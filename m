Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4237C98327
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 20:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7096B0095; Mon,  5 Jan 2026 15:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27886B0098; Mon,  5 Jan 2026 15:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3696B0095; Mon,  5 Jan 2026 15:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 771446B0095
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:12:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39DA78ACF1
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:25 +0000 (UTC)
X-FDA: 84299007450.04.7CF8A71
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7244180003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="hwIl/T0r";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zhLPd2Ca;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767643941; a=rsa-sha256;
	cv=pass;
	b=nIZsvgJnt5GzixnKVCK72auONBC1PWyqXNjeDlO1wFDyM47ZNiqQddCUR7XRgVY2PIxbPH
	g0+Yc8DPaMnDLcHWyR5VXTaKvY13Q2GVexwnUyrFQlBDD180VCOy2wRfjhFSd4wMvqNf41
	VhOwI32L5b3QHb0DU5LypYQquXvH5is=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="hwIl/T0r";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zhLPd2Ca;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767643941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2f7b/ZureIQ9M2/dKm0jsTyp6hhSkf9f78eZ9OnjW68=;
	b=t91IEgOYMGidMto6gkuSA6GpZITCUFKtCBIat+E70czdOpRufrWRIqorxDp3cDmYCO7jih
	gk9F6ya4hL9pg95ZE3Wpq8LZURysWAm0Mo3c5PkcQwH1ScQvfm7hYbCPYoJhbHl5I/frdK
	ZIk+y2L2CXA5I3biHv+Hd9kEOmTvE18=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605JpsGV1920803;
	Mon, 5 Jan 2026 20:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2f7b/ZureIQ9M2/dKm0jsTyp6hhSkf9f78eZ9OnjW68=; b=
	hwIl/T0rNRSlDTYpe9fYWHD9bHqHW7OM7RP2pHhfSPSoM2jc3qKcOx0/ab5Jl6xl
	ZLKAVjYB+Rtdxh557ueFUs3tqur0nytJO0Y/HjxldaRrr1iczW1eC8ywQ/+O+DhC
	A83SesOre7feqZJc1Aaebk19PNyuoBKee5POsuX9G+VVNWNvKt0QfIqYhpK10RiB
	LhrO5o0JCqXClBhno1v5YH0ndoY6i/pcQV1E0/fc2g1F8cweASdHvg6WJcKTQQbm
	/WZPJtbT41gT/lGmu77B8waCXR1wE9xZB9JpyAYK47s95Kbz06YzRedg2c+ahcJy
	3Sz2camD5JyENgXWQcjvGg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgktm80wy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605JR9Je033967;
	Mon, 5 Jan 2026 20:12:13 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010038.outbound.protection.outlook.com [40.93.198.38])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj7sj45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQ1ludz2SI2gNd9uFhZYNVf+YtUandKSivFCmwRnclswQ2HN0A8SGBcIPVUQAytY3Oiw3sJ0oXdbRwfxLdMTFPMAijAdn7b1YgUVuXrUqm0lX9Kqr6FEceN9ecsINE570wQgD0XDeQt6Nyu7JsmWGCV4VqCdJ7sPpLRGCk3CNffrtVmQc/rhQ2FU6LpyHxreaAVmVrGifZFmu9QDZdxyEmxyrqCDq8YqKqSna8g4IGmKUempfqRkEwP2H6ogWTeMyFUp1YSP3s/m8f68+4CQ53BAwLgDTolsgABcYYDRFUgzrIPkrSASUoanjVDThgP6zGfJswhK8+JfZU95Qj6/CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2f7b/ZureIQ9M2/dKm0jsTyp6hhSkf9f78eZ9OnjW68=;
 b=szxqy827sae+gQmdOnaQ8o7JZYtryOGUWp5ADwwiDquCHbG7lXuNRkYIB94zWATgcmB2qBfX6Ug7/aNd5yYrCxzSVbJOF4D3Pne6YXd8yiOk5pYVp0DJGUESIAXHnUwyxjHNcHXXWeA7RzBjLxMxRGku2SeAUZLKwDHyd5+2q7y3WbpuJnVp5H+xmckfsu1GgzPPIxk8MT4mIsfpZLFblzJkrgGbrStiDQ5NNpyZxJQCh33yfOeckGfYeRzyhFdtiTmto0bGJy50C9RNg3Dki6bJ/vsWFBibZGb/pXaVZvBBsvzVuBLQgvN2m75pCSFHWx/2rLEo+yASPXro9+h6zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f7b/ZureIQ9M2/dKm0jsTyp6hhSkf9f78eZ9OnjW68=;
 b=zhLPd2CaPpxtuh2KOKNnb47xKizrMT2MYpy3mtXHcOg76worBSSskoSYJz2Yvv4r8uoXWiDivUTWmofJkoOSIMXzzM2SFdbB87FSFM/cJ4qYrx7xPj54bJZu23lQXZZRjdLkzeZX3NN1QQOPFVZdSyG22o1+I/IYzShSqTmeXTw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7077.namprd10.prod.outlook.com (2603:10b6:510:286::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:12:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:12:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH v2 2/4] tools/testing/selftests: add tests for !tgt, src mremap() merges
Date: Mon,  5 Jan 2026 20:11:48 +0000
Message-ID: <f903af2930c7c2c6e0948c886b58d0f42d8e8ba3.1767638272.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0127.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7077:EE_
X-MS-Office365-Filtering-Correlation-Id: da836536-e06e-4f53-f293-08de4c96b3f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pcss+vCLQqaMSESRx9fzNiml0zfdHOdI5n5u+bWuJgcNovDDDPWs0KP7ZsAH?=
 =?us-ascii?Q?Wp8E/R2sRUUK03IcxmyaHnwubVBR8XdxzNXeo9oGKU0FVeJeWfYwoDJvO/9L?=
 =?us-ascii?Q?7bm5H0P8ut4OBkM8StYxGRztFvqzvf4nzDLxHNc+A8U8gnLogPCwLWr0tCB+?=
 =?us-ascii?Q?CRv3u/SmkJv4bM58zYNOPU6dyt6prR0X1V+9eKEk4auYwgsEjcSIj1f035HO?=
 =?us-ascii?Q?uNvLUvftxkYS5u/t1W6wYGJkjxi/wl9ztXo5UiBBVu8PkaN572Q0gUKwEdNJ?=
 =?us-ascii?Q?BDOVW1POTcJohSV3dpAwvwJ+SoXVYRfCXD002iM0tLKpb9vml9c1/8k+sFG3?=
 =?us-ascii?Q?1HpPMG4gtmRHcOoTIQERj6XCOuT1rlAmKi0h+KNGhimSMmY+Kru9GGXcHGp+?=
 =?us-ascii?Q?hWf3Q74a677j1gMlP9Vc4bMHP+DJc3I3yOFNZcVpD4WaibLnNogkLglqfLsa?=
 =?us-ascii?Q?FOtzBPqD7DfpP1CEvHD7yCwv4txfz5DzZKiMDN5fsVTHGSGOubwl0cXFwiTu?=
 =?us-ascii?Q?6NTCdCcijSg+d7QIlWK6zMvdzOVDBIWFvHbBG1EkqlH5+lBymZq6iFIRmOct?=
 =?us-ascii?Q?BAQ1b99C+DebZO+FpYIi7M+JWCikh1BOz3bLordbVeX2C8R+XoYPNsFZEGYF?=
 =?us-ascii?Q?dIuR2+TNzFU2g8gg9UR9PUeVD1yK87ytxodTSnmyMfY3aFMfQ1kLTM9VtlSZ?=
 =?us-ascii?Q?B6QvXE/ZBN7afAaB1L/6mev5ALFEEdjfmgpi+hFDWDRsjmj4Igrgnlg0SLj4?=
 =?us-ascii?Q?vOjEbj3+lzxGBixAWFe+YDFsQazIxaLW07sKOw4Yyu68yMwOiHc+DE2pyC/z?=
 =?us-ascii?Q?WX5HBIq+9kB6+VIe67Hzb/xKut/ItwAP8YbAa0IAL1qEMvfvwdamP2eqPEcn?=
 =?us-ascii?Q?8XTUkkZRJ1RZMY8LQLWHOGjx0QIQ4k9rtQbsp1vNYr6vASB5DLFLdLfiZ/jZ?=
 =?us-ascii?Q?kESVMu8R3UEraisobhbWTqGHGmkYRAUan3QjpfALufQnEnuKwFEIjWnYXymO?=
 =?us-ascii?Q?SvRRdoM0b7j3rZ/OjshdIoOv32XrURMU3gZWSjCtK6HeKzprNKkHx1JS7qa3?=
 =?us-ascii?Q?llRKpaGr8hAb9xIKiIMS3j6dVCga8zrSJl9Kl24NKcuSy5TRvq6g/Bsc2uQ1?=
 =?us-ascii?Q?MFNd+E5Nx6oUW4VFUrQwJcabiaAyWuaCOWiHdFdc93Y4DL91dang1sdxkmSO?=
 =?us-ascii?Q?44svWHoGmvluSYatkIzb9AdC4KowExJS8XVU0EmS/x/OX9uNiArrqFOhDkuA?=
 =?us-ascii?Q?6VdBjty0vi+1ZMxh2wIEElpeC7Rz4G5OvN2pLKOlOF0RZc59+BFQ36tQjhq/?=
 =?us-ascii?Q?LLBQW1noGSLlie2GcRxB3Illw/pd5uKMlBCaUOuJrJj+rV0qL2Lgf2bpgbQa?=
 =?us-ascii?Q?fOI3DN0b3juCGw46lBWoJsXmCVaDpnX4GMlcMuY4D+yQxvPBy+venYRA2wwJ?=
 =?us-ascii?Q?bWxbehWNU2NSzuQ+PY0kKXVnvd0ul3Fy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h5dJiNcZ2rzZSuwVoj9dEECN+z/Zch+8L0isjnYWdeFk/HCnY7keGnhDcx10?=
 =?us-ascii?Q?pp3Jag/dwPc4EFz2ThbD4jfNzW6wa0GF1y1DLERKuOG0R2o6fTbKGfXURMOh?=
 =?us-ascii?Q?/F2RcoDCcwXYf+0WuCvL6/sCRTEf+VeaO8xxULcalDV1ncafF7N2QqJml9mb?=
 =?us-ascii?Q?BAnJMfPjYPN1PJSZfJjV9wWQSosuK+WDDK8HxEZWbWDKjXUIdUQdXAHajI91?=
 =?us-ascii?Q?/ZCsRODN9FE4ID+VEAo1dqLIpZHI83Zns+ag0tLnvt7Zqbag06TwZtM6tV89?=
 =?us-ascii?Q?2rS20oTizVX5WlCwhz0u2OiRgWVQ35eY+PPnQf3hXoJtH67g4oPfKtjX9SYK?=
 =?us-ascii?Q?omTPU4wpZ4/1xEddrvVXi9kSXLfeVRXUjRBhdfefdQ+e5echjGM7MlWloRMa?=
 =?us-ascii?Q?7cs6yEwTij5n/Nvp+T44bn91Hpmu4Yk1vYRDd0AkBi/JLlomXAJng1sKWcAo?=
 =?us-ascii?Q?9AnxlDjWywlQtxCSdHhkO8Jw6kZ5rjJr0kycjhwxuXNwfM+UeuYyOjYovwSH?=
 =?us-ascii?Q?xqMvan6WVp7zvogZeRXOIwyPmxkkEveszuOp0JfQxtNNozkuXk+Nj7xPtqOm?=
 =?us-ascii?Q?Pu7ONV1KdDqtSOVBtGrSKAv0TUFZtY3vkwxn833Ef5IiDErUdDHrTuLTlFJG?=
 =?us-ascii?Q?rJZsbsbsrf5edif0Qc0oXeZJx38L4aHcfIxrAecrTH1awzhHClwLDpnTC/bt?=
 =?us-ascii?Q?IYyxq8AvdqVW7yGXdmm4yK0nZxBWlJRSPXi3CcCf3wtFf5HvgBym9xKrHxrx?=
 =?us-ascii?Q?R9o7lwZKetTVEfYI0sOAybpGVen2saWcxmobqTN8BxQ2Vc//nCDlENmNcuDW?=
 =?us-ascii?Q?0QnlTTt2VopmskMXggaOhaHIt6cFmJSEZrqk2rtJOdfpR1Vs/QetyzMZUscy?=
 =?us-ascii?Q?JYYLcEH/Kk9djBvpPS4xbZl9c4ANTpjGGP3csF/l7b6kH+Qv2tmill4Bz6nJ?=
 =?us-ascii?Q?M22q6rlsYKHXTDYdFglDZA8QqgiZQN+1DYmvfX555CbQN1RWsyvHRC5amXyj?=
 =?us-ascii?Q?qplvENodOueNbmkug6jVDT8AQW/ycoyPF4dvTKRxSvUN0BDCChfz6NqoZIkH?=
 =?us-ascii?Q?NzfYxrL/zERb5m2fJO4DD1gnhw/57snWIc2KyLAAZ65/9y7GhAywXoL/Xz11?=
 =?us-ascii?Q?fiyTKMSl6DRss7f+2mj6HGla8UaIs4ooWT1WcTdszw+04RCUyzkuOOIkgb2q?=
 =?us-ascii?Q?mkPBWO0aJrG6Rhr7KF4lSL/PSNCff7mYFaGwk2R9LnGptsBHttM6UlQbUHo8?=
 =?us-ascii?Q?DHzQSLTucm1in3wmbufROQvUiqusc/ySZcpXalvq6gdtRbMD9CfTn35kDdWT?=
 =?us-ascii?Q?LKffJ38lYPaTZkm18MwqMYL/EBaRs+9NQFeGhzJCn9gLbsi7a9lV8Z/CJ5+T?=
 =?us-ascii?Q?/gSOOzixzIYuK0loPaMBvO9pY19PiTXpB0n01WRYkCJvGZcgamNJpCqEchYE?=
 =?us-ascii?Q?vOZP05JJYIzcKQIN1wfTzUGwQ5WMBBO3/uFcLr5gEdRPIDCi/4BADlgeTfd8?=
 =?us-ascii?Q?ld6EKBPZvChHPOlN6dA2AKt/MmJeH5ImTT1tiWJiHKbNfT+5nXa1YgtQ53o6?=
 =?us-ascii?Q?v0igz+NClahAfXgIVikwTgSv5JCeowT8DgJX5Q1NwKn68rgd/iy88En2WwG8?=
 =?us-ascii?Q?s3nE7GZP4Qi+MmQ6ahG8kuJRXn+rT3JXvObqBKGNiioa9XkaSBQjkCwz0Q1p?=
 =?us-ascii?Q?b+EXCzDuf3XrBd1zc8/LB2r7f8n47ieZCcQCN8ZbqFvPwREv/fXmGd9dH490?=
 =?us-ascii?Q?sgC+RCgZ8FeUSAsVk+e9OLn/KRgbag0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	af4cxozLSG7zaSRTfMp5UbGmAsZ+caQP39YsIa5uBshDuGD4qGmS3JPSlsnFYZ88Q/dW2iM6+o6gT9vPF3BmaOi1VHm4Cx/1rUHDR+IDbNeXeUkeXabx8Fpp4nGBUwItNnywI1uMO0giUyM+MoJXHlxjO4/TOmryLUiiKcvUrGfRhbUU0AVO4jze89XsUH/DPVjGvw7O8YKq5QcSy4mGChcnnanNg6+B78gHkKvojt7vlVifg7Po38cX+3DqrJ2nym5jQDSsyD1EnQDM7nI7frvHUrdqU2vXj7o6mUsok1yckZJPro+3VmbA/gWtjlrW47zBtG7gq/MrdBDXL6Yy2mqAdkIsk4P9jfdwoK27YXdqIi6on52FvnVwjlTkxOtV3i3iujxGzt6Lh+GAIqKSKtTLbsGO/9CCBXuwgixduriQ4rqVySr9uuu4em345z83iORYcT66Upm2W88BN+AHO0jQrd4A3kcfsF6oPVRBxupSJj1cKcr7s/C18MPp/vtTBXqF1smhlLMqKPGIdKlRnGQRNpfge2T0zHGPS8DRCTzrFDH/HcFdrKQrZ7IHJwpyElhoYHNJnfvj/xqHhoQ/lgwRYlPTvuOkOzeb6z7n1rY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da836536-e06e-4f53-f293-08de4c96b3f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 20:12:08.2051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FkPh9Wbd5lQKRNn2v6a5MoguC2gs805pauYn1KuIuo3P4YGLkPlRW++dp4fmqN98paK+9T6Xt77HnIAwsMcH2WUuSrHZ62HoWz5F9lB6tvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050175
X-Authority-Analysis: v=2.4 cv=RoPI7SmK c=1 sm=1 tr=0 ts=695c1b1d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=a_FPZE3UsW7wCDZMUWMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NSBTYWx0ZWRfX/3u6mbSdMY6R
 RcRM6vGfPYEBPBvVUYYInwjL45oV1LsTS3r1lKjEubFblq6e4s9q8bAzbmgETUsFCzubDlR/Hsp
 yg1HB63U+PCrYdP4SCLaHwr60tcG2NqZlV0x6QWPcQnhbaho1ECyWwQFGjiJAnIj/CbHkoBZRWr
 jA4utmbrmZ/czO5bqetjTbtHOvEEL/vmW+L0ZvBVWfS2deLBmMjAy12KF68YTrUqkNsIr6gg7YX
 CnhAhM28RKbzO7DTgqN8Xqp1HGQMLNuHO5xf8CAUJRgaevJ92l/wTRu8SFLHtFMbYX0/gSMF4vF
 CoogeK7D4gKohmkzdS/jgXr4IGlSKGN0viBNCqAKXG+HZjawdjRBSLkkp04rf71iKquSEme6r6D
 pDEQWl6PO4BoLyVAnLy78apNOIUG6bJWGze593bi7hvg066IwtbHhN+dKYvChUMPE+wdqPcqgmG
 hHRLncdmhz9ojG7J3XQ==
X-Proofpoint-ORIG-GUID: h8WT2PbbSTVmBMXbdCtdjKQuSTla3jbG
X-Proofpoint-GUID: h8WT2PbbSTVmBMXbdCtdjKQuSTla3jbG
X-Rspam-User: 
X-Rspamd-Queue-Id: A7244180003
X-Rspamd-Server: rspam10
X-Stat-Signature: i9jjb138up5iwtwiw8645fuxscz43qrc
X-HE-Tag: 1767643941-927444
X-HE-Meta: U2FsdGVkX1/nRyXr41B7FD1oJyr6u25OjqNuvPYQqzgn8FDbhBzM0Nf1F2HcxQfI/37MidYCk2xvF8NPEgxnHXST7OosO2fSg1sLS/vCqhDb/gaXCy9BiOD8QOijy/RGZin/6+qG4HGEHJqP6dMt5+kYyiGqmZAZkHON0YEZGoNHwcTVR93Une3n6qEvtDaw7k6h54WZyIoM1n5zPr+ydbuDe18yr+RYSO1g/Lkn91bMIjzLByD/s0eZChMFAH8JMov2ZnTwlrNvB53YotphaBKqN0ajEaiWrq6nv8mZBLCw/Lf0vqEf7zIassNr7dXFKxCOdX/SQZRBXUQsOHlX7HZq4c791hqbXOe94LuuLBwk8xP6nm8K5GH3gdCikeglh0g+a7vEa1JqG3mNkwTyI7WbWJNqOQh/nzYBAw/t9FV/m15IocIM0lRPQqDw6nZSLS1mMfwZaWnGOEUxhpwjMn1/WNItoIO3kZqQBqB9Ly2BSbSJTN2j/fokaVBlhpuuFwZ4SKuibEm7fJfPf65bf52ggWtYeVM2LxGcUYw4lquP/I+wG450oTgBWzSyQa/4/21mbVywK4hxLzSaKtYe6F36IslPx+6v8qj6KpP45L6Gf/YUszErBG5k3C1bw2XKBSLilPLn2BwteytI9PFHgJnv+FP88TkKoZP6BX+Ph9KVHMHA1XhW8jdYA2xUGv4czVx2sMELk5A7yjuODQ1i6iY/k/0X7itK0CwhxliO7yHGNrFZuf6RfKGZt3txagtOTVwSqqaBIS3SY2Eu8tlfzoqf0Y2oU4hmdyRhnD6UiBsJKsQ0Ts7rU9FJKy5VxLBoLYltya0MNwyD9neUCopCTQJR15uFGNqKaYgHLVSHAdtV/o/cycwSZGmQFBB38xA8xsJSDBQMsQMQ/a012bjW6Zgt4QbDAcp4AOIt1AQnJvuo78+TlXjQsNtNcYHuirDdzmESdU4XyFBpa4JNWgQ
 /hDK2Qbg
 Znznalqtxp7V1R/eIrP1fLWqzAHe5urEyqnJX9F0VBsunGJMLJaQUG6YyBfwJazlb2yKtTAsnwO4NGZCkaIrLjTMcouvHHjr0fDTUUrGDy8cnwTy3JWJbznJrzX4uZfJu2/kyzDWBBNnaeOByjwgagCSiDEUG+aLg7816dtsEbHpWhYW5u6qHdjsS9TM5nSBjHOS2KIasXDvc3QNnLyDv2LU03Ra6bLzu+cLS0r62CX76ddPGQSBCCDBgDrjVE4ZdOBsDroj/CefaHcsirOG8Voou3FkPxzcmuMK+uTwljPCB2WSXlgZAZKwgpApQ406TLFXOt9nODwpnMsW6dAZzO66Pz7JGF0eVWRBAwr+/JwpJVHgPem2AUS3oF5g7NI7gM+K6BeBKNrjpwHeI93raNlcFZXVMD3H1ILwSJlScPWa4I8O6zemL+lNxhgVls1zrhuPlflbIxx7tBb2MSFswcUVd5wr9umE8EZELVwTbx8UkPVOt9L0XSAOCJmFlJ/TRvnwFB3BD/y2RfRLyXAO9cOtgABp9VIf/ofHTSv9rF65Aa/Q5e+jmZqEOM7FbyOf8nO5i5vJQfmZJURy/cqTckRK1/JrO7oomlUXXwHxWbFpnRySYDfaI5Y93Ro98iavksjwUObriGffRstIGC4eXOnzwowDR6U/FFrmiBRHqfDjvf1YeXbjqMEROqPDzH28uZZlSEYwTtMVl1Sc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test that mremap()'ing a VMA into a position such that the target VMA on
merge is unfaulted and the source faulted is correctly performed.

We cover 4 cases:

    1. Previous VMA unfaulted:

                  copied -----|
                              v
            |-----------|.............|
            | unfaulted |(faulted VMA)|
            |-----------|.............|
                 prev

    target = prev, expand prev to cover.

    2. Next VMA unfaulted:

                  copied -----|
                              v
                        |.............|-----------|
                        |(faulted VMA)| unfaulted |
                        |.............|-----------|
                                          next

    target = next, expand next to cover.

    3. Both adjacent VMAs unfaulted:

                  copied -----|
                              v
            |-----------|.............|-----------|
            | unfaulted |(faulted VMA)| unfaulted |
            |-----------|.............|-----------|
                 prev                      next

    target = prev, expand prev to cover.

    4. prev unfaulted, next faulted:

                  copied -----|
                              v
            |-----------|.............|-----------|
            | unfaulted |(faulted VMA)|  faulted  |
            |-----------|.............|-----------|
                 prev                      next

    target = prev, expand prev to cover. Essentially equivalent to 3, but
    with additional requirement that next's anon_vma is the same as the
    copied VMA's.

Each of these are performed with MREMAP_DONTUNMAP set, which will cause a
KASAN assert for UAF or an assert on zero refcount anon_vma if a bug exists
with correctly propagating anon_vma state in each scenario.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Cc: stable@kernel.org
---
 tools/testing/selftests/mm/merge.c | 232 +++++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 363c1033cc7d..22be149f7109 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1171,4 +1171,236 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
+TEST_F(merge, mremap_faulted_to_unfaulted_prev)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b;
+
+	/*
+	 * mremap() such that A and B merge:
+	 *
+	 *                             |------------|
+	 *                             |    \       |
+	 *           |-----------|     |    /  |---------|
+	 *           | unfaulted |     v    \  | faulted |
+	 *           |-----------|          /  |---------|
+	 *                 B                \       A
+	 */
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size + 3 * page_size],
+		     3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+	/* Fault it in. */
+	ptr_a[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMA B in position,
+	 * unfaulted.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/*
+	 * Now move VMA A into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b;
+
+	/*
+	 * mremap() such that A and B merge:
+	 *
+	 *      |---------------------------|
+	 *      |                   \       |
+	 *      |    |-----------|  /  |---------|
+	 *      v    | unfaulted |  \  | faulted |
+	 *           |-----------|  /  |---------|
+	 *                 B        \       A
+	 *
+	 * Then unmap VMA A to trigger the bug.
+	 */
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+	/* Fault it in. */
+	ptr_a[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMA B in position,
+	 * unfaulted.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size + 3 * page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/*
+	 * Now move VMA A into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 6 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b, *ptr_c;
+
+	/*
+	 * mremap() with MREMAP_DONTUNMAP such that A, B and C merge:
+	 *
+	 *                  |---------------------------|
+	 *                  |                   \       |
+	 * |-----------|    |    |-----------|  /  |---------|
+	 * | unfaulted |    v    | unfaulted |  \  | faulted |
+	 * |-----------|         |-----------|  /  |---------|
+	 *       A                     C        \        B
+	 */
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size + 3 * page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+	/* Fault it in. */
+	ptr_b[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMAs A, C in position,
+	 * unfaulted.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* Map VMA A into place. */
+
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA C into place. */
+	ptr_c = mmap(&self->carveout[page_size + 3 * page_size + 3 * page_size],
+		     3 * page_size, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_c, MAP_FAILED);
+
+	/*
+	 * Now move VMA B into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b, *ptr_bc;
+
+	/*
+	 * mremap() with MREMAP_DONTUNMAP such that A, B and C merge:
+	 *
+	 *                  |---------------------------|
+	 *                  |                   \       |
+	 * |-----------|    |    |-----------|  /  |---------|
+	 * | unfaulted |    v    |  faulted  |  \  | faulted |
+	 * |-----------|         |-----------|  /  |---------|
+	 *       A                     C        \       B
+	 */
+
+	/*
+	 * Map VMA B and C into place. We have to map them together so their
+	 * anon_vma is the same and the vma->vm_pgoff's are correctly aligned.
+	 */
+	ptr_bc = mmap(&self->carveout[page_size + 3 * page_size],
+		      3 * page_size + 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_bc, MAP_FAILED);
+
+	/* Fault it in. */
+	ptr_bc[0] = 'x';
+
+	/*
+	 * Now move VMA B out the way (splitting VMA BC) so we can place VMA A
+	 * in position, unfaulted, and leave the remainder of the VMA we just
+	 * moved in place, faulted, as VMA C.
+	 */
+	ptr_b = mremap(ptr_bc, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/*
+	 * Now move VMA B into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+}
+
 TEST_HARNESS_MAIN
-- 
2.52.0


