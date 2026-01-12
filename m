Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D94C9EC95
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878926B0088; Mon, 12 Jan 2026 09:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863C06B008A; Mon, 12 Jan 2026 09:39:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738A36B0092; Mon, 12 Jan 2026 09:39:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60F886B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:39:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0893B14035B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:39:11 +0000 (UTC)
X-FDA: 84323569302.08.CD13219
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34E2A12000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:39:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O9eW3vkQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.8 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768228748; a=rsa-sha256;
	cv=pass;
	b=UdcshpzfCjED7ZUQY+ZFh6ldEvIGENrcEJoui42PF5LyIZ+9RF2pfBC2hOB+cYpk+YoYdV
	Z4hcSX4Fv1hfR6MIbkwUfQFsgiD0mH6qhfdrTlMVo5WrguKqypgkKptXmtzNCJhXw9T6vi
	aZxvTlc1u1z2OheiUCfvxA32tVkj/60=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O9eW3vkQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.8 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768228748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9JvcOOAnUmG+RXEkJncWN2C3v+3WUl14qzSyrQbRGg=;
	b=UqwUPe1qzCJOa/lXSX4tLvOaBQ404ck3+/4gLZq+a7T4gLB5xxYch05k6kEvXrschdz8Hp
	paM3FuajRuBfrIFHe9PxPYmSFLz/ObadfdO6HijMU7iTy4FTDHoalpjidC9+i4U66/6sSX
	H3oyrJhpVy/8W5PXPHeNxxguC1Iv69k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPWGptrKWToDIbv/ShnnMKk3tbYnJzrvVMeJJ5iAj1IauPAVG/KjF9M7L6N7mDcjxjRWp5p2HJR0OBBe6V+c9RGoR5q3Lw5XwLSOb9IE6G3MwwQIUfia/TQYTUVw0/xbHn3DgEy10WBbWbWAI9TMT0ETbsKxqUdnEe5Vb2vNOS3HKrtFlZpqQLG53MiP4X12l+JbTlDbR/A16n6Z3yg5TPaBTev+AMOWOLDNnwDTJ6q/GHj19qBF+7MXLrP1AKfpdigfqfkPpvOs8ADNgQni/uMdvPATxxv5wzGwhxA4nbT49xyBVSBOLIhPIJV0gHSwJb/rftOgCZgg+wI+Nfpm9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9JvcOOAnUmG+RXEkJncWN2C3v+3WUl14qzSyrQbRGg=;
 b=fAMcvy39ExjRAljugJ8x8DHqm6xcLsFKFZ8CGJrsuUR7CpTnUK9v846vTZEKhEkRhYa1unXTlFYeaghKpF8fWJcHyc0K/WyfUC0WFMtcMD97tLVcjRrGnwsHhfQT6qsFrsDt39okjhufG7SLVfzu0PFTEgy7F9Xeh82jGce1MR4YBaE5cAVnsqd8deoO0/LFITlXuA9yfZURE4/eJH43TgekcyURIFZgoOsIbPnfqnn5GIWx0V9GI0PzV+Ti3BlHU9aU3PZCPa5CAuikLJhZxRHipjr9PRpDM5pliQZDc76RcETTOIIPfz8emdYSwn1XGGxodo9vXmyQtj8ZloqZ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9JvcOOAnUmG+RXEkJncWN2C3v+3WUl14qzSyrQbRGg=;
 b=O9eW3vkQQyDdggSPnuY/v+qDSRk5LiO5hMyk6k8F+AfQGJ5bU+YDzI2iWDdDaNShmW47JKdEQNl0y3VIhjcAQZxbgUWet2Gudue+I6zRBio5o30kt9Vchualcie2iiGfybAaK6cflEjNqW4JWBuH1eJ+LAH8jWe0U8WfmpsiLdADL9BkO9jp5OM+yYi9pqEh3qViovqNN+hNVPiK9KgqSxZzOn0wtNV5ofrb9WV0OjHI/oOKlhTrU+P5ZOfLqp/DyaUmefsZ8tO0KT3l2ZRvOaryAKx+hEjoucCn8QoSGc83AVnP259vbqLeAEHpOlRhgkBKcj+0R8dVnTrm2Gq4DQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB8526.namprd12.prod.outlook.com (2603:10b6:8:163::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:39:05 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 14:39:04 +0000
Date: Mon, 12 Jan 2026 10:39:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <20260112143904.GA812923@nvidia.com>
References: <20260109001127.2596222-1-jasonmiu@google.com>
 <20260109001127.2596222-2-jasonmiu@google.com>
 <aWTJ2v9J-Aa6ykBf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWTJ2v9J-Aa6ykBf@kernel.org>
X-ClientProxiedBy: BL6PEPF00016412.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:a) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB8526:EE_
X-MS-Office365-Filtering-Correlation-Id: 8671f75d-c463-4392-754b-08de51e855c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/80LbP/m7/27YLVEHo4akCG7I/H692VmjDjyrwmtYyC/QVARfzQfNd1Bo6Z4?=
 =?us-ascii?Q?yUVE92tGAmvMfySd5RdDxgsM9ho/6uU6+qHdmBFsJqoVskgYFe4SZqYtktoT?=
 =?us-ascii?Q?Z9yK4cifSVhzNf6iYEHlbCE0u0G4rQWNOoNBwao+N0PZU0c2ikn08aGWTEK/?=
 =?us-ascii?Q?zm61HtTEXD6AtgAXpmYKeB7ngO7uOLF3dkGaFppl0HYBiND12JxM1LnGwF3P?=
 =?us-ascii?Q?gr4tuTNve6mdEp1yeySdo0oMyqicV8zUyVPiYVvI8NDjwyqlLDr+34vW+7Ji?=
 =?us-ascii?Q?O3RYWzcGzw2xyvhpLl5iOB6uoRoU3ef1TV0ThAZYApuymCBS4+5kWw/DBRR5?=
 =?us-ascii?Q?yWrQkZ5cRTdFOPHpBbN7TSTaKAMJoBKxjoXh02z8ODI2eKhnqVHlVedI2/x3?=
 =?us-ascii?Q?x92viyyHl5iO1vu5C0Yv2hTn8OHMzI8O7UBD8yd43u5gQIlDmpffhAPYRmhf?=
 =?us-ascii?Q?MQiRNg8wqPB76InaHMc7izkArZVF+xwQlJlDT2fm9uc5gaMjlCFpTXOENjMr?=
 =?us-ascii?Q?mlmus0sg6SjZpg9/Y9JlxnbBV2BPr/ep0Mw8hAGVQPMs1COn/Qf8vj1MxCUE?=
 =?us-ascii?Q?V/SePuzOcUMURbkpX0Kg/ux8vr4X6rrKBzMkr0xkR0QtsoXYY0z5xcpkOJ9E?=
 =?us-ascii?Q?1VTI91DUdHH8aGtajOndSsOTJrLl7Tt99D8vm+W/fEW74RmloqYIHS1xgDUz?=
 =?us-ascii?Q?X9ZMmr2O7bVX6Fi1CqLG/XsRvDZf15oajm2mbdXkQD4rj1nCHH0n1ErPWwJi?=
 =?us-ascii?Q?GpiP/FikeIamTx25G3tPb6solLU+MCaRTo0NwEkmBPOsSnxnF/7UKIioWAtA?=
 =?us-ascii?Q?A3NN8OnLwhOlT58qyUtYpZrp59sr+s/fbC5Jzllr++tfoTaANu4SbW1O0yki?=
 =?us-ascii?Q?dNXgUSJfO2WFG+dP6sx8oyafCn0DfQOBDPf/uT+V9vSOUfVIv3HxbbnDsoAL?=
 =?us-ascii?Q?qN57CBxricb88mTGgrp1KgBKOSuMpOchzLsN1G/PGIa64Qw485NHGCpRJYRk?=
 =?us-ascii?Q?kJqtfgiYx8/vxC5kDuYoGBioxThORfxWGmvHueVpN0FfXaFwqiebpW3ki+UL?=
 =?us-ascii?Q?v1COP+DT1bR2DGKl80Btj9/CBuMHKLe/nU5+i8sXP6wBhYbBiDTo8NJAwnP3?=
 =?us-ascii?Q?GWbaOgq7bovTWpJ+V41POS0Ko2OHtonj2GY92Kb8EuMGt+CMEkkUe17vqlaC?=
 =?us-ascii?Q?e5qjoSzg5Y97tqjKdx2CjM204KoR/5zgG3trQJs6QL4QlixW03tmb2QB8tDJ?=
 =?us-ascii?Q?KnSIh5Kbbg3tk4UqgMPgoVg7FH4NEPc5rArkpvE0DcUMsFCytHyOE3uPCA2g?=
 =?us-ascii?Q?+YK7bpUMqqq7RqSisUulzHEuPwm+iGtmrWj11zRfZ/83UM0d5a+3SCDSd3VP?=
 =?us-ascii?Q?kgyVdCmDAXJAWSGFnqEVDzA9T+YvKSR4jJM06YzBie1AnAMX+zyx4izwdEsF?=
 =?us-ascii?Q?uS1iYSMVpjkHELT1Pu4XpLCLPcUSZf2A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2cz40LeiKh0D+y4269hZG+YWr9Q87A0Vv3/MCJtMXFx+LXWmSWgElPro04XM?=
 =?us-ascii?Q?FkA3w2tsDc6Oy1lTtpgUbqG7tS9n0ccxJbvVpK+QFprqMWfAz+FTVlEJE+Ar?=
 =?us-ascii?Q?sEym8KtsRl7nQNhGKXTI+8eTvj9T0+Vb3IgpET+cNDdh3w49wo/r6DuwSH67?=
 =?us-ascii?Q?iRmHs/z9eeze7WyzJRgZbw97aMWmeUHas+ZtsqCq2spLzVcivwJZTnJ83hWo?=
 =?us-ascii?Q?GpCH7+ly5g8VkjXMRidrrrUWtiznLsrgFH0Xlz8zRnztu9eHtfFVNJf6KFZO?=
 =?us-ascii?Q?J3RTqnIP1a4nb9I8FUjkpW1jIKg6mc4O0NlI3DBIU2UikGXayg4XZYtxKfQ9?=
 =?us-ascii?Q?got+a75xExFdip6JqFMScHQlge1vjzJ18daFqyG3r/2w92rDSOwwgx+7ewIA?=
 =?us-ascii?Q?IM/PrhKnhgs5tfINsgPYuQNrU0lIMqAnH3D8oXd0AYMgYEifqkbSCcxXCTRl?=
 =?us-ascii?Q?oEQ87JS+WSSVw8ssfJt2Qp4ljpbe5xbClIssYsTrWqL6jXO/OGwXU48aOzKr?=
 =?us-ascii?Q?owDMC+ntVehLtFLsRVQbDq873T2enCYMPyonROm3L5ALWGkwXpQA2MHwTHLX?=
 =?us-ascii?Q?bAvKXhTgt4NBeFIYRBLs/8Qbd1yl2WuadMPS4nCVAARunqfKslrPG0HxYDc7?=
 =?us-ascii?Q?691UW0c9l3CXcegNnhqHootsSP0sX+05sJ2GKEHUb++4qJUWZp+sRpt3kdc6?=
 =?us-ascii?Q?xTfA7DIUWl91nQcy8njXuclhZNfacBXagRbAtjFYdW3nFIqm4ZUoSGuHsG6w?=
 =?us-ascii?Q?5ek86uMiyvDwBBUmlKr1hHddRdTRgHBkoaLmMTqClhhQ5KsewhaDxrAeJzSq?=
 =?us-ascii?Q?DCE1V0FGbF4piggnfC05UeuoM9EiQTOcULALe/UBUDWdKVHWt+7BoOA/NauT?=
 =?us-ascii?Q?UXEFIvmduXif5lnF4PLxEPD9O2xtqz2t0TCRR6i01/N1IZASUQjxq5SUx927?=
 =?us-ascii?Q?wCJuM3EfrabBHXTiFfv9LCN4AzQZ2TTFUI3R7ZdHFqd7UgqSlrvIR1tUvvsO?=
 =?us-ascii?Q?T5AG1ZegxRshUUBt3XtKCCOUJlFcsuKRK3DbtPIsubm1pofAPaKhlTMMyLWg?=
 =?us-ascii?Q?l9GGLM0KDbjdmV80F+fXUg6aSjxOGlYAcIqAXs0QsTl179teb6ufRVqFmAOT?=
 =?us-ascii?Q?cy3vwULlr1WtDvUbOv3xkSUQB9XBbTWq7kGcIsBbBrDXJN6/fZG4hgxayNlN?=
 =?us-ascii?Q?0l+dDFO3LVB7XcCQcCZZGhORGqAoLjE7IGSKUGSqMmDHyt8kfRu+myFEE/te?=
 =?us-ascii?Q?S4MfHPGA9nS6MAXL+xYbrpgCBzIzDdIHq1e7Pxaz4pjBdYPbxsqOH55/ubu0?=
 =?us-ascii?Q?eTAtUDdMfhe9owb0uwawmI47hpW5VXx+qPjM9Nl/b2kcPHiLINSLqlXCzOaH?=
 =?us-ascii?Q?O7DKQQ0tXkqTB0GuQ/Ewa1wQ5kY5oUY8vJ9jxDiWsg01k5CazfJ3jGZxuUZ+?=
 =?us-ascii?Q?IO9BApLyFFCql0pDcAu9CahyWBH99kp8YlUf0H+PP5s4+AmpqnBbaWkhWbcv?=
 =?us-ascii?Q?XbHUrjXykvRHAM/So49ZiV2xFMUXb2T0qmMW5hqOcTOt3CMixDruqwmQQocc?=
 =?us-ascii?Q?FtfOFRNf5OvhB4PEfC0ao4Jtl2Jw50ECo6xZ/U9fHxQ4YBId0ZvTQoBkBovv?=
 =?us-ascii?Q?q8oXMBmm6mCGeI8RbdmbrkqIfCmz3b8aVdD+Jgy+t1abouRGEcyYh46rhLhn?=
 =?us-ascii?Q?pMg2XhGif5iNaPWHc3I4y/jR8oOl9v9ts40bsDcdi7KQLxHEP0qnTwBaXEd8?=
 =?us-ascii?Q?R/29hSwFag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8671f75d-c463-4392-754b-08de51e855c7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 14:39:04.9403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrXkRaedKzi0STJNgLpI6qwCWc15OoXPIvrVEUXwAvKOkf5uFkFek0Gk77hKtw4A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8526
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34E2A12000D
X-Stat-Signature: k3kky48f6ipcpr7ifh9t9atg6h3rcqhp
X-Rspam-User: 
X-HE-Tag: 1768228748-596091
X-HE-Meta: U2FsdGVkX1/7QCBKS/Xw01g4759TRD336NplZwf1NqTMFL7F3Z5WZ+NJCVJ8Jpw8SyiIrbAATlmf6jGcRGIkZ9WJGgTCEEaqCukHof3nTDwlCczT01DSPcUYMXheyh1WwPst02RfLLcKl1kveuetENNCyvT9dI4G7QOwCrqaBPwRxHBa8wUKy9n4kmeU9/K9gWrOsCKEqiXeNgwhkAFQgvPt+jWqIZQuBmT9pnNZD7S0i7Byw1Z8tGyruzxKa6pFl/IhO0lNEHVPaT6TZL17g7vuVCxtr2r/c2o4PZ8zhczjmRn2pyNPSUlS6MuquC20YbEwQp0/NmT6PiQ8Y9PWX3axCBW89wVMp9CBp3rvrkVFUXNfxqqU+nQhNiFN6ZlBYFrZEtHZ6Psn5mO4CP6EW20URufSNhkXrCtQ9b7fjWdosWdz6oTGPTIPrx79oHgMPXoMxu+0M52/R3OLFgQH80YrLqMShIZfPgl9+Je3hUEiWC6gsBV5vcnkb9iypjd8/RUiCowUp9sBx80abwgaRweS+seflyWIxhHU16YJet1CzidyxWGqVwbi3vU3LHKweRvdjdwTG0nPcvNS/AbiEwbuEHNRazqpf5Iz11/oW45lsCMrxttuvkdHVvsVSlW6OyqIgVUFh9j43XQ5jjYiAqve5i7dsOxcYB0Ir/RFAUq9yqOG/kflJIXv4Iu3wJTLdgV86mx//eeqHK8Nr0FzQ+7a3EzdK+t0YjpBt46B3HC42pa/jzgWCC7EuARbwert01Edekj5IfyU7mR4Ni/y4D7Q2KxlLP9+KZowOnmwbfD71+/TSdMe/cupkKepmRk2VY5lPdYKGAPrBHIOnhO7I304ZYryKsiLSmVFmIpWeBqdoDQBaqKWLBcGB+6nEA717RgjLj7/K7BWGeiSBwx/imP+Yl2jcLMkJoh0J7ceAvcy1fPgvnharW11rcTJp6aLb6+FcqkxGPo8Gfgxmp/
 VPww0lRk
 cXWQrxORAhx9RIhPmoX77kcB82/11uxmQwfkUTvVf2naR6JUIruYhoHqNsZo9fo+4gGaGv1OlHxXX1swRTYLjK5dpZfd0VS5z/Rnj/aIK9E1VQjaM8wpRkfzZeTCw4GMX+DRCPjqubrVd8qmRrrYu/MVClMaR/J/YxW7c06DEbk85Pg8f1vgdDtAMUzc08KvlPyLlBWWP9KXTkOwS/lA/QxIfFFqrkF6Q0VR7Y9xJggGWsz87t4O6ZtHPC1to35JVSIdtroHdWzgTAwMl2OTHhYnAW4M6jiP/QCajj2R1yOswnQGY2iG9meOUxqz68fTB2xw/teHca1S7/knpjJJ1QRv637DvQh2tTwhrwGa2u5P6a6ZDbdVLUUZFbNGiU8DQDRBcMHS2Sa7mJRSiMl50Il2ETA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 12:15:54PM +0200, Mike Rapoport wrote:
> > + * The tree is traversed using a key that encodes the page's physical address
> > + * (pa) and its order into a single unsigned long value. The encoded key value
> > + * is composed of two parts: the 'order bit' in the upper part and the 'page
> > + * offset' in the lower part.::
> > + *
> > + *   +------------+-----------------------------+--------------------------+
> > + *   | Page Order | Order Bit                   | Page Offset              |
> > + *   +------------+-----------------------------+--------------------------+
> > + *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + 0)   |
> > + *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + 1)   |
> > + *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + 2)   |
> > + *   | ...        | ...                         | ...                      |
> > + *   +------------+-----------------------------+--------------------------+
> > + *
> > + * Page Offset:
> 
> To me "page offset" reads as offset from somewhere and here it's rather pfn
> on steroids :) 
> Also in many places in the kernel "page offset" refers to the offset inside a
> page.
> 
> Can't say I can think of a better name, but it feels that it should express
> that this is an address more explicitly.

It is "Shifted Physical Address"

> > +			node = phys_to_virt((phys_addr_t)node->table[idx]);
> > +	}
> > +
> > +	/* Handle the leaf level bitmap (level 0) */
> > +	leaf = (struct kho_radix_leaf *)node;
> > +	idx = kho_radix_get_index(key, 0);
> > +	__clear_bit(idx, leaf->bitmap);
> 
> I think I already mentioned it in earlier reviews, but I don't remember any
> response.
> 
> How do we approach freeing empty bitmaps and intermediate nodes?
> If we do a few preserve/uppreserve cycles for memory that can be allocated
> and freed in between we might get many unused bitmaps.

Surely this is an error case??

We shouldn't be unpreserving at all in a normal flow?

> My view is that we should free the empty bitmaps, maybe asynchronously.
> The intermediate nodes probably don't take that much memory to bother with
> them.

Telling they are empty would be quite expensive. I think we should not
attempt to clean the tree unless there is a really good reason why we
should have good flows with alot of unpreserving activity.

I think we would be better served to treat the root cause and fixup
what ever is doing preserving/unpreserving loops.

Jason

