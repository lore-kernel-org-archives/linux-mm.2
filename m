Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403B4D2ED08
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8273F6B0005; Wed,  1 Apr 2026 09:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D84E6B0088; Wed,  1 Apr 2026 09:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6A26B008A; Wed,  1 Apr 2026 09:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2136B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:53:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B1ABE06DA
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:53:46 +0000 (UTC)
X-FDA: 84610130052.04.6682275
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010002.outbound.protection.outlook.com [52.101.56.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21D6E16000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:53:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VzZemszy;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775051623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hyqzfmqw+dAicH+66h4KudrRgu5Fv7ulLTjFAcD0J60=;
	b=NQGFhqjrbNEPj1BR2bc+6NB7Gr2LDFUeHL2Cy8qD1lDdb9S1N/l7maBQj7rADDY0lY/fcN
	6h/XGy6hcIA9v62Qhw6pb+N3jgPLAKXAoXU/uERZGfpayHy+H9P+5SHBTVW8lPZguZwDlJ
	poEkwd/KI9wsNq9sRYv/ayE+3IhEXFA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VzZemszy;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775051623; a=rsa-sha256;
	cv=pass;
	b=V+Bbx1vwdCpdkXow/n/q4uo3rfOVh8VrGsjGzkwhdWEAgWlqYDTj9CUh5DbwOIEXIsCtjX
	1k+HrwFRyF8PuK3CMxAOH7naCboamER+Nyu4Lay3LosF/QEhRry2ifjgkvw2kKuKA62hWF
	i6+KlSWDeYKvp28NfETCsuq0cUJR+mY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Grc7PQl8KhgaHqhJTyojQZrq7GiHlu8N4iCANpTz8nEvV2/k1/Ax09f4civrK4B3MmkaZqQhVUfzFZ17n+megiTowDPpYl6VXCEQd3jzFk9lu5DZHiefT6j40D8egVNkal5kBb2eEdL5y5PQGyKM/h7EhNIW6iqAyB0ktacAJz6diC5yVbJLB7Qp2veiMqNCCWtrhs45Sww1iMQPzi/ZN8t5RGuEEO9EL3Vo1SDtjbXoe4t7B3gNwtnCVabpgd9gWmiSRWCF8UmVLGHAGzoTNdmLZzfs/yzqylsN8Wtc+9u+z3r++PhxxOQvRtFfqpqbSyHtAA9pUj9+17rfquvLiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hyqzfmqw+dAicH+66h4KudrRgu5Fv7ulLTjFAcD0J60=;
 b=cqfLz6wh1sSWFcWyPuculQCWfHK/NNrUEtozaYYz7wLQw/XOM7YS4iqL/m52akkj2ttI/xTnigSROiOnzcfFiyrkFuEHQV5NH8dnfflh0xt74SwE4d1idtG0oRfK8YeUqTnQ0Pp+0Z+UmMXyXb6KSHtNC+KhO/kW26WNBkT1uT6rljbuXFQLnFeshJspp8Pp+EYkOstwNbuaND2pTf9+MAWdpfVW65Tu8z+4kxJ6ImiuRWxlBrgzhvq5UkliEBLY34owHZmKB2cff4ga9W29ka88Evgzak7Xk1xrVSPrJCZd1EG85zMprPbvH4vThuOwE1BDssbPK8rI3bYGzXH+uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hyqzfmqw+dAicH+66h4KudrRgu5Fv7ulLTjFAcD0J60=;
 b=VzZemszyPZwbaO/HEBSp8liwv46M+VRWZHZKhbGb3HXmZyiySMEy0RfJzGIdhPhy17mC6LUjFi02JDgkWyTSYNYUaVjT4ZuiZcboEDB0KFbod6K92wvl3akNkkL7yeVSxvweGd+pitp5RO6P6byybP+B4W+FWa4gQxOtePNJNu/ZjWqTOB7p9WZ3NM00bCEDMCEGVINUaG06CiPf6vZT0ziTjfb1KJI1XZFOtcX/BpWx42rYKXbkvWvRkqcUGpEXU7IW9ukKR1GPuHFf6rQPlhiqx+Afc047rxGzKdPyH+Dvhw95rYZwmMwnpqgizmKe/14gvVMuZEKniQeitKJ6zg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6335.namprd12.prod.outlook.com (2603:10b6:8:94::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.15; Wed, 1 Apr 2026 13:53:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 13:53:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, michael.roth@amd.com, dev.jain@arm.com,
 vannapurve@google.com
Subject: Re: [RFC PATCH v3 0/2] Fix storing in XArray check_split tests
Date: Wed, 01 Apr 2026 09:53:30 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <79ED6AAE-96A0-4934-9A24-BB12F3D45F90@nvidia.com>
In-Reply-To: <e1431688-17ba-4881-9536-b598383ed2d8@kernel.org>
References: <cover.1771831836.git.ackerleytng@google.com>
 <6ada27e1-8f85-4b85-8c25-bc9207b2624d@kernel.org>
 <87FD20AF-55B6-4129-9AED-E2E854593883@nvidia.com>
 <e1431688-17ba-4881-9536-b598383ed2d8@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: ebe70b95-987d-480c-40a2-08de8ff6112a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3jcfkrUM6/iukJtz+e15kMhUx/uln+rl5j/z8ewuu68XAdpeHXbFWVIgKGYe7jqoxZ1HvhUNXUYEZQfNmagxUkrEiCppgJfsDzjcOFCA313apR/LFP0WHdeHoD4gAwLKRmxq9mpljLfYA6q5kPPjFD5I8QHpiT5S9K6BoWpeEOWmBwdtYBc9MLaDkziDMGFMAL2yquiDHt1EiJ+wrNxBAh400wp2vUBpFZSnSZ11/PW911UX8NjaNl5pFx2dxoXEadNRfJOti5p3ZK+2qt6uMkm7CMX2OJSapBHRJk5za8XMvcPFjstePC0/tgyxSJkE8P/04bGqgIrYa7Fqc/WXbtwgU+M9TNIqalGH2Rt9JJlK/ovTej0zTbX2kLcolcVhQ/Yz2pl/bbVbpAgk6RyelBi4wuyr7OEm/qjXl440/+vqjG9+cVkVVA3GAs2qiMbDouBG2vKHtyX+TudvjR/jk7JcLTQx6ngutoGYC/gujdSAbTuxHihGnJum8O6r6G3SX6Zb6ii7utixr+xjojAU0FDizx4g9GAYk0xuVPdoezmqWXqOtk2BZPpwWuZ1AVZ1IBf3yG0KXvk6593tyTg7AE/akn8Mtu+D7yCS9jBDP6sEv1+97TLso8Rrb3oL3q9VmlOU3aCSLUH4uHjF3RlXYnMa8PhS1YVdaHzbdsya2AikrHPCkG+lO4PCjwnCOkwDSmdH62ZMoZrTMU6EnYHVZRR6Z6LY2W5oWdPb2zUND5o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KlDLKxKMfqm5yYyYdJnLOQKctLw9pDvYecNY2LiJ1fsZDl8Et2iM/0fyYHX8?=
 =?us-ascii?Q?O/DIzIZZxDbiHASROg489+9xHEl76hELS3n/qNqd77G57UM2al4fWeaumh01?=
 =?us-ascii?Q?CiSDeE1hLIsRiL4F/5ti/I4ABGcOyJmjQYDBv8nn1wvgUDTCUWR9YXNap5mF?=
 =?us-ascii?Q?hB0ifNK/MiO8zLpKeB7r8TSI0LxIOg4r7/hkqVOqkdNaS2zzVCJ7lyCDvTmt?=
 =?us-ascii?Q?2PS7GH+pgpJEoQfRuklU3CmZIKoq+LaPKhz2blm0hiNBaKqB5qawgFsYxzsK?=
 =?us-ascii?Q?dLpD6p0gVL5LP8wbSk36t95lm5yfl/5IUoq0X8DpA9ZMiG/020AtnB6J0qB4?=
 =?us-ascii?Q?sltWjcnu5ANJvonPOqTjYMeihv8+e3vR7BpwkZdYv0TNXKHeC167BqY6drsU?=
 =?us-ascii?Q?KsMnhqy1dWZJp2e9HMeKRXU4w6iKQRP8Q0HUZOVVJiQfhS12TgDDOKIfVSDU?=
 =?us-ascii?Q?Z3Bu/aBu5IQMqXcWIfCIGSnDq20IGNEWflH4QrLwrnQKNfCgONHKODvFLmuz?=
 =?us-ascii?Q?JGzb2KazrE783lEOKcZDGg/VRdNxk8MItPbPstCvWh16luXLUCfcfHrNbGug?=
 =?us-ascii?Q?b7OOKW8/Qu4qVdwgyXhCAdd8cWzj9E/7xWWwfF3MdXyZTyBKIA6dtHq5A+KH?=
 =?us-ascii?Q?UZ2QZ1niW6o44ufi3tUHlU3Ep1w53Xp7tjkrW6BINqR3fk1XLTAyJACWRyA9?=
 =?us-ascii?Q?39VseC5WNogHDAVD4wQvTmN/s4FSM+kDAmupILNyXy+VWPWBpzgUPThY+Ano?=
 =?us-ascii?Q?oDq0ETtmdR6Q8u+A0Xn4LZ3HUmllZqiQIRGT9t7JywKQtxwX0upPdOcO5+uH?=
 =?us-ascii?Q?tk/DWkWNTb3lJdVaiPurI+UYkObiNghKncohN2SrxZdq4I0NeuZWjtWWnaWd?=
 =?us-ascii?Q?LXFFFbePVuxBzihY26hIPeWAJq+Ugcess31svqiJt168khUrURW+OsAbs0Fm?=
 =?us-ascii?Q?pTQNdWANS7Trz7BH7t3w6Yr1CR/zOnlcUMl9jTAAJ2sci3Vf+a19DjbHOQnQ?=
 =?us-ascii?Q?9cBWJuXZ0tfulMECp6fy6V7o7pw2wEjZbDwSTWOSEIt9MkLJ/+PkFrgRmruG?=
 =?us-ascii?Q?bwD/HdSQ0qyiHqaetcflyr3SeoRbqBUCd5COtPSHWACx9Ikypzcjlncu/2ne?=
 =?us-ascii?Q?vH2yCLZtHYbJwZPQT5QINYLJPRTSHu9zNXes6aLfjC+Fx9lPnJkJLa8WPsPU?=
 =?us-ascii?Q?/IP0byqCGs6G6phbKSnl9bNIXds/VBYJfDHqAh3lJxdzMaIfABvft1uUJPWr?=
 =?us-ascii?Q?k2dDdszgT0SW3gHLVHWsZTUTjb9QByevFUdvjU2c3j3N93ImlaeVGchbHpl3?=
 =?us-ascii?Q?hA3pCGBW/bYJXJEZ7lvNOZt8IitDyrtYGlwfO+FOiM/Vr3U2hN3m0l1Oht9G?=
 =?us-ascii?Q?tqipxBQyo5J7bVt3ANoD+q2dmIy44slsoxWTe/jOusC1FmDridvWdC/F0IiC?=
 =?us-ascii?Q?Gf4lp6QwzqsZv4ChPWltZPsxWgEO0jaeAWUAzNy1V2qFWcf06gx318d54nWL?=
 =?us-ascii?Q?n5AcK3ciBe0D+H6lgqDthT9GDbpNS+GvaW1wDkVpfAvKTMKs8NiWs8/IoM3y?=
 =?us-ascii?Q?a4lHpnC4519Q4K8ior1NE0Fl38cYFUTSrnpaM2zVe8EgQOd7uZlGUDcwqEij?=
 =?us-ascii?Q?N2zMhapLzR7t1+LU2ILLB7+ugKRYO0w1aP6byFwKJkqZTgnpPsfqg+n2YYV9?=
 =?us-ascii?Q?D1jWyrLPjprkm5EjCyTaLsg8YGJZ5HjXR589+QiXDL2rnddI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe70b95-987d-480c-40a2-08de8ff6112a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 13:53:34.7026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBCWoGJm2+sAlCB2AJRJlAFJ1GU/xGqtZ1UvZuFapARENOzFUnpgOphPwPPKUzrJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6335
X-Rspam-User: 
X-Stat-Signature: tyjpqn31tpfn4xnt7sksa7knoqb1mk9j
X-Rspamd-Queue-Id: 21D6E16000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1775051622-71487
X-HE-Meta: U2FsdGVkX19vvOCzhOAbAaGszO7m2vedcQ+iSHO4lXKGBKqp9uBL4zAiqPjrsgl0DY/oYPNw6sZSFYfZDQKgSIqPg3+0pcP+EzW7WVjMgu1P2HqyXLDo8b6bHP70OnfuIpkVk2acwHkia2VbqaBEsWQs8aiKWQkeYBUGMpjTQevE1zAoTpC0ZN3Sq0fuDdDFRq/G6zKJmZUgisOWDigP580cJGJDusmnS0YfJOOt10+P/I8TV+AY4GSHtX5FO+aOtk1SohbDoHXVEofnUcKQHBvYW3WzUw65w+V6mEVPKAFijrR4opBYol4BdTdUhProUyzwQFp5vZYo8DKCQPAQ0AdKjQUsxULEUPcqTFVO2CLXakGJlMiqej68yLQubnOV8fmFqYmNtdEc6zEtVM5yOtdLNv8Kba53y9WT6tXwaZImKqDYGz8FD2oS0ySnyCqUmZA9Q+lhXYFmsGMPea3RwR/iFYYFYMODwYbZwaVk6rlkWN1MxM5q42oOio5Zsk24Q1A5AB8XkMBMFhLrCLsHHSDQZopy5+iO9QvXbXyUXbkFknCIkCZtwzseiGWI+1cx/oLywiM52kBqcCDN/qfu/DkRku4OMSABA08ibbWmyPMneDJcaVho2VIe3MiS3ucAN+AATor/APTl5iCbx1cBabMvdlyljZ15OvIr0zuq2dZl3uh9IwVuCIYAwEmUk+zb2Vvotzz9dHKrd6WviHlfrwRiguzM0rc1hmwx72TWso7zUWICWtjGQtYuhpWJFbDrj/65n+krkWpBWdInQx5sIyyo6ln4G8OUjYXDyU4JYA+YIiM+3NrqFlEzKCzR6l3IJUwWY8e9pFjgA8+grtdhjWSU7jU6Il6saRPwBws2sqXNTAuAd41ane9YxiFYFU2QsETScfYeNzzR3IGx8w3Qr6Bg655Wi1BZlmK5C7jKhykJ6FF4d323mBIH7NCaaGmRXWhDlHyLY+iD3g63lok
 IjVvsYel
 gzY9UQbwb36+N4Rf7oPSxeuwDI2jxCQc1zW0f4LhYFS9/LJRyWzDQqZJRjc9cOrHWasfVsI+27LLsrINJsOYmPPYZESRpKk+URSgARevOHeGA3s2A2f0e/Zi01UgHTJpO1OVF2KJkM8uJ2zQtv/4c4noBqxgrq30tsfhNqXbsP4COA+qRf9s35FTjtuOiIVtaDuqc5koHNQsz9FgWwZCc6tCsvaCVvJTRWkJYeK5SLkrHcbLlojNY1+NZxWYSQQ3xFFTjO4+IVa8PxkbVqZYVQx/kcn3kbiCzr31eV0U5/Oxnp+hRj7k/4lXeFMDFcn3QGSUmgHo5IC4MM0Y2sV61vVOZsdIY5lu+VKEbfEIvP49VxjhHAfxZYRuCidE5KGrcXqgfyEUEJIbK7AfFBRXid0fhIhUKd5DIjlQ2wS8MpGs4YBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Apr 2026, at 3:32, David Hildenbrand (Arm) wrote:

> On 3/16/26 17:49, Zi Yan wrote:
>> On 16 Mar 2026, at 12:23, David Hildenbrand (Arm) wrote:
>>
>>> On 2/23/26 08:34, Ackerley Tng wrote:
>>>> Hi,
>>>>
>>>> I hit an assertion while making some modifications to
>>>> lib/test_xarray.c [1] and I believe this is the fix.
>>>>
>>>> In check_split, the tests split the XArray node and then store values
>>>> after the split to verify that splitting worked. While storing and
>>>> retrieval works as expected, the node's metadata, specifically
>>>> node->nr_values, is not updated correctly.
>>>>
>>>> This led to the assertion being hit in [1], since the storing process
>>>> did not increment node->nr_values sufficiently, while the erasing
>>>> process assumed the fully-incremented node->nr_values state.
>>>>
>>>> Would like to check my understanding on these:
>>>>
>>>> 1. In the multi-index xarray world, is node->nr_values definitely the
>>>>    total number of values *and siblings* in the node?
>>>>
>>>> 2. IIUC xas_store() has significantly different behavior when entry is
>>>>    NULL vs non-NULL: when entry is NULL, xas_store() does not make
>>>>    assumptions on the number of siblings and erases all the way till
>>>>    the next non-sibling entry. This sounds fair to me, but it's also
>>>>    kind of surprising that it is differently handled when entry is
>>>>    non-NULL, where xas_store() respects xas->xa_sibs.
>>>>
>>>> 3. If xas_store() is dependent on its caller to set up xas correctly
>>>>    (also sounds fair), then there are places where xas_store() is
>>>>    used, like replace_page_cache_folio() or
>>>>    migrate_huge_page_move_mapping(), where xas is set up assuming 0
>>>>    order pages. Are those buggy?
>>>
>>> Zi, do you have any familiarity with that code and could help?
>>
>> Not much. But I used lib/test_xarray.c to did a test:
>>
>> 1. initialize an xarray with order 6 and set entry to 0,
>>
>> 2. add a new xas like XA_STATE(xas0, xa, 0);
>> 3. xas_store(&xas0, xa_mk_value(32));
>>
>> 4. add a new xas like XA_STATE(xas0, xa, 16);
>> 5. xas_store(&xas0, xa_mk_value(48));
>>
>> The outcome is that xas_store() does not change xarray structure,
>> namely the orders are preserved. No issue is present.
>>
>> After 2 and 3, the xarray is still order 6, but its 0-63 entries (all order-6)
>> are changed from 0 to 32.
>> After 4 and 5, the xarray is still order 6, but its 0-63 entries
>> are changed from 32 to 48.
>>
>> I will need to dig into the code more to explain how xas_store() works.
>
> Zi,
>
> we discussed this topic with Willy in the THP cabal call. I did not get
> all the details, do you remember our conclusion?

The conclusion is that if user wants to erase (or xas_store(NULL)) an index
that is in the middle of a multi-index entry, they need to split that
multi-index first then do the erase (or xas_store(NULL)). Because it is
documented in xa_erase() (or xas_store(NULL)) that it erases all indices
of a multi-index entry[1] and requiring xa_erase() (or xas_store(NULL))
to split a multi-index entry and erase the specified index only is
too much due to potential memory allocations during multi-index
entry split process.


[1] https://elixir.bootlin.com/linux/v6.19.10/source/lib/xarray.c#L1640
>
> (I can try getting access to the recording)


Best Regards,
Yan, Zi

