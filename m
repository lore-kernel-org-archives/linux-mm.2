Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 860CECCF9EA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 05:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C668E0129; Thu, 30 Oct 2025 01:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C668E0112; Thu, 30 Oct 2025 01:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD308E0129; Thu, 30 Oct 2025 01:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95AEB8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:22:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C3B2C0A40
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:22:12 +0000 (UTC)
X-FDA: 84053634504.09.65B94B5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5C8E40009
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:22:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jZhp8Qrr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hZTdhCK5;
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761801729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1akE6IfLC/N+k0CPcLZkBnHKdDkzk5/UnLklqjZzvQ=;
	b=KR+pa8IfdNRxcTs0S8Plpjk4IlE6UWecgeWSielwltvuOQKuiXz7c+vG0wtpqM5nKT/VwB
	Y4OLx2+gDUBLeJAAatlIIYnjLtXRLIoj43ROCSEaRpQpRqH+/X5sxrReXR13kWc1hivXTo
	Vko+fEeYnUvhDDpOtc0/gWiV1RsAZOU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jZhp8Qrr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hZTdhCK5;
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761801729; a=rsa-sha256;
	cv=pass;
	b=1pxRuYL8znF/EW7gIBoousb9YzDfK536fgp59pzmKKPVjAo1Xfz1dm1sLbdOlp0ZE91HfI
	7izxRJvhXlyd7eWwHUz8aKpfCeHaNnOEjffb46R+dc4lRFCELeMgfCavvUDvQdrfyzavfE
	nZtLQmfAXVVVjU3EwBGKT/m/o+Hpiqc=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U5Iao6019039;
	Thu, 30 Oct 2025 05:21:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a1akE6IfLC/N+k0CPc
	LZkBnHKdDkzk5/UnLklqjZzvQ=; b=jZhp8QrrQKTIxmaou2HyqGVf0yxcaVm/8t
	lkDq/ubF1eBWSq3EtLmGe8HZqk6CcTxWsaIn8aJgEpzGMEO8c678oH83blopWdYl
	NJ8Y4lT4mDvEr/CsK92GKWrjLzKVUfRVc+SKVGnrTfEVcbi8SKUPm0xXXYLfmbMQ
	BKGUqkIANhGej6XXUCLxuUijdOy8UfLTVTLlVb7FoKwXYSIGuh10gs3GgCkWsEB7
	AVaPyqMJJ6IBOyJoM2tsx48s7SZiIU+tzf2mHx8dcqXbhs3aZXoCVn2U9xCFGLZR
	Ym30cbZEtt3L3rP4qn0aKZBTbdQ140JLJNctNnhZTr423CVtKnGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3y03064k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 05:21:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U42MhJ007586;
	Thu, 30 Oct 2025 05:21:45 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33wm4fga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 05:21:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wfbzak9/r/kEiN/KE84ADkEjkngWjHXdOgQ47/URuJf/693Y708IFoOOwylNgKVan74WX3+QeGmFp/NKtTEoA9lcr0YFE2CYo6wyYoyfCBco0mHARu56Detv+o+mbgi/mWkxMyF4x33IV4xRMAlX/nHwsB/zBVKcdHdDMTfuoPLrlfbHDwdG2hFQ/evmdxQO8Bq+VE0JvlILLEsuvZiHq0Kn5NGziFHrCvi2rrBEhfAtTlVWerHLsBtkRZ0zEzd/NFXMVw6f+3ESmjCdrfIq1P7sdZVX687PSo6eiFFxt6vKhl463x/EY+pDUp9aYvMTXsm0PoX4q+loh6kRoqkSKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1akE6IfLC/N+k0CPcLZkBnHKdDkzk5/UnLklqjZzvQ=;
 b=fuoCeHDYY7phKpCxpc0ennlG26o9Mc5nbqDfbF9GwgDUkCjiYPTWCY+hhNJIaeJvN1E7SXOFMpM2Q62BfdWjZHoa5eXK6cywCpQfMfzgAU2jYl5WoFGxedqJ7OiC+kca0uvZxmMRLnT7MpCOG25VO1IEz/omemNlbnS2oEfjvFCF70nHbpY2IxGqYOXAiLDA3SZankAcNKkGoosBNp/34dghknctLCxTdwv29x2+vdwu2ppeKg2IEFt+G2kUzZAunJupBBzPEFgqmOg+tqUKUFN8R/+PzMuhX5ml96nSvWt0jWPlCAuro4fofnOuRy9URMUFv6vhrPlJrTckvlohEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1akE6IfLC/N+k0CPcLZkBnHKdDkzk5/UnLklqjZzvQ=;
 b=hZTdhCK504AH5raTIsA3cr2k2osv1P8uj+iBUdbiyJUFSuaX5Omc4Yad5kPL5QXMActMIF2avmFSrGga9U+r9ZxqS4LPjL75BkF2Mw8gxXTp06eWqqPOTbXHn+w5UkaJlJEPd36RTq1JRhOsUbvFpBQ++QQXV6gumP1wm7siTYA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB5663.namprd10.prod.outlook.com (2603:10b6:a03:3db::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 05:21:42 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 05:21:42 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-5-ankur.a.arora@oracle.com>
 <20251028133648.GAaQDG8PfOwrSiHYuk@fat_crate.local>
 <87ikfxguhd.fsf@oracle.com>
 <20251030001759.GDaQKut2wDtopc0qn6@fat_crate.local>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        david@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 4/7] x86/mm: Simplify clear_page_*
In-reply-to: <20251030001759.GDaQKut2wDtopc0qn6@fat_crate.local>
Date: Wed, 29 Oct 2025 22:21:39 -0700
Message-ID: <873471ge1o.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:303:b7::6) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB5663:EE_
X-MS-Office365-Filtering-Correlation-Id: 771aa72d-ea75-48cc-cfa3-08de1774354d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X+xjwKX8u61ZuBkU0jLchrBvmq9clzhQRD+Fknq/+0QUsKPaXg+58RO0yuIw?=
 =?us-ascii?Q?oCFTyrgp1nBPnpKkHu2nghIelJIOOIbJtpm9CqslXvyoyUU6uATB08Qke++I?=
 =?us-ascii?Q?YNtzNnhZjaOdusoOjoHU/ZO6xBj+WKS/1gZasVsyqTCFq+kZQDrAvaVTpOBF?=
 =?us-ascii?Q?k5dVhY37lcAqEiCy2cKlngFLM9v5b5IxJTR1//qS/jWWs1j8bV/CVOAGgOrh?=
 =?us-ascii?Q?EzcRl/9K6f8DIsusDe25c8j6tTNDOd89pq7Ls6RyadsyNZ2WIa6blOelXCwz?=
 =?us-ascii?Q?AYd6sAalpsH/ootIraOVp80qmZZ7Tln0Aa3QYq0H0MI2wRmKuzMzddopGU2u?=
 =?us-ascii?Q?43CPbc9oxfn1n5YMS2wLc4a/DKtZ5+RrHCYy/RchpGeZWhWGOx8oKjDGAXzM?=
 =?us-ascii?Q?AQw9rGad5rs1Ee80gEWAJAWCpugDQgeuQFfvKXLpCBOTTTJDaXySOaJ4nyVu?=
 =?us-ascii?Q?uqcChYPSseBy2rym5MDV6aMkttUIwh/Sd/5MPIcyVvKdPlRN1Awi2cSwu3z5?=
 =?us-ascii?Q?Xn2Cq4IPBgbblWaLOis1I2SYVOsNS/McFc/Yd167mLpgZMW+URAClWCoHQaW?=
 =?us-ascii?Q?KVXw8fBYZx/jx7iJQIAjk0u0ALDpggeouXBjdw2cafjXBlHIL4Nmck0/Ixdc?=
 =?us-ascii?Q?SQRGStqE6pilE38W3NQb6Ah0Y4WhlZxPbbqRJwKz2xPfwpZ/5zdyjpm8R0ww?=
 =?us-ascii?Q?72/d3+g2Y50GOjBvghjFRnQP9ENdY8NQ+0l59NZ+pcH4ze7g/l46u3rq2Y2u?=
 =?us-ascii?Q?z/ZRkvQY60lkfmnAVfRF0/EOsVqR5quZwFQ4rY5gqO1goCoIvEmZfr4skNVN?=
 =?us-ascii?Q?J8tyNjj02BfBPn1sKaAz0jsd/fZywGwcvcg3NwjqCUC47ZZ9Nr2lM0dj3M+B?=
 =?us-ascii?Q?o9ilPDcKz+ziPpljeeLqdNRxUBMZOAviC0r82LtAQSBUDmq4oIsfsmxBXS65?=
 =?us-ascii?Q?vdm6h5wU5WauL1uq1LOkf5OZtG5WRAY7uWs2BvBaOcsYQgSz34H1t0lJp8kD?=
 =?us-ascii?Q?g51mr7Tldq2Ju+IIrLtGY+0fRVgU8DTfX5wUm3NuLvaQs+dBq0qdL8uz5clo?=
 =?us-ascii?Q?dFm62/sYzPF8hILMy16QUWPNy6g6mPx461pJm07WgOfjDZNHHYGtZMSbjCX1?=
 =?us-ascii?Q?NFLjmz0+9hl5t+HFy9EOZK3Pp79VTwDyAhPtcE9FEa8BgxPo4Vfu1kdLkloR?=
 =?us-ascii?Q?ihUMcB0ZJgC8D0qgB6DYyp5gBUQsc3AkLCipmo8xe1qre+csDzy4yuNQ+nT3?=
 =?us-ascii?Q?m8GG/Vmw9PATmgOx9pCSUfhenqTL8qeoTM16bnefrgVPZcHU/aYgwc3IRT7N?=
 =?us-ascii?Q?05oTIxHynBB5u9jTb/0MLcbTs9AZKb4GbwdOb4amoaHDY2EWoqRhsky/Rqr6?=
 =?us-ascii?Q?QQ0V5nzIjZ7Q3nDKGwqQ60OVR6wJKANpW85oqMPwsFKHfJL0Nab4PZuk6LEd?=
 =?us-ascii?Q?07HGKMtIwg05U62PiJWP7KQkMK5+S9yl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4cT+3JCHO7nH5zP7C1ErumJBy3LIS7OeDjBi84WbPRhG0KDei9nji2JEMaVk?=
 =?us-ascii?Q?TJPQpncgFsbSSd6PinFkVaPrwQKB5WgzC+hCS395YBxzY9APc5y7wQ3ItN4X?=
 =?us-ascii?Q?Ni7ZKYf3Q83+S2tsHx0CiaIVs8szOy51sjQJRG5zcO6v1GZc48OC3mUOx2j/?=
 =?us-ascii?Q?9m4E3I79gW59PCyh1JBKPHxo6BsB8DRjv7L8yjWkNOR6Mx+oJY8y3DXscboI?=
 =?us-ascii?Q?yJX9yAhRiEBlBIaDhM74/fzrqFG0bA1yXs8Le3C80cmoXIIrHsgoMXjy6NRa?=
 =?us-ascii?Q?vZIpx+4rvTTUoAuHrzbHZDSTbkuAOu8B2pkz3yI578kgECqTTMrSq9W7MXTj?=
 =?us-ascii?Q?Qh+2AXwKZvH9lbdWesT2IjEVggX1tbHJHHDXe1RKQ5xJMPjcYgfwX8g8I3+P?=
 =?us-ascii?Q?bCl9feP6+urQPFIHDQ6aGThZVxLe0rRRPGFvztd+B4FlL6lpg/2n5r5ne4cY?=
 =?us-ascii?Q?wVflEx28Ksy9YSIfRV7BNAtIN9my5MPrGl5USEBuOhGrL2RpL49iilE0Cd2i?=
 =?us-ascii?Q?i2pb7GiFItqnSAI/nPkam3zk5UiEKUx7Zg4YAmvuu5zpso+Mz1hJqpOcUF/3?=
 =?us-ascii?Q?3GXdyLbxQZt+fpfWEM/MHZhy4o9HHofTJJBpTzAVO/d6N77P17kyLBZpQSMf?=
 =?us-ascii?Q?RgfHsiF1YUBjUtHF55h2XjsSgYspY63zo9HgOdJ7q65qDmkb73+R+f/a2tL9?=
 =?us-ascii?Q?IOM0RULvyv5W+YCZpkmcaPrW1roL94gkAIcxbNOkb9PPI9uUM9ICCiD+Waiq?=
 =?us-ascii?Q?l+/hdg5pkwx/HC7WonTdqKq3pL4MrLcEWOBL88AQ8FewKeE5sc+q0zOXMA8w?=
 =?us-ascii?Q?ZmqKR2ev6+jNV1pcl2DN8eECOCr/8F8JHd18E6UUif3H6JIaEDknkLpf9Xpl?=
 =?us-ascii?Q?8p8NMQ257NR+RNRXORoh498lotQ7oLcnQTj6qpUmZW+LP2ozmztZy7hGC+e0?=
 =?us-ascii?Q?ayh4HcpbcC/4HhKTNLREPGxjIlRnjrZd2K7Or3JGDB4X2uYkSM9/o/e9l2rn?=
 =?us-ascii?Q?89dqi1Zw22O3yRZ4bxf6mKqDaJTzJOKRN6Iaoxzdu+d1jRs6Q6vIcZBCebe+?=
 =?us-ascii?Q?mz5rkhhUtCG9qhitDxw9tQbVzgeq1dF1iXPpQ0DnOiy0RwVvKPzC3QGiCz4l?=
 =?us-ascii?Q?aQ7FsK8T4ohnnVWWGLnVJQtjFXNYi8RXgvm8Ax31IJ3HRMEu16hXnjBk2rvg?=
 =?us-ascii?Q?9yIbSbBqRxi07Tgp7xecbt3y8ci6sd7MfIAYwtXDeL2dH2cj66D4EYRwnqM0?=
 =?us-ascii?Q?inWqP8tAQ5u7Jxs8uqkdWwlJx+/M58Y5YgpOfeOnzfEdQJOwlVg2Qud6B7ex?=
 =?us-ascii?Q?xQaQ/G7aMD6P2k5DnvvZv1k0+Kgua0Iin28wKpAwOrcsSuLALluquChMQmr+?=
 =?us-ascii?Q?8qwZamFavpFusDCYOKvEh9nKWNECdPlvX9FeUIbNfaH+cweaD22EHVEErKeH?=
 =?us-ascii?Q?DQ8YGtOnE4PeVw9wBpDCcrq6XbYNxolQVY6a/z08tP8pUEgTlZRw0EsoHtkJ?=
 =?us-ascii?Q?v4ekZEriOQrl68mM/3bYrMOvaPHSdRtaSb0Tj8pB7PNLQhQQn0Rr3/5mojyP?=
 =?us-ascii?Q?lREmn1Ktkd18PHn//9eVGnSLuv++FKYxjNgJen+5xsGuBbR3nsIeoxdKFRGa?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IYcBCLtB590se5GYTnRXdm0NAXbfQ4AFroxhRPkrRFP1y4veOdwCtJrqdD5BZifitf1TTQCSh4jW5TKfrXGO8S366tMrsYIdfKiD25SsIzxgkV0F6XoZ3Kk1Mwa5y6vWjlrAcI83CsqNurMd/16iq13OeSIO6wx9AAz84ALAFwdbpudWSqkXfVXbojFRO2uT695HSWHSiIWvdSoyZotq4KtkQtKCax/20WkgEfzXk2MKbTjEuA4tlutA6SAIORTwPAOPDxAY9lo/BgpSsHUY0nfDyAtFcsdN0Otp3v9AqHYeUvcqzQWjr9B5ecchUu0Ms3pDauc/Jja1BMn1oHQOWnWeqU8KZMb6Q7FBsQjTYEYjVsP9jxVw3hgqD5eAGZ6YLR3jfisf25oIzy7n/gNtVEe6SBW/dJieg3Y18nFU5ef+3LCEH10htpc6RblCKEhi5bxSFneiwh7yeXAoYi2BlidomEh6lChTs4GIn5DSlWrFrXi8ydZ9iD9Ne0hih2YeQKEU2iT4Zetjo+ZVu5BZmoC/Y2XwEHtKfOiI6pOhim6VhI+/jH7Kqq0M0OyFVibcLqeJsdQCMZiYnOuJipsgsdUlYApdlONIkR1vQfwVJxE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771aa72d-ea75-48cc-cfa3-08de1774354d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 05:21:42.1700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kyQxKagMVikZhu3Yx7FdaRYFASmyQSDpgenMb+vBGEbEBpSszz1wKvg3SaPnBEQbug0+ScSyD4xbGsqdIPn+xdkKKYnp8yPYV/HcPfmHu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5663
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=987 adultscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300041
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxNSBTYWx0ZWRfXzMMI54G48ncx
 BI5DcnlSFzvgkmyMAZaQ3+lFEIkYoD5ge2joHDLmKnrHS9C0i8S2ulC1KzjfeqjBdMisXXZgx+0
 HxqcYLbI8tEDO9uLQqVCQqgqlZll/zr508nu5g+8HgQPF8oV7RvRpSWqvOTvTCm3muTyz7c0/OQ
 4WElYRRtHEwoAys/cKzGDO56M0Mb+k9NxoLfi7OPcUNmS0JjGMAu+Cwxwdt1lqmzvIsvM5LCo2f
 Rp9zoa/ihki7JY7zZi6yFNjwj0KQvgvsiJY/jZD+MYtb+2qc3eapNoFCac0bt26nvUM6Il4y1R+
 LawumE6orxpRQ7Vw3CHu5llp2dp+plnhmprt4iHOSaGZwp1WBdeFCbBx4hwCDKNm4ZvqdmlN/F6
 +h2edx2T0TxE3fy+bLqr4yiqf4i5hg==
X-Proofpoint-ORIG-GUID: t7ejIM1kHycJs-GY7JxUHvTUnPc6UgKn
X-Proofpoint-GUID: t7ejIM1kHycJs-GY7JxUHvTUnPc6UgKn
X-Authority-Analysis: v=2.4 cv=KaXfcAYD c=1 sm=1 tr=0 ts=6902f5e9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=t-jbfmeGttQue7XU7YYA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Stat-Signature: sw3xm6a5t1swz7suj9na5j6iywx6qrwk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5C8E40009
X-HE-Tag: 1761801728-297980
X-HE-Meta: U2FsdGVkX18OL5MnIB+4z7z3dW4ZETCLC/yH5i1mhF9FN4+zJSPiwzGKI4l7fVGOEk+3dPVMjGzHpUBqcPI4rULaVlTF47yrt29wBusFPCUDiy7+eikBh8WmZsl0UAziREg/jvn5cWvTOcX8MNO9NAn+ngK0MI8mB1kBmb2ZBM9vdwdRvhuyFsgIZzB6Y1maM7RZMF92pe3BPOIcTEmCEaHG95Vl7Xt/G62TWUD9mUm+siuAdrRn6OtqsyNbrGQT5OMvickRH1haQ4eJPPKc+nLn75Po2k/Xk7QrQIyLlGaxXvJsJxOMj3lOolzBgbICG3MoRtlSloBCE5gvf7iWCmrslmUNf8m/cQKpSp9DEiDiADS/jJzXLdwqO0vqSzXhWAJ6xs9l/bDs6eunf+gLy/BfvBGWwdMDZWjAjsWWXqj7GfSpn7/gjj7zD7kpTe4ILhdKfjlvSRdOJu0f3McLwAwdZ0dnB1JVKYjywRcAhhpB6PFGwEhixGOzW/D8qpAVDgJry1X9LBtceKbpaWlWTlrjiBuHlwiaBc0dZKO9as4ViF3+9UemOYdfCOu0uhQa/EMeqqyqFRv2NHlUD9BSNccNOCdkVi/bd2DqcE7g22J4ldiNX67XrJ+YW4BYgW7XslaIRLx5Ny/Cu+A1Sg/uLDWcir+lEhiMVy0St2iVN6mVClquXWDiaXrLraH6L5RtKLR5wChneG5pp+hQ0BoYdm0ffK3b+z+GpOk58pEG/ma9RrreaCwcQXk/7l9ojatGkyZh6N4jiqEJG9MNwl/kNASom8ZJWhxNph6idBZVzP3QW0nESx7MQgkENbak0BtH7w5FB/IFYl8GW3LIZIC9MdQ155XFqfFGIQGEnHrWSXYz+jkaeFF91Oin5LQm+R3RXFfa3YnKrXYAwVR6kh6CLXmLa+sQMGKXZrriJWIjwDJsPDlKxys+RAhi15TzFgn7pHVXKbVyPzUd8rogcK2
 Hal51ZoF
 +IjwybWeFAnQmZ6q+L8ns8fRyAbN9kxx+uFqSoGzt+UW6/WQ12u2bsPOZuuC+LU6Fbw7+sTj/HkB7oI2X+ucKogxg1jTv5hgLKl7sVOxn8Z+7nUsCAFME04J2M7ySKsar+9ajxCpK2IXpHOW4cQzpwLCO2bZKK7Y/gq+yzgerkA2LSFuN5N8BBZS0vx3ztLZBirpd+hmF3H8vc8a764RRxx6TTN9/UvMjQ0f+vep1G+EGf5xBup25QjYvDUweNjaSHq6SQW8rKfJJLnIWwNkjWtsoYW3lTrtojVf3hYqwKdM2L03fffMkQtWhIp3lijCdmVveU4J5WKBcaqTEo2WL+z4TcaBFHXsr2PBsLb3kr0/I2GD/C9nq7rs5lEgwDhsoe9ajJ9znpTN2mIyTz5qrRD24tcJtxZ0VFaD9c1SLjw25GI0r8IwA7e8zaJffOqO8ff4GBfYxi7qcadYhy6MnA/u9Aa0O/iur9mJEiMNeURaJkvZuIVmHAAwYC9I8pZWd2oVpIVkEVeCD29ax+TtqZmirR39TsJuslihp7yrk0OUSUw8LyWiB7Ws7YdWP7gsQgkZFOs8wLSoMMei5ny/iuE9mzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Borislav Petkov <bp@alien8.de> writes:

> On Wed, Oct 29, 2025 at 04:26:38PM -0700, Ankur Arora wrote:
>> After this change the only remaining functions in x86/lib/clear_page_64.S are
>> this one and rep_stos_alternative.
>>
>> And so the _orig suffix seemed to be a little confusing. That's why the
>> change to the more functional name.
>
> No, as said,  having "clear_page" somewhere there in the name should stay. It
> can be "__clear_page" or something along those lines but not something
> completely different.

Sounds good. Will change.

--
ankur

