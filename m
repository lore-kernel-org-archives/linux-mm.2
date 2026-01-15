Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B62CBD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B966B6B00F1; Thu, 15 Jan 2026 14:38:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B601E6B00F2; Thu, 15 Jan 2026 14:38:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB8A6B00F4; Thu, 15 Jan 2026 14:38:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 618C16B00F2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 285A713AD7A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:41 +0000 (UTC)
X-FDA: 84335210442.26.B700D1B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 950EDA000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="St/c/IHw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IRz8JLP1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505917; a=rsa-sha256;
	cv=pass;
	b=EwWz4f+RsND7zews8NEcrkVl4r+/pHMdBf5pojg+eeMWgXm4lJf+ugNFxnzrOoA40O14XG
	2qS8Fk/AxFG/bnRL51tQ/dRSg+5a15Azoc3Hq/zZ3Hafo4dLTI3fymOHRyjKPNKQj3XZp/
	eDsLNCrEGyHKUA8TPsiw5a8LH6tVRAE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="St/c/IHw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IRz8JLP1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Zdsmbt1gZXW7BPihaPP/9BjJd+S+LJ5uM30ogdiMPY=;
	b=ClYeWfwvrUuAVi0+llRqyDjX6OXLLat1hM8Ej/rrBETXI6S4rifWx6ThfQLUGNoJps9rPX
	bci0qVOqLAVkMpykyzVoxWpv6krZFQM1yYngivp8CeaT9a3j+nGUGeZpdYXfHia9C4Amqb
	estDj6YdZTnNXpABJwa8QEZcsAozurQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FE350j2753710;
	Thu, 15 Jan 2026 19:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7Zdsmbt1gZXW7BPihaPP/9BjJd+S+LJ5uM30ogdiMPY=; b=
	St/c/IHw5+EcakTVN2BKZsOgORfV9NvDJUWGVMKYvemdLgRJyWuLT8agNPTSmEdN
	D2b5lY30picJfmFBZ55GSdVnQRmr9J7srfadxMmW1u52qqV7sqh22633/oJoZHQz
	O5SCxD5ZfFMMgr5bWPY60F3QseroRtuJlQWgfUvamgk887zaaqoF5XIEajgen850
	Hp1F6WjRJaUwDdJlmqgtXnTsmRrICvpfkL0ZBQGiTFX48kAaWkCvTGKdmrUd6anm
	ySSnk7byswYFu+3kn1Qz+qViUb3H+kA14zM4JHy5AsZ8nUp3z1qIzh1235Vq49ks
	UKH7T/fPNGy6b4GEwzR+rQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrgfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJbCBP040448;
	Thu, 15 Jan 2026 19:38:27 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgmdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+svUJeDUSRCH3cNthEvk4uoKRxY/Dk2GFnxUR6VxJ6JoIUrg+EFiPzZKJ/bS56c7CmKwrEtdbkCR3tufMz2hVLADJ8ymfR07qC3SBWh9Gucp8yV1OYef6zaBRfk99V+GWXD3UAuIzTtcO5Pq2gdZWfcCGg3+UHC5XbmscM35BcDEX1oIZ9AifKt/QwPrj6LNViY/i/T8iEJfIba6g/xrPeRz3yOJfHnu7cjrRQ1iEkKktRqdsHhYBnyax6Iep8XfQUmWtONuCESnlc57locrYNxJPOo91xe4sZyOXLiOT2kiDnrAmGV1NRMIsY03V3VytIkEvK/Qp0ROOfD9b364Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Zdsmbt1gZXW7BPihaPP/9BjJd+S+LJ5uM30ogdiMPY=;
 b=yAZWJvSOdSbv+xYOZi/Mrv20EESVHZWpyY241nEOI+SBF8AAaN2ZV7BYns6XH3v1lg5ZlPJ8SSnv9UFvS7mSMqw+mPCGct6L9xauMb6YHLZoSfug8oIoGY8yTh0GRTruFAqG3BVCZTBI9kfNN7eYsFzX7WZxoTV1JIQTfIN7vgIN0GRjBLepVvAcY/HV8C8ENMraykTyJxP4GxQ4Db7bX3UzFF8AiRTZvRzb3e6IPCmtsFI9y/P+c4jW4K63/Z9maA7wWkF2Sm+RDwxTyL6f3iV+zucDbC4Qp4Hbr8qNLN5MfqyOcsyE/mr0tbQjlRh5erF9Jxf55+SwWzDZhCMHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Zdsmbt1gZXW7BPihaPP/9BjJd+S+LJ5uM30ogdiMPY=;
 b=IRz8JLP1teM0J+NH9LJ7l6K9AKCqFsW5nh/cv9Mwqu4e0DhY3LSM8HKS2XA3Du5PSyWgWHGIiE0loFCRJ1ruossT2jMCdVHADbX4QaFEhN7M5Q8i1P4CPbUSpLWyKXyw0s166nWZyAf0eYaeuPIYJpVKUmaFvI1o+vsguRODiZ0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 19:37:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:52 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 24/28] maple_tree: Use maple copy node for mas_wr_split()
Date: Thu, 15 Jan 2026 14:36:43 -0500
Message-ID: <20260115193647.1695937-25-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0123.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::23) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: f34b719d-2b64-4f14-b7b4-08de546d92b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4leWszX/QU95Ttr3x9/K6iyW9Ky4KXACTEYQ1WmnEb2E+H4kouyYjzYeJBR2?=
 =?us-ascii?Q?Uq+yQRsbbRWOztnOnabiegQrLSJ7EUMZJPHGZNltf62ngxt7Wkqh5OmBt135?=
 =?us-ascii?Q?TEXtTtbhmn7Nupo/S7XkF84VW/yzSGbbJHlFladrmSGk9fDOXD2f5pEo3MVJ?=
 =?us-ascii?Q?2hBXds65W6LmKapd1DfWTWvHwE/8N9UQ093F5mMortP7ELPc2HAmwbOnc82A?=
 =?us-ascii?Q?AYNg3b/98JNGVIFLpUrWkv9nh4JMLuVjlRd/ymWj2lZ+ydlyQnHL5Lui3SQi?=
 =?us-ascii?Q?kw0SAAl5kerxhY8s42Y3yDcGSQTPW4VTUaWAeMxuP8+cCOEwY0rWH567Jr/b?=
 =?us-ascii?Q?Pc2Ta3LA9RYXWE+t7Bgmovgp8c4oeDTNTEYg4IOIDRVBxpnrGVPtyW9Df093?=
 =?us-ascii?Q?esndbOhIY9x4pqQY8z9rgKDhwrwHXXabxbQj6aju/+CLlpyu3IuCpQ0b9bzW?=
 =?us-ascii?Q?vZRNh6pSKxD+K51ibnukjbe52lrJbay2pkG/XeXk5BygG836tRt2wJtIx1il?=
 =?us-ascii?Q?Xklk/GXHxdNJ7yYrSxqm9SWMcg+QTu/47zzuTuUczFVcFjIcs1a+c7jEUS0K?=
 =?us-ascii?Q?KWQ/6m+9ywrKDmDhwi42Zhc68CXQ1/a49FKf+HfaleWemK0GNlye5zzf0rCH?=
 =?us-ascii?Q?t16oc6Or6fv5x6xEbDR5RVF32UM4UcS8A2gIpmNZAg5aB7747+RGjw54sg91?=
 =?us-ascii?Q?0xszjY9SsNYKxVTK5EsYm3edbKHQj9RGmDlkE8azfRslxVOlUFCio31UaDId?=
 =?us-ascii?Q?mn0WrTVFoxtL6oja4n6hnRm1oMAVx1AbWLCjh5AYwUsoZXTU9K1aJF6LBTwV?=
 =?us-ascii?Q?8EQm12YhuDOcl5g1Drx/b3XJXhkiPN1p9TAJGJyAEGDFb598iFKx+Y6SNsb5?=
 =?us-ascii?Q?115HG/OhFUKyXaSX40TJISCebMfOPSy7QSaRsMv6/99eHpapCg9l7NxRNSrZ?=
 =?us-ascii?Q?nH89sUt+cflcT9EPwOQ/UUvocUdzOFr6wBF/U7m5cpXLQMzfoWmJ/gb+aR0j?=
 =?us-ascii?Q?t1tztFPx/CNjQPzqHfH1mf/lKjwCTZ0o+tXruqfivKGVSJ12LT/bC45uSNDu?=
 =?us-ascii?Q?YujqZvyqYsNp5yStgVuYycmKU4WL8Arb7RTK0VnCIjTi0B2XA3RWtSsSB3VR?=
 =?us-ascii?Q?hosszYyLg8zxA06sqrhM8raFGTEQtGHNxsojA+1us4xZKMGjcqx4hUn/1D5D?=
 =?us-ascii?Q?FdTIuHz4sJS3Y55eLrYgdJtElfCOlaYElg5/airJxtkJjMNw1NYTNFfWmVce?=
 =?us-ascii?Q?QXcruGKw/6fX+lypQ9JkRAeTJI2Vxj8SjYdr0lWfddkDlpyWmSaOpeISfeip?=
 =?us-ascii?Q?ih7+R9t/cfu3Rr+X7/NZQpoEAXmHfcmPgDltzm3iF/SLorsowiSGgdFFSlsz?=
 =?us-ascii?Q?VoZYxjRTwWxXHBe+snm6KZWM4uYLu3XK12mcKfyUtqtx/cAKIJuPlHshooxR?=
 =?us-ascii?Q?Jdm0eEuMV9ikZH03o2Iv88iNKkkfM7puur7dnAT5amXj/69DSTta2n0bj0f9?=
 =?us-ascii?Q?kSr0A5EcH2Xe7+ha7E37p3gIAxCPHapnIaI9SD+bF5p47N1/oW6J/oVP7Nwl?=
 =?us-ascii?Q?5NEIQTvWPyRLaPi7ai8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x0OFd92P6uNdyGefLoyUIA9CPvn7sR54bOb++MK2sHa4LOZ5EHmVKkmiC906?=
 =?us-ascii?Q?zEr5hqB3LWA35OQdBR4So2kH9d6lNgtryUDQfDpsmv6rEWWPQMQqjuhoQuid?=
 =?us-ascii?Q?LZ2AaNmifKKxOgrGaALNxYL+UMrm6i8rdLTkw0UGB/20dPeJK3XeHTac5Vb0?=
 =?us-ascii?Q?A2uy6baqwUXEROj9iy8iM811krYuJ5kelQpaQaz5kO3iYa5dA57sWpkEKHWI?=
 =?us-ascii?Q?tiEiAsasVQklgRN4h6OrrlEgY6JRD+BGpQ1MreF3B9TNEL9/Y+mOSSfBduan?=
 =?us-ascii?Q?F5BrBjQmGgW81cxbjrk2cLjWJRjhrZR1csYDt4Kl+6LuMcP0m2WtNRziYk+O?=
 =?us-ascii?Q?XrCWqZwpjEsLBHGYWjsiTINk2GK8kO4cCeATc3pOjfFSkSgwvub0f5LIkROO?=
 =?us-ascii?Q?7pPVzVnjhanAtRy1gYE4ZC/P9UUOcDE5d5XKmZYqyR1qO/r/j7mm/JTmxpM6?=
 =?us-ascii?Q?3jwDzQdvapG0YWvQT2rwJMCHqi7VnTLPrIJotU0Gl8+4bSVQuQZIYREpAH49?=
 =?us-ascii?Q?biqcFeaNk36lIq9aJ48q3eB1YX8p/1bbWwkVdZOmpMm19x84ttWomPWqvtL6?=
 =?us-ascii?Q?eUfgIyQ5KrDbIoNJ/Dd1IjBX1O37I1caJ1lco/aKt8FqKXAgA3QqhgT5C9ad?=
 =?us-ascii?Q?EV1mfBU9YWRg6y/soPuyfEERUyt3uIQJ8yt4ZTmeMv70HasbUP5o1GMq+uUo?=
 =?us-ascii?Q?zqJs+PAU9r+Wwp9qd0vRfrRXvFYbmr1D1NPyC+K9BcjGJj+WhfFEVtOlHSqS?=
 =?us-ascii?Q?eI/AJQYIOfOOLzm2vkHg7r392uln4KDQLndEtCCVp820KIcxcDBWtWm7QjwX?=
 =?us-ascii?Q?1fqYRGNSnot2LBVbg9NpjY3aQUThK/htlM6ccXWuivpU6dwBYQlDkpbwD0/2?=
 =?us-ascii?Q?al+i8LrMgmxXDHK0RuBAzhEFY/7wL6bX5NuQV6EL+o56df0t9EbmGCOn6VOa?=
 =?us-ascii?Q?ZLrdMYLwyC9egxTk+4n3c7+sLGPBDTuxdGXILpcQLJ97/XQD8N7hh4jjIwyf?=
 =?us-ascii?Q?yWJmR8NNCK04Hg2MkCKJkyoebqpu0r/Cwr/iQpogTdpQuiVCEuOazJjRZ0OH?=
 =?us-ascii?Q?BhjhbbQ8BX18wXjAq5XJqoqkx3/v0dDD2kUtRN+ywjYwJrS/R6SAMWQ+/16k?=
 =?us-ascii?Q?iET+Lxq/4iCx1EXDbZhssvf9lRvmCOfvnX1qM1E0fmhxhNpXBrq2+j5fApm8?=
 =?us-ascii?Q?BtMoaN02Htm1CNlGU2y2G5Z5qE/mfdQcv2H60/rAGCBVzf4hsAhl799DskQq?=
 =?us-ascii?Q?sXS+r+HVW3CJ1M4069FK21gBEPIHQZnybd+OqpuUF1fMSAmGBlleOCJU8QLR?=
 =?us-ascii?Q?OiMs/SE8r8426TEIlZ9yCfxd7Yr7qMou0I5d2+WMRsF0rx2ZGtHPAxbGbZOh?=
 =?us-ascii?Q?WT9XU6OD7RaaFP0R1Z7fmE0HmBsrVlqrxp6+QSwY2kWe5gfN4+9emeP4z/gr?=
 =?us-ascii?Q?AHhpDgdNs0hUFyjAPe/ZcOGkVyCUvR3gogR3G4q14je3Jn8LschU4lB47Pn6?=
 =?us-ascii?Q?/FQAnrHoVoDAu09DCYFnZ0zuvscDkDMfqqxqTWVRa9LJKtaOxDAWYCx7RQn+?=
 =?us-ascii?Q?4aMsxcQPmtJYZJB7BiX35ug3hIvzabjvQjOS7/MnqpNWlXH+hMGS71hWiCFL?=
 =?us-ascii?Q?AfFbczOHBcjiuK+S+oOj0zOt7+P2j17BoGyzq70zcWzwIWJDqcekPTWr4DHB?=
 =?us-ascii?Q?E9wph2i+adkQVkc9YL1iIRSyYc8VwbIqSYJtCtbPampsImKO0VK7TZmUaEoa?=
 =?us-ascii?Q?nh7kZfXLbQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RXcJX2cWx8AjBGMzivxEDQtk+TsgWc8YJl258I6RFTEOKyRC6QBAeGEWZTvs5ylVWenmXulyu02r7CNNP9ifu1LszF9ZAjk0MNug8aKdSy8DgUA2qNadNE/nt7U6alWfIqB0yDbFNQFJX6ma67lOPeEwzlSwWG6KRNT5I5iEaL8OGFXRgG//BBg0Rkbw7hIu38LHVJeyL2rqSohWa6fubBoglDNbE9jpxGj7PlE9xFS9oNGRvpNtPrbwKmK0KtBDReDQpqneFN4ssPkDQ1e+T7hYwwCesH4gir5fQ8xum+PpkcOyNbJ17ehW1jw/NnZHqoPNgGD+yyuDoh/FoZoyuF8+fy6Tl3ISV2ARKhNGChw9lxw9NOwCPn/hJ7ug5BNKiJIEtHbthGTDE/rMKQyPYr7JYuMdOyzdWUs7lM5tUnx2ArRTGsHLwhk9XHtLp48FAd3duq4J0LpaFfFkTQ4bjKBHPr5yUlGOJUMFsYUDzMn+T6ITxu+SCIscBRVtMnyzsuvjEVQKJRIcOA7XQlk2LdLxLdsKmB2jQwJHTdnPpsWMSRh93qvfUX/LNxmpkJphtqP2d/Xu7CvamYZByCMr8XeF4gmdk4vMZzXCJVAZ37o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34b719d-2b64-4f14-b7b4-08de546d92b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:52.3908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jZsq6Cw59Z6X1v/iY12Gozx5X8gb18Bbp4B817s1Fgb8aY8jdGApNM9sk5CPdXxlvZdZbTgU/6zaL6w99LJlDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150153
X-Proofpoint-GUID: DPmJ-f9FCumMkzePQScSQjinRht70-Gk
X-Proofpoint-ORIG-GUID: DPmJ-f9FCumMkzePQScSQjinRht70-Gk
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69694234 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=tVZdP6cYBDUjvyGzC5MA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXzHX6AAJMMqdX
 rlKyM1X0p8CGgaIX02btCVrxpRAVhDqiASpjiBnBlDnXCdahRHUywLW5chCnWiF8kSLn10WD/1Q
 Mn/sBUevmCujlVZHW4p7aZXftFKY4wrYq+eib/TyLsPmEYBsVWJ6oWpvEzrjLIhBn6xop+ty9xZ
 ETmy4IftJwn9qClkDnLNWW8m0wh0ZW9Wcyz/lOROFHVQOvxfs/G+DMKMv7169moxU9o2AThM1tp
 bVozT4YsWIFp+ow6aRrZdc/p66E51ATe22lOTHjXIF6Vm7MStgBcvyq1Q9f8OgD3XAT5i43Mbu5
 pz39VJwiWmXZc6gq2gbxPrXYyd4cfMVpAO7pUsaXPZ61EP0M2361FJV/NvympaCRD32e5VOa8lY
 lfm+4FSe6yXyyV63YsqNUrlkpHB2PgOrOdnIURJwmAjBaocu21Xe8HY5GzAbf3ywRHMr9gprYgO
 ox0RnHYkeWt8nNlP1S2H4RTe5olDhVI2wocJx2S8=
X-Rspam-User: 
X-Stat-Signature: afjshs9yxctjdankqb6ox3nuuzsnhu7x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 950EDA000B
X-HE-Tag: 1768505917-158064
X-HE-Meta: U2FsdGVkX1+TaedSAJefVmDfeJjDARUmF03dlrZSaQy5dQgfQ8anPiyz7mtO2Y1J9Z4T1Gi6HUOuvcjjW655IL5YauuzAEHfZQ4vZqDyAxtACUrbgXBhc3QlgQDc4X4ybsrduczpvbvhbPaTC+qO/Ssr2feUjnRuJRdxzgnWoxj43sadqH4hDDJTQVobsxiA7o5QHhxq/uhY76i+eg+tbdVyg7GWKpP4eOqMpe1HA+6AkiQV1qNWRgF6uJSeRkbo8Imlw2SSkl9J5pLNnuAnmOVe7+br57iVPbO95o5CDNQM8Ruhye8XmNoFGC9G2B6Me6x5LPppq5HoT8bF4h1SS/+G010deJPAGsSUC4yU6U1o7nBI1arAbRpzfM0GvuOxSc24wFcgfbrw+LhrEOI2/uqekfH7uGb8L8WxsRKOHpahWhil7yXU6GI+CSREHNpfSY7KrnCzai9QPKCBbAaPvO8KV4/Ff+NVZxfvS++FgxnsOlL0B42tRh6EsXa9rt+X6xhaPR+Xlca/5AZ4CZlgj2Rl65hj30oVI7NT8jCHj+Uj9cB/PLcQCx8NpkimfFce+dQgHRf2C/fnbfDFHJAP5llMfynj90JDjg7uUxoipqZLaEmuqiumBOaK9XpZPrI1FnqZ7Vmumd+y3rxF7lTv2o4vtA/I48YTrQRCXo15vB9nhdwake9j8sJDYQRt+0vyX2t3BNCNovDZ2HjoHuksHH5sRA3zGRS9dr0Fm3j3KYBdtIjl+H73DbahVKL7TUvWfYbPubLlbRV7fDK8hbsP7o0KzPOZRaoKDI9LuF+Mk7hEH3TUD4PyWjCpkPbPlaLGz7NRsxi+MmPLbq0JRFDWmcFRRoK3glwy4eWNBfxMnGoZkODmhSNDKp8xgAhSz5OgIywtqxlhtc2CmK+nBG04oFftfpHh4exmdmyIrbot9vjJs57yMBfHse1AfdEoCRZ5ZflGFLtLyqrvjgPuRJ8
 hUCIC0YZ
 0CSkc/tdSmI8UzD07zKHZsKN7FZfq+kfBojXdr6pY9HaRyEDy1vis+McCZoNRhPEqYY8MvYda/E5ln13+g8qkyqmAmtzsRGSQ7FLrnlvqnpBmWSklG3EzrrSlVNy50VcrkLHkQsgK3/r6iuBo3zE6M2r8Wmrc60e7gtKJYV3uKeaDOie4Eqttn80/OdTO4A1ztnTKDi2dBQa7X8zmvOcuviKdUsQe3CY54BJrbt74orXZfSUx9lP7eSUfNRML4wO3Aqy+4ieAwL5Nl2+6z0Gv1UIh5HWeY5duFs9rT1gHACtydVJSMIKtL9+wxeVcQkCGOIEyAhpNzR91MT3VL9SFgVJufoiC3laYArfQXfFQDGUQ3uYfR8ez+1MZ5dK/bc8eUmzWmRxfWR5PS0qLvg/UsWakfBTeVa65cCxOjmn9JzgcxYCn81leBdnUlQG5dN0Dpd5GtjQU8EM05ZOE9FzRyuHs/x0KsHXn+6sK81rnnqi2T+UqVCGu8U5qRZAp07X4x6HHbu0cylCVmdbsOrliWdsDr636KGUYsCjE4/WpRkxGyj3nyvyZM7ipxI3m6d9Ze8ehVWkeqet/s6UMIuJuibGwr1VLfU/zVnDgiISyzdZqptvO1DoTuK6kWFmVjpgToT0Nu42DkjPwEV0A7/xGsGhipvyOOG7+NS4HizomUO1wU26eAZueOKFPBNWUZvJVuioy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using the maple big node, use the maple copy node for reduced
stack usage and aligning with mas_wr_rebalance() and
mas_wr_spanning_store().

Splitting a node is similar to rebalancing, but a new evaluation of when
to ascend is needed.  The only other difference is that the data is
pushed and never rebalanced at each level.

The testing must also align with the changes to this commit to ensure
the test suite continues to pass.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c                 | 99 ++++++++++++++++++++++++++++++--
 lib/test_maple_tree.c            | 55 ++++++++++++++----
 tools/testing/radix-tree/maple.c | 11 ++++
 3 files changed, 149 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 46daa1ef32084..722868812a738 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4511,19 +4511,106 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
 }
 
+/*
+ * split_ascend() - See if a split operation has to keep walking up the tree
+ * @cp: The maple_copy node
+ * @wr_mas: The maple write state
+ * @sib: the maple state of the sibling
+ *
+ * Return: true if another split operation on the next level is needed, false
+ * otherwise
+ */
+static inline bool split_ascend(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state *mas;
+	unsigned long min, max;
+
+	mas = wr_mas->mas;
+	min = mas->min; /* push right, or normal split */
+	max = mas->max;
+	wr_mas->offset_end = parent->offset;
+	if (sib->end) {
+		if (sib->max < mas->min) {
+			min = sib->min; /* push left */
+			parent->offset--;
+		} else {
+			max = sib->max; /* push right */
+			wr_mas->offset_end++;
+		}
+	}
+
+	cp_dst_to_slots(cp, min, max, mas);
+	if (cp_is_new_root(cp, mas))
+		return false;
+
+	if (cp_converged(cp, mas, sib))
+		return false;
+
+	cp->height++;
+	copy_tree_location(parent, mas);
+	wr_mas_setup(wr_mas, mas);
+	return true;
+}
+
+/*
+ * split_data() - Calculate the @cp data, populate @sib if the data can be
+ * pushed into a sibling.
+ * @cp: The maple copy node
+ * @wr_mas: The left write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ *
+ */
+static inline void split_data(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	cp_data_calc(cp, wr_mas, wr_mas);
+	if (cp->data <= mt_slots[wr_mas->type]) {
+		sib->end = 0;
+		return;
+	}
+
+	push_data_sib(cp, wr_mas->mas, sib, parent);
+	if (sib->end)
+		cp->data += sib->end + 1;
+}
+
 /*
  * mas_wr_split() - Expand one node into two
  * @wr_mas: The write maple state
  */
-static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
+static void mas_wr_split(struct ma_wr_state *wr_mas)
 {
-	struct maple_big_node b_node;
+	struct maple_enode *old_enode;
+	struct ma_state parent;
+	struct ma_state *mas;
+	struct maple_copy cp;
+	struct ma_state sib;
 
+	mas = wr_mas->mas;
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
-	return mas_split(wr_mas->mas, &b_node);
+	parent = *mas;
+	cp_leaf_init(&cp, mas, wr_mas, wr_mas);
+	do {
+		if (!mte_is_root(parent.node)) {
+			mas_ascend(&parent);
+			parent.end = mas_data_end(&parent);
+		}
+		split_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (split_ascend(&cp, wr_mas, &sib, &parent));
+
+	old_enode = mas->node;
+	mas->node = cp.slot[0];
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index a182e48b5f5e6..434d8a2fdd99c 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -1024,6 +1024,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	mt_set_non_kernel(10);
 	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	/* Create tree of 1-200 */
@@ -1031,11 +1032,13 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	/* Store 45-168 */
 	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	check_seq(mt, 30, false);
 	check_store_range(mt, 6, 18, xa_mk_value(6), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	/* Overwrite across multiple levels. */
@@ -1061,6 +1064,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	check_load(mt, r[13] + 1, xa_mk_value(r[13] + 1));
 	check_load(mt, 135, NULL);
 	check_load(mt, 140, NULL);
+	mt_validate(mt);
 	mt_set_non_kernel(0);
 	MT_BUG_ON(mt, !mt_height(mt));
 	mtree_destroy(mt);
@@ -1285,14 +1289,20 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 		MT_BUG_ON(mt, mt_height(mt) >= 4);
 	}
 	/*  Cause a 3 child split all the way up the tree. */
-	for (i = 5; i < 215; i += 10)
+	for (i = 5; i < 215; i += 10) {
 		check_store_range(mt, 11450 + i, 11450 + i + 1, NULL, 0);
-	for (i = 5; i < 65; i += 10)
+		mt_validate(mt);
+	}
+	for (i = 5; i < 65; i += 10) {
 		check_store_range(mt, 11770 + i, 11770 + i + 1, NULL, 0);
+		mt_validate(mt);
+	}
 
 	MT_BUG_ON(mt, mt_height(mt) >= 4);
-	for (i = 5; i < 45; i += 10)
+	for (i = 5; i < 45; i += 10) {
 		check_store_range(mt, 11700 + i, 11700 + i + 1, NULL, 0);
+		mt_validate(mt);
+	}
 	if (!MAPLE_32BIT)
 		MT_BUG_ON(mt, mt_height(mt) < 4);
 	mtree_destroy(mt);
@@ -1304,17 +1314,42 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 		val2 = (i+1)*10;
 		check_store_range(mt, val, val2, xa_mk_value(val), 0);
 		MT_BUG_ON(mt, mt_height(mt) >= 4);
+		mt_validate(mt);
+	}
+	/* Fill parents and leaves before split. */
+	val = 7660;
+	for (i = 5; i < 490; i += 5) {
+		val += 5;
+		check_store_range(mt, val, val + 1, NULL, 0);
+		mt_validate(mt);
+		MT_BUG_ON(mt, mt_height(mt) >= 4);
 	}
+
+	val = 9460;
 	/* Fill parents and leaves before split. */
-	for (i = 5; i < 455; i += 10)
-		check_store_range(mt, 7800 + i, 7800 + i + 1, NULL, 0);
+	for (i = 1; i < 10; i++) {
+		val++;
+		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
+		mt_validate(mt);
+	}
 
-	for (i = 1; i < 16; i++)
-		check_store_range(mt, 8185 + i, 8185 + i + 1,
-				  xa_mk_value(8185+i), 0);
-	MT_BUG_ON(mt, mt_height(mt) >= 4);
+	val = 8000;
+	for (i = 1; i < 14; i++) {
+		val++;
+		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
+		mt_validate(mt);
+	}
+
+
+	check_store_range(mt, 8051, 8051, xa_mk_value(8081), 0);
+	check_store_range(mt, 8052, 8052, xa_mk_value(8082), 0);
+	check_store_range(mt, 8083, 8083, xa_mk_value(8083), 0);
+	check_store_range(mt, 8084, 8084, xa_mk_value(8084), 0);
+	check_store_range(mt, 8085, 8085, xa_mk_value(8085), 0);
 	/* triple split across multiple levels. */
-	check_store_range(mt, 8184, 8184, xa_mk_value(8184), 0);
+	check_store_range(mt, 8099, 8100, xa_mk_value(1), 0);
+
+	mt_validate(mt);
 	if (!MAPLE_32BIT)
 		MT_BUG_ON(mt, mt_height(mt) != 4);
 }
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index dfd7099f0d8ef..d1c3b8fd83405 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35406,7 +35406,18 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
 	mtree_lock(mt);
+	if (MAPLE_32BIT) {
+		i = 47811;
+		do {
+			mas_set(&mas, i);
+			mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+			i++;
+			mas_ascend(&mas);
+		} while (mas_data_end(&mas) < mt_slot_count(mas.node) - 1);
+	}
+
 	mas_set(&mas, 47606);
 	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
 	mas_set(&mas, 47607);
-- 
2.47.3


