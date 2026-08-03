Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F84BC55822
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A366B007B; Mon,  3 Aug 2026 14:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B096B0088; Mon,  3 Aug 2026 14:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4199E6B0093; Mon,  3 Aug 2026 14:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5146B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:02:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7993212078F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:02:21 +0000 (UTC)
X-FDA: 85060727682.26.AA4E1D2
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 886894000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:02:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SNX0Ptk0;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785780139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7ugPuUEH9pvtG4TP2Jg8TSGni8pM15A3IqbNFNhjS8=;
	b=iRvuAUVexDmuGwEnuRCmveklVH6rg7JVoiw99QZiCagpfTsx9SdaMJFaIOaOkNl49qbvJw
	iN1JtrWfYHk3xemQa4JeqJEgVzxShC3MleUQteTbSnC0+p6raPADz2/bgGGzlzgwmUlLnH
	lRKZwRjdBYntwRf+WMJVXLRw6cTOIwQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785780139;
	b=yQ/L1enI3UsJFmKGKDbT09XV6gq9k39sMZmEpfAJRXBumo5MGsEQE+GNfhp7Wytv/pcPPd
	gcBeGFqLHaM9ppQTVSQQFBzig6mjD41TIjM97cVpYynY1MxITIllY5Zj34MQZvARXWFFHa
	1ygpj978ab5djGiZgaAEqJzbKwRigLc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SNX0Ptk0;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c01c79467so28891cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 11:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785780138; cv=none;
        d=google.com; s=arc-20260327;
        b=TghbgF1Zg3djYMshv6cKb9Nd78DnL9IlurZ6bBaCXnJsLM8Hpz7yVPO5wFMeWngvsx
         4qqqGGPM/c79CXMi+dfTh1p50S633zC/Mt2tTe24oq8JzPZEb2F1NhdZ/+BYi/dsAZYe
         VPgyHCNx8ihgEP6BFOBzGGzVcpQ+LJ8R1mJ/0nBi0zjFYUrp5dM6UJRWMYjpFWfE6fH/
         TQb6SjDTPM17t/ERPfK3xO5qEj9gFyFRP+Eamqx/Pa4TiHlrBr2f9/Ioe94KVjqgixIJ
         dCK7rqGAAm9mHto70kxKH1MkB83sknOL40UnFnVHsFhD82ULZgLNEYba/PFTW/RdO4PF
         bFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z7ugPuUEH9pvtG4TP2Jg8TSGni8pM15A3IqbNFNhjS8=;
        fh=UA0b5xmD4QErA3bua1Lc25jgaRL8Nscko3amSC9EcqQ=;
        b=qrp8YBZ5xhkDGO1YlgsCSshVt6layXUAjONLNJdowAToZWiBtRUHeSY+oFXumf6VLt
         RjwDcBgCUpTzt/BpZ4YxUfAi82PWUiNOIpCSA/DiTQsHJ20mNS31rf/9oEXw+BgcleAc
         +8SMbqsGJyVt0tvzcLlcQAiCNOzyk1rDGzsd43QWdIseCOayuW4JLEcJSlQMZSqTcgsq
         xqBhL2+T4nQbY3cFWVPweJ+qzUGY/FgeJQ4WMG5TOHJ8+T5ouHTFpqddhDL7D9rg1Gdk
         upGSwAUbvRmb4YgR4ElAgg0DivgPJmQLpqTIcIpTk6+QpjYMNAwhLy0ZruVAV67Y/6nw
         a8lA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785780138; x=1786384938; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z7ugPuUEH9pvtG4TP2Jg8TSGni8pM15A3IqbNFNhjS8=;
        b=SNX0Ptk03x7gEevPNKzWL9XTHNNFgq37eMI6OANF3B+3FwKAQverHlg/yAk2KsSBUy
         IVIzzO5Fjhk7FytzviRIyyAHaaWQxG8ltIlz86nrmVaVaIrUi6917mebjzJm8xCr3hsO
         nOJHFYzZQmOdHYClCUGmlfm53pIDPzMurLmNp9OlZ05gjlBFO3P1VSKiEfdEjpDfbW2E
         q3dCF7chCsomFky6m/YNfechfDRUa00LFngim/uLUx6iTK6mD3pyQwTUU078yI9GQ2dm
         Rbx0JgZbcJzFiWM/a/jgN0nC3T9/qIOITpTauBZfAclo3G24bxhWbyVcj/bPtwCGzUi4
         +6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785780138; x=1786384938;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7ugPuUEH9pvtG4TP2Jg8TSGni8pM15A3IqbNFNhjS8=;
        b=W5XKTILfaa/OPt457dM+Db/fJFI+mdS1GoINYG5p6HVBLA/CYBmkn9RhgI5192Kasf
         tYAZOF0DEKu4TgQtClrleuYLs6C+yoV08QXuIOMPH36qofi+hKHxph7moDt4BuADB2T4
         2BtoIDZ+Tbsnl2XEsEfI46qxZWwLsKwaOyBpVI/i9ljPA2IlVS+1OzLqWOomPMiASSDC
         N5UPBRfYDWobhT0Ws0iJ0C+iRVwtTm3E74o717rahM5YW/SW/y3j+ERXC0T92Q+agU2z
         hNM5lzQbm6bXSgj2xxtuHcZ7EygF/19zH7OHDIhxU0LGrUyG3+G6DqPTnWLxoqHv7sy7
         CuWg==
X-Forwarded-Encrypted: i=1; AHgh+RqR0UI0+/3jzrkF6Z4PGPSr0NMfY6E4kYrX0S6HoibEiTXoRr0Zc3qJfMjjt+n+tIIHf0csKkTdJg==@kvack.org
X-Gm-Message-State: AOJu0YwQWM4yo5yPRHxLk+F/WZggG93rMMzlALPTKLYmInEvz92eDOJ7
	9DRZtKjmgJl0SUz85uj+br7nrs+QOGfgRlqnF6YKReWJHVXyQmEWzpWXLvsqLtQVv/J1YiTbNFw
	XW77xN0cswGe5jAPTc41DYBht1TDBELM+SKBIZ9/2
X-Gm-Gg: AR+sD11qRi/3sCpX/TTA4SKIzACkSN0CjeGF98v7FXVEbAFv27Og0/C1bsvTHbVqnuz
	2n8ipxTGRtiJ8t1N+JYTGLlM5o9+rjhIYjTYtSnQBhHI8SzMtQRv0Vnn3UPOZZa5kMT6YwDP5Wd
	nOTfwLELgcQjXYqGTo4dShsNCtA65auuV5BUMT78ZhpNtoGpOM9MqLddsX1qT+tW9ut/A3r9YGq
	P4SfnAfsRpBu5QY/pf+aFB7gMA+Pi3ztq7zPB6CFcuN50PfN5SkHE3CEdWlMxJlzX4W9S3h5qUq
	LquAAM5AL3fQWiU/TkKplSyRNDAMkR5JrRd/nRCQcBA=
X-Received: by 2002:a05:622a:98c:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-52cd4df7d70mr979371cf.8.1785780137924; Mon, 03 Aug 2026
 11:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-3-surenb@google.com>
 <anBj40CVAhcGMnQ4@google.com> <anByayBh6Ed2bXox@lucifer>
In-Reply-To: <anByayBh6Ed2bXox@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 11:02:06 -0700
X-Gm-Features: AUfX_mxKLrQh72gLoW3UHgMSLtVPwg93Wyi6kzNAycJjx9dt9DeuOOjvi3Gm980
Message-ID: <CAJuCfpFTqK0jkhm6FQ8Q7DrPG+VSeKufV4Wyny-a3bDi-7R-iw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 886894000B
X-Stat-Signature: 8zb5d5y5jsgb45x43y3ud5izid4bwwak
X-Rspam-User: 
X-HE-Tag: 1785780139-494197
X-HE-Meta: U2FsdGVkX1/YqO0EDJzV0lLnwscbiXWCi3zaFlOOtc25Lw0LLmxaPoz8x+E/ozvSEwjSDr9sGaSg0P/RRBGO5ys6uOXgTx1omhbDAN/UYzQBJTdFzs3xWmuew1aUY9xcgVzZTlkBJl1a8GVQP30sllb7ePiYRpH8YL+x0DKJJMXBHct9GL2aU+RwCa4Wgok6GlGeX2teOngNKKQyFbma2CqhY7e2LnsyGtEwr4bDkfwTJ72Gy20YHsLj/jIyQuq2lyA0ZIhcwZFvkxy2hjgEsATHx1AURh0wfhaJzAfbvy6XeFFJijSCo4mCMDvh1MkBRPe6VQzyLSnkioQnyhIRv3SSSj9hyzqJFvbUWD1EdSotnda/5wLyeqOopsg1lCogdzXZNeu9CmxdEwU3HlCeESV4mbxTZpT9yPFcjLCQjHiStSefvc+3G3CsQbNBVF7axsiABFRm0iqmc1ut8YdPcJEH6WlKu2QNCpMT78WQIegsKYczc0t2HJD7CFv8v5zWuXahOvT1nf9HVoOBzH3qG7BWHBbIGgPeqprNRlRef8X9QOhEw3XCI2AqUIgstMg/bCseipHt5vFaM4sREGzbIkutjh236e+Qkb9TaV3m8HZPEafCz2tlMy6oq3LNgd/eMzlsuhH2YhrohCmFbcTpiSRAUNVWD3iMwJTo8Qlgu94knyShaULZE/RIm3E1K95nzdXUBJBfCb6nP0Mm+Q8tK8zwdGwUrlzmD72dUuiwM1JljUlHByFWQU8XM6Ds9s1IyJyAtNTE7pNd0890IvMT1tm9+tNkd8nW35/jyJlNvJfVpSXWeLoav0bpS/h/TiFIB5knoI/DKR7CNxG+fat0VHbjFE8ToUyCQqJIup9lKV3pN5kqjoDtcMBK4vMYBTX92BQGreJmul1v0LQeuJVtOmkfNR0QMPPHB8lgC1KyC9cLKGRWNabOnzJC1xXG7hSBhcP7YacacI82xSLlMSo
 y0Xw9ij5
 GqjiKHHybRxNvq657hUDU6p5JdNYy2pbQroTkKsOlfw3D0FiUnM+WWnLn4JCx/fm/TswJyGh7N28sOVeFE7Dg6OgivuD4OAzmZALxQeRKUHheD+nZCDzzYImeA0wRk8S07LG5tSbTvdCR+R3hEfN+akSxEUDmPNp3UBw/49OeetJLndRmW/xA+wV0zisG8Zv7TujrNLuen+3ucRIQkl3mG/EcLOQypB4k7Myk0qj7OdexcN84D3v43W/3VT4Dz+RIGCCaH7tjpPKFyqJzG05Cm4eVV1p+iK6vlAbPK5bpVJUsU535//0+SjIzLRO3lSM0XqJoY7q1LemiISb+OdOWsBl0+3GrylaThX6eS9ZdXtxQkjnokDv7zdQRS+jMYg9WmMD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 3:50=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Mon, Aug 03, 2026 at 09:48:19AM +0000, Alice Ryhl wrote:
> > On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
> > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > >
> > > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > > it and mmap_read_trylock().
> > >
> > > Long Version:
> > >
> > > =3D=3D Background =3D=3D
> > >
> > > Historically, binder used an mmap_read_trylock() in its shrinker code=
.
> > > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > > support for the per-VMA lock, but left mmap_read_trylock() as a
> > > fallback.
> > >
> > > This was presumably because the per-VMA locking can fail for several
> > > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > > to mmap_read_trylock().
> > >
> > > =3D=3D Problem =3D=3D
> > >
> > > The fallback is not worth the complexity here. lock_vma_under_rcu() i=
s
> > > essentially already a non-blocking trylock. The main reason it fails
> > > is also the reason mmap_read_trylock() fails: something is holding
> > > mmap_write_lock().
> > >
> > > The only remedy for a collision with mmap_write_lock() is to wait,
> > > which this code can not do. So the "fallback" after
> > > lock_vma_under_rcu() failure is not really a fallback: it is really
> > > likely to just be retrying in vain. That retry in an of itself isn't
> > > horrible. But it adds complexity.
> > >
> > > =3D=3D Solution =3D=3D
> > >
> > > Now that per-VMA locks are universally available, lock_vma_under_rcu(=
)
> > > will not persistently fail. Rely on it alone and simplify the code.
> > >
> > > Full disclosure: I originally tried to do this with
> > > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > > trylock semantics. Claude caught this in a review and suggested the
> > > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > > I guess.
> > >
> > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
> Is there anything on the rust side that needs to be changed also?

No. I think the corresponding function is rust_shrink_free_page() and
it does not have mmap_fallback logic. IIUC, it just returns LRU_SKIP
on failure.

>
> --
> Cheers, Lorenzo

