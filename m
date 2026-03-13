Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09B5105F79F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2256B0005; Fri, 13 Mar 2026 08:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136576B0089; Fri, 13 Mar 2026 08:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017246B008C; Fri, 13 Mar 2026 08:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2FF46B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:06:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68B74B4B4E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:06:24 +0000 (UTC)
X-FDA: 84540912288.21.A9B72E3
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021084.outbound.protection.outlook.com [52.101.70.84])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6DDFD40019
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:06:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=BjQg55tq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf07.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.70.84 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773403581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gVgvstBfscKTyP21AE/OEE3wrVQLjb2R0KPIGOqFS4=;
	b=DrDvzEzCaCBRCfsymtxbTBNEnvMUO1MHiKswhEzyO08SPqnas+qY/DfhDvCOsHKFTaJZLx
	D2M+DgKmoM0OLjOO7M/a2dx/EJeYXJrdpH7O1IaWHveWhmYtdVbP7ozyqf8il38X49FKbi
	cyROCau7nlbo/4dYztvbVnBOuuJVri0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=BjQg55tq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf07.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.70.84 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773403581; a=rsa-sha256;
	cv=pass;
	b=CveddxBfUWxZjVjSaZmU3bK6qPgaus9gxHZwq8TV+T3wLOFnC19Ye2xzQobHaEPVmqV5TZ
	QwSF6AO7mM8iifQzwT0TJBwZsFJJacS8yrjKhZA/K4RKPCQrsKiHZDem37u+RIocGLt9so
	RgnnjQwZFJfdpEZ0DR2Sp4vA/oyeCQ0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQs2J3NyXZSBNj+2B5lkoceN7xbtLvkcF6woBeYGlK5ckmWXR9+p+EsoRvq0jB5umSV2+yI1M0pjhNCd8LAVUgfFyM4PSAlACV/kRX4T72UMigW/Pizt0EopT0yV61FO+cHRIn4BeEi+xRc16G8821ZOpdtaCDqslIhRJwSemhAxmDoq8D+fJ+LX0ZWr6BxrLNJ4r8k5i4uoTi/x14rAaOFqkM2Tsr/HqxkZkzzAUccONxkU9KFZCCzJIfzkdY+5aXbPvbBSI6F61gJLIDTrYyaMWmT4c6ONsX3iY7+eGUifCFI8qhCeQCD6It2H5srHMsbH46i8k2vpzPXSQpxH4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gVgvstBfscKTyP21AE/OEE3wrVQLjb2R0KPIGOqFS4=;
 b=G93EMyzJ107VqjvOND68S3FBO4P/uvvnDBWk0k8+OwdqT1AfRf4l65qs4BKYlLEr++1aHXm8j1RTAb5PRhsiNPiWkacYI3PzLXJ+jnw3HCWNBLl9q9CKcYlXRL603n7MkNX/Y+ZrpglUpNIpFKD4uk3zDXHWl2sm0YxASyQ+yYotg2wB1pQTUxGrgnNffMx2EKHbjvuNGqFpbIHfErQv2vp7DYtcjNg6Q+PgsfDL7Qol0KkEDkDLFCTJUBznK3qfeu5au0Z5pkuB1OFg1pf+BHUKRMeyZprPzd1iM+EDk/t6cfZKrSnRhMheyeCv5rUM3ssHAn5lnRRrs/c5T/Udfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gVgvstBfscKTyP21AE/OEE3wrVQLjb2R0KPIGOqFS4=;
 b=BjQg55tq/NTWhi28GSP2UO1Ytvl7ozeNrk7BXQKqrPLsWYXYIQ/5MNuqeU439TtrciTEkG9Ywozq01rAvmzzrzUHB6H2CrhJR3vssyT37VfWGmA9vq+Ypw3cFw8CIb2OHSVTpPhG7xANArbAnpDJIX58KMaNP68yCnj4yt2RH/EgLGRKkVWD2C1zNbxhwdy36AKBbOxj3tJzO0hyPFN13tVwaS9VfE+uGRD3PTQf2R+3gHHpPRplcuDUfZ300dR3d2/uE/iG6uej8Mr8X0xaX0DUgY7Ixrq39vffS/MusCc33er3xPmsT7jua3WcmyRwx33esWybRfAPae//DxBhbA==
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com (2603:10a6:102:341::8)
 by VI0PR08MB11199.eurprd08.prod.outlook.com (2603:10a6:800:255::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Fri, 13 Mar
 2026 12:06:16 +0000
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a]) by PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a%5]) with mapi id 15.20.9700.013; Fri, 13 Mar 2026
 12:06:16 +0000
Message-ID: <60017129-4f3c-497c-b932-c8e278603d66@virtuozzo.com>
Date: Fri, 13 Mar 2026 13:05:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] pid: cosmetic changes to alloc_pid()
To: Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mjguzik@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, brauner@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260306190100.1900572-1-mjguzik@gmail.com>
 <aavuocRuM2Kmwj98@redhat.com>
 <CAGudoHHgTA4-50qLFvptDmg1r9FB8G0TxdX7OrWoRoHgtZW_HQ@mail.gmail.com>
 <aawV7-yjMAy8TF7h@redhat.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <aawV7-yjMAy8TF7h@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::7) To PAWPR08MB9008.eurprd08.prod.outlook.com
 (2603:10a6:102:341::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR08MB9008:EE_|VI0PR08MB11199:EE_
X-MS-Office365-Filtering-Correlation-Id: e5fcfa1f-6b45-42d7-0200-08de80f8ed7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	E8logUzGoaXwW/v4Dr/MPdSLtcV3NUjGmm6FVPLJ9OiD+/MV+tmrl507azwl3Y2d+v3gk6f3ZKYBuP5AyFNraYjO1SVI9Ks91ThJn6JiA3dVlOfRk1lxvHepBVIeIJi2BHuHKdBQUJmnoiG7b5uqJd4KjxPqisiQqncrMFv980HxxnRjOdMWAWrkMZfRFP/IcRo4eq93jTbhdExXQW2PR6AiK+bfZ8Ps4mcIiKnS7JkaLGMGNtp4NuAaj/HpRnYdfOZTWeY1q0D7tsLGtvH6H2zaWB1crARUriBJz/DzmkEIe8jK1qDhjE5M8DQ7uiXCApSPryEdKAFLG6G/p6BHIbwX2PNtVtUDMzNgEUrfmew/vnNzz5QVGHTCb4NhLMA6f0LYV93Skaa8HpOye+rIaRJhf+MaUX6vRhznuIwpO8qgIm+eOBy6xUiocQh+P751ECVD9nLGOd6fFvaa37drvUaGEGZiCE47QjsZcOh+FwJ7MoHwcfK4f1XlEeByYPC4ZzrVu7vuYMFD7UTD/qiOb6oW0LWLcLidmEajFuq2jlSnciTIKOGGvS8b35n0EDgeLLcBSnqhmb2XJEHHRaNYTrVDXesFKC1XPc/LSLH3DUIw2gyRlMHLp46nKxuMkKd59xdarnoU0Z+/1NnsuaaQ796+xfgISLENNJRf6o2V1ChMlyZKjbCb0svEFrzHv7ks4KpCxSggNz3L1ugFKMsK3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB9008.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUlOa2hBZXYydkptVU9tR0U0LytwVGxWekxHek9CekZkNS9PVWVYTlZsdmd6?=
 =?utf-8?B?RFplcVVzaE5SczFMaGpoQVVadkt1Mm5PdFUrdTB3MVBoYnk0Q3FzbU9Pekph?=
 =?utf-8?B?RDgzUmcwU3pmOGtGVVFrd2MvTWRldS96U0U3d0dUK1BOK3RQV1VOUlRCa3Ja?=
 =?utf-8?B?eVhxQjcrVlNOV0pDRUlyRDMweHRKRGF4L3lMVElCbFBCcm16ZGJ1STErc1pK?=
 =?utf-8?B?THM0UHdzV09ETEpoTDM4WW90TnREaGJsVmRSdEdOOSs1T2NnN2x5ZTM3L3Ny?=
 =?utf-8?B?VHhXVzNUNVhSaTNBaTZ3NDZGc2dWalZzMU8yNnNGWmVmVDdNcy9VVmF1a0Jw?=
 =?utf-8?B?WlBDby8yTmI5c0hVclc2ZnNqN2lDYWpFRVlacVl1SUsvdHRBMmVVSkgxYjRv?=
 =?utf-8?B?azVQQmNNYmEzMjdLbUpvcTdvR2hZWUl0cFhaZU9Oc25JeWVTMmdoQm1PeXB3?=
 =?utf-8?B?OTBqT09WbXRTaDRGNXBmVzVUTDBzcDAxUVhuZWJNQkgyWFpQeDkzTnVSWE04?=
 =?utf-8?B?VS8yTW1mTkh6clBZdWNPeTlpWVMvWmh6Ukk3U21LK0JldzhoS1VNMTlnbklI?=
 =?utf-8?B?UzB5VDdXYWh1cEhiRS9LT1VVaEhhNGg3Wm5SMlRmVGVmWFJkTVd4dTJkV2pl?=
 =?utf-8?B?cFdaTlkrRThVMUJnUlkvTE1DN1pIY3VhaVVVQ2dRWDFLV0JFVHdRMHJsNDRp?=
 =?utf-8?B?WUVFUnJCOUJwNnhMOGxLQU13cEJDZzArRlhQb2FacUJaRzFFV2lKMXVEVXlK?=
 =?utf-8?B?eDhpRzJYK29YR1hiKzMxUVlqZkJoN254cC85d3RhcDhrWVBYSnBZZ2RmZzRi?=
 =?utf-8?B?Uit6TFRzd2h5NllNVlIwZmtCc0E0RjgxSUhsMVVXbjhoeHd6UkdrbmhxRis1?=
 =?utf-8?B?VXp4SGxrc21aTjRzMFkvU3RhYS9MVUFBRzNkeTNWd1IzS0ZMWjlWQkZPeDBN?=
 =?utf-8?B?ckc4bDJQeXFBc1N4WnVFemRjVndkbkQ2WlVrM3V4YWl6Z2sxWjV0SStZZVlO?=
 =?utf-8?B?SThvNjNmTE1xMktROHAzSFZZTjd4SjVyQ0FjUmtHaElvTyt4YmZjVEtxWXhu?=
 =?utf-8?B?NFRsV0VBdnc3ZnIraWg1ZE5aMWxJTUFwNzVxcTRGTzgyNXQvaHNYVlVSWEE5?=
 =?utf-8?B?dCtib2tIdFlWaE1TS3c1QWVuQmUwUGZXYkI0OG9EL0xaR0FOYks5VzN6RWdI?=
 =?utf-8?B?TW90VGRwdkQ3NWRNcmJORkVkODNocEFuR200aXN0TUQveXI5aXQ1eDhwcGNq?=
 =?utf-8?B?M0IyaTVUcEVGaExBMzhLc0ZiMjlsVkN0MFE4eGh3WC9DZEloWGxPazBuM2M0?=
 =?utf-8?B?UmM1RmF5ckhXZWxnSUtBazBGSUpSdFB2M3ZhRDNnYlMwU2lqZHN6ZUdDeERx?=
 =?utf-8?B?dlUzaUoyMmlvanpGbThpUEN5ZEcwSlNWYkdVTThBayt6czU3eGR0SWYzTUdU?=
 =?utf-8?B?SW15aFlOMWt4MDFiN2NNQzJjRTlsV1Zxdzg0MXdhdDVZMHN0NHdiY1dIUkEz?=
 =?utf-8?B?QjJhMm1sb1g4WHZQODdoS0FjbU9OMkFLKzl0TUxOK3QySUF0K01pay9XZzZS?=
 =?utf-8?B?dWUyNmFVaktkblhhWCtBb25JdWIrcEpmYWd5TlVuNDhmSTVzTTFVeDQ2NVRF?=
 =?utf-8?B?VjltdlN4NDdyVWRUUk9aS1BiY0p2YzE1Vm53Rm5vMTNqSERwNlVCZE8reDF1?=
 =?utf-8?B?blEyclhBVERHQUtUQlhvV2g4Nk5yOURaeWppb0pMR1Z6RUlaVm4wMHNaaGgx?=
 =?utf-8?B?SjhlNzhQTElaQUEvVW90YUFvTE5FWW5sVUtXRG1yYmZJYlM1U1oyQmUvMEpY?=
 =?utf-8?B?cytadlZmYzIzdXBUNEJSK0FkejMxQkZxTXhPdHZpR2lOcHpBUVpaOGhLVjdP?=
 =?utf-8?B?bVp2dmdibi9Wemg5SlB4ZzRsWVZWZnVjR3pIaTdteW1GWU16Q0lVTjRrayth?=
 =?utf-8?B?ZWNRbE1hVi9zTXNtUnFlWTZJK2NhdmIzbTVGRE9YaE5uT3JqREtXVEJUL0k2?=
 =?utf-8?B?bTVQSUloQmNrMU1aN2RlcXk2K1pvdEJDSnlIZk9IaWpDQ1JXUDdpN0dvYkt6?=
 =?utf-8?B?QmVsSFduN01Kd0pEQmZHdVhWeVcxTnVEcHdFRDZ6c3g0NHBiOVlncmpEMlh0?=
 =?utf-8?B?elZvdVZDMGhYaFpOS3JlWE9KNmpIYmVvRHJnSXRGUTJTeGdxV1FrQXRMbVY0?=
 =?utf-8?B?SDhjMlNCeFlFaWxYbUZaYU5rOTRyR3Y1dlVQQWJDREV0b0pDSVVyRlhTOWNn?=
 =?utf-8?B?WmZsT0F1RFpiZkpPekphanpYQ3ljbzNnUzZxMDRGRUx5azlVMzJIMWQwQ0tP?=
 =?utf-8?B?V0d0N3REeU1Ra3MzZHljS3FtNmsxQlF4amtTdllUL2FLZDBjYmhqaFhIejJ6?=
 =?utf-8?Q?Smf842x7gu/yU4o27U+5NLlfIM4HXKZmg2fE26DtqdCw7?=
X-MS-Exchange-AntiSpam-MessageData-1: fQDPNDnlDJsqEN2MNO+qU0mzDfMK8AkmYUQ=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5fcfa1f-6b45-42d7-0200-08de80f8ed7e
X-MS-Exchange-CrossTenant-AuthSource: PAWPR08MB9008.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 12:06:15.9719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1t/4KS5L8Pe/ftFAO1bY2jIu9D+z6pbfMGjUreIhGoZ2rAcbpsaRUX8eyj+0ag5cxVpLtDKTImAuAgkGo1op5PI/r2OKV9l9DL/bE8qk7Jg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11199
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DDFD40019
X-Stat-Signature: h9j3wtfz8z6gt9wrsi439jyef5e7f6dz
X-Rspam-User: 
X-HE-Tag: 1773403581-208416
X-HE-Meta: U2FsdGVkX19PY7MKJcmNMqYD/ddwmriO++HHhaSdjGhcpOkowcow8jSHEgAYUC8M1+wJ1NvNLGHVBY8Ky4aTpJHqp/CQcRc66GfdEX/FIuO+A1ERngO+9kT183RZA1uSAxfuWKczgQ3GrRfB7KBpGHObzswB/7GR+Q2czGyCtvB219kI7Db9cy76y1zsqkFVjwTvV0Y2IaLbTq7lzKWALV70V+AaI0XP+h/gGGaIo7Rnwgf9yfEdJf4goJiwlsL3XbLyf99SE1iFb24ChKq4nxuDXCrQ984CRNR1dgE/V00Par54TEN+vchCENAPKbB54U4SjqaeZVoTcnAWi+eMZBS9KCV651CLGluu8LFe0XPqc7otkNKgz8BoxgtXae56wtdXFvsJp6ouUqe3xme4vkunneISExsFV2BpCYzVRQKAaX0I3OB+UhgX6ZW51IJl8Nh0ST+ym3L/f5w8AYBFN4wWEzv/mdST0PPChbUdy1vtQ7Rz2cplZbAvOgjfS7Rz9Q0IUPTIV/kSZ91zYMw/zN5rNRKm+PPSybiApgkatQN53Zdizq7a8bSMPMOQat3kBV75r4kbCR5JLqMyeJnPHLIy4gDS19WtdfrnOI+WIjuhJLZqHpVy4kPyTHko5O0HbNpVOVsfjnkTy+k0vDuOKPFy92Ekjj5PZ1RGslwJxJ25Mor7dv2d5vHYxQu2bMf2SMQFzNrh6tT35Np/ccNnSHYhnurQbioQd+/FbaDwBkb2iSTMJ3nA3y6LaV8IKcRa2H3QrPnQD8k7q+8IYi3pbnqfO97ZUh/+8rf27qy04WnrRB5RwmYYuLpEs2V8mfSmz9MODr9BFETViVko2b/MPl4P94FZ5L4KucjsEbpGwtkmnZf4DcqARi1dIt5I8htATHuJwp6woTMk0zEjZmYBK+nWfCyfVBID1TJWbHW7ETUG2tJBXWpL6y1aOypBYQXldu+aFbLMoxCRjcl2amM
 pfHAEB4C
 uOTksGcLpmzfHrPcvTvxnALW/mJKo/OV1cl1s40d+ULFdjR0O1gWMmJXpH9cSVSwNxzvQr5DAVqiuzy3IkYleRlWCXwK3yXpM5pTBL61x2gvJKnEDq3C1/bGr4YNXUYzvK4qKctrDTbGchn8T35O/IGJIq/yQHylcCsQ8t5kFbk2slUR6y03fRrWHHQDXov9/qR+sXAXeFPB7S09/oZPUnELlJMlztZuZoGd5snqDO87fVnBg0i0iGSPLlJVKId6QOAqsRUam4wNCgyLUTLuHkB6KA9/J/OiFNoIZmlWAz0Oh4wHjEQCJ33d0ZdTEnotoAnqT61DLAacXd4+RUiw1uqKoKT4M3TzHrr1WxXx7klILy1WfO0QfS7l1BFQm+3vGUBIeFSqDhn6kQYS3BilREp5getbA1vKRiftqZ0AOGsLkFwkMja0b1E6bYTNnKpLz6DibbyrNNFplkTqgO4NbnC0XcfrLCtOR3diRKZnA9EpiRR2C6uzhKrxmlAIwxTh6SsSClYF38hNu2AZkMKPlWcnmaafTinN8aYITtuitDdWX4bb8NZ4QX5Oo4NCK6MtdjOXYnxlXo1HbwlbEMo8lcygb+YaoVpa+rWR2A18XuybCu4PEcqKzv9F4Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/7/26 13:11, Oleg Nesterov wrote:
> On 03/07, Mateusz Guzik wrote:
>>
>> On Sat, Mar 7, 2026 at 10:23 AM Oleg Nesterov <oleg@redhat.com> wrote:
>>>
>>> On 03/06, Mateusz Guzik wrote:
>>>>
>>>> Commit 6d864a1b182532e7 ("pid: only take pidmap_lock once on alloc")
>>>> landed v2 of the patch instead of v3. This patch remedies the problem.
>>>>
>>>> No functional changes.
>>>>
>>>> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
>>>
>>> The patch looks obviously good, but it conflicts with Pavel's
>>>
>>>         [PATCH v4 0/4] pid_namespace: make init creation more flexible
>>>         https://lore.kernel.org/all/20260225133229.550302-1-ptikhomirov@virtuozzo.com/#t
>>>
>>> In particular, this change:
>>>
>>>  -     for (tmp = ns, i = ns->level; i >= 0; i--) {
>>>  +     for (tmp = ns, i = ns->level; i >= 0;) {
>>>
>>> With 2/4 from Pavel we need to decrement "i" before the ->child_reaper
>>> check.
>>>
>>
>> That patch will be fine as it modifies the other loop which already
>> had i-- towards the end.
>>
>> So I don't think there is any need to rebase.
> 
> Indeed, I misread your patch, sorry for noise.

I looked into this patch and also confirm that there is no conflict, with my series. And in general patch looks good:

Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

side note: I've sent v5 of my series, since I found one more place to add READ_ONCE, also based it on top of mm tree. https://lore.kernel.org/all/20260313111014.2068913-1-ptikhomirov@virtuozzo.com/

> 
> Oleg.
> 

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.


