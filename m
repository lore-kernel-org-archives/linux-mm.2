Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411BACA6CBF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166E16B0088; Tue, 27 Jan 2026 04:25:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1151F6B0089; Tue, 27 Jan 2026 04:25:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E6B6B008A; Tue, 27 Jan 2026 04:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAC9F6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:25:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BF6213C0A7
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:25:58 +0000 (UTC)
X-FDA: 84377211996.22.63FD560
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D2744000E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:25:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GalmdGdh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=znr3aHsQ;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769505955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RJs+jw1rBK9eT0ZwnAbZ3Gno5dEaRSGjXq2MBODZ+s=;
	b=Ks8yX/+vBgl8LithPbQP8ymwJNPImgjv1Yb3MKq2HFVx6ykem5VwP98HQ/2Y5HwNfz730z
	wH+Sb/ZbyXKWGwQnasjiQxrKykqfq56KTP7F2KS+TiwwVk6HPvQ58LlIYxxlUrBhL5Fhzu
	TfutQ6zd1qBjmuxSmJlO/YPe5gsim5I=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GalmdGdh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=znr3aHsQ;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769505955; a=rsa-sha256;
	cv=pass;
	b=XrPhjG2zgdp/2ad3DYgMPdErORg914bd2fRVN9Zmm+W+tJu0BnJSC+hMMYFuOLeyX4LTJN
	aWYAP6jKpldL0EJvBOrOOrceYZmyXQgDc/QAugQDKRKNn0WV0+e0W7tDRykCXdUzssTT19
	Qx6/wf/UjbhubmYC/b7t9638TzcjvYk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60QMJc9T1498687;
	Tue, 27 Jan 2026 09:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/RJs+jw1rBK9eT0Zwn
	AbZ3Gno5dEaRSGjXq2MBODZ+s=; b=GalmdGdhdMB07aotMc0FHqqNf78j9Do5QM
	Lbi3YLMTmFcOPai87bxBP8VijGgCrbKR8y6aqYcpAFmDlGVaAcm5zhbBHQzUu37Q
	Tpyhlv/jUiShF2Pq5ba2kIncd0HFQ7uccPkyXkk1B5cf9OySNnpMajmit+hLbtr2
	guo+Hz7ry7RlTWLPuBaHf0w1vqG3IdD9WaG0a2faftCe8utnBwOCK9SXE6vVN5M9
	ya/y8JQGlO+mFlv4xDakV5pfqRzPD7Y94iSUDCMZKc4hhGQ2H3n9Wxts6b+uI5RQ
	chUMohbNqXLoLWt75aHhwI/kXaZggsDnSfND7xqnzm9qjSQI5MGw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvp4buqgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 09:25:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60R75bNH035109;
	Tue, 27 Jan 2026 09:25:31 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh951w4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 09:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9if4pNpRULRqLC82nLUamwKmEbwqLupuUiXxaJjxhjgrbYal780buFa3OflsOWWVwUiNKKGRMc8dcF3t0l7qXFH5AipQvqeagbDG2wR7KI9cN3roa2lbSssPpNBDcMe3gvEkycKJU0dNgIf8/W3FecFUy+Fxp37zz+So6vPILGpVtL2sH+mM3iUEDSLX5piRBEklikBmt2T++wIADS0Ue1YwDjZWP1tL+RwoV/SgxLmhFZ5P8tDjIQsHWoJowwZ4X9FgGka8nm+pC/QS/0iOqqCRapGuByrchF22GQvVfvjoW74NJXlezdFJo7FDlfgGDOglPytN6BYoNsYkxAlJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RJs+jw1rBK9eT0ZwnAbZ3Gno5dEaRSGjXq2MBODZ+s=;
 b=v/oaSZK83xZe9LneSdfio9UQSPZnDkOs0Ar169E3lBmfRDbK9FDZTTEmaRAEfbQQ7X2V+YjUjbHt9wyGnVNB3T8rIyonG/XefZbvOJvZnvvJKfqLhSwOS7bPvPtN7EVd0jtkDWA46xPafwtrzL0id02mSLGlx4ptYEXK2GbKla/D98W1pwtBCgMzqA6pltpAP/t0acEqf1VDOeqAXvas6QzO0I6kaMoNcOY9iOAYNtbPtamFYLtAs8LLXj1LJqrIiJM5iXMC5bUfrRvrkUahyT3Af9abmEIez8+EqJLRnG6bUnMziPWOAJJraLuvXgGJdG5CHlUXK1ZPQ1FUdyAcvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RJs+jw1rBK9eT0ZwnAbZ3Gno5dEaRSGjXq2MBODZ+s=;
 b=znr3aHsQIaxwBEV8EeesnEkxcz1mYvZf1spDiR5whL/Rx3rRLwABG0xwfb9kC8l/h81Q3L8RmnI7Mx9ry+8oK1DSFzuPW3juaIMBrQWrpkluR6ps2ygecKXgpuelr5OQD2PjGJLg1kaLZ3AtUNQZrJxa4GvcWwNXZjXHu5kBtOg=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by DS0PR10MB7296.namprd10.prod.outlook.com (2603:10b6:8:f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 09:25:28 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Tue, 27 Jan 2026
 09:25:28 +0000
Date: Tue, 27 Jan 2026 09:25:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Minu Jin <s9430939@naver.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, akpm@linux-foundation.org,
        david@kernel.org, kees@kernel.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        vschneid@redhat.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] fork: clarify copy_mm() comment for kernel thread
Message-ID: <d8d4dc93-78ab-47e5-8daf-36fd9468ed97@lucifer.local>
References: <20260127055321.2400480-1-s9430939@naver.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127055321.2400480-1-s9430939@naver.com>
X-ClientProxiedBy: LO6P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::17) To CH3PR10MB8215.namprd10.prod.outlook.com
 (2603:10b6:610:1f5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|DS0PR10MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a330c1-db04-48f8-4cba-08de5d860272
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7/TUTR7SNoJSltkJUqDXN88VMVcxMiwIHXk4VE7IAjyUHwnLQ3kLV2yaEErx?=
 =?us-ascii?Q?iB2luXEe3KE7C0qvqEOigSrgRnJLJqO+oRXdsMu3EUNNp3fGR6/8KIcMhRi7?=
 =?us-ascii?Q?BOsYRUjRNiKFkm0NwNwooByjj48aF14tCWNPmglyknnmY9sZezliCGM/l6Ww?=
 =?us-ascii?Q?F9ZqXEtxIn1365bxO/f48H64l3NtXxUm+TeNdFga7zi8SBm+H5EGDsi3Nm1H?=
 =?us-ascii?Q?KaUvoMKZn1lxcn293IbT1nr0YRdWW55dFKnsFdkgDHxCpzBMmmD5tcWCHswp?=
 =?us-ascii?Q?proUNtvcO9unRIqbv/GM44I6vbPq6KiBd9sj+VWJOPjLwjimQoNK7lseE2Ww?=
 =?us-ascii?Q?8MnjX7FY3o6hlk0g+GcKLjl1PeeilULEJ89mWvyAqTO0GbFP3ItKmpHRs6PP?=
 =?us-ascii?Q?iNt7MNuwd3emMLgxPyas9JxPokAnKYBHOyiChIrq10p62XgR8gUSj6HTf9zx?=
 =?us-ascii?Q?cmt1qHODdjtPncnyIv8xn0c+meK8PIojQCV8F9n8y1DbDT8OYiMBUH/UljPU?=
 =?us-ascii?Q?LWySoJJ3NpZTX6aBLmdnCNbbfYJKAs9lHI5D0TZlYJgCWXZxWLZJFfdbqcLk?=
 =?us-ascii?Q?j0rH5vh2XzSO440hNgHzQP4Uktev35zVcXep6J1SguJKnR4823CxhSFwDFr8?=
 =?us-ascii?Q?DuR3yY/PAT9hWQQagQ0UPBDfU3rWIv2MaM2yLnGOw+AbbW01f2g9t4UDecJb?=
 =?us-ascii?Q?/EtAEmWAy6iQleEu/3sG4IX9Fs7g99WwUVMXeDiuEwnn/ULmUwrQeaH0+xC+?=
 =?us-ascii?Q?4/0CjRnb+jwR5UV9/WB4/xO3reRX9XkZIczbGzgvIPZTYLZ+KAGu/mOIXRKY?=
 =?us-ascii?Q?kFYCyiNdtXJa7eI4bfNSgFuAbwvZABoUHj5Vd15/r+9Z/OFZ6rhQiMGsGlhG?=
 =?us-ascii?Q?Di1xqoGWn3FXmjmgl8LjO0Ct6dyJ3KIpJXYpf7IWoZeDSh//KHJl64rmSAm0?=
 =?us-ascii?Q?X49kCyMJO5Q1KrCnp8ggg0IS/WTCii6SiPEGiD5FF1Tip/NDV8sjHIL2lO5O?=
 =?us-ascii?Q?07JFP0/UfEES0niyjXMHViCr0EhgLJ64PwkA1wX1LezOQ+8BSqzGfm+cLky0?=
 =?us-ascii?Q?NLy0zpFR7TCqJFWx0m9aMCtNU3nt5Ry6r2FzcPzdWm9n1fuwwpgLX4QIzJpH?=
 =?us-ascii?Q?T36gUQXh+yWrEdeBavkn6EAHKsQ7a382F4NlT/V0vz1IQvid6pAjlvp9X+kq?=
 =?us-ascii?Q?SLeocSKVdQmB5ZfiqusyLZjTy8b/UrAg8bqkeb8Ny3A0Ne6EN+cdHD4m5h1t?=
 =?us-ascii?Q?Hsv0PmKSrlpAHsON8DV2xQh65IUB9x1el99ghGcjxu1PXL9balKJgCw0Watm?=
 =?us-ascii?Q?VP/rk/15QYUXQ363mRJrKabI8rPhx+OBdZD7Fmcz3R2tVNXbB5TowNtrB+Mq?=
 =?us-ascii?Q?GKH8ODqf4HNOs9KA35piPLZ/wXjv8+S5h9R5nv11s81c+vYSWx0Cn/jwk3S9?=
 =?us-ascii?Q?pxtYDmjAL8HaJ+AxUptHOST4n7gp8/dFLqCsgZQncztxA4pSbGv3fetKBvSN?=
 =?us-ascii?Q?i/7IuIzEJ74KuRONpDLwBUStC4BxcDr87h/+pHlc8slhBTM1FUziPDo2Smm2?=
 =?us-ascii?Q?9dc5BWA+RjaNErb/QA4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m1ImRlrq1dM2kuDL4cL2JF4F6MX4IcYhi+IHAdwwUqrRYdmWat61QGwO2Ddx?=
 =?us-ascii?Q?/l0nVKSI/s6Ihj1cIt/RrD0to8RtGINLpDPcv+xsKR0+xbLdq8qb/s4z7uxe?=
 =?us-ascii?Q?C9KRqGjgi+XUqtmbjqbi+mZTykouS6t00SQWRiGC05t4VODDkFVOG4RICuZi?=
 =?us-ascii?Q?XrB4Y6AFo8CMGLDSjqDDM2fuP8VZZvu/2fDj2JxxxtPPJNYxGgFABFLtawtC?=
 =?us-ascii?Q?5VDO5ayvzAoUaafhwkYw6dgi3UlYBQIpH+SF4bbzlrJ0SYAD8ez53Wj8/Yxt?=
 =?us-ascii?Q?eQNf6/LdIXf/K7XUFXSFVNG3vIcvYL/PlF7P9Kyb2Jk18BNlJf8kUpU9VLqW?=
 =?us-ascii?Q?9myblVHT8BU2qr4x8e0RM9QNlEampbiNuppKK9vK9aVV9M4FsdDueBa6/hvu?=
 =?us-ascii?Q?rUu4qLHORiLITBxqv3rYy8dyEMSFh5DHDpm/FpQiky43Ieq+A9BAd6cYhwkn?=
 =?us-ascii?Q?sfBTq9aUCtK8vk0OjLtfmw5gIzR5iW/0N2vH59KrA5z5yQatdVbL2j7Hha+r?=
 =?us-ascii?Q?ivspnR9zvKd7yhqkVB8iZ14PiIgCCgh8VAfO/a8NjpCfTQnVu82CJmn9eDFk?=
 =?us-ascii?Q?20g0AstxeLmVDVUePbEvaGVzs0leISkVTmTI89rjk0rbPFl01kk0g0pElGyy?=
 =?us-ascii?Q?rHKEy8JvhGWzGNn/gIeSeoxrGQi7uabqbSx5Ht9EsKwVw5bjK74a4JXe3hH7?=
 =?us-ascii?Q?o/YbFpJjjz/m/TG8zZxOZN8I6SV4su9xOq3tvA4bkQ3dCcx/m6vuVwFUahel?=
 =?us-ascii?Q?Vhkfkgi57d3o1xZ81CmZ5PGQ/eUX94UydgsnV1RafQV637NL4vy4kPPD0HH0?=
 =?us-ascii?Q?4dKMP8TvGsMrZnoJlH23aEwp7b2FgfMBis7QpjMVWirBSyZbcMONeDLrqpW5?=
 =?us-ascii?Q?GT1OgkDJd7pIx5U2gEx2sJFfluvqdeEYKRoapV1qDpuB/LAmmGvsEEP/3Fzp?=
 =?us-ascii?Q?5/6KMShxqaNsH6a1eOLRcqZjC+3BCqurrIhR2wCM+nbopY5i0Ivqia4RL754?=
 =?us-ascii?Q?OSz8m9TAtVJOuHVkkQrDFWHrb0zT+e8M0BEp/Q/PAdUf8V6ejZKhpNiAwE0d?=
 =?us-ascii?Q?SvpC06TyZg6oFy18yOESCh+azYqUX+ewqg3sEqU2Hmo3tlbgSeSAI3XMZvhj?=
 =?us-ascii?Q?0d9inkl81DTwBiRyaxwF/vblU4t8m/RNAolFylzZcztN2jDBvqL6GXFWeIQ5?=
 =?us-ascii?Q?sZQG8+YmSWm+JW3lI1hAUIugYYS7Py0CSkaZgSCrIg7+OzURCj2mMuvbIPFn?=
 =?us-ascii?Q?LZrVJWaK+2zKyc6tjwb0845ItqllM5leTlcWvcIqU9AEfjF8oef27HhvI3za?=
 =?us-ascii?Q?Z1RBHcoM0yAIZK3usFZBlQcT6l5A2Yhv7z/o/G5E1C0ViN6tijQMS0bMGeof?=
 =?us-ascii?Q?MPdezhV5f+wYx6mh6SitUWiFgl+GNo68qcGZ2nlucxoOUnfPY83e9ohNBN6g?=
 =?us-ascii?Q?jbE4aYAVu046lVYwe+3RDjLA7evmzLxFRiI7ctkyTD6ZmOxW5nWS8qpT6LUA?=
 =?us-ascii?Q?NotMGfoUy/Ay/yn2PNOAi8cAdZYh0YrMOznbmg9/QuWTDKP2I5YLAfo1PIu4?=
 =?us-ascii?Q?iPRZSqZCGFph2Dr3mRWOE7wgDj3NO9Cd9RGJDy50DkSsS2LyJ/QQZfGccXZD?=
 =?us-ascii?Q?IONtZINloOWCgLmnYvaRthiQq3Rew5u20pZ6YBHgm7NOtF0nhMSjZlr28Njm?=
 =?us-ascii?Q?lzRefRjjyGavE+AGknTrHx8vp5yU4E+D8tSFzRHfcbDMmpLEo5MBy6Nt9hE1?=
 =?us-ascii?Q?YstXgYhvfwvuVi9kgG0dmMkYMlW9NpA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/PSTHZ6HYmkhbS250rBTcKcOO6meEUHtoP23n2K/6cdK1zO2sruZ53GfGNwS/I5/uSp0FZ/2EKGEj5Xi7jYyaHYeFrgSVkpxSSBJyOSnfSXalwMC0NFRyX8NWqhAXDN93Ylg6BKWCNzTfc77qiLZJ2HjZfy7WIszPLkDs64RQEqUhE1Pu1WUEUGfWs3nfCijqoDlepxi4wjib8oCQ8Smjbrqmq4ZLvtYaP++r2ud2CEg+eIssGMOJ/L3QPKz6Ar4KNWL/NsWrG6OuspdpkhnPWloh+tPaxSNGia3eE7NpdnXXaWXDpLvc9gy3/a3kQR74b+dweRHr2ao+0RV/8EG5StQN/eCJEX6PvGYVRJA7HnMIhTeKPyD77VFJxbG9Sr8bbDW0E3Ukn2KTFMRPY6KAmUyNpbqzMFKkdPWiGPvF0U/6MnyuNE1xsrJyXqhXn6G7quFINKJ/OQXX3jlO+yd73oFNx4JPiTTAcJ9LTQEKVC4cZa1voYzgkr+z18sgt8ypm5A3RgdhqqH1xiz9H0sN0AW/5VGFAMOR+a3eKG3wGuyJ3JL5TqpWgctkkuouy1p+L/hD6OoqmgghPaaEq5XbPhGFUq9xpVm4Io3T/MS7tI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a330c1-db04-48f8-4cba-08de5d860272
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB8215.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 09:25:28.7237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZHjZUbA3mL2dX9j6ragXEo9esB9nd4iKqhx5YPkf6AG/E3dvfyPCHB+Q2AVLVpcoxWZVMWCMGRjDMCgpGHjbSlAWNDt4iST6gC4A3ReJLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_01,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270076
X-Proofpoint-ORIG-GUID: dzDFKtQV3W6BovKQ6gYqiZTEHxqMUkRF
X-Authority-Analysis: v=2.4 cv=StidKfO0 c=1 sm=1 tr=0 ts=6978848c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=_kqLnAfwAAAA:8 a=QupDeeI2lh_Skz13W64A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: dzDFKtQV3W6BovKQ6gYqiZTEHxqMUkRF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA3NyBTYWx0ZWRfX2fMQYfyaXhgG
 0Sx8oZ2KdKSME/fxnDdZE22wCZHuMtcB/gJT2p2uY1K9r2EEiRG8HKXlE/Es/Zc+RhhG1qK216s
 wBEoaHov/fjt6xZ+TzU+Wg/F05GEXvQEuuZr6l/kCNTVBcQaqAVKCwTKhh0bK/OcRSKSw5H945w
 Ta3xWMp8rqeIuNpFHAinU9Ny0qSKKTtX9+Tzeq5L8KmeOJU0bL3U00KTxP9FWUpoqma3FzhUmDt
 VsY74XViURl+lhsYPXTAqOviP2uafDL+KTIFokp+nURS2pwllm7ZjfKy7pNXOBpFVvQgYyVTCro
 /xtDtATwzZVkolcm6SUprR41q3sx3LPdV3HhCYd2fAHaLz6TBfjIKGjm02yNDHCvt4almpAmB/A
 0iwZGFad7HhcPdrk+Ud2alXYpZQgCYHxpsR14JIYjoTuBCIUJPVhLMVqopo1Bre3JsJKwtZY29h
 p9LM1dJOC3o2DGIFSUw==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D2744000E
X-Stat-Signature: ika9hf9t3bztequjg5uofb1zan67bmng
X-Rspam-User: 
X-HE-Tag: 1769505954-496403
X-HE-Meta: U2FsdGVkX18dz+Hc3Go3eMROvSH07NbPlHaomyL4k0xJ7CX41YZ2EbITdBx6LJpxpEvZSyWv65t0hUSPF+KpVCWkpaA/TL/4tT/gAS9Dz4ROIiNJuClHExo1xJlm2b4ATC9bfWTU1/PKN/5V7RMaFF7g/xn5CYh6thjUNSuRn+n1dluoxZbRV7181sSEhZz6fer/aozjvR0B4h0ZCfyBMqwomVf2gYUtBxfo60oAT5RWT/ijn1kZWFVE1B9qBmfgpQGcIE7X0yGayEt7d+ZkHFf4YTsriy4ppSQ8ENbI/qs/S3EU8/j0F020h0zVaZe/XWloVvxZ3CYTlVM5Q2ZlQBq/EH3uBnwEul7hPTbdBQd8dPIEUfY1tPJPHaluNfnJrddR3o5J/kxJqks7BoTDuqgs8w6ArE19LkJf6TfOkEGgV/ZfqkKX6AJH1Q43/S5DvmMVjq6yf2Es55wTVAxP2qGysiSGj3pYMxF4a+0jd6CJQPB2N3va922NJRf4PlPPzaqWNnbX+ST3KNilDS5lYa+4OWs/78zn6wuC8JMJ22YlW3c11bhFuxNC/M3MDdcOPOlDaJNZbweJhWliTX/03AwZn7Xs3PPSQsL40Izp4ObMNguMY4hnVJvupwhQvJgqlgnJNOjwD5b9/vsejHb/54lOg+22Ecdm9VK+9HkMcmhb1pwGOQ8xDhMqcNMp/hE8SrlJY9odu6qtNivcHTptiDTlo+pTdr0Y961kekwnZk1GRhlUdyJpzfCXGCe+wtUku6wlm3p3Yha9Xnt5jWgBU7QE8j/7HkckrSeGPk3MfiHtfgrajQ0hekg0N+q9/7WzRsemZ/XQ9i1Tg3i1tgMKIMi7IagvZIvHbp+JfUIDVo6KaOj5pQ/XHjm5qKibJHJeWh95aVe+lvG3KG8fCcYpjy72b4wJLnsvbQ5ycN/tCD2pJYDqxUOJrufJtkcWOWRaonuCd7T0pBHqXTKheJz
 JHGTgHiH
 yOYR4706SH0Lisjo40iC0IWSagaFX3Md1ccf1+snya00fX7kjcSdXDMOIUifuMK78VYkwGnwJ49Lf6RKs+CzULA56gnfn2193P4/uor3QEUvqm9xEP4w5+S4rt3kAhHLB6FmwCiqHzSb9IQZbh/Xa6X3LlAdFO+kDdgGQvpebH5pjZoitplUhgaQjuGoNELvtrJY4OSyb2s/1uc6MPHmyNT31A5DDW3x8IGMNnk7cfUG+ETN521E2q6j6o5dEv8RhkQG4jKoRS2dIu+xmHRhjn2/l1Q6/3dMP5xrlkmOTevpKA+pCP1j8EBBVMCxpld1x1mdWO/wXJeKvaYmqvJAxgprzLLY7ynppxrKLmmB2wUoAqAyIiTsnM1ThIQKHeQ9cwgeQ5BqV8rZueKHEFvQr6iHMobYKwQ7bIUu9uD/EPCqbuTGGZq2TJo1syxkw/G7WjhQiQuy/BL9VKK7j2+Z5+2ouxn9zlPnZBOrQc6cey4rA2Ic5DGUEmQLxFtoVUWZ1ksX/APfLDEOre/oy6pRb83KH/yw7EB0P/SaspKCNB4myqMOMGhD8aA+d9WytBU/jlg953J0AVJw4tEZLaQXZ2fPYcEM5HIFLncXN0ciRqO4bllrbcOyiC/7pN63cQWIdGChUv3rnw0oPRoo1amWaxBbmnaT29n66q1d6+pY1Adsm5dCjg0vJ+XVzFNLWw5/a1RvY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 02:53:21PM +0900, Minu Jin wrote:
> The existing comment is misleading:
>
>     1. "steal a active VM" suggests this code performs the active_mm
>        borrowing, but the actual borrowing happens in context_switch()
>        where 'next->active_mm = prev->active_mm' is assigned.
>        This code simply returns 0 to skip mm copying for kernel threads.

Yeah but the comment as it stands implies that you are doing that elsewhere
so I don't think this is a problem.

Referring to a specific other function in a comment unnecessarily makes
bitrot easier.

>
>     2. "active VM" is outdated terminology, the kernel uses "active_mm".

Well VM refers to the virtual address space so it's perfectly fine
terminology.

>
> Update the comment to accurately describe what this code does.

I hate to say it but this sort of enumerated list is very AI-like so if you
are sending a patch that is AI-generated please do indicate that this is so
(and put e.g. Co-Developed-by: <whatever>) if so.

>
> Signed-off-by: Minu Jin <s9430939@naver.com>

Thanks for the patch but I honestly don't think this is all that
misleading. This original comment is from 2005 and I don't think anybody's
been all that confused by it in the meantime.

So I don't think we should take this.

Cheers, Lorenzo

> ---
>  kernel/fork.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b1f3915d5f8e..4bfd606004db 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1566,9 +1566,10 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
>  	tsk->active_mm = NULL;
>
>  	/*
> -	 * Are we cloning a kernel thread?
> +	 * Kernel threads have no 'mm' of their own as they borrow the
> +	 * 'active_mm' from the previous process at context_switch().
>  	 *
> -	 * We need to steal a active VM for that..
> +	 * Return 0 directly to skip the copy_mm process.
>  	 */
>  	oldmm = current->mm;
>  	if (!oldmm)
> --
> 2.43.0
>

