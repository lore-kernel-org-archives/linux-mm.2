Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C23ECD3EE62
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613DB6B01A5; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0116B01A9; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F796B01A5; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20CB76B01A5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF7A4B6AD7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:51 +0000 (UTC)
X-FDA: 84359614542.22.77D6BFE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id A183740004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q4tbBjNP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mI1EMkl2;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=;
	b=TV2Q0bu3tQjdDBrqydFivyacAu5vWX1VNvHB2vh2SBmOSXpX1XdWVkLN+xdg3T5xeIAuV1
	n4YxrDmH5XmBqqg0IaFnARyPgX+u+XKa4cWPtxfFBNJ+57HqLF1Erst/WNKcFf8K3ywi5s
	WAtEk4twD0I9UPNvxOly/8BYnAcBn/o=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q4tbBjNP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mI1EMkl2;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086968; a=rsa-sha256;
	cv=pass;
	b=PVWgZsBxN7o03BLqBkMhHST61I6JalD+aGvKXQcz/rqXGxpjZz1UCpSiBccNQUAjDhRp7h
	vKyTPBzckLHvFSCMLRwHhjWx901acAJDzoDIYRhwdapiQFXm6YXFTWx54eZbah/8a5xaqu
	RbFLC0ldiiZVmMdwp0w5M0A1ep8SKJk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LLsXcg3867763;
	Thu, 22 Jan 2026 13:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=; b=
	q4tbBjNP1K/coDQh1ejAuEmtfCbkoYu4C4qtLSi4iCO0+iVAs7n6jWcpEBRfHie5
	37msGoFx7go4TBdpHzE2U7YMDdnPxGmStA/XKp+P+ilLWygHIujmxLsCpLpXJjU5
	yii23+fQ4RhTPNY0frgFDFxZtndDqH2Q6gth/Rw8YgwH/nQJSUv9hS4GmKdNaEs+
	EChBPiX3FlrQBctckuEeO31pyCRmLH18kD8tfs5yaW8Q+HoosKjPiYoUWDjSxAni
	5t1UuW7lHF1FymuQ7y7U7kK0CPicv4kNoPuVmZHkS22qGzoujMkmpZzsPIkNbOcJ
	rxl+uN2k8c973mkagWbaxw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd46r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCHAdp022503;
	Thu, 22 Jan 2026 13:02:15 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgjp0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=whnXkl2riQJPxQUgimNdQvbspr0c7fnw0A3piK4Jvg44UxoV6JyQZz5PT/pdkQo7XAfR/f33pZWv5d7sRU9tSQPDNop/Oexdz/CPKX6TpVBSmJpKUH9oI0CTzoJ7t0K5E6cdaKfj7pwDzoZX9XIi3G/D+2tac8lq6NMnzKvt3WuS7tAk8F2cBwzOsy2Y7CE8cnMoyv3dTsKsvwqcuEy4Tv9X4kabI+bSAIR1TNMuLTF2RCuawb6J9wXeyTIctU+EZ4ZibuYaCAMPgl8eXpFSyrsfgGTzofzrk2rlQG42CPwa13kP2HKrwIiX9yeYti0VVtsjqFNZFcJtF6sTsKLNbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=;
 b=UozL2SQV0auvaYTvAo96jIO4XV5Gmx36goujNPdaBw3w5IS0GLcxlwKTHe0/UBKEnUChigU06UvvWlgcTy9qrt4UidtSYsmqfNyW66inONv9E2kCZbt3bKVYjgGJxOQT2npto/DBbcVg4R1lQmjV/sC77OMkVul7sh+d5LE1NzLNb0wwGkoWo7K+ExOv6a2KuVWCEBx+AMtqnBOJV1rSXnV1fhAx6bMgWSl178I3kUu+AgyLMzHRgJS0qNLyNE9RpZyWjU5I1uPsAbjhyEZxumtUlxqn89kkAiTPyjgXQidCXsPKrsi2bkPwAuTHUZee6P1XRTtbWNQ+XQrVN2yzVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=;
 b=mI1EMkl2iamdD/t4du5v2XOaGxr08kEd48VqLeqqnqRJhXhiTKgoi5pbhfdxvZDRZ51hoM3i6GoFo/Bo7t5USauwsRysvtTj0uEXa34TCbs3LR2bS+iUjZj/zgBKAUwaDDKARMgdBTa0rCPWCYDnXe3eh3hWvYYBn1CnhIs5QNE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BLAPR10MB4865.namprd10.prod.outlook.com (2603:10b6:208:334::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 13:02:12 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:11 +0000
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
Subject: [PATCH RESEND v3 05/10] mm/vma: de-duplicate __vma_enter_locked() error path
Date: Thu, 22 Jan 2026 13:01:57 +0000
Message-ID: <2611b2b6957b7aef587e9ae62712a888159dce60.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0009.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BLAPR10MB4865:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f56fd9-911e-4212-0ff9-08de59b67527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?duuL2OUSKqFDZUGFzoW3xDRM0Dsi4rSnAHf/AFLOJUnxyn3PBJJ/fR4/LMyF?=
 =?us-ascii?Q?QKMLgYupbKH9E1FfOOgsMuXICgZcNDt8ymlPKCFyeBjHR972pP7jmdssrQnV?=
 =?us-ascii?Q?WN7rKCa90/SRTUTuZdiDSDAf9HsUkiqDQiidIxLm0qsrHdi0qguFsNpOBYuq?=
 =?us-ascii?Q?wjyuxhNRfjM9Iipu81FrJ4FNokOiLy8vpwwuDZPNyt+1DxlAvUuOnj++A46/?=
 =?us-ascii?Q?K7XD8GULYbl7VvngsZBuFoCO3ntdoiBvUmtD+9psfa+gIxWFE0EQLgenrkfr?=
 =?us-ascii?Q?zpadDeRfKY2Dq1JD4DlyGorf4YHNmwnXUN96Zx41tD2NOco70QFGuxN9YTP4?=
 =?us-ascii?Q?M1w7a/1tl/3IHfefXWmQAs3t8yXEW1ZbH/4+Uv64G2TVwakR1FPc/z4XsfJz?=
 =?us-ascii?Q?hWyhM/qvkwDGxbopMJsrW6Mb8ERSdm7fQVO59j0GkwfTejTkq13BntZtLejh?=
 =?us-ascii?Q?vNwm6GEz1TBGkYHE8uSR3YVangWsJvJkw+/RQDrBD8izoYPHylV6HzKYSqku?=
 =?us-ascii?Q?t6V/X044GPFTKuZgps0y8osz7vIV10C2/1/GwDa8Qkp1qOf7b26L9OM0DtTm?=
 =?us-ascii?Q?eLvEzTdpAnkxhmOAEp3c5FOdbDiWJ5/OuPmWsIUx2Qe0uDhZrh3TPLZhtvIZ?=
 =?us-ascii?Q?1hPoch3uRM5F31xntmGS1oGxJb/iQU07v+/aha4knjP1uppRTLIlUNBSQFQp?=
 =?us-ascii?Q?e9DtzQJ/O9Egz097y5wuRX+8n9Vkni0zFn2sp7MB9AmjJTBUgzS4E6Fkok/A?=
 =?us-ascii?Q?DrAdGp08NQWXzTvnK8uNED6jQGC3d6yass/a9NRjGmN8mgf4Km+aj6gIuJsG?=
 =?us-ascii?Q?uvI03EBtcy2KWJWhS6a/LI5Z7PtZ4wooJHWAUO3pH2GjWrx/H17hEt0Po2mF?=
 =?us-ascii?Q?aVtQqyasxyrsukTg5iZBmkeKBzO/mfAl9fRu3VzewEbDfsS1aqF1e/i/H/+O?=
 =?us-ascii?Q?rwzispTWXgpyumPfBk/tUc6/4yqbTkbuMSTAu0Jyuk11uQafygqTJEPgwCxS?=
 =?us-ascii?Q?ua8Q9INHMoaQybj9oTOPgcCtiQ+jDJCbSSeDzTxCwzQxviVNWsxZB8YDJ7Vo?=
 =?us-ascii?Q?WRMdeBydBuQpCvI2QMTvkLLTPXtHg/NLFfn6G2ww1CaLDrXrEDxZQt6ewlFt?=
 =?us-ascii?Q?uY9x7Bye1+gzI0o4MfgTg0Lg2XP32nWlou5nM72AiXQ5UNGeKAS8ksDKU4Ym?=
 =?us-ascii?Q?z+lHXO6h/DrDRRrOOYonf2C5wqoL1pyBBtO5ymUENrV99BPHAsRGdGgL832E?=
 =?us-ascii?Q?8T4z38390eBN2ATjxKxjTi0QUFKNU/qOomtmPGUiniTpUZgOxKrtDy4ZUTvK?=
 =?us-ascii?Q?QANfevml+acT7yCKdFZ9f/PrF7T8kCzcp9dOPOctDH5hf00m/HEMIviR/dV+?=
 =?us-ascii?Q?XZW1oajHnp9U/7aS/KclW/hXF+cMmtjCUmPV1nu5FFIu8OK9/AFwaO3aq65X?=
 =?us-ascii?Q?s3U50buLnrh8G+zVrHznfp8mENoJzQ0AHobu2LbU23DIDjvhHZafYiX0EMpJ?=
 =?us-ascii?Q?GzwW/HlLasjt9y7ApCun+Y2srTwb00w3Y5QIOTsmvhWRRgRF51RxQpUT0wKC?=
 =?us-ascii?Q?9LtRKVFK4WVM0DRPl7w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dh36GCUxkXbTQNVz1ia8ZcdYGlkMH91Y1MWu8sX6Xawb+TVqG74eM4A/CHLb?=
 =?us-ascii?Q?WeohO94oHXuyEyKqRJ19s6/7fmbo6lo29CUDR5+aMxFrpPM3az0TiWbmQyun?=
 =?us-ascii?Q?ojhmyJ5ux/jlqdkoUZR/ZGqOXguP0Brvz6foSu7YPIe/D9F17PC6vEgV3JZa?=
 =?us-ascii?Q?9XIOW5wlx6x+pzxUtCUWYICMbN2pqKpEKa5BEFh+3Qq11wH8+XTh26lkC/st?=
 =?us-ascii?Q?v9U7YI3z/NUyfrtfQtBWSTjVqJO5XxDIkWiPqyHyUy+GGqK8vouTJYvDPZrH?=
 =?us-ascii?Q?K4jPXrQArqYr4IBhJ2C+lrCExp52gABoD5lIVbFeskhioLsizLmZ2JdokNji?=
 =?us-ascii?Q?ODWQKGyGx/nHaOudWYWt+pE7rsIytv7MRzP5GN4T14CafbdT0kpJQJzblhK5?=
 =?us-ascii?Q?wYM8p6xMS3w9H0qVkM1y6Pi0AToLf7Eq2l9NMS24eKnjUHSFMfXUgGpINlEx?=
 =?us-ascii?Q?HojihspRT1owSaM1+10YOsCe89DU40Mcn/k5FaCzEGQ33GLBc7rQnZVes3l5?=
 =?us-ascii?Q?Gii2Gwz9OcCEdeMDhphMl+ezjlWsGaSsxZ0P3dxH6mCGuWXYleHlsPMHK4dc?=
 =?us-ascii?Q?f9AaPjZUmbMWF1B9GIpIYVrd72qyAKjeSzdX66ZtukSMPLEnALk7dSc6VeDV?=
 =?us-ascii?Q?gcUmNNsqZci6SrILbgTZd80KvFb7Zf0acPxkx734SZ7osb2dy5LiLE8is23f?=
 =?us-ascii?Q?Y2fpTOlm3SPRYuQ2oxa38FB801SjV7tbEYIRbZ6M0gN+Zuyc3UPoMUq0nE1M?=
 =?us-ascii?Q?28fULpMTqqKWyKouLMStARa+IWfYbPY4ZkRWMloRRbuHEkTosJoE6P26scqu?=
 =?us-ascii?Q?TnmrdkASjU+6cOxrH7+YLRVtRiXAct3olVMVYQJa3Jj6NAPvG+fYeBTHB0Yb?=
 =?us-ascii?Q?wmhCuhh4/TntrslbWJT8uOx0bT6gvnP02z/3OJlPlUFfT969RB3kLA8T9u8A?=
 =?us-ascii?Q?Dlk3fk3XopRi31tkb1q9NjjxG3Q6sPK8rLOr8f/gLLR7OwAsv9Fn9Pr4XvhR?=
 =?us-ascii?Q?f8w6yPUWhV/r9guyKgmCdHUofjpbR1vvqkHwHAPWpqhQsbS4AEqRlq+dUu37?=
 =?us-ascii?Q?hl+6PPoYOuInYVz3hm7bhXPePHKECdIqZX7A4C9nOpKx4WPTpq8nPMhSNqFd?=
 =?us-ascii?Q?XnbATd1EBMvXjOZFvlO4XPLsENghLCazOAy794iSwGbIwEHXm3duplEIdgnx?=
 =?us-ascii?Q?z3+gK6Z34Ppp4KrIxikfY17cmEdZ8YoRiVKbRkFA/1lBDDcugqogVmj437xr?=
 =?us-ascii?Q?hYLCNEMpGX7Yg795i/bG2QXX//NBNPOs8BGBjcAAOhjUofmDtisKyVY19NX3?=
 =?us-ascii?Q?gt/O6I1GmEubom33k2azpsdDdMv6ZScZOWx5FaHvC8nrosZaxC0H++jtLa/x?=
 =?us-ascii?Q?Prf/wf507L9UhherKevusZCHQd2fqFCKpYVWsGzUpLxuUQTtMEXwc3YL6pbn?=
 =?us-ascii?Q?Paipqg3C/rubbOydlBb3IkCe1gSZ/9LWJGfeFW4k1c/7hPSt5NItR0adsbPd?=
 =?us-ascii?Q?urVyyz3IVio771ggeGc3uoLQCDtE8ZMazSWNvX46k0YiSTKUVs/yhEFOr1ML?=
 =?us-ascii?Q?ZrAQFt18K+Ve1u6p/9JXweellUvsLqEm1oX22ph90gLZbHHNv+IvZq3vuZlR?=
 =?us-ascii?Q?q0S9RVCoO36sUU7bivAxnX8TLQryGAR6eNLbP2oKkxbY5apd9uPEbXcroJvo?=
 =?us-ascii?Q?WiBUr/KLqdtnSExEnjC6fPvO7nWhF4OsUGmCEhD83gzzUP7geSw7lWGQyMFz?=
 =?us-ascii?Q?CXcz4kISItwO6WI4olYzPI3h4QtEq2I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vJfneigGjso4VqFCe2dDeLzzbTwj6/Jf77p+pl7OG6JT4bu6q2P1j6mInBjfQeqzNjAk9p2DkCDP9L1X1M1qNA10Zf0/M8s2P7ELn64NilukQujU5182lIvPVjJqiHWvvCWJeO09Nbn5NYNJ7AgDC2R0MOVieb7itNrj+YuMyLJPoBLSz9Fr3nOPV22zbHGHmBgIgQ9Fkll3ybckdvnbC6mxR1x0GXAz7+2g05AEqvsbcNRI2ixRJbjarYxYBWqD6DWekpL73RneYN+b6MLezYBxJrYBXPlpWp5QayUongBjX8vCXYSDygxASlKUgqGc+XYdwX5HK8nJyezB9cWe3Kt3CJ3fcUy+IHFRGUKpjA3oNKYqBT1Vz5LCQNqEfcO+7vP31pj1M7qkrW+35LfqyXheYx9k0geyGki19VNolb3r9rMlYrlsM+9SzYpUAsDbCQZ852mlOWJ0nAIrCg4jwbjWlgOrVo0Jnzvo2EjsGvHhHOepGxTY2E1j6unS1gc9okhCWW8dP584pt9VCS+NepltFXvIntpWMwGWIeDWXw+yvVTltyAF7i9kRB8Bt7AmWrOzLRj/0SFockUzIf9pXQsN4aTasVj+Ag3DrNHpu98=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f56fd9-911e-4212-0ff9-08de59b67527
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:11.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L37ZIaClIHixbUKAYN0CxlJaJP/6XnURlgg1rMBL+IIv5PGvcSQfaAYZVQ3Y0j8aupgio/t+SJzXrh0WqcYbv3ZuWXhEFSvQidf1h6+LcMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4865
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=69721fee b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=3lrxA4fjdKnX_o0fwtQA:9 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: GOJSID8ZmHMKsbWGdFbBqQjm8RS_8Ff-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX6Dhs7aa/5wo4
 3az/iYKDZ/nN42W/ovOyggxBGF5nuXqTZ9Pmhxqsi0/VHYWLWGSpRX6J3xBaQ+VygvAxLAVoXTU
 c1sYHUDdISjQ4nvrJvAxz/ZMvvs1od1D0F4n6OdlDrYCBNh9DQni2IpjWa+ubToh+70AJaI1LEh
 qcbmLduQcxAU7GirHJ5QAVQ2+cVDHaJhoOhQT00P7PPUkSuCPuU/FOb2p3j4vyyh6kL7Uaus3Ys
 lRatXhDyPvIJRobb4/sckl2wlqwqHVe95hJoFR6rll/gXhKoQVnzfFnRylX4ye1EG9o/pV6XBvR
 nwnrWkmRy1X78b23ab5lUKovqaL4SbFTb0K0fjr4l6XLbLBPIegOCygPklThZxvxkmycIhQ2gtw
 jxGkLQYEks5Q2EWV2cuLuHxGLtw4vgDCRoJ9ct9w2/y1jg8utkDW4TEGW2LTAd06bin5CBigvBZ
 suYf5WdrSbojB3YVWT3QNODbFiSqYoNH1os4lhdo=
X-Proofpoint-GUID: GOJSID8ZmHMKsbWGdFbBqQjm8RS_8Ff-
X-Stat-Signature: g8q9rbaz886fpccu1j4qo1syinefgkog
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A183740004
X-HE-Tag: 1769086968-219497
X-HE-Meta: U2FsdGVkX1+egcgWLPdFSrrPMa0yZ8Xvd+Rgj0d8xHHKcs19kIrnZ8VeCfLMPs+Q++tkg9jHQe/te04v6nef2eW3VBeByNtD13uucgDQeG3I8//h+U1g0t3VxFz+OmZIhoVpr5QM2985jWYhdkdtCGup4S7Cbou1XaNrkYv2HmLKwc+to/OkxPIecUISOYW3sBfOyiPAeqyXDm87uKXxbsfa3OirACNdEr27CmnoYccXyRnIaT0H1z4cCG+mygZaRNGl7GhhW4/gHe2FaePgLDTTeyMS9yAlOrdkYV+fAMj5MddxLfCY9VJq48x3HjiY4zKFZJOrrbSTWc0g+JdxgYnT95Lp4t2ZOjk3zA4XbhKvLllCRGqf6l2yqw5MKlv2d/07KBTxfwyS7AtwZLX9k9R/qregA9+Ng+jWfBkubYCBt243HI4R3C/mNx/mZFl86OQawq4y5iTGmeLg3ybULr4EevtlQ5tiwCSpD8oiKE07tyDYwmOn9ykc6psB8TP7swGOwRxO8qDnnJ1ytXhN903GpXRNR6UZMF3KRRFHDaAZr4qHyRpxPbvKisfzqa+/1SlIvJnfjQvJ/ViI7KAvp3Qb4GfB8eafAp4y8qVGBxjwlaHIxLYSecEoovejYbnmvIQeWsxW7FOIkem6e+FP0QxJdH50myu32XnB/oAZlyEMcCtijfajYwaXXFztrXdkHpVIzimuqZEuCEhNNMJZDXlhJKcYpMFRyRmUvSy3gPDF5QNeVdpD/Dl7LfI3TCCyMknXLqWJWBiBJGcOYfO5FLzhbPQPsZuR5ZOQ7tgoNLxCYhZzOhPyUqkOysfrOOAH970THrE5t5ujj5ATympiZ+XFwwi9FHAFy5qOWIdvt3s7/5ASCGVsF2g1U2HT8k809WWzwqTPw5Sr5QNxXirczBhF7b/J3NHq8TKa77NNlZwI7/jUqlFK9qcCT60Kh743lgk8tIl06P/jx+r7zkx
 Sb4sC4Ml
 BylyzMspMRnwaFN5H+ouVldV2EkberSSLa6BQ9u/QwkJxhBqHrs/sj6WPwGD67NvzIOvsc+Tv6RPJiiBwjknu+Nor1VMgTnJ8SwV7EGa9waD30b0yc4S5RwdNvGPFjwJN6okqKuJ/sXXOfyzHpkdbvHVFPr/iroHVP4FTdCc3dTaYmm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're doing precisely the same thing that __vma_exit_locked() does, so
de-duplicate this code and keep the refcount primitive in one place.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mmap_lock.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 9563bfb051f4..7a0361cff6db 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -45,6 +45,14 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);

 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
+
+static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+{
+	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					  &vma->vm_refcnt);
+	__vma_lockdep_release_exclusive(vma);
+}
+
 /*
  * __vma_enter_locked() returns 0 immediately if the vma is not
  * attached, otherwise it waits for any current readers to finish and
@@ -77,7 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
+		bool detached;
+
+		__vma_exit_locked(vma, &detached);
+		if (detached) {
 			/*
 			 * The wait failed, but the last reader went away
 			 * as well.  Tell the caller the VMA is detached.
@@ -85,7 +96,6 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 			WARN_ON_ONCE(!detaching);
 			err = 0;
 		}
-		__vma_lockdep_release_exclusive(vma);
 		return err;
 	}
 	__vma_lockdep_stat_mark_acquired(vma);
@@ -93,13 +103,6 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	return 1;
 }

-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
-{
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
-	__vma_lockdep_release_exclusive(vma);
-}
-
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 		int state)
 {
--
2.52.0

