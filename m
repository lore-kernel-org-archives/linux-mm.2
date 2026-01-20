Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEF9D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA316B03D4; Tue, 20 Jan 2026 07:12:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6D36B03D6; Tue, 20 Jan 2026 07:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9716B03D7; Tue, 20 Jan 2026 07:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 449F66B03D4
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:12:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0ACBB1AED48
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:12:10 +0000 (UTC)
X-FDA: 84352229220.19.B43056C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 95E7014000F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:12:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LXL36nsE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WzLfNyt9;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768911126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2h+P88m/YAiCpNnzdiD7s8KRFXehlXnZ6v2GGtwiw0Q=;
	b=OBksmlYEN1C1m72e/rguXaASoRYp+MPogcyB61RXo8ixqZEYPjhXmFzLxn+rV72y4LrdXK
	m8b3wR/Em75qnvJyAax77gRHkdqhXcszkLfA2CNK+bcxWXli3d4lVHUt8k/31UexK5fidZ
	2hbcBlOu8m6GkoqA4KPTlwBFbHzOHvs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LXL36nsE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WzLfNyt9;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768911126; a=rsa-sha256;
	cv=pass;
	b=fpKhpvVNmdt5tRgDP3WSht/nYOQ4vbMu4ZQDoCraqrYPr7Tnc8WQSVrbmSfev6VS+JZ+4y
	wIWWAtXqxE98FmLpYFQ4DUVMO0ka/8htXLXsbnmt9L0TNHHJkJG1IUVe1KqVynLWHCgVhV
	aSzO4DBJb6PEKje1xivzj2/h4rHpNTo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7v1gQ3523773;
	Tue, 20 Jan 2026 12:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2h+P88m/YAiCpNnzdi
	D7s8KRFXehlXnZ6v2GGtwiw0Q=; b=LXL36nsEFsAwSNymcCaU69e/G2R+DUtfkc
	iBp26y8scg8RdX6ePxCsMLZkoMDdqa+sNeFnbw3vOCYT7K8KIj71q1MTEtuOpvbz
	x4xOLbJbVNfQOvcjW3ne2LFy05jjaoI/0wv2HfUdniejWPCGOpkWuqA3GYPgJRAI
	2524A3+ZWYxPMdcXeNjSAlnpDZ8uhPkTbydbnFPjJZLe1nzRDR5OICpIiW3tVONZ
	kf5ocI8IIunP5bNZ9OFmKqWCB5yg9RDgVOlt3JuNhL/uraq9MnoavV5TQAGq95K9
	T+YP/IA5BjvUwx9BpamsvPtQ5V9sd0nUAaySwKR3LL9T2A2C2Klw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qbj99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 12:12:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KC2usJ008410;
	Tue, 20 Jan 2026 12:12:00 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012032.outbound.protection.outlook.com [52.101.53.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v9k4s5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 12:12:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CBaqGvP4FlGsLX6Kfnz9H/fFqjbZjGyFLCnOtCEzg7XFKGjXZ5ka3DHr8+gbsg2/r47dmjyh9lNnWa23++fEFWzyQYCFR+jiZrakRaTaWAziTpMjzZjBCTM9gdo0ZC7raQRPYZVt/YWmUhhnQLsBrxPqjzm9/tVc5J74KTQvNmtrGOoh/RaPHIf88hrevXPjPX1N6uopqx1nn3juOnDCTIYdrgpUqMQkuf0ss7QWfXkJYvDbiJNnkq9ddSK4moKehEPt8w6I3KRbzGp93RyPH5vrEajOzr6Kdn1C6Qm7d28AL5C0s80dxEDqCggxRyPNz69fhIQ8RaU6sY6RCz9uew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2h+P88m/YAiCpNnzdiD7s8KRFXehlXnZ6v2GGtwiw0Q=;
 b=WdBrN+y0hti0JwLMb6erm19IOf6uw2PKi/tvU9CBvk1vdKDVSPFe688bwS305Uya6S+64ozHESZL4WqYiHBtQ53hW5bQn9f3OTuGDIR3gJ3D4P8YnL8RAV5L0Vjb8Gk7Xmufh+scuGK6iaPWkLeKVb9pXSLStznfF4ChbAbqccrJEnRZVYNXzLrzJ3j8UImt66GV2//I3Bul320KC2ASSGFO/K5+iXEnEpSHOgOY9tS3pKZUx+yYMIzEb7CNffSh59+vdYHlwMx8pAt31OJ8g+TrnFvWm6t0kk6MNSqCxEbI2zSY0PYrptxWzbQ6gtYNuLJ3sQSylrjJDgXzZ1H25w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h+P88m/YAiCpNnzdiD7s8KRFXehlXnZ6v2GGtwiw0Q=;
 b=WzLfNyt93yC4yyNKatOVnN8jRDqKYKSn2ofynsUDTvy4wqF5fYKlM6a61g3sBJiteUJO6SyOuLu1/ivJnF2FHf9MhBHHDvHvxi4iF/NtGSvYgnE32xOT9SlpiW6jq0xuX8mx3GPJHqlhPXwvXM/EXEJny68rG4Qt5IfEneAOrds=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 12:11:56 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 20 Jan 2026
 12:11:56 +0000
Date: Tue, 20 Jan 2026 12:11:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 418/422] fs/orangefs/file.c:414:9: sparse:
 sparse: dereference of noderef expression
Message-ID: <bd3e8a3a-4507-446d-a0b0-d58590d8b30f@lucifer.local>
References: <202601201701.IhxeGffs-lkp@intel.com>
 <09bb7453-a2d7-45f4-a69a-ceddcf6fe809@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09bb7453-a2d7-45f4-a69a-ceddcf6fe809@lucifer.local>
X-ClientProxiedBy: LO4P123CA0103.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d09ac59-9233-4ed6-9312-08de581d1ae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8jcavajcqrPCKXi58jsjCaX+FovTqVusyhjHHKrOAG2kfGwT91P+1svq08Rv?=
 =?us-ascii?Q?DgcIUOxabk4ZMOrN/EA8qiDkknhcCKYtuBfdhlU2baI7h9xWjTvNsuD8H1Ks?=
 =?us-ascii?Q?Nm0PjhI5UqixYDV5YOBgEbkvUxDCaobKc5f33kR0Pf0A+rRmCDU5G5WaIKLf?=
 =?us-ascii?Q?Ps0z3LD07YQXtWPXYgVvef6XudlLjfY7ZPMRwPD/H6vANxbRqspLWkW11C/3?=
 =?us-ascii?Q?4/UntHuQKiipp5mjtIEFN1nkWL8ONcgzV9Vd0mDUNDP7RPxUmwcw8GgvCvVd?=
 =?us-ascii?Q?5kLIHxdcBzUTaFpHnUxKBAOWiFtxJI5htdl2PFc9HZjqwHaX5IR0biZb0/X3?=
 =?us-ascii?Q?FDJ8oOtk7HhUS5bu5j/zHJAGyY4NfVbJ2NcZx7nEmG5p2HAUiwjVo5W18wpO?=
 =?us-ascii?Q?g8/UJile2pVmBZES/e9XPbwtBeS8Rx3sx/9bPd9yYKp6/Hm99+iAB42Z4bO7?=
 =?us-ascii?Q?i9HolH6ECcNl9ZH2bIezEZZTBP02HKJLPVr0Z77pVrc/Oma0umRss0EyLmzv?=
 =?us-ascii?Q?tk2HWmOUx/gBz1ZbJEjCAEiLThRmKsZGLL+S1kbwUVsYDdHq4NMQlvXp1A0M?=
 =?us-ascii?Q?wIEGBYl93/cjGeeMK9r/5RcCk0jXtWI/xnaP49KWVo5Q8NvrW3zLUmmIXwTJ?=
 =?us-ascii?Q?vHrYGlXcJKCZKl+tzD1UDOox4p76w36oKjW88IgV5YbNLVKy6stoKQvDvBUQ?=
 =?us-ascii?Q?y74566ZTUGHUPS39RObXdksxAErzODxp1/xT9iOjzxMWFrjZoWsqSt0soqe8?=
 =?us-ascii?Q?EfBlgAX5axNClyYtpG8peJ8mve+QzAG06l2g4e4OyiNCTXdl04tFpm8c2zB5?=
 =?us-ascii?Q?oxddVsvlkfOfZm6D9U2C71w0qR9uK5kfPrDWmXYBzYrbkdgopPBE6N+wbvak?=
 =?us-ascii?Q?yToXSNZ8uuenUp7WZmuDtYizQX/+9WGzID8lp1h2a4jHkbPZCZYDB//zvykK?=
 =?us-ascii?Q?5wBU4O16d4u92DpkWzM6978fmGYQPidsValRquK2Od97h/75J1DKBkIDYc43?=
 =?us-ascii?Q?NC9fHBP+NJaJBibKLTl/23NQfO/oiIgp48l63POVN4gAF/yF0HVnRLYeNUCI?=
 =?us-ascii?Q?zsLT4gnxxtoKIzekpik1Szb3IscgL85tQ8ntskWgbjF8/oSA3KmAnaLMKyrc?=
 =?us-ascii?Q?dVtR7xcFTbNe02P0R/QQ3JWoeOBC1BgvF/VKQSR2/bKMoFzW2Bf2v/8Nj/yR?=
 =?us-ascii?Q?1+Hun5Ck1Mj0wdFSjSiWd2VYrayY2O2rTmQezsknSvg3PjZqII/bstC3K2h7?=
 =?us-ascii?Q?wmjrGE5KDpVjMVmOOgqtj1ebghydO2qSrlyzQaAlaEqiJEeM4yO6Vso1Bbr2?=
 =?us-ascii?Q?FaorZHHZ0BaSP7qaSYL0HXLFRKZyepZLTkBNkQT2a+ZVm5ROxh8gAYprBJYQ?=
 =?us-ascii?Q?OENXjiprVAjy0aHIHnIV43eodB9mjIK/jedU2uzdXVaO5wvZKROcrmULZIQb?=
 =?us-ascii?Q?Z1ayBNLJLA0yQuVhLr/SZuyzOZ/1kGFl6hvEZOt09OQC8CtDRmtshC6a+4Vr?=
 =?us-ascii?Q?IRSlbT/FcH5ORQTy/msYyeRDu78+Q8e7lAjCW07uWRT4r6nCEdp5DFGRDQL+?=
 =?us-ascii?Q?cqO/yFNjcgY1mhS1yai901DowLpvep8pD8FX+N3W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bNgDQjeQF/OvB0aeEEZCBKNVRiWqKVAPkLb2G8axAYagQ4P6w+PbNFJ7JUaN?=
 =?us-ascii?Q?QOwfLqQyieqyBlZwqKW/+MrC9lTzpjobrMU20DMS3ncr2pYcactLuVQ41iWG?=
 =?us-ascii?Q?qy7q/t5s2R5OUVG4FxmjvUIFCIa5JPYxlgIg4d3/mqt3TtfQJ8DvkrAfGFvt?=
 =?us-ascii?Q?br0PrsD3MlsmPO6fnf414mtDUY873uTdDXJVuWW5Gc/X7gWJmWXiGSW1QFGQ?=
 =?us-ascii?Q?xoO+5wsPghbEzH1T7deDn8JwT3qr7nxb0Rg6pv1zI5CYl9JWBKmeYpK+vtvl?=
 =?us-ascii?Q?DYPOdr0Q6oX8xCsdVOuSylgInrLRbKdYkqnL0iAd/jQrbWa5FBVu5GsEj6mB?=
 =?us-ascii?Q?dQrs90GrGs4av2mbOwHyROHq/eL/Gqzy3NiDrRK5Ha5PkKWaa0GgcHHYiGzI?=
 =?us-ascii?Q?CZ+08iydt+qczOVTMm0i1r6uz53yC8VG8MYgUgfoUEbboR4Mh2CYsxBhmgcR?=
 =?us-ascii?Q?sqDmi73Tv1UJxiS3NrLWbrHVn4wGpt7uWQpGSyzntU8wMyI1iMw0NYsVac/W?=
 =?us-ascii?Q?eathJImN/OCa0UJ+9DNaM3WRgqAZOstuGz1f15HwTtnCf0P0Ke1Wfvwazxic?=
 =?us-ascii?Q?PcuoH9pJO0Ao/RIu9C4UdLTmoK4YjGYPLbvjm2pmeUbvpr+pYfWeWGZelr15?=
 =?us-ascii?Q?cHQgNyPtZmPd+bwCFuSWcyXBT/cjzeGFzYir/UHsSxNebA3XrqNT5FX6Qn26?=
 =?us-ascii?Q?yqo6oxG0VEopiOvwJ+QIcxQ7asE46d+yFzlO4boPpGGC7YpHmorNQGpNzv8V?=
 =?us-ascii?Q?/weNgJm4Ndoj6X6lUd8Tl1NyMmlIlm1RWlb5gzjbLlKCFiQXIAZEEZFfGoup?=
 =?us-ascii?Q?O30trfVPHsm8awI+ctVBVeDCBz8LEN9dGUKRdni/lUIE/Zsqlcfq7pBQr1xb?=
 =?us-ascii?Q?VmDN6fkAg23uU/ZNelSLvVcPJxTxbulRCgIDyWI/Ot0jaJ4Lzxgl98KeYB1O?=
 =?us-ascii?Q?GtpCmStLx/jS6DwnFmhwLl4pxPeTjcG1mNvR9vP5JIHuo39JvHcYkN0dp96Z?=
 =?us-ascii?Q?9k+iIdV7Kdm+3ukX/7gnqkj0e+L2SK3Ti/hzqClOtCibPf40o4D60hpwlxMa?=
 =?us-ascii?Q?6c6LFXsXfGQeHh7ae5M2F2+F4WozdOdeq03vA5OnoaZjWcMr5q1kz/EAHzLH?=
 =?us-ascii?Q?uTkidqErBipnSME54sxIHiIPRymwdvmJSE+2OzLw1CK4QoY6NWk1YamZORra?=
 =?us-ascii?Q?02OQDnCZ2edcVQ18+BRDGapm6oiWBE75wSfZucoq8/bI2PcMejgrTzITpwZc?=
 =?us-ascii?Q?T49o7EyQgPFDRqKJHQIvUuU5OAqviuJ700a4CuF+N921+RZFG59XUoiydF8n?=
 =?us-ascii?Q?HvsWG1tLW8ZMagWJ9G97pd5pKg5X7CgXVurCqYIc+7JoWkESmlp+MPrK8bf9?=
 =?us-ascii?Q?wmCPAYAFjjgre9ZX3pM77Sw3S/zqYoT7Dvpe3dHPfyBRuBy0v/U8sS5knB7q?=
 =?us-ascii?Q?/pZENvH/cPMw/y6qGJTfGMXL6xjXzVie/FE/owuCs/MVneeMyF2/X8+K7U+L?=
 =?us-ascii?Q?6Iooos6xahYVjX2wwOjBnMpV6Fiw/d99Lw6S9SL0J/anri9hWHIemK5pKumu?=
 =?us-ascii?Q?OpNneUTAvcek+2Es0Zk5ygekewu2CSgvHlpgdpbBJ5mlzsWlbQqmdr/ElGg/?=
 =?us-ascii?Q?TG//flUitve/dG1lDmBKEpGmGEAPmhp5eQIMP7YUo1GFiQfanRmbtoHebJFL?=
 =?us-ascii?Q?YeeP+3gWGdVfboHCJi0gCg5lrc0v8l9lDytKQqqezPvTM38OrM2S3Z/LjGBc?=
 =?us-ascii?Q?Ccz5NFNnIs/2YI6oWZOf5LefMqdioP8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+qDePndtRGHxBJ8CXjxMRj+0kIMV1YDmIiJaaUdUVhqK7bIgq6hL19leamDZ8wjUJrjGkyJBR4mLoXZGfrUf8Epexf5xgtkxA8PZ/pYdWvgBItto53fNYs0UgdevdF13bzamKJ6cwOyWrCYb8ag2kklY0FQ14RSifZM/75F7Zc4MnWAlqBFwyCu/JErXvGRtAOXsyIvcKUngtAL+qe2uN29m9yXs/Qz9edQ/g4mEk9sYuFU/C2od7aBAsZg+/CeXmRrgrhhNl+SxiBkZNDUBnZ7s3nT3ewKyFVFrxo/Ae0QMGrzAlcuLluYGg9Cz50BwPnc0oBwDkrcpNPuSg9bDNSZg9OTOYFngcF9FBdW5lzM+DOQuzhfWuADK0bgEOWEvw8SUbEH7BsqLXNAtsCQLuvZSIxI62TNg+175rCVl0jns2C04FXpRbDWSaMFLY4mlcIk7IvKz6dyextSiIbXsZBC0ba5KCvnpT3QpEYkFGDiyFcGpKHzsO6lzVSnTk2VyCfsjgBMmVamqLZtlWvc/3IlMJjJE/cAPF/4Zh0NLhyj4t9nWFvrnH18XYvuHHMTSuPd/01yP3U9nrhxbPPIaQHUF0tNzpCSV3lWXEMYw7q8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d09ac59-9233-4ed6-9312-08de581d1ae6
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 12:11:56.3473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jr471za9A0ob3J+5zf3jEn8PnrxV9En/GBrLjLld4YBtz9rQFgjD22IBdBCkkagvyLXql1RVMfqsH1Maun319Vxocw9YwgqohLBQBXqwMsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_03,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200101
X-Proofpoint-GUID: cT2s7lgcL2a5SqkCABWcsW9IjMxIK0NG
X-Proofpoint-ORIG-GUID: cT2s7lgcL2a5SqkCABWcsW9IjMxIK0NG
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=696f7111 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8
 a=L2Ig8cwMpYkon8CDR8EA:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDEwMSBTYWx0ZWRfX8AP8x5LEuTe2
 MEsQRSxEmFJOEAkQHxFKNxoG6EaVWdB5J0bkVfcrvjq3XF+VcS+OH+eJUp4am9XCjZUvYHkiCxn
 0lqju8pX4s+i/brZP+Nxpj+WpPqckJ/uspQpxv3QXL4gUBqR+kuCc9bQvivTIHDH9SNhwOV3c3K
 HQM6Zf2D1imuRB67PrMpQjTfxFffCnES4LLu6oJGZ02mdsyY+dpvFmyxXEWHg01PbNBylm8F9Ty
 1TDJVRpLq5XnOy4uMyiy6FsVmQdlF4F76Ua0DyiKumOC0BphlbHA2U3GiCHpG/NKma8uLYJqlTZ
 HFcjfePlAhUgmlIGeebZXuSifZSjHX56qWJ3p/hJHita7bT/ndfnme5okO3xfte1qS8X/p7xat7
 tK8jhj9j2AU0fqK1PshGgtES+n713+AjPAyII3qXzCgxaWRctBFXJQLZXHWHt4ovN5r6gLj4fe9
 HRr8t7ZWxM4t4ABHusA==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95E7014000F
X-Stat-Signature: 6w5e6wtka7ygbykor4mtbfxyifb3dam8
X-HE-Tag: 1768911126-282759
X-HE-Meta: U2FsdGVkX1/ZmUm1bWNrIgmQaGur3GW78OvSR3+7bwO0o3WlI+lJ+JmvjRfUoZGY/+JGIWj9zfmkRrzeohNFzjHNyPIrv+FjyrGEbHkflwPdftzMpQcw1TtoSZyW0WN0316sipONPbth5ATJMY4VlKGMxI4OXNFKzrLjaywYqA248HM65wD7P/AZpMQbU7SorlkzUADwce5D2nYpVa0xx69ojY4U6+RaTa57vCarv9E/iJm4MZI1JZejZCF+w9h9fxzafj4drBolnBiy2XgugZSXhMAfWJ0u0NRYae4fWD1QH7BSocSud4oRKST/oKQTB1noO3usmq4YZEhS1pYBIAV2om19JRvBHh4BaRBgK0HxOznfqPC57dNwo9EH0NEWLjc0qa50Cu7RWOqyUi4NJbS/nOGeWlxxnJz9dwsVuZz+O4yjBUMO8HbDd2J7Kk8DE6HJ6H0Rt5IzCQBwAPZu0DezmkDToRU6y/oR4FIcRX9oJDedtiaWN4WXOQ3W4vgI0VaTUsSfSGQTgA0Hi+V1rlI7avx/Ft6xFL4s/CYJ+AjrDD4eb/nGvEuvQzIQlgsv5n8u/Lkn8MhupxvZgNBhdDyKNCvPDQjLsEJgWCncbUuA3GCbC6iUE2/w794aJjvr6EPcQKFYFExVFpRR5JaXcdjvbd43GZvvsSCdPAzk5/R3cZjdsfGfJmawdVNOvEGp/tj3oC2dNDOG+bBmJSrEDwF/5nVLBcjxZrmJWoPd/QWgteiqjKjlpsE/uyIjF3UgonzXIHiDlxWAnZ2eI9zvkoyDk7VxguWJP9okvg+mdYooZUxxBadc1jq5UN9RiHwoXuWMwyMrk5UZJ/qP1FWiIppLvbkU6DmgHKZi6gPfSwjhDS7wBdzjLx9GBpiiviQxjKT4X7WNR6WO4gM++Y7xBlXinxRXrQRmFWEj8mL9F5YBTQ4zqIe79qMvcv8Xero0cRSlTtGJm/Aeo5EzZ63
 TTmXDaLg
 KxczFXu4ZEt5EtjopHKTEV4rU27suOHGPlGtlAzRO78vgj4E/ThV3vpNAEbM0HMzkXyRV8p24tqTX+sGvQCkNqKAXBcPijwm+4PuZQ9N/D9JfEbNCyAkw9C8ODVz1D4qwukw+uIPT2bS2FPQR0Q1ieaVbS76Fjw1n5o9xnzaxQhpZrFIKS9+IZ6MHLfUCIkuRpCO1BZV1NDsBNxlDQFlAac8vjmdE3If0bRq7kQqeDq/2o0YTl2ghFylOW9VqQ0U5qG0e3L0/UPRCsXBFhjBzIqIHODG1ZHfHlV5p0iSC8rKjR8fkbXvLIV73CqU4H9lP25nk/co0BMCeajk5c/1jwUVNYuoLvocYYc1m/jPN6xFtM6vV8LqxgHHl4327SIancMpIvYeg9ZSBC7f2uIc53So2yGXLOSQmWzGPtV9oWbtMK1uV5WBnBYpbjd3UP0Mc+AjrrLvJnO9EfGauzmhx6g5d4G5fSsOhCpgsGVX2kmFypBX13Gf6CuuErgaLz/ibYDVBxOdJnMbwaTmI3fUQJalsyCP5PwkcUdpQyRpwRiTYqsqGnrjq3oaKpdICU/mkXBBVbN6bX9dvrLpymArkGyeswI1glTOdJRfWVyaY4GwDJljfd+E+YPmgU6Lh6IvjnBuXSUlQRyRHX+MDHNUidAWc2UxwFEGmP7r1YsP6E35UcP76HjyuP1kyTI23r8EDAYh1t4OSq2iHuSfF8BqwLmIyl4Idu1KP00E3906il1665klCIVQyldeykA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:56:04AM +0000, Lorenzo Stoakes wrote:
> On Tue, Jan 20, 2026 at 05:10:47PM +0800, kernel test robot wrote:
> > Hi Lorenzo,
> >
> > FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   e4348a62bb1acacafcdeb149c9363291fae08c0c
> > commit: ccbdd8044f13617fe9f2bce61aed556314544664 [418/422] mm: update all remaining mmap_prepare users to use vma_flags_t
> > config: arm-randconfig-r131-20260120 (https://download.01.org/0day-ci/archive/20260120/202601201701.IhxeGffs-lkp@intel.com/config)
> > compiler: arm-linux-gnueabi-gcc (GCC) 11.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201701.IhxeGffs-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601201701.IhxeGffs-lkp@intel.com/
> >
> > sparse warnings: (new ones prefixed by >>)
> > >> fs/orangefs/file.c:414:9: sparse: sparse: dereference of noderef expression
> >    fs/orangefs/file.c: note: in included file (through arch/arm/include/asm/cacheflush.h, include/linux/cacheflush.h, include/linux/highmem.h, ...):
> >    include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1199:46: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1199:46: sparse: sparse: dereference of noderef expression
> >    fs/orangefs/file.c:415:9: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1216:48: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1216:48: sparse: sparse: dereference of noderef expression
> > --
> > >> fs/ramfs/file-nommu.c:267:40: sparse: sparse: dereference of noderef expression
> > >> fs/ramfs/file-nommu.c:267:40: sparse: sparse: dereference of noderef expression
> >    fs/ramfs/file-nommu.c: note: in included file:
> >    include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
> >    include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
> >
> > vim +414 fs/orangefs/file.c
> >
> >    397
> >    398	/*
> >    399	 * Memory map a region of a file.
> >    400	 */
> >    401	static int orangefs_file_mmap_prepare(struct vm_area_desc *desc)
> >    402	{
> >    403		struct file *file = desc->file;
> >    404		int ret;
> >    405
> >    406		ret = orangefs_revalidate_mapping(file_inode(file));
> >    407		if (ret)
> >    408			return ret;
> >    409
> >    410		gossip_debug(GOSSIP_FILE_DEBUG,
> >    411			     "orangefs_file_mmap: called on %pD\n", file);
> >    412
> >    413		/* set the sequential readahead hint */
> >  > 414		vma_desc_set_flags(desc, VMA_SEQ_READ_BIT);
>
> This is totally valid? vma_flags_set_mask() (which is ultimately invoked) uses
> ACCESS_PRIVATE() consistently.
>
> I wonder if mk_vma_flags() is an issue as it ultimately does (const vma_flag_t
> []){ VMA_SEQ_READ_BIT } here that then gets 'dereferenced' by array access in
> __mk_vma_flags().
>
> Nothing is accessing __vma_flags in vma_flags_t directly however, it's all via
> ACCESS_PRIVATE() as far as I can tell?

I mean this makes sparse so damn cumbersome to use.

I do NOT want people doing flags->__vma_flags blah, and force ACCESS_PRIVATE()
for this field.

But I _do_ want to be able to pass around pointers to it, but sparse
unconditionally makes the type no de-ref and these warnings trigger if you ever
take a pointer, and there's no helper to help in that case AFAICT.

If I mark __vma_flags __private this does nothing, I can even do:

unsigned long *foo = flags.__vma_flags;

without any new sparse warnings

Which seems bizarre to me.

Touching headers generates endless (currently ignored) sparse warnings in
general so it's very hard to figure out if things break.

OK I think the best approach here is to drop __private, the __vma_flags
value should make it clear that access directly is a no-no, and we can
avoid all this :)

>
> >    415		vma_desc_clear_flags(desc, VMA_RAND_READ_BIT);
> >    416
> >    417		file_accessed(file);
> >    418		desc->vm_ops = &orangefs_file_vm_ops;
> >    419		return 0;
> >    420	}
> >    421
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
>
> Thanks, Lorenzo
>

Cheers, Lorenzo

