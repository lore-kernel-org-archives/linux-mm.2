Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50829CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4558E0017; Mon, 15 Sep 2025 06:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B058E0001; Mon, 15 Sep 2025 06:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752FB8E0017; Mon, 15 Sep 2025 06:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 636448E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DAD4C0560
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:40:53 +0000 (UTC)
X-FDA: 83891141586.14.D5DD950
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id E623540010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:40:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vtl9tCxY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ehdzU8WG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757932850; a=rsa-sha256;
	cv=pass;
	b=gKvKvB+YleNVrsrWZhbilxEZcR0PMK+8vuSS+7Q2uZciGjvJP3hFVAvzgPMstI9JLqB8CW
	V3wUJIjCJqfEMRs5/6oqWW1lkbv2c9DWk0PanlARKSg1JZe9cYf5fBW9Z60A4N9TW/fSjj
	mX5rDLkUk4B2T3RJerDtxhFXE0DHU1g=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vtl9tCxY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ehdzU8WG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757932850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTDXy4XfBHDTD91N8anV6kwnawEqB9qYb9T/HA++yQ4=;
	b=Q4FQfkSD2qlB4Oyl+IIis+1fbkDdMOd4JdpX6GaQNSJtj+P4GcXEEwXDplEvgWhsbpdvZn
	o51yvS9M/uDgMn8L2ekebYvL5aA819gyafO9sWHyyuFW2kIJsBD5/yggoDGrGVIw9GAfXZ
	iF2WDGa3fPJfliQzqrdFIhTU5hlSOQ0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6fpr8014231;
	Mon, 15 Sep 2025 10:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pTDXy4XfBHDTD91N8a
	nV6kwnawEqB9qYb9T/HA++yQ4=; b=Vtl9tCxYqKIdeXr8pklMzlniCdYwvXsvzI
	dS/tj2c9egUMzjuZbh8OoEZ8N0YX5R8qMf/P1jBlzJtJvPZeWvoYtT53wgOcV04P
	zsuaPsWSf0yKuDK9ZA4wcemnERzO0Ennjxd2IiQYhptpV2S63u6ewuEywxKaldkD
	qu/aDeexbTj+JZvNNq59kb1zouM3gxQMDYYrvWZa0uUi3Ll2IrXCZc9vxVGvOnlh
	Z3bCCGX9Y+7Zk9zYLHMSIUvbxWUWyEKRWjV6xLjFC+mf/onnv9nrXFupPr8XCZfH
	WgBQjmsn/wKnK0EGLOWkX/KstEaaUpQUgK1CsS1ESuTVXPW2wIpQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yd8j3s7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:40:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8tDrN015288;
	Mon, 15 Sep 2025 10:40:33 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2h458y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TObWy0HZs/oCQmFvEmVR2UbvZ7OVrG7DQxsipNADkKhA1ctk95pTZk7FfvmRIAo/zdul/1xAvfd6vobIepvqIEH6j6OOUJ6qYc/BmvjGAHHbCIkZAuqszDCBy3HGpxRDT8c+cftgX/vVBzbUIr9QM5arpeOfy4Avmu9Agq6p+ndhHw51fVKdbtRfvpZMh4aO/dFX7esj81OY73Si7R8orzEeU3BZZiyVLMrgd3mpJDXK9gZNUg9CHyxqPVgrdEqEcMYLOa7qc8VxWg6rMOGhRth8Q8gNoShoJAs3JPrrzs6EUOuOtBGEHrEFvGW3WuIzDvrBT058b4GXNS81Lj/mNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTDXy4XfBHDTD91N8anV6kwnawEqB9qYb9T/HA++yQ4=;
 b=KjLCy0cKiG+ekaAUCLtWRlSZ1EkV8yjiBim7tjYIDl2Y3bdP611kO1Vn6FeTSBr+F8TT/vmPY6PLTC3UVT+XqDIXVkJBKcQkIVrONsQ3i/DxO2EJiQWlTBOyhPwDC3zAhkmezDkODvSb2cf9v9e5YtlccZrKsxHIHzCjFv+OfGxbhX9qjMRcAZCguSBV+hhCcPZ4otcm3MJnxTMFDR5TDIiHXe1b6aZhRASDBGIKGDNi1Frky1DfZ8Mg3qB3uEeakK0hmLQwHdfvIfIpc1g6kBBsZHXhv8hbcwQ4QFgLNOnLKA3HQW3nSQUeiaYi/NeJ5Uu0AwlblyVpAaMhjHqn6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTDXy4XfBHDTD91N8anV6kwnawEqB9qYb9T/HA++yQ4=;
 b=ehdzU8WGY4c3msyZhuYMhK3pzGJSo0eTZWgX/0F+fn0tAV+zFyeJIACHb5LDYUpCFaof3O4LStLRKxuCy/AC4Xi0H7OKNXV6KWpqRRDrU+T2viOTa6efVjHB4coyYzA4y54/S+lpmcSxdkKUk0xwIhUQTcdigV5Ui3r2mS1+mjE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFF257CDCED.namprd10.prod.outlook.com (2603:10b6:f:fc00::d58) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 10:40:29 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:40:29 +0000
Date: Mon, 15 Sep 2025 11:40:27 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
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
Message-ID: <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
X-ClientProxiedBy: LO4P123CA0165.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFF257CDCED:EE_
X-MS-Office365-Filtering-Correlation-Id: cf47cf8f-c46e-42a5-eb0b-08ddf4444a41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WlhGSTtEcfawnF/lKAQuKhdi8hES29D7nl0Z0+s4f0fvfLhol+9eKO5mmlku?=
 =?us-ascii?Q?2/ikXCt0D66yJN+96Izg4xOrjXdzABjP1iWVlUWiFhPOIm1MFPmDRhAUtREQ?=
 =?us-ascii?Q?oV/er8Wo6yQlUIolC9McjSXl4jfpxvrB1g9ZLDnQzAmYl9IvcmFWNHKOp9ti?=
 =?us-ascii?Q?7HhAeEkZNvRiOGiwv5R2pTVx13meWDLYawApWlIPJ0zlfYjbM8Tgn36Iz75b?=
 =?us-ascii?Q?1zfF5IAlBkLcletD+ndLl099D9EUw+HBPjPC0vhlNYkanXBbZoGgb58BDZg1?=
 =?us-ascii?Q?wPKrFXVk/65IvRK19aByRBoSyZjosd7als27HV5IRuWduC/IpivhkNzEqcwp?=
 =?us-ascii?Q?d5oj9tuI2QXxUXwPjUBOD36TMsGO4mjKn9J+1qZ67WwRETBcmt0IKGD1yWwj?=
 =?us-ascii?Q?kdRkmpI5m3WIt4lR9/xgN9DknKqnoGPTha9UHVN2A5WBb68kLzV8tZSdG7Eb?=
 =?us-ascii?Q?f9akWemfcrFmYA+S87SI9z7cdtHV64c776Nh6VKTDlh97lBMjf8eA+qbF4ni?=
 =?us-ascii?Q?a5lGZwL26b8a4/d3pRuJLX7UuBvBjJ099JCiIsppFWCXfBNPX1zKcZmWuowT?=
 =?us-ascii?Q?SGYEcddnZDO+PUlCsiwJSPtGuBsQdeudT/PhDDeV5/5PUvzb4rdc8GnMNObi?=
 =?us-ascii?Q?X7YC4VRxO4rUb8RP47nhjXYDI6bNOf4nrhQU2SWSYGW4PevF40YwkouguV/G?=
 =?us-ascii?Q?LCUx1Zh2bXxwXOivN3dMudAKrbR3R1hmmO51IKTLwAcO4XFki/DWE+WYs2Kf?=
 =?us-ascii?Q?hEKGGkQAiVr6u2z7+WhDsA9BV891uuejvAFnwWzLQ+YjK7eEdiIgBK5jKZZZ?=
 =?us-ascii?Q?hNOIhK4W7QIxaxjY86swrKXpxR7UBgJWftnqycTEoEcZyP8orwyeqDkH/2Bu?=
 =?us-ascii?Q?83M3P8o/ZqhrgWnOAmjAA/urEXm0w4ozaXM0u9nFsHU3WtL6mWsnwl2S841t?=
 =?us-ascii?Q?tgQSkMkj3SwD9PNjbzrzWhSEUdLTGhadmmMz0EW8fjHZ1h8un7OxfcusylRK?=
 =?us-ascii?Q?bFwa0a1Csm8TJ0ypbxKcRKQgyMvTeumCj7c7WpueZ/DAgr3Omf0pbRIYdgV5?=
 =?us-ascii?Q?8QTNzIKdQJj0d8Md70MJHKQ2MUg7IVQ+dclfEDmyG/93NFWhkTEgppa1ybj6?=
 =?us-ascii?Q?YzlZmKPpFFKOzGXUbZYHerqvTi3N6QlzdoMhl7keSxOwQIjK5XeNJw0A+30b?=
 =?us-ascii?Q?7G0zOqo0xtauOuDpe7jarfzM7UqsQZV6sq9HP03bPwXR7x5L/x2SIN0yOMrk?=
 =?us-ascii?Q?Bchdxhv6jzh9xjK7lwNr7bJTIYNzGC876U8PQJJdtC76ajQ43Ox8jAC6nutg?=
 =?us-ascii?Q?ftrkCp5KyYHP772BldSElEW5gnht2XxpASIdYdLjLjCm5tzowojX72/7xgnj?=
 =?us-ascii?Q?nlNqHb4aVdUWDuUvTCBzPrawCanbXXw6/c1mcsghqQ3bzKRLEKDGZZjp01j0?=
 =?us-ascii?Q?dimYi5yxhLI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?engoOJ3j/+b2Y9BQpOQ1X/CtN+6rQC6na18YhOPtwo9hY6ChmfN8YFZHMfdD?=
 =?us-ascii?Q?O2ljaPTFHO7OntCuvYU2FhzzKqm5Oo1WEx32zazkmD+tZzINrLDVpj8zCwkK?=
 =?us-ascii?Q?xg7z3rVogx5pxMylK15b4UQBSsk9JX+5CiAEuwrpxujOXydzZU8TnGk5dzMD?=
 =?us-ascii?Q?4EdmtLqkOJbBVZMczmpXgt9TyeaQ55nPURzVUyxqVtfDjRZ6dI6vnJqybkZa?=
 =?us-ascii?Q?7dYR146OV1x9SmdmFCDgpgkrq3PZY5ASeKCl1yaka1164jA1Qgza1zEl7w7R?=
 =?us-ascii?Q?DH1852PfmFjoFWAzxVQKK52odfttBi8XWYj0WoSiI7tqv3XLWnZyoia16Cje?=
 =?us-ascii?Q?JMlh2jOn3Dkzc+MlcsKtSykVg6QSj0DQ/degLdyF3Br3NdsLhaPo5e/KeTLv?=
 =?us-ascii?Q?LuWZYekwxv4WN8G2bunOFB7mytg5Ij58w+OrcCcMt291yTXzIKdLxVd+hvTf?=
 =?us-ascii?Q?cWt3R8FkzotU3ofr/7iPC057eFHzX6/xgLWYaxcdBd0WgxR9wuNVHAdEQQJV?=
 =?us-ascii?Q?JxnClTvxGLU6L810qdVYDmsJfKZlxv7opx8LzJJUz1eu8XJuim4wS9fssyYx?=
 =?us-ascii?Q?IAntcF6ujs7Qp+pxGTRu2PpMIywTmF/OR1ykOCU8GltXPbeDqG6+ra2VzI8H?=
 =?us-ascii?Q?/zvrDSK2F5tC4P6Bais3fVXC5Hle9FRB4olKR7cQyjdUa8A1OoT8OlpXMWSm?=
 =?us-ascii?Q?uyfVQyyRGa4DnE41LxbYp9uyxUZs2BIJakNtPXcj+skDptKHYdQtPC33KGOY?=
 =?us-ascii?Q?yipK7QaMvjlTPHWFG49yatOXFLUpVypIBoF3RWsAtcm28/euX+LfKKCdXoQG?=
 =?us-ascii?Q?rwLD+kh+wU8b5QNctcKqrG1u+VArR6AoJC1V+lGh7kbuN8wDsUXgr22CqPhi?=
 =?us-ascii?Q?GpklMbGPiKh3xKVoZMNHe4xZuLe1vJG4oZ9FBwNpJRq4X8nO9psBNuQ9h/+z?=
 =?us-ascii?Q?VnUFCqCaUh0OTfv4laNvtwgU7OhOmD4vXcvpeQPLNmyQQIj0+U2nZUR4gBV8?=
 =?us-ascii?Q?dsZL3ZEvappMJ1cRqxMns0V2Xpm/HXCBaA2HjW5PrlADrvqprtakjca9XyZ1?=
 =?us-ascii?Q?oprIPnjG1l1w9pkKPoBxSX3JAdH31oWASRa0qPQrDDZmueTwRjmOlg6JrsPH?=
 =?us-ascii?Q?lgKIuIKfkzyWIkHdRGDoGXYQxEv7ajqpRJ11rmjo7T4LBV56DtXrzyfIyWTw?=
 =?us-ascii?Q?Q9A8RDIocMOM15sWxFSEHoKpsuYooyd4JmgCOkMBXbUhCdnjpsI03oFhtx9y?=
 =?us-ascii?Q?wNNJC2CKNI04Ifv9gU2RHo9d0GBDAP13zbRtiep0CTbZ0JQQpdNhZzL62DKT?=
 =?us-ascii?Q?xxvQ2vaWhjFzK0CCu60b0GaZJLsLwCH8F6ff4q9At+PnDpJ8pxdQAhCdKCIs?=
 =?us-ascii?Q?/slIEYmSsVADdqIP+MEQEHrqLWOcmZMHUxTwgWN6eGsk2o/4NBG9SiGlmsrG?=
 =?us-ascii?Q?iUG+Xmw1kAbhRGg71hsj+hnm6C7EFn8FNTXW5NT9r95UXYhgGLvXyI5QS4Nr?=
 =?us-ascii?Q?nXfFJUWzAeOhShEHj+Gkun4ZC4J1JdkTPyb4BIzJcHGMpzj7M/HxYDT+kn5b?=
 =?us-ascii?Q?7vyZ3KawatqONdckXnYaDgm8EbWqwp43OTPDrIbztDiBCZjjCsCykuP958g0?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wm0/4SHOyECoAa+HGp9vfJeKSovXnLbrW+P/szIjh3f286CDwGkANAOZ/f5HJyR3lou5AV36bm9jgjDYLhSXDdb/17gt+yY77i4fi8UlggkFKVerBbqRM+mwxwKVLr29xcxid5HfPd2XSLN84F8VVfqdeM04heBGVKcUl98DJe6OS4/y1nOInvyY/wYJozLmwl/fBsXaJocN2DGfya42ElXqANaFAha8IlyHJJpqNyoMAJ+Uvbu85IL6nTf7UX7zAGR0WWPEaLpgH5ucNGOWW1q4i973a8j9oAwhkWUGLcTUkwLeFfgXn4Li4NeviW/D7+GtqKpI+r443aGBOG3x2ArzdS9LE3elDKM13tr4v/njOrzLY3dKL0WYApfK/2ueUbhCwFQq3pd+0dkWKtWJd31EZabD+iGMGHLCSxG+EsGN3Dgnpp/JjRWi6ws42wooWoFQSR1b0xuMzgHCYidBS1wT3qfLHZTsP6qUDXRQJjm//Fi8GwvGPDNLQ44ZhiSjHEwhQN27kq8y1HPEUBTlQd18OXhgIU4I5GGVwJ5dpZnOdI9tFA1yFbowao8DYsisgWx/IZya5CqVoDrx2CGXb5Joj3rrraOH8puO0zIskQ0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf47cf8f-c46e-42a5-eb0b-08ddf4444a41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:40:29.7864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHseP6ATU90fjppohCWO/U5SHvb96Rm+67BizOhUUOpIWtCY4Ji7GIRbjFZ6iIBsKq+AYoH2sYsN/5fIL7PbGUFmBXFLJX27IFlsX9+iz9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFF257CDCED
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=882 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150100
X-Proofpoint-GUID: WNvFdCerghuMuJgjqYcYKB8kk9zOsAS1
X-Authority-Analysis: v=2.4 cv=M5RNKzws c=1 sm=1 tr=0 ts=68c7ed21 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=6kv2_2G9i0vNTtKnQ5kA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: WNvFdCerghuMuJgjqYcYKB8kk9zOsAS1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxNiBTYWx0ZWRfXyB/+G8PMSqMD
 gRuG/tZOAlSgK0a/Agz1uqkF96DNWXjlgFCKt6szOc2bTIexjqCogZu2HFVa9pACtrrDbPd7Itj
 nYeF0x3gehm7CAbALsNvUwMKh4DHsUWsQDJKAlKwHuKsUuYSGl8NxWOelQmKfBgHTJfrMk3yQfw
 gDOrPjbB9vP12dwqVppCfvkLIWgzmV9JcXZt3CB3y5HNwFbASyhDKEw4+2PNIvRFVTrrHSgpCUK
 zZ8R2r7VokzShZkfV8k/028yt5Y2Mzu3d+DXkXz4A2sIjpchUmgGKwnoRFKV7AF1UAERFbk6ZAf
 VtN9RYOjGum3XXgOxvNxgtmlxeLssf1vCcxWYSnaLe7H8QUpRq72gjGFu16acZ94jSAXc12WV7W
 XIO+gjQSJepo9mlxyunlNiedO93xFg==
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E623540010
X-Stat-Signature: 5bqj7fkzc9pg8jng4tegmy19g9eowhq4
X-Rspam-User: 
X-HE-Tag: 1757932849-329905
X-HE-Meta: U2FsdGVkX1/+Y6vmIBEwQghK2hTBx2Qs5otfKBgXcYkTiURd92jbwMp2c1yeX/4cgZJA24eJqq/gFTf3GmJn7BFS3q8kw42kNcsflFH1uo6USRmURJYXyCQEpgiPvxnLpOfG0wB+FxpoKB0WauzjOsKI6t5Dvi3+VLr1ZfhXeA8MdBwV2Ord9dmd+gWJgB8gQNbtMCn0JcoIOjX+elxsim97PTRnF7AigQV4e4mL1fzmgTKeBRf++nfwVuemk11y8oJp5Szuc0E367/Ab9xVdqeVTfsTpFs6m/D1FvfbUsTBLUalHguAtRyYkB4Q8Vn8thacOijZamIJAoaejo06TeWk+cHAsjbzcLRRD6N17z0ZIKyjwCts1tqSBB9G+rvMSuGC/TBHPPZTTagV6vZiMmYGMTD5de42Ir79E9RfNXRS/7pfx1jUXdRh3yRDQdIEcxakW76H/CkFrbw8KdQjjPn9zBre7owaA6zHWux45nFWoMKwSqR1WcmwrxkqQLVmqSaxonYlV5DLMBzxMDghCZrnSc8hyTSdpHuyQBfFykWCqk3fb4L85NLE0m4/LjXLs80q20K8f/tKcLDOtfFi3uuxnuutGvb02Eej7wk0OLrdZL/bci+63qxLOMjrDYUJBW01w3UmxW//gePymLDCrIR7L8bNoNVYALUBJzXPGDvAKK3sgeiqHgj3P5jUWDhxFH745LihRn3Cfpf4ffHZOA3+g2rROA1aZQa42N8bADekIfYpxBYRc1pcQ95suzqquVpyO4Xa7mAyIlt5t1uVr1kk2yrRy1Q8xUcot6kl7A+7o8Oqe1LjDyc3vczs/MNbIUAtTJPkUE6B3w+Vmq6zi7u+s539tKSykZI944SrSq4ug7hlzmEn7jKN82qi7syG04SfmQWIQLnUVHYn5fcXKWmfxM1z8Z3+bpzQbP9sNjTuBNnGCln2OheZ5AZUBGN8kAMyhyYHeWl120wAmYC
 OqjYw6PD
 Q+QBRpJTXHuRWJOcpH9JHQI3dnuR4HCSzmqNBZ8tBPJDxSW6Y/7OLvfDKmCFshfXKjCBYXOcKmM+I3B/gTeoGrLii9gLWlZLvinAFnt4WOi4+35q2xReDcGnBzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:35:53AM +0100, Lorenzo Stoakes wrote:
 > On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
> > Initially we will start out simple and map it directly. But yeah, the idea
> > is to give us some more room later.
>
> I think it's less 'wiggle room' and more us being able to _abstract_ what this
> measurement means while reserving the right to adjust this.
>
> But maybe we are saying the same thing in different ways.
>
> >
> > I had something logarithmic in mind which would roughly be (ignoring the the
> > weird -1 for simplicity and expressing it as "used" instead of none-or-zero)
> >
> > 0 -> ~100% used (~0% none)
>
> So equivalent to 511 today?
>
> > 1 -> ~50% used (~50% none)
> > 2 -> ~25% used (~75% none)
> > 3 -> ~12.5% used (~87.5% none)
> > 4 -> ~11.25% used (~88,75% none)
> > ...
> > 10 -> ~0% used (~100% none)
>
> So equivalent to 0 today?
>
> And with a logarithmic weighting towards values closer to "0% used"?
>
> This seems sensible given the only reports we've had of non-0/511 uses here are
> in that range...
>
> But ofc this interpretation should be something we determine + treated as an
> implementation detail that we can modify later.
>
> >
> > Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
>
> And at different mTHP levels too right?
>

Another point here, since we have to keep:

/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none

Around, and users will try to set values there, presumably we will now add:

/sys/kernel/mm/transparent_hugepage/khugepaged/eagerness

How will we map <-> the two tunables?

