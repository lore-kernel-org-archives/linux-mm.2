Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82B1FD4F17
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7D36B0088; Tue, 10 Mar 2026 14:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E558A6B0089; Tue, 10 Mar 2026 14:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02926B008A; Tue, 10 Mar 2026 14:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABFD06B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:33:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 436E48AFF5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:33:02 +0000 (UTC)
X-FDA: 84531000204.05.B37280C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71211140013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:32:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ctzoAVZ/";
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773167579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCSIpOe9n2sFHnl7WhFpdBTM5nHLTpx8JtrsbGnYjEM=;
	b=puWxmrQDMFL2vYnzLtT+mTZPb4NDRAfa4NhULt++IfTNrDTazaeMGhu6FnbWqBOp6RM/gF
	fAT140g9kemBaiXOr7rI/X567GTiM054xHJPn+0GXNvoVjNa1KZWQZLQD5pmp0Hsfn0XLp
	9XXnEmV6n/RBdvDm7IxAY165k2xT0F4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ctzoAVZ/";
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773167579; a=rsa-sha256;
	cv=pass;
	b=BnE6LCXLf5jPc5pXEasJAlP3z+H/Y+yKCCk1BMqtyQff0gUWGH02hc2Ku/1lSi0avFbYoC
	2W9KLBMTZNe8PQzg1hzWgmfpkFvwvfniEnzoA55SUIUiGecBW6GKekWcqNA52fzgX1PWBz
	2aWHSyMvc9N89ao/IGDhUF/Z+pC5RTk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3bSDjUHhcv+jmERRsdWxAYvjAaBoUpx/xqLZh9lgm6wIepjOLqoQOW6UpfpZkcaKP6yp19DpxM2uVCDPIzhkWAxW2kkDgnAnw7UunlJSdox1ssXMgUAxTsgO2PnubB5thRF47C3UfgDLmbI0Q0/XirSEdpM6Akicm6WPEkHQtydqyPUxGQuLfRdrK4ISJBQ7ueeotutJqkafR3+iFwZMmrsSbNdyHYNA4nDs6xQfflVyrnd4Eaky1NKC71KjyqrHenwO/UwCLq3UOvtOpzPLI2KwNxKdaEp+iHusQkSLOlr4OHUVyTS0SDOy7JGf9SNvIwFD0ApFmhyJoIYgWSyCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCSIpOe9n2sFHnl7WhFpdBTM5nHLTpx8JtrsbGnYjEM=;
 b=NcEFUYJKXEL6XdHMPT1Z9D52jVPB9mY2LWubyJpTPkaw/lebQXXmi9Oq7TJUgKBG0tb0ZSR5HjOoPqha4HqKd/ppE+58ctm3CxlvJsZt7ACt4aUCc4GTepqJCEKZ+AASOxO8HXv17zt87UR4pkntsCp8s+jE5hLDIO7wU5TbRzO/Tvfccu3PTOoLpAQ142ptueuuPfzZbcy5P74eMNZI70SLndDBkqLnlGcF556VQw1GJWYeR3jYwxCmIsEOHWkdVHtVESAqCNYzfYmPCqmfI6/YCFrLQsIRbYTTS3OyEO33hkdnKyULc1EuKtVf+PyEkQ+NA0LWlbpnfLmeEVy5TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCSIpOe9n2sFHnl7WhFpdBTM5nHLTpx8JtrsbGnYjEM=;
 b=ctzoAVZ/KmM5rNMKEurGu70+CankUIwK06edOStQ96CK1wZ6BzUWfQkraWcQCQPItOJZJCzWjZtW15OgVLtDQe/4qcrx17MXuNisdfUu7MhLVB8LOMCKvk6GuP/N0wrb4iVwUW2F9W92l6UafXrLDMkP9pWWWjedcag2I+ptfc0qvAj89sGdNqI4uGaI4z3IIgqS/qgsIwaURABcuEZWPi8vGs6lLxQ17fr52lJEj86nRV252ON4vsQte5kKivFAPcZKfDCDtlVKlw42maXzgjxXADEhyPusIfQDYEM0WM8CnsvLCywFHOB6xKtaFyAWm5YfEJqADjrkmOO+f/zMcw==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by PH8PR12MB7229.namprd12.prod.outlook.com (2603:10b6:510:227::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 18:32:55 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:32:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 1/4] mm: khugepaged: export
 set_recommended_min_free_kbytes()
Date: Tue, 10 Mar 2026 14:32:46 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <258746C2-DF4A-4154-8AAB-1CFA75B1D852@nvidia.com>
In-Reply-To: <20260310-thp_logs-v5-1-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-1-686099175bf6@debian.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::20) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|PH8PR12MB7229:EE_
X-MS-Office365-Filtering-Correlation-Id: ef27304b-a467-43b1-4129-08de7ed371f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	Oc0Ul33Dqz06cBqlZi+2807SkWljSgkOvaqAL1Ss2tktSeynAFkN2ddbp36/8EWjDlNOBWAarDYv4/pp99SHpjAwp8kHB038luT2LTRND16eBy/zdFPcPv13DylFMrqFxmzI/Qe6xnx/tuOfxi4SF+8OptkIfAjCmRO+RJBE1DxCh5rylHBvwVBDXwd+kEqtKxpgmOaYn6TKCxOwzptFxXeTmlZmK8m8I4Vobhq6SC1y+iTNiC7rCo1BNSDdX9n58gIqcnMqztCEbCc7yHk2vxqcVSi6pd/YDHyS4RC/wzcO8a3ypVbER0xSc4FKUPA+RX6GqLoD6tlroUW8hsdkgIZo/5YOJFqdtJvsRcfejaubDP5z/5Mnw3Y+IFa7Qw89e8o86RaTN8igJ3Sj+ureVhwAAzUnBOgHrA3mABwlK0pAl7nNg/MogrDP2PIxUS/unY+bTVPG7+btRzie2ACjyvcCB3De2t4bQ9ruh8P50QcKtR7HbtYiXTbCCXlOpx1IVwvSm+EWd3EeKG87t3pFo42GJ13afPTxFGfwi3l+Kf65XiMXjkO1EEHQpTmCoyaXk5eLwrhJ2u8otRqHV7RHM/GUC7SDFCzyeLALV3s9QtHE7h1iQXBNKmZCmg4W8pwTWwV9uRy6swObZGnuc8Hph3negZ/8gbRqhUTGhAUtiddmcjZGtRKc/Ds+G6DIb4W6evQnjctgbt4xK6W19tmAfvyH6ORSYrd/4sgR1AiatT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g3k+7aLisxQL5N365PY70rSJIEeRlm9rIowcB3wMtuBNakJQvaKtbiiIkkBu?=
 =?us-ascii?Q?kgTfxfLXwry6SvTS+f9Xs19guNJ7MMQkM0cD1fd9rFfrm08CtDaENJ1LZuu0?=
 =?us-ascii?Q?nCPX/etPd/k6mz4UT5NGYjUEDWo07XjjNWH/azoJie6WSE0OxDv0QtuzJrM+?=
 =?us-ascii?Q?g13GSr2UY/nmWbqy21H8pm6Q0SCOkkBvW72DGG5/PetmXvgCrgnwUK8u6QG/?=
 =?us-ascii?Q?YChoKjiTWxk90JEFwSrpKx9FA5ig5HTKk8pMxtVhyNlYipnFBEWiOvuQgy+F?=
 =?us-ascii?Q?GVTY5y2zetwUqftMyswMdfaUGqY1L9jYc+Y/v081Za9KAcq+dasXFgY0JfZ3?=
 =?us-ascii?Q?sOvSpiazXty7gafr+i4ffxT0/jbDP91Ku9JiOwy0F2Pb1M2yATGqTi+FtL20?=
 =?us-ascii?Q?cFaLCTibuxaJBV9fqxEvRP4AV6YWno3T44W0bjhlNF9HkeCZyfqQ+2jvbkwV?=
 =?us-ascii?Q?vUJ0xY1LORzhHduQTjKODBnXLfC6I8uXh5M2gt2j1RhL3qwvMqq4dcTxF+eE?=
 =?us-ascii?Q?EydmM2v8DjbyoNJ6usSWEGC21DOHnyWQP+ZlSAQZlkNm55qKoKb5CuoaUe7k?=
 =?us-ascii?Q?p9OhnIvOPHWLwmbsrBE24clj3ljbLwXC+x1VK/SQYRupiD0CO/F9UNDtQ8Bc?=
 =?us-ascii?Q?n2r+yXURG+aEgqLBaTbBNCDrnK6s+Z03LmoS3H+XljdKYd2OV4oXP5aIn3/E?=
 =?us-ascii?Q?MoonnI4SW1oG8/fTdGScpfcQToC1QjgfmsDN5Xf8AiI4EDzmPlgN/ms0JRtx?=
 =?us-ascii?Q?kty0B3Qu+zl62TYwEeW/5yNsPbD9Y4J7Gw9VsoPrCs1FHjukqA2E+GiAcyG8?=
 =?us-ascii?Q?kpyZPLMOwW5i9Z3w5lKcUJzQNonCWviydEAYE7lnMnqEEJ/kP7kEmQfrvXZX?=
 =?us-ascii?Q?QuDF74Ghf5SeCFFT9UbkBSrZ8DqxaaAXEO815G25MPGVuuBdNQ7u76lNqNCl?=
 =?us-ascii?Q?EDNyRbtLm9eTVYLxgZFLLv8L30UmzOvCm0zNoUcHG4irSgDj1/Lb/v649uhT?=
 =?us-ascii?Q?xY67xlfdbjgI2gz65GKLOhlCLWGpydwsyJ4LPZ2u3u8SNB9+2SXYcZiAiOAa?=
 =?us-ascii?Q?qqNa18EwwOqT6Vlf4l3+vhFtoqeOdD7JqOIx7h/8RlzLRa9Lq9io7f7HjM8E?=
 =?us-ascii?Q?fdN/G0YuCBrby4LxTlDVWVlT2WUUUYWsGU4V55XubEDjbA/iikFFzfy6Jfd+?=
 =?us-ascii?Q?sEtLUh+0rKvO4yjrpxlmcMLYBJB/cKd1u7qHdhtDsicbaAi6HrNs3Z2JQktn?=
 =?us-ascii?Q?k7WDGYixGBkvtoqQFF41eDkhGuNSosnwoWnwRRrnTu8SZevsOPL4XRaIWuPO?=
 =?us-ascii?Q?aBUA/X2M4Xqct4PzuRYZWDQCdVitt2z9Wu2nEVEkLMpPX2JUMxtmc/EYPnrL?=
 =?us-ascii?Q?L1NBXcdfVqavs/0csUPAshxIsXW/HhI5duwymDjLMFIa0Z4lSecBKwiJJblB?=
 =?us-ascii?Q?C5e6lIGgW3VuZ4I+QyCh0tj/7UnX8pGRXxrp0WSQfiTRtx1rYzJXXSPAr2vF?=
 =?us-ascii?Q?XJYckJ/3MSPyE1YUu6lSgQFhIgJCXOBx9ptSQ0q2x8QHgRsrzDtBdjZgaH4m?=
 =?us-ascii?Q?aPr/LaKxKf2EP0lh6CI8kh7yg+BI+UHIv/dZLjNkTpdtkKX3FC3ZFWdwtfzQ?=
 =?us-ascii?Q?wQXI860CU23FDlamKFAmVqzZ8jFhedk3Mm5XsW1VSb5mx8aZkk02u9rZEzcY?=
 =?us-ascii?Q?EBct3oZRovljfCTIxATgXgLuayH4O1fQA4C2mLwNRsXDClco5LMNWAdlvsda?=
 =?us-ascii?Q?tuAnWgK3Rw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef27304b-a467-43b1-4129-08de7ed371f6
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:32:54.9372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umEooPjXGn2LRD8bTnvVNPTJAfwApfAf4MKXxlXmbXRBE46AjVOpK9s3wgS/E3so
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7229
X-Rspam-User: 
X-Rspamd-Queue-Id: 71211140013
X-Rspamd-Server: rspam08
X-Stat-Signature: kz3i3tymm8xsbdjoadoxwrna4s9n77x1
X-HE-Tag: 1773167579-241870
X-HE-Meta: U2FsdGVkX19sUBiytQBJoxWLQBziuSD+6k69gLXKxjdzT+Y19NMfx2h0NBktnH5NUoU3byTEfDSy/A/qyohRCAm/ywlgjMsH+R00Dv4ccpuAg0wqIoWkvYXq/fSXfNuymzcLu3FFFNRFmi5ZbIOb2wrjuXaGdGVI/NyiW/gGrfBBpe/CYI+hcDuJU/4NqQYEeYSHtZlw/JeYiWU2Rcjc6JD1lW9PpMcK6ZBCPtxLoFLc3hJF7APHqQIev+qvV0H8GUn0pJQ8h96scJOdhi7R0rgrbVA6npO5MQnHmvksplxH7W1f/88QuBw9Qj2RnsYTE73msYjhXPZe7msklC1BF/iQJM5xyratiKJLiOcIYmFBeUXV9G8eeeXdPGxb4zTl/Fwkie8ptnjJh4rd3UJGaFxB+c5wO42nZvjDfZdHbmE9zhp34u8M5f2FvGquSdlnMVLnyZa4AQu0NbOT1NS/lkzplRz4A+tkt+4MJ8Q3Zvp10ZijmwV28seJVo1lwdPl4HCLHv/fEg4S3Nb9BomaCiKRk37NcTKJnbh0Zj3cvQ0u6lSJWLnvtl8DWa/tWoUGc73DJPJu+FTRAMCaVGlaDfbhuP9nI35NrSUDa45TsnkHjcIRxMsFM4n4pyFW4HL6HM5hMOV7tygwsE84yA2++nP0ug0tMarwmTdnkz4YaKp/hwUdPSTDXfXGAPacGrWJBVRGRF1Fm0HOaK2dsUmrz/LspMIyMB/LBbEVObFdZyBlioA0y3aakFheU9BSiIZxrIWM4ltgxHVp5hm7M8i1IxPyCRibFN07ZuefdT/YkDyNJRsxc1VzcmuWnhvd1YBjqQMVcrITFPObcWLMejLr4N30p+Bv3L/cg0el/YMLIKYO7jxdNZNKVHOiQ3LxFBns3YOMY7kvEZpzycrjFDq3rB8owghlWhh060p1XIXQsz50HWlkUD9P+XNv7EsP9qPobkuD2tESzkAmO8s+RnS
 GCGjv131
 8U0FJ9CQpD0qalVl7vwsA3OxXYyyqtIKlokT3EbZb61Bp14xlhQa3m2CYTvEPScdn6s1GA2PfhpiKnh3ELpobogEQGtVpNyczsBzByNfiTM5jh4XWhljX4eMGFiz43bg0tQOQ/dVkemYmwkttb0KwgDJvATxlwttp2YHxjjWr9+Z2KfeSHxY6B7ijhN28zYz9DTnH55KfBV2tkTrAdyU/Np1HpOYc3t9ERY6pzdLVp4tEwuo3G2LjW6Yxg3sj1frRq43M6yxqhVrSIyUUbreNHrDuInh3vljrJUtJBEtBQseSZOmNqgzEV0+wdQn6kdhh7XcNZ7jyYBEhtTOQUvLryEyGb2WVZYtyUxA0eVIAbUXbV4Muydyvf+db8ubq1eL6pnci++A1rstrulEFdQC/kEJaxGP52tlWVDGAm1v16IsSA4NkUbHS7DcCNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 13:57, Breno Leitao wrote:

> Make set_recommended_min_free_kbytes() callable from outside
> khugepaged.c by removing the static qualifier and adding a
> declaration in mm/internal.h.
>
> This allows callers that change THP settings to recalculate
> watermarks without going through start_stop_khugepaged().
>
> Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/internal.h   | 5 +++++
>  mm/khugepaged.c | 2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

