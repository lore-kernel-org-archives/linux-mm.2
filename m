Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A62BBCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 05:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1668E000A; Thu, 25 Sep 2025 01:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62388E0001; Thu, 25 Sep 2025 01:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29988E000A; Thu, 25 Sep 2025 01:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6BE58E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:26:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 613FA1602E4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:26:20 +0000 (UTC)
X-FDA: 83926636920.07.73CBFB0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id D29ABA0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:26:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EsvBAFuB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=srZbGWu0;
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758777977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnJxe2aMQM0s8zysfImpPuGjrQdJsXqMm7TryRNJxqM=;
	b=mAQFUr+RHM2YJCiNTG6MG2A+rKBvSqlv5NwglyAsd91Tggpwxb3G3+9iNGif+zQmmsBoqO
	5vMOqsQaSjAMkykNG6lC5mluqBwWpUI3xZAb132HgAi8tdXCT1HfOaMRmZCg71QpdKefV8
	tPYn7IouBGc0Alf6J9Wh3LYC/Fwa+sw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EsvBAFuB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=srZbGWu0;
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758777977; a=rsa-sha256;
	cv=pass;
	b=CUUFDiudaitp0bEF/REnjVhaTkMdICeWPDi78kzrXFyyCrfRXvXl6JZdI/uAqD2ufVBnQ9
	I2s+sBEhJ0zIXstVomkJagu18T7byql/DCdifS4e//o/LPpTDRdXSLhI59LZ5tof1Favnq
	QYCNjZrXI/PFtcPcEELgYYvNLE4NNOY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58P4BwBB013741;
	Thu, 25 Sep 2025 05:25:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UnJxe2aMQM0s8zysfI
	mpPuGjrQdJsXqMm7TryRNJxqM=; b=EsvBAFuBPnKmo4f684GI2otn/73LYeNyja
	20yLyXE2IZNsN6mZ8N/KvxHvjZflGbsa5/z2fAArhBhFtl9+Jg6LGbcSEEUp5rFG
	i5V8XWQRBjAL0cfMq02sdZUuoyB1EQkb/Mb1Ozf5O7MlKm7/MdG5+TGHL0uk7ESi
	m0MrX6ALtmRhIyCQ2Zhuv4aSHzAt6GxcqAiA9Px8+e22QF9+wKjuOz5INnXYVQkS
	3k8SjEiJm4Zv2bFLA5TjT4jUc5a1VsmVG83QwzH1T9YmE1lTYEwBqp0Mw7+UJK/d
	h8BPDDLQXXC5qRriHgE5wlUaWmDfx48likbzXBsSuBFzmsj4E/bA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499jv19apx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 05:25:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P5PCEL010739;
	Thu, 25 Sep 2025 05:25:34 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49a6nn0pb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 05:25:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=blox0y+l+igpJl7jNOmZHmcfOagzIzQPYYYdcREuvJKNW+1zuHMIQwbULSMwBFE2FH4zgZyYFj+1MqnJSniPBul/8JSbHWFTobDOw4DqPhizHMomAfkkm/f2SwNgPjDNZJg9ySc38JqNriiRMZsGTvi93Mu17b95l/seUn6QVbqeCvANsUjlFEiSktoKJlvjC6Icy30oqYaDsZXC/cubFAXMyhd7GsnzSNdk4u+6CXUZsCA7N0EHX/Wc0ltfm6eMJ1ngLPev5J5ie7dcggaAWXoSUR87eQ1QZv3HKd5qNk+gZXT4AlyXmo+fJ+8WGfIsMzX1QAVLGrN1Vc1WTwXDVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnJxe2aMQM0s8zysfImpPuGjrQdJsXqMm7TryRNJxqM=;
 b=Bl98K71boZhgdDXaFW23xCcAkPfBi0jpQdK03xgRR6lu2KsRMym7UFSe43iiRzoRm9LzToqUkNffEZku47NiV20Wg5ckHqo9Gt1dE7XY7ZvksUN0l9QcRUAQqqM1eLMEn5t3J4Y/CKrhBnaMPDbvlsWlRwGW50UWhlI0D/AN85gjvcRCx+aHQi2YAryCLr0AC0BZmU3J3+9IJ61cNh2k33ANUaBEW0mT/w6ReRyGwtPuYaUWInS07rTsFyZB0Ep2n3UXoHGtAzfNBgp3OmWBaogLBr5KqgeRwJVNI2TQU1QdTsSx1tjQMygVX/4jMMzEF6YhLyR/McG1kXMISZ+akA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnJxe2aMQM0s8zysfImpPuGjrQdJsXqMm7TryRNJxqM=;
 b=srZbGWu0rlrQUbNnNcjRZnCZ+UREBNVzF5itUZgcpsMvsC39DXRJy1ffWnxZZRKTqn4KlvALb1KWRhWVQKT6pxhYZ17frtGgHRt9iEoNN0gQi/c4im1a7HEyRKwjlzmI+j1swGBBuNQ0nZcs6+dY8DyZ1ETiYTQCThjk3fbsEtw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA3PR10MB8757.namprd10.prod.outlook.com (2603:10b6:208:57a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 25 Sep
 2025 05:25:31 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 05:25:31 +0000
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-11-ankur.a.arora@oracle.com>
 <5ec85b0b-9848-4cee-98f4-37953d504773@redhat.com>
 <87y0q4ewzf.fsf@oracle.com>
 <6743ead5-4d61-4274-a24f-13a8a8265aee@redhat.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 10/16] mm: define clear_pages(), clear_user_pages()
In-reply-to: <6743ead5-4d61-4274-a24f-13a8a8265aee@redhat.com>
Date: Wed, 24 Sep 2025 22:25:29 -0700
Message-ID: <87frcbayt2.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0022.namprd21.prod.outlook.com
 (2603:10b6:302:1::35) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA3PR10MB8757:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a5bb2f0-1587-49d9-a65c-08ddfbf3f1ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kG4fMvaTL7Dddp5nHC40Je/kUYik+AuVhekCJ2BACNKcB0n2Xg125nErtQxK?=
 =?us-ascii?Q?oDv0wJfyVIDxgxSUn46UPePN7YhTSfXBqbbvYdDFgfK31S43Vi9g/79NZA32?=
 =?us-ascii?Q?uYNDXOUbTmvqlIWw3V/S5UcmG4iSQqpZ/PFz65sseXioIElEnb7yDcDLCAbI?=
 =?us-ascii?Q?Xuvnj7v+NeZMSJiPGAEm8vDcsk3jURMudaBDayAad6KhrNRp4Tb05039XX1G?=
 =?us-ascii?Q?yRI3jceYm2KXIJVnHg5etTJy5GhPvZSVjM+2rIAKlFAmLhX2u+cjPUIbb3fu?=
 =?us-ascii?Q?ta70epv+FFtTudp0IS1+47qHvKltN/Arhd9Bw4jSmaxnX8w1hrMA7ljrDA4y?=
 =?us-ascii?Q?/P1VP/iVAK2owbZibiRHgL/MLOpWVgrd+8so/CMj7kvc6e2sOKRcbBaTR7eB?=
 =?us-ascii?Q?Sf70zbGGwgexWE04IRID2hZKLmOdZavfZYKAu1GJ65gpC072RFVXyvmfKuhg?=
 =?us-ascii?Q?jVaiHLvoKlxOJyfHTk78rpyXF/Ctv5XFCQGuXOX9iBcLk+G6u4VzyuAuVaa9?=
 =?us-ascii?Q?nCGN1EkDITE7WRopYVdjdjlE5I5qY9yECdh/5H8FMKnqz959PIzNEouT7E1c?=
 =?us-ascii?Q?qfd+nF+Dk9/sGYFLwyWPqBLVSmh3Pzaab8G8gK8jNlJ2plqiKtPyny1tWt+r?=
 =?us-ascii?Q?fdXnfrM6bzWvKs27Hx8JugG90Any3K/WKHkAUVVN3wxqqfThjBDA4ia41Gv+?=
 =?us-ascii?Q?wseJspI7SYXHgmm+64HWJINRDIxhGTqtapr/GxKJZF7X8/rY7Ds8hK6eb3jC?=
 =?us-ascii?Q?UXuhoNyWLnVz0q0mPizxOXz5oJnfx7p7pWRiGQLdaHGJmFViNE1TuDm3G5r7?=
 =?us-ascii?Q?P10QI0VSnphYksdHH84FaZYrrLNOEv3KkoySwfbtIDVUW0VnYa3VXhwvW8rh?=
 =?us-ascii?Q?kKbU9jV9uieOQE0eoFHatkJfwTRSnjiRYyrp8BLrZ6oWtjJisTUaS3DZCQ39?=
 =?us-ascii?Q?m2nVYsiqQNScFg7IHP4OAyHM73AKz5DZ51d7m9oR59RpmuPgfevvnaAqdTOV?=
 =?us-ascii?Q?VLhWaMrIuMj+IWSn/I2jOWNm7OP6/0R4Fu/WeabVukfkTwx7rfNkaCllSXl2?=
 =?us-ascii?Q?Bh4low9Yj4UHUj6k/aY2svILP4iHOkTzkqQEBPBeMl9/rFLXssjaNr9bM9qV?=
 =?us-ascii?Q?GOKRYh+q38SQVN/fjDpH+juK74/uVM0N66VGacCDe82iieIXF0IsWDgP4ybV?=
 =?us-ascii?Q?1xu5P+STH9q5KkvZfXYC7G04sEzfixruWl00nVX1eKL4iS3wC2Y65jKBl7iN?=
 =?us-ascii?Q?Y0RV7asFNQPbUY06mqRedXcO9zmB7u0lQsh+GiKEg97BuxCZmmyieMG3YAcl?=
 =?us-ascii?Q?WXCWPzy4kkzAcvCamR1ihJv5B/3AFqnJZDQM43JhGggmTXnALHKMqp9rVoBO?=
 =?us-ascii?Q?Q2ShSAWbqOFUW+3iycgjEdXJ05+O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aC4ho88xzlIfyDAt/LcOrltagykoegIoMAAwqOB3d8/tFI/e3chE5J9WUpR4?=
 =?us-ascii?Q?fheGA+CpELtUn0BSQ+xphPDhCdNi84SI+IGFyawo8Z2t9zdHaa+2xpU4z+M4?=
 =?us-ascii?Q?b+BLlGOnRMill0W19UFJeGPNV84dD7jA/uqORDpNn3y+5pfcxv+1lSlLC58H?=
 =?us-ascii?Q?EVyAxRooWBr//lVPnSFawAP/5MOihOIn5czb5ZiQjoZgPKzahkkTL/ZRuo5J?=
 =?us-ascii?Q?YIvGelSiQjPs3sil9IgdcPa6YjTEXWQKTT/zIwtXmruqWu10lfk70G11WYhn?=
 =?us-ascii?Q?pPCicEZgatq487CGstxoOdrtdj83LWlips3X2tqLyet8nkt16fGICLE3Ft92?=
 =?us-ascii?Q?rmVVTTnwEPcpQXS1RJBWdGXu7U0zVXqZg3ntN4lNBO3BrhQrkR4YbcG1fqcS?=
 =?us-ascii?Q?reUsvS0Hj8b/nQmQsDLO0+DsyKg6eShap1hIYgMxPcMGfRMzi9EH7MQeLqcA?=
 =?us-ascii?Q?CGXQQS+98J78BBjAQgVkjFTcoc5ZiqeqNQiSTSVjJPr7rvQCeRQkXASVYwbT?=
 =?us-ascii?Q?Yz8iJtRWMdkYEC+Q/LuT5yti6T9iHRUduJmv58abTj5TrEc/3Ckw1+XAnedr?=
 =?us-ascii?Q?wB9mWvYLVuxTEZJuUwObqb0nZzRj+rRCPg6uw5YzskOuyoIFJQmjUupF+3eM?=
 =?us-ascii?Q?4AnXkykV1vxGVahmSYTPm85vbcX9SCJTDOyyjjgdhNg6I9lCHNhXnTK+K49J?=
 =?us-ascii?Q?QiysfJ9/fiOx24bvFdqa+l/bJnt1+4m7OtGZb42xaE+TSnoUXhSS3j3QR+/x?=
 =?us-ascii?Q?p4cHiA4N+M4+H3wNiSZl9rJk158decrVjxawjUFnEUde2Mr21KXh7lkwn3Sh?=
 =?us-ascii?Q?PIJqYhXipYaua4f6OGYJjeqjvYpulp93iQi88Q8uj+Nxz2tOJZXfsUeFiDPK?=
 =?us-ascii?Q?m+wEq9g4jee2b524DN2RMCha8609szimGZ2um6OWyBSl9cPNxhfFX+vaeAq7?=
 =?us-ascii?Q?ROQAxHrrcGJrEc6oa17yVBztiHU4kTH+ewOzauCBp6dCNdxY9RVil+ppt3h3?=
 =?us-ascii?Q?Zh6C1PaiEJycwtZEgcSugdNLkVpKKql4tT5aM2zjnC2WCF/lqJAjob3rIu3o?=
 =?us-ascii?Q?G5+L2GQT1stzrDh465126uoXdtjgZWu8iAId9qG2NucE2VR8/tnnZj/i9rIw?=
 =?us-ascii?Q?jq2NdnM/oC48VBibAJvPvlpPdVbHMM+UNuHetSSnTw5oTRpUD3O62wjc5Cvn?=
 =?us-ascii?Q?I8h48nJZLOlNmBid3AJ5K6rH3mvGrCXkAqoxMQCx9acOPDrmbvI008bTzq0x?=
 =?us-ascii?Q?38kg+lgcJhWefisIKzbvb1+c3Zr9s93LZc55thnDEtgsR0IyTzBKx6evikx0?=
 =?us-ascii?Q?9GWX/jswXOCh1pQ64GjIGqBgkRYzMQeEz7/XKSabmlrarAN7n5JVRMF7zhN9?=
 =?us-ascii?Q?HgPuzpfsbvlnufUe3tmG0tSWI5AqBr9u0aF5TsfhZjjDHG+etxazKcE1O4Pf?=
 =?us-ascii?Q?Q+JzObgb41chlFLqs5gugPxSqyfcubLmayK1HR2B9NhQqsJpkfL8kmA8WN8V?=
 =?us-ascii?Q?de33cnNi1hfYdi3RrZuhDP3AOq1zwuqH7zlPFfXK/IoStAboLzxyo2tG3HWf?=
 =?us-ascii?Q?wcEueaK97twqbNJ8IAOi8KViQXsxOfQ0PasH3gamqp3lMD3FIm+uxIwjFVyP?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RdF8EtbexoQZaWS9I+ef3ULeyOt7w45r0Y6R/l4VF9MOg+sO2N877sscJRFDom2aZ/1qkkhhtAsE5X8U78rAhySCGtrjKGnRQ3PEEt87VCwk7NTCaavHHElfggsqL+uT5/7Kr10VrIpSz0Z3TLHmhRntIByZPjnqiP8zXDXXiNyj1vYhVC1CIEu3kawjc4Yrlb/HlVu9OFvRorapYZIO6WDsyOfa+LjXYAAtpq4kXFq4iyxTj0RUDaDyq6FmVWHsxH/SHatkDDD+cI0lXLjkT0SH41Hzc796rS66tUSylTvaYEHHuQ2vN+Fjny95/a0rLdx9EI3jnVcidBbX78/TzaTIDhQtYmV2vblya+9riytZP3LmwGFaeUVlj+5na1tBg/41EdDFfsVRjXND7QOyMoh6x2m5tjYogtKUBR93vvMBaqr185O+GvQ4eka+o4zpObXy3nyPJrDWoILUnWwN2PGkBehUs6+WanOVwmcXTZACy3q0T85lzdFIAViAt6LnsMR+i6Zw8sH1Si0uPg1Ied35lh7pbHRLaxoUaTHcUJw9POBgKxV2m9C2VWxW+F4rr0wRzhvWQv7R7l+7ZFBVUNBQpbU7tYjuOs21reiTZkU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5bb2f0-1587-49d9-a65c-08ddfbf3f1ba
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 05:25:31.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLQ1ExKnoZ5IJ8PUCd1EfTq4vsvc3gCFfm0Q8tsyIOAkRMF/wD9f1Zvhtpll/AvCtG4r1eBU6W+j66R84E9M6dBT70aFMIplHQCeTM3HDaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250049
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMyBTYWx0ZWRfXx/AqGxms35gv
 ZkX0NmKCUHa8eCSKr9slwoVtHhvOygCDGVcVPPLJy/Yzg0/Tahw0n5MqhPUn5QK4yPAordGJdVo
 Jr8rLh527sjqattfY+Sn6NZeXogwZj5kFMz2VB8GA4Ttkg7STS+VS2Hr5W5fOB7ZQxEVYKFHkPf
 cSVBVO3p9CJHrq2PUiivb8V98G4OySStJYzNjzN+KlRKLxqTJXDW2I2mF+0rWyS8OnOLY0PapcW
 iDmfgdg8sKSA077hWwV8avV3kCaTGCXvESFYYZl7cqGBHKyfthEWthhGwvCElHjBOrlw2661G0b
 whDsryljaxgQsv3lrfG5iygJY/AUwaR9H0tlYLqq4Plx/h04Dy8S3D3tZopvOCG6wtB01Qbbuc+
 yav8HOfzAsq3TNvuY0KvWLgMUKP2bw==
X-Proofpoint-GUID: 0EOkhcHwYKw_V9mvne3NwM8H6tzIP3hm
X-Authority-Analysis: v=2.4 cv=YrMPR5YX c=1 sm=1 tr=0 ts=68d4d24f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=ZxKozcnS16wyfBFpAQIA:9 cc=ntf awl=host:13622
X-Proofpoint-ORIG-GUID: 0EOkhcHwYKw_V9mvne3NwM8H6tzIP3hm
X-Rspamd-Queue-Id: D29ABA0003
X-Stat-Signature: 6qwchjz14fyirwdwjtq5mgk3a8hajjm9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758777976-315541
X-HE-Meta: U2FsdGVkX1/Wg/hRjJ/THXBNr8a5SZS/zqtoPD5Ah/vYjOeyVyUr3BrDiCNb0beqyD1myzF2oy/HqVwSr4NM3DCMrIbRCiDJTGqcGEklY/mSW/qmWMdmwOfAq9ljshO/nCUEGQ5opaT6cSLHRMWsKy8sCBAzHopV93NOFGxmP3stVoqZF+mkbmZP6G0+KhjcGTiovsaJ2rsvS7PWWTEI8vG0vePAE+Htl0B/unwrp7Bd2PLHaAuYMRTN2V/8tUIc9Uqod2Bdj4E9BTJytSjKb3lGT3HjVpm58bAYrM1bN6fIrwxeEANLanEF16t/2tiby80pQ3XRE8YDckNc3mDwiwNC2ZYrqdFYNuvjF9Zz0Dq65iScIV2gMbe3fidE7TcfvF+o9OCeqoUuDBIAJXzA7OZTMUuUPy+xInEGk0eIONG5Ogp9R4zBz1sBIvQ8L/xUayfQU0wAi0FM7fsmxNJQYl+7klsGtA1eCQeh1ratcSBCPT+vqwp7FQQgy/pjI5+GuxksvAmS121NSjaHs3b2ur3Gd6KUlIUJFsxVeal0qDqrCy+OdLQYjjeWSUAS7+r0j8D1w2ZlO5PsrFAMn4fAo9r6wJ6W8ipc5bZ1bPhxDD/cKyxBhzP5S3CLGFHPKjEeIz3xFdzTVNsyhoHx5YoAHXrRSAjfDT9kz6F6iZWJTCTRt0/8FyA03RmpAm5b/Vx15BZQ0IrQK+ZGHdO7gsup1qTkj6BDpfCon+OgV2rU6nVZg8vbgk/EkrwZ4NOl9GPbwExstQB8llPUFgMtal5sOwxGftxNaCjCwm6HEDZC8XYMPwc6+l8wOCB8qlPF0LpoHN7sX6AhG/Hru7f8Y5y/gO0VvY6wHUKusMWGRq0rh7NYsmD7ULhpQxUfXFD+NlJ4yjGoCEnD/jQcLKn1xH/GNcJFadsaXDzJA3b8sKlt2/1FoMKzepJocUJzTyvkzRGM/m4t/tRO0rThLeMIRYB
 Cu1YbnJo
 fOnOXKZo/JG1wK6CaN3ER6ZxJPgwJzN+7WZ2mt/SW57Up2uIijLltJWyB7FyEGsTwOVU1XUtkoq29SEftv4gB2nFZxcmzkxAz2eXjQrbAExc1G5H98rVyFHCpqtlVffDMtX2WzQeHiZl3+3/sqljgHWkzG9J1W6HxWn4iD2z9M9sqMNazUHWt3BK8KIWtBKUW2lXm9T2FL6Vjq465bvSF1tzXRGc4LXe9HvRnKkn/n5gk4qJ5CchQ8IVM/0SVHSzjMmlojMxn3bfS0sx3wEi0u1k27In945NE9uDc8lu47t3BIRZwfvy1/rmluB9TdKeDBBOr7UKejC8xvGgzMFiWmZTG5osYtux5juD6peS7uaOUlWOLgIs21ffMt0Wq5GbZlgJfgz8f4u2BHd56bQwBRJKNhFNjYn47C8WvTKKEOJaTe4eFeOJikP8GnfyLlxyxuWUXxyf8fDO6xo/NTO9rlBY6OOuKC0saS+AQ7CgQm2SoMZrqDXD8DwCJxePUmDM4pGipjmLJz+ODic8jowozEZoEQ+cMfaYeoOIvJp2NdLmWFe8ZuOctVDqD2hkg4IniaZmdf222dF4S786GbwP0xC4GEVWvy8lAcBRu+Ww1qVZAaEtMJLI6EAETsd6DxWw8z9VxmSJvntPZ9Wp2PTESpxXscKOm09c1sIJnon/cqqDg0P/LCFJngujCWjvpkgCZRxF+5TbLqI6vMg0ykmBVyBoE115I/vGpPK8p9Mzq1odH6Mplq2MBP69lerE/vscf47rMhhiV14aVYMmSeEh9lMka8Y4JhNNjqiRQmjB1//fcI08BwXHOzk5sMqkWxS47PIYzCH0MQy60QAV8pbrKjiPXOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand <david@redhat.com> writes:

> On 23.09.25 22:26, Ankur Arora wrote:
>> David Hildenbrand <david@redhat.com> writes:
>>
>>> On 17.09.25 17:24, Ankur Arora wrote:
>>>> Define fallback versions of clear_pages(), clear_user_pages().
>>>> In absence of architectural primitives, we just clear pages
>>>> sequentially.
>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>> ---
>>>>    include/linux/mm.h | 38 ++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 38 insertions(+)
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 1ae97a0b8ec7..0cde9b01da5e 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -3768,6 +3768,44 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>>>    				unsigned int order) {}
>>>>    #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>>    +#ifndef clear_pages
>>>> +/**
>>>> + * clear_pages() - clear a page range using a kernel virtual address.
>>>
>>> I'd just call this "clear a page range for kernel-internal use"
>>>
>>>> + * @addr: start address
>>>> + * @npages: number of pages
>>>> + *
>>>> + * Assumes that (@addr, +@npages) references a kernel region.
>>>
>>> And say here simply that "Use clear_user_pages() instead for clearing a page
>>> range to be mapped to user space".
>> So, comments that actually speak to the use instead of technically
>> correct but unhelpful generalities :). Thanks, good lesson.
>>
>>>> + * Does absolutely no exception handling.
>>>> + */
>>>> +static inline void clear_pages(void *addr, unsigned int npages)
>>>> +{
>>>> +	do {
>>>> +		clear_page(addr);
>>>> +		addr += PAGE_SIZE;
>>>> +	} while (--npages);
>>>> +}
>>>> +#endif
>>>> +
>>>> +#ifndef clear_user_pages
>>>> +/**
>>>> + * clear_user_pages() - clear a page range mapped by the user.
>>>
>>> I'd call this then "clear a page range to be mapped to user space"
>>>
>>> Because it's usually called before we actually map it and it will properly flush
>>> the dcache if required.
>> Makes sense.
>>
>>>> + * @addr: kernel mapped address
>>>
>>> "start address"
>>>
>>>> + * @vaddr: user mapped address
>>>
>>> "start address of the user mapping" ?
>>>
>>>> + * @pg: start page
>>>
>>> Please just call it "page". I know, clear_user_page() has this weird page vs. pg
>>> thingy, but let's do it better here.
>>>
>>>> + * @npages: number of pages
>>>> + *
>>>> + * Assumes that the region (@addr, +@npages) has been validated
>>>> + * already so this does no exception handling.
>>>> + */
>>>> +#define clear_user_pages(addr, vaddr, pg, npages)	\
>>>> +do {							\
>>>> +	clear_user_page(addr, vaddr, pg);		\
>>>> +	addr += PAGE_SIZE;				\
>>>> +	vaddr += PAGE_SIZE;				\
>>>> +	pg++;						\
>>>> +} while (--npages)
>>>> +#endif
>>>
>>> Should indent with one tab.
>> Will do. Also acking to the ones above.
>>
>>> Any reason this is not a static inline function?
>> Alas yes. Most architecture code defines clear_user_page() as a macro
>> where, if they need a to flush the dcache or otherwise do something
>> special, they need access to some external primitive. And this primitive
>> which might not be visible in contexts that we include this header.
>> For instance this one on sparc:
>>    https://lore.kernel.org/lkml/202509030338.DlQJTxIk-lkp@intel.com/
>> Defining as a macro to get around that. But maybe there's a better
>> way?
>
> Can we just move it to mm/utils.c and not have it be an inline function?

Thanks. Yeah, that's a good place for it.

--
ankur

