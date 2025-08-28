Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55BFCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B7B6B009B; Thu, 28 Aug 2025 08:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A7E6B009D; Thu, 28 Aug 2025 08:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7636B009E; Thu, 28 Aug 2025 08:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8F016B009B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:35:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31942C0189
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:35:45 +0000 (UTC)
X-FDA: 83826112650.04.6DC02CF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id C93BDC000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:35:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l7WRsANx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OlokiGCX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756384541; a=rsa-sha256;
	cv=pass;
	b=vnLf01azJwjpEJOVvNiePbrJS9UTHIVjQpj6PpumIGA662GrlKipMsYgTfLylX/yIttcOf
	q6JMfwUySUMki3nkRqWYJH9FFKsj2k57vP7+Oeb3ojA42M8Lk1Hpywp2Oc1w7MY/iVvjRv
	Z+d+iUd5aAJr2s69bH+1/VKQS2yofeg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l7WRsANx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OlokiGCX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryepdK9hgrsryaVqIaYsc6S0+9pI6GBVRkE4XCj0QFg=;
	b=7dKzRhhgi5rQkaWhNqUbvhEC7iFuHmzEQw2yb/sQYsoacTJrcKjaspv5xY2nv0NQTOyycF
	Uk5aUUfAvs8Tp3R5HOuatV7kFf/SX0NaTfsir+4sDu3O5LfpK2h6hMo+hCgxEWWCuLh55I
	W6oInXmlWO8rDALFBSusKJvTPBkqkhI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S8tnFG021624;
	Thu, 28 Aug 2025 12:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ryepdK9hgrsryaVqIaYsc6S0+9pI6GBVRkE4XCj0QFg=; b=
	l7WRsANxtoRDci9Tv+URjuJdp+wgL5J0IMiT5CfLikJPLsc0uMol6Hb1HnNSe7JY
	tVSrgKTbSpE4T5Nih+gHdjTzfLJGw4SxXPN0iauDU1/5C5ISD1q5M0UfNxqlY5Vt
	hlE6htmPS5qoac4TAl+aoDVsGwddsC/tTTe1XZDYi5Gp16npD19ME0q22AyVsXbN
	+rRWViXN3fkuVTKps7unTrBEjbwQxpCiFV4WLK40NZVoGel2H3YLBOI451CwfWmp
	3ObsU+zpqor5G79meRM2MSf6uUg+QukWQEleS5R9JsXaPbeD/SX2oyt154cdzKKP
	fwgBuweWV3eT4FumCtXRaQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e28gng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:35:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SBmfSY004977;
	Thu, 28 Aug 2025 12:35:34 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bydyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:35:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+Q1d/q/mOCqGWXDCJHHJYLogAs5caWBNVl2zPFutl9suX1LhIGC6rZxNfgvQhNXE+X80h6m/v+hhlHiFEWldhp595KP/PMXtbfPdRh8v/3mrP2fnF7x7bybm0BA3ieKmuw6pBvJZhDCBB+wcXNJxuJUWFRyELPfWI0jCaKLQeNuNN8ZHTaA24qw41ALJoM0o8nCXY115OgDYwmcQyV01ECurM6sKoGBhDbml/tCxup4Sg+TR8w/YJn1P4qdTn3bf+FcBYMVHr5XCbPD+jlZwDL8oOY3gLwV9WyVGaNjjKNPeX9djNne8KWxnnxRI9SdvIJbLMg4FavUmiInvYMbVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryepdK9hgrsryaVqIaYsc6S0+9pI6GBVRkE4XCj0QFg=;
 b=PhSyxFU82qiuKZUzfSWYqxR5Rat00o3zP4agsKdK6Bu/COKe9hWmWw1W2zZmgypiog/sCqKBdSYTzJkI0hUwVPMu9Kp8r30dHfOq8vfCtfObpH/7Sj0SN1LA3CNH+LAYb9RCbl/d+qEhz9XuVGV4mcGhcnUYAcUAE4R4nAYYLfFxAnP0jqsSFS9MfpTiBNeX46nWeR6ofjNSFKwYcTJ/7h+aTBhvCDvigyA+jCeJpdV3y4BddfwEikVx9exjrkPEsbXkzhATdGLMjvcc7t8PqjvP8ZSvmjNLN7Pui0EJZkBnee+glNjI9ttC5bB/YNvg9JZQqXbk4zzB7xSJppSr4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryepdK9hgrsryaVqIaYsc6S0+9pI6GBVRkE4XCj0QFg=;
 b=OlokiGCXH3/8NHRDUKSNbL3MeEExndi8YrvsKX25QaRcMpwH8tuhm7Pudad1amb5TTOjKyL0xz9L8sgnWRquATWUUzETiuxKBj87TRpjN3/iTl/UVxUa9dakPaVKRq6LjH5ojXhj3klyOjySXOWvwSjG8K3vafNa1ydExiYyTZI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4635.namprd10.prod.outlook.com (2603:10b6:806:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 12:35:22 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 12:35:22 +0000
Date: Thu, 28 Aug 2025 13:35:19 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
Message-ID: <56d18767-8b3e-470d-ad60-781a6f17f9d4@lucifer.local>
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <20250827144832.87d2f1692fe61325628710f4@linux-foundation.org>
 <74a33635-3348-4e70-8cdb-16307f839b79@lucifer.local>
 <CAKPOu+-0zuz-t22RmENiAT7SXTMyRVeHgkCrnLK-Xt-DDxHykQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKPOu+-0zuz-t22RmENiAT7SXTMyRVeHgkCrnLK-Xt-DDxHykQ@mail.gmail.com>
X-ClientProxiedBy: GV2PEPF00003828.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:5:0:7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d9f10ae-389a-4f02-24a5-08dde62f5b2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amdsRE5VaTJrdlNoVmFQSGlTaTR5Ums1V1J3Yk5KZW1VZlVoQVdZY25wVW1N?=
 =?utf-8?B?Z1VXZ2hqMVFCd0dLRk14bkdPVmF5SlVjaFVGUkN3a2F5a2RPSkU2Z3Q1cTRG?=
 =?utf-8?B?RVZiV3g3OHd3NzF3Q3E1SjNzQzdzMjhJS0tvUmgyNU5wMWxDa0NabGJtQVNh?=
 =?utf-8?B?VUwvODVBU1I3TzRSRVNuNjA1TnFXVlk1aWxQQUpNSUE4b1JUTk9seWhBWjRV?=
 =?utf-8?B?Q2VhckpCcHNFNlNXUkROUXc1RmtxL0xJKzlRTU5HNWFxdm85SHdvcEFPbFcy?=
 =?utf-8?B?WkpWQ2JqNU44Nk1RejlQR3F2QksrMEVXYnVyV1ZqV2ErcHBRMzhSOHhCVlc5?=
 =?utf-8?B?WTFEQVcyS05xZ3lOZzUreW1pc0hWRkRtZ0l0cDViNXZrYUo2czdhVWM3Umtx?=
 =?utf-8?B?VkRQVDJ2a2N1ZmdWSHpFOWUvVnNmVy82R1dhU2wrV2h4dHpFaUF6QURhYlo5?=
 =?utf-8?B?QmM3L2UxNjdRZ1MwQkFLNmd5cXNiSkVmb1FXVUt3VWgyVWpETTJET212VnBK?=
 =?utf-8?B?Y2J2U29DS2hPT1VlRDNxbUlhV1ZNOGxvbzlCb2VlbmdneWdhZG9mdmpYbzA4?=
 =?utf-8?B?aDY0T0tCVHlSUTE1dUdaT0VvOXA0OWRLRlFVNERENkl1Q3p2ZjczT042TXZH?=
 =?utf-8?B?THJqWm5tb3lLd1B2cURGUm5KSUFLcG1JWnAwWWNkUHpVbTR1UXU2OXRqVmla?=
 =?utf-8?B?MFFUcXpQQUhMOE8yREFxYUxTNTdjNzdMWXFFN1B5eldmUkxpRWV4WURLcTND?=
 =?utf-8?B?QlV0aTN1MW1DWXYyMHZlY3lkYUV2VXlXY05aRFE2RGhEUFZraktrZVdFdTNR?=
 =?utf-8?B?ejhGcFRwWVlQTXlmWHV1OElGbklldExOWHpJOWdVN1F2ZlNZZlRlUlpEY3dW?=
 =?utf-8?B?ellSRnd2em9ZN3Q2bnE5NHFwbUE0Z1d2VExEWHhJWnNCbTcyMkNlUjhZQWJ0?=
 =?utf-8?B?UGlWcll2ZEJxemRiOGZBOXRBczdEYkZja2RCTVk4alhDOUROVWFXaUFkVVVs?=
 =?utf-8?B?ZHlKdlU0VjFLRjJFUE82eis0UUtYVUZLYTFOL2I0S3pEd2RBMmtqak9jRVVo?=
 =?utf-8?B?MEYwRnVzR1FLQ1h2d3kxbTUrUWtPZnhTWFZEOFQwMHlzVnV1dkFtR1BuNDM0?=
 =?utf-8?B?bC91ZjRIR3BpTWl3bkdabVVjdFFTSUF5bTZlUFNqVXRIRTNldW5IRHFxVkJ2?=
 =?utf-8?B?cjhmdk9PVzVwR2dtSEVpZHVJMkMwQWNwQTZncHp1UFlKZzdSR1dSRi9NcVFi?=
 =?utf-8?B?c3NBU0NGditWN1hHSm9FRklxeCtjekV5MnFCZG1Sb09mYmFNSEhnaEsvUXF1?=
 =?utf-8?B?Rm04VENpQXhqVU9HMzhoOGw0YzF3cVAyMU8xZHlBR1dLYUpycWtlYTl6elY0?=
 =?utf-8?B?WWtoeXBSYmp1Ylg1VmZVc056OVNKbVFBTldJamROaUdHcTF1bmdreHZ4cGp1?=
 =?utf-8?B?UjM5dGV2YVZmZWFpOElQWjRaS3plRHFxL1VoL3NsU1lyNU9ZVWNrRnk5a1NX?=
 =?utf-8?B?RmpJQTdWeFl2SWx1cUdZTkhYNGJoTXZrbmx1d3hJTDhpZlFUTlF0b0VkSXl6?=
 =?utf-8?B?V3oxc2gzYk8wbStXb25aYnZjazdSNHlTYTc1TTFSamN6UzlZTTZJd0hCOHFF?=
 =?utf-8?B?WjFVZ2VxcjU1Y2lWM3hPRjJwWlBNZWREQjF1d0RldWRhU3RyMHV3c2g1Z2Vl?=
 =?utf-8?B?MjM1LzEyTHYwV0J1VTloUFoyaEN3TGdhUjVobFUvM1BTM3J5aTIxNEVPUUor?=
 =?utf-8?B?cmsxYVFIZUFneU80Zk9jcGNjRUJSWW9tU3M5MWI4eDJGb0xnMnJid1k0dURa?=
 =?utf-8?B?TjlQSCtmcXVNSCtCaVVyTkRrQ1FJUDh4eVB5SUxZVTlibGtxaXNzQ1didWQ5?=
 =?utf-8?B?UlQrWnFtK2pDMm5iRXdWaDRsSlVOcmVwb1FGYTNDSG54YnhycjRXWGdzK1RB?=
 =?utf-8?Q?3pXAlw8B8xM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVVTR2JZOVhoV0VOYnl6ZER4K0FsOUJqODNWUzVPblB1ZGtYWm96TkVXelkv?=
 =?utf-8?B?bDArU3l1RTFpWmNGaFUrN1RiSWFkSm5XR0VBekNPaEMvS0MyN0QrckQ4c3N0?=
 =?utf-8?B?bVdWSnF4dWh5Ky83cXpHRjIyNkdxM2NyRXhzR3BoMnRkampkbEdtZjZOOVV3?=
 =?utf-8?B?YjdlZWhWYVBQYjhWQkVzYmdKWi9seENIcnR0YmhZeHVjakpLMDRZYlM0L3I0?=
 =?utf-8?B?dkRlYkVTSzJEMExkb1JCUEhoMnRibnpUSk80NUxqOExBcTU2S2VBZHRvV3o0?=
 =?utf-8?B?OC9SajdmVFlQM0RCUWJNYXVSQlYyeGVnUE96dUMwUUJJMzFBMzg1aURNLzAz?=
 =?utf-8?B?Z3JDaEk0NGsxd1dCYXM5dXVlU0ZyUHRtS25KeXJjTFhmK2dlZEc5c3FIQ2hQ?=
 =?utf-8?B?RGIxWFEwd25LdW40SFJPNWpoN0RwOXJId2pnR2xoRGNXdDZIN3l3QkFyOS9B?=
 =?utf-8?B?cElxU25TU1lPVzNZdStLeFpQTlJ0VWQzRm50a2tsenJQai9xSi9hZ2FOZTcx?=
 =?utf-8?B?TVIzeW1Ea281UGtCRk95MHNqUW1JOXdCMXQrcFRiNkdicjk0RTBsTyt1b0kz?=
 =?utf-8?B?T2VvcEt3WC9PYWdXNDhObTEyT3gyNWRVdWNSYWFmTTkyTExKRWRIc01haldW?=
 =?utf-8?B?ZVg5NEF5UXRRNWdScFBKNnJyV0NqOTk4YlAyZnNkZE1CajJETU9pNWtaU3dH?=
 =?utf-8?B?SkRUUEdhOHZialhlaitmU1lkZ0dYV0ducHRHayswbE1sMHRNSUttWkE5T0h1?=
 =?utf-8?B?Q3NIKzBjblgxU0lobjZRQ3NIckkzUVJkTlVkT2VyUVBBQUtoZXd0QXRTVnFq?=
 =?utf-8?B?NTJabUdtdmYyY3Q2QW4vYjVWY0szcGw3SVhYZFBMWHdJcEZVVVVPdEMzamhy?=
 =?utf-8?B?ZUkrZUlKR2FIUS9CRWdDaktLdE5uMFA3amZ3dWhwRGF2TWZtS1d2V24renlW?=
 =?utf-8?B?RTVnWkNuOHJVTUMrZVhMVURpdVBEZGlNMHJXc2RTYk5HMUh2SHhUNXY0MzN1?=
 =?utf-8?B?NjBPUGZNVUt0TDZUREVHRFdPVHkzdGp4ejdrRmw3Sm5EcUw2WkJWN21OcWVE?=
 =?utf-8?B?b1BiMUtUZTROdTZEWHlZdHE0bHhDQStmU2h2ekV4cUh2OXcybVpBc0h6OCto?=
 =?utf-8?B?NDFYTjViTk16cWVtckFaWXRoaldFVDhnWVFGd3FWRTVmQ3FsWVVLbVJENSta?=
 =?utf-8?B?QVQ2Rk9NblpsNTA5RGhIcmI4R2I1WXl5S0tZQjkxUzVaSE5CUzMxYmxwMytp?=
 =?utf-8?B?cTgrS2FhSXVkT3FHOHNLQVVmVi9oUUFMMVhzZnhUbFhQMGo0TFJEOGlkOE43?=
 =?utf-8?B?SjJONGpZdVRIRFJaTjJ3M0RpSXJCWVFDRVRLU2ZWM1lXcDhIam1ORlN1RnBw?=
 =?utf-8?B?My9JSXg3aHlZemdIUERCS1U1bU1RUTlySVFXbVNpNDU4dG0wWUtVVVNVd0NT?=
 =?utf-8?B?SlRoVzFJQUVCaWtacG1EV1ZocERMVXczaE9UaEo0eTZUMDlDMEx4b0QrbVY1?=
 =?utf-8?B?SWFBM08ydjFKTTRDNCt5bXUrYWY4UkRhSnBJV2FxeUY5YStCWXEwWnJRVlNH?=
 =?utf-8?B?V3ZYTFZQcVN5eHozUkdzYnJ3MFVJQldzdStFVXlwRXg5dE1hZVhiWXhTUnY2?=
 =?utf-8?B?NDVUTlVmVkZPMXI0MUJqN2ZabFNrZUVCUE5pNHAvQWNRK3B5R1prNEpnckVQ?=
 =?utf-8?B?M3VLaWt2RWMyaUd6UkVhSTFZMElYbzlJbEttRVU4UWtwV3dWSkQ3VWhDVVRC?=
 =?utf-8?B?THQxQnpkSUVmdmtmZ25LMkRHZE8rc3BaUUVqNGVRSnZlR1l0TXdacFJSRkZD?=
 =?utf-8?B?NTlTMmwzZjhrcDlmZTJKN3B3Yks2YVkramhiY3VZbnF0S3pkb1NKZ3lldjI1?=
 =?utf-8?B?VXBVOHAvVUNua0FMWCtzWkM3bm93SDA0M0xLNHVVR0FZeW45VTRCRlZlVE1o?=
 =?utf-8?B?YVpHM0wraEc4S3F5MEN5RzhyUnp3QmZYcEZGOFVsM3p3R2gzOEhwOFJDOGxW?=
 =?utf-8?B?MUxFblpWKzhrdmJFbDIxRVZReUd2QU8vaXlKaTRWbXhqRjB4Y3ArckV3OXdG?=
 =?utf-8?B?SEJuRzB5WU1GQVNac1cwRkMyZURCRkpyYTBhOFdrRllLeDhmRWtCam9ZMkVz?=
 =?utf-8?B?SENua0tlMGdtVXBsZU1jenIrM0Q0Q3Z0ZkZpVE02b21ubXV0L1FYQWZJTklS?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TpcSrtplmzo1WN5pKGuVQS6zsP7jEpPAAehJcrX1rqb/+fjWqvcOmS4OfJdONRsaQTVQgeVw1afUlfte6yPxErs/LGleQ0D1KOjwdIYTf5Kr3JyUNW67UOW6WWGqEBCFcrq/fd7ngFT9hfqauNi3gxZtjvp3O+2+FARWAbd5ksxfvUlc125XsfrjYYMO3XOmi+L74IOWANZl6/Eo3/23dwQ5ClyxkORENKOtqtOGx9L6DaXsaXlTh69LykH2tAB3RQ3DPpyLkqkQb+CFo3PBviIHUf1CMuIey0pnyacRkdP4mcXKh9hf5oyg+RkpJsunIsaKZdE1nh6fQfPc59ByMCgiPrP6UTv5aeRDLE/DTuKdCB6zOj2qyuVCqbp5uWF8DYoe36YrmFtJr5+pQOvlbeS7k6Q3wRmjlHxq2rbzv2Mbe+tDtRbssNazsmB3ZdFS4glQXxKPoRcfFR1yn3B2v0GkhjpoPrVpTDT4mer1OOA7oeu5924XP+PB3Sd3Whc1EVnLCrNbIWM7KoTovQYIyOeh0Hiz0yYG5kcIrVcrQ/W9PwlO30KKgWjerWdqxMovwIYtiDlcLs940+3EXQuRzgq4q8S3l+RfKlhN9Uy7JAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9f10ae-389a-4f02-24a5-08dde62f5b2e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 12:35:22.4693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YN7nlU5fUx3fhQLI7u3ipC+cavQGy7VeWGGtZzaNBjz5WRtEa7pfB7vNSOZan/68hGY39x9M+iUx7njbgVECzeFq6cze0M9os6TWdffHML0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4635
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280105
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX/k/F2ni4xJMq
 haxHjb3o8/7XQyBInIqykGqHN30WWyuIRKJrH/SjJZKfWo2yygsciaYnOBrOEXFusDa+r1MYYno
 V72tFfnO1ncc1JA2MKcGV3q9eChJfUNKmC2KPbx/V2OAO3OK1zhhBpniSriOI3b098Vr8NcYfik
 kVMya2p36hehlWKPXnnX2VfxESBdK7E6qgNmamw+HxgSUQhCDEYNbxzbzJcnXmEhh8mOgRph6ku
 4nBBvw1wFLmgx+3V5o4A6TeeULnvC69WD2APHTZGGUhfrCWn2P5poYJdE4nC5xXksD+MXRHlub5
 PSAtEPpy4gjItOiAwj6EVEsmn4XDf3cNeN2xqbpsddrWNmqiLhHMOFK5JPp0AviW/f6S9UIjNAN
 jxuzO+SD
X-Proofpoint-ORIG-GUID: miy4BDtIYv1cLMHHJCVOhZdoKQmHYJih
X-Proofpoint-GUID: miy4BDtIYv1cLMHHJCVOhZdoKQmHYJih
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b04d17 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=_scuRt6ZxZSSl4byhWYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C93BDC000B
X-Stat-Signature: xxzbfot3g7xui5bdd7rmsk9ht7i3rh7a
X-HE-Tag: 1756384541-357360
X-HE-Meta: U2FsdGVkX1/Nh7pVsUnTi9wXXfa7m1P5oNrRVEUryuACOtvjKCsqKrcUAJJ3UlkCeVg84xUt63OkKbZH4SbsT930DSfY/a24W0j3ZBuKIfFPh4Tf7zu4HVInbbOad3s0qWlbcdqNe802yy3jCvhLwja0z5VwHzyOqsgUUjWz3gUfR4R0CMaFgDn1gVyj2PReHYR4nF259dFW9sPmA/ytsbkJnicMNwIB0JFmAMF0jJaxf+uudHQCBYeAJy2zqx+n1alEK2Lv3fMZKPpuA88FFjLDRBfX78DO+ppwSsRVsmLMz+i2jt8TMKQ6vnETAlpwC367lfqw706SX3zERXPpI3I/HwqEzfDbofJLUTKhyLpZzITmr03y9sqrpJ/xPuDrbjCW1AQR9mfXCBIJkY69A6EX2BMAQByjILOeSJSO1jpl3MePGwWxRGsJYReu3YOPO108QOajjT5GPpPba5iqOfdMcpEYdz/Jo0QdKEMDEepfVs3NDSxxfjWlKfx7PTDt7+Z3E2BQMkK4e9s1ttCqH1ntT1GOrNORY3oBWmPLu4GtUEbi5CBLhxa+/nR2R1eujuQKX8++Mw9BUAyUQ0G6z8WgVDoWi1o9y46F/An899rUbgVcHulj3ZzolfWixm6IXJjL1HjCgOZsdMGNYUHmncbZuR7gi67LFQjQdZGfiyUei+dLy8LQGr57w97b6o/nJNv3ZMVO2UFS3XFeMrCtuXSBPL087hSk/JK6Lr/boz/RY8L0RJ48YEmFKpLyrAUnTk+yQOgeJ6q2d4Ozo7A5plJPM8LwE8iJeA1KxZvC4vOVn0iy7Jjqq+Tr8DK0h4kaobsDxP8i0teAfqSs1xhUkZk2spQFBN614B+voUT7Qc2t51RQYDA6UuQMQxt0oxr7uEkDDn8pjpV0Llzu2g4bqbycPee8mpanQEyT0JF1tMCzIWUEs7I1+nF6qNAkYU7rJhAQ7XXPLviiErn7xTS
 /DYi1vE7
 rADR3MoLSea2XO5cGDPOkbIgq4mHflT7UJ+KJxGkBcYxDJEI63Bue6clCDqPScX9gkd9dnBi4zKSLnke3j7AJvNt6dFx9cWHT6SeLWR2/emxtGmniD6P+twd25EeQ2etrSFgvNEZlT+MF9hR2rb8ku7qn/DV+JJrp2j0MtNhd9VcEXRyXw08zR+eRZcATogAQXoLT1yAXx+JZmPS6HRB7koDBuYGbln8CKCWD8J4IpviLYy6eVyL6gWIFtNX40dWZsHrkjT3QVDjTL5aerqW0dU7tPRcMuG8F3bPefO46kTxwEROXrk4XGHJ3+WLjxo2TRHrTVur804W+8t9b8gDeZC7h9Xd+2MvwV1W1lyqVWK6vmpr0I3f4LF5iB3ARPWPWQTpgUuf+bC6g83ZF/YWIp59FL7DwWom6qAmznL1Bokv1YzPFsWE9Iv/SqerO4+n5PS//9VN51QQP4gxuTe4DG1+R0knkUOeI4xjGcfLvX0EBuB2I6g3yM0jIGjzOQ3fMI8mNPigbr39ggdppm4pbvt7glYQUlNro8fkTP4tnrQICvheqmirriCIp75DB/o/qQwA51hBswGU91sP3YODfthMOlPpFmcpnw09tqojSZGnBP2SD7Igi6MpksIj4fE229rtwe6eIkyrFz7+CbzmKIV/IIy8uadABJLtLtMJ1wo4fj4nTWA6nSExnbX5Dn4swv8ZimeXf5Ztdmf8gZcinEsTl5Uk+F0a0AT3Rfkc7n6R2bGP13HFxRSflsmRQHTvx6Umq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 02:16:42PM +0200, Max Kellermann wrote:
> On Thu, Aug 28, 2025 at 2:09 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>
> > > I'd actually be in favor of making all incoming args const (C should
> > > have made this the default).
> > >
> > > Because modifying an incoming arg is just obnoxious.  That value should
> > > be viewed as part of the calling environment and should not be altered.
> > >
> > > Try modifying a lengthy function and wanting to get at an incoming arg
> > > only to find that something in the preceding 100 lines has gone and
> > > messed with it.  Or forget to check fr this and get a nasty surprise when
> > > testing.
> > >
> > > Not that I'm suggesting that someone go in and make this change.
> > >
> > > On the other hand, it would be neat if gcc had an option to warn when
> > > someone does this.  I bet it would be simple to add.
> >
> > This would break half the world, I've tried making parameters const, then
> > finding basically every helper function doesn't function correctly with it
> > + having to give up without needing to change half the code base.
>
> Are you guys talking about making parameter values const (i.e. pointer
> addresses if the parameter is a pointer) or making pointed-to values
> const?
> It seemed Andrew meant the former, but my patch was about the latter.
>
> Yes, making parameters (not pointed-to values) const by default would
> be a good default, but we're 50 years late for that, and
> unfortunately, C's syntax for pointers with constant address is
> awkwardly confusing. But adding "const" to parameter (values, not
> pointed-to) should not break anything (unless the function really
> changes parameter values - there may be good or bad reasons to do
> that).
>
> Making more pointed-to values const will break a lot, yes, because
> this needs const-correctness in the whole callee space. This patch
> here tries to do this for a low-level part of the kernel, to enable it
> in higher-level parts. Long way to go.
>
> Max

I'm talking about const parameter values.

I gave a more full reply in general to this at top-level.

