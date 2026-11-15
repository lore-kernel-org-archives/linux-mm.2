Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D35606A33A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 23:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fUMPf3ZX
Received: by kanga.kvack.org (Postfix)
	id 18B226B00EF; Sun, 15 Nov 2026 18:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C806B05B0; Sun, 15 Nov 2026 18:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F326B05B1; Sun, 15 Nov 2026 18:21:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7EE46B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:21:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C7791A0822
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:21:55 +0000 (UTC)
X-FDA: 85438928190.28.D688BAF
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013015.outbound.protection.outlook.com [40.93.196.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 875B9A0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:21:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fUMPf3ZX;
	spf=pass (imf15.hostedemail.com: domain of apopple@nvidia.com designates 40.93.196.15 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794784912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhDC19L8bxetJWEOwt8UJ+2i0dljJZjZERjlDf4H2rw=;
	b=TWYx+qQU27+RkyriY8XK85hqBEZWtPHegZyjxaqXcOzlx/IFfLDY3q7Epnhrq6sKXEeEh7
	vvFlZH0cMU2U1VsgDLpmYS+HYxQ4Rsdou5NMTRDQ96HX1QuHcFVMud5pIJUwpt8Oqdcgmo
	XnrtXBQmAmGujnhJjEZfH0+K34OnxsA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794784912;
	b=B1xIQS34K0Kp5i4KsFJ7GN0MnFKWMMzCP/jWZEo+cwmVRTFZBgy27aWeZUKOcky7rPXh3N
	l0vcXXC7voL3KLGz59iBNfzK6rDYbWLIymDrp9EqhH38MN10GQtZ8cfa4TB3iKKbh8yujy
	TXhEtroMNY0yI7jsKOkyvQZ/q8MFHs0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fUMPf3ZX;
	spf=pass (imf15.hostedemail.com: domain of apopple@nvidia.com designates 40.93.196.15 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e59+uSck3V6RDo5TQWOoJsYfz9osy5Nzo54ogUC+y/gpNVlX2gCjLomvptMD1umIUmtIkLd64L5C2MFFMpP2jdp0WaQ7C8e7czwZ4p9r/67V3PJpCPttD0YGhvcFWKeEScb+teXCouIhGAGzqkkZpkzdeSAVT8sY/K2iR3IizLABlOCzxkP1vwiJGPrGDy1d6zILTkoK9sCr1qW+/VNSGvkcjs8u6HVYiK+jQFRfkOWW35FQHxACZ/CWasQkdbChkmxBxGdQ+n7MmKG1wY4eKgKhUd+psc6tjioBX9Q0Qood1Q1eAb0erqpdinq60CwkdVx3UtwopL184DDPdFHozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhDC19L8bxetJWEOwt8UJ+2i0dljJZjZERjlDf4H2rw=;
 b=NLKuihxEQyoLRo1FrYs6pwW+Aq5CWHeRGCAngziJYVdhr8L5783Q8P+9LBinj1d+Nt8bpYCAnfqWARut97liEUTmomktc5cjfYt11AKy0SavE+R/FXDi5sH5lNMSZdqDc9686+NJigEszkFL3sp0M7El88ROGP9Z+4rD3znE6A8jz558sEXazs+fAdcqF4Bq4Zpo4qfhzQH1N0wSgoj8LmN+alxXw/2xYtipl+V6fSgNlUTYFRfW7n9I4wuPO1GPId+UL34i4Rim2zRZIPU9eSTBV011YDyO5pEAAuroBXh4c94fNxqTSGZUExQ6qcw4/ZiJBUtIUzyRs87yz3HA5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhDC19L8bxetJWEOwt8UJ+2i0dljJZjZERjlDf4H2rw=;
 b=fUMPf3ZXeWHouh7tWV9HWX3STF7dn0fGEauUnGh7Y+kWbasSlyrGwwCPmP98xGrmfO7veLbWRW91A+ECoZBYHzs65Kg74dr588Mn2ifrwVjUKwLXPyLKIyCH4sbld0g0fmbLDmBDqTK7eWuqpQYmJ2wV8xRsKVium8tvMQlJDbsrUF5W4tqBdNkJbrF3mPZF9b6GgSOA2QrBrZF7+uxDiDV+AF3tgJbMo2imCKZT3ZFzMy4ryw+tRgk/chbKfjakfs6Hcj1D8NvN33+42b3fvr3qkdWFZzDe+OLjLig1LRxRx6ms6Ayy6FQjYguaNjivrpSKfWSxk0c+0j5mALa2SA==
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH3PR12MB7595.namprd12.prod.outlook.com
 (2603:10b6:610:14c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:21:43 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:21:43 +0000
Date: Mon, 16 Nov 2026 10:21:33 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 09/13] mm/migrate_device: fix use-after-free of the anon
 rmap
Message-ID: <avo-M-Fq2jznQMYU@nvdebian.thelocal>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
 <avTzHDlCiaNSzhtX@nvdebian.thelocal>
 <avYNv-bmQAGE0ktf@gremlin>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avYNv-bmQAGE0ktf@gremlin>
X-ClientProxiedBy: SYYP282CA0009.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::19) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|CH3PR12MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: cd15c9bf-e0db-457d-a6f1-08df436f35ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Ldn5Gt8fFsZaBbWUVqOxvD2WY36F5utiSx/+A5cInEsNArf1Y1egMFV9mHvxigO9sZ/4LjIHoTg+Bj7E7Ti5WvAKob6PS9cBiMdDeXS1tC5PwWS+pDnKpWjw+VYXMqeGcjMkgelGQUZyEylS5ZsAb8JR9BLTWFLlZKPstJ1dByHDg3pEbEjL6brcoSbc5l15aUdRLzwoa2l9UhnHXFIWWeCkJW+33crEFjETRtzPyotkCzLvXZj0E2/uLe5HESaqF88Jk285cKT5IIK233HjBq1hXvOimTj1zfJ3Yl23SLI6KCRZxY/Bc9q9nN4DIaXZRGYgA/bQqwwJPsSqn4WnB16IyN57wueCiUghPiVbhaIiZlrCp4LWN4Sq+QvbldzyjqSwUKWE976QpPjyJBW93VzaDOt9GWTTLIZGJmiBaWXUSkEbBMKXF0bHMuvHDlzI02g4CIUP1GTbIChrmkUqpEvKvEbPLEWrxlq0bbKkJs3e+It1P/PCpoQZqn6hb9RDg9bZAkhjqFkIzNOsPCnVYsrWdiB9q/yWB/hpOJcWHU0jtB/UdPHJAGl7Bo+uwLRr+NSAzKCl1Pc6yAVOynCiBmZgF66i6ouVf9dc9Wm1lV9Z5SQ6M66eHvAey6ynDW7FOxkmKaDqgsARNabZ84HwG0STVlP42tNJJOwokAoNYIU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5RgADQErEK89JKfnoSX0jjUeUzCc0jLD4O9MB7I1xGJc6Yc+mZNTKwC9YlVJ?=
 =?us-ascii?Q?3WfpBRAF39I4saNxgbBamPWWI1nK4ddWE1rXJzYd8QsuPH74ewOkeQYvXgvw?=
 =?us-ascii?Q?TFBk4mvlVQNbNutL66kTBuTfwqawzt0VXd/gBownM0ulFKjN3Yrhn+6/rOcj?=
 =?us-ascii?Q?vDROCwAR2AM2jkTVNl+UzhbPECSwQUegQj7ombBGMKxtCNtMm4COg8QJdx9J?=
 =?us-ascii?Q?1U+VH2Wk4Ut8wLNID19/zp4kdfjy/s4QwkIVZGooR1vHf/KaHmq3nTQ06TR5?=
 =?us-ascii?Q?cbB45CjLx5C3pzXTKAghvy4ZtW3WnybECFFYk1bHJGYInY4WPZiF1UgV2oZD?=
 =?us-ascii?Q?6mnHXjTJDZIS25v0owHdEwEJLvlJnl10XnFHrFGrmjhDCqx5peqjMVzUJiqC?=
 =?us-ascii?Q?9oRHRjeTnS5GYnPzr8W08cr3sYC4YfMnZnHrepvRCkskSVtcflpbsiZoHS8+?=
 =?us-ascii?Q?7vAPNnZdJ1PZly6I9suzp+yPwFaU4ytBQ5TT6b/h5ZFelDPk5GePqvtWaEoP?=
 =?us-ascii?Q?RIxleCSjzkUFUXJlwcCViNDwMtyPwvVCDKakqRh+TlL9Ooh77s5jLI+iqjdn?=
 =?us-ascii?Q?hlJZWNDbRlefwVYpqXz8ES5AqP7mTRgEESj7XFdXxeYiAZVekHACkmKbrRoQ?=
 =?us-ascii?Q?ESdAgKQMpi3N6TRuZXd9G++siOzqNcXYXIB+jG5Tw2Rk5jWPEsv3pGywZNDf?=
 =?us-ascii?Q?SQIWd0TLrDqYgc/x9f2GJGD/mxJgvaIAztC+cTUl6f7+BFvnabT0FLdwXY4V?=
 =?us-ascii?Q?xgnXpSrED4VFdmQy8CzKsy5pH0XNfjJNvOp0+EDnul9reKbx1JdbGogXYIr7?=
 =?us-ascii?Q?3g4a1cJALNsdQnkoiTffuGJCd9obbsFX+4AQH8dxMvKCWyZq/HC3t8/2HeY0?=
 =?us-ascii?Q?C4218hGnJ0JtrpeU/q/qIa3pkbncJDIzbt0ae4nzJYMCqDDLp1F66TMl0+Fs?=
 =?us-ascii?Q?cxthXHzPq/+oQbyT3Wv5gMOWxZiQyFlzm0Ilo/JnSiGFAP9ZPnOEUfDOaJl6?=
 =?us-ascii?Q?KYpjfwUF97MNZYwfJDnrxTlwcJgD/DNcikTbXnuicOk7U+pR6uFymdKaFIFZ?=
 =?us-ascii?Q?y9NA8CQ7v1D2ep1rd6wfHZKDyx35ymNg+zvaxvsQD1Hn54M4zDKtnD6e9PO7?=
 =?us-ascii?Q?yt3qIEND7RJL2C1jjYUHjvCa4trcr9ol8djfZDVDY+G5pHA3C9xMQZBj8bT9?=
 =?us-ascii?Q?+XT66Pp1xW6mwOLvhb3EqVOB/ivLnSleYOlnNJ73DegIJMv724QqiO6D6M/C?=
 =?us-ascii?Q?JQiDC/MijwwDzjqNtDy+43rHNOYtrpDNSI6aRpdL/k2TK9mrFwyD5IK8UG+s?=
 =?us-ascii?Q?kGlAckrMtK8rdhTIiUipNbxwH1Czggy0WUmZtz++qhkbUjbVwx5zi1F39Qf/?=
 =?us-ascii?Q?llusniWxLhvKSR1Zj/gKwb3gfFoR+LrHVZrflwNhZfVKpZzuQNdJA/vdUcsM?=
 =?us-ascii?Q?CuVZAKBpaKNfdicmD2AEK3xuXsHy3Tw9mIHUPEm1VtwdlD/mq8qrX02FY45J?=
 =?us-ascii?Q?sWEgIh/HR0B95TuY9OmyjG1glZMWrRU6LkUhsCJ776pxyhIQNzqy8kN+9oPR?=
 =?us-ascii?Q?xI4sKjxspFCe93LxxrfdB45bHbsWI7a+y2dcbXG3opSP0EkpwHTZKQ2ATtVA?=
 =?us-ascii?Q?pSLtmlIggfHkb9wf6o4LTjr98YMXop+7adz6FDB/e2NtM01VY4kIYnGZSqx7?=
 =?us-ascii?Q?PVQmhl9b2e83dQVaAqdhJ+BmUdp/ev7V3RfmwD7zsWplukd3q7m7ih7aTVS+?=
 =?us-ascii?Q?KQx449ssfw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd15c9bf-e0db-457d-a6f1-08df436f35ab
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:21:43.1733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SN98nuiA4iicw1IRtXOLEv54/+93GHmXFi08tWPo+10n53L7df4xCK/jeiw94P9EdciOQ2kjCUWj8KDHg3grZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7595
X-Rspamd-Server: rspam06
X-Stat-Signature: fnx3z46hfe4qnao1ju3mzq1boubqg19z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 875B9A0004
X-Rspam-User: 
X-HE-Tag: 1794784911-762774
X-HE-Meta: U2FsdGVkX1+4W1aRWD/SXxmbbQiM+jT3RfdcRlFz1ES/ZiU7JmcD9xkd5KCdUptfOt9fJoObOhN3wnVeZ8S22TTh+63rstDkyOM4+hco3/+0xrCFn/9rn1oWBE9VIDeHXQ2ViPwDNlfLDwBAnHZLQtG4751/06/9ZtTwL0/wvZLAHokx0citSnWK3gi7xSfkDCTVSD5+6TQlh2bJTFTtxSK+fR0L2ISqVWb3RDQm+SuFEoVYRr3Jr4gvSdtjT2wvnN6oThVQnwq3sWn6wbW9mp3+AXPZ+pOzRKTO+QYoAcKobzHMeBbJWZDjvLv51FAK7naH+wetXSPdEq7kGRprkniAP3YiKXW3zPjPN1IDnBThNFkfTrUnOTq4DxiZ4//cZYCv1p5kpmsCgrV6fxLo/LpkHXw+4vl30vimZlUIUcpI43ovvzqw2cgwtChA+0QFWqarG2x0fCOJLKDXineGz+YxlLKremltpfO9u44eOebB/QVjYn3iZEesAmZRcH8Zs4oyX4SUeJDFtyMb4U4PDFvGNgHs5TfB83y/D4qTa3j3Fy+6gYgbK0tDnfXEIpQSta4mErvGTzW2tsSG+rFlgHW9ggX20eGoLLjfHI3yzjNmxLeT9w/1KjfLuDsWpK5TVa28SQPc1BWoVdrbKxZWPS2t4EQzK5cbCRSQmA+Qhc9kp0/nvBJ9Fr+MkFBz2PJ+55FKZmSm5bPcQ6HktIemOyBQ7BvppkwTUH6N2/xi1A87kEjk+Zf6Zlpn1MBwm00jKkvoUMh/6HfF0bTX+a3xqOszYkC19mmpvxzztyiMIf+k55maJjmQkrL5atc9E57bFdzMzROPsrddlLhlioY9hWR+q/2cyCCftaGfAq/L/NQS+vFFzue5VexFSl9nmT33w1o0UsMbN7mHWl/S7Fd5ix1qT7e2OIk69FQhKc96dU9w3Z7Rv3EsSCta/oi+dN9H87UcgGuw87haW8/C8VI
 shYnal7D
 qZy7OLrGZpw7K76w7JGuqeN8OzfD0y71q8qWMFLs6O9YXqJzlcwabiCHoxYop3xBNdvn87dugYUrHNmkLF5VbDIqh5p3b4A/vFqqu8n8DDoFxUF0OkqIwdL9YAsosfcKvsTYo8BMtJpiVRVnvEuIo0f2MRl0xJnUoR76bW+BsI4DXNgE2bqggGYXvKydSmeO4Pju/FRyHXG07nijjuqZWTnk10BLLKyMWMNMPG0+YqKBH+kUtE6tG4MKOsTdyr3TC/hLwoz9bCzzYxJuj6GO08rdUrn5H/4B9Xd/vZBJuMF+oaz1AFV3bkMd9JG55rDY5b9Li84YaVjHnudv/hL6gxB3NjGQHH7ZNJx5wtcPHnptYgfsh9+/PzsYP8LGoh8d4DXpZg0xDGsmoQoFZnFc7HeW6RwzQ7KQpWN6XKYZAYuPQRPo6CJ3qtkLgohdxg2WqeT5gqeepCGaYGsdDBNkBDIpuBLhoYm9BDYXkhnqm3/nhqL3NIMMi3ayOAfSXmrk0o45mwNIEe/UpZQ5OMOUKK+gzTEIIftnbUo5W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 at 06:05 +1100, "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote...
> On Thu, Nov 12, 2026 at 10:04:10AM +1100, Alistair Popple wrote:
> > > Resolve this by pinning the anon rmap of each folio which possesses one in
> > > migrate_device_range(), migrate_device_pfns() and
> > > migrate_device_coherent_folio() before its PTEs are replaced, and
> > > unpinning it once the walk is done.
> >
> > I was going to ask why this wouldn't also be an issue for migrate_vma_setup()
> > which does something similar. But in that case mmap_lock is held across setup
> > and finalize which I guess is what saves us there?
> 
> Yeah, exactly.

Good. That confirms my understanding so:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> --
> Cheers, Lorenzo

