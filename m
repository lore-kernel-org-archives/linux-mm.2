Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6C7CA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB2D6B009D; Sun, 17 Aug 2025 22:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2B36B009F; Sun, 17 Aug 2025 22:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355A26B00A1; Sun, 17 Aug 2025 22:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 185166B009D
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:13:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5E6F140770
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:13:48 +0000 (UTC)
X-FDA: 83788257336.11.81E9708
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id A3FD81A0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:13:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rjg1veCM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hzbOWJ2i;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xtZg+9wttejQ1szHl9/q4wxxDLmDTq5lDaEs+YbL9N4=;
	b=SLa4mNBHLTkjUy7Lq2vmQGh1gS3dPxOhYRYVx2h9OfeADrTvoYoNVmqHNZ8Q34iS5S+jUV
	J5Igf82NPx43Xb0Ivgyhk5T9M1toFKOOUaYjW4pQ3I9QoFsSjiD9Md4/0r3rcggCGrXTrO
	G+Vb9LE1PN2csGrvEbmuQqU4JDXnurA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rjg1veCM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hzbOWJ2i;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755483225; a=rsa-sha256;
	cv=pass;
	b=rwPsp7pP/okcYRBDgXcY9saEL2AgFThStQdriyu6CatUzrTZKljn4w4d3tOPbHgd5QMG6l
	TxA+xaLBkn59ZtYFRUWhQlJRPdct07Oq22YZ7S8tHStpmzIyO9iYR9sZESfCw+Bqb6oC4d
	cjk6L9tco9c1jX34brtwM/ZbVUSEyjM=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57HNO4US022494;
	Mon, 18 Aug 2025 02:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=xtZg+9wttejQ1szH
	l9/q4wxxDLmDTq5lDaEs+YbL9N4=; b=Rjg1veCMhFGoQ7Be7r/hK6SASvVPn0m2
	LU+39MCsMgWsQ4nQ7GmNH2JVam3hMIneTt5gGX7zPUz7SFjW9H1QHxT/7qIq35fX
	Q8nkdGGwtUPbCsdGqM5/i+IVPb2QBLfvCQ7qMGBLXybd9ROz/dGLOLF9WPnxwdgm
	wTvHXMCV5LpTpeLZwGLffK1Wf1uQn/SBuPjOy+I1YfLrG0Xm5wUD8NbYO7LxgaGo
	4Blc8ZXjjlaYMP9A1QE4qVOfcux9PGQcdcLQ474URaitkTckrsSBlHEDs3EDdUpZ
	h0RMrl8t6j/aZcAmCFmy97d7p2EmUk9L1u+mF79BnroHIjUkbpUieQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgdfhyy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 02:12:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57I0UoqV036815;
	Mon, 18 Aug 2025 02:12:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge83jhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 02:12:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TxqBxSH/jUrEGtv+dEsVtuNNl+JORfkGi4Sh8EfufhUuPGUqwldsI9jKgbVme3vZO8aaL3jzPBumMJGIgpx53Nq/3/edDQvKqdx/eNHzdxMnfb5MxRguxJ1UXh3DJxsQpH6OS5rtWhDTqiz1EFCf5R15hmb1WSJSl7CXn7sNDdcTeeoAx6qwLVkmOUE6wbAExmxCNkxoKejdv0BJIawDbHOfJTjWl1+c/IsU0d+GmsnGeRx2w7QkGkw1yYZUjQqCTopkqisdX6nXSSCX60iTD1rp5FRlrSPHpYw+jGUA/qk3o7iyjOOm3mICXs31t5pO7qrVUg23P5m8JnuskWMZZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtZg+9wttejQ1szHl9/q4wxxDLmDTq5lDaEs+YbL9N4=;
 b=vS8HNLTTa0n+1UwABsnGptEJaLD406p7NrijEZxBQOwxGKka03KgFL0Tsrkp2XUTWnc2TG3ZdoaT4fZtC9vsMqU/05bmtOB0GBUYGwH+IftrcFXkrU8FImEwpLWwaf1D5KWFrRS4xgvyeXntgoWFXc3z7SHOB+PpI8O8t4jONUB7uwoINqOxyjnDaGNFno71psYKa2QwyadQuhV3yOyqKRWA6xvnS7yGICCpF4mP6vaAHouVhU4YWuV15QMwMo3xztrOJWkU+JCaPPNR/GOMDLTbk8D+el+n48QAv6hn939w3YviE0dEYuMIapOXytLmKbCX5FpMWvUhvOYav+XRbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtZg+9wttejQ1szHl9/q4wxxDLmDTq5lDaEs+YbL9N4=;
 b=hzbOWJ2i7Lg9sXX/ruc15cN7sCPuAho3mGu+FNQWLmK1ZlWcyuT5j5oRtYL5lrJWhhvb+t8ko1qMJNZ/E0+c7m2Ts06s+smtF/KayKpGkZ4qOQt9WqUL5kdOSe48oWYE+7auEcIovHfsCbzQth8Gsun4WLAOM+oQvNHpE6XHaRU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4690.namprd10.prod.outlook.com (2603:10b6:303:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 18 Aug
 2025 02:12:45 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9031.019; Mon, 18 Aug 2025
 02:12:39 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zyccr.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.de>, Kevin Brodsky <kevin.brodsky@arm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        Lorenzo Sccakes <lorenzo.stoakes@oracle.com>,
        Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@redhat.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ard Biesheuvel <ardb@kernel.org>, Thomas Huth <thuth@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Peter Xu <peterx@redhat.com>,
        Dev Jain <dev.jain@arm.com>, Bibo Mao <maobibo@loongson.cn>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V5 mm-hotfixes 0/3] mm, x86: fix crash due to missing page table sync and make it harder to miss
Date: Mon, 18 Aug 2025 11:02:03 +0900
Message-ID: <20250818020206.4517-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0159.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4690:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f4c98e-afe6-4524-6ecc-08ddddfcb4bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MkFKdKsIa5ppPFdNYOww/BNlg7bG7nlTyMEPEbj5XU1LQhoqknMhWNZBfl3T?=
 =?us-ascii?Q?T6JgahJQoIITYYm+yFUetZjF9tqSxTsLq3SyzCjBrwOItNKQhWk9n7GTImwt?=
 =?us-ascii?Q?FnV/vs+gqwpEpdyjg4OqbIGcVH2GO1Q57TBJo8A0QwyKZJaeOJWKF7ycwTOX?=
 =?us-ascii?Q?3ICtL1mscd3WkMTctwFXcTBiUIBbNehnKs4QMG8qhDxDPwhy3W+eQjzT72Ol?=
 =?us-ascii?Q?9+6mjgiIDTrc19KePKcZO1ZtBZrG3wClrr4PBV7zQNZ4eFVf6iHhT3fA+JlO?=
 =?us-ascii?Q?fD7WzoXn0PH+4Rv60flcI3Zf7yeEHqFix5gySE4/qLGVQlAGydaS2kuEfO5C?=
 =?us-ascii?Q?L5DAvsYWq+7P7bbReoXp1jj9uNe9F02zJiUy2TOQgUPrnMJodOXY4vHH2Ot6?=
 =?us-ascii?Q?xflvXIsm7Dv0wSQKL6PDBEzahpfXz4zTEiPzAB+y0ubsKcRfp9UPIa1Ru4IM?=
 =?us-ascii?Q?OrjaYkNlFQYNSbSucpGA8pHrxBmeeOZHT+FH5gKhDornYB5mIM0TTxVmuKhP?=
 =?us-ascii?Q?a3ygnLUXJsGrg+bcci8unylRK1mowIK+7XUe5/cUDiHbXyQ0wAg23i4Wnij6?=
 =?us-ascii?Q?smO786aFUGPCmQFNYAhESqzAjLN6hZaCREemsmE4l6BttnqByL3rWa3xosYk?=
 =?us-ascii?Q?xO+fNf6FV8/2puWDYTG66PWNaY8xqlKrCCA1OyDhS9ZjZgKynF5bQ9a0E+R+?=
 =?us-ascii?Q?KTgBy0dIo1VxPAzZe6Xn8VZPFCtQy8agr0P7Se8SxNZdGX7Sk8ddJeXh9DtQ?=
 =?us-ascii?Q?XrwV1OQhLvZtjLnKUNnPh5LWNnAqhIw+fzshQERpoFcRyAzFBCcrt3v2mghr?=
 =?us-ascii?Q?10t1po3OiuB2bInHnEx5WupO5p6NNXOKez3jVuzjXeOX1mbngj1X/7LPvN7R?=
 =?us-ascii?Q?OPQ85ClzLmk8CtyT4JZ0DhpUkwcJSGNd2qPhXq7L18yXpIwggehZQvFdzAry?=
 =?us-ascii?Q?IFQX40WKeeTGhRUe+aiMlHammx1/SfnCYoWqJkyo/xiFV5nGfqEYblcRHYEG?=
 =?us-ascii?Q?uvBStifw0gFloE1C39Umvbl3aqsZ/v3YBzsNSKhKILzHTSkh9uHf1RdqUJ41?=
 =?us-ascii?Q?sDKqumbfOuR3+0S9E97/GJOrhnbBmIxDpK1yS79/iHAWsWe+B6IuHqCJJb9k?=
 =?us-ascii?Q?EpJf2m3AN22BoKOwlH5K4XH1iwuTHTpd54l7p5HY/YppvxufcM3ickyCEwrr?=
 =?us-ascii?Q?rXt/bbd9HF9e9LaqI6QISvWauVmaW3X7S+EQHUKJ1KqBuv1gE1LhyYyNjS6g?=
 =?us-ascii?Q?nIaIu6DB8ZzdV6ktGuwLIt20dE7lwCBMqauq4lxRoOBGWR4EnjDf6jFVaPrS?=
 =?us-ascii?Q?JHiOhTQdNpD67dCgRoBdYs9NF6wVMeaggNU0jhM5zMtN3lOBCH3TU13aTewO?=
 =?us-ascii?Q?Cbrq4wHuhRWMculvxL9u/MmWAO82?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OKArcR+9RNfnF4Lgid9fauOn/JHVJebHGVIDYAyn47ps/PZkdtTC/1vSyQ1Z?=
 =?us-ascii?Q?z/+pRUrefQLam6MPMi5t0lKse8EH8JdeRr/Q6VGrTnBJ6pbBK7FGQpZkCTwx?=
 =?us-ascii?Q?C+lvfoyJlyhwiCWS6SPuVHHJM4APGcnshccsbAqu11mgY52UObTLjnTNMaLa?=
 =?us-ascii?Q?0hEJ2JlAI6aiTL8RTqW8YB96ZxOGYr8GUVGOhfRDKY39EKwm0tcgcGHATUOV?=
 =?us-ascii?Q?9fBf6QUcUh4PSurKl7WotCrME4JBn8TqEOMmGbB4TaG0poNfh+kkmKQyg2bn?=
 =?us-ascii?Q?Zr45CtkZcQXVLIiLc1FlhhaNnifZCCRkb/9SyX3dIHWydAXJqNAVw+AK1ZC4?=
 =?us-ascii?Q?m5uMnXhWduyRkw3gK2yIftT+xqfBrqMRvzu6w7uL1/gU02M4Z43s6CLJ7Wmf?=
 =?us-ascii?Q?tRg9A5hdiboUrZmDz/ttiuVepQ4X2xVPIeDr8W89ofMpKQdOqgT5skNvtJo6?=
 =?us-ascii?Q?fjwNfUq8UV8KnzC8v9/iNyVT/bf88/8bbeVXs00alYagwOfqNEQXIJnTUskJ?=
 =?us-ascii?Q?qxFs53KOs3rN80ezvUBxJ3jF16QuY8M6tugzzEBRytIR/JqRimUTRLQyDxoZ?=
 =?us-ascii?Q?0ZxEPK5hvxxgUPiXQmneWsQk3ehvfNTUyyxV27tmNTx2szo2iCf1UvK+cwL4?=
 =?us-ascii?Q?H5/MCJ/hSCD/z7yRsxGRDybsARXhHlqEJ+Gji7pE43Zv9QKqjrH2xCgL0GnY?=
 =?us-ascii?Q?ujGUgwgSZh2ddHc5T8ghAfkidwGj/HoyXZjcb/6jb29EPGu/gh5+rFvR7W85?=
 =?us-ascii?Q?XvM4eEKrvLHOcWdzb34TScNggeXHbB10tmf/JvsbVa9riJLv/sWU1PCHOjs3?=
 =?us-ascii?Q?vWmOQPs3KtkjufIpgNGlKM8wzpn1iit7F1m4Ab1C3/iq2LsdTSbDtUQgh6sH?=
 =?us-ascii?Q?zAOOy8senpBj3UxJynUOiB7BSTB71tAbwc2PUtiDbs0msA9M62O3A1M4jkmu?=
 =?us-ascii?Q?bvy0Spg2BcTaLaHb8DOPTLSXX1mwYHh/24UMdxwfVm/d75YmHU6Nl/V7J6Fc?=
 =?us-ascii?Q?uDWOvAM8Z4UuPGiFy8fA6rPSAaWc4fiksvqTR0qZYF/S9qzdk5tXqlmj0WSw?=
 =?us-ascii?Q?RZGHYK59kkgIBunf8il60WAJFjE6s2clbVu7N+95kTCi6HZnAHQAYhZaWpfs?=
 =?us-ascii?Q?Kq9ZugPNixYzPGn1KVLQeCKMWbf4KFoqMOXgGPkd9GGA61KFgmLjBXXpf8Ay?=
 =?us-ascii?Q?YR4P5mx9RQ+mPRqmShf62k7YxSuSmEeWyNdKtHuxoPBR5sHCZG+NVvPGkFHy?=
 =?us-ascii?Q?71PuKlIodh6mGRZwas7RcR8YG6i3ERBrsuHg184mMpZ76dX5ilakKfk6t9xJ?=
 =?us-ascii?Q?UpWhx1B7EUn13CxWByr1MWy9C1y5lVsMHVlTaG3Q9U1RwVwJsqVq/pN3Fc9+?=
 =?us-ascii?Q?G/G/LYWOxESbvUFfrbhGIvcXx3DQbrrnm+fIW+UrhY7qFu8meAU5uNu5u51s?=
 =?us-ascii?Q?W+wx/7Oe3oqEc0eb5GFnTT0/SHGS9CGpW/PE7mYJT0DSaW5eUzOIXdm9Oc5V?=
 =?us-ascii?Q?l+8pNcPB7RK5SwgIrKZlsWTbGsXNRz3wW0iophAEF4dMfz5TSaqGbUXZsGvY?=
 =?us-ascii?Q?751TaRM4Eviqe9vZIz2+nUXcQTQu6KL8T+VjTSNy?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z+ssMR8S9YcUD978kWqYiRbsPcptp0UKZ6aUCnUCo+7FbQZyvaUaU8KXIQdHZ0Z36zmxHQmY6qZ0GDedCEVIIMAnMumSrUGVHBDrdzZM5JMZCYV7jgVhxclUam0TipwyMg/gcxEaUeaYF8xCoZuj6qMXibP61e3y+CV04gK9KajH/CLQtRMfvTf+mb9t3/772AfUVDtlqc/556xfimeSMb5/W94LcBHF1sraahc/Nl7iYuRrc1TERcCSX+fP6e748SB2DViDDhGXq4oL2ba0CDuoF6vmR6Aq/i8wWE5cINsjH+YzcRokcYrdPjFOTqyR23zQZQ0XE3ddP41r5oy4xhqoVxKGwxdKaksFKQunoDd2VexyqNwDpVqN0OddkbGEewup3NoZ26xbFmSdnf1uXhn8eR9MeSLDZxZrEPg9hZCoDX9U59oeicqHsNbc1srHCn4zseLDnz0ekDQzmDreyh4plGUd0a8a1iBfSeAmTLnJ6HPkQvjaVo6SWkVSKYVeZwZy2T9uS6BMDs6nH1E9GVFWPqKHdk/Is6Gd5gu/xB/f+xJvT/8lMFaU58y4wufrpJS7q+2NSJjmA3rgUOG0orE9Y50mR/WjPNnTNN/UXX0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f4c98e-afe6-4524-6ecc-08ddddfcb4bd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 02:12:39.3903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wfa+oj64IKkOIkhn230+BzZ2oTdfqeNx2yWepOLlEas5dEb7Z0PRfEJ7bKso/jYfynyRUAk23k4YpQXw23/Lww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508180019
X-Proofpoint-ORIG-GUID: un7H_zbgxYLtQBYciQgQzkfNTXqGszOT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDAxOSBTYWx0ZWRfXx6pKh8yK80l4
 O9LaXmxIiHMWKqHEVrzweSVgeo6a0byTdimKfAd7YAQRKIrNms+TFo5SujUoPNilVGw06AJoDZ8
 s4Nqo+Hthz4PrSLFQlr1Ek1HkM+KX9WsfcEsXPyLZhBONmcmRO4qd7KgAgakq4EmF7j0KMmu8kl
 gJUHk1NTmezLAlcYiZ6lpmxXI0PJohtGjYmb/mBnqqMh4rBm0SJeC3jS26IOgaCUyXAYQ5E2WSv
 neyoGpMqSK9nn3U4zoVt+lwWYSNzW83jhqqLMaVpjrwOQLOGcwDTlgwnSOLz9BQoaD1jWAXb5rv
 qUjVVUdC8hAlBOrBgQ3fwyUq9ElvCsYqUr2cUrtsmRQLNqGC4mhquZjkLf1cpJFBMLymJdISbmg
 U4Y4fL2wO8R5h+Og59bvBGhImMmrQCsAgh7xVBM2IghkoOiBGduXJQ7HQGKasz9NiTkqwZqP
X-Proofpoint-GUID: un7H_zbgxYLtQBYciQgQzkfNTXqGszOT
X-Authority-Analysis: v=2.4 cv=OK4n3TaB c=1 sm=1 tr=0 ts=68a28c21 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=Ut5Sv_cQT0ioXsQQ:21 a=xqWC_Br6kY4A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=rRErieL821EAsMUZkU4A:9 cc=ntf
 awl=host:12069
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3FD81A0006
X-Stat-Signature: phnxsfm57jm6n6cyp98qyz1xxxqhs94w
X-Rspam-User: 
X-HE-Tag: 1755483225-184968
X-HE-Meta: U2FsdGVkX1+5eaM+k/GZbDFJdj3svnS6SNR8mRm3JkGq1ks1Q42ZjsgXesSfmxBtcAp0Vk5Jhi78I4i/5GBQQzLDQ9x1JF6gi0zjHLZQPNVsRmI0RxIJ2Rtekhv7JLHcE1tKsqv3fwfZi0AM3F7b5vXk4OcXK1NLf1Zw/uZoAAdB9dQXJwpwD8JLn35rS+066x/8/VpXzNI5RR9mSCttUMKRlAOmuRwQS38P0kLIdcZQgtFCjIHe4Ja+DMssdLTE4S3iaKEiU1Rnl7tXQHqj6qSu+qZ/7X/qM0zkldu+nPoE3JOVvjOPMETFrbJm25Kr94l/MfFvNgp/0b9PUixNyJ5qd7dWvkgHUPw0D8tn3Mxm4XnQzZfI90a8F4SCBbjaftIZNExvlb9IPtt2sTw6WdecCAEe6GCAUZzJlN2cUwOLGMJsCejVo5lQyWaeUH+5c5pvXK4EnG99RHOGYuyiQJzfPustnb+kgdK+J5I3gWfDxu6XAmpgCMnho6cd6+Xz++3/ZmsPME4ouTY6f757JILjC9aXjQyHyy4s/coE3qDI5zCfy0s8xgNCYck2yhw3qlg92RnXwh27qCibT/EO96SS6qHlBjtbnbRWEC1twJB6/lN7REbRm85hcLM/QpX+QIxVeReY7WcnjSQz681XMsVF4geegyGClWIA92k9jk4hvage9WbdgQHB5WtiV3rYHaWKAfTJECG9BHakpmT/wRD9LBdZc+e3mhb5qugOKkQjcsk/DEA2R2dz3wSWpj+lQfEjje14dU1HoXKhl/KlpITk25TNRprIRAnzJ6VflGBUuTNKqeTO873xvmkELXLpMfbspn/bLNBs/DkExF2Kv/7PNgCOjPLg+nZoOpE++x+MoxqkgZtOgoV6LyVdlst5Mcf3DtDqYMcpcbVcIUZ+OIw6jrVfXcrbO2hx9SJaguZ8MO2S6+d1bPBikyCCoIxH5QF2gIo/fS4flL7QXAE
 mQGNTn6N
 J0fS3B+EV/8xyN8w2it42JinMxVQdTfFttR26pxMjHVF1veIYhzDi10vpkjuxKvJgCTPN/OY+l3dBtKrfUCPUWADdrq+MUJckq50oPFIrc2SqV77scI5Aft9CPdhtX13HvqoNw/XaEAXSqhU4F6ODG7mIcQirSYbE1/rrA04JbSO2ea00LfLLnJVDG2dBbSycE2P3LHuYaZ7YQUJmcAM6J9bHVE7izBV6VVrtq9hLpmABvmZiN37olQnO7U2DhGlJ8IY/buwAIHE7ZuZds6fLnXS2g4YbffuwGw3OntfQStLTu5xsVBqvaDprOLtP0t4z+8g6YHhW3nlIYa11B6eHUbCVVu+CslrVZvd/uGPTcahQDcxxg17nvraVed/DehgOfaWRTY9ymC3+qWWADYEHTllqmc9m/B5Xq53XwRBnmFuawCBy7FnFXJ1h44vXbQcBrMediFZ0d1hGIePcZ6XnmPA2eSgj37/WhTWIs1EmMBov0+f4JFh/0nWcaNfxYXDSzOV4xcuY0K2aD/VSVUNbN6YZkvRGm4izNQi9vlVPz8jpeq/J37oSudSDd7Ee6bkFOPFpbWYiyWmvbscW3dogDDXSbqDtemxcWGXk2ep887H2Ad1GLNv8/pdeqOVOEUG0to3PqMcC7zyhSoDoSf9aOQjsUy54laR2aifZGCA5ixvMi/12DkYdqB2DzZC45A+KG911+ZmzKnAVRDBPxWQS+EGVInvbUC/0w+eJGLpCeXUpd8Zicz8Z2PMzETwizYZ7W3mYK7H4D6mVWhwN8wBf9UGd9B141kxdojroaRzvP+iC2PzP9/yuonRAocEYr2uepZTRITMP+y7N8kJwJ9MomJmhdBf0VaTExDM5BCvVfv/D8QNaC6fj+s6k0JxAWcaqtx2qfi9nPbn6ZGA7DqnDNv53mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To x86 folks:
It's not clear whether this should go through the MM tree or the x86
tree as it changes both. We could send it to the MM tree with Acks
from the x86 folks, or we could send it through the x86 tree instead.
What do you think?

This patch series includes only minimal changes necessary for
backporting the fix to -stable. Planned follow-up patches:
- treewide: include linux/pgalloc.h instead of asm/pgalloc.h
  in common code
- MAINTAINERS: add include/linux/pgalloc.h to MM CORE
- x86/mm/64: convert p*d_populate{,_init} to _kernel variants
- x86/mm/64: drop unnecessary calls to sync_global_pgds() and
  fold it into its sole user

v4 -> v5 (Only cosmetic changes in comments and commit messages):
- Updated comment in PGTBL_*_MODIFIED that I missed in the last version. 
- Added Acked-by, Reviewed-by tags (thanks Kiryl, Mike, Lorenzo and Ulad!)
- Updated commit messages of patch 2 and 3 (Lorenzo)
- Added a comment in arch_sync_kernel_mappings() (Lorenzo)
- Rebased onto the latest mm-hotfixes-unstable (e4321cf73f53)

$ git range-diff \
  rework-sync-kernel-pagetables-v4~3..rework-sync-kernel-pagetables-v4 \
  rework-sync-kernel-pagetables-v5~3..rework-sync-kernel-pagetables-v5

1:  003cb4e564d9 ! 1:  79c2286f7739 mm: move page table sync declarations to linux/pgtable.h
    @@ Commit message
     
         Cc: <stable@vger.kernel.org>
         Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
    +    Acked-by: Kiryl Shutsemau <kas@kernel.org>
    +    Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
    +    Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
    +    Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
         Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
     
      ## include/linux/pgtable.h ##
2:  7493cc93874d ! 2:  c3c34f3ed699 mm: introduce and use {pgd,p4d}_populate_kernel()
    @@ Commit message
         and the actual synchronization is performed by arch_sync_kernel_mappings().
     
         This change currently targets only x86_64, so only PGD and P4D level
    -    helpers are introduced. In theory, PUD and PMD level helpers can be added
    -    later if needed by other architectures.
    +    helpers are introduced. Currently, these helpers are no-ops since no
    +    architecture sets PGTBL_{PGD,P4D}_MODIFIED in ARCH_PAGE_TABLE_SYNC_MASK.
     
    -    Currently this is a no-op, since no architecture sets
    -    PGTBL_{PGD,P4D}_MODIFIED in ARCH_PAGE_TABLE_SYNC_MASK.
    +    In theory, PUD and PMD level helpers can be added later if needed by
    +    other architectures. For now, 32-bit architectures (x86-32 and arm) only
    +    handle PGTBL_PMD_MODIFIED, so p*d_populate_kernel() will never affect
    +    them unless we introduce a PMD level helper.
     
         Cc: <stable@vger.kernel.org>
         Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
         Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
    +    Acked-by: Kiryl Shutsemau <kas@kernel.org>
    +    Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
    +    Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
         Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
     
      ## include/linux/pgalloc.h (new) ##
    @@ include/linux/pgtable.h: static inline void modify_prot_commit_ptes(struct vm_ar
       */
      #ifndef ARCH_PAGE_TABLE_SYNC_MASK
      #define ARCH_PAGE_TABLE_SYNC_MASK 0
    +@@ include/linux/pgtable.h: static inline bool arch_has_pfn_modify_check(void)
    + /*
    +  * Page Table Modification bits for pgtbl_mod_mask.
    +  *
    +- * These are used by the p?d_alloc_track*() set of functions an in the generic
    +- * vmalloc/ioremap code to track at which page-table levels entries have been
    +- * modified. Based on that the code can better decide when vmalloc and ioremap
    +- * mapping changes need to be synchronized to other page-tables in the system.
    ++ * These are used by the p?d_alloc_track*() and p*d_populate_kernel()
    ++ * functions in the generic vmalloc, ioremap and page table update code
    ++ * to track at which page-table levels entries have been modified.
    ++ * Based on that the code can better decide when page table changes need
    ++ * to be synchronized to other page-tables in the system.
    +  */
    + #define		__PGTBL_PGD_MODIFIED	0
    + #define		__PGTBL_P4D_MODIFIED	1
     
      ## mm/kasan/init.c ##
     @@
3:  f199138e40e6 ! 3:  4ad9ce5c09c2 x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
    @@ Commit message
         x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
     
         Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to ensure
    -    page tables are properly synchronized when calling p*d_populate_kernel().
    -    It is inteneded to synchronize page tables via pgd_pouplate_kernel() when
    -    5-level paging is in use and via p4d_pouplate_kernel() when 4-level paging
    -    is used.
    +    page tables are properly synchronized when calling
    +    p*d_populate_kernel().
    +
    +    For 5-level paging, synchronization is performed via
    +    pgd_populate_kernel(). In 4-level paging, pgd_populate() is a no-op,
    +    so synchronization is instead performed at the P4D level via
    +    p4d_populate_kernel().
     
         This fixes intermittent boot failures on systems using 4-level paging
         and a large amount of persistent memory:
    @@ Commit message
         Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
         Closes: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [1]
         Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
    +    Acked-by: Kiryl Shutsemau <kas@kernel.org>
    +    Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
    +    Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
         Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
     
      ## arch/x86/include/asm/pgtable_64_types.h ##
    @@ arch/x86/mm/init_64.c: static void sync_global_pgds(unsigned long start, unsigne
      		sync_global_pgds_l4(start, end);
      }
      
    ++/*
    ++ * Make kernel mappings visible in all page tables in the system.
    ++ * This is necessary except when the init task populates kernel mappings
    ++ * during the boot process. In that case, all processes originating from
    ++ * the init task copies the kernel mappings, so there is no issue.
    ++ * Otherwise, missing synchronization could lead to kernel crashes due
    ++ * to missing page table entries for certain kernel mappings.
    ++ *
    ++ * Synchronization is performed at the top level, which is the PGD in
    ++ * 5-level paging systems. But in 4-level paging systems, however,
    ++ * pgd_populate() is a no-op, so synchronization is done at the P4D level.
    ++ * sync_global_pgds() handles this difference between paging levels.
    ++ */
     +void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
     +{
     +	sync_global_pgds(start, end);

[ The actual cover letter starts here ]

# The problem: It is easy to miss/overlook page table synchronization

Hi all,

During our internal testing, we started observing intermittent boot
failures when the machine uses 4-level paging and has a large amount
of persistent memory:

  BUG: unable to handle page fault for address: ffffe70000000034
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0 
  Oops: 0002 [#1] SMP NOPTI
  RIP: 0010:__init_single_page+0x9/0x6d
  Call Trace:
   <TASK>
   __init_zone_device_page+0x17/0x5d
   memmap_init_zone_device+0x154/0x1bb
   pagemap_range+0x2e0/0x40f
   memremap_pages+0x10b/0x2f0
   devm_memremap_pages+0x1e/0x60
   dev_dax_probe+0xce/0x2ec [device_dax]
   dax_bus_probe+0x6d/0xc9
   [... snip ...]
   </TASK>

It turns out that the kernel panics while initializing vmemmap
(struct page array) when the vmemmap region spans two PGD entries,
because the new PGD entry is only installed in init_mm.pgd,
but not in the page tables of other tasks.

And looking at __populate_section_memmap():
  if (vmemmap_can_optimize(altmap, pgmap))                                
          // does not sync top level page tables
          r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
  else                                                                    
          // sync top level page tables in x86
          r = vmemmap_populate(start, end, nid, altmap);

In the normal path, vmemmap_populate() in arch/x86/mm/init_64.c
synchronizes the top level page table (See commit 9b861528a801
("x86-64, mem: Update all PGDs for direct mapping and vmemmap mapping
changes")) so that all tasks in the system can see the new vmemmap area.

However, when vmemmap_can_optimize() returns true, the optimized path
skips synchronization of top-level page tables. This is because
vmemmap_populate_compound_pages() is implemented in core MM code, which
does not handle synchronization of the top-level page tables. Instead,
the core MM has historically relied on each architecture to perform this
synchronization manually.

We're not the first party to encounter a crash caused by not-sync'd
top level page tables: earlier this year, Gwan-gyeong Mun attempted to
address the issue [1] [2] after hitting a kernel panic when x86 code
accessed the vmemmap area before the corresponding top-level entries
were synced. At that time, the issue was believed to be triggered
only when struct page was enlarged for debugging purposes, and the patch
did not get further updates.

It turns out that current approach of relying on each arch to handle
the page table sync manually is fragile because 1) it's easy to forget
to sync the top level page table, and 2) it's also easy to overlook that
the kernel should not access the vmemmap and direct mapping areas before
the sync.

# The solution: Make page table sync more code robust and harder to miss

To address this, Dave Hansen suggested [3] [4] introducing
{pgd,p4d}_populate_kernel() for updating kernel portion
of the page tables and allow each architecture to explicitly perform
synchronization when installing top-level entries. With this approach,
we no longer need to worry about missing the sync step, reducing the risk
of future regressions.

The new interface reuses existing ARCH_PAGE_TABLE_SYNC_MASK,
PGTBL_P*D_MODIFIED and arch_sync_kernel_mappings() facility used by
vmalloc and ioremap to synchronize page tables.

pgd_populate_kernel() looks like this:
static inline void pgd_populate_kernel(unsigned long addr, pgd_t *pgd,
                                       p4d_t *p4d)
{
        pgd_populate(&init_mm, pgd, p4d);
        if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
                arch_sync_kernel_mappings(addr, addr);
}

It is worth noting that vmalloc() and apply_to_range() carefully
synchronizes page tables by calling p*d_alloc_track() and
arch_sync_kernel_mappings(), and thus they are not affected by
this patch series.

This patch series was hugely inspired by Dave Hansen's suggestion and
hence added Suggested-by: Dave Hansen.

Cc stable because lack of this series opens the door to intermittent
boot failures.

[1] https://lore.kernel.org/linux-mm/20250220064105.808339-1-gwan-gyeong.mun@intel.com
[2] https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com
[3] https://lore.kernel.org/linux-mm/d1da214c-53d3-45ac-a8b6-51821c5416e4@intel.com
[4] https://lore.kernel.org/linux-mm/4d800744-7b88-41aa-9979-b245e8bf794b@intel.com 

Harry Yoo (3):
  mm: move page table sync declarations to linux/pgtable.h
  mm: introduce and use {pgd,p4d}_populate_kernel()
  x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and
    arch_sync_kernel_mappings()

 arch/x86/include/asm/pgtable_64_types.h |  3 +++
 arch/x86/mm/init_64.c                   | 18 ++++++++++++++++++
 include/linux/pgalloc.h                 | 24 ++++++++++++++++++++++++
 include/linux/pgtable.h                 | 25 +++++++++++++++++++++----
 include/linux/vmalloc.h                 | 16 ----------------
 mm/kasan/init.c                         | 12 ++++++------
 mm/percpu.c                             |  6 +++---
 mm/sparse-vmemmap.c                     |  6 +++---
 8 files changed, 78 insertions(+), 32 deletions(-)
 create mode 100644 include/linux/pgalloc.h

-- 
2.43.0


