Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FA8CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B5D8E0007; Wed, 27 Aug 2025 11:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803048E0001; Wed, 27 Aug 2025 11:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA628E0007; Wed, 27 Aug 2025 11:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0858E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:35:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17B81139F42
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:35:31 +0000 (UTC)
X-FDA: 83822936862.04.558BBA8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 812141A0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:35:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="LF4/6HRI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XiM+8l4P;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756308927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NhpwuwW3iuoq37WhwdqP0sjLlUiZwf81LNSSBmrcYE=;
	b=pTxUnYayEh8hmSTqasQ002ven2Cx9VNm1ry1SoZoNeb9Ni9a1eHynpq/Qx/2MdI9g+BrAe
	ZMKffBDCm7yvNk3KlOxoepQC2qwP6hzL7/3YmcJfJKRCQJi/EaM+3abEA1YZw/kVuwY69f
	Fh5lEVR5C9GxcnyaYKwE9LFm1fBU+HE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="LF4/6HRI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XiM+8l4P;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756308927; a=rsa-sha256;
	cv=pass;
	b=4zzou/kLYcsCYlW2SJ3H/UlnGD9Yn78HH/OAEBrEloo7ouo4gd/FHNc2U4FwMvwZLcLqcO
	dENDF2xp4LXUluVmGScD0yc3oXxKdPRGbXRtvssJjx2Mt+QotSZ92+UbkPF6+w3ACBFb7u
	DrW3BSx8LOGw3TDl4m1nRfDNoB46WfQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7tvip001213;
	Wed, 27 Aug 2025 15:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6NhpwuwW3iuoq37Whw
	dqP0sjLlUiZwf81LNSSBmrcYE=; b=LF4/6HRIYsEejjW4ORBAuRlcZ0xezWSayb
	SkCSEG8JTIj6MqJCK1Ui1LZ1BaX9wKqzQtWzqCM5prydY3V2M0EXiV68MrX2RTm1
	76h/3mZpufGIQ9Tfnk2jdcrehTyLhwEfX4BFxdO8ZUKIaQLtt0HfNAYctfyYEruw
	ndVKP3qNwpIEqjIWSX7g7Rh1V4LdNDh+GX95PqKFfAybRr4BqPbla8dGKmQFkfeH
	E6+6MoVh/YGUNoApq/kUG0Hwf695FdPRhq2eSwNsPJgvfWSBXVphLTEqp3eI6ECp
	wb1REKc4zHb7WlbJCz0IIL1MZ8qfimAhV6SDgl6WSVc1LCU9W6MQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e26t88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:34:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RE9VaE012168;
	Wed, 27 Aug 2025 15:34:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43asdpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FnoXh8FKWhTpJbH9B3pjGB1EuyBWmQIsNrlYg7XWq1sNp3LOl9X1bv7datXnPv3PMuca1WOIw2420o9c0aKFX9XbZsIoAC6PlgDlhBrRsRVUIOz85L0vnsVmkk7UHfegsDz/B/DfWAwdu/+nqLSXN5lF//MV+zeM+Kvlv1ggYum9K8XlCZ/mdCQIjsp2VDeT89Wdw/Puknfi4w7m3CQOCKLrqEnGe5kAMCgvMLkmcsv17OJW+S97sNPMP2Wv+xDsy8oELGyoy+hmiE6ave+IzA9HkEum4hzRFgtrLZj+GSYIOcat7rYT755+6LtV8+G45hU/Ha+MeywOy8TSguWkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NhpwuwW3iuoq37WhwdqP0sjLlUiZwf81LNSSBmrcYE=;
 b=F59DKUmN4VL0b1CxFaVzz4bWlkZ/azVcxnwswj3wIkPtyMDKK3i9FSqK0Fti0O7eR+SklKGFqhy9Cr83m8olVDU+aMtp7wQdXAK7D4C8a4dzk5PoH9VcIKI1IeF8VeNJj+s9hyQ90F8qpnybLJXvXmXGRfOIwLfS0RPLxSF9a2/Xm1jSfoFUlwVmeDpcYwhkUrF6V8UgmNwmo8oyZQdA7noJyZ+U2A5kQjFu4NBNK9eBblSqrOzOTQ7L8hjP5GK2uqPMZBo0Omwi3aPfLBKAk7pCXpg3XqNVKHdiD8wNjB3HCc/uYX8lgM/FicHr1g2gX6GXps3z0ZxmklMC703T8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NhpwuwW3iuoq37WhwdqP0sjLlUiZwf81LNSSBmrcYE=;
 b=XiM+8l4Pt5qVdvWV/8J4BM9Pc8Lp359ICSCFNHhSftuYKE7zNhEAXWA4TIqaLH1EnVHxghAEIttOmjznuZyeDE2+OTrA1ScsJqt6Rec+PYtOaf/JvVA5fYWPqwuQGLbT+6UBn3hvznKi9UbpT/276snzMilKz3upVLJFZSDPA90=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA3PR10MB7041.namprd10.prod.outlook.com (2603:10b6:806:320::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 15:34:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 15:34:50 +0000
Date: Wed, 27 Aug 2025 16:34:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, willy@infradead.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc
 bpf_mm_get_mem_cgroup()
Message-ID: <299e12dc-259b-45c2-8662-2f3863479939@lucifer.local>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
 <20250826071948.2618-3-laoar.shao@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826071948.2618-3-laoar.shao@gmail.com>
X-ClientProxiedBy: LO4P302CA0042.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA3PR10MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be78dc0-565a-47db-9447-08dde57f42b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZIijCu1tDfq3NwTFl3b8X6kQTFqS8B0CF7Tm35KRXks8E3fnTaHcWqhcP/qI?=
 =?us-ascii?Q?LLGpMyluTNwMqXzBMyWqPItrpbzmrSkc9lJEJHCorpWpGbfmxxQ4W26gxNjH?=
 =?us-ascii?Q?7qVz/MIhNv0IAmGKxd6UGCoQsPgYip4dRwv8hoNNADFdVsCSSmUh3RaZIieB?=
 =?us-ascii?Q?o2gy6eOoQoYPvNKQ0iHWZ7GP1BIxmqwwM+fPa7LGxd7DVESnDSs7oAYI8T6M?=
 =?us-ascii?Q?5t9gLYqB1xpGsdi5VA2ku7ie9B1NajVG7F1FMJ+nHgPFzdjS0bXG+ueEIMc+?=
 =?us-ascii?Q?C8uFpYPx7GdSuj9q90RAlZdo/UkPbJU833xZK5rv4qs2HKb5M4XnR/+0eJ6O?=
 =?us-ascii?Q?wM/IiRgVZ+O3KhNJjziH8RALDG8mfitIvEePJOYdLQ5wDXh6C2pzQZNFfeJb?=
 =?us-ascii?Q?ADA7c8EmtpomaK9uORvhQZOVwqn9ZNiUad+fQcTOwDKD0THJDVmxHvH5FyQs?=
 =?us-ascii?Q?vHVOjdHZRG7bSNZcYJvGnBTaOnPIWdAMG2VbRydHRkf3fl2f1blzAzXgpip5?=
 =?us-ascii?Q?e+PUP7+xAYO76EHrpvxVg2HrYYeb0R9kaq/fEpinUFzdTv78tm5HQPKKJG83?=
 =?us-ascii?Q?Ly5uGkVqvag3C2plYp7Vo+CTsap7gFp4TY/xgA459S/TmnL2XlEeF0Nn5Lua?=
 =?us-ascii?Q?l66pHV06i7bWl5U19icmPsG2ZruRtUnRDy3T0d44vKY7NTDlzZ18BCuR5+fv?=
 =?us-ascii?Q?fQGjRJCJXeroWHfdANI5fUnyHANb96Cl0wr8ViQwFqX3kOjpwfejZA6mGlj8?=
 =?us-ascii?Q?YWRJUk2eWNiBurOv0VkrKl6ZT4k8Vyk0Po7PK4rH1AttJiklsSyNH2PJ/hIG?=
 =?us-ascii?Q?cAQJd5v0pgBoC9lUCGgWDfrmxiMbVkuUMkffUr6BgLXLd4RpGsZu3Zc02pW5?=
 =?us-ascii?Q?4sDw/GE8pwhC9Ad9dUcTv6T8H1peG81GiSJ4aKGeGITMkEBwL+p9PkIdZCvs?=
 =?us-ascii?Q?l7L/9J6+Fr2mPZ7dl0TOFmNlqHcL6Fc7IsIDt5daV8VYNQONlCX0RWE1mwr1?=
 =?us-ascii?Q?H6Z0tb3FAtfOJKU5c+x52buGNPT4227eZskjOrdmHG6oT+ZPRoldi3ID0VVh?=
 =?us-ascii?Q?6URoLA745PM6vWXz+ncdDF6r2hdRc+mUUCNXc0KkWEZy6bXsAMtbneLpBjrS?=
 =?us-ascii?Q?Ugx2AiSEYAk6zBaPNLxN1VUjFI5ilmIb2+NKVn/0ZlSx6jNTUVGYQy0YtrEI?=
 =?us-ascii?Q?ACaKnt8GYN3m8qCRCyoZPXbBGSPqm1BV//PR4HPT7FxSFxm5befKmg0ltCrQ?=
 =?us-ascii?Q?L+f5zmsqI0pkkYDDKxo1rBh9aI6SCUFoXo2OdaH4nBV5jL+KayzTEmOnLa5z?=
 =?us-ascii?Q?UA88jsjce1ZhL0M8sp87+UL9+6vT+mS22rqLOXBKbNXQLZc22e4GIjnwGR5O?=
 =?us-ascii?Q?S2ttEK0VnwlMWCT2oW9UggdoP16AxK3OlHmpxTdlaNUS426LIQS6t2WWVSbH?=
 =?us-ascii?Q?X2N90Yqbco0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?90JSxzKeIPfiajBZrpi3xPziq21gHfkOhHRzb4uVFYmzREiW7lDTLjDgb/nm?=
 =?us-ascii?Q?KQmeBHa6JsQzOAgm0N/N4MSR5RFIGUClXkQg0EhEUQTq/HNgjQkTPAj24ZPk?=
 =?us-ascii?Q?aJ13bv6YJnviy90c9nJEYMayILFF56MXlHNUwoI3We6gY0xToPC5MXCBTtZg?=
 =?us-ascii?Q?BNcgs7kIQED6uwC1Uo2FiJuBgtRSSZ/nxY30a7vU+Zg7XOuMwH9AgCaaYK9S?=
 =?us-ascii?Q?wW/X5t2OBupotv0DnW5p/1ufRe3Wkdcd0X1Qzkjpa5zdBBoRkDxx6Oz3bkvn?=
 =?us-ascii?Q?7SCS04OBkXp1nsLjmvrY6fBApd/9+kY5PwMTHfuz8A3VriHThLXh6Le2vBuN?=
 =?us-ascii?Q?5VZeqZvjHExymka8bHjwmYvOJVyZH1zhFjYUt186Uxa8xtjtLhgyTbjL/EHW?=
 =?us-ascii?Q?aadR2nfdZ0Ue3MKwr5TKwbzCubOiIdmB+YI7LrY9VLvD1xmg6lrPeGaH9L96?=
 =?us-ascii?Q?v7mEVk+wcH5MR3Jxh9uyisiCU+msvpQKRgPyN6xPwBRfD4xi8luRZdezvS+x?=
 =?us-ascii?Q?TfsAe6C0l+udvepVYz3/Ot0g08k5RMQpOWahfWnZ9QhVqRW3uLfw/G07v6s7?=
 =?us-ascii?Q?iSRC/h0MyWA5QyWoaK4Twup3TxbfNhp3diCgi6HXjwqQqAbOlbUU+ike1IsM?=
 =?us-ascii?Q?yev27IKrJmnChIedY1bsDjWqWSCukWfFyGjyzSUJqclZvoIpDD5hrMW6FcYL?=
 =?us-ascii?Q?UdAfbdrpRuwCN6BnOw9z0/rMkjxQX4xLtOcqKj4kg5C9IE8z7Wu1bP6MH5DD?=
 =?us-ascii?Q?R2fIE1ctRufYzJrNSrcZsjIqCpvzU9KYAgDfwEXOSwrkcCuU9E7m1om8ms6U?=
 =?us-ascii?Q?NJb4KaUwZGLIzvWs8M+LzyX/GXEHTdymD9/pAMONDZRTquVlwyE9pP9m/AdZ?=
 =?us-ascii?Q?LF9kF4HOUDth+ZL/F88TOyuNwmecPN20OC2e9Doe2CBarvrB6JqSYo5DNOBp?=
 =?us-ascii?Q?wJxcmjZU2+9IqWVClqhNBU+nztjZ9+t85jb57ckaV4WjVXIPxTz9QdhUwR7G?=
 =?us-ascii?Q?d3agwpzB1IT/ypPrSwZEiFIAShfIwoUHs0D+QORUQnOV5kiYhzY/LID69MP4?=
 =?us-ascii?Q?4/ydFeoVSbJuqS+yKuAquhCIXHip3+iAViiONLF1MJ4qEs1/hdzYzn5WndrP?=
 =?us-ascii?Q?ZQ5hAoisrMrXSC03r1nhrXYMkHXNiOOOrxJJ5uWWlN6BfmjzKrOnHrFXIcr9?=
 =?us-ascii?Q?RTlhbJdLhlJjAuamqETkJmWuO1/G036UpufZKdSfvJ3H8AV8QovmvawzKkYp?=
 =?us-ascii?Q?6oU2gnbcNjvmt5DysZBx5OElxmeGEHUXtEYXvd3jkfTmH2V6OdvBzszKAlBU?=
 =?us-ascii?Q?FR7nhMYOzng0B8e0JU09n6Os9bIGtHqYIwiwuVm7SaynSknlfgcB6kzJ15GQ?=
 =?us-ascii?Q?PzAhZIiKt0u/PKbsQmoTJkWS2fIXimzeVhxrjjzLoCrSFm7H65KtgRfKZdXA?=
 =?us-ascii?Q?SAjFkXThya7dB6606N+yFYN4q7bo3WqDpYS0ETxOffW6XJEZOgBxj7vdSk15?=
 =?us-ascii?Q?17ST9xrwffRElEWVDtvAuk6MnindqT3rQWbV7coJZa59vURgHjnvvwvj/tDD?=
 =?us-ascii?Q?sK4tBdMhnEVFKgrYFKZPkJYd639twbWquHF5w9YSWoWxueEEiQhGrXz3ncn3?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+Czvy2eZf3MWEyiVANYhT+eX0CDWlO6hskVHBraL3M78NEGHvcjoFAodchTL10cc8JN8N8W/HJygUW61wo1q7VDQ3sJpL9ayp9Fs7XhJO9Zb/+en7mSm2zLb8G6YUoakUuxAkpWMBwH3YURulzUB5rMD8mNalhNzEf9Wh0Q3RmyB0DuQjHjRdxTMdetrsGFsuHqt/04S03qxg/vfGqNpCBRwgzwe2geMKAbmlS0MezOOOPCbUXVdDO2WN0Hp79EPuZumMIaNRquhiZL4QPletu2nAttmEV5dnBZwOP4yiavJUdtpOHL6gZ1XBjH3fZOcIfWqfUX1MgsDm620pTvGnaTpZY6tzfvQh7N84jd4KfC9AhjipHUu87Th0C3lcftflydQuR1JkEOxP6F2Gy+VGxas8fOSH0AOZJVjeG1ql+tB67pCfPzZl8lE9HLndS2ogk8gqEq2bBltHi8chDJFLIYquiG5+fDCYABT9rayDLnogUwjGbi9gzh7hnclZAoBDEFWjNXBH77s6B0FqM4HpbQAaR12JaAJLkpamlqrN9dX2tTBolCISwLfXVmuz8sKdClg3qObOe8MIS20srXWEUeDH7BTgz1DG73goFUOWpE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be78dc0-565a-47db-9447-08dde57f42b7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 15:34:50.0067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXqKCfIvw3aJN9V+oVP9bYsklVPfqE/KdZpT/MN9Mj8nBGD5nVFOxbfBr8oxQlwLOiWpsPWloyNHtCVhunYslN43qSIIRLJI+dion8DUg3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfXxsqJrFrPp77B
 ESRcxewn+pdUGtYo6wzVacUE++E0op8wVg9gpVfnec9Zh/kHnaCgY82pBHDmeCU6I80TaJpNhda
 vBBAKkbjjywJgV1CUddTe/ifWswgNv+w3C+sLCTN27RX8gs5ZM4Ub3UgAdG0kJ8YY6UQS6EBAez
 UnvE9mdPQ5+czC0UDV7cq0sZ5bP4dFqY4tbIJbz19rnreddMH+NlWp73S6vdTGG5Ct8P///ps4o
 RnBpb+4P+FO8DFJUWdUXFoA/mA7HbLcas3pOg/CDbx86DyeHVuHSRR8k2rW8MOqCnIPhxWvf5hV
 ZNcadtOUDSjxf2hb8Q1jSpncR2ELkFs5u6+2DZ6mRG7glOWEEI88MRqya4P2OLLjj7Tc7eSiy0u
 SgWApaFx7vGri9psUUn4NEhzP5hKGQ==
X-Proofpoint-ORIG-GUID: yiyzEV1W3NEHex5SQEzszF8VZpU6lBrY
X-Proofpoint-GUID: yiyzEV1W3NEHex5SQEzszF8VZpU6lBrY
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68af259e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=85b6-gphyTJJhaCVbR8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Stat-Signature: jx1us34rdmtrgka8shnpsy67q68h3i9h
X-Rspam-User: 
X-Rspamd-Queue-Id: 812141A0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756308927-761852
X-HE-Meta: U2FsdGVkX19AVkyCSEhsMNI4AKkYKK0CPelyM8xIVeRjWJ7+2DBXLzo1irYtiaQMPJUteDM52RGMmB5xgDx0rBqfAl2X0dWMxgGjMtbfpNzKx4R5uKLtv5LQY7hX1h7x/TO5j7xP9Wd7jSzq3uh/FTLy6FaJWo31DMmPc0RC7gbwC8FFnB5qCij7f0TVGhuThI1bDsLM0Q+uoLvPTYn7dQBrPLAu/G22cRJQgeGfwCiyoq8LeOOUKtHTGFSE/tJS4kXlqIfP3gA/KO+OsLeuFuamJ8zMmbsjlU44py7iN+s7i37FMkKq2H8lbmXDtMKXt/sYkteIkvOUs33mXP7+Z8izOJv1b/1fe1XxcP1z0Wxqt7nkrchZlx4jBkbnehbHo1Lal5U44v5LtUkGRc8WPIrqXBSnzUMJQ5McMU+w3QvqXBEaXNnosPJ423jNsXuNKCrSjjTLz9NelN2Sy0ydB/98DmKm5lh2ejXRclT4j8XgFFilHqEYw/yOPoL65qW1dy4bloXML6i9kbaCpijcM57JOXZePRXRzUGHeVR5aC5rPUlyf5Pzu8G8TiIWs4gZBpMzj5WlgoPY8kGM/2YX10FImhiAVBnuFd08cYZKYSXlyOhyfF91vDyGyiYFwlkAli9WpOJ59wgfs7wCfY4CBQsAI6iL2KAcVkeCeyUOh2RMAYkssrrfk3bp2DjSCDXxcEg/lPsKbK18+ntV+sXijyAoESVnDG0mznSzWY7k0C6u6szI9NSNBeDpiOmPaDqZaAj3SZD7qJbBcZVQC6x+SBddCaq2rk1pLJbjrG8XxUY8X0k7+oOpqBzRP6HkHg5nS5rH3Pm7iwYF7Nyyv1s+YaHyvl0WcBpSgOp7AGOmCwZLVbckBrRT65xLmZtz8bKIvOwOoMEOR6qSY6CIg6m8Z7nhPHIT47Ru/6DM0IjhXlUCafx+4YLRSqrX4aof2EvUaA+2nDNgranmtmu6iSZ
 zy7MH4SX
 LTG7qhgHmsSzPoa0+t3QaGcGB982lWjHkw5YqZXhm/aA+N0AuiveJZbpfg0UnIXfmcO8NENyyxaPyIE1mV6iFzUrVe39+iW5kbLeR/OAMOnVI2o002g8kfbxPBzYCxUY9syJdW8F4dY/L4Eo5dt0XnfrjU6iBAYbhWh6TrNKzqSwQPmnKMVvNMmTVKeH+/8XbOMcBX7COa5YAg7mG5bufJrqWOjFSJ8ygizB7vDqllUOAj0nZoeQpshqbKQ042V451YqcZv/hpF+eaQdEPRGsHqm5t+am/Spzy1YMHLbTlUMWK7UeMHEmHuXUTL/hwGmx0jAoBG+O6hNuYpViygS1Fn0cUmY3Zt/RCOSzV51ebei3dewpqnUkJWNFFccL9f3ZUMqJr0q0ZWYP0gfd3VKRoTZu5tBt3d5hcPpvaGFtnRVzNtmFJdjaUv4lEAaIUUna5wSqnkvtIkwSbY/DikvxaV3wcdoFqiFTckYu8xXVd944ICG5z6W3LbRZ6wZKYwqzw75uKIeCaaybzzgo/VnEvSodL7bXbjp6GRhUvdJ8s1A/aO/OrI+eAEUVoHil8sBeI0HIe045kKxaw5Zy4Gbyhxx71n/0VK8HoYa3BHWZycEQxKcUYMSdYaGIXRPvVv85Bu4ch3gOpO3j+iEIGfAnbaO/H4wWwCGtOuaJ0zcRFfb1FK5HjoZYfp96ebs5BtOh+tScxUuRXSNb6iPvXmwNY5pxNCy1UUCQ29DOB6kBEcf+0EG6H6c0eVxZ+s/TihKRNL5CJkVuj5zH++GhImgQH7GaWy3nQPEToAL9obOyrMZMVxSnqAt2oo0vy+gk03pI9pLenCSADi8ZZheVB7iCsOWy/t5umuQHXeTz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc cgroup people, please do include them on this stuff.

BTW I see there is a BPF [STORAGE & CGROUPS] section in MAINTAINERS and
kernel/bpf/cgroup.c etc. anything useful there for us?

On Tue, Aug 26, 2025 at 03:19:40PM +0800, Yafang Shao wrote:
> We will utilize this new kfunc bpf_mm_get_mem_cgroup() to retrieve the
> associated mem_cgroup from the given @mm. The obtained mem_cgroup must
> be released by calling bpf_put_mem_cgroup() as a paired operation.

What locking guarantees do we have that this is all fine?

>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  mm/bpf_thp.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-

Also not to be nitty (but I'm going to be anyway :P) but I'm not in love with
the filename here.

So now we have

- khugepaged.c
- huge_memory.c
- bpf_thp.c

Let's maybe call it huge_memory_bpf.c for consistency? And obv as mentioned
before, add it to the MAINTAINERS in the THP section plz.

>  1 file changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> index fbff3b1bb988..b757e8f425fd 100644
> --- a/mm/bpf_thp.c
> +++ b/mm/bpf_thp.c
> @@ -175,10 +175,59 @@ static struct bpf_struct_ops bpf_bpf_thp_ops = {
>  	.name = "bpf_thp_ops",
>  };
>
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_mm_get_mem_cgroup - Get the memory cgroup associated with a mm_struct.
> + * @mm: The mm_struct to query
> + *
> + * The obtained mem_cgroup must be released by calling bpf_put_mem_cgroup().
> + *
> + * Return: The associated mem_cgroup on success, or NULL on failure. Note that
> + * this function depends on CONFIG_MEMCG being enabled - it will always return
> + * NULL if CONFIG_MEMCG is not configured.

What kind of locking is assumed here?

Are we protected against mmdrop() clearing out the mm?

> + */
> +__bpf_kfunc struct mem_cgroup *bpf_mm_get_mem_cgroup(struct mm_struct *mm)
> +{
> +	return get_mem_cgroup_from_mm(mm);
> +}
> +
> +/**
> + * bpf_put_mem_cgroup - Release a memory cgroup obtained from bpf_mm_get_mem_cgroup()
> + * @memcg: The memory cgroup to release
> + */
> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> +{
> +#ifdef CONFIG_MEMCG
> +	if (!memcg)
> +		return;
> +	css_put(&memcg->css);

Feels weird to have an ifdef here but not elsewhere, maybe the whole thing
should be ifdef...?

Is there not a put equivalent for get_mem_cgroup_from_mm()? That is a bit weird.

Also do we now refrence the memcg global? That's pretty gross, could we not
actually implement such a helper?

Is it valid to do this also? Maybe cgroup people can chime in.

> +#endif
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_thp_ids)
> +BTF_ID_FLAGS(func, bpf_mm_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
> +BTF_KFUNCS_END(bpf_thp_ids)
> +
> +static const struct btf_kfunc_id_set bpf_thp_set = {
> +	.owner = THIS_MODULE,
> +	.set = &bpf_thp_ids,
> +};
> +
>  static int __init bpf_thp_ops_init(void)
>  {
> -	int err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
> +	int err;
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &bpf_thp_set);
> +	if (err) {
> +		pr_err("bpf_thp: Failed to register kfunc sets (%d)\n", err);
> +		return err;
> +	}
>
> +	err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
>  	if (err)
>  		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
>  	return err;

Am again assuming this is legit BPF-wise :) Not my area... yet :>)

> --
> 2.47.3
>

