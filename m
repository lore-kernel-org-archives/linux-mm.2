Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB28BCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3D98E0016; Fri,  7 Nov 2025 11:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085258E0002; Fri,  7 Nov 2025 11:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E405B8E0016; Fri,  7 Nov 2025 11:12:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDC498E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:12:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 912024BAE6
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:28 +0000 (UTC)
X-FDA: 84084303576.07.A72B6ED
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2152B20015
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OEEyyY88;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hWKfuh+C;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKZ44frATo2OnAk5GNawxfJSKKEqSPdN4w06/D4c4pQ=;
	b=zoutqdPY3pUvQ9m3Vy0wH+/veu+6xaN01MtD08FXRuUalDljE9V9v9HvGa41y/0H9dAQvv
	0TLo/yOMeAceZRzHCnLefXhJTeVV/DiupVBmSKZvL5TBAgoKjfwda3po4p7u6PEMsYfb1e
	Y0+l9Yno2c1tjzc6AqbNRTa2rofvdu0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762531945; a=rsa-sha256;
	cv=pass;
	b=AfcIHO5n1u9YIdXe1HPmghBD+pMHy/UjfJQq6F8t2mnEsYw/hyHryXbJFIXzyttVwGxDkA
	DvRR2TbnhPnPin8DK6+Wxp9Pzm5KG5Utii2T1VkawjqPk6jgx+fjSdp7Ai5UuVDWlsJLnV
	BVIH/7UcBiToX4iJp0PJ/WURfQOuB/U=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OEEyyY88;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hWKfuh+C;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7Fieeh030357;
	Fri, 7 Nov 2025 16:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sKZ44frATo2OnAk5GNawxfJSKKEqSPdN4w06/D4c4pQ=; b=
	OEEyyY882SpW6JpURKxXpNqtQfB2690r0ryVAmcWMoSvGV3/kakd24KT3IsMvnjC
	rXMGiUlUeGSpCv2/MWVhhpp3wUTJ1IXLsFGTvjFchYCDf1zVwlg0hfXt9M3+cw0u
	xooXFe6+eS+ivLc9J+e071J9kDpLFHJ4aYgNkDRKutmOLU2Gc+ftKQ0+qE/wWx3j
	jndy9v4DJ0mSulW5chLQAUgE+uBQlCulASTNN0ji689JMVGlxYQ/Z7eWVrh8DJPs
	aOUZsoqHHeqmrfp6S2Dmvu7GKIO130f31wCNr5GYdkmjkjDnf8U+1JxtWdJtejoX
	5agS8WlVTWGJEz7QRuGd4Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9kp3829h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7Ee2HJ039707;
	Fri, 7 Nov 2025 16:12:06 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ndpvwt-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=phehc5EiybDbvjXuPSgGO8JqbPuFtUmddnfVq23+CXaY30XHqnJ2yxh73t/vZSspcgEB98XuJjLqcg1CXBaoQwT7r7Oh3oJA9AZQpax2C/375ESKKeZJRpmHO1UlTTrELzogz0uActZI98oK7AuiP4h224H92UI+kFyXAZT99/taioHy4eOdPbYJdkcAYLUcmM+it+RwKNGVkY1fMoaCLFk+9j5GMkY6A4ExbnCt/4r+aPe458qze43TK6snhAbbvpp79vkyOJq4EEA7Rg2zaoNn7vMgJ71K3DMMq75GW2/8YqtfDfrA2srnwc9Rw7vh+swipHoyU0lib/zcGEMyCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sKZ44frATo2OnAk5GNawxfJSKKEqSPdN4w06/D4c4pQ=;
 b=XHEViccvJ5dau7Zakwkbzcv8gh5zMwuh/UmE8Lt8BXwLboGetzxo4Pttn40l6JNyZmcZQgfCO7pQxjcXfn4Ii8DlnJ1vauUbH0ebONWQK3dZtdvZh3DlqR1lrnZwk/BP7M+xr3GHyqi1k7Ek8tVjaJZzl4KKqNkJxfOOPCOTJk9LLoF8y/EvbPLfqFpeeYWvYhJJPvCYioIS/RmBTSUd6Dax0jivzI/PM9enL4LzfaRCXHV+S5/oV2Ip//LKSGZt8pzne41v14okn9nWdZzvbZnMxL38rMXMN3HblMCvBb7VPxZnzUbB1P6oV+wV9LWB7J5QvWUKaH6KALWSW7xK+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKZ44frATo2OnAk5GNawxfJSKKEqSPdN4w06/D4c4pQ=;
 b=hWKfuh+CnEE1xq3PDUjd5ipmj6mX9g8oAqv4i39v3Fm3ZIlf3LdciWcb2uQZGmd+f1zWfvjhaaZkph3HS6rG52+lq+AGgXuXyDuUjyltbykLIZAbdJ+d5+lVOKMqUShrjiztZWd4B1y9XVzT+zaE1zqAJrRJxw3FvCzyB7Um5go=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPFADA73EAD2.namprd10.prod.outlook.com (2603:10b6:f:fc00::c42) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 16:12:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 16:12:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v3 1/8] mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
Date: Fri,  7 Nov 2025 16:11:46 +0000
Message-ID: <94d1e9c6c6dd8a4de1f2a8022ca92e2e320730ff.1762531708.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0077.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPFADA73EAD2:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3645e2-d3f9-4f1e-a47f-08de1e1861f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U0Q79D2Q74SbNcUBZGhM7K8Et9ABWg3TIHB/7NlVSL7EhYieHuk8fxIV+7aZ?=
 =?us-ascii?Q?8GAf1LX7RM3+NV6uYIrXBwpH6oQg4SwrOSIz7tg0rUbvqNNgxf64S7vYWQW0?=
 =?us-ascii?Q?EsNMp5No1z8fWZk5WR7EBFWgNWEFQTiNoJaL7rKDwk/zJhHw97/YvjguCFGO?=
 =?us-ascii?Q?sIeYLFPwOFurWRegy8P3eThdjIHnoAz/KDZT9qZO6nxvJtQisqo2v2pxL8j5?=
 =?us-ascii?Q?2hmUw6n7A8lTG3bYVLEU6+tagOIUfO96jo59Zxmp8U9wsDg5FMQcC/DNBOdY?=
 =?us-ascii?Q?kHOat1jUGNj+1QshFkYjkbXUNjT4zHAiFyaDSNIMmSCYvHwBD8/NLVt/MXBa?=
 =?us-ascii?Q?kQ8rEkksSnMVuouwesAexWBgfEqQKQNGak3m+IjgnpsaZenZSKH4VBPZe/qv?=
 =?us-ascii?Q?dr97YUK8IQCA9g6cb9bh+1an7LdQvnf7/f3N0W7jWQeEBUVzTHy+/FMdRmBJ?=
 =?us-ascii?Q?tqYOJvUyI1WJIRzfKjAawjKxK1V8BMbPVXihMYd4XvxQy5xyFp3Otxv/gY8F?=
 =?us-ascii?Q?KBVp3MZD/dmOHnodP8BwB9Z3/eTSY1rtrnOppbivSLMBS+2udaNt9myry8i/?=
 =?us-ascii?Q?SnNfyWBB3Zd32XU9mWAG2PXIuMqA39HzGRnpckq4HyXmjq1jSYgB4Scyue/m?=
 =?us-ascii?Q?49tVWHCiA0TK3rEheU6HnD7AoqJQo/2gBejegxBYcgsoPyYmLMDj10PBI1U0?=
 =?us-ascii?Q?t+EnjiP2Ko+x2Wz5cLVlWviHZ7NCDI5Q01xDAkMA1UN5iSNUR0MV972bNN8o?=
 =?us-ascii?Q?0xrqn8JK/KhE7xjn0qbmCxNJEScE30j6pDPOdJEXgUb3wuItLsohpsJq4Eom?=
 =?us-ascii?Q?8wEtd9HStAH4nEPvYydBhNIpDnQcZXOv0s9NqHN/HRGCPpkSUSvyqOtnatdh?=
 =?us-ascii?Q?kcK5TH2cJ/HySBVWFrc1OAQ//Z1niWVLe0paVo7bjbR7YQv3JEEWL5E78baL?=
 =?us-ascii?Q?+udbS6SUFwIKPP7Nu7xO1i7kF46FeIxJk96OWxTFgjcG6Vf71ge24bBtPMed?=
 =?us-ascii?Q?+lePaa/Hd5ooxt8sF2e5sNsFOxtZ0FSXFo5KKwfjDt4FGPDZjasotciTvWv7?=
 =?us-ascii?Q?BPBDHvO9pKYBjEd5Cxo2ue+1+Yiqv3VyivEviNNjuxWwPJQM0LjlGoi4rlVV?=
 =?us-ascii?Q?h5Zh8YMFgWxBbiGAAtZeYRDXKRuAbiKQwqQc01J19MtcZs+J33Fim+EtObnr?=
 =?us-ascii?Q?uzV0NXRFFu26kSiUPmVHtcEykq5PO6vY8P1FkyQM3XObtXSmDN/J7Rjv2UKN?=
 =?us-ascii?Q?pvBfL4JR+Y/POeHx7kvJag0teqaqzoZnb/DsGOZ6vhxvnAfRHSoB334rrNFZ?=
 =?us-ascii?Q?F17QgRxZJFAwbSINW/35dJLqVbAhLRacyqqCyPCCiJjh5JrjKk2MZXsBihuk?=
 =?us-ascii?Q?dld4DxM4U0djhMgeoVE7N5tY2ngEIrn9bb9sj25aN6KOyFkaY5aZq61mE3U3?=
 =?us-ascii?Q?lJeVbszzx+XR5JTzRFRYBCeEJRcWc9PP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uAsJujWbauDEKvWUoMiuDSjHc+De1u3eQP6NhzrRpbtm4SF6codlphEW5x4k?=
 =?us-ascii?Q?NQ8NYxA5+JYUjOherdfCkyhCFyp6dy8rdcDXabp7mk5nZnqbutzWu5L/9Wnm?=
 =?us-ascii?Q?9oR+ZEgmYj3zaz6LREqEjaeJb1rRl2DdE9pYMhTj4f/YRayBNi76ZYkxn+mD?=
 =?us-ascii?Q?eNTqVgpbtcActyEwklukDHEYkIvWH+Ao/XwgelNMftXphT0m4YXQM39MwQhW?=
 =?us-ascii?Q?2sb3DaCOBEUwJ2cfiyBDp940Dg1ADXa3uZ8VLy56AZM5ZJMCHLRuWo3QGBxP?=
 =?us-ascii?Q?MSs9F7GpY/2x4A1Q43gDUf3ISerd2QWDYGKQKfe7CnK0dcRn61Rrs626kebJ?=
 =?us-ascii?Q?bpDfvVvFgmrQ/ySrqcd62epYygKDXMpnEU6AD0XbnfViot1sYeLQdEnE48DT?=
 =?us-ascii?Q?g4ACf0VsYok7/i/7yaONlR1fGoaMOfObOVa0DTe6/pwvSQlluZSPST8An7v2?=
 =?us-ascii?Q?CKCI4vZK8dyj2ZyxSoO7bDLV07sSlyy+v6s+sV8Pi0nq0EhN98StjdGipvxd?=
 =?us-ascii?Q?BPq6WZbw0060I+ZvydX1MslojjlMh1qEYtJW1JUN89t4vVo0GBgHooko8Avt?=
 =?us-ascii?Q?O5XWzIf2AkG0+kBp4lTJajYK1FBAjLP5gXh9nV+563k/0je6yOb36RgRmoVJ?=
 =?us-ascii?Q?wUiomk6ByNoU+VcdlRhMnEkFirUOHFAlFisYl2FIAh4Dv5oLE+vWnMeBK7KD?=
 =?us-ascii?Q?HTijw0rH/vSvwmYAMJ6dLQt6wqYuxE1ov/DH86hSxwS35So/H2+spwrKhrIE?=
 =?us-ascii?Q?PudclNWIUuLJWH9Sq7SemA4/7C2RBonS4pVh3dQ3rpPmz4M/xeui/lMQLXkd?=
 =?us-ascii?Q?Oo33/7cHw6/s2PkpaWcP3Bm79S0q7xEmxFM9LcjcQU288fuY6OPGalD6JLR/?=
 =?us-ascii?Q?c1ZOrH+nEQNFnjJHp0x+JemPjJ9siQNdh5I+QrqTyEtRdgvN2O0HrFDTq/Gf?=
 =?us-ascii?Q?OHgE2yBOAdeHdfTKA3++nCdJue+psqicSTD/ahB9k5EVD4hAxjI0Xl3pleKM?=
 =?us-ascii?Q?tfxqmnEHJU6pIshzHMtzYv5IaLldC5Bspw1pjyMK01JFKuxctOBRYJDlkO3b?=
 =?us-ascii?Q?k/9UvaVe5TbkX821BS2W5eTI4WBXlIn5+1dGP5u0CVnFATA/AITvzmZr/bD/?=
 =?us-ascii?Q?IH5v8//t7D3tryCR44aDiVz4joV2er5WyirwHHS3Z65dhtzTjPc7izLqkeBz?=
 =?us-ascii?Q?/KLdC4wtlz5QCopSRb3dzyXg9heGFH4/3lHGWBrCo0GfyeA80OFWtVzZZ0Zf?=
 =?us-ascii?Q?uI4O0ypfwbp+sDKU0ja9s3t3oxrMwiEV/8muYJPgmD3lo3UsK8Ilgg9hKovI?=
 =?us-ascii?Q?IwPGz4SS5gIxue1yTxr2PBm+e0fb0qZByYMzPdofMCXQF4oCbPstrSUcUzyU?=
 =?us-ascii?Q?2aixPwlQw22YpJ3KTivJCe8Ug4n5/e0xUrPFbKj++/FkMK/0nKBeAAo+kjcK?=
 =?us-ascii?Q?Ebwp25uQkuGN0jXV+3E1BGnT8iujzeCULQLgve/zj7WGRx5PrLjsn1sX0uOy?=
 =?us-ascii?Q?xlrMlfsJ7dDH6A9yfPk2tk9o2iDsnHMROj5l545Ai+YeWt1nZnI704DGq9hb?=
 =?us-ascii?Q?D4B8FoSUo4G8Rp5yfgeyO0w9A5uzA6VC3XLJaodZxa0ZsGtyCYb1R8tylt5G?=
 =?us-ascii?Q?GA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HnPDrBeC/p/DB5uxGC7e3qhgZxdNfbJmaxlqY3mfh3aaiDpMTK0y1gHnwLLMzUsmvqE8K6YimJgkPLK3f3AUULti6jz47+i4j6n+OdZUclTMZIBh2ZOpM/4v+duE3+w1O+XJCrBWF7PjWWsmM54xbdeJEvyMo9PQaw5WbD2l1OlvxBk/3SeQvtbArE3eu+8qE+3YE0DPCxv53UHEbs4bX263AY5w3TezGB7w7mi1VOP9pr6uIR+GuBPSvHSYTzPGUr9IXjWIPlUPjsDOVqThkTcGklmvS5aPPsw4pqXDw5DDd2lRUtTB+JQZ/+V/z44OZHt5G9E6VsBwH7/YmsYCVUR8nEKMxc1zSTm9CqGUiCGygecEQzbzlHwwzEuqYonxCXjJiH9+zP5K5JJu/Ynvfe8AjehKSjLnr6xG8cwRZu1MIr77SfNXoUOd+5cHnRlsSG85AzH0LdsCyPhEEaZMMjk+cD5gs7FZtgNQkjUG1BQow9eTCJubqVVkzLB0tAcyVWO52BVZBDttaHocgNOVCsXoq2PC6wbopn3BzKKyj4P5YypZUfDSkIP8ZI/D99zgHTJ0aOpIhSH/In9KaMDpSb1uYPAO/qtQm6TT4cBBPcU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3645e2-d3f9-4f1e-a47f-08de1e1861f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:12:00.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXfiQW+ZS/Wi7Z3bsRNTL8gYEiILxPEL6fnsg1e43eiIBgkTwDtn9zPoOUIRBzSywR5fm0XKbT5x4Lvla3g74ITkQgu1i3/1yySAk3lgFTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFADA73EAD2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070133
X-Proofpoint-GUID: X2wwu_HArp-AusOexNs0ZDT7R9wJhEfi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDEzMCBTYWx0ZWRfX3jZL5mo3SI6w
 LhW0dAvXa9bbFl6pEmnwAcOMKOvEjCHY26yiBQd2GeNRzkX2WhMClzqJ4TZUqggRWcVitieAH/E
 FNtBfDQduPI/H5wt4NnZdoxUbT/TKVUj1XPoHSFEGMENwmG47FbN1amFDW2GkYfKa+MpCyX7r1v
 xS4Oiqeemlyv47XuerGJiaA8fmbXNyX+oITenqwiKXS8gAqkTmzHP25iejR1iu3UfI3mg+bHlW1
 3DE9KLkXuiKSgDg9lek/GdgW729YgprNBq9+8ojtmFSu1CqCF4T4IEaMRstIdPeDJlu7xA+OszP
 7Iz3eidgRnySM6dvpsaiYclFwVsdNHfyjjO+zrZZQNSm8oZ08/foGi1Yk8Ap3cQz/+r5ft+cdR9
 /LKZCkOiPGvSEfXN7YYAwM/UPQffoA==
X-Proofpoint-ORIG-GUID: X2wwu_HArp-AusOexNs0ZDT7R9wJhEfi
X-Authority-Analysis: v=2.4 cv=Is8Tsb/g c=1 sm=1 tr=0 ts=690e1a57 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=lkmYoepbxJn_IgOSQAYA:9 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2152B20015
X-Stat-Signature: 78x6xye6735risofrb9b99iwphb8kcp7
X-HE-Tag: 1762531944-348451
X-HE-Meta: U2FsdGVkX18MMVZRjPhy5rPNfwT2NJrdHG0j+hrLGtl9h705WSve5hh0i3WU8LseAUGwiod0BiykfuRZYmEkExEgnEguqlrdKvEha4NdJmZZx6ShT0SEiY0hLEnKDjf9KKJncPgvJO1QsbNoiprwtRjnp9YWVFQH0xGfvGdr616pUYTAmHgRG1c3DgKUgFoVw+++tDAZMFPU0E8Io83Dg/vU58s4C1rXXSDohAipISraYGIXD04sfCbCAbmEct9mnAPrHNC/RoAnnkNmXrnKf+n3jdCOw3jRcY1qB4UXPxKj7Kw8GxmOLsj9YMztYjDdXTlnPO8NtP2cITWocq/5vi+FHPsdlF9Ja5CSl7W7VH+MHKFKUMygJ00aaTnKrqE2E4XkWthE0kjAxjKlSfG8O6WKrr66H8d0Sm1r3lHL9C3QDtau3byCeUR00jq1SLR6Af7uwuvJ89KXO0YvsJXJIWLR0M0EXVpW2c+BHFVpD95OwCpzgY+6zwvrjDgEZMuisDf2ZpywtWsruRV2bR9l0JdEF2maWGz2FBsyJnpoiYJ22vGEzIcM9meYCkKFHq+iTTN/kMm+jp21aKpc5Bxr1vg9jnO2lEkhQwoY+Uaixc/o1AMYzDoCDE6GGrFJ+1Qi4rZoYuc7ZxDxG+RMKg7zeG+TdDziBek+9aT2rjE1+AFrQfR1MmQGYvGj3fV88bfTVyZdOkKRzAQJz1Qxjs8tqhDs/uu3tqXQEaaeYkEjlLaHKFI5Otwco3u4CiW5FCN/pgVYxyEuC29nFGUCDHIMQ9zp2MZwLKlwZJe5V2B5Tzw+6PUAJxyY8GeOIzs0SlBXeZ6nDZ/4g/lTh/PZti+UZgB4r4HTYQYf47TGyd2XueZIo66O4MnRRGkfuQgSwL2ARcLeKct7+il88zemW6Kvo4+d3WabVgNbwDclv/KUaB5SDyKWkZAprJN4JGbObt1cJ2vOYCHRdlMQFx+ALwK
 TiAnExp2
 /DwKvTZ0G7/QhzEByto2z08GigTGY5JreyVaKWXfNcCBsyllxvGvYI29+dKSu2AVTa38AI2TcGI0nTSc91F/ypI0W6bFGcjKPKxLT9zjUwaWMltFMu6dEAkwDaVfyEcX3qyGWd9ub5P6z+57Jg3MYkX8yuN/x1MJss8EgnIqIKqInS+KXGgr23q/U/9ao1AZFlpzdgC9lHeJwcJDzQvZAu14wO+mjvoBaf0cYZNSWn1A+Q03rCSozbB63nozX3O20zasZa3Hwa8gaHVLxc3oh+L0352sPXvrHR6N3tjzzdgvztYXeIah72gSdnerM6s2XLsmC5NXKB/qh6GvzBUoUpPraP7TPvyGszCpFPPQthZf16kbZ9qfnggIu2GpqRign5yOZ/zo2DcX4vDgmqQJ3dGRMc0Hydwx7sgvM5JHcCpn/0Z2M8jtUPf5dM0405btwpHjFWUMi3jb86B3jo4oyJKOUNSkSJd086kWl6kmezWg8DXARIIh6QwM1hzEg0Mj2VZp2xdpb18X8NSik/GOhX3zR4I2SwLXJf8hD3WWzK9yA3AoPGZq0eODr26HFBUh14zMGSxaHomcfRTAwfIqj4jsaKNn9mtiIZypmkya6u0sO1CQoZ56Crt5wrV7k7w1A0KBSgyLrFTGD+xwdoA6p5BRG9f+LSIdnPt9k8WPS/VJDtVWLish8SfPXVAqpUjSGnpdoSC8umvuoFx38Fto/cpyH99+cooFkytXs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, if a user needs to determine if guard regions are present in a
range, they have to scan all VMAs (or have knowledge of which ones might
have guard regions).

Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
pagemap") and the related commit a516403787e0 ("fs/proc: extend the
PAGEMAP_SCAN ioctl to report guard regions"), users can use either
/proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
operation at a virtual address level.

This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
that guard regions exist in ranges.

This patch remedies the situation by establishing a new VMA flag,
VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
uncertain because we cannot reasonably determine whether a
MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
additionally VMAs may change across merge/split).

We utilise 0x800 for this flag which makes it available to 32-bit
architectures also, a flag that was previously used by VM_DENYWRITE, which
was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
bee reused yet.

We also update the smaps logic and documentation to identify these VMAs.

Another major use of this functionality is that we can use it to identify
that we ought to copy page tables on fork.

We do not actually implement usage of this flag in mm/madvise.c yet as we
need to allow some VMA flags to be applied atomically under mmap/VMA read
lock in order to avoid the need to acquire a write lock for this purpose.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 Documentation/filesystems/proc.rst | 5 +++--
 fs/proc/task_mmu.c                 | 1 +
 include/linux/mm.h                 | 3 +++
 include/trace/events/mmflags.h     | 1 +
 mm/memory.c                        | 4 ++++
 tools/testing/vma/vma_internal.h   | 1 +
 6 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 0b86a8022fa1..8256e857e2d7 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -553,7 +553,7 @@ otherwise.
 kernel flags associated with the particular virtual memory area in two letter
 encoded manner. The codes are the following:
 
-    ==    =======================================
+    ==    =============================================================
     rd    readable
     wr    writeable
     ex    executable
@@ -591,7 +591,8 @@ encoded manner. The codes are the following:
     sl    sealed
     lf    lock on fault pages
     dp    always lazily freeable mapping
-    ==    =======================================
+    gu    maybe contains guard regions (if not set, definitely doesn't)
+    ==    =============================================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
 be present in all further kernel releases. Things get changed, the flags may
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8a9894aefbca..a420dcf9ffbb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1147,6 +1147,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_MAYSHARE)]	= "ms",
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
+		[ilog2(VM_MAYBE_GUARD)]	= "gu",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6e5ca5287e21..2a5516bff75a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -271,6 +271,8 @@ extern struct rw_semaphore nommu_region_sem;
 extern unsigned int kobjsize(const void *objp);
 #endif
 
+#define VM_MAYBE_GUARD_BIT 11
+
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
@@ -296,6 +298,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
 #define VM_LOCKED	0x00002000
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index aa441f593e9a..a6e5a44c9b42 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -213,6 +213,7 @@ IF_HAVE_PG_ARCH_3(arch_3)
 	{VM_UFFD_MISSING,		"uffd_missing"	},		\
 IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
+	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
diff --git a/mm/memory.c b/mm/memory.c
index 046579a6ec2f..334732ab6733 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1480,6 +1480,10 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	if (src_vma->anon_vma)
 		return true;
 
+	/* Guard regions have momdified page tables that require copying. */
+	if (src_vma->vm_flags & VM_MAYBE_GUARD)
+		return true;
+
 	/*
 	 * Don't copy ptes where a page fault will fill them correctly.  Fork
 	 * becomes much lighter when there are big shared or private readonly
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index c68d382dac81..46acb4df45de 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -56,6 +56,7 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_MAYEXEC	0x00000040
 #define VM_GROWSDOWN	0x00000100
 #define VM_PFNMAP	0x00000400
+#define VM_MAYBE_GUARD	0x00000800
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000
 #define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-- 
2.51.0


