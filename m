Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FDACC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6F46B00A1; Tue, 22 Sep 2026 00:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E446B00A2; Tue, 22 Sep 2026 00:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94176B00A4; Tue, 22 Sep 2026 00:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF3436B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:04:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53D611C253B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:04:32 +0000 (UTC)
X-FDA: 85240056384.22.39F2510
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97334180006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:04:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoD1eWxA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790049870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdK9NOa+Csh4+tgbck/fIPFaNIpTXpsiJF2arJyHaDU=;
	b=L7/hWB1U1GGAyk9gOATEgxHJvpUxTpjdHEZ2L1ilgsLdDvWM2Vnv+Z8SqsQqXg+lniLycM
	FFtzv4dfas/1eaTDzIeUpsCwVEaC1vWyhTOCE2h+N4NL9F+0WVt76VENs0CK8taclLsRfr
	JQRfv5wwMK+KwG7YTXwXsVXxrtNodDI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790049870;
	b=LzBT2Kw532SbESWPan+WI5xx7Ntzu+At7LXfewHeQKBA0BTPLxb4064d3BtTLY3Y24uzbK
	MF5o/xYLy1IOUFaqtdlL+g4qhP3vnm2DEvHKo9eiWUSJ4tr7xn8mFm7vpC/OJ7YuY6eHbF
	1zNxNVUosPzv0myYvvQH4LKd9AV9uyg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoD1eWxA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86B63403AF;
	Tue, 22 Sep 2026 04:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC5B1F00898;
	Tue, 22 Sep 2026 04:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790049869;
	bh=XdK9NOa+Csh4+tgbck/fIPFaNIpTXpsiJF2arJyHaDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OoD1eWxAao/IPqexC/yqGBE9mUdZr2l/XResY7bPKAKx9KitlrY6x0g+fe1ZtvHwG
	 YMBsag/OpacfmYFOv103gYiuk6qQULuSnCAMTTVlnZklJxrkBMLlRYb3f9ep60MvU9
	 fJrfqiroyQymRgjDPHQalZYFDqO7sHYLTA9N5+gA/vmmz/UyFPcCzylqV1Ah8jU/Tr
	 jk5L+LDTJV831j50vA4Gpra2zXXC4Zf8LuLviP8Mi+6fYArU9p1ozN1+qArX/6etD9
	 tfwIGktNXcyelkdo2awMWs4g5XVGrPq5L6spppc+O0ft0ar+afICAztfndaedg7QTz
	 nDfUSljFG2VVQ==
Date: Tue, 22 Sep 2026 06:04:22 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
Message-ID: <arH-Rntaf5SKFTga@localhost.localdomain>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 97334180006
X-Stat-Signature: pirermzuox3yygb6jtu6eg9g3c8d7kkh
X-HE-Tag: 1790049870-200026
X-HE-Meta: U2FsdGVkX1+hClBO6Ct3jQTc4uNbfI41iMt//cDLEAgM7OSrM4R7mM37SH/rE8dl8kQwYpbbP0fTzLT11pbE9dL5xfh7y64nCUEx6eqxZz363ArKp3Sa+Vcxtm0QPQWEnjoRV5kMMFqXqYxmPq8c/YxJtGaVYhkPAyusgDnGTLCvilFXg4M0ZAP8Gu3gK0KtcId6RhYrL9ziPmAf/5MYYvVlbxd2iY9/JHauAJweHVRSvhMQwWHSXmNBHcz6MwFkpTgNuRl0MGPM5OWlMhKmMw6VA6tHfCL7R8NtLQw0dEuA+BEw15k9u4D3aWZQCQgxEaxyxbW4Vr1Q32D3E4qrn5L8Ze+WB3oeuA3h5sgCs7J+kFtWscz8o0cnWvGeAtodZHBl01dCmcMLjFszTVDm9VEUfvtRK9S945kl8SVC38Bel9RmTVX23sPG16QN9EUSfVAM9hjd+GGKPM4J6Dw3lsj3xvtwDusSMxFM7sCDr1Vx2Nu9HrQw7c84RZP/Y2oMaDOfS42V1DIzIdr0fH2UJtp0zmHKVDUHpOcXQUKxVYD693Mpbo6pN4dO4RSLGwm4QPqVDljG01E2Hge5n064GWdnUTyp6GFh3TtYNLwbQ4MVJmdD7YyAfDcoIVr7iSn0VsN1/cc3NwkVPoeApJ48GQdEsZdcQFrgagGhZNy0/9hS4Mh7KhITq1kZbdC1m7RNXal9ZdCODhXwyCKLkKuFqam9e9xI8M+SapPeMiXIf6cFH2qHDXTdpYfvIS9o5Hmir+yHQWEpgdNVh8PUdVB1w5qcriInplkIwrkBgAiQzHQTwdbeThdbRQi8XxocN6foIAYBOg+cXXI8gcd9Vv5IHjUynM3WP0l6mEcWwD4afiM4TbE17XQjwRTq7xuAZp4fuU2ryR+8caDPdhnMsrgbjmiEzN4BuXeB9zyEruDoZP5MPMqp8NyUSv9oVdM7pqtop9FlnP/GPpEY8lBOWcY
 R3rqYywu
 u/4tq/webpzoTeveFfHChFyB9zv7l65fNlvlpRvlKUpEvG1NOo9d2Vh6oHzY+VLawgNpYahpT01uGTLNBX00/d4L+bZCFObyFtQsuf83HBEhPqiI8CECe2i0cUIF/XxzLAy1pwapfy5Q6RBjNkH8jvHVo/JfLZT4wxJ9goEg9Cl/o+yj/UpVQo3Q8hgWNx3H9J7dzt9949ad338V7Ojb/LGW6YzDvtfL+kyiZGB/fMYNEI3QZ/DroL9OmR1ypDoiGi2zbH8a2hNM7l+iDAkiHc8l+vY964Ij26x9Ww5U7r6iquJJhDbqPzx1moRpy5MvR0FDg8padr+7tD91DFbpxQPUokBjEWa6SMzS4gQqQEfSNDUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:12:34PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
> when a huge page is handed to a user via hugetlb_alloc_folio() and
> decremented when it is returned to the pool via free_huge_folio().
> 
> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
> hugetlb_alloc_folio(), so it is never accounted, while its free always
> is. For a migration target this means the target node gets no matching
> increment for the decrement on the old node, so the global nr_hugetlb in
> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
> affects the failed migration path, which frees the target again right
> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
> same helper.
> 
> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
> folios, has the same asymmetry: the folio is handed to a user without
> being accounted, while its free is accounted through free_huge_folio().
> 
> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
> decrement in free_huge_folio(): a successful migration hands the folio
> to a user, a failed one frees it again.
> 
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

