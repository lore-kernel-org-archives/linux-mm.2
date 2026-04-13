Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4D5F34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB61C6B0099; Mon, 13 Apr 2026 11:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DB36B009B; Mon, 13 Apr 2026 11:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C826B009D; Mon, 13 Apr 2026 11:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 950F16B0099
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:34:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 394F41A0243
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:34:39 +0000 (UTC)
X-FDA: 84653929878.10.C0794E1
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010011.outbound.protection.outlook.com [52.101.61.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6023BA000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:34:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HOVZZCui;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PY07rGiJd+GPlgZc5Da8RiBihRjWG9iwaEf1DMv+yj8=;
	b=w+3+OT3T9+85Yuwj9d0TVm5NGJ5dWe3LBWsDiNm2rsVR19kDga8lJdOY8xMR/OTVKQT9F6
	XxF4Hbr8OZq/2sDz2AiE2P89QZHaey8rjfb+Kj85Z/wF+4UZjiTW2Xd/rkkgqnLRPx4JA+
	G27scCsYs2qH1YSoAbLccJkM/MaY5h0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HOVZZCui;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776094476; a=rsa-sha256;
	cv=pass;
	b=LrUpV9UzUtky6baN4nPdkJA4SQu7NUQFdKujmgM45k2Ytyf8HtyJF73Q3lcpM+U53bBN6g
	wISyw9oB/9e/KXpo8L43nOcE5LxZ5AzBxROZ/iswuoe8A2XbTAQHod6ITTgtWEq4VOwtlf
	CREoxZOwTopk++cp7MJghVDhhxCpidM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncO0CFQf7VwIJnPIbT8gdLJwV8oWgfhAF7amDhkBmfIvfT820w3Gm8dPXVmElabamA2f4y8Mi4JmM+wtWi+WCY8zSIUOuaxJgLHaIZog/phs+y73BvcWZNr05OfnNcujm0nqi6GS4y1Gml6lzu4dwb5QTL6Lxf8ErFC1IJPzNiklM+qHLSo9OtqGHDjjhOZ4zvkdMjS7PIpi+HP3VT/3QATAkc3tkrTl1NS7STDi1iyFEqAH022fXih0/ZHJP6P629GQ4LOrVVtidJRNS934iR3Ba6igqeK3tOlLQFf60RSD8sw/TU3+wfEnQbFOagn19hQ1NXjnHgdeq6TRqkwZNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PY07rGiJd+GPlgZc5Da8RiBihRjWG9iwaEf1DMv+yj8=;
 b=A0maklCxRrAtXVOBqpHxg4CoT16CmPsh1D4KEy1m8bxbWLm6AfmjAXIAA80kIO9Y8v+jf7TmuW6qnGwFQxlITZbfXu4WMsnnHyXcIPbTClxZ7COP77gBMmMtcVrxscK9z+yB4Dv/42CkbFZqULR0jV1S3kRS1bE0RV/HB8e5VdnM9DZvZtG+eYW3PrdOQov4+7dYXRgRdrtV78xer6Qq0409nwcdesmeh7ND2Ykrjqf0EIoVc5qNRK6Fgc9ld/3ceK5RByJEeXpSlOy6L5u8Qzv7ByX9hvhG/hiSx0jRt+2CPuEfkFhFV2guuZLMCUTh6xzn/wqOPnUxqypIunKfpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY07rGiJd+GPlgZc5Da8RiBihRjWG9iwaEf1DMv+yj8=;
 b=HOVZZCui7rma1O7dyoF+rmAGIHj/DH46cpfSOC9pSTm2Abh33KzD8icByxBRLDb60IwFJtNMrxZ9VDjvhnxYA/Mb/sUDI2h+slk8231+BGGk+bJYcIYy7wjKNqjv/sBK4L+BK5Jy/9QGmgSj8D+ul/jgERnZ3H01sO8hcHReLQHkIXRQIFARsqngUFTVlWIZVbirxbZXCcoE4ihXgnv/C4mHFS+ArA2AMOcSwkkaBir8zdQiFvOOn76CKUlWC4ltrBgF951uVPqsI4M0FaTHdc4V50TkTy9jFpE4kIx+U7E2HQq79ysVud1GWrwJ7SPmhFw/RuqQM5iV66jmP/ziOQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7509.namprd12.prod.outlook.com (2603:10b6:8:137::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.44; Mon, 13 Apr 2026 15:34:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 15:34:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 07/10] treewide: rename has_transparent_hugepage() to
 arch_has_pmd_leaves()
Date: Mon, 13 Apr 2026 11:34:21 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <B373B936-3CA1-468A-AAC0-F5719760AE34@nvidia.com>
In-Reply-To: <056d8383-d373-436b-8841-6350425c52eb@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <4f640655f26b4cc2056a62bebfd570686dd6dc3c.1775679721.git.luizcap@redhat.com>
 <A1A0BC2F-A9AF-4929-8774-C5841A3F6020@nvidia.com>
 <315f7856-82aa-4566-8c16-1d96314b235c@redhat.com>
 <056d8383-d373-436b-8841-6350425c52eb@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:208:2be::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7509:EE_
X-MS-Office365-Filtering-Correlation-Id: ab56abb0-3c0b-4788-2942-08de9972238b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2Qg9gYNID/vx3xqnvxqeIdmmVtKsDTE7+wy7y8OQCcQzngLFMPtrj2gXpDss4/7nMdP4eSUYEoJamsW+xW+EXFFDFBuSvW5/3hJiNBPd6RPsQu3LQfu41Cqfo9GmAaNcJyN52VyBqDgJ548OxJtqWQLM/R3A0TdLoQJHjHeohF69H3UD0a5Pj0XR3inOBNvzGQS8G9CnQnFnODv/g9FsQ8otv+u7dcnUA/qqh5vUZ1dvg6E9ZWZvtjUpOUeaOrnubEqydir3DlgWe4R1Ccx1pDx7J59BLpbi/6TITfAwZDLLekGSve43FvGq3pXSy2OBA9n1Le3rDrBd/tOL2niGgxha+PKGQXBpdLgMbhIqHrlI2uGHLUw/4yW1XEVMRBIAMWijl1taYlZC4+ARNsJ2fib1hVdDi4vb5vrhuBCej5qyFj8HSIwWX3sQoP7PyOCLH74sLfVTcmb9EVPIfmHXOWnID65GgFKeD7GLtmraiXcpDVCSeIYlcOGJ0A9gGxqaa6jN2I6qCe7H8TpL7SjzakGpJmoQ6LOvOoP44RVgSrR3ib460MxTwBVx84Q8Vi/bvl3aePUvd2i9AmIlR9/CDTM0W7NNRdFZXsBlZOCRZJ415zAsLBJaeNiNM9yW03ciVg98pLQOw8aj52NLFnbiIuDqN12H7JJ+UAd6WsIR0gh9Sb8ccxNR6fCwKlKT7NvLHPp1ijmunNvg/n/Ed+oPTCzXnZOaste0bZHOm/UU8dg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eJsPhvSt+QqIYvxEVm3MKeNxznRNhOTP05xxkTO7BhhsVovoE+bBf7Ndxrqq?=
 =?us-ascii?Q?AwVvkcDeBj5AEGPl8ki5TpkBij2u3q7he1tp06slpKQC1wuNrSti8gDGWQDe?=
 =?us-ascii?Q?24FihdBVlL4SP2KdO9wfsO4hdRr68Td7jOKR/DKoT/TIaTqNWStJMA+XQKmA?=
 =?us-ascii?Q?4x2HI3ebocCRvwbQ0HTUvfvRpY2oLltqQE40OZwtAtc6AXgK1gshoxoPzESq?=
 =?us-ascii?Q?ZhhGJvjHnrzuXEibRQ6GaO8IIpE4/eFGBBoV3mKG3ibYprdgGmR39+lh3m1Q?=
 =?us-ascii?Q?KajJECycmmdaMkeUCafFhxljMPN8+L6ULJlxyX/xbpC3rXc6G1wG1zAaeuW2?=
 =?us-ascii?Q?+NFS1Rax+6asj6TCeJWBz/56TO0suVuNnIiHSv9hgQqUTMV4tCu0WqBtSaSa?=
 =?us-ascii?Q?36Q6doQHwuZr8TC+vuGOwH1k3sT4BjpzCECKn4/g3U51MXoAZvc/0sSv/N/s?=
 =?us-ascii?Q?ODQINwAyxtMQ6ue8TY6RyaPO4iLBRaQfieFpUb6FtCiVRh39+BH3fHkLch/r?=
 =?us-ascii?Q?ChI8b/559Xi3kkKGJGftgNDF+EJVWHTgX1eKodbTsuCbsrvWaKGM3hdNHlRu?=
 =?us-ascii?Q?btv9ES85dvWfw7+KNEPdlyrVxfxHWmwkg8p5782Pe7Djozfq2jXJQnp6jdyM?=
 =?us-ascii?Q?VcWDSaKwyGXIqI0T1mfkyYVkZzQcGGg794SdBAzxYB4yAmfXovUHKXyFf+QD?=
 =?us-ascii?Q?kwx+oJUrzHSKDDfgMrrz3LQ9uFR0+Iml7MrhhIrvrVYLWbJXWGlrFzYWMnKV?=
 =?us-ascii?Q?WEVRKzFnjMEWSRj7t8wvuPxeYSsIwBbwszn+EgMs/sAw+e+KdxBQCBLuxQg+?=
 =?us-ascii?Q?PlBod3Yfbh+IHzSKlEBWuF2knTBLTnb2a50tRYeGayP2k+bWs6z98mhjPzeR?=
 =?us-ascii?Q?8Lj7KSUw/KN1TSqaeqp7EtgF57/YEcrtGArPjKzHATXGAP/FXpi03PnstP0j?=
 =?us-ascii?Q?jmkPUb6AwknDeImJvXJwNSFeU3x2CQWG6ot+Y+W2fPOcKYJd0PE7OgYGhbpb?=
 =?us-ascii?Q?jZ0vr3yZ39i4LjMCN53xTYTidjjaNdYRW9EYRaoPZN9xHSMH2+LhXuZt/v9E?=
 =?us-ascii?Q?YDxnkHBorN0hTnBYcXXURCCE6Hd0OvelFNdk4DTMryoxqB0gZ/6mj9Tbkz7i?=
 =?us-ascii?Q?+3Jzj0vQvqD/WV1ftDz7TbQtfZL4w7pEnD95IegbPPZrATBi0iA+q0XzZ6Y7?=
 =?us-ascii?Q?B/N2397CtqyoZSkR1Xz8yYKX+5mriwgYVhcVACH10vx1x8UF09mo0Gd/wAyn?=
 =?us-ascii?Q?EEAeFWwoRXay9cLsnIgmNzwgq0ACTI9gkO1qxxEsGE8iQlnrRM5ybdcasCs0?=
 =?us-ascii?Q?p8NdFG6DQ1ryuUoaIvo7QK5bYwDcy/FtBo8w70dEl/mhDQZtgSw81stkjIER?=
 =?us-ascii?Q?fI1zUaC4iMbeZct+b3cjw2yyEsz3/UK/AcU/4Bf4kLC6vDkrjpKoJv/NACp7?=
 =?us-ascii?Q?HLo0UWsbAzSe2kxOqzBjf3cOufmAKHHXkvH1q6OnOkUGB9s1YPNoku2tESqK?=
 =?us-ascii?Q?TKWoWdocVRDGKKP324WFbh7ET3YxiGLa6DD7nketnpagrBYQVa33hau5q6rS?=
 =?us-ascii?Q?0+0n+oxlD8ha2V83z8wN9y4u3NW4Z0GdZFfMt6SrcjZf5gqZ+8kpufdb32ec?=
 =?us-ascii?Q?ZP9HEchlfXBakXjvU6sKY3U+ihoSwqavB2KKhpIvzoE3mOocJMSW6ICdRAFe?=
 =?us-ascii?Q?tNFWH0V0FEZWyQEz8q/Par0iR3L5PYCXOMy9viXp6aiNi9AmLlUkN2F0lHHs?=
 =?us-ascii?Q?Hj/0/Gd7tA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab56abb0-3c0b-4788-2942-08de9972238b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 15:34:23.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fvEv1SEtiza3MLaUP93/K3pH+AOChA1nBEc+HLX+PfxzRmWI97ZzfTgzmJMzdthP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7509
X-Rspam-User: 
X-Stat-Signature: qnk4aw61z8b4pmurw6n5spi1f4sj9d4i
X-Rspamd-Queue-Id: 6023BA000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1776094476-521250
X-HE-Meta: U2FsdGVkX1/vnVid1RuCNq15QnIjagG49fm4ZdJKly0gDB9lBHFezk4FQ2yVLWnILGynCTEcOJn8PfD4pifmO0KIeTUuqbNXgb1nuzYZ5PvYLop4G4Ae6ww5DBs5khFcjrElEtnWJX9ELMrVIAE2tJfRkk4H+WSPj+NyN0iI8eFtEYjrp8MYWcVvvwwfELA+tJ+Fl2v/VDra2TjFva4rlW8B/6jRLUEwoYpnl9AdLLRDqhQItkYhUH6hnKumlpOu2Vp0eCFvQX6n8zj5PCXdIsYsXV+RINdqHIl/lRphYoeVTlnrvNdhVciqbMUmyqW3PyZXAo+3lmXwtgHq1i14PhPa70798gI0BImvLPiifcgXcQhWr7n/FF/hrHf9OXJriWLyQeJdOZmMSKzGu02j3/DwBdplgHJyc3AzaFC12x+7kfWxyKGTrpQXeE3wqrLejh3U423/Pf7fHBsfDxfc6VrdOqPwxlxNFMJawk0ZRawD2aiQ1QPbUKo9k7vIQpPR5qmsHEdaFzdx4dzzFpUrfcIGoX5M/7/UT5RCgEbl+WJngrFPTuR8peZtf+Q1cQQVoSUXpGxDcTcHU7oJIVz8W9jk0F9NcibQdoPadVRTfHJEcbqdX7sCSfUaRcXw0ak02Dh01SRA6XLxFmXfaAizY3St7LF2rCQnorJM2EVfK5hSffIMUHPH5PkG4ekxCWN09t93iCuzqa7kGiTFaOwgsKQQEI2JGikZbOtSaF76p6saFtaY55TskPRUIXcRp/x3AlWRdAuS0qsLUKmIzpCKqM+BRyDDcq3kFj6LKoZyMNlubTsdETNqpyNqX8U00K+ND4VfNQMmOcKMYb2L/HOhA6RlEm7XxXq4K6KZXkKOo/rKwcJYPnErXq3XaLXX/mRFThY1BlcsE+Fe8bEp7IARIC6+AsmFPBC2Urui1h91YXyEQU9fyfEPuZR5NsuXWUSkNE+sXwCF4hDenOHgD6U
 cWSJqp8K
 LORdqVBHNFfoMHOY0h4bCK2Hv68GPpvDC1fF/ZTWhAN5+jF4S9KnbhztiXVYAMuS4fZcGfmHshYHMNoyV9fxezEiLJzOgJVUMUrKwg1xAhtUhB5N6VW2nytADyJhFxr4TglRWH0m2gv5WS5rQAHHQVZg/eIZHdWAI/hDn7Th8ZRKh5iXFDjRn2GWMKzSnnDfOxgpOUoPnxzCtKrf94S292qAwwVVisua4Q1OSEOB7AfKpa8vpQA9eIQLDHwwRAeqsOWlRpysLcDIsgHhfujXA7IhB7OcsLw8ltDkEe7DldMT9SvLXztID1t8J5YoIgYywjehR4gZCz+x2FP5DkFyG2loYyS61oI5IpCPWOp3n3sHEbZcfaV8vH0D7u5S20P/AAQjj68dW+Zk7aH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Apr 2026, at 11:32, Luiz Capitulino wrote:

> On 2026-04-09 15:43, Luiz Capitulino wrote:
>> On 2026-04-09 11:41, Zi Yan wrote:
>>> On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:
>>>
>>>> Now that all the has_transparent_hugepage() callers have been conver=
ted
>>>> to pgtable_has_pmd_leaves(), rename has_transparent_hugepage() to
>>>> arch_has_pmd_leaves() since that's what the helper checks for.
>>>>
>>>> arch_has_pmd_leaves() is supposed to be called only by
>>>> init_arch_has_pmd_leaves(). The remaining exception is hugepage_init=
()
>>>> which will be converted in a future commit.
>>>>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>   arch/mips/include/asm/pgtable.h               |  4 ++--
>>>>   arch/mips/mm/tlb-r4k.c                        |  4 ++--
>>>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
>>>>   arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>>>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>>>>   arch/s390/include/asm/pgtable.h               |  4 ++--
>>>>   arch/x86/include/asm/pgtable.h                |  4 ++--
>>>>   include/linux/pgtable.h                       |  4 ++--
>>>>   mm/huge_memory.c                              |  2 +-
>>>>   mm/memory.c                                   |  2 +-
>>>>   12 files changed, 22 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm=
/pgtable.h
>>>> index fa7b935f947c..a97b788315e2 100644
>>>> --- a/arch/mips/include/asm/pgtable.h
>>>> +++ b/arch/mips/include/asm/pgtable.h
>>>> @@ -615,8 +615,8 @@ unsigned long io_remap_pfn_range_pfn(unsigned lo=
ng pfn, unsigned long size);
>>>>   /* We don't have hardware dirty/accessed bits, generic_pmdp_establ=
ish is fine.*/
>>>>   #define pmdp_establish generic_pmdp_establish
>>>>
>>>> -#define has_transparent_hugepage has_transparent_hugepage
>>>> -extern int has_transparent_hugepage(void);
>>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>>> +extern int arch_has_pmd_leaves(void);
>>>>
>>>>   static inline int pmd_trans_huge(pmd_t pmd)
>>>>   {
>>>> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
>>>> index 24fe85fa169d..c423b5784337 100644
>>>> --- a/arch/mips/mm/tlb-r4k.c
>>>> +++ b/arch/mips/mm/tlb-r4k.c
>>>> @@ -434,7 +434,7 @@ void add_wired_entry(unsigned long entrylo0, uns=
igned long entrylo1,
>>>>
>>>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>
>>>> -int has_transparent_hugepage(void)
>>>> +int arch_has_pmd_leaves(void)
>>>>   {
>>>>       static unsigned int mask =3D -1;
>>>>
>>>> @@ -450,7 +450,7 @@ int has_transparent_hugepage(void)
>>>>       }
>>>>       return mask =3D=3D PM_HUGE_MASK;
>>>>   }
>>>> -EXPORT_SYMBOL(has_transparent_hugepage);
>>>> +EXPORT_SYMBOL(arch_has_pmd_leaves);
>>>>
>>>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
>>>>
>>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/pow=
erpc/include/asm/book3s/64/hash-4k.h
>>>> index 8e5bd9902bed..6744c2287199 100644
>>>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>>> @@ -165,7 +165,7 @@ extern void hash__pgtable_trans_huge_deposit(str=
uct mm_struct *mm, pmd_t *pmdp,
>>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struc=
t *mm, pmd_t *pmdp);
>>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>>                          unsigned long addr, pmd_t *pmdp);
>>>> -extern int hash__has_transparent_hugepage(void);
>>>> +extern int hash__arch_has_pmd_leaves(void);
>>>>   #endif
>>>>
>>>>   #endif /* !__ASSEMBLER__ */
>>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/po=
werpc/include/asm/book3s/64/hash-64k.h
>>>> index 7deb3a66890b..9392aba5e5dc 100644
>>>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>>> @@ -278,7 +278,7 @@ extern void hash__pgtable_trans_huge_deposit(str=
uct mm_struct *mm, pmd_t *pmdp,
>>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struc=
t *mm, pmd_t *pmdp);
>>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>>                          unsigned long addr, pmd_t *pmdp);
>>>> -extern int hash__has_transparent_hugepage(void);
>>>> +extern int hash__arch_has_pmd_leaves(void);
>>>>   #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
>>>>
>>>>   #endif    /* __ASSEMBLER__ */
>>>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/pow=
erpc/include/asm/book3s/64/pgtable.h
>>>> index 1a91762b455d..e4d9b884af5c 100644
>>>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>>>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>>>> @@ -1121,14 +1121,14 @@ static inline void update_mmu_cache_pud(stru=
ct vm_area_struct *vma,
>>>>   {
>>>>   }
>>>>
>>>> -extern int hash__has_transparent_hugepage(void);
>>>> -static inline int has_transparent_hugepage(void)
>>>> +extern int hash__arch_has_pmd_leaves(void);
>>>> +static inline int arch_has_pmd_leaves(void)
>>>>   {
>>>>       if (radix_enabled())
>>>> -        return radix__has_transparent_hugepage();
>>>> -    return hash__has_transparent_hugepage();
>>>> +        return radix__arch_has_pmd_leaves();
>>>> +    return hash__arch_has_pmd_leaves();
>>>>   }
>>>> -#define has_transparent_hugepage has_transparent_hugepage
>>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>>>
>>>>   static inline int has_transparent_pud_hugepage(void)
>>>>   {
>>>> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/power=
pc/include/asm/book3s/64/radix.h
>>>> index da954e779744..c884a119cbd9 100644
>>>> --- a/arch/powerpc/include/asm/book3s/64/radix.h
>>>> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
>>>> @@ -298,7 +298,7 @@ extern pmd_t radix__pmdp_huge_get_and_clear(stru=
ct mm_struct *mm,
>>>>   pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
>>>>                        unsigned long addr, pud_t *pudp);
>>>>
>>>> -static inline int radix__has_transparent_hugepage(void)
>>>> +static inline int radix__arch_has_pmd_leaves(void)
>>>>   {
>>>>       /* For radix 2M at PMD level means thp */
>>>>       if (mmu_psize_defs[MMU_PAGE_2M].shift =3D=3D PMD_SHIFT)
>>>> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/=
mm/book3s64/hash_pgtable.c
>>>> index ac2a24d15d2e..f7933c52cca9 100644
>>>> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
>>>> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
>>>> @@ -370,7 +370,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_st=
ruct *mm,
>>>>       return old_pmd;
>>>>   }
>>>>
>>>> -int hash__has_transparent_hugepage(void)
>>>> +int hash__arch_has_pmd_leaves(void)
>>>>   {
>>>>
>>>>       if (!mmu_has_feature(MMU_FTR_16M_PAGE))
>>>> @@ -399,7 +399,7 @@ int hash__has_transparent_hugepage(void)
>>>>
>>>>       return 1;
>>>>   }
>>>> -EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
>>>> +EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
>>>>
>>>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>>
>>>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm=
/pgtable.h
>>>> index 1c3c3be93be9..e638d914fbad 100644
>>>> --- a/arch/s390/include/asm/pgtable.h
>>>> +++ b/arch/s390/include/asm/pgtable.h
>>>> @@ -1776,8 +1776,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
>>>>       return pmd_leaf(pmd);
>>>>   }
>>>>
>>>> -#define has_transparent_hugepage has_transparent_hugepage
>>>> -static inline int has_transparent_hugepage(void)
>>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>>> +static inline int arch_has_pmd_leaves(void)
>>>>   {
>>>>       return cpu_has_edat1() ? 1 : 0;
>>>>   }
>>>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/p=
gtable.h
>>>> index 1662c5a8f445..8fe95270b713 100644
>>>> --- a/arch/x86/include/asm/pgtable.h
>>>> +++ b/arch/x86/include/asm/pgtable.h
>>>> @@ -314,8 +314,8 @@ static inline int pud_trans_huge(pud_t pud)
>>>>   }
>>>>   #endif
>>>>
>>>> -#define has_transparent_hugepage has_transparent_hugepage
>>>> -static inline int has_transparent_hugepage(void)
>>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>>> +static inline int arch_has_pmd_leaves(void)
>>>>   {
>>>>       return boot_cpu_has(X86_FEATURE_PSE);
>>>>   }
>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>>> index c4c5282f795c..4b52a3abeab5 100644
>>>> --- a/include/linux/pgtable.h
>>>> +++ b/include/linux/pgtable.h
>>>> @@ -2222,8 +2222,8 @@ static inline void __init init_arch_has_pmd_le=
aves(void) { }
>>>>   #endif
>>>>   #endif
>>>>
>>>> -#ifndef has_transparent_hugepage
>>>> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HU=
GEPAGE)
>>>> +#ifndef arch_has_pmd_leaves
>>>> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAG=
E)
>>>
>>> Should this be
>>> #define arch_has_pmd_leaves() 1
>>> ?
>>>
>>> Since all has_transparent_hugepage() is converted
>>> to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves(=
)
>>> and pgtable_has_pmd_leaves() is basically arch_has_pmd_leaves().
>>> The IS_ENABLED() is the same as IS_BUILTIN() here.
>>>
>>> Before this patch, if an arch does not define has_transparent_hugepag=
e,
>>> has_transparent_hugepage() basically means the arch supports PMD leav=
es
>>> and software controls the availability of THP. Now you rename it to
>>> arch_has_pmd_leaves() and setting it to 1 reflects its actual semanti=
cs.
>>
>> Yes, you're right that the intended future semantics is: if an arch
>> doesn't define arch_has_pmd_leaves() then the kernel assumes it suppor=
ts
>> PMD pages.
>>
>> I originally kept arch_has_pmd_leaves() tied to THP because I was afra=
id
>> of breaking the current callers who want to use PMD pages with THP. Bu=
t,
>> as you say, they should all be checking for
>> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) now.
>>
>> I'll look into implementing your suggestion for v4.
>
> In taking a second look at this, I realized that a better default shoul=
d
> be:
>
> #define arch_has_pmd_leaves() IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_H=
UGEPAGE)
>
> Since archs defining CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE should
> support PMD pages. This is also consistent with
> has_transparent_pud_hugepage().

Sounds good to me. Thank you for improving the code.

Best Regards,
Yan, Zi

