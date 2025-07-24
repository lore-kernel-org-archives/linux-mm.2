Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199FAC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880918E00A7; Thu, 24 Jul 2025 14:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856B58E007C; Thu, 24 Jul 2025 14:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E368E00A7; Thu, 24 Jul 2025 14:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA1C8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:02:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EE6513396F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:02:03 +0000 (UTC)
X-FDA: 83699926926.17.535A18B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7811420023
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:01:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TKNRjsGG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HF986pH/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753380119; a=rsa-sha256;
	cv=pass;
	b=Xm8ueUqXB0YvWklK0bKIriMNXB/Thh/yG3ILQeUu/L9dPy4/PLs6Z6kKyVw7mhOkOkdgf1
	5foSTWpwYsf/b/8h9NYfdcqo0O+kSObpcmWWuPIbbdSRIGCCJuQUXObyptiCuxZypN2s+u
	lavIsdJVdQc3IVyMnPVAZbjtga7roDA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TKNRjsGG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HF986pH/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753380119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQ6uGGaw5HpMBmO6CNPr8MA7VnnIIbYij0C0D3n30Tc=;
	b=Zme+R3/0D8FS1q/apdnGQViJJeiJqY1vkYvdQ2jqkdIoEkbN6xJLiT2R9yTHJ0KYhe0FKm
	lsdLGGKPTL8NsXAVxR2859aKVizPQjh3kl39XA3ZdawTnDQk0LkTNx7abCeRe7qNtF2RLw
	UTVIt0IBaCj90RGGh8fpWXnEuSi7Y/Y=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGitoT011335;
	Thu, 24 Jul 2025 18:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OQ6uGGaw5HpMBmO6CN
	Pr8MA7VnnIIbYij0C0D3n30Tc=; b=TKNRjsGGx4nib7Kphacd1SZN0hvlMgMYjK
	1QotKcqKgypR6nxkNW2px19LMyZ7WJFbRxKmHPmg5pjk0w0UMFrhgevh+RL9JWIG
	Y8WDg3UmOVgY0A/R130w6SK8TrRLydUfkF8YNqIstUHdiuY9jkRwBXlY0DukrdyI
	UxlCs0VbI1JnwqZwNVak8g+aMQ+DC0DfoVztXImZC4KB7guv+JPVfWKYyQR/vv8O
	IVLyHT38r3cweUkctlw5YbJG9wArtHKNViYCl+sfaSixz7WVoz2dO1PsgYK5waID
	dC4XFFO+T955rfhfGXly72tjDH5PeYUOV99PzESOmRvFN6lfSh2A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805gpt6q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:01:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGmLrN014501;
	Thu, 24 Jul 2025 18:01:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tjg6cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:01:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w0hH2AxMJl8s7xInIxEhTHr+ooudEEPKUMJPA1OmilU4A0ZDyW34ZaXzqX0nVwgt5SR2+i3axAtQ9w0aO+BDBshSFFa4snNFgNUhAeTwOomvykkm5vJCuTTUnj7cY539pGFa1tha/9cyilzNXFNcimPpzxA/d+DWn3HTqGa6XfFknXcO5DLQ20tjgJgV3WjBHH6M5szm5OmB0QhPNRoHvcvOKpE/eIfqrt6u29r/MJSeIJYBovSdSOhdgB1uQwq3IyxwUi/pzfZUcnnKupxwzL6FfR5VGV+JT1pVbdW1X83URw2VBlb7TdgxU2u5dyar5lwG46xvx+hEB63DIF4Kvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQ6uGGaw5HpMBmO6CNPr8MA7VnnIIbYij0C0D3n30Tc=;
 b=sTRvO4DOCUQQl+0Ud11CZDAGPHkoMQcNS8RWEwwMYFGCF+Bh5R/uLERFRQtFcVH6AtjUKEu3/Jlcoe4WcwGz0OytiPDB36zuFovstw209vmqLKvIFRTDblO+asIKCy/aWJ4HhKXESJ+IUndeNhrG3P0h+kCCwp1+UtMO2vwky7b9RYB9OT23/8p3hXNGwglTk7UPiwSUlkK/Z5ic62svsFwyv/+uiMKSvgm3KjYL5XIbYcFRpio3iqvBcFzRIf8zqqilP5sgHPNPmCsoh4qa7pmF/HQso+c1KMBR+bdd/mSEz7ePgQmIwXAeBzxw513oY37IWS8PKvZxCZfF0yiAjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ6uGGaw5HpMBmO6CNPr8MA7VnnIIbYij0C0D3n30Tc=;
 b=HF986pH/pBjmjdQAmzTx2FYleFAtUUqxYzeEXumtb1YN8pND5ipgQl8PBRVzqPxmZikdvyVDozr4qzTTiXfvDgHaWva444nUY5P7N+ID/qJzmfSnCPkwd910ygazS3lzEJMu14/dPwCwY5/6faTenYwLJGkJJkg2eGW++5KGrdg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6320.namprd10.prod.outlook.com (2603:10b6:806:253::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 18:01:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 18:01:35 +0000
Date: Thu, 24 Jul 2025 19:01:33 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
Message-ID: <0719992a-c436-4746-9167-03a2be81bff9@lucifer.local>
References: <20250724052301.23844-1-dev.jain@arm.com>
 <20250724052301.23844-3-dev.jain@arm.com>
 <83c00fa9-37a3-4024-b3d1-20e7749b06c9@lucifer.local>
 <0a70058f-e2fa-4f83-ace5-f58df589ac46@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a70058f-e2fa-4f83-ace5-f58df589ac46@redhat.com>
X-ClientProxiedBy: LO4P123CA0177.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f02c095-30ca-4490-cb8d-08ddcadc20f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bYpsTFq+HHYxswtJo4YSD0sOAx5UHzbaSLt5hTrT0YGp3EcMgFMhY+NYxW5I?=
 =?us-ascii?Q?zbtAR/yWfe+QoF5UXAgfprOWc17hd3TaxT+eyE0rmtiD12S44gqr46FamQmC?=
 =?us-ascii?Q?jc4brpTiopwe6Z8flZew9A3yqdVnNAG14CVNA9CnAwJi0kqXC3ezShVw7b1n?=
 =?us-ascii?Q?MSZ/tfERDmXWattGjI6TMru2qXwXv1xMjxcwboq3evvG9XyfSeDFUn6vUkgi?=
 =?us-ascii?Q?IGuHJq6WMHOLiC/KTGI9zYX4vXmzCy6lZgfmuJ6MRYWFyI4BREMrrtA5T9xX?=
 =?us-ascii?Q?3okjMPPTBDvGAe8zA6wweSm6F7DhRorbuRwLnCg+RPhTo4t5IHJUoNCKUsay?=
 =?us-ascii?Q?aoy3c93BpIYw91vO5xL1exukcxLXSdSwLuts+TEvlktn2OmiXhaSFLHPVI2+?=
 =?us-ascii?Q?N+sdr+LA/x/qYItks9Vgy5LtWkPF2TpKU+5nyYLeKB3YYwCTsmmkCCI7Jpz8?=
 =?us-ascii?Q?JygOFNU5SCnMx8L5DMnmLtFyz8kiRgh5Nubx18FJKhqSYaYD+pnYm9efVPCa?=
 =?us-ascii?Q?/O0OLn1Tqs0Z1lKGAZI8pgjLEAZNwCXLl1YqLCj+i4geH8gShQU5mWsoniNh?=
 =?us-ascii?Q?4ekQMYOds2sCOVN3VK45jenkYRd6bQNrSwbNj5rh8+M9eigRMCSjCnheureM?=
 =?us-ascii?Q?8PpOj2LRRaS2/bQTlQnHJkjSHNofLYZ384cO2aNlR75BJTAGFUStQ3Jh3ori?=
 =?us-ascii?Q?rqa+Tw9B30xqCQqUBEFRI5s9Barz9KyxcxOdAVaEC7EtOzReYW4v6bc97MXi?=
 =?us-ascii?Q?y+CWZqXpiP54UAiYYn/0/l79acvN90VN3ZxNQw1jqAJpSYxVfeNNpzeFIuD9?=
 =?us-ascii?Q?SsCD1lbnvLHwWrMB+SUCf9LQF4gwYviWh8y6408s+SIAs7WEd8MEty8mWTvq?=
 =?us-ascii?Q?F8t6Q876xzv2tMZCfXzTfEmInhF5GZMsF1GNf8Z9xyCtBSjzx6fZVsaOG/FB?=
 =?us-ascii?Q?tZjY/NFDYTfv6RulKxojmGVdODWJAsk/qsvMoE+O2H7vbc6XwT08oocJbLua?=
 =?us-ascii?Q?3ZL5fa0upQhYs4NjPKYHnZUrC0yG5w1xKeU2nrXbOH2662pncVQCkBTt/yVq?=
 =?us-ascii?Q?ddnHSlJDhiBWJIrOIfatQ6rvMZw7JeIp+pak4hwQKNnImdnVQsjv46OpY5Tw?=
 =?us-ascii?Q?USokxdIIhtlt4m5z2OQ5PSox+BZ2hvAstxtd4mLK6/SGkrX3GXGymUdJl3Js?=
 =?us-ascii?Q?qVdXcoeJLj/BjumXOxIDDSct3oAiJiwLF5ZPOgiPSJnA4WBBwh4izvHkd61L?=
 =?us-ascii?Q?gYRKXSrVFndcn5Ja51rg1l5aMh3OYZsdE9cVDgYScL5rQ7Z9lcOIk24iPttF?=
 =?us-ascii?Q?RX8tNvjMKK1UYyO5jWL8JEShiO0R+YwL3d5tcHHJWFxulmIjwqBC64/AF440?=
 =?us-ascii?Q?lixKm38Jfl126LVOUghnrSyXYu+YdlbTGdp9ENzQ8k3Ijh8A2yEihI/b+3qj?=
 =?us-ascii?Q?VWj2JjPCrgg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x9KKpCwNjO6KJrMgZbNz8dQMPH6yOuhscqvhQGno/5C6avmCUzkrymnuK0uh?=
 =?us-ascii?Q?bLOfFoo6mi+lYUnN+el9JU843pt2PmRtrMKInssWl+L6uccO2uMPvZygxXgC?=
 =?us-ascii?Q?QeQ1on55EZ2kodwWZpQRSfIo/bz8jk7Dcwy8Xegl8CMwoyjAqNnCmJjwlljO?=
 =?us-ascii?Q?9AgoXGwZ1BAnaxylCS+Dy9EBCDwOgJ0rjsVAm13MErAXbxa47SQFAFgFZ3BD?=
 =?us-ascii?Q?Khp+QclvGVRnoeFT4yZgWRCtMfDYyI8BpR/v6432f25n00etwILL3RnpYW+J?=
 =?us-ascii?Q?j0ZUZkNEK4eYdlVH8bEVyzvebdOiab2DwRvTrXWcjYnuMzmVWsbXbecgv0h2?=
 =?us-ascii?Q?xVvZl4+5U/rRkU4dMAeaWecwLjqXDh1hpqmIqLyEjQ3hK371clNlE455G0oH?=
 =?us-ascii?Q?oJ8X5Y0j9dcfjawWv5W6TlzD21eWqENZ6Xx/uuunuEow5LJg1OrWvJS2MwE6?=
 =?us-ascii?Q?Pd3UHFfULn7tOJILQSY8m1A5FS3GbsCvTwh/5Y8Si8xtAPF/6C4+eB59VsNI?=
 =?us-ascii?Q?BrnEDMw3EUjA1OSf4wCvS8ccQ5+EYNj10oxRJXZBJBCBmadO13ZiNi/ralZh?=
 =?us-ascii?Q?QTzCvcmBNxyHKrsJe5QdlEbkOXm+STiuwgoD7cHGSLkuNxD9Nmo9AwYtVbJr?=
 =?us-ascii?Q?pzpdMCoATI1m6FHAHlqzdK4ONUHGrD3r1p8abq5DjhlF87Rc79mZV6sEwzuk?=
 =?us-ascii?Q?nuloBjr6V3Iz0JnhZaPuloHyAVj9HIXxrqnYfP6W7PL6K7Jw54odBFkVXAs9?=
 =?us-ascii?Q?3UhXgJMzH8Sx0mX8VsanrtnCcHmoJczufDvgWMRJewjBJFNXv9g1E9/Hn4zm?=
 =?us-ascii?Q?oKuaB8UYV6WCS6SdgIyQLZ/stiK/aNSbbS3Y3xihEBrz4Rpk7jwGDzAoAeWd?=
 =?us-ascii?Q?apw5XKhc/NBZbYjJn49x2CG6ufzyk8/nWpNImaDuRGg2mjndWaxHT6WIJhi9?=
 =?us-ascii?Q?SEfMrzat1ct1Qc+3wDZaBpAL70W5iVO/gBpoZJ9Sz0RG/Kgk3OyJjsg/dM/P?=
 =?us-ascii?Q?LCm6oPUa0a6v8eltTUHGp5SDx6mAfc6Gy2H8EJnFgxFLIn5O8nsYZBZK2sh/?=
 =?us-ascii?Q?9qLfa5XuVfXJyKg7ma/roSeeC4a/u9/PsBm1zGj0BHo+obkRSvP4q/OOpet4?=
 =?us-ascii?Q?t+34QErl2V9vJWdn/jRkwx40hcj7ZEhD1UvaP3avmClDabo8KN0IxGMdNPE/?=
 =?us-ascii?Q?kIEVqJaID/nwfKgWPPfOODzW1WZiG02SsTSi1gmk4nDVFCS14X9MCb5NhjA1?=
 =?us-ascii?Q?q/0W6z4/eEgViq4AukgO5JUq0wHvl+QNhk6xUA0rJ26EAoQ+W9EtqtiWY0yP?=
 =?us-ascii?Q?yyht9IPwL/oe1ImaGl/QKC8xcXc4/aVfzcPGOb3PifJUevv7BjMY3ZTYqQAV?=
 =?us-ascii?Q?wvX3RoecilaEOeFrzbbwTVJOw8gpCP31cGn+39izSrDQ2Nx/AzuhDv40STRN?=
 =?us-ascii?Q?XpWN5t9NnKh+E9g8Is9nCP1ql1yFk8MunnfKk8QrHogG49uwgycXhcr9SWbS?=
 =?us-ascii?Q?8KX+G2Sla3WJhnGWVZLlJukAEtCv7EkxJM2gP9e6ijCzzef9LdXNme3F3jBT?=
 =?us-ascii?Q?8q9ZB45H/j/cYFxQLXKq7hIYIwXPJoXaI1ED7kKlawcgnZE1OeO46WXxOaJL?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/AoKV9zEjWfeU2mqT6ElSR8Lnwy6VxzTNCygYnA/PeC0ZOtfS3SIVvVVBPkhVc98FEevN0Id0ZiYsR7/0cFXj2qAIWxEvqpcxJ3Cgegm6PsWio3GP3Quz4aSTVXQFMp9IB0v+Qjk9pKWEzRsBxkiKvvtIKnPJd3zNesYg/dHmPtAx/IQz68lYCHL+6yShiSfC/j8tbTXVTkZNeGhFPLLoPnEqrULeReiRHi32psUuuqzIIneMyVp/o4WyzBYpxxtPGqNDvF+xFzwnqiOZGiZikDf8NmFmw3F5P5NcBfV2AdGh0VpieXtWXNVcmMLpbPRH/7q5RJ4RSPpTixGsbvLm9QAELjVX/O1UUjNO2L8r6hzdemgzDIsrOg9mc0a0HNaxj9MNihqxlbh2a7O1SxwncsTOe7X9sS1Wicwd2g9ZexAEZovb6KMewPrVCQlXksULxF5IHoL46nrx42Wz70RlPu4YUBygsDmrypJz6ajakccQqYK+sTYZOHXFAZTIkVRxORoJ6n8irUCI6jAjzEN/z8pjd5VJa+cgVnCCkz/v/a0NKd/zuib1Ik8Cwb70HR+UTmSIrpyuGgKPN+itCycW0o8TWBGCgWf9IqlYM83Ef4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f02c095-30ca-4490-cb8d-08ddcadc20f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 18:01:35.1859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zrjNRVtIYYMA1at1vDJX5L78p/ha99XOVUOKKgqra1Ewu7m1r+3Iy0q7y3DxJPq7Xqfu6yIUiYYp8tn5FN/RXbtyAE+yvxnF74fnJEK09q8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6320
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=586 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240138
X-Authority-Analysis: v=2.4 cv=TfGWtQQh c=1 sm=1 tr=0 ts=68827503 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=MCLQvga6n1pZF-u1AucA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12061
X-Proofpoint-GUID: ZLozZ7j975DKdyd6vt-7zEY9_HsF0mk5
X-Proofpoint-ORIG-GUID: ZLozZ7j975DKdyd6vt-7zEY9_HsF0mk5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEzOCBTYWx0ZWRfX+u7FEQDsPnO6
 SxsYVAo/dqqBngHCsKvlXAuMcS9Z1cra7Di5VLKwdiL3/At3VqZ7xpxQtRwlUrBT3JVp/iUGQiP
 +wUAA3V+3Urs0OEZHwRu6hcYwRh114a+fxrVNa7ejGyykt4rkuuTxkDuYcPIwUuLS+alZNvwr+Y
 FEWlBfjK7ziSPXc0LYVUYy5WfHdoRHBICKilWXC044Jg2/hEVQSm7lNRKzdxS9g5wUXapUtwWrA
 Ux8adcFurDsQJPL0bAtpWTkPnn3qE5ZMHX9qkbBDIKgV5E1TZhRkUe9S10s1c7MTdETDS4p7+cy
 ntbDuIGGPrfOunQh/OrriathR7OaHyhFyFwKaLX2WbrkFm6a8agcp9XHEg1HW3m8vmFuPAbRKAF
 y69gpb6TUe8IGGOOpNv4iZn+XQ9qJt/tx6hyxu5lkRCg0u1SiJqa1h7fBLTxNjqbRPAhwonA
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7811420023
X-Stat-Signature: duhhq438kfhhrnkzg1oi71zuzhwzk7tm
X-HE-Tag: 1753380119-581118
X-HE-Meta: U2FsdGVkX199V8ruVG7bAzOpZZTSrFKVgwjaqeOjNvmCeFblFX56+y2OB+uHj8JUZe7xVk1ZuVOyTue1AUDHnelwz+T5mIQ90pZkQEO0t8qHEZ0H182KEtz9VxwDw6n2H+KMCRcoKyLuB1h7C+ARfzuhNHAcPEMdA7EYzEg5i0m8yd8WaeMLSitfASOa+bxqRsWyj1a/q6XxbnlUEMR4qbMFIKFcIJOWGpRwkZnX55jOoPZ9IKcpHGCAOalsCwHQ6QgCbX6theNKXlJYjMU8KH6EG+UwNn4grazs2eus1HXdbc6RLMWMQUPahpMRkHRhTfcxPL48kQHzyY4Lni8O4ziNseiCL5sfGxU1gJgQgECFApVn/9Rav0nIJrBN5R3xtegtKX5tj4uzM1uj8wvH/qfvArRWqYl/vNvwabpklToeZjaZ7Lx9DwnH6REdo/D4ebAxR5w07orIA0zLKUjU566aRDkusFkDNNDo9v90K7EBQaVrUwWNIQQ3EpjeespNgqatuSv/UwUY94AZLFdh2GJ2HGKMply67E3hzspRB4FiyLl8FadYSDjzZSzeYnD/NxJSndcToAmWcNvuhCwsLAA0PXplJTJI8GIQmxxncxv3n16+0Le6CYsXnNupYg1bzBjXgcGID+RO2VgsKVeEI5ix1Mc3fzcik5XsyYeDMsP7OSvWH9FZpRqJTLZVa7behWXxKRWzWmk7k7QC2DFn3khOqPcFzDZofJHfG8yFSwqYPkdSYoAruVPb9DU0p7Jh1pyoXHganfDBAkk2Rxu5xLwFRlToN0R2wCHKuOaW84WRhsi50jf5L0LbZMZ2llfflWH9Tu2aKZaEQVxUeya2hfw6/54cb0JJillcBhlYSjcxtlfSfcVGtpmM+GamasRVuFOSc0+YG7FdLqWnVyJWBk+XHQrZG/dJ9+m57elCQ09j58fBjiES0+cyVlfFYivjJYFklf2f/i2x3w8tYHa
 QZlYk3JN
 RCMB7q1m+YeTyFE3fSz6SxjaPpR8oKjvetHu9jngOz6svFFlXHw5R52SS1lOp0ANZJgd5+ccw+y5fIFbhevU82agvqmHAILHe7Yjl54UAyUN9cnTJRP5zLEpPoz2FTSIKuqQwAnCwQU+io+hbcNEXDEJrChTlnbgYwsn72CXB6KDOtS7ZkhHUyuzzxjKZR2lL3LE56wqIAw2yUQ0xbvrw9mUacZFMPG4POAwG8TVvND422HF3a3kreGUtIaSFomooXV3WeXjwVpnU0QddFqaAsKRzgjh8PhVApiBUjEN6vq4QGKV2r6eLJsAOJgj5GKF73mQcxst0XBl1u1a4IRjektnw6DK6Dcrc4+RDyALmxceGK54w10+ikTeK4rTrqc/hX1o/h9XD2/WZnxFYhvI1/95Qb/E5tLrYxANlGQ1Y09ljjUSvW2dQGr+Bnbh4H2/Z7fVkISmo70lvL2B0/xjQQ1gp7+OI1Q2gvxpH20bNeNIJn6Uo+RvyuSXOnUMK1eriVB+fcs49Lh+l0lUGOpLWEcP3O51F30Fdk1ZG3MBHZPvwn2Z4z6WcJbUuA9KT1JXSsbBYfIe9wqNRw5l2dmfgTSw8B5mB+oRgR/E2gsPuQWqeq54jVAHPtYfeyvLt+d8YWsvIYTywiYlVMVg6vi4FsTUGSrZYkjZw1S+siBBnW7/n2s8UWufF0w12DOgCXDZd54gwmmZG7chWr446pDMAjbN7MNdS6gGbCzFL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 07:57:22PM +0200, David Hildenbrand wrote:
>
> > > +			if (folio_test_large(src)) {
> > > +				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
> > > +
> > > +				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
> > > +			} else {
> > >   				release_pte_folio(src);
> > > +			}
> > > +
> > >   			/*
> > >   			 * ptl mostly unnecessary, but preempt has to
> > >   			 * be disabled to update the per-cpu stats
> > >   			 * inside folio_remove_rmap_pte().
> > >   			 */
> > >   			spin_lock(ptl);
> > > -			ptep_clear(vma->vm_mm, address, _pte);
> > > -			folio_remove_rmap_pte(src, src_page, vma);
> > > +			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
> > > +			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
> > >   			spin_unlock(ptl);
> > > -			free_folio_and_swap_cache(src);
> > > +			free_swap_cache(src);
> > > +			folio_put_refs(src, nr_ptes);
> >
> > Hm one thing here though is the free_folio_and_swap_cache() does:
> >
> >          free_swap_cache(folio);
> >          if (!is_huge_zero_folio(folio))
> >                  folio_put(folio);
> >
> > Whereas here you unconditionally reduce the reference count. Might this
> > cause issues with the shrinker version of the huge zero folio?
> >
> > Should this be:
> >
> >                          if (!is_huge_zero_folio(src))
> >                                  folio_put_refs(src, nr_ptes);
> >
> > Or do we otherwise avoid issues with this?
>
> (resending my reply)
>
> The huge zero folio is never PTE-mapped.

OK fine, as mentioned off-list I hate this kind of 'implicit' knowledge, and you
pointed out that really we should be using vm_normal_page() or equivalent in
this code. One to address at some point :)

Anyway with this concern addressed, the patch is fine, will send tag...

>
> --
> Cheers,
>
> David / dhildenb
>

