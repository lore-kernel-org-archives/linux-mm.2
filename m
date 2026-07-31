Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A5DC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789BF6B0096; Fri, 31 Jul 2026 13:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A586B00A1; Fri, 31 Jul 2026 13:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3766B00A2; Fri, 31 Jul 2026 13:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28FD36B0096
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:37:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3385A1A35
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:37:06 +0000 (UTC)
X-FDA: 85049777652.22.E1B129C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2B841160003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:37:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YEl4VVZ9;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cFeTwzYL;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785519423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXhcno23itq82a/OISHjeWwBwP91GxGzdq91mB7dC0s=;
	b=i5wwMBUBPbHwnbnrW3d/jwRxTzV40N/XYpwb3S7RVvdmtPhnn7GwB1NgqJqZAftHiEZnCo
	pufK0Md8U63A0Maoe10LBsCo1F8FNRgaKpXp5moqGFQ8wHlwSbNRGwwkWKJmoeJQhqe4vl
	yWm/ZZguUa5ewBAlDowUIx9+xSezN/o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785519423;
	b=vx8q6s2IsvL8HZK4xVEMI8po2mRV1KnfmO4MRJ96u4wyp9ylWRTMcu3cuN8CJyM/CZWY9e
	yXH/shGSaWGboO+mup+0Qrta2SB/fUCj8JOu6GRfx/POFqH5VZ7wGBwkDgSzXSfAM3W7GR
	Jij9arxM7JGg+Fj8hwpt7OxU4tQEZqM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YEl4VVZ9;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cFeTwzYL;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VGhlk73772224;
	Fri, 31 Jul 2026 17:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZXhcno23itq82a/OISHjeWwBwP91GxGzdq91mB7dC0s=; b=
	YEl4VVZ91uHlYyBo6x5LTXiff3QX8zCCNBhVTGVG1c73DNuZV4dVTyFswS0RGSFX
	78h3buDXXRrgvpdkOyV1TYb+9n8wBzuMSrWG5NYwq51PA2kmVD5UVqpoXzb2py12
	nd4X+eh8ZJg59x/puutMqeg9tQx1DJOKgL0EnT04Qe3/0ruGORTznw1U+Y0D+rL0
	vwCr+4FSqEnHPqVTLKCkmWvc27uAA6SLcSovNdpobth7PM6Rsv2I26uQA6TszdBp
	0cEM6cIXsuAkCkxmSroDzxrjt4UYM95HKSUJHIUFgr6yf7HgITxI9Ewj3se9le1k
	pmAsxFg6gGHyYEImusxcGQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyqb91h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 17:36:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66VHZ4tf014160;
	Fri, 31 Jul 2026 17:36:41 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012006.outbound.protection.outlook.com [40.107.200.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fqjwwr630-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 17:36:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F1bgxmh6jLaCFYjcP097vDyZkcxbkh0qOxMiIX2WDFyYM8Ul8Z0zRTrp2f/IkvkI85qn5YTgFCAs5Z+SF0FvepB0ptW3XUY4ueS1XwZxpaiXgk+J8X95Um3c4ljnmHJFTwff0UPspP19uecxnTdquJJ5df3S0DU+eCi2Yqd19K6CJLtGcndGoOGErSZ/qLDrj7LLMwI51ffM7KCWziBgR6czhqlRlOz07tXGkjO6/mZu//Sl6UTE99egWXJIW43HVHIyn9MTIlbVbPoNxGY5SRbnQL1rV1NISPpQ6ZIvh85CUTlZfR6JPgSPiDlE7Ker+eaoTZ6OcJiTw9yle7Qvjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJcnZXzzNvCoMatCjXaYjnRRcYtS9KeunLE9vaaoPbo=;
 b=eZplxe6hBmlBMGH7hh+s5rlMtKU2mGsYxj+B8rse8bWxqj16JUhcjFjdCGcQnXzHjW3cP4AQpk0bt1YKVGPvwvVKiZwlCW/xhOW4aQi9Ua1ihpjwH251f9pOG4k2w+A7bjXm+1Gnbbm3reaQVTkT544zLpynWOwa9uZe2AZIyxQMU387JaK71hYk9t56s3GhUviXtp8BbvvD8wm60Dl9ybnBFpveJ0Ik43TmBQQDrK7yEg74rg9ooNePVob0W+xzwhNlpxFnZXWd0JH+Op8+0R1H5aTXy9nkc1pgPZO5GcMolJHSoMRUTNKkt0wXnmVd0hQxF8tdhdfiBTKn0lPl+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJcnZXzzNvCoMatCjXaYjnRRcYtS9KeunLE9vaaoPbo=;
 b=cFeTwzYL9ZV9VaKVjSvaYG8QYMCLyIUYV5soY0mzznw1t2lSxNmSWT7i9mDbx7n2Xo8YjZ8HoNW0DPpSaqfhNGlCQa+dlam0367kUvRLeUtJf7VPygVRvyR1qRzDLXdahuhbUkZ1pfBgybigf6o3ZzR1AaCcoU1/hnIqW+NqV60=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SA1PR10MB5757.namprd10.prod.outlook.com (2603:10b6:806:23e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.15; Fri, 31 Jul 2026 17:36:35 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.21.0270.015; Fri, 31 Jul 2026
 17:36:35 +0000
Message-ID: <2045eeb6-d135-4531-a746-f2500838ee8e@oracle.com>
Date: Fri, 31 Jul 2026 10:36:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/13] memory-failure: Fix hardware poison check in
 unpoison_memory() again
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-2-willy@infradead.org>
 <c5b01c38-9c35-468b-9fce-ff7e1e11b03f@oracle.com>
 <amyldelTLZNeGaNQ@casper.infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <amyldelTLZNeGaNQ@casper.infradead.org>
X-ClientProxiedBy: PH1PEPF00013304.namprd07.prod.outlook.com
 (2603:10b6:518:1::16) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SA1PR10MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: 574eecbc-e01a-4893-f91f-08deef2a4450
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|4133799003|4143699003|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	/gG4BGl3tFlbsHoKQLq+y8l+e3U0JgbK43PvZZSI2hEzxEWVdWZPjKAshDYdWfDBHuqUYe+sw37rCvHJXcbw0fJ4rCW9req4CnDanOGb/yriFsaeyAtbaj43Z+pi1mGhxdwHAqwTc+0ugi2pFfM1iVuGU1//BtJ+neYTWvRtQHgyS3gDnBn68KNf8HVX9DQ6lCb6DGPw//yC08F8ptAyke1qBcupIjbMYxaZSlM/GyC9aGGq+gEhH9XdOFMGWNRa9js81dYYu3mREGn2XphKFKDdoUar1fJoFinclytafhiQ+11Uh4u3gz3Ridd9KCAV2R0q+NWi7AKRQKMbZ1k8/1LY7XMawfvKytBcPQfCnqqylfE71m3MsCQMNcO01pJFmGDYNyOVHuuY4+ezFT/MWDTmstW+vML0pGWQYrSR+tGrBcYgLGhPp9lMvFP7HUej3nrKyoYnxwsIqpN8f4oKGybPQKudJA4O6/CKNnpv/cfMyIdtUD7Op7JIdQCveQm/2LCVhyOtmJTaUKC3opmLVfLLQWttW7m+AQvibJkRGSPEAceYSV7N9Kd6F4Y/jd6zdgkGM9ckUPisDyzuN9fT0Bfukw5ZBcAlM6X+dO2+7w8pme/G3UvadxW/QCU41hbAc1XOzxvOYR156oIROJCUIEveTs8e2uxqJ6KGJVyNlDc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(4133799003)(4143699003)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0dZSWRjZjJTMkFyT2F6OUphc3grMU9wTE40V1BlQ2oxZkJ1bmw1eE5KN0kx?=
 =?utf-8?B?SC9kSkFuT1VIUDJwSEhLV0h0ZjkvalpMNDZ1VzdIWVNhTmdBOFpNZFdrK0NL?=
 =?utf-8?B?UXlrN1EyQ3RiV09OLzQxSDBZSU1BNUVjVm8vMG9kd0l6S3Z1dTFrcm42dFZL?=
 =?utf-8?B?dEtleWtEdVc4RVE1WCtvVDBZRXBGZFpTNjZjcGp3bk8vZjQyeEtvQ0twU0Zx?=
 =?utf-8?B?RUJPaVJhNDE5aUVWTjVNbTkxa1h3dFdiZm9neG56bW4zcHlLQjJMTXUxaTJr?=
 =?utf-8?B?MUVlRnNSZ3I2R1E5VXNvOWFjQ3ErRGlEQThOTkdzci94N0trcThsY3dQYmcy?=
 =?utf-8?B?UEVOWkZ0aXB3bFJuVmJDTmNoVFh1WUovNkp2MGsxeGJCYXNuRlg1a2VKb1gx?=
 =?utf-8?B?MXZtbkdvUFUxUm5wdE1aenhGa1ZLOVRKUWZkTjhObWE4TU4yTTBnckgrZ1I2?=
 =?utf-8?B?c0c5UHMzTzlDaFlqYVJENEJySm5RMzczbGZmR1ZQTWJyaFhUNGE1UFBLUHVs?=
 =?utf-8?B?NmtNcVJSdmdhTXY3dXBTRWRmODVlaE16UHcwRXc2a3VobWxOVE9NRnRJVVRN?=
 =?utf-8?B?aENabnhlbkUyNDBQMFhRektrN20yYUhld25YeG5RcGF0Zmo3YXZ2R1YzYVhY?=
 =?utf-8?B?Ym5CQlZLV2xoSHNScHRJU2VsSnBreWJkcFhCYmhTQWx5UlptejNKL1lpK1dY?=
 =?utf-8?B?VUJDcTQ5NWVMTTRXaUEwMHVJVHFFaUNIckZtaGNBVjlCMENsV0w4QzlCb3FH?=
 =?utf-8?B?bHFjVXplSkJ2ckg2UlVlMFFYMnF4dDlaVGhpWGpadjh6YjBJK2REd25rVHAw?=
 =?utf-8?B?TGdHeEx0QzFoZUwrZzVxSXRxL3BTcmdNQlQ2TGNxcXVhWTFWV0U0anFlMHl0?=
 =?utf-8?B?YjV3Z3ZpLzF2S1U5dXJYWlc0cHlJOGVWcUR2REVBaEptc1ZLL2FDazJJelhQ?=
 =?utf-8?B?NTU1WEN3NE85VXhzZ1N2N2hNZ1NPRS9mQjZxTXRjZnJnSUJFN1RjQXYxbjA5?=
 =?utf-8?B?R1NFYUNmR1hSMEI1QStzeFVIeDVTRGlpbDQrY0lOdmw0blFGUkt4ZFh6NW5Y?=
 =?utf-8?B?MjkyTG5NTnlWVVJDMFZBS2JhZnhvL1M0M1UwdHYvbWp2STZ1WFNwVTFhM3Nx?=
 =?utf-8?B?VTRsZ09lREZTbUZpMmppTFlmMm5hTHl4aGZtdG9xK0c1aHByVVBXZGxOOEp6?=
 =?utf-8?B?aXA2NzJKMVVkb1Q3T1hKcHZuZ2ZYQU8vMU5mUm9iaWxwbzNqdGNFK0pvTk9q?=
 =?utf-8?B?Zkx1S0w4TDJydU1MUTVCT1BjZGkvSUZocm9GSm9RajlHNmxZRUd5VVc1WkJO?=
 =?utf-8?B?Qm1oZFB6Rm4zbVh6d3VBZlVSWm1DQWdPK2pZbjFmcjhXM0ZEbkpkbUpsYlVP?=
 =?utf-8?B?NllOK0dDMUpXSk9GRTU5d1N2Rit1MGVnU2dMcTBiTkpWQ0Y1MjZ4cXhEM0tv?=
 =?utf-8?B?RWFHSk5NcCtmcXpMU1lpTndEUFRJWVdydm5FTUZPcmFVVEVJaTg1a0p1NUY1?=
 =?utf-8?B?UklxSDZ5YmNvT2RLMlpoYW54T2UxMTB2MlVFV0dncTZha2FuWnJJME5ubUFZ?=
 =?utf-8?B?K0lxczNnbGQwUDR5cHdjQU5VMjFlUEZIdCs1UC95Q3oyUTNJWDQyeTZqNVhP?=
 =?utf-8?B?dTljT0dNa2tnVWFzbHE4bkZoTDl1ckZPcUR0U2hWdGVCYmdIWm9sL3FzK0xn?=
 =?utf-8?B?UjYxYTRRTGtGUkdFTVdZM2lqNllZOXMzZFhTUmduZGoxWDhMWVM5czk2ZkxC?=
 =?utf-8?B?VFJxc2V5eVVDSHNwL0JVTldOdkJ1dUI5RGJxOGlFWDI0SCtBenM0T1I3YTFG?=
 =?utf-8?B?Wm10aDlpVHA1MWRlL3NpM2dWZ3JmN3BWNGdCYzZiVkpyT2dzQlJxbUtYc09B?=
 =?utf-8?B?Vll2eGVjUENibjI3L3BPWDRCOGFnaHhLU0hLOGlDVExzekpBcHhxRUJJNzZT?=
 =?utf-8?B?eG9uOHhiNWZHV2laTmZlOXIybnVKZ0VSYmR1NHhVcm5zVDUxQVUrM2pwNXcx?=
 =?utf-8?B?ZmJLelU3ZEVITEpZQlhzTG9FVEZ5VHNWQi9TQjNTTmlaUThhMU5GemxBZGth?=
 =?utf-8?B?N1hJRUk2bVhsTWM2R2txdDI2ZEJjSGF4VEJ0M1pEaEd5cnEwZDlyUEQwdUJC?=
 =?utf-8?B?Zk8rT0NsOVo4SmlUSzNoejd1dVE3dFBKQkNveW00REdNS3BNamlQZG9NNm5y?=
 =?utf-8?B?QzRrcmV4RHMzcGk2Mld3YUNRQ3JDQWhyckFWcE0rTE82Um51ZURuZ1dHYWFS?=
 =?utf-8?B?L01rUUY2TWRzOTNsUEVpMXZKdjhWblZQR1VnQnZZSjVrZThFYmVlNkljbWta?=
 =?utf-8?B?dGhWckZDTHlrZWJma0dMVmdQWjQ4cjZWMmhKbWhYcnhJM1k1aXJJdz09?=
X-Exchange-RoutingPolicyChecked:
	piux7rA++WpWsIn9pgWsQLAx5MpyZfo8AtEG9/IcW1RV7C0olyPQkVw/OcKkXclKNxyB/ZHn0s0Lj50UNMfINMJHO05LuUy/L6Hu+jQKfIhf3EXHxlWXXG0Z4z/vLuv47k96CdI4/wZnoO/xx2jpu21LP2vIhXr/78q5UOE5wFBG9ONHhl/voneiFaZIyX+Rg6pGb1M7OwXSAmnjFkzWGch1tBGvqiEnh485b0tkMYfw/QuOucDjjI9yhIjEk9GJtjEywyrenD8CS6ANY7VHzSJyN+aeIkletAF1Lvdba5YYSxItVYfekkhPXxPdkCrGVQXCBRQ3FoylgJdQWAcN5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nRWltzD6xi+nR5fuEBy3Szc1Q6aX2yWe4xQwYB24oGuRcxfNQoacFFJ1m0U06GGvuIQ4dTO35Mtz1NSpBFSy6MqVi8qjo7DYJpQ0A21VWeA3VoEv1X2lasJsJ/i9Rr1yXNiAP1gpoR0Ng/4v9Fh5NWWWzvLjn5jugxrBgEXKbrI/BU8RePzXyGGQVrmkczLToqTybj+fOuUvziilAy+BxSDOKW/RHg4GSXpsmfPjfyhq6Z2uRATV7fevBqWYtqSIXWsN7dPFtWEN5l+50zy5QcB4REJ/ss9uOzrdCzYsCvupn1xIr8uRoL6ktl3HwGjmoS6+e0fc7OGZeXnXzjZoqIWJSpoxVi4il+wbRbvnfrcg8+wwCJJc/WJjX1xyR/cBgb9CQwnNIykqwnoA2gyUpaHzteEyq8ALyEIQjBPi4gJIo1OH82riSwMokW3i8I2iyz2jK52lNofBlkbTsyLHU5pdFmdq7QUx03ScMnABA2VXWoKFg0wPmAA6oN0cY+b+bSKQr+eJN+Ln7DFSKtY9FCpC4/8sR31z4Hb935O7weY4qErU/xFIvepY7OipErEUjacqxdME/m1q5EoU0OTq0o462L/C/uv/QL3MT1vYBtU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574eecbc-e01a-4893-f91f-08deef2a4450
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 17:36:34.9017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5B3U/r9D61M1zDlo7QC+Hsn7wqZb9kjS01Qwh5Cqa/dxi3zX8fShDdxmx7mVsQ7dHoL2P72Y2uGsIi4vDtQYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607310135
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzNCBTYWx0ZWRfX94AU3TqCjtsL
 wOxAvuSvWcDEe8GJFxkXtZCUvmva01CremSxiH6+cAXUpiuzO7icEVbZWzaLn70vpWLXH6tHEFz
 Z+JJDAeX8T509rCzGGIzrkmo3gCTVRXFOWpFyDX2q3AjpyQrlemFH2N+UEE4XNlbBFB6tyIoG0k
 ueRV0syUfmDfWGaiMZwJbWAQWeUbn+aIaXRvi/uymkgr/qR4ZQfBj+GvjYZz1ad+LFa+E9mCD9/
 yy+7KFp1g5q0TkaFhTMrW3lebqpdVuo+d4CBFDDUGHzxmdrG5KpvgnJr55elswkMs/oDCYINfc5
 SS8tASMGQyjkensmRAp5Lrj2vfdBm3BBCyC7BcUL6dM4ASwk2NG+05Is3UMa8ACJa/yK4yfUy6h
 L0zPf9aONRdE/EWfoibfUjQFdxWe1+dd+rEUQkKldaG57tgr8uBy2skE7WIOAGKAX65jUv5xjJ1
 lDPZuoGKa/uHJ1MpVrQ==
X-Proofpoint-GUID: 0OWlKbzqRTDIKgxgBw0_dbcwCuek2l9b
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzNCBTYWx0ZWRfXw/PKZuW+AWd8
 TFL/Wq9yyCjBJDPe6gBwcDUiiv7LISuaTsFFZsnsiZPTsJtKd41LPEWGIOQzkLsQ9myHKJb01i8
 PWFxOWzE3jerMBzyAkcRBbpecFzsl7ruGbr7/3hTDDaGgG1kcyJe
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a6cdd2b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=RpNjiQI2AAAA:8
 a=yPCof4ZbAAAA:8 a=IbWKqwsIx1YDLRePfYsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: 0OWlKbzqRTDIKgxgBw0_dbcwCuek2l9b
X-Stat-Signature: 5f6166n7ti5k3sgpt63dicajzr4fjwr3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B841160003
X-HE-Tag: 1785519422-513897
X-HE-Meta: U2FsdGVkX1/JYryoB+8XsdDuTWyned9VbV9/e1sb+CvHrftLn2pfKm0SHd1DOTc/DfUQAH5eaL3phh9Gvit97QImlB1IyEnI53+NhigcYhSEB2fch05lHCGN+QafJOiLjn/y53fyoSXCdOMImViqJ8figVteZHX3V6azywoxz6Dbc5GMc+r4AsklWXNOzqKM1sNEvFdQpELHKXqAgyWd9OyehbUCy95j+lttzY1qc0RRchVosktV7VrRySk3ljF1rxsBn3bjvV0IenqnGHGDq8ntxVpj28n1v7JrAeIgL866Ns4ThcybCrc2BAGO2nyxPqiYGc1Epw6gN5LJ0P4s16nQfeGm3g37EUGuoPQa9BF5I55iou8aYVOuF30WZ0lPL3imgKHFXqmgRHPhwl2ULpAoLdlbqabNojVdVP1FR4WrLCYPZO7c7eYBs7xdKyN3g0o3SjM6sgBIowH8zviPtUtgbC8uTXLyqDXP8JK7pLnRxSzJepu8Dh9zen1oXzDlfabVMvxmo+f5Jm3iP/eWZAtxox0qIu7cpnyDI7Z7FOEnGlAynHm8y2FkJSfHrePCrSku04DuVPFIgLtmTCrIzy30xzNrXLxE3a/7h8jfjDJ4GQ+gpciSHAIIZCNkrv/mgMqZ34Oz9NXAxW+QOsVytUUEIUIe1EoEzEPkes2dk03FTEm+/2cluUO/5v109l1jPlHjnmqbdkYzBylDSN+WBaKaH4Kx7MbAw9OWaVIT1BsISVYRwIGpmwf5yp/7YgZWioICMMb8eSdXQ65UYf1m/A1TImIzMSbPIUkaNjKu8SWXn5xvmyBsJ5xxRVPNFCirik/0406jLTCwVJbszhxH5edgbSLYEFb0imOMKlyxQdT54PhsfUgc2lSh2zKs3lQY/9Sup30Yhm1wNahRxp6hAnrA9EibmE3TPkMbL6GQStAzp081TiiEUVYcGtO+glYJeUQqX5O2lwGRMWmQxH/
 vqoRbsVf
 4UDKG8XFsEVKWoQkn0uJbBvdeSwtluslrEfO6hNNbNKZ+/5JnA0J+wHZ/houdKTAjxa+MsqFDvhBWmnL6NHWWEtLLqS6ihOhecvjWezTVE2ztt4zBsVHt6k5bIbglkpX6aIkjKGHMoDn0+tVy9Bdk8icQTu/k4pu21WFR95jHId45DYC6ObuxEha0YbbHNwSnTSk8aoD8CiX54JOQx4OP8NlEFFgGjRjSnTCJhiGd8mqw79VeLtceCraOstIHABr5xe1MjOyxxsTUrutfRzCIC739IZhjYRykX9tJYfrT1pErq0fBq755l4OLJnVcvFsNahxY0Co5Gzf+Z+xjXoz7vRBDdtpNbxqwAzsLORK/MnKzJtBvpFHA+jSIw+cgiLgwbM5mjp1YVL7BsKmkiKeTeluHyvYLIO5bpmehHlu2aCFomzilWjJr89DpCd+LePSafkaI4TrgtJHJQokbxduBapgaPrKl1zSxS2Vf8gcPzyLHlfnUOJNgAFr7T3wmotf+l6pAYNRFQojrwFmHgY9ylZqs2Bt2V05UvJvvMiP79TXv3REZ5Oz5EoXyAgYdbhnyyS8C3UkrInmQxyCMES5xWE2pwL1OvhnY8Gyz6f0V/errNLzPs3i+IbONHpjDAYd9gBR/vu0e3eDKOwtyx7I5/qb9poeGSkpvdFExRelPPIaBcorYacSYjjhL/8ufeO5QT720rS0euuzfYolY/fAqtYpfQ8ZB3YWDHC/hwlu3aj/6cscF3FHfzccbXHWeur/tSe/EfW1Z4ai862zK4e1Y0Dtxhv5bRSqJhPti/z24omcgS+99XEvByKJ7yhI6SJd7LIfz0PheoIi89dhpiERO5oHxjlAhwFH0aEcbe6IaAWxg3/+1/hNW1PpW8dmJ3lT5ZJbSxCAK7IAK42LtAskwdp24IA3vDHKfyTylIA+QJ+6j+cBfxClvf2syz5qdziJN/xTKIwa4j8WiOdvjGzuyP6Uy+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/31/2026 6:39 AM, Matthew Wilcox wrote:
> On Thu, Jul 30, 2026 at 10:=E2=80=8A39:=E2=80=8A57PM -0700, jane.=E2=80=
=8Achu@=E2=80=8Aoracle.=E2=80=8Acom=20
> wrote: > I think I spot another pre-existing issue in unpoison_memory():=
=20
>  > the XXX line doesn't work for non-hugetlb free large folio because=20
> it'll > just try to clear PG_hwpoison
>=20
>=20
> On Thu, Jul 30, 2026 at 10:39:57PM -0700, jane.chu@oracle.com wrote:
>> I think I spot another pre-existing issue in unpoison_memory():
>> the XXX line doesn't work for non-hugetlb free large folio because it'll
>> just try to clear PG_hwpoison in the folio->page, not the precise 'pfn'
>> page.  Something like below could do.
>>=20
>>=20
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 51508a55c405..14915718ace5 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2730,8 +2730,10 @@ int unpoison_memory(unsigned long pfn)
>>                         count =3D folio_free_raw_hwp(folio, false);
>>                         if (count =3D=3D 0)
>>                                 goto unlock_mutex;
>> +                       else
>> +                               ret =3D folio_test_clear_hwpoison(folio)=
 ? 0 :
>> -EBUSY;
>>                 }
>> -               ret =3D folio_test_clear_hwpoison(folio) ? 0 : -EBUSY; <=
---
>> XXX
>> +               ret =3D TestClearPageHWPoison(p) ? 0 : -EBUSY;
>>         } else if (ghp < 0) {
>>                 if (ghp =3D=3D -EHWPOISON) {
>>                         ret =3D put_page_back_buddy(p) ? 0 : -EBUSY;
>=20
> I think you're right, but this isn't a bug.  That is, we're calling the
> wrong function, but in this particular branch, we're guaranteed that
> 'folio' and 'p' have the same value so the same bit is cleared.
>=20
> This is the case where !ghp is true.  Here's the code we're looking at:
>=20
>          ghp =3D get_hwpoison_page(p, MF_UNPOISON);
>          if (!ghp) {
>                  if (folio_test_hugetlb(folio)) {
>                          huge =3D true;
>                          count =3D folio_free_raw_hwp(folio, false);
>                          if (count =3D=3D 0)
>                                  goto unlock_mutex;
>                  }
>                  ret =3D folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
>=20
> It is my understanding that we take this path for hugetlb memory and
> pages which are in the buddy allocator.  Buddy pages aren't compound
> pages, so calling page_folio() on them returns the same pointer, just
> cast to a folio.

Agreed. I think the header of get_hwpoison_page() can take a bit revise -
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1484,7 +1484,7 @@ static int __get_unpoison_page(struct page *page)
   * the given page has PG_hwpoison. So it's never reused for other page
   * allocations, and __get_unpoison_page() never races with them.
   *
- * Return: 0 on failure or free buddy (hugetlb) page,
+ * Return: 0 on free buddy or hugetlb page,
   *         1 on success for in-use pages in a well-defined state,
   *         -EIO for pages on which we can not handle memory errors,
   *         -EBUSY when get_hwpoison_page() has raced with page lifecycle


>=20
> Now, I do fix this in "hugetlb: Use the has_hwpoisoned flag" (because
> nobody gets to use folio_test_clear_hwpoison() any more):
>=20
> @@ -2733,8 +2756,10 @@ int unpoison_memory(unsigned long pfn)
>                                  hugetlb_unlock_irq();
>                                  goto unlock_mutex;
>                          }
> +                       ret =3D hugetlb_clear_poison(folio);
> +               } else {
> +                       ret =3D TestClearPageHWPoison(p) ? 0 : -EBUSY;
>                  }
> -               ret =3D folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
>                  hugetlb_unlock_irq();
>          } else if (ghp < 0) {
>                  if (ghp =3D=3D -EHWPOISON) {
>=20
> so I agree with you this should be fixed.  But I don't think it fixes
> an actual bug.  If it did, then we should do that first for easier
> backporting.  So if I've got anything wrong here, it's worth saying.
>=20

Yes, with your [PATCH v7 06/13], the patch looks fine.

Reviewed-by: Jane Chu <jane.chu@oracle.com>

thanks,
-jane

