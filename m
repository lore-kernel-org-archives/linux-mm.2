Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2628C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 16:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45C56B009D; Thu, 20 Aug 2026 12:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6006B009F; Thu, 20 Aug 2026 12:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDD36B00A0; Thu, 20 Aug 2026 12:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4A56B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:13:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8809A160205
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:13:04 +0000 (UTC)
X-FDA: 85122141888.25.5A2B5D6
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011049.outbound.protection.outlook.com [40.107.208.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92BBC40011
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:13:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m+vO74j6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jonathanh@nvidia.com designates 40.107.208.49 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787242381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXQACOlMqYttdwf87+MdT+hgACB1lVKrO6r8CW4/KWU=;
	b=Ug4B0vDfq8GHBAp85F4UeL7CvZePHspLIXwJ4dVnaQPyAGLE91Xj5IC0N3Vf0ZJBToJFQ0
	P6MppaoLMXXi6v4Ow9K+YKboB3kYlRMFRf1KwgON4bcPX2EU9FEOgNjMbsiwpVNvn61ZNB
	5IiBrqcM8C2drMYbQrSiOqJzjRoAKz8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m+vO74j6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jonathanh@nvidia.com designates 40.107.208.49 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787242381;
	b=wML0DHadJAiutswrojRvzvbO0CWm8WKwNRA65ySRba55SRiq0NP2aUvS4suWqi+wDf0o6a
	AxuvGBP3GVh1Vn/zyKCpRMy2tsjqNPP3+O62d9pQUU3bqq3oKLAJAUYnyyDQ7Bni+MW66R
	b4G1t6IgTL8jeBbPfsC7I7DyoNspR38=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f3Uc5FdNgXa/DWjk8UUj7JgJQBpAvUIhou3ndjHFD6ixU1lLrWEAFXE5BcI4LDZ+6tWa95B1/6tLHftEl1NzXSk9cjNJCGlJF4pY794+/SX8bpY07HoRMRyRIQxQFOEyVxMf4unobpLhOAsQ41JXw03eP8ULqwxEKkMSE9BwFaLA76zZeh4LLmlMfUOZHDCxtiTOu0r3/I7mTRjlBXPLifBjQ2vjIuXUTETq/nhyFCcKpO3LGEcp94DuWKyaWeBxbFfGG/+soKyxKhhwAL9CdFaZrZQdDjY6flcdE4u/xx7Nbqs1UcTthKY6LeCLiiREMS4nEBfim/LzkBpHKLYDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXQACOlMqYttdwf87+MdT+hgACB1lVKrO6r8CW4/KWU=;
 b=oi4foruBDTxzCm5vPGH2kNphFqYT/GM0953Ftl5dLyNgyB8lwXy3fTTb6rAmvKAPUG7ye8KQuQYENzFHWjRHLabgvpZz2P6nywUG6zsVJTCHNYGkbDD+0KCyjpysZbaqwhuSkP5PiFSIFzRSy7eIOaYnMSqlX37WH0DXeJhsjcHDmoWr9l63Du+gZKywMt4CWYn+6VgOTRY6NER7dD8XUzbQML8e16SdaCQYS/YKE6d4VkiykrNiMXs8e6PrUmzn6mBMaO3uF++vxqwNHs5rRVZ+xWkqYXWSNI8tcZ7GwdZ+5X5hE80IfXz2JsFNgoCXBBOwyRZfSt23WCfQN0RAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXQACOlMqYttdwf87+MdT+hgACB1lVKrO6r8CW4/KWU=;
 b=m+vO74j6BdUSjBj9JJqSTFitMc3/WKuIUYplZHoaHToDpuLZAFuspnhpDliJtg+krMFHpARp5V+JADFacIFFcMWnB4s39hT8QJ5NYiqptIukyWWdJ+YXBWuQijL9ZOQRbhJG0Xja/L9Jno5AavzKs2ylZqUpnSEc2RzZEGSPsThuf41eorCZugY0lTo0U0/56Ak5LwK86IcBxon3Uu7Hdq+bfDIK0a/PbkLc9lMgmV5nh+aK8lUUex0am0ui9fniHxo2ePBZQZjwbV4m/pmCKTA/y90pmuFnCKIrbGznsLrA997W1MfkaHpdsKHVTTRo0lZ/YUUCwuHNFyv5v4rcrQ==
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18)
 by DS7PR12MB5936.namprd12.prod.outlook.com (2603:10b6:8:7f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.10; Thu, 20 Aug 2026 16:12:45 +0000
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9]) by SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9%6]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 16:12:45 +0000
Message-ID: <c8a8ed26-973a-4fb3-a72a-f595cccaf1bb@nvidia.com>
Date: Thu, 20 Aug 2026 17:12:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 06/38] calibrate: Rework delay timer calibration
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120317.978403520@kernel.org>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20260410120317.978403520@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0205.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::19) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6051:EE_|DS7PR12MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: 403b744e-fd37-478d-d403-08defed5dea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Hku/AQpoDLljpIsWMTOh6NT0b3M4gjVgbDMQtZDjU7lXVe14SpA6/bMJ/hEkj9LRXMDZc7FgK5B7dIFn/CHKklGKQjQcJ5HpNDzmN4TKY20Ud1Ntw/F/UJRIbfErCGYCpzKCbnsGv5Rsmspv/qDZZMPDLYteMPrfcm9qcqIou386zjVU0KOD6ACvP7kcbIDxFnr2GqtbdqL8bY8sUXWqGUlv4c6fhxY2xVpptb0nBK3djNHVjf/NAv2yl+67I7weZjtdPKG04+hEBivIYgrgCFoogdONpMrqUAfSOafaB3UDz20/5WomVhqmSpYtrB1RHBs95+qY0mcngiyx02QJ89MoeuMuCg8spER2kwX5y8JR5TLeEBUjo/dxShi7fZFNO8nZluTUWeJ5s+dPpfjqhCBfsgwXWTYeRxsOmvw7HoZh1XUWJawnikpP1z7aso0Uw4+C+NnaK7ooXLl41q4ivktSsWadUaPhPbbaflbgUFM6l7fVWJ0oNy0Ml4vnpgTHsf3EhEUAF4byfE3GlG8sVSkbqqV6/ALcKCAsibKQVvo8XE5OQzN+lSLP6tVIEqcx90W3eZbmKOd+fvU/1uqsXkhdsQ9hHhmqrP9vzYi/pz9OQgvoKKo7+mZyPERQMtInUTYJd1znCNef1XIVfITbXvd8OCnivO5+I4a/LRJsI7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6051.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2pNYVJsZ09NOVNLY0hqVlNKYTB6cmFCSHZ1dUdIcHRKVS9ldzlPZ1c1TjFk?=
 =?utf-8?B?b3RHYzZKSDk3Tm45d3Z3UGl6RENmYVpOcDhibUorY0dDa2s3NG4rRWZ1S0du?=
 =?utf-8?B?Mk4wNVBGb1Z5ajRsZFQyZmJGSGFCZnVhaUplOGwvNWxFVUVkdTNDNSt4Y0Vz?=
 =?utf-8?B?SE0zWGptVlBBTUlRdUIvTWdHeVVNelpmVjlKWHA1ZG0xdEpaOVd6dWdoTWEw?=
 =?utf-8?B?b0tOR0NFVlVoNllLMitzLzNhSk1UU2NoNWJ3NFhKSklRMXBKYlhqY2pDdE45?=
 =?utf-8?B?QzlJTnBXRzZQdFZIV3hKaENqTEs4Nkx1UzB5NmlBZUJUekY5dDAxQ0lJVllH?=
 =?utf-8?B?K1VaajRPUHlwUm0zbUdLSnVhU0RJUFJSL2JwdW9XNTBYVzJYRGNsNG8vSHgy?=
 =?utf-8?B?STc2TnE1TzBWRmIxMEpHNW1PbVZtWUxnQ0owa0FsbUhORnBlNjh6L1J5MnJF?=
 =?utf-8?B?OTBtOGsvMitsSVFoVHU2b1R3TEpBNW1TUXdGZXdqcmc0TzBobkJ0UFpibU1F?=
 =?utf-8?B?WUdFaFpzV1lvRVg4ZmRZRXRWdEY0bXV6c1Y0c1MyWktqSWNUVHNtditXaFdN?=
 =?utf-8?B?b0UvUEUzTUlndEhPSDhjSXVydkN4MktGcGZaUHlwbHRvQ3AwbWt0ZCtvQ3JT?=
 =?utf-8?B?b0R0WkYzT1ROZ1FBYU1rRkhpejJlcjRBekRRejBkK29pRUd2UXlqb2oybndV?=
 =?utf-8?B?WWV4Q1U3KzFobitJaW0vMHBDdk9hV3JHUVVBdWRzS3lURXFNNzdHN1B4eEYy?=
 =?utf-8?B?c3k0M1RNK0VUK1lLYi80YUhsQmhTMzVWeHkyZTQ4QVh5U1ZhRmJVcFZUa3ky?=
 =?utf-8?B?aDRmeHlSckRnUHFOZmZFRkJoNDl6eThaTkM3Ry83S1hnckhycU9JSzBQL2Mw?=
 =?utf-8?B?VjZvYW5ndGEya0Q0THhlQlZwNkNmOWdtZDEyVUoybDc5SSt4b0VPcnV3Ri93?=
 =?utf-8?B?bkc5Si82UW5vaWp6NDk1cy9KenQ4QWliRkQ3SHJRNkhVc1g4MmMyZjJXRHVz?=
 =?utf-8?B?RFJ4QXI0Vmx0SkRQTnVWZk5TelgxQmF4dHdMaFlvKzQvdXo2Nm5IcjNvby9O?=
 =?utf-8?B?NThMVVlIMHptZE9jK3dIeVhrLzJ4VFhWS0Y0cGpaZlMzb0JQT2JrdzN3eVI3?=
 =?utf-8?B?dDRnaW9ZNDFwVWlmKzYwL1hLekpYNEZET0RETGRDMlVqQ2ZlVXBTd2NOQWlx?=
 =?utf-8?B?MDdiZytFeSthWjh2V0FQSzV1aWUzNUtURDNyZTVKVWlUSkxjNTFiYWkxc05T?=
 =?utf-8?B?bUk3cnBjZXkzSEdPTDRCY0JkOXoyTGtxeXR5Mm9UOEFFMzhUSkg2QXBKSW84?=
 =?utf-8?B?aHdvR3pHcDNsRXppdEo4YU5tWDc3ZGxPY2tpeVhPS0ttNS9aeDkyUWppR0dG?=
 =?utf-8?B?VkxwWExqUlRRNWNMZ21IdXBCR3BSY0cxTjM0Z1J1eHoxcGdINFRvS1BhWjRx?=
 =?utf-8?B?aXJIK2pRUHJFNU1LUUpiTldwYWdFd2dDK1R5Z296R2w5N09IdTJNZXQ4N05t?=
 =?utf-8?B?SHJDS0JEMVZKMjdmNDY2Vzh0emtGRExTNVJkQlB2OEJoR3FXMVBGa0w3WE9C?=
 =?utf-8?B?cHdLYnZIbFFSc1JqVE1vNHkyakVMV3VMajVqaEcvSkdtYjdhUWErVlBoMW9W?=
 =?utf-8?B?TGNpR1YxSkdUc0s5bTFUejlESmVleXVwSnhNM0RLZEhueUFQckhLUW9oejJU?=
 =?utf-8?B?bUljV3M3eVJ0eVpjN3ZKWE9hWkduVk5FMndZU3BLdHRldUdPcHZtSmtRd296?=
 =?utf-8?B?KzloVzROdDQ3V08rR0pnU0kzTVFVcmJBeFRtM0pSL0dxcldkWmhvRUFHYThy?=
 =?utf-8?B?Um9DTlF6dE1JenhNUDZZcHRBelB1K1VrNHdTYXpwS3N1OXZVRnU1bHRGb1ZV?=
 =?utf-8?B?TW0venp3eHM2R2xpMDVadFRNOU43ZWhTbEIxVlFkV2pxNGQwdXd5MlJjcXVE?=
 =?utf-8?B?N3BHQUMzVHo4cUJGSnFBUzkrYWIzTEI5b1prUmtUZTJ5d0tjRmRwRS9oREhN?=
 =?utf-8?B?NkVlOWJoNjJUdTNOWmNNYXRzelZDc0s1cTVvalVQaW5pVEpCMm9tYjI2eDh5?=
 =?utf-8?B?SDl2Nzdibk9sNVR0LzVNUXFZSENKa0J0Q0l0Ym1UQXhWd2RYdFE3NU5aS0Ew?=
 =?utf-8?B?Ri9Ha0dvb0x4RlNBSExObEEwQjl5MXNKVEJpdGZtSkxGR2NzbFpqNGlWVlNZ?=
 =?utf-8?B?bitWS1NzRVFlbW51YUVRS0RWWDc1aTdleTdZQWxub2tIVDJ4b0w2eGJ3OXc3?=
 =?utf-8?B?R1ZCZmJrbWlYOGF5aUFvTVN5VDJ3SVRXQXRNQVFFVXFvTFNSOG5IdGRlZDE5?=
 =?utf-8?B?Z0xUOGxEOGRkVVJMVHgzUUNoTHJOQ0YySDNWbVJhcE5RNDVBWHBkUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 403b744e-fd37-478d-d403-08defed5dea4
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 16:12:45.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ye8rvQlQdxke1Cm1o4X47OnoHKOhjeOLZqyz+t1/mQTrGPAo/TLtIte6ObxvJ5yITO80ujas5jc+bmfZJt3IoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5936
X-Stat-Signature: oc8a95uy9h74os8ft67zt5tx3ib3d7x8
X-Rspamd-Queue-Id: 92BBC40011
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787242381-487555
X-HE-Meta: U2FsdGVkX18YswQT2vLlcWbcop8S6dDNYFs2F0YDeR0NM9PyQ3pMSCBwKIRKbw6bNx/IpdzJZwGBC+w/tmuKPthoG+en0igzkhkf06C5bs1iBpjRSSkwsopvcKZDQMPA5Crie6XpBQO6TCStiXEGvnj79jQlqtaE1uqZpqcekZgOkNI1/vnqZIbkkm0WAiEWEGueWjPbUCWgM1vGW5kdwLtqmauNqy4Qk0a8lDN6gQSv7PFtuVON3ZCtD7KPAqHaUSlrp3idj4S69blCIo3eABE4vluiNHkKtKUUHtK4lK5o3Fq0ZsiQmHRBEzVPiwevWlcUiI+TtyDU7REevQyifpLyzwBT+laUWGeikZAp8pyNeGZsQO4e86EnycAbelyFv3QsEoo6za+2vKZvhP1nl9NoWGS/C5JXK5143cZXwC5gY0zFX7QwvL2gvaNmqgoV+ynpSX8YWel4Ey+/BculnooI3Ho9/+M0kFUFTkxfAOOoel9qsESur2ODv9E26wB9amTfGQUOjVp0iaz/yU19VJ0XfZvzfdkXc0kinVMWGILVw8vhuanTEAaWMKrPve5bBb5v602KlJgUjn0dMzvVi+iMWSv15THClfmT38pGdLVOGEbKZBzBjOYB+YJ6PCtfZCIymf9E1oAAIjYiGEb7j2C2oy4f+hnyZQouvb2RYnIGgvZaCQ9GrhNOFypOH5om13wH118VFh7SdXazqXoQu9ApXkbCJ6xUnsdmEGVe31XIDUyQ4XkP9QYi4X58n47zdmqAHp+XecOf3wmE3hKL8ZpOLwKCUk/8yImmym2z+KLGL8lOvz5my0bUxoTAXMqEwPys/qSCN6HzJBlAnoJz9ks0ogAjAWTgsYCXKT+96eEOY2Dwr+quMlcGtaggXyraYSHKZt2jZIRWXgajaWplSSJmu6HG4OsFBULx5OGxeLVBsxN7ZHjTiKDPSU6HgrQ/mCwGiOLcOfZqvF4M4yE
 GAKej0sH
 zeeZ62G+Pyqjo3qeEKDutYpEWd/GAlP1648KHRwfq6HTQjXIp25WdE5pZWo65VIyKlFCsSvLaqCtsBl+wIHT1ys3+S35AUtAplEoPKHEaoRWK47qsffh7wDPfgY5D/McwajuYiQ3YkxQCE4d0lJFYe22LAk7nwnhyh/Voqv6OpoXh4jOBFElBNKde6CohQ96xnjPL9D0zDWgE5WvURSeuYRUf2GEd06FKswiMQbBhaIOl7d2wbyfU8GAXvUgzsL6jMWlDRoENaf/cz5v0Ex2bNAWikAfTdBfLkBgE0bE2Fkn3tdnHMVgnoxbGlBj5rYn/Ztp78F0zFfA6kQJx7NZMF0TvFdHuO3jn3m3u6nWgD1upblpPOdv2RyUT6BLHq92zEVD18YvG4sqGPghCrnH33CYNU50M1sFPPSX1ZgpMB5+oqEoPFfEfpHqEBZ0VxOgDyM+SUT5n7/zW+PsL9PBp4Egi9iuvMEAqwSC2poigesDsOa7gnD6o5XDuS/RdIviesS6bSG+irZzkJ4ZuqJR///Xy1DCp00yfr5dPFn/SLLnkxiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

On 10/04/2026 13:18, Thomas Gleixner wrote:
> The header define in asm/timex,h and the naming of the function to read the
> delay timer are confusing at best.
> 
> Convert it to a config switch selected by the archictures, which provide
> the functionality, and rename the function to delay_read_timer(), which
> makes the purpose clear. Move the declaration to linux/delay.h where it
> belongs.
> 
> Remove the resulting empty asm/timex.h files as well.
> 
> No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>

...

> --- a/arch/arm/include/asm/timex.h
> +++ b/arch/arm/include/asm/timex.h
> @@ -10,7 +10,10 @@
>   #define _ASMARM_TIMEX_H
>   
>   typedef unsigned long cycles_t;
> -#define get_cycles()	({ cycles_t c; read_current_timer(&c) ? 0 : c; })
> +// Temporary workaround
> +bool delay_read_timer(unsigned long *t);
> +
> +#define get_cycles()	({ cycles_t c; delay_read_timer(&c) ? 0 : c; })
>   #define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())


I have noticed a boot regression on some of our 32-bit Tegra platforms. 
Bisect is pointing to this commit. Making the following change does fix 
it, as delay_read_timer() now returns a valid value when true ...

diff --git a/arch/arm/include/asm/timex.h b/arch/arm/include/asm/timex.h
index 94e40c19cfc5..4d31eab9dba2 100644
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -13,7 +13,7 @@ typedef unsigned long cycles_t;
  // Temporary workaround until timex.h is cleaned up
  bool delay_read_timer(unsigned long *t);

-#define get_cycles()   ({ cycles_t c; delay_read_timer(&c) ? 0 : c; })
+#define get_cycles()   ({ cycles_t c; delay_read_timer(&c) ? c : 0; })
  #define random_get_entropy() (((unsigned long)get_cycles()) ?: 
random_get_entropy_fallback())

Cheers
Jon

-- 
nvpublic


