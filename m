Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F22CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA876B008C; Wed, 17 Jun 2026 09:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B6E6B0095; Wed, 17 Jun 2026 09:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849926B009D; Wed, 17 Jun 2026 09:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 488E56B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:34:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE85F12041F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:34:00 +0000 (UTC)
X-FDA: 84889497840.03.A668893
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id C88B44000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:33:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BvQLITIX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781703238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtUpAbQflQwW1fqPQP+8XTY5Jcq0/q11dOYKCUiq0Rs=;
	b=ZJNEpwqnoNqV+NbgOxYM5RIKlfkA7dth3Ss6Pub6k1ejm5iaZzmKFUIgi7R2GIU8A89wMO
	0s+gwSd3G3mTGXpFNTTMWk13z4K213pW/d7aUX+1DeHaAOR6O6bfSgR11xblGUNSju0I28
	eQ1ACVg7c9+DGUgpJpYjnUuuyuLqlWI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BvQLITIX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781703238;
	b=6EVNg6EXVU73jXZ31qNnWHJkukjz/kw7DyhE82J/MDj+2T755mF2ZPkh2HDKXeg+GZMpdL
	EmMlWTGY26yRKtw9/OHLcChJHG+tMjEMePhwvKkuZ+RmZHcX0zLjXqppUsOaWDkaRFb/mk
	/cGPxI5vySK4SuBxpPpNLJ1IMarI8QE=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51765331535so239071cf.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781703238; cv=none;
        d=google.com; s=arc-20240605;
        b=eVFjA+9lvMi2X7Qh2x/ohKsWLZ5BVg4ALLKKyirqzoZ+jtLJbPxLhljmeou+LOCgxd
         IZ23q1m+TgdPi1KW/p8aOt+4ja6UBw3aghO+8TOYsSdf1FueepOYT9f6t4aTkjuaXw2H
         +z0repXlgd/pzGqNwR2GfL1QkZvldjz6x2cHys88s1Mu+k3hJ9x7hLIDhH3nl+3IydhE
         7MRnxWUyGN/je1vBmg3pSpjX9v1gNJbIlGFIcRD1xEc56q4lskRj5WHWNMYsSfEO+Ajb
         EbOvVLGj29KsMzU7jB3aU/BNNPIn8zj2uKZdpWj+vwlAsBCBw7DMKXZP++rJgEFblijg
         DzTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OtUpAbQflQwW1fqPQP+8XTY5Jcq0/q11dOYKCUiq0Rs=;
        fh=v5B5RVkvysGHQn79AP4ho+XYhCwyTN6chn5dv5C+iDo=;
        b=b6MCFbm2ZA0iNPTyLl5QZp0+zzuUiJczDcv0PF3EJP/QLicQTxJkoeN2DsLRive+ta
         5C3oE8w8RumJ6coHC2y2Hf2Hbr8lxEkQox43tNpxTlsndb/7tfaSXauaAmJqm912a96u
         P4r7449gUeJgBTX7EMBtWqQOhWLmXm4d58C0A/zK/miw7VL4IWN2Z9FxtNTGjgTdwZRC
         upxLrXfF9t8XpAxvtCoprtXRlwteZWM3LDuSBiCif1xQTd3XAZI9XrAw12JOrSK9NKGo
         vT9lvDq0HhdQ+YJtmdbG1AhFhMQzKIf83CO5G6W6eWUOVK9s6U+bSBT9nsOZsu4e+BRO
         97Xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781703238; x=1782308038; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OtUpAbQflQwW1fqPQP+8XTY5Jcq0/q11dOYKCUiq0Rs=;
        b=BvQLITIXB4uqnt2GIW8sI7+vsyD0TzRLCRNELLfj7zh4UsjudhtBWk9vg69zucjmyU
         hsI4qjqr6g/6akrQog14XSiphs7xJ38CI71CkMANX0zo1qXoOT+WOrwHSjCO+KwLVQaJ
         cAElOSkWkj55G7yemudWS7ZNXfj5hLfnoBerKlViGujOkPB370WQMWMNydctb017RCGH
         /EbkxBGacabaK+osZlvEYMfR7BSHMOzbnjEDBOhCQTppvniKbF53EQ9bQTR5OmX6hVbi
         +2r0BpHMdJ94GoMjv8JM9KsTiekYmKp7Zm6HMyK/nZClN6qAepKexx3bhSgJT3N3BbRN
         MS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781703238; x=1782308038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OtUpAbQflQwW1fqPQP+8XTY5Jcq0/q11dOYKCUiq0Rs=;
        b=V7IimMtyLgvkYzjcPV+vcQQezz5J5F5PB6lld7mtgUTEFq1zGLIqqMUVwVV+9gSKoa
         EQS0UGF9wY/RNIRb6UWtcI4Na549RBxZ4cMRSWF439oQF9nvjMDuHkttzPGc0UkvFNHD
         F6OxZpZmaYoNE9R7QxjylJTbMnjp7mGgRMWWfsStzlog6oleBjoLshVqmgNQPRBSvEYe
         JPMJF/IZQnpQ+UcDa5Hk5pYj2F+7tWTPPsjqxs1G8c6Uj361zKmrDSkc3zxQQZSyoq+M
         Zscv5JQlT2f8KKvtusEURvXqtBzBtDsR6/fbCddVT7Lj8qKqQfdGqAkdSesDpCCADK+A
         UduQ==
X-Forwarded-Encrypted: i=1; AFNElJ9iN3WXWdCVbwJxLE3nfYG2ROwdmhTNsR1f5cOQXkK0Bcigi/9UaUYg8wffAGr+BNFd7ItaEjTWIQ==@kvack.org
X-Gm-Message-State: AOJu0Yxh0wMVZ7WleyFBB2buEoY0d0u8+LDXOC1G7M6ToNGr/nb2GkTT
	tYw3GZ5lfak15v+gm848/8PH5dqdfDRJVYpBnWOLJAB7lgJk7CPbd7TIUDgssZYbVhI2otbsAPn
	YIuyKjG3h9AJ7YFlNUNILNp2Y8rL4C1lbXoRQ7PhE
X-Gm-Gg: Acq92OFzUfIL/s7oH/vrg+XJZCvNLqASjwXi05HZ73n3Fm1IVG1ebcSHPFLA3NjnOke
	yQAz+Jcmh5CCdVoXnG0XXkFbC42xAV79zpxqpnOPuQRb7VDd4dm3WKdL5tPUcHpBy/5ekfuLJrQ
	Qi7D9ClovRyzzBR6gLaFth+nC80vslA6FZe5Dqd7+kG/1cW2lGT+2UDskyFNFzNI4E1nEEVpyem
	rllPkF0rsiXOXx3cIC7c4kiv1V6iMe3btRMXoj/yGyJYK7p6yY6DgKEPjaxP1gqcG0V21c=
X-Received: by 2002:a05:622a:4d9b:b0:514:b17e:86f3 with SMTP id
 d75a77b69052e-519aab877d9mr10070301cf.12.1781703237254; Wed, 17 Jun 2026
 06:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260616190300.1509639-1-riel@surriel.com> <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
 <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org>
In-Reply-To: <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 06:33:46 -0700
X-Gm-Features: AVVi8Cd4JMUTRfCCPW9ytB872W08v0kJo8SfL9N8ZS3ItG28TXCLPKx5kVJSysw
Message-ID: <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C88B44000B
X-Stat-Signature: sxdndwkbfp9i1znb9bnxffudjwbs7a7w
X-HE-Tag: 1781703238-264423
X-HE-Meta: U2FsdGVkX1+5Ghwz433QEfVNCa5CcHQcYADwgtnDXhroJ4Ivc5B6hTKD+Ua9u7VWv+mthM9Jeqhp2decFkfpUVWed/jo6DzdAkkp2WK5CDADi2B+gC/ing0h+Sc326ZGViSnEAFKcsUSGwNxKC25SfruZYQXDxBBd2tG/N1ARdprtcxtVieTLWr77BauJAD9PTmsIo3TFUoTbZgPVVkb1u0srxaKcvf/tgbINgZlP3zdMKh1eY+bQybpHTPR3dZ1VKB+2OsYp6lEKc1vWWnSVSDhU4U4yCFjHyc9kRdZhdgZ3ImC7850ZSUyw6nTYiyIsVgCFmO1M8TFuGPPc8Zdo3xA3RijlH0wlRjZ5m9l8YFqDUEnEQvmWgwOW0QW0NR/Ta4EwHFdNiKfg19qoz4cfS2E3eiaqEoXgpX/bkZnj5liHrvB7pu4a9sct4QT8UJA2jOA7g26dkW4iZzmaMeO1U+fj47GRywTL4xxWCvo5bejd8eFIMOqdKwweTB8Aa5PdzhiPs1ejINxdQWZNPzQ2vc2x19GA0fMqwxfaI3KjoB33rLJdFfvQeQjPiA/xzZ/LLNguxX3J46ycN+7Fy4rJgxLp/05BsQn6eTMyCG6hsYsQGrvyeCRefRKmP2XdaG0/uZPCNALYVtPDx8WP/h5z7TLXcMxApARZUaZoOhEglhdtQp3spuHfnTNHaXr5b8apFCAZD9l8+IZl7F2Pvgy2aZZIHrxElwKK6150or18G/eQ9wu0fbwtjn01Do2Pzbnp/tjnxGddcVfEi7cfD2UpSUIxVULksSkeDW+S4E7kZua9kMLM8l8sB6jCwX5k9ux5sJM13a52WPhsty8K4GdsCBj+ndRdYdkV9LYf0KZj01BMtc/A6PL1lpbPfO53cWZFLMB6p4Z6XrY6tMEQPxrTMHVMhbHgTD/JGgI2/Ktr1gzrHsoh1R2amMubXwtiUhWH7zCifSKBWX0z2tziuI
 IqWTHyQJ
 63COI7nNNuHz2+O3rfI+6HhqGB1SQwNFjIEQJWy+7y0z8e6TrL8VBefznGKSoqizy4SKFVIESpNocYAzrRSLNWkVc3oodzPT7bC/9o6zMSjIGDuOF/ZNpmCSnqDw5eqyLUosAMUbkQHE690EbQ8WIWRmIpmsaI/lxJldIhYE10YAwveXTZkM2tqzKMkQRwPpJ30wxXhh7sB98uNKX/JDqGQkaigRiR5/0sdvwCPvSMIzdVsAcBBTjva8mnkAGwoeKi8D9G27iKahYMnif//hW35sLekrZ0CGN4pD8CBOfCEiczz1zcpFJ4QluQDNT4Q+tGmJ0XASC9qH1TyoavOTojbPa0JTEJJuJ1u2j15YCVjK/b71wPIfAM0n+ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 2:42=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/17/26 03:10, Suren Baghdasaryan wrote:
> > On Tue, Jun 16, 2026 at 12:04=E2=80=AFPM Rik van Riel <riel@surriel.com=
> wrote:
> >>
> >> Sometimes processes can get stuck with the mmap_lock held for
> >> a long time. This slows down, and can even prevent system monitoring
> >> tools from assessing and logging the situation, because they themselve=
s
> >> end up getting stuck on the mmap_lock.
> >>
> >> However, with the introduction of per-VMA locks, we can improve the
> >> reliability of system monitoring, and generally speed up __access_remo=
te_vm
> >> under mmap_loc contention, by adding a fast path that does not require
> >> the process-wide mmap_lock.
> >>
> >> This fast path is only compiled in and used when it is safe to do so,
> >> meaning a kernel with per-VMA locks, RCU pgae table freeing, the VMA
> >> is not hugetlbfs, iomap, pfnmap, etc...
> >>
> >> The code seems to work, but could still use some more cleaning up
> >> and benchmarking.
> >
> > Thanks for the patchset Rik!
> > Previously when I looked into using per-VMA locks in
> > access_remote_vm(), the biggest hurdle was get_user_pages_remote(),
> > which required mmap_lock. Your implementation avoids altogether and
> > keeps the code much simpler than what I expected.
>
> But, wouldn't we, in general, also want to teach GUP to just work with pe=
r-VMA
> locks?

Matthew suggested using gup_fast in access_remote_vm before, and I
looked into that. The biggest issue there is that gup_fast assumes it
always operates on current->mm, not on the remote one. Reworking that
is quite an undertaking.
Teaching GUP in general to work with per-VMA locks I think would also
be much harder than what this patchset does and would require a GUP
expert (which I am unfortunately not).

>
> --
> Cheers,
>
> David

