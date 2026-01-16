Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5453EC982D4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B265F6B00A0; Fri, 16 Jan 2026 11:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11486B00A1; Fri, 16 Jan 2026 11:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3856B00A2; Fri, 16 Jan 2026 11:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9015D6B00A0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:23:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FE2B13980D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:23:36 +0000 (UTC)
X-FDA: 84338347632.21.16C5FD8
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012062.outbound.protection.outlook.com [40.107.209.62])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2D83E80009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:23:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qcEQqT/M";
	spf=pass (imf30.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.209.62 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768580613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRmbW0dLBnsfSJIiK1b2rPPufs5wHHzP/2/SdWkT8/A=;
	b=N3e+PhrzPgjyjUVW2rHXY6r1sQovdTK14TlLtAVjtDdrcIH0S1DcIRzQnvvLSsVCkMi5vh
	gNMUkL3D/TdnByzlS4qDZcUp8JreUcPAGXsb8SlUugIdw5gC+7XKh0expUT8ZEsJSwPYvU
	URFt0a12G1epNZ52SW1F8sH9bTv4Qqw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qcEQqT/M";
	spf=pass (imf30.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.209.62 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768580613; a=rsa-sha256;
	cv=pass;
	b=KEX11/Ctp9bi/F5W+LsmDn7DvqJPtHXRvQxcvXVdTOKqYCtSChqdFXTZWg0knNeLhm5hz3
	i/HlWeKNBwEDJg7wlHg5f0wIatanFZFHlPh/zoYIUtnytucvAc63/YBsrBUqv+UNX9WhKK
	AGo9Vfx/PJ5BcYfH2jUnROxp5PPk/T0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZ422sjCeNpaRSAEeLOU3/hY4Ygwxwu3jP3QtTUt8DexUU7M0NjLXnRr+DPfP8Red7ZvmAwRyTqWp/x+4/2UN7/pyYnyNC1aBptNRXv3Luv9AO6dysZXhnaHllGfVpzL61u634Sq57zF17JhepfydsFhqgzodZ/MTahZ36aXgblkQZHRifbOSfnGkHQgWt1kMWDq+gqc1xHEHqq33FllDOIvEqvMqdStG8Sla7OHem0o8aEuihUUwZ94Or11B+dg3G2GXoMsdfxkrHqzjSppoPR+XiHEQi0b1h19JMbhHEE8iMF/Uy2ruSo4j93eSHy5GiisBRIkRhxgl1zT6R/kxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tRmbW0dLBnsfSJIiK1b2rPPufs5wHHzP/2/SdWkT8/A=;
 b=u0bESUEINMi1ewVa6L46SZW01wx7DHvQvd7GbdoCS/woY4NQLlXxRTSg1JrdAdiYp/1VlwkqZClszySvJrS/GlRDrUNSGoe+dk3/ec6lv5OY1qCtLvCyUmBt7aWivDtPe7E7Uh8zg92ZuGn1ZoALxfph66Axb0LabHUQsjpCVaP++BBzyk49m0P6biNOkg+oCYReVPUmv2hVfg7iUUu33w2xwOZfw+37b8aVj3dO7YGtsvrr3GRQJe+HFHV4f7xwdCS5A2NVFj/4y8Dqkc5W1jFvIHD+uh+XlIXl57v6jvvfdbaCkT0H9pj+qGLh6c96ieR1diAPBl/En79ag2qzvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRmbW0dLBnsfSJIiK1b2rPPufs5wHHzP/2/SdWkT8/A=;
 b=qcEQqT/MJWu1Xluzbgu76PIkJFb8bO+Q9XCMM72XXDXMuXBFUwvStpzdkpdauar4o4Q0lvWr6ZDd5whFS8Vl4z5lLfSBOWeX/VIT4jnxIFNHBXRRq+MR40Vrf+8s/U/c/1+G47bBh5Jyav4qg+A9YGKqxzmK2Dxycbnehwm9ygnejB6+MKid58QepVlwfnvodIO2oNQt68VkIFnDER71bwY/Kt85qMs0tGzIxHxTOzXjunt7nw0mVn27ycuZ4Oyw0YrArutEMXc/WK9L5hGqnlyS6YWpQ9nC6tXjDwlbWJJkXaorUV613m+japGoh4p2UidcwcsIribPKIhDYKIe0Q==
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by IA1PR12MB8262.namprd12.prod.outlook.com (2603:10b6:208:3f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 16:23:28 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%5]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 16:23:28 +0000
Message-ID: <ef39d1a7-7f13-436d-adcf-cefd7cd854b4@nvidia.com>
Date: Fri, 16 Jan 2026 11:23:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] rust: rcu: add RcuBox type
To: Alice Ryhl <aliceryhl@google.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Andrew Ballance <andrewjballance@gmail.com>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-mm@kvack.org
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <20260116-rcu-box-v1-1-38ebfbcd53f0@google.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <20260116-rcu-box-v1-1-38ebfbcd53f0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::22) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|IA1PR12MB8262:EE_
X-MS-Office365-Filtering-Correlation-Id: 4394ae40-d50e-4327-6100-08de551b94ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2N0WVFrUzZISUNpcjRDeHNCNFVZaHUxT0RLVGxjc1BBc2w3YUgrQ1JLMm44?=
 =?utf-8?B?VEpvTS9PTEpZc3FxaWQ3TjFYbHV0R3h2WjJUUklaeUh3SjBYbTRUZG4zK2hB?=
 =?utf-8?B?SzlIeDBleUdxYVZSNnMwWmdxUnorNUEvVmRCNGZqTG1DaVkyam5hZTFiZVpR?=
 =?utf-8?B?T3gzVW5BN3lLYXV5Q2lFZWRUZXVRbjR2eG1RSG9LRGxmL2t2dWl3cW1GenY3?=
 =?utf-8?B?dkRLNUFQVUk0SnlpdHdNdmJra2RMRXI1RFlIS1U1QTQrUldZSkFkOEIzSlZ4?=
 =?utf-8?B?UlZlbUUwRDlOZnE1WWNBN25YTFpsVGhKQW1ZZGl1S25vSWFYZktkeXdaLzJk?=
 =?utf-8?B?dnZlZ05JVUZxWm1SQ3NyeW5zelVNM05BL1R4dFJTY0tIZUUzUjZYRUdqUFJl?=
 =?utf-8?B?NzNpWVRFRnI5cER5ejRlczVHSUI4Z09qY3kxc1V6UUdHbEdteVdGQnBIa2N2?=
 =?utf-8?B?VERHSThBLzhQZmNMZEpzTGt2bC9TNWFTU2FmRTBjVkE3V3ZWNUpYQlBBb3A1?=
 =?utf-8?B?NnlvVnBMUnp3eWtydzE0UytZYllaeC95cmVrNmFKMmduc0ZBS0VzbWpNd3RL?=
 =?utf-8?B?bklGRW9jakVVY0NjN3p3N1BNd1BGSnpnczR2YXlDR1VFU01YTjI5VmZEVXZz?=
 =?utf-8?B?cFcyc2NHRHByNnk2OXcrd2dMOUZZcGhScE5SVVdMaDNhcWpIZnRzZjhNaGJB?=
 =?utf-8?B?bjY3QUxvWVYwQ1pGNzR4QVg5Y0U4OWowSmFFTlJwVkhGcSttNERsTU9TWkhZ?=
 =?utf-8?B?a0o3ZXM5aEhLeTMxZXNHeklndlhIMjlVdmFiVHNMSFFmQmovYmg0M2J3Y09m?=
 =?utf-8?B?NTB5djkvZDNRVWtsWjAwVWpJM3Y2SiswUDd2VkpSaUhBUWk4MWpCMkl2K1Fs?=
 =?utf-8?B?T0dsL2ZHamxMeTNuc2Zpem5sL1NGK2x5T1AyTGN2dUpSYkhrOXBwTStwOC82?=
 =?utf-8?B?ME9iekp6Q1ZsTjN0eW43akZBRXdia1NTYXB6a21USUVKWVh3TUJSME9zelkw?=
 =?utf-8?B?dXJBOEppRVR0NU1DUWFaQWVZU21adW5rZy9FYkdJOFBKbDMyelJUWjI4Mm04?=
 =?utf-8?B?V3ZWUkdlRTJwVVRvRjdjMjFNSTc0NXFpaVY4cGJPbS95ZnduVEVNV1hCS0M4?=
 =?utf-8?B?NHlJaC9pNnNLK1NtMThicVhUOXNvNDdPWEZIMWxxLzFmNW1xcXE2d0htZk1L?=
 =?utf-8?B?UGIwZE9zTzVUbEMyRE10TjhtTXdRbzRRc0RHUkZtaHNqdjFpL0Rid0taeS9M?=
 =?utf-8?B?dEV1c0ROMERSb0lmTFh6L05ZcE05bDd3YWNpdlZjb0dQdTVTeHkxNzdENi9i?=
 =?utf-8?B?c0tReVVGSnlhWkxnRFRGYkx1RExNSC9ONEZ5Mmp5eUVCUy85d0pOU1QxKzRO?=
 =?utf-8?B?ZCtTMEdZUmM1ZzRnckZXRkUreXllVTZpbEdTM0ljN3VNRy9WQTFSK3pXOEFu?=
 =?utf-8?B?RHFHeHpUUzAwYno1aldmdi81MzQ3OGx4OG54S3g1dXBScHI2T2s3WVVTb3Rj?=
 =?utf-8?B?MGVhSTRoYnFPbHBCMEw4a0xMS1J2c3VXT2xXT25LMVM3WjlpQmJjS1N5SjM3?=
 =?utf-8?B?bjFVUXM3MzErRlVwa1R6OXRRdm41V0c4S292SjV3MTd5QkJudERMTmI2VXBK?=
 =?utf-8?B?NmJIOE1hcExTS3N3d0tyUm5qcHJtaVlETG5kZWFyaGdidU9FV2hpSS9KKzBJ?=
 =?utf-8?B?SGtzTk5sL0pmL3dZL2cxM0pMSVQ4SmxnZjdRcnc3UWs4YlRDamZwRGxyMzBF?=
 =?utf-8?B?enViM3hXcXhvN3JrVGJ5U2dDNC8veFljWXdoK0RMT0NiTlBDd1BPNnljcmZ4?=
 =?utf-8?B?b3JPR3RTSk5mS1o4QmNVMWI2QTZQVzVzS3ZxdGZ2WGViQ2JyMEZxaGRoMHhC?=
 =?utf-8?B?YVB3L1RyTCs0SWdjelY4YVZGQnJaa0JqQkQwMTRjU2kvNlBDbE1XWXVsZE5L?=
 =?utf-8?B?Uy9wbitRMjBRYTJ5WVY4SUd3QlI5b1ZaM2NYN3Zxc3A3dkxKNU1VYVpORzRa?=
 =?utf-8?B?UW1CRXg3czAyb01ocnk1TitqNFlCcWhZU2tjYmEwTHh5QXNRaGcrSXl0bWdB?=
 =?utf-8?B?MTE4TlRyQ0ZhdzJvNlJ1K0EwRGQ0ZDBPK29kZVZTSnpnUnhJbmYxMmFGb0tL?=
 =?utf-8?Q?9f04=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkVmRFVnRFJxd1JzVkx3OWJMNlpLVERVdnYybXI1Sldoejlya2UwM1pSNGxR?=
 =?utf-8?B?Y2tNMzAzL2d5ZDlnYXpUQzhJOW1DTUVLTWpucUtQUnpFQjlmQXBVWVVhQ0VW?=
 =?utf-8?B?OUlTd2UwRFR1NFVxcVk0dC9sT3kxVG1HWkc3UHJDTkNjUGtibm1NN0VDQ0Fy?=
 =?utf-8?B?bmdJdUxHMFFHK0hwOGdMRW1OK3AxdTJUeEE2SFVmaHRUTFVuWTJ1YTlPOE5v?=
 =?utf-8?B?WFQzNkpVbHN0YVdoNURoSHFtVXJjSGF2dWE3NlA3RlREL0h4M3lJczBNYStE?=
 =?utf-8?B?MU9nWTBPOFFSQUl1NysreEdLTWg2QVAxSk9hMFFiVEZNMXZxbkpiaGJaTmxG?=
 =?utf-8?B?c2tWN3lmTDJjWCszSmhaZkRlZUpxMnlLb0JvNm05dWZhSmgxRzd5MkYwNlhB?=
 =?utf-8?B?Uk1nUzdvQnFSVW5jRmVpQndOZEVoVjlvWERUUTVTd2YxaDdBQ1lsbXdUSTds?=
 =?utf-8?B?SVowbGltR0FIMjA2S1NGdFdWd0hMckMrbjE1U3NCOGRtMXhCc0RFbmM2WW9Y?=
 =?utf-8?B?WUxlczNHV3lXbnVoa0tKY09FSlhKZjlGVFd3aGVhYW10NTJucUZwVVpCY2Mz?=
 =?utf-8?B?dEh1V3M2RE9NazBMbGk3cmp2cy9FdktyYjU3UWVMSmJHc2QwQ3ZQek54Z29Q?=
 =?utf-8?B?aVlER1FRSTRpdjJOK3lGb0JzcDRnTlVvTFZHOFBBdDBUQlVJZHJFK2ZSaCtT?=
 =?utf-8?B?SUp0NDRtMEIrLzIxRnRQVFNDNEJYV0NPRkVUb0xQdkUwREF5UnQ5OWRSWG1h?=
 =?utf-8?B?TWIxUjhLb0hGdlNRcmNFS1dOdGJtTVgwUEk4ZnpoWGQ2cTVnMmRObTd2cW9h?=
 =?utf-8?B?QTVJRjZSclM3QlkzQnVBQlE1U0t6MkxqRldQMXdKblRwM1dvcWJjeEdraGYr?=
 =?utf-8?B?eHArWWRrMyszMVZ3LzlVM3JCaE9GQlptYWtkSURHM2JZWXo3TE0waTU5RlJO?=
 =?utf-8?B?b0Q3RU0rM0F4cG1KZzZMN1ZxbE5DeVZ1bWhMOEhqRmpHT2xMU0lzUk8raHFM?=
 =?utf-8?B?SnY1a2pJZU9FcGZJTGpOc1YwYWpsWFpBOXlyU083clhyb0xHVDdabkRycW1D?=
 =?utf-8?B?M3V0dldXWjhJcWFZYWtOaXkzWW15U0N2VTM4NHZSUHJoOVlxQng5MVpIRU1v?=
 =?utf-8?B?SGoydkx1OHVzNGF6OE1qVWZzQ2FRbjRPdWp0QlJJM0piNEYwUGl2VHBIa284?=
 =?utf-8?B?ejYzWGhGdTJWWkJpWitlK2ZrMXdCTEpPL2JpVXdNSmFyOG92UlpydUZDWnQ5?=
 =?utf-8?B?TmxyeXZ0ZGt1eWxFRm1zaVMvYUVndkcvejVyVzkzMjh4aEFnYzZsdGJQNlZm?=
 =?utf-8?B?UnpmcFdLeWFlQlRaZklqYUdhSDN5MTlkLzRicEUyQ2ZNSmJGc3JhLzNqSlZT?=
 =?utf-8?B?c3BXRFZldy94YnJLVEdJc3V5UFZrTDJzbkxzVjBTaXpiZ3hUNk9YK2JwMkhh?=
 =?utf-8?B?QkpqNUs5MXpINXR4SW5mc2tOUzRHS202ZTROWVNkYTRWRU5XU1VobExFN1Bq?=
 =?utf-8?B?MlpybDJxa0hwMm94aCt5dXYwNUh5aXRoRmlmYkt1RzBHVDJuSWNBcGNZcUNl?=
 =?utf-8?B?N3ZrSTFSRFBlWVovTHpWWDRFbzZBMEJJNGxZQXNuY0tZbTlYUy9rMFIvN0M1?=
 =?utf-8?B?RnJ0cmZTeEdpeUlmQzdXOGYwb2tsTEpPWk1FVlVRUmd6K3RjTTBMWmpsdTZi?=
 =?utf-8?B?SG1UQzRiSG9QK1pYOEtHR0RMcmVYRExneVNJTG1Wek9XT0JNb0dIbEJjNWxY?=
 =?utf-8?B?Q3U2U1JjZUUzbFJOaDQxc0N6L0Ixb0Z1Ri9Kd3B2RGxlM2dvZVdhc2dRRmFl?=
 =?utf-8?B?WUxJaUNoT3B1Z1hQVXRZOHk5cEROSVJocHBIM0pPbEJsWm9uWlFHZ28xRGUy?=
 =?utf-8?B?ZEJNSVBXc2hDUkpZMXJnNU1UMVNPSkpFU2pDZ1hHeXpPRkJjbU1FMFVkdmZB?=
 =?utf-8?B?eSt0MzZJWkJwYzJaanhZeHJuWVF6OXhwcVN5K084ZU01TTJ2N1RmV2FQdnZP?=
 =?utf-8?B?T2pkLzRRRzZ1SFcvYm1jWGFnTHk0L29hS1hJbVZKQmZQK3BqN3Vnbnk5OGRP?=
 =?utf-8?B?bE9EcGdzbnRCRkxwWnlDeDMrSk8ycjY2eVJnVVM1WU92SndGdm8wUHZJYWNl?=
 =?utf-8?B?T25UdDZmYlJqbEkyMTBNbmoxdC9uTkd6RDZOWlJHeFpLSWVaMEhGRHBTVkRZ?=
 =?utf-8?B?a0MwM2RiVG1IVnVrSXRjRmVNNm5wRGlYMkZ4emF5SWsvOXNFdGQvcEppMnF0?=
 =?utf-8?B?SE1WU2VaR1hiK1VVejAzWDBBNVJ2OVZGajBiSnZQdWg0UiswT3VaNjdqQlFq?=
 =?utf-8?B?RTV5RlRhbnp2allsVS9rdENNbkRBSHZNRWdQN3BJYlJxRTNySm1qUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4394ae40-d50e-4327-6100-08de551b94ab
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 16:23:28.2108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuA18tTVXfkMLHKqRl6H0XaN4sqZM5JdrR7hw/bnmWtdhgOMFff/uSXP9fvkkRgrZKQPyUPNuJqVjwSwYux4Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8262
X-Rspamd-Queue-Id: 2D83E80009
X-Stat-Signature: ga48i5g3am47hou4uj1s6dzepzhg4yq1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768580612-401488
X-HE-Meta: U2FsdGVkX1+oH+/nsjgkaL/UfuwPaKCICqp49p0HmY6tjLk+EYo/DTKVVXy6XGalEDyjJQS+7jv8rXY14VcYcG3CXc4/LtiifWAzEMOT/dmQIeNFYRFrmpmIT4nSG46UDb6JsCK8WN23SLN93DoqCCIpBV8tpJSGfk7BrYRmu+Nl6kpo9dnX90rxFkTnDJXfmFKhBXa+7s1EDVFSCPCSz8pb5zA/oSkDRCpwuyUi5glEEQLRR9mMqOROZrAb/vpVw+BhahvYTesssxXxurDokiDVtuXgwOIxop4Oz8BxKvTGq5CKmRYFC/XmaRSqwHGyylm+qWtvE0PGIeY9jPjUXKTMwaZYQ7s0LijcDlcpHVf+C3Z0aeEJ+GAC2mBwQochnvCVfntS8DNVy9vOaFSgXqOmU6SSgWZseDKW4uwDFv9acqv39W0NcQo73I/kfhj/MXewdDoYrBBrB8pq/S6pyfhvor1U+pa5cttksPz5ApqkWt1kDSDvFgB/7bHVjSPOKXwcBXtGV3rE22G2yattWsZZFe3r4BUWdhFZB3CyktgxFub6pLbxt6dK/Ip1PuTJ7NimFMmM5Kx06qyETl1VQTd0s2O5gycRtDbhxTmlwtnUybQg6cIsl5qY7yt+9ZsOYrAxKamXyCla9XN1p89m535ZG998F04A/Q+PG+2IdlJjG6g9pae1fUov0zbXqteUJDYzJBfLl6vVAL7AoDg2+ZQAsSwDkCYX1+61K97n2PTaakJSdF0SI9V7BVUNkxYcx9w9MbYNsL7giMGsXsjysbskS17xHlzyIxFuVpLvfOAMWM2/0TJ50kcM8q/avofM0gAY0FZJrMRwFvojKqzzyBbmDKbBezWM//fYOiy5/BKfzeBPvBHCjxq9b2dMT1STKaFuhwCmv0x/ukRb18Xp10N4J0BAycD1ttFIrlNxJKI+e9nZ8DuBQ5dPoSpjB5cEE5wwtZ6Lj37fbqNMeIc
 f243oIDM
 iuQ8zEfFSmpG8xMUd6jHRLxD02OCAlRfoo1yQDNSff5WWl1VYt3cC8uzTW1FOcP1rrdNotP9UVFvx3HmArIQgF8j8wEz4BtXb0RDXNXk26IpduNyTGHEF+Ib90ezTbRAxYukNYb44kJMF+j4QPVEvB0ZkOkAEyj8sKyBT09JaXBWUU8C3Ry28G3Yxhji7KIubEcaZdQQgDTdjlRYHKIt5wtTWe3uCbrk7A0+67WlPb8VnpAeZP7hr7AIHbFuyxrKbZR2RHY0DNCKhQytJnFj6v01/tfXNVAAKwbingUOTh6UgcDS7uOgDdd7Gdb4mtfSGzEamcNxxAmUeWTIjOUeT+WVU434BBEwZcr+7+b6+VRgm0tjOGed5HhO3lSBBrqyoW5TAfk2KfuqHQWMKI4wvScH/2AqFPJ+rzwRr1kCBHCl4DhX1ZBRI3ZBLsVpcwBUnJq/Y6Va4rdIfyAqI4G9Ju9DWsHVTrotqIM1n3yR9QXzd614=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/16/2026 10:46 AM, Alice Ryhl wrote:
> +impl<T: Send> Drop for RcuBox<T> {
> +    fn drop(&mut self) {
> +        // SAFETY: The `rcu_head` field is in-bounds of a valid allocation.
> +        let rcu_head = unsafe { &raw mut (*self.0.as_ptr()).rcu_head };
> +        if core::mem::needs_drop::<T>() {
> +            // SAFETY: `rcu_head` is the `rcu_head` field of `RcuBoxInner<T>`. All users will be
> +            // gone in an rcu grace period. This is the destructor, so we may pass ownership of the
> +            // allocation.
> +            unsafe { bindings::call_rcu(rcu_head, Some(drop_rcu_box::<T>)) };
> +        } else {
> +            // SAFETY: All users will be gone in an rcu grace period.
> +            unsafe { bindings::kvfree_call_rcu(rcu_head, self.0.as_ptr().cast()) };
> +        }
> +    }

We should probably add support for asynchronous callbacks for Rust instead of
directly calling the bindings in Rcubox. I know Boqun and me talked about that a
while back, and there was a usecase missing. Perhaps, RcuBox is a good use case
for the same?

 - Joel


