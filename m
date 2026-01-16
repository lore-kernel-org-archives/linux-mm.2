Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A2F0D489A3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EFC66B0092; Fri, 16 Jan 2026 08:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6E86B0093; Fri, 16 Jan 2026 08:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8686A6B0095; Fri, 16 Jan 2026 08:37:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75C396B0092
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:37:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17E3F160158
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:32 +0000 (UTC)
X-FDA: 84337929144.21.413F495
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F63040010
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dydLHmza;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HQx0Vg0y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhOgeK8rv2SDFBgmcQhDu+SGeo7HlmSbb8C4ONwPLvA=;
	b=GCvKuuugw9fIP8VQBOSIRPvBeIAQ6uyrAbOcKopbf5L6OxsKutMTbmpPXwv263j4UnWc2f
	9wLwfdVoBiOtkw8xtrdAc5vSEEu1XUYidvR1rIGPAPTiOFMo5fOODOo70+jY4umxt83K3w
	s3nkyFe3nJQvYTyvO/QpZXEHAT4E9hE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dydLHmza;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HQx0Vg0y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768570648; a=rsa-sha256;
	cv=pass;
	b=Ki6tBHGtAPZYN6OYEDdP+FNBLsE94pGZeM7CrRNtl/KVh24Pt5lK9XneRLQNvNCbnL4nN9
	iNBFHja1fWGdm57XTmf/rTJoQCQWIfuEsUkX2Ar36+jWoL5tnVWmeOcRECYvBkPYqk3npp
	EAJAKtjFuDiL4fFV0YNuG6S1oMkZB38=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNLGW1655463;
	Fri, 16 Jan 2026 13:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rhOgeK8rv2SDFBgmcQhDu+SGeo7HlmSbb8C4ONwPLvA=; b=
	dydLHmzaSp9lKUGUSBVFoFwdMj4/HTiWxpQAoUgiZdVM+XMU2QQeSvB/2pu5Ijpt
	9VkcYKfB8sY3MeMZDur2RIRII7Ne6yx/BAl+iypSmIFpc106oS1QBfh+UiOwNZWO
	JZ0ll8PaOcrH+SlmeY5oEznDfKwkCqK+J/UfHgjDTcWJgCcL4MTlKJhJSUOk8p8F
	0SgibqPkxY6Ba96iAhPx5lDqF844cslct71/YZyTR6yWRQqZh8v/1sITeItq5wCF
	Kxea88yg2HNkcS166oPIYvVvB+DMADu2DoFGaCu/iYuXNOP/syJiwnWzqDVn2fBp
	tLwn5GHrPnSZulYR3dX2/w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc58bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:37:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GDXNij001924;
	Fri, 16 Jan 2026 13:37:15 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7cvwan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oxwjFcGh+tqKuxR2ycxyl8GeRKByZ14U25DH0hPbCf1Db1XRBKl/NNQxgdGXKLb+v2m06PqqyOewKJMoQvNwHt7JYJLFb43d1Cs4tvYV1N6SJGgYUeMHPpZpqVCr+9ncEF2QNHY3z8jVu8PCowHZEvZ/YaxQFal0KSeXDLqLTokwpu6A/iRvOdROIlINyjYaZ1m8oftek3wvJ6TlBE6R+OS24H/8hEqslCcXC1+FUYNcxa2R9S6Z4GTt59fgi19cWsxNVqMVxu/2ClL5r5z9KLCj6sOoSg324m09YuegMdnrw+uIPPezC0xq58BTKJCklQM8CdFiSMKuw4DBd0UD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhOgeK8rv2SDFBgmcQhDu+SGeo7HlmSbb8C4ONwPLvA=;
 b=weMj5vajtaGlLNltYVyg/OiRaji3fIumptDrpOVLclllaJlyr6Czxq3nWA9V2dmB8oT8zvLVljS3AnvhCmVkvclLAzQLtAPnFzLYG/ePeakwwfFBGUUN5QBwEeRbRiHelsMsWwXe+ICB42vbFVo/3BbGiLhAy0n09gX8e7LVBVAXAeAeQaTR6MvUreDHdPxbA0/q4oi1hMO4/yHUcTElSJtD5BjQuOyN54SFGoEvh4CIdkHh/DeMBBLn3V4QL3evqFmZASYA5QVNpvwbavJfwvr8qrJSIdMVWF33lmPKXtXpJx09K7MoEq6f5PCHH8lNnPSmpQJa5TLrgI6MYaxlxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhOgeK8rv2SDFBgmcQhDu+SGeo7HlmSbb8C4ONwPLvA=;
 b=HQx0Vg0ya5PK9NmA+T+Ud1uXCnd0R8vfoV0c95vgbs5GIexy8UjHZ4eme2i2mFDmz0dfFbcEKL2WxUxx+eUEaLL/HtvVd0ezBZUoMXicNwgZ/bz6qKGpNGDgfYVTpkMWLVF4gH8M+s6IEjEcTj4SfwushgUHpp2en8Kmv+f4HT8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB5609.namprd10.prod.outlook.com (2603:10b6:510:f7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 13:36:53 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 13:36:53 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RESEND 2/3] mm/vma: add vma_is_*_locked() helpers
Date: Fri, 16 Jan 2026 13:36:46 +0000
Message-ID: <07122584007a6efbaa47d115030ac27947df700a.1768569863.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::23) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0df74f-b222-49b7-c66c-08de55044f33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?awjFyHEtcvNkhJ7/n7MxvwkZGxwoysGRpi05b0E7ptiJ7UzwdYB0cwnCHwgs?=
 =?us-ascii?Q?fAFePkVWgXPpPe89JzmSHzCBLoQ1zwUfDM5rsUGH6zB9iO6xfCyThqtQyG6/?=
 =?us-ascii?Q?REVg2UMBGlHFVVpV+WLeyVA+6xK1qjN0D9GUYAEL7mBRxSPUkAd5R45coUQm?=
 =?us-ascii?Q?n96Qrt7Sn8UFb0HyHiPToY//XrxcX8eBavbKEGSNazOI57S+9UdFBNG4K2mf?=
 =?us-ascii?Q?Wb+k5mWjOrojHcLbI+AFSw02AyQVVOAP1GtPl6itx50OZVF+Ovzp/f0Y3n/t?=
 =?us-ascii?Q?WYGvUdJTYbqD/96AuHGQJet96uAvxb0VT4Y8Hw8r+TvwWoXNKyeUG5KGr+lq?=
 =?us-ascii?Q?dNWo2vI91lb66DpzgT3NN6Sa5PEXNuCH1BbTHH9c2ntcrJ+O7XiCKwkB+GTS?=
 =?us-ascii?Q?mU60f1a8VOgdq2QpE+oq5Uk8a+YU8nb7dDIRQJzBLJ4ck9oVlouQvrYRcXvk?=
 =?us-ascii?Q?q66/oLKHTlCzu6hj1q2BdBYEheX9bVPUShKeI/CXR6DeFZVqpjrmvw0MWjrW?=
 =?us-ascii?Q?zXOuD7XsPxs1h0K9fInS2JjoaawkSw01tDZz2GuvQxf+B0RyUI+6ljy/oDpm?=
 =?us-ascii?Q?NHadHuuZavPvd52RkWOuZ7cP388uubj15EXIYjkvIGsj8mS7nx67JxPTdYr1?=
 =?us-ascii?Q?PfTdb7LSP+7JCyvGf8XZS0CNrBsS9f/USzHPVs0Dtxus2bQXD8vGLuJQseAB?=
 =?us-ascii?Q?bvuG6e99PaRzMFieTFtDwr5Wk1VZyGu6NE5bMmFffWqAShMJarDS/gDxeehx?=
 =?us-ascii?Q?BMJ/AQMwXRObk0BHkAPsA1vhsDpObArzPpgqoe03oPWZF7PO7kR/eCNGj3Gl?=
 =?us-ascii?Q?/OInQn4GKJfNqHQElH15azRbHz/AFohHxoQ1SfttSU/xzxzWUmK2CUWO7RI1?=
 =?us-ascii?Q?03j7VFcNguQMg0KsBT6FS0RukESjXKaAYa4ZYN4KHEuYDzznaTbTXer/U9Og?=
 =?us-ascii?Q?MgyClVX+gRhiMIEqmSTELwJ0+lRe6IeVWaHLT6NqOsp/NVAxaBuyIcSE58Z3?=
 =?us-ascii?Q?yKsf2/6uDt6B0Bg/WwnIAm9Up8CK2sK7qfrxZ3ZrW2ac6t51ESS0uq0wS9Vz?=
 =?us-ascii?Q?Ws8xcs2J0jb+wu6cb6W9J1RoxAnjNu5inQAIoGfbjKjoCiWZ6ky9ahy52xe7?=
 =?us-ascii?Q?YOh8TnnjfaaPz45kG4g+oMpkfABqs8xpQHnsAjsh1FtzMzmmHmSq9OTo13Dk?=
 =?us-ascii?Q?siaV7OvhRm2h3/xKSMZtKGXsQD8+gloo4D4I1vf7Eciyv99fx0GVnQVBdcM4?=
 =?us-ascii?Q?KttHQJqigyNfpJS0J3tuhd3bT7/mb3dYtO3ep0aVtwOk9rknb97ydmL5DfE+?=
 =?us-ascii?Q?S/ngtKFO9HHaI23qUZMoRqIjPzD2QKMz1l2kkUku1D9wjvJ1aY1Pm8zwjGeV?=
 =?us-ascii?Q?g7Gc5bimxFObT8bop0IiFDV0GzhkNqvjMP91MghhxigBwppmsbUa6Cdm8HCw?=
 =?us-ascii?Q?gsTtNV9uZSW95OdTAJ6e/61S1zSDWfYHc+NzqEppc6er2HO0hmxIQL0L1Bwj?=
 =?us-ascii?Q?E/r840OeFS7TsZ1O6S/vZ4o7xLRS9IOB4ltT0E2MCboKIwcfcbgILRT8Adq7?=
 =?us-ascii?Q?JIp2bFFMLlDhM776xzM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mXd17X9idmqmFLpdi1QLGQEakZWP7taGq+EnU5RQkq38p8I8g1OFDj8DPhyz?=
 =?us-ascii?Q?1Baa5K5LA9IxsSeiWMrbBZqYlF90ZAPKWxrJo9+SjumXULMFLjkTpxRrM6oO?=
 =?us-ascii?Q?7MPgXHdw+efzmWKVyhwAxR3f0JMgI1nPAT9dOsie9/m9MxNPnsSoKJJsuQ9U?=
 =?us-ascii?Q?xE1i89SN2ISKyHV1F8v5y27JYhlcxuYe6FLkw5FJ4DQZrP11i9JNQiiYzhsu?=
 =?us-ascii?Q?pBvGFyhWu2PudS/H4JwkFC6kaHIVM7gtrkHM1a9HpDhwKbaSmcbLAfuknytn?=
 =?us-ascii?Q?X5p1q5oM3i6NVN/wjq9gBHN8KnOM5n/ZwnbUjsMTFVbq+adrh17JdM87sLTF?=
 =?us-ascii?Q?tm4aFdlZx/7s/JFPQ5wggFoCLcpOyurYVpwG3IrPPMkNIYGGZb2M7JaukvzS?=
 =?us-ascii?Q?Aw8+jhAgjBwunERisXSeN+ZEGL7xBVWiYUBhe6Kd48fAbF7WIFSoR/8BstDF?=
 =?us-ascii?Q?tNavv5s5j/pOdu05cDgCO1Fy5N17TUZksVxo6hh9Ky2t8XMYxSDG9LeOopIR?=
 =?us-ascii?Q?rJPXOfQkduSwP5Zfld+IBMmXI4/85m4MeA27X2LlBM+Z+Kzj7aMGu5/BeKqt?=
 =?us-ascii?Q?R8qImdOAWbvdk1ASTHFRXIBm/Ttb4GfnqAPPMv7ukeIwnYwq0TdQNMWmiNP2?=
 =?us-ascii?Q?n9/2qQWmNsiZU8nVBxValvBWnmn3lhC13Pbyi0XBd5wm06hewal9kzPQDu1E?=
 =?us-ascii?Q?vPi64fqQte4PmncRcpWdLeZlLNtjRf53Fos010kUlcvjE7d7NYkMbF2M4WoK?=
 =?us-ascii?Q?epGHdJr8FhvbE9esgy4cSVcXQyAf/7eQN50BwVlGyx2brFnJs2lx+HS/uUmG?=
 =?us-ascii?Q?KJz/0ynKpdG6T1b2hPlwpJYcTdR3S0ZW1W/0Yqa1xdtWxhwpC+thqMhp4+WK?=
 =?us-ascii?Q?Q575OoLYaU24puOc+uua33RzZNIxXic89lvSBNIUw5oDHkkzr3t0Ypdgslms?=
 =?us-ascii?Q?w0WjioomZy9qjSB+u+UegfWiJ2dDNGlAfL8wIRu9yJqqqtFQilRrL4u4Bqi2?=
 =?us-ascii?Q?5VzN9NASHwDX47efuok8gH5sKGh+G+fRgKfDoB3ywwavHBmuqpuNHfzDjwPx?=
 =?us-ascii?Q?KDh93nOZSjswW8zlnADPWnQfesZQRz6LCVHHO77qsPXfvoNaIzg6SQR3NDp+?=
 =?us-ascii?Q?/DAMcAtjyKePq2q/rSmVbC/qxUQ6UB3MgaKa54yTiFoV3SKCmXy5jNcQA+nn?=
 =?us-ascii?Q?VU+p47TbIbqwgEKBHFGoM13YYtV4w0Zfc6Jr8Bky6w72nMqY6W5ZfoTv6XoM?=
 =?us-ascii?Q?3/nuTbf6HZwU7MAQMuaCFV1nbBO1YFRosKT+wPRFPfquJPfmjPOlgVNZT2hF?=
 =?us-ascii?Q?W5FPDXZ9lj33+1s8XE3AoQ/5JGdvYJcBY1YfYs3igF2FN5Bz3tQRpNQmsnFx?=
 =?us-ascii?Q?P6igXZNUMe1P2aR76g9jpw0wqkGO8afqJgiuIgAymUzhqEqpLyue0drN6a4Z?=
 =?us-ascii?Q?nV6oC3sIRYbfWQ+e1pTq7z/uyXMgImvwhtAp9JHdHIumpR5u/Kr/uT89qbjg?=
 =?us-ascii?Q?dYrLZgJGxs0ZZ4WkLyJ96yVhcb8JEWoe6MP/pbarhxX8bwtn6uiyt7f0nNpI?=
 =?us-ascii?Q?NH0eOsL4PxlG9mnWl5RZgUeC1aSUP4b9LFnForDzSylIuqZI+WFxgd7TND6r?=
 =?us-ascii?Q?svo0MBRxh7B9eVTOCD/sYYLkdG7/S0XgdBxM+S5jMs0YmllRvkp5b3mHhJpp?=
 =?us-ascii?Q?SJLKel7S29gfniBIrv9Msys1AvYyBygcVR7CX5giTlZT7W2fqzikzSsSEr0y?=
 =?us-ascii?Q?VUrPwiHoyIFSWCcSCZXBs3s7NXnj/xE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o/KCSfgD045alb3LcifQjPcQpufqeYfN+ftJwkFjtqy2U9DViRj0YLT4eZBBR9KvEhLOtFZ5xlcxP3F0oh8xVpdT0y4FEe1HUkdF/zPignfZcsubGJQhzjk8pkCSpwyFs0+QRszbu2M4xwRWftnlYXI+xbOYCtKvoJI+X2BFGJrC3xxA6edRbYry6R2BKekRn6j0h22g8W9cnLc3Amm7f50XVlFk2kTFCd9R6kR9Wp97WgwEYJDJ+2fro5s2RSN7x1sZE2+iCqZHoUskMdpg46adZjXu3+U5FvHISnDu3ERYtOfewCi722szaUXd7GYeKkoAyMt4bJO0+Nbwzmy04TixAE443B6TUq5nRv0cSiSoSFvb0emkMje4ZvApBiMAniJMGwfQvfgqWaGrlMA7kIilS/0jyqRatKJE/Vh7eLNH+W7x2oftj7eBKYX+eGUSEQjzcOk6clWCfNS4it/Fcl3AGqH3k9MoJBJmLJiZ+hoqwt/F6/2LElPHqcjl2+zWjp5Zm2XJjugzlITUvVJLSjpoXDBPk6oP0mobKFoauMguc613/KYvkzWsS09t6kgR+2MkgSaUKMM93sNvi7lpZW7uM1pCIcIdTIGkdmwQ3sw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0df74f-b222-49b7-c66c-08de55044f33
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 13:36:53.1018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpIOI9KavOE+VCqByStcc7d3K8+uQ/rjdLfp0BBkzzvuCb1RfX9j2qIvoIrobfJkp/Ktmf1M3PITWG1aWz38GqX1GErtusqC80pWAGeNzeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5609
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_05,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160095
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696a3f0b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=o-O4cB3HQs8lDPzn2AwA:9
X-Proofpoint-GUID: E782J6cal6sDVd62c0o7ZDVlG8sd6qdU
X-Proofpoint-ORIG-GUID: E782J6cal6sDVd62c0o7ZDVlG8sd6qdU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA5NiBTYWx0ZWRfXzQPVBFOkiY6y
 faTpnCXDHVxoDkUDhW8k4BIfJ7lJUFGr13I5o3ZjSbCHHK6SE82idoDLXSRWFI0oh6pForax+FH
 jvQl7zIAfT1gbx1N6HS5zgX58fHcd9WAj0Pvt7Fp8sII3ZTcxSn9INIW439tAsCFTVsi51EjdLf
 /tA1WyuIQ2xycGR6q8WiXyE5WedI0M0nQLmND/ZxHabscqLS9E3pf8G2ITOj2CmMd99JM4A+zGo
 UXqY0eHIHoMoXEv8/BTtGKlHHA0tbOA0Oi8Ev+F2kNTo3FA7DNIJZdHRZNegfg3pYJSw1kJDWKC
 1RHVim07uKnaNVEMH5RWFJdMikx4Y9IWCxA2L9oi9ZYSCuUMSYFTr4R7y5s1kyQDNqupmP+ZTfH
 5kk30+kTLWAp44c7g9u11NBQAHjEZ5L4BY14WzeGCwPiAxn3nW5c+J++FoYBwrCeYiTe0zQsFI9
 h51+eiHrziUluTTBwiQ==
X-Rspam-User: 
X-Stat-Signature: y9psf4iencm4u7x6kck44nbn7xzdpjdw
X-Rspamd-Queue-Id: 8F63040010
X-Rspamd-Server: rspam04
X-HE-Tag: 1768570648-743605
X-HE-Meta: U2FsdGVkX197LtVErmOXeg9EGWmxszuO7ajqcxMe4bPufpW+qxmHoB3YojHV68xNeKfv6At0A3393h2cw3VDcJ1EjWVD7gXpGe+ddJg86XKR3IeJmhgB0cVnRbzE/jz958G1pP60GeQzJmtNRZCrpyjkP/8GIKaPlrbd9jIij45wCoeSbTNBoDlqXje5KKnKC77/FOpXXVaW8Q2w7zqur3KDWRT1WjAPmhfzZEG74U4/k8g19H1RHA8p5KO4kr2dkSEGN4dnJruj92zm6dS7H1vtth9Liq+QTmcZBjfoJqtfng+GTUMxlXQmMS4FNn9ZnBzKV2CM7AM3dx6hYzEThpUjVLX/dn5gBsgfhqN6pXycCJmOLG/b/QDtudB+EHkl5BLeM1lOkE0yAfwMUegks6ckn7aYauXK1tdCsp2JLGVDK0Nc57KErEZGSxYOjpBf6dpQfFdCSRQxGVHsm6tVD6rHE4A1CA8Wx8MtwtdW7wDDx/4K4Hmb9wFvyjHRQCnbUfqT53RTMSlqMp5UxUYLxr+m4a1R0W1v5j0THM5YVL44GMeZNY6Q7nG4CyroAItlcGv2MiTY4LvCfF3FI1q4+1BX4dOkJXEQihqfvoExKyYnzKvuBr2cc8opSWtJOW02CYe6i0cQpye297OJ0fVyXAZYPPUPW6HmBeufTpDmjF19GO5ZQA5f2HccNqct3dx+68g7yPs1IdKj0pWc6fdaJIqKpgEg9OwCtVYGcWXJip5Epr0MzFmE26e7hYPY9jKnBPZSAx/jmjOGCgVkpLNb6KzbGkqKSFADzxOJvPLp9WoO9iDN9+O/VtzVv2kkia3l1KeHqP8bnBja99iVKGgKkIHcSvhJnmWstNl/X0IT3Ok9kpR3WNLXWzuWa+C0Z+iduS7gGKx/JUMDVrSRhFfFkHQjGBnJiMojDE64G5NIxzHAa6ujrgbiPmMjS07Sb23HP7QfKxff3M78wBf1Oct
 J29WeZJk
 8SqmtSerix3BcdJ32K29pYQfEDmCaz7YJdRirqG9oMwYEH8X8uEh5rGR5/dsNE/9EA+gvILcZG3lr2dKDi5smwzAvv6leQOl+g5YMwlnZjuOe6jVWo/UYv+FbPjncocsiG/IjLmrq2sV/8u/QZV8r2o2LdpjfGNLZRvxP3rxM1AztcDJvGnL7so0jraBtMYffAdaBzCYiIIaN1wfo0E6/Uk3kATRD9y5XsT1I/edMRL53P5O29Zfh1+to3AbtrTSJb+vyJ9k8yp/jQoLzah/avtbuWlej2aA/A86aQZVNX2Ge+Nfj+goj/6rr9Wr+INxSMJutyhQR9lN2Zu+u0hXv0QL8ObbXCBhJ9F0RzFCIDwz/mMj7hWu7RCIRF+LFdXTmv84pux5dsSLyZdLmxexod4c79H5BEchStWPPeTloki6ugfMJY9qOIE7sBbl/d46tLrqUssQgXJ0gk8LqwHUdNUKiV8WflcI8/FCcJ0mp5/ifViE8x/AdzsK1NeV0SLSxfaE14EUtThwGDGNma8NvDNw3k08r/roJ/wFnnP/nGV/+M+MfXZaZdNIic/2rEtRrMWuIC10NQ8GAb0ZrntVMW6111PgYpk+GiuGhbICT4c+7I5S4ujQuUzKS3Ls0MAI7g4N3u07UTshrCfriGMGtjzgFhQQlGvhuhj2W+hhmjsd9lzdw6DqUWmP+/gREz30BVxoBHgu/m5iS/tIeisVwYBTG/5NLzpAd3kAu0Cj5Ml6sp0G39pbI0p3sKsgRViD3srIEEefHE1XiaY+x+defrACXSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add vma_is_read_locked(), vma_is_write_locked() and vma_is_locked() helpers
and utilise them in vma_assert_locked() and vma_assert_write_locked().

We need to test mmap lock state to correctly test vma write lock state, so
add mmap_is_locked() and mmap_is_write_locked() so we can explicitly
provide means by which to check mmap_lock state also.

These functions will intentionally not be defined if CONFIG_PER_VMA_LOCK is
not set, as they would not make any sense in a context where VMA locks do
not exist.

We are careful in invoking __is_vma_write_locked() - this function asserts
the mmap write lock, so we check that this lock is held before invoking the
function so vma_is_write_locked() can be used in situations where we don't
want an assert failure.

While we're here, we also update __is_vma_write_locked() to accept a const
vm_area_struct pointer so we can consistently have const VMA parameters for
these helpers.

As part of this change we also move mmap_lock_is_contended() up in
include/linux/mmap_lock.h so we group predicates based on mmap lock state
together.

This lays the groundwork for a subsequent change that allows for asserting
that either the mmap lock or VMA lock is held.

Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 50 +++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index b50416fbba20..9f6932ffaaa0 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -66,6 +66,22 @@ static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)

 #endif /* CONFIG_TRACING */

+
+static inline bool mmap_lock_is_contended(struct mm_struct *mm)
+{
+	return rwsem_is_contended(&mm->mmap_lock);
+}
+
+static inline bool mmap_is_locked(const struct mm_struct *mm)
+{
+	return rwsem_is_locked(&mm->mmap_lock);
+}
+
+static inline bool mmap_is_write_locked(const struct mm_struct *mm)
+{
+	return rwsem_is_write_locked(&mm->mmap_lock);
+}
+
 static inline void mmap_assert_locked(const struct mm_struct *mm)
 {
 	rwsem_assert_held(&mm->mmap_lock);
@@ -183,7 +199,8 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 }

 /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
+static inline bool __is_vma_write_locked(const struct vm_area_struct *vma,
+		unsigned int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);

@@ -236,19 +253,33 @@ int vma_start_write_killable(struct vm_area_struct *vma)
 	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
 }

-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline bool vma_is_read_locked(const struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt) > 1;
+}
+
+static inline bool vma_is_write_locked(struct vm_area_struct *vma)
 {
 	unsigned int mm_lock_seq;

-	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	/* __is_vma_write_locked() requires the mmap write lock. */
+	return mmap_is_write_locked(vma->vm_mm) &&
+		__is_vma_write_locked(vma, &mm_lock_seq);
 }

-static inline void vma_assert_locked(struct vm_area_struct *vma)
+static inline bool vma_is_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
+	return vma_is_read_locked(vma) || vma_is_write_locked(vma);
+}
+
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(!vma_is_write_locked(vma), vma);
+}

-	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
+static inline void vma_assert_locked(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(!vma_is_locked(vma), vma);
 }

 static inline bool vma_is_attached(struct vm_area_struct *vma)
@@ -432,9 +463,4 @@ static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 	up_read_non_owner(&mm->mmap_lock);
 }

-static inline int mmap_lock_is_contended(struct mm_struct *mm)
-{
-	return rwsem_is_contended(&mm->mmap_lock);
-}
-
 #endif /* _LINUX_MMAP_LOCK_H */
--
2.52.0

