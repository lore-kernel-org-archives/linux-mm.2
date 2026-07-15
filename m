Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67BCC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C226B00A3; Wed, 15 Jul 2026 14:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214156B00A4; Wed, 15 Jul 2026 14:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03FAA6B00A5; Wed, 15 Jul 2026 14:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0A726B00A4
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:06:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5835016026D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:08 +0000 (UTC)
X-FDA: 84991790016.22.E6E0FCE
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020141.outbound.protection.outlook.com [52.101.201.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 78BC420010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=dvGpYiPV;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpaTpdar5NmCn6KDifPZIoCGv+BUoPNwYtyDeM8tyOQ=;
	b=M5XRZueVXCtIk1tLVlttK5pU1/w5MvNI1/gY7OpTkVTbuJ9+YTkugTAwnmatsBH9vnX8uW
	nV1UHCc0nzi83Wr6JhXxgrYvcnD9N1JvgsVeo9nLeAuyD1iuMS5g3VsGQQtYJ7qFP3JXJf
	tyinH0/XQ69uUa8b5jjMNvZJ9MMetOM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=dvGpYiPV;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138765;
	b=o1nROMFTkBBZeNTZUK4eSNnnw7BmswpADNuiLZvIjHJD6G2dWqXl+zGzkKS2Tkef5iXFkd
	Id88B6iDuNt8YqyJXskRjjSp317bSBFA86MQj9Sb5Ppm3sSXSHQ1stDNDwpYvZRyZ1E0ws
	T9s+cvyY8+Dd1mNslAXKI/9+AC0ypjc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1hJbx0H5xPh0gswX9vlaB2Uuo2ZVVsMJkmjW8vH6wNswhhXeCCEaV8OC6AeRClW4C1QNkf25xzvbiab8OLkcZK0/oGz/LbOqIr2QUElbdEB3ALLwvi4pP2ni6QAuhQCNHTDULRbjKAmH0bwLM3oqrIZIgPTDcn5P+WZ6tfSZXivz7LBxeOboSFudHL9VxDAo0drxlq+e79TqQfCkKENncwA/3ufJ38ofqc5j2moYPYq5yyFDm4hGOAokkr8vumew57uEjs8Ag6lc/BBlVl2YXFiG4VnUmzT853rFWsgfmEtEjddBzhIoSeSou4vqLENb/n3rqHDPPjXdk58wSW1bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpaTpdar5NmCn6KDifPZIoCGv+BUoPNwYtyDeM8tyOQ=;
 b=YxEjHtD/ORa0pk8+g8lRPqbuAo6e+oWCb6o86L8SzzH9UMeW3Y2Z5Cxh/Q4bQmSNREYuYxPCkuDBYvqWZJ7NMmDnze3ucgWZDfliWFkay3ndaaZOr7jEKQ79aICZxSmGBGwWTEkcrYN9Ph9D3L05lANzW83nxJiTdhoEoVMZH4hRNerGcWi6UzshWeKV4Vf+Ql2rh7CLbOxC6TeQ7O/9c8sHGZ8Un6PBbkGarVT079lLsO6iNAtMoGObfbOYOwWamU1gx+oSqQZduBbXv+3UREyFF+nOpuDvCzVWmZQ1xrlTSrZtR8nQh0u6fC44TT04FyCiIEIXRR17yRZIakC26Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpaTpdar5NmCn6KDifPZIoCGv+BUoPNwYtyDeM8tyOQ=;
 b=dvGpYiPVywlL2zHHNhQB++U7y5TE4Efge/wqlQ0NQH2y88JhbTwCojiXrL2Iy+iqDAhXELMBStqc6azIO3QE2uYQaQNeub8yOQoEtBGBlPNKGjGKKzkMoH0mmI4PMVs1fqJsj8BimyO1bt1N8oQ5o4igwqBNFNiWONuowODVuig=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:51 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:51 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] arm64: kconfig: select HAVE_LOCAL_PER_CPU_MAP
Date: Wed, 15 Jul 2026 11:04:17 -0700
Message-ID: <20260715180455.515692-16-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: ae6172e5-7a90-445c-9f29-08dee29bb4bb
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	Re9mHU3BS+kL/MeXeXlTBcQPME3ja3FPtdC8Uocrxx4D8wKbRL8wigsyY8OK2+dNjHbO9CsDeWRZSI/rfb0x0qOyyYf4u2aB3jPDXytY0aoSNaFGM9ixevnCuROGpgjsIlQtJSpVlHqPc8/6edMuodfjBwPzdeZQ32xnXJl31GagNI/mPz5dO8qobS6M3dAWODWmaQUBk+havdLF7gvca0VrEvCj/2tU+ul+eDm0XHLG2w2ui1eR42/pXEzmQpSH18voxUTNBWrT6LEpk8a/wf/MDg2hzxmsmX/w8TcrJiDI58fuyD8RwwglK3+Bl5EQkkf8BNXaRYtxqswDcbRvCeht9hgnhRPCtrlIV6d4fNGBDxfcRSavYoNu79a/XCzhH1t9wHHXkxKPP5gsEChc08fNNTOUPKhwXohwZdB6kyJjwmTR20toWKWLfGkG3LrLUvfTVIrVKe5ECDaEkSHacgtwq8ptL+nQaqTRbS/0GkZepjJsuXESmCl7ygA0sAoFPRFe0nfYmvmPJCL8omnyg3PNhryfcoYweAlyb9ji1z4znn5kgtBdcI+GCzbfl5iomgD3t+Rpx0D5B8q/mARkn4yo4QJ8uMne89a59J3HE+/pdFSZzTk1x9Ly7OFkQNM3F9I6757fcghBVu8z5UAcfbfBbjVzph0UXaUNYYF18E8ps0Bm4a5qFaQLuXaSYx2UMJoKMBHDo3iYFQMm7p+D9w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8x+/HOtolt31i2OGfFuBtzNf+vV290Ccf22gpVKWTW6KEGyNZhN47rduwu1n?=
 =?us-ascii?Q?5ha5W0aNsmlcCj3HTTluMdjuoBaV+eQ7MQuk1bTw5wVxaeMQAzq3fSgJ6w7n?=
 =?us-ascii?Q?VYf0sPMkefePaDr5R+giEM3j+TYa2n3mIPoCD2VCVgDMWdcRzQE4U41i1i2R?=
 =?us-ascii?Q?bkZym31EC2Jd/Y4Nh9+OFbVZfbSS+SW1S/zDybelpIEtsHCxT9SD6Vc9Ifjt?=
 =?us-ascii?Q?E8xrQaI6tnMZr4kVeHSz1tE5Q+juS1WuR2J+ZIWFXa1Gz/DNUQhVtMdeZYp+?=
 =?us-ascii?Q?oXQyQ47+s2eUBsMiGkasS3RnBkvpICsjlaxK4f11MFQ/8yrI/ypJm/zjCrJi?=
 =?us-ascii?Q?r93LSuNrM6xA1HScWADV6naIDd9kLvaV7XHDwi6Qi9KqKwuoK3BtTKHgKf0u?=
 =?us-ascii?Q?UB1LMgh5QPEykIaVvPMvGHofkFRn1siwTYFgG2Pzs1WJjusAwrSsnbTi9dUl?=
 =?us-ascii?Q?QXVq+dzpA5Wupr+MFRk78x/qtr0i8OsYhmxSWJtRYiAK9XtMKRTXsY0fOYfY?=
 =?us-ascii?Q?TxKJvd+GLok6BGr5ll3uB25UhXvDL23jr95j6jtrjtoXk/qlHx0niqRdqgto?=
 =?us-ascii?Q?M4a8mPRJfuhpArJ4uQQ4SLnVEgmJyh+qnpuihweq6Mv89NlUObVXd+MXM9R3?=
 =?us-ascii?Q?8LvRxllIWaSgjWmoZYppA7NwlV9pC5qXBIqRpT8B6WL2W3qAjMAdRV/S+koU?=
 =?us-ascii?Q?1DD426sm23ibxVVTDuV0yta9QhHRLWOghUNejfZCticukaSHGbZsQCd33h5y?=
 =?us-ascii?Q?9GA4dhX5t6hAU4HfdG1iNoSGtOFsRRknz//Fjf6+lQtIX4IBfZFbBTac9/64?=
 =?us-ascii?Q?tvNAFE4fnQeMG/KMNTvSt9BJekqbouGyj62vYiydE/w9qKnwjOkZ8EdTYIuj?=
 =?us-ascii?Q?uQPY/vOabOX2/OYJftDV9KtdSKAk48Jts6RhrACA79sEJyKVUlkh9BlpVvar?=
 =?us-ascii?Q?X5FxDWQYd033h965X7r3YbEdC8NBe3RAvjObtsEWjZQ+v9BtduD8BNeN8l3Y?=
 =?us-ascii?Q?wC4fz6AIlK7A//kSS/ejNf2Lq5G4OKbnqB1VUHquLIXDtDEKOY6itYsOcAqZ?=
 =?us-ascii?Q?QvwychLGkBhY512fEhXTmhQ8vh9KsIdvq0LEqRUPgClb3m4hsTd1z5HQ+uty?=
 =?us-ascii?Q?VYmcvg2veGk+0FwsyfXqT9Tvv1fi8nS/CgGz3UQ3m0gZFNUWCP+GLcPBYr8Y?=
 =?us-ascii?Q?/dCDzs8psCixqgtTN0kcBWgLReFNMdnltgkmDf9mbEpfAqIcw0k2ADJ0guOj?=
 =?us-ascii?Q?E7n+qVTm15UOn5U6e6djzddroUKh2+cjgXAbMJc9RTjwQ9NCc+MytGfTxTjE?=
 =?us-ascii?Q?SQSBop+srj3LJ5ikR/4r7/Hd7jmmMpHbr9oaL+AZPRql7wWpWS6lJperrlCV?=
 =?us-ascii?Q?CIbzkPf29Yd5LVKTwtVFX0qYF1axPKzvIRLLQP0Bw/BQmhMoONxZd9SuwC3j?=
 =?us-ascii?Q?mkbD9J177+fd6ArC/RAE6hyIujYoicO9KiZKnMANvCHENgkNPnJwqikTXsHa?=
 =?us-ascii?Q?6WUHu2FK4GAG/Fyq7tXL3O/ms2bYo+j627wlxGGEBAyTHy9F8iFmRY4gnBm3?=
 =?us-ascii?Q?mV1dLZv6GMVyUNSOsTSGxKK25QP7oubuhsZF6b5prRdxcqj+Yey8EgAb3yBG?=
 =?us-ascii?Q?ZEI4lPu+JNXnNHMmzfGNmPZtC4NQDK2REHbIXvRd+kMMEEM+4/a1WSEgtcrM?=
 =?us-ascii?Q?f0G4zM/GWfqHZpPMIOE0yYc9we5RCpIM2Jq25U+KtVdz1E3eLbKFgqIfe/BX?=
 =?us-ascii?Q?BKgVr8OxX9Ko3/Ofz0XPhlMgDPjTj3Y=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6172e5-7a90-445c-9f29-08dee29bb4bb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:51.5077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InASsdjKg1A3e4RsMCaX8w1kZT7het6FeFfB/SHJceVsoNpREyLMiGnZD5MpLskX/fiCLY8N+iA4fwKnaBu4ghSVfWWG3BtNvYTjvbO861k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspamd-Queue-Id: 78BC420010
X-Stat-Signature: 6rmtc58yb5ytnw7wkkgbmsernreb95m1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784138765-779953
X-HE-Meta: U2FsdGVkX19GgecFiK1o0mx5hBErjMjGffLDrazqv6qrL53ioR1uYffZqIJZLo+UqVJUdXIEl2Cdz41OMGfIonyNKUfwlQ5Mwk1vNi4Yu885msxCqrbHmleCeArXg53zCekcDO6xcfuYKvKL5Fzh2MGbYpdaGsWo1brmTuO77QyhUcF5T8yD4woHs3J0JXZ8VdV/CIMLXM0gwS0ogxFEygTGYctGwGiHYjm3QEW0SWAdfK8krZwCwdvC3QZF0TE8yREMyR0ApR57l8r7ApmJbbLgQKvpVGX7FHku6MX1G/Cw21QdutcSSbDsMaBAKBVnryz8RYlrF6RoNuUr3tMouP4p+XiZA5CPBpq8xAlPLPi2K7BCNWofz4LbDd/MCD8SUgbYEDnT7nP75FG4U4E7Nq/pRIAEvb+SaA0enVd5NIsrIC5gwuBFazyjF+8rO0rt5Bszhr31hVPeiUMshSF69ojeDEwI8McIbu/t/ODPkZtJ6Mbds8YAzysVDkSXxxKbyayepOD3lmr16zoMsLS1OGvnqwO+AB8DzRGw/ACulJRc4I3auFfl1u39HuS9c3nPE1DGjMww46/0zSx4veTwY0NxaRDf/7aXLd3ir553wF0kRUJzW5wn60IyEKeN7J51dM7FIGyahwzPaaEDlZ5MACIN6B6/XtqSylz2AGNaxeNBHqoejw8N357nxoVaut16PyWyOcTrTw7HY23ehFEgQF9drstVDi9K7diJ+KU8IOCWUODu1ys++Kf+ARZNQMFCMEEnk12KeXZ0B9tDgvU5apmfiUfyAD1OUb+bzxxS/jPnv3hgyv7tkUJ7UqAxs2SnubwUHlZfKRfXCgFh3WuloyNFGjt5QiFMtSF7Jcoc1XVyjhmX6CUixlrkGGq2rqz4soK5A3Zy9OvDnN2rZuvocd43/UUqozgPRND2FA0bgWqpiKKXEV0Vg3uUzF4Pe+QtZ97Y7KbwUg2nJLqprM6
 C/P2P5HQ
 xjKze4cUlSP1119t+IKs8ZFjcnW5cRPYLWZddkCKQOitX1A89eWwEZMrBMBR70gK8VJt9os/KDkEUg3gMi8Elxi8xX2STB7pXq4hu+JPJ76qXRzh2Q8/f6mqiuZFCJML7FBMSpEL01iwidnmtBviE9ZDk44LA8PF7vriIOuG+KNIwStSaV9IwY7idWqN0nJmNG1FLi4q+FNEfCuZ9/H7sW4EBsulY2AVv4UKe7UNoGV+R7pWKQeRpkxO/cnunGHqxBMS/GhGA2RvLSZH2LVVEgXuhq+zLdbDgZPLRq+ViEQifu0mQ3uilOU3NgvXdtoOszlRTCQFW6+OP3i8TyVDKjFM8K8Jjw67TI1BCQlIif6KUFDjxmsNACFDo9nevSOpEeaCvr+9LIyoPoyCombZ0FgZDY907yxIsQgMu18rKXk76xut/JkdHegMLpi6maZLvjMB0XqMsoMBOZu/83P7EkZzbF4DqT7w80M1BKsEcyhahdfcrBW1OqzbXfBVb3kuIu2f/NSTHOKfN2kjJoc2RdlRstsgrw37hABlKoOgYFDaS5Q5i9+eDp5Szbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARM64 supports local percpu map, so select HAVE_LOCAL_PER_CPU_MAP. But
it depends on VA bits and page size for now.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index df55e6bdf81f..95ffd151187f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -415,6 +415,11 @@ config KASAN_SHADOW_OFFSET
 config UNWIND_TABLES
 	bool
 
+config HAVE_LOCAL_PER_CPU_MAP
+	def_bool y
+	depends on (ARM64_VA_BITS_48 && (ARM64_4K_PAGES || ARM64_64K_PAGES)) || \
+		   (ARM64_VA_BITS_47 && ARM64_16K_PAGES)
+
 source "arch/arm64/Kconfig.platforms"
 
 menu "Kernel Features"
-- 
2.47.0


