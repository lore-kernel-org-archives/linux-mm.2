Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F420606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cd871SAm
Received: by kanga.kvack.org (Postfix)
	id DE0B76B00EF; Mon,  2 Nov 2026 22:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8066B05B1; Mon,  2 Nov 2026 22:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F206B05BF; Mon,  2 Nov 2026 22:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92D406B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:01:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7458416031F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:46 +0000 (UTC)
X-FDA: 85392307812.17.0C7643C
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012004.outbound.protection.outlook.com [40.107.209.4])
	by imf24.hostedemail.com (Postfix) with ESMTP id A8DCC180005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cd871SAm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkElwCgd4giFwvWBgSR4/6i5DRT/RrEQQLucrCdY+pM=;
	b=R+uwdGgm2qujNxlzr+qmXdrjRUmdli8UmAKGAxJyl97qsOY6z9f8ApfGwnUk0kRyOOgED5
	+SKAV/Z2rH6gOwH0LRGp0b8g/xNjCtuVnRUIi4/dz05LRsN/GS3+X4phBhLC9qub2bH2Zi
	yxsxOfLxkOxqwbfatXh01GG7CBuGqkk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cd871SAm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793674903;
	b=sGBnRUiquaf0cQe65101vZPNpj3Ci7/oVYmsuOdWwxxcn289cYmOwwcE7cJS6VwUD+V93W
	l7vPBkj32BK3ZzRygNa8vjsOyL45KoRCWh2Kpm1V6o6g3o8YBpKLGi+9b2Bu8AvZWPnJpa
	0WP3krFxXotZus8cINoXSEGlvTS8ekI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYpDd9bQIhxEYzijukUWNtdqn4+ntH0+aA8aG3lYfD/STXJsxTs9ze6/DWaEpCet6HUFGWUD9ojGOErrHZ1YpumIOJnEdKywnMzMnSivkC9QthSGSQqpvjsLOksChdPVj/MdTqdBP3hCcIvMoh5kb1SCneX/p21c/NI8a6dy4H/rYVYrNl71Ywkr+6s8H75k2AaM2t1lTd6MXzmKNdhaTbmLg7g894AK1Bsd5MqZ89gbnFkCocqSCeR5KMpUrJ/RVNAAeQYRAbS3VQpHP3kOYCar5xCcoNQTUhsgA32/202reLBWtkz+BsVZ2WtMMcI3SgLeJGIAjS77CpVu1ohZyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IkElwCgd4giFwvWBgSR4/6i5DRT/RrEQQLucrCdY+pM=;
 b=W1XYuXS2HC9V3QDxcxJLOVvAoRMWaUifw7ffQyytA+WsIFM2R/y/0uEOEu0JT+LkvXZ6G7oqId3kVrjIv90C919pR8Mbj0IaCvoe56oB0WsSWEMKF0RD7fcAL6ni0fm92qi/fH4U84Qzn1A/i1VOVw6xXlnX524sX9lrP6j98v4feTkbQA62cMwYcrZzbTu2yEYTox9+DZkIsKCN1Nr45Da1r7yBDSmPjX9y3XTNIc8O+XDgC62HuoTN/xsTZ4xZPtYfnQR0Hrr06xym9EY0+hdqVWHvcyqaj7PNkpmcxVnum9aHKyNOsMk03ShoQ4znp+iNjIVbwG4N/W7qyuFO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkElwCgd4giFwvWBgSR4/6i5DRT/RrEQQLucrCdY+pM=;
 b=cd871SAmFgXknFoHKc6yGwqvwVeN46oEu8BryXOanCraqkov4V7HEqj/3TU/bwvxDxRq+watLruQBZ7NFrIYiVuvqBR6lT2nK+WLIFmRU7Zcv5N0LEco9vlapnzWcjVDzGymXfdjV5f7kRAZFucV0Kl/zZ7LARhdSwdfgnFp0XyTiHqb+E5LJaltkP1WXAzG2D51BCbL+nYNnW2tvY0BIDmi+59sTIK8GRz0CMhENbehoz9iY+fyEaWy3sTiJrYUwM7Y0NUCVwZgxsmRT5aprXhocxPfpkNAy2Xu1fCd3SDisghroJHO8U1dyouyiHp0YnNiwUFPjY4OaVVqJeCRrA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB8173.namprd12.prod.outlook.com (2603:10b6:510:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 03:01:39 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:01:39 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:01:36 -0500
Message-Id: <DML8OO28WT5O.3U6NG100XWKZP@nvidia.com>
Subject: Re: [PATCH v5 07/12] mm/mmzone: read each zoneref slot once when
 filtering by nodemask
Cc: <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
 <ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <kasong@tencent.com>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <baohua@kernel.org>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <baoquan.he@linux.dev>,
 <baolin.wang@linux.alibaba.com>, <rientjes@google.com>,
 <rostedt@goodmis.org>, <mhiramat@kernel.org>,
 <mathieu.desnoyers@efficios.com>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <ying.huang@linux.alibaba.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
 <nathan@kernel.org>, <ndesaulniers@google.com>, <morbo@google.com>,
 <justinstitt@google.com>, <Bessel.Wang@huawei.com>, <jiang.liu@huawei.com>,
 <mgorman@techsingularity.net>, <anshuman.khandual@arm.com>,
 <stable@vger.kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-8-gourry@gourry.net>
In-Reply-To: <20261101021340.2251928-8-gourry@gourry.net>
X-ClientProxiedBy: YQZPR01CA0159.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB8173:EE_
X-MS-Office365-Filtering-Correlation-Id: e657dad5-fec8-4ae8-a239-08df3956c7e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|261102123227099003|56012099006|261021121427099003|261022105027099003|5023799004|11063799006|4143699003|261009223027099003|261028144727099003|261026140227099003|261021123027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	W0rrzj0rCFRII+xirkyfewLvivLalIUhvJUbA8IJyD8AZ8OUgA1Y2uUx2mJzjzkfgDR7eSQQG0WS1y07U3Gc1FGMWdXWISOv60PywKuJ+g+4lTQ/XRkWQnxUaoUc9ys6YH1/nWxW36bZ0eBnF7aYMisE3FsCd6UO6EigEOYouu6XV5X93KOyCyOCZRSMb+ODubcVneLHWCUqu6qTCC9VYMH0NK8EqCKNKVNymt0FTgIQ6gocc5N1N145Gwu+Huf4npwQstU4z2NVMHX3EUkkwwYH6V/ID2xBwiDrBSGsEAyDPgk/2xro6M8XlwwiuNdyKw2Mc8XOSrG/0hR7ks6uKG38dHJ6X81+u8e4rqLKGevn0a3jy9kiTVmwamQ//LEBg9eOEwZ2PtTDZO9Bi7+PNmS0Ic4SiMXiBSzHq73PvoVTahOuMvN1eEM/bfJu0nN63T3wcfAIQPoSU85sAQWHBjuIC8YoKpN8EttX0KjiXqpaES9ZRYBO+522JkzuQQvSY/uCpV9yE/cwlKR2+q1Vbai1R0cIoZlnF3v63M/WViZnowjgEcP/AV8bXFH+NpSQE+wT6eZCFDK0hN+sOYiwT3NIIiy6EFwMxGGVVSoknHx2adPfE+VO7ZaNKA7jHLtxz40A1nMMy99mqc3OKXMVVIxyaoLybPNLeiG5woYqGtg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(261102123227099003)(56012099006)(261021121427099003)(261022105027099003)(5023799004)(11063799006)(4143699003)(261009223027099003)(261028144727099003)(261026140227099003)(261021123027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3ZYQzlBY0VYUUgyTHlCeU9OcDJMdUJYMk5qVjdObUlvaW9lYlEzeVFUUXF6?=
 =?utf-8?B?OE05TkUxTnBYWnpXZGVUaktIV05PaklYNDI1dEFMNGtvNjVsRlRpNXB4enJE?=
 =?utf-8?B?YzNLYWtRbDI0cXFUMm1CYUUwUTZyM1NkY0NxTGZkUC83VUFkUyt6VnVjS3N3?=
 =?utf-8?B?Q0kzMmFpRVZHRlgyWTNjYlViQW9lZVJUK2FtKzI2dzZSZ1dSMVlPNTR1TkU4?=
 =?utf-8?B?TVlPUXdsN3pZdTFiWjU0Qm9EN2FFeXVmdVQ2ZXlrMkpiaW1KL3c5ZmZHQklQ?=
 =?utf-8?B?ZXdnZVlFTFlrcXZkUGE5U3F0dzM4aXhpUXNtTklGeVo0c2p1UWc5WFZkS2g1?=
 =?utf-8?B?UFFiV0FvTVkvYmQyTmgrYXRJZE5yQXJHVE5SV3d3NjZ6Ti9IOEk5aVBiem1M?=
 =?utf-8?B?TE9QSEFWcGVHK1pUenFKNHVYVkdGVlVSUjhmbEdnaDUzbmp3OGxQOTZDelZy?=
 =?utf-8?B?WEZySXJqZW9CclFCQ05jekUvMFlTNDc4VU5sdnMwUXgzZEJvd25Gakc4dm5Y?=
 =?utf-8?B?YnVpR2Q4dDlkeDlaWENTUUhPZUQ2dmFlek0xREJSeDNDY0xqbTF5Qk56Qk1I?=
 =?utf-8?B?TSsvSThqcEZ3TkpEcUlMbkhoWnZ2VU5PalMxc0dRZ1NHRHJmM2F6RTUrOStl?=
 =?utf-8?B?M1VBVTY4dmdnV3VJNCtoOS9HS0NaZlByMEdyclg4WDQrU254SU5iajZPcFo5?=
 =?utf-8?B?bnZLclpXQlhyQ3VhanVwWWRLQk1La202czJna2p0WFJmZ0J6clpIUEJEV3FI?=
 =?utf-8?B?N0RGM0pKUnFrSkhXQVlWV3dNSXI0YmVKVXdxVEJkWklPalgxNm5nZ1pzQ0hY?=
 =?utf-8?B?MXdQdmdTNFJibXUzcTJpR1dWVjNNQUYrSkNzTU9jZHRtcGc3WDRZUjlUUGJP?=
 =?utf-8?B?TGw3dUV0RXMwbnBOaGhHSUpVT2RzTEhnaDhtWG5oWEdGTTU5ZVJpUjNKQjNL?=
 =?utf-8?B?SGxjVittTmRHZWhzdjFPT0djQlAydHV5bi9qYVc1ZmQ2UklXbkEvbDBQVm9n?=
 =?utf-8?B?K2VpVC9rTFdOeDB4NnhNbjQ1bDZkMEo4MUJCaG1vNlNJUWxYK3V2aVhNNks4?=
 =?utf-8?B?dmZHUS9SRFlnai9kWVJnbGxaYnpTUzFNb2oyWmRhOVpGUERUK0Y4UEhxZjVx?=
 =?utf-8?B?bkUwcHJlbUNPRmRyTG1KajhzZ1pHdGNkeGsvV0tvRldaaWtWSUtTTm8raTFY?=
 =?utf-8?B?bzF4TnNYODN5NURnaXBKUVlyNDdkcC9ROVorWnhMTlZVemxLNC84eDJlbm9E?=
 =?utf-8?B?NWFKOVE4ZVFZY09YanFoUGVidXhWZmJoQW1mTWtmRUQ0cnBiaWpROXV1SldG?=
 =?utf-8?B?RDU2WHNVd3VBdWdxMXgzZE5nTmx6WDZUQ3ltUjFCNmdWbk9LVzJjcmlPY3NV?=
 =?utf-8?B?ZTZndm9wcGN5MWYrNnhIWW9MZXFiWkJvWnlVSEh0L214eHhBZU1Mbzhqejls?=
 =?utf-8?B?eTZtcFJOcmQyd3g1QlBkcXN4VkZocklsODRRdkd2c3VhaHlPYkYzT21LMFVq?=
 =?utf-8?B?aEhBOUNVdlhzZ0E2RVNybFZ4RExqU2h4T21KS2tWSmE0N09tRjNGMlVlZFFs?=
 =?utf-8?B?WnRzaWR4KzJEaTRiOGdEYXpvaHZueUJRbkdKMkpwckNSZEZFbmNZajM3TnhO?=
 =?utf-8?B?Z01zMHdhNzEwSDFDeHBGNWNGNTlYVERqTnJuRFNmNWlxS053U3cvaWpvbzNy?=
 =?utf-8?B?cmVjS1pOVjhzQVBlMk9UNXUzM0tPeVVmdzE4UWVDbERJNzF0aHhRM1dqMFFy?=
 =?utf-8?B?Zk9NdExsYnd5Q3U4VTNLUFNCTi9lUXBrRitlSWUvd1hTZTZWQlRGVnBuSEg0?=
 =?utf-8?B?Z3FvQS9IVkI2ZFZsRllsNk1VZFJIdVZ4dW04WWI5S09hUDVQa09aR0VwblVC?=
 =?utf-8?B?WU0rVzBSeXNZRHdSb1QwdlB5QTcyazlPVEMvUkVFRVVya2NQUU5DTmY3M0E4?=
 =?utf-8?B?TTkrYU8wZ0xwa1lOMXp0c3QxRjJ2MEZhT1Vlb0ZPOW5lVDB5Z3ZCTkFqY1Y0?=
 =?utf-8?B?RmNOdW9aSngrOVl2VHhZMWlmYUhTbU1DYTNDUFdiYVlYK3Y4U0RWbERQdFBw?=
 =?utf-8?B?OXQ4ZUpLM2xNOVlaVFpyQUxCSXBnc3hjaGtPV1Y4VVEzbHV6TE4rWHdxUjBG?=
 =?utf-8?B?alBxTU13VnZ6VFBkVUszQ2NMY1lMVVNHejN3YjN6RXJXWWduVGxmUHR4WmNR?=
 =?utf-8?B?bDFNbnhuRmVOdnNyNGhBNmdUa01lVmhidmlYNVZUNG5UNFF5VzVmQmJHSUI1?=
 =?utf-8?B?MGVxWmlXNmJnbFZJby9vekpnZ2NpcStzWUJmSm9BakRvb1YrSkdDZkFvZmRD?=
 =?utf-8?Q?10Sfp+OkddMNqP5HJZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e657dad5-fec8-4ae8-a239-08df3956c7e1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:01:39.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RL5gsG15AeqVcM2ZIx42y3VIDuN0O7PV2s7h2D57yVJ3PuQYXQuoouef2oenKowj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8173
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A8DCC180005
X-Stat-Signature: d78wm4opr5skh6fwc7bsyc1eq9ca8wzd
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793674903-443001
X-HE-Meta: U2FsdGVkX18PYW3Uf55ItGmu9lPMFsCfVLl8t3koMf9/JwKnoIu9DEF3QhZAAUCFg2QyEhAgVfFWTqk9jRG+8XOn46L9FWhrGgETpavYabpoHN7wPckeixRO2XbuIxa+zkBSzNRNTmm4Pjc9noRrHRSE0P2S+UY1fkcNBXBaj/tbXJQQfV/cL1VzU3J4dwajgCr2b+cXWrPuNWadcLDM8B8Qm7Tof1WEpZ7SzHmHIcDs51jgUZr6c5rHfCnBZOzhPZ9VxB2wxGRpQWOuPnMip9IaJdKfR0Lxqqh2gdCVsBvtz2d/rBx4ruUW0yI/TQBtV0QnVAYedhuucc+ckGUKKSEZgKGHd6IHJLcDhDV+Y0HC9J0uRjxJkftmqSFnBJ8BTDWkGWwU7D4ShUJTXN9yvZXtXe3wWPQtMrjDiUcWqLNIcxLl7K9CwAiUCdiwjkwAdqDi1+LPMOY5Okxl0B3ZkSo2iqKg697tJz7J7n1iPSErIXvW9/DbWmem/bDAO0FCthHZ1iNJwN/FP6HrROrcM/8154248bmLJCGxsx1rKmAWmTba5DmMYLDIt9MMiTXXjHybgFCvLeFLIP3/QcY5oQ/Qb9pwxfCl1ReQIkKyYvKjkyisdCjXTBi/4DXQ0Ag7Du9hbc+kgy+CRi2yN1AOwDJoWVxmDNhvemVAsK54KswtOACOy9ZsG7AXFpYC0sjkgSPQUde9g8jFgo34JqT3OND82aA2742bMqv7RmENJaAjTsUpch8+o9gRuDjvtmzif5jxI72XVg6dvwz4JUFI5GBYNC4DbT2kv6eZtFpYGBtxukUUCO2PjlJKDTminscHZ7fi886c7sMKOnSpp+YmElJmPX6gbaD0Ie2RYFA9nB/6deiXYwAC+1FUsNj0Sw93zQn956V/b4LH43Ydq4iDsk8PX4W/cuuFKdXgRfiOvIMXEyZFFgTiwwGWHvEgUIzRG6cTvXPF0JYEjZeOt/7
 3wu1PNUo
 edlR+WtlauhLPg/dSG0I2o07MzoA1RFRempopBN6+9dIMXDtH7SbAUaSpW8NG/dw2mqsoseJP0908o0rb16MifRIjpjNyM6lSKySDEmUzu9hs6wa9sLGjLQl3cHT3oT3mzJLB/izdV+VdywAHuaHTs4UiK559/LQlL0i/psK/DTsPcbaQq0LgKfhW9Ti1gRF3oafHCU1UbF2Dmzf3VXxaf4hgS/yEb2/WcXBT4AvcpnSo+CpKgn/yR2M4aqbu85Jv6WhdbMDVX6SsNKW/KNG/vuXJGZveVbn/kb8BG1cr/DzxiesRdB2EUPuhaMS03obvRnjMm2TioCMkQHVATqrYQTsFLL0oWGpqOkzXIp9YnW6zi8zyZdZB3RGV4VboA0gTpashYAFhP23Nzo+X+SxZUhy6g+EVOdekIKaKVa3qalQaV+4/82UD2lcJRW/htbMjmiqdMH63Fc+HEMPn/AZKwpeD6sz33Oj5OxCoVXU8D92YMtR23fbH1RhCDCmHTsabodEXFK2P1dT5hcm2IwXFPU2LBOe4Wcbj65MmhfakMgzjUbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 10:13 PM EDT, Gregory Price (Meta) wrote:
> __next_zones_zonelist() tests a slot's zone for NULL, then reads the
> slot again to look up the zone's node. Offlining a zone's last block
> rebuilds the zonelists in place, so the second read can return the
> terminator:
>
>   CPU 0                             CPU 1
>   __next_zones_zonelist(nodemask)
>     zonelist_zone(slot 1) =3D NORMAL
>                                     offline_pages()
>                                       build_all_zonelists()
>                                         [MOVABLE, NORMAL, NULL]
>                                         -> [NORMAL, NULL]
>     zref_in_nodemask(slot 1)
>       zone_to_nid(NULL)
>
> Current GCC and clang merge the two reads, but nothing requires it.
> With mm/mmzone.o built with -fno-inline -fno-ipa-sra, holding a
> nodemask allocation between the reads while the node's last movable
> block goes offline oopses every time:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000060
>   RIP: 0010:zone_to_nid+0x0/0x10
>   Call Trace:
>    zref_in_nodemask+0x9/0x20
>    __next_zones_zonelist+0x23/0x70
>    prepare_alloc_pages.constprop.0+0x16c/0x190
>    __alloc_frozen_pages_noprof+0xaf/0x330
>
> Read the slot once and test that zone. A NULL zone still ends the walk.

It is better to spell out the rename from zref_in_nodemask() to
zone_in_nodemask().

>
> Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_=
zonelists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/mmzone.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>

Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


