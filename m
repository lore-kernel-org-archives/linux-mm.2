Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A47DCD37AD
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723D26B01F9; Fri,  8 May 2026 12:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4B46B01FA; Fri,  8 May 2026 12:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C33C6B01FB; Fri,  8 May 2026 12:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B94D6B01F9
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:44:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6678120208
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:44:31 +0000 (UTC)
X-FDA: 84744825942.15.139CAA6
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012039.outbound.protection.outlook.com [52.101.53.39])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0BF1B18000F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:44:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LRjbjRXY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.39 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778258669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVh+mJ/1nYCzawy+c7Ai9Nk2MN+bNm1fAl8GRPeZ248=;
	b=SP5WOnGtntYi7YUT/uhJNA6FfUTO5I8IkvFg31g9eLNQi+QQnCaV1b6Ac7WzcvFksg5zc6
	Py8IEQsuQPoPsfKnNebODq9T8D2iXKZV/CUqoK/noOqj3Wq3+1K0ouG4YqUqpB1d3zjO2N
	CNwCGitaESz330bdnPQE+pH5yp7dTUo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778258669; a=rsa-sha256;
	cv=pass;
	b=22u7rgD+W+crvpkR6w13BcFqjg5C/N3IBSWahn8g2Hx4XTpFWVMuQiwBgBpy16eyuu7Sa1
	iwBfzwDlLXHUGovZTU50IqovlZFoPklkXMaVFsK5QUwQe7Axuw/OSIsYbvo3+DSaktkqeQ
	x0lS+JkCvABDo9PZo0/kJasGJh56/F4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LRjbjRXY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.39 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQ1ndRvTbUzxyuKHC7RD715/9dG595yKo77JVHFXgaj8gkL5RQVzhrT2mzMDdz5eLc9k9d46gr7BLE56fRs3ZRqabgPDYoroJWL/cKx2/ukMVb3vUdKyQvaB0+YBGbyn+D0W/m6QA9l0M3wn4ak7AvCLbVQzXxQ1Ur+QxT/t1nq/c2Hous7gmN1Dm5us4fKk4zeIUbq2gQKaOPq5wi/2J5syRqa2s36tkDnhZzHFsABHaAO8VQktUbcFjYTOXdM6FGHJ7MOee6PuOY40bS8nLGyC+yZG82xt22fFgejrrF9cRCzTFcZPowBDu3Oo24eV7kGMoHwKQft8lp/srUEYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JVh+mJ/1nYCzawy+c7Ai9Nk2MN+bNm1fAl8GRPeZ248=;
 b=YQeWCvBzKsLyxWLXBPakgElEtB1Z5RsT1g75gKxQWaLlhn7dS7Dq0exe2gURGXFFE/8wr+Co38VIyGsh6d+vK3GCq5xaVJfPznHJfUfHU2miwz7gJWZ2cnxN0y7mB7kv8+SdMb/M2CbnYyQC9ok6hNpTwHUrKA/9QpfMm/263kFfocHAudRMVKB2TsTorkBTYfHLJQdLlLkRrNzvW7fqCqjc6Ris1laQ2TkSUVihnGZEvF3gTGJgkswfq2MmCNcb0d7dr9SdOXUkyj4b5+nRCa/X2YDug7fGVsvIwBE4ox6p4WrvJfq7om4nD7PTbXIhd9Bh1bgjYjfJDtbRGAu4jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVh+mJ/1nYCzawy+c7Ai9Nk2MN+bNm1fAl8GRPeZ248=;
 b=LRjbjRXYj+hNgz1pZW6TX48j1ZANN/M03fd5EnNTGJhmaPqe+jDgfcllKkCcpsPj/PIRzaTl7n51ccbiphHLAxGtSrBl3bTj+bT38gpM4XGyPlch8NY1xfEUYnDpduRAx+x8dJKjXqm2Vb9TVtyKyUhWv8iS9uHK/CKPKFgrdso/L9QFdWuzRvUknT+6ZflJfwJPvR5i+R9xjrAy2KBOPCuGBrlOuKwKO3U0gJA0tAE1g+HA7XhanDFGF9njF/HAb6omM3uAr++TqR7Kph2Cjg4tikbdx54vz3W0oyHhbEs1nZnlSRUqWDugExxJkk85mqjTtea30FN6R9s7EIzhPw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CY5PR12MB6528.namprd12.prod.outlook.com (2603:10b6:930:43::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.19; Fri, 8 May 2026 16:44:24 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9891.008; Fri, 8 May 2026
 16:44:24 +0000
Date: Sat, 9 May 2026 02:44:14 +1000
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Souvik Banerjee <souvik@amlalabs.com>, dan.j.williams@intel.com, 
	willy@infradead.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
Message-ID: <af4SR5-QwUCAClR8@nvdebian.thelocal>
References: <20260501233933.2614302-1-souvik@amlalabs.com>
 <a708a295-9d80-4538-9d12-53c12820f9ed@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a708a295-9d80-4538-9d12-53c12820f9ed@kernel.org>
X-ClientProxiedBy: SY6PR01CA0006.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::11) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CY5PR12MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7b36a0-3363-4dc1-cac2-08dead210fa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kmAd7uc5LmEOqL4eQB6Gps32pmXqPFbNZVyHRL8XfRIE8JNFsky1baTmojs7F8/djBButoXSzzuYPUr5gE0Kmy8zQB0mVNuSQjBidau9U1RClhQMPVbqFueBttsczBcqjmjyY1kMC03dG1BVswOLoNWmyUd9Ads6BKUWwWM6hklGSlhSOMygTnU9eqzmFrcTIayhw0pfg4qDWwRdv10DOG90lwl5OdmZv7Uolf6LCBdk32bS4I4RYCd6UCNxxeNKYk04xWfZl4K1P9DZ2GB1djZZkaXU47M6t/hXXnRc/P7s5qmUxVwhhdoSjst15Y1FJQTK9JzY/+GOhKw2KmIldAPfLYUNlEHwi12YrmT/IipnupjBMJGkCb+3uzVLqzKhhrlkiK2tJJQlxA0wbkXDJzz7KG2Gcv+Mii7xItUj9Nou4TCgQMP3yMFB9U4EX/rIbCnkJYGed2T/8ElTxhYRujumojpY0vA8sO5p7j44OZfpyA2wytub31ILFmrdYV51EFcA3SFWtXwMDloMNab0pjTdjLr/nQtwf1K0/cbUcYD6o3KhLmUTTtscPE8HZXJ789+fv6OZqvxm4RwQUlmheEc31i7fZibyI45bxrTwE/6MXFsTlt7660JYWFqZaa2v4JHt24uLIWNUfYe8ctSeZUJMewmwRjehQx4A0ObKxozHMZO0fUT257CrDbPjapXt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bg+ovCIMOvPnQmErLf83WVuE+t2QKnysoZDcxh7nUkk5YTIHOggaUOeJVDcr?=
 =?us-ascii?Q?XfO7DRFkYWEBmyeCrK8A2JdiQXQx2wvDTVnxflzz6EwdP4N/A1gluH/v88q8?=
 =?us-ascii?Q?/ZETSStScNS0B+lN1OQ5o9t051SB0J7bEBgmkhrGW/OtZDk1ZWgN/8kmO3Eb?=
 =?us-ascii?Q?W4rU6F6oxS6cZ9J+mCc8NEOVSTuoRmZBbMwnsZXwOqNPGuH24X6n3qJ/Ui8m?=
 =?us-ascii?Q?mY8mLlZivaVSsptAtgaaSV8yz2hO9t9H5bPGmXnbXUMZCugF5N3KjRVSyQhO?=
 =?us-ascii?Q?psPyRHBcBXdooehWjDS3IpHyH3XtBKXT8/PB69yUZAtZDEi4RD2JKsEr7Ttd?=
 =?us-ascii?Q?cqXFWjdKRxh4+NeTiB/gWjaAeTUnsixT53iGdFa/6IwVMHTk41RpUj55OTBY?=
 =?us-ascii?Q?xtDbEl8VtprN0KpEazfoy54snykRfY6sa8SKRoCBYc7NEWm17o8iq5L0rGDF?=
 =?us-ascii?Q?BIa+EvhT8CyrIQjFcoBo5MT/VoY3gGWEn+wLMTgGwwZrvzw3ZcDKfdCafLnG?=
 =?us-ascii?Q?5KgbzuJ3h6PPLeNDv8hr1lLXBvKLgKxd0bgMTThbiVR1z8KYJexB8Ko2QvLj?=
 =?us-ascii?Q?fccEDkpQE2zEbVcijxHbDJHyrketYJtXfIsauoVD4TuWd9NkYqcnvBLDfzSk?=
 =?us-ascii?Q?UbVKcy81mRYFFhtBbr1g0kSCRqPcdTdm8CwOToR8GPDieuo7lZHu1uJueOQd?=
 =?us-ascii?Q?MUoXKsUT9YTUD+J+M3wDnfpaqydXZYdIAk68BQjOLnyt1dmUbbdonuPyFVDE?=
 =?us-ascii?Q?k+mvDESzemRnBPFT/T7b4kV2nRmPu+pTikkgdkIhgd8O7QnwlLBpIkEgnfiZ?=
 =?us-ascii?Q?fUp3tnbnq5xD8JVjo3Y3Z6qhkXW9E6V67K694QsBnpUnzNV5MJB3cNBCCq/k?=
 =?us-ascii?Q?dQ/H29cf61yk9nPrAKLo5qo/mn7z15rBJzH2gqT3XI10sCEDGPfKIdTprVrb?=
 =?us-ascii?Q?RLPfLvte/lgu71oYStdxD0RkxiWLBzm1bUKUEXTsXn9JbAuTv17mg3Ed8Kxf?=
 =?us-ascii?Q?Bv+m83YdtCMdfo31nplHHukuZhzBtG1xSRaSa9oOrI34WQIddbrofrqd0eWe?=
 =?us-ascii?Q?t5telK244pbJ90SxJV1L5uTM2ZM+YQvfIkF1vcsn9X1Ud2G0hhAW0wdAmYWM?=
 =?us-ascii?Q?/HEb2KJWTEfJ0h7a2UV1+NFPJClhFVHT1I1yZCJwRJnBtnN5Im8OulVeXJyY?=
 =?us-ascii?Q?bhxrdoXo9+7oXeDnXvAM1hatbsySwAjN6YecrLDmSrBErurYb8ZV+AOHpUfz?=
 =?us-ascii?Q?8B0ZdzfJLhuXvqY70lbimYafv4PzD2lYyHi1f0O6EPxRdC/MOVvzYJKTFALc?=
 =?us-ascii?Q?53kGgoi+8whEOrLYUndSbJcJetE8oweyQLJBh4r4PW7VrliEFbFeqwpaOiPX?=
 =?us-ascii?Q?Ibt5dTFB5DplIMUetq5KwQ3OrBSVEGwP0lVUxgaeIrwzJahKKZkDGPoLAkRC?=
 =?us-ascii?Q?MIKsSNrDPXsYuNX7TE6cd8JdQD2hJ5rVY1WBieOhAHFtR21voGKdDYjKGvFf?=
 =?us-ascii?Q?4UL3xfkIVikxAaKVF///QqjO7FhlCn8SjjjQu+wd/ufCtITXDQ4Rp/Wy+Thm?=
 =?us-ascii?Q?RCSfHzsK7Pv8s9kbYByB5+UbMzpgZEU6Sc8ZjN9AEznT3CiHj4ZQ2Fp23WCg?=
 =?us-ascii?Q?jD1jReywSxCofqV1EIjmNb+piC+DF+8vjO4ROIcBPtgWJm/YSCplR2V1hbR8?=
 =?us-ascii?Q?yWNdlQ2hgchSQ9baezoRPNqvuydb5z8+ZfQaUdZ6+OvmDw7amFde0NiTpWhl?=
 =?us-ascii?Q?XsyLRUvxLg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7b36a0-3363-4dc1-cac2-08dead210fa4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 16:44:24.5959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMu8ocvQbyfH8hd/SUbBtU0jF1+o7VdxUKHaVs5yoFaMsYnyz0ISMaSRiWZ5HuF6MfnjkSS32LDVKfBQj7qo8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6528
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BF1B18000F
X-Stat-Signature: b7jcbebnfqy3xqatqcgxi8dbi5f6ewg7
X-Rspam-User: 
X-HE-Tag: 1778258668-253337
X-HE-Meta: U2FsdGVkX1/Lk3y4T7scb2yO41nJtnI8upTw4BV968fR8jiw+lHLc5Cd7aXiO6cBoJ1id0sAOT0ynD8F+SwvmYn0IVZ5lLc3qVEJ3W9ZffAGujfeAfZKDeFuUu/h0XssPGhv8e5yyFY+kldwyETmMSuHM0mWVMvXBQ4kqUbvMSPLThHTSeheKlXg9t0ASa/dsGLVn6PTZtEfa5cDaYaeWGJK4cXMnYbjQyQJvBRJfVQ21ezVpzPOvCpmVt2gna7uzgD/l9bCDZhb+AeXRNxTIEBb5hTSDfW17VbRElr6KNzMSStnPZ4waqTKH3Ns8dyMADZ2KDa88rqpRvgyqesKk1UIZAnv5099YNmkEypGr5A5P+4aMz+PAZVKNbOn6ne810Wpa/SnMbNV/xigtmTZEHHIZXazZFRorYGl+4TrT8a3UBkAv3b3SKgq2/OofVDG7FsbNzDYBVwLbYFm+J8xCNX592LjcMgaGMbDdHGPxqg2l9PP7+EVYIQW0zlwVLGDkz2Of5xCDOM6xfWaZji2ykXvq9k3dfGMjBV6/u5f2aML5bxAx8lHXa+1gGQgZtZE4fCj4XKpOYWIB9z4Lj42M7BHHEdB5ZjpC2Nu9qgNNIBmQH/ux7GR1OY7ZjiWX+sHDF6s9lKmqknzWoYctIixbjgJix5OwXhD0DVtzpq8Yg/rCeGHF1uI24DiifCqx4ohFZTBGXNZOngRvAaXfUJYMXEMyiwoi93FX44YXb5h8H+caUyFPeuRSQaXDTrFCpkBaPZtHM1repx4gAQ/C38s9iI369kuaUBpW5p/qvM5mbgXHAlSoR9hwV8c0qHaCbmPDNkmawfDoDnYFPzFNJuL3tNooLrjfrfYoHC+bRwkv7ePmDlhbkrS4Ipv2Sdm2xi46ZKbuQm8I+iUiaM813sjXn1+bIzVA/RJQZHHgX2WtvAtYIRxvkjmfF1FsV19inYjyqTNdav/NewRd81kgYY
 G28QF7yh
 ViGFAn+3XNlT/VaZ7KU92l6kfV/8MRt77nrgOLdSyP8uF1KNnuCfyCQ0aDUybsdS2spqAVR1syB3Sm6iEUumF5uFB1HQw5RbDPbID4+OYhkjAuOVfv+TomHQzHhKN8dwvDTe+MPpiFcMCCTE3DvIAA4LGUnsSsHWLFdW6NpU9SrT68I518SFgjVB/npO2OytLi5OikFJqfIKwW7xRQ3EcaTEEBrXSVWamOfBseSQO5mkhcGysU7VeO2DZDE4OIdlkXGbeu1s5qGY7bOWJWL/67H9MQ4NxEpxxQEVDtNawPrEpiBB3cmgxqc6soOqm14x6tKnywpk/gIE/t4Lj9m5ObkmUoCXVoMz36qjL6U0UyVtSD9SITx5VmwKsVGhtpIgl8QbBPQouZKnY8UAPRkwPqLKS0HXsWkpMtORqMhf9vNz3EMwNy2z4Id65RCE4rG+NAWx/HLGvljNMqV2yfF1porpq/BKjDzMRmvIfVcjowP5Cg0FtMPib9TEYvSSs/yDQY8fWmFfOuSwae4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-08 at 19:15 +1000, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 5/2/26 01:39, Souvik Banerjee wrote:
> > Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > added zero/empty-entry early returns to dax_associate_entry() and
> > dax_disassociate_entry(), but placed them *after* the
> > `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> > expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio()
> > performs READ_ONCE(page->compound_head) -- a real dereference of the
> > struct page pointer derived from a bogus PFN extracted from the
> > empty/zero XA value.
> > 
> > On systems where vmemmap covers all of RAM that dereference reads
> > garbage and is harmless: the early return then discards the result.
> > On virtio-pmem with altmap (vmemmap stored inside the device), only
> > the real device PFN range is mapped, so the dereference triggers a
> > kernel paging fault from the truncate / invalidate path and from the
> > PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> > freed:
> > 
> >   Unable to handle kernel paging request at
> >   virtual address ffff_fdff_bf00_0008 (vmemmap region)
> >   Call trace:
> >    dax_disassociate_entry.isra.0+0x20/0x50
> >    dax_iomap_pte_fault
> >    dax_iomap_fault
> >    erofs_dax_fault
> > 
> > Close the residual gap by moving the dax_to_folio() call after the
> > zero/empty guard in dax_disassociate_entry().  Apply the same
> > treatment to dax_busy_page(), which has the identical pattern but
> > was not touched by the prior fix.
> > 
> > Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> > Cc: stable@vger.kernel.org # v6.15+
> > Cc: Alistair Popple <apopple@nvidia.com>

Thanks for fixing this.

> > Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> > ---
> >  fs/dax.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 6d175cd47a99..6878473265bb 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
> >  static void dax_disassociate_entry(void *entry, struct address_space *mapping,
> >  				bool trunc)
> >  {
> > -	struct folio *folio = dax_to_folio(entry);
> > +	struct folio *folio;
> >  
> >  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> >  		return;
> >  
> > +	folio = dax_to_folio(entry);
> >  	dax_folio_put(folio);
> >  }
> >  
> >  static struct page *dax_busy_page(void *entry)
> >  {
> > -	struct folio *folio = dax_to_folio(entry);
> > +	struct folio *folio;
> >  
> >  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> >  		return NULL;
> >  
> > +	folio = dax_to_folio(entry);
> >  	if (folio_ref_count(folio) - folio_mapcount(folio))
> >  		return &folio->page;
> >  	else
> 
> Makes perfect sense to me.
> 
> 
> What about the usage in dax_associate_entry()?

Pretty sure the issue exists there as well given this code path implies we could
pass zero/empty entries there as well:

	if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
		void *old;

		dax_disassociate_entry(entry, mapping, false);
		dax_associate_entry(new_entry, mapping, vmf->vma,
					vmf->address, shared);

 - Alistair

> -- 
> Cheers,
> 
> David

