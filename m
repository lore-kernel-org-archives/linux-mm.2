Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44FE606C585
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54486B05BA; Wed,  4 Nov 2026 16:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E048F6B05BB; Wed,  4 Nov 2026 16:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB946B05BC; Wed,  4 Nov 2026 16:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3546B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:24:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 328198086E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:24:33 +0000 (UTC)
X-FDA: 85398715626.10.78D5BB6
Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022083.outbound.protection.outlook.com [52.101.101.83])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F956A000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:24:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.101.83 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793827470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvbyKWbvjRXfdCahcmMw/zZ48pSDnL9iKfnxz5mk/hI=;
	b=4z0vp89RRTSkQF6yhtFp9H8OwHUGJ0r0inpqBRwDqgfGVivA9qS6qSzPxl83iX6Mr46H8A
	za5PQNxb+B020mafRTP+NN394RJp3oBQP/bsuG//regEU0fic+4COfkTikppcw63bE9v7S
	5g673gtSPqYJw2oCIdiMUZJbzWaWaDU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.101.83 as permitted sender) smtp.mailfrom=atomlin@atomlin.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793827470;
	b=CWbld82ulBTQv2Dc+iMcjqYo/uXOoN1niNoAbYEvThF3mjLaF6e42BsHO8S7vso7Ch5+xz
	VG40jGswT0zPjagzUPTJAxcm5cypJkzBeWI7Tpa5q16Vm6WU9l00xMFnYFaxAodQ5T4YMR
	ojoGimy9ZCnAw/yxSOc3Ly1XcL0dZaI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6NsO0r4xCNeZX6jUviRajHvXxBhECwlo8UdIoRtyVsYaAW3/6ZTU1ytjUUjl8dtU+hRZ5ZH1GgriFwwWxAwV41mdc7rh8408segnS4icCc49CVK3q1c8RlaPdIcca8skG7kmauyrr1MbcSHSsblllJVIwhuwkQ1FqSwFLPT4Oq8IqZ54N+hp6lJ5klepcOYA0Mk4xyUqp664wmkqjwYShVd4Kc1dCaCezm4vBmdyL6Tb9EEcRPUR7qSWRG1Ni1nra7VgoO4PiYAUdhgSDOr8MVge3iCZstZ8v+jSeFGs0anZz+dLqk08VG7eOxsWGu2QrBFmLDty5hhFKGGfhfp6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ZvbyKWbvjRXfdCahcmMw/zZ48pSDnL9iKfnxz5mk/hI=;
 b=Cg6tDfhFZO6GU53VHwZmE6miLHANG+kxVHAjMmq83V0anqcR//IFLdvnmrafibIvu9qdtVPNTXUuEM5K5VDYarc+3ywyHVIpSdRDBTASygm11Z3qy6Zw4CxnihdbFpKmTSGgsnrValB6HQvuYg1IzEoRfA1HCXNHputbIQ802SHVqe7XxolAbR5wF1oS2fzBV9wLyS51H4Z/dMnZeqtKtzUaLVUU8AzFT7wqZbcGHCHmvkX8DR5Jhk4aG+C0wwWneeLeK0rLuzhOMujM0TMW6aig6cbwMDoXqnjOgYn6QD7/shmXdPc0y+kYog7j0mWi8AfFpbFcV1hh/xSWg2oleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LOYP123MB3006.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 21:24:24 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0592.009; Wed, 4 Nov 2026
 21:24:23 +0000
Date: Wed, 4 Nov 2026 16:24:19 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: sashiko-reviews@lists.linux.dev
Cc: pmladek@suse.com, john.ogness@linutronix.de, rostedt@goodmis.org, 
	senozhatsky@chromium.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, akpm@linux-foundation.org, 
	baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org, 
	anna-maria@linutronix.de, frederic@kernel.org, tglx@kernel.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/5] mm/show_mem: Avoid blocking on zone->lock
 during Oops or panic
Message-ID: <ygc3ylz5hxlkqt7n5xnl6klydhmjtflkctidr4qabf3p4dxxsq@64gqisbenf5k>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-3-atomlin@atomlin.com>
 <sashiko-outbox-196525@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-196525@kernel.org>
X-ClientProxiedBy: BL1P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::23) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LOYP123MB3006:EE_
X-MS-Office365-Filtering-Correlation-Id: 5936cbd9-4fda-4842-de67-08df3ab9ff2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|56012099006|261021135927099003|261022105027099003|4143699003|261022075727099003|261009223027099003|261026140227099003|261028144727099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B4MoVTGX6QLPHc+rDooe8rpV0f7vcatJRj14LiHX5sUs3tpra6pgmap5fY4PgUJPhDztj/sQ4L2bvD+gAtoPXI6N3MG+W3SBbhWP/AFMzdio0ss6A8/FJrrVP8bwYQXDYeNM1Cdqvkvz/bXoztWTrL3NoACdkSq4XIAtGGwOekt9g3VwO5eFtCBaoxMaKQSERahZS+7TVOGJL1arxhzKslqWQStJ09nfJxHmCq8ncehglf+PHoYDX1jbg2/zjcXAHU+R1ZK+10a0sxSKDCYAkZgtMvDg9zfXatynLgEv9JUgqzAk27Rw1/wpTmLDfN0O5wCFol6Yz6JbcSnOpJGqnKnoYVrhgio3gS66upSlQjijf3Ucv57UrMwAr13qmILc+YrWWLJ6otjpp0hDF2GFeXn20PgGlxgBFBRMwFzXTpw/I4PPsQxrMXFS7D0uNRJ1HJhCRN4fRQv/HgYFd0qfkcQeLNlv7Tx0VJSnKAGONRpaZkjiF7tI86nn9ONVr+jvuT9y+PpQKFy/z6XhNr36HUyJ+nwNnVY+LaY7g9ZSUqgT0HtizqxKOntAp4seBKGwslto086V+CNvszriBp547KONbG/iLmvMfv/r7qVMorY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(56012099006)(261021135927099003)(261022105027099003)(4143699003)(261022075727099003)(261009223027099003)(261026140227099003)(261028144727099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0VPVTJuVklUMTZNdW51SXU1dlFySm81LzlEZWY4WnNHN1pVbFFtV2dMR1NY?=
 =?utf-8?B?anlEbGFQbFRweGd5Q1hqeFNMVUN3SUV2L0hxVmwyZDZyS25RQnBPemRwbEhM?=
 =?utf-8?B?aWlqdW8ySDRkcldaS2lrNkxvVW5SUE81b29COEFCSjlGTS9rbTVuYXNjM2x6?=
 =?utf-8?B?UnZMNHdNN09qZGE5RkE5bnlxM2psN1ZLZS8vT21VWVpZbWgxZHdPWkxBeXZ0?=
 =?utf-8?B?ZVk3V0ZtSGo0Mk95WDJ6RlFEYUEwUklUckJ0NkVPbGdtMTU5MU15S05FQXlu?=
 =?utf-8?B?MjlYQmxMVTZsZElxUHFVUlVlaDNnVkxZNzJ3eTl6WGNtWUlBa0JZSTRjTkg5?=
 =?utf-8?B?Sy9nSGh0MmkxU1N0bmZkK2EzS3pob2FUN3gvNC9oMnhObDNuTEtYN0xQd2Zv?=
 =?utf-8?B?VWtkdk1JdXBhSEU5bThQNFR3R0RLU3pBRzlFMU1yM0NVQklFWUNnckpXblhG?=
 =?utf-8?B?OHkxYW4rd1Y2Z2RKd1RXcjNFTHdSTjRTNkpnUmRlWHhkQysrbkM1SExSRlBJ?=
 =?utf-8?B?Ly9sS3dOTU42N200d1A3d0VyTW8xTEpPcXZ5SkM1aE9zUTN6VkJ5SkhxZ0pP?=
 =?utf-8?B?eWJ1cVp6eDdVWEUyOWZZbEtRTzVXMnBlU1R5Ulhic1ZJOGljekthd1lXcHBn?=
 =?utf-8?B?OHB6ZlRZd2NDajRXRXZsWUJ4NnkwanpMM3U3WTZ3QTFrUCtTSHhPTXdBZ09s?=
 =?utf-8?B?RVZiYWhidGo4dFJaMVRSRWdsWEFyclhucnUxQW02amRlYk5iUDl2NHFONGJH?=
 =?utf-8?B?Nzc1eTJNS2V6Rm0zc2MwWXlMTjZPS0FTVlhodVIwRzdmS2pxUy96WCtiRkN0?=
 =?utf-8?B?YStraStmY0VjbzN4cndQcWZTZ3VsRlRhZXNRalp3eldBWFBWZzJSQmhyRks3?=
 =?utf-8?B?RWhyR1laWWc0a0NwR3NSSDAwR1lvOVIwT1UzakhYNmI0T0wwNlZjcmdyMnpa?=
 =?utf-8?B?NWE4aGpNWFR2TnN3TlFCemVXSWNaNDcybms0dllPM1hJc0NVcG9XL0tKRFdI?=
 =?utf-8?B?VU5IRFRIZEZMeG5sWFFxK0xDekxxejNzdU9SeG1EVHowV3ZIWHFZMWtYMGpF?=
 =?utf-8?B?T1VuSjFQMHVRb09JMHlBcmF5RWJJc2Joa0V4RVluVU1VQ2FrWDZnSjdTczF0?=
 =?utf-8?B?VHduc0Jaei9sZm1aQVI3MXF1NGp5UVNYVTVLbnJWVjhhWFBzWGlEdzc5cTN4?=
 =?utf-8?B?YUlMSWp2bmVRK3Y5UnRrajJrVkFpOVRneWdtc3kzYnVsQWpBM0NMcnE3YnEz?=
 =?utf-8?B?Uk16VzZ0OWwycHVab0k3Ti9BVSt5QWNTbUlmSkh4b2pudU9vMkJqUFZlMzI0?=
 =?utf-8?B?ZU9Eb0tTeWZLY1RaY2hWWDZqMEhxblhoSzc2VW1kWmtoeGF6YWNBMlQvNGZN?=
 =?utf-8?B?cjFKUDc1Tm5qNWhSSjlEU0QrSDI0b3hHUVUrVU1sYXlaQVVNVXZIY3k1Qk16?=
 =?utf-8?B?bXVxY2pPMUtncE00MWNUT0xpcVUwQysrWFREQ011UjhIYnJzMVkxOW45cVdp?=
 =?utf-8?B?dVpGYU53NllZMkxsNEFMUlY0OHZPb0VLcE9RMEtqNi9GR1FCT29iTVJ0eVc0?=
 =?utf-8?B?aTlZb3hYRlJkb1FWYjQ1NFAzeTFhUTFpU0Z5OElmMWdrVVdXWUNLYmc1bFdH?=
 =?utf-8?B?cHl5UFN6dFo2TXpzV1lKRzFIYk9jd1orRVRHTzNNaWZQcldwYWNQT2paR2k0?=
 =?utf-8?B?VDRiczBsT2dZVS9WaW9oMVpUTGRyb3Uyb085cU93bDVHWU1pQzRPZUxkWEc4?=
 =?utf-8?B?K2F6dnlIN3VvTnQxV21qdVJtckpoSlQ5NllYM0tvYWtJZ2hDUFcyckxyUm9K?=
 =?utf-8?B?dU84U3FnVmdKQWZJSmhYTWJLUFhnaWwwMHVWUkw1cWxqYmMzdzIrWUVUbk80?=
 =?utf-8?B?b1JOOXZLVTA1d1R0ekplNlU1eGxVUWZ3U3hkTVBRV3F2K0lpeDk2a2VnWXdS?=
 =?utf-8?B?SDRKU2NYaFY5TFZxWkpDU2s4TTZ6ekpkUGo4MS9rYUlvKzVCN2RqYVdnYmd3?=
 =?utf-8?B?dkpoa2dTcVBsaFdGaHhUZEdRWFR1a1dadlpla2FVdU8zeWNscGxhSmx1LzlO?=
 =?utf-8?B?aWYzUEs5ZUU4WFNaMGR2S3NzWVJvSytVMGFoTFZDaFpKNnZEcjdjbXBIMHo1?=
 =?utf-8?B?OS9aZGRlQk9JU2NodmkxbXdFbk5mNUVNY1hGbnJQN1BicjB4T1VkUFB0MlEw?=
 =?utf-8?B?WTBuZkJnNFhjTlpjbWI5ZVNBRUtwd2xrTWJBb3QyTkExVmlpQ2I0SmRzLzdq?=
 =?utf-8?B?SWlGMXV5WnZhYUZrTTZKd3lEZHdPc1VDdGdMMHo3YUFtNSsyZDNNTW9rdTFa?=
 =?utf-8?B?aGlEdnBuUXRtTE44Y2hLdW5zZituSThsczByYTNwcXE5NFZZV1ZrUT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5936cbd9-4fda-4842-de67-08df3ab9ff2d
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 21:24:23.6745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mX83XXz0UDS6Kd6a3dostHVE/ly4PP7cXSCUxkqCM/OEnhV61pwEeyjX1e94r/wQgKwvWWz40ckXFkOdBC7r2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP123MB3006
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F956A000B
X-Stat-Signature: knj43nuuts7imybw3h3nm3dfyf38htk1
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793827469-434863
X-HE-Meta: U2FsdGVkX1/OZCk/bq6ea+XPYnV9Y2cDf2kwDS0bW5DSSR7VkfREX8uYpICw95VAzT/Ep5Esc9xKCpkoo472L27lpzTiBnC9IRnB2GaSPd7JXTWjbBb5a6PY2M8BfX+gz/5HncEjI1ejAEcCJpI+32cwih8IEjClTaIyxdRHzLndfBaozmST5q3Uc+UNBYRfgcyCXKX1cBYIXU7jFLEMkZb7A4DRGKhqOAZhh2PahsEUBJgz9xkYTluBPZpZ2+YTcpTFnu2Ev2XyNlZIccHnhZPVPTdQzPPDuQ2fKvAehLxBupxjMeUOA4Gbpns7qhtH6V4GRVS1Wd8ejGem1xlefmUkHHbUNuz4H3EpXXHpVr4+HUwve6hH9NmFtGIuuA+Iv5KZfOQyuV0KYwV3qbFVBAyDHK8hua5wETzyEYp67SJTP7rY0LvHGVg1d8qQCrvKiYpQgIjw+4q9woBHlNgyWSJThf2CwAFyjG9xmvHF1cx+uok6TvvG9OOwiaxaTllCj7yhz3FIncHKgNoTpfDveF5GeyvoU1hWJONPMvOXf1p7u5XTzJo1Jn1slXqB/cRiHG8H6mknSTXsvj1nyOja4rN2+HmTcMKvDIWlp7de0CkGDAbKmizrjgFApN7FjCe91MkTDfylqmCJ/Q3jzJKGaV9fJ/ypx/xskEi5vaP94VFRG6ASOGXfHFtJOIEuKw2OE3pZlls00fs46qsTvAdqf0cUcTwSpOs8ISjlQhXXKHgZ4q1GysVu2b25TZWYjq+TQCXdIYML5r6eVLiMR1JLguaJt5aNTeQpHKWWb9fQlwZfja8VTwY+8BnxTCe5iL5f+1cHq7p9Kkl4+povYWFSI3HaQjPS73Jm2w5vCk0I0UP2MSn9iMxSA+v0PGetfusiFOw08abGmFU0oJBDEZU6WUTT3ZyYxM7Fi3TIRvzgS7O7oLuHtlwDw+b/1DPl/2wvcVU+mjXRLvzNyongdGs
 Hv/OkgL6
 SzLzZ0XgnrCdpqrlTow0dhwZCf+Yl+gHC4RG1BJzIcj6TQwIghisW9xakzNLgoUbhPIPRtisF9HyXCeOw6E/14ieOroheUCs/TuPOu6vQrXQJj6qfmlj2kiC7ofwdclP1HtLtra+kC1bcKSEeLTkTT7ot9m44L0Dew+UTI4zAKeF1VU7FM5qcZ/ff9nYhV54VXtl4eYO7zRKSxflcZ2iUpdmE2LKzy4DiSLVJYRQSr79H8yalCOlCwEwE71oC6GKCVHtmoAoIrwGaiS6Je8BuVU5bxISq2LtrMfj6xmrzXgf0bd2XhvQVQ1+dU9m18jHmMGTtW90PJU1MIx1M3Ep7ed1/67PeoC4HW54PaVRq1gL8RfbnHrP54tW49+c2Cf7koGkNZY+31rtWmfJkE88HWZRN8uwP13vuIyo01/hl4hX3aRRtvQ332oIUqbusqJG4GucKAj/5+XRPp/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 02:49:19AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/show_mem: false lock contention warning in show_free_areas()
> --
> 
> commit e1c6e11316c0b99b2f700b8251c5ed2b76aad84a
> Author: Aaron Tomlin <atomlin@atomlin.com>
> 
> mm/show_mem: Avoid blocking on zone->lock during Oops or panic
> 
> This commit updates show_free_areas() in mm/show_mem.c to avoid unconditionally calling spin_lock_irqsave() on zone->lock during Oops, panic, or NMI/atomic contexts, skipping zones when acquiring the lock is unsafe or contended.
> 
> > diff --git a/mm/show_mem.c b/mm/show_mem.c
> > index b938cbcd774a1..77098077523a9 100644
> > --- a/mm/show_mem.c
> > +++ b/mm/show_mem.c
> > @@ -367,10 +367,17 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
> >  			continue;
> >  		if (show_mem_node_skip(filter, zone_to_nid(zone), nodemask))
> >  			continue;
> > -		show_node(zone);
> > -		printk(KERN_CONT "%s: ", zone->name);
> >  
> > -		spin_lock_irqsave(&zone->lock, flags);
> > +		if (!can_spin_trylock() || in_nmi() ||
> > +		    oops_in_progress || panic_in_progress()) {
> > +			if (!can_spin_trylock() ||
> > +			    !spin_trylock_irqsave(&zone->lock, flags)) {
> > +				pr_warn("zone %s lock contended\n", zone->name);
> > +				continue;
> > +			}
> > +		} else {
> > +			spin_lock_irqsave(&zone->lock, flags);
> > +		}
> 
> [Severity: Medium]
> In show_free_areas(), when can_spin_trylock() returns false (such as in NMI or
> hardirq context under CONFIG_PREEMPT_RT, or in NMI context under !CONFIG_SMP):
> 
> mm/internal.h:can_spin_trylock() {
> 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> 		return false;
> 
> 	/* On UP, spin_trylock() always succeeds even when it is locked */
> 	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> 		return false;
> 
> 	return true;
> }
> 
> the inner !can_spin_trylock() check short-circuits before
> spin_trylock_irqsave() is ever called, yet still prints "zone %s lock
> contended" for every populated zone even when zone->lock is completely
> uncontended.
> 
> The commit message also states:
> 
>   Check can_spin_trylock() and use spin_trylock_irqsave() when
>   !can_spin_trylock(), in_nmi(), oops_in_progress, or panic_in_progress()
>   is active
> 
> Additionally, because show_node(zone) is moved after spin_unlock_irqrestore()
> below, skipping a zone here only logs zone->name (for example, Normal or
> DMA32) without the NUMA node ID on CONFIG_NUMA systems.
> 
> Should the !can_spin_trylock() case avoid claiming that zone->lock is
> contended (and match the commit message description), and should the skipped
> zone message include the node ID?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261103024453.922373-1-atomlin@atomlin.com?part=2

I have updated the commit message in the next revision to accurately
describe this two-stage check, and updated the pr_warn() message to include
the NUMA node ID via zone_to_nid(zone).

Kind regards,
-- 
Aaron Tomlin

