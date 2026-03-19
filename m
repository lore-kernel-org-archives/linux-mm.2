Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC2F1091904
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA906B0581; Thu, 19 Mar 2026 15:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BC26B0584; Thu, 19 Mar 2026 15:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72606B0586; Thu, 19 Mar 2026 15:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 920046B0581
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:05:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46DD61A06BD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:05:33 +0000 (UTC)
X-FDA: 84563741346.03.EAE897B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	by imf01.hostedemail.com (Postfix) with ESMTP id 661E44000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:05:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I8qKr45j;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773947130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yj25kFCQJqFRFZQqokzMHCxlT+7im0LjVWYrdh0CSTw=;
	b=Pg6tcraidfMqNRrSdJIitTMCtymeZhqpDHK8QCIIcWgnWEJ6uxVV0wTIbyiziQnUl1VNQ4
	n+XrinhFOkJRzpLwZ3Be72xxFc5BqkWOHItVWjtqOLuB3gGvBWuFJgAs48xV0QzLMZoFaM
	GhV2rB9eW43EKwc5GuceANM9xtnMWrQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773947130; a=rsa-sha256;
	cv=pass;
	b=5e6zL6N+Bc1UXp0DD+yghIX2laVanp9oUl6PMqEtG0We8z6ABEyziw+J0H8UNO0AaHdNHs
	xjp4YjXpf/gFnTxQtcJ7KHvN87rrGACHKmcZ+c43iaVr2NU9k9qLo6YzcNPCrHmzMKiqoe
	edlnMYA1hSwDsgGHonlD+WqDUDGAU1M=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I8qKr45j;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1/mdasfheNA9BGa/ecNU8ZxWTcvP8Yj7TQRi6+MBmYI1qryqZSZCAMJGja1XvoQyFwQfqlf+qj6XN7MUIIlXl3cYRU/9SutO6KVh/Lr+sxWxKysG8EVx3dM2G0Aia+wCCPtWDZeTH0778CHygM/yHPmemiKS+fq/AI9M71QHpgf58ZzUXej0YCSY69xr9sbVfDDAuUCB763KMSB73E3JmPIsdVQvS96eEX2GW+BNFvr8lyqcRg9E4HvmxUIjpOp2ySVaQ6Xw8QdlSKQ2wWDh0+U4TCL59YZQDpgV/kEKRlDzGlznZbCAW7xjfgRoxE4kTYa+VslVY3uQhXbVo22XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yj25kFCQJqFRFZQqokzMHCxlT+7im0LjVWYrdh0CSTw=;
 b=E3eSq80gp26BoGbXqecPqsSZpYanUjaqWiNanYD67JlduKFiMz1wPx+ZXgiyeah87aigXY6DsMTzVKos4EgA9iBZUROBsgWtVI/D71BGBthV06LdTQMglejrY3xDA+UG4O00zKVwv8jXBezhVz6ibxdMtl7NEpV5t7UQQn1tTjTx1zyFoZZnRNFEu0vUPqFq2dT3TXHmFdUXzQTDcvmZqEI/lEx0bjsZTE1D5cKLoryJUtEjPfv6jQioPRktuVAF9e/SBkmGcGQtprAnL9ZlqYqUgWIk1raR1WkNFknCl2LI5u4JPxZmTgJHBqwEro1TkLQ2HC3JTpJPfDJ0XbiQkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yj25kFCQJqFRFZQqokzMHCxlT+7im0LjVWYrdh0CSTw=;
 b=I8qKr45jiz300hbYXfAbO7NinrvJQEV7yXyy59WTlqw7Ontyaf1WEzKQyyxqERuI+NoASI4zD9fk7VqiXqO+Qv76SYRuJJmdQJ18XQa6qLSBKFuEtZTIc0WePAF8b6iSi/gf4a4N954pUzNHxTZSgqBkeCmVS/XSXvk/k9mv3aKs1VpVXLbRw6gnagUm64HM7SvcS0pFkC1X5Hnu4z3EOxHFWfkgTa1VYbECqndsLD8PhwqwyI8AMiHaruYkcgtFbehXg33ziUQxuYg2LqHaap9F03tdX3Wz20wPo8MJxn3OAXiIzT1F9MsksFbJSi10SR/6x9qGSz6GFN1fBP33Qw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Thu, 19 Mar 2026 19:05:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Thu, 19 Mar 2026
 19:05:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v4 1/5] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
Date: Thu, 19 Mar 2026 15:05:12 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6C8E73BD-E59C-46DE-8FB0-9BFF18698B6D@nvidia.com>
In-Reply-To: <20260319160656.1480279-2-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319160656.1480279-2-chuhu@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: a925d73f-3f8a-4968-4a06-08de85ea75cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	X5VUS6q5MdRAC7PhuRkQKhoXPbTM1MBxPg6XHKi+lmiMfpGSdKemonkDrL9CxC0P8E1JLxBbUA4Dqgk+VhoUPBXGxFG8QoTQctuK65PWzOCOj8TMaVgWGm/3KvT28qDo0ax8yY2WlN/oC2VJEfQuXvmpH00xN7ja9lPHjhxH9z5IsmegvCLqhkkn9XYMHsvSxO03HK1xwCDcy9fLu1sWlCjdYid7dWAZ1RX+LQ/Jc3rq1LLZf8T96itmDdBE7jEp4qSDpCm1/5HlfwFPND8Q3m3OVjAX5bEm5C0GEMZrS16t/N4Z8X9srJHZQlS2G0YhYcHCaPFmTKCPDV/xnoNtF+D7vuXc9xTQLdASLytEhfE0IJeJj9zwOrRhrgyuC0TJtWDqIvB6m3Z5uo0ompJn7xtPbrfcvY5sO0fjr0Nz/Izny3p0olcZ1xmhoTOSaakCI9QyAnbwOI2GSfXIorMmnzmkcdiKVcyFRSXCdwponG8oP0f37S19yJdPWRfvngSRfHfmciHhrtXeNVrNaqv+kGqZTTGvkRLMknk9gVE4xvh+sFGDzylm2orwRPlIwX3zSMVOiZbo48UA/j4U4YLvinJS3te0AADunESm0qPSHAxmyg/K1LYr5toQWDplP3G6QdxcZrMBFSh5IoPENOVm5MbWNpYMO99PEymEwXSxsNEDELT5y8y0N7yYyGUrzqHV84+ncc9uABuSoNgyjBPNXxuBan7/6zlIykaDzDY7nMU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FhQZgbxs079MaTDRgoZ+fV3VrlU1+hsJxvu2NQSoa3ssR19rMstKTuKiGjgx?=
 =?us-ascii?Q?Z17ipAH+IstwJqiG2T2tSIEbxtnPW3co2vHXDni0XfdgNLMbCN/mMhoPqwJH?=
 =?us-ascii?Q?/hGt189UGCN0vdMkCqaYyG4eYw+es5kok55s7+8SCYdUqBldWcx31pM0mdO/?=
 =?us-ascii?Q?g2hnvDCIXzpV4kuX7DmV3aqjR/0yQtY58Zru7uCoLbdjpb1++l/Xn7qdhdiG?=
 =?us-ascii?Q?MhzRSx/mMODXZhuBUH56U0AzkE2PrZ+O1HYEdihsxsgfK7o3rbsDHAgLy4ip?=
 =?us-ascii?Q?hG6h0JM5Nug2e2vYPffLEEQ3dn7ZxdMKQyRV+VLYYU1h39GU/+pFt0x63kFW?=
 =?us-ascii?Q?1SFPAyMRTuOhDbRGdm3NZOFkZyra0Jx/ElUL12XYswkxbag96WQK3GaraWLv?=
 =?us-ascii?Q?yq4G1exn1LZJkNfcTao5praWFO9FaYxBNSY15p2R9oc9fCGcjdyShs5UGjGN?=
 =?us-ascii?Q?PsiwSdaREZyFRpvnQPhptWUyMyw1Ih8WXhXCujxwdq9L6clEoalpy4CpdVgk?=
 =?us-ascii?Q?UbZSH/CqifixDQ6/ms02EmJ6pzHSUvra2rednomrQAQUW7I2tYpW2J2nvCCJ?=
 =?us-ascii?Q?dQRNbUQjZVNtgJl/4A/DeN0s/B1bx7Y5JGgKoSicV83F43cZGEScDcWYTTBm?=
 =?us-ascii?Q?AxDxGoCsNer1Nkikm9Ubz5qklmTiBjxS0/oZ/d0a6aveQQmT3qb4Ji/EQwMw?=
 =?us-ascii?Q?0W3uxj/CWYOMqesLrRd6O1UJYpBEjsUX+3DLmVY7OP2b2xi9EABYeJDbS724?=
 =?us-ascii?Q?cEQqGOMxPbU04NhoPowKTvtG9sNppyIiaqm6/okNswecrhcFJXXEzvuqX+Av?=
 =?us-ascii?Q?Kod5oMT+gGP18gcMr20F1+kcozlsnhNdALWUBZgIxbGptSelNwPL/yTOdSzv?=
 =?us-ascii?Q?JhftNdqnAoPddLUaVFKdYSHlvSKEaIleI9nb8gIg6YmrHD3yQhiIbvkjKjJn?=
 =?us-ascii?Q?q725pKVQbZx2bZlnsaRFDnWHnX4od1gOQXZKNKnGFmH6whQkSHhKzAROjOUR?=
 =?us-ascii?Q?YiK0VKbPkPlrwRzsTP64pvLG1tHd1gkFJ8DMrxDfh84TMrK2OgWRm51TN/PQ?=
 =?us-ascii?Q?tU2wUm7N9P25wkHdMGk/zuoeIhzxrZ0kqD6D9A0YM63FBwxj9eJ8Ktv8TOv0?=
 =?us-ascii?Q?15RbCRoesnYyEeMrMANs6QkHqXKbW4EXdvMobhodM2nbGQN/snvCQna1yv7S?=
 =?us-ascii?Q?QRSdACY1KZPPFlvzmqD4TATdkTs09dvchOHAQK6pjsl5bGOUl4eaqiK/p5zp?=
 =?us-ascii?Q?J+Rmu90lwqlDOOfj0JmOc911V5kNdklASEnKs0Xwe37Q3TC1cKzcQKkybvO+?=
 =?us-ascii?Q?pLyLzF/UkwZInu0qOvinpoPlfctbjjPErvypFN/1T8LeA4FjmSjWUfYnBc51?=
 =?us-ascii?Q?mi3jAKc1eiyZ1XgD6wfjuVSsAlZWDPXR6bioeB6MJiUbq37vLCUwmGb54FKL?=
 =?us-ascii?Q?DwyuKKdReyUKyW2NdoxH+SYeVQP1kShMXctOT2rx0qlFJVrbKdYuUFb6ZuX8?=
 =?us-ascii?Q?89C9l14rcCGtWHtwlgvAnUlMf9nTqSv0vxhWzH3S+i3KsgOyDKqy4Y1AavWj?=
 =?us-ascii?Q?RoX82cGLFo0x7HHQGS57tEMbFwEGojadXTlYFi6+78LyJd7tHOccEP6s5Of9?=
 =?us-ascii?Q?fW63t1bJE1glV2g2NMQG2XBFnyVzP2jtBkk1R6Cz6yYVpp2PC+211yzkpCTD?=
 =?us-ascii?Q?/0MO5XIx9/9WN/yixbxPsRVm2RJJ04TfU/7Z7779XmsY7tGV6Jx37Fk0OBM1?=
 =?us-ascii?Q?4v78F2mgtg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a925d73f-3f8a-4968-4a06-08de85ea75cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 19:05:17.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ceeSp5/uQwBMcuSwS5qalG1WvU5HKEhW3bkwSIjy22xbx/yeWvx8Lh8U7rIX/JjH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6120
X-Stat-Signature: qzk5776an5pux6w5fudzwkntbdqsn6gg
X-Rspam-User: 
X-Rspamd-Queue-Id: 661E44000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773947130-799652
X-HE-Meta: U2FsdGVkX18tFrVepQ0KBvr1UWvLCyk+TgbCDGucWNTr0d9k3NQi4nJipU9SNTOi0izI8Kj2AL5lUH8s0mq19QyHVIoE2BUlELXE1GI4MxQeuu1b9JVBPbccFaFHmsRAr/g/+5KW8yPSf2280I5iYp7qRcZz2euEGuufpH5TwFHJUDC/zY2yO+L+TRGEQsHutGR2s0GV8Duj9Czax0POV/daF6aEOsxx+I5Fa14eC4U5kNHeaXhDqrNt/gTO7Lb22nEThOv0VKLrtcbznP4+zbjpcUo0RIGFOUQi4iux/UTJ7+XLyBW0JSZUNRZM8RXaQ9zB6Y4Z/WSRnhs4TJSLG6Ll2CbAaNBosAqJL0QU56GOmHWe8+d8uel/vgdgaHXgdeOnATFIacRVJK1Tw554f3tUHeDPlJAYORFywd1ZB+xeJ6jZoHKsD3k80zf4+9LC1k7EHSw0Eylbuef1QAvLU9F6+Syk7KzU5Qvx9Yl8y96kpZaubOdEPGne4xlsWvQM06qwFAEykG65kGl8sgXRFZg86/c5FDTYCQxr77SYzd9XW4b/G3g+NGk1s8s8qWGLKuGM0k5KHsTHPXS1QkcGjFoyKAOSWHUH6j7yBelRl1edQGPpT2BfXkTC3xQA4A1FwBpT7cQKWLZ/ZfBAmBXSgoNenAP6p6Wo+2nivDsvRumrMkC6uQUnLh4aE2OMm74dJd4QICyJI6bNHDA0/RsC97ojVT3RoSGoiy+20g+HmxxKwPnb4bkB4itknNEBYQp8yoAeZUAG/vlpy4nQtKGBNoSsdiIy7C84je+xvav1GCSI5hbk+JLqbYinDIwBMXcZnanPkzTZkYGOyO8msxj8JoD33cocalf3zEVHo7RYSpUNNsai0NBogmwFdf3mZAtnfz/Rh/6gW3rlwqzAkXC3UNI9+gHTVvGdzs1lAc2sy7TTy9lH3lllPmm+DVa2dh92dmnX4VXP2auLmfIM4PA
 IELkYejM
 DLJ1vzfbY2dQWXMBhYYYu2Sp7dWQWXCg+WJaNtAffN+1qckqJdHEaGwC852LhSQEZ3x9553GsJXIsN3irX1WUiLPx8p5GoQjO3ha8ArjuGakUV7494XI2KvQJ+HyiygUdkJtKIsV2VYfOMSE/YENGZRMDrl8UI6etmjI+gGUjf8sq+jD/UdqkNI7gbjAh0Yu7gMEj1SECPKWTv3LjuAX1lXCxEpv9FWDJB7eDfgW2Qg069bvZh7SI2dxR+g/tjysfH/+3UmPFXoswI+c6qGCEtGEgUWbDPeMqXg+SFaNKTI/gOUHcVFkYZPUe84Nr+EfWyXXngpzbwbIbAyhfHU7IBl25YTePqC0YePTk6gQiAlEVh5wcjTlzzL1BBxtu0TRDA+qEa0++zyJOZxRnVS+hU+4uUaNc6xNMdWVp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Mar 2026, at 12:06, Chunyu Hu wrote:

> When thp is not available, just skip the collape tests to avoid the fal=
se
> negative.
>
> Without the change, run with a thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard -n 1
>   <snip/>
>   #  RUN           guard_regions.anon.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHU=
GEPAGE) (-1) =3D=3D 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.anon.collapse
>   not ok 2 guard_regions.anon.collapse
>   <snip/>
>   #  RUN           guard_regions.shmem.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHU=
GEPAGE) (-1) =3D=3D 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.shmem.collapse
>   not ok 32 guard_regions.shmem.collapse
>   <snip/>
>   #  RUN           guard_regions.file.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHU=
GEPAGE) (-1) =3D=3D 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.file.collapse
>   not ok 62 guard_regions.file.collapse
>   <snip/>
>   # FAILED: 87 / 90 tests passed.
>   # 17 skipped test(s) detected. Consider enabling relevant config opti=
ons to improve coverage.
>   # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0
>
> With this change, run with thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard -n 1
>   <snip/>
>   #  RUN           guard_regions.anon.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.anon.collapse
>   ok 2 guard_regions.anon.collapse # SKIP Transparent Hugepages not ava=
ilable
>   <snip/>
>   #  RUN           guard_regions.file.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.file.collapse
>   ok 62 guard_regions.file.collapse # SKIP Transparent Hugepages not av=
ailable
>   <snip/>
>   #  RUN           guard_regions.shmem.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.shmem.collapse
>   ok 32 guard_regions.shmem.collapse # SKIP Transparent Hugepages not a=
vailable
>   <snip/>
>   # PASSED: 90 / 90 tests passed.
>   # 20 skipped test(s) detected. Consider enabling relevant config opti=
ons to improve coverage.
>   # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0
>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
> Changes in v4:
>   - use thp_available instead of thp_is_enabled() as when thp is set to=

>     never, madvise(MADV_COLLAPSE) will still succeed by design. So a
>     failure in madvise(MADV_COLLAPSE) on guard region will verify guard=

>     region denies it. This is suggested from AI.
>   - removed the 'Reviewed-by' and 'Acked-by' as the code changes. Sorry=
 for
>     that but it seems the changes is a little huge? (1 out of 2 lines).=
=2E
> Changes in v3:
>   - commit message: update the log snippet with where the fail happens =
and
>     add the '-n1' to the command.
>   - fix the 'false positive' to 'false negative'
>   - add reviwed by from Mike
> Changes in v2:
>   - add reviewed by from Zi and Lorenzo
>   - add acked-by from David
> ---
>  tools/testing/selftests/mm/guard-regions.c | 4 ++++
>  1 file changed, 4 insertions(+)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

