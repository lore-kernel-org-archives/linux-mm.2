Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D07CD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8176B0088; Thu, 11 Jun 2026 09:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958AA6B008C; Thu, 11 Jun 2026 09:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E8C6B0092; Thu, 11 Jun 2026 09:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 721C06B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:52:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06AB61C2470
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:52:27 +0000 (UTC)
X-FDA: 84867771534.01.CAD92D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6BFF514000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:52:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dM73evRg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781185945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trCpG7OYfxnjH2p0gtbocSZgOkcD6A+aryRBCDUbrkc=;
	b=J8jp2oPv3Cvo8emIs0ow44Es5yrlWgTfmIkAqLnbzlE1LDm+AC3cypcTsMZEpo9r8QlD49
	JVzvA2rlAf4CHIBa+BYC4pIYAtrteE3vIF/kTYVzG76QfAl+GBxeQ3JBNgLZJeQw0IfrYI
	KScDsWTAO16YoMQiW8z6eh1ZsZootDU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dM73evRg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781185945;
	b=jhsmgKXWslgxM0iNUX+PvvYInFJONUgLpJAeXe0X4QDyem7s6DKpH/bdmxBQmdWmD/075v
	bS+HWymhmaCGJ+meIx0HiX9wZJf6xyIj63mWHWnqhXZEQQeJAEKDNF+nA/1rfKo1e/Z6lG
	lMh5ZeOh7Oy52qALJHWMPc1qdbuHPl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDCA9600AA;
	Thu, 11 Jun 2026 13:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BD21F00893;
	Thu, 11 Jun 2026 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781185944;
	bh=trCpG7OYfxnjH2p0gtbocSZgOkcD6A+aryRBCDUbrkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dM73evRgIH6Tc0t4MT6FmSArUfNHA6XbB0+n3hG2uul6GVQNExDXuAKD+omFLkxXq
	 L9yih0T0Hr7pZ6W1rmjbx8is8+cgZ61chG+VdVg1KTOp4YrRQh+moiwslzeXmYib96
	 QmwT2TabtDoEDkyjB4FOFb3PiWf8GGJsnyfiIPQ3HBvqYA/GJ/4oICjbiHK4Y6IvP0
	 ByTLMlnoDUfkNRVHy70E/eju975PEOPc9zScG1x5FK/WI+wSaDk+lPtN16CeXoWvY/
	 M7AgL7l2wUwgkuIvRl11zk630XGtsTT65nVCKpr81I4+fChK9tUw6vPaRXBYRlJxni
	 8Joe3Q7i68zJA==
Date: Thu, 11 Jun 2026 15:52:16 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: syzbot ci <syzbot+ci07d784447d67ca63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, david@redhat.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
	osalvador@suse.de, vbabka@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: Implement a new generic pagewalk API
Message-ID: <aiq9kD3loZWsfZTN@localhost.localdomain>
References: <20260525165528.184397-1-osalvador@suse.de>
 <6a153468.050a0220.7dd1.0004.GAE@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HNkqtG5OHNgJiC2N"
Content-Disposition: inline
In-Reply-To: <6a153468.050a0220.7dd1.0004.GAE@google.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3ueoyiy3pg9sz11tenetc6bwx4kj3ayo
X-Rspamd-Queue-Id: 6BFF514000F
X-HE-Tag: 1781185945-301816
X-HE-Meta: U2FsdGVkX18od5Ql7BxaDbkNp0BlGLCWO2EyvxE/hGFIgrea2EoeJfPAfLNMKedZZlixhLjGtGHFu8ab61lGJU6kdT+82/PbodNlN9Pa21GbJFXaHulXL/CmQqj9vCNCQSYJjow5b0NtEhwBRcNb6V3cBHRkKes6/KXU0WV9MWCROdbpEqcxAw4fRiZ4TFlkKEBuj1vG8g2K4kN5cpw5ithTuuEy75EAwtmOA0CUUD3MoC798EzCs3l+oWMlMhe4U1UP3f6wcKmaaCGDTDdUUY6Yy6yb9Kjq5BELskaT4H4wRkcteHmT75LvtfDrpMEN0I7dhJxS74XtEFKpwQnqP4Me4lokjNDhVUDduSZVEWHMbs25MNQ3ZtjLNJpqVqX+6/5rAt3ftmpoR3VqCZUwfJGY5FPHHbBsio/gYjxWkifzySBemlzZWIPLxWaf3TAmNniTHh9BH2x6xMbz23NdvfkbE984B8R5J8oIJcaRD6pQqlwXsJOXdCGoD+KJAlA6yB9C6djX4tyzkXwxIHjVSpDHLoKaNieprhXBr4l0uYp2IuULz7GDnAjJlhOVleNNayOq688wN9ye365FqL7VyN+cV/na+l+BA3vXoGBM28vCsUpcvwmrw7IUHj94J8EQnbeHINmp5L1QSQZ5pTAWn65HIEeTie185z3HDspi6nA0ideFRY9Vqurzz5ub4ge4eOEdJ5nbOfrPUAoHK9K8nj5pvpyaSwhxrqSuJo+EH9yfmHLMJHyynxIqlkF9TKjIvYsfOc0q7X1Bwda913xZwLfGbIryWw6TwcFgH2kKlj2HOtCSKDahUXiGaQ3w1MFaZCFwL8hpEuW81G5k/H0+iTH9FiFOuWWN2tsy2iwAf2qA+u2SwCQdIyy+vrrRp9khHuq+za1t+Igt7l1GPBXDtRFIkdHK05DEoYfcdwwAnXYtjB4MZgsTWm8fg7Uc5MtkwBeMFl7X7jy6Ht1MGzU
 JIy0io53
 iixgk30wYrkrAFTRhKWEdmCAV7BgoHQI93w3IFlQFVfV2N5IdPVNo3x0BEqWNCfQveFPRGKVJ5H7zuoD+ogWRMU490dJryWQo0ccnG9dOm1J95ENeOlQaXn7+8eBOpB0NYlX6AbmaCNF5rLSrqhyIjawXSmPffIWJoa2tDLIVgYdPxlf/KcMhTYH4wQcxKk/MRSN0uy39/7rEloYbr5AjHqKYu9PR+MIB8vIDnHZtE5Uq4F1PN5eMykFPcguaNKEq1R5jNIntQr0ETdPs0UdjM7vvysC4QT2cBj6o0PAMakhRX5ZrShGoELA8Ut4ue7H1jqTbtrh1IyUG4I7Vpnvj6dTr5FZHSpPJUhySUObaY48sT1V8JH8mOYMFkcJfqP2YxC+PBpwPhOZmOQ+sKtwdZZzj3TO8D+q5W26zUpasp8KlA/avvxaE+9KX7yQwjyDbQ5yut2pMvI30b1fCLPfvoMsArClnTtXXj/kOwGlRfknz/ly1s/V1ek3w+JlVny9O9Q1cxf/TegMKSZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--HNkqtG5OHNgJiC2N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 25, 2026 at 10:49:28PM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v3] Implement a new generic pagewalk API
> https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de
> * [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
> * [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
> * [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
> * [RFC PATCH v3 4/8] mm: Implement pt_range_walk
> * [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewalk API
> * [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
> * [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagewalk API
> * [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pagewalk API
> 
> and found the following issue:
> general protection fault in clear_refs_write
> 
> Full report is available here:
> https://ci.syzbot.org/series/0beab2d0-9d88-4288-ac81-b294e51c057d

#syz test

 

-- 
Oscar Salvador
SUSE Labs

--HNkqtG5OHNgJiC2N
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename=0001-fix.patch

From 59776435d1beca2bd9446050450afe04453a99e8 Mon Sep 17 00:00:00 2001
From: Oscar Salvador <osalvador@suse.de>
Date: Thu, 11 Jun 2026 13:58:44 +0200
Subject: [PATCH] fix

---
 fs/proc/task_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1134dfb3dab0..fadc6356f84e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1710,6 +1710,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			else if (ret < 0)
 				break;
 
+			flags &= ~PT_TYPE_NONE;
 			pt_type = pt_range_walk_start(&ptw, vma, vma->vm_start, vma->vm_end, flags);
 			while (pt_type != PTW_DONE) {
 
-- 
2.35.3


--HNkqtG5OHNgJiC2N--

