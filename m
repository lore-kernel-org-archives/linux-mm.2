Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F96C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19AF68E0025; Thu, 28 Aug 2025 10:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C5E8E0006; Thu, 28 Aug 2025 10:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07118E0025; Thu, 28 Aug 2025 10:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D52F58E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:28:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 724C683FAA
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:28:03 +0000 (UTC)
X-FDA: 83826395646.28.ACD4889
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 003512000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:27:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SxL9fFB7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n6WUITLh;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756391280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ow4X0M9Z4qcXCJlK3HGVBF5VsdhgDGmTtxV5r6nmfU=;
	b=r0J53GMEtrEV4KXmRSnHzUU12GX5P/2IV33qTiL2VuDlZLgx8c0ZxyGV+42ALmebU59C9U
	kqFPWhB1X24kbSoosguPJKc1gzD5TEVatw9veQ6HwaqOIaknYKAfn8Dgy7HatqmYzpVmqR
	YRlJZOJZ79mfN5aKoiK5StJU/BrB9vc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SxL9fFB7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n6WUITLh;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756391280; a=rsa-sha256;
	cv=pass;
	b=sAuSyCaJp3JqnlsahIJoCBf1HfCWUsH3ywNsPeoaYEDJZZSQ1Dp8z8sD7IoeQkIg+ZhEAk
	jufVYlrS3cDB284iKWSGIRfdobk0t1tzn64tX9JE1QTMBv6dQMPkvcnmpoRqSfrVFRJEJ+
	SVsPKocPNci6c8gD/18b7VzkjAts/yg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN2BT031230;
	Thu, 28 Aug 2025 14:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3ow4X0M9Z4qcXCJlK3HGVBF5VsdhgDGmTtxV5r6nmfU=; b=
	SxL9fFB7ZyzncCpXWaRobZHC6f9kPwbwc8RYOyklw1MhVZBqyZ0Ih9pWWFdd5kEz
	rMmjBV0sSr4/WNFPCLoS66e+VgM18Lt4k337XfCOVoMP+WgGnthp5WEOp1K/gElK
	k2ebX2WOJgsc9EfZbgksolZD+Bxj+esasLUDkH3zMcRfwU4H+KwJWXEGNGVGTUR9
	i9hd+s8vXrfdVvbWrFZdQk0hKdmIlsLu/c7iKvH/eHGUkJ58qndpCoooQ4h7TPQK
	WtOnMBpgf8IwywzPEjsvVA1mPaA1+wxeIf6tCYROtKEq35IUCnF11e/r+opUMUQw
	maNSb6VykdPC6NG6/kraTQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e28rgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:27:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SD5kgx018999;
	Thu, 28 Aug 2025 14:27:55 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11013013.outbound.protection.outlook.com [52.101.54.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c27m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:27:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YNXnfoBSTpbbxUBCpobiCLhehKrO3YxWb7fj1dabggXzvYZPTmaY6fKGj4FpJROFqiXOBosuBmd3QU3xWSvMK83FOP9VeDE8YBa+Q5ysFWAi8K8YzUIn0/p5OgqTCZ819uZ5av4PlmwzuQ7qsRiqXzGXG9xNn/ONTgWEjpQDyk4Q2YAXyFYplOvuksmNKbQsfq5b9pi/lXJiuNl91U/cHk9aD7cfImftz1pmqSOSAs3PCxTcgGzyovCexIx4BB56pTu73fDiILUZ2fzG17VlNrscY7SBHhvrJumg8O0BCUQ9DlxLZ1IRbL0crw1ksvY0DdR3BJnS8wLH4nkHQ2n4bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ow4X0M9Z4qcXCJlK3HGVBF5VsdhgDGmTtxV5r6nmfU=;
 b=hfWpJy2QauTrQMWLyYflwj7xLLFfe+VMkj0MN6PDMb3mjQEBv3BcyFHvRFDTaoVy9g9eoPJ/Kd09JCFaRMjn5vKAVGyP/NawyZc8ZzcKLbomo6PEGEjB8X4ZGcJSEddHtdseaY0WefOa+GMzNrQ3vE/bEqzMXdkI9plORD3zl+NZ1e0VXypZ1TJBUb0esCpELTraMnMQ9/vlIy6KRHj82rG+Jacp9x9r0bNa0BRtG34VOW8msDUzGzNzitky0jD6eni2NwjuO88fztnNSe31XumKzBMJUZ+rP2JFdHWQNgWNPTO0FAB/hSLNaJbVXo/RkudzVLHCeVgSq5Li7x+9rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ow4X0M9Z4qcXCJlK3HGVBF5VsdhgDGmTtxV5r6nmfU=;
 b=n6WUITLhat/fI9bFhEZ67il9XWlwvcOqUc+cUVhQMR6PPgGwvQSXPf44ouBG3haIK8lalqu/XBfnsFNcZdUafv624MtOLEy3rpeUWQj6NENowsHYent8TuDOtG+tYc0hxymnGm2h0+iAtVGhX5QMWu87CAVJO6oYAflEXuC47uM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB7386.namprd10.prod.outlook.com (2603:10b6:208:42e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 14:27:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:27:47 +0000
Date: Thu, 28 Aug 2025 10:27:43 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 12/14] maple_tree: Sheaf conversion
Message-ID: <x267qkdsaaugvvo4fg6mzoxinxa3kjwtrsjxowedeb3zoemg2k@tiafcyckbioi>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-12-b792cd830f5d@suse.cz>
 <CAJuCfpFKjKAAyXgW_SFBXEp9N55txYdayw2h+=cSLO7wLvO2Pw@mail.gmail.com>
 <nhw4odptloo5dzmawss4q3mg7b5mtcfcs2z4flnqpduws7tlfj@hy75m647kp5z>
 <CAJuCfpE8+u73+COnB=SHmjJKHYJncLgdt8VMGCXR3JDDZ0+s0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpE8+u73+COnB=SHmjJKHYJncLgdt8VMGCXR3JDDZ0+s0w@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0470.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: 41339462-958e-4548-9047-08dde63f0f19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0pWQWw3SkJTVnMvcDlmS0hOOEl0bjdsamhDY1k1U05wMG9VRURmSXQyOWVL?=
 =?utf-8?B?UEFnVHRnSnFCYnJqYk4xV0Y4U3R6SlE0NEFDMWZ6VTRZQ0U2ZGVPWEJlTnFE?=
 =?utf-8?B?dFJQbEpUY3VLUzVQL01paWo3a2FuWUliUVorNFhDVHFVSHFNbUp2T1JZNTE5?=
 =?utf-8?B?UkdwNzJIdWRic3Z5Z2VSckF1MWlQY3l4YmV6ZzIrVHpZZWJQUmdiS0NvQThD?=
 =?utf-8?B?TmNTZkorYkV6QWhvK1NDN1NPZzIzbHlsaUppMlVvZUhCVXgrZmdsS2w3ckNU?=
 =?utf-8?B?Yisrbk5WdHM4OVFzeU93K0d2T2V3T2R5ZUhkcVdXM0h3cmJVWktEQUF2M2wy?=
 =?utf-8?B?L0FUNlB5T0lXZEU5aWVoQ3o0eFZpVkR5bS9qbjFPY0NXV1htNURIdHNaL3lX?=
 =?utf-8?B?QjZTNU5jQ0g2TXdndUVvaDBvaGJSMHZuWnFkcG5DdlQvMnp0dnlKcHR1UjdQ?=
 =?utf-8?B?SWR2SWR4R2Y3RHhMbUlHRmNMMW1JT2pqZjR3MkNKY25ORFh4SDFGYVA4L1ZK?=
 =?utf-8?B?N1ZiWHF3OVRxeGNNbTZjQ2VrNzJvMXFrVEZSRzFUOGhSYU8venE2NG9oN2t0?=
 =?utf-8?B?S2dtZVJTRitZQ25pYUlQb3lqTGRKWi91YWNYSWM4MDhUT25XUXFHZ2JhWVVS?=
 =?utf-8?B?TlZOWTRtdlFxNE1Gejc0L3pEMERJdUd1QkIxVXBpTG5ab0tJUUFNbHhhbmU1?=
 =?utf-8?B?WFdIN1Jjd1NPVHNJcEVCVkJ0Q3NnN1JBVHlJaG9iRkhWdDdycGRKWUZtRThh?=
 =?utf-8?B?U28rZWppNDFHcVlwejNjMW9QcmppdnhCc29TdGFDaEMxVVZIYWxySkxIaUZP?=
 =?utf-8?B?YXNCRjBJNTNBV0hSQy91TWhqbTlhN2ZMdW9FbGYwSWtYOVdqbnhWLy9icTRa?=
 =?utf-8?B?aVBVZEtEbXVvcVRWOWM2NlM3T01obG02R25vajJjeFA5d1JsOUtZd1lEUGVz?=
 =?utf-8?B?aWU4S3VVK1pWNUxjeEhDS3ZhNEJRTHY4UUxET0ZJQ3ZsWEFsc0tTa1VCWk1y?=
 =?utf-8?B?T1hwc250b0xDTUFjU0d6VlpVMzFSR0hhWmxZYUZieXgza0loQmdVQUgxVExX?=
 =?utf-8?B?QW8wMXNQWS96bEV4a0JJanFETVU4UGhMZnFZYVc3czVIY0htdWJXbXZPaVVj?=
 =?utf-8?B?dlIwL1NRTm9aMUpLbHV4b1p4c0hwRitCdGdIbzZSMWxzdGxDcGpiVCt4K250?=
 =?utf-8?B?dnJIL01iYXpqOHpHcnFhb0JpOFU5N3NsbmRza051OUdFdlQwajl4SVRkRm0r?=
 =?utf-8?B?bnpWZzdISzBTdWcycFptWm5jdmhObVhRakREcld4aGUxV1NmTE5HbWxtelhR?=
 =?utf-8?B?NTZlcUtSbVJqeWJmQUZDVzd1Y2h2QVRaVndLcnVmc0ZlT1g5U3Q5S0w0bFNj?=
 =?utf-8?B?MmR3UHo3ZmVsTExuUEhtcGRPaFd2ck1BQ01vR3cwUzdBQlBXUDI2UWE0MkYv?=
 =?utf-8?B?L0g1NmNmRlhlWjYvaHQzZm9TSWlUQmVUeWFhaVAvSDZZOElxWFJBdWVqY0pF?=
 =?utf-8?B?NThEUWw3YUpzSnhWbW5lT3IwWlFZSkd5RVQ3WEJhQllMTjduWXpUUk1PMkFJ?=
 =?utf-8?B?c3pFWEJyNnE1U1o2akgvRXNTSU5JODloS21pY21YUHNxa1AwZXlRWnVTRExS?=
 =?utf-8?B?KzhmdVpPK0huVmN1YkxadDRJQ3hGWnJQR3Voc0ZhRUZtSGQwdUtleUdpUkli?=
 =?utf-8?B?M1N2Qksrb2dKdUUydkxjZnJ2bFR1WTMyVGRKVkg4aVhGQ0JQcUVvMitMOCtq?=
 =?utf-8?B?ZmpwSFJLTmU5S1NPeXI2ZEdFY014Y0d5ai9ValVsWS9nMmRnOER1dm8xK2ps?=
 =?utf-8?B?TkdzWlVaWTZBSVk2ZExzVlVySjZBOXg2WjlQeHNFbmk4Tm5DRnA1LytmYVln?=
 =?utf-8?B?aVVyN2xjR0FXMVhkUk1tSkt1dTB6dTZhcVpzbGpFd0NGdWcvaHJCZmZOZzVS?=
 =?utf-8?B?TjlaRVBYdGhGRmhBNVQrUjR3K2E2RDhqc0U4bUp2UDJ6VWczZ2JSb2piMWxu?=
 =?utf-8?B?dWwvWCtXNTlRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmdXNWdpdDJBTzlucS9UWk0xQlVzWWFKZktVSGE5QmxpMkRZUjlYM1hEQTlL?=
 =?utf-8?B?dFdkSFQxYUlTZlM0YUhlcW1Zc3k1dGMwN2JMNHVLWUsyU3dPRjQ1dVp3MjR3?=
 =?utf-8?B?MW9udmY0WmJDM2p3NWk3Ymdva1pXcklqMTE0SXFXOTZWbUdxK2ZLWmZjNXNw?=
 =?utf-8?B?VnFmSFlvOXN6SXNjbVVnN1Q0TTB6UVZ3dUltUHJiQThQcGlTd1hKaElnYnFW?=
 =?utf-8?B?YnNBWXhCUjUrdGJacldZamlIcmYweVZDVWQ4V1lVY0hUQnM1OFRCbXVKeGtT?=
 =?utf-8?B?NVRNRS8zR1hvbWNubThaNVByZk1nUENDQ0Y5eFBVSmtiY015ckkyZUM3Tkxt?=
 =?utf-8?B?bmJmV0ZOUHBqWlUxbTBMNGFuMEtCSlVTYkVwSnFFcnRJaHlhS0RaSDcvK1Zi?=
 =?utf-8?B?Yk5vUnJSd0h6VEc1bi9yNnJPK05XNDZGUllWcFlIcHo2c3B3NjFVOUszWTdV?=
 =?utf-8?B?S2RoZWdmNk9Zc2llTXBpNE9ERzR6SnhpYlRadUl1Q1VzR2pxSzAxdVQ2M0dY?=
 =?utf-8?B?RHhEdGVVY1N1ZEt4d3dDbCtYMmFFa3RlQmhYdEM2RWJoQ3AxNVE1U2NOSy9S?=
 =?utf-8?B?Zzk4ekpjNnBEb0xmM0RDRlNXVUpBQmhLZjZjL2VCNHBOVDdTTVJraDNEZ2to?=
 =?utf-8?B?clZ4eXhtS2oyWXhocVJtV25UNm9IV2pMZEdRMmQ4UmtQOXl0QUk4MGc4eDZJ?=
 =?utf-8?B?YXkwRlMwdEMwM25JRkpMNDlORGtQVzRRNk00S1h4c0hpdTQ3d3h5bE53YkNm?=
 =?utf-8?B?TEhIZUpWTk9hVS9WTHQrNmRFNFhzdHpmWVVUTFlBM0g3QmFYWmRNRlFRTnBI?=
 =?utf-8?B?ZWtnVExrVGpqSFVGd3p3Y0tpSjVlVEpPcy9NejZmRHhLdEUzRmNkVDcydHA3?=
 =?utf-8?B?cHRvcy9MY2U1M2liaFloSnU1YkxLVm9lQlR4Vkc1MDRlMjNiaHZMV0VqU0ZN?=
 =?utf-8?B?S0l2dzdMV0xVT3FoTFBvSHVmRXBETkN1SE9JaVBMSUVWOEUwcW5vZ1Y2QWFF?=
 =?utf-8?B?bTdleUVYY2owVE5Ob1dmZmptRlEzN3pzbEJjaVJ1ZGdTaEI0RU9tbGdvWFMy?=
 =?utf-8?B?V08zRkhNZDc0TTlnZWw3Uk9yMVZJRmdQVXdOK002Vms3dmNWSUhzQ2FiOXVG?=
 =?utf-8?B?U0FzRFJlTWlUQk5QZ09OdE9LOCtTalVjc29Id3k3ZUZvTVhFV2FxMkRxVG9q?=
 =?utf-8?B?ckM3dkM1WUNnZ0dFRFFoT1NXU0FTbUFFNXJsRGZxVkNmRUZlb0h0U00razZk?=
 =?utf-8?B?ajlrcTgxWlIxK2hQakh0aXJyWEhINDE5cGJPc3dvTEtBOGtJM1I4VDNja0R4?=
 =?utf-8?B?SXczWlFzNHJmZDhQWkorVTRmSm1BN2dzWUlDb2FpcW8vLzhWYXp3ajd2USt4?=
 =?utf-8?B?VWpzNFdxenl0bXBLTFlkcXJ5VjNoakpHZjVBUTlhbERkMldGbVNLVEZLeGl0?=
 =?utf-8?B?MHJDQjN0Qmx0NUtjRXJYOEk2OTZUMU8zc3NkTjZBVm9saWZHQ09CbzFjN3Ny?=
 =?utf-8?B?M3JZNkJOdnJTdEkxeXk4bnIwMGs3Mk85V1BBRkNtYWNKTklaQXc1b1hESVV2?=
 =?utf-8?B?Y3lHU0JjRlpWb2k2RjNtWTUrNlJtTHZiYTFiZVdNMUpGT1RJTGNRK05CYzhl?=
 =?utf-8?B?ZkNtODI4Q0M2L29vcGhzOENWUDNxS012YXRuMUpLV25TczcvcThDdFo2TXpZ?=
 =?utf-8?B?N2IyR2lkamt5cmRReWF0THNzSmxBblNGNVF2R0hmMndLNEpDSllLbytCMGUz?=
 =?utf-8?B?Snh3a0U4YlNDdnNOeDRLWHJBRi82RktUZC9XM2hvTU51eEpQSXNweFNtbmln?=
 =?utf-8?B?Q2dWUzAyUHF4MlJJMXpnYW5pSzlGNElJQUdqZDZFblpTeVRFcnlOeS80NUpO?=
 =?utf-8?B?TmY2RUJRQjdma2QyV0o2NFpOWC8veUg3UWJ4TC96V3B6eDVWQXVmckpGRlFG?=
 =?utf-8?B?aThqQlFoVEw3M3h2NVFqU01wenV5WDRmd0ZoV1o0aGYxSGdia1R4Yk1pbTJJ?=
 =?utf-8?B?K2tVd1poWUpscGt0S3I3N21PTXZxQjduS1dQUEtEQk4zNlEwY3VqY2hQeDVi?=
 =?utf-8?B?MjY0VmNSZXZ6d0hYRnpSc0pKYnNLYmhWcVdhVlZXWm1hVGVvd0dKQWtac0JP?=
 =?utf-8?B?cSs3Rkw5VDFta2xYa01sYUdOaEVYUEF5b2xzQ0lLWXZzWFlEVWZDY1R6cUFh?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aN/w4oAWkrXYypZec9ZPCIIj9Ud3dliz2Xdt8dZzE3VudjRZv7TwX4oKZUwDnIyEpRQtmXD4Jhh1GWFmMDE7MGUwkQwd3mNM853oU3lttc3cDVJzDzvBJLWusE4LDxqh7sqWRvpHjT9AEjQ7xIN9Fl9UaACO3kD1IJCUPIDWmV8sUxoYrQnjrG8bJSZOeE3U3Br0n7I/IHC6flZOTq4AQFlpt6nTKzwKfflngAXwWsytpKWDTX4MH3gcUp3AbMDgBHYfSy+2NEVZ503yOtnAUdfihwMHIb1x2F5SPEPhbzTknflMW5R2ol7j4YxOS5ObEbiKjat9JbScN8bmqJGSPJK5ZuF6ASWOndBX9pUujCMUWD00oa+0zgafGPhkKu7fExtWT5wQyQsNgawd1g6E7lSoTigWw52Taz9s78WxrfoZGBo0Y9/90YFHN5fSAqHTVllfSygVDuVtKLWG2kLgaLBJnv9el0wjmGsPGmLpc5l6lmrTK6syJCeSs6nXh6coML0YsDucmYO1hgsxOGvDGyqICb9TWGDEKFDvfudYeoql/k9qTbBuA/qZiXNnZRV6wEvSSpzlHIELgl6V64/gQLz3M/J6/UU89uzewGlnim4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41339462-958e-4548-9047-08dde63f0f19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:27:46.9589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w300TNFOhPMkQgLq2xj+P2v/OhM2vgE1KaUHqhmfY+GQwkPKiAX1Ru6TY+XhjMBUsJMuCAKtNcGQmo2iHizCWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=919 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX0sssQwA4EMZr
 wfEaXrBstNWKEURPWU0QiXu9QI7Amickfq7fOxDpo23Dah3cmiWl2LTr2kPOBgEhHiBoTZJWMvT
 VenSYGLQlvY056Zmud3bS10bhtMPEVEO9ZKzjPdYbTG7ak1rGZycrHTjS8ZG/A4bv98Bo3f0iei
 AVc5welxCWSC+a4nZu4TUlQbCtnwzecFssan1/9NdW1CUqMS5v6k0l/ybq7//oRelowV5wkEAKQ
 OFDaeyY5SfmIxQc7Muh7/YpyvLYNUi7crJbet1YSpOY+lZ3vR/qSMiSui/WbpvZ5XW04MlfPjXy
 u6CWMW7r/JH4N9f3lK0bVa90ezhcJvBant3NYwSR40AS79LnT33b23b39Gl59zFPHtzIw5hCzR4
 BMdOHNC9
X-Proofpoint-ORIG-GUID: NeQqzEn0hgBwRP3tgIXAAiHP6HxKzjxa
X-Proofpoint-GUID: NeQqzEn0hgBwRP3tgIXAAiHP6HxKzjxa
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b0676c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=dr_PQ8Br3Vec55-7URQA:9 a=QEXdDO2ut3YA:10
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 003512000B
X-Stat-Signature: ybqbjbnmnug1u5rnr3xdsbwshmyh7g4q
X-Rspam-User: 
X-HE-Tag: 1756391279-903821
X-HE-Meta: U2FsdGVkX19634JjiV+7dgnIs7SrwMd5plxLPMKr9AZR3eikx1ekVxD1pah6gi3s13MXOdu4/3rPtCZa6KnEcoCxoopBl3kL8PS+iguJLM+KbowtGGqgzGgfMua4RTQMIOa4Nhcsxtm45/48HCyAM3adfIW8/zgBh91g8cTPl9os7yYZ2wDUXwDRo9TZuGZcdzVdG56NoNBCeNrxS8LnxB8dU5SF504AYG4H7o1sOoFrNJRHM5rhkhVgKVo4CjGYENvRLer+CQgj4vXrjOvPO/Ep84oaRjsaCdncAb5m24aaxnPnJ13B6YVydhRhk8CvdWzTk9R7+5Zj5I5XfCrueyx6aVKYh5qlO52eGrKQB46FvrIUfiW4+8HhFOuIpxmzWvZ9Ti/DhMUGGrSLsJFP+aEPMVGbi5napfvS/yD41s7uSsKU2B8FV1DTPe7LIP9aGYco07NcyNOmtmSErPVCLTyj/Bh5XxvI1ueKO0fPh9N8Q7pVvu0EwtXV88uGUhegSyc6X3NPvQlyFoe00B32/9dw2w4lHTDcae1Oy2wP1hblzMKZSKWZlcwG5rpodzpnRfGm6WgkiUzcxyP8OkIqqI4S58/8rqYXjm41006d736qUOqJcDbIbc63aya6VOlJrD3WpvjlcOfgye+Vjw/+joiKvsxWb9UgwPLhzO0UJcI4pDdtmglxZUiGbRlFZE8ottD2dD7559mnjkMbq9vayZp/ES08eyto/Lw96uIymBhIGt61mAqBIStR/mBTmwzBzBt/kQKTK8L7tI/uvXRu24qIQ0yc38YHezi2aa0pbsNpRHp4x7KNvt42bdyjtMgGpo/wWgxPlIYF5MYyqZQcb/gNmDvJbU+Jqh84NaoYSco/VsSb7EVIQ04C8ls/JnTXN3ijZzyfaTKAn1aqxAU4e+x6Lmb0tcVylYhpSvSRXYi6inAzaXzFL7maKJKMNaWsXQ4W7peKeHpOdP+cTq8
 VVW9+LAR
 kVUfbJoSzOIw0siBPlIrrTybeGU1kFJvw9q0viDwZ02sGNTvezNr6xq6X0IklK1bRD2OMf1SslRFIJ6DqUvH0+KpB1DQMr9F503amJiT2ErKMKGhzr+zvbjukWadDeg1F9LdPpWvFBE1XdcXzgWnbq9eCEgBkULYULjuQgxYIxX+XKJpRIaThRW++/fHQKhWVcNCRxvCx28cdWu87lVvRYbKNngIydXlk6YjNaqIylYIKNDWzXCnx5RASgamY1zLPMaMSw7yq6lXuxAPQBMy/owyJ73HR58WLifwVCHmd2Jv0h2YHfSOWZFPL4POqxU+k7Mqv2bpfuORWab4yaKTLYKFFqrOFb6BEiQ69m349EvuNm0sOqhc4kS7GcNOuwQH0CpFXVrZCIXcBAd/1nlhJSjHbfivPpEUG3vcsnhFk/c7dga4WiTSEmJZGfWYUnFJ1aoGC0Rf+HT1oum94kZ7nzK5KMhEWPh0Qz3FP8IqoD9+ODVFYHSmHWG3TTldkA97jw/ZzXM2qLiSwnofcOvUzcFhfE9EZdsc5zKTzqO50+DnpS2rD7VRvpsasNtIO1mlpTCWQkgKqp7DWagknjs07ra+4FiqonbhY7G9vJ0hlE78MWkvEBiIQWOOw8KDjT2iqQol2Y7Y9Hfjs/Obi7ggcIrL809Ur7yxQKs+1clI1cDl4kkF8gMt3Cmqz/jF1s1qeU8QcAeE8qc6NfRsBa3DWRgC+LWoMgPXFW9QfdsOlBy89yv0GWjsm5uu2uGyi6CTs/A5tL+NcVN9azpeUr8KiaGRgwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250826 22:07]:
> On Tue, Aug 26, 2025 at 7:22=E2=80=AFAM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > * Suren Baghdasaryan <surenb@google.com> [250822 16:18]:
> > > On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> > > >
> > > > From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > >
> > > > Use sheaves instead of bulk allocations.  This should speed up the
> > > > allocations and the return path of unused allocations.
> > >
> > > Nice cleanup!
> > >
> > > >
> > > > Remove push/pop of nodes from maple state.
> > > > Remove unnecessary testing
> > > > ifdef out other testing that probably will be deleted
> > >
> > > Should we simply remove them if they are unused?
> >
> > Yes, I think it's time to drop them.
> >
> > >
> > > > Fix testcase for testing race
> > > > Move some testing around in the same commit.
> > >
> > > Would it be possible to separate test changes from kernel changes int=
o
> > > another patch? Kernel part looks good to me but I don't know enough
> > > about these tests to vote on that.
> >
> > Yes.  I'll do that.
> >
> > I'll drop testing first then the feature so that testing will continue
> > to pass on bisection.
> >
> > I will also stop moving tests around in this change.

I cannot easily change the tests without the corresponding code and keep
the tests passing.

I can limit the changes to what is necessary though.  It looks like I've
moved some things around and I'll do that another time.

Thanks,
Liam

