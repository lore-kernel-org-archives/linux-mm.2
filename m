Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19EBE81A2E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1F66B0005; Mon, 16 Feb 2026 09:45:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483986B0088; Mon, 16 Feb 2026 09:45:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BDC6B0089; Mon, 16 Feb 2026 09:45:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C82D6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:45:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B7F95D50F
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:45:11 +0000 (UTC)
X-FDA: 84450592422.22.35D512A
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF0D21A0013
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:45:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UkOKapGz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.107.200.21 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771253108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPCaRToXF7uNrQvdBEmDs3Ax6w4oePOAKqu2BXiX68A=;
	b=GlLhOT+X5FOOqLo1LulmDDp/FCMDoAXUoykRZ36FB+AfRK5vTTUtqUGj+OhUFvgqrAxFOR
	0JIP1mJDCeuA1onQ4WKYuSQrg2TuxY3BicQ7aGI6bsKoPA9njSlPorSBPkDwMysdsx/72Z
	0QD7n1stN8HKDJCxOvgqYoO9wQfz1Ho=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771253108; a=rsa-sha256;
	cv=pass;
	b=jkldONc0YKgx92CtoxedHg5g5VEvFMdVNaN2bAhZcUxDhy8bj+XwFiou6jW8460tpgn/0a
	fE0+SqT8a+K8VIA9nfbZvL3Kfp4kijkxLsq5hwQhQPG/G96UmwF0i7jV2PQ+b+It6VAgfx
	KoKkTLgbKxQYf85hV4pots3Obfv/Qss=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UkOKapGz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.107.200.21 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZ3WL7QP05eqHsbbgKe6FjN2xYBgWTeNkapFwvjvJsZ0HGffprBuC3LMHJuS1XAbIs9DvEjqX/FUTHzCHlMDhTwF7LlEkbsiv3gsDlGVcnFBehEVI6+oCLnXqCl3wECc87HGmu8B/JcNme7OubanoCqlgxvU1jCgqHyF5PW/ZO/K6jJ7prGjguWA8l4MOwniDXSX9ZZ81d5ZEe6yf6DrOzf0pIKyIvTKnVVorh04Q4sgWDOrFiJ7Rr3ytI+ra5bvjJS3KoW8X0GxQV57EhyCx3y1psBcqG6QVOsiBSPJnAklri5q0/ljd2KL4xluhkLAZWjgZmU4piWKjul57n0c1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPCaRToXF7uNrQvdBEmDs3Ax6w4oePOAKqu2BXiX68A=;
 b=wE4EXfK7jn6flyCk53ZJRCdVK2Ec514I8n7GQiOZSchYA36KAgV0VLO4ghwBRcvCQUP938W2up34YfeG4r0GuJkIJ6BteqSoHipdUwe4SjiuHl1mNuoSGoqNBW8USBFCGojaybkCvzokuIQKDW3b29uQ0F3RhmRjinWq7ZRhiVlzcs29xfaxdU1AcvlMIwI5OWX9W7itOiyn7VKgrPILooFZ6daNAxJqhRZzX0Y3IKHyFrOm5mwlqDA5/p2mUoFjyqgAFIcCVuKGXacahdbfX6cj3mUMbqL7dKIG2z+zxUOfXEPnsmm8M4RcCyaDR6j255miXM2ZfjRGO5g/z9JVNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPCaRToXF7uNrQvdBEmDs3Ax6w4oePOAKqu2BXiX68A=;
 b=UkOKapGzDl+uAw53pT9Qm6N87hTVFbUKnGVBR83/M/CD+8Ep99MkjEIj2RmwXtu5tFNeQ/jjn6r0s53dxyQhCJUNpCtS7nLh5XUELNQe2ozKU3WYZTPM8kl+xMoK+nUTNsbBldPF6Sht/691vjynuQ33ZHXm7Pd0qXc4o4WPWx0=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 14:45:05 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 14:45:05 +0000
Message-ID: <fe516b2b-4b63-4da2-ab9d-7d3e71e3091b@amd.com>
Date: Mon, 16 Feb 2026 08:45:01 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
 <d07cbb96-ba30-4dcf-ad14-0479d6a989f2@kernel.org>
 <70be936e-e49d-4485-8d1e-416fdf8f40a4@amd.com>
 <aYR0vqwyFPo3EKAi@thinkstation>
 <ce4334f8-5e54-4dbf-9be0-059279ef1962@kernel.org>
 <aYS8O0phOE41IuEF@thinkstation>
 <fc60cc71-80eb-4058-8d0a-dbd19a5c10ef@kernel.org>
 <aYXYRf4lxm_iQwjE@thinkstation>
Content-Language: en-US
In-Reply-To: <aYXYRf4lxm_iQwjE@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::35) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: 03ab368f-3a23-4c61-860c-08de6d69f8de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1JsRjZWWWQ1dGFoS3ZKY1hPaVAzdG1Rb3FVSG9YRGlvN3R3cTBCanBMczBx?=
 =?utf-8?B?SDRFZGx0cTcxNUJmc0h1U1Urb1FpY0dIdlhGV05NVkZtNW9USVFQQlZJTXNQ?=
 =?utf-8?B?RTJSUzJpVjB5azZCSDNrRXYrWUx2RXdhWU54RDhvT2NGaUxjZGtBcU5UM2hj?=
 =?utf-8?B?YTR0Zm1ETVM2elEwRlhiVGtCWnprd1BFN01BTzRQblZUWjExayswOE9qZjJQ?=
 =?utf-8?B?Q29YVGZYSFJMbis0aTFNRC9EUnlucFpTTk9MYkFPR3p1OGlDWEwyYytQajND?=
 =?utf-8?B?ZlJXQS9tRW95ZDA1ZVVvb29uc0M4TzM3aUQxUjZnaTJaTC8rckw2aDZtL0Fh?=
 =?utf-8?B?bzQ0SkpsMFVMdUNGcmVrc0t2enROWlltVmtTeVBaUFhZOU1YWTBJTmJLdU9Y?=
 =?utf-8?B?TWRiOFBUclF6azlESktFblpUNXFiNWtnQ2lvbmF4cStKT1ZWZ1YwY1FOajZ2?=
 =?utf-8?B?aFhLajF6d00zWGdDVkw3YitlRE8xcC9QOEErdVZPOFJCblpKOXdxS1BXRkhw?=
 =?utf-8?B?bGhGbVZ6bWdwK252VUwrUE1pdFltZHRiUlZQNjBGeW9qRHhmODQyU0EzNVlu?=
 =?utf-8?B?eEVyM0RzMGtYS3hRaERLbEJnVkJNY0NkWEJRL2k0eEthVWJSSmRJRlBxb0hS?=
 =?utf-8?B?OUVpY0RMcmdxQ1paaFAwK0tlUFlSZlV1dzB1U3U5anJrZWNmQTdUM0JpZTQ4?=
 =?utf-8?B?RUJZaXcwcUxXUkJMcDZyN3dORDAzTTU1V1BES21QR09IUFVzMXlxRUI3dmZw?=
 =?utf-8?B?eFFja3N1amtBdzV5MHZ3cnl0SzJxbzkySjQrSWsvRENxc2hVNWZ6OFd4ZVNu?=
 =?utf-8?B?TXg2RzMxWGdKaUp0TUlKMXdicjhKeG0rYTlCem9ncTF4azNDTFVMVE54UElX?=
 =?utf-8?B?M0djdEZ0NDdvTEVuL2h0WmtJei9HRnE4eHA2aGUzL09za0dIZWtaUS9ZUXlx?=
 =?utf-8?B?eUdPaWVTS0xLMHdyRVBOS3E5Y0lSaVVzeW1FYytjOThVc2twT05ic2VDRmlm?=
 =?utf-8?B?WFVOT2VGdjJ6NTd1M3FUamkzKzM5ZUFMTHJ2OUlkVStwNUxVUjc4SVJyTjFu?=
 =?utf-8?B?MWI0NzFacFJkSEtSRnB2czhmclNKcU5ZYTRyUm9UN0JQQnpOazZWeTVpalpo?=
 =?utf-8?B?VzFsZkpGSTNEeHBrTG5saWhaRVFTOHZlWWtEMUpEYmc3dk9KNWw0NE9pRS9w?=
 =?utf-8?B?MDk3RnNYWlZVa21UZ3hjT1dxVGNJWjh6NUh0TlB2VTZrbXRjTWJjSjNvUDNQ?=
 =?utf-8?B?THZsOE40dzk2T0Z5by9BK1BBYnQ2VTlta2RpVWNhQks3VzBaZnFmR0tIbEtt?=
 =?utf-8?B?Y3J0WXlGTFZ0TDRTdlBWNFV3RmZFRGs0UkhRZ1JGcXJpMU9TVjNwMmwvbjcz?=
 =?utf-8?B?a1hyT095Z3A5aTR4TnVIeGFsYVZmdUU5OHlvZ3dXeVpZS2REWmp1aWYrQjJa?=
 =?utf-8?B?ZFprVzhzdnlwaVM5dHF1ZWJ1QTNFNHp1VEFMak9tazBnTlcrbGRVRDFmMjZM?=
 =?utf-8?B?SWZ6RzFLdkwzaFpQSnBuVXdGdGE4ZVBlM0ZxeFZTNmFZcTBwb0RWbndnNUcw?=
 =?utf-8?B?N1JVK2w4akxIU1llZzZmTDJ5cUtBVGptaSszVXNmQyszSnhJMTFJVFlQbks0?=
 =?utf-8?B?R0lyL2EybTREc0VscjlBczduVjBNeEJzb2RYcjVJdGNrV2kyY1FtQ3ErNEJw?=
 =?utf-8?B?c1pQcGlHVkx5UElyWTNVaW92cERnMHFYMzhUNzRHQ2pVcm5peVFhRjBnNGVv?=
 =?utf-8?B?NkVReTlXdkQwNjNxVkNrdEprUjIrRmlDNzJXSXErZ0NueDBiclZ0NGY2NnNk?=
 =?utf-8?B?VGJLWmFjZWRPdnFwRkVoZ083ckwvVStBVW5mcHY2K1YwQ0ZhalFpOW1YTkdv?=
 =?utf-8?B?S21lSVZsSzdVSjdCZVR1enROM0k0OTdUTlBEeG0wMlpVZ21YeUhrTTlnOTZo?=
 =?utf-8?B?a0doSnR1emhFMXo2dmRMYWVqK2ZHb3kxcG1KSEE4alNlVkVLdndTdng1a2hI?=
 =?utf-8?B?S2ZQMTJCVmE3SDc3eFBIb29GTVppak5INEMva1lPMnZZSGorYTFYZjNGanpx?=
 =?utf-8?B?eThpOFdZemkxMmczUGZ3UEdxdWVNUHJyWDFkMjFQMTVwbEIvZHE2VHpMTzBt?=
 =?utf-8?Q?iuPU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckVuZy9oZ3pZVzU0L1FMR0VJZDhpZDZ0MUY3bDVnb2J1Zy9wUU1xVTZGeURL?=
 =?utf-8?B?akFvRjY1V3MyclRXMGxWWWxUdHoxTWx1SXRta1ZNZ2lXU3N2MUFYamlQVUoz?=
 =?utf-8?B?MDNBTW54SGxGN0pMMlVXUExrSVQxSmM3dGMwUTBjOGJZa051Q1hUUUNqTlh3?=
 =?utf-8?B?NmVxTXQvS0Q5RlN6NDM0Y0FUZGRKeUJ2TzRHWkZOY2FnMDNoZUxhd1lzQVA5?=
 =?utf-8?B?ZHZjRVFOVCtnQTlUbjRSTzUzblcraUVWdTdUVHZ6ZjJxL2VFQ09zK1JPRnZJ?=
 =?utf-8?B?ZEVmWW9ZRzRHVzVEVC80S1lXbW1kck5yczE1NWVnZkZxeGJWSjU3d1YzR1Fh?=
 =?utf-8?B?dWlkcVZPaWVsWmdvNnFxcHZPQ3c5a0gwVmtFWmhoQzVobURpaE9VemRWK2g5?=
 =?utf-8?B?ZGJCTUZMOFM5RDFiL0FwSEV5eGFlN0lHeGk2b1FYR241M1BpVzdWdzdUbU9K?=
 =?utf-8?B?ZUZzVk5FTGJGQTg4V3B1NFcvS3hYeTdpWmJDdmhwQXVxWkRPQzIvT0VZZGFK?=
 =?utf-8?B?Y1UvcU5kSHlCK3o5eDF1MzdUdWhWK2RzYytUVFM0Q3dlOWdTaCtLQ29GeFB0?=
 =?utf-8?B?N1cyZmlHTjlublM4OEVOQzlxSHk3aTdrT2o2TVJxKytEMCtkbmhBZFROT3VG?=
 =?utf-8?B?Z2tGbWpLNHdGUktmY3VXcmd0RjJ1NEhSbmQ2ZDdhLzNISFJpbUtEcEZ6TGxJ?=
 =?utf-8?B?anhNVXlGSW12enV2dWRjVE9uWk1EWm1OSTBaOXRvaDlLK1pub2dYWDkzbzBI?=
 =?utf-8?B?VGFIOC8yMVlOMXZzZDZ2SzZDcnZWT1hiV2NOSlJIWnduZkd5N0hrK0Z2THRO?=
 =?utf-8?B?VDJoQ3ZnUWpUbVlOWUUyZGowTzRlMzcrYitHMVJ2TjNnVEc0aksvd2F5eVNw?=
 =?utf-8?B?cVJ2RXc2R0tXMDJQNUJST2Z1UStKVnczdTVsWTZMMkRTSUM1eDFEZ3ptTkl3?=
 =?utf-8?B?encyenNKMDJtTHpLcTU2bUdFM0o4MEJ1c1JtZ0pxUDVLODd1ektpQnBtTDhN?=
 =?utf-8?B?NUR4clc1UjZpS05xS1hzU1ZoUG4wOFVYWkQ4b01UeklxbVRDcW1wcU53L2ZS?=
 =?utf-8?B?NzlSMXVYTFZXYzlySEhmMzZINzNwVFRVdGtBM3BlVXpUTVg4VmM5NDZIY2Fp?=
 =?utf-8?B?cHA4bExhWlQrZmFaOWtYVTlqVmIwRndwcnR5bjRESURTVU1iYVlWc3RaT3VR?=
 =?utf-8?B?aVZTSGJnNXBDWEx1VEd6MXFGa0N3SnlKV1Z6dnA5Nytjd1hBNDF6WlE1ek5C?=
 =?utf-8?B?cTV4WEZNM2hCOXBXV0Iwa08vSlMwN3FIL2t2eVQ2cG55UTFYbkJvZ1c0aGZs?=
 =?utf-8?B?enhlRnFVWVhCeWlsODBzUDN2T2xXTUxLZDJscHNCT2FtbktwbkN1Z2Y3bVBX?=
 =?utf-8?B?cW5IUVorcG1iZDRWQkx6MnJhUGNCQWRlenNSb1FPaGYySkp1aVdLV0loNnBh?=
 =?utf-8?B?RjB4NUFYMjR3VS9JQ3lCVlhrMjlWVmVRTDdvQ3EzU1h4enRCQVJhOFVBZGJz?=
 =?utf-8?B?SW96Sy9RaWo2Y2RMdFVrTlJRRXhNNmxkYXFzZWJQT1oyendtb0p0Mi9EdmJ4?=
 =?utf-8?B?Mk51Y1N3bG0wMVRCd3FqWkFOWHl5VVIyVWd2R3RjVERXTFFZOFpzcWVVenNS?=
 =?utf-8?B?d0ZYVzY3UWVuNHNteDRlZjg1VUJGRWF5aDV6WGx5ekNBWS8zSVlSbGZ1Qkph?=
 =?utf-8?B?U1ZnQWk5TjJUTDhhWTY0YjJ5OWp2b1VUSkVjVTBnS29uWkpUMXBuYzlvUnRI?=
 =?utf-8?B?ME5MSEhmajVjNDRveGlkRW0yWFVhWkRqMTlSanJPWWNYb2Z5MFB6WEJNREov?=
 =?utf-8?B?Rm1jSmFiMXBRN1JzelBNMjZZQlp6MnRZS2FkZEVXZmNuNUtkZmwxVjVqODQ5?=
 =?utf-8?B?STVMQTJIR0paRWl5QWtkUElCaW5sTHJldFd4OC9lNjhVUnhjT2NDNnB5NElj?=
 =?utf-8?B?TTQ5R1ExSVhLdk16bWFuY29pYnBNWnBKNi9oa3Jna084RmJlYm95ZFdsK3hR?=
 =?utf-8?B?TlZ5dlFBcGJoMG9PWFJLTFN1UGJXUHVQUnBDYk1CZURCL1FIdWVnVGd4VjlK?=
 =?utf-8?B?bnlpcVJCelpoWWwyaFBzSmhBYjhwQTYxeDM1RXVDVjJzUzBCN00yaUVUaUxF?=
 =?utf-8?B?Y1h2NVBKVDNHWm0yUWFEbmJpeUdvdEtpSEdXQUpCb2dqK1J5Ymdabmpvd1p4?=
 =?utf-8?B?cE1nUys5VGp1SDdKSzlXMGxTNm5LVkhZRCtUN3lUc2IvOERmdHIyMXRkZ29V?=
 =?utf-8?B?YVpYRE1mUUVMRHdQZ3hBeDlzem1HQURneDl0SzR6V1U3N0JScHlPRlAvSHpW?=
 =?utf-8?Q?EQ38CrWiNaXOwqqc2W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ab368f-3a23-4c61-860c-08de6d69f8de
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 14:45:04.9877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wy5g92SZ323xo1I7g9d2qGX8GZwY9KI+l3kfzg1AP7llad2rN2SP5k9S4zWp+Tf5iTWsujLaXe+gSRUoKQFXNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536
X-Rspamd-Queue-Id: AF0D21A0013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xs8bjfyhrknomrp4t84pi4ocu9azcr8k
X-HE-Tag: 1771253108-203948
X-HE-Meta: U2FsdGVkX19evG8J2Q7djcfB0uUYz1n++dgBpmsyMERDUHmmhwWPmEQ93nv4oG+GkbwFWXDpWHkvhKor07ozGRfrq8fJVXGpWQsPUbTAhBtada0cDeMlSla/rbo/5YZo6YAllwfbcSGbrPuhF8TOKUCLoItDBTy9uCr2/+ujGeZ2f/Xuhk/oMGsIeDsijrpWnMXBlq41fqMP12liad/ZYPgm+NSJ5jta7N3mAXq9rjOBCg6OCTftDujsTfZu8E0g66si0yHMAVCP4O5tHazyhAcKh3wmsEYXMmd+Q7NQxow8Ho/fJo53GMwbUXPusEjPAVEyGJPtt7sAM0IHpcMlccIzeLdG2b0kXLqR8cAlzY7yFfeCpcOyIES8WXSqcdDGymChUtEB+u6dhLLpCs7UXicuDGP9NbBmRX3sAiVImRs/YfejB++hEwzCM1oHnjLdZhB3IwqJcgrgRHO9lzoKWNd0jTb9BLbOvP0iWn7zNkLV5Z7Sr747wpLHgERTJDLOgrb+jd03huVwa+2qTOKfidfWLebp0/jLWrgaPoKuvhR2xb2D1IRPN8QV/wAVP/mzATTiWa6R4pUEgZTKoI+ztfYCi/5kExHiel8yBTL9vi9e9PwWfgtvJx4VC30U/TfnGco85PB3fccgXq5tA2xGnCFLpUXT60pKjVAts+6XFw3QBfvXHyiD+yT7juLV3nJBF4iCvZ/frOXwzz33Fh6qyuTs8ceT971H2FrKXgXcXWMGtBQM7B3YEPuXDFHhIT7izAoHoM1yTgUgLQwhXZE36/9jjq0rJgEInbq9CR5vg6QMOSoF6rL0dW+1Li3gXPEk5Jd1A8NPnsveUJtTnmJIFaUZWriWENfAQrkzgkLkq/B4b4RnHVx1dOkfB1rIjKri/tCRvUu+MzhqKXY60imnfHmxMObLyFMq2rzvJwRWrl7Q6i2wTjEYsfVeOEYxjdE/L467juUnYNvWyfhL7E+
 0mQKPFle
 0xAPDtFn9jmuyT2CFbGAE3qrdDezauEYEmCAcR1meWr/Ueswz5HUYRj+6Mp+XcerbHhqXUHX0/rjSxJX9GSAmjmX0gbKVCgi/9B7vHre1Ds2KA2OPt7kUS9LX85f4KliVscAiqhq7A9E/NCoRO4nDO4zBlxwg+XN/jZmm1hjDUxn9jDw2AhQCxsufALwDoFM3PrunvrJg+m9PM5OG5QpRe9imw+o6w/VPO418s3ZRJfjZrOy3YMO5gu6doVZ9JaYHQXJcHRUIMkgeOluRCQRho45XdFLA9TeizH0fy7gz8HhOtC35atjcijgt+YMfF4XflEd4fEJjVyCIA8SrMNAUkwiT9UJvHQK96lYHCyd9f7eGJWQb4XXnCOrGlWrdSsieezWBgQJXiFlrYmAbzcrbcc3lYRjF/KkjpC6RKLkVdNRc23AcrxUlF2gFkLwCeGSOC/mQNvWHhg9B/+jWIzX/DwckF7+OsB4SWO0CPc8YF8Zweho9KwKZIIFyzaRGIIWRib9QQjbD5qqkxw1jIRw5nj8gYcibWHmN5YBZL1gXQ9t4qc14Kr3VNK0Wh350eWh2uLMyRsQ01Q3/X5OG0QpIIDL4LPvi7MQgvnng
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/6/26 6:03 AM, Kiryl Shutsemau wrote:
> On Thu, Feb 05, 2026 at 06:29:08PM +0100, David Hildenbrand (Arm) wrote:
>>> Ideally, we want to know on boot:
>>>
>>>   - what memory ranges are unaccepted - we have it;
>>>   - what memory range can be removed or added after boot - we don't have it
>>
>> The SRAT describes memory ranges where we can see hotplug memory. Is that
>> too late? We calculate max_possible_pfn based on that.
> 
> The cleanest way would be to declare the ranges in EFI memory map, not
> SRAT. It should be doable.
> 

Got it. I'm speaking to a few EFI folks on how that would work; if we'd
need a new type to specify this or we could piggyback off an existing
type with either the hotpluggable attribute or create a new one.

Thanks,
Pratik

