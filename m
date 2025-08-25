Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB31CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 15:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42BF8E0042; Mon, 25 Aug 2025 11:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF37F8E0038; Mon, 25 Aug 2025 11:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2588E0042; Mon, 25 Aug 2025 11:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B81F08E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:13:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EB8A1187A1
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:13:58 +0000 (UTC)
X-FDA: 83815624956.19.9304F44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AF945160004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:13:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bi3KNdil;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756134836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihnyLvMqFgwRsUSPEw5Tge2jcml8CkSqI+kjzDN6pmQ=;
	b=GrQbweN+f7AEFyUBiwoqHfVWhcpzO9tOBiSMiQ2pOjBBSXg77fRbiBwj21nk5/xi7ek2QH
	9dK29ec9ePrJr7NngpCpQ4dKcIPKSVw4RXodJ7f6yeIX9Eg+jkU55nDcNqW8ae01cP00+Y
	H7o6gQCxDauI0FB2fYXi/23SJUJySX8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bi3KNdil;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756134836; a=rsa-sha256;
	cv=none;
	b=OUh//aa0EjuAxyY/5GqjQiud2Pu/DVAKNZLs2eQ/y+lczUyJy7NdKwgV0EydkQBtcyDD1x
	puTmhdhYjj1TEFied762BhqqFigBkOOyePCfgNZXJO0zbYqmn2WBNXUHqH7OQbmCu2TNbe
	kG9u8kSVn41qH7MKTgTEHdjDTGFJ6eg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8A684341E;
	Mon, 25 Aug 2025 15:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E0FC4CEED;
	Mon, 25 Aug 2025 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756134835;
	bh=WZz+BEh/Ios9GLEN/uIEsnq1OHEvgWzXABBqfRy6Akk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi3KNdilY7L65uSGuh+wXZHJcTlHRrqDDZGm/3FiF5ruHGiEQNhqc6YfGiHitK+F1
	 dPqSNqGqGBBND2/c8uQCURQaRSadSmRLyY7aO7PKOxjv9o5bI4JZkH+ISVpn7hER8S
	 k5JaeR4QTvO4dP26VxEWXP6MQpV1IHzwkc/b08X7HGZdnwfrYFsweHn3TKu+maBWK8
	 ZgSq5xeVm+jzYe5970Y+VcwsuyIlASBk0DPRK29VbjOU3PBYXii9145mL4R7yTdsy0
	 SEM52H/4Fabq1MNznSczUogzmbdz2tgh3IClQsc1X82qdK+aO0o9LWf0LrNnmjj7xe
	 uuIAvIhCVEXFA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2 04/11] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Mon, 25 Aug 2025 08:13:53 -0700
Message-Id: <20250825151353.36392-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250822093420.2103803-5-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF945160004
X-Stat-Signature: s3qgfz9ki3qjfx6pe3yjj834x7pge9ei
X-Rspam-User: 
X-HE-Tag: 1756134836-989923
X-HE-Meta: U2FsdGVkX19qgLV+EJFo4QAV6VNa3VlaxsPtYgtDZ1curQZ6wUFFIZPSpsIv55HTzBg2VdlF1c81OP0CCa3GuARj+hdSHbRRAAxUqwgyke1OvChNmNiEo84vRUvbQQt5BwZLXpZC5bUWcEebqw96Ip04WeH4j/2yqm9xWClxaUy2kSFBp6W3LBKJntMkpfXRO/UTgYnSYu6Z+yGczMXt0Fk4GofTC4minBnsQ2KYVcEvw7fYc7jgVxbNGni6uWdIW5zPkWYNaTFESySSjtYY65ha33LSVSJQFDfai3GJQSDXQxYbkSsk7z8ru/i53hJ9+ZCOtRmkjIHYLsW+aZDpy/oo6sxMLvFI32YwIdhGJJNG+4lyIsMLuKD4XsqIdbuE0k2Td80P+/zgbzaWfuM1XQDxCWLMprBhkh/fYILMO4w7yLFpKWbciX8KdLUH5qmdiznZ1EU/keOkXq5BoiW/cRdBSc66P3TJtPWWvQJCX1Ver5qsgppPGZ8lnCONtooODKoZ28t+VmANIEqf9MMlrPnC/UZZhJ93qVYC5nRPmiTrmne8GcJ4u0K0Mo/jGeYGPjd9vE7IKlA+wg9S8lvl7zWiWMUKx+BaND/HHi5QY3Yzp0lgNjA9mZo4wz+cw81bxgKqDI/ibAnRnCOy7A2llVbAFaOmme6apfZlmty9jkPHNawSg3cjM+goR1z/P8IE51wUjGA71zSuE/0gNleKIJWSUVTn7f1mnBgaJymdG6Qrlgo+Of5KC+P7wxYI+kh9TpO5S7FG04GMw9rDuhjETOeILYj/6MpR5jxnHUKZiqbYTm2K2ajObXryUU15n6HyOceU+dDVBwzXEh4GDh+3KnQbfDswu9fRcz1YX1e5Z/lYMqAtszMy4o7Zk5qq/C6mPn+QKPR85roHac3u0Xqbyb+RckWSAL3NfKljAFpEu9lnR8aRVTl1YuD+pzxHwxZOslvzHMGDAsbnQ8nf7b+
 kD9Eomqm
 Y2tfJhWPs9TqjriK0qxY5/oEjZ6kO51xc+BBpCtgskgUh6Sd+0ExZOeYrQmKNHGhNsQc0cwCT9rmowUhUCvtOCspUU+m/fWlEYPXKZJMwkd0d74EkHt4UWvOuVcvRxlu3ASrJ8u1VxHaQWV19rr4z0EIS2iFR0KNCwRkHBXJF2DMBxziXI90Nf01MpCmAGxDNu0S3Xi3HyeWFzCH0vVi/4krl+6oyy7lYwgMVryCi0W2bX8V+zy/aRi5uwPcLZ8N75pfl10dss6bogMSMXOMhFfpHaRSbFWbz1k01z6BzygPKU6qwa2fM7eU0U0rz68E903n1gYf3kFLNgHoxFgmnhMQ6ZUPaMv5fNIImyVdFHOm/rxuMUQ+QaU9NmMOGEcHZdLR/vy2VgzPu5C4KF6H/CXD2EhE3kVzDZuPbyhDABbDmT+JCIr2N/fZ+AS6ZG9ER9sOcIGPuBFY621PiW2tH7daHn20hz9PoLqVRqUOU9f+SP98MZw30tmYbnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 17:34:12 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
> handling from the DAMOS operation implementation for the physical
> address space.
[...]
> -	return applied * PAGE_SIZE;
> +	return applied * PAGE_SIZE / addr_unit;
>  }

This can cause __udivdi3 linking issue similar to the report [1] from kernel
test robot.  Andrew, could you please add below attaching fixup?

[1] https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/


Thanks,
SJ

[...]

==== Attachment 0 (0002-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_de_ac.patch) ====
From hackermail Thu Jan  1 00:00:00 1970
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev
Cc: kernel-team@meta.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Date: Mon, 25 Aug 2025 07:45:24 -0700
Subject: [PATCH 2/3] mm/damon/paddr: use do_div() on i386 for
         damon_pa_de_activate() return value

Otherwise, __udivdi3 linking issue happens on certain configs.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 09c87583af6c..6fb92ecc513d 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -236,7 +236,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-	return applied * PAGE_SIZE / addr_unit;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static unsigned long damon_pa_mark_accessed(struct damon_region *r,
-- 
2.39.5

