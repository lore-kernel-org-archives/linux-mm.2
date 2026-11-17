Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72EA60A5BCA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJzFZ3wG
Received: by kanga.kvack.org (Postfix)
	id 489DD6B05D7; Tue, 17 Nov 2026 08:07:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4619B6B05D8; Tue, 17 Nov 2026 08:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377796B05D9; Tue, 17 Nov 2026 08:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 137F66B05D7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92752160436
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:43 +0000 (UTC)
X-FDA: 85444638006.03.6ED5CC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id ED1701A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJzFZ3wG;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hj69K2vm8ZEVPGY7njQT5Zr87Alx64EswQJRpbuiDuY=;
	b=D+fVVX99zxXttt9fbnXDhXKgnvReVa7xtPcdhSdaUQk6W5w2Tf6DtuImvcPvMJrox5bzim
	d5SGkedZKbjbctFQ0YyHrLQsyKvKvqNsy2VsJsrw4uuCAnTu76J2oMJ7xku58gcilPNfRE
	OEZAK/PxSHpiACU/rV5xYwHlAOPKcbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920862;
	b=HSIbs0NK69PFi3IRU1Tz0hwsSqp2GJ2tOMmbs2K8YOa5Rz+dEQW7B11PVHj3hjV8bBnpk2
	pXUy6EVC08UEgQf+afK0+7Vw1QR/ZRlOyzE2AY6noKSJJUS915L9SzeLGO88kH1i07rfGG
	Jv4FE8Qc6IQNUqnem+MnuFo+XNDyXtk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJzFZ3wG;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50C0646B67;
	Tue, 17 Nov 2026 13:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C977E1F000C7;
	Tue, 17 Nov 2026 13:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920861;
	bh=hj69K2vm8ZEVPGY7njQT5Zr87Alx64EswQJRpbuiDuY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SJzFZ3wGnfWsIG427ElOibz3m53GNhvmBF7aHBPElQs89O2PA9Fh7tjNGfuNqQVq/
	 CCkjVlT/M3MWEtq2FrQJ2O1SKHVReShxJH/Q3J6FSbxo2t5YX6gyEghSNhPxhO1ydd
	 5ged+faH3jLgeFhL7DOpyCrXEjQW/PFe/wFYvH/0fhk115a5QcT04frbrMDxhXSxIe
	 0t/WeH2jCMR7PvTmJ6/Ea/ZPQdAM26WxBLsrWQx2SoMGRgcIRtKu5fheVzud7eBBXB
	 uAeCqzuwgE+K+fVigqd7uq8BhIn56p6rgppwp0Yj7nDUCWeVGM1icHZEQ6qilQQ8+5
	 GLOBDtinIoJUw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:07:06 +0200
Subject: [PATCH v2 14/14] s390/sclp_ap: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-14-e518c99622c6@kernel.org>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
In-Reply-To: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: whykj3z7j6j9figp5nwjzanxeybp6fnm
X-Rspam-User: 
X-Rspamd-Queue-Id: ED1701A0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794920861-309577
X-HE-Meta: U2FsdGVkX1+lCPMgq8yiNM1XPMTyh8FUH7SCzoU4XYYDvAGPTH5yqJtOw43VJWfTDehNW4kRZ5rsfh7EfCLdhVDmWciFUBoTHt5LVUK9XfnyR67qRNsStQjCn9SVPwM5oRf9iQUDvbOZ6vjlXVksw5RpmOtrhI2QuYJyBcAkn+67pFC5ERTje8Wg8x9+2sBgzTn8eOxgGGa14At2Tls1OYSgap91VHvWuxSoroS+dWx7bkDS7bb2Zb7UK0M+TIKLEuwMV9xDqwQjXn2SJtU0tHDJxLranPqjoCtbEgP7PumYqYNmj8vAi5rnY0qraFOJE1Vg1yeZqFS9TX6PlHgPTKSc6QffqG2qBtcfmZK2szuMlvfwAkmTjIN4Bd7jdMRPLRLOhjPGwwTbpBvchyqC7f61uZoRKoI607BNQX44JeGXHLtQyyeDqMLHTVbQbRLT2emu6RnWaU0d1ImTEnb8FU+hQBktuy6MoXcF3SVTAgrerf1zxFXn2F+T9nV4Mna51np/I4EE5jO8YRxgPnd938FP+QNs1/0wMLjLolwD2Cv+447x+2590Op2lWdt8pBysX5QQmyZmhqH7w2G4v+rdVRwWKNBa6oMWjwpu2q2HhAtItlagIK8Wm2K0FzMEBRffrRrcHKLAzeGCTZ5hHhV1w87xkZNMUSaPhMlWTUTRTXWr/G2mqfMDUz/Q4ZaUd7STRNmJENIiCT8ZeP4tOWmUD/NU5DmmraeYEM4qYRkkz2F+VDtFLPdNR8dHZPo/oSSaX3JKlzOD8LDMdASX2WnUwrEn4NqrdUgsf6NttLsuF2EYkd6oxU4mXCaUoQMa1ZF1yM0YUraOKBTBTrjPmLddFoft4NR32kUJv0KYd/3hj/AoXwC7zkBE9OyDcPNoRdo9MKPyf4lqn6FK1uUSzIbQNY4EpGs1Z1IjVOMWdGie/JPbgK/x9m0ILiUlX6Y+iIAyPoxVkJWg/29sHXnQHM
 OUuKuQ20
 VCFJ9ho/oS3hQHogkydoBGS2VacftVBUADuZsh07FUN6t+ZkmW2J5MUJyk5GPcME+VDIzmDssyYN0Iy7n+14qe/iu9yLWJ3ZhSVooEJu+NgvnU/gDDuaTA4HNTlNEu79x7OOSKFAM1xpjz/M8y2On+Q5uRFQlIlc/+KUeAWIPpN9GuD38cuag3oTz0xxXyihfYVrz+oECnSogZed3pg5KRFOOH2lMapOEPOG9jDtb1LV9ixZEo1t+AryXdnnH3WFvwEl0Rw+cNPt8hZO6YN/yrqcM3o9V2HL24Uc81RciKqK1r1PAiA5//NTWJH6W8takEX12JXw5J5oAWiOawuaCcU6A+w==
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
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_ap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_ap.c b/drivers/s390/char/sclp_ap.c
index 18bb018b4e0c..15dff5dc0cac 100644
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


