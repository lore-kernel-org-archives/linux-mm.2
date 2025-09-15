Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D1BCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 12:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96BBF8E0012; Mon, 15 Sep 2025 08:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943548E000D; Mon, 15 Sep 2025 08:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AAC8E0012; Mon, 15 Sep 2025 08:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1AE8E000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:15:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 308E41605D6
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:15:15 +0000 (UTC)
X-FDA: 83891379390.21.DAB0E8F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id AFF79180012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:15:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="M7NM2C/V";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="bxf/pl7C";
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757938511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rSIyJ0q8Oc3n16rZzUscFbJ9EBbGjUgLhB+r097WxA=;
	b=qNlnwXFcDPw2TBZ4cFo+H1gDfa3ZTAdiaW1glLP856aF0HTddDnacP0svnYjrv6btb80R7
	GEwr+dQ9r0Rn0n3dRlDTybfOYpeAzli8TCPtIPt9xeAhV7O5VefqrDOOk/YpI6v77EdqFG
	sEvalHa+tdgEEzxr75zL/uxE7WzZtAw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="M7NM2C/V";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="bxf/pl7C";
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757938511; a=rsa-sha256;
	cv=pass;
	b=UGQ8OhTp4b68AzIInJ5ExDIrhQ3o7T2SHxGXnrHjgpU3JyfmdbIKgk83gjtflVRYmVT22X
	jU1Xjbyk5svwBQD5PadT8rHclPgdLliJrc0CnWLY+nSapbG0peE5OMF9VJEjl9kiDRM3+H
	9yKcC7PbHXL63OQE83qqxyrz6nVdiFk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAtrmc028212;
	Mon, 15 Sep 2025 12:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8rSIyJ0q8Oc3n16rZz
	UscFbJ9EBbGjUgLhB+r097WxA=; b=M7NM2C/Vhz7QWhDlO8VuzlXetJh5qBKxxt
	NMmXC1C2Ug7MF+kR9CU5AIvjjZDj/4tMOxzwc5rtz5VlM+Pb4NJ1mnaPPdzMOcUF
	K5rJEWRf/lNkwp910gDcWBgjCsPPQfJcEXqu2Dq4rnMeBKxkf1Pxy1INrbGHUXgX
	La1IBdJ4vI2IDJKsHlVLpevX+OcSBsL9EVBTedsxY2Y88lnydNfV640H0aIfjcLm
	nVT0Y+BwJBxDmzeKMUWog/PVMj2GyDrxl/kJ9Upa++uW3/WY4mdnzE0PQ5TKEPoF
	twy0E6ZPh7GdSW1mF2kuYkZBj/eLkslD1269OJQeDbsv4guo0Hmw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494y1fj7nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 12:09:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAicSN019174;
	Mon, 15 Sep 2025 12:09:45 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010027.outbound.protection.outlook.com [52.101.56.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b6wgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 12:09:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYN8QQ1jRCIU8sfHTVr6X2rv+7qZrT7UXTkdz0rNq0ubyiawAUUYwR0cDgiPv3syH438T5JS+vfn1SedcphwLAYOcDtuXTqOOCaUVI+3fSHP2xd3fJoeJXscv72IPB+YX7U00DySbO4d4YoCxB8xOM5kIyUI7II9ked6mUAre24e+bVVHLAb3zkjq4DeMGIH2hr1kFTOpVOsSaXG2TgRvBhPHjxKBVLW9wKzikvgEKLqQf3ePYsR3X4ivgJ/fGL6ZN+1n7mALEMp7zKPxyTP+ycHsEF43yG3C1KrXXXrSvjsTsy8oLORrXq9NbQx2TTX7oMQ8nl6O9aDuix1tjEhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rSIyJ0q8Oc3n16rZzUscFbJ9EBbGjUgLhB+r097WxA=;
 b=a4DXWHpJGtIunpG3bTKxY3YpQ1aFNvN7QsJMsnap/9gX3THul+LRs+wrovLnTOUGQavfVzhRdJid3ACILwsQkOqaKLvUejTZ/VYBQvLXWhzO6OvXYDi5eK+/w0TgmLIZcIyr3yF0fvQyXKOpIKgTMerOyAUbf6/66fE7llcHTGwagMWCloLdiAYhD63Kq98L2bE26c+XJD1Rk3enAUTCjUjHROOP/shi3WzK4t7nwuUrrbsHhpcXzu7mUKzSDuNmMBWpKDJdlGihZ14eTeSgPGmuZAd1CuyoAQlphznkQQpMei+cTVmmQ7gFWxv5rU2e7TyRflI7QoAgFvCK366wpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rSIyJ0q8Oc3n16rZzUscFbJ9EBbGjUgLhB+r097WxA=;
 b=bxf/pl7CWCJKdyDCLig2xqnC9Rufi6iKK+ib/bK9mobMdbsah/3Qn0LulrQtrYeh7R4sQbvPJyFpBeJtP2kfeXIwd2XozWzSF7XImF6xkFCdQIkohP2oeVJnZS2dZ9OV/lvmnzx7ebOVVQ5fy7PNGQRjfAUC9U6k7Wt1fP75DGI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4217.namprd10.prod.outlook.com (2603:10b6:5:218::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 12:09:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 12:09:41 +0000
Date: Mon, 15 Sep 2025 13:09:39 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <3ced93f1-cbb9-4847-a572-362c75438291@lucifer.local>
References: <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
 <ae9d88e2-bab9-49fc-a459-d7b9a8fe9351@redhat.com>
 <ff4b6935-fd13-478e-9187-219fb612aac3@lucifer.local>
 <e450009a-56c9-4820-bd0c-da1d782d3962@redhat.com>
 <2757fb07-78bf-4a39-8c60-8ca8be200994@lucifer.local>
 <a48c8d89-da30-4a7d-96f6-e5e17757b818@redhat.com>
 <e0580a44-2afc-4f3e-8d3e-d4fe9b2eeb21@lucifer.local>
 <6ec80746-2945-485f-930e-8cc34446f9e3@redhat.com>
 <ioo6sjwlznvfmv7kupubkqk6qc6lec7kczius7g27o4kpp3z5p@druouu5ziylf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ioo6sjwlznvfmv7kupubkqk6qc6lec7kczius7g27o4kpp3z5p@druouu5ziylf>
X-ClientProxiedBy: LO2P265CA0246.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4217:EE_
X-MS-Office365-Filtering-Correlation-Id: f86c293d-4bce-4438-67d7-08ddf450c019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?upfVrJmgkg2AV2faWLffYEqvQWK2Gt2vJwvbA40BbLHl0CZJxvWg4LqM+Xs+?=
 =?us-ascii?Q?b9n1gl8XyfL/lnZjDVcycLRu1L0vMofq4rJNILpcqQWWEv6c0UfZV/oKbHIv?=
 =?us-ascii?Q?V3JFDmQPuYcxNyxGjS3gBrBtP8WuIoNC3fbMmVDcYPPzFX1xlxiiGmT1JVaK?=
 =?us-ascii?Q?AzIwN91fZd/Ra6JcccszVn03El7LE9siLM7WFDL3szzf8USsyCx9SpKG4CqP?=
 =?us-ascii?Q?e+BYGwQ/xiKfM80+kxAUlZeYSd7aaqUliIydN24dBvi3PPTqWDf6OfrVuAYK?=
 =?us-ascii?Q?qIeb4HzWAUDyKJl+/QmPxtogRK0vmkyp8yiP/qDst8DpMaIBqr01u++qLy6F?=
 =?us-ascii?Q?MVDB/BEBLIek9fCHdSfF9vg2EKSWGmooYpVKWxs8AyaxQ0OZfY9fmf/2ztDB?=
 =?us-ascii?Q?OKGZ756nbjfIgce4D5omav8OcQX0RW7DOlhg4zAludWcfpzOw0AtzfRPwrLp?=
 =?us-ascii?Q?KTqdMUI2X+uwvJbDrN+CSfBQPygH6DzFrEBvYW+fJQGxjClWeynElhCeEY9Z?=
 =?us-ascii?Q?bHWiSb88FeJOS3aCYDxND4m9kdYKYWp9vDjdpqEUw/N36h29wtF9ujGclygp?=
 =?us-ascii?Q?i98CN4cgBLj7KXi/fnfFElaRmDr5kKOmoFcY0yMBQDIxf/H6j7dt8U1PDT5T?=
 =?us-ascii?Q?ziMdLaD4l372OU8b10Vrk4jjWeiIh32q1rWZ0DvrOw8OQxZFcDW7fmYpU9DJ?=
 =?us-ascii?Q?FE4b8x15Do3H1EHfYPgIdcqknELtZGzDzlFdcaAsiNforvSG2u7UkI7UYVVM?=
 =?us-ascii?Q?hYRzaQqXGYY9fOG6z0GwMbxXsic7Kykx7cqjWfTWuse6TTuqEv54uSM/l3A9?=
 =?us-ascii?Q?0Oq2bnrSwG+0tPhx2l02qKjyRG0kRlHLf8X47s1Zo0IEdvINfjcGcK1cP6ao?=
 =?us-ascii?Q?4WhDuimE0Y+6R2QvjzTcXWtllYB0NAxbcvEiXNWBw99vrwNMu0BtX0pr3OaX?=
 =?us-ascii?Q?NVpkfaeW/DLfd/JtLseU2knRBJpzNJr2yYlQcdavsVUtaUa0gf9891NkH35x?=
 =?us-ascii?Q?KW+OYTBlSwiRmWqfHJvFi0cK9hlgBOz/ov3TjPK4P28SPNGLQzhfpMZyEb4K?=
 =?us-ascii?Q?Q+6TJI8/5WruFMjt/VrVryGERQpGfWYET4+l0VF1V9bTi+4GkEgacWk1NOWu?=
 =?us-ascii?Q?nWegNDM9JvPRz2WodnjWxw4Nq5SJbHvSgMS36jcPlgd9CHmbG0sv+ER5T53i?=
 =?us-ascii?Q?S+a4uLOxg6/zpnV5jXPDWRJNC/0D22szHliNY1gGAkoLxzr1u3w25Qjo/bkK?=
 =?us-ascii?Q?+DDHw+pRt1PenvHcvtiihel3jMg9ipnxCuxLfo0A/lXxV9Ou3eH2SNzolGa+?=
 =?us-ascii?Q?T0HPit+/s4uDu2jTUz2sYrGOUq/bhFLyEh7UGM/98TNr4wLiEGCrtz6u5qUN?=
 =?us-ascii?Q?ECuIUsygnvFfadHUnOVo4fi0zQMkldaQs3XDHa+Fyl7Tgl1EezcGMbBtXeRY?=
 =?us-ascii?Q?2eMfgrdm4vc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L6LTbAWkUK8mKgvSRlKXDyS6RQhiYqOHYw5oX9/J3mGQZ+oOhBAQcCS0IMBm?=
 =?us-ascii?Q?b0MzBqCqFDAnPCYeMxiXd/vtmxsPA0oo8V+CNmCLJaNCRITTl6YlumccxUxi?=
 =?us-ascii?Q?EjonHCX0zGPl8mlAcxXDfU1wmXx5NHUNJFPV1H0UhQEHkVA0aP747KeB4eBN?=
 =?us-ascii?Q?JZvWY7fE85aUsncOjd9SHHS5D4GUcsUYtfm82bDe7ljIpskJLpqoJufNUux4?=
 =?us-ascii?Q?ZelJiHd//ElCjE0ksJjpOwYe+WlWB6vAH4tHpbyEH/RiiBo4PO077LPQ74Xj?=
 =?us-ascii?Q?syfsfu153ouFCt4HSwEZffrzRJg7kW8tIkeK2VGAs9rAXhnglmaAJl1t32Rh?=
 =?us-ascii?Q?U1dLZwdxmrurAxREaGbnCr4uMp+w3sH3JL9lCdPIT0PVhh0UjA5XOI/qafWO?=
 =?us-ascii?Q?Q2Ukt//0V4VYjVrYJAkI0a8rMJRn218aCVVrsJXG8h/0JYwMRn5Zi4Z9WYBH?=
 =?us-ascii?Q?ur/fiLp2CO0kFCcDCZed1RlvxEkDqLf7eK6Zb7BeKNNULmrckcMObo5DZdKT?=
 =?us-ascii?Q?5xY1n+oUoBRgX+TbFlutIUqBu+ioH4qlOCo2Vv6gXO6pvWG6+MHlkpGZZ4Qt?=
 =?us-ascii?Q?1qc9klyGn0RFFmnymQsvpUczRTuKUhOAetX3hpyUpKzbZdosYBaHix2M5oA2?=
 =?us-ascii?Q?clbltnWFnbhlcllGnm8Fn57zMYSvazgFsqjM8LYJgsNl3Bp+mfKC3nHYi96u?=
 =?us-ascii?Q?mp0n0WZNyeQT09gf/VkfwDMtZuYn+oWnWWwTO3qv5XXFcAYjpXRVqdsxf8qD?=
 =?us-ascii?Q?3Ps6d8bXaDK+U97L8wTqFQ1OBH4Khws0ldqPy1AW1GeBtz83P39k2WNqORtY?=
 =?us-ascii?Q?sWcXPuOXmgn2bMtzdyUp+5P4r4qY8q6Hj5+uG36yifvty4K4L4EVSWXRqvIa?=
 =?us-ascii?Q?dQ+Bp8BBhtJW9XknkJElN1Yy+Jqpq/GtlO431tS+vyqOP+My4jeDHwRXagUw?=
 =?us-ascii?Q?4kNvQrrCIGjy7XK9+mtQy9ulKH7fUB0E0J5dq8h8SQIvAYvez+iEChbRhYhF?=
 =?us-ascii?Q?/2BAXD+jvZECOuZAA6qBeufeuYRhvQ8/j0a4fxCkYHHm9rVe9KK2jr6cHAlW?=
 =?us-ascii?Q?iwK7U+Fv/mTz9eBOlW6m8jHYDCaZU7Q8pEhqaCz4NQ7L7fKoyqHcyYt/EGuK?=
 =?us-ascii?Q?jsK0dILT+R/AaX1ZoT/AF8Tz0ZfosAFKOuRprtqFjV4DKqeVoYEW7wRHgoeZ?=
 =?us-ascii?Q?kMJNVaRLJO97E1G79H0cL28zBAY6R699CQqTvhXXbGghET/AeE/n2//835HO?=
 =?us-ascii?Q?ficoFw10BcBJ7tkujfPX8tmNHI5DSghKebRGaE0FzHA11CalONtMd4ch/YG8?=
 =?us-ascii?Q?LWC/E6BTy06ubO+dDx27wtgYWk9b69Z6784MCQ/Z0gxXaf1Jm8/FNwGXCEHu?=
 =?us-ascii?Q?jCepXnDVahCIik1LQgnoGc+NyGmvFPbxLldZtYK4L6yr0HH9VOSb7Q+Rtf9+?=
 =?us-ascii?Q?aPG5afRu7WeQGKodwvDQc0wjWr/Yj2Z/VUkomEmVfPBeQ5aZvK+/zSVCCgi7?=
 =?us-ascii?Q?8pHXpv0wkwDDlgkwi5JVy+2dnY4Thljx2Irq04+PsjpVZd3Vmn8Zsz+hhL52?=
 =?us-ascii?Q?M/zpjLp4k8U2tS4yr2H3AOiS4DZ2+npuUuVAGkBgu03HRwh1kfgt0c9w79uC?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VraaC9gojRzAt0mNT/dRHCf4LHBCM9uPFree8yTuS2SKkjCsMBSzfQj01B4hIwwza1jrqi9z8OWmItzEaQKJN28V4LvxDaKoVJNhOSCoY5TyPV8xg/nimFhKli6463I4Uno8KLxORQSXTAkH/CiXm0ol+UQKYvH0AjVovFW0rif1oe3/qg3wEIY2D6Gaz4d0amkEZ5yrnvSUyHQqOBiQqz/XPKi5cN/9O4nXnaJv2f8x7fKfjAcliP8akT0qjjmSmZReGY9CEdEnDmdaFBUKA5VIR+UzFt6mWGcF110OyuEBCw8q9lfu/vdjaXgruXxWsYUhW7xX69+Mw5DzqkxN2EYJN+fXulruj9ENGfc+mC4vVlKNqJcHSanSX5zuhxQeYVlKKWGj4ThzG3+DOnG/6iNAYKwqc6ve6v7i419msaZn+IqDGHOlFFR85Gg4SF7Wy6maqZIjAo5HLBxgEOwX1i9glDYtywAtJuIkhRKGiqAY+jwZcNg4DZzOxDQu1lOwpAgn6SyvvgSisNEvFmazF5rpsJ6xm672tdaOp1Y6YQ3VaymuSNvdB0CU1eU7NdhynthMK5JOhiL1d5jNlmoBPK+pAwQF378T0wYAhUMyK3E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f86c293d-4bce-4438-67d7-08ddf450c019
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 12:09:41.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1AtIqNuTJWQnr+wM9gP6D4/Et73hTWuQMxiF1lHvaDEuY0RGN5dyAWP3QHQwZE+Q6Nc9ilmDvEAvItAupY4aQ4wNiJR75EgHGYombX/B/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150115
X-Proofpoint-ORIG-GUID: iY-Bhk3tc6DVEwDy20W8RjJoJkjevHm8
X-Authority-Analysis: v=2.4 cv=KNpaDEFo c=1 sm=1 tr=0 ts=68c8020a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=xtoeP79OCLh7t6D0JHwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: iY-Bhk3tc6DVEwDy20W8RjJoJkjevHm8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMiBTYWx0ZWRfX7s6f/KwJ+4E7
 yxfQH4EfriCAexRKM1lwZiG+2E+7kyZhV+jcrcuif8dL/D/dFA33Yx5JhMCYQkIe01hHW0ORlp2
 BN2c4rVk509eAVHEnGxwb3Ps66kXVDzZr4MyM6YFsiqJB2LrruvwGTPcnnpzX66VqEpK4PWrQuZ
 IyBCv5/QNSVR0CUWTWVEIIUCaMRuRQ9/I2sBH8LCmvJpMm/FLXm3Ed2bwnUuXmd82bJ2WnMHQQO
 vAinvDJ1a5+ak4zsy90u2qWoH7Nig8wErYxcqEgNTeMuUaOa6XHYY7D4aden4mApNmzWoYn9nT1
 bMWZKL3eJJ1HuDjAkr8jZc+dfSuB2iARwU/siE1/eezz6JG9vCLr2cosLWynFv9QoZX+7RfAWMd
 RRYMswA3
X-Stat-Signature: 4orjisgwfi15gtyerpj6bf8sdoduxyx5
X-Rspam-User: 
X-Rspamd-Queue-Id: AFF79180012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757938511-307330
X-HE-Meta: U2FsdGVkX191R4qFqcqlKQqRns1la+Hb1NwvJfHvwJ8k86gZv995evWdma5ew613mjI9xeXUD48H7XPwkzEVSgxdxKG4aNPqSH5Hk1x4Om6dj2ZeBwQpu0Cyb11F1qNR0Hw6+iPXQV+vjdwRdQ+P5c+wP/8oqpd/1d27KEQ+K+kHgJ5YjhdQOs/lSRPUhm7ykWTPEYc/EB9q1Xdn43S43a5m1BDKlz8hAZRB7iz3F4k0Yp1ccTqJeX28WnmBk/16gaxrp7uIpBafHxv2AvDs0kcIvbrHGBAZ6XpohzkSpKKLIBN864JPr4IAyOLizDGMf+OpzqqSc47PdWvVMA/oCbhemE6GSn3U+tSPgmhkHFvhouG/49e4yvie5e8N80zEYyRTg/Z+Wl9/YRM1/kzsr/x4nOKxSSt2Krx3uALPzb0jFHp5KBo3YHltS78rvDgChfTHAjZTV0102QAjtKtvv51VXT6IAqk4XtsKUfT335tKM7rs1RJCdOe9HsP/uunG97BbbCGc9Qot3uMYg060tucAJTeXaJjAyIWM4qDTNO+nKuLFdw2ONUGRMeqmtjm6dAmZfl0axrqwPYmO829qVGwCI6qh80l7S+I06XCouHMRvd7oEsoBvnUhkbwj4hwf2lQt6iKETO56/4A3RYMh/h0PTInuF6RgVVKHCd+Cuk6vOrJUvPoNQBMjyJq5ziwg7UlXwO4/wWa4xskj/Ua1ixwd/Nvatcc+Jx2yzXMn0J3l1ca5T4yC3o3l3A079E1FRcxyWKmsPqddO/WkvFsZN/N6HnTo4raswASrRw6SPFyAm71vvpQNgsva0vgRM8n2Ufwjq0Am3nnVDCQpz2w+bZxHxunGS15bEkQn3KhBEfnQiz1GC54ZBXZz0yK4+8RMougEXho4N/IK3V821S6+kUkqhaqmYwrteMn+vrI+FDtDuXKZwWoLrOuc5E4K3XB9oRfReeIH8AlJ7DOpQGk
 BTiy+Jsd
 yAEGQeezxibOdVd+0iqO4wVa2jOH376uXa1qVntDibVsqMhP6r0YUvmLx+8xV4KmHahTogecJB31RUkdZSPPxzvmKa2q9+QLt08yuNq0ZHFel4ogpgAHeO/byonKqL/lMjFfvK8D2ro0aUHhID+ntxk/xcYFqmmVio6SOfmxa9a2J6sUKrKlNCbU1QY9P/sJufRXpe0zYsKWn3ANFE02UZtHYv23bfoOyNKHO/babuxQyzuLxfQXH8f9twYfoKl3vrFw3q1HNEYD9alXVO75yiKoo68uUu7lbrFMFv6/aQHkoAfPlVd3O4iQ2vFqfpMrmzFtVB1WgZxcaBzkTi/SNcxjqm6acKAfw0KrQcjEmVyQaiCs1gm9JE9DVHGO3ZrX3jFVrnTzByICyNm7eqe2s3WWUG+VYc/J+4CJtglBK/VMz/Xnfvwlj4yux6nJwEFYVuJsUIDnEMH6GDGFDtoPO1XRGVzrPMT6f1XkdE3IFUQ6iHLNj5EA04a2uxVWwZLxVkVBdbFd+op1Us0bALNeD67TlJ54kzIBQJDbPpyH2aPB/xMzj+5t+H/qNdu9zIjcDPR8ytJhG0QWlyxQvvnaSR9VaAggn9ylJEvqceeg707RGt1AcygFS9xlvL0LS+Eo/Q6P3esKH8CffDRlL7RO74uZR12dW8cvDK45ZcrPMoFeQ7qfDCa0kWGHpAJJAWnhg8Ba4RafA5+OT/+jEOGTg2wK0Ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 01:01:26PM +0100, Kiryl Shutsemau wrote:
> On Mon, Sep 15, 2025 at 01:45:39PM +0200, David Hildenbrand wrote:
> > On 15.09.25 13:35, Lorenzo Stoakes wrote:
> > > On Mon, Sep 15, 2025 at 01:29:22PM +0200, David Hildenbrand wrote:
> > > > On 15.09.25 13:23, Lorenzo Stoakes wrote:
> > > > > On Mon, Sep 15, 2025 at 01:14:32PM +0200, David Hildenbrand wrote:
> > > > > > On 15.09.25 13:02, Lorenzo Stoakes wrote:
> > > > > > > On Mon, Sep 15, 2025 at 12:52:03PM +0200, David Hildenbrand wrote:
> > > > > > > > On 15.09.25 12:43, Lorenzo Stoakes wrote:
> > > > > > > > > On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
> > > > > > > > > >
> > > > > > > > > > 0 -> ~100% used (~0% none)
> > > > > > > > > > 1 -> ~50% used (~50% none)
> > > > > > > > > > 2 -> ~25% used (~75% none)
> > > > > > > > > > 3 -> ~12.5% used (~87.5% none)
> > > > > > > > > > 4 -> ~11.25% used (~88,75% none)
> > > > > > > > > > ...
> > > > > > > > > > 10 -> ~0% used (~100% none)
> > > > > > > > >
> > > > > > > > > Oh and shouldn't this be inverted?
> > > > > > > > >
> > > > > > > > > 0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
> > > > > > > > > 10 eagerness = we aren't eager to eat up none PTE entries at all?
> > > > > > > > >
> > > > > > > > > Or am I being dumb here?
> > > > > > > >
> > > > > > > > Good question.
> > > > > > > >
> > > > > > > > For swappiness it's: 0 -> no swap (conservative)
> > > > > > > >
> > > > > > > > So intuitively I assumed: 0 -> no pte_none (conservative)
> > > > > > > >
> > > > > > > > You're the native speaker, so you tell me :)
> > > > > > >
> > > > > > > To me this is about 'eagerness to consume empty PTE entries' so 10 is more
> > > > > > > eager, 0 is not eager at all, i.e. inversion of what you suggest :)
> > > > > >
> > > > > > Just so we are on the same page: it is about "eagerness to collapse", right?
> > > > > >
> > > > > > Wouldn't a 0 mean "I am not eager, I will not waste any memory, I am very
> > > > > > careful and bail out on any pte_none" vs. 10 meaning "I am very eager, I
> > > > > > will collapse no matter what I find in the page table, waste as much memory
> > > > > > as I want"?
> > > > >
> > > > > Yeah, this is my understanding of your scale, or is my understanding also
> > > > > inverted? :)
> > > > >
> > > > > Right now it's:
> > > > >
> > > > > eagerness max_ptes_none
> > > > >
> > > > > 0 -> 511
> > > > > ...
> > > > > 10 -> 0
> > > > >
> > > > > Right?
> > > >
> > > > Just so we are on the same page, this is what I had:
> > > >
> > > > 0 -> ~100% used (~0% none)
> > > >
> > > > So "0" -> 0 pte_none or 512 used.
> > > >
> > > > (note the used vs. none)
> > >
> > > OK right so we're talking about the same thing, I guess?
> > >
> > > I was confused partly becuase of the scale, becuase weren't people setting
> > > this parameter to low values in practice?
> > >
> > > And now we make it so we have equivalent of:
> > >
> > > 0 -> 0
> > > 1 -> 256
> > > 2 -> 384
> >
> > Ah, there is the problem, that's not what I had in mind.
> >
> > 0 -> ~100% used (~0% none)
> > ...
> > 8 -> ~87,5% used (~12.5% none)
> > 9 -> ~75% used (~25% none)
> > 9 -> ~50% used (~50% none)
> > 10 -> ~0% used (~100% none)
> >
> > Hopefully I didn't mess it up again.
>
> I think this kind of table is fine for initial implementation of the
> knob, but we don't want to document it to userspace like this.
> I think we want to be strategically ambiguous on what the knob does
> exactly, so kernel could evolve the meaning of the knob over time.
>
> We don't want to repeat the problem we have with max_ptes_none which too
> prescriptive and got additional meaning with introduction of shrinker.
>
> As kernel evolves, we want ability to adjust the meaning and keep the
> knob useful.

I mean, having said this exact thing several times in the thread obviously
I agree... FWIW...

To repeat, I think it should be an abstraction that we entirely control and
whose meaning we can vary over time.

