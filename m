Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D9ECE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942108E000A; Mon, 17 Nov 2025 10:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9196B8E0002; Mon, 17 Nov 2025 10:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0EA8E000A; Mon, 17 Nov 2025 10:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6539D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:36:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1790E86D2A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:36:13 +0000 (UTC)
X-FDA: 84120500226.11.C19E6C7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8DE6B100019
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:36:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bzmvL0mg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d9pVIxx1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763393769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7htE5jq95wCdzLuYau6S01VC2lwmXoDf1TmOONyrvU=;
	b=IrZigbpNL4I7K9QFpnTQObdeuCNGVc2tf/+Su/n4NpWmFOqQW30Osttuv1NuxR7ZD3RQgA
	fAje58SJtGGdHZCHafohc85tVK2K6SID4sYVv3I/oW104NtGKtB7qiYh3K+fNAThjNasbd
	gMHsh/FMRIg4G9+L+A0Edginbwqem7Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763393769; a=rsa-sha256;
	cv=pass;
	b=gpMDdPQuLGQ7pKKfu15qHWGW4/HBOjZ3zwIOPLJdeL1et+/XMDx+g0LWj3onubNXcTak/T
	4LMzrmbdHlumxpwvK4QAK73mShom8YqYxvCUOqVxgrI+tVgLVDuuLDxHUU/XJoXMMMjnZ2
	FxeVfmSdDPZEpFR1dkITC01zhRc+eZk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bzmvL0mg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d9pVIxx1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8NR3006073;
	Mon, 17 Nov 2025 15:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=K7htE5jq95wCdzLuYa
	u6S01VC2lwmXoDf1TmOONyrvU=; b=bzmvL0mgapMQ7nlx8P0+0eC/oG/px2CoA5
	ScBvLmVrSQOOejVCjGBXAahR0C3t3fW64mv18dFjRhgMLRAtkxqIL5DG6ESpEGm1
	MsWmbtmgjwb4NEqxKqzyocVncHckVR2uIGClggEpV6QTP96r0A0qx5inVZgua1GL
	jjH3aPiehWkOU/7B7+/FX+v8jRz3nEs5Pv8bcY7kd7+pbNLB2MSBBUEVMkXTDZ6d
	xrVPgnQp+sYS4ro7eT+/eLQY5yRULIEGisAEwr91XfNBWaeaIYx++2JCOQRQ1vE8
	gtusmNZrCM2fIXWmLd+d2pjijj+8Q2JyPZ9JRCVKUuhBLqesPM4A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbtqfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:36:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHFPt1V035937;
	Mon, 17 Nov 2025 15:36:03 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012070.outbound.protection.outlook.com [40.107.209.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyj3j7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:36:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FKj79WMok3tUaB75dGC1EklH8+y2t1J+GqSAkVYp8SwtkNufhe1K50xW0E/udq1BXtYFDVmD/vZ2MNBUXufNOB9ZuvXxM4BKrGhKPKkmrZbWK/Zy3XZu1392EXH1lcSrLopYJOZK5o9XKuIl56920mTa36wLl2tkmsBq4AbWyuMjVzSdqsBReZR9ES2u5IJTL2PWmpWZcaH6/jkQEa7u8PMqAUMXpnQXZqWjM0GM2JSEMQIRoEcCfdCJr0F0qSqc8HWafOghuPg+kxs2+6i5O9Wz4ZtJGqm6sTROiAgDr7yZIs6Lj2EfLyJFZNCmh6u+onA8K4g7uvcjABrO14KkNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7htE5jq95wCdzLuYau6S01VC2lwmXoDf1TmOONyrvU=;
 b=Qx03wLmzitHt/PE6VG9Sf8U96LI4Cc/7ZZpUuifY3flHFKbJfcQReoqFdUPkESH+Y5PzdAZOf95LgMPaRc0nvo9KuxsTkXIrQ4QmK4lBC7d05VKQmjgy79s//HOQS46jWsXGyx13e+fyBf/Y8hZ9Rycswc23bM6pmnQq6Jfyhd+dPdCr8y5YThc2nyOzvuC9UYeLUtvnx+EsI1WjaxXbX9Fl88OH6NsZD+HPirbhbIIzVIk0OTKWDTR6OMyq/OYFx95P0eCi6JXzVSdWIGlPB+KcjQntVxqiMJIyvHj5hImwJBcxGNO9UxhTGSdegCHFg4awBZnDs7n+zSxrJX1p2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7htE5jq95wCdzLuYau6S01VC2lwmXoDf1TmOONyrvU=;
 b=d9pVIxx1HyStZwwEmclS99ZidIjRD9PbIm4zIf2Lou6c74ITnQqNXapMKyYrVq/n9fpwwq1rw/GhQ6689aiV5cKmiTPCpkc1LQGLQMyEQQWxIDxQzexd0FKOGVfItCNjbV7P028B3KMHdsKmVQa9XFtBeycnekUeStMGrklo6rg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 15:36:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 15:36:01 +0000
Date: Mon, 17 Nov 2025 15:35:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-ID: <3663ba10-a16f-4520-810c-701fe2d18167@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
 <069adbf6-181f-420f-b2b1-0ca22894d904@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <069adbf6-181f-420f-b2b1-0ca22894d904@kernel.org>
X-ClientProxiedBy: LO2P265CA0404.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::32) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c58dd4a-4d63-4235-e9b8-08de25ef02e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7NMUXSzGYCgKWJwWp3USO+ISVUmzL1+7L5s6O2RkU27/smQIAJ/uuGs/J0UX?=
 =?us-ascii?Q?cKN45NBRZb+oTre1CQIjpCTVEJIw5mQecz9Qw+vzE69ql3PF6MK8IZlOUHTh?=
 =?us-ascii?Q?tzaSOwb8QwCXLFIHVsep9TMcKkeB6VT5mB1egu1Q9oIej7bKJn7ocfnXesGT?=
 =?us-ascii?Q?z8kwaADNjQoR0TIMqTOoKBXxxHLMDCoLNvs4i2PETfSEKbiySqbmct/Vjzgt?=
 =?us-ascii?Q?Ov/Ht1pszNbljDCO9sNxvRLw+aJPk4PARIfe3c70htoJwatt0s8WJUlfjkrf?=
 =?us-ascii?Q?aEN6oYTT9jeUcNEgX9H9PTNZoQoXydYpCL8HHDNYhArcVUsaD/oTKy4AtfiO?=
 =?us-ascii?Q?92n09+0MdszU36XztOa3dUzOcW6j+BMPj6PJkI9rPyzUPECahO5jyvS5Enf2?=
 =?us-ascii?Q?XeBkOVhrsC+W1sLsauC5eONfbWzEkCLVs4ztHkGIpBZ9N/xDK6XWGKcfu/qF?=
 =?us-ascii?Q?94+1HqX6C3TQLmhzAAeKfMQ7zvNrkVWWmor5TNveYWmyu2uqQpgGkTp5MrJ9?=
 =?us-ascii?Q?bsrWI1rfsjdqBg5g2rObU0XN5C6ZWJ+3CMxLF5RNpDq96mHVqnk6D5MVoled?=
 =?us-ascii?Q?KeEIk4IeMgPRQy2qPaBf9G0uJl9LtU5KB1sMIEGuta86mk46s5jsxk/OnYZl?=
 =?us-ascii?Q?pclhKYqNVq/EmCypwgvRQfGEvO4hzDRVXoLDHWdBgnqfFJoVnXHSUY3bNGnv?=
 =?us-ascii?Q?qqc6ZSYDLXhC0zOA0jeqFaxDe0saoHTL8EzCVKn0FQewib+OPB2990jpwALg?=
 =?us-ascii?Q?WEBiPxUs8po4Qxhyos6k/ugGmy9z8KLty7F95UTNla05VOXikXL+2ucJUab9?=
 =?us-ascii?Q?NEh9mj4K0m8Lazug88xhh4ipkelxAstBDepl9qQb8HrNCOp04lztW+cpuIFd?=
 =?us-ascii?Q?KdwQkPMU5PfHH+h+HyLD/CbOKL8cMhUvxtws0UNeuH1MNjxiKrQpaPLS6HqJ?=
 =?us-ascii?Q?PQgvAjofry9IgKyeEFX5PXaV/7BxB/hW1TlHyUbRUsLH2Gx15d7qrj6p/qOK?=
 =?us-ascii?Q?MkacrPslrlsbUzspMWrHs3Igr8mt2cwj+kAT5B/DD+grCgafoqMB+jr+pblB?=
 =?us-ascii?Q?dQ29VzfPHtEYgzBQi+6lqY3L+VHSQc55zy2A21YrnfkMBGmDyEgeQLg0pDgf?=
 =?us-ascii?Q?IPIpgoQUMlBfxrN2QIlQg1KUqWzbpt0NkKtsWZJr2LYpcmVa00j4DvYAfNld?=
 =?us-ascii?Q?SR/34lN32LJZ/XqN72PdMxuY7BeDOmQkrSg5J+qmzVZ3KrzTsj9PU9tIyPpm?=
 =?us-ascii?Q?ZEicQu4RVYBytKAgbhZNqtDUeb0dZLyhJkdpkgHwbQUXSfjL/Zwwg/1xwW0d?=
 =?us-ascii?Q?bGW4Wcj0h2REcq+e8e0IP6hEpSGSGuFiqR8QyUWYTE6tO6dp3cytumshgBLp?=
 =?us-ascii?Q?ZYVugwLEOea79ARwLenk2ipN1NMzrNJTgPpE6haTn4u+d1XkgUEUzgFpPkQ7?=
 =?us-ascii?Q?uIA/DyGYjahLWvFu/IPFGfOOJspY/+u0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wwIH8zWTQjbrVuhzEvmMsH3XmoTCQLS7eoOPfjzvTpL0lexxYb/vvCohrzqQ?=
 =?us-ascii?Q?bolEkoCOyjWKTNyWL20Knipw0apvcxh7Uz6tz4E12lIAQzp7hGP3a39QouLs?=
 =?us-ascii?Q?TSSUFo+1+JLDrp0yybONLA2fzlITpGBlayz+n6Bke6PrlVIjvXhPvBBOVQtK?=
 =?us-ascii?Q?yXC4NchPIg8liamYGnPxGrcE3ZKKf6xj//pLZW67n83158ujvgHNzPQdo5NM?=
 =?us-ascii?Q?mdyaA5Xh8ER08vQqMpc7uRGbMwRKbTGntdoggXdJ/z9ZO1L5GGLpwFTr2aWV?=
 =?us-ascii?Q?vDchpj3o2KgwGHb1aiMZTY2PAwa7d+e68A/7Gwx+S2+9Gz1LlKktnAufvFPs?=
 =?us-ascii?Q?tRhRrSrbTuVorHyo5vixseyitqOQaS4000AZy0Qg9GSmRzVFfinXykVQeXlB?=
 =?us-ascii?Q?qCYMFEg5erqYuUyBlVLttXKlVNGwmXbfGsQWAYLgDfLZx5SuWtj/wQyvOZD2?=
 =?us-ascii?Q?kbJ+GJRl19DVWGMZ0hONx8MhiKyjW7JWWVqKbVuICeprjzzFFbS4cE+5RaO/?=
 =?us-ascii?Q?Bffy0FGfRbmqDCHSdlLvv71/SLE6eTr3J4TM3xTJ/l/qGnnEhV2SwZLHWbR7?=
 =?us-ascii?Q?UtDwp8Hrg4JUDBSRXYksGPey2HcK0PxyjHIZ6eEIkNYy7Y1Qhv/WSQMOiftp?=
 =?us-ascii?Q?b9n7OW7O/0E94cdHk1D+79Y2EyGzFVnMSY6mSCYRjFbMdZeRqMO9Db5HJ8l4?=
 =?us-ascii?Q?EM7qQn+IF7jRPHOVDNe21ODlC3/uNgBnT2OtaPWmq6Bcajce1QfcIacy24Ac?=
 =?us-ascii?Q?hjsL09ed/T7MZUnm+C5+7a9bQp+ZiKVTNlLtzeRFOnUhH4J5kRsn3ZIIS5hx?=
 =?us-ascii?Q?Cqo0YRUsAcDTj45n3koznQG5Qy3LEmjUyeL11aGx7g9CYkL7d0bweLkVEXzg?=
 =?us-ascii?Q?TE5mQPXthtpSgM7c1uuD6gP2zYtRK9aMEYk4n4rQdjzlrDHe3RfBmkLC9EDr?=
 =?us-ascii?Q?TrzkPoXuVFGUKicKi9x2MJcN6fWYwEChvsjFisiMjRR4BSyQjRSdcOrdnkYO?=
 =?us-ascii?Q?JKef5SghUawhiwgoL9JhNOj8c79V/qtB2vDKinmDZXBf3G4mnpcK/tvYzPrF?=
 =?us-ascii?Q?lnz2nn4/Sj1kxe9F19PA8Zn6HJnZY10ob9AJ+h0Jgsidwla0VtQ8mQNgDGO1?=
 =?us-ascii?Q?iFONPKLb8qDimyylTOh8xpS3hcA0a3scn/0UtSKsTxQaNsVXQIsXEwVFkd5S?=
 =?us-ascii?Q?F8NX8SLFZof2mapFeFVUiWWwTI/tk09WrjRcDE0XuPwlvZH0Sr8uwfNapmS6?=
 =?us-ascii?Q?iSJLgGOFl1OTPMSGQa2z+1gBKRc1wQ8MEO/ioVAycweGTsZiZJmaibAQzk+w?=
 =?us-ascii?Q?EDGVQ+xQVbS/l4sbRTMJsldGVyb/SokUFld/bm0MiJ41SIvq/RSN+XMxFWCr?=
 =?us-ascii?Q?iYc2ePpi30/TYJuGlYmQY4u/K1q9kvaeNdPfGBHA+94jAPIldGG/oMATGNzF?=
 =?us-ascii?Q?fWpq8Q5p1ba2DDStjYiNsdF/42Baq3i0bS7HRxTk4ZHpISmreMO9N6O3xtQS?=
 =?us-ascii?Q?ov3o2a3iXV8LR5Ln0NIV4V+r7U1EGBWeB0xSiarumMwawP0NcTnl88IX4Ziq?=
 =?us-ascii?Q?eB9YBdbs1v5CAOCuWS9YOdUESbhXifacctcC6VGTcfjkm2iUgb2rogzR4C2a?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+LvMdaI7MWYdmEBmCS0paVnyem5D1ffInfEKyxxTIVEbrGvt+9jJXri4a3eTC6gCjBbdfjQU8kYDQ+Mj0xteHC5CHMXWgo9AusEEN/24B9DpYPYJNFTQ9lRiZWRaA2nThrYlgSLj9RdutrQIKqQ/YQYGY4soz22ZKvxSlm8dmWTEA52Jew42LLwKZ6+oo7SRR0tGjZmWiP4c+si6ZDjpqBJDzYWFg6MSTew8SxY/iIEyJYHj17WA1MsAjpxP9SljuObtMkgaSqBX2ffLOv7Ca2Ho6E1PvMDdFf576Uai4PXkDjv8dHgwRej7ws4saxG7Soh59n5gX/Vpwxlbk8G6/+lzz472Vg6T9byft3btCwH3ed2emsn/M8QI1GSLQzSHxYE/fhhOIsGcwW8WNmBG/4FvMDp5voSIlSN74uF3mxaR5P+y+rr+n4pvlNuMdxAm0WckKCcjI32ppsA2OYH254ZLiaBDtM8V3ppNdAdAxSGrYu6B6enF5Ht4676R5wZsDRKzpc+fJjR/qVg5kl7ea6PgWotBHsmSi7k0qMLlPwKwfxTJ/0V+q9uMqqxgIgGOfge05A7YHTm6j82qF+fm8M2u32y35U2aYaWfLu7sBmM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c58dd4a-4d63-4235-e9b8-08de25ef02e8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 15:36:01.0261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBPLmAwfGticUL4mmFjJwapNJC8M38LV8rsOedvh7Qoc98VG/If9a6wtTR29E7sse+e2FlyxRVQzIlCt7c44Z1H3TegbJP18SZEv1UW2y6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=970 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511170132
X-Proofpoint-GUID: ExLvCE8N3iM4j3E9mIDHxMHZ28mtwevx
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=691b40e4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=KqlOEK1dFKdBYh2KpIEA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12098
X-Proofpoint-ORIG-GUID: ExLvCE8N3iM4j3E9mIDHxMHZ28mtwevx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX0wCGEl5nah2t
 RHmPdNHV4F+HQmhOAeSHn09INF3O0myjvTPSwN3OJPuQwqv5WjV00NACr+w3EPG04OU/9S9zcfW
 YPzm1RFzxHYrMBrftZNx3pmrqsCdpCa/3H5tYLyqcLAOPEECIAUdfCalakN5a3/4QZETAsU/Ch7
 yVHhHgxzBI/APS2kXN37DVXu5l8FN1XLSLKO3ykTOm4MlSbh3kG2UzLSuom4ol/4rLA6ILmA5dk
 XD0NaRjKFbUJR51u/GXXvxQrLDsESM7iuK2FErTiddj8NA7R5/uD8yJoDIHGvXwQEZp1JnZBbdC
 18t/3BaAC3pKkGQ36/FMUIHH7FX7MxBRgpZtKn2KaC729UNmYzMhiCDHXo9eQjp+CT1zGVwyw05
 5LLIH6CTQZneKcDPGdy7aqkeefOp6d8WwB/vCWpsZAjeW9fv7b4=
X-Stat-Signature: yy9u5a3ckbz6uhtoxf1yx3tdt1kuk6jc
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DE6B100019
X-Rspamd-Server: rspam10
X-HE-Tag: 1763393769-984502
X-HE-Meta: U2FsdGVkX1+Z4FNPKx8kuiG5QIDKbcG21QSQlQKS6ew/45My7kAHw46XhRO4ZUNz38yGneVT7JbVWJiKVulnlD4p4evXoHBp+lowfJmy1pDY1wfr9LE1/FXd7ClbJ4vNlvkTNuN8tnPtaE/zZA8VDWxcSfmvxXFez6YCxZIZ5iuIeHItXXnpcqtmJpEl7ojbplOl3vSOe/AlCjbPpWuuUitMe9UwxMfAIWzBFUflru4KTAo/wMAYHpXc6OF1HojNGSAuNaUCs8N65CTE7qDgns30FavFSL4z5Rbpfcd8QRE4/RnSVaF7AKj/FOdK2dlj+T8VE+vAOMsFXkYSJaerGuCd55YVmXjbGRNZSRJL6MW9JHqUtidHcRJfVmo1Ee0iOZwEDwNzKU3qTO0dhKwfNuTm/+sgWnpELszP2mgYlNcVRU1Xyw/DkVTUKxRLqKR8btHnuFWt6WrCt6SYTEgMpP2+yPGgtvJaSP15iN79RV/ChC4Nfmhc4TnZpZa3WdKiKQitSr7ntP237YA0B1ZrkcwEeC9X2pwbG2ue3Rh6anaSV9nT+saVtbK2w5f6BItfcBVztYFc/f6bD1uICz43zAB+El/YRZRbw1Guv9NrddvK3kuR7cEd2OaOaL9bb16SYQbYDYRCkjFnkd1KSFwn+CTHrpyX8meT+Kgj0fQr64bOnuWDc96bM7+Q65B6dslDGi9Qo4fhDI57CEw+zjiJzxXPrlwF2P3DuruRXCbky3YJw3oo/1ILNqRL801dK0Q1G4b37KskuKBNY8y00O1aAtv/ktDnnW6+cJzJARVPr+isqoO7AIVEAKA3aEV6Pvmn//buOlEQArD7mJYRQ8DjTbo9p82GO0BLvdhw77d3BtKQAAvt816vsKnf+DjHB0R/26/BQ6ksd0oa8ExWqQwG9IvKcm4ns0NnQ7dmp9MYNfWLRw4NVUt1k/kUQKfZCfmm0ewhcoahI7G4XmW/Deb
 lmzon1k5
 c45eqC4B/MqYQFV8KIjEKzWQBj6dURytmaQHnp2/AOQu4MdTxFKp8kr0ooKwG6KNanPpv6QDn5tVoIFqmkUQ3ogNAwTPLnz/06gVU10H8AGMOpGPb+i+KhyEKpkXK3T71DKVqQGoyCIVDYeIzKwQAhYv0WbBfyip3LP8KMK9eN8O7uXofDNkwzA4R/VsPMe/SqkaGrt7xK4X/+AwbRm6FsmB6hA0IVrHj5c4ZGEhduLuZq679o5Z9JkrGMUbOI8kweT3n7I7LOuw9Ib2sLFMRVWFB5zTTXF4s29igs/Eq2AL7Mzfl5iNLOn59WeerbX8ZiAn5XPPC/OeHX4Fof1qTSvTHtXYT1rRXmX5y+GtVny21R4o6rheQvoeYupbOZfY/jUwGaRxoT2RgZsahaehThTaDAPBKhYEcdjcklElUsMw8RWwiNbOEqiEKQXBRKptRqV6lP9cR7yK5HH9zFI8GHKk8hTwI2aUbwLtEuqOW3MqIhpHZE4gpArXtdVn94DqV8ToGdSvZbuKu432+tAXAcWJLhcbVVQ+TzzcFeEEPCSnMIJ4/eoJIw/hP0CG9xTr0Jq4hX4b8hOGPEnbmwsJ/zLfukYx9w7UrFEgsyaTlvjIkvWFQ0RCpUncd6zFmxzM/zQieT+qe7C5kemaSwdMHGiZZ6PfqQt1j1b33Vd7UiUhlKC5949vyoywLLQvdxD9kMU0BT90r2mB/S7ck1TMoQ4OvcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 03:25:05PM +0100, David Hildenbrand (Red Hat) wrote:
> On 14.11.25 18:53, Lorenzo Stoakes wrote:
> > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > and do_brk_flags().
> >
> > However, when performing a merge of existing mappings such as when
> > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> >
> > This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
> > merge, so one VMA may possess the flag and another not, and whichever
> > happens to be the target VMA will be the one upon which the merge is
> > performed which may or may not have VM_SOFTDIRTY set.
> >
> > Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> > which solves this issue.
> >
> > Additionally update VMA userland tests to propagate changes.
> >
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
>
> Looks reasonable to me. I thought that we had that behavior in the past ...
> but I also remember scenarios where we would have imprecise soft-dirty
> handling. So I assume this was semi-broken for a while (soft-broken :) )

:))

Yeah it's only specific merge scenarios, and only when you e.g. already cleared
refs then mapped a new VMA and it happened to merge.

Nicer thing about this change is we stop treating VM_SOFTDIRTY like an exception
on merge :)

>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Cheers!

>
> --
> Cheers
>
> David

