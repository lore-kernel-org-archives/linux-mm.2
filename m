Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01CFCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 14:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C692F6B018A; Fri, 22 Aug 2025 10:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18F76B018B; Fri, 22 Aug 2025 10:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93316B018C; Fri, 22 Aug 2025 10:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96E146B018A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:49:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36CC6B7316
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:49:58 +0000 (UTC)
X-FDA: 83804678076.20.6DE9295
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id D8B0C1C0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:49:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B3ehtc6Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=axxL8XUT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755874195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPqtYMxml/yf/9bo655c5nBPqDGutQEGxKRLb+eoZgg=;
	b=bKr/PRe948FJO+N6MbChEMa/z2S/CQkF1u2rjNBWaCe/8Sxoz8Vl0krKce5J5H9YcTPIv6
	E6LNJrfAokQQBFD8KIY0VSn/ew9MIp8E9ZdSeukUXniFNJnsVBzZSAN9obBHiZ8A5pUPeB
	Lhn+Unhy1j6ho1LV7iRz436XNuMn2J0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755874195; a=rsa-sha256;
	cv=pass;
	b=wgrzDiAQ0rQQNsU/ifYdYJhYxbiCj65v338jghFKd/qyMv3qk7DLGZxicvq5tBwL0cD76x
	Fqng2YTODEQp3Dr8+f3JDJakEGiSTDf93xmv70W3ZBwlohMKOVpFV3yyGZpBx9JwLs10YY
	4/OjVUhT/gsplmIZil0LT9y2FX11Nwo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B3ehtc6Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=axxL8XUT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MElV2d001811;
	Fri, 22 Aug 2025 14:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZPqtYMxml/yf/9bo65
	5c5nBPqDGutQEGxKRLb+eoZgg=; b=B3ehtc6Z1mBDMnPRWDfWjrlvEwpC4lcOfp
	JUjZZ0lHWvQ6OXh2pu9HqPQsHC4C+LRvNpprF0OJfe5tzhVoAl0G7U1s5lMFUIEH
	q9E9gK21lN1gRQngtYl1NcvhG8Vc1dyXPUSVgynvvpVqCQwIomc1KUO14zG48fO1
	GB/qy7T631UP75EFriZXe3S/mOWyD9vyCakH6/nULVV3hOJLah9FqsmAvUrdGoFi
	lhdVgU9gKt7sKCMsFW7Md+FytHeh7uN+mPNd7Xd9mMnNAwAUQ4aLSXGYkyvCsEpL
	2oAZR4tsczD2F9SQ8Ux/3Sdh64VJJK6ebkfRs6NhwWXNKoTQV6Ag==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48pabh98h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 14:49:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57MDgqg2007422;
	Fri, 22 Aug 2025 14:49:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3tf7sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 14:49:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jdHUOet5poBShq0TMd5OPQmJqJ1f3Is7v1pCBZ59plxcfa9J8LaHn3Ah6FdhkDHAmC3+myDlK7v6V8ZCHGHBJU2qPVKr/baqMiO9VNGM1/HG3u+dca2tSO6ee1FI2e6Ld0lGureiKiuD/enNOat7kWCWJI9uGVxOXt3HQHZh4Zvr3tk83q1rkJQGMWUwTI5gFViUd8krCLaxiUPV4znmuEvtwZHW+GCEb4uznpjfn53s671QFw9/JtEM9ftQwbMjsUCeenC6mHPT2SdxEgi0GRInvUJRAANlSaaTib7b6cxLBqG3QeEwKn1Y6zw3eQS2d/PSOXF8PvP3uAi2CgkvcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPqtYMxml/yf/9bo655c5nBPqDGutQEGxKRLb+eoZgg=;
 b=U1yBGWyJuSg1yA6UCfKL7vBvtEsKMC7JKsDW1NY3SvzIWTWYYaAdCwCOm+16y8NNUcSRkLeT54aa4lvak7UKvJI5bqgn1hje8quiUT2RQKX0RXf8agcipwluxvejVzz/We6rhHlhLleIXQgW4qqxrgr8OL4NoqjU603CHr8HsDmzZSPw2Q+yZbWwQG+pq0ACfrIbcMqDrYhHziqJc2H2f0Ta/Vwa1I3re/5dbDZZtCwNnl9McD1rpiTSFO0diWJf5KUfKlZs5p204KbhGPdApvTgw8jN46NC0P+nGxxseUG3JJ+ddwuMrL+83Evor288s5SAd7fzvv0yu8uEjQnljg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPqtYMxml/yf/9bo655c5nBPqDGutQEGxKRLb+eoZgg=;
 b=axxL8XUTV6Ti2Abpz6O/8XY8ZbsmqECVulAFS07UBsTXhkAPmlaXmLvgkDVnAKaRTHnwdMKqjLQsxoSAx5rnbE9rEhZCYhldxYyUta9EJ9UAnn5A00f4F3feZ9QgJ4zsskNnZz6rjguxGxI6FCBgA42YlTT+/nEEJ20wL+YbIl8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7943.namprd10.prod.outlook.com (2603:10b6:408:1f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 14:49:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 14:49:31 +0000
Date: Fri, 22 Aug 2025 15:49:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
        mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
        peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Message-ID: <a1942809-ad8b-4a8d-85c0-74ffa2fbb53d@lucifer.local>
References: <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
X-ClientProxiedBy: LO4P123CA0690.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f3a7d65-a9b5-47c0-f00a-08dde18b19e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BhEV8aEjy2unSA7ZfUhoQKxgZbIV1Gd938Q7xrKRm+KJlcXra/n3/4DLMyUT?=
 =?us-ascii?Q?Ak1ZIgwyaAXUgG6RObm6offgwXyQpGu6JC/fkrPsBsVusGNVWk8fJTDSTG6x?=
 =?us-ascii?Q?nujbmJmfE9daoF9kADPP9AsfkwYbj8aS3e9tTTba1zIC2zBKbo/IwdDBXmF4?=
 =?us-ascii?Q?ho1usFLK2Pv9mjcaZfO0FFnYxE8uulUFGCx1dk6FXyT/XAjlzUSnHwo7ehCC?=
 =?us-ascii?Q?0exT+w2eYxIu2lRS40WZSjdNa8BayvKXgTZ9iOFfojKvsowg4WozI+/w4re8?=
 =?us-ascii?Q?jgwDXGPBfOrACVfslAwLHyxwsEtjmahsjZHdXGcMorL0qSFVLlvuw6sA19NT?=
 =?us-ascii?Q?EbwKr1NVZAtfOL8f1btJpl2iHO0cNJS9zPKXB3VlBnaD49FgWN5JZDHYG/Y/?=
 =?us-ascii?Q?NjAVfF8vD+2dn1LqrozPo30646XJIFvplDBmO6/kQmrPcWgSyFokGXNEnXCo?=
 =?us-ascii?Q?ll8dzLGJXcPVZ1ixR7vr3KvRJmv3tTZGgFjYP5A4WHPUZ4Ta5HRJgAs6Kfwa?=
 =?us-ascii?Q?K0b8JsDmOHIEFIunyWjcDUuCTxvENdqj34/TYSf9ST6dygN2gmMUEz9miHTC?=
 =?us-ascii?Q?tHriRrakfF1VUvXCPQgmBQeyMCMm9VbVydJhTIHmCjafztiJxAjnLPcpOpUr?=
 =?us-ascii?Q?dVhpk6N4Lkt+jl08RdlNb+pjPtvBzY5nKIVcLo3pBrqt2oTOhjhU23stjYPc?=
 =?us-ascii?Q?VuUedvsHrowvkJzQGWhcOtISr5xStkMtck0tGdCKIo62Ug96RIwrBAQteJ/a?=
 =?us-ascii?Q?vsDqeBocVURxol6zt9KP6yaiRr0XUESF1ak4Sd4VVQm3lxgom9RqORQZoj74?=
 =?us-ascii?Q?6e2M92Bi2Wun+faa6I0Uy17CxtoM5opHlCZFnN2PliWIW2bcsC7CT1oy/5IK?=
 =?us-ascii?Q?OopWAaEyCH834tHftA6EijkKSHz9KUhXbkeDtcb4AUTxhLs6HwO1CBHwxNCx?=
 =?us-ascii?Q?jf8lY19Dv8CMLn68Pe2ZCWrQxs4CS+gp5OzS0RIEZHpHWJzpU4RRj0bpsGtP?=
 =?us-ascii?Q?aUBMULwa5i4mxQz30/0+jUdPtyHOq4kPTyrOIc2bRamFBbktHSgBgRFpy9sk?=
 =?us-ascii?Q?FDizoQCpB459joDZTuhfVL8H7p6m1hqhcllWtFJFUzN4dqlP054CTQ4fJKq5?=
 =?us-ascii?Q?xKoLP69Jb3GT48r5yFr2J0d8HgD7lCjxUHh/ZZqlruPrECJRs09tFgix+ez/?=
 =?us-ascii?Q?qa6EJ8BoDKNEl3w3gX1R8wdvLMLDPtkpn9Qx3t7ImxK0n/dS4mv8jataC/n2?=
 =?us-ascii?Q?TYHRdHaxfLc0Sf9/bknykiGpWtE94K4F6rVH65cMmLuIWJ/hDdYeP0OoWyJU?=
 =?us-ascii?Q?FoICM1MlzhH7F7Oke6Vsum8toROJlrSMuxtiT0DUx+U9yIMAFV1+lPDaR/wG?=
 =?us-ascii?Q?SbBqW7/di+DLhbnLu44PzJ4zDGWRowvwZobqvwAQR7sFi+tgco3nGZpD6+nN?=
 =?us-ascii?Q?hom0CkSmtRs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Mt6uYq80F2CG0iyeOd/M23DL30v1E0aKD1P/i7ezF4SXnQJGTnZ3caKNvSA?=
 =?us-ascii?Q?Vjw9MDB68RJIWYr6DaV3cIiyepqscKd9dcspTx5Ho5K2RrHc7OHm0gdwCqKh?=
 =?us-ascii?Q?ObLUthTFbuLFLWNmjEsjU0obIqBGlHILhcja2mUNjNbz8sdJsTYSmJPhwFYU?=
 =?us-ascii?Q?kXRYrK6UuehONE7qgPezD+EFVbF4/TRHNRKsSIrmlyyz8rsOkY2mrMOl49cL?=
 =?us-ascii?Q?1HXa2BVuikSaigTmGqeo5mKEzYz+wRjSaahNDlnqsM6Y5VCsgM0PRIykg2cs?=
 =?us-ascii?Q?VzJqjbgWF0wEFgQ3nIxEFBb19opG/s5KBB0e/kaeVM11GBi/xAU1SkNjkO1m?=
 =?us-ascii?Q?rDYAKeKXY1X08JCy0TyRRiNF8jQTAY5Gze9+zVeFWc6AYBKjedGk6O306A9C?=
 =?us-ascii?Q?v7APIsgWtELGrNbcB1gmXb150RH6I/5cD6VyCBiGyBRSm+TiWynCFBuSG/yu?=
 =?us-ascii?Q?+aM9tnYlJ7nGe0CeAXyrTiKCqg8vty7wKZuF0fdLhOFCmS4pbO8/CuGSkQXt?=
 =?us-ascii?Q?3zCB8Fn5/evMqr9Px9JVJv4NR+DXKQZ/Kcjt4/opWOk83y/2WGK2mHprn6vP?=
 =?us-ascii?Q?i6+U82nBZjqlfCSKtjhQTqNJpuFr2eNdZnhyQHfIIPR4IzenNrNswjl0cXEM?=
 =?us-ascii?Q?ok20vZuw1lTAJgloQnXER4J6TJH+e22piSnZv8PtQmmGz/sOnk/urd4cmPI1?=
 =?us-ascii?Q?2Rz1VvdgPUpDz3EqklBxtb+kt0pYeDWlAPKtFpSJTkietY1lzkijFP7Fp3c6?=
 =?us-ascii?Q?+BMDGrONbLgUdKUBE12iWsnEWMSGA9iaz/6pntUGziCe8PpPaWGGmulsjFJE?=
 =?us-ascii?Q?7d68kbY2GvBJXk6OxwfVlsw015KSearNJCCKnGoR4OIFctS6vSC/zH26bavp?=
 =?us-ascii?Q?AY7O73oHN8Dx7txjNZFyjyY27o8pzexoELkyyosQdx+KMmGaW5d1ruuzkoQE?=
 =?us-ascii?Q?5An7NE9kpCHViT0ylxfuITDIIWUx95Emf99KJ/tTo3l5FSUT0pS7JCgZXOUr?=
 =?us-ascii?Q?Dy9rRqZYi1WSRzoyOzmhiOUdGpR+koKUHv7KhQoE13DhQiYTNrI7liLj7dvh?=
 =?us-ascii?Q?RoO4XI84LDygCjVSGYH2w/rjsHunonxdLSaqJD4HWEfRNtgQdOcGZT0Xnzfe?=
 =?us-ascii?Q?STV/4GzqtjiP1BNbw/+coyqp8FTLvHqHHLhrsldCfgoDvwWPICIpYIlDdwRO?=
 =?us-ascii?Q?cTgKubK7XUYtJK/mt//w0sBzjLUNPAfIYNt3yBohKczGLAgyyHEqFDUGw2QZ?=
 =?us-ascii?Q?JIXZf//rpzhF9SNgOERyeUhEGL7ugfGickYdlLzDh/hOaMBNySEZ4klobEoh?=
 =?us-ascii?Q?aQkJM8b3vokxyuzw51bMcr3+KpGqj70bb6DvZlcUIsTxWLkB7dLUK1KSoH1t?=
 =?us-ascii?Q?ILots2BWU7ZL8M/mS8p7gyRl3wpG4EnT+XZeU/CLBH/I3kAIzoAGdaKxlUJY?=
 =?us-ascii?Q?/1kQ14b6jGw5CosCjRA1qIyXtdHg0JzcCxghzu9PejH1pAXtcOWIWMPaNMjl?=
 =?us-ascii?Q?QXEylfqt07+DaU//8yLXYtSK5A5sDAuOjNRooMLegNGGaLN/FjfU0FDNdaw7?=
 =?us-ascii?Q?X20yygElqdChHOy6S0XQ37ycKbRhSrDnQTwNKo3Qu9813DgIQu459+euRMUM?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+vOPnqSMKwIVWBzljnip6k5DfUc0JCU+EgZ4KzeqC5GdE8F7IZ4Rjmfn+JvuOesIvjDPYdUa6Pb+E6cKUvZGFFpLlxiq+/bcnk+sdiiruLzZOSs2qwO1+IoJ1/vrxbigtd6Pmfo44jIyGHYCKA50MXzj6t+LG7qNJPD0ETTeJZr3KXRwvUhYeNweVYeMgHhdorZbME8zsxfACGS+kr4B3P1iylamYpuJ8F2RAGoJVxNVBC/If/am4VONBLt8Ob9yUXkalPXil+080A7dPNgF5vUO01OzVuAUMA7fz/e1PNUEYUkMchbZHdAwJBKfpAEQqo367HJcchV4V6Y9lXr55HWIhF1pFpgCluTBqlXGhFLt9KGu378a0lk48+IlKYOl4Nd0XKmtx26UKkLlUalcMEmacpWsA4fmW4Ev9JkHsRv1D3RBrNXJ/Cnevu9yO++8tGCmWPbbe/v4TGWG67bv+NEdbb6TFQovNtMElL9BPMpvh7DvuWugTG0/M6AA7FIrtAjpO5CRSxo6LfZx9Z28WOgaVXrEI6+/vBlit3POlB1GobYDCSgHFyL9gIS2SmOURFmty0e8DYa5WjOGmL/8JJd+PHYvU3UmY73rBgocpm4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3a7d65-a9b5-47c0-f00a-08dde18b19e4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 14:49:30.9622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CoUQ6Vc4/P+Fcxva1biPHrT0SByjsYTWIqU97a+EnnQuevLkJcqnX86WBs5getc7AFKwByjYUrdm2bWsdwU77o9KQ2OWMCCLGfSY98aGRCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7943
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508220133
X-Authority-Analysis: v=2.4 cv=E+aUZadl c=1 sm=1 tr=0 ts=68a8837f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=8lpCnpDcuYOSSMyT7H0A:9
 a=CjuIK1q_8ugA:10 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: znvaX6djSfr3A63LYjhw62iN8XymQ1Mz
X-Proofpoint-GUID: znvaX6djSfr3A63LYjhw62iN8XymQ1Mz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIxMDE3MiBTYWx0ZWRfXyhN32arUofHd
 VpTYPtW6DPM/dE3WiyQDz2x/t2ebo8yC3VFvXJ8kigsgF53FwIPG35n929QLbm+WNHiHLPtgNki
 Xh+yBf8TROm6Q1qZHyCVMsMoa3EF3NaCXq94VirrPuI0tJfcDAb4sjr6uPWp14s/Bo90vfmDl1p
 VWV8V01oeHyxj/zqGnR5JG4SK+syNI4NKNk5RdnV7WtAshGWgvwesqFYzErrSQUUwM4Hx4ko3kX
 nwjEqBDhsM68sjq823/u2/PuNiQH87g9PQ8/z45RRM5ShZ2p8pSasdj5ffukZUJksfiBigm03fD
 hY0F7J7sQaOISlupXLjpKpFoUNT11PT7BzYCe4LW1HpnHTrcLF0mEvVcEFiwP8MclqX7tF1wKWt
 dATQX683pHx1AxdO7K6oVVhQWTHr9Q==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8B0C1C0006
X-Stat-Signature: srwtc8fz57fh6j848upubangw9cqhbe8
X-Rspam-User: 
X-HE-Tag: 1755874194-145861
X-HE-Meta: U2FsdGVkX18QJgHH+DgW8JyNLDzmGz0W+iwUkiKL5YmkO9fvF46s2DEfKh16F82y3jwCz+nJacYvFYbLSHZ3aXbGAn+2cIPhU9OKkr9Pbxvf04RyA4WwTUYmVlgMDZj3EFvrL2hcRi3dJaDCunI8bFGa2b2ZmznN/qEJo2JiuVVTG9vHAgCHEBSNW3ZCN0+t8Ot17DeLzPc18esoTl/AkTa2jtgno/cFS5OomgTcxlf3l8ocGZAfGhA5b8jbOjjjOTsNd6vf+wIiHVewYc4hme0dlV0OE3/b08Z6/oYe2DcjynuE46oEBLEHg1rIHEr38yaFyasSPbllAG7GC30q6oB1zuCrMhytPEB693aywHX0hl/FPonXo/v+CymPIlNfOJHgxXbNjHPl4tF40b2bhuld8NID6UXLypCxCiBJ2qZYBMOczH3XBe2CbU0mcyRdKNZxeXSEIc+pVJGrQcYdrHo2J+JoucGQS2qnrbi+cX3t+5OX7UDsm7gEYoRsdpjGFUGbi5jQK0C9H6IQR8XulHuXJ0OT50O7Rp1+iGrQC+0rI/5mICPi+Ioy0QR/lmcFPTRfaeIfl9GFjLcQPJurwc5pHCuNF4hPUGh3OkXxpbU10tZt6/7lGYFg1V2nvxViG/WUdP+jJLEWbVs7CiVvyAHrQVsVeuJyIZSI/ayDRaPCe762oA43x2WyzxLQnjVwpqNX6h8jpdZ0uek2NxMhzJotlKWVqfsEJ8nGxr9YGG9coR+mjcq5Mdb5Hy0/Cc0j3aaQqGypFNdGRzTnudlaQ81XqO5eDSpkHhpTkw4VaE80r5SYNtI0+2q/zOz4zA9HCccyKpByF6YePDxy8e3IN4VinmvAL4ftZNC+6EUkhxdo2OpUZWHkwD5rgFdeHWRmlP4HeHrueJ7uwUzG0P3vSrsaUWenFekhTMd/JzWIYlzdRjLUh4vtKwiZonJz6QHTRLVJJKJl6eTXsCILDYF
 +0oZ+BU3
 Z0aBSBKSzf/bVlPjdbIc3+Emt1zPFCtTeMThNxUnAHLeK0MSnj35lcL4zKRORxYNWB1AE+KIkxHdWw6DUVmwVHUHYOhuIBUvVQoKiNooWWYRKTqMCnIr46AI/yc/ds6rVpuxSOoucFgZhcdnXn4KEGTFl9SPLi/rurUIf+1L8EJ8xR1Xxf92Nev44JR7IBjbTV0MAlflAhXV6EmSX7IEpxff+M5rvEjog/M8lKSWlczbP/RH0rTCvujiEGecv3EaeXAtvsKTJ0Wk54l+p2Bgb/WnIIART8L/NL4Gtcg9xsgc39LWbnUtpkcdSG1qXy4DxjoPKHQm+u7c3UcBiIk3A+MXsG9kZB2voXaK9YKVfa8VXiMo75i4jSx08LFZmGwmETL1JDxh2OjREKu1T01hFSu1lncgHPiuCfQ05ok3ormwb2bDSWgym5LOoUnYUO+2UTkuYtaiDTAW+Y0ilA8VhXgbZrW2Q+8D6I0BcfTCjUneR1H/fx5PeHvGetHhV1L/N43XTqYa2GfeVXi6t7V3DuLQaPqecWgBKB6vtm0ng2BsQ/ALQTmODZWJWzhFJmMJxif8hrEWtr7RXdO1hQpnjeKMwuOTlcvw3tEi3DqFx1tTdNxl8X1TkjhWfA81VmaRNgpOHitjvDnvrPeObsDqWoRn2VP+JkcvsmTqur8iLhloEupZmVmPs2E3kJG5E0peDAqMGZvC8F2mHTxyFmHmKbmFCfF6Dl3VdH0aY55GUYMKyPlqFzwvu4eSWtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 04:10:35PM +0200, David Hildenbrand wrote:
> > > Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), but not sure
> > > if we have to add that for now.
> >
> > Yeah not so sure about this, this is a 'just have to know' too, and yes you
> > might add it to the docs, but people are going to be mightily confused, esp if
> > it's a calculated value.
> >
> > I don't see any other way around having a separate tunable if we don't just have
> > something VERY simple like on/off.
>
> Yeah, not advocating that we add support for other values than 0/511,
> really.

Yeah I'm fine with 0/511.

>
> >
> > Also the mentioned issue sounds like something that needs to be fixed elsewhere
> > honestly in the algorithm used to figure out mTHP ranges (I may be wrong - and
> > happy to stand corrected if this is somehow inherent, but reallly feels that
> > way).
>
> I think the creep is unavoidable for certain values.
>
> If you have the first two pages of a PMD area populated, and you allow for
> at least half of the #PTEs to be non/zero, you'd collapse first a
> order-2 folio, then and order-3 ... until you reached PMD order.

Feels like we should be looking at this in reverse? What's the largest, then
next largest, then etc.?

Surely this is the sensible way of doing it?

>
> So for now we really should just support 0 / 511 to say "don't collapse if
> there are holes" vs. "always collapse if there is at least one pte used".

Yes.

>
> >
> > >
> > > Because, as raised in the past, I'm afraid nobody on this earth has a clue how
> > > to set this parameter to values different to 0 (don't waste memory with khugepaged)
> > > and 511 (page fault behavior).
> >
> > Yup
> >
> > >
> > >
> > > If any other value is set, essentially
> > > 	pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");
> > >
> > > for now and just disable it.
> >
> > Hmm but under what circumstances? I would just say unsupported value not mention
> > mTHP or people who don't use mTHP might find that confusing.
>
> Well, we can check whether any mTHP size is enabled while the value is set
> to something unexpected. We can then even print the problematic sizes if we
> have to.

Ack

>
> We could also just just say that if the value is set to something else than
> 511 (which is the default), it will be treated as being "0" when collapsing
> mthp, instead of doing any scaling.

Or we could make it an error to set anything but 0, 511, but on the other hand
that's likely to break userspace so yeah probably not.

Maybe have a warning saying 'this is no longer supported and will be ignored'
then set the value to 0 for anything but 511 or 0.

Then can remove the warning later.

By having 0/511 we can really simplify the 'scaling' logic too which would be
fantastic! :)

Cheers, Lorenzo

