Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDBBCAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1E78E000F; Mon,  8 Sep 2025 05:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99728E0001; Mon,  8 Sep 2025 05:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61398E000F; Mon,  8 Sep 2025 05:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9178E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:22:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 370C613C059
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:22:08 +0000 (UTC)
X-FDA: 83865541536.13.36B5973
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id E74DF100002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:22:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KKAqLLXG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="zD/X/3zp";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757323325; a=rsa-sha256;
	cv=pass;
	b=izXCFknICEzF5LnOnabLpEUMxZzSoO5keucnXVB9NlEMiQafwfvH2I7e4/lj4L00ZLFwS/
	qdSGFvtbxmfUGU9FAc2fezsy3x0hZ8PywpXUUbLieZKZNeYbF/2t4n0IxQGE2ABwuC29F9
	0ra8momKIqEzMZgNyXYaXGl21/30MDs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KKAqLLXG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="zD/X/3zp";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnjwipPgiutyxioNE7coE0vd2hUvsMmxhR/eG8p0NsQ=;
	b=rVY50DF7Eu9Vg4Dvryxm6Nzdm8+By3ZUotJ5/4XTOzm+pQagQPZ+//3dtfZnKqkeVB4TVS
	NV9TFEehuEVpkl+QZlqqXp8bKURTaOZEF+nHXrAvjg+9tH5/miYBk9wTw3BqNzqNRTxzDo
	p708toziXCMgVIAXDBk2JQSD8cCiQyA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5888e2VW013034;
	Mon, 8 Sep 2025 09:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dnjwipPgiutyxioNE7coE0vd2hUvsMmxhR/eG8p0NsQ=; b=
	KKAqLLXGn8i5Xnhk9g23TfgW3X0NwuIVzL3N5PxwG6fLCDpGpmz7XWprGflwJYxV
	yrgk9Bv7daadZ3qrQzUmw+NYlZwx92LpOjg84Z+/1HpknxlgE5TPE0I7P9oM07fq
	MVdGuDlssQ6d0qCeOFqF63sSQALqdv/B9s4LROhwgFhiN1xBBv7CM7Pi0GPcqifq
	VHueJLO0g8EuQ6G+kzIo8tkFbfh34UIBFgndEVJ7Bw6fkMzTI8HHvkzBGSaCXYYM
	K++SNriK7Ii9wf9VeXiNc9ZhrzTly4GYppwQ7mZD00p/OsAoorYnPd5EF+xti3gF
	EHEF+SgLJKPtJ2zcYr4EbQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491uu503as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 09:22:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5887Chj7032844;
	Mon, 8 Sep 2025 09:22:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8x8px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 09:22:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncAHED5atQItPgam7nO+E5Xqxa1vxye3C0P61T0wDGsXgT4eaT+faQU71nP2Ys4yW62kB8vQqc/iHBvL+2cYdyOhT/EUgmyxJU8l/2cazF9eWiBctmqelEQiy4jQGjgUeIT7k7+UXwkDN8O+d8Ug9kxqqa8C7gTfwpX6+wlkS2hmpJGx41LVwVYz/bE0DB4C66P4siAyExxcPRLI4g12Y74/PjG0rm3+v7SQzNGkkKl1JsCMVJl2+T30DVlRkmV4YXRqnD1qPmkLUbdxinB8rCoNuNCJvFrAR4+lB3vpxGmaJ898bYG3nCUZCVYTmo93YgotiZ9B6hfkjKG9D3xiLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnjwipPgiutyxioNE7coE0vd2hUvsMmxhR/eG8p0NsQ=;
 b=BwkdwVhC0M3O+LqcWDy3B+MPZaBz5nqK/Hf1OYaUxRneVW9xcxRZLxwQww3eA0UH3Ja8KhcOLfASLHUN5SrTjwCPV7TkpOyrar47YF3Csvwj9D7u4ty+eXRx9R+yfEDkXsyULhuhfI9peNA8qmKZ2F608uxaG17ZSZ+CKDTUpINozsM+gU8RnORVwuEOT2IReSxmzW1NhmRfYRGY+VxAQs1+QpgIxvwirQ//LPPTahQGA9UFZmc4KVvUcV7RPt1H9Egw9WHLAxhTjHQDsg2jjI7w5t6HZdc+n0nYrrDjLxaUJPzc0Vvn2I2doiEgjsBLdMpyj98PbluyS/ii2zbVvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnjwipPgiutyxioNE7coE0vd2hUvsMmxhR/eG8p0NsQ=;
 b=zD/X/3zp4nPfnxzI6rjzYJFDacG6W+b4JRSC9x9VmMyz6NmJhQVpAmFE82wZ2JddX7XpaP6MDBP/jUkewlJdWinUwVl3gVGjpTXRhkJFqtFuN4WjNLKwNysR/dUu8tZ/PAb1Ww8KykvmjrFd5KMHstjOfukXw+cQOLb+Wk2nbI4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPF8C8C3D129.namprd10.prod.outlook.com (2603:10b6:518:1::7b6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 09:21:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 09:21:58 +0000
Date: Mon, 8 Sep 2025 18:21:52 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Refactor note_cmpxchg_failure for better
 readability
Message-ID: <aL6gMEvR8RqW7YrE@hyeyoo>
References: <20250908071922.1062170-1-ye.liu@linux.dev>
 <aL6WTrXczZJYUoGb@hyeyoo>
 <c089b941-97c7-4392-828f-923e8da3510a@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c089b941-97c7-4392-828f-923e8da3510a@linux.dev>
X-ClientProxiedBy: SEWP216CA0145.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPF8C8C3D129:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fed2664-2e1c-4219-5d71-08ddeeb928af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2NlTllyaDFBL3o0ODRyV0ZKQjFxTTZQcjdnTVJQdFRZMVhXUVF1TENaeWU1?=
 =?utf-8?B?NVdXeGtwRi81NWZyNEVPa090R0xwbzhrRnE0OFVFNERiQWw2UnFUSWQ5WS8r?=
 =?utf-8?B?SUVSQjlzRkxYTTB0SGhEN2pFc2pJSnllbjYzYkZSN2cyZVpIQ1BpQTYvOE53?=
 =?utf-8?B?WUhRNXhrZTVGaVdrLzlEbFF6N05WRXJsc2lFZ3VQbWlQZXI2NlNHNkJsdHNy?=
 =?utf-8?B?bmpITWJiVlE4ZU1YRy9MeEhnekVXd2tkUWM5UXRMblc0V21zRG4vT3JiZGkx?=
 =?utf-8?B?YUIxTU1KeHB2TE80czQzRjRnUkpMMFFqdlZKcVk1Wm92S1pOZE9BRmM3Y2pN?=
 =?utf-8?B?R3RvU0tPd1h0VGtCcVV2c25qSmhrNStvRGp4RHdkNlZZTTMrUXhCaDN6VEJ5?=
 =?utf-8?B?MjMwZWVOdnZPQ2N0a00vR0xwekN2VG1pYmwrN2RHS0NRcDBkcTIrQWI2ZUpS?=
 =?utf-8?B?cVB1WGV2V1o3OHVwcDZINHdzc2RpbllSWG15ZzdWb3dmaEtqNWJKNGpzbmQ3?=
 =?utf-8?B?R0RTaUhBT2tVKzFpSmpMM0M1UjFpcDFHVzlFQUR0a3NGcjhqVW5EN05TNTR0?=
 =?utf-8?B?ckVreEYvdUNOZUltMysyNmRFQkNRb2pOZWFOVEtCRlBvU0hDc2F2aElrRkk1?=
 =?utf-8?B?N2c1ai83dnZTelNrWG1JM3hCSS9wUGtIT29zb2dpZndyNmh5WjUzMXY5U1JN?=
 =?utf-8?B?TC9VcC80ekUraEE0OXAycTZGZmc2dE5UTnZOMUJvZG5GYzNXSXlybFoydHRL?=
 =?utf-8?B?akFhN1pDd1JzSmIzY1Z4VitQNW41QkpRalhoVEpuQXMxYTJxNlNxY0ZwVnN1?=
 =?utf-8?B?STlwbXZFS3pSQmlZaGYyeXBFN1BYVnNqSWV5QjRHUDlMQUJiWXdHckZkQUNG?=
 =?utf-8?B?WmlhN3N0Ulh3THJBaG91bHRDR3N6dXpmUnphc1VJdTBMb1d5cWIwbjV5TGFP?=
 =?utf-8?B?TUxOM0ZrMDh4Znl6T1JYYWdZWjZ6dGJrUnJNTTJIQlVTK1JlbGpBc1lWMlp6?=
 =?utf-8?B?WVFveHZ4Y0xYdXNXempEOXNwVC80YlgzcWtHQndaWUZOdmgvRjUvd1V1UXo2?=
 =?utf-8?B?akI0dHM3TEZqa0syNUhRRzRMMDdYWDMwdkp0aVJqdmdJM2tHUkQ5bzN4czdW?=
 =?utf-8?B?aTNNOWF0b1U0bjBrVDd3RFdNUytMOG53UTFZa20vZHNxUVU1dVlwZ2tJSlN4?=
 =?utf-8?B?WFFtL3M2M2JOT2o0cG9sRERuekhiRDBIdDNVbi9iQ3FOcFhzeTZ5bDVucjZu?=
 =?utf-8?B?bjdvWG1pTW15V1BCV21QeEFrRkxleEZKOTJjbTZIV05xQ1NCR3lsdzFJekdt?=
 =?utf-8?B?eHE2cnh0SWtNbXhVWEQwbWZJWVlnSFpadlY3ZEVGY1NpdFFuNURHdWZLYmZZ?=
 =?utf-8?B?SUJKQUxoMW9Xb0p0RElJcEQ3VHdwaHVmNllTbG9JeFN5RTlNblYxbS9USXo3?=
 =?utf-8?B?d2V5dEkvVHc0RUlzOTdIUDVBR0hLdEFwWFZCVTBiVDQ0dzNFdUoyWUpyYnho?=
 =?utf-8?B?VktsUnBZcjhUSEJKLzZ2QldqY1dMZjlJeGw4TWt1TkwwWHVPcW9nUHQzbXNx?=
 =?utf-8?B?aURwcFljZHZ4MmdTVmtjV0RtWjBTSHZvSEtyc1pRWEptRFM5Q2FwRU1SWmJU?=
 =?utf-8?B?YUJteitNeXFWbU5TRituSVZxQ2M2VnZCZmdDTjYxNCtpeFJEcVM0eVVkZVYr?=
 =?utf-8?B?NHY4MmFIY3Bka1paUFFNN0lnaEp6WFN3NW9vTDQvV2RzeWRaOXZjek0yalJp?=
 =?utf-8?B?N1BZMzR4RG5STTVneEErUjAxMHlTcGxMdDhiWVhHcVRpV0ZkM1hZakk4SDFo?=
 =?utf-8?B?aGU4ZUcxQjNQSW0ybGpYQkZnbU5SOElZTEFjKzFjQ2xxdndPQnZEWndRTTlF?=
 =?utf-8?B?MHdtSTBpajkrbGN4am5aaEFHNHJ1U0VZVitzTThSWXNCbDVnODVxMjdQY2NH?=
 =?utf-8?Q?E2ypFL4a0WM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ay9PelVMNzJyemp2T0JLYmQrdW9BaHdUTy85Mi9XcVNpWGpONmVyeFdBQ3hL?=
 =?utf-8?B?SVQ1bjZWTW9HVWY4QmlXSWdMVm9sR00xZ2VnNnc3aFhya2hFaXlHVzNhNXdN?=
 =?utf-8?B?RnFmQ0NvRkp3STFiMStPd3cyRTFoOXRXak5EclRLMWNBakI5TmlGdm1BMVlF?=
 =?utf-8?B?RHdKTEl3S210a3dhdTk4TnI2NklRTXA0djJMdnM1endsQVhSbUFoYnZrL041?=
 =?utf-8?B?LzN3ZG55SnpDSnNlcG50K1BmdUdJMTIwREJIeDZ0elNKbXc5ZUF0bEtPUEdm?=
 =?utf-8?B?ZGVMVUVBemVDUnBTeGpDOXVKZ1RLc0tqSTVQR3JCVFEwcXpSMVB4d1ZEVloz?=
 =?utf-8?B?UGpjd05LWW8wMWJFTWRRVDFSZFU3czB3TkV2WFREMGJDaE85ZXVMNzF5ZFNS?=
 =?utf-8?B?OU9BTmxmRkJ2SzJxU1EwN0o4TVNGRnB2R1FXdE5zSzhMUGNtVllLUjF2cTRq?=
 =?utf-8?B?OWVuNHFDeDRrczRkUEhBSzRzV2NBbDNQc2lWcENKKzlMUTVEY1NqK1RqSnc5?=
 =?utf-8?B?NllOUXBPeDBIRTJDT1BUQnNvUGl3V05TL3h1bXprbkliVldXRGgvVkhpUjky?=
 =?utf-8?B?b25FUm9nRjREYmI1V1o1RXlVRzFSeEZwOVZXY3JUS1ZGVndVeGpYNktvUWdX?=
 =?utf-8?B?UTlUcURPNklJQzJWZ0o1WWNZSlBqd3NyYlQwd1pOaTVlM3pqSHMvT1RqZmE3?=
 =?utf-8?B?YlVXVFFCbHVLQXRXaWZPaDArOHd2N0d4a2FLQzhadDBtVEJ3VXE2bW9TSExH?=
 =?utf-8?B?L2JSL0J3NEZnZlIrZU5tOVNPSTZlYlZMWWJPajlIak13MU96bW05TmEzQTkz?=
 =?utf-8?B?TVdrOVdlK1pucFhXWFhYVDh2cm5hais2WGVnbkRjMk1TNkpWQWRiV0ZBZElQ?=
 =?utf-8?B?YjZISWVuVVlCSjFEM1dwVkgzbUlLZWhBSzloR3pzMGVsK0t4VE02bU9lbVM0?=
 =?utf-8?B?WDRWOW14dXJSRkNxV1FOYjdhbm4rbUtlMVJFYTVjMWRrbktjTUxqbUZmbjhn?=
 =?utf-8?B?TzBuY2V4TldYdzU0QVRzb0RtTzE2K3QwaDVWdnVqRGgwM3RJSEluQ0ViK2hQ?=
 =?utf-8?B?OSt0RGhZell3bzg2S0tDbDBtVzdycExEVUozSDNGbTlMelArVkJyV1liUGZG?=
 =?utf-8?B?WmxJMWVIZHlrV2JsZVViaWNFVVVTdzRicVpkcFQreHZqMmx0NlBmU2ZHT2Vt?=
 =?utf-8?B?S2t1TWV2b0MrWkk4eUtKSmY3V0RMMUZTdHZoeEJSQVhVaHoveGp1cWpSbk5X?=
 =?utf-8?B?Z3hjZzkvVVZpY3JXU2ZLZ3o2T2NiL0haTlE4cGlZSURvWkdrdGh5RVZGbXZn?=
 =?utf-8?B?Umo2QldDTVArTHVqRytWb2NkSTBLM3JKUlllbzhWWDMvVFUvVmRST1RRUHlY?=
 =?utf-8?B?WkFFcHo0UnljTkZCUm9qMkpuNkl1TWJrTHhJcStXNXBld0l5MVcybmZyeTRm?=
 =?utf-8?B?Y1JIbVRZR2hDUEtNOEMyd01QR29NV3VIZEt5bHFuUDJyNU9hSjZYZHRSSW56?=
 =?utf-8?B?cUUvMFkrNEJFenErcjcycTRTRDgxRHpmb2Vtb0FGVDllcTl1WXJqYTlyRU11?=
 =?utf-8?B?ZkFRSU1xNkhiYThDK0xEeVhSRjQwdi8yc09qRzN0L2xpZE5CRFVNa2VYcXI1?=
 =?utf-8?B?WTN0dXhvcGx1UzlUR1RDWElLV2xoaWd0bnlkMG0rNTRsV2JRZk9rbWp1L1Ja?=
 =?utf-8?B?QnNMSURUVUVYT2tiTnQ5ZDdRM1M1US9TQ1ZhWGowU0huSUVoL25LaXFDRkdS?=
 =?utf-8?B?cDVZN3ZmamoxMmVnYzdsUFF5dXJ1QTYzOUxOSTYvMGxHdXdVYzNXNGtZWi9v?=
 =?utf-8?B?QlF2clZIVTZHUEsxK3MyV21ROEtjT2hQZU96VTV4UFFweTN1amNidklUNmxn?=
 =?utf-8?B?WlNhalh1R3diWTZ5NzlZU29RU2pjWW9tUTJZbGIvTEdad3N2MnVFcXl0RXlU?=
 =?utf-8?B?TVkrZGovUDVsTWNGbDgvL1FzN0NJaGNKR0N5Ykh2NVUrZzVZeUpOaCs4L2s2?=
 =?utf-8?B?WUo1V0ZMcm9ZeTVlRE4zVzVBeTFXS0FXeDQzZ1daNVNQTERkSkZyeDJhZE5a?=
 =?utf-8?B?YVYwemM4cHZxNEgrS3NYTEg3ZU9kMlNsR0s0MDdHdmUxdTRuODVsVXZ0TFd3?=
 =?utf-8?Q?Ulm4t9O/G+p6YirR0+heFEoe9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+t+ak9840sGXD5CYuKc727Ea1hPWoySHaxSE5a1vcbdnyHer/qa6/0sVxdxtZeHqoozOfMxtk5MjzKf2iMVJx3yNsNp7r6oTA/H0/gFW3ZVd160sN/oG5DHQB9Z4uSzJ0eVindNI7Qgeecy90t1AvQAsf2JuxrfP4W7pMy8ZJx/hD2LtramMlAOsNom5zvRBI2vkOe3RKzMqNJmQeq3Y4vu9l6tgvL58pWCsLq9xKI+e69IUiKTPd9vqAftUU36sJb9+8LXYQlFjZR2FLvEshWmX+Uzf4dCO5L4alRANUaJHViz/NSzWyLxHNPL1UVQtWrvHJeybLtzT7fAFtPg3bhsAqpWZ/9yEkY/1diqvg6gXGheQagTqvrAKBtKp4j+zXMrwDVjHikba3ctvlVkQWu7yXZBI74HBIGe4aN+G7wdyHl9e9qIgjaKqYsNPFZtJu9VvJM4RcmdNA75nkizcZu2XNxOxYuPc7KdShxOvTDBDkKWl1AMBFCVNH+J47rjlUgMzDoLlfcdIYJpJoNQ8VNrsjukD6aFqbj/Ir+0nl2kzGyTHcsN0TmF35YN+8c86niAtjf9VkV+SRpr75Jcu66FzB1KZLnJUG4Ume/0i0tw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fed2664-2e1c-4219-5d71-08ddeeb928af
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 09:21:57.9247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9DQjkU/m4a8lgXNWe8pQ+N1Cy8btIuFpNODvkUrdTbgWjyy0j7LepEL2l/secE9JHiPUC/AtoaLFk1G+KI+7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF8C8C3D129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_03,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080094
X-Proofpoint-ORIG-GUID: sTCYeQFENRcgiKKu6XxeGoV1mxD8nzqq
X-Authority-Analysis: v=2.4 cv=XqL6OUF9 c=1 sm=1 tr=0 ts=68bea039 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=IJv9LcIfAAAA:8
 a=Z4Rwk6OoAAAA:8 a=wQqJpyoz34nvIW3zytYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cmr4hm9N53k6aw-X_--Q:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDA4OCBTYWx0ZWRfX2Zx47YP++jXY
 x5/oRC20NvKxBh+u46RGvSkJ7j6/xp2k+aFHoU2MPcR1Z1wS2oPrC9sCRWCuA5YVyVQ+1dORhHk
 YU5UcGnEj7rCU658AM+5UUBiAYt22/nBkLMXC4IOToK85jtTWjnCAjGYyRdwJUGPBFb1jKXEMud
 pA7VHPtTmW/E8NbblvWk+ebcCEPhGuw8d5lovZRux8jwTiMR2bjAWopNgyEILPu+A4GOo/jzO6Y
 zkkl+2zMemkPjKlkeXPLi9fTqj3Ocjy8FYZOVjWlxE+SGQyQKuAqDwF25XSVtU4wg+oKUBIEFA+
 CHTxHtqQWbmKaV5/40kNoYKkPhHmeJgBZj6o4dyhnAuRIC7lFdesJ2UXIShJseWMZhasObIod4/
 Kf6HXY5j
X-Proofpoint-GUID: sTCYeQFENRcgiKKu6XxeGoV1mxD8nzqq
X-Rspamd-Queue-Id: E74DF100002
X-Stat-Signature: br8j5ea85uaerkbdonnz3d3n8ruq9a5h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757323324-225152
X-HE-Meta: U2FsdGVkX18+lM31FacDeAat6duqhnj11Lbjw0PPSuQkGawC9UT2DysvuQMvulk+Cc5ZP+kOLPCdQ2RFR1pHVwAcWahH1PN8ndRNxyZaCXLlBN21/6iANYBAXK80P/dGH7p6hm4BfOUgH+QDgC4uvwNBriKnrMw1LP10VPugmi3eNm+EC9/1q/SZdANfsmO+gk2SeJ/DOxyeBdx8u1W9Us65sRVZRaVeYOsSAFFHnvngQzAzqySOYxB3XGf51cGhRjnznl6kc1JF/TuvliOrpZDC5HyxeXxbSXxVD2G8dEm9l8RtWRm0mrOsXiVUgCT54EzIDGfvPC1mXgkZPcFm0dbGui35fmH+f/UpORSeyLbenMh1fks2R0ZhRx/mPgdduZ+49v22dR8cFL8K28qDc++ZtaHf17hThbSWJ10SQ3T10rdxP5BfvjAK65rOvye0bbOyufbNjGH1nF5B8ikGCSKk098/NmAkbVrFPc/FC7NPj6PDIgBe7i2WeRJHYDMyI0OA75r2w+SmIE0uVKGU2EK3MIQB3mrbyT1bMQvQpRKLu0IkRb96HNUNtqQ73EkmUbCyO1BQqvAEgFqzYpP+HgxZtc6Gc+LTbRy8kj/Uh70i4AyUGgQ/pxGyV4wci71CeOk4igUfonow/sF4o+NpSQhaHfyZfzpooqpt7zGD4TE2dDQ4nXaMcpFRvbul+jaC4AZswBzeeav+R2Ue/fAQgB6msBR3wpfwnGTQPxt723cs6utUq1cMgbT95wY7HEpInl3N4+KIeXQ5etwwocHa1DiJJWaEumiqKRRVb5rYMLQlPxCp6fIcefv95ZD/CC56FNKVKCWRjHyWCOTBk8pB5NoUpAhgmt5tLDUGSpMLZUYJchsqGvjapyJgNZAj+w2hjTbMv6JcvkRP+IESKATx75vKr/vr9rAjT8lLGL7ULtZpMIMtPxSU2Ft71PUx9y6uhVc8yShWAPShJqkq9vQ
 ec0ilOyu
 Ry2cA9OdJeZKotGyAAdLgPOXbvySXfHliICgKNXpJvS7uzPdflmN/df2070TWz+kT2w9aTyAxAHrfAKrGbRFXP/7l28XGfKK+t6KaktewGGiQmiugLETrK79FTaCxyEOIuQM/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 04:56:40PM +0800, Ye Liu wrote:
> 
> 
> 在 2025/9/8 16:39, Harry Yoo 写道:
> > On Mon, Sep 08, 2025 at 03:19:21PM +0800, Ye Liu wrote:
> >> From: Ye Liu <liuye@kylinos.cn>
> >>
> >> Use IS_ENABLED() and standard if-else to make the code clearer.
> >>
> >> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> >> ---
> > 
> > Looks good to me,
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > 
> > with a nit,
> > 
> >>  mm/slub.c | 10 ++++------
> >>  1 file changed, 4 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 30003763d224..34853c0441a6 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -3064,18 +3064,16 @@ static inline void note_cmpxchg_failure(const char *n,
> >>  
> >>  	pr_info("%s %s: cmpxchg redo ", n, s->name);
> >>  
> >> -#ifdef CONFIG_PREEMPTION
> >> -	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
> >> +	if (IS_ENABLED(CONFIG_PREEMPTION) && tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
> > 
> > nit: insert newline after && as it's more than 80 columns?
> 
> I noticed this too, but using the script ./scripts/checkpatch.pl , there were no warnings.
> 
> $ ./scripts/checkpatch.pl 0001-mm-slub-Refactor-note_cmpxchg_failure-for-better-rea.patch 
> total: 0 errors, 0 warnings, 22 lines checked
> 
> 0001-mm-slub-Refactor-note_cmpxchg_failure-for-better-rea.patch has no obvious style problems and is ready for submission.

IIUC the default limit is increased to 100 characters in checkpatch
but 80 characters is still preferred.

Quoting Documentation/process/coding-style.rst:

2) Breaking long lines and strings
----------------------------------

Coding style is all about readability and maintainability using commonlu
available tools.

The preferred limit on the length of a single line is 80 columns.

Statements longer than 80 columns should be broken into sensible chunks,
unless exceeding 80 columns significantly increases readability and does
not hide information.

Descendants are always substantially shorter than the parent and                
are placed substantially to the right.  A very commonly used style              
is to align descendants to a function open parenthesis.                         

These same rules are applied to function headers with a long argument list.

However, never break user-visible strings such as printk messages because
that breaks the ability to grep for them. 

And also quoting a commit message:

commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
Author: Joe Perches <joe@perches.com>
Date:   Fri May 29 16:12:21 2020 -0700

    checkpatch/coding-style: deprecate 80-column warning

    Yes, staying withing 80 columns is certainly still _preferred_.  But
    it's not the hard limit that the checkpatch warnings imply, and other
    concerns can most certainly dominate.

    Increase the default limit to 100 characters.  Not because 100
    characters is some hard limit either, but that's certainly a "what are
    you doing" kind of value and less likely to be about the occasional
    slightly longer lines.

    Miscellanea:

     - to avoid unnecessary whitespace changes in files, checkpatch will no
       longer emit a warning about line length when scanning files unless
       --strict is also used

     - Add a bit to coding-style about alignment to open parenthesis

    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

> >>  		pr_warn("due to cpu change %d -> %d\n",
> >>  			tid_to_cpu(tid), tid_to_cpu(actual_tid));
> >> -	else
> >> -#endif
> >> -	if (tid_to_event(tid) != tid_to_event(actual_tid))
> >> +	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
> >>  		pr_warn("due to cpu running other code. Event %ld->%ld\n",
> >>  			tid_to_event(tid), tid_to_event(actual_tid));
> >> -	else
> >> +	} else {
> >>  		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
> >>  			actual_tid, tid, next_tid(tid));
> >> +	}
> >>  #endif
> >>  	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
> >>  }
> >> -- 
> >> 2.43.0
> 
> -- 
> Thanks,
> Ye Liu
> 
> 

-- 
Cheers,
Harry / Hyeonggon

