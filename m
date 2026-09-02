Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90184C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9145E6B0095; Wed,  2 Sep 2026 05:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5E86B00A5; Wed,  2 Sep 2026 05:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4986B00A6; Wed,  2 Sep 2026 05:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 596B46B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:32:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D629B40134
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:32:14 +0000 (UTC)
X-FDA: 85168306188.18.50071C8
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id EFCE720002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:32:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oql95tJr;
	spf=pass (imf31.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788341533;
	b=riXLrvVv2517Ji5F1jtaTSRYXTxqyluZMvIww9NiuY8EqfWGNzIwLLEip3EcLeplV7Xku8
	eJ4qey1478S9f3uIZ/Z97Fn8AhqwTGtTFoyou3WCJP0qOa+OXAeicPqJ9H7SsZsgjBxaiR
	XISUrpEfZtY8NrGgzYYfZWa3Cn9bPB8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oql95tJr;
	spf=pass (imf31.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788341533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J+LXdYat0I4QNFciFBu0qyDuz5wb7/kssPEu1T1bfXI=;
	b=3rURly1xlZAakn76qXyCOIzNlj/qMoyvLaSY8JNedcNhpbg74c6gafrn5R1cFE3AVTn800
	p613/sZzybpf9acLIx9nMBM0rQqCTt4KFAWOpu6JImPVxr00Ua/reu+Jv+jEmnSwUaN51B
	MIVClNYhI71KovdWbLqduXy5xeIpvaA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788341528; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=J+LXdYat0I4QNFciFBu0qyDuz5wb7/kssPEu1T1bfXI=;
	b=oql95tJrSkUj2Np3Z+ijrFpoTVJ9lrSu6Unxo4lldxNCyv78VOLf7STeOyQMHlUfDZTJ0GGNZnKdU9NswI6ZJUbfbCjtvx0rJ13VuPIWZU4Vak0siq+MD8+dGKVNuSmhxssqv/pcYimyc8asebicjEoUWk8gSXxTBqxo8oLyuFo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XACEOlh_1788341527;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XACEOlh_1788341527 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 17:32:08 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v2] mm/list_lru: disable memcg awareness under cgroup_disable=memory
Date: Wed,  2 Sep 2026 17:32:02 +0800
Message-ID: <20260902093202.609559-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9kpa3shwh7jzh6pw35ewdai69ojzsg9y
X-Rspamd-Queue-Id: EFCE720002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788341531-64075
X-HE-Meta: U2FsdGVkX18LXDGoJDKw9ZKbyqwJWzJ73ueVlfXBplv5oZFGnhKPx83xXjy0YhyhCasU/2fC6e0EKhrvRpfO69wZY3KhV7Eek/Zkt0zZHoSCrAf+0iCF95GWTtisMvV3Xfd1U2slCrkCysv1VfiCyFPaFWT6m/3K+pXCmTwE/PAvw4gbhn8qf9Q+Jr4NTDFxXKWMAgGxC4j5rbZQ4812IzNbgS28jgfZ3xSsJuSdz7wXEcJnK192zBwHI7Gf/S+Y03g85rGksgA4HqQgeSpy+ImzAMS/GjkNIMV+CD8alPqBCxQKKy2u2lB3r2pHS11B/dVcfQUd3NxmoQA0RNZY24kalatAd59N97C6OLhPHKWMrtzRbvadq8GJXTSivwv5umEs/G/t4cw1EkdRPoOQ24WlPlM35wTDRMqP068Pxhl67HPHZnrR7HkTU5ZFVQ5fuSwnyb3PPpbZU39AU+fEZZxNMWTm5Fcc3EgyuMBXcN5Rb67auKF0/2PqQJSX2oYwJARgsV/2yU9DJe8JqmoqlUQCNMMlu0s5JJVyhUHCyyVfhEqQlgcKzNjmZe1qqynDVjKZfUUw7GxX54Tf0Gq8q7lMCVHCGFYA+8p/vRvTf7zYeirXZggoPgxXaxb6BNoRte0eZ+Ws4PNDlL+Fbpe5LPi7mm2KdNau4Evn7n/4Azt8VBC9DyBaQqbr4V6ZKVAiIiw7wTrtn3tjRYr8VGdV3A8bFY6DgamEmW3foUfr8JaWPlXPKIdBzPaDuvpJBmJHOIHfELYPSTYEnPLQsL5bFrID90L7UcuIM6CsqD1AaTMTIYylHTyeogg4CxLM/kN5Kd6eA7u7Qt+P2OCVZbwLOZ2he2i9aw8KrM8CRtqJHLWPgr7YtUXqVbqlThrH5TBlrExU01A0drMu62xz3ai78YVEwlwGOVlvYW46aarIpWSdTHrfnhQgQRoFeQAkeINMwCpfu6IwMX+zvCFeyfb
 tLawhBE9
 pRfp/UR714GR0XCamnwTVTsYjQx7A9REBusF0E0QiqsqXYkGBDzCgiwOExkeCnhR+HZLG7oTt+k3pQ+nIETL10detOFLOZGwE+kZLCL2dThCi/iNl0+TGPArvNli2LhSekWjD0R4lWahFPI2i44N1EeWvDM0c1fnxGAinnv81UqNHTTBaXZuBV4YrQwx+Oq1YiBrL9yXfVRW5WG0wv1SDf0HqgIq8ez0eCpy5T7upSsiyrTp3szeAAZvijis+3NwYVrjtpSYwVcJ9Qkm1rTrn+61+Wy/pMZ9NBoUnj/mKP6JdJQlnXwOLCCHpJbHAkNdzZlJp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__list_lru_init() only collapses a memcg-aware list_lru into plain
per-node lists when kmem accounting is disabled
(cgroup.memory=nokmem).  When the memory controller is disabled
entirely (cgroup_disable=memory), mem_cgroup_kmem_disabled() is
false, so the lru stays memcg aware even though no object will ever
be charged to a memcg.

This is more than a semantic inconsistency.
folio_memcg_list_lru_alloc() trusts list_lru_memcg_aware() and
dereferences the folio's memcg, which is always NULL with the
controller disabled.  The only mainline caller,
folio_memcg_alloc_deferred(), papers over this with an explicit
mem_cgroup_disabled() check.  The shmem unused-huge shrinker
conversion ("mm: shmem: make unused huge shrinker memcg aware") adds
a second caller without such a guard, so booting with
cgroup_disable=memory and writing to a huge=always tmpfs oopses:

  BUG: unable to handle page fault for address: 0000000000000488
  RIP: 0010:folio_memcg_list_lru_alloc+0x41/0xf0
  Call Trace:
   <TASK>
   shmem_get_folio_gfp+0x1cd/0x7c0
   shmem_write_begin+0x5d/0x100
   generic_perform_write+0x89/0x2a0
   shmem_file_write_iter+0x82/0x90
   vfs_write+0x256/0x410
   ksys_write+0x61/0xe0
   do_syscall_64+0x8d/0x460
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

The faulting address is the offset of mem_cgroup->kmemcg_id,
dereferenced on a NULL memcg in memcg_list_lru_allocated():

  folio_memcg_list_lru_alloc()
    list_lru_memcg_aware()               <- true, only nokmem checked
    memcg = folio_memcg(folio)           <- NULL
    memcg_list_lru_allocated(memcg, lru)
      memcg->kmemcg_id                   <- NULL pointer dereference

Check mem_cgroup_disabled() in __list_lru_init() so that all
list_lrus fall back to plain per-node lists when the controller is
disabled, matching what the shrinker side already does
(shrinker_memcg_alloc() bails out on mem_cgroup_disabled()).  This
makes the mem_cgroup_disabled() check in callers unnecessary rather
than mandatory.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
v2:
- Drop the comment above the check; the code explains itself (Baolin)
- Collect Baolin's Reviewed-by

v1: https://lore.kernel.org/linux-mm/20260902032840.30250-1-qinyuntan@linux.alibaba.com/

Applies on top of mm-new.  No Fixes: tag since the commit that makes
the crash reachable ("mm: shmem: make unused huge shrinker memcg
aware") is only in mm-new; no stable backport is needed either.

Reproducer, on mm-new booted with cgroup_disable=memory
(CONFIG_MEMCG=y, CONFIG_TRANSPARENT_HUGEPAGE=y):

  # mount -t tmpfs -o huge=always tmpfs /mnt
  # echo x > /mnt/f

Discussion: https://lore.kernel.org/linux-mm/20260901115104.2944996-1-qinyuntan@linux.alibaba.com/

 mm/list_lru.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..a4522ca93ebcb 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -671,7 +671,7 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
 		memcg_aware = false;
 #endif
 
-- 
2.43.7


