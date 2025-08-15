Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BFBCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D338E01E9; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4F18E0002; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195908E01E9; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 071CE8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BE3083A6F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:11:37 +0000 (UTC)
X-FDA: 83778575034.07.46E30F7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C180180010
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:11:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ij1cxgZt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Op1jaNtM;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755252693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1L/noB/eFMqkzOfr59ax3ylhn7F/Lt1lWVCStNFPyc=;
	b=xJ2LI5eNC/gepdXFWElysSGQ87OGFTlrxScaSg+GqTCvi0t44vqxJVbb5M0tYkdJcOD4zY
	cF6jRLLr4kOE3x5nNsIfJSSdrKaJ70IGxbBD0Nr+j5px48OzpYNg6h9F3XlOg6bGJ9XumS
	a0xiic6O8BP7T2TZETCKlOD+K4Vei9M=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ij1cxgZt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Op1jaNtM;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755252693; a=rsa-sha256;
	cv=pass;
	b=oRyVwUxHboXQtuArYCE44nhA+KhSm+rBkdspghOJ9eByHgSMydL6nFECBjl5fa4mJhzYGt
	KE0sMvXWJs0W9nUSmUY3+a0bwqKosGZztmCw1fnskCcCcbQ6OdXGCVAap7Hyy4+2BM8RK/
	mdIgnXoT1zvr3rub1s3WnbaecfmuLkc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F8g7H8028636;
	Fri, 15 Aug 2025 10:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=T1L/noB/eFMqkzOfr5
	9ax3ylhn7F/Lt1lWVCStNFPyc=; b=ij1cxgZtU+sF3wGlxcxKF0Q623t+ijhYZ0
	xxDDhmuIs5CvYHUVblNWdsFAliiv+NBELIIqlVoF3ifZ0xQga9+/U7hAfPsRsvYQ
	ssxWtA03FthTuSM8qqDBeQMferhwbZw3glMeFJf0IHzmej4Q2meL7VIKny9rB6Td
	G71jw8aH1I+X7kkVKghIBZvN81FJ+Xd0jArNg+lSRX84CbmUphC3OpbVIUUrmM+a
	zzN8NOS8/ZfWCqz8BTO8P7FaSIX7Jpj/Knktw1YJ4VDCxyYHnBmhOt9vkZN1qvZJ
	08sUPJS/dIMLU34Nr1z5g+Y73CqHprcyU16dUz+CQIR8mJ61GpNw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4kr4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 10:11:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F8CeDf006593;
	Fri, 15 Aug 2025 10:11:30 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdnr5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 10:11:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YiHUf2J+/hkl7j4TadcU8AqCucAmXeM3fl299bIR/PZ8FrKn7Va/BRyDKKd606ys82JoS1nY+yUnPjL65Ux5cSMJZ1wVNm8k4RIdo5OzvYNsgFSvo21FCxygCH8zv5V1/3s51XAHWT/es1zf4ZN0Ib98sf7FtdwC14TkTrFXWfgsP3+UXM570AOLvDaOHaEMicdmq5aJN5HzoOXY7w0N5blzldpdzWwcd1rMJgJMv16TTmH6N4vuYuBQhOpXNEUQflQVM/MJjEyo/TBMKCLVFPuAvAGXpyd3FZYd3nmo/1ykTMtXUfSsO6MAiW35E0GJTeZkvFslMIXJdgB9rGC9eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1L/noB/eFMqkzOfr59ax3ylhn7F/Lt1lWVCStNFPyc=;
 b=lhn5doig5fmzzsgIsvOGIgjWErBoHXsPlaFmhF6qPNtI8pbblWTniCfuLywHBslv313kDBwO2lGU6l7s21cNx7MyYjyCuGgaKiM5Ohoh/CEvDRLwcYpFn5271QRPjtNyecc+EmRUHbWrqlLtD+oalXhFNH4LahO7rhG7h5N76EsbdLUa0keYz7QClEzTfsN9EYl1+99AbCls9RUwXiJYKGybeq7GUVJFFiXS/Tj99VFlW+Vqb4f7TylWvywTvz2m2tfgrwoMv9V+LEHtyhPAK8E9ynZzK0lt5VfwN2MWznSXd/TUMkTz4oFhDyLCRrrJPN/Cz7tapD4M8OtoYu7++Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1L/noB/eFMqkzOfr59ax3ylhn7F/Lt1lWVCStNFPyc=;
 b=Op1jaNtM+bOdanCeOvmoJkt06yI5pbbBdEOywml1r/yucUmf3pFne4l4MaB3KgpYXqpyt9JqtlyXlqdp+z10SxSdobDY5VNN/MLqWlHFefyG20t81MdSGlZnUiJp9cIISJSuqKqvvH1HY8N7JMGvL2jZHVJ+9FOwHh0rVa21QeQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF424CCE606.namprd10.prod.outlook.com (2603:10b6:f:fc00::c23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Fri, 15 Aug
 2025 10:11:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 10:11:27 +0000
Date: Fri, 15 Aug 2025 11:11:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm/rmap: small cleanup for __folio_remove_rmap()
Message-ID: <d9da4b04-7537-421e-b712-5e694056893a@lucifer.local>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815084943.23063-1-richard.weiyang@gmail.com>
X-ClientProxiedBy: MM0P280CA0116.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF424CCE606:EE_
X-MS-Office365-Filtering-Correlation-Id: 33167081-b064-4389-9cf8-08dddbe418fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lc1b5yMAkRve1/q+NOZHcQshhU4jpvCn+DzuJr/rvENQyyaH2TRRvF9OSDNt?=
 =?us-ascii?Q?xVtIM59Vn3o9SGBjNQqjwXDNpQN9A+dnyUquk+QX/A4RagrIYSG9QS4iBUHv?=
 =?us-ascii?Q?y50cWTvA6QwAJi8so0ZS3czhHO1pMcZqSe+ktsn0Y6OXmrqSxEe0slr6XMMR?=
 =?us-ascii?Q?atFUJQ3zxFqkA99FX0hEtxyxgfr+sHLmpCjTp6sAtGWmggdUEUdXOBC0LdTf?=
 =?us-ascii?Q?KSoz7GIRnAx1mZtH1JZRcWD5nxFdNSG76XEetMDpTX837VLf1yLY1shynLHn?=
 =?us-ascii?Q?W5hY1P6b33FPQD/la/DN7DSZ3S9wK6u1yHqxLw1WXmyp+XAX+W79/cCpYcLt?=
 =?us-ascii?Q?w8Ut+2QXxtVsBFWDxtpDcdbQrbwqc2IeHP1E18mASevup9g5MsHVbs+16hIX?=
 =?us-ascii?Q?NNS1G9eR2ZuvGR91YroTEt6J8kdlz7o7cRf/Jgz+pJKOAfThz1zhAC/N4u+8?=
 =?us-ascii?Q?ccav+JGLAxaF1vRFdpm9iXcd6R57BqdCbRoyLG/z3swpkx6tHZlKn3yOcGuw?=
 =?us-ascii?Q?b7T51ezDzAvj4ADpvs15dE570KwrPOiMKtXXrgcBTVhuI1AsiPLWJMZMJHXd?=
 =?us-ascii?Q?VrfxTEuGzE+sm2ca+0V++H7obnPMKVA+r5bjDr0rdNcLDu9ipV/d1qmOT6iK?=
 =?us-ascii?Q?BwJhb4GDYCwgirLHBlNX9V8n3V+TIKkSuKs6vaoKtGfOCZQ23ByzTFGQSA9k?=
 =?us-ascii?Q?GDGkfgXaJexRFi3+MuvdllCvAJazVVvC+QcGTE9NZy1+SRF9HsT/Aj6oLsto?=
 =?us-ascii?Q?lTuW/bAHKJh0E/706kXdMBDWUCDzC2qEgjkpkEv7amSUgzO0NMEugDUzxoQV?=
 =?us-ascii?Q?Km/zh5BbZDc23MbiQY5IdfCV+3d4Z7z0a7MxORI4veI8MGDk7BNxBOMu1PwZ?=
 =?us-ascii?Q?UHnTQ3sTF15LyjdF1OF6LMLJA85Nm6r3TnSjuAig6p4de4qWwhZgfcx9qrAY?=
 =?us-ascii?Q?73UhquoAkGOlpf9wOTtIvms4Mz1Iue3SJi2EAYDBPPJB8AQF4i/j+slvOLeb?=
 =?us-ascii?Q?/wB7jfTzjpazCInHPYLENEUgX1Z0enZycXmUg35Lvb1q8uBtMCrQTsENibtZ?=
 =?us-ascii?Q?l2K9a7Mj0jx9cEcsvtqWs9r39WOrYWW0EMNPrczrQyJKPb6W7bxkVjt9JTCq?=
 =?us-ascii?Q?2HlpXC2D83O5Fg/lpOQmBcpx9b/YTzLXs2eBFbTs08by4ZIjSwspKa7mIFyT?=
 =?us-ascii?Q?anJ3FBDVOEiSCu0KN+6MefVpJ5x8WD9uCnjttr4mpcOL4jOA5kV2ZwXBwrSw?=
 =?us-ascii?Q?cQ7b/PdetAxaVJbLj098Mn7ZMxbgG04JsKSym9ChgXcGGb5Km8P5L2TRtutT?=
 =?us-ascii?Q?LpeK3E/jx++ja2BgYIkOPyrD2rixsnt4rllPTCVqxuOvQ2K0lsf6j30VIA3l?=
 =?us-ascii?Q?tdw+5Wq2NPCbfhwCpb3sND03RH1/G+13dw2exZY5pDBvmTyz311Cy2kGThEo?=
 =?us-ascii?Q?ZbEmoTWBsIM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IwZxHaLuZTyqgAPFwKp9dCYHLhkt80RExN8b8y0ZnqJ2v6QNUoRDaWUrWoX5?=
 =?us-ascii?Q?TeDDoiOdfXUQEYtLLzPuvkofh0ZUHW2RKs/oEC74EEcYevQySPN6N+8ef0Z7?=
 =?us-ascii?Q?3OP/snTAq3B136cD/l8SBYPihBopYHLMJDPSJntrr/VvZiGKy7KTCYpaylau?=
 =?us-ascii?Q?qOJdRUtRZG5twTv/lRyJoLQjAuvW/gRzhQOfJ7MW0XVtwGqe9TQ3/orqLYCg?=
 =?us-ascii?Q?tuU2u4Vo7al9nmfwuEX4yXdudt/EnOQinCUdfarfZpl6B97C3kQXeYuEOUcc?=
 =?us-ascii?Q?XWEk1nn6uEuZc+ObJsQFZsAGUWfRdkgsw33tdJrukkho/bmXFcC0431CJuHf?=
 =?us-ascii?Q?z88JzVTshcve0ecEoUnwV3A0DiXjW5sx2HSJMwDvT7X6deIAWk5frzogXzZQ?=
 =?us-ascii?Q?2e3Edp2wfDAtu9I01MorBaJk+pOp24XuU4bpu+U9e6GQMedo7uOX7Ya8mgvF?=
 =?us-ascii?Q?EKVav/GITZXSOHumCEAGHjx/kwAQ3+JzcKJ6m9W+MjVBlnxgTHW2Wp5JgDum?=
 =?us-ascii?Q?q3dm1VUkpuBseYdSRq99rjPSsM8aErMQtG9BSyYFhiFOc5uDkfky/nTytq0M?=
 =?us-ascii?Q?Bf6t4LpfPpNV5T4sNhgvEgdjRQezUuRuSGTfPQ1TSW8rtpyimxNznTG0AGj2?=
 =?us-ascii?Q?1Os5eOi185oMhP+HT8q6RIZf+RG5vjgYixMCdyJX2ZXHGtrlul4edNj1uViM?=
 =?us-ascii?Q?C/ZCR5uMIDVsewBbvepJ+p5Wj7jPC9KtZUR5w0rdz+btfAxgriBqzePVOwpC?=
 =?us-ascii?Q?ifuenSq5RQhH6+sqGkw9LwLf6qkfvmbwB3Nu69aGIJrXwkJNo4O3avBENGD4?=
 =?us-ascii?Q?WpM4+/U+Q6bIwTaxPuFDRn9c9jKp4AeAUx8lYhb6OO1s832ZOvV6PLpmcHyO?=
 =?us-ascii?Q?Ma/+/JHpgQyKGqS/YiNgDva4Tfr7Wo/1+OeU1oBSyRhTgzz8A+349gr/aPJ4?=
 =?us-ascii?Q?qpH6VmGnefSe6RgHdQ1/Gz95qaJ+RyjJhZaUwIVt44ff6kaP1pXfppqe+6xW?=
 =?us-ascii?Q?FE0n0B+BHDQmf3QV3m534jzH9UUBTXLYloUtJhpMcUmNpiAJssJoMQyj21li?=
 =?us-ascii?Q?WnMPPaJNKENio2R5mqc0qmEmpwrZJmaxhJUzPsuHy7xEgN5HDHcKyLRXhHkT?=
 =?us-ascii?Q?qezNJdQ0SDHegWoR0LEP57AfG++tqjIR3osvxm3DAjoA8gxGDqHuCLn88dPN?=
 =?us-ascii?Q?g/O7Gxu/Wsgxf5bRKbTFupAizDjxCXjdsP7/civ1+xM/EFLvifLgviVQhlAu?=
 =?us-ascii?Q?IIuP0h7oABDgBya5vb4z6HJyxNxBM3FG/5lYt0+odX7mihrDDFenqD9LFrD3?=
 =?us-ascii?Q?TpJh32c9zFgJQOOdA9pX9C8fXgKPSLA5U7cirPtlCw4QUMo8raHpa8Mfu0Vg?=
 =?us-ascii?Q?vyAvm9AteUX0RW/ZtWivU4T2KmojR6bpQcXtJJy8+240a0FpHwf5NMQFvKBN?=
 =?us-ascii?Q?sxWhfKFRVcASA8hPBoNPATOWYhr8qpbu2BU26O5vm+yQt+B5nc8H3UJmeB7e?=
 =?us-ascii?Q?RDVRDLwYDFVsm2vTB1BAVVlGKG/rad2SZQ9LOyQtcX42rNF26HdrLjJtUlo7?=
 =?us-ascii?Q?NXcvp6uW3/ljEP9Kxdbk1KEv+zmlw+mBONaZWIZW2wnIIqmjFzrf7mtRFOpo?=
 =?us-ascii?Q?Aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TwmEqPsaeXFSkKj7Rui6iUYXSjzRCQUacJrjj0PpbxtAvFAy/PGrlQJPh8OlHv9D6/oP0nDiK97M+TrWItdz1cM6tT+RkxAMdxfPquKYiZYjvgGm0yc99/7AtFy58Rm9kj5ccg8Y6xZd5A/ky4ygAAsc9iNnJDfkuxpLsEk6Z7T0zi9C+vwZzPT8slEWLalSGHoqPc7/jBObkOANI7gqp9De+JU87m11213hZpa8prUBao90kBAefZuw4Xgsfbe75hiDzUlzzj/oRxIGoWu39Md2P/3nU/D4j88rt1Apc7Q4bozE38z1oOeCTYn4dQDFqQr8FwN5bgv+lqk6r1OHgCuBrB6PjS31gP5I2FpsO4z6pIXHTREBsQsRpWWbprAjylks1gSeYjUKbeMbllssYBhSw9s/Qt+i4LrcLwjl6sGNYIEXbfLcnYaNKKImDOH38++NKTQ9Kv6+vmkoydP9Cf2xvbblb5IgRIeCk6JSC88e29/+j9630yvctD4AtlruiwPefpW2oeMB8ufyUg1U2QarrKhnxdPfYxvj3E/BmNS1ZS3rLxVoUvxtjMcPmuRrE4iD4sGd7G9V3N2ubTDlwZblBgJdD3t2qp5J4JC+1uA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33167081-b064-4389-9cf8-08dddbe418fb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 10:11:27.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5IelxdlSx43qNi0W87uV5GKV11DcKaSWo2fUnRI4yp7JcaOy3qNEiPq4We3YRDkFZqBsGwtgTEnVw2eprQADpRXC+kc/1b72P6nwT10/4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF424CCE606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=561 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150082
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA4MiBTYWx0ZWRfX92NLDxzc9HZ2
 M9gpH9WfauuMueQDRw0L2AG+Oc+7MAHlqkXFITG0tYmvD1XmLvGEfXp8Lad9mZnX9Ri/c3gxG2W
 r9UofUhRLEud2qzIVE8lidAV25IR8XIXFhgxnkz6VjaPJl2yJuGhrhFtMJmd3jc2zoSiDd+euKV
 LOQuxKjTppCyCxiRerENmmAwk0t8dHBwEJTgooFRMCXCckejAR7FzOaJND1TEje2fasKVckhCOq
 qM/tQo3uWGkYg+2YY7PtmlM+whyHN1LJvlT0dyDUEfZWvSiodNqj6/DSk/dDxpDFyGxzI0I5Fhw
 ++1aR+hWCHpYSE4pBr6UUfo9pPbt724GyyVr3TJ8RLpmIYTt9zLSL7bkRo990bdCAG/AbroBpNc
 E9hyaslTeLX1lV/D6dNga1A4Nin39gnyCBMTAt6EJaPrg5yuc+3Sy8IxFybB0y6KoM1xcuyA
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689f07d3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=0YuXtRd4_jihUpMn9gAA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: 4mTbNFkhzOcahgxa_ZSqgZEIBoHsy7cL
X-Proofpoint-ORIG-GUID: 4mTbNFkhzOcahgxa_ZSqgZEIBoHsy7cL
X-Stat-Signature: 5do96nzfe39jdsmcwy1rwdsyeawzn5th
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C180180010
X-Rspamd-Server: rspam01
X-HE-Tag: 1755252693-122386
X-HE-Meta: U2FsdGVkX1+qVlq7KzG10QZHraYYu/5irJms1yye5qCOP5VCJMGtuPUoSqah6LI4RMUZCiBH5Co1Aci60TaDO2lmISBUx9uo0CIqT5NOG18cd6L/CLQHCPktA8UL/LmB+OZ3VvVu0rugvnGgIFf3mqqzE/5tVAEnOMFzh3PyVS3xsdFNg4egXnfyTpzaFHDzITay6BffPRgTI6IuFnRMnufzJgxQF7+1gXhBrJ87K9v59Kzb7hiC9tAcrqeFQ0H/7KW5qxKmDrl1q2sahSoyF3nd2BF58no7ehjRNDUkdo6UuI0zyNBKAfkJmOtsoiR7XPmtlqjJ4LSyi8skpj4nOw1RvtS19KaoC8w9P2YicorRh/MhX+c5xXcu0+Xr2RVVO++eslGQqX3BZqosJmsRPAKVhVRuqTGS5xpXDC8YQ3qaKtFAbqs13KuajbenGi3KX0hp0noZzsqWHk/9yUyJQYDh7ulDYKAYHLnEvRr4bBQxUzPYcNG+DReY9R4oRTEkz7FzHBIhyi3VoDIJK/bTOiJd7sfczt7MoWBIFkB9LTmI2ImEl+ZjF5EJ6/r9KMA+eRbgL8uK/GyipXFO6IlQYGJvJTc/1miLeRXBXDlmhNbRklho+D59nuJNC1XrcGVrToCzdCbrx7wNq8LBG5AjFUiyEg274+bRbwpfwMtnI0m6z2U3QEETc6i1ZHJE4WvoxMLLUR5X3vKWd1+D+hY1iQcQYL94CPlXAJyTM1fqj2SK4UxCsxZ41q1It6eCGTQMwhFwCy2bFR7m7m/lqbsKIhe4zSuMTBHGmok/hIyibu4Mq0qMbT5IKCLc7JPsmdttAmkcVI1QobkXqk7M4UsfPC3aNC5WAthzeoUPjNDN1jsgpOs22zuCShsvuXpaEPZ3M1eCGRLZoiIRTGLkbJIljZdkZ8XSXjoiBndNDveyAsLlpNpfD4a5DCpcjZMZuoaF1oEyp+EFGfjRxKTPp2t
 j/zCZNCP
 DDWK27bNypzGkZUWYUodhRUdpP9lthEuznalyDJYuUS7aTR7AVnTGG14RIm7HbhOHhvY9SdwMXjhq0gUpyoD3OmH388ujCaGn3GHAnpF5PDRYE9y7DlaFN67MwTrK9p2kBNjtBx3z5HlBr6QnYgDW2jV5lvDgkczjbBQAdEMdnethtYcXO4GWtqLBXrqKaVKm4OLiCqdG4UyBH+mjP56syVaoxGd5u6Z6TxoY3fitSAut+7kVt7I0QH6zIvpO7JrAPihIbgKpXSzXEObgd6LwLT5mqsXlBSSaao4Bgk+r97N0m/cNk5ponyp85VD+qUxOBC985HducFwcTLBP32x1UOEBW9r6xcCBUMyiX36T9TRzS/Futj+F5IZSUAoQynwGJezAiJXNu3g8rDkxjFQKgH2q18cXAXduv1kZa98xd+WJqHSRRPlBDvjY2Su/En0FTatNt70ZepK3LdUvGW+q0Knwyl+3YK8gPOlEbJuSqPOPowO23sGPPJC3eR+KU4DjrdHLSN5NF1cBn7KL6GZimO/4shrbPgeqZSmp0CBc/ALpfNyrEf9xUVwXPJ7E8qds/IvFUMDbe8E0ExczTrGQl5K7asHT8M7ZPXClpsF5x5MBVZKvL5BkwpiqEmTFKF9ld2ahVjligKn2sm/4Sb2hblLdlJlXSWzLNYSR1TvRIqXXdY78eysu5YxiYG5Het1GGKJs7mXmj+Kjwz3pNZ+8wo+Ag2W/5vgckSw8MRWTLuXtGzOKJ/mNQ96ddRfypnCY8jlicw0IFb0OB06Qz7zMC/ATqq7sYPXrqykuaOHkvYhJdT9sgmlHArHpwQHtqvzaX6IarxkqM++tG4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:49:40AM +0000, Wei Yang wrote:
> During code reading, I found some small places where we can improve based on
> the knowledge we already have.
>
> For example, since base folio is handled in another branch, we case use
> folio_large_nr_pages() to get the number directly.

I think this cover letter is pretty weak, please describe what you are
doing clearly and why.

>
> Hope I don't mess it up.

Please don't put this kind of thing in the cover letter, it gets reproduced
into the actual commit messages and this isn't useful for people reading
through commit messages.

>
> Wei Yang (3):
>   mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
>   mm/rmap: could be partially_mapped only after no entire map
>   mm/rmap: use folio_large_nr_pages() when we are sure it is a large
>     folio

I find 1/3 and 3/3 ok, 2/3 I don't like, so please resend series as v2 with
only 1 and 2, propagating tags + improved cover letter please.

FWIW, I build-tested each commit and ran mm self tests + VMA tests against
series and all passed.

>
>  mm/rmap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --
> 2.34.1
>
>

Cheers, Lorenzo

