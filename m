Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B232EB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06726B009B; Fri,  6 Feb 2026 04:35:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA9C6B009D; Fri,  6 Feb 2026 04:35:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C556B009E; Fri,  6 Feb 2026 04:35:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7806B009B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C787C2846
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:37 +0000 (UTC)
X-FDA: 84413524314.29.8AB5B3E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id B59F91C0003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cvpdH0Mt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZgVH8kUv;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSGwE73S3syIQ/5NHH76MvNCyBfZ5obiZUkjfQQ/osM=;
	b=WR/I9LQ5o7XALOqAKVjVnCYqwOmW2xSXQ+2NCh8K9Em11SjZKEBMn2vZ83WmctVhUf2dp3
	MEdWmMHJA7HTS9j28A2GYR2OSSlCjvxadNBw3y8aq3/Ruf2hOOO/WV0f+evOiO0XxkHmIX
	7Rp9X/6IyY0Fv0juJMgbzQaMUbKgtiY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370533; a=rsa-sha256;
	cv=pass;
	b=jqAr0SCREpnBT5iZqYPEso8+i64DplNQgf5j26KNx2YzlSQjSzuzL0RPAXCzZ1yevbR6pF
	SXIXh3aaSI0tAZOAguffM/lwbq5F5W5t0zjow4N5bq+nEL3GBwnCDJiu1ccq4KrjohqYjJ
	7C0oh+yqrdUtMcKVr3VyKI99FPS9hm4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cvpdH0Mt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZgVH8kUv;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6166ZJau559883;
	Fri, 6 Feb 2026 09:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZSGwE73S3syIQ/5NHH76MvNCyBfZ5obiZUkjfQQ/osM=; b=
	cvpdH0MtuVBK2rM3DLRuBBIYntKPI6yxxU7HD5CKjyW9LDKdZshFSpJ8Uf35ABHD
	IBLdE4sE97bDZEmFYzu08FuYhzSuK7VDvdezEyaNb5NGXlZW61IKpiC5ltBP+QDp
	bRy4r83NuCnoHw21mLI7MhJ9BP49BqR4YUxspSYwaqc7qdwaC3dgItHfH9NChFa5
	c0Bs9RzPIrOG8hSvZHFPhP+PJzdPNm0CjcvfOP6S8e494tcHQcP/G8gcw60NEAC9
	tLoz+/F0OJgBeaguHglFMNm6EV0PLrwoANr+Y2YLtkGOlPDLvXXletjVEfqlncHn
	p6Saxuuj2g390cvRfgivgQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3j8un7cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:35:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61676cW5040084;
	Fri, 6 Feb 2026 09:35:08 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012030.outbound.protection.outlook.com [40.107.209.30])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c55gbx3ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:35:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=emkLpEe9T1FsNZWJXW94LhOVIryWa+PgulXga41CSEqOrh/0szM0kzvOvChBHo7OdIFfHF0fdSAOHvrib1ml42smRNim9KYnA6Yw/efAhDl7tiIgcLs6SQJVI5hx1oG94Yt5HEprTDnOTuNEaQRfSwXCLONZ0ltpD9zzhiXkl7DL34GpvkOjnBj0yrDtnviWASCTs0ioh444i9zKXQQbnyN6RLMG4vOU2Dq5iENaQY0NH322XL62yu8yczZd3rgMfHDOt2bDhDtAIUImK60JHv8jL2TFvePkfklzl+ExziPxGQkT3uEoqVpPWKwsZFEsh6ZzVXLmJLz2e254nemSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSGwE73S3syIQ/5NHH76MvNCyBfZ5obiZUkjfQQ/osM=;
 b=JTWOPgh5uYuqngNYz9vRE7PNWK4CRbxMUJ0dWtWTEpbBiRMW7ZfSx6dvWZYo892ujw2iz3zo7SIKiHxqFKZQVsC22tyLXVG5iS14Ljp6lWSkTQmMcCQQBPdgshIGQViyqBCd8V7N/aoIxMmOmv05DZx1caPqKmdnPU3Bb1wOHTHDxCNi8WShLEQNvn+QSt7VliipZYUspRXWGbFx5WBPmj7CKhDIrvo6Yn9r5/5fyPAyqim/XHc2Y5dT7KljJQTshc8aCW9TJ3va8QIrQ6yXFrEfoB1e7ymtbgVhSc00SXkCcrhrT8TvQ6QOselKmdQ8x8CV8K3mMcl1y8FJz3THnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSGwE73S3syIQ/5NHH76MvNCyBfZ5obiZUkjfQQ/osM=;
 b=ZgVH8kUvx2e+Z4j0KUgjPZHUo5f5pMkrwXnmcuLjltLuzrQiaLMgIYRCAcXRi7deQa2Uybjm8uTO2IBmIHlt6rphsNzWD1XQlks+6CrTp8QES0Ar7mZtpokc93qFRbdGmLwoSzksyoSp1zY2wec2V/YAC5wuoB0gnrFQM0zkx8g=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:35:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:35:05 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
        Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: [RFC PATCH 7/7] mm/slab: make kfree_rcu_nolock() work with sheaves
Date: Fri,  6 Feb 2026 18:34:10 +0900
Message-ID: <20260206093410.160622-8-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0094.KORP216.PROD.OUTLOOK.COM (2603:1096:101:3::9)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a928da9-75e1-4ae9-b7ac-08de65630255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CN9kxypuyfwwgB3MynV66MImLP5X2ijhtSNhcwY6+czRQIUSTAawmf3xl8cd?=
 =?us-ascii?Q?OfTI7XDehehatkWCfE2c+dzaq6UEM64hpCBeKriKtKh/7osOr2Bf32s9zD4k?=
 =?us-ascii?Q?6RSAUNn0gZqXsTk1R7EU+sLMvcwosWkFkrSGqViiQNZjC2iJ3IJIY9fwdgCW?=
 =?us-ascii?Q?JAeifchjvSF76SiqxtXHOGdsmQqOj5MRsou/pWwE6eYQQP3Ip5u5aXgMXvIF?=
 =?us-ascii?Q?IIy5mTmlxG8Enw+HkPyleuMZMVYIKdvenjPRENPKSA7Zc42fBqJiGHjZlNHP?=
 =?us-ascii?Q?nN+/TzdOciJ2nM/4/DydqUASR08QDkeAY1JYNyULYgpAlcSLTVhGZ/cGf+T1?=
 =?us-ascii?Q?+rqPYxoin4iyLR460qqHU3St1Nos4z+/xEJXjdpbrsCsLxF/dTiehZ/+7DyU?=
 =?us-ascii?Q?ldYo3X5AuKm+lzPZxB0ZHk1HMZI8olXvBkRDUVTQJPcSTejMzsf87mz62HMu?=
 =?us-ascii?Q?8EF++5gXsomMDCTJbm7ELdZP/0LBG0833jUd2KY55HLilo+Z72TmCiU2p2H/?=
 =?us-ascii?Q?ctJ64nhHULr6aj6jTEHDCiAuF730+dUMCfUWzqtoJX7xPqrjrxPSk9I8SOtw?=
 =?us-ascii?Q?dWDkPShz6Sbk3BoDaFO1QHnB8Nmkw9zZYn1HApvt+8l9j0ApGYyPU0Qd60N/?=
 =?us-ascii?Q?0Zf8/5HVLZA1P7dlk/7lE7rlmfreXs0IJZP2Xg9rmuXpt3qKFljZlzI5Js8u?=
 =?us-ascii?Q?YRuwvmHxc83LtwXToYTgZyujmp6lvQ/Jl2vNQA9DR6FDcF5DaSzclZBqIncD?=
 =?us-ascii?Q?IUIx3Pw4fXkqIugQ6T1ZzzpWEQzjMI+f6qje35xgWjDEGdcJOrf7yuhKZ3Ql?=
 =?us-ascii?Q?RQa1mC2O0/ZO4HSXFF84SZ5OxszLMemG1aBfPzPjugkyirY54yaTTuzxt1fo?=
 =?us-ascii?Q?U1hNmUrC2BP5sSH82+vitoP/skhef8UCT4cdtoLwm+CyGS1C60Jg0hc5PhjC?=
 =?us-ascii?Q?9nAOIBiIyznZttvqNz7h+STwtkJY9QbJVjH9Y1CWsf8hIcbOBwvMkFVik6iU?=
 =?us-ascii?Q?49BEgiGAebAiUIln5bOP++27c8jD2cUelkIY9b6y/TOiF00696viQj1nKYM1?=
 =?us-ascii?Q?0aRO5TItIikOblUEGDog1fYj9+d0DuDvGnaBMInLbLFfzoqMKgPfL1sWACYM?=
 =?us-ascii?Q?l//7anNyLK2qRUu39pETcMpd0gE86tWSSKPS6UT2bhOQn4BxpPtJjHaXqIGE?=
 =?us-ascii?Q?5gZFLkfN4BTul6yxeDJaKpIcWxnHoxb5lhXzgwP8JfKZYicBqAIy1haTUx1R?=
 =?us-ascii?Q?20UfsCGlYe7e2QdoE/9puaLVUASOmb+Xc2Akvm6dSX9W5c/9R5QNCTj8AAOv?=
 =?us-ascii?Q?+HmJHPopMXUvrBB7dZ4B2nLSCuzLZvbe57I4pObRCEjrbOA1F7bhm11x35+M?=
 =?us-ascii?Q?r8WLZMSDVtzwIeO2W0WsB/djhzq3kbrjlm99bnpDqAtWEfZa2QoPcy0GR8C6?=
 =?us-ascii?Q?gev8UwJhdL+UYZM/icVlwouC1qUTE/hMrnQUoAXJN0/SSs3YckTv45kJcvMp?=
 =?us-ascii?Q?npLIEUn70+VLiN2AO1xcr3gsxtQhZWCt/QEtf3O/VLB1DzXdUtbTFPS440cz?=
 =?us-ascii?Q?NGV1TdQzOehbWdQMnwE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FB27WwXcHh6hDSt8S9oSnvAX5SoqcJa30ETJ3jUNlRKvTvmYbPNcCBVQthSx?=
 =?us-ascii?Q?W1Ak4yPWqTjR4ss42VehRCh1pILpa4wWKmXtLrppC7Zr7pc0Gin4I8d+NMOC?=
 =?us-ascii?Q?6BSxNFcoGDuwXIpJHJHlRTUFHWeZlMq+zDQql2NxePs2Sm52QZnSfEXLrf8I?=
 =?us-ascii?Q?+YvlbBQY60UKEUKq0bh+cZdfFtQW1X8Ndu0kVBiH9Clv02ZcFSLDpHz7BmZw?=
 =?us-ascii?Q?Xh2H667RWLTFjnypIabAWv2A3iMAJPNCIQGp5RuVt959NQTMZvo0WNFCT0Pm?=
 =?us-ascii?Q?sU8LY8VgVL4u/4/KSOfBBz5W13sWcVril+D2rnXIFWRogHAAdW1HudGRzUIr?=
 =?us-ascii?Q?Fg+RY0QXvfSHa/+ox1FpC1ezLO31AhX+3q6ctZfI3FnfdxpJZf+mMg1dFmk2?=
 =?us-ascii?Q?3SoI9v3F4ophefk5HqAVevPBUT7U5EHSqoH5LaqZlEeWiBR/KyeV/kXMLpSd?=
 =?us-ascii?Q?uHdSHIx4C3/i/bThOyov0eVQ1oNrdoEuF6QE6N5+4tT6V+k1xZi6ju9UDRnR?=
 =?us-ascii?Q?gcWs9KBYRY6k9wCyDn2TATeAPr1X599k3cuVUy5JIfMTVb942JmwIa4Snsru?=
 =?us-ascii?Q?CAp5Sow9nTu42DN5Swzo8vVtfn+4crI9jDyV0sNOWso/vezIK+LbwELDRmxJ?=
 =?us-ascii?Q?vemlQWarAUCfDyeYjj2ub4ajDcUqxjBj9HskwfmQmrg86iVCt6a0Bg0JqEJl?=
 =?us-ascii?Q?WtfX+CQyvPKvj8o+jIh+8ICW1V65C4eam39NzjeEo/R9AVvUFVpU3S0uyABW?=
 =?us-ascii?Q?Wr0iskeCcTpCrfJ6oerN61nUzcgCvKWmdB8YDR1Qyh9zxPnUseYkecljz50Q?=
 =?us-ascii?Q?lYWWM4bwelqjJa7O7nWuVDW8P/0CIeRYzGj9Np2Jd2Fy2yvDMRE8f2XfLDWp?=
 =?us-ascii?Q?QBrT3/d+rbcZD1DKQjCq6y+scoz/wYXixags6mhixjeCT0qgklXrUqAhXNwu?=
 =?us-ascii?Q?miPMflsPDL6iD/0Bvfql17HBambA5rGEqNbc9xTQFNT7cmfEXfTIi+Sz1BQP?=
 =?us-ascii?Q?X+aX7PZhdUNaMrQ0sYmQGhh16iZRCGhBdpolZlJGrvNrD60iy7vxISJF/mck?=
 =?us-ascii?Q?nWJlTgqhRo03RZswSmgvYS4LdqQrXcDAvQQCaaZ01SFbnwIEZsEm5dlMeN6F?=
 =?us-ascii?Q?DCqvjIb0tydmEE4lOdhkINIhOUwZ2li142HwvS+EwLhgLQ+hFR9AYuZQ+7WI?=
 =?us-ascii?Q?L/+IFQOvgept74yKUt8hsb6qBv7tWC2Mwcyxl0GRtQFQcbmQqfMIw0ualdM4?=
 =?us-ascii?Q?k7GmKGfPRNw69VyzwV2BhvMh5FkVU4TSkHarXnHoDc6kZiX67XfvdoX2TqEM?=
 =?us-ascii?Q?+oL8llKMwzT9qhhHPWQMpculCtDFFH+nVhp+yPggoMo3cMbhFHfMKqowB9Xr?=
 =?us-ascii?Q?iF0RXFcpH9P/PExXEspjUe/+uQAj8XDrtGFyY0Ua6ahQuBhzQ+YA+hliraO7?=
 =?us-ascii?Q?aBiofrZWn2y4m7jBxV6JnFzyJHt6eiWCmuPcnRNfavQA80OglKtzbjzusJ9F?=
 =?us-ascii?Q?9xtaJG99s3ozowC33gsFyZFvpMnLI3e04mfUCgIqLifiTHK8qqd11P0iG/iQ?=
 =?us-ascii?Q?NPWKNohCpnSPB2KYqWKd3kvM6IYD2sOx9pvSasp5a0lMQvMj0pbcRtzOxPR1?=
 =?us-ascii?Q?gmEQXtxJLVJIQu9fBwWB8ME5cnE390KCDoKkMJ3CdRW0pJGFFZ2d1J6NLFzF?=
 =?us-ascii?Q?qIVsEkVx9AM5Ei+v2aCOYNszxTvle2/fH194fbvhD9TsLNtJ2k2LLdCiZK21?=
 =?us-ascii?Q?u5E//q6cow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5pEK2rSJ3LhC35/JSD5FopaKmQJ5EbQEwi5ol9Xh3iidrBZqMOrdNj4ZUURVRGAtJtVqhyG1Kkfgg7pbqmcwVqJfYpPlSokQKkqWactnVxCwMZ069LL8SISw31l96J9eC9/LuwEP3DMz1cfIcnL6+xczdWzgz2GGXgZ8VtZKCtUeU4AIEuLJ5dpGiFnIilvrOsqqEEVWGuGe3qhopxRzcuiUf28X167SXdFTFcUwW0sp20QpmAZWPAhxFlfb7h/4eMhEqmWZqDHohlZEC47fDLYv8tKDK56IsjoAFMeFNAGSY0tcj68Crk/4wT5c9oQgbRRutMoesQu2xlaQG4bdDdlRuHedK5W0Ib4bMV+v88UF2kskLRNPdWoNwn+4558FAiYdGYd0AQYS6o4SCJZHbqeg5+6yf3SpcHiz3/aW4ul7L6PKgNStKJZyqTYMm6RoFHBXQULhmee4TUWYMdwSkasX+JSfWITw0CvO8H2YWfg6vr1gHAsGEv/rwaah4WFmYJ5PPkHnn7TkBfepncED6WUo8xXZ+SfBwoSJKVTIlzqXVcoyjp+VVloBSHK0f6QwijIQTQF2sl1wH8L8S1I7rWBp9Xa0awcaf5hLEZK66RE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a928da9-75e1-4ae9-b7ac-08de65630255
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:35:04.9990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOL9gFxpa4uq0IAvYmn0HE95hfqY5heYW29nQEbngD0RWxr+yoI199nRPfTIoz5ls0cQ2hqzY8y2DeWphXVjHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060063
X-Proofpoint-GUID: thCQmt67T64vZ9WiNwvBbqhBzxSKi3Fa
X-Proofpoint-ORIG-GUID: thCQmt67T64vZ9WiNwvBbqhBzxSKi3Fa
X-Authority-Analysis: v=2.4 cv=BJS+bVQG c=1 sm=1 tr=0 ts=6985b5cd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=-60tig8Jy-qxpTarlVEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfX2eTPxSzy5bur
 9gMGXWI5EmlQpXmhG8LjXe1O1KqpiAh/U2RcpxENfv6AAG2WCCcbm1qgGg2rPsLLCnpr7mmGkt4
 11dqYp9feRFeXVV3npoQyofyc37prHPO1ivfXXX6On50xyOfVdLJ2l/aRFVZPoBe4BquKox2oJu
 CFdD4YDYx/4jiAPh5z5JFKJABi7NUxMZx9buoeuT6NQP7P8asMsZqa+RTVRUEbSkYinHpa9nCcX
 BBMTNICrTI0y4Z0XySSf6SeLai2EG2uNQH4OvNLZhwtNtPGEci0vmeQq3qU2w9Fbu/PN0k/8+Cx
 yNmUEYXHmMq5W6AiCrLVeopJ95pVHZSP8HRv5abcwITDIeWE77D7mv2kwoQo1P7pcv12S3rim3T
 9pzaBmdl1YfZtrWV3l9FOL8ey+oh3/zM+Puh6yseU0XjE69lT5JPWpfQrEIy5L1s8vvSlwDvXfd
 RUzeychj8fUx2oLyVTw==
X-Rspamd-Queue-Id: B59F91C0003
X-Stat-Signature: 7kb9ayrfpbjjwrmk9db4a9f1ckkr1jtj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770370533-176155
X-HE-Meta: U2FsdGVkX1+fhKAvqR2dSin1mzZgTVXFR0F7pKaiCypJ3rDXpBNiJvq8ilt9/1Fut0LZJXnuj4NfXbDg60N5IPsXz9/ef0inULkYKn9tJwPEHfT1BvL3/bnEal+uVapS2QBe1GhpqqCriZMlSRXIVY9C20bfCFZEaT8mvCSmXC34ri21xRU8/3SnxBnXl1dxvsyBiHZ1jcJAMxTpLW92h0KId03ue907JGtVBd1JdjVuMEAM8zj9+DV/26kcJZFSPQnolVjIQq1ivpDZvlnKuHN6rTGUtiHsjODA2WuLGhcy+0JtpIC5i1d+bcOlGpY3VxKQwP+dQjeRs1jIymVgjFGzceYBCL3KtRM8sU36LcbhnRFYu2ETW1PeAIxiNJ9Vun2aS2kSkkKtL/paEecdEQGoVEyBwxF3IugvtLLs2fgt0OGR6uIHDtqrSAVf054eTun7NfP7r8NDrIoG2j+I8cTDbNd6SiHIf8tc2tSvFl1RdeQ1pFDEwjNNtKi0OdBCoLGtHP5oBYK1zZMzoKf2VFrVfGBTagEwnUgy/jDgQa6RtKkjgtGyyPYVpDcpip8Fery8MxDo122djWHYOVzS8+3A/Ss+ZAOk5fTHM8xLyQGqgoVIt5IQUof4L+/ZngU0JsXX5TigCokAjAmb3r5cXNl0iFaiWobBVFkUJjUwDVS3NBwUCCBiLGvaNYeGLkukyi8rCsR0YXYIxhLrMZXg+ZpBQ61CFanZPLWH/RGqJ6st4B1pK+wO7lfZWlNTxoTTfnt+igKdLPGzf3607cpTssSMdsDG69RKW1AykJsH+VgpvyDNX7eOwhfLolvaNkJdTnFKNbQa0O7xnxlmUb71fhiA18T/oAd5Qd1r1ANB0cXnylG0vftUlYOC4rdgo4reLwb3xiZ4LHGIzsW1tUG920el8/lRjsqEuMU2aklwRi+XhYeGdP0ij/zTVvIx+Vk56FvkZmcw33uncjBCbZy
 d9CmJp5j
 ORPB3PuXGET9gFbL97AY+DvNbC7SzL8N6+/+3d5V9F7urK4qPikvxZFjhgTmi1qr1vWVC76roV45C9b+GgzULuk/a2oimvPyDCjRV5J8x0ECn80zcXw2Zd72OFvp5fKjODGgigyodemP4uuRE4Bvm5bE+h+3aU48DyjZo3oigqesIcF+VFqWSobxwyCwxXQzA8I9tEk/JsERAPnMZSX9uJ3hGNlioZzLiE8WwRoDcBmFnGb/Za87TQbw9qaCHUMMSIDoXaaiQ3mZXw5C1I/gW5hrZFgbqTdSXMOyq1jEu4PRZpbjzwGvesSsSaTH6CDbtR3Ci8D+sEcUiSam99MpZa12yhhKWzaRHLzfuEc1gaLVWm5x2T5pvSVInBuHqh4j65z2/VWyaQ5bHb6mmxqH1V4sUANY+qFOILmh4sDf3B8/HTAqqCSBdOkag/r+W/3huMWsxIU6r/QtDCgJa9hrD2M5SiW6l5BrR1/rgiRIlUX6qMi2uqXoIBSJsL3NKKMo2h3Z/WWAR8JTY4+/08chwN/PaFlfOui6LBzloG4ADsyg3NHV9tA6pIvMT21Ua2E3cMNoJxIL+WDqTNCj6pMhM1r7Ct++wsNzfgG5y3tb98B1aQT42WXgXEtN7W7OXjIyVnuJB2VbjT0j6ZoB4AD03+8EcLencTusR2Fgz9SohvVh90PX8FMmKvWKtI7Fd2JspJjqT6assn9fu3ltmNHPropBYtR9Quj1+4d0vAHnDEZFrVzD25bQ8ohOdbJRHQG6NqES+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Similar to
__pcs_replace_full_main(), try to get an empty sheaf from pcs->spare or
the barn, but don't add !allow_spin support for alloc_empty_sheaf() and
fail early instead.

Since call_rcu() does not support NMI contexts, kfree_rcu_sheaf() fails
when the rcu sheaf becomes full.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slab.h        |  2 +-
 mm/slab_common.c |  7 +++----
 mm/slub.c        | 14 ++++++++++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 71c7261bf822..5e05a684258f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -404,7 +404,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
 }
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 9d7801e5cb73..3ee3cf8da304 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1675,7 +1675,7 @@ static void kfree_rcu_work(struct work_struct *work)
 		kvfree_rcu_list(head);
 }
 
-static bool kfree_rcu_sheaf(void *obj)
+static bool kfree_rcu_sheaf(void *obj, bool allow_spin)
 {
 	struct kmem_cache *s;
 	struct slab *slab;
@@ -1689,7 +1689,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj);
+		return __kfree_rcu_sheaf(s, obj, allow_spin);
 
 	return false;
 }
@@ -2044,8 +2044,7 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
 				IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
 		goto defer_free;
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
-			(allow_spin && kfree_rcu_sheaf(ptr)))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr, allow_spin))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index ac7bc7e1163f..48f5d6dd3767 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5783,7 +5783,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
  */
 static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
@@ -5821,7 +5821,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn, true);
+		empty = barn_get_empty_sheaf(barn, allow_spin);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -5830,6 +5830,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
+		/* It's easier to fall back than trying harder with !allow_spin */
+		if (!allow_spin)
+			goto fail;
+
 		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
 
 		if (!empty)
@@ -5861,6 +5865,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
+		if (unlikely(!allow_spin)) {
+			/* call_rcu() does not support NMI context */
+			rcu_sheaf->size--;
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_mem_id();
 	}
-- 
2.43.0


