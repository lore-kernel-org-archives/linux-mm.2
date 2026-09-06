Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD6EC79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 12:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526AA6B008C; Sun,  6 Sep 2026 08:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD4B6B0092; Sun,  6 Sep 2026 08:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4130B6B0095; Sun,  6 Sep 2026 08:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1066B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:48:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96A93160554
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 12:48:04 +0000 (UTC)
X-FDA: 85183314888.01.BC5EBDE
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020119.outbound.protection.outlook.com [52.101.196.119])
	by imf14.hostedemail.com (Postfix) with ESMTP id C13A4100003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 12:48:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=xhcVediM;
	spf=pass (imf14.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.119 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788698881;
	b=6YBxyp9ruzcMI0dy8Lqa5GSilYxQ/I4bU0uNrfldvJLyOH++WhZ3s/BvYjkR7VM6XbzJ6o
	n0bTq0Cp/PP8g081atcMhwqhcghSV9+/Xgz+EpGEFsxRibybcoBDWXnOjKoTNye8J5fIC5
	pV029soipdj18fEmehq6Jrci34vb0/4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=xhcVediM;
	spf=pass (imf14.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.119 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788698881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjxjpB+7oMNA7JHysv929t0fK53XSWaFOn2UbP+vDQs=;
	b=mOAT6iq/aU11qnM/dLwEcdyYsx31U//mkQ23jvDUgiVzgykFuz/LRSa6kGvFJTLs3jrDy8
	0Sf0rTfI86igZMgSUMVOsRFVDeQ/LZ52qGFawVkLXRD1mLWPawecej+79bKBXi1i/zJQIn
	tmz1OKsGTRi4NWNTRXiKzWrbvEue3+A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHjO9n29c7OXe5XFucmYx1OjnXuT8Bt6cXU3dS/kpZf3yJt4eDgw+yzdsIF418XUuzkVc9JhkDm+mHlqlYHg6iHKVnz5shXf5sxAylnip+mddFmCqoM6Hky/qtXwno90li1DWh6kQLPCWXTtIBDm7tnoTzlb9JlNvvhuxa9Zp5KytenvzByoQt77MCuGCHrfOnOUyLvVyJz898Oh+81evxPg6C/OBZfO7XmNvNcuFNQS591km3hmsjTR1EBtVPCVgIQ1lTsQibyNAFMzC5ACdN3Hb9pk4Jd/JxkChn1vUpwaPvQoVblLeNrAnv4DRaAP0AtN3w+ow3dsqrVT9vppdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjxjpB+7oMNA7JHysv929t0fK53XSWaFOn2UbP+vDQs=;
 b=cnE18gcTphfpIXHpdujSrtRFT8gAlEqVVuL3J88Q2Di3a/Y6Mbmu8IMu/azdqJVFOnlC+R+F77iibroPHh51Ss1nH0sKTDIZDlIn8B73H7d5vTN5yswMwhLAO0kFZt2+83JvLag9Pv3G05CMGu+QMSZdEeBeKCSX0VJGm6lD6lu3POzhi1bLzXn1BP0aznxjbS9d17InCDS6otemPYBfgewhIl1Ft+bzdJEYe1oh9Jhzt/EKMeLLW0JLSBlNypxh8HTpGkzugK5fgfViSU/qG1ejW5t3onR+abxlfbuFRmXbwfnfAZgtzU+7u33U674u1oDSFxmxLXcYgtGT3dg/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjxjpB+7oMNA7JHysv929t0fK53XSWaFOn2UbP+vDQs=;
 b=xhcVediMnf5s6Gy1WyYV5SWnZw5HaCH+y88s0cz32cpRi5JGVywmX25dPA++baOo3ETMXDBktmIerUmL0cJFJc9K1fWh+pVcooxwUDy6J+zPXHUCA9sij+U9M3IdVeqIaGzmQHNG1BiqWs1kn83cc88oUO7yXjrG0OR04qxx8N4=
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by LO0P265MB2699.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 12:47:59 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%4]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 12:47:59 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Sep 2026 13:47:58 +0100
Message-Id: <DL88U0RJ7ABX.1LB1ML3HMSXB2@garyguo.net>
Subject: Re: [PATCH 1/9] rust: sizes: add SZ_4G constant
From: "Gary Guo" <gary@garyguo.net>
To: <sunke@kylinos.cn>, <rust-for-linux@vger.kernel.org>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Lyude Paul"
 <lyude@redhat.com>, "David Airlie" <airlied@gmail.com>, "Simona Vetter"
 <simona@ffwll.ch>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <dri-devel@lists.freedesktop.org>, "Alvin Sun" <alvin.sun@linux.dev>
X-Mailer: aerc 0.22.0
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-1-e0fdbf8bd108@kylinos.cn>
In-Reply-To: <20260902-tyr-ioctls-v1-1-e0fdbf8bd108@kylinos.cn>
X-ClientProxiedBy: LO2P123CA0097.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::12) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|LO0P265MB2699:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e4cb29-f7f9-48b1-9a3a-08df0c1514a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|376014|1800799024|23010399003|366016|4143699003|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	o9wVrr6cOwJKZ451+6gb0vpZyIvZx2FiPVdyBXlp5euuUOzSQAl3sa4p3ZF+9QgNODNspzzRs748Q1JQvH+CtEUdDsn51nRCgDOkOyngi1Um3Ov+W6tA5hLbY05usowz72ENQT7I0PmF3Zz7syg+gtktwim0sCBMsRDyZMURf/8YwK/tiiVAzP7gIikguhQOdg18UfnasTW+axlxI1KLdMT+IBrlryrGoRatQxB3QnxjzrJ17Eq7raMUSkxUFmL6rwvy3SSrWLZBajdD6VpQ6u90/MgnCJz+x2RIm0SZTZB8+ymDqRYDQ8Wt280nINHHxto9nmeyiw4+SvDTmNtZOK2ft+FK53wnEJIQSAT91FpRVgW94mODfASxQSKrZzoGv/2XR7RaVR5ntkhOscMyLYfZ0oWf7RVNkUtccS+1CrP81ygCJW4ZtFVVOGcfFS6Jhd04Sqqs0L5ruQ2XTeS4zZlsUwDwt7bykcNn/FwS/r1H//hNtlf6+FvyipXDtpWlpKNh9b8Mrw8MESm8wPyh90B+6PrmKUDQTCmLriFgm4mIgd++A3cSiPwh4M4bAnYGyQVgaFjLp3Y1XRRJbMy9qTUQ8rK1IdeH39csGq3OceERuFK70VT2SJjCXM6IZbdpwoFullsuP9FResLO6exsJNHCjVeaux0JMUrNvkx/v9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(376014)(1800799024)(23010399003)(366016)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1RkUFJOZTNPckZMSnc2dkM1eVQ1Ym16Qmg2WWkxM29zV1VxeE9CNm40TlJ2?=
 =?utf-8?B?TEsvK1dUdGlGYy9KQ3VRSzE4Q2p6N3F2Z3VXQ2NyMDZlMW9OcjQ4b1kwQmp2?=
 =?utf-8?B?L2ZTQ084NUV2c0taZGloQzYvcGtDN21kUU5qWkJnenoyaFg5blFvSC9BQjFJ?=
 =?utf-8?B?RmlML2w3L2hGb2wwTnMwanF1MzR4eWF6SE9qR1VEQzhuMTM5OSt5MnNZOU5E?=
 =?utf-8?B?Q0lKMkF4WTRBK1RNK3U2YnZsRzVVdlJFSWNQN2cvTmhac0ZMU3lNU0U1Zmhl?=
 =?utf-8?B?Y0JEUFZ2Y1dEQUpEcEpaa1NXdktjVE9NVHI4Umd4Ujk4VnkwdUVPQUtGellL?=
 =?utf-8?B?VEw0N3M0cFJJQzFldDVJSEhqQmV1TmpZa2c0cmxnN3RvV1l5QXN3MEJudHZY?=
 =?utf-8?B?NmpVZDd5WVVzenF5NU16MUdiMklYNElON0xJQjdQRDdjWmpTSkZsK3JSZ1Nv?=
 =?utf-8?B?dVBEMFdlTFFoWlNvMkoxU09pVndRV3BYaUZ2Ujd5eGJFemNTWEN6c0hmR2lU?=
 =?utf-8?B?WW1kNC95d1hvRTRQTWt3U0tzMmNtbHVYWHovakQ1WTdreTRxZUJ6YVJJUmFX?=
 =?utf-8?B?am1FTWU3bmpFTjZDbHJMbmMxdlBjZVVkTm95MHVOamdKQVV5dElya0QrUWdq?=
 =?utf-8?B?dEo0QVE5d0taUU5hZWpOaEhrWUdGREozZEh3SldabVdZbldJMGRzdlNvYTFp?=
 =?utf-8?B?VUREMWZzS2k2L2FUaEJBWXAwV2lRWlhzOTBXaEFyQUFJWlZ5cHhjZkp3VFpq?=
 =?utf-8?B?cXNZRTdEdUQ0cGtIL2dqT3paWkQyd2ZKWVdZOEEyTDhzTmFlaUQza3QxQ2F1?=
 =?utf-8?B?dERIVWwxeVZob3VKWmZVakhzcEc5bDk1Ykc1OTBIS3paSmt5SWJqZm9UeFEr?=
 =?utf-8?B?WlB2YmRucUs1aWN2b1Q3NEJWbVZ4dDZTd0U4ZUl5SjQ2T3REOHZlbnh1R1Rw?=
 =?utf-8?B?ditlWFFaNEdPcjRRbzFGZ3BxWVNRaCs5QytNcGVzbndsQ0pzVFU3OW9uV3ZF?=
 =?utf-8?B?SFBldCtNMFdDcTJPMmJxeDZmdFNHV25VNk1lL2FldWRwbUNSNkRObXhKSGlY?=
 =?utf-8?B?TFhYOVdLVVg0WExUSk9mOWZrUkxhUGFPSEFaaG01VGtQWFp5Ukl5OU53SDIy?=
 =?utf-8?B?aTl5RVovdlVveDRackZMcWxETmw3bnpIdWIraW9DUEdiMWJUQ2owdWJ2K1Nv?=
 =?utf-8?B?eHJoYUs0VFdDOG5YRURibjVuUkg5dzJyWmYweGdleU1aQ3N3dmVhQ21UODI4?=
 =?utf-8?B?WjdkN0dwWVBEdGozMkdPNGVxalFNSmdRaUtWWXRkKzlFcEZkY0J3eDJlZGZ3?=
 =?utf-8?B?YVdwR3c1WlhHZnFKUEJZZ0pVZXVMcG1VVWVnQjFCSmRISWFHc3JQendTOXhE?=
 =?utf-8?B?QlMyU3Zxb2hpVkFPSjh0ZDU3eFRRcjdYTVVVdVNlZ0pKVlZsckNwVGRjelJh?=
 =?utf-8?B?aWFsd1J0WVdXUUV5NFYxZUtrdlpwT2Q2aFBBVU9jUU9FK1BVWU82VmVzajdn?=
 =?utf-8?B?UVFxc05Oc1p5anRPRWV1RncyS0JiZklSN2NLMUlTKzBhYmVrSW0rMk5FUnpv?=
 =?utf-8?B?WEZXRWVqbVp6dWhVemRyT0piMTg4Zi9sY0FiYXhtT1pXdTd3QVpOQnFCTDdn?=
 =?utf-8?B?bHFmWUFxMjc1VFpRN3JPS29sa2N1cldJMVYyUkxDak9WQmRXTjc3ZUMzSEZo?=
 =?utf-8?B?Qld3U0ZHU0Mza1crdnBzendzMzUya1oyclRkVnhMc0dLQ3JFT2pleTdVNXMv?=
 =?utf-8?B?amZQcU9PaFlGNDJZYUdaTDduVWdHMEJyV3FZOWE1Rk1VckFISkxPOUd2RG5K?=
 =?utf-8?B?R3lDR0hLdmhHKzEyYlhlZnVQNHhQRGE1Z0VWUW13SjRFUUM2bnM3enN2SW4v?=
 =?utf-8?B?UFkxTU5vZlBjZGNwQjVwVUhrU0ZJM21NY0g1SFlzQU8vVUxGenMrUVplVDA3?=
 =?utf-8?B?L0hiZjdXREJFWVZjTmpKeXZrU0hUNmp1elNSSUhQNEFLVmREeVkwV2JNMjQ0?=
 =?utf-8?B?RElSejcxQi9vSWYwYS8zeHd6aFVsN3l6Tit2Zm1tbjE2RUVuN2JRNFpzM01l?=
 =?utf-8?B?T0JaUEt0Q3pvazNoZEtCbklGYldRUTM1clRNcWlZaitUZ2ZRV3lWMDdPaTBI?=
 =?utf-8?B?SHREL0FaYmFRYXRTQi9OVnVJWTZNTGJWVk1semt6YlJXdHNlOURFZmg2UVRs?=
 =?utf-8?B?QmllTllPNTBIQzEvMm5TRU1yN05CRHN5NjJpWkdZYnQrWUJGeVNmWU1hOXpV?=
 =?utf-8?B?Q2NlSkY4M2drVnpmSThyMjZPd29qMmg5ditZWkM5RzRES3pybHpsNy9BT0pT?=
 =?utf-8?B?YXROMDd4blNEMmxrdmF2Wlh0Vi9oY3QvNkVpL2JWOVloa3BnbjVpQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e4cb29-f7f9-48b1-9a3a-08df0c1514a4
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 12:47:59.0965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2SDeyQceoGB+O1YHP85HbGVmhswww+QDUUYNmoUMKeE1Wolg4IZjPTOqRSPezcGLzO5Bc+W+S8zecpl2MacUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2699
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C13A4100003
X-Stat-Signature: n35x85ayz3wims1rkun3968d4phsmkut
X-HE-Tag: 1788698881-109452
X-HE-Meta: U2FsdGVkX1/a2CtnKujxF4RjhtLWeSslP0USSgLmDUC+vxPgsF/ZYdFTA/alU8gAWCrscuIsjbnL9F0Lmuaz0j26p9BSnfr6H5szWoM87M2IFGQ88YehAt/DkKFWXAIBFRkthHmslzcA5iAEeVIDUv4sKNbGQ6EaqnGpo4osCZTC+6nxfP52ZYW7wC8tMKN1GiggqphbM7UIUVKfEQlUBiTsLDrrQjTARSOd/n1WUkAUJjhVWAebf5Y3DBg+s+Dpc08Zxz1rwO/c7tk6GUhsQfLAfgWAU//03WTcsBsvWdCypBNicCMtdy7c4yVSMX6S4daqnrJKnoYY211fWQeFt0tKUffb/8+qVDId8Fk3pUWEOWB/GEdZRzO/FV7YAAb1QveOZmqG3kyb4T7bwPbmITsKnxl4uf/Ys45nU7l7zkmaGQrxBwIoDrnrEZzmGLi6p9FcXfDSxcSD33KJG04U8TX60XaN4PZX8Yt+Oq1/QPWmYvaNJvi1Q3NPU0sijPBIS7dhWPy5CXsOclLpstOycWMCnyQkW+IzDT38j7Ep8zdG8o3ge05MBdMLQqqzF5SCg4toSwjTVoaL8EXxX1hLcQSw2wFlUGQ/ovJF6YJjeq9pWp25pb39Z88lAP2Woei95N6Zzox4hoBsjCeeiW1fEdqoRdVerGOiXc9YE+pDB14rBaQYJp2DFfLtr+bGI2glYj6YTXb2FJysjn1VQtnn0fioilSoUSXTBO5m1/lu45twrq3iy3enUv6kR9PIQoP39oDTlfWTys7tYqazrujHOfpF9tBjDv4K3uNEkw6tDG2nIgLVHMrbZ5AyeU2shXUexIwuTsDVA/LOfsu++l5c+d5EFZku3O/rKZose9ASZ1bSx1hFZCFXqAZwOKqQ0C3ZmatLaSvz8ia7EXPPzwo+aGNGCKG/AfDIjlvaSScJpDvs+BrynL6kPr8R5s0/jcqMEbFshSN9nc2ugkYD1wD
 Em4Ltubp
 nZ0K3sLZpfz87yL9sr8AR9/lfvGBp8ULPdRQjFOhdHXD5HWVHZM1u7yDAg0N+MY5F+7cN4p1d1nUEBQrV/B2HvtfwSRe/hHgKu5/GYaX2iogXTELoWFrhC3Lbi2R3LtxHOgvT4D/dx7/VdIVJFQ9d6FmQCSZbi+BOGqnktbzdhYv2mG+JMy8tzt/XdjbJrHHqy147nQbU7OazDKgd97zYatURR0u/aLsEO9XQvzWx8xOaNWzrYVD6RJAX29P/D0zosLZ850prkUng9Xu+Ip5eNxb1yujnqYVbUAteyIwfSWX4YS1Xj0+IlGNc+WwrfAMd6rwd4dttACXuW5ME3eQQmvmqIM+9o3+Ooa1wJFYkZ8pBJDfaxtsRTLf5PKgwrPVJPu0jlymGiastJNWBrP9tvJx/FfTmzVJFCNG8UJUi1sKfZ6Pd8LTFhT4HR4Ch22XkopolnNoAqDaG8QoVEy3B4IH8eJSBM6xLTFlNPA8ktuaVYDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 1, 2026 at 5:09 PM BST, Ke Sun via B4 Relay wrote:
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> SZ_4G is used by the Tyr driver when splitting the GPU VA range into
> user and kernel regions.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/bindings/bindings_helper.h |  1 +
>  rust/kernel/sizes.rs            | 12 ++++++++++++
>  2 files changed, 13 insertions(+)


