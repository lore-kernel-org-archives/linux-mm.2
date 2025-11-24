Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB02CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FC66B002C; Mon, 24 Nov 2025 05:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57BC6B002D; Mon, 24 Nov 2025 05:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F88D6B002E; Mon, 24 Nov 2025 05:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8499F6B002C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:43:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65E3D8873B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:43:56 +0000 (UTC)
X-FDA: 84145165272.30.78DC655
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4765120006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:43:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X+s01BnQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mUo5NOad;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbHeWmpHhyGf0Vp8mhQdeGAV0yECn2/PReDlujvi8uM=;
	b=MclyINUFjcK19bWsvEurUAt6DcdmwuBnE28dUaknFUXxYk6xgtoypUyO/uF/0d3RvEUW9O
	HzotLdOtXcIl3CkKlDRMVI3kf50Mq2bWhnBTy5KKalbhQcBmgIj6d8oBch9jkEqeaOAUdB
	w2U5Q2x88Cdg79JsDHkuJIIbg3fJ+h4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X+s01BnQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mUo5NOad;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763981033; a=rsa-sha256;
	cv=pass;
	b=8itfIGt7rGefCoMx/QjtfnvTaojcG5kGtBGkfbuXtYwwpVd42itRXDVBX+s1wBNABxVrkR
	8Z9CyfakmW6Kit7HdRafLwHG81v51CUsDP4DHgQRtkVKtoSkGwkQxTqJpTPRbYHAQbc7K5
	snOtp9qzlw3PEHuDsRdEj/hi9dlnzXs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO8v2OS724786;
	Mon, 24 Nov 2025 10:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WbHeWmpHhyGf0Vp8mhQdeGAV0yECn2/PReDlujvi8uM=; b=
	X+s01BnQO+7aeXGd8xKEhtmn673JoXnC78xFqdN2U1NAHBKem14GRypZoijPy73t
	cYSy1AWJrSU6sekx7HJOlAcMbZrZbduzJcxtu43KMfysnIOVJHbw2bodILeqd6pW
	s8FtKXfW4IbgnsRHTjDQe2OxZeGhKbCzL2v+8oPI5iGjNl3C56hU3OKmA5PmyCIg
	gYUID/zajI05ExAg5s1IphaI/Ys2msCgfr6dGZrreUByHi31szOMvBZ3qyK/amiz
	SUZgYTWp8Nw0a8XL8jnaEE4qaKKhDvU4feOYn7zfBBv/SgiodFZy//nhtzdvscch
	QNODkejDGY3UQhFibspmLQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak811hryn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:43:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO901qR018859;
	Mon, 24 Nov 2025 10:43:49 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010013.outbound.protection.outlook.com [52.101.193.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m7y43a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:43:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIexpiuWLGYyzoCxCHM6FAP/q4/XXM6t9Qr4LrJ7I72RoUAvycRX9ZjxxhmaY6rWSsSRy/gqkHRdvBGkMTpApTbpHpAn6K6iSijPtC+mrYuXzka8VhpMH4nJH5gUgJTKuPNAkg42aYlZDuRq1JRHSvmBijOBgsaG/YIETsyeYcwyztPG4npW0Xy03XJZGcRjuWawKpfy7DqFKv8eMKsKUqVZ22uRQEl6KBWhZ8jtrikoPZNlhGOn1ds9UXKe1q34DIcwOv0CYkIQu7rtykbGCvMSQLi+UGOyiJQ6XFtHonNbf4cgQay6g9zvRvMs7egzF6/hOxSWBgr1aj33+AY+1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbHeWmpHhyGf0Vp8mhQdeGAV0yECn2/PReDlujvi8uM=;
 b=qwLuTeOS58DFUujulreedltNbjxPBdqvHAmyWXwSzZK0EOMTj5UEBpKNhk9tleMVlqYxJX0wTvWyi/Ke3mwjSPkRZIP4ULsrUO+vYg7HNU0NLoj6hzGq8Wj668k7GaA9xmnoMTeb2Ud8mQy46hj7mOEzr8wExRLDufmpbifhDunJogtwiig3uMcSg0GEFiH4UFLT1oJODI8fMfkxmbn3urQLVivaeuYrl6HjCfQWhaehiYlqwFDvkt0DAq6dK/YfwIrikMzN7EH3bS5IW7/HlHekIZMsxa8PDB6wcmAQeKYQwDENAGuycjynxPN+k9wYy0UM5fa2v8JwohWfCLwwkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbHeWmpHhyGf0Vp8mhQdeGAV0yECn2/PReDlujvi8uM=;
 b=mUo5NOadVxomV18jzDs0X/9aDnY6jnlMaO/zqmWKa8714/GVQnqxgomvg7oxFbxz7NJdGm/tgpLQLvOr6KqSA2Qy4PRHw8JtNrTtzjMz0UA814BiFQBoPpShwfIZV6/v5hssXqnGr/9EbGDlFeY6YgR9/PaFpR6p0o5JevySkNc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB6960.namprd10.prod.outlook.com (2603:10b6:510:26e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 10:43:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 10:43:44 +0000
Date: Mon, 24 Nov 2025 10:43:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+3e03c904429660114599@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in vma_modify (2)
Message-ID: <b90c9e30-362a-4448-b4c7-6b57627f1c9e@lucifer.local>
References: <69229bf5.a70a0220.2ea503.006d.GAE@google.com>
 <744134e8-387e-4429-b878-87161a45113f@lucifer.local>
 <CANp29Y7zio=dAByyup8joNG2Ufas+ta=esOShvOMu3j9tRHvRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y7zio=dAByyup8joNG2Ufas+ta=esOShvOMu3j9tRHvRw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0219.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB6960:EE_
X-MS-Office365-Filtering-Correlation-Id: 61e46a05-ce52-4145-d399-08de2b4656f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjZMUVRXUHRNUGszRHBiVU82bndsS29FWjJYejc1d05ldHpOV0JGN1IzVVA5?=
 =?utf-8?B?ekdxWUl5c2hNd2NJR2FKVDlYTnhUbXFCeFJXSGZuU283RmsrTW1JeVNyOGVW?=
 =?utf-8?B?M254Y1ZvaEZWSmZiS1p1dDdIeGtTTDNPc1NQNm1lOWZMcE9wVEFEVEtLZmt2?=
 =?utf-8?B?dkpVNWVUOVFmYXg3RUxMMmlKQVlxcU11cHFFWmd5MWlBTHVKYWRhZmtwOThW?=
 =?utf-8?B?S2pjK0dwenZGQ3hqNXpDWDA3NjlhRjRiV0xmam1kRm9NUjBlZWthUGh2SCt4?=
 =?utf-8?B?b1VIQnMvMVg1azduSnlqVkFoU1NHSUEwNWdOcFl5WXNka2hjSnQ3U1pnSmNW?=
 =?utf-8?B?bGFkZy9jcWk3VnpvcU5wcFRrSGdxcVQ1dFR6NE83RzUvbkxGMWZGanJHb3pU?=
 =?utf-8?B?eVMwODg5cGxvdGE3SHNzYklLSS91RnRDM3FaVWJGbU51SlpRRmY0OGVqVytj?=
 =?utf-8?B?YU9zVzh1VGt1dy9FNWhkc0RZNmlPSjdnekFITmZMMXR3R1hGcFc5ZGNNdHdm?=
 =?utf-8?B?T1BQNllBRGt1WUhDWFB5WThrWUQ3aVRNbjN2aWVDRktST2pRbGtMSEgyek5h?=
 =?utf-8?B?bDUrdFJyME9CbUR0b1I2ZzdLYm1sVTJjcUFzYWtjSUMxOUplV1NlcTB2Rkt0?=
 =?utf-8?B?dlFsTEt0M2RKMU5wUWFGTUNwU0wrWUkraTVVNkRxQWpUSGtFbjYwY2pXY29L?=
 =?utf-8?B?Kzl6akh0djRUSlBiY0FhQlJmMnV4SGh6RXdNMlVjQW5pdllyZVh0azlkVWp5?=
 =?utf-8?B?RjF1U25oQjU1d1c0aU5XaXRweWhpRzZLZEEwT0VacDdGQ2taSWgrNzkrZDhi?=
 =?utf-8?B?dzlxMTlwVnVzUk1PRFFhOXVPUDhUOThuYUxJbzhZRnZDWHRxNWNWZWFrd1NB?=
 =?utf-8?B?WXNnb3BDcmZORWp0S3Z1UzVIaVZ3dmVPSWhNOWllUHVKMmhHOUxhK3lxZ3RO?=
 =?utf-8?B?TDNIVXZmRGNwN2dyeE5sUjFjZEl6dThCVW41NkxkYzNLUXBoYnc1ZTdmenRQ?=
 =?utf-8?B?MWJNTlJyRFpGR29WTE1CZHVPSFVSQ2YvQWJPb0ZKV21mVm5GN2F4aE82Q0sz?=
 =?utf-8?B?ZUp1dy8vRWdwWHVoR0QwNXE2OCs2SmVPRmxFdzNjUDFiTXlBQUxQR05IWlIz?=
 =?utf-8?B?eXg0UzhCMXBHbUYxa0RoNkRaYmNsT3kwVnRRQU1seEt4NXdVV3gvU3U0emRV?=
 =?utf-8?B?ZHluVXV3UGRkRFU1VVdmcHNHSm9lejJtWlB5cGErcDJ6azBvMzBiZWZQcEEz?=
 =?utf-8?B?eEVKaWZZSWI2M2hxcXI1TFVzUzBOL0lnaUw3OWFLZVFKam83SzVuQUxUSUlK?=
 =?utf-8?B?N3RJQkUvVktvZm9ab29pSmhUaE8xRmZOdStXa3lzS0RBc0lYbTF5VWdQTHdi?=
 =?utf-8?B?N2NYbmN0dkdudE5KempNZDVmQlE0azJScFkva2g1K1FOVEViTFA5U2JKcW9K?=
 =?utf-8?B?b3RyMDRNbHA4SG5YR3BCdDVMMnlyOEFha3I2bUNJTUc1WHE3MCtIcnpmMzZ4?=
 =?utf-8?B?VkYyTld3bG82M21iV01QWHpENjVMSDZWM2UvMFJnQThJWEhlc1VFYkNIN0sv?=
 =?utf-8?B?elhTTDFIR25ocWh4MmVkM05JWkNyQmxHSlFCcnFwR1ZBaG5PS29Vb2MvWFdY?=
 =?utf-8?B?S2RBRjZ3aUhWc0NPcUhwVmxyOHArRHphemZnN2tNWE5JdW1jMzhDeXlPOG5i?=
 =?utf-8?B?TW52SXBJNnpnOHVkcFcxaVQ2RjAzKy9mZG0zbFRUUFdWSGVBRUxGL3RuSGl0?=
 =?utf-8?B?c2Y5YTB1R3RVUTVVV1hta0tqWVdxV3orWnQ5VTRmVllpbUdndFJQOEVpV01q?=
 =?utf-8?B?alMwVG9uejl3c3Z0QzdZanBBekVuSHZlYW0rQUIyWUlvVC9JY0JSZ1BCeksr?=
 =?utf-8?B?Z01VNkZ1ZHdtdnAvbDJqVWRnVDNQcVlUOSsvdG1ETnlJSHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXRNR0pHUHhETy9oSUk4dkVsVkl4Kzlub0ZZUHRjRmwrNUZ0K3FYRWFDWDNi?=
 =?utf-8?B?ZmNla3NsaDF0YlBBWEoxRG9JT3RvZVY0QUoyNGhyd3hYakhLUUdyREUxOS9t?=
 =?utf-8?B?NTJ2NE1wWG1tQmZoL1E3L3hGMnMyZkdseDVoS1VQTmZkdnkzeElvdHZiMjlR?=
 =?utf-8?B?MVpBTXlFdDRaOFZIQmNlUGVVdU5pc2ZQWHh0RHRpSW1WSFJaMWZmNUJibnRD?=
 =?utf-8?B?MDd2KzdLY2ZKY0JNUm11cEhtUnpXdTYxWHRtekdKTWRMSkFOT2ZXOWtlSEdZ?=
 =?utf-8?B?OUVFYm5BNnJnMUVZNTBhYWI1Um9rOGsyQjg4L2hjczc3bTBwSS8vbHJKcGJM?=
 =?utf-8?B?eXlJMC93VGFZNTA3YWsxeUFYSXNuZ3V3enNlOE52bkNIejZYTDlYcm4wOXc0?=
 =?utf-8?B?NVZNRWFrejFrTkFJRU5MSjlacS8ySE5zUDJ6NmRtcHR2ell4bFFzS2xPWU1H?=
 =?utf-8?B?bi82bnhwUHFNOHBQT3JxZ1hrK1dJdzlUQUJ5cE1lUUM1bXBzZ08rdjBRM215?=
 =?utf-8?B?SmdNS05vbXlpZW9oRnRUbXorZmVwbXV1QnJSR1hkYWY2VE4vZGNBdEhsdTNu?=
 =?utf-8?B?czhZbmNOaFBvQTVqZVhydy9nbFVERkdBWXBWek5NOFFGMnlDeU9YZGx0bUJG?=
 =?utf-8?B?SzhTZFJvZ29GY2YxeWJjTUQ2RTRsRXgyTE1ZemZqaUtZVDZ0ZUZIWDFQcHdy?=
 =?utf-8?B?MEdkWGh2aXNnVytHRE10QmRTb3F5OUJRYlBHUjh1a29NUUVDVWg4cFcrdHMv?=
 =?utf-8?B?cXBRc0lKTVorNVpQQXVXNlV6L2Q0Tk84NndQSFFmNld1T3R5ZFlvdENTc2pl?=
 =?utf-8?B?U3dlZERQRXQ2RFV3ZnF1U1pCbU44Qm1HUHBYYUh1Sk9IZ2xEUXVjUEpLNll0?=
 =?utf-8?B?cUF1VHB4RC84SFF2NGNHQjRybEdLWnVkM0lnWUx0dzhtd3g1UGlYOG5UbTB4?=
 =?utf-8?B?SnppNnlSeXoxWWtVajlaRFhGR1NyRU53b1dsaVA4b09yL1duTmxvbFd3c0tj?=
 =?utf-8?B?SUlHRzR5K0U2ZHlObVAzWk1Pd1VIcXYrZE9kZDB1Rm5KV0hBT0NRaitTT3BL?=
 =?utf-8?B?M0s2Unc1a2hCRmtIK2h1RStRbGR6aVNkYks0NktJczRXcjIrMXF1NGxBSjRU?=
 =?utf-8?B?ZjEvS1Q0bFhRd0hTTTllVVdWL0VRZGN2UlNBQVFZY01YS0wwNWl5N2dOck1S?=
 =?utf-8?B?bm80WFh2eWRtNEtqcUl3bm5uV01LTFpIZ1kwS3gxeHh0ejF1UzNBeUpveFA3?=
 =?utf-8?B?VHc4UitxNDhqNDNxamZOS29xM2VxNXMyM2Jya25HbllWcGIrYjl5T3plT3BP?=
 =?utf-8?B?L2lhUUlkZHp2Y1phSzRNQ2YrNDR0RDB0Um9lVGtVdjFXN3FNd0VvV2JWbnFS?=
 =?utf-8?B?ZVZtWGFZeEppL1JzdzV3ZGg5eTlDVHdYWTVlcHVRd0pIZ3lXNm5pY3pXSEg3?=
 =?utf-8?B?elh0VFhoVm8zd0FNbHRpMGNYazA1UGxBcnZoa0R6U29HanBBcWFjSnNSd1hO?=
 =?utf-8?B?UU5xRmtyc0dsaTVXQWIzWSsrcFdEQUl5WjdkSTN6cXhxYnh5NDRid2NCR05F?=
 =?utf-8?B?dDY0MGZOU2U4c2NDeEZOTWM2VXJJcDljN3dsTUhDS0xPUy9rOUsvUUlNY2or?=
 =?utf-8?B?eDVMbWQ1MWRyR3JEM0dFRnZvNkcybzJnMUEzbXVTNWVyajFKTmVwVmlhdFFX?=
 =?utf-8?B?NHMycFk5OENwRTBxSXdxcWdid2dXM3hkNnZ1K3JydmhNb1BRM3drUEI4T2Zh?=
 =?utf-8?B?LzNjMVdVYkhHM3k4V21pblBHYUthRGtManZTenkwcXNxZ0dzS0NvNkdCanda?=
 =?utf-8?B?dWlkMUZwc1VEM05wbVZ6RXczSjVLRHBXVmMxd1pweDFPMWlkRHo5RGo2VG96?=
 =?utf-8?B?MzBRN3NyTEVVdlhCUWJkOVN5UkphUWhBQ0huQXpHakdDUVFKWlI1MGMzYVpP?=
 =?utf-8?B?VE9Db2N4WU5oM0pTU0RSUEs0dGZuaGVkWDR4bVdYVkZMd2xJYUNuZ0ZQTTlB?=
 =?utf-8?B?VnFZc1g4bnFYTDhHSGVsT2hZK2oweG9MRVBKTExzNGcwY0VtVVpCZW9sZTkv?=
 =?utf-8?B?OTl1aDFJOFVieEtFbU44UzFRUEVEV05iaVFoU3NlSWZVSEtaSkxtZStGZ3lS?=
 =?utf-8?B?a3oyalRVcHNMc1AxREZtRVYyb2xqenpOZzVSV2QrOXR6QUpYTitjWTI4VXpZ?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A5tfq+NnhdHG3WtgPY0Yy/iuBmjSq7IhBPE/qQl8A0WM7Nqwe+Py6f/O2sE3mMUtqomi7pDVnzEpxrVDk5ClKweCphzW/ZpIABGBwrLjJvxxXztYp/lICHAe+JoQpHnKDwbbkA4Ak+DNArlgohAE+8ir7IxwuMBOg0nH0QST0GVRMPiYkAajRrB609vlvjVY12+Msfg0V6T3rxU7+vD/1cgZUQDekAsVuooQQ2aLmouvrx1PyQ+Rw2S9RwPdjCcBM3KgSGKeF2ZrCkXT8BFZJpskJG7JLnNkyt6UV2fk2FP5xq2NwjxhCAXZ9ONQJfKwSq3ZIi8lwmJiGbK1cZ7nKvL4dBnKh9NuND3a5HNwm2zLibcjsooJindfTE1dqezf+TBM2EBDCj91jvRimXbhv8tKSbZpenETlKM0iznONpQOoDiXe+B+bkNoTJP/ZE6fHZ+1MoN6T9/h/ZZLJn/MvDM5TNHY6ddozPfa6fyskiGKiJHV0jxMN8VHC0Q9CYew64BvcaLhJ1Lds7A0n2SX/eRDwi0inxeCKjsGdI/VUfRHACDf2X/9bzvRvdeZv0GDvAjYmJAi7rPWsG76SuUuHBHN8B+XefIR7mIMh9yIV/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e46a05-ce52-4145-d399-08de2b4656f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 10:43:44.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xq3IruLxvGQ7koXPcPofWKpOPYN/Td9QWZ6xN7ezfl1vwwLm9pScUJGIi3W9X/WsF9HCfTRxmYUjYi+hrlVQNx6bvx8JL9THCfawZBnsJPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511240095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA5NSBTYWx0ZWRfXwDxknO4P8ey4
 fUK+oOCtmvO52cg9PaqXjN8ObSVaAlx94/WPRwdOfurfvBFNfpbLwAenqhxjMRhdg/08HoA8SFr
 hF23ql82KxkViZx6MVasrCPJGv1w1isv6S/k1mjqa5zRnCC2+8GhJXcjqn1rMiD3+bF/11sFqgj
 om/w67wB8Afh5BSORCfIx6NhuwlKDpBy9wwXW7j6DwqCuJFGOzxuY5N2sCV03D7qzGprYV4o2s6
 ntcIYf6vtE7s+ifkhTK/PtZ+TwOKMiV4yYufblPxBXpNigJkDoqAooMsFalKYz+ifqjyPwsr1QF
 B0nu1tOaEfzcJT8NVlST+88/VHa3QOlAa+fSe5Oy8AFw794LKPgXHsrI+OIaH0gCc+PdrpR8tFG
 OGUzUwq09JVxr6otGY/PA8/VGz6Teg==
X-Proofpoint-GUID: sZegIUAKrGLqi5qm1QS3rGk8LUU6fzw3
X-Proofpoint-ORIG-GUID: sZegIUAKrGLqi5qm1QS3rGk8LUU6fzw3
X-Authority-Analysis: v=2.4 cv=KKpXzVFo c=1 sm=1 tr=0 ts=692436e6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=-ibLmwfWAAAA:8 a=4RBUngkUAAAA:8
 a=JVtNvzFCA8CWyqQSPt8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=A6MkUVyZPcTV1i89ro0M:22 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Rspamd-Queue-Id: E4765120006
X-Stat-Signature: 8yawqms16tqxxhhzwb9w7ffydm6fw8ig
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763981032-113854
X-HE-Meta: U2FsdGVkX1+DrJdoWkayX6yg7Wn91uupKVegEGHcniOry8zvndFpXd6D10XvQ7UlMBHrJvNoyug4q96RcOGdjDQgAfVPOWWnAZAAB4WyI60forKHl7PaZkCZT7Flh5XmMnvipTwrTci/IkDb+TI08g9IOBP6QpqgZ8BGn+NyluRQg/48BMZSCuTyIasPLf3pblNsCmwprS+Sa3VCZFGE4b/ddRlZQAyK5fvjWyTqxKCWXb3pVsG9PrJh3r60qjpai3WrYtHBPs+H3jScRjIkfgVAHx07PyEW1bPjvbOW+MumvB6XR7CH9+EOfBniaq/blf6w8VcqKfx3rSEE5ezoVVF1C42PkdtdbR5hPpT/BsHn87C5fiRUqT0BhiwOco0nsm/qxD1pRB+XaosIcfYZQSsDtoXyaEf0PNVJ+VdkoV9Lp8Od3yFxj2RIpIqRbw/2sRi4lwMiuuZjRJw7U5NZj3Z4vSAEM7tWbzC+dShm/FHt8Z3b7+0/fiEyX5yr0XvIKLKABB62pr4r4tfhrFZjVlLAxN+uSnu4mR8V7sqFEca+YQczy5dIvFGmDFLdmsCaH2iRtzv5brxNaqMKHMs8T3yONz1DiRcOIUZ3stBfh893NWOd1xgJJzZkZxA4N6F/of+Wek1TPdft6VKwu82HMGSMuWC170CzAiyCIWbdIR/q0aKGF6jAiL2m4GEEX1q1DpVKJMAYRCxHEMt9+YFr7rN0R84PKdrnweoNHeh7FXEQYgGNHDGDC8DNjjL01Rtp2wEwx5NOTUnaovYEhPa3Tn0X/6yJbB6VMxBG8EWWP7hQ58EGv4UjlSaqsBjjbFuW+cBYYAgz0gfFtYX8gYfVChTEwCF/kDBtqDvGHTb8bulqSu53P1g9GX7sKiBdYBKbEm9ZtkQQIsKhXCCGk/oLvvrnZUOs6i1y/w5fqw0IWdH9QTFY/OhDvlZ7VFK+jeVpZLfhY/7hOWG6oJ0MSq4
 71ST9Mrh
 J+mlnG9zQAE/tc11WEv+kv8he5OnhUzkBvC2Gs3nivaTjEmoA7Y9nLHzjeygaFFV0wS4OCWoAOqRecnDaRn+Yk9JxPfLvkVx1dXYHUHZnBhesNyeCmfzyUs3lXxFsmukUYhUaeqP7F1GMdeqJpkQFVrQ73zZfWeyM16MvTF6FAS+0CwZjzGTIPnWcnm+Hv7Zl2l6wEG7txFwGi85JhkQN1A612K0GS9jCbgBr4ny3EY0MGh5FfIoG5V1cdwcZ3zTjToBc60CkcNywOOVhaZX5EgdrmWj1K7WqBqadfjKGl/XTbf4zzLsd0fr05+9dReCgsqc5+ue57MsgMekW2eIUOtclTV4HEM0I0cfrFpti4RJOYQEx7OhI+IBDqxSk2pdT7QHkJNAd9UaUv3VD5uROOGr/JSzYBiSL6Mq8Wpf3fFyPJ63ucc2rO767CB1uLYNwZ9RY+QkLnRGdVJumIj1N8tFcpHRbN3/I0qqsD68JfxMu1OKP/blPT06idIuEtck6DNe3SkK0FIPukCSTaV7or+0OtspPaQboyf/Ugq3kNNo9cxS+HzXCufcemhj8E8YgbAq/Et6VfXHZJQ7hwovGRpGkHrLmxYYuQHGYEvhk/RRzThvEuOssx26rM/ifM0SyLM8qOcCYh9Pp9ygLZ+XP9JyFdWwEBm1mHp2p+FfWVgFQhgsvcW8Vr0GSF1eRRW5WLd1v+hMm4a4xp1GjZOJ7jIiMVUrk4q/MkCroATQAhjZoyQ8gs4DQoxG1L8dGOVOntkpUe40GNzVtFhPvqYKG8sGLZbH3ZJsYRrqLpAeL38XNtl4HgaB2kGkKk378ma3X53r1SZ1ayxS+1ftPJqYCxcM7IVsbkQVYPxE1A0AaXLzYUySreJtc//XS+W1RPaICQKnghdiMNNI7PtBTl3xvqplb7b9PyX5pV2Vm9IQboS74diBfoJjJyTfVnfmlMC1eDbN3lGzl7ImD86A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:25:14AM +0100, Aleksandr Nogikh wrote:
> Hi Lorenzo,
>
> Thanks for taking a closer look!
>
> On Mon, Nov 24, 2025 at 10:53 AM 'Lorenzo Stoakes' via syzkaller-bugs
> <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Sat, Nov 22, 2025 at 09:30:29PM -0800, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> >
> > Hi, thanks for the report!
> >
> > >
> > > HEAD commit:    fe4d0dea039f Add linux-next specific files for 20251119
> >
> > Hm this is quite far behind!
> >
> > This is a known issue that has already been fixed in linux-next.
>
> Could you please point to the patch series that introduced the original issue?

It's two versions of the same:

A fix-patch sent for v3 introduced it on Mon 17th Nov -
https://lore.kernel.org/all/13ae542f-5c47-4511-b0ad-6d1e9dcbdc9d@lucifer.local/

v4 fixed it on Tues 18th Nov -
https://lore.kernel.org/all/cover.1763460113.git.lorenzo.stoakes@oracle.com/

Unfortunately it seemed the former got sent to -next quicker than the latter
did.

So next-20251119 introduced the bug, next-20251120 fixes it.

It's all rebased so there's no meaningful commit to mention etc.

> I'd love to debug why https://ci.syzbot.org/ missed it.

It's not that it missed it I guess, it just worked through a backlog. But I'd
say it's not really useful at all to do so for prior versions of -next? You
should always do everything against the latest, since -next _always_ rebases
like this.

It's useful to look at older commits for Linus's tree, as we don't want bugs to
exist at any commit there. For -next it's not really helpful.

>
> >
> > It'll all be rebased so no syz command is going to be too useful here I think!
>
> Yes, we can only close it as invalid so that the report doesn't stay open:
> #syz invalid

Ah wasn't aware of that one. Maybe worth putting in footer?

>
> --
> Aleksandr

Cheers, Lorenzo

