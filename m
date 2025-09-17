Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D87CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D816280019; Wed, 17 Sep 2025 15:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78922280002; Wed, 17 Sep 2025 15:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6503F280019; Wed, 17 Sep 2025 15:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 515C9280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:07:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF4B91A0664
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:07:37 +0000 (UTC)
X-FDA: 83899676154.30.23B9B02
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022131.outbound.protection.outlook.com [52.101.48.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 121761C0012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:07:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=QaXa9zVl;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.48.131 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758136055; a=rsa-sha256;
	cv=pass;
	b=hs53jDj1tA9DnsPBZd027XpM7fVj3dBzDrnkPZqjJ0EHdTFdI+mMpSRKny73TTdbiK2Z1S
	LixONuCEei3NH1IW95nx90bWRju7Zij7X1IhhINJKBAzQ4KOHot4MWEhslUv5CHCMgaNxh
	agd0KFLwVpNxeVN0Ht52CH/2edFbP+Y=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=QaXa9zVl;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.48.131 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758136055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lLiP0q5IFLMxnjMShTLnnnDTwSWv5Fa39Icu54ILZE=;
	b=JkP0e0MHeAAuhlWJeFGeElje4p/ogAhuu4+1R7fc0SAupTo8ts8tx4bJxF425TtKKnwsvY
	6EsFf+ifqHRxqxGnf55zXbXamB6j8d5f+L5NwpZ3Dwi1m+8epnyLUBhtXm7u1eSS/ul/pn
	NdtFLNG0loXgExMJcqIQKwNfzA6h4q4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sro1GpR7LO1K9Z8e/DuveA7iwvWBnLVO+OCjkuI7U2jxwskraipCORvtHcweC32beNOVoNFXzvP5KQ7ZFJrxJNv3odQ/FPXF39y94SG4aBGzyZN5wtW22FS2Yy1n9+nG2bVbxJaOvJOIzEMP0ng5hPYc2bFrLvI4QwJqHartuYKlPWQ7SknTDgJN2EWxdfgH9HOSue03R5+M0RPG+9RRoSQzC0wfgZ8t2ZaQJ8zJW5HawU6kpuc1RjSQNnsQiSTgiyP9WfvbVE+xUtZXHb+vJftblltvBbXBURvbW39uO2ah0SuxZshmxUgZZADmRgqmHrItSCCTWSefgL9fvu4+wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lLiP0q5IFLMxnjMShTLnnnDTwSWv5Fa39Icu54ILZE=;
 b=KpEYhVG2YiPPzpBW2ol03ARP5kbbfD42Is/Zn+9zGZvdzpWZhvhtQDRXaD4ZS0eN47XNmebrLd1bhhxZVPx6v6OUsxtZIzjq4wxW1pvptz+Xe5Z7qtmzetZtRtxpMeVSPnyjbLxnwn2RAhWRquX3Qo89i1xgQFn+Xq2x/2OeKRQm1FhuiSxHWQwGufJVUNhNBxT/naahf60KX3ZhoJtTvuk9BLlQ0iA3xcsyjUR3rIMHpNVHuEKe5r2EM7S7czemKu4mrOjqfQi6CV4XIE5tmnS3N3323kcdU+QhRmCjKAdDMTZCRj8O8Gdfoh+FcRfEY2WZHKmpGrttJV3eLdgtQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lLiP0q5IFLMxnjMShTLnnnDTwSWv5Fa39Icu54ILZE=;
 b=QaXa9zVl2v9pRn+a+RPk0PEepiL3DHfjMKFySB8MmLPuI6XpKYZbMZMQyaZvQ/UO/bBK19PccXXiah0b/A157GOylwBLOpRaug7PP5K2bF3iKh9JwdOUCBVc3Pi9t8ji8bjLSDwkcZ4RJAWMhrRD7ndPLWmDfUHN2/qFyZhtvyM=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV8PR01MB8429.prod.exchangelabs.com (2603:10b6:408:189::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.19; Wed, 17 Sep 2025 19:04:19 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:04:18 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ardb@kernel.org,
	dev.jain@arm.com,
	scott@os.amperecomputing.com,
	cl@gentwo.org
Cc: yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 5/5] arm64: kprobes: call set_memory_rox() for kprobe page
Date: Wed, 17 Sep 2025 12:02:11 -0700
Message-ID: <20250917190323.3828347-6-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250917190323.3828347-1-yang@os.amperecomputing.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY8PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:930:4f::16) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV8PR01MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: 1858c89f-7f5b-45f7-96a3-08ddf61cfeef
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1JtawaK/mkDWiXpIKt/cJAWxwvDIj4IMxBHkNO6MuHPLZ+l1mQTAIIFuaEgN?=
 =?us-ascii?Q?gGBesFt6zFrLRsx9Np/aH0F9P25K2Rhnz/lLcEG3XEbZTiO3wrv1/pWvkXgV?=
 =?us-ascii?Q?bxuZBxI9yGEodhang7H3oc0hGUWrE3D1q+nhgmgr+s4msW/2pR5Rqj03SlNw?=
 =?us-ascii?Q?cJvstd5hK8UDV71OMhVGJ6Y8+CJ2sD3pjGuHp3wr06TggvRIVaDQMwjT6sKz?=
 =?us-ascii?Q?kMG7LuXq1vNy31rcY1InpsCdWTCUHa5aq4cLzVisvhw9MfiDD5zz5RRfDJav?=
 =?us-ascii?Q?nbKeTPwjDD9GoyJPNDae74K3NwX9f/j0PmRhOeg2JKoGFbbZ1KbLj6WgVn3n?=
 =?us-ascii?Q?DRjqJVS6DBDkzACKJVEBzcH5sq6HZSxn9xbranJld8VycZtndKYss5KPmVgf?=
 =?us-ascii?Q?06AEeeSIcyptHC9Z7KIwZIy4NSeAcJAoKMDEOwHaZgzXcSjKzV90/v97o8NX?=
 =?us-ascii?Q?DFRqCE8p9/eKd5rSGo69xLe62RzMTFfZclomPqJGfcKSexzRqpfxORY1JirT?=
 =?us-ascii?Q?bYC713YAReW0OvExyT+MoPqVWJtV9vaCYqijCOWFw56e97LOsFiF9VNl1vo1?=
 =?us-ascii?Q?ZIG9gsEeqSQwxo6EhEeOn8X2WA5k9bZ7ZZ2LRB3K+mI90BMXCuDx0cfVqzy7?=
 =?us-ascii?Q?109mgmgqoDSGlZ0Y0FfJe5gF58IuzOi1slXBrKLBJxcUm6F3Ev2mvQSCNFou?=
 =?us-ascii?Q?kw1k4JAgwa8PLuMQpim2iprxx7o80dW6LY64lMd4buiFPRhzLKYEgEPBXzE2?=
 =?us-ascii?Q?IV1tT4RBLyoXjI99y9znXmVyEu63gRPeNzJfki+jPa+AIaT8gr+NUtFr6GY9?=
 =?us-ascii?Q?1Cgb9hHEKF+/EKIlzPAq++3yp0GsA/14BeznPyJYjxUJGdnvv2r2m6HiaEJA?=
 =?us-ascii?Q?eEpugy9UqzdJcpMfIbWvdNSWKMTfBr9rOlQjmcwZFpA5Cxk3D0xH9EjMhWTP?=
 =?us-ascii?Q?ebxkDS9soxj+FcVybywK6U/AD3ZHQ1/R8HGOCdAbEK7hbHSNxPJN94QtVv6n?=
 =?us-ascii?Q?TGYQNi21+mNnyirJOEJaioW9BQ7euT73lnCOlFwOJI+8UW+K2e36BeUw1EPW?=
 =?us-ascii?Q?TVE6YWVZhSn8JbsZEeSyOFgjxFtcDwtykPP5ydja6LSpx5mMcqFRGCvpeo3C?=
 =?us-ascii?Q?9ooL+4Tp7SAqfoa19zMl3nfyazyFIWRxwIvDjyNHWbQQYwyTDW5RyGPy8Bij?=
 =?us-ascii?Q?+CtN5y8ph+kWjqNpq7J6mdx5okp+NM0namJpUM89rxm5s34fZYWgB6iDQ9vs?=
 =?us-ascii?Q?+1phgvhFKsTg9Xb55ek+lxIZdFuN5d2ZPwPiElWzZl1jWviV49Mf2sgFpRPa?=
 =?us-ascii?Q?9Y6bHHBomtTdkbqi3qN3P7L/LEoLYC/kM7W5AYblGMIomsH4SaafqGWNOSqz?=
 =?us-ascii?Q?QmbW/rvIfEZT8WooWTTCCeArL3zAQCgpvT6jAiWLTCcimaLhmNGVNHlXmYRu?=
 =?us-ascii?Q?Di9HBbpZCg0Bt27/h+OwsTQ+E3Xrugu18JkcxAglGIAAU+5MCSlwFUTx8Y6O?=
 =?us-ascii?Q?3kb66Vj5qnzSivM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?laP4Py5Bt0LKoJIrwbKKSekAN/757xgenTFh4i57Rxep09lwcLwwoNzfDwHb?=
 =?us-ascii?Q?ZctA57yPMcZA7FKwAujdX0ylI5YKfdzzqgocCHyMYDk+sDPMUKWAA3UWbF4D?=
 =?us-ascii?Q?RGDRF7pwnChO6UWUISegN+SAX98mcB8hd9GDCKbO1rL+yREWkIozVDL1054V?=
 =?us-ascii?Q?krOP2eaIXzLq9N6qOhOcL2yA8v660YhefwPym/RdXJ/gXiCCxCx8j6J12f2d?=
 =?us-ascii?Q?uQiarNbM4R0ZHLoQqnAquKqbZsPQ0YoiNCghwrXjVAeNmiZ5rrm78mt/MWiL?=
 =?us-ascii?Q?t+EfI435FlMuNS+Cun2MkJ6UIYI7c4S391dsBKjvZqwdNyAmk9LWW60me27l?=
 =?us-ascii?Q?6hlig8ueOCWwJ2uTg3lmgt8zBJr9KTT7zIS4nkp7xruQL3qmMUjkkbj6rOVh?=
 =?us-ascii?Q?IPuu7ebN0eF7POGf61UzwhI42jQlc/9OHLxPhbZlXQxYqZYg6DJIG6FRzRPH?=
 =?us-ascii?Q?ksEk50usiEvM99VFCf4I/LkC8KNadLCFCwvw4JszjzfiHrp/PjGh+ANHthD8?=
 =?us-ascii?Q?9ShP/+LjuEJpi2TiuKCpXxaczoLpw+qeg0N20FrqMiQj731hSzX2QXNbMK1+?=
 =?us-ascii?Q?/3O8LNifePkF9WMAXmRGVZZxGbZlIL4YbmIV2KTUGDhUx5+LX6LPZs1PXLj8?=
 =?us-ascii?Q?sOyoa3RxQZwPWQkiBc+4WdCsi1gkcUJPYYC+iPcpnDu6BA9PEayaoYBxvsKW?=
 =?us-ascii?Q?ig14jKzyIKHLNeqUZfkjL29Cnrfnby101Nic83JJ1NRiLyGF/xoNRAoZBCcP?=
 =?us-ascii?Q?TWmxeS7y+o+PrrAVd4HUQsCURemeAuxCBInROsDHMlczyiWncpEuFvQ4Wvdt?=
 =?us-ascii?Q?KRNl6jRpFwrke/XcPPqec1IyR6hPS8I2DR+VooQXlqG+O10xMRSgbtg4X2IG?=
 =?us-ascii?Q?IUU6/VFEL0opLYT9ck0ZgvGU+jo46yXbV4skjmnqd/Syu12JxGgaiPC/PdTi?=
 =?us-ascii?Q?cmYJHpaoM0v63kPWJPYYq6OAmLa5GyZdDVlK3mtypxCbJJJM4DzElyLXcr7F?=
 =?us-ascii?Q?6irJH31iw2ekkL6kBdIf6hCHqM5j6KcCD98u0E1dYSkl4GU5KlsvBLqAnLXa?=
 =?us-ascii?Q?0X7HwIUPpN6sn0ByBSIrBdgnlZwN49opBPfLXpqTMvDA3xZFRXlhipXLxWHQ?=
 =?us-ascii?Q?gFqKYXQrQeAtFJV1g5lMFKlxx/RfL5jY0pgkcjRf4yesiAkGpHhnJKgUpB/L?=
 =?us-ascii?Q?jvLQ4eaQSjGxCxrOb5dwr7AXQkT0OWNzPjfmYb8KFBhildiD7LXnPaHo6DuM?=
 =?us-ascii?Q?OED0yNSVvWyi0DiiAv5CEcfIn9lKk92S+0mIlzW925L2cixfokT+ukaHNsgs?=
 =?us-ascii?Q?ThG9xU81mjAAevxntIuyU6Wyfa+FzqjvjeCXrpDMIxFTK95ZUVQKeGuGsuz4?=
 =?us-ascii?Q?Gk6yw/5tDqgx/VOpZet3X0TKFjO5PmFndnRtT+Wl5yiJ8YlI2o6ip0Vf4x0d?=
 =?us-ascii?Q?B/Aoi29b7baC5FphINenupPEk236Q5Qe0m6L+rrAQA2deErvdW09NBK7+GIe?=
 =?us-ascii?Q?+4mmQf+1E/bvK5FwkPfMWndz8OdU+5WR73KZPjInCaisJ2DGh+C2XCSxxlCk?=
 =?us-ascii?Q?Siw4sBoRNN5h2Gkl0lhngdScxfhNoCtVXzM6IYDYRIepvnOtQcMZSTbGw1eM?=
 =?us-ascii?Q?Weuj2vYtxiRORGHUG+1tW3s=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1858c89f-7f5b-45f7-96a3-08ddf61cfeef
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:04:18.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /okpRiSN3QJi/7yFi8vfAyuV4FzfqbNg3DvveobKiDqxnpF0NbWBLtBHKnCaRU0VXt8ir5Zuk/58HyjyuWTj/mGJy5GGrgfpgHenYxfxJRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8429
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 121761C0012
X-Stat-Signature: tjo4sk9epkpksdncxonffney5418ouyx
X-Rspam-User: 
X-HE-Tag: 1758136054-1652
X-HE-Meta: U2FsdGVkX1/4r4xsW8EiJw+FYSsbIdG3daFAONXjAql3nO6rz9fxo6Pmh1XF6PU7Fqv9SU3n/MS5Ov30vwOS5ZVuIW9wjjp9cReZC7cNBSLCU62fNDvGGekfQkF/P3XTxLpqBSq/akZOVUxFmFySwIHL2GA9V06YAJM/XW79ewma1NxUuYi3uCteYED6MdguHnTwATu02wueE9MoWjWYcR0R5VfMgNGS9GoxQdxJ9IS+ZJq+ShaZwp85KEZK+ZT5rXKNIXWUG5PkZVcuTy3ALwGGe/rI25If8f34qjUyKP67Ekt20rhpyKO9l/MSFjz5udM9+jMl2qUj27N0Vp1+FLYe6NU+itbDGQCD7iQnQLZXZKKUiz3XfzRJVNQ3sMmcnRPGyr/pxaCblI9AVSNbSTlBjpb1eEXY/lzD0lAj++QpKDn/OzZRzK5V9gut9HpcNu5smteYK2YnxZQIisrZ95gqfYGpyNB3zYAJLTD196dY3NH0qMos/By/Mr9E85PEOJ8JoQvMZArvMjhQAn9UTEr6faJjvX6/Ph4ljEh6E5jtz4lC0u2PUkcdW+BR1MnxPhsBR34P4wlb9o1LM4UQyCYXtrE9SdIbjpjeddtQzCKsGDgBawtIyD+rccSp3qP+89n2zUI2aI1xlreTjVcd5GMNkTteqT732imJfmVPMAmqQe+bwW4sqwLq6bDWXSZSpNSzoJ3T2ebv3pdR2BMK1ecU6uUJ1yjMwAv/SbD8yKcFRhAqkyoD75uKPiSMgZW6e5t2vyii2VpPEQlTrNuzAEPAFRirYMsSjfGLejRPE79Z7DqEEQh8A4NN1u0FRG//jyu9dGxCDR2cnY+SSbpp0exanKTKuHvxbqfDkC1CLmO25akpOUCW96fLuUNRkk5I2H1Vit4hUjPdbOMW7nwhiXaLDXVR3JKuDCtupkKhlTfryGb7luQ3gBCD1n/kC9QrYMc8NkN1O1QSTmCHL/l
 PbfcA3UT
 BR0NXFgnYgF/D+NuNj3aPqnRclkqyOb/FX8vaZX+8YPzW9PUcklgZ5/OfU5HjbEj3PTWIBTtEEjLC/vlmHgvxWhK1koziBqtRgnphM5ZLVwqN7h1bwS2ctA8kBlKF4vOoAqHJ7UVJ3MXT+RRUv/jSFL05SlEmkRxSDN+YlOjweJQPyUgRhF+kQx4zv9gOloO1xJWFUDTDNr5ICX+dtSm7pE7L4FKN1BkUsNHo7IkpM9ScgsnQvjtUlZ3DsFfMqXUk3wf8e+aY5kpXzTWNZZ6t0XWI3QE9htfR9FzecrdQZmS2NOmAkIGJ36pe1ua82rw01k9FPQlP8nAM1w/LcAVmKBV2StAVI0KvtPLcEsZEToOTPpKTFkk/LLiTSJ/j9eVZV7AfjLp3qJJc8UXCtzaB7Q0QuPUhQvVr9KcwvTUi8uN8aJldz1RWhR947BsBfdTzPFZ6jId22d91ZymR6cm+dpBUVNgvSy8xj6IDyFMm1H0uH0dGdkQmA2OAdrbREqe5hE/rofojkJqD2qpmxRnUnMRy4xIxYivkS2UxGdg0iX1z4jCmfgKuhCwF3tPDLaxaXbhvUZEJ5wO3duahP5CWmNIE1fzzP6/f9TC9z+UoXPKpjiMcea8Zn+w5exXO7NxklQBhtYZOgf5kUgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kprobe page is allocated by execmem allocator with ROX permission.
It needs to call set_memory_rox() to set proper permission for the
direct map too. It was missed.

And the set_memory_rox() guarantees the direct map will be split if it
needs so that set_direct_map calls in vfree() won't fail.

Fixes: 10d5e97c1bf8 ("arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/kernel/probes/kprobes.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 0c5d408afd95..c4f8c4750f1e 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "kprobes: " fmt
 
+#include <linux/execmem.h>
 #include <linux/extable.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
@@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 static void __kprobes
 post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs *);
 
+void *alloc_insn_page(void)
+{
+	void *page;
+
+	page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
+	if (!page)
+		return NULL;
+	set_memory_rox((unsigned long)page, 1);
+	return page;
+}
+
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->ainsn.xol_insn;
-- 
2.47.0


