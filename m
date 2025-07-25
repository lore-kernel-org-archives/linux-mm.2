Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04711C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667B46B007B; Fri, 25 Jul 2025 14:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618646B008A; Fri, 25 Jul 2025 14:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492236B0092; Fri, 25 Jul 2025 14:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 382C16B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:44:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0867160821
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:44:54 +0000 (UTC)
X-FDA: 83703663708.17.287E349
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7425010000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:44:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VrTBy6LV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mxWaXklO;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753469091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIEIqeqAgYIUrh2go+NJCgDyVb7ZEDWHTBXr7Sw286Y=;
	b=AL3WXTsI54MttL6xB5WHor895hCRveb2NI9MunO9ExD/1NS+j78mm4Ai3hAsQ1vuxwwHKH
	WJezWfkO7FrTpjVOhB9bzfmnXad3KbQJewthx3vAIvGHdMUiBywHtnDWUimM1jnwPB6oF6
	XRGENyaMrvInVlQPrL3BwMtVsnV/tCk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753469091; a=rsa-sha256;
	cv=pass;
	b=Qn9FOPfUi9BaWXu0YTvqPqXMwQ6UAu5SeYwG4iKzPxUqbfeV9ZhZ/6+N0FoJwE/5BUULz3
	AOFdNsfjPYKOEOquIIN+sCXkNxn3DK8h4duPV/ZlvgT76Ld3MtCTCGL3zKjFZjJcNvpnZX
	p5c4MULNhVC0cC7M4wVJcufKqaIWDNU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VrTBy6LV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mxWaXklO;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGCBit000821;
	Fri, 25 Jul 2025 18:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cIEIqeqAgYIUrh2go+NJCgDyVb7ZEDWHTBXr7Sw286Y=; b=
	VrTBy6LVfBEdpOD6SDqnB5Y6XOXPM77XDBgXB4RD3da+Kk4r3gWd73b18HciuWBD
	tf4Dv2bYaofzdoFnH10soCKKELOrzKPrKqNNe9G+JNXH2MsQm7JsTQbfX5KzisSO
	VAFLrJ4lj7/RU5Plk5CDBI9exhTtqiKuEHKDtgYYVZWqGD2p/mo+RBKaeIfyU+j2
	PqV5E2caXJ2LPl63ZaiRfoRIJGzGevXwuG9qZfsWVAsdyCOl2mBG9T4QCws+2BNz
	rlxQYaUqm20dPOgDEEa/4gKkLzCJRcy6vpwcVze1kvKsCReL8Vf7E11Wn+sxHYfN
	ZLA7x8yfxWVP7owKnpuKbg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1n1ksb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:44:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PHj3em010327;
	Fri, 25 Jul 2025 18:44:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tdd1nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:44:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMdgFKhkARZnS6a5kOVCbbfta2P6P/eryb2b4jYgpjhKKxI7/O/PHpydfl6rixh303IQjKDzuVywKdY+6pBijN8GdwO/i8N7aYVNqre3Skwan8mQufQVFJbv1GP6fgCcDazHs+6R5F56VnuJeE1SkzeAq+pXvEcFdPrmJojy3PLI1zJOMdd9Vqj1wuzXGdtOztXJGmCWz/hIQcVkZ+EFICNH/8uFoUABxQBN/nMVJPpDFyRoO5ZuwnJMfARO2GpIoYUngZ7iGFO8uJ6qIH1bqTKxvrtxtrer2XeGL6t1+3426ToFTteIgklmY8P+SYldtZ/yuyqDFArwvevCeiDc/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIEIqeqAgYIUrh2go+NJCgDyVb7ZEDWHTBXr7Sw286Y=;
 b=aBj7TIOAwd7IWYquZZ7a4c9ZwN5WbcNgfqP8ZhcsCXcWul/nQTMX/0K7aQifU1Xr5koDTbC6B+wc1990k6V3WcpoLHEJt/q3vXXCb9gNGQ3uCFwD+RR1KMKeFQRwRYAAzDx0k9maoA6Ol1h7kRV6ZkjZK0eNQWlrMBLII9s1osLB8lgKeZ5E7yAMJ8ZfDOtDfPoWKcn3Rqmqiglvnrk09s+YD1uTjoR1BWwq6c+aWJWy6SuLrTHeEch9pfWLm7VknYvpYEhTdJH1RFeKKxuSXIKTJTxmNoD7jwf3bIYMpgQp48rH6dbMdGsmnWpTN17mQ58eq27JbeCjodAtHmx1Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIEIqeqAgYIUrh2go+NJCgDyVb7ZEDWHTBXr7Sw286Y=;
 b=mxWaXklOq16jp/icsDsP4GsMQDHcqgb80t1xZoFZFs42d3eS5gRC0hePvCqCyuZrTN+DF9tdpIFluDS1bBgeelU40pp0jV6tcWdkU44c/gmjhUYWiSHGPiZwWhyKhoco7qiYbm7CfvIQ0ugtwI8og+Fft/Cuj7xf36QQT3POBwY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB6892.namprd10.prod.outlook.com (2603:10b6:208:430::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Fri, 25 Jul
 2025 18:44:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 18:44:43 +0000
Date: Fri, 25 Jul 2025 19:44:40 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 2/5] mm/mseal: update madvise() logic
Message-ID: <0a2e43d6-9015-4cab-87d0-d6caa97d966f@lucifer.local>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <492a98d9189646e92c8f23f4cce41ed323fe01df.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVSjRV_zz0mhuRF3t3UJM_x=+gct1jbV=qd7eNMPBbvkQ@mail.gmail.com>
 <a1691645-18ce-4e7f-846a-a5b498df948d@lucifer.local>
 <CABi2SkVuS21VgXXB80bs20=fg6+Bqm_LfQjknZhqRMGYYv7-BA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABi2SkVuS21VgXXB80bs20=fg6+Bqm_LfQjknZhqRMGYYv7-BA@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0653.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB6892:EE_
X-MS-Office365-Filtering-Correlation-Id: 5936e58b-05e2-4e87-8472-08ddcbab520a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEJpVHFEWVRBYU5pd0ZWNHVOQkRSNndmZXpwSThUZEtWZElzb1loZ3c5bXZo?=
 =?utf-8?B?SnZWVE5xR3lVdDJLRlROMzEranlENG1JMjNrK2FMZmJNa3VCODJRS0FxWGZl?=
 =?utf-8?B?dS80MTdqcFdHNFJ6NjVFQ0dEclB6RkJBN2Y5WHFkUU9kdytqOUpBTzRlVHFG?=
 =?utf-8?B?bHNFR1h6Y0tNcXVxeDVTWFk2cUE2TFFHR09mV0dKdlRFaVY2YmVDS3lGK0kv?=
 =?utf-8?B?R2dUUXpyVG1sTW1DbDY3TXdKODI1RGV2a1dvUDZGN3h3Snkvd2k5SSt1aVRn?=
 =?utf-8?B?MkZFL3RUZG9IdnlXcjZFcFBDcWVtQTBoakh5d3AxTzZmZitSYmc2bGwrSk5D?=
 =?utf-8?B?NUdmSHY1NUhuMTZBZjZ4aW9lK0tGQmoyU1cvRmh5UStIdHNWZndFMW9WMWpR?=
 =?utf-8?B?K24xYXNwZDllSUZTY0ZxTUs0MmJXdTM1ZzJRaTgxTEV6RzBiL2FMTmdYQ0or?=
 =?utf-8?B?eXAxSVZOb1NVQUMrT0FiNHVlOEJUMVdlSVd2V3pmMGhvUlVwTUQ0K1R0dDRO?=
 =?utf-8?B?RVoyamxWeXNEbWpDNzZOQ0tuMzdrdTV3S0k1OXd6OFdoVG9HaUovUTZQSVR3?=
 =?utf-8?B?VHZoS0tzQm9FdDlCcTk5c1ovbk00R1J4ZzlDNVFTR3h4RWxJYnppd2ttN3l3?=
 =?utf-8?B?bFRrU2NBQTZqTHkyeE5ZRm1TbjJzQ0FsUytMMWxFU3h5TlBFbk5NQ3VQLzkv?=
 =?utf-8?B?NjJ6QWJqSU1XcWpNVHJUbHZ1ZkkrRW0wdmpVb3lHZHMyZTlQSDRaZENydmRZ?=
 =?utf-8?B?dlhhUFFrUklNVEUzcVRyVTdtekw4eHpVZ3l1MEtSdXA2RysyQ3ZFcXpKWG9l?=
 =?utf-8?B?UHBHMEEydmp5RDZQL2ZEUGVpeW1rTGV0UngyRG0renF3ZkF6Z255bU82MzVW?=
 =?utf-8?B?ZVoyd2IxZ2Y4S1pBSHlPb2p6NnR2RE41MWVyeHJBOHNEUmhkaDZWZHpnTzdn?=
 =?utf-8?B?Yk5DZUVZcEw4YzlhR2dPWXY4YTJZUW5PT0ZISVMxa2djYkc3bktYN3Z4VkJS?=
 =?utf-8?B?L2xpY2c2ckpyUkZtQ2NNMnN1dXRkV2FLazdQTXB3ZnVLNzgwSE9NenRQdm5Z?=
 =?utf-8?B?YTRuWC9aQXN1aFo4MlVMRTVRQlJHQWU3aHp3a3ZWMVdpdk5qUkhLanNVQlgy?=
 =?utf-8?B?Qm5wcHdVbkJvb2Y1b2tGbktWUFRnaWhpWmZKeEh2UTFMUHdHVkJPWm9KWktP?=
 =?utf-8?B?bElrR0xYcThFK3FzUEhyZnhaSGJPeXRvMG90Ui92NWdYQlcxa2pWQVVrN2hO?=
 =?utf-8?B?NlNESVBuYzVpY3VsYVhSYWFQbkgrckpmYjRzd0JlQnQ1NW8xWERCUUp2SXdT?=
 =?utf-8?B?Qm15NUJKWjArWFRWTHJBVmxaTUpITTNkaHBGTXQzaVAxZ3lUdnFBV080NVlO?=
 =?utf-8?B?QVJwSGZSMjZNMHVyanpHYlhJQnIwN1BnVTg3dGhTYXFaQjN3YkZaRlkwT0t2?=
 =?utf-8?B?ZXorUGdkUDZwdy9TSXZKaHRYUFp5dUtubnlqL0lJZnQ1OWR3ekNwdFYxZFdZ?=
 =?utf-8?B?ekFjZVNwRURxaEhnVmtjaGpRUmxPcmlBaGpnRWtMTURrK0QxTFlBMEhpOHIy?=
 =?utf-8?B?UlZZTUF2MmlSZ3cwUU9DZ3NmQzFIcDNGZGNVMyt3WUFETWFkVkFGalVBd29G?=
 =?utf-8?B?QXVZUEhsRkhmdDlZTmJ4NlpqRXdpOHIrbnU5WE02aStHNnVlaDlOSHpVUi9m?=
 =?utf-8?B?dmhhVGhTRlBzOTNSc3JtckxtaFNXSjk2Z05raEdqbEpNN2pGaFU4Ri9ISlNP?=
 =?utf-8?B?ajNHYjVwcVIyak1lNnJaUkFaeUlsRjdLZTJGSVI0YWZ3OVdRenJKK1h6OElF?=
 =?utf-8?B?TUZ6SGtLSEIzOGRyUmpudlpMMGJ5UFk1OUZ3ZzEwYkZiZHN2cVI3SzNwVFVk?=
 =?utf-8?B?dzdPR1FmVy83Z0YzOHQ3WEo2ckNhWHo4ZFlJY3pHbVFxUUduaElPdEd1RDY1?=
 =?utf-8?Q?u3PS6RBPJrc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTZpby9OaFUwcmxVNUxNbVk3NlhRWXhBRU9NZFJhNkNPS0FLWUtzMXRNRERp?=
 =?utf-8?B?dGdKZWJDakZqZW5lZmx2MTdEaWdKZHhFYWVKTkhFUzdhSUZSRlArM2tHcUE2?=
 =?utf-8?B?anlVMHU0dlpJN3R3RGRPQmE4WXV0N1UwNUdaQURKUVdSZHF0Sm4ybEFMbjlv?=
 =?utf-8?B?ckRneURIQlliV2ZNOXlqUVd2b0F1R0RNY3V6TXRBNnA5ZERKWU1EOGJZRG9r?=
 =?utf-8?B?Z05EYVQ1dVJEdTBsNHBQeDkzSkdpSHd0MVNZdkRJeFpFazMrcEtwK3UxVXkv?=
 =?utf-8?B?R0ozeGlzcHRqQlhKZ0hvQm9CbloyS0lnZGhJV1lsNG83ZWlGckZoSUJjN3JC?=
 =?utf-8?B?UmtvRVpENnczZ25TOHU4S0wrb1JyYmYvSlY0S2VNK1M0ZThtdDFZdU01TjVV?=
 =?utf-8?B?aEVPME5uaC9KWjdWQ0ZlcDVvWEEvMVdRYXE0MCs3dHloM2RYcGY2VTdid056?=
 =?utf-8?B?RUE0WGpQeWRsYWg1L1NsZzR1NXNYSEdsUmN3Q1VBM1Q1aGZzVXZBN2RpVjFJ?=
 =?utf-8?B?R0dCK0tjYlN2MU0zUGZNYTNPclRpT1FucXRPRUNKMURuV2RsSFFZWUZ4U2lN?=
 =?utf-8?B?MVFmQXhiSll5VUhwZ3RRTitRTTBQeStDTzNsNllTT0RsWTM1SVJ4MTJyMmZK?=
 =?utf-8?B?Mkp3L3ptVE1WNUREYVJKVmc0RlNCTGdEbVpWaUkwY3lYWmtUUGlqYnAyQ2U5?=
 =?utf-8?B?VWNYZ3JZcTV0cmdBbFF6bEwySHU0eFY2dXdMRVI1b3A3WkxwNFZxbnFhZ1BJ?=
 =?utf-8?B?K2c0Z0NpWjVhK2haVnRBcndqemxZeVJudXJPMkQ5ZDVqMzBuN0hWQXQxZzdO?=
 =?utf-8?B?Ni9Vd254aUEzNXpTc05qNEh2RkhBYnNkRlVld2wweTZRcDBIMUs4WEtTaHI2?=
 =?utf-8?B?OE9oRy9jS3RTemR4V283L2VUNmlZL2gwRHgyMFdzYlVyUlhYdC9SWjc3dDFS?=
 =?utf-8?B?ZmVISWVzYWV3SHpBSTd6dCttT0Nub25GUGZsbnZwM0NjTFFxVUNZdEVoRFIw?=
 =?utf-8?B?UFN6aWVpenZHT1BPajRMamhPTE81eWNzWnBnSktHU0VoK1R4VnJVY3JEWXpT?=
 =?utf-8?B?ZldrMDJndXdiaDhBNWZxR204Lyt3S3luWDlQV3hhTno3VTdOTjFEeG1aRi84?=
 =?utf-8?B?bHZLOHJBK05QM2picVRSQjlkV3U2K28yN1hEbTRCT2U1cFdQaFhJUURoL2FM?=
 =?utf-8?B?WTJCZjlBSy9USW1jR1h3VmdIOUpjWlpsdUkwcmZ4NjJlMWc1RkJMclBremRV?=
 =?utf-8?B?cjgvZEduY2tpSE03Wld2NnVoR1dBK0IyUWNkUEp0cTVKZTVIOCtSQ1hjUmdT?=
 =?utf-8?B?aFNJaTBkVmRvUzZwT1Y2SFh2SGh2QTZQQkQ4NkNiRlErK2xMYytnc2d1Y1pq?=
 =?utf-8?B?Nk14SitOa0poRnRwUWw1dkV6M0s2R0xQakxCaTI4NEo3andaWFdlT2xrNEJH?=
 =?utf-8?B?RFJUeklrejBJR29VbzU4ZTgzQlY2NDRTeDB4NUNlT2o0cC9OQ3gwRTFyQjRN?=
 =?utf-8?B?bUdmRWhxb0N5MENvV1IydkRRYXIvTlkxUi93NEk3d2dBVHhrTDFadXI2MTk1?=
 =?utf-8?B?K0N2K2pENDRtSFBURDRhNzV1SnY2R3RadS9hWVIwanNIVFNLdjFweGpJbjJX?=
 =?utf-8?B?NE51UUtVU2RzeGlnZjVqU1c4dU1ockFoYnlZWFBXQW1FZHorbWc0Z0x0U0Ru?=
 =?utf-8?B?QklZbjAzYnpZeVpmK0E4QkRHbGFHNTd3WWw5bU0vUFBnanlDWmJIQmg5OHYy?=
 =?utf-8?B?OGpuczNKWFR5UUJaWkp1ZjUzZ1U5Q2NFS1ZDUVRpUGtHRG9WdVZoRG1yci8v?=
 =?utf-8?B?Vk1pRWZudEZsOE1NTjJMcVlzWXQ3NnlNbXRKWGVVcmI3YnJVUlZxTkF1TDlM?=
 =?utf-8?B?NTFoOGxFbkl6WHF2T05aeVQwTTE4dXlnNzJpb1dzRXB6ZmhtaCsycE1BMXo0?=
 =?utf-8?B?UHVTeFpFYVhhM1cwYWJtelVsU0cxY3ZnbUx0UzF6ODcrazZwMWNjNE1DeS9r?=
 =?utf-8?B?aXpvUGF6UXJCWTNxeUIwNk8xMGZDNmx2V01aZnlRNU1LQzIwRCt2cnE3ZlR5?=
 =?utf-8?B?ankyc1FjYnljck9zVlBjUzVEYnh4YU9IdUlpQS9jMytXcGVWTTJxRjVERE53?=
 =?utf-8?B?T2RyL2NnRzZsZjlXS3BCUUF1UGkyWGtDUzZZK1R6cVVzcjR5NTVicEdPQjZ6?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iaRicqyH+KSgB4BnYwujV2+tdr5CiLgqPYtfd/iQ7U6fm7p+G4YyerLvenpfjAZWudNOek3dToswfFBwkp3VqSCAUdDryKiU7YLqt3a3lmRWIZm9e50l6s4anWt0THSzOayMY5GXymZBKMVst1RNzrbfiDvV+QhYlGnvjTW62lZ/wiGUx+8D456igSscDyzn3Ek5vpOdYwt2zjPBnhvSfPNnAEDvxDv4LzsjuE/lQ5zUSkAZGizQ9HcgushbT59LNnQvrSr//vbGGIlyWqBfWGv+X53WIEPjlRFR7H+3U82S0ClYR1PsEI7ll8kArFmhuJ6hQLGzhy6a4FLXa92nL3HdN+HHTk/WkU6fguXZG+7/TBM+xnIxtp8cEoTAogtUd07C/ob5Sk5338SILBch49dJdlBP369OXAVXOQXBV7gPzNykabogBarTwA+RVbKKdhtmjBONn3cYH1NTQhhXgUP39Jz32icoPo7V15rCYv17hxsiII7oOdp2xZKpnHW5BguW85cpFjmpinKdu0DzeFYY62CJukzALXBTj7/qeadSLOoWcuyl3m8/MwPe1yb1hiN3oGSV3QYqXKsXg/oqUQZpS0M0gysxL2+2H4KVhKA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5936e58b-05e2-4e87-8472-08ddcbab520a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 18:44:43.3372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuaQ6H/miSBkcMMFxKjOwfIYfKNFHTrALaiTmIxOENKi9ClmOHvkh9GVr707dzDrgAv5YpaUeZUvkph1zUgWttAgvOO9aKIuRLO+k9K3Jso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_05,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250160
X-Authority-Analysis: v=2.4 cv=ObmYDgTY c=1 sm=1 tr=0 ts=6883d09e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=LiCleaz9cKZhoZ4ml8IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 1u73AsMT2QFlksgqq7ycVWnywg9ezupb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE2MCBTYWx0ZWRfXyLSNDZr3APjR
 B3knMnqWCpcqLU2ukGOOpwO3RolNzHQFhP5hq74ebsrWyo0UD3hWL4koeb2fjkbEUclTGyLSPIe
 JwuM1xmAgHK9wwSnxgNikk2cURIYnjyBYTQXLQMl11jftteQKWERFS1w2pjut0XzMoDGGasPh5I
 ayRHqqBVqCJT8Ta9SPy3BYvlYvBGyowVS/E9r48NmTW3uv3oahLlsyDmdo/OfyUyedgzi75GNJr
 PH0trcuebptwAVAfvksOgAh3zpr0JF6rTEfqDudlBYbSex8sjqYwEmfkypu05zLiViTUVwok7/5
 wWY8+/r/PIAp8DON+QsrUfBFNgTNafUOAdnP/dTekWnEu66rpEkjtXeQ9yfyFr4ZpjNNmkw85hS
 q7Q9966oW4aMtf1LAI3KrrgJXImyY4gTpqLhs83Mt5rYMiGIwNOVqO3o6YuFY9bLQYlSEhXm
X-Proofpoint-ORIG-GUID: 1u73AsMT2QFlksgqq7ycVWnywg9ezupb
X-Rspamd-Queue-Id: 7425010000F
X-Stat-Signature: fkkwmcik4zff1xac18ym1xmfa3os9dz6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753469091-832582
X-HE-Meta: U2FsdGVkX19G/rCS3pnmfu11ediqyWzWJe3AlYLhpKeYtfteKrMT6Xrrp2OjVn6KE8s0RNA3oKaeb88nFJmoVMDInjcT8M1OB49giv8PSYCRgwIjafdiSgLnCIMSEdRTLuZqbi250IPZEZ7KDHZkq1xD9dU+IEMnVryoMzB2z6RfXvWI5mbZ0Qs541yuWrpeMvbQZx5Im7SzSvO4rBqXMfO3VNdyopIH36huwj1hbhWHmTQc9UqFjfdAWylQWenRt79jW9Mdfkh3tzVKIrdoa3E+CpPT2OoMW73VHy/3xfsqc3MCYX6qau7Varl6/L0saOZK68R31pykLBFxHQnaps5ufyLQhrPPlv7jrs8bMd5jDHfuaf298cwo0EGfa/dWYvqqbTqOwZtQVMcj+tmFd47zolqxDQunmPRtvkSXJ+AmHY9vgh0tbkn9jIvR8KXAaL2yVTKGT55ddb5xkvRHHz3B7TIdDAgTPKLq7z1zGF3kGnK7vhjWbbMHgdl6dW+//oH+MM9meKR6HxKO7T4zHUt8haHEGAEpTVw0Ryvl5yG1qAKrJsA+2J0/v9V30y2uTch+AjefQgIRPMpODQv6pj4MBhPjI/77q7FVFDMLrH4DWDTWWl3cpFeCx4iKvbHlIpS8FANaRhfA1txGQS+q3jf0/er2RLbjjIKU7nzS24azGByRXiVg8eQt7XmkH0aArpijwxClwYS+y23nzMhSHk9C9bg0XgMKsoG8koOPluigTtpyzC4gZRd0LRfJXgk+lqZtLALb747r1h1dehuNSPBcGEd8ceuR1Eb7sT3K5bnAxyfPUY7h8sSqmaZ2OuCOvOoJlzM2u13e/TNZJLQuPZ1EZeMNyKrwnviL8WAmvaku26x1qugt9EJqOJRfLvldRi84AffF6AFT5R6kWBrjJ58KAc+CYxCWXyWbdpbdq+SBdVDl/9DgZi1SoZd1OnpcTyouy1v2Jt2A2zUbIL2
 lGa+XS1g
 Sw89AxFwvnM6Nv0wtwkkA6ivxItDJiF7daBqtjGn9zM74ugrHm5Rip95Kn3K9unvwjAo2hK4HjPVoF/+xONnAe2a1BLNxblisbceHvskGtXDQSwoNygdwgXQfOExSCrQxCcMRNOGVremc2Zt6L5vLWx8moi9rOBI2XSTng6QArqQvlQM1dXFcA04HVG9wuJjUEJKbILXa4zZVGcd1QRQxQm/rAx90wjHfb8jF1U+Ik4aBA4Tge3MLtbHmsLHhsw7FDFlFHJWngRpHcOhGTZlNWmWEGkEurWNVmJyhOOx6Ujso9okMJK9xifTIj/x8x2ZcUKw/td7omc1aDS334xMIB+MzfAbvAn3vPbKV13EwR7XnzKzUA0LHaZaWhFvRWJw3bvb+KUH2KZEBkwOZ99c8e59BDVzDUht6u/ihXn8qAYyftMYwEfuoltEXk+Fe+RK5OBIZ3xouRv0iZo6TJLN7j5G05XVJ4rCYmAE9JYBwAbbz8zmn73auZsd9izN2IHw3bDT+Wk0pMj5bEtvDffoaqDU8EqTyn4OXVH9ASHeriQoM8mBxuGL6wuRvofE23XnU2NqwlByebhy6LJRkFWS45SwXoUVgS5eQ2Xd/WFFfezJANivKAEwyun1sCwL3E6qWoXO5sVJmz2ZdQFayFy9e1e8pgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 11:41:15AM -0700, Jeff Xu wrote:
> Hi Lorenzo,
>
>
> On Fri, Jul 25, 2025 at 10:54 AM Lorenzo Stoakes
> > Thanks, that's a good question.
> >
> > So for a function to be mmap()'d and file-backed, vm_ops _must_ be
> > supplied.
> >
> This says that all file-backed mappings must have vm_ops set, but what
> about the reverse? Are mappings with vm_ops always file-backed?

Yes? Otherwise they'd get treated as anonymous?

We call this vma_is_anonymous() for a reason ;)

>
> > You can see this in the fault-handler:
> >
> > do_pte_mising()
> > -> do_fault()
> > if anon -> fault anon otherwise fault file-backed
> >
> > So if this were not the case, you'd have file-backed mappings going into
> > the the anonymous fault handler logic.
> >
> > This covers off MAP_PRIVATE mappings of file-backed mappings too, as this
> > is handled in do_fault() by:
> >
> >         } else if (!(vmf->flags & FAULT_FLAG_WRITE))
> >                 ret = do_read_fault(vmf);
> >         else if (!(vma->vm_flags & VM_SHARED))
> >                 ret = do_cow_fault(vmf);
> >
> > That does the CoW fault handling.
> >
> > So the vma_is_anonymous_check() here should have the same semantics.
> >
> Just to be extra careful, does the reverse hold true as well?
>
> In anycase, if you are confident about this, please do state this
> change in the commit description that vma->vm_file and VM_SHARED flag
> check is replaced by vma_is_anonymous_check(), which is expected to be
> a non-functional change.

It's functionally equivalent and can be seen in the diff so I don't think
this is necessary.

