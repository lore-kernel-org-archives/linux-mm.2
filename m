Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C6FC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933966B0005; Tue, 14 Jul 2026 00:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896676B0088; Tue, 14 Jul 2026 00:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737A76B008A; Tue, 14 Jul 2026 00:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48EC66B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:04:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8C381C01C7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:04:36 +0000 (UTC)
X-FDA: 84986040552.01.FDC6308
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F26BC0009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:04:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Uk1WSl1b;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784001875;
	b=2NtiLmaSbp4lyj/h7zwFZh25fEqUcAbZVcJ7+83re/zAEcq2kGLjytaArOFMrDFNJALYac
	XXcZfF70CIddudrqBtX5GNfwAoRW0ZQN7WOdxwvVlBIkKbLxFKuMO2GevE0X6DgKQwIMWZ
	U1HJ1b70OAhkGrptQpLJdBvr7h+SYpI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Uk1WSl1b;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784001875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8e5QwFzOEE3DTcxaJFQ4C1se1WuaDb4/2mYW5ZmvOI=;
	b=XiWpopvtgglBcXQKpljmd59UI6J8i9mfVcyRQVyHOyxax5hFAmYYK5gT1YUbd9cDCam/d7
	mv/SeLYeQVtfqlTtxbBMqdZuG/v/PXbuUcqwqfbWRc9Y3TYeC4kALFX9MUor+YuqCK8maG
	QFHkbHLl2Zd+hWwowU+R6ATzsXThe1c=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784001873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b8e5QwFzOEE3DTcxaJFQ4C1se1WuaDb4/2mYW5ZmvOI=;
	b=Uk1WSl1bZgrN/S9B8wc/UXqr44eSqfDcnIkTgpqhfZXIea2daRtcBrV6YEWiD+ncupy3Sy
	P51KVc1qBaBq4zNfWTsAVu0tQ9b4laiIUJnvW20yBO64PFn3kKUqz3R5qvA3N8sUY73GTQ
	EU/RG6SaY++MB26rPfL5CHwVamUlFEk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 2/2] selftests/mm: add hugetlb_region_cache_race
 regression test
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713171456.300518-3-caixiangfeng@bytedance.com>
Date: Tue, 14 Jul 2026 12:03:49 +0800
Cc: akpm@linux-foundation.org,
 osalvador@suse.de,
 david@kernel.org,
 richard.weiyang@linux.alibaba.com,
 baoquan.he@linux.dev,
 shuah@kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1C8560A1-1F70-488E-BB62-2407B115F7B5@linux.dev>
References: <20260713171456.300518-1-caixiangfeng@bytedance.com>
 <20260713171456.300518-3-caixiangfeng@bytedance.com>
To: Xiangfeng Cai <caixiangfeng@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F26BC0009
X-Stat-Signature: dp1gkb5oakt9m3nztx8hhd61urkt3s7w
X-HE-Tag: 1784001874-935144
X-HE-Meta: U2FsdGVkX1+Acv9Qbg82nXFehNIiihV+XWIivWwgycIwuUHQp0DIi6Tz0F5uOCFEE6MmANO79F1uV++k0LvQyH55C3T3cimwAPCmzqaXXFFizFSByOmwh8b1hdruF4ExESulfo3quejhl/xqo51z/2fgivvZc7pfDq1VKuEjPw982uRm8o1LmM9yYWU3HSQZRV3oj5EnF88Ki9/QJl/q/kopmSHFZjk7RndtzHug40mllEFlv/m/RJYDpXdzjYjh5VoLsYaEcRCi/80aFH7mYg3Xf194kRUAku5cWt8oA4h5Phv5kDsWFurGUhdUapgBSpx0MqCjJ6XoBlctPfXvUx0lpCN1NJcfzy9/eFB6gLf8rCXeUGex05F/RdxN5hJ0AY0FVI1N7bIlvwclxrkpTgisa7coSRFBVAVbktJEpXZB7+fKikLXnBcNhWg/hU8afFE3ut4xPHx+d54UvoQIWZnDjaYLucALTVJtGJVGm+we3Gh9M/NQCf++yQoMxsM9thZrXQnazl2IbcwiT0hjtLvnJn1CTx7Wk2laghPSXaDG63OXmRjbU01gCA3TqL6MROJb3rOf9vJuAsNeY9EpsxUpyO0htdtvbA6BooX4/kt92RYiWiTkONIVwjRo9KM+zMUDwYrITcZrAGBXHcct+b7toIfDeAk7uBBkObpSkn8XEeppj2+kq8BDUZDrwvUjxNF5XRDf1z1YxtwSUv+nxqzeTND7S3MjvyYjUpm80/6X7Oead0m00j15srnmPnMMehrzl95U5+PRtqPyTdxJkkmwMoye/m0qMF9nsHrt1qFrfiYbGY68rqWeX+qUlWsjeu5HpEGD5p+GlPRsZSri1HMQueXw12LEu5ff2WVWDLCuJpopq/ImCfPXssrZ3VAYHj0fTBtLItBm84JRzc5mUEpAxBvtWuH7kyVNO3iQ+5ewyliPYaOwZBxdrVjWeKm/FYa7gZCqk00BFfzZL3L
 zTt+cY0m
 ihjRkgZdQ+a0M0CBvo2bzVgThd6yH6SnyvnJ2uAW4H2UG15OBZaFqfnP3C8veiQhYC5WUruVkbcmPqrUEHqE5DmtVOcgue1lWf4uZb6ulaXWgJsHgpsUHwvz6q6J9Buf7B6g+7LNe5kK+WeQ+KBaw2JNS4YOUTd/luswm9IhqQPqABtQ64/EdB2nfSKnZwmQvu8eNDtHTIUJk1EQ3aEoLMnJ9+WLBxMUnyhByFy75Hur4W60fx6UUpWj+jeduc3aq4S3fdhw4Rt2nJrie2ZuuT8Boa0yMacgBpd3BuAy/2R7OyPVMpLJIRFfHMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 14, 2026, at 01:14, Xiangfeng Cai <caixiangfeng@bytedance.com> =
wrote:
>=20
> Add a regression test for the list corruption in
> allocate_file_region_entries() fixed by the previous patch
> ("mm/hugetlb: fix list corruption in allocate_file_region_entries()").
>=20
> Triggering the bug requires a concurrent reservation operation to =
drain
> resv->region_cache while allocate_file_region_entries() has dropped
> resv->lock for its GFP_KERNEL allocation, forcing its retry loop to =
run
> again.  As the mmap() and fallocate(PUNCH_HOLE) paths serialise on
> inode_lock, the cache has to be drained by faults from a separate =
address
> space.  The test forks several processes sharing one hugetlb inode via
> memfd_create(MFD_HUGETLB); each mmap()s and faults ranges and punches =
holes
> to keep the shared resv_map fragmented.
>=20
> Two modes are provided:
>=20
> - default: a safe single-process functional check that exercises the =
buggy
>   line without forcing a second loop iteration; safe on any kernel.
>=20
> - --trigger: the concurrent reproducer, which panics a vulnerable
>   CONFIG_DEBUG_LIST=3Dy kernel and is therefore opt-in.  It faults =
pages in,
>   so it needs as many free huge pages as the file is large.
>=20
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiangfeng Cai <caixiangfeng@bytedance.com>

It looks like this is a regression test case for a very specific =
instance of
list corruption.

In my opinion, selftests should focus more on functional testing with =
clear
expected behaviors and results to users. I don't think it's worth =
maintaining
a test case for a minor issue like this, especially since code changes =
happen
so quickly. Once the code evolves, this specific list corruption might =
never
occur again, and the function itself could even be deleted during a =
refactor.

Therefore, I wouldn't recommend adding this as a selftest.

Thanks.


