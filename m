Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92463CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C7E280017; Wed, 17 Sep 2025 15:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BA5280002; Wed, 17 Sep 2025 15:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5D9280017; Wed, 17 Sep 2025 15:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5439280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:05:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72E7613B8ED
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:05:51 +0000 (UTC)
X-FDA: 83899671702.20.E775442
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020135.outbound.protection.outlook.com [52.101.56.135])
	by imf21.hostedemail.com (Postfix) with ESMTP id A3C081C0017
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:05:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ph+HcIJ+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.135 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NQFd6F862UY5IpAKymvkX8+pFFNqRJ3Mg4CYGzACdI=;
	b=6HZK/nyOel9A3MfOQ8F1Wqqlk3ZK+wE1Za+7nB+ZhnpsnLjxeOvcm8JBaYUuZzl3RxUDfO
	CbloHSNiTqxmRQQ9G8BBp2k/EtKPDyWWQegw/Fn28K/lhPEmAdKsvapbx5bMbuZ1r0lMEz
	AKrp2b/O0IYN4cQoU2u3pdv21IpcHjM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758135948; a=rsa-sha256;
	cv=pass;
	b=qVXRoNUnDvET7JafgUj3YRlQSDasquAzvhF0UA6CTbRvJzpPwu0rM8VwtE+norZoa8hc1j
	vEtlLw9SWFAtWsf7tnUH7DTqCcyFLwTEW1SeIiai8lIRdAR6Zwv7rmS71m6nBiMQtg6gX/
	WHQdaa2PlX10TiOwmp3STSxw/MCFwqc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ph+HcIJ+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.135 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OttwyP5hS2wPb29nZx6brN0mkQQqEhL3jaQEkGWHlLkj+Yh6PZ8VOBUaNUytjzWG26ti2ZTwMAUrQrG05S8f9FYYRHCsTnXyv8wQg8oaBKqUwgsdd5kHEEBM2KmS/OuUUDwyEduXfQrgQWzT35DDfKPSiJFc6f5Cgri/CCrslkVDriBwTHwczhM6OrzAvgerrTjJl82kzm8nNsreeUcpPhdVUu8xqtcQ4BttdnSFK3TKSLTyWlSSt4Lx/NPgMvZm3RMwk6mcLCWWJ8gldinbbBv7IdH0yEM7c3Ptt3R3jkBy8kLsTHd0AeskWsaYwbtOcV0epTUAURAcnuX2xL7ufw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NQFd6F862UY5IpAKymvkX8+pFFNqRJ3Mg4CYGzACdI=;
 b=KcAUDl0mR+mfH3E54CX648xOq6MhIMuxTAbEkrA3x22bh4jxZeFq5E9YrrX4N24ga4KT9orcfZYalHhZazL6ffGfizZXEQH4ttViS22HsICsspZAHmYfxpMKvsv/DODz0nMuFoDa0Q8s/TNR91J6EBgDzpfq/yCWU52O7kHGB+DZJ9mdpbM8QNC0ua3ztKFhnbV53QZaTdGulTVSbnCCUTMTZ96jy3yc/trqbhQX79Llr+v70yOeeQSyWrav1SIxq+Kf/rPYT/6v0efGiwdUONt+no/JzHmwimoSL7Bogqwqc3yO+AsXz6hK4TiV49rfY24zX5C220Y2hkRKqrrSQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NQFd6F862UY5IpAKymvkX8+pFFNqRJ3Mg4CYGzACdI=;
 b=ph+HcIJ+ajdaPwmA2WNS9kB8NYQUzsC0KTnZQl1wunS6YpQ8gM2HIl6t1eHOpsPKQpnTAM+dJshJB7AymCXprSLObge0+2CeqjcVgSExAL/HgRdJhum6mGj+Mj+kwUFZyCuakvQqT1rFaCTkQqFVJYzINLbvkERj3gnx8niTfWM=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV8PR01MB8429.prod.exchangelabs.com (2603:10b6:408:189::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.19; Wed, 17 Sep 2025 19:04:11 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:04:10 +0000
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
Subject: [PATCH v8 3/5] arm64: mm: support large block mapping when rodata=full
Date: Wed, 17 Sep 2025 12:02:09 -0700
Message-ID: <20250917190323.3828347-4-yang@os.amperecomputing.com>
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
X-MS-Office365-Filtering-Correlation-Id: 779f3472-9615-40e0-c098-08ddf61cfc3f
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KJp/RV54eu1/xfr/NeHxjuWDKN0/FVAWWH+Mj5pE8+8tofrG6zFYOIWFGKfL?=
 =?us-ascii?Q?3qBwjcO714RiBvTirY+82K9XZYtwFRnn3Ddhg+oSE4gRneHc/3ILymrrgTJN?=
 =?us-ascii?Q?l/1XqsEKsVsLOmeIbqOv649vhEFs7x+JdB3BoA6DML968RhyGVpJVqj9s0aw?=
 =?us-ascii?Q?GY9cT3tTpbJqvL02xVBr9igybMNMlvfcwXIFLSIsWYZuLnkt61q3w/hsqSoc?=
 =?us-ascii?Q?sXYDuR4JHirvq9H/f8mUlmGMaAmyK3B5CCJyV37qdWbZ8oVXNzhFwiubopcq?=
 =?us-ascii?Q?O692MZgyrw9xl7+8Zq5ss/wPZYjgDr5zwV5iqA43iVqHn5zUKpDI+YL607Af?=
 =?us-ascii?Q?qyhbmv9m59m0wGEHYE5XHRB6+nIBUUe8Nat0WAvKnluO07lC0ZR7/xUfbh48?=
 =?us-ascii?Q?kGljy5CCnPbHMV2FwymEgsPAfQ3QuMJxKNF6Wy9NhLQdi+RJVXciR+DBudty?=
 =?us-ascii?Q?RmVAY6OXzaC/wG663Wlc3MPETpEtuwtvWHWd3ybL0AYtyPw9px5X2mfHTyAF?=
 =?us-ascii?Q?0Q+nl/pxXxbq+lzd6sSx4jT68rAaru0WIAGnFRjjIRKJCnMejZyVYboK1zhO?=
 =?us-ascii?Q?3MO+BGA+B9qF6k7GQykto72n4ipKHAo+SX/tlw10e5E3wDshhGgx24dAXOo5?=
 =?us-ascii?Q?YJIXhYEX0hb9e4O9tDvRbC9J6GgpDFCYhLn83/oWtZ/UUxFqa4eas7+A7c3r?=
 =?us-ascii?Q?UprIjN+Um1uI8QXeVfyu7zC+YGZc2V3ntqHTNPdmZR89mmgD7E+be3IapDsi?=
 =?us-ascii?Q?/mMg8pDIq+oDF2dHLmsAnGzB0VwL1ZY7b2hPEB7YBu6gKDSeARs/XONhN7vV?=
 =?us-ascii?Q?Mvi6kYl4OKiBZeX51ERS1gVHppzOZB1GdIsURFSDn/RenWSqTopAmQ5j9qwa?=
 =?us-ascii?Q?cotWRvqAeUU+gelgh+skLWxfbrBm3KFlCby0EA1TFmNOVl5LmtsWtz0mXODI?=
 =?us-ascii?Q?+VCet9rYVzQiOnUzeav1/hGmRtiOKB3Qrgg2AOdT0NwBnaubUOl3jlvjRpZc?=
 =?us-ascii?Q?VJMhQBbGA1u/Y+joS7GIgUtxoWcw3Hb5bP0nvdOsOrugEduDKrABJm2g6qRL?=
 =?us-ascii?Q?pdLrNwPuoFwF6J4Hl712lq5rpECD0mM4s3mP2LEtw3RHSMHQS+xYpnRRAVs8?=
 =?us-ascii?Q?2JZfMag2JJPvibyorSRPVBe5gAbrWrp/6UCJrjGNk+yxgHoR9Yv0vS/Mouox?=
 =?us-ascii?Q?ymNBZhh7gkZtDrM4IWU763Mq8nYXgfLHVTIF8mdfiW+ey8JYC5eGM2nF2AEI?=
 =?us-ascii?Q?9CLkssqVx7exKQkXbW94oyUc7S3VVLPz0QledbBD6COixYaAAG6ah7DCdVJC?=
 =?us-ascii?Q?hidVZRsVUPMVwscPUxyZRMyme/BozGs+IsvtlXc0J7zVVe/9O3jxR7XM/FcV?=
 =?us-ascii?Q?gCVP8TRpuaBV6rWQMf/8fyTkQr03KfEKLVEsItcbThfvV1QUWJP/cmmb8AJE?=
 =?us-ascii?Q?7tt63nyP36L4H3miD6uwS9Fs6HJusdp46jl32TTOzqJM7NJHweq7+KcA68vP?=
 =?us-ascii?Q?At3/cqmN1vH3XzA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B7M5VjX6jNKNDNi5dT+oSkf08KN1MOjmrVs5XEPuryhz5GcvoIVg3F5a089E?=
 =?us-ascii?Q?PNgMVsdnwVOdZ6hdCaoOlwco6RX+7VnWom4HxKK7xkLqCOH+7p7IU3Ir+ij9?=
 =?us-ascii?Q?kfYnVzhFJJ2lP0xEdT3n3MK3YxAZh0M7W7KOpwqnIw+67KgFN83Clm0oBOOD?=
 =?us-ascii?Q?ju2KLLI9U58oYFxOEgL+ROv3ZCYOvFHxcLA3QoDRP1GsP79BsYoOgOa5vLz1?=
 =?us-ascii?Q?tHJ4ssqKrj9rMJEzA/xp2S9NGs3Ae8Vv8txAWJXi5OsuDi5xmixW5fsG5Qbp?=
 =?us-ascii?Q?bRGGk1ezlzt/rmqJigWKwOEsZI1B4nMYC2G+e23GOeaXY8yd9KY1UOYBV6Vq?=
 =?us-ascii?Q?Rm0wDcUts2brdhZBU/fo+aNHPzbDNBlaPZ5kJO549qqGUH5DM/QkR+T1qqVU?=
 =?us-ascii?Q?Q+OEc1t3x8kg7c9tdeyF/zGINzeX03tzTciEzvnG/fVrJkilRuxZLHdfpFVk?=
 =?us-ascii?Q?mBralbXzZT7vG+kqO1O0ljky4vYDGv1rlp5pK0br3dygE/HpsOgiZPv1vtgK?=
 =?us-ascii?Q?QB6nmEVB4/gQ9hT6QxQOLJFIUDeJlK0936bbIr3Xubvz7eSoDQhLIxkLnKLq?=
 =?us-ascii?Q?guWI6vEoLO60GeLYhVgOOPLhNiNhL/+C57VTAVr0z7p0x9rtf5QdzH5wKKp3?=
 =?us-ascii?Q?StWS+6glfNEjQ8hmY4ICLhKNid3cd8GwmT0CTD/suOYdOCN3A8wX60Ibmyuu?=
 =?us-ascii?Q?7qCWx7inadV2thWPQCvYKYYmxNtFO/FqkrPM+lwGBFT0nXYiODOsEy8UyNNR?=
 =?us-ascii?Q?qyeO9lul/17PzVPk/Ui4oic2KKRSLlzk7jaqlHnoXDBuwJxH9lRw9lnxK+BI?=
 =?us-ascii?Q?UOBDt7Fpx3+RxEcGVrMqu8I+E1+UIIPGmuayM0ev313m6oVeTC1w9d2RrHIe?=
 =?us-ascii?Q?8uIidXShQJmus48W8tfm8xhcqcKWOfIo88UsyKxnR1qtIIzC0qyvdkH3v1cz?=
 =?us-ascii?Q?+/+s4xTOfltah1xcIwz5hur2AoMJxc6zWBtpecks3bXrKDab5jxbwX8xqTRm?=
 =?us-ascii?Q?ow6I3y7rQJV7cn7PygtBlLNkB8yI5Qijl/Aw6OGFxxr4BBNDSPYBOxdxOX2O?=
 =?us-ascii?Q?VBkTbYH6vV1a17G1meYAIxjt6UePUnqixy7DDj66e+aZtORcQIWtxdbfx0b+?=
 =?us-ascii?Q?wfD7eL7I+FT+Dd6qBFl1kxcpGslObiY22HILIBiQLpLRoJM8YGwvFPsP4+EY?=
 =?us-ascii?Q?v2tJV650kZcrdCWBO540pwXb9pizZONtBtCAjkL444+ounqkUUVGo+7QfaMy?=
 =?us-ascii?Q?T5SyqBLQfz2PgjmWI9Q9K6L38QIAnnCAZALKj3feH0Zw31cMoXXzUNS/BiCn?=
 =?us-ascii?Q?0UH3cb4LwPofB7D4HLdurRHHr7VZImA4U9XEmfvFoReoFTOPmaxPMgiY88oP?=
 =?us-ascii?Q?V7V8GgOvNbMVudbVrWlir7AoNOwNcR6avtXln3Fu4i7EVxp8CjlkmlYXwA4T?=
 =?us-ascii?Q?0JXPdc/C6JpD+8cVRrUwUFb9iqWePql4UJ3Ro2vKXJV8uWUcVE5sj+77ZTMn?=
 =?us-ascii?Q?YkJO/egKH3J6pYj0aUy/YwCIKH9MMELNf54bLoaBOaHOxLbEFVBlsDyoO85H?=
 =?us-ascii?Q?n5AK84xPv2GZneHKI8EGjVdELufaC+/4NJ7jUJm470H72lVrrJwZhTXQqfpF?=
 =?us-ascii?Q?WfH3t3P0tn5CbvdWHm7+7KU=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779f3472-9615-40e0-c098-08ddf61cfc3f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:04:10.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oX5+HdBptRGsDK0OswfnZ5mEiR/HytG4yRE7cJfhkapNgiL5+t7TZWeuKacfyUnfc+zMXBZumR2hk5/KsgotsIntCEhVyyt+OCcTAtxCcd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8429
X-Stat-Signature: bft8ggp8m5epo4uw8qbywx8z7it78xa4
X-Rspamd-Queue-Id: A3C081C0017
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758135948-326926
X-HE-Meta: U2FsdGVkX1+acxk/altonyj7akzCtf7bZl0SZIOcRtOMN3akEXXVRhHOSoNmZOpvTZke5ogpP85RLtUOE34z9nii9UKCROGlQpeQwA88mh41JYeGaKy6DMY0bWmEUzDwUPrg9xd2AX7wMI11YFGCsmtBFFMBUDCXEi9xLANjWU/BiJhfafhX8rZWem0IHqCB9JVNgGcGSr+4qm1MyskOfDLADmWjdOl+mhgO5sTGLnF3o99d+uTAkbq8AxrqYDV+nJL9z8mjyo3AtV2+zpSesfzpnl+og2+jLWX+GcAxcov7Z75h6890TL51eM6jKnHo+SZMF5iCYeTU0L1MXYd8lTnsIFUpodXXuMKkoWn2CIlRhd1Fo68bBj3iw2IwfQpLRY8sMRavs2rh64RXabRX8ZEWW8GP5HNUEg5606Uo6GiKbmUdoFttzj74DiD2HfkT0vFWGsKiKFCpnO9SiuimQZgBgwLqe21WuclgNRM7uIUNuGQ2UsISTNwmXoiZvt2PucRWfcHcgO4VxJwaSqQHymrPE2lzAe+slh0DayHRv03VGKcfvN6u6gJxoFvZWHzjfwEqaB5InJN/tR+4JPjQKvVQvInXd9KP3Q/LyKcracM6ccWgsP6qN/1lgrKCqPHga1L5ciC+FWF65d8EQ++ARQ60c+rBuXiNSkYZE7QGfQDI8wyyr8RZWn3vsOYCaTVh+odLNL/NHpfmJVRQ0e3yL1DenWHHNWhOZDeITDaz0bKeZGWR68IZ7vJvNL+ui7GY0Wu4OmKlPm8TiLj/MfuBngcaD6t3jM5BUpXECvs5bIFon+7hUytRxwEuWXzyP2mtm9fHxN74qEa6QUj6bMjOYHsOyW/ouBWdtmLRHAmfU02Ef2UEqxunHKxwiJUlNrqgZ8rtLvT/Tvn+LCVL7/we+YQxnzjIjVZ0MuGxTJAR79+NqHoHIJQZzsdEywyVVYPATxxuAZBwC6DS3VMoNEC
 2p2ZM/2Z
 lHsymvq8biQktsx9f/jOMmKoeO3ScyrbNOI9u3bYktj58u28OTtvSNpzZBrhamU+OPKJ4b6RB8/yd4xwHNXKydedOELbf/bvNUUdKfgJIhNnIPL3OPTTCYpRTiTkXX+eQfT+MGtq7dbu8uEiiEC74M9HO6Nw/Ld1YnoRyoSCTWjKPTRTLObAWBbg1Wy1w26yRBUmXhFFEFHqz5FaXBehKDdsSZznl0ImV24zbHaLtgPjB1PQJ74lDyr+V5aQvJYuimOkoIzAHE1UPkKhj0LdP/5nB+bNUVTMGcyTnVrHgHLA3zNnuKZTHQgMfwem9e5EFZhy3kViDLiMO4Od0X7/As7CFcuS13qayCo/626JZ2Y9lS4Fk04CHSLGxtXfov+UIunFPNZEaLH9uQ2iYGhiTR8ppOGdsaNthLkZTaXjTuEH3KoK0Y73sL2cNLbiJ9reGQNy8ME3APAul6ow5R2GzF3hSHNnLIh/ShpUZLZAyxDr0h+dteMMWzFwwHjGtdZeQhSdLZQMKmSeBnTfPkWHnUIcq+phpMiLmV2qbiY3Fe6DC2QGLh5rlo/AEW279lCivaMUrFARiBQg96G6uSwovc6S7A88ek44aGNdVfxzEQ+1mcS4a2w7l0WWEkOi47xiQqOUd6DemKWi+NsidjnQdCjrgNMbvETxhseJ6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When rodata=full is specified, kernel linear mapping has to be mapped at
PTE level since large page table can't be split due to break-before-make
rule on ARM64.

This resulted in a couple of problems:
  - performance degradation
  - more TLB pressure
  - memory waste for kernel page table

With FEAT_BBM level 2 support, splitting large block page table to
smaller ones doesn't need to make the page table entry invalid anymore.
This allows kernel split large block mapping on the fly.

Add kernel page table split support and use large block mapping by
default when FEAT_BBM level 2 is supported for rodata=full.  When
changing permissions for kernel linear mapping, the page table will be
split to smaller size.

The machine without FEAT_BBM level 2 will fallback to have kernel linear
mapping PTE-mapped when rodata=full.

With this we saw significant performance boost with some benchmarks and
much less memory consumption on my AmpereOne machine (192 cores, 1P)
with 256GB memory.

* Memory use after boot
Before:
MemTotal:       258988984 kB
MemFree:        254821700 kB

After:
MemTotal:       259505132 kB
MemFree:        255410264 kB

Around 500MB more memory are free to use.  The larger the machine, the
more memory saved.

* Memcached
We saw performance degradation when running Memcached benchmark with
rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
With this patchset we saw ops/sec is increased by around 3.5%, P99
latency is reduced by around 9.6%.
The gain mainly came from reduced kernel TLB misses.  The kernel TLB
MPKI is reduced by 28.5%.

The benchmark data is now on par with rodata=on too.

* Disk encryption (dm-crypt) benchmark
Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
disk encryption (by dm-crypt).
fio --directory=/data --random_generator=lfsr --norandommap            \
    --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
    --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
    --group_reporting --thread --name=iops-test-job --eta-newline=1    \
    --size 100G

The IOPS is increased by 90% - 150% (the variance is high, but the worst
number of good case is around 90% more than the best number of bad
case). The bandwidth is increased and the avg clat is reduced
proportionally.

* Sequential file read
Read 100G file sequentially on XFS (xfs_io read with page cache
populated). The bandwidth is increased by 150%.

Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/include/asm/cpufeature.h |   2 +
 arch/arm64/include/asm/mmu.h        |   1 +
 arch/arm64/include/asm/pgtable.h    |   5 +
 arch/arm64/kernel/cpufeature.c      |   7 +-
 arch/arm64/mm/mmu.c                 | 264 +++++++++++++++++++++++++++-
 arch/arm64/mm/pageattr.c            |   4 +
 6 files changed, 277 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index bf13d676aae2..e223cbf350e4 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -871,6 +871,8 @@ static inline bool system_supports_pmuv3(void)
 	return cpus_have_final_cap(ARM64_HAS_PMUV3);
 }
 
+bool cpu_supports_bbml2_noabort(void);
+
 static inline bool system_supports_bbml2_noabort(void)
 {
 	return alternative_has_cap_unlikely(ARM64_HAS_BBML2_NOABORT);
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 49f1a810df16..a7cc95d97ceb 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -78,6 +78,7 @@ extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       pgprot_t prot, bool page_mappings_only);
 extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
 extern void mark_linear_text_alias_ro(void);
+extern int split_kernel_leaf_mapping(unsigned long start, unsigned long end);
 
 /*
  * This check is triggered during the early boot before the cpufeature
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..aa89c2e67ebc 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -371,6 +371,11 @@ static inline pmd_t pmd_mkcont(pmd_t pmd)
 	return __pmd(pmd_val(pmd) | PMD_SECT_CONT);
 }
 
+static inline pmd_t pmd_mknoncont(pmd_t pmd)
+{
+	return __pmd(pmd_val(pmd) & ~PMD_SECT_CONT);
+}
+
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ba07eeff2a8d..7dc092e33fcc 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2218,7 +2218,7 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
 	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
 }
 
-static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int scope)
+bool cpu_supports_bbml2_noabort(void)
 {
 	/*
 	 * We want to allow usage of BBML2 in as wide a range of kernel contexts
@@ -2252,6 +2252,11 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
 	return true;
 }
 
+static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int scope)
+{
+	return cpu_supports_bbml2_noabort();
+}
+
 #ifdef CONFIG_ARM64_PAN
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 183801520740..fa09dd120626 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -474,6 +474,8 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
 			     int flags);
 #endif
 
+#define INVALID_PHYS_ADDR	(-1ULL)
+
 static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
 				       enum pgtable_type pgtable_type)
 {
@@ -481,7 +483,9 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
 	struct ptdesc *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL & ~__GFP_ZERO, 0);
 	phys_addr_t pa;
 
-	BUG_ON(!ptdesc);
+	if (!ptdesc)
+		return INVALID_PHYS_ADDR;
+
 	pa = page_to_phys(ptdesc_page(ptdesc));
 
 	switch (pgtable_type) {
@@ -502,16 +506,256 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
 	return pa;
 }
 
+static phys_addr_t
+try_pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
+{
+	return __pgd_pgtable_alloc(&init_mm, pgtable_type);
+}
+
 static phys_addr_t __maybe_unused
 pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
 {
-	return __pgd_pgtable_alloc(&init_mm, pgtable_type);
+	phys_addr_t pa;
+
+	pa = __pgd_pgtable_alloc(&init_mm, pgtable_type);
+	BUG_ON(pa == INVALID_PHYS_ADDR);
+	return pa;
 }
 
 static phys_addr_t
 pgd_pgtable_alloc_special_mm(enum pgtable_type pgtable_type)
 {
-	return __pgd_pgtable_alloc(NULL, pgtable_type);
+	phys_addr_t pa;
+
+	pa = __pgd_pgtable_alloc(NULL, pgtable_type);
+	BUG_ON(pa == INVALID_PHYS_ADDR);
+	return pa;
+}
+
+static void split_contpte(pte_t *ptep)
+{
+	int i;
+
+	ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
+	for (i = 0; i < CONT_PTES; i++, ptep++)
+		__set_pte(ptep, pte_mknoncont(__ptep_get(ptep)));
+}
+
+static int split_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	pmdval_t tableprot = PMD_TYPE_TABLE | PMD_TABLE_UXN | PMD_TABLE_AF;
+	unsigned long pfn = pmd_pfn(pmd);
+	pgprot_t prot = pmd_pgprot(pmd);
+	phys_addr_t pte_phys;
+	pte_t *ptep;
+	int i;
+
+	pte_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PTE);
+	if (pte_phys == INVALID_PHYS_ADDR)
+		return -ENOMEM;
+	ptep = (pte_t *)phys_to_virt(pte_phys);
+
+	if (pgprot_val(prot) & PMD_SECT_PXN)
+		tableprot |= PMD_TABLE_PXN;
+
+	prot = __pgprot((pgprot_val(prot) & ~PTE_TYPE_MASK) | PTE_TYPE_PAGE);
+	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+
+	for (i = 0; i < PTRS_PER_PTE; i++, ptep++, pfn++)
+		__set_pte(ptep, pfn_pte(pfn, prot));
+
+	/*
+	 * Ensure the pte entries are visible to the table walker by the time
+	 * the pmd entry that points to the ptes is visible.
+	 */
+	dsb(ishst);
+	__pmd_populate(pmdp, pte_phys, tableprot);
+
+	return 0;
+}
+
+static void split_contpmd(pmd_t *pmdp)
+{
+	int i;
+
+	pmdp = PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS);
+	for (i = 0; i < CONT_PMDS; i++, pmdp++)
+		set_pmd(pmdp, pmd_mknoncont(pmdp_get(pmdp)));
+}
+
+static int split_pud(pud_t *pudp, pud_t pud)
+{
+	pudval_t tableprot = PUD_TYPE_TABLE | PUD_TABLE_UXN | PUD_TABLE_AF;
+	unsigned int step = PMD_SIZE >> PAGE_SHIFT;
+	unsigned long pfn = pud_pfn(pud);
+	pgprot_t prot = pud_pgprot(pud);
+	phys_addr_t pmd_phys;
+	pmd_t *pmdp;
+	int i;
+
+	pmd_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PMD);
+	if (pmd_phys == INVALID_PHYS_ADDR)
+		return -ENOMEM;
+	pmdp = (pmd_t *)phys_to_virt(pmd_phys);
+
+	if (pgprot_val(prot) & PMD_SECT_PXN)
+		tableprot |= PUD_TABLE_PXN;
+
+	prot = __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
+	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+
+	for (i = 0; i < PTRS_PER_PMD; i++, pmdp++, pfn += step)
+		set_pmd(pmdp, pfn_pmd(pfn, prot));
+
+	/*
+	 * Ensure the pmd entries are visible to the table walker by the time
+	 * the pud entry that points to the pmds is visible.
+	 */
+	dsb(ishst);
+	__pud_populate(pudp, pmd_phys, tableprot);
+
+	return 0;
+}
+
+static int split_kernel_leaf_mapping_locked(unsigned long addr)
+{
+	pgd_t *pgdp, pgd;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
+	pte_t *ptep, pte;
+	int ret = 0;
+
+	/*
+	 * PGD: If addr is PGD aligned then addr already describes a leaf
+	 * boundary. If not present then there is nothing to split.
+	 */
+	if (ALIGN_DOWN(addr, PGDIR_SIZE) == addr)
+		goto out;
+	pgdp = pgd_offset_k(addr);
+	pgd = pgdp_get(pgdp);
+	if (!pgd_present(pgd))
+		goto out;
+
+	/*
+	 * P4D: If addr is P4D aligned then addr already describes a leaf
+	 * boundary. If not present then there is nothing to split.
+	 */
+	if (ALIGN_DOWN(addr, P4D_SIZE) == addr)
+		goto out;
+	p4dp = p4d_offset(pgdp, addr);
+	p4d = p4dp_get(p4dp);
+	if (!p4d_present(p4d))
+		goto out;
+
+	/*
+	 * PUD: If addr is PUD aligned then addr already describes a leaf
+	 * boundary. If not present then there is nothing to split. Otherwise,
+	 * if we have a pud leaf, split to contpmd.
+	 */
+	if (ALIGN_DOWN(addr, PUD_SIZE) == addr)
+		goto out;
+	pudp = pud_offset(p4dp, addr);
+	pud = pudp_get(pudp);
+	if (!pud_present(pud))
+		goto out;
+	if (pud_leaf(pud)) {
+		ret = split_pud(pudp, pud);
+		if (ret)
+			goto out;
+	}
+
+	/*
+	 * CONTPMD: If addr is CONTPMD aligned then addr already describes a
+	 * leaf boundary. If not present then there is nothing to split.
+	 * Otherwise, if we have a contpmd leaf, split to pmd.
+	 */
+	if (ALIGN_DOWN(addr, CONT_PMD_SIZE) == addr)
+		goto out;
+	pmdp = pmd_offset(pudp, addr);
+	pmd = pmdp_get(pmdp);
+	if (!pmd_present(pmd))
+		goto out;
+	if (pmd_leaf(pmd)) {
+		if (pmd_cont(pmd))
+			split_contpmd(pmdp);
+		/*
+		 * PMD: If addr is PMD aligned then addr already describes a
+		 * leaf boundary. Otherwise, split to contpte.
+		 */
+		if (ALIGN_DOWN(addr, PMD_SIZE) == addr)
+			goto out;
+		ret = split_pmd(pmdp, pmd);
+		if (ret)
+			goto out;
+	}
+
+	/*
+	 * CONTPTE: If addr is CONTPTE aligned then addr already describes a
+	 * leaf boundary. If not present then there is nothing to split.
+	 * Otherwise, if we have a contpte leaf, split to pte.
+	 */
+	if (ALIGN_DOWN(addr, CONT_PTE_SIZE) == addr)
+		goto out;
+	ptep = pte_offset_kernel(pmdp, addr);
+	pte = __ptep_get(ptep);
+	if (!pte_present(pte))
+		goto out;
+	if (pte_cont(pte))
+		split_contpte(ptep);
+
+out:
+	return ret;
+}
+
+static DEFINE_MUTEX(pgtable_split_lock);
+
+int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
+{
+	int ret;
+
+	/*
+	 * !BBML2_NOABORT systems should not be trying to change permissions on
+	 * anything that is not pte-mapped in the first place. Just return early
+	 * and let the permission change code raise a warning if not already
+	 * pte-mapped.
+	 */
+	if (!system_supports_bbml2_noabort())
+		return 0;
+
+	/*
+	 * Ensure start and end are at least page-aligned since this is the
+	 * finest granularity we can split to.
+	 */
+	if (start != PAGE_ALIGN(start) || end != PAGE_ALIGN(end))
+		return -EINVAL;
+
+	mutex_lock(&pgtable_split_lock);
+	arch_enter_lazy_mmu_mode();
+
+	/*
+	 * The split_kernel_leaf_mapping_locked() may sleep, it is not a
+	 * problem for ARM64 since ARM64's lazy MMU implementation allows
+	 * sleeping.
+	 *
+	 * Optimize for the common case of splitting out a single page from a
+	 * larger mapping. Here we can just split on the "least aligned" of
+	 * start and end and this will guarantee that there must also be a split
+	 * on the more aligned address since the both addresses must be in the
+	 * same contpte block and it must have been split to ptes.
+	 */
+	if (end - start == PAGE_SIZE) {
+		start = __ffs(start) < __ffs(end) ? start : end;
+		ret = split_kernel_leaf_mapping_locked(start);
+	} else {
+		ret = split_kernel_leaf_mapping_locked(start);
+		if (!ret)
+			ret = split_kernel_leaf_mapping_locked(end);
+	}
+
+	arch_leave_lazy_mmu_mode();
+	mutex_unlock(&pgtable_split_lock);
+	return ret;
 }
 
 /*
@@ -633,6 +877,16 @@ static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) {
 
 #endif /* CONFIG_KFENCE */
 
+static inline bool force_pte_mapping(void)
+{
+	bool bbml2 = system_capabilities_finalized() ?
+		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
+
+	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
+			   is_realm_world())) ||
+		debug_pagealloc_enabled();
+}
+
 static void __init map_mem(pgd_t *pgdp)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
@@ -658,7 +912,7 @@ static void __init map_mem(pgd_t *pgdp)
 
 	early_kfence_pool = arm64_kfence_alloc_pool();
 
-	if (can_set_direct_map())
+	if (force_pte_mapping())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -1360,7 +1614,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
 
 	VM_BUG_ON(!mhp_range_allowed(start, size, true));
 
-	if (can_set_direct_map())
+	if (force_pte_mapping())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index c0648764c403..5135f2d66958 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -106,6 +106,10 @@ static int update_range_prot(unsigned long start, unsigned long size,
 	data.set_mask = set_mask;
 	data.clear_mask = clear_mask;
 
+	ret = split_kernel_leaf_mapping(start, start + size);
+	if (WARN_ON_ONCE(ret))
+		return ret;
+
 	arch_enter_lazy_mmu_mode();
 
 	/*
-- 
2.47.0


