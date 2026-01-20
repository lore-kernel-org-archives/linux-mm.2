Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0652ECA5FBE
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697856B0477; Tue, 20 Jan 2026 12:49:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657456B0478; Tue, 20 Jan 2026 12:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E89F6B0479; Tue, 20 Jan 2026 12:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26BCC6B0477
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:49:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E07681A06B2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:49:39 +0000 (UTC)
X-FDA: 84353079678.23.77DB47A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FA3D18000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:49:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sV7BGm4b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rnNp6DSN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768931376; a=rsa-sha256;
	cv=pass;
	b=vaypaidAZNYXF3Apy+jX7UizWyq+WRnTFRkxQ7HHYJCeUl3+A91V3JkvWpJWLEtTcHtwXy
	U8e8OsFvwrrL/lZiC1XwhjQzz9HPlHnRifjKhDOB9emjNXtiuw4pBEw5Ig2p9oqTPYnJ6l
	chbuuYqvXesgnd5hldoEmIcrNXO5k6s=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sV7BGm4b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rnNp6DSN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSReaAxQ48MqKhqPM7emx0GGqGE9t1T8GAjW/GwG5Mc=;
	b=KJ1iduWkRYmMaZl+Z/E1NtCTkRo7KUpM+bDvIwC7THyA+fgVvT1xuxPHG9K97ZRctJmEeC
	a4qVGeKHDYjzsv30fB0ZRnO/+SE1wqzLLsTSYYrGz8tdR13vKVT+SxIA/rj5qAsuUThorl
	UPWdNmazAUra9BEka4ss5rGdflvhHH4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7uvmF3265007;
	Tue, 20 Jan 2026 17:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hSReaAxQ48MqKhqPM7
	emx0GGqGE9t1T8GAjW/GwG5Mc=; b=sV7BGm4bHaDHmr+t1lZ8WrQfYBIdbelm0s
	zm0803TNkXLfl/vdiHzsKbTJmTx78NDjHJJQJjrOub5qAdRiCgG5MWmukQFjTjqk
	H064HZfzu77qbkXbBRxmzGQcQ1EKo2MN43pPprLQNEzOmALCM4y/eLyTd/O7O55F
	GTNTvDyf18tvV5NWJrW5Xi/KizZl7oE3RByO+VwrDBdcGVVJ/1CPRuYUC06AfnWw
	hLUZBVxI1chcUTgeUY5Sd6PJTFcFEV5HQBiAUB9Xqso5fItmsiXxYtnla3u4YKgJ
	Ble7hmu4jliBzonZZ0RolHOIG+pTKLQnn39O2iAT494Eg3/3KQuw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8c4b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:49:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KGDgIe019003;
	Tue, 20 Jan 2026 17:49:20 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrqtsw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:49:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lcrHRAXGdBtEDlbIi95Hbbx+FGr87Y5i9in6vd71pemO1Vt9s2mdHo+ZoZFSxCQg+tH9FLUdsaFNzYGy58z8o1dz550spzTqhBDqyiPHBM9evrGxZNnvUE1+ABJGuR/sXhpwGRgGeftBhx7qO7aiXfxGv9Qm3RgAsMM1nTH0oKcUAL+uqOtWhHsPP0+0bW88ZWEaDg6Ad3bSpTlNTbKn7/ZZt5F++Uha3+kCleSO5VKHDAIL0sksQymlQCCIzQrtXy7/sH91E8itDd/lsHAnYA66l9EyDtOKvn9nFlo6P6uzQDtTUxVoQ18nhprJquQSdEQNxp8Jd4MU9OSIwxKaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSReaAxQ48MqKhqPM7emx0GGqGE9t1T8GAjW/GwG5Mc=;
 b=ZdvI9HaffMfTGWe6Opj0SO3ZsI513tukJKjCvMyYRTTNvUD7TuEPVDrg/z6rfQKEoxNBhVfhnsMWth6SOAOh+w/4BMADR6YiDf0i2iIA1qKXeG4itCyTxNyrQvsJ8h8eKOAVRyaRHWGnIVN7sNiCEu/bnTffj2zsrHG/T35Qd8aB5uyezWxJHtLUFqlvT88zypYQSxS2hnHgev6EfAK6weVSuYC+NCy/FOFMFpXyEPRzESXmzvyYyqDVBnuxxH7M43CM1v10B14koyavThvaByt1FPwTrgf2E5Yll0ftuUWJ/LuTZE5aPbw7kCFJ6a2NoMTEfImeLc9dVxYLXI58ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSReaAxQ48MqKhqPM7emx0GGqGE9t1T8GAjW/GwG5Mc=;
 b=rnNp6DSNfOieiIzLVydDsvHum3uONAVZZNIEASNj/NEMBdTS9VjGfY4Y2XbV8Wb4mQ2m7pd6n1awDiEooUR1FjE6kdKlswicgS+Z/Hf5g97BROBuSwCKhJ7ewzF+GkOFExS7If/808Yk70ImNSJ6maJWJsH3BKiUN36zHCOY6IA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6891.namprd10.prod.outlook.com (2603:10b6:208:431::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 17:49:17 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 20 Jan 2026
 17:49:17 +0000
Date: Tue, 20 Jan 2026 17:49:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] mm/vma: use lockdep where we can, reduce
 duplication
Message-ID: <61ca35cd-5c08-4196-89b6-ec3feda69e36@lucifer.local>
References: <cover.1768855783.git.lorenzo.stoakes@oracle.com>
 <bd410fd91d22eef37f9b617327cafce33b267b09.1768855783.git.lorenzo.stoakes@oracle.com>
 <30f843d9-03cf-4c7c-8a29-8e11b12e47e4@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f843d9-03cf-4c7c-8a29-8e11b12e47e4@suse.cz>
X-ClientProxiedBy: LO4P123CA0456.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6891:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca1337c-df23-42a4-5631-08de584c3b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7i7xmf/gwCblH9VSGNsISqgIIpX5BzVGfZ2U4lFJUSU8tpLscIwPxTfMWpEZ?=
 =?us-ascii?Q?l9gQduZufAt3ns2ZHBpM88IikRd62XYQhn0cLeO7e0+rxP9LTAHjA2sDB9fn?=
 =?us-ascii?Q?8NLLMH2ncnrwy7FiL5hWG41zyYyegV1JEbB5PzgmSU/xrYiqzbDV1MykH4Qg?=
 =?us-ascii?Q?984VqZJxYkRzXlr2Rwa+ds860AaVQVSsEe31tuwkwCVOSCfalFiYG8FDHy9Q?=
 =?us-ascii?Q?R8EjAGqd+OkJUlwfTSek4086laF90Wzhe8SZA5IupCy68trfNewLrkj32Mk0?=
 =?us-ascii?Q?Of16ztEOdMe6bpT1V7oxBrZbKu+4i0JgTvsH+biQsButVxjKARxNYNzYnlbj?=
 =?us-ascii?Q?VMTWb+eHgbRNvvrL1htIZKapEnDGvAUoSWdNZnDPWnXrbHDD1LKrIfoSAYpX?=
 =?us-ascii?Q?FvLmEaG3crQ8L+5C842sBvu1On8UKUiyIkUVbf/pjdYe1o4QRqcp75Xc8iQc?=
 =?us-ascii?Q?YeDuovc+C0Y3eLGz+iv+N5HxsxW8Fkxc7Y7SE+GYHlqmiBI+WcoKl17+eHqP?=
 =?us-ascii?Q?tphX/XQL3sEtMgEDd4UpkT7eDBHcoNSPPfjcCOvyW/9isgFqcmY//j97PJl3?=
 =?us-ascii?Q?LXejXrmED74Xiq1qbn2KFNSgdG2nJ24rSfpeT74IAhNtmWhab4DCd04W+vBt?=
 =?us-ascii?Q?+5qowO/XTFmzzVAHyFybuOSjWvsQQvOG/3Chel6TMhd/W0F06Gqw/tKorfqv?=
 =?us-ascii?Q?vQzyMhgVTLl4AetDADhWhWuvQPWEOsvX3f8NSKgW4UecxhD1J8iPN4rc0kXm?=
 =?us-ascii?Q?Ij/ipCAuBmsN6z2z9W7CQiyEFYxNYJWxa21u8bojaBHzdXNEnjyovntgF07R?=
 =?us-ascii?Q?eq/qeCY+PEi2CiozMi3FypV89Pp2gNu9qdPq+cYknYvp8y2fgo86hFH2PnLJ?=
 =?us-ascii?Q?OWMiNfmDLVtEa3r13YELDA96v9sz/0hKxCbVBZV07xLNA0J2KrS3M9dUtQI0?=
 =?us-ascii?Q?gnbk4OeQpO31z9D3e9v0R4e7n48ApP9M4ECTviektxX0fEvnRDvNAWR2rse6?=
 =?us-ascii?Q?A55QahRmHoGhclWMvhP0E5p8/IRLuCfgHoDWjfLWpKwUxKbq1ilBgASPw30J?=
 =?us-ascii?Q?CcMcEQU082mXei8pACdKkAKiyzjTB0NUxxoJ47aYxnhTazHam2+EJy28KPcO?=
 =?us-ascii?Q?E8gE6A2TUzOeTb7sOapglNDjUmzUckwEMEFJ6DoO2WNIfQp+nqdQSA06COUL?=
 =?us-ascii?Q?zRW2v/vIZguKcC4EyizbAUXQ1cTGo6n2eWK6o1p0pd99cWVYPNl7CMiOzrup?=
 =?us-ascii?Q?+2Q2BwhUvxMh8wI1VFiXAZdC01WXykA7hOrsVED5QJgXN+xqXTgx09NW8m6Y?=
 =?us-ascii?Q?r7au0OBCOaUonXBoOSu20vf4JxE86b40eDtMh8SRCXh5p8GIeNTgLPgZuNtq?=
 =?us-ascii?Q?D01Y2VZsR5TdxE0oto68aBtYklNXqrC4PV6yCIVNPP86UDB+gsvGqfDTCz3a?=
 =?us-ascii?Q?EHIXVxDRQsQfX0cxKj8IENT1k2USLEtwFLr1aNzmnAlETaszXU+sKLcfoJir?=
 =?us-ascii?Q?C0V0lR3auCsKZoXX9h2Y0DMPCs1UXomnObVQIacG2O7g6HIy14Og2+N7dgV5?=
 =?us-ascii?Q?ye00wSaCxR10qXm+z7I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3wi79D2V9KaCAWO4FUDg8M2MN0NKWnXSVtbmTHQ3va8obNbUZm4g29TABYJi?=
 =?us-ascii?Q?Sq/NvJnWQsbpb/yTLvww2O3/+d4Pr4ic71IH9zC0nDmW223awv6PgnLFGhdK?=
 =?us-ascii?Q?PQ0auUu/zjzNqOPdVspnPw6qvBCoSu+g5FDpH3ho/FNI/4QwVPvvzm7XdzLK?=
 =?us-ascii?Q?HZIJZujuhtrGJqOQeouQ1ykuWThnhy7bOo2nCBGMiCjCecKkwNr/G/KlXVwy?=
 =?us-ascii?Q?XPgCYTU+bnP23upMHzI/07A+DhnC/dK7GhU+VHUBYQbenERwcMtYezH0BRkU?=
 =?us-ascii?Q?drpbWe3f6fasMabbsJ5FTQqs6iahwPRmj2/rbycrDRgiGY6+FydqKFKPIn71?=
 =?us-ascii?Q?hFNxHYc8+lEEaiTtIs8pcgUyzw4ij93+Y/I0fTZtXdFaQAU+yBscUW2msKL1?=
 =?us-ascii?Q?TvPKXlxKt8bJrxc0IhLFfJBJTZ2rpAP7AyfjTETYiseUGLthat2Td+Gy2sHY?=
 =?us-ascii?Q?F9astiiu+Dtv26cIbzpLj/t4t1NaIH+zOHPJiIG5LZpJfDj7RglBzahRVwel?=
 =?us-ascii?Q?cGyTS2pAfr+i5Hn2XUiJ2MLzB8pqhdZ+4re3GoZgS31kNpJZshdBiPMg06oA?=
 =?us-ascii?Q?Ix5KI6xM7IyjpY5JWH1alHgMa8xQKx5PTtWgnbZALjVwoCmuXkqyrvSv/aHw?=
 =?us-ascii?Q?ZjxlWKgwyeIFRyXMgnq8hEpG8cLnJOCYecoDxHeIYy3WiSYfRsS4VAK2jjK/?=
 =?us-ascii?Q?E3+HRq4c0XzusOBgb3qzfH268dAkQPUmy23/z3SX2S6LicNR25n8ap3Zrvw9?=
 =?us-ascii?Q?gbhxoekTm3BhbwRonTi0XFYn3YBa2s8L1sE/I8Tw8VHow8DSEumUEOeN9wcq?=
 =?us-ascii?Q?TRMipAzRFZQTtO4pvJ9NKB4D5g8/X0JFeo899mzDZAoxOK7Kv+OVNSLDyCTQ?=
 =?us-ascii?Q?vS3hnPL1KVxH2e4cCo3NC/VB/F1Pl3XSZGaRWs4d/3Et4IFI0HxY4IKaG0Xs?=
 =?us-ascii?Q?GKsZQsR9U47MqCSjiU7GZ47I0IU2v3ZZSg0QnnlMJJbShn9RSKSPKBVlKeRs?=
 =?us-ascii?Q?63qBXek5eekMjQ2qmKpw4ERWUFPNdr43rMEqGKinyShQ7/peIYazgaS/Ed/J?=
 =?us-ascii?Q?RnEjgZMpCJx4jzU72IGytG6c2mFgrT/dtk/akBbFefFs6+HGNALimHx1PXqF?=
 =?us-ascii?Q?eyBLrMtm8BvdU1EV8xAE0Q4fXc5WH7Uy+uIL219RQNga8LeVIKCMuMqo8lfm?=
 =?us-ascii?Q?2PBxyk433XNuOUVQOMvulObYvOHcURuGLGEpbiqesAUM7I5LFdpCKRNsmOuY?=
 =?us-ascii?Q?PaVxX1iLFstkib4cdiglO69yIIvZzghgNXiR1df20sStz5D89/XdDS+0AyF8?=
 =?us-ascii?Q?XYSROB3nxqdgmY0U4segGU81bIlU+pJAE9V3WSU/riVKHDJbfNiK38ypQa5o?=
 =?us-ascii?Q?3rneVRPtpDx+WhJREzBNKe2Waw/npYLssQxHVrxR59fPMWvJXZkqdEHwRC6H?=
 =?us-ascii?Q?nGQJnEbAofBxJznrSBc4clA+ytgylbcPBKHkHo6rjWdaLUvkXRIgFR688qpX?=
 =?us-ascii?Q?HFECYH3oPL7MzUEx5Ui6CA2GkW+MP49B8XDD+vYsqZ+B2dDTK2+/AcUwJKvJ?=
 =?us-ascii?Q?vwyFbQbsJ9ixPTuFjALq031Hszu77hf9fb80iTER9jtF0akwGildPpmKekeV?=
 =?us-ascii?Q?6rn93/trhrDJGLxiAjnD2yitRMxunA9Vo7Uoqa6COOqic08yzTH9XY+o0Kwj?=
 =?us-ascii?Q?YEBtFYDOlZiZumkfJg17ZG1ruKQfipJfdtCfpMAfKuUJoGhtGepfoXSru2uE?=
 =?us-ascii?Q?pJyWDNJfRIdnbMueZjG3nyVC0OcNEt4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mR9iCjJLZgq2KHrpeR/Me7ahXFjWTFDkt/qWHDtFpPG+YsdUyitXIpRzWF8P161TM58gDZzVtOHeb46NO2Ij2Q64zfn8irKb8pAH9gd+4uyUK32LBC4munA4op6UR+xqJXW5eaOZy3QoIzyBvrXfWBCGKSXGQ+1zk3xiG2jphq5kaci+kmnrFt/XCb7yhlC6UmrTFBzUJPTqqM89mS5zYIHNAo/qPIpsXorYR0Eo31+g2ETUgNVjOcli4BL+1ui95otMr1dHfQ7bgJeoRynAKKH7Jczc2md9FyYkjxBaSMbLxt7oZ12YgWVEqgaILO4sNIe0VYcok9soY+ClFv9KH0cSJZi/Hml3SY7mHgwndmnIS3TxxVSfuEJ23RB2cm9JePgipEu534+S/tQdrM+J+iQNxihb4g/Bfp3KTiARq983N8rvE3ukRNX2A6UETa79qovEQokoMPtorI59R6ipiLU/DSLjqo4mhEAE4ZO97I41GphV0PEas0PO8nVU4Kw/esAxRe3dhtD2AXE7tWjTm1rSDfbVmqJorI49pIYP78ZdJeava/DDOZIVSfqVg87rAQ8gPoIA8Un0hk0w/t6R/BeNgC3961VMmOny/xOpkAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca1337c-df23-42a4-5631-08de584c3b46
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 17:49:16.9900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pm14VJdrBj6s1tQ1mfaDmI/KgiobooHFKgCFAKupyt1A1BeHIQ+Ae7J8EcwKr1sRUSkLamsaWflt05IuNfSFAtVkQ+MR5i1PmXhqcAy+pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6891
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_05,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=660 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601200148
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696fc021 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=0S4gV3rVulT82tTG4QwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE0OCBTYWx0ZWRfX+/SMW27RcNwb
 BSI/8lgEbjTS7PNTTdzrISpPhRwW2E/HcMLcoOkpuo/2XVOONdcsfoaHEz+gn9wv+vnGWj5lkHp
 bo7wmbJhknV6WxiQ2aPgWW0svpQPmKospfMW4PaMaPV9at5bR2K0LQXvgEl1c3tpk26+4nR48mp
 ramMJi0xidjH8NXak51rO7pnZJplp22Z8JXPlDsH6KCJvPIAhZnJBsjb3TLqe+5JJuPxYXeYHEu
 Ao+ymVljmrxyeCGZjXAaYa4Tp6gWnClsZWK/uA0KkRA4hW5ndh3wGnB6EZL9rRR+m22vgkLglQK
 YTQXrttiv8vgfgSth8Og4GRkqL9hUibiOzWiHtZOZ28iIP6LHfktDlZmWfsUQRT4uBvXXSENyyK
 Cf0xiaTrESK2QRiMV4xLrTRvaRNUIRc7f/G+WQ9DSzrI5RZBUVUlXS89dxzLMPwKnfqU4yidcsD
 puih0B/63PPmZ5vKU83vuw2kJsEdL7aguenaveRk=
X-Proofpoint-ORIG-GUID: XwDeBJX0P8sL1cpi4O6W9x-9rjlsqnEB
X-Proofpoint-GUID: XwDeBJX0P8sL1cpi4O6W9x-9rjlsqnEB
X-Rspamd-Queue-Id: 3FA3D18000B
X-Rspamd-Server: rspam06
X-Stat-Signature: theq8d3mzotstoj8noraqie1bz76xtgi
X-Rspam-User: 
X-HE-Tag: 1768931376-700649
X-HE-Meta: U2FsdGVkX1++0233fmzFY1+cMXSoIDY0AXpeSFqtmkKKGDm/31EzZhmHzxaRTV0DNK5S92dCyMnosNVavCrZ0BzMR8fIxEgh28zfHa0TzdYmxk2+ZD0pNWewlzLplGj1sR70NbsL5wPCFiG/Ezn4T1vkwF36/XyqYIgOEyQY7X3H5CC3+H2NGiFXvW0IhH2a2vDEB6BGVJer1paWYIy5PskpJXKD/I/MFRh1oC2ueJe95IXwj8hRacbM1j0GLI0ThStqFrKkSqMbfnsdy82JBzkokc8ydCAfvi8MzavTumFEaXuQVHlT4BhgBwgb2rqgVfXMvyDUgqbUUYd21F4nMa9Qt5j6vCei2pW9OYhU7kbZIApOHXVJOWoNVmIGebC1SPDHVkMXKhMASzUX+Q8tTsqMLK4SSgTULLDBuEhxjv1zyo2Fp/E/0Fnn7fLD+PgT92SGMJt7PRcK0hjQLuTLbS8lQRJHSm84XyXnQu1I+DhXBgU/n5uxXu+v4RIT89b+2ZViO5N3Jd3RCj01Tt3bBmVWYkHMFXBlNdx1Rtv6jX5TzN1BUY49T45hhOnE21zXr6cX7vPBWLVwGA76EoNbdoJ4Ct1J6UbLVIjQWkrUTHDP84FfjeZMnaQ9hAEFP1u4S1YAECn0b/JAgQmewxofckVpRWlHyNyHzZil6SZHKA5rWkSoxlcCPRbEnya50IqojOCBymn6XXa2zfu+oHHGEuNzhNjZcFQWPOK6tsCV03D537BfHfFnckYL7/K41EhClGd3yZsIanvIX2HBnPO6rwKRN8NMilaQtE6LzaM9Q4lIAgkcAdIMpdgbZXIkq4RypxR2A6O5c5UN9OxmeIhmpHvqG0JHfmEiE7+5wGsZFe5OvoCDsnrYyO2byAjo4spUdK4iYFJge7mlkVjQ5pSIP2aU9/ZUzuQOBqUl2Hva7hYu1xjaCWjwASh7dzsQcH43J4YybBoyfYRX3PBYqbL
 weMiRDko
 Lqz+1ULFxqBbI5ulYcBQMmY1aXW3k6Ef2ldzI7PyP37f9CD78epww+/QBHA64FF3URpZJvn8LKgqzV8eJq9kwrHbTbfz+z3GQ11NM+Z/3xu8sEd+80mMLGpHcAJSe9olqpm96NPV6Fzxh7JX29OPRkx1r0U8CEurdZiOenqATKEskJ90cQsSa+DoldOG4xn4ozu5U9s6/xTEgWNT4RctKhY9T1LoQJBlMwLDCpEAsZCD5g5117Bt9GPyGndeKbEvu7R6bzjHnzMtBzvZyIW93qCfsnsi29OrDW2CF4jU5m/VGZOMKhYzNMEoILC3CMGaJyPr/JlLvY+KdcFvFIn3DgYfwVb0fbr+tVlFL/jC+B2TW6HUoyZuiZaJv0DBNsfXteKXHJlJ8De/YawBQbfGyHczQKfaPwlzw8Mbw7GbZrgP4HKnSyO1V+57W7SWs/m5NqsA4LwwDgl3KYI4FGNUrC5r7z7eTAYlW1hM+0HO8w8jhTZGnRDrTVE2YbSk5n0fL36+3fwBvl63Lxx1LxlgwFgLdu58u7XWarkuH8kg9vTKmD/gGMhfCrqrh4A95G5wC6STzJPYs5PxdguvmqKwuAcRqtIriLK5ADiRZN76TMKQI8oqW7jvwl7VTA7k5L2Kf5QjZWCQe1Zg+KhF6/CXDltG659DfdlibwWkfx6Z45fyKaq6uv2KZRqlHV6npMDxd4r9L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 02:53:30PM +0100, Vlastimil Babka wrote:
> On 1/19/26 21:59, Lorenzo Stoakes wrote:
> > We introduce vma_is_read_locked(), which must deal with the case in which
> > VMA write lock sets refcnt to VMA_LOCK_OFFSET or VMA_LOCK_OFFSET +
> > 1. Luckily is_vma_writer_only() already exists which we can use to check
> > this.
>
> So I think there's a bit of a caveat in that
>
> - is_vma_writer_only() may be a false positive if there is a temporary
> reader of a detached vma (per comments in vma_mark_detached() and
> vma_mark_detached())

vma_mark_detached() and vma_mark_attached() I sasume you mean.

OK so this is all very confusing indeed.

This function is _only_ referring to the situation between
__vma_enter_locked() and __vma_exit_locked().

Despite their names, suggesting maybe they happen on lock and unlock
respectively, that's not the case, they're both invoked on lock and enter
on start of TAKING lock and exit on completion of TAKING the
lock.

It seems __vma_enter_locked() is more about getting into this state with
refcnt equal to VMA_LOCK_OFFSET (detaching - note elsewhere we say detached
of course) or VMA_LOCK_OFFSET + 1 if attached and waiting on readers who
are spuriously increasing the reference count.

So fundamentally is_vma_writer_only() is actually asking 'are we in the
midst of a VMA write lock acquisiton having finally set the VMA's refcnt to
VMA_LOCK_OFFSET or VMA_LOCK_OFFSET+1 but haven't yet completed acquiring
the lock' - e.g. having not yet called __vma_exit_locked().

With __vma_enter_locked() called from:

vma_start_write() / vma_start_write_killable()
-> __vma_start_write()
-> __vma_enter_locked()

vma_mark_detached()
-> __vma_enter_locked()

OK so in __vma_enter_locked() we add VMA_LOCK_OFFSET but then wait until we
get to either VMA_LOCK_OFFSET + 1 (attached) or VMA_LOCK_OFFSET (detached),
since presumably refcnt == 0 is detached, refcnt == 1 means write lock
finally acquired (but you have to check the sequence number).

And _there_ we could have spurious readers.



>
> - hence vma_is_read_locked() may be a false negative

Yup.

>
> - hence vma_assert_locked() might assume wrongly that we should not assert
> being a reader, so we vma_assert_write_locked() instead, and fail

Aside ->

	Every time I come to this code it's like this - having to refresh
	my memory as to how any of it works, getting confused, etc.

	This speaks to this being a broken abstraction similar to anon_vma.

	What I mean by leaked abstraction is that you seem to need to
	maintain the _implementation_ context in your head to be able to
	correctly implement anything. We simply are not abstracting details
	here really well at all.

	The fact I got this wrong despite staring at this code for ages is
	indicative of that.

	Also the fact an ostensibly simple series has turned into a
	'restore the context' discussion this long and taken this many
	hours is further suggestive.

	I think we can do better. I'd rather not do more 'cleanup' series,
	but I think this badly needs it.

	So maybe I'll convert this series into something that addresses
	some of this stuff.

<- Aside


>
> Howevever the above should mean it could be only us who is the temporary
> reader. And we are not going to use vma_assert_locked() during the temporary
> reader part (in vma_start_read()).

I don't think so? Spurious readers can arise at any time incrementing the
refcnt via vma_start_read(), so the temporary readers could be anybody.

But they'd not get the read lock, and so shouldn't call anything asserting
read lock.

Anyway I think my use of is_vma_writer_only() is just broken then.

We _do_ need to account for the VMA write lock scenario here, but I think
instead we should be good with refcnt > 1 && refcnt < VMA_LOCK_OFFSET no?


> So it's probably fine, but maybe worth some comments to prevent people
> getting suspicious and reconstructing this?

But yeah we shouldn't be asserting this anywhere during which this should
be the case.

So hopefully the above resolves the issue?

It's still racey (write lock might have been acquired since we checked but
that's just the nature of it.

But if we use lockdep as you mention we can actually do the same 'precise
if lockdep, otherwise not so precise' approach in the stabilised check.

Let me respin.

>
> But I think perhaps also vma_assert_locked() could, with lockdep enabled
> (similarly to vma_assert_stabilised() in patch 2), use the
> "lock_is_held(&vma->vmlock_dep_map)" condition (without immediately
> asserting it) for the primary reader vs writer decision, and not rely on
> vma_is_read_locked()? Because lockdep has the precise information.
>
> It would likely make things more ugly, or require more refactoring, but
> hopefully worthwhile?

Yeah good idea. Will do.

Maybe I need to make this into a broader refactoring series. Because this
so badly needs it.

Cheers, Lorenzo

