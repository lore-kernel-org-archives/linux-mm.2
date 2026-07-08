Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05106C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11D66B0093; Wed,  8 Jul 2026 02:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94D26B0096; Wed,  8 Jul 2026 02:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36636B0098; Wed,  8 Jul 2026 02:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97DB26B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:59:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1425E1206E5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:53 +0000 (UTC)
X-FDA: 84964709466.03.558F247
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7ED2420003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kfb6BHsM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783493991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8g5jqgLjD951EWfoRZb50fh2tBQHpkiuCaoVDllV64=;
	b=7O2+jkA5/h3DKpsC85idwfINT6RDK0E4o+BTxNs1lUEVla4LdCLH1PmkdbxgqqwESX47jC
	SzGC3izMCEp5h4n0fragiiL9Ic9RPPY9G2PnPpwoO0BkOZ7maBYPDGuRPQiDjAEnruUmua
	7TM37AzNGOAUrLkQSRpqWjEHLFm/mEQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kfb6BHsM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783493991;
	b=jlIzVZFaweWZwv+Wc9D+o233ECl0CZo/ohzgNxlVAEZfO3K2l/tiEQzhq08NGuZIC/wysZ
	2+O1HjKgXJbkVwzrcruimwogQ94NxwNEPf4V8tOfKZylI3PT6/TAyp0zl/IGip/NQz/8bu
	SriIeaGHA3/aXVF+gSN7YzHLbY/VxxY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783493987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V8g5jqgLjD951EWfoRZb50fh2tBQHpkiuCaoVDllV64=;
	b=kfb6BHsMikwfRWrebJWraHz6m6y89IWGuNsz42BIRXCT5N2yrGBijRhl7tUhMWC3BipA5Z
	G9gJuHy30GUIk3YNlr0PlJL+2iuzFI4Y1fCu5jkibUvd8Cmv6Dsj8VJ8Z7P2kcgzTO3yFc
	AYYyw2HzdkSm0oU5UEWLQDyV9PAEPLg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 2/4] mm: hugetlb: Fix folio refcount mismatch on memcg
 charge failure
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260707-hugetlb-alloc-failure-fixes-v1-2-5bbd3a4b836d@google.com>
Date: Wed, 8 Jul 2026 14:59:10 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Xu <peterx@redhat.com>,
 Wupeng Ma <mawupeng1@huawei.com>,
 fvdl@google.com,
 rientjes@google.com,
 vannapurve@google.com,
 erdemaktas@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CBD2D5D1-CBA2-434B-8056-8D9A407EEEAB@linux.dev>
References: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
 <20260707-hugetlb-alloc-failure-fixes-v1-2-5bbd3a4b836d@google.com>
To: ackerleytng@google.com
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7ED2420003
X-Stat-Signature: hkgb61fb1drijq5wfs5rguxbegmnub45
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783493990-614276
X-HE-Meta: U2FsdGVkX19xYFAm7VdOPpU6ORAciHIoK6PE9Rui3ySCUbnWEiTD4cmQtux9MrbiiUYrviBaZQaZbM1/Ht1QgnL5CMVbPQr0nJYA0iY9tdxVmO2heDObbkCfMewMd42pP16XI9ByIyYegpkotJzdhLj3+5P76fJ3yjxl78NF0ijYdgcuYg1/TnlV/IwuBMH1vUAFN2NiHrsgMVGdp4+Cnfe+JhrxX1WIDuMWAtGpQ/DEKej956kaf9wjkx55bHIK5pHIPShfylgvRfwlU3ef5zgPT8vbgSS4n2MWrp1+GnTydcA21wV/plSOcDWVDHMwQrj9SsY1gbpyqVGwEs41pP10YoyiT3rywciuh0ZcHim442ohPZEv7bY8J6XiN6FxYEmJw8zkA8NHY1aQII0AP5ls1fNe+1SLeVBYptV2uENJUoe5Maolb3hATzc+gamn8BhMv8TCvL+qZAO4hklj28CyiW/twl53qe6L7UcSfSXKPF2jj3ywkpOdc3JCoXgBdFTg+rcN8OuX9uSO9P/KID8ZP3+vphS51DF3bVfyp8CiRy9Apc8qNNk2B16VvbAqpp0gxV7NsLy8WIkyNwf0ssZsSZaxGQXjTSEJA/6nETbD9QsLy0yVzxgkTlkiFuFW8CnGswr0i8DPy8U45p+aJA0sSgeFOKhToxcYh/ZYXyPBot5PcnZOuk69p39TR51+yY6BiyJGHec5I64yLECtgSoh2HwiUw9pHeOoiTboc3OorA0AfZtrGBueEOP72Z/C/OzHrfcjEZBiS5xWM7cRY4fs/1Dgm4ZOUT7raPLtXra9NQkkBNZ1SuY0vbhk7PjZw5WwssWRQ5pjTn5Nc83Dm+aMdX6VSlP3FnO4apt5LjiihwRi5bFpzo3JIwpqt7ZHpS+J6QjZZFeSmxSBXUpEsIJbh/yOMqGjka74iCj1SmTvDtoKc+ncLBYhHJ+xBqTzUbs5Wy27udT5UDJ21Dh
 dzv/RRxC
 K5y5NXrYS3PvRUvVlYQ8Gn2cD6m9pUotWoklMvvaNDhr0B6PckvIll8GYOypYeKe4uZNBmVHzEPh9LXutsOjNXBX0y3aSu/x6tIdGVmN4DZynjq+4DrHQ55tNmKHlJM7vSOfh5KVhnEtRvgF+6f85umF6206IugSn8peu+ASgupNsyz5SHlKC1/6fFp3fhYTVNRYFJML56NJIO+Jt7qeSNgxZdIvvZRKZfnbnpA3EFRR50GQtxVsZLGwYFBTdYGGoQfperTQFQ5tEJ/nNfUzTpVzvQnMV//yL2r7kR1BI9DkOEyR98NSLAa/OvlGgafg599GZOUvceaDfpxA9LcdcPyEo7WLnPIAXa9P59pNbQ2P4l1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 04:46, Ackerley Tng via B4 Relay =
<devnull+ackerleytng.google.com@kernel.org> wrote:
>=20
> From: Ackerley Tng <ackerleytng@google.com>
>=20
> When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio =
has
> its refcount set to 1 via folio_ref_unfreeze(folio, 1).
>=20
> The error path calls free_huge_folio(folio) directly, which expects a
> refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) =
is
> triggered.
>=20
> Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 =
to
> the freelist can corrupt allocator state later.
>=20
> Use folio_put(folio) instead of free_huge_folio(folio) to properly =
drop the
> reference before freeing it.
>=20
> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce =
mem_cgroup_charge_hugetlb")
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Yes, a real issue, I think we should cc stable as well.

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


