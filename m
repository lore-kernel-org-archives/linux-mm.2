Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10937606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4ntmeYhk
Received: by kanga.kvack.org (Postfix)
	id 2D52C6B00EF; Mon,  2 Nov 2026 07:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EE96B05B1; Mon,  2 Nov 2026 07:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100006B05B2; Mon,  2 Nov 2026 07:02:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCDB86B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:02:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D268C0C2E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:02:05 +0000 (UTC)
X-FDA: 85390040610.04.4965854
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	by imf13.hostedemail.com (Postfix) with ESMTP id 485EA20009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:02:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4ntmeYhk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.107.208.60 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793620922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgVSr5e24PcaRye3+pb56SSUJHvpMmVSoKLrdqhQzd4=;
	b=vuGxzV/4hWKC7UZI/FbrH6ID3QchICeb9kOeXJjgoNDoaUhiAkRzey3pMBDJdszIEi9t8a
	52j0ByDh5D90Rz5B8XCMGr5iaewJ3v3EAn18tZYp0rspNaaXst1DBPdGWr3WHfcL1tQmI8
	nd9vOrTHLVclZxj8l9GWu/an8wxoQ9M=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4ntmeYhk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.107.208.60 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793620922;
	b=tGxY9M6m8wI2OGK1X4A7WFxmSFSjaWRJnycPfq2XEP17ZpmBbhDnaudY5r7Z8sWGod356E
	RpkVhRe2kfGdjLnXnUxHHI6AVWMb9WSi58/FZ/onfTaNiprgehNBl0NjEVDzHh5acPt3x0
	7D/K2Q/xtl096d8raDa7yhtrCiS17cg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUR9MglwPYCaK8w4cYKNzz4+0bFEwCQLE2SUEdEnUtNDkunmMqBgC24pWufTVyly+EuqOtG7c0bncPf3kkdGX5TJNNGhzu+aaKuSNYHjWsgybPbN3COz/a0v28RGbgyybpxwEU505TqHCiE0Aqxncge6w35WVtgJ8hmOk/NE7swl1OCejooTtyR8DhDhq0S+wRGHWq4248cZmc194SryHGN/3xIXBqsMBsVTZlN4qCoXK33D5eiji41gBeHcZZbIU7SEB6aQHxmy+B0HGkfkYPUWI6qEJI+JYcwLwjYaBxg00kuaK32ZEHyB/mqctD9YyXKNWUVkfhA3BirpcIAJHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgVSr5e24PcaRye3+pb56SSUJHvpMmVSoKLrdqhQzd4=;
 b=mk46NBoB/19DuEmscurjNCl6K8ibNC8hGOyTxfz1LzyxLcYOps0mLM0YAJZehdWHff/0ZjL09VIfQUwMtjXZnSwdOstQcq4UlkVxKRR/w9D5n0gSerWEGX1N8U9/X+cw1n8G6ezgu8w5G0RtVQHSTGRLEcoDPYRIPIApX4VB6M2bAe6JGFROMg6mnQWiXjUtEgioHKwLbKnbYSfAxsoF29UpfVpjdl4E1TZkcpN4CEoSQxfsVBl1etMCYattadlbigk6IaI7ygxrLKkTa4pKEBD+AIPx1M9QKZpQpkNfv2VFAKahBsGJ6VbRFiWp08/ELMCys2m2+8FsutXmCkzfTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgVSr5e24PcaRye3+pb56SSUJHvpMmVSoKLrdqhQzd4=;
 b=4ntmeYhkixJzhsT3jggwGYY6RktD3YRdJKKzKywuvx8UiciWEz+TmQLpWuaP/g9TahWFwNWVDHVygLu2vP1AyZ1eBPkRD4pf/k2uEIh5HbZQfks4K0RVtRIonLXrRawMxBqT2QdxMPP3DPQYBefArFTtlWihAGXmrHHQY/EogHM=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 CH3PR12MB8459.namprd12.prod.outlook.com (2603:10b6:610:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 12:01:58 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0569.010; Mon, 2 Nov 2026
 12:01:57 +0000
Message-ID: <f241f883-39f2-408b-9f44-574ce8d2910a@amd.com>
Date: Mon, 2 Nov 2026 13:01:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/unaccepted_memory: Do not accept ranges that are no
 longer E820 RAM
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
To: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky
 <thomas.lendacky@amd.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org
References: <20261102113127.161823-1-pankaj.gupta@amd.com>
 <bd56cfa0-6fdc-4e83-b571-f2abf647afa2@app.fastmail.com>
 <a9fb9818-39fd-4b6e-8998-761bc3439893@amd.com>
Content-Language: en-US
In-Reply-To: <a9fb9818-39fd-4b6e-8998-761bc3439893@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34b::13) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|CH3PR12MB8459:EE_
X-MS-Office365-Filtering-Correlation-Id: a81c35e6-90e8-486b-a7b3-08df38d9183d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|4143699003|11063799006|56012099006|261009223027099003|261021121427099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MmvANkclssvv6Gt7LBLTn24c+lP4ql0OClBVPjMCa/efAmgswE8eF32+6CQU11wXmjdVLqGMF3kzgqVaoKG/pwrRh1OC4Pd8KimgCMi6NdXrDD9ML1BMR7bqiH4osdqttL5EFOoZsf/dkhLNLVPDrBfSLktRQqDyJPZ9/2blRcsqWaDkf7QjxxTyJ5hNjxWBuk9pGwm7BesKPyrbQL3XctQnwy7hle2pPUPznYeGdApU5SLXnB/EMIWByl4yjbAkNGbmJPji2mk1VudUt0FB90Z87qhFTG+P6nDfc0rao3yPf6c4WAfWbEHtZRqVHrq/K2uOItO9iNR8wONfZcvC25v1LDE2ICwfilnSfApe3eT+SZHwW5omvBqcol2WOo9qp25dtEoi9m51BT17azPxr2dyJUb3p6KRi1gDwEqbMYpfm9vx/wU3x+24IOQe9p9IHVFOJEY8ZnlOkIyIkM3d1LZDmEXQzGQjo0TnCqyrZOYHZ+Ul0AH6hgmq06dwA6RBQozDaqvdLcb5DuL2032W2lH1W04xPG6olfbkjB/LRtWNaEmfJa1KTnv9uMpFzo89J0jVrsHY2p2MD4XnmtWGfmyUYaFfUp0vGOW+FPDUKlk4Fg3oPs5I589rhsoVE3Xy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(4143699003)(11063799006)(56012099006)(261009223027099003)(261021121427099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDE4bnpwUjVHTm0zSkRrTUtQRXBjTFFORWpmbDhGSUNmcU1FNnliNkF0OTZa?=
 =?utf-8?B?NzNVQUN1VkVsTUVHc24xc3VPYzNCRytDZkY3Wk5yT0xQNEIxdVBwYjFaWUta?=
 =?utf-8?B?QzNQaUg5WVRuS3RlS1JqRVlIMG8rQ0hlNzBOWFl3OEtCL3NzUmdtYXVBb2VL?=
 =?utf-8?B?VmNnazRCUUJtN0tlQ0puM0xReHQ2ZkhHZXgwNFJGWGZMbWVjbzhvWjV3cDFj?=
 =?utf-8?B?cGlVSHJObEpmNG1SWFhFNk80dC9nM1NwRW9UR3RlUWhxSkdoamRoUFl1cUJM?=
 =?utf-8?B?VDhZRE1PbjF5aVRhcXlVaEdhNlRXZFdLb0FhdjdsVnFWMjZ6Rlh5cHpvQkxP?=
 =?utf-8?B?dkQycHhYVkpQd3FPY2hPRml1Q0VYOUNnSytHY2gyZzF1STZjZHYya3FFSmRj?=
 =?utf-8?B?RXNHdzJPWTNrWlVVOElLVVVacXc5NEZEV3FxOFVsVWhyZDY3R29OWHI5K2o2?=
 =?utf-8?B?Y2p2YjFCc2IzTVlpWW9WaW9LTUdvU1R3VFNFbFN6Qk5XYkcwc0NCa21oV2pj?=
 =?utf-8?B?b0lieE5uZ1N5V1o1Q2N5dTdGNEtHVFFxbmp1OFdTMi9OTnB6S0FLaHlGVytt?=
 =?utf-8?B?MVFJUm5iWWpwSmtGOHJ0eXVONEU2Yys3QnhUTGQ0UFdtRVJ1Si9JeGZmNTcr?=
 =?utf-8?B?MmpYQnBrajd5QnpuMDVZbnpLSzRIQWNOOHdzTkIzRjBwSTFGbDAvUWZzUys3?=
 =?utf-8?B?VjhTTUxQOTRydGRuUnM5T0EwRnA1bk9zV2hWNDZzUjJQTjZlVkpJUEk1VEZD?=
 =?utf-8?B?dU9ldUo0a3J3K1lRa3hoUVlycW82WkZidjBVeTlnTkFxTjFMU1h2dnVLMExF?=
 =?utf-8?B?WG51eis4UklnV3p3TGxGNjFMMXlBaEtnSFk1ak8vdW1BdVdyM0xmT2hlS3VK?=
 =?utf-8?B?SU5hcCtCMjR2VEN0ekd3UENnMlpYZnVPRk92V1RkNCtQdUIvRmUrRDZTelg4?=
 =?utf-8?B?UVNxOVZWckZNMWNTNVBtV0pWTnNDRi9ZRDFHc3dvQktxVjgyUEFFYmhYY2Ni?=
 =?utf-8?B?S3NIeXVRbGIwRHJiYXl4Zm9DRGZTdnYwdTB2SGcxeFFCeVdKZDR5UWhDeXZD?=
 =?utf-8?B?NDBFSm93dVk4SjRadW5CNEZIMWVlc1phUmd5OVlTcHZHZVhWOUFHTjZnbExJ?=
 =?utf-8?B?bUNpOXZISnhkeVoveG92emdEOXRsS0dmUFNYSkNVenRCVnhNZEYvbk5sVVg0?=
 =?utf-8?B?SjRzOFpqUkU0WFdSMS9tQjVzeERWc01CME5XRkl3OGpuOVJkUzMweFU2S2Zh?=
 =?utf-8?B?MnVPR0IxOVJYRHFuRGhxbHM3S3hJZkJpSFRTMTBSaVFYby9QdVV3VlVTTko2?=
 =?utf-8?B?RTkybzJUNXBQdEVpQXNObmxrZEZKR2tOSWFWWFJmbjVnN0ppNC9jSW9IbFJw?=
 =?utf-8?B?WFp3UDNJVmY0cE4wM1FUZVRBWDVxME53K1hpd0JnWUlkL216Sy83bmdFditr?=
 =?utf-8?B?UmJyK2pyWXJnYnlGdFUraFVpbkxWMVg3V0JlMXREeHF1dFVlVjZyNVFnYzhr?=
 =?utf-8?B?NmlqTTBHNW4rb05tczA4TkJ3QTJJOEVmRFpvN3V0QVRIQXhTcXllRHMvMUJy?=
 =?utf-8?B?V1JkN3JXNmxIaVZ0VEtkcVhSQUM2ZzJXcE9RQUxRTkdoSkZ6ZThQOTlkZ1VV?=
 =?utf-8?B?dy9qaCtBOStWT211WWFscHBoREpXTjdHM0ZNWVhNVUVEV25icHp4SitDaG9r?=
 =?utf-8?B?bDVNd2ttTHd2eUtlNk5lR3RxdHFSMTRTTmVnek1CRGJhUzA2QVpHdkNkclB6?=
 =?utf-8?B?cnNsSmFDT0hjZjJZK3FlSW1HS3ZFU2RQL0J4b3lmdURDZkpUUXRLajV2TWJS?=
 =?utf-8?B?N3lSVVFPbFMvbnN3Unh4NGlpdVVOOUZIM2ZOdDJaY0tuSzFLSmg5eDNpZzNV?=
 =?utf-8?B?T0tybHFUU2NkQUFESEVaMzBaNlZSSzBZVDZ1b01hSzFlWkxpcGtBY2NBQ2FT?=
 =?utf-8?B?bnI1RHBVUzBHem9BcUhzTDhuS2s4NzBBKy9HeFgzK0Q1NEYyMVd4dG1WU0gr?=
 =?utf-8?B?NUMrOGM3bWlFME8wWUl0amRWWUlBeXI2RFVwSjFXWWJMN00yZHNHWDlTWmNp?=
 =?utf-8?B?YWZaK1NQclZMTEdKbW5nYzZJelBrM1FiU21UTGVrcTdXTGljQWtmNzQzUGlN?=
 =?utf-8?B?dVBPek5leWlWbnk1bnNBUWtkamw3TVBJamNnN0pFZjFMZ1lQanJVMGtpa2Y4?=
 =?utf-8?B?Yk4zZWZwaDV5aTY1THB4VktyZmE2M3BIOHg4dzljL0tJZkJkMTh1SG1PNzdv?=
 =?utf-8?B?U0NMdklyN3d2T20yYmp1TUhYTVVlSTU5R1MzdEZVUDcwWVg3T2M5dXd0bkVl?=
 =?utf-8?B?V0kvckNEcUQwVUlwYmUyeVJrd0xvYk1CME9ReWZocUJ0QjFCOEFqdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a81c35e6-90e8-486b-a7b3-08df38d9183d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 12:01:57.7836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7Mqhxj9pFirm88NqHv51JSb4ICvns+VXrLgifQx/7+LM2OHLWJloUPtA2sIaHHvcFaMGjlnSiv7XAGsIHYI8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8459
X-Rspamd-Queue-Id: 485EA20009
X-Stat-Signature: oejr3g6dpaw774sg74384kn197nkutim
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793620922-587620
X-HE-Meta: U2FsdGVkX19eKYD0W7JY6K89FKiGp9HFWZQ2r74eLDWq8imMZjRlHalqweEyTEAk7cleHz8CWKJDxlVwnWCwX0nV/NBQfMy4xAUptZGHPq6C8XcuPPLhYMPUh4TE0UUZU+v0IHnV1DOZGY2t1KY/zWk8BSG0zrbUubvxJP5FvGOgO729jLcP4be9DKZyDeaxrOoToXYYAx+X5dBJYCLbtLerSxyhfe7mXLYN58G6GhL84lLy5LEUFpnHfzqkBvBz8MSmnaOcTuJx4qSzasI/CIph5oGkItg4r3Kam9oaBpDAnfwURP9vWAVsppbBK8+8gfIoY5FYIJi0n/e/0FEVkQGJC+D+3dLhJx3M2YyMQd8ikr7ERCQpIpCQ/UzHAF3oV020HbK2kIaP5lDs9n4L+t7oBgaimjTmR4+sBFnXcr1kwoC2RZAiAfYCQeKM2wXmDTmm2plLTMQ7qd3PoNRrHuEln3i1/nyjBUuhLA4Cq2bpYzHYxtkFE9NenmmaTCAnUrWxfWlV1CqegNc+pT795mRTlMevDD27hAgLVpLoWUJ7Tu2F+dafWQGONrtogaVBgZ9gOlGnNreo/16W4RBz/0OVKUsa4mVboYn40bZk/USqo2HL5nSUN30Cfp15d8ISB8FJ0RrjfS7IGXRibZrQIZXHmbjHiiyVV0OHXatU55hXLktSgHZa7UJu/ntvuNJL+yXGRwCveMBOJ4tP9wFBmS/lDUk1MAeJhKMoJVaucivrBViQg8VDu5+NE2fFMs/4NvcX9VPBxJArH44sMkN7IU9UQBpCfWeOJsR5RUU7WJ744AQBzdd3JBrE4j82irk5NGTpnVvMBF43pl/U5BNGFhrkFmFYRHiY05Jzy/tbu0oOebN1eN9BnWCdOn8VEiN383mxgWCIbb8K7NW7qHc+OY6HNdo5ggo80KknOovr8EXU4fYK0Mzw71Nz5IQCe63ZD7WwzpWaqpfnc2xhkgO
 ns9JOCJt
 gASAbABY2Uhl2VvRTfoLUHMpZzSUX94Jwx6d1z3B1JQKu6llzJAWvXBnUm5uCIzXQKiKc3LocpRhSpweKXa2Usy0P+n9kh/RsugsfvDVD9Q0G/EWhjYu8Sr4nZNy0GbAX6cLtdCfYPiuqrBITKl+nYKWqqERQaOv8DVRrmtF1bVndgX7My7RGd4Uzo0CUZFXKDhlFzdtLd0WEL9FG2nqTRfMhtNeMXKKt+A7BaL+Pv8W2tmWt/iZWT40pN3G+nnXMMlcKh4N6GN4qs/3ez2HF2yWVNGs2QAI+65rKcsc2G9VO4faug7K0gXnP2De43rID8KYu1VpVdwW4Oa0M+uHk1c3YnNfUpdxbp0jwXCx4ZSzExyaP1M2MDh0T/PiwZBtpPhtJM1GaILMH+1S0t2MkQTr5fiD+UbwjPtCcG+xbs0Ob0/bXjChaqCwveskO8J6gde9KuGOm/ZlEmb+PEXS7TirrpYpDNdTCgpOSmJrWw2eYZY7FhK0aKG2o2rBGBubHHZ2JWMIUqpLy8X/+gtIDcYmM84Z34JTagEp5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>>>
>> Can we just disallow memmap= when running in a confidential VM?
>
> My experiments showed: memmap itself don't have a problem but memap 
> with a hole is causing crash.
>
> There might be some usecases which are already using this, e.g:
>
> https://lore.kernel.org/all/20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org/ 
>
>
Its also good to have a general safeguard to not accept memory that is 
not marked as RAM in e820?

Thanks,

Pankaj


