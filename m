Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00456CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D376B0096; Mon,  8 Jun 2026 04:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D446B00A0; Mon,  8 Jun 2026 04:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515466B00AE; Mon,  8 Jun 2026 04:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE2E6B0096
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:37:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13BB31A09E0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:47 +0000 (UTC)
X-FDA: 84856092174.18.412BF63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id C253914000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a/5XROuV";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nfUkrh3UXXGBEBXNDRnqOIydAOk6SYQWb2HusQDLsM=;
	b=gY+kbDGcQPHCIQY7EsnUbD1nI83Co34mWiS1gYj1DTqgsfN3E+Pgpzo3RLO23fZjQZY19j
	CMgnT7YulWf5YfAhSjUfCKTk9AT3XL1/a6uDHPv+8jSDbVGvdJImycAKxwttdoQjPmc06L
	AIsLhWwIqX12gchk9wwhP6fEWqovXxg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a/5XROuV";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907864;
	b=1AfexNHz+fszBnmWCzLjThzpYpKvN4RXzETMREg7170VD3xwC1iWGpKrXBb+1RXEBJxJUU
	do90L+eyJO5wH0DLsznyBmsZSPQqFdwTIBtx1a4KHSrKOij63v9VUTW/U8aE9uh4j/esl4
	lGiZEQ1c1+AQTSenMIeAmyHm0NLoDQs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5nfUkrh3UXXGBEBXNDRnqOIydAOk6SYQWb2HusQDLsM=;
	b=a/5XROuVFhFXf8AlswwpL9GXWpSJHYH6hwUdVBWff4UwjwzCN2NEiP3TXF+LD2GNacTzxF
	qHNST+PsVMeOPnnimWjLCv7T7LXRR4mUQs392Dq6G0qe92ieoYYhWnUkPXOwzF8rFISd72
	rdDBOhmQOkBwevN0znrrCC+smvlg2oU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-KW3NPXwGPfeDrycx4cKsDw-1; Mon, 08 Jun 2026 04:37:43 -0400
X-MC-Unique: KW3NPXwGPfeDrycx4cKsDw-1
X-Mimecast-MFC-AGG-ID: KW3NPXwGPfeDrycx4cKsDw_1780907862
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45eec2ba533so2790898f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907862; x=1781512662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nfUkrh3UXXGBEBXNDRnqOIydAOk6SYQWb2HusQDLsM=;
        b=oXGZ88RMp0/JcrgW2j40K/Zbx9ULB69m0biE4zXYaX9cXeYRuJqtAdVqUC2CXJPy/W
         rkccIivamxDNOL/LmYlnHiBbQjqvldAecyeB08Wjfcbx7WePppINDGVa02HqtLTisd35
         Gwgqf6SGd84sKBwncyGnsF4E34b1glZ4y0h1e72ZjXayeKPBm7triMwbI8w7qY5UsRWh
         2MaISj/6FPh8ZF4xLE3AtxGoZu7RlQ3DlW32+q4fjqRjLegG32f0tTuO1dHjDJh05dEL
         sBveCN+HLp9qI9B0J5/ZvyUDR0b6Orq7zSn//BcTPgx4xmmJawX9CSd7ueB6IgiAYuz3
         H4GA==
X-Forwarded-Encrypted: i=1; AFNElJ/3s1Lvwn5A6fKJOmwJDQC/ThR0PjNVYeVei7ESlmzCWqyX2GYHGvreDJB8s0GfRhhT+OFeBAncqA==@kvack.org
X-Gm-Message-State: AOJu0YxFEOAQMIojzY0cjknQVBnN2OQ5iqa41Uv4+2NBh3KeSqZMIvyn
	g3bf4Aqz+MV1yDhMnm4eGh/TkbxV9G1NSvGcpTcnhZo4t75LpkXDGwx3hXIRYN4fkzCTzZSmogI
	Ght3hDrNUT7dMWEIVLlYbkygPYhhh/633rYVOAgfBeJWkEGPRPM5U
X-Gm-Gg: Acq92OFqS+OSCiTCQuCgp1CXYMlJa3eP4cvllH6jVsZdZvQ+tlgQlKsjUdQtEVl4Fsh
	n5shr4uIuo2O1klylsaFN1PmgNbBxcfpvOu1KSeXSmXdwTMmPWK0Y17xw0fnbzGw6w0OK+WgFvI
	YoYrpHkubvD4CNtdbVW9Tow9Sv+ihp/ruMWe19zeUF/+etAD0+0JSzKJxAMLDS6rWdVtAQYXDUQ
	gsG9xq3/TBOjaItaOUsbiA6x2Z1UWWyz70SuArbC2Amm1S3eOEbXKLNmd//ItLeTnFvyRJARI7d
	jQa8ZLuQNqDWn7sepN1DlQ4979L7WtrpbizfKZOZB5kLg6otXkywAeuc5PMcxX7cKLD+p1SoJSw
	EmcQ96QJcXod4bxdG6OIEVus=
X-Received: by 2002:a05:6000:25c4:b0:45e:e3ee:98b1 with SMTP id ffacd0b85a97d-4603061f968mr23332577f8f.32.1780907861714;
        Mon, 08 Jun 2026 01:37:41 -0700 (PDT)
X-Received: by 2002:a05:6000:25c4:b0:45e:e3ee:98b1 with SMTP id ffacd0b85a97d-4603061f968mr23332507f8f.32.1780907861145;
        Mon, 08 Jun 2026 01:37:41 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f368e9fsm49322612f8f.37.2026.06.08.01.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:37:40 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:37:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 15/37] mm: alloc_anon_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <2e931dc3daa76b57eaedd5b2d3d49f1075797252.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K9rlIFQyQpY6s-dRdzLyEGpTD1ABO3Gu0mnKMVkdx60_1780907862
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C253914000A
X-Stat-Signature: dugxcye9kzi3fbxc8m5ic366oyqj46mi
X-HE-Tag: 1780907864-543393
X-HE-Meta: U2FsdGVkX19gihYQOVY9VJOi9jJXce6yF5jCLFtGiz1APPbr3N1lNSC3dXHeKUFzdS2wE+Y5bFZncQd4audPsH4ZalRm5fhiPsE/cKWX7uFYwb5MfYoekTeaY4IHuTPpQSDFfhv1HHSZwfQha9TPePS60tbietSHulSJ9FR38K6daeoXbqA2SmUbxhZE3LcjLeMyN17PbQy2d7Fi4PS9K8TBa/zOfRqwkMgFbYXPIkPqNRb6KN3IC2z/4rLu5juGGK9t/tPmIGfcxYxIjLwfIcOsmSWvB7g0jtV1UXMoi7OAeb3rvrgY6OqieK+P2iwqyDZCQajy2C0yevrBxgIbSo9rA4AHS1BOlP9wVMCwnWdD12H2Jf3MsmUy9VYsFhYDuZSG6Umi2p3fYC51O/wh/UnWqgovTNvqnTWSxvtUXWbFjcqkl38doJ9SqlVDm0CsFHciDCwy6N+8Jw8pOXlpu+qB5gvv+oPOtp3aG0nrQnkqbsd08G7LJvTLGfJ3vzdAVgmuQr5xTO4xP2PTAlObiQUo6XaUshYN3XWv/6bTzc4opiJ+4xWya01ZVlcjibY58yw5kxxY/eKA9c2K1yAm213BWPixH2DBbQvfJ4JwFAjaKTEDF0gDZkEHtlbhnaF2xgDDaqyPrBivhyGAIk0N9TeJoOvbOK8ndb+jdriJZ9zBSNAa5mcGyBuYjdowc1fdJTAr8519hrabWsvxtgSt257GSgG3zk+8qxWRm0QpJwV63JNi24o1f3ikmyLwETLjESa4iQFgGZtNANv7cmFxjRcqglQ/+6sc5lKMI7T1Ifw81hA+7GmiwTG7nQxD7yO0TTJ0Le5tUh6b0z5fu0OYotoZOO2Lcr4Z65rbItX6+TlWeaH8qUM7Vqm1b7QybFS2BZFLFzsEaYN37we0lMf6SdVsevrDu5oA6j5PAeKaZwwD/IblZFyHBpYl32eVBeNOo/p/khZn7QNWAPWkQZf
 6os2BQSE
 tA9kUs9cCyq6itlgHywf95SOF4xCEPjzpwDQaixnYmx1z+Jr9v0tZjGe2skeDbCHxinDJAUbQ0QXhUPmq6ARDiuh7jAajP7T/Jnc44pn9KU0CQQr9jGHWnWJac+VJhU88b3Kntbi4qkcGJYjt3nKxogIuIkOOuMJ8TIYGGGHQvJAGJBIKjJ/kImSFQHS5MCOzCnwaezN8RkaM2JqFIpgdeYKAVqCbRlkC02BOb6CzAKKk1N30EWxJPlLTkv6lyw6cs6LbrvJL0ADSFZEtCjNe0foYBBDv+DAxdRXVCKtCjBztx3DaWZFbtXlOH4m7bAagTDI+yNtdqKumBQk1UP0h/qJRvD6r6HrlBNgjmlLdPUJluc+Oaz+NYm0DwLFN41Y2PgfZ/hGUxeQLhU4iAbu4QJ919TdMbpzZv3t16lfPpbe4RH/nyweckzSZyG+1FqucZeWEAolDyN7atqv0lgKz6c17iHiYufaWCyoMC/UAjarQ4e5ek1b3fjNjndED0lh0qq0Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
NUMA interleave is not affected: the ilx calculation in
get_vma_policy() shifts addr >> PAGE_SHIFT >> order, which
drops sub-page bits regardless of alignment. post_alloc_hook
will use the raw address for cache-friendly zeroing via
folio_zero_user().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..21f640674c4f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5268,8 +5268,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-- 
MST


