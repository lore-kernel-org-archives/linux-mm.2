Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325BA606A325
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=c5yc5uR5
Received: by kanga.kvack.org (Postfix)
	id 141A66B05BA; Thu, 29 Oct 2026 22:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A7B6B05BB; Thu, 29 Oct 2026 22:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010D76B05BC; Thu, 29 Oct 2026 22:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B71556B05BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:17:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FF4AC05CF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:17:23 +0000 (UTC)
X-FDA: 85377680766.18.050839C
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	by imf27.hostedemail.com (Postfix) with ESMTP id A81E440007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:17:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c5yc5uR5;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793326640;
	b=24F0/g+FwCPo6MJ7dRaQMuyccO3ObbDpKwPlL4yD+HxEfKoLFv4tUGYe8AK5rdSTjsASUh
	82+Sei12iYwOj06dnk2ZdVeW9Xyd7PDT66HHP6AEEpKOmVtv9ckrLj8QJyqZSiDILDkYNF
	0qB2itoqBlLTApxYMSUyWqPzCb+fUNw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c5yc5uR5;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793326640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpggTdqErIKk82O2Wk4x6czfMl0cYZKj3Ft+MlWdw8w=;
	b=o8EGSJ209dXULNvqT4gCdbPZfG2rW+9gxDUOuKbMbv5m7eigNlM1ioGzUAiwnUI4QFLaZb
	3xDzeO+KIrAoSXzOPl8VE7JHxXmKf1Pf/0OAmugd9J580s4Ml4ff4QJV/rycC4tdiLONRc
	HdtxtBuEM2ORgtyZlw4voetol0/lEsQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TEMU+MOg5ldmirdFQ6YGbwzQDx7mI7T8Et5uPFNNk3JOBnaEBRo1EcfCDzyM8jkF2EqHr6Yk9afdojGYVz+3vPOI0V9lN09Ld0snMak06Soy5EUjcJSOQ/8JRtaVL7CoFe7B64SPvvFCir97lk9xwkfbQRf9F74z44tK56qtlwN5glQhdAmnQP0LRRJaUlujaKpgl685QFgFsBjLpYT+MeDYC1cwmFNWinkVSHiFLEfcFVHfhxMEIXwPlyUN1fgvFSEZ6Uga206OQdft+4WRkLt53V6HB3GdSCuvq5t14X69PD/AaqrLYhTkLZVl5UuJ3R6D20z3YXU/lRiPaMwuYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpggTdqErIKk82O2Wk4x6czfMl0cYZKj3Ft+MlWdw8w=;
 b=BIJKi6xncc717DMumbKMa5IOCDkl1YFKEax4IyEAk6w7fFEqhs29OISxEsaqCbX62coQQpRBnRXUb3oxKrYhY4dYcgkRJFi++q8N3sA3OBosGNzPtEZlicCgRaw7kNvh/sBGpbwIuw2IBX+/qAQXAO6p32VDKChM/KtoCFl3n3mxF9f3zaKEtTq9Uf7gNFUWFxkOFi4pJZi0FZNoi8yzOnkEvlWRUHFyT+yJogQ2bg3NlihQkNo3KLyZr3OEBWFFCh8g/wPFwwtCYXnjZr8KAIM2IRezjKKJa59JusEsSV/nReQXYADMIPe92m/jvmMne0GWdQuXw95pYo45MuLtEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpggTdqErIKk82O2Wk4x6czfMl0cYZKj3Ft+MlWdw8w=;
 b=c5yc5uR57dPd4LW5toA1A1EDVce2st5UF5LipZHRo9WSmIlPWC/aX9rl7D0qRRD/VxSEyzDZtlBtyE1aKN5wly1vlygIDapC+g9ilSRq3EURpZfGsbb1gLIM4m+R81SRcUvyDDzcKOwvYobkO1vNPQfmSQxbsR0iudWPEZ39KZi+gb0UQNnMkYCNZNsilg1SM89TlhGYQBCezGn7uG/kJ0WuqmEiDPxPMAMNAIi67HrqSh5CW1vjv6X0kHHBJ1l0NMKDS66s1JL6k8DRqmXYmiJXbgyNXesOIhw7xrRT6FIdTBXq1MpRbbiY09rupU/4jeFOmBInJA3pDDHkZpmFQQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS6PR12MB600903.namprd12.prod.outlook.com (2603:10b6:8:4d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 02:17:15 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Fri, 30 Oct 2026
 02:17:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] selftests/mm: load xfs before checking for it in
 run_vmtests.sh
Date: Thu, 29 Oct 2026 22:17:13 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <B6EBABEC-23D6-45A0-A718-6B0DED0FABEA@nvidia.com>
In-Reply-To:
 <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-2-16ad772850ee@gmail.com>
References:
 <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
 <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-2-16ad772850ee@gmail.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:208:329::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS6PR12MB600903:EE_
X-MS-Office365-Filtering-Correlation-Id: 098b8337-6dec-433d-e21f-08df362bea08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|6133799003|18002099003|22082099003|56012099006|11063799006|4143699003|261022075727099003|10067099003|261021123027099003|261028144727099003|261022105027099003|261021121427099003|261009223027099003|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	MUqvYzXWZ+IImFJ5zYVWV6VQeNwJj9JePtpyQweQ/KPE6MRa2sz9kMrRRGGEPqKNBAXiyncZGA3J2lV8lMcox4vic0VX7fULaHPo/R/gOfbB3whpIxbJkXI5JQUzQVhRr4bgQqPwUp0P4eLgjNp5V+XF8gC+9t3nYD3/SL9w2hZoA/D62LhhRUOhdnR1OnET7Z9BwtaGG+jkugMZ4NbMV5hSY0ExuavX43fUL3YhSVHQou90OQ5g59ViB8WPisUl4kHcGHThp2HAAcuIkEqqxq2l3X9Z9I7HYFupF/NERBOfX5ugiBRM2JDkLuEKgZkNPAND1b4B50GxIKwzERF9SIrYimrTmwAUhx2QVIdFEUTgzuXIK2+TxuIZ6sSBf9I9ISJJABN9qRiIR8EcIQac9Z+KP/eXcaDjViZogqYYxuLJRCc036amUum+aWb80u7u43j8xTg/2FUwmJtH9Ri3vAUGTBYeaVVM8qQhoF6hlZ4ljIO0qwz3NAB6W9yZXPe83we+GeTpc6Mh1ptDJ66OM+SaP+WKx9bArlu7q6MAg8vCPyV2RZJr5JdGkheP38EMDYVKDY2k4MAndStcFVDN7ZZPlnLZku4Coi3BV4id/m5o5/+02BrGgFgWp8bvW0o2JvigydNF3RAkwdgLz6s0egiX5G5rjiVYxYn2G3M7aYY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(261022075727099003)(10067099003)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261009223027099003)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?REdielqp8aMPq5sKWNa1GSIOPT743wC89NK6t/LQKxe/AfVXyLDcE2kHtGjl?=
 =?us-ascii?Q?vVntu6kNKWGeYTCdNWVaSmbca0rAgqsbNeGSY8hh93tzJXTWgyv73U5DdV0T?=
 =?us-ascii?Q?67km6yRlWRE5/bpnnwaTf602aKFTA0Yb+wqNxUI0ngO9KDKbfmdYJtUMJFtY?=
 =?us-ascii?Q?xeprFbFbf6S6B9P24J8Pz/DrB0TCC1Y7FVioo75lAJWFA1nF2d+UUjdI8kLi?=
 =?us-ascii?Q?cMRz4OIrBYyeRqwhFqAd+ELabwrq5ncoenskHPYcy1dQYPqKsgFIecKtlp1x?=
 =?us-ascii?Q?7MWAz+jHYaAhMQgq9/ZmZkPiyKnRwyIODy2sicQSwSreiEz6CK9HgN9I1RfS?=
 =?us-ascii?Q?DiJzTRMiJ8r4q8GzbfDPW9wWlnfPigdF17410GD4mh18Y7Wq7+fcBfjPbqJz?=
 =?us-ascii?Q?G+dbAdkheUGXP+bF0L1x1XnOJxWY4DIurYul9CpDmlQ49qPKqG0yAWeMM/Gj?=
 =?us-ascii?Q?bB13mptqVjeXtqjxPaq/EExxpk+Ri+lC2V1ncSRzem2ElIagFYuAoAJfBaZ1?=
 =?us-ascii?Q?HbElLHawq0UNfX3F14O0S/AKrDgAPiBtLy70tUEFx/Kq0rp0y3ktUpAz9ZMu?=
 =?us-ascii?Q?v3D7nsWKHHJtRH/9ShzWYTSTyT3IXG3ROk+uic5svkfupH7KDAhr0H2sM1Z8?=
 =?us-ascii?Q?V1BJ2G2Qfk6IYWKFxgMo7h1aUgKmtmVxhSOsGoTdDWPTelcH5Q719oNHRE66?=
 =?us-ascii?Q?Czl2wmXhwJwNHDAKeBg/kAsl2pSUwPKJGGVh3CY0QeNDL4P5fo+FE1bgIYDE?=
 =?us-ascii?Q?84l7Ne3LUZD5aiJUw83RfKZXAyGM3Es39wowgOhr3rJWcL4wwj1h6o2vSHqI?=
 =?us-ascii?Q?0ihL+icZ8z20/DZwHsM2UGc1LGLJX4iSOPu/CcIHdim8Ne07GPsTj1HtwdL5?=
 =?us-ascii?Q?GYgYM4+/gpzIR/tUQe/nEVAAJJSlS8P2fFl53PYefpXnfRP7rNPxnBkT/77F?=
 =?us-ascii?Q?J/4PyAfzeM3uaybuXxIf1rC1WojuTrRIf7hRK23zcePD32Xhs5Jhq3o1l4bB?=
 =?us-ascii?Q?213sqQFwOzBuScCaSGUSyokFUj8E1JVd92udTnErdd1HTMluf0QCqzzEcSoK?=
 =?us-ascii?Q?Jp0mc1m6apdDp+m6U+43eP085QkGyw4H4I5SnKeMRpZYuU8RLstPWGFnrDaj?=
 =?us-ascii?Q?2xMoCOS/jCOgiIn3CflxN+KX+UyRB+cOCRvRN4NH8bLtCynZFpoZVVYIYA5l?=
 =?us-ascii?Q?1j61UJK9ZVhq4woz8J2urQOGj4szJljLU0RxyYLAkKBuJqduM2H4uWozsvla?=
 =?us-ascii?Q?9X9bGu+RV6YQAOiYrCTPDwWe7lk8mH+H+DvPD2af7drYdbS8kCGk7Zonzhyj?=
 =?us-ascii?Q?mW3YtGrsZa0uzlfadL891/PX5a+Z3NDtvDRo/hwGRdLzZkaReaycDRQnfuQe?=
 =?us-ascii?Q?sHUN6s9XuT9cKPLey1qKF4xt0e1Iv2C3NRaS3zttBL6U8EbESBMjK0zCY1Y/?=
 =?us-ascii?Q?w3IA897re3maAPUd21PbtYwis/cPHxk/GLYNmMgx24QOSO7wiimKuqxxfA+G?=
 =?us-ascii?Q?umOFWX8yK0ojlmibl+CR0XJQW9ky7KoR4oMKgrv2H3kBBsBndTvgdXIVvaPc?=
 =?us-ascii?Q?fc1wMMHyHsW1oO0tbXHtRW0ZFeh3Jpz/HwfeyN0g4R7nPH16GZz/459ZbPu+?=
 =?us-ascii?Q?aoOdbYj5wVouXi8GKxBWTy0ft9Lc5Ut5P7NxACXSFbQucA9I+ovIfZypGqug?=
 =?us-ascii?Q?BvRKbnTGFRk3j1ABmY9r+RIhRRHQaC9lNK2MJvk4iExvZIyX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098b8337-6dec-433d-e21f-08df362bea08
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 02:17:14.9322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/B2DaVOBrto/eTp9LpVsc4QqxFSBroQT7leursYO5tWyBvCnf70hf1EoVWIcvAq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB600903
X-Stat-Signature: n6i46yhab39i4cbx7zqr7orfk6qbx1gu
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A81E440007
X-Rspam-User: 
X-HE-Tag: 1793326640-658342
X-HE-Meta: U2FsdGVkX1+s2gvWIw+SxfJENRLvFt4N9lHwnO6QDpoAwiT67ijzx/OtuD7L2V8OSlBYM6OFpQbJJgc4YD/cuYjzep59HZyOG3UivTZ5DjABrFf81raQ1vFCX6xTq5VQDnNPb1jBhkUpYW9jW98O1NEHbPB2yGt6CJcitdBPmbzdEve3LJ5NooP4pxTjlcAPwMZowo73Li71Aso+V0r92vTYpw95jwRKB8nrIZYJnoB6i7YQXVJCpcm+vCsPSfWbWOUIohds1T4tRzdisR5eJkeNBYWJMfYgbPJSrcEC+eQERS8fvLMPQJ6V1pcx6AHTq80WzsDWPaSmcHNIVUDcWTZGYCQazGeF4JrjkS+fNdbRuaOC66j2zUkjfOqAJCB1F8nh0YrExtcRW0XoGvm7oWDdVsbNkW4QJM7kyvgBiVPq4d0dePZLGHvO7AoMgUNW/Siijy7A1w3O85Tw1FQLHm4U5mB7kq+JkmsJ08WQDMEPfoLIvA6KQ0xF/kI3XOpWpGKJxZIA/GxxVpmCyi6gZdB1amnE9LFSbFX0SdEtnStZx4F5tDJ6kYhA7+00FeftJ4S4kRH59ba93QxbuBVB3b/emyhgAXnMFkNyMNfv5pDUCBD7LSsOs4S73vfSgKfZxu7binxZKQk8ekcPRCrhz0f5OGUYEpBPnUffWqDCMs2lArwumzaWKQ9KdGbNklzIZXIWUbMgtC3z4oml5asWAYnXSr6BbxeBIKTWJz6BHeLGriYELp3cXq/rTNqVfzv5aGaITy5mCk4QEReaqMVn/AJPuFvxJpHmBSfiKjSpafkTn9fZoRq1Vim4myEfNUt1SqCtY9l6OZcxYPHfrrjdG9h2gxmCL6IO93LCpCggz6KhWvnWEK8rxcC23p4R3Uwk1dSVyeHUWtjadHzKK4L8WxhR94ffxmDppVoDnm8OyW6MQAMeVHeStQAEmiNaiAMjIRK0JfRxjruy19JgBnF
 UDJHU1Lp
 U9R8IGhJrxlqCq2Aas62rC7sA4wCLCLSFem+nBTgC+UpwwttLVLz4aT4vWCvO6DJKSU4U8JCTtSYx8KV71ANPplHJVEmor/XtpH4angxTFq2oHalnl3S8hWeZSO6KWhK0iLKIaALkNZ2Y0+08DSMSMHK+lqkAVKJABYHEP2inZMgwUkzL8twELvLqOv6gMhRGi09oXnXiyAM2P4LQzvvBRCZwbXqe3dCnPyqMvJhaeilRG6l9f2JKRgn9BsdD4FAdIjkkBFUeMbQFXCqLd0Z1iQCzEjmPnWzdiBxzQqcLP7lGN0MUAz403tYcuohQn8DJhZnlb0AWWmP5gXT0rkD0DXdn8Lnb+19/IR8yBKRXQgBY9Y2r8r1+Dvtalibz39fOCgk09RmH+hMR8iYlJDFsKx5G/dNNnIpcvp6QcPut+dFAS41IILfJ8m6xxCQaB1kACJhl1AS/kxiIn57HG9Bs3TPHxn15kQdC624YiaakZ+Vj+D7Ye2YseszPyJiSWW1dxffph9bSppUvNCgn/AQpDLW9Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 29 Oct 2026, at 2:24, Qiliang Yuan wrote:

> run_vmtests.sh creates a loop-mounted XFS for "khugepaged all:file" and
> for the pagecache folio split cases of split_huge_page_test, since
> tmpfs does not give them large pagecache folios.
>
> It only does so when xfs already shows up in /proc/filesystems. When
> xfs is built as a module that is not loaded yet, the check fails, no
> XFS is created, "khugepaged all:file" is reported as skipped and every
> pagecache folio split case of split_huge_page_test is skipped with "No
> large pagecache folio generated".
>
> Load xfs with load_module() when it is not registered yet, so that it
> is unloaded again once the script is done. Match xfs as a whole word,
> as "selinuxfs" contains it too, as does "vxfs" on kernels before 7.3,
> and would otherwise skip the load and leave xfs to be loaded by
> mount(). "run_vmtests.sh -t thp" with xfs built as a module and not
> loaded:
>
>                                         before    after
>   khugepaged all:file                  skipped      run
>   skipped split_huge_page_test cases        43        0
>   xfs loaded after the run                  no       no
>   xfs loaded after the run, with
>   selinuxfs or vxfs registered             yes       no
>
> Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

