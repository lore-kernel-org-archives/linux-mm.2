Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB818EF99C2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D675F6B0005; Fri, 13 Feb 2026 12:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA686B0088; Fri, 13 Feb 2026 12:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69836B008A; Fri, 13 Feb 2026 12:53:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C14B6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:53:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B3BC1C601
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:53:46 +0000 (UTC)
X-FDA: 84440181252.25.F353FEE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 93D2012000B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:53:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=awHhtXjL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dOTxjkaY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771005222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1q4E47OxaluzU6PO0XYvirSbsfYuZCaFNAe6drR1KPo=;
	b=yd8qkIh8F1t1eDsbM0IzeucdejPp1pa0e++SSYrwrYfy+h532ngfutJQFwsvubljk6Qjjw
	GMDyU1vzP0pS1C1A4gN+P8ni9ywlQPc4Xpsfxkc+oYB/mMb4l3yxN6Zut5DVb1aQr4+Tng
	pGv3pfnk/a8YluCBO0LU2kyI573zy1g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771005222; a=rsa-sha256;
	cv=pass;
	b=Vy7EzDUsnr5myu+gbmGzvQ2sy9gHMLVdHp092ymVWW9MCtGI5y3vZM6SnGBzYDGYfwGGFY
	Vpr8BrVTF/bNtGx+7XWsIVLlzP6AmXCv1UkzFV+n5vG0f13q28gUWVKZjKxTDFXiu2YVCr
	B76oSN/ldylAC2xr4nMXZfjNrnumxDA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=awHhtXjL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dOTxjkaY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61DDbUor3345584;
	Fri, 13 Feb 2026 17:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1q4E47OxaluzU6PO0XYvirSbsfYuZCaFNAe6drR1KPo=; b=
	awHhtXjLMmGCLBrnGF00AXW2ueVsdhjpBa6zhQK2YniYdKBVMkvh8WyfSuPkRPd+
	wLe/4LQGx2HOHLRpMhNAjKMCMYCaP6DkLoPyuaWr7IeHlmdD0CuZuYRlTKzLjWWV
	ifxsxcU5Pe24yDcvVnEs6f3B9z/ctc6G5Sn3X1M1hk7drKSg0a9NZ0bFbJC4b3JF
	LpU2j1Pm3LrGDqiA2BQpRIeCL5H84VmH1/Sq+jfQEb9SgFfV+Ky+6UDtpeiua8gE
	Siaftuizz8EEHsb5Y8/0JL0S/BGOt6qgsJWSbMhyc0nd0pACTdO7HiKMfC0PYWbN
	wYyCzJIdgzN4Kuqg4hAiNQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7s7ry0ye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 17:53:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61DG9Vic033130;
	Fri, 13 Feb 2026 17:53:39 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010034.outbound.protection.outlook.com [52.101.201.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c825y4jrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 17:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UC7VQ93Y+3WEwqhmcz4oy2XoT5vpEQCRAl1utD5zub8rf5r5f4efoIBIPC4LmRVOkgjqANdj72iRhLwvFWAwkY20HkhukPTfPp9GI0VNTy9NV5KKNTp+dzC96AVyPxDDUkwUi1vIxfxkZf3vZY/VOUJ3GWmCrbRoDQwA3AqseDxZcYRGVYO7MRMXNuN+dxrppM7bcyMNUuOEun2OMf7aHyzTVQ9xSByew5KC4JxMF5mhzmVKezBs8Yt83fxfANRlhn6+sblUVrvFUtB2/vSYWxbUVxfFtffld4Bk9jR9KbG8pmouYQcwAHkF8UocpypTVrtNif/EmeMA+VKrOSLymA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1q4E47OxaluzU6PO0XYvirSbsfYuZCaFNAe6drR1KPo=;
 b=JqVoObC9Y/61u9KNQ8OAmvq5Zt1hiIuSHOo5R/Wp+gJGN/tQ5T54/+9WUlWGLdnCeoiJ/bNrf6QkT0Eg7RcFU5mlm3XZZP5uKlci98Ak2qaOQYh0xgNEiJAEAWOaARsg1AxGuB+R1PNVmidRP1hv6VT9E4wUtlSSToLyl4NOjt5tI8Wmg7Uq15prQJaqL+wDAQcZahAPGM3AG7WGQ3Lp9cRj2XmhENIIG0mM+0TMpFNd2i1AhRwusgGg0xANbiwGN+iPsfh7inXyRlI88evfqLX+ox/zaEsLk/sLzY1w8o+4IKP5KGf1rkxkwxnZSPmGaRRlthewDcKXA/Z9M+dWSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1q4E47OxaluzU6PO0XYvirSbsfYuZCaFNAe6drR1KPo=;
 b=dOTxjkaYLi3XfSYfNpKhRi8wUAvSTN3nbN0n7/WEp3HYku1IdtTiZ4MHKg51IZTqkSoTYE7DuleIirPlJxH39mbpSsiiBvdg+xUXT6XNv7cUGe5KyqHGxn3Ln3AVKJpOO32/aO6kT3NoPxKYjZ2zONyEUwU0KOsOUjce9OgUX0c=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH0PR10MB5081.namprd10.prod.outlook.com (2603:10b6:610:c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 17:53:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 17:53:36 +0000
Date: Fri, 13 Feb 2026 12:53:33 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in mas_walk
Message-ID: <tny76q4g6yvmc57feuphsrfnz65s7be3yrvj4x5xgjc7nxyhag@nsx7eu6ljudj>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
References: <698e287a.a70a0220.2c38d7.009f.GAE@google.com>
 <muuhcv22gzsr2a3g4lsu4zqsjkdbjqxn7bszh7r4nuqgq2oc5a@7jqpwr6v2vez>
 <CAJuCfpFkHnmX_40RdjnWmicB46Miry6Bc6Lht2rfno0jopraUQ@mail.gmail.com>
 <6pj7qr6p2wcg5pbigqzbxikpyxw32zqaysepdzhggbvrd3rf3o@5nu3sf6wz6uf>
 <CAJuCfpEo-Lj1fetH5GtRX0q_jPP0c_VFgWgNBH3=pJ8Sza-8-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpEo-Lj1fetH5GtRX0q_jPP0c_VFgWgNBH3=pJ8Sza-8-Q@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0502.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH0PR10MB5081:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a103682-8d00-44fd-dbdb-08de6b28cfa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEJndVI3a2V1UVVza1RmeTVKZTdvT3gxTURtQkVCMWNxRE5qUUVTd2F3bXVV?=
 =?utf-8?B?MEViWkZ6a3pNNzdsMEJ4cE9iRlhuTkRvR2Z4azlLelp3V2VxL3hqcUZ4TTlq?=
 =?utf-8?B?TTBaZHpkdGgrblVzclpwbVR0ZDZsRlAydGZLejFUdythR1B0RlJSM3NJU2ZU?=
 =?utf-8?B?cnFkTXpYbWJxZHF2cm5ZemRvNE1ydmVkMDBKVG95RlpDU3VCZDNyUUF5NXF1?=
 =?utf-8?B?enVvOXJGdHhCN0lSeE1ZT2xhdUZlWFFGem11RHJGMk9DVEwwTUJQSjM4U29q?=
 =?utf-8?B?MEdrdXN1a29pUmxWbm51TG10T1pFZFRBY3hZVEQwRkswNE84Mi9DYmRPM1dh?=
 =?utf-8?B?RzBIRGFlcUpSbFgvUnoyang5SkdsS2gvaE9ubVlOanp3U2dlRmV4OEhwbUtK?=
 =?utf-8?B?OSs2L2h6YmEzbHVobUZQOTNOTUJpNFZBeXpNN0xhM0w1dDEydlp0TlhNT1Jw?=
 =?utf-8?B?WjN5OCtqYTRvUnFnbUo4Rm43eHpHcXFxZjYvcm1nUkVHMUtuNC9ZKzFUbnhG?=
 =?utf-8?B?VTRXSE40bG5laWxBVU4vby9nMmM2ZFl2MmhTSFNEc0Y2TmlHTndpY1p6alAz?=
 =?utf-8?B?UzhpRTc4c1RNdDVMY2lSdXgzdWFVVSt4WnVZTGZKQzZhaTd0dTVXRU5uY3p4?=
 =?utf-8?B?TmFoekJaQmxONFcxRFJEL0NBNVRxTDR4ejZybWlRTVNlZFNRdnJlMnBocmU5?=
 =?utf-8?B?L1ZBeWQ3ck1aaEVVbGVEQXQzU3hjYlNDdGZ1RGxWTDdQTTRHWDBtVG1HZ1pH?=
 =?utf-8?B?QlhQNGRHUzNLdWNENzRtaUZ6U3hpRVhiWmJtcEpPU0R1UkVIUnlDZExvanZh?=
 =?utf-8?B?dERwQ2dlbmVPMlpLY0NBSENPZGgva0dEM3V6QjQ3UUR2b01oMzhwMmhUUkM0?=
 =?utf-8?B?YWJGRDFwTDJvM2lqUkhESDNzeTM4V1JPK01tcTlwajZRc3E5U21ZbDBrUnhG?=
 =?utf-8?B?ZnhZNFVlQS9qZFRnMXdzRlNrUDdXeHBBNGQ4UHMyaENrOGZFOW01TEFyb1Jw?=
 =?utf-8?B?UW1MYmFDZEtyalV6UXUxOTIxNXpnVVVBY2xqckpDRDl1Q0kvSkIzUTZRVkE1?=
 =?utf-8?B?ZHJHdGFvWnFsbFlWZWo2blVvaHJremVQUHhqaUFpUnMwbFJmQ3pFVDRHWW9H?=
 =?utf-8?B?bWdwU3gyNks2b3c2OVdnd0FhL3VnNCt0U3dkR3NVSkRoSmFjMXRuZjFHR0xM?=
 =?utf-8?B?ckxTM2FkSlZSUnJTQ0lDRWxXMkJOVnRlZHJOUnpObWxueS9uaTNMOTlKWWli?=
 =?utf-8?B?d2Z4MkdsUDhaYUpTVG9mM1J2WGQzeWxhS2lyUVRBVDVSWFRtdG9rcmVkL0di?=
 =?utf-8?B?UUdOSS8yMkhOak9ZUUtLVjJDbW1TYkV3c2lyTlp5NmVzcGgzdDdYM2tOekMz?=
 =?utf-8?B?TzBTUVJ1dnk2WjhEVnBBcncraG5VNnVod0wwSWRxS0I0dXNURjY5SlZzbC8z?=
 =?utf-8?B?cDlGQk90TWJLRmt6UDZJemJYZWM5VFowTEl3M0FGbUlzbjNwKzNsQXFXcEcw?=
 =?utf-8?B?RWh0SmR3bm9ud2s2M2U1NDFkemNSTUM4QkNQcjFuU3lmK3JHTW5oWGdZZ0dz?=
 =?utf-8?B?dWEvcHBZZnJaUUFycjhIRXA0b2FFT2RCc2V3SjVkaXlkVzgyN2FkS1BtcVVm?=
 =?utf-8?B?U0g1M2dua3doakw1UEpiOWtLaWVWVUI1b1QxR0xpZGE3NkNnYlRqK3prbzhk?=
 =?utf-8?B?L0l2bSs3VFR6b0tLMGFIUXVpV2JqbEdhYUNZMnZsbHNyOExSZU9HZk1WNGxm?=
 =?utf-8?B?K1RJOTQvc3ZEb1Vpb01MbWsvZEUrSUR4MU1mRjltajJGZ09MSENpS0xlcEFU?=
 =?utf-8?B?ckJKcEl4OGlXMmlnK0hLVTgvM2k0Q3hRUGNLSFFrREZ0N2VObFdHMXozVG11?=
 =?utf-8?B?VmtTeEdRdVVRNG0rbDA0c0x5dWovRmw3YmZnV1FBR2VwM2haOS81U01DVGJ0?=
 =?utf-8?B?VEtOcUFzQU5RZ1AwbDlGZEh4ZzI2ODVCMWk4QUlUUEFLT0wyelZEUXhBeVdx?=
 =?utf-8?B?K0ZZbXJhYnAvVzIwdmE4Nm9uRzh5bHF1TGhuYVR5Zlc4MGVJVmgzbGh3UnFQ?=
 =?utf-8?Q?Zmj+RT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkFkU0lIcWVqWGNVZ0N1cGxhM1Ruc29iSkNrZVpRQVJWSkFUL1pSTnNJY0tx?=
 =?utf-8?B?citCSzZPcGZqMk1zNVJUSVlaR1NGV0w4ZlQxbmlvSGljR0RFeWZ2aHpkejR5?=
 =?utf-8?B?MFR0eGZCa3h1bEU5cWhkVmphL0RPVHdxYTVFZGlNY1M2dFhWdit3eEVBRVhV?=
 =?utf-8?B?U2VHb1ZsSXMydE5VRlJoQm9IeGlwNk5INkJaTkZFSXQybE95NkZ2RjdtN1dz?=
 =?utf-8?B?cnhMMVpXQktkUFF5V0c0Q28yWE9JTUdOZWNaVFgvKzRyWSswbFBJWUdpMEpv?=
 =?utf-8?B?WFg1S1pBUVZwM0gzU0ZiRUhtL0VUM2h4c0RqdnUyN2ZWcjBJeFpSRTlLMkkx?=
 =?utf-8?B?WmpPTWp0Y29JMHNsMVE4OFM4T04vd0ViZTdiTGFSMXBWOEljL0szZE9jSGsw?=
 =?utf-8?B?d01rbzcveW1nd0tVeGpvY0ZrREo4dDJUZ1VpMHVvcy92NWFGNWVrMkZCQnNl?=
 =?utf-8?B?RGR2TVhrUzM3VnZvOVZzUjgwUkljbTFHQ3hYTE9EYVhUblo3aFk5QjFZV0I5?=
 =?utf-8?B?MnhtdzQ0N2ZZS3ByZWo3bXRQWjFncGdCeHgzSDE4WGdQQk5ONEw0dE9Eb1lY?=
 =?utf-8?B?ank5U254cW93RVBCdnBaTnM0UFpraTJMeTRCdXRISm9HVHgxRUcvYVJ4d2Nh?=
 =?utf-8?B?ZFFQalYzUWh1bmdnOFM4WWd2OHBpdGgwcG9xOFpZejdZRndkdkVlUlVSVGMy?=
 =?utf-8?B?YWY2VVh1cXFKeGZQMDloa1lyWXMyQ3pFdjczQ2o5eFA2ck9vWXJXMVZRRFVX?=
 =?utf-8?B?NFQrZzRRTllBU2xCb1V5WnVqSFNpaTVOTkNrbmcwVDQ0Q1F6TnMxTW5zVDQz?=
 =?utf-8?B?RUV1NlR3L25zOElPOFZBaWpXQlpwUlFwYVJ5R3lDUmhLMm5pTGFPdld6RlFj?=
 =?utf-8?B?RUVSM2grdG9KSjNwUXhhak1MQkZsTC80dGdCZ1VrWDBQZ1hVQ2l4cHVsVW9J?=
 =?utf-8?B?VVBzSzJnOFN0enk1WUJ2d2gvci9Pb3NwWjU2WWpSU3IreVRzSDRwOHFoR2Vm?=
 =?utf-8?B?MnpVbEwzOElwRGpLanl6RlI3aUxjTVRzZnBBaHNjU0Z1L0l6SUpwNDNmVFVU?=
 =?utf-8?B?UFFZNEhTdXZwR29uNHBKZlZxN1E0ZzNBQldLalJHcEtjUUFWRWtZWG5sekln?=
 =?utf-8?B?aWg0b08vTWxzRDlBaXdNQWZwVnRSRkVyUXhlZ0FJVnpPQzYvL05IUkJXci80?=
 =?utf-8?B?b29MeUZSeHpkZm9XMUlaSi83OU9nVk41RFk5YTliTjBZMGhqRHR4UGhicTBo?=
 =?utf-8?B?N1hMZThpZHJIWklReUZrWHBjSmM3K05tU0pzZjk1d2Mwb053bFlwWjVMUUhm?=
 =?utf-8?B?eTlrQjg1RVBzL2NBSktGcVdOZUZiZzN1aXR4ZXR6VXZTS2RXUDFJaDM2UjV6?=
 =?utf-8?B?Rld1NHhSN0IrM2prRkY1S0dYMUQwK3NZV3B4N29oc3VnUFduQzJENlJpemUx?=
 =?utf-8?B?cDAxWG9vZ1M4eUNPdytLeDNGRDU5TFN4ZzRlZDc3UThKdndYcFplNVlZUHo4?=
 =?utf-8?B?b3JDZWY3d2kyMERIWFlqSEUvM0xWTWxxN0I5ZC8yMDBUenExL3RlUkllOXUx?=
 =?utf-8?B?NmFRWU1mMjdtTW9wbVpMY0JMNVMvUmxES1FqQ0p6UlpZcWFnRGtLcWFaaVA1?=
 =?utf-8?B?K0NiVmxVMFl2azYzM1YyWmgweGJLT2lIKy9lTk5abXNYRHBPMFhiK3ZjUGI2?=
 =?utf-8?B?UjlmalhUMVl3VjYrUFlqVDlNUG5HWjFLNGQ4NHpwd0VIMWtRbjhKNzhEVHJF?=
 =?utf-8?B?Mll4TTFQZnZ0YnBUbnRoOGN0eGRCMXd3dXFaS09SdzcvdkFxaC84VDhTRHZz?=
 =?utf-8?B?cWMvTXlkaENHQWxmRVlrN3BLcFExOGQ1b3pDeFNyTFhaS1FzT0R0ZGswRWpV?=
 =?utf-8?B?MVpMRzR3YVFsSlAvVGhPUWNSeWNHbnZ4MTJOYjFJakVxNFNnVkY3YWNqTUdv?=
 =?utf-8?B?RWdrMWFaWTJlOXhpdFNhVUNiK0dmQk5XSFV2TFA3eDlXc05FVzJCaXFNd2pL?=
 =?utf-8?B?dWVRN2d2TTBnclg4Vmszb01sQ1l6N2NaNTY5Ny9kRFgwdTR2bWtkUW5WMksv?=
 =?utf-8?B?TmJibnlOeTBCS3gzOHNBbG5TRU16Zjl5Q09iWGFUUTd3RTJDZ3VwdGF6ZURx?=
 =?utf-8?B?TjN5dFQvaVpJVEZFZWZPc3JjUXdINy9Cd05qY0pla2h4UTFid09FcWF2UVp0?=
 =?utf-8?B?TXNzemcrV1FVQmVTb2d5TUhhTWhpMmxPSmVvaFhjMUI0UDA5YjA4djZ6YnJ5?=
 =?utf-8?B?V09WKy9NeStNaHkybC9MNWJFZCs2OWI3b2Z0MUNLL0Z3Z2dVOVA5UXRCOFFq?=
 =?utf-8?B?QXg3UUY4ZGppYTY0cUloVXhEVlhVeHdmcStVTVBYN2d4ZE56VkJ1Zz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H1WXx3+RheCJl0YXD2+HK0qv51sVwSLe5w9AbzckdzWuuS+XXaKBr99eaLXfMWS6GlPqnC3FbCvfokO5NKcFsjskC/SmPu+LkRj/0M3dpcCixcUxHEBjDy/y4Td4bJUNQRzqpoo2QcVoXTIuAgHGLmPCM/R6OZUZvaTCVCFyy/oArWQWN9gOPamMG6QBvXwxGl/CxMSUgduh/sUrj54QYtaMOZZSzFC4D/5mjc47Nuzq+82Hmw3IKGpIOqfuYM71XnLHb9nQbHJtxwGiFwaGrBBqBpahz8JYvpVwgKDoHGeyCCXnGSoarNJ1LjFPIy6qDW7DjKRfHeRteftbdQPMHrPWxnrhgJArEW4ODLOVm8pSvrguqmHpNZ6Fquh8yb+l6H7FpSIl61UsK0aubK7B3PybP1Q840kgi8RH8Vuor4yFXSjqvcED5G++QpvvjUTmg20TwhcJc2loC1disHAhjjQzLZHGvNcyEMff5sAPvjTF5+FIR4XXEMAGaq+Mw9sn3zXuJuH4C5f8SHztT3+dyTmGdLiWsNm4DP555thNgU7xvtM2cU7DqozuvQPzyW7xAwxgHbAoT12H3+JdambGsAts3xmvb5pxm41UyiQtPRo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a103682-8d00-44fd-dbdb-08de6b28cfa8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 17:53:36.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUcsx1o6du7OGUccWjR/H81/8bdf/DfpXyYGZUiRpgi82EgpTRtXxq9FDRJ7rvcGypgynjoho6CH5T25/e8zkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5081
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_03,2026-02-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602130138
X-Authority-Analysis: v=2.4 cv=PZbyRyhd c=1 sm=1 tr=0 ts=698f6524 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=VwQbUJbxAAAA:8 a=QY18SFpNAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=naXMgVZUj2ZjqITv1AYA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=QEXdDO2ut3YA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 cc=ntf awl=host:12148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDEzNyBTYWx0ZWRfX9t2Jk9c9H1lG
 0JSXdGj75jjXPGJ9tHj8GgT2jR2z0zDB5iCt3xA9xN/sWyTvGzDcRpjNRb3VJ1A/idRzG1KfuTK
 cGRMxIh2/fKv6UTGOfqKyIdZzw3972wk1E9FrGqgOUkZPRMaj8RArSdlO8k4OU7+pAjgMYpG+BC
 YVXL7VDyTendbKTByYwRRcBFwkZGp6oPURdkHMjp4EfxNdqmhWvbX+H8w2GW9s+3Hd+oop8pSL/
 JdRYvy9NbEFuJTcWiAY49AKBs2qS8c8nBxWkgyiqjAcFJ78mlWKHQCFMSICFJOtnSJpZDbGZPV2
 0l4lxtQFFak2I7K00I+FrsMqq+lPFFyZn+Pwg8ZpRpo86ZjVsQ5wdQBrrDHMx3V+ntLuqrB8/W0
 8pDrJRcZMHh9c9M4kWjvO4nJMl+mvKeCvJ5Oe9TDZk0WtEL9QQ61dPxtyHjML5PuZpnRS3pyODG
 ZGvXucwrS0BK+OrvxwDFmYTzfLGhGuLTjaEXX0Oo=
X-Proofpoint-ORIG-GUID: asSoqXSkax7bs_2XEsvkPbORX27vpHFf
X-Proofpoint-GUID: asSoqXSkax7bs_2XEsvkPbORX27vpHFf
X-Rspamd-Queue-Id: 93D2012000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: w73jecdc4mdmheru496trr35i5hgmbx1
X-HE-Tag: 1771005222-962850
X-HE-Meta: U2FsdGVkX19Shcdk3dr/FgBu0bfSWG8oV9WCKI9R6p209VRDOKGvQizvF5J2d0ayYSQ6RoSf6aV4n7i8oI9JOUZWEQj2e0+w+XU18DHsrg9NwNAGphZ1q1pw916DMsmj+vJUNAK1P1y0IiIYx+9CLM/oK/Y4DKfHvMnUFcH8YyjgyaSPj9aqCBOr1Mf0uL84yrxLNbZsTJlKZ3lpNoeRkE0iZGv4xnzfMO7jiWSWwRSK7U5C5D7b0lmATwhXgk7ChIGgruWJScDTYj6gOMoHl9gmJD5ilaoNxsHzsPEOhKQhE0N3+qlG4B6WAY90j7Rvy9JMRmmAhwHYME+jY0phVbt5BRSdpntdg9xqlEV/FmfVpzMHWqr1BY4zD9Hy1L+jwSeWQgSAjgJY+vqm7WTHQo1SR9IYDfj+FICfHeVXhbyR0kAPjxOrGtNnX/JaoDu3ZBPo8a20xyiAP3reQsxQ7Gt75VXTcn+OOv/iQnWT+IjoIfOTskWOgvqrI/DUHjMw5EUy8XNiNkte+1ihYl3f/iDPeG5H6k8qZoHaJSxp8uFmfGTgkya2SIooSKV8XKabU46oCeYyA0wLn4/c0HgnVlSehyPrehxyMO+XaYPMP4vvRwqaCTdJ+bDjNENh0tauOdm//viuH9ZGFyFppXozYnu/urefhVKsyECPocIQwS/W9K0ixfeIZarI8x+2WZNUvhdZbHXydi9RhVjp6kKb/ioDZnBrI2iXpHLPr9ZxOpRy3uvot58qKjxng/6NPqilgB3RRWmN4OYW2KgVL+81kfm3jd3CQCk/Q9dbeTyEZ/EkceECRZLPG0xkXiM+e7j0OB8YN8xjXX+Rt/83Ot3jnF6MaSAQlFMh477Sm8TVI2FrgqW7hSwgRHA6gPv+EVpFzhVYCrqL+IhE7ICpmkj3dgjKcvLtLg+1I8mxRRB1W+AauVJJ2wOIgWXvZSLxSgMflFD2KM06IDObY4WP/Ie
 o5pTggg3
 mtcUfHuKhBPw0kpwjka7JLvraCGoEGzSOCWVOggHmeULCCUf6oG1zQR7paesw3CNMcw/GtfuQWqnokfK45nUSCsYBFD9uobi+PfQZet2gckgYHfR1suAoom3qpOyQuLYKPoyMd69DG0AlLMCKIVrvhWhBueDWaqkVO0VT9BjiF+Fklyxuz7CIREmuQFBHipeY+BOC9m+BosXLqNZ71L8chR2D6XXSyZfDf3hkL5sYYHgFqg+ON5GpmZAQ9qGvaw56rboaBQcd0lz2UutNBZeiZaztuXucp1j3xzjjgHPJq85f7Xw+ZNvhhgvVV+N3GWAyLdR8Gq72TkItXq9TxRLJ2w0NFhtYNPyP9hkdfwPUsbKlKoPyGGZ9PL6y9zEOxab11vK6dE42KfXp24+p6XLjoxJr7/0xZFrqJ2OkHC8kEAakllg+a2Sefx7eBorwApOfr1eMhsI2VN8HhvWZ5VIcY+LT7vM/06zM4YU+AIggzMpLaFsO8zys8vDNZLtIArdxvETeJi/T9fsUb/CoxJ2NiAQp5bqrDvyKMWvBGCudB7CnbpxIwSrUpMrmAI8+EM7c668q7iqt1SRJyDf1NFyJldM2NL8/2OWbXDbZZcTRBwYKGyK/Jbua8nd1AygC5ZG4f7fugDIWB4//WVcDYB/V8DunsUdlifTgfPRZUgjbe2SHw0DYWtjmHmUhjzT3sDG2zWAUOSaAZ167mRj2S3c9JWLuQplE4NXTw+TnIkv/L64pn2avBZigbEY7CgQkmqN7owdYaE6SD/OoJu/JdehhQQQ411qc1Ohui0a/nbDJJR0u6kw5wlOhwzXo3FWPkiMUfcEpz+KdlBg29fmlvDCG7bpzwoMwGpgfv19EzoRbgAPhlMiMfWu0/b8rF7qLRL860Q/4t91SP1F2JAPG0PzF50RALx0T+jfp/Mc1YNbb7v1388FKumUjf+ed/mAssD8wY5N1uFIbNEPLDCbzifLMB5gj71Gp
 TucN2+ZV
 mKITYtngsNsF1TQfBYKbYb9dGLnHfjS+C+FDs4DnS3Am+ouHk5wwq+qJoYqtba9HtB0JV5wP7KZzNz+mWqCRhjp2a3Ls+09WTCdfT4L54x5bkNAgdnLNLKoPV8Ltp34Iko44RzBnwBRFnww9sfpuSkhp3l9ACurZHxzgJp6w6O5jD+vR2O6muN8FEyFHSQ/8h0b+yvckyfwusZRplDJMrdeWGCm361V+cYh9owDBeR/DG6VzFU1w5DLeOHIQcu2ar/f5+ii4cIP0JvBZVE/1KvOhSg5C01Y5N9FU2i5cfQ5pLSl+L9cdt0zidS9AeZq3IsO3ika3iBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [260213 01:00]:
> On Fri, Feb 13, 2026 at 2:53=E2=80=AFAM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > * Suren Baghdasaryan <surenb@google.com> [260212 16:31]:
> > > On Thu, Feb 12, 2026 at 12:56=E2=80=AFPM Liam R. Howlett
> > > <Liam.Howlett@oracle.com> wrote:
> > > >
> > > > * syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com> [2=
60212 14:22]:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    192c0159402e Merge tag 'powerpc-7.0-1' of git://g=
it.kernel..
> > > > > git tree:       upstream
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1304c=
c02580000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Daaa1d=
655bee4457b
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D54245a2=
37762e7cbecf0
> > > > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binuti=
ls for Debian) 2.44
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13d=
40ffa580000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1704c=
c02580000
> > > > >
> > > > > Downloadable assets:
> > > > > disk image: https://storage.googleapis.com/syzbot-assets/a4215071=
8371/disk-192c0159.raw.xz
> > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/4cda72c184d=
0/vmlinux-192c0159.xz
> > > > > kernel image: https://storage.googleapis.com/syzbot-assets/404b09=
fd74ca/bzImage-192c0159.xz
> > > > >
> > > > > IMPORTANT: if you fix the issue, please add the following tag to =
the commit:
> > > > > Reported-by: syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.co=
m
> > > >
> > > > This looks like the mm is not reference counted correctly.
> > > >
> > > > The maple tree has been destroyed via exit_mmap() while
> > > > do_user_addr_fault() is executing.
> > > >
> > > > >
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > BUG: KASAN: slab-use-after-free in ma_dead_node lib/maple_tree.c:=
572 [inline]
> > > > > BUG: KASAN: slab-use-after-free in mte_dead_node lib/maple_tree.c=
:587 [inline]
> > > > > BUG: KASAN: slab-use-after-free in mas_start lib/maple_tree.c:120=
7 [inline]
> > > >
> > > > This shows it is the root node that is incorrect (which is stored i=
n the
> > > > mm_struct directly).
> > > >
> > > > > BUG: KASAN: slab-use-after-free in mas_state_walk lib/maple_tree.=
c:3291 [inline]
> > > > > BUG: KASAN: slab-use-after-free in mas_walk+0x8cf/0x9b0 lib/maple=
_tree.c:4599
> > > > > Read of size 8 at addr ffff888078907400 by task syz.0.18/6008
> > > > >
> > > > > CPU: 0 UID: 0 PID: 6008 Comm: syz.0.18 Not tainted syzkaller #0 P=
REEMPT(full)
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine=
, BIOS Google 01/24/2026
> > > > > Call Trace:
> > > > >  <TASK>
> > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> > > > >  print_address_description mm/kasan/report.c:378 [inline]
> > > > >  print_report+0x156/0x4c9 mm/kasan/report.c:482
> > > > >  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
> > > > >  ma_dead_node lib/maple_tree.c:572 [inline]
> > > > >  mte_dead_node lib/maple_tree.c:587 [inline]
> > > > >  mas_start lib/maple_tree.c:1207 [inline]
> > > > >  mas_state_walk lib/maple_tree.c:3291 [inline]
> > > > >  mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
> > > > >  lock_vma_under_rcu+0x101/0x5a0 mm/mmap_lock.c:253
> > > > >  do_user_addr_fault+0x41f/0x12f0 arch/x86/mm/fault.c:1325
> > > >
> > > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > >
> > > > >  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> > > > >  exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
> > > > >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > > > > RIP: 0033:0x342000
> > > > > Code: Unable to access opcode bytes at 0x341fd6.
> > > > > RSP: 002b:000000000000000e EFLAGS: 00010246
> > > > > RAX: 0000000000000000 RBX: 00007ff2e4816090 RCX: 00007ff2e459bf79
> > > > > RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0002000020003b4a
> > > > > RBP: 00007ff2e46327e0 R08: 0000000000000103 R09: 0000000000000000
> > > > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > > > R13: 00007ff2e4816128 R14: 00007ff2e4816090 R15: 00007ffc4f622688
> > > > >  </TASK>
> > > > >
> > > > > Allocated by task 5934:
> > > > >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> > > > >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> > > > >  unpoison_slab_object mm/kasan/common.c:340 [inline]
> > > > >  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
> > > > >  kasan_slab_alloc include/linux/kasan.h:253 [inline]
> > > > >  slab_post_alloc_hook mm/slub.c:4953 [inline]
> > > > >  slab_alloc_node mm/slub.c:5263 [inline]
> > > > >  kmem_cache_alloc_noprof+0x2ad/0x780 mm/slub.c:5270
> > > > >  mt_alloc_one lib/maple_tree.c:174 [inline]
> > > > >  mas_dup_build lib/maple_tree.c:6299 [inline]
> > > > >  __mt_dup+0x5a8/0xc20 lib/maple_tree.c:6382
> > > > >  dup_mmap+0x36d/0x1e20 mm/mmap.c:1744
> > > > >  dup_mm kernel/fork.c:1530 [inline]
> > > > >  copy_mm kernel/fork.c:1582 [inline]
> > > > >  copy_process+0x7371/0x79b0 kernel/fork.c:2223
> > > > >  kernel_clone+0xfc/0x930 kernel/fork.c:2654
> > > > >  __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
> > > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > >  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
> > > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > >
> > > > > Freed by task 6003:
> > > > >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> > > > >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> > > > >  kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
> > > > >  poison_slab_object mm/kasan/common.c:253 [inline]
> > > > >  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
> > > > >  kasan_slab_free include/linux/kasan.h:235 [inline]
> > > > >  slab_free_hook mm/slub.c:2540 [inline]
> > > > >  slab_free mm/slub.c:6674 [inline]
> > > > >  kfree+0x1c7/0x690 mm/slub.c:6886
> > > > >  mt_destroy_walk+0xc0a/0xfa0 lib/maple_tree.c:5028
> > > > >  mte_destroy_walk lib/maple_tree.c:5049 [inline]
> > > > >  mte_destroy_walk lib/maple_tree.c:5040 [inline]
> > > > >  __mt_destroy+0x2d7/0x390 lib/maple_tree.c:6446
> > > >
> > > > __mt_destroy() is called with rcu disabled because the last mm_stru=
ct
> > > > user should be gone.
> > > >
> > > > exit_mmap() is only called when there are no mm users left, and the=
n the
> > > > mm is write locked before removing the rcu protection on the tree.
> > > >
> > > > It appears that somehow the fault has the mm without holding a refe=
rence
> > > > to it.
> > >
> > > I tried reproducing on my qemu with the same head commit, config and
> > > using C reproducer and it did not reproduce. I think the only
> > > difference I have is the GCC version I used. Mine is gcc (Debian
> > > 15.2.0-3) 15.2.0.
> > >
> >
> > I get futex issues before I see this issue - but it could be related.
> >
> > I was planning to add some debug tomorrow to see if I could figure it
> > out.
>=20
> Thanks Hillf!
> Makes sense. The reproduced does use PROCMAP_QUERY. The fix
> https://lore.kernel.org/all/20260212234050.03FC6C19421@smtp.kernel.org/
> did not reach Linus' tree yet.

Yes, thank you Hillf [1].

Happy to see it's already not a problem, and especially happy that I
don't need to dig deeper.

Cheers,
Liam

[1]. https://lore.kernel.org/all/20260213033815.3016-1-hdanton@sina.com/


