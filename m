Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04AC606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Kwk7Cczj
Received: by kanga.kvack.org (Postfix)
	id ED8C56B05B1; Wed, 11 Nov 2026 14:07:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0CB6B05B2; Wed, 11 Nov 2026 14:07:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F0B6B05B9; Wed, 11 Nov 2026 14:07:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7B366B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41DCDC03FB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:07:13 +0000 (UTC)
X-FDA: 85423771146.29.8E86130
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1DF01C0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:07:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Kwk7Cczj;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794424030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QF8db7W+YbYRqJNdGVnAyMFZ98YJHwuO7grixfymQkY=;
	b=xdDuzlQRj4eYilo8EvHhXQ3me/51Wdgs9sqZgaK40AZaE+p4oRuAOZYZGmU/zl3qrvIHiq
	pkxw3VWyqq7ll+N3OuUWTr6c6UuiEP7FksCQuQ1pCGfMSGDvmlWX9Tv6NxZySqqEIUZyHz
	GF4xLPzP1Gl1zaejatskvRmsTmqnARQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794424030;
	b=ZyYnSxHPTgJ484PAsFz/mIJS00c93rkg3f0W1+zpSOIAMtZKA6hm6Ggaj7WnlONYykTAB1
	K6GUWoIYqvJo1GN3ydShPJIiwk41Zk4Wv+HaW9EkrS5IJfm8xxCh3SH9b1XsC4fcvz3Pid
	WDcamvzpwXx2r6vST27VEcBOi2WRMTI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Kwk7Cczj;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M89n42IqPjtws0EMpBWpT3Ug+LAY0tgtjx+dtwXCYRu16VL6Xf/MW6rxEeotzurff24lCywq0dAmCJn2eP3wd6koBDMEnuqYF++CY/J+yiDcU0zFy6GhBWIPeaIEJQGflO0As3It0XdLdX9bYCmauQUhNbW8LI5kikIMcq3Bo4y4gzEhg4OZzm3PVyIS1YkYhAS5rqhag3eSZ3ni5QRaz6n75JPtGWZg7ZZeIFcBNSni+Fx/bpx2pn16t+DpKVY8e0krvwJuukkbG5ML8RHXTDi9TwuHqh/TRAfMVLwZ3MwrA4N0M2CHPK+WqAyYcnMkBgSKGErPLvgtn7NVffbUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QF8db7W+YbYRqJNdGVnAyMFZ98YJHwuO7grixfymQkY=;
 b=YQTwJsrvoC+AnuFJGpiT55q8xiBLyV/dxiLdzDtBhcMxzST516WuSkObdr1AwKOFX6K0LH3ADvDy0lPqFDmQMivEzVDmXLlH06FbTs8fb9Wq1L8R591xx+frLamGC8TNxLvSJrQLw2f5zH8/w+eBPpGf6jbMziNKdZ1wRSPCI2MFUuUVX264hfJhf65EgHRsKCXF8uEaS+aQUkxWqYwBed9PEDmO7u0oYqgXUpC3+kcD+s7KIf/+kTrqJUfCBTop4kTXx91nV3fnKaA5tFwfLw2DiiSdt08RJxDC0MwikGcGtE6qYPp2gx5NhKS98dY40RGeTWO0y0JZRUJsuZ12sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QF8db7W+YbYRqJNdGVnAyMFZ98YJHwuO7grixfymQkY=;
 b=Kwk7CczjtqDfgrlH9SxtERR+SDOA0gMd12TkyeGkrA7RMUqsAO0BaL+Kw5tbgB1C0yH43fryjL6phyXpk1S5aYzs3unq9qAL90EV/uCowyRLNAPUbFo3SWOviJMS5Hjzbbj8pP52c1hxjHopFlKKvYRHwzLUVArpVn2Yb69aisU=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PH7PR12MB7818.namprd12.prod.outlook.com (2603:10b6:510:269::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 19:07:01 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0592.007; Wed, 11 Nov 2026
 19:07:01 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "peterz@infradead.org" <peterz@infradead.org>, "ljs@kernel.org"
	<ljs@kernel.org>
CC: "Rao, Bharata Bhasker" <bharata@amd.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "david@kernel.org"
	<david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"surenb@google.com" <surenb@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
	"liam@infradead.org" <liam@infradead.org>, "mhocko@suse.com"
	<mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>, "Nayak, K Prateek"
	<KPrateek.Nayak@amd.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Thread-Topic: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Thread-Index: AQHdcH7OSO+J2tGPsk6kyOa+UPv/Dbco0pEAgAAI8QCAAAKCgIAAYKOA
Date: Wed, 11 Nov 2026 19:07:01 +0000
Message-ID: <261ef956af0843f414b4def58b13dae003c933ac.camel@amd.com>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
	 <20261111124006.GI2668564@noisy.programming.kicks-ass.net>
	 <avRnJiDLdGcbSW5d@gremlin>
	 <20261111132105.GJ2668564@noisy.programming.kicks-ass.net>
In-Reply-To: <20261111132105.GJ2668564@noisy.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|PH7PR12MB7818:EE_
x-ms-office365-filtering-correlation-id: c790d955-06e5-40b6-5515-08df4026f757
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|10067099003|261026121527099003|56012099006|38070700021|4143699003|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 DzLa9YN6sl+wIJ0B5cwweJWELuOGh2/B8L30mwrZh64QOd28iJnr3+NKxoNISm1SYwtMzneA6diKUHrXS9OyG+NDiN8yIi5iQ6wUd7+VPYZDtsXob7JDZ63tGZmMNDcMtJ10/8UF5u4mA4gA9XkEi40Sxr8dCjMCkHiiRws8RTAw9oc4HRZeg5ME2h6hjiisYQH/7/lJVKsk0I9pjB3VEQNvw5OvktqPHTIyRG1c3cRHJIDyI9r3iBYUydGbLZ54iVs9FwSvWyE3fXw27k7a+9yDtGfjqQt7mXIz2qfd3JhvQHSKGUl319eFnUk6X22cGf4qDA5627rcbQlh/NjgRRHG5UlpPWABfxeaudfyK0UOWe4E61CiYmnW1xd6kEwZpk8TF1zQldc+a6k668z9/WW+5U7NCYCHPcTVzqDmawpmeS/W64tDukwT7ec6Cn2inZVmp0i2yuGeDzSl36XSJRnCZZ/vDIiHbNa4Mvwg7HE115i45qUL9PNioMtKI+OpApMkGf7FIufIH9ye8MMdTjRwyGHO+tsELeL96GFlS92USpdTv7Yr3znxZSW8o98WSHk2oRHvMcNZ7BmP1O+ghEIgao+JQHwKEF1+frK/MeDyqeqMY7UTP6NEl8TqgBXtbl2mk10bL0RZRKIv1UnGtaDZqIiXBsm3igM+yurIWtGIGd+7FxQ8A5dq9jJUnq5NyZP6i89mOM6ommu28NbL7D1EbZvmTFoHzSdK1T2oZQg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(10067099003)(261026121527099003)(56012099006)(38070700021)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eFQ2ZFhlMFlCVmpJRjJWMFJUMWdKQTF1SUtTTU5hZkdrSUVjaE9va2xCVlVG?=
 =?utf-8?B?NGZvTXBONThwcXgyMjVmNU1YVEw1am84cFBNaEVTY3lWTDkyeFMwb0N5Z21v?=
 =?utf-8?B?NGhMeUdBT2FCdlczZFNxL1BVa3RTUlR2VkFmUlN1aGJqalozNlVJaXhQaFR2?=
 =?utf-8?B?RDFJa2lHTExPbytVdW9zYjNXMUVIdXE5cWpGRlE1T0M0ajV2Rjc0eTJDelVt?=
 =?utf-8?B?cERJR2lIRVh0K2MyMVdhaGQ4ckZHN1c2bDBLWE9nQzR5VFVJblRjamp3U01P?=
 =?utf-8?B?QjVJRzRqQk81cW9RL0kveXNZNUx5dTc2cmlVaUpJTDJGa2JWay8xYmlvbnQw?=
 =?utf-8?B?MXd4bmswdTl5ODU5SlMxazI1a2F2MVZlc2tvR3p6WXd5c01Mc3Vidmd1S3Vk?=
 =?utf-8?B?OGtUdmxyWlZvOHF6UGFOTEViTlJCWFE5Wmord0VOM3U3d2ZYRFpRRXhZaG83?=
 =?utf-8?B?UDZPOXNMSUdNZjRKaVduZ0wzVE0ydFZLam9XT29mR2tIcEZ2OC9CSGVmWFYv?=
 =?utf-8?B?UzErN1JVU3I3aU5qNFlyaExUU3JhVnMxb2EwLy9OTXFTUFpwc1pyQThoOFBO?=
 =?utf-8?B?RW5ENVcwRDIyY0JneUQwS043Q3AraTZNNWxvdlMwK2FTRC9ac3hzOVAxOFBE?=
 =?utf-8?B?MllLejRPbDJPOG1aYzZCbUtHSGx5WlE4NytKakVhSEhXRlJDRGU4M2w1NFNr?=
 =?utf-8?B?Z0JHRHhiZTBzU2lrdDVhWkJRalFmRUE1TnZOWndSMWRGSFNqVkJQWDBPbUVX?=
 =?utf-8?B?R0J3RVE2ekJLMURPYlpTWWlPdzdpcDBhYkpJbERJVWh1OTZlbWpWVFVxbzdO?=
 =?utf-8?B?enp0MTJOUmlEZHpCS0hUZTdkMXltSE1GUTVNTDA3T2d6WTFETHVZQTBwTXNh?=
 =?utf-8?B?VXlFdFpocFFFSC91WDdRTU9XQ05HTGd1TVNxZENVdVloSnJBUGRkeSs2ZzIw?=
 =?utf-8?B?M2djT2l4UlFmdVRLREtkODg5dU1URkV0dHIyRkhVL0xSTEwrRUI3b1YwNHAz?=
 =?utf-8?B?Um9GdUJJdlZuMzVST2JERk1sMDUwME9ReVhWU1RBMEo3TWxVYlVmdExkUjBH?=
 =?utf-8?B?RElvQnlndlErK0ZtT29tdnR2MXlZRlZJWnJyRHZxaUlmWkR3N2E4RUt3blBu?=
 =?utf-8?B?RjNaRGJlVXN1VU1xb3Z2OENZdDkzV0tkc29SRUc2Vk56czRVdU9XekY5MEsx?=
 =?utf-8?B?Z1dSc1FmNm9MbzVkRW5jd1g5d1pVMTRvYVV0Vy8zSHd0ZGpPSWNRdlJWaXlo?=
 =?utf-8?B?MkJLVkcrNGRkS3ZjaHhqL3Nna1ExOVNMYURPVGNqOUowbnFQWis4aTZxQzJW?=
 =?utf-8?B?cXkycFJZWktWTmRobzFENkhwRlN0bC9XZjBNeW5tam50eHpBYTVFaldaaXRp?=
 =?utf-8?B?SFJoVUZIWkUycHE3RTQ0eDRRajlCOXEyMWcyZ3pNR3EyUUdWcXh3YlM2b2JR?=
 =?utf-8?B?NVFBcC9TTkViUFpHZjZ1VWMvMFR0TkRPeGZDS2pyUGNlYVBBRllCd2RhTWJu?=
 =?utf-8?B?RFIyYzErTFVFbkdrV0JPNG9HSEF5b0tDazhWcWlyNnFEcEMvZjJkc3lKQTFG?=
 =?utf-8?B?eXRhZFRUV25XWjFXM0dia3MzRXFQM0M2bXVGT1Z1Y0RWcDQ0SUoxVm9xL1hS?=
 =?utf-8?B?TVgyMkVocDVDak5jTjlPbEhybzQxb3p6UzJqL1Eyb0RPL2JaZndOYjhSSXZu?=
 =?utf-8?B?cy80Vm9IUWZ0TWFERUdGOTRiV0ZYSEtXZjBvUVpTZXdWMklEOVJQNjBSOGJD?=
 =?utf-8?B?UzlHQmxpeWJJaWFGWmJxZ0JCWU9sNUJjL05HQXlOejJFSk5vVXdvRGwyU0pQ?=
 =?utf-8?B?enhuV3oxUk00dVQ3aW1SR2ZCMG9vc2c1SUFtSGtrZ1pSdmh0S0g5QktIMWoy?=
 =?utf-8?B?SERvb2liS3JMVklqMFArN1VzTnlOZC9hTTBPTGZ3My8waXRqZStKYjlsL2F5?=
 =?utf-8?B?ekdZWXNZS0diQ1d2b2NSRDBKYnVCbVdYZUZFTnBtWCs2NmlNQUVoaGY0TEJH?=
 =?utf-8?B?TERaWGQ4V2toeGxXWTc0V3VZb1c0TUZ0UWlyNis4YkM3NHY0QVZ2YTgydEhS?=
 =?utf-8?B?NitIL1dLQWQrNzRSSkp3UUw4KzhOS3J5Tmp3ZDNERXV3MjJzOUJKRnAzb05x?=
 =?utf-8?B?b0RXUkFtK0paMGs1eEt6Uy9HTEVEUlhQdjRLMWJwcVYwNmZUUVRTSjlNY1My?=
 =?utf-8?B?SENLbkdBNW8wM25Wa29JYS9iLzQyNGNReExIOWtJQnZ0ZFdicHcrbytpKzZC?=
 =?utf-8?B?NTRORE5wNHdZSXpKdFplSEpaR3VLT1pBOTJ6L3FIblNxa0JleU85MldzblFs?=
 =?utf-8?B?ekNJcENwMVNseE9Ma1pRbndwbFZwUjF2WmhiTDNrcFZPbHd3RFJoUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BD8ECC47D54EE46A90F4EBA58D4209D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c790d955-06e5-40b6-5515-08df4026f757
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2026 19:07:01.2357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /EIvcjcGN3rO8yLDR8ZcUCFBG8jLGP4dhsyMnYytTwx46awjGoQCJybWmEBvxHeJiW5ms9x8Eod+SLqV3z/ufQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7818
X-Rspamd-Server: rspam06
X-Stat-Signature: 64n19o98ioeii5ajnf9gonmwwxmsadfb
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1DF01C0008
X-Rspam-User: 
X-HE-Tag: 1794424030-556896
X-HE-Meta: U2FsdGVkX195jWLcAWFxWV2HJagUSQkQPacZieUZFssjlvgdKCw8PAuTghATS8pzKaOEXCWrYXRUDzt3q6h7W8X1PCgHN0HVGRKD/xMQ3WG4WrlV0VJXWKc2k1AZtITwhymRZ/rhXntQqt4pq/aCQmPk2wGrly7URzDvJqpD7kp+QoEYX7e5f0eCrtpccssopmgUHBpSE7neAsskdXOcpK25pLJCPKh6NxUeg/Zk7RiXB6QRnJjVDT6Nb3O8N3i+GkQgKwNz90M1byTCXzTdQ1CX6P9udfxuLMfZ2tN5HT5zdNPYBFeHJtQUxCG43b5BY+546NZyDBkLOr9/wwrvAzy2w4Ocqe11HsRSNAjXV7chLke6T+XPAnpuisDBogWKlkKk84h8am0bcoQTsFJcmX1ZndIDaJ+r8t6+4j6ilQ8zQx9VPF/YV8xNsrQG4T5Oq+0jkzXoYV9McJOmbud0ATqEtefIbbJwUf7U333isg8mdwMM55cl2bBeP144gGxXaVFIsRiUFaUL/ejc98GTjQqgihf8Rsv0NJ7cslW5YXw9d3BzoGx92g9koSNzFukSRA73vY4TGLLmw9yFGuPw4hhDxjcH7tdU8Poz4kpGmuD0XR0pLfsasL9z+Nk7pMmxZ651NXZ8AH8oYDHlam3mDeSXGhNAFfc31lfBtzOn48cYnmNGnAPj5tCqZCLuoCvU107Rm8ngeyu7CkBn9zT0to0Ckn3p4DlsRvaFMXl4IqCIdSurL2vslBtZJnaI8eGmQQdNva5/7wpqi0fm45jultmmwOzTPF72Nc5MfSiYujac+umfv+6TBzhXzdyFBX7zkNskAe5mniT7Fdl7+0VAPEpUPb2ugbrnOeSAOafBcMV6jsWbvpLgWAOd7SYLvlrDqKdcGnPNYoe8FxZzvuBXxlkJpGSl5kTXLYm+MgWBj7dWTALl5LrfwzVae224M7aioUuIp6fh/lypPRLKlbA
 L7v5lmUv
 wzNGduGKJ/vNQ0ez8Ei/xQ7NV5vUbRTjs8Bcq4ektyhk/V3PfpSVwDaaFJArbiQNO/kMqREdw9S7+cxg1ncu0BFkpFnYEg9/GEGF+GW7RszsEbOVMp8Kq186N73IZ5IGUYzdwXSGFb3HlRiFhrY6cddIyz9we1scFYZso8JeWCgCCzuqawG+k2FYB3hiRlVWTxfjet3Oq7JI2clEFGByH9eXVPdwsBxOBnVja2Go4NB7PgEaLZnfbth6I/quYYHFeJWilXASEzmaTqWr8P8oWJmngpJmjpe2WFPOIU340lHKcqyihSh1UOSfueXu64RzcHT9QH5XPUb6ptwRueKgg9VmSQppobEda+jdvNtYKSEQvQYqLDqCfA1CFAHm6HmrmdvXw1Vl9Q4g7Dt1BlMQncIxgJuw4i/p4ZoX8Xouo6gF+Nsd68vJr0dAFGWi2kn+veMHkXoeeMSGjof4nz/sWxEjrTb6QtQ8LulnSByBqh40GNKk4WdwO8++4yNRmz+v83OYK7upkUE0IlvgZ993INtcWf+G6JwZbMbgBg3oyDLRoW3FzFLNy20mg4IoQS2CZx+mxLcDPHznRfPs21jLbXt0Ryv+phaYyOBaK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gV2VkLCAyMDI2LTExLTExIGF0IDE0OjIxICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBOb3YgMTEsIDIwMjYgYXQgMDE6MTI6MDZQTSArMDAwMCwgTG9yZW56byBTdG9h
a2VzIChBUk0pIHdyb3RlOg0KPiA+IE9uIFdlZCwgTm92IDExLCAyMDI2IGF0IDAxOjQwOjA2UE0g
KzAxMDAsIFBldGVyIFppamxzdHJhIHdyb3RlOg0KPiA+ID4gRldJVyBvbmUgY291bGQgZG86DQo+
ID4gPiANCj4gPiA+IAlmb3IgKGludCBpID0gMDsgaSA8IG5yX3BhZ2VzOyBpKyspIHsNCj4gPiA+
IA0KPiA+ID4gYW5kIGZvcmdvIHRoZSBlYXJsaWVyIHZhcmlhYmxlIGRlY2xhcmF0aW9uLg0KPiA+
IA0KPiA+IEkgZ3Vlc3Mgd2UgYWxsIGdvdCB1c2VkIHRvIHRoZSBleGlzdGluZyBwYXR0ZXJucyBh
bmQgSSBmb3Igb25lIG9ubHkNCj4gPiByZWNlbnRseSBmb3VuZCBvdXQgKGRvaCkgdGhhdCB0aGlz
IHdhcyBsZWdhbCBpbiBrZXJuZWwgc3R5bGUgKGJlY2F1c2UgSSBzYXcNCj4gPiBpdCB1c2VkIGlu
IEtWTSkuLi4NCj4gDQo+IFJpZ2h0OyB3aGljaCBpcyB3aHkgSSBrZWVwIHJlbWluZGluZyBwZW9w
bGUgdGhpcyBpcyBub3cgJ2xlZ2FsJyA6LSkNCg0KDQpUaGFuayB5b3UsIFBldGVyLg0KR29vZCB0
byBrbm93IHRoaXMgYW5kIEknbGwga2VlcCBpbiBtaW5kIGZvciBuZXh0IHRpbWUuDQoNCmJ0dyB0
aGUgcGF0Y2ggaXMgYWxyZWFkeSBpbiBtbS9jb3JlLmdpdC4gSSBkb24ndCBoYXZlIGEgc3Ryb25n
DQpvcGluaW9uIG9uIHRoaXMsIGJ1dCBJJ20gaGFwcHkgdG8gc2VuZCBhIFY0IGlmIHlvdSdkIHBy
ZWZlci4NCg0KVGhhbmtzLA0KU2hpdmFuaw0K

