Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10885CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AAAA80121; Tue, 28 Oct 2025 02:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581A2800E4; Tue, 28 Oct 2025 02:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4708880121; Tue, 28 Oct 2025 02:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35FE0800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:25:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D487849145
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:25:03 +0000 (UTC)
X-FDA: 84046535286.15.E04B36B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 800C912000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:25:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n24+TFMD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AXLfP8ej;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761632700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUqCLm+nH6ouHAL4UY6Rauf8HucEUPoSFRJUUdTtoaw=;
	b=BuOnzWfq2DOqmlpNO7apNrgK9yKUoEeNCYsq5HR2NFtR7N0Y8utmlUyK7tKwknverBY78J
	l1ztuIQoTxjAn07ksddY8LM0YQ35w+03xWwna70L7JLOkjIA0v6xNmOA42f/OO2O0PuwbH
	J8hyl7h6Y0BywoCUuVp0qN40raooKTA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n24+TFMD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AXLfP8ej;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761632700; a=rsa-sha256;
	cv=pass;
	b=ti2A6hRf0APAecjgafDHkB0e6ff8eGUMMxxrmknLydCgzyevLQgWMUN8EAB9Eoyk16HxNd
	M5ToE0FhLiO3hs7MwYwLmN32O8xevHR+6qmJ7Hex6u5cX5dkdmfruZ2V8aIpS6n16FX+0r
	gLTYplqgN5bOGDeSt2S+i2c0izSqw8c=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5NTU6010421;
	Tue, 28 Oct 2025 06:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YUqCLm+nH6ouHAL4UY
	6Rauf8HucEUPoSFRJUUdTtoaw=; b=n24+TFMD77YzZW6YiFaSEZVNkQgNESr0iI
	dXd31UATX63iSsol5H2GOgjISSiYbYl1B1/B91sUjr8+mdjYtMwC42oV7lBUEXkw
	jLampmfr2J8P0D4zkXktd6zFrsgYCqAZMPpn9NqnY2O0wHk1nR6n2+dh6h0QfsWT
	cFrqiMCDLVAq8euSC6eBko284LQVh08UF1tbtCYnSF7lBqQoq4zcmLIrH4UdKRze
	JNReb9d96sjbZqqNb9uVg0iGRqJpRwqaJN4mjD4AO6szYR3en6SpuIZCr+hsd8wx
	CJB5fQs80I6BjtJtaScVpAEnsCbqC2g70Z+lRNH8Z2jUL6pMa1pw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uuapd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:24:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5VuoV024898;
	Tue, 28 Oct 2025 06:24:54 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n080jx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:24:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSNw/h/QMBFvjatFZNqRCmEDsE/Y087SLA/0FThev7mLFwRsCYC67MCPIQyY0evvDxr0sYIVCm8CC42xQftjn3P9gZBM/owCW6sOWmvd0EUIRSm7NAB8CWlVc2uPcqS+scxRRAq0UfE/puJ5X4KsBPtA1AEMVr4DQ1mNERoAElEJFcmS9wK0sfuK3A4BejcjfwfBr6HI5GCbeQ9LHW6bLM5RgPYVHlwT7fBM2zDN1OmMJaewdvuFcEpfnP58Vv5NF16vA2ykxbaVJQ4TvBM/UpVPfxOTq44X+yFV4vHF9FMIriQR0ohedZVXv/K+oQGP1hZbi+1RMjNzyisPN8mjQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUqCLm+nH6ouHAL4UY6Rauf8HucEUPoSFRJUUdTtoaw=;
 b=onPXjb3rkvHLm4jzSICox5Ti3wIrOO4TOpqiDZUylU12tnjZeZTRwPlsymWVhf0howPVErerUeUhQYCfVOQopgk+f+XawV4YkO56GBNmFVj/I5I4mjMKgdG1rhMxgGxzRFj+zVmY8gzWOBxMq3zsFqmQtUt/4/R3M22X+JY5DdC8OzbAfZx1hx/XBObE07KT9FNadzg5hVxZU5lUzNYEUghQA/dC/DXXJYMMweEFIix+p3OziMe/q36HIM4qHpdh5jUZMGS1w6fVHeHIMSh18baWyJcTur5F53CsziiYgqJyQMK8tEqdaxHUvV4+RblGGnA3Autx2tBp1oYWajGHxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUqCLm+nH6ouHAL4UY6Rauf8HucEUPoSFRJUUdTtoaw=;
 b=AXLfP8ejDrJZrC/3bmIu4+PZTFHimLSp2Fo5P1y3Q89K02tsI2HQRY8vZEE/g/I0CnqqRUvB1e4J/5B0H6KJ7hCoVZ3BiKodaXxMhS29MpBms9201571U9ahRLXdCEm4SX9nWm++6KIArl+rAaCwvQ6ovOLnVXRS8P+8jQA+Leo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPFE06E70EA4.namprd10.prod.outlook.com (2603:10b6:518:1::7d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 06:24:51 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 06:24:51 +0000
Date: Tue, 28 Oct 2025 15:24:45 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v3 05/17] slab: Remove folio references from
 ___kmalloc_large_node()
Message-ID: <aQBhrTbWxTKDU8RY@hyeyoo>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-6-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024204434.2461319-6-willy@infradead.org>
X-ClientProxiedBy: SE2P216CA0016.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:114::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPFE06E70EA4:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ab818c-1c63-4672-de21-08de15eab378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3V1WkvON/Pd8TvfLWOn3qCdl8iyLVJHCjbTEiOUSMOa9rzyjMcQEPTBOyaMe?=
 =?us-ascii?Q?r7VlvVBTLKCmIRWX8gVRks1jTHezbAqpO4EnFvmthW8300V7Kmcvo/rhXzu8?=
 =?us-ascii?Q?K7zivcQ3nMjiPYo5lQj6biAQMzf9A08mwsptH63BynOOnQKpNwNG+6JcD48n?=
 =?us-ascii?Q?5Dw9UpM7KAbtfxzHopOgrmzSyzj4j+HRrHBskzsLIM5J+j9N/TV5xIFfwQgo?=
 =?us-ascii?Q?tVFubLIRjaSBKwKGlE7cu88c6ITObCYT8Wy2xiY1mKMz5/Av9BX9YWNzCmCM?=
 =?us-ascii?Q?sGZzRQiGwbm+D6OYx96NwZzZESTHn2LJ9wrC2nAoKr5AYgBZpkOWIldYE4q3?=
 =?us-ascii?Q?tNDGt9QCwu8ETTE3AgZ3R2CD2bzohnwCP1qv/HXTIwXA9MSxtAUloUsISWse?=
 =?us-ascii?Q?Wfec233+/ah4r5ZBEgqFz5H6GQ+18nLulcUdZq5R0AYGXpG3glh8A7sE5BXE?=
 =?us-ascii?Q?ZF/c2QO6iHIev+B9wt+ikNvu9Y5J64sTyL0kroA4v19aBWxOTVK2wMpBnaJq?=
 =?us-ascii?Q?Xy5v4IVFWzdzx2vIv1NycekAlDjmjROq3v0BqAxh7l7mkeN2BoCbDmYH/Ru7?=
 =?us-ascii?Q?qwXBrxgfHvSIWHiH3csaUvxA9myB1UJK5xJSHzj3Ji8AplPYE6400zxswhLV?=
 =?us-ascii?Q?HAWykBLn/P2RzBT3kn3kV/2wSCKeyVp+renARN7aPeDmokiIRladYl9TSyxU?=
 =?us-ascii?Q?/Thf1hnbzrFbmaR8cKjsXE9nL2fTG/JephdGvcXKQFOUl6DSLf9SZfa5inn7?=
 =?us-ascii?Q?xq0RPW4GctGOPfv14YBfRauLrlIwofQHieT4YR+ssU/7FBQEHMma0Nkq+DU+?=
 =?us-ascii?Q?V/1ewr/EdKBOrH1LcRaab/DPHG67kg+/Eotm8wABNlidA84WcFo3jO2TWEYM?=
 =?us-ascii?Q?+Xqz6B4iIBdP/aGTBlIOGe2Kc3pMf4l0m+hwiyRiDXAyC/KOkb3ZD4dO6QCQ?=
 =?us-ascii?Q?adNxM8lDmag97QXsbRRB2F5wyKhyZS9lcGPna5akKr1HFpBtGO+chS01+iY5?=
 =?us-ascii?Q?zF/XtJ/TgnXngaBkWauKdHIjMOLVey3hIwhkgh1V2l/jhdusv2ElS9CK215M?=
 =?us-ascii?Q?OyaXGBH6H2n7/qt05OwnkYmmQjJnxjehbS3C4ykkCMbWPVTBB9uGHxuTh988?=
 =?us-ascii?Q?9rTPcXSviCHDPAbokXwoPQpKN0RRvn7ixIDsWnACgwdwhXDCW2rWIqHDOeb4?=
 =?us-ascii?Q?339v2J8kWfMeHuSdY1m1jlVOMVm6xZ14FUATqYQ6mJk1L+7c1HXX8eFTnRWR?=
 =?us-ascii?Q?tkEytT2KL98ej627dENaF1S3WGARhFmYFdN5PkPKADKEiUkoyq/YVCgPYg/S?=
 =?us-ascii?Q?1BUkwRAij7A/9G5N2IOuDzHNB96ya4aZI2SD/pkxk15TqK1gb2f92nrbfVF4?=
 =?us-ascii?Q?2t2kAAGW8E7fm/+pTSxkleRmV8eyqAULYHQO2/f2TQHBsGnUBcVYXgyRKJas?=
 =?us-ascii?Q?GExffWcw/cUgShtw2OX9lKKz/Q6+FIR+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MatK45rN/3rJsLfG9XeiFmlRo+3GH5Xs9htnuas6TyMQNx6pyXw5S8Ewop7K?=
 =?us-ascii?Q?Do3c3lvPEOf17xd0p76FwjXTY0ikQ1l49YKcn5ytLGL8RyB2ONHxhBTYoBjM?=
 =?us-ascii?Q?PiljvHBULLwi6OLi6TVsAifd4mzWU8KLY2DJ9jh3yOmProHfD+xi4RAie4JV?=
 =?us-ascii?Q?8DXtPZbICr81A+0b83zSmsCGBEfrt/hXhDwfLD+XS8SOipj46rbCb5wQzrwn?=
 =?us-ascii?Q?DvjDvBXyeqM6Z99EJ1puCONFWeUtcMelyQ+kL9w72jtgeuFHg3Zn4TKoHD8E?=
 =?us-ascii?Q?Y4fvLF/wXBsTfVln0p+3zwiD1RmnV+kd9y2eJCFxOd7PL4zl4a2ZiHLATKMI?=
 =?us-ascii?Q?1o4uzaHT1KzEM7KSnwi9thdZAOtny6AcFTCgZks1uG/Z6dvJLdNoq9Lta7QA?=
 =?us-ascii?Q?idRbGEuYCypYtNaQHg+nKDEzQmm5cS6IJSm+a4Q51D7dcW9WdKkMRO4P6RoO?=
 =?us-ascii?Q?zsYitEObmVlSHA3m1+nMoaYaHHJ08LVtqFNJxqfv75E5l8UVXeSQ3WqOFiW6?=
 =?us-ascii?Q?JT87oZhNC9hdfTRHJzLoXo0fH0b4SQjOrHsT+ubkoGrySxcAigB9FqgXGrgn?=
 =?us-ascii?Q?ScVJBvO8zQM7Y42kw5Q6Xcn5WsbJbgaceZeza5AcTjPeIhPosz0WMhVvgU13?=
 =?us-ascii?Q?F9vi3S9reB9JJ9tmnRP91Trsov9DeU4dJUls0WNxu/hpVM3WHWjJNhGERU3A?=
 =?us-ascii?Q?nhmA0jPPlfvcNPpYH8OG9FjfyJ9dEeD46JwJwLOFeRz5AYR+5KcuVC3zbScs?=
 =?us-ascii?Q?pFZvUKE42Eyfmg3C9AToNGs97CohyOhrdWHSx/CCBuOQYUMzEiSfeoiSa9YO?=
 =?us-ascii?Q?TJi7tGFNefTvPruCS7iCZn26qAj7QIEiDk/gYdOcSZJnAUc3swFMl1gI0y78?=
 =?us-ascii?Q?yQpVrtUXQoLrLtP9ByOIWe59uZlj9Nxb/wZuxmzDnRe1cQ96cCkt8HL/403b?=
 =?us-ascii?Q?4U4kO5ysFzKEgJovXFvYeNDMcsNyTcnVYx8mSgn5aOTQ4rH7hZf1TBIgPHlk?=
 =?us-ascii?Q?T6AzpGjRyg96VDTy7HGeeSOAqBbzZp4Pp7dj2R1i5u0FdqQqHC5vxnpcSzVm?=
 =?us-ascii?Q?fjjgm/MhEwtdNSOfDyH6ra9Q+pG0dxFslx6zTb0Ed3f5N84J9HZse6n8lRPy?=
 =?us-ascii?Q?zcc+Y34CK9hMjbQlDD+aP/99ljK6Zcv6BEHY/t/Ymb6B7IShW+i+2P5a8f4T?=
 =?us-ascii?Q?ofGqwVZXaj1uC7WcNj8FVptWEmjFEu+onTeTJf3SFlFT6eYxl+UyQcmI1hbA?=
 =?us-ascii?Q?ZO7xb7WilqvS7AyVA5Al409M7xRd/QCqN839IGZ0MZwb6gGfTtFShwU0qKAr?=
 =?us-ascii?Q?G9Va+WI4kIZBnJ42FGEGil4aDoz9J5vjh//V4xMkm3HGeFWmPATlFlxNOFEg?=
 =?us-ascii?Q?JE1dKnIdNfVPotu6wK12rrf9ImA9rKqUOUxln5t5UzReVXUr713o/Gh57Q+v?=
 =?us-ascii?Q?hESijqjS6UpJCGe72BWahv0ePCpXJiD7G2QFdpOGFnCO5Un3DzgKAZTiQCam?=
 =?us-ascii?Q?clwGXPwys8LB/3n7yqJ2A/f3l4XYtyALx4ckkFaIFn/t0BYKaFra0bMglK2s?=
 =?us-ascii?Q?o3qT3lMjiYoZhDMtIgEOH6jngUu4hlTuFA7Ra6xv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HCPfor8Z6HMi8wdzstI+gBvlQFPbS5F7KL82KgmLYSAzHh7grHWPif/A6rL68iXOpG5YT/PYs4p5hWPK+BWtcfoPOgx68cBiKv7bUHo/Dy+MdOqIr6QXxjYgT6Ek6mE252yOZHr0a+4S/ji981hTzTixaUzZtU0XU0IrpJ5SQ6uyjxfyx9g1xcgmpMaXaeF4/ldNYlMIaO+4/PDQQJD88/YwNCZhAI9V9Iiinv1YVRL/vIUBT2phFAeJ7qIBtVnQmzkNz2iKEEGV9S78uPWUdn0ITpSsjAJ1vkW9DJ0BvFXsKC6KGMVgiA+THVsFrUHuUek1NdJWNLtmQnBOFDNwsLXYX3xk9outf2+N4onWoddWUYUuIdgru/T67t5TIxju+MZHikczTseuKaOy2L6uDLnTXpW/YPsAS1xM4vTOm3nyQ9sWirkrIBO6zKEyDeOxSjEPDS7YbHWqliuAwA2bXiA54Hig9CVFSOSK1jOTXwNjy5s8CTuMX5tzR3PpWhV0RBS9MfgXJzDA5CjS5ZRDO0Ilr8EEuBsBsIU714Vi3zzp02wJQSI6gOGVbyu3mjrPlGREG1KVwCRkakaxLyhKfZux9ukGabXbRIeK03QzJoU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ab818c-1c63-4672-de21-08de15eab378
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 06:24:51.2982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGkyG95KT01fNTcpHSGMaT2ixxTCNhMRkYoM7qeJd5J7wY1GtZQw0TREgM2d8uLmMjU1owW0R3GHDPoQZ0vENw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE06E70EA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280053
X-Proofpoint-GUID: DYf6JAzdaClp1CkKEVuvSCBO7JQGXEwt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX4hB5y9D+woPf
 9JUkTc9QdCb4ZTTrI9rYeEcjT73V3bvAADAqaXX+v1Pw7HWXpXhgBXO7rJP6n936FGLCpR6ybSB
 j66g5FYHFDRG7W+id6lDu6bFfi/DCCuaFu4+McdHMXTvr+5px/mJ6sdLwMqOHjRX0kT7KNyAqF5
 TYqm/uPKFMQqs1f/yf1I3lOjxCS3EK3wqj/rI5BzN1OQZI0DzFg95TzqWf5EM1/DTOjce5FASj/
 IzZ6d8JfTHjBETIv+i99joodGPUIbqQCBcn5AOmfOroikrlU+cWuWgkiBQsiP/g0zYyV2SaH2PU
 6qMdGZYtkNhVY1zSC4Qr1cn6zwcCoLHTorSOIoi8pJqjwWpzrSjvEqe6Cla9bezaINmyXvvvyZ6
 1tSt3V5757e/wKTRX2P7BN+nps+kQw==
X-Authority-Analysis: v=2.4 cv=Xe+EDY55 c=1 sm=1 tr=0 ts=690061b7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=lnYYQb19Fs_rjGwmAtYA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: DYf6JAzdaClp1CkKEVuvSCBO7JQGXEwt
X-Stat-Signature: 7mobje4ja4xnsggrxudodpkubwr6c8j9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 800C912000C
X-HE-Tag: 1761632700-845190
X-HE-Meta: U2FsdGVkX1/2H3JF61L79E4ah/GiyQmCvwTbWPo3EMD5vymh6UfgdAXy6wKhRSaF/adyqdr04BthpgnDoRs3v9Makx0/YG7WKtbXPgC6NUPCVvTOZo6ORQLHI+cC831XzosLd2Qxbp2RYRxY+Ch5hyu4LF9BT/xSNHQXM1K1ugUVJjsuNvtFDf63fF8sOE8d2neM1BAcD/YJfQMI3UYiQAP6VF+nQVrC3R9vwKn7EP7+bYwVdwBIi7Pb+ma7HuMILHQqBA7E2dG7ZnRY1EPi7zpDQ5+9FPSmRmyqFXhD6z+Q9XX2VInOseYbplQLz92R6SIDgUqzTgwEkK/e/O+INB6MY6GWY0Xg1zDU5b/MOOv31geRQZbIsuUXwFXUWolhgno7OwhRUfHD+ZISsxRhQKzTBCJ+PKlRxAOPyLYbNHEaHwWzd5LWgnKGdPaCuYwty0ZSIgWEBhWbXjrpUzsilqLxg8NP9hOijRPi9AqvDNo3qFWmhHLLv4hxlDVzTdmj47f3IYNQ8EH2o4VeZTYFTo00pmJcDp2Q1PJ7/8iMGY0f+U3+lBrK4Vuas3UU84JLS5iBQ32c1Vvq8Xo9S5kNPLmRaWDL/ZiNPPUmoaD8eJeP006JtfLnUcLMqWsVv5SDi4oQvXGj/VaSU1nFMvd8a1XDqXbzhIIEHSyUDEhyxDQ4BbIHPtP1gspGK+q+GBsgK2Z/kfreosmHkbgIFUC9v8E8jPzh69Aq047vSJCl+zK1HUFUvuftZtqooWiJTuIHDluqEH8tJ0z9/yyzFgCmFpgcp5aPrJ/QGauxXsPnPVwmwlQIqukN2UZxcLN3QJk8duYdqCJJ/0ozqwmT8I8/IotnmAwPM+YFOP8eX9YWrHRjxRzu9xtY9jUWGCGb00qYIzDpksXHc+NpoI4ctecam4tZRoSATa10kffCALY4DcW/4M6tWtx0RelUHXiXvqfCJibTCUgN3Ci1ZbgWvqT
 MwNb/JFX
 htEz7JQpJcf7EmSkLUOEk8uFf1uTBt7lJXLfhy4mnd3ScFop9p6wH9GxERZXEjjOgjw5CQsGN2c+fAtXVVdbAfYixu93crpgKovK4L0aZfSP7BIBKkOo9MroS31heN6jRC0hlF8fOmG2u2hi7NPj1wD1os3x+C50KXuFdFRivQMopnGR/cRpgpMOObpN07r3jQLcz4GmX2PDH2D8Ufmk6Yg+jL3CrfrVJVnQC5z37ybwRhTx4/5I+foEc7OR2WFWvibS4xbC/8l3Ja3F7Jds9Ar/70t6VEBp4PE92eSm8TZ0uU/7bz9cuBUy+AiRxa4Se2e0Ns1ihCbLf1zvqh6Ed3K2MZHOVnKgZL5Gx+VqT2qJXcZSUxWdkEZUwxzrksLCNh9bnRSbdr51JE/jKmamNOmBA6+jIGK1JjNx3tHei2/FsCp0r9FEuK7luquyxsftfa2Rqa7Opk8yXEsqyLOCgqEUNK6Shhr5m4wXR2YUGcTF419gYMatK+lC56ucVYTKDcn0cly6OzakshzRZZBsSFtdYO+BH/Am6oauFGNzNZAT30hfBgrris8FoFJ2tKJ20pRcu9flh55vrLmahgCdY6/sY7YltJPhA9MfPZ90jYAUeEgmV/UiTuqM08q0I40uPyOdrs6TRp10PrYHXylFRmcFA5i5cz30ftURIZROoqVX2HSFRvSJ4y6nSr7l+N8+DOS0vmwq/Qq9J8E87xYxIT1zsNFJNM4kU1QAPHknJ6J+foNLfCixgjgDcyStKLpDo6nRZDa3qcK8e6k4HiHU9YiRAg2ueFIbAS4e9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:44:20PM +0100, Matthew Wilcox (Oracle) wrote:
> There's no need to use folio APIs here; just use a page directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

