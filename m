Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C96CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261786B00A2; Wed, 17 Jun 2026 11:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA786B00A5; Wed, 17 Jun 2026 11:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B936B00A6; Wed, 17 Jun 2026 11:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D173F6B00A2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:16:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FBCC8DDE3
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:10:56 +0000 (UTC)
X-FDA: 84889742112.30.6E95DE9
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 20B7340015
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:10:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nxaISuCI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781709054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gryElRlaESvdlunLHhbnDO0S8K7V3X495hJBbeeGh9U=;
	b=Ro/neUc1QZ2VaiXwN4xhsBoGHi03yr9ffyeJ4Iy7mc1UP2Jbvd3UXzoWcq5tmSDrruha3A
	CdnMQzoI0NVEJJBGEMbaKaGnLCdEFd9H5bSTFYpQFbHSrhzYUP/YZC51SZuDhTRxgGgWUS
	JJLG8XBvCslQpth6wJnWZ8i8gytwsYQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nxaISuCI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781709054;
	b=6s1WxiD8o9Z+gKV1J49b0WeZVAESc4KpBq+mveCzEqQYFGAK7kyYD8eBlkq0IWF8Rlawz4
	j7nwIx2t2TOG26usqpcgDGLAabzgmKS9KbXlYrMJXfgEMtoSoZGszW/zPKilP5sm6bk49i
	Q4y1nszoDUBsn5yKsGGuHgGUZh0nEUM=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5175d339e8bso294811cf.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:10:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781709053; cv=none;
        d=google.com; s=arc-20240605;
        b=bOT3s83ehdq+7bAkw8MERy7MdlO52q6mMAT8v+L6CsmI0o/nKBG7ZqHjKTLIthG5Ch
         BiJQGGl0Tq/QapizAyDO4b1g+FOqchuL0hswYO2wCNlm0jfUG8oIg1Qwa6VGNHUUe1bA
         sEm/ATq4whVkVtDe6yW5QdGyu/7mOiV4E2SO7LrlHuh1iLEg+dfs429hzC4ovnLe9n4H
         fXD6NgIqnAkwOKuS1LBUz4jcqMhhme+XmnZsI7duoDGxbxlYuntie4dszd85sjdMiRRZ
         OaW9Lv8i1B9mMjf9WXw63/9ReWpCawh8QfzolH4nDToJNAy1dYxuIvx0Psp89dnnD0Pd
         biOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gryElRlaESvdlunLHhbnDO0S8K7V3X495hJBbeeGh9U=;
        fh=5MqnTiXTzorcyZKVQcK0G6AuXtl3wiTXhdnnlIubSwI=;
        b=GFN3kMr8oBL2cxbqvBQZ6bKhAe97/vycHLXwjNoTAvk0shHbbm7oS24oNHimBru7OH
         +DUryZAvd/LQrOaybseQWCLDZNwkeU9QciT6TFYk2c5PEqEDs42e/FvQ3MbuT/obbJbY
         gtpWnieMkaWzq5npysauLyvswMuXQJphYm0Xtb/Kuear+GFmQoeveKSzChP2VeuELITa
         vzhg1m/4ySXPJwEaMZIaMMZ7WOwPNKFHEm5vHgt0Rc52hBv1l0MU2LjqaCaQ1ySUmZMA
         LY/2W16iClOle7W9VC5HIuZtbSOuG/h0a/3JEuVHMud8qq4QLo33D73gDNTygEqBJkew
         KhDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781709053; x=1782313853; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gryElRlaESvdlunLHhbnDO0S8K7V3X495hJBbeeGh9U=;
        b=nxaISuCIWrOcWABlcs0yVeY9KvwIUExAr6R4yZwsZsevjxSKyu2BPgfnjv5xZ6PsK5
         eDfUn859/PdVjo14/AXe9A7bCBcCL6EgD1hHApnM/MW/TXjyvWEq/bVuFzXGEuTw4ks/
         s34Htp9ofBeOb7GhWUXgDHC33PTWQmtXP1aTMDIPvHKNWksC/B/1xMZ1bPemfnBbcgxM
         2Otp0fI1668swNng0eGDN5UVP49emnPyqJvjzDoM9jM2YY5K3Bwes64EvFzXlU3hkXbM
         9U9Xkc0IRFLnSeNEXsrs6vY8xBi2fYXUpNqU/98gPQDnybHBeGuz5QWWWknbpVLOdvoW
         dJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781709053; x=1782313853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gryElRlaESvdlunLHhbnDO0S8K7V3X495hJBbeeGh9U=;
        b=JiHSD+D7WIWbSrZK4+S5n2FelBqvhyzBrya4P+Ub3bKrNVniKD7bygjmoBJzBLpM8A
         aYNOZ7CCBvDH6rN579ADNGqdV1IIFoY83pmLihonuNqkAZpVS1Cs9ec34W0jjjDsajN4
         RqpeNbEJ9SAM/APBvm4UPipVclTpmH/OWxjTEOrY3CyquskWjRcq0JtXv2U2c4Cm/M/D
         aybtt3uV8w0KdwDVp7kl22G4yx4cZaJdbKaf63BZUJuIFKaoX1WHi0XEF4gr/3XXRhn7
         iVloV6aa9ZQXAcNJ37t4Ee0cMpCNn6pmuwnC6W3K+PUfwVXEHGosNNITleYA98JtZT6Z
         Ywzg==
X-Forwarded-Encrypted: i=1; AFNElJ8gcQc5+bCmSEtZN0l3qd7hFyws1Z9BdeOPDh6d4YJPEx7uH8MI3JFQDVrHohsMnhHIz4utYtmUUg==@kvack.org
X-Gm-Message-State: AOJu0YzCKsiY2E73ij8vRZom9LyrfQI4PiHJ77CHqjPQoNHyLqfp+46X
	ZEje+gGN3WyVchS+gjqpayJloVOxcjoNY8TRrFVBrwuhf/vyksWJRc69WhnBmIDp3HBO5SP8l6J
	/VUI37Vow3/pxTgcpvysjU5vefTwsv22XctoDdsXD
X-Gm-Gg: Acq92OHyPW+YBRfxFGqsmnkLfFpCqibNs1YIlWsDMMPRpsykuc0NvpVAna3D2C9m1+r
	uz5iv5pEjrzDZ3GLk/Wf9HjiqgkzONmnEnMuPifkITf78Lm/R5Zjny0cV68PN74xcG2lyJ1CPf/
	fY4DMpiLE0lxVnmvKLH+GDrpKybZELXVt7zINQoxrWOOAnncXqIIXtNoy//kp11xvaegEUjIAj6
	Ml8Q5Rq2ygIKPQkF55gLJocORV2/nqedwqqidrZ/XqusJOZdHCejLeKv2gX0g3kGLQq68rzp9mi
	JCOX75uH2LRGkSbbVvZqH4BAFjM=
X-Received: by 2002:a05:622a:4d9b:b0:514:b17e:86f3 with SMTP id
 d75a77b69052e-519aab877d9mr10980831cf.12.1781709052609; Wed, 17 Jun 2026
 08:10:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-15-ce1146d140fb@kernel.org> <918fae64-1323-46ea-a86e-3c847a52f174@kernel.org>
In-Reply-To: <918fae64-1323-46ea-a86e-3c847a52f174@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 08:10:40 -0700
X-Gm-Features: AVVi8CecK8kUk7k580xJVGlwOxJX_MOMS1WZV6CQSJDW2f1pPxADvDgMBq8GS-Y
Message-ID: <CAJuCfpGXf-DLFTnV3T-o-9COo51EFg2MV8M0QbZEoJBCKNwoCw@mail.gmail.com>
Subject: Re: [PATCH v3 15/15] mm/slab: replace __GFP_NO_OBJ_EXT with
 SLAB_ALLOC_NO_RECURSE for sheaves
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4izhjjfnb3t4dtt3187dyye393t3cbse
X-Rspamd-Queue-Id: 20B7340015
X-HE-Tag: 1781709053-189446
X-HE-Meta: U2FsdGVkX19lJrfU8km9GSzrL2ekPXU+aqHaJpOw+0VNbro0sIs9PuXCWLR/jlPajllHYV7awws89DYgRG/zLK4l/v/98hrXbNUR5A0z4Z39uNyDiA3q4OkSjTQmSyQh0YVa1DUQKYkHFxzQiqJqOxacO5c/ZtYVM48sdDdHMcm4lkITLEzVIofmQPNrf1Lc+XkV9JKHOl3L61vds7/jgzvLwg6vJG3n9arMBk0uWeVanAcUTwW3h1dmN9KMyuwxoPUbG4cWuHDWpMgs1tkp5WHVTQG9b8EltLzf55BMRDaXmaxElgzCESir8QL7bc3GvlpjXpbyGsxOZskiWVxKVAS1Gweb8AmqhB3KoVH04xHEoBNThpI6NKhU7CZAgSC5/QsMdbUFONQayj6eoGO4/8v7MRVWm0whPdbsu8dWw+qASjQcbjvuOb5VbtLR9cgcJepC4LeLiIDufMfHO6XS1d4nSHscUxC84VMsliLwx3JwpBUvOIj/OlJUW7Jv0QjL3hOd9M5ELEkxBntmxakJ1sYgqhCQasTYg+/8nxHgMKJXB6KFaPe3kqye6OEJHx0oF1A3hIrvhIibaGojJVq9raatlYwvUIt5TTYN0763Y8yJqXwXjwkw5t83O8rNWxHEUY4QRqGtRBVXfLm5D8F4yLgZUNnAIhxAw+gBPpTIM4VTAbgqFAek0yInh0/qxyTX9SBhzn5AOlNK1p0JDGg0hXB//tqwWDcMXuNdeCOTug8CGOjABz9ynnci+ZnM9/TUjq8P/w/3udkguszvBJLW6hK7+BFLsnqhFzrplrs7Abp0VGBG7VcYNriqoza0D+zikWgKxmRJfy8XENVXP0abbVz4WGYPvB99cilRGB17Nz9Vrvdp5vUuJCIIIrXlfqjp+Fl6JDB9VVXlC6bHJro9FrQYtQHujWZL1M1ShrYKE9wKKhS/JyfZ9BLTIkwp+q0JAOQprLbC3AbxSmvwPpG
 neHfOMe4
 kYToK3haTlH4/KHNBez1iK/5NtWtTYXsRB9OrFBMSWXsnfA+ItfKnkeZLetIhCpIVn7hiatz2ZhrpCls/tcno2AlSX5026giuzS0BeS34XSLJUuAbtHQpkmc2zeXVGhdGbpUu3Gfw/6bBIDFb5ELARLnR76qLtuG2oDvPyjmI6I/KFEfAqH4pR5CFmZTreUSw7F1dxo9WbT0sNGJRUMeRnynPT7bWarFSK2eErfZS423kBbpboS37yyS+4nh+DRq5AgGX0Di+GcSn/3HlAbf9OjqhxJcKt+4+zFRnXZ7yQ0MZ8/WxxqeDS8TP/fB0aVBg45cuI56tS2B4+NkKeu0bCmSAKxY4C9NulaXe3jMqxQNZnUGALfxjl0lfWUULVkezZOWlrVBO7lko23ArOF+kpjo9pDuJ7/1Y1kJQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 7:37=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> > Finish the switch away from __GFP_NO_OBJ_EXT by replacing it with
> > SLAB_ALLOC_NO_RECURSE when allocating empty sheaves. Pass alloc_flags t=
o
> > [__]alloc_empty_sheaf(). Callers that can't be part of a recursive
> > kmalloc() chain simply pass SLAB_ALLOC_DEFAULT. Use kmalloc_flags()
> > instead of kzalloc() for allocating the sheaf.
> >
> > With that we can finalize the removal the __GFP_NO_OBJ_EXT handling fro=
m
> > obj_ext allocations as well, leaving only SLAB_ALLOC_NO_RECURSE in
> > place.
> >
> > This leaves __GFP_NO_OBJ_EXT with no users in slab, so stop allowing th=
e
> > flag in kmalloc_nolock().
> >
> > Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-16-7190909d=
b118@kernel.org
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Cheers,
> Harry / Hyeonggon

