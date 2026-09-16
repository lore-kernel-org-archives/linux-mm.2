Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71DA9C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D416B0092; Wed, 16 Sep 2026 09:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7986B0093; Wed, 16 Sep 2026 09:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190496B0095; Wed, 16 Sep 2026 09:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1A6C6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:30:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61C361A0714
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:30:23 +0000 (UTC)
X-FDA: 85219709526.10.C9B5B64
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011054.outbound.protection.outlook.com [40.93.194.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2B12B180016
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:30:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WPrgFdfQ;
	spf=pass (imf16.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.194.54 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jo8S/l8JJzBQNMO/i75lVdt/pq9IEWuVKGTUb8oHPVc=;
	b=mz/mvHKpcm+qlayDkOKZjMrQGWObigEODztBtEdC7a51d5XuVQsMTwshAGTD7L5q8SqSLZ
	XJ5DIrySkilOzijTVczg9hLKZ1nyWxQphoW9RECysmaoWLHP3HvtuhkZWdyn/xZTkMIrOP
	1JCencV81+Gb33J83Dw9P/TwZSeds08=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789565420;
	b=DPekfqYkBE8M2DpUeMu4D8resx5oRAQn8t5Go4qBwuOs2QAgUn9bpD+30eYPMMVd0LE77I
	o1As8qd5pz+oQqx4/tCTKgw1wjIJA1TCFAJsRD7bxD36srmEXk+2TBgOUhSX+l6d/sF+IL
	N6Vl5jI8DP7oBHcfmFKAzO1o1YdLITE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WPrgFdfQ;
	spf=pass (imf16.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.194.54 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4usrxmHwtLMCHv9SnKXuFjgksBgbxjTivaLj7BnP+uYyff6Mn10qZmXL9SOL5maidwFmLTnd0oZ6cTU3prKx4d17JeWDUsEAJDH21yiVdgkDRgmXy4lLy2bhH9LRxdvDiOtMF0adZ+f/ARzzq0N7e2ZC6fn+Sdk1ontUV+3zvG9PlEB3CDMV4YQWDrvPFRLc5oR3B5OW+naWqthqFflO9MLgSY2wEfnu+gnp5AdQ461u2PI9xFbIwGGmwY0UgWZwarCvQ26tKq99NjaNSwe7Dko8tSJWZJsF69PUipP5MhbITnnaUPM8fY/buhVV17wpsfBuHARoTbSllum2c/GCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jo8S/l8JJzBQNMO/i75lVdt/pq9IEWuVKGTUb8oHPVc=;
 b=WAcmicr1kKsR8206TAKVWLU35rzA3IvtYB0oaE33x0lHa9DqaVxDVyvKetK1mQW6dcMPH23lZQ3kj5jTGLgFMmCLPPyZ1Em9M/tuzEUjY3vX3e4DrT9K2/1AubJJTsZ7WBialPx79pksWt8B6lIBYY9ZrzhzXR8f3Y9Oykf5dEaM9SlXhR2CeEc8Qr/XIV+uPhVa7BTcggR/NNiP6owFSQAr7yB16IeQyfS0c6foyR3bqP2HkVEIWGRlOdvXDXsjfwTyFYGbohnshYjLoIVYxoKObxlb1EyyQa/u5+RaR6gV7rj0Vx+brjIk+aa53gFwuagPw9dPMeqQFFINoAnJFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jo8S/l8JJzBQNMO/i75lVdt/pq9IEWuVKGTUb8oHPVc=;
 b=WPrgFdfQawn9/diq1ac8xFIlY2ZSLhHqlz/37PgkNOVq54g984oFXl6yUQ7NkXu7vMXCfmTNvpB2kxmaanc9gcW6h9ykmbYUdiynBBWGCRCQpVh1o99SU7jYZHayRXsbBq8Bj6/ac6wEU/pVSK3zmU7AjJEcLpNUpuhb9j6rhuk=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB8584.namprd12.prod.outlook.com (2603:10b6:610:164::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 13:30:12 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 13:30:11 +0000
Message-ID: <a51b4181-f102-4820-b5c1-af9cb3d9b77f@amd.com>
Date: Wed, 16 Sep 2026 15:30:07 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: DMA BUFFER SHARING FRAMEWORK: tighten F:
 matches
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260916-maint-dma-buf-v1-1-0f8d6c5bf1cd@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260916-maint-dma-buf-v1-1-0f8d6c5bf1cd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB8584:EE_
X-MS-Office365-Filtering-Correlation-Id: a06b9ff9-6f05-470e-6cb8-08df13f6a261
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|11063799006|10067099003|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PxIevyZJUKiDbfcoglak9mxEd8KNg8dLfuwQ6z+jmWLyZ3PJ/6VYMkouxmpq2CDB9x2pH4NdpURoicbZ6Z8J9xnsJUFoIcmZRYFVbpmZNRA/0J2AKEvUieBOt3a/l6ypj6Y0t5yTSZnY6Tovrjg7e6qWm3OGv9YeO67Z+aml+C7qc09V+SlJJw9vqQIc3lHqiNv4dLixbwFsf8fyF4rVk033QhsBmqQr6xMljzjIP6R4Vrte7SbAKbRJ4burfz6V49jsftCLw2QKKEQGzjWygzTMRHJydSuFMLbVQX6UVabbLhoZZfQqXJNvx/EECSCAiShoJIi1C2cGcL0pJSpE/6TlCxbwy+GgICisN/uCE1t7G3ABJJuamYLD7g0qhJpfi8oiNhJHE8NF+BXdxWe5oZPF38c9lq4RGdceG0RoeH8/DnyYTwLWHBNf5g6MZasCd1PDeA18L6qQsfDifDr+mfFcb4wpL99/Lt8Ty+50Isi/gly2/n0HVH++nDWGtLaNYfAewyis62kt6/CKUWdkTR87G2FTGqa/uFKWrr4gHrRbL88mzqZ1dGfIfNQXgioBiGi6RohyPZ8NcVzXD3qTy25vNcpc6l6L+BsaX9BHz8Rm5/vjzsP9fKeBLdNFwY73
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(11063799006)(10067099003)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2o1T3pUNkR2M1Z4eW1XODJRakdick1CclRqbU9INFlHam8zMDcvK3ZSNitn?=
 =?utf-8?B?MDZVbkNmMjRFSk5JR3VHNHpMb0pqRTlVWm5QZ3VQdkZRdndLeGNCRTFxUmRE?=
 =?utf-8?B?SDgzYzZPeGhlL1U4MTFmdFBUSVdxSGxJd1F0RVlZZnJibXBrYmJueGkzdE5O?=
 =?utf-8?B?UWQ5RHdSR2R4L2Jpa1hXbW0xSGRJR3BUcWJ3dmtsZDFXTnVFQlpnbWRDVDl5?=
 =?utf-8?B?RXRPY2w1VFZZTCtLR3BjcE5KeG81VDJ0cS9QbHJNcGV0NEpsSkdFOSs4WERz?=
 =?utf-8?B?c3phNVZ3M1IxV1FudVpyTk1EV0k4anJJQ0I5TG1GZ1paQXo0Z1RVUnhqODVq?=
 =?utf-8?B?SktqYUVkZ283QTlhNlNyWFJ5STBxSkdEUEFNMVBsUWYvZzl1a202eXBwelNV?=
 =?utf-8?B?ait0cmU5RURUS0Q0NzVjd01aazJ5OG9mVzB6bnM4Ny81U3IrU1hsZWNyQ0Jm?=
 =?utf-8?B?YXVqT0lwTDdIODFGNkxqT2FlSDhMZUZKN0RKSjQ5WUJaL1dSTndwQUdMRU5D?=
 =?utf-8?B?cHpKTXAyUDJ6OHZMOFptYmcxNkx5MVE5RzhjbDdFWFYxSHkxeG1PckhST3Jt?=
 =?utf-8?B?UHZSYWM2TUhLNTFCUVBEMmMxR3J0QVpsZXc1ZEJiNmZ2eitWb3F4Q2Q1U0tB?=
 =?utf-8?B?c3Ixb3FuR1h2WXU1MW1vMEtvSkcwUEp6Q2UzMXVzQ0NiSkRyMFBIU1hGellv?=
 =?utf-8?B?U1o1cG4yeVlPTEJRYU1icDRtTENPYlEwZDNCQ1JWN01ubXNiQVpnQXl0YzMw?=
 =?utf-8?B?cTZaeko2VU5wckNsL1l5VitMY253K0dvdFBoNnY4Wk96K0dUSmV1U3Y5WGcr?=
 =?utf-8?B?ay96WjE2bDhadGNkZ2FYOVBlUmhod2pKR2NEMUlsUjVlQkthV0VNdjNnNWpj?=
 =?utf-8?B?U052Sjh4Wmo3K0IyeEswREhLaHdDZEVDT0tQamJDUVJKR0l6aFpYNzgvM0dY?=
 =?utf-8?B?MzMySDJTL0Z0bGxwUmZFcDg5ZGh3bVNBQmtRYll2eWY2UHU2VzE1Szh6S2Fv?=
 =?utf-8?B?RUdubTJQUVNCN1RDTFFCOFVhNVVvbTViTjVZUGR5Nmxtd3FBdDhMbzMvbDl1?=
 =?utf-8?B?REEzRlZBNWE1UUcyWmQ4UXRjQW1Cc0hSK2V5RnYvbENRUXEwR2NvR2hMdktp?=
 =?utf-8?B?ZFJEYklxMGl4cVBjZTNVUGN2WFcyREZSbUc2Nk5BYy9IK1FFZFRhQW1raDdR?=
 =?utf-8?B?b05keU5oaWdPUUFKRFMzQmlNc0lYMEhMWjk0aHh0NVVidGhDV2p3QVNFcnRG?=
 =?utf-8?B?S2NkS2FmQ0JtOTBJOTdpM0ZTY1Q1V2RqU2JEVDVRZTluaGRHU2NZUXhkc0hK?=
 =?utf-8?B?UURxMnV5T0RnZDc1ZjNhL1lnVEtBWjNCdDg5TlArbjhxTEx1K0JDa2FQSzVU?=
 =?utf-8?B?QnE2K0RoSHVlek1OYXlIYU9jQ0dycVgwa01aTzQvUGZtS2g3N0dtY0VUS2lL?=
 =?utf-8?B?Y1Awbk5IU1FXQnpRYk1XUWlLUWVaSGNWcjBOMFJDRFRzbm91V01PMXBrZDBa?=
 =?utf-8?B?UGhueE8zRFhuZGpNTVhQTXVpQ2hqWUFkNDBlamFld09IaGdjeWU0bytaZTFt?=
 =?utf-8?B?UFRydTUrSkpIT3ROOG1MS0hvUi9RZjdLdGlJaWIyU0VFOUxYTEIyZEs3VUVN?=
 =?utf-8?B?S3lYdVhvM2prOVhUNitTME9BZ1pjODFiREdJbEZYR2JGRzg4V2xuelIrNWt1?=
 =?utf-8?B?YStjMWxscXZDYW5RaVNDemxaZi8vOXJyL3pBL242ejBnUzJLWEQ4TXlMQS9H?=
 =?utf-8?B?MVh6NzUrK1A1TWxqd0h5VmxWY0VzWnZsZzV0N2FtWkRrSW5PRDNrZEU1RkhK?=
 =?utf-8?B?U0pjWThZKzBMcEs5QnM4R1N4aEE2NjJKVFprTUh5OFNmRm5uK0JvcGRQNzdW?=
 =?utf-8?B?bFNTTEhwNWJWbzE4Sk0wSkY2bFhYT3VMeENFbGt4MFI5dTNoeTZDWXoyRTBR?=
 =?utf-8?B?RXRaZGMxcFl5Q0NEOFltZ3ZUMTRNRlpoSE92TGRBdjFmSFhyLzFXNDhhYUtD?=
 =?utf-8?B?elpYbHJFSWlPeWFGMEJ5azRWdDY5aUZhV01FQ1dQcnM0emNmMk1KVEdvUFVh?=
 =?utf-8?B?TjhOQ1crdXRZRXh6K2d1cktSbDd6cHc5SkdsSGREODBqVzg5OUcrMndZdUt0?=
 =?utf-8?B?ckNxcURHMFF2azdieFRPaG5NU1hKOEtSNzR4b3c3Uzg3U3JxU3Zyc1UvSFVC?=
 =?utf-8?B?TzM5YUxUOGlaNys4LzdpN1BOSlVJRGd1NEZ6NSt3WWZ0ME1RMW1uZG5kbWxi?=
 =?utf-8?B?dWxYT3BGZWVIOTRYeU96ekNMby92MW5EOGk0ZGpsNVlJRW51dDVaSXFWWHc5?=
 =?utf-8?Q?7daODAhcHdXO7zuMY2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06b9ff9-6f05-470e-6cb8-08df13f6a261
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 13:30:11.8979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /WT+pO/mzRrxugBiT0ysnI7MVivprNeg8U63WgG1CNn8XwRuTAb+p9WWMfklsxr5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8584
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B12B180016
X-Stat-Signature: c865jja17gu6e93ne7ts5zwkp1yqou13
X-Rspam-User: 
X-HE-Tag: 1789565419-134858
X-HE-Meta: U2FsdGVkX1+Isn7nB0S/KkfzX2xnn+CN7t0qtBDuizE5tbotULg7SYU9Tuih/IPfXwCtWd0nUugAe1e4wjB1TYbOGVwNS7ibMEgbBimgiVhkFXuA2zsHJSou6H3m1XwRuuSHAIfV/1NsDvB0fPJ1t7/S1hJKEFsCgu3fTzr3KtOyvLNQUzGAqIn7xXRbZBMd1kMB8PMBNv84Uxf7NiEn9PfO/2+NrgHF+qkazYcDNogLU/BGOLb1OJ9garptqGE5FDdsEfpV7UQ9ZscKGWVA3gzWbksvi9wkcjDrcxKpqJoBtIi8qUR0PNp03z5MrgscglMBPC68sG2MpEa22L9nGJZGc3725ZJ2L9lmw/ne5BNbd4xs+65Hk/VKsqmsppZ5F8RKD53Lf9oSr3ZlVM2eM2+x1M8KnkNB8JBakqk6ynWTtkCK1chflf4uKsBM2/NFOloTaYJX7csd87/KKMCM1N5rMxregMQela5Z887C1FhkTIkJFNjlNO/qmwKgTSbpBPFCdwX2xLQWPXfIYm8ONyCFztVd7LMDptGueSHq7x9wAi+0Q34IMjUb6WAjP/76x3GB5GjlHh5QKFbUm7jPR5ipU5fLV69RjTTNYEv3/4lU0a2niLWNhFT0VWGRlTZuqNXd7iOIqC++jq5QlyoCGW3U0/W1rKd2tttXDOfj4CGPNQptBy+vgNaGqh0A4QVq/xep/dDHWFU1ouVs2IjbcH49etswPc3ri+po0Fz3Z1T40Tb+NzQ9CEcgabJUGiFkItUVYdv6CJ2xEDUgAmLmRc5ovfhYr7T0yODaNK0/bLyjoWydL8SpjdHVNUR04Vo1brPNbOlJp4CaZckthQh/P/lTu0hRklWQODRAEx0nONc2hjp4QZCwobLwvQfjfS/Yj9/rKunmAWTMTmEm1Us5LkPKzn2zV5RNB505s6+F6pNB3z0EAkfJYYKhv0feqLM9hZDstPDdCzQG7yCQa/v
 7ipVi+FO
 zhRBvybxTDPtFYL5QBGCjjugHm+V9x4kszCCl0DOJdMy6utffdqcWy46vEti8OUnnitGQ/0p37wuP4yCy6f6dCSLNjo3cyy7MC5oNdYdMJaFu0WVOPo8j2trUu0QQFd0EoS4feRSn3jupqXcVkjWhLqLz6IRir9xw13axc8Q3Xr3m6SqwugMo7FFmBG4KojxeYyPPlcGZOmHnfsZWqX4MkupxtgynkcZyOB+Z0NoFg8zDx6XtHi3inQhs8mRhk+SxhL7S1gcSZUly/bdLMYdn285b21agHWremmc0eAPecpwojnH+nm6jSvLdGQZBWTmOYt7bKrQwF86ncd3v5VZk2z4y1Pmm34/7OPxHWHRNXcTSi32rdr5qLPaGlO6AHOpOQXQpz+FGJPL/66Mnsfrh2qF0PFrIDp/2gyz+gyC1w/Z2k8cJknlZoFOCebrAq+QMr7MlKkQS9aJRUbHDWAyjUOKncsQ3jOqP5XXkXNPHINNvgvnK8xh+JXTcb+Uegb2DKBNAVEZoHNqqZO7ljIyUvYWR2YL3q0ZNK/Cz1fmvcf+wX8y9fWUMto+c4wkpr5PLgfCDstkT/0jcT9mB78aBqyXwpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 15:21, Mike Rapoport (Microsoft) wrote:
> F:	include/linux/*fence.h
> 
> in "DMA BUFFER SHARING FRAMEWORK" entry matches include/linux/kfence.h
> although that header has nothing to do with dma-buf.
> 
> Replace it with explicit 'include/linux/dma-fence.h'.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Christian König <christian.koenig@amd.com>

Thanks a lot that was on my TODO list for an eternity as well!

Regards,
Christian

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c2414447892c2..656bc5ed8d2ba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7688,7 +7688,7 @@ T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
>  F:	Documentation/driver-api/dma-buf.rst
>  F:	Documentation/userspace-api/dma-buf-alloc-exchange.rst
>  F:	drivers/dma-buf/
> -F:	include/linux/*fence.h
> +F:	include/linux/dma-fence.h
>  F:	include/linux/dma-buf.h
>  F:	include/linux/dma-buf/
>  F:	include/linux/dma-resv.h
> 
> ---
> base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
> change-id: 20260916-maint-dma-buf-3311abfdc90e
> 
> --
> Sincerely yours,
> Mike.
> 


