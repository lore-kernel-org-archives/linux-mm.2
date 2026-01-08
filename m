Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4041D232C7
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 23:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155E76B0089; Thu,  8 Jan 2026 18:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D236B008A; Thu,  8 Jan 2026 18:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31C76B0092; Thu,  8 Jan 2026 18:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD6226B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:34:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7992B1AAD4C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:34:59 +0000 (UTC)
X-FDA: 84310404318.26.32ED81D
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8B383180005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:34:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DOpKYf2c;
	spf=pass (imf06.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.198.8 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767915296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9TBFatjTadnqSnBQ2PX8Et4Costh/J3XbG/UICXrfU=;
	b=nYAmBelqt4lYfOvSSrxjJ5F/z1p7Zbp220WNf3HcBqKzDVw6IqTIkjO7uD8bTaAJI81MHh
	UIxj08RoG3gIvPfRCn8/ht4IalmY+LslYKIDgltSzlCzLKKZnd3qSYxvWsbBJnlxMxaV8H
	a8CdGAmXR1e/NxP+S5WzIfnOzOjU4lQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DOpKYf2c;
	spf=pass (imf06.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.198.8 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767915296; a=rsa-sha256;
	cv=pass;
	b=B6lc7KZpc0fP31MNX2YpYPpEVDlJKRk6y7DT+ljTOPmUMIQroXDdXf4d0tTKxiXYiwtbnt
	ifkEBmfbfKr/hYmOkIyF0TE8IW5+IXcvD2+DMqOQRfulm0UfDLm2XGyS98dqDk6TZmFWVD
	hZWGfB/wqLSxAKef44KJxNnVwWoD9H8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fvMWmaiPZDz7fjiUkFHE7uXcME8AL81eJZQQ8eafqcR+GbGd7SAvhKTinoCyhs0qfut8IxcsC4yQhKdya3i26xI/SeCIADtL+tf36vn9P8SXKjEg+F7kHE11kb9bj62zy0UahrZyaAYmC2aGh5VexgZV3U4fmyFBIKT0A5k7jPELmaz62buMBHjBk1OXUiALu11FMNk/GUpzNK7/SWlklyeSon+33wfG1O+0MBI18Tm8637fmiErm6i2ZVTelSJvu1NkAsHCJ0TQugbf2kj1XBwg9HY1JRj6DF38jIiLwtPjuGXjs66pI8Qyn8KC87ahqIqKwnWD/XzKbJ5W9yANKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9TBFatjTadnqSnBQ2PX8Et4Costh/J3XbG/UICXrfU=;
 b=sJ53857N6DKeBRUtdM8eSYBvsFOFNgudDb8DF08+xJf27GoCBkPEDWW3eRBm0HzvPJxwVQ9ShNvrZqBlT4ZysV/YMYPUBeOUrIEJaoOkQV4Zi/aZLkX3OmMghR7z0GMSQo4dpZhcBtrNFkGaQ5wmAEkq1dXFuK3PQwxPoraoYihvC+QyiA44dzrm30v5yCsiY+kPT/DbH53BQ0o5PPW8+K1zSqdGCZg+vLf3MuM5Xy//UFhMn6i92De21Einubyghi6Gyw3o6JuIR5eWj5VCVIr79i4sCLlDsNmuyTf8ByMYLDaixvNHjFlORFo+ApqK4uASDbrw3EzMeNadty2tMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9TBFatjTadnqSnBQ2PX8Et4Costh/J3XbG/UICXrfU=;
 b=DOpKYf2cMTleXddtzHaChfTZjmrmzM0qTQPPzgZAls/2rZUlnIPJcASfFsOwHzgIvYyQ17EymUbFqmEyUciCsm7B4gH5eP+LUF51NFaQoIrEmmpdmIR/3qXUCmLidM1bsMcuLNAD7b2H783pI/6siWW33e/TS3PRm4bkc77XCzcfirT3rwtsvu/4GvdDYs/rKK6SwhEh03YklMp1muQhLt+6tFIqnaAD4VlMAHc3XacRPvWKYqcg+4MyP/oTVoJ/ccrQ/xRVNfstRaq7NjZJSzrxkTe2zZx2L9JlpVGWhzV94ga8eyASxmfyd/0Pq1pDhXMuzWEOF5HcLXHDPOGp2A==
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by CY5PR12MB6647.namprd12.prod.outlook.com (2603:10b6:930:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Thu, 8 Jan
 2026 23:34:53 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%2]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 23:34:53 +0000
Message-ID: <b045dc42-233f-4bb9-8619-6a688c05b7ae@nvidia.com>
Date: Thu, 8 Jan 2026 18:34:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Frederic Weisbecker <frederic@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes
 <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aUSfu4V9mrD7BQGl@tardis-2.local>
 <6c96dbb5-bffc-423f-bb6a-3072abb5f711@efficios.com>
 <aV_cms1mCPYq6jah@localhost.localdomain>
 <fc0eaac9-930f-4692-b913-80e48dcdd301@efficios.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <fc0eaac9-930f-4692-b913-80e48dcdd301@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0015.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::34) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|CY5PR12MB6647:EE_
X-MS-Office365-Filtering-Correlation-Id: 89cc9f6a-a6b4-498e-4352-08de4f0e8609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OW16RWpFbnBsWHFEclBheGhGODhKb0wwS1BFMTFrS1c5RmdhdGxLeHJYbldm?=
 =?utf-8?B?Z0tJQjErR0dWajhMazBRRXZwaDlXQ1RtOWkzQXlnN09RenJFSVRXQUxXTXNG?=
 =?utf-8?B?OXJiRHF6NjBTVWEyN3NlZkhYeW5wc04zWjdJMWhiUC9GRUl4SXhFczh5WWhn?=
 =?utf-8?B?WFc3K0w5Nkc0TTcrSXJ0enFjTGtZK0NlWndwMzNaN0wvZEZhSDFWUGR0TG04?=
 =?utf-8?B?b0ZBMThYakg4U2tQN0MwSWdTa2J5L2xvY0JlUGdoSDNJOTh2Wnh0bjlBYXJn?=
 =?utf-8?B?V1pVNElESUlMZzY3YzZnb1QzUno4RzZSS2N6U3hJSGN0ZklnOGtKTnI1YmFT?=
 =?utf-8?B?bmhSUit4bTFnMFhoVDRXbG5kK1hRby95QXFkVjdyejhFamtkZVh3N252L1dB?=
 =?utf-8?B?UDUzdGFJZXJXWG1HQTdIaVNkckd2Z3h3WjdPSWJIaEZocGtTQTUxS1BqYmF5?=
 =?utf-8?B?NlJuRURsd05QK0k2S0lnR2M4Tzl2QnlZaHVxN1FuTjJ5UnRzbGFESTlKWXNE?=
 =?utf-8?B?NnZYM0trT1ZTemZyQThPeXJlYWZLbEgvRGlWZW9OMG1PVFJQeCtIaEVNNVBH?=
 =?utf-8?B?dlBGS0ZwcGNjVy94K0NJdW5wb3RLd1FTU3RwMndTYjQwL09CTmZuSWs1T1lx?=
 =?utf-8?B?NFBhY1FqeXJZMFlxaDN3akpsSHRLTjFHVFYvTHdHUmptRWtuaHV6L0xjcEFV?=
 =?utf-8?B?MzM5VXFUdGtuOXh2Y1loTGFMOWpQWFBBT2RBamk5cElEQ1QrY3N2aTJ0ZUxr?=
 =?utf-8?B?dTNlc05mckY4MjBVRXh4L2VMcVhpV2grYVNKcVVSSlRrU0Z5UTBsSFRxRith?=
 =?utf-8?B?c1cvbjhRYkk3MWN5Sm96djZBZmdydGR0b3I2V2VkL1lldWRpazJxNmlqd0k0?=
 =?utf-8?B?d1pscjJxTnJ4SWM4S0JSaHlmZ1dscTZGRWhhV0h0UlBrcXI1NTYxTFhMdncy?=
 =?utf-8?B?ZFZrbGF3SXF3dW9CNXVBejNMTnR2WlE2TitvdEhDYlFuNXdTZ281RXE1d2RV?=
 =?utf-8?B?blA0SWhsTVozYmhaWUl3UEtGS05ZeWJ6N2NmWG9pREVFbng5TkNMN2xteDk5?=
 =?utf-8?B?UURPeDF0VlV2QnNBQkpxeTcvYkJhN2RkREoyVXZBblErb2JvTCt1RzVWKy9Q?=
 =?utf-8?B?WHpjNmtjUzZpL0xLRkIxT1JTZUJ5WlNmWnQ0cVJHN3RHK1JRaWUvaE9rZWk3?=
 =?utf-8?B?VTkxakZjUmVuM3V4Y0Yyd1YydHNEMzFzRmtiV0pTTVFSYTQzNFB0cjlvOXA3?=
 =?utf-8?B?YXJuZ3RUeWxMYUR5RWNmYUxuazhtc3ViWWhDRERQNVRVN2IrYWxyM2NBWE9I?=
 =?utf-8?B?YWh1SU9EKytlVitRVlRPdXdua0hBSFlvRCtZSXg1RGtQeXp5UXh3UGxJUWxn?=
 =?utf-8?B?RWVXVG82eHUrdVlTM0kxNXJFVEQrVG5RWDNqL1JsZTZ4TDJVbkpSWmhCT0U3?=
 =?utf-8?B?eU40SmFoY3p3blQ4WlBlZTJ4ZndxZXdRRlEvclAwUS9qYU96MU5pdUorS1M5?=
 =?utf-8?B?bzMrM3NHamxqaWthbm1qeU13WmROamlDRG9mZUVTSjJab05NMFVoUWFmYm81?=
 =?utf-8?B?a3RQWVo3T3ZTR2dvdEhlVWxxeUhnU202NzZXdytHR01Mc05vZElzVE5jUWxD?=
 =?utf-8?B?eUwxQzhxcjd1bGorc2swT0UrdGJNVGZtT3hXenZtYlVJMHB6dVRCSTVPRjNR?=
 =?utf-8?B?ZC9rYTRGYW9YMXJybnRGclkwQ0lpeWttclYxNm5LbXFPQmZ4NW1CV091TjNE?=
 =?utf-8?B?eTU5bThNZXZyVUF0MHJsNGtESjBycFF4M2hNTGVHY3FLZ2l0YXhVUFUwempF?=
 =?utf-8?B?c050U1AvbEV3OU9RMHU1RkFCTmFBYVVUK0MvTUgrNmgzSldjcWt4bkVWcy9y?=
 =?utf-8?B?d3MxQXA1MFF4NEdXM2YySWhWZEdWUCtyUi8xVmZGUXFyMkVmRHFDZTdBZ3BO?=
 =?utf-8?Q?cYTgG47VuX/xE6O/J3m5odimuMIElwXC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzhxT2FpL2p1RmI5UlloOE1RTlVDeXJkcEUwU29MS2M4SzdzWXMxeTRGQ2dL?=
 =?utf-8?B?aGtlVy80OVkyOHBaeG1YMjY1TTdUbCt4UGlTanAvMzRUbWZvMXQ0N3dmemk5?=
 =?utf-8?B?RlBpaHlROGVCZklDR0JlTCtzKzFTeGhTY0tXT3JpdGZvZFFzNTg1bStZYnd1?=
 =?utf-8?B?Wlc4M0ZUYVpqYndseG5TTFNzejRQQjIyZW1tSWxwRFNmZkhETW02ZUpwTm5r?=
 =?utf-8?B?WG9yNEJQcFVFTHZQNGFsc2FuL2ZnTTBrYk9MQ2FZSkZtcWZaVCt1eUJUWXJn?=
 =?utf-8?B?bW90bHZlMWg0eGx2RmlmeE9HNlljQnpIcFhGVk5IbEY5Nml1YzFMOWZxSkYz?=
 =?utf-8?B?T1NuVXZubzVHVWhkTFFwcmNuVU1nYWIyQVVDczExQVFrczFKQVdXV2QyaGhp?=
 =?utf-8?B?bXJIVi81ZWxqSkd6SU4wTER4MkoxcVQybjVkbUpuTSsra29XZm0xVkdlb3dV?=
 =?utf-8?B?RmxreUZPenBrMXNKTDlGenpxUVpYaGtQYmxnYzhTcmVleEZqZVN4bGx5WkVx?=
 =?utf-8?B?S3FzZWFQa3k0OHkrNWlVUFVHK1YzekdHN2I5alo3R253V3UyVVo3dHZYVmEy?=
 =?utf-8?B?cEp5bzJoVVNKRis3RzJHTldIQkNGM1NQeVA1YVZRMUdsTjhQemhMVHRnbWZt?=
 =?utf-8?B?Q2V3dDByZGYvSi9YQ01mSW9jd0tZTWp2dzVpNFB5Lzk3Y2V3dVBaM212MmpJ?=
 =?utf-8?B?M2xjVWM2am53RmQyMXpHekI4WEVOOHhUNXc5TkdSVVZVUUZnTWw3Q3RxS0JD?=
 =?utf-8?B?RmI3VFhiVTdjWk55cUFqNDRZN0VDR2xJUWlwenFDUDkveWV0ekxRRWxhU3FB?=
 =?utf-8?B?b2F3RVZ1MzcvazF6TVNxODYrWjdtZlpBa0Q2NXgxZXRoUVo4RnBpSE85RHNp?=
 =?utf-8?B?TFplTzVXNjk5QkNIMktsbmc1ci85dE1zNEZpMzhzaVVsUURnLzhrT0NnMFVT?=
 =?utf-8?B?eHRwZE9UdHVNVkZ1TDRMeExCRkFBblUvZnQwMlBNN25mbDJhM0dnNEFVbWlq?=
 =?utf-8?B?THdvUHIvRXhIOWFiMDJlcWZXNkxWaGFvbGFSWTVPN2hmQlR1a0pZOEZBMkR6?=
 =?utf-8?B?aDBNZ3pIbWloUTNyYXppcnhURnRaQVNieVdjYVRHY09Nc1BzVmNxWXNDVTFP?=
 =?utf-8?B?am80VjB2V0VyMnI5STIwVlFZWmxQbVBMclNmQVRKYTB4L2dCOXovOVJjTWhr?=
 =?utf-8?B?T0hIcGd0eE1qdDU2WXJUQUJaTWgvazQwbVBJbkhYdGtpK2gyc1hNbGFKWWxW?=
 =?utf-8?B?WktPMDc1QkdRQUd5aTJscTlVMi9LZG5sZWs4YUpKNnVkUTR6VzJYRE9WZ293?=
 =?utf-8?B?WlJjZXp3MzQ5YnpwU29sWGFBdWpOT3V1UllvK1IzMVNhU1E2V1oyamFTSWJn?=
 =?utf-8?B?ZjBQU3BpSGpWaElOZ0lWcWZCMWtKTy9oQWxJYjRldFEwVkRjL3dmWlBTKzdH?=
 =?utf-8?B?UkFkMmkyM0I4T05NenJnNmhDa0RvNldTOFE2ZkZiRURjUnk0dHhmUnpTVkpm?=
 =?utf-8?B?cjdGZlVmVUdZczZTVWw5ZFhlQ0FwcDl4RUJ2cklBQjRPSjVaYXpiVE4weGxE?=
 =?utf-8?B?QVRDdHlpdktjeU5WSklRV25TdTN5ckRhOUlkaWdNNnpNTTU5c1NUU0MwakNR?=
 =?utf-8?B?SXZta3I1eWQzQklrcXpqMnBMZmpJQ0NHSmExVGhjR3AvZG1VVGxOOGZ6ZW1B?=
 =?utf-8?B?dnRYcDRyam1SRG9CNFBVdXhVc1A0a1Nrb3c5UDB2dGJ5c01mSnNNZWJQMmdF?=
 =?utf-8?B?U1FZbWFIcGZEVlk2OHNlTjZaTHhpVkRPTjFjZ0N6TmZ0SFphaHgvOEUvbDl1?=
 =?utf-8?B?WTJkTWJHYmpDWWRublllalY4KzgvQm82OGRvK1dzamlONFcyVHNRaTJKZW4v?=
 =?utf-8?B?c082SVdmMkRSQW9DQll3ZjMvWmFtOGxiL1RSQjFYcjg0V3M4T21nVmlBREdW?=
 =?utf-8?B?K042N2w0T2gvREF2SVdnUmhDR3lMeXRCbzIyL1YxMk9RdS9mcmhNQWh5ZWVM?=
 =?utf-8?B?ei82aThHalZFaGs2RWZMUDFNWWRMU2VhTEw4UERCbmwzTFo0eUJtSk12SWhz?=
 =?utf-8?B?VHdOcGZDUnlMN3VLZnM3bGlGTEFuWno3d3RSUXM0MG51UnkzVjdaY0JoVk54?=
 =?utf-8?B?UlBCRG0rM0hYM1J4Mm1uUjVFRTRIWEVMd2JOQVFvUHJydGFaajlYcUVNRUhS?=
 =?utf-8?B?OGhWbFlONlZqVkJzc0h2QnFZbkdISnVBMmN1WUFXbU9yRGNaL0Jla01hNzZT?=
 =?utf-8?B?WFdWajRHL3ZHQ29xN3IwbzJhNno4OVhpSEpPc3Exa3RWNGRrSTNtZisyY3E4?=
 =?utf-8?B?bEt6YTlxb3Awd1pTUC9nSzZIK0Z6VDFPSVcxNkkyTE5BaTRLRXlzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89cc9f6a-a6b4-498e-4352-08de4f0e8609
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 23:34:53.2543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ry+pBiW3ZhIlc7G/hDZfkOlQE6gR+vm8IY+oLZC58Ad56m0o++Y1aGXUSnQuXR2nGAY/GIYjLTSHjDYUR7keug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6647
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B383180005
X-Stat-Signature: 84qxrgqyx1zcu3t9ewecn3gt838e6c7p
X-HE-Tag: 1767915296-665730
X-HE-Meta: U2FsdGVkX1/pU8IALLoyLBUBt5Msfzp64C7CWAqFXywYqqN+SCAYMZNlUU59c/109teOfkwW1L7AsZojJzPKXcj6aOXX4R9YPHsT+6uwZUJO1iFitjxDQlxWid2gHnPlrVUOoxKxdnCiszGqFrXH1c1iMD2Jd2aFOO0Dl12Q8HujEl8hkR49noGAn3hDrAkQ6chzsMEvpjiH5zLqONuhBedbid9DhKnw62Aul3Vo7PqgAGAg0V0d1cI/9q4uFFt1d3yZkzsPjtHySeZ8GB50LjOQBk/01/b08TfxWV1Ph7vTmbL5aClNoNvpyRKzCeXG60Q4mu153fS2ujxUU/k41cQWjlVZuacTYMIl9/V7DrNut7kHH+UyROd8NimzKk+WHWWDg7Ogz8XtMt9kEf9NZ7Ka5MX5ouSRhsa8kEQo48N5ogo4qiZaUhu1YJY7ZYKbsWScBFZgfsuTPlBfTml3PMK8jHE8Lt36A/mvwISDoRAHP+0QVYmCx3EzgiFlVr22S7ldjFi763DzYRSv9NLoZbX9mHHviqVsBOgn20+TMP1ceeJzi9p4z/za8WJKStr7JolENDvI/AsEWel0TBbWI9mOaQR/fdZOP8lp10ILoU7PuY7s2DmP2b8ankQh7Nwno/W0rbhDWvsvUvEtcArscu1l5FdSRWR4M9YNuscMOOcUAgZTijaXd8v5nL99E/ttmyMbKLqRfpPmZEt6qiLKLFCApYKT1M3MhvVQ6HZDVJf6m6x5dc3dD3ioS03Yim8N/om0IO4QfRgSbuVdoYrktagcRDr5loRUJbUkvaORiL+lG2No8giaJhyZfBQpoK30vOSg0bP5+xpdSQSCsNX8l1tYVK0eHHORPnS/C3Mm0HQ+/MJja1GuREuYdMbR1c7fSjPc4FdCokAOGbhxTJeEy8wu99UUebJj52EG4TEW9fOGQ0JzNffQH36nkLe3yxBsOX3n31j0+LZcRwQwfW6
 7zoEK132
 KVlpzfmiYxLQOTBSbqnOZN43AV7ei2oZPJKWaqKzYNj0XJ2G6tooxAPpJiclPbt7m80G/aQsb2OmSmArEwJJS4JpKYpcjGSZx1DI47Bb0x6HbAZVA1BWqIN6digT/VBvfFOtJuORZkJVYh5XJx+u5CzpD8KDPNQYoVY3j9QDzywQ4pnqSHBXv182zS5rBlJX2U/beNRi/K4/mAEY/4Xol4WOFTjXcC3IcAhP2mbgLzk5nTAoq0glExfnDBZ42wBFg0GYbnbXs+rM5TD5fTMsyyAjQfXJAGzEMWcAcF2bndmSRNtHdqITOtVVKFjM32jg41IiFK3e9q9ZzdKFm+SG4X6F9KID5uWHboxivJdFcQNIuMREUyEv95Vgn2eg4/mypFily2SEwneUEkU6+dxAQvRdzfhf7dp8X83FgsF1iMFrUt72UPYGw7kcJ6j1hCm9gZDtmksTIxFQEjMOKcJKZk7XcmTOFjeUIHhqSAIDRsf5bTUPhsG1839IDduW7XCN5Q8Bx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/8/2026 11:45 AM, Mathieu Desnoyers wrote:
> On 2026-01-08 11:34, Frederic Weisbecker wrote:
>> Le Fri, Dec 19, 2025 at 09:22:19AM -0500, Mathieu Desnoyers a écrit :
>>> On 2025-12-18 19:43, Boqun Feng wrote:
>>>> On Thu, Dec 18, 2025 at 12:35:18PM -0500, Mathieu Desnoyers wrote:
>>>> [...]
>>>>>> Could you utilize this[1] to see a
>>>>>> comparison of the reader-side performance against RCU/SRCU?
>>>>>
>>>>> Good point ! Let's see.
>>>>>
>>>>> On a AMD 2x EPYC 9654 96-Core Processor with 192 cores,
>>>>> hyperthreading disabled,
>>>>> CONFIG_PREEMPT=y,
>>>>> CONFIG_PREEMPT_RCU=y,
>>>>> CONFIG_PREEMPT_HAZPTR=y.
>>>>>
>>>>> scale_type                 ns
>>>>> -----------------------
>>>>> hazptr-smp-mb             13.1   <- this implementation
>>>>> hazptr-barrier            11.5   <- replace smp_mb() on acquire with
>>>>> barrier(), requires IPIs on synchronize.
>>>>> hazptr-smp-mb-hlist       12.7   <- replace per-task hp context and per-cpu
>>>>> overflow lists by hlist.
>>>>> rcu                       17.0
>>>>
>>>> Hmm.. now looking back, how is it possible that hazptr is faster than
>>>> RCU on the reader-side? Because a grace period was happening and
>>>> triggered rcu_read_unlock_special()? This is actualy more interesting.
>>> So I could be entirely misreading the code, but, we have:
>>>
>>> rcu_flavor_sched_clock_irq():
>>> [...]
>>>          /* If GP is oldish, ask for help from rcu_read_unlock_special(). */
>>>          if (rcu_preempt_depth() > 0 &&
>>>              __this_cpu_read(rcu_data.core_needs_qs) &&
>>>              __this_cpu_read(rcu_data.cpu_no_qs.b.norm) &&
>>>              !t->rcu_read_unlock_special.b.need_qs &&
>>>              time_after(jiffies, rcu_state.gp_start + HZ))
>>>                  t->rcu_read_unlock_special.b.need_qs = true;
>>>
>>> which means we set need_qs = true as a result from observing
>>> cpu_no_qs.b.norm == true.
>>>
>>> This is sufficient to trigger calls (plural) to rcu_read_unlock_special()
>>> from __rcu_read_unlock.
>>>
>>> But then if we look at rcu_preempt_deferred_qs_irqrestore()
>>> which we would expect to clear the rcu_read_unlock_special.b.need_qs
>>> state, we have this:
>>>
>>>          special = t->rcu_read_unlock_special;
>>>          if (!special.s && !rdp->cpu_no_qs.b.exp) {
>>>                  local_irq_restore(flags);
>>>                  return;
>>>          }
>>>          t->rcu_read_unlock_special.s = 0;
>>>
>>> which skips over clearing the state unless there is an expedited
>>> grace period required.
>>>
>>> So unless I'm missing something, we should _also_ clear that state
>>> when it's invoked after rcu_flavor_sched_clock_irq, so the next
>>> __rcu_read_unlock won't all call into rcu_read_unlock_special().
>>>
>>> I'm adding a big warning about sleep deprivation and possibly
>>> misunderstanding the whole thing. What am I missing ?
>>
>> As far as I can tell, this skips clearing the state if the state is
>> already cleared. Or am I even more sleep deprived than you? :o)
> 
> No, you are right. The (!x && !y) pattern confused me, but the
> code is correct. Good thing I've put a warning about sleep
> deprivation. ;-)
> 
> Sorry for the noise.

Right, I think this can happen when after a rcu_flavor_sched_clock_irq() set
special.b.need_qs, then another upcoming rcu_flavor_sched_clock_irq() raced with
reader's rcu_read_unlock() and interrupted rcu_read_unlock_special() before it
could disable interrupts.

rcu_read_unlock()
 -> rcu_read_lock_nesting--;
  -> nesting == 0 and special is set.

   <interrupted by sched clock>
      -> rcu_flavor_sched_clock_irq()
         -> rcu_preempt_deferred_qs_irqrestore
            -> clear b.special
   <interrupt returned>

     -> rcu_read_unlock_special()
       -> local_irq_save(flags);  // too late
          -> rcu_preempt_deferred_qs_irqrestore
             -> Early return.

thanks,

 - Joel


