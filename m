Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12C3606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WCeeqjBD
Received: by kanga.kvack.org (Postfix)
	id 5AFA26B05C9; Sun,  8 Nov 2026 04:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5618F6B05CA; Sun,  8 Nov 2026 04:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BA66B05CB; Sun,  8 Nov 2026 04:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 162236B05C9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:05:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95240160428
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:05:08 +0000 (UTC)
X-FDA: 85411367496.12.D845082
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F0F9120009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:05:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCeeqjBD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlJKhaH/GHxHkRkI9LbPdsXIENTIT3s6EiTose+Eau4=;
	b=r67VdaScs8DhkGZeNArOBzUOaPZz2Mbr5NYPF4XDslY6JsQ6ymnpQSviRUWONVcucXbO8c
	i7xA98nMKN2lxs43kkNXqSw+01XpqXmyk4a3FFZ5fQzi7Y3OZG8zVSpS8opnAtUnej4FHe
	s+TKgsm32TWeCFt0M+bDIn5+4nkTXcE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCeeqjBD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128707;
	b=Ia0O3GxQjtPZBO5ALOnQRqb26U3p7JS/FCJogh3p7lS/IGkEn30Hr0uYKzXqE9rupIVZwq
	5uhiFr36SRYbGXtqi70R9Dz2E4bzwYYcgz4YEPeZ24GUerDvmHqnPGJ6l/Zdl/Z77tk/UW
	9BMcTzaQhRnudGiL3bBh4+92qQfAXn8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A5BE44D0E;
	Sun,  8 Nov 2026 09:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E571F0089F;
	Sun,  8 Nov 2026 09:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128706;
	bh=MlJKhaH/GHxHkRkI9LbPdsXIENTIT3s6EiTose+Eau4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WCeeqjBDCKOlD2WXTKgnOb3VpGFbNofzjKQQMSQA8lCURuGfKJMVpLm3Y399NtvoP
	 /2bRS2AKpG+kHPeu6o6S2+vo45ObhufmljPhW5PpClFL4p0kRQm7frPug4C9M85pIJ
	 NS5+7DdLc6NcDQQJIyEehkXcr5lqQnbX2xa9PJdPoa1JKp9L/ksnGe/Ehh4uTnFEUV
	 mdyWG0tRI374Aq/FB1Ze4D6i+FAJMdbIVs5+CgB4Qakn/SCkd+ULmH4NJa1cnbVSAR
	 MGtSzMOKQraUfVtftuvtW3OWSNrW+rf+WO6xihRsp2GQShCv0Fa7Ok+qdvfgYsvw2o
	 wQzW3D/4aSAxA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:45 +0200
Subject: [PATCH 14/14] s390/sclp_ap: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-14-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F0F9120009
X-Stat-Signature: 1736nmzsu51y6e5xh1pdqdh3xdo45jdo
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128706-837816
X-HE-Meta: U2FsdGVkX1/VTd+oCNiLhzxLqyT68MJQ0VKYyj/CV4t8JwAYNrp6ojMHdeqZDua/zYBAUN5S3zcXkPhbsr1q2j9P1cWIWfbMQanciRK6fxWrCsyN6oUbhxXoWuCKGJwbAhSWB7CU/ZZl5l5J5AfMrHz0IQQEhgGyPXlQSBEK7VxQ+hDvsZt/qJM/tZHA6kLVcrth9UCKLYfaCS28AhJ5fxpYPHWNFv4dJgPlkYt5fg4E3PrbiGDcQSrjXhKr+q02kOdqKPpneBq7V9Z6ygwqrbrNvc9EE/FGR9S+PTI1uQPs+uCplmtvpnRPmPoER29FRohEsRKJVZ+qVG9XYsjoeV15xhb3G2n2idBsif9cRZlt3duMtT7rw2FllKRjbTV0DRnh042n9vzGLpk/SL9z5km+goCgMcMloYHzkRmwV8pnhkqU2cnCHbuusZc40skw/7D/a6lwcdEgopcQ3JW4Jukvg4k4bYWz+BktWIbsV9XSTNvc1R13GOdO+fLpDetgBhzPefKNqrAmIoctboJZ8KH2ML0WLJj/PuZLcQimRD6ewnY92fe5DsRhIZCSgU8fkU477OanhACF5M3MFHDxWipveNbIV5GDgpD/0nF9gTcLQqe8mBy4Fwo4VeGBFR/jEIGvHtOeMwRWsy66G78wIFgaoOUJ64kVMFNW+XI+QDQ6DXj5w2FCyYgWU/QDOxXXPV75P7ve+j78MyfM5aE7fq7FpqIfKcfos6TYrz/Vys7GIRxH8F028On8rV3BOGGjukReG9VTAYL/KoWj4pJucCPZ2jINuEtSZdnDGiHyWq7RND0nbklqMZRdNSSh+PvqG4MqylATk11DH9TXEHW6NZCNi6ATa3XoH8/KbVOU+BAUeSBqpMUsviAz00xHpxr/lXvPz1x8B8Eq/UDQGQ2iBtrxBPQN8QE1CX9c7e8jfsFFjqRYmYkTWsATZcd+v4gtX3aVGJ2jAjl1+HZL/7l
 1nhRdaFR
 iV2icCzv6fRcdlw0ao5CoO5NoKzlv8c41LvlSEuh1zn7kTt0XGLCGsCMOKfglulCq99plKw9tWFC3it2JBR02n+kfU1eNQ2m70wMgbGu1pKvntOIej24drXtz8nVsbdaDaMY7QMq2+/8r+z07W+P2koT622GKn38uw0BTjAFKrnPNdwsEe8LMKQHmjUSWwIbyQLSmuQLeI8i487Wb5xelq+tn7lCT4z14JFm7ZEmODEx6xZQfMTZPZKA5jvvPMfynIVMFtCXHa6F4Rc8QbQ11mywYtEXw5bbYI/SBWnh2QprB8KipOPszMdd/FUi0mAGnoS9l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_ap_configure() allocates the SCCB used to configure and deconfigure
AP adapters.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

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
 drivers/s390/char/sclp_ap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_ap.c b/drivers/s390/char/sclp_ap.c
index 18bb018b4e0cd..15dff5dc0cac5 100644
--- a/drivers/s390/char/sclp_ap.c
+++ b/drivers/s390/char/sclp_ap.c
@@ -26,7 +26,7 @@ static int do_ap_configure(sclp_cmdw_t cmd, u32 apid)
 	if (!SCLP_HAS_AP_RECONFIG)
 		return -EOPNOTSUPP;
 
-	sccb = (struct ap_cfg_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 
@@ -45,7 +45,7 @@ static int do_ap_configure(sclp_cmdw_t cmd, u32 apid)
 		break;
 	}
 out:
-	free_page((unsigned long) sccb);
+	kfree(sccb);
 	return rc;
 }
 

-- 
2.53.0


