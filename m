Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B8D606F6C8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GCBgPRNh
Received: by kanga.kvack.org (Postfix)
	id 65A746B05B2; Wed, 11 Nov 2026 17:47:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B106B05C6; Wed, 11 Nov 2026 17:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA5B6B05C7; Wed, 11 Nov 2026 17:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAFE6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:47:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F1B980416
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:47:53 +0000 (UTC)
X-FDA: 85424327226.15.68D1947
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC6E1160003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:47:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GCBgPRNh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794437271;
	b=2V5Zy8VRGwTJsa9YYXsqvpzE3WJ2aE4GI8xnoVfJ1NymAEj5gs4TZ+IL8ptsP1wZMKKaCm
	KjCmb1/Ljjtg1Hw46dQ6wolYYiOlW0Qt2QlyzCZfHOYY6useZ4vsYydJCBUQ4dspMG1zgz
	hVJhgzw4sPCP0442nnEQb8EOMtz4yGY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GCBgPRNh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUuGXl7v/IvjjZlG6/l86Wsb20/evZCBhE5nrxrKyFs=;
	b=pMcmygJXrwk6illuozy/FHmK1byxVleFE2v8BFEfPWwobxD94U6agO7Zl8z9yUVxETdU+n
	UrcUcGNQ15U96/6cDI3Dtf7JNhqYjBUV3o0oOACA+7Y379dYj16P9Q4HUjSZhxmCMdox41
	4llAwbKtN5uoalp+sl9VUHWZk4YsOkE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4cTbbEjgbfYdw7Y25p5e2sRceC0uK0wpv8wAQAF9WZvhCULRcTjTk5EPK29W9dLjkInZ2MOK+wK8eFOO1YWj/EVLI4mQvzrAl2j/AVjz5SxLsqdODc8X6aQLahCC6LcFYCLD1mkunv/KB/G7MVpmsCPLC+rYVH4LpdR4/VX/N9GFAkZSFridD4Aq6x1tNMlrZBbLYRF1Bspcyqe1kpEd0AL946UobN58x5H0ifsdJxfrTA1IsJOb+bovGBk7+JDMFHcaBew4d3mHGJxsCyevJ7KdZumqVllBFcEk+WppVRLRe4J7xuoyaSD9aCVv93gq1xiyflQbaKB6VYNymLF4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUuGXl7v/IvjjZlG6/l86Wsb20/evZCBhE5nrxrKyFs=;
 b=bEFbxudT7lBa4fhKMhX42ss7tPVMOaX4I9coee9mGf+cIxo/jPz7SlUApWeSsVwUMZ9um/CbgW9qz5g1s4vMXph4GkQ8KpR0AsoJtDUpN6S4u7Q0pJdczGOMG6R1Swmkmcz8z0YJaYP7l1DKtGqk5VOCBkjjK350jmhy6JuIAwUzF73f7QEV4f1vnVCqgPU9lWvpZiYfdwho90Lzu3fWDhspKV3BEhEL4CT//Vsxm+kVNQ/g4elfoiVKKlQTUfLrlUHcNDSUxQzK31vEf1g9TcjOFKomSiW/gBPZyRhlj0cB/sKUAJx0k4QS4ueS/v2uk5Sq4YYDlbEXCD7mw0v+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUuGXl7v/IvjjZlG6/l86Wsb20/evZCBhE5nrxrKyFs=;
 b=GCBgPRNho7BrK4pQhIxY7hMhXX5XWL0Kl/0qlAMSPjAic0Mscquzecwdrvgww831rDutWl+nFjq9SiO43UslVGwElAmxT9Q1Hha7FAAVWaIbQJ/cQQuFkNlp/FmF88LXIi3HIRMzhSXypyGfrbDq0fpwD4cV5XcwBzVq98Ij2X+B0hd8aj07KA1TWdglk8z0J+LK081kKsns+LA8iaRTfB//0+7NvsKjMK4fMz4p4IdcK85Vy/CPBiKnRz6i/wI04isyCiGgL6xMqKL/plVNMitZWaLtaF/ph26IxsygC3U/TOgEdeweom8X1TFQ9wGIVa+uCNDDwOI001XMIQegxw==
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by DM4PR12MB6136.namprd12.prod.outlook.com
 (2603:10b6:8:a9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 22:47:39 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 22:47:39 +0000
Date: Thu, 12 Nov 2026 09:47:33 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
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
Subject: Re: [PATCH 08/13] mm/migrate_device: fix ksmd oops on a migrated KSM
 page
Message-ID: <avTu3LmscsttRVRp@nvdebian.thelocal>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
 <ef0432fc-2d00-4568-8087-cb39264620c1@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef0432fc-2d00-4568-8087-cb39264620c1@kernel.org>
X-ClientProxiedBy: SY6PR01CA0057.ausprd01.prod.outlook.com
 (2603:10c6:10:ea::8) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: 02308fb4-a109-40bf-88a4-08df4045c9ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|22082099003|18002099003|11063799006|5023799004|56012099006|4143699003|261028144727099003|261021121427099003|261102123227099003|261026140227099003|261026121527099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	SCEVxJk3Hj+5IJ9gRfy6Mxo60p+k81MIgWAhZ3llH0Pm/t2fZf/pXqNlhjEVxLXuCxfeOvKCs2PcHv1Kq3GcOX9vFexdDCzrHtn6YkuYqdFuO1BYUbSuXPjUFLqPlwVVw0Ex9tcKxv1fCJj3gh8b7G6OUC6pnrW+qguWe8wttKCOINRtn+H9QV1nA5ZvV8gkqHmb5iNxSBO3gaJWrFE3/0NK5SscfoG3GIAq9zGzu9kDgeZ6m7GdXVN8cxMOFghJSy5emGSRAExeayR2n3Fg1XCR6VsPVHqtQSsA0AoCfeFBscUJwYHf1VxOTjFg20S+R/TW8ijx+JUTfml/C4nRvhnMxACZF/4Z1gLuS7rTNcJdMdrleHjMMV0dgQs74PoXtZkeshbbr2g+ScEvwp6n+VJn+TpWD2u3z4NhqW/jEceemiC4aOzeFk+UaXxPeh027RqdDY60FmsyT9pc7UKbMVUAeqK5b3AMyhYzDbG+H5lGllFXUqVQkYwdf1WDpKt6i7T7X7XMnlfymsjW/WBUR1VNSPp5hbK0QehV4GYxiAMtUnXwJINDTjGBduuekFX2xK9l/oNdhr6hbthy6pIhKO+H5DM9CZV8HZDEurBCUKtEMYP6PH3/alwUNgZOPFa16w2yYubDlErRh3OrtH6/6wfh+U/bMalIXz5HanaLAvY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(5023799004)(56012099006)(4143699003)(261028144727099003)(261021121427099003)(261102123227099003)(261026140227099003)(261026121527099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iTH5jtExl4VOvI7HR47krkbAing5fAzzcarvgJY2neeI5glwjncZWv5/n2o5?=
 =?us-ascii?Q?gKvWkqal+wgL7qAZAuRAoFsYawjn1dtIkHQPSHKZuUOBPxouiSXjXXgGbCQH?=
 =?us-ascii?Q?bgIfszIm04yrRPKOmEg0z+Kirnk/ZC46mWgh8W7u/YxMVhXK+sb+YU+PcYSq?=
 =?us-ascii?Q?RfMus9y7p9ufG8/8DzfIiiBaJTrIly6c7wvYZErI2xpNuQCIf7Nyi9Ww39/i?=
 =?us-ascii?Q?RoKemn+TtIJTSAVB8dD2rOs8WuZypJsrCOL5LBSEdtEEFzhg1wXFrEyOrl2P?=
 =?us-ascii?Q?PU4gzcsTmwPXOjoLj8gxcE/PNo27KbFHydZzqRSgmXu46T0DdJrmna630kOe?=
 =?us-ascii?Q?h15yZNa9koC2AOz1fP27GpnyshiDlTHlB/RvRP4fIZ8MU31SkIun8fsUoqLD?=
 =?us-ascii?Q?Lt0rbi3zCe5kP0rU7s6OmTGOmcx/zzVcPuUcNgDr5GNBL6J8UQ6+WEPVOM6L?=
 =?us-ascii?Q?E+Pd6N/O3zLcv5HzQOL4wW6XIKH4R6SbIXWfM1a0kz5SZ6mYCmjXwmEr/TOg?=
 =?us-ascii?Q?WP5BFo/7OHvsvqrLaDgUgyxZkXV+NOpqP0jVkG2DYwCfuFwX1JXX/ic08Gmt?=
 =?us-ascii?Q?fiLVALodcPsmDHM+juB611358V/a0eOgvLM/tJTRBBceyoh3kjizF4CMu3dc?=
 =?us-ascii?Q?8ZeqavrMsvcJKAyQxJsSV/P/2wkKOTcAX3Qu0CqLUbNvRetywfddxXp8FiQv?=
 =?us-ascii?Q?oBa+xKNukCHx5ZuwBeyPKPykEQihiHUwNvCn+ELLnKyuWrB2p/kicTmEHXJH?=
 =?us-ascii?Q?CUMnpgotglyDOH3W3jsIUJWNB912Yo4ZjXjzrs5FDa+sPQ2S1Y0G1Pcr8vUC?=
 =?us-ascii?Q?Pj0ZwY1LfYZLBa9qRAlh3bqNfri5YzW7kJQBs4c9d4sgVVRUBDthTEjwWA68?=
 =?us-ascii?Q?CRTzXTYBKu2+GuSHfj1dB6mDx9kB5Aqcedqm7Tu2mjvYhALlmAd3UjTx4eX0?=
 =?us-ascii?Q?Iz6iPIGrbQ3JkHEFOC0eb/+hZCimt17vDVzom5fsau+doUMcCQ5Q+whQ31tg?=
 =?us-ascii?Q?exnCS5lOKhiY+pq85JTjeNtfRTkaOMCmp57AgToZ+JkQX4LJk1LWMtY0Rv6L?=
 =?us-ascii?Q?Ax7wPg0H2v1RKCSnrSV8gaGpC5ErADUCKMX69Ik9lTGBi6DnSarzu9bFfRzE?=
 =?us-ascii?Q?UJ0jqYYWLEPIj189bCf0gAUtKWFevO40WB0MZF8ODiy+5jLBdzBHWAG8Zz+M?=
 =?us-ascii?Q?T9dSN5cHFrhsle9xAFhXSuEyXXQWhi3dIYe/CvG68A2XCEOwiGjuHof0Pfuv?=
 =?us-ascii?Q?I0sPzhQLRZmi6l+ZCiLvTAv1sewWitKzFZNvzI8ewSmEH6qC2YNUfL/53q5Q?=
 =?us-ascii?Q?ND7kdHFzzIPeiN/ruB+doe9daENSSR8fY3po5rXml6iuty7xBQ8XLRUen6Tz?=
 =?us-ascii?Q?ybvjVJu8orOMdn22RWDeGXxiiNuioMwL45Q4OI9Kzb0aTHVTb/UoHdXXZogH?=
 =?us-ascii?Q?3N5MJL2ZUoehEVo+Rb+4aE8SVV4s0KEd7IcLEkZgJClzGHdHjIMB/plbSUFV?=
 =?us-ascii?Q?NktKA8cXebryhiaOxBVhjtWC1mHi78FphzO4WMNrNEWy+Wv+CkiuMhyVRF45?=
 =?us-ascii?Q?AQv+GO6CHDEF4SKrqG0KEO3+LDVul1O+O9JBhRQ8bfkUUjRSF8/6ktn6IFo9?=
 =?us-ascii?Q?rI1RdlYI+pTKxLRLqlD8TxuNf+JYmZvbiNvV/dMX8n0Zpp26/UhM5HxRc1m8?=
 =?us-ascii?Q?aRkosZdoNbvuReiE4SWrHI83oJApE4aTXfXuSo0mk/udjoFcNoVhPQNfSKa7?=
 =?us-ascii?Q?G4oC5cvrOg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02308fb4-a109-40bf-88a4-08df4045c9ad
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 22:47:39.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bahZ+X2CljY6W+Yav3NviGmq4WrQyicFuv35c8t2EcgUDsos4zzlDCgsNMNjkLQWbG/Jj779l9TYMBTOC5CESw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136
X-Stat-Signature: m9r7i4y4nzwm9s4kqe8r5ckhywywnb19
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC6E1160003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794437270-114096
X-HE-Meta: U2FsdGVkX1+dW4oTk7yfZAh+2M7sKPeVo6FAcOMBYJ+HeTYOQiSE6HeV6xiSIIr98bQFzdT68TiwyvTDrnE+4fYgCBoGxBBHhlWMUZYxWp0pwXj9Pr+cUxA0XXl0SpjgILYh03rf23ovzgD/jsCer6xVOzxfxS2BAVKH78TtaPWBieA31hZmgukbprjzcFh9foDPU3ljB1aLhiubc0x2TMO0tCghqlyNvz6zXipr6BJyz2peg0BdYCfmZ1yJ4zNrk8pKaU6bdLja+YBK+drJ/e9ZgriLLoL+iJjYq4v48FgpydUBfzNXzBDgyssJkKZflZPVgJANgsHTrUK6Rm4LOoWoERRihP9UImNFDZWQeYr4m9HarOngfvqFX+xDh/5jSwlaCfjEbN161roHP6gwVfo66QPv9r0e4H/Go3IEFhfHmemVj/e8UgY/uHdMFGT/QSkksoboXZfvlvGHC0vA5NaQVi7p3qWLN4Mz/ITKe0t0BWtHtgWfAwgvJdFQKXwLjadtYNH2r2ABqDLuY3B1OiVoyUpt9e1C0+FaNzgL2QE5mGcF7cwxvlguVPyyGKkgEF9/BULRJU1SbJgZ8frvuyZqFByNejErAsWLiDhyL0QCt6TMVBJdTs1sRkM/gmjUchkALTKhS/XusMc4If17+Nx2ZV0mY4B0nrxP54llkeBb1J2m3UL5giTItj/DQ1c1MZ7UQQteHYMrxuVtbxasSENARbU54G53zTypZX9gFFVlf3M4LKl9CZxNb5AiYmpfbjpVa0KC/hlVrQK3tvlhy58wW7kNpMZpmsoKJxBnkjvTI8Gapt+Oo00eAk1JgqLJQWfV5aOVua6IJh1uFbmI4nf5qMb6wEGf1GbAdn2i0nJ4PYwebfNLj/lESWCbNFoBNMOJz6FgTGiiZrNT6i/tL/wUcqN9KniHcrrlkGOL/EPjwuGdctkCTccoqEbE7a341smzONRkcr6vCtcFGQ6
 NI3IR0sS
 HNs5NQMOULgqwcTUqlkFvom03JFIjiVFBvzh6z4mn0C4bd11B1qJU3Q8AAw1TyUGy6IPltX498sG04UNAZFjNq+AGHCpLA+zviRpT8XSdF5fKR6P6+hjW1aXAWUtVxZLa9xujJf2m5mcjyxFvtMiNp5Ob5kuboLhwEYFH9Nkkkmm9rFAUUsTs3PnucGUUZDIfTdddtYgH4RtD5OAQiXKV6XYIk/KioUNLvrYjAUCdytylmLY5fhpk7TdDBm8MUzzbsU/CQ4EnMv0SysjDSASq0n7BHV7BKgidwfvlij223msWJin8ftPMR8VqiyQDZBxvoELhNXs9yDLq/omadIGytQP1gH1Wt+bF++x1q45rqw0JPKWQ75IBmbu7rmrNHfmS/eBI8lPqlRKVqpbkOVQDjIXSIOQYfdvjcvMRcmRh1WpX6WgFFab4ad3K9x6Tky4zAfC14evu098A7LPCrIqEHeU7XVOhVAPJKMlJeecJKqYJvvY9SPL3ObtqKH5jqAJTfZleW9uWmFXYEkopzyQNaOtGFLlRUyk0gFK/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12 at 08:54 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 11/11/26 19:13, Lorenzo Stoakes (ARM) wrote:
> > From: Chris Mason <mason@kernel.org>
> > 
> > After a KSM page is migrated to device private memory, ksmd can oops,
> > and KSM then stops until reboot. A process that maps the page can also
> > loop in page faults when it next accesses the page.
> > 
> > The problem arises because KSM doesn't know not to try to look at device
> > private memory that does not exist in the direct map.
> > 
> > Disallow this from happening by explicitly testing for this scenario in
> > __migrate_device_pages().
> > 
> > Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Chris Mason <mason@kernel.org>
> > [ ljs: tweak commit message, comment ]
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/migrate_device.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index 45e571dbfb4c..7ebd02ec303b 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -1205,6 +1205,15 @@ static void __migrate_device_pages(unsigned long *src_pfns,
> >  		}
> >  
> >  
> > +		/*
> > +		 * KSM doesn't know not to try to read device private pages, so
> > +		 * disallow the combination.
> > +		 */
> > +		if (folio_is_device_private(newfolio) && folio_test_ksm(folio)) {
> > +			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
> > +			goto next;
> 
> In general, LGTM. I was just wondering if we could reject that earlier. because
> apparently we already allocated a destination folio :)

You could do it in migrate_vma_collect_pmd(), but that would prevent migration
of KSM pages to DEVICE_COHERENT pages. DEVICE_COHERENT pages are always in the
direct map and are by definition fine to look at, so I think it's better just to
do the check here.

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> -- 
> Cheers,
> 
> David

