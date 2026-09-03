Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C48C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F2A6B00E4; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00506B00E7; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902B96B00E4; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 624746B00E6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA2811603EF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:35:04 +0000 (UTC)
X-FDA: 85171639728.25.B3DB70C
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id E607640008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:35:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dDhEn2Mg;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of orsonpeters@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=orsonpeters@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5k5+Fsqvp3x6hqAgGWwJ6Y9lY2700zpmH7OyCgfIjgU=;
	b=6RiTWd5zAqIIDKgZDbFK254yNNYEIGo6No9PuzBpuzID5W9UpdUwr2cVxCiNoPk4TcTDC2
	1US4aUIjZeuB1OyTS4BbXuvU4mh7kQ940tUCrV0ibKr/kSX7KCotpSZhhP1Ex484ZjIOcz
	H2/BJxjOoeJqTH5vOtJRxU5125rIbxY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dDhEn2Mg;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of orsonpeters@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=orsonpeters@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788420902;
	b=GdGjm4uOo41UnJE3rWhZQB4RQ3a1L9EbsAkMbyhEgc38TIKRrFiPBzRfK42Sise4F7JQjQ
	bffKE3MbrxfU4cM6mRWbAjWDIYNjgJ0xxPRsmG/slvgoinVE7IB9IwatgQw1h9SGeNsoZs
	W0jz4mjWqfFAkmTfQQU0JPV+/pMQzp0=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-85aeb506b78so31637417b3.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 00:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788420902; cv=none;
        d=google.com; s=arc-20260327;
        b=JdmyBuSVNkIZYzQrc1LQ9agOoy184uWzzegPRzp6uBV2GWDBXMKA2/PAyj1NBMxW/M
         rdHWX3hqV+ViAZZ6zb04oNNyuGnuIoVjpunuByEzq5EwlNU7eQoPRnTHlyo64YpGfzPx
         vIJmfaw0sq0Y1PbQc4R2tflN/JzOAg3RBiLa7Z+3RI3Bv7THKRiILEug8m1AJcQuAhUu
         Hl0wcKaTAKAkLsjbU1MFFyF0lDW1SLU9BEQozOyzPkRiu62H5LSC343oeWvBUyaKof9i
         +tkrMYCr2t31YWSJm9Afd4zaYydWqGKmuQPYZAhNu6o4CHiVJxoBmv4HTzCcYsISPiDB
         mM9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5k5+Fsqvp3x6hqAgGWwJ6Y9lY2700zpmH7OyCgfIjgU=;
        fh=zEiyqYNtOMqsCbhU/MxmQjhPwosnt5Hj3E2X2rOJhlM=;
        b=BIA8BXlwJfBXnPXe1Q6QZm2QwRqdMJWHHX+2xCSLniA+CA0nyWNSQMgxxAQg/QFCA0
         ZS//Fd1ZJXiasZW5daCMbVJL7waX/yybHsyfXhdVWQZduNOyvNzOel5NWOZn9VuP9OIf
         4MQTJJdeY2qQSMTmLy0DuKiLY7SZjAFpBzzVH8bjFyhSflcX2KsYgyK296IsQlmf5+QO
         J3r+HnQ1s0KktOHU6bBpAG06/RggYZ+g/lqDXDxpHRPSlGZBC9XnhiqPuOUZ7nLCzFjG
         hjoNwc3u9Nidx6c3C9ROVbcEvyjDNP1lm6BkziVEjvaBQEWYQf80Z1MExEYU4CGPSTos
         wldQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788420902; x=1789025702; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5k5+Fsqvp3x6hqAgGWwJ6Y9lY2700zpmH7OyCgfIjgU=;
        b=dDhEn2MgnEqHY9fQKv+LDRiJdymKFNsAD1gAgm23efpWzCYqvL4H/bn89ttUdfzShb
         9XBwH23gseHqvTV1hZFG0/chhVeY/2E1a8jo2bdU8Y2AX8P3te7U2qj0trZA+L6peGCd
         f0WNP24yZ6HsF/v1y0BBLm2Ka/m5fWEt2pUeGytsb3Fs5xhwg6y9MAkngpBWQTw71kyQ
         8h/MWz53i0OTlp3DU4DVnv/Rkr5GCCp6SaAlF3MpM9jd+1dCIun4I5X64QcLQ3d5jrcK
         rjngwvjLaADBSjmCnnbllfXzbhj4/aZ7Ghw2maDKt183Jj+1HJtmiLfJRWuNcbiLOWi/
         PURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788420902; x=1789025702;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5k5+Fsqvp3x6hqAgGWwJ6Y9lY2700zpmH7OyCgfIjgU=;
        b=sjDwgoBXPCuLv4wWbJszX1toswdXsQgiZ5wgTTk6M03eUTn+4+e4wTJhaq6dcz2xnU
         +WaNN2g6JjX0P9JZ6Ltr/yHE1LyoCQ8VYcbCzqRYE8c5M7CQ9+//LxNYIyDOc4ycmiva
         kpQDxsxjVq5BhK31mmO3Ym3FiqBLXds5mn20jePiwj5xq9v8eE8uV9KZFRBkS1rRajhR
         A3jaC3mJd5d4k+hXm6b1gjy2eK4xu9AUU5fQR261GqTBT5Y51o6T1Aq82j8D/ilKGVvP
         /4kyHEwCGDZTXmRBGj0iM6bd4xjzgbCD5VKPs87sARpzhzGKawI+l0XNKjLoB0WAJSrv
         ZY2A==
X-Forwarded-Encrypted: i=1; AKwUvBzdalLGYhmon7ECI5C/RM/2YhoKLWoPSeunNcBusxo/X7e0NWQGHXyYBwwmZ5EJMJ+555HM5Lr2Pg==@kvack.org
X-Gm-Message-State: AFuF++lEfd7Hkh1o16I1xIcWAmaeGMCguSNqgQzPuHquZMVpTArPuatF
	uzGRccHYh3rXMWXNY/MTaIdHigTX+6pHy7fKkMi4TyXn+QZOTOFWmK82sStDiUMvsxZnyVpbora
	FhV31kA1h18AUzBNxBQnS1LAXpi65wlA=
X-Gm-Gg: AYBFou2hxsWNd9hgrlSdXqIEEkN2XXtCGeAJ5bCrk5TwqUC+jy2O7bz6CrLw+a6Dy7H
	Kxg8nHeWs2mvlpzAWds8hvybpEJxE/JTQ58vjmdkCYPWw5u3/6p3nNZLJInnRUrf+AijptL5eci
	X4jQ/BJoyTnd9ViOjoxuu7JotIuozVGUE677kq4o9uHZQlAaBpHztWOh0T+pVSKk4+aCkulPmzB
	xU1X8fGvSX/Lh4Gp3k3dKOp7GllzdVjCeIrm8dnPQoNpmAW96aDZf0pwJSTleYzgudqW3xM9qaM
	v8O2CoH1/PwoQ/bQRMUQkf/zjTqycXKnE7mO1JgfNXMHIldNHY/0CNS0xAjFcsk65E49DGpgFpX
	TrMHX46ld
X-Received: by 2002:a05:690c:a198:b0:81d:edf2:dad8 with SMTP id
 00721157ae682-86c53684de5mr42681947b3.22.1788420901952; Thu, 03 Sep 2026
 00:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260903031608.1194238-1-vernon2gm@gmail.com> <20260902211036.8184c6e5535669bd73c71fd0@linux-foundation.org>
In-Reply-To: <20260902211036.8184c6e5535669bd73c71fd0@linux-foundation.org>
From: Orson Peters <orsonpeters@gmail.com>
Date: Thu, 3 Sep 2026 09:34:50 +0200
X-Gm-Features: AcwNN1XmU1byQhOAnlxDSVcgMESrE-dNDgSfZURu06PxV6xOgn5ADMEdyXgvAEY
Message-ID: <CAJxLxMXN+y03VPWyiLcT5-eLVGE8iojDm4+GYd5fdJ4ZtQ45UQ@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	rmclure@linux.ibm.com, andrew+kernel@donnellan.id.au, 
	pasha.tatashin@soleen.com, kas@kernel.org, tj@kernel.org, rppt@kernel.org, 
	rick.p.edgecombe@intel.com, yu-cheng.yu@intel.com, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E607640008
X-Stat-Signature: uu8uxpxcr8oe1uoxobry7mzfk7c4awjs
X-Rspam-User: 
X-HE-Tag: 1788420902-970355
X-HE-Meta: U2FsdGVkX188D3PLg7ZpmPwcC92943PP493hVLIkvvfZuqKk5OPeqIY+iFlyxprzCYknvfzZhbiFrmdKX3lXmGU59FvJMafY0fJ4PJom2myquKjRIfwl0FV13R0D9yn9iDe8ppKR7jNAbsSx9dhY+IhS7usrRwwwGKsjV4wdFr7VjYqd+6dJpQtHPgEgcKSF8JNDeVKMMiec1noRWguxPQ2WvJ7EllgN7hLQ2hgizPgl6AOmyruCuetsB1G2RBADmDRvnS+J3KnR0gLCd6/08uK0Dv7S2wsHluv5229rJAOjCptjoT7kKAbYShFPYOlfBbX/C7qssyvHrUAkUPfTHkWEzinroilRXrYO1V90WtoFS1MpKDcaLhuRScCs8GSxugIK5gAFm3nyfnwJAAXF1MwXtZ5D9iE3pYjS7dk6xJbWzi5coLNCvH6UZ5radfNul++/M7t1YHva4II73QamxXGqzj6XqbHOm0jX7wak4KlJoz5Axra1Ud+sl3H5WLwC/91ARfIEM5CPYrRQlv9I8wjY5xIZHUrvOG47QVS/EI/qxAhKS/bRDy1RZ7TyFSaNLAk+NpYij6rTkbvQXLbT3m3odC9bZovoA3ciJgeAcB5lN7CA7ZuNg77vvBB1RyIcJ/I9sY9wZAGn5raBjttxPz/7katlMGPzcgwTZ5Id5tspGROOYPYpX9K1Pdi9Is0GiwGVX4Ecsb+tvNZ/ExNtdeNadRzGeCPptOBIQOq6dXsiCl1XmYbVeYRzVAXrOIGgqhZGS/x7quLl2bT/lXpdtolC4GaUb4j2sQFR9Tvu5gBuzqIkTB08KCy3XGP4YNTfMLWk3vplDYs02PoZ1nN7Hk+X3GXgGjMjZIFbiErm2YagBb90bAYiuNKR9/llbnEurbbxHcjumS17La7aFNsVxa6HVJWS1zYk1ejy54Lw9T3A5jntWmlijER1969Ai5m5jkn1pcfLbALimvy+vDg
 r10YU/Ul
 CnYz4BJ38AiV3jnBb7LOZm/c5Dqt1iVE5Sd42YfqaArXdP0dLGALxbM1m1hWYt8VY5DPTWD36i/fIrsky+uiJQNS/bDBZoIqXxp6S86eli4/PbDWoqx7CbGUHWFAXaydu+nEwS1yu9pcKbXd4d41JRHEKOgojxocWumeoCKUtooitqB/HUI5bi7yWQi8T5hyV7uLaFv5V0Lnr+U86yt3FD+2dBTv/EpeLA/2cNEfC4gx58F9LcpfBdxcDouOv5gJ22GtWkSqDZ2nCClI0Dv8NBcJXWEiTxyNEFVPwNn+5soi6wY8YflHsLn9IO3KuRvzi2d81Pv4Tb+DFKIrEykaC+S6Wfme5pf0MLrPkxMhZXs4uRoyzDCqwmrXJ56zVY2JQzIdrTwDnQhzDvK7wUTFwv3Phu6gAs8pVJQjIxJ/aRQOt7UzHsLo6tr8AlF5DpiAix3TwNOterxkEdyk1q93PIFnd2F3TMPVWMxs0GEieM9++obOsZpIkBUjKkMiU4CoQfUyZoZjs1WRhw+2Zetw8JgMe0TSmPieKyXcTn6VvBPUNDrm/M8hBVWNjjmd5NQNRF/BEci3oVXjFDRdYWb6AZP1RgHTiBbzWGM5mfxbXCOeCj4qhVXRc/fnASBq7hUUYUiHrKw1dr5FpXd1OuxcMAEEs6aWXOLgTWt6A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Andrew, Vernon,

Thanks for your quick reply, confirmation and patch.

What I failed to mention in the original report is that this isn't
just a hypothetical issue found by analyzing the code, some of our
users (of Polars, a data analytics library) have hit this in
production. "Live data can change silently" is never a fun issue
report to get.

Transparent huge pages + MADV_FREE + NUMA hinting + cgroup
limits isn't your typical mom-and-pop setup, but it is not an
unreasonable configuration either in high-performance computing. The
only missing ingredient when you use Polars on a multi-NUMA-region
machine running default Ubuntu configuration is the cgroup limits.

Considering that the impact is so severe if the bug does occur (silent
memory corruption), will there be backports of this patch? If I'm not
mistaken the offending line that introduced the bug was first released
in version 6.6.


Best,

Orson

On Thu, 3 Sept 2026 at 06:10, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  3 Sep 2026 11:16:08 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
>
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
> > silently discarding the hardware dirty bit.  The subsequent
> > pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
> > _PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
> > stripped from the value, so there is nothing left to transfer.
> >
> > Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask,
> > and pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify()
> > is the odd one out.  Any pmd_modify() on a writable, dirty PMD loses
> > the dirty state.
> >
> > One visible consequence is data loss with MADV_FREE on PMD-mapped THP:
> >
> >     memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
> >     madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
> >                                       // folio marked lazyfree
> >     memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
> >     mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
> >     mprotect(buf, size, PROT_READ|PROT_WRITE);
> >     // ... memory pressure ...
> >
> > Reclaim (e.g. under memcg pressure) then finds the lazyfree folio with
> > no dirty bit set anywhere and frees it in
> > __discard_anon_folio_pmd_locked(), even though the data was rewritten
> > after MADV_FREE; subsequent reads fault in fresh zero pages.  NUMA
> > hinting alone can trigger the same loss, as do_huge_pmd_numa_page()
> > restores the PMD through pmd_modify() as well.
> >
> > PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
> > the dirty bit means rewritten data is never written back.
> >
> > Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
> > pte_modify() and pud_modify() do.  The existing
> > pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
> > hardware-dirty <-> saved-dirty transition based on the write bit,
> > preserving the shadow-stack encoding rules.
>
> Yeah, this is exactly what I came up with, using chatgpt.
>
> > Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
>
> We definitely want a Reported-by: Orson here.  He obviously did a ton
> of work on this, and it's the least we can do to thank him.  I'll add it.
>
> > Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>

