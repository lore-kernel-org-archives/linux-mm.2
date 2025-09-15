Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF92CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E328E0015; Mon, 15 Sep 2025 06:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE6C8E0001; Mon, 15 Sep 2025 06:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7481A8E0015; Mon, 15 Sep 2025 06:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3248E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:36:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3DCF11A534
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:36:21 +0000 (UTC)
X-FDA: 83891130162.25.8030104
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67DE71C000E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:36:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VTMOPVXv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjamEPz9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757932578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAs9y1zo6KiKKbnpbj6WNJbwRl3p7ol0q6OE7GurwjQ=;
	b=Q5xlLxsvz0A+DwN+c20as/tLCS5YxVlipFquDQ3oFwo2XjGEmI+ACkw5y073v7v3/Bo+Cp
	RBO5whlspQZ1fpeWPX0cE5tgX7YG9amUXXY2bzdB8g2mL2JxnjfQHbRP1Rrv6Hc+eGnUuW
	j8JXLTiyAqPaZndnidl4LxtAKIkHmdg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757932578; a=rsa-sha256;
	cv=pass;
	b=x4kV+DKOhoITIGt7MyujMZNwZfpZz57lDIcPtw/RrDrizjhacJrPbT3rD0rprZ8A1iQ+le
	Wojdt77KRJggMtAYTCaujObvKyrRAIsmyGPpARTeCUqiPQf8TVBw/gTDlGZ8TQpHTPiMw3
	UYo27OlcGbjacznq0vxf4GddHvJcbPc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VTMOPVXv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjamEPz9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6g2QK021743;
	Mon, 15 Sep 2025 10:35:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qAs9y1zo6KiKKbnpbj6WNJbwRl3p7ol0q6OE7GurwjQ=; b=
	VTMOPVXvZqXqTjIDt7eVGI0KFJtNZ2+sHhex9V5galrjpwwv0pXfQ/8bvuR53Fyi
	aQwTxiPzf3F4dYq2Cr71PWTsO9UM9l5lzypElo+mSW/rEWSgqYlSy+vhP3DbkA6P
	8DNLQVFut30YPv/2PcFiJrl7RBOXtxwXA49pAFkMjwbmLxsf8ra9rAsvyXYrFSRB
	bU6EFXzQXpFyXU/125CP/tpR/VKkAP+GVzSkVeVp0f9U5PZVtxjN9QpbYdfqLGX1
	MNBKN7H9Q7mExpE3g/80DwEDhVUnlrFLCmRaZLD1U9rQ4CL1kuRrrwmjbqubbzb6
	fo3k4biiLXXUpnWVok6CNQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yhd244r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:35:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F92aAM019379;
	Mon, 15 Sep 2025 10:35:58 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011020.outbound.protection.outlook.com [52.101.62.20])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b3884-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:35:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPJ36RTQ+ajZSfinNoc/ZRFU73jBAN0fXAJAPIBid/E/pkJQquVi0L42Sc4lTLsozcDna1s1CQcOu6m9LD9pameDAAjV45uZqZWiDYEVffpK4GHq7Vc7zS7fyNZWFOyKGUPtb7M4bbnZBX2lNMEw+OlZPM3xmOF9D/HiQerVi4wLMhKDMpMFmDYsEyX490+F2m6i5JrNeT9pxOT4P0GCGKrl3SZuQvQOtgsL+Hmt9H9vjcOAYL/hd7ofHCuMRzfy6RZXDlMnwMCiqR1vuOikci78KDCNhdofREhW6zb15fNeH/kssrA1V7SPpnHeP0j6Pt3NhEDHsI/KlASCF2RNQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAs9y1zo6KiKKbnpbj6WNJbwRl3p7ol0q6OE7GurwjQ=;
 b=IpM+2LX0CCLb84Ycnl2ai4Q/7QjNf7apKZpz0qI0imDN9qjklQWG6YzklIE/HYIV1g1kUBTByi8/hhnOftIsoHwvYfQtmaVroTjNsb8Or2/zFRXuT5wN5oJK0IgD/dkw900n3o0h/Oxi0NfroGIU7bAeRU9i/qrrpn7D3SxkUxzs8OCXdxBuONpir6liNtnRGIDT/fnxAGHfsbbYW4na3PiFD0f+WYxVQveKyLC8d96oK5MnvopFCUdFlAuGl0R5tI61KOXP6B5X3oJjTQaIfHO6Es1APFvcgQeqXTM6/AE7t+JZEOs+D42L5W24nlri5UuzVJJ7FdUIs6Hn5j4HSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAs9y1zo6KiKKbnpbj6WNJbwRl3p7ol0q6OE7GurwjQ=;
 b=HjamEPz9k4fduUgI1QNUhU+a/nr1Z7GJL8/ShFpkuBICBNgqMzhmXQUVVpjZ8vHIz4ZlNiyXfococ31xQw74fh+GKkfKZI0m3+K/FnD6eELYLBZIjMhEoDej67yTAtsJnpvgLIgHYGfnW1HCcDUi0C9iCvLgphP3ON9P5FA0Z+I=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 10:35:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:35:55 +0000
Date: Mon, 15 Sep 2025 11:35:53 +0100
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
Message-ID: <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
X-ClientProxiedBy: LO4P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4459:EE_
X-MS-Office365-Filtering-Correlation-Id: ffcd75e0-5604-45da-d93c-08ddf443a680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODh1akJCQ3hteGpZd1hjTjM1TXJtZlNEclBqTGw2WHQ5YzRCV1ZFNEFERXJM?=
 =?utf-8?B?a0tlUjIvSUo3Yzl6UjdPeGc2NVRTZkhMT1ZEWDB4RmRQR2pYR2ljMUVJU0VR?=
 =?utf-8?B?cmJmNkRNci9kUmpYZXcveC92WFhyZVNsRWdYdG9nRi9nb0RBYVk2YW9xUTN1?=
 =?utf-8?B?UWJxTExEbnkxS3RHSnEwUXdRc0MvMGUvRGNEa0UrRmdzOUVGT0NZMkdxOTNW?=
 =?utf-8?B?S081TVEwN2VRUkQvU01zdUcrYXNtTC93Z3UvQzJGeW4zZS9KL0RhRzRsYVRQ?=
 =?utf-8?B?NjdGVkpMOXR6V3U3R0NBRUMwTzJEVDBqVndEUlBvbjRVUy9SazlQNy9ma3Yz?=
 =?utf-8?B?U2t5SFpqMXpZL3FBMWxyUDM5aGt6TkRKRUl6bFIxN3dxSHVLZ1VxTGNaL3E2?=
 =?utf-8?B?MkV3aGdQUFJNNzNLRldXNy83ejQ5MFlNTW1QY3grNFZWUzU1UEQ1di9wSm83?=
 =?utf-8?B?bUY1LzZmQ2syNzN3WHFHd2FUSVd2ekVmdjJqQTFMczFUaVJhTk9rYWpKcXNt?=
 =?utf-8?B?NUYvZTk3dFI3bVpqTWI3SVJEdUQyTFNydjdmSVE4bW95MWRrUkZ2a1crZktp?=
 =?utf-8?B?ZnJMQVZkSzVjYi9OWjlzRER5OW10VzBqQjRMeEZyb2FOTm1yYmZMQnlSR1Rr?=
 =?utf-8?B?RTJ0bk13eU5kekhCM3JJc0pPRVc2WFZ3SWxxeVdHT0hBekliV0FnVGpBbmE0?=
 =?utf-8?B?Y2NBRGw3bWcraVhFaHVNNmwzdWZ3bjE0b3A0Y25CWUlIclNWZ2hMNDdHN1NY?=
 =?utf-8?B?dGo4a0J4eklpWnp0N2NRdFZobnhycm5rU1F1TTZ5MExNUDNlR0ZYSHVmOVRW?=
 =?utf-8?B?UzBmY3RXeGtRYWI1d0RCU2tyR3dKRGpoZDVFdm1OcmVOR0wweXd0a0ZTOEZU?=
 =?utf-8?B?dWlzc1hqY3RZM2xlaFBBMjZTYmZ6RmlBamg3dElyVXRCMVRSSUEvNXhCbmdS?=
 =?utf-8?B?RGpWQ0pEODBWZVRtRlUyTnV1VS9zT0J6eE82RjJ3TzdsRHR4eHMrMWZvb0Y2?=
 =?utf-8?B?UnVpUC9tU2Y3TGFOMkw3andST1BidkI4TzlGdzRGTmQ0Snc2R29xaXk3MVlS?=
 =?utf-8?B?ODFncnk1cG5xaHd1cjNRbUkyM1BTUEZrWTZ6MFBhbHVXTjFpaGZ4Y3ZOU1ZB?=
 =?utf-8?B?ckVVUkVYeWJLam1UQTlLK3ZsWnVnTHRMeFN3VUlrTmZSd3Q4a2QyWHkyb2Yw?=
 =?utf-8?B?S3dUMlZjTnBxNEJoUTJDaTgxcWtaLzBvemVBOWpNVkp2N2JBR0lhbnRGL3Fv?=
 =?utf-8?B?R3F6KzZLZG9vM2JtOVczV0g1aU9wbko4VDhqWkdlR1BIeDJpa0RjTjhmT1RF?=
 =?utf-8?B?a040Um1jS2FOWHNlMG1qeWU5RmJjSHhkSUdZMkw0N2tCZisvdGd5QVdLMVJs?=
 =?utf-8?B?R0R4K2kwUUZ0NUdRYXY4RjErZXY5elNqZk1lZ3pPZFZDdnpjd05tR1R0M0Rv?=
 =?utf-8?B?YzZ1MUlST1pnRy94STNOZzUrNEdTQVBuNkU2OGptNndwbzdWakhFcy9YQkQx?=
 =?utf-8?B?UmFjMmFhaThOb0Y3NXZEKy93RTVxS21oZTFDWm1mcmlENkVhTGV3c1ViQUFs?=
 =?utf-8?B?TmVhTUFLNEZuUVdGWUJyZTEwT2daWnp1WWRjREVhMFVZLzNndGpPZDR0Tlhy?=
 =?utf-8?B?amhhVUhtSENjVTZzR0o1RUQxNUFOZVk5T2l3SmUwYlJnT1d4eXN4Q3MwUDlt?=
 =?utf-8?B?V0JXRFZIU1FpMHlCcjVQQjJkcDJYT3ZDL3FXWlhGOHdjbm1wYlV3TXA4NlYr?=
 =?utf-8?B?dmJ0d3BWekZob25OYWt1bThmVkNhaWlLS2JJQkJMUmYyYmdFWVg0dHdUdDdH?=
 =?utf-8?B?NVA5M2pQdjZMMTRlbGJ4OEZ1WGs2Wno3MUUyR1RVVnFJRTdxWldPd3pmaEpZ?=
 =?utf-8?B?eEVmWHA3TEFMRE02OXh1M1NDOFZZTExlaExSajhCck10Q2F6N2NQL0hyUUFF?=
 =?utf-8?Q?CgoSMdi0+2A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1hrUW96U0xRUlFHamR1eU1VR0dieE1Qb0M4dHVmcnJDMWpyT2RrL2pNbnN5?=
 =?utf-8?B?YmJDSFIwVWMya1lHS0EzSU9KR0lyTUZmdEg1ZDBrUFVJdm9pRGhDZnlWU1pK?=
 =?utf-8?B?ZWZZd3FETnEySnFWV2ZOVVFGcG00NEZDR0U4REtBWWRGbE1paXRkQ2ZBRzQy?=
 =?utf-8?B?U2ltU2kxc2RWK2xRZjRLeUdJL1YwZXEzTEkwM2RSSGRyWkswTnA5MjhXaWZD?=
 =?utf-8?B?amhCTmtTOGhKQStoSkk0eVBxTTNkanRlaWU2U2tPaUpKNnhHNXVNU1Z3RVNK?=
 =?utf-8?B?ZTRIc2dtVW5yMlVUN2x3S0lrMmhzSWQzN05oRG5pVmNMYTduVFFCMXd2V0JM?=
 =?utf-8?B?YllRUkRCT2JGY1JxcS90U3VsU2M0ZTdTaWY5SlVlbXptQXVrK3RWeVFZd2w3?=
 =?utf-8?B?NkQvUVdTUFlEZmYrbXd3bDA5SVVDa05GMnlFUXc5bFVNZkZFb3ZVVG1oODkv?=
 =?utf-8?B?MDR3SFJ3MHFlTnFNcXVuQnlXS0NmRmw2eC9vbEFpejFwOVlIQThCODUwN05s?=
 =?utf-8?B?b1VLMC9ia05XbkM0endWcUorQktOQTVRUkZXYUN2dDBMb0JRZGRIZkZPQUFs?=
 =?utf-8?B?WTl1SCtnK082L2FmeXhoK0NHOEtxTUh4WHRJYnNBK1NMUjBpdlRicTMrUEpt?=
 =?utf-8?B?ZmJWZndhMGdFcFdCS0l4SzFHT2VZMGxWVW11UXc4RENSS2Y2R3R2SHh0NGJJ?=
 =?utf-8?B?NXFrZCtEOEVrYnhUUjQ4ZGpCWWFrVDZCemRCRlpwWWc2Tk1tWE9mWHlFeW9S?=
 =?utf-8?B?YUJEcEdQeXd4NzFsRE1sQVh3eUdvUSs5WGE2enZZWnB6MC9DMmxPQXRkcUFW?=
 =?utf-8?B?WFgvWXNrWTBFNjFBV1lWaTQ0SGJnYkhOZWRGSjg0S3k3Z1JhYzFQaml5UkY4?=
 =?utf-8?B?NnhROVpPQUU5c1hqZFVaQzBYVUpoWHk3RDI4RjFWWmZlREFyNzVFNHRYd202?=
 =?utf-8?B?MlFiQlA3aU94cmhPNGRYN2pvYWNIRnJkQVhPLzRXb0VFNmpJcm9yd1hWaVh4?=
 =?utf-8?B?VG5QYmNMdlRMZ0Ixb2FFNFZ3dFdCOVNDRnVlMFZNYlNZck9mZlhLa0tKZzBX?=
 =?utf-8?B?S0l3MnVscmJGYlduNGRiUHRmbVBsaGxYcHpuT2xaTHFRL290b2VkTkU4ZC9k?=
 =?utf-8?B?Vk1PbG9LNDJOMUZNeC95Y1d0ODkxMnh1R0JuYWhndCszV3V0dGxrRVMzSGRE?=
 =?utf-8?B?Unk5Z0N4QlI4SVUxY2VreXFmbXN4QjJFUWZDcjE4dUcvTnJVeTRZSjd1Y3NT?=
 =?utf-8?B?azBTMUhPcGVWU2phSU5NMitJMWg4Z25pRlNpZ0xJNlRHM2w0Tkg4bzZZUjVP?=
 =?utf-8?B?TDlVdHFJNER1NHJ2b1AxRjdZc2UwcVZrdDdIbGdlYy9jUGo5T3c5UEVib29k?=
 =?utf-8?B?VUtyN2NyWUlrZFo4TmJuaHFvYkdsN09lTjNSTGZzeVVxUFk5TGdocHBEeTFV?=
 =?utf-8?B?WVR0cmlwdEI3NHdBWHRJT0NqWHpCQzZBZUtPeFpnc0pzOVRHSEtZb1YxRm1E?=
 =?utf-8?B?UHJGL0ZSbHFVa0RXOFFIZE1UYmMwTThWMHYvbTNCaWFaQ2crbHo0WGFmZXZN?=
 =?utf-8?B?ckRxMlA1VzN6UmhpZFR2d3NZdkxMLzBzYUxpbDVtTkRiVDRsdUZ3dGdyR28y?=
 =?utf-8?B?RGZsTDV1TjVXWTNodzZDV3NZSlJSQkNJOEVud0dYeUhsR2xjMEV6Qjc4cjRM?=
 =?utf-8?B?NzlObVZBMVp0Wnl6NXZnQS9qZG9qSHdwNDhHdWdHdUlmNTVCV2hubjRPUSt6?=
 =?utf-8?B?VXUra2djTnAza21YV3gwZW5yYWZGMzlnY2FYUm53dkVXOVB4blk0SEV3bkxP?=
 =?utf-8?B?YkRLQ1BXS2lBV1ZTV3BEaWRCSTREU3NBTVNYKzNIRDlpMkVjSWdIMkVUem5O?=
 =?utf-8?B?UDBzUTZyNGxkYVUzSUEzV3A3Wlgrd0FWT3dNR1JWdWgzTTBycDE1cEYvNFMz?=
 =?utf-8?B?em0vMlVxZ2xEQ1pjWHpmcTVYN002WlVvZXdpc0h0aXBtY295T0FSNWFOYUJV?=
 =?utf-8?B?UFowMUFvSnZJOWI4NDBORCtBSUxGYWhvaktWOWxFR0traG9ZVm9vNG5pOEFu?=
 =?utf-8?B?R3ovM2xyMEVjUDhHS20wMDc5Q05mSEdaMGdzdmhuZVREUXV6NWZNNUlPaTVj?=
 =?utf-8?B?UnZ6YWJwMnJKZUhUa2hOMlFkNEtnSSswSzJRanFWbzlXaEhrKy9keUlGdmZH?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fH7sxkhyYvNf+TsuBz3Yy46SWXSrM9m7e+hv4dCXApJ/CG1879CM2hiz4nGpiL2bzHLCMv6EvG4H9xdVo2NfDUB1tO6BR4aJYogoZU8SKImpUsJ//Re1HZ7VaMWT16dPDzIuEsscIkH//PJc6QN7WGAtD5zQOdXrHS/XjpF830wNjG6xzpJbNoddmbwWynhIAVgAL7hS9RB59U4REaLufx8pKN5j2Xlst0AVc7oTe/sIq1YjYN0/OhjQqOhvXld4j/BVI1xGKA3FdX0r7DaOKcA7M1ISCMveNvuUNxVg9rVfd3lvH7Dc2+fKfKrQjtqE4SfjOpXI5DzrCg25AnTyAN5yBecQWWtQGgyaRgHCet2Kl0xxuEmEdPUONuN4O3YWVMo8kKWQX3LrfB08b0fYEXN2bvBgiJGeF4pPVuf6Htl/3dntc2YKQySsPnHcESk4tbybRyfUrcWkIJaRY9k+87xmgZ1ZC1q9WOvCMjxWkAZt9ADEEyxDDnHsXGFPHnJ/6SmGX5fQFvV1YOz5Xt7qL4VrV5+aEsdW948Q5Sstc7zZjDjt4SP+JhGdTFz5BIbcnUz242TdJUucPHEKL1pK/yi1neoBx/fAwTjecey7IGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffcd75e0-5604-45da-d93c-08ddf443a680
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:35:55.0594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVkScUZ4BFA1W56TncIr1yJMtvjrsbHJsxGVAdeawJXe19YNri175EzSazVH/Gw4yzWMVmYzyAfHdDvwkZMga87NU3j/8N+SdAVWFjF+52E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxOCBTYWx0ZWRfX7U86eJVHe/c+
 qJAMjdBI7t+nBp1by9X1AvNM5DjMId5jWLKnUzPm3xu+xPlzW2np1w+iBy/2GkV3lVGjPjw/uOo
 zIUgqhm2MKP68kWiVYtkpoUkgVlF9OreqOoDKsp9fHd942qAFc4Bk4dvCq8ILampt7AUNlDmHjD
 d06jQL0zVwLZAhIXLPwoo4yVXv2uujojsnSy+eT8xOYfvJMiLUCj2Srx0Hjd8a5dx8a69I9+JNk
 MJ0R+R7LOLpz9D222JUk1LDwQSYEQy5QrVKR04bVaooFNoViJnKLvAdUKoFwGqGxC3j7yMkSUU4
 moUUOW4LTKjL+G67Ka10kiUIrS8wTXMM8m23+v+Hd4s0WLtZT1AxUTAWC6NlBtW0EPDzO8D1jwp
 ACe0zSmZ
X-Proofpoint-ORIG-GUID: sK7-ojJwuOmBF0HH9QO-LU3GZDYOxbB-
X-Authority-Analysis: v=2.4 cv=YKafyQGx c=1 sm=1 tr=0 ts=68c7ec0f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=XqxKOe8KMYB_7hxSnDEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: sK7-ojJwuOmBF0HH9QO-LU3GZDYOxbB-
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 67DE71C000E
X-Stat-Signature: ezgizerhig9w4t3hn3kjyjeoz5t49qiu
X-Rspam-User: 
X-HE-Tag: 1757932578-882963
X-HE-Meta: U2FsdGVkX19DeEhimutY2kaUlHN9hVJ1JN7K+7US+RA3cRVz+WA/qyxOSHYSWGL/VW5wuVUm3My2JTJRBNnjm+IAPboslg9kMoe1lY7wT1X4r7zYXi8rHEyQodlHA9okK1bPAP8eIRs1TMnntQmaOi56L3qv/4wCRbmM4EDSRcNcrmsNR2tbc9DiB8Wi652Vgo5ggKIEHbKFIm0Vj7FNkLOdsIbBxSu0dUyBHlwKZKZ9kzpHvQn8ze9X1Nt3XStY/DxKcvS8jqzhXhq/bbvtTJQkRER7oE5ZkwQHZyoMDc5T2n82AJV+c0/shYfrK6yklAvLBdm7LKGl+i/+sSUDRcSO3LD4HHKW4BAq6U10L9a38CaohPs0ofzK1SrrCx02aZ0qBFPxCBIRBZjyUjrOFNCCxzVupOHZOzVuIjVY0moVi8IT61y04wjqFZK3A80iAW8rsT4Kckqm/aZZ2Bm1O3VTTi1yDfaNR61DBQ6Wp0OUOOeS6s1fPlr0CKxYI6oAjk/BKR7ciYE0SRC4ik999N/e10lVy471H9f87Yk8ce+Q7ESAaXRkKFLwqe1frPx96A/g7qXddm1OdkXAwmo2lDm8+QhTkaDp1xS2cjMZBItx5f3YCetMsyr7h7dL1fvI0SyVhBY8lQhrxp9BYTOt+pOYMTj6JRQdvZQhRX2ZptQUVivp7yyGnHRe9vUx674H1Arf/aCtP/0P77UDL5e+ih8lVBQRi602z7w2vBRClAeDbMml+0ZEefXdw9ftBTFl50ZxKD5cym2adAVJf9GF4EI4p5iZIRe+LL48+zfp0oPTUrVoJgdG2OgJcInEZRgRrnUegrylV+DQszZUyMjZLJaUoUyyCua5qxdj/9kAYfaHE9JLAenpmHoff6mKtPDItxulJe3iXHmdAY/RiyP73Gsuu4tvOi51yWu7v/OrqpJr+RrfhasG8p/ZXr5SNNhTeMHHXgBenaZ31cgoEcT
 KSr0evcf
 3pSWzUE+5pnrrmq062RH3GQ90kU2YLwv4M1o1/PjV7Jr1Y8jUC3KIOeR40XDSx7eIjz4tQ/hJ76x8Xi8LQEE/ph5CMR/6A5XzpUKbTg/T223oTMP8ZthpcXUOCLzAM+Lqmumv7V7bH+N3e0uOs5ft7bIFy6KBjJg/6C+xwq/IpF7ln1a++t1cJGcAfh169KkliDU50rwP9I90nRJ6kiTolhFE3HfT28scfbXMyU2DfID4NIks4pxJsE17zxfDHuxe8c55kpbW5nO4v3PDLtHq3Aw8jRBy4V9Q1WdPU++PUgdK/JGrd2/Wahm9iuI58r+uw5kjUZh/sBrs3wZe9drl5mJjnueN5iqegkl98Y/JsmNnhkzXbouboCfpufmHL2tNSA9wrANd/xGuoOxu/kTzlybAFhDgADVii/ZpuLkFK96VFOPHMu+9xQoqnh0CPMrohZKr0pCzjuQpNeALKEkieZnSOwFQsio2nixYrfIxrkAil27NociiP5XZSu9O7/89hwEKzzG3ezmS59Yb8HxW8fi8DQ0j704DEmoa3DX3H2lq6keMiDm9oIIB5wCsRF/TXAM8M5vmg+zUA9jLpXumUu2QkplBMYNJkBN9L73FhWhlG1DGnTRg4nJ9ncItaOp6iBMnqcz05QoRyYKQ5lgu28necNBwu27sO1svUGzxkVNTVcVBQohLuGmZoELFJG2DrvLb0GnG3/b3WuicUAMgpgbGoJDP2VDbyINKRIP9LaDLYTKdQ7bMdAxsKZo60ne9UVZNymXINvK3qMqyUKADkXnQzO+3DWJO/6+A2czXUOgfHEA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
> On 15.09.25 11:22, Kiryl Shutsemau wrote:
> > On Fri, Sep 12, 2025 at 05:31:51PM -0600, Nico Pache wrote:
> > > On Fri, Sep 12, 2025 at 6:25 AM David Hildenbrand <david@redhat.com> wrote:
> > > >
> > > > On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > > > > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> > > > > > The following series provides khugepaged with the capability to collapse
> > > > > > anonymous memory regions to mTHPs.
> > > > > >
> > > > > > To achieve this we generalize the khugepaged functions to no longer depend
> > > > > > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > > > > > pages that are occupied (!none/zero). After the PMD scan is done, we do
> > > > > > binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> > > > > > range. The restriction on max_ptes_none is removed during the scan, to make
> > > > > > sure we account for the whole PMD range. When no mTHP size is enabled, the
> > > > > > legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> > > > > > by the attempted collapse order to determine how full a mTHP must be to be
> > > > > > eligible for the collapse to occur. If a mTHP collapse is attempted, but
> > > > > > contains swapped out, or shared pages, we don't perform the collapse. It is
> > > > > > now also possible to collapse to mTHPs without requiring the PMD THP size
> > > > > > to be enabled.
> > > > > >
> > > > > > When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> > > > > > 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> > > > > > mTHP collapses to prevent collapse "creep" behavior. This prevents
> > > > > > constantly promoting mTHPs to the next available size, which would occur
> > > > > > because a collapse introduces more non-zero pages that would satisfy the
> > > > > > promotion condition on subsequent scans.
> > > > >
> > > > > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > > > > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > > > >
> > > >
> > > > I am all for not adding any more ugliness on top of all the ugliness we
> > > > added in the past.
> > > >
> > > > I will soon propose deprecating that parameter in favor of something
> > > > that makes a bit more sense.
> > > >
> > > > In essence, we'll likely have an "eagerness" parameter that ranges from
> > > > 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> > > > not all is populated".
> > > Hi David,
> > >
> > > Do you have any reason for 0-10, I'm guessing these will map to
> > > different max_ptes_none values.
> > > I suggest 0-5, mapping to 0,32,64,128,255,511
> >
> > That's too x86-64 specific.
> >
> > And the whole idea is not to map to directly, but give kernel wiggle
> > room to play.
>
> Initially we will start out simple and map it directly. But yeah, the idea
> is to give us some more room later.

I think it's less 'wiggle room' and more us being able to _abstract_ what this
measurement means while reserving the right to adjust this.

But maybe we are saying the same thing in different ways.

>
> I had something logarithmic in mind which would roughly be (ignoring the the
> weird -1 for simplicity and expressing it as "used" instead of none-or-zero)
>
> 0 -> ~100% used (~0% none)

So equivalent to 511 today?

> 1 -> ~50% used (~50% none)
> 2 -> ~25% used (~75% none)
> 3 -> ~12.5% used (~87.5% none)
> 4 -> ~11.25% used (~88,75% none)
> ...
> 10 -> ~0% used (~100% none)

So equivalent to 0 today?

And with a logarithmic weighting towards values closer to "0% used"?

This seems sensible given the only reports we've had of non-0/511 uses here are
in that range...

But ofc this interpretation should be something we determine + treated as an
implementation detail that we can modify later.

>
> Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.

And at different mTHP levels too right?

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

