Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15187CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF626B0095; Tue, 23 Jun 2026 07:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A2E6B0096; Tue, 23 Jun 2026 07:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738216B0098; Tue, 23 Jun 2026 07:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 440FE6B0095
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:15:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96D568E1DC
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:56 +0000 (UTC)
X-FDA: 84910922712.16.02F2EE5
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021092.outbound.protection.outlook.com [40.107.130.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD72AC0009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="u/iwYlkt";
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782213353;
	b=MVcYpkMASUhFIOC6thJSYZnJNudh3S1ohg+1n20tBk/7scBBia6LCTMqQ9zvGwoj6R+c0p
	ehdeXdU4RUpAC+60u1jYtVcdgG9pdSeSpCW5YiouRwZ3tc//BhIGCC+30KWQnfEvrDSF7D
	tuAU5WR0Tah1KXk8jg7mgOUOxCKDT1g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/ev9EwvfWfwYWYe4nc52tRKn62J1UMDqMCfRo2z74M=;
	b=DnnGyyZzHRfuUb20rSh/pHOZLm/5kTCUUPc8HXGsQ4FShwm7Yhw4dKiLET3sYdXDE4SAOJ
	XdEZfB7ZgCJSX8789sI4t0M7sD9s3sls0aZH177f08kCIWf1+1iBT4gEpbIo8aMYJ+9ujq
	DzzFC9On5NVBgH8R7yKSiDXaoKn1XQo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="u/iwYlkt";
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1cB4oGidK3EmpE+mDCd0SipD5AEuzMgZamJgufUP31ppVdoX+TklSDnTxmA9gkHYyzc+d7+olR6HbXHthE+2FMBMpjCowfJbmJEeJKF5R/W7HGCeRsuV0Dw0dn7rBc82AvrP4MDw2MVuXqGJKN7XRREK2P2R6w+yaQimlflGsSe0jcg8XP154zLR6v6pXCszPUclXrdHC/xkey0nYGv23ACpnTBJVuW1lTz9/PKQZmpJBtgbUj8woSe9/9lSNNYFs6gcataRbrRwaZPqvRdLAIgPBi6E6VDY48utInAQZxOmIRnsZ65z8BD5uk0s225oSHBzwadTgsiLpRJZgKtqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/ev9EwvfWfwYWYe4nc52tRKn62J1UMDqMCfRo2z74M=;
 b=s/pE7Xr6gqKR0e7sTelBAOr2R/nI/gCWepQGjUEsHURXaxKjexfFOMZSGZ6nEBOtm+6Hc3tMp+BUX93PIsHK3Ly/bd4oNIL6Hoxw2d/+/TAISDTprNgB68ImrjFr2JhuQxUGcBcH9vDl/L2KlOWsy8U2pDOck20zfKfLZf7y77x29sDr7JsfiWBSBmzP/mJNjXPGlkq88c2QeI+IyQZvhiZaCE4SuqoIckwuLY+CwFIKHVr7ofn7Mycc4sPZBXOE4verusigXA16UKJsW3t9b9q9HsFj7kn2mINeN3u75HTTeQTK1P3Po1TBVSzieKJOnqjNfgf2UYqueLwPEYfKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/ev9EwvfWfwYWYe4nc52tRKn62J1UMDqMCfRo2z74M=;
 b=u/iwYlkt2wJYFyX7ZSWWphARpyV82pDQ3FwYJp45VM30LcYCXqI7lww6lUWWi8V3bshprjCkwsbs71LLlPKhQI9BC97+USaKrZIjECngocObnBBBxAGINLRb5r38GacKEqt6cMDiqC9Vdh5Im0X8xRiAPn4gzHmNQ+iIKQIyqQF8Lmbk3zMGCDymQIeZWhJ4K0bllLr4gaaWnOVBmD4qCh3juZEY5KcPYK3ozRnuPgJFJmQBrkm1SXx8J3NniLcHla3kM0H1Ubi2VTiL47RyX8OMv8E8wVlZdyZO8bbm2iN1Y5YRcottXDN3hEbJJtJlTk8lYfX1a/WWgboncwYaFw==
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AS2PR08MB9974.eurprd08.prod.outlook.com
 (2603:10a6:20b:643::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 11:15:46 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:15:46 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
Date: Tue, 23 Jun 2026 13:14:49 +0200
Message-ID: <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|AS2PR08MB9974:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e77047-d577-484b-ee2d-08ded118c5b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|10070799003|366016|376014|7416014|52116014|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vVO/fOeVP0vhrOgHiiQjkjIi7y6WtFY5gtOT+KeIDwUNWSFnGZFyzmvKwiG+eP7RZhwiKVfmsrU6dM58MHneWrO2TNUr6VIJI/1nXb1pdJJscgNdzjsE2RnB5lKXZTcK3RIqGzDcGpv3aiV9dmfpcWcSG+zQbsXkaU0XivRu8B/TTQPsFtuDQs1UDp9s0BggU2kGVzTEgH4enReeUlpKM7VA9+m2MGN5XpLuusbhyHvyBE5EK/wfDTa0mqXt1B7/bWwlYQ+xh8AIYM/7bx7AIkUnjNxB/+Oes0LaEbwP0U7M4rXnZr8hBTeIZ2mXtDV7ET/Ln8IACD38ag+L4UbugzqPXVzGhYS0hl/gDfBHMj3WDAoMY8wp4ajWm+wBpuLxT2+WSXpc4c1ao/43oybh4HZ1dYqDHXQxwsnVy++aERvBqk0AcaojZQjpsY9IaCk0+fjs3agRTJd3egho3VxZTkEsRgvcy3BGcsg4w5NpOCrcAHwHXf5M2MINl+/uMmJG7/JfZ5VUebBrww+puN++dgCOHleoHi0aTb19ytfy+BgvnbuP/KNafsR6FSo/Pvb5VQCQZmYAfj0Kje/4jlz1T1FGErsvUgEtY9M5T2bI7dnhrrkAe+HWGnaK/Aoo7m4Bb+YlUFEFlHcGzl/lJIqcNxsl7GESc++ieaUWNN3hj7A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(10070799003)(366016)(376014)(7416014)(52116014)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1TzjpGktSypNXfVAlnZ3X1n7ruP8/1UrDa+WHhXb6sJBvK/37zEnpn0oqClu?=
 =?us-ascii?Q?FgohrJ7lFKT/CQmTzDHLysKbXaBlNwf/ukCYPgNzKWo5/EoaVVBsoFK4E5E0?=
 =?us-ascii?Q?5DuB6A/Z91WyOBUi8DMlS9oS8ClfPGidugFkMumRh6+EfaSXZ/8U9vFgLK+X?=
 =?us-ascii?Q?KPIX+fQq+qnz3E1IMlQYrEQg5OUyw9210r7oxTx9Wn4R5jEngLs9wPv2DMKU?=
 =?us-ascii?Q?B/p4l5VRLUm0LNM78AolKEsKp6tjippDUVGlV5D7WoT2rPGKqt4hZrr4ikyb?=
 =?us-ascii?Q?WE95zMVThM5TxbLUt3tcYxzu880s8CecjarXrg5m11n6VipU7OtyxxjbVtAl?=
 =?us-ascii?Q?d7Tz9tD+esvQqSl8/9gKLJL22oAXQjbjuH0uw0CNLbLIA/gvTS6aBpx8rpgq?=
 =?us-ascii?Q?uUcyjZEXWX+obxcxks4gx6C2GGS81djbiKywCMYVHwkREsTWchr7fd90kU5w?=
 =?us-ascii?Q?njR8FGR90J9rudhna6Pl+2Q6kF6FKaVKzF7ozq4Vo37zli0foJHCD9a/6RoI?=
 =?us-ascii?Q?ZyR/LHeCu2syiCPTQVHJUEWAv331qLNV7C1EH4pPVBU2nKtE9Hm94vMvboe+?=
 =?us-ascii?Q?ijeYbmCScNdBQ28DzD+AbZcdIcDwp5ppIDUkrSW9as/opnKYbL/rbEgXVBh7?=
 =?us-ascii?Q?DI6k8SmRO+2XMB6F6l4ZuPNUKw8th1uYGb0lByXKElkjhqR4ZZ4YXCaWU9V1?=
 =?us-ascii?Q?0MTxCDzaYtX5GsdFoFbfwxRI6NR4ucLUuoNyYQ345y5Nvnulrp+Wij+9HC+h?=
 =?us-ascii?Q?vJ3lTwp44HeFAv+s+OW0d9t9mcAjuynq0WySWkE337yxnAMFmmihEwGcSgaX?=
 =?us-ascii?Q?BNhw6GyZCe2HhtZfLZDFCb+2nq8ARhTamoUBFIO+e/kIwsirByF/CiwuhZPv?=
 =?us-ascii?Q?/loIu4zROJcOTjan9nZzGVK6Z6JI/tYfcN6l8gAn8nOGi5KppBlcLnrTlpKd?=
 =?us-ascii?Q?IGPuoxOZRrm7RHCPQ/blcQk8TD/QTbLBD5y8XzljbQb/iiwRUSFmYvrK7swl?=
 =?us-ascii?Q?HGEdoMrgSMrfSULByySA9KlYvPR/RNvqevkReA/k0dZUjLENovRTonEu6Alu?=
 =?us-ascii?Q?pgjYunWMXPWg8k23JNvsYpgymB8dKU8/X6MpxnSfvA5+K0AbbAQbhsf5GFS/?=
 =?us-ascii?Q?cw4j5Tef3cT7ai9LjtYhGkFDVB25RdVoqoXVoLQgXmK+PAMipxuPgOXINeFE?=
 =?us-ascii?Q?9PgrK6peUgrFgL8rNZnQ8RVkdQEX3y0cQ9of4Dg1UWVTRLzidrdzMb2gf/1X?=
 =?us-ascii?Q?vuw8+2/pxcgs4LLt85jgKkmp65hOKXTqGVPi1G3oQymg7kqWfPOKxJM4ibOD?=
 =?us-ascii?Q?+aUDhSSnLv8+GeCX8dTnrG0NwtFgpcGl3IGaBGH5UHxjhwSrM+m911YMdjjc?=
 =?us-ascii?Q?kd51I0scHFXzXIB2FVSCb/IK2lR/MzA8mNLuGUNm1qWF5PhifquNw2JEe2Du?=
 =?us-ascii?Q?y29wd6F85QTkkrTLqrolUz/e4A7mBes3g8SRLwK2EloEbh8QobfHKXaKcSnZ?=
 =?us-ascii?Q?2xmKG0SUgNcjWM0EgYrrTXMjpngJJ0BCCqEk74Ut38uAxC/c9jdMrVfBFdNI?=
 =?us-ascii?Q?6CDehNEkVQanGF1NemUAS+S90+VcISVhIJ4I49qA5m/FmUpdwqXBQ9dIrIP5?=
 =?us-ascii?Q?P/6F4UltHVHloVnokZsY/5gDTwuf78mDQcWpxTRAksLL3mklxVkdHPeOBV/F?=
 =?us-ascii?Q?dVi47m/eEKyQnx/KNEJQNJqK/AotTsrB9TM7qHFbPOXfJbdlKf3XiXvBply7?=
 =?us-ascii?Q?bHj59kqvOjXCkt+0+igvXao2S1Cx/+cuJy6H+2woWbtadc/3tvPgdxsrGv9F?=
X-MS-Exchange-AntiSpam-MessageData-1: jsrUw1KBHo7/FZaN+wGrACqXm6AjW4hOONg=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e77047-d577-484b-ee2d-08ded118c5b3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:15:46.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMvfQ3luKLQN09sf2FlWjQo08pyAWIrzz+9/1rwi0M4zWU9c03+Ee+CHJtClnBrTkUspZl7W+Vy3jwzfZkiZpeOgp58gFADXAsOHDRvphvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD72AC0009
X-Rspam-User: 
X-Stat-Signature: ajtmx7ty4wczt8sy36ihret1n9o1zx8s
X-HE-Tag: 1782213353-258596
X-HE-Meta: U2FsdGVkX18Nl81EEgy0nECj6QgDzYeC6Wx9Sm7N9baa4A52Hv0TOK7vRSieq6DKPES6Wzj9Cs0wsuTXFEAX0Sc258Kj0OY98jjVJKPKMYyY8yyDPbVjaO9xnjmSu9iGwkxibzOIHM7AnZynYxrONJwPw4IthpDY7lg2B3fPSJB6NKEBJniAGFMllpi6kuMrwCVUu0EtQ2rd6+YBM6fJzui5p264mdTl6u2N1POZkpEdrfPzt3dvBYAZnMUgjHhpyRQ8NcgrcjbJHSqe1B8TXCOLx9/kNu/TbsyC09HfvGhG1kVMh0gyV7VLCbrp+X440YJ3Ufisy+ZbqbCu/ENlxGkzOmipkGQMkiirsJ1TEvDfsUI3Y5Bt+dle4AoJPYsz+Vl9MtQhy8rFsUlr/HxvOG6Jrl+9aLaGdifnGe1OEZX8xU0cxaO4ugSX+eBJIgCZOnoj17iDXh45RvXNbujiKBDWnERWH1ZJk/3vnL8SQj4wk0clOQEMsK3hurSvLf9gVA04y17TXIi1zstO2Zo2Wz+irZKqbjWU/+UsWvJXaKVGRZTUJPgBdBDiOiQSGmi2uMIvbgness3H77+p601VqXpIN0M+N5FJ9uF64ZmNCvvXfO/gZiaVDKjUQ4gX7cAE3L5tLqcXslZGgg+i3d1mzzq4GYfLdAN4+Mv7DggWbn6hMxwv6hf8qsuboVzHlk5TRddAHb7d8SNa9kjRVtcnGnZoqHGmxFR9Wd8Hg2Fz2kbOinoUWNa6AxQC9t7f6u0hqVDANe2IRs7GlacIYF1m/0xHMEnDvXnEkhRpdEff1bUYP9k9tj2R2dGzL41kpR4AQrMrroaNs2Nb9kSTbw0KrncFA8vlAzLLiL2Y3XTgvM1VcA7DA/Ui5Lw7SVHKMUc5fkJvLZkgOhVsouhcgO+sAeONNPWgbAUv/VA/YAxN8o2bWjb8MKYVapv0amR6M8VJ+01Yvj2L/VgeuL/yIFd
 pGwfIm61
 snYdc4V/7SuS5OsqFDJlmR1tDFiDsyIsGQuStnSwYCjdU5jHh4jjdHDi6VdocYAKE6ZtCLRczMnN72kAFOfQnVmKGIWIOBtNjmzfoxGiGRvCcrR8j2QhChmKqpvVt4/74XQqmdPxWhZKsjmOmLAXtd5G1hmfxWky6o7sgR7Xv5dEGW7BozIdg1WjoB/1/vhzXMMRK0KdPUUlX8H1jv39MMsVgwkmS8NanDlO3HQACobuo9weH9VMC3dDtCKKsJZK9ZKBzStvBzXgPXt/ykf8T9VjJuByHZiT10So3AdlfnOj9B6uNXzu0b79SM9v6eaeNYCvQBc4vTevwTSh/P9CeLTe0Wfm/6qu8syVNN7PU+ecv4Yf+6NOHXKV/xcrugok5mduCgLSHsvo0ALFmF6vsiJtuxwyY4X+5tSZncyIDgpDNZM729b4dbxLs1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Overlayfs forwards data I/O to the real (upper/lower) file, so the page
cache lives in the real inode's mapping and cachestat() on an overlay
fd returned all zeroes.

Implement the ->cachestat() file operation by forwarding to the real
file via vfs_cachestat(), the same way ovl_fadvise() forwards
for fadvise.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 fs/overlayfs/file.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 27cc07738f33b..a7e252a91ea43 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		return vfs_fadvise(realfile, offset, len, advice);
 }
 
+#ifdef CONFIG_CACHESTAT_SYSCALL
+static int ovl_cachestat(struct file *file, struct cachestat_range *csr,
+			 struct cachestat *cs)
+{
+	struct file *realfile;
+
+	realfile = ovl_real_file(file);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	with_ovl_creds(file_inode(file)->i_sb)
+		return vfs_cachestat(realfile, csr, cs);
+}
+#endif
+
 enum ovl_copyop {
 	OVL_COPY,
 	OVL_CLONE,
@@ -642,6 +657,9 @@ const struct file_operations ovl_file_operations = {
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
+#ifdef CONFIG_CACHESTAT_SYSCALL
+	.cachestat	= ovl_cachestat,
+#endif
 	.flush		= ovl_flush,
 	.splice_read    = ovl_splice_read,
 	.splice_write   = ovl_splice_write,
-- 
2.54.0


