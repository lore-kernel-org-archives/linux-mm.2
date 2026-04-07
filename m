Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A4EEDB7EB
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 22:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432A46B0088; Tue,  7 Apr 2026 18:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3A56B0089; Tue,  7 Apr 2026 18:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F93B6B008A; Tue,  7 Apr 2026 18:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2105E6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:45:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A748A8C8C2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:45:01 +0000 (UTC)
X-FDA: 84633241602.02.5706230
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	by imf05.hostedemail.com (Postfix) with ESMTP id C16FB100002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:44:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NYwky1D5;
	spf=pass (imf05.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.62.62 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775601898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAcboJD+rDdyNG5B482P1npMaVbqwUIhbnEhR62iN54=;
	b=P6kE303LXBauDF4X2+nqPL4zk2AqWHfAvX4OV/ORrYNE7Cqi/U4z91Tz7THUktW3fVwTez
	JfDWT8k1MS2H7pQcERjs3kGMxCi19YQlfZYKn9t9w91KNNqOPAqwBbqvg8BScLmrosqOJs
	lyE6FYD++cs/Hyxb/aKzjeYmPxCzYSw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NYwky1D5;
	spf=pass (imf05.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.62.62 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775601898; a=rsa-sha256;
	cv=pass;
	b=BUlw6kxEus60Ehq1/S2rtHrVBMV3oYbAt3mWRHiv5YINDpnkg7CJ90PNEyDmfOvEHF7Wa7
	MrFvbwbHgm3RTEnRNL+jyQFZF0jxMd9PvzczcUP/F464Sr3edDUJLRHFWA7s4ACFwjiBoK
	iZm4XnqV6NCe4WIl0px3xyL+wheeJCM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FUWPZ4BqVMbjmdcKtggDaUxUbUXprJApQK9WyYeZLGSdhvOsKsyGb/4pOiN42MtKkfDKEjq5qjimkq+iCMElFlyk0ln8nU7acu1TxnivjZIAJlcXvJtWvnHAVvB1jbtCRcnHlTqV99hkK5VVr3qna1LBYekB72pLHJKwGVMgo6bDasCG5m8CgI1aGQP+PbYCpK2E0rjse28wE3nMZR9fhA7HSHdm5mpt05JEl1391btZD82KZYCau1zd/0hYYAkAPb9Km36PHnBLGt4Egb5uJ0OFORSeN1xQa0e4HZLXx0G9CHSmyNhDOgnUfOW3hn8HC955MVIeYbqVbuve/NhZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAcboJD+rDdyNG5B482P1npMaVbqwUIhbnEhR62iN54=;
 b=QWS569SUY2RSyevpLuBKPw8OHVmNdVFM/SMzdjArFKE9eH4YdGDLKyQpTD4wib8l4DVFFpAdALIHs7yG39mSERXIJQDdxrARLGmHdrEnS/pYlNcXxIVxHaIdJwQCtiYMnn1MGms8j07RrxYlaygNQqhKdReFBGamkNyvZ7c8/qyJNr3w3zt6w8TCwfd7MmMuVHsjwtxdc3cPB6sTI1twjIYyodxI6w65CoupM2Xs0msNgx+LGdoX/uwHfhiktS5iys6HFu3AbtjGkmCw0D9ONixEn6+Z5jMqvzervOXTSJKTTT/K+8v12jPr4j/Av9bY2OlEXATIRg5N2e7y1nAl0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAcboJD+rDdyNG5B482P1npMaVbqwUIhbnEhR62iN54=;
 b=NYwky1D5G5CSIPRpdWWlXLjZRJBReKlYL+fGPekVmH+u3/vGc6KRJuagISyZztUPMP65Iq8q6v9JG9Rh+FlN9hZebfNgcizweA0VXefeoywib3JonXDNFHAk7kIQnifqko41EolnlK2/txbdFARi6NVoBBwiHBbfxEnrbZVytkA9OE6ApwPtlNpg4U2CV76LXUjm6kHqA5Gc3NMZraxS+CjzzwMqolrivip7562igDlvLZEkg91JIjWFxzVJlmLvNP6uF9bFjPlm61GPwW+2D5mNdPnbxNvvQd1Psm21hxrzoe5GyEStcbthr16xYvw8oM08J8nlhr7Gm8rtYXSrfA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CY8PR12MB7682.namprd12.prod.outlook.com (2603:10b6:930:85::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.18; Tue, 7 Apr 2026 22:44:54 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Tue, 7 Apr 2026
 22:44:54 +0000
Message-ID: <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
Date: Tue, 7 Apr 2026 15:44:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
To: Joseph Salisbury <joseph.salisbury@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::35) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CY8PR12MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: 05675813-cf5d-4286-f42a-08de94f74989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	eUt7CzPtN3JflUHsKckGqmSq18Tuww6G7qXTOv8gTsJFFIqZgTD+7M725IC6jxxMuDCm1zNvUdrcAyfcmiOLpbBs7nu+LP4U97VeN25ZyZ0Mu51/Dz0atV5CkcoWPHphUbR2e/S4+Vm42JiemNAWhe82UWESjgPm46M0fdDnCxLdEiamW6TTfROfx6l+sw1PSDOVwbjoKK63vm+s/gltQrWGFAXlccZgGiVPzM/Al7TiiHFS9XbRYZAlWFHjHN6JE4UkoAaQi6CHAEjo4SFk6Q3ARjQXrzrz0Als+xmBoFAgse3maBZ9Gg68a0DlSa0P5/lOt8MnHeHC2NKZZi5togVis0gOsw82jxmNGZq0m0a9OJi0NkW/HeYHslJ63vk4rplshfhDiXGEHxY61pr/24J4955ISOnHKZNkB01kq8e5e27mJr5jdecjsomZIMaGWQVfadK8n0CPr5ZVDVsz6GZ1RN2kl+Z5a/2BzfVmubxSWjfhaItcjkcpLIC4a7yJTvsREABGTzj2ct/GoxgOmoagNaIYTS0tWLygocPMKM60jSVslUuQ51mbKa1ojOuRweU8bpqPXlqccrZkJbEHY+g0onybg6R5AD0Fuindr6qZFtL0HUakkSG2Jwowo3XDm3aYzeYgSozan5k+P9+xJZ+PlT5TdYkuFc1AZ9p2JoCLH0MKpW1sMvyCS84H5OB46MEKWf1F2HPE98Es3Jlyy079rWUTr417tOziz9MtJFg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0syYnFwYXgyZFlWRkQ0M0dLSGdsaXFaOXoyRldVcXQ2Uk82cWVsaFJaSXYv?=
 =?utf-8?B?NlRCOEExM051ZXphRHNrdm9veDBNcmRaLytVdTJjajdOTW9zNm5tcFpzdFBM?=
 =?utf-8?B?dnlOTEFKaEpoQUlRN2FEekpGaXVUWWVJWnFTbjdwYjJIUFlPbE94cC9XR0da?=
 =?utf-8?B?QkNsR25vZ3ozTVlBbXFwdWpCZkszKzg3QlA4V09jVk9qZXlHWVpvNSt3b2d3?=
 =?utf-8?B?QkhoWHR1TktxdGMzZW9BMzQ1R0RZNk1ianhrZWc0TGkxb3Rrc0lRN1gwRDdV?=
 =?utf-8?B?cHNkSm01VjhIbDRyYksrR0xtTWwyUEtGYjkra21xd3NJTEtHYzhpZlJla01m?=
 =?utf-8?B?TFBpaGY4M2dCVitEbWFTZnVnVFZWSHBWRnl6OERhNzdDQmZDZlpwRzQyU3c1?=
 =?utf-8?B?RSt4VXZVb21WK3BOcll5cVpJbDBOWFA3bFRyblJNaXZiVzFpc1IvdnlHaS9K?=
 =?utf-8?B?ZThzYzI1bTFVT2lWQmNyNGZBaGxsMXBiYWZTUDR5OWJZVVFSeGJTR3c3dTVn?=
 =?utf-8?B?VjBhdmdXNEdPbDR1SmNsVkFkM2h6YS9aNksyT3d4U3VGWVU4NWRJaC9jT3Iy?=
 =?utf-8?B?aU5lNVI1VHAzWlhmOFVla1NIVGxMa0hDdTlBZ2wxNE9OS2UyNnRrY0sxYkty?=
 =?utf-8?B?MHRGb2tiRGFMTHkyaDVlblFJWnQwOUNIM3QvdHMrMFYvWnRkaVNpT0xMYysz?=
 =?utf-8?B?NTdESHFlWG1QVE5mVVpTVGhjQ21zRHQ3SzhXdjBzSmNqSXBDSUovTmgweWFm?=
 =?utf-8?B?RG9GTGtLTGIydDBBSXd2NlZkYjNCK2Z5ZEZ0c2o0dTNEaTdnRmgrOU9FdHhx?=
 =?utf-8?B?cWgxYnYzQ0JxZEl6Z3JlR2daV0Q5bFh0ZDhtTUNCTmhXZFMzY3U1VEU1ZmY0?=
 =?utf-8?B?QitnN1J4bFlQUllvYzBHTFFYdG0weEUxQjdqM2V5UmV4eTA2RU1IN1V5VndY?=
 =?utf-8?B?TkEwY3hBYWIzcjRtYUw5bUk5bGhrc2dacjk4SXJCZkhZRnRUMjZHR0ZrZk94?=
 =?utf-8?B?Q25FQTJ5Ti9TMEVXNGxCMnNkNXBGZWR3b0dRMCtYRHJIYy9mTStwY0ZweFdo?=
 =?utf-8?B?RVVOTmZwdWU1d3p5dytLaElBeWNxbVZHdXJPYWZLd2ROVnpJZ1VOQndvWUxH?=
 =?utf-8?B?S3Q1SlY4NExsZ3QwYllkZmdEOHFPSUpEZ2RjYWp6UStZUmk4NnBhbkdnaUYx?=
 =?utf-8?B?Q09sUWdhYnVFcEVOeW03NGFpVFJaSzgzZEVocjJNcUNWalhuVXVSZ1ZRenND?=
 =?utf-8?B?b1UzSk5zckh0NWE5WnY5VFZ4SmVvdnZyOUNuZmtGbGZ6OUlYWCsyd1REY1lX?=
 =?utf-8?B?Y0R6MkFsU2o2aEhnNy8wS1lFRXJWYSt6eG9VbnE1dzBmeXZJZTZKSFVTV2Jp?=
 =?utf-8?B?YzV0cVhwZldMeXhYVEQvTGNsMkFnaGFFaXdjVm5tTWU5UE5iK1RSZVJWaW01?=
 =?utf-8?B?ZjZ3SWV1TDlBYmtwVUtGUHZKTEk1dDduT0RVTUF5SDJkWGZUcWNoVnpDa3I2?=
 =?utf-8?B?OEV4d1hRYUVucmxDVUFsUzRmR1FqbHQxVFI3RVpjY1VTTGgwYUtObmJRZDBL?=
 =?utf-8?B?YkYxckNpcC9kVDUwdkdRWmtCZXo0K0Vhd3BnNTYxVm1NNWVnUkxjUVRrOERS?=
 =?utf-8?B?em9xN0ZORldSSldOZGpLVXZpenRBcWcwVkJQQUVrdnZhSU1DZEt5SStTSk40?=
 =?utf-8?B?aTliWjdCK3FiN1ZtdWNWQmtYNTVSRmwyMnJyNFZ4SkdvZ0Vka3pkSktGcFFt?=
 =?utf-8?B?OEF2QllUOFQyYi9YRHl3YUlwbmlMMWRkR3lyMDIxUzQ2YXZHNnR6YWpuWnpS?=
 =?utf-8?B?WjV1SWIyU1pXQ2VSV3U1MmtsZUE0WThQdlpyMEFqT1RFRW9YUFgzS2hoU1ls?=
 =?utf-8?B?Z3BRZmRHQjV5ZmlBMHZYWGdOMzNQSjhmOWZ6Zk5mRjZHTk5SaFpVMWFkZDd3?=
 =?utf-8?B?ZnRHeTRTNWw5bWYveHM2NE1DWWZ2YmhlTStBbktpQWREUUNuaEJIT0RtTU80?=
 =?utf-8?B?OU1iWStKUTNSMnNRcWZoQlMvNWp0UGpDOUJCYk54cHNxOGJPL1VzNzBjenQx?=
 =?utf-8?B?SngvbGdMNmY0djNtcllpekRCNzJBSnVBRURFOUdHcE8zb0JZTkRGNk9Ydzd6?=
 =?utf-8?B?STNHN28rMUEvWWc3cnl6eFFGazZjdHBUU3M2WjR6dDRqRTVtSUkrbE1MVktt?=
 =?utf-8?B?MlNaODNTdHVOVkdoVVdzcDVPdFNIY3NldmtxUlgyTzlHRWZHK0Y2U2t6dGFN?=
 =?utf-8?B?TXZyNTNxaGFJQmZGaDNrTjhhQ2haMUphWXJsaFhsSVcxR2pibmIzbmRiRzBw?=
 =?utf-8?B?RllLb0I4bWFrUkNodkNYbWtlcElHRnZqUkNBZHRiZ2wrdE52VEpNUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05675813-cf5d-4286-f42a-08de94f74989
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 22:44:54.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YckUs804OrlR/FJrGb0vNnwtoiEjwN+K7JudLMV4Hkrmr0fceh4IAzMqlU5+DJD+UwdqwwyGh106etHHYNP0TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7682
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C16FB100002
X-Stat-Signature: s13wruwk446xhytjr53n5h995h4yeu4o
X-Rspam-User: 
X-HE-Tag: 1775601898-845780
X-HE-Meta: U2FsdGVkX18hc0vhWLGuHSPhTGmG0tl5cG6CxtvXJHqMuJJ7W3vQRytR1dG1SsDUS+TUrfJST5mcgxQ+zvc35nF5ZZADBOAAP3LlZ8CPyrBQEAGKsYz8jFkLU3g1pj7mxyYKP/FePS7buTvmyxV7kQb7gMuNUtQSVrF5lzE5r6wRMhtFfsUU68/Tg8TWiBP5wfsiBBRuQgrvhrRHeEvD+PoAx+h+eDr3mmqIGq67qqwRUy9sCpF4IRiQFrNpyzSOt399khlWFlokMOhCTaLE+zNBM/Tpek8b/h9ZwtOI0ybi+a6Zl1bSS2pCLgrUDny9bdWB7icIy6klwdMfb+IRdcf303NN6ZtiNdWuQuKJGhTFmOMvV/qwl/XafH44vP2a8mC7rs0G+13HIv/f/0NYA8waftfdZWHsUptGD7AS3E6imAbxWJN+IBWj4hcfCwYaOpkrujNI1ab7HRQ4RPASpaUackzEAXewZdfjWPkYdOXuw5ZXabMmvwKQ7OXMeXcI9lyXSCzy5BwxivPF3pO95NyAB5yhKtyVdag/0nDCcFyIvjnvCKAcOjK8fKbrYB46AoT8/C+aZhVDfTlsrTkPlFjk82w883gk8URdfhMZDrtjDeQEbFAioinZiwoSaVKIAf3n7Q75njT+vhVDhZDPUdl1xsxTjOIXcGMEsiOhuQNqNSMAu064XM2ikm3koflJYrLrMaOmEKYDgeDxDfEY86H4mQ/MCWWjkHl2CdFU6Pf+WlsiYho/7wHYIQTqLiKNgLBZVIyHSKnxPwHBHDyhOPDAlidB4RvaorpNt8VXT7xyNnKYeIK+qHBa9H6Dk64Sv86ybYfX7FgN4dlQGZ5XGtb9mF1dn76Url9AAdsXmnFpSbWLR0CTyhmJmoijxN00LMLjUc9USQid3WIgHRQe/B8VBPO/HSNE/cHGJHxREdHretqvnleRpqeVUvyPNNq+dkQ4mYl3jIq+7npjSyK
 zuVZHbqa
 G/CQaNngEl1dtXp6MC3jFy1zACEuDcQXPjL+5UXD6iCT2t3VXlO7J0jStyTpjyINlej8t21q5yaTI4DY3EuZ/bn5cTPux6TRhijvYEt7JDcLu4XIVRYye+rlyl7xGXzgOK7ks5kJtl+i6jN/HhmoxFs5uyM7DbdLmihHK2Ru9YS4OqOZaGsrrLukooDIla6oIQrIlSekFyW//nV5/STdnYgGjxSkfC1LbP6FM109iXQd6KJDJbkw5L2h29g1P/apc1H4A+16xWDrqy4BjIfS6ZQeIoFvb82v8S0i2Np5uzoUEhOYUlLQR8Kbweuztw3ZnfV06s3jD6slvS7oVpbWF1/LcSaaFl/iRsY6L3lMKITnEEdny4x8fe5wEpQhRraV2cEMBx7vwNUVDJecXIyU0Yzx+B7QGtkfcF12LpZo6++fbwmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 1:09 PM, Joseph Salisbury wrote:
> Hello,
> 
> I would like to ask for feedback on an MM performance issue triggered by 
> stress-ng's mremap stressor:
> 
> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief
> 
> This was first investigated as a possible regression from 0ca0c24e3211 
> ("mm: store zero pages to be swapped out in a bitmap"), but the current 
> evidence suggests that commit is mostly exposing an older problem for 
> this workload rather than directly causing it.
> 

Can you try this out? (Adding Hugh to Cc.)

From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 7 Apr 2026 15:33:47 -0700
Subject: [PATCH] mm/gup: skip lru_add_drain() for non-locked populate
X-NVConfidentiality: public
Cc: John Hubbard <jhubbard@nvidia.com>

populate_vma_page_range() calls lru_add_drain() unconditionally after
__get_user_pages(). With high-frequency single-page MAP_POPULATE/munmap
cycles at high thread counts, this forces a lruvec->lru_lock acquire
per page, defeating per-CPU folio_batch batching.

The drain was added by commit ece369c7e104 ("mm/munlock: add
lru_add_drain() to fix memcg_stat_test") for VM_LOCKED populate, where
unevictable page stats must be accurate after faulting. Non-locked VMAs
have no such requirement. Skip the drain for them.

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee73..2dd5de1cb5b9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1816,6 +1816,7 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int local_locked = 1;
+	bool need_drain;
 	int gup_flags;
 	long ret;
 
@@ -1857,9 +1858,19 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	 * We made sure addr is within a VMA, so the following will
 	 * not result in a stack expansion that recurses back here.
 	 */
+	/*
+	 * Read VM_LOCKED before __get_user_pages(), which may drop
+	 * mmap_lock when FOLL_UNLOCKABLE is set, after which the vma
+	 * must not be accessed. The read is stable: mmap_lock is held
+	 * for read here, so mlock() (which needs the write lock)
+	 * cannot change VM_LOCKED concurrently.
+	 */
+	need_drain = vma->vm_flags & VM_LOCKED;
+
 	ret = __get_user_pages(mm, start, nr_pages, gup_flags,
 			       NULL, locked ? locked : &local_locked);
-	lru_add_drain();
+	if (need_drain)
+		lru_add_drain();
 	return ret;
 }
 

base-commit: 3036cd0d3328220a1858b1ab390be8b562774e8a
-- 
2.53.0


thanks,
-- 
John Hubbard

