Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25CE0CD4F50
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE388E000F; Thu, 13 Nov 2025 03:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F578E0003; Thu, 13 Nov 2025 03:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E868E000F; Thu, 13 Nov 2025 03:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56F748E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:37:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2E184D41D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:37:27 +0000 (UTC)
X-FDA: 84104929734.06.D066143
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8086940003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:37:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ci5sFrxE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V0hNnZ+d;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9KcUaYvDTANOA9ROjagm1pavlv52uewzhYIEWMzGNU=;
	b=s4owPWMJI0RYJFy7w5DnZV3l0yKzUeZSC9Va9LEtIWGGcALSc0U8fDWDMZDIMP2UM8+4Fh
	WbL9pCRIE5OfrKzdh5uBLCWA1F7ACNuESvvp0hw46JKSBWtU2bvX3vE63DUGb9ONAxWgrF
	KrPpMe4osfVl/N2OiayhDXC/ddfcwUo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ci5sFrxE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V0hNnZ+d;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763023044; a=rsa-sha256;
	cv=pass;
	b=eNmHnNCCigyGdQ4HP4k729JA8UjMGHTr3K6mswbsE+6wD68RV4lcDMSOTEttVh0F0+bzW/
	NZudNtYOUqEW4ghS2EMuc6H+ruUiJPVRcK+FkCPW2XL8FPCpf/Ttotws3Vv6geHqgsnFci
	KggDf+rLj21+vFRroMVvOHnX1m4yrMs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1hvRr022199;
	Thu, 13 Nov 2025 08:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=C9KcUaYvDTANOA9ROj
	agm1pavlv52uewzhYIEWMzGNU=; b=ci5sFrxEgw6evh8F+52lxTPdfJmDDCxy2B
	l3z1e5AlU8JnQVVDqqW36b8aW3IBB7+91WWKiHKw0IprkpugN6nGbbJxZP6FCwoM
	5nMStg9kOf990bfFhXYI1DgMVmpgfyxHR0wJULUGFnMfG9JyAVcfoZX0n4N4Cu/x
	AUp6QsdkBOB2VqOB5v6Kad5evJwWWCCs/AQ9z6b6oFC8jb2MulzO1dedrgLgISE/
	Xbgh4vDwQ59xFNfmY/3btelvJOgwuVue8njRqtEi/nLkfgjkw9JaGWOSX1wHf+O1
	UvAQM4K78Nr9jIjwFY3A2n7BydgeGhcz8UObH5/MSi6zjCKpAHnA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyjt96b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 08:37:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD7Evq3029139;
	Thu, 13 Nov 2025 08:37:14 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011015.outbound.protection.outlook.com [40.93.194.15])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vafvewh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 08:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0JcCPkPyUcmX5TL1gPvnUA5qtkilte7ryqtqTIR6pZIOzAhIgM1up8zekUJmdkdciii1cp7xq2mgl5A8SGq9dgGr9zIlKNdaLVRcUur6FXxQ/JXII1GYkCJWnRQDDiQVBIsdbIIFeMOQiY10QtdhXNClIgBirQDkSljeuoauJPhHwelpXgU4g+D68e1dSptvx/x8jUGJ7HL3F0U0+d/HJJddVOTxx4ka+vk9b9evkYTXE1V3JHSaMmT/gkzufiWlOKhx5al88zxkqdqqpDB4fw+vrckvVUS5rE9kpGiSqRTgREFUWgFPjqg6TsmaUTmL1imumv0YkLJjJuSUYHOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9KcUaYvDTANOA9ROjagm1pavlv52uewzhYIEWMzGNU=;
 b=GsiWx1AfTGOljCRI1Ct5hxH7X+uIlTPxlClSewZ/FqVgjt9jWi84FA2f2X0HzTGioTgwPDH6C241jaCMSMyUmRmTcb0VapqAGMmq1e8yy+OGajR7Uwgj/lTcUeOHOE1omPqHG1B5r/yyaKlv4koWtXu9yKJW0Z0232MOpnkiOLHqh5X9FIFq0vZBFF3GsGMThLlBSMkNrzTnoZ4YH4FcsYfsvvxrs3tIS/PCfYiRDoN0eg8/QFSjaQrlbaFu0P/R6niOWVJhHK4qjXT9gImIf2UadFqU/B6yuof4R7QicncAKoFiQRZ8fzcPE4qr0b/jNHSDXgQNpJiBRQj21BXSpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9KcUaYvDTANOA9ROjagm1pavlv52uewzhYIEWMzGNU=;
 b=V0hNnZ+d2aiT/feCNZgd99/EnEjDDHHpd8TgrkBtwhmXZKumGyEFchPezfAff8ALnHLScePM4JpGvcPLPXabLycxz0O5vRPFYRypeucvDT1GVrlwIr7F9dOF08OiX248d23Vx8haD2JaEmiq70yXvFgq1GLKzEUsuA1af5DuQ5E=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 MW6PR10MB7637.namprd10.prod.outlook.com (2603:10b6:303:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 08:37:11 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 08:37:11 +0000
Date: Thu, 13 Nov 2025 17:37:05 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Baolin Liu <liubaolin12138@163.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Baolin Liu <liubaolin@kylinos.cn>
Subject: Re: [PATCH v1] mm: simplify list initialization in barn_shrink()
Message-ID: <aRWYsexGnCmTVut9@hyeyoo>
References: <20251111122205.29940-1-liubaolin12138@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111122205.29940-1-liubaolin12138@163.com>
X-ClientProxiedBy: SE2P216CA0141.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::10) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|MW6PR10MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b65cc9-9077-4f4c-b369-08de228fd6d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZZ8+554sKO0Gpo0A30Tg/k8SHOivcqnByhqNUqVZY8RQtuyr2PkrsSCEydK2?=
 =?us-ascii?Q?zFutDJB0Xh40rFPuNY4c/+g3Ul7ZRYaN19Z5nhWa5kwluYme+VbuvS853mC6?=
 =?us-ascii?Q?L2TpBD138Oi7kcvMAbKokX2NKsJYgIRZ3FzplagdBpvbXRY67W558lGItm41?=
 =?us-ascii?Q?m6NIQyMTQgHkXgTwbm49NOwBX7UyV2NTpBu/EZ4asMlRIsiMyx0kLV8Xg6Mq?=
 =?us-ascii?Q?0mXE2yV3fcTVz2DY+RjSjNr4JQSIO3Ve79zTCgwfracf8KprZE2YOzCb0Xb2?=
 =?us-ascii?Q?nQSqGPjPBdwZkF3mTeVx9FibHTqwQmgFiK22MOaLGCIeMfgRJWQw9RTcYXuH?=
 =?us-ascii?Q?ULgyDii/fwEPD8SojL0j43QqbL3Kh9x+wXIxx+YTjZKp6Of3dk5MWP0Ctek7?=
 =?us-ascii?Q?siKFW8Kk/laDH2dpczS1j5yUMQuCYk5cASz3CIN0JLMuBs3jc7doRnBUhALp?=
 =?us-ascii?Q?XBqth+HoyVjyUW562NhJIzYTt5MYXBt5h9WRNYBbE/O0WlRgpaxq9UlcKN6/?=
 =?us-ascii?Q?UrwEAfZonPYnIVlRlDw9HFw/7wCPafkuo80iafxJvE65tWDOvf00nhL2vhRb?=
 =?us-ascii?Q?ipelJp0VgMPrTxJytZlktfLHlliS+vu2Usz96EU8f2+Zqh4kqH9JnV7JwTJ0?=
 =?us-ascii?Q?uGkpLzb5xpg32PhznPbTyCwH5u3/hzVsiF0J9ZLWiwcq2YIVh+jK3Vt/bLss?=
 =?us-ascii?Q?Wh3Qq+NtMjlZHszl2DjhXlBY2tHfJ4uTqchK89dj0lcaQnzrtVwiCs7cpv+U?=
 =?us-ascii?Q?PG5qhMswr5DZr0b7pAKGtd4eyipA8v2p/z6ynMx3ygpifgSE5hsYTukoweiJ?=
 =?us-ascii?Q?mPjNxyhpjuXCAj+jN7PKHt1BEbi2/Z/mctdJLkMpoLhu6r9FYYKp6ZsptLor?=
 =?us-ascii?Q?C45rJpKbV+ciOFq5bLlfZWrifh1wLw40y5mCA+S531LJfe1V0h82wuR35uxU?=
 =?us-ascii?Q?vbTNlCdImJtvP0w7kdKo3GI2RQYIpGtWa+F/qdil2QASZ3mk8fJ86bgsHfRP?=
 =?us-ascii?Q?GtX+dEGZ8UdZBspu1AdRe8bwchbEkL15iWDUUWcKivSiv5tOMMAcl4WApcd6?=
 =?us-ascii?Q?o319XPq4u6slujcKPMPAvpG0v42zxr2A5XXoc9AafR+54sTYh7wplDj2/c64?=
 =?us-ascii?Q?v9639rAF5r3HkZIGaf1df03lLYEhsog8U7KWEHJMPHukxamDwEK8jYGaorcU?=
 =?us-ascii?Q?gxbWrHADIQCLycpjSeZhe/Os17gOmDu3q0BtFQS95aIHu3hG+tplk6KPHDvD?=
 =?us-ascii?Q?zPusLtBay4OfuRsqgQOZQxq2sc/KAfT31t/UG1+0fOkmaItXHkEU9OYkj27O?=
 =?us-ascii?Q?vWt3a9Yw1YD3rw4XaHb9PHk6MJ+t+gJKfg0WCjOeG5K9JhVomJa9XoDjQW0o?=
 =?us-ascii?Q?mZDvuAaipf+22VslByBYYOHCMhaMd1+rFlEI6S0JgMpii/T096cjoqT5WbJ6?=
 =?us-ascii?Q?6X1/KOpH9z/yWX6+50XBL9rEfg4t1Xh5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oVxzdYz4FomEK5iCnxYIAFq9h//rn1kD6WdFG8UZhzk8Qtl4PDNa9fnwgXrF?=
 =?us-ascii?Q?cqySM/NxnBTCsz2SKE3NC1UQEHUjZ0uQ7tm7q1bvjhdZ/2N51Ztfh3Lr6lth?=
 =?us-ascii?Q?J3Pr2JqE5wXAK2YsWF7SOiYSCZCPZKJKKFCbG4+cWvw8hsJXj4hyPEoGWzvA?=
 =?us-ascii?Q?UXiOuYJc1wl/I5U9GOTE6M1mqvWlWYzBhluyRwTPj4QAyERDGV8cBEWT4xgO?=
 =?us-ascii?Q?bvTILOgMiI363CVRa2KOVbpljX2r5UB3aoQXWg9bYYWLY8gLIK67bsCibXdL?=
 =?us-ascii?Q?EnzP0AQE2X9/k6ZjMIRtBfJTlstXvBIKHCao/IyZwUxhfyNdUxkbqX1QITmU?=
 =?us-ascii?Q?VPQG2abVEpFnulD24E5D8BErT/1KP24adiFUJniCtxMPXa7vacOTt+hsKG6y?=
 =?us-ascii?Q?Rh9hHiMw9NwpnAZXNNkSssoLV2jZFd0FtmdbWfHL60GDmNoeBqo0OLTi0kvu?=
 =?us-ascii?Q?dKB48HHV4x+9aZujWttFTmmHG1DJ1P5V4T86pP10xZEoIh56ANEKrLjOG2py?=
 =?us-ascii?Q?4XxMLBpXMyMKaAMSxKDtnoBJWAaiRBOwtd+S0gIh1fiAb65K7SLq9X2V1Dq5?=
 =?us-ascii?Q?Wm5pWYBlTcYV07azxz+zdIdIe3Y4wU12omnF7QCZs8I6iDpdgdztQ9GDizUR?=
 =?us-ascii?Q?j2+rQWizWYHjN72Vm7f2V5e9y+SMZa9ASnTCyEQAjDEyXvBRcFRM/nCbe67i?=
 =?us-ascii?Q?GpxPv22PjgqaTyXDVJD92WkvGftsX2BK1V6nEQrXaUYZuHBoMEATNQ1vtJdd?=
 =?us-ascii?Q?CauYNHzSp2wgti3vicANjga811S5LWZtbqESMcIPjyTSVvslG+ndnFvPByRk?=
 =?us-ascii?Q?YoYZiy2A2TslxXdDHpuB6v6gCs4Eb8KN75vrirFU9RNBKzgRtvpgIimlwAjI?=
 =?us-ascii?Q?dAl9MFrH2tDocGy/W/ORWRaQoI0yRfQsf9BMj/sg2hXpXU9iSbRwG9cmKgLt?=
 =?us-ascii?Q?1CE6fYu2b9ITz6M49cRhtaEPzzJ2nXnrjMLnMkvaqC9xKlYjiMq34/rP2jtm?=
 =?us-ascii?Q?6GZNKQDwpkS3lF35FgepU6FbpieDRXY0SDn7cvdOt+2CtjLvXXxADIJpE8og?=
 =?us-ascii?Q?54JL75iStgoUXI7IJNvY3X/NWBeXkujN/1iYFOiunXzqxQlbanTgrhWpHnwM?=
 =?us-ascii?Q?40NVDmpblb4qIsWvMY15uW437VjkG8RQEPyZKzzVxSOLtCRSUBAZSuu/f8US?=
 =?us-ascii?Q?gpPJwuR4aDXxWEZveoQsJukbcb9mrXldI8p09ZdXTu6JsF9AcZuKezpbNRrJ?=
 =?us-ascii?Q?UKSTqd1AgDcxP8BsNMn02UZUQwRuuIYY+vFzx6OboiUEP0MFzSOpPUOoafSn?=
 =?us-ascii?Q?DQ02sEwP5AVnkxlmuNrijD8wiDMXYiudqJhDj9onwuuQToTsvEov2TJZ4vmN?=
 =?us-ascii?Q?1CRXS2Wv5pptCowZKH31fIcUtfb2rigDrlrDLdI10P3sf1C/UwtJDRIsgYGL?=
 =?us-ascii?Q?Zp5fWmw5AQBOkw5kz9znVXimEEw8JXpAw2IKGUZzoP2fZSJbvxRUmw1+ZnX5?=
 =?us-ascii?Q?B8R0w/7NSP83zivinY/mTGxUk4V7my6+hxqFV9/NXi05Z45JRiezQng5ZjXS?=
 =?us-ascii?Q?qaSgKtUSfuN4Q15p7SgLgjsHfuc4rPfIb2hGAoLEeVbAys/8B3ROH5Fnjqr1?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1bDAKrhqqEwBnzq0blUoy4gOrZjxo0JmbmAZ9gL6hzk/jIGOLfm38otGNjxXRESZAX61NiLWYLQPemZLtlEOGVTKPleRuEdT2X0w3syvxryLv/ZA23jnhQcZC8y6WcV+QA/U97iIUGJXH0jrdp9cDl90qC9YuHH8yBWzvKahszw3++ESUCCHjUVx75mCE0KqamrrKtS/ibKnOVgiiCvMN8A4eeE2NoPTwPccS4T6lqAxTj5RiFoiY5sOFTI51rYozFiP/fqfJPP9rG2sZGKf0ZgkhPLKHJJIa5UlWFFp/Yfyr/cizoULoMgL7KjDP0tIUD/TbpYp+UiH3iRNDwqz95J43YXqCMcoDP7BBUZiHJcPGcYKVGpS6OVmqmX/yld2RrPQAI8UVeqvXUYbDhkmy/pBcfq7D0C2a3ekUDV4Qaeu7f+/JJZgdT4ZZIIknklzS95i2VvJwtw3VUEtWL8Tjt77kPy7pXnaSj1237lFE/xMQs9GhdVqZctDrCcKEwYGmJdAyEaZhj+xsoSQzUaVIPX1tWEQRL9K1cYp7ojJ5LiR1akvhvQvUTsbW6wPOHzY4ekD2rHOoSNdMNEaJ6KCQgWAqUkS/lw+o7+PljZf1sg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b65cc9-9077-4f4c-b369-08de228fd6d4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 08:37:11.4551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhgHTVqRwznHRRQvK/vh0JyK0NOVvYNgLu082u/CGQ4Sicfj53ltfw5s0g3LP+y/jlKPAQUVRA8MIs0uYaH7cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130061
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0OSBTYWx0ZWRfXym3zkowUxNhK
 bnJ2OrAB06Zk5TjlalzKyoyeMxikyYdTvbpHmTOsdOzInV+hRFxaSQoBR3PTTPnE2lscU72K7Mv
 2x4nzZIweRfiQMeHYLGQe8CvVuwjgyqGZx7vPClrshcM764OzLuvjU9IA3H/sc8BED2+56azt0P
 hBsM/MK+uREnLrLdmeThT8f+vNA9AyD3/j23mrigMCjIqHj/SzPDvGrhB/B2/QFlaG0gWj7EPHG
 d1K91BbCL1Sr92vt5q29sDMaIas/A0mmDsODaT4shDNZZQzPbtcMr9kgh4k3NpyvzjGQMNlYVpZ
 f4fDPsUPjd+F8JtkZzJnj8RXVoZCcBpdAJxMFDK0m4oYCOYHDvm2k31jlQpBawOs2SdV+AiqX9G
 D5JnlRuVikon8h+NPL5a6QSmuD6x5DZiYjqEubB3u5Lj4ZRcqtE=
X-Authority-Analysis: v=2.4 cv=S6/UAYsP c=1 sm=1 tr=0 ts=691598bb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=QEAugTGhsiiaq8UDkMYA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13634
X-Proofpoint-ORIG-GUID: iXxQL_4K5WEy_idfDQp_k8sx1EM069_q
X-Proofpoint-GUID: iXxQL_4K5WEy_idfDQp_k8sx1EM069_q
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8086940003
X-Stat-Signature: fs78xdj6dk455968jeqrf8nzhx1tn9jt
X-Rspam-User: 
X-HE-Tag: 1763023044-542388
X-HE-Meta: U2FsdGVkX18C2q2zD9pwT7oxKmLyZVH9tOGiFOAYaAR5zyIpVX/YK/aiS5jcaDweCvn7KTS5fMwWahijrD+xwwzqkh5IkCLELmkHIVuCODdTeqScTDQsj2br4OSlHFuEn6bIBWTIXS38up0dOJYiSAR2AvDK0xBwrXIBZJptnBTLTgKtG1bcNfZIq/Jcd3uYPHvTEYndqCsS5YDSzQZwm0g5zk8fB0vD3spnZ6eZ/dfKi/UpmdQueolnUMD/Gp5QX6HGzKrip8Z/iCi1Hb1guLRfiPrHBeeIQzuRJg8ctSZkgvAh40BJZzw0G3CLn7ONa9lZMZVuYPbjzIXGORmC78aYFFssMkfLzI3yNLVNQ/xrNuprEISfozqjql2YqUaU2vW7XCeGDpJ/fmMZcpJCX1ide9iNKDHyesa6j9KhU4scZQ0hHK0LqLebQbvR8KqQJ1w+/A8NZXeKPp2plFHXryeF5c6StLFeHb+n6kjNRZpp03l+IrwIND7J/nML6y1oWs9eVswQW4swrqLZbga+NNe0vT9kwIOSknEMZOaezA/hVKml0SIjLd9V6Fme9yfON4lS0GvB/jbsYEyYRdDCmmfq3Nc8OI0Dm/u5K/NQHAOWSxJisKUkDigwqTS5MlV+in/RgsceLtrsLirxNkqVDVM2/kTyO92pZfuU+/LKpUK0A6XYs8BRBCzCj7xftZZuRu3KTXyNiV6cEiUAamiXU0sh/oBdRpWUbQ3RCM7Qo7DRBHZpXMG7hx1sqZ2hIZh0Vixnt/zwl0xYnqCu+Kmdl+b/o6MI0yi4cx8TFHpRagLQvc4x+1j3uHfu4Xbdd5WOAkb+poHG+/yh2IVECf/oyn6S9s2hzLAYKahW9BqPgzKOUl2o6cqwixn2oSlCeRW5E/gHR95xyZ8tYJ6/ooIf0aOgPniZdgEiHKwr0k2SQ1x/Pia5ZmYg/OOR5DD9XgyAxi2vumpzj/A/E1D43Vr
 lZ9erN51
 V0XSIZdRm0f/afWve+mcPtzdSyNT1rwGGY+eC5ScjIlQgHpwmKqP3LQoi14u200fxA274ux8GIqpmEgIA7AsW/0C/Glbc+tcyx8OspixBLbrSXpQPdT7YSo9eEp0yAtHV0uFk1ihd/k82x03v8BVt5Yxf/aiksxQQ7Te8+RNHgmRZPzXVMHZeKyWBPsN+cRrr0SNYhJcv+IFSg3+3At8OvW7aBXKUOtLbOSe/EdeoeErc/yCbdDefa15zP3wOJ4ENZBnyQjFQJP50RGRRbIXF8Tk7/mvyZxTsVXifrpek8w/H9eI1ecQIxxZGiiAmo54xji2y4v4Su5E6iNguvEH4fs01BGwLbda/QRHjgwyhV+pGsfXdh9/4r1Oh5++I9yFDz0VkLeRvIyqFjJGylfiQ8tfLErm0U+bXtQUcvd9WT7uNl+sQU6tjF78vSsyLdhy3i+wqDI3QkETcqZlCF5e85snqED+6bhl9OOux+mj7LQcZf8UN9mUNTz+B0sIZSjz6twtoOgZeL+aZ/acEc6espj1OvVyVmSVFNcEKizwAe7Lo+Api/Y2ZVUamY5snD2vDgx+OaspBH8XtbL3lqVAVkd/kuVKscwx7CJJ+nc7XyYgsD3utbM6/gym2osqc9R+X23N/cw3mC9sz5E1awFMG5jcuy94Cb8wv5UhNGazaVXICOWUA67TjV2fz9B5Ezx1TmHw8YCg0UL2LH13Py8aGc6lJRE65BMf4evDt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 08:22:05PM +0800, Baolin Liu wrote:
> From: Baolin Liu <liubaolin@kylinos.cn>
> 
> In barn_shrink(),use LIST_HEAD() to declare and initialize
                  ^ nit: need space after comma

> the list_head in one step instead of using INIT_LIST_HEAD() separately.
> 
> No functional change.
> 
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

