Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EC4EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C616B00B2; Wed, 25 Feb 2026 02:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047F66B00B3; Wed, 25 Feb 2026 02:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24A26B00B4; Wed, 25 Feb 2026 02:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC98B6B00B2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82BB9139C0C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:26 +0000 (UTC)
X-FDA: 84482216532.23.87CE4CC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08E1518000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZAvrTxab;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="OeNxl/u9";
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xj6cx9G62xrddJGb5BBWMZub4FFMH19i4QxwL0K0leE=;
	b=MhJR7457DFUIFBpA0slxLh+7rX7+mniOjdxBoJ85TLFY/g4nAXm93QSZV1h/rzKZJGg370
	E/QbMbYHL2JKitjrtfyqABK6Y2oxFWqjN2jn7R6WDM2m5IvTPlh+9BPZ39QA0ZUcnhs1k3
	gA22GW16lGNxE93FWFdsNjysTVp0rE0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZAvrTxab;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="OeNxl/u9";
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772006063; a=rsa-sha256;
	cv=pass;
	b=JEQAS3f6BufMEowSwhKBnbLLGRCsV50HOb4hxtwgZ4UXraj1oo8Nl0pvCiwKB7gCDupa8q
	Auzi/rK4nHJ1auWHIY4rYuLd6YcRC5WOmTwC1H1tjLHttUbMCvVl+ZIEEXgpfwIqLwaPf4
	p9WVx2o08IzYHDa22F6cg9WYxe+5nIc=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIvdel372361;
	Wed, 25 Feb 2026 07:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xj6cx9G62xrddJGb5BBWMZub4FFMH19i4QxwL0K0leE=; b=
	ZAvrTxabPCvvx+fbYOVVaFtTzK09N/NjR4NKwLQjtA4Nywpy92KAu/Ix0T3a53OS
	jdKlO7zvZ6oFFf7W0Z2oMbXRipH0woQtOYZfO7LEHRt01jxEPnywp3PQzf4KXLa7
	L/7f7gU5cou7uhUugNThy7uN0GFg75FFo3SEP6+8AHipFu6ntTKTv5Ly1uuFyGOI
	ygp0Cd82TmHUestKec8wR6Gqx0jMY6f6xPlbDo5Rblk/QwQ3vTe3AbhvSAXj/6Sf
	iTtcZIeYRvv2NrjYGCXoZz+h+/D5IkhMo5pEG3vDVbFd/ECUQ1Snx/Wk5ohufxNJ
	rd2GIq3+FjQB33M2oiZy4w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5wkyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 07:53:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P7kPcT006498;
	Wed, 25 Feb 2026 07:53:27 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b1c42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 07:53:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aUqmlI8rqqaYoy/iGaiQ5Ke6qz/rIVYvqvN6ZhSsmF1AAFl0UK9AL/XV7gY3f3VmbUEfxhIXJjOTh7KPXPelfIAup8yx+mNxYaqye9uZQ+QoPO7DZuHGodu6YLTwyzVKPxnNJqggNZuj91BgrXWD0hEJBAcKdQWm1hPzsEuILzn5kFWXIqE1GtP+XzNf5USsn/a5B9cAQcp+ArJ0xymhZg03yQOEX1rNWIfewBUkHNi+FypD7tqO8RlPZUk2boBJENOxVZfbGS6BQO+pjCqY1C3iPL0w6glV9Xukmaqao/J5WvCE+9KuUXTFxGFUZpDwZjk5HmAGrJIMhUvl3vwviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xj6cx9G62xrddJGb5BBWMZub4FFMH19i4QxwL0K0leE=;
 b=Ef/KXmsFHcARAmIRJ7Y/R2OPJ1GyAU6+Gdzs6OkpKWtja8o9+pm4sGcMGLJV47JdBYKmOtxqg605vE+WlkJz8dsJvT+IUaCofx/HX9uBS1CLUXa1wz1XPVcYaJ/xEZ94kcLVKRt0+KWMN26pj4cttZQMhNzUhBJHv7H5XSz8yBAzvKji5BX+I4DD41reE81OZj2PVwjeky84TuciNP7YwJHpWWwIENYkPkBOgpxzris8dWGCTzJMOtNqDzxb8lVAvZ4czYzyYlFNg0Hoh3aGeC69Wqsfnqq77SB71mJiCinAaIwU7EoSmCfkbtYCTBvCdGrrK4AS6gk3K4nmkCEs3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xj6cx9G62xrddJGb5BBWMZub4FFMH19i4QxwL0K0leE=;
 b=OeNxl/u99iU9hnfFZMls+mRQWf+mVUg+jHtaHv4l2hCv6QO8ZT/rP+PD1ww0pzGrCIeNEfHQDV9coRPQjy4KPCprqtYs/+49I/H1AtUsh87lCjT/Oxk5hbWeQ0kQpOzeu5JKZCCXSHfIdvOM/N0Qsj46LhrD6rZEM+63il11McY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CY8PR10MB6657.namprd10.prod.outlook.com (2603:10b6:930:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 07:53:03 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 07:53:03 +0000
References: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
 <2553a75a-6dc8-4295-96b3-58367879751c@kernel.org>
 <CAD++jLm6iyeFuGoC2zfHDOu6gYdb2L1gsjQhT5a4qS-CBWia9Q@mail.gmail.com>
 <10fb20fc-b379-433d-9a08-cc962ab70480@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Walleij <linusw@kernel.org>, Kees Cook <kees@kernel.org>,
        Ingo
 Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri
 Lelli <juri.lelli@redhat.com>,
        Vincent Guittot
 <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel
 Gorman <mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Andrew
 Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren
 Baghdasaryan <surenb@google.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        Mateusz Guzik <mjguzik@gmail.com>,
        Pasha Tatashin
 <pasha.tatashin@soleen.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [PATCH] fork: zero vmap stack using clear_pages() instead of
 memset()
Message-ID: <87jyw146ac.fsf@oracle.com>
In-reply-to: <10fb20fc-b379-433d-9a08-cc962ab70480@kernel.org>
Date: Tue, 24 Feb 2026 23:53:02 -0800
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:303:6a::26) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CY8PR10MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: bdc268ed-9a39-4cb9-cb97-08de7442e76e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2xFaCtZblRxOEhLY0RVbzR1dGMvZjdEZE5ma3Q5cXpkOHFIL1Y1bE8vbWY1?=
 =?utf-8?B?bWQzSWovakpKMERvc2swcXZ3R0xWTVIvR0VWRkQ1a3hvdUhpMFpDaEQzRnNW?=
 =?utf-8?B?NjRabHpaVGpsRncwejNCZU8yQWRKVVFqQWtDSmZJVlV4WG9kRlBYakVIeDBX?=
 =?utf-8?B?bEtpQUtMNnRSNmx2N1JIT0Z1TXlIZCtiWTh6bnc3RkRNcFQxRXdkWTdsR0h5?=
 =?utf-8?B?K3p2dEM1OVMzQkUycWpBMHNTUHdlMUU1S2lEWnpKODJ5eHhDa0RUNkRWc2FD?=
 =?utf-8?B?dEV6cVlMVUlmOUN6Y0FMWVp4WmRyUUpsVmd1cG45dHpITGRuOTJQMXVBeDls?=
 =?utf-8?B?eDFVbHpWbGhrWjVMOG90RE0wSFRGTDRsam5NcUhFNjBMeXgrTjROZGtVODRq?=
 =?utf-8?B?dndWTnE3b2JvRzdtbDM0YzczdCtVV3FTZ1NGVXVoTmNCaDBwdnZjYXAzR0dW?=
 =?utf-8?B?VDdMY0tTOHlxQUhyV1VXNk9ZMmFNRXFvTGhXNHBHKzY4SGZ0V0N6R1pWL2E3?=
 =?utf-8?B?K0JzSmJyQ0dtTXJKenViSWZiN1VhMmphTjZ1T1FYSm94YThPSGRRL05SaVVE?=
 =?utf-8?B?YmpwYVNUV1ZFcC9QSDFKeHNKempySWJSaHFISHI3blJHVkQrMmVPUlNVWWdO?=
 =?utf-8?B?UlVmeTEyZXIyNmp3ejFlUmJ6Y2VRYmdTRWo1bWx5WHRHZCs1LzFyRVNWdzM4?=
 =?utf-8?B?cmxZZ2VhcnVKRXJROVV0ZjNzUUtrTGMrcXlubjNYZ0hyRWFNRVZRNjdkanpa?=
 =?utf-8?B?T25SYU8yRHBza1RkUndqd3EwTVljUXlRaFU0NVZOZ0hWd3FRM2JWUSs4ZFBF?=
 =?utf-8?B?NjJPZWtKUXJWdkovdmtsV0w4MjJOWVZLdHVIaUNtaEdIN3QvSWt6VmJKWHNC?=
 =?utf-8?B?a2xOUGg2UEh1RjZzTTBMcjRXOXlVNnRIb21YTERnL1pyMG1rb3laUmI3dU9z?=
 =?utf-8?B?V1BKOVFxdC9XYWZERUZUMWduNHNiWjE2dE40REFQM2VDQmtEZnFZTXRPbWpu?=
 =?utf-8?B?S0pIUmhLb3kxQ3ZEazB4cHBOL3hTNis4ODhYL0cwT0JXMDRmT241cVYzbU1R?=
 =?utf-8?B?NkFyMWh5bElMbWQ5b2NZRkQwQ1l5R2taZnoyTWZCV0lyY1ladHZVdGVaSUh6?=
 =?utf-8?B?RmEwdzI5dEJHSEdFeFBXWTFtNVJnL1MvTDA3ZERIUUQ1UTZkRWJtVjNOZVZS?=
 =?utf-8?B?Qm4zUXRyTWJxdzNTbDBpWmV2L2VLTy85MU5KYkE5TGY3Ym81cDJWdGphbWFt?=
 =?utf-8?B?c2lINkRMSGliUVA5N1R5UjY1NGlOL2JybUl4WWZjNSsvcUF2SHlpakpMYU5U?=
 =?utf-8?B?bXJZaHQ4YVk3QjRmdC91NVJGMlhqYm5aTi9yUEo4eUxBdXhCckMvcWJEbk9y?=
 =?utf-8?B?NFp1OHFSQVBQSTBGakEvdERSVEI5emZ6aVhxOENKQXpwa1JDQ292SitaMkN4?=
 =?utf-8?B?QVp4TEpNY3Q1ZmEwekdUT2FQWThrblF3L3d0MG5wN0Y4eU5GbTE2NWVIa1hs?=
 =?utf-8?B?a0h1SGtMKzJva1JHanhqemREempRV3FRczRBbytDcDBDZWhsTERaZ2Q5cUJo?=
 =?utf-8?B?TUYrcWpoWXNjNmszVHlOVUlEdmFwY3JLZXlyNTd2alM3Z1V3UkJsbjU1Sk1v?=
 =?utf-8?B?dFBrQWRhS1VaS2E2R2hvbk11Q1UwSzhranYxWFpJeEgvQW1vQmRzcnlsUytO?=
 =?utf-8?B?YUhLZW0yNEZzYVAyUEpLaGlNTWNEZVp5YXJDYVBXdHN3WlgwRlpONWNWYS9G?=
 =?utf-8?B?WVVyTk1iWmlYeURqTzgxNVZmZjRRb3FUK1crRFNLNkhHMTZKejlyTm9HTnVh?=
 =?utf-8?B?bGFTSUhEWlhkbDhoTmhVYkMrNFhtbDBKVlVCTXY0MmwyTHV6MEpFWFc2eG9Z?=
 =?utf-8?B?eEpOM1FrWVFvMW5EaWw5d1VOV1hvVTBuNmdzdEt3OHNXVUZUSkg3T3dqQ2ZY?=
 =?utf-8?B?WllEeVBRajIxWkdnR1NnSXpqUU4reTRobFhBbDkvbktNcjkwR3pWVEpmTVVu?=
 =?utf-8?B?Wkpoa1dya1R2b000YVBCTnFBQXBVZzdqSnkyY0NpeWJHTUs5OGJwZXAvS01o?=
 =?utf-8?B?UmtJQ0d6V0dwSWcvNGpXWTh6RVVqWHNhRmVDbU1aTXo3TmJrQWxGOGhyZVI4?=
 =?utf-8?Q?dfzM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFNlN1dQcWFiWjBjOWNGV2lCaEc0RmQ2cEVCQktpVUF3YVhPNG9uZXJqY2pD?=
 =?utf-8?B?VGtQQUFzN2l3eFAyWGttcHlqdVdxNjc1Lzc4c1hKcnp4YUdLMXhSTmVNZHp6?=
 =?utf-8?B?d1ROdVFDc0NieHNwOXA4WHBsL2c3Wk85akhTQXliVXpXM3Y1aExjUDJBTTlK?=
 =?utf-8?B?dWl6WEJIQStzck43UDl6eEF2L1hWSWJvUThLVndqeGpoMWxsWkxHLzl4Rnpy?=
 =?utf-8?B?WmRNcVBVcTVFWGErSTRCU3ZLbHpsT3lSS1hBZXkzdEhUQjVXLzRBa2VmclRk?=
 =?utf-8?B?SXNDd2lFalNiTU01eVhRa0FBYyt4bG5xOGVheUtvbXdkRThXN1phZmY1RDBD?=
 =?utf-8?B?eWtaUVYzYitQTk9XUFpQTHdPK3dyazk3dE9IUGs0ajJZM25SZG53N3QxVmgz?=
 =?utf-8?B?TFJGZVh3ZFY5WHUzZVI4UkpoLzIrOTJocEZha0ZzeHoxS3pxbHlzb3VRcFhh?=
 =?utf-8?B?VDI4d0xqSjBwd2FIR1pUcWVWbmt4aGtYcGhkc1FycVArZTlTRFlLbGVrUGNU?=
 =?utf-8?B?Tmx0ZEZ5Q2NEZ0gzN3hLVXdycDl3dGxxQWFNNzVnMUVVSXhiZytFNG0xOFpy?=
 =?utf-8?B?Q2R1RnBJOWRpV1ZKYlNYa0hvZDVMU3k4emgydEdKUUFOZ0w4VDM4NTJDbjlk?=
 =?utf-8?B?NWlzUU5Ld1FTcU1td3JQeDVNQkxHbFhEU3M5Zk83UTJiYTBoVXk5eS8veUI4?=
 =?utf-8?B?akk2cGtoKzNjeEFsUXFsa2ttMVhQWTVSOW1Za1Q1MUJlOVBBRDA4b0xidVMr?=
 =?utf-8?B?c3ZtVkh5R1hQMDFJT3F4OWl5dDRqS28wSGxLZk1XVkV3K3ZFcVp5ckVRaGF2?=
 =?utf-8?B?cXNVMzdWM2dpZ3ExdmF4RGdjZXpvQVQ5YkJvZWJnUFViRWlGeUd1YysrS3RD?=
 =?utf-8?B?eXFqZXBQUndocS9iY0xqMWdZTmVmSkExaU5uRDNGcXJPNDFrVnF2TnNhY2s2?=
 =?utf-8?B?ZzFUOHN0L2F1eUI5QnpVcmNLVEVQZnpKQ3o2ZGtBRGJYMVRoYmR5MW5Zb1BM?=
 =?utf-8?B?aFczVDlmMlpGajJkUHc4NHZSdmxDWEFDQWYwNDl2ek1waUVjRVdkNjhvM3RB?=
 =?utf-8?B?T2NKL2pEUDRuZURBU0xRVHF0V2k4VHZ2UUF3UHhJY202Q2lVRWZxSGZHNWlk?=
 =?utf-8?B?cW85N1lVZU05U0xDK1lFVDB2VmlTQVVLQkd3QW5aZ1hoY3FROGIvWklCbmoy?=
 =?utf-8?B?eStNNm1yK29PQ08xaEZxeVlXWXZyOFp1eFdzWlpzYzhhbWxEYXNuTzBiQ1cy?=
 =?utf-8?B?VUh5WU5oN3krUXZHbmNZdkVKTFIzNHRFdFdDMFhjaVJBM1EzQmF1UHE1M1k0?=
 =?utf-8?B?bEs0WnhqNXh0YUE2Y0VDdm5jelVHejQ0RnE5ZTFDTFh3U1JqR3FwSUYvWVZz?=
 =?utf-8?B?YkpsZGRZQ0t3dDNMRmt6dFp5MnhoUHhYamFvKzh1MTV5Zzgra3NlQjF1ZkVu?=
 =?utf-8?B?ZzBNdEJoRTB0MDZ3ZnF2Y2dBQlYxSFZRamtCZHV1ZVZycncwd29UVlNVczhm?=
 =?utf-8?B?Zk1KOUlsenJwY1VseVhhSGoyTU8vWXBuQmp6L1pHYU5WenNpUUM4OHNBZDJT?=
 =?utf-8?B?WTdYY1dlbWZsNVVTeWkwYktNbG5UdkhHMmcxL3Q4LzhUOGpGVDF0WW5DUTRN?=
 =?utf-8?B?b20yeUF5VjUxbU1KZERLK1BrQmNvY1FiVjB2UGQvZzZGOHZNSHB1YjJJbmFE?=
 =?utf-8?B?aVROQk1wVmN5dE55Z0p4QUl5S3F2RHVJQ0Z5cWJtek1sUzUvaTRleDVEVG5P?=
 =?utf-8?B?NEE1L0M1UjZBck9MYURIT0FOUnVwNVducGFMZlZUTDFnU2loUWRqVXZLT0l5?=
 =?utf-8?B?d2s4U3lxelV0ekd4c1M4V1AzTGRsSUNtR1A3YTRMVnZMRkJYbHpoNEJLV1F4?=
 =?utf-8?B?V1ZHS28wMWhHY3d2TE1Mc2pJTXBzWlQ5WStzTG1yWEViRytNdmg5aXNkc0Iy?=
 =?utf-8?B?U1BxWWd3UVYyb0lmTGN2K3VEQTJUNGNpeldURGg3UnhoRjNFcUY5bnRudUp1?=
 =?utf-8?B?NmpCV21tL2lKWlZDYlFWRUFSTmJ5LzZCRXNHOS9EeGRMQ0thaEsvNHVReVY0?=
 =?utf-8?B?Kzk5WlgxckNsN1c1ZHQ3QjhHdTZhYzUvNitkQUJTa1dhS0VuVjhRbHc5L21M?=
 =?utf-8?B?MGFBaDVSY0tYeFJKRHQyMU83WXFKb2hZS2RnY3RJeU90blRRdVVCZEdiT3VI?=
 =?utf-8?B?NkJ6b01ocXRKWEVKci8zQjBDck1PVmk3ZGtDODFjVkRjT3YwZ2Y5WTVNS0Na?=
 =?utf-8?B?QW85NnhTRDFvbVN6Nk1kMGZ5MzQzeWJCLzQrZjhaRWRTc2tVZU1Salgya1B1?=
 =?utf-8?B?L1Q2NnhZZzNmUFloZVczZzRyUWI1SkJvT2VKdEl6SXFYMFZsYnRFejhFWWNu?=
 =?utf-8?Q?huN0t4xRy61qljlg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	39Lv39Y8+rd3pfIT7uq5ejcJCnFuvirr5CLV2kAqIYjJkDozUtybOwDbSzvoNBaKXg0bkeOPaJAjFZOyNmJMatYV9wPwj1f4dhtrb1C6hKqDzigFpQNDMcI2KdyQexs5v/vpm5tmyY6i8Wz/Dg2codRLK+uTEOZ0zmOzpo76HdtV1JeMnrjc07xuZvh+k1lPAvUu19rQmcBIL3smqVSjR3O0i7MJi+FyyLhyb3z39N59sKRoTi1ZZRDfGStJek7HSFXnYhYePVBOCPg8mtRZ0L9m+AooOns2huDUMF+7+UgQUfJpZKZHA3putzYfNpeb0J3fiYLBV61WK7oYN1loLiH4Ny2MAx0YPYCp/FxmaRj02erTWKKzGKMDSVKZkeVJ39MWZZy5S9AcRVY/ZB4niG0PuEpBMKlxAxkSTcWEHamRvwLJ7p4P0rq/xT/dYwXnbgzkAlCFNNDRfIyINM06fP0K0OFSldKqRRBIPPoegVk4h/V+qXJzeupZ3H1CZQBXbF9lzlicRFTEsn7am9J+G1g+qRAoIp42DHhgpCml/QpIHUmHzwaRlhfBRHq9QEYo+Yic7ywBh+uZFH/8JGYc6LfMmUjIRVjRO1XupvMADsY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc268ed-9a39-4cb9-cb97-08de7442e76e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 07:53:03.4956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5YtU4kpIswbSFUDgsCFElrVgmPJrQeqycL9y0ihFs5avKHdnzwAkNnS23c8l1wVl2EYktK0Ith3L5JVk2C/424KmYo02nHCNVl9iptun2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250076
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDA3NiBTYWx0ZWRfX91Xa0/ojCxtj
 iHAuZc1XhI+MW2zwCoYO49c3GEt7+oM945MPsy+KDmK8eY1/eXOE1kaGGO5V+vW/khTgC21uHhy
 81Joz6g0qTE+d8MwT8sGcoFQ8TYNOnNuY5ITChP+/YKIhoRz0+sHIDNIevm/PmqFiXfuBvPtTzB
 tmGCGsDhisCSqPTPptbRAE7MLEL8uVcpc/ajCmUGDzUSFlG89jyD9fjiJTWTsyY5FMySdaGKh1o
 wznuiY8I4mnZE4K1gBzJvQxcjwUtBhzJE9B5nm94m9bl8qzYQxQqJsU2ch04NbzsWumu2UFzKXw
 2WiO0iLZZOQ6zZd3JtrFNYw5b/Z5TvCOmGzkwoSGB0+9kcW+i6wae/YqcW2BuMF0bzQX1SujtQ4
 tqS88VsrFUEEY4CggIloNds39BqoWtQ/4ENJ3IeFD1F+2JqpJAA8Vzv49q4sLyHrpsaQ1edp/kT
 7bVM6/btRKm24QXsK6Q==
X-Proofpoint-GUID: j8jse0a9ZdH_FVdzp_Ceat63sslh9iOD
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699eaa78 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=QP9QS3sva8RS9bSYyzQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: j8jse0a9ZdH_FVdzp_Ceat63sslh9iOD
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08E1518000A
X-Stat-Signature: rucmtpgz9aga4sfzbr7xuci6m1wr873z
X-HE-Tag: 1772006062-214240
X-HE-Meta: U2FsdGVkX181OxwxkVQLcsjoKdD6BLYQ39XzOWiUq6yDSSUaa2M2rFr4twYa9aasgQWiCjhLltn5SlxQzdIshsuLNwN4oF1FBnF6I2h28wuCYaPi9EExGmIbUyB4Bi58ZmExOkcMJUkJ2HmjbMg7rvq4mzHBtO0R5BbA7IlL6kyC2yXv32GpBnKZkCUwNBALhCUO+naX/8VgcPZqKZ+VzpoJiFMUPIoNoof7qnk68YbWcpuVQNZ1WTqEDpfSW5iYeTbC8KJFy45/JHgF3zphjBdkj67Zbw90SM0grRjicuJ9ybQ9hm6nz6mz0sbqsoaojwEl5mImFyCKP1EV2DLxNC/KkIdowRslzXCOXZpgIP75HdCM56DLhqQIJVFoUzMAxEqMp5FZ8YLTBIGRBn6tKL6RhouoaC/w0roi1bg/X5jZ/MKmIO38wgv6Dwt8IjJHiUyowEe63otvIZhUYo2okPO8t4ZpQAdh2kKqcovhVx/wVQMgM74xGow4lKu8VLIU8ytnU4vD+RQMqlflYQ7nzdqhf5gMcsu/XR7+d1qCJcslIZJw8dyeNv+Za+e5mnYnCUjuuuI62NFHLMOr1KHq5sbrlCM3SCzioQZGs98o0iV3lH2Fxv91Fr23dawytwm0lSEfg/q8PEThTYZ9GkcwqAI8nnpzt1Dk5DULZsSozQdmbiFi5VJSIGe/bRbRuXUAFNzrgTmQ10He8H7M47Xqy0rRhdEGsKnOTRHITsq1dojOwXhZI5jXNaNMcwyA7vmovW37k6/YcDzgibehw5rg4YM6NdR4dk5ChLYgyJbEXnnokwzGK+UMijOYbtCVfq9WeDevxg6sLAhSi+rZe5WB+8pipVhRNcAjFKZPp3YzSqds4TY0FXPTwtBAO7+k8Fkd0U/VRH9vnR2fF/7cvriNCURU+cPKZqEIW4pPef7KRmHGYAQC0DQPL32FihtQpOah9VEQhSiUmmUvDBLIIxz
 hF7niVvK
 LdYRhwJIPhxjKOIbotzdzK08OQZ9Z4rjzW4xQgu96b4ko8ZcXqW0Pc4xyEzcy8ktCw10nkH0Wq2hjZ2OD4OpG2WR9nYd6GCZLvERqvQ4KCnKgW9cI5afwWlexXeM1Bn4JfyoEoousg1FwNt6jjy0yx11kHTFCUyEYBj/NHrOlOjEGSrWw+K1u6BLUCuZMlcNKEeT+g+5oW8/oCnpfwu/oSlO37PyLXPjy3EqcjxpabcKNep1Xw1q3USS5nxszLvj5pNcAqUPxD+RF3W6wPxsDqM6e+Za6cQfxs3iCR4hDkLeR9rBayQRzxxHSqB1G4Y+8VSeRnX7CT82zVWNzjpf89YwHjX9Q77RbdFwXjs9Q6SuGKqnq9ZAbWo34iLCVTJ7BNEhQTUe+6VVrTFrW1P5uPb7aFdiiAMSavIMCIt5AJyeRTeyshJ21qSDnY/E0ECJFJb22Jqti1o2sLRF4B7hY5AvhQExz+huNn5KTutSZv/Vj1ufW2Ok3iBG0EZ6fhgVZxrdLXYGRzLLxXMgybtFPYl98fvHXDHNYRu6U74RY3P3CVlbxRs8znK/jPX6pTZKzAdehNwFXZyGRTJ3wxBrx9QfvI+mQAkQsqIQ5DuwWLKT0WoT+m7YAsDqV8lOq681gz6s9SswJg8r29yet3uj6irhjWTr5wOBBM4lcnkDuBV28ajDPDY6vE2o9X/pK97UjGicM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Arm) <david@kernel.org> writes:

> On 2/24/26 14:53, Linus Walleij wrote:
>> On Tue, Feb 24, 2026 at 2:21=E2=80=AFPM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>> On 2/24/26 11:26, Linus Walleij wrote:
>>
>>>> After the introduction of clear_pages() we exploit the
>>>> fact that the process vm_area is allocated in contiguous
>>>> pages to just clear them all in one swift operation.
>>>
>>> The pages are virtually contiguous (vmalloc IIUC), not necessarily
>>> physically contiguous. For clear_pages() that should work.
>>
>> Yeah that's what I meant with contiguous, sorry.
>>
>>>>               /* Clear stale pointers from reused stack. */
>>>> -             memset(stack, 0, THREAD_SIZE);
>>>> +             clear_pages(vm_area->addr, vm_area->nr_pages);
>>>
>>> LGTM.
>>>
>>> Do we have any idea about performance impact etc?
>>
>> I have a pending patch for implementing clear_pages() for arm64,
>> https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.=
git/log/?h=3Db4/aarch64-clear-pages
>> which is in a performance test loop, once I get baseline data from that
>> I can test something fork-intensive (hackbench, I guess) with this patch=
 on top.
>>
>> So making that patch made me remember this one code site...
>
> I'll note that clear_pages() documents: "When running under preemptible
> models this is not a problem. Under cooperatively scheduled models,
> however, the caller is expected to limit @npages to no more than
> PROCESS_PAGES_NON_PREEMPT_BATCH."
>
> We discussed during review that we should probably move that batching
> logic into clear_pages() at some point.

Yeah. However, clear_pages() can be architecturally overriden.

I don't see any use for a non-batched implementation. So, maybe
the arch version should become __clear_pages() and clear_pages()
can always do the appropriate batching.

--
ankur

