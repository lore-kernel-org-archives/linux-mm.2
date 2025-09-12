Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3544BCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937B58E000F; Fri, 12 Sep 2025 05:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F508E0006; Fri, 12 Sep 2025 05:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D73B8E000F; Fri, 12 Sep 2025 05:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABBB8E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:31:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 188261DF6FA
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:31:24 +0000 (UTC)
X-FDA: 83880080088.18.EDE52A4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E37E140008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:31:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nhvsm+K0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W0Erf1Oj;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsGkyFWLuPaEGsmQtTalMpeuNWauV8vcMB1uLFVZ8xo=;
	b=aY8iN4p1a2YFCNxSdMKFuUe48a4ptRZ3maTUGlgMvXvD3u6VTt6TyuOBV9jA+t/WfBlObA
	O+8/iiIprZefWLWT9LMs3TlnviD5pEEfPB9JQMDWdgn5n3dV2bZUKIcPWh2h8ma6Re3/XT
	B0thvAkHBhfPftH8AqQwAu2yNcSvLXI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nhvsm+K0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W0Erf1Oj;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757669480; a=rsa-sha256;
	cv=pass;
	b=E5C8AaaVtDhRCD7RPe5z/woj0mGWDa09NL0zCzJX9rDCj8+gli1KZv84Uyy7V5Q0okZUhm
	iqveQ4k7jp1I2LOn8NJkhXQgV9H9uP+iOcdyHV8MDTyXSER5yFYqF2ryEvyTYDC5L9vGEU
	NNbRLgUEJhDGoRI0xNg7H/Z7pPTWXh0=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uQoD016809;
	Fri, 12 Sep 2025 09:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tsGkyFWLuPaEGsmQtTalMpeuNWauV8vcMB1uLFVZ8xo=; b=
	nhvsm+K08jH/bEwfMwii/2KovbXmNZZdizdMKKxYFGuagpUlQV6HJFIsKuVnNEBF
	wg+6VBuBMXu42XkhTT8UxDeMmSD/hajilM8ypZvcbwTEsQd1bdYv/TCQAUYZZHsy
	E3ONhEhFJGt2MmMRyezMmXNExAe/0+0z4pmgcscKJlS3fWNz11dZFdfYcRz/rtPZ
	Wjnw+ZDTA0hAMsKTCmyr4zytnpJVXu1yoaOBFSnITXpw+Pe+SzGDhgGdZg5o5gpX
	gN2/I13EG6YrKv+7GLJJSJkPg3G/dmtLvhL+meq3HlZz5RJ9ubqdhnY/VTvKTTwl
	+3ChMVOfZBG12E8XSHMmFg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922967xmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:31:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C8K7jC002755;
	Fri, 12 Sep 2025 09:31:01 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011026.outbound.protection.outlook.com [40.107.208.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdm5q9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:31:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3j2uxxPMxmWd4IH0GmIpqW0VYGa7RiJM0y0j+MYWzCo/J8xUrvaO6/duJdieUnFIrlFTgUzcIMtg40Ff8s6/C1ng4t61AXKpTnArC2vPZQkpwEkEbP3aE+AxdOwzC/Zk3VyS2IEMJHknNj08Svx9p1hEbUqLKPng/Woz4wmaJ8yoxThSraVieeJcparLJsqWl5wv2HQ0uA+S2mXXXSt6ieRWVJvsTuINtWHrYOtFNR7XnDytWEdS1jVrnTQzrq3gTzr/YNfRfwcNCAB/KXVdAUr4QqA2rGNePve2rqxGpjBKBsA/8uSFIb1ilTk2Z5HKJdvTfsrg0PdSTcwsIwCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsGkyFWLuPaEGsmQtTalMpeuNWauV8vcMB1uLFVZ8xo=;
 b=mEQuC3lzEbJkbH4H17LgkP2yh/3RM2iYkSkeOKSwHvPKQQ9PkYd4lf0RYMp9z+vthDCJ/vE7nMyyfMXm2/T3eM1HFIL4y8nH2z5+pAoiKLR6g6FAkvcL2iXFfUBoIY1PswgHhgDjz4JpFb3Tmy9EhdwwjyPfv6blo/+fogwufwk1MU2iNuO0MF1MbFA+URZqiPI3cyAVmyh8G0k85s0fNb/dIaMUk2Yxcu+YKzPwraZYa9BMCprOmAViju7XUV0qF3e3/3x5C+HIVigM14wwe4IunYaMmaiHEz0CwOYiy14X0bRSyv4HEso8DemLk3/BTX/JyYPPysuKdQ3wWMSIAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsGkyFWLuPaEGsmQtTalMpeuNWauV8vcMB1uLFVZ8xo=;
 b=W0Erf1OjOP2kSBANd+xkgA7PZULMGWcD/LhJVZFx4g5EI7HxFivUjHQv1e+vW5V8BTkIg/a8ivtYxjCaAwqfoEAHM8odJLTPIGoqWeWAtRO+nRyaey4w86qO/RnRNMMHwyNF3hYor4XhdhdgOmjn2dBCSAd0H9U4F46Qprw11MY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5126.namprd10.prod.outlook.com (2603:10b6:408:129::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Fri, 12 Sep
 2025 09:30:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 09:30:58 +0000
Date: Fri, 12 Sep 2025 10:30:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
        Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
        Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/15] mm, swap: use the swap table for the swap cache
 and switch API
Message-ID: <d5f84730-c7c0-4059-a5b7-061a9eaebc5c@lucifer.local>
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-12-ryncsn@gmail.com>
 <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
 <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
 <CAMgjq7CtYpe4sEYaw2carqGskvchV9Z+1yn2Wa3nMP2VguV_eQ@mail.gmail.com>
 <223c560b-0234-4203-a11d-661656317808@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <223c560b-0234-4203-a11d-661656317808@linux.dev>
X-ClientProxiedBy: LO2P123CA0083.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5126:EE_
X-MS-Office365-Filtering-Correlation-Id: 638c310f-f8df-4eb7-3286-08ddf1df14a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0wxUjVObXlpMUkwMThIM1h6SjFKb1ordXh6cmxPenFZZjBwaTh1N1FLREFt?=
 =?utf-8?B?d2pqWXJyRzRkcFJjS3o0eGFON05aTXJjRG1vVnRiOWxBcmZqZFFRd014MFIr?=
 =?utf-8?B?MXRRTUVXeE5KQjN1YjdZbnVnM25IcjVkY2ovKzYrc2dGWE9vZzZNc3ZWSEJO?=
 =?utf-8?B?OXBhUVJudTRYUnNxbGFnMVhNVmJ0eEtSTms3ZGp1clJYRC9CWUNydGpheXNV?=
 =?utf-8?B?N0p3Qk9UNm9hTExBZXdTK09obWRVL29zSjhsQVZJV2NpYXZrcStQYjlaNlVG?=
 =?utf-8?B?QVJjU2tqSHVhOXg4YnU3a2k5cTVxVFU5aEZSVUk2N3drOWpmb1FtR2FXTUNH?=
 =?utf-8?B?MHBNV3NocUlGU1NQQmFnelhNSzVVdUdxV2NEZUJFVVZJTHcybUhuUk15bG9F?=
 =?utf-8?B?dDlDNjU0RXRlcndkdDhRYSs2S0llU1FnUGI1WUZnRzlIMGR6ODdFMm5CUXUw?=
 =?utf-8?B?VVJ5TFRLOVN3dk9xQkNPbm1ZMWprd040VmllZFc3WXhLTi9RN0VBaDV6M0tx?=
 =?utf-8?B?anAwWlNKK3pzckxCK0JNcmk2Z1hrNjJkODRkSDVLWGFTN0tjWFRVZXNOYzNB?=
 =?utf-8?B?N2VjY1A2bWkvQlZYMkE4eDFhTXNoV3BQcTkyK1pWcGw3SkkxUE0wSXFRMGRH?=
 =?utf-8?B?dk4wdjFCZU05bjE1U0hZSVAwNnIrejI2alRobmU2NjE2cUU5TWdYMVRRcUVQ?=
 =?utf-8?B?aVB6S01SZVB4bFBaaDVQOXVMV1ViVzlSY3RVaFBQdFZqbTZsM3kxakZiZkJM?=
 =?utf-8?B?YW5jWVE1YmJIdlM4NU9OSE4yRXFzMkNxWUtpNTlkRHFVSjQ0WTJDbjBIZUNM?=
 =?utf-8?B?TG9nbDA4NjJDQS84cG5penFXS3B6QVRwd1NRNG1Tb3Zza1ZRbXBOcjVXczFp?=
 =?utf-8?B?WmRYTm1BamtVdEhaMDN2NmV1cUFzaWkwLzBwRE5QWkJqRUZrRmxxaS8vSjNO?=
 =?utf-8?B?d3hkMWJudmdjb2NOS2ZCeVlieXZ5SFoxVEVBM3RlakhNeUFrV1I2MlpITHNC?=
 =?utf-8?B?enhPOXA3R1RlNndUM1VXc1RZUjNhZjF0YkkweE91dXBIZ3k2OXNjQld4cmF6?=
 =?utf-8?B?cUpnRUxYaWI1YUQxVUxFTXNuTFVvaVNYeWxEVGgxY0hXVnZQT0JFRTl4OGhF?=
 =?utf-8?B?N0hJOWJpQXE3aFFiYTFsUWdkVXo2K1FOVGVZT1hlTUlyLys2bUdyUmNuc2hp?=
 =?utf-8?B?bzFiOFN5TGM3NnF3VzJJM2dWa2VRdktjc2VlQnBrajEwakNZL3p5KzNSUTJ2?=
 =?utf-8?B?VkFkdlg4dCtRM2E5bWxreVU5RURsNTZqK1pXRjkwYllzVTgxbjVKWHBNRjMx?=
 =?utf-8?B?STFIUVhJZlIzbys5QW12dlJhTnBXclZzQ1BZdGNHMlFwWDZVTFpZc0RRN25m?=
 =?utf-8?B?LzJ3UnR5WHRDOFhJRUpIVGxsUExWSSsyaWUvUUJjdUZDa3Y3RmZmQXEwUE1s?=
 =?utf-8?B?N1pVd1MzUnhMMzRJSnh5TEN0UVBMNDBKcS9VNTVEckVvaFE2YXZ5RVM0UkhZ?=
 =?utf-8?B?bVRuNGlGdW4wLytMLzltT3NZMnA4bWNQOUYxYkNKNWlQWFpkNnY4UWdvWFR0?=
 =?utf-8?B?ZHc5cDhwckt0dTB1cnV3ZURWRHFBeitLR2E4S25aMmlOaSszTTdRZEFCTDd0?=
 =?utf-8?B?YTcyQUs0V01FSkJUSDYyTk9PN1U4TU1xSzNTU1VJZHJmUENxYWd6dGMwOVRm?=
 =?utf-8?B?b25ITlhici9Za2tabDdjQVFFdWJSdVAwV00xQ1YrQmNkWk1tT1dDWUJ2STRn?=
 =?utf-8?B?THI4ZTg5cXpVZXJXSjg3UzZkWjgxelRpb2w5Y3pneEJsajZNVE1sdGNSWi92?=
 =?utf-8?B?dzdyaCswZjVRbzNIZ250T1V1NkZnR0pNbUNnMXhwSXdNanNEdGU5VTNDVGV5?=
 =?utf-8?B?QWVEM2IzZ2d1S29NN2U4K2JsVndzbGlRUzN0VVJXS3BrajVtUjlabENwZHZx?=
 =?utf-8?Q?qJ0XuSZ3XWg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTBOWXdiUHJoS2s1WmRuNG1UeERXNnFJQTdXeFdIU3VzSnVNSURBMitxTEw3?=
 =?utf-8?B?M0FXc2Z5YWh1ekxtMUkxS1ZqeUdmWFFFNzhGejhrK0g1K2lIR2xOV1lrTVha?=
 =?utf-8?B?Rk9WZVJJeUhUS08rNlgrQTA4U0hyaGx5Q1Jsa3lKbzAvWDFSVnJFMzkxdnE4?=
 =?utf-8?B?cVJJay9XS2xUdHp6N3M0SHRWbVB3RlRlNUliQ0pYQ29abjlMT0NJcFd4dUt4?=
 =?utf-8?B?YytSZjFBQUxmSEJEL3hrN2szOHRqaVowdExaZnNUcFRoWnFoNHFFRXZHKzFN?=
 =?utf-8?B?cUFCdnJwcEVUekNMZzZnWTRDRHpJTGRTNFVBcENYM3ltK3l6NzFUQ0c4ek1I?=
 =?utf-8?B?czd4ZnRkaTVPZnJxN0VQN0Z0WW1RNE80dHBMZmdUaVBxVDZkSDRoSElMMWpI?=
 =?utf-8?B?L0huV3VXeXJIUUkrMlhVbUpNN21VNzZPSklpQ2hsR1d0S2lTYVZPbFpRckdn?=
 =?utf-8?B?NEVDTlJYZUxTZDZmTWMxeUI3NE5QZlVneU9BNHZGeWF3YWR2MGhQc2lEMERP?=
 =?utf-8?B?SkR2dE01cnJoRlNyM2pXZ2l5UFI5RnAzQmU0T2F2YU9VMVJYc1VJRVZ2RzVz?=
 =?utf-8?B?ankyQ256MUFmY1ZJZ1R3MFVNZmFTZ2VlR2J6ejBkcHVsczFZREp6bEhhTENQ?=
 =?utf-8?B?RVNGbG1kUDQyYk5ZOEZLbXlieE1JcmhZQ1g4YmoydXpnY1hzZFRJaHlIajNF?=
 =?utf-8?B?YnNvQ2JzWEZtMmVhQnFiN1N6d2pjVG9renNqbGJ0WWR1N09IS3R6OUxnSEVB?=
 =?utf-8?B?aUxBMjUxRjdoT3RLYzVqQzZWWWRzZmFZSzM3eEUrelUrVVdPTEFGNW5wbTFi?=
 =?utf-8?B?YU9lM3ZDQ2V4aUhvOU9DYzNnL1JJSG1HNTdJRTdQY3pwTER6TDlnS1NFSUhP?=
 =?utf-8?B?SnhDWm83Q0FZN1RJcHZWSWJtK2dUTHIyZWJJcW4zNXFzTjZkcjg1VUlJVHht?=
 =?utf-8?B?Szc0Sy9PdVZNS2dmZW50dCtWQnVGWGRiZEdmY1VMSFI5WHVlL0lnSS8zbTNB?=
 =?utf-8?B?YVJXd2sxMnBQWHkrdTlTQkFDNllLeEpYWHZCSkVIb3YyZFFuWGFqMEJNR1Nr?=
 =?utf-8?B?WUV0RGZuSVhzN1BOZHZRZFJRbXEzTUlyb0RyTWo2cHUrZDZVTG0vbFBudG0v?=
 =?utf-8?B?Z01PNlhiNGpJbC9mUmY5a05uS0MxVkVYMS93b01tZFBUM2VyZmtid1hjRE96?=
 =?utf-8?B?Q1QxaktldnI4by9zTDFZaFlEdlRZY1ZTd1lSb0hjdEpOblFsd2tBNVNOT3oz?=
 =?utf-8?B?Q1ZNNDVVcENnRnJwZk5mSUJUUHYxY01wbjNCaEliSnoxUlExY1lSYmVlK2lT?=
 =?utf-8?B?K3hVYm43Q25UM09ZMHNGeXlrMW95WlA0K2RyV0JoNG5hWnl3b2p3czZpVXJ5?=
 =?utf-8?B?RDgrazRvZWhKaTJpMFQwellSL09VbWE4L3BRT0NGNVM3RVo3L1JSSysvNk1L?=
 =?utf-8?B?a3JTZldoZWtIVEZ6cUx3SzNOemFWM3JFMnJ2aktNZkwxYnl5aXFaMENLc1Ez?=
 =?utf-8?B?bnoxc0FNYTVkS1cvV0hnWUhCZjgwZUJtaFhVK2JpbDdtUVdrYUVnMTZ0QmZD?=
 =?utf-8?B?dnluVnV1QmltMVpudm1WK3ZPTFdhV3hkQXNmblVHUUNPdHJjZVNKYXpFNGdS?=
 =?utf-8?B?emdKcmxBUTFHSHlYSFQ2QklkV0Exa0JNVFNCSDlsVUdMaTlySW1VbEcwTXBY?=
 =?utf-8?B?QXBEUXRaWG5RZTRTbU0yQWZNR2FSUWdjWVJtVDc4cGxZNGlwR01zTEVjMXR1?=
 =?utf-8?B?ejg1RTBxbUprSnk0cWVGWWpPZzZaTGpoSlRzU0tiTk10K05mdVBVL0M4V1hH?=
 =?utf-8?B?UXJFK0NvY0JNa1c3SldrOTE3WkNnRGlDNTFjelNwVEYraE5XUEhZOUMwdm5W?=
 =?utf-8?B?Z29WWFlodW8zZFBNSFp0QUlXQXg2MU1ISXNkSDRrejFFZjlXRDdMUHRYbTZT?=
 =?utf-8?B?WDZXVXJCRW9FV2NBcjBkamd2UFBBY2VZeVBxamI4OGliWEh1blJiRHo5Vnpa?=
 =?utf-8?B?cnMzcHVMZG1GK0JDQktjelhvNnRqZVFtanI5VUFBcjRHcTVsVnRCMVlldTdu?=
 =?utf-8?B?WGdGREpzQWdyV0lIMGpDUGdhQ1h5bGFaaWVFZUFCODNHa3Rqay9FN1lLZnhT?=
 =?utf-8?B?UkxmQVRQNzRMQjd3ODJPVTdPdDRxQjdlZjhEVmdmb3VueXQ3NGlvWWg0VW95?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3SZsJfCfB669gvRyVfaWOQUCPVftLQJcWLDkZDKWnyAHgq4nUE1TeiyekLCsrvbcWwQRD4Jc6FJBoeHwj74EsZ1anRpN3d4NrsIfuu+5gj4s/NTWawq6HjG4VVOCItjpr5fzlG78ei5yoIMLiY2y5oZIRWmcsEzeMD2bpjQNYnrZlqWFFnUCCvJUTxXn++bUEoY0iRmw+BdQVdK2T8CiUVEkFEdLViOwuqMrpuRylpTK9M+q0g9EZu2lex2kJ7RKM8c3nfpPlAHCXnTl5iBSduSoE0/0pBB2IE9EnvQrKp2Y2qnBeAGn4HzrhUFOmy1/X5DqY5qWaNMh6EQmZJ1uj0tuBlyWmYl7X73fh0glZPqKd7s71QJzUlkIQuZVsx7l6pQB/gUx0moAixhYGrP7339LkGPcOloF3NKcxhrTEpqK7cpjcenCKxklCfiImVgOEU3VGtrWLjJDVvQjjbjKBIWjSMW//wXPqYNd6SGtnN6yazgHzEQZysIBpaRataVxqLrlGtxkazMfkh4SnpdNHFfCq+0zMxstGq1Xn0bIAusUyEzv9d3Xc6ZZ2m3gac+ORKf9ljP/ZGSYY/BR36qk+lQRN5XBL9ez3AXFvBZSXQ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638c310f-f8df-4eb7-3286-08ddf1df14a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 09:30:58.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5MGPh/Z8v4RD8YOAuh842Mrx4gpbRjhC6WRePCc0FUfFj3yJsS8JgjAwBuzopwKLm6RY9eqzyk9F6nB8baJ3+aM9sHGdbSsDh6G0HDgAkjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120089
X-Proofpoint-GUID: 7mwuqag9AE5rTcnMOcyeDfGRvO2Msh5b
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c3e857 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=fYbhGPvKPZ0hst4Z:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=JsIZJZhev9T1LyQr-swA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX5jpFdGefQVMx
 5+M9D6vjzOCTEHH2L4RhBQ0LH+oJ1nKSzpIVTp03TuKbGa3VCQ8qVO3Q+1CA0OejYXI7d/12eE5
 oPTJ8s3OFS3uHRmVw7F8lHEwdAHEpF7Dcw2R8CgDTx2ePV3dy2sBm8gOsEixXHjc6GiSj5Zplrd
 GGsB+wGCDQRD/ihS2x2/Z3hHBSQeKMjBeHC0/A++8FyXsgPnuBbqJ3sWrZE2S3lQs1rDeGCTJ8O
 z0UGHCEmbRjCxqMW/kQzK+cM7xLr9Bom4ga7zAug93mGkJWbdOdFA6WI7cmC1ZzbYdgIEdpDzIh
 mieyrH3a0inx6y/k8ppbrCxsql5xjkOzsv4wtJI/piFCCj7PsvWtySW7e3mxILYwqUVdeFlDSPB
 meCIrrKKwR0+DAIJh7lkQz64J/B2Ug==
X-Proofpoint-ORIG-GUID: 7mwuqag9AE5rTcnMOcyeDfGRvO2Msh5b
X-Stat-Signature: 6m5jqxfi36a99969c5zkunr8opuf5rez
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E37E140008
X-Rspamd-Server: rspam04
X-HE-Tag: 1757669480-220169
X-HE-Meta: U2FsdGVkX18pmIfav5TisU2It7ZhQFWb8is+tyrxNlO5Bon5f0I4M91hSJJuLBG1+BCQs1drYAKc/Aa5cNwQxnvHZa1olQ2kyeHJcxVHONLsHNN3n7WbLVBHBlQYgYM4k8o5A/W9zFb3kMVkDaUjqSvcWremhO/y6ilx5LKMoCN7spQVCrU81y9j6anPd/jubpPqgcnVOqNZDEKDArxHRPxLu871JcmE79TJ+9zCnWqp6+VXoLOCCxWKH/Sk04a1dD2tt6Qb6PLJeYCov3b9ORmc2ryN+Uky7zoMQo1qmvR3Cs9l5Ua4U5cLnJF+V75q578yG5zyH6BMd3fEtLxKDz3s5VcY3hpVVyoZ4f+jPgTo+Z5GUH2i3qED+kJLZOvzuGpSflVGOnFNXoflNrpcNfXLzjSl1LtQiTrE9AbzrWnkxmGMeLSvI9xtwpKbQ1goITcHKzUYACxyzCRHBfFhgl4IWbkHh0goKT6ueH1Xh0LgXjaJmwU4kWwlNewuHJbulqL5o/wip1oFidFXlm5TISqOT5jq5/pnw9UZAFHeJQWVrW/nFYsytOZImjtWNyS00ugbxk4bCiUYjnjuedr09XHAL47xQ1L2v/DVnD+icI3wUQkLZqMGPmGwZJuk3Q8p7mZL6V2cHyFexigVi/7DtLaKmFzpWD8l5whX8hqJNgzGfmsezAzVVbym9ZuFpuO8YdjTRIbYogpwviYsA8wN3pS/jXNoucfKzW3AnWovRUX5CvO4+pI+HY9FXT1Fxm29uKX6+eulOmIBM37gVqN832U2hp60YQkmGX9U6dlTCzrB07RrrrLKSalv4n/yf4VolbUEjRrhqcQdEbFdgDPMxgtCam0dURhBLQdx5a4kvw7ihzQevMLhLuYCnEuBdu8IDCj2QDwbtvlx6BEa5p2TVw1CY5dup/NYbS5QgwHVY8u7QsT9/VJIfvIOrBUjej4J6g9SELZX8DxlQewYpx3
 gr76sDOv
 VS78R982MiEF6pax3jhYnc37/D6g15aOD3bWWzOEupe3ic9KhVjpRcKLgU6iMogENOLQUB4ngVWcMuznjgEyenab5ZIjbXngfN4udmYuwC8t4lLV38Y3KzHI1ElS3jPpxdXdIv6LxhEmLr4IxQJb9XC84E5vipDgAtfLgeOIfG7YrhKgsQKbz40s6SQEwKL7pw5JeqVPP85lI53eJODGhPk1ywrGa4hhRxsxqYoxbhpDbctHmID2aO0d7ZFcI9tvJ0BHB6q90olxPCsDr72kIgydpqKs/B0mBsFM6cL+Fjk32j3nAmTWn84K3lCL6x1GpSexvm4I/LZZJVRf10R2D1erLT0sh7lkIKLuG+7QZNU/Ib5o3z3PQjNj1P6dDRj+Ea7LLqu53fXVKwAlSPIrrqc11OMTd5Sq2OK24qcUDi3kRVJkC0XHw0+K/FOdczF8mEmlt5uKw52IphaBf4LsaDq30ENNa+QZCmhxb92/JKDpVky6Eqe9KosbCGQJBLLe5yuZ4W00F0qGNKdTrt0kvnNX7JCqRRclqHp9QsU7ycZy3StrlahDqWJy0Snlu/s0zTDa9YsWysBpiwl0jvfAsm0jsEYcZx6qrJXTOss+FmN+6KtcAKI4Org/zfoCQt6tGmWp+upaVSjTGM6cLMZOSKPiguotfQJjc1PLpjHEO7ZxWsP5qqtAX478hgNRqcgf4mZtHqeIPQFzehVD0HrNSp6rzY5CvhD9pH92FyZ4hN1ovU5YIXhaGIkXpzrCxrAnDbXJM9Reh0CrMpVyIGY0KQGZNRkMuYdjNKREAsGlSMWJPRpg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:54:19AM +0800, Lance Yang wrote:
>
>
> On 2025/9/11 10:48, Kairui Song wrote:
> > On Thu, Sep 11, 2025 at 10:34 AM Lance Yang <lance.yang@linux.dev> wrote:
> > >
> > > On Thu, Sep 11, 2025 at 10:27 AM Lance Yang <lance.yang@linux.dev> wrote:
> > > >
> > > > Hi Kairui,
> > > >
> > > > I'm hitting a build error with allnoconfig:
> > > >
> > > > In file included from mm/shmem.c:44:
> > > > mm/swap.h: In function ‘folio_index’:
> > > > mm/swap.h:462:24: error: implicit declaration of function
> > > > ‘swp_offset’; did you mean ‘pmd_offset’?
> > > > [-Wimplicit-function-declaration]
> > > > 462 | return swp_offset(folio->swap);
> > > >
> > > > It looks like a header might be missing in mm/swap.h. Please let me know
> > > > if you need any more information.
> > >
> > > Confirmed that just adding #include <linux/swapops.h> into mm/swap.h fixes it.
> > >
> > > diff --git a/mm/swap.h b/mm/swap.h
> > > index ad339547ee8c..271e8c560fcc 100644
> > > --- a/mm/swap.h
> > > +++ b/mm/swap.h
> > > @@ -3,6 +3,7 @@
> > >   #define _MM_SWAP_H
> > >
> > >   #include <linux/atomic.h> /* for atomic_long_t */
> > > +#include <linux/swapops.h>
> > >   struct mempolicy;
> > >   struct swap_iocb;
> > >
> > > Cheers,
> > > Lance
> > >
> >
> > Hi Lance,
> >
> > You are testing V2 not V3 right? The build error is in V2 and I can
> > confirm that. But In V3 I've added "ifdef CONFIG_SWAP" for the
> > swp_offset usage in swap.h. I've just tested allnoconfig and it
> > works fine on aarch64 and x86_64.
> >
> > V2: https://lore.kernel.org/linux-mm/20250905191357.78298-12-ryncsn@gmail.com/
>
>
> Ah, I was testing V2. My apologies for the noise!
>

OK so my bug is different then :)

I think the issue is that you're not properly checking for:

#ifdef CONFIG_MMU
...
#endif

This is v3 (I see the #ifdef CONFIG_SWAP) btw.

So swapops.h is wrapped by #ifdef CONFIG_MMU which is why the declaration is
missing.

The below fixpatch fixes things for me.

Cheers, Lorenzo

----8<----
From 5a3969a438af9c33422a45fe813a44068d784b2f Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Fri, 12 Sep 2025 10:28:40 +0100
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 arch/sparc/include/asm/pgtable_64.h |  3 +++
 mm/swap.h                           | 37 +++++++++++++++++------------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index b8000ce4b59f..b06f55915653 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -1050,6 +1050,9 @@ int page_in_phys_avail(unsigned long paddr);

 int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
 		   unsigned long, pgprot_t);
+void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
+int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t pgprot);

 void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 		     unsigned long addr, pte_t pte);
diff --git a/mm/swap.h b/mm/swap.h
index caff4fe30fc5..18651687fcd1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -53,7 +53,7 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_MAX,
 };

-#ifdef CONFIG_SWAP
+#if defined(CONFIG_SWAP) && defined(CONFIG_MMU)
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */

@@ -317,7 +317,26 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	return i;
 }

+/**
+ * folio_index - File index of a folio.
+ * @folio: The folio.
+ *
+ * For a folio which is either in the page cache or the swap cache,
+ * return its index within the address_space it belongs to.  If you know
+ * the folio is definitely in the page cache, you can look at the folio's
+ * index directly.
+ *
+ * Return: The index (offset in units of pages) of a folio in its file.
+ */
+static inline pgoff_t folio_index(struct folio *folio)
+{
+	if (unlikely(folio_test_swapcache(folio)))
+		return swp_offset(folio->swap);
+	return folio->index;
+}
+
 #else /* CONFIG_SWAP */
+
 struct swap_iocb;
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
@@ -442,24 +461,12 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
 	return 0;
 }
-#endif /* CONFIG_SWAP */

-/**
- * folio_index - File index of a folio.
- * @folio: The folio.
- *
- * For a folio which is either in the page cache or the swap cache,
- * return its index within the address_space it belongs to.  If you know
- * the folio is definitely in the page cache, you can look at the folio's
- * index directly.
- *
- * Return: The index (offset in units of pages) of a folio in its file.
- */
 static inline pgoff_t folio_index(struct folio *folio)
 {
-	if (unlikely(folio_test_swapcache(folio)))
-		return swp_offset(folio->swap);
 	return folio->index;
 }

+#endif
+
 #endif /* _MM_SWAP_H */
--
2.51.0

