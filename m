Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41E2CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 13:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64CE76B00CC; Wed, 20 Aug 2025 09:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDB16B00CD; Wed, 20 Aug 2025 09:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F126B00CF; Wed, 20 Aug 2025 09:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37A5E6B00CC
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:24:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B13AB8390E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:24:24 +0000 (UTC)
X-FDA: 83797204848.09.7EE7F77
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C1F8C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:24:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="PPP/C/bI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V4y1MqM8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755696261; a=rsa-sha256;
	cv=pass;
	b=xizrTLqcUuSJtYAlU5zYgEbjTEBhux0gOf/wI2A6fmRb5j24A8L3jyHdb+csJHMyerNbO0
	pXjOqUTwFHz0JRIWB8dN6tnxAJZZfsmJ+BoMe21qTA9XxhxMVqu8D1wOzuVDXYdwZAs+jZ
	Jf2qlW7iqiKmFn3gctaDT2ehGpJIGIM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="PPP/C/bI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V4y1MqM8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755696261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqMzOAHphBJG5Y8GJsZ3ePdTGnccAFK1VW649griJi4=;
	b=y190C5QALSei4Rfk+Cz4MxOIxpWawA2NJJGQQ7IpOaTaObsVF1xu7BOgeF6Q0FB4P6TU+S
	sGxNxogkCTaw7GLxRSzPTEgxvNezGMQudgmAs6RY5JgaY8/wPXYTOUVTltzQb0+zFjJCj1
	UlqXIwbtOxduP94wUN9Z5eVmv+s/Vzk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57KCKvAg019181;
	Wed, 20 Aug 2025 13:23:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rqMzOAHphBJG5Y8GJs
	Z3ePdTGnccAFK1VW649griJi4=; b=PPP/C/bIafdzjluONgTgBGM/H9DFqchAym
	z4v6BsAP5U/jySf3oe+RjSaWZkhGh1oYdWugR9+U41zsIx+YpcYPqfy/ZXhSccvf
	W/NO3lZfhzz3aE67WgmRifCYufqXmn6ejWmEQbNobRtzhJDEuyHona3UPjt2LnZk
	hKB6OazaSLSidfxWOc6shk9Il+DmUg2CCfrsuZe36JGjfrF7J4xUuQ9NhDmJtDf8
	mUHKz1jPeEkwi0tvzSbX7nXVHNRtgNN9z7juaJPc0tRX4kqOz7ZubSOw3uwspExE
	r5/JTYdXzjviPhz5a2yxX4smqcN4gS/9zUK+BXlx+dXP+VAxVx5Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tth852-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 13:23:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57KD5qTr007107;
	Wed, 20 Aug 2025 13:23:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3qry5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 13:23:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WXkO6F8xWXg3fdC0Z/NEnU2Rnd1NhfHJLTA+Za0wuNAMclKsSfKNBKq2reDy3tYkcaO98/i3a5MHdYTTj0gWWy91HNUhlBP9mqBwyoDveUZxw8Zg1EPUuYPcRZvUQYDCMQjIv5idrb0hbApergR3F47v8Ar1aTMlDCuaVQb8rcLvCR8msX3UwB1gIHS7mW3Hju/VpXq7wAU3E73W8yHpMEYkKOj/PUnpbHQ/dh1ox7IDcOc4H6SiwiZ0Qp2plFmqq9MEDfXb/hoffVwUKQlZWYvdbfKNOXTqumaC1IMBGFJtSK4bJUHriaPrlNky9ptUcm98cRt9d/oiKJxKYJNTEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqMzOAHphBJG5Y8GJsZ3ePdTGnccAFK1VW649griJi4=;
 b=OyMJKYsbbknxpR4BMVQ+hIkYzuNt0i51jmaCxxy1V/sdypgYqqtku8UUQMpw1JCHM70Gb81Gw9qMfnqSDpv5gvG1TvzfA5A0sdE8I//zKoR8WKFgWXMYLrJyvu0kIo4fvoqYmNyFlhz76jfuBS5F/fa4IK18mM77N5dUE4eGTAdgOOflUTpYxsuvLW0a7ESJ9wjS4+pfVSMbLAN3asZdm9pAAnNbkeBtb8lC3R+RGd97UdMuR3gMncrtf6lRVaNFybOcugcJ1lBWcMJthGHpXa/K0M0L/Qm1tyqGwHz7fdc6IINKlMu02CPV1fe0KyUWUc5HswEMgBV87mR/q2KRRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqMzOAHphBJG5Y8GJsZ3ePdTGnccAFK1VW649griJi4=;
 b=V4y1MqM80I6xOAWm2V7nvTc45yMbM/w60ajONAmiQbHY90OndpOgNO6PS3sX9FUkPHFRi2MeHmVCREjvOEbNd1e36tF4Yb9Wp8OAVd7iHB581IpYQw2mRnMnkPocK/ksjnrYaAWpe7FRjFGBHnhC2vtNw1gpQcDD40/1iIxeoW8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO6PR10MB5586.namprd10.prod.outlook.com (2603:10b6:303:145::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 13:23:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 13:23:12 +0000
Date: Wed, 20 Aug 2025 14:23:09 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate
 for mTHP support
Message-ID: <cd4dd743-679f-4c55-9635-6d32e6fa5ff7@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-4-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-4-npache@redhat.com>
X-ClientProxiedBy: LO4P265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO6PR10MB5586:EE_
X-MS-Office365-Filtering-Correlation-Id: 21d02a26-7a3b-4c2e-4e20-08dddfecb63c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5uzmfWw7w3kK/sS/voKAxTKH4kqhU3SvV1wLEGOom+nnbs6d/cFp+etUcluM?=
 =?us-ascii?Q?eyjGiKsOrF9oO7fcPmoOMLvm5PIBOoH6hNkzh8JIQIZ1PzMiRPLDL0MdZCIf?=
 =?us-ascii?Q?DwSRJyDb5o3Pp6/7vLhUqJccaysoCnY66oqYRqO4SZDQwEWmROf9UQ/XGfJV?=
 =?us-ascii?Q?HEMk0cc/E6rPhDHVIMsnTDG4A7qQ2ZsJTiEMUV9W1jXHpVe00iMtGuF+sksN?=
 =?us-ascii?Q?06FVFwlJQsm4ADWBolmojBzBOiL6CKSyb+yv4TZtC6eZY/NtErJg+2wofNEJ?=
 =?us-ascii?Q?v2xSGXfFPlK3WZn29irm8scXJEi6DLS+cVkATlzNnun+wsxG6mC7OCfx/r1J?=
 =?us-ascii?Q?n5j/UBOfW6v4jC3mNt14JuTHdIeFEW3kpVTpLdCZMMiboVaDu4MDcbWAOYZA?=
 =?us-ascii?Q?nGnxUBMgbZ9BFh3QlAiHcWmOoObBEoDIbPSpqsv0e9ngPmqn4oLQa9v+f8Jq?=
 =?us-ascii?Q?jBD1ySnf74itDjY00kOaCAYQ/inKxeMMm2LOQiIVjsR1WidgC4uQcFjEe8Qs?=
 =?us-ascii?Q?iwqNu+jqzf568V6ufY4XC3kOxNuwC4L9yWuCbx3js0oTarQ5L3//gfQIIj4A?=
 =?us-ascii?Q?YryqubdtNnewA/LUm+HJYOGRR6cDZge2JTRwF6c05EYKyE0zcbqWVCbkW9EF?=
 =?us-ascii?Q?M9qznH0n7G1Yv6TVLHzg+1GJG80vExOUt/w6XGMbM1XUYqUhl0w01nColrv2?=
 =?us-ascii?Q?VAN+wj2cEuWCjoVwRSXEIrKBzSnJy1AxvN79BzPxsjFb+ZNL2PEbvj1X3ry8?=
 =?us-ascii?Q?OG8cMRvs7wLFqGphWtRjAs1fVJCgY7/ixWURKi8sv2tJQKJhAXqQpjnF7JNx?=
 =?us-ascii?Q?5nLr3jhsEMlIyYJBsK59GeFvWsrzDY4nv5OeC341xk8OCD5keUD5oabsZ+Oj?=
 =?us-ascii?Q?2umt6wnn0jS03cRilEKA6gV0OD5j2+95har4K7Ql3TYmxtF2LEnzxwPee3BJ?=
 =?us-ascii?Q?xVoZliMIE3zAOtCYNhd1eac/kdndU7nXmAMOx/6fXInp5+J/qlMxRLRYur2a?=
 =?us-ascii?Q?EBkUYv0g1S7ctW+ennW9B8uVyylMRNudb/dfy1hx+PTeCaAMIiEFaEOy9JGP?=
 =?us-ascii?Q?/DyB6nh5MIVKnI1AAy2ahWblYU/VuMgCVqIdG3J94ahuhhPwo2rRdp+JXGvo?=
 =?us-ascii?Q?5m5HpiBS+By3DEagRikJICTBT75o2hr0T2LXd6ewgVylwwFwGPUSvDoA2xmC?=
 =?us-ascii?Q?6P/Nq2BIFZ/3zdTx6uARr63D814IWNr0u3A3KZOeYOUgcYKn8s+FA2aqWEdc?=
 =?us-ascii?Q?NgPKuKreiiTewtsDJC0dUbL+/6+QZGWKdBeXak+ViGgTVVOzU5scdp3MHQHa?=
 =?us-ascii?Q?cv4Q3Ci2jLurksCmbfNaImjjZqKjtjGBzjZdGhJgzp6KIZXG0XfAgiGLl/06?=
 =?us-ascii?Q?0x9+qjACXqjHhI37VXYr9gggfpzaGrfwn76H5Xhl0zww/SqFUBfzVuRAVLsG?=
 =?us-ascii?Q?F3JXJ0axDFc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9+V08R6xYPUGolLK0g9BIosrcUB68soDK0JXRKG8K2O6DyElcFGx+g9C9/u9?=
 =?us-ascii?Q?+GDOzNmVYUpT2pKYvbAyouamwMBZUDp7Himn0325uRtnTnT0X9Yq61in7w7n?=
 =?us-ascii?Q?0s5XNdLmkuh6VxCykyzgfQwnFXzRZvlco+WQZvYkQKHNegZ5pQMC4Mcbr0gc?=
 =?us-ascii?Q?2+pvsCKHe8P1EN8dVRNhDwD+JgoB7BkjjcwxLjK2RGrzrrmEVnRqDPaGqj68?=
 =?us-ascii?Q?C9GCOLv9Yxb/1MYTFQuwMb0ui2BOy6ImxKyeKN3pD+emzzlUM/lra/A//S5I?=
 =?us-ascii?Q?2jjxMIrD4ZjT0tvjqYBMVlI2MLFYZ9WA/zEuFC6RUDTCMElOecPDXYruvvgc?=
 =?us-ascii?Q?m9UtLX2MwdH3K3gmDpoXEBhJ9Fncx6Wt5bF6EGNqAhDRmeifZRm7RWHZpFc2?=
 =?us-ascii?Q?w6fVMSmnY2LDYcDdwf77JxbCcL2nL0n1S6sKoxeHpf86V0639JNfvt9BIYNv?=
 =?us-ascii?Q?QmX1PzZAzUs0vOB4chLrIl/vwQPpt2ePKAluY23YZ8bTaCfuxUNVcqSczeW2?=
 =?us-ascii?Q?12RizGz4ISxNcPmbYdArpCwNpmDj2kFJ8AwVyDxBu/QsW+NpkaJOV/DQw5Lh?=
 =?us-ascii?Q?pGmTvwCDZmdsU30MxVGwFta6UkFLlhZ9Kjiiha7gxvVSzqVVFddfXKTt+vgc?=
 =?us-ascii?Q?wjPXUZGLTJzcWU5jVtBbuHiolcIXByGijX9Y4uS0rMBrI9vshA3Dx/sPRyqt?=
 =?us-ascii?Q?dUQv5cc7uPb8GoekvSgXcuwXPGq/K6vVgfEu6xa7knmriTpeVjPVdRfpTRij?=
 =?us-ascii?Q?VIm9ak7v/mp5h7+UJgogTjA+vRhpTJqY/rR0DkOeCsJS4LKSgtsg8LSY4Sh9?=
 =?us-ascii?Q?HWr12T3WI13N3tEg/P8E7w+c//vqtGcltulODHzEEh4S1aQ6Amdtzl2HrgcB?=
 =?us-ascii?Q?xUEfpt0bFUC7C/YldJptFeuH69cgi9BDEIkEF1Hz/QScjIpxKzaRDSQzHCv5?=
 =?us-ascii?Q?P26VKuKpfxgom8IvoUTn5s/TdoWheYyvz1Fdik0yXT1nMeR7G45y0pKw0MtS?=
 =?us-ascii?Q?Bt8pHzjts41Zs45ZjFLAGNp0zAsJtRXuMFpirjeaSiE+gYdfQQlasEPK327K?=
 =?us-ascii?Q?SbZzULPUWjMXASZwbiUtdNgabgyazxjZzi3QYaWRHhTyK7kyebAmyuDJopiL?=
 =?us-ascii?Q?B/XYXpfC1jQ3f+Ar1Da0gDJ/fXSx81JCb5j8+8W6WIWg+2qWN80tI8GOLCBl?=
 =?us-ascii?Q?oSI43aGFx4/iDxbcy/qXiIhpSiTVdzFOqVWmxen+541t3MToTQ1GZqhDtk61?=
 =?us-ascii?Q?8uYs/rQ1HIdLMbMb7tBH97RjnSU8fX5qVOXuCFllsfCi/8IOrMSlROzPFyFH?=
 =?us-ascii?Q?fhOxYRZFnsFGq+dAk7Sx8moxn7X54a4GqHGVs1PBnkCYFRuJSApf6PdCAJey?=
 =?us-ascii?Q?KrBKLGftABYSJ+ljL0k6cxeCOmICCME0Lqkxr9gG2Hvgsl8k/8XCEQpqe5PY?=
 =?us-ascii?Q?YOrc3FFoyi80kspkuox5D5QrlXNu0HHc52QBzFKy+zfN7UQ9ZCjFsQEqiUjE?=
 =?us-ascii?Q?2rBatb405LyLX4pBokeMNE0DpWo6HGK8jRIomFpppZA+994kNEb55esRiCQ/?=
 =?us-ascii?Q?eObpIIbM3vPXeDRkYmGb4KsbfyV/CUpazDLZ8IWfcSgL3XziMNMvbwif1bT+?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z4nSpGnnSiBeSO+boQE9B4235fZwBGkpBtzZxKxAXPk5XUrrNfQx+Le/OOzCM/L8YRNBdpPCgjIcDyt2J4vcr/EjapDrlr63pejZwlLVEe2Cf4B9sGrKUXxlDvoFcxttBzrUwef4u1deW1INmJTaIuinA1ybpE7DCInjFIPv7GRuGUW/mlF4gJCJGul2wjTCzFCib4XtcnbS7/dGfwbHS0agF5FdqNdVRuSg7Wk5kEVDD6tbpbu84E0XvySFAa40oMvHeE8VV0045NebvgZw0BQ/zXcNXxd85slWUGWCZRXOxX6V0le2PUmy2y47HyUnwQ4tLIr+mrm3WguE0faa94zDG4ElqYdHW2he5tkgfLupH+ekQGYPytupEQ5TnDsgTDda5afJ/atheiaOol0l7GO6xXXbyKnt2RghZXSCmsBkn+WyrnAmq64DUyDOeG8lU68zi6mz84T8FwbCQTLFEUdT/cyDiJbXf8A8/+aV/6VsUZWTLdFLU1fsc/lEAuNO33SaDxDlCDMz/LZ0FHuAYmmPlXVIbp4IyiD66iS9JWEKa0YtyZXMdHPg9LcFATTSZvZLjheSwJcHZmvEKpoFxnKj3NHt4hlryB614kJAAQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d02a26-7a3b-4c2e-4e20-08dddfecb63c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 13:23:12.0055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gM1nxFWFHA8JzvPrnd7zkDYMjGjInZbc+sz/3IpOnZKppM0tWqbAYoZrt2CX4iGm1i8iyoV84if31zt3EtUvUiq9b161NNvWkxmQNcHQv9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_04,2025-08-20_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXw4KuWRmVqdoe
 a7TKGfYt8g025cgaibinMrWBTo+BEVzX93Jnxj0q90C7Poeudbeo0fuPb/Y9BrYM2txbvlMBBP7
 zeVhC4ZTA1UsOtb+b6n7LIS0liLvCHneOfO9E3D49WZTjBdmvOwfuDynf6Q0fbU+A6tCEbZixsT
 KvDnpWQM3L6KrGKp1evVegDhZOHLrm2tq77ia4euBFyWRDvOju/OCDv/1ioKMOhg0l0DIP0S5AN
 Uq0KcTZKiDk9dzlaDPbjkrMlpWaqeluC37JKvT353LFMbrmkK+jLoZjeM2x+1zVqJwRNis88Q+y
 l3xkezrSOSqiKRhnlTCRu2qI6fafJD1nn9fYxnFkiYAIM9wBUlzFkLun2TH+ByrOZOiM1CQ2LHN
 n0zJqktwWJMLf6cNsicHJ3ePscO1yw==
X-Proofpoint-GUID: p60mFRG9gUn27yU-4505j01t-_ZfwPzV
X-Proofpoint-ORIG-GUID: p60mFRG9gUn27yU-4505j01t-_ZfwPzV
X-Authority-Analysis: v=2.4 cv=V94kEeni c=1 sm=1 tr=0 ts=68a5cc51 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8
 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8 a=C31ckisCZls3i61GkwoA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 4C1F8C0007
X-Stat-Signature: h1mktnkurpmt7afic3f4pdxtuiu4pz5m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755696261-951898
X-HE-Meta: U2FsdGVkX1+6iUdeBpD12X8nsMgQXqm9Tp7zTwnKVC3u1iakHTMYXbpWsfHC9F8FDdTAKm1Eda5Zq2JIKoY14Li2o3F9fxbulo2auqdvaTQdOUlQFK2cMJXFCdEY7Iho1P9EUVrdx1LxXoREH7zbnur/yIz6ETPE8GFiiMSDmcDR32cA40Nl+fqQnGls+fSKTc0N50N2/Jky4EXD09F8ZVa1v1cvdh+/G9d7dsCc6zdR2rDW15fkXjkreF9mcVVqD2qx7E2eHgSFfYFf7W0C2LihJ1lhGzco+aWJ+Np4YHo2aAbYuFZfXARZPlJsnxx+M/fleEFB0cusZOGZ51JdG1nQRHW0hfYOS3MaoWqPTfA/FkuPJnX4ujMZMK3aCMvxbvS4dyiKMhkNDsicMXleWTfn8YBJwM8PWghQ/Wz8Za8CBFGoo+ph4mRFfj0SGUjC9hnHgqbMVnS1rF75Yu+ivDqiCSSFr94wNuXfAEDDDXRc0xGarxTsibEW6jcVIAntyrzKSVwGKoLwOZ/qgEjp6Wjb9pBiibBHioESQOOffhlLolxumjTAc5z9GQcqctxHX2BaQusxqyZY1A0PuCo5cZ+AXXhK8X0BIdKywQQnIUtY+uKsFnjS7Eb1LEUt2D91KRgQh3lLPAn6kEBxoaXc90ykPwK6h9ID3sbUw/0YJdezL9lVuWLNIBA8pgLTOZPff4uIH/fFX2zhZZ85G5vvQeqICfaT6dwSGR9Mn5xZQFOmqBbpbBa3aP7HbAefEyFx2MUEjWENknJWIs11+c7frt6xIWO2PZPHFmBNeW0PXfesy52CTYOrriEGTI47Nny7EE7jVUkbl/kqyyMLTbSmj79D5cbYwlNUqrMAvgmjUPlTiJcDwqnjDBN902HsXNw3YLk5bhicX86ZHrsq5R/QkNirt8udbqvjB2gUC7Gm5MKhV1AAU58E8ynWURvDkskZsF23pOfbDeB/wEKvYmG
 br/Ce7bU
 W60tOETZBl5ZxZ2xZz3V4mebmabGx276rUrsj0dNP6rh9fjeonix0pzo6pzJH6VMHaD2X+6LKWpMXRGQDEi9QM90J4cS9BbWnk1ou3yr0euu3dUR0PEhAfF9bFyyc9IW5VTR2pQyfI79+Y+d31bbrOZmSTJ9/pD9i2pOXlWW1b3iCvkl5+N3fzjWSJUtWGPWzn+Xl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:41:55AM -0600, Nico Pache wrote:
> For khugepaged to support different mTHP orders, we must generalize this
> to check if the PMD is not shared by another VMA and the order is enabled.
>
> To ensure madvise_collapse can support working on mTHP orders without the
> PMD order enabled, we need to convert hugepage_vma_revalidate to take a
> bitmap of orders.
>
> No functional change in this patch.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

LGTM (modulo nit/query below) so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b7b98aebb670..2d192ec961d2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -917,7 +917,7 @@ static int collapse_find_target_node(struct collapse_control *cc)
>  static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  				   bool expect_anon,
>  				   struct vm_area_struct **vmap,
> -				   struct collapse_control *cc)
> +				   struct collapse_control *cc, unsigned long orders)
>  {
>  	struct vm_area_struct *vma;
>  	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
> @@ -930,9 +930,10 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  	if (!vma)
>  		return SCAN_VMA_NULL;
>
> +	/* Always check the PMD order to insure its not shared by another VMA */

NIT: ensure not insure.

>  	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>  		return SCAN_ADDRESS_RANGE;
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
> +	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders))
>  		return SCAN_VMA_CHECK;
>  	/*
>  	 * Anon VMA expected, the address may be unmapped then
> @@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> +					 BIT(HPAGE_PMD_ORDER));

Shouldn't this be PMD order? Seems equivalent.

>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
> @@ -1168,7 +1170,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> +					 BIT(HPAGE_PMD_ORDER));
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
> @@ -2807,7 +2810,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			mmap_read_lock(mm);
>  			mmap_locked = true;
>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
> -							 cc);
> +							 cc, BIT(HPAGE_PMD_ORDER));
>  			if (result  != SCAN_SUCCEED) {
>  				last_fail = result;
>  				goto out_nolock;
> --
> 2.50.1
>

