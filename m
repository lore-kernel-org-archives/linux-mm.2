Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08645C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6956B00A0; Thu,  7 Aug 2025 15:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9881A6B00A3; Thu,  7 Aug 2025 15:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F1E6B00A6; Thu,  7 Aug 2025 15:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76FBA6B00A0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:21:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04BE2BB2A7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:21:12 +0000 (UTC)
X-FDA: 83750929626.20.5CDCE55
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 82D7B10000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:21:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lEp5PI3n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LcjhL8TQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754594469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zomJxk8ANs7vgjiAjxA1QTlHUj4Eqi4TyAhi1iseNGw=;
	b=we24qj84CSlWirn2KU/VGNy34IRa1K0q/kCJtmbmnU2vXj5nvIyNHs20R59g//riiu81Sh
	itEMPHMAAsUCDa0MSxbfT63j2yA+Ktnjx9FWjv0qTV2msPyKIqwBab2THiAaciw2WAMR4t
	vgE1kgwwQhbDy8gpoHvZvwzOJzQiv+Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754594469; a=rsa-sha256;
	cv=pass;
	b=wNysxvlY48XfunpxxS2gDIYfXVjxDGKz4oTXwWiqM0dvxbWQ5TlWUVs6+qjR7vpiSnclQE
	Kaa7h0m2gjO/CCRCZAV9BdBwhmv7B8dFxO2Y05c6+4tX4aseGtDEXrym1NN07i8IKNr1TO
	HfohJaDGmqFYLekXqDuSiDTBVANaPq4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lEp5PI3n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LcjhL8TQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577HC7hV024928;
	Thu, 7 Aug 2025 19:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zomJxk8ANs7vgjiAjx
	A1QTlHUj4Eqi4TyAhi1iseNGw=; b=lEp5PI3nsYXx9s05V1nFquPKuKEcrYJTbQ
	R9ESaRkT5EcvwT5mrfmtl5yib6ZpqWFj2j9VrBplHDxCKz7lftEhWMcbSedyl7hS
	8iTi5v4LdU6c52503qgdHSLB2lnbsEL4olEPTUsPG6QHulZcvWPxMEdlBiswOWak
	a8zwZLl/NqPerTbV9gqyrF6z4T7m9jLCgElenPhPZPXqM7o/FUXrt9kLvlEZ2Tso
	m78PxB3W1PUSID0AKJzM2/aG12pRf6H5WyHFIsYoYmfMdbdGYjDEE4/+uSdlcq9p
	85OwIpZdb4rsiihoY6b2foEJIPxaKksOwiCTJG+X8mHIKvn3X7zA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy50uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 19:21:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577J9DVq005646;
	Thu, 7 Aug 2025 19:21:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwyvc48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 19:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rV+brb25VPMi7YhHSCveqaKXuVOQ4K0C/ESFT5cJaw4rXSUAdhLZLUEZ9/va12NmIdudPB49Kg5CZvf87H48buFHV2sdygdU29Sss3Ma8rbAty7J3jKr0dZXRpq07oovCFNjFGpFm8rx5rbZsSfF+Vy+LWtObpJphB2t8XJX/RM0tGivQ1yoP7zzTsOVfHc119XVqfMgZn3Cw42wZcmy/xEn5Uvp6dbIXVFpK5Iq0Zr2LOU4U7YIQLfJ5RQkbpFXziDmuIOjrNFs88SZGgkDuvRcGKYS+vGWtbGD83D/Sk5wNV+hacM6QCRGL5Re4dgRSRNgN9xjrB0YQdrB63Fi2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zomJxk8ANs7vgjiAjxA1QTlHUj4Eqi4TyAhi1iseNGw=;
 b=QHIXaLxmFB0GnYgvXfbB8XtyEqIQ4SNpeZoU7pWC9YQSV60E1LCOcpQFiBvKOWOwrhAtrUcFGiyaKOIczIZRWBWMC0f7JUJaDkSKi7/6pk44DMrNHYnRsIdvYOxvNDWYGpDeqFlzV/8h7cd+jvg6XLDRpPXz3Me8U6bJDeHwki/WwC0wLx7eHH9cDjgh3IEFXQfnf0cd4acI+Dd5R7LEB22eRaI2XpSeKOKqgycRXXbf0hcOyE9DNXI0OGeE4/1wdZABmZUewp/W+OTqgWp5+w/ADES+i6Qpm7KOS6YRgcoNn7NRKkSvNMyBhVKRX3kgyNpH2xi1bD8Ad2qMKXwQvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zomJxk8ANs7vgjiAjxA1QTlHUj4Eqi4TyAhi1iseNGw=;
 b=LcjhL8TQXa4/z4WmTJQD9BJUdnh/x7ggPerEUH5fwFUd7IBxKNC7OnoNPZSQsSna4cTqgWX0lPpBujiuVzH4J5SHBXgVD0hcEMlnCBqkbrNYGM/mUxQDIs19kiIJF6mvCzJ8Ho+cSng4OArnr7fvBb4tsc+LywBwXI0iW/L9qmM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF612E8E8B0.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 19:20:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 19:20:57 +0000
Date: Thu, 7 Aug 2025 20:20:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
        Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
X-ClientProxiedBy: LO4P265CA0260.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF612E8E8B0:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d7bc5bf-bc0b-4b91-57be-08ddd5e7891a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1b62Wn5nhFyj5LCRDAzbSkm6pq9SsdYf8HS8eYM6JRuGzlY20QwEM73LswZr?=
 =?us-ascii?Q?h0mUHfIFtQFBBgppHmmTc7NIVYoHjQUsAwwk6QEqD8jA88jMz+6KwZY13Jq2?=
 =?us-ascii?Q?Zv0gOlneAz3PedcvqIB9953UDNW6OEFnWwSvEq+UDSGpA/zelqaOiJJpUibN?=
 =?us-ascii?Q?d7Oc3K4teAZm5ZgYsaVKsmoaFdCMuK4Q/+EPHbydK9PyDD7i3Z+QMmjEm0PG?=
 =?us-ascii?Q?cL1ds6ghCpn/47gxDrbX6MWTEUxNla4j/2z6478dujfmDOB2hgr1hctX0HYo?=
 =?us-ascii?Q?ImUUtKtCjJBoXnjf9eYvkQ5iK9zpg6qoslaUGaGA6D2GwdIIcKiUL8M6wkBH?=
 =?us-ascii?Q?Z0gBJzq6iOIQsoeqR06o4nam03NG7LKf74GVPifz3C6iwNy1qI37y1FsWFsO?=
 =?us-ascii?Q?oCZapiKHV/f9UfyXNj+xLVrlQd0ScmnvrMqGSWkGHWPq9b8qr3A0tFm3pgt0?=
 =?us-ascii?Q?RM4CDF/0Jouhkd940a1nmLiA/E2JtSx21y2u2DXu6+7Ps6pvvzwff3vxc16q?=
 =?us-ascii?Q?YVFYdkGZLcpoMDkoOK5WyiiZKHykwygOXGGkF7w+g4vyRCPCZ/oqvA1Kms0G?=
 =?us-ascii?Q?0F778nJ9kId0pYSRjeywbzVi75c7elo4lSQlWud065ryYBBLE+VV++0Bmuuj?=
 =?us-ascii?Q?hQP5Nabflp7162AX0RTVnD/py6YSg4cD38zucx5/m+g/UUIwlk6HeHj3UpZ0?=
 =?us-ascii?Q?TQm9Bd6gHC8N4GDg79axnA1/GOyO8XxUVHdKHZNrLQ29UD73wJc/PaaNHWuI?=
 =?us-ascii?Q?CFlYFg5vedIQqOO2XZhWt/RuRqLzj/xk/42yJI9jKsOPyHBQCM0pTyWHm+Va?=
 =?us-ascii?Q?c0mmuoW8iq3L9tK8g9NiXWoTLXOchOEmOIkB/qmmm6p905Fw8CmbAhneARTi?=
 =?us-ascii?Q?aIHNEU9X52NZ55i1HvEquUTZDK+qlDUuiR1q2Ytc9W+1dniTtkchJCEnUtKo?=
 =?us-ascii?Q?v0IkjgLQcfcMsb37ptR4eboBqAxyLPKrdZ0MVcuE+wurCHwrS1A8C/0PMXYj?=
 =?us-ascii?Q?DPyz7mj3iBEwfqIVUpWcWNx8l5frasNCoSX4WwU2kf+Usai4XN5S+nyDfSFQ?=
 =?us-ascii?Q?Qh89X8BGB+01esnZ7D8/FqGS1K7hZiMKdkIkrZupWl1pz/PGfeWnopuRk92v?=
 =?us-ascii?Q?sDNgdSI1/vMzTN0iD+Hawan7GeHPLAhIqmQ3gpLcWqOZKRrp6irEQcN4s621?=
 =?us-ascii?Q?aL6W9Jofnl2DGgF0+g6TrBWiuG4AD4fT7tagBlPMnk72Nonr/oISrf+N0wc9?=
 =?us-ascii?Q?mp2ZtgwGdHn1+VNtLcDZP0eh9bBYRuQCz9TQXiAVlluqisP3mYZzz1B3cjvA?=
 =?us-ascii?Q?nLE5q5UvCoqC0wttSJVKlZhdE4rtSr4CaK7DNr2lxTnMElH92ZwNoYgpUEKT?=
 =?us-ascii?Q?u42Ed56uO7Cqu3kTVpwDvCYPY/qCckEZdcNZujUp2gU0jc2kN02vDg2X+6mN?=
 =?us-ascii?Q?RejwVf+uJxQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lzo2fx5xOcxytNdGF+rODnMAFJpy0iKtNoZvzAc/KENa+d2kJLSJm0NoOCag?=
 =?us-ascii?Q?KIeg9NXSx/1fSGlQ4hDUxI1qH/i1UrWx5HlZ7hrnZmIifTwcpQz053IlIo8u?=
 =?us-ascii?Q?JAKkcC501wd1Geh4UH3wdiHNVvAVJrfNaI0RjH0wJ7BkOTlVhsE2fbxFSMQt?=
 =?us-ascii?Q?sKn/ppiY11NYheGlkZc1wVbnhKxDqO7w1mRkO8cf+07KK1tCnCxqWCJkru4o?=
 =?us-ascii?Q?pqMCSEUF3l8RZfNKMOrQYey+bgREk89QFnXqrMNSxkw6xZChnRbigg1IdMRM?=
 =?us-ascii?Q?tTSpmFn36zwtG7HC17IoaAgvezHbT0INgYq+2gIW/ciSMg6jyzaJ8E26Adg2?=
 =?us-ascii?Q?aroKjRsOCJ0HhNcOnZRQnqAw+3vXWtXtwJGRMZUE592AY04VDtJSwSXfGXDT?=
 =?us-ascii?Q?ZTKuFm6Knz5JPzNu+ZPV3jb5vq5VotHdyuS6D/qgNqPkua24oEsGpKUHIBLY?=
 =?us-ascii?Q?73ts9eavbEqQ8CAwksn7mz5OKItofDKMGHjlmMZdAZGcwZf77BSysV/ESgq3?=
 =?us-ascii?Q?hbHvP276KR3dneBWxGfdlgSfgFAjq6otwbTAFU2IJJYMtLq+XYEhRQSMeaNN?=
 =?us-ascii?Q?7oQdHXD8p11VlMf71RvKP+Mb4/oJ23EpJNWy+O9i/hPkkdzf3y+2M8jFyV2P?=
 =?us-ascii?Q?ytk040Z+41QaoECBSqfitr9CdMekTBLZ78Qf8CqZWkxYHlJBLJbMrjdKqvhB?=
 =?us-ascii?Q?44Me6MBT7otQc1TIVBxXtNcsSExdA6FWnABL1lM2I0ALGxDwnkPBbh8tsavy?=
 =?us-ascii?Q?Jk7Luh+siVBxX1DJz/asACrEAiB3TqF14YwXSXPGXWgLJwpSCHH/pD9XG7ya?=
 =?us-ascii?Q?2C/hfCk1VOoYhBk+hFtEVp9UZNh4DNNXS9Ps8cooH9G1KJ0UEBhzPfhBHVcI?=
 =?us-ascii?Q?eXqXX+5gCc+VuXufkWfx9LgTaUmH+LLRcCDCFpbE4+kE11jzljJQ9Sb1kweI?=
 =?us-ascii?Q?TSJk6uCX4Wv/TowFx+Mo2M40FDsPEmM+BW4vFuadvtzFf2fkeBh6zCJyOtmr?=
 =?us-ascii?Q?gw7PnnfzLXWqv4A/1yLD7SxfPZbjdNsD6pLY8uD5OIC8P6sMcK4S5dCxgBob?=
 =?us-ascii?Q?gFVJvB0SwNNLIx/VTT8NCKTXRuq5Z8kIoA+r8o0NQDiagVhOo8muS3Q2QxQH?=
 =?us-ascii?Q?M3aUfrrfPDxUlcMjspdOVJKDvMlVuRsAfJ9OUZd7RSP2AWx+xEn6HTR0r4aV?=
 =?us-ascii?Q?2FEl3vmPosE6TuZUxKed9fFr2ETJy50WrscLa2WqCAIpJOvPS37kUTlpMrdW?=
 =?us-ascii?Q?iy/8Rgqx/evo71UwVtpk3XWHRIdDhgshfmbVa+BYiq+W39C+tkEWRPssAILF?=
 =?us-ascii?Q?/yXFSiohpmsw1TAxL3oRh2m6LN/Qa3n5diI6LA0FftvVNbgkZWIsOvFccYxo?=
 =?us-ascii?Q?uOkNcwrHNNkKndSNOtwUbKWkOVg1LqeA1YoHExv5nUXYPBCGM2wjWfvZ53EZ?=
 =?us-ascii?Q?8Kd/ZYuwmDq0XD50FHBZPmeP0khAaQ8Q8kaHovntMCELGI3hAJOzELAO6TMp?=
 =?us-ascii?Q?IEWKGmWAiRFIAq2X0g1fp45iRmRPOU/MfxVjE8mletnkYjo39wQK5j66SbMF?=
 =?us-ascii?Q?a5gHZtWB1H+APPSFDgYXQYfCvXvkdq11n0tGL+e5YJqBNimwHsyGx/G/4YWn?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4rmsg5Iml2NodsWUpjbi36eKQ0sskf8bZA2b59y9LDPXkBkiGDDFoBu5tTogMfcFBMX9jUpD0/fgbliwn4J4WmqeDQo909Fe8nB/+moVcaoYY8e9fetHO/R9hLwcMtCUdQ1AqaZ+qJE8O5AdD2SX4dK3YAEj1z9JwUOPBzIRCCSO+UpTKmAOR95h2sre9GPVzvI/1vLix06BNaoWbmVhJ9PjV35j6GqG4tazWzLmZPC8UZ7UBSg4I7eJhBPChaMpjZP6NpUSjCavJEi0IEg35liUpqBaMj8v7i/jGmbYVKyZZa1YYTBwkQ572B9unpfit++OY6EWY2ld/TRO/FBO3BZUlXNDzCFnYU4436lAe6myJPDTfLzJNldDFr79y7M3my5b27gnLGtQRBKvRDlx1rja53lKq0uimSfbWd18MoZhjabFYdGqPqAxYQnqb7RwoR0JD71M1qam+ZqohU+y0du12M4Opzt+7CoLMTUHO/n9idepEVrfmMLp/OJrSbD6TzlFI95w1EIGcy1EXVmRT7NlCpwR4QZsf4jNNJzLZKYh4xTgoVFqoe5FH3rYpHIjkql+nABUnymyNi7BnoZmtMKpe6OxgzD8/VC9rc+HZck=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7bc5bf-bc0b-4b91-57be-08ddd5e7891a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 19:20:57.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JK+p8k4od8kKG9DMjY/zXOR4TzyHi65ZdAyg6g/xn1Uc0udadyM1N4KpALltKlyHoMdYlIRt3kJnZk6sVASHHl0N9NTehgyCPpAkn66RHvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF612E8E8B0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=602 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070158
X-Proofpoint-GUID: wlMm1zIk7SeK3hUa7UR1lS8kCV56Rv5H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE1OCBTYWx0ZWRfX6mijwZRbuxZB
 NQzBXqC/pnjUraSuRY3wzXr0Etj7uHn+Z2FtKqyXaahqIrWdd/8SKKPf0Ouq4gv20JFrmqe3qn2
 HPIUZ9TNBwIFxgIpA0yPDsMiXEPlPFA/GY/KaXzELgmHxYC1d4XKlZt4LhbH36PXP3vsY3aL3+0
 hh9IOZ2tCdrf6bkDuPEHbp4+DHoqC8TnHd1LVJ8uVmxXl6wHiuPcvfSliFGOGRRtCY5dsAQBBGo
 1o+ONC/yJ9y/ErFSU3tqAFCIdBtnvNGBaeKIUmHc95zwesRcXA42VtjlrXQwmzXp6ZaZXORCiAa
 UxIYCKUfv/WFZCzddbPwcOqM31gdZxHWGPQDmoHZm5zy0aJEwiWV+45L+4+pnRCYrO7YUB2AXUb
 Zt8PSg4hXGPguUWWqpkT3b9PMyb/1vVgyd30VqtYpCAe3lx1Q/SnPN7L57c6Ldw9ahyGcht9
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=6894fc9d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=17fNWo1zRM5nqQOUsyoA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: wlMm1zIk7SeK3hUa7UR1lS8kCV56Rv5H
X-Stat-Signature: g1zrmqgh3149epor4m1s6jdhe3g5gjhj
X-Rspamd-Queue-Id: 82D7B10000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754594469-919160
X-HE-Meta: U2FsdGVkX1+XbPz9M/oXdhE2fptAypgy2SYQrotrQgfMYFfmAYNPcHGr7OnoDcSHMwAi/vxXUZ5SBBbOtuWn4X5f8Papp5YwyfsFOL/ff+GZYogyW6wYM6x4PyCFQRQmcRSd8WS4xlLjOWe62qfL9v30+Llp65BZYuZUt8VggD/RVpJcPXvX9c0E586MxCaMtx1Mus+QC9P2VnZ6acYX/LQtb7cCwzoOxvZ9UJbQwF6Clv2TvebjHcY/99Fgstna4v9k6oJgsDd51B5MsP1zbr8yX0FjN/93/OpMxA5jUXVBwFWB2BqJeGmcEt7iyw6hL8wpBU66gW+g+2THhp2xnsb+H/mL/NjaDs827Y0Kbhx+SNZddxx4RqLCcqAhGQ5Um5RO/LJ/+X1CXA7hXydFT1hRDR0NJRt6/sT50ZghU/Bt4BPlO1qNEyN0zDjsSN0bP58V8Hlb9pD4QmCXdve0mmmtpiZ7uTegO7XNgdb/OItggU3IDRLkYYPMgkOHx8UGBg5UL8KxBKRfXnrHCu4BDxTpaMA6lvGEfnjSQEgTo3TwIYjuwwYbH8Pshja+uTLy4RbYADGhGuSM8eZVT0MXLL2uFZzx/4e27p5svztmP0saWlNnah1NDdts8/McAVrKxBLDKSCBRFRvsRFblsKP/lwfZ9kAoI9MzUfhElDNZsNrXJRmelwJQvpi72Asgt3U2QsUcXOGOaliFWbosu4yi/xi9LJy/jkDqq5lhj34vfsyeWN6XuqsAmaqVnFOd7SxIbRQU7Aq0kmk/yLz0nVuufysg8yJXspv/9KZ3uyBqVS1zJrG+KOcfKr4UAxor827FkIrC4BmzFAwG6UgKEgfXTFLWglValj2TFyra4xZ+gy4dYczzIvdIxtQc0DsFVIHkFm5Y1kailEX53e9S80Ij26ffpCl5R3qTsvhSHZVKtMVAmlG/K2pGYiXM0CIdJER3Q4YUC960Zfpjw3c+zE
 B96vgLJe
 UsBSdfqjiL0ZGJQWZXciTCAzmOc7vb7x95+Km8GCVWffoXG841KeFGHbSLF1s1RP612lVT/Ids6p7amUKoLTrK+/yE+70hkcc2H61tCqqi7WTGdupHj7HKvuyH3g64mAr/2roh+7B8qNWFFPqgq+CbMyYUjAHVHq8ZYcpaULlqpIeD+eVwpDZGRwmOl6VlFNqQZ1yjHh3+YX3/RD5jB0MkGIrF2ECAG7IM+ejnvMdAkdIDJyedwrNkiZYPfsYuaW16HvKunJ2sM9wVHhXgS0NQ9NVjb7BWx39xPN/esnInN1PzBoPig1MsiGopzpZBbRkT6H7MJRWwfx61+NboYa6EtdHTypcMe/jZ3bg65rjam5xT4+EJZUlvMU78IKZM5AHMN+KjYqy6IZNjPwGVCHKYwkHXjDpSsj9uo+0QYToRVuh328dk9JkKpUbigyIpqJ8++dzJYVHMAreXpeCmMaYyE1wahNOCK5Irya7ziN9o4u2bjSzuPJZLRwS0qdHEB5w/6QcSIllgV9MQlmpX7o8k70hW9sylQpjfHqkPqsOCYT/jrl5fAC4oCKqjmM7ujg3s7HbSXSBr8fklYOBSU3pihgBTw1ZfIQlshzmmyt0Up+Md2i7/XnGZYekVZsCiOP6E+uyPraQU+Vaq3g7CXfGMfB38MMS2+3BkptzwiF9LXaFW0btHXSxEG/SjknvMbV3rlZSWQQ0MQcq0k8KTbtIRRg+5kzsdogKJLoZpf0crJpD+Xk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Ryan for ContPTE stuff.

On Thu, Aug 07, 2025 at 09:10:52PM +0200, David Hildenbrand wrote:
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

>
> Wondering whether we could then just use the patch hint instead of going via
> the folio.
>
> IOW,
>
> return pte_batch_hint(ptep, pte);

Wouldn't that break the A/D stuff? Also this doesn't mean that the PTE won't
have some conflicting flags potentially. The check is empirical:

static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
{
	if (!pte_valid_cont(pte))
		return 1;

	return CONT_PTES - (((unsigned long)ptep >> 3) & (CONT_PTES - 1));
}

So it's 'the most number of PTEs that _might_ coalesce'.

(note that a bit grossly we'll call it _again_ in folio_pte_batch_flags()).

I suppose we could not even bother with checking if same folio and _just_ check
if PTEs have consecutive PFNs, which is not very likely if different folio
but... could that break something?

It seems the 'magic' is in set_ptes() on arm64 where it'll know to do the 'right
thing' for a contPTE batch (I may be missing something - please correct me if so
Dev/Ryan).

So actually do we even really care that much about folio?

>
>
> Not sure if that was discussed at some point before we went into the
> direction of using folios. But there really doesn't seem to be anything
> gained for other architectures here (as raised by Jann).

Yup... I wonder about the other instances of this... ruh roh.

>
> --
> Cheers,
>
> David / dhildenb
>
>

Cheers, Lorenzo

