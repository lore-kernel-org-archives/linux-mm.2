Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DE7C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276D66B00B1; Mon, 14 Sep 2026 23:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2282A6B00B2; Mon, 14 Sep 2026 23:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA896B00B3; Mon, 14 Sep 2026 23:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4C406B00B1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:14:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59FEDC0301
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:36 +0000 (UTC)
X-FDA: 85214528952.27.E659256
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012063.outbound.protection.outlook.com [40.93.195.63])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96D83100005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZUOifBcs;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLlM/fs18Ew1p4SDbaG7B5TPIvAP6a1EQ5gO3YVRWLo=;
	b=FB4OIeEDZBTmwpfReHBhR+OYPMaYMtzTmtN0zRmMXB+584OJzvzrBUaKvW7xWTq6qdsVRc
	vEXPtX8jbEpiTWwl0m97sSR1wMqNj2suwfoeqCitzb0e4+betQmsYeLQihhW5SE6Yi7hp+
	/iOA0LY22h1u8z7ewLAovGCXqrB0KfU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZUOifBcs;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442073;
	b=ZhaXUMdIobfJsW6JkwLLt0H5Y6n/lbQXt9D4euFyqyjRB+jLeKpU6d8W6JZS6kBF0oaVYb
	xTFWMpYE0aB5y3NcRQ38ywgxcbPkffu+QUcV/vgxiWlCozrjSa/gIon+sKPSvaQxSZbTml
	MPuPEALJXUZArqwtCpeZUCt6oqJ8TJA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6GmgkI4miVFrniamzA1iIhpYlud79z0jAMZ3+b7rOMUDW6StLlaPGZ4hEw5q7qBgkQx5PUUkcYecL3Iwi/H9FTt+0y7qd8lJIvR/X2bvx8aKaawFBGUAeAiyIcxqY59F0ZV6X7n/TdrjKll1V/pUxFUxqskOqPHXxgjSl4VE5Z4GKFtcnBqnf+Tk2G4q3vKnCHVV5wCuDTuP1VoseYGYrJBqLtv/NFWAQFHfqsBfkHMBnsjQ6tz6h0G85x56FGSr0iYp3G59HSxHbf2GGqD5ma2xhHK1egU1FIT8zK+dI18T+hFBqFSrZM73FJ7UKBbyKe86dpz1CiS9EenSkBC7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLlM/fs18Ew1p4SDbaG7B5TPIvAP6a1EQ5gO3YVRWLo=;
 b=BPA34QoYe1CO7qmA+NwPKxJs6rlV3Jtl0FmfSqewoXbMHmKCSIUiADQhAnDJfOj7nLyYGbDz6y7OkqkAQKloEfeO7+3ADWnBTwPH7eTR2w6T0cViBVPNWH9vgKYoXYtuIC6SBIhW4VJSPw6MgaISCtCZzLho4mO7CUbpJigbBM3607YC5J/jRdQwDx9SP3EuAQIUcoq6ME3Yr103klmQmIkSlG590cQx9WRqkrbkkOr8FHeVH3bM10XtmywAaHAbKzRhSB2jsT9ERlEdWkcMEHXgPi2KrAaKK2jN5L9/q4IuPvIKqdIuGy/vB2Egm/IJlh7ty4XbRJwlbQRy1MsUzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLlM/fs18Ew1p4SDbaG7B5TPIvAP6a1EQ5gO3YVRWLo=;
 b=ZUOifBcsBqQwPXEKi7GOLtBQ99Xcy8k1LCFbFukx61gmUzUbm0Bs0TGd1Kz4a2shopcmrZbdHM3T8KbvDp6geYbsp0fzzi1q+sDl7PSzFv16fUQaRic4h0r35S2u6ffnlOhG6hR9kCELXlNvAyhp1X/VlSCy1yaBMD0YcD6ZafvbJVyqwvM6rjizdb0O3w0FBoyBBvIzXRI+u9ThNV09d2k5jJ131KzfZsPOUVkclOID8Xl8QZVNfQZBBz/KuqQZ8kaOMss8mbf4vUX9MCjV2Pj63R2NXEI5vwsiGm0OTGCjXZ4JcVk5IjHJeZHkQgRhHN3bF0yct0Ou+vFlRwn00g==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:14:27 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:14:27 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rt-devel@lists.linux.dev,
	llvm@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 17/17] sysctl: assert static storage for DEFINE_CTL_TABLE_POLL()
Date: Mon, 14 Sep 2026 23:13:32 -0400
Message-ID: <20260915031334.1194975-12-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: 6daf2da6-a7e7-4b95-017a-08df12d77363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Qo1j+AvdrQ3T8IqkSwOQqtnDz3rnUfofGKb1knJaHaz/RgqNvQvXcIOY+hEpnzirJCYMyhopAu9TmRLvJPGsMOUT2+83qwSgJ3o3wNKmj3nfASNYTf+C01GKrREURVCXNdJLOlfIksRdnuE3S0LjjMIFEhpMahWnIX2BmlnsJ9cNNj0KYDPQtJ6z9KkKt3PR1WthSa8JRjl4lWyPB9zBaNeqOuCFB+NPr06pEfECsQIR7A847a37ho7tCK0R5CHppntgTp2r7t6f4BzAwm0NSwgpjdl17bf9/7a6UzSpybqxSjPHmTX6Ya41POOgEvlpJw5FEfuiMJYr4b6WiEEMP751xT1qSpLeZO/204qTZzPQsoBOnYy6zEnKYQnOzx2WtTA1kFMy1+fbYEH/ZvSKlhrnBNpUF+IoFFIw+06Uq5nEGOA4KGsxxbIZIFkx5Es9njWcPm6lkehEOOSfXlQhO4LasYnN79xZhbwGF2NmodcnORuaRlHgU2l0KApsrRnc4ui3wJHIdrbrLNRZOJTqXK4fLBYzzoRyXddPbVlXD2USpbd0jLDc6E5U50Edd2UHxat6jqghyecNZfRyI5Mu7NRh/eiFtP+BCDCb0hzOig4E1Ikm5Tl1PM5JafmGz43h2Aqrl1lseWD/DRgn5I5b+Te7le4VuLo0Wah94LNUJVM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5l1zSSIkIJQQkj4Yh9ogsri8II2nXbR7+dyn2Gl5uewrZI6MLu+UCIvt3Svs?=
 =?us-ascii?Q?77g/6flqiqsDUJjaYltjg0lWZnf/A64cImkviNpMQqVTwZU/ugLcBJo9si51?=
 =?us-ascii?Q?VZ2oI+UugFzPzef3Jes7oVZ8sVHwt/lcvvXpsAO/T//8f+99eKoV+WceZDRk?=
 =?us-ascii?Q?s/PHjOX+awh1cWzqeaSYwmo+qeOtP3cyBMK7KpPU6F14x/sdbUbL87TNwbbD?=
 =?us-ascii?Q?NEfVkOJylQAn9iJWU/cVTRwRY0NH+dlmYv+K9A6VDGF+yPAnfp4R2JbEr8yX?=
 =?us-ascii?Q?8mZ9rUNxGHf/TW6mvhT+KA4/LjPfVVmFKJm1SwAJWR6hef5p+seLr8pJOwPJ?=
 =?us-ascii?Q?Kq94uUq7mAvJN1bHLcrhLPTXMzp2JmcMRdGKrfyiVR0hkBuAfBjhvFS49Hp2?=
 =?us-ascii?Q?cePN0LUr/7Gt651bQ/H1S6eab7I8OZdcM59FtDN66xo+R4A416/OzzhVRTGE?=
 =?us-ascii?Q?EnKTYzXZ0IvK1PXTChT3hM1FPQtJmwx74ZKjjUUJS57VDmVj/nJ/VvstShAP?=
 =?us-ascii?Q?K0c1C7e7OFdF/Hp8V74Lbkt10HrYrfhVHV8W6dqwBUDSe7UXuyxqDSp3v+eD?=
 =?us-ascii?Q?zRzQm+WhHT3oh4aKiY2m4vp0BiEKpZ+fsYVYllNsEqPOSMC9CalaVil8oveD?=
 =?us-ascii?Q?yldQm19Dtu4vXwH8MxPLjmdT5BUpSS4b3ZtwYKvfnG8hUodkIpRsHavdWEV5?=
 =?us-ascii?Q?k2DQIQ/B8M31LGn6/SWPqZFNhrL6qEpGABIg2CbcKZwBo0o3zGnuuAiU+Fu/?=
 =?us-ascii?Q?a4+5oeyoQPGg1FuB9WO9IHmkIbPW5mKXKzfgNc4MzXhv9DU5CrRGaPlp7T5B?=
 =?us-ascii?Q?gv6VWFGeXdE7M89bCaUZy+OB7/Q2VvBwAW2HOq3IeH/3KPJ5/tLMFRlOTQhR?=
 =?us-ascii?Q?hUd3ka4CG/v9nfSN0NmNVXeYCbcrPxcjjeeArk+8SNvhffIgTKPxjvj2aTpq?=
 =?us-ascii?Q?lDcYQMRKNBTUt/8fOIJZIqqHwbtp2sZTq8otYn6c3gjf6zkRyOqTTUfHDf7a?=
 =?us-ascii?Q?BZdxOUDf4yeg1eXsFzBgvBqgpXohZQVCZFRYksmrwt4gkp59LACSNWbXQeNV?=
 =?us-ascii?Q?VvRwh6UMZxg9e2o23ySzZqYZnOH5cqZUNpOkxMG3E2dOG1tv4oWebe84B0iT?=
 =?us-ascii?Q?j7AmRrNObK0owP/4mWXd9MWpR24mgI9zNeTQLBPjMx2kJxETOLBpA2jTt8bp?=
 =?us-ascii?Q?Pxz0SIJeUU1DmL3qaZ/xhp2HG0Vdy7fgsja3v2D9y77NDWRZ21eO+3/PywPL?=
 =?us-ascii?Q?sKz6GEEuOMwmSDQ8ZByWKHSM3bjAdIsca3L4L7u1paRKz5LTVCfX84cDVj9v?=
 =?us-ascii?Q?xoUaVMBFmYvv8DvV15+MjIE4ueiROabe6I11wYBRrrYAnlgtRBklmgfvycWq?=
 =?us-ascii?Q?podzS8cizYt8gCIkvWHMOsRwVEci4n8Ifb4kXhlUhna/ZOZxzZgocXTKPXWN?=
 =?us-ascii?Q?QLAugcOU8/XybeNapiqAQT/nP5lpMyEhBmDB/JsDR/73YuzrwiXJJIiCYre6?=
 =?us-ascii?Q?SNTZcSW1gzdGUSFED2oDDaHg6XMbfuZgd7wLwY6ngiQFDZ1gKwXI8zAXKiyB?=
 =?us-ascii?Q?gMcICXbd6LUack8xjjW1ubi+DbQKMhe09N2DVlU5PxKc15IxrTnPrw1U7Ert?=
 =?us-ascii?Q?+yBYjV4A0qmulsvAE+Vl0AB/nqKIbNn4s8qZILJTMxJnXfwjadPy7ZyrQcqD?=
 =?us-ascii?Q?Ld3DOJlP3G778ePaBmicaLmSikTyE+9Dwp8DmXdwXsefOYO76tCBf/ZRxDTu?=
 =?us-ascii?Q?OpEopSiIPQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6daf2da6-a7e7-4b95-017a-08df12d77363
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:14:27.4677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULG/dxhE5t8BJXtBHDi/DnBjTp1qD8KyHEHWQu427wj3sbtl+C7HMqeLee8LLm/TBLSYihJWp++NKFAiyA+2zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 96D83100005
X-Stat-Signature: cz6m6eea5f77fsjscapedxnka5qedjzg
X-Rspam-User: 
X-HE-Tag: 1789442073-447281
X-HE-Meta: U2FsdGVkX18r82vJNqNbIDKPksmsx4DoX2wiHa5IoyChg4zE+/TpzA0bYVrc7FEEiTpCzEVH8bTXF6dpyoFYfz/0CvPZ8MyeTzbgOedMt61a6/o2voWm4lVdZ7gsvAaP7JccYqzZbtxoz8nlYMd4gJOyxW+JbbgyMOEHF9mJ86fJwbkdszgVxR16aAsEiCbblbavlO0xWMCAQjDDL690/sZdBhJqkTa91oGjHxfO6FdLjZKRWtp+es0VRWvUvS5pAyg2qohZW4WVUOs+1jVaYv4s8Hn+W6UiVaH6ws18x32LVRf7W2KXFFYA54Q2flh3e2GJMb8NedwIa8MAeMiBBvLY/44QIUFXMKduiod8JpZr0CBHxJqPUvKFKo5dZo7Va9SqSSHYd2iNWuM9+G9A8n37V2GplF3rihAXDRK5LjWuQ/a6GiHnS3akiiFNfNLduYyh4t8nheD8w6G34jVflVXwbGAdpfjfjLEg5veogiKzRb2ILUeQXm8455fP231i9YXunAJtoUTRex5S3vKZQPZQyAhyWZ3OJteg/2i/AvwQXcjjXRSyRNlnpgoMC+1bMQ0DiPrxpE9e6M3uK97Q5E1YrkXZyoNZphe5cKRfxsDc1IDyxMDqP/Hzm32jkCwMlW7BIn/JJ2JPMb6rGXcpiWV5GLVmIdBLJgju1pU+smoKHvLGnm1L/RNmYlRfFvomzBW96x62ZquUhPUvNXjZoGzOAMEdIvLI/l7xsY9ZVUDGxAjTu0nDRnvkDt3j4OrTPjoJ/2v1ZQQmesG2Ik5L9E/RJQV/T04DgeZ/naCW0t0B6aX9ZGYXhp/HTEedpzRvMLaE6CrzB6gqDevA+/PpA+eIAJacafhYSrKSNOsOmRR+QX0MEIqD+FrFBAt7WFx8gtfVzfcagMgZbuUSC6w7o5XPKetIdgQL+xfmdcCvpUUo1MRQeqKbMPfiYi2MYp25wrFw3icpq0NTOeNbdsD
 Hrzxd5q/
 TuQ4sIyCRGfcmnNXVpPvOiS32JX9l/OT9blU9wkrfHlfTMmJ/J2W36yYrXt1w7PpmxdCeOJwZ+7PgXXmPziMLp/yuGfEClZMeP93MqjhjrHbclVJIBJEA+54met31R9XsJiXQLvAvsUFKJMJ+hnZJrn5oyldY7nLw6xfh54EUbRA5XQS5imU2d4vbn3OtYY1vuSQ8xpFAR3v4XTC4+wN3VyBBbuXyq5Qk5cS1yUWsMDN6Q5G3G69nJYk8L9OZc5aIenugzqxgyWT2s8xFs37L6O/fHf0u2dPaKzd1BWiemD1+r/DhNuidvkqug8qUMGZcEITZRQATNhkz75yHuUVtuDmrjv0N0BhbN/AYt7HPoDbALqh7XpdYVjG/idRl8kYO9Fjnv8v8z+6Kd7hTWZ4GWBaNUJAvjSqjDaSezytOJ9m8I5jQvHVIg8no7I7eb6SdcPxHkn1dxaWz1v7vkFlyCkGELbqisxV+7/sSNw2cgou1qEzYPsYNtyiedUCU/mVsEc7nBme4J7DXIeByhFuwFM9Va66HUBeMs4p/zNH/3zTYNHxV+7BrutHNNWg5dE6Cao0geMBEvDqIK+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_CTL_TABLE_POLL() statically initializes an embedded wait queue.
An automatic local poll object cannot provide the persistent lockdep
class key expected by its wait queue lock.

Add ASSERT_STATIC_STORAGE() to reject automatic declarations while
preserving file-scope and static local definitions. Leave the underlying
initializer available for embedded objects.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/sysctl.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index e5d7226ab6f5..be79359346af 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -22,6 +22,7 @@
 #ifndef _LINUX_SYSCTL_H
 #define _LINUX_SYSCTL_H
 
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
@@ -216,7 +217,8 @@ static inline void *proc_sys_poll_event(struct ctl_table_poll *poll)
 	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
 
 #define DEFINE_CTL_TABLE_POLL(name)					\
-	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)
+	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name);	\
+	ASSERT_STATIC_STORAGE(name)
 
 /* A sysctl table is an array of struct ctl_table: */
 struct ctl_table {
-- 
2.53.0


