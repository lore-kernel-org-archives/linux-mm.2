Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CA1606A335
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BEW158Q/
Received: by kanga.kvack.org (Postfix)
	id 6C9E16B05B1; Tue, 10 Nov 2026 22:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2176B05B2; Tue, 10 Nov 2026 22:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590BB6B05B3; Tue, 10 Nov 2026 22:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4CA6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:35:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEBFBA76F9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:35:03 +0000 (UTC)
X-FDA: 85421422086.13.6331A79
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C01520002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:35:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="BEW158Q/";
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.67 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794368100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mc0sPreXhVH6cmYLfjxr+IUGiTNgAlutU7ThX8zMT/M=;
	b=4AIpOpZa93Kmy79ZEWG06BNLVZIy813rR19Gkhe1U0MqYZ7X+2o9UE5/oLO0omd/5gnSMy
	auWROMRytvzieCY1Q+WKNfpCbMN3eR62Lhvr6rWDcwrAPHo1IlULWtPNy+Ug0dd/JqAkx3
	lmlKOvz4V4kgFrIfo2cWqRap/1GDaWE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794368100;
	b=rxQT1oDtnGZwhlLarjsreu+tBMld6IUrIKM8pXMsijSSPTM7MbBIBreOMJiEpcrH/jVXjU
	9W7I+8gNmZnFiRHEtyk2SL155UigJZDgnnP+rZCBhEQTwpAsnEfZ6GpmgJeTaV20WgEBmf
	HISwJP2uArNtWb7BL9eR7GM9/TJ3V7c=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="BEW158Q/";
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.67 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q/ceGJ93Q5t8hgnRi2eUD9kdtpec8jvEgfsTo8ztG1NSF4V+On4I6rN72qaGBgBhpxtqF+/rxz6UOBzfcQDZyRAk1QobFcsT/XkKc1hStaKR5gfyen3AH2W/WbigWOlDOAUqP1XVEg8empc9Cjp5L53coatX43+5ueeRLDAm4swFov8V79I1vStZ6GF0uOjNS8ShNkW74YmmJ+cD9N0/Gq/ZET/oB3IFzuHSiYSOAi/boKyZl8SiWMfcPFytafKvn3K/BWB71rnkFtobE8seBRU5XAQbAFdbINJ/I7F+CQQgiKvUlN4UbMYNv3dBA2JiWN9WaxFha2AGljs1MWblvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mc0sPreXhVH6cmYLfjxr+IUGiTNgAlutU7ThX8zMT/M=;
 b=rhE4OeMol6geuk5OLzNAJGW6t6PXISoMfgE+X8JOWGvWpFv0jXqoULx5oMhVW2LKhsVolJTuhGAvEEvXtnYE2zJmFVGPru+VzsiHAYBDyvcmbpLix0nkp3mLBJXYOgbZXCyU8s+H7eQNpD5ZSwZ3RarZCWCe5lMCnJro8Z2hsKdbP5/JanaTLK04WMJ+odGY2jMCVEk4tRZfV0Js+1xBeIgUTIMLfTAT/j7OsVdg9SOopVuyZDlo1sayyOD4mljRc+Rrq94q3lhnyuQvf8Xmh3ORNVJrFA6DtUw5Z5hV2f/HmexZga2MPuxf3FS0bfetycZoCrNzY5Ikk7oJYQcApg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mc0sPreXhVH6cmYLfjxr+IUGiTNgAlutU7ThX8zMT/M=;
 b=BEW158Q/An7Oo/R2zKiVxMhR6Bj7aUU1o+XIoqObsOw+nFgi1gkEP+9WeNuZHwthwkU15e57qnHJaERZ4Q7etCW5N97+v1zpaWs3y1PN5QvKMYu1pV8ZWKWTuq4En8NjeprtJM0rO0sT3KorxLXf8ADBTx5BOlOvQE6o1I+XiVk=
Received: from DS1PR03CA0016.namprd03.prod.outlook.com (2603:10b6:8:233::6) by
 PH0PR12MB8031.namprd12.prod.outlook.com (2603:10b6:510:28e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.8; Wed, 11 Nov 2026 03:34:54 +0000
Received: from DM3PEPF000265BA.namprd04.prod.outlook.com
 (2603:10b6:8:233:cafe::7d) by DS1PR03CA0016.outlook.office365.com
 (2603:10b6:8:233::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Wed, 11
 Nov 2026 03:34:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DM3PEPF000265BA.mail.protection.outlook.com (10.167.23.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 03:34:54 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 10 Nov
 2026 21:34:53 -0600
Received: from [127.0.1.1] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 10 Nov
 2026 21:34:50 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 11 Nov 2026 03:34:33 +0000
Subject: [PATCH v2 1/2] mm/vmstat: remove unused folio stat helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261111-unused-sym-core-v2-1-3edc7fb8581f@amd.com>
References: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
In-Reply-To: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794368087; l=2371;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=oFAB94gxnhPd2K18rBNKPJgU8AMrMtnlf3sgrZ4T7/k=;
 b=cIPDzLnHbNJ0Ga4+qhzo60fJ6E8Ftdq/KZ8ixFejfBdom8VTww8+Sqm8VHBoO6jNz171OZlLo
 /07kpVe5EGVCiQQMBcRbE5AMgmZs5A4Dxb912iQkGOh4uQxs+o08zwV
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BA:EE_|PH0PR12MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b0aebe3-db96-471e-11c2-08df3fa4c036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|82310400026|36860700016|261009223027099003|261021123027099003|261021121427099003|10067099003|261102123227099003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jsk9L4yQRECXzl/OKrqhAjNu60J3fRJSzYffjLhsAqtymAmsLAs1yqjFaTqCFeLpw7vUPk4h3j7QFXb+Nmku5R4FDdUQSf3f5Zq0oUPmxFFUMX5HqDQ5UniAb7xgt7AfhbGIF5XQMotW5kNKbK5wDt+3Mt/Xx0F3ML/ZAHDq4ngCSrJtkv4w54GFFsOZg35E0D+jvmcQwZFziR0Lpm7T51K9/A6tzZyE6oJzhijJ8/SRcA4v/Esl7mvKEjEJUUfWevyHTkmFmgNJipIKpMp+YIsE8r64rtgCvvYfqgr9BdewR2A+zEyCP4P7oPDT5Nkm+Bfs4RYgQvGYKFg3dvPoxXFwONropfdheOZOdEhi0M+Dz11d+hVVkhHhfv1Gh1rOqgHkwLnxgzPAnuAPJzkeo8GHkE+/yC6d/X2iwLv59H2sdoH3RSfpAqdWSgjnljVgZG6bYZFbqXMv3MPRV52CbqCCpaHoefSLJgDiZYl0QY7Yl2ifjUuOz3TMV+ZWu62aCigOm+EM6RsLgiL9XzZrcwk7nYb4PxCqSRukjnuxa3I7KNVCCGeGuasgMlSWTFbxGQ7k2HmMU6syFYPS2gtmn5et0uEzE7fsR++dzCfBySC3baJGsOpBbYqM9dxT4szQzcIgdC0JNt6eDSMxhv9dMlcEu8eCSI/qhdCwOLKoQiNE9fPLF6UX8vBp0E2hKHHHQ+1P1hyRZn1Gcuf5RvY0ag==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261009223027099003)(261021123027099003)(261021121427099003)(10067099003)(261102123227099003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SUsMILYkwnRHafD1IAwIHwOA7D1g1s3dxN1lq+2CK7Y+wgwY1kCRE/rZMyNH/0gJbBnDQton0ubul9d8EzcUsnIZ0c4Dya33cJRFjhJ8zcUoC+2Sx+Z+d1KHyVfcv1Fz8WwUtUHu0F4W43jQa1yUbQdghFRCcgBuBw3WF77rWMUZ1ol304CgWWQm5Xa0FQkqm6efp2WSnuw63VV+809klbRVGAwFy7Ab44EpZJ9rUK2xGyfbKN3QRLYXmTlJ93WnvpG9zgOxXCUfx3MBrQAqR7Ies4KmxTl0BgqYD+ONPySsV7+kW6RnM1kClyt8eKWIRrH3dKKaVfE0PS2OJ3jCT96rUMjTKoKcx+y6zzpmRUuAKmpsI8btJ5OzC8sdEwfLsj4t4qgjEqi7HGsFv99eJchsGkwP7gvjAxEexzRhUbtdw9NhmwW59Ye8tigbKtJl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 03:34:54.1124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0aebe3-db96-471e-11c2-08df3fa4c036
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8031
X-Stat-Signature: mt1odypj6a5j6p9w5mnqknaycx4qwpip
X-Rspamd-Queue-Id: 8C01520002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794368100-635955
X-HE-Meta: U2FsdGVkX1/84IvKy+kYtG0lOrjRpLgdcUT/9QGu/Nfwags23h1kTaJIS9xrRXvtXWtT9T1pAqmn31zznW/rLjQ1I+C0Oe1EVnPZE62AJRaR0djon8rp9EdcJCaXw0c44BzT+WuUfEThwU5/0sMAlDi9VcvuKNUwbXRGHjbBg/uNKEhgyo+bOxLnFaABPBFQdD3xJS0+DtTyesnfEIDAvWD4Zf5KAZOz61pDoaZ7zgTDUGP+d+EU0yCSiVguFy9Jt0hFGKt05gFfjvLQhJ9turnqBB4GNiHT0jFAqFtJ2tuFvUSojvwR1IrGeQBv8KnX51z0bjFcHfz6zMRGDfsHsJDX9+eYdHplqiOvdwNcne8bAj4ixEM/D77bFmpQSNypLe6KCr1UxB37Su8BQdOyYxkvtcOGGjU39A4E8kDs1TtdMyJG+yx6wo/zYWEPGKgPpGe+sLX1tlHI9E5hPz0+hDBm7uRrZnq2WNsAVixLPLGXmiB47Hdfu5mMjeZzls+eOhrIBMEUoT0ZB9pnV7uhPg4505lXZRhOqLEO9N0h+E8NoZDUuql5uvzGr5l025yx1wFX99SzRxFFXn3hykJPUyMZGO6VpykzmBIA6jqKBV8MB3wx/ncd6DSWzWSk16tunzGP887vO1Nt8O26SiB69qgVeHMgMJulFdc86T1pGFWDZ/SUNfiu1pqFlMInXHez0MpNcQstuacT7tSz+LWaTZuGOnBQ2GtBnI8OJp/DGaxU+7OMk2KbHHNxk4azM74qoJ2g+MI4PF8qzUeBdwXFHK7ucUbHrtheKj61PPZ7yT5EUYMUFYCorzJ0AALdNsSj9RkYVxm6xfiv6Ipgv4lKPY93cbr2OzCm0G2n2zcjiPt4JtO2PzysE66szxyKV9IaqYQgZSyhlzhhpydzRqkZOehu7OE3KguOIdUvZAgb6VMr+8edEmKEDKdszLgUEK56Wxg8aWy9zoGdkfVvcxX
 SSRMQHF1
 YrNXP3I2qJoLoYocT+7DtWggxmAI4ZTCoZaygdtprXmU9ZcOfnL4peyn5lS7vgF6zlKypu0atGXycOxptVGr2wSjZFd2YT9nWxmfE94wtodboBhjt/IG66A17nTWQTvURAeqkU76YuC2cPGuzHtrXLMeHUCZ/KTHjKj3yf0lwzHPvDT1WV7QceyJeWd4QbmZk6hgzQR/bZZHD9vR33m7rk1HcvY59sMcIQAiA5FBelZZYvlgqbCXKW/kEUgjILPEXy8IqUkQdyvrAhGEZ71zR5TcyCHjpBgix2uJZlIIjMfcPIFWCMO1eKIXOPVGT/JPEG6iEbbmxLpBwqLzv6bWePieHPK2QdSfJpwEeF4g5WAr+uCSlRt+aZqW2yxM4/4gHwl3XgB4PL/SVQd5cWrCtC0+3LNUfKJXQjojM0SJDAogG7mS3U/dNOWijjJ3UBo4llcVu+jNV2vyfGmDIUvWr68Arxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__zone_stat_add_folio(), __zone_stat_sub_folio(), zone_stat_add_folio(),
__node_stat_add_folio() and __node_stat_sub_folio() have had no callers
since they were added in commit a53e17e4e97b ("mm/vmstat: Add functions
to account folio statistics"). The last zone_stat_sub_folio() user was
removed in commit f1ee018baee9 ("mm: use __page_cache_release() in
folios_put()").

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/vmstat.h | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5b31d8e7ae40..953d8ef65400 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -425,54 +425,18 @@ static inline void __zone_stat_mod_folio(struct folio *folio,
 	__mod_zone_page_state(folio_zone(folio), item, nr);
 }
 
-static inline void __zone_stat_add_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __zone_stat_sub_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void zone_stat_mod_folio(struct folio *folio,
 		enum zone_stat_item item, long nr)
 {
 	mod_zone_page_state(folio_zone(folio), item, nr);
 }
 
-static inline void zone_stat_add_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	mod_zone_page_state(folio_zone(folio), item, folio_nr_pages(folio));
-}
-
-static inline void zone_stat_sub_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void __node_stat_mod_folio(struct folio *folio,
 		enum node_stat_item item, long nr)
 {
 	__mod_node_page_state(folio_pgdat(folio), item, nr);
 }
 
-static inline void __node_stat_add_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __node_stat_sub_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void node_stat_mod_folio(struct folio *folio,
 		enum node_stat_item item, long nr)
 {

-- 
2.53.0


