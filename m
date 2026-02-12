Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BA1EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 20:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70556B0088; Thu, 12 Feb 2026 15:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E522A6B0089; Thu, 12 Feb 2026 15:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29F26B008A; Thu, 12 Feb 2026 15:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C030B6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:06:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E7991602A1
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:06:48 +0000 (UTC)
X-FDA: 84436887696.04.77A356B
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92E7A100003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:06:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j1ge+KjB;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770926805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hv/eFcNq1q7SLKf+y9YESjCOhYSRPm5h6O+U9gH4Kp4=;
	b=dqdTP29Q9thkRWMNYU4G+wzTrLA8zNOSkjugPYjO8wRWEBoev0bLNGtXo2ZT+9p3/4RxEF
	bBlbJC9tXYhdrXX0qW914qELmm1nkthI1a8l91u2Miu1F02LoujmgYss3qi6GkPrtakpWF
	Wco8U1cgewP3ANYjFzgL0rrBASpeDFc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j1ge+KjB;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770926805; a=rsa-sha256;
	cv=pass;
	b=XhAjRiClPUCXu931UJgfA4vUATE9xkZxK+l/qbTQD9kmwiUmE21z9xBWBqkLq7XbpTzPHD
	Yw2U5xH8bpX+uh55V678AteAXZlmbby1USjZDiGBpGTfA+oV4D28NrkUhKj2o5ucotPjEh
	mVeOWRV6k/kpIvkCGfAXBprNu/Rtaw0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cX4HIquPnA1TjjvRC2kN0YsUYca7ry1viLZuFyNEEeRjeQ1rYlDhxfwJ2S6uzDJgIy3kYwjw2Ga7UXLPUTjsmdyIT5lpBam9QOGQyG34xy9A9ChPC0zmfxZ7pzKAFeIQl3BZVrBbp9s6mttyvzs5lCwukmBcgyL3cmBpp2w2RLUIswDgaaBKUB2cbMeRFSt2GMunZH9TU6SWtdujywG/ttsTZC9N7HbR2/Wfwsh61C9ouMaiZ4FpSiOedIuQ04BxMFxE876S/ENIynKTKP6Y+aJ+QZUh6vb9r7G1jiQ+TvZ4X1rQCbWVOFEYs7WdfMqFx5upQ00BXu2o1U+WDPZ2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hv/eFcNq1q7SLKf+y9YESjCOhYSRPm5h6O+U9gH4Kp4=;
 b=wPfTn/9DFoD2p1iWlGF36i8TNlCi2XJZZj+yrv7fgANtCSCk8pcA/XEATpv3ShgbdZLDv8WLzUwpe1zPoRWdX61PQ2XfKxFMNdfIygswtM5g0ardG4+gepsoxatsHz3bSjhVMxaeb2FcyZqwqzU/R3E2K1l2U9msERGcK6VWqgumopRbz8pbKzU1YO0COJ5yx2FM21g8ck785uB8AKTH191AShgLW44dEWKLebGbCBNkEjyV3S/zUaeqTyjR+Fna/juzqPri4SD9LILslbAQtTWixQZpZfU+20Z9W4IqmFbABma6DOXDNQhyhgEK3kE6KMrTvVlVGpsTEmlfzb9Nfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hv/eFcNq1q7SLKf+y9YESjCOhYSRPm5h6O+U9gH4Kp4=;
 b=j1ge+KjBjNGNx7b/XIxTuuvBjbcnOkVUsEoL0SbcoAdlNgQsQFuL+VzVyctsj9wnXkCaAJfv3XmWWPF/Iul6wQ3nqGbHZZ6kQ9ABHc6ipUdcZQdMdQcwKUCVopKeZJB+wcdG5QXOmCRMI/MFD9uXRn0cBSEScUupIGN1kbXaq6vclydcyEZMwPojTc3xcCskJranUi82HUjjPwVptmRIB0oZZS+aN6/KRAXbb5MMrCz0W/6UdH2AFWPT58qJKOkUj3LgLd+gC4W0OXBzkwcRC4HiaF2m/FoShL7u8TVXJoZ59pAocINxKpQKQd7xTrDvxN0VIN7/S7D7X+B2jsuEWw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4487.namprd12.prod.outlook.com (2603:10b6:208:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 20:06:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 20:06:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com,
 jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
Date: Thu, 12 Feb 2026 15:06:26 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <079A6B19-00E6-4895-AFF7-3F7CEED4170B@nvidia.com>
In-Reply-To: <CAA1CXcDNX6g8c09q=oaW6RdPYrpEfZP-Hk2rXo-2XqREm68Twg@mail.gmail.com>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-2-npache@redhat.com>
 <048C7077-3E54-4DFE-A25D-05D3CCB132D6@nvidia.com>
 <CAA1CXcDNX6g8c09q=oaW6RdPYrpEfZP-Hk2rXo-2XqREm68Twg@mail.gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:a03:331::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: 40e91983-f23b-4fa5-e8d6-08de6a7239d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z7NaYY9YabeYoj5L/sKXPphWX9aleGkvn6pbqQYWDqlHY0NgPZ7HXyjldxT/?=
 =?us-ascii?Q?2vQoOiGTQp0zMAs/3PW70m2s104ft1JMD3n6wgtvEHx0mwnXwvi+rwoyHiGv?=
 =?us-ascii?Q?UfrATgj98fg+g3B3mKl6PSSLKqQ8REZ4NMOOWUlyVqvSrvyMVvD71/Irq22i?=
 =?us-ascii?Q?VwFVNuMrWGoHRio2Fp/uEO2oQA7EvpWzpBY4GywarR5WRi0k4BLm/AlX5B6F?=
 =?us-ascii?Q?FvOktvj+B196A0YGHZFZDLDRQBp1juSB15JLH7ofSTHJhVpzC9RMBbIOgMM+?=
 =?us-ascii?Q?eVgxIdQy0HV/S22KpTEkrzDXNGHCFm1f3XFcgk8lLWVBhweiV9U3TULebUIY?=
 =?us-ascii?Q?uyVt2XOM82hLP3KMOK5MSit+nea7H3C9eDpP0xFcrQWOtjdZHjBMr3BuRDYt?=
 =?us-ascii?Q?ScfBu0hjUSc2fiDjcaFTDK9If+ySU9LIBWkkwm0hY6vlBKYjUYdzrJIgGCoM?=
 =?us-ascii?Q?AXxPyp/pjr0VUOCsLYKwRE7UYzuc1bjWZmIQcozd9g7pierm89jtVmIBKmvQ?=
 =?us-ascii?Q?X9GJwyKDJtdb58Vip+SdR6RGYGICl1WjHUNrD+ySrw33fW0nlUqemu9hPhOh?=
 =?us-ascii?Q?1VXdLIN4jB//005ZwjE1d+9tBlF9behUmMzNrXJ26N6mMSUuVN+uKNyrmRT8?=
 =?us-ascii?Q?D263TFD2mFBixpkWLPw+Px0H5KMXOVWnUSeKgudqV/lHkwY1zWZ4ZGpXd/KD?=
 =?us-ascii?Q?WUhYba4fSKfjToiu4FnJv/6x6rVGWR3yR3ev6BTq0INra/ZkyWK9rQnZAZWw?=
 =?us-ascii?Q?BEXoiPnM97QC1rFcJjmww5tCmOIjPPbfNyy7g/qnxfWa0zwmWnw2pqsJAhKx?=
 =?us-ascii?Q?YYb7QHIPS721XfQc7KR2VITR5RX3Zb+KZ0QSGD56jyS/nUTsmefj1sRhHO3n?=
 =?us-ascii?Q?RsPY/Obr/SN3gLZypWcpVJ7oRIdW5aNRnaxhKszfVp4PZNvAJS+Xk28pD52D?=
 =?us-ascii?Q?3/9M6BR92zNCoC92KardGkM2TppBlkJlGIG8qw7tpS3bJxeU94a9q3gVfbPw?=
 =?us-ascii?Q?IQbwEMZfKzM1P6X3prP8tJLPCl7dPw130Dh7BJ30vVDQ/x4JZMZeTXffBQSO?=
 =?us-ascii?Q?39jbN95rsK59MSNfpDfcX6RmgCVi1/js0qziQxJeXwLYD/cYpwr2NP5pwi6y?=
 =?us-ascii?Q?OPYfkoMLJVRL9XzuSEctCqvAcIWHbJnODvYFglXu3jZp0HN8j+bK4JoNHBD5?=
 =?us-ascii?Q?Tr9BhVA33T2ntxu9edNkK5gNlNcVwfHcV59zxPwALa0jBYc++C8jtLUCkgNU?=
 =?us-ascii?Q?2KFGv7Y7yH00Adgpti571OnZLUxUzWk2PDcp/uxs+x/EOAQ5hm5fODfn6RQD?=
 =?us-ascii?Q?7SSrA/6fNExrC40QvJIbxKzYpfhU4XzE7bVU9GjxucLwKaLqiMEAVe4yyVG3?=
 =?us-ascii?Q?osOm/8kFEFqZX8WLpLM6ZerEd0nFWsfgZUwqLhvb2DvIx3BuA1rzAokkcpsk?=
 =?us-ascii?Q?0IxTcKCMO67xk3Itlj0TzHutKggYJ7wjQzruegmZwdSb4XpSGw6pGfTKCBui?=
 =?us-ascii?Q?NDJMSR1xhWGPZfAunF5zgYhiMlWjhvNGNXzVlHG8AUhOpT/XuG5nU8m8rCci?=
 =?us-ascii?Q?/H6vw0C0TPWSP0PGnjg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p30Ap559y9Eunvdo5lOgUCNZEgItiR6PLFUhvhf3O6N04cqlQ1Rn8HGeGoMs?=
 =?us-ascii?Q?sQM9FZwpXAn5YlxegaSdy1SrSCnzZnuQ1qcOaIiLBwUz9DWlwngoQ/Bvd2Sh?=
 =?us-ascii?Q?RNSrxGq9kH0bL8np4+/59J+A91tNsImfk9VyWdBQkDnPKW3S1ZgQGy0lQmld?=
 =?us-ascii?Q?U8h6488se5MRtBMIOgw/TjKIbajRAQf4B4WJKq2NODaCmXEorcPCEMrhFH16?=
 =?us-ascii?Q?A4eJeMJwMZvFVUFzCJCJKhVkid8bgZVSK863WZ17dlmVABog2aQVVkLUPH7m?=
 =?us-ascii?Q?tFMgsywL9IPi4cFWOo/2ydsYZPFZSwfkJRiesPbjumRzB8AoSCB86UnekTr2?=
 =?us-ascii?Q?3/hNAKOaLrlTTDz6GNspUEWx8l436H+e+vFRqjA+9+XqjlIi1aHC68/LA9as?=
 =?us-ascii?Q?G0zhVLvZ5tzWr+uOmmLwWSPKdub8S71g5JECCeIUz0Yv+c43yF/DEyFbbi2D?=
 =?us-ascii?Q?YHhMbCjZelni6YuUkZuC2XMaekqiDHJ8PBRgylTYWvfRuAlKZZLFBEE8U7gK?=
 =?us-ascii?Q?AkRTe+iMlkRlkdQfv0qJrR0lMLFjuQyKrtD9cuQrNR+5jKPu1+U7x3/kOjbw?=
 =?us-ascii?Q?xLZKETuvNtq53SThNAUxtyFjUBgiPM3EljEGGcqca9YkRFE0x1bIZ7x0gyaF?=
 =?us-ascii?Q?Lc/aQ5ItofEeFy7svnHzL47STQ7e+yeC1i78r00OJhD8nn4O3+ZrMQD+nCT3?=
 =?us-ascii?Q?B/fiznh9/xsbr0uojN5NkuZD6qaVcTa2R8TT3DEwFEEi/fQFa3ksYJT6nFn1?=
 =?us-ascii?Q?ozCFcLCvFwIpYqEJhDcpRbGeyZJrfHOhMLishVGlbSlJO1hBOf9uEmNHsujz?=
 =?us-ascii?Q?phf1Erw7wyesJP6lebjmGiIdExzWln4Mwq8p47Dz9jLuWNIEEjm+qS8h33Fo?=
 =?us-ascii?Q?+u1FtNDcqu7bIQDcE9uVwsKEwrhFRFYeLsYLgMaNhRf1J9/ArnE3cBDqp+js?=
 =?us-ascii?Q?N03GEitNkzxsu0XlbeGgZ08jpCU5ius73ATXEGUbgNRLDh3ljqRBhBcffpTe?=
 =?us-ascii?Q?0xpvDJWH9zUYwsDdgaVRhDW4Gyzte7L0c2/Yz+PXimTvWK3ixIttbkUORGwQ?=
 =?us-ascii?Q?ZHaqTzoaPe9gLdtY9Nph0LAU7sBbeZWBwLDYygo9yzWWsOhkwQwU7MbONv6D?=
 =?us-ascii?Q?IDkDrta4bB05g9bBOyHhaE6wbPFYRuYItiERcDbUgUo1dCXmGpUHffBi+2Wj?=
 =?us-ascii?Q?7CBtFyk49sLZarNN0NDtr4sydxl0KGwuywT9r5pJzOQ2fUcRUTK0t2C5dg58?=
 =?us-ascii?Q?dJj0H6JTuy98nHK4/9VmXWSXF6KVQy254TXy9xG9Lo8Q+PLnBmWMOYDBHLId?=
 =?us-ascii?Q?6BKD7kyJKY+a/l0Vg1aAgPT7ijuv7uPXIOX2pGrGjA6jEWyVAdTEBcDQmtJu?=
 =?us-ascii?Q?3V/kT1DkuP+pQA8zq1xmBAHsdK4uK8MC59fVDMO78Xmszm4vhONd1ouNJc6U?=
 =?us-ascii?Q?PRn8ycqprjEm0qGHZ0PFYKnD0wKV2e2XfiMdWmpw+Vwx+DtFY/5k1udTiqUv?=
 =?us-ascii?Q?zaiOteVcusBbb9LJTh7U0axdBcjKNTcLKjGkvFmFetuzOMRra9Sdq6AHTJlG?=
 =?us-ascii?Q?2vd1vaHzwGzZ04YN4U+BlacAqlGAYaQzNL+duzDSMCIBofFrKx0UZftChgzZ?=
 =?us-ascii?Q?3IDLK9vFlG/ICDo4GbZuCTDOE8DH9h/ncBSq+nEIQcUl1rkiw3pocvcTlQ+d?=
 =?us-ascii?Q?L39NdgwzElsxzHirKd2MG6HpYI3mWIHptXHUyZJdoyHEhvSD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e91983-f23b-4fa5-e8d6-08de6a7239d4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 20:06:36.4771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7pW062KA4ydnft8dHFXii4lWDGPtGby8ouguO9LkayNWjNIPU3gSG+tKXPbUMsn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4487
X-Stat-Signature: t5joeou1wyahnwpto4jf9co9g7n4e1mj
X-Rspamd-Queue-Id: 92E7A100003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770926805-108873
X-HE-Meta: U2FsdGVkX18fUeCKjUC+p9rb5fi8oDJ6lOOpytWFFWt8x9QwtuJc0F+CEGu0vV2sQE3NCq3wnlggSnIji14syKjOH5xyVo+VWNSyfj59EWh2PKPoElrEqhFj5Z6MpWIUvgH7nKHtuF0OoNxiG3pyYH8aYLol/eidTwS2EQHk2LoGBGaIDvuFxhLd5hN4X+EeH+GpmA+vk7RgsB1scadCdKsjh2iI9nYyFBkkelBN8K0RtRcUVZptTU6ebh7cWKHkQu9o1qtLsKp1e9/16pRxGuOqTm2lPbSWucHiraWwn9XeYnqRx9yerm+Zg2EWIQedFtRefuLu/3JFDiQSKRXAxxtHPpFxhp1amdS8fU4XkT2Z6IBTiTMJOtw9M6ltlhqRHrU7wJs+Mkim5dUutoLOfz5NGl7/ZzTGgm1cuxnngW9+nPbEGpc+I4SFUY3UW5UmARga13XwmzoVXuQVbdiDJxxgf38bOYLFEM0s7ZNRT+qs/BffG+Jv/MajFe0vg6j4I5VQAt2gurcv292wG/tFfW5VkHxAQEbRqrNGhzuqIJMI82cwQdF/bdR6DbgiIeHHicfLGj/Btip/TWMDpYuPX09B93OTuTwFIPCc+c8EWQb/P4cVGDu6r4qbDm+7mzsR+mlmLlKACg8hVScFc511QXBTfGf7DOHKNfiVANW4YGE3tpxemihtnOGqlJaBa2Na3dVUW3gYcq2MoG6ongMnAfwLcamn349mTTYe75hxf3ptGen1Vf3UZc++aOIMA7FynnmNN7znnf4GYmug3zTdr5XsMQrRwbC+S4CfFj5bfwgjIXlMWkMLPo0nX2OAlcwIxeiwSDiGXBt2m5AX9fKHke90UOwY1vRBcP8rNPKLJ4FIp6lZUp+qcoQ5o7vX7wALPqG/v3DVxG010QDPeFzqH9fgruB4HEc+LMkzQ9oAOLus2U/WoECRx9iOqeTBQlmqEHBEHJF9CAGfX9GJ/B0
 5tXKy4Xj
 5DInMWOKLhfuP7CaXBNVE0mTa1tOfNL4oPINFFtTuU3AhGcUVK7lx7N5amTJXPi5NTQJIIeIgSyN5IaAfEMmEhQkmP2qcLcfeNFn3rR/FAYxgzDBCUqeXy40rvrTEimVOKy1ATv1hyNS8J0cuxQ2Q4KUzEB8dX/QMY5rwgrUTv3byHI3DHl0LtJNEcHMYhW3mU8PAD82mF3AnBMxHOE9Htxcj2DXu3DzVTZ6DOawIagfe3YXmgw+OD44EY0PzOFoEAB/XxA5G40KTl2hUgOASf8kRmC+JTa7Kw1oxgH4zDyDsyVQO9dpaJbSwfpfP4WlFRTnFMbY/08K7xQTPPWD4DdS476NiXrdN1o+Wod0a7E//d15mX5gXylhiV3KovNnbHoaST5qqnWFBsxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<snip>

>>
>>> -     if (vma->vm_flags & VM_WRITE)
>>> -             entry = pte_mkwrite(pte_mkdirty(entry), vma);
>>
>> OK, this becomes maybe_mkwrite(pte_mkdirty(entry), vma).
>
> Yes, upon further investigation this does seem to slightly change the behavior.

I did not notice it when I was reviewing it. ;)

>
> pte_mkdirty() is now being called unconditionally from the VM_WRITE
> flag. I noticed other callers in the kernel doing this too.
>
> Is it ok to leave the pte_mkdirty() or should I go back to using
> pte_mkwrite with the conditional guarding both mkwrite and mkdirty?


IMHO, it is better to use the conditional guarding way.
We reach here when userspace reads an address (VM_WRITE is not set)
and no zero page is used. Using maybe_mkwrite(pte_mkdirty(entry), vma)
means we will get a dirty PTE pointing to the allocated page but user
only reads from it.

Best Regards,
Yan, Zi

