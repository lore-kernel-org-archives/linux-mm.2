Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE91FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED456B0005; Tue, 28 Apr 2026 15:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E216B008A; Tue, 28 Apr 2026 15:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D8F6B008C; Tue, 28 Apr 2026 15:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B71A46B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:56:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55D6640464
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:56:18 +0000 (UTC)
X-FDA: 84709021236.30.53D8421
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	by imf18.hostedemail.com (Postfix) with ESMTP id 830001C000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:56:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bq4ptY0M;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777406175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrbLkWbIUYZuV7Tie+5k9iP7c/Bchu1zUYb81KoyOo8=;
	b=cb4YwO1ESM2PVOzPtnt6CrCYwLMiq5QWBZkyrzbKkVlaqSqlbRQ9L60AZI2UGlemPZUUOy
	0/Z/+deMm3bJBQI0JiPnTpSJclpdji9omSfQCKLQEK9zBQqH154Dv4ZVigZOrC3wCZQut5
	fqRPgJCYSpw3M8kFABIdKoLD8pJHB/Q=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bq4ptY0M;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777406175; a=rsa-sha256;
	cv=pass;
	b=DFVCVXm/9yGrFZsC7hZb57rrZYwj3805yKrSotVEyjsndBfP5CXoWRneQLfhpadFx8pf4Z
	AT9m3PYoeH5RgV7Oeiakgc2FdfiIQQsHLWNDWxvBkoQvHiKJVl27MfzkybqHzC9tT4BVYw
	qgNi9Bv1cheV6lkIQZZCkOZXoiYd+Iw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j0Y484dwk8K8bdXIcXv5Sexi1UMFJ0ABgZWBTAlFMYKQ1bSUPovITTSnUgE+QQePcNIyXkG04ykRDQ4UuSMZnex83HTLEkLSWaYJqlwBW8EFqhKwaaRwEu1ZIZgW7ztp0Xo9gL9XmmgHn31jzmsEV9Tr4av+3HTV+HrVSoBOImJ9giAzVpjbFGlYytUC8ekbJCA4Il9EHwiQOAYMZyt0q8bMVkkfSUDzuROk5Ye9rsGNsjd4WJtpVrYEPQLidIGoJhT8i1QfCYIXSkvcWF693oyTLX5d8NDNfiGKP5E1NBLtWn/J/ROLcwd7a+Tvobggllg4QehQzLxkuhuKDSv3gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrbLkWbIUYZuV7Tie+5k9iP7c/Bchu1zUYb81KoyOo8=;
 b=hArLdM4Kc3c9w/1bn7acCqpKGCgyXrq7aisf+v9YFqZY0BH4SHxkltvy3yxDnGBR7FOSqpalsHA97gFCqjjB4mRHPmUYEx3p2KnCY5hMoQV49EPQp0clMloyOz37CKpOnPAiNSYwBmA/mfbCtWYk0B6qoMnj2TvSAHeuOnu3G0o/uJxF2+9liypZu8suFc1lXhw/dRuQjGYu6CbCpgma3QcUnU7zQ/ArBbtStjqWIpDCqhAsjmwj9C7F/Npsr4LUXSnzdknC2c7NMuGGUXCUF8I12FlVmItaj3217nkYvQbFDPMEkt/d16PUyzIbKcSRPWHvZesrkBWKCWGrkzF6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrbLkWbIUYZuV7Tie+5k9iP7c/Bchu1zUYb81KoyOo8=;
 b=Bq4ptY0MEPVZeVU8Cz8JhCcq0bwUDW2ed53Et2nSBNK9up7qd4QzS0rGPqnIf1zTjdS6TiWnphQr2OSEQ8B2JcwdsEAnb2yk6WQi99JKir3t5nh0dzI2tpY3xcioDTxgb46D9PkeOGDzsoMKYCbdoIS1rHq9l6vrplNZFS0W67FGViGMPRNNnPPFod3ydMehFcdvYwD0USd4sUUC88qcwBp/3WRPKyZM54+gglnuuTgNION38NFaXyuJqE2sUjeIgThyd2Ogvl208hd4mEqVsrltqOL5ww4JoY84ghKuc31EUmCyB0t8+ulDNzTU9VrDxU969rzw/y6GGMMmUQdIvw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8426.namprd12.prod.outlook.com (2603:10b6:510:241::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 19:56:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 19:56:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] selftests/mm: khugepaged: initialize file contents via
 mmap
Date: Tue, 28 Apr 2026 15:56:06 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <583F8EE1-5C49-4250-A24B-0D73372E3864@nvidia.com>
In-Reply-To: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
References: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:408:143::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b76fa87-5cdc-4ef5-8456-08dea5603086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JqvBoX233zILnZVJyVlSHzvb6esuzXopBjJm2eDMjoQDpE7SCEBAezOTbRHx4B5uAptzsCF39M+mHXo2HAPxwt/ibyj9FFKRB/LTOLjIXnB5Fo0sDqZy0mFzcgGgYxouewGVaQJAQo5KVl13WnSeTs5n5iluPmoGaFrXeU5IQrfHZfUG7gYaxiRn/ahhNvU5wxxdEYTHAYpLghXHIErPcprBNVMjIomzBYaSKt/PzaQsP9cclLcPpBDAOCTCgaECAp5JI44VcaUjV0jQ2tWQlUAr35iIip3uc234vUT/k3rUzP8JblDpF1ueXsbnugOP3+rpe+J/vw4aCnY0DP7V9XCTZg3hfZVCwhR9HkcD1wy7sZffpHfz4ttHkO5fCD3CjqRFPT3iN7XwADqgzrwj5AhGSoLT+50tgDhZ5Q9tc4QrQSwLRtOYNHgTfZqMALPA30mf8ibubeyvZlatyyYARAfcpnfAwvGX4bDCFt5N+BCnsYCtRDnCpKqF4ef1FShx5R7w0yk9kB347mgKVnK8HCOOH1Fiuiqn+VAB9z9NhJ0lB+8nPhbKE4/8P+hOIXKiKHKvJ/lR2mBLXlajwcXiMfDlwmQy8cm7jnL7LaPFQoKxPsLTNg4kS/2WHDWmBQd9KgQoPNQPUZ6LIr1o6k1jJf2PNCIZI3zB1DCIauAVN871w9kMZ4CC9fe1Lto/iRRelONcNpJCZGNCdqLshbDl1uyL9nhDQuH7OPjCUoCGrIs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PlRS3w5eBE5hyG/uDObQYHCeUat3kxv0lJ6pA3jIrjHi1VVHnaKRREn0fIdW?=
 =?us-ascii?Q?PFd8IBO21FA3yhx7ThxsyjtiC4IUf1/Pfd78y9OaDIHAw0GlZrK418tEUVjN?=
 =?us-ascii?Q?PLzyXH3hg//DA0cjERTQBnw1aqK92FThcRC+A79bkstvSRHS9MBZ/gl6ku1m?=
 =?us-ascii?Q?8OntcJ2d02Z/9CTL2YOYAmLIWKXdr4jUFxsaqFtf+e9i9Ht93JCL2/ZRkYfw?=
 =?us-ascii?Q?rmBlQffCbkOgnhHsmjAHfpsEx56yGiWGNltxcumUdIYHo2SWT8uRD6/mDN1i?=
 =?us-ascii?Q?Jdlt4hMnJ9iXJGiHqLRJ7TwsW0wJqZvodkDIJKy3Po9g9m7fVey1k9hXhhkt?=
 =?us-ascii?Q?/1mn3pM+YxussOoXkLutnNsNu3dv0I9+bCL84KjUSite653V0pe/ru9x6HUj?=
 =?us-ascii?Q?x9XL5UiXP3D2nDh3g4LdIkrFvDgoOFs4pcL3LZgPv0FHprIcsLGgcMK+Zadn?=
 =?us-ascii?Q?N9+NJ8oOGu+9Z1fYDCj/TZ14s//gX6bSUjMwCTgXrXK1ubG23KVlqhWQ0qB8?=
 =?us-ascii?Q?fJYbdPnutABbW5CLpVCqYuXiZJTrAx3ei7TIoXGQsVp9EvXcXCRBUJ76H0SW?=
 =?us-ascii?Q?NNu1wKVoWj9EytD9Shb44lRKoN6eJuCTVzDR/JiNZ0JC8XNj7N4WvEV+aUED?=
 =?us-ascii?Q?qFF0Rua8yDI3ocv5NjCV8VD2ImUomfrU3/fzqfaaXLtutvFN6JQOyuaE+QrG?=
 =?us-ascii?Q?tIEiXWRNW/MtwuN3MbZuFWQcJKrg2q7D5WmdzByUfKNY0uSPE7usGDao7H2o?=
 =?us-ascii?Q?35dtDeV9wGcy34IkKINdlzdKrrq+oGZULoU3VtzPE0CCZ2REmOumOHTNg6sP?=
 =?us-ascii?Q?dZY4Dxl1m4bho6886KoomGjsFqSS4ArST3S6/AQ+hImZN6QX9AxzKSP2VN0K?=
 =?us-ascii?Q?YhIxe2LYmwDUUUezOnlz/1QU8IobtBvzYdqZfEZu+1+rJG9U8VA2OtY2Dspn?=
 =?us-ascii?Q?/J/ICYmubE41o7Yrz3iP8zkR5jfq6oN7CquW3ZEn5c2YlsEzp5lo1xZeopGk?=
 =?us-ascii?Q?ZoCQFQE0tZsSllP0w58jrplEtD9mec9CJOcYgrK88Pbr74vIvoSPpOkIfu0s?=
 =?us-ascii?Q?naBCN3CeRi6xCpPLtOMX3eEZGnaWluFIvHs+2RgNuREkdWMPtY75E0Z39P+7?=
 =?us-ascii?Q?D/3dLDqN6OZXSOSbfZjgeDtean3m/KaOE7e3kZkJBAtQlKtUaCvNPeTtXAfo?=
 =?us-ascii?Q?dFtdkCZleIHT5uesZONJRb3pOfzcndoSAJYELKyIhbakJRQdleeihhJPmijY?=
 =?us-ascii?Q?+bECzW1u2q0gP5MQgn6epORl/vk5yyP7dNU3WlR7YPcdbYfNcPLdiUbgrzeq?=
 =?us-ascii?Q?MP+o96NOUhppRpT++MrQj5+nw5LJCf9ZnoAeMSUuWRofBzSm4/Y8wTh49FSR?=
 =?us-ascii?Q?vL7C4jF/oKoV4FITQu9pxtkda6CQSE/tPWnGBMuvfzYZQkXBEKlLFKWcGRRI?=
 =?us-ascii?Q?F/dIK81ooQEGbyqS6dU4LQsAOnm5QMOoObc6HU5DVlHz+ARK74Myz/ACqPMo?=
 =?us-ascii?Q?x6VjxRe0JHLD+1bHFVcwTmnt9sBEVtvsSVFL5x+e85zN/uXwQvXm1SRuQEC6?=
 =?us-ascii?Q?qngGclP/X+DNcJaK4ILsrn4oci0h6IBfkyP2+m2RR18MJrAtlD2jWt5Rpvny?=
 =?us-ascii?Q?Q2+absKA60u3L/2qgnoch3ydcpvXcstSP7GoAUsxQN4eYn7QEEswgUECHsjr?=
 =?us-ascii?Q?ZZFTJS6LAb2Upic5w4d77n96LVJAa41bGot0GvMhz7DxV6Rq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b76fa87-5cdc-4ef5-8456-08dea5603086
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 19:56:08.3671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jE38TqffduucAri0cKvhfEtEXEetr0roPlbhmUHTY2TgWMZEKwYDiRBWrJXw6hUN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8426
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 830001C000E
X-Stat-Signature: sx5147hyr3o3hxyzpg3bgjy94qsuybbd
X-HE-Tag: 1777406175-643338
X-HE-Meta: U2FsdGVkX1/CfRm9gU3YpZ5m+4EW+jAPqUzxtRVqN49QEN8eTd2UN0gzSyZr8Z+qtBE09A/k+0uaC5/d2fS21CGf9ucWRhuOjK1lRcq7Ojq5EeNkuFyleHTcCDoBeFxuJKWtoXw2EB1MCHNVcudSWVNkvWEctD/dLNu1sPbqHtvGw6Pdw3tv5PhEBsds3u5icuB3BzLMJs6K26BEUazkc8tGfJGEifNbfrvXpFCnoaYeyzV5u0n+vKxp3ABK0y1KE334NBv9EDwFEljSsvzjeuVLbdjpWckxkvqxPKQXUybj8yShmu5rpIkasFUIkPDiiVjnB5ZVhEG6pw+vIkpS1w11BpBerMh9qf1RpbHKV0wvFGwOKVAOpE40tbdP/rPVGUzwNcUiX85TlLA/ilREeZ7T097KY+ZZaZ423v9nPLDOZ/A+CzTy4Bd5FSDNbwspeIbBxTM3Dt7gZvByMVlQqIkVgJ6cuGbOrX2bImpeBl0g5Eb68y3klKU7Uz4mPWxLxsJfcJsto4CBnTIZlt2DbXxUojSrDBbmWU/AfB3FeCuZRWuYG7g/hIMhlC8toprusB3PX0OuImDcVgufAO8XFfvS7xLy6v6jkKqOhjVoFLe0lONzdA9CK6arxNrrqQ8geAenU74U3zhlZSEg4Khbl+2mqeU628x7ybqUZejhKEROlDoOrhe9zhY/tE6Lsy7e3Nanf0tMAMZHYNFM2fujkRUrt/VBAgeO32f75V5kGBkUmOzIaKAUEgMeogVYR67eqSgPHyzjPoJg7Kpk4mpyUm8dWAL1FgyC+rmNX5PKsFTDHpJ3ly7S91Hx01pkGRYP8xcQxOqsc8R3kifUOGgzKxFuW/T4WRpYx3WWsa2cL8w9h5axOOcbJxYKzYBVe9p8Pkkt18aefBA8SpGIF2NvtajB8YBxy/o1fs5T2ggkUAJcVpT3xoLcoE1dc97Wxz0+ogSTg68bdBKnPvTsG47
 VVXK9DE1
 +uMpTs0IiYuFz/SeX7tU3AwfjKDSLvbgBQ+vaPzdfkWHsQbE0zc7iYCFolcoqLTkGTsQoEjWhgmzG7WaIc3vGi/+Pr4ZMa2auHUkV3j2oB35uQQdRn9XBOu5U4bHu7ox9/QYLuWuK75r87KI2JSSJkmvgE0cmaqiJYq/yR/8uAizcuupNhW+XMuf362n65krodOZkCyth6HEN2LIxmNm6QCEYo5bALWh7n0MFDvcK9FEZLBqOtw+RdVZm4kj0bb/G5E9IxZWoFRNmKHh+oW4/TTuXiceJ+uBvy5tr2Kxqggg8//R5TPDKiYTvllA/Yu0eFBqJvclFGijgtCdZ6LVENfxb2fAwrQkP+honOc2N5Sk1MlHwac1JL3g6/07+uS/cmVB8PHOtBcMpUygTDBr5a+xIvrJoLqVgbJHTxtrKFGG6zD9rpPUslD7NrWsdBEYD3UgDUHHRfM6OJmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28 Apr 2026, at 9:31, Vineet Agarwal wrote:

> file_setup_area() currently allocates anonymous memory, fills it,
> and writes it into the backing file used for collapse testing.
>
> Instead of copying data through write(), resize the file with
> ftruncate(), map it directly with MAP_SHARED, and initialize the
> mapped area in place.
>
> This simplifies the setup path and avoids the need for explicit
> partial write handling.
>
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
>
> v3 -> v4:
>   - Restore unrelated blank line removal
>   - Restore original close()/munmap() ordering
> ---
>  tools/testing/selftests/mm/khugepaged.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

This patch breaks the khugepaged test for READ_ONLY_THP_FOR_FS.

When I ran sudo ./khugepaged all:file ~/ on ext4,

collapse_max_ptes_none (khugepaged:file) fails.

Run test: collapse_max_ptes_none (khugepaged:file)
Creating /mnt/test/collapse_test_file for collapse... OK
Opening /mnt/test/collapse_test_file read only for collapse... OK
Maybe collapse with max_ptes_none exceeded.... Fail
Unexpected huge page
Restore THP and khugepaged settings... OK

Reverting the change fixes the issue.

It is also causing issues for my READ_ONLY_THP_FOR_FS removal patchset.

>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/se=
lftests/mm/khugepaged.c
> index 3fe7ef04ac62..6e929a484a1b 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -381,9 +381,19 @@ static void *file_setup_area(int nr_hpages)
>  	}
>
>  	size =3D nr_hpages * hpage_pmd_size;
> -	p =3D alloc_mapping(nr_hpages);
> +	if (ftruncate(fd, size)) {
> +		perror("ftruncate()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}
> +	p =3D mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
> +		MAP_SHARED, fd, 0);
> +	if (p =3D=3D MAP_FAILED || p !=3D BASE_ADDR) {
> +		perror("mmap()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}
>  	fill_memory(p, 0, size);
> -	write(fd, p, size);
>  	close(fd);
>  	munmap(p, size);
>  	success("OK");
> -- =

> 2.54.0

The code looks OK, but I have not had time to look into it yet.

Best Regards,
Yan, Zi

