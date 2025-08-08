Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61A8C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B25F6B007B; Fri,  8 Aug 2025 05:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762FF6B0088; Fri,  8 Aug 2025 05:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCC96B0095; Fri,  8 Aug 2025 05:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0686B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:46:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A935117D5B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:46:08 +0000 (UTC)
X-FDA: 83753109216.20.01832AD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id B1C0E40002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:46:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pgsbpAfD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=snctNh8h;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754646364; a=rsa-sha256;
	cv=pass;
	b=Fy+aH3OatHR8OFLKrK02Cmn0OJAFD6jg8qS0TWW0Gx0RJjPy0bE5QzDJaBxIKQwnv7WInt
	RQNBsKgjFjNtGuB7EYbfDMvPwLvaaqe1/inbKTMIODttaLoVUw1Wt2Uc6GOascMfjUFMDj
	zDtnNfNY1RxtKnznfmKGYz07bMHo1FI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pgsbpAfD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=snctNh8h;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754646364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtCNSp3Vr7kuxeA3IZaCaCt0Vn+Wcf524C5yBV+slL8=;
	b=ewED9+fZ79q5gnX4Ok8XNWjsh95pbAbKHlUPQlYPXPEbrAtx4cfxe3D5TdmEyM8bKwAb/X
	c1/Y8Eiu0B6bserYPMR+gp3Q5DwWALQ6IIfw9IatWGzLv3mOwWfq5bmOgPHNA6cD7gA1P3
	cYXavCkSE0AAC1v9hU9bKFBaVe0Gxac=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5786Yd4Q027975;
	Fri, 8 Aug 2025 09:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VtCNSp3Vr7kuxeA3IZ
	aCaCt0Vn+Wcf524C5yBV+slL8=; b=pgsbpAfDwaSjdZtDSJosv3OkjU0VduHTK1
	pfRzCudpcOa83WtcC8fz6d/ntEc/8/7pxwfjB4dHernc31rrOnvC0Ik6d3Mhy9ZK
	9TomQjNBM6rBKvVmahnf3zgR6imCWAh02my5qBerH/08MvIkQoZoLs3Axht/PzwG
	GGyGz9hrYg3jbmJg2m2ApHsVKhKP7REaL8gMICvhYJNoEZS2cOZkfEC2EaWkJPAP
	A73lDwuWly0EIoLltKxGzv1xZyDCzVAiI3mRDVMQ//Vi7C7bRUrzpHSUuG6xOHgS
	XOe/HJBlbH/falm5V+xW6MMCRWAAAMW7z8/rk64DIFP2kUA4ZO5w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd60f8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 09:45:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57891grl027119;
	Fri, 8 Aug 2025 09:45:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwqh7c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 09:45:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hUGsQ4w80aDNOBatYL6/JmKP88Z0qkAcBat9rZRslXnwITFPsS/ENu2iRGVLtA5sIW4LteAY9bdMH2FUO/+x709snYa0JP7TFNHUjWDbOnoCMzG7TXrJf5nCRRA1wv/lcmN+nOWM0mpnUzfdPm20t1GNrfSbTyozOg9Ei4b/fTKkoAcK2pP4q74AZMLnpC+UhDg/oMgy4AW8xrwB5xqyMC6yKnRmZL6VqAfaB8Yd5uytYGYUCJwDfoEjPFyXStF0QpIORYtDwCTcFJ6NYyLKeFQjoj4IroS/CjG/Bwzts8gcjuafiHQEzdFqNcTau5KiTK0By0mgXfKUhQmz1FCcnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtCNSp3Vr7kuxeA3IZaCaCt0Vn+Wcf524C5yBV+slL8=;
 b=KRZCz9iHqqlfIb8t+Hf+OeXAhIjv+fpsxnL5iva8ufQjrdZE9BFdnKUnfN6Pp13HexM/9uDZ9xVS0Kcn3Hp1IwMfXYxrghym65A3q/WywNIYvqq+iTMCjclrvRFwExOr0dklsGC2TPHWag9trOmqFZ1bzlCDhYPo4ppB6l0rS3QB9C3eZcz3h/dP2+GBTw/tY3047oknH4UeQ0nquRi9iuVEKs07z1f0k0p5RIIBai6TP0aDmFAyF9T7MlcepbL/S0eJeluM6GxMyS/ZIB5iFYf/FUsL17PV1YAOlRHwBpkGetmSVN5JzEsYdy0OiboZfo8OsbgAT9sR71/V98P9SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtCNSp3Vr7kuxeA3IZaCaCt0Vn+Wcf524C5yBV+slL8=;
 b=snctNh8hGpGNUE8ToPodq4gA5KjX0WZ8tz6eUdG/bJMnHGW4dX6NkvKMGQSq5y2iVRaaD+WXxlz4jPmtEXkbhTEzrxxGLflifMb6dcHPy9FvJdWlfpIXO6sc+DyHuqbRJ7Y2Dx5aIY8Zt9LanP+MqIhYI80kv1jsab1Or4/m4gI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7086.namprd10.prod.outlook.com (2603:10b6:510:269::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Fri, 8 Aug
 2025 09:45:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 09:45:42 +0000
Date: Fri, 8 Aug 2025 10:45:39 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
        Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <ad650cef-1a3c-4ea3-8204-6c2f9546c7ef@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
 <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
 <303b1764-6471-421f-b4c3-6a2585cee2ae@arm.com>
 <b0d257a4-a37d-41da-92f9-4d1c0a11c30c@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0d257a4-a37d-41da-92f9-4d1c0a11c30c@redhat.com>
X-ClientProxiedBy: MM0P280CA0014.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b619d0-c2b1-4e6d-9e0a-08ddd6605740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TmMcoul7MV2F7clrh9A12WcydsvWBnrZ7gDaIpYKECQtQqkxOZQHQF/zs/3y?=
 =?us-ascii?Q?ct2EKTjDxPWiBioD6oBNlmFy2Qi3FtK9dhFyjOeKKCITX5n+a2x1JJECfZvP?=
 =?us-ascii?Q?JBE76nyR4agYMJ/TRcxkV6zzVfKW3wReiJUAKzeOWgKghBaYtUFSX4yXr9Gy?=
 =?us-ascii?Q?WfAJ+2dbkQ4s3swlaR2LSr3681huqE24oueCPRtD9/zEqQHlul1VCO5ATsBx?=
 =?us-ascii?Q?6BCx7siL5+gT/oEFduJbHkVssgKsKQIUOktV9WitskpNGuwTJacQfnOh6RfD?=
 =?us-ascii?Q?964ecXn5DJdi5XNCjP9GMAqDG1RUhFEUCrsKEpcVlM+Xue8bcUuMVt6A4kYf?=
 =?us-ascii?Q?RXHQcGfIyeQowVcQtMVELf4BFBRPR66AW5redvzGQxQF9oP/mXOH9KOOl5EL?=
 =?us-ascii?Q?BiJJqFFtnqAOpoOW8gA0T8XyJTs1vQ5tbiEU5tRwgcn7i2DiB7DCe4DEjn5b?=
 =?us-ascii?Q?jcCt7AU1SaVFWvAfqB3gb4KfSJ3uJYGyaGS/9tVbgTosNt3SSmcWbN7y1zsH?=
 =?us-ascii?Q?fRbh5DN0mw3rkpEpsfn46IWi1NzUKC7DbEypUrz+Jnb0+TSTYMNpXdBu/hdg?=
 =?us-ascii?Q?jncpMqwTegJSuFUzllWrzB3c9yUSYVIm3RkSpcFarALwAIENwj2MSf6Rx2gM?=
 =?us-ascii?Q?whHXHsz3UDc3oeJfZoqSBII4s/AjMM4yNfsEl41Cafdjb57k/jj1bH7waOTe?=
 =?us-ascii?Q?9z9UqDp9knC3rzMiF1VvVjqAoBmr98jSwA2IYzHtGqNHVCCSiy3CJdO1vvtP?=
 =?us-ascii?Q?pFfQoEYVuCYmNwW/AuZRjUeGwtxgweR/A6rJO2ev2KkPJEAuSPbe1a5TFuLg?=
 =?us-ascii?Q?jE0ETByC+DrNBQcxnZ4qVFxukNyrWvXOLyTmBmn8JjR6p9ZuDi2QRmcyFmKJ?=
 =?us-ascii?Q?inCXe5G7bqAJpXJIUSZmydXeGLC1uCokO9SLl46qek3S3XLEDsKYrZ7A1hbx?=
 =?us-ascii?Q?aVKsQW2YGveh28KBTnVRIeoBHVvVH3kbVQema09xF32xU7M9IAf8CW1+Vlnq?=
 =?us-ascii?Q?ofyC63IrULe5Egw8V9tfw4IExe/rnfegld+KXR76c7peGYZ60BZkjYEF7QJT?=
 =?us-ascii?Q?G3jLOjy3AEjrJIiPUoL8xuSBdFmaAQnddIAWjxV+CfYdkWzs+p/yGct3ERhF?=
 =?us-ascii?Q?lg7ORNx+PMolXF1wSAOWrPpBbiL3trWJwYGg2c5c/yYGDJgG6fnsQICWsKA3?=
 =?us-ascii?Q?FQiV2d11L2JsGE1whaOHYKeUAgLGdeA5fCxV0+5IhHV76CYfhqU8PjhOT4Pe?=
 =?us-ascii?Q?yL03sIETzLlujW5GK2pPwiiqvI6Z5M0+tfYPLO9nNEZy3nWdM3FoxFVn5WOM?=
 =?us-ascii?Q?Pg1HKiPBQuWsjbWmvHe9M4uDOCaazGZJydPDXSkmssQbnrw6KQCDRgOBiGsG?=
 =?us-ascii?Q?D/z5BNAnxZaBGG5FBmnN213oDgmzxnId7hAPjx6v0eylT63ZY3Kmjab3nobj?=
 =?us-ascii?Q?QyVRCiZMDUU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/G0sqQom0tvXp/HoVgR6ySXgQgGP8cn8Rcqhfnuwd3WDi2qPQMdeiHvJ+fy+?=
 =?us-ascii?Q?e7YcNsI+iBl+xHlIm3dKFMtdGlsURTCY7ZvBd66x7NpbQDQpYcip/xgZ9MC4?=
 =?us-ascii?Q?ppULj4DBjyQ/G79cMV4qXM2lj7Fghjfogh4qRfgR+g3NMBmGBZf2gSKYy3Jg?=
 =?us-ascii?Q?xwA3/6DB/SxawxyYFLnxG87i7xm+2Qp2FL0d/zVzdLBm1g234M41Ih44RpYB?=
 =?us-ascii?Q?SuVMoI3ZGfzuDaKOesIl8IYGFEREm2CzmyTlfp+WQBxu7RRGMn6xuddJah6k?=
 =?us-ascii?Q?4tOXAUdihJ7ynnuqxGjufqmuLqI5puw2PMGIV3jVWVDLzPPSBkmyAPf+Cg2g?=
 =?us-ascii?Q?pAwSLw2sRyqDs8WtuufFL9pAxCOFqhfy2bA0Itw1IAqXeZ/xiM0uxcYKu3eH?=
 =?us-ascii?Q?rE56+Ji4J/leYh4DMh82eOI1jJKybLnZzOMi/NZWUnv0hANUdg+ojRxRZm2i?=
 =?us-ascii?Q?q8+GaONSq07QzLu7IgDe0T7PwX+DXhFG5uafGluY6Ri2nTViUT2PdH2+z7wX?=
 =?us-ascii?Q?JWdLJpg+My+EXLjMnk4fhsMrNAbI8I+4yuI17IjvKl9EGNJR133FjcObMNZl?=
 =?us-ascii?Q?Q1d4b+7D6pKIPZzLhJGCklg4rC83sWEgojvLFgBbTgWZO4sSidUkJWPUZVNo?=
 =?us-ascii?Q?1mhIv/CY2OHhYvJRjVz4fPKfMJJk/iB6Thu4XGdgHbSlXwtle9Iqs9ZS0cPY?=
 =?us-ascii?Q?9q2Yv6zjADIBVLSosx3ep08tXxa74UudRwM763y3w0NvNm/8gZhhbda8bJZX?=
 =?us-ascii?Q?VTUQQmDwA/bzw3d7IIu6J1rCLxQBux6VSbVzPZHduRc9Bhr5ZJHcuftkk0NK?=
 =?us-ascii?Q?2HuuyhXn/eQpHo5+Z73RiKxwyUkwq3Cy4i9wnsI1px2RFn60jeebWEJw6kiG?=
 =?us-ascii?Q?+QmuKntFQU1A5dSpc3apC1P/mX4YMvPtoPe2xJtDbw24trRl8k+E//Sph/Q4?=
 =?us-ascii?Q?gNanMmgcjISYN7Fo8mBbT1+MAdUN8ajwD0a84dprsOieWCq/IBQnjj3Cr59y?=
 =?us-ascii?Q?mH2GVwHkjnNwrkOjIubn2mVHzU1huXDpysAQTR8Phy1V/u9CdqyPrwY0bJIc?=
 =?us-ascii?Q?hA3fXeRYUlsrj3vrLml1y+/8VhKCnq40m6HEfYq602bqXRv4QK2asOXd7Iyi?=
 =?us-ascii?Q?j1GrH5GoHcp2WUYwLQMnJ6B1jsqm5sPDQiOIPZT2Ild9Aidu2Y1r4nAG2b69?=
 =?us-ascii?Q?v8+vsUqxbEMpi9Wo6EXTXSf/kOtOmHZxBWVMr7u76OX6vdV8GIEIMvPx4TsT?=
 =?us-ascii?Q?hzeERRnyZdpGHI4Nv34cH+FVkyILduQXzM9cWdncuHYuDxc+qUmdjKbMA7a3?=
 =?us-ascii?Q?xLapxs9mLWFA+r2JLEKWGpX4kcnkAohaoy6CtHFkr8HIy3QBiPwesROoxUDc?=
 =?us-ascii?Q?iDTRWyTCjpDG0+06NgAIojoJkCt3FAf0H8qfNZVdsC6esKuUr2TrjhHY400t?=
 =?us-ascii?Q?cJXh9l83SFrYWN3LzlrrA3CItM9M6f2JALlfMIYsoFtUXKZlGHbaBOPsxPiu?=
 =?us-ascii?Q?Nhi6yuL9wlRQD/oPbTWz1jb/nmjZwnVkvNy1Ig5FFcwbgVCiGOaGbG+0qsbK?=
 =?us-ascii?Q?myZG/pU5P5XFzndZOD1hbEjRBWKeJITxXsvWuxaZ8gibgb1/q7aPdKtGHIhu?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4tJAyFlTTdzKg0vzZXzqPKQ1WAkvb2rVj0zoEf7wz+CoD9384zYc1OKp4aQ9E+1aNaV/+AMj9Umse6vPTdvz+QWULs1QI9US1xMkCKE+sSX1xkEgU4WSWWxNh/bssTGubZ3C2tvNr3c4CNnhbnykwi2VUrTpzDyfUSrlUlAL8M1EDZyDeFIxtrFnE4CH7iFuGmq0XHTiK0nsB3Tli71npSuu8I4/W7nQ/IkOMJhBbC7E1WXKIwenpzSxpodi13bWfKiP+mHNyT0Zwy2UARFFfi//DqCz/Qg1Zzvwl5dIxLgoQBqce19nfDHXNcDUqMQh9zNdnazTlhB9uSRUUEBPSc72fO++wl3HZe58ZZzs3hN5v1t/v5kCSKrd0FsfjJVdPCmpwJRYj0EYTPEuWG/wEwIscM3UidsKxK78Z6yQREKREceYeqgc8nh4T9Vw507xzpjNwimDZLFcxPCV6kWF8AGKohNBjNIwzq9qan+DZ84AZp2OsO9UBVty9LfMLiZSrWH2wSCedr6ixHHN3GHcNIIECnjE6fCvbHbiz9O3Jn8icB1JFsghli+WSnj3IpMY62ytmyi6o9NUEj3WqwlZ8LvUb7LlKCJCiUBSbrHknuc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b619d0-c2b1-4e6d-9e0a-08ddd6605740
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 09:45:42.6070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzl3Mk0eZy+aIdR6RrN3gdpYKVDbjpKDzIDqyo7qdWRcecJnlY0047yte+v8crmqYFyXTUOrwMDq7Z6mWhxdM4nv+LILYDTKbg2pUF6I8dU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_02,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=809 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508080079
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=6895c755 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=ErywnbMd53imLDUG0G4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Tu_7MMTrAasJoPrkZLMaztIeq7plQcO9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDA4MCBTYWx0ZWRfXw3rlQ9yeaZMo
 7RUS2eudswQXULpROGXCF5ejj098zKhzgmlIpH5AKTko8J7rI6jJ3c1p0tK2ZO2WOB18VqxnRrB
 44SG6VbvvKPtyAQXTqRegPbAujUNu7Pz7X+sENpccetL9qPop9J+T2I2QGyccK2ltV/vVmQGWcy
 dgFA85EYfoidNNTCm0eFYNkSVZKma60nZm53vzWwwoKwJdLUZ1/yBOz51e4hAaRY+8LDb78QmdE
 4fcl5dxKMoAHskqxUtya4Vb44KFcjSX1Asw5vS3Xm1gx4m13LC46yb7FfOBupMCq/iiIpi2ym8C
 MM3g6rOwtlQz69jmpa1YqttukbWj4itJHsosJ8WF9mEdu/ely4MrD60a94JA4fao8oLU5OBf8iC
 Y8sRCPMnER2Vpn9JoeZpLuakLzQoTx5+cwFqr/klcWa78XQ/y6RIMAAEwARlYPESnygP6rM/
X-Proofpoint-GUID: Tu_7MMTrAasJoPrkZLMaztIeq7plQcO9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1C0E40002
X-Stat-Signature: eyet9dngsbq8jxdst6gyxe9mp4bua49c
X-HE-Tag: 1754646364-408197
X-HE-Meta: U2FsdGVkX19sgF09rVHMx4SdYYCn48FJTqWdZjMhzowQfh2cDv5so67bzwCuqcUYxK1FslHaOBrrcYXloKn3mBfRJVIfQMbHDKnpUoOqz6TN2jH8rtWaZO5bzbuJLM1wMyg0y+rBYo3IqUIJwUzZ6IYO0cxUaGxe3LDpp4c/zSUlH4Q4nMNzvm90WL3fLUInk4CGDuyGeA8Rha7ZK/n16zuoZjRCTnnk6vn6sGiNHJKXZMVzon5iEI4KD882UE5/WpV3VSOZXryittZY18tyEBAfsQhWWjHxjBqkcf3ezufS6F+S+F18sSiOXjh+hb0dgpaFwmQXbVWW5FjOh1MADQ+movhC04c2Kx//GZd92XOQruU1awxwz/dJiwqzTKCm9dvxg8mw5ORadWq+ijOITrpN2QIOrdv66s6eOYC8K6VZJIe3Vdssukl9Cxgn5e+BZfbgA1uic4p48tmQVYT2CF+SyYv1off2VEo3ZjH9weuoHio9Q2YCVnRx2e93D/SVF1TrrutegZG6Hdi/5NuLKAtwJ2+Qpb6tjC4asbiCY91LGX1PcgbhZiKaQeWbhL1aHnfJ4uUwchZNRqmlMq3tPVFo5ADrXVMxgsJ2zWVfDqM/S63twRomMbYLXEaisVkUNpBnaIJBve4TVxGbx9PdZYpHDUrmn62e6fvbnfjvTWfykno3LDtiOqoby7V8VFJJEzdhcUq+GfdVl92X0iJWYNZ8aS3BkB29d/d1Y4smC0zIyDXSywiB6CefKNIQGvLGhJwQsGgWIlqHaDatXFEwrcglOxVTCNfGZR8OSC/beuo6JgKJ8PKwOVn5CBII5NFrAQF4k1m5qYGEjlfigta/BwCTmgL77heg83+P4/pa4jVtcOYig83LJ0QsZUjb7IKZXk1agHU+/nhHbH1yFGmpT8O9d5SHkKxbrPcCQN5QBUUcWNsL6tvGuAmxxCiEPZsXSevp+/xQtlLnimWDRMK
 jLGVlGp3
 dTjPVTtXUEqhK27HOf5lXhOjX5FH5IMNZbCOtoiFH8qVLw3IFwUaEGHuhOkE3rEiFW57aCqnA5tsKxf9ujry+VMr+YDSzNoMVF2S4IRhp1tYvl1HjAfi9Z7EWK+5MCVH8mDKIMMJabzdM4WxqOKz9QWnqsjnzdg9aAeG9QgDtQts1hinxHxLSfpXfdsFVJlpscH41FbRHkzp43MwyTvYIRoi7kWecushPsgWV2hGhYr16bTwlBiD+kgWJUdCKUz3KJ79N2Vt7Ah8usHf5nnQvhdLgbmEl0mhs/d6FKzXFuQ2zeG1Dq/N6nlbXd0fjmJ4aOlJhnchamQm9mg16OH0LsIBVIigOPaq2vIsKCnTTZ4xpltPHGL5GnOud4OSiJOzxyRe9lrYoVmtBapFstDAZK5BhrkoC2FSZ/ZfxFhvHrMIKjMUc3FYZ2jZLeGjqE1xYfaH5L3J2VFuJ7gJTWBDCt8nNJVCVOL/sht4UvPvvbwCEDhOb0p/bGTYUjDMlGwza7llkyWru1vvsSFCUJMwbItrKB6s7XpegI7FQIgrZsKFjBAp3S+9zx3VTtS+zESzc2zv2JdY4AYRYmz4xoxLiyw2AmyGdsjeUtLZDWln3vzdfcvvAHnsVeizUNj4DaiFpDlvLmt1cVYs+WYAyQEBP6J8kfbJsarF5IB+EiWyRj0T9/Og=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 09:45:39AM +0200, David Hildenbrand wrote:
> I am probably to blame here, because I think I rejected early to have
> arm64-only optimization, assuming other arch could benefit here as well with
> batching. But as it seems, batching in mremap() code really only serves the
> cont-pte managing code, and the folio_pte_batch() is really entirely
> unnecessary.
>
> In case of mprotect(), I think really only (a) NUMA and (b) anon-folio
> write-upgrade required the folio. So it's a bit more tricky than mremap()
> here where ... the folio is entirely irrelevant.
>
> One could detect the "anon write-upgrade possible" case early as well, and
> only lookup the folio in that case, otherwise use the straight pte hint.
>
> So I think there is some room for further improvement.

These are all great ideas and given we handle A/D correctly in mremap case due
to get_and_clear_ptes() + additionally Ryan has hinted that it shouldn't be a
big deal to lose the 'what if there are other batches/physically contiguous
entries' logic, then your suggestion for simplification, that is - litearlly
having mremap-folio_pte_batch() figure out the result from the pte batch hint -
is probably the best way.

We could RFC it and Dev could go check arm64 perf perhaps?

Cheers, Lorenzo

