Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A5AC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C6B6B0092; Mon, 24 Aug 2026 22:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23996B0095; Mon, 24 Aug 2026 22:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15656B00A2; Mon, 24 Aug 2026 22:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2116B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:06:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F36F8C02CB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:06:18 +0000 (UTC)
X-FDA: 85138152036.05.47D4F0E
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA257140005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:06:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DW5U2ZbS;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787623577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3lOvkOopleqCpD5m7JjvMuPQL3UXjj1ISCcnJv0CNQ=;
	b=D0s1yax1x8dvk947BONhQfc/PPVecalapR70wiy/bcNIyLiDhFFFW9lNMTT22hmn4ep0OE
	yvR0JcPmi3kc3dnBU4kANm24FzJ1jr092xjTpZ9R9sDSU0QDtZIKnICv5gEBGsvuJJgq54
	GsWiVYR2bDwwzsj9wgUZI7q8EOdYwG0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DW5U2ZbS;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787623577;
	b=eiq3CGNhkNZ2/KTxvgv6QP+SrR9RIOwO8QQDmkwofIM6SLIfVsVuVAVIAq2TSEmzcOkjzx
	EZuzPhhAKhmhoGui6E6Nm+ELBicW1fLib5V3cW//ZyRY5xP0uoZHhktz+ZO9inYuRDWRkL
	ETe1MrAc/iqDeg1lyh09Sn6SaAQbCKE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cme1RL/17bIGW33pWmOouQoKs0p8QtP4P5J2UaYG4Yg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787623573; v=1; x=1788228373;
 b=DW5U2ZbS1B2ieZk3WcsXOsthiN++qi8iuXF4dFl1TLwohf4uBqxAIl59Lwe7F2a2kyzx7hmp
 hNXqFf7slEs4C/WqxOyKOlwCn8Wmo1JILqV9aQGbaKfolOJaFdpqTBEzxvOfbznT7TclcgUsCkf
 /Pi7jFEuAAUkI19+W6rQuZYs=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.92)
	by mta11.migadu.com with ESMTPS id 17279551e972122e;
	Tue, 25 Aug 2026 02:06:13 +0000
X-Mizu-Trace-ID: 17279551e972122e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: use hugetlb_vmemmap_optimizable() in boolean
 contexts
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260824151655.30840-1-kaitao.cheng@linux.dev>
Date: Tue, 25 Aug 2026 10:05:55 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <3B304F17-AC19-4153-96A5-0F25163B4BB4@linux.dev>
References: <20260824151655.30840-1-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA257140005
X-Stat-Signature: h5u416ddx1uqyfbtmn9h5gb9nm78bz9b
X-Rspam-User: 
X-HE-Tag: 1787623576-407781
X-HE-Meta: U2FsdGVkX1+NyMOxOPXjKmKJnQb4v2+S7XoQvU3NUcZUc9iEjSP8HJ9T3E+rNsrLdNby5UsITS04+qK06jOhMk59NyQfBz8murdHPIgawUrfym2FIhtYDf2JsLHiH/9A7YPRXZ95Uwk4424J8PaSRJC8agn7fZmnEe2NJw1wflDkY1lRZeNgMjMe9lvKiZrcua18LxviGNmdbRXECgSzB2odFU9HAy9HzTP7J5EcUChb/QhlmhW3Z217AAccW1f9ezhhMGy15cOQyQIki26FLq5qJdzV1y8vnhv8y9nB8dPiqvrL4OH+TCMEq7LG2NNaIDwEqMZG0cuRmQbkfFkc1gE/5ZGUq1jHmHi8d+29zbp1LgMlQYkiYQg2v2QcFNVo3OVrXZnq9O6lxr4lApQZE+czJ5YVEcZEGN4ZndTbxtcjELtxrCSdouwApVBesCXQOeuRsJC30sI8mS39Y58leNunEFvlPIlpZUUaqsOYovTMApaonH7Jx2gc0jmMqV/YzOPYpHobAk5MU0R2vJs8m+QgS9tfnAUj1G7G86C1KN4q7Y+YqeyFS996k/7RQyHQhTl2+Hh/7vcY80D9YHhMlWGwp8/8tS/LqTwyFK9B1Ilc6GrGJELlY5W1F6+QMJoVHGIFpJgB3uGgDwiB9ZFRwNVhbajau68l8qWlSe0gYTTOe1ykZRw6ZfXXHeJgZzkrx1odyoVYKIZG/jkwhrLlhRyPysxJbkr89uI37BvyiodYRDVDhwvxdxR2fqGqLonAHJThdOg8Iz39N+Ea5b5U4UiWYvMWvfN2CI06YVFMES2agTW540dotmTzI1oRDArvmWyi0SX4ncQ95s6VyesbBTDAbEXDTheBJ9zYLmH4ELszYWjo0RgmVJtP+KVHkppNW42Rp6lJ+CYASZfiR9poZUPvI2mJIVTLqZfUud3OiJOnVpguy7NLYKd+NAK7t003R0FEvWCdaxuKj9UMwXA
 BUJ9JVXL
 KkhoKsFHCdn+4dew7AEjzHn/iv9q/aQAKxUmuPgCMXD+OIbeMJ/cCrGS5ey9hHhTo9tio6V5EMi0k5296LkRuVI/zuBnzNQuufWHptGr+b85BRF4NuC88+i42r5goHbk/GJGHQtIm78ihdD5IH4Rd+fPoSyp/sGzpY48mW9MlxA445PVFP3v04+wJcwNmb07j7IyCm2W3aXGhnxpwcPbKsO0GHczN6IPbC5FEnTF79vG3RhchQEg579s++RE2JClCMv1pYeNp7XzbFZ/sWHXZYv709KJ9/YGHLPqq3dvP+Di2tZuzVq2X8efvdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 24, 2026, at 23:16, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The two boot-time sites in hugetlb_hstate_alloc_pages_onenode() and
> hugetlb_pages_alloc_boot_node() only need to know whether HVO is
> applicable, not the exact optimizable size. Switch them from
> hugetlb_vmemmap_optimizable_size() to hugetlb_vmemmap_optimizable()
> to make intent explicit.
> 
> No functional change intended.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


