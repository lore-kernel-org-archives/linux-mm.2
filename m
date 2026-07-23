Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DBF7C531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 16:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261766B008A; Thu, 23 Jul 2026 12:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBDC6B0095; Thu, 23 Jul 2026 12:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D826B0096; Thu, 23 Jul 2026 12:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C012E6B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:43:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45D9F1A0555
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:43:07 +0000 (UTC)
X-FDA: 85020611214.23.24E8A71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FC6520013
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:43:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiXKwAil;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784824985;
	b=lY1N0J/ExO4/GYHrdX0/iMlff8Q1ePKZkO6jFprjRe2RRUOAzH72xbcBmurbeaOi3Uucw+
	uMuuwAT962c55n4qz6y7iiQLifZLTPOlomKlNRUL1xeSMH2Tokm6O51T8Y2kYeGj2CIjG7
	wpMkAjCBgHc0IHw/g2a22tsZu/ittmQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiXKwAil;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784824985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Tm+L3ZfGNAVuWnu3vi2dlwoc2n8K1GA36uCMITLP/A=;
	b=AcOb3bixEwpkfMUtIN6vMOWsH6nIc/JHKfq92E9vJZyjNJpcYLNc7rvXEcyrRHWtHofHJW
	P/B5H7UEb5KWCzLgS5Ofwd2qa7tFdBpCqR9euszJa+jmEYcTJYb6/i6tHMvQX5ZabodQe3
	cRf05rXc+E5w//OW9ECZWEZxIc6qR/4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9470643ED1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799521F00A3A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784824984;
	bh=8Tm+L3ZfGNAVuWnu3vi2dlwoc2n8K1GA36uCMITLP/A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MiXKwAilU4xl2yhleBopEWMdq9JIWo3BlX6j0n1xwUG+j2arVZlkN4zDzV9pHUW3c
	 YAP49f9SWiYTSfwweFJaV7f43NTlURxoVq2QJ/lJUH8Z4ciYUaPvqnlfxSJ365m9wd
	 JQxIlf9CdpXAUlPyMFM/dh6TtPqyMWvfZ8+RSkuhDLO1t48zcgaAnwiq82GkvY3JS1
	 Ovx61XTDYNdDrJhWLISfH1FbszEifVEQ1WWYtqdVTGQJWKiitVI40hgWUElC8ryxLl
	 D5UUIOEbjKerFAmxSBsoOOE12IFtfKjbPHX3r2scugcA5NfL/WQqE7v4StD2t9o4Ib
	 fgCPlCyOy34AA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1677c91969so99143366b.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:43:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpghpOGK9TzRwQmlkQOhSFi9NH9Rb9+zWF51YGmvAO1XCyOuS1HdKFk4k/GcoGEIeZ6Mriu8eSnRw==@kvack.org
X-Gm-Message-State: AOJu0Yw4/PsMd4/oAbjlFQeLfJDUEl9fI0g0yTtUYYCX2B/eosBBbyl0
	QtV+xnmczxOQjlUGVMgwtC6r7y3NDb1YKqriNWKaK0advKKaCcfrJIq9yYYx4fbWoNqK1xMc7wp
	UpRqGgSubUIOtfRVj0IlZTn/S+YAn3Sc=
X-Received: by 2002:a17:907:745:b0:c1c:5aa1:de57 with SMTP id
 a640c23a62f3a-c1c5aa1e1e8mr108906366b.13.1784824980080; Thu, 23 Jul 2026
 09:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-5-usama.arif@linux.dev> <amFZmtGHEZjXEw5R@google.com> <ee172b01-54c3-47ef-9040-1342a1566796@linux.dev>
In-Reply-To: <ee172b01-54c3-47ef-9040-1342a1566796@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 23 Jul 2026 09:42:48 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
X-Gm-Features: AUfX_mzr2qlQx6QdDR71I1yU6XQcNBB6QxUacWdrDztePk-C_quLrGldHBIAln0
Message-ID: <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
Subject: Re: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio swapin
To: Usama Arif <usama.arif@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com, 
	Alexandre Ghiti <alexghiti@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5FC6520013
X-Stat-Signature: e147ue1ynonr7swuemx6wpgrzp39749k
X-Rspam-User: 
X-HE-Tag: 1784824985-479161
X-HE-Meta: U2FsdGVkX1/zjmBQCpI8w2CoUNXT6OKYFujXFV5qEFPlzCga2vdk3h6iOoWlqkd2xY5ZJ9bg3AwEgJIL0wUufqfpkHztp6kFNrUj8gpYRuAJz15rOtnBjkbuA04tAbwH3AV3EO6RI0i5i5NMggL9l+Hkg9Q35w31HsK++K0M7ARw/QZduwm/dVGI20zyCtcJRa3eL9uC/MPMC3Zw6VSRZGA2FNaDOkX+xDbTPPzqTXH0cFrez1cfQdXcMyapDfnFDfi5jdGlsXk+F8d8GXKJALvWiwUziTSMga/F5cwaVWq6UBo7qZrw4B2Kd9tol8wTaQ3D8Ucwr/k3hdsin3CZ+lQQsGKad8LF+asyq5JQUztUBX6q9co7c7TCBF2X0duJnlxTtVQf3OmB860kp+7rq+zThrQFIXS3GAmogCDWPdTiDVhXMA6NDHh0WXZa1/ug7wHONsFPGfGNSGxyH4eh9rBmElvnet4oIVPWkrCpLPkjJ2/BGWPHGPOwditWg2MhnORyEb5N+oIQLm4+RLtE+DTV9t4CJ3WEqDOQuCVV6akHmwTJuv92vEw7UllI45LPf2nAGjw08l2fa9awt7Utrq1Jy7pmw3SlkE3rTMsBozNHesolkdMXtEUWMhRmV94n4mAZDI22/rL8ZBTRjZ+Q3MKFzYYvO9Br6EZm7pvMHfEMn5oF2YuutRTjGDgHSemGa2PwdeIT+eCnGhItwIrh2DHAHb1UQ5xQYAydvOGJWq8o82TsPq7zbaziJ9yd+/ZIqhQfSahQoLL4a+3ANxphYW2+dGa8RR4ludsLxEW44OCNHcH6Tk8rn0bE1ltJfXRKho2ufKD+z7h37MAfIJ7GFoZpyziTTnGXoqAHd8bP2VvWLr6Gwj1eC2DT6qn9FLv9XC36jCjG9MMuCxx7DEDUd8jIgKEmtqOnrg2dE3H+Beb6WvhmltxTcdES7lwsw0gJ1E0SBffxo9owbR8AtWo
 MTR/onRl
 N7vhEhPIZSgNvauBO1P/ZpEQ3SE0ucsizf9m1Ss/7iSvnrjwE7dPyF3JqaoCggHLQNKCcyZTBZGvwlqPuDDnx/mV7V0m3+1OsXMAUPnUb0NPCSYZYOF64SaPqPColJh/VEWQ/jfMdhHkrk5w05z2JJodqLD4sC8YL8yhnV0MoK8a3VY/rw5VQHACYTa+mzWcxTTOcfYGRVG96HtyGDE+XL9BIKNpf+Olq5hj0E1AVwCxpvbGCwnA5jpozSdBuFljFS1ySrw2KkM4LRBQ+BjnIobkdpSRrqWIlIp1j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> @@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
> >>              return -ENOENT;
> >>
> >>      /*
> >> -     * Large folios should not be swapped in while zswap is being used, as
> >> -     * they are not properly handled. Zswap does not properly load large
> >> -     * folios, and a large folio may only be partially in zswap.
> >> +     * A large folio reaches zswap_load() only when its whole range is
> >> +     * expected to be on disk: PMD swap-entry consumers split before
> >> +     * calling into PMD-order swapin whenever any slot is still in zswap.
> >> +     * Confirm the range is entirely absent from zswap and return -ENOENT
> >> +     * so the caller reads it from disk; if a slot is unexpectedly still in
> >> +     * zswap, fail the read rather than return partially-initialized data.
> >>       */
> >> -    if (WARN_ON_ONCE(folio_test_large(folio))) {
> >> -            folio_unlock(folio);
> >> -            return -EINVAL;
> >> +    if (folio_test_large(folio)) {
> >> +            if (zswap_is_present(swp, folio_nr_pages(folio))) {
> >
> > Is dropping the warning here intentional (for the folio_test_large() &&
> > zswap_is_present() case)?
> >
>
>
> Yes, so we can end up in a race, which should be handled gracefully.
>
> For example, lets say we have zswap writeback enabled, which means we
> can end up in a state where we have a PMD swap entry and 511 of the 512
> slots have been written to disk, but 1 slot (slot X) is still in zswap.
>
> We can then have the following race:
>
>
>   CPU A: PMD swap-in                  CPU B: split-PTE swap-in
>   ------------------                 ------------------------
>
>   Checks swap cache: empty
>
>                                        Faults slot X
>                                        Adds order-0 folio F
>                                        zswap_load(F):
>                                          removes X from zswap
>                                          marks F dirty
>
>   Checks zswap range: empty
>   A is preempted
>
>                                        Unmaps/reclaims F
>                                        zswap_store(F):
>                                          puts X back in zswap
>                                        Removes F from swap cache
>
>   A resumes
>   Allocates large swap-cache folio G
>   zswap_load(G) finds X in zswap

Why don't we check the zswap range after allocating a folio in the
swap cache? I am assuming at this point we have the folio locked and
the result should be stable?

>
> The correct action would be to reject the PMD order read and fall back
> to per-page loading.
>
> I am bit torn about what to do for zswap here. The series is quite big
> already. Alexandre is looking at adding support for PMD swap, but will
> send patches once this series gets merged. My initial versions 1
> and 2, basically stopped installing PMD swap entry if zswap was ever enabled.
> From v3, I used Alexandre's suggestion to do zswap_is_present() test
> so that PMD swap entry can keep on working.
>
> Both of these paths are temporary till Alex sends his series. I
> do feel my initial version was simpler but will basically stop
> working if zswap is ever enabled. Do you have any suggestions on
> what your preference is for zswap?

Even with PMD zswap load support, we still have to deal with the case
where some order-0 pages are in zswap and some are on disk, right? I
don't see how that would eliminate the case you mentioned above.

