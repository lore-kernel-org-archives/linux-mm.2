Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4ED4D2FEC6
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 17:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1DFF6B0088; Tue, 27 Jan 2026 12:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB8C6B0089; Tue, 27 Jan 2026 12:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25286B008A; Tue, 27 Jan 2026 12:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD9276B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:36:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 577E31A02AE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:36:53 +0000 (UTC)
X-FDA: 84378449106.22.D36EFE3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id C2BEC40009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:36:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gLcb6f7Y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fn+HKgow;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769535410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXir7zTRJqvrWYhRE8iA37qejfvxY08rtLYP5bXEggg=;
	b=PgDse4vQOh2mWHhEQgz2a1nobLG2fggkkreNm6dniVgf+NWEL+8mAxcVEGPNlDd0HwVVXc
	7F6Yr+A6OMfFAWWIGHqWzHh0tvhWkwgMFH9Xoa9S4rfylv1rtKFC0nMUUKc7g/epknlp0u
	RPQLzNMEWLoIxU0uvSqEfrzxTWXGQks=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gLcb6f7Y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fn+HKgow;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769535410; a=rsa-sha256;
	cv=pass;
	b=4QmU91dm7LjBLlyZhMgQZW2BXf5Pgrizdnr2yN8epn8Aod3UXf+67ff4E+oZbVUEJGeEdJ
	KYmqJ9E4JKF8O/1canojCYUnz6p8Ug4RlhZ5BB09MgHd4T2ZhBXxO5yvMLcC9PFWegWXo3
	8KF5RZPOm82IMIwJFCjv1g3NLj7NTag=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBEI2N3713709;
	Tue, 27 Jan 2026 17:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QXir7zTRJqvrWYhRE8
	iA37qejfvxY08rtLYP5bXEggg=; b=gLcb6f7YU6hX+mkvgzlmPu2dY9MB7+wFLG
	n0zjFHYNp8bMDAXiFdejignSwmahUA530Au4xYxOtOUfWybxk+Ct1PBiUSVeCsCh
	paG4BZaIhSRs1GVNsUA6iNSDEsFUJoVpNzcNkTJzzcXYFWhWQeEo4IjSSwja3nxN
	6stK8JMOB4SD3TwcOKRHTIQ9Nhv8kdpUd4pCGDYe6KcmV31OrG9SkvH0cSITGUis
	npyHFCVeAPgmz0YuQYz0+V6dMwgtAUnD33enhMgwmNd+aCJVzT7+rYpF4z32l1qn
	BfVjJM+NMwII1jjMOFTrPIBz6yxW4TYyN+WEaEoZNOeqUvtqUKVw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvny6vep5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 17:36:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RGgSfL001851;
	Tue, 27 Jan 2026 17:36:37 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011039.outbound.protection.outlook.com [52.101.62.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe9gk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 17:36:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S77agDwp+DRoGC8l9wT7sX0fx8PmF4W/MHgURvfiQIyIep+Uq16/4AZlNAxfIg7Ihfol9lJ7GZZBSY/RFeHJFgZunwK5PqMI6WYkr/hMW3zuyTg83B/dlrxbWoji3Ss1of2Lsr3gKOmMWErNavcNTzWqYDaxMGt6WRZn3ftKmwHJumwz32kz6PBQYvwlw0g3ii7WsWZioHnzJWJ8hJ3nDRxIP7u7WcW6x60/g6tHfU0mtLo5vwYliQBTx6/mDjmbe9VzyOA7FEXi8ZPsNqZFP7HduentnM1PxzorpZS/p9Gr2fwaeafP9KBJJD8cmKBnvqkUiKjQiiqdFWdYN6l/Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXir7zTRJqvrWYhRE8iA37qejfvxY08rtLYP5bXEggg=;
 b=NS07vV3pp/4nfYj6//sNzx5kr/V/uk/8P7TrpuSpdkRuy+oRvo2VCPEt9w5Hn7y7uM5Ykej+9D/q5P9arspN2LGRTYwlBJdkp8Cs4/J/VJW5rpVj1tKvZ+aDSgSLUv2wusTy4SiWqKafetwwe2FlbdwLNzHUaINH3vXNI1xP1O1sa8P381q/G3tSSRWCkK8i2j1RS+LMPb9XNWk3i9pt9rsq+LDvlIgwoQR1KaPmipmc4f1WXfJknNkGEtZRSgxHKbVx8DJ0DyKFbDyyQQV8d06bN3hccK19HRzXB2ciVZPNKEZc7R2pDikPncKKO8Q0QdLXdDsVwfYzyozmS0mUzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXir7zTRJqvrWYhRE8iA37qejfvxY08rtLYP5bXEggg=;
 b=fn+HKgowU9fx5tx6Gvbn+xf08Z/sMqNjwrYQ18WgIRqPs7xwR5xBHvl1cN1gMalo5slutCDZ2oXmaMToo66pyXFpd4oI1pNG/JRWLQVww31cp0zA52+PPfjmr+wvGkOjU8iTlOodwJdFSoff1tYXcralx6+iuqOdSGskfjp1004=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM6PR10MB4219.namprd10.prod.outlook.com (2603:10b6:5:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 17:36:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 17:36:34 +0000
Date: Tue, 27 Jan 2026 12:36:21 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 08/22] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Message-ID: <7dk5q3mbusqlklpk3ja57upbhkhhg3bpueh4nemuthesmwpgnk@zkk4fqug3cwx>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0090.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::23) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM6PR10MB4219:EE_
X-MS-Office365-Filtering-Correlation-Id: dd2acba0-0ea2-47de-7ae6-08de5dca9d71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SQOADRwydAMTzY5/SBq0dpXRIXHvE1Rx1erGe8RqDWFttNZtiazSXHzc1lHU?=
 =?us-ascii?Q?AZYJmJY/c+oiMei4ErZ6Se0eGZk0Xwi64AbMEREkQEm8QoQkG7Zu8ONvABRK?=
 =?us-ascii?Q?LTHbIhn4+zSVI17erEpOolnJW8he2oOQrKIK7jfTNMOqIu4s16De64/e+BMV?=
 =?us-ascii?Q?xrWHdCB1mRkF+ZbWIrRiSZZ4XfaCV0J/KyqYamlacQZB8TIdF9BFaz8/V+R7?=
 =?us-ascii?Q?HM3LNMqMK5voQnQtus9I/7INEawJUy3TZf8qyYdJgibrCyXvY9f188FxiHH1?=
 =?us-ascii?Q?wLzAeucPbELUnpOxhcbI4iMSUjJveSYBGwlQ6mQYCdFCt0LgPgUmIYtjCwBd?=
 =?us-ascii?Q?H2z8tBblZeHHvHVoSlUXoY/sGRCvIXOYnTJ82FSszMKaipWeXPaKjRFj2Ecv?=
 =?us-ascii?Q?TfWtfg0N6tz1T02SAkzc76QNrhtRnGGrW6nDiuG5CvuCMYEsx/NS6+Bcf6C9?=
 =?us-ascii?Q?6OwlDEQ3nQ3ftZJzdXKYvfyjKWLG7fLCxCm+75dBittkSb0jb0QrRbs1J203?=
 =?us-ascii?Q?3mcMFnQjFMIjxZNbncmMEL9XAOzTLPDNUNuCHvIkuhz6OkHWiTdbI+ovf/W7?=
 =?us-ascii?Q?VLabtyaEURt6knvRrTtxbi2BZJWuuNR13u5+V7EvgkCAGmgCkvceV3mHv6pn?=
 =?us-ascii?Q?6MuUZLKT92y9BpvC726No6yTQ5Y367N9VehgIMyT7Y+X1CvliZKqoB0S9Bk5?=
 =?us-ascii?Q?skhVf+EAoRXDBp41z4C5LipdgfVkxfTj6ytEYvZ/M5064yVvyeLRZSt+/46o?=
 =?us-ascii?Q?mdDWmRfkgSdYwluXeClmOcKCGp8OIGMPzZH/Hy6JH9Bm0zsMwK8p0zX7SNF2?=
 =?us-ascii?Q?1tUTAHFZ3fV96NbbDnO0aL++MFBHtUSsd5rtQz135ZTMXX6NaJVl/PpJ7p67?=
 =?us-ascii?Q?GXpYf+S2eKxeQRgERaConfRJL3kgKpu0Q1GT0SUh6AB8gz1RIgkKzeNk4GpL?=
 =?us-ascii?Q?Z9pE/xtjhe4zttRqGlPAuJ4L2Bo5FWNgKAkDN77I+dpeFAqPPB89AIumuoZr?=
 =?us-ascii?Q?UMGAtTpAT6Ojb4aQb3qsEgOHOCdpHY3zOmH5cuMIz9GCPCfGH2BD6mW2O6bb?=
 =?us-ascii?Q?KtCZmvXwLhpb7xcLhnnvtTiCjUciApB/jSZtFM3vEZ5CycTVcpmfRtgEL3OQ?=
 =?us-ascii?Q?oz34Km+suozWC5VEiwSC6nnWNktSe/1shOUzJ1C5D6+9GuyMXPvzZiHdy1iF?=
 =?us-ascii?Q?eyLxNPX7/mbIUz9pgamjN6WvQ8Q1jwpVnYZx80OszfwSD5Avayo2Fcp3pveS?=
 =?us-ascii?Q?TealU+otEL0TBcz/AywTRnXVBzLzSc+EiznfvgnhAKbIs/tQwocZe/UWo8Nm?=
 =?us-ascii?Q?z9OTed+jt5cAjdjPwSwe9nk6uIFAdZ+XpCfr1MXgrO5jI10LYbpWlQp9G5ug?=
 =?us-ascii?Q?qqYFbGSVz3rNCGBK0ncvEvljUFRRoVPZZgUMIYGM4wC56Falk36zMjdV6QyH?=
 =?us-ascii?Q?qjspvuKWrYk1P7xnOpZfxe3VUq4zVJ48henPE1I/GrnVeSOrOGmngMOfQ1yM?=
 =?us-ascii?Q?HTzK/LSuqWmhbN4rr+Si7Qt2Lrj26EgzKRWfj1GkGGszw6tUJ9OWdL6uVhhr?=
 =?us-ascii?Q?UftW4hXTCGZEY/AnuyE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WKmBRSFZCBRpEDWIwSB0maBfjpOctulNN5X4/5xPfKsiZkBl2c4Upl3h+sn4?=
 =?us-ascii?Q?rhj0d5hwF5MVzQEybUgKEX30YdVaZLAGh53n7UjuDfA1QXanMjwtO7NbWWTd?=
 =?us-ascii?Q?tavXcxtde+LmowUnYvgIx2llKLi7TTWfwbipJS7zeqgE8Mc1awe9+kmjH+7i?=
 =?us-ascii?Q?oXXqWrYAOGtQcMmqt0/6g2QcqER9p3UREZW0qN7ZcpFNJ9fM05u1qKSdrwiM?=
 =?us-ascii?Q?lK2/3NlOo6AEdNNZz6CyCp8kE/Nxw3JIbacaVwGoXNXeqXW/eHBORf8IH6My?=
 =?us-ascii?Q?V+8m0UtnoKzM2jDDwV92xOhztnVvaVa2j9VfAqEhJwR/DUxjs/A0IWYqYoLF?=
 =?us-ascii?Q?37CH/qly4pgoUobW6pcPptuKmUkxLyA2/tVAwXSZWxXw4xBW/g/NpYLGomMi?=
 =?us-ascii?Q?+qs839gmICYf5s+jnjXpRKHT9Pqky5lBL3HoexiKvu9qb60v3igw3dPLyKMq?=
 =?us-ascii?Q?jWvoPWsPAlCS/sXqSAzQn/Nmjd56ag44LvokQcL1Sl4Vzo++kMK+c2+V9BY9?=
 =?us-ascii?Q?p5Q/TEitWJRYYcADFEkGW3l39lzP5VopGYqmjdl9EMmg7g7gpcK3okShGR1u?=
 =?us-ascii?Q?0u+VL57CAFtwRPynN9so9VSNh8LQ/B3CbnSCml1PMrGeQA84Qf4Rk3doQY/k?=
 =?us-ascii?Q?xCICqhfclzoHWgn+1qxwVXBGZL3SAkgZ/kaq4EvuHlzTVZCGOpuLrKQ3pFty?=
 =?us-ascii?Q?NQ7brSJCInk01/nlkdquZx68Ki6No5feFZDVNjG+DEmqA1uJcF0zv34Ykw1T?=
 =?us-ascii?Q?JZ5sNeIuv4jAZpdwBhDo7H96OR9g4DWuRCQ5YWucrdnHLy58QgHerRYRVIB9?=
 =?us-ascii?Q?tvAmtHWT93IObY5h2DuVpWzXt+SSAL5Dzt8oyOwXEsTSIp2I1klP6EOKoGJA?=
 =?us-ascii?Q?KZKtH6nKgeqJy2gJFGKjrwCkkb7iPxRgXB/HtlUdSmkyH1xhprNRGRcFe1u7?=
 =?us-ascii?Q?JX6O4jYPD9qsEXYCfvIavtxB48ntm+F0apoZbvjXamJidlAC+a0Eqz+b30RP?=
 =?us-ascii?Q?nv0EArh6nwtp1mxmBt1F5V9Mmie9MYYsckE/qxE8x/03VNjbHJZeX6rRq73h?=
 =?us-ascii?Q?f9M69hYGKJDHh1EgCuOHmHiEbH2H20+5MJ5eVtaRmsfOE7rXWtsmICKFEyM1?=
 =?us-ascii?Q?Z4wOCnCX7sYTjOtVtptCWB9ftsex08UZCXHhM/2ALpuP5i91mJCpTo7zp4yu?=
 =?us-ascii?Q?+TpsKdx7zZSRJxvn4S7SzQVhoNfVVe61xGY1TvHQ6yVE2xuAiXf8DsDSrJEg?=
 =?us-ascii?Q?PRtgK+lEZM1TB+ZefAVU2wSsjV2dW4WZK80VtM62fDYHxJVigwzpG6KUixVV?=
 =?us-ascii?Q?2GXYgQLNNuEFJnIoaXWS49vlkHhX6M4FgcI2Rc0I1bgLZ/FH9+r3pr/CTl6s?=
 =?us-ascii?Q?LtwBBieLOr9BYfhkIJ8UZivkCDDsPACj4lIBHFetB+0D3faqA1dhcg2RZjb2?=
 =?us-ascii?Q?df99LJcWGk7duD3Zau7P/B6jEARkw6q6/GqgU67jKq2nXAuB/xxentC3SCc2?=
 =?us-ascii?Q?+lECnHAGu0L6OcWfVhF2Vnr4t1T1Pl4NyXzCbbawXZq86dFn6g5tBflc1D8R?=
 =?us-ascii?Q?5ikWHkNX0Jv8DlWwS58rXoiVKKBS5KQvHtSWMiwP5ztu8TcetmsKHlgj/gMU?=
 =?us-ascii?Q?eQVC4NtiGQ405zdYDUoDBIwBNDEPD8JfMARJsig/Rfbupovvi7aql3posSnh?=
 =?us-ascii?Q?bXvMvrTN173ab9Z5Rwxk6gNnTWanQ8qdb5tI1thGcslTcJb/h8KDddjElmBU?=
 =?us-ascii?Q?iEkatb+9VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rnp0+af3Uf/9XywPsbEajsAHGjInA+jyGdd3Ib3i7eje+NMoKS2Nb/vODxwCg68tATI9w3TCjlKAF3mvWFY4od+cVqAsTaRdWpjdWeEPa/5B/hl0s3DNo/i9e5g+jx83UqiylLJ1xQQn0zfzyT9R4Bz2LRILkOVG0ZeQhcIOVY0Ca4q0jsoRvQhJErYAmRmtPyFEnuCDuztP3cc6WcihVDrZVNMEn/gnxcn1+ekX8JTAD6Z0+pQXt2hRUAC2lg/Mkop+5jP2C84cRy7LRWBYNnqn1GaFXdzOm42z7Iffym7N/SWqybh69E4b/eC6EGB/hvmXcfAzvEzdAmuDDOFL7B1TcSfUzhpm4XPGOpmlE+1V6KxU6lokxR/giaE5xEBvZSA/20VgNxktpTpo75khwfDJPz0FXvHBBbu7nngWQb/S4DzclDQeWznCMT7LKD2pSKf0Se+PvyYzokQCp6quT24sPZpQa+j0Itg5pQuhKT+l8xX/AiEPcEZfJ9gYZ9dCYju0NCw2vHbGN7p33zSbPu8cU3HuW8uT0n6QfbHXiXwWz5qdjCv9Tbm95dh7HyJWNX9d7WqIPFg4f5HkDv7CgiuBnwEvZCcxemP1QMZA22o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2acba0-0ea2-47de-7ae6-08de5dca9d71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 17:36:34.0945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUbf038Y07g+PmbZctmamU9wbRIcENkO4CdEoXIQGF9vJx5c5HlFCgznkcqIPfplOlHzc09EhDaJSWErnnUMVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_04,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270143
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDE0MyBTYWx0ZWRfX+JSTySiuqFwn
 loLnLTLmnDy+QPF5xOXTajxN07v6idgGAMbKRSOXwu5um9FO7Ysr3/A97i7ILSiwLH1jccWpvE1
 9GSSMfTXaH0jpbtQ2WbPGxXvmSBgDWBVitG7z/DXW+/x5ZcK7d1iRTaVnjU2mLo52qiHq/LzqnB
 Bjq6Q70iuEC65AHnMowBxpckPA8UC1KT92XSbqevLd11qh5mE70vD7u75CM1ZfI9iHiCRAAK0oE
 XUI8a/seNpZoH735HdKTYdHIJRXqUNEUuLJ0DKJxfIjyr6+glbTrWRxtJCu1Eixv4ASo6VPuajB
 bJLLv8JvtaxbedHP6KoQt00FazIw2LbxXeFKUoxoG6dAaKVjKPDaK3Uv5G+faL5BBQkX/jrEBTZ
 n1IkoXoKBqwdPAXyqUOcGc7eqd3l8+H4RiUoQpn2i+J8km8UhrC7tSJYj9DGKozPSfrPq+u/xiK
 KhZ878AYqnn9QY+L73AwT5p5zzP5Nv60EZYANl6U=
X-Authority-Analysis: v=2.4 cv=C+XkCAP+ c=1 sm=1 tr=0 ts=6978f7a6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=0_aX6oQtOsjAA9Aozg0A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13644
X-Proofpoint-GUID: xowf7Bek0qxwotQE6-UfXlfvdobAY6JV
X-Proofpoint-ORIG-GUID: xowf7Bek0qxwotQE6-UfXlfvdobAY6JV
X-Stat-Signature: wkwrdpi4huu3kkhhz878fpinc9r3qmhx
X-Rspamd-Queue-Id: C2BEC40009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769535409-985008
X-HE-Meta: U2FsdGVkX1/GA7nMwvqxTh3oGmvn7MKcs+8E8hp3ULiuIPQYffjJ7NwoFbiuevSWkZtIesP+bPuPqx85k0h53HgRgZz5vK33claSeyn5G8WjBcDrzgw8E69Fckh23ziwd6IGICS2b1AAcc5FVl1RsRj3OOTq11M9eH3xl/W2mprUNJSSeSSH0uvdcqo9MpV/rFDKEhTUi3LzF3cPLKwQxIqafdKMBkzIEIDc4g36jJB4aOANLieOZoKpAj4KKJH5eS6nGPGJjecNUxCDTg8Kjme2yMdHljaXxdwU48mhYbTvxKDZKtVfxt/qT6XhAkQqE8dbjhXq4rDvqMrWkNUNZ4jTED2i+MlVNrxEKEhlcawbzKa+ZMqMDmi7s8DapNw38gxKJNGeMWXkYNMaTBJqu7+jywWFTpk7z/T7spVhskdo69VMFdBlcPJZsm6/iFrFSrKJysBsnoDUBT8GlbJDFemkL4ap6JBTNi/Kg5jJYiuZ9/Mm0JlUnqO/5uhnc5IOM1G85hHErkzKGGvwrXkXen/1UwAWWux+yi8VkK+9pOe8LViTDbMkg0f9zR4BDaUz6bdRwDwC39dwmx6kml9PZNPNNaTITMDhKNQf9zdSOy3W/cq81t8W6XfzvXxgj7vR9tLftmIZ8al0n7J4A5egLtVpl0idnCDWkG78mjeWPXYxUk5w9XfZJ3/ClxE5H56TFeQVhjYnNEZCmZmAnhtm2cDLpZ8GAZK/jzI1eCXdLpZznyDUyATW0SJ0XuVyh8jLX0tZ6WvfLb3M3p8NEvmMC29hpHZHtDbzRo5y0JeDqIoDvT7fGm9FHmL4Ab1O+HekM03B4ECYz3kLaoMkm2c/WaNE5HKj9r88ExeiWmDdEmFKa08j7lU2D/8LVewepC+S+2gE7eM57X3CZHELayRymz37tuuZo9diru5W99H1NjKvrxwpNaIkeBufo61cLXnM3HQKQaqYNy4iIJG9a2K
 HG2N+kAx
 MO6UZM33x0dk2qLGmxxAG8SiVr8Tv413Qz7nOTD1YXjmyxga0XZI1u5yLkxRiVsoeKdJxIxP/KTK348o4zhslErNUiQgMtXC8fQe5dIvxDcIGwk7QHOTbbsunTHapoFTbJgTP4A2YM2hZGOWIw53cB3HJufg04lxHvHIzPclgfw2tfu0/JaAMb5dDvzHrvQYUzSofHpKrXFqycwWpCdko2pu0qv1uMb9S7iaf5OYkp6kTzBJPWOH67lVyjzZzKVByN1kr0N9huhICBbqX9ZXBZw4TyODVmuyG0GGb5n7ld7eaN7ZIW/nWrhVqH8wDgSRmDqpG/SU7VeJmhq+Rm5vPZFJGXfcwjkOvzzY7SJra7ys9rkzFOJUAnc7o/yekv+nK75M7/DwvcknHQf3MSbnB/eWs8DQmDjLXDyd6x8J8QJXaD4A83bXo0id3dSxWLeGXHnmbrseXXcW49GMI2Da5uV6Xa/1eRKWSXGSZfX4swTBNBKabgfuR16Wl8FbrZFsaQjc39JNqrtCnyMzsuxe/QL41mDunY6ApGrA2bV185uUDtKZO8stp6XVl7l7P0pytuFYVPdiHJFZK3ZGfh8BgXhas4b0b76BDAngYafIjOigOHCDP5bgm6yVqjoAwgtE1Ef38UqoVS/VwnvGA8+57nfOJKJL7nuKGPUv6lbWzK+uNtPmlS+9+LjdlSz/muQK8Qe0nzj+qelF0Bw6zn/alUCpt+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [260123 01:54]:
> Before we enable percpu sheaves for kmalloc caches, we need to make sure
> kmalloc_nolock() and kfree_nolock() will continue working properly and
> not spin when not allowed to.
> 
> Percpu sheaves themselves use local_trylock() so they are already
> compatible. We just need to be careful with the barn->lock spin_lock.
> Pass a new allow_spin parameter where necessary to use
> spin_trylock_irqsave().
> 
> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
> for now it will always fail until we enable sheaves for kmalloc caches
> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

I'd rather have a helper that _mayspin() or something.  That way, when
we know we need to or don't want to, we avoid extra instructions.  We
can also avoid passing true/false and complicating the interface when
it's not necessary.

The way it is written works as well, though.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>



> ---
>  mm/slub.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 60 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 41e1bf35707c..4ca6bd944854 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2889,7 +2889,8 @@ static void pcs_destroy(struct kmem_cache *s)
>  	s->cpu_sheaves = NULL;
>  }
>  
> -static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
> +static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
> +					       bool allow_spin)
>  {
>  	struct slab_sheaf *empty = NULL;
>  	unsigned long flags;
> @@ -2897,7 +2898,10 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
>  	if (!data_race(barn->nr_empty))
>  		return NULL;
>  
> -	spin_lock_irqsave(&barn->lock, flags);
> +	if (likely(allow_spin))
> +		spin_lock_irqsave(&barn->lock, flags);
> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
> +		return NULL;
>  
>  	if (likely(barn->nr_empty)) {
>  		empty = list_first_entry(&barn->sheaves_empty,
> @@ -2974,7 +2978,8 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
>   * change.
>   */
>  static struct slab_sheaf *
> -barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
> +barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
> +			 bool allow_spin)
>  {
>  	struct slab_sheaf *full = NULL;
>  	unsigned long flags;
> @@ -2982,7 +2987,10 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>  	if (!data_race(barn->nr_full))
>  		return NULL;
>  
> -	spin_lock_irqsave(&barn->lock, flags);
> +	if (likely(allow_spin))
> +		spin_lock_irqsave(&barn->lock, flags);
> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
> +		return NULL;
>  
>  	if (likely(barn->nr_full)) {
>  		full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
> @@ -3003,7 +3011,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>   * barn. But if there are too many full sheaves, reject this with -E2BIG.
>   */
>  static struct slab_sheaf *
> -barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
> +			bool allow_spin)
>  {
>  	struct slab_sheaf *empty;
>  	unsigned long flags;
> @@ -3014,7 +3023,10 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
>  	if (!data_race(barn->nr_empty))
>  		return ERR_PTR(-ENOMEM);
>  
> -	spin_lock_irqsave(&barn->lock, flags);
> +	if (likely(allow_spin))
> +		spin_lock_irqsave(&barn->lock, flags);
> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
> +		return ERR_PTR(-EBUSY);
>  
>  	if (likely(barn->nr_empty)) {
>  		empty = list_first_entry(&barn->sheaves_empty, struct slab_sheaf,
> @@ -5008,7 +5020,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  		return NULL;
>  	}
>  
> -	full = barn_replace_empty_sheaf(barn, pcs->main);
> +	full = barn_replace_empty_sheaf(barn, pcs->main,
> +					gfpflags_allow_spinning(gfp));
>  
>  	if (full) {
>  		stat(s, BARN_GET);
> @@ -5025,7 +5038,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  			empty = pcs->spare;
>  			pcs->spare = NULL;
>  		} else {
> -			empty = barn_get_empty_sheaf(barn);
> +			empty = barn_get_empty_sheaf(barn, true);
>  		}
>  	}
>  
> @@ -5165,7 +5178,8 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>  }
>  
>  static __fastpath_inline
> -unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> +unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
> +				 void **p)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	struct slab_sheaf *main;
> @@ -5199,7 +5213,8 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  			return allocated;
>  		}
>  
> -		full = barn_replace_empty_sheaf(barn, pcs->main);
> +		full = barn_replace_empty_sheaf(barn, pcs->main,
> +						gfpflags_allow_spinning(gfp));
>  
>  		if (full) {
>  			stat(s, BARN_GET);
> @@ -5700,7 +5715,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>  	struct kmem_cache *s;
>  	bool can_retry = true;
> -	void *ret = ERR_PTR(-EBUSY);
> +	void *ret;
>  
>  	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
>  				      __GFP_NO_OBJ_EXT));
> @@ -5731,6 +5746,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  		 */
>  		return NULL;
>  
> +	ret = alloc_from_pcs(s, alloc_gfp, node);
> +	if (ret)
> +		goto success;
> +
> +	ret = ERR_PTR(-EBUSY);
> +
>  	/*
>  	 * Do not call slab_alloc_node(), since trylock mode isn't
>  	 * compatible with slab_pre_alloc_hook/should_failslab and
> @@ -5767,6 +5788,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  		ret = NULL;
>  	}
>  
> +success:
>  	maybe_wipe_obj_freeptr(s, ret);
>  	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
>  			     slab_want_init_on_alloc(alloc_gfp, s), size);
> @@ -6087,7 +6109,8 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
>   * unlocked.
>   */
>  static struct slub_percpu_sheaves *
> -__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
> +__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> +			bool allow_spin)
>  {
>  	struct slab_sheaf *empty;
>  	struct node_barn *barn;
> @@ -6111,7 +6134,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  	put_fail = false;
>  
>  	if (!pcs->spare) {
> -		empty = barn_get_empty_sheaf(barn);
> +		empty = barn_get_empty_sheaf(barn, allow_spin);
>  		if (empty) {
>  			pcs->spare = pcs->main;
>  			pcs->main = empty;
> @@ -6125,7 +6148,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  		return pcs;
>  	}
>  
> -	empty = barn_replace_full_sheaf(barn, pcs->main);
> +	empty = barn_replace_full_sheaf(barn, pcs->main, allow_spin);
>  
>  	if (!IS_ERR(empty)) {
>  		stat(s, BARN_PUT);
> @@ -6133,7 +6156,8 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  		return pcs;
>  	}
>  
> -	if (PTR_ERR(empty) == -E2BIG) {
> +	/* sheaf_flush_unused() doesn't support !allow_spin */
> +	if (PTR_ERR(empty) == -E2BIG && allow_spin) {
>  		/* Since we got here, spare exists and is full */
>  		struct slab_sheaf *to_flush = pcs->spare;
>  
> @@ -6158,6 +6182,14 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  alloc_empty:
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> +	/*
> +	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
> +	 * easier to fall back to freeing directly without sheaves
> +	 * than add the support (and to sheaf_flush_unused() above)
> +	 */
> +	if (!allow_spin)
> +		return NULL;
> +
>  	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
>  	if (empty)
>  		goto got_empty;
> @@ -6200,7 +6232,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>   * The object is expected to have passed slab_free_hook() already.
>   */
>  static __fastpath_inline
> -bool free_to_pcs(struct kmem_cache *s, void *object)
> +bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  
> @@ -6211,7 +6243,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
>  
>  	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
>  
> -		pcs = __pcs_replace_full_main(s, pcs);
> +		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
>  		if (unlikely(!pcs))
>  			return false;
>  	}
> @@ -6333,7 +6365,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  			goto fail;
>  		}
>  
> -		empty = barn_get_empty_sheaf(barn);
> +		empty = barn_get_empty_sheaf(barn, true);
>  
>  		if (empty) {
>  			pcs->rcu_free = empty;
> @@ -6453,7 +6485,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		goto no_empty;
>  
>  	if (!pcs->spare) {
> -		empty = barn_get_empty_sheaf(barn);
> +		empty = barn_get_empty_sheaf(barn, true);
>  		if (!empty)
>  			goto no_empty;
>  
> @@ -6467,7 +6499,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		goto do_free;
>  	}
>  
> -	empty = barn_replace_full_sheaf(barn, pcs->main);
> +	empty = barn_replace_full_sheaf(barn, pcs->main, true);
>  	if (IS_ERR(empty)) {
>  		stat(s, BARN_PUT_FAIL);
>  		goto no_empty;
> @@ -6719,7 +6751,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  
>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
>  	    && likely(!slab_test_pfmemalloc(slab))) {
> -		if (likely(free_to_pcs(s, object)))
> +		if (likely(free_to_pcs(s, object, true)))
>  			return;
>  	}
>  
> @@ -6980,6 +7012,12 @@ void kfree_nolock(const void *object)
>  	 * since kasan quarantine takes locks and not supported from NMI.
>  	 */
>  	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
> +
> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())) {
> +		if (likely(free_to_pcs(s, x, false)))
> +			return;
> +	}
> +
>  	do_slab_free(s, slab, x, x, 0, _RET_IP_);
>  }
>  EXPORT_SYMBOL_GPL(kfree_nolock);
> @@ -7532,7 +7570,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>  		size--;
>  	}
>  
> -	i = alloc_from_pcs_bulk(s, size, p);
> +	i = alloc_from_pcs_bulk(s, flags, size, p);
>  
>  	if (i < size) {
>  		/*
> 
> -- 
> 2.52.0
> 
> 

