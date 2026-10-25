Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1456C606A323
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 09:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UyXE9pHc
Received: by kanga.kvack.org (Postfix)
	id 332B46B05B0; Sun, 25 Oct 2026 05:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A0A6B05B1; Sun, 25 Oct 2026 05:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221526B05B2; Sun, 25 Oct 2026 05:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF37F6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 05:39:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74800A6BD5
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:39:31 +0000 (UTC)
X-FDA: 85360650942.03.C84DD2C
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf23.hostedemail.com (Postfix) with ESMTP id 168D5140003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:39:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UyXE9pHc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of jinyue.li@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=jinyue.li@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792921170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1YX/NGwD+4icII1vdPQ/3V0UVnnxb1F3CZZawSscMPM=;
	b=istJFx2eo/Qbf31p3ywGJrHXvV84/jyRqrDIIKHFum0ktEr90A0K9o8hmseCRZ+4lYHiQm
	vR6TqoBhryNZ3vNc9xeFR/ubmESi+wTt3cM/s91lx6ITjmNtH4s2OnEYV1LBcHv4z3MzRz
	NJjHNYy10E2wnxGC7zWXlHmQeVX5puM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UyXE9pHc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of jinyue.li@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=jinyue.li@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792921170;
	b=FHdrogWt8Te9eleLR5cUovlZG8vaCR0RFusLhnNDJXz683F1oOeqZkZDk9eDdjlWxM/HuZ
	VEG60yE6Ev0y0hU6sJc+xCnngJvomBXrIs56Ywd64ni4GWXY3t78zZ7NhLILv2C+MOgp1z
	FO5nxDTCesJ+1Syy/Muma7U7nag2mzQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792921164; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=1YX/NGwD+4icII1vdPQ/3V0UVnnxb1F3CZZawSscMPM=;
	b=UyXE9pHchOL3Tr/sAHRaDnJIvF8kQeiYcWstaQUiwYI4I5zUu+M89drq3T9jRRm6Fb3RxYpk/D+82cYKSZeqAFh2HxC2EAcladXhhvdrga8eamEa7eCNe1T/fpgnRs202c3eJq0L/xAXFpfNzGAMPJpVrhXTLxLwVXc8afcdmCY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=jinyue.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDQ7Uop_1792921161;
Received: from aa8c952a0f58..(mailfrom:jinyue.li@linux.alibaba.com fp:SMTPD_---0XDQ7Uop_1792921161 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 25 Oct 2026 17:39:22 +0800
From: Li Jinyue <jinyue.li@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/vma: reset the VMA iterator when merging a new range fails
Date: Sun, 25 Oct 2026 09:39:21 +0000
Message-Id: <20261025093921.1011927-1-jinyue.li@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 168D5140003
X-Stat-Signature: ursn4s8tg8k18boodspbmup7ti1z8qm1
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792921167-47929
X-HE-Meta: U2FsdGVkX19xZt7oeQSRfOpRzkJSdOXIKz/dwpPNeJJsJs64lTj2OzFhThzCcR2p4mjUJcxUdJLSGpyn4p92mRo89zzMm/06BZ/7yCp/xQneVpgjgofYMIsbAallWcDfGblzhv4v0MFkyEtRLRAWvaNhIBCFtrIwHHioMWRLhT4Gb82SuQssZY5ndDnhOM13a5HqET9KJY6/oIqs9bW2zEQap87pQ3kFIoKc9jQO3uM+YDXGaFhJkQ6zCiQwFxdu9HHfCK/g1qbwoaoMNvFa/OQQ9/Bovu9WbfXZet7PyCoz3jA118PGffdec2tdldlgZvAlgPAHB2lJiqCVpMZWYwRfIAFeW/QabijHkG52xZLOQ59/Xnjd/sA6bvJXh/PWmkqBOmLXsMnIqA/3a1XDF6CtyC6R1PRixhnvnapfyv6HDNcQzOgWyALozsAWcbiAwoIxcZAY29ZqHQ+40c/59MO667SM6102IE/OT+DOfQOkKqmcWUpU32uTb6ghulXmM3xN6C4v75U3hvmmOLAyNV2yLI227CAS8UZ+pzsw3GFC+qRj6tq7jl0qAnqFMJQCUlyk4HkxHHhCcmmhIY5n6Rde4XNFDf+p+pxKpc7mLSg145TNhrTUgHxrJV+2ZiXNkqCxPExkb3XbFdwFlX643vQl988M4NOzx2SnaCEkDYw3KONJ6Kg364zo+W9sOOC3hvf/0ROAXdx1EyzQdbWLX4RdPsnqPoWUbdWF8L3WER+e3q3ElPP0hVhas+eRarQ4Jvc0CRdO5u/jMaIOF+9OlUgJYDdF8C6npAXAC0Gm9n2Evo6TkOpnLg0Y/c3ZypcEMn6wgkTZVuitTy69mGG16BeE/ljPSsSZfaj+t2iGMTCyvZA70w99FpyfZqmA6Cuz9+3Xj0+18OXoXqR8/PK/LNNYF2IeOyfpyGRD8nI4LVHh837q5cPk6EKsYxGdXf0fbsjaoeC/u5/3ucX1Qn+
 x6uYHCVo
 D2vowfVT66mle/1szpSHb8WJ9hGyWx8zCJwxbPpdY+8QydfxobaF1nssW9vhhvDfqMGyGwo4CYZfrlZyntI7mRYSts+CmTMeDXlDoSCd7lEXU+UUcN++7iEV91pL4ty/N7Pa/nIRV/XAuzKwPcQ80BjiEegfm9q8e1oQz5VukHQoR6DBqTItTYnms5vFSELY7Fe7t/k3dbU5XSTLhLmDiDIJMeCmGKlUSlPke+rWZiZLrqlSaGJgLtLZJNzF4a0twVkfCLEiTPFj+ubz2LMw5jGHDUOG3OxK38sLZhjBmDIQDOtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the new range can be merged with prev, vma_merge_new_range() moves
the VMA iterator back to prev with vma_prev() before calling
vma_expand(). If vma_expand() then fails, NULL is returned with the
iterator still covering prev. __mmap_region() falls back to
__mmap_new_vma(), whose vma_iter_config() requires the iterator to
already contain the new address and warns:

  WARNING: ./include/linux/maple_tree.h:796 at __mmap_region+0x1a04/0x2398
  ...
   __mmap_region+0x1a04/0x2398
   mmap_region+0x304/0x466
   do_mmap+0xe7c/0x162c
   vm_mmap_pgoff+0x1e8/0x362
   ksys_mmap_pgoff+0x76/0x402

This is easy to hit with fault injection when the new range sits
between an unfaulted prev and a faulted next, so that dup_anon_vma()
has to run and fails on allocation before the iterator is
reconfigured.

mmap_region() used to reposition the iterator itself in this case, but
that was lost when it was converted to vma_merge_new_range(). Restore
it in vma_merge_new_range(), and only when the iterator was moved, so
that the common no-merge path is unchanged.

Found by syzkaller.

Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
Link: https://lore.kernel.org/linux-mm/CAGfhM4AaEygReogOAmkmu5UfRYwoBXAMdLMBi4jbakNONbpsMw@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Li Jinyue <jinyue.li@linux.alibaba.com>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 6c35f0d775ab..a801e3d29dbd 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1141,6 +1141,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next = vmg->next;
+	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
 	bool can_merge_left, can_merge_right;
 
@@ -1198,6 +1199,10 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 		return vmg->target;
 	}
 
+	/* Undo the vma_prev() above so the caller can insert a new VMA. */
+	if (can_merge_left && !vmg->just_expand)
+		vma_iter_set(vmg->vmi, start);
+
 	return NULL;
 }
 

-- 
2.25.1


