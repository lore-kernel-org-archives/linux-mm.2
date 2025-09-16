Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B19CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C478E0020; Tue, 16 Sep 2025 08:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4736A8E0001; Tue, 16 Sep 2025 08:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B388E0020; Tue, 16 Sep 2025 08:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA5A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:26:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D172A140120
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:26:38 +0000 (UTC)
X-FDA: 83895036876.06.3AD8E89
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012040.outbound.protection.outlook.com [52.101.48.40])
	by imf20.hostedemail.com (Postfix) with ESMTP id 12C931C000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:26:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=InWxR95q;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIpsKIdmS4Vl/4tWlSRRMkEyG87nLGt8+VUyUuUw3p0=;
	b=ErnyNpNcjg979jD7hS2Tg0jUEZsGp5iCnJnRKdPDn/+uW0kGXYJOjE3Omjbp+AUpu54MpH
	re51TwKtcFExmjYjSrTFSA4Q1UuPfpblBQ/wVhDTch5eoW7esyZ9TcDXQTNGUdwZYIs+IJ
	l8GmYCSu6n8qLcjaSNyqUQOdgh5ftq4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025596; a=rsa-sha256;
	cv=pass;
	b=4P+/wce7FU6ISdj0a54w/yjr3OT7m1NazX8HgGqi2Mu5dTQSZwrZMObuX+qWCLoevpRIcm
	yCWlakieMlUFOfSPyEhrIGHXuiGI9PC/AaBMqxjvqXVCpV+/Epcn1cHXYSTpWbso/orvAU
	QOCbzU4REH9eD63toOol55pvJ9fEBF0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=InWxR95q;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBOQSU31IUWwDWFUjLKi/bDiT8pVtOgkDakdftHj2TpcmShghz4bgfbHGqBOmUjfNSBXiMY78T6Mn8DC8W8QyIQBKKMO29wZczJqbfdJ7lB1genUZPzErCREGItdJfRlgdhrTyXJZIMhsQij5hJ4tel83xrliIbcl+5+Dsv8lR72KtxTJ/wTXR5pRCD+IwI/fJjIXpoCTc17qfAvcYyNxQmyl18p+WdYSVu+TzIWD5LAdqQmN810jCMYyaAlhtfCtRtSZ+k6BPvvuzlQ78I55VMr2wvgNqGEW1QsByhA4Y7FYJ95cGAkKGw+le93+x96kF1k+bqYpTMdjL5K5Dlbxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIpsKIdmS4Vl/4tWlSRRMkEyG87nLGt8+VUyUuUw3p0=;
 b=yboN5iaDjyJ9CWZLN3zV8p3ua7uCHjpgyC1G6DZOqHuwdGY10Bwc9wOnHn0n/8NZUqyf7UFviKdQX60CB6wwgqxIo+UVicu4kMm1XNPppIY+UpxSgxlytAMeBzRXi5LjJ1OPAXQEtV73MG2rJ/k0ErpkQ5KSe9gtm9KFO0gEkq2Csry8oXhhTfegxtOxfYC1wBdWlVUNsAUypfl2K55/BLTaNwAwjgOk4T/XIT6kM5dpsvCSiejL52cQTG3EQrRnszCAmT68UNVTYYBmlOJqs7UbPDRo14yDyfBPB96zKj46NnKaSeqdjCYIsuLGWiLotVxkF33AybL30mXdYpcbbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIpsKIdmS4Vl/4tWlSRRMkEyG87nLGt8+VUyUuUw3p0=;
 b=InWxR95qqWke5LZt15ojqNXQFbG/BhuCSIYN9GkHmIhb24saFJcvYTxokEZHsfoFcEB0BFMWdR/Qx9omWKb4kDXyFx00KSnqw2ANB2zQqw0Wj6pgX7TBP4vVz4wKeemgr5m5bhnBtDfnBRZwDJEse3HLiyZ8T4GBMpQ3QdPN/q+1fFqTlUVL8WTzNDXD2lHm80j0XGihJDOKSTd8bfy12m+vxAHgMFH+f1NMuRNJH8opZNKEwWd4zUI0UGArtD5R6fa2ZrpgRc/ybwnDoXJJ+6DNVojKe5b9vhs12zBd8FcQ1dk7aP8uGWd2V+qDYDItqXamy3yPonzl3kco3OMt0g==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 12:22:08 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:22:08 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v6 09/15] mm/memremap: add driver callback support for folio splitting
Date: Tue, 16 Sep 2025 22:21:22 +1000
Message-ID: <20250916122128.2098535-10-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0071.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::48) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 70a16354-4f8e-4266-b67b-08ddf51ba759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0w1eFJxaEI3WVNOMlhEWUhITGRQYm9EdHRzK0JNNVRsSUZGZEZ6cm04aGwx?=
 =?utf-8?B?ZDE4ZVFDdTFVRVhQRnpPRlZ4Rno5emZuVU1IQy9kMk9kZWI4RjlwRWNMZG13?=
 =?utf-8?B?bnpqMjlPbDl6ZFNDNkcrdkdCc2t2ZmRyUG9XdnBhb0tOWW5zN1ZuZElTOXZ5?=
 =?utf-8?B?dkVGQi9Vc2w2SWpFY2ZJVnRrYVZyT2RFNlZZZTNLelVFcXhHaWR4c09xRndP?=
 =?utf-8?B?SjYvUFNCTVF0emVEaXU4OElHRmxIOHhsTGpRUVhHRnRON045SlRrdlJZbWk2?=
 =?utf-8?B?ZmtHc1JCWGZHVUxmNmZkMlhRQU5WZldTamNMYktRNnY4NzAzSXNHSWpUeGgr?=
 =?utf-8?B?d2dud2JiODFtRmJFTVZ6dHl1YS9obUVPSXZIclAyWkRGY29zeGg0aHdTUHdT?=
 =?utf-8?B?bnNzSGU1dVVONWRkdGtLTVFYN3o2aU9XZFNwWkkzUXFqc2ZpS0JwbGU0by9p?=
 =?utf-8?B?N1pDT3BJMnlVSmREdHBwT0xBNm0zVVN0QWdKQUttci9kNWRtK0pyc20zcTRX?=
 =?utf-8?B?VnYyR0hjUlJJZlRBQVpmd3pNQStjODE3c0VDVFhCSlY2VmE2dlVhQ0JTTjQw?=
 =?utf-8?B?ZExrNHc3UU9WQlZxdDVUSWdleGFrVHNOZGZpVmZzYmpRSnIvN002WTBySHh4?=
 =?utf-8?B?U0lucTU5RVFsMFE5NHd5aWcvZEZQdUwrTFFkcytnc0YrSzhTalFGVkdjcFFr?=
 =?utf-8?B?dGYzMWdBb3ZYMDFJV1pSaHhQYnQ5ZC8rVE1mSk5OOTR2MjVRVUtFamJUbXBD?=
 =?utf-8?B?ZDlBV0JxZWg5aTVEWkRvWWlqRytONlV0WDQwZ3BTVENURHpGcS9sODkzdUpX?=
 =?utf-8?B?dGFBbjdzUFpJR0MwZm5meWV3N003dDcwcmE2NTRvTE5ZKzlLdWRLZG42dk96?=
 =?utf-8?B?M1k3V3hTbWRJNlhJaW1yK3JwdzE0VTdWUnJXVXFCZ05TY3pxaDdMbUxLMWVy?=
 =?utf-8?B?ZmZmVDA5S2ZlMlcyVXUrbGpSS3FpVDVZZXF5VENDcUlYMjN6Nlk5c3RyZEZ2?=
 =?utf-8?B?cEZDYWdWV2dSTWV1STkxM1dzeDdXOEI4RXNwK2RnNitETGZIOFh1SlVqOFRK?=
 =?utf-8?B?UHEyaW8xWVhYZitHZFpzbUIvVDdEMmdFVm8yQW1DTnZOdGxQbUEyaWJlR2dF?=
 =?utf-8?B?UVcwM0N2L2IvMXpxRUM1bGU5czVtSDE1MjhvcXdMaTQ5WXNUL3dSaDhqcnBo?=
 =?utf-8?B?L1dMREMzSXUxNVlqYjUrQ3VHWWZMc00rYXlTWDFUaVdNTGtyeGtwb3JSTDgw?=
 =?utf-8?B?dTNKZ3QvVDRWNGU5citvb2VQTmliMkc3Q09yUGYwZk9JMEs2dEF1SHJOdU82?=
 =?utf-8?B?QVcrWVJEMjBGU0pnOU9MOUtxNzJDYlp2bWlRMitmTHVqOHZHcWxvNGhBREpM?=
 =?utf-8?B?ZzBFLy9BVThTOG52ZUF3V0NNTmE2SVlwK24vZHpKUTloMFNFb3FDc1ZlcjBx?=
 =?utf-8?B?dC9qTEdTL2JBcFA1aEJKdE5IWjV2djU5MjB2T0U2QzUzOHlTWWs1eHdBcHNj?=
 =?utf-8?B?b1hyVzRaVE15SEV0eWhKOEFHTzdPQVBVVy9RaHRQUXpHZWRSem9DYThxVmx4?=
 =?utf-8?B?Q3Y4azJBdjBvTUZkTExma2hxTEtrdUsvNUJzMzNSMWQwcVM3bTR0NnNaaHRh?=
 =?utf-8?B?Y2RiTWt2QWtNMUV1OWMyWXdDUStadDU3UDYvMUlkU3lSa29meWhjL2RMMkhG?=
 =?utf-8?B?TjNCOFJCTnliNmpjTkVZcTdSSmVHeDVvZFFqZlp5TzJxcmZiNlVxelMrM1Aw?=
 =?utf-8?B?U0NQWmE1YlJ2WGFkVkt6TGM0eThqa0YrWURaSUp1bXE5L2ZWM2JZaTJlMktZ?=
 =?utf-8?B?UVovbmVkenYxS1ZVRTdmbmQwcGJWR294V2lyRWhRMmF6dittR0Zqc2NqVjhJ?=
 =?utf-8?B?SklWMUVmeDd5emRVYWJLWU9qVnBQY0hVeFVDVjZ5VTk0bVRmM2xEbk1zZkI2?=
 =?utf-8?Q?QILcI1laqjc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2hVZnRBODNOZEZSRWlRbU4zd3kyd0UwWVhueVRralZSNXdoT2xUdnNmWE1x?=
 =?utf-8?B?di93YU5taEFDSGhHV2hEdDJRRjdJL1dnNE0xNTd1UE9XYk1JU0xwc3VROTVj?=
 =?utf-8?B?Z1dkeE1SNjRXUVAvSGV1OWd1UzNPcjdrekNpU24yZmNLZmJwVEtpNGZncUZL?=
 =?utf-8?B?U281bXdaOWYxTldUdWdYL0doci8rZEZHdzY4OU5iU1JtRytLR1ZibXExY25V?=
 =?utf-8?B?cG9QWWs0R2FuR2Y4cWJHNjlWeTZCYkhQV29VV0V3WStad2RqUFdIL2N2Q2ha?=
 =?utf-8?B?aU04ditPQUVnRFlYYTBZQ2kxdTFSN2NWMzBXMGVmUUVqR0dHTG1IUy90UW9l?=
 =?utf-8?B?SVBlSHlkSW8rOUhFS1NBSUNCYUVoZjhKVm12eFIrekdDUlhENDdNOVFURW5J?=
 =?utf-8?B?WnoxNExYbWZ0NEd5VWxZQ0U4YzY3NlJDTi9GZnFiVXp5cjY4bWVQdjlmSTlK?=
 =?utf-8?B?Vk11SkZ6eDI5UWFQQmJOYXB1TjY2M1VnUEFrM0hyVDVSVWVIOVRoVkxyTHI3?=
 =?utf-8?B?MEpIZVJQQ1FsT2VZdmdLMzQwcFMxRjJmbWpmdkdBRFdXYWoxbEk4TDQzUnh0?=
 =?utf-8?B?aUR2MHBCa3ZyY1owaUlTTTNHWk56aXNKTkFLeStPUXdtYy9hL21NSk00Uk93?=
 =?utf-8?B?SU5KSjVzcDA3cjlSRUFvU1RrNUpWajZuSnNlQnVUVmFZT0hOMUJPKzdrdFlk?=
 =?utf-8?B?K0s2bEFqbktuSXVpc2lwNFhJNzBTTVJjdXB6cWQ0QUtGSnp3ZkJnYXl5ME1Z?=
 =?utf-8?B?WUgxYTVMTGFvVVp4elYwNVN4TnVMWE92VDhzckdqSVYvR0RZOUdsWFVUOVJi?=
 =?utf-8?B?QXBpb1RSMmJiUVZaRkk3bXFYR0xFc3dadmlGN0hOZEwwMnd2MlQzU3ZiYXVK?=
 =?utf-8?B?ZGpBeVp5TFE5c1VieE8rMzloV1czcGZUOHR3Q1BQakRuTnFkMWg5ZlR3M1Zh?=
 =?utf-8?B?dVdwUmtTOXp6d1k0cDhWN3pkWFFYQjM3TWpzelpyaDdtaEZvSm9YZjZHZi9o?=
 =?utf-8?B?Rk9QcURKY0Uzeko3c2NPcldhb3BHcSsweTVsYThOR3ZFWWN2UzAveHpOSmJR?=
 =?utf-8?B?OG84RFlrWmU0dXJTNjkxUUdKTmE1ZVpmcklEcjZtcXBEKy8vTEFSbWtia1dC?=
 =?utf-8?B?SHl6TmYrVzdFWmtCMnpHYi9jeGhMaWhrTzNZNThTR1RlSGZmS1VTbEUwMEpE?=
 =?utf-8?B?eldMKzU5V0JaZ2NxSU15UUxldjdmODVtVzNxRzJNNG5BLy9NaVI0LzRRbXQ5?=
 =?utf-8?B?S3RtTzZPWDl1ZENmMXd2WHo4YzY5OFdMZUY1cE1mRzd6VUV0bE1VV0FlZXN2?=
 =?utf-8?B?TGNudmRFaUhYbVJObWdWR3lxNldabVcvWlRjdjQyVVJzNEEzWms2d2JpVTJa?=
 =?utf-8?B?ZTFxdFcrWG5RS1doeXpzeEFDZWkvZWpTbi9VQXFOS0ROUlgvbzBxaHk0TFAw?=
 =?utf-8?B?NGRURENUOStScUg2aVQ1bzJzYklSeEVFSGVPMEdib2FuSy82SDVUbkppQUJr?=
 =?utf-8?B?WVF4S2tyQ1g0cWxRR1k2WmdmenRLUWZ4SEd1ajJ4eHBvckplS2pMT2wzNTNC?=
 =?utf-8?B?MTJyd0xGSmc1bTBoMW5adWVJQVl0VFRTYWJxVG5zWnJacWlFUTRJQ1lXc2ts?=
 =?utf-8?B?bGZOa0N0WGxzUnlVay9wdFZRYjNSTHJKNjFZZitrTlR5a0QreWNFSzlQL3ZU?=
 =?utf-8?B?aHlPdzB6cEcvaUMxdFd3T0hFMVNVYktOWlhXTkJZWFNGWk5IWUZoeHk3Vmg4?=
 =?utf-8?B?VEpKYzY4TVJjYy8vUUhXbzZOU24xYlF4bkFsWE1NZFMzNHpGczZhb2pOcjRo?=
 =?utf-8?B?R2E0VnVrcXhEc2crc1ZnTEV1SXlSRzNtaXZJdUJGdWJGZytZM3lySGNGRm5z?=
 =?utf-8?B?TytSdEVoNm5YQzYvM1lOMUNiNGNwQ01IcnUrMEtYL0VYSDk2YnZVL05LbFBL?=
 =?utf-8?B?ZGYrK2g3N292MTRnWnJHK2RPcUxyMDZxaXMya01CZXZ4TjU2eVNmQ1VWaFNP?=
 =?utf-8?B?Mk9VZXp2TlphbEhaNE04U3N4VTFCU1FIRGJoUXpsWk5ZcnBZT04rd0Y2OXc1?=
 =?utf-8?B?b2xlL3pDd3dud0xXT1BDTlNBZ01ZYzJVaEhtOW14eDhuaFlMa1FrN2RvWkdO?=
 =?utf-8?B?NWJDQnFxVUR3c3dJalNiY0Rxc21wQ3hJZytKcEFZMTk5Z3YyQWhzbWFkYVhV?=
 =?utf-8?B?bVE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a16354-4f8e-4266-b67b-08ddf51ba759
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:22:08.0103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQd3lEVX2kBmks2v3R4jJv+vZhh6go3pEBM8zzOW+gEdmeYAWzjm1jW18DVotr/c9bU592XEhagKk5HdsCkPNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Queue-Id: 12C931C000C
X-Stat-Signature: nixzxxccjnmhb9sqpdosmj19i5hw19yq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758025595-659812
X-HE-Meta: U2FsdGVkX18TyTtPw6uFe6n0YLWR/mZA32Kkvp4rXTL5HT949KCuADti94C+/4bykQm9o+BcIiC9gbV0yocc3nHd8dXORX6RL2+Zo7vupf8k93KgvTgucyHjHL/DUMGuhOxQMTiPSqPydq83Ipve7mN1rWoS39y8VM5TbNSpFpd34DRBaR36wfVmCvelzKuqJ6ovif/C7//+Hav1ZB5AulHsZZnv8M37eyPt0OjvQBkkLG4FWmqkJTmwZHlN2G6XU29TjQaCAUnPoF0pehPpJR9+p4pGafBWNsD6HFtKt45zB85LfHIUgNczW/GlGYtzaBdv0pnDd2WemBEamTkUYYCs7n+EWeBsy9hNQ0xP5EUjBj9ZF7rSasIg4sNseSp8/qwewcPSJf8aszpMuI3oz5RALbaUHyXI0b+VtRXhAPFafPQm5AVE4dgTOzFb8N6qTkp8LuAlK9Ieh7vcOT6cWLWQrdTyzSEw0EQRQXn7sy0/uoKM6liMjQvatq2vOqAvkZoXXeFnNlwJsuwQyzIyLCdsVTraamj7kEh4yL95VtdZJ7eb4O+1DgRawoQjKcL52Xvrzm1waXEy6i7Qirl98/Jl/iwGyISnmMr2u5e07lp+2fXJopUSld4SH+TUgv+NxBtj+yCFCBje357niu13obde79kJlQEqAplSyQPGrSLR8aDM0NeLav5LUTPNIX958flN2g5FLdyjerZTGfH3XyrQROI65zaVPc3ibpHKbwwYlH+d+dp0JNIvasJqJ60Jt0qsO5FzD2ZWuj/aM7pv32Oxt3zgCuc59F2YC8u5Xj1lwIzkDR3zLBtnbcTCQwUusKPGrxZCOQ1umBx0vyFtMASYNOX8q0/hVLDcy936WLsysh9xjMxLE16Eq7UWAzU5WwS3ercHato7f+DW+ryCe23sObWDQVugjki94UkaM27IOzTGZZI2ImWlSDkA6I/mSUEYBZnCZnLZtHBd2aa
 FQItiX5V
 phudSHGFw5O29+jqMKxEJjUbaFBWDID1EHSzxcDTeI91dNyhWf0u29fxYyeQJwXVlAs+44F0emrbq7/ePWCkKmo/WKpevRa5GlqGdHr4iA1rL0JxYdNNDYdGP9rbSpk0xxZEJywtE7Uo88e4CTl2r7+q9Ys9j8v9RKFawMGu0XiE6M7j2/bWxJ58rLYqLVAFuKYTZV4tD01opMGcL0y0YGf80334N/4Uk9RR/wpZ7VDeipe2a3lCrrdWpjaeN+zHcLoRyFzkEdiGyaDyGu2EdvLaKwWf/2BXeBUQ2cLSsFNgKV+nunOgG3/9sd2OtWj0rITEj/uq0YpMo4bfj572+tgr8L1LBpJApV1WT9ryIhX693RMXB1kH5g+lZx+PxgUpvx+Y5lxlyFqJHbI7iq3taDXXo97UP4CgujGPHKbt7XZKWG0bR4Kx67UTsVD4DaCZ0Wj0rsy/BI2EhdvvIIZtxMHcTDO/w5n/4BUqnpktInld8wtHlK4PCeYrENIMoh7h0OPm+vYKrQCC2eb/iBKx/9ya8N6p3mpuGVFBs7vFLqQoe1xoSrF+uuXvbc5KKL+QVP6wiDQzoq+3TXq950Ps+KOhmzugC1+sFg9RbQ0AvirjGborpJnzauWuiMmA1eSp35AJXny9gk/tzWNYTsx0WPKs1wFsQOfNQKJxW5/7cy8xcKx07x5tsyt4HvGd+dRr2h0XOS/CR4gT1DL6n7bc9YGWWPsZcHK0G8OwBMvZUfc7rcINBm3SCcL9FJFLkndgknLrmTVc1FFnqSwDi10J0hP0oetO5jmI7IVwGUsbajtFUos0Z0T4M7Pp1a5EhWBi/rZ2lvex7jU03XxtR3x3GE0uKZ81Z9vFVsAd+Zwb4QS3/R1bK4coX6vkNl2MrB+Uf4U9CFyZtWxoCd9u3qg1qAFFLt3I25ayj9bNOePdDrFfD2cxKq/JwoUHt8VYVQAjuyhsL4mj5C9iSRbSvXJ/I9LSRK21
 5xfqQv7k
 Lww87PUWnSHMFptqae0qQiOpYtfjKHEl+psjpXsRtXTY1qzrl0TJGh35fvha+wVxbBg4Vj7h3aY8Y60QT85p9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a zone device page is split (via huge pmd folio split).  The driver
callback for folio_split is invoked to let the device driver know that the
folio size has been split into a smaller order.

Provide a default implementation for drivers that do not provide this
callback that copies the pgmap and mapping fields for the split folios.

Update the HMM test driver to handle the split.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
---
 include/linux/memremap.h | 29 +++++++++++++++++++++++++++++
 include/linux/mm.h       |  1 +
 lib/test_hmm.c           | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 75987a8cfc6b..ba95c31a7251 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -100,6 +100,13 @@ struct dev_pagemap_ops {
 	 */
 	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
 			      unsigned long nr_pages, int mf_flags);
+
+	/*
+	 * Used for private (un-addressable) device memory only.
+	 * This callback is used when a folio is split into
+	 * a smaller folio
+	 */
+	void (*folio_split)(struct folio *head, struct folio *tail);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
@@ -235,6 +242,23 @@ static inline void zone_device_page_init(struct page *page)
 	zone_device_folio_init(folio, 0);
 }
 
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+	if (folio_is_device_private(original_folio)) {
+		if (!original_folio->pgmap->ops->folio_split) {
+			if (new_folio) {
+				new_folio->pgmap = original_folio->pgmap;
+				new_folio->page.mapping =
+					original_folio->page.mapping;
+			}
+		} else {
+			original_folio->pgmap->ops->folio_split(original_folio,
+								 new_folio);
+		}
+	}
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
@@ -268,6 +292,11 @@ static inline unsigned long memremap_compat_align(void)
 {
 	return PAGE_SIZE;
 }
+
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+}
 #endif /* CONFIG_ZONE_DEVICE */
 
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d004fb7d805d..be3e6fb4d0db 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1265,6 +1265,7 @@ static inline struct folio *virt_to_folio(const void *x)
 void __folio_put(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
+void prep_compound_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 50e175edc58a..41092c065c2d 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1653,9 +1653,44 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	return ret;
 }
 
+static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
+{
+	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
+	struct page *rpage_tail;
+	struct folio *rfolio;
+	unsigned long offset = 0;
+
+	if (!rpage) {
+		tail->page.zone_device_data = NULL;
+		return;
+	}
+
+	rfolio = page_folio(rpage);
+
+	if (tail == NULL) {
+		folio_reset_order(rfolio);
+		rfolio->mapping = NULL;
+		folio_set_count(rfolio, 1);
+		return;
+	}
+
+	offset = folio_pfn(tail) - folio_pfn(head);
+
+	rpage_tail = folio_page(rfolio, offset);
+	tail->page.zone_device_data = rpage_tail;
+	rpage_tail->zone_device_data = rpage->zone_device_data;
+	clear_compound_head(rpage_tail);
+	rpage_tail->mapping = NULL;
+
+	folio_page(tail, 0)->mapping = folio_page(head, 0)->mapping;
+	tail->pgmap = head->pgmap;
+	folio_set_count(page_folio(rpage_tail), 1);
+}
+
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
 	.page_free	= dmirror_devmem_free,
 	.migrate_to_ram	= dmirror_devmem_fault,
+	.folio_split	= dmirror_devmem_folio_split,
 };
 
 static int dmirror_device_init(struct dmirror_device *mdevice, int id)
-- 
2.50.1


