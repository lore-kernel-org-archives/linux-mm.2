Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E90D4661D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A248A6B00CF; Thu, 15 Jan 2026 14:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F386B00D0; Thu, 15 Jan 2026 14:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728DC6B00D2; Thu, 15 Jan 2026 14:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5544A6B00CF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BDEB140461
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:31 +0000 (UTC)
X-FDA: 84335207502.04.9640FFD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F69820009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q6c1jw2v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Hs8kvfUe;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IYw0gmxm31WKmcuelyp8IPfHpeekA9MBbyeUza2MSs=;
	b=eyjwnMklWDEWLN+ae1W+AfZvSBR3qIjFNjSsQn8iIH3UsaopZQ1BxSOuFMecYks0oQWp4D
	HwjSbSkBwrELR18DFMKIayTigoRiaxsvv1xSrku+rS9AHttQ/DUKboQTEfKFwr66unp1nx
	0fKZIFWvD0r2ZgoXSN0IkvmuttbHlLw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q6c1jw2v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Hs8kvfUe;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505847; a=rsa-sha256;
	cv=pass;
	b=D9+nqnnRZLeJrJnmmqdAyLlzAixCkTak94BkI6aTVUwDb733jMQX29uTdfEZ2FidfVQjSe
	uAnMh08kUlzezPPaDrT8G2r93AQHJdVPxszS05XBBWZs43XC0rRRZi/42g986eI+ChH4Ok
	dg5Zw+OTdU/mncaDYkBcRgvokGlGPYY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FHQv0b2419474;
	Thu, 15 Jan 2026 19:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3IYw0gmxm31WKmcuelyp8IPfHpeekA9MBbyeUza2MSs=; b=
	q6c1jw2vd8fU6aSM01+V/ag69atL+T1QOFguWRnjsj2D9kHdM2a7Cyhjb3Q6zgos
	m3cU/upCeSEqz6RmX5Ls7DroyWT4nsr1CqzvUdt+ELwKjtn+5hs8Eq3jbk99e1/R
	XiwBPhh+NWWa3W2G2T6E8UQNtobq9DK2b68JckrvF6NZ3rTHYs3uAZxNauo9zUMs
	EVrZMj99N5ed0enaoovWfudL498BEiUGlMtVEPe2vw9R6/9i9PhA9pngxi9ZLjwz
	RlzmZHeBvmqUowSelumhV6ult+ftLzL64YPaAc2qeLfLjfYJIqlSXkKys201tw22
	OYNyTwjincZcGYP+FIVlTQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre40j13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FISGK8035318;
	Thu, 15 Jan 2026 19:37:18 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010006.outbound.protection.outlook.com [52.101.46.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bqn54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oy/0gUtZEvpdRb71BF6kPs/C92XthlR+ySUX7pEPZlt6wVRdcRVcMeWGRr2sxIcojDLXLqFBJvy1jzqUOd51lSq8/YfoHSqKteCaxarOzZxoAd9aocrM+2qLVhZXV9b3IwclOLnWhorK+MWRhaL8jJUaPRyCBhYP5FpCDXy7ynCBKpXiUFYHDBz+q7/ngADV+iRqiZ7FxcC7KBQIvw2fxhagTBGmAlADhvrfCptgnt7FzQOU6PoFeAfmrwfFaqbsjNCEi0EiztGl4i0hYoLCE1OsHi2itLdpDPXvldlds0gtockGnT9L2Yn8/F8+BJ1WPcm3hOYbpJa6FFItce2uEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IYw0gmxm31WKmcuelyp8IPfHpeekA9MBbyeUza2MSs=;
 b=V1FG5zzXlEnYeor/bmksEIeJaFE4LQnOHbAyB0t9iYqqMuQv/RVId/jkYkWr5UPYa4xcu1qrDBb0gvr23e4k2tHIgIBd9VuEIq5go0we+CGcY6YuAtwEeO1GL1o13s4bISZPaPzZywsGC7Rb42VCFrl+1VVXN3hSpN8VCYSkuukW5i0h4OibZa5teXYIvoEX59h28Kf0ffRXY6EerkoLWwLKcUKMqcveBIBvSy9BoB690fj7+ZJIx20WSVikLvaFfQTGieUraDo8soF/hXIbY+9YRKXchgauaNg3g4XeWBet6blAG0V980FqvLLkpoOu/hycpelRGvl8wALjcPwiQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IYw0gmxm31WKmcuelyp8IPfHpeekA9MBbyeUza2MSs=;
 b=Hs8kvfUe3dmG1aB3/L2ly3XrRo6zJwCSZLgQGXRRbsCYXmaZHYyx0fcbXsMSU59BMEXCCjVb1HLuKreSAvEOaDIhOzleiML2JD5zRQpJHFjHzXbn+CKj1gu9Hft8UTZMZc/uEPFQPChFuSdbRSqQYqWtUpY5VOk8hR6jO6zvEto=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:15 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 08/28] maple_tree: Move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance
Date: Thu, 15 Jan 2026 14:36:27 -0500
Message-ID: <20260115193647.1695937-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: e2e069a6-ef9a-4559-d972-08de546d7c8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A+CD+523fdJ2wJh8oZzaa8Z/uPCJHau4VmblI8SwKgVnuMKE4jHZwnb83gHP?=
 =?us-ascii?Q?DJh1cdmNyxwR8wZtwmJjtIgkphsRC2eNZKCeSCvPSqirfEqWzXAQRhc2gS/W?=
 =?us-ascii?Q?NB2jS2PSCUcVufBPz0tS9pr4Iolfcz1oI58zo47Okr1/+My38U6FlITkVw2m?=
 =?us-ascii?Q?sVG6Agg4gte0DDb0I0d309grvDOft0UIx3OkXij/Fiytth9FTO76FRgmvAW5?=
 =?us-ascii?Q?LVb5Nxsl4W47TVyPBYq9lUQ33f+53uHkuF0gCnasDUvCsWbOIJWdCMFYO6IS?=
 =?us-ascii?Q?OQPmjzHqHm5VFux5aNNi0jXAW+FclgTbpUEufLt3yWPKXBMkUhZ6AYNs9Lli?=
 =?us-ascii?Q?MboWv33EEZ16D2t62xFPoUSRZn7yHMnHX66efJ1mzmiFSq8SiE66iOtijZkF?=
 =?us-ascii?Q?EiCmFPKS76wv28erhWkfu1q3HN9kw0JsPY4EHLKif572y43gIVW8+PxP0A2s?=
 =?us-ascii?Q?UVuVnSuBYK42twT7lD7rioDu9zLJ7d4HS2r+KxpMvHmXaKMah3cfCGGkk317?=
 =?us-ascii?Q?rupDbb8XeNckD0DE+pvEUWe8Rpt+klBrwfEJjG103G6WxGn58zIsIOjEfH0V?=
 =?us-ascii?Q?SjnsJLpaWwP0a45GmoF1HLwUJA6JW2OyH+uA80TDV5fGlxEiwqsPqum4LmQz?=
 =?us-ascii?Q?eKPuA1YAwPiRT/czrx3UDdD+jkgRPEVmUR3SRGX++tcyPP4pybvslbZXd6nP?=
 =?us-ascii?Q?q6ddK6eRx/gTCy/LvypCIpM6DLP9dp97+lu/tOvsYT1JKDpmtBGnFrPSXn1V?=
 =?us-ascii?Q?mzJa3Lt7Qm4ABRCPrMCVS4occ73qv/Fqfbrfe2VBGXXY/WDdCVdNMnh9AKMM?=
 =?us-ascii?Q?Zm/YwXQNJ0f10TUBBunSv787l7zDAKcYSdGt7y2PVEpudB/9LN1ezofNm8H6?=
 =?us-ascii?Q?xbfAoa56cQLhzAljMDiWy/3L4fDYSEI+Y0RaJ3cr0Lj3Srl4ddsWYigeOszN?=
 =?us-ascii?Q?J6UEakiYHO4MPu1AKxJp+georKu4nVo8IPXTst6VpB3mL4bauOyGKOgWm0EA?=
 =?us-ascii?Q?8FDmpc886LkEFr55uX2xc8gSh5k8sJyDNdl2BFOkzhwCmRTWC3Sgx0QL25Ns?=
 =?us-ascii?Q?X9BHOUrJIofcdGpW230mTG76Pi3DOGCGAYYUvbnH5hCbMXrdYb+wE+JNUJs8?=
 =?us-ascii?Q?I1GOQQV2x8PMOeSs98xFaCQmVn7G9m/iofhqi9Iin+2EHA2PYj6HZ3EhPsu0?=
 =?us-ascii?Q?f7d/8AGvp/C0lej0Dt5dB4FUIUoTcNCErpKN5WGevPIavwu0PpQOJjJRLi/9?=
 =?us-ascii?Q?KtCtQfezQDokjbQKoRS9fF+INTVcmrNNNjqRkNJrGieQNkBc+gT+XnkjJ5wu?=
 =?us-ascii?Q?dPqFQTqa5JO8yV+fkkfs2OSLFFAJ4COY6Pf3cyEi4X9L0ve3Ky6p1sWRaLKb?=
 =?us-ascii?Q?9PEdRQbhKQiURH1gBolBklMjcG3e5OzDrIAGyGRWSsw4rUdTdwGumXlOUCl6?=
 =?us-ascii?Q?4ahpuBjPCRF388qYzEc9zRj0Fihz4aZtS4xPDJCS7tZYsXT4C5B1mWAwMogh?=
 =?us-ascii?Q?+99MCd8HG6eF84Pm/E4JCOFujy6/sZixV5byAQJr5sO1gNpnxuv/25nEhh8P?=
 =?us-ascii?Q?2bCFaSFp7pF9ve2oDio=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5IXQJhIo8EnPR/iHwN+mjr8WGRe/1OuMdZpu8rR6V4Q3UMZ1+5wKpTvxgZ4a?=
 =?us-ascii?Q?rQOvEbd0EIWLFpG9kUwZLdqG54VxlODx/9PPFa06Hc9WMRFHOkbQdfJG/lLX?=
 =?us-ascii?Q?+KaRTWks8VBg63qeQuC1Vw5WsbAssY6gI6rF1uBgDWH3NEiV7KSsyafws6sz?=
 =?us-ascii?Q?OqAYpot5R8G5dXgxwrKCxVJg7gWfUfU9xXdoqUvIX5s5+q6HWTfdPKy7X9zt?=
 =?us-ascii?Q?vm5pzbnk+USJYAAFZUvr16mlZDpPELfj2LR/E8SqjG251kDc2UZ9kT/WooYX?=
 =?us-ascii?Q?kF8W9728JGxF4Kmx/5cdu5kRZsrRO9RJ5Dgc2jgGOlVn0/8MjUhymCDkJW0j?=
 =?us-ascii?Q?qeHZF5d/Wr6oifyu5q/09XwLgJTDNiwnox0egj7lAoELNIMvjduXHTpWTz9e?=
 =?us-ascii?Q?73fxqQzFlFMDqAs5wYl16/lnt0+3kaj3N97yd9e2397g7DjZn/wPXyIRr6ED?=
 =?us-ascii?Q?NU5bROlG/t19DnO9i8a7v10gcN5AxSUvjnJ5/i0W5fm/ZbE2WzT/lnApzYIk?=
 =?us-ascii?Q?aEh6++0ZA747MwdamutL4tWK1XUJki63i8yhxBZjfJqsbbNPRTiXxKFiElAU?=
 =?us-ascii?Q?Rp1DuujFPkcS1v5rBVmEA//eV7MY+frGPdpme2dfK5IZblF7zW5vb/kW+qs5?=
 =?us-ascii?Q?cJvc46IA5snr4Ih16euVzbaf1qXdkhOLa2/km1Ry5PhIp+maIBupLj5NhynR?=
 =?us-ascii?Q?Xwoaae83YYMmmDmNjozexEpJza7yhJq8T9Eqhja7mtiuwooi4pf77U2odr0J?=
 =?us-ascii?Q?xaTPtfQlpVy/sgvvF8ISIkn5Q5lunK/TT2eYYHTuSt9sRFXHwR5voxz12Gp6?=
 =?us-ascii?Q?71Zi6aeHRS9zDsj8QZimNVDwLww6BK8KG9R0xeZk73APkUQ9TMYhAG3zomcB?=
 =?us-ascii?Q?BXAmyV3oOyK7+1uCKGrz7SvSjUm0CZssi1uB+JHQ8FYPCZH6gU6HujABN61Q?=
 =?us-ascii?Q?oQ4kiSgXyiH8n0TIIR6Wf2qasmOmzM8CGwxyJt9eMU5c3r62Lptn50aofx6U?=
 =?us-ascii?Q?eXkgt3QdMRij3N3Fa1oDlFZE2DULhbLCajxkgO1B9pbXgJe+FBxDO/sTqjVI?=
 =?us-ascii?Q?Ro5QNWQjuTRrUAmLxk7blP3m8svr5ci8fj6JgkaEBce0s63QX9jacUw5YplZ?=
 =?us-ascii?Q?n6OrhzLY5W7xC5KAVcgAp68PfJ7kPlxoErCmbqI+CWh9x8ll/Zq7hUoC+POM?=
 =?us-ascii?Q?aeklSuyRED5OoT2FK3dTa6mZ9I47b6bDki7d/R7WbcbgGWOhteuzI3Zae01h?=
 =?us-ascii?Q?Gnbh91upE8gVHwQOZLPjFRb4aDSClA0V9vENRgy0oJ7nMjnmJUzuCjd+j49t?=
 =?us-ascii?Q?cIG9UzVX68IT1iFwBvioXMJZOf3R/AvLxjMZPwYK/+JMIXADdIBUENefqnVP?=
 =?us-ascii?Q?mEQLs4Pk/kzFox0YynMhq7fWFJ2jQSEcWkvW1PVuA+gwrbT5IMjOFi0rzZfz?=
 =?us-ascii?Q?e4PXLVaiunUmoT6L9BZJjqYvN8cQxSP4fVCj60SgqI4Rrtm4REf3YqrSh/3e?=
 =?us-ascii?Q?v9rIESMOObwsxfnf+PBJdJ4GhKyBly79j368zsyu/9YicVuWXfac5A5h8WK+?=
 =?us-ascii?Q?Cb/iDQGpg+OSLvOTRiA6icdfyPNF8QuP1OgqWfZX5zKWTYPUpo1PR+se5SLp?=
 =?us-ascii?Q?fq+4pjri5A/8p6R4CK5CS5y1MNeZ2MFcaSkiIPm8gsGZSD1WPHhB5WK5P7Dd?=
 =?us-ascii?Q?9KNQY93fBxEilNUiwpZw/ft7KKgp8LIKXMSvnQp2YSKmlG0gIZq+6pUzPQMo?=
 =?us-ascii?Q?Uju99bPehw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eKz9oH07Rnj1Yv8CLHUGkdWXkg7XOK8nTh6R/PVNT8G4ar/7kpqzN0j/VsQE7cqSqJLf1ffEEUVV5OXGlwAjBOROdDQc6FjCN1Wh1MrrzhJcGUvLPmJFXwJugKlIvme6saWE0dkBTaA8X3JYBTHpErwpCNE1RtytIj+000VXPITr8hI7tTDq49LWQvRCEBHngr8gR53/r/FWUQxT6/4C+8BeoP7tCnN9Z4j1j4vlWqhvuuabc6zM5ptuNRpRd4yBjjqTg5d5s01qD8kjdDa48DG/GV4CbYHQBpqxzCU1p7Cm6sKmxUstOx+BCSqowvDrE61eg2SJ2Js5k4mDNIjUYTDnCLutdhSnf1rgXLjhnaTJMiAOO0BOWV9Gb0/zIvebxm3i4ZKFJTtkOiGcrrGIwD4IkHOxySQRKyUg1xWYd/RA+zQzmTdUQzKy/ganRJsqzj7tSZd9MVhfn6XIvZ32r+X0x2yzPootTZirjjAlx9y4qoASdbIvuu3D3zDXXp7LTxccthXb2gxkaTK+uR4EeCCeVXuKdXCDqI/7gCndB/8TZB8kKijDTWLMTEzPxT2sVwzs0/sGPU+NBP5oEce4OMGL8X9ruQsrBiIR0OyvGyI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e069a6-ef9a-4559-d972-08de546d7c8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:15.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4P5GXY+91pg2PvIa+C9Abx6XNdXF4dHE8ZU3xsdh6B+dTUZf+cPLt7homaCZmmB8zWIpREk+NuRAHklion5ncw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Proofpoint-ORIG-GUID: m4pfhJCt13zCM1xIfEknYO0cMUpBdrqM
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696941ef b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=CYoulDwovmb3McnCtv4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXwOKQIPF8DhTZ
 y6HHnZPNcfNEDGfIxCFkCcwvbiccAXHEm6E32mBZTf6hXCBHofYfeSxfuDn9TUjLw4/kpfVpeJc
 WB0Y7ldXK3d6264lSrSlcyyEWW/lHBFmMhaENdro0afnqL02XOs6AxJftapy97ow4CLHW5euTdq
 IeQXjN2ZRvtUrcOtB0w/2RHeaJ9aX+H7AJi7i/z0Z4jqIcXd+KWhRVrVMIH/voTN4v7VhXKOVl9
 WPlBFYkR3+ajR636fEVl46qf3u2gVCVheu7XHgL6Gaz9a/n2gxO5b9OYyGU9l8Tg5bey37q7vWv
 xVurJ0zfBtkTJsOyJhzhqaHMt7jv25BqV+0BIUNXXAzsy06/Jj2oKFZgV3TyrRwMpaZIq2gTQEr
 ADnbvsCYTDjIgEbA+IoIDUUS7cpcTJgnPpSxDZuAdt4Y3rpP9iQPqBh/fjMJ+4JR4U8LvT3wQH/
 EcTFXK0O2smPfAZ7sUw==
X-Proofpoint-GUID: m4pfhJCt13zCM1xIfEknYO0cMUpBdrqM
X-Rspamd-Queue-Id: 8F69820009
X-Stat-Signature: npd1zky4w4dc8e63px3oiarrw1zfzj75
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768505847-377042
X-HE-Meta: U2FsdGVkX197U++6I5GoOr8oFxh7X449nuxX7ujvn2dmKQeHrgT3o3BGWmGbqXUotmQbOOKSqyPZMopTkVuwvBDas7lm5CGJ4KC6dBUcUA/Es2/j5BLWt32SZ1YifStb+hGEXVRdURSknt4BzK/RPwmUuUSluWnAof6rKiuTx7gCbL5+7Z+F0nvL2gAEU4jMHtGhMn6fFrZFrGx6LTGF6MogfThGzPgvspboeD/FDa2JeshSa4IXlMB1pc5QXrdqagwmKpimwkadWBH6fd251PcnX3i3dajMKbgVz5m62kjyYH0l3wmuwaayxemKtQVgXvIqYc0c4zSg6zs2wUd9AY/LZ3J7c+9tDWoJyTPRwJ2QeCpZUZiPMpS0jqelLoDDP/cySVd/T1fJhzBY6J4RAi+oRzzGZWM1VOxjnWwrcjlMph9rAhMfAAbzZTILona5MjFz3aJ9knlcYOPxtKJ5w1MBWrTSSitpUBLFZRrnOrY2Bqz3jTMcfMB4Yvv5YXra8zNZ2uhCQgUX68xfKFRXrcegZLg4lqY68burH4JXSUgt5kPM0YI3D6ptpyF95KcLJwh2RcEnqlZ/kMaGNar0ljIvZdrCFF8TiuiAnjb1uossX6s/has88C87F5ILYzLaXR3biqNAu9bZGQ2jDJ4UN7k3wfDH/QgCfY/rzj98k7cYqEBz0VIb/sDuDpLJ6Cgo06c+0Dp9mdMh3+gSjOlWIQkO2NroPNspH9HvbpAg7HMsZTTSRU/QJdlHaoTEWC9h34GZJJOycWJBNdI4vx3l3h54bmovyJjKVddc3Pcj9RgTy1pSO+z7xibSD7bZrmshIZHzuIYGIHvo4CUlAbh1fHBd2EJl0CforbiMnjRE/D3e0paaXeCa/LTN6uTa6ZDntPINqNJ/Ik1Upiry0FZi6nhsPzQ5YcNCX8S8seQCjTPylF/ArByRBaa2r8R3jnDj+pu2Vv27dxsCw8eIagj
 W9I2sylg
 XJo4tDdRoNjy2XRG5jGW6SHVkiRgQ8vlbwwRyZi9UvNR661E8JWDgj9iNZFWQw0KWAzdQ3bE7iGgdLqbzbR/wRxsz5+1xuiKTeZqiTWvm/001DuixDeZcyaqIsDBnrPcgRdiMFZ6LrquynotHlWvNfT6Y6efdp2wa20DEEMJs1fKlIU+TAzw9tqF6gVTYUrZNM/ooV8ttLq6LMaNYUKAQBafXH0rRS8HY8wpdm6zAJdczf2PozxtY9PrgQZ03K2/zqCLhEohAw7Pi1t2tyjor+EWI9t6cUdAg00mgrW4VSXiWGiORtkgi92JjrjtY6a9G+b0eUozY5jw9Kb9xib3iERmBH3sWDB2HwhVh+XQ8lBsZl7bYmevZszL6+7ohxkv1ECMsLHKG3LIU3JRoobbufzdRIYHO61IbrolBBFJLEDIwJj9vVVyxztwiduLKwY1XvJNHS67ZAAAdA3+wXrPb/iMOuDvWU3PZyWOhwdPA6Lrt6uusQfI2966N8WZNl/nLhNLUFDD5639e/ElWiVgOqemc9ACu4Mhz65uuwiP3gia+CyQ6xKNzLKzoNIKOnFxENvUMhiMXvu8XZgwLaBqOmoIPJnK8t+uA2XZVBBARAWC9IPO8oJcpNqRBFpCWL0CdB2uMlrl13kSjzdu6LzzHazZOpxZAQ0vHu7wQpim0zUVnoJ2iytsIrFSkMnCPF6Z7FHPr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Moving the maple_subtree_state is necessary for future cleanups and is
only set up in mas_wr_spanning_rebalance() but never used.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index bdcfcdd18dd65..e3b9d6687e6d7 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2750,46 +2750,52 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
+		struct ma_wr_state *wr_mas, struct ma_wr_state *r_wr_mas)
 {
+	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(mast_l_mas, NULL, 0, 0);
+
 
+	mast_l_mas = *mas;
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast.orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
-	if (mast->orig_r->max > mast->orig_r->last)
-		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
-			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	if (mast.orig_r->max > mast.orig_r->last)
+		mas_mab_cp(mast.orig_r, mast.orig_r->offset,
+			   mast.orig_r->end, &b_node, b_node.b_end + 1);
 	else
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->last = mas->index;
+	mast.orig_l->last = mas->index;
 
-	mast->bn = &b_node;
+	mast.bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
 
 	/*
 	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
 	 * Rebalancing is done by use of the ``struct maple_topiary``.
 	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
+	mast.l = &l_mas;
+	mast.m = &m_mas;
+	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
 
 	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
+	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
+		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, mast, height);
+	mas_spanning_rebalance_loop(mas, &mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
@@ -3447,11 +3453,9 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_subtree_state mast;
 	struct ma_state *mas;
 
 	/* Left and Right side of spanning store */
-	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
 
@@ -3505,10 +3509,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	l_mas = *mas;
-	mast.orig_l = &l_mas;
-	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
+	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
 }
 
 /*
-- 
2.47.3


