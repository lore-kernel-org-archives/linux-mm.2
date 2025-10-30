Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5551CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 08:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA9A8E0131; Thu, 30 Oct 2025 04:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8CD8E0112; Thu, 30 Oct 2025 04:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562048E0131; Thu, 30 Oct 2025 04:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30C808E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:14:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C834113C03A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:14:43 +0000 (UTC)
X-FDA: 84054069246.05.18F6C33
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 473F41C000A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:14:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mLIPh9HS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JQzcdos4;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761812080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QbrTjY6nAj752ijOZ3wK/PEHOracwDDr7x4uzse3uk=;
	b=e0uW4noGFUpGMo6QMRulEH10DrwhKed/yE0A7ZaR0ffn+iLYzKVPIBHCAj4EyKwk2q5Lim
	+gbrSKcnMthTHy72DQVDcEedx5fvisZ+BIeNUEG+vz1P4gw/Y0wWhJvQa0oHWcvHCdb0SI
	Uc12ZDt2EscKUwuaq5ogz3H0g/oV+nQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mLIPh9HS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JQzcdos4;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761812080; a=rsa-sha256;
	cv=pass;
	b=hHGU4gpjReQz1JqNybvJf4ZSW9jBkLa09tASxLseTIEFMKgRFK1AWyWuDxXO7ybpa1EMoq
	qxdK6GWV09BHXfGjaRAlhQnjCkJilhIFOEujOPhgKL35MDlKLitVWVYlf87biunie1aqBe
	E7SSE2BkeBcQ2bHKOl+UNbwAYVYfU5M=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U5u7Cg028110;
	Thu, 30 Oct 2025 08:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6QbrTjY6nAj752ijOZ
	3wK/PEHOracwDDr7x4uzse3uk=; b=mLIPh9HSdIvA8A6D6I8raLvqP6Z3WJAgxO
	UrPEGDmkqtz1EpbS3LJpLSLHsbek95eJabYxjO3U+OJyTPsXnroURKPvR7nmXNIQ
	tx30K4rFBOVyIiIXhdrATmNDJ4AUMBxKz5vhQuWjlLUiT/BJiYT3bgpNeUVOtHIl
	YYDT5SFyKBrTd3wGyq1LMv4OI53OcZqe2CJRY/GZyT9V0VSP8dRDC6EQjaoWmJMM
	H1BKl4v1upVlu9MqIlesWuNKuKNgP/ec2hZLaLJOVaatXvHiv3nEhFQj6Bci1xzY
	KZzMGx1ZnTizzqmsQCdol45Sa8zxxhEFKZTL+9gi3+vZKqDTL0og==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a40rbgcgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 08:14:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U6F797016044;
	Thu, 30 Oct 2025 08:14:28 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010014.outbound.protection.outlook.com [52.101.85.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34q8rku3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 08:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kk0iN7BUw3r6mzTK0JSZDWzw5Ye4DeuZrIwXRJWa3vQMm7Nxt9K+knt5TmYAFQBU7pckptvYhYhzjIY8QP6dkgnQBHzKS0A5inXGD7YPR1ICcwsi7efYQq+oOZ21F+0TpC1ADuydj+t/gSTE1y6qv413MZI7lUleSp+QiUiln0HOu4iClL/x26ruNgwHrmgFVEs3fdBl8uK0BUFyKF5P2NlMZhBkN2PM1R8nL89b6KpsZM78XPM12xSkHzoUVfq/6u+TpB2Eo8OWVP+lYd8+Enr04Km+L4PQcAkG3duZq+zjeOQtzFWsYX8Nk+uN8uZEJ5FPy8OYsIEK4oD4uqwj/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QbrTjY6nAj752ijOZ3wK/PEHOracwDDr7x4uzse3uk=;
 b=Vg9FlZyIFUFvSFNiwIbPsEuEp7sKbEfLw/lAM3uHVAayoiYTddo22asmhhFRxr9vYsrof6fPWl4z4dYGQV0pIymPtXhhIZkHIlhqF0fxwksPVKhtJoB1Ae0viEiU1CNWS9defsMVpGKE7YDfWY97jqrpd0mrnX0O8hQGP/HgHxxEp8j7IDQrTP7kL1dSM8mwhA0/dZncfsYypi94B7rY8YrvojIgutL7UZMBGA2skN/IncAAelccvhPGMWOyRtwLVfwLAPkpv3lj4zyITSxbw6a9ypzk4FOMWQFAKuf7l2YUKt242LPFkCrjFKjJQEGjy8EIOVymP/0qs8cCRg2COQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QbrTjY6nAj752ijOZ3wK/PEHOracwDDr7x4uzse3uk=;
 b=JQzcdos4nWQ8lZVL3RMMQMT2d3lKEDpoh5NaA1OiTjaGO3xOs6njsNxyi1IVo2X/Qy+cK7Q07vhHmY9E8oNgLyPok0oCLRf8+4QeoDZMfcMWgLCb4vc+zJrYpf/UWi4Kkn4pLNy0shdMxA8wYZ1g2NzF2a7xtI+99MW6PjtsBrE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6198.namprd10.prod.outlook.com (2603:10b6:8:c2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Thu, 30 Oct
 2025 08:13:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 08:13:44 +0000
Date: Thu, 30 Oct 2025 08:13:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
Message-ID: <a6062275-20a6-4014-beeb-6cf8aaf47410@lucifer.local>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
 <6c273611-e815-4a4a-822d-f6e55cec3810@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c273611-e815-4a4a-822d-f6e55cec3810@infradead.org>
X-ClientProxiedBy: LO2P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6198:EE_
X-MS-Office365-Filtering-Correlation-Id: ba2fa4d2-4926-4154-7e9e-08de178c3e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Cl2ttRFT9sYcsztyIgLUEyAG/RwaZKKKFT94SFb5aonK7zqZT0C79FOr/cpT?=
 =?us-ascii?Q?xz2yd/SPDWKBDHk0DCyPzjGyqNWI2vXTeQx09qokpdryIIR96MmU6AAUWSRI?=
 =?us-ascii?Q?cxCzK63Qi0JYGSqDtfq7FOh0FcXkqOgtrJhtP9Gw3xj0+mgwjZwBcXriEtCp?=
 =?us-ascii?Q?vnuxCFZOjpcgaMABmj5rxhko2wfFwSGvpLukJaA2hV/OjzcQP1ruksp5+ts/?=
 =?us-ascii?Q?JFUnC1FO/f/Nc9P+pu0An0GNokWy4X+buDasV13Z6zPUUDt38+sDHHkzXCdr?=
 =?us-ascii?Q?1+ZYmg6lpJr1/N2mhvw3R3a1YAVNh//Y1umYlk1K6w0hFDgad3LL3MfZk24b?=
 =?us-ascii?Q?ChINAmrqdpX440nLQRhl1lI6Eo2qzfkI5HBiAxXqi++E1eethX/04ebru2ih?=
 =?us-ascii?Q?h3IsgIumbbmLRcd79jyGT/KEpmy9OKEMAaU1bbCPfBXlZXEYUuBJ0jTyx3Ur?=
 =?us-ascii?Q?bayBvLo6TK0NrTGjUAGNKOrJH67dJa3enYqOOh6bPAYHuy/QIDl/rDSdnyJo?=
 =?us-ascii?Q?kvRZkDeJ4KcT5YXnlH2LObAjmee1VLhrYs01UJTT0Wa/kF5eyH1tZSB1HjJT?=
 =?us-ascii?Q?PvNeBiNSy4BKL+tsUAvaf7ohkyOetdao8BwHB0QnZAqLZkHM/aak2pk3+4P9?=
 =?us-ascii?Q?Rl4kOxRNBJ/kHRLklSc3Lwg13Qj/ROeYYCq6Dhoog5QQWAeBbqUnd2P4sxO8?=
 =?us-ascii?Q?YApnNYIOU2Be68odZduMoab3vmGEdEaeGVK3LjceQWo0+tOARY4OI4yiIw62?=
 =?us-ascii?Q?D3Wu5artyr8SD1aaYeNnf6Vaizvkz8NQE7Zb7+238mUkiebJ2edO2YSnzLGS?=
 =?us-ascii?Q?Qf8cuDYoD8qIE+EiBEx8T0SqcNB5srUlqhRp3EjlZ1oTGOMUgvWFUJs+0Ya4?=
 =?us-ascii?Q?O5tXBnVyd8lOybas2HdrDJVVtgPIB/18HT/IitNLHYwkYyKsPfzWIWwAfN7W?=
 =?us-ascii?Q?gylM/vbMXdT4+IIRC2OZZy2yrxkgeM2vB2vL89bsY3IYJ1CghUCCwOLDV+BA?=
 =?us-ascii?Q?GaT8ByYf68Snes5O57yTkqsh3q6XYKpO3mc4Ett2E5QtAjmshIE862b/X4z3?=
 =?us-ascii?Q?EQV43Eb0XcIqhDJ9LL5jX5Hb7QqDLHzdV/IgCgPvFnGHiGIPgYefnEoLQNnQ?=
 =?us-ascii?Q?KqTZ8T4UTesBmhM4C6iSW39V1hZ0gWH+eS0L0x21RAP0ZiTZK1IQ/qEYbDBX?=
 =?us-ascii?Q?sd8MCQz08QKl5s905zNngITlqfBabkmSmsYG9wA0RkwUfUs0vkjs8MJjUwJn?=
 =?us-ascii?Q?d1rxZaee6Lq/WjO6WUJLg0KdvlXHATsmTNv2lXrEqDzsUVarrtWiWsqOElyo?=
 =?us-ascii?Q?ruyXxgP37l2wbHqSxKWJ7iJE2eRdEjF1BO30swy5dzx6s8GftcfGA22mIudS?=
 =?us-ascii?Q?3s8WulpuON8f40xPqumugr+AuQvmlewovXyLAV/DiAMlN5NGH4fJ60CVdAbt?=
 =?us-ascii?Q?nbEfgAD1X/cPAOlD88tTMuWsE6zngiXT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i0Yf1PwzXfqC2Qs9/VH2V0kdFc+tyUd2iyZqNEVg39y0DL8mrN+CqRr4mgVX?=
 =?us-ascii?Q?nbRFTP76EVpos1OlOkucJRvsSkJg5H6NDeATQ7bgdAUaCWzjtZRV2spvnwd2?=
 =?us-ascii?Q?waqmIZ96SXu4ticgEX2NbwsInc5PIt/gPi20X/DnQ0sdE1d8KBNRuy+ZXzGh?=
 =?us-ascii?Q?i7gqRpzfgAzfN8fySGTrWXEVt6uynCwP/k3uW/2gnrqjj67JeFQyDro+vpCG?=
 =?us-ascii?Q?EpLEIEyoXP5d38RMCsPYvuqMWjFjueGfRwAlzdbSCBZOYvHS0sm6n0jZnX7h?=
 =?us-ascii?Q?+yoiH/mxJ/SaekfP1GrJDMyGIBQ/9qO3oKo2bpFCuWZAtQLkosBtY8kNUXei?=
 =?us-ascii?Q?89CToSHplV55gEmdtamSOYS6TpiuPm/pc/07VtcbPO6/uQDntc3DsvpLoaGX?=
 =?us-ascii?Q?NRKqPj8DBy4ew/f4EcetCl/uvmi7WfBCbZbxG6PAGrMzaZo/BG8hX1t9ZovM?=
 =?us-ascii?Q?mU84tFztou2UkRcv67vQ8Gj+oXFlrGYM+XSAwF523TUMp2eBQ5oz13Z+IRCF?=
 =?us-ascii?Q?JMPTPbkQrDorLosh8BVQPVdqTi9xIUxKbtvwi7Zpg0wl9Rnyc6rGFFnPTawM?=
 =?us-ascii?Q?kKwpWGpeqMXcrn/3lNVsGwhjbHGz1uJNBgl90hGxFPnXRVRaAwdQ2UVDFijK?=
 =?us-ascii?Q?ZpVqtrOAFSXhU7c1oqTjZjYDxCn53y8u9rTbh7b26gLimSsyP5gNtk2I3rsl?=
 =?us-ascii?Q?arXCYpzOeRRD7YsjPqsMvExr9O4uKYlfpiSBxuGQod6+G03riTRlhUH7VlNE?=
 =?us-ascii?Q?SoN3+0Uffm124upUPsXjyUThv88LhJTl+TeCcfJwsm3ms8TQEOmztEAssEeG?=
 =?us-ascii?Q?Yjzw/zl7J3hog1iz34k+tImF4/gkea/8Lm1IGRoEGyGz0lHjhTKPffZflXT2?=
 =?us-ascii?Q?6tuUWwboNTMfU5IFhrP8OtmugYBnd/5XZeIzySaks5GLvDnZIMG0AGn9iWuw?=
 =?us-ascii?Q?qSa1D8zoixagPVEKwMOPnCVqY9WrTR/3MpOwl2Tp5ViHJSAy5qUjny8v2VRW?=
 =?us-ascii?Q?JyjMDb/tIFF9huxbxcLfYb8nblvsDm6jUp7F1ZFpljGUuZpxIbn2fGRdhHL1?=
 =?us-ascii?Q?9bM85PeIEJTIp2J/X/RbSrRSCLTJ7KgvO+GgKYive9c45H+NdSWlz90vvVNs?=
 =?us-ascii?Q?0v28NF1oy8sHtvPi7shAH9suQEU+4j/yfsaWo0Eh9Yg2+SwrYF5FeFchymOK?=
 =?us-ascii?Q?T/VkEx+EFSkV/AbbES/ARnN91w0u8H7zIPy+VvfbUzJzVw4Qu+pgRaQVbqTz?=
 =?us-ascii?Q?ef2ul0OSkcCkI9lgxneofBaNrUFAHFOequIrRBFH5Q4pUB+nu545u5ZHmK5/?=
 =?us-ascii?Q?Ry43Zqx99sWO7gTmhvuj+qnpL7PKkYqcCjZBJLrE/pmslxEQz6z2T4zA0dZT?=
 =?us-ascii?Q?f+19osw0d5CBzespnSXjucuhqLa7zP9CPaF7w4VX82kbHmpY3afQPA3uPBiN?=
 =?us-ascii?Q?LRddewzKQX8PXypWhnMiTuenu/pHidgq9qaAvRIOddDGpJJEy3iOftkuF6Ix?=
 =?us-ascii?Q?iDKdWfPR8M3Bc9nyQ+9W5bibKHL1sFq/KIE84hlxdcDLNb3hRsqwqV6iOqR/?=
 =?us-ascii?Q?c2iGVx7h+EYnzPvznnxMBWmBHyRvcuCoQ+9pogwQEPxCtovCfz7sY1gKaX9l?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lMe5cuVzTeed4lWmA3fNodslWTXFQ8rpqoP0W6IcIgoJN66YAWV21lnJEz8yTm+DqBtRGk/5bRtB3lbuegAL2M+gbutLL4YsQQt3kk8H13Ms1uWzVk9l1rFcQgQoRZWGh0Z0fncFDRsRU/XMmQGsCglxSOzbEtUb2YljUm3DxXtGwJQaaQbQXzw/1uXwAH8yRLaJkT/x/v4bpM372YuS7zApRF+KABHHWs26qMlpzld6APtSaaIsNXj3DhDOQ4eezWmC1FYyegx5281unRZa10Cm908+tSKkHP6rKypxzgcwie9KaFEnfiqrm7zwTlTlI7hQfww8EDPwSqCa7uUweSZpG1NVYF2yiDlo9SF1d3Q97af+S3ICAAIXLzVwERSXbHNGUudKeMXOMbWrLxnwni0naU/8I5R9fxCCVygvXdivddPk3VrVApGg8PaAx6JbcASDvz+wLT/JBYK15gWKzg6+InDdsNwACsGLQPS6wDOyswvN+30dqQ1dqweFFPcFR2ePxL6kVg6jnfNgpBaBVQlRTbwJM3TxPuME7lLpgqCX/4fOn4rjtEjqzA7efdIUMe1d0HRMeCbvttDnhvqMdjX1byK9tPvtoKYzyaCb9KQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2fa4d2-4926-4154-7e9e-08de178c3e5e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 08:13:44.3121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdYYlECH62sA7AvFwAy9JJkuK0od0uCXWyLTmVA+xA3uPOerMmkHG4QVvHA9hZbug7Hm05HQARmS2nAH47uLS10fiCaHHykaFf1uHbqAGTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=953 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300066
X-Proofpoint-ORIG-GUID: AbKrCRYKU73ixvxhDYc74XQTcVjuvif1
X-Authority-Analysis: v=2.4 cv=Z8nh3XRA c=1 sm=1 tr=0 ts=69031e65 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vuMfeq_oiUujA5svxkIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12124
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAzMSBTYWx0ZWRfXwX5S1Rlb4VPC
 fPgO30E4Aa5UgK+QbXbRK+w7TjJ9CxnTrFoDOOlp0i9uUWud3NtQAHbOCWvOIRdGpROKzYfIKWy
 Yu0ADn0i+FwmuSASSgd0druKdmdvl/Lv5XxgTo4VLhhp1go4NwcwP2/VJVx60CNmMp4U5F8sfa7
 GkPym6tX+GNuQnda2o3AQEwfYRvUg+WvRUvObvtEPo/8fZ2FLqFwMyWDA9EcvO7w1AB4r+/lm/y
 dtvr41rayMil05TxfC2tmywkyIHJKpmnUgAhtHmpecpS4SS/WpyaN7YI6REHqT1caowQ67Ik0BC
 ZrvM5J3ZmWW8HtJxy7ePCSaHGDseHI3IA0o/GiW2BtSbtTw2793kP6B2T5AyzhdY1wonQJyZlzT
 aLHIHQ3V/MtuzjX/roEmFv6LykBmxZPeNrtK/RfAokylvpvHbyg=
X-Proofpoint-GUID: AbKrCRYKU73ixvxhDYc74XQTcVjuvif1
X-Rspamd-Queue-Id: 473F41C000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5o1oexfkfh4bcg5n6hfqj4ireoxbor7n
X-HE-Tag: 1761812080-706509
X-HE-Meta: U2FsdGVkX18mHHpFblzGyTlNK9LJ9jMcrNzRZu31IXFN4zRU/KU1TQ3Pa//I2zwpcZoY8m9J1D5Xe/VIykMlTWdcufVsUla1vn/NuzyIKmd+jly0CZDqCse8b0P9GrM2txXtpzVC3SQnWba7JWSF9b57cxcDKabQx8tkF3XcWYKYpeHyJ/L81Rh1hdYynQXdQ5sCG2lPLjmafQs+ae9783YmriWkNkhiDgKkgY3VIk7zI6Dnzfhayves8o59YV0KTcFPhe1NEYyH2ApecvJoYNqmsittD1LCU2R4N/QzvSFJAHpNluvMa/D0KcSBdIz1l+oC9tcGyEHpR8lXCoDxNIS+DeUPwDsZVZkJLp8FABeHyBmEDozmynUqUrNf0fxAh76Un8kUUa5Sz19RKfcUZxfgGvg271bwFmawMF4AaqW1JxAVuiM+HgBTDRPqiIl3gko6cSNOCFCKJm+mMHM+hL9lEiFL3T4ybjuFhHZSJi4Z5olaU50X9Old0XJ3GoeQxC3Mlq2Yl1xRpGHYpdagwxEuOpr5TSuotl/UxqvgR7WgRVpiDY1qpi/jBukGZSGm/WHPCWS8KPvxP+O87GH/GwiH01ITU+BfXXH7bdlN/7Ag2td7t/eetVS8QAQEhsbTz7L3OesdFP9+gnZKAUJHWde2vWFEsRNzCH/b5XLPx1eAAnwJZMzZL6m8y/8j+hQ7FZP+CS3tY4sPsHryxhjl2BVbXjZHn+tkPt7tRsxd7BGcKutqb08lskQg49or4YjWiBMXw3xBmtxjp6g20B3zsCjoOG4G5Sxt6Gy+w1Kso/sTM/gBy6osZo+w3V2WAvzYiRWDUrisf49sHA9v8GHzyg2gbzUHP49xApB60ZgN1sTQPaaY6GalqKinhfUx+aRe9l+ozcde1Yv0EsJN77VMhu5H0rVojt9YdvGkAbz8pdlOHa7EkAaOmaPrzxCp3ufpPaUEBKEzLL4ahtDUSou
 13jODqrI
 PKfVQpjQeidh3HvwIGLAfoKJpRV0ID/prSJPjtK85uv6S5t36/AnxBtM/Xbb4iHaHeo4fhSQArfqLh6A8qwFyCwrawLT1AKj4/wbvKkg8NK9LZivKDc7Jfzgs5FCFno7VMgk5KypPAgkVulGlgIiWBADv9njb51PS5hO+yPOb0Nm3+Gv5eFJT7krD/G2bC/BnhHEIh7vJvwaGP0Phm0xUx1BSdqk3rLrW/cOURU/mwmfhc3isc7mTbfqkVGMeKCf811rO+P9Snkuw/M5f15YCyNyoVpdM+TNWnQ7c6FI/yg9TjnTJ3AXafl7dBp6Do2CHXUKmJ9MioXARznECndRhFazQRIjWO5JkgNgxl+ZmeaSPChe1KstGJwvA+sjE9DvVkC8KSuj5GNVZ60KDkpL0jBNkhoRpKvnxgStpRs5Eq5oLQt8DJk2tW1MS4gkUA9I0dJ8R1GkTkk/iLY+u98+FJ4oEJKseXd4h5r59x6oM0Yq//6yUOA/gRZy6/r36VLjTjkrU1hLY0EcFYjh86D/4Ota77BnRrZ1tFisDkWYunH/tJQrDM5OXFjg3E0OJyNZTaux1smsourg9a8ySgq7vhj/NfY2RVC4xSe5sN+fjoGJjdXLfnFTmu6BtFb96FNIQ0ijpJ0XAZludLpKXyRUN0vQUgZZvmse1dAidX/K7VU7SI+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 12:50:18PM -0700, Randy Dunlap wrote:
>
> On 10/29/25 9:50 AM, Lorenzo Stoakes wrote:
>
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 4c3a7e09a159..a2c79ee43d68 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1478,6 +1478,10 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
> >  	if (src_vma->anon_vma)
> >  		return true;
> >
> > +	/* Guard regions have momdified page tables that require copying. */
>
> 	                      modified

I appear to have entered some kind of typo nirvana in this series it seems :)

Thanks, will fix!

>
> > +	if (src_vma->vm_flags & VM_MAYBE_GUARD)
> > +		return true;
> > +
> >  	/*
> >  	 * Don't copy ptes where a page fault will fill them correctly.  Fork
> >  	 * becomes much lighter when there are big shared or private readonly
> --
> ~Randy
>

Cheers, Lorenzo

