Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B351CCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D1B8E0011; Thu,  4 Sep 2025 11:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DF18E0002; Thu,  4 Sep 2025 11:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDF28E0011; Thu,  4 Sep 2025 11:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBA5B8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:24:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60776B785C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:24:27 +0000 (UTC)
X-FDA: 83851939374.09.4CFED0F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2645F10000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:24:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GaTNs1fh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nwSXNTLJ;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756999464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxEntWNb+CKu0c6w5xl4njWh0EFy38q8FDmyI6UQOQ4=;
	b=6NuJfb2DEipZ3wAunTFBunpIhhsQUVf8I0CD2WSZwOqlZaZwpU30C+djVKc9CuC6p7Gg3Z
	amH7jA6J7FxZhJBxO5gNOCiQE5wYH+Q0Jme7lpAWT18EJ+FPHt2EKLiyjUkWD0r5LRy/Sz
	yuhZ6///fcEkFFTPFUzhPRCihhrH8GI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GaTNs1fh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nwSXNTLJ;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756999464; a=rsa-sha256;
	cv=pass;
	b=daz/9/lV6ufIGdirTO0KHdV08DTf8vqJ6xuAtiJkkjMfHchBN1GyX2vX47fOsI+29Bn/my
	pWRcL12/+MxULqw4BnWV8NRDSgpbtM/CXO5UTnYV9TycX8jZk03nDIg/5HRnmGtnr+GP1W
	2hN3AagbigmtI5xMu9X/PUt80nzTNgo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584F9pP4014226;
	Thu, 4 Sep 2025 15:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pxEntWNb+CKu0c6w5x
	l4njWh0EFy38q8FDmyI6UQOQ4=; b=GaTNs1fhvwhXc2W3gtX2XMWK8DjVQCN0D0
	fG8VlNxLYxHmMChNulkEIWg5IDgEzfix8MtG6Ua4fr8w+kTLJASM80iw718G2GYo
	SAcJl20XkKllz2pwdTjG1vihSPbm7EtylqKSkn0tAWsM+ugmSfUGYDUu/rgwJfp5
	UFSDIizH3VUnR25J581gi1zCHBlz6GIyPG6aNYKEMjnbcm8cCTdAajCZFxAY2Gce
	W6tj6lmFlGJ+pP2nb2sN29IUs92xUnjCjfbLlKpwC1q474nFxFGgXLz6MMHCsHei
	110THNi/g4U9+qBLmFvUt8CFW2h+l5NvznuU7dDwFCQNxfaqTS8g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd5s814h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:24:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EUZ7V040682;
	Thu, 4 Sep 2025 15:23:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbefjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:23:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uwxtwJePt5gwd8xe1Xmc+FWaB5fJaKqNHXxa1ybc1sDvrv2fbnnG4seVMWjW3JTiT10rNwhPz1TFIf3opOt6n3ogkjk9WQDqzgjiM8TtSWLt7TLqyU8SRIgcpBtvUbvkP8qV7e7Z8PlPuFMZxsPQ+Y9zPi1ZxMFXIcJu4+M8LfGjzSGkLUUgR0gqOAFU096/ku62kFAV/Gct3ATFS9+pIY87Rb/fRydHCTGqH6kizMt+rT7ZsGawdru6y7a/b39ux8rzBpGjhGHxLkdCG1JPmIiywcpUVrYuu9UdMYtA0T5kz7KCUy9RGMW2XepxqcgQyOILdZKC2v3sTqyYPhXPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxEntWNb+CKu0c6w5xl4njWh0EFy38q8FDmyI6UQOQ4=;
 b=aSdn4PmTDl+Bpl4c+TFP8R73L0OSKNEJsDGK5hyBT6MCBjLUHnpdRKtymRQThrgpcThbDoyDU2h6xNf5yTKJTthp8sI+8W22SPi53pICIiVWsfBqFh5N5KKy67XiClyRVzvIMs3fHREuUaWPqlv/721sJul1x1RF+VVYWTfXH0o+8PU0b4DP7hyXXhWMXe3cuXTrl25Jy0ePB2ssn03tg63oL9N1bvWcdPnu19bSa3c+7B2EaYfwXfbw2M/ShtL9abMY+mbMJAKV0S8t8AGEagBpSSut8tkkb4NSDixlmqsDtDCZGseWyvAa2ZfEkO+63VChk+P7zONw4lrr+ZPvXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxEntWNb+CKu0c6w5xl4njWh0EFy38q8FDmyI6UQOQ4=;
 b=nwSXNTLJ/rJaan9lntBy+k4NQ+PFPEwRHwZDgX4UseqCZnws3Pr/jFRWSDNM822Qu52PUHD7iDyZfchpktE54lX1qU69f2h8nPxcEtcKnxhCNhF67HYCzbpwOwyjvCgdAKFcxGcGDp/HRk2Mog8od8RtG0DA212HYMs4nb/+JXM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6074.namprd10.prod.outlook.com (2603:10b6:208:3ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 15:23:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 15:23:51 +0000
Date: Thu, 4 Sep 2025 16:23:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 3/6] mm/vma: Add limits to unmap_region() for vmas
Message-ID: <ed75cb72-82d1-4ade-99ca-abb55cc6ef35@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-4-Liam.Howlett@oracle.com>
 <a32ea375-f093-4f8f-9270-fbe9f7977cc6@lucifer.local>
 <w43jgvlabgvxpq2jb3zv7zo64r4xbvmad7cf75l3keests7djf@lmqslvejyyk4>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w43jgvlabgvxpq2jb3zv7zo64r4xbvmad7cf75l3keests7djf@lmqslvejyyk4>
X-ClientProxiedBy: LO2P265CA0109.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f49629-4aed-4c64-ef1e-08ddebc70dba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OWR0auYguaUaN8UgEH9cZO9k2/9C9QoxVyEu/LKEEzjriedUg4owIS8VfF3r?=
 =?us-ascii?Q?1HUp5tt0nBUmg+L+zjb4137SNVJUwI03Wb1uSIfxFyoUe1YJPi09RrUIns5I?=
 =?us-ascii?Q?D6N3CwLsnoXlEU5QQxgJ6kNVMOj77Goa6uwg7XfaWzbAS9Z2p+PJO3JE9ELm?=
 =?us-ascii?Q?V8Kj5ChFaRPK8FoU8UDA0u+doF5C4wuLwhpBcRQsHe6va+xPfzWmBHKx6Xf4?=
 =?us-ascii?Q?df83U2xhVXnO0E4jotLUOHWhQKD01yxWNl0BantRrE6QyrqZJgYtbJZqrwh/?=
 =?us-ascii?Q?wyiE27zpiQcfXXlMJiMMIcxDasZKgACF32MAvRSy5u/NWS9XQPBwN4O6jIte?=
 =?us-ascii?Q?o59xPFHCMkjkihFd5Z+nbt/v1alLBuuyti4hHE30t5yc2a4mopJaw2DKjiVN?=
 =?us-ascii?Q?Un2j8BAs3IzodlQ/LclRbSC4CNRsu1aBxSLW9YRpxqnpOuqleq1xXLN61Mds?=
 =?us-ascii?Q?iOG7Yg2WlT4v/R/sJyrQF7Dh+OzUlaKXAFIjYwAbNxlmeGr53Efcd1l35jNL?=
 =?us-ascii?Q?Uo62F7tZbb+6tmG+xVglCQH1QJZRNAjxcDHZSsL8SiMMGKAI5djoJK5PyJa/?=
 =?us-ascii?Q?RDysE0y3UuW2zqq74DLJyxPrz1JAzDFkULXtc0LfVMHgSQ05S4YP2uB6k85Y?=
 =?us-ascii?Q?B2GtkkX1LxwWtN7FSaRDRcI3VcTDPg4TBEYXaCndsdW8+exWkJsFPTuY5DBI?=
 =?us-ascii?Q?KJdJf4FDEVXDY3+HBZDLbdskAt0Vhxv5vG4VTLVtdouE/3uVJho3wobZQcmR?=
 =?us-ascii?Q?yaI0K3IftlkKmmr5QLMSAdV3Q+GAwQdVMEZx3U/NfFROZMlp0v2Vp14uCEMA?=
 =?us-ascii?Q?HlHs9l4ymNTbNqnSL48Eq1OyLYWWJemHIhRraJrEEQt8qIPeAmY8zN1txtf5?=
 =?us-ascii?Q?6dJ4pYGu6tHHWdsjopfi1YYPWflCEv2HB7N/3BwsrQ2gqyo2Pxyx9a2fl28j?=
 =?us-ascii?Q?rE/NTVNmXdxo9euSjHHHGkegtnisCbORislp7KcRBxb2BvpS7mBdzE9cx4mm?=
 =?us-ascii?Q?jgmDsw59PLu+ok+9UvsXRx6QL+xdmRZE+YRDVxVNtHAZYFCooeqPV+YSfiws?=
 =?us-ascii?Q?sCF8473vtpz9M1CDoN46QnktuCHgIEqNX+FAjPmF31rMRNzy7/bgG3fsegNw?=
 =?us-ascii?Q?uSb2S43ngUqFcA75L+UsP2PwoxC6bj96R7/aC5uvijqhW2VPog/B0Eda+rlI?=
 =?us-ascii?Q?IWagzNCEoJxLUQGzUzkCGzaF2G5WtXZ0QqJlqj3VuBjuFbmhR9qQMrWzERUg?=
 =?us-ascii?Q?vlwwKUVwREOxc90864FKJzEZ9sbugWjnT/0NVbczCFlroE8hgRnzi41hj0M1?=
 =?us-ascii?Q?iWJ9zhO3AMMtVrlNMthFpFR7o6HLdneHJWnJXfmivnffcYTXPC5vsfRKtrKM?=
 =?us-ascii?Q?bs5da5hpC8xHqnEiJli53Yd5R4CYhiIPHx8HCH4kkJuXt+oX2A6h1pzetyXb?=
 =?us-ascii?Q?2q2MmWK+y0F89pjKpVWaa8Pfng+fkd4q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hpsh0fVomlqEKh6O6ndu3xfkohppBQSoHRdw0wYTOMtKrepNqgoz6iIbwxvh?=
 =?us-ascii?Q?N49qbBshn728sVnZxSFq6XUrmqucC1p6S7ucbqA88mwkBnxFDl2VWQcSF8dl?=
 =?us-ascii?Q?1upIAbHkhu2B1m4lYdTXQpT9gitbDIPnZhjQi6Z0YO8ijiQ94EvFTlIgmdK/?=
 =?us-ascii?Q?3A2hTdPE+3mv5xngpYcfZvcVSDf9mY2WSJbUzn9hnH5yljq6EDxDw67j5pQS?=
 =?us-ascii?Q?67Adv/+D7Gh1t0G3+CKOAIuxmIUJGGDyuF2plE5e55eZ4u4Hgl9rNZy/eC0v?=
 =?us-ascii?Q?Lxt8Xg6qv2BS/cJCwnzIii1M2xgF1Q0rD/S76vJrf4jA0cvOP9G/FPAJfaiz?=
 =?us-ascii?Q?bGLz9tfNKkhH3u/nMq+42uMfVM/E0beID8rN5aih5Up4DjKR8Y8EO1X9kR5d?=
 =?us-ascii?Q?MS3YuqHjQu7sBjEtjlm0aeTxT+Bc7+OcKb6qcAO7FaDDCj4F3ifPY4K/TIOe?=
 =?us-ascii?Q?4AaQLa4arRewZtIkOWrG98bTaYNuTDGohjK3maE2syJWbjhzmcurMNtV+fbw?=
 =?us-ascii?Q?DoTW2UUU8Rkmi5EXN8vaQ/GzisGVTCwcstS4cNHImyhuJRXuEC4/988mYulD?=
 =?us-ascii?Q?9eJ8KLutjsh9GhYt2pwSdtTlRvaneVKzgN0P44Q3SEdr/uEglqQe+chJJ25V?=
 =?us-ascii?Q?7QxjSQZymdGMpUHXTgtzo98wKYKRvx2bNHl2Dek8dMHvty/EXK+aP4rwC0Kk?=
 =?us-ascii?Q?ZmIcJzLaI4VmuEwWcZlvOhJnWfjClIBU02hJiQOue2D5BFi4E58Eae+EYgIp?=
 =?us-ascii?Q?64iSHlJNaVEbZEEE88mcbkWMeZgAjhf9SunmTn85m4sIzAv57eCepJ8Y0O2j?=
 =?us-ascii?Q?Sc/el68IKtvEP7ON8O33YrlfteVj3+dhmTVSeujgW0lX1nz/KGc+B7m/zK6E?=
 =?us-ascii?Q?8u3ZqtTDXlyQmZTgH+UTyjNnolqJCb+aHtf2FlVUjJIPhww376NZMW0Fpk6u?=
 =?us-ascii?Q?eHlsWaMELHujb9h89BN+AasT2xAKChuWQyejoUyLxiMeJ0z01pZwN9rC1IEe?=
 =?us-ascii?Q?D7rRwMyTDCH232HdQ6gHPeHb0CCcaNVTMU5+X2xLh4UmitmCuhd4XFRaJ8/8?=
 =?us-ascii?Q?78TU15VQCGbAGbh0PI2gb3LgWmdkOZovb8cog4sfVc9JNuOF2gQL2nC0Mrf5?=
 =?us-ascii?Q?CIt204RmRIi15g3ZMzGwaYi1YFveOiOzCiM7c6IBdD5bH9WKAYZEXx6BjVXb?=
 =?us-ascii?Q?BT/DfNTy3F9z2vTH67hDazO26C3ToX+taQGJF6pizMCjoxHaHBcM4f0hcSg9?=
 =?us-ascii?Q?hvz0btfN8oIdErBtOY9yPM0BFaTXz2lMibyu7HF5rQN3+xv+4bHlau4ApTK1?=
 =?us-ascii?Q?ywuW9ZI+MlruKhk44OtNkyMvAmLblObvXcRWEQucb3/Jwy5UnzDfqKOq9cRj?=
 =?us-ascii?Q?5tPc2RFnCTd8C9XCnLFO6gpoAuW2Qqktwr3UQkJKxIhWuiQ3W41Mrlz2pI4v?=
 =?us-ascii?Q?TKCuTwLJW0dEuHZGFbmXBT62LbzWNuDKoWwXpjhWWUK9D+IqzE3cSlk2lfgc?=
 =?us-ascii?Q?rWBzg/uDfiR4S79eT4qbG8r+t7EHjqhLgeFN3KRyrAHUtaKkFADJm4kh/23Y?=
 =?us-ascii?Q?EoGDfNFCgZAHgpYfVTko08xI23SaWKuzsHIOvx5BkNxYruISCxCdvmbyLg3u?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sp6tKK/CsheEvwEuEa5xCJ9O3QC8Lb2qfmsIfxiZEyxA2OqJG8DB8R3V9tRpFevZmr7M5cf/MosHvlZCDbDuBTqLokLjUcvJGT/odPr5L83GhBJD8v6HlhFPCC48WYL9I6l/8WW0R+m8Xb0TeXuFLfk8SF8SIxUpKGH30Cb5S51yXtkj6eZvnf67gn1EsUuBLB21o7fjqkotybdcAXeUz0dUVsS/P/jXItUVOL+GOgK4hWf04HNhBbwq0jCRrsm4TrUAcM3jYZXEq4u3ifPm43a27m7I8mDI0mt+DqLAb4EDD8HUyNEML4KpNlLTloseeugBF+E3j4sCweAJUyp1PYbldNSvH56mOu/wVMHF/AJ4z+hzB7dgztHXahN01RIe3UwNjFXtLxc8M5jDBerTn/PLmhuGMraJ4lPxtxzOZHocNRcAzmBKV6WLtmgqDh49sw9H2klyeVwyrff9ovabCT3onmZhSQeKzyPuAIZdXLCsctdfxd8jQhWcJY1CDJX9WcnmR9jla+MfAgOidqkGCfwMYjyNnUrnvUx3UI6B+kXY/4Ah4QDvAcfmWovZDVsNgdJhR8fKLb5XxIV/XiBRYUBkNRAPXGZ9OqYUVTG+QLQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f49629-4aed-4c64-ef1e-08ddebc70dba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 15:23:51.8417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eFBSURW119zxsqqCLds3wEqHrUllk0MUfhjaVJvtz2F+1t3kAdycY/YCEsNxiNg+Nq8Ol+6cTj+zEmEgxB8AOAQlK/rN3AAsigrwmNz2qU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=932 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040152
X-Authority-Analysis: v=2.4 cv=RK6zH5i+ c=1 sm=1 tr=0 ts=68b9af14 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=MYsTyAQOyGR7M5yDxtwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX4LLQIIGjfE3b
 E+3k9wGOjTI/qdIES3I7fC96TtLHPWTfZLeZPcV8a6/Kp8owxoy3Mkw4b97dyEV60b4z1aAvM7T
 9Zt5sI6RRZP7cKkR+OuS9xoDNnqtOtw448pK5F1VgRqoqw6S9WmGr+uQqYNMDr2yd2pvFDJFq6B
 l+CSg4BxmhL3TpqccLKVWsF58gpFEziGIw0z5piCXdszwLAhvWfMMwrzYfc4HLJa/aACzJOPRUJ
 C1jg9uePMhvqoa6++tsry60aeXfH65UWhJOOR/G7cG5DTyabN0IWh4lN3NzeZK+leMIJ7WJ0hBQ
 YP+JR0jiHST+ubZN8J7bKMVFWDAEy9/f6b/ZeYR18lygW2XYdiDJ8451vzwtWQJiJE66qw2BwiX
 E6tNVNMu
X-Proofpoint-GUID: tYtmkszi9YfnLVPcPGl7SQnVN5oEwx0a
X-Proofpoint-ORIG-GUID: tYtmkszi9YfnLVPcPGl7SQnVN5oEwx0a
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2645F10000A
X-Stat-Signature: asi1bjgbax63tekqfnxut15koym6kwo6
X-Rspam-User: 
X-HE-Tag: 1756999463-375253
X-HE-Meta: U2FsdGVkX1/sMXHP2/ErLHHYAM1vhI8KKmbiUoQvrO/URvr86RCqObnBElq8cafW280ogbs9bpbodhhK688upkd2I4nnAlj5+a5kO33yjBifAUewbhmgwCsNM/14uo9mFJTgYZ4IGQs8skh9hBheEn3ndQeDQemK8VzC758ag2CJE3zSflPstt/pj/lETs9bMCMwGoVRlp6WO/UGDdrm/ISwtW8wO/R+vBLMyECwrG8B7eiK5T2LdV+NLj//3M5WRhsWKmFNOL9/0KMpV0lUKxwRuixH7Yy/M/1+5k+CU/OXf5XpfArKL+zcardgerm+/mwa0lPu/NyhavZ07EMarDZwIyW7p7gaVEx05WiZ4Evsi965P5RIanNiA/NDzdTa/xXy87TFmTR/aPh7j1Uu1Z1Po7WRnlntpUNHjC6j01LlvIpL+8dm/8IKFGWHTV7JtK6MzPU3/evVCKU1YTC87iZlqkvjjAy7l+lLFYsxNUO2zX4jrk2Ba2Wl6+l5tNzv9Np/C8HfoV/uqK8frfCOsYWe9CB7txpsE/nOPaTqTIToOSyiU7HQu2JnjfWGmDa3+QWhwtI5nJRDmontzq6nnUJMDCMpsD7ONooGEgW8NXuqI/b/tCx66AJob8RHSM/92qZHmyWchLWcGV42h5WoxX3Q1N5HOdcydpHW+nOibNrbC7jibN0nAXMxy2H7p+TqUGfEKjJx1E8yNV3Pe9me3dzsPTb62A605d/zoKVf+VfK4AUzzETx3AK0DFEVgDFiAUSm1XrNy0QnJ0sCxL70jMfODi3tMM7mDIJgGcsyIejplQPJ7fLP9S19PaE5rLYSjWk9a2vZsPYvU/qxjj33iADA6/CdLj6haHZJ8M6pQKZiir2Ql1QKz8wNh54lbN6XZTY3yxeuAp6crGwsNu3Mg2Xjw8PGkMQ8r6nFM0Lx05pujVFGOtVuQRlxHFHwSv7JBNiRl9tw8oHul/VL9M6
 5W5wAZxb
 DzDUSxrnI2G2dm2aXRriFjg7Es0V3DKQEZPIHNcaGkXim2tIjcYNRogOAxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 03:57:37PM -0400, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 14:48]:
> > On Fri, Aug 15, 2025 at 03:10:28PM -0400, Liam R. Howlett wrote:
> > > Add a limit to the vma search instead of using the start and end of the
> > > one passed in.
> > >
> > > No functional changes intended.
> > >
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > ---
> > >  mm/vma.c | 6 ++++--
> > >  mm/vma.h | 1 +
> > >  2 files changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index 3b12c7579831b..fd270345c25d3 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
> > >   * Called with the mm semaphore held.
> > >   */
> > >  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> > > +		unsigned long vma_min, unsigned long vma_max,
> > >  		struct vm_area_struct *prev, struct vm_area_struct *next)
> >
> > Luckily we will be getting rid of this as soon as I complete the mmap_prepare +
> > friends series (_actively_ working on this right now).
> >
> > Anyway, this is getting quickly horrid, since this is only in vma.c, we could
> > make this static and pass through map to reduce some of the horror?
> >
> > We actually can hand it vmi (and thus &vmi->mas via map, so we could implement
> > it as:
> >
> > void unmap_region(struct mmap_state *map, struct vm_area_struct *vma,
> > 		  unsigned long min, unsigned long max);
> >
>
> Ah... I could do this on top of the last patch.. that might be more
> clear?

Ack, yeah I think so! Thanks! :)

>
> > >  {
> > >  	struct mm_struct *mm = vma->vm_mm;
> > > @@ -481,7 +482,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> > >
> > >  	tlb_gather_mmu(&tlb, mm);
> > >  	update_hiwater_rss(mm);
> > > -	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
> > > +	unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
> > >  		   /* mm_wr_locked = */ true);
> > >  	mas_set(mas, vma->vm_end);
> > >  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> > > @@ -2417,7 +2418,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> > >
> > >  		vma_iter_set(vmi, vma->vm_end);
> > >  		/* Undo any partial mapping done by a device driver. */
> > > -		unmap_region(&vmi->mas, vma, map->prev, map->next);
> > > +		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
> > > +			     map->prev, map->next);
> > >
> > >  		return error;
> > >  	}
> > > diff --git a/mm/vma.h b/mm/vma.h
> > > index b123a9cdedb0d..336dae295853e 100644
> > > --- a/mm/vma.h
> > > +++ b/mm/vma.h
> > > @@ -281,6 +281,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
> > >  void remove_vma(struct vm_area_struct *vma);
> > >
> > >  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> > > +		unsigned long min, unsigned long max,
> > >  		struct vm_area_struct *prev, struct vm_area_struct *next);
> > >
> > >  /* We are about to modify the VMA's flags. */
> > > --
> > > 2.47.2
> > >

