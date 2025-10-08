Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8537CCA476
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 02:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499E38E000D; Tue,  7 Oct 2025 22:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A798E0002; Tue,  7 Oct 2025 22:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339778E000D; Tue,  7 Oct 2025 22:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB0A8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:36:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEA3113AA1A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:36:54 +0000 (UTC)
X-FDA: 83973384348.04.A12453A
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010008.outbound.protection.outlook.com [52.101.201.8])
	by imf02.hostedemail.com (Postfix) with ESMTP id AC0E98000B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:36:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L0ZwCnr1;
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.201.8 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759891011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIv5yRqiWXKTI+JeU1jBqBScPFQs0tSUnZT3nnzTF2A=;
	b=sO6PP1UvBmU/irSdEqUbFQoPfrsXozOg7yj/S3DdglVMMSm0Aaz2JT0xAWNallYMTCY8CB
	hzOPAEboIMHBys2hOlOAldN4ui2YUzyAmmo6PFyAviqyTEyNjBU9wGWz+A34K7aQhD3+Bs
	pLYG5vLF7q4jeOvb6SSsgUbs2Y5/VZo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L0ZwCnr1;
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.201.8 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759891011; a=rsa-sha256;
	cv=pass;
	b=LSSSzfjOTu30u6pF1eY3zuZLlfsJNO6g0E5LghCYcNrurV/H/jhJVZC+CUbCd3MiH4EOEH
	SeUrwxF8nxfZZvRcORNcXWJnwH5mkZKrn9IGDYSHkVpQIi7UjWPA8MYuWewwnepRQTjAsu
	POPPZItVIIkY4phYIQigMDJAGSy1++E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=syeXihVyi3ywypD5duxtRpIoGmkATx39/laB73RyIMoIFn1TGuI/ehDOWYsUujSXVAjgWyD46dK83k3ISG9LFTznglTr/QjOf4zyjege9O89AFtjcfNcfRtWa8IRPCICfD1u49jcia702RfyOKnOjZK9/iEGAKz+b/gIO3U3MI4+hFN1qLZFoFj4JUrgWaeKjsx28bQowt12H+O3t23qhkD5QRofltyxdZ10ImPVgDi2k+1SHTkvPkHR/hK3OS74VxMROJwTsQAuTPkgwjodPnjkxiFe6b1FjQRKpwP6JzA3prBoSS5m5VMyser0pZjEp31OdOZ8W5clkweJDmzUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QIv5yRqiWXKTI+JeU1jBqBScPFQs0tSUnZT3nnzTF2A=;
 b=TKK3wOUI/Y4pXql5UzjcLczva4EOftBF/fmaf3SZol/Hgthj67KVfi3yCbujYv4bXl0gNND3Lx6uWgW68uOVEJLa5JvvzPxWOADPM5hTQmAKoNpXLgVQASQBK8dLDNAfPdp3btkDfzWgmNGfMLwNEc3GFGjPfQp94kA7HZqK5QgEOWXT93Z1adZiTrg8RF7aKdjjfPIFgiAOd3WSVUjlDan1H56R3omiZIMcVXqvrvkvoBnbhZNoGc0JUSkfsSRhr0nZAFk1ym6XBAI+MWUjCkw37U+Cck/5DaS18Cm/QHzU3s35xIQtc4+sEP+TUjrmx9PNVtXcy2cx2TXLZ83Yaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIv5yRqiWXKTI+JeU1jBqBScPFQs0tSUnZT3nnzTF2A=;
 b=L0ZwCnr1U4zRafhvzXnmdvc9jmmb71Kp04jlK3DQ3MDpkJq/5uN77r5y4T4tdw9lrXifjjW/vuzktG8mmt9wAPK9xclNtCOKn5VQ/1XCnyhrEFjP0x8EUXaTDgFnjxsB7yCa5VxplpOeG4TfcV4u6MUE3eec1rDq6CUFz1asugAVPpCuAFhIyagf4ghjRLK2G6lc73gXtJEtvp9bhS4ibj1S7f1OSthBzb0oGDuvzPCxbdXl+0S3V6j1IEQN9y+Kk2eyTqU7du1NVclP3w5p+oXwmwaZ2rCAPmEg69E7UuqfyPM/nxLLEWEuOVQUP0K/sbce2J5jvrgROdvFR7zf4A==
Received: from BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13)
 by SA1PR12MB7343.namprd12.prod.outlook.com (2603:10b6:806:2b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 02:36:43 +0000
Received: from BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4]) by BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4%4]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 02:36:43 +0000
Message-ID: <37092fb8-c8f7-4d9e-ba43-f2104e33f388@nvidia.com>
Date: Tue, 7 Oct 2025 19:36:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use enum for vm_flags
To: Alice Ryhl <aliceryhl@google.com>, acsjakub@amazon.de
Cc: akpm@linux-foundation.org, axelrasmussen@google.com,
 chengming.zhou@linux.dev, david@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 xu.xin16@zte.com.cn, rust-for-linux@vger.kernel.org
References: <20251002075202.11306-1-acsjakub@amazon.de>
 <20251007162136.1885546-1-aliceryhl@google.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20251007162136.1885546-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4116:EE_|SA1PR12MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: 73793c35-c036-4935-b19e-08de06138483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHpnWXlPaEZNVGlCbklCYmxnZzl6WWZRT2FPNm1RYXBHcUFZNjYraHZCT20r?=
 =?utf-8?B?M2ZWRTBmNld6L1I1VEg5M1V4M2ZnRjhnN1huUXdvdEF4aUdMdUNXeCt2SS9y?=
 =?utf-8?B?MEFSUGFlVno1NjExdndZdnNkM0N2Znk4elZWVVRzUXYwTnlBMzE4TEROR0RZ?=
 =?utf-8?B?WVlQbVhVSERzbjFlMklRaUk5RjNJRGZkSnA3NHlHV0pXaGxmWVZqREFEdUdK?=
 =?utf-8?B?Qmx4MTIxZE52SkJmVlZMeVEreWpId3FyRFBOY21jc3d4TnNsUEx6aUY2ZXBO?=
 =?utf-8?B?VnZSbjE3b2ovT2NFSUFxUEhUUlh1bHFaMFF2R0ZYMVVPcW1lakgrblpzN0gv?=
 =?utf-8?B?WUVVendwSXMxaGV2dlB1cWZXUGorL1UySjB5Slk3YmdYSVc1MERxY2tDREpC?=
 =?utf-8?B?RW13N2ZGMkdaemRhL3ZuZENvU1JzTFBNUllnRm1mTTlaWndDMTlUZnFmTnlK?=
 =?utf-8?B?aEZ0Rmg0ZDg5N0ZXR1hwckJpamd5VlB2S3BjSTN6WXg1MDMvamJCbTU4Zkh4?=
 =?utf-8?B?LzZQNGNxaS9oOEFDRkhCK012L0w4OURPdFg3U0psU2FRT0pOZllrakJZaUd0?=
 =?utf-8?B?TkV5YnNtMEZtNExEYVhZVnRqNVU2NHVSOFp4ZzVRdkJpNUlJZDQxWTVqckFO?=
 =?utf-8?B?d2MzMjlhZW1nUTNJUFM5RjRrL015amdnek5RRzFCdGZBSFZYTzVNMmpuc2sr?=
 =?utf-8?B?UEdXNzgzY21JWm85TG1WdUdqZUZqdWJITUVYNnR3d05CTEcvN3A5WitBZXkr?=
 =?utf-8?B?VUZMdWw5clJrQlZNbzRaUGVqbWR2VDlmUlJWTW9vTENTcnlmRG9CeGdwWG5J?=
 =?utf-8?B?UE5jNC91MHFmVmFiNlJNNzVPd1dVN0ZGdHVWYUpYektmR0ZaMXB1YnRqVEd6?=
 =?utf-8?B?VzF6WG9lLzgvWUduWmFOUjZhSnlyTFJObmp3elJYUEdyS1ZySzZGTEtHS0h0?=
 =?utf-8?B?WTMxODB2NHRFRlpvM2JmM25sMXNXTWxxb2VWdWRFMmt0dDJMbXdRdGovOHJR?=
 =?utf-8?B?SWVHa3cwalJ2RFF6eEhYbUdBenlYTURkTVRBc0RxeEFqcE1BcERhY3o0UGFX?=
 =?utf-8?B?SzU2RDJRV01CLy9Tdml6TlpuM3Rnc0hiYnNyTytEU0JHQkVrQVJtMFQwbkFo?=
 =?utf-8?B?cDhrQTlLeHJhYi9ZOVJSdkxMaFRLcThLa0lZT1RyQWhtUEhjb2t5UXg3NUlt?=
 =?utf-8?B?NWhvVjRBMGNILysyV0lqTC91SXF1N2pCbkhzV1VBR3VnMHp4NVpsV3c4RkJ2?=
 =?utf-8?B?Y2l4OGxncGtTWDcrVUJNMlgzR2hFMERYTThsTWg0blVRck5YdmFYUUlZSjN3?=
 =?utf-8?B?c1l3RDF5UXZLNUJJLzhoRWhZa2VzSzN2TVlJU3F5VmlORGdsc3BrUllwczli?=
 =?utf-8?B?Ti9RcHRLdDJnNUdvWlRkeXorbThXUXVEOTROM1IyVDRRaTFKR09MbEI4ekln?=
 =?utf-8?B?M0VNNVVCZnNZT3Jxd2thT2c4enhkQzFBWDN0MlZ1clJVQzlGaWpudXFvdlNF?=
 =?utf-8?B?WjhpRnNwSm53R1czQTljallnZjU1MnkwelhLOFpVczNaY3hDWmF0K0xUQ3N2?=
 =?utf-8?B?bUJFcTk5a2FqcnZ5V2UxZGZWeUlNUHpCS3h5aktxbnFUZzRnZmlpRFhpVVhE?=
 =?utf-8?B?UmhMOVZ1d0dvZVhDNUZBZVJFR3BRZy94Nmh5UFdIbUJxZ0JyWW05VHI4eURQ?=
 =?utf-8?B?dVZnanZ2NDM5MklxVEwwR1h2NkFIVkVlZ1JUQURyRThWNXU5K0ttMEw0VmdB?=
 =?utf-8?B?aUs0d0FpSjRCTXJqdkwyV3VxYzcvN3htZmUvbzI1NGwrVEZWRThXRU1WWmZp?=
 =?utf-8?B?cG9zSVdhN3NPVlBrRUJCbklTcHprWEJtS1lsczRYcVVRRnpTZk5CRjF2cVRB?=
 =?utf-8?B?UU5wY2pnMkJkUE5ObUU4QVE1dG9RUUFZSHFRSkhGUHNIL1hJNWUycTZMdGEy?=
 =?utf-8?B?bXh6b0pVUmNnNU93ZUhmMXBRYW5PUm5xWm0zUzJ2bmlSMFR3VndyZW1ncWdT?=
 =?utf-8?B?bVJpcEdscXB3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4116.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkZoYmdGbVhObER4MU13Q0k4Ym9uVnB2b2Z5VmFnLzJsYmo0dWp5S0plWGVx?=
 =?utf-8?B?NjhWR2lXd3FNYzlhWFZ4LytPWklVbkNta1lVakpLU2RwS2svck9kWWszcHpP?=
 =?utf-8?B?YVkrTnZKZEZKMXEvMXF1WFlWbzAvajJMb0xjNDJ3WW5vSWt0WW9weWxoR2RF?=
 =?utf-8?B?RStneEd0b1JENktESnFtZm9EeHdoV3JYbFNPRktVK2R2b2ZTeENyL3o3MnQz?=
 =?utf-8?B?cTIvOVZxUFRZZWc1RGtXK01aQzc4aERxK05JNTFobmVjYVpBMGx4MlV5aXdw?=
 =?utf-8?B?VXNMYml5cFNqTlpvMlJGdi9OQUthNnBZWkFOYUdFS2JveUdvaTBXbW4wakc5?=
 =?utf-8?B?cXRQaG9GUnVGdEtRK2VZOEJVYWZkaVV2RzByaFZONzQ4enI4SFdMV0gzcStT?=
 =?utf-8?B?clpZWUREV2RPTmdsRDI3d2s2dVorSUF6Z1hZdTRhSE9XZ25oc3V0Yzd0a0JC?=
 =?utf-8?B?YVplUStzWXMyQm1QczREWG1abXdBcHhJeGpPQWVBVEFUUm9Yc2dyVmtTYXoz?=
 =?utf-8?B?dytJZ3pjUHRGdkFoR2ZDR1R0R3VjUzNJYlNmdTRvaG9JbnFtZXE4MllwRU4v?=
 =?utf-8?B?c3JuNldwWHhBSDBQbTdjb3pKWFNOZDZXSzBTMjl4UVBuMVlFRE1Pb2VFZmFo?=
 =?utf-8?B?V1RKRHJQbUFybTlKS1ZPdDN1YUF5bENidHRVN0dybEtHWlI1b3dkeXVXVm4r?=
 =?utf-8?B?aHRScUVtekZrQkx3SUFkaStpcDVHNTJEQzhrTE1pTTNtVWdMdW1mODRydS9I?=
 =?utf-8?B?NTY0T1NYenZweFBnVkUvbXhINkthcUVRamdqb1FzNG5sL0Q2Q2xRUFNndUhw?=
 =?utf-8?B?SDVEVVNEeXNFdUlXS0VhMDRHeGJhNThHeFZwWWxhY1A3WEpMNmxhN1lBNVZS?=
 =?utf-8?B?bThUUkVCTnVUaXFiWHpNWkh5VHd0VVhHeDVoR3dVWTNXY1N0bDh2NjQxL1hQ?=
 =?utf-8?B?bm5NODFRYnBTNkQ5azJ4V215YlRaUHd6V0JnWmNyRHFaUmU5cUVtcE03RnJR?=
 =?utf-8?B?QmdOZnMySE5mRXpsOUgrOTlzK0pkSmY2VTlld3gxYmVXRGJYQmpBdHVLeThC?=
 =?utf-8?B?R0dJdnp5QkVkd1c3MFQ3eFd2Z0NEQ0FPUVNrNlpZa3FrVTlDRURSTmY4Vy9I?=
 =?utf-8?B?RFBxK20wSUZVaTNTcnVwZE1lUGpGR1dCS1QxY0pleVd0emxOYVJBRktxbllK?=
 =?utf-8?B?WjZWUTNPcnM4OWkwM3RpN2xWd1F4ZVBBT2NYcEhsZ3c0NDhUNzdTUURHYWVH?=
 =?utf-8?B?bXREZXpudm5PUTgvUmw3QlFqbnlrRDVVY3IxQzBoTlZ3cEhXRXN4aTEyVm1W?=
 =?utf-8?B?WHFxTWliY1V1YXBMa0FLZ3BvS2Q1RWg0M0FuSUI3c3hhdDJOcG5iSlhOd2E2?=
 =?utf-8?B?c01qeE5sZlFVUWovcjlyOE9TbkIwQjJBalVGUFl4WkRpQVk2TWp1b3llNm9s?=
 =?utf-8?B?TTlISVEwb3o5M282SVgzekMrd1ZkTGcwbjV5WHU0V2tHTkpIWnFrMnBSWUNV?=
 =?utf-8?B?NFZTc2drQW81Y2hqRmlsK3QweEovbVJ3Z1ZSVHNvMm1HWEh1QzF5N3FseFJ0?=
 =?utf-8?B?Uk9nMGpma0xQN1NHWkJJUXNHS2lJTnVHcGM4NlB2dGN0NmxrMVl0RWRIZHUz?=
 =?utf-8?B?aXhJQW1QYUduVWxOLys1WDVrc1k2Y2NwMDR1bTMrOTU5RXZDMFFyM3pheSsx?=
 =?utf-8?B?OFZ4bHF0dHAyaEdmdlM0ZjgvanpFWlVYK0VZMlZXNUhVbElYZjI1MGs2UTZB?=
 =?utf-8?B?VGdXNjMrMlJOcDVlM1VXVTBxLzFFV2k4aHBIcFVVYTFPcHJhNy80b1Z3d0w2?=
 =?utf-8?B?RmRHK0d3SjJsSlhDVWptam5HYlZPOWp4TTMwdGVkaGkrOUxTTksrTWM0UFBi?=
 =?utf-8?B?NWtqdzV6L0dVa0tJK3l5NEtSaW9PVWhpVGlRSmtBMEROcXhjanBHcHFuRW1I?=
 =?utf-8?B?S2V3L2JvN1cvSzZVMWRyWlNRNXE4RmxISWU5MXFxREJFRHpvQkhFdjVHb2pk?=
 =?utf-8?B?dlJiQlBWK2xQVEVKSW5QNlEzRGxSM3p2ZTVseTB6Q0RCZjM0azZkWWcyK1E1?=
 =?utf-8?B?QVErbW9JbHdmVGEySGQvWTl3dzE1THE0clJaYUlVNG5HbGlBdWZnUzloUHMw?=
 =?utf-8?Q?7ExRtDZL0Khu2A4PYumAUjk+t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73793c35-c036-4935-b19e-08de06138483
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4116.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 02:36:43.1893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5nZiw+/6iJYEpk+c2T5ah8tNG0n0CL7ru7yGAEp8N3oJJpNprzu/9/QdQIcDOGsHYhpOXMZK7Bf5NiMN8hX/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7343
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC0E98000B
X-Stat-Signature: y4dhpyryrz5438ygdq5k3ex7n9gakd51
X-Rspam-User: 
X-HE-Tag: 1759891011-628964
X-HE-Meta: U2FsdGVkX1+gEnbD+JUOb6qXo09602zjw7zyKI/ZhdvXF9sAa67ReRHfBATo5HtxCVCk1nmrVCaYOajbYGZ0yOmJMZz9wO1x6a84sWFlsTtvvtUzAdV0efxAzW4fm5FyXcB+GyBr7Drj9+qAlmlC2fu/l6VJ87itsFPjOXEPTD4afYcihtJHpwUlwTkI2CeHn403RjElKn4I6fVuG1K+fI0lGTbPgSHVSmYS5zuV8aGoU0TiZl3t6ArOsNVAX4NDt+19rZh+9fcGvmO7JG+nAQslDAC56up3z8EkY5DYolyMOCVU5cap5Gf7zRmSTUaNVHXxBf/DCmWkTtfZibJpe4PDeqTfgn1tYoFCfddlk37MRkiqsxi7Ub8eLOaVxFzYc8xUfpI/x49TfkEJ7JTrvcxTpFfEJSXZ65ymbfmLW8TwSzHxsw9d1aWOJyMW0nngH28hdRmrJyFBIZbAgqKXFKHTXcmK1hhR1D+UbrlNaW2S7vjc1ddsKEMCrOI3P7PYjclwokkRZnupZA9+D5rFsriwpIgkLjkxuUbYREH2eql8NRq1cKHuZYzTTiUP4mhdI73KuMtru5BC65EjsSzuFKjqS0mdLYe8W3cLNVOMCFCUQ/VITWGXzYildwYmIR+OOa0IsstFuPNaL4VG6v4R1viKUPnPkOWz+QJ4Fvz+e6HpbIBjkELSou0ozmyy/gmSmfklbh9hUnvY6cnrPfUQ2gm6ns/z685ZNwSWbPNp/C/MX47lxzqkbTm2Q9vvaYO4rwDcNXfbt3CLwzZGWHXuAAgaKvthJ6jqkFzAbIjXRdnI8QqFc7Jzi0KDZ5IS0ERu2xYUZNCCSycfZzB7gPzvvP0QUvEr68+bD/BihwdDq2byKHBHine4UvT8QxHApDH3XpDeU5ra3fxShUN9pm9mZmMyO9eyDZmYrtlLVBXBcskINHtICPYEMnQzYJgFNQipIRA7mjIg8Te00ImMmjh
 XLbCb5OE
 dJOVHpEV1j7UtwKQVqd0Mzv4N257LZ1tZK7VCOPT0NEf1nP38/I4jD8kgZaSO3qkABTdgsdsPdoNNmwjdEWbVznHWSxVqVhZB1+SkQE0TYs64aqutW3vjc0rdpo3O1097xA84kxByd2i4lRl5Nd4aRJUhnOX1Mbw5tDSwvoPlN2IzSPwnsEc/y6TcJ5CPJmraWMK1dOB3UfqoBL+F/LKT5NhUQmzMoU2buhgDcchNwp8JhhG36QnVSyLPRO3vSniexn/SGTwpejdOqxtqGAzWUw9Voo7tX/1vAJWWA4YXP5iiJx7JR8p3+XMxU1wUs9nlCgCoB2L9JM53EWLGalUd255VGWDCz4BrdWz1IPgWBHHDxlTSgQjQaiKsiuhTgvTBmZM3dHW/pLHr17QNNk35i2XAz5Y7exLqewk1nnh7uu1dSFrqSehqk4n7jpntuXuWcksMoIijCB/20OoeSb6Amd425fWdg8w/dyGioCVttdSGeNSE9u5gziCcGC5aDO+FnrScGf9xGOQkYegaRxydSrPwEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/7/25 9:21 AM, Alice Ryhl wrote:
> The bindgen tool is better able to handle BIT(_) declarations when used
> in an enum.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Hi Jakub,
> 
> what do you think about modifying the patch like this to use an enum? It
> resolves the issues brought up in
> 	https://lore.kernel.org/all/CAH5fLghTu-Zcm9e3Hy07nNtvB_-hRjojAWDoq-hhBYGE7LPEbQ@mail.gmail.com/
> 
> Feel free to squash this patch into your patch.
> 
>  include/linux/mm.h              | 90 +++++++++++++++++----------------
>  rust/bindings/bindings_helper.h |  1 -
>  2 files changed, 46 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7916d527f687..69da7ce13e50 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -273,57 +273,58 @@ extern unsigned int kobjsize(const void *objp);
>   * vm_flags in vm_area_struct, see mm_types.h.
>   * When changing, update also include/trace/events/mmflags.h
>   */
> -#define VM_NONE		0
> +enum {
> +	VM_NONE		= 0,
>  
> -#define VM_READ		BIT(0)		/* currently active flags */
> -#define VM_WRITE	BIT(1)
> -#define VM_EXEC		BIT(2)
> -#define VM_SHARED	BIT(3)
> +	VM_READ		= BIT(0),		/* currently active flags */
> +	VM_WRITE	= BIT(1),
> +	VM_EXEC		= BIT(2),
> +	VM_SHARED	= BIT(3),

Hi Alice,

If this approach actually works, then I think it is a reasonable
trade off, given that Rust's bindgen(1) is not going to be able
to help us for a while.

In other words, a small change to mm.h's format here, to avoid
a messy sort of "forked" copy of these over in 
rust/bindings/bindings_helper.h, seems better overall.

At least, I think it's better. :)

thanks,
John Hubbard

>  
>  /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
> -#define VM_MAYREAD	BIT(4)		/* limits for mprotect() etc */
> -#define VM_MAYWRITE	BIT(5)
> -#define VM_MAYEXEC	BIT(6)
> -#define VM_MAYSHARE	BIT(7)
> +	VM_MAYREAD	= BIT(4),		/* limits for mprotect() etc */
> +	VM_MAYWRITE	= BIT(5),
> +	VM_MAYEXEC	= BIT(6),
> +	VM_MAYSHARE	= BIT(7),
>  
> -#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
> +	VM_GROWSDOWN	= BIT(8),		/* general info on the segment */
>  #ifdef CONFIG_MMU
> -#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
> +	VM_UFFD_MISSING	= BIT(9),		/* missing pages tracking */
>  #else /* CONFIG_MMU */
> -#define VM_MAYOVERLAY	BIT(9)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> +	VM_MAYOVERLAY	= BIT(9),		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
>  #define VM_UFFD_MISSING	0
>  #endif /* CONFIG_MMU */
> -#define VM_PFNMAP	BIT(10)		/* Page-ranges managed without "struct page", just pure PFN */
> -#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
> -
> -#define VM_LOCKED	BIT(13)
> -#define VM_IO           BIT(14)		/* Memory mapped I/O or similar */
> -
> -					/* Used by sys_madvise() */
> -#define VM_SEQ_READ	BIT(15)		/* App will access data sequentially */
> -#define VM_RAND_READ	BIT(16)		/* App will not benefit from clustered reads */
> -
> -#define VM_DONTCOPY	BIT(17)		/* Do not copy this vma on fork */
> -#define VM_DONTEXPAND	BIT(18)		/* Cannot expand with mremap() */
> -#define VM_LOCKONFAULT	BIT(19)		/* Lock the pages covered when they are faulted in */
> -#define VM_ACCOUNT	BIT(20)		/* Is a VM accounted object */
> -#define VM_NORESERVE	BIT(21)		/* should the VM suppress accounting */
> -#define VM_HUGETLB	BIT(22)		/* Huge TLB Page VM */
> -#define VM_SYNC		BIT(23)		/* Synchronous page faults */
> -#define VM_ARCH_1	BIT(24)		/* Architecture-specific flag */
> -#define VM_WIPEONFORK	BIT(25)		/* Wipe VMA contents in child. */
> -#define VM_DONTDUMP	BIT(26)		/* Do not include in the core dump */
> +	VM_PFNMAP	= BIT(10),		/* Page-ranges managed without "struct page", just pure PFN */
> +	VM_UFFD_WP	= BIT(12),		/* wrprotect pages tracking */
> +
> +	VM_LOCKED	= BIT(13),
> +	VM_IO           = BIT(14),		/* Memory mapped I/O or similar */
> +
> +						/* Used by sys_madvise() */
> +	VM_SEQ_READ	= BIT(15),		/* App will access data sequentially */
> +	VM_RAND_READ	= BIT(16),		/* App will not benefit from clustered reads */
> +
> +	VM_DONTCOPY	= BIT(17),		/* Do not copy this vma on fork */
> +	VM_DONTEXPAND	= BIT(18),		/* Cannot expand with mremap() */
> +	VM_LOCKONFAULT	= BIT(19),		/* Lock the pages covered when they are faulted in */
> +	VM_ACCOUNT	= BIT(20),		/* Is a VM accounted object */
> +	VM_NORESERVE	= BIT(21),		/* should the VM suppress accounting */
> +	VM_HUGETLB	= BIT(22),		/* Huge TLB Page VM */
> +	VM_SYNC		= BIT(23),		/* Synchronous page faults */
> +	VM_ARCH_1	= BIT(24),		/* Architecture-specific flag */
> +	VM_WIPEONFORK	= BIT(25),		/* Wipe VMA contents in child. */
> +	VM_DONTDUMP	= BIT(26),		/* Do not include in the core dump */
>  
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -# define VM_SOFTDIRTY	BIT(27)		/* Not soft dirty clean area */
> +	VM_SOFTDIRTY	= BIT(27),		/* Not soft dirty clean area */
>  #else
>  # define VM_SOFTDIRTY	0
>  #endif
>  
> -#define VM_MIXEDMAP	BIT(28)		/* Can contain "struct page" and pure PFN pages */
> -#define VM_HUGEPAGE	BIT(29)		/* MADV_HUGEPAGE marked this vma */
> -#define VM_NOHUGEPAGE	BIT(30)		/* MADV_NOHUGEPAGE marked this vma */
> -#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
> +	VM_MIXEDMAP	= BIT(28),		/* Can contain "struct page" and pure PFN pages */
> +	VM_HUGEPAGE	= BIT(29),		/* MADV_HUGEPAGE marked this vma */
> +	VM_NOHUGEPAGE	= BIT(30),		/* MADV_NOHUGEPAGE marked this vma */
> +	VM_MERGEABLE	= BIT(31),		/* KSM may merge identical pages */
>  
>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>  #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
> @@ -333,14 +334,15 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
>  #define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
>  #define VM_HIGH_ARCH_BIT_6	38	/* bit only usable on 64-bit architectures */
> -#define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
> -#define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
> -#define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
> -#define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
> -#define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
> -#define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
> -#define VM_HIGH_ARCH_6	BIT(VM_HIGH_ARCH_BIT_6)
> +	VM_HIGH_ARCH_0	= BIT(VM_HIGH_ARCH_BIT_0),
> +	VM_HIGH_ARCH_1	= BIT(VM_HIGH_ARCH_BIT_1),
> +	VM_HIGH_ARCH_2	= BIT(VM_HIGH_ARCH_BIT_2),
> +	VM_HIGH_ARCH_3	= BIT(VM_HIGH_ARCH_BIT_3),
> +	VM_HIGH_ARCH_4	= BIT(VM_HIGH_ARCH_BIT_4),
> +	VM_HIGH_ARCH_5	= BIT(VM_HIGH_ARCH_BIT_5),
> +	VM_HIGH_ARCH_6	= BIT(VM_HIGH_ARCH_BIT_6),
>  #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
> +};
>  
>  #ifdef CONFIG_ARCH_HAS_PKEYS
>  # define VM_PKEY_SHIFT VM_HIGH_ARCH_BIT_0
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 2e43c66635a2..04b75d4d01c3 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -108,7 +108,6 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
>  
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
> -const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
>  
>  #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)
>  #include "../../drivers/android/binder/rust_binder.h"



