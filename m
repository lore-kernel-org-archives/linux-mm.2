Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF07D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EB96B0089; Thu,  8 Jan 2026 12:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8716B0092; Thu,  8 Jan 2026 12:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CB96B0093; Thu,  8 Jan 2026 12:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 022BD6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:02:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 951E9160241
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:02:57 +0000 (UTC)
X-FDA: 84309416394.30.0F9D509
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 252EA8001B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:02:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pjtx4N6K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="tdDug0/4";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767891774; a=rsa-sha256;
	cv=pass;
	b=I8+vdRoCU/u3uaPHRIX8tZ+hO7L2CeEwe+vypbGoBeeE5yKspuIfdUJJP65ejVXWxcKykY
	/jFgbYQHQmuKVX6y2Dm6r/DUCYbLoPLhRtKsulYzhpM3vbgJdzHwSvkTBtRRPK6SJ4IGdE
	1aS/vf+vNRaCQceArxO7bQgB6II/EqM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pjtx4N6K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="tdDug0/4";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767891774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmIN+Qv4X+AHKLeSm1P6jBtdvx+zHIXhLs5yhQiWn7g=;
	b=Wko6xGrE/XxmpebOoEoCLXie3wX6DlecpeWhmucxVSwubM9zJIDI/mTdQhOS4rQLxeg265
	278mGXjNR1bmdJIbNSZ7AW0ra96H7NZ4C2iQw8VhQU6MANrf7uKSXZb1M07iZmEdXPqS5j
	655DEHTEFyscXSkQKMZ2G1+0veAe6Us=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608FnT2l425459;
	Thu, 8 Jan 2026 16:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YmIN+Qv4X+AHKLeSm1
	P6jBtdvx+zHIXhLs5yhQiWn7g=; b=Pjtx4N6KDIyBB+qokpe1G4EThG5WL/iNmg
	kuBGSo7YCBVqO1erD03F1cDH1huCnQBgb/9kGOB6XSk6YHnvkSMhcPDmlY2K0doC
	Av/9jyh55wFFkEtTU5hS4zY4CGYjtcdW0jwutAfGo5Ysgb5tpIOK+WGwEf0XhRFP
	Wfpz9SRngTD1lnQE457CvvzpbCpGibod+V7WzAATmrzCzbzdGtXAad2sh/jKt2WJ
	o88rI5j/LBp/6OOhz883gTnm3Es2PuyPLwkvtgSq7CTmukb44u7lNg8kfcpK74LR
	vqH0W9RmCE2E7vox0FSeECrvugnktOcACJOb/zZ1iNVWA5IfhBvg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjfjd83u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 16:57:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608FJnQg030787;
	Thu, 8 Jan 2026 16:54:31 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjfbf0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 16:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKRGf4mMD9//YMBMkWYicODic+yjtPk+sp4FUDnz1/mTsLpWu+XhBvU76NfIpG7mjZjgVrXcfKS6rx60sktMD6XlJ5YSZTMKigJ2X0AsmBmMY5+DOvsy3PJxY59ZCZQPrD+XWe4zl+V/+bcU0eDy84nbqD8tEez3GFVTQc/3volZyTJgLq6I9aDycGSVpHY7eif34+CHpWwFRG3WGDcAtivJtB/7lhGXignXawbW69fPTgGSprka8we0BYURs380MCef6sVdpUqdSlmlaQfdqiMRVQ+hgLSHnpChFP+FtrVfRUYPR0rLxhS4LrtBu4cCcjpLBiG/CrZPN4xxb1TCbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmIN+Qv4X+AHKLeSm1P6jBtdvx+zHIXhLs5yhQiWn7g=;
 b=r7ZeYmQ1h0FeSDmhqnHEuy3ZB4cE2CDOmCCaGvqKkQG/0fS4IpQVPSOQ+2LifrLXOsVler7ZqRwogkTXIvBN7OI3VDyCmgi5qDkdLIQ//gy0q7xUB4CVl11RSTAjb03hlTNi+0w46GxITI4RuKwbgsjJO7tzNXYAsC9OFFBCrlkGrFfV+X13wKG6B7GRK4K3TGfSXgp8MwchYcESJZCpYCBQa5Ocq0oiC0tw+rwi8p/IEaXj3DIbwR0z6RrK4/04rRK74CaRrDLczxdamBfUPKcTY/fWJClDX4A3HBGnGL6fstn50LJZbGIjvfp/vaG9WH8QDFHG1jP5RPCchGlmyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmIN+Qv4X+AHKLeSm1P6jBtdvx+zHIXhLs5yhQiWn7g=;
 b=tdDug0/41RbmfR8Y8qmhmuZYG81P4reY8T9PFOTyU6u14Y//9Obp9GdUKmRhI99Fcw0VHIt3MVw4j/k2UkEV8wG0PEbZNRzAFvXdeApHSGlvWH88cwOLcyPZwARNZXQ9wXv4zH0rUkotc7iHHKt3LmbTm7jbZvvXEmn+KXbaQTo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5605.namprd10.prod.outlook.com (2603:10b6:806:208::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 16:54:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:54:26 +0000
Date: Thu, 8 Jan 2026 16:54:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v13 mm-new 01/16] khugepaged: rename hpage_collapse_* to
 collapse_*
Message-ID: <46d48e0b-5fae-4275-a770-552188841fd3@lucifer.local>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-2-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201174627.23295-2-npache@redhat.com>
X-ClientProxiedBy: LO4P302CA0004.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f2cd5ef-b6c7-4b67-2eaa-08de4ed69532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?joX0paMv1tY5BNoY72/NZfVBVKFaCWqKcQU1ukT9IKiJb87S29/+Ltypylc2?=
 =?us-ascii?Q?z1SaBcigMCA2UL6FcjPXeoQ2yKwsbFcVO31nmD6bsIM4nqEXfEmfyT6qsG5x?=
 =?us-ascii?Q?Rs6gGRoT7ybKm5w5RO78pSU8rJ3RPki7whff2UjybBJ13xGllnP3rlXK3daX?=
 =?us-ascii?Q?UT8dXz0TmgXYg1/QYxpD+pGX/wNEuG306Oq04zskXXedrbPF/1TdldIb0SVB?=
 =?us-ascii?Q?K0NeV1LtUOivir3exp9LqzRjRkA8zTSDtmV7k3usibChE1gBYW/j2CqLyamo?=
 =?us-ascii?Q?CBRLf5CY4hb5Tu0k155EWKM8KAa9pSUIn7JEmtBf53gG2dK+f2nxoZ7ip69t?=
 =?us-ascii?Q?7qbfZPd8hjCylm9s06GdlsucQ0YEv3ioVfyaaHgjafcOo/aaFcxx85NxxOPL?=
 =?us-ascii?Q?g9OiJX7VX6UQM8ig1aVZDwbP8HG5m9ydJ4j36SjUo3ATKBNO0TW6LNfFNbKV?=
 =?us-ascii?Q?mhqL6mP2pRUL9wfDkmRUeAfn4aRu8POQjTSq3R90MFRf3ME/SM3rEm4usTB7?=
 =?us-ascii?Q?LSozLDmJI8gBtphYO7otFQjcaf0jiPK2i5oUpi2i/BwnLuzW+eEiGNU38B6R?=
 =?us-ascii?Q?k0tTRi8UXqSUVnhj1fDPiRnykt+PGe3zjAk5Hh38LRQ3kcq4PupwjFhmg2+0?=
 =?us-ascii?Q?+XYHyOHzBiygAgylbUPagcpSQaKS8fDoEdltUdaptGy87YwoQhyEZhRLZctJ?=
 =?us-ascii?Q?jhrmIbwf6ArZk0zKwOTT4nw+qJNSqDx03bHn6gNV1K/tTpl7lmEi32kciYca?=
 =?us-ascii?Q?iSFGpuhIMAnI+GAZ1quDh2sEBXDNHMf9o6F+vYBjBsnxXbEKMxKh7khwVyI2?=
 =?us-ascii?Q?dMEaO25rXvx+NLx+Sn5WZW/aeUsn8pdz6mVPdbrSgV1wGMBKikXrlvHcBXOh?=
 =?us-ascii?Q?MYExE9lwUPfqGlt4+w+HtJDs0/ZgnJk3iEhTVwLZKeeElKZhbKuN5b2Jt0k6?=
 =?us-ascii?Q?iOJT5YflNl524dYTYemtJfYTVtnaFxBbn+3ZnsvbUIHdRH+n9gqCPuLWhrEh?=
 =?us-ascii?Q?a9zotKjKeiqxCXqJ+ej3LfjIDeIU/Mva1qlNFODc2calhfD9JkXguVGvuaAM?=
 =?us-ascii?Q?jr70ZrMP2yY0y+rE6flI21kE54kzdyXvBk9W+D6y2ITIH2i8ZYruF9X8v47d?=
 =?us-ascii?Q?933BGf020Uqrl2ei5QV6Jvor7Z+Y3iYFXJ950s76uJV1/AJDxopTyoSDYGBv?=
 =?us-ascii?Q?9zHkgk2RxO1/zMFxXAlPhrSxTBUqAWNWSflasjaKJujZeWytLC4U52r2KsNO?=
 =?us-ascii?Q?xbmXx59Fd/jjYlu4VXxHyXFRxwYRdhbjhtpRFmOmbfP0IsTAzuVhZY+a1/8E?=
 =?us-ascii?Q?uJJJbr8I9Byq2YqUCc5gORfz7U1A3eo55sMgfOEXCm0EEz0MrePdOXO3P1zX?=
 =?us-ascii?Q?XSks89sYohWWTEvrSslApRB5MpIDXZQb5euziV7j2zkDsQuAqyRP+HhaXuam?=
 =?us-ascii?Q?IUKl4u2UuFlT0si3h4dt4bJUGVxllkvb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C86PSjDiEYkxKa+FmsQpvwgXIklzBT1aRp2omezwK0KmnRyDfOcIesSoyCTN?=
 =?us-ascii?Q?9FYqSwN2evMCum5LwY3yZlf3VZoYsnuJv63OBYO+2EntXtAodGOw7msqBBjK?=
 =?us-ascii?Q?NTYkNzQ16ycvVd4zdpXPoBJA8kAvydhBjNrMIUeYRb90jJvqPn3sONJ9XYJ3?=
 =?us-ascii?Q?UnRI+c8mHiKJnZmrh0MpPMg9HsYmzQ4C5C/aUWtLnkP2w/0FJ5aqHRF7Ezix?=
 =?us-ascii?Q?YF/jMZLdnBm6xJl8xPIRWJVw90mXPbQz2DF2JToqQyvnXHTrF97hRKRp4Asm?=
 =?us-ascii?Q?rxMsM+krzvfzNnrEIGpC7cgz6H8zshUY4AKm2m3AQPMSKh1D2yObQwfm340r?=
 =?us-ascii?Q?yRHgBjDpmb1BLIfwN5naxsxljP2sgppqlBk0sT9NKMxgvbsqs68+PPWzzUnj?=
 =?us-ascii?Q?yZEPfUv9+aQFP3k3+JZzRBXMH5xDVnUeMA2TIFrizyFMfiXW+JYXUaU4OnAn?=
 =?us-ascii?Q?Np0o2uYSnuWupDH0WUm457i4ROIqVD4lFjOhKVkpVBf+jnshgjS8DifC55lJ?=
 =?us-ascii?Q?kq8b3SajlLq9UC+4mvtN8fCgY9mBNjWVdcf1Jfu8ln2TSGMkTmYKNZBJLtwT?=
 =?us-ascii?Q?aIOTpna9+yQM6PBcbxCnynoN+NjPt88gbWuO+uoopYS0Q9Jq7bZerckeDyV9?=
 =?us-ascii?Q?05hyxy7gNLxADaG3b16KTfkz2iyM8mCkb2x1NfYvoPYmizrgwQKXS2hTm+oU?=
 =?us-ascii?Q?bu5+OUZRCph0BMMYKSZpAh1pc908Nb/fRvk3GQlOOgrvIaJnNZffQYr/qaJY?=
 =?us-ascii?Q?+/4j0fUMT0k9uwzgjYiPK2Qz+pRfMJznlz1EgWRtgFvi7MUtbbF75RPv+IbV?=
 =?us-ascii?Q?d66qNuanaGeGLHKbRtSWyKUqKrV2+y9sKMSDJCdoc7DF+LyQW9KV2TC+vQCg?=
 =?us-ascii?Q?iP4dFkpcwMVZ6LoMccwCwYvJ/g5z784MakjQoHRjo+28alYlKnryiNtxNpSo?=
 =?us-ascii?Q?FYQB/ecnARDVEEQ0qwFIRHMssZ43BLYexPywCFh30Ktz4bH1SLryTlWNU9a5?=
 =?us-ascii?Q?AlDDJ6PeAm0l910pwLXbNof/z0QVrhMdEgr0ESrsafR63JCNpjGtDg0gCwYi?=
 =?us-ascii?Q?Hwkv/v4g7c22yeaBUqOCF64j0RhPenM6qd8DO+kbRJwA+PpasRiY7JPT2444?=
 =?us-ascii?Q?UEIedS7ZAKWuEtios8rkYgwAkBc7iiyfixaaLOz77NL1HGOBUFEBCqu9qLFq?=
 =?us-ascii?Q?Vp/alIY6AyED7qLEDfCdl+Wcf/jEbmxy5biHrCP9MhL6+ESD7aNlTmm707TD?=
 =?us-ascii?Q?q4pzZ2EdEIWs7dBq/ZhShMapEcOrlqxKiHtsDbyyl7uokzvubidJB4ekkfR0?=
 =?us-ascii?Q?sOaV86yLYqUCeXjUF3io2bDE2dPCV/rd0cUVlcv6UADHMLJepBByaBYQwUSm?=
 =?us-ascii?Q?b13SS5FuajEnSeq0lHHvPykLDhcmJwQCXZR2rZyCnxeiqCNw3muyscJd5TZs?=
 =?us-ascii?Q?rCducrQb02mvTsATJG9U5sbgKeB2fI5rxFy2SOh4w4uxRnzZeS3/PLoEUd+E?=
 =?us-ascii?Q?3/IeqxVKlSj1+530k8NZGmaUv9l+iusjKNDpJEvrzSRBJ9b+e8Jy9e9TG0cV?=
 =?us-ascii?Q?qNFL/04Hl3K6tYux2QfL9+VjNJmctoQyg7Svb4XjwGQmEpR7MB5Sae+aJZsn?=
 =?us-ascii?Q?Wj0tjHScdZabCT0QXF4id2MNt+3cdyHcXlX55XmTYQ9/PfaqWnq3cpDIw5Xx?=
 =?us-ascii?Q?rJVHUhbgVcsjqeSDHW+71HF9nYvr/ut8LRpYP08YNF59xwGeRvBTxxbl64qY?=
 =?us-ascii?Q?veaxG3SP31hEqUcFR3RLM6s68YbiKYs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iJ7Vo4hnZTlGc8A7DpYQb//0lQ6F57mnKvaQpCofh1UsLWkyECg/vQYtGeJUk4GxNc8i1bip9Q458nRh0NiPA/0BARI74pcbFKUCktm9z8uooTQUK88u0pX7GlAw5pokG+Kc6SfEdTf7jv49PW4it7W8H2rI4Ge+g/c4OIh2HlJ+bL20TYrZpu+u18ISQX4WQpRrX/Mt1QtcmY9SWVqbm6IBBddNhCYGkXUxpU2T2n0pBBFm2UvnHmfp1pz1dzzANkRhMp2Op/RmcKYqa1IgtnfTyVncMsxJPu05c5YLM+qldARB7DXTt9iYQUHrkZr5+Qfx39vcPASu9S3WxeZtnR2uFGeKtk09/8b2dBjd76d+y+/D61pW8EPQSG9zG5+Kc577sk3AbskUwUY9wcSLgMxfNW+dDDXURhdi5JbpSBDGDD5sn0TJJ6YRAuyIaoNeamFgfbOpgzGzFds8+E7WR8bfw78BPhCEKOC/Ro5epbTgfbg+j1K/vwfMIeG7XA+wZlA0faApefBpv53V67m1/WbuCZqX8fuo64evL3WjKjGT/hyEFXJdCJ6jTgPqhGGU+ba+AsxKhOmGOlcwW7rVKaJJX+52m7sMkUsJL3zvaFg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2cd5ef-b6c7-4b67-2eaa-08de4ed69532
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:54:26.8740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQvvFSqalmEOrgSF5j81teh647EOW5veZ/ooBfPBHxrfVsPWy8c+lohvrH7HuNhEt8ND1dn5y6ncbc0CI8ps0WhaRfxcdA6KkFpos7xvoBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=984
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080124
X-Proofpoint-ORIG-GUID: lNcnM3Z3_jYP6wbC_RF-C5_Tny2M88p7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEyNSBTYWx0ZWRfXwCiGkaH9oLrk
 u1uAscPueyBR4c18lNjCGXZzBchGn59zLjJo/OCQ832GFDoo9NEJ1eagvYvvbDLl5OE0RFbETOK
 6Naap5d15J4yqyDSuelfqZXCo38tkL/ecDs/PJ56pNjjLWRHvBgJRdxRUh4lqfMzqT5KvgxQitW
 ZCKmGBXxXjZnINEcozPRNKZS6LG2aNFo60721MSL4o01MQqYo4BmbaDRgOnaCy5iFHdWSEQ7hnl
 3yC4V/R9Ct0aUu+2Y1xC3eibcqk3vzduw2TM/OHs4WDetetuwE0bJSnUNxOCXYiS9m9bnlhaAHj
 yx7imZFgmRsRq8KWjfpvmhDlD6eiDuA81prJj8bYh8f2+BT/zl5A73M8wI6Ah46FCLBfKguyHJ5
 0oVEg0XI18z964z6PqyG7D28BUYqS21HuA+CfggTCCtHcI7mR1JM3xffSxM0ZEL8M4Mm6bZcsca
 E9L3jdiXfR91ojts0rRowK/48dLKqOWGSv2QHOT8=
X-Authority-Analysis: v=2.4 cv=MOJtWcZl c=1 sm=1 tr=0 ts=695fe1f2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8
 a=20KFwNOVAAAA:8 a=Cypll0htrsRS82Uaf6kA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13654
X-Proofpoint-GUID: lNcnM3Z3_jYP6wbC_RF-C5_Tny2M88p7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 252EA8001B
X-Stat-Signature: cbzxef85uy8y3ty7uigh8esfee3h3b8w
X-Rspam-User: 
X-HE-Tag: 1767891773-477134
X-HE-Meta: U2FsdGVkX192k1gfF61O2TG8Lj6BE4s2hBzBtwMdLJKYldVsw359dwJ1UKPq7dlEP8lc2tyTjKF/NO1fm4ATGribtKyNRR1EwFgGvwEOk87kDBufr+9uP/FwjVtLFhClj2YJ1bhcA2Xzgw270+oCniUxwF7TVyQ1ZjKxjdyYzclPra1UmSb/fGZCiHidk9nPVA0dSVpGXB5TvWKadFCwOAax57+olnraE/daH+nprFvHScd2TLjFKwLHUX5RxkwrFAv2QuWri9HVBkmG/ItcW/gbxy5IExNdl25lW884LYfRBd05zUi7XgAiMu+8l8dqqDU0t2s27klHNWbCEOuLQ3D9MZmkRGOIsp1gKhSeZUyWTt4b735RTBeI/ve3l2s521lmIZ64dMpxSDcxLSde84VW6X9BHtxBmbRJFEtr4kzduhc7vAt2oqBdBd3qFtbp9IlnNvYXm350H1cThBUrZd2Dj35IDzflpu4c8Fbl6Zp7FF/YZvUEQEh5+3ranEqgRRYSTh0vtkEpM0IdD/LCQDOix9rWQIyU5leXNPnMAGBjdBtogMrs6Z8O6I5Xa+TkhoYQHTY+WNZ8Pn7vXIKIRH5CmWEbwrkrumMbl5pbQ9uGCQx/TQnfOpuyFCIEL80d1pvdUaTIszZI5yknj/ZipTfbYAzRQbYWUzw9Om/XlKdqnPyp2lRXnV1RW9T1zDAKg8VSSjztTpNIrXdexWdyCUmLj3WkHPacLFRatHMz61RsouAdjfU6gEuEAArAfTjq6Zt4vMT7CiHn+4aBXrP3D9M2+CS34t8a79tRbHwAJTr3b66GxU4GBG2xT+vLUXv3fxKz6e8TjMBiv3GS0+DBRO/dMGxOrr8TQiUfbTtkC80vK+6JM5P7ibVOkQ9DVevp3CD/g+aMtqka5qHmAeRx5jX3fZtuSrVbTm9/OhEKGetAvTuLTtPy+U6GnXP9y5mAE/xxt47SBCpuVuSU9EW
 +M55RFWS
 83fzyLoWoR+4pVrXMjf3SuZ23yTLxeqIFvz4yaUko1mKI88tplLxv6mU2IE4l/pSqQQRrYTVqrH8miCJweZSg5FZBADXw6DFQyFc4tG/5rxih6QoWOfJNUpmPsCYDjq024Bid9YXk8SSrEkNJ397nvb+/t35JgaTUrreXUWzva/zlmnvpmbYLD8y+ODSIGvZW6eyN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI there's a merge conflict vs. mm-unstable atm (mm-new is unworkably broken,
so prefer to base on mm-unstable if possible thanks).

In mm/khugepaged.c:

<<<<<<< HEAD
static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
						struct vm_area_struct *vma,
						unsigned long start_addr, bool *mmap_locked,
						struct collapse_control *cc)
=======
static int collapse_scan_pmd(struct mm_struct *mm,
			     struct vm_area_struct *vma,
			     unsigned long start_addr, bool *mmap_locked,
			     struct collapse_control *cc)
>>>>>>> khugepaged: rename hpage_collapse_* to collapse_*

<<<<<<< HEAD
static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
						 struct file *file, pgoff_t start,
						 struct collapse_control *cc)
=======
static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
			      struct file *file, pgoff_t start,
			      struct collapse_control *cc)
>>>>>>> khugepaged: rename hpage_collapse_* to collapse_*

<<<<<<< HEAD
static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
=======
static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>>>>>>> khugepaged: rename hpage_collapse_* to collapse_*

<<<<<<< HEAD
static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
						 struct file *file, pgoff_t start,
						 struct collapse_control *cc)
=======
static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
			      struct file *file, pgoff_t start,
			      struct collapse_control *cc)
>>>>>>> khugepaged: rename hpage_collapse_* to collapse_*

Maybe worth just double-tab indenting the args on subsequent lines to make
dealing with this kind of thing a bit easier in general? Tab/space alignment to
function name, while neat, can be a pain when return type changes.

On Mon, Dec 01, 2025 at 10:46:12AM -0700, Nico Pache wrote:
> The hpage_collapse functions describe functions used by madvise_collapse
> and khugepaged. remove the unnecessary hpage prefix to shorten the
> function name.
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 73 ++++++++++++++++++++++++-------------------------
>  mm/mremap.c     |  2 +-
>  2 files changed, 37 insertions(+), 38 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386..959be77f2e65 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -394,14 +394,14 @@ void __init khugepaged_destroy(void)
>  	kmem_cache_destroy(mm_slot_cache);
>  }
>
> -static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> +static inline int collapse_test_exit(struct mm_struct *mm)
>  {
>  	return atomic_read(&mm->mm_users) == 0;
>  }
>
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> +static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  {
> -	return hpage_collapse_test_exit(mm) ||
> +	return collapse_test_exit(mm) ||
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>
> @@ -435,7 +435,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>  	int wakeup;
>
>  	/* __khugepaged_exit() must not run from under us */
> -	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>  	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>  		return;
>
> @@ -489,7 +489,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	} else if (slot) {
>  		/*
>  		 * This is required to serialize against
> -		 * hpage_collapse_test_exit() (which is guaranteed to run
> +		 * collapse_test_exit() (which is guaranteed to run
>  		 * under mmap sem read mode). Stop here (after we return all
>  		 * pagetables will be destroyed) until khugepaged has finished
>  		 * working on the pagetables under the mmap_lock.
> @@ -579,7 +579,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		folio = page_folio(page);
>  		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>
> -		/* See hpage_collapse_scan_pmd(). */
> +		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
>  			if (cc->is_khugepaged &&
> @@ -830,7 +830,7 @@ struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>
> -static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
> +static bool collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
>
> @@ -865,7 +865,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
>  }
>
>  #ifdef CONFIG_NUMA
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	int nid, target_node = 0, max_value = 0;
>
> @@ -884,7 +884,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
>  	return target_node;
>  }
>  #else
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	return 0;
>  }
> @@ -905,7 +905,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>  				 TVA_FORCED_COLLAPSE;
>
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		return SCAN_ANY_PROCESS;
>
>  	*vmap = vma = find_vma(mm, address);
> @@ -978,7 +978,7 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>
>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
> + * Only done if khugepaged_scan_pmd believes it is worthwhile.
>   *
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> @@ -1065,7 +1065,7 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
>  {
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
> -	int node = hpage_collapse_find_target_node(cc);
> +	int node = collapse_find_target_node(cc);
>  	struct folio *folio;
>
>  	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
> @@ -1244,10 +1244,10 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	return result;
>  }
>
> -static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> -				   struct vm_area_struct *vma,
> -				   unsigned long start_addr, bool *mmap_locked,
> -				   struct collapse_control *cc)
> +static int collapse_scan_pmd(struct mm_struct *mm,
> +			     struct vm_area_struct *vma,
> +			     unsigned long start_addr, bool *mmap_locked,
> +			     struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> @@ -1355,7 +1355,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		 * hit record.
>  		 */
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			goto out_unmap;
>  		}
> @@ -1421,7 +1421,7 @@ static void collect_mm_slot(struct mm_slot *slot)
>
>  	lockdep_assert_held(&khugepaged_mm_lock);
>
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (collapse_test_exit(mm)) {
>  		/* free mm_slot */
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
> @@ -1769,7 +1769,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
>  			continue;
>
> -		if (hpage_collapse_test_exit(mm))
> +		if (collapse_test_exit(mm))
>  			continue;
>
>  		if (!file_backed_vma_is_retractable(vma))
> @@ -2285,9 +2285,9 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> -				    struct file *file, pgoff_t start,
> -				    struct collapse_control *cc)
> +static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> +			      struct file *file, pgoff_t start,
> +			      struct collapse_control *cc)
>  {
>  	struct folio *folio = NULL;
>  	struct address_space *mapping = file->f_mapping;
> @@ -2342,7 +2342,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  		}
>
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			folio_put(folio);
>  			break;
> @@ -2392,7 +2392,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> +static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
> @@ -2427,7 +2427,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		goto breakouterloop_mmap_lock;
>
>  	progress++;
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		goto breakouterloop;
>
>  	vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2435,7 +2435,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		unsigned long hstart, hend;
>
>  		cond_resched();
> -		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +		if (unlikely(collapse_test_exit_or_disable(mm))) {
>  			progress++;
>  			break;
>  		}
> @@ -2456,7 +2456,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  			bool mmap_locked = true;
>
>  			cond_resched();
> -			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +			if (unlikely(collapse_test_exit_or_disable(mm)))
>  				goto breakouterloop;
>
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2469,12 +2469,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>
>  				mmap_read_unlock(mm);
>  				mmap_locked = false;
> -				*result = hpage_collapse_scan_file(mm,
> +				*result = collapse_scan_file(mm,
>  					khugepaged_scan.address, file, pgoff, cc);
>  				fput(file);
>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>  					mmap_read_lock(mm);
> -					if (hpage_collapse_test_exit_or_disable(mm))
> +					if (collapse_test_exit_or_disable(mm))
>  						goto breakouterloop;
>  					*result = collapse_pte_mapped_thp(mm,
>  						khugepaged_scan.address, false);
> @@ -2483,7 +2483,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  					mmap_read_unlock(mm);
>  				}
>  			} else {
> -				*result = hpage_collapse_scan_pmd(mm, vma,
> +				*result = collapse_scan_pmd(mm, vma,
>  					khugepaged_scan.address, &mmap_locked, cc);
>  			}
>
> @@ -2516,7 +2516,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm.
>  	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (collapse_test_exit(mm) || !vma) {
>  		/*
>  		 * Make sure that if mm_users is reaching zero while
>  		 * khugepaged runs here, khugepaged_exit will find
> @@ -2567,8 +2567,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
>  			pass_through_head++;
>  		if (khugepaged_has_work() &&
>  		    pass_through_head < 2)
> -			progress += khugepaged_scan_mm_slot(pages - progress,
> -							    &result, cc);
> +			progress += collapse_scan_mm_slot(pages - progress,
> +							  &result, cc);
>  		else
>  			progress = pages;
>  		spin_unlock(&khugepaged_mm_lock);
> @@ -2807,12 +2807,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
>  			mmap_read_unlock(mm);
>  			mmap_locked = false;
> -			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> -							  cc);
> +			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>  			fput(file);
>  		} else {
> -			result = hpage_collapse_scan_pmd(mm, vma, addr,
> -							 &mmap_locked, cc);
> +			result = collapse_scan_pmd(mm, vma, addr,
> +						   &mmap_locked, cc);
>  		}
>  		if (!mmap_locked)
>  			*lock_dropped = true;
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 672264807db6..db31d0231e05 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -244,7 +244,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  		goto out;
>  	}
>  	/*
> -	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find
> +	 * Now new_pte is none, so collapse_scan_file() path can not find
>  	 * this by traversing file->f_mapping, so there is no concurrency with
>  	 * retract_page_tables(). In addition, we already hold the exclusive
>  	 * mmap_lock, so this new_pte page is stable, so there is no need to get
> --
> 2.51.1
>

