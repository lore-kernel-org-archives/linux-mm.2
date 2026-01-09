Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E45D1A627
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDED6B0089; Fri,  9 Jan 2026 08:39:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68576B008C; Fri,  9 Jan 2026 08:39:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DB16B0089; Fri,  9 Jan 2026 08:39:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 872706B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:39:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3207413BBCF
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:39:18 +0000 (UTC)
X-FDA: 84312531996.12.36F5A76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6AEA914000E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:39:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfOOTzSR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767965956; a=rsa-sha256;
	cv=none;
	b=6CXZ6p4570VeqSAOenRMtHpKnpVrHeH1dZ6bM/ZY+1lEOzSYJQtG5rmUwsBRy1/5vcbmvx
	1V/NGG7c4xb94o4Br9f5WsGr2b+O+4V1MQc2048CWCfE5ch++xRAgj/ok44R5OljGHsruS
	QgnIzRkwjuBugXUiTKg4LZ5nyYiDxrM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfOOTzSR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767965956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYB6Gh4JQVQNRZ1NAYwohtN0GLTwbut5r93d9lqZjD4=;
	b=MlILu0ZDD5+L0UYhQBo6mdS89AT6aZAQH+4JhXx2jIHzpgVevDZ/p0eHOpzj54P6zYeYDY
	qjFzeh0QKT0gZwfOg76skQQT2YDbJ7boFzb82pv4Chxd4s0hRbk4rtZoGm3VlVa1egA6fn
	O/OJ4oBYA5tKIYhGMIkGnoBNinr0BrI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7FB860122;
	Fri,  9 Jan 2026 13:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10482C16AAE;
	Fri,  9 Jan 2026 13:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767965955;
	bh=1dPK506i2U9+WjR9nExbFYZAgBn/2wtpSi+tYqMsfpU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tfOOTzSR0lNSJxCRfGRDE6qkkN79kEa+28zbT7JNP9L9D+DfDzq3leP+uyflJww/n
	 a6nFO5vo65KQk30H0/sUTgm1dd9xIFSFOWwp1TIvdvoNGAAEwAIeeTMzDm+FTT6Vkp
	 QWovGhbbmg6LpiSFQuXAuEpva4aESEQ8CCPG9jnr09Nl5fEOHPTULOMC8wUJtBZPzb
	 Ie6aRjxkVC+gP0fELUkHSx8UJIcBk92oBnOjQIpQ9OWBiDO35mDVAjln+6hP7Iq0A5
	 0vamyVvetJJeeWnHLdeGmpLJec19ygROhxOak9cvvTO8QgQUGBB2PXIVGfvLgMzq15
	 kCtR1JQDNWO2g==
Message-ID: <920c641e-e092-46f0-89cb-0f1c130d979a@kernel.org>
Date: Fri, 9 Jan 2026 14:39:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock
 ordering
To: Jinchao Wang <wangjinchao600@gmail.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260109034723.1342798-1-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6AEA914000E
X-Stat-Signature: b1ioh7p1kwnac8be5gxuknae3i4t1pni
X-Rspam-User: 
X-HE-Tag: 1767965956-918757
X-HE-Meta: U2FsdGVkX1/EoM6xwKRuyjrSUpATq6B6ZyV18YZLHBo1Bcq3T5CHrMC17AF4QF6eNyIyZhSbBxts5q/R6wTc08YjxyKN5x7Yj+yIX/ezAWfCpteZHd03YEnP5iJ0HsClPKukKJVyQvpttvPDw+MCwIJ90YXii16lhOVDH1xcCInVyXCH2VRH2hygKx4r6eK1Y4DPYWL2EdLUZp0DwVBQhPKlhKUaSf4ZUdbNxt8H1DnskGejvryCNH/i++vfcUIdZaVfoxRoR/uJ1td3RxQOM6E/bldKdEbFH44eWCXBV4XM7U7TpHsvP80YcCkVuSfDnBwgb5MLvQQ3D8/qxLDIRgMeTD6r+QFb+MjOE9RxVl8DGKQrjZyeb2NZKLIDVLYA3MgCilDcEWcAcsOqD7MNwumFAsof3boY1iZ+JuxDBBMXKbnfUly1zU4KWdaW4iZGdGGfqCm7Rl1UteXzGdSJjoMua9rMP1L6Ld7tMHqOtLSsYzCviqgDEENbRwFEkFrDstkLUhz1M9j8fGDUm0I1NGnag/qgIByyECTKhXfZnQXVkZXktwMA1gMDzLJQRFxUmm+y9f6Dio2cUqtTb9KWOWtM0WuRy1Rs+8Vfisqj4aAOiOK5oLLIZRAwztw5tLeoF/mKxMgQEcCIB9BaLpuvVZctl1KW/6tILR+ZFdBUtdf3hh9YVercrqaTq7U/pMqyWJcSxF4q68ksmm59jt9G/wATAx5babbhLs2Hb8o5AIi8jkGqny3OKDkWL/aqSJQl32taUA7VKxtlSFGzOWDc2WEnS6ztVD6zAUCJyq3MnlfjnzafmsBmoRYTwVlrLzw6LrNrvcpUdQ2Nr+7BqT3SbVAMT9K5OJaNr2LG6aqS7N5Xx9nYxavn5nIkWIuShhVVuunxyaBf5RIAV8DVYqQnyN4S5llVhkW6aICG/ZlxsRsp0bAJoycYLpnc5m/rjGha23OLQ5uzM+oYCz3hCEG
 tyuAQs+8
 JK3bJTVnJuqaeMCZfVaF7VppWm7BSWh90TweV/izn817DHMuubwUO1DBi8TtuzspuWmSCrgcMYOKlUL3VKoGjpe+0+XncCgA/CEo2YT2Q0jFsfzuH239ZZv7jjjPA2wlJbUJX7v/NlSihyGb/LTO/JRHawTBzCxPVhie01hnxsy0UdHjmAEf0kNIweRytT/8OiZ96PCpSMHJW4+qADb54+hnzqo8Og8Gu8J1WD1cM27G+apj2gGilEfSvpBc1vxrUhpqw4KvJzOfBVu2PG36yhm4oJ71b7Q6k5RpK1ddfuc7G1PJDQru+qtSL3WR4/JQZzaO0NyTI+p7/wOtM8dFfdr8tniUCN/5kuX8TPrUcCoW5FMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 04:47, Jinchao Wang wrote:
> Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.
> 
> The deadlock occurs because migration violates the lock ordering defined
> in mm/rmap.c for hugetlbfs:
> 
>    * hugetlbfs PageHuge() take locks in this order:
>    * hugetlb_fault_mutex
>    * vma_lock
>    * mapping->i_mmap_rwsem
>    * folio_lock
> 
> The following trace illustrates the inversion:
> 
> Task A (punch_hole):             Task B (migration):
> --------------------             -------------------
> 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
> 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
>     (blocks waiting for B)           (blocks waiting for A)
> 
> Task A is blocked in the punch-hole path:
>    hugetlbfs_fallocate
>      hugetlbfs_punch_hole
>        hugetlbfs_zero_partial_page
>          folio_lock
> 
> Task B is blocked in the migration path:
>    migrate_pages
>      unmap_and_move_huge_page
>        remove_migration_ptes
>          __rmap_walk_file
>            i_mmap_lock_read
> 
> To fix this, adjust unmap_and_move_huge_page() to respect the established
> hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it


I'm confused. Isn't it unmap_and_move_huge_page() that grabs the 
i_mmap_rwsem during hugetlb_page_mapping_lock_write() (where we do a 
try-lock)?


We now handle file-backed folios correctly I think. Could we somehow 
also be in trouble for anon folios? Because there, we'd still take the 
rmap lock after grabbing the folio lock.


-- 
Cheers

David

