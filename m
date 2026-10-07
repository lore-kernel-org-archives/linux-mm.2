Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC6CCA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 18:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD676B0092; Wed,  7 Oct 2026 14:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AECF6B0093; Wed,  7 Oct 2026 14:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6768A6B0095; Wed,  7 Oct 2026 14:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 387576B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:49:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A257E40338
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:49:02 +0000 (UTC)
X-FDA: 85296717324.16.EDC703B
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010000.outbound.protection.outlook.com [52.101.85.0])
	by imf17.hostedemail.com (Postfix) with ESMTP id C8FE54000F
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:48:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H/Q9//CT";
	spf=pass (imf17.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.85.0 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791398940;
	b=CitdWx6xP13ST8Qzh5uYCT70GeGhqPoAYyxIIMKeattqTAFs7H2Loy96w+UN3+WjlvaC7b
	jjEZPkEvdXMe6OJTL8SodF1nsjYKJd6GfZ44P5B5A12E/u2pNxZKlwyq2R5tx7U0UG4GKd
	v+KM+ZPRly758d7yO2zYhdKfICEjkAY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H/Q9//CT";
	spf=pass (imf17.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.85.0 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791398940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TLWJ1MdRWJxyEFOFCT26/MStZZHKoVEXtYBpaT3o6s=;
	b=Lyvv0D66bbaUEWacTR3brimZ6wasVn2413OFolK1jNvRaqOyRVofVDf8ZEN06gV/TbKSVo
	S2uoHS9SnrNc4tZXxuMfsyQadh8mquYE/UR4vwQu2M9C2lHL4gkFgPWzwFHqVx6xS9frbR
	XiYN8uSiyCJlTMBmT4U5JbYnaS0ySWQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pmZAc4qsz3q7181vMa56valegysIj5kA5BScVoZzGRGKzj9PxFghvv1d5nkNHeUdfUtlbhwZGWyNC1hU4dHZ29GbLShC7JUzLi+rQ7c/iV9PoqvFpRMMU1cSQcp/nyaTjzxj1phOZ7AkGQKXrDmJKlb2rgwqHKEmgK2lJfRtQ+bqXASN0wIFH82/BiUsZYEQ5RBG40U2PXxmIElu54J5NEX1JFkNdVCMYfO/tnqLqo4G9XOLLh3jRYHPaqyzAyNsmCdt/vn6FuYxvJZtU90g79svmoffwjl75fC2ryfyCmaedAMpJUFLyOOih3dCJvPZy0U1KIGX1n1UHUGB2ytc5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TLWJ1MdRWJxyEFOFCT26/MStZZHKoVEXtYBpaT3o6s=;
 b=XSVnbWgr+MV0JC5pb79ASXHAx07I/isrSkA14sCsaRVOX3u1ypnW9fTylG02ThRuuspbtXS8akD4S6Z+FttBieLs8tqPAUVgYDDacqnKUEnMmZOJVGHadmwNf4nkBiR9sJYD7uwrpg8NoPoYkI7IbZpzFLoYxjUMb8RCwhs+XJAYoNt78eyT4WvkNKbCOe5LKRT1vp6h65LWYBCUWVKI8/zoaU++19UobzqZJZvZatOUCgSnJNxW70jPcwElIYT9HBPdGomiis/M80htXqks8k/WTKl77ykx1hzbRbipFyNSdjOeFLuT05xmrNTMKkdW8vKBT2unFsd+4T7tEowTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TLWJ1MdRWJxyEFOFCT26/MStZZHKoVEXtYBpaT3o6s=;
 b=H/Q9//CTn5AJ4q8kisdsp8esX3lOE6Vl6rrvYd7WqBbqrN42BrRNb+Onx3jmCRmGbo7vdxe6i58O1mP+BIwTO/Ll3535XCksqiycho/jZlx2I5earV/JaoZJZ7gr3PYRSpseZ3UQLCNzZSw+XwJSYVHxxHI1vFi4ne/gN7/ganBDgm9p9iJbstLKW4vzSN7FoBCTe+nIAXXSnqB1+wenRvWnmdUxYQ8RIKWhwdTW4Qx/GtxSCi2xF4kFDxvyr3tcGqE5oPSwpjAT/+NRhkWvkol5ZJS2tEqomoeWmKj7drYifdje6C/EB0RxddNr9O4ReUlL1FtHkVohT100kGQHPw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by PH6PR12MB128275.namprd12.prod.outlook.com (2603:10b6:510:3da::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Wed, 7 Oct
 2026 18:48:51 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0496.015; Wed, 7 Oct 2026
 18:48:51 +0000
Date: Wed, 7 Oct 2026 14:48:48 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	rcu@vger.kernel.org, virtualization@lists.linux.dev,
	linux-rt-devel@lists.linux.dev, llvm@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 16/17] rcu: assert static storage for RCU sync and SRCU
 definitions
Message-ID: <asaUECwON5PS98M8@yury>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
 <20260915031334.1194975-11-ynorov@nvidia.com>
 <20261007184105.GA3837481@joelbox>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007184105.GA3837481@joelbox>
X-ClientProxiedBy: SJ2PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:a03:505::22) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|PH6PR12MB128275:EE_
X-MS-Office365-Filtering-Correlation-Id: a396da15-a4f7-4b3b-a3e0-08df24a3a0d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|10070799003|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	KDvQAR4Tikl9QVR7IiWze66MK/tXUt/krHiLIfyhhoLpIfS3uhXoultbUznj8cM5dIOUgU/FOBLMklrj934iG1XUT7mADecPJR+PsA/O0XRwj8LckbtP7xbDAIOcklyXZJA1d9pzZ82MjiQm8EmoTcL0vy3zTbnjiKWWwLvTPTuWsNGEKRajujZoGfSf+XkfJCyrWZUunu++0SsHnVFS5PCDD/u3V6k43pbhYmb1OwTCyz76PLdPMGD9qAn+PaS4BohtrdgHpauzh8YDRfsmECKO+upsCl1fmCKaW79c+FkbUYrA6QBESSPaI3qG6Yh69CEpnet0F9rv4uW7m+wVlIKXPmWE7IiwdHFmrF8D6o5lloBRFzpMcL8XipmwNw7s8wtE4JpCVqHYIgtU/BLQntBW+QF1GTz0Cdbfxp4ArrU+gvW3RHlm48umLeFAS2oyfvHxt/WLlP/B9JXg+5gk01tIP7iciZQmgambF4oFnAlvkxAa6AkFqteRbzArC7DZRbJ/zaWcMziF0rBrQY1qUKbb5nFvNomTBbQOShndPP14qqPCY4d9mOav9zCJ+IhTQLu8SxZGL7fH5Rcsb9qgO+YpGgX0tz82nEOl/56ymaBwXNqQdhufgSQtHIIgkA7sKIAC03egriRKIu7BRdVIg2NLZSas2L1O6nazPGXqi8g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(10070799003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h9O8M/w8AtSP/T9mlaUoHJcLX5Ah64EXpLBJOt9mqnR1FLj6s19OZozKBkMK?=
 =?us-ascii?Q?umZru4xKGzWRIeQho6SEEiVDg+y6QOwPVXN9BJDEyPHNvarOD6eiLbqqh1af?=
 =?us-ascii?Q?JwCKyXfHTW0SbF8XxidDrGor/6V1umonJMX626ZDa8HqZtqQnhxFfbvsyoDM?=
 =?us-ascii?Q?VtCcCyn1xhfH5vjKPMbiaevlLXkL3MDCQO/MY2nwhd47ylXt3ttelgExBPbo?=
 =?us-ascii?Q?bxYQ/YXjQPG9V+TzkdjC6owvlsrovQYufAAc3bPkSrsTv6gkCCTDlmmYKZFt?=
 =?us-ascii?Q?36IeVI/rRs0tKnOsqvb+xgb2HAC4rOw6qFIwULu2SNxPW2TjBp1OqShJ0sYQ?=
 =?us-ascii?Q?GYQHA42jKbrmmeg6tzoXNlNxaKMBWIucbmnCCJJ/th3tr/3/LheHYw0gR83d?=
 =?us-ascii?Q?ePuW9CdfOS7AZWYhay/yRtpLioUPZWELIcp/GU2aJ9c03khJAS+H27FVwWPl?=
 =?us-ascii?Q?ivtS0CIkoE0YrLFSC/bIPl8aaIbelu8JYpPNHQFy+Lh888N8JHTGg2Jjr80S?=
 =?us-ascii?Q?27oWX5gR7ALT14m7shVG0Sv8dtRvSatxmjS1Z6isQ1wWO+vOtrQl2HnehXP4?=
 =?us-ascii?Q?2RVc9Exkmxxgq8c2sj+GZuTfKYDOHE69neOs8pdT2VqSfExEGkT1uG69a67H?=
 =?us-ascii?Q?fTNQL4Mf5mzck74480zajwoE63PKv3tDMZnnkbLsqPcoVMGMA19PwTP6Ud71?=
 =?us-ascii?Q?p9bAQX91MaN8U2fHwg0QnpfsdsdNHo9MMALOdg1w+DoX20BdBNaBqIp7K1gm?=
 =?us-ascii?Q?6vr/5lCXh00JF0TE6TecERbhoQeDnAOEd7E+G/48DoE+Vt833rCsgy6b2RCY?=
 =?us-ascii?Q?EMHhBRIMLaIczKyL1H5++Jp/3vLn/EfG8neBU5ReiN4kh6DYY7alSoDxVT/2?=
 =?us-ascii?Q?hYMOydLIipcRlJrAZb2OijtYywdVw1usTFPKELCkwgLSbxpuc+tATnAkGSFn?=
 =?us-ascii?Q?gxK+J1SPFDkWT9GKeAYP9LRqkO6whSVQJMOy0gYji+VOFge/ggNUwZrhwe7K?=
 =?us-ascii?Q?5TDE9crCeJOQrUKLjskF4m7VQgT6WDl1xeznG3z73GIN0iGbfQjY4ggCkQ87?=
 =?us-ascii?Q?GApqy0ruHJQDVxdmmDVZViKQlGob4+PfgrkhbTy6J1VHx4JbjzwsJn4foxsn?=
 =?us-ascii?Q?WLqGOABioI3EeT6flkMs4t4s8gW/Fp9Z/hStS9P/eF2lTtCF2zJB7ryHNbq1?=
 =?us-ascii?Q?SJUs3mUMcbE9xVSrA9FBKW06fluFgkN+8oY0De3lmidUHaikyKVVSomiaqfz?=
 =?us-ascii?Q?Agy3cWfFxG8uZ7QmO23ryp/rv+TjOoQOqc/Aa81H6wM4mAkG5eGpwQOJDftY?=
 =?us-ascii?Q?vnBSZQH9XwomvICxk0tExnOUVq25ZFdoSjHIFccJofKJvlAUwX1a3lpGrGHC?=
 =?us-ascii?Q?Tt8bS0s8YS+7Zfq0s8N+VA+RU1pGEz3hyXW01S7psnbwJGlWlqqQeaKAWewd?=
 =?us-ascii?Q?I/hncHiz09py7sUk0AUr8GRA8QtiiCS4stxCm1FZcHgnropXa8nixnzwzkOd?=
 =?us-ascii?Q?u94AF61rzyxCW5e4nQtkqYE+3Ar4yE3rfY/QFwA66iom9R3rGAKFZ+Po/sMy?=
 =?us-ascii?Q?ov5MtUhYt1LYHaDNNiLfgdVD3bSsgfWIB4BIiAGigE/ohLTeHooX/zxb2FnN?=
 =?us-ascii?Q?du4viVLxglKVvCxyj0q2WX4ndTZcHmSdIbTeLTmXn672zXAcT7VSndPVykzX?=
 =?us-ascii?Q?17GBfn16T8yAUBlte0/17eXveGYmLU1GjnWGLx9CdTGb8rsT5IPfnibfAoli?=
 =?us-ascii?Q?6Z74VkoXAnF3++qcCBbEBBfcERfUfez1nHPkudtQkTOTCLon2OGD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a396da15-a4f7-4b3b-a3e0-08df24a3a0d8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 18:48:50.8547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBdMVg25g9plnw+DwKb8dvV4L+eeS+3dT5j90auJwUwxkKgMCJzLqPZB236yu7T4jyktGSFM0LtpiTBlyWbalg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH6PR12MB128275
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8FE54000F
X-Rspam-User: 
X-Stat-Signature: yy1mgeeiaeytbm3zsnh1wrgj7yghsjgn
X-HE-Tag: 1791398939-245044
X-HE-Meta: U2FsdGVkX19bFNfSQ+1MNobeSVMhFJTHUyy2PTQy7HVRAYxOZ2WIoKoCm6Hvmqe+yjbj95lQgumTOuLVmGyWZC33UbNKemyf7cEF/LXOyImR/+o5OA+QCufkikEEfqyOO4JW7nrn9FwDtks30YYLKSnwDm6MnUHac5rvgjl7lNeCWZNGrxbJRNJX/Ljgyd1Cfb2JVxCCbBq0OAsB4bsS2u6KHknxTgrImxrkAO2biEt9IMrkL3YCgi49TZT3gyXG9cytlLpQOG75Jzcokf92G54UjYzFzuQNC0ob8DHguUIFNbdaYEp1112/5hioeFhMQ+L/5NNJjDfnAdEB67lIlioH3KL3q6PUOwGIFE4HPIAVJSw0qSwoD0KBYqJVdcCi+p7ke16qwQQdnoYyt+3ed1c1/0ama8/edhJqU7hJmBZBYKU68QnsVf4JXrN7byVN2k6CvnQbZ6KqXYP38DyDvtwVNDiQ804LpvR6JX5w0kmN9NFlJR1ADNRPOsix51CP7s0RKbjXAtAqNF96CQwtaVnyxebZJhF3j2tyO5fEeyS01NEJ51IL6a2lyePkaGBG4zoNj7A9ozAhaxAcB30313Zik/hkEcTz88PQEXaDLb+HahA5kXQBktybIXXfJ4ROlU2Xli2+WWbAzrhjLkcSTtt4QoCOjiSobUVpXqdqNd/GVQlSg+zFfeRYePUZJo/cH9uzIvLT5PvnlEUPuin0Hixk01s3OKvPoeLyv40/C+9a1FqSlGfRh1hoZw8gCxtfTrnzsJCKdUp808pncjLfkMvL8qtzjJwyg/QkIuDtdjAkhYuHsx/kCqvm8Vs5SwFQk5RktQE7t1X2TFsz8va1hthdURomz2Vj3HsYnam2vJ5skxlNNxTXDv1qwaodAlgA4BWYQsFPOtb1t2m/DShlDXmzipE61YY762BbrgVXCvzpN6J/bCFoQ0Zw/QcuvDUCaxJiEfzRpzHddtVXAWu
 tCuH4CQy
 6XuBZGYtvvFjhkKS4EWyvWl5ys8R29pc4wBgMUeQE+5E0STl6VpKWYpxKUrRiVihmuuEAlt8rGbi5XdMWaV0Xvj9i15okRNrC+3EHIwTSLfWqGvJ7x4cENtDe/m3Bue/yrDO7vTHvGuXfhaiX7KhiNfsNi1FnWqzeHZXALnqIPRl2k9JmX0YIMvxRZbFFfBGBX395WvuIEN2IWMkLZJ/M3/EdhNj53j8VVwEUJTAoTbc7AxCkpHhLdZg0ETil6LIJjQtn+3ep41fxJMMWPV65Yr1L8n8bwPIeLhb+7Atfaez7Kk0WrB/JZNEbPzf9+kq7ngswzhzKzh/8oMTcol+suEKUd9wIpFYlvPLgaIEEyF88KAUZ+5IQOo6Gwby190a5lJUJ1uGWbw9HRCCkNVUxkj2nIta4gSijhvTOX8I31O4zfi9ZFzOCFt5A2xIySS/LbvWrG889k/Ib5DwuC6fNgVhqCFbxr1HJSaG+w8X1b1oRFPAi+VSzV6FQC7TeLr8oWHEzjE41LY/da/typZEYCA85nmO2Qb5NmCb4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 02:41:05PM -0400, Joel Fernandes wrote:
> On Mon, Sep 14, 2026 at 11:13:31PM -0400, Yury Norov wrote:
> > DEFINE_RCU_SYNC() contains a statically initialized wait queue. SRCU
> > static definitions similarly rely on persistent lockdep keys and, in
> > Tiny SRCU, a statically initialized work item.
> > 
> > Add ASSERT_STATIC_STORAGE() to DEFINE_RCU_SYNC(), both Tree SRCU
> > __DEFINE_SRCU() variants and Tiny SRCU's common DEFINE_SRCU() declaration.
> > This covers the non-static FAST and FAST_UPDOWN wrappers too. Tiny SRCU's
> > explicitly static declarations already enforce the required duration.
> > The existing per-CPU restrictions on Tree SRCU declarations still apply.
> > 
> > Assisted-by: OpenAI Codex
> > Signed-off-by: Yury Norov <ynorov@nvidia.com>
> 
> All the changes make sense to me. I'm ok with carrying this for -rcu 7.5
> unless you want to take it.
> 
> Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>

Thanks Joel, carrying it with the RCU branch is the preferred route IMO.

Thanks,
Yury

