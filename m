Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 299BC606A884
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Uu5pNF6k
Received: by kanga.kvack.org (Postfix)
	id 486A06B05B3; Wed, 11 Nov 2026 13:54:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437726B05B4; Wed, 11 Nov 2026 13:54:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EB86B05B5; Wed, 11 Nov 2026 13:54:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D28F6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:54:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D175A7EFC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:54:20 +0000 (UTC)
X-FDA: 85423738680.22.B603D31
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0AE9140009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:54:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Uu5pNF6k;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794423257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9WuI9PTUeiv5O5AStKEefptoT4aWnKBezJfaA7uZAs=;
	b=RV0H+fVBipzd0w/E9rbrPoIPJ4PfEw378TwvurUvu0vuU16AZar8QWV5Ym0YUt8H3Drhvx
	+FYNcLzazjgtY69ya1rqXc+tuMfdKHJC/1sLVL6vfHrJI/eEPhm2XjG958hq9aqTvYi3Vg
	l2K1qdpdr68T7gApnEnTJNNHQ502lao=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794423257;
	b=pdVMo7gPvGaWHAqdlSSbNGKH1pBUKO9njxyAm1zZDAuXj0TdnOHoJjxzxnlvY9p7lKSBf5
	aoWiSPpytC0LEkRqH1/ZQamhmPF5REPtxlCRV6SpXpSwavSL4OUE4F1DNa9FMb7BOkupkg
	UzKX3qZKvBxVZssZEO0rKkhiTzmDyLE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Uu5pNF6k;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPi1Dx7GMkpj+qyUXhDxT1t/NwGo8nr1U5AVdZpUGXabB2oV3MKIj0dbUEbrvMAMpF6g1CXZE6O0jAGxeLDonDE83krSVzpJuW3p5rI5GxHdpE9oPzHQFfqtXQruKUHN/MqS+YfLBuYjYjWABeI6qOXS4NzQnUMUxqsS7cVpMOfaVUuCUiUafxGuNQA8D8zaalncDKuoP1jjuusZo49Lrq2YC+IVYLLjhXaM7XO7HxEYKPydip+qc5caKhZSzzUkr6V2rohTYYUYACciTB2owPMduUNoyRHsByxyFua+IJ1vcQVcWB+a67QcVkpxZBgxxzDuNNryt8uowGuIQXOpIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9WuI9PTUeiv5O5AStKEefptoT4aWnKBezJfaA7uZAs=;
 b=GP4bTd52ZxoU21x4ShcPU4r25+FA3clE2gGoYHS4yOZLW2sbc9x3x5iZKTikJn+coqvQCnBDt79toPjlmLDSXIqeTOvDffYwVTwyTvfCFJpf0SxWzOYO+p52Lq3jlRODLeHN9ZGNCaXfRzNGmvykt0hxqYiJ5rykz9zaQ+yvibPhP3uMZ1sWVLBJl1t+maWxIREK2y/eL4Ndwn9Jiujgjhhbm5o+Dx8Oib7061P6/ySJai0QVKd0JiXo4EZ3bbuOlMS12BlCMvAIHqzOj5F2whNS70GHCyisDEEwZ1VcBCQSjHUxjz/2hCXGXlWSfJK1ThVROn3cWYpkIJZh3Hc9Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9WuI9PTUeiv5O5AStKEefptoT4aWnKBezJfaA7uZAs=;
 b=Uu5pNF6k+pWE2vvGyeQF0y/Nb4jfPkn482MR6iTVjk9OES134lLpEMAhuNbo6bYnkWegVymgypVV2S7GEuxULCGcbCGGnp8KVDVcN2oapUHnhq7xm9QvGZORNhUUjI5hB/EeKKxBSkjHkFXsPeA1Amf/AC0W8BzoRvrm+yNxLCq1YWITI6bzvq9q1PT4vN6ZfDbsFytgwrdtKHra1ezlX28YzbJ2T9EA+JAQQa7FkghBPZ6lFd6FGnpQe3EE/XTVsOfjR5FnF9OKcck91jgDtp26mkHPOtzaAwvT/23wTVYMXaHEtYHspJvpEjk27p0YXLY3bp51Ojwt6hGK03ye8g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS5PR12MB610447.namprd12.prod.outlook.com (2603:10b6:8:47e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 18:50:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 18:50:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: don't PTE-batch a swap-in over a
 hardware-poisoned subpage
Date: Wed, 11 Nov 2026 13:50:29 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <2214E459-71AA-42FD-AAAD-07C49C81A676@nvidia.com>
In-Reply-To: <20261111113904.650722-2-usama.arif@linux.dev>
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-2-usama.arif@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN1PR12CA0018.namprd12.prod.outlook.com
 (2603:10b6:408:e1::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS5PR12MB610447:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c32f3b9-35d2-4c90-b82e-08df4024a96b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|261009223027099003|261022105027099003|261021121427099003|261102123227099003|261028144727099003|261026140227099003|261026121527099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	he+ZVwj0+LviejQYdcsw/NGx8lSlMlMk4rBWxVZwpfeX6jP66N3OW7g1QLSQ0LaDBzH3xlnExf+7rK9ZxwsfsyuTlavLYwtcluaOGr7ScHad7E06n/brHAx5c85he99S9eLyi14w9kSNFJYZczCjNvAix2+lYSW4w7QbhLMDy6IDeYYG00X7y07CAXmxLd2GxgrZJ0bPyhxnqRLyMdsBahsX/QxtnOSGY1IPvF5Puwl7f8DMB0n7kCYWeDcvK03xbrISfaDlqCXx5SEoBo3hfHtu5QLYXPfcCnte/fKJbww33YvI+jUHyVzOwnZEqcLIj+61GMeVSzflP5uGx5Z1powqLT8GYbFL34v9c9npFXDwoTlnAY52z3c9/a5sopfdfcAjySVRjML8mef37gXRgklyGygQce0bff8LNhdz94J23J/wP3kh30ROBBVNDgGB2DjousnlZNyNv4o7OFZ68ylKweLhQ5dDFcaVItbaGJP6DnC/b5odPNuWjoiZ81HHKNZT6kWSeml4Xezk0gzDC9HRjgLDDIkohTs2Ph5Ib0nlDSxtwgues9ZOR27sw1KqXubJVpAFhFOTV55Gb6d/XOSajKcJPLT/OPp8J/EWaJU55ik4BY+28mc+pHhp8Eq/tNVTtM1sVCpi8G4BWY6Z5GnpVPeH6MsnpubR9L7C7p0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(261009223027099003)(261022105027099003)(261021121427099003)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3XsgDbMIkftEZ8P+l+IzJZ71n3bmPtDzXsL5kgnveTOUiBNKWek75Af1XmNN?=
 =?us-ascii?Q?/mPNpwpG4Oy9+rvXWj5CsN6X0jIQgZm2YcWrlWCa0bvvVLxPpULpJgKzz04M?=
 =?us-ascii?Q?jVxXcsgoFMStCp6OrcOnMd5ryO7wkC+X/6NWxwyPnHe5zRpqzcO+SxGyMypf?=
 =?us-ascii?Q?c1WayMcJxgxj+lm1yhzHCUMCmVVmquzIsRAWU5jZruSUwVIqyjUiNe/U1EO5?=
 =?us-ascii?Q?VNf/FMvU8omcpGjvfvqUmHRi4kV8oyTRykLfXXPAY1RWf95+tbdMZPGoSXdh?=
 =?us-ascii?Q?WtsVx0E3pDjjqclDvbsIzjvKw5Xad3kEj0RgD1rtB/RlYv4qDhPwD+r7qSWj?=
 =?us-ascii?Q?3d2vBWBsK3q+y0ww8MH78kwEfLyN4MC6A4i1oAZc3pMekQjpTaDGV5BR7FlZ?=
 =?us-ascii?Q?N/4NLwn+B/Y7zxd1BvgpfR7YV+XtKnXJ/Dt0LQOoAXpHSUWdg81B8aUGqLSc?=
 =?us-ascii?Q?SKGrIxV04ZFL1zHDNkfMDMLUdl/+T0LeOzChtCHsHh5u5Psdv2IPCYaCmNUa?=
 =?us-ascii?Q?WnT3wH11JFX/XCuGua7TXVExxgm8GdQELWjW2BEfCHdrXKVDIuwQOQC6s5jc?=
 =?us-ascii?Q?nJaMZr9I4OP4XSquie0wPdIcNDHHi3siOWB+haxyBGQ4op8uzX7h+U7bGapX?=
 =?us-ascii?Q?pAstoUiz+UwlopWCR95f7L+gxgd7pqD8wCS84gyOYd3rgXbrt/1e7H4EOqov?=
 =?us-ascii?Q?HsYHSG+It+vxMJXgfaOoWGR1kK648yWm/wXCEzUnWf4vAQxNWJ37mux1i40c?=
 =?us-ascii?Q?G0S32z5RrCn2H3Vp4Ljmbl2T+jOBKJrKkHzf4YHnV/mrfkckt+TBJSm0oNWk?=
 =?us-ascii?Q?xCc1l0+A8IC4kVmtVqe/LRlNaxDCanVKjaIlE2fitgwvhH828TjGI2/Q2rW4?=
 =?us-ascii?Q?VGplQIVQdkjvsSskfo5QyufNC1SGl8z3IoSmzoWwACo8QJ7q/wNHVp82OGuM?=
 =?us-ascii?Q?TUD3T6O3ZTdnpDoHbSaL5Q1ucPp3gymYFKHOJMEA9OnA9yirECFNla0zHEs5?=
 =?us-ascii?Q?n+8n2g8X0/ZMkYN+Ivi33fN1IomWzGiiUNYSrHu0yAiBWUNeSEmspGondwiL?=
 =?us-ascii?Q?PdwB5dHvV2wmrhP3WzSRWHHoz91vojtd1P+pqBuiJtJ9ZX2gUP3zI36Rf3MH?=
 =?us-ascii?Q?h5/d95bD6kkufBUKNOtqJtM7AdFVP+2pMrxiHfoPys3EdHD24XCXRFNR1VQs?=
 =?us-ascii?Q?Q8wZzQZz+84KnRdqxu6Sd+wh3+foRO4eYq218q5YH34F94XwIp33K4t6x/oA?=
 =?us-ascii?Q?GB7KxI0oEwHHhZ2K2Y5FjwrnVGrvL35lxhlF98R8XKK5fNmUdB0uE90m9+oW?=
 =?us-ascii?Q?zS0g4QXGeL1ClBE4+le985Q5yE6wDZq/j+fgQ52MtH6TgcV6QIOOQMtuSkym?=
 =?us-ascii?Q?wbH3fpjdVdmgjVIyzAc5RdYe/24eBBOBX/CTHkBfs3zXnsj3DmNtGKKXjo6G?=
 =?us-ascii?Q?cgakHDbrQMZi+87aV20RNpBadLec1aPPU7HZw36sf3SLBrUDBUXu3xKhwkwd?=
 =?us-ascii?Q?nqRyTajbyH/K6JrzPYsJV0T8Jlxcep9KugWOtjKR3AEd8r3LdMmifTu+Rgxi?=
 =?us-ascii?Q?0naPQFA6iimerP4mQ11K4sE1Kgbjxo/jsdpaZpJPXskPlUK3NvQ5nggWVB79?=
 =?us-ascii?Q?hO0bKqpsXNmE7Dmur5Iagp1GMmnFk2rmfVpWoIVwd6KgK6vxinfiqw8UQg9A?=
 =?us-ascii?Q?KcrDBUHiK/ZxU2RHJWLH2/soE/JA+WQLuZT/KLSRmLrZuhKF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c32f3b9-35d2-4c90-b82e-08df4024a96b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 18:50:31.6353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilBwrFiuRtmzObXv0uACuKYow2t12J8FndqAWDKi7Yp73c3sNhhHpyV1roZq7OzV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PR12MB610447
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A0AE9140009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d74r6sq7b9tebyjr434hj33i3sonw1ao
X-Rspam-User: 
X-HE-Tag: 1794423257-362786
X-HE-Meta: U2FsdGVkX1+7le/F5aHSy9PXP++LYH8E1fHKoo9vJai9QtVVhgklOcs2lLI4ww3DTrzEoc2nNz0bYvFpajGQAQ4rVOfx16kDtEiOKoD4Lg08VrcAUyY8muY5w+i0Zla1+nLxf39ZQjUfvXkjWg+/M8vjJX8gxPQkROXV3ypNXIF9KA/uRfKy/MIML3aT4GD2hU45JCppquMfGlL9fNf2M5x1F+mzqqqDZW1trKuUXjU8O4doD74GuQ7gYws7dI+ysH+wRvnF773SIfkg7ms5TBu53BeTkB3wqreYWFn01l5SeSQfYfsmq7nPXDBlcmTkz5yl8135jmxYc8sw+UKB7UrMCi+3YqiAf9UnJMuQfGiM3jLcquUg0CpfD1UzSnv2J5q+NMiMk4mxYTTMlxVjJFAq1Z1zpjMCTl+5HNQFeby5TFQyIULdMDCLh8BmmZbVbgsj8voKZ78EzXG32J0IaXUzCABrY0ObhmF1pw5qITf+pAkHvQ8Umyw02Dt4kzlccZ8w7jsgZZP6r8jaYp+21/f7uPmYqn/cAybxvM7ohANmql9c2ss84tRFVxI4kOX7lphkoUGibgiYO0nu8StBpINg6XQ8doxyQad2raA48aaW5+OeDLcgHkq7p4Ukp0lAewSInIplpdx43A4OpWfyHfN3idfTQVqMJj9v1SWaa5Pr+CwHaqYolyl6QKgruV4zoMdLRk583hDXuYOmsCp5HMJuzg8TxRTdM27tTnhZUYbUPdBQnk8wPN7W+hQN1PylX5snj+FQLLGRr2ikk8kFMo8lkrGcFkUwFcR5pYPLMPLMztjjOQiXCpPPhiOSwFB9+358DQlaCslTNS70+eJDmh7gwaAaVkakD6KssolOXU1GnloUm2XaakDjyssB73+mAJDFl3lKr40/HwYxusAwQb3UmfAtWODmcrKXkBr9iN5w7JzSGK8++EAWfWdiJK1jCMMIPgzNNbkCdsCsVJJ
 QGDc27ib
 ESMdL7B+m+qVBNALf8GLh0bdGu0G5ooRcsdEpG+7l1uiUKmRz3/ZHr3dsmI6u8KdkrCz5cpOMyXPAbBJ+4QxH3s8U8/X+C6sfQT0bgSHKpQN4gBkG+vp6St+achv5kF3coTDyE10HbvdfpXEUcNufVpQhgswnqVoD6C2nO0+wJlhhyS7xP81zat3WcdGvKZULUwm3nqhwfrJ/mJJTkeUcG9UfJ5Xo7Mhe7utmRhfsZnUsTM5h3yKk/wFjoJX+WDrH/dIwsLljEqfCn9wdBzmzYvAaCPRA1f5uXFMedVat4/70PwyFCoLpva/Y7iFcF57WPm+BH1uBvdHdd4GWgfVoYg4UQVtKS4jVokyQln6uG/88hNfGyRJYRyEC80VOM162I24/rPARSK3s9WLYM/mIDqZl5qEPEI+2qM4d4ebuuSv7B9ICuWuTkDfVcDAnoAcYSARROhdiDYBruhsnJwvIKsihww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11 Nov 2026, at 6:38, Usama Arif wrote:

> do_swap_page() checks PageHWPoison() on the faulting page, but the
> large-folio batching path then maps the rest of the folio without looking
> at the other subpages. A poisoned subpage that is not the one being
> faulted gets mapped anyway, and the fault that would have reported it
> never happens.
>
> Skip batching for such a folio and let each page take its own fault,
> where the existing check catches it.
>
> Scan the subpages rather than testing the folio-level PG_has_hwpoisoned:
> memory_failure() sets PageHWPoison() on the subpage first and only sets
> the folio flag much later, and the bail-outs in between - for example
> get_hwpoison_page() losing a page lifecycle race - return with the
> subpage marked and the folio flag never set.
>
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/internal.h | 15 +++++++++++++++
>  mm/memory.c   |  4 ++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index cd3675c044e0a..e61c02f4019b0 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -28,6 +28,21 @@ struct folio_batch;
>  int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>
> +/*
> + * Check every page of the folio for HWPoison, rather than relying on the
> + * folio-level PG_has_hwpoisoned, which memory_failure() can leave clear.
> + */
> +static inline bool folio_has_any_hwpoisoned_page(const struct folio *folio)
> +{
> +	long nr = folio_nr_pages(folio);
> +	long i;
> +
> +	for (i = 0; i < nr; i++)
> +		if (PageHWPoison(folio_page(folio, i)))
> +			return true;
> +	return false;
> +}

It looks almost the same as page_range_has_hwpoisoned() in mm/huge_memory.c.
Maybe change the function to call page_range_has_hwpoisoned() instead.

> +
>  /* mm/workingset.c */
>  bool workingset_test_recent(void *shadow, bool file, bool *workingset,
>  			    bool flush);
> diff --git a/mm/memory.c b/mm/memory.c
> index d477a4f986bc8..4b7d456332200 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5158,6 +5158,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
>  			goto check_folio;
>
> +		/* Let a poisoned subpage take its own fault. */
> +		if (folio_has_any_hwpoisoned_page(folio))
> +			goto check_folio;
> +
>  		page_idx = idx;
>  		address = folio_start;
>  		ptep = folio_ptep;
> -- 
> 2.53.0-Meta


Best Regards,
Yan, Zi

