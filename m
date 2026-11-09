Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0312606D807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=zHnJfZ/5
Received: by kanga.kvack.org (Postfix)
	id 858316B05B1; Mon,  9 Nov 2026 05:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F346B05B4; Mon,  9 Nov 2026 05:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F636B05B5; Mon,  9 Nov 2026 05:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6036B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B35C2140632
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:56:24 +0000 (UTC)
X-FDA: 85415276688.06.A2F51D9
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A71980004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:56:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="zHnJfZ/5";
	spf=pass (imf02.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.43.42 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794221782;
	b=pmBFeOB5+ZS3LNqCb92aoo3DV1L3nmaniYnlrpP2cayyK+dIyR71tec76+Z3UkLqV45VrX
	NfphrfZx2HShLDcFf3pIFJImo2ou8aSZUjLSFQdNSag04mRpRxaagARxot6rNZy84hn1lS
	7VMCb6QGQT9GScFcERiDCUemmtK93e4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="zHnJfZ/5";
	spf=pass (imf02.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.43.42 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794221782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1G+4UQ7mHJ0FfY4QH361X/eCZ1GoBx6Ud/WEDTINhuA=;
	b=FOviToNxRqH5M4aoHkQ7e2pqJR0GZEI05OHy73Po+gpf0/XbaHl3x+GnXZ4qMryBUJmhUF
	VVjdP+DNWFjTXof5nOXrKeqGKjKLDbBUObyQVHHANUq2XZROQS/KbY7PrZfFGU8dCkh+uk
	u6KAkLivEWk2D7HmmdWxUwdIsiSkjnE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNMhfjUgNLQAav9n5sMDVkPcAa8E3Dt9EkU6fjpcKxYCZ0FBAnkDum+qCwDlBedzvQEbgpuVd+l17oXVD9vTnnvPwSsoqILcWj9qpGeL0CIj6egyry3OokiZ5kgeFpzLVT1PEtptZxspBncmhHbIzyYCXoEKsrMgRmQLE6QZb7cPzeQTXKrSxsMOKqx+rboiT36dB6VQy1z2VqDlj/CE/3uJ1Zae5oUAG9ewJryyRtEfr2SINtMvLd7IZbX1dnkWano2f0wdrkHqf1CEzNLpqfJTu/RC95Pq5lprXHzmz31xFJf/ml4HkTRj6NgUSLUAhtzLbbmu+dXqPx8Uw0+HTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1G+4UQ7mHJ0FfY4QH361X/eCZ1GoBx6Ud/WEDTINhuA=;
 b=HXeZuWKmTjltPbLNtmREqIla7BZuNTjHnJdZ5vJe7AoPwKQS/34nOf0HBRbasEkE8xjBxm88gqfMTQOmQMhkVeWnZI6Y1g76mSSnHjSjb9pfpaa83H8Jp6Az+yHQMX5uK8KZFoh34rZj3fSJqducDfu1kRxgycR8ga6CSa7sZlNySTsdGP10TJI4T0OeHNyUvBBUmvXc0pLnScr+0RTpYX9WNeiEQbAfGFTwWfT1H29EFSU8sTmup0NgPOEmgqXuqp7aTc2hlYIHK+3FZdbYK7zmR+jlTtHHEzEkcU5PzTzXdCqG+JtOoyP1FibE8BrGLeBmxqO0M5DVKEmpbtC6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1G+4UQ7mHJ0FfY4QH361X/eCZ1GoBx6Ud/WEDTINhuA=;
 b=zHnJfZ/56wlbK1rQwka4gYtup2ittnN9vy4rwhEhf3ibcStZHkNss0jRp0mdKhMSJJPAML3W4waxFabcBOHBfwt4K51nj4+cM5aMQAczi9jv4Mjfj+qLrWNxphyJDj0247IKIzv46qQBMT9O8K71T3MOOCVjcrFMIm0aDXTqRBw=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BL4PR12MB9535.namprd12.prod.outlook.com (2603:10b6:208:591::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:56:16 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 10:56:16 +0000
Message-ID: <b0f530ef-bbfd-4112-aa51-82fdad6c4ba2@amd.com>
Date: Mon, 9 Nov 2026 11:56:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to
 memcg
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
 James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
 phasta@kernel.org, joro@8bytes.org, will@kernel.org,
 linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
 robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
 harry@kernel.org, vbabka@suse.cz, Albert Esteve <aesteve@redhat.com>,
 cuitao@kylinos.cn
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
 <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0388.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BL4PR12MB9535:EE_
X-MS-Office365-Filtering-Correlation-Id: d00351dd-fee0-4d66-2bf7-08df3e50140f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|11063799006|4143699003|56012099006|261021121427099003|261022075727099003|261022105027099003|261026140227099003|261028144727099003|261026121527099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	k5v1S8AS4zWotcYJ/nhJUFg4E2b0rgmX98soCxjpcnO7LVlofM86eDQLP4BV5HvWVBiWWTYib6vjQ8X1m+5DqUqrWfIdK8R960upM5qh+mD7PMQCCSFABKj994zG11gP39ixXp1jegnhpUSXVtEf9r15avOTOAOwmJB0LXsWiQ8K7aGq1dNP4wd7o290cn6Xv3hrIIV+HkppZp3bpoAiNdF7RSStQxaY5KBpZOykFWHxisNUVjbpcXv/8KmTUrHWosSUSITyeBZW8N2l8+X7JakM30JdO/9VSg8BwHvwlm4Ff7rYaAD7ZNs2kN7yQNEcfJazxive+CJQ6Ur1P4m7RyTMuv3BHDjJBFqU7ZLjNDZlrKsUF3hx/1wQGMgDzQWuJsiVxp3+4SQ8kIOn7xurDrrYH6r1TMTepxbnIlXbWXypmKq8Jv7B0in4KPX+HAAj2SPvKYI5eRHb+zy9ArWd8Ki5ia5CowjVpk9B9IIJUjG20ENbJMattfthUl0gI+bZTNHxJ3sx+909NtG/IeG/snBShfeO9r5j/VmTAWiuRIXgZOH1QX6pb+hg1EW2SbNK8IKgNu1Tbup7ij4BqQUNcgwcUIARYEL7/6xS+NDT4a6u30xaYTghU4gKB10B997wqEK7k1nFelJIanAqJXjPvLwjoKSt+kHJD1ONYIPr78I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022075727099003)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVUyZnJKLzRudFo4UVlUZUt6cmxnT3M0Y1pSazN0ZDkwTXBzK1cwV0N6VmpO?=
 =?utf-8?B?a2tNNzYxbmZXVWlGV2Y0UlpqaUkzT0ppOHpBWVg3c01vT2J4Wmd4ZWJHWTRP?=
 =?utf-8?B?Q2xVQmR2NnZFN2xnVjY3bzhJMjI0a2NRaFpUOWRjRGxJdVo0SWxYby80b0c5?=
 =?utf-8?B?TUlOcDBMeVJJWjR1WDhQbDNPOCt4SjBSOUtVWkNwV0Z4RDB1OGw1N3R6SU5m?=
 =?utf-8?B?ei9pUmV2SzUwY2JEdUFMWXZHU0VRM1AvSjVITUUwaFAxdDZIVGpXWU5KeXZs?=
 =?utf-8?B?ZnVKbDJQTU5OUjNEd3lIUFlzWmlIc3lPdnJpaHhNK2RlZVFRSjMzdGo3Vyt2?=
 =?utf-8?B?RHRyMnMzUVVvK2NUZjg1b3o5VGdKdkwvaWNkNWlBUXBFeVJURitrdDFzQW95?=
 =?utf-8?B?djgwaTNIaVFkeVpuVG5OVWZVMytJY0xaRFloQmxLaDZmbmhHQzlWaTd0cVc1?=
 =?utf-8?B?VlUwMjFVRGRyMkRBa1Fmd3UrcW9PdWVMMGo2SFM1blVGU2UycUNoZDBNeDFI?=
 =?utf-8?B?RytqTGxmMmZqcXdTdUcvRjZ1bEkxMWpTb08wVUc2bllUVER3d1ZUUVdDT2lu?=
 =?utf-8?B?VjRpRmNBWFB0ZGJFd1VJVWFna0xhM0ZiVUJUaTRkcjBySFpadm82N20wcXAw?=
 =?utf-8?B?Q0JuUUpkeE8rSkkvZVA5R2c1cGhDdllaUU9ybUV6MFI3RUNmdC9wMFNWaXRv?=
 =?utf-8?B?dGNNTTE5VVhOSjBrY2NJOGxmb1FJY2tnMnBPRkd6MS9YZEtWdXdIU3liV1RI?=
 =?utf-8?B?ZWpLeUxSc1A1Z3cvYjA1NThMSnNNSGNpQmlNZjZoNld2aXJkUkxzSGZmWFEy?=
 =?utf-8?B?Mk4wNnZ2eDZKRTlRODdNcG52b1FzQncwZ090OUNKTkJyRTh5ZmJ0NkdnVVFG?=
 =?utf-8?B?T1VQT3BHYW9Rdm5oeUNpNWxycjA1Q0VoVzV0cUp0MWJVYlRHbHV0KzJBRnMx?=
 =?utf-8?B?TW45NEFKT2lFNUhHUElCWWdhaXQ5VzBmcDhUVXB4Zy9RenhXNFg4MVpRV0hz?=
 =?utf-8?B?eG9uVGhEcEJUTDFQSzc2RE9rY2JTVnQwTGV3bGs2dnk4ZFdXRHVBRk55QjBI?=
 =?utf-8?B?U2JuUHpWS0xLSS81SnRDTy9mU2tTamF0RTNDNEZuLzl3NGk2aW85OHVXWFor?=
 =?utf-8?B?aEFZSk1IUWNVNmduY24zNEZMWHpNdGNYLzh4Ynd6clhnVk95NlVoSk9mZlFS?=
 =?utf-8?B?NElTTWdoTEwyT0VlV2g5UFlHZGhQVkRlbjZsaFZ1bW9pUDhNZFNRbGMweVJZ?=
 =?utf-8?B?aEJzOWNadDVOditZcWIySURYaEE4R1JzTHBLdUJsdUNlMFp2eHBmckdrOTcz?=
 =?utf-8?B?Slh6WCtOUHFsaVE4cmNLM2t4U3o3ZFhDZ3JFVnJmNFZZcTV0QVc3TEc3MS9y?=
 =?utf-8?B?K1duNmdPaEc5MEhPRTlUN0t6WEpYTHY5QktBOHRZYUlmR1lMZVR1MjRVSzAz?=
 =?utf-8?B?ZFp0M3FMMGxhM05TQ2RoamlUR0VRL1ZZOEl2aE5FZm0vRlA1YSt2VmhmaXRw?=
 =?utf-8?B?Uis4eE9XQy9yM0VBcmdZcDV6K2xaYTQvNHZZWktBNXdvNkdxaFhqNzhHTXJR?=
 =?utf-8?B?NFoxelJObE5ZSDYyQUtZTXVyQXBHL3lybHowc3o2RHhlaVNQbUNoUytIcVJx?=
 =?utf-8?B?a1FJTHFucXF5UkNOVktSdTRpNU1ZL1V4TXBadmhMaG5yYUpxSWp0Z0JXUEli?=
 =?utf-8?B?NXJoOEVZanJ1bkFRWUpHZFpZRmJCZ3JGKzczSXBsNkp3TWJEdVA3cDh4bGRo?=
 =?utf-8?B?aVExVmVNQVdWMEdCZ29HYWdnbjVnc2c3K2QzZjE4bmtXSDFmTEtnRDM0VDJN?=
 =?utf-8?B?MXQrcDNmcmh0dTZHTzZ3MFZsdExvTXVUbURLVE5kelBqK3lYRnViWHBkSnBL?=
 =?utf-8?B?eFhKbEp6VStadXVWeUJva1lJUldZTW1iMndIejRXL3VTMUNGb2tKbmk3eXJ1?=
 =?utf-8?B?bWUraDdTZUE4dmV3elpsRjZzN3N0UCt6Z0hmd3ZNZmRkbGxScXlzdFUvanFK?=
 =?utf-8?B?a0JKSENtWmRwQXZhWUhObURhNG1BKzdxL0U0Nlo5T3lGcVZxVUtzR2lmcWJj?=
 =?utf-8?B?LytveVlzSWJOMVVaM1N2UzhIb0pFUnU3azVkenhpNVRKU0pNcjFrc3BiT3FH?=
 =?utf-8?B?bkhYdmk2U2RHM1RqUWc4djVjRGRjektKL2hLMGV6VXYzY3krRjhSaWprSDN6?=
 =?utf-8?B?VjhwQ1NrVkJPYXl3OFBkMFIrYzRxL1Jjc2k2YTRQZVM4bjVaTHJ2cW5yc281?=
 =?utf-8?B?RG9lWUV1U3lJQnB3QjJ6eU5TTnJ5UERscUdqc2NtSTF5cFR4Nzh3YjQ2M3RJ?=
 =?utf-8?Q?BmNGAbaK237SDbqCFw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d00351dd-fee0-4d66-2bf7-08df3e50140f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:56:16.6770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vDIN17QFG/90J4re2i0bT4E7MPnbihJnG+VSBsBN8eORLYlUUoSjrmJOTMD5Nb8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9535
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A71980004
X-Stat-Signature: mqafikdcxobnju5txbuci7c5cz9beh5q
X-Rspam-User: 
X-HE-Tag: 1794221781-609397
X-HE-Meta: U2FsdGVkX1+negUd9YIYvI14GE8+bnrBK9l6GdV+LXlaVgUZbOKl6QJA2TYyNGP/5VibvXo0TwxUuj3LqYZdPQeokHo/e1hwWzZFv34UnCHmEtvEU0SoP8PUouE8y4YB7r+/1KoTUsxOTqQ4BAZMFjT636vxfJgyzk2tByn+RBpbxQca0yHKsvvneZaxcMeRrhxbhtIIOlwDZs+1jfbxzuFQTdFDH7itLL16cpNkzi0C5Go72rOGOjwn1PfzJFUYFtq8k0CXZZ1FgaPlbb+fLxeEnBo3zIPh+X1tH/+iIRfz1jxEHLCG30BaCg8ZkACrI0VLEJe8kTMBCfhMGU40KEdRlsmsCi/D/K46F2QNK+wclKjvOOVPMdWCsCHM2SH1pf+ILoBXuBsKCilxKwmbY+Cf4bz4eiCEKbXjYZqoWyOv8MpDzbPFLyF7C4hsgdMdTP+Zk4Us1aPAADQY0Mg22UsDlebe+zw9fZ2Vr6RXO7BNuyXYBkX0K7zpV0+kn32RNsWGpqq0ugNZV/w2g9egNrYl8J03lVVDfWEdDP7ub4S1IeeQatbCB9bUzDwTWhCeOviuvTUpAWpM6lSIPh40iFd9jJM/b48gWIfpfb05VEdsf8FS09elqqnwoPFyipR0aC1R/CoImUTEL7TBpKMLBXSuLgfcvaZur/1N+tNUi4T9JTmPs66aap3Y/ToIQ3xZfGnsaKBOmVWXkaSEjhy1/WwF7rHONOP25ug1jtX+pH8FP5aSVuGY5QXXiuGHv0kRRwzCNQSI6DK2YAw5DMiTat6uYUba7SQ9a4ruAzVu42zgvDxDh5ijWbMFfs3B6tuUNcUuJql5m2gzG30D9SyLw5tfPrXQpiL8THrAkGwsTzdfe0YKdKe4mUO+mA/1H2I/Mu16dSZgaXPFEsOP6DCbeEUDltXe5PinqLlQWPbWMrIjLa+cJujdJDKmFdrAGhcpz+NhoTm1OQ7c80c6lNH
 sGLDawGL
 KGXif1ZZVcCgA6QoVLlFZrsb0Bv7VjBnqPyw8snuxej9F37mNaillvdp3cTOEt4T/uTwsknVsJIiJx7XIy8OhHPOMwlGm9QnrbWCTm3K8ebBQn0hQ0y2/2q4qi2+L7A8dZOMiDxHwptkxoEG4n3pNaAAJUl7acjqaSNMXffKQXrEfaqaxFHbaWSGgDk4tvYuarKk8Ihs69Mj4lexCXLekaJD+9SCtmfkixI3XlFzxS6vdQhbE71DffkYhSBq1IQU8dLUaDsmr6bQiGLDna9ZLBS4Gwvv6tehdLtqwrJiZ6tT1AMEJPJP8lJFH4Q432OpRO9sJ/E3t0V27sbINAZgH7vKf2I5rqRE0P39/Ka4PP9zbZEm9juKOxQkAA8U/B0Qics6yJA2Gp7QrIS3Z1JFZoJfApSDmT+v70LS4aPbL22V5lgM6554wJBYp58/a+O+TcTX9MAQSJxgnlmZ/MsKztlfWDq2Xn9xvC9HLy//hdNOt2IloiB4yJjBZFtk1XyaEpBfniR6wHFfFVULw25i/kycQZgeP/1NpdXvsDAUZNhGoarokaob8g/ADbidrusDvxfOi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 18:25, T.J. Mercier wrote:
> On Fri, Nov 6, 2026 at 5:23 AM Christian König <christian.koenig@amd.com> wrote:
>>
>> On 11/6/26 14:18, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
>>> data pages keep the accounting of the memfd they were instantiated in,
>>> but the bookkeeping around them does not: the page pointer array and
>>> the pinned_folios array, both sized by the buffer page count, plus the
>>> transient folios array sized by the memfd folio count, are plain
>>> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
>>> memory, and size_limit_mb defaults to INT_MAX.
>>>
>>> Charge the three kvmalloc allocations so the creator pays for the
>>> metadata it induces.  The system heap in the same subsystem already
>>> accounts its buffer allocation;
> 
> Only if the mem_accounting param is set to true. We (Android)
> currently depend on it being disabled because system heap buffers
> don't have a single owner for their entire lifetime (ownership often
> changes immediately after they are allocated), and the kernel doesn't
> have the ability to switch who is charged for the buffer memory quite
> yet. Albert is working hard on it at the moment.

Good point, making sure that Albert is on CC as well.

So basically we not only need to charge the backing store of a DMA-buf to somebody else, but also the housekeeping overhead.

Mhm, this here also complicates the charge transfer Albert is working on.

@Albert not something we need to take care about now, but please keep that in mind while working on that stuff.

Regards,
Christian.

> 
> Could you update the message to note the mem_accounting param pls?
> 
>>> the data pages here stay with the
>>> memfd.
> 
> memfd / udmabuf is a little special because it uses shmem for the
> backing store, which is already tracked by memcg under all conditions
> (except hugetlb). We don't currently use udmabuf, so the lack of memcg
> charge transfer for udmabuf is not an issue. But once we get charge
> transfer working for the system heap it'd be good to follow up with
> udmabuf.
> 
>> T.J. needs to take a look here, but I fear that this might break uAPI.
> 
> Thanks for looping me in Christian. The buffer allocations cost
> gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
> so I don't expect charging them to break anyone. Leaving them
> uncharged is an accounting gap though, since someone could spam many
> udmabufs from the same memfd and only pay for the memfd pages once. So
> this change is ok with me.
> 
>> A lot of the DMA-buf resources are intentionally not charged against memcg.
>>
>> Regards,
>> Christian.
>>
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> With the commit message updated to mention the mem_accounting param:
> Reviewed-by: T.J. Mercier <tjmercier@google.com>


