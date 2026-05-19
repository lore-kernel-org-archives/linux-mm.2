Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F7CCD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C906B0005; Tue, 19 May 2026 03:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3BE6B0088; Tue, 19 May 2026 03:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC3A6B008C; Tue, 19 May 2026 03:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7AB6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:10:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DD6B120220
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:10:05 +0000 (UTC)
X-FDA: 84783295170.12.AC1E7C3
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012050.outbound.protection.outlook.com [52.101.48.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 554014000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:10:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NQ6YQVTf;
	spf=pass (imf07.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.48.50 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779174602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDby89GDFbE2WlCNFDnN5bITqJ0cJDi+MZpwXASlNGw=;
	b=iI/vu0BWNMORsLMnIumF65WNM3jxlTQI8N7SJ6SrXV06FFwrrq59GFCFQHy13vdowZ1Jbo
	TyVGiXo0Vh3LOxQNol0ydsf1q5ADPz58j+R82VEXQCRK2d9tgNy98fZ3Z9Yp+pIWaOpeVh
	ekT7IBOTM3opC7gTBJNQ+QBEDxIfO2M=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NQ6YQVTf;
	spf=pass (imf07.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.48.50 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779174602; a=rsa-sha256;
	cv=fail;
	b=eW+wHH8yaQDqJc49HMUuSitTGY3U+eOTMPdioFv4r2biIfzCTMazDSFrVGdaVXd91ktzWu
	X4onjHDJCLKzOGDQhMUiqPmKYtn0/a5Z5CBXx0bUrKxhvDw3jlhcarbHvcM8Va87W2c1dx
	yhqQL13EhhJGWauh/uWuNkN9tnmW0rI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VESfoGjqVsylJhPLkZucjg3PL/p9xwpG9oNT0/nxlHO6zMSMH+qEa1dkiYuKP/BFvwvLVNPvVSDss2cDL6yWye3z3Il0QSpSn2pOAtN7/jDjmAWgPPFMZQIVaoNVxpXO2hCfBIHwr2y0iA5fUIu6MHa5a+uC/T7/E+bgamUupfrTizRM9zAmakwlivdvYnih+7O8xG3+lwVwX4+s6XrKNvbuvB4H0UOxgJUaRSsQxaqHTk0pL+K/wHkUMsoUpCnZW0iu6HdWfRvK/xTXsoO321Egtf45zw1Bx0N3NdJBdNI8w5P19kf+QHO5Lc6wwy8k5idliiFSd/wr1FnErCgIzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDby89GDFbE2WlCNFDnN5bITqJ0cJDi+MZpwXASlNGw=;
 b=bX++wGp4czlwfL1byR7lCEzA3EQ/o8ypDZD0hZA6ZTeMb93kUxD0JPUKpRws25qC2P/Qrg1UIQ/Z+Yrjgf/Yq11QnqttJHtXOOWZMUTrlWJB6qAMtv1Qig9elXbGoWDIHR0uLbxlShnheOHAE4FhJpXgDJqBWD7bsJBgOOjTlGLSnyuQlmzAtmUpB3CXzD5LCqX1HLag5JYpyaqGnaqG4CM0uNyT6AAgCxx6+lW2TIxEpVQvInQ1E8kQPBC9E+9nc2JdZQqpGWfZ0LidMuRqioilqTMNOz/85svBPxetUwXoZawN86Lt+UvzJnh2kyHLjuKV3sy+acbyPvK2JlMasQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDby89GDFbE2WlCNFDnN5bITqJ0cJDi+MZpwXASlNGw=;
 b=NQ6YQVTfXtVDhmneMG3j2JS8cH21liLeDjrSSBIZynaMbfnaP/mqLNFLDl4tB+c1GCRoJT/H3eAUc8NMc4dbiIuejGHv85Hz09l0PxaIDS6gbmgdtOhjZNKPkKXfBdLA5//qdoeZoWRSIUA0POKrawd5uamIU+8UbLNm8cq9RUE=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BY5PR12MB4115.namprd12.prod.outlook.com (2603:10b6:a03:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Tue, 19 May
 2026 07:09:57 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0025.022; Tue, 19 May 2026
 07:09:56 +0000
Message-ID: <8a13b1ad-f1be-4ef4-905e-0d9828ae8cb5@amd.com>
Date: Tue, 19 May 2026 09:09:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
To: Barry Song <baohua@kernel.org>
Cc: "T.J. Mercier" <tjmercier@google.com>, Albert Esteve
 <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri- <devel@lists.freedesktop.org>, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mripard@kernel.org, echanude@redhat.com
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
 <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
 <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
 <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
 <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com>
 <CAGsJ_4z121v4tK_3+j-hkD7HH0gH3w8tWD8nk0CwRhFE5T+4Og@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAGsJ_4z121v4tK_3+j-hkD7HH0gH3w8tWD8nk0CwRhFE5T+4Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0420.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BY5PR12MB4115:EE_
X-MS-Office365-Filtering-Correlation-Id: 16b26d90-c393-4ec2-7819-08deb575a1f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|22082099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	Z9i1JUP7T+NrdAaxJm32m2qm0GXls+gvyn2fH+HCuRApRWYZZiQmjf7P45wCPXf7JfBhMfuKP8M6R3+dAC0pwDAk6YGDmIPUPlzpNaJswORqhtjMY5c17JGnbxdyUWYztcJYyCnYNijqXDfqM0GYVVOMyCUJltJquNlScMDBx0s5nvbIQN0m+QuDNrjyb9I7EmtGxbUu1lS/ZZo1Trt5rQ88NVb+74cNBehZ1V19Uk+MgE5wtvXFBcQWS087BGN51MPD8pMEbJZg4Zakmwd1KsGtDjPIs/p9FGQtRs4hkqct3Ox1thkPG/c6AmdEXnkA26WNze7C3zn9HAJbWlcYMnhFvktQ4KM2GglQVbJwzFtDBl2Iib1PsDHALfUekrKoTCS7cnGZ3pFtdsKi8qxHJIY6YIJpLj6mmc+Hd/MTn3ZvoeUqo69msFe5wf5RBBTUc3kmspC5dg/dx8QLkH2Yf6LRcofiD00r+GMEXObmczSetfa9mE1qQkRAy+fHcqa2nKPbNjACVZy6sNfQK2BBrXdEFj3lgxoPapP1N4Eu76WWjrsApW7s3tS5CnM7TIwIPgphHKFXH3PRLXXy5sw4mA0KywNPhiXrfyQhkSBCcpYRn9A45h4S3+jLU0aS3fpdtO7bmbL7EEcaHcUZpwyeSMqwHVzWp78z8FMJbLZJh2MVYwL8tTiH6gSj/XJlIjC6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(22082099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dks3UVNwYkVHa2pZOGp3ajFwT0pwakpUbmJXS2tQQ3hOT0ExRXNxb2NxUTFP?=
 =?utf-8?B?d0luekY2NkNRQWU1R28xbzI1VklyLzNSK0tHMVFFV2FLY0VwREZOK0ZOeHB5?=
 =?utf-8?B?dzAvNUFFbXNhTm45UUJWSTJuM3FmUVB5VG9xQ0U0R2dwMjIzbjJmQ1VSSU9V?=
 =?utf-8?B?OStrMlE2OVQzYXVueHZSemNHMVlTb3JKcUNpUXZtUmJ6R3l0RmpZVHdMTEpU?=
 =?utf-8?B?SVZBWWQzRjMyTmNDSCsxeDYwdHZPalU2S1dPczZUY1RheHRhRGhIajB2bnJk?=
 =?utf-8?B?YXRNS2dBRk1tU3R6OFZKQ0N0RWg2dU8xbkxMbnRvOUJEcFF3WXNaQVhpTWty?=
 =?utf-8?B?bDMxYUViYmE3YkdyVHZRcGJiMC9FNmxsYjZRcDBsbG9nRzdDL1UyWVhiVyt0?=
 =?utf-8?B?clFad05mdTFMNlYxamdGem9UcjdLdlp6c3V3V3U4cFhEQkJ1b2RIalQ0M3dj?=
 =?utf-8?B?cUJBNkY4bElMbVNhTEkzdnVtN1BScHF3Y2FhbEorTXR4ZEthcVJ0VTA4TVFi?=
 =?utf-8?B?c3BaQXdFOG0wSTBDU096SGY3dzZTNk9uUG16UnhMTGtkaXE3TE1FSG5hMGpV?=
 =?utf-8?B?NTRMMENEMlRHSzE0aEFESFlPdWVTNVBscURSVEZ1dU1sT0JkT04xcG5vd2RS?=
 =?utf-8?B?aktVcnJtOFQ3OWh2Rzh1dHYrOVBIaUZKSXowNCtWamI3emxINWF3dGNERERO?=
 =?utf-8?B?RDdzb0plN0h5OTM0MTRTbDdKRks4L1liREU1UDJxNEtSLzMrKzRtVmpXaW1J?=
 =?utf-8?B?WkoxV0tyU0R0cHhyYU1tbFU5dVo3enRYL0VYbTJwUHZJdkxXVHBRSGtCbDZE?=
 =?utf-8?B?OEpxbldSMkFiVnpKZ1ljNmh3UEF0MDV1VmdPaS9EcWNDY01NR2VDRkVGdWtG?=
 =?utf-8?B?bnJQZHE1NVBOMjFzZnZTYUQ4bHh3VUd4K29rT3VMZTFsVWNkQ3l3eEJ5ZWEx?=
 =?utf-8?B?cmJpMU0zbUwwd2pOUVJJTURyZzczK2FLL3M5azZhZFZ2L2lZZUhuM2M5WGMv?=
 =?utf-8?B?UUtaOVhWZlhROE52K2FIZStwREVzcVo4MzE2SWg5RlhkcXdoV3dkQjBXZjZC?=
 =?utf-8?B?empraXk0enhabjQzZFMrYkg3K2QzQXNWV2FrelFlNk53NzRpUkh2SGV2U0VI?=
 =?utf-8?B?WGcvRzl6ekQ3RmpDeTdITzNLZ0ZuLy9MTVpjM0Z6Qkg1QW5hOEl1UHg5SXRu?=
 =?utf-8?B?cnpYVERGQXNaelgrclVrNDE4WG9NY016cDRQbUdGMUpsQWhOQUFDSDcwUGJQ?=
 =?utf-8?B?dFFITVllVGZxaWx5MXZrNExMN3BudmEzUnJVcEZHazZPREJMQ2pWMjZSNllq?=
 =?utf-8?B?bmVDekkrWU9lMWgyY2ZVUDBIQlV4dHBLTit6aE1nWDNGMVcyQWJMdjV0cTFp?=
 =?utf-8?B?WjhjRjYrbmlBNUhzZ3lrYWowOFJxOTlYWDB3ekkrODE1bE5SMGg0TGZ3STVz?=
 =?utf-8?B?L3VFZW0xRkJTeEF0N2c5TEZCQjZWcVFEeU4zeFZOeUZsSTdrQlVsbzdkdFZR?=
 =?utf-8?B?Q1dHeFNmWHM5czR3Q0J0TThIV3REclk4bmdKVkkxN3Yzd1piaGE4Q0hucEEw?=
 =?utf-8?B?MzVSdy8wd0NPU2Nqb3NZclRwNkl3Nk4zNWg4M0t4UUovTDRnTndUK28zU0xt?=
 =?utf-8?B?SzkvZVVJTWdQajVJTWhQcEJhOVg5ZXhUay8vQ2NlV2g1S1hYK1FwRU4wVGhK?=
 =?utf-8?B?Z0ZnNTh5ZFBSMG1zcjRJZUJ1dzEvNFQzR0JxOW1RMnlpYmt5M25lOFhYUUw4?=
 =?utf-8?B?OVl0ZHZzTHQzdk56ZHB0Z09ZdDJPTms3MWhqNWc4VzZhaEg1NTVxeFBGck50?=
 =?utf-8?B?TkEvUVgxZmJQSnR2YlFZcXNYV2d2eTUzTlJYSTRROWFpamFmNGNOK2VHZWpB?=
 =?utf-8?B?NnFKZ08vNW1xdXJSUE9qNlQzaExBckN3ak9MTkk4TGZrRVQzaGR6R2lQQmdj?=
 =?utf-8?B?cmgzMUJJN3VKRmlQUUVhczZJSVI3N01YdGJBcStPVUE2eUpsTVF1SGpzSDJS?=
 =?utf-8?B?d1QvVTM3d2RkMFlSTC9ocjRvaDRlSnh6NXZERU9wdUpsQmV2UURPTldiV3NY?=
 =?utf-8?B?ckpwUGtUMHVnUU1aVVk0cFNpU29OZEVCTVpPcmpnaURiRWVWNXNvMHFVRkpK?=
 =?utf-8?B?Q3J4cXp2am5hVnVjVkFiVUZsNWNRaFJHWStQdkt4RFFqcHh6ZS83Njd5M3FF?=
 =?utf-8?B?blo2ZUptUDN5bFRVcWtGM3QxNDJtSjZBd2dtbnd6QVIyUUR3UEt0KzJ6dzl2?=
 =?utf-8?B?N3hRd3lPajNhelc0UVduN3FuckZuYlo5WG5kdHBJK1o5YjJDN0FSUTEvalE0?=
 =?utf-8?Q?+aHqYm9l2vxAg0i2cl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b26d90-c393-4ec2-7819-08deb575a1f8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 07:09:56.7940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88mu8R2ynre5LClCmoXXIPU27rEcIQmhD4NxaLne/k50dawo2qKFfZnyN2BgAJq6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4115
X-Stat-Signature: kocobx5j3zcidj9fyac54dksemyicr99
X-Rspamd-Queue-Id: 554014000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779174602-870080
X-HE-Meta: U2FsdGVkX1+MqnNUyiP51/W9mtXbV9AwCz87nz1/3VIA/SU5xvyGG0KTJrUgI3a16Xn5baHRh/knL8r6CiMJmAnVzkuzd4i/buQJhVgPMZKx+aUZ1ibspjnvvi2QIoHzYADJYIlNpo6q+vxZnZ8pbhJXstp9Ae2vNYejau9j656wYm0QFxZoZwqet4HVMVBs5RuXVuL7it4GiCKo2GfzSO+C2xzbpnMRhCrJkmllzCjgiqgxb2Da7opsmQ3Ig77/l24XJM/wM+WJrb/3VvUrFm52ZN1bCRuvQMI6ztTqhx90Cx9fUG2f/qWjeOkjmYuuWYSCIp6u/znnrcGgaq5uHp1uBR0NqlkQojefOUGIql19fhCMGjeIyB/IzVcvVhIwYIP0/z2cqGgQAWM/w3fn5bWytyJk3F1pnbB6nw/5crGDZGUgzZtn4U9rjuUl9fwNCdA2O5Rs9mvpTq23aPqUT1hAl+k8On9k2wA0502r1hapRAYKJQVD2Hw3AvezA7tKJp3BLSI0+HzjbmLQkQiwJK7xxRBVHV5iitjv0/uzhAIzZX/avu7PQsfMoW745e+C5uwbJZj6r6TFBkUCJpFKx5PlbjjhUo+mDTJUGKaPimOoCg3Q56LPFRpZG7czSnJmXqm+Sb21XhwzBpI+JDa1YewWoyHSA9cG+hoy+rZzNYEYfZgq80JNPBpZzQDn3rvMH1Ag6lMqCp+I0Br+1W2dtE97IaMfeFJS7nV4fgsPANN+88liE4pI5HQlnbRWKnvb1pJsv2NzpY6GRxKDViLMgbC/xRYz20XXTg++96wfeJPPyb+Jx5QnfxI1FtcGkP27UW3WLz+YSTHLzk6SPMbO4JPodcG/bICGC16GHS4hgZf1l8T66h4UoISIo08H4F05xjeVIO/eoAKbNye3u/aE4VswInglH0ZKR+vHiLRgEYD/gS18O31hII0BtxCTEP5dFprlNlLNBZ5lPCxkQgV
 m+wIlhnH
 c8nL90kVWZyNsl1VzkX1UXSjhe1Zf3lMMOPv3aqwlpCfQNGyLISRA1co6hhCz96BkA9kPaXGjpZxAl3rE0HrznwbLLQXkrhQN5SudC8UPlxsJ5D9+60zXvHuCxYvJg5skfEBnYTTWw4eVYbSNFqlbuqRdJJi2ccMAHiqvxiyMBV+0nXZB6+blJimqHhGqVaSF7/kiXZsoHA3DVU9f8GkunsNqMBJDGdmqn2XTR2gzFbv5iZZYmNbNlCOMZxfRICcTI3d/xxFEqAMfwWeouVCq3useWcFL6L9t+FbeRkYoITiDe3z+O+MaJj9z6TMPDOq0QQ07r0cLytcGkEXTECSCrEexuGAbE/D94MepbKaDRuMihov0QRZY8r9rxCEpC6UHeb9s+19zxr22JHHzMZ2vzuyOzjnm1fr3XD8c9Z5jaMWEYkze8SEHqJA9i9ZM+XveEFWDMekmqk8zE+/zdJClvvaTeF1pUA9aX9jToMnOuU8q9AZh4rZ+7i7HvKur0qAGH1ur4a17ZBl0EQioYyk4fF719E6vCxKia78oRrWLrq42AYCzkkEbP+4lLJBf2mFucAqj7/nvZCUB4EQvxQ3G5rfxmz/M9EumD2k1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 01:00, Barry Song wrote:
> On Mon, May 18, 2026 at 3:34 PM Christian König
> <christian.koenig@amd.com> wrote:
>>
>> On 5/16/26 11:19, Barry Song wrote:
>>> On Thu, May 14, 2026 at 12:35 AM T.J. Mercier <tjmercier@google.com> wrote:
>>> [...]
>>>>>> I have a question about this part. Albert I guess you are interested
>>>>>> only in accounting dmabuf-heap allocations, or do you expect to add
>>>>>> __GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
>>>>>> non-dmabuf-heap exporters?
>>>>>
>>>>> We're scoping this to dma-buf heaps for now. CMA heaps and the dmem
>>>>> controller are on the radar for follow-up/parallel work (there will be
>>>>> dragons and will surely need discussion). For DRM and V4L2 the
>>>>> long-term intent is migration to heaps, which would make direct
>>>>> accounting on those paths unnecessary.
>>>>
>>>> Ah I see. GEM buffers exported to dmabufs are what I had in mind. I
>>>> guess this would only leave the odd non-DRM driver with the need to
>>>> add their own accounting calls, which I don't expect would be a big
>>>> problem.
>>>>
>>>
>>> sounds like we still have a long way to go to correctly account for
>>> various v4l2, drm, GEM, CMA, etc. In patch 1, the charging is done in
>>> dma_buf_export(), so I guess it covers all dma-buf types except
>>> dma_heap, but the problem is that it has no remote charging support at
>>> all?
>>
>> No, just the other way around
>>
>> DMA-buf heaps can be handled here because we know that it is pure system memory and nothing special so memcg always applies.
>>
>> dma_buf_export() on the other hand handles tons of different use cases, ranging from buffer accounted to dmem, over special resources which aren't even memory all the way to buffers which can migrate from dmem to memcg and back during their lifetime.
>>
> 
> Hi Christian,
> 
> Thanks very much for your explanation. So basically it seems that
> dma_buf_export() is not the proper place to charge, since it may end up
> mixing in non-system-memory accounting?

Yes, exactly that.

> My question is also about the global view for both heap and non-heap cases.
> After reading the discussion, I’ve tried to summarize it—please let me know
> if my understanding is correct.
> 
> for dma_heap, we have the ioctl DMA_HEAP_IOCTL_ALLOC, where users can pass a
> remote pidfd or similar information to indicate where the dma-buf should be
> charged, as in Albert's patchset.

Well that's the current proposal, but I think we need to come up with something more general.

> For non-dma_heap dma-bufs, we don’t have an obvious userspace entry point that
> triggers the allocation. So we likely need other approaches. We could either
> move more drivers over to dma-heap, or introduce something like
> DMA_BUF_IOCTL_XFER_CHARGE, as you are discussing, to let userspace explicitly
> declare a charge.

Yeah but that's not only for DMA-buf, we need that for file descriptors returned by memfd_create() as well.

Regards,
Christian.

> Best Regards
> Barry


