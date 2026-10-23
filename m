Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86A2606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Qbu/vPW+
Received: by kanga.kvack.org (Postfix)
	id E251F6B0BF0; Fri, 23 Oct 2026 16:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD48F6B0BF2; Fri, 23 Oct 2026 16:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C956B0BF3; Fri, 23 Oct 2026 16:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE646B0BF0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:23:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D61D801AF
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:23:21 +0000 (UTC)
X-FDA: 85355015802.24.4151BCE
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010011.outbound.protection.outlook.com [52.101.193.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F717C0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:23:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Qbu/vPW+";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792786998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+XlcwQI34F3dMA2xFT8NS5TelcWVIyw8mEMoNZQjSI=;
	b=yqdT7JZcSb1UwdssBrqQ9d/9oXDSaWjfjiHY5dPP+x/K9v0Dtq/7rdxbMAuFdknhgtgQ1e
	qOz99X/xZhFZRp3er+wWKTAkJJtRumgNJeVJpSvi+3sl4hKKuXBs4P8saCNIil9aRsr4oD
	dY1U1hYoW7oWKk0KMtESrI6o0eZbGn8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Qbu/vPW+";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792786998;
	b=f0ssfXdeOeYN1g/maFQA8/bpftJSZuTxxaBB/KUX5gH9a5sF3uRbEevwJYOTP+2KBvzMbP
	/UAcEnBEDGI75vpaxAKj2R3diu5+YC2BzVN0C2DY7LRnEl+e9Wu/QsnUSbH3pqY3eqsitU
	hOmtVu6oqKT7Es2b+c/JE4hB+kSeZy0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPS+ac07ovRiANrJwk1/OwS6sjvF4QYbBPk6z0MOFFos4hMojeQHIwyNy6XyoVRbE25c6cJdMXzg9XQPTqqhQXag2HasdjvyzgTIT9pca2st63m+kefksVZkBAA+hBkHAhxmNE5PFeaG5OzakqJfpOJiTmFy6PVlGawcdN3qW0kHTbFXhrmbg10zDUjp/kh8+uW460d1s3DgdlcGNUbGU4Jo5Km2QbiREgHgsqdyCDGytEd17IEWzckL5yZSCUjtcutfafvAOHxPwTBqmA6+KzyXOZl/IZ8HVjpp1JHyKEGeSesKngl/J2FEFm3b+gaDfjOeDep013DKNkecrStElA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+XlcwQI34F3dMA2xFT8NS5TelcWVIyw8mEMoNZQjSI=;
 b=MrEYzeRA8DAJdnMMqkY9OXDFMS6loRu3AMVFRFAoGa93XM2DYQ0iQABXchwOq4Oz9XSFSrz/ffS3lmlrZaJ7UlWNxlJnygVr3a/y+HH0VjPTiiog8KOM4OKoyP1rBnnsUAb45P9h0TDeUkCbDpJWoPy8Dc2Ag47wbz7MQsnYej7GnxBnsC7I9OcjZNySUk54gl0YmsU/PEBzzTLTLw9E8q7d3Ui7cl0kQ1QEhZsROk9E20KN15HWiiierqTccs4ZvXJyxZ5o+OgfwB2NvF1x0ZM+CV4M2mwBMN7cpcrmcC26yIxfebhR6lT+eTrh4jf0WS+NMpq8TloHRfATey8+fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+XlcwQI34F3dMA2xFT8NS5TelcWVIyw8mEMoNZQjSI=;
 b=Qbu/vPW+R7oXg6ngO6mS7MS47cCvG+KQxg6LAPYqhqlCoomh3OjjxDbxv71pTCdH/3UoHVYYJb6q5jZjUzL5Qsz0SB89bNUVlBemhCQRTu5RQk606+302tGpNtZcAhzPHD/wM2SSUvw2YjzraFCWQEtlsYRBoUUyvyNrMggGMFKZyxtqpgc2E6G4aLm5y9divWozzXExoruQqlVuOjBYDF/BIqVq7J6ypDTlGk61JiWJAIZ3BrU+3dnSh9QT1YQFtNAzJrlRID9TrALfuYpz4qhzIdbCruKw5SXGLQOsK1SGpYflqNt9Bhin0y3FWxAkqq/EYZ6LeNOZgppNhD4Wag==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 20:23:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0522.017; Fri, 23 Oct 2026
 20:23:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>
Subject: Re: [PATCH] mm/mempolicy: remove unused mpol_is_preferred_many()
Date: Fri, 23 Oct 2026 16:23:10 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <AF9A10AA-E27E-4677-B14C-7C1B4EF7EB6A@nvidia.com>
In-Reply-To: <20261023161003.59086-1-ekffu200098@gmail.com>
References: <20261023161003.59086-1-ekffu200098@gmail.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:408:e6::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB5859:EE_
X-MS-Office365-Filtering-Correlation-Id: a081c194-db6f-4e71-46e8-08df31437622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|11063799006|56012099006|18002099003|22082099003|10067099003|261009223027099003|261021123027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	pIhv9sL75OnysT8PZlHggM1TqcBlGaiQbb2G5obeBENoCGDrWtUSfqhbKTwyuBHf3suOVB0GFkUUVcsDtAl/vWFe1Q4nXtZdY+kCeqvnqeGpy7EYyyAnROpoJnk4cs4z8YMCIJ18rtbqttzLcQ8fO70oCxc3X57Ey19fRahgn0Wy0JeD7GdfBBqIGUYOeQLXlG4Szc2GiABe1fQDlzy96IQyfwwUmm9AFhRNpkfpBZRo2/+NW2s4O3g/KD7FE6NMlTXy2ah1kwbImJfgpKzjGO0ljDHEXgIwjUx4Tbcmg6E7/45XAjl1DhqWzM1oLrv5cbODKFIEs5InaujbAsv61Vg+9h/wE5DGj4d00aMfW0iqLoHsS8W2hEutty3djgANhinD9gML7HKw4I4bTKdy2zO8ATWPfKD6zpPBk54IDe5QfZxn2Yjxz3LHvQ5hNN/EYssfC7/hH6PpLFW8HOyIu0ezg6p8k3f8LOEmX8OIKdOTSZbcvSNi7O6xL2Vksxr3UxZR4X0fSseyWxtAc7zEwFm9np72LAxW7WZ7IYJJHbUkOiiI//gdbE+KU94vv8Oh6Irser4poBttJdxx2PcR4vssVL14sTle5eWhNZZHweFgMKqIUIQBV0Ul9XTLEy97zmzRDpCT/UKRpEQe3KVB1np59ApmdDudVqWXQ83pbU4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003)(261009223027099003)(261021123027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KFhIM6BDlNYYvwzgZKB2/LQqFNty5RDkBBagsxt05SwU7CbvgxaX5btQ/1nG?=
 =?us-ascii?Q?HllScMDB/AhB6DRK+LqGpD0ZXs5VXmX5rUFhpu7deut+Ti/uajK4jq/iNHXT?=
 =?us-ascii?Q?6IRh2i+XSjLFlL9pUauWLOtcMPmYK6WUcXFChrMoLe3/S5De+Y7VEorJbsrO?=
 =?us-ascii?Q?v8q3YT/ecBOy1nEPr8AZgQta1EabWizrUQI9HDcVHAXWkmLqL3A0LtabBjWD?=
 =?us-ascii?Q?Gl63Rqdo6uaI/gT6f/eZ+KKeSu3ZokNxEELky6pdpu3j0k89dlqtoH1meTgy?=
 =?us-ascii?Q?2t7iwSU/VK2+islhTU+Oj6unGdZp2J0RLPx+WNRfnqhDktvgRO7CGWggyEGX?=
 =?us-ascii?Q?Yys/lj4VwIgvkwBTlIVjlsxZSEby8s67breD1HuaDKKF37m0vt7nFOCesvU1?=
 =?us-ascii?Q?7aYULNRsrtUqwJvoS5YQT3p6IKk2wc3ZiO2lNPJ8mOQK8pC4qaqcGbf5wPys?=
 =?us-ascii?Q?41ElI2ySFXdcELFrdkZDTv3t4Q3y3cT4s48Y5Ovr/TgREime7ph6PprsTOOm?=
 =?us-ascii?Q?dv3g/5G/sY6mHF0MB9LIu8Aki8ZV+er3nKSij7XXvIWeXRHhYx+cDdNCBkar?=
 =?us-ascii?Q?bDcCJsWcOP6HhucKo7ihlxhYxe337PkuZdjSkGgZV2bq73zayGs/mJGyP/Ry?=
 =?us-ascii?Q?9yg4YNrSHl7JR8rrxzFt4bB6vuZlj+hv3nt8FQjZziXpd+11Uc8HoB/mBjf1?=
 =?us-ascii?Q?Qv67jI28RD3XgUhybXWrJuMZppBDltk/14f+tOYSt1aEpgN8MXtn2gzSTQXd?=
 =?us-ascii?Q?aFKqXDLzekowxK+vn2nsxeWCHnlWy/krWGoSwS+/s/QhSiMp4EeP5CtgkErJ?=
 =?us-ascii?Q?4Mcy7tMNLMGgn3jIuXnVkhSkEMKLJD/GoGaPx+Y1tBFCsnib49K19PDPldKu?=
 =?us-ascii?Q?fgQtOvfcHZ4doZWmARUKx5q/N6Xk7UM35iS3wSwyqpBqzs/wDsJGljks8EUs?=
 =?us-ascii?Q?yWkCiOLgtyvYUVBLgAYiCpE7YlVVU9lFEcfXXKiZwOazzvY/tRcUruclkhph?=
 =?us-ascii?Q?YxlLpy26rkfvyNay+LaKBIWS7uhy7eDa5VadRbGv6TxiPkZdEfWT5DwC+tgh?=
 =?us-ascii?Q?8ppbo3RemJuolHnhrZdOWTFGURuhNFJJmZersszFhNCvheowi4RiglZEBYC9?=
 =?us-ascii?Q?vReezqsOd4XVKLhUDtJZbJ89n0Ph5wCY8cbumjt1LXQgZc8o1ncrYQU4mxSH?=
 =?us-ascii?Q?tK1IVJf+dqT57kzOJuuReNq6z1UYxSfNzLnc5MgHT57BWXvJbTxOoYX0wu+V?=
 =?us-ascii?Q?ZWxORJF8IO0E8HzAkmQ+7SuS3LuVcHOD4dhUzVkccsSrItI0c4tlBQqZRQKy?=
 =?us-ascii?Q?drVOZ5+My8BBkAt9fnY5dbDyLGGrsjX3VyJ/QxxOcSAzQ1HDu6FqK2Uz/v75?=
 =?us-ascii?Q?ns4EAcM9SrvgZB2KjwoRbVCgJj75KqScMvG4CvN7v31jkoJzh366dUb7IvnC?=
 =?us-ascii?Q?cJ6vG30tlCFDu5yKvh0Vn+ssviPaoV9Tk0z+wWN/a4moJKZ2vKFNrQc8pkrI?=
 =?us-ascii?Q?YvjxRXYyBuq4ZAC4I86o/BepL3sK3zH/vKmr8bSReb/QTkzobUNm+hdeJeT1?=
 =?us-ascii?Q?0QHrvFg7IBtiku4Z0vHIKMnQVYqlmg3jtTDjvx10Xo7lriXlcJujAF5Rm0q6?=
 =?us-ascii?Q?Shpk0ZFACJeg8FzxLzCmSohipClCJiWEAlQCfT0ii6gOn7+INn0gl3y/Z13U?=
 =?us-ascii?Q?Z5vGdaAhPg2iy++jvDwnb0+rd9fCYjsonF9AZBiQJva7lJkn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a081c194-db6f-4e71-46e8-08df31437622
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 20:23:12.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NE4p4Y+TtifH4g7PsOtZ5U5rpu9MT7k7AQX1c1AqwzhLWXMqxfaItlS5tLc/Kdev
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5859
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F717C0006
X-Stat-Signature: 8mn4qixcjumkf3hxk91hrdpy4g11kwpi
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792786998-503705
X-HE-Meta: U2FsdGVkX1/i+Aeywef9rcmKUYJ/gaeQcCvo75kEkeZ5vXyUc5HuQ728OApAstJnPVLnkqNcH9NRKGNVwDGppP68kP+jBxxuHjuOBEr0goDl6/zABIfEluQnndoKukWjf45EW9A1nMv/4xpyaz0hDt8CjAgi0OQy50u1XiYOiwpCo4M3M+jBHb1SL/6EpoFKSiwNnekiamhDS70ZQRcqO+qVF81EkU8c0MbPiy5yn6JDi1O4CWU8tJsfhqCPMRFjFAL7AbTMY+R+L4AOkCFfxKEdT8fwVVT6Bighss0mCInKiMHJ8hDwAhTqQb3RdI/b2YCv29yeHmujOM9TWpKQQ29ny7alNflOEnlg/C7KokyYkllqhXdZbeR9U2SAve+a+RyR7KQCAVJT51UynJ1aSSh+mDsz1czg3oTWjxPMH1dbYR/TWcTELi+xjNr38xfUe+RL0qFnAwNGp/YrCaiOif1/0O9yM6CknSyu5yJUNpQwHqqB98M7b6LHTr/CYTcutIOe/BDT9Wk65xoxkh6NofvOtcoMhQz+Fr2YtVhpwQQ2/uKZkteYCJ2PSGmmfcgyOR8fvfoIUh3CbJ4jEYGzCLUje6/a2pHnuEuCdof/c6rHipFWkvNjVAFZGC/Zc4cqgM1viTCydkjMgVPEyNK745NYfYJTO6FIBzgfKinHGyPkVIVLro3Em6jsfufUd/Ma9f0Vm+zoetDsrMeHkHMkoW8Yk7+BWxoBK+ESXFgVukLcPGxjnUUvvMZdkwbpKjI85OfeGYRnNzeuDUuJnzB+kfFUjfOrrBfsflN3uwmu9Xd/wzsofnv1PNdJQPoAA/RgFiUpvi6GJNnPkPAPG77X5jvJGFkDlF7M9TluVB9D+gZ1yUx/04487e3duTotTu610eEYyx1XOgFqwGsd+Oqb8OBH3xpziveRGRKamIsZpmpeiBHMfNGLOWiLHlgHqMl4yq+fxig+vsxjTDQa2K7
 sJHXTbrn
 YpLP3rIG8dNYL6J+C0lwJAa5+bVMVSK6gptD8V0G+y83NmWaytVmuWxmuYlVVSdUmerABC7V/zJVv591PAOhcvIM0qIgEA91qUgqWE1kvyPUxmUW/B6e+uHOeNTHfhcV9OWWGN9t1hPrwhNODNuqpWJPaHaS8Htt+0G+99eSDa4Wlgbj3BNfykayVqoi2tjXRPn4951BtZM0DcdYHLJcnRN+dmwTt1t1A5wyrPv0go8nzjd8mzT44Qxr3y9Q31zJ8v8WBTA6JR+9Q5z8g0/7GM7/DVabUT02+ZHcIlLz2kvSSQXhd6Kzd+cJtkZOuXM4TYPkZt7wxvuZ1BL2bVjPAVKMElglUiSMOvGZfIZVIP7/Nq3Eri8x0W94BlosJlWwNznCyAHWs/xiapDAsYglX0ucHLLzHpNIkYySrLJqN+sKy0Etf3TqaBJliQaQzVG+Ma6+uFrAQDi32h4HK5IEbAN4qyAAW2W+74+6QGgzJAY5EbZtNd9C2QeDmnjokJJ5ipmzViaIObhN/BPDk2/zAMv3u+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 23 Oct 2026, at 12:10, Sang-Heon Jeon wrote:

> Since commit a492abe28bec ("mm: hugetlb: move mpol interpretation out of
> dequeue_hugetlb_folio_vma()"), mpol_is_preferred_many() has no callers.
>
> So remove it.
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  include/linux/mempolicy.h | 10 ----------
>  1 file changed, 10 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

