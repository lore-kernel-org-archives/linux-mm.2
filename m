Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7572DE6BF35
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 19:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB7E6B0088; Fri, 30 Jan 2026 14:29:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A94E6B0089; Fri, 30 Jan 2026 14:29:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435E76B008A; Fri, 30 Jan 2026 14:29:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33DB66B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:29:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0B6F8C246
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:29:19 +0000 (UTC)
X-FDA: 84389618838.02.C652457
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AB31C000A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:29:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=PJfrrVGd;
	spf=pass (imf28.hostedemail.com: domain of "prvs=049005ca1c=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=049005ca1c=clm@meta.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769801356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1zCH1hu1PPmRZCaV/iF4v3gtlyYvk71wFE77iuZbjQs=;
	b=fAMBjKnk64h34hovbfez7WJryY0mD2edtwU/vb4pD85bMe2nI08S4IRHkhsrd4spY0UdY2
	HhbWGZCzr9iXss4IjTlEcwwabQT7erh22YfN67iXYfVEaILOoX7mqnQG1gL7mtmPutkNIY
	Ypqm9tsEAXeTAdDDJx1S6tIBZDEgcoU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=PJfrrVGd;
	spf=pass (imf28.hostedemail.com: domain of "prvs=049005ca1c=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=049005ca1c=clm@meta.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769801356; a=rsa-sha256;
	cv=pass;
	b=IeAod0hvPmYeL9bpLWADWgqcocpWQX+E+sQ6x7J98Hb+4p3mkIANOpZ3gFhsEJ6VJ1UNej
	gLllOsWL07yM9ol/q3Cvo/890oZa/tMQtAip5YaL7LVgZG29tgFgOcEKbWm+z9fPTqNkar
	561FgSTO98XRQNUxd3iQ3N9QokfHrUY=
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UIgg5w3636197;
	Fri, 30 Jan 2026 11:29:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=1zCH1hu1PPmRZCaV/i
	F4v3gtlyYvk71wFE77iuZbjQs=; b=PJfrrVGd06aJ7coBMDXsT6Jb6v22/o4KcC
	ssqG0KSvwAn2VfLdzTdzcmZzvafM9boK2mqvk11lPk4Hv9IX8tpKDL80FCNQTUVr
	awGGmMJsfe5uHD9hC6luWQwuk81HoMcCHbD0j8cf8JcRMtGXmnuKoZq+uidtDpij
	frtCNhVph+v4o921zOhdNECVByYmtYbF4MpK/xlo6+Cd0bmxE+jb01M+qcYNaUiO
	DhftXkvQPLcjHumUY/taOPGQHDoWJ64kpZGhteI3TprabAsjq/AvrIwLti/aVIdi
	PyAeg/IJ8HddnOQU0XzSmSEDCmNWbfGm5fbfdhmBgMuYlcUSyWbA==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010071.outbound.protection.outlook.com [52.101.85.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c125mrhd0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 Jan 2026 11:29:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e/9qF64HTaQCMjID6MEcM/rAoao5RLhoIyRLZrhgiiVSL9Afvx8Sou+oZkiZALUb2SRTqqHjNWLuOdZgNXNemf8R8n8bXPfPmOw4ojs32EDgSbtiAfcbUD2em4ngrmQopP4letJcn00mVNR/ZESoGRaSgJsQIJte9kxPhskJtEFXsUpfu0RhOC2JCelzDFw0IRgHRwa2sbrt5St1Ay/WKHamvlk+9WFr/pqA2vxx3/3G3fPVLpnYfXMqxGp8DTZLWY7EC4IGGnrN8E8ZTGW507JYDszjBUvieUdR6TqzXkqvmE5+ehKGzTmWHFRpgUc36eOV6HwmcTrrFzW2So8iaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zCH1hu1PPmRZCaV/iF4v3gtlyYvk71wFE77iuZbjQs=;
 b=K8EKb/lba+ZF7iLt8CVAIoy+INz8eDNXbvLPmEHRNG3Ssc+1242noxl8luVeG6E8areA3nVFNZ6dkMdwZcrp2/SQVMbW+BkrY5Gh7n1FsmoURZHP4DutnTnkI+YP0remhXksl21yVCO3Xj6RNfReAMGWIYICfZ2888ktOMaiVYIS+FxqZldBMOVgKaIJ2SpFDxEtbJsUZ/CSMWlo0XrTjscaVYs7MmqiA18R48IfIlfo2aYVI6yuaUPyY6uIKYzkmmvJsM1JrY3cIlqbwP59JeDVbGRJTuMEm2HEv9KYs0Bcqcu8TYUPQRjjHbKuD72W15bgPh4OhQh+PS6HgUBTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV3PR15MB6455.namprd15.prod.outlook.com (2603:10b6:408:1ad::10)
 by DS4PR15MB7052.namprd15.prod.outlook.com (2603:10b6:8:2fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Fri, 30 Jan
 2026 19:29:13 +0000
Received: from LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::444a:f42c:1d70:40b5]) by LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::444a:f42c:1d70:40b5%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 19:29:13 +0000
Message-ID: <b187e0c1-1df8-4529-bfe4-0a1d65221adc@meta.com>
Date: Fri, 30 Jan 2026 14:29:04 -0500
User-Agent: Mozilla Thunderbird
To: bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm
 <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
From: Chris Mason <clm@meta.com>
Subject: [RFC] AI review prompt updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0002.namprd14.prod.outlook.com
 (2603:10b6:208:23e::7) To LV3PR15MB6455.namprd15.prod.outlook.com
 (2603:10b6:408:1ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR15MB6455:EE_|DS4PR15MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c33130a-529c-4143-7122-08de6035d981
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WW1XS1FpQWpYRXQ2ZUdSdFN0bzU5MG44TGYybGxGSG9mTm5ZOGorYVNEVTE4?=
 =?utf-8?B?SFVFSnk3RGlDQWErSGZBeTVtWXlldWErZWlSVTAyWDk4TW12ejBWMVQ2NEJC?=
 =?utf-8?B?T1k3SGx3OHQ2ZXFBUmZEamc3bWIrVmVubXVOVGI1dSt6dDNKU2hzQmRyT3VW?=
 =?utf-8?B?dUNFbDlFSnhTdyt0U0hlOXBzYXp1ekRPbkdzVmtpTWpyVG41dHh4REZVL2Ex?=
 =?utf-8?B?bWQwR3E5QngxTER6WFpxdk5ueUg4cFRsM2QzRmRhRnlLSHdZcE1xYlNQaDUr?=
 =?utf-8?B?bXJJYzNDMTcvdS9pZHQ3WFVBK2YyUEVZQjRxRHp5dDg1WkZncXlQaUp3emVl?=
 =?utf-8?B?UWZzblBLY3Q2amg0WXk5dmxMWVNveHpTRTJpUlBRbENIZjRnQ0s5SUc5NEVE?=
 =?utf-8?B?VWIrcFNSSFpGa3ZsU3d1Nlk1ejJrTTQyQUowRy8zTFBaRWJpTHZZcjFiYWR6?=
 =?utf-8?B?Tnd6emVFcVRhNDdVUFI0N0FsOElpRkx2VFhlYm94V3ZhVyt5L1U4aE5LNVI5?=
 =?utf-8?B?ZTVhU0ZwRk5hZVNiRkd4QlQ5azJuMThlc1FrQUc1SVVVVzlpdmEwRkMwQ1Az?=
 =?utf-8?B?ZjdlSXUvaEgxcEVJdDdGMkxXMjFSVzZGeWJRQ21rZnhBdUxpU0pHNzU1TXV6?=
 =?utf-8?B?ZGlIK2J0dXE5V3k0WHdxeDRPSWRaZ2RhcDlaODA5TG9PRmwzNGFoRjJpeTVT?=
 =?utf-8?B?R2V2LzRtQzI1UVE1a2lsVXJab2VBellYMnI3MnRNVGVoNjFVS2xMNGJLTFdn?=
 =?utf-8?B?RTliTVdVSXdGWmttR0czMUNHQjlKMC8yc3I2Q2ZHVmxxUDhSQWk3U0dMME9J?=
 =?utf-8?B?VFFvd3JrRVNiS0FoQmtqNkZ2SzZwRTVFakJRU3hzdThXbzFVaktmY3J0Nng5?=
 =?utf-8?B?dEZWTjlPUHdlbjBHeFltMjdjc2NzRC9DdzRHbXJLOWQ0ZkY3eUdKNHJwbTJX?=
 =?utf-8?B?cmhUbmNBb2REZXM2bUwraytrck4rdFFCSkhNRUVNZVBLbE4xbmJIRTIxU3Av?=
 =?utf-8?B?VVZKUml2a1hrdWYxMlN0UjRqTjNUNDIvTUhIQmJldGNIY1gyNmFzTlY3L2pB?=
 =?utf-8?B?MlZPWFhMcFB2bVpEY3plMURqY2NrUy92bWdJZVZqYnRDWHUrUWJUbUZhbjFz?=
 =?utf-8?B?ZTlFZUZNdGtkcW1aSzEzcXpqbllZZHdRL2JSa0NIK2o4SnRRNWdwME5iM2Jo?=
 =?utf-8?B?RVJpWDdNZjBFWUpZd3FIcjd0RnZyZUcvVXBKdTJVb0diQ0FoakxQZHMvdmVE?=
 =?utf-8?B?UVkwbm5JbGR0UGxweFZtM1k3T2hQdVM5bmFyNmV5MGh6UFhuWEVSTm5TdFll?=
 =?utf-8?B?OU1UYi8vUi9ucUJ2aW9ORnNCUWJVWkh1em9kekx2bjlGT1JGSnRFUFZxTkFZ?=
 =?utf-8?B?a1NVL2ZzWDFEb3ZFRkx3Z2loVnhhNGVoMjh1bXdnbEZJSVM4Mm9rV3plc3pU?=
 =?utf-8?B?Q3k1VGJEZ2t1dmd5MzBxSVdkSVRuanN2bnBMQ292RkZwQW1wVTJhZVR2V0Fy?=
 =?utf-8?B?aUhjejYwZEFrbWVaaE8vR1VvVVhoVEZIK01BVkcrZmFzTHFYQ0NuTXkvSUNC?=
 =?utf-8?B?dnkrc2M2MmhBYU5CbnVqNlBBU3ZJUnhqbjBERHo3TDFERVk5Vm0xTmY3ZnJu?=
 =?utf-8?B?bU1FY3VpenBQVExNb3RqWGY1Q2YxV2JaZHZJNU0wUzEwdTV5MVRhTDUycWZH?=
 =?utf-8?B?bkl2SW5oYXZKREI5NU1zTDFpaTFKS0dMZnphSVJpTTdaK2dlakJnOXRHL2VB?=
 =?utf-8?B?Y04yUWg0dlkrL01kT0srYStoVXMzVTNuWlNzTFdDUEU1RUNuTDBpcXVZOHBM?=
 =?utf-8?B?dzRiazJGZm9QSkJWZGFJdFF2bDRtUDByM2NFMEhEY0xCK1MwdE5VWTJ5L3pL?=
 =?utf-8?B?ZEpSekVoNHU4elpPLzZwbmg0MFRHNElRbVNSQW1UWjlEajFqV3hJbStSdFlw?=
 =?utf-8?B?c1RaQ0E0aUNkRkJueWQrRHR1OUphb1ZhZ0VOckZpUVdheTM1ZzBYZHEzcGMz?=
 =?utf-8?B?VU1LTExiVTRET3Q2RWdieEErTWtSOHRqWmwzeDA3d3pYUHJYSFIyVWoyVjBQ?=
 =?utf-8?B?bUpqMkY4SU5RRE1ZbVJtTVU4bVlFZUxCR3dJQU9XbU9Pa0ptYlFwM3pnY1VD?=
 =?utf-8?Q?hgOSWNMD77nGusIyJLgfrw8io?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR15MB6455.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjNWNnJ4cnFmUlJwUEo0eFlycGt3TVMxdGRWTVMyN0FmMGJCbW5KYjhPRlBM?=
 =?utf-8?B?Y3Q1UklXNWNjV0VzSjczTnMzQnBwalFIYjdkdTVvNEhhT0RLaTVLOCtuMG9m?=
 =?utf-8?B?ZEhZRWlPaTFQWkoydDl3YTR0WWdscmhaaW41RVNFZkExL1A4NFFKVENvS041?=
 =?utf-8?B?RnlUWXZQNnVMaUpYN3U5Z3F5T3RZcmxBQ2Ztc1JqbTViQ2s4MnJ2RFROU1Jo?=
 =?utf-8?B?dlMxNEFxanJZZnNWUllRZlJ5MU84YkhiZmVFTUMwNDRqSDJ1eEVUQ0lIRXpU?=
 =?utf-8?B?cVNTaHd5K3NtQXlJandiRk1WWVR0bTZWN0xXdlg3aXBydzJsZS9MTEZkdGpD?=
 =?utf-8?B?aFRpbmJXRVptbGE3QWxNY09IcjIxaWJRS0lKTlRnSWVpNWFaMFVORTVtWE1U?=
 =?utf-8?B?V1JmUFQyR29GUDg3Z1g3WnRCRmV5TFUzd2hJNjlPK1VZcDA5WEwrMnJjU2p5?=
 =?utf-8?B?dTVreDRiNG1qR2lteFJkZ3RrN2pWdXJzVHhqc3FndnVtbCszdDBRTkY5cWNT?=
 =?utf-8?B?ZUhUaGVCV2w2N1pyY1FBWTVHdGI1Y2lvdlVJOFRWcmxmWHkvWnhTMEhaOHVl?=
 =?utf-8?B?WjNXSjlNOUJsR2VEbDBDeFVVMDIyYlNoWHV1SGpLVGkyZnhFQVRlR0JsL3Np?=
 =?utf-8?B?VlE3NGEvcWtYZ0IwSjRkdElzWXBsZ0JaNGxMSXZCRUJFWjhWSkI4c05WTy9P?=
 =?utf-8?B?THZxMW4rRURJam9IY3ZRcWprUnhsTXNlNWhMZHZqdUdaUmUrT2syRzdIRGdL?=
 =?utf-8?B?TEM4QjE3bVFJSkp5Ly9Ta2NBVXRqZGFNQWw4VXlPZHdzdGNKUmo0UUh1WUhV?=
 =?utf-8?B?Q0JZZzFaSk5ObFQ1c1lOcSt1a1hCNUQxbk9seEx5elhFamozQ0U5enhTaHNz?=
 =?utf-8?B?cTVSaEpVYUlwaVI1cVFXcmZxQlRSTjhpamV5RUczakZ0SVVOTklraENXOEp3?=
 =?utf-8?B?UXpVZm5FTlZBVmlQWnFnSFJHdHV0NTg3V3ZGb1BqT29xbXdJL2ZHVDUvNFEx?=
 =?utf-8?B?T3NZQUFlS0RRN3BtMTR1d1ZOUks2eUdIMnVlYy9CNm9rY3hVbzJ4ZEFaSit2?=
 =?utf-8?B?clRtcE1FYXdaVGhsQmE3cjlWNVdudk1MMU9JNXljbm5WV0xIWUhWbU9rMkZP?=
 =?utf-8?B?c2tPQ0JxeC80RlBuUktVNkhBc2dNUDAxSzcrRzJhOVVQdXFFWlBJbHZybGlM?=
 =?utf-8?B?Q0ZxTW81NjJYU280M2FGS1lqMzV4WEZsb2N3K1Q2NkRBVFh5R0QzSUdWTFdE?=
 =?utf-8?B?TnJnL2dWdjFiblZPRXg3YTFMczJhVU9XbmVwUms0QU5CRTVscFl5OUdKMUwv?=
 =?utf-8?B?Y0FrZmZ3dEswT2x4bTZsOGN6citUSE5lbFUrcFd1bnNQc2VTN2hBS0xpNHdY?=
 =?utf-8?B?VEttS0s1d1BkUFN5Y3BEYWluN1FTOVZ2MnBYUXN3WTBVZ3Q4QTRRR3R4eSsx?=
 =?utf-8?B?TXRFY1piYjN3RC9pU1JzVk1iWUVQc2QvejdSTnIydFRZWTFJYXVYdE4rN1lS?=
 =?utf-8?B?WkRqUlpFQm9zSEtPOHEwZGNLamhVS0MyQ3hCVm9XZWw3RDJlakQ1U29vMUh1?=
 =?utf-8?B?SE1SU0R1SUVUSGh1Nnltd0RUdFRLdTJRbHhLSjFDMnFvTmkrRyttZlNiVXY4?=
 =?utf-8?B?K0pPTEIrcStNQ2VJSzN0ZkxIaHNKdjk5bWduZE5TdmgwWTFkQzdualpqdGIr?=
 =?utf-8?B?VCtZeCtzamRjRnJxdG9zbE14QzRvL1hJQkJWY2hmQ0VyK29DTVB5TGN5RFFT?=
 =?utf-8?B?UllFRXBzSTcrSFhjK1dHV0YzYlpVdkFSMkpxalBKa3J6RHhsNnIreFJFNThR?=
 =?utf-8?B?aDVOd3ZpZ3BhanY0bE05Mk8wMEpnZ2lxR1FwdjJ5ZHBVWlIrdERGbWlYa21K?=
 =?utf-8?B?TC9LejFjd1UxQy9hazFaZC9TUE1BT1pGV1JrTUQwa284cE5VTnQzRDdBZlZu?=
 =?utf-8?B?WjltRjRpTUtwTGowV3drWlBpMU4xQzBYRVlQOEFIaDhmeWYyREdyYUJhUVVS?=
 =?utf-8?B?WS9DNnEyakJCNG5SZTd4STNqNDJIdDhmOGdTSVlHYlJndDFqQ29nc2ZGdmhI?=
 =?utf-8?B?d3FvRG13OC9XY1ZRQk5USHRaTExkWkNsZmNKMys2OHVFcDkxN2NMdmxrSFBL?=
 =?utf-8?B?Szc5QlFFV0NEV05xZlQwbW13R0kwdkZ0dXYySTlTRkpzTTQ2bFBaUFNiQUJz?=
 =?utf-8?B?dzZubko5MlNUNVdCMG9OUElTSlJ0bGFjU3FrQmZBZjN6b1BpU1FJN0VGS09R?=
 =?utf-8?B?eGNUYkVLTHNKYlZQaU5pSmkvQVhJUTBBUzlrRlltVWo4cVlRaW91UHFkNnJX?=
 =?utf-8?Q?jkVHhes0portQUnWEX?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c33130a-529c-4143-7122-08de6035d981
X-MS-Exchange-CrossTenant-AuthSource: LV3PR15MB6455.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 19:29:13.3270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vT/2m5ViXI0oUugTsOaWlfhTcTkIMvndhCgP8pFbLYPRa6VnbkuZPDrVTznsdxts
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR15MB7052
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE2MCBTYWx0ZWRfX48Eoe7/coRah
 nri8CGCy65eGnDwwpiGY/o+jxcgamlzLYSn8rgdeHB+VmcXglqtL6QPLq3NRWGDTPMUu3EbrsQV
 ajm6H0l0N9Jp2dMZfCO0ts2W/7dP4dynPtVJe7CTE0EgR4JYOMTNHEKt1LJIYOl2uUIqJ52U6lG
 JUZ8EQUeo7sDrFGWJM9wLtEAbJOl8lllBhoGz9NIZKhmOiHV9VjHWKFl6m6XrG1Le5wG87EBAUk
 Enw6GTSsLrkTWq/HY8Miovuw/LxQzmEsFq4H88FjfNH5+7hHXMdzWEryzxkmbbmWjm0SnJlzPRY
 WHm6CgUn5OBDOg8XzrQlTadWlOASL1H2rWKDFDiI4s7v8zb88zC50t960ikSLWkCI3XmYG2SYv/
 T5VLkUguufKlDt+272GBvvtpias5zcAwSFqqj835rjvBvXA3gRrw6KiMJysAiK46JTKCg2kBE2h
 dAJaKgDEbsyZE51w6LQ==
X-Proofpoint-ORIG-GUID: mZDdvBg93yGwg6LEU_dvZKrRfAKPd-i7
X-Authority-Analysis: v=2.4 cv=ULTQ3Sfy c=1 sm=1 tr=0 ts=697d068b cx=c_pps
 a=OGRNNHJcR/XwrOfql3gobQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=20g8vh48bvThxKwI9eIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mZDdvBg93yGwg6LEU_dvZKrRfAKPd-i7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_02,2026-01-30_04,2025-10-01_01
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7AB31C000A
X-Stat-Signature: n77zerfpmgrcad8y3gsgz8t9c7uz998j
X-Rspam-User: 
X-HE-Tag: 1769801356-445855
X-HE-Meta: U2FsdGVkX1/Z6WfpQ1pkSintd4akRwN/a2bl0OEuCvBXV6WNkizY1v6/JMsydf+fCWojwX1xEXWQXsKeXuL5PkTBXdEAtJ2sCN+CiDOsBVX8xkS5ZwQTTfs8jxymxaAesHFwE+sRYu0Y4OBKlTd6+wqiWyP3W062ka8gpCpjFy+N7mvqQP/bAR9SdnCrkWup+pD+ArakKRL2pLL/4FAGobiIbWtKP+g1ddj5j2aQoz0dbr/HZPUYEhHEDWrdJm17NxrM12400vcj5z99W8TiI+9xIXh0rEI8ocqIl9otz9IGHeY1pcknhTyKDv8Tc1CSnuGQNkdwNlMZiNfEX9MRw2JK2DG4U51K7qKWOqVzmNQmBmQCDlLnDoWQTt1EhURT6C7JZIrWMKhCBYunM42viGRWFISknMmNGK/dm1xljuxFpft0rHq1S8L5gUSQnQC04jQTdCHHWnMvPTLgPyRfb1+Qh7ZlNJNVTS4CXUUVKZVP0DX74iATmoHjdGfy15B0+Icx1IPK13KTGSF4X6naqxyH3zrIxZddhD44aUbjzZCAnVg7IYIT38qRLOJ/eBTTODPB5a8g1qlm435Rg16CQm2utjLVr4Elj3/DMczf/Kg4GLpTMaZ9yrk2hq5uJUkC3fV7qW6UiY/Cqog30q66RvUKgiATzwcYhjhgbJ/aahugNZtD0lynIgkI3hWF3waLw2WSE4fy0pwsnMy4ev0luay6ivEIjxtDDlWx7slXcLqVF1CKZIDmw5Mt3/eUrHIi2ozHrt0h2vRHyshhHtO9DBYF0sZ8yCR/m/BrSp7bh2w6jMKFyqvLH8VkiPdGVaQ7NYdYnAeiGYnl9LTeSsnv6Z8zc4dnUNyx1B1PdDpmWZUS2Pj6I3X4FDXlVoQzROiS89EztzE7j0+bVGGMMPxSCg5JHV0MZGGYSZFun6JlfS3L8OOp7amnaovxRK+ghhAJk9GTGrO01AL6pezLJYK
 jjZVnG6K
 JDfzzTETQOiIBlqaDACtJyPc+vdyK5CfP3cZLqqudArI8CBOqnHIgQaOEdP6hjWcEpzYV9W/csdpiuKKuAVgTIaXEpUr72iGqH4QvecPLotsJnGpljTJ4hu+v2W0zFWrJ1a5mhb2niJBdR3kpYNdnlH9vUDMd7y75IzZwKynduXBPO7QWwf49wz71220ncY6b64fX53tX3C5rFc6kHWzXJE42rIG1alCyvq84R0wtNOYBaMm1GpTcGvZS2l7lpzHdedjIHCcSRNKAjpANXhEPssoEKyzilRowJSPXzHZ6veDgVzZLsi83pY8rB51S5jzo1aSWtfdsYNmHT82yOGCkmKcPtUxPgt/odhYfHs0O2rYpNhSqF14h5+bOBdtUMwdqcf6TWlzPHEF8w70oFkodMRJX1kvpgXXYqanNk9nFSgXqR2dpV0l0bslZci8ObB8Q6m4P8WodFXWryrXSi6MRF0HTaQ8/J2gcezwlc+QKT+CNCG76CB2YZ+jDKBSiB8ZsCoYvfy1J9iSZG3LA+GzHyVMW+mcFPabdZPyY8H3D3Dn4U1UgBc29iKwr3M0zCd428fpN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

If you haven't been playing with my AI review prompts locally, this
probably isn't relevant.

The prompts are: https://github.com/masoncl/review-prompts

For anyone that is using the prompts, I'm hoping to get some feedback on
changes I pushed today that break the review up into individual tasks.
The previous prompts are all still there, so we can directly compare the
two in terms of time, token cost, and effectiveness.

Using tasks allows us to break up large diffs into smaller chunks, and
review each chunk individually.  This ends up using fewer tokens a lot
of the time, because we're not sending context back and forth for the
entire diff with every turn.  It also catches more bugs all around.

I'm using a python script to break the changes up, and do bulk
processing to pull out modified functions, types, and call graphs.  This
also helps reduce token usage, we're just telling AI to load the
processed results in bulk instead of making it discover the same
information on its own.  It's probably buggy, I'm sure I'll have to
refine the python from here.

All those tokens saved hopefully helps make up for extra tokens spent.
Each task has its own context window, so research done while processing
one file in the diff has to be redone if another file in the diff needs
the same functions loaded.  AI providers cache tokens so it kind of
works out, but I'm looking for feedback on this part especially.

The new setup has tasks for:

- Reviewing chunks of code
- Checking past lore threads (if semcode is available)
- Checking Fixes: tags
- Deep dive into syzkaller fixes (more on that below)
- Making the final report

To use the old prompts:

cd some_linux_dir
claude> read the prompt <path to review-prompts>/kernel/review-core.md
and run it on the HEAD commit

To use the new prompts

cp kernel/scripts/create_changes.py somewhere in your PATH,
or run it by hand:

cd some_linux_dir
# the prompts will run create_changes.py if you don't
kernel/scripts/create_changes.py HEAD

claude> read the prompt <path to review-prompts>/kernel/agent/orc.md and
run it on the HEAD commit

I'm sure proper gemini support will need more changes in the prompts,
please feel free to send fixes/improvements.

re: syzkaller, the prompts focus on finding bugs in proposed changes,
but they don't try to decide if the thesis behind a patch is correct.
With syzkaller, it helps to have some extra rigor around making sure the
bug described is real.

So, any time a commit message mentions syzbot/syzkaller, it gets turn
through extra validation.  I'm sure this will need a lot of fine tuning,
but it does catch some good issues. (thanks to Johannes Weiner for the
suggestion!)

-chris


