Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F60CCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DE18E0043; Wed, 15 Oct 2025 10:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE43B8E000A; Wed, 15 Oct 2025 10:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57C48E0043; Wed, 15 Oct 2025 10:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBADC8E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:26:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 688271DCE89
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:26:35 +0000 (UTC)
X-FDA: 84000574350.20.31E9761
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id EEE071C0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:26:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nTMGPGYs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JqHB3AMR;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760538392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsKPlJM+HQM6U7Scjzorr+F9eHAExRlTzXP36wJKJGc=;
	b=8R/KxVQ59x9vw5tfe5DnPHjFy6GWigYaOko1sb4tkf+mQAA1Kd6DslC5988LVNO6AnSel9
	HkFSZVDuYdEocrgFz1EdOVMWqBCu1BXspDhOXjCg81V/cDzLfScQShWgsYHPa2a6duOebo
	LyBP+CfdPVJKoSW8OwBVis1Rtek9vi8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nTMGPGYs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JqHB3AMR;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760538392; a=rsa-sha256;
	cv=pass;
	b=fGsfxHfuQGCp+9ZkVizcu0HfTxrdjd0a2v+6jGa0aBU66o3Vx81t/R9P+jwCbuhVgF5uKo
	bsqcnZd7NnX03dfqL0Y9H9XHFJO4AvFHUvnq3tg275BqVPFNjBMVWTBUh0yKg26HSnWKLZ
	Mz1H1mQ2koNjocyAMDI0960xg/nixcY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FCuPZP031796;
	Wed, 15 Oct 2025 14:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xsKPlJM+HQM6U7Scjz
	orr+F9eHAExRlTzXP36wJKJGc=; b=nTMGPGYs99xmGLSW9jSbgVVrfb3lecM78Z
	FPM8lcAtlPwdwgfaXL15BQRsQtErgB21jQ6w37zTWqMEFbPBVK0wenXAYJnRs0+7
	xdMpy5sStn1EXka2JPOKDmevSyHXqTk2jIuagb1qxEV5pTdPKPTEvZPEw3POxmr+
	mNZBZhSyD0n0F2RNHbDFPdhwP8qIe+SiXX1y4o+zfPxBzh4XusolsoKfTVkS92Hz
	hNnN5c+Ecb6oB0plKxHC9hdylKJ0hI+6AC7ViJgHFRVsShVoCr2Hj1hHgQjB2G0k
	TEILOkIX47JrS14rEniyVooHb4SzphRi+djG5KWqnzGBrzGjdZ6Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59es46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 14:26:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59FE3JMg017221;
	Wed, 15 Oct 2025 14:26:10 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpacnfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 14:26:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AuDQloY8NiAADm+CLXUVklZIQf6cwq+f+xfosVg9YSmOKDsQZObbXEPF8x/fDprf/ZtCozVkNVSoeX+FSdupNLka1bqWXESmmIqDV/j7UJO/7huIOvRnQ5pyckFH9Bxexil/0+KGpRD/yprjnRj3oiRuyXpAwwr9k4XCHzAg+rP2taKAtZxYRR6/LwDL6xJezGa67o6MOBP8vKkT03waZIoqvEXQ9HxUsQ3rpXagDQOLlFUiZK6bA7bG122jtKuJ/HIlAeFKZ2DDl7P+BQOAInzpWt2kbfQJdMB+944MqJaroZb7j/bIJ3YVZkcG3K2YZ9j3qJ6y3UnvZol8OJXcgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsKPlJM+HQM6U7Scjzorr+F9eHAExRlTzXP36wJKJGc=;
 b=eHVFjRXEclk+w6gA0ZPaQkh6XKshV1VVd7uAKyITtUSZ0Mgi1NevBQwnBoGvAH2fyJawaF8IGZsyuuAX5DlpSMDu4pGPWeYidUS30ehmSUMoJ5guvTfeShKeCOdLJitRSoQ49y1V2BevSA9+MGEsOEeF7o1+wjLf3kWOYGWa+gQlDbovIskck/lGP/k/Xkt14RWdKQ8HysMmIggWJLCgwdRHd3H7NW9C1QBGJJEa0YcgPIO0iFqerVO9EMkt3HPmzpTKNrXVGhuQn8fCAQvrh7P2b5L03L4rgnRnD/MdJ9IXupOR5My6FGWrz81d71d4VeFhk2fVgrXL6kXAcS3Ylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsKPlJM+HQM6U7Scjzorr+F9eHAExRlTzXP36wJKJGc=;
 b=JqHB3AMRlJ5/7EA0nhGpaIlw0JaaiIPqGsLYt65EeclNlftvHLR/mq5xJK8rFFbkwquwmROTj9V0gGFv7sMy9xhYJfkSoBlfYOFm9QpwvXU5Eym6G9/ABPmGsBcPHR9uZDZx+TkwEZSUdsmzh6JimR/wasOkBMGXLkTshC22JXg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6438.namprd10.prod.outlook.com (2603:10b6:303:218::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Wed, 15 Oct
 2025 14:26:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 14:26:05 +0000
Date: Wed, 15 Oct 2025 15:25:59 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
        kernel@pankajraghav.com,
        syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
        mcgrof@kernel.org, nao.horiguchi@gmail.com,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <d7243ce2-2e32-4bc9-8a00-9e69d839d240@lucifer.local>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-2-ziy@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010173906.3128789-2-ziy@nvidia.com>
X-ClientProxiedBy: LO0P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a5c8bf-07a4-4186-513c-08de0bf6c63a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?42zajDlpwYvpjxmE698ffzxfOIJ5yx4pSsxiQYTObASnT0YxM9P12MVHAWiz?=
 =?us-ascii?Q?hMkKGYcYi6sjFrqZQ48f7l9AAD/HP9BPXHJb5URTe9nns1fK6LokZoIRQ5U4?=
 =?us-ascii?Q?aRuTvYiH4i661cs3Wzh2lGw4KWUVjf5K9yIsOPdO3N588vFo3BIpQuGGbTsV?=
 =?us-ascii?Q?gY28uD65/9KHZpSkIZTVD+SiIezHx86YCi02QdRglBJXCe3r+lrEbVzd/aq/?=
 =?us-ascii?Q?vmN0hmaiXhorGgvxdfgh9JSqWzPF6AVlLzdDp6gARPl/U1zqMQcxxQKL0HSq?=
 =?us-ascii?Q?H1+CX9Ug23381/jvNHLvL2ku3fm3WZ5u4kYwlaDR29IEP7IXwwzMS6sAIX6M?=
 =?us-ascii?Q?799vux2MhFJ/RewciY6TKJNGOGzFXUs0w9b9sfXRQw16KuO8Vb8tS3ZiYjef?=
 =?us-ascii?Q?GAdWysnsbkC6/X9xIWa+Gem691jJ6JBu5cUIfi4u8Xo2FC1JkjyAQKYgi44R?=
 =?us-ascii?Q?8ZrpVq3u4RK4tTavTZOrKc1OPc6FN6FDIKuTPnMnK5xOhcq8byOezh4AaaNp?=
 =?us-ascii?Q?kYB7vk4dfnX718vWkrJ1h58NHqN9wNHUvvQcEmJP4d3iIuFveQ2Mt5uDSA+V?=
 =?us-ascii?Q?QQVJ65DEO/jPuFHtGzvW1h91RwS3iIvWLIBbT/7gsLTP4acncCCQm4pJ9H2q?=
 =?us-ascii?Q?QHsrn3+XrOW1YXtOkSdMWRu7t9PbNjm2tTNXwbwv3kkWiZCyTUK93Qd9qpJK?=
 =?us-ascii?Q?TR1OXLyWQ0qyh/NYJDzXmNr1uqbCrprDRitWUCov3SxGyzP6xo2XUngRl9Uf?=
 =?us-ascii?Q?IwpwYKLTYpP7MBnCoUObj0tN8/hI7I2G1hNBAT7pTnoTpZLiJeTiT36SI++H?=
 =?us-ascii?Q?OEXMY0VLUaoumESGtYj65DStsZMDzq9PV66zbhu9mM+tKViTlDzWlz5eJfjj?=
 =?us-ascii?Q?Ak6teQDwVqtJ1hF+8QU3W9dkuPUCcE6xcMpYGcKds8BTcVz2BbeWJYn8bqBd?=
 =?us-ascii?Q?wFNH6jnmsZnqhV1CgVVviyxNqErpY7mPi7Ju3kACCLAsudpxnh+O+WooEaqc?=
 =?us-ascii?Q?hG2iH99f51+KRqPDzRxpHONUswxl2OkB+Dnhlg8t9OBahSVhjLjlsUBPgMsg?=
 =?us-ascii?Q?qMmOiuFnpvzC6+3Fks5EB5NUdA2NYIPiHj44P7/AZmNgPjcM4LG/7Y8PbP+i?=
 =?us-ascii?Q?+jnRvZMIN85AXHcJVUvFP3hlvi0sb8Z2h8HaFIpiZ0NDw9KZhO6BLt0ZpoTK?=
 =?us-ascii?Q?gdUizzhU/P8TflIB7MR48Z9XVmjVtmP9fz5zGPc83BwP8cREoemg0dj6X6L+?=
 =?us-ascii?Q?7mu374GLI9WbJuC6lO9cHQ3aMEpe3x418XOExYpwoXX9gAF+j/SdPmtRTg+B?=
 =?us-ascii?Q?cW5Km/y71U5foNCpVzF3t05NS6NvInMVgj/UcjLy6z9eKbTPQsh/QooqLJah?=
 =?us-ascii?Q?OLHttKmpXLPRUfowSzO4lc0JMFt+qi15cjv/FxU78impqieObg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wezMXsTThG5MIIrjapQTwhvcABz872h4G+kET54iq9yyp5Zbw0vLgUDEnlMz?=
 =?us-ascii?Q?JSRopPfwy0lOGytCCVt+e+ZC+RfmKwx8x8zmP696GmwieBg64MIchkpVPag4?=
 =?us-ascii?Q?Qm+tylJwwAS1aXUVD3QkeXF8B9ajBkvCDFfz0etjhAtGVsxf2UaA3s6RlHZ6?=
 =?us-ascii?Q?x0iOxhbm/mqnbhI8CF3zISQA7QdjedrusUiy3gLHDjumUL3P9PF8zRlquNiz?=
 =?us-ascii?Q?GkuiGP6BN9FIrtjucn6k8DDOS2X4bkvquusbYdsy66uevpBuoJrLV8v92C2n?=
 =?us-ascii?Q?TjC3Q2OjyuWAI1yXrdS2yNCZ8WfD+MsLH0LHXS1IrE4JZR3gWw86dX2nFKjr?=
 =?us-ascii?Q?Uvi5vD3E9WxACxc0ukwNCwleoR+m1HyOdVk8s05T74q5i2XMk5TD5KSeVdnm?=
 =?us-ascii?Q?lcYvETN6cQIhTBaRWgK1VE3IEmMNmD/OmlEqOpIi0OU34mCq/U2FaCWmhHI3?=
 =?us-ascii?Q?Ab4nbX5ekcD85BAp4c5CrhjaQL6Fi2zcDVN7j1KQ/zCELmGTMdidp0IFKnbS?=
 =?us-ascii?Q?KY/Z2QFZrgmBfcVZ8bv+6+FdTySmA07vmq9O08wUm6ugr5T1gIhhEYYF3Mf1?=
 =?us-ascii?Q?2qskhlR5TiyrPQ3iIarVh0FQj0YkL+NPS04lgCVG99ceIBcaAImXaH9Dd/FX?=
 =?us-ascii?Q?lCgk9INk9sExSCOvvJkpCRr32xeyfxAm6fC2lqW/jSfHHOnO9zY7nCGi00Ri?=
 =?us-ascii?Q?0ZIQIuMirOFLXs7xF3rJk2WqdHI5wfLYiB99r3qWMxjyNkNJNHd0Sx/mnZSE?=
 =?us-ascii?Q?9EQQ9tsRnvVe4JOTb2fP5xPFsvJne+7XnPgTAYjkH1aOVbSSzm/Igs8z1QRI?=
 =?us-ascii?Q?rKt2OEgGowIGKUyy4QsBsNzDVDt9r8Zj8IVrrV9QIKtUby5OBF5WFhs3oZiX?=
 =?us-ascii?Q?u8XhZo9ETvtSPeokwy4/diDEVWzSYz10Yx3flShCfFBug5Tj4iCibLccOcpa?=
 =?us-ascii?Q?SWZTN9TgCX+9Xcw1jrC5iCbQLhcw+ET9+/AOADJTw7kErc9lBcp9iD0rbcA4?=
 =?us-ascii?Q?c7kcJJZoMW/fTbC05hh8rJI/QLDS+u6DDzM8Rc3hKd3saIX7OXL2V8a4oPqk?=
 =?us-ascii?Q?8zYBSXKEL6rxdaPgirgUsQecPLVWj2EQ/SWIwmlC+WHAGlPc4jmRuCcnss6b?=
 =?us-ascii?Q?RQGWVd25oynyr5Hw/X2OLknxU94sT5OHhWPLO2Macy4hCqPJjAFTVecIjCAh?=
 =?us-ascii?Q?0ecsnlJehOQwBDuBQ8D17H/6YRolxG1Bd4lG9FpGrjQYkQAn0HFPSPGia301?=
 =?us-ascii?Q?Vn0tlh74pOmf1p52w+spbj4SQDNDzILyEIxZDH8YkszMOtj1lfFhMRM82W4C?=
 =?us-ascii?Q?yHjni3nM+s566cGgWmWZjf+ZCqshlZdLMfRqZEoaLIFFpnDttKoQ59DUW7M0?=
 =?us-ascii?Q?Sb+bJ64A1nEn1FKYlX0PH16qVx0xgQD/ueruNOktjkrKxAot2Q2xUHmQJkRz?=
 =?us-ascii?Q?WqxY+XfA8CIQ4neD4fjo83V1J/6NlDygYN4aR5Mc+qWN3Clc0NIlZiW3XCrY?=
 =?us-ascii?Q?PGOQmDYzzp+TQljIU7owyo0KtrW33sbQQ23cFXa5FcQ+ytNFhqYlHI2ECZsb?=
 =?us-ascii?Q?FLD8eUL9HqFdLzslhSL3vVb7Tgz+nk64jbHptXGrAqHQH8t9NbwSnvsr++D+?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mym+f3j6+C8rK8pNC2EdnMZNXXqsqUcl4/fevFxaVap99zlJvYllzhQ8BOIlW6BzjgjwCW6pYzjUkD0NZATHCLnnlB222V60GhHTG5Isw4vwOSfoF/mmvoa8guT3flOHM239KGFTzwKlZOilZ1tNvlK5A/aJRl2j+SOE/3ppbiZyUKh2PtSi/GJs31S0Nb2hxyP7UZFOIMtv8BSUYxK5AJdvNC0LD+Hmf/jTZEKDkt4GEHc21lyZbV2WKHQyxrk6EVwivDPajR2vKClpMK5/JgEsEveBJUZTBjEcjU9nk71PQEHcgNVbuqr2eUXjWP0PhN8Pe4cePmBtkaV25CLRXs/VdsFm+AikZR8J1DaWsX6vtWXrwcuOJWea9Z84MGZ1UCg8x9uGZAx3iFgrOvVA4dUsHQyXr1ZTpOJMV7TxPlq1jvrMaTDN4YBookQBfb+U3mz8cqlVrN9mzK69g+V1swuaSop2gZT8lbbYeLDH7kXSkhpqzJ+c2PkX7mcSKE5qpXP2LftsCmI+TEms8ZBQAw1fL7ePHGLZ9CAF3XOsWkTu1eed2OYXP9ClNv9D2fK5/6Ba45eIvjaRTAne3lefq7btNuXEWx61j4hYWw/2j1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a5c8bf-07a4-4186-513c-08de0bf6c63a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 14:26:04.9577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkX0bIlbr/qiTmyFRdzvwQ+auseHbaTLA3KWkHD32UNBR7acBFS8UHAifvFtCbCm2wT9cObT/uBMLuaVJXX0zzzNQEqWx2aS8rLmq2fb+3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510150111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfXyW3SprE4nVFm
 z8M3NIecLM0/sjMA6oZSWQ9VjRg7/U1puNinIPK2+0Z7sG3XXILtWehzjFaMs/smWITqYAerCdM
 YmC3qsOl2hOCnDTSMtJYh+fRN4/OuXz4b+A82t3fvg1PaphFanpefm/LEFM4hjZaSFDLMlZtJF6
 2RvSS2LDMAKhYpg67iXnYqHKMOVixEZsEr+s7otyrVr/GwQTgZZKWHpacbtdNoKX9WgC6Cn/Kiy
 YXDpujP0jojiGiZW7+hzKP0lopA5qXwoiU9zBm0luKkXRKbnOfW9mWQSEqIYkrj/sdlia09n/Ts
 arUnLiVFjJwMRbX4IzmlHXqN6jj9CDirlsaFBkRgi8GKTzcV7Nrl6QEadwtdMFHkNByb+yPKLS+
 tlKY+7Ms3KSXwKrxToN09QPei+TqBQ==
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68efaf03 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=hSkVLCK3AAAA:8 a=Ikd4Dj_1AAAA:8
 a=hXRQEShyM1sh5Id0wpIA:9 a=CjuIK1q_8ugA:10 a=pnI2m26_WTs5bHz79ivh:22
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: ugbBHyqcKEsfqFRGuZN_xHy4UhTvYZB_
X-Proofpoint-GUID: ugbBHyqcKEsfqFRGuZN_xHy4UhTvYZB_
X-Stat-Signature: i5rrxeozxyjwuxmi79731x4p3s5oamqe
X-Rspamd-Queue-Id: EEE071C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760538391-122654
X-HE-Meta: U2FsdGVkX1+Aitat63S4C811MRs97jhWAASypTDloF2Hsh4PxGtWA2L19UUV3g5A+0/HBFiC78/SQq5WvlWxIC2IVAGVf4ne/mmf9frqKYHisqA0P/xI2gmMMjLyw6Q4pDVZw5++CbOI1k05pnFSI9dWeberiLzxZVOTHjfRGwqix468vQkJRYXKsS9MYRACIpu2Dk9t4cRLEQlFR0o6UxNJlh7kt6Z1TijBBWmDaEtWdC6zxbyzOj91gDmZ8eJzSwgvzTeUU/ne9Y0UwhRldT2z4X1uLWzrV85onSn3Ksp1787zfPvlrsOSKz57iECLTck/gvoxCUobq/tdDEBMPyiIlu+L+yVYtSDm3DwE47/yW/M+Ei0G/fonksNj5S7jnxSNbdDVMFPfKUH3QpjrC+JjAZkE+xE85G2gVQIXe0cxo/3oIDf5Ua8aRTimDMXxxhnXCbEk4H1GUCZaJdvpYXmj0/D8ZrUevTJJTw/AblfEo1H6WCczHjxl/bJfNNV2YqM98FXb50BaD1wrZ61sVWQsAThD/Siy7bqZaBKIDcHotlzmHmRDJb+GEcJ6vA/o9+d9IYNUKKJ4oxZaRtVdK9Qsk4nZcpR18r1hGqxj1ruV343K5IUTl9qParJUDhYLPVc18lQTqrRWu1LEqaYqWA7Vg8fAHYZeQ86dyocapTB4iCPB/+7Tsgx00DZbGSDJRZTsQTeAlfV2YQXvLq4YJc2yWzYVLFaHLQczJ8NKp5rLyNMCfTHGI/y4DtBe0uHhN7pAwQOImUAYbrnzNFk21lERlNy9ny3AYRpBRSlrRktGjSkAc8mq05zPNI948v+yYN2ke5q6rfCKVlrZ1M9l1dZSsUX/bU4f1x6LVhxAAxVQgkZWj8Suqmr4t8VrzIQ09ybP1y9B33LTjlN3kqiJmWiIa6d01dKkpYBUnXrIV+lsHQnTTHoY1vuSs5N32FpKi4NJwgx8d/SX0mbo/xN
 vN02FIbB
 OaOeHWmp4v+Dua0zKUVymr8apPXRw0jiYvQORtghAIZt4wa6XbyYjyeVC1Z4/oJQ8cCY+obVYwAqPWR0TOfsJTlMiCJoAuzV8OjHvjvhmsJvISlaTA2polSsgfgQVEIjaFRo29cBSDZnj2VoxcA8c17sCDuH2fv7AXwcTA/fH5MkQFpSa3MfZlER8QyGAJ7cWxGxFRVLowj41WSH15jvs4WcE/E4kExNnyM9C1nn0DvrZwLxXUSA/dpEfEFdVTu0Y5G7tK18ZisxI/TAQOr7rxQZczsFcutAxHvggdQJTmpNNDLm4/nsUmLBpgu7kVJD/NGXfcYQhrqmKdGGdj1e0iCItBB/lIVxKwtB0+uypGwkvUM9qwMELHmmVXoSzXSlwvfbhN0ZaDJOWL+KXjry1j6jDAN0zQW17ux3z9pbBo6XbPLTX4N6xGCKwVBbE9AuOJTMynwPK3SAyG1qATuVHCgXYRL5DV+XDMvWgVKB4lXcoeKLOyeriwIGQMlUbDF4ptkExsBj2acqTO102GK+gKMG88R3msuRV58V8jsE4FZYKaSK4mxg8yOfkikB5Pphy4885nBJxwLXyNp6i5tHem3LtlkALSdNu8roIGgsQrmnNOQiZ/oFTwWG+NLeGmV/dSuTdu5GC9XJKfFPIUmjZjvJQoSTU6VBdoldkBuSrf0xV1TKSL7D8piurlpnehgyUDQMBEjJcj4J8ie8KnFM21to1QhaFhqm6r4KtCeJQ4kjGBNEIyqNVcgyPzOWn6Xs18bkR8kcpSsIGTMrVq8PxTMvYALDrieF5UDob8GU31eVDYB8KcGxgT5vCVtrugG7PXuOnm88FJGbyxby1VmRrpk+WT7Q+EI3H8G2Vogy0naLSmfkBxNhzeGE0ZEG2H9dnqjRQpdlWe6ZV4QIx065x0MhcZ6R9/9P2VDD2DM4PXXNRzPqAZBbAClIgBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 01:39:05PM -0400, Zi Yan wrote:
> Page cache folios from a file system that support large block size (LBS)
> can have minimal folio order greater than 0, thus a high order folio might
> not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
> folio in minimum folio order chunks") bumps the target order of
> split_huge_page*() to the minimum allowed order when splitting a LBS folio.
> This causes confusion for some split_huge_page*() callers like memory
> failure handling code, since they expect after-split folios all have
> order-0 when split succeeds but in really get min_order_for_split() order
> folios.
>
> Fix it by failing a split if the folio cannot be split to the target order.
>
> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
> [The test poisons LBS folios, which cannot be split to order-0 folios, and
> also tries to poison all memory. The non split LBS folios take more memory
> than the test anticipated, leading to OOM. The patch fixed the kernel
> warning and the test needs some change to avoid OOM.]
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Generally ok with the patch in general but a bunch of comments below!

> ---
>  include/linux/huge_mm.h | 28 +++++-----------------------
>  mm/huge_memory.c        |  9 +--------
>  mm/truncate.c           |  6 ++++--
>  3 files changed, 10 insertions(+), 33 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 8eec7a2a977b..9950cda1526a 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -394,34 +394,16 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
>   * Return: 0: split is successful, otherwise split failed.
>   */

You need to update the kdoc too.

Also can you mention there this is the function you should use if you want
to specify an order?

Maybe we should rename this function to try_folio_split_to_order() to make
that completely explicit now that we're making other splitting logic always
split to order-0?

>  static inline int try_folio_split(struct folio *folio, struct page *page,
> -		struct list_head *list)
> +		struct list_head *list, unsigned int order)

Is this target order? I see non_uniform_split_supported() calls this
new_order so maybe let's use the same naming so as not to confuse it with
the current folio order?

Also - nitty one, but should we put the order as 3rd arg rather than 4th?

As it seems it's normal to pass NULL list, and it's a bit weird to see a
NULL in the middle of the args.

>  {
> -	int ret = min_order_for_split(folio);
> -
> -	if (ret < 0)
> -		return ret;

OK so the point of removing this is that we assume in truncate (the only
user) that we already have this information (i.e. from
mapping_min_folio_order()) right?

> -
> -	if (!non_uniform_split_supported(folio, 0, false))
> +	if (!non_uniform_split_supported(folio, order, false))

While we're here can we make the mystery meat last param commented like:

	if (!non_uniform_split_supported(folio, order, /* warns= */false))

>  		return split_huge_page_to_list_to_order(&folio->page, list,
> -				ret);
> -	return folio_split(folio, ret, page, list);
> +				order);
> +	return folio_split(folio, order, page, list);
>  }
>  static inline int split_huge_page(struct page *page)
>  {
> -	struct folio *folio = page_folio(page);
> -	int ret = min_order_for_split(folio);
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	/*
> -	 * split_huge_page() locks the page before splitting and
> -	 * expects the same page that has been split to be locked when
> -	 * returned. split_folio(page_folio(page)) cannot be used here
> -	 * because it converts the page to folio and passes the head
> -	 * page to be split.
> -	 */
> -	return split_huge_page_to_list_to_order(page, NULL, ret);
> +	return split_huge_page_to_list_to_order(page, NULL, 0);

OK so the idea here is that callers would expect to split to 0 and the
specific instance where we would actually want this behaviour of splittnig
to a minimum order is now limited only to try_folio_split() (or
try_folio_split_to_order() if you rename)?

>  }
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0fb4af604657..af06ee6d2206 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3829,8 +3829,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>
>  		min_order = mapping_min_folio_order(folio->mapping);
>  		if (new_order < min_order) {
> -			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
> -				     min_order);

Why are we dropping this?

>  			ret = -EINVAL;
>  			goto out;
>  		}

> @@ -4173,12 +4171,7 @@ int min_order_for_split(struct folio *folio)
>
>  int split_folio_to_list(struct folio *folio, struct list_head *list)
>  {
> -	int ret = min_order_for_split(folio);
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	return split_huge_page_to_list_to_order(&folio->page, list, ret);
> +	return split_huge_page_to_list_to_order(&folio->page, list, 0);
>  }
>
>  /*
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 91eb92a5ce4f..1c15149ae8e9 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -194,6 +194,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	size_t size = folio_size(folio);
>  	unsigned int offset, length;
>  	struct page *split_at, *split_at2;
> +	unsigned int min_order;
>
>  	if (pos < start)
>  		offset = start - pos;
> @@ -223,8 +224,9 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	if (!folio_test_large(folio))
>  		return true;
>
> +	min_order = mapping_min_folio_order(folio->mapping);
>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
> -	if (!try_folio_split(folio, split_at, NULL)) {
> +	if (!try_folio_split(folio, split_at, NULL, min_order)) {
>  		/*
>  		 * try to split at offset + length to make sure folios within
>  		 * the range can be dropped, especially to avoid memory waste
> @@ -254,7 +256,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 */
>  		if (folio_test_large(folio2) &&
>  		    folio2->mapping == folio->mapping)
> -			try_folio_split(folio2, split_at2, NULL);
> +			try_folio_split(folio2, split_at2, NULL, min_order);
>
>  		folio_unlock(folio2);
>  out:
> --
> 2.51.0
>

