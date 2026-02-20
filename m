Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E29DC56204
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 15:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4545A6B0005; Fri, 20 Feb 2026 10:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4020A6B0089; Fri, 20 Feb 2026 10:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B96E6B008A; Fri, 20 Feb 2026 10:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 11B916B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:18:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2E1F1B4A11
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:18:18 +0000 (UTC)
X-FDA: 84465191076.23.5CA3F59
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 17A2640010
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:18:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CEn+Qf67;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ybABxooJ;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771600695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3eyXs1ZRsAgK9yPYN93KRZnvbtLIX5yv3IvNxp8wt4=;
	b=DhJh7+dF0P/zZsb4MvfNVKfNEVK8XIAWFYGfX+02t1zB8J4zvA1WtRLA+m1jTpHpqliTuY
	QwEKSk+apJpgEqVGVYEkQhW9kidxFs96RrzlEJAUhodAVjJ/JF8dX0KLRlJ96b2Fn+Q4U1
	noMt+f0JVapyG979h8M2AeIoHHxE3SA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CEn+Qf67;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ybABxooJ;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771600695; a=rsa-sha256;
	cv=pass;
	b=V4HrENk9ihkxwB3wlzwOVmfRUV+74wBteu+AjVmpFIwzPUSfnJeKU2nnVUSG8+2IUtJ0O9
	+phaPZUaNaQRz/SsA1P3MFEgH0fmnUydM8kzoIJv2ZmbYNFySkIUvr+ng604YFGNHiuPsh
	NlnVY6cn1DbZ+/dsVHokF4IoHIXcQ6I=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61KEvKTb1260234;
	Fri, 20 Feb 2026 15:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=N3eyXs1ZRsAgK9yPYN
	93KRZnvbtLIX5yv3IvNxp8wt4=; b=CEn+Qf67wpXT++vN73I8vz1wq629LuSe0P
	EuRkG8NVbtI5Vhkwq3c/eLU8g5Hrj6z1B8B6/8HzZWOeCrR+d0UGjFpk38SOxxOb
	O7/w+3y+32AuqTbAGRSfg5H9GXUzSHWMTCNFtkn1JHtBCegpMJKp7EfqLp5oTx4u
	N1fnP6euDRayk4b65BXgu1xGXFJTtUa2ftbsVNTDZm5j9ai18QaOr04IlJEsCECy
	aUz/TnV3iXL7nOnpe52pYFKoz+OCGevCAVu62snerc5k3ZzWPVVoOKSrN0E3MekG
	uG5jJ8jIPbKX0xxODLnVn+SZ0Pi5GgNXwzQ0D8NIlJ7IAtN4KrvQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj5r9ghv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 15:17:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61KDOCms022840;
	Fri, 20 Feb 2026 15:17:52 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013058.outbound.protection.outlook.com [40.107.201.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2gdbhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 15:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FNaFlyp4yjaFqFbLdlkBvcataPPTvczUKDwklRRUXPYBZ9SNv1agNYaQtG7tNVqgeElKXjTZX14i2Ma0YkFfEDSJ7ZLpUTs1BhX3JGaze593hHtvhs0lFuFu/mwPauLXs9l1higowxZlUHlP/JOQnwlmdiXalai0baLfj1/DvWeLHpW2L8A5BwqF8t07gLAvQKDVIYhTgYPS5FftybxrcccD8NYlCzLJTEEHZ6RlSVTl++1EnQ0klR/vmqWoJfeHXm6SQb6ujbvPe9EYn1I5TSe+dKbFryDEJHNZmvIBAtWGE6G5P1/oGhrbU27WFqZ3m7y2XN6lgy+pepaVFxhRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N3eyXs1ZRsAgK9yPYN93KRZnvbtLIX5yv3IvNxp8wt4=;
 b=pK8JuYRA0EiNjSxhdeHENJkzRIiQf/hIBeVhK3r7YZctqFaWuhb3KD5RxGDfR2q/bXA/qAD7NKCs9swxX3VrXhPqJLueWEcYshHNYODPG5T7LSzE72UVaD4LRQCQIFD8jhrh43mfus7wK8NxpDYw7R+r954u2j7XbEUQ046Fdxq+6p7fLfI452MKcqi4rmyqHe542p3ZIBDHgXFlEIK3Ixf1OILC1XNip59gSwhzIBYelwJMj3HpqNwYzYgwoOMe/HptdIzPEu9hBYdH3sFr3g2lBk7FbR6k7jlX9phv/AHXJ+sHlW9ANgOcziZ4IKbXus7+q46KxgzKIsarmyFHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3eyXs1ZRsAgK9yPYN93KRZnvbtLIX5yv3IvNxp8wt4=;
 b=ybABxooJZBzNDTPWt/sju88oWn6jWYtQpFgEeMpn0kIGSjTCL1PJY1p1uj2VKjueoHknZ2pLQZG5YVoW2hEDqQlaPBUnes8f4SsjFfG3X2nALofBGd6ZKVPNTVvDIYApOeQ/vD9DK1UfydFXetiI+LCHA5wfCOm/nQZTM+BjxRc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Fri, 20 Feb
 2026 15:17:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 15:17:48 +0000
Date: Fri, 20 Feb 2026 10:17:45 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, lsf-pc@lists.linux-foundation.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <bsvfkhvxwjyyvvd6stn7ucevk4mhbmlsdjof2f2vg6gcnhhwqp@iitazb6w2uky>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
 <aZeFeAP9Zh-9q7pH@thinkstation>
 <vq6hv7gyieakkka33po6nveq52vayruxsdbymcjxja6vtxlldp@th5gwdlfhrwa>
 <aZhRKOK9I_MLEeHT@thinkstation>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZhRKOK9I_MLEeHT@thinkstation>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0241.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BY5PR10MB4324:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cf773fa-c1b1-44b2-d85a-08de70933514
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5M5wqgCdFw2NUkchPys1As+Ip5UqM4Zsnz1e2DpEYV9XctnQTExWPlVF6jmQ?=
 =?us-ascii?Q?in4MwgjHo0Rlz4B93c1CV/zvP5qOWLOJoiHiIE9DLUnBRPquv8HFKaoLtTX3?=
 =?us-ascii?Q?5EXmt28gy1iDqAHb31UrhARsFp76f87b3sgc+n2CUHO7yUNagNw05fCO6SzC?=
 =?us-ascii?Q?xZnbYTKzWuyggXwy7U3vbBmFyKfDvfgRBDXM/aDmwN1doub7loj4y4xpEa7m?=
 =?us-ascii?Q?OtQKwtr5kdww2YuhR/CoM2QFM5XYVsugINM7BL8sHsRWUjU5y1GkNEcV49n9?=
 =?us-ascii?Q?jWw/1gBERsGBAQL0mjedIoX0mhwPtJAvBhRtUJcFPFFgfKmP/Dm1efPbP5TW?=
 =?us-ascii?Q?rcTpXCcgp4+YU/XOqbj73wJhAgizkML41iy1WZ8GaWVRn6BhhcG/nUPlRpyH?=
 =?us-ascii?Q?gO8Vd/mrvTRklXHpo5gPgXbAJDzrBkb1hZjob/i1+MR/xGTFMEnVbfZRtqkS?=
 =?us-ascii?Q?ma0JbapvEphWKFf14QYbP6s5LHnomgB/0tuwi+OVX8y++qg1vWcW/wYjK5aK?=
 =?us-ascii?Q?OlYgHTvVGReGsDgHp9gGrQPvUrevkch08IkBKy84AIXprCaWHoTzhzu9tJTm?=
 =?us-ascii?Q?j9eMZyAizZKSH6jufSFb+Y/kSc16qyvQCZgpTa/hpi2Fjr9zVIGG/cx3gkbV?=
 =?us-ascii?Q?kxMbCarn+GIQxEAe9yQWpsKK5/3unRy+RyRwu9EVcuMzcbV/xEn3BF9Jm7uF?=
 =?us-ascii?Q?rF20rOTLQM/8B6gpeFpC8uHHrMugXqGz0EjHOvXYoCHrIHwpRCFq45r27itw?=
 =?us-ascii?Q?DtW3sHv8uNVuR0C+nK3j8SX9VeDAtUgxbSixvb5eXfSTX5amvjrwhQjFCcaO?=
 =?us-ascii?Q?RpL1Ux5Yg32zRnjjtMhqb1erk2ACXi/mxNfblKJ+CRbg7dByMf2HopgqG798?=
 =?us-ascii?Q?R2/6Wu8s4PIPpo5a0dPgk7JrxTvFOZ07BdMMW3iKSITTj3643oSE7kcuKO4p?=
 =?us-ascii?Q?byunYxqrdtmepFR0TkgBr+DdfKMXGzZ98YjFfYJgmE9lV+Fd8PQdrYKktZIh?=
 =?us-ascii?Q?s1yB7c1+5T/GeGjMpuDgjHGKfh4cplgMV4+MVMjVEOGFAa10xrD/CJaDx8/u?=
 =?us-ascii?Q?19rfpL9vFFQlMnYse1V3+5rFmHy9AdCLU9IsXetgRSCvj6qBNm5LDxZdK2dO?=
 =?us-ascii?Q?uTphSPE0PmRjUwl5M6ve3axYDk78QeEarxGSrargpsZZ3wr1ruytTSj3KUoO?=
 =?us-ascii?Q?ogOJ9tVZ4WhwxPi/o020QtoDlJCdVntseTm8JK8DMCYC4DJ2oOoJ7npnsJYI?=
 =?us-ascii?Q?URH3ZOVAJTqdGOP6BB+/pZO0Rr3g0C3oo/nCob2H6o5/3s0Q26RgEzZSqBZ/?=
 =?us-ascii?Q?KSmIi5Hi2gPeYH8u1xbSpUtkZ+6kaEq6R/Bo4GCLJ3LJTzmVdYj5SqmMOcBh?=
 =?us-ascii?Q?c2JH6GAkiAY1cMtewxlT4UV1XAEfa7HOpE8byv6pEMzB60o5yrF0i7iubq95?=
 =?us-ascii?Q?gLy6vKw+Fqa9OPmW7qo2DcHbJYGPov42GxoSLUjqc/67Xn0moJS9RIlT0TO9?=
 =?us-ascii?Q?NheypsGlizJxqkfM55ukhqkWL6cXcPTehiSEHo1hobBWBNXNLdbxUDHjSzxX?=
 =?us-ascii?Q?QyV7YUc21Hb909V01Ko=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DuoF8upQDXDqO4lZ9xNbfLGD+LiWDeUTiSMdqXTK4oHjrPF1xZEi2f4R+BIO?=
 =?us-ascii?Q?/3vC6JJa84WI68WIO5LeMOOLchxbn09OmUMLd4OroYI/6+S82rh8DNCzR4xK?=
 =?us-ascii?Q?ZBwfrE0zIZ7YMnuXL5+9IG+fpCCqpeuU5FZCUtx88XYFn3lt7sxNRVqI0ftT?=
 =?us-ascii?Q?5gB3rcThcERuc282nZAJ/QAY+ikcCKQ1lJCgsORujZaP7pvgahdUwnr/xl4r?=
 =?us-ascii?Q?zPTaDoq/gu6pQz4Kv1nJOoIfeB9vbV7rYuc1f+XXxuaR3diHE2dagjcaMq4s?=
 =?us-ascii?Q?T6WilBOLkrKXVhlPT5LkiovjZMLkBd0HRsjV+a8ouluW7q9ULdZe6mzzCLal?=
 =?us-ascii?Q?SL/RkPxWzUJx70BXP2+su9XlnlouK48HQN6RmBTNkiyYD9Jpdo2FrNY8aJI6?=
 =?us-ascii?Q?PfUUm+FsCg1iXuLbsvH2TBQOcuLqrIzaVJPhSQYIj6XqvvzJJiDn5JrmvUR8?=
 =?us-ascii?Q?uiPt0vr9EYq/ZKiRrhmF2wjI+itsXP/cWtb/QiJafXDGG7mtWyncUhJ2hgMi?=
 =?us-ascii?Q?i4LseUmGwiqW0TcOkL9YheS0NhmiA/Ue0EPm72gRcdC0Z9atqMHzwzN/rwLO?=
 =?us-ascii?Q?R+1q4rftNv8Ts9/4c8x9y6VOMhtXvDRWWmN4wkUrfNKuzPlLF+JCBkmMtZ2h?=
 =?us-ascii?Q?i/cavEcrLx3ZTQWYVoGKOwQTsorRELfHR0KFeVdf7COZNZMbsiQEmiwemB3J?=
 =?us-ascii?Q?2sRSBMaOLDP2YYXQQoOHGJ7EMj4k2dltdQjjlJcnZXwUmwZF9Yl2twLe8qyP?=
 =?us-ascii?Q?lA5mJPu7u4IM1E9HYNrrzBMBHgOZwhjek87aohspaP37/gt3P3P5P4KMadgv?=
 =?us-ascii?Q?PZVKEer4PR3xrOoUVWgy7l63bqEEV5EynzlQcAPpnY9Kip2hB9LC5qQvm4PM?=
 =?us-ascii?Q?MY13zHNp931FQA7plxcGVsgCDbZIe7AOkpAqBHwmYoi34zXlLig+QdfTkDgt?=
 =?us-ascii?Q?xGdNQwKLfZzHQY/g3Hnrp22Z3nGymhQ8x3gxv7LBAxuXJ5GlFjn4x5hqzLgN?=
 =?us-ascii?Q?FHh1wMvmP9WZb/op8RP5gHQ1vcLTD1PPeilzNixiE1WhMSGBKd7Q+0slO27y?=
 =?us-ascii?Q?4y8SKMpEcuhic+HalA8RnoafPv/pY1RfDH6JqjFc5Jll+TeHvfKuQTcBrCRa?=
 =?us-ascii?Q?eP7IQZ0tZYU3jNN9lOpfFcxihQMXvjLBff/eSCKEQlXG4gIVebGJbdHxtpiO?=
 =?us-ascii?Q?grk0ywbtrNFK6oA3GhYOqzlu3BoHtFUSVrrL8SjR6Cn4VxIHwU0bqY7LWxkm?=
 =?us-ascii?Q?kB2YWbSSxrjmuQbR4bGywZesfzmcEW9UIhfktF98UPPrJEMn5Fa4Jr0Aubrs?=
 =?us-ascii?Q?rlGK97PSYh6qXYsAFitNBaJZraxdIxLq+GT/tiFkISVNhCn/4YJzHIN5cCTr?=
 =?us-ascii?Q?AQTMYrZ7hIAK5L+alSZJ/XVxQtMOCEh51LwRVIXsqcLquS7fiBQoeeFSgRCo?=
 =?us-ascii?Q?ayU4wbXw5JPykP0jMAK0nfuRihqiJWWsU/VDrA+959lB5HL2f+KR4Bb33Bta?=
 =?us-ascii?Q?GB0nCvy0LVaqxTxTkxVKw7+lAUAw00ARsZtWzpj7wdWT8C22MRCOdHDzDJ/q?=
 =?us-ascii?Q?WG9Mqb9ojOAEQhi1Ds5HJz/neCvqq9p4cfAkMRJDVE+CMKGBn82VDA6GljQN?=
 =?us-ascii?Q?ewBywdj+z71LpPLNj9iKsF8DxDc8WgkUPwCj2DWB4FLiFIsM+FDm7+DLW0JT?=
 =?us-ascii?Q?1eBAvMOmHNAcNZTq6/nod6bL9R0bw45ul676jIiZ2tIB/GcIjnwl6AG/pONW?=
 =?us-ascii?Q?nlI1wmX3YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/YLyRzrGyEFiEhD+7FgZ4b+xN/mJsMlKQchq6mDptpwGAwBz644RIPqbADH0tYFSg8ZMqhs72DOFFDmn3JoK9nUFA9jbDCy5Xauv+9PlQy8qwOJeby+v39YgdYICvIhDOoe+/Y3HqQ+73pbl1qlPYKR/edTZRBYYMTQoE12DRmZy1p1VEnCkdwYsKIkmJdB2z3jBMDZfPxK+yZzDomflNW1DCoRujEx+N1wY8NDrKMIy5ID0BzOm10U5lfaRmYHZZahLwoIqOkVnN44khOrO7KfkiCoCleogSHJ5p7laNlVOLIgOWz7LyN1Fdmd3sns5ggZRLLA3MvbaTOZ6r6uH1a2hlLc64UayA0AafMGuvgMkUF1/0NwdYbbhcPQXbgzabeiXfql6RVAgfW9QaLxFO3h/QQIdeKoyg9AmuzHfI3lH9+auBJ67ItQ9AOSbkze1bKDjNKncrIQOln4CCTVofOX4FkK1PpD48Z/sX/9rATXAHlstuIEIezDsifBcQLX2xNVRYQQAFAuhPq6mFLu+5tNjV2UsJuchaPo6Yz3Bq0FMEsJ0v2oq30REB3nM1Heq11y/RWSMoatbtaH7I6reWnSX0lRoLcLph2g92jsIxwY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf773fa-c1b1-44b2-d85a-08de70933514
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 15:17:48.7572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDHy9QesuA2IyX61HcaQcfsw54lS2nnWq7mZnSAR1J5HZMZLSmCZY0EIIJn0WCueZQCpymXCyP9XXCITMWBNZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602200133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDEzMyBTYWx0ZWRfX7mMka0lVXyml
 Wc0v0MzakenhT6Q3S0b/VOZ4qv0aQQJIcifRMR33+WttI1A0ybzoUBj/Rm8mtxHsxZNuHPCBciZ
 ylBH0dFIv9Q75y/GHU6bJ/ivwVS2P04xeGGtpNgjWSpeiWEcCVWbJMb7dkKDQbf55TFBc+f6udk
 vLdyz+checT2mhrord+CFPTsCaT5vjdoTCoFwrFHd39dT5e7C2usA3po8BpwhE+oUOK1dOQZtlk
 cEPaNxFWazwHedVA2e0+X6jOvk58Wh7rokbfbmlH7pEPO3HBkH+bl7ulrV2rFilFWhFu/XETdMs
 p/UcgSpE3qfF4c9TiVmWX8UlW/+/IYjlr/XTH3wp5pCwyu6vV4hIgPVedCQL7AMLYghfLdiMzyC
 nAI7CZ2HBnH+NHlzSa97mjkrcCCAq/zsbo5lt5T3254Yk8OCLJeTo/gL/3MjUqBXnAG/9gGObtw
 S11NH96+r0LrqMF87V/w2YoKGG7XM4b6yz7jejn0=
X-Authority-Analysis: v=2.4 cv=Saz6t/Ru c=1 sm=1 tr=0 ts=69987b21 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=Cg7Qj7Fx9exRDFjbP_4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12262
X-Proofpoint-GUID: MvgT07pY7gvmZSDuX171jsHMVSGFNj_R
X-Proofpoint-ORIG-GUID: MvgT07pY7gvmZSDuX171jsHMVSGFNj_R
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 17A2640010
X-Stat-Signature: nzdqkyk89y17ii1xbwxq5wgkywqzqh7e
X-HE-Tag: 1771600694-461419
X-HE-Meta: U2FsdGVkX19tWSrXlBmrzrk6m0/T4L5iMNCKSYb1poCnIFeswSM3jAoFmP/IL33tMnVNOsf1LhhAAcQQqCVEpJsaBbHK2I0ZTDHqws7w+k2VhqCqXhbySixKRIS/j/jZZZ47yjQ1C6Uozfxp2MHPqEaDHrKPwGinjbGDZLnXGQZeIBAMWg+PNadxocomafQLaJ++czyrbqeGIivPPEjDqrcRWLslOf57RV5s1ij+SNUcmJe0oAfFfVIiaZC8gBmUrPPFFq8osbhFrQL6mOpzTA2Ox4cEnM8Z80U7zLyxAa3DaLfEZ1pdmoVM8IkIVnaUAPUn5ZKJbhHNf5cXWDjW2c/JOWUwTlyRnE2/6DNkvetJKue+qh4POaPQtVeJzXmLI/7mLEbo+ZFydWA6jcT3dXQuAyzzRFbaK9f78OlD/BK5KryZxkp1Be59ORhDN/o09v6ZFSuqsBnw8VZ4NMlZEXvoKzZaEppEIZtfwT02ypUUGGdC0jC2Q7ZtAoIi2FeoSQs0oUrnruipRKcU7QkRgcd4ROLn65T4MAbyxNesrsazCf8/hiv6yBXQs2z4RUntXw1GxowXA/HNU2g0MrieX41Y5qrf2q1qq+Zr0gmwVQnr9/vkS0Zz1rxEKjV5omPuc1yeqFKi3VZFliZEwJoFTo5k4hvEKLllvZ/Vp5r2aFItA3w4eFmHD2EjzgGa/RW6vYgJMmyTldNKi4ywDZfzujjF/iyxG86N9C6RzmM+V9r7k1Em0x62/zBiIMAIYyytWskcoMyBzjzDX3/G9+HKi/OZyndneEgMmrO5aNLlbRFEmEliaaQSwO2DLRMApPBRNk89iSq8WvF2RXxED+cJM5HlXgTSzArE7TMUQSjiGJlraC4MISdLEQAAnKzMFQWnV4gTULe4lsk1Y6Fr0D6nmbzyJjPltJGY8MzXKDfuH7KlFha7NPMrZ1WDTh6KCXv/TO3Hp3jaSFLNBpOLq1h
 WbvlJEfb
 GzCI2aUzpUp2jIkYqp9XLnvMktX623/bnLX0GHwwvEhTex2zMeE2bsuE7IG1ZNblQSuZK+zNvcrYgoKCTlgfEVVX9kCdKMuAejsImunqHspZcz1MDEyqHbs7MNIMPVkCzdnk/JYg3AkPYyu1zhfdV0VIc0JVpi3NM3Z3mXXLzBX4L4KQ2BNCrALJ1un+5oPOmNgEkxMJkfcbRGWlOAvIHp1omxA5lQ1XXrZhNSvPAMSPtOPm8a2ujL7Ee94dfAVBQjNRZ6iakPgvje8GQ8/OYmF7YK4s08SkbMO7DLhEupa8JxoO6lftyme1WBR7cSvbbzPkvb2pV7xKuBkz0mSMp8cEj+ActAv69zfg1zAmdZbsHPBhlM3vkhJuW/HFO0tcpr4dVf3ioO0b7U4kDLi6F8Wn3X64IAtwq1Mb6TpuxuNOq4e+dW3SWBqwqe9p6PAIkEDx5l4QmAA1DSML0u+McJyoN5hS91IFHoYQVtKWLpuY/LuGz7pYwERJ/ixgZpg/5IyLMMlsBHu7vnceG9sUIxClJGOpvVfPHbuT5+VelVHpgNrzO1KNqW7BT0eZ+Eic+pedJo6kee8WfQl4bURealeM6V4xBz+FTxEskxVmXMjGyOYYW6ABKN2n9WiCUIEX7ddTcvIYnerOW74TjnaaUkW1OyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Kiryl Shutsemau <kas@kernel.org> [260220 07:33]:
> On Thu, Feb 19, 2026 at 10:28:20PM -0500, Liam R. Howlett wrote:
> > * Kiryl Shutsemau <kas@kernel.org> [260219 17:05]:
> > > On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> > > > On 2/19/26 07:08, Kiryl Shutsemau wrote:
> > > > >   - The order-0 page size cuts struct page overhead by a factor of 16. From
> > > > >     ~1.6% of RAM to ~0.1%;
> > > > ...
> > > > But, it will mostly be getting better performance at the _cost_ of
> > > > consuming more RAM, not saving RAM.
> > > 
> > > That's fair.
> > > 
> > > The problem with struct page memory consumption is that it is static and
> > > cannot be reclaimed. You pay the struct page tax no matter what.
> > > 
> > > Page cache rounding overhead can be large, but a motivated userspace can
> > > keep it under control by avoiding splitting a dataset into many small
> > > files. And this memory is reclaimable.
> > > 
> > 
> > But we are in reclaim a lot more these days.  As I'm sure you are aware,
> > we are trying to maximize the resources (both cpu and ram) of any
> > machine powered on.  Entering reclaim will consume the cpu time and will
> > affect other tasks.
> > 
> > Especially with multiple workload machines, the tendency is to have a
> > primary focus with the lower desired work being killed, if necessary.
> > Reducing the overhead just means more secondary tasks, or a bigger
> > footprint of the ones already executing.
> > 
> > Increasing the memory pressure will degrade the primary workload more
> > frequently, even if we recover enough to avoid OOMing the secondary.
> > 
> > While in the struct page tax world, the secondary task would be killed
> > after a shorter (and less frequently executed) reclaim comes up short.
> > So, I would think that we would be degrading the primary workload in an
> > attempt to keep the secondary alive?  Maybe I'm over-simplifying here?
> 
> I am not sure I fully follow your point.
> 
> Sizing tasks and scheduling tasks between machines is hard in general.
> I don't think the balance between struct page tax and page cache
> rounding overhead is going to be the primary factor.

I think there are more trade offs than what you listed.  It's still
probably worth doing, but I wanted to know if you though that this would
cause us to spend more time in reclaim, which seems to be implied above.
So, another trade-off might be all the reclaim penalty being paid more
frequently?

...

Thanks,
Liam

