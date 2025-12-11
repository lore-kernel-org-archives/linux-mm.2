Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B1CD3E799
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 06:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE7E6B0005; Thu, 11 Dec 2025 01:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF7F6B0007; Thu, 11 Dec 2025 01:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECB36B0008; Thu, 11 Dec 2025 01:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8B36B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:41:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A54A31607B4
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:41:17 +0000 (UTC)
X-FDA: 84206243394.24.488A82A
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B769A0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:41:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PVm2Ovmy;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765435276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/jPsKfeO0D+5qsv+PXL7ya2LAsONenY167Q1JLuy3w=;
	b=qCEGIf8kzmlpRIGKBW1Cgu42j8cq2FfAKhVO+lAgmBSdUh8Zj+yFcMllZlbfQ+FfQc3vZM
	4+5G9QK6FhFHihYW3G/KtbyJ2rPt09Cm5df+l/tdfmIHTHJWYeVvZC2tATbRkAc6+1OfBd
	Jo2ztjxiJqqzj6qUu9AfMu8NwoEt26o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765435276; a=rsa-sha256;
	cv=none;
	b=nNFEjAWDq+qvy7tNo00Ni23TANK+rwSMv0SGwvNCxG34V/iS/Y10z85z9mQFm/ncvhWNo3
	44ZswKybBMwYEelniw3me1L8SX+AA77qGz0gkWC4yJHEekNjAS9GNEbzfmcZTWYkcrSk6o
	R761RKn2h6LFyeOwfBke0hbMWkPF6LI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PVm2Ovmy;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 11 Dec 2025 06:41:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765435270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/jPsKfeO0D+5qsv+PXL7ya2LAsONenY167Q1JLuy3w=;
	b=PVm2OvmyiPRuk6NVjfUWFRFPVaVXEjOBDMp1Om9zewhwbqJ6L1+VNe/VOetrK9/wtLyYdp
	httjUu831I0U1nS0LG9hHslo2hN8SGKwRojMXfP1lKiHHTLzPnthFQGrODDFkayQMijHTq
	waWCitCrRoV3kIYJHo2fPjMEpHQ4+hg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: rename mem_cgroup_from_slab_obj()
Message-ID: <aTpngVxmYDv7huFF@google.com>
References: <20251210154301.720133-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210154301.720133-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B769A0006
X-Stat-Signature: q834i1xmcjz1bnqz3of1yj1358bfodu6
X-Rspam-User: 
X-HE-Tag: 1765435273-37296
X-HE-Meta: U2FsdGVkX1/g66fhE2KxxpLmIbzqXoXemT8w32LpodXkLxV748emsT9LI0FLGzGHrWn1tjuHcepVsEzdK4+yg+r2qrJFD78558Hh/liOww22s2nHeynK4HL9EB7njcFZsGfbS36EZshmCs5NpDQyn+qRbhA3aXzh0ogU3y5ryfDN++0Uz4+LTysvKAF7GCd8bUd3Ru/FRGu7JQKQhl/Xyy1No4oXpdOJI46d3zmIf+/NhErYKDFO+ZIwg9Zhm9EdepMgmVCPyHcK69PWigGZICe/chGZRZ6JNSUOuRnfTwACFsvjIxhIJPP0qWu8tyDC1dFBjRUhNfsSVk/BJDVYcgHVyZIRbqQJQWE2lbK6cNveN6n4GLiq7B/HgZaRg15EI7BnxY7nA8MDSK4u1Mc+pKFm+jVGHzJRO7XGob299H7Oen7lQ06FtDAYiR05lHsXnsfAmytDL/0cHmjCFF+8DYPkq9Ihgow8+0X9/2a+G9qRrzw7sY+/g6HTCmki2u+D4rfFc26RdHr8574QCumVoH8hh0OimTd7ut7WtKHVt7ccRqx3ACEZWpYSg/+tnRm+lhkEvky8VEGM7rWdMnXhTJHNZq9PY27r64bZy/69EeW1OFeaMCI47AjeKyCyJ72LMn6mA4iJHhdtp1P1nDyjPkgqMtz0gzFeT2R4qF9k22giQ8rqagBzPgPbAyOg8CU/5BVLG6OrjhL3N6Vla+UjxvFpPwo2n5YzLlLSLKd+QqZn5t4s/f4nR4y0B0vwYH5/XnHySrhXWK/MpOn5jvvqxl0VvHaKouPHc5kdHP+Qmd0TMRY66EtQR6RWgdlApqoLquS6njblNxEeyNvnXcIVvgWzYqVjHgTQVAtexlApuetK4o1v0iN1HzyFcGHSmF0zyu+Zk6df6k0BTzsuBFMmVMbOSAsKC57JQ4fkCQrYkq9BpEEHudS/0zzDEdScIA6T7vcDt2wvlbixX0ligyy
 9wZyfVNX
 /Zdq5jUZbqojCRsqBY8RVWT3jiszsj8weadqL3jYnPYDfRXpbO3BGwte7KtU1G4a0g18LTVXxVioxhbyKeqMmXO+gjtZGNoiZtkjvVVju9uNPi6Dq/yWRmn7YGum/hDMh3RGsxEl5FvqD7PcBxFqzFRgUujKLXuSog34IluoH5DVSuTujq7YkVLTkz4IbIK4fghzflIC7G1sZrhIuUtnsx9BDa6mtBbMn3/p9egVG7H02pGtxXtinphPR2FhhOAHe2wb7HXfb5y0QNdHeDTdgyjYQ+cXA2x6JoNcUrL6pVCrhXEXVv+OvHsRfeJWig4A4Z4N5XLpro1aHT8+CVGqciqR3UvGAwmTpaoxVwbgZMbkiDT0nWcRinR2F+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 10:43:01AM -0500, Johannes Weiner wrote:
> In addition to slab objects, this function is used for resolving
> non-slab kernel pointers. This has caused confusion in recent
> refactoring work. Rename it to mem_cgroup_from_virt(), sticking with
> terminology established by the virt_to_<foo>() converters.
> 
> Link: https://lore.kernel.org/linux-mm/20251113161424.GB3465062@cmpxchg.org/
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

