Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E81EFCE4B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 22:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23DA6B0005; Wed,  4 Mar 2026 17:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1D56B0088; Wed,  4 Mar 2026 17:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F446B0089; Wed,  4 Mar 2026 17:09:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C66D16B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:09:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 734CD13B88A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:09:41 +0000 (UTC)
X-FDA: 84509773362.17.15DA807
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012040.outbound.protection.outlook.com [52.101.53.40])
	by imf01.hostedemail.com (Postfix) with ESMTP id 77FD04000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:09:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=blMZhM3h;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772662178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ekf/TjwPl+jZYEK0lsM+N2qhKuMMmm8KbhgUriqG/9Y=;
	b=Hc5tTx8DA1ZM7PCLgZuDq3QfXc+K6c3LRApCYR7QfbmaccJlYtsUFQXMncQbZphO7HgK6o
	Fso3RnQook9/sXRUP3WDzzT33tWcyfHpYgfrztjSbQN11Plxf6aFm7tSNteBEJ642M8uca
	u3XSjxtdxUlrQKQ0GqoLm1A4NxxnUdI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=blMZhM3h;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772662178; a=rsa-sha256;
	cv=pass;
	b=ehfakTN8k9NMxfSHzV6b4Re/3MyHCvna7cMcYcV6pJ5xe85HeXrq8b5WWc557/5f5Vk7lg
	vPnOOlrFHvDw2CENXlDw/28Hx7OddpLzYfrBywkVl4IBLfuXyH/tfwW86zR3QFcYxnC1Mj
	0RarkC5ElknirevPapKFKHGTuc3rIAQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjvK946rNetPM9ey/NAvdD5D/LNKxBQmUCSNQuNTJiLj55OoRNGlozy0BxaMwNU8MfemPT5ZcVs+QCLzJC2Z/NyyG/kIbD4Farghv6Jd3RUMQSzAk0DhJm2Cfo6byblGILxoXxyfbA9Rnd9HmrUGlptIdyPvgcXNY2AQbZ96IX03NwcFEzoZ4H0ZHXF+sYYTbmuRM5hrbQHfsDCFe7JrmQS4El8AYR0jXVn3ZjhZFF1DycQZCcD5VQCfm858Kkk5Ha3hBM4cUEx3rTwUwDJBmYCCg57/uP/OkHdZberV2IQN6f6VJ5ybcWRvCbNbzxl6VWBF0e37qcOnKH8Bt3BBzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ekf/TjwPl+jZYEK0lsM+N2qhKuMMmm8KbhgUriqG/9Y=;
 b=CtXg9wX520SSF5qiqXqKjgqXljI+XiXQjoZOZo0b+feY60rtJ7iWbNafKhe8h1yfIJBgxP78ga1LnDCYHL6PlDhPRsI1bHv1JGUtDIP5yLTi2js+CmSDxyFtV+nj/68w3JvDaob7+Fwb5QMQR/EIXfIXKtYeSYDNcmDzlp7TtAxzLZi5w4g/nyASUe7EtlAskSHtIqVaI8KBnbfha0LfuW8hUXRptAFNctEihuiCfO2bwtRhtuBVfO0F/hZP1uRlkDTyYtltzeNP3GNtVuvBL0smHtSrI/5BUVuhf2xvomZfftGbF6DQbaKH0mLGezS1E4Q30Nyh43HJbTnme95qtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ekf/TjwPl+jZYEK0lsM+N2qhKuMMmm8KbhgUriqG/9Y=;
 b=blMZhM3hRLJYC25X2+LhhJ4DNEC5S1fwZDSzsVvhyF/be87KDEDRpebED6diqumwAQFl4GHFJ9OGTvrdumFNxXrpAEHABF/jfOswxQ22SDLk3WKZsS9XoHLNB5ywFaD7npi+x/NEy2+hyZBqXat/fpwr2QIGQEllQi+fOsy0Y917pGU3HNW57Yc+3H2KgGq/YRTGST0M/BdHeqgc75vjuWqa6y+444PDrRfdR4UoKDW84hjpL2My/A/RwX6vxPyLBIDphpF7pyDZhoHEbTdPdDet2bFizedUrZritye8WRKiRWNuMa4503BAJ6gqeswpp6TujgIM5KwB7UL9rDpi6w==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MW4PR12MB7482.namprd12.prod.outlook.com (2603:10b6:303:212::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 22:09:33 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 22:09:33 +0000
Message-ID: <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
Date: Thu, 5 Mar 2026 09:09:25 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 david@kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:40::24) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MW4PR12MB7482:EE_
X-MS-Office365-Filtering-Correlation-Id: f81ec86d-504f-4239-10dd-08de7a3ab6ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	HAjBij9DKWsfbYDEdaLH6OLdToeRWIl1O3SMbxwsA2dpeG7iGosJbJzx2r2ZaDqvGR21KCkSqJIk4APNikXsXmj8yYNHNsBREbqo8VyCsmnBVXSZlCZ5EOhdHbQWN8i3KBVxBhuVnJyo0DDOwDuHUES7YWlMAhvjEJlaFnlKj+ZLjocfTIsLNQrpLNQQFQOyqTqM6+m3O/0qk4ZjWMS5da+6af29UO344zCVqW+Q4I0qjOJVsPo4N7qCTv7T5DHjuTpFVrwcmTeLuPEB7pj2wYmxX4sK0dC0K1/T191fMVz53JsIY769JFEUPMjQAnXQmmr9pJccQ20Tze1NyEXIzsbUxMrmaEP/2VrwnO6U8vg8cwSoh7Uayh9y3qhnGpVzeLokk1XomGK4WkAVoIc+z5T8IRHJ1OUG70nBcv+lTkbKfZHNm2RrnSxF1TNANDVQy9sBrLCOkLGcOw1rmQVybi3jxPh6sJPcO12REYWFiZEu3iHRgv+DSKM4Oc+BkirDdIW/gMpRJ2UyZ37suF8yaOPYPbZGV0I5jABfuw0WIg+6e5hYwJy4Hax8EiijmiuqFZ2mKwlFu96ziwy9RG+6ebscSa3TFVqzGeBLYS6/P7H6n2mGsGTTvKv9ZpCtXfwaCtg0bxnYhT0Jdpw2pjEccho4jfA0F+f28f7joXUBKD+T9bqcmBySGoqM88RCaslEiUXqu9HlX4SPex6vWk+p3FfCpCFhm7cY5tNCIeG6C6U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU5mZDE4aFVDTkltV3lndWRQQU04TkNVMWtyRGkvT3hOVzYvMTJwaTAyUjkw?=
 =?utf-8?B?SEJZSzRBQXN2Mlh3c0lVemdlNFd6VTltU3Y1NFE5dG1LQjI0eEZranFnR0Rz?=
 =?utf-8?B?Ykk3QU1QTHlPc3paRE9nbElzT2QvZ1FzYXBnWjFJa2NzU3NleUtscms1UWJF?=
 =?utf-8?B?VkhSa0ZuOXVtYjBkQ0h1cmJ1YnRDYi9kVGx1ZVVucGt3cVI2V0dQUklCQUtP?=
 =?utf-8?B?TjlhVzR3emdlRjQwTk10Y1dzRTYrOWdtYTY3clNrRVlsZUtuRFVJSzlXUU9G?=
 =?utf-8?B?RDRMbEVmcXd2VVRsRzZCWlBtU2Jicm5IbE96c0NlaVRtWEd5WnhVMnhzQmJv?=
 =?utf-8?B?cnhXeklvNnhLVFRYQTRaY2l3eXhrcHZ2alMzZTZoZ3hrREtkV0lJM1lXZDVM?=
 =?utf-8?B?dnROODhHN0hDNDZnSHhFbjlEUU5tZTZxL1ZjeVFvTjFCT2t2MERYeUU4KzVw?=
 =?utf-8?B?eGxSRHE0T3lpeU45Vy9keUo5SG9JVXlmR2NlYzBpdDkxUHVyV2tvK0JMSGRC?=
 =?utf-8?B?dU9vNW5URWtsdDQzL2lXQ2luMjBsckg1cjRzRFVCVXF6M0E3aTJuNDl4c3lv?=
 =?utf-8?B?VG1BVFBDcUlGcUNCVGtkVzc1am5FRDIvWTdVUng3Uk4wK1RpdUpJN1gvQ21a?=
 =?utf-8?B?WVg1UXRDVWZiNkFQWWJZT2d4d3F2STNhb1lLQjQrcjgwbDM1dTBvbHFvczJE?=
 =?utf-8?B?ek8yOEdWV1FoSXBXQll6bU1GNmpuUTduK1I3N2tJRXJZWWZlSm5CdWI1ejhQ?=
 =?utf-8?B?dzBPZ3lkTnMxcWVXWXNsTkhFdHB0LzI2WHl4RzV2d0kwRnFlSTBWT0ZFSGkz?=
 =?utf-8?B?UmtESG43QjlhZDZ2NGlRR0UzQzIxOTEzc01wMmI2aXRtekJWcjdmRG5uQnln?=
 =?utf-8?B?QjlpTzF0Zmo1Um9nWG0wdjVlTU9RVEFnUFliR0VRbGdwZ0xreGVaYUo0QTdC?=
 =?utf-8?B?cTZmTlJ1clhZdlZrRG1qejd6TGlEb1BrOTlmWEh1Y05xYmd4L1hCT3dqS0Zo?=
 =?utf-8?B?Nm9qaGtlK0RZRlFJMWVUMWhscW9iajM4NS9reThDZXRNTG4vQkZlUzhJYXkr?=
 =?utf-8?B?Z3FWSmNQOVAxd3VXNVZZZFdwV29ST0l3TFQrUmdkdzU3T05kbkxXMi9uSWhh?=
 =?utf-8?B?SFA2YVBXRmNUZEFNS0djbFZhQUhBVGZCUnRJZ0FhdE15T05YMWpuYklXMEVn?=
 =?utf-8?B?U0Y0Sk1FR2VMdnQzb0dNaHloalVTSFVoMFJXQ05UUXBDVjMwQzF1UVdRL0lW?=
 =?utf-8?B?S3VMMDBUZElTa2N4T2p3djVGbVl1emxneGFHcmdJcmhBYnZiSHdGS0dvQUNh?=
 =?utf-8?B?Mm5ScVppYXJxbE9zUGpIR0xyNVhEMDRZdmtVMEZhYWNGVlZrbm5mRGoxa05h?=
 =?utf-8?B?Z29OWjhGMzdpWjdkWlBIaWtIeEpHMlRVZmltWmVWYUdWK2RLSDJYSmZQTjRX?=
 =?utf-8?B?eDVzaEYyc3MrMmZRbERHeGZycEt0MTRUM1VrcXoxMWZ3ZUlaaG43Y2kybDBJ?=
 =?utf-8?B?eGN1RjhkODFwckNsTzJjWXo2V1RrWGE4V0xIemtzc0VVQUxlV3ZUQ1JrM0lD?=
 =?utf-8?B?VU5kK203OFByVDVQWjNhREVjcDNoalgvRW9vN2F1dVl0eElOVlZLbzJtTndN?=
 =?utf-8?B?azQ2R25yQU1iRzdadG42M1BINEdKZE01U2dhWjNJTGFlOTFGbmJJbUhsZUdK?=
 =?utf-8?B?SlZSWDV4NVdNU21kWXZONTRCR3doOTJSanluaUZObWRRcmdKYWtKT3FKODFE?=
 =?utf-8?B?VUxYU25uM2pIa2QxOExVMEpabWpRT0FIWGVTTVM5SzM4YzEzSTRxOTNCNllw?=
 =?utf-8?B?RUF4VHpBRFNucnhJNVpLdDF0VlM3OFFUaHBRR3JwQ1lWQU0rMy9wNlg5Q1pQ?=
 =?utf-8?B?dHd6eERJZVNxY0w5RzlYaXJUQW81bEV6S3JQWTlLaWRLWmdzTVpWYzdLN2tk?=
 =?utf-8?B?RG9DUFJrRk5Xd1BPbTNsVGNkd053Z1RnWFNUWFNHRTZUck9OcUpVc0hpY1JC?=
 =?utf-8?B?QWppQmIrV2ZJMWVsYk5zT2UxZVRsdWhNUUJ6RkU3cFVseG5yYnZOdzc5ZWEx?=
 =?utf-8?B?dkFnVmlqUXIzc0QrQ1B5clFkaW1jd20zWnVtc2FubEtHSXd1R2NJemhKZUxZ?=
 =?utf-8?B?bENCbTVmcXlHTlhNU2wxZzNYY0t6cW5GdlNPTUlJT1U4OWs1aXVxYzFrZHg5?=
 =?utf-8?B?M2wvczFqaWN1Q2tBeERmWEhxZ0FHWWpvc3cvMzBqVFBBdGVWQ1YrL3VITGRB?=
 =?utf-8?B?aldQaVZxZG9vR0gzK3VrT2lRVFIxWFRDUkJhKzhJblFGeit0SWJ4Z2VOQldv?=
 =?utf-8?B?SzRHWHZ4dVJhcUtGZ1BmQXRqN2ZQUm1LSGQ1T2RhSG5DRWduQVRVQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81ec86d-504f-4239-10dd-08de7a3ab6ca
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 22:09:32.9330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0aNF+p3DJ18dGXFqeEwWLBm1raqCD1kHDfnOlqN8U4zU7KJ+YOIpQURdmZaHI98bHM5qoFLPfRj61XATljVMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7482
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77FD04000A
X-Stat-Signature: sgw85psjozqxzrxs613tomqsa746jb56
X-Rspam-User: 
X-HE-Tag: 1772662178-524251
X-HE-Meta: U2FsdGVkX1+jSCWnp+VOnMRMPojkNZ4sw5wBVt5aQZdlQNfzJMS2FtF+kmivw+yP1v8BLSY9kl4meBOsATcX8/5auUsg9+sK+kUUK3UPR33tpC2zcoh6sXW+5QHvQsD5sShgrrvaPsOwWbPDCKYxAKioyVh1RxSb/jzVQqD6WsgtFuMffXD8340NhGRmQ1m6V6lfj0HdGKPc8ffmz0AF2K7M5fCC2dJFoSLeaJS2HR1TkE78EPx9Nhq+1qZtwdfPQqmaVoiPKWqHGgaCLL59HK4jtVxnYSQgZb8CjQ2UEBSF/r29oPXxNmNO84qVFWrqGsWFPRzKVc8xewK60PjXdBpqAPNOPcOGkAbGI+fZxMHLzCwlI1rp9h+lpMMMteV8xOh5CAFTB3dusnLl28HNUp6krHKOZ69QcsbVbm2vvrs6WB0aEKzE3TbrgsdSHUD5rCC1A8NOqG0brNhx7s22A86SpPoQF+3D5D94q+CsPMXn0ahxqW/1hWhRs/95xBLQVSmwbbM56EL3dOsg7pu1CpwOdvXywP48xdAQSB5IZNq1d8kBOyEY4NhRRQanedV9MmrvZ9EOtcQXMk2NIanylUi5hA/jPVDhu+ajLwkvA9N/V2ng+AagAVE8bWxuq5FgCwgnrWUTetWY73KwEhrqTzV7xQYmqhEsCwkUxWeOMeY4Y7mOLujP6fnM9e1PiZ0ZtIAxhE6kfbM5y0O0Q3h4DD6mSu/I3L0u7wt1NHskwYZVJSq6eyePHdRcYlLLUgU690m+p/HP6L2Rdihd8N2D036+RlIx3R0YVzh41d+KyKXOI99gxCf6A5LqU04EmJv4myKFn6IY1AeaMUICFGhPXyIR8KtF9iNlWq6+mI1Wi2DpakhxLEKR6q7bT8zkFayHbp41R/LIedT8RrK4RBy1cBqw3Sj6Vp/IUnqMVKju63hqDGxrqvhkFkOi39QIAkniJjhNz7zsREEnspyg9ZI
 JUa0oZeN
 yah3ztRqkkb+hsf8QBxTw/c1IpQdOef9eQnScsKTktVgLx/HNMuxxGLR5UWesXvpzwSVg+yeGm+8fFPsEI76JV0nAAeSP9zo4OxsgzsnUhHoJyV22C7Z1UnIpf8SYcKInlv32EZ68GySCqdLkoBFKKiAncey8vxDpN72E/rs3Ko4fm64pmTRBsoPBIWJHlCGbcLuWq8Jl2PcTj7iilMBSKR5umpQ1Ew6UjYOYpzWygpTj2+0/icSI8+n5kmASwaEDgAeHuG02hl+KxMsv6VWPowbz5JFdj1asIM/+7VPucbWywdAziWiojB01prMS4BDvYvOtklFXq/N6cUzRJN3m2w9EFe43JBotPWj4glTJhRPCnqXta5J3jnCssiMk3UTGa0InLsJPCPi7iHFsLeH944A4N4ds8yqkM0jrrxGZhEBw87qn1hQbVcQybYNcO1Z+TzvKCUZOwlTQOABPnw0Ma2j2onYNiPi/dqUXY+Su0Y3cxzMRwRi47OzM/IsQ/OqxUsuz5z33Q6rFd/xFeksejqGMbH+ufKcl0SVcKxdz1eDHxzeJsALe+C0Tafqi00oXZO9cDecg/6B/0w5VeWVqBDrklggzwNUVbwMypLrdHnTOdWsKo4EwLGm3WxnzOJZ++lMhSX/dx9dGzQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 08:54, Zi Yan wrote:
> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
> 
>> On 3/5/26 02:17, Zi Yan wrote:
>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>
>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>
>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>> folio_get() before calling folio_split_unmapped().  On success, the
>>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>>
>>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>>> reference is never released.
>>>>
>>>> Add the missing folio_put() on the error path.
>>>>
>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>  mm/migrate_device.c | 4 +++-
>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>  	folio_get(folio);
>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>  	ret = folio_split_unmapped(folio, 0);
>>>> -	if (ret)
>>>> +	if (ret) {
>>>> +		folio_put(folio);
>>>>  		return ret;
>>>> +	}
>>>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>> -- 
>>>> 2.47.3
>>>
>>> Add Balbir, who wrote the code, to comment on this.
>>>
>>
>> Thanks Zi!
>>
>> Just wondering if there is a reproducer for the issue and how the fix was tested?
>> I expect migrate_vma_finalize() to be called for folios, even when split failed and
>> drop the lock.
> 
> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
> If so, how does it distinguish between split folios and failed-to-split folios?
> By comparing source and destination folio orders?
> 

We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  We do a folio_put
on the src in finalize, if it is split then on all the split folios as well.

> What we see from migrate_vma_split_unmapped_folio() is that
> it adds a refcount for all input folios, but only drops a refcount
> for the split folio. Isn’t it cause failed-to-split folios to have
> additional refcount?
> 

Thanks! Yes, the patch makes sense

Acked-by: Balbir Singh <balbirs@nvidia.com>

Balbir

