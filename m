Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2F3606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 04:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=L681TkNB
Received: by kanga.kvack.org (Postfix)
	id 806676B05B0; Mon,  9 Nov 2026 23:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7610D6B05B2; Mon,  9 Nov 2026 23:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601FB6B05B3; Mon,  9 Nov 2026 23:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3E46B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 23:16:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 974D2A08C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:57 +0000 (UTC)
X-FDA: 85417898874.01.8C54F50
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B21820002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=L681TkNB;
	spf=pass (imf03.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.62 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794284214;
	b=zo+4vKeHQWUrWns8fDqCJHItqsNh+BC4avjl6lUeB4RjV/R5vrUMu3JSnD/wKQWgfU8nZN
	opWnqj3wCj82EoIM7XVMMM8Aa1VDswyQxh8LhxARV20c7iEkbtlLyOqzMdNFGqiqpdWhWU
	vq9K4/kImZhzKc1BBRmtAQz2R+FjBRU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=L681TkNB;
	spf=pass (imf03.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.62 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794284214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKJ6WobrwbDkYqLAH6fb6qljWiugsDiTZ6U4AQymzpA=;
	b=McOhfhvMgrPsouHoP7zlXn3uij94GSuZnSh3ZFWu/v8bB6r2CjnaNF4PKbXVz7rF/vHMnu
	r4NQ1HC0PtHDqSHfBbZqf6pBok5/94SJHJLn5cBtPNtvSTCeucSv9+qx8FRzbP7In04Q8g
	+x5Bqgoar63ZiPDLXYyZUsduw+y8yJU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZyD89/ADt59TdKkzYpHgNY58YS6iLJ2Bs9YEs1MQTOQcyCeSk5tAHVQhw9YsiR9LwSEc+tWLSyCvGW53HOE/L571niSS2wqKqBtZruZdkcMwONq4vXi3REvcEbw3Lq9SXCUPFbgWm507apTlRO/c8AFr06S0DrXg0doXTuteyB+zweAsc8U1NK1YABCCbZuc+XCo+b/l973LjD6BwE0dCNYVLobe4PpMvxTL+rqQDFHcwPBPoXTTlANlOITZaYWbHXlS168nxw1WbQMUKvoDeXdb/Rhrs0nuoN2eFHl2Tjh/GbV3aLOb0N0fomyLQc6SZ/Qj8LzuM7kh/1sHqkYVbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKJ6WobrwbDkYqLAH6fb6qljWiugsDiTZ6U4AQymzpA=;
 b=ESqPy2FD0K6BqYErmiXqSeLQIc0cJp5fWZNFbdB5ifAOihgNgVixOk6D4pr6DUdP/ULojvAGa4eWGIBK55dBquL6s1frJTyGb2xirll93WsjUomoNiFO/HDWQHyTrOMcYXf6ohJ1mZgLFk6GZX9Ub+nLHZBY7HGWSbmaVtt/8PQRWacIy2dIVpicQF3G9KMn6FnzPUAcjiDwv9XjM2g49PeSITduF5A+ioh7b3XVw6/YjaiL1PNM+mDiBL4jJWfWS/Rp8c89gyVFrLLyYN+4HBYCh3HBDMswsf3cFQYTqmyib9sJYSEMs9rJCNaKIKgvqrNCdwVsiWzad55Jo7+ITw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKJ6WobrwbDkYqLAH6fb6qljWiugsDiTZ6U4AQymzpA=;
 b=L681TkNB7DInJOgulGKcB+qw9d/MHcjqMHTBK+OjpT8kf/7P7tIeT0csY8k0rFGffwuHQrLru5aldpZPeyI2QDTPEi5bFrpojKY2QNhjj3Z4kG3UTmujaroIKW5fZs8mYAC1OuMGDgp15U2eeCf/XsFcbbnyy5phD0s4YPJ56tM=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS6PR12MB460083.namprd12.prod.outlook.com (2603:10b6:8:4d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 04:16:51 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0592.007; Tue, 10 Nov 2026
 04:16:50 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "pfalcato@suse.de" <pfalcato@suse.de>, "david@kernel.org"
	<david@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>, "surenb@google.com"
	<surenb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>, "ljs@kernel.org"
	<ljs@kernel.org>, "liam@infradead.org" <liam@infradead.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"Nayak, K Prateek" <KPrateek.Nayak@amd.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Thread-Topic: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Thread-Index: AQHdcH7OSO+J2tGPsk6kyOa+UPv/DbcmSl4AgABpQIA=
Date: Tue, 10 Nov 2026 04:16:50 +0000
Message-ID: <420c59779498e976307ce4591347cd75706a9964.camel@amd.com>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
	 <b47cc8f4-3f8a-4893-8a2a-f88dd5ab762d@kernel.org>
In-Reply-To: <b47cc8f4-3f8a-4893-8a2a-f88dd5ab762d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS6PR12MB460083:EE_
x-ms-office365-filtering-correlation-id: ffab0997-467b-4df2-231e-08df3ee171dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|22082099003|18002099003|10067099003|921020|38070700021|5023799004|11063799006|4143699003|261102123227099003|261026121527099003|261028144727099003|261022105027099003|261009223027099003|261021121427099003|261021123027099003|56012099006|261026140227099003;
x-microsoft-antispam-message-info:
 mYa/qUqdh7OEfz99LI3iq5IHVZkv4eH2oeON5ST0M6srKY1ZosHChpudY9484MnSmZO9TYOnX3QU0PExgXmyePf29uKno6wf6sg1Zy3RLyiaYLhqRa/e1vI4alOknuahqAOj+x1nd7j8xKjTayCiiJ5XADSPq5ffJiVVfwrf3evBsENsuBwcEERtF0XyYjkcF/JM7ZQEDlAokPihkreb+uRR94M/rTlbgD7wCfpEh84RDyKBgoX2iK7P8K6Jvz9T490pFCVjPpmOFflzvS8M8Iwf+beFeTKoW5/gnoNV9LhSI2YfqF4EtOgcLxRc8ZjuaIaeC1Uo73lSkod4efhxv7qRuEKO31wVJRkFZv5/Els6VFUWzng1lgWJbKcRjoOKifxJoQ3scdC+RnDRnHx+9RWboJZQsMWn5zagrYjxhhyVWeu61+nBUtVHh6eepjRL0FH9fmbwLth7Da2j+fsa29Gy3RdYH9MZeAYPi5UN3N6elrHYLLzpwdyxvLOzVVS0zDVSxFV0s021qnPzaJaPiC3Yag+68ynKb1ifg9dWTj+V1qa0VKU1G2F1/XopAnFB+QIwokSqthe0ZJIv4cQ6gYK4SK3vD3vst2jCsK6Q63Vs4pKCUpPV05uJDv9ClGDTLw7XGkM+/BYN72W2G+Bpwzryx6lYm6++/xZI+N8KHsgZEZVmTPYh/GPGLcbaIvn7
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(10067099003)(921020)(38070700021)(5023799004)(11063799006)(4143699003)(261102123227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261009223027099003)(261021121427099003)(261021123027099003)(56012099006)(261026140227099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RWt3RHQvUDRGM3J5UWYrbjNzK0JYWDJIOUw1RjN0Q3I2aTZaS25xdDlXUzdu?=
 =?utf-8?B?RW9mVnBmOGFQdUo1T0lQbDAzU2ZsZlJRSUszdnJSYmFUcjk2OG5DVFpjKzFa?=
 =?utf-8?B?MnRTUHhTMXhMU01GZHpId0JWMEdEQnlQNzVsNnNoUWQwVTJHUk1zNSt4Wk1o?=
 =?utf-8?B?OHNBVFBjMXJiZGVaVGxaNjZlcndlNHFpV2tEZEl1eGkwTUlpdTFrRGF3NUpT?=
 =?utf-8?B?Vk9HV01DZ3dUbERLR0RSMWJkVVNWUGhPSDVDM1grYnRERHhsSTlaMFlIdk1B?=
 =?utf-8?B?d1p3UTkyTkRtRitBUEpOSG9oU2laS0NxcFVBL2Q2UUZRMHZ3c3BDMm5MUlcz?=
 =?utf-8?B?SnVWRkc0S0tncGRkZEtJVDU4RXBybkNlcXFNZVp5QzJDOWN4dmYrS2ZCeXNF?=
 =?utf-8?B?VTdVSWRTcHM2U29tTGZYaTA0V2xBSWZJYXBnV3lzWlAwU0hJMjZwNVAvYmF1?=
 =?utf-8?B?RDVySElaOGNGVjRkNlloV2h6NVhxZzE2S0gxdU1MeFNJa1ZBcDJ6Y0tLOU1I?=
 =?utf-8?B?VUpNQ0RQZTgxdlJsdjE4aXBvTkVzdkNXaEhpa3hDL09qd1RlSThoYnB5VEhl?=
 =?utf-8?B?NGZVNnhqTElqU0JnbDNuZVBKMTVqcG1VM0ZLbmJHZ1RHTXdyZGF0d21DZzl3?=
 =?utf-8?B?OXpmQUVSNTFxREY3U0VTZUMwdVpUR2MxT0xkUHJJNzFYV3VvUHpPaVVpeXNv?=
 =?utf-8?B?VFA4VnJzSEVNdCtONmJ2UHUrMkpQQzJMNjUxR3IrMUp4ZlBGQ0lmWkhTdlF5?=
 =?utf-8?B?MTk0SGozRGk4cEpuVXMxNW9BOGFDSWRQWW1QLzBXMlZUYWZ2MVEvMG42SmtL?=
 =?utf-8?B?NmRiaDNtWEh5RXcxUUVkWTV4WkFrUCtVWTcybUE3MzVLcmg3ZHpLaFl2VTdZ?=
 =?utf-8?B?bUlBeEJ3WmxXWFEyQk1UZ1hZQWNyMXZvQ3pnSEVyK290dXhnNXZrejFwcnNW?=
 =?utf-8?B?TEc3RXN1QTMrNmoxakdrcjB6UDdqblgwU0MvbGViOTgvQkxIRmR6aFdkMko4?=
 =?utf-8?B?T2JHMldzR1dDUUpEQ0xrYkVZK0Y4UllVN2tWUVlyTVpWdmtFRkkvTzdHamtn?=
 =?utf-8?B?aDF6aUhaR29ORVpYbWFJVDMvTExSWVhBVGwySmhQbkNWdVlhZXY5SSs3Rm92?=
 =?utf-8?B?QnRldlltLzNnN0RZdDgvaUdWdWc3elRZbW5nNUY1c2NzQmlSOE9xSlFHRDBF?=
 =?utf-8?B?TjJicTRNNlM4SU1RaWdKc080TmovTXU5RUZnMVRFdmpSblZqT2lLdW9XWlox?=
 =?utf-8?B?N2loWndmYVEwd2czeGxYVmZzM2FRZlVqVE5zL1ZibzZMY0Y0ZVNDRTlOMU9M?=
 =?utf-8?B?YmlVemgzYU1BWUVycXZIWFdxV2tZYmpCQnRmbkpvU3JGRnhOdzlGbXVVU2FT?=
 =?utf-8?B?QXJlY2ZIMktJcE11eG13ZE1PdUlwbVRKUVlhbDZrWTVnVXA4RGZ4eVh5RGph?=
 =?utf-8?B?dzZNVlI0VVVvY3NKSXhnK1MyOEdBK0NRUUJiWGMvQnVnckl0M2JUbFh0bkcr?=
 =?utf-8?B?TmRvckd2NFRZZjZ3ZW1yYnp6cUk4NXV1YUNDcFZ5SWpUanJ6UGdMeWQ1Zm53?=
 =?utf-8?B?b0pJU29LNHpKMDFWbW5FeUE0eWpjbFdlQlVaL2hjckJVSjhFM09BZkZickth?=
 =?utf-8?B?V3FKaFZDWWVyeFI2b2VxN1RmYmRpOU5rcE8zNTJ4T05lZVZUeERrdVRyZmJl?=
 =?utf-8?B?WkJVMkdwWWJqRnV6VWFtQ0EySTlPNjJpckEvUFVJV01penBZaEpWTGE1YVNv?=
 =?utf-8?B?MzJFLzF6Nmg3WG1tTzUzU0FGaGVhaU9JNUJRSmIveGxvWk80Z3lMci9rQmVV?=
 =?utf-8?B?NUdFdTY4dlNwdVJOWDZHY2F2N1F2T056aEVkMDNlMEJKWHdzazZ1OWZUSTM1?=
 =?utf-8?B?cFBZNUxQWjZZS3h0cjdDSGFrc1N2UlB5RHdLRnRNWUxtT1dHWGE5NU45QTNj?=
 =?utf-8?B?OEVhd2tHK09nRzFBcmlxQ2hBQjd3cG1MYjMybUV3N1V2bHlETlFhS1gvSU96?=
 =?utf-8?B?bzVWN25yTDNaY0h0RjE5Vjdrb2Q2cFlTTTVLcFRSK2ZDZUxYcmlwYk9nY1ZW?=
 =?utf-8?B?dS90VWgzZDk3RHpBYnU1VkgyRjRNUmVvYlc2QkRUU0VYdVhNNDhBUWlVc2Fs?=
 =?utf-8?B?RFJlYjBNMU5lWmdVajNkUXJaOTRGLzIrMzdHTEZMQmF4dFdHUWxNYzVjWHlr?=
 =?utf-8?B?ZEw4SGR3dkQwcERDbGU2QlVieXlaWmRWWnZnQWZCMTg0aE0xWThaUUwvMHp5?=
 =?utf-8?B?SXVqbTB1b2dRUG9uYkdrdWFTbFJod2paYkJKYmtMd2lrbjF0V0pVLzZRbnlj?=
 =?utf-8?B?bnI2ZW1Nc21WektQd3Z0NkFpZkw2Q1NNV2dpcXAyK3IwY1k3RlRpZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5ED6B53DF06D7746A8EC2B09D6593DB7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffab0997-467b-4df2-231e-08df3ee171dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 04:16:50.8758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PCBIuBTTcisVQj8hJmVLEcnEOFQGnInPj3zudUV4jTyKaWxng9M3g8cnhXXsMBH9O7If4duL+W94b4kEtugPLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB460083
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B21820002
X-Stat-Signature: hzc7tccmj97dte6ytp7spkofz4j8md76
X-Rspam-User: 
X-HE-Tag: 1794284214-295097
X-HE-Meta: U2FsdGVkX18I9/kfdK0DCB9mWjke4zY7pb0ejFZkhUD4b3a4GzBvMzmDCvCalf31/q1Bxr+wT+oB4rXwE6OfLJ1OXoKf3uDeP2cCrtiy/EBRd6RwSwtHny8AHoMGHWh3AnY4JSSYTZRq49C+BkRSODE3KonvZg9WklLkXG8LGnDrwNg3lYstIvN3JWA1qwucYpqHLFKaqG2KB2f1JDRXY9yP1mvttsmysezOk9cS36U3LcSmjtxCjQUlmsnpZogkg9gnpZzhvA87LhogQbLgFmpxs7FCD0kU4y4jhNno97d6sWxiSW6OkzWkJYFGGMvCo+ZstMqOg6dsRd6TQm0nDxshXA+uW/rz2hkBHnYjnIvXl7HYnDbYSf3+kZnjT/zJosdAoDMqbN715wt/lt/aauSfXEhJcP7Cf6lrl0+23imcq8MsC1tRd490YLp5Qsl9PSqEGCEfPPQeQyUWrnwl0kKK8hOq7TftGFMhyUMc0Mfm2lRpu+6DM3HZT0wixrQUFZjs4ehuk+rOxb++eEHfSoagVRHTi6ccpVZhzCr81thbJFolZDFhQM2QWr1LspFrLL6GkUzUvheII1EQi8unns4Yjyhw1zmfJdTe+YtdhN1rHpxK/UKTb/Ww4/h6urvGy8aPhisgfoPG0FZQs3TC43VLiNVy/fQ9COpEqD9vzUE6APMflbUNN97YR7DBKKgRNlHbcPX4KuhLGW5HY/FrxNP1VlySUHhUJqGr9aU9k2rLoKkLwta/D9txEolR6851nXEQknHvP4q5kmvrLvt9AtqxHj4whoD+PWEBw/XPASCp0nhvfXH8UAh1qGfxWsu4nxgJHfs343MEkfG+5msGSqgqyV2/rppg6msFIS6L/xfTFp0ifI8Rk6CTKVFItKzrxDwsFfxXq30Odb/sD6rCfq6npEc+Y2IYxCUBq3y5nh4Rya4eoMt51Zc3mlVvPRV2/zbUmhNl4Bi7V2nv2sI
 gbnDpnVG
 Yicjq5FFPeE3bdMQ3z/JUytUWb5rEpd/lYRp7qhXQEoi1PqhWzGf1U82ThnCHhjCMs+kqnhVv7+LV8zB1iV6ZYtLUEWAr/mugp2/VRYi4fN9gGdO+hhOzavs1A9c4U6YWJNOcNexsdJtna/bd0owShO4ks5N4XIcFH5xBJmVWZMdnaGqKU6YffVHFICck4Z27mzsx8ivcgYmAB7wCTQBIRvbHBNXarAu2T2HSnWwQHFv6nbob7kRy6KzZK0grMa7BtFVh+T1Y1XRu0/YKPtkSFd444+hpz/RwoRlsJd/cMH1t1kDIvQ2aP61RuNRAvp84ixL9xD1UMOH/JG1N1hHv1jDEkBYL1m0Q9NrV8VV49GPbFysKaEbMoKfJmdtsxmsmwJC9cEtjYgHRuEPYzklYCJaG82Xelq3m6JXDKq45edcbVeuUGHsoUvuej6TtJZLgjjKjK8sMJymdEdbPgvt6Y6eRC6ttMblJzU9DNfP7L8KW5WiOB6QcvWPlKoogc14VUqvsJlieolf54rXHeQn3kATXmQMCwQdCe6sR/GcC/jGKZs/m2qp8Wy+5643IF97y7LUoIIeDH7ZnD4Xmhm28/4dV/8h9V+gyotCEo2aXsHa8eLCfgxYlaIbIhnR/ZApLpz0Kgp6tDszS9X0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTA5IGF0IDIzOjAwICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gMTEvOS8yNiAyMDoxNSwgU2hpdmFuayBHYXJnIHdyb3RlOg0KPiA+IGNs
ZWFyX2NvbnRpZ19oaWdocGFnZXMoKSBjbGVhcnMgdGhlIHdob2xlIHJhbmdlIGF0IG9uY2UgdW5k
ZXINCj4gPiBwcmVlbXB0aWJsZSBtb2RlbHMuIE90aGVyd2lzZSBpdCBjbGVhcnMgUFJPQ0VTU19Q
QUdFU19OT05fUFJFRU1QVF9CQVRDSA0KPiA+IHBhZ2VzIGF0IGEgdGltZSwgd2l0aCBhIGNvbmRf
cmVzY2hlZCgpIGluIGJldHdlZW4uIFRoZSBiYXRjaCBpcyAzMk1CIGlmDQo+ID4gdGhlIGFyY2hp
dGVjdHVyZSBkZWZpbmVzIGNsZWFyX3BhZ2VzKCksIGFuZCBvbmUgcGFnZSBvdGhlcndpc2UuDQo+
ID4gDQo+ID4gU2luY2UgY29tbWl0IDdkYWRlYWE2ZTg1MSAoInNjaGVkOiBGdXJ0aGVyIHJlc3Ry
aWN0IHRoZSBwcmVlbXB0aW9uDQo+ID4gbW9kZXMiKSwgYXJjaGl0ZWN0dXJlcyB0aGF0IHN1cHBv
cnQgbGF6eSBwcmVlbXB0aW9uIG9ubHkgb2ZmZXIgdGhlDQo+ID4gZnVsbCwgbGF6eSBhbmQgUlQg
cHJlZW1wdGlvbiBtb2RlbHMsIGFsc28gd2l0aCBQUkVFTVBUX0RZTkFNSUMuIHg4NiBpcw0KPiA+
IG9uZSBvZiB0aGVtLCBhbmQgaXQgaXMgdGhlIG9ubHkgYXJjaGl0ZWN0dXJlIHRoYXQgZGVmaW5l
cw0KPiA+IGNsZWFyX3BhZ2VzKCkuIFNvIHRoZSAzMk1CIGJhdGNoIGlzIG5ldmVyIHVzZWQ6IHdo
ZW5ldmVyDQo+ID4gY2xlYXJfY29udGlnX2hpZ2hwYWdlcygpIHJ1bnMgdW5kZXIgYSBjb29wZXJh
dGl2ZSBtb2RlbCwgdGhlIGJhdGNoIGlzDQo+ID4gb25lIHBhZ2UuDQo+ID4gDQo+ID4gTWFrZSB0
aGF0IGV4cGxpY2l0LiBDbGVhciB0aGUgd2hvbGUgcmFuZ2Ugd2hlbiBDT05GSUdfUFJFRU1QVElP
TiBpcw0KPiA+IHNldCwgYW5kIG9uZSBwYWdlIGF0IGEgdGltZSB3aXRoIGNvbmRfcmVzY2hlZCgp
IGluIGJldHdlZW4gb3RoZXJ3aXNlLg0KPiA+IERyb3AgUFJPQ0VTU19QQUdFU19OT05fUFJFRU1Q
VF9CQVRDSCwgd2hpY2ggaGFzIG5vIG90aGVyIHVzZXJzLg0KPiA+IA0KPiA+IFBSRUVNUFRfRFlO
QU1JQyBrZXJuZWxzIGFsc28gaGF2ZSBDT05GSUdfUFJFRU1QVElPTiBzZXQsIGFuZA0KPiA+IGNv
bmRfcmVzY2hlZCgpIGRvZXMgbm90aGluZyBvbiBhbnkgb2YgdGhlc2Uga2VybmVscy4gU28gYSBi
dWlsZC10aW1lDQo+ID4gQ09ORklHX1BSRUVNUFRJT04gY2hlY2sgaXMgZW5vdWdoLCBhbmQgcHJl
ZW1wdF9tb2RlbF9wcmVlbXB0aWJsZSgpIGlzDQo+ID4gbm90IG5lZWRlZC4NCj4gPiANCj4gPiBO
byBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gPiANCj4gPiBTdWdnZXN0ZWQtYnk6IERh
dmlkIEhpbGRlbmJyYW5kIDxkYXZpZEBrZXJuZWwub3JnPg0KPiA+IFJldmlld2VkLWJ5OiBQZWRy
byBGYWxjYXRvIDxwZmFsY2F0b0BzdXNlLmRlPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNoaXZhbmsg
R2FyZyA8c2hpdmFua2dAYW1kLmNvbT4NCj4gPiAtLS0NCj4gPiANCj4gDQo+IFRoYW5rcywgSSds
bCB3YWl0IGEgYml0IGZvciBtb3JlIHJldmlldyBiZWZvcmUgYXBwbHlpbmcuDQo+IA0KPiBSZXZp
ZXdlZC1ieTogRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkgPGRhdmlkQGtlcm5lbC5vcmc+DQoNCg0K
VGhhbmtzLCBEYXZpZCwgZm9yIHRoZSByZXZpZXcuDQoNCk9uY2UgdGhpcyBpcyBmaW5hbCwgSSds
bCB3b3JrIG9uIHRoZSBuZXh0IHZlcnNpb24gb2YgdGhlIGJhdGNoIGNvcHkNCmluIGZvbGlvX21j
X2NvcHkoKSBbMV0uIDopDQoNClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8y
MDI2MTAxOS1iYXRwYWdlY29weS12Mi0xLWQ3NWU3ZDBkZmFhZUBhbWQuY29tLw0KDQpSZWdhcmRz
LA0KU2hpdmFuaw0K

