Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF20D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497726B00C1; Thu, 15 Jan 2026 14:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECC66B00C4; Thu, 15 Jan 2026 14:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170386B00C6; Thu, 15 Jan 2026 14:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF78C6B00C1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BB4F1B97B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:23 +0000 (UTC)
X-FDA: 84335207166.10.3819F64
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11005180004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Epaq5CKC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gew/OQC4";
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHDeQa6VTyK8A0vOM9JQVLu6IdrAHZaNehx8PG6pdPY=;
	b=MTUz285DacVA/+e1t9F1Ua04BLXvQNSCSKRgBxlQIzhegH1zsQOnv29GfpTK33hlVmYVA0
	x1ivVe5dpjpOrcQLQRg58iKDcVdQlL09+J1uYmjNw4Zzk07B8eg4aJIlZmHWLti3HpqdOd
	xhY0ipMUVGhotYUSWgYhj6hLE7Amex4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Epaq5CKC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gew/OQC4";
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505840; a=rsa-sha256;
	cv=pass;
	b=h5zspcsvAwF+yG4UJdxPP4JVgjhCX+Ijl9DKzgb8CzM86pgokqjdsHFzSNN6w+vlvyB5kQ
	DfifVJn47a4sQP2NvXrsQrR/ZoAUTS0VuIzmszXa0nC9t3N8RGTDRNPFUd1Ml3NGN2CQFZ
	AL/cQiALaMn2eJX9n/IIw/ZFBeWbmgM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FE7VOH1295689;
	Thu, 15 Jan 2026 19:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nHDeQa6VTyK8A0vOM9JQVLu6IdrAHZaNehx8PG6pdPY=; b=
	Epaq5CKC38Uq5qRDFkGH0j41d7cKAxleqzA1NCltZeK0iY/PRInnzk0IiSGp5iXm
	yiVNQTcdVUvTW2whZPS5qoBZqeje3aiWuQA6dzRYuR+SMvBqgKP8JWlmvn2iz7lS
	xuUNG3LdJmRbALv6forMg9jY2SPtVDr70u3Dt0X56ncEqPyyVgAPZfUO0RvnEnKU
	pZaYxxI2faWpf8kbCRUHrXtL9xm6Wvs0xHx+fiXzquPlabVLvOQOP1oOIyUcDxy8
	e/B0HBZ/R+B4pKRW8DQKNfJMpBoej1ol7/O2sYPg8El0ACBPcZO4GT/qTJExRwVW
	/rkcaIBwzOtjcpYg23AR2g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc3tt0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJOrsr004503;
	Thu, 15 Jan 2026 19:37:08 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011008.outbound.protection.outlook.com [40.107.208.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngu1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zS7gp9Ten5qm58F4iz2mVdzsf7oE+db2JqI92YT7s3clVqhVMrP5AtMqX5x1kI7TOSZUvK/YijFg2RQC+gLCzCDkarje3ZHZw5TuHUaRae5T7fDqrRk9JDAgAM2QhhcBEDuVQg7+MTtu6V9WJBIWGBGjPuEwqD+cIDXHeVUoiE3owfhHZumfpBKr4T6H+7fbOlznNE2qAVV1bI2tpy7EVi5CPvCdSnKxII6IuItN0B+2YcFg+rXracVOuGAZ1t9yzMFNq4N7Kizs77FZQXjAcx2poGWcq6H53hkTqG9brMzhyGT+crEwsbLOIoxTHO/hIKI9VKBv+wvBWGBUom05GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHDeQa6VTyK8A0vOM9JQVLu6IdrAHZaNehx8PG6pdPY=;
 b=mUN1xjukmd3lFg592YBH1Ng8GB2BdQP5OJ1nV+a6q1ncwL1FxKa7KtahTOnfWOKXpU5E/3ypnQkHeZ76inhwaA+pFtUbFCuNvUHni8m1jnrUKRz2olcvu5TdOjm4a8BWCoSxkAMU+50BIUxuYUg85V+/A52qEMGcBjvI1ArQcvvCFzSVHIRRYiCGWg5MS52OwGtORDoN0OLORwZajpzqEBHKLjHLXbhmpt+tWeKavtLkD2T2YUN0sK407K+SpBhPGu8IqxJENXrSJH+tUxXFpMW24aEXqg48S1psrj7Va055OO6lx4yFaKvis7wnzsl+qOUZqugIJW9mIzow+MY4OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHDeQa6VTyK8A0vOM9JQVLu6IdrAHZaNehx8PG6pdPY=;
 b=gew/OQC46V/b6rBh06c3CiXZ7l1CxvYewdoDmvHAU1N4nhvLDOvHNBWIEFkUHbrcs6k47GohgTtNUNb3W8UwZEKOrSzWuH1AiuUVjfRyaHi/0EOv3NFnJBeO4Zk3Q4d/FeBCaqfv5+3ZwXqbSXhqTpvWtgDTvFaVt6MiXDsVK5M=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 19:37:05 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:05 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 04/28] maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()
Date: Thu, 15 Jan 2026 14:36:23 -0500
Message-ID: <20260115193647.1695937-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0180.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: a51455ce-a9a6-4cf0-da5d-08de546d76dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A81gtvS9dX2ZpilM78oAJPKAhB/viDHuEKe++pdjRKAfwlYBrVIgCdGcK6Pq?=
 =?us-ascii?Q?ZpAV5f3Nhd26GuSaKKj8E1MjKuCH+FPD4o37Q4Q5pH3NZ0X7Ag5gPcqRpXon?=
 =?us-ascii?Q?UPZa6k5QEO1g0vgkFA1IcD4w8jTF7ZZahw72BHtP/ivnDy7ilod1+uhZ51/G?=
 =?us-ascii?Q?lRS1QEgZfN3Uc5dbm6CPsm0aXhXFzxDOaRx3IJjLhGGJQRE2+nahA9GPbjj4?=
 =?us-ascii?Q?8c5z42JljlIJ8zU/LyQELeRtYB4GVzg/eHC6y5hnmq60Dv3eDRHZ51S2RQgV?=
 =?us-ascii?Q?73LkYSyrzyleIvHrDlTFIy90F4DR6XRg+UqtK31bKSlI0h8UK11thAkTVOqC?=
 =?us-ascii?Q?cK5Jjb6s2MWEbI4wmiixBIblwdhPyljLhN2cjiam2l3XvrskDnR4EPsHN1kb?=
 =?us-ascii?Q?QGHNfxutSua8Gbqg0zg53fi9cdUQR5UVifoBBTM/LfwBt+qN8xC49YyflxIe?=
 =?us-ascii?Q?DtE811Uvwm0JdCCHUoxTelDByk55NBdVMgAaNtFRcLnXO3wPjGhM/aQ5oWW4?=
 =?us-ascii?Q?riUBsH76GxgaH/5+tKZDq98peUgymySoabVdR5YATSdcVahUp011hlqjTE/f?=
 =?us-ascii?Q?YN5t5HCX/o7niynleAnQ7Klk9Q1khJC+mxaooHIuTStDO+0nzTw6MZKMmIQ9?=
 =?us-ascii?Q?Qgd1NEO7RPdZxzyvueP6x8yR2FZlCvyk4MjJp0eQ91EEc1OnT+VrWdlKmscT?=
 =?us-ascii?Q?PTVn/YOJZivEPdfhwrZ88Fs+MCdxKuw98NyatBHxP5Fcbnu+b8UbXoxReF3k?=
 =?us-ascii?Q?T3A3zHOAY+wfB4/D6oRgu8BGvghsgM7BpM0lMYIxpgBmufM9FcCGdMfM6dbx?=
 =?us-ascii?Q?r7aUQTDIaCBNauEyDs9G+zZ5TDbeMVSN7wx27rvISGZr3Hr+qFmxr3nnf3vN?=
 =?us-ascii?Q?rZjrabnMaou5fBhTtJSlKTrqWRlT9Yki5P12qmGsqrzSIghUREKboRipxbLt?=
 =?us-ascii?Q?VX1UjhHQo8br2+sRfztJ5wQG4C1eXrDNPO7ussa/Y/KdZQC4iGUE/TFcROFw?=
 =?us-ascii?Q?BQ7ipwNRKbmoyR373dhObG8tQhIo9LBTXMKDjlqCF3ymjVybrQy6RoYCuMis?=
 =?us-ascii?Q?3TyObsRzhzLzyZisg5KrJieg9iwcMzSgZfuWSfRY9eWqMYueBsduUo4ZllZk?=
 =?us-ascii?Q?d90157bGHjVG+9vQrT7oyOGee068T1wcNatJzzbfxyjqHnQc+Doy11z/wB3Y?=
 =?us-ascii?Q?cGXoO8N3sCuiYUtatJYgZMGaFeIQTSxQSQ5VEEyziQfa88zgmM7xSSgiTnmc?=
 =?us-ascii?Q?65aZUFlmAbJgJ2MguBHLUl3289wdwa9akKk3fU5M+nlrEcmFNOARySFNfn20?=
 =?us-ascii?Q?LbOozUbQAlIsVBISzEjkB0kgarApbQSIc/Nrku6pBl2OPXioYBOo68fx5jOb?=
 =?us-ascii?Q?AK4R+h6uKe0BEJ0orXZAxQ1ya51yz8YTy3UKhou18NxBG4/Tz48NOjHa25a9?=
 =?us-ascii?Q?87HHekw7ehP856qHLIaDGRcDz4UV6wLk2qJ+MuqyMj80f6pKBpEpKZJCHLBi?=
 =?us-ascii?Q?dC7Qy5hLpNNPjPOyC3lHA9BtdPsTtzsZyQ+ttvtuRNub84z2XPqMxfy4D6NQ?=
 =?us-ascii?Q?wN74sa0bh1sYrDrDcfo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F5W4cpjYQNpL7dIcUzWp+A3/6BNPd3mOdkFUB8WEoEzILIaFg7ds/xf//j/E?=
 =?us-ascii?Q?L78O57yzEz9Zl7VekeEWiD1EB+SaAlq+gPHeN5at0HBFYRhPgpHQlfBm51nL?=
 =?us-ascii?Q?H+WokgUmCx0nsQedfFiWRSJOrROkOpdYqTK2XzBl7B84Y3ybWqMNHB8AzaTP?=
 =?us-ascii?Q?9zhJeCSQMYH4LEU02SultRTitld+Y2ZfLbbl09S2yVx2Ccf5NAtouJxV/MG6?=
 =?us-ascii?Q?SD+yADjUKEUz0HmP2aWD2CW/40DqXTjWU1xAK7qgYoA4jhYhHfOc1aXLRC+f?=
 =?us-ascii?Q?QWpD5Uxqq3nFZ+p6csNVxfSfyx1RrQPOs85gQ6+s3r4qw1jq2pncN2nTwSu0?=
 =?us-ascii?Q?nMK3XRe3hUm1MyBmV3c5B78U4Jp7ww9VH9vPWMitf8JBj05+egATtdnjWjCm?=
 =?us-ascii?Q?oqqWGtPJLcW18zJg5XKjoFSPKQMMVmCloLxs0H4D2Bg3I+NTc9GcYiq4oiQr?=
 =?us-ascii?Q?3DWHfZZtlx+DVm383zRGtbhWx3H9A47CaV62FSy5hyZ2iljt7JxoCRzKOsVb?=
 =?us-ascii?Q?CE2L7CuiByvih8dgPcDX3s2M1eB2WbaByBZjYZd0eCkPgeQ7R3pXM7SIVzkY?=
 =?us-ascii?Q?PdM1MCqwTnsMm0NZGG5ts7Si4hmmM90YiQ704vN4LYoqFV7XZLp5in1ZUBVd?=
 =?us-ascii?Q?FIPiJKZDg6fwY+MIR85kPILMMYEfk8tJoNpcbgrbjEBuufYuFhySGzs6fd84?=
 =?us-ascii?Q?4YwRyeDcFWih/ClDaKEL6Co0UInqz+Fe6k6hMUtEx8oAO+xibMZbXVA12S/1?=
 =?us-ascii?Q?bPm4szQIxV+4sKbGKCwGo4nE7+oT6y6o0Sn6JL+UGhnuxeJp2+47/nF3NqMo?=
 =?us-ascii?Q?jDzNc3on2JrifIFbcoUhZmiYx/EaQ9gxdymJihKQ8UJazPJrjVBcaBvZSWO7?=
 =?us-ascii?Q?VIAP0SUVIdtpOlaweHPZkaXDe+gMFg4W0AMGmZB2KxGpX72jfevs2kcAsZM3?=
 =?us-ascii?Q?KpBxRvYYyELfDM2p8lRZ5ToGEy0Xxnzuq9HI1uNTjiVNVIfEFxDaVpdSXEkN?=
 =?us-ascii?Q?DXqKGAWJzLouztSqoe2pgXO8tCgpvioMT4FHnnPGDrKLsEmcg5Vv8zTwET0F?=
 =?us-ascii?Q?ItHZKnUhQdr4RpivhWlYkpslXJFi3rGf0yJw/KuE6fTBkPSDMB+Ha3Dkl6Vh?=
 =?us-ascii?Q?i/aowU/4/nnqmwZMf4W2MT1r29FW9/XRuWtSlTzvLeLh6H+JdWxNcdZWD+my?=
 =?us-ascii?Q?83HLLU1EPwKKygHia28G5Mgv2uMnPWnMRUOTKnIBb6p3Flsy4WD0SLiCCc2N?=
 =?us-ascii?Q?Wohh1Op97vqHWNkZG6B4/s+cqLrpJTGPN/9RS12vUIlF79cB6jnfTektpfru?=
 =?us-ascii?Q?NG2klu+sAAcr57A0VuHCO78zP6cFWyDby6YyAyVof9QuqB+70phSgoOGtH2x?=
 =?us-ascii?Q?j0VIfQQ04vFWCWtcxnsEAnQW7xnVjOeq/BCIj8uquZv7OyTI2vo0ilUXwbgp?=
 =?us-ascii?Q?qvqVG8sDZ2rh+udn4+r1CM6CZS/zBt/CeA0dkw72xDooG9PzM0VIHK8n7jz2?=
 =?us-ascii?Q?N/qqrSO7pf6mrOx32pSrxWg8jodMeACwa8ea8KUxUHYR3x1RuBoh0iP9+QSu?=
 =?us-ascii?Q?ixa6B1lHTyEYlNPv8w4Bdkk9DUlEmhcKDr2jYN7wQdeDFWE4zEf6dr3p5T3U?=
 =?us-ascii?Q?Dxr2hDk6F53M0WJuz758NRL4BW50wYofbBXu0zMxFOa2HjjWGK+VcKIfURq4?=
 =?us-ascii?Q?FuyUb0LPkL3hqPXEdvlrkkq0E98C7gEl6gLIHTq1Z1FUhHW8Z+eiuEzlhRjA?=
 =?us-ascii?Q?49sC2NHGFQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YdZGLI+zv1uVsVCrHusM5WWcVeuXfZyZKQ9KVVjAndxfBZ6r7/2rJThaFslVRgoOVdX0KjeWN0h1WjwESGQkU8UbfkpuATzy6bMtKgmF+4CItPG9M27xqQ/6uwEQtqyD/9BFTJO6PP8esJsQRAOM1HLOBSMPGHNLrTjLJMsPff3VleLAelRM3/bdkvcGo85x/s8ksGb7WuC8ANW9BQunGKHvjV79lEnmPW/qN1Q/rcfUesQl9h8iSzTFbiTzyIW+0fh2bYJlof/g8ttBVSXtT2huM7lzVusQCFCVrpLrIp1GYsVi0GZMaBZorpOxTfgo+RqTQHYXA1BmGvo7DiE6eeCRL9MCK8aDV9A0RUQP/dnQUvWhwUl5DXJMGNtll3hb+rnqm6iwldR1d7FPSCmg6dgkKgIZBByuIzhMWa3oEZzI1BJThaP9Evs8Wodo6qx7huAYqBth++hOVPFTCW7XL5WWgUDE2Hw/pDd4mqLGBrUfuejQ11Xz/7/s5Ks95DJrt12IiXcNoN1FaEmugl6lzJ6jwyKqG5S/D4qGo0H+73X38lP/tOAqqkKFTtDHEO8Rgha3gSXSAKAU7tzUWfnSCdVuPx62Jh6teT8v/eD2/+I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a51455ce-a9a6-4cf0-da5d-08de546d76dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:05.7746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZNRXanFH70Vi0n//rCZgowojtHaZiUEc8O3l4Bx7gbpdkCZscUFtUfk5MweGmg5lk7ILmRTe7xxl+QodkamKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696941e6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Ens7JwPV80q2LG9ndpkA:9 cc=ntf awl=host:12110
X-Proofpoint-GUID: yWMctJXELyhOE84zMHhH9oT2Y1FS84cS
X-Proofpoint-ORIG-GUID: yWMctJXELyhOE84zMHhH9oT2Y1FS84cS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX/hV0pP9MD2wm
 ECzHevxnUkSwgE8RaYNij7LTp4MdrB7A2FnAXvarx5P4csf7eDK8rtk4y2XwQlsXTRGgWZcNGPa
 Draf9iBazHREEmK9qJz5RNVupE5wF4ki61slajGOJdzdDid44Zijbcw2EcHYH5BmuOI2hTt4ixl
 aYo1J2+T/CSLkHOYKNKVxkrRLFL0ITZ2dxj9JZ+1i1B6SdAZD3G7ECA5vMUHX+/mkKUBTfvv80J
 065KV8KANkTgCBxMxd7tQ1qmAXgG0mbp8tudnl0s7h5zAAhBsA43ZFtkzpqRsn8TG97nvFE8RYH
 pr2hvCiWHH06PL0a7sVRqmSXVubWdyNO7KfA8dVLq05QxO5LoUSYmTvKjnUkmYK2nkc/bW6d3QX
 344cSZUWD36OwvrnoT80tmy1wOKhBVBJ2xRTqlA2Xu3GZ3ASg2EgmpxLsUM1tuN3YbgS9V8P6d2
 53gBVye6EV4fLotCi4/Zy+RAUo0uwEZqBSKQWdxY=
X-Rspamd-Queue-Id: 11005180004
X-Stat-Signature: 63s1uac6qzsfucimytq9449j7er3w6ue
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768505839-6366
X-HE-Meta: U2FsdGVkX190XHl5HayDddLLV5xDeSy+zgMpAI2YzstzIXQE2IiqmMqTyIWfUm4Wui3etC8+PeGSjjSXoKZYqMCpReUTJkdDRTDsPjiSIqII5EH4jCIy719JiBWSdulMzeJA/pQVKVWV71d1sqrzO6N397+1OgHsH3Sqp14p4DXbssVBGNOwy0VwLaDjQy2GTXrrGTql1smP/nfudxM1K4mIpgp8cTyF5M3bun65kNknMc/7ICpJhtLBIfbHV+vz//y4S5eMj1jUWA2U0lMXLbpdzPDJokhfEuhgu52qf82qpbRnu2hcJbtWO640znC4FYYm1mUYCgUszdigVFScNfNF1rSPxWUgiHoPPz3yfJfkbo6lSL+MQNqF1my9AFVc3mexP55Kyp2CjPw/w/lPs002kXcAkRx81MVvgmyvWVNJT7F+f8r4kQb67Ihl1V5wfcEpqlL7GXz1auv9cQe5B8MMBwDJHNBxiKCTMCIcrmUe+oTDNcnPjqNLFX2TLCF3gHgfmlEhxRhZQ1W1AbXYtDKrrq3WdE4Exb5zHlBSngg5HMt+9AVryKYKUvZ5UYa+maWgdapiugkMFRTYJ13SEwWKQsz6i2hTMQ4f9F9OQ1JZkHf2DXegUJHbIsNO+GkCXYzxYYyOBCChwJYk/Uw1EBcYDamUu1i8rQMl4br6h3gVBZ3axCmxkhpUe/KIXAwZLJ4y9AXPoMKI59SYEHv4xRPSqE7sNSMwTVp89pYRssQvzzf2pNK6PDy1owVc/qCJPKU7b0ExBOYW+rStRc6YzHcoaafTPhTXhcWtuvOfbef/QEXGANtP3dHMGi8F/OkAoW3iXRAiWN4f0grXrl7Icuo+gfRIjYklNI+X3JkUiseAMAA4d/xqp9DcErBE92xOyagrtHqnhdAkFM9XXN1X7vwRFhViQ2pgmqF6DOFNvtFZN07WZJo+1DF+vGmLlpcfiYWNwJ74a0hMHDbWvuA
 X/EG4fIR
 6oYOL9iFvz+lF8h6i1jD/su5tfjynxpfZ/9FtWg8bAw3Z0OCNScN7BsTOjz+Y87KBYjxUZfvSUN5ntHhC1oKBwrXThAWkqCOEjFao6yJUchgNUOYAb3xGHSv59unUR40tdBE1aHQmI2yc8ByQIdDUa3RgiKdnnA1GZ+5TD54b39ghuyVIq02zIIVj6AMLVz2SghhL/rmPvwh2BjdHp6BQBArZAgTnec7+IGkiW4Ew7R0myx4qYX1ORVPEr3P7oeDX3TUxhXfWKcof700bn16709p6KoySb72xv6a1YJ+95nvwnb/Hpz/maRfDSlVEbfannwigELt59tMYmpe34LqUpU4FSi2MgxIIUu3pRge9d8z5CsG6kTpuSwnebXJUo4U+lujwpVA1SpRDsZs0ggX/GF2U8YfKkww4hZGcyVGm55hzYl8AnFxZjVqdrKE+mPO9zggZr8xL7TEnmI8SCOIjjAd4K9JUIZUeHI+yh0f/z1Jt69SOsSpDbqH7Dn1MdZbf1MskUbxopgAr1D9+EI/KdCUg7iYu3Qrx6UsSNWanNouYAgVixuGdm7Ovd3bW13tdPZkeMYIixsTBr68OwNtuYNkNzCfjv23Ge9rupEDDrSk0X+mdH1HRTCFckZbz0nXZ88zjObnSyT4J40qtzA5p8IKX2vDuhTnFly1FWfONXvnb7Povk5FZMC5hSVsl7TSukFE4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Copy the contents of mas_spanning_rebalance() into
mas_wr_spanning_rebalance(), in preparation of removing initial big node
use.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5d1dacf95f718..67158eafc1d2b 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2754,6 +2754,9 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas)
 {
 	struct maple_big_node b_node;
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
@@ -2770,7 +2773,22 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, mast, height);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
-- 
2.47.3


