Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C72BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752EA6B009D; Wed,  2 Sep 2026 12:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702A06B009E; Wed,  2 Sep 2026 12:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6191F6B009F; Wed,  2 Sep 2026 12:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B42D6B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:40:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEB041A0290
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:40:34 +0000 (UTC)
X-FDA: 85169385588.22.A9733D2
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013063.outbound.protection.outlook.com [40.107.201.63])
	by imf22.hostedemail.com (Postfix) with ESMTP id 226D5C000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:40:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=od4xBZqz;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788367232;
	b=0AL1XgglXS5TzI5WruHh2huMZb5dN/ou2dzblPjPKlqWCx2sM4Y2R1T9DMkzj63e12T+Wv
	shu00eE9ljiInIHFonYv+UaodJTbutzJ1s14EwRXfgNd7Cep9NZcMJLajgg6lbSk3Rpws3
	0PSfk4tJwwrL/3YG3SyvHfvCN/kHY6o=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788367232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfPH7wEplOPb5Mjdt3EPMuZkMkAXUODUOFfv4gwmoZI=;
	b=Qy5w3jOPe9K5vu1A9WvUFNis3KJL22OHmyVqMXI+bl/yCR62LTP7/bTy4Jju56gprVsm2M
	zmo1yxQPY8RSYYdYk3+x5ytTDYs6cioEC0T/NKX1E0mB1FN6JEdhmq6+gSfRekcXidKHN/
	OaF/GZG1llKN4FfkZonC+NHb9e5WWzo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=od4xBZqz;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=itNmp5mfOhCB2ktvy2ixtaPJAkP/2x/mC+DlPA/MqHbZAYFwfS5PhjNjf8XtoOiLHtgSMs6l2aIon/vr8Mj1KxDUsX0SYtEybn/6RUSVcB+rcqm/MRv+TQfX6NC8v2EklrIfDRQXTdIbnDLVb661RthEqBGNTH8VWU9HnWaDEEeb7reT4O9sFwvOjKPFfGrY4rufnfxZTjM3/aZqeU4D2B2d7kptWiGZ2KjvMxiOVj+oKpYYVQV7RA93bzgM1bhZ4d2KXIsGUQFCKgkPcqlcTh41rG1YCw6Rj8F9pyXVJGiX4lzrFrmwUroLMTDaNnZkS4e7RNl4CMSxJRHo5v29iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xfPH7wEplOPb5Mjdt3EPMuZkMkAXUODUOFfv4gwmoZI=;
 b=TOo+dk0jzaAPaCZtTH93i53nBvarpqGBfF3OxxHci1EVae9g4LF/XOm6LV1Wq8XKAeYGMuSs2KTbj/p5FBq8Xd71IiPHUV5hTzjDqAdj+Tv6o5FXjxvndFqUQTgkEZUpcFVP5Ie3LgRgRjxjgMqptSVrC/8i4qR1YJKyXghCWAcPEJ8PBFt7d2QXGyNhDGVkRvfi6MvugMR3q6D3HYr9g38Hw+75ZZCPBAcIM98fIuBlnMiHpWD3r5zgFRNLwI5q/37iCYOn02fXoVlJPG0SmYstHxZyM4Lt+cUgwm1tgZ7TDyGsjvBGnKi6HxbZgz6/7DwbgVamrpEEkpYbBhfCnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfPH7wEplOPb5Mjdt3EPMuZkMkAXUODUOFfv4gwmoZI=;
 b=od4xBZqzvXHfqKx5+Z1gaStSA7nlN7OSnErudhxW6u7rvLKt23rPpv0aLg+z0j+qmtAF0Wnr6pyOYundA01/BueNlzZSdlgwyTULq/hTqQi5Ct50QOS6vHmcv0W4WY5kjkYtSreh02N32C4TIxl7HgDTb+FDScw69hnWoNpbZFluXDuMHszI1Z6XWm/bMiM8EIOWQilo5TVb75y4VkF9cLFhEH33sM4y8/PoEdKkL7OBKPsH26k5rlgLrIep/UPuEJiv2IhRTGFxoHzz8TbiW4oBPiDUVcZkMwFdrzTZFb3v/KFidp8L7XgEuy7EElxL0Yuq8dT8fK3o22SbJn+eFQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6470.namprd12.prod.outlook.com (2603:10b6:8:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:40:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:40:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 02 Sep 2026 12:40:12 -0400
Message-Id: <DL4Z9NG2457N.2H4T7SUPSGM5J@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 4/4] mm: replace PF_KCOMPACTD flag with kthread_func()
 check
Cc: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, <brauner@kernel.org>,
 <djwong@kernel.org>, <cem@kernel.org>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <david@kernel.org>,
 <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>, <ljs@kernel.org>
X-Mailer: aerc 0.22.0
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
In-Reply-To: <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: MN0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:52c::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: aaa58d2e-4797-464e-25db-08df0910dc43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|921020|6133799003|56012099006|10067099003|22082099003|4143699003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	KcpVFLrtnXfPQ/+TkIlT7lkEibHnUgtwLXw1zD6CbUhuBK2tWvAsuM3aktgBx7pOIUot0AVE1oN02AESSF5c1IDzveH+3qJhcx443yyPaSs20kfBshj1QWh44vmfh4629nacdQvfnfbRx8PEa3csphDNaYkJd6DAOm3h1GiHDtRcyKA/nHruvte1LTvifXfNu6tvf6/T/0W1QAehKe9Zd+lVTrqZH8tyP93cJNUfIalmUiLOUbUk+h1mWYknoqFcHq2lx0SZUZJkx8IVZCnT9LNX6A1HimYAsWP3+Gki4VCwjlxWBpZE5Knd37aUXS0UKo2UVAhBzMbunxNKHNOYUY9MwWIz8+4FGWsCV6LJfaX5uGkC+3tQnxWTtEqTSvc5syhfGK3rqB71QMmrT1Ogl8I9aWUY1/Pi9/JRSZQA3qyxos9Gg0/akumoEdiwjgRyL5eeUF241shL2O0OwlfS/GOZCrtGDr0RexHZD15HuE2vDbG4taIIUNquewlR4lXdx7Ad+nql1FbKMV8W1/pWakZ6Ro/+nuRW8LPIpbbKLMzSXtfnl3SWKOeF53fQg6r3GtXCsQfsok++7scW36CtJsLAZ3JZkdw9wnfu0E5DhwTbcKrLBro0Pqls1s6RVq+fk52Jn4v1iVbadASNT+mjY9TBbQA/Y+OywJR3ssUuvvR4eAHNHzpbfJ5ovHfq1w13O08QPbPKFsxz9HBDvkI5kg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(921020)(6133799003)(56012099006)(10067099003)(22082099003)(4143699003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUtQZG5CN2orcExwNFBaWlpmTWQyQzFwUUY5NlNjb3duemdGSjNqV2tpdUpF?=
 =?utf-8?B?WkwzdFg0K2IwY1N2bW1aTzNWMGk5Mk90bzMram5KNEJTbUVBOVFWaEZtNTEz?=
 =?utf-8?B?YjhYbTdmcysrRjc3Z01DT0lIZ1RmOHFhOEtqcEpRVVluT3UxWEpVeUpIWndZ?=
 =?utf-8?B?TEZ5NzA4aytscTE2UWlzK3pDZ1JGZHBDYjRlT2c2QzEzSXdaUVFFeGxZNHR0?=
 =?utf-8?B?bUhVZG9SNXQ3dHNIdDNURkNkblRUN3VsZENscnprbFRnM3JEU2hvSVhBaG0z?=
 =?utf-8?B?NHByUTZaelZRc0YzOGMySG9VeVVGWlR5OUtYYzNEbFRzMDF3clByNWZNOFJq?=
 =?utf-8?B?NmpHVlJlRFNZRU5wNVA2SUZxaEhoU2h4OVpxa1h1ZTR5MEtBazZ3TUMycVgv?=
 =?utf-8?B?VG1QZ0ZjaHc1UU43NzJ2bGdmZWdacjJDajlZQmI4YVkxMkFYZTI3MTRpWDBl?=
 =?utf-8?B?MFluL0wzenJkdGJkVWVCRE9SZ1ZESTd6V0xneTdNWmZzNVM1Y2E2ZStoM0s3?=
 =?utf-8?B?SzdRTHRDWlBKdXA4RmYyQVQvaEdZZEhlQmZWcUs3aTFtZzErYUYrdGl2TmZE?=
 =?utf-8?B?N1FUTytBN2N1eGdneTVneVphR1NGYm54OERoWlJzeVRIelVYc0lQNmkyQ3hM?=
 =?utf-8?B?YkVpb0JXTWtkRG11NXlkZHhKK1Y4a0RtNnVkb2ppVWdXcTU2YndYK3dlRzNy?=
 =?utf-8?B?Y3UwMmZHL2EzQmc3RkFlSGkvaTBYd1JHbXo1R28wemhLQkphK2d2UG0wdTNt?=
 =?utf-8?B?cVZXU1dyM0QyMWc0NHd5TXl3MkllNlhIVm82K3Z0alYwZ2FQb1ZVTEk0ZTZH?=
 =?utf-8?B?U3RmQllBM2hCWTA5RWwzbWRqdzJLNWNwRnlVTGg5NEtYNnhHRVl4WWZRRFBo?=
 =?utf-8?B?UDE2NEthdy9SblBaYW9lb1FjdG9jK203UytYMFlZOVlrajJjTWdob2EzUTJx?=
 =?utf-8?B?ZStCZWhPcHFBWjNwaGRKQjBGLzA1d0FyOXBwbjdCZVhKbGJsUmVDa3JLZnpB?=
 =?utf-8?B?Szk1WmRDaEFtTDRKdUhPTU5JU2YvR2w4U3E2WE5GRUdTY1BCVzBpUE15blRJ?=
 =?utf-8?B?ODM3STRrZkRiajBGK3dmWFcrZlliN3R6SXpDUjJxcENna0kyd1prK2ZOTGo1?=
 =?utf-8?B?MUJWZjFnUlIzZnZ5VUNWSzVaQzZxZHU3NlNjOXlMeGwxcTJQaXRNMENMdzNi?=
 =?utf-8?B?ZzNMaG9hSk1icWtSOHU0MG9PdHE1TmRnOU9SeFBNUVhlKzJlU2gzN2dwdHl5?=
 =?utf-8?B?dWhQSlRmTXZwd0dUSm13UjYwV1hUQ3FqOEd0SUZLeXVDL1FKdndGVkZrOXQ2?=
 =?utf-8?B?MkcvbEgyT1Q1d2RMSmp2WDRabVVvUy9SMDR6Sjlyb3d5N1dRbTQ0bFltcXlQ?=
 =?utf-8?B?aUpHaW9UdGdLeExnN3hYOFlYK0krN2V0bS9jSUR6QVoyaUM3aVVQL2FUalFH?=
 =?utf-8?B?K01jbXpFZzRzZlBWUXZ2QXk2NzlLUUtQMFJXRzNNTDFvanVaL2dnZnZhRkNi?=
 =?utf-8?B?ZFFzazNEMnBNVURXenh4TXJwYUZDbVllejdJVmRtaHF2VERGd25udk00ZURZ?=
 =?utf-8?B?RnFLZmYybkdYWmlKL00wNlZSbllXcnc4NDhmSmxoanlCekpIQml0YXNTamR3?=
 =?utf-8?B?MHl5NkhtcGJ6RXV6RTExZmlqTWdLVVY4NWhUcUxDb3JwRkFrN0Q0V3Z3MGlq?=
 =?utf-8?B?bnNWdEFjcVJqUzQwZkI4Q0o0QUoxU2ZRVGE0MkkxZlpCNm5HaWNaTVhoRXRj?=
 =?utf-8?B?ZVErZXllaWZDclhoRTd3b0hMYzF5aGNIY1VlcWtzREVBeFR2NGpqODBxOXZj?=
 =?utf-8?B?RjVmem5tVXRPYVp4bWVnTXhHdm9penYyVUxPak5RV2NZK2N6VndPT28xUFdl?=
 =?utf-8?B?d3kwSzhYb3ZiZG01UXhicUVPcUQyUk1vT2VnUjcxODRvRkJQQm9sS2c1cUJR?=
 =?utf-8?B?SmVKaEcrSXBCTGlTUGdPRVNyZ3hsK3p0U2ZnWUQ5KzI4NzROUlpQZ2ppOWFu?=
 =?utf-8?B?RHRRODI1c3Z6V280azR0YjVGQmNJQ2ZEeVNFUzRkQkk0bkI3WURaVXR1Z3Bw?=
 =?utf-8?B?SnA2NFZlaWgwbHNvQVZHN3JKd2szRSszOElZczh5NW9jWW51T0pLOVFyNm5i?=
 =?utf-8?B?bGxxMFQ2U0gxSE5OYWxvbDRQcjdYMzhxSnNoUjFta1NFTDFsYUtPN1o3UW80?=
 =?utf-8?B?ZlJxZThIY21Ib05tRTg2WWtneWdDNCtMeUdtci9tMVlVbzFVcXphUHMrYVJh?=
 =?utf-8?B?c0QzakV1dW9UNDE0ZDVQV2tFSWdta2IvYVVneHR2ektGVzdKRTk0N2p1RmhT?=
 =?utf-8?Q?F/IgiPHZ1quts9ivAz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa58d2e-4797-464e-25db-08df0910dc43
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:40:13.1052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QA0nBDNO9Q15B2qgVfvqfpFb3X2+C9M9CrsG6w26xxy8PgAN30C1Is8f2yFFEw63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6470
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 226D5C000F
X-Stat-Signature: dghfaopqaxec8yx35gtzexrwzcogerx6
X-HE-Tag: 1788367231-223847
X-HE-Meta: U2FsdGVkX18WxdlNSlVW7wAym2fDR8s5k0wGh8PB/kHz8SrUYEV0EKZlq6WgVw1D6foXjOrsr9bawTqPEPc5xfdlIux54x4OcxtijGxSAcIXcyZxFs3o6mPYwXOm8cl9vu8r1mcS7jJlR2o4393j8ZyV00sMSQFUPZJ26SFYx4NEhB//phcTlLxgG0L/pVhUYHT/iIYq/ERkQ+0V6hBZpwu/sn6jFWs2bgo8wbJ72vukn7bLkaZteZxwx1J2B2VjNOCouZD5pxgv8933jQyy2eddVQSVPYpkaml/WMKFUWGISsaPr15YfdwrV8QRFklXDRu+Jd41/XWYbQ9JT2RkInyOUqC9NuB+Cxlg/13yzFVKrstNqeMlxGB+8bpOAqSGcfa6DKqGly8i3cjr4NapW8MwmOaD3kwUDPL81ZNE0hlhP57tnkxRD/cWt3zIumnkYPt9HKB7FNOx/NdlWf1A0WSfJjB4ydSc5kJIn8DfWQ00/UupY4P4mnFfQ+fMaWrnmVuZ4DTtxNYFY3AXshtFM5ImVSdO7HIKt5I3y75zPvJJJ9ggQ0+v4JJ73KK5QDra7e4yF9Upmu0UW9r3LSfDvsmvbg334yO3fH/ayG5xBoBO1QQqYr7LI5YlBGLLbl3joFJwj70U39gvgn5+5StP3O5wjjTdKvTtsVMFbqozYl0WtOOGPYP9GAsrhl9DwewF/7SCRYtxLu+gxwFHR/cl7eoNIDbvWSr+YAdokIWkfCKrjLAUN5HioHlXMGOONCt1xMLMUuvDCKfesLxM5CsMhLFe83kIL+dHLiVVMdqDed75SwU22AfUw+4CIdmkfSqElGPIfSCeFuh9IpeCjpvK9ESohfSGbJ2zRrJ1UHsFUB2YCUqlcY8Hx2aSY1BhT7n/otDhxG2ZakM8Gsm9dit0ynmPE8iNy0UElU/o2nAsHJGxnC1HAcaYxFkvsPljIY9c7qhO3/KQmqS4IvXMMV5
 uaveAJxx
 1Myk097X3qp0xtJdoJqfISimtMZEIUxkcZI54TZxc7ZpNklxab85tTKenimrg0jdQXHOBF1wvf3Hm8Vc91vMi0Jk8GPXD8+WunWfi7FoAflhr5v8brJUK3mFUN+zAf/ZYIZ6CRroloIrt9WwHOW+RIHRRuVN9xlyuYf2WRHacgjKldwSdDZkliFFa1e5Mg1Xl1E1LZxE/B+5kEJlR9obQDekGgnDHTYp51V9E4Eve7DdC/sbtRg8VKBbXONrqWAgBwVaEOef8IBcmYbpBRfX5X1X/A20QqwxHahfs84ZPHqBiuZsqZ2qKWHlvD+Nh2Lp/22EgjxrD7TdizhgYW5/Hv7paUnLsBTYTC9PXcFGeFw9v0SrLjZWU0KOR2JQrVs0jKKNZyfr9kC5tJZGptjrnHK/bPOwInsXrk0Mfx1U2QzPCJmgHVx6F7iq2SjH5skzGYQbHFxQx2k0+XBe5n7RlDlpBTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 2, 2026 at 9:16 AM EDT, Kefeng Wang wrote:
> PF_KCOMPACTD was introduced by commit ce6d9c1c2b5c ("NFS: fix
> nfs_release_folio() to not deadlock via kcompactd writeback") so
> nfs_release_folio() could detect kcompactd context and skip
> writeback.  The flag is only consumed by current_is_kcompactd(),
> whose sole caller is nfs_release_folio().
>
> Replace the flag-based check with kthread_func(current) =3D=3D kcompactd,
> freeing the 0x00010000 PF flag bit.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/compaction.h               | 11 ++++++-----
>  include/linux/sched.h                    |  2 +-
>  mm/compaction.c                          |  9 ++++++---
>  tools/sched_ext/include/scx/common.bpf.h |  1 -
>  4 files changed, 13 insertions(+), 10 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


