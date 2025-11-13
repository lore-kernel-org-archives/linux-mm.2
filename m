Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D0B4CD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FDA8E000F; Thu, 13 Nov 2025 08:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58428E0002; Thu, 13 Nov 2025 08:25:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F378E000F; Thu, 13 Nov 2025 08:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE8348E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:25:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CC215BD95
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:25:58 +0000 (UTC)
X-FDA: 84105656796.22.13A6031
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0623180008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:25:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=idEmdIOr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KEpy7i7y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763040355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzDf2sq9UxCgLCpM2swe9MyZOCNVbls/Imov0j5Hrt0=;
	b=ss0MMrx3zqsa/sXOeUFy1rIdbJ1/HsM/gzfuVCmPvL30HJ3hilHFKeStwbAuj6x66M2dfd
	G9pH1I3t1TReb1Z/qxE6Y/XW6NCmTB3/ihxIGl3xiY2HMPIjDUYDr9os+QbsJxfqGMDvpO
	t/hy8TBTPT1ZbB4pQVhpoRi6pRSLMUM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763040355; a=rsa-sha256;
	cv=pass;
	b=ygi3KtxflCfJJz7+WFHORV9N+SH2ceWMjaxuIuyrKf27bR3IEZQpxzxPKFjGQz+haLgYno
	ysQADsTKtcYXnXhffCAITRBGuBkzLd3LLcnNNl5cfiTH2zB1skS6RjK2L7b5jzJ1p8eBBF
	cNRQrF4GozKZWP5rE8BdUnnW3Y1LpZ0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=idEmdIOr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KEpy7i7y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCPM3E024494;
	Thu, 13 Nov 2025 13:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YzDf2sq9UxCgLCpM2s
	we9MyZOCNVbls/Imov0j5Hrt0=; b=idEmdIOr2REPWPDdokCAUMrHX7R7zXoakJ
	DhAynfdH6RfW5PWZJDEbbLpaqhzzzCBeKbFvpNpR7f50z2BZFNC2NDwPw7KghtCF
	5F6uFQmOXdQdjRS8D2ZxddHQWHaAkyarD633hIMNAozSD8Lht1Z0pNUmUeFNILg9
	MmL0PBbUzGD/3YrKTy/KsN9Fo2txfGs92uyYpfKreGXmGU9NlSRYsmI1wx57dobv
	b7lO2trTqa3QnAG9BD0X24aD65F6/itzV2M/l74TbXNCuUT8C5JANsvzANz8J4ni
	ZD7ax21YuXdYppvmweo3IofZtLmhsh6N8iQar+ITWHi+I1cNVXxw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqss3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:25:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBwIPI000393;
	Thu, 13 Nov 2025 13:25:47 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vafngux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TVlvOAsqtxTXcTSY7GJXomF6jvfK6dfsMrN5hedJVwFIee7qmzziuyq07ww7eTYrtPI7UMfC1uCyr+7Loaird5s5UURWiK9IOQMvP22gjr4AzopwpjrNO//mdbN7j0Ghu1fdR82Y1jUKpcspXcf2NyA+sNL8+ojmm/ttXkx4TrASoWGvsWXxy09Y6h6FCxTzFCqhpaZTKPf4Qal64qh14TYzj/LT9siXmE1+Sj4Fh8Qq+CwM9pGtrjHx4KD8AMOedbqrzsIykAqxZR2iZOh3FANEt0uk/4n4GCNCdnMYspqiI1VxuX0QZVjCuPadEhA1/64ewb/vuP0fCQ3RVQ3x0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YzDf2sq9UxCgLCpM2swe9MyZOCNVbls/Imov0j5Hrt0=;
 b=QOSQ1a/5gScmPDPrmQ8K8+iLxUk/5Pp2MbgOA/jE3XmaQlTA0ul5d50DV0moVNjI6QV5apf/B+sWAf8bFpU17jhJdRS0+oxRY5daGQGyZCdBIKjGWn1WcGArgvnJ4kDUf16JzCYmZzhTgJfhcIr6WmMqI76KK0z8+CAAD0Bhb7/fcmW3q9xe2UQlIbqx0cxwBUCpHXWPKAAqPylHWze08KeeTcdDbJACSzMwqCWJi/tmY1lmMe3EwqHsj1dO3TIms4NpfX0X5DjJEIh89lYKgKbgdfdaj+UL34RMyiAfZNpWGjvfZgBraRycWfunZDllV3szzbu6EpWQPkF7UYr0GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzDf2sq9UxCgLCpM2swe9MyZOCNVbls/Imov0j5Hrt0=;
 b=KEpy7i7yVbOYpCs9vg02Yexkv+REnKbWT7xeWJ0eOWqWe7c2HCGKj2jdK3xGtRJPq0CL6wNxlPB+SI/e20CCjuVODeAVJTP7oPIPWO8gvArutYEDNEtlHKzjLXCmMyakxE5PgnxMJsg2t1IZuZYlD+iH1uyLdqdm80apl39uvi8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7317.namprd10.prod.outlook.com (2603:10b6:8:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 13:25:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 13:25:43 +0000
Date: Thu, 13 Nov 2025 13:25:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Suren Baghdasaryan <surenb@google.com>, Chris Li <chriscli@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2 2/2] mm: Use vma_start_write_killable() in dup_mmap()
Message-ID: <01ab3958-8a3d-457f-86de-2c7959b01d10@lucifer.local>
References: <20251110203204.1454057-1-willy@infradead.org>
 <20251110203204.1454057-3-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110203204.1454057-3-willy@infradead.org>
X-ClientProxiedBy: LO4P265CA0193.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ad04741-e537-43d3-9ea8-08de22b825d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oF0kDRIG5jsYq+zqMKn1HQfBTn2f5O+oJmCmbRAXyBdFfUMVdCn5Bjw1GG29?=
 =?us-ascii?Q?tYFM7bBoFuW61SzHBjJc1JIoLMLnKh4eICg0+ABLobrkjMnPhCUPPmMuhyjQ?=
 =?us-ascii?Q?L6f5fao8kHYyGHmSSB8zdGScBjCrMJ8AwjoMje+XULeiJTt9EK/Ort6izBB7?=
 =?us-ascii?Q?ZKbSzAP0r5DYatJpzkQfo7RHW03fZ6DxViRmOk9vecx9B5I3OW5OjDsgJyK9?=
 =?us-ascii?Q?oFg7MC1hpabUamc/MMIC1V1nar9pYdCUAQUPcR+VDaWnk1qICW6pLb7jiawo?=
 =?us-ascii?Q?+9tLhQfUoBS47tYIOILO3xGFE7hg/zV96KGTfJj9atvSPUWEzyWvixjNbx/6?=
 =?us-ascii?Q?rKyLKGBrCTl4zVis2wtWHEMFXhRNSzdpGTA2KauSZjyXuLUQuxJZxDU54aIu?=
 =?us-ascii?Q?TUCtsmnQ1JoXn8ntm7W1uUdHO4iH5UwOmzlgIEmu2a4VOz9vqkCnESBHeJc1?=
 =?us-ascii?Q?fnf05TIlGjtbHuuZexQgp9cm2uCiDHflTsI8ewfGpDOTXZhB+NR1gFnK8HTM?=
 =?us-ascii?Q?aVN4s9GyNJljika7Bdoijq9DAzA3xeU0yX0BiTGeJy33zev/qNeGuUKz1vg8?=
 =?us-ascii?Q?TTtWjUOX51+FIT58fXjnmrpm0HWpHHZg97yv70/31nPkdW2xI+7omeys1o0O?=
 =?us-ascii?Q?tDZWoRjkLwVE7gjkx4HwTEt2F03U2M1cYFbFkaDKAR2Tmj4GkJrK/eQSRz0F?=
 =?us-ascii?Q?LDN4aRJWN/ksoG4l1KtHQtuxD+JhJ44VPVmrLo/WmahSCkOIMSGuA+G8izel?=
 =?us-ascii?Q?pvvZiSY6ne8tZbxye+W2wItt+LCMgvQ590Qkt7GYOlI3vJFlAQaC0ncAbEBr?=
 =?us-ascii?Q?nMZkuTp6kIOghXoJyYTWJPQyP1CF33aW+FoFgp4stvZ4ZsOU8tAxfR/YZjD8?=
 =?us-ascii?Q?dww30VTjd9sl0UyWVYx8jTp5HEQttHcVj/C1R8cosas7k2okfR/4xjNOHwhu?=
 =?us-ascii?Q?5bOxB7b0m5F9aRLs18kUimeKr6XcESrY349arDHplJHXLyy1hs3j2PnrgZui?=
 =?us-ascii?Q?LIf5MMKcrHS7UgmZK1h/FnRN5YM2RaKQsrIdDj1TuZVUinx6UesLcXGP1pQc?=
 =?us-ascii?Q?xS1R3sTZTL5tJDVyrAzSVz3IB65k6TCqXUUlMiWUszT5sDgjI5gRDFQ4rJLo?=
 =?us-ascii?Q?M4nV+jXjpBTMGn7GkhjRx22fDRlNbNUZ6cmXZlllQSBWWSHNooEVi1tIW3M2?=
 =?us-ascii?Q?2RyMSrYOGtdlJ46pQ0l8BT1VhVAGgfxZMKRiklmpHr9ufZRV8fzUZiQcqGz8?=
 =?us-ascii?Q?EnUeO8o+Sw76gil+EyslcypLQUa8XUSFuiU2AVFFg/SzqPkbQQ0ync9MgCzR?=
 =?us-ascii?Q?tU9hPqvO6BRC9xr5W39kBHcTP1hnpiXY+CFxml8hFKMKu9ivP9DMXi8K4nZ2?=
 =?us-ascii?Q?NCkwgdAA4ATLOylTX+sQmmEn1fRQxrsGvwGOs2EeA2VJi5ONGLyAuxcXr8NB?=
 =?us-ascii?Q?TFQypKFf7ZEsIcfTeuvbB2oMg0+917c6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qshnj1hXq8qB8vywNip6UdeU0XBbSaQq7b/Blnc4dOzXmm1hhOuN8Qm7m3Bh?=
 =?us-ascii?Q?ovNOTRFy6mozVhukSaYQ8YLnanCwctg9b79ITgBxh86hW53kt8iCY/dzYhDO?=
 =?us-ascii?Q?CSQnSucskZ45VLUGfMKA3oqOWMXujS0MUXRgpNxPjgEs2X4E9MRFNSPy74He?=
 =?us-ascii?Q?ew4NZWmGsm2CT81GPPCRrUzipsS9qsBmE/592p9fQ2XZFhc211gXqEkoBzzV?=
 =?us-ascii?Q?olJKqeadHYZ55RgZfAOvMdzgc8yascatxrccuuME2O2xVYhFnaet6GiMlb3j?=
 =?us-ascii?Q?Vf9L8GEW5zeRHjUVc+dAGc2NotPTD6KPXny8Bg9hIFwK/YiA42SHMPLoRbMK?=
 =?us-ascii?Q?rVW+yVbKaXqcqUO/+UHc4nTqwhR+X2vK77NLrkTQHKi+1zGKaTCdRjRzJKcm?=
 =?us-ascii?Q?cDiXfZzvKnwQhbE2rK6mCCbrOh2eOef1PzDCc9lV6cDJT5tnxp/19CIH0Pqk?=
 =?us-ascii?Q?UF4M/C9oQeUy8+SeEkvPA2+yO0xOlHVOY+OGzJwhey6tK0KDo3QXp8VdvQEz?=
 =?us-ascii?Q?w1hq9RTVRfp9nuMlNF7ZSMaF+2sb1fFNC9FKGNhlt1Yh0SuyHpwxt2Jz5N52?=
 =?us-ascii?Q?Alkav35i+ZAMwvlQW5jOpuRYkNldWIq6yEebqrz2L+wHJSOHBYOmY2v6PGsI?=
 =?us-ascii?Q?IF8OKAph7zw19zTkTBMWINbEr2E/NVZeIQobLmlgYEY90lZhlYIC0Mx28jah?=
 =?us-ascii?Q?8PIZyrjkwCRlUtw4usa23yJOapPi6pjtTXccHOYD+h3T59QrjDrNAlFNq7yM?=
 =?us-ascii?Q?NW+rC+Dti11inEMqAMDb9hS/l76MMurgFzRDsdEUwuvkgzIsj1lesz6huk5D?=
 =?us-ascii?Q?uEn3HMjhSw4Zi9JAPWFBq2Lz78SoTTurlGPDxDghFLH75KXnWjsnUJi4gJRX?=
 =?us-ascii?Q?r5JsAiQPMpWr76DJghBW7ssr23dPNDt51SLkibhDWYQlaKhdjYrBmA+AAUz9?=
 =?us-ascii?Q?BDgsCqk6HM+mkyt6ymC2iQWh+N5Lrkw5e/u3gkI77XeK+LHfcT4aI+rZ7avW?=
 =?us-ascii?Q?WWfBhnVtwTF8Q7pLRslVJ/5f+ZqYSySlKELBOnAbDQ8+zWRdPpvd9oLDW/09?=
 =?us-ascii?Q?Eozaq5e3ALdIl+bmGBWBih9o4ZbKOrsK6L8GghGpYiWiAQj4bwrlLyoX/0E0?=
 =?us-ascii?Q?yEjJGzq0lDrnk9kzgNfbiYNMRx6KKn9u4lu+D3nFySjVCv5zx3WqnSGZ64HN?=
 =?us-ascii?Q?7MzgHG9M/y+izAEQPpLNiy2dK9o+1wHtsZynd1f9U+CYFb5UGfPemuxLV84S?=
 =?us-ascii?Q?5qIiXPU1cc7oGwf+pljyc8nySoXxFuEsPDiC+sJCypTjstZ6rDnvx/QM7Uq+?=
 =?us-ascii?Q?7+Hg7DbWOinW9aVhVZ+NiZhY5kLSL9BxX1YZvRehM11h8sJgTezcpyMEILCe?=
 =?us-ascii?Q?WkfEYmpLegzfuUbCLm+be/nUtcTgsbhz2xpEokqKxYXxM2Oqly4ikzR8wby0?=
 =?us-ascii?Q?CvBks+I896MB0rtEBAgEOGwfUfqEVrtbkLcRHJ2cZS59jbJaBByHikanmCs/?=
 =?us-ascii?Q?Qp1xtIEmJclZoEiyVsCXb0SCPiP///6gfb3vTFBmGRXPX23gMnl2Ll1yic/M?=
 =?us-ascii?Q?Dif/zx7lyjhl/1xfXR9IxfPHWyEzFQr2rWy/hxV0bNKgt9dcUgNeLIX3H3DN?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BSpAtm6vEi2W20qtUZKvmtoap5JFOdg1Uzz6r+ZND3UMHqxhbpoD3PIP++e8ZvYu+TxXvT9nOe+M/V2CWxntONFj6dBwHbd/eHJw0EmusHS97YwVAMCh5JFCrgqfwif/s4voSVOwGUvd9yZYz3wvO2mXJwMhpxLS/gaT/QyOSdi0bml2LqB4tl1p05AaMSy3tdH/GEqYzzjpp6Y2RxuMAwbxXJfIQYE/wk6OpW37a8FqtzxusEcmKJc8HVHiVH/QiuJ3mg8qM94swt9TaWnOYO0Apbkk4lfK3gMBLIJJE/4bAUsPgBkBoh/8tZ4ZLjDfD5niDA2OAEZdZRmGOGsrBNivKWmPF2BeGSGItLsxGOzy+A5snSeN2e4tnZqaBcSzfcUWuBoQisnGWNVx1FkwSXKclGyJzskP0O69eJz6k1+S92j4pdsrXQpui74E96Jr9hcByq3JD/s07mItaIrPnFjCYSh1ZyG5V3pS+7fbpdhjPRucgbqxrhD3jDOqh88W8DmUN/1Q1c1Akk7fxcrMfBobetrBZJatGzdUFkb66xsPLbWb4BdrWwyywoT9M2fF8XUsQB5WXadxwILZ/nlvMlb0l0VggKRqjvNQbYQxwZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad04741-e537-43d3-9ea8-08de22b825d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:25:43.8319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hm9jvFUG7/xLqfjlRXjNhVUrKkgb6NGhJ8xpfqV8ReVsS8a8LH6HhxUndssrzcEIZZ6UgMJLZmtIRtFfKRWvGwSepbIU6GVBC8w26picOxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=784 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130102
X-Proofpoint-GUID: udelqig_k8quchlzK6NJ9VDlpREY6mvs
X-Proofpoint-ORIG-GUID: udelqig_k8quchlzK6NJ9VDlpREY6mvs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfX2jMy3fIKXRH7
 gqLU1v7OLLzLHkj0kP6ItUOEohrwyO3GtmmOI5UcuLEoxKYTt9SrKtXIeIeAPgarY4dqGuYD4Xf
 8eZABqPVb2g6GUyZF78SOk81Bfjj4DgDtH77VeRON9rqvtJWJRePQHemOeifFFj3x4FiHPJzo6o
 hfE8saUutSItu7mEExJamc7HArSYFm+G0q2aPBFUxMigrQcQ0tr6WxXmlgYAB7sojEkZfycxq1K
 YSNPk1svLxbgy2HWXmY3+Cacx/Lj+FzG6eDU5SaMaqBcQ4qKi2CJ/HWMIU32nBE9gPNd8h+K4hF
 RQr8Czzp5dRSSCS47I1kZ5bhE5hVM+QKFaad1DlmDC5oAqsOtmDsxeg4BQ0m+MY3swvpf+EEfQW
 PqcV17yF2jro4c3B0B3WSvmVTguzEEmDfYDGHw17kFiEBDQ7dEQ=
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=6915dc5c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=8zpT7_AKYaNu37XpEyEA:9
 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12099
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0623180008
X-Stat-Signature: ggnyby5x3gan5xxhq4oertm8hdkufzt8
X-HE-Tag: 1763040354-724559
X-HE-Meta: U2FsdGVkX19xK18/dMmSPTeiMQdBPKxNUj9/JlK28uSD5p6WRhPm+umHj+HjWMbm+Kh6aSGpU1//6iKYcbERKs41hFikQc7D8NUhpxL7qEymWah3b7iKjRanhrNIVwEl23/YnYyrvhrr5CIoNZZigS/G9+85qxbWKdBet1tTMHjcDZGy7pP4zKFuRgbVwYNgftcgVTwARkOGhYkPMU05BAlo75tDc9FA2jOxbYr6Yn6a9a1rjYOgqc4L2uI9FMOmSLSOiB6qoPQh5+7sXicCfeCjqYIYK4SHK5Qv7hBLxygHCTIudPjlZybdQ+eWwdsMxAsvXFnHORAsI12bwQ/adtORRi40meC7ek7GEnQgbvvFGKnNAHizYeBn9roe91IlXgJObG3u/4Mqi5yVfqt2FTsknXbeAjrtf6bl/jgd4psvjhpJWlCH0icV/y9/I9b54SVBDmaJsgdnHe3Eml+S4ayxkeHl5SvmD24kb4OJ3DQsgOH5kxKVp/CdbNo1ngZiFSncoQY+YqYrgEpMP7T1cn3/8fkoBvMmPV0GlSf9ef9ouyLOMdXCZOCckjR6amUV+yaRMJ6q2iQaxZElo4rUXyllJdq5iMXCF+75/Lk4LJc1RBl2zepQkAevyP2SrN4t6iD68wBDWNebQPLnaD/xlMPaayVkcKxh9K2q7bNJS1F8A/Y4DQOmPGWrbn9ra231+A38w5g10jp+Fi+NfI1QN2v2o5bOZeBAI7s+q8INOHx6LHCZ0eDJ+qF31WZ8m7vgU0Ukp/FIHYubVS3xwzm6zx9Ni9moeJKjxoJzIgKmxFnr1PgVOgn8FQYKaOtMo6WMmtNbr1iJ3PWpcC2ko7NFmE0B3WHrmNKmnBDLZyUT6etOWiLQ9fvw+AmevO4xtTaxT1EcTjQQR8D3rLq+uokOoZBQDB/noQTw6+eSwK1OD1RTMDYHt9KBj8QwIaE7hSfISSzxPtVxVXZz2qvxD+K
 FAi3J+Uu
 DntErqGf641ljtFZZHQ7ct3lXyjegNfiguudGgLbIPZifqmrbDbjGyFraoZTtWzEmCSi70X1JBoA/hPVPNLLMw8CNKRbxv97JjeVDNIPT0UYM59K2bkTDpmZQLHR66MBL7I6p0YUP7LQJMEAGtgIGzyg+UYQfprQilBwt0DaPYk8DbQ8AsaJz0PqFVWQVjYhC8WNzwsmheTrNfkwiR8FeMRLcpzXK9NKgFxlagtMDs99Nd6fCPe0aG9lk6iuRlxcUydFSB+LlPvcuo2llp0uh8OB1UouFsrrikWv+i0h4V3drEXYPlV68pVboBedaJeTfgwSlIt9Bxwzii6+FGY1JRNffU34F64ACtBDGHd/fSEFlXFjiCnZwmYqkmuKvd20R0rJUf9kgwOeawDVYD3vwdu/v5eMDZn8SpTIwLndibNnUMfO9yqsCKn6B1J/D1J3OdGZq9tMldrqbhVhCJAt+zTFhbB9/e6JpS8J16B8VYs42/EonopHRAODl8109F6Zt83BY2M0m6dpkENNeMA6aWTZjEAUSkyGwTFC+/uFiWJP8wSaTOY1gYH9zPPbYWjwjaYAKXxkZROdhjbs1AJzb3LyvqQSY7iftqOxNE6jyYhAJm+sIar/jnfkpykUMrgYRuHQvaMRI2Gi3++z35u3jbdMTEUwbgEbKA4Bbc8StcudfAR6GlGcsNbhVFyiwT9nK+IwRTvkihSN6gWMllNwc32QZTD7tdeIPDyfetgScDobGFHbVsxF0shp56NxBHlNP6iDHMX87X+JQVsmQ2prJUPS+Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 08:32:02PM +0000, Matthew Wilcox (Oracle) wrote:
> Allow waiting for the VMA write lock to be interrupted by fatal signals.
> The explicit check for fatal_signal_pending() can be removed as it
> is checked during vma_start_write_killable().  Improves the latency
> of killing the task as we do not wait for the reader to finish before
> checking for signals.

Does this fix Chris's issues or is a forthcoming series required for that?
I'm guessing not, as his issue was w.r.t. reclaim right rather than at the
point of forking?

If it does we should say so I think. If not then obviously not!

>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/mmap.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5fd3b80fda1d..03773fe777b7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1750,7 +1750,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	for_each_vma(vmi, mpnt) {
>  		struct file *file;
>
> -		vma_start_write(mpnt);
> +		retval = vma_start_write_killable(mpnt);

Maybe worth explicitly adding a comment to say we handle fatal signals
here? I guess it is implied but still maybe useful?

> +		if (retval < 0)
> +			goto loop_out;
>  		if (mpnt->vm_flags & VM_DONTCOPY) {
>  			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
>  						    mpnt->vm_end, GFP_KERNEL);
> @@ -1761,14 +1763,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  			continue;
>  		}
>  		charge = 0;
> -		/*
> -		 * Don't duplicate many vmas if we've been oom-killed (for
> -		 * example)
> -		 */
> -		if (fatal_signal_pending(current)) {
> -			retval = -EINTR;
> -			goto loop_out;
> -		}
>  		if (mpnt->vm_flags & VM_ACCOUNT) {
>  			unsigned long len = vma_pages(mpnt);
>
> --
> 2.47.2
>
>

