Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 105AED4A605
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 07:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A1D6B0088; Fri, 16 Jan 2026 02:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627B46B0089; Fri, 16 Jan 2026 02:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DACA6B008A; Fri, 16 Jan 2026 02:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 384B86B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:29:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B76B6C211B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:29:30 +0000 (UTC)
X-FDA: 84337001700.14.05E4280
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D60F1C0008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:29:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Cibzc/Zl";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fqR7k/2m";
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768548567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjrLOZCCXcrxOqasdE0kfxBLvr1EjRzh4KDykcYPDBQ=;
	b=3mh9b7XRjjQ+j2tF9GtGuNRatVZDL/APvjorJA++RSHRVXLJ33r8JpODMN25f6K99yBK0t
	di1ioZNc9xcI2gUN5BDqTWtmEVem1X3UReh5O+mh6+MIWkhog0IHrV1R9wRelAi2adpz5H
	d3YJ0sAc4GYl11rclDbGX2F14w3/+cA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Cibzc/Zl";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fqR7k/2m";
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768548567; a=rsa-sha256;
	cv=pass;
	b=Frl9dsX+D0IUiE8Kxx2aEDNHNrKP/OpnVS4vZ1qXphh4z3rK+zTC2cNAxNM2e7DUbf59y/
	Lv42hIdcR1sMSoXAQ6kU9efw16JzDxNbb3Kr26uyRsbMixv8VeW5OhBwWWY1je+FbK9xrP
	MpmcadE0GWQqWcgfj34WvKdP9fAgobQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNND0h1817752;
	Fri, 16 Jan 2026 07:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wjrLOZCCXcrxOqasdE
	0kfxBLvr1EjRzh4KDykcYPDBQ=; b=Cibzc/ZlZiWYzx7fbj/YwEcIj17Cjgu43J
	DEYxCA2l+tutEr6tCpxEhYiGtPS7/5xwOrixTgap6w4foapIolNEzO0vIFKvHRNO
	P7YeWxzVz4ceK/QNMZTSmS3U11iRqnrHGxShEZOdGmA980mmu521etrw37dUpQpr
	HwYo9KiE1TWek7jxlyr9OhPr7puZGLCXEBr87Mjp9ZPuJuWbc+Yz4ohreybhExtj
	HB/McdxDED0i8b03MQQvhKfLY3SIdzfz6d1y9Y9mwpvVJK3cne5XWVbRhYYE/lcL
	Vkzjlz4PSyK81Q+loVejuxT5OSpPuT22D8zOI9T6t+u8FDLIXv/w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp4rxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 07:29:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G6k7Fd032777;
	Fri, 16 Jan 2026 07:29:20 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ckbwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 07:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvaQeb2/f+MmahpveHR/IOepMgsDCxTHVBdVVhmPVlVt714XMWXuOS7LHLNZfbrFu8v4Cdpq/O74BNaF15fzaAwxA/EQ6u0u+4fxRSZSsATB5hBD9btcn1b8kUVqZqE7DSS0HHJIbRY3Qdv6nIWMdiIWOLWbFEEAhyiaFaL3xzDq0f0HPOTIbQhRnGWoq/9kVHqBdx7FT67mNx/qrgmyrTBb5Tktj/PXdiDbnOu0ntRXsHLhNZdaI0WaWIZIRhVIdin1HRq1p8FjrlWe9dMDED3buxJf3xnqrn7RTIZcBnITo7q0Bew/zgaiv2c9+Zj/BiVBygVPT0BxM+PnNXb5aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjrLOZCCXcrxOqasdE0kfxBLvr1EjRzh4KDykcYPDBQ=;
 b=c/idx56NXbELVhS5uVpYmYXImUgysOa8LLnLoqThLZTJ5m5De7pNm03BhPpZPkL6f4cNMeyw7H60NsqgcEMosaAyaW1xp3Yuzc3W7UdKw7TTAlMQa+STXnlhAUVy5NOVBxDKJ+JrLl6fOA/z1DVXMS+4i06wApsjMKQdcwLheGqjFZYKI30EXHzjHu8zS83Zdb/+Hp6t991lw50ffXhVft1NU2EYqSwJH+fxmj5yenR86QxiRb5V/3cbGVs8oAJqCVDEIgRzASvApyksGGvXxyHdTAG7hM1MIhwoKpQl9hYXg1YtFVVa5R67qaRfwos8KweIUp3AuVOe5peri4UDCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjrLOZCCXcrxOqasdE0kfxBLvr1EjRzh4KDykcYPDBQ=;
 b=fqR7k/2mzM0JIAz2j4NnHVaYKjs3oBSNpfv+M32bxYBfy4ewVghDd+0v08U9Kd1QVxFSeDt3dxKZes/1p8BEjpRgfQBRCGa0n4lVSwj6FeLME21Mwlkiymwv3wcUt8mi+O0fnYUBQcxvVC8ZfLNvQDzQ+nBI9W/YusLOdcpu6fU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV0PR10MB997636.namprd10.prod.outlook.com (2603:10b6:408:343::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 07:29:18 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 07:29:17 +0000
Date: Fri, 16 Jan 2026 16:29:07 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC v2 05/20] slab: introduce percpu sheaves bootstrap
Message-ID: <aWnow3tQv0KxSOMe@hyeyoo>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-5-98225cfb50cf@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-sheaves-for-all-v2-5-98225cfb50cf@suse.cz>
X-ClientProxiedBy: SL2P216CA0168.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV0PR10MB997636:EE_
X-MS-Office365-Filtering-Correlation-Id: 40ef7198-b446-404f-2207-08de54d0f505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5DtMEYTxrN+wDh7ipENws3hATLatWOlYM0jbu/CIEzube41137CK2WLNN3DH?=
 =?us-ascii?Q?D5EJ0Hcst/qlJz0mwjI2Yu42ISbFt0HiWdxqCkh98lXyw5CdZwB6DKaRCGO4?=
 =?us-ascii?Q?7g+RHexiW7Ulbd23k5zUDN9AXAqxyh21/3MB1Flzz5wPSrNDRCryMMfs7P5W?=
 =?us-ascii?Q?SbWvimhaKUu6/U5BSC9lk3GD4IIMZK8VWjPAKY14Wj/BiZKEF409JtKGehFs?=
 =?us-ascii?Q?kdyDUiJznAnf4ERNxivLQwqhUY0rA95+HwCgLR3o2Pp8xk7o2haUFBw/CHT+?=
 =?us-ascii?Q?xxHdE0GV1VNEFk/NSc8UQGJKS012NAtif3ICfUzkbA4lOYibKlQMHY010yG2?=
 =?us-ascii?Q?RL95Or9BoKveJi0AQep1sl7JGdIdTX7MVTkFbUPp9SyTJcsB/vY4yQEXxp1B?=
 =?us-ascii?Q?Aau120yOhmOXifYBoQdb8DWYBY/s64+MxMjTeBluVXXGRvY5LbII9kzv+SY0?=
 =?us-ascii?Q?+QLGDc4zVJA9NJ+m3iZ6H85oFPJTOpUqhqx0nks687jofQLXWMcgyqoJWjC5?=
 =?us-ascii?Q?fo0LW4+RML5EhUv+4+xii3YvUvbN3PjYiwaJPI5hEmZiP8gsvlxevDdqgkjs?=
 =?us-ascii?Q?CTzv6A4sNQhABjFbDGhPkd2iLL6TxT3vbh3uc1M92uMnR6g9JMeInt0bABgd?=
 =?us-ascii?Q?PNcJjW5JRL6AfEGsIwphW3WApOKib+qkvYGd6tcI2ANT09Sizxl3xzXxL6HU?=
 =?us-ascii?Q?h2FhD7kkd1isY3ZkrUvxlczP2lbKhl1rw6VuusGKAzweAGC/4vHCR2x7lxbX?=
 =?us-ascii?Q?as7CdMOgWirTCPBZggphDiYWSZYsvPYV4JNiAzURmVgtpyyhoBjfuQaBmqHC?=
 =?us-ascii?Q?HiEOiNzUFcOffbK3ZTymJreq1z3SzBxceYNeJ4QyqW4Hajc47x1qKRZxN0/8?=
 =?us-ascii?Q?88krKfJ7k+x85iFjA4SVpvzGhoVCgeO80dSpxJLuqctatQFYO1UHg+j5V+Qz?=
 =?us-ascii?Q?sbn/LRuI/sN3pxau4Lz5SX+Fn+6YXlWYKqUQHXmfE2F4YGCJB8S+XhhLIE9C?=
 =?us-ascii?Q?0aL/OZM0/Lrqhs8aGPror+Npxvq4lc8jbhCaX+uhqCF2sJ+pXMT8/Wp53hCK?=
 =?us-ascii?Q?rrEsvS0llCHX39TaFHN5OCqBfcckzubyqvm7AlbSuNYPv0dBE9Wo1e6YUQiB?=
 =?us-ascii?Q?D3JQSnm2sSFLOZY5FbwmW6QDps/UIv6DB2evmmSeuLtECK9yZPMHoFgqLctI?=
 =?us-ascii?Q?ODSEY4lHuDP7Qomy+9h+kNZoH2dpNJh8vXHvrnFvZoTjIE8GFTB5TzVdoIyz?=
 =?us-ascii?Q?561IvNJaBuIFtJbxQCUNc54hb0EczZRVIjYUPrwL+5SKNBNmBPyQp7ZX8/GZ?=
 =?us-ascii?Q?TdxlnuLI2SRA0j8poLjabjp3ikFBrErMUK0KRoWFEraYkWRyx6E1qyeu13+q?=
 =?us-ascii?Q?pzcRVlz9WeqF2A40YUTMIlKB5a9vGqyvrccXOt+0RpFGSP6oyxDaswoZJGUn?=
 =?us-ascii?Q?g2mlS1pBAP8kGnuxb1qdTFZobgYvlWo3nMtmouu+aS7HZXRP6mhjH92Epdre?=
 =?us-ascii?Q?eggozCSO7r0jh0+1OI6kt+M69lVylBVIJZ/vooSXLpppM29k33I8/NbxgwxU?=
 =?us-ascii?Q?CSp8h9Nn5CUElxMz238=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R6HG1FPAf3VNEpxB4zkLnVejSgYvIl00dBqM671hirX0z2EtkSqQvedFi6y4?=
 =?us-ascii?Q?RKcNlEt+WY5ubXJ59cRQpp/niAGw3djhBwzLnFcQ5GZpbDRlgsR3gsnE9onE?=
 =?us-ascii?Q?sadix4Fdu8NTNIIN+QUAP57rXjbTVZ0vdSA9iFh4+yhu/7xzQpQNoXI5XRIl?=
 =?us-ascii?Q?TwV0v5jktvyEFpat90oJaaFN15Cu5UudDuYCX3q1k19924iy78h9kTm7fWaE?=
 =?us-ascii?Q?MkQte27kAM5wC5wo2f7aZx5BZrc0G4PikEFBQGQlR0g2O7bK5ta+01mNdZQx?=
 =?us-ascii?Q?93rLmrKJ+RCIW3gsG4qlAbiF+npMakfPc/yJOCviKnFsyvr5cCr37GLkyxJs?=
 =?us-ascii?Q?FvBRmnZSl8u6mQizDOMQBcKTDp0sfyk99WwIOecAPPP1EtCnVYleGGamasP/?=
 =?us-ascii?Q?mFQV2Bd7IJ0py4lhgqkFDQQWaq4xJiB/uEZVMYutcmUvpEfV3m87mcGrD7Eo?=
 =?us-ascii?Q?o054UdhdD3C680ncoSg6fPhfN9UZjH6+dw0uks8A+fI4bOIt0+EOeSHBgS7p?=
 =?us-ascii?Q?R08cFFUYT9yRdrsVguUFTXd/AaOdTbnWpCuc8e3qLR6lXMFmahECp/6/tXFd?=
 =?us-ascii?Q?oGXzS4UQmXQ3NinCMeWOTx+HRqzMUkZqvQ1fYvhh8Iz6LbZN+odNQXJQs4VE?=
 =?us-ascii?Q?6hVr3Tf7xR3vC0avlWBaCmJG92XBmQ/KU1aD6tQEE8kzbpldj2Z65Xh8i5J5?=
 =?us-ascii?Q?JMRiMOOiuWypGh7R/YUx5pXCxIoPL57g6np1LKuDxA/T59vSR0bUZOVGea+O?=
 =?us-ascii?Q?udXsYQhHe6E3SRkLEobXlHtinwyeD+dCePHWKV+sMDmQKMUYYiRrSanFGZpm?=
 =?us-ascii?Q?AZeRawaiUEaLIteR6+2C3xO6jLWQE5y0fdq56hjPE+cXQnqtKbyv6SUinOs3?=
 =?us-ascii?Q?O2i4FlpQnY2JlTePWxQxiu0KMD8/cnh1/PIEfs4LaNkxJ9jZB0bp9ikXL33g?=
 =?us-ascii?Q?bm2mpM7knByuw4K9FU1m0i3qXsu8gLDZlRVRI9fY/NKwHCZugPiaSuwh6owY?=
 =?us-ascii?Q?LqqukdE91/gdigj5R4rB4gg7dP1Y1CQ5lmTYY2IUQi05lBTx6IITvmoLEoMm?=
 =?us-ascii?Q?tnmYPY7eJFGSvvsE0ZKzxC0k8bWF6xxyMRULtIE7QSn/MzrO1CEbf0Uuw9xV?=
 =?us-ascii?Q?MlcM5svaF4X7bIMTzqREW+kOS5NCm5EE7roIx5C/oVNFCUVAdgC2bgSFy4kl?=
 =?us-ascii?Q?EiRCPmBCyA6xnLQAlhD6FOOZ1hiUSQ/mPJ7G67jtVu2B2dse5lih/SuWfgI9?=
 =?us-ascii?Q?ydFqEw1OXgvtF9yQmG/QqFMqCLBrO/u/1eLAuAIXJkHmsPIwTfVqeIZLPOYJ?=
 =?us-ascii?Q?voUfClf9oPMeWmYqn1aw4ss0wM13yk5xB2Z5QKyarR2q6ZARQ2Xa3caGqccc?=
 =?us-ascii?Q?875BgszKFThFub8dW739bJNX3ycqikPDMQ7f2SC61TEFMGthiO2iV8Hu0ZpH?=
 =?us-ascii?Q?31gGjslCfi9sh8GzzqUEKAtlTbJIxVBqHGU8bHTRSFfYiT09dNT3Bj4/M2ej?=
 =?us-ascii?Q?4cRxQqLASJYpJCAuyAFxTkL3R7S5HCkF0fcNrlTMfSlCbaYhRPwcVqnFtGCp?=
 =?us-ascii?Q?8W+d+wt+XuaQ0JkaWdbjNbzRl4144f6m2auW4KGhuonyiwsOJH9VOTXtzDAY?=
 =?us-ascii?Q?SwjFiolbGVLJ/fQJrQtnU3B8BwHfnjYeOz4ZHN5n17PIS4TMWbA6t6gWmlWl?=
 =?us-ascii?Q?pgFPoDZaGaVf/JRpaXsFHZJNnG6VzltzLkoW10h2xgq0CrSQ5Ckw8078Ue47?=
 =?us-ascii?Q?ktA/2kGk/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cBUSucIchFHXqD7hiFDAISC4t6UovXTFLDx9Xj5DzLtsls/Y+rom6aUu1RdJYDgDzDgVGZ/5mj/qdHegMux4ayXKngOEOowbjihGNRR0LfC0SrAkODpTT9FImDtQW03lgr6FOdIuHRe4cdyHg/QA7m2NauxBOLp8UWGqGa9XNdf9nLNbZ54TFoNsEjSSOBmt0gLr9BGKBhRksxfss2PWDIlM6CE0j5VSMNRLyfdU04HHfp0Y4oHtY1eG2qwKF7fTdmnmA5kblKBUIF4fJhas39Et1uxDJ1TBE6rW6bnmmviKUqBACvcnY+U2RuBqRPdDJF8/hPReAA03tXSY8ZDnDFP1FjX9WbZIj/jNGMujozdRfc3cdcQ6ng1nX99F4u2T9NdQP43D9sCXo3rzg9T/r5iy8p1XfcV/DJZvyMT+jvSLWLpF0ULd0JM80Ek9vTDMHxhOD9tu0JTqPzJ17HAI4C+0VmFBTPLrov/DcfWXlDS5OZBQtuNnmb3qiH8Ed7ccAqnKrb+oNrLuAHPrb0SjQSTyJT+NBNLE5g4gzJkwgmo04agJFbQGZl31miZYPHRM+T3JsEPv1aZkf2YH4eAP6jos4k7aUDpxPtK0W9VwJGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ef7198-b446-404f-2207-08de54d0f505
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 07:29:17.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lY8I/qBX9gNmeiKct5tQN+8MhIM6WWry/R50f41nbS/Gh5WkQc1kuvziJQRhx0tR89sH7K9WBnWRoWZd8MzsjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997636
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_02,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA1NyBTYWx0ZWRfX0zrLr+4kWYOw
 LjPoLezDw+gfTe/wycUIzicaDoCK+8+fcHPKtCXKJCp3AXhmoMDWsCi8NtOSMtSx+tECaxpLXWY
 qUSXKqCCUiQEzWlzqr+AaWRYVrD9m1zKipvdzYe07M4a6HiFvpk0LH+nz8uiTvgiWom83LsPVR2
 GS+yeggKraUatVh5Q0BosPx5VC0gHNs36GWQXUtEqN2Eaqzpuczl8MFY42HFq3AVF0pvJyYVODC
 fQtJlNgpQ1mhSE7KGjsB18iIUDgmj1qbde98tn3J+Cymb53l/ZFIE39UWGCIUxfnNfJ9St2aH6H
 mEfoelZ6/pWbQsGYUY24csYiQ2bejLW+HbenyfNaIzlANckwf1xzjdG9l3WBaD2w7iB/aGnC2sh
 7Hvp4Gj2kZHjfWMoMU5XiDgIl/Tt0ntxDhH8CV1ETm9fB4YiuJjCry7EYnleLNB2GNkKENfUW70
 TaeZG5Ct7oylUIqJ9FA==
X-Proofpoint-GUID: yQBaaDwFzTxfhgmYr2U3Fg9BadBIxLEi
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=6969e8d1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=dBbnmaIThoCBKMIWZm4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: yQBaaDwFzTxfhgmYr2U3Fg9BadBIxLEi
X-Stat-Signature: abkjjx5t3t86ww1ndojsoytwr6iatnus
X-Rspamd-Queue-Id: 4D60F1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768548567-50586
X-HE-Meta: U2FsdGVkX18c+uunLx5AQk4GfcqEvZPuxm0jtV/UdtBqY2fvF+moOCTk6j6dysS3wEt/o3AlbzSonB2BpyoqJDcZ/5QftOhMZNn3HPn8gWOaWtYETYa3XD/D88yh0Ki0FFBZBUEYRNlYWIshEWOQRI5r1mxtDCMBdgAW59wnJTvmsBxQoEHnT9wmQgnsdetNCaYsHkXB9NCxxbmeFSGVOyalH0pRyqmXDmZQy8JnpoMZy3MYlNXavZLqoo/uiOggvO37FK5xqYGImVS+bt1N4Ye/I9fFp5R+CiUi5llS48JGw9qPg7xIHxHZhKYqiMU/vIjxCfFmtahcrPb9uWRsVFG3sC5Czmo6SiJrIIBvXEmZBBEoCmsdHaH8ZFLPxkXhAZzOk3M2u4gKXpoc2p/ug3xmNeassVjoi0bjFW7gGv7UA3DJR7NlI9ha0ZCa9bIZ85toUVg5A/qa6evcdMo44tN0mEH4aY3ueF84Xc3jI82Et8GtotYHeEL25McwU+lOmlaB52mDWcOhvJ2bObLgndpkD/eWcWr3H3CnpMUGm8A6YGKpBaU4v3zYPx6u0H1/cxrgWO3DMNRx0lx4T3adkTuZ4C4kFx6gvs/a6gLiHLPeBVZJcjONhWhIg/waweW00a1l2UALtI7JsMz6cVn4Wg9O3Jh+ZPbcYMClaHApSc6EqL7/fcu3WeKH8D2NXXfa0fKxLT8Vl6VCiI8hasTCUx4xu8C+zxAW92chYPTXoC9XP+HZOQe9ZOjRFOQ6W/U48+QxK8rtGXEdEpk3Wt8Y6cnUAppplZw4PNnADMo7c/Ez4Fp2YwG9N9N66MvwigM8ebmrt/gMgxbMr+0Hj2tNQyWbehHuYjo79vkuvFcMq3ESUj92U+ZE9RLaF5ubvirUcNRKIZiChl+gO7ak9U5rm8PdD9Xu2mvLyyd9OWkRE+KnuW92a3CCSB2oCY/2EipJe8dxG4agxpJJUiUeYmZ
 pyLvsb0L
 HoyID26VuwJioa+Vb9pbhyBo6r2u3xBgvEF6SUpdkl7Nrld672VhhfMeKR3Ex50KKCCTYPzTtdXqFHs7g4sxnCON0k9Ob7IVf0mpoklk9n0QyH70zRoPY5UhzQb4WofniaWNeRXpXGCOQ+TYuHT7Rdv6FzHW2zW5dNBsbtnREOfJ4uoULcMtd3GJ/aOACtuXgP83XnW1reT4wKwlEA408CTVHQOHgbnliPpYtgJszmhKrcz8UOLPGSFA/0PtP57Ahv32K8tsYH7o+McTqRNDDhSeJBWQCkxeVKPk9HK4yYht42INSSS1Zf1Seio28bwZf/rwqwXNDszn3AlhIt6/zZgB67AL8Zk+ixg0BBzraR5eq6nJHZzuuspTWMTLvwW8P29h9s70I48TdSahKG+lKso5Va9WjOOEe1i019XYGoTzBVBsR8swnjhyk8qe7mnb43meEJ2TeRDI+11FNitvlNd5MWZWqx8u5Yuh3/M39/4fPu3U2nBZr+hx1tyHv7J9mr2pAmQ+PPO0/CKlchrWqkSAYigKlZXV+/C0sc5ys0sXPVi+tyb+e3dGgCUMqLD/NH5V0lFw08d6jIJAk9y5vAUZdCP9PGN65uWcfYQwG1qsqiRyGGHj7t4UDuhQ8QF1HsjBkihFHnUTr7i+U+tvSuExlwWlro+olm7dFLAFlmDvbftfHSwSKIPrABVAbGa1uRiR1rsanpPsgqrI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Copying-and-pasting the latest version of the patch to review inline,
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/commit/?h=b4/sheaves-for-all&id=daa81eadcd0f9e3b8085dd7fb8bb873f4cde88b4
> commit 36b6dba09fee446540b8bd6dd771859aedf2aafb
> Author: Vlastimil Babka <vbabka@suse.cz>
> Date:   Mon Oct 6 12:13:33 2025 +0200
> 
>     slab: introduce percpu sheaves bootstrap
> 
>     Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
>     sheaves enabled. Since we want to enable them for almost all caches,
>     it's suboptimal to test the pointer in the fast paths, so instead
>     allocate it for all caches in do_kmem_cache_create(). Instead of testing
>     the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
>     kmem_cache->sheaf_capacity for being 0, where needed, using a new
>     cache_has_sheaves() helper.
> 
>     However, for the fast paths sake we also assume that the main sheaf
>     always exists (pcs->main is !NULL), and during bootstrap we cannot
>     allocate sheaves yet.
> 
>     Solve this by introducing a single static bootstrap_sheaf that's
>     assigned as pcs->main during bootstrap. It has a size of 0, so during
>     allocations, the fast path will find it's empty. Since the size of 0
>     matches sheaf_capacity of 0, the freeing fast paths will find it's
>     "full". In the slow path handlers, we use cache_has_sheaves() to
>     recognize that the cache doesn't (yet) have real sheaves, and fall back.
>     Thus sharing the single bootstrap sheaf like this for multiple caches
>     and cpus is safe.
> 
>     Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

