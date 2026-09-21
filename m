Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F15A5C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F6B6B00D1; Mon, 21 Sep 2026 11:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77196B00D3; Mon, 21 Sep 2026 11:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D2C6B00D7; Mon, 21 Sep 2026 11:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7BF96B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:31:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F9AEA0219
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:31:47 +0000 (UTC)
X-FDA: 85238159454.14.904CE07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7314340004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:31:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nThAib49;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004705;
	b=g36URczm+U7Kcp5mcXCpQ3ONAQ087h4S3HdDfUuntLjkIeJKoRyyTatrIsJt3i7cnLAl90
	O+z/v6vUqjq/kSu+rlw4gLQ9o5XiiVRJ9Px3y6+NxFtlIrYsFnJWsleTpH653OHo6rgAYL
	6AryncRmKWVGMnDx856zkcy4mvZBPBA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nThAib49;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abP5BF1UTPM+W6oosYSHCkF2RzGG+uzDkbZ+Vb1AvjA=;
	b=vvPVkGKiHkiYn/WIp1qH8gW60epeHFBhp5CquM347eF5/9esG1czutnpxKQukTtCyv33oA
	LHDTPbJIyXcxHH77u79dJg0qNhrZNrtJbWuTzIX70gudM0/IX6+9Z5YV0BhFLvCaDZnFNY
	HAhKiTBFTRdxeMBmlU34oo4lIKSn3Xg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA27B40BFE;
	Mon, 21 Sep 2026 15:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CFB1F00893;
	Mon, 21 Sep 2026 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004704;
	bh=abP5BF1UTPM+W6oosYSHCkF2RzGG+uzDkbZ+Vb1AvjA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nThAib49IgYbQaKbrt84+T2Fh8oVMIfL/MRvZjpHS65Af2NXFBvgwg35bV/5hzMGV
	 k2NX0Gffa1TRONHzZ+cAC0HFUSf88TAQNJ2mPGe7rx8cu0sKlF88v2V+ZlRo1oBWpi
	 La9bNbShkwwNFly/uD84JXublTgbeCg4wwlxYbukPOYriy6j7jEc903zxGnEY5ZvIP
	 ZnWmErG2lHlibDNVY5rUv7AErlmCPHUsZVvkKbBicxqqsK8Qsn007STiLoyAcuoKf5
	 NiWomskz4FH1bIJV1+nqWzRq+TG7LNoiDWx8xjJRL67WsGdOxSWVWik5gUA78RB5Mo
	 20R10//6cbLUg==
Message-ID: <650657d9-630b-4338-b7e5-8f12e4c59efe@kernel.org>
Date: Mon, 21 Sep 2026 17:28:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] kselftest: mm: remove check_huge_shmem()
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
 <20260921-fix_split-v7-3-d25ec991159f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921-fix_split-v7-3-d25ec991159f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7314340004
X-Stat-Signature: dxamtn5h5tfr41ae4docjozebkrunoi8
X-Rspam-User: 
X-HE-Tag: 1790004705-87994
X-HE-Meta: U2FsdGVkX1/rBMZvQ4N9si6GmSrHq/tmCgxRMhjLFA3nzhC19chHO4Ie6VPBVjAIenU4pXupGFi/WjsQGpJ4mAVUf8qp0PWBd6fV0QEyfni1PN7VRLwbBUbAd44w6Ums8EBy4JxiYpCM+DhiHHVuE1typ9K02AkbvRQVTJ5ohroR1bkaWMG00SC2mnFhhplv7JEl8kZavxMrvhPboONkHgCCQG0an8rAIEeYfF6eTUn9tkFTFZQ+HFBezzFgHEGvPdWbNiiSUWJITE6Arlqfqwhqbj5nd+XaoGb0bNz2DVZ6Gp+/3nh6XhltHtaU/Wf0silz6H+jkAz0MsCvDEq+DASFbWlqJxypUORCSX5B+rtbJlFFN1rAABr2zlJv2OCj4LJ5ybbMCzQJVsU+/L+YLEL/lJfD/nQDzqQL5m0wFXEb+IQGTl4L78FOkfpYwD1dpxKBkDvIJZVFmkXqGpng0adtIJ2qOgz9UjBsaS7P90/LeT4pizftAWRwVVWK/s4oB3lHrjwBWC0uDdBz8wFIQ8B7N2MRbS6gme0ljRXH3FKdMLqgyBx5EgOENZMg1f6Q972bBuwXyB9BAN6XexElyWJRi3PorwqJtFCG1PKEgx2IsbDAM15H61PbW5PM3cPBhN/BARqD4tuS9XXCHZyYnwqweUVjhc5v69ou+Mew0bscSmstPtI4n5fAB5NvxKkfK3xQ3gnT0GDiDlFlrrn1BIDrZk63uOj0DoIjsIp3eNpIPJYaFqpT3xmJCifketzkLNeTuj0eHMfdtyb/r+YfbDQ4t8S2xqKx10/9ggx11s0t5n3M/e+0sytJwhQ+7XQ2twpgjsvrCSLyzMI2Le60czBhGbROH8PbB5YIQPVjWGxDrKYmEC05p3s6HAu6L49upQPHFMzhFghxfY5fwX4yI8UmCkmCvzyPFVK93Xir9GpzHliPtxOuBpOjhR3+/28o0C9NPHS3PlB5PzSfhJh
 7rzOFW/H
 QPi95YWvU5W9hfSwLfr4nErxgRHSYT++dClMZ9GETATET1Ak9TLtLVfHIgaUwzHW6oXGqev8gW4/ylNCrRB7Xbj6wAUpB5ArEiKWus4AhPaYE2bH+UU8RezqUc3vsUKRjg5fvsyoL9udvB3+xq1olXHYreNloZDXowetrMc2UwiRhSNX2K4uI8t0I74edwfw8K3o492+XtKCeA4s7xcyrV91OKDBQ/ZXZHx7cBXj/TR2sWlr1jwcZixAFECi08SRT88iDE06nd5iOyzY4ShWVjq3aWDh34DpIW6YYQbeRYCXalyDKMPM6SwswH8ylgzmwHnaRkOwog2TcvX990dTl8lpA3ir265v4UOgfxz+vSaXUjbUGBVJ7LKOigRE/HvvRrtTB8+aLLI6T0kaaQCVm33e6Zq6r+0Ujr91A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 12:40, Yeoreum Yun wrote:
> check_huge_shmem() was required to distinguish shmem huge pages because
> /proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
> as opposed to “FilePmdMapped” for file-backed huge pages.
> 
> Now that /proc/self/smaps is no longer used to detect huge pages and
> /proc/kpageflags is used instead, it is sufficient to distinguish
> between file-backed and anonymous pages since the ShmemPmdMapped is also
> kind of file-backed.
> 
> Therefore, remove check_huge_shmem() and use check_huge_file() instead
> and cleanup khugepaged's check_huge operation in mem_ops.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

