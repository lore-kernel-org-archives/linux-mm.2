Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F90BE9A777
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A586B0092; Tue, 24 Mar 2026 07:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13D66B0095; Tue, 24 Mar 2026 07:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB41F6B0096; Tue, 24 Mar 2026 07:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95C8C6B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:48:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5147EE1007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:48:18 +0000 (UTC)
X-FDA: 84580783476.19.BA2CB08
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	by imf24.hostedemail.com (Postfix) with ESMTP id 405E3180006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:48:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZcScZP1V;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774352895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xjIso0qIEN0C7CvEOKCVkSqgc9+WXM81F/XInWl6YYw=;
	b=Ck201nv2Fjc/sD6HPhi7BP0MRylK310FPihIpQUc32QehtF89hsU6kQEMfTVVrLUDyMM1S
	7U6QSMHJn3R0PXb55QVb3WYx7n4cLrXd5VhXRCezn0CPA7fsaUwunhqZ/b2aNGSxnceV7A
	im5p4qnx9lAOXPFAJfctgcl5JqDOGVs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZcScZP1V;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774352895; a=rsa-sha256;
	cv=pass;
	b=MfZdHJFpmDC5pzwgMKxji+oFoKtw8jMbtUJtDNPhq43tit0mSjJnMMCEthRk5FkqmcxAUt
	AvOrGGqDzFWnslXHPMmotq1vESmJi3qrp/M1IdZlboF/XkEbU6u0izyU2rm2+NAvHzVwgb
	ceVXWDSADQRMfpoYvL8wNmMBcANSMS4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYyOX3pJoTZFqaRVI3ApRF4QYXBTOQn0pjO9u1eQvqMXO+XoqLq6NRpIe/hASaYHdKby8JCYNDU3UgKUft8P8PcBjbgV+SSYTLauPiLBPB3nf9jsgDiwVYZPpHgjNepwPRMeviC2cOkaAUWp7lWqLYERxX3rd/IIIgvvP37Al04u8lKZPD/jci+fb3EtcPglP1OU0ImCymQZqikBUMTv2rPE3Ph3GwOwSXOZX5VexDMmaufz72CLhbl7cjO3GMqc9UdKXH+rIfcwCswYBl/x3g/LHDwsE6fU3AnM55QutUKe1oexmKHicQCmn1E6oXSZI2mrf4yMbXIub0rT2RXJKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjIso0qIEN0C7CvEOKCVkSqgc9+WXM81F/XInWl6YYw=;
 b=Foj54azHHwovspVWX+TqqXmkdNKWHW1nKROIwcS7u7EeD7rjyyVRnkfXYomLuaVhLqlvtCU9tvk7kWtVIPC2lrhtZfl0EMyU1umQsvztjMYz3V956OlFHlARvLPujJWFUdJ80VpAqT9qh8fm9v+ipBcC0gHd3NioAYprzOIOJs4rzmRIxTlLVzVVr53iearvQ1ylVOcnxdFDYrPhVuxfRt8Ea+C/WHn6rv2kvD/o/k+hD+vb4oZuu25NuYwpc9AQV4hTRpgvy9RyY66WGiw6ZsJfaD97JD2ktxf26Lbpaqjjmo4Kt/dVr98M0C6dTGrL1V7nksc6Z6PzXapak5LS2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjIso0qIEN0C7CvEOKCVkSqgc9+WXM81F/XInWl6YYw=;
 b=ZcScZP1V7wBNukM3BKxWQ5rqAAsIEqj9z42vNK/fHUL9nX6kTJiBFVSJge8su3frVStft4aFqJWzK5hj9nuGM+fsw9X6ZXEkQNJ/1f5P+fRJYvi8fkuKrrJn7fNS5Ix7Eh4iEcZyRxjJZclyxS9OloMaXkCkYCObekce3yqVaZY=
Received: from SJ0PR13CA0147.namprd13.prod.outlook.com (2603:10b6:a03:2c6::32)
 by DS0PR12MB8456.namprd12.prod.outlook.com (2603:10b6:8:161::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 11:48:07 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::d8) by SJ0PR13CA0147.outlook.office365.com
 (2603:10b6:a03:2c6::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Tue,
 24 Mar 2026 11:48:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Tue, 24 Mar 2026 11:48:07 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Mar
 2026 06:48:02 -0500
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>
CC: <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
Subject: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Tue, 24 Mar 2026 11:47:20 +0000
Message-ID: <20260324114720.864478-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|DS0PR12MB8456:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b642ed4-090a-4a7a-8b4e-08de899b3774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700016|82310400026|13003099007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VJhFoZ6BXK4709nCFRPMB8iSErXVwHr6gl9dAPtQb3o9vqdnAIWoKPoU+rEZri2dNFeUQAt0X+n0kQL/Fb1zqRZCC+KiQsgeVNOptHuvJJRBQdcPRG5jx3VUAoSoWmW36pA92rig9MfYnqHsRzgAb5nIRKcNg+qDJZzhR3kWpuxSyEp24ndsSR3VJ9i4FVL1WIFMYXWRlzIJQEtnRQU6z0xAL9fgx6gmig6dV5BDOy9nsqAdSjZot0zWLx7fsmuFt8/zZSp2MiJYady2+5bTmg02uZqUBmtJWZwPXkW6Y17FMHAxLmx/KmrIc+7Kwki7qyDgmHlkdfTrRTVuxBwHM0V5djvhct3SV3+J3uJVB63wapfMQCYfRDBqE29sM/84tfKvVNc2XBiS7emppMWGsjHtfbL8qTB/9tZxA0nXTAF7KOQPHxwlXsZ6JW9PpYsvIxjDGH66xO2jdtr/RoFfPPTAWBEJ5KioXgirx50HlmB6IyGIaiEm+XfGr8uYU67WLkUX6HwAcYzLoZ3xQs4537VJDit4kvutl8ZCR2uUHKYIXD4ooT9ny7ZckSDMNDy6H/m9rAEn3kSaRU/MfZc3ZmCdsqh/bS3f1CcXVqmwkYfiPuKQq4zt2SrY9G088yKKSEYKJ6ov/MywtE0weRnshI2UnDFIp9wtBkfC1hwYt0x7K7ckaau254vZAfG/niiiNZOcphqs23wuAdOqFU+UGZmUmYERFSa69sDage38vvhpMJ6kwDahkIT86d/MY8PeslBv8nuyml4uCttu6fxM8Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700016)(82310400026)(13003099007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bzUCGLgoVBpfjHAeD/hTSq1gbv6QsQmVXv22i0GE1wS09U0yGzIGAX6vCw3OEOFunRY50WagFCMZuWzaDKekUBqt7hy0vG7Ao4VpUcDHK0apl/9HaDJk7PcMP7dRrpdEYwUI3XOfZxrSlRN0MnrS6Mus/4OJmLp/UAq74L74yVlu5ke8q/3soE/+R7hPhKiVOK6uthpOB8VF1anXpoTGOwR7jhKHicWvxFFFh6oMgFGGtduV0Kwy+xQrhUB/XjAutWEvgWb+Z0cXKQOiSEc9tIZdLolIS4Ou85+wG/VWhe6Ae4QUFJlCuKN/rHmDE7lbrvHNGFnslFFmVYDxeyio8mtXy7UDsTyGYQMyWeIJf0Pey/tYe+2XiobeR763k8SHExeiqa3raA5YYIm4y75vXzgh9iBXBY0haRqMq59Gt8Um284EZN2LRPGNR19dWQb3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 11:48:07.5505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b642ed4-090a-4a7a-8b4e-08de899b3774
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8456
X-Rspam-User: 
X-Stat-Signature: erhcxdui31jxttq333o3dry51y53pfca
X-Rspamd-Queue-Id: 405E3180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1774352895-162072
X-HE-Meta: U2FsdGVkX1949ElkcuGcYjXzdsUkhMxHqpgDzPO4cGn0D6MusH0H4Ctv9Uh/fXTRVZbpp9GZn9wjRtPttoD9NNGHvZpkpdh4MZkFYV4vZTlb/602WZW2wYP4EXqKOO0uma5Xfl6afcrXP7mjlGzvI3O9rcNduc0uRMppwd4ezKTKT0G+xXicVIW7o35HCFRBciV/oypy/2GPH4+byS2jIA6hE6Mj3RiNOvlvIrc2bf1pi88Lj46XF1ryJdeZc2pw6Fl1j+mbYqPOezQx5qJJD//XFvzj/oFXuI7/RsWPlX3JZzsSi3gnBMkNBxoN0FCc4jkXBRSDdAu1j4p6co+CpTj9e2V2MmH0G28D3FXlABMi0NuYvPUKwqnXIaUf+LIoXk1GDsFi+jXwCQ8GHE/bQ9cwv9bXmxpD/wH9NtCir7Vlr2PoW0IN5zvnrxktYHvu/h9Uk2utnQaoOi2pxMOojBIW+G3m/hVK6/MwBL2K4h8u1aQP2ClCf9U6l+N1mRjOelDosWOPyryZl03yj90C94QA/Ot90FwTZoXepBelxfExj0mOINg2kYDZYslN9roTkwNHMTOVKg49yY6oefzDDSGB6DwkhevNP6lwHs8voJx9ClnOaEFc8NRSb6KB46MPCK2okXHyQmMQ9jAXpmCJAtH8WEouO/P+SgWSevoU5ZfnUoEQmRPArwD8W9tH27zQQ/wz4k5/UNqT2+tfW0mTkUrxS11hsbe4Dd0//vR8A5jr0TqQds2y7cIcHIpp/c/sEBvjPOEOgqsRGb5lNulyG8sOSl9vdL6RfyGPoBLop+eG+JanlYE7ZB3tnrop1belGm9y2SxhZUKzXea05GuXwImkrh6F7NoomVPkz3Hy/8Ej644ySD75S/OKpcXTX1OQRREW6nBLoP5WNU+1xKOACXgG75lgPSPAs/W9Wfsv9xsMeEQ3FKEKDEJl4BknGs4Hn49A+x7bnBp1s6IZMQu
 IpktocGS
 7Oig9wpZIPgT+bWR8O14/JdLITEWlrz7W5j9m9YoYsW0fbt3iRdhkwuEAYQ7WIcVwcxWbrMJsdxSfeUfbeBHaiHcFU4pFYx3b+QzV7gfwK0ArecZN3sO1jLw6TBwUqmd15Zn06+oOQ0yQde7oC450sOZf0CCcyyvJspAYa0letexSfzk4PXyD7VNS2uTX3RO7HGxOgKCw6zVVHD0zj5bmS5azAUIlx/DCBquofOKPYFLQmtc8re1Av5T4JO+JcH8l592iEz7TXz3s1RvtVCM2ICLGWX6xt5TZJZZ3ov0UWNsngChNiqN6xIiezuWFNtIKdRju49LidD5jlwzTNKBx/c8jF3BuFxOZ5PtvMaHsDHZP2CQy7j0eAzILhLllX2uQ7R8P40xOo+qh4pwkhfDZCiZsKflcEWGAHXkHacAkkaKrCa5kvQPn02bPpG1mW5X/w9knq7JieEgrWYP/kB0c1poh8GxFFjCvaQ/5cfDTOjb1povrfT+MghYQDhS5u9yxCvnSeZ/JgVevtweTx0TShfyr3OxyDGNnDmdPuHSRbQRilQOB0drLJEsdgavPo0z+wdXb/xU8GNLBzs552jihSNDgHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These flags only track folio-specific state during migration and are
not used for movable_ops pages. Rename the enum values and the
old_page_state variable to match.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---

Applies cleanly on mm-new (02b045682c74).

v1: https://lore.kernel.org/all/20260323141935.389232-3-shivankg@amd.com

v2:
- Rename FOLIO_MF_* to FOLIO_*, per feedback from Willy.

 mm/migrate.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 05cb408846f2..7dd6c2f2e1ef 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1135,26 +1135,26 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
  * This is safe because nobody is using it except us.
  */
 enum {
-	PAGE_WAS_MAPPED = BIT(0),
-	PAGE_WAS_MLOCKED = BIT(1),
-	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
+	FOLIO_WAS_MAPPED = BIT(0),
+	FOLIO_WAS_MLOCKED = BIT(1),
+	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   int old_page_state,
+				   int old_folio_state,
 				   struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_page_state;
+	dst->private = (void *)anon_vma + old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
-				   int *old_page_state,
+				   int *old_folio_state,
 				   struct anon_vma **anon_vmap)
 {
 	unsigned long private = (unsigned long)dst->private;
 
-	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
-	*old_page_state = private & PAGE_OLD_STATES;
+	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
+	*old_folio_state = private & FOLIO_OLD_STATES;
 	dst->private = NULL;
 }
 
@@ -1209,7 +1209,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
@@ -1253,7 +1253,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	}
 	locked = true;
 	if (folio_test_mlocked(src))
-		old_page_state |= PAGE_WAS_MLOCKED;
+		old_folio_state |= FOLIO_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1302,7 +1302,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst_locked = true;
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1328,11 +1328,11 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
-		old_page_state |= PAGE_WAS_MAPPED;
+		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1344,7 +1344,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	if (rc == -EAGAIN)
 		ret = NULL;
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
@@ -1358,13 +1358,13 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct list_head *ret)
 {
 	int rc;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool src_deferred_split = false;
 	bool src_partially_mapped = false;
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+	__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1395,10 +1395,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_page_state & PAGE_WAS_MLOCKED)
+	if (old_folio_state & FOLIO_WAS_MLOCKED)
 		lru_add_drain();
 
-	if (old_page_state & PAGE_WAS_MAPPED)
+	if (old_folio_state & FOLIO_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
 	/*
@@ -1439,11 +1439,11 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return rc;
 	}
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
@@ -1777,11 +1777,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	dst = list_first_entry(dst_folios, struct folio, lru);
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
-		int old_page_state = 0;
+		int old_folio_state = 0;
 		struct anon_vma *anon_vma = NULL;
 
-		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
-		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
+		__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
+		migrate_folio_undo_src(folio, old_folio_state & FOLIO_WAS_MAPPED,
 				anon_vma, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);

base-commit: 02b045682c74be16c7d1501563f02b0e92d42cdb
-- 
2.43.0


