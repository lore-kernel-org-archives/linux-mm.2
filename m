Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A964410F994F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE8D6B0005; Wed,  8 Apr 2026 11:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F4E6B0089; Wed,  8 Apr 2026 11:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26D86B008A; Wed,  8 Apr 2026 11:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FDC56B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:41:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F9A3E01EC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:41:14 +0000 (UTC)
X-FDA: 84635802468.10.63BB440
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by imf15.hostedemail.com (Postfix) with ESMTP id 51BC0A000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:41:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uK9ED8VF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775662871; a=rsa-sha256;
	cv=pass;
	b=xn2Nl6UhPhwmBGGhifb3g/ZOSriO2kJe3u0bF6afH2+8c409//8FWIRoe1tJrdeJJYchfx
	NqJQqbpiW9GnyoAOgXZtoaddcSDT1lXAnEPVRbU2cyZFWterfRAcGV4pZKTYD0HzDISOt7
	rSmHZhSqkh0YDdqKpSMs5i/IL1Zv6P8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uK9ED8VF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775662871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+xvlBHBcH7IM2+ZDj18/N62x/I7T5X6uhPVMzuDREs=;
	b=OuNRRcMx5sLtgWQ8yECobfzVMjItXVs73DFwUJP+sbRvrQxoh/Og+TVVQVxH+YvLtbmgML
	Q3motIH564bX2qqWC8cJB8KQUq4X6LB92/EHiup9oGPmhlpPOtDkOEEXAlUh3GW3W02cI/
	TsP8a7S4PIuTveNH8j//9qJHBtA1mbg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fuYjpxG7lLAnKtlClwowE6iGtNF4kRxZtRBp0cppjZ0G45+zAHJZ8ZFcYtu1ONHV0BiFOlYYYnbK9oCkiW472EAErEZjRX8MdEjKV24G97eZUqhXIDA9nuHm9Al5OroO/+iTt+8kgrU2ZOhlfwy4tQqJ9HTGwzWTIpSMtwTBlO9oOO48n2mPxiFNKi7Kdij8Xy4j9iSgugO1Mg2YqxvkIoIduqTteWwlJqxwmXInz4orNQA6gpmDyGY2a2vqcHJvltwjAVfYSGmR/rsWU1Ff62zsEibPt8UPS6q345BkG+JOYwvfWl+XCg22Qzz0uN73ySEbWehZ71KkgMSCdFX6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+xvlBHBcH7IM2+ZDj18/N62x/I7T5X6uhPVMzuDREs=;
 b=uZNYz1cn2gdtfvOEGYoorVG+TbZIXTXtgbiLHqXGdKQzv+xnGEfp3PM0q2VV4PZWPWJeS3QgNvYLV7iAQhnkSTbC0ySQ42yVTWTCQL82BR2bLRj7XgbyVlO/C3a073vLZlSCB0+xjCuAVB5wJw/3GxCHKhBmKW2OXb0QgzlDJ+gWJl7YtRbawgx65F4NJ3s1N8Ccl29UfgcwGeSArvxpQShp9XsbO5kC9bEFAvMJpNb6pTN1phevxDw3LBj4Hm3Xg3eu/IfYCs9sJUtxO8mi9PGu9GQ25kZR4CxIbXuuM+n+uwFwehh6Hhi+0NGwPAIlZ3nDejarNPRKIYdJByo8pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+xvlBHBcH7IM2+ZDj18/N62x/I7T5X6uhPVMzuDREs=;
 b=uK9ED8VF09lwR3m0RQAyVjH2ajhslIwFuvFB0g2nhkIc02eyNT6tFO0rlAZBeZhuvfzSo1SlmfZreIRu2/FSKRO5F3bpAeQsO4dekx8SEjkJPL77uYbOfEndlbo3NEM2cJxPw4ePhJoIkRzXRdqpnceZyJaimX6T3dPaHZUau8S3AYvKRF1/QcRrzQKXoZFQ4sRG2izMToyv2gX+oeUro8dHZb6W3n/zpO2PyGidE5AvyegUi1SQ8FOKi5XZpb2ghLjj3lWjqB4GZX+41tvwZ6ZCQMvCq2IdK5G+QzsNABev0JHM52gxFdICSNXLQOh5rkJSAYkocRg0P74+yOwWsA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPF4A654669B.namprd12.prod.outlook.com (2603:10b6:f:fc00::64b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.41; Wed, 8 Apr
 2026 15:41:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 8 Apr 2026
 15:41:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v4 13/15] selftests/mm: move hwpoison setup into
 run_test() and silence modprobe output for memory-failure category
Date: Wed, 08 Apr 2026 11:40:59 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <B686276F-89E5-4192-8973-3B787FC8AC86@nvidia.com>
In-Reply-To: <5888f69f-c336-4151-a9ac-9b0b00f9c3bb@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
 <8ef8640092004d143fe80e6fc32ea8d30a9080de.1775466330.git.sayalip@linux.ibm.com>
 <8B26C697-4D0C-4E1E-A14E-D517CC9DA05A@nvidia.com>
 <5888f69f-c336-4151-a9ac-9b0b00f9c3bb@linux.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0316.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPF4A654669B:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bffe843-2c4b-4cd5-112d-08de95853d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FEVB6z1kfUqnNQ9YWMiDj/YPlyiUQypazDmlUxqs8rVBvgGP5Zp1vzmJaez4KUCge2hHyHuPAmtn6mbeQSYcXG9j25GhO+x9NnKcd43SXMsOSHQHEAUL4KEykGm0CNSgHsXNtOuW2hMMH6IkzjQlNWAkocMSFOMUDVERoSC0TY10wegZ50rI5b0gYg0DLhLLLnMQByM15BaZYJC+rN29oZW1hDnPtNrJG3P500h610QTH4J4UUOLXN8vF6wiHbpVn4lNEzNi9BWgenaNjSGfpB6sqR4/9Yz/cawPatArYphlzBKq9lrpy1t7wZw9PSXUM6ZUo+6FGswWkINI+/u+hrezN80XUUurs6U6qxIHCprTBP7TBOMy+yuE9fBsSkBrE7tOuVH9JocHOmPGu0DuHHJYNksKNN20OEkZaV1vfJu18IPmfXztfldAVZf0JN7mFD5tfNUVT2JWw5hTBw4U2rthD2Plxzbk7VU4Q3YqzAL6dDbHSbZQ8kCaSrIUsox2Srnjv1pf4Z/VU2Ljtmo5XxA5LCSw1liKI1vfsCwv8xUlaqH8fn/sDx1yPeo52oPPGAyoteJUTl9wUsQyOtu/ON0E5Y0s3npLs/ubUF3C95B0/iZsDWSvbDmepizLkgFxQaZu4MyZP0AI/+qkkmmA2j6vmeRcPeIOcGCg6ynhFSe8/T9DC0pp1MN6+awGhCKXzcH/bZd6rsWforBclbs7MfKOWGC8l5zAiC2w1uUxkkk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WDY3lvwlRZpvaNoJGrMBL5b9WUgsXHoViwBNkBTuDifeyoZCeRVw9xzII4u/?=
 =?us-ascii?Q?taLdWyKwGn98DKr/6vdz4ArwbN37dlUAeAmqFWb5Xf40PWoVY1MULgpGjU33?=
 =?us-ascii?Q?mDYRe/MraAsTtyz0Eaq9qKJ1hh+wwJ/BTGwY0f2lMqek2/2uN2Y2ugfXNLpQ?=
 =?us-ascii?Q?dN7Z2e2rUnYVseUOqhXryoDulOeU7VS+5UAMLuswq7Tmw+hJT2Me84fXTxVZ?=
 =?us-ascii?Q?imyKXrmVsdPM7+qhoKwUwt7G1jMPi87MVVNlGXpGxeWYfih7xbDqS03HsYIx?=
 =?us-ascii?Q?GUUKrVVM3ydYJo5sE9etvIlmtYusdwnDMJbH8ie+A5ZDYSiiJFdl8zY3noOv?=
 =?us-ascii?Q?YKkZkUZCTu4baBIjV9QtzvjdOTpsC12NJAPpNK7F6+teoKJrgjg+v4P7DFQe?=
 =?us-ascii?Q?Xgvb+w7xZY+f0WDjXa4g/kRJ2BnFT1CksiiBSleE85CA46j/6N3BEmfUz+h7?=
 =?us-ascii?Q?VVg60Ow2Q41UQQOSLHzY703fnnDOHqo2FYAaBO5vQjbZZTd0DFFCwC//lviJ?=
 =?us-ascii?Q?wWHiCZFuxYCR0VDu0Pma3zSUSwGtQIaB4stf3ddxECr8gSqsg8qucw+WcjiL?=
 =?us-ascii?Q?YopQaNRNSoW/yI55LoMvcVD3boNRKnH9W5oxcVhtm8v0BPlFzJi+Nb+67J3U?=
 =?us-ascii?Q?f6viVJBE69WXQS33W2TzI/7SFGISqKofE+9czQYp/P+zsFcuPB8TGhnQDk+m?=
 =?us-ascii?Q?v/aM20DRQKGyWXvwZqhfVBuBbrqrLj++NIfdEmmtX8dO4syivMcl28YmzRsW?=
 =?us-ascii?Q?1tnGmoNxpUk59eN7eXboSWSm1qQZ8VPz4O3lWRrLEkWMBTToxLLDIVHkHYcX?=
 =?us-ascii?Q?FbsWI5LjnIv6Gznxh8aVvOfsVIGV3/s4VISaHKKNUGr4xGYzUNxZ0lXSxD+3?=
 =?us-ascii?Q?r8XLQhRRBMKlng4JjVO+77SBngTEVzFupNSVDZYvu+kV9LewwLNR3ID6Vuoz?=
 =?us-ascii?Q?W6LH1OyUDbCesfpOyYcyRJe+snDi2uabbq3jWL2KnhFbVZXbNfJFBncpOFvf?=
 =?us-ascii?Q?FaX/AFIBri+LQGz1zNfaGehVIrIxkP0zdHV3ZYW9FZ/0W8j91R810Yqvial9?=
 =?us-ascii?Q?Q+GRxK67nNNRuH4bfvc6xYcyY/YSvPLxdMg21gSbJoczgcaDWejYJR+BkVl7?=
 =?us-ascii?Q?njn83X0KYrPdwRHwQFB8WhU+ZjccWWjA7c0WYOHbRIOC4Vu6USWid5Uam2aJ?=
 =?us-ascii?Q?G7REHNFbA8QjmPR6A6MvyL1CGOnpDGrVEFO3+G6rUETVoiIwDlkPLhmlRjmt?=
 =?us-ascii?Q?51yxJfIMlxcU1ny99hYRdDESZieEodrQRgUNsTb5z/580cFmwOLH7KabCN2L?=
 =?us-ascii?Q?nGIsZue3anatcqT5//kokY2wnfCmOMwPOLsuO47uw39EeSssPAgKKvVbhGHh?=
 =?us-ascii?Q?iNoivUOacSFKN/QwRNYRkJ55q+kaZX1qcNGdh7Etr+2hsYTy5Xsb8bAYLeZS?=
 =?us-ascii?Q?+Z1LP5wnPTfRKJK1NnrstjP/eGKWcX7z0YPV3dmIFtiMmd0jWnH9De1nFW/W?=
 =?us-ascii?Q?TpS8Aw/4qknUfKku+gdlZklt2YN7hayOiNJwRrbwtdWthjJ9+L3JSwp9TtyC?=
 =?us-ascii?Q?fto7ft+utrG71aGAtgRNrXrfELl4nH/LJbBHRtPUHSurqMEp4D9CPWkezxWH?=
 =?us-ascii?Q?8vCS/HYhKRejnxYRq6pJO0hGnp3w4TUd4+Xw1EH/020IpUkz6aLdNIoT9x/y?=
 =?us-ascii?Q?ObkRbRDp7dMYK5iBNcCD0CocCurVAxU3IMxjaqwkj8Fiaqv4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bffe843-2c4b-4cd5-112d-08de95853d0b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 15:41:02.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tNbXd0VfJAwmb+9O0ztR2qqmYD5am9JD10XcYGTAU/1Y1XUithNV9YQwtbTthF/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF4A654669B
X-Stat-Signature: 55jzqxxsxpmcmiorhao7knejb8cji67d
X-Rspamd-Queue-Id: 51BC0A000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775662871-530503
X-HE-Meta: U2FsdGVkX18fo4h4QAeV8yzEG51CUlL2JJHANa4kfgr4XlsaQlKdsluZ6KQj1ujMbXxBdhnI3rwDr5OucMP+ChBRy3mtFNiQPp9RzcmjWtK83IQo3CXcgugBl+HQ9l5a0QyD7c/swiYHl8uP+iK5LLRMEbBP1sngJX08c1kK8JvC2VmorK2Hp7eWBO13o4fo0aVTrOHOCOACe8+PfQzbANkb66L0DGlfaP6PK++KjOoPk2hMsiiC3afKurF8kfE53u/Gu8eLZUHzlQOcUSA5FSwcuPcRMJfXuyltU0qakAGLxUNo6mudd4KGZvqvQy6X4Wy0EwLNVgwklFO8ZrsmAWb5gOFdcg1me1Vwuz1BHTyOl7sXLdDGYoeurVOUFaNuzUije94yr6cnrSv+69sE/gjYwsA6mMH1v7wFcFPoySehxqEnyzeSxAvDuj2xVtMPiM+mhAyutz5wcjHcPIlDLE53q1+vzmNmX9GZLnskmkREFZ+rp6QxpMSszwZxU5ExKp6izH7sJIrsXNd0M8kt8kQNV6Lx9OctEoVujXeQp3CLioX+XInIFNbVGNlpflaJGfQGSKk/aZumDDbPIIgSv+diyUVoD5jn3V8YM0kKvCMfq8KOP5DqakVRgNpZ378CEALRJS5FZcoUAPZEEcCvWcEjoBxljXEmms+71a+T4rtljqxC1Y4WJs5R4y7C1CRsJQIQqUHoChmMtj1gnqoud1mFJcY0CEg3/OONhwnK0HI6S57cwlBzI0Zs5OiKRqI32ZFD6u7VjHjP34NR7MtKMK48f20pVQoqHdxa/iJI3J7i6mWePhbIHZf+Pcav2z77hTC3fb38a2o8Kfru6NfW9icwM3jKyGVlGqvPTZ5lhz6oNDH9K6OHR1GuVh7Rn1RioSqvi/xpHLE1qRcCdwtnb/xHIoctjQltFyOmnd6H9eRdThY06pgdVRKIOgL4fynWXlv5pBQWr5fvN8gKy7b
 M6Mnpl13
 B99sEbaeKJgv4xhtPMevHGaHtlC3lM3z/kvg/pewDb2050AqMq580QuDL0hywKlQ/sF0Nmu6g2R/0CBWyzF1pYajmDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 4:36, Sayali Patil wrote:

> On 07/04/26 20:21, Zi Yan wrote:
>> On 6 Apr 2026, at 5:19, Sayali Patil wrote:
>>
>>> run_vmtests.sh contains special handling to ensure the hwpoison_injec=
t
>>> module is available for the memory-failure tests. This logic was
>>> implemented outside of run_test(), making the setup category-specific=

>>> but managed globally.
>>>
>>> Move the hwpoison_inject handling into run_test() and restrict it
>>> to the memory-failure category so that:
>>> 1. the module is checked and loaded only when memory-failure tests ru=
n,
>>> 2. the test is skipped if the module or the debugfs interface
>>> (/sys/kernel/debug/hwpoison/) is not available.
>>> 3. the module is unloaded after the test if it was loaded by the scri=
pt.
>>>
>>> This localizes category-specific setup and makes the test flow
>>> consistent with other per-category preparations.
>>>
>>> While updating this logic, fix the module availability check.
>>> The script previously used:
>>>
>>> 	modprobe -R hwpoison_inject
>>>
>>> The -R option prints the resolved module name to stdout, causing ever=
y
>>> run to print:
>>>
>>> 	hwpoison_inject
>>>
>>> in the test output, even when no action is required, introducing
>>> unnecessary noise.
>>>
>>> Replace this with:
>>>
>>> 	modprobe -n hwpoison_inject
>>>
>>> which verifies that the module is loadable without producing output,
>>> keeping the selftest logs clean and consistent.
>>>
>>> Also, ensure that skipped tests do not override a previously recorded=

>>> failure. A skipped test currently sets exitcode to ksft_skip even if =
a
>>> prior test has failed, which can mask failures in the final exit stat=
us.
>>> Update the logic to only set exitcode to ksft_skip when no failure ha=
s
>>> been recorded.
>>>
>>> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page=
 test")
>>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>>> ---
>>>   tools/testing/selftests/mm/run_vmtests.sh | 52 ++++++++++++++------=
---
>>>   1 file changed, 33 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testin=
g/selftests/mm/run_vmtests.sh
>>> index afdcfd0d7cef..17c9bd910c47 100755
>>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>>> @@ -235,6 +235,7 @@ pretty_name() {
>>>   run_test() {
>>>   	if test_selected ${CATEGORY}; then
>>>   		local skip=3D0
>>> +		local LOADED_MOD=3D0
>>
>> Can you rename it to LOADED_MEMORY_FAILURE_MOD to clarify its use?
>> Since now LOADED_MOD is visible for the entire run_test().
>
> Thanks for the review!
>
> I kept it as LOADED_MOD and specified it as a local variable intentiona=
lly. The idea was that, if any future tests are added that need to verify=
 whether the module was loaded, they can reuse the same variable. For tha=
t reason, I did not make it specific to the memory failure test.

You mean future tests that use hwpoison_inject module? Or any future test=
s
that load a module? For the former, you can use LOADED_HWPOISON_INJECT_MO=
D;
for the latter, I am not sure how a single LOADED_MOD would work for
different modules and that probably would need new code for that case.

My point is that since LOADED_MOD is now in the scope of run_test(), it i=
s
unclear which test uses it without reading the entire run_test(). Giving =
a
specific name improves readability.


Best Regards,
Yan, Zi

