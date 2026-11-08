Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4119606A331
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQxTPPvi
Received: by kanga.kvack.org (Postfix)
	id 34D9E6B05B4; Sun,  8 Nov 2026 03:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF8C6B05BA; Sun,  8 Nov 2026 03:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0FF6B05BB; Sun,  8 Nov 2026 03:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F119C6B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:49:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F0291A0438
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:17 +0000 (UTC)
X-FDA: 85411327554.08.F707115
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC1A7C0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQxTPPvi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyfscNgfuH4Bgz6xRWZ3M/NAQI+U46EGvUlQUq6/bgc=;
	b=nftI20WzrLad7i1XOn74qgTRb8goJy4ed1j8eI2C9QDZNQVq3dEurNn77FNoBIT7uXlm2d
	DZutpZ5///91H3rIewXB9i45azcy/rBJ7CD7Zsa9nLrlMnii32A+jadrvbHRxa057hTnRC
	zV7FJP8yWyfDOoy7T3M/nRHxKwYavYA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQxTPPvi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127756;
	b=lLRi4mVFgI/XbsRrNbOQdWJZn27JaP3TQRU0d5ejOVCf0ddHA13JsSu+/zC8+x5HYBDMlK
	IRf9nOf0Re0Vt9wWSEZKjobyLIHqQC6KnG45j+dSW8GBi3L8OTlpujhrawnoFTLUPzmu3X
	dSDNJgUgwmVOXrcs7YH2bNpsNrXfcfI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AD01614A1;
	Sun,  8 Nov 2026 08:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225691F008A1;
	Sun,  8 Nov 2026 08:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127755;
	bh=jyfscNgfuH4Bgz6xRWZ3M/NAQI+U46EGvUlQUq6/bgc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KQxTPPvir/kfH+2bqchdYnHZIzVjk+t3znnd5k6S/8nUsbyTYUhn635WW8Ztv9MQt
	 1qL/XGAWJzB6TBHx/w6r8eH8Ubrx3N7uDREpMYDAoKD+YWI/y2sRf/Z3xlpuvy6utX
	 dKBaaT1iJ7s38+RjBbVPbxVQBnUMkm4peKHJE/jM3C++JcRAE/mtbWzpTxbzDvTmIv
	 Unktv4xstpWzRvIqV1Bg3/D+/Nz1po34iHKssRZsYAE7tkoyz8TAFTPTo4Y02/+lIi
	 LOLT6FTrdAf8A7SX697ByCc2Cjt5q4s4f21YjUmNJ5BmnnEvb4S0hmr6fiPzvrj5QT
	 ZaGqWjNFEJefg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:49:00 +0200
Subject: [PATCH 3/5] s390/vmlogrdr: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-char-ready-v1-3-3db507722530@kernel.org>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
In-Reply-To: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DC1A7C0003
X-Stat-Signature: d5g55tc863mdt3553z7idccbnudur7pw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127755-727162
X-HE-Meta: U2FsdGVkX1+R77iYG/Y5bZmSihfsIF5V8JZxOz27crgPZfaAQb1sg5wMmVvXQDAaMx7buTX2ry93bnXlX9xZbBNEbgRt4s6O93R5uCwpwo1h/DmFwExagOCTeg/xq0qe2zr17xAhmojpUwtJ+6luF08Kwp836KyhV9nIiYrhZIFj/gR0gog8SSviVRIv7PpfBSVHyEMZo1nf8SCANDqKGxYBO+BJ7ewCixGBKyC8/j1Em3VBXK3NwdXkeeFPYF/ciTCEtllaK8+J4h/+jqGvQGykSHdX7TYi2IzdV9iGzl2yTHJc/BWHKZ+kaZaqq5h3yqkYxfvoLRw3CL2SY4Npd56dHkdCnR2RE6DFGFGLJ8rEyiuSNSz4Qfydwd0bTrX15PqgOqGElPDsz2qssP5dTmYHsz/pJCOgpXgKU1kE/csKNHoTMpP0rR4Uwd3XPfDgKZkgVSrxK9PAE8h5k5R9sq65IVjG9qXtXAAQ5m7/SRvy1p+50cFDBFQd+Am89ptEjQ4CN0v2LgdY2cqDnV4dXDOuVQHdcrTaMwaczWfnP/toDSWnHCsLXlYPNce0Vah4MLefO4xT0H0qN+VG2ybRhfZeoFS9aL152rvHmIr5D6+ryapKCDzv/le6RIy2P7wkO2vDS8Di5ae9sB4+6ygdUasK3J1O0pXxOesff/z1JJCpFXzQk4RmMYz74axCoYt9eDpZ2B9bCMQWUFqh77F6J5kxebpFPdttc83dv+l2PwFITW73CeH5E6o3f1pP8F/xt9XXuNO/YqCdv0CVAEhyP+HK4CbKIQTYc4fKib5ut5LSKWu65YMpDc1weKL3px2uBsPxbL8o4zNpAMN7m62YVqFk18z3ap3iErI+/HDAkJTO0ZoGSZtYqRKNnF+RqvsLWdOpYPAxiQDbXehLxyFdfImLkeUH+zCiBRphzKrQW1s0fWAXt+jZoJk5m00DC9QlEQxIZ64iLYpQ7yYeLqW
 CsqKYqmf
 Y/8VIaZDi6DUxS8HWg74xMTsFmTAuxsGNHmP8EAZDdtHY6SNo8zu53ikwTpTr1RfYQLAQkxeFWb0s8wy6YVWN8iHq50lXa4kQbwpPblj1wsSgL7x08MyAJ4T11lYQjWTDGBfg7/4r1VieqLT2AT3imlg0XKQQJHvr0EnRoToKFlmQltOEfZYR2wTUvmhhJbJImE3oMM8snzC/I8bPOBLvbULaPDjxW6AmyxZNH81ObiwaEE/FRQoHl5tCsA2p8ThYeeI5FvKL+BoKtUQZ76XS2T7kRAomo+VMvnAOU5m5+fAOEY0ko7CdXgKTwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmlogrdr_init() allocates the buffers used to receive z/VM system
service records via IUCV.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/vmlogrdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index 005735a899203..229a0f71dc453 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -793,7 +793,7 @@ static void vmlogrdr_cleanup(void)
 	}
 	for (i=0; i < MAXMINOR; ++i ) {
 		vmlogrdr_unregister_device(&sys_ser[i]);
-		free_page((unsigned long)sys_ser[i].buffer);
+		kfree(sys_ser[i].buffer);
 	}
 	vmlogrdr_unregister_driver();
 	if (vmlogrdr_major) {
@@ -826,7 +826,7 @@ static int __init vmlogrdr_init(void)
 		goto cleanup;
 
 	for (i=0; i < MAXMINOR; ++i ) {
-		sys_ser[i].buffer = (char *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		sys_ser[i].buffer = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!sys_ser[i].buffer) {
 			rc = -ENOMEM;
 			break;

-- 
2.53.0


