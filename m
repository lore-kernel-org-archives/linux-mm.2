Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F62DD74EFC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26CA6B050A; Fri, 23 Jan 2026 11:18:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFDD36B050C; Fri, 23 Jan 2026 11:18:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8F06B050D; Fri, 23 Jan 2026 11:18:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873116B050A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:18:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F8DF160394
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:18:17 +0000 (UTC)
X-FDA: 84363735834.18.0ECF323
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id E0E7A40007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:18:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b5QDnoJ7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yeGdRlCV;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769185094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUhDmTzUMMXE1zvb6Y4oJRIQerlZ3xR/bPx/J75Eo1k=;
	b=nI364S/3xqeA5oSB9752QqkWfcDeD0bI9+i5AEV/WFIce4B72qz5DKR0q5V0Yl85OHJWqw
	7Ny9pq2L/9ajAeCw/ZeoAOUTMjzYpYXAnrjjQwylKPUrG55Rti/CEykkQ2FJ7Uay7X76CA
	Zz3zJ74A7hYo1UhMBN+0JMJ3edTt46c=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b5QDnoJ7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yeGdRlCV;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769185094; a=rsa-sha256;
	cv=pass;
	b=iaPDvAzK12DnWLIDvyivpCW9pjdxRlFKd7tNro28vAHzwnDZ7Nk6MrIVqHfA4tJeehLah1
	BL22QYxSZMwgJLIxIB9xs8q8SJW6ntsKI75patdtBXZmxSV97L1QpizigYoOOjDL2W/wjU
	StW6T4vKsq4K+C1LlRpzp8fxInd7na0=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60ND6QMW2973522;
	Fri, 23 Jan 2026 16:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kUhDmTzUMMXE1zvb6Y
	4oJRIQerlZ3xR/bPx/J75Eo1k=; b=b5QDnoJ7hVRUKGcfNle9aP1cyYJ8PGpkRI
	NIL3l1UtGufGFfYOxp27eSCe9WRdIo6xHiIUHw9qw/OAeeyior7kUMXhhZxFvngt
	v4l6kkdIdfsXXaKBCBFkK/iKYiz0XJvjrLuXsWuP/hKKfSqi4diPsInbx+IRriul
	tVQwrrMyMNitVDW/v8SW+1BsN2LhhK7kMtvihRKtFSUm/nPD2+aix4qKSUyn5k/W
	o6aRPR+ngdX9tgqXX0Kj5a8r953dj+LnJLDx4PpAF+RArLlPhBAXEDHeQz2MVKgh
	0uY9XcoWos+JIPqMH5EG2suw0JV1EnGl66CWGYxqVPAa0YLrrFfg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcy8fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:17:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NF3dWN037984;
	Fri, 23 Jan 2026 16:17:54 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4buswc74ju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:17:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jenuWjzqMk7t4qMh8Hsf9BoHmL/FJ2rVw1JWrGmaVK9K4zThEhCtj3ULEyjFzZG0A/yrETzj8Ug1l1jaBTlhAzb9o90pbxDwwejikD/LqmYLbM0VOq07Eh9QB6x9iIk4NMXp4Bh8CyYoXQuh5JuMTz6h8gX0A1Pworqy70s6Mohtw2m6uPMpWsI+lzi+GkiFNtzh+4FZUPT0X25EzOPfd8cz00SRrZcKBUscEN/51uXg1ZFuQMpMKub4l4M+FoeVtEYFuPWEINmezAc15dRiWnZKfhaWUc1y1VGibf9d+2Vws+j55KRYwbajm2ItwSaK7nvtsztX3ofix6aUi6Z+Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUhDmTzUMMXE1zvb6Y4oJRIQerlZ3xR/bPx/J75Eo1k=;
 b=wRthyadA7nkrQ9TC2pFpe4Yr84YsD3Wg9BOL9buN7PR7A2da37aPMySXunJcpJeaaGk2UjmTDpCrfcyutdbIiYuMohKpflO+d5J7QYrejWlOunhAEEOK4geJ/WAYYa01SG+zEInd8klEat9y9vVDuptUn444BqUJkod4HWJ9Jtg/jyakhP2o0Tbyj1x5YJKMHb3VetYb5yWHLQM4B/R02naXRbtHueHAQMNilGHNAtRk5TTBiDHlY9kk9rxvKI4phRfq/Rzekb/hfqGdyj1o7h5jAJWGm56fTRUewASLXYZrCs8Ysw6htdaGR9MJaBNwWzng7b+NcXqfYMPO36vvUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUhDmTzUMMXE1zvb6Y4oJRIQerlZ3xR/bPx/J75Eo1k=;
 b=yeGdRlCVNPCAAHuAjkbz5ZMA/0Qp5er1WD+KJ9N/OktzwON1ZWmurLu6suPSkAK8nAi+gBvhjKr1S4Wy0CSAzSD2HoOeq6/HjZGNBwaLGQDs2aT08l31T5aTOyL+HpsuuLSvjgk0nF4kdZg50ellKl06P89+nr7wQlVybu/D8TE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by MW4PR10MB6324.namprd10.prod.outlook.com (2603:10b6:303:1ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Fri, 23 Jan
 2026 16:17:50 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 16:17:50 +0000
Date: Fri, 23 Jan 2026 16:17:54 +0000
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
Subject: Re: [PATCH v3 06/10] mm/vma: clean up __vma_enter/exit_locked()
Message-ID: <deb0271a-af67-4971-8e2a-be0f826aee2f@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
 <0567268d-edea-4229-8bf4-bfbfc2af1fd4@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0567268d-edea-4229-8bf4-bfbfc2af1fd4@suse.cz>
X-ClientProxiedBy: LO2P265CA0245.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|MW4PR10MB6324:EE_
X-MS-Office365-Filtering-Correlation-Id: a934a84a-2986-41c9-5c94-08de5a9af474
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K9sp1P+OLNZoDG7VVxFrsyGZO3GDJVq/y6TVls9mt9XVJKFoS5RjM9sbmZve?=
 =?us-ascii?Q?tDvCqOEBq9LG2uwQ2qw/qZ/SsFFKW9Sd5XO+Fj3DFBcRgF2zC+43r2ePzA8g?=
 =?us-ascii?Q?x4WZ/8W9D3Dd/gp+TF2ZRfqebFbL53HUUcDGzKGuqdb+QFW8SZga+lQcLlJC?=
 =?us-ascii?Q?gSGlYmb7yQ3ncVS+eHwvWBePFG4NT6GZ8/8tpHOunJLdaC9TAS5s0JE8r/Z0?=
 =?us-ascii?Q?nnN+Uo/vkxlUwmbsRPgYc/5riWfUz8WvapQwtbt8OF685DNwJST+Nf5pogjR?=
 =?us-ascii?Q?VU/1GK1ezP0BEL5dN0z0Pz7LzrU61ANUbWAiGBmNVVgULCzbyCOT73fIaspD?=
 =?us-ascii?Q?uV8fADXVd+0Wfxm1nSi+D47fnjPts2wqgUjE6i3WTzMJD/zbXAWXFRtNtJo0?=
 =?us-ascii?Q?I54fq4gwb7v71354NwNrXfPaq960mkuYuMPQMats9L/StDBWnsuMpTrhSo/g?=
 =?us-ascii?Q?Ns0CXEdHUOsWKaJXTvOZDDfyzPIY/RJw4EQbTgOqV6QA4RASADM1ZqQbtvg3?=
 =?us-ascii?Q?Wo2X6FQ6evdNkZzQyzTyDPF7ySd2BtVdB6K+f2LOTCjSJIA+b7w6BJaH1bCE?=
 =?us-ascii?Q?xat/wIufwLt/46eRI5n29o64ml3aztFi/VLf78ooRCwREZnhHV+IaiirorXC?=
 =?us-ascii?Q?faRBUynZlU+7wdeIKnJ02UV+5k/Li5yYzT4KzI1UeOr0U07hGnSlAG/PRrfU?=
 =?us-ascii?Q?kiN/on6VtBRTTeMIH4tP3sbTCjOcbPtgSrsVdbNgNkjwx5nFxNnd1hKLDmYQ?=
 =?us-ascii?Q?Ru/uLqwludZz07gKUt+gjbEekhDw5RVYxRl3+EgLvvaz1w/A91xfukHKSDtn?=
 =?us-ascii?Q?Odb2SoM4ehREmnk6CK2FhqJQYRkNgJzq0jMwDSSlV2ARaMKixvg74JImpiZN?=
 =?us-ascii?Q?7QNbQLeX8PQ3oVO+yhbAthWizF8Wrs69Ob+gEbEKlNbtfKuw7bN4jH1cGVOR?=
 =?us-ascii?Q?ov9GafKN+acQY9BEAk46y0lYqyLoRZH07IvSGYzUFCWQGmiL+bSmf3rciXxk?=
 =?us-ascii?Q?ogWQ6t8yMC20AENKllaQIeNL0GhcnSFbuLGyNrgo46emO9go3KUj+9Vi6P99?=
 =?us-ascii?Q?i7AcxsJHUoANx1UL0g+VNJZVRJLOtaEoh8bqWBK+/+PdMj5dod5dzoPipJWs?=
 =?us-ascii?Q?AXrr8RVfhjqfVCkLV/T4ZE0xUe8/KEfaFmJjQlSNcQILQRqzMFwzDiTpzN3L?=
 =?us-ascii?Q?CTlwCcbDZU7brGPFrlaMYN/jlS2+rNGplHcmxEsO54duhknOxBNgv6JxTHi9?=
 =?us-ascii?Q?4+TARz+DVhYa8oMziHMhtAJ/fJk1C7I6Vta0FtzTsjtFPev2S5zke7fVsZLe?=
 =?us-ascii?Q?UBwwJAvZG5WCT+FBGBsDALTmz7O3/HskHaSX/lHkl/Vidhjiau75hAEyCHr3?=
 =?us-ascii?Q?zAf3uTGWWbGejwofg57cZgXobIHl49MmGcnRV78KJ4TjGnRexix9BQQDbM7A?=
 =?us-ascii?Q?HNq0QQRHPN567xUoQqWBxN2/SIskN7kYlS1gVTa6VjmyAu+II0ec6Qk0OWN6?=
 =?us-ascii?Q?Q9WjAK8EPr6Lh6/uEEe/t7lZoRfCTI2pWIJV4juOdkhFycLveEMBzlEe4EtT?=
 =?us-ascii?Q?7+Age1cPhDA2MiCqSTI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2UKlEe4cy4+F7DrIL8i4SjUwyypeOlC0LBIbVIQNIkMeNEOCqNp9dCnxs+Wr?=
 =?us-ascii?Q?sZbGFErVo3D703dcHX0JyvIXP/bWMFQawkL2ufXsbf0gmdh/Hcz+fqbkwDMD?=
 =?us-ascii?Q?cpohdEsLMuK+JJHKZ5Dgl0nL8dDdbtXiHXMsKFxfHvRkE8UgbpZiqKIR+Bzs?=
 =?us-ascii?Q?MVpBb8FwurcVUrMZxrPxwvO6l+IDwVHOSTUvs1PURBmogQ0VXg/Ec0knDG9s?=
 =?us-ascii?Q?DwUq64nXwrIIMXrh4C8ovqoI9M6xh7p9Uty0IBiOhjKisojrhsvsqgrFS3Q/?=
 =?us-ascii?Q?s+AxEoIF1O5r0Knoq5e/Z4S7mRvNHKCK6rNkdLwE6IdfTTrjrr4AybuJc6hs?=
 =?us-ascii?Q?SZOXplxmlPlXWPZ7upyvRJr4/+Y2QHPOG7sxKcinRD6WhQV7zN3g4uDSKmCM?=
 =?us-ascii?Q?jo9QXjLJVyIHDqXc4pNZBdPytctvbrj9Ijo0fCfJYwcH3Hl6zOiPXbYWfstD?=
 =?us-ascii?Q?2vDQ81k8rFZY/9BzJ9OCf0P/ot0qzExtsW7yMJMSd0yAfaqefNSh7TkIYJn2?=
 =?us-ascii?Q?VIOc2lnFcIyeHPr+oW7kZeJB+EfKpYcqfbs8bYQsjdNo3ArIq1bqQgXuNnt7?=
 =?us-ascii?Q?NXqIOfBHvtYY09soqfp4MYwU52uJuzbTcQUuCq0D541IZFfDjz66I6bT+ubc?=
 =?us-ascii?Q?IsYZi2VGv6+A0crYAdaucD+i99qXU8TH3aGpe4BYttd5BEbd6Jifykun0a/h?=
 =?us-ascii?Q?JchSAugv8v5lCNox1osIPHAH/sEsMQsIROsXRQhHd+qFlgHIII4iLTH7MXkd?=
 =?us-ascii?Q?3J4zOdAE2sV9ZeJMGUX0deROTjAiNHKSb8ENR7tSsl7HRPCK/zZoakSy2gVR?=
 =?us-ascii?Q?YtKCmBtablYS/xXY253D25Ct3LeaJHRfOxCUM075JZtJiU1NDLeYqwE16AIX?=
 =?us-ascii?Q?DGuiDhpxSk1t6Y13qZX3ZuFxTs0RiPORYcxOeVvM3OUs0K+XVwfMTO5K52DW?=
 =?us-ascii?Q?d+Xf/xQbBvvfC5xfGua+rm0oZApCWjcObWD9kHET230/PKkcSNnZfbpqj1jM?=
 =?us-ascii?Q?IZiEVAD02QPS6lP/u6h9KzeIKPKAXoVfFON/zOlcJJbnT2kikGByf4v5EYvs?=
 =?us-ascii?Q?mEsTDHcjNZM+YbjBobggduZiVwqOsRqyGS6cooLswSaTubfg/ySiSttibTdG?=
 =?us-ascii?Q?fJsHkpPsZJ96oDv7JLVQUh3E0fk3Z2AKGfKGMveKZ6mHKSV5TYoueO+1+50d?=
 =?us-ascii?Q?IGvbQfQ2H9LF/sUzm3u8NDLkzjalnk+sQZpfM/fw1NtVc59DSmkC9TQxIRbV?=
 =?us-ascii?Q?LtplZhoe/17KgIvRtOUEDvycrzX83FquwfLlpyuj5CzPX4rzqKZj5K0ZhrFx?=
 =?us-ascii?Q?ZCCDIf73QPJ90EuvMNJnjhlnx8vcECaZtfVILri8AChz8mNxNHYEZbz0scM1?=
 =?us-ascii?Q?fM0sMtqIvQKMR09pW+Q4geZLptwdZKnSHtQXUl4L5CY6ITcc6C7JKJNMUeVB?=
 =?us-ascii?Q?41Nr2RldeXU5PfM8+LWFDKjWdAx0AJhlsp/FPIBP/37R6I9/asybkKtbRm+P?=
 =?us-ascii?Q?5VuGSQXaXnKeyn+yEVKULdgguD9n/e+Dct2lWU3Dl7JIpoHRWIgxKdqcewRg?=
 =?us-ascii?Q?ThqZBYFjOPMjpdSGzHExoy4HIQZry30Q1ExkGQnkxiByEBtMzecdyNLCZayW?=
 =?us-ascii?Q?rJgde3XfXzpRYYLy4e8LpIql4X6J7sbAlpsOonbdquZ7MVzHa1WRKJUxr7/9?=
 =?us-ascii?Q?VlHNfNaxCImYHJCLQqDZf/yYvnRoHDaRaVUfkDBCFhOtK3feAklVIrarnGWp?=
 =?us-ascii?Q?rBw1W44OP0K3Xqr99USUVg3RX4Tl0is=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BNDUu7JIimUjkE3HSHyZ9pSM8mV9R7+pT86/EFxe3jmG71H2iLdLNbJgJQ7fnHy426Q8u6FeyFA+33nHtBiUK91pS6s54TCrOwxnbJlrf1DV8JsCIR+FTqjCcB63AT1Ixc/IZybgOx31xPlSq1KH+02Nd2/K34Ma6ioF/BNBLSxm9NG54VTIz9wbSnKTJbaRzfbO96xLG58nrSOMrTbuTGNoKPEpCBwkj9wrik+He9JpYFcyvVZ8bWv35Ji3DhHfiraRnuWj13yzmMTJvYH1Q4qlrq31XqlgJ30FB9sxghRvyVK5mYj9gslXQ3nQNvmOiXpuYzOTxaQwdPxkE4CWaIW6YQPGPq1hc7IU212b+Wri5t1ltALYl5wEnn/Mhzw3YIIrcdNsccGdd+Ef1GbNBwjA9NLnPXmIGmZ1CCIHnGx4o7qqaqj9gFSy0T/GjarqErK+SwnGWDJpKMNyYqq6y4HNKT7dY/BUr75YV/gXDddFHuarYoq1EaczT92KuBpj6XOfBNey7lmTEqSsCpJsdPOIGwIR401H7V4lgYhx6ujCVqGZ1Cm75t9lGS7QLnuWNz/7B7e/n2UFfHjakwvMlHhct2wNiwhCq79yUkiQR1Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a934a84a-2986-41c9-5c94-08de5a9af474
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 16:17:50.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnN/GHeAa7ugnyfSYbslQIZZlblTsXyoV61i3ZIjg2JVc41ElAkPTp8jXPLDsLczWsEAb0n3Gdq9kGV0q3xetqGspiCPFmsTqCkxLQR/Uio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6324
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230123
X-Proofpoint-ORIG-GUID: gg_DFAIMpLvvoYkkmwm9H8c79qrEBJvA
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69739f33 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ouf5RM2OwgisqFhaejwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEyMyBTYWx0ZWRfX3Av0D8C5soFE
 4J9J9lp/Y39Y5+k+/i6/J7czNOArZ/PZWQ9STuYq2AYhB2IbdhUE5iJqvx7D5TIP5C5p7CBDQri
 7StkF5QG/mh1R2EbeuXIEReH6u77VXQUPz0CdoQGiWP5vFf2Xu9kW99rP6lgtLSaGdmtciluQvK
 NBn1/r1+1zL6Xxcl3kP2Iuu+jv5zDfMKsUz5URew0LT9WTi7wz92XoZAZ00xTqLedk7QUN/HdHj
 wl/oWIvjN5TV64LqM1w1tloy4clDvxkku62aB9qfbwyH8gYaiaplcf/+td5K9sB+iToFasaatX5
 aljXQxewIqSu6FM+3LlUCk1Vjk+atyMU0iOh1gUQrO8HvEX4i6Jgy+k7VbT8uoctv5bP6zsIP95
 o0UDFEOuo92ZwFbY6Wdp9oss9Gb8YCVx1SsvUMvw3lBly2OHu8t0KHCnuGfX/+ANPemhdZYHrbt
 Wkj6o1i/0sty26mZRXiYrLXW/BipYajSRTZgpFJY=
X-Proofpoint-GUID: gg_DFAIMpLvvoYkkmwm9H8c79qrEBJvA
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0E7A40007
X-Stat-Signature: 5bckmjkb18rknakt7mpfb393stqkp1pf
X-Rspam-User: 
X-HE-Tag: 1769185093-771327
X-HE-Meta: U2FsdGVkX19nwUznTeDxZinY6S8lyAT2rmL8dsDinqKt/wMgosz8hWm61wayefRBro0LZ/t/8VZqzceHzb3hNuUd0qdmDKAZtiAajpvtQANqrRXiTwqj3vbfkAKTSDJtM1fYXb+5fKlczUc3Ohv3DpaUNtg6hbe0vAETnWA0nct9Q+8TeK6kugezThF50/5iuXqU6ul/qGitow4qN0zUXFwnzGQfdT0bdn8pHt5UZqRxyOxCUHAwnhVOTTOZv0r4eKm1SGNs+VlYhu5kk6IHkbGAVu3Kd/cQ5oCLFKO9gijw5qdXAzUEfrJGwhVv5DXg9qogW5PNSL/itvkDoYF+rnGT8WQQ+Rqx/ree9B5jjn8HoUMR9QF/+7tNaNWijq8kvHGiWklUyL09c+GjFzQWwtkQVx6eNU1peQUE9Xx4wZjQpELxY2fn/JEZZNwwemaVlaOOK1lOZCVnI/QN+RZ2ZKy3fNjXNyCvQSDUMl0Rw2SmBHlgnwNrjUgkB79dEM+EUnE9wu7oeSS+xBO8Y9feRImH1YYWIIUpm1e+PGpN4RPA4GV5VlkYIfTBhCYKp+g2Ek0EVebmzjVwR/UoiKEQ6r16Xu4/FOA6v/tE6fTl0zYjs3FWVtLKK/5n7RGCQw3QDT373Ay6Evl+1oZHAag1C/l7qUHnh84wHgBxp2NdNPws5y6XFcFNtlcu1p3CP0r6B5CeOzQGHEQ1vwpDuz+3CM5VgHD45lkReqfrmBusVmaTurxJhw/lBwejarYfTcvjJwYz+rOzFh+SxMn1N9Lt9tosWnMtH0FjK++rc7uUs9ozH4YaGRpZP+jcu37mY6EznWJGpmageCq4EtzyVNqdup+f0hmvq9Fk6obJi5QEQwyXJlJf3AUdiOlH3b1RtFa/AATXI5XRsh3mWm86vXSlhOZgMB0m4MigNxppXct8ekwS1i4ZnzdUotETl7kj93ppWIG5fwq1qcxh7jZfeK5
 E5aLW7+X
 L6UN+crEIGz6yLFp3b6hF2uq3gKqz1dr/z8E26eiSQxX6F4OfEstGHh/n9SGG9UHBeJWwGTdhiAzYAzlwLCHtNMGhFKjuLZmlVCZUULaaRIMmD4f8bEXFHJg/t5JIXZa18E3tuFgsgR9n2vpMPvHvZBz/hTEmMqtE4qq9GdgL2AfFcAsW4B9pfW1IH9w5fB+Lm3A7kbaIb7kNUsQnhgKVGqL68wDBODUNHJ5LVm5ReL5qrNFV2DhYqCcXbSYvg/slnsdw/6LjJDAk2NuhW/zPqYWQS4SHtMaESa6kE/rOyL6V2DTQXI5Y2xpYeC3eUVY/fR1QoVW69MCX4vwKI2RqFaCdz8DZxRpwUwqJORMUzq15IRDzpD5sBHLgbP7v452vMGccGcrAyBHg8vZRkkF2C4iEVMU9RJEBAhk1kFGh9P8JO6XronWYbt0b7LpQz7g9QeWJmSDBNAa0vJwpBmhDkfca7c6kjtDPzIYEfeK1Zg/aJ6+QiKXO14KLi/h0ObW4IVlSQDk9dggE3pWIDJ2iBNSbgRYPILDaSo90B1ilJk4RFgBlAqRnjZswd1GJRKTlSC4mn0mIp/4takS7Aqx4avqhkWsBhu1QVnqA5TXvYGnnsSlXwJyQ37M1imaSXMsYWYW2RKCySwyLpcDDQeLFFVqTjrbRb5qloAy0kfyRD+B+F3vBnax2Wco3tkv/qUC1VPcd9A1m9KzNRTSS1oOzd1Gs/irLHWKUWBD1ZtHSxp+qUM8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 10:16:22AM +0100, Vlastimil Babka wrote:
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > These functions are very confusing indeed. 'Entering' a lock could be
> > interpreted as acquiring it, but this is not what these functions are
> > interacting with.
> >
> > Equally they don't indicate at all what kind of lock we are 'entering' or
> > 'exiting'. Finally they are misleading as we invoke these functions when we
> > already hold a write lock to detach a VMA.
> >
> > These functions are explicitly simply 'entering' and 'exiting' a state in
> > which we hold the EXCLUSIVE lock in order that we can either mark the VMA
> > as being write-locked, or mark the VMA detached.
>
> If we hold a write lock (i.e. in vma_mark_detached()), that normally means
> it's also exclusive?
> And if we talk about the state between __vma_enter_exclusive_locked and
> __vma_exit_exclusive_locked() as "holding an EXCLUSIVE lock", it's not
> exactly the same lock as what we call "VMA write lock" right, so what lock
> is it?

Well it's not exclusive because spurious reader refcount increments are
possible (unless already detached of course...)

We are _excluding_ readers, including spurious ones realyl.

>
> Maybe it would help if we stopped calling this internal thing a "lock"?
> Except we use it for lockdep's lock_acquire_exclusive(). Sigh, sorry I don't
> have any great suggestion.
>
> Maybe call those functions __vma_exclude_readers_start() and
> __vma_exclude_readers_end() instead, or something?

Yeah that's probably better actually, will rename accordingly.

Cheers, Lorenzo

