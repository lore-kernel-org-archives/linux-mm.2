Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57CA606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eqkS1+6R
Received: by kanga.kvack.org (Postfix)
	id C89426B0795; Tue, 27 Oct 2026 10:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60566B0797; Tue, 27 Oct 2026 10:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AE66B0798; Tue, 27 Oct 2026 10:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2B46B0795
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:49:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27F31140A0D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:49:26 +0000 (UTC)
X-FDA: 85368689532.04.92EF22A
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	by imf20.hostedemail.com (Postfix) with ESMTP id EFBFF1C0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:49:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eqkS1+6R;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793112563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIfiK8RLUovcjpZQvUlWYSY0E4HcBzMfTj89oi3cQE4=;
	b=TXcczBPPheQy1c+Al3kWIlJirli9eC2ivl9EljnZ0EiqR569HyqJLs//zJ7mgheD7hoVwk
	8kqg4Uqcud2Up9X0JZuALvaI88aToEReEaTBRnYLxZZosDwmy552OeDnzNZwV4V/aGgRYm
	UQkv0uFg1nj5+OTGsGCb0o8Sz6HzAUY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eqkS1+6R;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793112563;
	b=670pejQjU/Az4CjWyhwj8x4rjVxsjWJvBBK1/HG3QS6vqLZc4N4bg8yXj5EEbT+/IcDKnb
	pDIZxqfYOFNskIqRjSHmZyU2oSdDkmwvB8xlSATeswwQzIkm5KyYMrUNsuTrqKIhAt4rBu
	yANeiQVU5/QUtpyz82GG+FXJ0X8z57E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RwspnxW/fQhd5NugdXIbFpLEaI1NIY4pL4I5tDtDXZllE8wC9QIEvFgoWnsFAC729DT1mJ5qeaM2Fr/Ku2FOJYoDeOdLRwSaV5Q2IOe0OioOqJDN2KB6+SRjYD/7CrkMPoYS9/PYY1Djk11zVFMIH6MUc51LDIrKVUDk8nlqGA6iFvpFKTFuiYUAQfpzEFoZUJHhxyt7MDyLEkzFhUzdcMSXLVlWHGxs9nB5N7bPQ1lT0nDPjDUivOVqvj/Sg5+Vz6xjmVJdgITcqXaSNr1WivjcNKBdUSE5v/vzAmi/juxNsuBrV7YI/jGdlgK1wil3pUNPOTvyC6tnQyNpKq27CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIfiK8RLUovcjpZQvUlWYSY0E4HcBzMfTj89oi3cQE4=;
 b=Sz5HZV558LpNuKCBMCXe9ICL2Jlka6U0X9MlrDNvd3CkOltXlIe0kdYlGObS/UHyAe0HlONIJqh5zMo50KN9jutsKaHgkfFoXt1ei3LrLSDIXXBweE0uVCrFirpnYJbRm53beDnKzMq5jiVPiG2qTgVPVqM0gSGeTAQ2cjumx+g6SDc1/9S78dg2zNIM2drR2wLD1Z5ZOR3vg6vO3tA4BCQi9CwVI9O3LVGmNhiox29G+J80HMWUY3H1ifYFT8t+Xp31vDE8+Fr1rHyEUa6JEQ7ipQAsULt2IZlLvCnQxVtrCB4IUmwxK9/yHteOx5cpeudy2AgL4N9OVwewjoISWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIfiK8RLUovcjpZQvUlWYSY0E4HcBzMfTj89oi3cQE4=;
 b=eqkS1+6R1dTOmp1NU1jN7Mt/DjK2MqQ96snTrmvIhAXbgIPF7g6a+GKpvy2YlKjkKaoSPPeJt2d3Zn6RP9h5Ql0p94mECLwGcbElaT1dH6vjdKZwAd0ciVETjocOs/W2GWGR6br4MtIuBj5KD+IrpBoNWZNiyyndIHrEE1ecWNdg11q80xPjRqI7NXJplIU/5gt0poaxlHsa0/hNReQP1JFDoDcaBA4dPIIinmzvOHT/+lSK9qmMxVqBzmu51d40VhT3Sb7WcJeBnvCKDa/NnLWMN0QX3hH8sCT/fG6tMe1FdyG5rrVZbmeARn9eCdIZRebkfUZ4teWfBXyowUB5jw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6115.namprd12.prod.outlook.com (2603:10b6:208:3e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:49:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:49:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Boris Burkov <boris@bur.io>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Shivank Garg <shivankg@amd.com>,
 Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH mm-new] mm/migrate: move NR_KERNEL_FILE_PAGES on
 cross-node migration
Date: Tue, 27 Oct 2026 10:49:15 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <83B7AC09-235D-4C0B-A0D0-90EA688D3CCE@nvidia.com>
In-Reply-To: <20261027043214.2248986-1-ridong.chen@linux.dev>
References: <20261027043214.2248986-1-ridong.chen@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR03CA0334.namprd03.prod.outlook.com
 (2603:10b6:610:11a::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: b639e876-a616-4f3e-8d82-08df34397ac1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|261026140227099003|11063799006|56012099006|261026121527099003|261021121427099003|261022075727099003|261022105027099003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8l2adlDtZiPaJ/h9ytDLWzAD2iSD7AfiLehdf9zE8mbH5bB+eHByS9xtJzzldocJpZI43RsQYBbWAJhQRyd0smvKeaCQyNBboYAaGOb4tMrNAQbbcyqFF0kfwIwpmIRSPMOdJMFURMxLnhxjRzSkGDNbUojWkud17PeqI2A+r0Q9maZlBd7VdbZKrQP6Leoz7d2g2X4B3yDCCBkEdHRe0sJDC0Navzl4DG54qb65HuAbZSw7ea2vLfoBreN2GoqizQw6MI0WkuVS4gX//Vi+7jnMSDpxK3e5c35stOKPyAFTsefGekjFtSZuhv8TgfzlPANcq4QSWlGUEuc31Sw9WthTimvf0u2eqREmcUpReu7FQRjTyKY2V6YCyqMqEzBURINbUbwwq05etHmg3YhAY9I8nnCGQO2rsbTYl7w9Ugb/FAHKkD9r30l2MpkB9Vgjb+h6d6B9MhMwA4rGEIHhsVjmyhTZ+VEibjUB5fwrGnUwgcta377f2gbeHqwU9Hawxog0YwFNXB8hOdRWO6dI3bhynbu+rMZGlP3z5oOpMVGjH+LZH6O1x1sBVxQb2xFcBpqyMRweKHC9qKrndtvjIpL2Uk2x/myFaffe32hozUuJDkbiMaiQlwKRRZvekJ1Cbeeww+EF77OcwEZgtV3KktYzwCrvH5eu9/Je8AxWK2c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bvtOvr31X98lFEgx4u8Tr1roWrvurLBs70I6Ibh5uAF41s2N8Sk63kONDEVC?=
 =?us-ascii?Q?Q9gJm5X7tDFbcdLwSPsilqKIwmG6uz5tDMWjy8+40hIPEo+LUDdhkHSUsn8F?=
 =?us-ascii?Q?elMcGldbQoAf9GOvOkkLV/ERJZocQOGCytfZHKp/e7GsYGi7JwAL2I9FCF/o?=
 =?us-ascii?Q?0dxEMesfYnaFj54OzGyyn1JZ+9itieERKdaKUwtw51TfaBcJwyqJZ8LlJgRB?=
 =?us-ascii?Q?gi3miNJ4mYA9/8UIMltON1MbOGvlEUA+cxvyB0Wm3RFJCo+TuSKufODnAqcS?=
 =?us-ascii?Q?oht4L/1rL+MN10ycSFxLE0vHY8FrCc7qn1gCjXgTkoAdiSt7A9yL99qMpp7j?=
 =?us-ascii?Q?fxqreM5UpyFPQFO1Rildl0PZA1yW/fwDRnXTlO7Hmm6xVYA/c17tOzoooJR9?=
 =?us-ascii?Q?GveuzuM/dnwob3VOeSmyQvB+yVXHGz8poQKRp3K37CUZiZf41sEUC7wXE6Gd?=
 =?us-ascii?Q?DXBTHkrWWqra2G/w0AmBLriM77yxqLGsMkMuT7NQ7m0iyb1TTyRx9dARH3VI?=
 =?us-ascii?Q?CZOvwzzB/9abyOIB2rkZP3SR0VdQEEaFk+H+PGFkOQOO1hAsxP/B0EJvUSoL?=
 =?us-ascii?Q?aiPieW4ttUI4rBOxRoNe80sdoQFeYv7ucgpBarSsjfIBRF2DtVQ9PsFJQDG5?=
 =?us-ascii?Q?RPrJXQtsY/FddzWsacPPjGVvr+BgYCmkCmsXzkK8q48nxc8ECCsYN8V1Iqo/?=
 =?us-ascii?Q?sms2a7XpJuqelIjM65UoD2nMyZACgAWJfTKPQN+8DDHxRAKqjXDWZQRfqAYx?=
 =?us-ascii?Q?Ml6va5840r7mMxUoO7iA8uRevyaTPx2U9L2iu6F090rXHQt+h/Iqf1ESYT7F?=
 =?us-ascii?Q?8bj62G4uyqMSwnZkeSUBPTnykvwph3DBg2S3yfJKuh8LTyfii848y2O4iFrH?=
 =?us-ascii?Q?KeTOAVD71vW35uyhLXbuCO9pK+GaXeHA2NXPFRuyazTrYVmOCzlb4RkkC0Tr?=
 =?us-ascii?Q?uXuZuk1FKjTGCj2Gb/x0UNVO4RHcJfhkLhCNTF6ZbgHKNSsuzQUASIoJrjh3?=
 =?us-ascii?Q?1Lwa61CgRtQOaLhH0EAASOb6bh9F6VS2G7hgOI56aKFpywzDFAmvroBeB/3u?=
 =?us-ascii?Q?tN5XkytWYslkw2KjDITULhkAnNYMmf02v54weDKFSyFBL6sq9dFN918WAbzz?=
 =?us-ascii?Q?HDdtj5EFvyUCeXCqXn+FiU/RBN3rPg06s5OBzEegByP02dF3cfvevfNhkdnF?=
 =?us-ascii?Q?J7cWNtupyj0Tm/wFCals5qevNtLVhSdA1ycf1PTLXsNBii8q0QXnevGjVLtJ?=
 =?us-ascii?Q?0eiIEl84RALmwAO4d4pWECVLotcHxtOlKBxPLXfCNphTohYhMpfrNizsd+SM?=
 =?us-ascii?Q?whw7YN+s3yiNMEgMGfbN3J+JZ45RKAXUFUdyvvJOmzGqZrFW5plP9BNp/v5i?=
 =?us-ascii?Q?b/6VjrqCVL+xD9vKq5D6RGF7z5/m3FAW7144gTCzOE2OgtNHf25k1/GAQx/7?=
 =?us-ascii?Q?VK9BHVc9g/og179JncB/3BEDhol6J7yeghcXbCcBzeCuw/hK5vU9+gN8HuYq?=
 =?us-ascii?Q?2li/sueMOULmMl2HkVxorCOGEwyAVegdhrgiXdYwseZbYAkHSALVHapdpl8e?=
 =?us-ascii?Q?xBgh06iFN16YeGzVZcGImI2k/nhL4EWbunrd2HAm+c0gkmSApkBNjI7tYK2e?=
 =?us-ascii?Q?CguT4zQDumw2OcI8claVX7qHUVUKT0jyZTZKYvHbjejuvkRlTDiQl6Sx40dR?=
 =?us-ascii?Q?0UWnxsuuhm3o2oOsqboUKGZLYQ4nrT4iyWyKev9hmBsqsgrjX8uJuAB3O4Es?=
 =?us-ascii?Q?pVt9upm8mA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b639e876-a616-4f3e-8d82-08df34397ac1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:49:18.8511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gP0wak3cTMcqVmBmXjb64gQplrdmn3iQMcDW1XSwlNKM7hjlLVdF39+AT3S9t/vQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6115
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EFBFF1C0009
X-Stat-Signature: icnfp9kxt4s1qyuo1shyi6smbka3q76x
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793112562-792024
X-HE-Meta: U2FsdGVkX18HIqNl5U9jYd+GqnyV+NbbWPNvrejqgEZKlyXRjJiHKb1TPemH+HNM4iNk7RIjbFdb5LNW5R51yg8WXsGlo5hBKodLqfVwJSD5G69JmJuiPS1LUzOqFKOLSU2BFMOp9p59hIOdvHK8NpSBRmS9fMgbWemILRaw8sXlqcQ0uef45e2WNB1MqhZFcDFEYC96Oxe+Erto9adgaoWATOfVxsDfQJXD5Hu7E/eWyOol+2RyYZ5S3Voso9vRGFJEdhUTm9y8NZLNwxHVsh/Q8BiujX5fmItNyu4wal/zcXLhQW2w+BCAcyiEMz4T2t6W8AfCRDI9KPYWyWFz8kj0FtavfDl8N0CGpYC5nVA/s9BU4eepymIGt/SVogzNqx+Y5m3TrqhraKQU1Tbe6SNDuYHHcN9SghsBK5vGOLDKjoxbrKGH6jOj7hs92ErAoRaRG8uXxvnzjB/GLbvUXdyI3yl2epYmDI0KDer4puqhHWoug+5nNyVMuAnOH3vyZ5B2XXR+hhVBfrSZJUNG3+z+3ijOjCKIgnNUtK2hIfa3+y3Qc2do7lFWn4y2k4hAGzWVJIcbWKxAVV+WmFsOzFphmbKaCQo1hfsseAg9tshYTqpyrwaue4/k3t0HMdwtIEpS+8ofQOdntJB63ZNwUyCPSzC5th2jjzG10mMIudvQlcDsoa7ujvwghnBhyI0D7YaBOCJuAiPIq1sVfkrK2I+3EQ5IRXfPeTHebRxfa0ZTA+M2IkjBHuaLJETJyJqE3RgXYvG1nfpcAHd8AMfy7ST09s5GcxiwnEHpHGPS8BARM0sAJHIuxO2/OLdgfUSLAyWoOxoDHCx5+z7ES/GdL02TIFfPtjqKpjXKNQMrNqwsXjx6Yx0p4QtfjK2W+BXY2vSxVWwJFBGNX9TdWxarnETwe8/fobEr/TxPNw8ErrOaFuHbo+Kb3kXq1vBIAwpg1haDi5YaNvbJfJQ22ep
 xZCt7oKo
 ajuagQFhW5jqvWTDRvffgBLYws9bDzFyCyOY2w1JKHk9jq2TI3JmjxywyHk1wzIzseWexOeBwe2HOzBa3YswS2NQY0ZMGb2G4qkeu9nOVVnCWQbfsB3BZozRV4RrKSu/92L0rkjFTtZaNBEC2PAD71r5s2kmWRng0stprjyXJHOxfj4rmZq8GoZlouTsIZ/SPqy7xNh8AYTmYLmy+hOtIJiWhuM4EvtXNykDHsHF17tZwnugvJ6uX1THj8yV4mwjvPxJsNbMRVEZtzQ8KR7WcAReUa8zO+9/tXCuQierfAQUEy4WQKzC+fgE6YFuHlOeZfAZOaDsDTluVXzHMoPFuBa/eOmibDR2F7xQ00wnrA/HPBjtBlFPzeaMtBNX1rWBkY91LTsxxNuZ5G7pIPZkop66YMgDowObc87av/Zc/C93bcEZU1xQRokav9d2LdMgsRI/+8G1/VyIvGBtSX9cX9YAUUYH8DuUV+7LZfUQ8MzjvBA+be6UfKYyCl/G0Bmswd2aXOhikoePLiaUAYIrqj8TmM+EE6nu6rK2W22Q6gYAuKI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 27 Oct 2026, at 0:32, Ridong Chen wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
>
> NR_KERNEL_FILE_PAGES counts page cache folios of mappings flagged
> AS_KERNEL_FILE (currently the btrfs btree inode).  It is a per-node
> counter: filemap_add_folio() adds to folio_pgdat() of the new folio and
> filemap_unaccount_folio() subtracts from folio_pgdat() of the folio
> being removed.
>
> __folio_migrate_mapping() does not move it when such a folio is
> migrated to another node, so the source node keeps the count forever
> and the destination node underflows once the folio is freed.  btree
> folios are migratable through btree_migrate_folio(), so demotion,
> DAMON-based migration (DAMOS_MIGRATE_{HOT,COLD}) or memory offlining
> all hit this.
>
> Reproducer, on a QEMU guest with two memory tiers (node0 is DRAM with
> all CPUs, node1 is a CPU-less slower node described via HMAT) and
> /sys/kernel/mm/numa/demotion_enabled set:
>
>   1. mount a btrfs and create 20000 empty files, so that btree folios
>      are cached on node0;
>   2. echo 2G > /sys/devices/system/node/node0/reclaim, which demotes
>      them to node1;
>   3. umount and drop caches.
>
> nr_kernel_file_pages in /sys/devices/system/node/nodeN/vmstat after
> each step:
>
>                   without this patch     with this patch
>                    node0     node1       node0     node1
>   1. cached         1868         0        1868         0
>   2. demoted        1868         0          36      1832
>   3. dropped        1832         0 (*)       0         0
>
>   (*) the counter has underflowed to -1832; negative values read as 0.
>
> The global value in /proc/vmstat is 0 after step 3 in both cases.
>
> Move it together with the other node-keyed page cache counters.  It is
> a node-only counter, so use the node accessor, matching how it is
> accounted elsewhere.  Interrupts are disabled here, as for the zone
> counters below.
>
> This was pointed out by Shivank while reviewing the NR_FILE_THPS fix
> for the same function.
>
> Fixes: e3a9ac4e866e ("mm: add vmstat for kernel_file pages")
> Suggested-by: Shivank Garg <shivankg@amd.com>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/migrate.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

