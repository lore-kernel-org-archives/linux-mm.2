Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF02606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MdieU0Fk
Received: by kanga.kvack.org (Postfix)
	id 753946B084D; Tue, 27 Oct 2026 12:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703786B084F; Tue, 27 Oct 2026 12:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3356B0850; Tue, 27 Oct 2026 12:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 396786B084D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:49:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8B371A0A7E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:49:57 +0000 (UTC)
X-FDA: 85368993234.17.95E1AF5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id C69094000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:49:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MdieU0Fk;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8a32jiRIHg8MgSuY0NmSAXzTQgRPvZ2S02jS/vgMnZU=;
	b=VVsdNXNtTc/PjBvTWYj+2FKnggfIwKyS6bwuw/Jb7hQxWOuGJ1a1ciprMqLaxpJFMvIhGA
	UTZVbIpSqnK4bMwX35poXAQr5xfhE8yOJjw+o7XqN9DBfcg7mALjp2qA7A1cJmEfIAQF1o
	es6R/R2TwjE7A9xhNxZumlc2xykoNJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793119796;
	b=NM9eaorQc4p+1q1j1hvmQbBNGUg7mTQ2VptySbFBtin7jS02tFGSwen6eN3wiqmXiRB+h5
	gsM5feLVGRXKL5igO+g0KGwnP53wdsum3xMT7O3g/7JYrk+ZvW3g0g5QXbDWu1syZA4su7
	9a+sJalSzABfyNDPTfNVnBJt64R7ddA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MdieU0Fk;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93F4415A1;
	Tue, 27 Oct 2026 09:49:51 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 152893F59E;
	Tue, 27 Oct 2026 09:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793119794; bh=Wi8JCvfDMPalrSXsQQq726qxz61LBuEE0WYkMWBem1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MdieU0FkgBD9jO+oaHHb+PAU9kNPVL8ASMuIuRPu9Bb+9eQH/ca8vRrM3DvNmi2wv
	 P0JcOZauSNMXB9JRYOb4jbHCvFXAWy9LbhupAt+49YAEvtdX52igbRblbRKxDC6vHv
	 muZXbhgWDd0yQKEsjKHTxULFBhdUdGv5Zxyp0Tsc=
Date: Tue, 27 Oct 2026 16:49:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zhao Gongyi <zhaogongyi@bytedance.com>, will@kernel.org,
	Ryan Roberts <Ryan.Roberts@arm.com>, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, lance.yang@linux.dev,
	mark.rutland@arm.com, akpm@linux-foundation.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
Message-ID: <auDWKd-kXH22WPjD@arm.com>
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
 <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com>
 <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org>
 <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com>
 <at9H9Vkx57pIcPos@arm.com>
 <c267c29a-5678-4c0f-a15d-e5c12ae8c427@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c267c29a-5678-4c0f-a15d-e5c12ae8c427@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C69094000B
X-Stat-Signature: g65za4h7zzpa3wj5qoks551azetogry3
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793119795-898555
X-HE-Meta: U2FsdGVkX19KL6AJWdjIXp614RJ07hfj5Ym4JPDdU+snQW/n6QN+Df03EEQMK9Z69K5T25rj1fTzmMwg5wEcoM+54Rs05ohSsp8ETiB+qUhNnso87wMyj5jiJo9tJlolKn12ICqr5qtXeNs3aI7MEPFOI69QVYIK5mRcLxAnianSdS8iaocTqjklIJ9/xa7OU0vXJ/eLQJOZ6YdbycH2bc1btQqc4Km76KeV1pu9jm77umWKNkFCfNKp8MW2juOeQR57MAzJVgdF9Ad1umLIMzD4lEM+31c0NQD1hbG1neOYorCkXoYwhqMcaZSB85AtpsYqDiETHtoeier2CQA9fPaw1aHcmLcr1GN1RHc7Ejk3exjg7GZzfs46OuW+3qzfcS62Wz9Udw1Y1UayEeinnlCzJ5DjSkZ+cU3JyxUf2Y6uADuy1vsxmahaQLECSQPBwouSnWTRqQsLPKgOAkq3lgRuxWPMbMgQZge5HzF0oSE4R4LXTFbEbL1dwH0mb+INyT2QhT00Cf84bWKf9Tdi1Y8T9NDl96GGtI5Po91cQEqtebAc+pwSRjeQJ0Y+K3jqDGutyFq/mkGWu3IOE51xQCO6xZyoHHroxvQQ5PF/b998WGNfFsT1Y9IDUtrbivkK7XiMDV4I8XAb8IvKdavXN1S0cQD0r0Cj6OatC9VP8kJmUGZ+67cUtp2vNMiYWHpxzT0ghNX76UXQTFm71t9/O934S/tTvvdbZVa2XBBbYtk/FKvL64DQwcd/LuIPTYbu59bMAAKN662UXZQ/kZ5TQHljLFk+MpZ/dXeo1Q1BZYgeJB1f5sbjabKWXl9pJE3i7DNtuOvChFnByu53VsBJttDJ5/eTHnqoF0GLdFMjchKIdgrg+TKCgjrtPS16fyJ8BtkI9QJ0dzeUbA+289Kom5fkmh49Vxq2zKmR/ZKQh8pWumcokO8WotQDiGss4413OPycPp61trwmpKBqLBk
 mheniD+H
 XpgXKcPtyE5XvvkQidzkRM2k01wqvehi+Zw10bUQRGRLoh94U9ImBNGCqwBnqJJorC/G4gtHpm665jDsf0VK502esW5UKykI8cakLZfsCxlAZmp+27UnwEK39ZFxwgzbFVdjyi6MvoK+LXzWxJBNobzqV07Kb4iVoNpcukKoruYylCT1ZXMs3cicMDYfVRDsIToMiGLbAlZ+9ffnKTJECMyBHC3qzgyxEqb49ArCfiPsYb5FKAHEdrzMaIac9ILRjGBdGUKvuRIcxR2iEA1BgRyQu+PkMHUHsa5d9pmu6Le36hIIlOTZQHxOhN/dGiYaPHvb2ZQI8RmzClaa9ryTqfY0ESPM9OfaXH5bV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 11:33:31PM +0100, David Hildenbrand wrote:
> On 10/26/26 13:30, Catalin Marinas wrote:
> > On Sun, Oct 25, 2026 at 12:00:33AM +0800, Zhao Gongyi wrote:
> >> On 10/24/26 4:55 AM, David Hildenbrand (Arm) wrote:
> >>> If we have the spare PTE bit, why shouldn't we just use it?
> >>>
> >>> It will make batching over PTEs faster. And we care about that for present PTEs.
> >>>
> >>> So I don't quite see why the stable fix couldn't just do it right away? Do you
> >>> have a prototype that shows that it would require significant code changes?
> >>
> >> I tried a small prototype that keeps PTE_CONT on present-invalid PTEs.
> >> It leaves contpte_set_ptes() unchanged and makes contpte_try_unfold()
> >> recognize pte_present(pte) && pte_cont(pte), instead of checking only
> >> pte_valid_cont(pte).
> > 
> > I think it's worth doing but currently not sure it buys us much unless
> > we also change pte_batch_hint() to cover such entries. However, if we do
> > this, we need to audit the other pte_valid_cont() callers (e.g.
> > ptep_get() needs updating as well).
> > 
> > So, if we aren't going to change pte_batch_hint() as a backport fix (I
> > don't think we should, it's an optimisation), I'd rather take v2 now and
> > continue with a proper pte_present_cont() etc. patchset on top.
> 
> Your call, the version actually looks quite clean:
> 
> https://lore.kernel.org/r/52e7e1f6-3535-474d-9b46-6bb62f96eefc@bytedance.com
> 
> But yeah, audit needed (e.g., no need to flush when shattering such entries that
> are not valid)

Yes, the fix looked clean but I didn't particularly like the asymmetry
between try_fold and try_unfold w.r.t. pte_present(). Well, that's more
of an OCD ;).

Going forward I think we should move towards pte_present_cont() but
together with changing pte_batch_hint().

-- 
Catalin

