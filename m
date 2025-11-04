Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DFFCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFD68E0120; Tue,  4 Nov 2025 04:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280188E0118; Tue,  4 Nov 2025 04:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA0A8E0120; Tue,  4 Nov 2025 04:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC3548E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:30:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 933EB160468
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:30:00 +0000 (UTC)
X-FDA: 84072402960.17.B003472
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3F196180006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:29:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EluKU2jE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Bxnj2IEa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762248597; a=rsa-sha256;
	cv=pass;
	b=Pw52Swo8xZNZA0OV7ZLFMadeAbTKJou7wijDeo9DgHPGOnRC9iU+/if5Ls3/Ll4/OaV9JC
	7O6LHWmG7ayLe3HM5BjwY7N18qE22BUQgO8Ijk0xUKwFKAtly/siHqOJux82mmkkwbSq1I
	DcDEwq6EqeyptFtjbnPkf1vVxZbRYC4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EluKU2jE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Bxnj2IEa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762248597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EUdI5a7itw/bkSp2oWHLxjFKwRigoqQyUaxJk3iM3k=;
	b=JwlbLFS+5rSK2LAIZhLi3u8Zz+7/UQvb9Ah9gbmhHBZDi8KoM1MaA9WtjPAvv7/UQe9gbh
	Zml/GGxTeGr6sTvbP6UTKOsO79UsCd/9E9CYLGjFmKPRFjaxaDi439KA+UDFk3UBKhc0AE
	87p9af/ZrFtQsiT4eF91WCsbDKWWAWA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A49EjhT019091;
	Tue, 4 Nov 2025 09:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5EUdI5a7itw/bkSp2o
	WHLxjFKwRigoqQyUaxJk3iM3k=; b=EluKU2jEDfg8Cx7jr2IeOw66w1mGS/o0TS
	XBlLreou+HabZj49g6ZAZiWTwxoAA/AHI3oiUe7ouKlDaTk+M4boSwNOF47B/PL3
	Mk8grPSn+8cWxUAXO/MSHfvzHkWaMAbqXq4q3p1rZMp/Dc7ILfnDpunkpEFRan3o
	ppRuA8nAawqZXrZjx22zRuZzRq8OaY7mkw4V1X2XisjVb/BTa1a9XYDKFEk9rSon
	iwifx8PKzIrlR7E9IR3YFtlYp4RCHAGXQtuRgwKwvzxC8Nze2TuWroeE8/+niYMo
	MD6M208GJLHlbJmQVxePbdaD3FQSPAVy5er/L/z0r75Nlqp1RoOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7ep8817t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 09:29:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A47i626007918;
	Tue, 4 Nov 2025 09:29:51 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncv470-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 09:29:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrQCbo0Kn6DeJYgexs62302TWSvn6vmOwJ68CkulW0clJ3vX0SEKbB0q/jdBP2kzVYx4wWuIAHutGoSPrh0mj0ww7Gh6uKUI8L7K0nz4JPOww3O6MbC9dZ2xpsScPkxm+9CbpTBKYIAtWZddZntPuX0SdBBQe1NhapA+2y2UMeTjX8yLj6sPFJKnLb/9Poa7JLqvF87iV1EXiEZ8N7vpJei+7tzKykU9GpwmOHbfpAF6m+tF+vWS9xdnxlpP6uUnjUn5cPxaIGd5vMksg8WtuXMDz6o0KPAsLLdwPF09gl/x+3LCsMlpet+GP6C6xuML+++xVun0P7uwyoyZEunINg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EUdI5a7itw/bkSp2oWHLxjFKwRigoqQyUaxJk3iM3k=;
 b=P6rf8H/qcuqXsOQkp0+5TxXnwn4ru3X6g2tY9oSxWefY9aH1oRHKSsMEZt1uFaJt/YsyzFprtguPSnDxU0dYRcq0dJ4AXOq3s/DEyKQ1M74Hwxx1vU5wdsPbUt5tqGIW+d8+0BT2npPFy0s5PusfEb6O/7xYEUtW+6FEf/11WiIdb8QD4kXljxrO55DTkYei155/4lSdO/Vwvq4d7m6ZNjl1iHt0qfWLpwvN4xBebYrp+Q0a+k73ZyhoRMDngb+i0giIYWCuz+j6JDaW7efAvxtDyb9eWYF5fdAF+Nijj1ok7g/0luyf284vGauCjE2WQHChRVrOK9qBRVaRpPpqPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EUdI5a7itw/bkSp2oWHLxjFKwRigoqQyUaxJk3iM3k=;
 b=Bxnj2IEa2t7vTbGWne3DGc/Xq8XlByEofLrz1nrfYI6dubEnoQ6YUQc40xyhrQ5g5+R9TsQknXddpkkmRQE/HXWcxWqKh93dUlh1BHXJEnascIFTmUoqyyyCTlWVYWVLwc+ol1lYN70c0NyKwXn+3PSFB40SorDKe7TtE0+9ywQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CH3PR10MB6835.namprd10.prod.outlook.com (2603:10b6:610:152::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 09:29:49 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9253.018; Tue, 4 Nov 2025
 09:29:49 +0000
Date: Tue, 4 Nov 2025 09:29:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Liam.Howlett@oracle.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: kill mm_wr_locked from unmap_vmas() and
 unmap_single_vma()
Message-ID: <022e54ef-d4c5-480f-b401-566008edd8b8@lucifer.local>
References: <20251104085709.2688433-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104085709.2688433-1-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: LO4P123CA0279.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CH3PR10MB6835:EE_
X-MS-Office365-Filtering-Correlation-Id: 609879ef-a243-4ab9-aafa-08de1b84b371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wgzg/pIQf0q9AwpyHniAVTk+C8lZCBTOiSLCelDBk6e0sHLZRKZpbA0nspIG?=
 =?us-ascii?Q?J+jXHXVW7ePzjc2qgG8G51JQl7m0lJtZM7s3bCWdqx89rqraEG/GQkWssKFH?=
 =?us-ascii?Q?4Gn8pmUWgPGSVnv4mapvuLZzRF6juytq/TgkO8kLW56bUd6NWt4Fc3pjsZB5?=
 =?us-ascii?Q?jQkykHTnQXeygh6MPxWBx11KytrJdo4OrpSZ/7pdgNQHmHBazGBnbcVghz6z?=
 =?us-ascii?Q?LxNrDMk/jGKcFGnLUfUFHntHl+VDTPWEjuGeduK1HN3fkaLOygT3Uth02ViE?=
 =?us-ascii?Q?mx0Cvr9DHFyQOHF6KM1137G1Pg+l8t2dXxLQ4wyKquSvewmYIsgxZHXUVq11?=
 =?us-ascii?Q?AcRjb10VLAXCBgjiWTmXdAFXf0Sh6lCQiprBrkBq+jDyNheARJHgSWd1TWD4?=
 =?us-ascii?Q?VpEkaPR1GAAyKi6AW4KgRn8W9Goa71zUvX9GknmKv5UD6d/R7m5eM2977EX8?=
 =?us-ascii?Q?NN9Ml7CPV6dBxt+/zxUwdFIpNy8c8ZnkT+phuqinzYvWGg6bYs7Xv7hzEhaf?=
 =?us-ascii?Q?sGwgS6ThTBT4qCzyoetJ7g5a+7ZiEC3LqBVhSuzojFNdOKd1I57nU4WosOgd?=
 =?us-ascii?Q?4mb+z3uu5p8uQLQpe3xqKWzr3a8GS1GqvKCtSCMiwMHdsR+NVe+6efZdvR1o?=
 =?us-ascii?Q?jy2nGaEkUIyER6Cmhh3kGban8pGnssA2ywH4uy9nmiCDSXZhFyUzSo/G3677?=
 =?us-ascii?Q?2vCRpmrOkvqhCB89f1yajrkft2AtpCyRAjWQFwXtrKhvuaSkaNzVxr9SUXvt?=
 =?us-ascii?Q?bfjg5u2bj5lcztzH73zX2z0U6Y5KwKIxIM6hfxJRgclN95Z4TL75RguIVOGe?=
 =?us-ascii?Q?aTsp+dvn+w8C/toMdATZRP2jiAzBpLHPNcb1Bx+EW8oC71Pjpro2oaGVmZKo?=
 =?us-ascii?Q?MTP1UJNN8M6uVWTTYJoQB9/9unkfk7+4J/reoSvLZiXPz1PqT3FCatJoRQjh?=
 =?us-ascii?Q?3zAFinOdH+Ze7pO2DsfyR4k2goLTV3TzutO0pHwOF74gT0GZ6gUzANZBqABE?=
 =?us-ascii?Q?G2RdgNnuqomVaRdUf4WO8cLWr3QFop3ZrWx9pMuGAL192QXGzae0BW11rIRy?=
 =?us-ascii?Q?AizCyfiTA6KUruSUXDeoESG/aMkDFVEPQlwArAp2D6qtOOr40GVR1iEoEhdm?=
 =?us-ascii?Q?DL2WEd9ANvQc5jCblZ7ZmURbU5YpoYlMtHuhpbqG6r+YppxSoI5Mj0UOHia0?=
 =?us-ascii?Q?DS0GMVlR+KW8lpiSfE64hn7aYrUnUAG8Pv6+jtbJx79GeHzO3Aw7+QYli1Ig?=
 =?us-ascii?Q?UiX1z2Qms7FZUh7suSee8D4hGXDM+JhFNE8NRqfUtNuHr4iZ/YiA/uaaNBV2?=
 =?us-ascii?Q?qgseDfeyHcWtC/QhfLoGVdC4V7oZ5+wEjOX7xdx2ozIlPWGdVF1YzQFEcOC4?=
 =?us-ascii?Q?q4Ec4KebvVDY+IKiS6VxyIDpNmlCjk1uD6tdI3INcED9oRxFN/NtlGduHJi+?=
 =?us-ascii?Q?m5NojTz6n7N7rb2z2OBJp9Y3B9Y7JjMe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HzJ+23u3MOPB8x+IQvgaMYxHcUOhC9G+zFuN7RvVrhpVHcsbFlDzyOTXLyob?=
 =?us-ascii?Q?7mIFiCpdLzW4nEJVEf+K0lXuu6vDkvH5USTOPI00PF+alI82cS52nxL5bHXB?=
 =?us-ascii?Q?UnQzOFPujNc/MVgAc0sxee7onXjZm4oyYolK7nR9u2QEYn0yjA2ROX8kYwbL?=
 =?us-ascii?Q?8QEwQ5A7VdIpXU0dwQmYi7+Y5ors7xgGGevBYC5m/MGMFc5HRtGAUIXr3aoI?=
 =?us-ascii?Q?mViNN4+nuzK4qQrb3kFpqIEnaH+Dhb8T/MgwRJaJPtP+YA2QrO8ZMdlXUkLg?=
 =?us-ascii?Q?W0xwHTFfKyE2Mxtad+9jxtLM2Yw6MD87dRFz4F+/1feQOmoFoe4leJgLXijK?=
 =?us-ascii?Q?yT0qnXPVGO2FqzjIhyw4GMTDiAgWQM5lnUk5n0oWaaYXKXyqWOBm7YN/PbNt?=
 =?us-ascii?Q?7iXbytT5nrTw0wcpYA60g1UkYwpSmhkabUEiAUav9bnbK2P5KpH1vK7vTf7m?=
 =?us-ascii?Q?daki1ETxWHp4/SF3MhA4oqhQnqJok/FSm0HTTDoqtyuDQUZix+TExKU1/3zE?=
 =?us-ascii?Q?3ImFlD0Uoz9ov7pr12GSELc6ek8B5XSZmw+Y++B1+WIrnQcQRJE5U5KKljjM?=
 =?us-ascii?Q?QZ0HOIA3tzj2OgOvea/OoriAaOkFTdb0DRINSydpjC72vHBTZUAttB6LYdwx?=
 =?us-ascii?Q?eEPKDuQ5ELUKzeLXXdCXeVSYF1/kDOmm5UtCM/fAVeKiMFhKnqYsvyzEOaSk?=
 =?us-ascii?Q?bnDbf0r2ISKq4nm8G8Xxc12y7CV1Ap45/xbZbIQnIll8Vgz0JqzEbdfi+wHG?=
 =?us-ascii?Q?i1GJisCZ7FpEWUxKuWn/7RYmmb9IpryUrHfLWS5eYektyEy/y4WqE5svKwCb?=
 =?us-ascii?Q?hhWnWqIJ0FGXN8PU7vPh0z9WQxCejjm9D54ANL55F2IX9Zws+u0n3lqpe52w?=
 =?us-ascii?Q?ZYS0QqVa6uvbKKY4UgLJnIMGcapSY1OVW/Kis+xjklBpw/5d60i6j71ecvLc?=
 =?us-ascii?Q?HEVMQScM4IppfYk1r0CYXYYLRv7HpY3cFAI0XXiyqXASqR/dKeLtPsMqu8K5?=
 =?us-ascii?Q?hVVrAh1vNsHfPHaNiUHmYP9hlA4VxgFhoon+Bpu/23CD4iNifo0q4JEu10nf?=
 =?us-ascii?Q?pHP4UX2BSeKUKnbhqXbyJ3XRJ/SaKKEvAbipyN5+5FwaBkUW9oYdcfeuvWYj?=
 =?us-ascii?Q?a/NQixAAAQH5GPqh6foTk8dqfbv5p9u8j+NpsJ9cCY+Yi3R6WbdLWhDu29i9?=
 =?us-ascii?Q?QDTaNtcXJOBFEFLn0sh/qzMJCyTzkAixHFdf+T2nshonwzg5Ss2jgYk+3UlJ?=
 =?us-ascii?Q?EA+ad3NTy2TUn6hBVHm0gA7Ev/Oawz3m/lCsAXOziBU0+btF2J/IEWk8sLVb?=
 =?us-ascii?Q?JgQei+I/FyLtfh4nHvTxuGivt/6EcoTgTz+LsDN1AOxb9a/kG2RsYJBm9UXf?=
 =?us-ascii?Q?3bRFaBL6KwCgt4+8D+wEnV25u0nVCzadITYl0sYQnY8Qpv4vzFalr4edlT19?=
 =?us-ascii?Q?n2ynOnKzGPCBsGDy9s+jopko8RYUqol2ybTR2ssRxayTyT/GJSyc2WgImqX3?=
 =?us-ascii?Q?n+HClEstaHvRAOhdKR8Mkkr7HNerU49Fmmxw2XVKv/3r/vugBF7WkxZ11YKI?=
 =?us-ascii?Q?adiX5xmQKu3NXUGXHS6wzD5c8+fa2qemzc+YYouSqY71Do7rQRc7plSYc1/0?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N0Cqsk+Bv3DrxC4gB3O7vrB2UtipIQlG0AIH//+CaoesOATKUO8gvDwksfmtbIAgfXM8GnLUtXd6mOgBFsndYMnBc22zS5pWCd2pdytkydRWiZpvMvTft6iA/GtmqGuKmUcklcgMRLsZnhJotBaKdQ5q3XD6xyMcxdT5C017msbVb5kkCVrOzqv1JMNtJRXRvNpftfFakaLWUhXJ2m0l2aIHXzyzaDmpycwqXccAdbaNJRaECuyuTvyPFIntGiaQVpT8KABFKzt+83RIKobLZX1H3/YqfKr5ATfJpePBPWn8EVhhqPNiTpsfKhQKaYX67pW7n3Xsyugj9uz+B1MBj4fFnYa0rnxQN8LleO2pXZwZVaT3DX0hzJd+9Q59f4EU6XOYZm+knPsYjRyN+MYUbPXFtpaLIGU5Qc/Hx2Cdr/sSD2DMtR7VflmnDVKA6CSt+IO12V2UsZ+jiwJormylZtLTSUOR6SD+Fu+0qBAXe8FWPSONlQUKIRNNDEkU088FqZh1sktSY4m9rJM73K6RGipkF4T8TrwiddA3LmAK1nGIz3v3NODOq34RBwIwfwnyYLqScBewTAfwpsAC4e+YroelTjNeawE/vPbLT6ldsl0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609879ef-a243-4ab9-aafa-08de1b84b371
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 09:29:49.4801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 523904IPqjs65VA86IBHVP8RENsIM2BTIhqW37s4VqxWs/7EMFk8kmuLw1fRIXMpNS3oHQIksGecrMPuvv0CElTnVB/uOsMezaUzXnmB9z8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511040077
X-Authority-Analysis: v=2.4 cv=cpSWUl4i c=1 sm=1 tr=0 ts=6909c790 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=W2uyuu2qsWL_TPgs8JUA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDA3NSBTYWx0ZWRfX95liQIf+CnJm
 NCfLV0MGK6xsIBaUp63hyHOsvy+/YWCQGo1hkNsBhchBYhWcrcMiOgP0qsLZBEDgRT7iK3WzwTn
 l3V/9//VUizwSFqgI1dn7DBLmt3iG95KwPyLK0RNf2veSSCZ3wRaTu5aWG0p1Ldv9hI9UU0q4fv
 +iFkntaKoek2LSxah6Mn7oTWAabi7ubarTW6Gii0vEOs98UXzr0Zq2To6KLumBqPbtqZEhdNBir
 /usFA6gKDO98eBQQrWO8lxdT/22t9hQR//3yrRByuTQ3HCPRtGnLs7U7mNIXmaxtZIkvYSj0okd
 jEn0GnaN1sU1OCmykXj2AiMuaiAuL41Bves1o7ssHJOCLp9D8UyGVq/743gIjc5KLtYqGWk26aA
 oUAgQXRbGIDWfb9tF5MD3WdcVNTd8l1yUrWFVH7F8+33dXqDEW4=
X-Proofpoint-ORIG-GUID: hyu_uEQnSvBq93RCOHYFridI47R88Rvs
X-Proofpoint-GUID: hyu_uEQnSvBq93RCOHYFridI47R88Rvs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F196180006
X-Stat-Signature: bia6xr5gh991uid7fx1mm5umqwg9gn39
X-HE-Tag: 1762248597-525310
X-HE-Meta: U2FsdGVkX19FwGoSmYQ7HzBUEZWy4ff1iI7xRx3/izF2JcJiQMFkN8vkSd02UQncHnQt4YCPM7TbNNF0tBfSMgqAYhz2nXJ7d8qeCSFLp/2nnGKHL7mc6pvl/zv06MhStLFAY+jcXIs2zPLGZ65eS65R4hUVenUNESKQPm4bwOepL89wrfWRlBN0QRJ5urGxAbMLZ63ZI76M6G7rcdZmmjkN5OfWzkeY+M0iBqDnpnhDS6qMNDCo9+B7Y1lwWRa5AhIxn7QIDCCWlFKldXy/koGbtPUIhXPA5F1CKiNRRVlY3PHMprFwgGimABsrUOgUy6fm4fg4++0QR0sQm3obdZMjW4FpJ5h46aAr3uYpTXA01DBV7MIaJvHOu9hgw/Co03DaEHBSZGkMsaKIeKQHHo0470GuKyz8PoAt3tqzbWbIL0Nqi5juIdkwQbGK3L58y/kRr85AvSelQTsVhR8K2qIdFBXqg834uilIvLiMO9K5ZIOA3gZZrGjo7g2rub4IRpWy1ecvzjz/XAOiCydZnQHDbThSmYNekCUxl2ycG4jKCI94QVZji7RKF2s9bzxssYNaXLwftYEo0nqKBFydlobOYWOcKZJAcMqteTHdcuz99r8O5kMlsXCWM5cEXY0ip4coO+ePi8lM6y1soVKn6e1V25ngWl5p7iL6nnNCL/V6MvxJ9Vj3jWgkIoSJ9AfuvbySvYqNdARbGnBrbdhzrAuYI5MMwsVLVpj6nI5yRpp3SERt9SsNZGn3OTcv614ImnH53lFtE1LU/k5tRvg47UzjXMnAICSJJaA9ytKYhaiGpLVHYeCJctC4W4uBMF5btldefZDm/haIlp1H+y1XLqbzvr9m4mJvuQvCJgFmWjqt2j1y8lUQuHRaPSGy4WK7pk24GbMq1eK1vi3+k/3q/naSWZySFvrREQIu6qvfbDp4jWWiyOyM+tC1ASRSogRneIICEVG6xwheWyqJL/N
 6a24fC+H
 yQTODCYOQ+erTmavVEbRhIPaP9NnPd7O14Ah6VUDiRrzE2QAgVRQJNDajnCJTiaZmHx3g+CUIXi9gT6gaHZmlkqyYOH1g5jp8CaF7zcz/hhuEj/OSnQEJp7lToqscQllJlpcezpjP/4+fMjbBuR83kvFLFcSHqXUdTq0eB0g5ztsWcyzBNRF94w+jo0UMznLjvhPkqiYFrUC4WVtKYVrvdD9b8+/GT5H8XSJ04Ze5nUp0nu/VZ4gxsBWukXSSHRfwQowiah1rvoG5QCBcdlJmQa4sNAg43PITXjIyvH29swEvthNh6O69pp1QKcThL23io5ey6e5NMAzrwHTA0mPqhf2OuiQiBVV+/HOx4PLwweJx8AWY2oH4PYjYeHCdUIdyiK3JOozGR0fIJywLASm90gFMU3221bOqntvXPdnDg8rSAUV36C0dB4BMxeZ9502ZAKw9JES0I8QDs9atbRmUR7T3B9U5xGL8aYpLHfSiMuUUQrfpM2goKWz/y7vzSTp+S8AETvxczRZUM5t/Trzg9eKQPuW2k9X6VKKKVwzN7NGODsezTvLGLgwnD8p9qtiHHR3LBQQcJFBnk0mLUfTns1y7GCP5bpMjSBCt2+hMOpgeo2Wn8o5oReyLqVG/scVZth+K8nrZPUHvZADtA91ALFwiCO+FyTMvRwdFWBmoZSPltsrC4fZw1DgotLgQT7zUc5ToTteyHjkaEQ4HxxioWGSrlSqDv9Bfl1l+nO3dgzG/c+Wi5+t8sBnPkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 04:57:09PM +0800, Kefeng Wang wrote:
> Kill mm_wr_locked since commit f8e97613fed2 ("mm: convert VM_PFNMAP
> tracking to pfnmap_track() + pfnmap_untrack()") remove the user.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Nice spot, thanks for cleaning this up!

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm.h               |  2 +-
>  mm/memory.c                      | 12 ++++--------
>  mm/mmap.c                        |  2 +-
>  mm/vma.c                         |  5 ++---
>  tools/testing/vma/vma_internal.h |  3 +--
>  5 files changed, 9 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f27c3687ea43..9909e35ebb8d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2471,7 +2471,7 @@ static inline void zap_vma_pages(struct vm_area_struct *vma)
>  }
>  void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		struct vm_area_struct *start_vma, unsigned long start,
> -		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
> +		unsigned long end, unsigned long tree_end);
>
>  struct mmu_notifier_range;
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 4c3a7e09a159..1a1626bba55a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2023,8 +2023,7 @@ void unmap_page_range(struct mmu_gather *tlb,
>
>  static void unmap_single_vma(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, unsigned long start_addr,
> -		unsigned long end_addr,
> -		struct zap_details *details, bool mm_wr_locked)
> +		unsigned long end_addr, struct zap_details *details)
>  {
>  	unsigned long start = max(vma->vm_start, start_addr);
>  	unsigned long end;
> @@ -2070,7 +2069,6 @@ static void unmap_single_vma(struct mmu_gather *tlb,
>   * @start_addr: virtual address at which to start unmapping
>   * @end_addr: virtual address at which to end unmapping
>   * @tree_end: The maximum index to check
> - * @mm_wr_locked: lock flag
>   *
>   * Unmap all pages in the vma list.
>   *
> @@ -2085,8 +2083,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
>   */
>  void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		struct vm_area_struct *vma, unsigned long start_addr,
> -		unsigned long end_addr, unsigned long tree_end,
> -		bool mm_wr_locked)
> +		unsigned long end_addr, unsigned long tree_end)

Yikes, so we set mm_wr_locked but it was ignored since f8e97613fed2...

>  {
>  	struct mmu_notifier_range range;
>  	struct zap_details details = {
> @@ -2102,8 +2099,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		unsigned long start = start_addr;
>  		unsigned long end = end_addr;
>  		hugetlb_zap_begin(vma, &start, &end);
> -		unmap_single_vma(tlb, vma, start, end, &details,
> -				 mm_wr_locked);
> +		unmap_single_vma(tlb, vma, start, end, &details);
>  		hugetlb_zap_end(vma, &details);
>  		vma = mas_find(mas, tree_end - 1);
>  	} while (vma && likely(!xa_is_zero(vma)));
> @@ -2139,7 +2135,7 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
>  	 * unmap 'address-end' not 'range.start-range.end' as range
>  	 * could have been expanded for hugetlb pmd sharing.
>  	 */
> -	unmap_single_vma(tlb, vma, address, end, details, false);
> +	unmap_single_vma(tlb, vma, address, end, details);
>  	mmu_notifier_invalidate_range_end(&range);
>  	if (is_vm_hugetlb_page(vma)) {
>  		/*
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 644f02071a41..4f51ca644903 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1274,7 +1274,7 @@ void exit_mmap(struct mm_struct *mm)
>  	tlb_gather_mmu_fullmm(&tlb, mm);
>  	/* update_hiwater_rss(mm) here? but nobody should be looking */
>  	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
> -	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
> +	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX);
>  	mmap_read_unlock(mm);
>
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index 919d1fc63a52..0c5e391fe2e2 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -483,8 +483,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>
>  	tlb_gather_mmu(&tlb, mm);
>  	update_hiwater_rss(mm);
> -	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
> -		   /* mm_wr_locked = */ true);
> +	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end);



>  	mas_set(mas, vma->vm_end);
>  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
>  		      next ? next->vm_start : USER_PGTABLES_CEILING,
> @@ -1228,7 +1227,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
>  	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
>  	update_hiwater_rss(vms->vma->vm_mm);
>  	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
> -		   vms->vma_count, mm_wr_locked);
> +		   vms->vma_count);
>
>  	mas_set(mas_detach, 1);
>  	/* start and end may be different if there is no prev or next vma. */
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index d873667704e8..c68d382dac81 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -848,8 +848,7 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
>
>  static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		      struct vm_area_struct *vma, unsigned long start_addr,
> -		      unsigned long end_addr, unsigned long tree_end,
> -		      bool mm_wr_locked)
> +		      unsigned long end_addr, unsigned long tree_end)
>  {
>  }
>
> --
> 2.27.0
>
>

