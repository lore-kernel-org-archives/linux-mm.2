Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D6E606A810
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=KG2T6QrB
Received: by kanga.kvack.org (Postfix)
	id 683CA6B00EF; Tue,  3 Nov 2026 06:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C186B05B1; Tue,  3 Nov 2026 06:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549AB6B05B6; Tue,  3 Nov 2026 06:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 333FB6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:31:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C44CB140381
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:31:34 +0000 (UTC)
X-FDA: 85393592508.28.DA7CB68
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id DBACA20006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:31:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KG2T6QrB;
	spf=pass (imf13.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.52.9 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2SnKxo6sv4vSn1dXELKrcR20Glkqp4+7/ht9vZM4ow=;
	b=AXLTC9MLu9rkNqoNbg6kCG59lyc4B3b+v2h2Oa0qYkNVi+zfwfdZiydK6wgFOgb90T/VPv
	tJKbXCr5Jv599Jktrbr1B5voZyuAcu2AYlw3Oz7jKON/1Uk7jZSUxl0vqV4VpD0XLvEpHh
	u4Qunnd3DKhdBzM4didTyTt7U7QigRw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793705492;
	b=FyvOXVNnGZj4Xeegf/k/850eYg82/cMkVnL/W/AZWBn3c9M8R8QyxPEVD/9qn+36Ze1FUA
	JhAq0LmTWOgHfr4xW6stJoVJ8bfTBEsc1lC6FxIOZezCD9FUyhhqkZodjyqi20fDrodjMU
	FxSI9229TVTRSMYxF29WnBonxQyV5kA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KG2T6QrB;
	spf=pass (imf13.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.52.9 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4wz1FuZHEniY87JJWyaDnOlfV/b7wg2YJAY5Si1YQIlMSu9VPgasZa1Mop9RpNycer5ioFKFrk4P8mHR1x9QSIeQUnpjR8FY/AGcuqM0mVS1glhU6XdXxAUgmcbqZzTH+c1szG0wbs/6AE2C1ZkvBOyPag7pKHKqAz0LLm0F1sr2bvM+htZJH/JEjhtdL+BMoFG2etnkuLTWx+kak6TIkhmPmIMCe07vdL/x2Yc5NksMyi82FVHC4xsqm+HVZuCYoBoUqD3gfJaToq6MEMmF0GDSVlStvNVihWoJlUaB6nh6DVZFZHQPhKe43ngWEan2Q5Rat0vV3klWAbhQ4/M4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2SnKxo6sv4vSn1dXELKrcR20Glkqp4+7/ht9vZM4ow=;
 b=bMSTEKAbeDRePXo+cfef3V/GOeJPFsRow7x0OzhVfyAoBnvNdaFxX0rTvBn4n+VvJ+wckTMp/wFRWgHVjDt1F0EYM/8r+yLv9a0uENAu53ga5XgMGX3M7JT/1G92VD73Hv118dodOsopM/8WyHl0gjZAySOle/ktY+2OB6TQeVO2cP654PmsgfeKpRb+xNsMoOb9pljQNczijbrRv35PZZObiQDQqi8VWXS/KR5fZO03Riwwj4YsmHMMVBUpM2aJ4pplpMAJqgrp3G/GXCkB0iVfGbdk8y5NWf25XFcv8pKU2H4x2MPfjQw+tRH9gWYaCPHX794yY8HTTP88AcBTjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2SnKxo6sv4vSn1dXELKrcR20Glkqp4+7/ht9vZM4ow=;
 b=KG2T6QrBKr52w76udPJ1U8Do3tJdTJhOZ1iSwFJmRaqkd5kdqE0oapeBf3BXaBmtR6wBaJI1LZKto21uyp0U65e0hO1OzEQEorkXvM3WEWt4jX0CcG4YlRLKOvGEGVsLpHtl+OISmmazIgTYtZrnNXnug+p8/FQ1qlTXR+F+EQE=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 SAEPR12MB231369.namprd12.prod.outlook.com (2603:10b6:802:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 11:31:28 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0569.010; Tue, 3 Nov 2026
 11:31:27 +0000
Message-ID: <0d37c6e9-50df-45ea-9187-610b55c70c14@amd.com>
Date: Tue, 3 Nov 2026 12:31:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/unaccepted_memory: Do not accept ranges that are no
 longer E820 RAM
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
 <f241f883-39f2-408b-9f44-574ce8d2910a@amd.com>
 <deb5ea81-70bd-463d-8d98-ed51c316cf75@app.fastmail.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <deb5ea81-70bd-463d-8d98-ed51c316cf75@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::13) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|SAEPR12MB231369:EE_
X-MS-Office365-Filtering-Correlation-Id: 9994db77-0d60-44a6-5a4f-08df399dffdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|4143699003|11063799006|56012099006|261009223027099003|261028144727099003|261022105027099003|261021121427099003|261102123227099003|261021135927099003|261026121527099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9ICpa3gh0j4/qruPv6bi3Tz0dSNemJD3ez7XLGWRzWMzR1Uaj/mKzBFZShlYXwN+nPWPytP4fBGDZ226lr4xNrPFdkiMu7ECP5zCeX8XT/7d/AKBG1axKeaSgt9qZCuGkuHQ9zNQXLVFWXjiVz83bZxGdrDfjNVASov0Y6M7ttDdSvEtfMMUXQo4OJLNzfsEimp/ERF62cWDXt0X1V5StnP2SIDvEhxf5lrjhzpV1eWoCGBk4mT0aVo12aHndy1pb6J7JWI9rmqvR27CKXjN7pcyXnEs6e4saguwv1pe63dHYGq5Gg5Rq2/4nxe/41DFMuCJ00V3UWiOeWXk0Sc9nQ5Y9hTqhOycF4LKJTk+Tj+zadW8cNklMaN4XYAsq7KDGq3vgEfl2imEfkC+5TWQ16ikzf1+jwcQAHtuHTp1JtmbwEm4gD2PzDDyZZfiXNw5AGTM8Lvc9CogcmURTcDGjautf1rDlH2v+S5Y82cy/sht1F15tfLBoGahfncllpa8by9kiKFQKz5Fr7HgfXEt541UmDcTru74GstTOyH7Lm7TwcNwgrG/3Wc3R0UIJgBlJCfwQZTsCy9nyBZdM6iJ5VGXp1C2C6vnKF+EGVXZYPL13p898MFRPfqtx8G0JEUy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261021135927099003)(261026121527099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFgxR3BHZi9DbmlVc0x3QUo0R2J2WUY2em1OQ0hPQTVvVUs3TTFFK1UzTFRR?=
 =?utf-8?B?dXkrTytMMEduakpLSDRjdFAwR0pPc1lKbGJ4eXdVSFBxREhoMHJ2c3VTOXA0?=
 =?utf-8?B?bWV2TEl2MWFMMjFIZkE5UmZzUGJTcEVKSXJmMTVYdVZGMUcvOWd5a0J0Mkw0?=
 =?utf-8?B?K2JSQ0hrMHJQNGpsUmdJMU84M0NZNDR2MnBBTzVtM0R4QkNxaHBwN1E5b3R3?=
 =?utf-8?B?eWx3NVFlV1M4bWRCK2g0MXpyeDlnTmI1UFlLUWhWaVEzWnJoSUwyZlQ2N0VP?=
 =?utf-8?B?OWdiNVU0YUZtR1RYZHFaR1g1VkJ2VjRCOXpFTGhSTWptalcyZ0I2OHhxcHFY?=
 =?utf-8?B?cTh6Y2dSUHJmL2VINVhJd3p5STFGbXpPM0ZjRHZ0SmpBcG1LQnhScGxDQ285?=
 =?utf-8?B?OCtZK1pjdTRnSlJwRVFmNDMxSHhrYTgwNW5SN01VQUR2NjJQdzgybWVuVzhW?=
 =?utf-8?B?NDBwV0NtRTZ6U1VHR0lJK3VxbkRNR24zalA1NzU4REYxU09mUXRRcklUQklN?=
 =?utf-8?B?VnJZeStBZStnVUh1VlpUNGdJOUZOclcwaXMvWW9WeGJ3U05vZmUvVmZsaWZM?=
 =?utf-8?B?NTMwREQ5OGF0LzVxdm1JWDIvRC9qVDQ4SVFERk52TW1qNkU0S2J1dENSSVpS?=
 =?utf-8?B?U1J0S3dKSkJ3d1V4eng2N2grZjk1ZVVmNVdtRXRyUzBJTWRVc3NJR2lKbldr?=
 =?utf-8?B?dndJcnVNL3RTSm96QkRNenNlRmRkOWhsYnl1VTZZRS84MXg2ZlorQkpaZXdP?=
 =?utf-8?B?R3FCd1ZIekJoUk01K0F6MVRMazZvc1QrbkJaakZEbUZEMEtLWGFSN25jckhv?=
 =?utf-8?B?M0xFY0Z2ZUU4TFdUUUE5RjdMdTFHZUZxL0RWSW11cC9qbkhZNjFhaGZqM1d1?=
 =?utf-8?B?OVhLOStNZE9XQm1IYnFPVFhBN1FhYXBpZXFYUTlEVjExL1ZEbEtpZEFKaTNP?=
 =?utf-8?B?Vi9xT0dqU1orY3NLQ2dNRFZRTWdGL2hNWXlKQmM3cTJOL28yZmNWNFJVVis1?=
 =?utf-8?B?Yjl4RWFhd2JYdmlLRGJBMk51UkVIa0tKc3FHNytrV3kzVG1uOFRadVpNYlc4?=
 =?utf-8?B?eUx0RWhRN0E5UEN3aHdVUi9ZdytpMVY4YjJGTlM2QisvaU1Uelo4VVhVclFn?=
 =?utf-8?B?N3ZCZUh4a2NBVlBtSVlvV2gwTHhNbkhURHk3eXQxUDRNK2lGNmpSamZPVjRv?=
 =?utf-8?B?ZGx2RWx0Sm1PL3JFN1RoYmdsc2FrY09kWENZQUlheURTZGhlNW1SREt0N051?=
 =?utf-8?B?MVNhT1dmTHcwRGVRRUdHbTdBbHhudENQbWdXUm9GNEtzYThocnFJZFAxalZ6?=
 =?utf-8?B?T3ZGN0RIQ1pPVzJjMFRHZXpMOTRWd2Q5aERDWVZpYngyZFVKVlZRWmN3a29P?=
 =?utf-8?B?U1o1eVRPNVN4OHdYaGVQVEVaY2liS3JydXBJdCsvL0hhc1ZOYTIrYnNzbVpE?=
 =?utf-8?B?VVNoYXlUdWFnYU1BenNOTVgzSWQ4RWFIZXRGcGNlVENDWks1K29NSEZycXVP?=
 =?utf-8?B?ZmxHNmY2N2xIaER4MnRCZGNCUXpUM3JWdWk3MVVDdUdjSmljcTJLQWVqODR5?=
 =?utf-8?B?azZEQ2IyK0pzMXkrSU5GZzNVMkp1SUYxU2pWUUdRVy9kZUx3cmxSUm1KamZT?=
 =?utf-8?B?cktzRy9Ia0d0NkJ4ZEI2SFAxajk4TnlYZnhWbCtiRDdRMjRUNVljaTgxS2R2?=
 =?utf-8?B?TFZ0eW9TdUxVMHZsQ2t5cWdZU3ZFSC9ySkg2Q3RrMEJPVUxWcWpXeThXM3ZN?=
 =?utf-8?B?Z3ZsUnJFTGswTU9HZ1ZBaEd3cTBtMkMvRnd0SDd3K2NIdDYrYXMrOC9rb1Zp?=
 =?utf-8?B?cHBoaXpRSmR6cVJ5R2ozcDNrdHZrWFJPY2tROWo2blRuYkk1enhQZHpaK3Zl?=
 =?utf-8?B?WTFwM2FtUEMxUXpSWVdybVhQcmU0QmRjdkFyRkFNYzY5RHFsTFljNGpsYllE?=
 =?utf-8?B?M3hsRzV2ZFdLL2NoS1BrMk9xdFJFUytpbDFOQ2ZEMjIxdUs2SVZJaS80RHNh?=
 =?utf-8?B?SEpKdFcwMm1ZTjhQbTZmSUprU1lGZXBBaGZsc2NHRmVlNlZZT0NzemJoSEhv?=
 =?utf-8?B?YUFmdUY3MExRdVZBek94cHlmNFdydjRxNTdiTkM1cnd1ejdLVEV6QitNdGZy?=
 =?utf-8?B?dWMrS080SjVod3hKOGdDVlc0OGNhc1dyTTNhbjJNTWxsVXY0RGhLQWhENFVk?=
 =?utf-8?B?M21xcjBwY0dFdE5OS0xrSXlaZDlrMXJkR1ltNnhLY1dmY0c3VnB4Qjl2c0Mw?=
 =?utf-8?B?aEhxTGppcE0reWdyenlTQWlzVlZjVlNISmRucEFPL2RWNCtrTXRxVXpNZHp2?=
 =?utf-8?Q?3t6N76/sGdvE1vMdWx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9994db77-0d60-44a6-5a4f-08df399dffdf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 11:31:27.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PilKoSG5me1p/6KlkChbXWLYH07t/FyGJc3xQV/nM67XlOd1N+yahM8SeUBrIFRs6NBRzTo5aI5gkl4JlJD8xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAEPR12MB231369
X-Rspamd-Server: rspam06
X-Stat-Signature: a3fp4raqrwj87to6uuwnd87dtijusfwp
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DBACA20006
X-Rspam-User: 
X-HE-Tag: 1793705491-650150
X-HE-Meta: U2FsdGVkX1/js7gARvY7w82lvsbNcIFkZKXLRM5fhp+zwOniOuVO3vLj07u8j8gJ0oGeJjeSfqi2FPdLdDozzALu5i7/DRBsAvb4+vfzpsn3ZsUZzfauRYMv9MvhN9+CcA2zIho6dwMvK5udh2tnZ56LwYKfARBArX86nMo4/apMMSUcRxeHpHDtLj/P7Zh3udeHn6oMlkJoIQJc+piTwyPGstRNJ+7i4MZiorEc27WYbqHvw6Gm+B3DBX+3lVgevaodGH3AGg8dB82819NByD98Vtq6d76uD/g0pIBWVOV2OkmgEoVLsIxLo1JEBm4+baS+/B/+zvTxtQ1lIVfzCtcdL3hTchxRf/1MjLPwIosr63Z1QupTidZBwyJwQlVufFsq8+KOcezSpMaL4UcPlV9XEkpEEo5UcLoYmSMYnG+jCzJEl9xpLnw4GDyZdgcRuMyEpuovHwxDCUBPoE4LXKROcxGni9jqhnLt9d6+wBiDzQpaAFEC4ofZzmx5XU8K7sLYYFetMC/sGcEzYj1oKOhosbLZv2EmGhA+cKDh/dScW8yLqcZ72NWCjLwhIoNQnesVOTuy0cVeFhSPCiweBIi7PeTRIg5L0B/rJEUO4i6gOGkVv//fstZBeRUy3u1J4b+hGOwWoBgFl7q4fTh3CfriX79qFtz9lbf04ptsXS3XRNMDekazhFS36ym7ECr/lTyVnlD/SeeGplWBy7Y4MMp5t5WklaWVqWRtIc5WSfWfAm7CHsZkAg3tQZawqUjbxy3tRQNCkQ9FVn22GvwWAB/xKdDGqOjxiVbbnzQwXS5BD32HJ3iT5Bjqli6dECGruOhbY1eQJ2FI9Sg0etQgZ8z9nONO6VNMV7chR+yNOfMEDK00SXxVygAq5r4ijEynaM9xHhia6pnLmSflGRyCoQt6E6nomsL76LcZHsYG7W9oHnG/5Glffix6I16Zs52dYq9s4Ee00Ts2SGaWIVt
 9nL2BknV
 CqkL68a4xnvxMlZEhJO6aeZPHyMBIj3o8lDVYLyKudjYKlDxJyVMUEQv0s2Xk1oZelIvu0I0JNN9FrGOuJwjj5K44knwYY1hmn2N3Y1KHTYqWGUJgDtiEVGbNEWOKA45voX1ODjEUH9+F4y0W89YGOwFuQDRoB5Dq636j1MQy/8bhVd+1bDIUxmMo1xpJ2gt4e/cDTcIjMLaCyHfibR+wQe4kxSEKF55p33I/baWShFE2q16Xfj75OGfJpPQCiAe1/jJmwXzZAri0EmLyDvRM4CabgeNxM6wmWfzTZyXQ+35UqLkyUQnbV6pdyo2lfyLT0iDkPPLq/5CdLQop9+tpvPyD6CJBul6m+HJRNx3x7xVmNQ3oiM+7RXX4tTeoAPhXYS1QhtwyoBB4KOWXJD9NLs6E3Z91Hn6N4DpHf7JSU22QRAsjWa739TbZhkP0NPVFackV53sH5xpEhvOWvI1sT8ti0OMnQGfHKl0sw3I0654xFnohMeH1kmDcZ7Wcmi/1vmXiT+OSZGRSufRacP2zWWpugiMRueMPNAlN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>>>> Can we just disallow memmap= when running in a confidential VM?
>>> My experiments showed: memmap itself don't have a problem but memap
>>> with a hole is causing crash.
>>>
>>> There might be some usecases which are already using this, e.g:
>>>
>>> https://lore.kernel.org/all/20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org/
>>>
>>>
>> Its also good to have a general safeguard to not accept memory that is
>> not marked as RAM in e820?
>>
> Personally, I think all these command line hacks should be avoided in
> confidential VMs, on the basis that the firmware's view of memory should
> be in sync with the OS.
Fair enough. I can post a separate on top RFC patch to disable memmap= 
holes completely
for confidential guests and see if anybody objects.

That said, this patch fixes a real crash with memmap= holes 
functionality in confidential guests today,
and should be backported to stable kernels as well. It also hardens the 
existing code to only accept the
e820 RAM regions.

Thanks for having a look!

Pankaj


