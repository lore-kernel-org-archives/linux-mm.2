Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86142C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C1A6B0088; Tue, 15 Sep 2026 11:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD876B008C; Tue, 15 Sep 2026 11:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CAE26B0092; Tue, 15 Sep 2026 11:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06CED6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:51:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ABE88049B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:51:12 +0000 (UTC)
X-FDA: 85216435584.13.BF27459
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011067.outbound.protection.outlook.com [52.101.52.67])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9666B140009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:51:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DlJQ1j6x;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DlJQ1j6x;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789487469;
	b=Ul+DNhFVeitPfQVGjNotDtBLqKLg8Q8zaOt+40vqF11Ld7VCRtBcnwcSakWfYFfNmr3uef
	nbXjcemGx0C/o2jwCgGMrtOsEWXxZ4NYrvsK0Dq5dgMufdvu8ObyLMeqZIuoTLw57ikblf
	R9kWGy//v7QLUfDfuCgf40fZq3L3Hvg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789487469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xuw6m+IoGXUCoU3dUnLtBdPER5KYVzNeQD5xsbFUgFg=;
	b=FjiyxelTH03EznaIp1YKFluVpyk9YDQVisB0wzetoaNfrBKq6hY+dxhhPdEHzCjCKpI7Zm
	x6D06RKh+RBC3XRQOpQubm2hBlVJPBVT0zQUS3JlW/RIcxCn91h5OARB5j3KLEftSa3VyA
	OFlD5SYR/+AGBjZ5z0ZRIn5VtxBXYU0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2xFHNe2P/OPjq740XhVUYIOlmifAgRHw4DV2UrWBvplzJBNbI8025lMNNZ3JeWX5EtON1OCZutZZupOx91L5NLA1OAkqfDF5qJXN2IDQtlG4vObV9wtD7MxdfakUE23gryQehtpWs3vJtNkZpGvRSur2dX7oTdQDU/jPfX+5ZQNtmF5EOcAA3qEhPS4FWxgSr8OQw6g8i6GxWNSSPsGwqCImgSnbPt+PBEb4uSOwgiXiL4ypEPUJPea+Zr7Z+RdFjmIfmi42hKjQxe3RZprDOShSKyeD+RaZdCh0sLIqbT2n/l7OF5qVNpExkXgrug1XuQD3yJWMgv8kC2mIKs7KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xuw6m+IoGXUCoU3dUnLtBdPER5KYVzNeQD5xsbFUgFg=;
 b=P0BJOyM+auBCMRugL2y1R/NwoGiRcQv5xapE77nxaGD/v95Z9966BME88n6v+REnS0H5z5oo+oWgTfeKeoXMDiCs/IbfSFZIRt6NjWXKoiRXnOw/EUlXrdLpJ038hIbXQqu10k/NJn5fLTJBrwFZFVvqu2P8ks0t4wgBra2lTEe3x2ZY66u8TD+7ZxyZB3lrgE8kfK5uR0zOghUOdPqy00TGZ85QHrkqFWN0rmCZke2ZkoM2XcmKHdM5qlvT/os7qG1mnlm0xHzquKLvgMjSPMn4W7bF4EtGj5n5t44RRDpOCfNINCsd5k9Z4y9zdenFBbyl2BidZRmKggq8BP+3xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xuw6m+IoGXUCoU3dUnLtBdPER5KYVzNeQD5xsbFUgFg=;
 b=DlJQ1j6xRKUY8H5Vq5GYWyrlAov+Y8vNK1XIBemXAgC20gZsEo6cXLBS14ZpiDKu09rX2eJGPuiyLwgzaMXMihB1Yk/Z1dNW3JaJh7rbsPjlq5OZoN3wX1l4V5UfRGbA+B0IXgoKwdSfEV/WaXZSujGmh4pl/wmOJqf7tQ2crIonXaUiNkzeRIgyfIZD+q8FkpkO2/6zDmVD3RUTLtFb/hnvEAD5zosBDoKGHpsTwGVTai/zF0lXadGs/76VoqxZaWTL2TxKfonbcwKSFs9+gaWj0Wd7fKRc5Os3nsRLnyRAaHP4+Jf8T7sY3QsuWV2cXnMOQ1F8QBefKZNNnbsT0g==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 SA3PR12MB7902.namprd12.prod.outlook.com (2603:10b6:806:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 15:51:01 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 15:51:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 09/12] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Date: Tue, 15 Sep 2026 11:51:00 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <C70450FF-9795-4A17-9C5C-448C38203F7A@nvidia.com>
In-Reply-To: <aqfeuAPx3lCKSXtd@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-10-kirill@shutemov.name>
 <DLCTWPIN1HRO.2HK4RPZ43F301@nvidia.com> <aqfeuAPx3lCKSXtd@thinkstation>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH3P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::31) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|SA3PR12MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: 673783cc-a89b-458e-d1f0-08df134123ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|56012099006|6133799003|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dziaLEzhS6SIvb55+yuaG27Z/0O4SLgAHTACVytaqzyroQM1RxZ2neZhfcp+s9dOJH1JHEELVUBpQR7icMrdG51dfmNvOj8itHvvpOu70Bg9EGXk2o1yeK0WTvq6q/ftW4JNigLKkxi4EcwivLwsbkjYR178wJtrg1i3aG/BUQp1icn8IZvU/Lwi9vmlbbTksJdLIYup6t9DX/ZEEzUEXi2F+kR5xmmp9aUwhcscJnV6SAoT/jkx23Kp0zPDAtdxXLkUzfmbkXT11vzwM0GwDUJ1oribqsgNKSFVTaZ/zApyHoJJAJuRZxiSyq7/YOSHQsxJOlUkQA520j2GKXYLWPKN3ocL4OvnoVetxig/7LKYsTC/AjqLAGxrV8wtARka/Fs/teCU2GGiQZePn70HCAFMmlotY4hUIFIbhIx2Cqq3b5IsmTUrhVDBtoAwmLJcZ66iI1FCQLodPIcKy+igkHwRY9HT7c/igx+l5VOpGEQo1bdI8y5kBxtTnGuVna7Vl7Uri2Gr8TyNm4Y9YoEFp+XJNHUt6xf8DuWVTRFqemVBAL9BPQOPWHIv4xOUJFVbw+IEqECvsOnZh9ekzW4beYmpfWPbIY7USxcXQRCEkO6eu/DmAatjjRpLvne4KgDCb6XlBBJJ+X2kfDDCdyYK7cIkHi9c0e3PR/8U2mcfB7w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(56012099006)(6133799003)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6VljITF7x/YFg0TkkcxlkD2XfbHibsB5ofPHdmgqYZgDVJhnrS6g/w/QfiSm?=
 =?us-ascii?Q?h8FdKKro3SA1LAoFa6fvml/63FqDrTwM88IMeLs5ljPAWy3aOiKJxriqILY2?=
 =?us-ascii?Q?Fg0wRsr8DjTiZ+TcPCM8p6pzXyxPKJEqRYhzy7N0c1ny3atNg63v29lzdQEa?=
 =?us-ascii?Q?BViie/59c2goQi0pOM4cQD+ieJH4PsBp/sM6qmlh77ioPWN/tfdZ+8HYhisD?=
 =?us-ascii?Q?r+NTheo4YsQFZBEywgT+7rajBrNorv3oWmqc1WjbeTfUj23tUZCg3GxfzJ36?=
 =?us-ascii?Q?Y3REFwoG8nKtwg6ItJowwVjr1wDO84O2s9eFqHk5fZYHfrzxuBB0FH+rLDZM?=
 =?us-ascii?Q?BqNB5ayODj/6WQ4EdQhbOH0qZGXrnzmGwN9hQDHp4oyOHS2L4E9kAG1dUVvA?=
 =?us-ascii?Q?6OTi8Zal7jx+nQx5UaebvHK13hkG6oIUdxpbYHHAvq8LT2CcvagbP+Ph3KVC?=
 =?us-ascii?Q?7XhwIvJVucnGgmoQ/Bgy3jP1ZWDNSoIm0ADF4wef20wdd3F9kuy4cZocB1L7?=
 =?us-ascii?Q?39Kk3pFl2MQeG8lqWU6O5YNBSBPhnsbODyq8AAeXgo1optE7LO/sJDj2dT6f?=
 =?us-ascii?Q?h98hP4qdsW56rj1jQYFtNBYhF0khNpaJWD0eDbbA+PxEm31NGACD3DuC6dpn?=
 =?us-ascii?Q?laJIbMdvbusSp2VYufIaNX8Z7sA1Oy/IJ4HmraGn0QRGC92Et4oOikhy6cge?=
 =?us-ascii?Q?KafaNl3tHGqt8Grtgd6xzhg1sUgwt7RHTpt2qZCXiEhVfyLn2YxV4kf3C8ph?=
 =?us-ascii?Q?f7YGwy5YQvl3r44eBs8E/aHpcoqwvgIRLVJWNszYHdEs1aGmsNWqyWdcorBo?=
 =?us-ascii?Q?CAIam+elFruPyiuQySK1ZNEqfjk0+b/itPfTNeNC6sdKeoyamd6/zlzhpMdD?=
 =?us-ascii?Q?iJg09nlz/pqjvy6BXrpv62mWutOtBU6RkWBDhbykmQ9cH2DUnf+Bv8FaAmG6?=
 =?us-ascii?Q?9RatWESST5XoxeazsekVgJn8sYq7R6uhkIqLQTSQ0T7NM2Kyonq+i9jy2sF0?=
 =?us-ascii?Q?T3qPrb2EpIJ3MbKZLXnm2S4kaLsDJTNEEaQqaDeBgK8CsD/2GhVPKoLyJViU?=
 =?us-ascii?Q?5IetwzUp9baacAze7b7qfhszLeREvfDekfh2+oI2L0qLgfP8pdYlL/R/oAv0?=
 =?us-ascii?Q?PYIie1Qv2YsQLYHkHLnH4FYdsWrj5sgqu7l68c6ESV5ng4kakOalNfwFhT3R?=
 =?us-ascii?Q?/VnCjrn43USpVrxdi90KB2oXl2ucRuRKJFKTtYsJZRRKRoxskjisbe5+Z5z0?=
 =?us-ascii?Q?D2nmf0aK8H+ZdBvaec2pla1uRococqmyOLZKhlPco66ox1d+C8YPJVndp/KK?=
 =?us-ascii?Q?ny50Vd3IKf9W7fkKi53ppRUMjGeAECQXnlZDGmnMX8mqruEbb0celwnIQ9og?=
 =?us-ascii?Q?cNIaawLwERh7HBxrorpJkFl30pFKg79JBYes5UjHiQUQH+4FEBXImMc2kAC8?=
 =?us-ascii?Q?b04PP5ccY/EvhAIvhy1EiE/LJ5yX0fDfV1OsRlQ7gygMn9Kv7jTmK8cGCBlk?=
 =?us-ascii?Q?xvrhWZgXsKePHMs7SJD9Wxcw7eLxxuak9MTYBaYElqYKVNU84HbV6xRxRnZz?=
 =?us-ascii?Q?Eyl0KVaWAaIwsn2gFpAlnsL0B6SEE3uUwgsyqr/8MrEeMz2pWOBSfX8JoBJt?=
 =?us-ascii?Q?u+rOWZOIMEaiCFmDXGn3TkPOv2BE+lRfY2FgECxu4DkVmkR4nhyJv/RSFB/M?=
 =?us-ascii?Q?aD6T1rN7LmrlXe88uFIfk+wdt+8qK0ruMOeMwzeK7i4Ul/kT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673783cc-a89b-458e-d1f0-08df134123ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:51:00.8401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJ37od0r0UUGFyFbwI5mBYrGUKKNGF7UGP6Ltk6IZVu9feMqIQ9sD5GmqPRJ9xtB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7902
X-Rspam-User: 
X-Rspamd-Queue-Id: 9666B140009
X-Stat-Signature: u9i34urrt6gpdo1dzumdowbcc9w9ux9t
X-Rspamd-Server: rspam01
X-HE-Tag: 1789487469-904158
X-HE-Meta: U2FsdGVkX1+IHqp67e6SiMtbIbxLPWcMKounvq4t6hcrn809cbKQE7OkhtL7Z7KAkHtr2l+AD0+WRsyFV/poWhjRtiBkVrCNhOiENYClOmi7uzF08FZcEbOjolnvJr3Lx1Hqz/yr5KlT0ZSbqm/r1zbgFzMs+EavEL2rV2ZI8siA7NxaNEtkwjkuEkDqssq+UuC+0dPUV8nAqAqbVFQZLOyVW5grhUKaAVyy3ROTa9uOFr+qxdKNzTwkSJODbuNqy4kXn8ozSe9i9bJWPBirdWyIfv0Cjl6ITHSKtO4qqr3lEXg5l8jDTjIJcCMPI5INl3sSmvA5+xP5EDgkwudN/2at/YWUZV6WdlonUy5XmmzHMTchTzbaPRYrieMO8GWdpwjST67Q9K2qcLwZttgQIKCkpXXSq+8IKzPIP2etboAyIMn8r/xFarwKA6dHLquK1sUCaTCEUDoxVSK3Y3fGk5kPpdpCoFVrjJkn6ggEXNdDpPJyOMmmCQkvJfptzwwxgBiwQr+8QzC2B6BEKV2gK5cIo3bzhcraq7uFOsKbb3ns6YCWAXhwSOf53zsYqV++Q4AVBvYnMeMGLJV/aXf/WVvyn9Lg3qo69YbrPlBcJKrj1eS2aOJp5DudxRTpVB3eVyeBvQMXgbgTC5Tq0Ujtu4+mk+PNuUgUB7G0TIYIeHqYG41l4JRhvMMWLQkQ0wEx4tgYtAJsIF0okjQM0FqFjDJSP8iOl9t6thD8wFen+5UB48xNIAHEK5kiUqaT7F1iIaYj2qwUO0g6U1seWU2TgTXvimCXaCfCZk9kMORyGErofIIj/uRaRfS2upmqoJt5FjjDFCa7HNHsNgMTsvjr5/70zRNXOsDpo9UYliVqktf2Kff3hwddREL2hUPLjqMWNIwSKFiK7T5XpYXiXCw9fIsnL+jqZ8vfgAmzr6zQWPJPw+TPwHjiU8KEIolz70oOYPDQS0FDCdLcR7mZT45
 vGlbO/sJ
 wBheilEybqM0OAmNcPqoPJCR8yZYtnMBZSuDirzz5K3/xHF62DQtx2+gxGfvutR6AMtT97f6cO33R4+IeR0qKG2sPy9YIESHTHrkzDL/1+bSGtjIkQytl0bqEb7iH5hrMcSFXY3rz9chIP0/kkfuyRqrLDYU++lsHBNcWpmb3/Uokjq2qLFEMsdvCfKAHQRj9cP5wYH2vorqt0o4HNWsqixtgSUTz6n7oQHWKsPZID7STL3Bd4Vc2SqtIG94/jAyfjq17v8fvnToh0jEEBnVyr8L5IcDe4oqogU8peXc+cimmT6kDNI/DI6BhmMfoRaEe1sbpfZd/NwQnVbJUhKhpy4SMxQ6DeNLy68MLb6VgBBRobd2Ni8p3lm4B2odcSkPh0+e2Ktk5uJzWwJ0UEjJn05ix8Ly4Gfi2m1M/8EyTQqaTNBpdlBoXezU4EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Sep 2026, at 7:47, Kiryl Shutsemau wrote:

> On Fri, Sep 11, 2026 at 06:09:32PM -0400, Zi Yan wrote:
>> On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
>>> contract.  The scan is called with mmap_lock held for reading and returns
>>> with it still held.  The collapse is called without it.
>>>
>>> collapse_single_pmd() kept that boundary inside itself.  It dropped the
>>> lock on some paths and not others, and reported which by way of a bool its
>>> callers had to carry along and then act on.
>>>
>>> Open-code it in the two callers.  Each scans under the lock it already
>>> holds and, on SCAN_SUCCEED, gives the lock up before running the collapse.
>>> khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
>>> the code dropping the lock is now the code that wanted to know.
>>>
>>> khugepaged's walk carries on to the next table while the scan keeps
>>> refusing, and ends once a collapse has taken the lock from under it.
>>> madvise_collapse() re-finds its VMA after a collapse, which it did before,
>>> and now uses a NULL vma to say that it has to.  It still reports the drop
>>> to its own caller, from the line that does it.
>>>
>>> The lock is given up and taken again at the same points as before.  No
>>> functional change.
>>>
>>> Assisted-by: LLM
>>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>> ---
>>>  mm/khugepaged.c | 102 +++++++++++++++++++++++-------------------------
>>>  1 file changed, 49 insertions(+), 53 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index c26907300c23..9bdf12128357 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2857,28 +2857,6 @@ static enum scan_result collapse_run_pmd(struct mm_struct *mm,
>>>  	return result;
>>>  }
>>>
>>> -/*
>>> - * Try to collapse a single PMD starting at a PMD aligned addr, and return
>>> - * the results.
>>> - */
>>> -static enum scan_result collapse_single_pmd(unsigned long addr,
>>> -		struct vm_area_struct *vma, bool *lock_dropped,
>>> -		struct collapse_control *cc)
>>> -{
>>> -	struct mm_struct *mm = vma->vm_mm;
>>> -	enum scan_result result;
>>> -
>>> -	result = collapse_scan_pmd(vma, addr, cc);
>>> -	if (result != SCAN_SUCCEED)
>>> -		return result;
>>> -
>>> -	/* The collapse takes its own locks, so give this up */
>>> -	mmap_read_unlock(mm);
>>> -	*lock_dropped = true;
>>> -
>>> -	return collapse_run_pmd(mm, addr, cc);
>>> -}
>>> -
>>
>> Sorry for walking back on this. I think collapse_single_pmd() can be
>> kept and still get patch 10 to 12 applied. The reason is that by looking at the
>> code after patch 11 is applied, the collapse_scan_pmd() +
>> collapse_run_pmd() patterns in madvise_collapse() and
>> collapse_scan_mm_slot() look very similar. And it can make
>> collapse_scan_pmd() and collapse_run_pmd() internal with only
>> collapse_single_pmd() exported.
>
> I gave more motivation in my reply to David:
>
> https://lore.kernel.org/all/aqQf9hSy0iNjnL6t@thinkstation/
>
> Short version: scan and run have different locking expectations, and
> the split puts the boundary where the lock is. It is also what makes
> moving the scan to per-VMA locking trivial, since the caller owns the
> lock and the engine never touches it.

Thanks. You also explained this to me in my early email to patch 9.
It makes sense.

My motivation is to minimize code divergence of madvise_collapse and khugepaged.
But it seems that their workflows prevent the unification.

Best Regards,
Yan, Zi

