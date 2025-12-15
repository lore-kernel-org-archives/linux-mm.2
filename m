Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED27D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 10:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53BF6B0006; Mon, 15 Dec 2025 05:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04DC6B0007; Mon, 15 Dec 2025 05:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E426B0008; Mon, 15 Dec 2025 05:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB88E6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:16:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 262BA160EF7
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:16:55 +0000 (UTC)
X-FDA: 84221301990.12.074BA73
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id A543AA000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:16:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oNHGZz/M";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EMNh7+Na;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765793811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpkJv3S5nE/VAveCfCz1viALn4psq7VQSujQP/Dph5Y=;
	b=YSPBOJZ/KRLq4tQZU2RgFs5XmsrylFM8l+3ehjNrrc/9cDqNGWRpSx3o0egRJNmzNvlTxJ
	0HIzFOHmpmolo4DQ9x0/BKSFPjVKI4G+cn1226MGR2xd3PMhO5yPndp6Vp2cM79A33JRXX
	DhM3nZ/eujz1nYKlEEoshJU1EdoO0RA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oNHGZz/M";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EMNh7+Na;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765793811; a=rsa-sha256;
	cv=pass;
	b=yVtSgSBT03p1WtCIxJSmBsCd85bJ8UTOVrv4ui16oWAirloVNDJGBIdYhlqBLr/GH9NYWM
	uXCkr+k9+0bL8apJGeon4W72uOT6gljIhtFBrA/MaEV701qrugvBHv//SMMFyFP/jsL7rg
	K17B1jur1VjlRsEZGPSSxHfJH+wW/yQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BF9vIUe1785338;
	Mon, 15 Dec 2025 10:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XpkJv3S5nE/VAveCfCz1viALn4psq7VQSujQP/Dph5Y=; b=
	oNHGZz/MmrfCTO6KtXrF5HGC4xzNM+64N0bBQOOUGTt39DxU9VqVfRhLTmh8SJSQ
	3RD5Bkh+T6MihtBy6vTwzdeNAohj27Sleei+DgJjZK7Pw4wQ3CDh0GlBP8ydi1UB
	gSwaSBUleY0MAhzyiD/lt1/0WxyzkpEmRb8dCs1evs+NJTg2/spHbTHQDc+oPM3Q
	doIZqebPTxJ0TCC+jCY5HXb7zGjSRTvPgeYXXGXOdatPLnOJCLZ2vq2GQCZvuTEc
	1LLI/9vrVB/S18XKMfkktd40NMHcpDAFIO8Uz48ay8Prelv0INR6GLunoZWwFa7j
	/BgUN55gnm9vapZ2noaUzw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxstfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 10:16:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BF9NDRt025886;
	Mon, 15 Dec 2025 10:16:47 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012019.outbound.protection.outlook.com [52.101.43.19])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk913nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 10:16:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KeZEYfT7uGKtnj43xnKZzvoxyO0XTecv8+qUnF3y6V5fTc4GoGkmmC97SWp57FMlz6l10ibm7DMNBUwAxmdwQmXTK+qnYIke0NG/IntA2brVbShwPoYL+wIvrvCBUWvtt7qUzkVO4q8cjksew4ZmjYGWRK77l3+Glw7+X5U9ZRsBa4DL8NEwxe00WgI4NoyS8LBrGwoCD81PjCH6nc5BPExDdHBJ/fmyt/GtzZs+yulejQe9senqS7+9O+MO4WUG7xVd+ZfQ9utd+BXCspKkM4kw0OIv7YFEeZDmNhae7UCKshmausyxRnk28NIBFacweNQZct5HqwEhEXta9SSTTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpkJv3S5nE/VAveCfCz1viALn4psq7VQSujQP/Dph5Y=;
 b=Co+yQZtv4rJ4FlONX+88kiJ0pHF41AN+7WKjnZv+X0rvzpXLGuzH44hW2ba3o0p2dv8s5ZZ0K2Ncn2o0DON8DpGinoGzPlal7oa+HOZEdRDJZmWOG/U8CujsW0lwndHkU4v2aSfHlfaWXbqGfv4IgkAQotK/uBJ8D7Xfqqkfw4RcUGMhBn3E+oiyWX1CsIMARxTUqWn8fuYSovq2FZyq3kjeLjXJGuFp5QnVy7JD39sSZzk9Agdt0gpdpLH+ktmcIwShafjahHGElyl9hQaqn7shDSSED53IevhH9fRPdhxvqT2Z8goVdJc3TVWxp4IzX7ECYBDhYeS7JYuL+Bnxtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpkJv3S5nE/VAveCfCz1viALn4psq7VQSujQP/Dph5Y=;
 b=EMNh7+NaKWLzEglbpgo8qNNO5SCtrqDS11PXMjlZ+n5+K70I13LzASNB+j/ucI4UNcZzYACLF6IrQ6dsR/rP3MHcbdOYlmg8e8uHt+BlDHt+IiSiY9fYo/S+gWtZYIqnTihuwzTPnSwf9Id9FF+vTlZPZ2xBzAgrV3yZN6924hc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7307.namprd10.prod.outlook.com (2603:10b6:610:12f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 10:16:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 10:16:27 +0000
Date: Mon, 15 Dec 2025 10:16:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Gregory Price <gourry@gourry.net>
Cc: Jayaraj Rajappan <jayarajpr@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Calls to do_swap_page() from handle_pte_fault() on a system
 where swap is not configured
Message-ID: <776ac4c8-6e55-468e-bb9d-eea49de0ed89@lucifer.local>
References: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
 <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: MM0P280CA0078.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: 13d67636-7a03-4a56-3fab-08de3bc3022d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUVOWm1LMVVSVGd0VTE5M1M1NFJOdzlEN2dhcThlUGRSY0xjek9OelhwczIx?=
 =?utf-8?B?Tzd0QmZxTG94MHh5UkJpSGExN1JoaTFNbFFqeEROSW9ybVpQTmtuN0JuMEc5?=
 =?utf-8?B?V2NqQnJFN3RNY2huU2pDWERIRnBqUHZEZzJPZ3JoT3ZVU2RJa0hsWGo4ZnV4?=
 =?utf-8?B?TGw1NWdrZ3A3aFhJb3pERUpKWGQxSTgvUk02eXlUWlNNR1VUa1JidFkwZ2tn?=
 =?utf-8?B?U1dkVEF0VHB3MFpqTVZoeUFOaVE3OW1XeHB6d2NoLytBS2NRVHJiUmgyS3BE?=
 =?utf-8?B?KzdJT2VscnV1NUY5ZFBzdGg5cldnU1lIZ3ZUaysvVEw0OTRVdEg2WEtFVjN2?=
 =?utf-8?B?QzhRNTdQTFZRUFMyVDlNTGk3Q0dWYWN2akZ5Z1h1NDA2bE0rMnJYTzRxNlJZ?=
 =?utf-8?B?TTErUzRWbSszTWdTTTM4MzVmcDRiYmhDb2NGMUlHUHJMZ0d6VlBQZExoVTk5?=
 =?utf-8?B?R3VVZ0o4aC9USUdOeHhNeUcwaS9TUVR4MHVEQzBvQmU5SThDRURma1pZOUM2?=
 =?utf-8?B?UFJJWmhLZlQ1dXdKRDgrWm1VVFBLMjhoTE1RY25DRDJzdnRMSUUySG5ldFhB?=
 =?utf-8?B?Nm9VdVhlYW5hTUd3cmxLb3lLc1pDYm1wWUJXc21BVkVsOWNROC9BNkg5VmNP?=
 =?utf-8?B?VTFYS2FWN0gwZlo5NHNXQ2JicVVPNEI5NFZ6c0NJRXpWRTl5SndpVmRZeDB1?=
 =?utf-8?B?VTQwZVFQNXlhaUVUTGtEMWNnUm5rOFpaY044WkRNMUtldU9pSU5yRGhONjVx?=
 =?utf-8?B?Ti9hR2ljZGErUUpLOCs3MDNYSlRvYTlCL1dmN1FLMU5PWmd5cnB5dVZyT2Ix?=
 =?utf-8?B?WW9QUkZOR1VoQTZBSzluSDFQaW9qOW1MSlpMRE9qYmRyWGdWanlXS2M3d29j?=
 =?utf-8?B?OVBJWXBLd0t1dS9IaXNNcllUMDQ3WGRtb1FOR05lVzlSc3VwVHpCRmFBTzl3?=
 =?utf-8?B?T3IrK09lODBPWVFZYWxxdEd3ZklJbmZCbVBVbGVBcm0wbUdiMzUrbU0yeWVL?=
 =?utf-8?B?YzZZWWcwM1MwSnFGOHFtanRNMjY2d2xmc3lQL2NTQllzZ3orMy9SaXBiNmhT?=
 =?utf-8?B?UzZxeXhmQ3NkUHdHN21yR0V1T1l5UTdjZVViTGpzT0tseUhwR0NnUEF3cnIw?=
 =?utf-8?B?VjBsN1lwZUlWSjdjUzFBRlJmSXluTDhyNXBjWHl2WDh1NVVneGVacitoUFZ6?=
 =?utf-8?B?UXZsRERUOWFCcDVmRXVLekJHa3cyUGs2TzdtRkNyRFFTa29EYTJ5Y1BNSWZp?=
 =?utf-8?B?UGlOcnJEZytWMEhmMWlwdGIrOE5Ub3pBM0FzOVV4TCs4cTZnTFNSeUVDT1F0?=
 =?utf-8?B?OEk4M0pZcmEwTS9EMDFlZFg0RWVaNjkrVG5EK09OUWhoQ0tubU1SK2tXeUhH?=
 =?utf-8?B?R3hFbGxIZXZ6bExnbFdreUY3WTJESHdHUWFKSUpOSFhjVkQ4WDBRWm8rUXRH?=
 =?utf-8?B?S3VTcG5qa1NWRXpKblpXZkNJTWdNTHIrRmRxU3FmQUl2TkJsRTMyY2hyTk04?=
 =?utf-8?B?UUJPUytiSWhiTzFWNkFpcmduaUt6TUtGckszNEtBT3dzT0poZFdFNGp5ZXBt?=
 =?utf-8?B?NTVuN0M3YlRaM01EODhQSnowbXh3dzcyKzR2VXdVOEkzbndjWlFQUzJxaW9r?=
 =?utf-8?B?OGpWQ2VabksyVk9XZi9yUHA4SlNrdEZjZ3dPbTkrZ1lodzQ3ZDd1ZHIrWk1M?=
 =?utf-8?B?ZUNCSzRmbC9HUHp3Z1JnTTlGaDhoNDVuZUZGd1MzdkgxVUZ0dC8ySmFRM01D?=
 =?utf-8?B?eWExTjl0Z2t1L3M2V1l3N2Q3MzdEdi95ZUZaVUJsR2FYbktnMVoyQ0VGeSs3?=
 =?utf-8?B?Uk0zdDd5VkZGOFptTjFuemd0Z0t5VVoxL3BkVks4TmlMWlBrRDFyYTV6Z0lr?=
 =?utf-8?B?OHhBMndEM2oySUJPMlk3SDlNYmNaMytBSEhDblo2QjJIT2R3MEE5OGIyOWZY?=
 =?utf-8?B?REx1ZDk0ck4yWFlFQVV2dmgwNDB6UzdHMnNZN1RkWmZGWkRHSTJIcTBnV2lH?=
 =?utf-8?B?cXorSUZrM3ZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUpqZDR3TmVFUE5LL1dWSGNnZTA4ZU9NM3hwb24rNXY1TzRaNmI0RXVHaWNR?=
 =?utf-8?B?Tmo3N2RWUUFocnUvY2toc1FVZTFvWFlLYm5aM3dnT0dWKzZtVjVEcjZ3RFM4?=
 =?utf-8?B?ME9HMUtCeFk3RFU5eE5wUHR3UHFod2k0QkFPZmZEc2h4VXhwRFZNL2dLdVNG?=
 =?utf-8?B?UWZvQTcwcU9SNkdBeUVTTmFzOVhlTUNSaUJlU3ZONHlyR3lReTIzSVhma3A5?=
 =?utf-8?B?cU5CbWFJYXZmWmdEYXV6dEtqTWZrR1NVbWNRbTNGdW1JY0U2QnVuVE9Vd1Bx?=
 =?utf-8?B?K1BEL3NnMWs0c0NLYVFUMUNMS1F1VDZ5ZEZsb1dGUi9lYURhNEV3dDZhUXk4?=
 =?utf-8?B?WURNdFhKVTA1cnhSYTF5ckllRG02TUVrMXJGRk5KczltcldsQlZZRDlJbks2?=
 =?utf-8?B?NERYaGl6ZWNTY3dNZ2lRUlJxOExlbXdwakduY0djYy9XWUpnb2hCWHkySDRm?=
 =?utf-8?B?M2kwM2NDdml6TFlnbm5oeEJhbDYrWlhGWTk1NzRrL0c5TWxUTC9ZV3RXSWNC?=
 =?utf-8?B?bzRJTndmejhvK2RDc00wa0Q1WUZpUXhGeG1PRlZOeEV0TUlneHErUzErd1NM?=
 =?utf-8?B?RU5ja3BIVGNOSjZzaHVIYk5TNmZHampqeG9lTTBEcWRzQTVtQjdmN0xPZGRk?=
 =?utf-8?B?Wk5sY2FpMzdEdEFaYUpUMnEyVEp2V0FZMStXdVF0ZEdmeGphNjRyRFhabXQ1?=
 =?utf-8?B?TEhMM2lvVnJNQVNxdW84a0ZoTndta0l2bjFPYkVUWkdSb1lYUGwrVEgwcUxB?=
 =?utf-8?B?NmZCTEJBZ2NDdzBLN3BUWVBpT1BhMkdXRk91UWtjMGNpdWxMYjZERXJ4a3RT?=
 =?utf-8?B?cHhPeHVBdzhzM3VLQXhnQ1YwTkJSM2huNy8yNmVoVXduSUhXTWE0TjQ0WHJQ?=
 =?utf-8?B?bG9IRDFsMEIzVFR1MDZtR0hmcWUxNkF1VzcvQ3QvV2JRWU9HVVFNaHMvemUy?=
 =?utf-8?B?cE9VVEZwMzBpMHdYaXZLUzljYWg1SWNzUTUvZ2cvbTgrTytLTCt2T3hVRzIw?=
 =?utf-8?B?RmxNelYvY3JUZ1dkRVRkMTVoM3IvNjNVUEZMOW5nYzNTVkV2eUd0cFZla2Zo?=
 =?utf-8?B?Ymw3Q2NmLzR6U04wdW93cE4waDVlTEJaQXZmSU9DZ3hqRisrYWh4WEV6WHU5?=
 =?utf-8?B?bE5VdVNoQ1BRdzN2aFF2WHVPbjl4UHR1WjZsK1dVUk9NTFhyRWlSZ2JiQjky?=
 =?utf-8?B?ZkowcEd1UWwxUHZ5TTFPNng4Zk9hc2R1R3ZOUlROK2FXSExSM2hFbGkyRmV2?=
 =?utf-8?B?Z1V0TjFXUk5MLzlOdlE0TmhwSUdhZFhYL0FMYlRFN3BJNmxZSkZVRXVRcnY5?=
 =?utf-8?B?TGxpSW1IcSs4K3hYaVlOdnRRWTNNYWNQTXc3V1N4VE9iRFpWSnhKMUtsbUwr?=
 =?utf-8?B?NWlMVXp4UmpsM0NodU5oT1BtaDFRUGEwVHZ0b2UrdG11L1hoQ2lLRU1XV0VM?=
 =?utf-8?B?L2w0SWNJVTdXZlRMSWw5RFFXQlArS1lqYjBrTWoyQkZKbDdpZmZKU1NSVkM1?=
 =?utf-8?B?cjRHeDBsR0dzdmJMNjd1ZGJjTE9JVHhGektCaGo2eUtWYXhTYk9sZ0ZETWtn?=
 =?utf-8?B?VEhQd3c3bEVZcm0vMFcvaytWTkxFUSt6UXNlcEZ6YWhCU0hONU92NmhYZnQ2?=
 =?utf-8?B?eHR4ZnVvYzV3aWhUZ0M5Q2pSSTdmRzZRVjVZaFNOWTh2QjNJRmorakdibzZL?=
 =?utf-8?B?SWNVMHRYdnRIZU9tRHdETWJiYWQ4Ynl2TktxUHZWVDBCVjlteU9ZdlpIc0RR?=
 =?utf-8?B?K2ErbTVJUmZudDRqalRFZWw5bFJKT3RIeDVCR01zUVJDVGJ6UUc0dUY3RStT?=
 =?utf-8?B?QmRUd09LZ2RYM1lJR0dTKzM0NWt0WUZYdG1VajNzWFZYU2FQUVhIc0JSSXJh?=
 =?utf-8?B?dlJLR2tpSGNuL0xBWjJoTnZLN3RrbGhxMXhrRmVKdk9KZUV0NmxlSjNpQVlo?=
 =?utf-8?B?cEdHdmR3SU16VnJWaGtRUFUwSHl4WmdscUJwRUVBb1cxaGxNT3ROdVFqK2V2?=
 =?utf-8?B?aVlWd3lVb0luNmdkWmRtNGkvaXRTaVI0VTdPL2x0aWt3NWdRVTNsL1BLbVpM?=
 =?utf-8?B?Q211aTJ6cUFieTByOGNwWFlBL1JSZG5acFZyR2JEbWkzRHg1bTRQNk5RaEZT?=
 =?utf-8?B?MHlZNkVjNm9Pa2hhaWlDNEh1OGJFeWozRHJWQzRWdUpyekw2NXE4aHpoOXRB?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2mMB7LeAZT+rGX+r4w5RYzCXJAfjUqBLXCDN2cE3AN2kgWpfJzVYNSLR5SxtwRlC/ntYU8QcHOY9xFIfBZjohmzjpX1EKCJ88s0mWufIezA1ZjGicnC2S6zw9X2sFV+4spo4bLTm6sNNKTxkVGmg5hc6EBJ1eCaX+CgOi4eWksTAN288AQofYDYCVPX/2RXaO+u97qxIw/RGJCYHO48xc7WDfuraRWU4T56Iv2RhnLJgAyfGuoZgz277XiHb90KoeLwWtFtzMWIwf9+orNJp45N9QWUePq9dF+klf5kBjz3xkqgeRFw60d2wLQG4wRB2c9UfBpvkHzcxoKWvvGqd0Vkt/bcPadcrGLf4TlZHx+9gbhVsdnd7Exw8IPj1w/5jFkG80CzR4qPDU+fX0lMTeqlQz+reotAYfBaMHZ1lxs4oSHPLLUXqtU7sYboefGqT93fet1WLVrmg4d4vZgPTQtmqdcVC7mbqJ36Wa4UQULxI3azdC3NYIkf+CC08ztEhS2K39s3kpFxlcc8lukdeXIkLYyUH481zuCTBKazpBA9/xqJUqUWC1TV5rGDQjG88q+4dM3H3AbencfPF3Ieh68yacHRauj9vIxl/7T2Zt0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d67636-7a03-4a56-3fab-08de3bc3022d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 10:16:27.6700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+RSlSsmEE555beC0fYezmGXq9bEj163uRCuASCKvxaqJh+eXU3kUOcNg/pOV6vUNcqdDjGwld9eQSdi+iBwgtvoAT6LKJNPFodqk7sKkAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7307
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_01,2025-12-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDA4NyBTYWx0ZWRfX6Kh9mshEeW6I
 9UKwLsoEnWtr2cccL3X5YueYkS96z7+T27q0PHPKRLpPv7Rks8KgLyGHqSdePKqb4XxjiNw8jex
 9Qw6fjgpk7zJ4yFsbUdhxVYGMu5/umdpYU+0bzP0+Tab4qDzjqvKVN99F7BvJ2//rduOsTkUUN6
 YyUa87YFCBfyWU+5K91Uq4vM5k35QUTXDxN2TdV+4tlVaXxFOvVtFDkBqESO+Yg4vvV/jD7lMUQ
 TYLdj8C4RnvQL5x5vHB7fV5wIXC7loe4VI5ocbe9Wx8P8gNKNq0xNBgloxUMuz7VczzIdtqbttZ
 5e6LoOMD/3NKzDekTmCPmCJjqVAbowDt1KW3YEn243S2oTx07GTRDnMvVwmDZ3gSk9yUHJJ/7It
 ERJuD5gPN+RT58r0Yiy8ZPMkq9jYHA==
X-Proofpoint-GUID: yzPtph9U2WgWy46ZNFKhWyUZ6dKAObEI
X-Proofpoint-ORIG-GUID: yzPtph9U2WgWy46ZNFKhWyUZ6dKAObEI
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=693fe00f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=Iw9P69Z2Bi1p_EBo:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=tHa68p0SAAAA:8
 a=Y_r4snl2nvMz8KXtHYQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=ufIsyHvWW7FwcMbVRpPq:22
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A543AA000C
X-Stat-Signature: 1miwc7enzm3qjgysuy1jbaotuqzgphse
X-Rspam-User: 
X-HE-Tag: 1765793811-572756
X-HE-Meta: U2FsdGVkX1+DlknZeFvS8jAvNcos08kNqGjThScTsPNd5vkWP0vy1OKv1wFHqZ8RbrJhQkqLJofGSH3pDhoy2NvV4bqBlqDLked3SHlXpQfZtOEWsFbJjcfY1dcXVNbcPKpzcdIYpw0NiQdpXJ8TtEw8yYKB3kj7GG96KhbNfApMDzYIV+SUb6wLohAdE9ciSmejvtGwIUehcJ5/VbZbyp3VDafKteCBCtPYnUawwHGgxo0D96SOYnYQkuPPBuoUoWEZ+oZCo5StY9MW33WJcYz7nI/eymB/tp8zmg/RdD/FpGL4Cmgww8UpG4VM0mpGPBET291Sf2ZwPpmwp9FXlb1c7weeSLeBKO2+L4X5/KpqzMwixKAoejgITaV0Rtuv6lHcKt3VZAiJjkpO0Rq3BBdSEr3PFjgl5qMW3Xv1o+1ECuC/Abq+9bfwKug3NHXw7HOGZY8gmp/LLbuNCPWPFOXeuaiDgqPhlY/mlmN1ESKfwd8j9qL4U4xDmhNI4bykKGf3uXtPr//aKwUtfX654Y9wYSCpgkf9D69+6sKdHtu/NuR4+mlBIGlnWY8V6S+b+pSHw1OBnWdpVXHd2EEvtcD7r/ux0acwIiok31H53ZYX3GITx2XuMephVwVXIl8fclrZJdjg7gMRIWCf9hwTmYhqYopTBqPLKEbJ/EZLwReKguRgdldgsZIwbXvc0Lwlbs9QRsyAfvyPzfwNlJLI6i//8TORvH6fy4F+OvW75Lc4bTBXjTjJrPI5CvMMKWurKlPC2KfJ6KQplka4lZFWoGb4xNA+rmuTmIteO627BHMZKcQwcBW7qpr7NvsbIH4tFMO6cvW72CIYIW+lMZboTVG9CALQ0VQtW4WvUMIaJVyI8kL9PhUdEtrcpLCzb42B+/UdcUMk60qD0IKWOxUUn3k+362ucOmzMzQpI2R44CFwSIPk/KZZlEV3E6N5UOkJjuTrwz3ElL6xqPWcAgA
 GR/KLyrJ
 zn9hPzuI8Lc4OYBIW9Az+9SoRREyIF90hoeG5T1GmKcrZROveXxgVl5BrIY111ZQ6dQYvmhnPcu3fqE5WxRmIHryets1ICegMcttzcnSOeK9mx0BYo4dWhj/Aly/jy/j75JfLJKaprGEs5H/otvyIJjhg7tmc6+KcmewZcLcowS9W0zOIvAg8bvgwwC0TuMy8SuWMuQsWmxWzgU7cdt73mlgnZQhTRJuQEZwZsvWliyqnqgl9Ogt2AERlKIG28TNX2cSZViA/CUgdNRqlC8k5lKHDhgtslX7zAoLNqSAMOI299aK2QFlbwjywE1UOU2B4aIrObvKOBYWtVie4Eb5t2PWSsOSj8G58U2KmaIvALDBaJnkCcFuhiWa4tDyWBaMH+DzhiZ1Urhup+jlV7qfTom0v3b2psURkQSErGGDUjUxe5ocBqheYaKindCqqse32TMCntTgRatzDScNc4Zfw9rcf94saE1bNK8w4+Zo3Oxr5iEWKZdK/Tky28ahyA50V2OE9zfKLZDxAOg7wPAl1SOfEoNZrkrGbbyqnHSDKVV7MdZA67hEVo/iRj+d6URAcwBUsTdvDszNeW2aAt5dBqJDMPF6tUkMfNAFSXcr6thzfrd/SGPYt6aK9wlioiQSTQAURcw00a7+OGOoW+J8HjSzDSvL4vLR4cnnD5qRV41XMOGemCsBpHFP9LjEFNq3cdocT9Ksa/LIHDlPxJP653W8MAH+zvMgwJXaLb0lHwqj3WE4JsTlxAwMYBtXrQjPP+Phs0UvxWAsnL/in7slLH5ieHa+NhiNqnplP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 03:18:57AM -0500, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 01:11:24PM +0530, Jayaraj Rajappan wrote:
> > Hi,
> >
> > On a system where swap is not configured, profiling using Linux "perf"
> > tool shows that do_swap_page() gets called from handle_pte_fault().
> > Kernel version is 5.14.0. HugePages are disabled on the system. Trying
> > to understand what could cause do_swap_page() to be called when there
> > is no swap configured on the system.
> >
>
> all do_swap_page() call means is that the PTE is valid (something is
> there) but not present (the present-bit is not set, or whatever that
> particular architecture considers is present is not met)
>
> static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
> {
> ...
>         if (!vmf->pte)
>                 return do_pte_missing(vmf);
>
>         if (!pte_present(vmf->orig_pte))
>                 return do_swap_page(vmf);
> }
>
>
> There are other non-swap swap-entries that are handled by the same code.
> Transient migrations, device private, etc etc.
>
> swap-entries are being renamed "softleaf" entries here shortly:
> https://lore.kernel.org/linux-mm/cover.1762812360.git.lorenzo.stoakes@oracle.com/

And now upstream :)

>
> So it means "a software-entry is present" which could be any of:
> enum softleaf_type {
> 	/* Fundamental types. */
> 	SOFTLEAF_NONE,
> 	SOFTLEAF_SWAP,
> 	/* Migration types. */
> 	SOFTLEAF_MIGRATION_READ,
> 	SOFTLEAF_MIGRATION_READ_EXCLUSIVE,
> 	SOFTLEAF_MIGRATION_WRITE,
> 	/* Device types. */
> 	SOFTLEAF_DEVICE_PRIVATE_READ,
> 	SOFTLEAF_DEVICE_PRIVATE_WRITE,
> 	SOFTLEAF_DEVICE_EXCLUSIVE,
> 	/* H/W posion types. */
> 	SOFTLEAF_HWPOISON,
> 	/* Marker types. */
> 	SOFTLEAF_MARKER,
> };
>

Not to toot my own horn but it's kind of nice to have this explicit list of
possibilities here :)

> -------
>
> +Cc Lorenzo:
>
> do_swap_page() is a stale name now probably?
>
> I know there was a hold-off on changing actual swap code, but maybe
> worth changing do_swap_page -> do_softleaf_page?

Yeah I think this probably would be a good idea.

I do want to keep explicit swap state around to minimise changes to the
_actual_ swap code, possibly even having something like:

swp_entry_t softleaf_to_swap(softleaf_t entry)
{
	VM_WARN_ON_ONCE(!softleaf_is_swap(entry));

	return ...;
}

I'd like to actually make the softleaf_t different from swp_entry_t at some
point just to eliminate confusion between the two (or at least make
conversions explicit, rather).

>
> Not build or anything tested (sorry it's 3am insomnia time), basically just:

Ah sorry you have issues with that, me too! Though not ML'd at 3am before
myself :P

>
> s/do_swap_page/do_softleaf_page
> s/DO_SWAP_PAGE/DO_SOFTLEAF_PAGE
>
> No clue what's up with the special sparc stuff.

:))

But in general LGTM, obviously assuming David's points are addressed.

Is this a patch you'd like to do? Or I can batch up with the next softleaf
series?

Cheers, Lorenzo

>
> ~Gregory
>
> -------
>
> From 92de7131f74b9300ea711ceae98bbe137cf0058f Mon Sep 17 00:00:00 2001
> From: Gregory Price <gourry@gourry.net>
> Date: Wed, 3 Dec 2025 03:12:44 -0500
> Subject: [PATCH] mm: rename do_swap_page to do_softleaf_page
>
> do_swap_page is a stale function name with introductio of softleaf.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  Documentation/admin-guide/mm/ksm.rst                   |  2 +-
>  Documentation/gpu/rfc/gpusvm.rst                       |  2 +-
>  .../translations/zh_CN/admin-guide/mm/ksm.rst          |  2 +-
>  .../translations/zh_TW/admin-guide/mm/ksm.rst          |  2 +-
>  arch/sparc/include/asm/pgtable_64.h                    |  4 ++--
>  include/linux/ksm.h                                    |  4 ++--
>  include/linux/pgtable.h                                | 10 +++++-----
>  mm/internal.h                                          |  2 +-
>  mm/khugepaged.c                                        |  6 +++---
>  mm/ksm.c                                               |  2 +-
>  mm/memory-failure.c                                    |  2 +-
>  mm/memory.c                                            | 10 +++++-----
>  mm/page_io.c                                           |  2 +-
>  mm/rmap.c                                              |  4 ++--
>  mm/shmem.c                                             |  2 +-
>  mm/swapfile.c                                          |  6 +++---
>  mm/zswap.c                                             |  4 ++--
>  17 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index ad8e7a41f3b5..4c660dbc908e 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -286,7 +286,7 @@ cow_ksm
>
>  ksm_swpin_copy
>  	is incremented every time a KSM page is copied when swapping in
> -	note that KSM page might be copied when swapping in because do_swap_page()
> +	note that KSM page might be copied when swapping in because do_softleaf_page()
>  	cannot do all the locking needed to reconstitute a cross-anon_vma KSM page.
>
>  Advisor
> diff --git a/Documentation/gpu/rfc/gpusvm.rst b/Documentation/gpu/rfc/gpusvm.rst
> index 469db1372f16..3a444bf2768b 100644
> --- a/Documentation/gpu/rfc/gpusvm.rst
> +++ b/Documentation/gpu/rfc/gpusvm.rst
> @@ -14,7 +14,7 @@ Agreed upon design principles
>  	  this path. These are not required and generally a bad idea to
>  	  invent driver defined locks to seal core MM races.
>  	* An example of a driver-specific lock causing issues occurred before
> -	  fixing do_swap_page to lock the faulting page. A driver-exclusive lock
> +	  fixing do_softleaf_page to lock the faulting page. A driver-exclusive lock
>  	  in migrate_to_ram produced a stable livelock if enough threads read
>  	  the faulting page.
>  	* Partial migration is supported (i.e., a subset of pages attempting to
> diff --git a/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst b/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst
> index 0029c4fd2201..269cb94362ce 100644
> --- a/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst
> +++ b/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst
> @@ -191,7 +191,7 @@ cow_ksm
>
>  ksm_swpin_copy
>          在换入时，每次KSM页被复制时都会被递增。请注意，KSM页在换入时可能会被复
> -        制，因为do_swap_page()不能做所有的锁，而需要重组一个跨anon_vma的KSM页。
> +        制，因为do_softleaf_page()不能做所有的锁，而需要重组一个跨anon_vma的KSM页。
>
>  --
>  Izik Eidus,
> diff --git a/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst b/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst
> index 1b4944b3cf61..afea57754c41 100644
> --- a/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst
> +++ b/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst
> @@ -191,7 +191,7 @@ cow_ksm
>
>  ksm_swpin_copy
>          在換入時，每次KSM頁被複制時都會被遞增。請注意，KSM頁在換入時可能會被複
> -        制，因爲do_swap_page()不能做所有的鎖，而需要重組一個跨anon_vma的KSM頁。
> +        制，因爲do_softleaf_page()不能做所有的鎖，而需要重組一個跨anon_vma的KSM頁。
>
>  --
>  Izik Eidus,
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> index 615f460c50af..7fee128daf03 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -1054,8 +1054,8 @@ void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
>  int adi_save_tags(struct mm_struct *mm, struct vm_area_struct *vma,
>  		  unsigned long addr, pte_t oldpte);
>
> -#define __HAVE_ARCH_DO_SWAP_PAGE
> -static inline void arch_do_swap_page(struct mm_struct *mm,
> +#define __HAVE_ARCH_DO_SOFTLEAF_PAGE
> +static inline void arch_do_softleaf_page(struct mm_struct *mm,
>  				     struct vm_area_struct *vma,
>  				     unsigned long addr,
>  				     pte_t pte, pte_t oldpte)
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index c982694c987b..a024ca1bae3a 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -81,10 +81,10 @@ static inline void ksm_exit(struct mm_struct *mm)
>  }
>
>  /*
> - * When do_swap_page() first faults in from swap what used to be a KSM page,
> + * When do_softleaf_page() first faults in from swap what used to be a KSM page,
>   * no problem, it will be assigned to this vma's anon_vma; but thereafter,
>   * it might be faulted into a different anon_vma (or perhaps to a different
> - * offset in the same anon_vma).  do_swap_page() cannot do all the locking
> + * offset in the same anon_vma).  do_softleaf_page() cannot do all the locking
>   * needed to reconstitute a cross-anon_vma KSM page: for now it has to make
>   * a copy, and leave remerging the pages to a later pass of ksmd.
>   *
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b13b6f42be3c..21262969b6b3 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1142,8 +1142,8 @@ static inline int pgd_same(pgd_t pgd_a, pgd_t pgd_b)
>  }
>  #endif
>
> -#ifndef __HAVE_ARCH_DO_SWAP_PAGE
> -static inline void arch_do_swap_page_nr(struct mm_struct *mm,
> +#ifndef __HAVE_ARCH_DO_SOFTLEAF_PAGE
> +static inline void arch_do_softleaf_page_nr(struct mm_struct *mm,
>  				     struct vm_area_struct *vma,
>  				     unsigned long addr,
>  				     pte_t pte, pte_t oldpte,
> @@ -1157,17 +1157,17 @@ static inline void arch_do_swap_page_nr(struct mm_struct *mm,
>   * page is being swapped out, this metadata must be saved so it can be
>   * restored when the page is swapped back in. SPARC M7 and newer
>   * processors support an ADI (Application Data Integrity) tag for the
> - * page as metadata for the page. arch_do_swap_page() can restore this
> + * page as metadata for the page. arch_do_softleaf_page() can restore this
>   * metadata when a page is swapped back in.
>   */
> -static inline void arch_do_swap_page_nr(struct mm_struct *mm,
> +static inline void arch_do_softleaf_page_nr(struct mm_struct *mm,
>  					struct vm_area_struct *vma,
>  					unsigned long addr,
>  					pte_t pte, pte_t oldpte,
>  					int nr)
>  {
>  	for (int i = 0; i < nr; i++) {
> -		arch_do_swap_page(vma->vm_mm, vma, addr + i * PAGE_SIZE,
> +		arch_do_softleaf_page(vma->vm_mm, vma, addr + i * PAGE_SIZE,
>  				pte_advance_pfn(pte, i),
>  				pte_advance_pfn(oldpte, i));
>  	}
> diff --git a/mm/internal.h b/mm/internal.h
> index 04c307ee33ae..7019db4f6dd6 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -436,7 +436,7 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
>  	return ret;
>  }
>
> -vm_fault_t do_swap_page(struct vm_fault *vmf);
> +vm_fault_t do_softleaf_page(struct vm_fault *vmf);
>  void folio_rotate_reclaimable(struct folio *folio);
>  bool __folio_end_writeback(struct folio *folio);
>  void deactivate_file_folio(struct folio *folio);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 89c33ef7aac3..a6e09e94834c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1007,7 +1007,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>  		if (!pte++) {
>  			/*
>  			 * Here the ptl is only used to check pte_same() in
> -			 * do_swap_page(), so readonly version is enough.
> +			 * do_softleaf_page(), so readonly version is enough.
>  			 */
>  			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
>  			if (!pte) {
> @@ -1024,12 +1024,12 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>
>  		vmf.pte = pte;
>  		vmf.ptl = ptl;
> -		ret = do_swap_page(&vmf);
> +		ret = do_softleaf_page(&vmf);
>  		/* Which unmaps pte (after perhaps re-checking the entry) */
>  		pte = NULL;
>
>  		/*
> -		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
> +		 * do_softleaf_page returns VM_FAULT_RETRY with released mmap_lock.
>  		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
>  		 * we do not retry here and swap entry will remain in pagetable
>  		 * resulting in later failure.
> diff --git a/mm/ksm.c b/mm/ksm.c
> index cfc182255c7b..002140f01bf5 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3124,7 +3124,7 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
>  	if (PageHWPoison(page))
>  		return ERR_PTR(-EHWPOISON);
>  	if (!folio_test_uptodate(folio))
> -		return folio;		/* let do_swap_page report the error */
> +		return folio;		/* let do_softleaf_page report the error */
>
>  	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr);
>  	if (new_folio &&
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fbc5a01260c8..07e3a17af119 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1104,7 +1104,7 @@ static int me_pagecache_dirty(struct page_state *ps, struct page *p)
>   *      - but keep in the swap cache, so that when we return to it on
>   *        a later page fault, we know the application is accessing
>   *        corrupted data and shall be killed (we installed simple
> - *        interception code in do_swap_page to catch it).
> + *        interception code in do_softleaf_page to catch it).
>   *
>   * Clean swap cache pages can be directly isolated. A later page fault will
>   * bring in the known good data from disk.
> diff --git a/mm/memory.c b/mm/memory.c
> index 6675e87eb7dd..6d31eda830a5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3371,7 +3371,7 @@ int apply_to_existing_page_range(struct mm_struct *mm, unsigned long addr,
>   * handle_pte_fault chooses page fault handler according to an entry which was
>   * read non-atomically.  Before making any commitment, on those architectures
>   * or configurations (e.g. i386 with PAE) which might give a mix of unmatched
> - * parts, do_swap_page must check under lock before unmapping the pte and
> + * parts, do_softleaf_page must check under lock before unmapping the pte and
>   * proceeding (but do_wp_page is only called after already making such a check;
>   * and do_anonymous_page can safely check later on).
>   */
> @@ -4569,7 +4569,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>  		goto fallback;
>
>  	/*
> -	 * For do_swap_page, find the highest order where the aligned range is
> +	 * For do_softleaf_page, find the highest order where the aligned range is
>  	 * completely swap entries with contiguous swap offsets.
>  	 */
>  	order = highest_order(orders);
> @@ -4618,7 +4618,7 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
>   * We return with the mmap_lock locked or unlocked in the same cases
>   * as does filemap_fault().
>   */
> -vm_fault_t do_swap_page(struct vm_fault *vmf)
> +vm_fault_t do_softleaf_page(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct folio *swapcache, *folio = NULL;
> @@ -5008,7 +5008,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	VM_BUG_ON(!folio_test_anon(folio) ||
>  			(pte_write(pte) && !PageAnonExclusive(page)));
>  	set_ptes(vma->vm_mm, address, ptep, pte, nr_pages);
> -	arch_do_swap_page_nr(vma->vm_mm, vma, address,
> +	arch_do_softleaf_page_nr(vma->vm_mm, vma, address,
>  			pte, pte, nr_pages);
>
>  	folio_unlock(folio);
> @@ -6234,7 +6234,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  		return do_pte_missing(vmf);
>
>  	if (!pte_present(vmf->orig_pte))
> -		return do_swap_page(vmf);
> +		return do_softleaf_page(vmf);
>
>  	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
>  		return do_numa_page(vmf);
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 3c342db77ce3..3bcc8487b600 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -514,7 +514,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
>  	/*
>  	 * Swapping in a large folio that is partially in the zeromap is not
>  	 * currently handled. Return true without marking the folio uptodate so
> -	 * that an IO error is emitted (e.g. do_swap_page() will sigbus).
> +	 * that an IO error is emitted (e.g. do_softleaf_page() will sigbus).
>  	 */
>  	if (WARN_ON_ONCE(swap_zeromap_batch(folio->swap, nr_pages,
>  			&is_zeromap) != nr_pages))
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f955f02d570e..21c3a40ee824 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2535,7 +2535,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>
>  			/*
>  			 * Store the pfn of the page in a special migration
> -			 * pte. do_swap_page() will wait until the migration
> +			 * pte. do_softleaf_page() will wait until the migration
>  			 * pte is removed and then restart fault handling.
>  			 */
>  			if (writable)
> @@ -2755,7 +2755,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>
>  	/*
>  	 * Store the pfn of the page in a special device-exclusive PFN swap PTE.
> -	 * do_swap_page() will trigger the conversion back while holding the
> +	 * do_softleaf_page() will trigger the conversion back while holding the
>  	 * folio lock.
>  	 */
>  	entry = make_device_exclusive_entry(page_to_pfn(page));
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ad18172ff831..7fa65a8501b4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2092,7 +2092,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>   * we may need to copy to a suitable page before moving to filecache.
>   *
>   * In a future release, this may well be extended to respect cpuset and
> - * NUMA mempolicy, and applied also to anonymous pages in do_swap_page();
> + * NUMA mempolicy, and applied also to anonymous pages in do_softleaf_page();
>   * but for now it is a simple matter of zone.
>   */
>  static bool shmem_should_replace_folio(struct folio *folio, gfp_t gfp)
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d12332423a06..40039586f56e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1568,7 +1568,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
>   * example, the following situation is possible.
>   *
>   *   CPU1				CPU2
> - *   do_swap_page()
> + *   do_softleaf_page()
>   *     ...				swapoff+swapon
>   *     __read_swap_cache_async()
>   *       swapcache_prepare()
> @@ -1578,7 +1578,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
>   *
>   * In __swap_duplicate(), the swap_map need to be checked before
>   * changing partly because the specified swap entry may be for another
> - * swap device which has been swapoff.  And in do_swap_page(), after
> + * swap device which has been swapoff.  And in do_softleaf_page(), after
>   * the page is read from the swap device, the PTE is verified not
>   * changed with the page table locked to check whether the swap device
>   * has been swapoff or swapoff+swapon.
> @@ -2201,7 +2201,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  		rmap_t rmap_flags = RMAP_NONE;
>
>  		/*
> -		 * See do_swap_page(): writeback would be problematic.
> +		 * See do_softleaf_page(): writeback would be problematic.
>  		 * However, we do a folio_wait_writeback() just before this
>  		 * call and have the folio locked.
>  		 */
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..db85ad97ccdb 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1586,13 +1586,13 @@ bool zswap_store(struct folio *folio)
>   *
>   *  -EIO: if the swapped out content was in zswap, but could not be loaded
>   *  into the page due to a decompression failure. The folio is unlocked, but
> - *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
> + *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_softleaf_page()
>   *  will SIGBUS).
>   *
>   *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>   *  to a large folio, which is not supported by zswap. The folio is unlocked,
>   *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> - *  do_swap_page() will SIGBUS).
> + *  do_softleaf_page() will SIGBUS).
>   *
>   *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>   *  locked on return.
> --
> 2.52.0
>

