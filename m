Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7CAC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17FA66B009E; Wed, 30 Jul 2025 05:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBCA6B009F; Wed, 30 Jul 2025 05:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70C86B00A0; Wed, 30 Jul 2025 05:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBBD76B009E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:22:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C17BB8F73
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:22:39 +0000 (UTC)
X-FDA: 83720390838.27.7B3F5E1
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	by imf28.hostedemail.com (Postfix) with ESMTP id ADB81C000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:22:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=apyemS9V;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IuxL8ZY5XuQaUWKy8sdw3n4uLB+HryPz5FqC3t2vCk=;
	b=KEVDkb41R3KpRuFjB7mlYT0iOaOKW80RyjHWWLZlmuXOR9ox3T0PRmOHug2ZqR/Uc6mKYq
	4720HgsA0RvpnRSH56mTXAE2uU7dNIggFEkvHbFN18y+BKzbi3YLNZlmXODaaxjAZN+SrG
	jjBXTx8sPyXHVn6K+ZIYdEDgM/WTK2M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753867356; a=rsa-sha256;
	cv=pass;
	b=j931csTI5Bu+ZpHwmJeCgo5iH3d1F7M1lXgLA/m+EY02kEm6FoZzRBU8geD+6T6ENHgqkj
	Xgev3hhBWgOUieWTR8SBvdFc/JPgGvDAUaNbbwY+lk4VWudAaLITWDPnqDzATsx/c5B9dJ
	8fJ9oR8Kjh5S8v19163BZ7bCbsCWPPI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=apyemS9V;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FLJ8olLunDZqU0PEdUFhqbcRHAMikbu20D60GZ1g8KpF66uyBA9D8BCqjPhskl5akb15ofEBsODUPKtLUl1OJbiqkLXHYaNMNgxEqCjLgneNOf7+rca6bDQpYErcXSmSVQj3g249CWp4J24e+vJv48YV0jsvLeMdh0ZWVzsblVCDJ+KBsjM0zMOXfKeT0FtXud5GdkXvDVTovLz49VTPPbnOfXFtXJjPLf6CpptfaBsVj+8kDZfUNvo9aDDa91FZkFszxsbaEE9M6bOsBvaKyBxCaw7ZNlLTzRKfQ4sOlord4JluGMGC2qqQ6D+BfeqvNsiAP0h3FakIuKrKdy9xcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8IuxL8ZY5XuQaUWKy8sdw3n4uLB+HryPz5FqC3t2vCk=;
 b=HuKJJ8f3ELAxpZu0PjnfE3Q3fnGyqTFbRa+89htnEJIOWsVNl4MQteDTrHF9d6iFYEE8MMtDBsfj2d6Zye28nb92Xg3IaICTP9f0uAjDpAi/oLXP1/BlqbFIW0Ygl1YfBXqOihNo/u0WfOrEDfs+LwwjX8gZpyfmPYViKI+N//e/1x0l40zhEj58O1rmDfYLuH4KwZztGuf9QIH8zVKIF+BMK4JQy5vjBw7mp06VWJQTknkogZz0z5AhxuTSH6AU4knIHtAsGlavaCwoXFm4rLlcNOIELogqFbvEwHQFWnWTUQ833ASeuHxAbKzIJ26+F/k0dMD2hlzZ8PSA20bqFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8IuxL8ZY5XuQaUWKy8sdw3n4uLB+HryPz5FqC3t2vCk=;
 b=apyemS9VQ7uJ/tKSHmcAPOECdKxuJaKIgHBr55gkV+y4nYJHz8WY7UuosfXzVBB5j6iPvWbBQv9F+JDjjYT3g7ou2EWnKyDu+Bgv4b1KEZwU98a7KRWARabu0ttSGe90wB+4GLQ0aurDOl7iS9SNA87u35BxCvYXjshljUrlS6E7KqXpDB5DSDMLQBddZN9eKoIebPE1UM7tcPBbPPdLCw3hyG492hoJzwigwWB1In8UiLS0EKhSOuJgSc9u+w88XWGLxF2b5xQx4YRA2mYjPuy+662cT/9H5W2q8kKgkxqRi7rRmA4jRm6kB01nlmQ+vEs+0OnODP/N0w33JZk9wg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 09:22:07 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 09:22:07 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v2 05/11] lib/test_hmm: test cases and support for zone device private THP
Date: Wed, 30 Jul 2025 19:21:33 +1000
Message-ID: <20250730092139.3890844-6-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730092139.3890844-1-balbirs@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:332::9) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: cb68317d-0a8d-449e-5282-08ddcf4a8d90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eElMcDloclBzeTRjUGNXV1dyaW5Pb1JZS21FTEVoVUloZnNIYlZCTXFRQkQx?=
 =?utf-8?B?bkZKTFY5ZGVEYjJwY1ViU2JQMFNxQWZZbVp6ZCtFc2YxZnRJUlZCMDFYYXRy?=
 =?utf-8?B?UU1QdWRiUWJMOWZqSSs1a0VmTVE5R0NJOGNtRHBRSXp3OHhTcENRWEd0RW1E?=
 =?utf-8?B?QXpKTCt4Z29uT1NPdjRjT0tLVjB1YTVYN2JWVUhXOWd3a2hPSEVTeFZEcHJq?=
 =?utf-8?B?Z0xRNnIwdTZqUExpWnNHL0NPSWhNTHc2MWY3MHY1ZE85NldEYTlqbWlacDBp?=
 =?utf-8?B?cnZJcXdpdHRaS1JSRnZoY0lyRCtuSG1EYVo3VFlHbUF5UlNEVy9wUCtkYm1G?=
 =?utf-8?B?cWd3UHFIUFZ2OWliemZjT3JGdzFDbU5UMmVZanQ3MkNhZER4Vm1sSXN2ZzZK?=
 =?utf-8?B?TGtiWGU1aUFzNTgrSndqYmxnbDVaMXJJcEFucTgyV2xrSUpxYVpwcUMweWN6?=
 =?utf-8?B?aDBJZVN6cFhJQ2RLUTNsM3FiZlRTMFN4UEVtWkdqaGQrdFRCa0M5MHlvNDUv?=
 =?utf-8?B?d0poelB5VlZlNVNldkIvandwRWxqV1BTcTFIbFQrSkhwMmYxYTNSY1hEOUdO?=
 =?utf-8?B?eGN0QTJybC9OVk9QdkhaZk9oQ1RRU0R4UEQ1RTh6SHFKeWZLSmxaYzQ1UjZZ?=
 =?utf-8?B?OVdvQVZWOHVlbXllRUlTcVkwcXppUFlONVJCM0Yxcis2RytKazNMSUNUMHdo?=
 =?utf-8?B?WlpCRGlCN2oyS1F4dVNYbkFxZkY0TW9iMUFiL0FmODd1bXNJV1czd3U1TU5E?=
 =?utf-8?B?dklHZDNNNSs1Q3ZqNDlKTmpDTnF1THpiSGlrZmVMNGRmbUg1V2l0ZFJNWGhC?=
 =?utf-8?B?VWFHV3Y1bHJOWmpGZjhEN0syOGg5cUZPS01aMDRFV1lWNlNsMnl5UlFoNng2?=
 =?utf-8?B?c2txcU93TUdYS2ZSZFIrcC9TaFV3ZGg2dkpyUlBETHJjbzRDcnpNU0J3S2Zv?=
 =?utf-8?B?Mk5yRTBNTGEzV2UxTWNQNUp1R3M1TTdJSDVQMmVkWURrK1dxMHpOZXkwR0VM?=
 =?utf-8?B?bGVtWlVIQ3AwL09FVXllMHhBNGdiQmUwTTA2OUVhMzZSVlVrVWUwY0tCRmxW?=
 =?utf-8?B?TnlKSnVpZXpQQlFibU9Ld3NmSXNEWENhMDQwbkJreUhMSlIxWUcrb1IrZnpr?=
 =?utf-8?B?SGxGN2Z1S1lNMS9qV3U3dVpDYTZLS1pJV3Jsdy9WK0Rxdk95Y1M4VVNubXRz?=
 =?utf-8?B?MW50NjlicExxVis5WFZDaHdqb005NVNwdW5rcXF5TVl0MjRER0ZvRlNxWjJj?=
 =?utf-8?B?WWpYTzFtL3FUTWRkR1FobjVITnU0UzdGZ0JrZ3VHd0svbWVWM1NaeXpjbHUv?=
 =?utf-8?B?ckpYYVhnVlRQNkc0eVM5TENNcldXaytjVEJpbUxrY3JJZC9US2ZJcEJCaWZy?=
 =?utf-8?B?eG8xc2NIUXY2VitxUkY4eURKc1RldUttNm9CaG85RkoyVVBmTmNLQWl6NEdn?=
 =?utf-8?B?Mms5RFlvbHRlWHNmNlNOZ1FkQ0tEU2lhcXFxNTNtQkJZWG5zblo3R3ViazFh?=
 =?utf-8?B?VW1CdnJpT280ZWZNMjdWMWRFczZTN3ZFeHpMOHhQT3dydzFqWlpUZ1djeEdH?=
 =?utf-8?B?R0hNdnFjZmhxRVZ6LzNDaXRwazUyc0lVaEFkOG5mUFNzajd1SDJCLys3T1Vm?=
 =?utf-8?B?QUlnVjg5TWF2Ti9HVERKL05zK3FNZHNqL3B5SDltV2ZxbTF0aWxaS2FseFh3?=
 =?utf-8?B?Z2VsMlhsbmpVSXM1UWZoeXBHaGJGSngwQ0ZTbEh0RU4rUlZPdWw3RVpVVFBD?=
 =?utf-8?B?NnR1cEErRXVDOE1qK1JkTHVETXhNRTROaEhxazdVVFluRFlFcS9ZaWJzbE9O?=
 =?utf-8?B?R0NiSzhGV29Lek43WWh5WWk1VW1ZaXgvYmdSMHlqWXNxY2RsTElVOGphVjRk?=
 =?utf-8?B?UDNONlJXbnlITHNydDJoQ1BWRGwrODhRa0lielltVCtVaHZEYWNmQUtEQ2NY?=
 =?utf-8?Q?fi1UfTf0cZ8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3Jnb0NHamhGRDBOZkNobW51aW1ML3pKUk96cWNPL3RrSTY2T21JcUNBelpo?=
 =?utf-8?B?TEFOdU9lakhpOEoyeUNuWlJhdTFlT21RWmd2RWYyd1BuQ3Z6MDE5bFJ0MWpB?=
 =?utf-8?B?eDhyUkVDbGlsNTg1NTlBOXV4d3dlMVdJMldiNUhkR1F5OXRIeEJoSTU5OGpZ?=
 =?utf-8?B?NjlFRTcwdXp1V0MvWU02MEp4cWdqNG54Z3g5REZrQnI2TFgwdTgydVJ6VVYw?=
 =?utf-8?B?dmxkN09MZ280cE9ONG5LL2h4djVxN0dqWDlFUm80NXFuWWo1OCtsaUlwRUI2?=
 =?utf-8?B?ZU9VUDFOdzJDMnJab3prTUxYMnVSZ2dnQ25XQUJ4cjBtOW44V3kzN2t2WnZL?=
 =?utf-8?B?ZWw4SU9WOWdzMFBPcGtGTllDS3ExUEFQdDNvTU15eGRpMUt6NUZtRXV1VUpN?=
 =?utf-8?B?UWVaMnJ6WlNrZ1RvVzlDZGxFQkxwQkhGUFRac1FFTXFCcXN2amNGVnZ2M0ZT?=
 =?utf-8?B?cytYbDRyUW9OcEY3NEhvVEtIT3g3c1RFUjNVc2FtalE4bnVaMkZyZy9iUFl0?=
 =?utf-8?B?MWpKb3AxekpSQW1NMWZRaVpkd1dUN2I3NlpKdXByZHRTYmk1OTY4eWwrR2pU?=
 =?utf-8?B?cXNKMFdIdWl6cDVDMEt6dXdleUErN3FDaDA4RENyeEM0Q25FQjBrNVg2SE1C?=
 =?utf-8?B?WGVzeFJPYVByZ3RtckFVZ0x0ZU1lZjQyMTFYYXYzOSsvK3dpSytDMjdrM1lY?=
 =?utf-8?B?aXRsME1lRCt4UC85YXA2WVIzWlV2ZTRQRFZuOVNTbUJ2cmZYdktxTGwwU255?=
 =?utf-8?B?dW16b1JHa25lYlEwcytYNEYzTDFCS2RXQ3B4MVhQRENjRUFPNklvQURnNXJB?=
 =?utf-8?B?ZysrVk1Hbk53MWtxM2o3YnJ4dUdKSlBxWEs0bWJpc1lXS1E2MnNFblBackJI?=
 =?utf-8?B?N0ZyUmxWVzNxVlFNejNoMEpYelVuT2JsZVpMaVY5bTQxNm5uZUdBbkFYNE03?=
 =?utf-8?B?aitOcWsyMThwcjBxZi85d3I5M0xKcmpXRVF6bFVXUnZpa2ZvNHpsSmRFdlc1?=
 =?utf-8?B?Rno1aW1JdVFZSlpnZ1ZNaXEvWklJOTJncHpCcHZiNE5rNFo5bjRvVjJHUXZJ?=
 =?utf-8?B?OXZCanYzd2FmS1U5VGdlUTgyelBTYUdua3Y2dU4zMXpRQk1ZU3BoMzFYSEoz?=
 =?utf-8?B?dEE3ZnQvaTJNaDlQNWxWY0FCaW1iVFE3TDd1YkVlK3NLeEthbFQvT0FHMEhG?=
 =?utf-8?B?dkRrUFRmOEl1TFowaXExT2tWY3NIZklPZmJyZDlWMnZwZDZWL0ROQ2lMNFdU?=
 =?utf-8?B?RVJWS1J0QjNBOHNGVU5aWktxTzFyWmhaQ1lwZFdTRitodXpuUVM2dS9Pc1Vp?=
 =?utf-8?B?d014dU5DeDh4dzcwc2l3UlRucmZ6clgrMG5nL3JhSUhMeURvVXhwdDNTZGpv?=
 =?utf-8?B?NHJyc1IzbnJDcmpIT2hBNGJJNmhRdmpQSW5aVDFtdlVVV1VvMFVscFFkSENu?=
 =?utf-8?B?aFNWUzlKamZ0NGtlSGszQlFFQXZmRzZucytOQnB4NjR5cnY2dE40dVY4b0NU?=
 =?utf-8?B?TWlTY3VBSE1hN1IzVGdEc2Y2QUJ5RTR0V2VhZnJ4UGlGbE15cTZYNElvZC85?=
 =?utf-8?B?QVc3MHd3Z1o0cEJMb0FtamE3U3F2RWV4YnZiUGJia09YcGozNVc0Rm1hNGNE?=
 =?utf-8?B?N2liVXcwSzVEcnBvcytZSE1XZU02b3BLZ3gyNk5wV0Z6VHZnNlZzVExVMUlZ?=
 =?utf-8?B?UThxY2l0T2thOG5Xb040czlLbnNwdHJ1dGFnYjZ2amJNTURIQm54NHl6UjVG?=
 =?utf-8?B?Y3dsS1htRVZZaElqSWt4WlNjMXZLbWZyRmJQTmJQQ0xQaVlZNWVPSkpJY3h5?=
 =?utf-8?B?eUl6ZDIvT2kyMTcvSnhLL3RDblVEU25DK0dzeWx3cEUreHZXdk9vM3hsVG1s?=
 =?utf-8?B?bzBuU3o4VU5PU09WVmduTitYNTM2OFB5OVVNdmJnNThlT3VNVTR5N2lpeUZz?=
 =?utf-8?B?SlVBSVlWU0ZRcHEvdzZVa3VoWGRERTBYRGw0MlVIcHRpMnZJbGtObVlVdTVM?=
 =?utf-8?B?WHhxYmg1alVqenFwMU9pZzFKWUR2U1YrYzVSMk03Q1RFYWhhendFaFdwVFZo?=
 =?utf-8?B?SFhmRjRtMVlJS0tpY1E3VExxWFZIWDUrSXQxTG43S3k1OFJlNFNFMlN5YWZs?=
 =?utf-8?Q?tzBUuH9IXLvvl4cGS2d25o++C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb68317d-0a8d-449e-5282-08ddcf4a8d90
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 09:22:06.9123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXb6q+bRR3+MbRVcYcBsTb3UPK1K4eQKYudsKfcnrduozVl3LBCWRMdorEyb4WhEiifDHSgdoZR1CTU7aAbGHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Rspamd-Queue-Id: ADB81C000A
X-Stat-Signature: quoif1sp4kqf3f3c4wzi1tm5r8isxiz3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753867356-244786
X-HE-Meta: U2FsdGVkX19QtFuw1+3UeySozLPst6E6OvJBHSra1+ZeN/XuRBpFT7ANGi90oqZTpuEtAGvFM/tbbiI+EmyYRP/LPVFFCcTL/FwRs4IF9TCRd+60rBHYShs82OzenzEdUZopRhL0h/7g4xoRxrajrUlXp+8p5tSNtLRbb8/2EoiAl8papUTIJNlNBBD9QY3FbeKyxDhiNXbZWfaUs3d8MO5sMvf3hooGhxkKH7oXoVis+p8sk9KDoj30bPIrUDSEOCjrUrv/VrIojde963M8U0z5bn9/V5aGfpISEhLi5INzusH8xSX/tgBfx4MS9e0tUMKNlKyH6T6YFgr8U6eYMc4plQ1fpneXHOmbxwtb5B/gEfd8SCY+sgSGo1sQSZXES2qcr6nooRH07QrKzSXaC2u8BfVaaKYbSf1M177d1To3UvWIpnjAACVkYYSneQpOdCo5sMzK1mYJWUzmNWhmpV+sQ6hUBXv+7rUr1I78upLCkK13ac9cv5jNHPrhgPiUR3HXoQrO/rhMJZNmCrgt6dNJ4Bth564QtvgVZeUd/w94ZB+dc5ofdfLa5KxfSnOsgPo1sO4N6Rs26Ya/wI15C3ftuU7X1XDbnf5jVBH66DMheVeQgLYFejinA7uC7C0bm1EXeZMMy3CoUC+/DKwL2Y86sEdutLrU/9r+Pk1wYI7VobWJttrNBTH4XoKsqqhk/VRDPnVizKDJphPkT3+kotHvqDryaBotDGa/4yYZeO+0/C8TfxeeLpF5FPkbUWQDAAXPUiG+mNt0XiZ7TaSlXVXAcPNRmcegxqb85m7ojhKB2tc+3YydB2/qs2ZJqLOp1OKfqlvgoTUO/1lAsAXPz7AIguD4av/+Yb0Y/gtQ/X0iMdZ8x43ZhROK7tZtQE7u0zcvXWBJUsaH6aUbtjVueU+5wiyLUU3qRpFu7SycOfTE68KK2fbPFVDyli7VgiSVt/gZTDh6NWYTDp7091E
 O5NDzutj
 9RlzwZL9fvlADRgVeGn6H9q3Pf/ERlLnTnuQPegwIk1tAU0N+pOeAtq0Wvr6YnEQ21Z8ym49YuphxvT+vcy2tx6ppm5bzYNFTqBeYFGSIym4VI3k8qgxdMKDMqjaU92fSxv39WIWal/PBjkVicct7nHl5bWGscF86KqHQH9XucwPrzEsp+uZmbZlmKHJbBHe9YfBUCH9Wrwn6i0K5VWelcITxWmV74CpTWuDDeB/n+dAPak3/iCxXr0oB8aHW5xzCDBVw+6j4IROI4lfNAX6ntwmyWShvQY5MDYp6aVaPBclxomaZ5yH0FTdE/RYGLoGCnNRl8OLpwBCtrHnGrqWjqZBaKhnPEAZBSr3V3fB1bVIOkrdCIvY9oDPeBDV3CDUi/ch3DbWNdAThlR3qvMAyjgxeNNciEFOamIVRa4HlQ8aqb9pWZWeSBf1e7f6pFsHSBMUnI0wK1rYL/k9HSvcYDPsePtwPdk9D43z+rBC60jJSNMwKcsCxGRGfrK/cTzUdKqPl7XpxAQsFb2FBtklcj0Kg+4Jp+0mRmBehk/+H1ohiSgOZQetI5FZkuuaVVEaXh3ygWEVz2afAlKbUbDX8iEapVNIEO9bAY3rz29je5qlSHS+Zl0+fAgKaAmaJh9DEq3UTcOVoArxUkhu3/oHb/KwS9GOn7d3NagO0R6/QzMqeJxXTvUxycuaGzneq9ReJ8ZYLjsTaytRK2GHG/vPf8pq3DPGYM19ugEvcnXS3vW6Qw1MbgteMRJrnGF3utzBogUCwzr/0Jv9uJGFEYSF3+VHZwwOFIr0bmtovC5/y3rh1pgWW3karuCEaSF0RwSxn8B5PrUXs7VbxycseZS4JTA7GvLKKyz86CIIAVz0nGIFY574L+aqE+fONU3UGxOXxI99h2X2mkAk3mt8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enhance the hmm test driver (lib/test_hmm) with support for
THP pages.

A new pool of free_folios() has now been added to the dmirror
device, which can be allocated when a request for a THP zone
device private page is made.

Add compound page awareness to the allocation function during
normal migration and fault based migration. These routines also
copy folio_nr_pages() when moving data between system memory
and device memory.

args.src and args.dst used to hold migration entries are now
dynamically allocated (as they need to hold HPAGE_PMD_NR entries
or more).

Split and migrate support will be added in future patches in this
series.

Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/memremap.h |  12 ++
 lib/test_hmm.c           | 366 +++++++++++++++++++++++++++++++--------
 2 files changed, 303 insertions(+), 75 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index a0723b35eeaa..0c5141a7d58c 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -169,6 +169,18 @@ static inline bool folio_is_device_private(const struct folio *folio)
 	return is_device_private_page(&folio->page);
 }
 
+static inline void *folio_zone_device_data(const struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(!folio_is_device_private(folio), folio);
+	return folio->page.zone_device_data;
+}
+
+static inline void folio_set_zone_device_data(struct folio *folio, void *data)
+{
+	VM_WARN_ON_FOLIO(!folio_is_device_private(folio), folio);
+	folio->page.zone_device_data = data;
+}
+
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 761725bc713c..4850f9026694 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -119,6 +119,7 @@ struct dmirror_device {
 	unsigned long		calloc;
 	unsigned long		cfree;
 	struct page		*free_pages;
+	struct folio		*free_folios;
 	spinlock_t		lock;		/* protects the above */
 };
 
@@ -492,7 +493,7 @@ static int dmirror_write(struct dmirror *dmirror, struct hmm_dmirror_cmd *cmd)
 }
 
 static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
-				   struct page **ppage)
+				  struct page **ppage, bool is_large)
 {
 	struct dmirror_chunk *devmem;
 	struct resource *res = NULL;
@@ -572,20 +573,45 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 		pfn_first, pfn_last);
 
 	spin_lock(&mdevice->lock);
-	for (pfn = pfn_first; pfn < pfn_last; pfn++) {
+	for (pfn = pfn_first; pfn < pfn_last; ) {
 		struct page *page = pfn_to_page(pfn);
 
+		if (is_large && IS_ALIGNED(pfn, HPAGE_PMD_NR)
+			&& (pfn + HPAGE_PMD_NR <= pfn_last)) {
+			page->zone_device_data = mdevice->free_folios;
+			mdevice->free_folios = page_folio(page);
+			pfn += HPAGE_PMD_NR;
+			continue;
+		}
+
 		page->zone_device_data = mdevice->free_pages;
 		mdevice->free_pages = page;
+		pfn++;
 	}
+
+	ret = 0;
 	if (ppage) {
-		*ppage = mdevice->free_pages;
-		mdevice->free_pages = (*ppage)->zone_device_data;
-		mdevice->calloc++;
+		if (is_large) {
+			if (!mdevice->free_folios) {
+				ret = -ENOMEM;
+				goto err_unlock;
+			}
+			*ppage = folio_page(mdevice->free_folios, 0);
+			mdevice->free_folios = (*ppage)->zone_device_data;
+			mdevice->calloc += HPAGE_PMD_NR;
+		} else if (mdevice->free_pages) {
+			*ppage = mdevice->free_pages;
+			mdevice->free_pages = (*ppage)->zone_device_data;
+			mdevice->calloc++;
+		} else {
+			ret = -ENOMEM;
+			goto err_unlock;
+		}
 	}
+err_unlock:
 	spin_unlock(&mdevice->lock);
 
-	return 0;
+	return ret;
 
 err_release:
 	mutex_unlock(&mdevice->devmem_lock);
@@ -598,10 +624,13 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 	return ret;
 }
 
-static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
+static struct page *dmirror_devmem_alloc_page(struct dmirror *dmirror,
+					      bool is_large)
 {
 	struct page *dpage = NULL;
 	struct page *rpage = NULL;
+	unsigned int order = is_large ? HPAGE_PMD_ORDER : 0;
+	struct dmirror_device *mdevice = dmirror->mdevice;
 
 	/*
 	 * For ZONE_DEVICE private type, this is a fake device so we allocate
@@ -610,49 +639,55 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
 	 * data and ignore rpage.
 	 */
 	if (dmirror_is_private_zone(mdevice)) {
-		rpage = alloc_page(GFP_HIGHUSER);
+		rpage = folio_page(folio_alloc(GFP_HIGHUSER, order), 0);
 		if (!rpage)
 			return NULL;
 	}
 	spin_lock(&mdevice->lock);
 
-	if (mdevice->free_pages) {
+	if (is_large && mdevice->free_folios) {
+		dpage = folio_page(mdevice->free_folios, 0);
+		mdevice->free_folios = dpage->zone_device_data;
+		mdevice->calloc += 1 << order;
+		spin_unlock(&mdevice->lock);
+	} else if (!is_large && mdevice->free_pages) {
 		dpage = mdevice->free_pages;
 		mdevice->free_pages = dpage->zone_device_data;
 		mdevice->calloc++;
 		spin_unlock(&mdevice->lock);
 	} else {
 		spin_unlock(&mdevice->lock);
-		if (dmirror_allocate_chunk(mdevice, &dpage))
+		if (dmirror_allocate_chunk(mdevice, &dpage, is_large))
 			goto error;
 	}
 
-	zone_device_page_init(dpage);
+	zone_device_folio_init(page_folio(dpage), order);
 	dpage->zone_device_data = rpage;
 	return dpage;
 
 error:
 	if (rpage)
-		__free_page(rpage);
+		__free_pages(rpage, order);
 	return NULL;
 }
 
 static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 					   struct dmirror *dmirror)
 {
-	struct dmirror_device *mdevice = dmirror->mdevice;
 	const unsigned long *src = args->src;
 	unsigned long *dst = args->dst;
 	unsigned long addr;
 
-	for (addr = args->start; addr < args->end; addr += PAGE_SIZE,
-						   src++, dst++) {
+	for (addr = args->start; addr < args->end; ) {
 		struct page *spage;
 		struct page *dpage;
 		struct page *rpage;
+		bool is_large = *src & MIGRATE_PFN_COMPOUND;
+		int write = (*src & MIGRATE_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
+		unsigned long nr = 1;
 
 		if (!(*src & MIGRATE_PFN_MIGRATE))
-			continue;
+			goto next;
 
 		/*
 		 * Note that spage might be NULL which is OK since it is an
@@ -662,17 +697,45 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 		if (WARN(spage && is_zone_device_page(spage),
 		     "page already in device spage pfn: 0x%lx\n",
 		     page_to_pfn(spage)))
+			goto next;
+
+		dpage = dmirror_devmem_alloc_page(dmirror, is_large);
+		if (!dpage) {
+			struct folio *folio;
+			unsigned long i;
+			unsigned long spfn = *src >> MIGRATE_PFN_SHIFT;
+			struct page *src_page;
+
+			if (!is_large)
+				goto next;
+
+			if (!spage && is_large) {
+				nr = HPAGE_PMD_NR;
+			} else {
+				folio = page_folio(spage);
+				nr = folio_nr_pages(folio);
+			}
+
+			for (i = 0; i < nr && addr < args->end; i++) {
+				dpage = dmirror_devmem_alloc_page(dmirror, false);
+				rpage = BACKING_PAGE(dpage);
+				rpage->zone_device_data = dmirror;
+
+				*dst = migrate_pfn(page_to_pfn(dpage)) | write;
+				src_page = pfn_to_page(spfn + i);
+
+				if (spage)
+					copy_highpage(rpage, src_page);
+				else
+					clear_highpage(rpage);
+				src++;
+				dst++;
+				addr += PAGE_SIZE;
+			}
 			continue;
-
-		dpage = dmirror_devmem_alloc_page(mdevice);
-		if (!dpage)
-			continue;
+		}
 
 		rpage = BACKING_PAGE(dpage);
-		if (spage)
-			copy_highpage(rpage, spage);
-		else
-			clear_highpage(rpage);
 
 		/*
 		 * Normally, a device would use the page->zone_device_data to
@@ -684,10 +747,42 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 
 		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
 			 page_to_pfn(spage), page_to_pfn(dpage));
-		*dst = migrate_pfn(page_to_pfn(dpage));
-		if ((*src & MIGRATE_PFN_WRITE) ||
-		    (!spage && args->vma->vm_flags & VM_WRITE))
-			*dst |= MIGRATE_PFN_WRITE;
+
+		*dst = migrate_pfn(page_to_pfn(dpage)) | write;
+
+		if (is_large) {
+			int i;
+			struct folio *folio = page_folio(dpage);
+			*dst |= MIGRATE_PFN_COMPOUND;
+
+			if (folio_test_large(folio)) {
+				for (i = 0; i < folio_nr_pages(folio); i++) {
+					struct page *dst_page =
+						pfn_to_page(page_to_pfn(rpage) + i);
+					struct page *src_page =
+						pfn_to_page(page_to_pfn(spage) + i);
+
+					if (spage)
+						copy_highpage(dst_page, src_page);
+					else
+						clear_highpage(dst_page);
+					src++;
+					dst++;
+					addr += PAGE_SIZE;
+				}
+				continue;
+			}
+		}
+
+		if (spage)
+			copy_highpage(rpage, spage);
+		else
+			clear_highpage(rpage);
+
+next:
+		src++;
+		dst++;
+		addr += PAGE_SIZE;
 	}
 }
 
@@ -734,14 +829,17 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 	const unsigned long *src = args->src;
 	const unsigned long *dst = args->dst;
 	unsigned long pfn;
+	const unsigned long start_pfn = start >> PAGE_SHIFT;
+	const unsigned long end_pfn = end >> PAGE_SHIFT;
 
 	/* Map the migrated pages into the device's page tables. */
 	mutex_lock(&dmirror->mutex);
 
-	for (pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++,
-								src++, dst++) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn++, src++, dst++) {
 		struct page *dpage;
 		void *entry;
+		int nr, i;
+		struct page *rpage;
 
 		if (!(*src & MIGRATE_PFN_MIGRATE))
 			continue;
@@ -750,13 +848,25 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 		if (!dpage)
 			continue;
 
-		entry = BACKING_PAGE(dpage);
-		if (*dst & MIGRATE_PFN_WRITE)
-			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
-		entry = xa_store(&dmirror->pt, pfn, entry, GFP_ATOMIC);
-		if (xa_is_err(entry)) {
-			mutex_unlock(&dmirror->mutex);
-			return xa_err(entry);
+		if (*dst & MIGRATE_PFN_COMPOUND)
+			nr = folio_nr_pages(page_folio(dpage));
+		else
+			nr = 1;
+
+		WARN_ON_ONCE(end_pfn < start_pfn + nr);
+
+		rpage = BACKING_PAGE(dpage);
+		VM_WARN_ON(folio_nr_pages(page_folio(rpage)) != nr);
+
+		for (i = 0; i < nr; i++) {
+			entry = folio_page(page_folio(rpage), i);
+			if (*dst & MIGRATE_PFN_WRITE)
+				entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
+			entry = xa_store(&dmirror->pt, pfn + i, entry, GFP_ATOMIC);
+			if (xa_is_err(entry)) {
+				mutex_unlock(&dmirror->mutex);
+				return xa_err(entry);
+			}
 		}
 	}
 
@@ -829,31 +939,66 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 	unsigned long start = args->start;
 	unsigned long end = args->end;
 	unsigned long addr;
+	unsigned int order = 0;
+	int i;
 
-	for (addr = start; addr < end; addr += PAGE_SIZE,
-				       src++, dst++) {
+	for (addr = start; addr < end; ) {
 		struct page *dpage, *spage;
 
 		spage = migrate_pfn_to_page(*src);
-		if (!spage || !(*src & MIGRATE_PFN_MIGRATE))
-			continue;
+		if (!spage || !(*src & MIGRATE_PFN_MIGRATE)) {
+			addr += PAGE_SIZE;
+			goto next;
+		}
 
 		if (WARN_ON(!is_device_private_page(spage) &&
-			    !is_device_coherent_page(spage)))
-			continue;
+			    !is_device_coherent_page(spage))) {
+			addr += PAGE_SIZE;
+			goto next;
+		}
+
 		spage = BACKING_PAGE(spage);
-		dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
-		if (!dpage)
-			continue;
-		pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
-			 page_to_pfn(spage), page_to_pfn(dpage));
+		order = folio_order(page_folio(spage));
 
+		if (order)
+			dpage = folio_page(vma_alloc_folio(GFP_HIGHUSER_MOVABLE,
+						order, args->vma, addr), 0);
+		else
+			dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+
+		/* Try with smaller pages if large allocation fails */
+		if (!dpage && order) {
+			dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+			if (!dpage)
+				return VM_FAULT_OOM;
+			order = 0;
+		}
+
+		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
+				page_to_pfn(spage), page_to_pfn(dpage));
 		lock_page(dpage);
 		xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
 		copy_highpage(dpage, spage);
 		*dst = migrate_pfn(page_to_pfn(dpage));
 		if (*src & MIGRATE_PFN_WRITE)
 			*dst |= MIGRATE_PFN_WRITE;
+		if (order)
+			*dst |= MIGRATE_PFN_COMPOUND;
+
+		for (i = 0; i < (1 << order); i++) {
+			struct page *src_page;
+			struct page *dst_page;
+
+			src_page = pfn_to_page(page_to_pfn(spage) + i);
+			dst_page = pfn_to_page(page_to_pfn(dpage) + i);
+
+			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
+			copy_highpage(dst_page, src_page);
+		}
+next:
+		addr += PAGE_SIZE << order;
+		src += 1 << order;
+		dst += 1 << order;
 	}
 	return 0;
 }
@@ -879,11 +1024,14 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 	unsigned long size = cmd->npages << PAGE_SHIFT;
 	struct mm_struct *mm = dmirror->notifier.mm;
 	struct vm_area_struct *vma;
-	unsigned long src_pfns[32] = { 0 };
-	unsigned long dst_pfns[32] = { 0 };
 	struct migrate_vma args = { 0 };
 	unsigned long next;
 	int ret;
+	unsigned long *src_pfns;
+	unsigned long *dst_pfns;
+
+	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
 
 	start = cmd->addr;
 	end = start + size;
@@ -902,7 +1050,7 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 			ret = -EINVAL;
 			goto out;
 		}
-		next = min(end, addr + (ARRAY_SIZE(src_pfns) << PAGE_SHIFT));
+		next = min(end, addr + (PTRS_PER_PTE << PAGE_SHIFT));
 		if (next > vma->vm_end)
 			next = vma->vm_end;
 
@@ -912,7 +1060,7 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 		args.start = addr;
 		args.end = next;
 		args.pgmap_owner = dmirror->mdevice;
-		args.flags = dmirror_select_device(dmirror);
+		args.flags = dmirror_select_device(dmirror) | MIGRATE_VMA_SELECT_COMPOUND;
 
 		ret = migrate_vma_setup(&args);
 		if (ret)
@@ -928,6 +1076,8 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 out:
 	mmap_read_unlock(mm);
 	mmput(mm);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 
 	return ret;
 }
@@ -939,12 +1089,12 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	unsigned long size = cmd->npages << PAGE_SHIFT;
 	struct mm_struct *mm = dmirror->notifier.mm;
 	struct vm_area_struct *vma;
-	unsigned long src_pfns[32] = { 0 };
-	unsigned long dst_pfns[32] = { 0 };
 	struct dmirror_bounce bounce;
 	struct migrate_vma args = { 0 };
 	unsigned long next;
 	int ret;
+	unsigned long *src_pfns;
+	unsigned long *dst_pfns;
 
 	start = cmd->addr;
 	end = start + size;
@@ -955,6 +1105,18 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
+	ret = -ENOMEM;
+	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns),
+			  GFP_KERNEL | __GFP_NOFAIL);
+	if (!src_pfns)
+		goto free_mem;
+
+	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns),
+			  GFP_KERNEL | __GFP_NOFAIL);
+	if (!dst_pfns)
+		goto free_mem;
+
+	ret = 0;
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = vma_lookup(mm, addr);
@@ -962,7 +1124,7 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 			ret = -EINVAL;
 			goto out;
 		}
-		next = min(end, addr + (ARRAY_SIZE(src_pfns) << PAGE_SHIFT));
+		next = min(end, addr + (PTRS_PER_PTE << PAGE_SHIFT));
 		if (next > vma->vm_end)
 			next = vma->vm_end;
 
@@ -972,7 +1134,8 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 		args.start = addr;
 		args.end = next;
 		args.pgmap_owner = dmirror->mdevice;
-		args.flags = MIGRATE_VMA_SELECT_SYSTEM;
+		args.flags = MIGRATE_VMA_SELECT_SYSTEM |
+				MIGRATE_VMA_SELECT_COMPOUND;
 		ret = migrate_vma_setup(&args);
 		if (ret)
 			goto out;
@@ -992,7 +1155,7 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	 */
 	ret = dmirror_bounce_init(&bounce, start, size);
 	if (ret)
-		return ret;
+		goto free_mem;
 	mutex_lock(&dmirror->mutex);
 	ret = dmirror_do_read(dmirror, start, end, &bounce);
 	mutex_unlock(&dmirror->mutex);
@@ -1003,11 +1166,14 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	}
 	cmd->cpages = bounce.cpages;
 	dmirror_bounce_fini(&bounce);
-	return ret;
+	goto free_mem;
 
 out:
 	mmap_read_unlock(mm);
 	mmput(mm);
+free_mem:
+	kfree(src_pfns);
+	kfree(dst_pfns);
 	return ret;
 }
 
@@ -1200,6 +1366,7 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	unsigned long i;
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
+	unsigned int order = 0;
 
 	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
 	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
@@ -1215,13 +1382,25 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 		if (WARN_ON(!is_device_private_page(spage) &&
 			    !is_device_coherent_page(spage)))
 			continue;
+
+		order = folio_order(page_folio(spage));
 		spage = BACKING_PAGE(spage);
-		dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
+		if (src_pfns[i] & MIGRATE_PFN_COMPOUND) {
+			dpage = folio_page(folio_alloc(GFP_HIGHUSER_MOVABLE,
+					      order), 0);
+		} else {
+			dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
+			order = 0;
+		}
+
+		/* TODO Support splitting here */
 		lock_page(dpage);
-		copy_highpage(dpage, spage);
 		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
 		if (src_pfns[i] & MIGRATE_PFN_WRITE)
 			dst_pfns[i] |= MIGRATE_PFN_WRITE;
+		if (order)
+			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
+		folio_copy(page_folio(dpage), page_folio(spage));
 	}
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
@@ -1234,7 +1413,12 @@ static void dmirror_remove_free_pages(struct dmirror_chunk *devmem)
 {
 	struct dmirror_device *mdevice = devmem->mdevice;
 	struct page *page;
+	struct folio *folio;
 
+
+	for (folio = mdevice->free_folios; folio; folio = folio_zone_device_data(folio))
+		if (dmirror_page_to_chunk(folio_page(folio, 0)) == devmem)
+			mdevice->free_folios = folio_zone_device_data(folio);
 	for (page = mdevice->free_pages; page; page = page->zone_device_data)
 		if (dmirror_page_to_chunk(page) == devmem)
 			mdevice->free_pages = page->zone_device_data;
@@ -1265,6 +1449,7 @@ static void dmirror_device_remove_chunks(struct dmirror_device *mdevice)
 		mdevice->devmem_count = 0;
 		mdevice->devmem_capacity = 0;
 		mdevice->free_pages = NULL;
+		mdevice->free_folios = NULL;
 		kfree(mdevice->devmem_chunks);
 		mdevice->devmem_chunks = NULL;
 	}
@@ -1378,18 +1563,30 @@ static void dmirror_devmem_free(struct page *page)
 {
 	struct page *rpage = BACKING_PAGE(page);
 	struct dmirror_device *mdevice;
+	struct folio *folio = page_folio(rpage);
+	unsigned int order = folio_order(folio);
 
-	if (rpage != page)
-		__free_page(rpage);
+	if (rpage != page) {
+		if (order)
+			__free_pages(rpage, order);
+		else
+			__free_page(rpage);
+		rpage = NULL;
+	}
 
 	mdevice = dmirror_page_to_device(page);
 	spin_lock(&mdevice->lock);
 
 	/* Return page to our allocator if not freeing the chunk */
 	if (!dmirror_page_to_chunk(page)->remove) {
-		mdevice->cfree++;
-		page->zone_device_data = mdevice->free_pages;
-		mdevice->free_pages = page;
+		mdevice->cfree += 1 << order;
+		if (order) {
+			page->zone_device_data = mdevice->free_folios;
+			mdevice->free_folios = page_folio(page);
+		} else {
+			page->zone_device_data = mdevice->free_pages;
+			mdevice->free_pages = page;
+		}
 	}
 	spin_unlock(&mdevice->lock);
 }
@@ -1397,11 +1594,10 @@ static void dmirror_devmem_free(struct page *page)
 static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 {
 	struct migrate_vma args = { 0 };
-	unsigned long src_pfns = 0;
-	unsigned long dst_pfns = 0;
 	struct page *rpage;
 	struct dmirror *dmirror;
-	vm_fault_t ret;
+	vm_fault_t ret = 0;
+	unsigned int order, nr;
 
 	/*
 	 * Normally, a device would use the page->zone_device_data to point to
@@ -1412,21 +1608,38 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	dmirror = rpage->zone_device_data;
 
 	/* FIXME demonstrate how we can adjust migrate range */
+	order = folio_order(page_folio(vmf->page));
+	nr = 1 << order;
+
+	/*
+	 * Consider a per-cpu cache of src and dst pfns, but with
+	 * large number of cpus that might not scale well.
+	 */
+	args.start = ALIGN_DOWN(vmf->address, (PAGE_SIZE << order));
 	args.vma = vmf->vma;
-	args.start = vmf->address;
-	args.end = args.start + PAGE_SIZE;
-	args.src = &src_pfns;
-	args.dst = &dst_pfns;
+	args.end = args.start + (PAGE_SIZE << order);
+
+	nr = (args.end - args.start) >> PAGE_SHIFT;
+	args.src = kcalloc(nr, sizeof(unsigned long), GFP_KERNEL);
+	args.dst = kcalloc(nr, sizeof(unsigned long), GFP_KERNEL);
 	args.pgmap_owner = dmirror->mdevice;
 	args.flags = dmirror_select_device(dmirror);
 	args.fault_page = vmf->page;
 
+	if (!args.src || !args.dst) {
+		ret = VM_FAULT_OOM;
+		goto err;
+	}
+
+	if (order)
+		args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
+
 	if (migrate_vma_setup(&args))
 		return VM_FAULT_SIGBUS;
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
 	if (ret)
-		return ret;
+		goto err;
 	migrate_vma_pages(&args);
 	/*
 	 * No device finalize step is needed since
@@ -1434,7 +1647,10 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	 * invalidated the device page table.
 	 */
 	migrate_vma_finalize(&args);
-	return 0;
+err:
+	kfree(args.src);
+	kfree(args.dst);
+	return ret;
 }
 
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
@@ -1465,7 +1681,7 @@ static int dmirror_device_init(struct dmirror_device *mdevice, int id)
 		return ret;
 
 	/* Build a list of free ZONE_DEVICE struct pages */
-	return dmirror_allocate_chunk(mdevice, NULL);
+	return dmirror_allocate_chunk(mdevice, NULL, false);
 }
 
 static void dmirror_device_remove(struct dmirror_device *mdevice)
-- 
2.50.1


