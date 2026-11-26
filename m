Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18E0606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lWN8uz1q
Received: by kanga.kvack.org (Postfix)
	id C91A86B05B0; Thu, 26 Nov 2026 15:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1AA26B05B1; Thu, 26 Nov 2026 15:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA2C6B05B2; Thu, 26 Nov 2026 15:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 301486B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:00:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACECA16037B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:00:04 +0000 (UTC)
X-FDA: 85478336328.29.F3712D3
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id B96FF4000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:00:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lWN8uz1q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795723202;
	b=w0EbNelyd51vAEtmYvHFsRz1LYSyWUyY3Sx8zQCB6m+DaL+7RAzXcs1eK7JMfWQrDouyxZ
	d7+IAHqtLs0ojZgnbRAtBpBKbdKPXp+FfeHgX8TVbrC6ktuRfbPmFMwN78c7fJw9MZ30wb
	3w4OFuQV4StA11pxX+ynU0mOffzFkh8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795723202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUQmLAInkGKTLacIVSVGPlTbjIhBu2Q0Jnfx3pxNGHE=;
	b=L+bSdu3ueOIOljH+OgYuRn4H6ZhPV9xhfT2YW8zxozGGaYiW9I9VIivCJ0kXsJMIhzSGXI
	ZbSDdYlrDqIqYHmLSN8v5xBnCKmHJidk4Q7HWYu6O0sSOldxzU+sNiEF7TQZivSiwfhyWK
	splCo9jP+pZ+3aLKs9uZVPLqwURwiNM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lWN8uz1q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso9938196c88.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:00:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795723201; cv=none;
        d=google.com; s=arc-20260327;
        b=cw7/zbONDsZ+DUBsSdK+q8RTdIxdyqfZt7HD+Iuw6llPgjgTfyDuRQKMthhw/tJEjU
         uMG7x/QJ4FosvoaV8NBleGYnE5KPs/NY6u5sBkBhWUWuzHGBn/y3ubSFcPGN/jxnMsnm
         e7QhReMtNLLmV3iriaDes/OKuRxLrZp1Ws2Ie87QO1jtoyS0OhxWf5Xx0aP2a6JP9OyU
         wMH99wBpj/H4UJrXlfltLZ5bULawuSjrZMw03XgARL53iyp7IayBnJzMlH6kXikhCYKW
         KgjYtr3efe104HtAXg6Go+A32WxR55q5OJKu2lNr+N7Vw9d15Y0jHNDbDhDooy3vxguB
         3BrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QUQmLAInkGKTLacIVSVGPlTbjIhBu2Q0Jnfx3pxNGHE=;
        fh=h+Eq8+eqmmW8cdebvMwYYaCxjmbdXTgCcbjrm4i/I4Q=;
        b=CQ3/RtvFLB7gpe84aeG3vO2NpBqbL38Yhs2V8SaBOGvuur1EtImf8C/Eiz8sKMcr8Y
         ZHPI8ccZtddx8mUQ74McAjNxB2Xct0VlDsl7lAlGyJnamr9Yb7/kTpsXo0OjPulCnouI
         ujAyJR5e+1mNJE+sojM4uDFTLUqS8TaPX6m+yOkkYlR2qPULwOo2pn/5+RCw0Q+8uj4O
         z0/PtIIzgAv7hBQncPBrfn4sEvOWq2tbCI8+b2il22cFVSlN7/Q0o0iQOnV7gREgV2ET
         l18k5pXXJ7Sch5rdq9upeOgqhyAy7uANNtzTibZeCM0tyCHEV5jdQGfKrDCbYRYe6ZaJ
         2uJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795723201; x=1796328001; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QUQmLAInkGKTLacIVSVGPlTbjIhBu2Q0Jnfx3pxNGHE=;
        b=lWN8uz1qIlt/zVUEwDefzH6rQMSt8K7cjnnclAQWt3jUOW7RwpxpC5Bsl3Vb/VQXFj
         iyMItJ0pe4Mwznr6M4WB/BY4OcSMY15iu2JmzqIs4/R4aoR0XIPXicwE02/t8VedrpIa
         QNy/J5Vwn3u77jPZRi1x+IUoJRjIXV8G7BQravSCKNZ1SQzTSDDZEiL6gvvPBbCEH9nC
         Uqe0rzRDyZKfPHEuoolML2pV8Y5TllIxDPmlV+g7Smc9LsqQuo3m7xNfcDOdAMsbwNiz
         v3+3hoaKjGmZBxooK+YQTOOHUqkIjMAp4xi2nvpopLrt/bUqn8TnBCCvuCc2MmkbZ+yT
         7rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723201; x=1796328001;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QUQmLAInkGKTLacIVSVGPlTbjIhBu2Q0Jnfx3pxNGHE=;
        b=qmU7TRvw6byihdnV28GjbRM0nPsSt4H1t3FAoWObvKg9Y7OyMCY4WrZzQCNoiSwyL2
         +g9qwJ+HCVWHv5HFoTCjU6R7I9RWh52QRMBvxHsidWKw9ejxB2A00I+NX67Gnm/qsxys
         p1SakBu//6DnqBJawkLL+3CSuRdz433UIgYIxJstk1vQbndOM2pLq8ul6WpxthuC+xX0
         IxfmzcF9eqApu+pA3ZU6EvXEDIpHci8wXiCSmBNDOLFANzFWRsHwTH7DZNK2ckqCP00n
         Q5qBVI+4FV9fpiXUmoVmJNi9cr8lPQ78X/9iUVbyBMocREpTlm9TnK6/jhF3h+gNzKon
         dAFQ==
X-Forwarded-Encrypted: i=1; AL+hErHvWjm/dB94eMQ703tWyzZvw4mZwchuIIhy5pzLrcJqnR2lXZlNYYiaWUXgrNq7ZdyYechxRbqq8A==@kvack.org
X-Gm-Message-State: APuU4Z8JmDem6vgFaQIvRlfFh1A5I1XclME8a4mHx6dnMGihK16f9onD
	wRFgquzf+kqpHArb7mb0u/Rqpdv+yG/rLML6wx0UdAnkktIWvMuAppwYkyEplPWxWNqsBWzujQq
	bfHLebFToPW/GZBXur6q0Gzv+eyMGZGSvJpuM6nfB
X-Gm-Gg: AZFdTZfXs7NdC0nbwRl3RKiJGugeUIrFG4J32UFf83Y/K3wexW5wWznyBZ+T6P6Gev0
	Yn97xsfLfvcfS8binY2sgBdd7yaiT/PubCqtpJ1P9L54QeZrw0/jOK4MRkvP3gBvQBAu7QQagAt
	uDH3eIc44WJze78XbhyJYpX5nbav8wGsA0UsOGOcGYn0C6sSzHlV1IY8CQvw+vAJxWyEqczLOaO
	5FIWp6ZyK20RSbUmQBgbbe7Hay9EnBiGs3+6oupHtihuRIyY/oeFka652LfNwOui/TBoDriQwDj
	qAHOkxb5Cbn1z7RhYin213y6nD+CdJG2IkeZWjJKN/H8HfYUwfsmI3mKC06tZyj4sPZVRiDuWrO
	xtFfS4geKiqvi7g/p7r7TDwLL39RSJjsdUR1GM7hWv8N0EWq58RDmKCm7uIUDhsJa/LKo
X-Received: by 2002:a05:701b:260e:b0:1a7:e1c6:6f33 with SMTP id
 a92af1059eb24-1b5568d3ca9mr22040002c88.30.1795723200649; Thu, 26 Nov 2026
 12:00:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
 <20261124-kmalloc-entry-rework-v1-2-37b1631a67b5@kernel.org>
 <awg-2hrOmY5U3vzS@thinkstation> <4cb6e0ea-5e6c-4ecd-b673-70b42864c694@kernel.org>
In-Reply-To: <4cb6e0ea-5e6c-4ecd-b673-70b42864c694@kernel.org>
From: Marco Elver <elver@google.com>
Date: Thu, 26 Nov 2026 20:59:23 +0100
X-Gm-Features: Aa3M54qIRTbwIcF7QF1KtF_Buuyhe7XJlsbw6zNTzNtYRjONQTndd6cep3utZfE
Message-ID: <CANpmjNM8K=2qGb2qWGj-AnuGSRbT5KwPdu9z6e5i2JfH8_+7kg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/slab: add own entry points for kmem_buckets_alloc()
 family
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B96FF4000F
X-Stat-Signature: 1jj4gxxo5d8f4thzagtpfn6rfp75mm45
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795723202-611926
X-HE-Meta: U2FsdGVkX1/wM85pRQRT6d2PEAEDWf4/ACpK5pu31Uxv/dMnwCD+FvbKDjsAN+WbgH8zqkcvzmgDBN8GHlbBMap0baJN3vyeByMvk9zYu3MDiOjG8+IZKuuKY+Qr7LbxDCJb7gX/XTu0qfs4zRyVS1BLRe4FeFfx6g34Oa5knaftF9Rvgzlq2pY4tLcWI+0lUXizLZx/B+7TtrNysjas4NeVxEbUNQM3ERRV2/JNZI4bcWRzyfbGkeWP9DtwVOq0OAWc1LQftjyiwFfFIxhXaAeW7ZUG/E3C97xqOrctvoc63x2K5d9fH/rpAnd6MJgXF/xAMh5rpgpcPsG8Tb2vVrrD/VTY5up8dryJKTFPUcBc+tAZQX1cLf8vBmYlK3WOAm74YCgJc/HKGeUIK2zUM/nLhDuwRcGOk4+4CSzF8etda9n2aO2rVMxJVEsf60CN/djBH4+h8XHtw++oRp3en/9rmilVppHrQyzSJFiyF95RpNuaQyFMZ0kTviUdkGIDB5POzdGCEb6UR+Zqxl6hRQ3srupiphZxwF4Q/1tRtRvxRwOGSpxgrDCLtUreAeQBy/RvK2C5ltZ6WYP/o0zImRM8ZyZT2uj/xGuHcLx04ND/MVDYUep4BQNlW3DkKD2RSBvx8Qr/7h4jp0APk4ObNDqs12ue4vhYMLYnY+JLwCWWhw0d1+aaM3PUlqlc6X6Y+Cr/5Suh6lGKzIYiMG649zK+WKrSzv8+4CK06KTeeeC98fpS8ftMiInr1BjWytxmXE9CQs+Yzs9/5UtF5LIJtsWNt2663KV95E8y6laX2YIZvI8hWcn/gOKbp/qZ0lT677UzEhO7pNUVXwNSWZlakzlc8XrOYgXbIFi243qlRRriPHZsm2W18QTkiYpTnHLKH3qLY+3KEI0T7Be4zPLxuQK532mq5MJwQEifdGAiO0xTvsImj4EjQ20aZQ4cXL9pQUtNt8Qjn39tJ9mqShY
 izBLzUo9
 OODhKpPgHCO5KcAyHhmMnP9nCH/wl0F15ZlhpdhMCYu/jo4YE6870gkNzRrZUZV20vJ5e1QvFn41y36HYjtsmCdeegZkFfMOQ/Ts7wSkyg+0EH2j241YCGVhhKyvPovMp+1h+IWIiCiuyf5K3/JCIXx2Xd+531CCj2sBYln5wHqTN/26Pox9JeTk+BTiAeVtUzD/OGmWZlVh7obmfV3yBpjORl554Jxn0nManLiVXJAlthwlqrPEL5OKgm2Ji84ZqM8h/lOEJCnoe72aZL3CnnnG7tUnYpxHcM465tbdvrG9yRjqf+ItJjaAnBKtDeDr0+5w/lSyHEIOYVb40ccFdOxctNed5fTW8ILfn4spqBrB0ZUIpjn5KLN1ib/Ppdi3Howv0fcFl3pDCYbN72LX1CHVpwjxSc5+vSMj2FG74Pdk8kq+Iz8VrjrhxA/S1FPyI5cjzl167H5NdFM0peq/A3KZDN56QLFi5Zks2029q7fw4TsS7RF7f8fWdESGiL/MMPM0x1XRiATJ0TZtLeSjLOzLxxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 at 20:04, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>
> On 11/26/26 15:22, Harry Yoo wrote:
> > On Tue, Nov 24, 2026 at 05:30:03PM +0100, Vlastimil Babka (SUSE) wrote:
> >> The way buckets have been implemented was to extend
> >> __kmalloc_node_noprof() and two more functions with the kmem_buckets
> >> pointer parameter, which means all kmalloc_node() callers now have to
> >> pass NULL. To avoid this extra parameter with CONFIG_SLAB_BUCKETS=n,
> >> we added macros for parameter declaring and passing.
> >>
> >> This can be avoided by creating own entry points for kmem_buckets
> >> allocations and not using the kmalloc ones. They all end up performing
> >> __do_kmalloc_node() internally.
> >>
> >> Since it's just 3 functions with few callers, do not try to do anything
> >> special to eliminate code with CONFIG_SLAB_BUCKETS=n. Only make sure the
> >> bucket parameter is changed to NULL in that case because it would be
> >> ZERO_SIZE_PTR otherwise.
> >>
> >> The removal of the now-unnecessary parameter macros is done separately
> >> next.
> >>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  include/linux/slab.h |  16 +++++++--
> >>  mm/slub.c            | 100 +++++++++++++++++++++++++++++++++++++++++----------
> >>  2 files changed, 94 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 70df0a2e3876..6674caabbb6e 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -5732,6 +5732,34 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
> >>      }
> >>  }
> >>
> >> +void *__kmem_buckets_alloc_noprof(kmem_buckets *b, size_t size, gfp_t flags)
> >> +{
> >> +    const struct slab_alloc_context ac = {
> >> +            .caller_addr = _RET_IP_,
> >> +            .orig_size = size,
> >> +            .alloc_flags = SLAB_ALLOC_DEFAULT,
> >> +    };
> >> +
> >> +    if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
> >> +            b = NULL;
> >> +
> >> +    return __do_kmalloc_node(b, flags, NUMA_NO_NODE, (kmalloc_token_t){}, &ac);
> >
> > No type-based or random kmalloc partitioning w/o SLAB_BUCKETS?
>
> Hm that's right, that excludes it. I didn't realize that, but also I wonder
> if anyone would really choose to have partitioning enabled but buckets
> disabled. It should be straigtforward to add it though. But as long as
> buckets are not disabled, the token parameter will be effectively unused. Kees?

This falls back to normal kmalloc caches, right? If so, if
partitioning is enabled, it should choose one of the partitions just
like normal kmalloc. That'd be consistent, but also partitioning
without buckets is a valid combination that has different perf/memory
trade-offs that may be preferable for some deployments.

