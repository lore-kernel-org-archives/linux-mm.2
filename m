Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123A9EED616
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 21:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F686B0088; Thu,  1 Jan 2026 16:29:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC9C6B0089; Thu,  1 Jan 2026 16:29:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC0B6B008A; Thu,  1 Jan 2026 16:28:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D71936B0088
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 16:28:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56C8E90D09
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 21:28:59 +0000 (UTC)
X-FDA: 84284685198.27.C9B41B5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id C2C55A0004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 21:28:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g9LovB+s;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WoAUS5Tv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767302936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L82wNQOE9j2JfF2E6wq1krAIirhLIsfEQJ5bmp8lJJQ=;
	b=FvmTmVBNFL6CS4R8O7PAEh3xDoNdsi8X6OPNMXHXYnETujaeOeNDWlwcS0MS9E7WpeWO1p
	Oh9xjjfz7C/1HgKBfSGloiRUN9Fk3ZL4lynglS/RVnOEpUnkGj2z/7m5zUNN+lFJqrd0KP
	PafAaxtIHhG9HYZfactxqDDDbzxEt8I=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g9LovB+s;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WoAUS5Tv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767302936; a=rsa-sha256;
	cv=pass;
	b=zQTF0iVNBpdLO13YhGeFDsbVPVHCuaFwe4Rld3sKi/CJR2EtUhRPJx0QFvenXxMtDPKbeP
	nbgencO3OUhWAMS8Tu4aZQFTTrfEGpVDVpG02u1a5Ejq3BdV3SqLf5mASA/8qV4Ibs787f
	tdYttaWUC2bxMfRe0pCB0FPRzDJoj+Q=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 601LLd7Z1370489;
	Thu, 1 Jan 2026 21:28:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=L82wNQOE9j2JfF2E6w
	q1krAIirhLIsfEQJ5bmp8lJJQ=; b=g9LovB+sBkvRvxFOGqusCDaUkDRq24l+Hk
	WAqejbw7s9hF1VVmCLcf794O+bDRPEZOQm8BcBumUCCxhv5L5VRiZBaiOVCz/wNv
	pH+Xea+Ie7MhXo77fMPv9Mz+icFSPeL02k0ahU8DpmiKtbN75cToLbDz/3FnMsr1
	qrVSScU86tv65BQbUeJjnGTSMUja7R9khNtdj83tdAsXCnSyS1ggHc4BC+YDxSgA
	kw2CrZCEGjAqq1K3VCgCRu9p9YuEjvrPfekO9WY8togtX0zstIxBTC9dID3eUGD3
	BGDfcT2gRBfFIDmq0ZV45gPOVmEV8E6/PGQ6QnJAwedsNg5PZsxA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba80pvhb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 21:28:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 601LQHBv024372;
	Thu, 1 Jan 2026 21:28:48 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011040.outbound.protection.outlook.com [52.101.62.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wkwhc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 21:28:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b5g7iMVKyoQXwzDHfqXYif9LEqlKB1G/uz1SCfLeqiITk0WwErTlNw6UQXHQOUrYv/STPco7pxKceh2iMOJrM+gbR527LbmO6aVCIj7tw+0+oVrjQUTu749fpsdsGttE2RZwSQxEi/idD9lSKx23tiG+IjwAps3i7jZo71UUEMXIdwQ9l56ew/TJ8OOe7elVqwLYcR+Z9Dg1yFwGzAf0CeeVy96goQC3wNe4BKraBsPb8oap7xMhN6GG8bNyp2oHYYGe6h2xTzY1f3fLdnR46qS90MV7l8zUNrOelWl7lTf2vQj5fCpLuvhhgve9LZMLCKTo/yiNPXCiBshsHT3xWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L82wNQOE9j2JfF2E6wq1krAIirhLIsfEQJ5bmp8lJJQ=;
 b=bRKbVPSv7K1snrefrobmIjN/pl4HpVscKHUVZ7qg7CZ9zFPMTbzj67Sqycf5xLE1nego1ejLh8AuTlEW6ytY+RuBpQUbRwaXgmRMrJ8YOAD2mVk02HLBxqcbB5n6VWOExnk17PYNEjeoyIY0ikLzE4Ky1sF4TyOSvDTWV6t4RRj/66sY0Vpnfc9DWw8ksK7uZWJr/i4+ZPPKSRWrlDxJaeRZcPU7jCQCHuOGxZdZJ1XvTJoLJMqSSXxneVwP50PVLxICk1QsPFwzTcoIg3SgB/n5ZIjI/Ad7CFQNkT401d5mBjX20AHQhN1pOq/ILtJr34AsgFXY+/abS9RERx4Tzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L82wNQOE9j2JfF2E6wq1krAIirhLIsfEQJ5bmp8lJJQ=;
 b=WoAUS5TvZkSeNDqhiMDMyQUzE7U/8oHFQgxrubK7Bfo6moixp8rptq3gqgG4V3heskL09W80aYPRpWZ4MSi+oFbfUjSnYodvYrM4AvaJxv3WSQgYRDYMrDrv56fTWYRg6yh3vx2dUmPoyBxRMKaxJvjiyyh2sUI9UjdtRC6OVlI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 1 Jan
 2026 21:28:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Thu, 1 Jan 2026
 21:28:45 +0000
Date: Thu, 1 Jan 2026 21:28:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jeongjun Park <aha310510@gmail.com>, Harry Yoo <harry.yoo@oracle.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <9306c37f-bc7a-4a7f-931d-452ef6aad358@lucifer.local>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
 <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
 <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
X-ClientProxiedBy: LO2P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 55cb1967-4bc0-44d7-7a9e-08de497cbe86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/0K8btn5aMZCPX8FY1inMOvRsbs6hVEFUwTrBvXQoOD8hKDM4tmMG8xyJxYO?=
 =?us-ascii?Q?v5f00xt8PP7ALbOux1P4UBkg3pfymqDQUur8NrakpYmy9jFAO8TD5woHKwpE?=
 =?us-ascii?Q?YIPS56Cr89/QvOmY6c1I3NoN6FZKNSvsVyGb6fh/zbnM/Karse27k5WDLwxo?=
 =?us-ascii?Q?lrkeRD37sJmlpAAHb6AtWcr3/Y4rzpX9oLLQg8OX+yjgccvAtMCovHw2Yv0F?=
 =?us-ascii?Q?mOt3q4k/fxAlbJDHZAD9u/1Xnr1BxUuPCq+bWhq16/2QebdBgayizX8geihU?=
 =?us-ascii?Q?qlSx566O8FgHv0+7n3i8pO0PFzIYGpGFp2fW2gCdXAxNE3klTCLCCDVWv74W?=
 =?us-ascii?Q?R7UTweTmCbK/NfcJMkiPG6cEH6ATY0ynBmlm/wzJMp1LlrmkvK8aCbbxi+ZA?=
 =?us-ascii?Q?fRGdRkvf+ZITfk3lcB1A6G1cBMaKpvWlUwlJtadnJfME7wnv8oe0TleeccCG?=
 =?us-ascii?Q?FQe/+fe4AGG0IoEOBHO1whgh7TfLv7/SluJOWNvnqbQeY2Urmyl0dlj7tEO4?=
 =?us-ascii?Q?xw9qKyxk+0b3dhDHIoJmiRJBQmeCjR/ZF/GgCA7m/rUM+YK5TDGZTM9yktgP?=
 =?us-ascii?Q?SLsR5QvyfG6gDzH18qzY4GLv3ewNu+JKvRQvGkOYreYiOXnO1rknexC0cs4g?=
 =?us-ascii?Q?CMdseAPkO+n40ecFj+pX/LurgplciUaNaIQVucDCFPouEg+QUfaVzeMmmuXK?=
 =?us-ascii?Q?ACpqM2G+oKzCGN0JaBWtaWxqwewUZpP7RFg52DFx0jYAsF7cSlX0Fqyt6ftB?=
 =?us-ascii?Q?UjAOyNNQQDfc4Vc+TxxII9XJhJ1LFroLrpcVGUPNENpgcilIvtMHnqbjoc+7?=
 =?us-ascii?Q?TnVzSC8RDwH0T4av1U1wWBN9nwQy+Ut+osPdQf6CnnRsSkX65oUeEygHqDQN?=
 =?us-ascii?Q?bCw6qTips246x0BiqAiM+4mbB9Ch7D1A8iiOPRseToPThJxM9DtrxhA+XOEF?=
 =?us-ascii?Q?5bY5gS7mPDKoXsUOkQ/+JbAYHFwNfijLEHFtp79XP4xhwPbsEgkVk+qL+nCK?=
 =?us-ascii?Q?VkRqRSyyGRLCfPgCKCgTqBhJOS8qDZ/08o/EgEShmb5vEAueJ0RGBZ5s3dm0?=
 =?us-ascii?Q?HpV+xig6J6C5vbBQEh3p5BXNUzllSZ6sapYRVOuq4RTumjmDu1NDyCYJPrW/?=
 =?us-ascii?Q?npN3c5eD7rPbZxziGxDaYSKuLR0UINrYrifA5/joy681E45XcnJ6xjn03VXx?=
 =?us-ascii?Q?3c/jap+YwyU7iYd/Xi7jZvvYfahtBBxFQsgYQB1coQRJ8moySYSyy2JxiyvE?=
 =?us-ascii?Q?N20czk0AQhUW65Actq73idJkB+b2wI1FAOYXRrhUtLmuHm3/81jPwDQUX39/?=
 =?us-ascii?Q?kyUz478PfTRJF/OiEDEi0azXgTLeCsASyBzkKbLHRQek0cbKHdgYb+qnPoaX?=
 =?us-ascii?Q?m5DYpuw42++5t+Mzb6fzJbHfYO5vTGtGkEsrQopTlb00csYUsl5lLtgLYTY0?=
 =?us-ascii?Q?rY9RFGLtBVuYIgdZpzy88GgcaUG5EWqI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m08rQY4vzlRX1Y97CcISbw1b2MXJHudNphrmsc65ASo2l+nXO7WO+0/m4N52?=
 =?us-ascii?Q?yh7nX4J7r9JSsr09zmcgVGkRhVqcBhIhGNuac5AT71Oi5Xkyf44bmyGqgm2k?=
 =?us-ascii?Q?z96WPhX6clV2TkJNdpS4bUgwjSlVj8SuLCrVEtt7iucA/i6p0lF5ji93uaJw?=
 =?us-ascii?Q?vZesiNHMYqCavC/Iz84tDEIsug4X5WTfxcK6eJk2fxy6Xdz4A9En4AYJnGbK?=
 =?us-ascii?Q?9d14nuQMOfFVoOw6dvurTr8Pn2o+UC8zn7i/ridHz1pogz5LI46yQepXBsF4?=
 =?us-ascii?Q?hPwxYEiJsEotpmzE8G0yi31eG/5SOzOaXan2xMohadN1lu9XmMRAKT3xA7jU?=
 =?us-ascii?Q?faj6A56TkYO+xN4HmMHzLrfwmmNwqjuTPvOBw1WDI8GyrXBs9Nmdty2HlIuV?=
 =?us-ascii?Q?MYt34nCMDjKwXYMEINrK/v8mtTUqP6TR0wS+9Tyg4Gz2eZ6N7BZvzwiDxARe?=
 =?us-ascii?Q?RlaN1rDjFJWygUeVlQ6glvTOuRErj7L8zkSwHfNLDMJ93DU4XaTVl6OPDGO5?=
 =?us-ascii?Q?BoSQcx9QJb/3ZtBdCy5dzUfMsQ5UQxv+J26CyBoTCwi8d1U/jasZi40p01bs?=
 =?us-ascii?Q?Im88Mw2NzG5Ya0uCDVDPW4VqUjx4XOX/ujlrntNGY0yEVCpujIhUIh39TbF+?=
 =?us-ascii?Q?cxEaTBBDi5YCJAluHJig6402IEf6fQrnrJR2d8PVeEq0Aje8iXVbeqGjO+Md?=
 =?us-ascii?Q?HqIZn2V6L5jr5u+iEiBalJMmVHs+m+rcOMoaPMvoasYkT/+nPDYIs4bSmqpj?=
 =?us-ascii?Q?jKb0EoLQyX9jsueUG4Gxu0pYa95sCc/SIsH8jmKB4I6kGBpy7GyShh0Hg287?=
 =?us-ascii?Q?RSrMaz0kzNGVmK+j/e6gEbpIujHUbjw/vDPRkaohWJMghzh9lYxwZSXNYJ+H?=
 =?us-ascii?Q?KTLd5n39OJvj3iwpbEo9mj5HiWWh/oDlQA4w2fZtRco8IgIM6Kf+7Ja0rKir?=
 =?us-ascii?Q?txVqHW3rc1IDoCCenE36mxlFjL5qGoMAmaiMLsfU1LX++XxfaHu7lCnZFXhF?=
 =?us-ascii?Q?MVeSYPAL+Xf62u79lCAQsw0v82/L2WiZ0sSImnC5qFoCm0CktVX425rcBrpu?=
 =?us-ascii?Q?x3ELU1mQVMk92jcQN8uUvMYVux5Cwp4pQpApOBRivNCZteoPQ7yVmooSUgUL?=
 =?us-ascii?Q?E6TziLvBCoHanDEXtO2sHq+DXPPR11zEtuteNXgBnYKysecL1AXylsRGnBlW?=
 =?us-ascii?Q?renYnfSQ6SfdyMKx3RfbKK1kf6D0xKeLbVjTo1wR5pBcxj06COkqhg12o2bS?=
 =?us-ascii?Q?RGW0xAHM+935UDgRVTRudQZdLweJHmDOwSSkXZI9V8EbNdMYxd8v4e6fTVSs?=
 =?us-ascii?Q?vA7e9/Lr8iED+kdRB+zqycl3d2nRpLXw+RzxfKwuinS82SYVwJWdpyYKMunD?=
 =?us-ascii?Q?FN3na7KFK2qPAGc7Y+c7z3q/O12/gF9oNWK+CD9aIixD83PAlMV5uq/TbYfT?=
 =?us-ascii?Q?lUz3IMNqxRrsfHYEqLaWzjpNmNwbJ2MXLiisTqJLcFYxbZQvdMB5R18kf8kL?=
 =?us-ascii?Q?ZbRyLsA6tDDOh7XLVtBEUxpiP/wjfxHfjyrTtViXMojzrC2B/O+FZ6aFeVKX?=
 =?us-ascii?Q?837foYexsTET0J3BHUDsikzafz2T67n2vdXSWWu5ipPBAmYby29UwOuQ+RqL?=
 =?us-ascii?Q?jB49/PLSbruCEo84OEe6wRCKpTaflMMAftx/5cpH/fjw5sY6QXGmJmHB+OEi?=
 =?us-ascii?Q?kAeZXOTQDu2Yo0t6UKxRfsF00/HXUw7liGx0lhFFB2xvnNIJA0tixAmffhsJ?=
 =?us-ascii?Q?LayJ9BZbqiS4IqTgKifdBqHMbdIh2YY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vK+lkYfgmBmAtZ3ghoHCX7d6eYAwcA/GDLyS/4Q5Xr2+6gpDnkPAK8CPXPv48okw5QdJwVmLdXpxhMk3DVGa+cso7XpNzntUKfdMsoATA/O9bEPOe19x0v+L7/+F19ZlyPqDIVz0Kl1ELoSbW1fGDh5usCS6YCUxrmvSHQYirSzAQYRCkGzJ+/AgvgWwnwHGQuh/mCtS1ixDaVhVDJgCmjLddBa29WQEUPIXop2XJhetpaDvjSKSYK8W8HEZ1K3M7aIxf3s9HDGa4GOX0gOhARJUyNXKTl6c9IbVsDNQBf+GuaNViYAJi/CG2Ka1X7jywTMgSwPCWeEApkiqAx3baTbbRax9ZmziyGvizJi9Um97jqGX1CCrpjm4fTo4KqYHVSLXxyI8hJeJNMTk0n9bQ5I6WIbdY64tNlp4ZQODObR+3ZPP0SEeuT3njTNrOUJD9sR0iM9/y4oMdL07K5UhBIjBtJhEuPdIqC7qo5F4kMkoQi9sucG5NB63Gg+jGL4YbJFhsL7Oa5HdNIj0I2fAIQWFeMlzf9x40tgVz5kzS3FfWd/6TFT52j9Ef13f0aiJzqtVyMGRHkRb2AOHYhyeNrJ2MksXcz/vqonXVHpEc1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55cb1967-4bc0-44d7-7a9e-08de497cbe86
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2026 21:28:45.5709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXajagGyr1LD+f9usutta4/1/yNI6KB8ERN5OQGKDCSmWtpccvPU606JGZkwJslNhVAs0o4Qt9ATUkRIyT8HSyJovyyTA0EPQVK4jEPPR0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_07,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=814 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601010194
X-Proofpoint-ORIG-GUID: maT7OVSyT4Lx7s1WX39OAQ1KoG1tGeAz
X-Proofpoint-GUID: maT7OVSyT4Lx7s1WX39OAQ1KoG1tGeAz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAxMDE5NCBTYWx0ZWRfX+LueH7WY1LGZ
 hqoLeCieP4WWpcTWaw2LYmtRCxyltPynXnE6HP8HGEKR/muwayIv4AWw041VTWh0gRJ1iZ6VCO+
 AQcxuSTzlIgXjmmNm6f1OLXJRmfU34MKw2Dqua1sfmBgSXM/fR9LK7kdjACrFWaZkU44SyXc+o2
 5GuUQ8MsicYxOtPiu5XC+LfbwgJEO33xgvpS2uzAsM8If/D3mT/nL4Yqq1N2c4BuKHx4jMXOkCg
 HCRQqO1MPkJZVnayd0dE50efniz96FMrm1kgPAm33WcnUiwSota1al1Z7HVon7oPFb1mX+B7OJV
 7fnJOtrsZWD3ujGqHvMpiwVoSjllnt1QkI9+/AfFhVZok3FqCvjMSHl7t2QLdF0isT8l4cT8Qj0
 Ob//2QI1AQGn+cmwO1gkLOSPZbMkYpdAK7cRhctFupb4bayCbqyYqegDO1OBy3wz7CBfMVo3XSJ
 PzBL0r8KPPVGkwKYWS19t1MnV9klY0tRSZlJuig8=
X-Authority-Analysis: v=2.4 cv=RY2dyltv c=1 sm=1 tr=0 ts=6956e711 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=O9370NYXSb2zyJjYskQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13654
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2C55A0004
X-Stat-Signature: 5esnfwt8zggsen68z7uzqme16hgjp914
X-Rspam-User: 
X-HE-Tag: 1767302935-603006
X-HE-Meta: U2FsdGVkX18NES1+rGwfOtK+Dih7WY8W/cQIsjrUDNXRL70aa6aQ/siM5+r33phkol7lG0+5KNP18xLa5BKLB7iEh8vtPqF5spi8Zyb2i6rfw84j427dHF/1tnhhENl+egJymyveowfnA27oCZBSAdmRfFwa2erCDJhB5SFFNut+PBfRMecYEszuSLBEP+KeS3TrxjMPfkfpsa0omLH9ZkbusK5vH4C/iU+PDn039puXwyevD396vfOqOPIjnO96GNxnApsx3K2rISpyGnFcUKMm4cTDPD1LAsCXcjskSbN/r2bv1z6GifIfyEdBK2nS8jln7g/SXsyYqZsr+9CbX8gyPvh0ASlas1z/UjEtfh3LiksW+GL6hrTokwJe5YzTqEwhm77nTt8nDwJTCDAbQTuKSaZPyc0YILpY9V5LJh/SfxDkW+xin0qMGKLjnOGGW+T1Ke3Tv6pQ+krScXnTftIP/0PvGKaEHp2Mp2+XnIicJ0/nUqjOu6b+QBCQRkHwgoJG7GWxFEADHuKfwHzmzsPv9JdpGrHF2rg2at/yMUDPfuO5Ocy3nGcJhXl4qhzAZrj18rrMMA/gQbjqcACTIHzxchrK91P7a5jv+c4WuSDHIqexzaQWCJCEKmRy1g4lZZc6/V/xtNoQAav484YvFdHtDmmuP+OACgEfHE8ShDmufFnkt/COby/raokJCDgasGUV54hjWMJ3ynfcKbDjry66RtLT9jetQ5ZeDqk5PPJLBDAbr5J4UUQE2e3IIfQrTKtQRJLXQ5qbGDqLDHZcUru9+Lf5calksLkr6moxDQ8+yhTHvHl1y1JPs1y7ATc7DVeqeAN6WJiDvlzeqWU6noLuW6vtcpFE/pePZcEocykcakAAcrESvav2h09rd+kEc3RHHG1zK36HIIOdoOn3GeLITMGeL4exblTFRQa1+LgEKGuiqVLSLIL+2AKshSC/wCje7JQVtbgTCfXf6EM
 Nh9m65Y0
 K+XcZqEVnKq7O43Jjeb5YWmQqkpxKA7DNgxBzgO7IeJlp8ZGgSzhzyhOhdoLuJNz95wYnJqPkEKSJc4NswU3GfMFxLog22lnkxJ520u2udO0CjF4sZ8hhHa1y79n3tCgH6cB00e6iM3QJW5XOjc9RobOtod6Kbb078DK+58oQW5tWh/M0dE24kpFY/jfVFAFT6Np/yztPkpyWpMB+L0KWytzr4PHFky2VymusxjHTUFTxZnlD5Jg3gAt8IjYulTxdQRl12yAPsaxa0LicoIG40EL+xBPL7kxAvgBQ2ESqpk5CMt4kI6uZ/rJgnobk6nloFE1MKwN3m8mXFcgZsfcO6Gr93Mjez8rTV6bLayTh2i4l0T86jCd0FTG3K5cS7EYjOC0atoGP2vE1PMq/rIBZPB/r4Ez2uahkcW3a25EN1PfgLJJd+lFtuiPJ3k03VM/utCzrgFS7q3ACVfNjSfOWJlgcEPXV1UVV0GOy57Xju3WwFumwHHnzmxap7kK0+tYToMRQHWESuT25AA5d77K2U14cqH+zRWfHE2Hs6lN9TOyKjoQuS5YYEBWiJM1EBDYmxI4T8/q9BmhuMOOWiN5ksKtQOoxufqcji55UqhLj0BgetQloyQfiXEysjkPprZYlyCKZmF8rPoexow4TXNC0f3h4MaxnH2Yign23bGE/xx8FnzOvw2XJ+bbh/eijmOm2/PebEmte0LL3kRjWO03atZah+bDeXqvQ31RD+OYay7BPKJ7crXJmcgKRGnusBDtsjaXNVckkbTq6YYVCzmjiclf7iZowLeI0UiAQy0C1NdJVpBA1+766v/Oh8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 06:06:23PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/1/26 17:32, Lorenzo Stoakes wrote:
> > On Thu, Jan 01, 2026 at 11:30:52PM +0900, Jeongjun Park wrote:
> > >
> > > Based on my testing, I found that the WARNING starts from commit
> > > d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs"),
> > > which is right after commit 2cf442d74216 ("mm/mremap: clean up mlock
> > > populate behavior") in Lorenzo's mremap-related patch series.
> >
> > OK let me take a look.
>
> Trying to make sense of the reproducer and how bpf comes into play ... I
> assume BPF is only used to install a uprobe.
>
> We seem to create a file0 and register a uprobe on it.
>
> We then mmap() that file with PROT_NONE. We should end up in uprobe_mmap()
> and trigger a COW fault -> allocate an anon_vma.
>
> So likely the bpf magic is only there to allocate an anon_vma for a
> PROT_NONE region.
>
> But it's all a bit confusing ... :)
>
> --
> Cheers
>
> David

OK I had a huge reply going through all of Jeongjun's stuff (thanks for
reporting!) but then got stuck into theories and highways and byways... all the
while I couldn't repro.

Well now I can repro reliably, finally!

So I will dig into this more tomorrow. Having a reliable repro makes this
vastly easier.

I have theories... almost tempting to carry on right now but I'll end up
not sleeping :)

Cheers, Lorenzo

