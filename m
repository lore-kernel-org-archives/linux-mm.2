Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A01BC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93966B00AD; Wed, 21 Jan 2026 13:59:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D417B6B00AE; Wed, 21 Jan 2026 13:59:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44116B00AF; Wed, 21 Jan 2026 13:59:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B09316B00AD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:59:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29020D3BF4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:59:20 +0000 (UTC)
X-FDA: 84356884080.14.1543E2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4BA2C180007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:59:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LAaCILBs;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769021958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyKCzKQcat9xQRKtBLqNBwPnKez9HbItxXS1QP1WUTU=;
	b=TUNb2mwDgjle1FkQbH8hp18Mpi+tCnFCjbSj/rSr71Is6P2EdOy0ukJy2fZYVRgsg+P4bs
	Sjf9hVI/O8l5FngLUt5Nm5ulxpbnG/+dhM64nMqJfdpSostmZ7gScsSlN+QCrfmBq8MV3Z
	5phYuRjhOw/8Vafb8tdnbcqz2PL0FUg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LAaCILBs;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769021958; a=rsa-sha256;
	cv=none;
	b=7reLwTBHIF+IdYxO8S8DpXdxIqs96uj8LAMkdQVuNvEaLsLPvBdfNHIisFXxicKSsjgYN7
	2m6xEm8tAOM0Q1kO5BIU7w4iqwFVYDPQAsCp9B6O/1lOTZcxF7zMI6WkauO+ffRvEvzEsO
	hisvFyGzfzgnFgMDfSAB2Iid8NuGhr4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 195C344289;
	Wed, 21 Jan 2026 18:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A485C4CEF1;
	Wed, 21 Jan 2026 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769021956;
	bh=DWqS1noBAz2W53YL2gP12WFcJbgEDyQ85hEn4oupPsQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LAaCILBsOG6xdGjri7YkqOs2tAgWkMDoUBaEYDi+zPpbCxH26ziaKzs+VTggbhVst
	 O0ha7wMbZ5gn6njaqQROzMKFm41o2Fy/af4OfEBVVO17FOX8irPKJGjvxRn0xgHGxW
	 QhayMrlPTcNkYAnK2p0Iu/nKuQd402IIvAWKhezU=
Date: Wed, 21 Jan 2026 10:59:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>, Vlastimil
 Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com,
 nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 00/11]  Remove XA_ZERO from error recovery of
 dup_mmap()
Message-Id: <20260121105915.5513fb9de156c3f415a1dcd3@linux-foundation.org>
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4BA2C180007
X-Stat-Signature: skkt6rzcrc876t3y8j3cxhmy8d88g86w
X-Rspam-User: 
X-HE-Tag: 1769021958-619450
X-HE-Meta: U2FsdGVkX19r+ghxletZN4KqSfRXUEl7nEq/svXgBWitFZmWtrQXP57+aK/gjALtSY6Moh0Al9D+Uhf5IV36FsehgcdQvzZM3QPbWtBgrig+z8Z4WM/5LRTwpB5wDF5oWZHBrJDLshBUS+Pv8hClnB6ophGhLfnm0/OcWSfUNmn6u5slrsPXP9SfvZ6QX7mw0JfN2sWihc3DwiczMuioqk4LiS3mNrbLG14nhpBSvLK1iJ3NifR01ZOPmZuRE58SdJmo7tbD4DeARQbXZOAl9lzF8ugkg2+OoGyCCFIJE/RJWqXGQnUnwJ8OKJjPIvrTTxs4EwtGn8k94XxGji1PqyVe/t56fNjySXMkkKO5bSZ/bKCBzXAZhmtuQenqYPH2+Oo27dtIrzZO/pBDJdkfNbZzVJitpgTvyVQPOeLVgOOg7t3U1z5go2RDUnSZA187EYjUWNqob5EcAR68jxxdS5HcEmi40LuGdpAuS+pTEteS4K3pMbwcBlYL6ymP8+ST95dDefHXLI0aBUrwHh/b9Y5D7ZNyJx3clX5xxDTvqnevDeUFP00UxfUKQ/HBg6xyo4mzdvihUCIFa5yW/cJLj+tGv2ooBsvMxYkVGG7gNa5F8wfZ40PUc4Q7VajCWJ7CyaYlUbW2hLpK20L7URrQfRSPzHtzYN0Ion2z8GQnS4mWninvpF9OBc0Llz+RwMFBE2ILoo+A2DSNZGqAgdOQDqNU7ZltLmvtrCBwz7DzPBMoQvh2R2icUoNoMQvGnWfmJpUyT0rAyQjveOYrOPj93EDK2ge0N9chDmX1zZKz4iPOMjPux3uRoszKtNXVn6FuqtiZPFL3zru17bj50uQWwKj1FnLgqnJ+ryRv6VRSfxrlcpF71YrK+s8BS0jfHlE6ZQyRxPDO4SHWxrwBGVYtb97aobwzVpqE6vXPnNOwL2XAHsK/fy1wCQSbtOS5A1BSaAw0NioUycvWEXm/CcF
 DdVCrU5Z
 hPlMUFyEJC0cIhqZtyc3fAO6516OZG0Ggm/RPmA2LvpUmomCNjFpeQxG4WvvjFt1D6dX0D27OhDGkRwwx/9/1skfqGvSC9KSoXJfpS+9YALWFG8lmmiqRyqLd15Izk+yqBLG9H7Ul8qQRRtKOxe6rS2sPnoL3w93pcBT9hDMyoXgzSDzHW+Q7L2pCx5VDkx9JNFXoThM9/ucGob89XxINaVIUqXwr2NyR9CLZ995pQ57TYrIbGUP2H/YQylnVN8svIkHDKHrhjoWKRzObcd6xRTAbgrbkqxchv2WlgoaooE7tBTxnzVmZ/GO/yKZif3UjnPx8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 11:49:35 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> It is possible that the dup_mmap() call fails on allocating or setting
> up a vma after the maple tree of the oldmm is copied.  Today, that
> failure point is marked by inserting an XA_ZERO entry over the failure
> point so that the exact location does not need to be communicated
> through to exit_mmap().
> 
> However, a race exists in the tear down process because the dup_mmap()
> drops the mmap lock before exit_mmap() can remove the partially set up
> vma tree.  This means that other tasks may get to the mm tree and find
> the invalid vma pointer (since it's an XA_ZERO entry), even though the
> mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.
> 
> To remove the race fully, the tree must be cleaned up before dropping
> the lock.  This is accomplished by extracting the vma cleanup in
> exit_mmap() and changing the required functions to pass through the vma
> search limit.  Any other tree modifications would require extra cycles
> which should be spent on freeing memory.

I've updated mm-unstable to this version. thanks.

> Changes since v2:
> - Fixed header issue - Thanks Lorenzo & SeongJae

According to my thing, this is how v3 altered mm.git:


--- a/include/linux/pgtable.h~b
+++ a/include/linux/pgtable.h
@@ -1660,6 +1660,7 @@ void arch_sync_kernel_mappings(unsigned
 #define FIRST_USER_ADDRESS	0UL
 #endif
 
+
 /*
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
_


So I assume you incorporated SeongJae's fix as-is.

