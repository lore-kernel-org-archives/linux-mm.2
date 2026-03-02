Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C81E9B369
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896F76B008A; Mon,  2 Mar 2026 06:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845466B008C; Mon,  2 Mar 2026 06:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBED6B0092; Mon,  2 Mar 2026 06:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 597206B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:15:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D66E85C79A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:15:24 +0000 (UTC)
X-FDA: 84500866968.08.12EC03F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 793B014000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:15:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IkfK0MCG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RiqsWkQn;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Lan/UjQ+A9ifzpuJSW7vdMRO3CoXKhXPQH8pGaUGXg=;
	b=LJQI3n3eC51BuFeT55RqzsNKL74hfWbfj5IMQlHLhKJwlvxLHO+9btpykaorfXak8jzfIF
	RkJ08dbLtJE+hbQxQ0bbc1/sEhJRBbYNLIYMpmg/meAMmPL5tOFe3xCU1aAJtq7S5v+yuk
	UyyBOtpWxhYCtTo76BmHlJH7rfg8V5s=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IkfK0MCG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RiqsWkQn;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772450121; a=rsa-sha256;
	cv=pass;
	b=f1cubmr77EhFbB7syFl6yQHVnMT+wVvqSzGck8rM3rXzYopY2f3JY7c7rpPAnrZeqGHPcr
	DbWUslyYWlitHF+5rA/Eei0bxgQZj9Czc0ZNmMbNbMUW8LA6/+aFuzBw0DnQ8+uNCuDClE
	J9gGdsnIX+QrFmRk8uu+m5ZwZw8xxKQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229BJfs1739892;
	Mon, 2 Mar 2026 11:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7Lan/UjQ+A9ifzpuJSW7vdMRO3CoXKhXPQH8pGaUGXg=; b=
	IkfK0MCGXjjX2YdVfUCUsE+LSLq4T0wk5mOOhTyAHHJ2duH8jA9/l6/iAP+8p+f0
	leM7UYpNk4vRn6H5cZYUYH7Ixjm4WiZ5WX/mIumACKb/qJpQwH5H4GsOUT1ngAwv
	o6nMw9j8lGMEksQGa5JhCfrrMPa3HwJ+Gm0HsZkrSgUzLgpCbvGvqt5hrTyYehyd
	sfNWyjwKwuJFrYudCXo0oEfe7BkENd4n0tb7f2a7qtPxhn22gJ+RHeB2yUJphLKW
	XCK/TRg1wmEAatIpNIOztvLxZ+kZeFi2JrxHk3KyajTreY/PFHwCmPVjFSnQz1Ao
	G457QXaP3cL8SmWDiYg52Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn7pf87jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:15:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622A9mRb029830;
	Mon, 2 Mar 2026 11:15:07 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010053.outbound.protection.outlook.com [52.101.85.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8t8c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:15:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h3N1X+ykWNOwHuoDrqnaffrQ10atD+z4extIvECK4mGHIzYeB3Ku96z7C1tgRSbZnTx3Ts6lL/EOPEKm2bjgKwzrtYMYi9JmpOvIZUG3IdnHWc0kZd60myMOPsK6MwtOO4GWBPAOFKsZCwd9IeDSw2XIodK/cjGp4ugxCOLq1fRx74PbLETL4Gsx7afZmfa6CwsBooOhK6f/aF7Qzl5V3kFo6Iz0Jex5b3NBCrfrTrRh+yDHin1MZwFCVk+5fF4wrC7ghl1a4GG7I16NvQ9iQjuUVO3HifydZqmq3kXo7jqUUy4ZfVCku6XrxgLcMqREmzz8Ex72UVs//gHVTCRZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Lan/UjQ+A9ifzpuJSW7vdMRO3CoXKhXPQH8pGaUGXg=;
 b=N8d82KMqsW1Jnp2o4Co+rVCr5O6FiJmbCIUetRu//DReGXEby+fGSJaDHYVQJOEriJsWGgocfK0WMPnKE6sy9NmXXct2EzZjxUWLQ+MEsbrsuELNoubLypXkRyG8Xs1v+EFHZpy/9iCkKa9VOon11wZbx9diJ8oPaoF90R5PTkde4JFAbDQmxQOsuqqzQmuxoIgq/0lZI/4VszHIyvMmJ6HRwK/vnkFIQOAE64bCNFeA8Ml3rcGS0XIdm8vSZH97mjPRJdFN5pj0QQs9Qi17Oi5MhUIpkRdkkrKGHz6sPb90Td/Bze6YTpU92TCPGCIv9hg56l4O4Q7EvpQz+Foq3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Lan/UjQ+A9ifzpuJSW7vdMRO3CoXKhXPQH8pGaUGXg=;
 b=RiqsWkQnvqD0L+4XHQe47orUtasX8qQwzhVFPOY7Beb9Qi0hD/su37WFEki617rBnDfaVA5Q+fmb71coFklXcagFjxNm1Ewbo+9ZTW3Rdr4NWZ7HMGE26VOPBiNga81s/B+5v5J6SgWO1DE2aBMFb2VUkUJoA+ugEHQS4rp/5Lk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8563.namprd10.prod.outlook.com (2603:10b6:208:571::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 11:15:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 11:15:02 +0000
Date: Mon, 2 Mar 2026 11:14:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] tools/testing: fix testing/vma and testing/radix-tree
 build
Message-ID: <80c5b417-ec8f-4b1a-be96-a6e7fec1f299@lucifer.local>
References: <20260225233111.2760752-1-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260225233111.2760752-1-rppt@kernel.org>
X-ClientProxiedBy: AS4PR10CA0013.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 057b05a0-f434-4648-b268-08de784cf2bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	OQhJrbm6QnDY9wq0CqDgP5EM9CQyWRPqG7XpzsUY8BIuM5Xr/Ej4b1FQuj9I2bCVPMPzr7++n/EJJBGkrcm+i20xsettqZnwoOUdnPvNaPDkhLzilePxhu1mb1/kKI8DG8R0f6SBg6HYx1cUdIGadRvfcHhewikhswJh6L+pQFFBArMz+kcLwustA+6HWZeCX49DrdCmXMGUOzSryz6E7HlFKONWFyZa/7HzI4qAIMYAME9qok1F35NDPW06YBbbuASKMdCyMrn1X5IhaXkwAmirhaJlmWunFAAsrxRCnrkc+9qZtBYAmNWt/UPpRY8GGuQmWQx+fc5ZeYHDOlrsLbgoqVzZ3GWgFvVUqBoT1qtaWQljBGu76uetMbmfnh/fKWjWuXqmmpgRPfL/l1v2GgxNIaa8WLElmakUMRVZDKENceqwO9BEYGwidyXgKx1SYSRWm0oTJd0RdRgQJI3F3wEIbkYqe406c0GJ330xSlz0idrxFhvG+AW3Ma+ulPVqlkt8p8qoirnXu6oS8CVt57QkWC9L4tqqVEiaUHjXovFehVgYXxCm9dyS6dWEyENffeonhOMaJnsyDmBfEWTh9TSP+uTFkTZIZgxnD1bZ7eJAmfPMZS/IdqnIOcINp98D0tEteXvh6JsN57oyhfXDpRhND80qSlTeEBLb+OlbVi1Uz4SSOodNNsQ470InkaQjtOJnZUKEEmYlnq4nAwL1DVsnvCGBuAt3oHYEss/zpw8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDJDdXI1THVFVU4weXkzbk00Mk9nL2lRNkZZeWlaaWp4S0MyM0x4cnhQTER5?=
 =?utf-8?B?bVJ2RlhZYlIxRW82a2lYc1ZOVTZxSC81Vmw0UEV0dCtQaGd1SUgvSzBjVm1H?=
 =?utf-8?B?eXI2bGFqajh5RnFlbjhOUDVnMW9sUUF3aWlzcEsvVjlOWEdJN0taMnB1V3FP?=
 =?utf-8?B?Q0RyOVVoSnAzWjRSRm96TytmaVRSV0ZKVU1BTkZud1dGQmpYN1dFQkl3cXgz?=
 =?utf-8?B?RFpHOENiZ0diOUFFWVBpNHJ3emNRa3JFc3UwdmFORDUxbmdNN3krZ3VSQVRX?=
 =?utf-8?B?WFlGc0c0MnltVnpMb2NVVlM1REszbFJoWG01N3plV3ZNVWt6MlM5d2NmNjI3?=
 =?utf-8?B?U1N1d2JOV2ZucjJtWjBwTjVCc3BRbDlLYmpnMEJ0MmFhWWZ0SjF4NE9UcVJw?=
 =?utf-8?B?UXAvdGYxKy9MTVQyV2FnT1ZGN2daNWlGUXVnSUNEU1BJTzdSbmxQWFAveUE5?=
 =?utf-8?B?T1Y0MnE0QmRkRVgyQVNmd1NISEw3TEYxVmwvZHAybkVUUDRQMThwQUtEaGli?=
 =?utf-8?B?RmlFZE1ZOFZjaUtzQnJvQ2VkOFZ3aVZFdnZtaWhlVFhFdFpWYmZiQVVtNVFo?=
 =?utf-8?B?dlBMWCtiNW4yWUNxUkNkRnYvM1B2c1ZKVGJLbVBMbFBYeXhxUEs3YUp2ZnEr?=
 =?utf-8?B?N1hBY2dieVF4ZnBzZVhuWkRWVmp1azJUMk1UNE96TXJRR0xFcEtLeDB5Uk02?=
 =?utf-8?B?eXNhcUxMN3VYYTNmMnd6ZkI3bVZxa0p0S2xCVUYzbU1vRzdaYmFETjRRbWg1?=
 =?utf-8?B?NTM4djk0ZlJSSzNlUjZhU0U0a0JpRmlyU0dwc0lXQUdkenZPQ3pGYTh1byt1?=
 =?utf-8?B?eDhsNHo1ZWwrS0dxQlN2TTYwaVZicnh1R0JjcVFjbWFWMlMrVjUwZ0JpNmhy?=
 =?utf-8?B?MlVhUHhKdEhpczNHSW9UQUozQW41b2REUWNYaFBUcnExTTJ5UFMxRDc1V3ZE?=
 =?utf-8?B?bHVPZnA1a3J1L0ZNTUIwOVliUXJad3BmMWF1c1NlcEJDamVrTy9mS1IxZkR4?=
 =?utf-8?B?RFNheUh5Mlo4RG5IM2NJUGwxU0VMN0VJZmRKU0tGVWR2bXVTN0dQWW1SeW55?=
 =?utf-8?B?QXpra2tmaTBNYVJFQWlqRkJuYXhZQWluSkhKL0pTdWYvS3VJVndrc1VSNDF4?=
 =?utf-8?B?cEVFazc5NWdtUis5Z2I0dXNHaVlBb2ZaQlNHc3EyaDBMR3h0anY5bExpeWJ6?=
 =?utf-8?B?cE9BZGpXcVFFTENwSGhTK01kUFloZTNtYlV3K2ZmelZWVFZPcnl5UUpBUjcz?=
 =?utf-8?B?Q29aNWJtUEp4VG15SE1vQ1kzR2tKcWEzZFB0aWN6Y0lDczZZTW1oWkV1aVBF?=
 =?utf-8?B?LzhCN2RWQ0dSSmFmNWRSR3BPRkJEUFMyUm83ZERMSC9IT2pXU0o2L0t3SFhH?=
 =?utf-8?B?NThSaVpDaUJxVjQ5WlR1TnU3K05pTXlhaDM3QVhjMENTUXF4elpiY0V1WFRp?=
 =?utf-8?B?ZEsvZjM1NWtuMC85VVJuWmxxZ0tkTXdtZ3RqNkpzZk9GdXJrMVkwd3dXSjE2?=
 =?utf-8?B?ZjVDdThYVEU3cFlZSjBLd1VkZ2RGUVVaWWE5clNoa2NQZDlvd3VJUVJxZ3pn?=
 =?utf-8?B?UjNFT0xIY2VWUGZqNXlJaWhSSzNXV2VFSkV5aEo0Yk5VdHZsdXhDT0hTMzNi?=
 =?utf-8?B?dGlYNFBXM1doNkl4clZxZExZLy9sK3dCb0RjT1JsZ2tuUzF5c2NvbWxrNTRS?=
 =?utf-8?B?TGt2QWRKbGVZVlNGeHo0V3FBUjhVRTRtemQ0ZnVNMk44Rm9ibjZVQWlhZjh3?=
 =?utf-8?B?TjNjRGw3SVNHVzRvSnByTEU5Z1BYcmF4Y3I2VUpXWkNzS21TNnp6QlJXeCtq?=
 =?utf-8?B?cXE1aTkvYWNaK1FtaDRhVDV6K0FOdmpJSk9Rc2EyNkRsYmh0Y3VwMzFGOFJm?=
 =?utf-8?B?TkVsemtzWmxvQkhnaHhSVlNSYW8zRGsrWTJWaDRLeUdjbnBCejMyRWZqME9j?=
 =?utf-8?B?a1BqL1psSEtEb1FyWCtKUHdUbkFzbUFON25rTWYrS1NCK0pZbFdINWNxZko0?=
 =?utf-8?B?dmlRVUJ4K2pJMW1YMjJJZFZwS2RaUDBESE9kblgya0NUQ21TNncvNC83L1h4?=
 =?utf-8?B?RndFQnFQZFUzcHovWjlGV2RYMmw1VE5TbTRWcDFucFVDcEZMT21vcEdWam10?=
 =?utf-8?B?a09wZ3o0VlVncEYyVWtwOWFleVhVS2JvcU5vcHdidzVRbURWbG5IMGpDRkNo?=
 =?utf-8?B?QXJ2MXRpSC9BTE5pMUE2c1hiWXhRbjlLMk13VVYxNDFPODZ6VE1hTVRQOElN?=
 =?utf-8?B?d2htM2xIb2w2OXRkR2VWdGt4NjNWV2VFWXJaeC9NTEZvSElPemREWUYvU2cy?=
 =?utf-8?B?UzI0aGpPU3VlRWkwUTNUbCtSc1hOcjZna21aTGttZmxoZFBRT2gyNFl5OFdl?=
 =?utf-8?Q?cifaom3WyeCtmNH8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ogzxBqcR11IfzTA1iEtPnH6uvgyuaLyWMp5AwpKm8/Xh2l9H3ZTCuLtH9bXWeAi1AOGQah0jeyGLWX6nMgkn8jlBoDL3EnAQXkkNWMqcGxU4Btnf5NceIoMtZwx6hEgao0yRJ32+qFjAUqBy4iEXqK58FGMbBA1Svx4baDpuSCE4SHUbyaBZHD8DWVhfxV7TyHAsj1nvQ1MhBvG24y2VRfhLoRKSHz/vk50uBKMN/D1zyvCGapwCgIs42W0rKyq5sL8fWWJ1nH4OTCQ75a1W0cJq6TkM2o+9EcgdfrbrHjsw8HvofW7qcgCJIonarAahsAlE4nYLM2yXr8yIDFhjK4Sqsx55/tSxMxqK9XcNb18QtRmv7VgGY/mi4ON1rVn5AaQbcfJMaJ9YPEncFZRZdTXgL30JN+Y5ochENqOFc2ysEDorVlhJjoZgXTeM8nUaJaa8YpQnX2+0rNOkHIvjCB3jsFGoicIypkFSntO98jp0sP/Tcr6xCW3xuMVmQYpyxlOC2HyOOXeo2LIzgSQms659AuIyjd7EpjgvJ34r0Bz9fI7FWJecuGhQZzgEFUZA7+TU4ZMH1kakLB0GDBVOEQpaAiLdlTunP/5c92ylis4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 057b05a0-f434-4648-b268-08de784cf2bb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:15:02.0005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: su740q8Aio7xpFQ1+5YuUxvgOkH10lCqA8FRHbysAbUgkCtEB2/ALJ/WEz5aSfw4nwi2RFkSJq/X3o79VaglaodhckFmn2CdY8YWl2uylkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=864
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfXwx60KHIsysTe
 p2YqzXLqi/YWyF4ia9m9imo8qyDBIMVWlw+Jd6vr22iOC4vhzqjJnrLIgO4SwBcBgDk7hN8gHi2
 q9NR9EX+GHQkbpGflDPUrywkSnxin01s1gk6A2eaRLwIXAk35XuTuzoP6s23RUr0gF8qOleBb1u
 8jT+XVd5mVHCKjYX0rk/B0uyNuxflCOs+e3KC/L+AIpHw9DCHquGFZzAIWb5X0jorVkP/M3O/mG
 rjiC4FFWb4A9qadoERDl0e2ee5gsCGbwS/Shc89Yeljr5sHIl4ot2bpT4fFtzKKvYNvQUbBW0p5
 Sgy+z4pukqVov1aP+ga5crytAMkZJa10hpnLr9Gjy/DqnTOjBFuAUZBeR3lPva6cFJcG7fabo2m
 0nQ4sfAfhF9Yg5JDF2VptynntQ2Xb32iIB8ILUyNe8DTCqwYTw23sqBIuQqj9iU2Z6MHRNoSvrW
 BgyTlwpFElOuLDKbubw==
X-Authority-Analysis: v=2.4 cv=Vcf6/Vp9 c=1 sm=1 tr=0 ts=69a5713c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=qrOO6S6zVJSGe4mIsFMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Kg6Ijd1uyY056_k6ZCZm8KAFWoo6gEYz
X-Proofpoint-GUID: Kg6Ijd1uyY056_k6ZCZm8KAFWoo6gEYz
X-Rspamd-Queue-Id: 793B014000E
X-Stat-Signature: ikhbjqtccraa899meaap4q6mrh17eqis
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772450121-374179
X-HE-Meta: U2FsdGVkX194ZzDf+Bp9fPb7nSAlOz88s4rvFvZ27KSrUqozUBkp9KxN7Vy2KasJQjY5KGePTN7ph7C34iF1wTeKUtwGU0WOQld8STdYfUlXWJxkLiLGeAIHnl6yp2tRHtdmG2zLu0d88jwwVCw2biACXKaWLEoR+9EOu3cQ31rGlHv1F47r0E9aSDovD+dxDGMNI0EBp7KrwZOmBDGnRmemcznQe6ZL38Ji3Fgc8c3GnFwRx8PAlBr6jXDKpllrb9C8rTsk/wo4frRexxNqbu1fBme0KddhgwrJRqKKPkbd8SbwIzQVHhYbVTYsTP4VsRmeOTv0yl9Iv41DxbUCTLq/iFAAMT5PM8ZGl/XFo9zi8DLyphvStn9rBoJrpxJd8l1CauIpfE2176nQvtXmsEpZ9FPlPo/8bqR5ujYwQ8yrmvKCxeMafFjpF8Iek1gm1CnJIjnpenDn2yiBqfUPUd8slP99c5+Lisvqbi3kLpDDEI2j2duSpkxQ/jlllT+4bmEca9AWhD714641Hr5fh84IAK6pJSAOTo2hT3CBpUewLe0tZGu020eHG2dmkJ8HbUZeiMXVrFexM+veKPEqmq3ayUoe2rFmGZS4HurG4cdp6iQVNFmuTck2jgizoTC6W5zEQvoCLrjy87nRP9gjdHgVBvw5OloseliZ99Pee2NC9j5hkqBZ8gqiCfaiYSnxAJUsx2f8cwEpADfnVYVjYE75TBTS6c2MCXJyK24GeiEuy8emvAe51smsP5RJLJsKtV8du9rmSFyoHAlfCXMoI/n9+uPZ9RvMieqDdCywQ5rtCR7hnPPwmQ0O0tUX+IK4oQYkgCkbkJgVm1w1B5BdFEbjrIT7E5fdpK0NUAPa5bqfFKUlqSFG19UmRWqhs7CdKHiagYtHnNop5qRMVYZHFt0/alkX2eJR5nlxrUhcbkm4WnAuuSYCNsNvM0xFcsG7sBC4paEADgXfDVOjIsH
 tbNfrerD
 nXbsD/pe0VUWg5mSNX7nhQY8MRTby+3Jy6G7HXQrz3XFE6VqfgSzao8WMdLIx5IqJyUSGxfo9j05lz7lu0uC4N2wAFZWe6Aft7orIzhpkWCASpfDbYfM3zQT4kLjJ5ZV+oFPvYxQoZ15VstjXuLscuu1DV/FltQxmHh1UVgFy2o6qKHCNADKcFACghGCgh9nzrjzZ4at+vdWN9U1G3AyBDUBUOzWUCDGy1+A+PfMoGcDUILI+HJmooGavrsvChkPieQ2THHQJxWe4ghfABn/6jw8pR9vKXeYDi96Tj3OYMNjrFjnGmINLkEEs2dxpBCVWene5y8wHy/uzHiUUTEK+Yu6Q0Ot3Pd4L0LVgzClwKeqmnqv+eDI5e8kNy7IIlQ/cTw96bUGlmGZc3WfrN1x2rbTmUlu7yUHkthyAOiwiL37F69EG/dHsz5LyEu2oLM0Hhvc39CIdsKfwmwhVzZ+p32heckUjIKIWffmdU/G8fUM+47LpNrKpi+Zm3foYnYTz30DFHxQMkZt+uWvu7lgFL+xONhL+MxZqWgems0k79kBcEyoUqoggJfkNgSx3ORSESIZ0/J6gQWIN74CY6QOVcY0csSj8CEAzF2q2a6G99T1fxhrIq4Mr9dXw7j7RPz6paYYTZdu3kn1TXj3RTMfpKnBgQtPyIyoKueSaE1x6hgwkFQHQCYnZbTCp0CimAbHYvJUFkhd8lth7i6esM+Sxz20o4GP7I18BZqUP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 01:31:11AM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Build of VMA and radix-tree tests is unhappy after the conversion of
> kzalloc() to kzalloc_obj() in lib/idr.c:
>
>   cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128   -c -o idr.o idr.c
>   idr.c: In function ‘ida_alloc_range’:
>   idr.c:420:34: error: implicit declaration of function ‘kzalloc_obj’; did you mean ‘kzalloc_node’? [-Wimplicit-function-declaration]
>     420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
>         |                                  ^~~~~~~~~~~
>         |                                  kzalloc_node
>   idr.c:420:32: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>     420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
>         |                                ^
>   idr.c:447:40: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>     447 |                                 bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
>         |                                        ^
>   idr.c:468:15: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>     468 |         alloc = kzalloc_obj(*bitmap, gfp);
>         |               ^
>   make: *** [<builtin>: idr.o] Error 1
>
> Import necessary macros from include/linux to tools/include/linux to fix
> the compilation.
>
> Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks, saves me having to do this :)

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  tools/include/linux/gfp.h      |  4 ++++
>  tools/include/linux/overflow.h | 19 +++++++++++++++++++
>  tools/include/linux/slab.h     |  9 +++++++++
>  3 files changed, 32 insertions(+)
>
> diff --git a/tools/include/linux/gfp.h b/tools/include/linux/gfp.h
> index 6a10ff5f5be9..9e957b57b694 100644
> --- a/tools/include/linux/gfp.h
> +++ b/tools/include/linux/gfp.h
> @@ -5,6 +5,10 @@
>  #include <linux/types.h>
>  #include <linux/gfp_types.h>
>
> +/* Helper macro to avoid gfp flags if they are the default one */
> +#define __default_gfp(a,...) a
> +#define default_gfp(...) __default_gfp(__VA_ARGS__ __VA_OPT__(,) GFP_KERNEL)
> +
>  static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
>  {
>  	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
> diff --git a/tools/include/linux/overflow.h b/tools/include/linux/overflow.h
> index dcb0c1bf6866..3427d7880326 100644
> --- a/tools/include/linux/overflow.h
> +++ b/tools/include/linux/overflow.h
> @@ -68,6 +68,25 @@
>  	__builtin_mul_overflow(__a, __b, __d);	\
>  })
>
> +/**
> + * size_mul() - Calculate size_t multiplication with saturation at SIZE_MAX
> + * @factor1: first factor
> + * @factor2: second factor
> + *
> + * Returns: calculate @factor1 * @factor2, both promoted to size_t,
> + * with any overflow causing the return value to be SIZE_MAX. The
> + * lvalue must be size_t to avoid implicit type conversion.
> + */
> +static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
> +{
> +	size_t bytes;
> +
> +	if (check_mul_overflow(factor1, factor2, &bytes))
> +		return SIZE_MAX;
> +
> +	return bytes;
> +}
> +
>  /**
>   * array_size() - Calculate size of 2-dimensional array.
>   *
> diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
> index 94937a699402..6d8e9413d5a4 100644
> --- a/tools/include/linux/slab.h
> +++ b/tools/include/linux/slab.h
> @@ -202,4 +202,13 @@ static inline unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
>  	return sheaf->size;
>  }
>
> +#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
> +({									\
> +	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
> +	(TYPE *)KMALLOC(__obj_size, GFP);				\
> +})
> +
> +#define kzalloc_obj(P, ...) \
> +	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
> +
>  #endif		/* _TOOLS_SLAB_H */
> --
> 2.51.0
>

