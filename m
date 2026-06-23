Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7995CCD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675536B0093; Tue, 23 Jun 2026 07:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626D46B0095; Tue, 23 Jun 2026 07:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516546B0096; Tue, 23 Jun 2026 07:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8C36B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:15:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91D74A0460
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:53 +0000 (UTC)
X-FDA: 84910922586.13.51B17F7
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021092.outbound.protection.outlook.com [40.107.130.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3960CC0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=fvkY6RXT;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782213350;
	b=de+7BcH7eE7IiXfJWtjhed/aL/Qz4KP7CyX443oYchKEcaidBKxN4CP9KFIb+HPCxSqGrn
	19mJl186ZeRSw6eDaXnBzoAA43zh4dt0s2rprqRYOsHR1klyEupcXPFXCAxsKB/DMtX9Ei
	TPKpopWh/KE/gc1g1r6+DcpjpdQhWaM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNL6kNdFYHyJdxmGG3JO4sSEoVfEqMl/8XnSCknIBys=;
	b=M4Tf3KofsjRTCNxlQIGRR6vb2pojB918KJaU42BVzCssYvh+pEaQ/OVXufRPlDExTFP+g9
	0h4K91h5n14RLOlEaPliW9BDr5AkO75itFLnYtet+vvOBpGpFDhKuLuIHPIHxGUEtFcYEb
	MzYmQsQ0riggVrEgLrbxk0d1QDfR5g0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=fvkY6RXT;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W32d+4DkLvtHgY2ANaRwvw1bx9p1dqm2vj85OpJYUh6ieeH6WMZZynoS866UpX9gUzSw5ENXfGLUeX1OXuIXEbUWS/r7/kgE574/09rviz7hQIh1gJGNUNo15IXnmwu3ejFJAuHmvawiErgv7mTrMR2NMkgxYDRDkZ8wn0o0DG4TnOXMdo/6xEdLqpZB2ys1Y5y4J/9r8id7DrB/MeRifj9/kuAnbTW/vo/NuicemYOazOspASgCTDh+wQKG6RdLyQwE08pnBu1FJhUHovt1bypQtVoLYBhTL+TluIuiwBYNA9T7BvND420E/a9ACWqpkz7m4IlvmIXRK5lLjKJQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNL6kNdFYHyJdxmGG3JO4sSEoVfEqMl/8XnSCknIBys=;
 b=Z1d/dLDfy1WONHW5BClpAVJQ9YYUE7PoLDFL9FmsslM/Kn1FZcjLmI/bddz5E2+b4JTEUFUzVFLAVLdPYYU9xv1IaNBr9Zc+2akfwO+tF7+b6Au83VRWXUvKHYIGW7Iy7WYSbu2bDE6N6t17sK8itiZ5c3XTuWx9XavQH7wR9rF9Ef1HoEbNMOW2eDQX+5+58mhzmgHI//UwwDyR/Q5TYP2R+Q1wHEGGEIFe6JfVCuYaHoLzjNMDlCLz2Wh4wRmwgVp+HTheLe3wZJmOIhB+XJCkvjKMNkfT0ALsRizWsWKH1waasmj6ZNXFOLjbHfJbQw/5w4jwrFAyMMv6QvDV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNL6kNdFYHyJdxmGG3JO4sSEoVfEqMl/8XnSCknIBys=;
 b=fvkY6RXT5zxfd9HHYlrSzh/ErgmpV7s/3teD4RxEM0HhvY0fJtbKUEVJ5gRpDV66H/IO3j138SSUO7p5onAHyz4O+VMh9NMhaKnLGZhZ6O93/plquqSnhTTlXvXM7j82GeslZbmYm/Wm2OUjljM2ThnQLLkMEasd53vQhxPJ465dehSPanj/0JcScWokEAgnEzMadB2BPadNVxo3kKvXHwRpAKNfu93Z8Zv4u03dWUAPmPW4MazWgcr3+5MgnJ72ow3IeECY/5XfXCOek0KYVBU5aJeBTlLUmhQEBo6/icp2XGQMEsuw8SJ8Z8SeDnxx9kSqESDf/BqxYNbwyq9rkA==
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AS2PR08MB9974.eurprd08.prod.outlook.com
 (2603:10a6:20b:643::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 11:15:44 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:15:44 +0000
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
Subject: [PATCH 1/3] fs, mm: add ->cachestat() file operation
Date: Tue, 23 Jun 2026 13:14:48 +0200
Message-ID: <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8e219f8f-84ec-4c59-1cb2-08ded118c4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|10070799003|366016|376014|7416014|52116014|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UOUviKdFgvEojmaCAeJfMvKK9ajEjQoOY6fK38knpK08E3MHpt9lxEo0Y/ZLpxTiBYiHQta/ZtNMezFXGiCk6D+3h6okhYYb80xgle14ONk1VJff046kT2Tt/7nTTE/gusQZofO4q9NRwXE323J/ubTsQq+iq8uFdfKubizvwUwzia3NF5EdiLgK6xuggqIvc5FSgPlJUCWgbO1L8hEqgRVEy8IPGeKnkmZlkSJDgIc2st4AS6bK+HuPG6RCDkI5UNlhEznSEQec50SELW457XcbnMbtawWZi3wex3godZbNyK8ZcPsH8FMkZ/L+PrzlizXobqMXD8yUuokVuMjLYIVdg83jJe/39cQ9JONh9DBpK4HJDvtLOxI3WEQ/6OtwN342Nm3x5U+Ac6tkXUaWX6YbjB/+YExlh9g84DKA2J/5CqhoDDYLwgSZZGhweF5KJfwCL+XuOCD4SNlQOKOcE0u1MqesNAH0Y1IDJ17IEkEJO8nrJHdGEX31G2g31GH5JY5YQPzYCqX7CxT629ZDjdJ97S2dcV6cKezf2KLekgMyjGbf5+Q3dWJ6GvLhyrEASx61QBIHfVK7cR2YsEbWSEYPYJeiAFMz67DAST6qkn0w2a4r2ar5rAjpGXooSWHoUlf3gBovnk9/R7Ta38SVOji4SBqADiOKn1DU+ZbagRI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(10070799003)(366016)(376014)(7416014)(52116014)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7rWtnG3Kc1PZwEuTXJzRE7mk+LLHDRaurvVJHqaiTxNy6Y+932nlZMxIBpQf?=
 =?us-ascii?Q?oHX5GYzseAjpJudQ8yGjZpjR6j+UPm6DKIZUPrmw/qx6EGgSreiTVFH2tsAl?=
 =?us-ascii?Q?T2moIAU7Qtezr2FUs0yZhtSKK2nIUirsaTzAIkBMdJdjlMY2RkJNWLHZcWGr?=
 =?us-ascii?Q?sJWjIQXXyauu+65racOxBrY/96FN03HKttgYVaO8Lc0QSMB3kePb1cAHxoNJ?=
 =?us-ascii?Q?Kb3I3zActb+uYYrwJbbQQ5WKxQU+ZM8i9EIehELIeWw4I0JKxfzV19QyGN32?=
 =?us-ascii?Q?Ho9GKnqQrnYoL8zhE1opY/M5iW658mkplwi0YxlneZux/xo4R7p4CGfDJfSd?=
 =?us-ascii?Q?43T0fuI2qIK6eSMSuiYr8/hj7pWaAGGgkcP+g5yK0hRqLltxfk8ghkFD3Wn2?=
 =?us-ascii?Q?fCfMe2IudxYscRKHOaz/WHEE2WEeIbfJdW+CJW2O5HSXrOzT8UT4Ix7viYM/?=
 =?us-ascii?Q?f+NYYCqKF8rkJXSsWRRFMkuyIPSp+kscMsZVolrUX16tJyn8L9z7zuj5wqOD?=
 =?us-ascii?Q?4qghOCtDT5/lX8szjOqS4sjVAZJ6gsO5p3RuhuTgs3Dn0HQpN4QUDl//8vBD?=
 =?us-ascii?Q?H+VBWmHcaWL1BoZKRvptNU9U69UJ+kW4WKUlOSEOOfUhXPLdnYynLzToVmh4?=
 =?us-ascii?Q?FtbwHETIqJp5t3mwdQrPcrKaJfT7pmyK1eySRqguoGbqw9Wh96c7Fsjf/ZiM?=
 =?us-ascii?Q?7yJFkKVosXOBt8CZEmpadXKNFjhCujMP1Y0htgBHNxgDremkWc++ibVOgdm8?=
 =?us-ascii?Q?c3VASGnTu8faRr/CfyFozfVPxP40zVpH/3g13rTw2LLH7hADlncUl3uIMWwh?=
 =?us-ascii?Q?sjpVRodWKXeUCidh2SddyuxQewYyT75oJZr44csGGclxIj2MMFFzlc4F3dsY?=
 =?us-ascii?Q?Tk3BsPPC1qmRn1zGwCkWp1oEs7VOjO5x/IqujXHBummip3z6szwwGgpA3OEJ?=
 =?us-ascii?Q?ZZ6P2+Dyz9nepfEGuDuqHfBzfoT7hhIGYZ610HS3B+pEfSpqSebU2ByCLrQW?=
 =?us-ascii?Q?t6qSQlYHtELPu4a1g3SrxPG5ZPu7Iil1ssY05VN6upLtxLdp8ClseQxzeNUj?=
 =?us-ascii?Q?tZdN3jSi64BP8bTJiZqyQ8e4iLLdoaVYAlZw3OIDQDkWB7YxZ6Qr9M3ewVvH?=
 =?us-ascii?Q?1+ge7sxa+PFbdSHq29S1sk+1Qd6YN7J4UjJJ0lOEw2Hw+E+Maenis3cTVmfB?=
 =?us-ascii?Q?D6Cf1w8EKvtutzHq8RPuiAVfC9MqufCt2xV1kn2C/2E9OfypPv3/2yYZnFdZ?=
 =?us-ascii?Q?/LPI8vOpSLmro8m5VFOgJ4FE68UTtsOluTtQnNXqbbHTeJgS0i17S4GGpX7N?=
 =?us-ascii?Q?+cbFnJ6w950Z1tHGKflo5Eu3Amwq2mFr83bdnrSiujPP6pGK/B1mzAaMPehh?=
 =?us-ascii?Q?/qDy1EeNNt2rXs4sj9TM6W4G55GxSzQ27KvhIlnTlbV4sN6FepQrsOdTb0FA?=
 =?us-ascii?Q?xj+E0iiN4NkmSzF18xHQRarIiP4a8v8gRTIfTfDqBFJ9O8CUVyzk+RMTRamh?=
 =?us-ascii?Q?g6N8d5ynkUSYeVkHF5QUbZjyMEjh3HjKA90ZPR8vBf8XYqmo9DgFJRj+DtqP?=
 =?us-ascii?Q?KsXUnT78eOxA2UdDL+VvmyXTItP6Toz8TFDTUfKg9sAMI708krBCY00h7upK?=
 =?us-ascii?Q?e7y8hTiboH7Rs37BaDra9fwIfQrwutdj3t5MTfc4MWf8fKRSioXo2DFqM+Cp?=
 =?us-ascii?Q?iapWVy1fZxvpTYBR4YXFs6puM2GOqRhTTkk0QxM3UAZ14eZYrafcEC7ePXfG?=
 =?us-ascii?Q?4XHIQL8fs/ecOuzxSRHbRPo2DjxmYPaWa0c4WNbWdYEbXXsAyR3dLNfywgjS?=
X-MS-Exchange-AntiSpam-MessageData-1: A4kQOLtw+UFmdiFuM8k3V0d1HmtgkMz3irU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e219f8f-84ec-4c59-1cb2-08ded118c4d4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:15:44.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MMft/Cd4YgrD29zlTfGXEfKzya0UVwYW1TYaoNMY1asZV3xQd169rBcZyT8L0kqvkoQTnzaTcnSOvJ6ax/VITEM5/9iLiSPAWZhnVvM+Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3960CC0005
X-Rspam-User: 
X-Stat-Signature: fqg83cm674aybmukt1hymr8ur6j8zbey
X-HE-Tag: 1782213350-425548
X-HE-Meta: U2FsdGVkX18MOcBg1zdAUu8K6nCHl2pZfUJpaw+uQ15FnyyYSPmMRIcHJF4O0dmrx98b2tqJhxXT2I8dC8I9lu1FP3c6Mp3iCEyjsvxXSEZvf4SwZBVMSG4mucDz96OJDJW3RDXmrwSiq510cyHPMhf1ITgMQq3Yea6qmuDOBKj1vPTRprIn8J+iSFZkHEalNchi0dORer/JL6cdWjK/MUHfj0BV8di7tfyK2F3fmlCixFW1V/pQsZ8JL8v1XT/d7d069ebk+rlaLhGpCNtmJkQ4DCDXkR/zCNdzVxLygqALI00TL5XkkjhecXZ+OJcUBOpsHm7lG39QOGnCAH9J4FL4nvT+HYbj5NcLFIVc14IKjHdLun+e0AOh3gcO/F15YlGndQ0HGK1o7R8Mb8LAkHWaNCqvH9zZyXc6UgNQEtTON9V7lQd+W/7H4ONtNY9hJbgOgt+y1aou7qFHxqNjYxQwjau/OtS/gEmofDB6FLKZtGOimbMco8PO11lWAdyRAg3NEW/vzs2tfoDXnox/b/JvraGCG7is8fATZqvbdnUGZ+TUYNNTH169HLS+xpWsa8Y+e5SfplovobSRNNczHN2eEL0+0kPcKRjuJQxq47l6MrYeQ/ziOxBpPlsJPG66TGWj1IdGBBPO44IY2jf6SBPZ2CjMqDELdk+qLRxkuBMd17L4T+MDUsLtfyS8jS2lLMa+xLig9fbC3wUc1KtWRnA5r29BU+C2bZIY8kBIamwBw09JrCcXsqtGLQFxUcuWwAfZnvKpUORIoSrmOA+qi3mUdfYeJ5Dlva83YM95K9YsHNRB/ISHGHbIs8AcCJJYEb7yk7thejJ4XZ4Dt+R7Ubmp0+B4PQVUfS949Chza8Fjzida50X6POANzFkXtrUWbeBSbVbaWKZZ5/sIqMs/wUa8OZe+MVO8uOvolnkvEPPKeuO/Tk2gToluaScrR+CIhG8vTaF/uBz9Wphe0m9
 rqxPZfSn
 7AT7eE725Hk69LCSOB8aO+xTbGHBwJde1FbQEf9gcDcq8VJtl5Ly0l84BatD9bl8LQymkUknxxzDBe3XjlSonBJ4cuLVsL5dtN4rZU7F8GI1984hP6eOc6VPqLJR3wWpZWm6nLn7QBzGbGtTcxjw86kq4Z1JKb1dwMwf77aWsm7Wq2h8sSTg088SSkzHeYe6OhA8sQIY95PXggwBhkqfpAVRWbk6FDb76SRdIM6HVyYWebVsBiAji/1VRcZNSLL5DfdeDB+zIGMyXB6MP+VWhm4jzv6Yt30dL5dzGUYJyl8BmQL8TW/Dv16++MsjlzJjoSP1tdTOdnoVa/Rm/2DEoJMxa11MkR1wjh8lXCj3XCuXXs0XkiUN82Sg40NgJ2qgrLubOyOniQdQf8l8AHfm6VwhGhpHj0+YbqfkkEqb8XJgr2h+11G4mdySTOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cachestat() syscall reads page cache statistics straight from the
file's f_mapping. Stackable filesystems such as overlayfs keep the data
pages in an underlying inode's mapping rather than in the overlay
inode's, so cachestat() reports all zeroes for them.

Add a ->cachestat() file operation and route the syscall through a new
vfs_cachestat() helper that calls it when present, falling back to
file's f_mapping otherwise. This lets stackable filesystems forward the
query to the file that actually owns the page cache. No behaviour change
for regular files.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
Note: Memset change might be a bit tricky, I moved it to no
->cachestat() path to avoid multiple memset on nested overlayfs, that
means that ->cachestat() is expected to be able to handle unitialized
cs.
---
 include/linux/fs.h | 10 ++++++++++
 mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6da44573ce450..966b6564707e4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -53,6 +53,8 @@
 
 struct bdi_writeback;
 struct bio;
+struct cachestat_range;
+struct cachestat;
 struct io_comp_batch;
 struct fiemap_extent_info;
 struct kiocb;
@@ -1963,6 +1965,8 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	int (*cachestat)(struct file *file, struct cachestat_range *csr,
+			 struct cachestat *cs);
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
@@ -3633,6 +3637,12 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+/* mm/filemap.c */
+#ifdef CONFIG_CACHESTAT_SYSCALL
+int vfs_cachestat(struct file *file, struct cachestat_range *csr,
+		  struct cachestat *cs);
+#endif
+
 static inline bool vfs_empty_path(int dfd, const char __user *path)
 {
 	char c;
diff --git a/mm/filemap.c b/mm/filemap.c
index 7e467c81d2138..90608c6b1ce55 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4714,6 +4714,37 @@ static inline bool can_do_cachestat(struct file *f)
 	return file_permission(f, MAY_WRITE) == 0;
 }
 
+/**
+ * vfs_cachestat() - query page cache statistics of a file
+ * @file:	file to query
+ * @csr:	byte range to query
+ * @cs:		output statistics
+ *
+ * Compute the page cache statistics for the given byte range of @file.
+ *
+ * Stackable filesystems (e.g. overlayfs) keep the data pages in the
+ * mapping of an underlying file rather than in @file->f_mapping. Such
+ * filesystems provide a ->cachestat() file operation that forwards the
+ * query to the file that actually owns the page cache; otherwise the
+ * statistics are computed from @file->f_mapping directly.
+ */
+int vfs_cachestat(struct file *file, struct cachestat_range *csr,
+		  struct cachestat *cs)
+{
+	pgoff_t first_index, last_index;
+
+	if (file->f_op->cachestat)
+		return file->f_op->cachestat(file, csr, cs);
+
+	first_index = csr->off >> PAGE_SHIFT;
+	last_index =
+		csr->len == 0 ? ULONG_MAX : (csr->off + csr->len - 1) >> PAGE_SHIFT;
+	memset(cs, 0, sizeof(struct cachestat));
+	filemap_cachestat(file->f_mapping, first_index, last_index, cs);
+	return 0;
+}
+EXPORT_SYMBOL(vfs_cachestat);
+
 /*
  * The cachestat(2) system call.
  *
@@ -4753,10 +4784,9 @@ SYSCALL_DEFINE4(cachestat, unsigned int, fd,
 		struct cachestat __user *, cstat, unsigned int, flags)
 {
 	CLASS(fd, f)(fd);
-	struct address_space *mapping;
 	struct cachestat_range csr;
 	struct cachestat cs;
-	pgoff_t first_index, last_index;
+	int ret;
 
 	if (fd_empty(f))
 		return -EBADF;
@@ -4775,12 +4805,9 @@ SYSCALL_DEFINE4(cachestat, unsigned int, fd,
 	if (flags != 0)
 		return -EINVAL;
 
-	first_index = csr.off >> PAGE_SHIFT;
-	last_index =
-		csr.len == 0 ? ULONG_MAX : (csr.off + csr.len - 1) >> PAGE_SHIFT;
-	memset(&cs, 0, sizeof(struct cachestat));
-	mapping = fd_file(f)->f_mapping;
-	filemap_cachestat(mapping, first_index, last_index, &cs);
+	ret = vfs_cachestat(fd_file(f), &csr, &cs);
+	if (ret)
+		return ret;
 
 	if (copy_to_user(cstat, &cs, sizeof(struct cachestat)))
 		return -EFAULT;
-- 
2.54.0


