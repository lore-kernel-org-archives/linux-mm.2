Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49612CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978A78E000F; Tue, 21 Oct 2025 11:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950018E0002; Tue, 21 Oct 2025 11:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818078E000F; Tue, 21 Oct 2025 11:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCBA8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:30:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A2BEBA5F3
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:30:12 +0000 (UTC)
X-FDA: 84022507464.08.DF5ACA3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7FA0E140008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:30:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KTDB8kWf;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WV8r3rB8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761060608; a=rsa-sha256;
	cv=fail;
	b=wV9yDKTnDH70WWzxvgdgo855oKM7xiBJ0JTHCTkA59R6vtK2NLOiHZY0A4kSh/VbuXiR39
	rL5Pk18UyIk3gdQSNH+iOm6Zb9hGTeiVzQRKulst6Gd/V7eiIR42jIUQaWIJUlnEIDDjur
	N/5FR0+a4TyvwLxi5dnmC8bNl5l1Zu0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KTDB8kWf;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WV8r3rB8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761060608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SA1ODjHR08eUZ9G9xxG24bjNpk4R7ezru+ZkYE4m0Ak=;
	b=68l7c5nKUska7NnSYbdGqFxEHFZ3Uhq0kg9lmJ3RoRWegYwT/qrNxqkHuNSluj0jbamiLl
	03BHiZ4S/nboyQCbDRpI2L3VE+inphIzHOUhqIvWMZXsFPm17uSZ0btF1mf4jFo0vRMWll
	3PVqCTybFfhAUMwRNRdEz7xmQHaYE7E=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEIfjv018728;
	Tue, 21 Oct 2025 15:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SA1ODjHR08eUZ9G9xxG24bjNpk4R7ezru+ZkYE4m0Ak=; b=
	KTDB8kWf2nubalYQhVQcbLcHagjUamzMb1/MxvrpDnPZef/s4gXEyAm/oE0j+wrZ
	7P2YdELuCwlz2J8Ws1OAtb9pV4aHPAByg2k7VK2I/Li47Dy79Wg+LVjq2bBlPB+t
	NMNW9nw3s5m7wklQR7WDo7WPD1shnO4GjsZQb4dQQ/40oYY+jkWtDeYovz+xl07g
	whQcnKzMoljquoDFnQJkVEtFr/SZl5H5SHUYoTuvP4H2iBVmemX9uICqeFWBeKm/
	JmvfC6p848CV1Fl+XpXAerjY2Xyly0ielQmjpzUj1kS9Ft9jbeIiYOlj2wfCBXC6
	yqCPzHd6zAIQB2yYsrnMXA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49w1vdmkbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 15:29:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEXQ0v009481;
	Tue, 21 Oct 2025 15:29:53 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bd8k4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 15:29:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SvKEX250bcbiidEaPXTfdORLDO8IAMETBFXBOM3r7CJP5yJSsQ5FTe3ADcC9kY9TDz/H5/yn04A78pLXQUNeluj/qgSnzpsRweoSygTaeBBY/jGOrYp/OMKl7fQ00M5mwN+jyGP5WMvLv9+zFpJp/iGjeTVEOGGV6WHd2ZWbL1qJdbnv5BQAl1ghBpSSIl5zPkMXB13UBwsLlHEP5pFoWNLwXxMmy8iq7U3WJcv9IVtAXASB7T/oXxx+4Xs1RYTiCVhAGvOg//2530E4K04SOcLEaH2cJFzlE1ozazHJhdhQ+2dKCeL4zehwCCoaj6TBAq1JnwqloyTOcqGU9GhyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GUnHdMsfl4H+P0quZ4EACx/6u9JJaerlG6Tqyc6xGgs=;
 b=iNWPuEDikgGtvO7IcrTCAZHtkmeV7Nk0GuMQbFMPS0reMdRalBagaGGuRT4ZlXbDLBJVzzjci5hv5nYiSwbNFjoNiKguEwbLnvziZ2hb+mGnLt2kaIJPX+Jv8Tfk0tO4j1BWygxZjvf7tsPpUNkWODWj8UAVhGHKW44a6tBWcRff8V5U+37FgnFVcmpwnKdOBf83i1aSZjg/qOw9EFHjevO0RWs9rureOyu/qDhyrGenndqmbpbowL3XHelOGMaxB2/1AQOnXNsIkx2g2v49XstkwxVR4xQEyeLz2Aoo1ul8dHlWxNPjNRjlmBkWDidaTnVkQd1RjbJwH7jfFgmgEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUnHdMsfl4H+P0quZ4EACx/6u9JJaerlG6Tqyc6xGgs=;
 b=WV8r3rB84Q8fcCnyIjoPDyYtWSgyH6GFylGGhC+flt9xQQamE8gh0yI+aEb0axzrCdYiwl+s4av5lPAMaJcPSMV0Uh8XHe98Yqg1hPGYSgWUCxNa+ZaFJjXib1zrvb0c7oYhNtacM8qipDnXoIdtpyGqJpg93HPpyjASR9pxTVE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 15:29:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 15:29:48 +0000
Date: Tue, 21 Oct 2025 16:29:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
Message-ID: <8ed25b3a-58a0-4e8b-84c3-2d787f9ae636@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
 <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
 <a25e1292-1110-4534-b7ee-b3398b955236@redhat.com>
 <2436956a-d5d2-476d-9117-a06fae5d788d@huawei.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2436956a-d5d2-476d-9117-a06fae5d788d@huawei.com>
X-ClientProxiedBy: LO4P123CA0616.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: b66fc408-37c5-4714-58bf-08de10b6ab6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?PlHnt4IT9CWmMPrVKYtRGZkVDEp/pUWA/WwW5jgrepZqlt4BIfuox25YXL?=
 =?iso-8859-1?Q?byCYnPw3DQsURjN6/JhZBYe876wlC+EbHkQLOvMj52KgoK9aNgoUYXCdpQ?=
 =?iso-8859-1?Q?bKfH1K373K9BTwcLLaTuk2WYzWBGOsk1druorxFovOtUwBN+V7Me5gE9vG?=
 =?iso-8859-1?Q?+6vNVYvITQCCiacHuahKbWMxNNUxPlP/NazZ269go5XnJDJ0PuG6xCR+tn?=
 =?iso-8859-1?Q?pB1Hopco9+eB7dGe70duCruO/gxDvH/HBYl0OfNqonHmayqJLvC3cys3dN?=
 =?iso-8859-1?Q?uAQEPCyjXuZtDKZri5YSBUu2pvqENQrTK68fitiNIL5VHtvdFx7JCvG2sQ?=
 =?iso-8859-1?Q?heAeRhDVoF7GYmpVQMlDQZr05ijVYX7ttTVFGDuyV2bCW/iCZFNXLQZJQT?=
 =?iso-8859-1?Q?1wqwEaNksyVjwLL+QR9WeadNOJQWoA7zGw6K25cLGpO+gFgVWA9kMTPBhS?=
 =?iso-8859-1?Q?NoEYXYORkwmBdVQY/r/O3wjwywMrZcSE7R19fV3VbhoWygUr/le3LX4hPv?=
 =?iso-8859-1?Q?YYEZTD1dUt7LQLhCXXgH3izqNrORQTgxcafl+e8jo/Ir01+TsFfy4q1uqD?=
 =?iso-8859-1?Q?xSmR+mISU2K3rmuVIZ8vz/aP9r2lcNN7yL3OdJdXgHWPnjYVQEwYqOwwVw?=
 =?iso-8859-1?Q?MjK5wDRrtzssi61Uz58Yjnie6JyU8wV+kjAu36U4b6YPjQKW6wpeWAr7DR?=
 =?iso-8859-1?Q?3vX4jAv5L4WNn2DU7LQhG3G9x8jxbmN4EABQKoJDZ1fYydZwfcAnM1dGz6?=
 =?iso-8859-1?Q?qnkGJWkkNQTNwUID7ScE8832/zcl1djCTGlvCkNzVdZRGkkgmNP4fAhwTE?=
 =?iso-8859-1?Q?qHN+39miXGvado5x4uYvMitdHw2CClEQY0Mh9uA98Yg8Tzxi3xbX5iBiDK?=
 =?iso-8859-1?Q?rn8xdrjD1fW2YmWLNXKw8/OjQ4KMxu+tIJgpQk1OqIe+Zgr4yuBhradCIa?=
 =?iso-8859-1?Q?LvJnxVzaHrmd2w133/KIrD/0zVr8V3yMiQmV/h9I6AOK9438AZ+SnJsY4h?=
 =?iso-8859-1?Q?pN/QzT/4r7p/1VhX6YM9XfrPShLG29mH/q5voI+bkn0kioO1Mlnjxlc1S6?=
 =?iso-8859-1?Q?2UBMcb0BwGjM43CBF9S6uRVyfvROZ0E2/AyM+xPLHqamKYXHMQHi1AC3IB?=
 =?iso-8859-1?Q?HfJQzf26aYK7QRQ33xiLRtNbv8SeDoI65c5OnlaRpCZLXk3rHWQu4p0eim?=
 =?iso-8859-1?Q?OJU35TDlVb7x1iluyxJzETQhgrw9IZPcFrO9Ay9OadS4J9avJ25p8Ue/IN?=
 =?iso-8859-1?Q?N575ZlwCgDDPlQ728yz1y7JENUascKWDUcYtGGOM+9gmLOUI1FIwOwkpcB?=
 =?iso-8859-1?Q?BJBtAKxN8fXAWbrKIPtiJB8ws6sf4sPPnqWGeFLQwgn4d8n/EcUBf3XwFR?=
 =?iso-8859-1?Q?QJ2bUvqJsxT2QnBH1DygAc5H42Su9zmcNSPAAvATB1MGpwPdzIL6xRqqEr?=
 =?iso-8859-1?Q?6BinwDDElhSU06dECTV2uxrb6Q/ZdTMED1J6N6r53sQb58LV1MH3rWwn2l?=
 =?iso-8859-1?Q?fuZco/8QEMnNulQxWq+IaD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?TyfQfeQ4HDn0r4dithoZRYRiGAy3kcDuHMx/bSMYBmWNX3WkKw0MMncMEk?=
 =?iso-8859-1?Q?GPfMEI7BQBv+VAY4WTb8pOnV2cceC70lpbR86UyrSABxq+4c1CjevKeNhJ?=
 =?iso-8859-1?Q?Yoe1DUxrxupKKg+rfrEqt8stXDJkx7kLrT4Q5MrnkRcYl6sFA9auLMAhtI?=
 =?iso-8859-1?Q?dZNQ3XELdNElSgdpX3ORE34FVDgO6HGGHBTD7rYpDyE5qU1H4h00UsijJ0?=
 =?iso-8859-1?Q?HW2+mr2Mjg9QJmhUpBH0xeOTv5Gu6UBw/ozv5X7IQf/vkZ2rDBIjMcvPAO?=
 =?iso-8859-1?Q?/Fd40i/N/jaDNIuErlRVw1YniUbE2inAzyELqeMQM5cQnfWdHjylMOzC9C?=
 =?iso-8859-1?Q?62nSDUF3fIRr1xvenPqFuokaHNW9Rz4u7cYmRnoUxyVWVQbGaMgfvQJKtg?=
 =?iso-8859-1?Q?vohIGP7dTqN1V6qZQHFGM+ny14JqP3Stof0CySB1wbXMQQUDc2d67SeUHj?=
 =?iso-8859-1?Q?dJQ7GOtCBICbcn101iSraX/7cF/OfnTockany9A3+hgEsmd4n2MhGzD2AH?=
 =?iso-8859-1?Q?FXtvFFBbEmMPJW7eNmZk4dqJpezuQPFZqKYDLIhJ+kse4/8OB6OH3kbu98?=
 =?iso-8859-1?Q?nbE5/lUH1wfxf4WrNOJNtKkApnZ8xmt+meqtPQxzxQP0fTLQWTd1djxXDJ?=
 =?iso-8859-1?Q?4kGeS+mSxEwZZQ4SC09bQFFqAyoBRfi7sszACwi9uBodQmz0+jXdGcfS1w?=
 =?iso-8859-1?Q?o1tL5LoyyXiFwls3c8lYn/JX9uGcy2JA7kkrXtoQFlsBOHauM0OQW5tci+?=
 =?iso-8859-1?Q?NwlP3XHM7cAoh+505qi/3txQn9Pt8KwK73rn6CznE4KBTz3kOr99//orRv?=
 =?iso-8859-1?Q?kXgoPOTFJNmvhdc9/TfpWAj6U0mEd8DjDaQYoueCkr4jqe/CrXqVqrs1n5?=
 =?iso-8859-1?Q?8fnZA7oMfzqrJO3STAvOKJaWlfpW9cA10oXWosd/N12+seAqNFjFLK4OD1?=
 =?iso-8859-1?Q?KjIm1wLVgE92v62qIJgWuyH+zqijerVwYuYEFLgzwDCtQb4QhxekzeofqI?=
 =?iso-8859-1?Q?8EgIW7cl5/f/d1MDwkSwEWYEXOHOVhRDUL6jb7ceaipBvZqj1ziIazLgpa?=
 =?iso-8859-1?Q?8pJDKBMfZOxcbaBl2XXfnBUrNgm2Gh1styiGr46JclWHXckGZ4Nb6teKjn?=
 =?iso-8859-1?Q?TEtbZrG1goHCYEoFIAfUuhQK9kKaNv3c41FFPg8pzcRMQzVXa1A65PnmIT?=
 =?iso-8859-1?Q?RAJn+hl1XMrWBZWmc0iFvycGsSdvWX1Qv43RP5OHI7EDwYum+vK0mCVW0C?=
 =?iso-8859-1?Q?eMcMQTw48qK3Zzjm8SJNKZX6lSe9SQIjTENZWytTSr/+H6zNy5w89dxFWZ?=
 =?iso-8859-1?Q?+cR48REgN6HSYsDKJJl97m6AkTL9IJvotT+Th40pm67XM1kGtNyoNu8JWS?=
 =?iso-8859-1?Q?n2KSz3SIRrNNXDdqtVz+xKoByX5fPjCzexwpnw33YaUg3Z/oa2dZ4fsstG?=
 =?iso-8859-1?Q?EJF3XJ5D7D33LtDRQcVDxnZOcARFLqg2vtaLBYUYytKs0ASIcjE/GZaECw?=
 =?iso-8859-1?Q?A/0IHhoSW8G4msx95nRZDoa5xgGTPa26nKaWSWPUuyvePlgdFq31H2dZ/w?=
 =?iso-8859-1?Q?/iVzQnct6goxo6PQLPBZjMJro1BSO9nP8eX93s5j5RnBmU9rAzp2z/sLii?=
 =?iso-8859-1?Q?eURVLtw8h0ZYkYfjireNXDlOuLzsdsXAoFlby11Hux62nL4nyt1NN4ag?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KLilDYR2Hj9NF7g56WTsuSLmXdiqGgcydsfXFGpBpelMS0g0wYyAINgFOa/vGlt4beVfQVWqcwtZGADjmWUWF8Yl7h8YYXSeMT+nk47mBzZKbK/d/6ecHK1+gZKDKVPx1RxMbh5zyOSFWpEOIyj125M6jUjFqYU8AlJDZRqRZkjXW/JH35LspjU9SPgV99WLoIDzsAbhaohWA6YKX4kpoXQuSAkmljpvfuV0cBeLtgcvbRNeFXcHBxj3sskecTEdZOzrxFBDJMtnI9ZrXj3j7wqCXJA9RN0CojpTekxAg0ti/O3MSB9zjFd76/eFqarzxjC/usM3KttlvEw16e14Pp14yfrkAFQot214uMh8OPg3NPzmdFZwOaqj+5pV3lffbTrZjvKeqzI87WegR48m8cCj/96IlJTVidHafTSoA3t17xujN8/2e22p8UZHFJ6BApIZyll2X1m30Gooe6hAZb2EI/Pr+35aCfuCzvOUxyiRmEuEGSakyfwRBUpo9Q7Xz0PzJniEkTW63Kz/fAt+TiLGvt5TCLveCw/ss+LzFBH0IK756HOxfRd5seEXAUsRpk6NAJM+bvJHAMpiTVmPT6vsxrH5wFdbavUIonfzMlA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66fc408-37c5-4714-58bf-08de10b6ab6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 15:29:48.0814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMp21ATMh4lt5umVelgCY1zbFwNgITHy5ve+AC8V8IYUAVcJ1OZkUZ6SNOvKL0dXJUGZVSd9LUVVBOfOhxm3Kr4hgv5udmRfIoFkeOvZN/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=838 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210122
X-Proofpoint-GUID: c2flX7od5JyHCWyVZHJywqmpGoUMGbjM
X-Proofpoint-ORIG-GUID: c2flX7od5JyHCWyVZHJywqmpGoUMGbjM
X-Authority-Analysis: v=2.4 cv=WaEBqkhX c=1 sm=1 tr=0 ts=68f7a6f2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=OzuFKciktCoAGvhAx_sA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 cc=ntf
 awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDEwNSBTYWx0ZWRfX9swE3ksD2bF6
 J3VUhHhWdO+WZOqfMuLloCJEopeee9GKeBggFfQ4Pxm2SfSKBHdOEaeOKsJbBfFvF+APy6bNwnM
 /y2zF9SfFzglM1tDoyB+crHT6TaGZuPOdpc/wjSRk8qT2LCvNwmJJO4xQh0wKfUjQzHSSY8HhIL
 HViOI/NeS+9ioxzTq3A9UxJNY/c84E77hmgk45/pRBrHnGaS64kSL8B6iuGDw7MmVIQte7O9Z6V
 ILgU8bNEBVPCZdxZWo5ESqbnEtuKV0ULXVTCCNP29nEthKOEPnK5kmMk39D4P3bCPMNvSBZtAly
 syYnnSL51E4A14d8kHXPce03hajMI8Z2zSmFA7Rs5bcGP+U0t1DvRA1CU05o5vM00YAhZeUHnMy
 6iG3ZUCah3vbNAe90ypT0eiSKSP2IrBQsnhNyroXpFZgNfKuDQM=
X-Stat-Signature: aj59iqtqf7a1or6o5m3fi7r1ai5z1udf
X-Rspamd-Queue-Id: 7FA0E140008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761060608-115312
X-HE-Meta: U2FsdGVkX1+kgBeLTMaQ1hEAJYpz4YADhxo7aw0mvo69um/b1Wk48FHU3F0vZ2UfN30lgemhhDVi/uLwQYv4kMV4P4ellCLqYoAESpzxNKXRYyX7jwU2ra9WMwK91/u8kr9h7FPxijUAVZUpMzGLC8N/j1ISkltYITMKHtOs6wq2PKcOzjzMruBJXCSSvD/Ob4N38akSBSnjd6UWAlqv1mOg0nRmsusLG5f/KghQHsZ5j+ZlQnExYr45qhAvK0lJdmd81biY8wMoTR8oSN9Aak5qvdxQ4/MH2I3VM5i3g5aqbyJTKOYdbSNykmkTaN9VzNRyojxjoo66ztphLZhbAMS6MLBhUjlecUdk/cuNcZV0hX7KxcAK6ArbgJLlT8ldcggvd2BVUQbh1OjqXuUvzu3mIwAZzuR3a+wK2DcBerSZqUXal57TO1YvpzSWDqPj6UDBfbLCmrWv60EExbVsqiBf/260hwC8xyIRQglGTdIL4ofqESyNESNkv/iD9V37TWmZhUbGp+50r1vhvpKhZfaAUCdaeQVwjhhf9/PPXIgChYzZbLVup3Qglpe8e06zU/kG2u9+hDNy+0agD9maoL0+hYQuRko+FRX8Ro0VCOoGYaVGWVD2Xhy0QTzTPyM78Ni3JeCC1tBYqQEJqJGJjLlxP1fHuvFgC9hHv37lFnRFlQqt+MDRK0qYA38inu5vEoWKvTB8lhIaCXj9LyFYmg4XIw957st2Eh1WtILFgLBpuTIUeVeCAInvLW/jv36FWgcqefgvGWFif4nEpArhxJ34IRlISJgAazAv+OgOodhYNuvD7NSFMw5UEOJw7s+L5tCQzAK8vFUssZfetXv83GDPSjt6e8tzzlpyT42H1zhB6hRsR7JC+Mi33EwqVvBH9bfpWuoOW1cUxHu5UoeQjou5Du2LTtOP+9+/fMIyOUNucv4j7BMJ5Fjk5NxzkGWEwx+pZWOv2rI7JILnp9T
 je4dR0NW
 vobKBhzC7SxWCD8NvJFmRXrFHnPLDb1GRFQw0IxR4EBVe+1JeiSMbj0oijTQyuG3xUEnLjsouBDuGExuRL6aL2LDFfYFz0xDzhgYnplBJzToBJ7AGfB5hx+ykq9I9xZlHJ/uMrYO0V6la8EHvI4DLI9Pc3hJjKbMTCLnUyibGYk5T3KQ1OvMuHfFGtMrb4nWccKja70vlxTEg6nT3pnxGe7xeQX198Cal1gcOcOxW8WzNty+RA+5IkQ/pUeswURDqHX/8SERBi2FGQlMNDG7DHDcvp65f3DSAwtnP6gzNDDCUElzG5y40JzAfk650PWRPwCN7RyOahRsA7XP6Q6yON8LkaDS//VzjdgAezV1mS0D14gwPAtDb2Qzgk8y1KuXpjA/NcokeowIZoLfreqS2ZLEpwh6V492Zw378TPAVipx20cDCzZL4XSSGRlSQN7YhS4FhSPGIrEoCqO3wF/nelPADLHm1RS0+K9V4r7OkFtLgdkbIeJ/YuJ/9Tf/aSqTkcangtYYgKdV+x7FIyhtSDNSVewlNWoAHxXzngHSJ6Dq64z82PvnOzml7YF6hDiJLP38kVnzEZKLLxzkAAMDbtENeajfEMyRVjE/uyHlg6jDUj+BWXweXJBMJ+gF6nRPYu0KIlL4EIdxypuO6XAPvoZ4wLY15gS9enit5eiNbot84BHBh7Owmu8nXtl0JMZEUE7d2Aet9+R/V3epcD5tqQ1W3UFwoSvwZJIZeWDPENbyHdI8nFxEdFAbWDB+MjDZtdmj9Vj2RIaZBfXHIzucRi/DfvCq8UXWqL2qtLM4l8OQBegxnj8YfSGAtS+vSofYiTcGjBgEEwtYqH+FxAqFQzBrvyH7OtZ7bJbJn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 11:18:27PM +0800, Kefeng Wang wrote:
>
>
> On 2025/10/20 21:23, David Hildenbrand wrote:
> >
> > > >           /*
> > > >            * Avoid trapping faults against the zero page. The read-only
> > > >            * data is likely to be read-cached on the local CPU and
> > > > @@ -2490,19 +2490,13 @@ int change_huge_pmd(struct mmu_gather
> > > > *tlb, struct vm_area_struct *vma,
> > > >           if (pmd_protnone(*pmd))
> > > >               goto unlock;
> > > >
> > > > -        folio = pmd_folio(*pmd);
> > > > -        toptier = node_is_toptier(folio_nid(folio));
> > > > -        /*
> > > > -         * Skip scanning top tier node if normal numa
> > > > -         * balancing is disabled
> > > > -         */
> > > > -        if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> > > > -            toptier)
> > > > -            goto unlock;
> > > > +        /* Get target node for single threaded private VMAs */
> > > > +        if (!(vma->vm_flags & VM_SHARED) &&
> > > > +            atomic_read(&vma->vm_mm->mm_users) == 1)
> > > > +            target_node = numa_node_id();
> > >
> > > This is duplicated in both callers, and only used by
> > > folio_needs_prot_numa(),
> > > why not abstract this to the function also?
> >
> > There was a discussion on that in v3 I think where I asked the same
> > question.
> >
>
> Yes, it is in v1, for pte, we could avoid 512 times check and the
> numa_node_id(), so we leave it as is.
>

OK so what you're saying is that in change_pte_range() you only need do the
check once (per PMD) rather than for each PTE entry.

It might be worth having this as a separate helper function as it sucks to
duplicate that.

I actually really don't like that we pass in a 'target node' but only when it's
single-threaded. That's a bit silly.

E.g.:

static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
{
	if (vma->vm_flags & VM_SHARED)
		return false;

	return atomic_read(&vma->vm_mm->mm_users) == 1;
}

Then you can pass in a boolean and change:

	/*
	 * Don't mess with PTEs if page is already on the node
	 * a single-threaded process is running on.
	 */
	nid = folio_nid(folio);
	if (target_node == nid)
		return false;

To:

	/*
	 * Don't mess with PTEs if page is already on the node
	 * a single-threaded process is running on.
	 */
	if (is_private_single_threaded && folio_nid(folio) == numa_node_id())
		return false;

Which makes a lot more sense than passing in NUMA_NO_NODE for shared VMAs.

Now we're sharing this I really don't know why the function is still in
mprotect.c by the way? Shouldn't it be in mempolicy.c + have a stub
function for !CONFIG_NUMA_BALANCING?

Thanks

