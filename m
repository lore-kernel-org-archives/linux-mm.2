Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6F4CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF0C8E0014; Fri, 12 Sep 2025 05:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F5B8E0001; Fri, 12 Sep 2025 05:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740418E0014; Fri, 12 Sep 2025 05:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 637708E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:16:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3995C1606EF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:16:37 +0000 (UTC)
X-FDA: 83880042834.15.C61D825
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id C248A10000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:16:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gmOk+zdG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LsEQ34oP;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEqU7vqwkowJg1UVF0GM7xmfD8FeNQ3Xz/P1qQvqNAE=;
	b=3zzi+BzpH/A8K0Dwt59btVCWK4KMbI5jj56YYgktZxcNgexdXBK92ocfx0alkn3HFnaKjW
	vj0oE6HQmOydwRXrc0LGvjE+5nVqBRiXOSK2Lk6CVh9nZNf6uDG+78qdC38fE++UpXVmjU
	BVXzEBbLNUQnl3u/zK8i3+lzZuhcDYI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gmOk+zdG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LsEQ34oP;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757668594; a=rsa-sha256;
	cv=pass;
	b=TJ8e+EBP+IRA0DGaSCV01EWDZ8Mj3Il24vEhNy1hLmuGW7S0+QaK21h3ppClUTujsYY7ru
	OiwgVBoiWqYI634/8v+ABtG2K2BYm5VOQ6TJQ2k0ZNEQsrlqItbpQfYmgoF2eYyS8E2fle
	qDWEiPqzhJj3AGktK2Ou38pxW7T4V24=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uQEq016813;
	Fri, 12 Sep 2025 09:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xEqU7vqwkowJg1UVF0
	GM7xmfD8FeNQ3Xz/P1qQvqNAE=; b=gmOk+zdGhxYcMMRrgDxLtXOoouVyhP6YXr
	QVDkADH8WHA5otC+0O1a1RoXNEo/AUY2s8stUxy/Q4c7c56ndE0qrURG2hBWldKr
	O0pl0lAyJqHNbQdqbx2vxEt6Ornvg6uCnbLG0GZdQTYnyhRueaQqmHhcUdqz+yy8
	0RbF7pokCO06pvh37BIedaA2ByGZolz7py8sBZvEvnZMeIuI4vKY/brzzAhAm4Q4
	S5Q7Zi1I4imrUxuXsLu0MkqfHLoXIx26maDnKIXjwXZuxf/6NPn9n8Nx1lF/XA5A
	+6k69rk3TMRah2TgPNdI5w+6QnU9g8QwIGqxCwcnwu0yAb67aaMw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922967wxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:16:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C80tTH038949;
	Fri, 12 Sep 2025 09:16:30 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011028.outbound.protection.outlook.com [52.101.57.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bddmex0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:16:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ta6PHqiWZzTdT2juTfoPpzMNHNfcws4g7IFG+aqz+qVBVaqj4DxnucziFD/UOodwdf6NusWiElqjWJcm9+k9jIpxDnJ2w4ALFkHpwD2PgSTa7b+iXVEFlqiPvk+LDhtqxJ/DjnmeyXGpOpoyZwH9ms/0sf1Vy/4XzDV5Jf+yHhPCKPCLshVuyufk8MCnU1Fz6qcitFjkP9Lfk8XRJ7c7GsNS1JpEqvpSV6DmTdRkyDcDFQCScnlIJyGCNXk5BJyoBklmqYQvRgKmb9il/C5JG9H8OTwGYh1pt/pM7R5V0B0wae7ETL+cxDlYLhHHvRCN6SZzm3r6gMFyA7vZ4PJhHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEqU7vqwkowJg1UVF0GM7xmfD8FeNQ3Xz/P1qQvqNAE=;
 b=EDq/y9e0VA3PRFzhP5EBI1tKOGqH8mwC14OSfqlVHBJOHa4U5GPpHffx97fFYLMHzC3BMLA+SuL+1pi4wPa7r7m2Hy+2icC+7wIS07S+gY02qxZTnrMIbaezFmAgU9wtZQGWZrPNEiJqU4NWXEFPbAjoB73Rvp0zePDZ8zdFW2q2fHM9YYdr7dsbhjQ2jA7XKviPc3AhcQTmLh3BF18JNpk/4QhiPgigMB4+9GfnNn8aCNA0kmy70q7sYr8XMHlSAW8PE8ANgy+62oufQTosr01rC3ht7XL0syDOMW0Y41v0zr9C0igMsEHlte0D1j2+dyTsrSViRvntnWuVsnVuEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEqU7vqwkowJg1UVF0GM7xmfD8FeNQ3Xz/P1qQvqNAE=;
 b=LsEQ34oPa0oOupMzirHBF34Ej4flCbRUZlgaDeNiZylyXAVmIILkzO0Pzogvk/n72TN8cbXwRrPTC+g8V90Ah5zoY0GT5tvoUqKQ77BwtzFAgsl/v7ERuLpQFvT3Oc1MbLahyHSZGxup1proFQffra8HIHF+mzV8Mv5F9lW2/so=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5621.namprd10.prod.outlook.com (2603:10b6:806:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 09:16:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 09:16:28 +0000
Date: Fri, 12 Sep 2025 10:16:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 423/440] util.c:undefined reference to
 `vmf_insert_mixed'
Message-ID: <4fa9c8e6-2a90-4482-8693-9bbd158692bc@lucifer.local>
References: <202509120557.Fjb2Px63-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509120557.Fjb2Px63-lkp@intel.com>
X-ClientProxiedBy: LO4P123CA0260.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5621:EE_
X-MS-Office365-Filtering-Correlation-Id: a8f98a1e-07e7-44b9-0d4c-08ddf1dd0e60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k17LpviBBn8j8lwrGyz8/mOvcPvNxrVpDoqiao09cjKf4ax9PAQn2RI2b3WU?=
 =?us-ascii?Q?n5P6eb/nuWhPL8YC7AKhTqPCbu23/No5DnH/R7yleQyjfP/hcUhV+PsrulKg?=
 =?us-ascii?Q?rq4li2aBlG7JgiEZx29zCfgBSs3fzuVpaT5PzVVZ1gZxzPY9W5cq/aO5itGw?=
 =?us-ascii?Q?G/WHCdPYCfUUDQZ2t8jr+PSSGBrTAJgUy4yiTudcnXS83oe+TLQRlEA9TtRS?=
 =?us-ascii?Q?xr9B1KUWAbrM8jLgy+f84CiQ/0Gcfzq0YOYdvroHF5PiRu60uNOSXIZzF5tp?=
 =?us-ascii?Q?YelI7OoWeFMKcMfeqPjXjErVCTkIZ6rud0+ruAIVMMTnCcY2r9HwZYm0kR8t?=
 =?us-ascii?Q?Be/SGS3EQ0zmSpABz6RalWHb14b363QZhMELkSURv39fMaM2+GWIGlzk/ndt?=
 =?us-ascii?Q?ONi1h6VbkJ7eMDtWWGCJVYtPDm/MRhzvLA/mExBtnNPR7YxbUu/VO5nI/1jt?=
 =?us-ascii?Q?qTXTeJ2bZU/K60L0SVVtGKmKKibGhvu2Najq2hl3dpk8cUQ/KblTRfmnmoWp?=
 =?us-ascii?Q?1bUSx1ZwAcK3he3B/2/Nzrg3U/bn/Sp8mps2tUCLCRsx84N7wMTpbtfEugmd?=
 =?us-ascii?Q?WYtltHwZWXcN/lpWr8tjRL1sumkiqQS99+a9MTF+ywL1G49KNvDimFlzzaLY?=
 =?us-ascii?Q?mpOP5Uwlfp02Us+ONqDWmb0Hy6RuR9divKOTX5gjhHF6xW8CNnslosHbn1LD?=
 =?us-ascii?Q?Meeqjs96RdYU+xpRqdYbMwFIaOQkAsnwD89BuNjQ63yWDoWmrsMmRnzW19uh?=
 =?us-ascii?Q?nwuBVdEM/JwoE+Dy3DI6wzcH3kr75uFApcjvW/h9ShAXILRG7wDBES1vw0hu?=
 =?us-ascii?Q?Gy8beJMNoCuon29aFiXvhJRG+wGIvNwvgG8DIzM0na2CXwWO/bchsGD7GA7Y?=
 =?us-ascii?Q?9JnxBCiAmx3w8kJaM75BvMhMfJR6AYtqCXOYVA2d6oRt7PWlxTCkjikt+iD1?=
 =?us-ascii?Q?YF2oe4qUSzpdY/xNS+sXoxJniLx2QHmSSOY61RDkFCOtUggibw74wSEZw9z2?=
 =?us-ascii?Q?cya+WkbAmYHva8NaovSnjebinMrtaRtqlqEzgoGvM7NVfcEeQ0JkPK3qHmdZ?=
 =?us-ascii?Q?iv4ohSb/nzalHJjFvNNOrJb4AKQcRocPC89BKnxu0en8kWFjeA2w+AsVlKpy?=
 =?us-ascii?Q?AHiTA6ifFKdjKChywOS4zNK20kzw5oTHx6m3Gu8Ma4TjajL3F0Y6770IaMTI?=
 =?us-ascii?Q?20Bu/vq39cF94Uyk2sV07fYL4Yo8n+w8d7cc55PpW/JCUTrZrH2VboahBAFF?=
 =?us-ascii?Q?X4cvNlP1bIOiRp8wrOLGYI9zI50rR8zM4egbsBEFjGoEV+aRguzQwE9m0Doa?=
 =?us-ascii?Q?nHn9aM/GYnXxLUwjcoxfd+9KqPx1l+sXC6IdkC/TrKmm7GUS9IK/LLnPGj3E?=
 =?us-ascii?Q?76GFF/3rPPxNyZIKQFy2Q8TNs8fX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?THQSDjqrVHb6jfef0X8wpU25LtZlFiksxcyHzY7WE5F8ZnXB3SDhtfmgFbnU?=
 =?us-ascii?Q?iyuyRi0rmHB6ag6kEpLtdLszBATO2H0ilD/5Wx2yOEH5ezG8Lrs3k+C7sBUi?=
 =?us-ascii?Q?yNWzOgV0UUhrP6Bk1CJwREa710HFLwcWm6F4ljKiAF5mv1hG5CNPaUNuamhu?=
 =?us-ascii?Q?cF36pF0N6XgKfzrAj8vLpfjsxu8EoOh0Vkj2KOE0rbDvudqEeVF4Iwg5nDkp?=
 =?us-ascii?Q?QWXl/XsqfXr1RgGCDYLhPVBSt/r9HnjDM0+TskhXvr8Qe+IjWhTWgJv/SVS/?=
 =?us-ascii?Q?bE2bEBISBRsRdiExjgT9pLhjUiDe5OZXWC2W49orMqm0DwrtjSZeRw7s8Rqw?=
 =?us-ascii?Q?N8LaF8+rCPge5n7JGY76+52pRM8RYCeTurB125LrIfFgw9zP3XqeV+7jmpkF?=
 =?us-ascii?Q?HnIGBLWkaYdv0kWMY2pvDCmJJDG8OBNX/PzFo585PzALBZefg05OwjZ72KC0?=
 =?us-ascii?Q?QwQ1Xeh8zObhjsEUKvxvDucYso2z0BohW12eqAO96I1YCD2eXObalU+7SQA4?=
 =?us-ascii?Q?4e8FS5KPzS8uJrEOc0qwOrNolNRizwaWP4KIT6K1mG7i28b57PdDZlLyJ9UT?=
 =?us-ascii?Q?gtfLXfvzPmDFmlGM1rviaPuN3xu16AHoUZfG2+yEG3HI01IRv/KSBj5ak/HX?=
 =?us-ascii?Q?xQmt9EyljPLEdW/RW2EYaFOAgfhsxQEbsyJPr28ELzbVMEZFsswAElW6k8Q3?=
 =?us-ascii?Q?Tvp51urzPUtyExLYQyze8ldVnFBwxbwygWY3iKdShVpLeveR5xd7whjCc0TO?=
 =?us-ascii?Q?9jg/yFIKheKPa6pT5RMiQ+uzkn/EF0aOBbHbdjTsGYBe/BclXa976jJ2t5op?=
 =?us-ascii?Q?zkzXxBPLZojZ5K8oFHPUxymDMljz1l2Za6fDkiFPo06r8g9QC9z5SLd/56L7?=
 =?us-ascii?Q?+Qrz9XPCJtaqbMnSUXFIdNZcmV1xpOEhwrjlJcLNgfrxha8vPoT7Wv2rAXaB?=
 =?us-ascii?Q?7bUV2CqGNt99VO2Nci3p7Tf8ub6huZ6z6V04WqCN8Sw5kx2aeAP6W97KsS9a?=
 =?us-ascii?Q?Wg0WnWdFKZ6tsZQzPqjHw6jgiUR7TPE9YsR30nCh0o/FM+mQxCl51nisPB6G?=
 =?us-ascii?Q?CBP9M0J7bB767FXi44y93VhztuUt+TZ+xZN0YM0C8BJGPeQ6Zpt2G5KVuNL2?=
 =?us-ascii?Q?mfNtGzNIYBHNxS/8rEoqaXpxheOTl3dvEZA/dwLwIXl2NjjS+FINIBDtBHwW?=
 =?us-ascii?Q?SnboWgq/pChqI2XkHMT/fGMBPoKeT6gBXXE038qPwVCJsRJyMGEj/ILn524Q?=
 =?us-ascii?Q?mC3SHKCV6MI/Nap6wGwnpKbNSIJOcvlJaUcdun751spsuol+5JzyQx6DACj1?=
 =?us-ascii?Q?hCdzBG1MZtZpgik/Dc37z99LhUBuBOeey9C9FB2i2oa99gwzWkovFXrTeij5?=
 =?us-ascii?Q?0PoLj/GCQD3kKoiDAqpZiv1ljRfYoV6KSXlMXIbNjcfO/kSwpervPPpOY30W?=
 =?us-ascii?Q?xWSkcyZ9ZjKv36XV+HveCrjs/1yyiKapGQIvIM9g3s5hUdlxW31OPfYjI37c?=
 =?us-ascii?Q?iUTbm80xKPb73oPYu4EdAnCb/rgzWCXzw5bBl15Iq7GVZrG8BoVn+BoiL4pU?=
 =?us-ascii?Q?dUXluI0XK1mN76bn1mwLY/WUsIzgwjsypcG76XeNfvCoSZKm3kZAiEdQub45?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qC4WeImicGaRArlXGIVw0nEghG1LkaZjsko1rUfurWPTl8Ppl1/hhZ0WASiEsP+NXIgu5lnOXpLMucJMeUtsAG4Gd7sSGyTCFV0f+UaPazW+ZUUybfxHMXqtY438J1xkUmUWVJ/MSGs2vqE7VswDjzY+ztv+RIhs+JJdmAhvuna1A5saaTZ0AhtoS+G1RalrVOvTST1gEV0yO2geiEG7sSOAfUdTPlUEBcuYVjXQeM7k2jlwO+iHgPEuvXTMcFNTxz4PWanci138EyjBD1qFGBOBjM+8Dz74M/gpUErGu6EZlJjeU7pSBpcU8tBx364rGqd1eg3cLH5aSQ5EQc1R/xK9imO1+ucehteycRnLlQA54nuE+rO7CAcIAYVn/qk6SRaRojI77EXqNBOLSjQNwrpXVEF1umGH+CTXnlkeeMiDWU0pXyhKsL188JlqCaRfy7M0wFHNYN+7na3LvRhsQgdmILqkAXp8gYJyzEWw0unN0glo1f/M8YzKGNremYaHiDz5sd78tfXLEFFhmtvBzcFWBJikdQSxHN2nnYG6U6KQMxZNchwvCXwMIvH6O+roCCi9JgDpQzZkHUzohR/9FGgYxnCmBnz99akpV87wDo0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f98a1e-07e7-44b9-0d4c-08ddf1dd0e60
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 09:16:28.8302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1V/loNVpmRffNFNoOAXsTyxQIEDVSTZ/DnOsDhtnZKFLm0055d6xSOtQJEfHtgcvO2MouM16HgTxr8GYj8RdNDI2H7DkRkF0pyaWtGnlMTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120087
X-Proofpoint-GUID: qWxUWytVn5rPMEuY0dBqMA4TLyaxuAag
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c3e4f0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8 a=59A1rTmvA9R-2usEGG8A:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX753O1XDzVRHz
 gHj7aYx5EL9Eh0U6izTjZIjMIrXFtNOjQn1RW1Br+KgC4hke1jSAXNJQVfTOW6xAoBfIBlxWxc/
 Wz0QDZ/mJE0LyzBnqvR5Higz1VKg7SztnAxhKIvPLQClyV6ts/BtT8WbmtNzjGSwBLW+tBhyQ2d
 ZdwSnzkQ15E8eLlxUTPIFYgwVEV2cdt7pLHlgFtxCZsieZnPiK5j8HCg3ZchQhTzvQjEy4SPI7o
 feegWdgAtzt2ME/rhdXn2C/18yMJuij2blzwq60ax5oKVLkPmcDynNUQL8OeGB4iTH+ib/Ivc8D
 NzJ5xxIzDlY6rHDmUMA+0hmKpAEV6+RQf8CYBKunSBW2u96XDUZvdNTBag5UoVZiaxPuzZ3Ogmt
 ZGLixlAanKpsAZKiVd8SKiltrBsjng==
X-Proofpoint-ORIG-GUID: qWxUWytVn5rPMEuY0dBqMA4TLyaxuAag
X-Rspamd-Queue-Id: C248A10000A
X-Stat-Signature: 1ksndyeztd5s3rutbi484xw4w68oc94a
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757668593-642437
X-HE-Meta: U2FsdGVkX19JuvDTaDhVHjMAl5Ric89ZNMYHW7driyPO6XeF6VE0JuJ+vGkLbaXfkTG4kgva128zi1kOib2p3i18LtQziXbrzA6EfySI4VIKNnjXpATmsvEC5MmDCdJCfTYFYoXOHl1D4Mxu+HxtW04DrYlCo5YpoZ4EAWtiWZZ9w/h//OY5d4N8wS79CD5oqy/QT43gGYz2OuSQqVXUA9YbR5PAI0YYgGYUT0HVnZmQQXZtgBhHarZjcVFsWeArW8O95UOBMKl73GXpXe6gNILYlEzeeKrtgrPByW0uUqtav3ZqPAflkqNx6likPjSPnhrXN1c1C4OGHCjybrIqT4UCKkiKD5SmybmkrUDEc5VrxJPGhL9lHb/Wl9tHC5Wo3V1v5d67JnC891jsGOBBO3R8rInAGa3kr4eoq6q/8vTE5MEDOJzN9Mu3anwgreblo6Fs94vqDuiiyfuumkuU0tR1UzOvcBRj3q0Aj60T6MKOEHhuUndaspB3THW5oPpbFrsQNev4v1w32mpj0jR9YAHIfcTJweKLN8f3JgoNMthrlCciiLL6w47Y52wWQCf8AW3V7GSoMxDkXlhANIEJBJ9D1qcK4GO+Wh0xjwV+HsowRVQn6t1h1i9aGrIrWoOaNoy69y8mtfHy7wY8DKtLGgd41AKr4f9GQFJ879nPgdiMwm4304SVSdMBbbrqcbo1YPOroT8n4rqjAeqxGBUpmr1fWy7n9Ke2QDMSykMBpjnp6u6o105Jqn5AHePW4XEjK+8zyf7ocUs3ml3eHIBn8dZ9bW4qjtMq4zQjLyDUagQE6BKbrPo/E61KCyN9jforbYVCXu4hT0oXgLxazIM53krORNG0dZN31sk7xuGBizDEI/yz1fnTJ1QfJTItO1EE0weFOliVz7/9i9VaOkccOqollW9veUHATSZ03+r3y+B1GxGm66rWoaz70N5rbta96UlOHzEN4mc6bRCnwhC
 H3ndLgQs
 0Bib0f79+9UN13JC8vBpBxm50nnwPJhylZr0BPhmMG0mPUEiaB29LlDozJJ43zUKIzjoZ+qLTYbLND4CXCIwmpsLSGr9+Yq/xjbYclSpXJkXV37AOreBXoI2YLkc3oubsgFYfgsm7jOyxXViTrQALQb/SH1N+ENYYdosQK5TTZ7CoB3BhwsT//DQeGMeMXcXIWt5U17UmvnnCxU9JrK8l769JYGJ0xPXF85LP4YAIRlN8zb3svoVu+J6Dp7TkmcWJW5XEO5lcYGVX5QWjeotBvhNdbdNJgNhHMfG167pFNrUNiV5sGP0KpITjKzSkZMk8b/e2/cdN8KWOyyE933lP2jtbysdqbYbdBSRx9AP0fVeaSglAnl086ZalrohrIbl9P31eHkXvg2MR6mH0fWYOSpbleVqR2OCDxy56LrRdd3iIOs7XWFlTjqsEUJxdSb/Dp/CNgReKNXcqqKD2vqgmn9aCDDRBKsiAZFhQJ4ZbPSBSqRokJukmhIf0PLmiRVy7Y0ww5vryE1/xEZbyEsEiQjV66Y57nS6BhcL4nFlTnIZMxtC9AfrO7tgm7CvneR08swQIVh6QbA89quknyhqqtk92jF/iBEok+3GDp0BolntQm4Jegy/ire8MaZPjHv0c1lzYJG0yOshzcbcWUVfMHCapp8SAdxBGd/cigvroQ9Jzd9g8z6CTMSfslgL+h8Pq9vFcNSQz10fTiGygEjR5XaqLJTDXw2rPQwvjVtw5zxPxFa/v5Fv91VP0r6LBsxtHrkT7fwTIUXdy0DDGYDACSx7YxeHq+bIlzP6rqr5BpTK7GSzo676+KZjzFxsztujUfDJMYUWFOZv3ZQGTOPbtzjogxEt9hUuRIViM8HJbazsLLPZWKJwHoSJHfmJ3uEpaKaWE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 05:31:31AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   31690ac95cb30fd036eeda36844c6e2820685e7c
> commit: 52b3813194a48b5dd38cc3d76686e0b060171b0f [423/440] mm: add ability to take further action in vm_area_desc
> config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20250912/202509120557.Fjb2Px63-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250912/202509120557.Fjb2Px63-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509120557.Fjb2Px63-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    m68k-linux-ld: mm/util.o: in function `mmap_action_complete':
> >> util.c:(.text+0x92c): undefined reference to `vmf_insert_mixed'
> >> m68k-linux-ld: util.c:(.text+0xa2a): undefined reference to `remap_pfn_range_complete'
>    m68k-linux-ld: mm/util.o: in function `mmap_action_prepare':
> >> util.c:(.text+0xbe0): undefined reference to `remap_pfn_range_prepare'
>    m68k-linux-ld: mm/util.o: in function `__compat_vma_mmap_prepare':
>    util.c:(.text+0x10f6): undefined reference to `remap_pfn_range_prepare'

This must be nommu, what fun. I can repro locally, so will send a fix fix patch.

>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

