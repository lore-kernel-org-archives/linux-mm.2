Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E90CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916D46B0088; Tue, 29 Sep 2026 11:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0DE6B008A; Tue, 29 Sep 2026 11:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741D66B008C; Tue, 29 Sep 2026 11:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD696B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:28:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE976A0161
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:28:42 +0000 (UTC)
X-FDA: 85267182084.04.DD57AA3
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012046.outbound.protection.outlook.com [40.107.200.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id B3E6E2000D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:28:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GD66VkRy;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790695719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jY8j6a0hEH48yQgXc2rw4zS1aOveQSgTPymEc0qiOWs=;
	b=F4su1YjhxDhgLYx1vwqRNoS0RiB/sMqznkWbJqVP6IInG5JgH65PZ8bS936kKaMDVmmqUm
	JEPxGVmkYobBBim67KkI8sNZKOziBOpxHpdCyNmPCx86/EyL+e6ZCWw5q6OXIWZLaszfU8
	zMQQa74EdPHnAOhk6HuWoHI+cjshR1A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790695719;
	b=VysE8f+EAiwOQftO3xeOYKhzklJNRVGZLRBv+cWic3vrEccfAzFTxpDGo+TLDMK2Mvibbt
	35oyTkuLph9JjTl7yT+QhLy/qTF27JqC44AvhH9iQfS/mMSPzAuEzbExV6vOlbZnTH8+cP
	00Wd/hMQhaakzF2y+/6GmcY1Obzow88=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GD66VkRy;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YM3fNYwMjzxrOZseZ+GBULuzF6zIFqQPsJRohEhEsR1pYLqrsR0HhQilIaBTQ/c9Y0f6JiQM5Atp5ClBOOPKwbUazWfyK0fEOyBaZ4gLK1xsuPWFhxEA5JD6oMTiRl/ly3isLvo317qRbY2cbqK7UYeZ+de4zu4ifD1usJ71DRlIHUA19GkK7ccEUppjNfpxnpLMPWEt8xgjukrW8BQJRp1GD0gtMYoihuXMiirKGCu6IkS/TsqNbnbMl3Y2SNnkPO/CY0c2u7aFaalTdaYsQBCbEtDLpXUPuLqV6xJ1p+4UlnwnCILy8rZcODk5x3TJCB37hfbxtjEJrN1oOVw6ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jY8j6a0hEH48yQgXc2rw4zS1aOveQSgTPymEc0qiOWs=;
 b=nnyZ7jb8P7rdOH5FwZU5Fl5xpZylfbRDgW11q+g2yZuIgVg0Qa+mSLrDogsm5bpJgoox1UCRZJZ5Fn7f6aflEChuygZEwc2+KcQvhXCWjJCmWPs192wQTVwOqUKpKHQngLc9p9JDU4KbTN4VKOllp6m8n6Rn2lh+ZFUTZq9V3EbkdOJKMTfiQUb53KlhpCCjqgw1m9jc0+IIY16EXQv8iV0ZkFdX0Hu3gRaYdVx+04/Xtt2WFXWdiypsRj94ZWkO7qa7PuEIuxoASWRNUdaFWzXkiUMrUKbZiXt7CU/bVeERxJ4pP915m3OIX9Yu5Wy3rz+jVeNVPccQ/LijYMoSNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jY8j6a0hEH48yQgXc2rw4zS1aOveQSgTPymEc0qiOWs=;
 b=GD66VkRyT4MXtyA34yTEoTArDSgtn+xpdORIJGD8JLZaZaxvmC+230JicR9Y4teQRF9itTy4Cwg1caIWNTIMV9A+6xx2cVJcqDh8z92RrV6oDSE7DqrH0QF9f/MfCIZMHwlmH8EXYEGNVqPlsS4F5iAzfh2FMe8cpiOnAZC6cF/i3WSMoNMyrKOLtCkslTAJh3JyIhTVQBEnx9P/IH+GmRevdPoIXSeDKNa8JDfiNs5j5ZW/wi4O+wYUos/885aFTHE0F+wAn+8QCStUqnjTmQavMO3K93G7WrsDW3lJZzGFpM4jeo/ZV4Mazk8x+xp8eT9+5DzoajUbI00RTkzk2g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4420.namprd12.prod.outlook.com (2603:10b6:5:2a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Tue, 29 Sep
 2026 15:28:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 15:28:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Shuah Khan <shuah@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <liam@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH 1/4] selftests/mm: open pagemap and kpageflags once for
 check_huge()
Date: Tue, 29 Sep 2026 11:28:28 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <C1FB2DE7-D93D-4CE0-A6D1-624CC0B9C8F8@nvidia.com>
In-Reply-To: <20260929131521.153079-2-kirill@shutemov.name>
References: <20260929131521.153079-1-kirill@shutemov.name>
 <20260929131521.153079-2-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0544.namprd03.prod.outlook.com
 (2603:10b6:408:138::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4420:EE_
X-MS-Office365-Filtering-Correlation-Id: 63771d92-8546-4e4d-091d-08df1e3e5127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|376014|366016|4143699003|10067099003|11063799006|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	CDCkH4d74RsU0t773I+46pL8tZZmRrGNgTmLD464HD961meIq826RUeJN7Msdxkp+oyyMKLO6/tmzi1QFDWePsZwUXePJN35B7NuR3Bjm+3BJxuxlUoPtxMJIf6ILvXZzn1Bvy4ZfuQlV2brNtCJrHCVZf67KKkz5MPCDL5n3fh2y1cPciNgLXLdL0Uewl35nlmdWdUm4LBf7bY34K/pIQUY+7cogFHaLFHN80csNRqhgjJL450NNG05n4h07qwWlNUkCRVfk3n5PoqRmW6xXCgkEY3rhxLg+QmY42f8rL98q9ldFQSyUNO1TRKTrRIxjI8TC1esBPhc02JD6H6uf6F6rh15gZXOWQIak0lbgEMxzvNImpTzWLO7SwwgcaJLLzVOlXFCCUQGTLpqDMfSuunCwDPAj9lOUAq6kp/YPV4qz+OpMqbXdeEs7On8lBDwJU7pGiK3/k9sZPJAnOMdnoQFVevkYPP97royT1qZl0qJhd3DnMh2Vp4e3VPp0xzC4SxDmBwPKtO2Nt9TkdAtfkiuDk8llgsDpiDeRHQnb0WOiV5RCi8NJE2NP90IkgidEmNvRKBZrrottkPcBBZpWIvayPmXx5RHG08GXxML3GSxN3EcbfoGNN1Y59fhr0DzVS7kFhnGsI/zl9dBSpb01XW2pp1gzpVbfn3Tu77xuQo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(376014)(366016)(4143699003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bk9XeFc0b2hrWGVIOW42NVlPMXROSkViZ3dxVnQ0ajQ3ODJ6Zkp5aTZ5NHk1?=
 =?utf-8?B?eHB6MUM2YUtLSkxSekNCWEZETFg1bTV6a1ZKWWg0dzl1c2xLbEdpajk4bVlo?=
 =?utf-8?B?REUreGxreEIxTkZqSEJHaEsxQmJLVUZMbzI3RGZWYlhNYkxSdWxHcUVQdTN5?=
 =?utf-8?B?a0EzRnJJUU0rc2tHQVROcFp1bHFweFhoelJDbW5HakxkNDc4NmpSbkkxckJQ?=
 =?utf-8?B?YnZDckRqSkdIcVcyM29mVVo0UXFhUTROdnh5a1VZeUpycFRRN1NYUzhrKzZV?=
 =?utf-8?B?UmR0ZjlmM3R1d2xFdVFxZEVDOVhGZ1F3allncmcrK2c3USttQkQzNEszVysz?=
 =?utf-8?B?aW5XaDM0UEVpdFRPU0dwZmJWQ2NvYlhITGFCcjNXU2ZqNmxaZDQ5VGYzUEVj?=
 =?utf-8?B?RWEyOExvNTN3ZUZ0RDB5Ujc1bDhLbHhYMkNiTlQyc2J6a05oR2lPSGJaM2pu?=
 =?utf-8?B?WmdKNFphMDA4K3p0aTZaaFRJN0RUNXBwTVBmS29iWGZ1ME9xSTU3bVY4MTMr?=
 =?utf-8?B?UGNUZEpUUUhuTHkzYWlpTlIyWWx2Rnh0ZGhUSXlxT01MbmxJQ3VsNTl6U3NW?=
 =?utf-8?B?MCtJR3RydWt6UThaTmxKbzM4MnVxZkFjTy9WUWZoc2RzN3U1VkxVNWZKYmpy?=
 =?utf-8?B?NTdHU0hIbGhLdjVSOVdyOFZRZ2M1cEtjNEpIR3NSWDZJSnFySk5nL0hUZDhV?=
 =?utf-8?B?V0Nxd3hJU29vT0JMTjNOR051VDlmY00wV05oakdhc2lYb1hDOUdTVGY3ZEYy?=
 =?utf-8?B?NmJzczZ6RWJob0srR2ZIMzJ0cWxoMUNVSXROZXVueUI2VkY4N21heWpQS2Z5?=
 =?utf-8?B?dDJZWG5wY1FLek5VanhlU1JGTFlQV1FPU0dlbG92eGtBSEtxTVJBMnk3WFhX?=
 =?utf-8?B?RjRneFo2UG1PNmprYld2RjcwNXVZZ0ZuMENvNzBZWnFuRzRFUU1NVWllanpO?=
 =?utf-8?B?NkF3b2ZQbkhuakhZQm5FRHFkSWNlbU9NVVlxWjhuYkxCQ2QxdVFnbXJNV2Rv?=
 =?utf-8?B?NEFuRUhLRFAzTDBDSlJlbUF4R3ZKeEVxaVNrMTZSNGJDb1pmMHpVUkdORVVa?=
 =?utf-8?B?M1hPeU4xTVNYMlFodCtMdDlrWXNDdzFHREN3dkRsakphNDZqbkRob1NENjBh?=
 =?utf-8?B?UlMxdmdmS3FBc2syajlYZDFxZlZjRTJJdDhLVU5UYVZoWFF1dVJiYXJ3SUc4?=
 =?utf-8?B?UzRweWpjdE8zSXZiVjFETnJjdXp1UVByZjVaUlg2UEhweHp6VUJHQmovbkRR?=
 =?utf-8?B?UFdyNnJNWWcrSHZkenMrOE9hVDVEMGpJbVlHaWcxS1FKeE9JZFd2RS8zdmRV?=
 =?utf-8?B?WEFOTHczdnhWNk1vdm95RFdTd2tpRDdybnFkT3pBelNBNWcxRC9RVnZrcGtQ?=
 =?utf-8?B?bjhzOUlwNmh5NnhaRW83RVNFOGNNbW9la2dTc1I0b2wzVzVUR3ZpWjFsZE1W?=
 =?utf-8?B?L2VWVWs4WnplNzl6dXNRN1h3amltUFBybEhFRWtSRnNidCtBSE5JWWtBRzhU?=
 =?utf-8?B?ZWUraWtwakxCQ3FoSWFIcFBBdzE4N2hTdFc4R2paaUFST3l5K3dWMklTNjJm?=
 =?utf-8?B?eUZHWGNjUzBHMnFiNHBFbzdQdUM0bzMyN240WjRlSGN4TzQxeVdmMkZCYjlU?=
 =?utf-8?B?ZGNtVG9wUjlrY3Z6MnZyTFRQcm91ZTdmK0pNbzZiN1FGYXhKeHg2TEFLSGl4?=
 =?utf-8?B?c2d1eXFNUEl1SXJUWnIzNEU3cGdJSjJ1VnNOb2pueTNsRnRNOWNGVllaV1dj?=
 =?utf-8?B?cjJqNjY2VmgrY1JQY0VoUmsvcFI1UndoN2FnM2JMQ05STGRibjZhbDFZMzMw?=
 =?utf-8?B?d3hkNWpjL3ZITmk5REs2R3FqeDA3RmQ0Vm1XeVREa1Z1dWVmRzNBYkV4S1A2?=
 =?utf-8?B?R0pveVJNV0FNNVh6ZXR2MWp0dXpJc1g5WmpENWZ2Znc3NTMrZG5mVkdpTWxK?=
 =?utf-8?B?VWNjS1VwUS92aVh2cWpPaWVsN256ejF5OEhoeHRSelh0aXVCdi85U0xRaXpv?=
 =?utf-8?B?R1lXN0k1S1psYXdDZDYxQVY0RC9XZWJDMkxyOUxkRUtEU2h6eDlJTEZnRDY3?=
 =?utf-8?B?Y29qeU9VYnF2bVlPRXFoM1h0c2tSY09DKzkrNmI5ZU1VcEdaQ2pPdmtub2Zk?=
 =?utf-8?B?VVRBajBZQ3pNWlJkQi80cW4wWE9PUzRVd0hBS1Z1UHRUbHc0T0tNZU1xZDQx?=
 =?utf-8?B?ekhzUWxrVW1wUnU5bDNnZWVMUjlnbnZqQVFXY3pzR3RhNWRMajc2Y1JoTk1T?=
 =?utf-8?B?V0VWQmhRTnhwODJpZEZwSzlGWnhTTGNXV0twNzVpdG1ZM3d0NU83aHJibFB6?=
 =?utf-8?B?cHBLQzBsOW9RaGZER2FSYUtmOThOZFMxYXVudWtGMVc0UWhJa2lPQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63771d92-8546-4e4d-091d-08df1e3e5127
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 15:28:30.9679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yb7AcAR6z6zijqka/n8Zd+isbbCRw0FvKRqkG2IbvskkVbrBC6iVTSkjNwe9BEvI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4420
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B3E6E2000D
X-Stat-Signature: cz3ta3sncnw44rfkjdfyyrkamemjrqwt
X-Rspam-User: 
X-HE-Tag: 1790695719-173630
X-HE-Meta: U2FsdGVkX1/XSizTA7qx8/OmqBEgoR0qX6SHdgOCV5+BuZhSdVOGpWAFmA+lTc9Pd7dN1MUYT1l3f0cRM6rX9l43aNH47DGrCh4bWd8kFz/TI48yxCMGWmnNmCLJD7XRb9vTedXYITZislKmclpmIeschQlLR7XKsZYvv0rjK/LeCS0ic0r+o2YH+VAcSsyp0hq80fXaile4WyZKcdAUOWoIjZDySNxHJFYgHLUFY74PPw3bkijhCAPsLXK1HXCRBE6wCfosdmHxIcpPAv7oSXSDjs5/0JsH6PON9sp5VMfB4r2i7pbeF36+6ndEStD6zxOP8ysvSlySBFRbYTChwpBunf5TQMrOX6vMc8cDOWeEkIP+BXQp+P3sRSYfIA15VeFHT3QbLukBk3hqGNZDoVgFcA8b6tdv/7739Tjwy0twlTlnuo5Jzx+/rIiykQID1H6V5HvFhDox7IbxvxPDCXkMb4b9YhiYzF+2vHHUJQv2hacQkle9NayWtwtWKf84qMO/ujXXyoNgCdOH9XvmgFFQVc5mqIfL+Mv2DGuu4F1zw76D/4DRy3gSLSJvNilFA7C1/9Ht5q3lF1La64yKxGD8/f78jTxdqN35g8H7fRLCy1iEGIjuJphHG+5swGaXVYYy4UoFxyDuwjjQHvIvvZojsCr8bOou5YP6HQBrqGMVWmfrzjckWQHM/GhVjZPwCAYZtyvjJ+Rz87iqZ9TgqrVzHB1t26+du0KFOwNYZNwckTB6DVgPVG4j2sVoIBvjRpv9Tx7LiqE3kCWjQ8nfyuGheISpYn9ugluzJc5rO366ssVulooZJ8DlGsDv34R/kiuoxRiqnBsRIBs7Pfu1ed95oY7wxVpelFI4jPD6i4DAKbcGrNCqp7XDa+eoHiMqNoi/VSwkISHVQUG562wjzSTSQzWa1aaBr79l/zckd05aMuzCUpU+YYHq22ii13glr1dyE+ejCtW0yriAcd8
 0rnXcghY
 K/6Z423x7DKQlc66m9Rug65IgdIGeMlj/9OpliuDxe2U9+FZej4ZZBDdDDWuDc0x5B7aB2WXbEdnSGnPHlklspceYnedSQveo9mQxugwlvSC1ztjEBRaF/hBRqeFBi5T7yhxaU/1NMfl4a4DHDvkeu+dxFegGjBbXZ6hEXtmi+CkgXyNHdq8FSSzMqRfqs6JTTIPpttifU4tJAbOVM1x8V8khdkKuM1t5lUoe7rksxQ0zkaEnEXXFL7ms1xo9HWAOhVWSXIxs4H+cnNI9B2ZPw1C6qnVX3YSCaMcBGq5L49ugnub+vqFB2/67ujRd7/EhcwUSGpmjNQh8uT2NvhY6AjvO22hHmSlpd9/mPENYFlMMikN6cYz45prxkGGWh+fZ8ScQi8F2p8rERClSrg3LweUGA76smHBirhv8VggXeb1RdLypkHrSfNYvB7NR+cI8V9dmOf4fM0k9KYLlk9C9OSQy/k0n3u+6ymfDgPT+WhYk8sY7nRQJ3YcwOJp6FboHJPqH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Sep 2026, at 9:15, Kiryl Shutsemau wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> check_huge_anon() and check_huge_file() open /proc/self/pagemap and
> /proc/kpageflags on every call and read the PMD size from sysfs on top.
> The khugepaged test calls them hundreds of times.
>
> Open both once and keep the descriptors.  A pagemap descriptor is tied
> to the mm of the process that opened it, and the khugepaged fork() cases
> call check_huge() from the child, so reopen it when getpid() changes.
>
> Cache the PMD size in read_pmd_pagesize() as well.

This part might be overlapping with Yeoreum=E2=80=99s another series[1].

[1] https://lore.kernel.org/all/20260921-fix_hpage_macro-v4-2-cdea4fc6ce3f@=
arm.com/

>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/vm_util.c | 68 ++++++++++++++++++++--------
>  1 file changed, 50 insertions(+), 18 deletions(-)
>



Best Regards,
Yan, Zi

