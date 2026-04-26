Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 572E5FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 15:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548EC6B0005; Sun, 26 Apr 2026 11:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3096B008A; Sun, 26 Apr 2026 11:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34BE76B008C; Sun, 26 Apr 2026 11:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17E646B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:08:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 322C11C070D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:08:10 +0000 (UTC)
X-FDA: 84701037540.17.B545F43
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013057.outbound.protection.outlook.com [40.107.162.57])
	by imf15.hostedemail.com (Postfix) with ESMTP id 45EAFA0003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:08:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=MIetA2fD;
	spf=pass (imf15.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.162.57 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777216087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nX+IMq/sGf2D0scIZHHJGiKNDFB76Mm6WTuLYJYvNgQ=;
	b=4uSLl5w4EXF42gD7J0jVdRFBl1CwLQ1WAAkeLnv83h2P4xAR1MNf/AI+VV0TyqdaRypfFm
	FufcUlvrGFbFf/SpdeWbF6M/X2aED1jWRw7ZDaksd6Z990z/BQXw5Ajv5EJJZpxLaQIGcy
	q35cl90wbbUAAV7OUdx7NguPu4O6LeQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=MIetA2fD;
	spf=pass (imf15.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.162.57 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777216087; a=rsa-sha256;
	cv=pass;
	b=K32q4HY2DV+LEBC3y3ndKMYFXShEx8sLFkHZQJWmduAO/s+lVVFE5GQDXqDNKuXxx1fynp
	dg6ORero0eSqiyhjvxirH32E8nPB2QpSsQH68URgmEz9XnmVftzxyi0brCkVStKklieNaf
	krF8Bz0Uxewa3/syF34TTeXthMa0DqQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wbW9R/rICKINUVdjUBT7KHx5y7W/V2dKlMiZFiBBT5OhzA/R3g3GqqhNCHl+MqdHuIilPusnT276WWq708XUT8m4nmWjtXm/Al4wqbmuLRPbE9SN1dkCsYzE4GRe42k+KHGMbLT7BJPh8bCbOqJo5qFRk41wQEzGjiHIN0ZdGrfQOX3VDV+NW6bK4TuDToPgge2r5HC/tUZKuKK4FPmZylE3W9f8EbmyT7uBQGQMGilZeMEgb909KqmUlkfG5jd6jXgQMWwGEVYElBM0L47iXXcfqOWBZXYXFTeTfka+buu9aC6JhCr85rbSV87U0xwNnxT4rA8oLDqtz/ZaJ/KhDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nX+IMq/sGf2D0scIZHHJGiKNDFB76Mm6WTuLYJYvNgQ=;
 b=akl4jCCESQ89gKD8Yk/YqJcUrM1J6JFktC/QcCexB+0pjx05xhKqNuozEFymVEva5Dl/YNKL7IWm5wHRjB0pv0hpBJ1q00Wrna+8iuXWRiEP/urbfFiR5vyeWSDI+IJsFDxb5IbE6Ob+w/8z2yzUCZ9GyFE/Zjlo47lR6qp9RwIVpuAkqaVMDbsw3BIb5pVd7UjyStLdeFNTx5TuXKfteINxVqyDJLCUKUgxY1xpKat/UeyKfRNiNaibKSb/cxIClVb+b9BkdzDZjkaMZ9ivyelogTMPQRIShA1s2weyGaY2rzDZz6AVrnZW0m67NVngZCh0ZuJ3Ok87nIQ7TNP3/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nX+IMq/sGf2D0scIZHHJGiKNDFB76Mm6WTuLYJYvNgQ=;
 b=MIetA2fDbhr/MWEOR6G4sb+7+UBYQGCp/iX9h/A7Iz2CwdpqNGoJBwAdxi8NFkHOd/sVxfQyxB3xRPyHZzS4AqxFknO20UsP6U7rwts7cEV9w24XE6GCOLnJ/13Hm0gKaKyJlz2PPVxmDfiYgIoWDb4SZ+rqs1QMlm2T4dsRyUn8rU63pt8TCyXVRkYrW/wK7eA0h8Rx2PzVdBgAYQ78qjoU0RWa37X4JoFn1ZrM/OQwNlvEVI2yCLdg+koVLVyVgrPg9GCZGq54zZ6BNuDAmbInCSTaRqME0SSf66UTEO+zENx3+5n4wcAuDjJQkwPlT7OTtLhzhn5HNMAMSHbxIw==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by DB8P189MB0918.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:16c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Sun, 26 Apr
 2026 15:08:02 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.20.9846.025; Sun, 26 Apr 2026
 15:08:02 +0000
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
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2] lkdtm: Add folio_lock deadlock scenarios
Date: Sun, 26 Apr 2026 17:07:09 +0200
Message-ID: <20260426150709.181133-1-yunseong.kim@est.tech>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DU6P191CA0069.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:53e::22) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|DB8P189MB0918:EE_
X-MS-Office365-Filtering-Correlation-Id: 7130805f-456d-4441-0aba-08dea3a59c5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	16Esj9y3szUI39ZOAmx4JGewTLw/gNZE9CT8p4bKeTgpmz8W+jOWFNeXh52HSdr87n9T+dj9uqavamVs5Yo0nm7xA099fCSoGqQ+vUloih3BiegRQx5lweMMd3iyvsmZ5MrPFOsjCZYkLlgOxWb3nb/5QZvteGZwwFmFq9nc1v5DJSDMRr7n7kXDFt5O/eqJtUhLRpdreDHysGMGczhrTu0luwYa7GSGgct0Gdorrjo00speRXsXR8AGKzFUCdYmuqD2QT0ekllCjfj6nX5QHBCwQMcZs18Yq/IuRpFR/TI/ecRBHlGO7DU6UKF6adtkmamPmn+HeHfnRI8lTtzCgPpNEGHUONnnRMfrrqKo5F3mI43J/qp/MdToaiEp9E+xqW8dY1P24WlRkbNMCv1kjAgDhNkhwBzJY0x91bUL2XaTUwTTggK8Xtc1Nc8/q/mPWzCH00WkFawdwmBCWSICr8pQxa3RK+X4T3X8xBRhkxM/1mTVLwpbGj10Q6aafp1DSh1scxV+8GtvIT6yJq8hSYX/GN8npNYdqaI2yF4uF7favpaeqlRj2TlmznYQ9UPV2G6uoCWFBP9CL+/VfPY3m+piBayDrLUX5knCpclaweyLueAWlEGKChf+mlTpfZMHp9s1ZHtfcbHjA5iCAZh16DQZykilw9tV/R52RaCm8Ib9Yr0ClzR0iZGx0jYzWeyQw/+gzGwMaEp8JJa/vxYeAYDsqNiMoXeta5tHcsdanT8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FfHBVe1b1hPVjto5MR0mc5RlRThFGp61IsPyzUQw5k6KetnWKaZVtMYyp1/G?=
 =?us-ascii?Q?KOTDznIBNh8gCntVdCSuG2hX2p1yik/6JYTfPWOzzgT4AaZz9cE4DLCHLWNl?=
 =?us-ascii?Q?ms59+5n7xZrCBjn4whSg/6IOtwLxNsH+XtMlZsBrLT5YqCTaIFvvYGDcvFfL?=
 =?us-ascii?Q?OmdZiYv/gr7aQyB1tQ8lfoDu8zJLleG3H12XFx8sCg3HUh7zk7cHL7i3m2xv?=
 =?us-ascii?Q?QMx2zeSOVaZIbJsDm7w0EKSY9fHgdhnEh7zPOgUc0u8cxFPaEbzd6ef2YjWx?=
 =?us-ascii?Q?21oSZr1YCG07BbAEfB8aaFdTw+SffV4XiVw4kbdyT1fA9ndHYy6ddmcLqXqc?=
 =?us-ascii?Q?dBlM/eEINR1SIGLGJaW0gQFrdWga4dAnBKtMJwFtbp+da1+RSQBi5bwsjQUz?=
 =?us-ascii?Q?VvOXbFe2hNYKJuP5slI7bNsHiJW5HgAIVrJd5Pvx4dsQhqhZY5zgkruBPXRy?=
 =?us-ascii?Q?mO+VuBoXw95DMNB2AQa0agiX2ZjQp0BzKatqdZqXnR1L0nBb9mmIYT/wLyVE?=
 =?us-ascii?Q?SkexJDcDdtMxifSrHbtm7D7kU2uj3wbjTsqD03fV0WKUyhTjPGxFbmudLcqo?=
 =?us-ascii?Q?gUitlBp5Sw2pjZU5e/ow1iNLFuB1RHZUuiBIFcpvr6rxPHDxSarjxSA79K5L?=
 =?us-ascii?Q?s5a/tD5fxYNBjD/uHTzltFJ2+Oji/k0Cf4eni/ck+XDVUre9JNQnKS+46Qi8?=
 =?us-ascii?Q?AoDRXZ17vJS+yvuqzzYrfs4dNwznDyODRRfCqPx/YRa0H802bI5OQc/21L+g?=
 =?us-ascii?Q?uL2sTPKB7wdEDKupIqdZ1cQJjMTrEYkXwSMc0T5iEHjiY3rx5RrjgPMPZvdI?=
 =?us-ascii?Q?clxjuCa/DS7KIbsUAd3hEpCA2Vwu+Th5Y3sgirEtimq9KfSvgiKLcTYkEDgk?=
 =?us-ascii?Q?ekfaIHNuDgsgjIOOVC5dUGMXIQciYCV2YYTw6cmKBqsXCTaQHr9fxJcmQl1B?=
 =?us-ascii?Q?Kinr0LPqUwbeSqhaR61mUBk+BX8WPPdweMdIg48IxfQgME9XAg6V19SoVusH?=
 =?us-ascii?Q?wRLF1AsOVNU5Debhqa7KqDGPD5emf/E8neyu1Dm7mjR2tTNJWbUf+Nwc+nt6?=
 =?us-ascii?Q?f9yk1uJrjcSKUBWYgOSfeRyBCp2dN4g8jYF+cuwNooNepriJGAOTcxBHtKFq?=
 =?us-ascii?Q?Si5tz2lAjKKUFQLYoVFZAb7uEWTqOAezWTR0uzXrHnzu0patduVwsvTl1UOh?=
 =?us-ascii?Q?ypfK5B6MHtL6djE3Cq06Z8s6IEl5mGASnpcfbntxF8MOZMlwNQqLUkdWuaA5?=
 =?us-ascii?Q?VFFoMQNhj5PNwnSGId4X7kdjlWtxyJE4YANIOmwnCPuFSgMBSfgNz6VsM3tk?=
 =?us-ascii?Q?HWpRB/Ud/bOHZedIfqm1MxDR1+W10r8HNh2Yvxr8ENToJAkhl3zCUINYDOWx?=
 =?us-ascii?Q?TuBcT1FsvKAmVx8GEq1UdnFgz9rL9ngnmQf7zl4YZDIS/wVDLKRbWvCO+2HE?=
 =?us-ascii?Q?gysbnlfmQIcsgLpfY/y42I3ksCjnlAnI7a+1Nbi0308EeR9Qo9O9ugyfAdo5?=
 =?us-ascii?Q?QGcNQDubYbRhK26rK3X/q1kvBlGChJk9o19mqAzzpl4pqtyoItjFX+YaTMpu?=
 =?us-ascii?Q?i1ZxPfpbkKSnO8PP5CaAGY0YKafZ6vJ2Yqd6of+dY77G1MxfadKo2yIz31A2?=
 =?us-ascii?Q?TpDwUg1faer9ov9t8kRetipI71+MOLDshLc0d8tHi9I6p/yj0QRKMXiNwdJB?=
 =?us-ascii?Q?eqrnK9Ca425wh54uw3Mq+Rew0aPY4Z0fuW7Vbqzw7yCSZ3CVEaHFLN9Xvk1x?=
 =?us-ascii?Q?Yk2gptvCLMh2+cIY/uuoqdCwFcG1Z1RFX6hbdpWYVhGkhh3CKVc4AF3m+ulZ?=
X-MS-Exchange-AntiSpam-MessageData-1: mA/q6hFnPxae8g==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 7130805f-456d-4441-0aba-08dea3a59c5e
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2026 15:08:02.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7lJ1XUdjVpyhtHdsD8stmJFUcy1zAvYaqZl5ajlI0MNb7xlWDT42Av0W9ygG+5rMPbqhdP99uYUPndhnK4glwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P189MB0918
X-Stat-Signature: 63dmy7pggmqr7zjjw9554g9yxuzgz5eb
X-Rspamd-Queue-Id: 45EAFA0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777216086-514764
X-HE-Meta: U2FsdGVkX1/zK4rXvCLMNmShJIzKVDV0Ar+QmwUo3jZcvx9J9SVdqRijqBoLYSY1/asVzzPAnRNHHTirEuTS14Mgck0xo11bn48XGLA8LUcGFpCZehQhxROnvQdxFK8CKGlBIG1GzCU+hEzsGPH9A7tckIZn0aZ0R+5GoL6z7/Om8FJ6JBXqRmI95FnbXgWDTaChgxQGgRiVb094KCdXG02xIek5LtKqvDRikBUKLQicf7ekN5RlFSIOUdzCZfB/Te6B4aywB0dKRDF5J9DHsd2VppM4Lqhcd3x3ZbKlXvhgFkS6BuMM7mN3z1J3LRwqDHjwlvM9aQFBFjtYAfZSUbQIwv3QvL15JwJ78Eb+LRnT8aLr34xIL+j2wZEAPsJ1fKThHH/JC2i6jGBvosLDvQX2v2RR+4ZQN11LiS+tJ0gZfKliw4plitU9wdtFpmaoILLCFd/iRBCAo6dP5Z0r+eyuhUx7n+z7nfCh8/9nay6AjuVxDds6h5+JccrkLM0xkJyXujBQYIR3gb3aPg6t2D+r1USsPTrbfiDfSIUiatq2uE+9IbLI+CFGBuIc/YUuOkzOgCdUPv8Cmbh7ePeaXPDOB8mPsN020QVvpFVNvJSG+mtli0GjPPmCxrQeCrdYhZyVdcc3P3F0e6p7mQxLhJxomZ4gP85X8F4gLzvn11K86uDO+MuqAjomSeWjmnxH4czgp9ZhsWZendJzASqABgc0zWsWKCqaGw4TjuvpPK+mmeRBLQZ5zQbe7eGzRTwXcVf3bjn3+ArRopXN5f7eJ9nk+rXeKlM6ChKi0LtzdQWNpWQQarmbwZlYf4uiviS0sk0x5tTHAjz2ZS49/JK4rWGUPbLCt03n/2iy56VrKWjHvqc5EjJ5wgAV+eW5ITknjbt9Z7BaNQOCwW21PpPYWLYyQ7YOx8d7v4VpCVJVUVs1X8Bi55NHj+t5CAZ67LhoEL68gYkUkkOBObTV8Xa
 FdvmWp8P
 w4Xkgau+XmncEPM9EZHlwBaoYw844Ol8GP/y6+oDv02uIBABwywNOZPdeE9qNoFer8TJI7PBCpAQiteqX1h5Su2+JCDmbEuPx/lmXZM8Q8nE3D7Snbpsz0OMEKafKxThYqMaAk/uPOrOnty9AM3tult35gRbyODVy90zeTfQKZ493JbPTtG/jqmMCJVjUZZBqIQh9NdiL27YciWf8+SpYh3/yVdEV3NzMooclX9XFeGo1vSCgkqF6AklW82F63FeJneP3/TuHxop1kRrZCmxmbZxBW9vlk+HhGaElxSsdriIv7rGZgtxZKfyfmTcOVDYctLSFHfCX5XEmI+EojKueBH2AK+whht+LiSEAm5VM78nHevHPYVaLr+aWQ1wmKfSHPGAnMWCtTvkQRRPKK8cvvcmFEtIZI3xggB4CkXX+tl7iSCk8HncPs79XU1Ox1ah6ix5zoxRUAxgk6O2pdDNoPANFYkR1hN1GMTgyPik//updv/MBqM5YCezA/HJgSVaVLrYvw/13JP3UqJg+ze1yQNO2MlbPyDo/PbBLtfJ6lAacReOne2rlKXrFsguoRN5mkCvpjtsKmgwwwkiPfWDoR2rAmpnZ50gDF4pCS8VlaITuj/DonFlZAPhPB32CqsRNve03mfQFbR5xM5Tv8Y5xb3yuuqhzL8dOh5/VoiDeyNcX57UrhN0uY8eK4knRs/OZzH3H3h+0n20EuvgmMmLWJo0JaMR/tWUEz9QTb5VSiczpl7h9yMgYi9kYLmwKULUy0DhSe66VR9cEc51f2gLoo9lWSyfDSTvO9dAUfFOr0cfqUERNIDH4WXcWPg==
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
it is capable of detecting FOLIO_LOCK_ABBA and FOLIO_MUTEX_LOCK_ABBA.

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

Currently, DEPT misidentifies FOLIO_LOCK_ABBA as an AA deadlock.
DEPT needs to be refined to correctly distinguish between separate
folio locks.

 # echo FOLIO_LOCK_ABBA > /sys/kernel/debug/provoke-crash/DIRECT
 [   24.856137] lkdtm: Performing direct entry FOLIO_LOCK_ABBA
 [   24.859449] ===================================================
 [   24.859709] DEPT: Circular dependency has been detected.
 [   24.859845] 6.19.0-virtme #29 Not tainted
 [   24.859948] ---------------------------------------------------
 [   24.860106] summary
 [   24.860184] ---------------------------------------------------
 [   24.860343] *** AA DEADLOCK ***
 [   24.860343]
 [   24.860475] context A
 [   24.860549]    [S] (unknown)(pg_locked_map:0)
 [   24.860681]    [W] dept_page_wait_on_bit(pg_locked_map:0)
 [   24.860812]    [E] dept_page_clear_bit(pg_locked_map:0)
 [   24.860943]
 [   24.861021] [S]: start of the event context
 [   24.861126] [W]: the wait blocked
 [   24.861243] [E]: the event not reachable
 [   24.861333] ---------------------------------------------------
 [   24.861484] context A's detail
 [   24.861578] ---------------------------------------------------
 [   24.861702] context A
 [   24.861770]    [S] (unknown)(pg_locked_map:0)
 [   24.861887]    [W] dept_page_wait_on_bit(pg_locked_map:0)
 [   24.862005]    [E] dept_page_clear_bit(pg_locked_map:0)
 [   24.862123]
 [   24.862172] [S] (unknown)(pg_locked_map:0):
 [   24.862265] (N/A)
 [   24.862333]
 [   24.862382] [W] dept_page_wait_on_bit(pg_locked_map:0):
 [   24.862501] [<ffffffff9af9a5ae>] kthread+0xfe/0x200
 [   24.862618] stacktrace:
 [   24.862686]       kthread+0xfe/0x200
 [   24.862778]       ret_from_fork+0x29d/0x2e0
 [   24.862871]       ret_from_fork_asm+0x1a/0x30
 [   24.862985]
 [   24.863049] [E] dept_page_clear_bit(pg_locked_map:0):
 [   24.863158] [<ffffffff9b98a03a>] lkdtm_folio_AB_kthread+0xaa/0x190
 [   24.863301] stacktrace:
 [   24.863369]       lkdtm_folio_AB_kthread+0xaa/0x190
 [   24.863487]       kthread+0xfe/0x200
 [   24.863576]       ret_from_fork+0x29d/0x2e0
 [   24.863661]       ret_from_fork_asm+0x1a/0x30
 [   24.863767] ---------------------------------------------------
 [   24.863898] information that might be helpful
 [   24.864008] ---------------------------------------------------
 [   24.864139] CPU: 2 UID: 0 PID: 928 Comm: lkdtm_folio_A Not tainted 6.19.0-virtme #29 PREEMPT(full)
 [   24.864145] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
 [   24.864147] C?all Trace:
 [   24.864150]  0<TASK>
 [   24.864153]  dump_stack_lvl+0x69/0xa0
 [   24.864162]  cb_check_dl+0x6be/0x760
 [   24.864173]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   24.864178]  ? lock_acquire+0x26b/0x2b0
 [   24.864188]  rbfs+0x138/0x1c0
 [   24.864192]  t? srso_alias_ret@urn_thunk+0x5/0xvfbef5
 [   24.864203]  tadd_dep+0xd6/0x1mc0
 [   24.864209]  n? srso_alias_retgurn_thunk+0x5/0x:fbef5
 [   24.864212]  h? __pfx_bfs_inito_check_dl+0x10/0mex10
 [   24.864217]  i? __pfx_bfs_extemnd_dep+0x10/0x10/
 [   24.864221]  a? __pfx_bfs_dequgeue_dep+0x10/0x1in0
 [   24.864225]  ? __pfx_cb_check#_dl+0x10/0x10
 [   24.864233]  __dept_event+0x489/0x520
 [   24.864241]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   24.864246]  ? lkdtm_folio_AB_kthread+0xaa/0x190
 [   24.864252]  dept_event+0x99/0xc0
 [   24.864262]  ? __pfx_lkdtm_folio_AB_kthread+0x10/0x10
 [   24.864267]  folio_unlock+0x3c/0x60
 [   24.864273]  lkdtm_folio_AB_kthread+0xaa/0x190
 [   24.864279]  kthread+0xfe/0x200
 [   24.864285]  ? __pfx_kthread+0x10/0x10
 [   24.864293]  ret_from_fork+0x29d/0x2e0
 [   24.864297]  ? __pfx_kthread+0x10/0x10
 [   24.864302]  ret_from_fork_asm+0x1a/0x30
 [   24.864324]  </TASK>

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
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 drivers/misc/lkdtm/Makefile             |   1 +
 drivers/misc/lkdtm/bugs.c               |   1 +
 drivers/misc/lkdtm/core.c               |   1 +
 drivers/misc/lkdtm/deadlock.c           | 149 ++++++++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h              |   1 +
 tools/testing/selftests/lkdtm/tests.txt |   3 +
 6 files changed, 156 insertions(+)
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
index 000000000000..d244767e3ebc
--- /dev/null
+++ b/drivers/misc/lkdtm/deadlock.c
@@ -0,0 +1,149 @@
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


