Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82216C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 01:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807D56B0092; Tue, 14 Jul 2026 21:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B90F6B0093; Tue, 14 Jul 2026 21:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0296B0095; Tue, 14 Jul 2026 21:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3724C6B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:04:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA9841A01F8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:04:01 +0000 (UTC)
X-FDA: 84989214282.15.EC9E53A
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by imf11.hostedemail.com (Postfix) with ESMTP id DCC3B40003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:03:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="o9M/PqcL";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784077439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZmoHZEIsezsfpesXDQ6VXZhDNersnRzXsPqPst+6hQ=;
	b=O5ClAgWzDKtzaHpDtqKEmQbxdTuVAIELEEJ3p434ni+rdHkLvL3n/iv13ShxnnwO5H2Nhs
	W+frUNV9HCXnPbnP0313M/YR8siwZEKlMSRXWEDcPWuJTWCEzOlLnkNW5UJ1VoQEBPvNzu
	DrVEnFMiRlprSaPbw8b5DtDgMTrR1R8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="o9M/PqcL";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784077439;
	b=nRVtI1an2ZD48CmalJN4h7deTLr7vaLkgtUE3EwxmaXcomHJD3WCw/5dp5KbLXI/79OFht
	JbaRO1ioPEON5sP0Rvo5Z3sEqfcT9NEbNSbkxmY9NSX0iPzCy1T+ubklUVU+VapjcixxhM
	U9k91EcXm/oEgzE72PRhCaq+zsvEP3I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLDf+ni6QiOI4tXZidmhMKVzgs7AGof/R3iUA2vFAgrig3uIUp5nRCAZHb4UUeLVbyMThG5+5VZId9rZ6rn0aI51S3StFSpEvpcL2GumS69b05w1sLO9Ir7PhjypdbRilUhvhNXhhpBuiCR54B6kTPspUCO/k0izJvuqiViFq1o3pH0QQM9w4NJwZWeJYHT21DJHIKDkPRbxjq8Ipn91omkxIJ/+7QKavNR/7D/W38T5njHjs1XotStkZleY15sIBR8Mq7vJZM0M1xTDENP5nnPN7XcYuF+VYObu+i7hTD2gD/tsRahMhGMjzKRNDDgh0W+f8X1ym3B7S62cUhfDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZmoHZEIsezsfpesXDQ6VXZhDNersnRzXsPqPst+6hQ=;
 b=Mkb5fk+Utur8B8vYUwWzBgFhZ2pSsnjjMOf4PValZZvz1CEcTxAmUB6cW7YNcjfwXBd6QLFLdm73rr7DDr3N42+XNND3+f7Fy2zIF3pAKgt7qmb3JiAxb/mbPuPzguSOUrUobocTj9MrWtogI+EI9JJ6hhrtQNwA8hixHOPrJry9ofDsXaZhR6LAL024hnBNZztzvDoSlxMNFJTcWRhKobT19T3HVCBd4GxSdSywRSw8g6wfMAi+Uz/5dEw2M2aL+SEN821WpT2V1NYAz4bM3sMupmM8Rp1gW0SljcuBXcduwmql/MBvxdiDhGg5dDAXFmcgQD0XGNc4KCsMkbCAaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZmoHZEIsezsfpesXDQ6VXZhDNersnRzXsPqPst+6hQ=;
 b=o9M/PqcLvExmEma0zjAFXjn5O0yA18+mAPUWYPHOTC5XlFcwLOF9joohz4dGR7G1YvgP3eN2hKeshrvgpuINaNcBBe555/SaoWs6qOWDhMLl8xRRfQlLs3EFpbLEihluJJY9cgZihMkvW9CLvTrO5UdKKxR+NvqPnVn0kK9l/8qZeDdAKmArfjQ0gkZDM1NI8RvV4tj+A4BIZDv5lnWOA/iBUyQiAE230A3+fv8jXEuqeDk3EUx1nWn4mlC0oF0izjaZuTUL/prdP//+FrzOhkvrK+crG6r8V6wd6A3EeOMCwOjijSv36Ofmw7fjcO46F8Ai50n/ZlTIBjIs8BgHcg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8689.namprd12.prod.outlook.com (2603:10b6:a03:53d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Wed, 15 Jul
 2026 01:03:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 01:03:54 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 21:03:52 -0400
Message-Id: <DJYQO1Z2LJTA.2PN4PE5LGWTJD@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <zhongling0719@126.com>
To: "Hongling Zeng" <zenghongling@kylinos.cn>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <liam@infradead.org>, <npache@redhat.com>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2] mm: huge_memory: Fix kobject cleanup in
 thpsize_create error
X-Mailer: aerc 0.21.0
References: <20260713054154.120915-1-zenghongling@kylinos.cn>
In-Reply-To: <20260713054154.120915-1-zenghongling@kylinos.cn>
X-ClientProxiedBy: BN9PR03CA0300.namprd03.prod.outlook.com
 (2603:10b6:408:f5::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8689:EE_
X-MS-Office365-Filtering-Correlation-Id: 6235de20-cdbc-47c5-223e-08dee20cf0b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|18002099003|22082099003|921020|6133799003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	hAbrcx+qd7SVzNAdCTp86xE4PojFD67l9fhki8a4Gz4UQxQnlmUXT1PKqD+ut6vS949Y1w+GBLLIFp0OLtTyCY+s+0zK3D9OA61FwhU0KZtpWN+NuFvrC9EnOpoiWKNfejulJJbE3hnhm5wl+WULlNh9/alOnamkntAKQfvrK++AWch660sguJwr5PIrykVX06A8C2u4Wpfsu66GJVJ6jdfy2nX86FaVgXDih25T7bJRNbKaiGU+sbuE0hb5UlPelWCdOJjbAkcTdScb9YP+AxTdmHczP/wo6FXx5Efy7DsYGhPdMNacQxbQXRYO8O5z3ovFEzcep8zB2S1AiJk+uJKuPigM6XJnvKRkgE0sab3gTj54u0hM14jpkQJj26hSnchEMPcA99Tz2bHTxpT6Z2PAa6hrsMd82vJBaA/vJtoVJmjNm+zl9dLd3+nQFkXILWdYFccvVMeWgd4CseoGdenh2LY65nISM8FWsaA/eoTaONC4/bjNtTsSK+iz3xtQjutmTb5ia+Ewj2ie5XpkoYXBs2Wi1NAHczqALweX1PS/rM2+VU1CPXdsiS02A51B8AufeVp56lkAzd5mzA11lhEKqIi3wQKcb+NpNtA8q9Qzv72WsRqe3Zor2EIefbdZmIshxiH9MXNKRhiSj3S6tl24xfN82s4NSF3DFCq4RToe75Zrm8fxW9nYwSq2RBMSoRaqKFTb6q9eGx/O10A6Hg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(921020)(6133799003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXl2TW9zQ2s3MGh6NWRUZFZTVmg4dThJU2xkTTJNREVtZk1MdzRBZU9maUx0?=
 =?utf-8?B?M0xyRVlrSkloU2crdWRlMXRNM2JJaU1VbXBsMzQrVytMNllCb3B0QWM5ODJy?=
 =?utf-8?B?eGVZSnhqbVhTS0h0bFBXMzhJV1BrM2h3Z05USWZmWEtiTDluRURDRDVhWm9j?=
 =?utf-8?B?Q2ZyOHF3Wm53K2wwN2dKZTBjV2JHUlUzY0tmUDVMZE5XR2RzMzRPWXh2MEVZ?=
 =?utf-8?B?YitBQkEzc0NlTEFaRENwRnFMZmkyRklRYWxkS0VxbndaVW9CczRyVExBQjN5?=
 =?utf-8?B?aEZrN0xCU2c2T3ZwcHFPMjIvdXZYV1YxaTNxUlZadnd2cHpyTXh3MC9pbVFB?=
 =?utf-8?B?cTJjYmdnVDkzSGFEcHZnRUlvT2dmTVVSWXBHR1pxZ0VaN2NheldtMEE1OVAz?=
 =?utf-8?B?ZHF1Um9Td1hGRU5FQkpabmZyNEtGSUVqM3BXcGpaMm94UVIzK2xsbWNVcjV2?=
 =?utf-8?B?SjlFM2Z4UHljcnJtaE04TCtmMW13VTBlL0FTSUFqeVlqb1phWE5LSnJYM3Qv?=
 =?utf-8?B?dXRnZ3BQTVd3SEdBU3J0cXJaVkk0RDlZOXBKY2hHTGs1V0F6N2dITzFuUkxK?=
 =?utf-8?B?WlNGenBzYnVUblVua0Jxc3dnaTNlbXlmSGVSLzFkS3pCeityR0g5MVpUOHFH?=
 =?utf-8?B?R05qMkwyUTNJMjNPN21qWUZIOS9INnR3OTNEQmxueDJHM21mRE0zSGFIQ0p3?=
 =?utf-8?B?dnFxV0krL2FuUE1lYlZZUDdzK0M1d0NKcllGMy9PZXdMY0hETW1vOHBEOUdM?=
 =?utf-8?B?TGZPNnJkVUNrbm1qblNNbWdOMHRpUXRsbmpMbnlmRC91ZHM0RkpBWDU5MEk2?=
 =?utf-8?B?cnlDbHZSUXJpaDM0Q0hKOTdUckxzSWxJa0hKWFRPeERURkk4b0pUTkppdkVL?=
 =?utf-8?B?NGxLcklhQnNmbWNWZFBHYnVRU3dJMXhjR2tSMU51b0ZmMk5wOVd1S3BpVnp4?=
 =?utf-8?B?UzRTR0RFMjVDVXVHQlBRNDI1RDMwNUcrdk1KMk1rQ2c0cWkxZS8zTWJvZ1Zn?=
 =?utf-8?B?SEJiK3oxSXJMOVBUTHpLNUlncytTSlgxcG0rR2k4bnZZS0hONkI3WU5qeXFw?=
 =?utf-8?B?bVVXQXQ1akNZN0JndUhBNGdBV1hzSE81REFINmRuY1dlaWtrcUlpSHcyUUZ2?=
 =?utf-8?B?bXJzYmhMSEhrWEU5WWljTWpWS2QyWXBFNU9iQ2VjMlRFSW9xM0pGWkpacVRa?=
 =?utf-8?B?OFZYdlhrdFZaMEpZNU9tODRNY3I0eXNnZ1d2MHpiVHlOK1V6bDNpMWwzQnow?=
 =?utf-8?B?VCtsYXoyRVJpVkxpa2tybFJhSHJLUy91U09SeDRxc2FUdE5CVXpkdGtOVVpk?=
 =?utf-8?B?MGNlakU5YWQ3QWZtQmpndGZMTG15eGNsYWNoN2pVcm1UczdyeS93cTNWbFo3?=
 =?utf-8?B?TWZxZ2xnRmptaXJrVGlDQ1YydzJVc1o1QWV2L3pXODhOdHljV1ZlYk8xd1dQ?=
 =?utf-8?B?bkRMU1lsUzVadHZIOC9JYjFudzdGb0wrdlY4MlY1TXZ3TCs2dFF4Y0tNQXEr?=
 =?utf-8?B?WWJud1dCRmsyeG4veWpZSk9hbFJySkdPaWY1WEVyZnd2L3JoYzc1Q25LZDBi?=
 =?utf-8?B?L3VjVVdzbEk1bVI2UkhIVzFHUitCQ2hUT3NTanlpaVkxVDFMUzJtWVFOcnI3?=
 =?utf-8?B?SWR6dktFOUQzMVB1QUU4a1dobHJkd2xYUithRTNqVFNwbEpJSUxNM1E0a1ZV?=
 =?utf-8?B?cldKVVZIbHNFSysrcHB3S2FrSVhTSnc4KzBYT21HOXlya3lySXRES3FnOGdr?=
 =?utf-8?B?UlpDTVBmYVd3TUFXV0dVeXJodStnZXlMWkNyRFpCM3VGMmIrUG11WHFHcnBj?=
 =?utf-8?B?ZHlKNXJxU1FxN0llS2tQK25QREhOK0wxbjd0azI4TXh6cnV4YlJWMlh5ZTBV?=
 =?utf-8?B?dEU4NzJoMnhxZklMNFd2VEZGMzZxRzFFUXE1ZW4yZkJVVWN1VWc5bzRyTlhG?=
 =?utf-8?B?RER2ZGJkdE5VZFJJd2dpWXUya1NrVHgrbno4YlZ5cGJ2SWNUQkRPOTZVS28v?=
 =?utf-8?B?QlBOQmlLcnJCcEVwZGNXeTJUTy9tL1RQclQrOGF1TmxxdCtaVmtmWlpLN3B5?=
 =?utf-8?B?RkZoeXdLbEhVNEJNWTFpSFFlUkFvN2dkUkV3aVc3U0hCd2t3STZlYWR0VnNN?=
 =?utf-8?B?WlJoS2MvSVN1YVd2cnlpbTNBSk5pUlpxZHFkT0IwZWtSK3k2bDJTR3JiS1Bt?=
 =?utf-8?B?WDZMVjZibXlPenRpOTl5RzMwUVNiMkN6Qm9mNGViblh1bEJ1M2FuWVpJTGtZ?=
 =?utf-8?B?eTBsY1hMamNuZUVKampIa3E3L3JpcDVJUUU4ZFQzcHZtVTNMWTNtaFdjYk1M?=
 =?utf-8?Q?Go90Q2By8ycQbZUHka?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6235de20-cdbc-47c5-223e-08dee20cf0b2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 01:03:53.9744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HTWcZ0fUAO1zhuH6/BT9wxpWGf1XBpvjFkbTr4aWkPymYa9w1IHPDUXY6cnkNmS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8689
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCC3B40003
X-Stat-Signature: 1ge5sb34qy174qd3m8po7jryou1ifidw
X-HE-Tag: 1784077438-134609
X-HE-Meta: U2FsdGVkX18LYk5RxuYavE337ZpBP6rWAhkj8e3rhcrxuVoxoto6BfH2EaNf76ShWOQtj0xqVhe7ri41D9F4LpHsdUCM0YdRl0bYXqqbNo/aoXPkTjgWfs7IJ3PC3zsSClhOZKdVgCSOydusCPDH3BKYDy5A5JMbxTrMyCZxIXvdhr8aW/u+e5KalmlaVY08Sn9ZMDwY4ZJj7VwB/UtkZPYfX+A2JyhCf85ij+w62uBtRyPn4qa9PN1Rxz3YLjUWTaE5bVZvXyNX9U/2NJfl8AK58I5ZVKWenrHRHKjnIIhBsGcTf6699zfPSHi2m7XkYqJrzNOXgNybHYIQ3XFq7CXPWm3Jd+vnpQllm18RBTKwcaO0CLNQfSsCnPp7UysvJD730Okrj1EDQcY+Es6YOGVL/gYfPSMboTXLSTr79GaKan3fqJhYYHUhpwGyfXS/Piop5epXNb/Bt7fr671LwNxfjThyUrW/IAYUA4JAoL+oF/VoCqmB+FJFdzDMAVu56hm+PDhYW13zXhpJujcSIidEtY5TvuVt5x/fesTX/KHM60QK1EW3xAKYpvI2ceMvf8ZxTkUhGeNknpwDOpCbq29VEMYyyp8Uu85Cq5xpVbYLD7TI5x40DrezFialMyL4W8aj+nSzZ4L0HLhjqa8AXqk2eAzPw+tLzOwWbG3khMffLnOv3JQjR+Erf4jhap4Ag7lYRSBitfrV8zUe8szoyi9nNfauOYwe3CjjjmolQIHueoc8iQugXqiFz6q1GruZ0gM5Q0qTf74UFdSf0e59oV/LYXM4hd8hfDlSVELyNL6V1f9aZZ5EGqXuLKodywQwUgZk2CEXSMuTS+AXG7WWKSJCsmsfm7EZmZZo1e4OoUEtlUf5xUDNvSlm1G+EkgQSqEgOV581yKK6eQrf8q+cPtUelOHii+yUA74a0eUriBydfbQhCilt05F8tU4BLCKkQohMALmKtZMRrf0c6w8
 /hmk+lr4
 wD8TSZeOM87gHg6SbpvbEF6TaDfIH3b9UFhJnj5yhILARwjBMX0WW7BUYPg99qA/ntbwE4JgtgTSgtK9xxqiLfOm3YAHKXAHFvgw75/51WANlmJgG/IJBFvdvdQriiyGMp4NXJSl2Z8dz9pM8SsP/8iOxzT2eWEz3/4BriBb1X+JScEFKt/MOhGLpUerbEIIv0oqR26BjD641D7nkd3nCtYDGiF4pvlxkDmcH9w/okj5OcKwx1XEdebUH5O96HsWrZo7/acGK/AJ/6tqS2NEip+VbnAtAVrbZEIM4go+LZiRMFwpi+ax7Y23JeW8Cl4S5Qp7XYCCg0uTpDvPGcpVsoXOoowXWih0e7hacpHdONl/FehSpcHxMzQ4/toqgtx8oZ+uG7Xaf+i5bDZI1yjlII9ZADWy2Sl873umixE6W/sVCfQd1G1tznI7h/WlxuBJ9vi5LOn0MplgbsaLiCX1vvlDGSmByG5l3kfPxU3hyU+WaA8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 13, 2026 at 1:41 AM EDT, Hongling Zeng wrote:
> When kobject_init_and_add() fails, the kobject API requires calling
> kobject_put() to properly clean up the memory, not direct kfree().
>
> According to the kobject API documentation, kobject_init_and_add()
> calls kobject_init() internally. If the subsequent kobject_add()
> fails, the kobject has still been initialized and must be cleaned up
> via the reference count mechanism (kobject_put), not direct kfree().
>
> Direct kfree() leaves the kobject's internal state (including the
> reference count and kset membership) uncleaned, which can cause:
>  - Memory leaks of kobject internal structures
>  - Potential use-after-free if there are pending references
>  - Inconsistent state with the rest of the error handling code
>
> This fix matches the pattern used elsewhere in the kernel and in the
> same function (err_put label) which correctly uses kobject_put().
>
> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>
> ---
>  Change in v2:
>  - Use goto err_put instead of kobject_put() + goto err for consistency
>  - Add suggested
> ---
>  mm/huge_memory.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


