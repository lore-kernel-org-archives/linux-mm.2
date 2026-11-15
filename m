Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16887606A33D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qG8oUBWL
Received: by kanga.kvack.org (Postfix)
	id 3C7426B05B3; Sun, 15 Nov 2026 18:57:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357076B05B4; Sun, 15 Nov 2026 18:57:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219126B05B5; Sun, 15 Nov 2026 18:57:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED1C56B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:57:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 713C91A082D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:57:20 +0000 (UTC)
X-FDA: 85439017440.21.1CC6B14
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011041.outbound.protection.outlook.com [52.101.57.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9306420003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:57:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qG8oUBWL;
	spf=pass (imf31.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.41 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794787037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDkWQmhvtsTHCe7740Md+HxTNgbsS1JohR6q2CqGb/0=;
	b=PFckaBFkYCBGzVqRE4d0X68ozdWI71RSadl/nIcHOEDPb2oqJ2eoa9mqEbxuKFnG9Cvx1z
	2htHy3TX45mqBkPAqcUTEv8Qke6g4oVzcQYrSfbOfNt13ISJLVd+rXnR9hUxaDz57VjRFy
	Uanc8Cm8+j9QHR6jKE8qF25Kiln17mw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794787037;
	b=cLJqIrGptSg9CfDr1OaokjOUQcYdk9YQVGLtnVdLKKm4KLBR6gUs2cYMRSPKg452idlsQP
	VR6ngDQBP+BbSPumVgNGJKqZFhxO7iqUcjtdWn6YsUnueR/pYk5DZ404LhgOayciMJ3rUB
	bN2BG1K31zOMsybS6zRulEj5kk7ZopA=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qG8oUBWL;
	spf=pass (imf31.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.41 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kkuj2du12SzUQCphHL6hBGS/XlROwx7xeQCFxcAmK9lGymce1W1q0X6Pp0S/wUxTIKUQl22zc/Q3onVAQk1BgDSRVQunYvM/MsCo7ymRoTYkp7UnJ5cYhZc7D1qZLMDiFPwDIuzgvfFvfV8AVOeTK4z4Rl5PFdnAkUm6c/Hwjiudw7C9cKYN9oEMddnGcYKytILc88hu2MuyJUmXejNButJJQVXBMS/kFtHW+0JOQm7cMPldlK5H7VaNcUTfF5eee17fboV6O4QLyROL6vsSR8HAzWonQYD0q01Sa1A3oJr7azjeY7qXj0egAih4ko2m1MeDz+q4DaM1pxl8T6oYYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDkWQmhvtsTHCe7740Md+HxTNgbsS1JohR6q2CqGb/0=;
 b=N0Hkc8ySakK4+KuoM4yT0/zSuF10ITvxPrGE8LNAzJRWNAHHQCNNIhvcnGp04L8nU72tuBH7ihMQ13MN8G4f8WGANXjLjr9Bae4fNJk5BCKPKDEUJ8JnJ7YgR6YQS5ZJNQSBgOnaAVf33u0MidqEfYrL20HxVn8qwY2S3EIiMZ5dYYHROjroFGSssTS1VV5AiQVHAeiVYk7hogArHIvKMKK6vNlMQPrxrQcvBOIVILn6+WhecgNGy+l02TrTeaUiolUtDh9zdOpdbjGlsGdB5r3NW6XW4h3dDiq7o42f/S/TRIuCNIZjCZDVbkhTwUUbWb0wwyhPbUFrD3ZtmxzVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDkWQmhvtsTHCe7740Md+HxTNgbsS1JohR6q2CqGb/0=;
 b=qG8oUBWLBsqd4JJMjuiCxpePjBaphJHT09Kj4VbQKqjKNsrq0hPifyfojvM3eZo7F51fJnSZY52cjtl5HTRZlVYysvtmZXyqbq5VKDMghlI3LqMXDf0OpBuw3T75MIqSrFEqo+uyv9xDuLd0QPShf9mXAFoZcl5hEUrZ/3Z3wKIC5iwQ8kgMWa7eueNZcE/nlW4XmaX+gF2qBheawbJRkEqPPRQ+l8/B+CT3cQd4A/U2cOIUYtAb51tNN//bxivcQtQXkCLWwMQcjnBFH0L77baBmE5p2JuIrJoDrdz038dtQPabrqsxzYoEzPajLXabGCd856xLObOsyEzOdCcfbQ==
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by BY5PR12MB4148.namprd12.prod.outlook.com
 (2603:10b6:a03:208::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sun, 15 Nov
 2026 23:57:12 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:57:12 +0000
Date: Mon, 16 Nov 2026 10:57:06 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/12] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
Message-ID: <avpGkikSWbIKV_Np@nvdebian.thelocal>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
X-ClientProxiedBy: SY8P300CA0023.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::29) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|BY5PR12MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: df6a5ce1-cf1b-4ce2-916b-08df43742a8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	l+GX+Dk5z6EhaiODCylwAsZJNeeA+GDzqi2b4Ur60niBrIqJ2vVuDDrgVLgHGqWFesbktBLAxcPov30R/jDLXCRoetPgGjsFvEfoRWjx/y2t1zq7R9ZZX3yDywCm2BIZvpdz8y7Is7VMF+5ntYH5p3JdTXjwCjFy3awfRBB4JiUUopzaFFOMB25lm7ShkksobSnU3szh3NnFgSIo/jLeTzcI9sGomtMUrIsapjo92eg+65+BHMzojJZxvOPxnXPr5KxKK36+1BZNuhT6Sdvvkm0rOWV3HFDjMuegGsXQjMjUXbwSBYDbNaV7fiCkVFz2SEDpkFPf1ZEARwB+HEH+OJtT054VDyGXwl6U4rczy2eiyQILdMn3/UBMZDthNQ2LjQUutF2T7XMpb+HZmGVTKmWjzYL2Znez3vuDAUkZWULLGUAiKtpLnXFRxP4mhAvdwkF7bIEpPHdbf4OV4YN5a99e2HsQV0uypoPUOIOtnAoPrSSE+cQ2oNpmBeg+tth6lxqeq9LWUwlJyCYxzAha4mZb4q2pey1X3MT+DM84i4G9bxu2DgIBf9Ai4sT1yjKC6lJVCgHUEoK28s2vaci0gaK7BAF+uoLgGwutHkAaTGsjrf+3NXRqbAJwOh2dK49Fgl7nXBO/ePtv2oFykF68YbrwVJmjaVLihslMd3ofTjQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8nM38xqHbDQpAQxpcgdFLOVCmMjr22+quaHkNz/nYWRnRKfCmoj+oqL4sbVy?=
 =?us-ascii?Q?xWzGDrUvBQWB6IMohmRjoIj+H5WPz1rzYDCkReV77yoqqm/yiEdvkDdHbGQo?=
 =?us-ascii?Q?Bb2FB35fGy8oIMeAHaZ6/O2mUCuV61FivlWntjhprkSTS1iyC7sqH1/aDYZ9?=
 =?us-ascii?Q?0ZzfBjpGejgiVPqwUjdmmlkEpbpjif6TUgbgFoBsb+tW5b0soWxC66SE7FcT?=
 =?us-ascii?Q?eAOeXegKaIswnx0eAdIFCcuZl29RqaZC8XAMw3twPbBkefGSDX+sJ7SVXTcQ?=
 =?us-ascii?Q?/1z2iY93gZkFaAe+PewkoAvCZ0PRRdJ0TMToWnY2u2SW4k1Enw55NyMhWLzT?=
 =?us-ascii?Q?Ei0aWs8I3R6eyw5RKYfMQcWNQS6DUzZ3+vB2SF/4W993n4wIQ08Dfm2WQsgh?=
 =?us-ascii?Q?HKLUMapoFVmEOlY/t70Wm+nxoX+VjzWjt94o3jmTRz5mtE19zcofRdMCbbCv?=
 =?us-ascii?Q?XlVreyBaFJustv/z4e/IhFX+ArjtASCcf6lRc3+auBJzCrMKLwaInBfgbahV?=
 =?us-ascii?Q?wOz/Q4vVBYNLJNTIIMolhQNZLkb9A98di4QQIX73EWcLfJWvF3DQ0pv6L89q?=
 =?us-ascii?Q?W8rTTMfJhIjmAL2X0siWJnuPK/zm1rAYgUYKHi+CgN0+k0mJAwbXvkBxP6oR?=
 =?us-ascii?Q?0tWvSsSzo8OWguGXsrcyz97TQltWV5C4oFzu3vgPVQby/0E75dDpbmlXY1TC?=
 =?us-ascii?Q?obBvh0RloVwI+FoCOCXnlDQADHRjuXodPglhsk+MmtiFjPFQFrms3tzTRxZ0?=
 =?us-ascii?Q?ZG6AMvB6XJ2SQU9W2c5yAnxbwqNKGwn/l+9V74XFXioorakWXZKbXJEQ/AGJ?=
 =?us-ascii?Q?XZsjFMMy82OCshv3ZVu8SF64sOvlATRnT/Sz/3WcG+Syw5DgloBQ4Ombkoaw?=
 =?us-ascii?Q?kTMmaZBpOb3cUVu9VtYtxCxPSX04C6x4dkEntuMRH64QDBlvE0E+5xWeZ74/?=
 =?us-ascii?Q?f5PuEuc3DthqmjxcXLRsQV3DjT/ZVt+1kVnJWiE43UNrv78l1ewJxxOwW0G/?=
 =?us-ascii?Q?sYjWib/3E0GHg8JxxCxnqKo1vWpzkkzjJtnt4g4pvKoGQp8wpwQxqBDHwsu0?=
 =?us-ascii?Q?9J70jHBn5hovIA2biqe6Z0cuq8qbsv7roWJqG5s+nfw/RCUTSQCpXGn4WgGc?=
 =?us-ascii?Q?MC14FNxW8WmgekAsT2sUcOVtq/rlYtIvyUbjt0MmMO3Oc+YGf2gdCd/ubKrN?=
 =?us-ascii?Q?XDvcQdqN3FuVq6uweTUMR42s6JFU8MHPcluGG2xhy2vTarMYWeidSwaG2Ywx?=
 =?us-ascii?Q?9Lqs2UtIw7Oa63VP3DXvuCc+YqxZk19hX3i6vUqLhyO7OIY6d3BAYLd7auPB?=
 =?us-ascii?Q?qMWMM7kO/H6vA0w6mUetG2PIa7kYDokN5ghWJ2V5BjJYWQj0ntsZAgp+WWu8?=
 =?us-ascii?Q?sz/eAnIBKqxnlbpe2PFL5Bz3FfcR6neEEqmMvUTIMOkAQiLKeIw2TXKJwgDi?=
 =?us-ascii?Q?QbnBzzOZDrc6afZfradHDFk0ryzyQIuZ6qKFXrJE/MjpoNN0ciT9THoa4KNE?=
 =?us-ascii?Q?9OtOLeqbDgcKIMeEkbZIlG8hUfi0liaAFVZB48ypL1R1B15ByAIkGQhiw3up?=
 =?us-ascii?Q?dYpSSyhDZJVNhNL2HcR0zhLOg5NobHKtM0byHAsle70OGo3mXXnEgWIw+JEX?=
 =?us-ascii?Q?rKnLxUW3IohI6YIJKYf8DcwVZaEB1mFhJuszoDUwIf83hCDO2ZYqbR/ac94C?=
 =?us-ascii?Q?qB0nTuyRQCbJ4JyL3IoNZ2Q4s9OMJIyrOvtysE4P1AR1WYRudyYFFO/U1RXF?=
 =?us-ascii?Q?zblCGYvkLg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6a5ce1-cf1b-4ce2-916b-08df43742a8c
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:57:12.1199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6fn71NNVJxdJ5WuTH16makzTpZRMGnAci1OCiYZki2gOTI0dXQl5O9/5HG0P6z6c99skTHfjBiVRXHKzlWwlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-Rspamd-Server: rspam06
X-Stat-Signature: x3wx6kdgx13w5pndax6qtyrygwnr1m4c
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9306420003
X-Rspam-User: 
X-HE-Tag: 1794787037-468459
X-HE-Meta: U2FsdGVkX18k55B8K6TcyFj8tHiW6quv6j4v3JGyqBLY4QmA2rY+06hKvAZeskgTLpkH+DNIW8QT5izv/6adVCb9jExb7qbnq35LhNPAXI+O+MQTUgGrPKGU/kowasVTeREY9lnYvd4Rj4TyYsWnWPrMJMz0ZmyNtHS2VTY91EgpCNOIl4cIxbsd+LBHT2d1m95iZl7daA6OVyMB5j7bDOI1qz3/gN8x5L7dvVu3L+dCmPSq93C82YusNy3B5ePMWIx/dwOJDRLJ0Y6l4nrnmv9XJS/FE5lQOcDqm7yg9ky8OIftq0qHIiUP9uO16pNENwhwhAWks2d7ZMpJCT7An9Kc46s0RIziECBg+RFF2mBvEGq3N0g8x91lC0TeRovIbzxize32EFTz+IIhHME5ZHM832hNjrfO/e+W6PmrioicDsVofDReY4fd8T9b90+uLDE3oy5sFOy4Q3OG6ovNbEBdDDyTcHInpSykZtbjkY51uq2fwJS6ZQ/MaqFuq9kod2l32yDPGM+jpQDNZaIfu1mhGDAI1+NkO1T8g49FrJQogOYQ9yZvhYfpsgyhsCYhcGeRnJtca8CvCtkjdzjrjuJtRj+IC4WvIJeBc6C/kl1hO9/dNK4dzTyK4WsZ5bviUwpfFaMo7ywxr5W58hG3nvQPnY29sxfP8OlbYqXBk5cuRIH6xFpR41vi+6NNiZEpQ2FmjS6RQRSZ/dETn/bm8m5YvrYwleyCI64EfDvf8WGRb2lGcY8ns0yfvAeAxxhxjWp2/QGIegqw4fNeSaIj5w73ef+B9tabi8rMCfH1A2oFusLgtEtfpOBy2O09CRfkQs4H1LHRpexZjhGxJjcWf5RBLIj1zUl9dANXRp0iUpTaiskvFIImPjsskyogmzIUZxLRURTJZk2ZXz89rk9SNIU7Ot2FvejGIbZvO2/k90VJx3O/YuUWppj+Y7vw6Rs5jz+Ct7enurKfjgilYhx
 qXQaXwyi
 AFiANdK1nQtnfrZ2Qf1PaUOaSerz4eodyOqs8LGopBF6xjm6LEI2tosooFLcELn+vqv/x0h0Ot/hpU7e9anu5P+8ae6KmaxRmbf+XidIaLt51GheETGs0AUtbNaAvDc2eh74vYHb/LJ5r/kC7/0ZxnWjIipahps8vSKw0qkqpajmLyUVV7mEdvAKbjmRDBUAQryc6Pdzo2U9wM6szg/xMCBfp1a+Ay11u1w9BnCGdUZaYzDIwmNfAnOsMhUQMXhUBAWWkEVH/EOtNis/jUKFT5SY/+R69JNXnL3cc0vHyGl5nCeeeuJ/fk3SlcJ4s759TV9lgXS6CRqU5/Ifi5+C++PZx6Kw0I+RZh3JgPDKMGtXZoc64EYuqS6yDnK9SRnrOtPmeSSGWJnivE/UegUB8zy81cazSulD7a8onJ+R0ulaa1rAtZy88behaf21rAvtfhvSLUsPJnyE/5og3dH9L4n3lPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12 at 04:55 +1100, Tal Zussman <tz2294@columbia.edu> wrote...
> remove_migration_pte() makes the restored PTE writable for a writable
> migration entry, and only looks at the uffd bit of the entry otherwise.
> A writable migration entry that has the uffd bit set is therefore
> restored as a writable PTE without the uffd bit, and the page is no
> longer write-protected.
> 
> An entry with the uffd bit set must be restored write-protected, whether
> the entry is writable or not. remove_migration_pmd() gets this right: it
> makes the PMD writable and sets the uffd bit as two independent steps,
> and pmd_mkuffd() write-protects the result. To fix it, do the same at
> the PTE level, where pte_mkuffd() write-protects the PTE as well.
> 
> The only known path that created such entries is PAGEMAP_SCAN. Now that
> PAGEMAP_SCAN downgrades them like change_protection() does, we should no
> longer see them, so this change alone should not be visible to
> userspace. If another path ever creates a writable migration entry with
> the uffd bit set, the page now stays write-protected instead of losing
> the uffd bit.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

The code change looks correct to me, so assuming you address Lorenzo's feedback
on the commit message:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 28a8d7734735..d200f64b5f98 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -399,7 +399,7 @@ static bool remove_migration_pte(struct folio *folio,
>  
>  		if (softleaf_is_migration_write(entry))
>  			pte = pte_mkwrite(pte, vma);
> -		else if (pte_swp_uffd(old_pte))
> +		if (pte_swp_uffd(old_pte))
>  			pte = pte_mkuffd(pte);
>  
>  		/* See do_swap_page(): restore PAGE_NONE for RWP */
> 
> -- 
> 2.39.5
> 

