Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D1AC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A5F8E0005; Thu,  7 Aug 2025 12:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6ACA8E0001; Thu,  7 Aug 2025 12:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D329E8E0005; Thu,  7 Aug 2025 12:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C286B8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:10:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5282014094B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:10:55 +0000 (UTC)
X-FDA: 83750450070.30.EB472A6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3ABE100008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aR3QNKrt;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s3GbDdZE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754583052; a=rsa-sha256;
	cv=fail;
	b=XT5iskoZYj+leg3JgLeMsVKlvk0hC5ggZ26W6cgn3snjY+qm+Lo0173B9tqHi/O7P2fXvD
	IoCMPHp5x2yfo0NoASKoFgmpOs07PmJev6SzHLbQFbfcGU44iwGv8qrLtIUHMhm5/PV/SH
	n1OffkTSVtCRbgd2DDpOSmqLpjj8hT8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aR3QNKrt;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s3GbDdZE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754583052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7hgIjko1rKVbRsfaJGhMV85fr1j3+Wd9L4rukvIJcU=;
	b=MnF651KdCnShflsBhgfTpFSG9uJnxP0QwxYuq0OX5oYfPj8crGPNEZl3X45gzLkFiuxUzq
	D66S0KtpYiF4Y4WXnnhCIBUdkpgpTtVrPb3CrqvyGpiGYRslVHrJH9bQNsDIk7zIUnHEUW
	fzE0KPOw6TGmO+Cw2/PDH9SGz1JZfc8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577F1f6U028483;
	Thu, 7 Aug 2025 16:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R7hgIjko1rKVbRsfaJGhMV85fr1j3+Wd9L4rukvIJcU=; b=
	aR3QNKrtRKy0F++sRJgd+9wzTBfuemFUpufOugAJF59DM7HYlocfSsVSgKty7Sfu
	4qOHdUYKFHpKmVaoPTVPBRPbIV7+buacU8G/ZEdHEQEtp9akro9a7/ygWFecuhKj
	IBeHmVjjWgyGvModGoPRl9E0u1nT24SpbvjEvlcy5rOFd5lMyImnpLH0ZLR2hn6N
	tFLUorMIysw1KHTIOsNU0WcSh73lILeUaGOsDf9uuUPVwzhQ2cTM1BxkshpwFujB
	ivdE1wBNDiDS3ByzEUao59rMWUuNM9ssM2UNZTMhTdNVl8svVj2KqGcBkIUqqKUt
	Pklpog6KxWX5m7/JVLK3YQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvh4evr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:10:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577F8g9I009830;
	Thu, 7 Aug 2025 16:10:23 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwnm877-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:10:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNIlXoaG3zOSK1rZvaT/M42BxoBdmiika46ictTN0IXJijQXUFQurTARY6P01P/ZgmuN3Vj3DpfgwogNa3USE3qkmnpMNT++PCby7AALM2PC6lA3j/9OIixlMfHCB4rnJOgRwS8lrt2Mc1hp3xStETOzquyDOEV6NuH3N+dQ0rj9zMhNcCJXP6SbwZSSRx7+O3BgS1ic72laZbJrg0IWLok1xX62sV35xo+vsdMyKtJgaAhwSq2e4NTsr8VZyG+eCxRVbD/B+BPZCJ9TvKrkOBSafkXzVGH3gOQBZXRUsfcL7FZk4pUnXxvJiSWjdgJ6zmIQkJMUCFZQtFMCRP9SfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mv2TlsmTuQsWePQjocC39uZykWt7cRD5MTtH3yfyJk=;
 b=S7PYapw5gUu4SqDo/rz0w/0pwplvHaW3M9/XbA+nbo1TQH+7Ch8aX6C7s4q4Xt8JNuYnlPucAw16r/blSBOsOTrytHlO1VMFFtEvy2OnQm7WZ5+OBRTiYSxp8T32M0IOFlkHZvnsCQKv7JJWrCeikl5YswBrHNbqbshmWiIiYuQha5js2By1bBbnr4yAR7k5HJSBIDGyJmf3i85cMyOWgXIrShwL/qt0F1JKMZZnRS0h68EmOZrtsHS3VzzzsmXpQp3KzRz3CoOXUJkIOzFLTjcvsKN+lB+fGpWwVk4gS/zq6a43HjxxZ/VnuKN6kKzjsPhfbmh8oGO+eeQSk3F3gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mv2TlsmTuQsWePQjocC39uZykWt7cRD5MTtH3yfyJk=;
 b=s3GbDdZEfVdcTe91RjXH0NMeA6aghFxsyVuUIa3XQtVE6Z16wdhk8mZhb+dpaAOWbeHvCDVJWHn7whNDxRJitVaRF3eLjdojZ1c1jC6xqLLrwOTnL8J2gFoIrUmgLYSkwLImTz1NDbxuydsHgAUUyOZiW9l2isnYGUk1G0Av8zI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7016.namprd10.prod.outlook.com (2603:10b6:a03:4cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Thu, 7 Aug
 2025 16:10:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 16:10:19 +0000
Date: Thu, 7 Aug 2025 17:10:17 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
        kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
        Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <66f44615-8df5-4e81-97b7-1f6a01401687@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <97419aca-af5f-4328-84dc-c97bb73ca1ac@redhat.com>
 <96e931a6-c70e-4a11-9e8c-c5a08da7f512@arm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96e931a6-c70e-4a11-9e8c-c5a08da7f512@arm.com>
X-ClientProxiedBy: LO4P123CA0473.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: da45f2ef-6a3d-4179-b73a-08ddd5cce7c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?T83vIjNxgwEjWkDEpgcF3vcsoAncazD0CeihN2iB5z3OpNx5fPlCjHDots?=
 =?iso-8859-1?Q?RiEP+MQuPujdGS+k8EgnLP6SivHi6QaIN+Jt8tLO6Z9iMLzWPVAUlpYdKW?=
 =?iso-8859-1?Q?z46VBj2PR4PTe5ORpBXWrYae4o8NXjb9apE0q8AzmMS51dcDpTtaQleU/S?=
 =?iso-8859-1?Q?mVelJfAaamMWbSBh5xxdhyjSGToGdcYcFts9AFS4nknRmlYsN4zT+cJS2w?=
 =?iso-8859-1?Q?7Dhp7nd3TNOlU3u4fvVtx/l7wDDa5HL2G0U3+EZP/VMlf3FtBaxDqhZQgO?=
 =?iso-8859-1?Q?uRzc7LHK20Vk5oEO1bkjW3fqLeOnnljpzZHgR/c0kAqRgo2PMgaW2WUE7s?=
 =?iso-8859-1?Q?YBo0ho7+AaApan4htLykYEwTbfkl3SHIkIvek7TfOCZEiv+jL0GhS+Tzlg?=
 =?iso-8859-1?Q?N0S+DHHQr6/SIFIDzSNw5kMsYmfyF0p2yvTzvf6NmZGLwjemIcZxsZT5RG?=
 =?iso-8859-1?Q?BYKYbMVXc6gA1s+G41pZjnte5gGZc/a7bNJmQEK4ppaoaoJ3yFyq08qJIb?=
 =?iso-8859-1?Q?FWbl6zzgfmM9wvXCwWHGLDT/NHJAK8EJTcKyEOoEChq1ImKf4c1Wh+zP5B?=
 =?iso-8859-1?Q?z5mnzq0YtCsc878dGNqMK3CDRt/PWS+hXpxrDHeyZJweskLfr7aE93l1f4?=
 =?iso-8859-1?Q?hupsqj/N7LUg/Kbf/ZO6KPTwjK8lNEWWwvSuqGZ0PbTXsdACS6Wiv2lGGu?=
 =?iso-8859-1?Q?c38qBLuCBCZQJeHsbDerXT5kgldT+tIRDR43c9+d00q7ScemBUmQ62qfaI?=
 =?iso-8859-1?Q?mm7eaNrb6MrDrsB94KhEwblfrdwTjtvgNECb5PRPKxTv0YhvMepIFOml9c?=
 =?iso-8859-1?Q?KzFhVl8thBUJMH1gJy7uFfBeK9LI7r0FSERAeWxlBLOsmV/ssCUXiD4xXf?=
 =?iso-8859-1?Q?uRfptzlfzMUrzxUQacCANura+PTOaEpCbI2VFcYTpXEp7vRPUm7Jo828pK?=
 =?iso-8859-1?Q?v9UBey7NlOuhxprLPT8gpYdALlCMsyp9cpVo/TWi5+N9lmBOTHYQAdUiRC?=
 =?iso-8859-1?Q?3/cbDZapEH3XMsbbCzZ5qRbhb6zFfA0BBV+azJXe8zci4ZM85HRYtjIYzh?=
 =?iso-8859-1?Q?HBY2BQBaKjD7F8Olu+KCSam469gSNFc9h8SoeVHOIY2xQ8+fpxKSHJ6Evv?=
 =?iso-8859-1?Q?T5wuw2HB/ojKRG1WUjF0P2KQEgD46KEa7KrOGO1ISerOnQNJW3cFAjZlel?=
 =?iso-8859-1?Q?8r7BHxfLQd/Twm3qDH0Q8Rdif9ExIlRGFj08gxayLQo/ltYvDfqZYH453N?=
 =?iso-8859-1?Q?ddUbRO+xXWV+OMMFOTsrZfiuP6lL+CSPiU38+4PVPMPeK0fHQTb0VWxLQN?=
 =?iso-8859-1?Q?GyCx2yv0euN0aNuc6LFqbtHaVZLJmyx/0q+HWwVbsHM3YzlqX/vc6UKZl/?=
 =?iso-8859-1?Q?/iDs6ZlElDd2+TntVpXJs+40Hl+IoVeYbBnEN8KO3A/P6mW/vNY76chLxK?=
 =?iso-8859-1?Q?gCUrsxBH+ksBd23H/0+keA/2Y3sXOIcpmtvl2B2KBQxflzjXNlTAxzYVr2?=
 =?iso-8859-1?Q?c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?k0L/b4peqIrHMHCdlVLX8qVIr3Th8J78+RibG3AXCxNaAXDaEnjgRjzcWJ?=
 =?iso-8859-1?Q?tonlNnbIxnjDOzZBjdZko9ZJg7lWvQbIkfayct2Q6Jpd6WkVks3/zW6zUj?=
 =?iso-8859-1?Q?ajiUjQj7ofm+5p5g7OJgVCRGnTOYUDeBuKayophU38zRlRH/ZUfzrjQpwF?=
 =?iso-8859-1?Q?aZJ6Tfdnc8Tzx+nm9wnKU3cdfD+KmoJt/snhPUbxA1E9ySpLpaIn83jRGm?=
 =?iso-8859-1?Q?OemSqCL/r/EQVTbJM3j1y0CP8ewNC347La8/Vzt4x3CYX5FUGeQEIquXKo?=
 =?iso-8859-1?Q?u1M8dR3g9aJqNw/FW7+ZHcXl85V8eSOOzWnz5WT7EO8ldTT4xPpgZrHs3P?=
 =?iso-8859-1?Q?hRrAwtWgGpla3itstEcRnWtm3zwpmwsB3QigLLvvBC3Qtipd4hFecoiW22?=
 =?iso-8859-1?Q?J8Fzq7S7IQcymm2oKQqWJSAzo3yKWSBB4HU3wNYlLchQ9LzN29y6Y9+R6z?=
 =?iso-8859-1?Q?Cq2ZifCmVmJwF+aCvnGzMMjUOxl3OY5IOsGCpk+qmcQtvaKUPyemzTOFeW?=
 =?iso-8859-1?Q?ijieDnOU/+6ld0HWYcb2qLSUMzaoRep4JUWg3xFXWNJufENnTMrcNo/7bL?=
 =?iso-8859-1?Q?d04VJ2ieDQ5ax+FsSCF5x6TxEBSMXhYKcxWINg4WH22J3GalScYrTf8ll5?=
 =?iso-8859-1?Q?VsNRNUY7fHCnVxmeGBspzdjBR1+vDeLaHBD58wZq67JWclX0zqzch956c7?=
 =?iso-8859-1?Q?f3wljX59gX+YaKjKNXH36FPCF4+6FILLahj6aQzWy2q8k5ozWnehV9ho4G?=
 =?iso-8859-1?Q?mVtAT5wgHfZzLbP0TX1EEblceUmTPU0rf3MJldt0weWt5mCuXw6WJIgmV4?=
 =?iso-8859-1?Q?UA4+HRFtmMmBxZznCXiH2yB0+T8KVNCSrvox14MXxvc8Nh2otKiFBfBB3b?=
 =?iso-8859-1?Q?Fhua0Hio3GdAVEn/ghr0ME7XmGQ/xUBB9lHarBqHZ8SHL0YrpC9Rizl/gK?=
 =?iso-8859-1?Q?2fY8zFbmbYizGCmPoDd6JmlrEvOGD+m3j18nnVvQhQ9L/Lr0OxoI2jlsPN?=
 =?iso-8859-1?Q?3qIQ7+Qru+RlqDqZpwILdPs8phL2TsfUx6RHwoC3OtkXyetrs9UOxGkGAL?=
 =?iso-8859-1?Q?Wkui6iCRQDY3Js4FKAXK8D0Lcyiz7GlYT4ci+KAAVH1Gbd3+6W8bbJ6LW1?=
 =?iso-8859-1?Q?anuaSomq1YQyZ1hEIB8O95G5RF6WFgnMNaxjPwmQ+lz2XgHp4oUkKqdnr+?=
 =?iso-8859-1?Q?DMUWorAiQ6KFmTkAAmtjpPEAjNdljO+On89smSjI2f37jLlQxH/Oeg4ldH?=
 =?iso-8859-1?Q?Gs+Mdt11uaUNn/rJqMooZCew8+ItOnFFXLW9QJCM1T/7OZVRbk1XOk1CMa?=
 =?iso-8859-1?Q?8KKtoVtYbBXY7nZE1kbcMvy6+niwaT6gmC7Du5P7jntVyx1PrOgXLUnwoQ?=
 =?iso-8859-1?Q?v21l7Ap23fIn5mCHhFRj8C+hTBUMhlYsCS8RAIDmWFG0UAdY5PAkb0kFQr?=
 =?iso-8859-1?Q?hmfnToVxRT6LpsDZ8j/jkdexLAWgNR39BNeJAAu7McpNmN04P2Vkc+WNW8?=
 =?iso-8859-1?Q?f2feqo8NmcDUDpgpdM7rqIEqwqtZbKNb5AKQRxMANZZ7ZATIC7FDMwsDAq?=
 =?iso-8859-1?Q?ftIFuxra6TBX72iWMIJLA3Io1CHfprowudCHy5a4l+O1zlJVTfl52DbNjK?=
 =?iso-8859-1?Q?SHf6RD3R/rGobnm/zaN3rEHongY080567oS3n8CNKD2lYn6nDx39ucFQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X6EIXlJe5awmw5i9mkXBDc4YwQLw2cdBYeJ5hfrhCw2WRXZYrNF/7zDSse/wFhlN/xAq8kk0NEH4cyF2xf9BRX/128Tx7vlDwj99XKtfTSahxMvlzYdrDbOIcPxLjDsRfCKOvmZ/ZVpqraqYx2xkepjTVmiLe3EmvzRNmfeOkEOLeyACy8dxfu4naPZRuirIFBn3X1ESyf0Cqlh8vvFuklYImWYnCLQoOcTG1v82QkIKQP42RkuCYvkPmKl4dWJhYEZyifaHyvGtnQZggoLqpnCUMZCU0CcAUIUbFRv/ZMgEJ2OE67F5yaPcUJVL+aiGkZ7exPLI9srvVa7yvwm3uFRhtVepN0yEa1Q1iXeBBjP+dss7g6nPWS++P9KRQ2TOvpUY756UYJSTrt0pBA83pd743z3bbqQfYkcNlffvM2l+PujD1ZWCf0UhqJwo20ugjahxGohsLiuvtplEl32xbRvIgA9Wdf4oK1Ec9LNs2zKAbOmRna+InYX0xL+SEpBOiWfAUG7E/7HEbcRgm6BxJZQwMdfFwOhvDAaX/2jQWsq5jPFEfOjhfwBYwTPHGvke6tM+BygiZE6wYKmD9nS4pv3mOCUsGZq3PsatvKSPE4o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da45f2ef-6a3d-4179-b73a-08ddd5cce7c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 16:10:19.5739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHnTtIiqVCpN6tpPfPTObAMBwA08QedW5tLykzMNuc3o2tx8OpL+uqWXLzCkabi6BjotB+fHYXPPnX2wvL6aYl5J7bBiuydENGG77ZQT7z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508070131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDEzMSBTYWx0ZWRfX0hyRz4qEbeCX
 hfbm4IMPHMIlHotj/kCLqV/kqfLFPGEwIUl8S/sYZbLmp2LP92Ai95eCKy60406Dtd38v00Y6xQ
 sqyExjFzDQ+TlX9PW2FlViqnUHR/B4erUvkObEmKgmbxJosvnYcJetx0fUuLNcvZ9xcAKqafR5t
 hn4P+Vf38aT5MPtGERGS22Deol/lQyiLDrskO0k1Op6W+KL32oloCE6kWrRIkg0wmzbZ0Hf1BcB
 FTcLAP3mY4HOGddxeALBkn1muTO7OJh4AxJAIaT0OCeXLbpBB8AzCNtsCCzyDqtODjkEnKfkGiS
 twZ32AANFndDErJqZBQFfX0ihOfJSNMXOfg3oSvHBf9DAUOp/wY+/kjdQLRLSI6AP8XSZx0efQ7
 fs8JHzGP4yVkESogA2kw6Yubi1izPT/Lb9yphvvv8rXw7BNNHFjvEn840xaMS1U8d6Hez6D8
X-Proofpoint-ORIG-GUID: -foTFJTm52I8dUkDc0jG3Uybk_TfQjHJ
X-Proofpoint-GUID: -foTFJTm52I8dUkDc0jG3Uybk_TfQjHJ
X-Authority-Analysis: v=2.4 cv=Hpl2G1TS c=1 sm=1 tr=0 ts=6894cfef cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=iFchp614D7Oui8V8O00A:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3ABE100008
X-Stat-Signature: cq7djgag6mjmmhgog7yur9ymx7fydb97
X-HE-Tag: 1754583051-708229
X-HE-Meta: U2FsdGVkX1/NCRLATn8i4+DsyP5MHNhpf+CrF5JkthnIgZYEXvvl2H6WtpYDMLfo5tOrE1KnADeqXp0hKsup2tv0SI1SJFqhOu90vazu6wsogoamwNlxr2iYtq4GXCpHeVieyyA+fIiGnMhYc+nm2QtOrxmaCZGRifzUtW6LakxY+vNiWuNgXFDyqR0d6NGNML/sNK+fytO3f6n9YcYNrUOXK4j0XRqp1LyBG59HYvCw9WdRWB/qKb89fjp6QPg70MSduhha5IaMBhI8TGMPvOx4DfK3Y56KA3LMgRTxypqE2mYR1A4XdYyY1B/niyfxtccKeK4cKRZe3R50qKoTH/3eiNQOQ97rPeVDPTenId3+iMPWE3y8yzkDIFe+Txk/0ZSm6noCD1WfFBlUHhQ4OFBB36uYgBxTDEc3NmeHSxnCacctRtIGrEHUIpc/vVfGoApO3jN55vHjXvqhGQCPSVzROfz36aTe+6FbVXqrNMpej++g4A0x/bMo4Z/WQFIeYw3PjDsU6TSP5APKa71002DN8vpgMTOvQ06nT2P9L+Ir8oqo08jlmJSh51g6OSV0PHrHi50H0+1VSAyLwC1+27AG6sZYwhfUfp+Wuc3+8oaBdpYbz1Ighp7WgEx8/dgwVBZyzKBD0jdq8MDg17V6vpwdP1C8Vf7VihP8wZaYpQLF2b1EEBlmlRUEPRsMVvan8cHrGX7z4nue//C/w9uaQMQ71jeH2jdyWRxcLZEU7XwGZolceb1Xc4UnwLY/bT2+SQ0Ywmap58fFqONGvjJ5BZ6bcSfcDpBRr52GXldxIY8hO2SSDt3bmog6UctDG/6y5+mT+gZCvmh4t+1319A+REYQJyQmxOj9FCERvywV0w+gwqwdknUpwnUbAfVXmth7RW8khoQJx1kScTVAt72yFU37R+jak/xuf1O04v13t1pvgFT1EcG1wOBiUKlu7hiVIqJvjvUpCv9ru/rqqO5
 s4oz8kCJ
 5ymrnv2XUoDd9CM7BsYXanIMTbxzgsMvENRigqc7T+yInKTfS1zFAcM3GtRIisMTBU4WGA/3ST13luSejPd53xYLB3+m1Nu4zsvHfXi3+DD+rnJDBFr7RP6nJfM0bX/DLKHP2yxnbZPRo6LnbErOj9M9r+EYe60qJRz3H6yzQB2oNz83A2pbjFOEUCkrLpB4ThZZKvzw3qPtcjho4xQpcmBMu5o2WYRm7Ne09plFQdEMeMK3H5URRZLuxZa07zue8LMpryZsu68duXfMxZJ4OHHM3cPYJttAYgajURM1HXqjs2pHfsEw5kwAbh/6zpisgu9qQSqU2wL0XkTH9DZQ6FM6zbKA5HBRPn76qkz7H/d1bGGWgaxXIvRoqkdX1Tglx+GdvptmYRnCezZh9hL47w/Y5cWuJ+vb9nXb1SD+TyHQqDCFYoyhL6YRd/D89N2IAr7g3PwENrSfU/J9x9cROfFYdTkACZl2V0AOFqiRbNDb7MOO9z84rKTz/3IWGkyqDxc83bVL3JULFrGtsO1Q5bvARIqm582tGM6qNqDmFf9bgpU4ObEjtA+myjDz3lbPbI42BP0o25OHeaP1vz7FoeOCCu4D09jMwTo1aY9qRUgJl+yPewKzS/oZLuEoZd7yQc8YDzy2nUW2VtGOhwarW239E2BsbZO8vmRAO3+SUxqr1gqZsmkq++RIB4RhfezK+oyj192iXwd6YxymJpA75P2O4mPbwei1aBWgX5fmsJTjuBqpYN+za7cAR+TPsFPqJsyKlDwNlW7FNgRCMG+kOlX9b2RN2rCzzqSfnHYars5RWbRLgigY1c2hNK40/6SRKCkzNHd2JjVhRq6E2SA28Pj812RBOb/bPj7+lvYP4p0lJFiAhvcyckkkna3Kr3L7mzTvNNZh8H2T0A03y5H0x7nPUVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 09:36:38PM +0530, Dev Jain wrote:

> > > > commit:
> > > >    94dab12d86 ("mm: call pointers to ptes as ptep")
> > > >    f822a9a81a ("mm: optimize mremap() by PTE batching")
> > > >
> > > > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > > > ---------------- ---------------------------
> > > >           %stddev     %change         %stddev
> > > >               \          |                \
> > > >       13777 ± 37%     +45.0%      19979 ± 27%
> > > > numa-vmstat.node1.nr_slab_reclaimable
> > > >      367205            +2.3%     375703 vmstat.system.in
> > > >       55106 ± 37%     +45.1%      79971 ± 27%
> > > > numa-meminfo.node1.KReclaimable
> > > >       55106 ± 37%     +45.1%      79971 ± 27%
> > > > numa-meminfo.node1.SReclaimable
> > > >      559381           -37.3%     350757
> > > > stress-ng.bigheap.realloc_calls_per_sec
> > > >       11468            +1.2%      11603 stress-ng.time.system_time
> > > >      296.25            +4.5%     309.70 stress-ng.time.user_time
> > > >        0.81 ±187%    -100.0%       0.00 perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > >        9.36 ±165%    -100.0%       0.00 perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > >        0.81 ±187%    -100.0%       0.00 perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > >        9.36 ±165%    -100.0%       0.00 perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0

Hm is lack of zap some kind of clue here?

> > > >        5.50 ± 17%    +390.9%      27.00 ± 56% perf-c2c.DRAM.local
> > > >      388.50 ± 10%    +114.7%     834.17 ± 33% perf-c2c.DRAM.remote
> > > >        1214 ± 13%    +107.3%       2517 ± 31% perf-c2c.HITM.local
> > > >      135.00 ± 19%    +130.9%     311.67 ± 32% perf-c2c.HITM.remote
> > > >        1349 ± 13%    +109.6%       2829 ± 31% perf-c2c.HITM.total
> > >
> > > Yeah this also looks pretty consistent too...
> >
> > It almost looks like some kind of NUMA effects?
> >
> > I would have expected that it's the overhead of the vm_normal_folio(),
> > but not sure how that corresponds to the SLAB + local vs. remote stats.
> > Maybe they are just noise?
> Is there any way of making the robot test again? As you said, the only
> suspect is vm_normal_folio(), nothing seems to pop up...
>

Not sure there's much point in that, these tests are run repeatedly and
statistical analysis taken from them so what would another run accomplish unless
there's something very consistently wrong with the box that happens only to
trigger at your commit?

Cheers, Lorenzo

