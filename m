Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5EEC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 08:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7983C6B0095; Thu, 31 Jul 2025 04:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A0A6B0096; Thu, 31 Jul 2025 04:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638B86B0098; Thu, 31 Jul 2025 04:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 524836B0095
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 04:41:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 243BAC0690
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:41:17 +0000 (UTC)
X-FDA: 83723915394.07.73D50D8
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B0A2100003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:41:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UENrrWLC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753951274; a=rsa-sha256;
	cv=pass;
	b=LkrcCkcFHoCrJBlsz+NbFH5Sl0owQhmZ3zaFj+zsEqszc6SSfKAqPEuT9JafH304o8yGQS
	6jBupQGme+9kdk4140a3QEt3My9Nt1WoYZn+ztx99Axgb6Z32cq2tL8UHGSddsGqRNaN+z
	m8qEq3bBBVS5WcIDiw4sygs+1tmLGyM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UENrrWLC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753951274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL7d/TFIGiAtJUUVQwLMK6k0XFGLk600bLVs+iShtuE=;
	b=kHTDYgMYhv92BMw2naD56unMGE6kUJPPjUchrS5xPvAY2c3CzwX+l55XDcSmqnObs0/XDh
	cpuOLrVoqcijf5viU78D8DDO5iXVSd9alof0LuiWOCj6TyO4woX7+buBsyLV1UlwpylfcT
	sPJXqfhdUbJtz9aXlmVbzxVEidksPxo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=POFloxeDRWjN7RGsE5lPRzQ4NA19w0F7hj/WmEH3hLNIJS+1kfYgTDFzIbodfUROZpcqXG4Fw+2oLks765LruXNmnd39oc5+EuxeeZaNihpDD21AyHKlaPLLJ1GQJpQEexH/tF3LzVOWw98HLG7YpZ5ulY5hny7GXPsHZu4EpOJ263KBgdY2cI6vS4JzDHWlS+hh/cG59IFnWUhEhQj+uMENlKQNRyjrWXMn2LCjQroQM5JSOZ0490Ejk5lVvkTVgIxzSJENLTQ+PQDbD6bl0lPO/K/vVCNnsCq16KVrr/pK5ZWiNgJFkCnON1NnvH5ZruncLBBW26K6wTLOqYhifg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vL7d/TFIGiAtJUUVQwLMK6k0XFGLk600bLVs+iShtuE=;
 b=ix8SEW48PAOCayGp0iGY2x5D64tN6RCZnf4fhwPg+wlItptUlQtyclJopQsU12H2IKFGygePkn+oL9VVqilO8W3dnpOhOM5kcTaVVGJktJ3hO9K8SKB+Zvnm9YvV7alYyKkbOv79502CHfkInZgJzNYFG40DF4D2lg6UI1VgDxZ3C48O0v0Pch3gqzGLX325XJIGIdQ9AUdnuoTlB3KuO6IutBJjZxwK09UaXUXmqSlomEyL6zn5phqTagsvNoJdbUKnSfAvwVzcLPhHVTOjmzqvnSVs+5x+LdgWWct+HHcvTYKrMT/58leWCH7Ozgi3vEX+85ShERmFXPhd/RHbvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vL7d/TFIGiAtJUUVQwLMK6k0XFGLk600bLVs+iShtuE=;
 b=UENrrWLCCC4NICqHopHApxdLSqYA1k0WApzRXJVCu5vCoQVQOA9GIYrwNiho3wR620379hufuhT/RjbbVlCV8QcuIqCtONA/YhUiomA1GmHGa3yjDWqvok3v79ewqPYJGMWJnZI9CrIzk/GsFNp4OtxwQFqHKETrGn6bNtqF+f5yVrf1bwcffV7ubAMb34dPAlOd7EjpDtiDKdXWMeosFzRttsLr4PHSvBOtQ9Tfnui8Bp03yRZNjP3rNS8YkkR+jZdWNQVxJ8soSQ318tpfAxCQJie9ge8doDCuHPhAc+0utxaI+/M6BhH0+4EeRfzowkGUC4jlUFA30Hs7ollZ5w==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 31 Jul
 2025 08:41:11 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 08:41:11 +0000
Message-ID: <1fa09b2c-4845-445f-9343-3a169e202ac5@nvidia.com>
Date: Thu, 31 Jul 2025 18:41:04 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 00/11] THP support for zone device page migration
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>,
 Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <e0153fb2-af59-4bcf-a07c-d650fa56d55e@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <e0153fb2-af59-4bcf-a07c-d650fa56d55e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:a03:331::6) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: 17f34c96-7cb7-4a1a-011c-08ddd00e0040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2I5RzZKRnpFRFppQ0x0WlZrNnl5Y1BmN2ZRVi9IanRHNC9BN0N0aUhLVkJU?=
 =?utf-8?B?dUZMaStuUEpEVDRmMm1oTnlQNVpVZHIrWlpvcDBHaGlvd0RybWVWWG45V3cx?=
 =?utf-8?B?T3BSZno3czJkWWF4Q0V4cElxL3JJZ0g1RXhScU1VYkU1V3JyY0s0SWMwNnJw?=
 =?utf-8?B?NmQ0WHBEcCtTd1RkRS9IbCtObmFOMExQQytkVlBKcnczNUpNYnRJb29XbVRD?=
 =?utf-8?B?aDZSMjV4eTRrRUlKV3A4bWZkOGUvK1BPNFRDS2lEY282VW5NVGZ2bmlJTXh3?=
 =?utf-8?B?STlUd2wyYkswdVRSdkt6emZZenpJUWhoa2pkcnBraXB1WUV5ZjVQT1NTVGg3?=
 =?utf-8?B?eHZMYmpVMkxLVXk5ZmpiM1lTMWtpYllVbkhJWmxYNkpSK1Y3cENnSGpnVG5U?=
 =?utf-8?B?RENSV1lIcC9DeFM2KzdJa0Zpcy9qSjRpM01ndTFCMUM4WUNjMVg1L2FXYUxx?=
 =?utf-8?B?ZVM5cWJZRnNZNFBZbEJQMjdKRVZwVUFmOHhYa0lnSFdEUjF0T0RzbEh1VzMy?=
 =?utf-8?B?cjQ3T1hkdnRIUlBPdWs1dnE5OTFpeEVJODFXcjVGRGhaYWQ1M0F0M1ZYcG5W?=
 =?utf-8?B?T2pvcHFuWjdEb3FOYVhnaWNWZ3V5YTZVT3NMRVRTWWJBakZSaDhGQ2NscDBI?=
 =?utf-8?B?ekp2QzlPazhvY1Y4RUlkQkZYRFVLd2l0bHZ5Ri9KTW5qSlpIVnBDQk8wdFZl?=
 =?utf-8?B?S2EzNlhpMDFiYW83TUZ5ZWRDUXdBU25CK2s0b09lTDN0cjQvNWoxaXJuSVFP?=
 =?utf-8?B?YXRFNlZaMWx0R1lxZjVpK2h6ZE5mZHZnL3FCdFViM3pDNGVEWnp6Z0k5WlZF?=
 =?utf-8?B?WEdFem4vQm1Tem5ZeE9rUk13T1p3aU90RUpTZk9oRUlEK3Qxb2kxek40Rkxz?=
 =?utf-8?B?MFNpbTB0akRmZkgzd0ZiNUdTcTRQbWFySkxDSDdmZWllT3hGbDZnYTd6RnJO?=
 =?utf-8?B?MDRlb01BcnVQRXVhbHVKSVpLbW5aL0RPWVAxTG5sUzhDK3ZJVUZXbllWZUFo?=
 =?utf-8?B?RmltVFdMeEplUjk1S1o4YTlocSt5RTY4SnVTazh0TnVzemduM09wTUlpeENo?=
 =?utf-8?B?TWp6UXlJbXdoWUY4M25NMlJiMU9ZV0JYaXJlNitzVUFMYkZFOVVGbTZBRERI?=
 =?utf-8?B?QUZWZjdqbUxaSlFFeENYM21FeDQxeXV6Z0lZSVRadEFEc0l3Z3Y1cVJDT1pL?=
 =?utf-8?B?U2ozMUpiZU4wdGZvN3Z0SWtnK3FyeDBPdnJzYlpoMEpBZkpYWlgxTGwwb05K?=
 =?utf-8?B?N2lvMStqUWZnL0dSNHBaVkFnWjYrMTRqeGZOV08vUmIvelg0ZkFNUE5DRnJU?=
 =?utf-8?B?ZVV5VXM5OW1nUkRYSUZrUzd6V0dMQXBEZE5VaFdSblhaNGprYlFvTGpnWkRD?=
 =?utf-8?B?ZjlMbU90TWxKT0w2dHIzUmw5TE96MHNuTVJnaUw0R2VmTDR6MGFMRUdoTDU1?=
 =?utf-8?B?Y0lFbzNVYjk0RVZMSXo2bUtqOEw0MTdBT3RyUG15MjVpR1pRUmZuWC95OUNC?=
 =?utf-8?B?cmcrL1VIckdzRW5aalBLenRFelEramprOUxJdTF4NFFsbkNvaC8vNEVDRGxK?=
 =?utf-8?B?YmVkd0Z0a2pjNUVhTlo5aXBCeTh6OGVVM0RqWTZqSHhwMlQxZHozWXBiKzZm?=
 =?utf-8?B?RThvV2VCL0MxNCtITlZEZi9qTzNOeXVBMnMwQmt4UCtNWFY1cWRGUDN4RW15?=
 =?utf-8?B?bjB6ckFXWEQvRS9CZlovKzJtOEZVNm1GTXA0RklTUWFEdHNuRHczS0tQT0lO?=
 =?utf-8?B?UDc5NW92M0NWcERQOFljM2lQT1dlaFJKWVZORHpReDQxZzZST1FHMzRyWkxy?=
 =?utf-8?B?ZkNyQ0hsQUtTM05oMnU2emxPS1YveEhpRjd5U213NndVMkh2cDM5elBnUWNv?=
 =?utf-8?B?MWtwbjlHSGZTYmptNEczN2VLRDJ0aHloYnZ2TEhBODZvYThhZFdJNGZ0QldC?=
 =?utf-8?Q?vMLMkolT0mg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkdyTVFrYnhmVFZQU2tzeXBYODZrdmREMm5mcHlwSnBLeTY3MzFNeEVaZTZj?=
 =?utf-8?B?cGlhd1pjbnVzN1dJbVFSeTdLVmRVL1NTNysrNlZjVXZvTkNPS2tmdmNLeWk2?=
 =?utf-8?B?cDZrcThKL1ppNEV6QzdWU05VeWFsQkZWbHozNi9TNm93WTRwZ3VjeVV4M0w0?=
 =?utf-8?B?cndZMDBHd2Jtb1FPZFJGazlVYUJHcVdvK3BtWHRuT2J3Wllrako1NkZkbHcw?=
 =?utf-8?B?K0N0Zlk2Qks5M2owRVlLUXlTbngrK0dXeXpmYTlEZkJkcFN6eGJKNHJLTmdv?=
 =?utf-8?B?SmtJT2RHS0JZUFBBaThRMlYyb053TFFKOHJnSGNoRlE3ck9aVVBxRGlLOWhr?=
 =?utf-8?B?cDhnbUlFV1BKK1gyWVVESXNMWGQ1dG42c2Z2ZVBQdXgvSTNOME9kSkIrNnFi?=
 =?utf-8?B?WE9STlVrRVJabFlkQ08rbURhUjBaeTd0UXFFb1R2Z0JBSTJjOVp6cllHUmxW?=
 =?utf-8?B?WWdXYzJJWG44ZGYvKzVFRWwzb1dMcWpGT3Z5M3YwRDM5NzFUUnJHS1R6Rm90?=
 =?utf-8?B?ekJSUkMzN2F5TlA0MzF4WmhsSXJKa0tHakhSZEVHSll3TndnTDA4QmtTdmo2?=
 =?utf-8?B?Z3poM1pMSjlwbmg0d1pIeEF0M0lCZVc4WWpWaG1QSHNKVUQ5YW5wQU1uWkhz?=
 =?utf-8?B?dHZiM000NG14M1NmM21nMG1PS29CMnpiQUJOem5hOVUwaDhmSU4wRkR2SlYx?=
 =?utf-8?B?eCs2aU1aQjR0NmtOclgwS2dqaVJXWWUvNTZ0ZlNkZi95dWxMaUZGTnlRNUlE?=
 =?utf-8?B?a3Y4UmN4R2RJblFaVlFwakhOcWdlT3FNSndZYkxHNGE5V1JBOUJuM09jKytN?=
 =?utf-8?B?ZGNnSnR5VzdYVzJCZUllc0ZUVUI3TDNTK2JyTTR0eDhaOWV6MWJ1YUNZUU1p?=
 =?utf-8?B?RHpMUDgvUjdjODU1NTZhVkxZZGdJZnltNWtPZ0gxSllxNkR2VStnQkdibGl1?=
 =?utf-8?B?TFZMUVRnRGdRSzhvb1JGMXNlcklpN3RhZ1NBRnlNZndUMmJYbklQTzdTOG4y?=
 =?utf-8?B?b1I3bStBMWlPeFltRk5lSFpxZFFuRitBckxIZExhV3Iwbm1ZWlJ5dFpmeXZv?=
 =?utf-8?B?STBJSnFlakJNUUVGMmdDa24wS2RaVHk2K3pXclV3NmdvZWxHT2JoWlZxdkUz?=
 =?utf-8?B?WTFUT01XY2lWZGtUUFIvQjBPRjc1R0xOU1crNW8vc09XTkxXMmV5ZGtzRGNB?=
 =?utf-8?B?VDRJZGY2VDc0ZGlEd2V0Z09vTDhDMCt6V201QjZGWUFreWVqY3ZZRmFHMTdV?=
 =?utf-8?B?K0QxVHFjUVAvVGVtUllUUUJtWkRNVnI3bmRURjZpQzdJQUlra3NtQWV5U1pF?=
 =?utf-8?B?cEtJbmNpekdWelVLMk9tcVRnMDR3TmNySEVxNnUzekRhYkxXLzJQYTY4UEJK?=
 =?utf-8?B?OHdkZVl2QUJCcVNxNFlrK3JoRDduTW5XN2VGVkxZTDBKWUplWkdaRC9zN085?=
 =?utf-8?B?UzhKc3l4TFZTRDg5MTQ4TUpOM3oxQy81MHFnYWVoWTY2SnlyQ1QyNUE4eFNu?=
 =?utf-8?B?ekJpY3l3RFM1UHcrOUpMQ2EwRTVPbysycGJ4R3prUHE0MUVCVlgvR1RZL05Z?=
 =?utf-8?B?b3BzZU1rNVI1NDlYTDhaRmtoNUovT0tmVUJYNzVCc01SSVRBUWNObTVheEFZ?=
 =?utf-8?B?WjNhenUvOWxTUE10UnN6WGE3WEl1UWZJNVpPNkozUWdvWVU5WHJmaVhKWmE5?=
 =?utf-8?B?Mzl6RmRPTGZZSi9YL3NESEpRbERQNWVYemhQeGl5Rk9oNVJSeGhTVDZJYmQ1?=
 =?utf-8?B?ZHppdmJISHR3ZjhVM21abXhPSU5HUld6emVJeVdGZHgreEE2NFJ0ZmRFd1FI?=
 =?utf-8?B?a3c4Z0JSVGcwWFpTVUJMOW56aXhBOHMvUUVpdWZuVDFWVTdwdDlpa3d4czVw?=
 =?utf-8?B?MUZvb0FmcTB1QjQzSlQ1OFQwVFloRzZpUVBQMEUzblp0VHNSOXFhcUd3U1Br?=
 =?utf-8?B?dkVEb1J0SklnQUJkTDNWdUxrbzBiMFd1OWJuOU9iV0phbHIwQWpzQ0dqL3Vp?=
 =?utf-8?B?UXdLYmdtQ1JlclQzbTRUb2tpQVdINzhGSXgwOUszYUVEbWNicUxtSk1YSkFp?=
 =?utf-8?B?N3kzUjhYSVNHUzVZK005U2lPbHZHclJxeHMrK0FJKzNvOW5wRmVaSXZJN3JJ?=
 =?utf-8?Q?NBHDq0pY/tVWDGRi4wZwYZTA1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f34c96-7cb7-4a1a-011c-08ddd00e0040
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 08:41:11.0186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDYZ+zgQurh+YSVdaMcdU7FD47/PaVrCOAkk1reP18DztNnQfK8wn59Al/x5+HjI5OcWE/ZHXTcYTF//0eH25g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29
X-Stat-Signature: 5biej67okd3xwmx7huoaprabremyptei
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B0A2100003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753951274-352674
X-HE-Meta: U2FsdGVkX1+MVsI6NQYNgfD/+tcB7EBis+IbH7KqyI2x8iqG7TZ0dDsQr+Xc1VFxxnzJv3LL1gWPzbxG1C9E7wPsL3XmWlYqLWXcSk9lWGT06DeH5DMS4LzGeYARu/JRJdwetoDMah6plzxZwKuF4bkuez78+8ZBtYazH6BrzA9Z2xV/zV1b5gVt19MF30ljUSJ7g/vwzZxKEVqv6UweM1z+IYEMU0Vpalz+9pm3HIzpzQwFfcuH3qIBr5sZ+Y8Tqg2MLelpF0N4GiWhxslirqdrjcF9FNfM0fpwUG9l3FT4Iazme/p8hcOe4oFsWvHld4tX3ZRlS7mJbLe15njj9tnmkfinxJKSmIXzX+7cSQ9EXoncgb2b8Y4seBxT4mdm3Kr1nTSqlcbQSrv2vEBQje/mqFUv+o7Cn3yyewwPUivaGOVQc855BBBOMzUAjfb48uyY6uNmzNFqP8lOFr6ynEg15hoL3VxSouypLWESHAmBj5SwIA1dyjU0OBFO4iLnnSpYi60Y3eDHxF8nhZiWevtfuccZ8obUxKH4B9HdahUXKIPKjwfSr1Gx8WPywXoo0d5+Fwtp9sAYShLOgr0OvRdQFusi0AQKzyLwrJTYkZzlkDQjML5ycMmPx79QQ9mVh2gSvZIIamTwTrgVzNcKJDX0184f0PCvt77g66Lr1PJgpbdrqyZ4TMDK7KXnT4m4oDvw61HFR+WOD4i4vf8Z68W6OY3yyiyf02QcwbSsSGm2lxLr7ZBeaW1h2k8GBRH5Mc/Tcuo3UztKtdkFwsoeoLRK2NdOMBOYGun1bLKJw7uRXVyF+3qju1u1K2G/MxfnAZehCf6JG9wHgyVqrVRW7BlZJDUfVVLPjGtpRGTB7SVz4V59NBlOl1x0DVxGnJERGHHZGTykFp0W8Ijt4LbiINGIw6Nd/8B6qiqwldi+uZx0AHMrqHCZy1a2QW4Pj9Y1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 21:30, David Hildenbrand wrote:
> On 30.07.25 11:21, Balbir Singh wrote:
> 
> BTW, I keep getting confused by the topic.
> 
> Isn't this essentially
> 
> "mm: support device-private THP"
> 
> and the support for migration is just a necessary requirement to *enable* device private?
> 

I agree, I can change the title, but the focus of the use case is to
support THP migration for improved latency and throughput. All of that
involves support of device-private THP

Balbir Singh

