Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1731CCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 11:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A798E007D; Fri, 24 Oct 2025 07:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523698E0042; Fri, 24 Oct 2025 07:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EAF78E007D; Fri, 24 Oct 2025 07:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26C388E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:43:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF2CA160E4B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:43:19 +0000 (UTC)
X-FDA: 84032822118.12.9CFC83C
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010064.outbound.protection.outlook.com [52.101.46.64])
	by imf27.hostedemail.com (Postfix) with ESMTP id DBEE440004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:43:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="sP/Gnkqk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.64 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761306197; a=rsa-sha256;
	cv=pass;
	b=sneqJaVTkpQAibV/ja0fBDCTALofxXBApTorkyxid+GqUf2votzy3F8t9ml0KX7Ge+695v
	yZeUmlJw71rmpkdCkiggziVFVV5tiOwj+aYx6pjRuuXOsGPswsKTTZe4Y8PKpoTTNw6WTQ
	WyIOJWdwgmLxiFkhi8qlJqR2390dBXA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="sP/Gnkqk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.64 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761306197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u48orTITZfPUgsw38yR1xW4rVDc1A8h0UF4HsL2Xass=;
	b=W3q05kn1fn4SPDzJgAvQIVsuChLBlyaTKDr3EKZPW/zTu/DK1OuGUZgegSHdPUaaR/C75U
	08r+wWW3oMM5Oj0uTNhi3KQDggkdMV7VyHKt2/AttN4P/VhUTHBFOmwiXNzQLhclwBFcts
	ybfdMIm8M/yOVHWWnbxyZ5uFfpu5+h4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qVFlew6Wq0AKtKX1DmKvNJ8Az74uSxWYRTzFz+CiSDZt1JoQXXFEOhZ5bY0D5WslgklC5mIiLlmFyD5acJ4aaN2Upgud3kUW+LvHVdtPmKDk88qfe01fLSVuOqBYRSsRP4FHiVVajVrio+NT8YEHu4Juo4R4vS0UJsbFt+B+cwk8gtlX0hYJnIlrvshWpl+hGDt7Y/4cIujlM/Ix1XmUPXb1qPcH31N3By86MH2fMYEO61+aAxoeQrCs08i9u8o1yk+8mlqvZ5tpIcENF9ZVM+NhxwVZVa5+P5WJLDnmYLy00V9PJgOJCzzFJBkiDA3xWkiIwRP/38a0TrWcTVXBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u48orTITZfPUgsw38yR1xW4rVDc1A8h0UF4HsL2Xass=;
 b=HEkc5iD2LXGZX9VBJlP8dRF0fzUM/HH5UzEUD6GZlN0+tmffzRkNmB3ffPw7rIXe+egBsa0qPSP58prb9a9rvcSq5FyTXMZqUhkISgorpmO3ompc6kLTXO5k8vs54CO8gfBtBT6B7d38Hgv3xH9Nn79+4H3sjgHCvfnCS63iHb6ixGtKZ6faFmleVHLyTT4tZbaNI0qiSqVX3JZvZK7+zUCyyUpwyoJnJg4COJR0F7FyJ1eS+21YiLX3n1CHTKROzFR45XG18Ztv6akskvbYeZrp//V3J2evM/XPgXRV5UJ5pP6URDSvA6IgV6wo5eV2uaxJdec86pz/gWfAf0yL/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u48orTITZfPUgsw38yR1xW4rVDc1A8h0UF4HsL2Xass=;
 b=sP/Gnkqkxo6Z0mCyGAp7oY6WoYVPNbUz3Ig/U23apaaoI/FLs0SYhzV96IVQc8NS9NlAtsaQZLNeS1W2VUQhTTVa8ggKy9GWifzCHxrrYRkopBNAv3cwFCTZfmrZizgKjUnHEkKpsAbCN2mvCJuhT+DXryJqRjZkwO3WVXdLU/JmzLavHS5lfwvAOjGPoY4tiFKcqEfOT6FUeKar0nI+MRmytOrzPkYHT4VhfnOqlkwj2Imn5aFO5FQzMBEPAxZo5RgKnAiBFa2minsDsdsw+GFZ9WJq7B0WX2X0it7NkoHF48RkJMCAYgctSpmzgBKQ28fND4E5+w5ysho3NfMzAg==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by CH2PR12MB4216.namprd12.prod.outlook.com (2603:10b6:610:a8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 11:43:13 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:43:13 +0000
Date: Fri, 24 Oct 2025 08:43:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] kho: Adopt KHO radix tree data structures
Message-ID: <20251024114311.GB847003@nvidia.com>
References: <20251020100306.2709352-1-jasonmiu@google.com>
 <20251020100306.2709352-2-jasonmiu@google.com>
 <20251023234532.GA846943@nvidia.com>
 <CA+CK2bCR0r61cnVxff6XSPoVN+ZxxS8rLHy0Mp6922xypCP8jA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCR0r61cnVxff6XSPoVN+ZxxS8rLHy0Mp6922xypCP8jA@mail.gmail.com>
X-ClientProxiedBy: SN7P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::9) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|CH2PR12MB4216:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d91846-96b3-4bb8-0b07-08de12f2836f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTA5TGlXbGxmdGJSenZGS3RoSnhIUmNZMmlhb0VjcGFkNXByUXNUL2I2WXBi?=
 =?utf-8?B?K3d5SHpyazRXbHY5Z1o4K25IZ2ZRNm9xcysweDN0UE1JQkNwc1Y2UjZjVllv?=
 =?utf-8?B?UmFmNWpuUmY3QTJvVFFjRHppU0YzdVQrbklrcVVtay8yYUZLYmpJc2NmbmI1?=
 =?utf-8?B?MjZLWGJtaFBpOTg2cEdkYVVxaVBNSmt0VzkrMDVZNy9kMzNnbFlOVW83ZTlv?=
 =?utf-8?B?R3RqZkcwRm1oNjIxN0N4cW4vUWZuM3U1aEhrbFNVNnVhVVJlaXRLOUlSUkFy?=
 =?utf-8?B?RSt6TnhrbFJMbzkyY2xYQjNtYk1xVW96QjhMM0tJNjh5Y3BQNUQyYWxpbW4y?=
 =?utf-8?B?K0VxQk40VkMxdlF6NEd3b2hyRW1FUzgzTUN1ZFRtQnBYRjlaYk92b2tjdDQ4?=
 =?utf-8?B?VVNiVkJiY2tjNDlBcVRudzAxVmhncHVEQnBZNXlDa1lkTVF0QTdhWjFxVzdK?=
 =?utf-8?B?Vi9ueDFXeGdGOWhYOEphcGx2SmN2bFMzRE15Rm8xeDBhbDh6TTB4WjEvNUhu?=
 =?utf-8?B?V2oyREI1OVBiQVdzUDlnNHdBQmtzZmhQeCtKT0d3T3NlWTRpNkVBbHdhWWpQ?=
 =?utf-8?B?T2EzYTF3SVUzN3M4bGpiY2Vrc3lDL2Q4YzVOSjRERm5XeTl3ZnZSTUlJVmdu?=
 =?utf-8?B?Q2gyL0dCSHM3L1IrK3FXRGVsU1BwTFdBTkMwODNkbENjYk1waUd6WCsrOUNP?=
 =?utf-8?B?cmlNZDdsTjRDNlk4eG5QNzNhT0JwWnI2NHdUZmF4YjJBbmpOUk1JREZxdTkv?=
 =?utf-8?B?YnZHMStHVVNlMEFaVCt1SjdOOVJIRW9kSElRbzlKVUZWQytBbmx3RlNlK1Vi?=
 =?utf-8?B?ZklmNkFXSWNVSXpINXczMkJYN1RjbFhoaDNJZWtpREpTU1ZpNXFTQ2FKVlpr?=
 =?utf-8?B?aHlacEZINTZ2RmJCaWhSSDBBY0p3WmJOUnBDMUlOdU15TG0ybmNaMkFrdzR6?=
 =?utf-8?B?WjRxbklVeTBKRkYwZHFsNURMdVVyZDBlL2xZWW9hYVY1T01mSGhmTVFYbjBo?=
 =?utf-8?B?eHBSeUQ5elVxZTVsYzJkYStGeGlaV3J5T0x1MFJVRzQwMDZuMWxGKzRpdzhr?=
 =?utf-8?B?UWhDcXpqbkVFSnd5NG9DaUpIYjJlSWdTK1ZTUG5hbG94S25HMDJFR3F1cmMy?=
 =?utf-8?B?RE1VR0lpcml0Ky9tK2p3MUhCMXBFZU9sQm1aM3o4dGdkclo4M1B1L1pkVGlh?=
 =?utf-8?B?QmxvRzJhK21TV3hGVkRyWnRRcEFHQm9HNTBiRDRZQ09uWXNpOFZacDQ0YUMy?=
 =?utf-8?B?c3RUVGNYS09VRXhWWllDNmM2SmRySEN4bEo3SU9USU9PbllZbjUxRDRyc3JX?=
 =?utf-8?B?NDB4VnNlUW4yOGF3TDRFbUNkRUcyN05zN2pCQ0o1VHFBKzdkcm1RMWlhemhL?=
 =?utf-8?B?bGtUb204ME1sMjZuRWtEUyt6dXdiMitTcld6UHhWOHpjTlRwTnZXaEhSelNM?=
 =?utf-8?B?ZEhyNE1ISllEUWpoQWNiaWZZSFlDeEJ0bncwMHhmK1VVSGdxL0dFcWllUkNl?=
 =?utf-8?B?NkxmOHYxNnQ4TVQzVXRUYWR0aVIveEgrcG4ybkdjUXZUU3ZwN3VuMXh1QS9T?=
 =?utf-8?B?UEFzbTFnaXd1NHRSeWQxL1dSWjlqeHhtY25GS3g2ZmczRXU5V2E2NTcrcUlx?=
 =?utf-8?B?YlVqYmVWenRVNDM0bjkyeG44VTZPcmtoRHBpZlBuUUFjQmdkYXkrVTd2aTFw?=
 =?utf-8?B?ZjdhSmFMVmVUbFpBQm9aWnBaSUg0WURoaHVJLy9aK0kzV29hbEMzcjFGalFr?=
 =?utf-8?B?QmxMeHZIMWJldW1sd2ZscGJTTlJDQklua3hYWVUyZTVYby82cXYzSlBaNnJp?=
 =?utf-8?B?T0VRa3piNjdmK1ZGUHZ5akxjd0F4RmJBallRSnViaW9HbUtpbitHY1ZhaVBG?=
 =?utf-8?B?b24wUkxIai9DTGt4WVJ2NXVyL0dTZDVuWFBLVnJiUFh2NmxtbUY1YTJDL21I?=
 =?utf-8?B?LzlvSFRUUXcwbkN4VXQ4VitreC82dU8wbUZXZ1dCRllUQ0xPN2JMVGxvM0lq?=
 =?utf-8?B?WjJDNnFiT0NnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wk5DQjVjdFRTUU5aOStUcExWcEhISUVnaHpNdE83anFHRnREQlcyc1pqVmtR?=
 =?utf-8?B?UzBzaGJudno3QlplRHBkbzlTSG5QRDRma3lDM2VCWjZHVUp0QU05M1ZYcGR1?=
 =?utf-8?B?MGdrelNWRzBuenpoSmFrV2drcldZaS9oK2s1MTBqM29IYXFraGt1bUxGR1NS?=
 =?utf-8?B?alhMUjl2VUo5bDhlcElJelpZQWRuSGhvcGxXc3lUM1dKQkk3bUdIR3Era1Ez?=
 =?utf-8?B?YktSbVZQVURLcHAzNGhaaXgvNW9lU1psQmY3WUNYZlQybnE0M2cyK3g3QUpi?=
 =?utf-8?B?ME82R0tsNVRhQ3pDNkdUZEZuQWlVR3F2RGZiblNrZ21uVlBpN1NqbWN3aW10?=
 =?utf-8?B?cnM1b0xCdURlQ2dlaWFONVBIcTJzY3VIem95TS82V2h1V2k1S0RvVVYzV05L?=
 =?utf-8?B?M1FWSkY2SGM3MUxQOHNuMEc0WUM5RGNMdGl0NGhTYjF3N1VSWVU4UHhSWUd6?=
 =?utf-8?B?QTJEUnZPOXY5UUpQU2xNbDdVQVU4UmcxUHFqNDNJYnJyTTI0N0ZoN1JuMVV0?=
 =?utf-8?B?WXNwMFFRVzJRS0dLUkhqVXo1dnhpWTVHOGh1SUg0VXdTTTR1Ti9XS0sxbnFz?=
 =?utf-8?B?WlRiL0xFRy9rcm5KTnBqYTc4N3JKOHdzWmRCZEN5empKamRqT3RjUEFDZnB5?=
 =?utf-8?B?VHBRN1Z1aVE5S3d6OTZRRnptOUNzS3ljKy9XSXduUHlTeE1NbEhMVnp1bGt1?=
 =?utf-8?B?U0UwUEI3VzdHQ1BLeWVDK3JIUVlTdmZSTGZxeHJ2TVBZQXB5azZDZzRwd09x?=
 =?utf-8?B?M0NxMmpYMXorSlZwVStSU1YxVDBaUG0wNmIvS2NzNXRLZUFiWjNTTEVRK2JC?=
 =?utf-8?B?NTcxbmh4K2RQeG9KMEpKTlhaY1VRdHIyT3l1MG5VMFYrNzlXaGYwWmhhNiti?=
 =?utf-8?B?ZTd2VjcyMFRoZVJUWmxYbzVEa0wyV2U0cFVzbVVYYTk3ZjU3QmorNFZGamRX?=
 =?utf-8?B?SGlyRlpUN2tDNXJ5enQ5TGp6c2VoSksrZHo5Zi9NTXZGYVc5WDhZcmtuM05z?=
 =?utf-8?B?UWhGN1lXaVEwa1phSjJsTnFZL2RJSSt2UHE4c0M5azBTeEs2bVVvcGhiQUtt?=
 =?utf-8?B?cTVlT25KRzFZSUtaWjlkMzlDZGhqVnJOWkVaaVlwOTlrdXpqa2hMa2QwRXd5?=
 =?utf-8?B?WXg3azVSNTB4QkRHWTYvVVhoRHI5K21keXord0dJMWE3TnMzWXM2dkVlVDNT?=
 =?utf-8?B?NkpBRjRwWWFseHlOSktDSGI4NmdROWVIajVxcFFXMXFPYmxGWk1vbTNYS052?=
 =?utf-8?B?MktxVVVGQTFZanYrMy9OazQwVVpGbUhTcGxSU0NVeFpjb3l6WWozeFFtaUxE?=
 =?utf-8?B?MlJvc2RRRUlmYjloMXBRT0Y4NVhaeHVhOTAxbkZaclRWalZZVTFyYmJLMEtn?=
 =?utf-8?B?cWY5LzY5Rmx5QkFyVnBwSCtqUzUvNUlOK1hjVnBORjkzSWs5U0xYaEM5TlNB?=
 =?utf-8?B?VTYzSlNORDhrV3RCWmN4UlBpM1NSWDBjTXNjb203c2k5U0ZqN2ZPSDJvMFR5?=
 =?utf-8?B?V1NjVUZQV3ppaUtCaUxjV1JidEtaekJkbHpvbGhhNG84dTIrZFdCQ3FWbzZG?=
 =?utf-8?B?WXZHcHRYV0FnVzY1N1dQbHltWFlUbFZjTmdFK09Ya1Z2SUMvVDFnWktxL05P?=
 =?utf-8?B?WlBPejIvWkl1RXZzT0lLVUp4M09LcmV2NmpVTVV6cWZhTjEvdUR4UWY1aVdG?=
 =?utf-8?B?emI1RjdJYXNPMXEwbldQMHZ6NjlDNkVBOUJCSHdDNlhNSy9GVEg1VDRUV3I3?=
 =?utf-8?B?RUhOczNnQUtRQWNkY042WU56NGVXMGlwYXFVVFdKNENVcnJKSWxIellyZU8r?=
 =?utf-8?B?RXZySWYrVkpGRkM0cExTS2NYSWx2V3V1L3VoWEo2QlBzb3FGQ2g0NGxHYzBs?=
 =?utf-8?B?U09uOWVFS1JVd1dtaTQ2UlpuT3dXZDk1R3FpTnoxSTlUZ2NCK2lORDFNZ09D?=
 =?utf-8?B?M2ZKRkJ4QTc5N1YzQXo2NDlSVmhRZ09lUDBmNjdRbklPdXQ3N1NjNlVBSVls?=
 =?utf-8?B?eUJLVDFPWlZqajNVNE85dVFkTjQ1aGhENGZqUDRmS1E0Z1dCdDhuUnRvTWxw?=
 =?utf-8?B?RUIrSnREcDNoY1RObWoxdmJwdmhqSkhWZWdwd01Rc2F6UENXamd0QlhMa252?=
 =?utf-8?Q?i8JtVXq3ks+8O2wSU2cPZUd+G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d91846-96b3-4bb8-0b07-08de12f2836f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 11:43:13.1467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOGW+Vrkdz24AqdtcAapa/iXNStqOx1MwZYgvU6U6xO6awz3n5Rx4pyZdhOgiGu3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4216
X-Rspam-User: 
X-Stat-Signature: hin6b93cttpfgn7jd6wgjapk5qbei6nk
X-Rspamd-Queue-Id: DBEE440004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761306196-738586
X-HE-Meta: U2FsdGVkX19jWrRqlUlh9zqbIUGGHvbZJM2JVqf8a9dL7fTmC6DVzvSGulS14O2Ok+SVQk45Od/DOpsLFH5XK4aQWei+FGzbeBPxPLvQEZkAblI8kAa6zZfNN/x2ShI3uFWGB2RWib3V0X7kQiUtBTxMbk76op7M2FJYPcOccircRBzfwt17wc+ihSKXVv2up+mpxB4OlryEzs4vmz+Xpq3kM4hgN+eGn+03CDf6TVTIkSKyhq8ApqkcxqpM1dkNvnC/FDai4sz2hOF90bVgcvdSp8Jfko1dMx9gqaxl3M/nFRuSxJzRk9VZD2uDljhc2zHZeROcXPW7V13oJfyk4ROAIkyvfyfOHMN62SRFsAYySO0/PthoptucSK2I7Tm5EODDciyeXDZm/m8fiAfoOLqJh2X52gNYuitaF0mbEx3i3Cw8tYZGqS+mybXpHkYB1jaP0YtfAykQef/aYf1TNHJVsD/FvzGNqZAcubjI0rgRjya64Pj4z7wvb8HJXGJAD0ZV8nU6pD68ln0r/2HhLE2SJH9E1Hm10KOs4JwhMBHGTsGOHrJQObcz6VC1AiE18MOEIIkJzxtVpuYBNzoAuTOmtijMP87Adq9Ai/4f0fgTsCkvxNwQWUOLTsURuImJ/MMQak5S9RFp18SlfD6VmSBEuf2Kl0EQwMgAISR/HRDAy4xkJU4vdmkNuFCkZVJwHsqcONdam+iRayAO9GH8FUSHs+4s4B5eG4V1r5m/2EJjz8v+SM47wPlWtNXoViQ77Xkq/z3ItzhIhO/MWI5LBP7y5h+GFUHeZbLBqrFadZ6ZkDj8aSD0JWfgt34VBsppWMTgbdmFMajG5zX7yyWxvKeZ/vb786ml8p4jarkS4CArHyjeeufkfnSYMy6LMhnUjooS24o3vdBmXiqtqMCv2rbuDssEfEM5tw8okSzdcMO8oo8YSaBK9SgN4HYCVQSW9eD7nM81/2mZ7V12yZS
 uR2QcFYg
 9aqqI1f0wYYk84+xfBLgO+vY/q+ofRvj1rEsD7T+UGbFMNORLRvVlAkUSzhaD1yl4/N5LKlwfhUXdY8h4jUm0xJIfWxUq8Sgl/PD0R7mY2Cf8jifP0euhxYngre5Or6tC/vrm6dysP1754SOXvxdDAyeigOjSoncqTzZv1ARzf+jWCGIIqWGwBW1qf8VLa/ZG5WaWgEDqMkcvtC1WNXUA4iNFIH2IRoyIYsAck5PkVOHvke8KJMdDeydbwUihP3i1hpt8pSYHPoAVUVRxULrTw4CTB1CoBSMTtbDY1rdKy99o3OVNBo4gjnHqnR/h+69V4PaN4NLWE+bfiu7psHXA+uV4qMd8EGK1io8hI9XKLA0NDdRPZuq5wRm/vysdQXXbNYycNAPBYVANxCwUFcS65j9pCva12myXjExihzjSXk1IbMB3Fz+QVm2UWUT+O2BgNO9HqjK/0MnSeC7Sv+xPsSP9EKV3p4Shd2HIjXYX2rRzsUHmAd5qdSQzM8GW/p4g9H69rAleQR+5x1iecRH1DAg2Jx5+25nYIdkv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 09:23:30PM -0400, Pasha Tatashin wrote:
> On Thu, Oct 23, 2025 at 7:45 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Mon, Oct 20, 2025 at 03:03:04AM -0700, Jason Miu wrote:
> >
> > > +static struct kho_radix_tree *kho_alloc_radix_tree(void)
> > >  {
> > > +     return (struct kho_radix_tree *)get_zeroed_page(GFP_KERNEL);
> > > +}
> >
> > I was reading the thread over here:
> >
> > https://lore.kernel.org/all/20151222210435.GB20997@ZenIV.linux.org.uk/
> >
> > And I guess this stuff should just use
> >   kzalloc(sizeof(struct kho_radix_tree), GFP_KERNEL);
> 
> kzalloc() uses slab, which in turn may use kfence objects, and kfence
> can allocate memory from KHO scratch area, leading to memory
> corruptions. Let's not use slab allocator for KHO preserved and
> metadata memory, it is not a good choice.

That sounds like a nasty subtle problem to have :(

Really should provide a kho allocator API to document these needs!

Jason

