Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE719D778AC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA616B053F; Fri, 23 Jan 2026 13:54:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2476B0540; Fri, 23 Jan 2026 13:54:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ABD36B0541; Fri, 23 Jan 2026 13:54:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E86986B053F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:54:49 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D15D1A0582
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:54:49 +0000 (UTC)
X-FDA: 84364130298.28.84089D6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2046140005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:54:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jzayEPra;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fvwKgKMs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769194486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiWGgRvmBA/cGvLVuCAun8KMX4R3TEsDTJqyhPKBiX4=;
	b=5wxHiFVMZ649A5b2R1lxksRYsiVGsxywTjNdsSoybkAxhbzuMrl2l5RKG+lZBLZAbOV4jk
	o8jXK0MJEPcVe2Bfgp0QH5a5md2wucoPCWfzkDHLG5qjlqdDSxWjuuRQkvJ3PTjDccq7x8
	tk5D6OwutbI0GDRzK8XxBwqOJegwL94=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769194486; a=rsa-sha256;
	cv=pass;
	b=KfD5jNL/x9yv5rHLADwJ+PYYfDEt435rPb53+ApsHV1peJ3vOU4KVWLXJmV+2PRgBUbwFZ
	1kINMf9uxNRdR15oJoYMKvlpEPftagUOTNBOeRaeECDqo67Y43QLhk+fVhJVH29HOQ4qNe
	P5Yz0t+k0UCSsNm9qxQ+08knzlpNpY4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jzayEPra;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fvwKgKMs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NF7UA42173055;
	Fri, 23 Jan 2026 18:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hiWGgRvmBA/cGvLVuCAun8KMX4R3TEsDTJqyhPKBiX4=; b=
	jzayEPra+KYhm/1wiT6REY7xcTPXgGlDqbGMAVp3+QtYrrJiOlbnepUAyRxSSJS7
	VHxUQeVQy6lvI/HRPx3Lb1mH1sNb94inodHvMOXqWnpetpWW30lNCXh1A5l4iS4H
	bf6HpLeEkWuHV6NhdXy1o0xCr9NyqruAVw755dMDyTUU5xKv3v8+rDCcLR14qJdW
	LuYAbBrYxvK0nBuYRRTC5c0+CovU6QyEhuC9VfC3DGigtg+339LKZeSndiAqmwiL
	t+ti/GmAe92EcM7B/P1ZfPVunIzCy1gw9m6pOQM7Ph4BUe9D06tA40biEkuDlsR0
	qdrf9fjAiFjW7RfsvDsANA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd7exk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 18:54:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NIRUSi021921;
	Fri, 23 Jan 2026 18:54:27 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vjh5pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 18:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQEy8N9VuO488odEC1XQQfilJnddIDzS3HsH0MYF7NUhm4pJI6MA5LAHMyEHK/uZvf1d2/f88exYG8WLFAliR/kO5AgW2zUf0+h5BgXr/SMA80+StOEeZ28Y9tG0/1vbcoZ6yje9DRFux2H6RpIyvyXTZXm23RPu42ZsQVudVxJqOejZ/dK+4hM9hfcInNLxN5AYgcWT3ExcKvzwkueljDdq9o3QgP9MILOdECO44/USTR2JS1hyu7bt/8Nc12EYbyQtlHpfUC47TBEHuObqH3IbcKmYJX8CWcIpBe9or3wrRBPSMtkcAyRwZ3yFYrDKmjLADncscJ0qQ0njXUxHog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiWGgRvmBA/cGvLVuCAun8KMX4R3TEsDTJqyhPKBiX4=;
 b=gwyyqPTFDKVju+0xJO/BdNBPq7I1Oa2ktzRy9YlLa14AOOvAiH3uwGk5G0N3cGiS2hF93NrRvk4sLAmXSnnHSvpT67H0hSV+iQNMKv6UyXy78BJkK5fMpJ7PA1T5ef5lSae1bigzSTGLfTb6cU6MDD7+oPCgPJ4D+AAubj2u6pi6S8nMIBaslRO7Ez9NVzj+ORVLes23Z0Bin+xzD/4eL7N5pyfd0dPyQzYmlTQgqPw8Byw5MYgU+Q9MMIVVMAfTTf1XSyBd+NhVMnQhcZrQL9CWYwQ87I+BB2QBcRqplUg23Wj0gM6JZgViaDdtRbrPHfoL9HSkdZTVqam5LQwI9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiWGgRvmBA/cGvLVuCAun8KMX4R3TEsDTJqyhPKBiX4=;
 b=fvwKgKMs0G3jLo2KbpwgJJOdpYCoKxifwGLMQ1JZxrMvanH/NmlBT5AoI7HEvRQvIwpruY+1BuNCd5HS9dWcKZ+qUKefWCplm8IZfL7SuRKSGzz+HSFRgQranbNeVOvvwRNtu0QsOcE/w7FUfrMs9mX15sGvZ9Mul6CQsHTctig=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 18:54:23 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 18:54:23 +0000
Date: Fri, 23 Jan 2026 18:54:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 10/10] mm/vma: add and use
 vma_assert_stabilised()
Message-ID: <60b1070c-5971-43ff-ab8a-fb4854fcb8b2@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <43c90424ba0874a71bb7ab9d6423b3a2bf616f8e.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEJ0NRB3vgZ2uajGcTRovKYTnrV6woSbFGWZ_LSFerkTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEJ0NRB3vgZ2uajGcTRovKYTnrV6woSbFGWZ_LSFerkTA@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0294.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b84ad50-1776-4767-4fe9-08de5ab0d319
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWRGckZnZmxDd1J0QVBNSURFaGFEU2NBL2lidTZ5Mlo5R0dlNWpVOFU1Y24z?=
 =?utf-8?B?akwxTWQ1QklRRWJXdFBSVFlWMTF0NlpQNkRnakxMTWVsaWhDbVprTExmdW1Y?=
 =?utf-8?B?MDU1U0Z3SFJrZTNQcUhGMEVpWUd0cDJERitwcnpGenRIMFZUVE4xRkl2OXZ5?=
 =?utf-8?B?S2V4MWhKTGd3QTg3TDQ3R3NaQ1NBR3Vzc0dJNjVKcEFSNkJLTElidVNaVjRL?=
 =?utf-8?B?YThFN3RQaEhJQzRkbUVjSlhWMG9MTmxxbjdOUFZPVXVZNE1uL0RMeXFpWXdT?=
 =?utf-8?B?NXlLbmRocGpJMUNLdXh1N2dRb2s1d2Nuc05NbkdZZ2hpdS84a1VrWkdXdWVL?=
 =?utf-8?B?M0prYU1raEJvL0JlT09EMGx3ZzlnVE1Od2dZMHkwN2NITTBDbnVreGUzQXB4?=
 =?utf-8?B?S042eHI5bUU1UXZDNFFvMStDYUU0aTV4L2t0ZlFaS3FBbHpaakZ4bSs3TVBX?=
 =?utf-8?B?ZGRXR3ZvaWpQT3ROTjdEOE5aRThrRS9LV3Zock13QVpuSDhPeFY2VklwUmZn?=
 =?utf-8?B?MVVJS25MUVRwK1pzTWRFN3BzdDZSYUhQNy81emxud3g1eDc5WkhHRWw1MFlW?=
 =?utf-8?B?TkxUOC9tYXR5YnRLUS9TRjJWSWUrc05DTVhjSXAyZWJ6bFFueTc4QmkyU1pJ?=
 =?utf-8?B?RUlHcnZiMFFyYzgyQnRrcitETDJ6SnhRK3BnTURERENJK2NCRjRjUGpFd24v?=
 =?utf-8?B?dVp5b1JsUDJsV29wdSt2TFFZUDRzSExsQjJNcThnei91UFJOWnZNR0FFMlda?=
 =?utf-8?B?dEZkWHBGajJqdVZ2VkY1czJ6a3F3YVZHUDVqOTRZcWN6WW5CWHVkL2NEQlg0?=
 =?utf-8?B?OTRmN2lkb3p0ajNKaHJJL2xqNXp4VTVRbXpna0t4Zk80MmR6QmJ3R2R0SmNU?=
 =?utf-8?B?TTFKbVA3SGxkQytOcGo2VWlyOW1idmk1SHpDWnZBdFRzb1BtWEhlV2R4OWJk?=
 =?utf-8?B?bGJ2R3NYUTB3eHhiNDJLVExPQWJjQzBVYVN4MXpIckFMOGJUWlhnZnR1dW1o?=
 =?utf-8?B?NzRWNFQzc01rUjF4SnJUUmJZU3gxYUpFNTdRL3lMMWdROGJpQVlVMTdrbE1J?=
 =?utf-8?B?azBhL0dGVlJhbWk2MkdVR1NIdkhJcExFNGw4bEJWRDhBeXJPMnllU2l3U1BN?=
 =?utf-8?B?OUN6SnJQTlhYUmNkUW9UYU5MRXkrMUgvaWVEMmFUcWlFYlN6RmN5cFVtdmxY?=
 =?utf-8?B?eENkckhhNCtMcThTYm9PRjc5ellQQjFTTjRPMUxrNFVYNHlmSnlhYm1xOFZ6?=
 =?utf-8?B?dVk2Z1BXT3p5STAxNHY1c0VNTW5aUXI3OWovVWx6VW0yMDhpTTV3RDVGUVhC?=
 =?utf-8?B?NUx2L0lzbXk3N2dwQUlxMjVXUmRuNC8xZXVmNDZJeU9EUi92T3lMZ1N0Z1pM?=
 =?utf-8?B?RUduN0w3U2NKRTZleTd0eHpLeDcrQXkxQXZaRWFOcHVMQTg5Z0Q5TUt3RTVt?=
 =?utf-8?B?OXpaai8rL2lUNFFyVFpHS0ExcXlxTTJ6c1JGaEFsWFlUWVY4a0xkNTZHK1Q0?=
 =?utf-8?B?eWJNNDdTODBYZTRJZ1NMQnNpaFdnL2FFbVF4ZStvUVVqdTd1Vkk5elBvbHhS?=
 =?utf-8?B?STI2TUg2TlU4ZDJENEN5MWdWR3lJTlV3LzNkZ0Q4QU1iYVpiempJbHpmaDJm?=
 =?utf-8?B?RENDOW1tcSsxaFhmR2pYeGhJM2lqZ0VxLzNKR0RCS1RDenpkcHZpcDdWR3JD?=
 =?utf-8?B?b1oxUEVWV3dDRUtpbmh2ZzRvSXBKNWs5bnR1VzBuZWh5R1RQOTJCdDBTUGFC?=
 =?utf-8?B?ZC9YaFhqdzNRYzdUYjNUSEdXTTY3cm56aE5IVGFUM1JNM3lmRXBpRG1xSXps?=
 =?utf-8?B?VjJyMkdmVERLUVdQRFdiSWtQV0t5dEk0ak43aDl2YmNkY2RkK09yekxhUkF3?=
 =?utf-8?B?L2dlQmZEa1Q0MXYxb0FCWDVyQTlwYlU1aWwzR2JWeVpGT2VKbEhLYm5nQUh6?=
 =?utf-8?B?SUN5Z2FFaVpNSWdDNnJ5YW8yYmZyVGxWUGpKR0tlYUY2ZDZvRitibldpdWlO?=
 =?utf-8?B?WThSNUZML3czM3NGRXVhcTQ4RmNPZkI0Y0N1b2haYU5SNGswS1FDbEcvQmhH?=
 =?utf-8?B?M1JIWitCQ1JjbkorZWpxLzBpdUkyRFdCdHc4ZndpRWd2QW1seG1zQkZKcmR1?=
 =?utf-8?Q?mBLQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDlRWmkzMFljTTJJUEVaR2hGY3ZvQ2RMelpKOG1qTGlsVHpiTkRGM29uZ1Vn?=
 =?utf-8?B?ZDNqQjFTaUVIejNGc2RUem1lQnIvUmZDM1VYTHh3VjlPSVJ1Wmt1ZU9taHNU?=
 =?utf-8?B?dUYxelM5bzZOMm05Q1RJZnpQWVppZ0NpeHB4elBxZytrdjU1eFg2aWorbXNR?=
 =?utf-8?B?NEFmNFMxMFNDditUelY4OGhBVXdBR1dtTG5WODgrZ21SR0R6TGxHR0pUYko0?=
 =?utf-8?B?V3NoRDJFT2NJa2ZMRDJhd0I1TnU1c1pIR0wvcTU2STNHT3VIYlJWS0xxYThS?=
 =?utf-8?B?YndvUHdGMlR4dWFMaUZkSWxwMThzQWhkRDVibnFDYWlKSWtOamZIYjhVaFli?=
 =?utf-8?B?Zm5COGVSVEUyM3g2SDBUbFViWWxHUVFTV0FDRWpTM25tbVdiVlRDV0puVjMy?=
 =?utf-8?B?c0xEVzQ2NlJ2aEYvcld5WllsMklJS2YzdFVmWDFBaXRIUVYvSVJ6cjRTU2xt?=
 =?utf-8?B?TFNMUmZaWklneGRWRmV5N25zS3NYQ3NQeUlSRGdHUklEbE94bmlITjdRTEgz?=
 =?utf-8?B?dmJXZ0Y4Rnk2MktNQmJPVkxTZkxEbmd3T0plRG1zQlRhMWs4L1lvdURkRVlv?=
 =?utf-8?B?RVBZWDgyaUlVWnZ1VE9MSkZCWlUwaFdWaXNkZTV6L3dqdjZySTBQSXFFU3Jt?=
 =?utf-8?B?N3cyTm0wMjA5Yy83bzJsWnFTSGtHaGRaOVYvbklUYVNMZzA3Vm9Ya3loL0Rn?=
 =?utf-8?B?Y3lZUmJzMVFEZnk3TEVtRnVCLzdIS2p6NFQrNTZvNng0OGQ1ZzVkajd4YkYw?=
 =?utf-8?B?aThyeVhVNERMOFNIUlkzSzFubUQreUJYQ1d0eVk4UFUzL05xQVd0WkZpWnFW?=
 =?utf-8?B?WjVLc3lVYkM1Yzd4dDQ0OGFIV1hyY0V0b3NydFFRbDhJclFJREVzaXREMFJK?=
 =?utf-8?B?ZkFUd0poZiszeTNKSVRZQ25PdjlsUUFNQkt3Smt6clNyVjlyK2krNytMVXZT?=
 =?utf-8?B?S3d4WWJLRXZGRnpLL3FPU2hkb2J2dVhFM2gydmhyTlloY3crYkV2RTVXNlN0?=
 =?utf-8?B?K2hvNUhJbjZxbmZZSEVGVlhXa0hZM2V0ZlNUMXcvY3RzMVRQb3ZPTVZnOXRz?=
 =?utf-8?B?MG16Q2hpU0F6MGlZUVJtYUpBN1ozdWhRL05LaHpYcG5pNEM4cjhRRy9uZTBM?=
 =?utf-8?B?azNYUUNrb3F3QW1WNnBvamg3dStJWnM5b2pLdXk5SE9UNjVpYmFDVzhERi9u?=
 =?utf-8?B?UE1NSzhlRlJEc0U5RGdYVEJqM2s5TDZEZWJjTkJxZWtaMk80US9CN0pZamNL?=
 =?utf-8?B?UHR2VG1GaThOYnpGTlliMVVUSDVDYlJGL1BtMTdTTHlXVStHbkp1K0Q1Y0xE?=
 =?utf-8?B?aE05eGxEdHdRcC9RcHkzM0xuZTlIOHQzZkJmSW5MblZaYXNtK2ZlRjFtajhn?=
 =?utf-8?B?V2lwVUpFUjVENzdjaVZGL3lLYzc3a3ZTRmNuRzJaMEloSGhpWWZDVjFmRStx?=
 =?utf-8?B?TjFJejZ5SXZYNUpVVzF2WGJrT09LdzBnR3JCVGlXMnBEUWg3Qkx2eU96Sngy?=
 =?utf-8?B?TXN3LytNM0JQbWw4d2tOcjhTMS94Q1BIZnpaaWVRUjdJU1RrNWxaeU10eWgz?=
 =?utf-8?B?OUhKSDgrYUJLa0tTa05leVZoa2lzWEhJbmFpQ3FTdEtJMTBKSXF6NmFqdmgr?=
 =?utf-8?B?aDdRRzlQZUdNcDF0WS8wcjFrRVpGZCtXY3pGdVhybENTaGhsNVQzeE5sTVRQ?=
 =?utf-8?B?Nko3Wm1xZUhtUlB4bDRvTDcrb3lsMWI3cm5mc2xxQlMxdU9FRDJHeU01SDR2?=
 =?utf-8?B?NWlieXZ1MDkvWjdVNk5nVlJPRndZeGd0ekViMm1pYWwzSzBQbElJczVaVEpY?=
 =?utf-8?B?bU4weU43RVhTWTNrcnpyanNETTRNWkJNT1RZWWM1cEI0d09PYS9WUWdvZE5X?=
 =?utf-8?B?RlgrOExyZlJYMXV1U21GYkxBZStwV3l5T3B3VWFaZ2JGeDBHR1k2RnlxNnVw?=
 =?utf-8?B?QjRqVUs5Z0ZtOXorS1JFWktLS2h6OUtwNGphZ3lMRXNhRldwZmt2eitaSWJJ?=
 =?utf-8?B?eXc2dW83V3ZJZmIrNko0TXVHeHk4akNtdW0wWVhGSU03c2hCNFlJYnpFb243?=
 =?utf-8?B?MEZUUlNFc0U0bmRXV2NyN1BMYkNSSWp3b1k4N2R3VUU0eWxlMmJtZGpFVnJ3?=
 =?utf-8?B?VGJCaGdweDVOY3BDR3E3SmZwemdmZEJNdTkxVHh6ajl3WWdsbGZucTNEclRM?=
 =?utf-8?B?R0RUdUJzRFhGRmdyMWY0ZkRWNmQ1UFhvUkgvemE1T0RYSG5SN2FoWjAwdU5N?=
 =?utf-8?B?S3d0RCtSSzllcHNCcWxEZWtFcWdGc0M4dy9kaXZYUlQvaVVVY2NUL2NzanRr?=
 =?utf-8?B?bFJDWnQ0anYxR3lSOVpiZGRUOE9GK0kzUDVtcHpTUjd0RzN3SmNkaXNZL2Fl?=
 =?utf-8?Q?KNlzwQrPlDS0fadI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6KD2g3SklcLikdKRTZ8xX6jRUHycgB3cAQhoQodhXk6vUPbNNUD3Puaj64DSqK4CciUu0zrueixWfW/UJbZF3aztKODXe19g6Epl/0unucAQ11HZXZ/BtRe4yzUetr+0KULGghDBPn3S5XLCcZUQ8Atl66ZtdJp6jG5rSAVdWyz4lSlEH6JduD/78IvUhgq6ldQ0AOsuhWuu0ano+pEIfjmL4W7MO0ycAuDYCMRRJTEeDeyQA5gK750jKhWqEeBXtgXege+xf5XTB/wB35SjhB8hKERGlwvAqHFx2eUWt8d8QdHB0UW8qnzs+TYLPUNwLF2N39XYtt82t0a7i8cQL7Zn+Xkqnea4586jjwvuRdbPp+FN0xt064BPkHZiXDpzi79ldasyY56d2vCcFkgxpDLNb+SXkNXk/z7QpT2pSLydPp/lFtEuUY2UnM0ca+v/VkdmgA+qucALuhE4tMKPF+JreyEJM8ux7pQmJ5QYIDmXQC2XX3pPATQMIdy5lwVGFVdscJtwXFGU43dnH/npBLi+a1KFpei3N2BvPV1tLSdXRA29TDaKNBNgkj9lMEhTN5ZdoNVbu1YwnG9sSDu2qoRDBwaJontMqeEaYHFrPpc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b84ad50-1776-4767-4fe9-08de5ab0d319
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 18:54:23.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcXt08ZO/zC8uFTKJuDvbMS74qpp84UHJLMONLt3A/stUsqY/ftOEKEnXNz40G9ZoEfI7sCrgUvBbGqrECGiiJO0K9b3zZKDxdKOSPrReh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230144
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=6973c3e3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=1EZjfDmEHyCCYmRH-goA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: 1kkwM21U3ubSWCSNJSEvq65gVdffy5av
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE0NCBTYWx0ZWRfX1EE1hferEfB8
 7YjOdGWlBayIdM284iI5CCBlIMfJ8Y3BiwFOb6cvEZ12v7mECJIPuSNa6+trWeFfJJajQYmeia4
 y5x8wlCC6qRWYc1rv0Tn1YPrzRuJy5nlQ0/gXYHln0a/jMqxflwQXAjKaMNRX7J9YOErzzoXrPz
 a3u99MwiPSKn0ptgBZaL7/bLi4rAUK+1yWWxl5Ulegs2FoSBfQUKcyyiFNJRWpdVgaGGncHYrAn
 86qGGVVJol6Z0FRGgj4krnRs+j3QUF7UrBpI0ccxSge0kPwzVajJA2CdLsOhyS2EHV7Izmn2adQ
 pARlStr+aOZEox6YQl4bvcCpnsQvG6WPV2fbPBiJrt7hgLKAkbkJAVuqdeuUmpXRrz01OIqhB0C
 OdJpFraBE+8bjdF1xfGcdlafXuhse7S6hd7y2jasl+Qo98vq3egU+xtWhKqN7+LQ9pt5wonSD05
 jNPy4mgQwFoswX+t9so6dPov7l3ki8QgZSA+KcAk=
X-Proofpoint-GUID: 1kkwM21U3ubSWCSNJSEvq65gVdffy5av
X-Rspamd-Queue-Id: 2046140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xne4uyhoqqmk96jbdsnz5wtp7tdzmyf3
X-HE-Tag: 1769194485-673992
X-HE-Meta: U2FsdGVkX1/r2CAVTRH/4BT1kKWJD0RmbSj3QjesMiwLpul8qD9LEBG33FZsSCxEPrT+LzsdtcazH3h/iEE1DWv7OaMQ0oFFAkQ5rfvokQiBxRezW0l2mUk8AYnhNdYJUenE1TfnOnyRzNzNr+1KH9pQQw+F9rJP5Pve8xTXdNfkh8w+m8anuHUCR/qFHB581f/gZbwmNSppFxSbTn1gcPgg42fWqH5PMe3KX0P1oVG9s2l6dIdq4iMkvBRwq9SVQZnQQ9SYy3Z+d5GrXMfWCQQrucAkZrjqRZHO+T5j1kWZpq+qZTChWAcsONyBT4fPIsgFHtJfom5/M2/9qyUxqesBSbQml4VyossK9ZUHLENUNV9YT4pHxr/IeLhF3vPcLPLevfplMBlL0INIDRahNOce0jk1QxlXkkRc7tNTy4fVV3ih8Iw73xfd+sl2eN4yOwetSn0qqADk7KvlCNqJzIm2cmDFPoaPO/WbXvuzGT2MvVS9jJcZ2ZvBgGOdNn3LAg1QboAAdXFb6SQ6g6ipSp6TYz//go0q0dXLHEzDgjJQnB5OLS4Uwh2IfjML/0fh79i4l/7/asLjYle+ljD/2NpBzee0H5tKW0W7Yg5EQE8nx6rUbRWBJjmKM7CX3PboyANw4TEJYiTEFMicHiXkxm7fVIzXEtzwcHxH+U4yweNBu5S5QPpnrm1RrYSFgCW3luP612JX/2uLldbOEKD2Yf0v/KxmPAaGDZnMW/OVYN4Zf2iK/JFsmYysHk4BBTKSL4TItgoLznbcReS6qfOPlXKyKSf5XogTRE8RUiic64eCc6OCZnRfEF6roolCBs0p8sZB2ek4BowCBBl65vk3kl+/vRDSfO+JBPA8Q2FNRcAjJILhTmVN13P1HYDrXpXgbohDLU3GUzEVTX9DWAubUFhoCFuMEM+A1kyKCM0lkphVcoY/mP84MpOjlhfgH6Ucb6tWw8jQApDNajCn6te
 GAMkLM9X
 k8lANtZOEcEkmI5li4VBf+NOYJGbfPXXHEDaziDBoH4qNcOgZ2N5mJnyTh9NLRXoVtrWFmh+rc6qH6j6bkBzRzCcjAovKjDOZLBlX2jUn1YSIJ9+wM8GcL3tVU5Pk2/QE5tYEm1dmgzBp8DTH1zz3TB2kJneNdiQ7A3VNUiZeJdbQTQ28cOWr6HplRQvD8ngTpZxWwKbJbOAYfl6aebxUdjU7sjhRXf4HAZSIq5B+TIUcUZfQbDyXbU1M9OHF7nT6EXYP7q6QQk0VliO7j/VAuQHTabXtJzISZXsQ9L4RFRO82SpLk9wZF4rrqUeBSa87+ZvCp/STfdjy5cDZwOYZUCMvLJYrYZCZtuSd2C5qAl1rne7MeW4UPEUs9um5Tyjxl4Lili84qD2ElqCiVFZ5accNYHTey2KDbKNUePt/HtujE0mbQPP66JsQWACyJCg+OXrLbJ6M6HWFgtbwmSFWaywR9Ux/+nSXrH3PvBf84jux2QkQa74esSFSR+/KUyUpWDNd4XRasXI3aOxlwsE7ZV40ykBlVks2adSGP71wlrLPvNdM3tFtjiChSqOSy2KZ9R301s+Isx4dVKboIMNgNXb7WnkDKkEGacwmyvS+uzM0WlRTmyLbiHsmKGD6z7fdLIGAXjUc5ab2RUSDw0zwZcdPvG1DqPO4OeoxT62DtbPyv1jBrEbwOOUN+LRfSRqgU+jdi3pDy+wA10ofVsv9ULU56UTRh2a4Sr1Rc5VhLbEm/wr1AtPuBuEUiYC+Wta0kRiBQ37DUwZCGGmYmSMYvgPkxxuwtyVupSsxl/2gx8SGMn1UyEsgXiEPjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 02:12:25PM -0800, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 5:02 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
> > be changed underneath us. This will be the case if EITHER the VMA lock or
> > the mmap lock is held.
> >
> > In order to do so, we introduce a new assert vma_assert_stablised() - this
>
> s/vma_assert_stablised/vma_assert_stabilised

Oops will fix.

>
> > will make a lockdep assert if lockdep is enabled AND the VMA is
> > read-locked.
> >
> > Currently lockdep tracking for VMA write locks is not implemented, so it
> > suffices to check in this case that we have either an mmap read or write
> > semaphore held.
> >
> > Note that because the VMA lock uses the non-standard vmlock_dep_map naming
> > convention, we cannot use lockdep_assert_is_write_held() so have to open
> > code this ourselves via lockdep-asserting that
> > lock_is_held_type(&vma->vmlock_dep_map, 0).
> >
> > We have to be careful here - for instance when merging a VMA, we use the
> > mmap write lock to stabilise the examination of adjacent VMAs which might
> > be simultaneously VMA read-locked whilst being faulted in.
> >
> > If we were to assert VMA read lock using lockdep we would encounter an
> > incorrect lockdep assert.
> >
> > Also, we have to be careful about asserting mmap locks are held - if we try
> > to address the above issue by first checking whether mmap lock is held and
> > if so asserting it via lockdep, we may find that we were raced by another
> > thread acquiring an mmap read lock simultaneously that either we don't
> > own (and thus can be released any time - so we are not stable) or was
> > indeed released since we last checked.
> >
> > So to deal with these complexities we end up with either a precise (if
> > lockdep is enabled) or imprecise (if not) approach - in the first instance
> > we assert the lock is held using lockdep and thus whether we own it.
> >
> > If we do own it, then the check is complete, otherwise we must check for
> > the VMA read lock being held (VMA write lock implies mmap write lock so the
> > mmap lock suffices for this).
> >
> > If lockdep is not enabled we simply check if the mmap lock is held and risk
> > a false negative (i.e. not asserting when we should do).
> >
> > There are a couple places in the kernel where we already do this
> > stabliisation check - the anon_vma_name() helper in mm/madvise.c and
> > vma_flag_set_atomic() in include/linux/mm.h, which we update to use
> > vma_assert_stabilised().
> >
> > This change abstracts these into vma_assert_stabilised(), uses lockdep if
> > possible, and avoids a duplicate check of whether the mmap lock is held.
> >
> > This is also self-documenting and lays the foundations for further VMA
> > stability checks in the code.
>
> So, is the lockdep addition the only functional change here?

Yurp. Wil add to commit msg.

>
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks :)

And also thanks to you for the review in general! :)

