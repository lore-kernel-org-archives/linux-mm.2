Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BAF0C44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1800A6B0098; Mon, 20 Jul 2026 03:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1322A6B0099; Mon, 20 Jul 2026 03:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BE46B009B; Mon, 20 Jul 2026 03:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDEA56B0098
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:28:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4465EC0755
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:28:42 +0000 (UTC)
X-FDA: 85008327684.24.00ECA21
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011018.outbound.protection.outlook.com [40.93.194.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 54FFA40006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:28:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KT7nhSvb;
	spf=pass (imf11.hostedemail.com: domain of noren@nvidia.com designates 40.93.194.18 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784532519;
	b=RMeWBWgw0Q68C3B1vBmvhG5GsK8jQsCi2+els/Qj13Z5fzXRi0Jtmoxr+gvPacy/5+GtcM
	jyCEiWeJfDZ38w+NApP9wdl0mOlsnSzbEUyd3bn6fPAXEArYQYIK16PGfFu/GyXf2b0bgp
	djweyTGBTdmZgx/7G1MyCky5NSUruBQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KT7nhSvb;
	spf=pass (imf11.hostedemail.com: domain of noren@nvidia.com designates 40.93.194.18 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784532519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLk2RJptM/6d2VVBlVWd80Hp2X/TjDlwN3l1Qtph/rQ=;
	b=u7JeTyPBk0oBKjq84hN9jBfAldRTFhEySq49fsQ7pW2MVWqxZ4gsy6L/SVr1LODKFH935X
	pSJ8+/9f2tLucmnPc7EiUx8uVqIeNVHz5oNqHU7wu1+ov8wufylAaf7jA7wuVmgg+A0Mxr
	p0LTouiRmcmV+vZJbGW+8cdpD9XP2c8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4AV5HZ84SePzbEkJ0uGX8NdKZpUNF7DvZ5nPh69HEQofMPyrzDimgOwxNzIEyea0HR0KmucUrCtX9QgOnsVU1E0FBUkz70Lcrfehsx+87zBdPNiEQNM+hCpibWW2FYfSklKUDy2lwuhPWIMaTid9F8BdYskbHJEsxPfRQsv9mMNtTim1pAG4Xhf5Wo0hW8MbnQOqNEMXnuom/v08XBgXa71V4RJZziepzYndHxP30hH+VUioXiiwgTXU/dhhhDSqIn4CGzQDVAOVuw2A+aAjAEh88yZsAw39GyLd3ZHHIi91c8+siITWu0D9EdCWEMOB46NQivaseL4a70jhIax1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLk2RJptM/6d2VVBlVWd80Hp2X/TjDlwN3l1Qtph/rQ=;
 b=A9tpgxK0acS+HH/W7xdVSq2bWZ9hpFm0pPz0Hjw4/1YmHoeD6Yw0oHlTzL7ylwYGQbPmEMyGNbp+/jh0vM1sZmYQSdTg0uVVSwkkLmDBATVAS3wT/I8qJYTn+G+CSFK12QULI/ObvLrQj5oxKHcstyV2srwSecUtUaYpCVLcPPqunN0t2ky/CjW02p5Y+Lj7kfAZcwR/NlnoSdy1q0XuJ2AvIt0IYphs7kgXKSNfeW7P1E/bR6q6eyORaGTKCAU8GU4Y+CoocnkooF61gfcgG+3MAnVjSt30qQFCgMwD9j0U7zSZ8uDYKweMB8UpFrLQEjg0MrL2YEYGnUm/gVNd9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLk2RJptM/6d2VVBlVWd80Hp2X/TjDlwN3l1Qtph/rQ=;
 b=KT7nhSvbVQXHqUJaDWMxGuE/uzF/7+pWg7EZXTWSSrlf7W1lYkhyrW5SD4B3LQT+9wwVT6PMYgAzM+xk+C8r07XTkrLbINFW2Me/qB9sZpDAUVr4rmMPUVTZMacI2adta9peQJoVrkFnZ1McIlCRwjzObYoUo79KVX49hhKQnpgTLGydmnoFF8mKopxOh+kP+/E/5lSOkJ57wxC8uDwt6Q1Swu0qYvtC9OETjK5MpOZi0gJNO4Rp1+8ehyDk45FJwIdH6ZhLdzBBg64vvomckzr/auBwwqWQk7fpBais+3b9V10UNQ0Z+yvYApR0Z82pSNHcA/Yw7KchtXQ4eaH0HA==
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by IA1PR12MB6259.namprd12.prod.outlook.com (2603:10b6:208:3e5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Mon, 20 Jul
 2026 07:28:29 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%5]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 07:28:29 +0000
Message-ID: <f6316415-4918-4484-a241-0254efb4aa17@nvidia.com>
Date: Mon, 20 Jul 2026 10:28:21 +0300
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH] mm/khugepaged: cap pageblock contribution to
 min_free_kbytes
To: Zi Yan <ziy@nvidia.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Liu Song <liusong@linux.alibaba.com>,
 Hao Peng <flyingpenghao@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260716173504.760369-1-noren@nvidia.com>
 <alopMtyPYdn7vDoC@lucifer> <8E9B69B5-0FBA-4CE5-B737-B83AD1FE52C3@nvidia.com>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <8E9B69B5-0FBA-4CE5-B737-B83AD1FE52C3@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::9) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|IA1PR12MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: fb1b3888-63ef-46fa-b4fa-08dee6307e96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|18002099003|22082099003|11063799006|10067099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	vqYycUrttHdyw27brEX1tBtcblgSA6Wb7uC1CDAwrlZUey/6gO32osteLZlB9SB9tBFe+F7QdSQZ08gmlJPZa6XsGBAbUnOE0PlRwEQ1cHzXkUAgV6JldTCHApsufdBy/d+hvhB1djpyTuQQXBd1poKPbR/e5tjkSCMxnwMHi0/8LDj0cw7Kj3CvmYbJX6HPiTtwYg7WK1I1cvJEuhY5nZLSfqG6GN7wc1i+Y87XzLbOfCh6hkCwuxt2m2C1sINzcg6TpGIjRD1rfdGtx56BvFm/Axyuva0kSre9CAFsOkl1UGJC+Olfu+JERK0uU5lgToU97I4uSr95QTg94rG693MjC01QYIM0VIZLm616eBbxauFodVet6NE/kMITd3Sd1uSwXpZXsyTDkPn8itFueUTF2RgsKtqcJX+4Tnzouvmq+iSz32ZNQ+NoZh4N9dZly36LW4gRfCGckz6yn0aOHO5L5xDPS7v+2a4isVYJsFh0T0XzFqVqIRFzK5z5N7ewg/EdlzEm5CXGlYdw9ml/H7ApIbp1zwTVKRAJlmXNzv1beBaqgzgvLmW4CHS8ypwBlGlmguEn6/4LF+R3qB5wiiyrn5SBRlbK0iO77x9iW5RxCgY5FgMnRnumC6XC+vo3TtJ9EC00GQ/hhxrxI/rHiLdLoNmAl1f08dRez8gIIYg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(18002099003)(22082099003)(11063799006)(10067099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0g3YVd6bDJiVWVTSFp5LzFodi8rNkpEb1dlYW1lVjRCekhwdndkUlFmRW9r?=
 =?utf-8?B?YTB2WDlUVjlyU3Yvam1FV0JEajU5bXJ3aE1CcjJqT3B1endkZWNuZWUzVG5P?=
 =?utf-8?B?QUNyeE55OVFHdmF2MWNOZnhFNWlWTzNDa0QxeENvaG9YSHVJVjNKUWlhb2ZR?=
 =?utf-8?B?UzV0RzR6TlUzVkpOOHFRb044RHJZaGF2WDVzZDhhalpRbjJqU3pSQlUrendw?=
 =?utf-8?B?d21mYWd3elJpV01GNHNMVitlZjJxd0hOMTltVWZ3cXRyREdVKzYxMW9uVmV5?=
 =?utf-8?B?RWVFbFk2TUI4RCtSdUZSRmdCZ2FCd1U0aXV1QUxXdW1NUStkeHc0Q2hDMTBM?=
 =?utf-8?B?S0M1Vkl6U280Y0E1ZE5NTm8rQVNRVWl4QXpWODlFT01GemtqSlc5cC92M1dI?=
 =?utf-8?B?cDZLWTF6Wi9RKytVNHE0ZkRxR05la2VmUG9zdHU5Nks0M1A5ZzQvZThGY1Vv?=
 =?utf-8?B?YXFiUmtrUm01b2lQZE9Lc0hBNzlUQThDMFdPcjUwZlZnN2gxWjdMTUg3Vm9s?=
 =?utf-8?B?RWYvSThSV0drOG9BNU5UYlNnc1Y2LzNsN01IbHYxb0gxNC8xem9GNWdKcU81?=
 =?utf-8?B?alRZS1BxaGNoOUMySkd2ek5aN1JPY1dxOW5zdVZlYWdYbEt6WHlJRFRMMXFF?=
 =?utf-8?B?NFVhK3ptZU5MSmpZYVBERngwYk1LcEFZYjlkVlZlTXVVdkgrbzNCNHdIK1Rn?=
 =?utf-8?B?T0FvQm1ldGdaS1hqcHdkRk9KbzNoK1NRT1A4SHd1LzFFMXl4NTNRT25hVERW?=
 =?utf-8?B?R0k3a0Fwc0N4U1MyWVBueFlTSW1WbEUvVnJ0MWxRdlM1TUdjSUV2SWM3cWhI?=
 =?utf-8?B?UXdYVXZhMWpMek8yemZIdDh3amJrbnFlTUNFbXdSL0FqbllhMFBOQ0Q2dHlR?=
 =?utf-8?B?QXFCOVRBQUxtMlBuWGNGTThjayt5dGpuVmQyaTZxMkkzMGlZck1McUVsVkxZ?=
 =?utf-8?B?WjEyNVpSTUMzNU9xN0dJcGlVYzZ2eFltandpYTFEQ3VUYWg0VDVQUXNMN0Fs?=
 =?utf-8?B?Wk9BUGRPazRtTmVyR2FIc3ZTS2xWVGpDOURUalhkeVdreVp3ZnVOV3hlamk3?=
 =?utf-8?B?MnR5aXM4QVNxbVJ6YjlCZERwc1lhTGVvcklrcTJPbk1NREZTZGVoS3R1V3VM?=
 =?utf-8?B?NEx0TGVkRzFGV2ZUSTFqSHMxWkNKdVByaWh4dWt5NzVTSjZWZkxUTUR4WFpq?=
 =?utf-8?B?MmorWElnSDJCc2dEWjUvZ2Zhd2ttRTczcTl6K0pLZ2c3bnlvSW1OdFVvb2dp?=
 =?utf-8?B?eUxWcVVIcTJRSFFLNUZ2Sjljbnhyb0NFcmxFQzdaZG83cEZiV2N6ditBVXFv?=
 =?utf-8?B?QXE2STVvcUZ3YmJkWlVvOUtmRkZFZGdvdEg3aW9UTVJCKzA3NWc3OW9oeG0v?=
 =?utf-8?B?ZHh4MDMwZUdWTU9oYUJKVEYvcTR4YjBjd0xwNFZqcW5lTGJRNms5Zyttc3FF?=
 =?utf-8?B?NzQzdlQzbDRpZGR6eldFRUFyaXNyS2NlQ2pHK0F4L0tCb1NHdG4wcGZOM1ZU?=
 =?utf-8?B?M1V6NThtdHhqK1lrRFpoNHkvdW1HaDM0STRtd0tGK2RRbEZSVUJvckVCTmlw?=
 =?utf-8?B?VmhVTFQrODlNMHduaEZ5c1B6Ykw3c2k2K09mR3hVUzdqWW8vVVVsOFBxRlZw?=
 =?utf-8?B?dm5mYXVlM2JQMlQxVlQ4b2x5RTdkUGJhVEh5UjQrcjRVMzlEMFJsMmFpNW85?=
 =?utf-8?B?elFmV1B3dGFLUWFOd2YxVTZGdHhUK2N1ZzJrSW5FNC81djhMcXJhcS9yY0Rh?=
 =?utf-8?B?MlAvR2J2cnlnMWZ4UHl5djQrc3VnK3J2V3plTGZXRi8yMWx3dDRwQlpPbVNs?=
 =?utf-8?B?YTljbkJoRjRIb05IMHZhcDh4SVQ2M2FQOENHV1ROTHgvRHV4TDB3QVErZGd0?=
 =?utf-8?B?RG5HTlpJd2ZSQktjSk1scjl4ektZZzhkMVBUSDZHSnBodnRXZS9pVTlnZkdp?=
 =?utf-8?B?UTNORXo1VmsvaW01V1FzeWZIK0JYNUM0aS8zNWpuRVNMVi9oTGdSR0dTaEh1?=
 =?utf-8?B?aDhUdUN3V1laNEhVRGgwS1F1OUFwWS9xcm4zUUtIRFA3aUY5TXNISVBQRlkr?=
 =?utf-8?B?NXFhbFg4R0ZJOURiVjFHSXhuOFpBNW5QRjV6M1lmTEdacTZEMzA2bE96TDVQ?=
 =?utf-8?B?VGRZamdFbkgxVWxLZm10ZUtNRjk3bU1IS1NWSS8vVnlOdzRIYmo3T0ZQME1S?=
 =?utf-8?B?ZTJjLzFBZ1BzY243bXcvT0RmTjlrVmJycitTMFVHU2I2eStNRk94emZFTlVp?=
 =?utf-8?B?dGhNdWhMNFlCVktsYzFYbE9WNDJncDdUTkRGenBQYUZzMGxETHZwOC9jYmpl?=
 =?utf-8?Q?HAqlvRAzRrQAmiFofD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1b3888-63ef-46fa-b4fa-08dee6307e96
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 07:28:29.1776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4zmOWQUp910Rk2EF6gGI8Eh84SK513xYxIu2ndIwIyv3kf6m0ja5iJ4mokaXKLY1eXMkXFG5hskRYkrCHCW1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6259
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54FFA40006
X-Stat-Signature: zzypde6qium1uzeozbf5sri8wh3grqjm
X-HE-Tag: 1784532519-326826
X-HE-Meta: U2FsdGVkX1+PhbUbvDc18HQccYlD4adwj1z4ZH/09+D2qYGHPQOm1eEL8itCMHu64lCn26KOKXwEKL1hc/07M3WxRZjx8qB+8VJsb+mx+N1mOf7lYC3pppVnF0WZXPi9VjvYsnPwqPCCnnX01TF92JKgC2KVW8gbUAzGtFWsyE4uV7D1FX9CgHy/j0uAm82kRdf/ae4sl66skEADbaxcyCsRgKVaCVUBwKA2vHQGz9fZMFz/L6gH60zjb4MFnGNQ7LG6gr0Qbgum7r2PBQjJ8FGIV1w+5ggUSA3I7e2mzXxpxotsUi5/NQGQMD3hWmu4YFr9zVKDGUMFRNH2JKGLnIvK5GgiCKlXRqSurzNWHZYt2TM0zZhypie/CTVJn/F5+tvCR/z/62FiQ8kr4x+kKVRl2sb3SJuthNYMZWHW+Y3kIt4dRv9chHF5d7aYclYy1qGa72aW4iU1Nft/z9djq79QqZeFD5MczAjxZn9+U+Il56ejKJQI5bRLE+FwTNSIWgHkqNw7Twlks/cqgsDlVHrcKGMGX9tsHFxv+U6z4WNr87N2TQC7GBVVFAaxcjddfLs0PiLmvujuz+w94A31vo/DIYUOOfhqL6sr8Y6e+0gaIJrkiNe7E1lbBib/wEZdFr6sek0cTddqvJD5hwBGEbp4h7EL20XL52CY2ZXUprt0a254Hubn8RpGsm9GOFHwoekJbP6Uz1GFO5cmD+9bEjeDkf/bC9zzvdCNlE0etSLZcN+2UL+XWtN9GNi2eU5A/41t6O826MRwSZi8CdIs+kyDH8WVNdGjFQH2PkQtHL6PkXt40/5kaQ/CnDmXsChAc/ye48NdMfpizIOOrW4nHICQ4BTGQreHWkDzJb3V5Da0/oQpIsEDJGfryjpY0IywDR77jhJcwV2pYPcfp3y07InKrn1Hwazy7qxsXbQDiuYtA7sSK99AM95ZRN8mkpkdIdkRTv1KoqGmWttrcPK
 sqqnUoo3
 5UFzOJCptsL1HH1WN2PG0pDidvCQIFGkeMYLtWVYyQERrWdwxhlBrCR+R/MvoSXoAsxGGGrcMNouoqL2N1KD7oHWKlmIXFmnpLQEU4jKJ0NRoYPckVX9kpL3qqvGXzNO/HmcdaOsLruSS17YdahNSvAN4PtQTQ5mUd7L/45pkONexGpyF02XkKB05qD/xBQ3Wa/ObPdWgwfFSEP2X+Q6gnEMhPggeeTqp1lX2U5kJ6IyEmJ2s4zRDWGzXNezbZcZYLK+Y/xuop/h8mJKpnqKV/zvnvGjwLPkMsBzrktkeMYuG/UmUEJ9tq0seAEzSkGD8UtEeMgJUbPkV8p9wFFcj1tPz2Romc53RRjv4LXaIlVaPdIptNPpDgJD+7CsyO0yQfAJAKfQP0+lGsXAG2OkP+hgELaGjEJDDAd2LolAipKwAMTokPaUJaElYWc3522tsC8NGc7t8pUhiixI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/07/2026 17:58, Zi Yan wrote:
> On 17 Jul 2026, at 9:36, Lorenzo Stoakes (ARM) wrote:
>> Maybe a simpler version would be to just attack the issue we actually have
>> with it - it uses too much damn memory :)
>>
>> So maybe something like the attached? (you'd probably want to make this a
>> sysctl or at least a defined value of course)
> 
> The approach below makes sense to me. In terms of the actual cap size,
> I asked Codex to check what possible pageblock_size and their reserved
> sizes:
> 
> 1. 1MB pageblock size (s390) and 11MB per zone,
> 2. 2MB pageblock size and 22MB per zone,
> 3. 8MB pageblock size and 88MB per zone,
> 4. 16MB pageblock size and 176MB per zone,
> 5. 32MB pageblock size and 352MB per zone,
> 6. 128MB pageblock size and 1.375GB per zone,
> 7. 512MB pageblock size and 5.5GB per zone.
> 
> 1GB makes sense to me. 512MB might also work.
> 

Assuming three eligible zones, my original proposal would have been
equivalent to a much lower cap of 66MB:

  2MB * 11 pageblocks per zone * 3 zones = 66MB

Using a more conservative value also sounds reasonable to me.

>> General idea is - if we're going to cap, let's just cap instead of
>> pretending that page blocks are of a different size.
>>
> 
> Sounds good to me. Thank you for the suggestion.
> 
Thanks Lorenzo and Zi for the review.
Capping the final recommendation directly sounds good to me.



