Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11AB2E73145
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 08:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F526B0088; Mon,  2 Feb 2026 03:39:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD416B0089; Mon,  2 Feb 2026 03:39:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174F86B008A; Mon,  2 Feb 2026 03:39:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3B4C6B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:39:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27BB31604F0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:39:58 +0000 (UTC)
X-FDA: 84398868876.22.0292FB4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id B5F8F40009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:39:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pvNGNCAf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RwIzGDGX;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770021594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9GJVVXbkCacDZ5GxU95w7WLPyzmjAXKrz7FGGtO3A0=;
	b=HHPsN6WLCEGsopNcqaqxWDPpNssYcpELFER6z9JJa8+GmVXIpa6Tu6dbJRQ+veFDA+jzpt
	zKL40f/pHVMzWcq2RAnhFsFACBIGt3YCcSgZREzF8EhmUlXjXzPXHltjM58eIESlToz4Dg
	1paxg+CoOo8bhHs0PbC0Q5Mq0aE3+gc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pvNGNCAf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RwIzGDGX;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770021594; a=rsa-sha256;
	cv=pass;
	b=mLmdUVS1c1iqyiEFkZkWty7JnjRbfDdT0ZIoIPy7ePfOeDdph74uZIto8u3YxUHLw5asAS
	j8ZIjmL02oMJW/5QPum64YCPZU4pd9OEGLQGCVRNQSDqCV9aZeB4MrbZqcFYRQtZSNGVuW
	9iNBt/DTL/pQVl61xo6toft4kZt23LI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 611NBPqV1236739;
	Mon, 2 Feb 2026 08:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s9GJVVXbkCacDZ5GxU95w7WLPyzmjAXKrz7FGGtO3A0=; b=
	pvNGNCAf2qXmzfdHUUHSSmMMih8kocma0Mfowo4dhdsB4nqZVwzyu8Or1qepKxOW
	tQIaWhnSGMbRu+aHaXn42AzqKm1ifJBgpos9GJCqQUEmwa8YQkyuajbv8XUrMJId
	vCDCZcGuPKLQ7zs5ZBaTcgQr55Haw+Sjm+6e6xwLcx8rQdOdAwv17J9khkzf8sMn
	6EpuweuaZcNy2+OIoh+RHSvEyqs22O86yLmqirjUey2QeMJ/d2bkWzYT2yqp95CV
	8BjN1sdeFGlZWAmb80JxKo5tUDpbt7IWSAf54CFX0FH8KKKrtmNdRp2wYXPaTNkv
	Qf9nISWI/UsVNx0tLDtQow==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1atm9twt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 08:39:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6127Ksio025788;
	Mon, 2 Feb 2026 08:39:50 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2576qdwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 08:39:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDjN7u2RMCPLI6U0SptXOOjF5exO6GNNGoY7sSo6o1uupTkUNeiOmJkVeAsbBeHCg1GfYvWhtZEtReQkSqrOut2c2mltEQ0wAbcFCHeJ1E17fDuIeDYqS2pkY9PHWEzxftuOvdsya881toHqDhK2/BUKlcl09qnOCPx6tC8pL4+mVcFmf2p81i2yHam6N9urP6MdpObk1zlL3rf07C8Ha7K4cnP6SRC/Sz/gj6WnfkuAH4eOTS1KDNdUfFl9xQN6vDiMCPjg25wTVQIHcn4ozIsvfpk0d99NgII/tOeah/ULALtuvpfks/xPRupThIwUcZvUElL/qT+bmZ/z4Qxq7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9GJVVXbkCacDZ5GxU95w7WLPyzmjAXKrz7FGGtO3A0=;
 b=g3uVgX6jLwUFEq6MetOMFUg0CiXKz2x8Z4T88NZ4nFFGOVzEVyXTPd+tQY1pdbB9I8wz9eBINaO/OI8ph4m+w0lF39Bv88PF4jcy4AJvDEapp0ivPz60aR/4ZhWs+WlsnNgzTU/Ix7BIL+sLP3KBcOAjvwgQWBDM7+c4xYukgwCJ8cnI6RnvhYpNc1bLkk8m5IC3v90ezyanzZYsKQTAeVLSrMblBQ/DNL5RbX8jATVhdEomrSdYDLt735Aht2hjwpx4xafb7oLR3pGu3r27VjEI53HVi5K7bt+qztpY/aeVhvO/h7PJLILUIrDFN54N8A2NqgVmkFIdOVxDGZq5mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9GJVVXbkCacDZ5GxU95w7WLPyzmjAXKrz7FGGtO3A0=;
 b=RwIzGDGXyM0fl+sxWiSqKNGWOOoWnBLGwog3tLAOPTRR9daSLKNwKWH+a5KLnk+MZ0gZuPsYV3yU1BHKUkCPrZjDkd9sVOPkJpRDqK1KxrLXGk26U07m6bWmZgq3elgEJRk6kyAZlbwLjknkDyLKrmiJhMnhsVFyz14JPhhry2E=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH5PR10MB997717.namprd10.prod.outlook.com (2603:10b6:610:2f1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 08:39:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 08:39:47 +0000
Date: Mon, 2 Feb 2026 17:39:41 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, vbabka@suse.cz, akpm@linux-foundation.org,
        cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Message-ID: <aYBiza9L1hmhmXbb@hyeyoo>
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0203.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH5PR10MB997717:EE_
X-MS-Office365-Filtering-Correlation-Id: f32b378d-cf26-4b87-60ea-08de62369f67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmd5bThjYUNBSmFEMmpTcjdZdWlEandMSzJjWEExdXZ6YTZMcTdld2hJTGJz?=
 =?utf-8?B?blV0WUduMWV6VFpzTVJqQUVPYks4YnpjRVkrM09tQTlKbE9TelhoakNxR1Jz?=
 =?utf-8?B?U0o2d01Td0h4OExBNzlIV1EySFFNR2l4bDdpOTllam91TENKd0s0TmMyVk1v?=
 =?utf-8?B?UDdVa29XUHh2MzVVVEJUaXU3eEhmSWJyRWtxNUZTRXlMNzZIMDRxOFNpOHBr?=
 =?utf-8?B?L2Y0dTBVZUQyelFyRHBhclIwcGJNN2RQdnhxK0VGN2NNclF6SFlLUFVKVG15?=
 =?utf-8?B?NVZiQ2MyZnByQ1FRczNSdTRrNUhiRnVKWlEzVGdXaExkbi9kczV2WDNrR01D?=
 =?utf-8?B?WDZ3K2xqNVlIOHAvTWN2aWx6aHg4QjVDRUYwSUU2SDB0ck5VdExKcDVOMEYx?=
 =?utf-8?B?Y200TnZHbzRHbk4yR3JUUnhqZkpvUW1OVlBkY0EwQ2VwNURTcW5UMjdUbmVU?=
 =?utf-8?B?MVhzUXVLVEZLeGk0aCtyTjlBYTFpMEk5MTI2bHRyOThXL0tRTmhRMXpaMEN6?=
 =?utf-8?B?a1VXOXc0V0gydGc4L2hYdUJmUDlnL21jaG9rUGJtaW1mL2EyVXZ1Z1RnNnBE?=
 =?utf-8?B?UDlseEp5eTFrQ2srWjZka0hFa1hyM1V0by81KzAwQTJseXJ1VGQxMmNxR3du?=
 =?utf-8?B?cHZjUVU1SWVjL0VkQ001VVk3WDlDQ0dMVjlFZWdXc3VjbENvcUZnMUlLOVV2?=
 =?utf-8?B?ZHlZdlBQVm5yYmFwODJBc05ObXpsWmFycnlrT3lmNzRkTElWWE9WeFhHTVg0?=
 =?utf-8?B?WHFEWmI3dkRFQUk2aFNiU0U2WHMzTkRKNXg2MmNBdWVRL05LVWdwU1FNVDZP?=
 =?utf-8?B?dTFqM0FHVGE1TDdPMU9TdGd2UExlT2hLcmtYZEtqRDJwRzZHREpLM0MvVFlz?=
 =?utf-8?B?S2NNeUJ2bmhvdU5UODlRSnRlM0NjTm9HRmFVTE9kL3lNSTJFallGRlUvV2Iw?=
 =?utf-8?B?THdZRkNZTjUvVUNIK1dWemxaNTJLLzY2WUVENHB6dzYzWDBBelFnRVdYNkps?=
 =?utf-8?B?cUZVdWc1ckJONVB3eU13UTRObll0QTBqNmxrVzUrYUZjdnp6U0c5RzFEdFFD?=
 =?utf-8?B?Ymp1QjVJN0E0Zlp6ald6VzdWK0YrbmFGYVk4bTcrdnZ2dnJqRnhNR0VQV3k3?=
 =?utf-8?B?ZG1laVM2MFloWjVYS2doREwvYmdXU1hDQjFPdlNJdjBCUGZLN3IrUmZRY3J1?=
 =?utf-8?B?c0J4dW1aOVk1NUQvTUl0ZFVseG9QOXhWeVR0M2ZBYllWK09ubmhubExKcWxw?=
 =?utf-8?B?Z0h2dkFxSEVjaDh3OGVpQ1dPV0JjakozNFltRlpDWkJxRVdKcUdzWThhbkZQ?=
 =?utf-8?B?ejQ3eXFFTlRselc3cHZNS3FnalN4azNzenMvODdub3hxZjJOdlJ1SkhpY0VR?=
 =?utf-8?B?Nk9zZ0dhRW1JYTVpcmtNc3RYRHhzdDgwZzJCT2pvQWJpS1Btdm5ZbjRvUDM4?=
 =?utf-8?B?VUlDZVljNEtoQmZyMXJtMEs4bGFSQjBpYjJWVUM4K0c5MFl3c2EwMXlrdUYz?=
 =?utf-8?B?a21PZVJDOE03VUtJYXNuSzdtaVRKQUNYWkNYc2dRdWFYQkQ1dHBqSHVWVnJv?=
 =?utf-8?B?TG01RCtuNTdxRlNPcEZiaU1PM1RlUWFWTkpPTmtYb1A0bWphRHl6d0lkWDg4?=
 =?utf-8?B?K2tuZFJFWU1oVDR0eXlLeE5QTUFXWUhhZ2NpTGVMc0IxSUtKdHIxd2g3L2Jt?=
 =?utf-8?B?UUQ1OHFwenFCdkI0ZU9sS3Nwa3hFUnhBUnV6NEI5TE45eUl0S09ESXI4cnVy?=
 =?utf-8?B?SWNMZDFmMnJwOHNOWlJtbWVhWjF0OGFFL1JRQ3RRdENWZHEzbk1sRXkxTGVM?=
 =?utf-8?B?YUhRQWl3WTN1M1AxZTVkbWJpM0l1VEVWTUdLNzBxWkt1NEQ0U2R4TlpMdXVN?=
 =?utf-8?B?Z09Lb1NsV0VJSkI4T0pnd3JTMU5wN1NiVkZ3QlNsMWFoOWh2ZnhMYVExd0pH?=
 =?utf-8?B?S0RJOUFHVUd1RHFYTzBDM2pZdDFOWlUyMFNQOUtUMFdpZ0FtNVJlQVJ6eWdU?=
 =?utf-8?B?Q0M3UGMyYWVJM01RdUNWR1ZZQkRFZDZwcVpuUVdwQytzWTdWSlFlZ1RUNnFH?=
 =?utf-8?Q?N+nnzs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UE1mRVoraGhYWHdTcXFkeERrOThtYURLRi9aWHY2bXlPaEw2VG1pM2llVDcy?=
 =?utf-8?B?ZW1td3lKRE1DZDR0bWQvREdGZ1gzTWpaR2lBREppbW9ROTEzaG9veHo1NVRD?=
 =?utf-8?B?bnM4TXhjQ2JGRlRaVGQ4aGNFY09VbFVuUldHTnZWKy82LzcweHV1S1o5OUk2?=
 =?utf-8?B?RnFKdW1pSFN0djFPK05EVHZQa0tSejhhSjkzYnFPSGFTT2xPSjArRFR3eEps?=
 =?utf-8?B?V05oc2MwamZ2RmVWYXZlNkNYa2lBMTRMalVsNkllei9tdzZ6eTBJS1NOUGZL?=
 =?utf-8?B?aU5RK29rME8yNE9hSlBYYkdzQU1pN2RBWjdpNHFaWStNaVJPUkg2T0ZuK2JV?=
 =?utf-8?B?UUgyRjd6QmI2SWs5OTlMTmRtZjVMbXcvNWQ4a1I5amJmUGhZZkswYlI1UjRW?=
 =?utf-8?B?QUNOQzN1eHplY1Y4aHVMRDFYQWRGNjJxU0JNL0g4WDFNQnJQSHYzVDVpQmlm?=
 =?utf-8?B?dE16Q3FRVjI0NW51S000OUxidjVBQWIzbXlKR3lWUG5ZZVNPZ0FOL21xSlFV?=
 =?utf-8?B?TFhzZU41REFsLzdIRVNRZnovV0toMG1DUmJIQWxUbm1tc0VNaFk2b3pmdXYr?=
 =?utf-8?B?WmN2clZ0RmtjU1JONnJ1QWoxN3h3NWl0aFFqazFnTktGOXBQVmJzSVA1YWR1?=
 =?utf-8?B?ZGhWSkcramFJQmFONGpKa3BlY1pxL28rOGUvMXk4OGVKcFZtcEFnMER4YkdI?=
 =?utf-8?B?UnR3OXpZK21iKzNKMjNxbDRqeWtpZW15dzlnRE1saHZuV1h5VVhVUS8rRm5n?=
 =?utf-8?B?aXBXS1p6bFZTTUZBUml4cEloSy90UDl3ejd6dzRKTjlTbWRTNnBITU53bUox?=
 =?utf-8?B?U1piVUxRY0tyTnUrVHhOcW1Hbzd1UUJVRnhTZW5WSUlCUEJnQnB3Z3ArSDJY?=
 =?utf-8?B?SXVwMmJvUm5XdHI3akpTcEhRcEUyNzFXZlBYY2h6NWQ4TXRwSzZtZEJlZEts?=
 =?utf-8?B?VkU4OTVLVGZuSHVrRjhQSkxzQnBlbzB5UGdBMUt1Q01MSXdxWUgwYVFzNW5Q?=
 =?utf-8?B?Z1VXYmZ6WkNmWUFuQnhiRUV5ZUsycVF2OVJmclBhV0RjcmhYcW5uWUFRWVJL?=
 =?utf-8?B?TkZQZzF1Q3NyamxOVzhMNkVwOEtUekZCb3N1cC9IUVRDTy9OUVc2NU1QdktC?=
 =?utf-8?B?SmhOemU1VSs1dmttdXE3ZElHMHlMWUFuWDZrcEFKaGNEdURXaFYvTGpEMEpT?=
 =?utf-8?B?ZExHUUlzOHF4c0VnUHkxMjFQendEU2E0S1ZrY0xhUjV3SkhyWFlXZUhVZ3Bw?=
 =?utf-8?B?U2VSWGJ5Y0U5Q2pUMDJjb0k4ckFCM3Z1Q1lZQ05BeWJZNWtYaG1ZYzhaY2lh?=
 =?utf-8?B?SEJCWnN4T3BQU29wWXFGUldGdjJIWmIvTEdMb1Vod1BuNkMwTTB2Y1MrSjBD?=
 =?utf-8?B?YXZKdTAydjBZaEszbDZkSWRZQXV5S3BoZWp4dS9lSTdoNXRRMFlXUjMwc2to?=
 =?utf-8?B?MWFNd1Zkc0RkanRqZHBla3VaQjRQcGt1ZmxMeXE4VS94dG11SW41bXRadmZS?=
 =?utf-8?B?VW5JMWlxblp6azFpdmVIWnlhdVN2a2NPRGs4VlFFN2VJY054bGxKRjdVckdF?=
 =?utf-8?B?aGlOSVlkUThoTE9QSHlqYjVJRHhJTXFLYXJLZzBHRU5DMWFyMFFwNWRLWkdZ?=
 =?utf-8?B?SlBsWHFpZXBNRmsrWWwyeW9kOVJZdmRZbXJZdmpCOXNrUjhlbjRKZlU1M1ZH?=
 =?utf-8?B?dkg0ZW13cjRFdkJ4V201TW4xTjAyeXpFNEZ1R1V3RTFaNHc4YW9SM0pTZlht?=
 =?utf-8?B?bzdUemRPbXpXcGNlWUxaOW9uTzcrczhwTlFQY2xuaWhlNWlGVC9kUEdDL09y?=
 =?utf-8?B?dUdadlR1R0JCMHlFMmpRY2xhNDhOdlNBRTBDTkR0RkMwTmpBK3NZa2hHSndr?=
 =?utf-8?B?TUVnRGhBSndxdjBFWkJ5WE5EaWFmcUpuUjFzZnBsazdHYUptd3BoTGdFbGU4?=
 =?utf-8?B?a3UwdjN6SG10S2FWTU40VFhEUWM0dUJvRlBzZkJ3NDZOWXR0azJvSGZYNUcx?=
 =?utf-8?B?RHB3N0lDVERZT29DVDJsYUxpdG4vQXZqRUVXRjZvd3RHSk5HRjNpL2FEc28r?=
 =?utf-8?B?V1N3Vy9hSzRpS1k3aHVIcUpobjRqSjlkZEMycXRXRFJPeVNlNkhsNWp4WnRQ?=
 =?utf-8?B?OVZhSkZVQzB5TkVOVnNMUW1vQkxKRmhCMzYxVUEwcDc0K1Exd1A0S2lBUWlE?=
 =?utf-8?B?QkNwQ1VyV1hnZEhzaVM4bEVJWThLM2hBemE1OEpqQnRFVWsyQ2tyczlaMHVv?=
 =?utf-8?B?THJMeVE2Y0dQNXBXOS9xR1F1eU1rdkQ1MGd6bi9heFBLWlpIN2xFdVJFRTlz?=
 =?utf-8?B?RVJVdS9RL016M3JBbVAzcGhTTmM4L2sxcWZocjhNVkxIeDMrbW43Zz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oHOFUdZweQvFPAhvkaWZosVqozlwIq9JLQC2alHntJcId0JTvwxgMj4I1bOU512MYoLCDPQV7N7vuCWXaEi0CUmZdeGooNQwvZ2wPKFtUd2HAlKRQw2OyxhXgP0vecSP7Pevg0BqaLctQJn1TAiC426f/E6CrwXw8MaKVgyfPIcP4IIm5qiDJ7VBaDRJCqPmZYg4lujGKpdqzti9LXLfmouxrx1K2g2MRPMl/AkGYRw4wOgntT+mJyrepTwsGMDd6fn8ZRLWgVgScM/sxmNwazdMFHK57zY8/aghLFGk7+iNXDYhgZQXV/LCbWoYeWss2GqmgncJKz6TOn+Xq7mNQ3SmStfk9YLz38nK96o/EtMhEncVekwtbc5FcWzcFOYGwgFlk6N42dyd/Os9UANDzCd4aE7r7zLHSl03O9Ed6u1RIaaO5FJSXqQZAbZeP1UZfKNni67WxMEFLMr9UIIVlIQh+khtR3P6RdydpNxjTsh6SAOEJ4effD+opc847SKDa5wX4drInZW7KMPBUvhOrTibGl8NRaXzK+6h0jjA/8rZcE9FXdM5SMYFKoE1sbtWn9BhUqDglO9m7+JhXqcv2Jrpwk1nDq+OvTo+SVtAiqQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f32b378d-cf26-4b87-60ea-08de62369f67
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 08:39:47.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gc6jEKXTINpcJwhF3VRVBzYHeTuQDLdHMkyrGeLyROjhA4qgd/p4s87lrZGb92NF5cXG8AGDNpJgAjPpLHHQ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR10MB997717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602020073
X-Proofpoint-ORIG-GUID: kxq3rC54oBz9hoYuZeRCdqS-RxzmPPXL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA3MiBTYWx0ZWRfX3oeiHbA/PkN/
 /Dmfh2kvf0fs8z9YUKCgRlzp5qW+rUAhdMV0vH5NGbJJKsI/c61lqbxjv6bTo5k5A1RN/Z2j3q9
 TKQNziJDyzH8DrwnVGM/9AK/eJlSE/UkgZf1ABPziTwNHPvsQtnZNWtdNkcWXaj7ZYg8zSH6UEe
 eQSw27XUSt7PTTxOPQMk2LzQrpsrBCW0bVqPQ2MCuxfcFINNDi+tN/Cps5QRZd8EE0dnymQMs35
 xWbhp3aR4aZ8VBzSrmwAByFEEY3KvE6XL20H27Kd4EfQAk1X4a2dRw8wqW0yav1Gov5SD11K1OS
 RJRvebCJVZuovGFZK0at3RQ20g3VwHiSPG6XM10J7su2HkqxSqTlGDRAZxa/Ze/0i/d0I9UUR24
 zT93ewIBx0ud0hO04hqXmFHk6UVEjOrFF54dWu185t5IKCKCAtGHyFCcX8pERFGgmrTk5Kl4OaA
 i6ojfRolnzuphpVmVV+nOHaw6l7s6lFg5Hq+xWpU=
X-Proofpoint-GUID: kxq3rC54oBz9hoYuZeRCdqS-RxzmPPXL
X-Authority-Analysis: v=2.4 cv=E+nAZKdl c=1 sm=1 tr=0 ts=698062d7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KJafJv24AAAA:20 a=Fr_jvMHkAAAA:20 a=KNUzIOaGdvwRfaY80VUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13644
X-Rspam-User: 
X-Rspamd-Queue-Id: B5F8F40009
X-Rspamd-Server: rspam07
X-Stat-Signature: opxoqxg79oawf878wyfk8ka5x18e4ftq
X-HE-Tag: 1770021594-759555
X-HE-Meta: U2FsdGVkX18uWCvliqqn4ZD6soAtWOuJc2YSeWZMiKZOu6u5j7pp5nssmdqC1eCSEuyJJ9YCWruj4yogH0dYCf+NXj2AofE9Qz2tN3oQAzn8MHWeKjF7zzlyrmKtrMM4v3YLMW0BHkppobI9pz1JFwy+bOhlzJwiuhFaW8f3xDIgwBZhkd3GUl+jaDzd763YEW3x2SJDfQCf1jnFYE8lvnTywbV+PJay4Xlnfj4QOWFF89GGiXHQtaZQPTwTxgl0pVqQAKv1cYejSdap+sJYlp2wnxSpxT+Uo7FLrbUlyD3cvzmtR73l9Fv9/G/KWgmU7CGnZzvTFDuLHj7hn0S8LuCBtZzazjSh1AXmmqnYgpZeV8Mvc0vJqB2tGmnMQBFMQ/5jypxJrQavNXVBnwS4YHEanJIvy8wT2PT5x5bSKpVb7ERo6q1stcKVTjrAGFVF0IQSVE7iEYeDeCL6vGL4z5udcjBex1sGi9evHkXxdhlauHGi/pgJH1zGEwAghARuarJFQxki3hsIODOK6JkjnMEhcRAWcOWk/x4ac1t8zyEc6aCOOX066K1v1vaWNoTVgNaS8QkqcOJw5HHO9xryx0MbSbi2QgpqtJTw7JAKXk2XPeuTjF/xVSVaqfcvPw7baI43zzKLdKSGgtQIAqmpuoJdA+2aHr8Cces+JTV0ZDaJk6JqWXFuYSFkyXmxek8W3CG/cHUmVB+y+n7dQtwqwEwq3J4UJZfmtdZWj7PTIvwPKWgI47QogJ9JeUiPYGb5mmUkFywa/vUcleVhXQymZ5byxnSyeNiPAF320auhcZb/2Tq2h87+JOQ88z4PgPunQQDbr6aDX+5ilJW5vnUszu3EMb9Uc6wyCc298R5GtS1iA/4yuHQda0wThEax5CIP7nzxjhohYtS0ERv8yRy0UolNbW5AgOw9VROz4XI24B4/4URNjye+PrjShtXng/3CDq6AWtlpLPti6dhvMWB
 O1/JM1nD
 4WbnlH+5cbrGPY0So9GmSkSX8G0rLI+qmYSfkss/D7dsGaboZ9Yi5MN0z+/uhWpn/9FniihhPT8UUvRXjKsE5BilJl03vnFVztgN6hV527n7aM/4TMNmkAfVOplWoqTYW1lJ71ZC9nJu7xpoM9y4miZh8n2w5qLto4s7hObNDO+tcbYNRclmQ2tebQEwLU4F8vy6toRqmlhNtnqctqETkYnhlpUa+w3OmbdzsJrA/MhYs5TrBUu3wBY6AZ2XV5a2hh3V3OVsbsjFI2qFpWyLeyoF7zHvdN+EQfUUYNi83hUqcC9dDBYg+i/b7qv74aN4arUiboBi2gJBCqkc67AqtuiDYQ44ebD/Q0OZs+hen7oNtxgmhZ690vRYPJ2i5R9pCEUZJxTElCvrx9uZ7qR0XcVTPZoDvs//6jVFfDd+nmUHuPrjOGF257dsuB63xQhAfA+GPT2yS3jdq6ZRzhJg4pYHKE2Y+TFfb+FvyogrFCayMQtBjlGurFdKYzAXLBP8UuEeCSZAwaUOCpbjR5ITVLktMU1/d2gLYAaX/mHh0WmFk7z4DgY/PSs+/HrGejP0CTCe4yew3KUuNbo26Ekrq+MouXJYHMbH/KWMHQIQS/+YIY14mBLIYdrOohUVvcvu+o/5ansJ/AzdiYmzx8gYMeZ1FCTsx5eFkLUUI/P9512Z7UzxDjZ4NHFb4qJVN6k2pZYUbOSis9iYYIjsDPi8fu+Hoy1dV+wncwPdgJ40amDY1p6yv9wJ6XqnJ3xAClhux37H3KO1eihewdwR5k4U6lyqWNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 02:40:14PM +0800, 李龙兴 wrote:
> Dear Linux kernel developers and maintainers,
> 
> We would like to report a new kernel bug found by our tool. WARNING in
> mempool_alloc_noprof. Details are as follows.
> 
> Kernel commit: v6.12.11
> Kernel config: see attachment
> report: see attachment
> 
> We are currently analyzing the root cause and  working on a
> reproducible PoC. We will provide further updates in this thread as
> soon as we have more information.
> 
> Best regards,
> Longxing Li
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
> __alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
> WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
> __alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766
> Modules linked in:
> CPU: 1 UID: 0 PID: 362734 Comm: syz-executor.5 Not tainted 6.12.11 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:__alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
> RIP: 0010:__alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766

page allocator triggers a warning when __GFP_NOFAIL is set but
__GFP_DIRECT_RECLAIM is not set.

> Code: 10 00 00 00 44 8b 74 24 48 41 89 c5 0f b6 c0 44 8b a4 24 84 00
> 00 00 89 44 24 28 e9 e5 f6 ff ff 90 0f 0b 90 e9 f1 f6 ff ff 90 <0f> 0b
> 90 e9 1e fb ff ff e8 2e a4 38 09 e9 5e ed ff ff 4c 89 f7 e8
> RSP: 0000:ffffc9003ce9e7d0 EFLAGS: 00010246
> RAX: 0000000000008000 RBX: 0000000000000000 RCX: ffffc9003ce9e8fc
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88813fff99c8
> RBP: 0000000000000000 R08: 000000000000028d R09: 0000000000000000
> R10: ffff88807fffbc17 R11: 0000000000000000 R12: 000000000009a800
> R13: 000000000009a800 R14: 1ffff920079d3d0e R15: 0000000000000001
> FS:  00007f1784eff640(0000) GS:ffff888135e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055bb25a85a28 CR3: 0000000096938000 CR4: 0000000000752ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  alloc_pages_mpol_noprof+0x2c9/0x610 mm/mempolicy.c:2269
>  mempool_alloc_noprof+0x176/0x390 mm/mempool.c:402

the user of the mempool (f2fs_encrypt_one_page) passed __GFP_DIRECT_RECLAIM,
but mempool temporarily cleared it, but not __GFP_NOFAIL:
   gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO)

Hmm perhaps mempool should clear __GFP_NOFAIL as well when clearing
__GFP_DIRECT_RECLAIM?

>  fscrypt_alloc_bounce_page+0x28/0x60 fs/crypto/crypto.c:59
>  fscrypt_encrypt_pagecache_blocks.cold+0x567/0x6da fs/crypto/crypto.c:202
>  f2fs_encrypt_one_page+0x187/0x630 fs/f2fs/data.c:2516
>  f2fs_do_write_data_page+0x7b4/0x1900 fs/f2fs/data.c:2706
>  f2fs_write_single_data_page+0x1454/0x1c30 fs/f2fs/data.c:2872
>  f2fs_write_cache_pages+0xd6e/0x24e0 fs/f2fs/data.c:3166
>  __f2fs_write_data_pages fs/f2fs/data.c:3321 [inline]
>  f2fs_write_data_pages+0x4af/0xdd0 fs/f2fs/data.c:3348
>  do_writepages+0x1a3/0x7f0 mm/page-writeback.c:2683
>  filemap_fdatawrite_wbc mm/filemap.c:398 [inline]
>  filemap_fdatawrite_wbc+0x148/0x1c0 mm/filemap.c:388
>  __filemap_fdatawrite_range+0xb3/0xf0 mm/filemap.c:431
>  file_write_and_wait_range+0xca/0x140 mm/filemap.c:788
>  f2fs_do_sync_file+0x2dc/0x1ed0 fs/f2fs/file.c:278
>  f2fs_sync_file+0x13a/0x1a0 fs/f2fs/file.c:395
>  vfs_fsync_range+0x136/0x220 fs/sync.c:188
>  generic_write_sync include/linux/fs.h:2871 [inline]
>  f2fs_file_write_iter+0x12ba/0x2370 fs/f2fs/file.c:5057
>  new_sync_write fs/read_write.c:590 [inline]
>  vfs_write+0x5ae/0x1150 fs/read_write.c:683
>  ksys_write+0x12f/0x260 fs/read_write.c:736
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x471ecd
> Code: c3 e8 17 28 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1784eff058 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000000000059bf80 RCX: 0000000000471ecd
> RDX: 0000000000000002 RSI: 00000000200003c0 RDI: 0000000000000004
> RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059bf8c
> R13: 000000000000000b R14: 000000000059bf80 R15: 00007f1784edf000
>  </TASK>
> 
> https://drive.google.com/file/d/17HbDTI_iPjA72SkV5MnO-_w7IQZ9HIHW/view?usp=drive_link
> 
> https://drive.google.com/file/d/19pMiWedcVz8nFrj9jiJXuCjyPbNjYQqq/view?usp=drive_link

