Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 059F7CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFCD6B0092; Wed, 13 May 2026 22:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55FBD6B0093; Wed, 13 May 2026 22:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4ED6B0095; Wed, 13 May 2026 22:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2996B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:42:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01BD71604EC
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:42:47 +0000 (UTC)
X-FDA: 84764477616.10.099BC0A
Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F13940006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:42:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=pQDPJwsK;
	spf=pass (imf17.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778726566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obws9dDHdh1Ev4pToV+dow1CQlh2IwjhnDC8RgrXid0=;
	b=ULXeZznNLt4u2B6hlEXw2yFqsnfK3H2e6RFB4XvxW1apJchkuZvikSUwzRFaFvM7G8MndW
	5Prjay699lggMSGR1j8oxWYiSLtvcjWEQS71b67d0vEEnDiHdtDZobAEah3R2TMlAZ1091
	Hi5nDx2WgpxFQh4tcM9tY4zQc4L8yLs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=pQDPJwsK;
	spf=pass (imf17.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778726566; a=rsa-sha256;
	cv=none;
	b=gsOrPVzl3dMi8citfCNnFr3KUySpGbKRQa/Wqb75mOmN1e7dOd7igRFJ8sQfpZx8EbJ5lu
	/9DMA+BJrdmhWL4z1NP2JtxbtlmiPe+YEjdXOqt23FQ7kVoD0UMHnbQMGrwUs4pKT9i+9Z
	fhE6T0u9MVxMTaW9eNXwAaGu+h2zb4o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1778726564;
	bh=obws9dDHdh1Ev4pToV+dow1CQlh2IwjhnDC8RgrXid0=;
	h=From:Subject:Date:Message-ID;
	b=pQDPJwsKEoqvWYs0AoSMWloW425uzp9EccCTEV53rJZNx74ktINrxzRJfC41nNOcR
	 CeMiwl60+crAlpxdjb0JVEv62eo8klEcP5UsPDsa68F8N8fvGZSMsjFd8svwHXGxx0
	 hpiJEx3/hXyzNa7K1cCk9Vk7ItX7JxMNNiUQo+Uc=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 6A05369E000014A6; Thu, 14 May 2026 10:42:39 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8128234456870
X-SMAIL-UIID: F00896C0358C4ED1A95DA11357443C92-20260514-104239-1
From: Hillf Danton <hdanton@sina.com>
To: Kartik Nair <contact.kartikn@gmail.com>
Cc: mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+bd6aaf99e8443d8a9034@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] mm/hugetlb: fix deadlock in __hugetlb_zap_begin() by using trylock
Date: Thu, 14 May 2026 10:42:41 +0800
Message-ID: <20260514024242.658-1-hdanton@sina.com>
In-Reply-To: <20260513211927.4206-1-contact.kartikn@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F13940006
X-Rspam-User: 
X-Stat-Signature: qxuesira6pyq7fwb1ukahqeix5tsuma5
X-HE-Tag: 1778726564-634798
X-HE-Meta: U2FsdGVkX1+4cvDP66HtkBf2Olt0+V3aio8QBwmBzlaEDwasjqJKdDCKaQOsv8TGpElwBabjekh9eMinhR/8C7KzACyf0xiRaybYOik3Gd6IwPp6vSeosayU6/0wr+RFghOAWDgZcEdaSfGP5awo1YKBmsAeS7oEJnegRt9dylmATx0nCxJ4lKuUkR4Ywn3AsUGM7X6eofHv5KQMM0e8mu8fLvT0DHfy+qiDrOwm1RIMtkHK6HtGmYEP5qp7N8CnpZ62eDkIK1/HupSoGRTYtaySLAhY3j5FsFo/PIpFu2jHOroOmP8Thl5T2J2Wng416RISQfY1htzeS6lGsVQPFI6EZ9JU3B+OK3l+7Y11KgR61YpjVVCggu9y7qhOhHkCDCMW9coQVX5Q9AKXnlMPoPk0nXrROmvPXCAdAVk2YGkzV3KDDhzl5cDv4LxqJS1RRnvLBjvAGim1tyImIgB/m50ZVmDCejSpUmz9cTXJWug2vjIGAA+Aun6m/q4T6wRjdEY7cy9F6mJ+/YCk+qQOIhKDW7eG654Svy0XUIu+Ji/jWDkxltcYUo5yACuffJI4LoWmJqy3TkU2JJPYN1umf4rygTI3Dwn2AhAa0X0BiHD7DeygJQo8gWBpJwHA6t2fLfXpRGBxN5TnnGTc5gMM4LPuE2nrLVh/qK0AYfpnALO+q265pJaPQclmMoFAc3EGJoFUI4PG3kCGqFxaoLf97eG+fNEdOC8SRknVm7B95qTdiSHojoQ/GDIdOQ0Puu49GyqE7K0Aw8iSmVPalql4ixh/3dupQKw6Vcplu78nfMb4oyOQq3JvZVUzCHCuweofxgu+t5hQg9Ih7xiX+k4qOZT0VROFA6a8AKbHuqYKP1cB2JUHS7K96Go/wDOvWm3XLcON91owu6jpjmh1NZvIARo7t278AStVKB7JMkl9p6vur1ShWerUfg/aaryWgXt7iD7dNbx2+YulwKWPoZN
 3BYqfi03
 BmvkGzlHHFSBhoynhKfJZZjf0SKpQEa49PNzTIwk4wnWl4WrDrmF1vlqH53nBGwPWmGgf3CGj8F0s8tTpZu5FhsPJ/+P6nB9qwrezFY0Co5g5ICUra0WyGHAtqfbvFl6llTLJUjmgUsyJwfm3iZXV/QVcCjryS0LyLp8FPonaxDjcXCZ8aRiR3/jjh4pfj64/6Px/F5u9tklHrKsq4kh/eQMwjpyn8m+yfkfDdYwQ4A1Sd5bsSejANx48GKQZB65E3889ZDpomgsiQgGnouXQE5fVgAarPipfVd6wu/4L+kktnjfNRSKZYDDEZlT8zKoblOB/lwSFHBMLjBqEdrM/Ur9CQUB4wjh0aeMVkO4bNFeJcJEHAH5ywQtzHT3+GmZBt2YkSveePtaeYO6ur418zxBD197bQAT06Lpav5bnm4Cu7MI9SRy+gNj9tjm2gVkKke//Ab3X7Chma0Tw7OOrnpbHZh+tj3jJol/ITkWub4iiM6y2imBO7C/4lJ9qCyJh8RnDxSo2WtRJsEsQe1Rfuxj5M7bFWXP3PYU6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 02:49:27 +0530 Kartik Nair wrote:
> syzbot reported a circular locking dependency involving
> resv_map->rw_sema and mmap_lock:
> 
>   CPU0                          CPU1
>   lock(&mm->mmap_lock)
>                                 lock(sk_lock-AF_INET6)
>                                 lock(&mm->mmap_lock)
>   lock(&resv_map->rw_sema)
> 
> __hugetlb_zap_begin() calls hugetlb_vma_lock_write() which does a
> blocking down_write() on either vma_lock->rw_sema or
> resv_map->rw_sema while mmap_lock is already held for write by the
> caller chain (vm_mmap_pgoff -> mmap_region -> __mmap_region ->
> unmap_region -> unmap_vmas -> hugetlb_zap_begin).
> 
> Fix this by converting __hugetlb_zap_begin() to use
> hugetlb_vma_trylock_write() instead of hugetlb_vma_lock_write().
> If the trylock fails, return false to the callers so they can skip
> the zap operation safely. Update hugetlb_zap_begin() and its callers
> in unmap_vmas() and zap_vma_range_batched() accordingly.
>
Given q->q_usage_counter in the syzbot report [1] and the correct
locking order in ffa1e7ada456 ("block: Make request_queue lockdep
splats show up earlier"), I suspect change to hugetlb is needed.

[1] https://lore.kernel.org/lkml/6a02edcf.170a0220.7f9b3.000c.GAE@google.com/

