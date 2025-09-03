Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11A9CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 20:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3E7B8E0002; Wed,  3 Sep 2025 16:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE818E0001; Wed,  3 Sep 2025 16:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90298E0002; Wed,  3 Sep 2025 16:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2BD8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:34:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EC501392A5
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:34:58 +0000 (UTC)
X-FDA: 83849093076.23.46C6094
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2164180011
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:34:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L32V0laf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FSk4KGv1;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756931694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XaMCEe3wCZwncDo4L05goThNVhMc/Gb3VfVAscmtHro=;
	b=Z9VzGpZqyCGfbkN4h9dvnras5C350anS96MqUiuVEHLpOTLKLdR5toiWIKAJJqG2LbZ53H
	SY5C1K9QljuzhORq3MaEnfDltYILtbErbCX/fO00AV9gDc3z5RdzyQHj2cQLc62rO8w8Oh
	t+zQVeyrfRLkTKzfEx2EyvDsY16DOa4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L32V0laf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FSk4KGv1;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756931694; a=rsa-sha256;
	cv=pass;
	b=OkOUMsEDGZGdjYt4PxVD8yHu0+mpoMJ7Rg+UdhAzjKnwRwzQdMFN3Nf05QhjVWOs9J+Lrn
	c7ApUSBxxsaBJa4jj0YzJC3g6aKJC+q6cqIganlgRa/LeMI+9T2tfvXNyQDcqM4GOMCO9D
	3Ras6pYJaTjP6Jay3L90wgeSsLcZdsU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583JtxDj025183;
	Wed, 3 Sep 2025 20:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XaMCEe3wCZwncDo4L0
	5goThNVhMc/Gb3VfVAscmtHro=; b=L32V0lafhzBeAUv0q65TrB9SqmSGTndjkN
	yA19+rSOR7WNp2Y4BnrnKSze2dEDal/5YSCx0dt/m51l5IdDsbuPHTHzi+fF0k1g
	p+4zrTRTaripsVIpwlhOCyNOn5nvib/hO/1dX/o6/T9HXsy21NIAPVWJ5dZp35AC
	c5LRy89e86OyV4LtFxGNAG11/AWeKf8O+BqTCq6LcbNobdEhBfxCisqZqZpyTWYX
	sYJUJDuwaKkgMAp3BoIssZbT8n8PZGGRmGWg1r1j/PuRhtUwADL6JnUoZjOhS8k0
	XcpL9c7pGxTzFH6VULiM5CNZuJGg2yUXFttnvWhZCRYFqjOTtZDw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48xugvg5sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 20:34:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583JKBZO040850;
	Wed, 3 Sep 2025 20:34:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrahmpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 20:34:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3NTkEqlc36Brtiqg2eVHIr09dx4qYAZm80T03MByzZcB/D0/1/Mjnn7N3hPryNC8Gp7Ar09HKhjm8zmZPjtrhDr8W14WT6Jr1n30N/vUIRD+uFQ0eoCWnOY8Q2ZancRaE3fHk3RkIA31hNkqWx7HAZAjB8HqGB8O2+LXaLTE7nlOsSCS9VPEak1Ukb+5fe/A46IVRzdrTlm8EKabY02dhQzUopragNU+3VLmVwd6gllTtvdDxjUQqRpDxjYWveV6G/eMdr9eor5jknCtKXgeJj8xxEBEYFpZBbSn0PyaLCgVGFf5EkbTnK18YOXKfGKYlgtR+xO4Ml3xWIGwryVxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaMCEe3wCZwncDo4L05goThNVhMc/Gb3VfVAscmtHro=;
 b=Ud0I1x11tjIyFDCg3FwLw29JfiBk12F463aAIKa5aLzy1BbpsKkpJf30nMudTPhUDRdXSKpLAxhNHBn7e8APRHvRBu0tw6iBH3JJqbykL34UZ/AnO2x5u1zZo71wKooEksJhUzEkJt69498wK+WXHzecH2WcajGWWWOuN2XdUkNSThraJbNCNqw5LZhVCjlZi5qx8BGwg44matw1u6nMfq1Xwmpdt1Q5HL5cu++MYsQRSB4caKh5voejf7ZSkWtNyGDnYekj0+awR4TSrUfdgpUbAx0KYEhsQEJM83JxCOIubzo7GDgMPwI7oDBeUKoQHUTwGXCz4nTxghjslqgQZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaMCEe3wCZwncDo4L05goThNVhMc/Gb3VfVAscmtHro=;
 b=FSk4KGv1z3DAyYALoWkdSHH+KpTG8Ivn0qgObG0UC8xXi6A6oetzZ9EPonaAgPLjUuiz72P7ccSmIaHBJ/V0rKQ1H0wLkpGC+w78JkhzQwwQP9Yj9uMQmkIwn9JNjKNfT3oEFMPSEEnOyzyzgKXLBH39wtnNFM08dqIgE6UVkvU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF334FD9217.namprd10.prod.outlook.com (2603:10b6:f:fc00::c19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.29; Wed, 3 Sep
 2025 20:34:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 20:34:40 +0000
Date: Wed, 3 Sep 2025 21:34:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org,
        willy@infradead.org, hughd@google.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local>
References: <20250903054635.19949-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903054635.19949-1-dev.jain@arm.com>
X-ClientProxiedBy: LO2P265CA0237.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF334FD9217:EE_
X-MS-Office365-Filtering-Correlation-Id: 128424ca-4187-4e12-06dd-08ddeb294e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aU9w4IQ001DEwvZddj+qTt3UPodxjaytBxsMWDpCwyVxgti6iWvmghqoW/ga?=
 =?us-ascii?Q?dLMNCn3TN46jfwuU2YmY02Z3LKz4lSTfguneUyRrDsBK78HqpduvzhwUeJbv?=
 =?us-ascii?Q?pVRWKBUU2Qt+QK18xAdSBzfo71YpWpiQbQl7yr+A4KhccIlnqBwtZkb0uGdl?=
 =?us-ascii?Q?JSbOMybPE8/S1uIKiHHRiTIGUMnQPu6S7Z2UGKadCLT8Bafg8rclWwrOK1zX?=
 =?us-ascii?Q?a31pLdB/U5lnBocvDk8DmfAm/M/+K0wiDDZDR3rLRr2k5cl1kMHFyfL6LVah?=
 =?us-ascii?Q?BT9Rh0wn+0HmZQPXpW9kXQPWwiw/efaLUUTOuI2o5hfH8BmB8v+P2aK9eMjN?=
 =?us-ascii?Q?OKb0NlPldIoWS7QumftSC4fYoFN4PI6wW0ZdVTnniWMz1Em2ON91KhpGPajP?=
 =?us-ascii?Q?WcueaCCZAJ9pmWVqpkcFBrDbThmbYHDU1p4DfqWO6EHxR9fniyCvW/v7Rqu/?=
 =?us-ascii?Q?3UQ5XhmR1dBcFy5JhUoKmkGNFEOh0tGS/ify1IF/85M+0rmWd7+W2+a6Ub9G?=
 =?us-ascii?Q?zLzHP27mdA62RPBD19TNzeMDms5aFRVJj6Sp+efbjtFIEtciROsnasw70Z7R?=
 =?us-ascii?Q?ZNbsTH8rvjSr812h5uJ/Mus7vCQfEcC/HJcJ6dqpww8dv/7sZDAfhpYwWSOd?=
 =?us-ascii?Q?ATqOMxsdicrU7U1wjsO0dYn48rU8O0lpbTcGMieSEdk4MIbBZKSbxxPt3Oa4?=
 =?us-ascii?Q?m14Cc+KnI9uWUEEQf0JY/QfLhed8NHNUk0sD7A4/N2TmievoPVPxqvMD7BvT?=
 =?us-ascii?Q?BIdwLqY16bFgDg5l6etqlKfUjEegH7qp+Z6BG7YCICo54RIwgudA25ObOllW?=
 =?us-ascii?Q?M/ogF1YZnIo6B5WqZDgmyHJfN5hAIt1sx9uyoMwuKa7bb5Mzj2Zk+Ck1MClS?=
 =?us-ascii?Q?Y0q4AgIt4Hjuqt30mKbhwc8lb/XF8Gof39djMA5/DW7jBj6bKnJvHp7tNpiR?=
 =?us-ascii?Q?Sr3/3BwqmcTmshegxx3OkjN12H5o2ZGTKHqUSwNdeCu2WKIu7hgGkg3LhkmP?=
 =?us-ascii?Q?cu8H4ZBpmXYbpGkdiqY9GhDKo1xi3U5sgYISHT3VI5YLH3F+WpbyQ728MKjF?=
 =?us-ascii?Q?qGD3+s0NwuxIW+CHfWPck1pFIGyziTXUx5koZcdFJRwnp4JIAnKjRg2M3wPf?=
 =?us-ascii?Q?vm9BsV6B0uvkbem3rMzo05y7NOAjv+F1VtjkAouvWysRh0dwNuzJ4TsxcA0F?=
 =?us-ascii?Q?buE2diFiWs2U7c3lL3fgDtRgmTRsauooFn0uYzN0hLemLwk8/2fc7Jf2xaYr?=
 =?us-ascii?Q?YaeMxe2eXZC0i3Fj779DqL9eitmHullyMXImi8yrBij99KyI4vBboCWkRR0t?=
 =?us-ascii?Q?90vWmV71p3IcEeudPB3OH8o94Zp1iRlcV/HdRoh71/9KFgy+ilkwj/Dbj7wo?=
 =?us-ascii?Q?DQoRr7H3jxxbhQ2JiTWhHHU35WV8ire6EqpJPlaJbMW5DzDKg8zfAyDnQSdD?=
 =?us-ascii?Q?67cUeCCvIEI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O0yYpUlYWEGTUjM8CeWqw1jUdCZ7paVP+B5iPhpGJAXbxf9kaHKs8oVUsYgv?=
 =?us-ascii?Q?jv/QAjNMNqq57fXO93O/7WO9Bc8IljkK38QxVcfmn1xgO8Zi1/aMIZq5MBMQ?=
 =?us-ascii?Q?7osU0YrpEX4EMOdp6fVxV9gxkFD1RSz1ABfA0HU8/QcD3TJDSm+Q8748+0Wz?=
 =?us-ascii?Q?krCvvCamqSpYIKBJKUXF31rb8TKmEQRgWu4knTxH25GxC5I7jU8iEG4m+721?=
 =?us-ascii?Q?FYXLIUQNTYnnZrFSGWnc23lAjvrWUCNbniTQWATUV+uBdMIGmzUIcOxSCKI2?=
 =?us-ascii?Q?GSqRhaLmzXjdfBBFYaaB8jmdQFjUtQ5+jPO9ApyJhG6sEeF772el02NdV5eU?=
 =?us-ascii?Q?ViaL+ulExUpa3bzt6GYc38nin8hek9odcqVrHfk8/Ik4QDoGS2R4//wtPuzS?=
 =?us-ascii?Q?SAyTWFTJi78zPZl/kLuESTllDMMH7C/GLjCkvQ2Jxrue45A/r1BNLxMPJmjO?=
 =?us-ascii?Q?w6L3swsQR8O3LWGeECKuX1YA6b20QCn6q7y43ycdzAxdaLHn/txcIvfxog0T?=
 =?us-ascii?Q?/lroyO28fsLd31DOgB/CAvAJYpJDbG46US1AKB6JLA29B2mpCqOcfE0iqs1c?=
 =?us-ascii?Q?xUnFg0JY7Zn7fO8v3xNTx7i4NZQ/7BLtw+q54SsZt5PP3vMzl/oeLA9fg7jY?=
 =?us-ascii?Q?HYa01nK/VIop1WEg1vu4kxFfVIlSTvjCaHKSn91riB5i1O2BfMZUHeGE9c/p?=
 =?us-ascii?Q?M5keHat0+wM92ssceC5UmEnJ75SiKn2FGcIKtMrHUEVptVshmeVKJ8Lcidl9?=
 =?us-ascii?Q?WS4zTf3rj7qC09eA293MG+b5F0jL+caNquUkXSPulP8pELVFu0d7NxExek/Y?=
 =?us-ascii?Q?B6UPEEzAKnwg5lGN2TNFciiWVeGdSZmyCNZVc5n9dfArzj7GsMlZHI2NUU4b?=
 =?us-ascii?Q?uQaiI4sQg+EU9DPUUXvNub7gpxxG7bSq1TiuPu30r9Fs+Z/lEJ7DllMRXGm3?=
 =?us-ascii?Q?rXidAwiNH+FDQRbkoLB1BVYFlzhZPkonkKyhTLomjEtySNbja5twxNavV6Op?=
 =?us-ascii?Q?kS9DS1Qq81bfkId8s1ud3OQQ3iX8vG2MsUAQNy5QvP7ucwnWCF7zE5E0slrV?=
 =?us-ascii?Q?UlR4TVQ5Vg6exzAl9hp4hsR0Qrfd985wduKLl/Cb5fEe7CnJTW+9bacaNStv?=
 =?us-ascii?Q?0ooBSzIyZbsKlJwHs5r+Ty+bBGsyu0qdnYTcfS24vwVk6mgwZTbVeB48sItl?=
 =?us-ascii?Q?zC/ufqzGygQ6umIbk9oy4sL6Z1RFwg7dLe8IN+Y0sIyTJSBqafzv2IrBNboL?=
 =?us-ascii?Q?V/uHqHdmJIUH/1wanD2Gv/eT06shsegT1KneNazjUerj24u8JWoLO820EMh6?=
 =?us-ascii?Q?eqyM0IDJeL02veMSADnA6UCK42gPMq+m+lZRVF7gCsvqnyVBSA4seoPd7AvA?=
 =?us-ascii?Q?UX3SGEmonkKgLDp5Vagx3YiQ3cyGw8kAEHTyBSH5LGxWVC2z03MispBM/0Gp?=
 =?us-ascii?Q?M3xhql+Ylhez/DtWC6aiVAldX6nb2hQn2XeydEs7Wf1SYXYTRuEXFNfX5mNX?=
 =?us-ascii?Q?lR1U7amXBWvRLxL9Nq/ost7yJNQ2XSel8iqBqkoxUYUVnCeakThNWrlZmgj1?=
 =?us-ascii?Q?zywgNzSncx2jXHd82Z0yxMoVWGHc4+p/XAfk8yyMEmz6YNQuy4DBCP0LCRtQ?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TsgQXIuyLxJjiM8Nnm60XBPVsKuRU1tgWFd6790m5uHDLRLT2vbPqCU6A6lLeWDPY9VWSOtnE8pp3EzGtojTaA9CIDonm48Xpwcr/KIGeZJ2Pu2sAgbvSbsLWi3mu6bth7DdvsBaQ7fVLgphx3xpX+h38s3UWCLdh5IKALWZN6oW8K0AxuvKamQJCothljENhdSwokRdx7SX91K090DKuartwIQPaRMuIAp9p49q53xKxC3Rc7rd04SjW34Hgm0XHNSsD2yf1l8tvthw6nhA2CF8e69REL0acI/cg3nc7TTlKKabDLzjU9bmTZhyaoYNWFsi07wU1vzNPbOOeDgr6V6jGORBk48xNww0lplc/UEgKc3NeMm/ZutV3i5st95Bny80gcB9acSHYHGaQLQga8bPZ9BQHWgo6HNIMG5L+4H73RYvj+aSaKoawCy72FWQJ++WunVffq75vKBE3/5eJdq98joO4noikP5DYBL/QnChidRNmTfaYPsyqDFORWYT6kGP4lZ6D1kvN1pRZnkNo9AnD76Yj/hXhK5HYb9jnnhztrhtnoRht/Q1Yvt2WWJGeBmBkOBC3ToemuZdQKt1gb3wBN71XeQNbOpLCQYYGMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128424ca-4187-4e12-06dd-08ddeb294e77
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 20:34:40.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: byBsRhrlEcgT8BMdg5mMiqDcDf2QKo2SJ/C5ItkMWy54artwI0SYU7hway4Cs9v5BE0ai8RgWghPNsVdHZz6VQSPqXjARmM+I/TXARqhotU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF334FD9217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509030207
X-Authority-Analysis: v=2.4 cv=b72y4sGx c=1 sm=1 tr=0 ts=68b8a663 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=yPCof4ZbAAAA:8 a=81jHosEuAXAGsmLoZGgA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: P1GltoMJ4TsYe_rQMxnmbYswot_7zJpS
X-Proofpoint-ORIG-GUID: P1GltoMJ4TsYe_rQMxnmbYswot_7zJpS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDE5MiBTYWx0ZWRfX4xcepTMPoPr7
 R/nso/Vej3OkrWU+SMmxetzQrRHpEQv5Qc2tVL9Q4xN6SefRcLAuy1MnOY6VTVexuoyux5rRZRX
 uY6nTBvEfDO/IkZBWurEK+LxkqBqcxMB5hZj2qm9ZTg9jV9jJlhg74ZF7qmeDhILEWgqACpsRti
 Dd0ZNFiSwNEm3i6MHyUONvL0UPbutPwQdw01aDSQNHP47/BMZjIpgWJpN6XOOxYHTGtriqBAiqK
 t/5yZcPMlQCSRSa+/SpNN0JlPcluWADiWOFhEemc6lb35rh86y6VXwhVoG86Nmo+uUXbm3Iq/nd
 OKn0EloTQhHFTsz8CbeRaYYWj2ZkGZTf/3M/dL7enGn7kce8gLA+r8Lhj9GjzIri+mms2W22d5J
 WYqtp+lu
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A2164180011
X-Stat-Signature: o88351qhu3ekfdekxoda5ocpe7iqqxub
X-Rspam-User: 
X-HE-Tag: 1756931694-285372
X-HE-Meta: U2FsdGVkX1+PAq5mVXkse3Z4xKVbv6cHWuiNShcRD9gkD5+aa66QJu41RFpRVE9gCThaR5GvzNaS5alwYuFrAfA2d8zmEcoe8rzXVJQevBjPcEmtzyZgUflDu10T0CMwd3hBbdytq/4edmTtsLlqLmH+0I+78PfIZQFRd1g6xo9m81b2TM3vtpkidaN+BrRpY7WhhiWMB5FsCtdlWOb3ICwd9lR4lx0y0zXyWptadLQJWVycByvGUkgOP7kWXJudutJA19A3vUMQumcGp9sNGsE6xd6YWwB8+Sb2pgf/H7WpY1CPhH99V76Ro7bh2GyHoSeX5DdJWW8ONtzVsdIO+ROp2BTWTyWJtJ9V7ZBeK/mAw+W8AvmLg2KZXH6a3etcJ5bnZJ5ddq2NUazuv2Ttvx6HRKVRW6Ovfy1NttTsExlYovprK/RmQAXt5djqJfw1YUWTf48YZ4hqZT48zsBk17sscuHQshH99Y1v/PbBaUXJq8AyXFHJwOFaQGxdxtz+chsHVdKa846viZckJrVMwjiTz3bEVgRYuQa0i9ox4t1FauEbSntau0LpobPWoJUAqBk/NlVhIBK0xdwssy4rDDkKlvIGGQ6AJenrKn7JuYL40QBnAmsJXu8WEwRZAThjoyYsxZYUoT7Yh+Aluka3gLsI6hK4TXqkVllkQXLsEVX3Msb6ZXQC1Nbsk+BuwgIiVL8JGNOY6GlcnB6hfGw+DZh17FUSH21tWDA2NRT8Suc+na5R/ql7Eq0nznIVuih9NIEuRE6AdQamoAFRFPwHgOZ+Bi4cV3AER9m+iNwYd4neNvPL6WvJ57v0/wgQL/nJDnrakXZBGXmbfHZiIKzeD3oOMog4a0xcLuPzO1bqOLF86Fjay9uFfnw14usSoT5RVFbDsC4s4gKtuHDH4ABYDUkxgFATj7kE1Fgf+PDyhrswJ71VQ0qNk/qLx0mtnvbJ2gAgle+lqWhkAnoCRxH
 ZqlhLu7C
 9xcLQh23e5jKUUolJpcT1rWX4mnBM1nGJiDZnYnNfeYoBhgIlN4N7+nhAwmhUqoIGlWG3PJ5VtInPL4DgoslpEpkJmiefSXWkKdyplSnfgryIA/N3VO/D+weVecC4Rtm1pmb8Om6DBx1Vs8XKV0NzD401v6y6mO4UowfNv8tqqnysVPNILkYQ5jpkxyLY3VQmY/Ou3vAj2ZBnMlLVej1hcKboGCpXdaAs14FVcTyj9kHWt1mf8YD4rMnVzAdTmS57zqs+X/xXHr3OGspvQNakqJX0fEjDuzo0GmCl+K3OEzR9rBYg2Gkvd8PwsbWwmNRCrwkgbrDa8+F/llXVE/TA6WRaBBpi2vMWNgii78lbMuFIuW/xXjSdtJ7CqDSRdGZ9GodV4lJFL8VCLs0+RkWnu6cpB6fsKzFJGtMK7d8YGPgdyRRl3VVCzzQJZcLX5Hu9E4reo72DV8o/+Qy0AaLdPqK4y/8V9mOZETWsz6Yr4I1Lr/Yh+xmAucSYAQFKuuRdJzm88WtPHFvhSv6+WzYkU5rDKPKFaSDJFMDcGWbpkgVx2MvuuzEJXbd/bAV2dFuhEb09waDdxK5zRyAeO3JAVfSP3d1nAVvimvnHPX/+wa8e43UHFslUhi/jRs1zuutgiaiSvvIvoD6R6OxUpCdZS9dlOMe0q5t/TkXKMbGvdPXTVZRUYvs4ATdUAlE7quOpyHlHVNYnu9VOJfa5NHLFh49NybuYcDDBCbkMFDGrI6tjd1lmf9QHZ/HkB3CbfbpgBBPhvgRnvTZyZmRTXP8yMwLdeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
> Currently khugepaged does not collapse a region which does not have a
> single writable page. This is wasteful since non-writable VMAs mapped by

As discussed elsewhere in the thread, you really need to clarify that you
mean the PTE is writable. This is far too vague otherwise.

> the application won't benefit from THP collapse. Therefore, remove this
> restriction and allow khugepaged to collapse a VMA with arbitrary
> protections.

It's weird thie history of this, it looks like we were super conservative
at first, and then introduced this 'at least one PTE writable' thing in
commit 10359213d05a ("mm: incorporate read-only pages into transparent huge
pages"), but it doesn't really explain why you even need (at least) a
writable page.

Perhaps a pre-PAE thing... (David?) we already do the refcount stuff
though, so it's hard to understand.

It seems the main case for anon where it'd matter is swapped in pages
read-faulting for a R/W mapping (as read-faulting R/W mappings would just
get you the zero page which vm_normal_page() would exclude anyway).

But not sure why we'd be reticent to collapse those anyway... you'd just
cahnge R/W bit on PMD instead of PTE?

Yeah it's bizarre.

I can't really see why your change shouldn't be done...


>
> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
> non-writable VMA, and this restriction is nowhere to be found on the

> manpage - the restriction itself sounds wrong to me since the user knows

I'm not sure why a man page would talk about PTE scanning implementation
details?

But I guess as you say you're thinking specifically of a read-only VMA that
naturally has read-only PTE's as as result...

> the protection of the memory it has mapped, so collapsing read-only
> memory via madvise() should be a choice of the user which shouldn't
> be overriden by the kernel.

NIT: overriden -> overridden.

>
> On an arm64 machine, an average of 5% improvement is seen on some mmtests
> benchmarks, particularly hackbench, with a maximum improvement of 12%.

Nice!

Is this on a raw metal machine, or a VM? I thik it's important to clarify
details like this.

Please state precisely what you tested this on.

>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Can't find any problem with this, and doesn't really seem like it'd be
problematic so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> RFC->v1:
> Drop writable references from tracepoints
>
> RFC:
> https://lore.kernel.org/all/20250901074817.73012-1-dev.jain@arm.com/
>
> I can see performance improvements on mmtests run on an arm64 machine
> comparing with 6.17-rc2. (I) denotes statistically significant improvement,
> (R) denotes statistically significant regression (Please ignore the
> numbers in the middle column):

Let's drop the numbers in the middle column then please, this is going into the
commit log, let's not put extranous information there.

>
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> | mmtests/hackbench                  | process-pipes-1 (seconds)                                |                 0.145 |                   -0.06% |
> |                                    | process-pipes-4 (seconds)                                |                0.4335 |                   -0.27% |
> |                                    | process-pipes-7 (seconds)                                |                 0.823 |              (I) -12.13% |
> |                                    | process-pipes-12 (seconds)                               |    1.3538333333333334 |               (I) -5.32% |
> |                                    | process-pipes-21 (seconds)                               |    1.8971666666666664 |               (I) -2.87% |
> |                                    | process-pipes-30 (seconds)                               |    2.5023333333333335 |               (I) -3.39% |
> |                                    | process-pipes-48 (seconds)                               |                3.4305 |               (I) -5.65% |
> |                                    | process-pipes-79 (seconds)                               |     4.245833333333334 |               (I) -6.74% |
> |                                    | process-pipes-110 (seconds)                              |     5.114833333333333 |               (I) -6.26% |
> |                                    | process-pipes-141 (seconds)                              |                6.1885 |               (I) -4.99% |
> |                                    | process-pipes-172 (seconds)                              |     7.231833333333334 |               (I) -4.45% |
> |                                    | process-pipes-203 (seconds)                              |     8.393166666666668 |               (I) -3.65% |
> |                                    | process-pipes-234 (seconds)                              |     9.487499999999999 |               (I) -3.45% |
> |                                    | process-pipes-256 (seconds)                              |    10.316166666666666 |               (I) -3.47% |
> |                                    | process-sockets-1 (seconds)                              |                 0.289 |                    2.13% |
> |                                    | process-sockets-4 (seconds)                              |    0.7596666666666666 |                    1.02% |
> |                                    | process-sockets-7 (seconds)                              |    1.1663333333333334 |                   -0.26% |
> |                                    | process-sockets-12 (seconds)                             |    1.8641666666666665 |                   -1.24% |
> |                                    | process-sockets-21 (seconds)                             |    3.0773333333333333 |                    0.01% |
> |                                    | process-sockets-30 (seconds)                             |                4.2405 |                   -0.15% |
> |                                    | process-sockets-48 (seconds)                             |     6.459666666666666 |                    0.15% |
> |                                    | process-sockets-79 (seconds)                             |    10.156833333333333 |                    1.45% |
> |                                    | process-sockets-110 (seconds)                            |    14.317833333333333 |                   -1.64% |
> |                                    | process-sockets-141 (seconds)                            |               20.8735 |               (I) -4.27% |
> |                                    | process-sockets-172 (seconds)                            |    26.205333333333332 |                    0.30% |
> |                                    | process-sockets-203 (seconds)                            |    31.298000000000002 |                   -1.71% |
> |                                    | process-sockets-234 (seconds)                            |    36.104000000000006 |                   -1.94% |
> |                                    | process-sockets-256 (seconds)                            |     39.44016666666667 |                   -0.71% |
> |                                    | thread-pipes-1 (seconds)                                 |   0.17550000000000002 |                    0.66% |
> |                                    | thread-pipes-4 (seconds)                                 |   0.44716666666666666 |                    1.66% |
> |                                    | thread-pipes-7 (seconds)                                 |                0.7345 |                   -0.17% |
> |                                    | thread-pipes-12 (seconds)                                |     1.405833333333333 |               (I) -4.12% |
> |                                    | thread-pipes-21 (seconds)                                |    2.0113333333333334 |               (I) -2.13% |
> |                                    | thread-pipes-30 (seconds)                                |    2.6648333333333336 |               (I) -3.78% |
> |                                    | thread-pipes-48 (seconds)                                |    3.6341666666666668 |               (I) -5.77% |
> |                                    | thread-pipes-79 (seconds)                                |                4.4085 |               (I) -5.31% |
> |                                    | thread-pipes-110 (seconds)                               |     5.374666666666666 |               (I) -6.12% |
> |                                    | thread-pipes-141 (seconds)                               |     6.385666666666666 |               (I) -4.00% |
> |                                    | thread-pipes-172 (seconds)                               |     7.403000000000001 |               (I) -3.01% |
> |                                    | thread-pipes-203 (seconds)                               |     8.570333333333332 |               (I) -2.62% |
> |                                    | thread-pipes-234 (seconds)                               |     9.719166666666666 |               (I) -2.00% |
> |                                    | thread-pipes-256 (seconds)                               |    10.552833333333334 |               (I) -2.30% |
> |                                    | thread-sockets-1 (seconds)                               |                0.3065 |                (R) 2.39% |
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> | mmtests/sysbench-mutex             | sysbenchmutex-1 (usec)                                   |    194.38333333333333 |                   -0.02% |
> |                                    | sysbenchmutex-4 (usec)                                   |               200.875 |                   -0.02% |
> |                                    | sysbenchmutex-7 (usec)                                   |    201.23000000000002 |                    0.00% |
> |                                    | sysbenchmutex-12 (usec)                                  |    201.77666666666664 |                    0.12% |
> |                                    | sysbenchmutex-21 (usec)                                  |                203.03 |                   -0.40% |
> |                                    | sysbenchmutex-30 (usec)                                  |               203.285 |                    0.08% |
> |                                    | sysbenchmutex-48 (usec)                                  |    231.30000000000004 |                    2.59% |
> |                                    | sysbenchmutex-79 (usec)                                  |               362.075 |                   -0.80% |
> |                                    | sysbenchmutex-110 (usec)                                 |     516.8233333333334 |                   -3.87% |
> |                                    | sysbenchmutex-128 (usec)                                 |     593.3533333333334 |               (I) -4.46% |
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+

This is nice, but is clearly hugely exceeding the column width we should have in commit messages.

Let me use emacs's nice features to make life easy for you :) -

+-------------------------+--------------------------------+---------------+
| mmtests/hackbench       | process-pipes-1 (seconds)      |        -0.06% |
|                         | process-pipes-4 (seconds)      |        -0.27% |
|                         | process-pipes-7 (seconds)      |   (I) -12.13% |
|                         | process-pipes-12 (seconds)     |    (I) -5.32% |
|                         | process-pipes-21 (seconds)     |    (I) -2.87% |
|                         | process-pipes-30 (seconds)     |    (I) -3.39% |
|                         | process-pipes-48 (seconds)     |    (I) -5.65% |
|                         | process-pipes-79 (seconds)     |    (I) -6.74% |
|                         | process-pipes-110 (seconds)    |    (I) -6.26% |
|                         | process-pipes-141 (seconds)    |    (I) -4.99% |
|                         | process-pipes-172 (seconds)    |    (I) -4.45% |
|                         | process-pipes-203 (seconds)    |    (I) -3.65% |
|                         | process-pipes-234 (seconds)    |    (I) -3.45% |
|                         | process-pipes-256 (seconds)    |    (I) -3.47% |
|                         | process-sockets-1 (seconds)    |         2.13% |
|                         | process-sockets-4 (seconds)    |         1.02% |
|                         | process-sockets-7 (seconds)    |        -0.26% |
|                         | process-sockets-12 (seconds)   |        -1.24% |
|                         | process-sockets-21 (seconds)   |         0.01% |
|                         | process-sockets-30 (seconds)   |        -0.15% |
|                         | process-sockets-48 (seconds)   |         0.15% |
|                         | process-sockets-79 (seconds)   |         1.45% |
|                         | process-sockets-110 (seconds)  |        -1.64% |
|                         | process-sockets-141 (seconds)  |    (I) -4.27% |
|                         | process-sockets-172 (seconds)  |         0.30% |
|                         | process-sockets-203 (seconds)  |        -1.71% |
|                         | process-sockets-234 (seconds)  |        -1.94% |
|                         | process-sockets-256 (seconds)  |        -0.71% |
|                         | thread-pipes-1 (seconds)       |         0.66% |
|                         | thread-pipes-4 (seconds)       |         1.66% |
|                         | thread-pipes-7 (seconds)       |        -0.17% |
|                         | thread-pipes-12 (seconds)      |    (I) -4.12% |
|                         | thread-pipes-21 (seconds)      |    (I) -2.13% |
|                         | thread-pipes-30 (seconds)      |    (I) -3.78% |
|                         | thread-pipes-48 (seconds)      |    (I) -5.77% |
|                         | thread-pipes-79 (seconds)      |    (I) -5.31% |
|                         | thread-pipes-110 (seconds)     |    (I) -6.12% |
|                         | thread-pipes-141 (seconds)     |    (I) -4.00% |
|                         | thread-pipes-172 (seconds)     |    (I) -3.01% |
|                         | thread-pipes-203 (seconds)     |    (I) -2.62% |
|                         | thread-pipes-234 (seconds)     |    (I) -2.00% |
|                         | thread-pipes-256 (seconds)     |    (I) -2.30% |
|                         | thread-sockets-1 (seconds)     |     (R) 2.39% |
+-------------------------+--------------------------------+---------------+

+-------------------------+------------------------------------------------+
| mmtests/sysbench-mutex  | sysbenchmutex-1 (usec)         |        -0.02% |
|                         | sysbenchmutex-4 (usec)         |        -0.02% |
|                         | sysbenchmutex-7 (usec)         |         0.00% |
|                         | sysbenchmutex-12 (usec)        |         0.12% |
|                         | sysbenchmutex-21 (usec)        |        -0.40% |
|                         | sysbenchmutex-30 (usec)        |         0.08% |
|                         | sysbenchmutex-48 (usec)        |         2.59% |
|                         | sysbenchmutex-79 (usec)        |        -0.80% |
|                         | sysbenchmutex-110 (usec)       |        -3.87% |
|                         | sysbenchmutex-128 (usec)       |    (I) -4.46% |
+-------------------------+--------------------------------+---------------+


>
>  mm/khugepaged.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4ec324a4c1fe..a0f1df2a7ae6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			writable = true;
>  	}
>
> -	if (unlikely(!writable)) {
> -		result = SCAN_PAGE_RO;
> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>  		result = SCAN_LACK_REFERENCED_PAGE;
>  	} else {
>  		result = SCAN_SUCCEED;
> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		     mmu_notifier_test_young(vma->vm_mm, _address)))
>  			referenced++;
>  	}
> -	if (!writable) {
> -		result = SCAN_PAGE_RO;
> -	} else if (cc->is_khugepaged &&
> +	if (cc->is_khugepaged &&
>  		   (!referenced ||
>  		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>  		result = SCAN_LACK_REFERENCED_PAGE;
> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  		case SCAN_PMD_NULL:
>  		case SCAN_PTE_NON_PRESENT:
>  		case SCAN_PTE_UFFD_WP:
> -		case SCAN_PAGE_RO:
>  		case SCAN_LACK_REFERENCED_PAGE:
>  		case SCAN_PAGE_NULL:
>  		case SCAN_PAGE_COUNT:
> --
> 2.30.2
>

I guess you delay the final cleanup so you can combine it with tracepoint
removal in next patch, not really sure why they're separate but meh not a
big deal.

