Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4018AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 03:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916006B00AC; Mon, 29 Jun 2026 23:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDB16B00AD; Mon, 29 Jun 2026 23:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7826B00AE; Mon, 29 Jun 2026 23:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 466FC6B00AC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:58:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFF94120353
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:58:01 +0000 (UTC)
X-FDA: 84935220762.24.824FFFA
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010003.outbound.protection.outlook.com [52.101.85.3])
	by imf11.hostedemail.com (Postfix) with ESMTP id C158D40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:57:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k0MKX4NP;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782791879;
	b=aN70vZSzZ/LeHcCnZ0AuKpnIwAaTkYmLP9rVkU4BtYKiuIgG/4adGFqql9ymRZwKNm1Qz6
	3w4pZgkEmZshI/wYfh3OTiAU3BxrsajluQs3FMeN/zkTM1Yq8nn5pZdeVaJvrR9RBfb9+q
	1A1jqgbtqmjK9V7LasvdL34Lmr+582Y=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782791879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCzlq3HYj1zv2Va/BNBOyGd+88lyQA2ipflVEzC/yiU=;
	b=BPVZDy7rE6advP62G1FaTgeZZ+rQPY43j+zsOT929zsRnPprLT4/j/NAaAxm6q4MHe+ip2
	PF7r1X+lt3Xzu+j86Vic8EPBQPxM24yqIyiKv41vSOsMI8FbTOPSb/XXfUR1yTPP62Z+19
	a2IIcVLCPATCEVM+1Lgt9VRITjSPxEY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k0MKX4NP;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gcitB1OLzxbsycbURBR/EFovpgo6CkPu/gOgJiw28UA5CUHt0Az8pWrXqE5Hjdkx0C2DklcrzUuKAcg9PzyBOjM/0uHsGRttdoLE0y69eZNbwbpHyadx56qa4G+OORDfEpVcGyMdS3lMMKoEOTgX0tW5N+3sy6azxRKrO+IZ2snAOWlEHPFJh2blJqbd6rXgzxh95eCMmUhP5E+f9tCkbywwmDdseu33YlUR1T/WArQadWoE0LD4BOkEQUhYXgf+85HFn3EHuf93WNUG93MFBecH999Z1KMPKVlp8mXRWeV+1ebZrFKL0nXJ6wYxB6OmVa3KY97Zopd+znonlUJYTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCzlq3HYj1zv2Va/BNBOyGd+88lyQA2ipflVEzC/yiU=;
 b=BAlpuNO7po7FrQe6/f85SqB5nBmyKuWrMEJHNTJO7ulJJl8HXNRbHjBdDEN9+Qo2KFCZAJ3qu0fAFvc8pQ76y25YZy1TANBWfyDV///SVhm0yOgDzubeTIZFZ1O4DfuwLdIr4IaItCK923XC9AEv//JdJgI76Y/UVvLGsYWQxw+RK5RIB6i5/WJZdL1Z/DACyu+SC2b2BwRn5TOzvqt2wXNuFzTuWQLvzltVs8OOmMCIAqfM0osSy5PcK7JA0Kj++XIaNOO2HdFpTxh0qp/5uNvLFQ/3ac7jXcSKCy/lO9UC0FLBpZUb5hUgsN8ZiM/hcLRioARQfQye4relZ3PRVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCzlq3HYj1zv2Va/BNBOyGd+88lyQA2ipflVEzC/yiU=;
 b=k0MKX4NPf3FaG/VvJYbBIA52fnTv8mvUVU+jzXV3kC1NLx6kqHdMjN+RmWbw05pZDw07KS/Kndi3Kqg8KZHLZJV+vhHd5D2tDtsvRM98vI3Qcb9l7jpqu/tP5M9kVKDIGlMD14XrC1srC7HHp6QJUjUAL2Yq5HfQWMQ0ySvtAiXZN1k60NRSKvq5QHQvmk8Mn76IFG3/ylxrD+8w+qRMl4Q5u4eDIszCNSdaXTk/DkOIpDk6DT5QcGe5gaNz2nG8Y7LHdMjW9NmuaDXwfYKcKD9SmLbuSkFHKe2aqkEnwatedAwmwDNWsrnyOdXSfthCX0QzDdqm8bLq4jyLa09ARg==
Received: from BL0PR12MB4995.namprd12.prod.outlook.com (2603:10b6:208:1c7::23)
 by DS5PPFDB3A23D1A.namprd12.prod.outlook.com (2603:10b6:f:fc00::663) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 03:57:50 +0000
Received: from BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2]) by BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 03:57:50 +0000
Date: Tue, 30 Jun 2026 13:57:44 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, sj@kernel.org, ziy@nvidia.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v5] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <akMsgZ1i0A6S5ewh@parvat>
References: <20260630021540.17297-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630021540.17297-1-richard.weiyang@gmail.com>
X-ClientProxiedBy: ME3PR01CA0032.ausprd01.prod.outlook.com
 (2603:10c6:220:19f::6) To BL0PR12MB4995.namprd12.prod.outlook.com
 (2603:10b6:208:1c7::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB4995:EE_|DS5PPFDB3A23D1A:EE_
X-MS-Office365-Filtering-Correlation-Id: 309840c1-a8fb-49cf-d95c-08ded65bc0d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|11063799006|56012099006|13003099007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XkeZIM4zVoAuWt1mgT1GfaYY+kpeVipUgfA5buciNyC2Dj1jyGrC4G5ZUV8tLv1/n5OwfWoZBbYwsZ4g8SFNpe94zlCrkjbtuRPjfd8v4Ufij9QgxeRc+3ji4782D2bos0zNPEFI1ivAe/avTNp9Tp2j3+4Klsu++X5UOzTbbW7HLT9TsrWikxwJX6U7iDWwTqyT/g2SH9gy91/M6+b9j4mlbm07n5g/aHL63iXuSmbp3bXNq8EBoxjejLW2IaqbDA5h74PUTlzz3V7k5E3vSPzYlSKrGcvJxnunV1cPP8HKXZVEDg/acepDsLBrFlXJqN3RrzBfPI1h7u9aD5QgZLxX08fRewiU06wPOXlG57hx3qohXWAd4G1XXziAt4B6m23mw6Aj47+k4v1Ctf1+PAIRBq11QWjN4bnpRP6wlkXZ3+iRVWKRzP4uQODXwj6hplgp9DJchJ0KMav5Zm0Y8BhjUrzo0tf0A6DQTSWO9mhUlimmnRwRNJCntDIBc11/MgA2xEPGFc+87QVQJsV+RD0g/40KL4JbUdnky/tdxiid8bSwWQqOh+6K/+YUqJv6JMfZofBF5wKMZeF401SiZriESAQ4KlhjEANeRHqr4iqbd17x3hoM5c6weFGYR10qKSA1d2X5CnkfqvhocxLLnhO7SS9K7BvI6mpZQBB49J0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(11063799006)(56012099006)(13003099007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wJGvKtqwMDlGeJkUYqkCAsDANksaGxc4pdfYyWbsII4aZJUutAY2gUt4rUvy?=
 =?us-ascii?Q?NrkJP27CbWc47fIcCOPSBwfr7DTAF+Zd8oWXzybtoXSVv/DL3abKtTjwPKI7?=
 =?us-ascii?Q?NPDHWjLLejdouvssQwtFLyiw35Ihkm3UwX/xw+iH+TSzkmNxl3NDSzmnskYb?=
 =?us-ascii?Q?Arqha6EqVOjUV/TGMK2BLIT5p91fLDd84PhuiZUz1ZBzKFcxgeHfWaGmOw6k?=
 =?us-ascii?Q?wB9mqDtpyuQG+2vm50MqUT/2jbJMMLqkzBj/xILG8MZsfWW9afnhKkZJSpw6?=
 =?us-ascii?Q?7U/gF7KPJdObxd0kYtlu4+C1HAvRvvC5mf19NgGGobxuhR7e+Q0OErK3YENI?=
 =?us-ascii?Q?Res/V4RjtIHHZcjyX2a3KzWpqjG9mgFE6COBHJWXgYyOZWGLpVQAblVl0VxP?=
 =?us-ascii?Q?ROnUPjcSqyneNmiWqW0xbd9wGI8+iJQsituj5QpOv0X/NUAwmttGYGYvRywa?=
 =?us-ascii?Q?MODt6wwJNd3tBforlezujXXpAhBEMRkGBDWSHlYDJneWH25NKKWtrliT8uPa?=
 =?us-ascii?Q?4fwqbcyTK0aHG4nmwI+TqxVcV6DKl86x79gljSu9dc8QC8Qwe+07nCW30uko?=
 =?us-ascii?Q?XsnFPaiFnh2KneMtWK4QQnA6Enayojr8x9Qu87dd2CcZuUHilyxpN80Biu5X?=
 =?us-ascii?Q?E3SuXSGb+GQlOQZzcAIUYyv60cvrf3Mlny5yiKXfVDt1fVJj7YGuWCuTt2Ub?=
 =?us-ascii?Q?nkDtGtjMIWMxuKWIStlybRDp+NYP56kbQXr3rv7ka4ahpaXpFJIMn4XV5jUi?=
 =?us-ascii?Q?/8/4HHaH8Y8kdH9lNPUh6YUtQgDzsuWubQo7JQVxG2ZMqKsH40Yesh//jxQp?=
 =?us-ascii?Q?8nOljXjS/WXtZ6+PBPeLUbw5r/sgsEuE7mtrKPWbyFcBSYKwxauosWPHAdHJ?=
 =?us-ascii?Q?x/WkOOunv1OzGdAUYKm8tgkNIusVNF2GHa+ic974LhNCHu4lKqHvAgKZefYk?=
 =?us-ascii?Q?mFEjL3g+mUeiycb/HQDg7cf8lXi1NEzmx2W6gfcFos3vHQPMJ0wcFPaLPK2q?=
 =?us-ascii?Q?XS7IyQbHQSbXZRjFR+7gxkFS6KsLpoido8ghxiQjSYjoHI+bzQiSPEajLnrp?=
 =?us-ascii?Q?3Jb5XIHAI6fByp+ue9p/2jeRtX/MoYv7xMGs1JHWLHm8Iilt/CmGQAcftIM6?=
 =?us-ascii?Q?IgwtS6Nr0yxau9e8aXX1zRVm0fRdQPP4IJMsMiphu6FRGf/HS4RwDCBfvcsg?=
 =?us-ascii?Q?pbb3UyfWM7QM+2AQwWcHkwYYqLG3wh6XTUumgCllGUUy8ZuXzIBalbBb0iBl?=
 =?us-ascii?Q?X6wSdOEmYfeCpBKISP1xlCRGa5JqSkszXTDEOu2CVjACMSTD7ApvJQt7Ju1E?=
 =?us-ascii?Q?KSLWwQWjLG8irv5TcQiDcH+cbNNWUkzYsyH3YXINqXcejJ1t9JJdQSvaFgst?=
 =?us-ascii?Q?jhBBKqWOs20Wa+Z7JOF5KieHDHN2MoSNmV7eyQCWp8IKmoK2CUYSy094I8MX?=
 =?us-ascii?Q?h3um57b/EMGcDDTR3jLEq0nVfxOacRFFosJE65KnNihlQdfkY12biPhg2QX1?=
 =?us-ascii?Q?x2pefoq8sqeDRd91U9AXq5oJDhKg1En3NVUBOeg+8TFQVZDyzCSRSLra2DVK?=
 =?us-ascii?Q?RPnil7zDcaRknnOljIceFEcvcIDrRja0Q6QxNBfQM8CvBsoG1TVQgmzBGd1D?=
 =?us-ascii?Q?Evv8Wlpa2HRFv1YEGS2cx5jzLmiLEvJIMboKCx1aBucj0GCCkrDfAmcXNCKc?=
 =?us-ascii?Q?C6G4cd+Fpv/Ng8jAmKdTyNqpJX293RHIQy0xJ6l230IzbXJ1QoQNrwq6X6tv?=
 =?us-ascii?Q?F043hIA9TQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 309840c1-a8fb-49cf-d95c-08ded65bc0d7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 03:57:50.1576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7K5JzleX2X7DbNjMRVpj+tWYt9hgySOXwDDHULAwCgeuuCPL3plAgFPqcY2QlrSkFxAnNLHt4rW01p615IiyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFDB3A23D1A
X-Rspam-User: 
X-Stat-Signature: w14z4a7jwtsd9gurjg7atjoga49k9jcr
X-Rspamd-Queue-Id: C158D40002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782791878-578406
X-HE-Meta: U2FsdGVkX1/dn9D8s+sv3fk3BHTlababERxNyyxvO9lnCGyQLy404uJ+OZlQOFtIfQncQ0fqI0bVlW2lIDFps7Y4H6Y2TGaG/2nVvjzieEdriHuVKlGQ002s3GGI50h7epphoKeWaC0U4JQhvZkqqPoqlQ6tx+VCRsB5/o0Y4qeTJsyn2m60/4Op0z9BIZ8NHwY9wBYvUbIt689XKihg4UZ6Su1xtaafjJCMkUlwQ0X8pCRLGtIrR0PLs/yvXyYtVC0F8VBubyoR+5Ig1FYyGuY1kwqtchAqBiJWotAtOwyaDaS34XO4olzBxUrhW+qZVlS7qzQJWYim2jWANl3f26szzPbKzrhNzmThWLzUZ0U88zkmpGSi0WZdobMNSgzrgk+yKoZsiCF5MMLAqFBGIGpPCxvekpqPumsh74ZH/MkdfHIWksIgJFcHsKbOPOPaUdWQKs5yw4im2FfLPXB8rOwbMCuyCGcKGu0AVY/wEWywfvaZ4vHPU/JqXeqsZ9xKkmwkld2KsK8ndXv2ZlPqDwucCE2Iuy9cR9qURY3xDKfl8Ee3QMuRrKgGv60jSmEgHiDavzgoyGP5zQBSpSQayRXcHhzMqjMv/lvIFWEoeKAU9cQEhvhrWQgXO+Mf31fxELMvBEIJ7meh4A9NZful2xowt0xLL7h6CnwsrmhzckAnJ/fBURFep79mL75VceXQNaQ3X/NgBit5Lmb4gLbxyINE3PxtQixWcwKxs6cyLlFFom+AJf1cX0UZBzNpUtGCN+PEX/Mw+p17vcPm1RIhFB4KJNeLtjZKdSeiE5FHyIK52iD2Bugg9RTvXGQV7S29eYh+Syomd1G4BHRSuYxBstnyf3JFlWTa+f+4ONQJsjDtnO3tD0lzINGKPt2LvAkdDQjkS5K46MEHvDD68oyz0rYHvMw5xN1liMFI4oYFRruq0XgvD8RudqH6Cgp1xp5HytTbF7fJu9AjwgIn3pf
 gu0R5TbK
 1Yor5bt4PBek1/fMMvkARVlKD6D/WSe+tEHm2WJ26iM1zBnGbwNurlLpMFPFYdZ70lsxOeb5qgox72TWuMV2SzkYvNBSM6V91GUslTdflSOmiaCr1t+iCoYkOTN8GxCcPbsbgabKzU9Q58j745gOfvxRtFRA6RHEEIF1STymMfWuAiBJUvNJXWr5ibZ/8qXOr+Ji02CirBDqjh2pwFZLTc9mDIDNVSnBlEelORw0PrXZ0exZQOQaii4hrxEFg8Euhe7+xNAMvbZ+OD8m2zT8gq1BedcD4tWG1kYOQLwbZqlFrCVRypllj5xaBopBUud/43qoQRX2U8jiXEaZao3uAFkyFGUX1YBrSGQYwQeI9CdpfEAx4r7vhtH6k301e1ffuIanFFljxkNKZG5+k0YPAnciZc8FjxUrLkWo1JSZRblEq+avoKajA0VfljGX+C8hZKFahliACM0TQV+jw4SC+AvGtR69QfmTowJTth5Od+8dxCirDarxN53cSyVGaQq4EmW6m+dN871thwaYmGX1R03HGSl6v0amrwCQCDf3PNN3dNJDZ/bNsv0Zq7nTpp48/qfwYfhjsWroe8a8xZBhoO8VEUm/Cqf31DRVN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 02:15:40AM +0000, Wei Yang wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") introduced the concept of device-private
> PMD entries, but did not correctly update the rmap walk code to
> account for them.
> 
> As a result, when page_vma_mapped_walk() encounters device-private
> PMD entries, it takes no action other than to acquire the PMD lock
> and exit.
> 
> However this is highly problematic for two reasons - firstly,
> device private entries possess a PFN so check_pmd() needs to be
> called to ensure an overlapping PFN range.
> 
> Secondly, and more importantly, if PVMW_MIGRATION is set the
> caller assumes the returned entry is a migration entry, resulting
> in memory corruption when the caller tries to interpret the device
> private entry as such.
> 
> In addition, commit 146287290023 ("mm/huge_memory: implement
> device-private THP splitting") allowed device private PMDs to be
> split like THP mappings, but again did not update this code path.
> 
> As a result, we might race a PMD split prior to acquiring the PMD
> lock.
> 
> This patch addresses all of these issues by invoking check_pmd(),
> ensuring PMVW_MIGRATION is not set and checks whether a split raced
> us we do for PMD THP and migration entries.
> 
> Instead of checking for a subset of the cases after taking the
> pmd_lock(), put device-private along with pmd_trans_huge() and
> pmd_is_migration_entry(). Also remove thp_migration_supported() as
> it is already guarded by pmd_is_migration_entry().
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> 
> ---
> v5:
>   * put device-private pmd handling along with the other two cases
>   * remove thp_migration_supported()
> v4: https://lore.kernel.org/all/20260624065353.1622-1-richard.weiyang@gmail.com/T/#u
>   * refine subject and commit log based on Lorenzo's suggestion
>   * put pmd device-private entry handling in its own if branch,
>     suggested by Lorenzo
> 
> v3:
>   * remove cleanup part, only fix the issue for device-private entry
>   * refine user effect description based on Lorenzo's suggestion
> 
> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>   * specify the possible error case of current code and user visible effect
>   * besides fix, cleanup the pmd entry handling based on David's suggestion
> 
> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
> ---
>  mm/page_vma_mapped.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 2ccbabfb2cc1..2d6c58488e3a 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -243,21 +243,30 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  		 */
>  		pmde = pmdp_get_lockless(pvmw->pmd);
>  
> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> +		    pmd_is_device_private_entry(pmde)) {
>  			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>  			pmde = *pvmw->pmd;
> -			if (!pmd_present(pmde)) {
> +			if (pmd_is_migration_entry(pmde)) {
>  				softleaf_t entry;
>  
> -				if (!thp_migration_supported() ||
> -				    !(pvmw->flags & PVMW_MIGRATION))
> +				if (!(pvmw->flags & PVMW_MIGRATION))
>  					return not_found(pvmw);
>  				entry = softleaf_from_pmd(pmde);
> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> +					return not_found(pvmw);
> +				return true;
> +			} else if (pmd_is_device_private_entry(pmde)) {
> +				softleaf_t entry;
>  
> -				if (!softleaf_is_migration(entry) ||
> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
> +				if (pvmw->flags & PVMW_MIGRATION)
> +					return not_found(pvmw);
> +				entry = softleaf_from_pmd(pmde);
> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>  					return not_found(pvmw);
>  				return true;
> +			} else if (!pmd_present(pmde)) {
> +				return not_found(pvmw);
>  			}
>  			if (likely(pmd_trans_huge(pmde))) {
>  				if (pvmw->flags & PVMW_MIGRATION)
> @@ -266,17 +275,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  					return not_found(pvmw);
>  				return true;
>  			}
> -			/* THP pmd was split under us: handle on pte level */
> +			/* THP/device-private pmd was split under us: handle on pte level */
>  			spin_unlock(pvmw->ptl);
>  			pvmw->ptl = NULL;
>  		} else if (!pmd_present(pmde)) {
> -			const softleaf_t entry = softleaf_from_pmd(pmde);
> -
> -			if (softleaf_is_device_private(entry)) {
> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> -				return true;
> -			}
> -
>  			if ((pvmw->flags & PVMW_SYNC) &&
>  			    thp_vma_suitable_order(vma, pvmw->address,
>  						   PMD_ORDER) &&
> --

Thanks!

Acked-by: Balbir Singh <balbirs@nvidia.com>

