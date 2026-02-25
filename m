Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18BEFD375D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A306B009E; Wed, 25 Feb 2026 08:34:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC506B00A0; Wed, 25 Feb 2026 08:34:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0981B6B00A1; Wed, 25 Feb 2026 08:34:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EADDA6B009E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A88ABA5427
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:30 +0000 (UTC)
X-FDA: 84483073500.02.CF71014
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023090.outbound.protection.outlook.com [40.107.162.90])
	by imf12.hostedemail.com (Postfix) with ESMTP id A69834000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=GsxECrUj;
	spf=pass (imf12.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.90 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POLExnsUEalhbItmj5YvWdue5B/3ZYsqn8G8E9M9K1U=;
	b=qv6moIgCsbFNM1hBK3RoeeYXIRVlPzxRWuADDhGrsrltlB4wyHb1LGVIyFswsvh+8aHDw0
	U2BsrOPrHH6iSD7kBHWE9Sg5fc3wLjpcHI/m+KWHbVWEg0938gEiEGC1rdqCqXKUR/smZp
	qQ9Kec8lU8j8MxY6ccJVruJdPNByWoI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=GsxECrUj;
	spf=pass (imf12.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.90 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772026467; a=rsa-sha256;
	cv=pass;
	b=1LHmYu0KMOsLEwLQjEvrlXKrUac47ChDRAzTA9CKdNXSGa98nhsADC12neIzYoLA6Oyc6D
	P1U1HO+cIsdv7AwVoJu1UAweLX3o6YWSXmr/7sTBFtoBXelaB+TY190Yq5VEKDTOjRgp4J
	v+pFliuMy9DkbQ64loZ20IBmyCrsu0Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kv8M9PP+tyB7W91h2hLE8qYXyZ8YVjieay+UWO6TO8SckjdFmCv+xT8elwkpHTQkoJzScNKnRYtL5C5T+HbNo9Oirfod0RT3q5tYrF7QoOU3Yc2lUvAYq4GorbiLfLuh1+WlZZ1b/RjCrwPi6jpjHyhKHAAgZaxFQTGewCo/ddIr74JHVbZ5X/1CRjInwG3JU1qBG5B2/ECF231Jeq1harCoRvrrH2nXbPX+s/jfKLHKmcBCbbW1M5zZqZvAxNK/dpZN+Kzd0lanFzNvhVZ9LDdVKf1SCUTif27E1cgvKhdtzcEARbs0gah2BWizuJphHL5X+IQIYMBax0xSzzTivg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POLExnsUEalhbItmj5YvWdue5B/3ZYsqn8G8E9M9K1U=;
 b=VsGsT+fSB2Wp9RGk5rqMVPs23HwkUbhFln1G4DG4suW8HDpVr1oRra/m9XQmbCYE0VIpHa24B6X90HMwshV5T+rPPudDBZi8EGuWcTNDGaiLVjKS5pbF59nr0puQpq5l/yQsu3Vx+qWF3v4cUYqBCxgb4a2KUpLnpB9jlc0BbUwomibuOJG4XSBA8zuzNoo65v22hH/bnVtsMLRqrnRXd5x/8Pap2XcvmnYWOXbrcr9H7CCJR7pWWTDpJeC6+8v4buLhkx90LorCWQJla6nUNYi6gFP1iUyPAV1ivbf3/fOiaf0AIiIwTDopfsRpQzwRQBpf2RQCQLEE4zbCU6tVyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POLExnsUEalhbItmj5YvWdue5B/3ZYsqn8G8E9M9K1U=;
 b=GsxECrUjRYhkxUHCxFDJqxcXClGys6L2/nDTNQpHMP5ysRQLAil4ll6e51/iIMtANpZWBLtP++5yBw9hhnLKM55aZrQtdCmfL2jXSb8/ODwi+Pa5IghOJDXBwRjUh2I5eAUNjB6KEpM/0qugUtoSntKsodVtKKhbAVoOgTG2yU4dkynb0d2rP9rhFnTviwKQOUBG+sQGrD5jtQm596Sh11qtrykozKJETUp614qcwuep2sddo5VCtK3A+JvshpCmZKcfmC5wx/MOeHOe3zNzTxXMKPd+Dan8vguzJucWeART0mU7OuF8kJyG92TQfhqeaFdm3coECdWBq9qo3wQ6eA==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by GVXPR08MB11715.eurprd08.prod.outlook.com (2603:10a6:150:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 13:32:56 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 13:32:56 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 3/4] pid_namespace: allow opening pid_for_children before init was created
Date: Wed, 25 Feb 2026 14:32:25 +0100
Message-ID: <20260225133229.550302-4-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0277.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:84::18) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|GVXPR08MB11715:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d54bffd-35fe-48fa-bace-08de747262c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	gmPiahBZDo+hcgriz0jJK8c6R4ZcHFpgaCjeh5+YIpChbdVGvqQM558PExP2pKBWW5V+Qkpo3aDb3W3GhmB1QWYbOXYjlEYc1vUKI7WGVEdnZ4Ne/6UqRkz67As4/7pSUJ4HVl6jlQpdvvE0B1y8kO0PfTfUmsvDtTvCxSNVk541KSzqrTOYaL3eL83Hr8jLL0XVqgNfnEuKgcn40IWDElzK5HDwRUqpoy3+UdfoJsQvZ9RDvQMK1hmyVmrG7KWNmLZgCzJv8XjYcFocIpaw9ZleFpl/Q7bBqLktlKCRxg19Gn1nhFSdoTKj/I5PL4fcw2DxHhsQr64dvQL06ODSJfeMV1yLG3BVzInOtcWJeNi5QoBIcZdl0yiQUtSR2KpS9s5lbzSSo/YuqAvtnOI/LOalg7s/04at6rdLFL3cTKSgRAuBLaygD/uTy7p/m4m66Z3os1YInfLoEJGFPbFaLUdbFCaL3o2UjxBWVX3FDHuDDzJMFyIkPmi6htoUn4pg5t2TdaC9hKHVcAJM8+XUHoFeVbQOZCyD5xLxV/R6kw1g038K6oGqKwaat2fBd1Mr/kTlpG7w8npvH5zjLoIb9tSQHWWMt2Bju+wRZwZ4CLNyiZkbJPjkNgXBEydQgwGEWxSOKAfalurzMwmjDLIBC1QuLsIKaLiSRPhrdzilYAndapcsoavrE2aTDcRN9rdpVDITnek3RvowU4fmqPXI/vJtIoiE2IcOqDpY+Pf0gYA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUlUck50UENUR3lzc0JnWkFENFQxVFpCSnJKWXFURUU2Qk8xOGRmV25RdkFo?=
 =?utf-8?B?L1JzbkhBQ0hIb3dpT1h4L2JDUVBaVklQTE1sUnY5VUQ3NVM2ejBsZStyMHdj?=
 =?utf-8?B?bnp4T096YVBVWkJzWkxtTXFTVXl2ellwRXdJL2NGVU1pcWgvVVZtOStjemt3?=
 =?utf-8?B?eDYxeFJ0Q2MwUk85K0dWd0JxNFRTMGNIclRPR0txUlhnQnlDazR1TzdWekhF?=
 =?utf-8?B?Y0JKT0xvVkkzNXRWU3cweVc2WTJHdzR4NHRzSFdsSCtCUDE2aE5kMW1VT05Y?=
 =?utf-8?B?TzRNeGhLSkJOWWFVSlQ4OWFZeVFGd2VXOXhGRkIyQzNPVUd1VElHUU1iRFJT?=
 =?utf-8?B?TVRiY01jSjNqVWRVRitxWDVjdnFPUUVUY29rWmJBNFlubTlXb2hjQUZGRk9R?=
 =?utf-8?B?bGVlSjdFa2tMVW9TVklUaUhuUll3K1ZqSFl0MmYxOTRkT3JIbFBCaitRQ05Z?=
 =?utf-8?B?ZWpCN1diaU1GRU5PTmtuUzYrYjk1R014VE5oaFY0MHkvbGlFc3dVV1VadDA0?=
 =?utf-8?B?a0F5L0FhWGF5dG04bjZhTUlma292dDZ0U0FxaW94a1BCbTBGUEpQR0drb3hN?=
 =?utf-8?B?VUpTL2NvbnBpNzlITm1zcTVJZ3hFTFJWN0RrT3ZCd2lLZU9yaHkvZ3ZOaXFq?=
 =?utf-8?B?TTB5N3lwMFRxektzRldaR2szV3dMYjU4R3h1Vk1HK1lZQTRtZURBS3E4b203?=
 =?utf-8?B?YldvLzRXY1B1N3lmN0NJcjRSb2M5bUdkY1JXT1VrQ3JVWDVhSWZveUVpU2J0?=
 =?utf-8?B?WGwzWmFqK01uZ3VHb0ZNOTg1aXM0OVlsdEFHY2N2b1JpOFk5T2Z5T3Flc2NL?=
 =?utf-8?B?STIrajF2cnQ2Und4RnRwVTZseS8wQ2tHQmwzclFNSzltOHpldHVDeHpJQlYw?=
 =?utf-8?B?RVZZWFo2N3ZYRVZJYXRGVXBTTE9WK0swVnpjQ0dCUzd6dktpaDRpR2tIdlp0?=
 =?utf-8?B?Q1VhK3REMEZScXBYUDl6ZmhiK3F3dFZwOWRMUnBpSmYzcjZDK3lUdTVzMmFl?=
 =?utf-8?B?enRHcFpqWmRYY21Ia1I2RDFDWUJMSEVDWUNwMS8xdnlOcjVSKzdPNkZTSVpn?=
 =?utf-8?B?YjErRVN4RFViS0lXeUhQRVYyN2JWUWFSTWNPN1BNbVl5YUFyemtTanEyVWlL?=
 =?utf-8?B?UEF0dVk4Q3ZSb3JQUkFlWkZ3VExmc1FrR29aYVhkaEFFUFRmVGx2RExJNkpT?=
 =?utf-8?B?WVpibE1RclhFWXYyNnZQWlBNcmtrQnF1SVR6ODRua1MxTy9oS1VBRUJvdlJq?=
 =?utf-8?B?WVdTK0hiOHdrK0dqdnBmcENxZTJyZEhFeXRNTFc3eTgzSnZKWEp0eVVNMk9s?=
 =?utf-8?B?UzVvanJoTHB3V2hTeWlPWGxnT01rTkdUd0I1OVJpbEpQSjg2dk5FWEhvOUti?=
 =?utf-8?B?NE9GWEJaQjNyTnlVaEdYbWxwSVhaSEk1VWk4aVJRdHRGN3BpaEZFYkVnVWFs?=
 =?utf-8?B?R1ZXUGkxU1dKTkxMUUFYZ3ZJakhrbHBiRVdESzJIT3d3d2VBeUtDVHBLTytM?=
 =?utf-8?B?RVROa1hXYlpyOU1WaUIzSzRzMmwyK2YwNDZvbXlyN1Y2NXNoN2xEeWFLVjMr?=
 =?utf-8?B?eW1ubERsWnVJUVpyZHJ0WXdXS1RxcGYyWE9sa015NU1ybTlOQVJCRGpvT28r?=
 =?utf-8?B?Ty9MSy9pOGlqUXZoTHd3Q0gveFc0TDNPYVZ5Um5FbWtkcEZmUnZVc1ZQYlNR?=
 =?utf-8?B?MWxmV2dwc2V5U0xEMTI0dGJLbVp2UEJ5ZTVLNHNSUzYwTllzYy94eVk4N05m?=
 =?utf-8?B?MHllSW1acXFRaERZNGQ3Z0hUOEhaNk9VZW9EamZ3TnUxSHBuSjU3MUZRMlcx?=
 =?utf-8?B?TWt4YzExckN3aDNpYjcvVDB2eU5JRUIvQ3RvemF1WVhKUnFnVmVXdU53U3Rk?=
 =?utf-8?B?SXdCMVgzMWN4WVBJZ05zMUNieXVWd2xDRE11NnRGTUlqcHRQQ0tRUWoyNzBN?=
 =?utf-8?B?eTRBamNINjBMV0dWQll6TDVyN3R4SFVDTHc0OWVDRjFNckllT1BkWmtvK2Vl?=
 =?utf-8?B?dDF2czdwREp1ZGNGK0Y4M3ZtOEVWVkdlRi9ydWpvL2c3bTFPcnpsUXZUT3Qw?=
 =?utf-8?B?eFNIQUdOa1BlemxsVU9xSGF3WVFLeVFRUzdvWjc4M3RIRm5sZDZmRmhXT3FH?=
 =?utf-8?B?OFVTSCswdG40aTJTNmlHb2plS013TjBKK0FEb3U1SmVqcHBzaThRSG1VZnY5?=
 =?utf-8?B?cnBOYUhwU05heHZLT1Jvcmx2azlRWVV6d1JqeTJ1Q1BEM2kwdHlHQ0lVRW54?=
 =?utf-8?B?bDRGempaS3hSVWU4eERwc25tM2N1U2pwcGNJRFB2aEpIK3lFb3AzUVZXL0RN?=
 =?utf-8?B?UlVBdkMzaUpPQjdUcWI5eVc2YzgrNFZNQmZjTk1CUUdMeVNUVHduV25TWVFF?=
 =?utf-8?Q?gXMIKrjUDLT4afw4+CqSL7o14O1KV6t/cC1gA8xA7qALE?=
X-MS-Exchange-AntiSpam-MessageData-1: BdRDZ6Bnicohzz01vUlU4erd6Mqr19TvYaE=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d54bffd-35fe-48fa-bace-08de747262c9
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 13:32:56.7123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF2CtdowGzJgYyiscZfzrdS25IOr22v796Zd06C7C5mnfMLHMnUdkJzCWAlfjQ7bA8xQfH/VFnl1uD6V+waaXS+hWuc4Mli0+6LJaxC7Wo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11715
X-Stat-Signature: itkndxd4x7umux568cxqqohpft13dofz
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: A69834000B
X-HE-Tag: 1772026467-60060
X-HE-Meta: U2FsdGVkX18mKAQ9r6hlQDYHyFwhcYqWSR5iXuyji3fXNwGgAdEp6lod/VxvjeMqlc0RuHgrcoF6H1p382ctUZa79L2vqAHvAc8Vds31kysNbsZm/gDNfUP2i6RDBldPK/YlQ5uqv6gXDyjgiqibI/Dj4Tclhg44AVDmggXDroC7fyCGzYNgseZD1FKrwxZuUxCs/xtIv33Beix0K2LnlTh94iUTkfvlAPWJ7m8OJ+EuVoiPN0HFSvHJGMo/mmv3irPi1vZlY2wRw+LJ9xOp2zzy4er3rqKoQCHbNO2IDKi2dx8bL2G85qvF4WTOhqxWVnIBRnTBvlKKBK5QzzKnrS56ur6IgP4uFITwok7F0gifPQk2juUlBqBqAPoXx3KKkVL6bP+DqGxdfr/BdaANeWlScUNtrPBym4bUZoQf/mCb/t6grjaM2jf3W8Zy3PJuXQ5QyToro8dLYGWxfiN/0RfOjxI2HuLo6qTIpFLm0YF6N8y9BY2VBlMQQaGWDIb0/xkX+ISkOoha+47H+qo8Oa+zO5dnZXhXwUswlLFbLhbSLVcfSiKnFzKX7QIoqHtbPXPBG7hb8MGJEHJAT0Kd5jTR3Ey6lACWw0Rz6fOCRf6EWpWCt9ZJXcrWBLrbLqShXiKCa7dRRwL3PxnpJKTK3+R3zyw85Itz5t2aTSeeFqhLR7JAxzyLf6+iJB/U3eH/O2dtu6z4Ml/I+B6hAF9WQzKg1wjo2fztqrcczImfUBrl+JY+QzqEAUeVZ338xEtST4hnsz486FMwmElPUfiVKVUdCgyuMUuIqmy8A0QKVRqdtL7j4C0QNJb6zIp/klRt+6Rdo0SFlCBIN4A2G1nJghEDbCeWKiFXyaL8INzOOU3M3//TLfYZvSOSoLgZwqXjE/nkwsKqZUTh1rsjIfmhvvXUK3GvN0wWBNB9PkrdCJi0LshWHm+d4qUspBF327CsiwUGClD9VDt3cZ7PGX8
 28VSPE9V
 py8RNCMhKdbOuEc6gED7eiGG4r9cygzam3RARM8f9NdD29wfg2dq/Oej5M+Jv+Wpax3VNAoQo6FBv3NXsnh5wRdXPbJnFq/7FuKWfH+xuLztScNP3wgVvV0XkKoaTITXADXIK/zjASRicmuYuhufJbIuzpAQFGIky4CD9LcajCuWoXSUwrFHb4SPLSbzCLsOqT5a57ed1EYxSZSjY21IPL98srp/G63kJO/+XH4DQ8mPavC3bBDc/GnUMA1CUyMV3xCOwm6wY/m744lVmDdnaZabOjz6eJoJlgIPDS3JjUTVEJ7zY6H5sGLI5O4gGYTWb16dHhXBTZv8B7iH4y7SJhgJEgdXNFXOzOSRM5dFhTVmO/HiEctl5N13GR2s5ZMBNXDilqhLQ3hp0WDtce3UQ1aNi6+j4Do12hEqinlC4LTEYceuongEIO2AT8a+94+8q/nFOwhC+ZHI3Fy75SVr+M/ys6T/q3LsXGzwn6uo5bi+AggFu+fAyKfqBYG8dIUUDPpXQw/dWFcIKbvIhgtLompt/ndXP7M+rRziCF2ud6teErUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This effectively gives us an ability to create the pid namespace init as
a child of the process (setns-ed to the pid namespace) different to the
process which created the pid namespace itself.

Original problem:

There is a cool set_tid feature in clone3() syscall, it allows you to
create process with desired pids on multiple pid namespace levels. Which
is useful to restore processes in CRIU for nested pid namespace case.

In nested container case we can potentially see this kind of pid/user
namespace tree:

                            Process
                          ┌─────────┐
    User NS0 ──▶ Pid NS0 ──▶ Pid p0 │
        │           │     │         │
        ▼           ▼     │         │
    User NS1 ──▶ Pid NS1 ──▶ Pid p1 │
        │           │     │         │
       ...         ...    │   ...   │
        │           │     │         │
        ▼           ▼     │         │
    User NSn ──▶ Pid NSn ──▶ Pid pn │
                          └─────────┘

So to create the "Process" and set pids {p0, p1, ... pn} for it on all
pid namespace levels we can use clone3() syscall set_tid feature, BUT
the syscall does not allow you to set pid on pid namespace levels you
don't have permission to. So basically you have to be in "User NS0" when
creating the "Process" to actually be able to set pids on all levels.

It is ok for almost any process, but with pid namespace init this does
not work, as currently we can only create pid namespace init and the pid
namespace itself simultaneously, so to make "Pid NSn" owned by "User
NSn" we have to be in the "User NSn".

We can't possibly be in "User NS0" and "User NSn" at the same time,
hence the problem.

Alternative solution:

Yes, for the case of pid namespace init we can use old and gold
/proc/sys/kernel/ns_last_pid interface on the levels lower than n. But
it is much more complicated and introduces tons of extra code to do. It
would be nice to make clone3() set_tid interface also aplicable to this
corner case.

Implementation:

Now when anyone can setns to the pid namespace before the creation of
init, and thus multiple processes can fork children to the pid
namespace, it is important that we enforce the first process created is
always pid namespace init. (Note that this was done by the previous
preparational patch as a standalon useful change.) We only allow other
processes after the init sets pid_namespace->child_reaper.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

--
v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
task_list lock for reading it. Rebase to master, and thus remove
now excess pidns_ready variable.
v3: Separate *_ONCE change and "init is first" checks into separate
commits.

Note: I didn't find anything in copy_process() around setting the
->child_reaper which can influence the pid namespace, so it looks like
the pid namespace is fully setup at the point when init sets
->child_reaper to receive more processes. Thus tasklist lock looks
excess in pidns_for_children_get()'s ->child_reaper check and it should
be safe not to have it in the corresponding check in alloc_pid()
(introduced earlier in this series).
---
 kernel/pid_namespace.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e48f5de41361..d36afc58ee1d 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -369,15 +369,6 @@ static struct ns_common *pidns_for_children_get(struct task_struct *task)
 	}
 	task_unlock(task);
 
-	if (ns) {
-		read_lock(&tasklist_lock);
-		if (!ns->child_reaper) {
-			put_pid_ns(ns);
-			ns = NULL;
-		}
-		read_unlock(&tasklist_lock);
-	}
-
 	return ns ? &ns->ns : NULL;
 }
 
-- 
2.53.0


