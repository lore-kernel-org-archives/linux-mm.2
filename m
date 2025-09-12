Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2592CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4C46B0005; Fri, 12 Sep 2025 05:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5836B0007; Fri, 12 Sep 2025 05:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D9D8E0006; Fri, 12 Sep 2025 05:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA39C6B0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:21:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFEB31A0740
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:21:25 +0000 (UTC)
X-FDA: 83880054930.14.A2F8575
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 367381A000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:21:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=itMR2uxW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UnQvpikE;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0lAjrJIBtANABUKEV59EYKMtMhvaXba3ZUuFjInLNY=;
	b=p+eYiZWvEx/hpj1HgpTkzRaq9NOzCEtaQ1juWJoqXR7QT6GSQf7cdnGpwIc945pe5GcGf0
	i+NlP6KNUIcb9i43eOPkyHOchksx6fFgr3sXL56OPBx/tU59QSG0PlyxmgBMDNQ9RGpxgu
	NEiT0oiILgjOHm1rlI59a/2DfRP2PyQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=itMR2uxW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UnQvpikE;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757668882; a=rsa-sha256;
	cv=pass;
	b=6RcQJItiLzI++9cWfvl+aj/KCq8AF3MPBh64XmwIqi8Xekq5+QhLbjGclYF/J9Y9PxnBL0
	tAuKOaAhu6sQewIWLqyd0R2qr7o8nXgcHzwiZNC/3GBDcvfLZa3xj/l9T2dXXxWNdRisLG
	jpN5pDl/DwZDe+jQxmzEjdl3nu3Q8wE=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uBvA009707;
	Fri, 12 Sep 2025 09:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B0lAjrJIBtANABUKEV59EYKMtMhvaXba3ZUuFjInLNY=; b=
	itMR2uxWG0ss/nGqz9BO9lml4nbXIqLGP5Er1W2D9ew0xf9J3EU4p2uRxmp8p6bv
	lSp7t0fwBNUXHDvxupwKk72pz0UOxIkumbjmQslXtzDtmqvs9PGRdflz5uZjicy7
	UVMtrpiRpIoNyhk77gg3zHn4unDNJuvanX7dph3h23+c/2bjL7oWDqoO68HofvMR
	upw6BOzZBZZrxNzHtzBQuLXdVFYQKNoWhggVgAmfgpwKtFrU03CeA+BOGR6dbISu
	BO6XbRMJfnX2UyDhQpPxidA7ZYWo1kGRRpQ5u5tvy0h9g6rc6+iZ2Xkgdokbd+K5
	cXNcysL16QMESzOYFD5nkg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1r0rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:21:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C8o8sI012857;
	Fri, 12 Sep 2025 09:21:07 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011016.outbound.protection.outlook.com [52.101.57.16])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bddt9w8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:21:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgVuf5vKQmH6MdK06q0bdVFgb9ITKYf8va4w0qBfOn0zKWmPAU8MxpnV2DHiCZNnf/5losZkuDQmwwAiq4d4RmcmiE3wFWhaR7RblqzxGxPpmCzjYMOl77fgqGgJmQv959DDVZcskUgQHsRlgpuuDZf6y613ucY46GNLg7F05A2Jc6Tnx22B5670PYQ5JsgBlp1KhMYZTr3YGMJ5Spwow67uBAIO+1Np9VGgbBDdpTad9S9hFf19TUhxL4YTi26qSWxwEuzDg5Pprsgc36Th5SPEF1f7+nwP3Ky2opgOFYs0QIaSaR5HtVaxF0a/ql0sRgdp2c6oQpPt9UGINIvkJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0lAjrJIBtANABUKEV59EYKMtMhvaXba3ZUuFjInLNY=;
 b=p0J8Iio2cKfh9vYCGu9wTGjDMYSdl4f7ru4+Paf4f6rB/sRza56DND3zMuVucTjj5/V647bBM1vnFAUXNmjQFiyYSd78kClmGsd2aBELYFTv+zPtoKzU2m+h3New9jXxZ2JOhWvWGqgYWGFtrB8b8OaARlb13FptUN3ruGQ3OoVNVIsNzc6PvjL4ma6+QmaaXVJbQKmtq1x1/f0+/IZQy7yHhlqtXuh+93vfNSOz7kMbiwre32ilaWYTqQcPTdliHpkuDD0bErNF2t2uOaBhUQ5EhSPzbS52yLL9VPDRhjUxGC2tmHA5s+OP0XvjbjLayqH3TGvftvN8wsmEdS25eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0lAjrJIBtANABUKEV59EYKMtMhvaXba3ZUuFjInLNY=;
 b=UnQvpikEKQuFLRpj3ZMFG7ocbRBnvtdQTga/BqZK9moYG4r3Dl+/LTKulPJAFWtSgsBKZjeLjtmXvuH5G+1vowaigP/y3vSOeD3KlR+i4/abKD9Vs3XSm7UwjNJn7wahp6HMvLYNxE9Unx+CiaU/9HGI56GRHDOQ7spZmxApsLY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5621.namprd10.prod.outlook.com (2603:10b6:806:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 09:21:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 09:21:04 +0000
Date: Fri, 12 Sep 2025 10:21:02 +0100
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
        linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 11/15] mm, swap: use the swap table for the swap cache
 and switch API
Message-ID: <85ddbcf2-09ce-4e58-9731-5fb06adb042f@lucifer.local>
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-12-ryncsn@gmail.com>
 <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0049.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5621:EE_
X-MS-Office365-Filtering-Correlation-Id: c115163e-fe2c-47ac-da97-08ddf1ddb2ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TW1iNlJGeWdWSHlib3pLMVI2ZldJS1VhTFdjNmVsSkhicU5ubzJxdHd2Q1Er?=
 =?utf-8?B?MzdEK0NNNDZKcldsNzJmTVk2QitaMHU1cjJPbnhBdUhyMUJKdXRyaDk5OVV4?=
 =?utf-8?B?SEFEZmlYd0hlVXhnMHZ4cFBpUHlhVURRRGRUdkhkR0xIRjFJV0lVWnhiYmVi?=
 =?utf-8?B?YWsxODQzZVBsWkgxTXFSbGZNU0NGbmVPSEd4WUw1dWU5VXhDUDc5WDdaa3o4?=
 =?utf-8?B?aW9UZVJkcmpFb09SeTZEZ1hYZGlOei9rV3NRRHVkUjhDU1lXa2lkNG5VL2du?=
 =?utf-8?B?c3JMbmJQTGswbS9MVFg5N04xbnF0ZmpISkZWcnJiN1RYSG14QTRlbVljbVRH?=
 =?utf-8?B?WWVDL3dLZ0dVMkVacFpNRnBvOG9YUTcyNUdodXg4bE05d1VtTC9VR3JFdFY3?=
 =?utf-8?B?WjJLMzhRZ09CdTBhZ0s4OG5HS1FmbXEyNFpHUU51NkhzeHFqeC8yZEFOOGpa?=
 =?utf-8?B?VmY1YTFPbC9oaUxQeWlDTVVrTVVPc0pvZlJHQ2FSc3g0OXRCcU1JdjhqTFEv?=
 =?utf-8?B?WmRrQm5FdUsxVXJkUjcyQTlQOUlOTlBEUk9xVFBETE9OemJCVHk1QlhXTnBD?=
 =?utf-8?B?SUZwZWd2MEJWdUpIKzByWnkwWTR1cng0Wm9mdlpXL2ZuZEVYTWhFWVVPU1hP?=
 =?utf-8?B?cFMxdGFCUUhpZVNxSzFQUVBLMnNDb3RZTVMrWTA0OHA5NWZncTlNemhCUkhx?=
 =?utf-8?B?dllmTkRML3NiWUlTbWdhenN2cU1sYXpJY2ZxdjZFdlNWRTJMMEtmR2dzWFFu?=
 =?utf-8?B?ZnE4YjY3YStpUFZHWEhOa0ozNWFwcmdVajVaVTdidWo1VHp0cEF3RXRya2xY?=
 =?utf-8?B?MkttV2laaDV6MHpUanh3cnVrV3hPMWgxNnpqT3FvZlVTQmQvaXA0cTdYMnkv?=
 =?utf-8?B?ZmVVbXZ5UnduMWpGS0JDU0lKZmtZMEVVNFJkTDhMbG5lNGpBbm9aM2lOOUla?=
 =?utf-8?B?Z1dSS0RuSlRzbGxnZFlJbHhVWUFSWThCNjFQVFo1MVZSSVFnOW5NcTk4alY0?=
 =?utf-8?B?VTgxTkpabmlJNFIyL3lsR0tXaXdzeGVWSG56OW1iZzZxcmltTS9xd0JBYURs?=
 =?utf-8?B?QWpveGpvdDdINEJ5cm81RW9FMFl5VXp5RFMwNHZUWGZnendCRGVqQTRRejcw?=
 =?utf-8?B?eFFGMnBaNDdaQjU2THhiSTZNaWZEaWQ3U1BXUWZtT2xOZjRuUnpCR3VNSTVP?=
 =?utf-8?B?bjUwckxHVzJOQWJCU3YveTVvb3pqRXEvU2oySjJ0ZmpRM2JjVTdkS1Vxa1Fa?=
 =?utf-8?B?eGpCdXozdzRCMzJiT3VBMXlDMmNja3hLZE94b1BYbnpXNmM4eEQzR0pQYXdG?=
 =?utf-8?B?RHIrVmViKzhYQ1RFTjQwZG92eUo4empOMmhRbVVXZFRQaDRMc1Vtc251QTc2?=
 =?utf-8?B?VGxmc09ZakxxcmZnRHluajZVcUdGZmpHa0F5OHI4R3BHWmxJRk1QdDlqK2Ni?=
 =?utf-8?B?NndkZzBlVnBOMkpxaG85MEgyYVkyemt5ZWtFZ2o3WHdFWkdCMXptL1pZMHNT?=
 =?utf-8?B?WCs0V2xVT2xubjlpTi96U29zYkQyVXNlTTRoRmRKZVMyYy9GeDJjdFUreVlS?=
 =?utf-8?B?aS9CUWdjcmhmOFJKVGNZS016V21IZXNIdTJCeXR4b0gvd2M5d1FjVzNwcG9E?=
 =?utf-8?B?ZmRRQ251QitDaFE1amxrcjI1Skh5L3VLSmpGU1dCWU5iUVREWllrMGdyNERB?=
 =?utf-8?B?VkhoOVBTZXVRNTdueXZsQlZCeUZVcVhkYXJXc0l3MzY4dnRGTUVKQjdZODRw?=
 =?utf-8?B?dXBuY1NyaU92MWhTZlFnMHNJanlYMmhzRjF1Z1pXcG1WWkdVTEplRmttU3c3?=
 =?utf-8?B?T0FEZFRXYjZqcG9UdGRZdS84eDVWdVg2cERFSXhNdGdKR1ZKazZ1bmw1OGpO?=
 =?utf-8?B?OXVYc1V4djhFUkdtK1V4c1Z2NHdPbEFFZjFkbmticTUvSmo3b3hoWFQyVEtq?=
 =?utf-8?Q?5U7nxTASi/Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzV5M0FKckpCeC9aS1VweWx3aTRNWjBPNGJWTGIyZDJ3SFlHN2dXQ2NWanVo?=
 =?utf-8?B?WXd1STlFRTFqL1FIWGdJK2plR3RIN29ZTnlNVVUweVF6Z0hqVTNyOXJvSkx1?=
 =?utf-8?B?djZZNkd2YW9KQWVFMmI4dTJRMmlzVzdOejRYKzdPeUVDWHZmK3dvNmV4QzBO?=
 =?utf-8?B?YndYS1poQnVLQ2RzUXpEai9OaTJySFZERDB6Wk5WR3paNk1OVmhNWitTVkVK?=
 =?utf-8?B?dER6MlFabndjL1dxQzVYQnJ4T3VSSHhISEh6YnpuL2crL1d3cjQ0eCtpRVA2?=
 =?utf-8?B?Q1hpRkwwWEMySkRjcU9LWHpaWEFSQjEzRG1OdWxYc1NTbGhXOE4rT1p5cHd0?=
 =?utf-8?B?ZTY3V3ZxdUkwQjA5MHZsNS9UVGlYMGZkOVFLRStRMVRzbVh5ejNENXgyTEhP?=
 =?utf-8?B?dUxCdnZJazRHbEwwdnU0WXBRWlUyeUxUdnhRSS82eVBpSUpILzJXQ1BKWE4w?=
 =?utf-8?B?eER3U0xrK0MyWGNra3ZwZVA1RDFjZ1M4MW9wd3FmNmFtUko3b0Z2VWRZU2s1?=
 =?utf-8?B?Vm90UEFBQ1lJM3ArVmJFMHhhaDV1blRudmdaaEQ3WDVJak1tM3YvMjNxMS9S?=
 =?utf-8?B?WTJSUUg2NytNYVYwT1NKclJHUWx5RXVxM0RGOTY5SDR4QXM4M0RFWFhLaHUy?=
 =?utf-8?B?VUFpK1lpa2RsOS9oRlhzMloxMzdVVTM4KzdEWmN3OFdZc0RUK2txbis5dkgy?=
 =?utf-8?B?KzIwcjNyVzdZTFR5SmlkNE9RQU1ZLzBYL2t4YnVxTHFIL3JsaG9nS2NDRWRP?=
 =?utf-8?B?UW1FTDhaZXc4OVYyWkN3RDQrV2ErUlpkUnVaR1lxa3FSNkZRcjMybVdZaEpv?=
 =?utf-8?B?clVSNEhjWi9LMjNkRlVjV0RvMmVyOUtaQkdQUmpvVHFSeHVUMUwrbm9yR2tU?=
 =?utf-8?B?TjM4Y2Myc2dyd3BMNGNiclFhdmY0MzdIa2hFR1hQSmNtc29lR1lxTHdYeGlE?=
 =?utf-8?B?SHVPLzB3Z2dPZ2trUnJLbmVjZDZnZ2hFRGFVQnIraW5saFVRSXBxcktoTm1O?=
 =?utf-8?B?RDBZVUpua2ZraDNsMTdiZXI1dDFZT3FzRENBME0yb0xDTkZSWWdqK2g3WkFX?=
 =?utf-8?B?cmUwZG1MZHdaSkJReFR3WnlCMG9YMS9QZGJsdVpDblRNV1VjZWFEQ25uanVS?=
 =?utf-8?B?NGw3aE4ycDhSMk5TMitCWS9VaktvdG1nTXVGZEV0eCtuT2ZjbVk5aFp6Y3lS?=
 =?utf-8?B?YlM5TWhXaVhUWFNUcDZSeXNBVmpLa2dyM1dJd1N0djJXUloxaThNWDFLaHVx?=
 =?utf-8?B?bERVUW02SFc5ZkpjMHNFdm0zWFA0Si9iTUpVSDdwUm5Xa0FRcndCbjZQQmtG?=
 =?utf-8?B?RkFCd0xUMzN3empwMk1RSXhSSUlJczJFKzRyYW9TY2FuU3ZkVnlZUHdPY1c1?=
 =?utf-8?B?cXlDRGhFb0s3WmFSRXlSRTI0ZVpHL0hHT2U4dzUyeFlUdG1jUlJaMkpselJ1?=
 =?utf-8?B?ZHRtbmE5dk9UWWdRekgwR3FCOGdqcDZVS3RrSE1wcmZ6VHZMU3NsenpVVGpD?=
 =?utf-8?B?NmxWUWdnSWdBSHNBaVE2aGtYaHhGdjc5Sm1CSnVmd3M2YTJLL1JXcVhyWEpE?=
 =?utf-8?B?ZSt3SVJQaW5kQVVmOFpCY2FhejlzWVptVUNwUHNNZFM1dExSbXg2d3QwWkdB?=
 =?utf-8?B?ZDZCUllUcUl2NEk5ZzkxYWMvZHlRZWdydy9HTmpQTi9tcWh3Q2ZkODdrUWJm?=
 =?utf-8?B?cGtHaWlVejJ0MnR4Q1NBVVdYdGlBR2ZtN3RvdjAvTW5BeUtiSlJMZVUrVVpI?=
 =?utf-8?B?MW5iNFZrRElnTGJEVXFRTnBNalpLR2FrTXllajVkbXZCZFJid3dXOEEyYm9N?=
 =?utf-8?B?OUtFQlQ3WG9tWkQxR0hHaStHREVtVHVlZW9rd1ZnS3cvdCtnZTN2VXA5cXZ1?=
 =?utf-8?B?ODdSdlNHenc5MkZPSGd6ZzlNenZnbkZqMkFNdlQwbjAxZ092b0N1NERuZUFo?=
 =?utf-8?B?Z2FrTm9Cd0FybDliZGRhbmNGUWxxbVFZSUkzdjd6a3BISzVJS21xMXZWR0Na?=
 =?utf-8?B?N25Hc0Q2Z09VM3dtTkZNMXYySExIcmVXSElyaXFUMmdMSkUwK1lDWjNqWjBE?=
 =?utf-8?B?VFh3N1pHNDNBOUxaZStKQnNjcFlxbTM0bnJqc1RhS3JMN0sxKzJOK045b0Jz?=
 =?utf-8?B?TmNVT1lVQi9sN21WN3psZ3NRM0NKTXdFcFdpM05SUndpOVBpZ0NpTWJ3dlBK?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HHkAPCzFoZQyqLCc/RB3abdEF99id7owPSAXJM8v1rAwtGx7d8ZSmmhESifZ1QZsTbYqsCHHQc6Ca71Jss1axlJ1BOfY+fN0qSEpWEGAZ2SiBO2m/aTUCDmEb5FIUidFCJcPCh52YAr36RFODDpAc8crmUCkeodQe7SjbzlJOZxrOs9NX5UCRcdMOl8ULo75q42sRp4jGipa5gj/bnv02glIgfUQujPd8l7rjUEK0IoURmn7VGyQLDQ64aTzmugmSVnm1asqFbJcMNOMH397cA6ikiaF4VgAHzdJaWmYBQJqytsiXo+7sG0tEeliOXO/1LDZpXMc3Q6zVBfzzxdUIWHNDTtn274DDj64eIm3eNihrosSdIIoaGYXDryNXOmJIAbIBgFH9t88iiCXNr8rK8wB1NJTTjAH4jqUjRRE2jG923Dye4atpLSp6IUn9RU3w+++NsL/UvSE1jchkCrtqO4YmINyP+MtEzWUOJWEg+4ixNUT3bJKTOtef6ln0QZ4Ia4/zqNiBH27p0xnOcw+5S+4rc58pPhqU3YyK8ZbndCpxP+nUpO/Z9n356/nKCzSkL5ra/wuzW8zyO+4/A3vT1wbL6XXsJtQs1HKGXKHFdw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c115163e-fe2c-47ac-da97-08ddf1ddb2ae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 09:21:04.4969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJkQxH5yoM1jbu5Rf85EQGAycDl/HsXmnwiNRw088CmGEt3N6Yu1QOTmnoV+KYCHqNYl/EAUDj4jvyERNqDV0CJc4djoKyMUs/LeT4ZVRGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=931 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120087
X-Proofpoint-ORIG-GUID: 6F9zCxwdgMn80jpzTIOyY7IiVEWAfA8m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX8ex7Z68Z7gN1
 yEaACVcffFzZZ0a2JXGUMof+gCM7Y+sQKwgJDuyQRbd6Ie6BU0g9DPo7JeBn5b4o+dqCYrQnojs
 VY7D4SS8SSzcWtHCMT0bOpUOIzlRquhhvkTb5gTgVVZySXMCRYFCYV4/7S31acTMYd+Xw+69+u7
 64vccwcn6c7/FtLAqD7NXjl9Z+EHg5ogyUuHiYQ9viR0Q8dlaMTxS1m7wCD04OK/19PlO3EEwb4
 ZEiA9ZBefrhft+/qAGBbIunmkT57gTxyrRNwH3PST4ttW2hFk/7ruf+MPNPFNzb1EGk6qZU79sL
 tkJY/gjqbYvgRrJK5P1jUnsPOzE4ILdWcbwTvGYfMT0E/lzwGQ7evBfgiTAP5O2JiSNxg8kxffA
 ftI3G54F
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c3e604 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=fYbhGPvKPZ0hst4Z:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10
 a=9LOPiDwHwhJmQRAJOF8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 6F9zCxwdgMn80jpzTIOyY7IiVEWAfA8m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 367381A000E
X-Stat-Signature: dbx6jsipc9eagjd5j1w4kkn7dqp7xi37
X-HE-Tag: 1757668882-447999
X-HE-Meta: U2FsdGVkX18Z9Dzmxi8rHxNiuHxat8cykOjHqEWPMYH0ZqJp0s7TNYYYvWjPh8829S4ngRGR1tjwA6KjL7j1ret7uavgrzzMaz2Xs7NlMHbmprhoRDzFaWke0jVFQ5aKzKB7Gsp+gkWVZ6l6J9cF8OuW42N3vaqNWQI7QXUrqPiVoIDGe2XJh88GPYksN5IsmRdyxSylzX1n9dMnfULQ6yG8GO9/BsoCozAW9ISth/aUadzAbgs3gxO/c8hEkJDhEYEm11g0Hnl7jYpn3PfVfs4inJXkf+wJlu3dlywErSCYdN+Wb//szmlh2k4Zz39MxOKY0uxHcg0n9tfS6dJBZK/E4dKbQHQ2LulHUO0Z46Q27v2cy1u4652v4FPGGDOy3NVc0SU6uNW6yPw0e09347a/V0PcIIZ3hsIZApPs9DUZ8O+rky84/XmVEaXbeE16/RdyKn/BkwwtuKF7cBCeEPKhfExbF0aWJpQgyqs6Xw/u8wWzPM5Wme1uTzqFUNhK6gM03UnRA3cDVv9Wx+X6ecOh+u6V25IMCDO7MfLyhPJvYqP4wdi82J6Bwhdb0lyOw/+9I9twwqA6WIlMqM3/JlX0nz/t9nB41Y5ub6t3TZBORIZDZoIqpl2/gAs0fPNhl8GFwZ6dJQzuJQqYFFU5UCNhaoAOoQMHBoq2wXAK/S99vb8XTLvBUKNa33lh7XDBdtIYORPLmUwKpdU/qyb4lxShK9pBl61t8c5wEKUqtpW/+31x7g7xLd4oB3PQRatPztfzVpPc1CS0+j32dYVJ0tjidCUKez+FkKt3EK4JrdzFGF34UqNsSDQuRjpIchCFKfk9NBmJRsO7vCAKn0eJfLx0VixXjq64m5nJD/44AS3HyCA/XavNzKo6phKSZoLGObcGzkyKMqe5x2VTS6sghuCcpp0qJO/WJ1PCMBvGkWM5IJGLAxWNeV+uQVg4ZwKfOsYkdbYkRk67c3o7E/d
 M1Kl0jWj
 pvTmtMbeRgbR8xD1WAjPA3Y7dUgekxjZf/JbnF0lXbY71kLxTHYJqc3xHfNc8J8dkhLNTC/zlbr4wzmpuCOmyPaFXdlO61DL2sQXzQl8gc+1S44CvwVWaRCRIogu9x0Yaqagmns2IHyHdfNp1Mk0AYembHO4COVmt5eEhk6wL3qReH9QzPvJVckzhjEUsO/B85x6LhZOL+71UbyPLklZ6xUFF7Ahvji6asCRuqpWl2rUvoXjr+vqYlLC52MOD8q9k5DxM2FTC5IFoQR9t6ANw6L3sbVMB0z2uFCe4Igz9g7EAmD/BnF05HA5PsZE5IPsB/EDYxGbu9iSUw7yFSXvAvsYgkfnPxN26RoZ1sMhGl3QNespbz/HN+EybbnUaPtPMyZQtth/fgEmcV4izKj60nwx1mQyd4wS8cr1h2/UeEr6iuV6QS9oMJdHXa9tBSwV5mUfmT6EfmmMC3eqYtdZkuaPm2OpJRwFiBzN5f0Jif8rtnDUn4glsszWgbBcACuGUUoo0i4vOtQFpcp3q7M+DW5Y3usPY+CMz9iPuQKsrbzte6ZHQDqDp6zVfZxHMeoG8vLtt+Vge9+f1G2CFBDBZMeTYgmTX+n82ax/Bd/Lg/OX13rPH1ASQKWFRrfaV4jUr5ll4HYpS3hPpjN2ofpfgvuTmBMhbqEW8YKpp2+SXfRIHc6AmIfXT9p9VAMVihvelMnw580YavPV/f6xr0sWtMCTpm1kUkFe++EQMEYYXsVgEqec1HU5Wg43xIKCkrry9r67W0j4Fb3ZZlU4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:27:32AM +0800, Lance Yang wrote:
> Hi Kairui,
>
> I'm hitting a build error with allnoconfig:
>
> In file included from mm/shmem.c:44:
> mm/swap.h: In function ‘folio_index’:
> mm/swap.h:462:24: error: implicit declaration of function
> ‘swp_offset’; did you mean ‘pmd_offset’?
> [-Wimplicit-function-declaration]
> 462 | return swp_offset(folio->swap);
>
> It looks like a header might be missing in mm/swap.h. Please let me know
> if you need any more information.

Thanks, I just hit this too with a nommu build locally :)

>
> Cheers,
> Lance

Cheers, Lorenzo

