Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFDE0D3B7D0
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 16:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052CE6B0007; Sat,  6 Dec 2025 11:35:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029496B0008; Sat,  6 Dec 2025 11:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33A86B000A; Sat,  6 Dec 2025 11:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0F3C6B0007
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 11:35:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D1F252869
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:35:56 +0000 (UTC)
X-FDA: 84189597912.17.9A76A31
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1D095C0004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:35:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=khDlRPOI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c0hV64nY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765038953; a=rsa-sha256;
	cv=pass;
	b=td6WS+RA4DiBqM+rmi19JY2ArAVriYZb18zgLPSsQs2+Z1QaIlLW8Q8MpYNt0fAA3uFX3U
	dOttgsixhIi4+nm+dRnysV192kH3GBK1bJVA0Cr9A0HI8uyVULUm1wTMeOH3vlhQRRVhw5
	8uehiCs0KWeNrTceVozmuw/lkL065hQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=khDlRPOI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c0hV64nY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765038953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyPeA1KDV+hiKC9L2ZKMkCQHizt2tPgOnWyGIMqSCtU=;
	b=y0Hj0LLJc29ibwUWfP9FEWTjboaFm+G/+7R0cbHbKUqHgt6SC+h+kfmD//avATCaAgGIO0
	IqJNj95BfE814V9ngO0oURXGz9sZfmdoe2OtGCszhpsCBIUhsGBUg6weuS3W3ozZJsyhzj
	ORMbU296CML2QyOH8A4D4pfxddxyaPg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B6GCv3e2338905;
	Sat, 6 Dec 2025 16:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xyPeA1KDV+hiKC9L2Z
	KMkCQHizt2tPgOnWyGIMqSCtU=; b=khDlRPOI5GhKQcQaoJAUaqglZibw+9jq1n
	skw+6Ag2UNWibj7hz4ri/WwsGAFya6diX6mUBZtz6Xbnk6D0LzaqRXFOtbmlRy/p
	t1S7vJcIT1SAMbBjqSwb37zacMzabqdiRWfa08gD6qMM3FEueJZCUX70i6hoblnO
	RW5wvboa4tf1WxObVMrda48G7GuiU8VTOjuET8GnI0mI5SWpM00wHgYrLArSwcNQ
	5PRwdKfYHkwB3j0LDKtMNDTH3yltGewqd6dQlNFTwivKzKopFR0tZIm+UdPc5M/B
	V7l7bu8N8rICanuKLAmYmykMBqFBFL2nUwHo7Vs8HlZhKp0MO2vg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4avqbcg0tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:35:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B6CKZK3039891;
	Sat, 6 Dec 2025 16:35:35 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011061.outbound.protection.outlook.com [40.93.194.61])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxg4wsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:35:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkrjHmngQ3t0ubn6vfk82O5JLWrEI08KOIu9nwdr1Z0AVVFspt3OytbYsRM2mfyh31G/99SSUgs6bY7mHeo2E2m8Zx0Mh8dB5GcM2f8zm5xLv3avRhVFNGw9/tvkz27vjhB8+PcgMClc7CRfS8tXGx8XMhP2lX8Syx7xnsNsn/sKBTuOLXcXqSXjVuLsCFDnzlbT4Pxx1wwW8ZtEK/SY3qYHfb0qL6XaU905QvuRziLxFsCE5kzo35+5HUN6euzMgyhpZf3UMNVpgGZ9Foj8O0rQHUzTUXC9bg2GwkmoDBsQJencokX1qW718YK0mrR7mYPb1N3uOaYsMVbLM+DPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyPeA1KDV+hiKC9L2ZKMkCQHizt2tPgOnWyGIMqSCtU=;
 b=GN9sLqkpYRwEuYDnLzfrjMefoGJbBVXviXzyqxgDuOrs1OpDlQGAq2nggUr7LsnYy+Z1HyTgzUlWmPSd8moV4Mdsbtrb2Q8qq3ZGT/zAwBhcIEcI1Et/XOvUT5IY5A0SSBxPURkOX2VkY5RA0lkFb1tZIVtTYSJQKXx9Ko1w1Q5clzlpxzgpYIub/Qv/+mmRqXgQLD1MMwkJFSnCuFa1qs6FHxID2OlQwzjtLMBJ/kRrTcjSIbDF1RDy2lBCpjPEn4a9BVgTOu/+9NtDyMm3SMzLbt1RwYUrirsmSUwqGqYgBtszAQn0f3OGnsv7Kchd3O5gaFz9Rllr2RT3/atq+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyPeA1KDV+hiKC9L2ZKMkCQHizt2tPgOnWyGIMqSCtU=;
 b=c0hV64nYm68u9a9f54yRFxhjb0o21pJgcdCYorAI3MlKXD5rM5vNELw4jX5usB4Sw1ydHKpmAiIxoF2aA8cbNLWFkoniYF6ARjmCmtPnoDy5aDbmlWJ+JrnSJiuPDzS13DmHn5wV+gHlGs4b0DMqtIsizzDYCb327dKP1WTjppc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7714.namprd10.prod.outlook.com (2603:10b6:610:1ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 16:35:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9388.003; Sat, 6 Dec 2025
 16:35:32 +0000
Date: Sat, 6 Dec 2025 16:35:30 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <492bf977-d590-47fc-bcba-898bbee01c16@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205121501.bf47efd78d0a1a8f0370645c@linux-foundation.org>
 <20251206114034.24bdbf1f@canb.auug.org.au>
 <20251205191255.e6da75c8511d23159f44b59f@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205191255.e6da75c8511d23159f44b59f@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0080.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7714:EE_
X-MS-Office365-Filtering-Correlation-Id: ad1c1628-85a5-459e-e2fe-08de34e579ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uqUCE7Yfude6RhLFfmM1zfS1iIfAxGXjGewv59TSrJOWSFfS/3ulb0r89AYz?=
 =?us-ascii?Q?erKDeVLyBOj4p5xMKfy9QWK52BZ60mh+uxEFVX+X+5pdP+ziiz50h7o2JqEi?=
 =?us-ascii?Q?HBaEf5DjrKrwu/1U7n8TIngG0cXPj8bxeSv0OCVI+Xu2eV0DuzXC3Pfcnnvg?=
 =?us-ascii?Q?JFGxIuCS9KxjusDc2HTFwMeth+CAbmoxVsRihrXl/p6RNKDT8j1DIb1zdVBP?=
 =?us-ascii?Q?QZGhxc2hABUPHHMjz6ZXdVRcsJdE2JzDH3E1SrMIfNRec110VlP/y/WIJa2K?=
 =?us-ascii?Q?SUADshWaaaqowknh86MsIUzixmsu7XZ0kpP8Qagnw9+ZFMuTDWxdui9Z2U50?=
 =?us-ascii?Q?GzKCi/VZDqy7xK3GqmuxodQSdGyIumUHVDJWBAZdx8EJImjC5OLud3i4zIte?=
 =?us-ascii?Q?dWALNlwJAk6BhXNKps9bHtGb67y9XL9+pfctyhha+E95Vh4vTMMP87DUl+EO?=
 =?us-ascii?Q?YVX43m1K+tNi7NABbsp6lbA8Vjt39gdPyNmvdW0v0UYpVBSMzHYFhwPZ7/js?=
 =?us-ascii?Q?i2YPlQO5HXI9hB1KX9y7k41aKDBlhZ2JC9YH1yw4vZ4451IOk4ZlZO0YuYc/?=
 =?us-ascii?Q?bmArLJY7xeIg77OE4IXBpBpiuCk7WTOJCcJEmmwTmOoTfNjAXiB1BUgK33zk?=
 =?us-ascii?Q?RfZH4lzLqaHehc8Zhf+vKWBSWkj/U2dnyZU3NCdH79/xBnU9AOszGzKlJDB2?=
 =?us-ascii?Q?Fu5LPs9dnP1/uFUHzlhewAk6eaZ9rHw5F7L/my3R3l/YE6jQEdF5hTsCbgrm?=
 =?us-ascii?Q?FEIoNpDYZjMqsHPgALpru0dUmyyJE/eE3d99AnZp1Gk2K+YOa/EyTPdkPy7F?=
 =?us-ascii?Q?T/2wCXkwp1kiiBE7V4cp5iM1akFLBb5X/cQoPFoOnta3QYTKGyLerQG8TsY/?=
 =?us-ascii?Q?1yYw4AcHeRHHNp1lS2zQrWDr9SgYbnTmvr5xSApkfEP1+IWOKsWuqpshpCUg?=
 =?us-ascii?Q?23/q7rT+F0OjAjv1P5c2/ZW761mIPJMJczXanWg5+eokOf6asNVu+0MGmgV8?=
 =?us-ascii?Q?TQFJH74BKf8iSTBO+Kx3ObsIz7hRPsh/+PQ/ecdF15ZK6zYcPQESjoCsK7C1?=
 =?us-ascii?Q?J2rfJQrTxM7H7CzSsxfI6CGDFt4C5Ds/PRyO0WIC4qrKfQSi1gFN9qvzYbe1?=
 =?us-ascii?Q?hUozxTMFq0CFCaX8XDByy2IbT5fBBuVfOWdOhs+hZL0Jr9d/0uTkYUGNFhXw?=
 =?us-ascii?Q?CbcJMGXbbFW4IMDfILOtNyqo+bQbee/XSAvFW84BRB/3Ed8S8XS+eGNM7nGA?=
 =?us-ascii?Q?D4+QXpZthLp8NcD5T5uBPfy9PiuteDe6W0NvE+phaNK1wgOr/BvTwUYDME6c?=
 =?us-ascii?Q?FMbp+w42MwM965v1R8Y4vcSx4xxhGxX0kHLH6l35B9ocYBKfNFCZ90WkqkIc?=
 =?us-ascii?Q?ypcg0V8ksEvqFSvWgl4czswgv0JrBYLGoS5byZvSCXgJqa9K5rV5QgR9BZ//?=
 =?us-ascii?Q?lcQg1MHCIdFHMhmxfMDeT1NwC7WIY13Z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vpfwh06a88GGSQO3AYanoq6mXbfCEHszzYv1KhlD/msUoWhbPxRoJeEzC7F2?=
 =?us-ascii?Q?mRSKMCwvF4o3oclfkIHIpxHfSVgbkvtMB0PnlRUSkrtcfZ9q067ghoOQ2EcP?=
 =?us-ascii?Q?5ax6OnBF2WoGQpWUB7Axy78LtNVt0J7m6xBC8I+UzmQmzKbkfby5NK1xYI3v?=
 =?us-ascii?Q?qKQtZ5iPvm3uNLTfXYXpnNLonuJwAlV5fuRn8VruWcbKOPxG3p/rZCFT/doK?=
 =?us-ascii?Q?CMjVOFORxLlkURc4Rl6wSk9OUILBTQYTgPoQztk3acJLF3Z0BpGW9riv5MIW?=
 =?us-ascii?Q?2XBJvZ+4Hd4pedVEvmjwqMCYRTEzh6kPVBTK1Dx3f1fQPPlYZipdM/GS2Wm9?=
 =?us-ascii?Q?zeqeqHAUuAu7gjvrbyXGT3WsamlCSQ7bMw156/AqQU2t15/HvF8kSV0NhSzQ?=
 =?us-ascii?Q?I91uD/gXpbyyfWPjVdMz0C6kbrCoHXNTnvSZDNNkcjyjhYS/cxbYwIhyhTii?=
 =?us-ascii?Q?VFHhqAjrky6qtHGedrtYyJvtsjOWhvY9ypgcKoyMNMlMGkhmv6cDNvcuQZJj?=
 =?us-ascii?Q?Es1TYdSjlWtqov9mDKpikqNIdzk2q8MSEPEDnLSPLPheS3kkJohNWtwFVBwM?=
 =?us-ascii?Q?R5TKd0dfFIKm7/275k8FPlmLnp5M+o/zR4dby42UkGOA3PTq/3ELvUGDwGjP?=
 =?us-ascii?Q?iiNCVIm81c6HRx1x6GjKIotWX9nsIUZTNLKFNW6yFmG/Lj3sQwLsXnGVb4PI?=
 =?us-ascii?Q?rs2uP8jFbThvoMuNDqRFXW4Pz+vDb1Pyq/IAaw4fLzuGdE+u+c4AJqipR9bF?=
 =?us-ascii?Q?iuiYD/M7OFu2rwZc9Ow9KTnyYZCY5ZX070JT96aiCfG2LmunItiqXpw/AFBO?=
 =?us-ascii?Q?UB1y0RC9fRhJ1PjRw0yofCr+V1G9GtlE8CA5O2xliD5Z0Q9RhZ3PwxMlQ/eg?=
 =?us-ascii?Q?KkgQA4bRWISCJB2h9ZG4retr0eyREEJ/Js3SDHA2GmYVcv3DoRcy568zFQ10?=
 =?us-ascii?Q?w+o6qn5nHR8Jw8c6af0P3A3s3dbtRci1D0sqjvdc5KJn6E8LMHnagdONk9pD?=
 =?us-ascii?Q?HL2dJ/cYmDPkRHLpxt9T2hvKDxY2IHZaguS8J+nKrp6dVdb1adOLMA9JQw8s?=
 =?us-ascii?Q?3vs2HIkYptz4dfJ/0/e6RwnrbRsS8ckVkysif9opboL8Ej+Z2zUJGhDQrN0m?=
 =?us-ascii?Q?t8GUH3wLxLp/0CfhddsEYrI6RgyLyjmLlHzkYrh9HxDruScuCRJKvZ9/wQs+?=
 =?us-ascii?Q?F7LV8BIYRV2ZlpNGy6+/bFLne2l581UbFQsBxMrzUNcd8S33P1eRKCmyIhYc?=
 =?us-ascii?Q?DI4q0bffi7uKePYlb0T11GDz8XSbfoQMS7HTt5dd+KzlIXDb+YCq3tkCgA6N?=
 =?us-ascii?Q?LVF3EHM++7fdAB0Ac8Cxz349hI+qcExbCTVlDI8kW7ttKT5tlHsXLSyzzJ5U?=
 =?us-ascii?Q?PX22Uw/mxJcy1zvu/xyigf3VA+//u6V6vaE/GwQEcNE1KssyDZwqwhJiLAIJ?=
 =?us-ascii?Q?h0h1S64bjZmc/Fx4MOUuWvz3ro1SKwRh7CbJmu7Sv3k8HIVzjxS/0NwBHMvu?=
 =?us-ascii?Q?AscMqeCMDqBse2kApXxb7VdBR1yD56W1UQZMxoSGJ3+8Xy6BUTXcETCuAqeE?=
 =?us-ascii?Q?FH5NanBIXgGNLRXjDq4oyaDTjgIy+htbDI9ZE6u2zQoH2Fe7nNd9l3ptYt0l?=
 =?us-ascii?Q?E066Opz3yQVg3Iw/4eDKd7OsqSJRmzLUULgTsjiZdO9jXq2O7aMXQB/1pK8O?=
 =?us-ascii?Q?7VQerw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nY3qLNw+dD7toOmeir2EiezguiNTUa/IZcF6DUvpWwOeJXz6+nEoF4mqAxJSl81zxFTzG3/a5hydxsvGXKfn/1L47o3bYsGbeYmVEtYbs15dE+imPvt8l3fxCivO0/P7B/PJzc98jvxaR8WEPJRHTAwKFNgKMB4l5nU8iHAjYt7bGC0mVPWunHfYGJ91SyJ4Q5938fGQAO3jzz3eh+G1jKXQzb2u9tPupRQ7XWoUR+WKr0NRuH9tXs7DM+CaRrRGtsb/X6a2sqpfUbyqoZfbS83bvoZBCaJWLRe9fg2TLhii1SOSS1W0nLvT/J+UcT4H4MBsmpEb6YQ4N7zb2SSZm9wRrtZwVi9ac2KQjIYfugjOr4lOuTRzccxz8QcvvkhKCxoi+LRuFzmT7nGBP75qTLLKHN21rM8WbQuIcvqzHKgXHC3xqEfW3VJuWBvfloJm7b5MzowpO2LNvwt6dnrgsXE5KEwuJlwCOqrSg0kMEFAGrnP1S89cXPKLM7muJEVbpSg2orgg2dAXEE+4dyM6MpQ8bUQL3++uLPxrBrkftRKk+KwUpuapWPXsVrH99uEBXCFw9wE4hlUZMNTMCuo30152fo+CgkfOTej4Q8vdjTY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1c1628-85a5-459e-e2fe-08de34e579ca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 16:35:32.9197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLsrb0sZ6yV1NHXVrfGQZOvIyDlpoRKhIA+L2d3bx+Kl0ukjewue/LRoLe6nolK3LMYvuDWfEIFsefvewYEf+WNojhVscAuzj28MSsZ4zco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=784 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512060135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDEzNiBTYWx0ZWRfXyzqRmdIp3XY7
 h6qQjh5PNbZz83ZJTEVMO8YTWgFK2pV/J1H0rlVTRWB8Lkvhv2hMb20hagJjiCra+hPaRKwx3LY
 C76qVwvwOQvtiGTJDTrGYwCO8ECl1zT0Ym233AcUrDb049fziuAdFfdqADRXplUSYM5x5dB0ZJn
 EDlEMGuaFPhQ6kMP7Ok55CJjB+BZMFves0mU4RrPn9R3HmCb2K0NaAvVA7I9sgUD83BZCttNq5L
 9J7d1+L8YFlIK47qrfhJfPd56B88GrA57ywbMJoabUTbIluhRGskJAYSGAnaHd58eLTf1/L48qS
 mNIz6k60sQL6RfcyhxlI9iRP55cofDF8mLk3KbuB8mpM6qScqTrcUbPQ7gg1t1mF0EX2ZXAZako
 0RXDbk9sPPdD59AsFB4TPsT1buXFP1uD3GJdFxfZtytPGr3FgWE=
X-Proofpoint-GUID: hWnibfpw6SyGQby-_D5jy2QUfjZt0g9N
X-Proofpoint-ORIG-GUID: hWnibfpw6SyGQby-_D5jy2QUfjZt0g9N
X-Authority-Analysis: v=2.4 cv=OceVzxTY c=1 sm=1 tr=0 ts=69345b59 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=rOUgymgbAAAA:8 a=Z4Rwk6OoAAAA:8 a=v016pYQD86XqIouOhpQA:9 a=CjuIK1q_8ugA:10
 a=MP9ZtiD8KjrkvI0BhSjB:22 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12099
X-Stat-Signature: joggwnhtoa6mchbnxc8zkb6di4oxmhzj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D095C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1765038952-673261
X-HE-Meta: U2FsdGVkX18/oCDvOqWXGDscIbg2kJpRt45KeQr2Px/d/X1s76njbqjRStmCFCHwSM/WQhhRKukJxE92Cn+AhhwpF8hCeAE78K4OimNnOYgOOCszxvmQH2QH7Aq/Xq/bSF9H1/WojQG65g3cavol2KvOjP/OCmNrQpOT1hCkpWnie4xOIA64dlNbq9iKtYHpdXPnzR0pOTDLqXxNKJK3Q7QtUUB+irIdJYPZ8aDNobFwI+32fEnG/n4JeP0wS3j/+UiTqwffVNu4smpak06sC5s9OPJf1RMQKXRQ8vjhhK7BVUpVQyfZaiOUF7cPRh9IW//5ecUAFGsy8qELXDBbHln+BSShYR0w00QK8ikpYRokvf0to8qBxpxs+KyR85xEax5/0PoGe2ESMvsvpoJDkBqt56LFtdcW0oBKf7T4nRu8uEgx4gBWzES3ddgMNfroMwyvsyY1BtnmzIHkgOqsK3PywOoWg9ccO5uKsp0kvHzuBDyuMt7BFGQYrqHihoVGtsDjsX8N66fRqjT9OrHPlZxwwSFhsW7lbQOq+ugjrkOOVdtTVg1QU/7g5/rMPgfoTSmnbqBuj2SH8hvhLgHkpHsGuXWJJBDrKIV6uRBUyr1WVQhCB7xCdZv84uZZHhpkgprQe/+cAypBZV5e18zQHHuLSqi0UCGLJX+gW4QhAbztRJcj4iBeoCQ0eLnD8fxKDGz9z4ksJxiDhx9pmos8kAcXkZvABeKD9f2CZ/O8rXai3LPJ3uSBETOeVCbZz/wI3haF6DsnqbG31L5zW3AtNlz9mBDiZcaFJ5ndphF9G2a2PNLIBQBxW8dVEsHVUjqsB54dr80B+N4e62HgVRA8zrOUgLhuPJzAwn8jJolQC1UWCbVow5bnEBBRD+6u9ggJFReuT47gbJqfnmVqg4e6JumDRFzrZg1Dau1UZ8NgPi5+KjHVRAQ8hPhbqhNCSOb8bd5Zn5xLZh1GkyBVvfE
 Lw2YPSlX
 s+GTpbDHjWJN4yIFRI4nc3uVL99fOg2wcfdISkLwIZ4T37HF710REr7FTrgXWG47t7FBzypf9M+4p0LH9ri7268cnWKky4S590pEFgRoYcjsvm0jCYwYd3NVA/bG1EKXSXgMzR8gkRpK19A4sHuhhLKSXOcG7n33z2n0uGBuG+SmmcRNqTYiQTWDe6zfdMeRIBvf6J7INw721mGUeI+wtZCQkWrm+Sd+VseupqHgZFvt7q2Z+4FRiKfVZQ+HWAWLDSQ23UzYutv6q6+j9Gn35ZH61raOSbEx6NfdzfC+BJDc8bvB7g2ipNg/0YRqIfrmRa+7+q5fiefWhmUK/jT0w0pPNMDGzbl7FvDBF/msoNSyRaQ59jG8kKjtZ66gmnIf1WrAfYsVeuyo4esn/98Ryt7GIXlFU3+nVfCjxRIDe92ay0RkY1MjUdqrFAoSUdKKZ3w+AixQflJPT/QNfL64cKShOtrBAuEiwC85VwzqM7JFcAVqjbFukltEfJ3pZ1RC/Diw/CtQpw44XRgEm5GDI6yqUawDmwlovI3LF2ytuPubjwmeJA1ZnmnFMojkA+5ZaAokI51Nb2JCJqR5BufCtP52ItSz9+9PDvC/j+djfQcc1mYf3A9iPBztdnZLz5qhuTcoOHRK/wSHS4N73tR+TIzmhBU1sS6OM7Xr7+F4cFF7cqM4GOz8OGwIYevEp6U7vYPKGEg/zs1wNIG2Aiw+biCVf6T6SRds4h/ihgNNl8do9H6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 07:12:55PM -0800, Andrew Morton wrote:
> On Sat, 6 Dec 2025 11:40:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> > Hi Andrew,
> >
> > On Fri, 5 Dec 2025 12:15:01 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > I'm not really sure what's the best way to determine this.  I use
> > >
> > > hp2:/usr/src/mm> git tag --contains 2b6a3f061f11
> > > mm-everything-2025-11-29-19-43
> > > mm-everything-2025-12-01-19-02
> > > mm-everything-2025-12-03-23-49
> > > mm-everything-2025-12-05-00-55
> > > mm-stable-2025-12-03-21-26
> > >
> >
> > What does "git branch --contains 2b6a3f061f11" say in your tree?
>
> hp2:/usr/src/mm> git branch --contains 2b6a3f061f11
> * linus
>   mm-everything
>   mm-new
>   mm-stable
>   mm-unstable
> hp2:/usr/src/mm> git branch -r --contains 2b6a3f061f11
>   linus/master
>   origin/mm-everything
>   origin/mm-new
>   origin/mm-stable
>   origin/mm-unstable
>
> kinda random, but it tells me "that's in mm-stable", which is what counts.
>
> > In my linux-next tree it says (I need the -r to check remote branches):
> >
> > $ git branch -r --contains 2b6a3f061f11
> >   mm-stable/mm-stable
> >   mm-unstable/mm-unstable
> >
> > but I don't export my remotes to my published tree.

Thanks guys for confirming, this is therefore less work all round :)

Though Andrew do please add the Fixes tag that I foolishly forgot to
include, thanks!

Cheers, Lorenzo

