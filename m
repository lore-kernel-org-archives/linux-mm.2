Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D8DD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE3F6B0006; Mon, 15 Dec 2025 06:36:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67EE66B0007; Mon, 15 Dec 2025 06:36:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8BB6B0008; Mon, 15 Dec 2025 06:36:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34F506B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:36:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8E661DF673
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:36:28 +0000 (UTC)
X-FDA: 84221502456.19.8AAD8AB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 51923C0002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:36:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hBv0GRXG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uGUzkhET;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haojUEW5fj0GfvuzgqGCZIOw7lBIRPkx4ZInMn7qApY=;
	b=5C4PGyzPK44P36Fx90BpuaBKCOQw2ds2Kt8gIrRKRr7b9bXkTAvCEmJrOp1LSr6ayINPRa
	NDzcPTF4bbFVzXLUMyF67YJDjavgg+AldINOU+AqBOYwuQ3Hf+vFqj1m1I13/FpywNIIAg
	WP/l2AFrEftC5pirTeHpb91LjMBfcQw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765798585; a=rsa-sha256;
	cv=pass;
	b=Z3dlbaVJovPjLF0PASdqsoRYor+hpZ7mQI/CvbsAPHIQjQYap2fz0TqrkoIxyj/xwXuZ8Z
	3tvSp0zOf4aizyUiCCRYBeV3OaKmq6EDJWfSNdrkkXkJvgh4Hmk7jYFh9cdbKl3t3NOggi
	S0WWue0ioyx2nOfptiZxR2XeHcI4zgM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hBv0GRXG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uGUzkhET;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BF9ulSc1895081;
	Mon, 15 Dec 2025 11:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=haojUEW5fj0Gfvuzgq
	GCZIOw7lBIRPkx4ZInMn7qApY=; b=hBv0GRXGIohi0wJt5ljVyRmfgKJZX0iERj
	1hxNpAalmONg4lZ/NmLfRGoF/6Pgs826Bu08JnAONAhKKTJxd4LiUYJhqTKKz4Qk
	OtagdL5WN6F4co6dQmb5Hm5NEisOA8yKDDP5lJfuIniOSRQ9K3dJp28YVw7Foqbu
	/BTbHly8mXtgFAIJFtr9UZd+QdwHAH+3BdhS2gmqUf0Ap2hUCYetXaaAPFzNN0iT
	jsVa8q5MUaopD9EA5RjCKwsjCTc9hHpLIGsqWeLWGl//W3sgniMd6r6WSjn63Zbc
	6nnUb2gbxUzFVNkYQkKXtDP2AEieqOSOb0HdAZbInjcfEShBqqng==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx29v6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 11:36:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFBOYie024495;
	Mon, 15 Dec 2025 11:36:07 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010013.outbound.protection.outlook.com [52.101.61.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk939xa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 11:36:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrHLNNEJLFEkj6qIhU8moL/RJiKOR4dUhb/jokMhtnhI2KLhyOq4dCuSPfjRKLnGFvUm0CypWZYegy0KXyvFx6OZq5Zj76cbJAzVsPlh0DZwkKfOSifSIaUcBRXMo+4KGlR1nPj2VWptPPvQr4fADwHXtHSaeCU4oqfyZPIe2CRXNpyBNZ0JxkRX5lvN3CAanLh322gBCsFsLxMoCxBmXj+4URMPpQRN2+yTgvtKp/VeuNf78Ci3V6bH/wkHXUW1vAn2QDHbgns3Issld4Fz0nGIVs3ouHZNzDF0xTYHc4Kinh1EB6L3Mhc0zfi6E8oznszK0qPSp4vSzNcK0AoklA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haojUEW5fj0GfvuzgqGCZIOw7lBIRPkx4ZInMn7qApY=;
 b=XGOrJ5f/LxYWOIe2iVXexrrNqC7PVyA91QSMCFndN4Tu0L/ozE1hPS/fWhQ+6q7UvZueoEnep/EU8YeYGHxbPTbi6y1EqjToLK0HKBayUGWBD/LgfoWU9CDiF/sRz6UfsWBqVHg3j/rKYSvcJkQlUY193027Ujy7j5i5GyZMVz9D+Hae8VnKkxvEaaQnMJTgMDi66ywkVBx+gB0YvihbM1WklH0vCoHT7ck9BIO0qqC/tJqxFkQe0RxFk0l/gCRpZnj0z+dSFXizRTyj3fQUj5ELbN/oB4tEBZ5tagwfgJ8fuHW03BgOoS4FBV3P706IFabm89vPg5E0ou77cPKNpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haojUEW5fj0GfvuzgqGCZIOw7lBIRPkx4ZInMn7qApY=;
 b=uGUzkhETakHj96AlJp1eF342M3NzysUYPiR8m5ZI9h3p3kGG33U1CLKaVR41ZANGQvB548yANJxKMebsVAEF5SjhvEU71C/gsCX57b6CVg6avtJ9/rx/rTeOhrHVAcDV+z7P9a5aOKojwXd17aJI/LKgoY11R956pjW6mjRqwc8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7944.namprd10.prod.outlook.com (2603:10b6:408:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 11:36:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 11:36:03 +0000
Date: Mon, 15 Dec 2025 11:36:01 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
Message-ID: <5039c6a2-09b6-4c9b-accb-26583ba120db@lucifer.local>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: MM0P280CA0082.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a21fd1-bbdb-40fe-97f7-08de3bce20b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yMWiXbkLlrC72n+yGYut+MVdsQ8PPNC/SZmFgzgwYAWvYFKxQY6Stdg7sqCV?=
 =?us-ascii?Q?BuDk1hGk2cpoHM5wjXXY1zmSIdSb7eBPAXCHxWGjwIRQHiMt6MerIZN2wE/a?=
 =?us-ascii?Q?fzqkDyxuanNtA3NsptQ0gySDD7P4LZftTuKmo1gbE3YFI30pH6qXxOi4lQpZ?=
 =?us-ascii?Q?WiCRAT1Vo1yIG10XGrCV+CsEaGsgmyAsI41kjE6ogf/sE1h30x28bcrSplB1?=
 =?us-ascii?Q?A7f9sAApylbWMzhAPhFKvqgV2oyimgsU+6VggTaTuaS20bGMY9zpZySwpfOB?=
 =?us-ascii?Q?fpE42kiEtGOfGTbwHc+m37/kl90tFVSRGCtg48UUlHd7TaRMytQbGPc2VLtd?=
 =?us-ascii?Q?boVj6B6Q+tLq+uyHfopLybMrL4zL5ENqEBbdM9Uzjs1ksAFEWAfNrdfX1XLE?=
 =?us-ascii?Q?VxRz4aQmVz7WZuF7tBYcJKvDjLr8nNRl0QTYJKhWU8RGaps0P/2v0R1B49Zp?=
 =?us-ascii?Q?ja35YkkUhZdRY/3HFhu6XJYL38ZRtlfne0IRmIZE7jjB50psHQOksQWMnzUX?=
 =?us-ascii?Q?gUbrLfm0d9XnsAiKrvVNFCAnI4sIW2WnY8+pZ3vM50AlDBsefEJJuWv/wSX2?=
 =?us-ascii?Q?Nc85rouZhsF1zE2mIwncDPXJprD7hkZa7ozPUth7tNYyAtSbNuW5/sA7Epym?=
 =?us-ascii?Q?KqIcuI8vFbo3A7KdM8ezj/4p1hdod02yvcS17MGRu9vWecw+GzOXRkvmz02G?=
 =?us-ascii?Q?dcnkmQ3VQs9YyR7Ymp13gu1IZEEYgrCnGmnjDKPk/faAAclXkqxOmL5VULZ/?=
 =?us-ascii?Q?dSRprLodBkPrUw1YyO4Dwfl+CA/7mCwGCcvNnkHiZJw0gT6vQzOrXhXX5/Nk?=
 =?us-ascii?Q?MV38EbbS+HmGLm6JfwebIdjQXITjiOP+/aWvL27Z/jfLkG6m1pAkF4jVDgcT?=
 =?us-ascii?Q?0WYLykv7aiKrEeR8C2kk7hg+b/D0F0A/eLO1H0gjbOhBCg+vjMGeyo3lmbBw?=
 =?us-ascii?Q?ClVuI74rM7iir8mSoICqV8+mV2MYeirE41n/nCe1dqUL86+0HdI3r2/Yvnbe?=
 =?us-ascii?Q?rwPMglwKUmRSrMCO2gWmJI+00M7nP2BCWZxaFTKQ0KYxOeioGoqoDWvXTq9q?=
 =?us-ascii?Q?BvfB+4wuLjupHUj1sie5JzUtBMiiHH7s0b1DAEVm4YLT1eP9fc4aKMVtwrXp?=
 =?us-ascii?Q?0AP8TsK/oj6WPdhieVGD7xq4uFeoU+L8YIeUVgIxF7NSg5jiB8Y7nEO44uK2?=
 =?us-ascii?Q?ts5BV7Hy/jW46fiKMMs8K/+HenCvL+tMzxA/KhwGpJTEvZIGfxJZDRvCGutP?=
 =?us-ascii?Q?yqH0mmrgODf7djwf1ew5C8MSERkGkQym4GzIQ7OLJrAtDVUZmJNOf5zsE8Lh?=
 =?us-ascii?Q?ufXcN8y8qZ5Vw2uiWlEyESIdBpe29ofWSOheqZ4k/yOls3mvLO+IP+ed82EK?=
 =?us-ascii?Q?XA37BN/4/nOrnSV3Oj4u4oi6ymgFT8Q2owqMcfHUWPQVEHOQS5FL1hJ2n+4I?=
 =?us-ascii?Q?g9QfNbUVTW2fUTfd8S+BgG7D27LXlMV8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AVEgIw80xD82tEuSovUKmWcKYs3dDI1a/fafwoV7xvxYkT7qVjBRxYcgTPg2?=
 =?us-ascii?Q?N5RIlWQT+d0jnzmDRju1inUbcBtWsMwsK+UWHH/VzdPYxzkzsf/U5N3GMkoT?=
 =?us-ascii?Q?Otdu7otibql2IGKDrD/+Yp1IyNuBJdhKQrdGN2A4ICYksJDmBXSv+Shzm44x?=
 =?us-ascii?Q?xqEnqpSBo9i9/dg2AAD1HkAutOHoSyCKvmr3pxe6X8OmC9vn3tupIRLFYmqr?=
 =?us-ascii?Q?8Wye4IeYAyQ/fKTLZdDxVfoQcM4y6yy1YcC4rfykmrYeaAWpxRSGEqP/P3U4?=
 =?us-ascii?Q?3mLihFQaMOwdil9qSZi3Y2CykbbSsPGh7BAqGhQPPeiDIcJxmvdSDxtZ7UiK?=
 =?us-ascii?Q?BMbn32HjUhY5oy9TCMZo8lV/HW4vvStQluvdhLWeU2QWKV8pUYrF62Cb51VC?=
 =?us-ascii?Q?ghFSkR6c7Epry4hdzQEqQY6lIJ9lInMTuE3sA0iIwNC+DJE1EOlbZoIPVV6W?=
 =?us-ascii?Q?InuMm/J12DH4iF1cyzJW3QpComoHzwupye8cO7wbb5GKKqE3bqUAMWVVr9Fc?=
 =?us-ascii?Q?kfYKDn5F1CHvkiWx3EDD7D2HooZ2NrtrCcXGiKGPjAy1+Hta8FWyGJaiRkyB?=
 =?us-ascii?Q?UYHa84pwtfYBavRzBrzhASSOVVbccUeMGrEYR3b+QdsOcEsksLXDSlnZLR1r?=
 =?us-ascii?Q?q7zH08L/BvOlwGKgc6f8aI5tP1L6IJk6NCgNoLikc/v82963WOC26okGd0Ei?=
 =?us-ascii?Q?35GUVkgVby3ApGvrW0lHU4Ym2nJJ5r560BANkaRonGorfA8cRzyEewGyKXHc?=
 =?us-ascii?Q?eGGh16v/27yjBi/2TxkZ6+RETCyHbbRSjLnYpC55Qflpic69AQVNahriSmqy?=
 =?us-ascii?Q?6FZoOl1RjMyxyfPlo1+8RMKNmnJ+Qv0Lv7YEJ18CzA3zSGDNWeeCVDm0JrBD?=
 =?us-ascii?Q?SMmpTtICMdqKAc50oU1Ja+sN69ncn/7LHZIQf5Jqn6nweWKn9W2zh3yWhP/A?=
 =?us-ascii?Q?8nuRaKTiH7SxXtUiXO2JlcaEt7fLu1pahPBtCheVItjWHFCY4Uiey19H09WQ?=
 =?us-ascii?Q?ioNzLDp6PTMmqoPQ4ZKlHX9OhAgw66NbGXQQUdZvdarQAyyvoSMSDSxfTR02?=
 =?us-ascii?Q?Az1XENVUBHuHGdYF9Uypv+T6nH0g8Qq6LCsGY0hqALSg1EKw45o0/6td0xxG?=
 =?us-ascii?Q?grDIfYAjrMBYhfUQT83JY/9QgNlpybLyYoiWJPr6qBWgN6A4cBJFIG6EJymc?=
 =?us-ascii?Q?R32CAs6pPITeDfo52zVfO7d5NMMt+PB+4AVFc2MSrfzhegIYRgFx6M3QUt9Z?=
 =?us-ascii?Q?jXWvvU1MNM6A5u+PpYD3PT8UV44LGW3ibFzSnDySX5sonNj7pj17p3oudWSM?=
 =?us-ascii?Q?vnfgr32XftfKdXakv7GIMkWtrMFUhq0WV9P6Gff0taFlFYaVfBsvWqi/x3ma?=
 =?us-ascii?Q?tVt/B7+UChgFMxYEiLKYdREp2HDLaRHXH+FW9svYqOVdLjn7WgW4zdQ3V7Yn?=
 =?us-ascii?Q?mh5TdGhCUiORrN1ciV+7ddkixZdu3Brbe1g59pAvRfVpGw7ZiFvFlt7fwfd+?=
 =?us-ascii?Q?wj3nqww0Om4V8hNaLXJLe8itB7nk8GtNHMo7SCKQ6tnfUs3ieXc4H1vr042D?=
 =?us-ascii?Q?8RPl0nHHK9FNW5yVSQEPr4K4BVU5+XsSGq3QXgwESQTEZDALTMbcSJgmn3lm?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YMyDBvB4srOJJ0O25luOnZ/qSGX4exxnHDKs/a4/U7d/JubHB9fT7MzXYDoCUeXWr49OgWGmoGyxtDSu8JgfBeqi9813MNpDKODBFCLW4haT0W1AeoxByPCEhIUzN1S88ie55XJvWN8Aeq0/F+zYFV2mfMmwHCoAnRNM8KQAzXlvCn2j4LgXTTJDGSCmJLwAVce7kj274LTz6cR98oRurM1sifPDcBXBhQvCJC/fBmFDRycV9buRXtg1Bj5JWRq1Bxk27j3MtphrFnCi1LPHMAYcbNzs/w2YOz25Wa0dIO95B1ZSPexlMCsw2Dvrbn9AaQwC1bDOhID8/jXknYB19YtXEg7pI66/k0io9qcDkwnDESqqtnMyocwmbUGrnJ6vQ8EZfgNVSFnQTrFCdkhDCUhScXR49ycUWYafFprFzlhGpapQIHbcmPcF0N9ary6fSSqXKgrDBDcqj8SuVDQa3R6Ghvgj4z6Z9KGmnBSxR2jtpPSDiRv0T1gLH5bmwsBoyYYxpjeaRwiy+xVXruy7gyANZPZ/F1dNv0/dXZBhdDIBOlAMVH97eLcoDewryKjdcRxQEWGgCBrbRpMEkij54GTA7csuLx6tYTo6VHVy5i0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a21fd1-bbdb-40fe-97f7-08de3bce20b6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 11:36:03.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYtDX4mQSwP2QR/4elWmnCMRNtwh8ivIEVR+GDohc7UwFJchQo9uDa1ZMtkVTFc3Ka2cbh6CpIgiiCc6G9zSDFr0Ko8sYOHn2/FE1nQ/ZYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_02,2025-12-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150099
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=693ff2a8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=MlbuCJ_8RV0uDKMv2MgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: I8ku0T6T3Q1QK-eSA-hNr7zYBMnuFpMg
X-Proofpoint-GUID: I8ku0T6T3Q1QK-eSA-hNr7zYBMnuFpMg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDEwMCBTYWx0ZWRfXxQ4268WoL0yx
 A4/eEtjYCCP1v2dTDsZum5+wCZiWUq9QVd3IbHIMTXkumbsC7xI0VJPLIDP4puzH35Vm0GCzG5L
 zm4pd3tViok99uV/23aQk963o30fubcxvy2XBnUcdgB7mRnrPTmqJvh9T4GvNR8WaMVFmFycK+n
 vaPmhVAT/JROxgCj+78EL1uDzo61BlYAy1+IUqj94bzKUsaa8960nVioGR0shHke9Lm013AnTRP
 8Eb13yGwccm1JPIxp3bcf3qjrp5rjkdb1TnymWKi3MDyVo3NWBLl9GvUYUaQgPDEZrWXt1DN+rR
 JrRC0OD+H1GFssLALwpKpxTUpm6IvzwLH/fyk4CcxU/Tebgad9H+7kS6E+KxamdP+pN5utti/EF
 xqd2ZSi0DZTNgzLnFTjevQSUeaitAw==
X-Stat-Signature: 5ztjdsquwt79yt1y4hci6j5h7c5zcxjy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51923C0002
X-Rspam-User: 
X-HE-Tag: 1765798585-590132
X-HE-Meta: U2FsdGVkX18tk609d0HmGG34H83V6roFiOFT5i+f/M0abKO2gh1DBRvKcuCMMcp5r4FyODyhQMleUxkKMBBJ2fLjCTrONg+scXfzJKgWaVBYKD11hVWeKW4dBpoVfJ0qIRIRRTUtpsEsEGXB+VGtkHNETsdc5j0pt+A/RDq1iI78HrIX5gB4fkDEjKyzMPhBENwNG1i98iRbqduL02qeSUx+NgTY8qaUcpdCm+9/WtTIAGgOLGli8mB0iFF9Hcn1i0i3AjRYwACQzPv8GMw6xuE2KE3dlZpmFBdYvy0cVo+lZ9tfVvQ/Smawdjw1Y6CVx355AgPwK9wKTXGRTQdcmuBp04rfU55OIMw6ZdCrBhY0qcJcR9mDidhOuJ4JPqHSq5Zayf9mt4Q9AcD9HUef+PUt251XC91QIriP87bSJ/hqqrKmgnj7UpTjJ047CKWYSOQOP1q6qPtiJ8cYylQmyS5VuF6lKndsm0TOpLkS5WJnOA3+AJJxn5LxhSN93C3UQ5pJDyRN92K0+bxaTS0YZOeBTK4yR8KDGXwEvV31W4Zf00m+DAiQQNjNyudRo8pRYvaeG3YNj704NID4lccJx6n/2wGbMZln2Pk9p5WnUyWV2yJuJ2hT3Ts86dXxsI9i/jvRUdB6/3JoNGEsAb2q59Ocw/xy/YjkV+Y2wM/VRJUdOQai6ApexDKnPGFqGUsnhXuCJ3l6OyHr8Q9LAeyBKG/hKyxtRf3rwuz9J4h0eSxz7L6cb+QHnbk45lC+mC4VpTTsIsgVU4CAZnILb5zIvmuj/A57vHcNoPgo6VjHNpiMJoN/GVL7PWfyFuj/kBMn4U1JM6H2Z/RyG9kopv+oqDF93KIC5hQe4Cs9/xdfwJIwYTUQHzzC0hciV71aex59UpZiY+PuVCEO5Gq8qpBLig4RooV4P76kv9HBkUjyuoPiQkzFkUJZm53Wh7yvNS5ZAnsNOU3jthILoE2UXmB
 1gnd7xZM
 Oj4hwEy41ZzQQxuV/mNRksSfIYnHGB3z6iIJmBkAls/9NVLckvsbF88eJm4fcfBWoao5V/OAG7PB+mSdPFZzhbSvU01LyT4M3xoKFRY/dgSo9M5sybJ9nzlqNQVi1YmUoYhzPfv2fnngJCoCvnkFPlaOFwKgYIopja5VAF7oXqgo1XVKM8lM7OK/0yAK2KEt6qkaO3YDV/EiznQHWPAILEcQxnT+CXWffrVYZi3ZtUf98MDR5bo24oIFUgKf1FXG1pdF01ZoGhRtsXujqyj23P5BHoQ9fGg2kRsj0ye3Uqtf2+GG766BMcAz9KC6d4amkAuMPxZ/67CVs7hLS9WTKoKxsWT/Qex3YDhUjmmJHo4RDziwL1edPyNotSM7s40h0mMWdEJ59GQnpCh/M8CIW1JHADaw1Wf8S1uczVvEOg+YzSxwNveWfCp41B1gHGeJpTvF4820iKdVXgZ47SgQPOa12csH29ThZ8nEpk395pqHtxL+vO8QkcCWODKU3c1FCQfUYfaoeBpN8uF/AEEQNJItQsYioz8sV4PpGuF0KROKw/aGCv5zEaHtx2KZBHykrvfbNr2fM0bqTZfAWuDdm6CSToGw212DDbahFbxR+HoICYZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 04:16:54PM +0800, Baolin Wang wrote:
> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
> only clear the young flag and flush TLBs for PTEs within the contiguous range.
> To support batch PTE operations for other sized large folios in the following
> patches, adding a new parameter to specify the number of PTEs.
>
> While we are at it, rename the functions to maintain consistency with other
> contpte_*() functions.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 12 ++++-----
>  arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>  2 files changed, 37 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 0944e296dd4a..e03034683156 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>  extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep,
>  				unsigned int nr, int full);
> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);
> +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);

In core mm at least, as a convention, we strip 'extern' from header declarations
as we go as they're not necessary.

I wonder about this naming convention also. The contpte_xxx_() prefix
obviously implies we are operating upon PTEs in the contiguous range, now
we are doing something... different and 'nr' is a bit vague.

Is it the nr of contiguous ranges? Well in reality it's nr_pages right? But
now we're not saying they're necessarily contiguous in the sense of contpte...

I wonder whether we'd be better off introducing a new function that
explicitly has 'batch' or 'batched' in the name, and have the usual
contpte_***() stuff and callers that need batching using a new underlying helper?

Obviously I defer to Ryan on all this, just my thoughts...

>  extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, unsigned int nr);
>  extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_test_and_clear_young(vma, addr, ptep);
>
> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>  }
>
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
> @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_clear_flush_young(vma, addr, ptep);
>
> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>  }
>
>  #define wrprotect_ptes wrprotect_ptes
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index c0557945939c..19b122441be3 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  }
>  EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>
> -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> -					unsigned long addr, pte_t *ptep)
> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +					unsigned long addr, pte_t *ptep,
> +					unsigned int nr)
>  {
>  	/*
>  	 * ptep_clear_flush_young() technically requires us to clear the access
> @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	 * having to unfold.
>  	 */

Hmm shouldn't you need to update this comment now 'nr' is a thing? E.g.:

"And since we only create a contig range when the range is covered by a single
folio, we can get away with clearing young for the whole contig range here, so
we avoid having to unfold."

However now you're allowing for large folios that are not contpte?

Overall feeling pretty iffy about implementing this this way.

>
> +	unsigned long start = addr;
> +	unsigned long end = start + nr * PAGE_SIZE;

So now [addr, addr + nr * PAGE_SIZE) must for sure be within a single PTE
table?

>  	int young = 0;
>  	int i;
>
> -	ptep = contpte_align_down(ptep);
> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> +	if (pte_cont(__ptep_get(ptep + nr - 1)))
> +		end = ALIGN(end, CONT_PTE_SIZE);

OK so I guess for PTE_CONT to be set, it must be aligned to CONT_PTE_SIZE,
with other PTE entries present there not having PTE_CONT set (Ryan - do
correct me if I'm wrong!)

I guess then no worry about running off the end of the PTE table here.

I wonder about using pte_cont_addr_end() here, but I guess you are not
intending to limit to a range here but rather capture the entire contpte
range of the end.

I don't love that now a function prefixed with contpte_... can have a
condition where part of the input range is _not_ a contpte entry, or is
specified partially...


>
> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
> +	if (pte_cont(__ptep_get(ptep))) {
> +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
> +		ptep = contpte_align_down(ptep);
> +	}
> +
> +	nr = (end - start) / PAGE_SIZE;

Hm don't love this reuse of input param.

> +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
> +		young |= __ptep_test_and_clear_young(vma, start, ptep);

Again, overall find it a bit iffy that we are essentially overloading the
code with non-contpte behaviour.

>
>  	return young;
>  }
> -EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
> +EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
>
> -int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> -					unsigned long addr, pte_t *ptep)
> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep,
> +				unsigned int nr)
>  {
>  	int young;
>
> -	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
> +	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>
>  	if (young) {
> +		unsigned long start = addr;
> +		unsigned long end = start + nr * PAGE_SIZE;
> +
> +		if (pte_cont(__ptep_get(ptep + nr - 1)))
> +			end = ALIGN(end, CONT_PTE_SIZE);
> +
> +		if (pte_cont(__ptep_get(ptep)))
> +			start = ALIGN_DOWN(start, CONT_PTE_SIZE);
> +
>  		/*
>  		 * See comment in __ptep_clear_flush_young(); same rationale for
>  		 * eliding the trailing DSB applies here.
>  		 */
> -		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> -		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
> +		__flush_tlb_range_nosync(vma->vm_mm, start, end,
>  					 PAGE_SIZE, true, 3);

Similar comments to above.

Am curious as to Ryan's opinion.

>  	}
>
>  	return young;
>  }
> -EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
> +EXPORT_SYMBOL_GPL(contpte_clear_flush_young_ptes);
>
>  void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  					pte_t *ptep, unsigned int nr)
> --
> 2.47.3
>

