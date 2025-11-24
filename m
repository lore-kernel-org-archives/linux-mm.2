Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71802CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6E76B0026; Mon, 24 Nov 2025 00:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3AB26B0027; Mon, 24 Nov 2025 00:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA436B0028; Mon, 24 Nov 2025 00:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 750906B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:23:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0730212A7E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:23:12 +0000 (UTC)
X-FDA: 84144357024.14.3D58931
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E2DB8000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:23:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GCOHPX1w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OpwWpBn8;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763961788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zwz5j+CELvcXzYdr4wQtFu3BxsoYd/HMtFTzXmdzdw=;
	b=hSmjA39g8ZK0MOpqaa3cdbUxexGLu+q7FbWSfO5I3g43SR1wwus1hMPIb6JF1Rp/oemV0/
	Os3sRxaaPQuVaDD2oQtmcaGHIDe1uyN4KriuioP1oRBfqgp9EZSn2LeCILWdPL9OMEXF2w
	86NlX0P5ak8vgfXxDVYDOvvefIw2hgg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GCOHPX1w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OpwWpBn8;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763961788; a=rsa-sha256;
	cv=pass;
	b=n+PDQI5dhVNGgWNUoXe1e0MMFgAFIXJ5m10ivHpg1/Dox8IoUTZ8NUxFBBut0dYaWDZA6m
	I8ppuB8TMIzq+wr+O88cD+eCaRp5LfrVMkbBSXm6pPycGEJ3UF7HaDWT/do84JK3dnOtx3
	4XeuGmFOW/PYqQJrboG4i/WbSbsYUjA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO3wHOk186497;
	Mon, 24 Nov 2025 05:22:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2zwz5j+CELvcXzYdr4
	wQtFu3BxsoYd/HMtFTzXmdzdw=; b=GCOHPX1wSTGKnigo+bBOu+OFHNZ01UqcPm
	lRZaMU1TkWUhlT6t+dlA1MYGSDWmhJHBCBRfRr2c82ielfx6zf83Tk/UuMJ9o+R2
	GqUIWXKVSNAMQoAbgMIWHLivUzpzQaH0JKL3/aiYYUyIWxlPs2WvCzJjEII2B/W8
	xJmWxTJ7mnYu71G1z1v3Ky3acIaXkGGNcUxa6yNpvYQ0zCld71/eKzeohwWGJKH4
	zwP9cFiGpHpf4zk8Oey0xWrI+A/LARDLjiN4fqNYiP95lu8IuN4sc0Eu5CH3L68D
	SAq90TMXAgQRkKk4Z3LI1ehfvadwq7zzKjT+SkFsvCZuvOl1cifw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fk9bvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:22:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO1tK2Z022767;
	Mon, 24 Nov 2025 05:22:57 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010012.outbound.protection.outlook.com [52.101.56.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mhpgk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:22:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mple1zJL5AGRjWo3tSZV90VzGL83Z3JzNiBkQAfPXtqQ4aTUDX7HRzy1bguZVfkNKcc4pSGzXMY2/fjYWdJOGNFDVJYYZ2UfZE6hqN+XwYq2J8cqkvebKnFdaNVkUGdI2FJc7VnRLxULKAnkdrsw0X0T9XOoZH0FlB+SzDisTv1+fYGppYK2TG11LzO8GghQnziDhJFUnV028Ct347BL/lsyPm6XXeOs4nnbb1LXiDg4HzbJ47UcF1llO5A/QhAiXd7rxHo/ztbuCnKIEwUTq4IJ4z0XpKE/UQTs7DZ+c3hR07F8m0aYQ2DlSo2299ocvg5E6ebFbj6fnqwmS8tpqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zwz5j+CELvcXzYdr4wQtFu3BxsoYd/HMtFTzXmdzdw=;
 b=vguvxtSrvJD/Zhti5whDuHqoWzhRmIkDA257ctnlQHELtXfweFHUBSF6r//DYyAMTTQGZ6r50ZC/Xh6H7fiV+P3Iqt0MTNIEgoJebrm0YPdfegN74S6dd0mRJtRchE6wbhwAR2+cDWmWc/g6CO0LoB4MG3VXoAl0TZ5lDBwel4aUCKmO69AHpz02cw1pw9DYihzkY6p5YM5Ab+ehirYzvqwGNFOVty3aWcbhn9eXYL6pS9KnOOvX5zuxLGZ5c7OnE1LKQBqPwca14/uReJoFKer2evXXbbtH76f0bM1D36gjRIIn93OO0CDib/waPGnwLugfmLvWSngy5i8DzNxR5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zwz5j+CELvcXzYdr4wQtFu3BxsoYd/HMtFTzXmdzdw=;
 b=OpwWpBn8WvgkIjtWBgemHS5joVNOR1EWWooCxCZZSNcUKdhLlN1A9pyeyPkQ4g9DG9QeMfw8t3vYBcN4OLH6NaUU01iViLa6/KB8IG9WV2a6f0k1qcNPob4II0L1hvWyIZVme4/uink2dQf9SZRuK7puEhd3r+y2wDz4fuhD/rY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB7131.namprd10.prod.outlook.com (2603:10b6:8:e4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 05:22:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 05:22:55 +0000
Date: Mon, 24 Nov 2025 14:22:49 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 07/16] slab: Remove folio references from
 kvfree_rcu_cb()
Message-ID: <aSPrqbudFjxKdSI6@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-8-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-8-willy@infradead.org>
X-ClientProxiedBy: SEWP216CA0008.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d398509-1630-424a-1f52-08de2b1985ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zArkOibaVMdgemnKkc0Tj2/d6nZE1Z95Ko+ewUyhhXKIrBi6bkkel56P9TlB?=
 =?us-ascii?Q?YpVJ32CPD/wncziT+b/+l5bbXCBGkYb0EK4bW5pM3/CI4UMEflBeHy1s3JFQ?=
 =?us-ascii?Q?2lCAUmo507MS80RxFRw/LFgE1EPMtDcllXQ6FyApgW5wmS07igrrWv4X0flG?=
 =?us-ascii?Q?soXKy2eQIcI7hMWByGsYger8b1/O6vJhli+f9IGFUg6xJLYgCn1EOQq5ND0X?=
 =?us-ascii?Q?WNyEE/oqpEHJHVQgSB/FKhQvRWtNQIQJ8I61kAI1h1obIp5W00+ToPqDVMqL?=
 =?us-ascii?Q?dQfcFNfxz9pg80RX887b5XNqPI/4YbAjnhJvTT+tn0nlK2DyHH2XE/ofZL/c?=
 =?us-ascii?Q?G9JKK/jjUPR4wiQ9CfxoFKBGFeQu/2nWmkZLm2OwvTOGRSJ81Sz9AJfzkdL7?=
 =?us-ascii?Q?w7MXPxcvh8E9TThbiz0IsbBXtxlto48zYzPT+QhVijWY9IpPj0h8jQythEQe?=
 =?us-ascii?Q?fTI/MGkH2HIfP5KVJPSPRBB6wphBx5PqLlMejyB1BB1uBgo8siF4PFJh+r9B?=
 =?us-ascii?Q?DwuC5FcpGu+3GDWPh+GytBjJrN+GL8D7nwoOIN4zl7fQpbFyldN335WZ55nC?=
 =?us-ascii?Q?UBcnzmqprLe6SfanawtYabPGFdtxoUm0tz42kK7gNhG52zMisWAkklI8yAsI?=
 =?us-ascii?Q?LK04Tl9JKAuZqDWcAtRubHGGT8M4cEdp25M+a3o2rG87s6XbJMRCYBcAC5Df?=
 =?us-ascii?Q?8NuH4npFm8AcQ2vO0tRbj+sX3H8TUMw+sBq8BEzSpkjamPC3nzWFZ4ljnKAj?=
 =?us-ascii?Q?2UAkr5sNTFMwnz4MYgZtpaKMJnyrPgI+YUcLfl+kqoE6+qmWtxyl9krVP8ig?=
 =?us-ascii?Q?DMEBVV7S37epKX94Ccar8ZEJVFfykdUYn5jMy7NmuhYtUQhb2XWkjc1ebwKB?=
 =?us-ascii?Q?/UEFckRnm+Ro9o0XsT5NNqyorEVqDMa3gARRWqR89TU08/VvuNhIW7bVAo+z?=
 =?us-ascii?Q?oKUU6W+ty5+Run8GFE3VJC8L1UvQ8TrWJpETKEMJsuS9GhK/Y7rUAXRX76Tw?=
 =?us-ascii?Q?KRr2rNY1afSKREoclnx2Mv6c5DyeBsH7AIkuKRUEBCxRqSM2wmTMzjk31ipP?=
 =?us-ascii?Q?SGM/hRzk5NHGzvk6N7scWCIkds660h7Fav3xmMXylAS5J9oU9JORhK2zXC6P?=
 =?us-ascii?Q?3Q39gMrTFfyfl+WuSoQLwdPvBK0yZjobqenv3KDo45LDio2eC33Tfqetfl1t?=
 =?us-ascii?Q?gJnpTzFMYvhgWU9AL4O0kAZ+EbfB2PXH+lsYdRnO2HFClg4DV6p7+eHKUGTm?=
 =?us-ascii?Q?ewX7YRJ9hHON82d45l76BqjdrRqwVZ0CEnBgQ+EpVLb6Y71R88X0uNE22JpW?=
 =?us-ascii?Q?EZV0zagl2PiPBGdmi39sBIeavP85DORd+0aUWhcoF3UXGTYbmBlrPqime1Vx?=
 =?us-ascii?Q?vvhHWOyVtHjdV5CBjRRfhjVT+qCjLN8A90qXl2SiHeliFp1wqpbqe995bSSg?=
 =?us-ascii?Q?kyhkGeQ3gxAYAlRZi5ZtsL+eQKY0SdSJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iekKz0df46i028cfadzKZrOmKo/BiFexmS/2uUbllI+r7cBpHssHr/KT8JGc?=
 =?us-ascii?Q?QxUpfQaSi7T8W+TIPiXOsQTLB5rItodKDaNuq/b8DVhGO3UmoUW0pprRFtz/?=
 =?us-ascii?Q?C/1VGyqhjbJThukRU/CSLc+NHFBd69diqqdltla2AtIMS48u/IKamBu1b70b?=
 =?us-ascii?Q?yc6E7reFke1Ii7yzMRuH/nuSAR6pf4BaG9rTXWJZqCLC7zQGuEhrS5YbZ8WU?=
 =?us-ascii?Q?I36YS7wI8X2kA0XZMNuBJNcclZ0fcRG7vG8bT7IJKw2fn2wHbQ5gRr8Tyrkp?=
 =?us-ascii?Q?Ij46PzmRp5Y6JxinDdaT9G5wor9o4VzzskIJ3xIIZZ6ytNNzh5LVM0eFBkgu?=
 =?us-ascii?Q?YyvTUUT7C2/S/pLXPZMBAKi2m0pbxc1b1ZSyoN30YAKDXgRIbbM9NRc2tfZt?=
 =?us-ascii?Q?JYyPE9rKjM7mM32yc5YCpGbzWX48MlMIEdF+L6gl9ITb0kz3Q26gHAhWv5Wq?=
 =?us-ascii?Q?zKuo52mLrto08XCn+qiWpgLObpeq6PrwYmaDVjdiwpjr9B07+Lq1FeXX36d+?=
 =?us-ascii?Q?mUEbudipl5P4snZjr+1oBRzurmmJlzdAbHcvQgHCTyRWOqC7U6QHdrexWI/d?=
 =?us-ascii?Q?nlDU20+och8PZW/uY5faWRaZjng+PBOsnz4RXJDwovRL+rjAs2yWzN2YBELJ?=
 =?us-ascii?Q?qt9pItZMI9bDaOLHU/6EETolP+IbdlRapkH8moaciACbvxG827GHusQQFvsK?=
 =?us-ascii?Q?SvdiljTQyi7i9Bq9CRZ9i5eVF1GlRyYLpy90+vqFECAR8R7GRVP7qHdHhOCe?=
 =?us-ascii?Q?mFSf2kkneSEU0itQFMzsZ4Xp1q+MYMWUujmZkxetuxTC4O01knQ8YskEgwym?=
 =?us-ascii?Q?qyn74xHBENViJSc3xU+qfuLWrl5ti8Y6FtgaxxBe30qpX80TbLKMJrB0lnV2?=
 =?us-ascii?Q?ueotGZ0yKirCETZ9zqWU+nHx9haC5OKE+Z8XFd8d+LiG8vlVdbmGXVO583ZJ?=
 =?us-ascii?Q?qOtfHfiecTCha1bezk1WhDlMqOSnGKkwEIWuRdmskKKKj4+05YtpcjOYmby6?=
 =?us-ascii?Q?7aqvWknn1K4RfLfNe5cIJUKVlR7VeJ9W/SqYQnEfe/iWTG2sO7X7DmlJwQ2I?=
 =?us-ascii?Q?u2x+b9n6p3baFWAgUijmLznTv56oXkY7BtBPaXZ6mMGnh41EalzxPt8OWtaJ?=
 =?us-ascii?Q?1WNWksSBDiNEUCVlFLIlqgPkUcoJ8+J1JPxctUQ5ic19pVHdIEIFwR6N3doW?=
 =?us-ascii?Q?DHFyN3IM37kSzOLH2JFJ43ARO4Poz8VVrt5EPBvJvwsF4P+CefGTLMAdmxDz?=
 =?us-ascii?Q?JSH0Rn+nJmGGtl3m2TrD5zSy4uJdmw49ecuV2jO8gAleZ9KyhLKGpRmt3oth?=
 =?us-ascii?Q?eweDkx8MSOywMFfuARoTveCGuryXKpK/ipq4VVaoVlTkP92VinD7voknQn8O?=
 =?us-ascii?Q?L5Oq3ZySa15F/gz6PDaP2hJPYDLTumU45ZSOOQ0RzQotWncgHF5X2r2+gq9O?=
 =?us-ascii?Q?cE1DlQwIlBzzHbthPN82EKMWGX1zvhRgWIQehriaFVepzBH9qrPno9A+cUky?=
 =?us-ascii?Q?0bY8wdqAnWYfGH0paQZzSp38zkQI5r2r8N/ghVweV6dYzb/PbzSUG/ikWBBe?=
 =?us-ascii?Q?l5Ta+ICyBUWuIv2VyEKEGOCJyOblC8kgbEqn85y7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L6kteZnMvFHjOO69NC10oTRxYHvZSYynonKc75U4F7VNGE1kweEVwH4VpNd1AZGgIgD5Zxg/MGNw8tGk/mknv4m8tDTkqg6FcPQxkXa8yOWxQknYaZgKWerDSWFUGrq/CVBdftMKouuum8Nld6VU6eWuS6WXGhAsuX6aMaKfgT/GK2Xs+HzUGvXwQ3pst4AiHSuRkEwbqpxfTns5e6yc18Zu41HriV6sWgYbZRZcBbXbba+dW97grMClK2N8CrlRtG0h+Xdb654zxO0yN9ZbFH7JxlxgCYXzZLUUZ91rXJ1KPLnm8uLINYa8h2cqV1QR2FY6ZiMcvg8GFbH5sdCZuXl3ZntVrjoc2CLWxBm5LNmH1w7C9QKhtzp8ayJ5UXS1/Ggmn0f4qsQDfrVmbFvv/NVT3WXOgOnDp07Syp24Muq8ijvaK5JbEnhF5gP72hWeSs8WglLijG36Zmgh+QAvbDF/F5p29T+vvNJ5roKqonRk3tF2R8b8BAz11/Dl0zJMK83Egok3zLXj00f1VAEIGeYstCRyeIgl5jP8FMRPcCotNQPRkuGCoMmVJwmyYEJoJq47t63POIAv3HL4KdmCtG4/fvAxXXqhbWIhMF9ZpA4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d398509-1630-424a-1f52-08de2b1985ed
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 05:22:55.5986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubmNkkm5n5qxEcm4WO3/EK4VIR0N97okpnZ1ipcgzYML2YmpMPFiCdBpCd/VPP5nR6b/6ZZobH9MoNXtM37mMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240045
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=6923ebb3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=aAzKC_sCC5RDkyeHMykA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA0NSBTYWx0ZWRfX9/DRn5gTQC80
 yFFQbS6mytX2vuCcmdr/uwajP+5RgIpQf9pXllcRRj8taOBQg41KX2Vsiw9o45tZ4XqwEVMmSd4
 GLTLRsNorO59rjDyxGcpaskNir2iSBHFP/xyhQWiZSWqRKgjd4fM8FuTX2ddn3YGeOZvcqPobOo
 kBCKxM0EjnTY11lldaTHPN6Vv08nOwoRCm8+sL8YIyICSgOfRPc+pheHCjyd4jdnNCUBn9XJ9qq
 49aaUb6+jGLAfUrnjnSeSI7tpx3OfRE0PW1FLzjK0hXn655C9UpMNapmShQdxM8/w+VSnXpyQEj
 NLAjKwqt6L9wx7j/vg2fBEWg/27ukuCN2erThN+iuvLdonkqXOgWSNGg020rSSDxpfm1/ZaTDFP
 83qI4P6rbvaf32KRRALllKxtdH8R2FbjtBiiQSbqcykDjLN1Gtk=
X-Proofpoint-ORIG-GUID: IhyFjy2Yv-yefmXs1AcuTqsb4F1FvQbT
X-Proofpoint-GUID: IhyFjy2Yv-yefmXs1AcuTqsb4F1FvQbT
X-Rspamd-Queue-Id: 8E2DB8000D
X-Stat-Signature: j67xwifpmejtowdrgiwju5h131y5op64
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763961788-929317
X-HE-Meta: U2FsdGVkX1++q2zlHiIzviVsrwtpRCUWQpC3Zisqg2estQZljzWHdxZRITSvDsoOhT48E4Va57Q+E2RxttgGyYYZWzTBRfE9XzCI/ZMGqYhIFfgDRDrpgyjQh9lBK+vp2jN7Pftva+/L3D+yr5d9HOUTtqGS+fNYc7KQSMZrTxvHTXymLUjofpc3LyJi1rIRDk8IvIUO7LAq2EcVvLJkfVc5FTn9Ty8Arnv/29EtU3kHB+0MB4/2Wm6H8cjJ2Yxc3HXoqW7Sxxs4eHatrBNAWHgId+ZjXxyGHKy1VSyfDQ2idwUrKv09NfB4WafC92CChh98YQGgtk3z6rZYYwMXoeZz0D8+ouOrzZqWHhDEfAdpKrWY+mqU6fE/yrcY+ldb07wiGG5X4myMLDJV9FT7mkegdjojHUkk5jEdutQ1XvwrdrI0FEGW1FrAXTQIUgpqTwJOYZ+1KcT2kJiv+27q9sPL5oogeZBddktSjCsFp/berRmP/jn+al1PzE4dOsD5P3i6yAs9YTl9SrI5pfks6wKci+k/99g92vvzEX/rMcvpIP0HZFctGm/o6pi/+wUhOy4zpZkAeGo3XDXUS160ZniMTSpBN/Sq1bjFzSNN6JyUMWDD7vqJ22XG1srRT1SNpZOfyw3jNYpjBeYekyEb+LmodBcY4Xw3vyMx5ayu7i3bBpmwItqvSkRM6+h8d/RfCp73PQDZnnYsG454oYs/hVmnm6D9L8GuHyY5TzoO9TA5G8DQGmhATL/p2KJILkG/PVKjxyONAnMUaj7WLeQeTRwOL1TwLsqXh3WxCAHjLT0zu7u0zGPNbVBVgZILT3T8sZvhPRWqjO9JT87bodXg+AYHubdvoq3oi2xnzw9yHCq7FJShxzSoyNUG64xHxppMGyCQVuJcw9cfYkaP8TPyw5Cv8qhfQRKmELkVeEUHFj38g3G/y0n2qrB2wckvpH/AuYjrDafm73BCsXjoBr0
 4IsEVGk7
 JQ8DXAnap8IG/b/q8rSy9ZrpJvagajHg3LpYpBNJrGYB5aTCqpToKoxlCkgm67bBGkdwVLieFE92LG/KBW/Hm92sCHfJYlTSdmUvDAah1KiSkwJ14pnqm1yKz3lpRj3LV4S9WbQkY5DpcRe3+kykHVq52H+8WtX/LV1UG7ae7oNc4Inra4pguo0HC4mMZ9IAvboOvg28bxIBODgSGpdasGhdhnCj1VaZCTtGEQWSTfTN0IbvtY5zmIVuA3D3/FHMv7Cwp092LLXpfJ/cJlwtJD/w1IGv/3P2utTE1xTfzQksEiseIL6Dsu5YUx9GcwZcdi/0imZzz3ZHUn0hMO6T8SPpdlFkIrK9a+S4qwOJ1D2ESZ/JUQsvh14V12dGwpKCdcTF/ID2D6pF+uyneOVxpN/ttLDR9rqaasPMeqS6TQertmeyLW8rP/2eAFPM0W96szR59gbOvyrJUCmwF9gQLW505NMu+nTrzyvLv1zr1GgmsKi44aFzaHGARaKTI+J8CkExVIjVoXRYdVbYfEUSdltplkfNB5gA5iyQbrY5t77aAE+PrBtuWMTk1iRPXv6ezFJpmNruB6kmNZUiGY4Lmfj6z3xOXo96t+rMDS/VYa2BayS/JfqyEqvzNgJNw1+pfhknw28MOD8dqifMhC9kYTa8/dQt/64YmkqQsqU5gmvqPs0HLuzyf5Qfk/p7XFclwPQfKjncXRDKlhh1IRjJ+KJqMVxn0aCXXUi5TqSvx5dHFVYfesPbymRSr1+uIk0EEbkzbk1rF1wAHJ2sGcN/8I+R7fOGWMp2X5kLw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:21AM +0000, Matthew Wilcox (Oracle) wrote:
> Remove conversions from folio to page and folio to slab.  This is
> preparation for separately allocated struct slab from struct page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

