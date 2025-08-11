Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33A8C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 05:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E024F6B00CA; Mon, 11 Aug 2025 01:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AA26B00CC; Mon, 11 Aug 2025 01:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2466B00CE; Mon, 11 Aug 2025 01:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94A6F6B00CA
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:35:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6191CC065A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:35:22 +0000 (UTC)
X-FDA: 83763363684.22.09EECA4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id E21F1C0007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:35:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D873SfkC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tvcCnxIL;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754890519; a=rsa-sha256;
	cv=pass;
	b=pBTPKBj8UHozPya3SIWjl16Lgk/eZ49SgQE00j2/0A0q83J361RkPRiWLQBX9GHPIh0EyZ
	/Anb4jHXVb6nIqfCGiuCpP8g/pW1nkI229zRo/h/SA/mx5QrzKCMIqqMqk725HfdiubdpT
	t9OENUrNa5detFoxEdCJJ80jJe8cfKw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D873SfkC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tvcCnxIL;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754890519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWHS0dKB9It/DEjUi46qnTads1jv9Dpy8htZPhxS6dY=;
	b=CGURu4T4SSId6c9F7L4KTW1euD7H+pcuP0WbJPVncOgW9ie2zBp8/zniZJi2BnAh0ww+GB
	mYvcJLrpuh9EQeIxOv8tOJCj0APfHTtEnrjGsJYVHDQQnbXWgLfGp8p+6Eq8sytqYueBBT
	YTP3ZLkcH96Dhj1Vc/QZhaVbsa5MEV8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B3NWiv020066;
	Mon, 11 Aug 2025 05:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kWHS0dKB9It/DEjUi46qnTads1jv9Dpy8htZPhxS6dY=; b=
	D873SfkCdlsBlPLOWfj1itz57k7vI0GaS9+1I5Kbh+x4yHZ61LaZ39CJYGXlsfAW
	CYREQUPbLCKPfgjr+qpGq3jhakJKGVhonSV+JCrXFZ9L4GUQT3KlKfeVoXQBRq7u
	8n2J1mztRGLgkbobTFu0/5JNLP4WL8asliBnWKba+/0CH3CX+he1AG1JPxAMLa/I
	PMyK8D4qeSgWTid8M/u8464IP9IeuNA3GBDufpQPJGXz/g1GdwCQAgL6bc8sRPi1
	Mjf9Zvi85jSyTrwl/Vh1A58HBD1nKtiaWgQfZ8g4m/BGR9J6qr7Kf8Pf5MwQjyZU
	xWHtdh2ok4Vp/zjq737hNw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7dhq13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 05:34:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57B58DQe033600;
	Mon, 11 Aug 2025 05:34:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs86ud3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 05:34:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2xCZw6tE9x8PbBSxfJcCRWnA10XWnsC269J+HHNU0A/ID1QxSsMrDX9i+kxpC3BiYiLbFGCq5ksCwHfjJX69vwbYQ7ZbGrsJK435FAj4KqM+ptvGNO0/Y2Kno9PpAhdcngqxXydlKr8ejmvCy6NKuzy7CcCSOyqOb5Qbvm7Dqyo9KUieTOMxg76DuTnumGiuPCIKXh1g/qDC/LfMDWGXTNLoJn72xQZk/RvkFqiY28WoMVwcGfnpmNelRmq9G3OiTu4eFEWLMyY1follSK2Nq0SvZd8PpejeFvNf1cMnrgqz2mBU/DNggTYpC6TkQWMN6Nazeu7lkq5y1GcKyyJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kWHS0dKB9It/DEjUi46qnTads1jv9Dpy8htZPhxS6dY=;
 b=Uffijha45AzmJ37tRPPdjPUSDy1jALdaXOjQgGcm70ARtnbLr+B9AVTYQKHD4dpbBpoeXyDDCnwDD0ERNimixnSQQS1fupSMOJOKQ6xKNtjyol8w3IURRfoSCitZZ2TsD3wJtmLsqEJAF3vp5j4Yn2s623sb1wlXQkoN4X0ydaKPKmNpiHKUia0vw66eJV+e7ch5a4nk7q8j75Wee1OZwQ9WGTPOx+MgE0mXFDzzo3wsfXt9H1bRb3OCHd21p7f5y9T2jVVHDAi0UB/hSAcOGt9o0Sk5wbH7r6nf463KZZg+AxuOWOlUQWI/M/bxBRlQfxrFDWvwfdAv9qVkjZoQOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWHS0dKB9It/DEjUi46qnTads1jv9Dpy8htZPhxS6dY=;
 b=tvcCnxIL98uh1ZCjHdST7IwzyEC3yig6DONpdHVdvTuAtLCV1FlEl+RepQv1wdfeAQ8ny9iGIxpagLHjU9mC0IxAfH0OrE+OcB0riXqcGyQI8ZeceY8juOfaysxYCIGQ05HT/YaxTi+Gn7grceHHVwMFG+i4tu3laGq2824pudI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PPFA0AD88203.namprd10.prod.outlook.com (2603:10b6:f:fc00::d3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 05:34:48 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 05:34:47 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Dennis Zhou <dennis@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Hildenbrand <david@redhat.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Harry Yoo <harry.yoo@oracle.com>, Thomas Huth <thuth@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kas@kernel.org>,
        Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, Alistair Popple <apopple@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>, linux-arch@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH V4 mm-hotfixes 1/3] mm: move page table sync declarations to linux/pgtable.h
Date: Mon, 11 Aug 2025 14:34:18 +0900
Message-ID: <20250811053420.10721-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250811053420.10721-1-harry.yoo@oracle.com>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0157.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PPFA0AD88203:EE_
X-MS-Office365-Filtering-Correlation-Id: bbefe1bf-bbf4-4306-bf61-08ddd898c8a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xFAU1VVxIZJ4zqhw6+l4YQYCgjLRylmg2T+5RZMGIS9BBvKZvnjINuUP2zAE?=
 =?us-ascii?Q?NC0NcW/6plgO6nChSgMjXyGZ9QivQuHyL/aqUaIbn8p9w9vYlJtsnuBgpU5r?=
 =?us-ascii?Q?wPILOdQgOyF1hDnFf9hIzZlg1ci+DQXp9LvA2o2b3kZ4UiRzs/N/3l0a//rw?=
 =?us-ascii?Q?HHMJmc0LUJmaNDeQYBnsGLuclO+qxRVr73SJ2aZy4WtpO8RFUQwCIntMCSaH?=
 =?us-ascii?Q?B6Ty/yV2TYipFLq0MGAztE+8/8DRQjZdj+mEPvVsXbpsp4b432feU+tA6zSN?=
 =?us-ascii?Q?MAuxfpzCeQEuorLqzaO2L7MD57lItVILPJfL9CfYgdrv4McfhsJGFQe9oHBw?=
 =?us-ascii?Q?6pHfHIBVLK1+xLZCGLfjQaU2rFmPpEyHsZxkypGWMxLj4aJDRkOsifIsGnHR?=
 =?us-ascii?Q?UyySjfY14riGrD484MFu89S011eWb631LV1o9NReNLSclYbaTtZQFES3Zugy?=
 =?us-ascii?Q?c5MrqVtWD5ZLrWSzBQ7BNyGxgAuNUhaE8EG1++9s7UPn3XnQHHoqdHIIKCZ1?=
 =?us-ascii?Q?v4GY0e8Tvehig6Ye6ODc15j2b5Zye+oDKsvfFRU3qO71GqGmfodWVUo1kGXr?=
 =?us-ascii?Q?hx4LGuIkrjeOBa/t6AkU4hN0Oy3I1TSgB9EceuY2tc4/xWJvGrSfzTnwQYj8?=
 =?us-ascii?Q?g7n/D4SRv8I5cCfG1yUciwnqabYyGnyOZCCRrHfZwCXABIemm3FTkiAeD5xm?=
 =?us-ascii?Q?B001p16Clut6++el0IeumLRtrFDtHWWndlJ+LssJ4hB4iXd/vCwaCpLK28Ek?=
 =?us-ascii?Q?/KyJED3aLbm6F9cuDmsQ0aaSgpC/Sjtj8YbvzjTSO8c1eqKvK/IS71KAARs2?=
 =?us-ascii?Q?AAY5fYsANv3H15xpVsBsHPI+dG/ZEQa6yuETToZL+W48srxYkj7Su0Vtlc7y?=
 =?us-ascii?Q?EY2wrRj9WHtcUtHytgJWRb33H2W1JFFayfeLXm0sc+GapBonk3vIiFoKEOUF?=
 =?us-ascii?Q?3gtRKkyrK7OVWa0Y0zk8QeCSyJloqfp4EtuiThwh+uECBPzB1QNiPYO7KmY4?=
 =?us-ascii?Q?x7cBt95S/WH038hY/ZqjLJlGH1uRLesgH9bzXjmfkZ008B+46akbUsxyN6DX?=
 =?us-ascii?Q?KHTOZH5l762eSLzn8r4flTZBwEArbLn3sw+L6vG3AxIjiEx8tPw9wrr+dVul?=
 =?us-ascii?Q?m6J237okQYRWZEImN8jyxgXSvTKzwE5Wwx2M9Ha+6sob+EKn46x0BNA1g4pw?=
 =?us-ascii?Q?Txo+fW1dQgOUmdKIHsa8ZcDza7fqIumvXP/T8fuDV5YpdfUrfDH8Wb3TaGKs?=
 =?us-ascii?Q?8vbnNx5u4iuelvF27mKugrmLLXAllMLd4uu6PE7DhRmM9wwtKav4Kcog9ifF?=
 =?us-ascii?Q?pkxa8jNZ0WCLykLVPbXO3JccmtrKUAjtiVEGAj82UYfhlOdSWvpgAPJ2i3Bs?=
 =?us-ascii?Q?pROYCcdG5HMTnKwAZKjX43OMeNSohbM4HlA2GFTIOAfAms1x8oC09dk72J2f?=
 =?us-ascii?Q?8BcLzOZX+1n6TCaCyJjG1lQwR9Wu3CZU+05YlcHZTfzlaN8sRsg2SA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fX/ernJ8IgUWBA5Ei5GE2M3hRENuzXMfAz25ed9oiCh6tosdCpz2YREuRCFb?=
 =?us-ascii?Q?/hH/yrOVzRKL8plvl+EvvJ3/28K6qOWxR0s5YrdKFy98rRoTEq4g3aOqsIDk?=
 =?us-ascii?Q?OYmlUT2Dx1+QK/n9YMVsIhY5Ff+ImMWeiYoIYKVeR08dZpK2Oq8ACDkBWJuz?=
 =?us-ascii?Q?YxEDhyf0M5qfcUMvBXKBmIei1tUK7KZC1BJbHVwwUKhJMi5QC4jhVv4natQ1?=
 =?us-ascii?Q?/HV8+hS09cJAzy/KSpmHuVxj19uEGBTk9+9wIjCQ5ChYlkLyqtfizJwl9kQQ?=
 =?us-ascii?Q?LE8I2VuOvCa0CV4uwvNrAolMMW9UgIGap1SnaQSL1g+OIDuGNpLwD59yy4C8?=
 =?us-ascii?Q?sOCJKoA1WxkI5APgNpGd67lC6mZxaS3W1sLdZvvM2synwBOZ96/4Wq2tY2uY?=
 =?us-ascii?Q?766yXiozyRwYjGM7VucUwdlmv8M20RQsmeh8dcIqrmAG6UGjsRyi6pfiFA+m?=
 =?us-ascii?Q?+vVcdjDZ9uzruoe7WU6XHZiuFCGd7Egxv2a7XHHP2FrML5xGmF2dabD0YPa2?=
 =?us-ascii?Q?4gHaHO3syHctrSyhbrb9LrkcE0LjFtNeE71qfmEzuceSC6ew26fsfT41fpy6?=
 =?us-ascii?Q?7dP7GRO/RX8fn+oxAmJvfmQgVS/jfucTLuA0tb7tUHZoHlw7eB+1VmGyem7G?=
 =?us-ascii?Q?uJy/4khCG1tp3BdtWwSW94r+Z/Jkd09AN1AbI5JdfdrRpOynL52a2v+92/lo?=
 =?us-ascii?Q?zDepYB+EiiESe2kLANvokL+CMKtgm/VZlKhNBKmnsjVNDvAf3fV2+nhVhKdl?=
 =?us-ascii?Q?acYQWtiEm9oaVdo32t7VZ9sNfaDf2AxCGchGjKJjHNAF28TEZSUw6QBJ0Owb?=
 =?us-ascii?Q?Ti5hPc3wc1pxQyYJ2BR4qs0/ZlP9RXchq3BCItCwMFL2zrDivAUO2TUtQ0kj?=
 =?us-ascii?Q?jG+wPRnvx2wT3nNCg34iYAXpPoNCm19sh2x8m8kJK07kzn7XH0V8k03pJLN4?=
 =?us-ascii?Q?VTH2TKA9/NzBtpbnWs9Egi6RwB3waimt6+b33oBfnRdcbLGzXzaYuRqUW4pg?=
 =?us-ascii?Q?R+sPxUWkKWzheVPZ/kxQGPXgeRRjTd/0vje9FK+WJult2XO+iVVSEKzU0y5K?=
 =?us-ascii?Q?CRxR9ASdB7i1k+xsK7dJUreqVaogR79R7wpaPJq5vAP/G4/HA5jtbBX3CMea?=
 =?us-ascii?Q?KJwdlplaJT5CCLJfUAxV9GBUoiHqdKo6s328eCUJKUn9J27K30jef/PoN8fA?=
 =?us-ascii?Q?d23e2MVQ+ACieAxkJDM1GDIcSR+Kgg/eldxlf6gMwBdcdJMpDm4yHcSpLy1x?=
 =?us-ascii?Q?b286xqmZwAQG/y8hhHb6/HV0KLfyX8UPL+2cuYH7qp0Z4K2PH9fAMRjDG2Pc?=
 =?us-ascii?Q?Fq3wNDN2G/X5Yu9Og89G333z7aOuu5RpCP8KjWoNZanYExbHFnSmbKc8LPOH?=
 =?us-ascii?Q?jIsCcXAjq+HoX8OrJydRwI0FzO2JH/n+h7/p5DPHE7BdO8FSBaiQGqqUaSQK?=
 =?us-ascii?Q?AFf7zZ2jkwJkmlJPxmWBdkD9qgrHHybX2sB1F4SiUpuEbFDHmB8PXTQgUbmC?=
 =?us-ascii?Q?ZLwuRf8VKFs+FbXm61tPdTMq9ZELeOeBJEse1zeC4hPJaBDPSHK1f31cqUJp?=
 =?us-ascii?Q?uv8l/ok5bu4AD+x98kEtceTOQBlYDMbNOhoCXxwM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i1T9ZHgtevV7rRBOwU4wV6u64BGfNki6PRq3QvPJDXk16wihVQ2FybmajKVbBX2RO0AR2S3IBcA1EWHk9wcMmTtij432mvui3eTSqU9Q/h5WcKHjLxxy+pnsxNpvU12czlkK/wr+TZ9NDjgzLkivz98l0xEgVC+P2Nza2JwpvjRYSzCcDxWOqWzLLh/38jvfGWzYBRlUqeXPo3fFJTk2oYrbins2MzQLkrLnvMj5fVH2ZT9TCWsicqMV46zh4lduwXuQrgdvlqnYBk1Gl9L6oIN6gNcP9GqAWv7REUhmJkd1dFwNRJlhg+SdhMP5NDChIs8sYfaGz3fyz8DEeTG3DjvlowEqtxs8xgb55LbftMfLDT+qUiLjhnL2xV86zj/w1OqkXzGcJgha5bditlpgihS0seSYFRFa6xyP0Y06DtnTcHQMV15Q0ujw5sOdhLUidOYbnLSCC2yjqSpx8fPbv7MWE8rkwia3e2hxcBRFVBGA7gOxWNga9qHt20JA1uh0CZhVkfVXYyXC+6/Cj5+XyZEJ7RP184TuNKbH9nOSp1MXSqk+lnM0ms6ZWh66kD//fjTNeqbymsLZXlyFvrqdKWIVDo7xEaZ7em0sdv7G0bg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbefe1bf-bbf4-4306-bf61-08ddd898c8a1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 05:34:47.3717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6arZVkT1W9OxLtbtWgMooRENzCxFgHF3amBZJqPbg6lWf9JDArfoK7waYgk8qOQBMxd0GX1Nnw/H4BTmVxe22g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA0AD88203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_06,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110035
X-Proofpoint-ORIG-GUID: U4jfSUqr6XNw-GHllVwWJllLhFthF1tU
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=689980fb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=uplis4tbhEJsONv_2NwA:9
X-Proofpoint-GUID: U4jfSUqr6XNw-GHllVwWJllLhFthF1tU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDAzNCBTYWx0ZWRfXwR0qggR0C0et
 lYpHi88wZqeg0TAPAo/xV2CJNcFMf4Pix/EeffHKsuSNh3tSYnP6soAlbSN8miZLxyT1p41C/+H
 8XNKfrvLHBrg6KeFMwBg9CVmeioxV1CDtQ23+18q1p3dYWMWnT6/SM02ntR0cJKRmKl3nl2mcdV
 UJf7DxPYpIQZjAHuIlyeo2PnTfzxH55ZU5H2bFR4L+0erBAdvj+D46m7Q1Dlr0GGA2JYUg7uJ6R
 UnLRGbRkS8f7Cpt6Na+JozShh5hBlgr+1Q1EJe3NpzvKNtWs866pYfU+oMB31PJrepndMgyEvhf
 HqDile/9n0qladI767Q4aekj8/VNg8erUJ3dV8B1A5o/iO7YdC+aPAccw3owvIymtGnDc1/r3ZD
 ov4SjySIb/nBKDytoW5/nNh5ioOYpT3to4z/vJvccZ8EflQbD4Sde/SlwqEl+j1BH503LDw4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E21F1C0007
X-Stat-Signature: huibuzpgwr5gfrbsp7jc1es5c1twtore
X-HE-Tag: 1754890518-940291
X-HE-Meta: U2FsdGVkX1/mZo6lviox7hShkDKsz9VoOtebCL92j0ZzJ7qywFUEeWj4Ks70DEr631rm03mPdQBQ3ZF+efJ87hfP2RBl5lwr9fJtw80S5/DeFj0zyXMJAkc3cmf1Keo/iH4KLyXfpWBA1V65SC+KssY2m6vQPE9JBmCCGi/inSI5rQnAM0DWDSu0ea+BVidBIdXv2Am1nnoVtjvyVSvE3H1Ez7srIN9dzKPgBfuI+TgTAhb3klrNx1VmsL4T9fcTJrF+85hhNeGIy5pIv15mPg/d8kZa/5pncskoy+3/my8QT6qfFdygcJJClL+28Gi7rB46BmOAjbwY/sqvOeokm/mzpXfp5a73xenXSaZKqT5hqoHBrfzcLKxQUXQSN6gw2DHZS2t88W7MAUn0cTS3inuhJ453HgMlcmlLTtqZQh6o/eciDlpGvisWVMD6/y/XtgG/jko/Wqzs3UvygVM/ZdyjG8CeMVwBCgq23DP6OSOjfKuX0nPh1dhlHj4dk6ScSJ2rEFXqHSiXmgoOcXqYySfuN6DvEe37AtLL7+hxUXJCPyW8DkPuNtdDZS7Ut2JCm2c6iSHTOS80nfFVzr6B+0Ct7gCHBR37zcm7k0gCRgBAh818mGWuTn1yviKW8QgFJnMpmnEMxsJylsIPbN8aodcx+mLaC8i1dn/UcVc+MQx4hzDydVkE2nhSie27lhSHIkM+PneFyKn0hxK10FfGLxnMQ6yy9QUZfRl2aknCQtdWCReNM6UjPKiAU65fDBuaSdGfXDGUt8HqRH5w8U3w83qO03B+7dnP1da92XIPnkUa1WNb8Bd5l0rRMHxFO9OPBm80ryvYtFa0X0ctBJHhgQGApynGXhkHsiYKOv8q0OxMWsKKe2nvDh4XywcF29QWtsBq46b6YPbomBkDM1YRyuX5fEv2ex72b5T4IiKqEyZaljulOFgSm07dA1Xz9/zMUwF8giXlvLhdwXA0TGC
 6NqzF08l
 V9nWJNb57p80kDKJ6v8Yi9XiYzXfGJ6pU9oO0Q4HLAnp21k/sVCGZ1nKrQ+JA9WblGDzi55bFsehOn4boj9sVRyNr66TuXXKOrpkP8Kuh/r04/L1aZYxfvix/15QZdIRemmg61HCP934NRiFLUL+q9L2O8Qo5bJZryF1KZwK1Aw68LsXN318KgIT4Be8tdvgHHJWSMhb/9xJ3xymujwTLtieZ/zBZtCTLxgyJHO6D5d9FBTWq/3Fm+GABIBsYk4Fs97cywJZDM9pri9k/GbY7R1CEIwzmiSHs7F9VV/krlAbevQEYJhwcw6Z/f86QOvuaOY0grWE0BlrZ7UdagmIJb0c6joR45Jq0bmxNDeIk/UZmiz+PYFc+9+Xt6mm7G3ZypnFrgMeDT47haxUdve7KJl8KONxFF+j82Lo0TNH4jSobmPcVWA7SHMb0w9CO6n4CpavUZL3HQsB67MJkKexbh7g+Gdn585QEStynnxtRXQwqUjK31De2NYXaQQ+J1fMCrX2soEXTrIm1B3XWpZ9wvjMq6kZmM8QVA/Lq9Ii3q2qrj9OIzDWcnPJF6sUayLC/j0oFYM+O9A/pU9h4E2ToTol85yaoSkASDu+Qxf61W3U9lckmGy0w0XlwvPG97dGa/rPekAnt2+/e1upvMirVf+LxJQ+M6eaBxgfLrplu5xekyHIWQUIU2JkHG1o3hGY932tqsZCF0EEsOOda35tUCP5cEMJXboXA7Hs4t0Tx+hP1A0cf7buSr0P5Olw6uvon/NCvkNQRYo+3T7ufRv5R1+MfeXKMOItDORsoKqw7eApjJirYxMGz8SC+x/953p51FkGS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
linux/pgtable.h so that they can be used outside of vmalloc and ioremap.

Cc: <stable@vger.kernel.org>
Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/pgtable.h | 16 ++++++++++++++++
 include/linux/vmalloc.h | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 4c035637eeb7..ba699df6ef69 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1467,6 +1467,22 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
 }
 #endif
 
+/*
+ * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
+ * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
+ * needs to be called.
+ */
+#ifndef ARCH_PAGE_TABLE_SYNC_MASK
+#define ARCH_PAGE_TABLE_SYNC_MASK 0
+#endif
+
+/*
+ * There is no default implementation for arch_sync_kernel_mappings(). It is
+ * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
+ * is 0.
+ */
+void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
+
 #endif /* CONFIG_MMU */
 
 /*
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index fdc9aeb74a44..2759dac6be44 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -219,22 +219,6 @@ extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
 		     struct page **pages, unsigned int page_shift);
 
-/*
- * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
- * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
- * needs to be called.
- */
-#ifndef ARCH_PAGE_TABLE_SYNC_MASK
-#define ARCH_PAGE_TABLE_SYNC_MASK 0
-#endif
-
-/*
- * There is no default implementation for arch_sync_kernel_mappings(). It is
- * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
- * is 0.
- */
-void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
-
 /*
  *	Lowlevel-APIs (not for driver use!)
  */
-- 
2.43.0


