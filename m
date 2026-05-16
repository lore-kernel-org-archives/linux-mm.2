Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3228FCD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 00:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420436B0005; Sat, 16 May 2026 20:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA3E6B0088; Sat, 16 May 2026 20:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223E96B008C; Sat, 16 May 2026 20:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 088C16B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 20:02:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8748B1C10FD
	for <linux-mm@kvack.org>; Sun, 17 May 2026 00:02:30 +0000 (UTC)
X-FDA: 84774960060.11.B03BF68
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011020.outbound.protection.outlook.com [40.107.130.20])
	by imf27.hostedemail.com (Postfix) with ESMTP id 82D9640006
	for <linux-mm@kvack.org>; Sun, 17 May 2026 00:02:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=CyeYIBFY;
	spf=pass (imf27.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.130.20 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778976147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gGGXndIEqPPWr6weAz5Zy6gcvc7l6RE0g4+hQvU+H2o=;
	b=Rdhy9wLrTXfbBksaRnJlle8k538vOSd0pCwdXgFKg8s6Wk58Y+tB9NF1/t4wURoM2SJX8j
	wuSI3IkvHrOvYTQphc4CxxmwZZdWhZrUhGp5uWXRjpnL20RpOTCMqz/H4xwakLEsdvgffX
	ksJUps4MQYiqasjLktry30hi6I33k6o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778976147; a=rsa-sha256;
	cv=pass;
	b=4j/Zh4A0Bo4yt0bAo7lcdeRueZ6xlOgpvDDszRpRaAS2L3O05K/M0BJW20HkWgbzQc/4M6
	e3rxWi30kMPSiIdos7qfMoX+tkl8qW0KVxPwwfAt4pohaEcm0wjIxJB+PmIuxsRh46suzs
	/J0+oInfYxRXGXXsmiJ5r9CUZqoxN5g=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=CyeYIBFY;
	spf=pass (imf27.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.130.20 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RMUtA42Fn425+sOPBXLVQWL68EvClgpnsTqnNI0oBQkEgIHNNTeBRa5OwTPPbxqHXbi98vOeyrBT8cQGv1+QMtr2/RrWZ+1iov9bb23BDyfygXAz55BLSvmH9b+m4/AVNWBVQkQILWAlMV8uKNPg3/EZg7nOS/tjZ+yXAIQQDKGtMgtjuZHGy+6pDubNaIc1YcVu/BXfl0qoPcbQOk6tjWWisONHcaShWmRW0rLMP2eoxC5TYrpmsygyGq6YGJ0htGIYwL1+wb2WcCrb1ceUTvKylmQZN2vzdZRBlt5wET0L2F6HhkJ0Zbnqrx4Vb5Zcip7ymHSECAUB7wdlMCFouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGGXndIEqPPWr6weAz5Zy6gcvc7l6RE0g4+hQvU+H2o=;
 b=FFiR+SdH83e8ZiyTGp07vVWZYoZJfPZQSbmlShO15czfDeJaMGcn0EhLuSVyPIxPuaMTYjKZ71hePIZP4yWR2eqEuiCp6dZlJZiYN4X9FRT3+qaDtwxhCDDf17zVpYSvZYV9s/DmevyEmVHG7Zv0ki5hM+RzqnlN0pdMeh8YB7NmlLqfC1wDUlponqj4gGPw2pG8abpHQqNE+6PP3YnOSGbZaVitrA0AkAC52YDRKPdr8v5pZk68v5KFPBbH3znW03Q6mFct7CqimqcpWua1Szl1ddedLYykD6dwEoWRIuXCLGxmlpRumA2/UxhDn3MC8AiLrNSQsc4/cUPdJWEzgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGGXndIEqPPWr6weAz5Zy6gcvc7l6RE0g4+hQvU+H2o=;
 b=CyeYIBFYMYoBn4SzxYEXgVhYQsRWhqr84Qb2+6FI5mOhT9OKBdW8GMZSu1hhSev11C38w0yO+Gq7G454d+ZTT9K4xDFbAR02CsWPfFKWQGyUpWf9xgtLbRmujzVTKbstSbKA2hBUSv1zbYSsBc1q3DLDn9W6lD3XuL+yLV9xh9IRuxLXtR8YSKChHWGiILbSIzYFQSxIpqTL6P6QaeYA9Q2ShJ6DVbabrGQEUezCorvMyD9AI2QwAM51rR+iYY/RPcnX3jxJvmyqlnIuVtnQFezY90KdWA1il3j0SGV4qNsN/YP80ZRNAt2hz9drnJVCnwU/gzNU9HZPlypBKg3FJg==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by PAVP189MB2433.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:306::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.22; Sun, 17 May
 2026 00:02:22 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.21.0025.020; Sun, 17 May 2026
 00:02:22 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	max.byungchul.park@gmail.com,
	"kernel_team@skhynix.com" <kernel_team@skhynix.com>,
	kernel-team@lge.com,
	Yunseong Kim <yunseong.kim@ericsson.com>,
	Yunseong Kim <ysk@kzalloc.com>,
	42.4.sejin@gmail.com,
	Yunseong Kim <yunseong.kim@est.tech>,
	Byungchul Park <byungchul@sk.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2 RESEND] lkdtm: Add folio_lock deadlock scenarios
Date: Sun, 17 May 2026 01:53:58 +0200
Message-ID: <20260516235356.635435-3-yunseong.kim@est.tech>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV2PEPF00023957.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::34b) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|PAVP189MB2433:EE_
X-MS-Office365-Filtering-Correlation-Id: eae3fc48-9db7-4c47-7aa2-08deb3a791d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016|56012099003|18002099003|3023799003|11063799003;
X-Microsoft-Antispam-Message-Info:
	mDtax8bDqhvLG/ka2fnUxjaVKHG5AUt/mQLQ8y31JDzdT+yck6xpfiGlTI1EaOI4E5Lja7A21NZHG4qPih+Y2Zwtwh2FX8+rCgcR4yt6PUasHW8QcuWcw8lZii+YccHqIBOXjo/0QT6GsGSWSFOsrGqLFD42Ke7CSUgDywL/YAEcJ7qxDecEFdex22puafK+vPV73UkLhvEVmlStDDHQlVtDNw4KYrRrPUHZSXru/fkHmOcVuLMjGMzILiZh52XlrEEZyuQke0Pu560h1DYRSke2nHCv/cALSHiTdcJShq23nyfc9Kt/FmKZyEGZKqINfbjaEgwnKLGXI4Zbwun1IoHn+P0zPa43dz2YwYj3C42Q+zt5zKtTtQAR5lfs3OfgHF3nGbP3HbIGIdwJZEC1CbBLWyp5y+E1w+xrt6bFnl6zloinZdD9gvTz7mMVNfo4GG0c6XLJkbXT9uGee9RQqgsBVXBbSalfO//Scu69bSI4ZqXqmFajuT/OUdABmnBwmjnYGtBE+FZ0/IdcScPTuKU3Qloz2aSBykVLeQ6kbF5BF0+/9kndeP2CrwoUih5U4fZ8dwpiwvklZ6P2+xeo7ErBU1rvmzY1UDDT16g/Fe5WjxyJnRg4SsNr2QvdhMkvM76fXktH45gpgFeWwORSEDmJx6Kui6mI7HeCrdIWqQCfkLn8rVXUNdSZfJRoAUjU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016)(56012099003)(18002099003)(3023799003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LQyOrAtH2F017YtIb/9M1Aj3Lvl7+DkdT63o9wEDttavu/YnQobvSRKYOEuh?=
 =?us-ascii?Q?FHGaNB380K4A1SQXTgBlaUi7p/xnWNvsXpsk47XiO1wO0eW/VbMHHxMGuAWo?=
 =?us-ascii?Q?PxTmnfghC/N5xSlvD8uWfGgbPolQyTNr/1w3eWBAHLprOwxqGFPOT3NCARGo?=
 =?us-ascii?Q?WdTW1QIJ1vjCcAnOMd57mQf+Rklxe2Y8SBjnDhJZpnUdgjHL3orZJNQQCN+d?=
 =?us-ascii?Q?m38gXpjxKo2eX5DeJAYczUcIlQTFniOTm8Vq2VeI3Cuu5CQMFJfs74mtBudP?=
 =?us-ascii?Q?W7eH+E6hsBMeh2zqbZojl2Q3gGqNKTbjKIdOhO+byflVoUgtoOT+1sGMzhSr?=
 =?us-ascii?Q?fgWuoUOoC2Igi2m0CkF4EZiO1oVEQcMLdVv3RSu9vi8wW2wS0hQwUnKBOwQ5?=
 =?us-ascii?Q?8X16GKKT9LsXqIs2Bc4nIN+khtiL5DLoltXxHynjE3xz4LJvcHxMo6FDNU7P?=
 =?us-ascii?Q?nLiHVk7n8Cv3HNhYX/JQX2G3UbiGDJ+KsiFfBx9kHmGLH+zAnyV1fc0CFBPe?=
 =?us-ascii?Q?541pBi+EqUtsl/1QJs+bNo7j+sd/yieamrzxAy/4Rg4CBOu4rgva/UzpPW6u?=
 =?us-ascii?Q?Dc20ED0737LoH+BYYp7FFXKwiidghJlyOzA8EkMyTYudxv7Jbs4/fk0GyO5q?=
 =?us-ascii?Q?Np4Pn4btt2801WIlHijyMcTG26gMzzOIZ5ukMt3cvXl2kQtDaRGWkV4G8plM?=
 =?us-ascii?Q?Y5PAY/GEOtimWZ2srb5DzsnsNyegFWE3yW5RL1lSxFJyxvnov5KFg7UOtXAy?=
 =?us-ascii?Q?BbzPzz4yih69mufxc50sW6dI80Ir+A+4eJ25ysPWlO3/vDwleuyqWhZzofzG?=
 =?us-ascii?Q?INFeXyOTQEbNWLyBPI4gDAayZHzB7DbLyCdP8WQbJWLMBI/z8KO7Ig5cl0/v?=
 =?us-ascii?Q?494Q2DrNF1utTye4Hdh1ct1XANFY7TV0N1SgCi1IywnJtPLdzzjUe5t4c4Td?=
 =?us-ascii?Q?7wTGER7dFie96G9hW6WKbpEPXxl4nUOw6oQUnpIVP3P0sQTr6js/kOF70auu?=
 =?us-ascii?Q?sA/UlSJHO4ccNSlBbRiopO441T5WLTX64fFTp5a1t5GcrfN7z8ta7impgL94?=
 =?us-ascii?Q?haP3QOm7gferiqzsmX0UHElaEmhRGfg2jvFw3YtAc8gCJlvJqF6eeiq8A2++?=
 =?us-ascii?Q?txQ36/n/f9or/6pW/nwq06lmUptXf9G3fyM77MlSnCrYmSUL3voLSggOXLvu?=
 =?us-ascii?Q?V6uucRAwZjL1henskNXbTXjNHatQ1n37EvErT4Z1+P9Lhsr8jWveVIC5ufUu?=
 =?us-ascii?Q?ktWNoB2o/TWo8KKIcOJx/AY0kndKGUMhaIjDi/3N3A+47XTipDhyKeZqAUgX?=
 =?us-ascii?Q?tBa7xn4UBiMl81/lY/IMY9+OnNRYATY1DYM/QeYCCIT1yUea6fBop03T6J6P?=
 =?us-ascii?Q?S9jdmwZwdl0gdI6rQFiBU9VOdADxgxzXMliIjWi3rFFbo+VCdtkljONStlfs?=
 =?us-ascii?Q?YD4B3sJ9T5TciTvHmfRY47h7+ZAAN6/z5qle97gXozXlMYn/XalPJNbhtR1k?=
 =?us-ascii?Q?MYQ1XU+0i+2p/YX3Q0EWqe6R0FK2tHGBwqUHkyuM/6P4+PmONjHasn0YdMs+?=
 =?us-ascii?Q?BP5ZTMP1EnhUzCvuwGx7LeGZRcudyoGEQeJ0p6oepwrvyEvSUYXDbmdEzEYQ?=
 =?us-ascii?Q?pqEhfZR6mQLAZw1uHQ4bF7eVV3ZDyogoc/7IWQqfEyx0whIGKAi1lfC5jcMD?=
 =?us-ascii?Q?rmUmhxKyPO62Gw17IeQthsMQIeKVNBzrwJSZlefpDCOkB6IYgoel0BS4qH27?=
 =?us-ascii?Q?uM6+PFMBLPrpVhUC64nIOxkzODjq80ttWJaSkkLKRpxnQdeIMJKxlgqBwiXo?=
X-MS-Exchange-AntiSpam-MessageData-1: ycD4XLGCXNwChw==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: eae3fc48-9db7-4c47-7aa2-08deb3a791d3
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 00:02:22.3053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmgLEfVW2nmNF7HToswdmM+dM76UqNQ0oXuxH3+kCIXoW9q+6RiKNdmksHhPxFK4dSkKJk8660G6dnAkvj8UQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVP189MB2433
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82D9640006
X-Rspam-User: 
X-Stat-Signature: bhsh1ptmss5jbksk7w181fc6wpo3otq6
X-HE-Tag: 1778976147-721680
X-HE-Meta: U2FsdGVkX1+Ith7vyZLtIY+Y1sB606nhVGq6Lj72YhULGI6+8MoUXCSfHiEodzP+LfO5KDOBsGeZWb34rWl6jvUxLsORQZ3yH27yk4h4H5RoqZMIN+AZF7RmdE7ndRXICvAQEU7kZOZ64/MM8elun9eTfVlxBBSBNEBuQ0tBcBjts70JQGPnSmOgrBpXm7kvunEKP6zsLB7E9h+erQ4VWw0Jkc4318qgU1U+FmWGTxUNcsHeKcQmKTwIDmcCi5ggkS3Y90h40SJLMjRWiQjW+5XFSlwFDXcaNKfuS7JvA1faNTUpolCMVwW70nU2zEWzExUuPZbQOkShdFoZvfXn/Rh3uKnHt5iFAhbyKLgfl9nKAlgN03Q+1pb87+MtEXko8a4EjEyIqTaZ91wkyeWYBNcs+g93TUOmjFtIiuIAE9D3oAFlpqU+3szrx7wk85g86F/yJFwroUQEzP0JpURNwTgHBXOVIGricaIt3nMRyslmkCEdiXAEg1nkHsSG6sNMeiWpXg/djYRX/Vur7gP0xfy5Flcw6ODGK14au9YAEDHEEnqneIG7+BECbrWaADKJimlEbn8BmI2ERvKBgTx1RNFiwoTkvuB/LKwWJz0HqaqQdbSiv9ZDu5JL/CXOw+TTc3QfMWl9CzKKL7lfhu7gZbgJcr3ahTtCDTIhm8GkqqzcjrCHcyomwBJH9gZAwURhVu7JOUgpZiLxffFzCzUImSni0FxXuhkCz1iKUcwGHGb+VuegdfQs8ZxHKmQ4g/6EvRWDeSPQm47bkJ08vBnTzWq2CrrgsePyiIe3rtkVCvMkB0OmgrjQTdtsvoHWPHhfKpjmbSLxnvo90YubEtLfq4PdA8e7C5dM3HmDgtooWPYNEn6+ARCeCBJK8h/ktPrZDzeUg1AV9pkfaLct/3neVJoPpIQst4fMy3WkepPeP2x2v2SpzRAZPP0UJWGk6eYIPfZIPXbeU7FJe7Xavmv
 yo6KFPL+
 CxPnpZm8GXSa+wlhDCFIOmaOtDrHT3rPBe2ps+FfhhmW1h04DVPSFeUCxTnxoN9ieOLfC6ZLYLu82+t3wtNo/TAEgkmiczv3Zt8IW/hn8z4ITOo1oYW0sROUrbh6KGH1cs7UvbyiGBYItSHQNGiJ0IUs1VR4gmr6XPEUPiG7xt2e3rzZk7Pgi3vFuZz8j8WuqsgF/vtDI2PdPWb/9M3rOTQv2jMih296thWTFB8o+rLeGPLWI3JuJqKxIH5idgz+KN7AfRcP5sAZKLgXv2itE8VQd67tyaEUhmMpZ4+PnVdaxT/HIns7/9O4ebc49WYmm++2LsBzBlEFTvQtK/zStzaHv55AyvmPWLXb9lDKITlqh9rhfXXHxuymgcZHlzvXSYy6BIzjfA/1zB9Z7CUl76EpWFgQSeDHXaOYArGohxS4ZltRgK9mrCBi4F11oZlLDhXyTWroCwlLWIhwGPBcyhbR+LYNme8yUt4Gvdywj4E4goln17/PcbYfFofHT3Yq1q0QKTBsnj7kTkcKM7lHmJLivloaCgVx9DbCcIDGUWWM0kdihiyP5gvXFmMSTZ9rXJmSE7u1eiddXSTNX7FfmBZvW5rQSgzNbhx1uV1WXcBdhcCZx3Oyr1g/NX22yG4tKEnfCV2ypxMzMcKzMtidGAQe3/5HPRJFZWTmBN6e9b/23mwFPht4jNVmOgunOXbn9vv6oSi3n0pRSfLwNM85dja6G4gzBO3QLvJ3vhOaQ4F+qLTWZMnGjISIZ6fDxZx/MvtJTC5akWFxojwk3DeiYy1CEuYL7G+4Hlsu9ooknjNjDSyel0ExXSyGzkbyqTwYFejcNEODD83jpjIX/HEudyJ4toiPRiFdOVXaTFFnDv6uZpSXdPOshI7yq0OtyC83CVnHuh+FYLI54YFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduces 3 new crash types to LKDTM to reproduce deadlock patterns
involving folio_lock(), which operates on a wait-on-bit mechanism.

1. FOLIO_LOCK_AA:
   Triggers a self-deadlock (AA) by attempting to acquire the same folio
   lock twice in the same execution context.

2. FOLIO_LOCK_ABBA:
   Triggers a classic ABBA deadlock between two threads trying to folio
   lock two different folios in reverse order.

3. FOLIO_MUTEX_LOCK_ABBA:
   Reproduces an ABBA deadlock involving a folio_lock() and a mutex.
   This verifies lockdep's ability to track dependencies between
   sleeping locks (wait-on-bit) and mutexes.

These tests allow developers to validate the kernel's behavior
(e.g., hung task detection enabled, DEPT reporting[1][2]) under
wait/event-based deadlock conditions.

 [1] https://lwn.net/Articles/1036222/
 [2] https://lore.kernel.org/lkml/20251205071855.72743-1-byungchul@sk.com/

(1) LOCKDEP & DETECT_HUNG_TASK enabled kernel log:

Lockdep does not detect these issues because it requires the lock and
unlock to happen within the same execution context. However, it also fails
to detect AA deadlocks involving folio_lock even when they occur within
the same execution context. Consequently, all three of these cases are
only detected as hung tasks.

 # echo FOLIO_LOCK_AA > /sys/kernel/debug/provoke-crash/DIRECT
 [   20.428887] lkdtm: Performing direct entry FOLIO_LOCK_AA
 [   29.579353] hrtimer: interrupt took 32992 ns
 [   60.613392] INFO: task bash:923 blocked for more than 30 seconds.
 [   60.613708]       Not tainted 6.19.0-virtme #30
 [   60.613868] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   60.614006] task:bash            state:D stack:12600 pid:923   tgid:923   ppid:915    task_flags:0x400100 flags:0x00080000
 [   60.614190] Call Trace:
 [   60.614256]  <TASK>
 [   60.614304]  __schedule+0x5e7/0x1170
 [   60.614377]  schedule+0x3a/0x130
 [   60.614437]  io_schedule+0x46/0x70
 [   60.614503]  folio_wait_bit_common+0x125/0x2d0
 [   60.614590]  ? __pfx_wake_page_function+0x10/0x10
 [   60.614673]  lkdtm_FOLIO_LOCK_AA+0x8a/0x90
 [   60.614732]  lkdtm_do_action+0x18/0x30
 [   60.614793]  direct_entry+0x8d/0xe0
 [   60.614859]  full_proxy_write+0x69/0xa0
 [   60.614926]  vfs_write+0xdf/0x570
 [   60.614990]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   60.615087]  ? find_held_lock+0x2b/0x80
 [   60.615154]  ? exc_page_fault+0x82/0x1d0
 [   60.615218]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   60.615310]  ? lock_release+0xcd/0x270
 [   60.615366]  ? handle_mm_fault+0xde/0x220
 [   60.615436]  ksys_write+0x73/0xf0
 [   60.615501]  do_syscall_64+0xbd/0xf80
 [   60.615688]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
 [   60.616034] RIP: 0033:0x7f35aa463340
 [   60.616334] RSP: 002b:00007ffe24f07ba8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
 [   60.616863] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f35aa463340
 [   60.617357] RDX: 000000000000000e RSI: 000056539115fed0 RDI: 0000000000000001
 [   60.618120] RBP: 000056539115fed0 R08: 0000000000000007 R09: 0000000000000073
 [   60.618302] R10: 0000000000001000 R11: 0000000000000202 R12: 000000000000000e
 [   60.618422] R13: 00007f35aa53f760 R14: 000000000000000e R15: 00007f35aa53a9e0
 [   60.618544]  </TASK>
 [   60.618591]
 [   60.618591] Showing all locks held in the system:
 [   60.618704] 1 lock held by khungtaskd/116:
 [   60.618767]  #0: ffffffff89d6d760 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0
 [   60.618910] 1 lock held by bash/923:
 [   60.618969]  #0: ffff8daa81c983f0 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x73/0xf0
 [   60.619087]
 [   60.619121] =============================================
 [   60.619121]
 [   90.821362] INFO: task bash:923 blocked for more than 60 seconds.
 [   90.821604]       Not tainted 6.19.0-virtme #30
 [   90.821711] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   90.821882] task:bash            state:D stack:12600 pid:923   tgid:923   ppid:915    task_flags:0x400100 flags:0x00080000
 [   90.822091] Call Trace:
 [   90.822156]  <TASK>
 [   90.822229]  __schedule+0x5e7/0x1170
 [   90.822382]  schedule+0x3a/0x130
 [   90.822475]  io_schedule+0x46/0x70
 [   90.822562]  folio_wait_bit_common+0x125/0x2d0
 [   90.822687]  ? __pfx_wake_page_function+0x10/0x10
 [   90.822809]  lkdtm_FOLIO_LOCK_AA+0x8a/0x90
 [   90.822902]  lkdtm_do_action+0x18/0x30
 [   90.822986]  direct_entry+0x8d/0xe0
 [   90.823078]  full_proxy_write+0x69/0xa0
 [   90.823176]  vfs_write+0xdf/0x570
 [   90.823284]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   90.823397]  ? find_held_lock+0x2b/0x80
 [   90.823486]  ? exc_page_fault+0x82/0x1d0
 [   90.823570]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   90.823677]  ? lock_release+0xcd/0x270
 [   90.823762]  ? handle_mm_fault+0xde/0x220
 [   90.823859]  ksys_write+0x73/0xf0
 [   90.823954]  do_syscall_64+0xbd/0xf80
 [   90.824075]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
 [   90.824189] RIP: 0033:0x7f35aa463340
 [   90.824290] RSP: 002b:00007ffe24f07ba8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
 [   90.824449] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f35aa463340
 [   90.824602] RDX: 000000000000000e RSI: 000056539115fed0 RDI: 0000000000000001
 [   90.824755] RBP: 000056539115fed0 R08: 0000000000000007 R09: 0000000000000073
 [   90.824910] R10: 0000000000001000 R11: 0000000000000202 R12: 000000000000000e
 [   90.825063] R13: 00007f35aa53f760 R14: 000000000000000e R15: 00007f35aa53a9e0
 [   90.825270]  </TASK>
 [   90.825320]
 [   90.825320] Showing all locks held in the system:
 [   90.825405] 1 lock held by khungtaskd/116:
 [   90.825453]  #0: ffffffff89d6d760 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0
 [   90.825577] 1 lock held by bash/923:
 [   90.825624]  #0: ffff8daa81c983f0 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x73/0xf0
 [   90.825730]
 [   90.825762] =============================================

 # echo FOLIO_LOCK_ABBA > /sys/kernel/debug/provoke-crash/DIRECT
 [   12.625758] lkdtm: Performing direct entry FOLIO_LOCK_ABBA
 [   60.622597] INFO: task lkdtm_folio_A:923 blocked for more than 30 seconds.
 [   60.623573]       Not tainted 6.19.0-virtme #30
 [   60.624034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   60.624624] task:lkdtm_folio_A   state:D stack:15288 pid:923   tgid:923   ppid:2      task_flags:0x208040 flags:0x00080000
 [   60.624832] Call Trace:
 [   60.624878]  <TASK>
 [   60.624931]  __schedule+0x5e7/0x1170
 [   60.625020]  schedule+0x3a/0x130
 [   60.625089]  io_schedule+0x46/0x70
 [   60.625173]  folio_wait_bit_common+0x125/0x2d0
 [   60.625267]  ? __pfx_wake_page_function+0x10/0x10
 [   60.625358]  ? __pfx_lkdtm_folio_AB_kthread+0x10/0x10
 [   60.625424]  lkdtm_folio_AB_kthread+0x54/0x60
 [   60.625490]  kthread+0xfe/0x200
 [   60.625544]  ? __pfx_kthread+0x10/0x10
 [   60.625599]  ret_from_fork+0x2b2/0x2e0
 [   60.625650]  ? __pfx_kthread+0x10/0x10
 [   60.625716]  ret_from_fork_asm+0x1a/0x30
 [   60.625794]  </TASK>
 [   60.625829] INFO: task lkdtm_folio_B:924 blocked for more than 30 seconds.
 [   60.625904]       Not tainted 6.19.0-virtme #30
 [   60.625964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   60.626049] task:lkdtm_folio_B   state:D stack:15288 pid:924   tgid:924   ppid:2      task_flags:0x208040 flags:0x00080000
 [   60.626186] Call Trace:
 [   60.626219]  <TASK>
 [   60.626259]  __schedule+0x5e7/0x1170
 [   60.626326]  schedule+0x3a/0x130
 [   60.626377]  io_schedule+0x46/0x70
 [   60.626429]  folio_wait_bit_common+0x125/0x2d0
 [   60.626501]  ? __pfx_wake_page_function+0x10/0x10
 [   60.626570]  ? __pfx_lkdtm_folio_BA_kthread+0x10/0x10
 [   60.626634]  lkdtm_folio_BA_kthread+0x5e/0x60
 [   60.626698]  kthread+0xfe/0x200
 [   60.626749]  ? __pfx_kthread+0x10/0x10
 [   60.626807]  ret_from_fork+0x2b2/0x2e0
 [   60.626860]  ? __pfx_kthread+0x10/0x10
 [   60.626913]  ret_from_fork_asm+0x1a/0x30
 [   60.626992]  </TASK>
 [   60.627027]
 [   60.627027] Showing all locks held in the system:
 [   60.627133] 1 lock held by khungtaskd/116:
 [   60.627183]  #0: ffffffffa816d760 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0
 [   60.627310]
 [   60.627344] =============================================

 # echo FOLIO_MUTEX_LOCK_ABBA > /sys/kernel/debug/provoke-crash/DIRECT
 [   60.096166] lkdtm: Performing direct entry FOLIO_MUTEX_LOCK_ABBA
 [   90.808780] INFO: task lkdtm_folio_mut:925 blocked for more than 30 seconds.
 [   90.809074]       Not tainted 6.19.0-virtme #30
 [   90.809182] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   90.809293] task:lkdtm_folio_mut state:D stack:14864 pid:925   tgid:925   ppid:2      task_flags:0x208040 flags:0x00080000
 [   90.809453] Call Trace:
 [   90.809497]  <TASK>
 [   90.809606]  __schedule+0x5e7/0x1170
 [   90.809686]  schedule+0x3a/0x130
 [   90.809748]  io_schedule+0x46/0x70
 [   90.809800]  folio_wait_bit_common+0x125/0x2d0
 [   90.809874]  ? __pfx_wake_page_function+0x10/0x10
 [   90.809944]  ? __pfx_lkdtm_folio_mutex_kthread+0x10/0x10
 [   90.810010]  lkdtm_folio_mutex_kthread+0x4e/0x50
 [   90.810074]  kthread+0xfe/0x200
 [   90.810128]  ? __pfx_kthread+0x10/0x10
 [   90.810183]  ret_from_fork+0x2b2/0x2e0
 [   90.810232]  ? __pfx_kthread+0x10/0x10
 [   90.810283]  ret_from_fork_asm+0x1a/0x30
 [   90.810361]  </TASK>
 [   90.810395] INFO: task lkdtm_mutex_fol:926 blocked for more than 30 seconds.
 [   90.810481]       Not tainted 6.19.0-virtme #30
 [   90.810558] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   90.810645] task:lkdtm_mutex_fol state:D stack:14840 pid:926   tgid:926   ppid:2      task_flags:0x208040 flags:0x00080000
 [   90.810765] Call Trace:
 [   90.810798]  <TASK>
 [   90.810839]  __schedule+0x5e7/0x1170
 [   90.810909]  schedule+0x3a/0x130
 [   90.810961]  io_schedule+0x46/0x70
 [   90.811014]  folio_wait_bit_common+0x125/0x2d0
 [   90.811087]  ? __pfx_wake_page_function+0x10/0x10
 [   90.811156]  ? __pfx_lkdtm_mutex_folio_kthread+0x10/0x10
 [   90.811221]  lkdtm_mutex_folio_kthread+0x4e/0x50
 [   90.811286]  kthread+0xfe/0x200
 [   90.811339]  ? __pfx_kthread+0x10/0x10
 [   90.811395]  ret_from_fork+0x2b2/0x2e0
 [   90.811444]  ? __pfx_kthread+0x10/0x10
 [   90.811496]  ret_from_fork_asm+0x1a/0x30
 [   90.811587]  </TASK>
 [   90.811622]
 [   90.811622] Showing all locks held in the system:
 [   90.811704] 1 lock held by khungtaskd/116:
 [   90.811752]  #0: ffffffff8556d760 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0
 [   90.811876] 1 lock held by lkdtm_mutex_fol/926:
 [   90.811937]  #0: ffffffff856229a8 (mutex_b){+.+.}-{4:4}, at: lkdtm_mutex_folio_kthread+0x32/0x50
 [   90.812086]
 [   90.812120] =============================================

(2) DEPT & DETECT_HUNG_TASK enabled kernel log:

Currently, DEPT lacks the capability to detect FOLIO_LOCK_AA; however,
it is capable of detecting FOLIO_MUTEX_LOCK_ABBA. DEPT misidentifies
FOLIO_LOCK_ABBA as an AA deadlock.DEPT needs to be refined to correctly
distinguish between separate folio locks.

 # echo FOLIO_LOCK_AA > /sys/kernel/debug/provoke-crash/DIRECT
 [   58.674392] lkdtm: Performing direct entry FOLIO_LOCK_AA
 [   91.323323] INFO: task bash:926 blocked for more than 30 seconds.
 [   91.323768]       Not tainted 6.19.0-virtme #29
 [   91.324148] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   91.324536] task:bash            state:D stack:12536 pid:926   tgid:926   ppid:918    task_flags:0x400100 flags:0x00080000
 [   91.325116] Call Trace:
 [   91.325284]  <TASK>
 [   91.325444]  ? __schedule+0x5e9/0x11b0
 [   91.325661]  __schedule+0x61c/0x11b0
 [   91.325886]  schedule+0x3a/0x130
 [   91.326282]  io_schedule+0x46/0x70
 [   91.326501]  folio_wait_bit_common+0x1ab/0x440
 [   91.326776]  ? __pfx_wake_page_function+0x10/0x10
 [   91.327141]  lkdtm_FOLIO_LOCK_AA+0x10c/0x1b0
 [   91.327397]  lkdtm_do_action+0x18/0x30
 [   91.327596]  direct_entry+0x8d/0xe0
 [   91.327799]  full_proxy_write+0x69/0xa0
 [   91.328116]  vfs_write+0xea/0x600
 [   91.328325]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   91.328571]  ? find_held_lock+0x2b/0x80
 [   91.328768]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   91.329104]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   91.329343]  ? from_pool+0x7d/0x190
 [   91.329541]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   91.329781]  ? dept_enter+0x68/0xa0
 [   91.330082]  ksys_write+0x76/0xf0
 [   91.330285]  do_syscall_64+0xc2/0xf80
 [   91.330485]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
 [   91.330721] RIP: 0033:0x7f462490c340
 [   91.331038] RSP: 002b:00007ffe8c0b03c8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
 [   91.331405] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f462490c340
 [   91.331743] RDX: 000000000000000e RSI: 00005595da40fed0 RDI: 0000000000000001
 [   91.332182] RBP: 00005595da40fed0 R08: 0000000000000007 R09: 0000000000000073
 [   91.332522] R10: 0000000000001000 R11: 0000000000000202 R12: 000000000000000e
 [   91.332862] R13: 00007f46249e8760 R14: 000000000000000e R15: 00007f46249e39e0
 [   91.333330]  </TASK>
 [   91.333480]
 [   91.333480] Showing all locks held in the system:
 [   91.333772] 1 lock held by khungtaskd/116:
 [   91.334083]  #0: ffffffff82b80620 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0
 [   91.334618] 1 lock held by bash/926:
 [   91.334814]  #0: ffff8be901beb570 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x76/0xf0
 [   91.335471]
 [   91.335622] =============================================

 # echo FOLIO_MUTEX_LOCK_ABBA > /sys/kernel/debug/provoke-crash/DIRECT
 [   23.480083] lkdtm: Performing direct entry FOLIO_MUTEX_LOCK_ABBA
 [   23.483404] ===================================================
 [   23.483623] DEPT: Circular dependency has been detected.
 [   23.483755] 6.19.0-virtme #29 Not tainted
 [   23.483884] ---------------------------------------------------
 [   23.484042] summary
 [   23.484155] ---------------------------------------------------
 [** DEADLOCK ***
 [   23.484343]
 [   23.484635] context A
 [   23.484766]    [S] lock(mutex_b:0)
 [   23.484953]    [W] dept_page_wait_on_bit(pg_locked_map:0)
 [   23.485087]    [E] unlock(mutex_b:0)
 [   23.485198]
 [   23.485277] context B
 [   23.485351]    [S] (unknown)(pg_locked_map:0)r
 [   23.485550]    [W] lock(mutext_b:0)
 [   23.486150]    [E] dept_page_iclear_bit(pg_locrked_map:0)
 [   23.486964]
 [   23.487371] [S]: start of then event context
 [   23.487988] [W]: the wait blo/cked
 [   23.488543] [E]: the event not reachable
 [   23.488652] ------------------------------------------------------
 [   23.488987] ckontext A's detail
 [   23.489171] -----------------------------------------------------
 [   23.489468] context A
 [   23.489571]    [S] lock(mutex_b:0)
 [   23.489737]    [W] dept_page_wait_on_bit(pg_lnocked_map:0)
 [   23.489997]    [E] unlock(mutex_b:0)
 [   23.490138]
 [   23.490232] [S] lock(mutex_b:0):
 [   23.490349] [<ffffffffa2189c50>] lkdtm_mutex_folio_kthread+0x40/0xe0
 [   23.490500] stacktrace:
 [   23.490557]       lkdtm_mutex_folio_kthread+0x40/0xe0
 [   23.490662]       kthread+0xfe/0x200
 [   23.490742]       ret_from_fork+0x29d/0x2e0
 [   23.490821]       ret_from_fork_asm+0x1a/0x30
 [   23.490926]
 [   23.490987] [W] dept_page_wait_on_bit(pg_locked_map:0):
 [   23.491090] [<ffffffffa179a5ae>] kthread+0xfe/0x200
 [   23.491199] stacktrace:
 [   23.491263]       kthread+0xfe/0x200
 [   23.491347]       ret_from_fork+0x29d/0x2e0
 [   23.491431]       ret_from_fork_asm+0x1a/0x30
 [   23.491537]
 [   23.491601] [E] unlock(mutex_b:0):
 [   23.491684] (N/A)
 [   23.491754] ---------------------------------------------------
 [   23.491908] context B's detail
 [   23.491992] ---------------------------------------------------
 [   23.492118] context B
 [   23.492175]    [S] (unknown)(pg_locked_map:0)
 [   23.492277]    [W] lock(mutex_b:0)
 [   23.492358]    [E] dept_page_clear_bit(pg_locked_map:0)
 [   23.492459]
 [   23.492523] [S] (unknown)(pg_locked_map:0):
 [   23.492603] (N/A)
 [   23.492664]
 [   23.492722] [W] lock(mutex_b:0):
 [   23.492807] [<ffffffffa2189d28>] lkdtm_folio_mutex_kthread+0x28/0xe0
 [   23.492947] stacktrace:
 [   23.493006]       lkdtm_folio_mutex_kthread+0x28/0xe0
 [   23.493115]       kthread+0xfe/0x200
 [   23.493197]       ret_from_fork+0x29d/0x2e0
 [   23.493280]       ret_from_fork_asm+0x1a/0x30
 [   23.493382]
 [   23.493446] [E] dept_page_clear_bit(pg_locked_map:0):
 [   23.493550] [<ffffffffa2189d40>] lkdtm_folio_mutex_kthread+0x40/0xe0
 [   23.493680] stacktrace:
 [   23.493740]       lkdtm_folio_mutex_kthread+0x40/0xe0
 [   23.493847]       kthread+0xfe/0x200
 [   23.493933]       ret_from_fork+0x29d/0x2e0
 [   23.494015]       ret_from_fork_asm+0x1a/0x30
 [   23.494122] ---------------------------------------------------
 [   23.494241] information that might be helpful
 [   23.494348] ---------------------------------------------------
 [   23.494479] CPU: 3 UID: 0 PID: 928 Comm: lkdtm_mutex_fol Not tainted 6.19.0-virtme #29 PREEMPT(full)
 [   23.494485] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
 [   23.494487] Call Trace:
 [   23.494491]  <TASK>
 [   23.494495]  dump_stack_lvl+0x69/0xa0
 [   23.494502]  cb_check_dl+0x6be/0x760
 [   23.494517]  bfs+0x17d/0x1c0
 [   23.494521]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   23.494530]  add_dep+0xd6/0x1c0
 [   23.494534]  ? lkdtm_mutex_folio_kthread+0x40/0xe0
 [   23.494538]  ? __pfx_bfs_init_check_dl+0x10/0x10
 [   23.494541]  ? __pfx_bfs_extend_dep+0x10/0x10
 [   23.494544]  ? __pfx_bfs_dequeue_dep+0x10/0x10
 [   23.494548]  ? __pfx_cb_check_dl+0x10/0x10
 [   23.494555]  __dept_wait+0x274/0x6a0
 [   23.494561]  ? kthread+0xfe/0x200
 [   23.494566]  ? __mutex_lock+0xae3/0x1230
 [   23.494572]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   23.494575]  ? dept_enter+0x68/0xa0
 [   23.494582]  ? kthread+0xfe/0x200
 [   23.494587]  dept_wait+0xa7/0xc0
 [   23.494595]  ? __pfx_lkdtm_mutex_folio_kthread+0x10/0x10
 [   23.494600]  lkdtm_mutex_folio_kthread+0x9d/0xe0
 [   23.494604]  kthread+0xfe/0x200
 [   23.494609]  ? __pfx_kthread+0x10/0x10
 [   23.494616]  ret_from_fork+0x29d/0x2e0
 [   23.494619]  ? __pfx_kthread+0x10/0x10
 [   23.494623]  ret_from_fork_asm+0x1a/0x30
 [   23.494641]  </TASK>

Cc: Byungchul Park <byungchul@sk.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Assisted-by: Gemini:gemini-3.1-pro
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604051803.UYvkxRXB-lkp@intel.com/
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---

Changes since v1 (https://lore.kernel.org/all/20260402143947.162844-1-ysk@kzalloc.com/):

Changes in v2:
- Synchronize folio lock and unlock in the FOLIO_LOCK_AA case. 
- Address code review feedback from Byungchul.
- Resolve issues flagged by the Linux Kernel Performance (LKP) bot and
  add the Reported-by tag.
- Polish the commit message for clarity and correctness.

 drivers/misc/lkdtm/Makefile             |   1 +
 drivers/misc/lkdtm/bugs.c               |   1 +
 drivers/misc/lkdtm/core.c               |   1 +
 drivers/misc/lkdtm/deadlock.c           | 150 ++++++++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h              |   1 +
 tools/testing/selftests/lkdtm/tests.txt |   3 +
 6 files changed, 157 insertions(+)
 create mode 100644 drivers/misc/lkdtm/deadlock.c

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index 03ebe33185f9..02264813a346 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_LKDTM)		+= lkdtm.o
 
 lkdtm-$(CONFIG_LKDTM)		+= core.o
 lkdtm-$(CONFIG_LKDTM)		+= bugs.o
+lkdtm-$(CONFIG_LKDTM)		+= deadlock.o
 lkdtm-$(CONFIG_LKDTM)		+= heap.o
 lkdtm-$(CONFIG_LKDTM)		+= perms.o
 lkdtm-$(CONFIG_LKDTM)		+= refcount.o
diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 376047beea3d..193b284bcebd 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -694,6 +694,7 @@ static noinline void lkdtm_CORRUPT_PAC(void)
 }
 
 static struct crashtype crashtypes[] = {
+
 	CRASHTYPE(PANIC),
 	CRASHTYPE(PANIC_STOP_IRQOFF),
 	CRASHTYPE(BUG),
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 5732fd59a227..ea6201861bb7 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -89,6 +89,7 @@ static struct crashpoint crashpoints[] = {
 /* List of possible types for crashes that can be triggered. */
 static const struct crashtype_category *crashtype_categories[] = {
 	&bugs_crashtypes,
+	&deadlock_crashtypes,
 	&heap_crashtypes,
 	&perms_crashtypes,
 	&refcount_crashtypes,
diff --git a/drivers/misc/lkdtm/deadlock.c b/drivers/misc/lkdtm/deadlock.c
new file mode 100644
index 000000000000..57f42cfefe31
--- /dev/null
+++ b/drivers/misc/lkdtm/deadlock.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This is for all the tests related to deadlock.
+ */
+#include "lkdtm.h"
+#include <linux/mm.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+#include <linux/pagemap.h>
+
+static struct folio *folio_A;
+static struct folio *folio_B;
+
+/*
+ * Triggering a simple AA deadlock on a folio, Attempting to acquire the same
+ * folio twice in the same execution context, resulting in a self-deadlock.
+ */
+static void lkdtm_FOLIO_LOCK_AA(void)
+{
+	folio_A = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!folio_A) {
+		pr_err("folio_alloc() failed.\n");
+		return;
+	}
+
+	folio_lock(folio_A);
+	folio_lock(folio_A);
+
+	/* Unreachable */
+	folio_unlock(folio_A);
+	folio_unlock(folio_A);
+
+	folio_put(folio_A);
+}
+
+/*
+ * Attempting the 'AB' order for ABBA deadlock
+ */
+static int lkdtm_folio_AB_kthread(void *data)
+{
+	while (true) {
+		folio_lock(folio_A);
+		folio_lock(folio_B);
+		folio_unlock(folio_B);
+		folio_unlock(folio_A);
+	}
+
+	return 0;
+}
+
+/*
+ * Attempting the 'BA' order for ABBA deadlock
+ */
+static int lkdtm_folio_BA_kthread(void *data)
+{
+	while (true) {
+		folio_lock(folio_B);
+		folio_lock(folio_A);
+		folio_unlock(folio_A);
+		folio_unlock(folio_B);
+	}
+
+	return 0;
+}
+
+/*
+ * Spawning kthreads that attempt to acquire Waiter A and Waiter B in reverse
+ * order. Leading to a state where Thread A holds Waiter A and waits for
+ * Waiter B, while Thread B holds Waiter B and waits for Waiter A.
+ */
+static void lkdtm_FOLIO_LOCK_ABBA(void)
+{
+	struct task_struct *t0, *t1;
+
+	folio_A = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	folio_B = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!folio_A || !folio_B) {
+		pr_err("folio_alloc() failed.\n");
+		return;
+	}
+
+	t0 = kthread_run(lkdtm_folio_AB_kthread, NULL, "lkdtm_folio_A");
+	t1 = kthread_run(lkdtm_folio_BA_kthread, NULL, "lkdtm_folio_B");
+
+	if (IS_ERR(t0) || IS_ERR(t1))
+		pr_err("failed to start kthread.\n");
+
+	folio_put(folio_A);
+	folio_put(folio_B);
+}
+
+DEFINE_MUTEX(mutex_b);
+
+/* Attempting 'folio_lock() A then Mutex B' order */
+static int lkdtm_folio_mutex_kthread(void *data)
+{
+	while (true) {
+		folio_lock(folio_A);
+		mutex_lock(&mutex_b);
+		mutex_unlock(&mutex_b);
+		folio_unlock(folio_A);
+	}
+
+	return 0;
+}
+
+/* Attempting 'Mutex B then folio_lock() A' order */
+static int lkdtm_mutex_folio_kthread(void *data)
+{
+	while (true) {
+		mutex_lock(&mutex_b);
+		folio_lock(folio_A);
+		folio_unlock(folio_A);
+		mutex_unlock(&mutex_b);
+	}
+
+	return 0;
+}
+
+/* Triggering ABBA deadlock between folio_lock() and mutex. */
+static void lkdtm_FOLIO_MUTEX_LOCK_ABBA(void)
+{
+	struct task_struct *t0, *t1;
+
+	folio_A = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	t0 = kthread_run(lkdtm_folio_mutex_kthread, NULL, "lkdtm_folio_mutex");
+	t1 = kthread_run(lkdtm_mutex_folio_kthread, NULL, "lkdtm_mutex_folio");
+
+	if (IS_ERR(t0) || IS_ERR(t1))
+		pr_err("failed to start kthreads\n");
+
+	folio_put(folio_A);
+}
+
+static struct crashtype crashtypes[] = {
+	CRASHTYPE(FOLIO_LOCK_AA),
+	CRASHTYPE(FOLIO_LOCK_ABBA),
+	CRASHTYPE(FOLIO_MUTEX_LOCK_ABBA),
+};
+
+struct crashtype_category deadlock_crashtypes = {
+	.crashtypes = crashtypes,
+	.len = ARRAY_SIZE(crashtypes),
+};
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 015e0484026b..95898de29c57 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -77,6 +77,7 @@ struct crashtype_category {
 
 /* Each category's crashtypes list. */
 extern struct crashtype_category bugs_crashtypes;
+extern struct crashtype_category deadlock_crashtypes;
 extern struct crashtype_category heap_crashtypes;
 extern struct crashtype_category perms_crashtypes;
 extern struct crashtype_category refcount_crashtypes;
diff --git a/tools/testing/selftests/lkdtm/tests.txt b/tools/testing/selftests/lkdtm/tests.txt
index cff124c1eddd..3717942e451e 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -83,3 +83,6 @@ FORTIFY_STR_MEMBER detected buffer overflow
 FORTIFY_MEM_OBJECT detected buffer overflow
 FORTIFY_MEM_MEMBER detected field-spanning write
 PPC_SLB_MULTIHIT Recovered
+#FOLIO_LOCK_AA Hangs the system
+#FOLIO_LOCK_ABBA Hangs the system
+#FOLIO_MUTEX_LOCK_ABBA Hangs the system
-- 
2.53.0


