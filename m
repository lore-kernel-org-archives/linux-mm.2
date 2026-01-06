Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53B2CDC19F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B366B0095; Tue,  6 Jan 2026 08:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8FA6B0096; Tue,  6 Jan 2026 08:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A916B0098; Tue,  6 Jan 2026 08:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D22086B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:34:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCC14160506
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:34:33 +0000 (UTC)
X-FDA: 84301633626.17.7B2680C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7A7B71C0002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:34:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XLOsoewa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qGVRdQpP;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767706470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOWPU897lv+6+CBNkxOQtiqpbVd9ig/YLv3bpIT2Aj8=;
	b=lyCa0URwMWYp5S/4/4gDATexrc7mn1eepNmsB0SUeDSFG1mdk93O3w3jXSAKOJaJPNETxv
	tLVmsiYQgdfCyLyuwxaHOfZZOUIDtZ+gpyavYEBBGU8R0PA9M4RVD682fNNBePWaZWk/Ht
	esJRGKfYYQtW5YqweaFBvC6CUs+n9tA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XLOsoewa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qGVRdQpP;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767706470; a=rsa-sha256;
	cv=pass;
	b=y0QMWNhJV/95aMVsKgROe3Jho2S1JyN7wfEldDacugymxADaaIggSgdtd1yYQAjbBU5HFP
	HXPEuUgHZ/mke0FPn8m+PhsQBMvPJiikPTdfkWx44VNCt1zYeVhR5f/Ms9H3GHqKMVoRSw
	A5UKU44JDXcq6ZEUAZyYHiMYnc+TO9o=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606Cok0v3899424;
	Tue, 6 Jan 2026 13:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XOWPU897lv+6+CBNkx
	OQtiqpbVd9ig/YLv3bpIT2Aj8=; b=XLOsoewaaEZ2zeMXNW4rIf3HAtdqKaRy+K
	qAcHV++bKBaUiYthLlbR1SdjdfiwLt26V2Erd+nOwP33HetUsJC+nRtxE/zRtg4Z
	k72d35f47UActF7ta2UPuuN7X+tWoQsMADUnS2NEZ7S4xZd0LSNrSEZtWxUTXAkA
	A/owN6vRpIU05Y3fphT77VOwPOG5sKQEPoMxv1A58oFnOySsQ/O2F39zQK2tiPxb
	CuGclDq7mV1JwtnsqLJvUAMvLxBo3Y/CF9fQOcntKdHSZOB9QcgYs2zZRxTbj4Hy
	RfJ8I2gF9QFoeuxFH7VlwTAtlLx/dJuyf+CQyrQWC8OgPYi+h2Vg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh2rf81jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:34:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606Cl79f030664;
	Tue, 6 Jan 2026 13:34:23 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcm39j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:34:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AGD/MKY5IYqMEO7m9Xq6w48IM2x4UL12Xcc/qmoDYgoebYnWx744oDWml4r8tPDwaTXv5bdsFzlJAnWdj79emKbNyR+KcPSHwfb/Hej854rAJE4M9KwziOmV8SfFbBeBLKTXQrAoiOI/fKJuw6b7MBsh9ZtXCYTwnbXSDPfgnNfqmxZZTKmRO2Ap8C6vcju4vbpIoMpSsImw7QVPjfVC0zd4Ucjb7yNE4Z+95BG8IBowiyEVeslwa/Kt0ZNMGf58WGTF0beOwM9JLmk600ztwMnuWqE29FRZroKKBgxV4cnEK/SqP0pJFtAmNVBmLne+5RfGCp5pklhCERTsHuAZQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOWPU897lv+6+CBNkxOQtiqpbVd9ig/YLv3bpIT2Aj8=;
 b=j5Q5AU7Y+V0PenSLSaPmHzJMaXMoMc2qLRM258FKFP9fWn3ns2luUfkCZzMPe0X4FnfA4eZHWlfZDyhf6iG+PGCUkP/nAOtcsPeMonkklvlEhOIIQu/RpTy1Czd3RcpGmoPqOyJimUmj/F7NiM4EiVzuuOQSEkD8qOWizmJhhhOVtI31/kvYPKxOGOU0QvcDVBVqkKycl6hhSoFSQwax4fesB4zuEByqvMD1MIUDU+bh4F70oOZkd1hriW7wGmZNpDgY8GLCtC6i1Q9I9UjupUVdyjD2bt8IhTY100dWGe5GV2qJdAbm9L3zkTLnCjvQIo5i0pUsXxN5w8CjIj6mVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOWPU897lv+6+CBNkxOQtiqpbVd9ig/YLv3bpIT2Aj8=;
 b=qGVRdQpPHPQZuwzY1VxCI6GOUPgQsMyeJNWrnJfr6jii89qZWN9mYSPEA43WoslwY8L77ietRqFz346TCINMHUNsn6sGBxxxlG8L9/phHNN2Srt8v8HbKnHZbKwb5aNNPf6BZ5pTvn3zHpFPMC6RFLv/JVt7IUxUr+82ajMWJDM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV0PR10MB997662.namprd10.prod.outlook.com (2603:10b6:408:33d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 13:34:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:34:21 +0000
Date: Tue, 6 Jan 2026 13:34:23 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <5f1337d6-80f2-4521-bb6a-74075760ebad@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
 <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
 <13c66c95-ca0d-4711-b755-676ec4066811@lucifer.local>
 <f5291639-042c-4ecb-8e7d-8d0fbc8b80ba@lucifer.local>
 <aefb737b-5b82-4681-ac84-798425175ede@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefb737b-5b82-4681-ac84-798425175ede@lucifer.local>
X-ClientProxiedBy: LO4P123CA0303.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV0PR10MB997662:EE_
X-MS-Office365-Filtering-Correlation-Id: 60ad5a03-3717-4f44-d6e6-08de4d284cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ha82XB8gtksw/3fRg5XiQdxgS1WUtHaeKbbTzkWthOWf964Rmq4rnKd9SbX0?=
 =?us-ascii?Q?pM3IsPIwP4ETU4b+0mqyeBLWLWESkd/I6nbKe+ejcBmUaoCSRossfKQzINC7?=
 =?us-ascii?Q?EqINYDs8Tk4biSnPg2KC0jMMu4ctoPWIJlTw+0HLH7cbOFKlfp/sxwOPRZkY?=
 =?us-ascii?Q?+bwUp78mm9Yy51sozDnafLGg9gmyAqftRke3hJlOlTaNQ29eFwM3/fKzrNfM?=
 =?us-ascii?Q?4PQ6n5q03hpOhzhpg/qHXMgjuyp2UkiwJgAGE3OVznmrgZvKK4RyMStYDwM6?=
 =?us-ascii?Q?bMjs/yN7kjW42mEGgVXNZDV0dd0fbsW5zjMECAh95m8PE29UeY1mEsYcB88X?=
 =?us-ascii?Q?iwg1hQ4nGBr2W17CpKZNp28sM/bzDYZJHKIS0M9UtqvmjenOLELbVaW+uUGB?=
 =?us-ascii?Q?xOW1Rof7HVHsHWVjqe/yX5O3I6UvUphVz+0ixryyat/ZGzSzNYFrFwCl29Pk?=
 =?us-ascii?Q?VBLgaQS3MaMvsa29AxynyohzL9kSC8uvsuiHLTO2z+zk2xokP+v4Kria6A5e?=
 =?us-ascii?Q?AazySQuyMrabUqLBemNgt1o02/AUaz7L0yVwkzFZo2D69L4tljCu+qM1ZBLU?=
 =?us-ascii?Q?Qg+fJf5Th9PlJk9Gyw4SLZ8jRqsjUAWDyAVS0Bd70pwq1rgmZIb/FTFPFfte?=
 =?us-ascii?Q?t7SoDH1BXT8E609L+qgVZm5n/Uw7S5ThnfJnTRA2jD/XFVd/dQTJ+LeHZaHh?=
 =?us-ascii?Q?K9dyanOh2O2o2/yjiCUTPtdMLX0XUqZ3+vwPyfkhJ0RxsKRNcIeYmKUD2rFM?=
 =?us-ascii?Q?lLMMs34UefHTZi/sIEGZqwNuoBdJI6HRVHfb7FDG8xoeiTkUGoWKV/NeAZ3+?=
 =?us-ascii?Q?CD4OzfPNcAgk0RG7277kbkpEEjnXPMaF+1HpTE6qzLNWL0/Brc9CTDghpTJx?=
 =?us-ascii?Q?jfDOV1S0O8/xAeG4ivcW5c9cqMm344c1jR5GHRwyyhT2NPcu6wPw0mYL1avH?=
 =?us-ascii?Q?1LXDAzjPOQYbLJtu9MIs8dUFbJ5jaLCU86mWYsbwmdvOKF+rVsZRFcnZTs+m?=
 =?us-ascii?Q?AOKfCLTbK0pvnOQz4ZrPcVKOu9Yo9E6LuBi0Kllkr3azbkM+DKdAwhmF5P9I?=
 =?us-ascii?Q?h/UsgoAEuGRQqyaz5yIYwrOIVjYKtyczELdiZa3H2A+dYLdCsGIzATDmty+c?=
 =?us-ascii?Q?GHXPOek+/07h6X5uzcnbxPHudls06bhV1AriaQ14u/RR5mD/DDbG7ZwzByjo?=
 =?us-ascii?Q?xckJee1MHwo4i1gmsJ3sBX4+ixk9j3Y8llTMOnj7zih8WpZBECxoNxspMPZG?=
 =?us-ascii?Q?HT4zvgscPv2KppnrdcyT9TabokNkgWQkDli/X48/JW3rdVI056p6IQesM1OA?=
 =?us-ascii?Q?iW00EwjMnQra5ea9HmIgTU1uujCmVJguF+E9uedQB4u2OAOI/bL1J8HwPZy7?=
 =?us-ascii?Q?gs0/McQp28uP6pTVPPhlw+rA7AYB2PIrHbooOm/EfPEz8trapvSvHXz0pwVX?=
 =?us-ascii?Q?CwvOap2cKDtkm6kXi+i+Va/4PAasooK4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XBMIj9705kfDecihGXqvp5Y02hN1AMMzkbJ0BhS4CnohCsN/BPAJDfrylXYt?=
 =?us-ascii?Q?YNEMkbs/f8K339YA65Mgcyxb+qxhVM1MKS/TR/d29CgQgBIifKBlPunrUDuh?=
 =?us-ascii?Q?kkPUwtYi/l430hPenQv3+3UnlyhMQ/mBV04h0BWeFReVGrSKp8hsw7kZenXu?=
 =?us-ascii?Q?FqY5xvk3aorhcq0x2lw8akguPS7/OOw4cvT5XxxMH83wLFYdpuJPhCThGaIp?=
 =?us-ascii?Q?r8fteMIjdTOypc194q2aJky47msjIGmxh4mXQO1XeD8mVjNsnZr8Lma3eZSk?=
 =?us-ascii?Q?+2zJDDlKJ5sroXvSvHvYzoNLwLvEx6wYS2Emn10Y+32gzZxis3j8rnIGSgBa?=
 =?us-ascii?Q?FVsgORp7zB39zXVd4MzTfYfE6S1t6Mmixbp4zYvfkDvN3KvwpCWWXBv1foDf?=
 =?us-ascii?Q?n7Ivo+RINntHTmB8eTgzcYcBaq7zKbKdIs0Vt9vUji8uv7kfnnX1I27cxfMm?=
 =?us-ascii?Q?DqK+KfE6C5YrdMBnZ/13uHsEESkQpdiEKfIy+2i5XDZmbonf1wEqfmKdR+oy?=
 =?us-ascii?Q?U2OOcZ4cEhnAetM2C572PImdTJ0AF7+mYNfr/eJFJcrYz2j7wdTM4QMtxWv/?=
 =?us-ascii?Q?5L4im+EE/QtCgnhuUs1pH0aaJecnwqUEu+vL36tPxd2MBtS4tErDxccGOVmP?=
 =?us-ascii?Q?LXnKAmJLH6N/aD4BaRuiqEHkGaIT4DNbMfwXS4GyifuvROLe7zOdsHVOexdL?=
 =?us-ascii?Q?ulbAk80QdyudMNSCqebSSjSj3/725yIkWV0W9vGJ9yv42yuEbheouHBOdi9S?=
 =?us-ascii?Q?FhDWu23EASq6fechIhRiM8WG1MiCCoG5jFuwAsBJj9FnE1DSVq3TzHkNtZUc?=
 =?us-ascii?Q?4cvmCu5FoPoyf+FyaXdhA7wI/u1Q5VWpL+eg532vn+SBFwYyU6xzoibjuhis?=
 =?us-ascii?Q?w5R1i89HGgO3o/9tkZ/as6ckHc17VbZv5xZF38XOWMHAv37vyKIy2IniGJtx?=
 =?us-ascii?Q?HmdDhrXu+qnTM5gW1dIAnGHn5dXYG9FPRQUdOWYjkcsaN8kerh6UFQ5vyBUA?=
 =?us-ascii?Q?CQBojwtRM/vO2UEYCfOU4r5trB3thWlfoATUO8PxuIi7tMX3m8u8zrNV8YV9?=
 =?us-ascii?Q?g2NeTqYr1LApzOLB8P+L3U1GJspRMK0pLhI0CSX1MhTz0AqqkFAgqzHwKRoe?=
 =?us-ascii?Q?RjFn5IyqKvCH0s8H79ryl5bFO2PUeJgBgT7J7UmIoKUFQDn4SVJ6NMvyM9UX?=
 =?us-ascii?Q?+/bszXpAV3HpN0XtJsiQDlVMPrAgdUsZ6Y1uqojHOtFoYLCDGGrmLDMQK/GK?=
 =?us-ascii?Q?HFDvk0AJhBy89HsHtpOnKsEtpT2sS432URNj45z422dutE+t39Cv8RrHAN+O?=
 =?us-ascii?Q?U8ThvYKHkSVGqCMvKC8tntAw8fgJqf9x1WonorFuUfjEgpd0scFZbFh5LUZ/?=
 =?us-ascii?Q?YL0KRtjiMT2GFW7cmNg6ODF+4SxYVQ0CMg/EBtYcrK5FCGX/R0VTFfSCdjqT?=
 =?us-ascii?Q?HduoNBRCt/SIiuKJkp4XU6WtlNBW/SO9PEQljQCs263ZkS3E/18aIO8HY7wm?=
 =?us-ascii?Q?AU6aSJyYC46Kwfqo3rJTqBTa1jkYWKFpw3bx2MUNg/oX8jNkkGaB7klQgldM?=
 =?us-ascii?Q?vpfzNfUTDH+n+S/+XktXNKxTsCPjHMsGwVUCIqrYCeQYW7xzxt0C/E3c8swI?=
 =?us-ascii?Q?aBkkBtdHCrwmciYRLvMTocufWKONoLyR8KbVo2ip/hUVaNvKg8IxI9e/llIR?=
 =?us-ascii?Q?x5BebdWKqscKoZk6NFfQosGctuDqt+WeR5/Y+qHWGTUolTT/XLJhnT5JjXun?=
 =?us-ascii?Q?oNKtnCWiG0xoiUNPEY8cQ5PYF/fxqJo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L++WNKZSgAveXdPB3wu/ILNw7Q/A18INahZmHnknDsvUnuMkC9zMCQTUZ7pBz+VY9zXlnC4aiz8Q2B3TL9G1v4rWZZLlBR5LaxO9hPZL0I6W7s72BjimlokOsQth2IdXQzWQDzrbJz6oXA2JO0feO5L0/EOEr8lEvytx54piHNYx00EaDqJR7fkpsCY9SJ8Xlwas1e5z9ntWgWCd+2QqRHBQBF/nEYjvaIoShWlgx+4RIbEx05vxmf44eQS2sTtAnkSgU8xq6+Xw9i2U2rmUPjRAdtVNYvsDhCPKjBXdcEUOHliLQxnua2o3BzlTILZms2q3WYV6nsLi/jG5wd6UgL0FaBWbU/ESpagGn3l+PUNt4rVwxhbp31X9RKuMrCciTzFng6ohjFr4WxAlJCMd+6AW19iiQEnkyItMChorlJA9JkGQvxerQrQSxnype8/qRkZya15mR+xQngrO+CpdGYh+VrsqL7HSIHEchE3xpAMVR9uzqHTmgPUTOMbigJ2i4YYCPc8k2bgktxiGvNLGPxvlYrFge4UJJfTxVk/PjdMeytMBr0d7N/ZCXmNfJhta/iJ0rteL9EoA7wtZ8mp3/OAvcYlK2RDq9LcP5qRP1Us=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ad5a03-3717-4f44-d6e6-08de4d284cb9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:34:21.5873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6vVG93gWkjSIfa0Vq/6Ug2QLpcd5bxjc/nD3TvQpX3dpbzAHFPoRqhY1HnI8JxqkQzVYH3+Qy/JxbQu1XL3cabR7leQe8iCi0qIHClUD84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=459
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060118
X-Proofpoint-GUID: 0lrg1M3Sj5vAz1KjV8O6iE5e1bzv7Com
X-Proofpoint-ORIG-GUID: 0lrg1M3Sj5vAz1KjV8O6iE5e1bzv7Com
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExOCBTYWx0ZWRfX07tt9ANwRPUV
 HAIolZbvZYTjrMGnPqfRKFtRWZHVZczHH7r6mgMek/eESXCBqyXyVl+q+szGuustXc+2figA+We
 z/3JoZH4s9XrpXR9A785Tb5ot4YOKRGM19oSVvMo7iVNJEKx7Ow24LDUaPQ3G3oKEiUC9YUlIw/
 DkplEJuWqaaiob+s1c3jeHIL+QfZAkq6KF0bDL66fbE6v1RuJUhym5fd1WST1V6/EVhSJrT2OJu
 ceBAG7Yxr1QqEvT65DCeM9mGkOHJJUfdLlawpNhsIdaCOCMYAQPmwvt2rcOdANG6/lwZbVcpKas
 yQDAV6v6YnaT6klQSfJs9WAM1cxCvlTCDFPpLN7aKdogTXA3+fJMyncVQc0jomf/JImdXPtE5Rt
 yNqDz4Z7o7CHfXHy+aGJiAoJzNtpBp4AgdLgeoeDCui1T3DDynF3tfNxCYlZ37NRjhPFcApf/YX
 ZGsNCh23cXcdM77cFz6W+Wd2UBKjNlma+wPDqYbo=
X-Authority-Analysis: v=2.4 cv=OKMqHCaB c=1 sm=1 tr=0 ts=695d0f61 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2CAiOS9jS1y12yc8-fMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13654
X-Rspamd-Server: rspam02
X-Stat-Signature: a9qdukjaezk1d6q3mh3f39ammt74u96e
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A7B71C0002
X-HE-Tag: 1767706470-59747
X-HE-Meta: U2FsdGVkX1+VpQBQHmzQ1ft3B2hjiQ4rEwpw3lCto9S2EAShRZzmsz1pLKdF7mo247tR+bEZesU/xO/OT+GHyYsJOIGKGZKr4LzdZa3lPLzQEkJIDkgmtK8yM3AKcuAS/wNdv38YeWtqWmdPqkij7/is1GIKif4rbNmV663mp+xJqGvS1TaBASbqzATaxskOjJAaySBXHl2O8Dsicr+dLti2KH1GOE/sCn/YqC9fGVffs5z2DQuPDe9tYtX2YLxN/LDaYhfiQj7mMWrT9MCz9+3bv/4ZQ0+VtSlkDMN6s0yayiCteZ7wxNOS6Pyc0lRhYhhy2KVaXVcIK1p6mKIuXiW4G+ysxboEd210mv39jsnhqYVBNglm9k9m4WeLADLVHtDv1NmmoiJn7gyA1OM9m6VogLXT0aYlQXiKuRUXcIpuAuJAMC4v2BEDdkM+J+bAMaYh2Xw1VekbbTinRs6gWqy5zzoOxjLu70OqjwSTDchSZqoPolOmR/yGO59UrpLJa9slhc+lwj9sSi8/npy1kAZSY0S+TOs/DHuFM7fv+KZ1JK9iNEk7PeA1pR7ptNNn4fy6MddFIaU5gCDxiOvUAILNG9X1prp+m/fCkEw4jrKMMYSrYsE2rB90QfrfwdczlsS6GzxlPMm6FkArGp4wDzJSla5OkVDDS5rpvhbsc65ZvWHKt3l2rdTjTS0jqQyB6xW0pzoQrOvKKWBwT/Nwb6HCxMpoJ61aqvpprKBBgokpyh5EF2zfjdrWHdnz5MC4EUPSK/6y23mI9AoDDrWQII+OgZazCl1l5vtq8qoYsZ1tytCvEOB3iP97+qAve9vLQvdKR2dDvrJBuku+WR7JcpR8535q+Zn2+i3n9m3JcesnTrWAFO9nx7cJ2EG9wEYgkvDfNehmqThTVRsbPJsEqgQF5dkQfVvhQjPxRWZvEISscYh2zudEaA82fSis2F2/7dG1yYJUkCAb8x96+Cn
 MspiMFgO
 R37k4mzfJsgLu06AyDjx8m6yJdI2LelPULHw4W+fl7XKWhqIBPBkvsFAl7Nv2jBx/SyhzMOME7RpfcFrgGU/BMvdrE5ikstPBDtjQPSdirtCrMQL/r3J2xnC8bpbhS/xwp/+NNRrt3XQr2ujoYXPq6dyzmiyG2gYciiz8plKsB+cAiXEdowxX8KPp7w71S71yObqR0FHeuaDTUno8/wdCb4sE7tglOHb7N0knn+jl9t93aAMcPSI9nLqIYZx6l2bK3XGfz60Og+T/VPEMHSgBEoc86Y+sgARc9/vpoWEHBn2OwCoFkK0SrcHQNSyHLloRzSKDyRjDXkOXNP6MqhiUK7wSezPNB+uHbgF/mItLhucwgqmmoJrnWIZAyhKo2Dsk5gCKetvVMbKzBs6YSmruQjSJuTJBc6xphzzIwngFV5nNUbvKhlTHB7/P/i3fUUH9RWbFESlp6RaUusg0PeEqPTz6ARpZBHakFhenGt/XNKpJbBOUtXUCiqMPCPj0x5E6G8bz4mkP4U+vcPzJFmYSTt13x3sRvqXxbF8Un0402vKaoNA4ETJrM2tCiOyzHvAM3ZxkLOFygNACZdhKLg9t9U0p+k8iHcOegD8F3Hofbye98VFR5ISW+4zQo2vK/B+QbqwXQ0kJcolcNrDX8gxSHoB8b+h+RJJBpL6G+kneUclJxyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:04:27PM +0000, Lorenzo Stoakes wrote:
> On Tue, Jan 06, 2026 at 01:01:15PM +0000, Lorenzo Stoakes wrote:
> > On Tue, Jan 06, 2026 at 12:54:17PM +0000, Lorenzo Stoakes wrote:
> > > > > > +     /* Unfaulted is a no-op. */
> > > > > > +     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> > > >
> > > > Hmm. anon_vma_clone() calls unlink_anon_vmas() after setting
> > > > dst->anon_vma=NULL in the enomem_failure path. This warning would
> > > > imply that in such case dst->anon_vma_chain is always non-empty. But I
> > > > don't think we can always expect that... What if the very first call
> > > > to anon_vma_chain_alloc() in anon_vma_clone()'s loop failed, I think
> > > > this would result in dst->anon_vma_chain being empty, no?
> > >
> > > OK well that's a good spot, though this is never going to actually happen in
> > > reality as an allocation failure here would really be 'too small to fail'.
> > >
> > > It's a pity we have to give up a completely sensible invariant because of
> > > terribly written code for an event that will never happen.
> > >
> > > But sure will drop this then, that's awful to have to do though :/
> >
> > Actually let me just update the stupid hack exit path code to increment
> > anon_vma->num_active_vmas in this case, and do it that way (so
> > unlink_anon_vmas() drops it again).
> >
> > That actually makes the whole thing _less_ of a hack as it really makes zero
> > sense for the anon_vma not to be specified but to be working through
> > vma->anon_vma_chain, and that's a very important invariant.
>
> Scratch that, this error path ruins the whole thing (we are assigning anon_vma
> later, because of course we are). How I hate this code.
>
> Will rethink...

OK I think will add a specific partial cleanup path.

We know we are not going to hit any empty anon_vma's because we hold the
exclusive mmap write lock, so this can be radically simplified. That way we
don't have VMAs with partially established anon_vma state (both vma->anon_vma
and vma->anon_vma_chain) being sent to the core unlink function which is also an
improvement.

