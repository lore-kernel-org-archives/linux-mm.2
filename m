Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A83F3CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35FD8E0005; Fri,  7 Nov 2025 11:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CA28E0002; Fri,  7 Nov 2025 11:55:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4088E0005; Fri,  7 Nov 2025 11:55:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA12B8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:55:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C8435960E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:55:31 +0000 (UTC)
X-FDA: 84084412062.21.21AFC27
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A3444000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:55:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WGvkdxx4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=li8Saule;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762534527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnB+O1uiigo9Axqq7Ac3uiXU3tdnEhbljuW3mMEePCY=;
	b=Qxw6oYY/qenHNLCVkh8WHuqyBYWKFPql+PW5Sh6VGw8IflWoAvbWZvs2287NOFBul98xB2
	cTVvlyx3seZoRvXvPH4y/OyPN6dgIbia/Wg0ix1KgSgiErVUqvOhlcc3j1rKfmxrs3V3Gw
	eDWlwjDW3BE6OZl7OgJJA9RP9u1vPW8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WGvkdxx4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=li8Saule;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762534527; a=rsa-sha256;
	cv=pass;
	b=FphzbKDR+RFx3GvZfbVibXZF15AOmdNCUfNIM+ogfW/I9RtnsGyppyowKMVO4UsId7aFS/
	WAz5QfhkTcjhyXmGnts/PSajXwVZ3kHXaLYxj3WbeUffEUEvQbdRjR5HxXG48t6cPKWjXI
	xEYGZYSiJ4mYEIGZ5JGOEzOkE3uzbLs=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7GrQw4006760;
	Fri, 7 Nov 2025 16:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MnB+O1uiigo9Axqq7A
	c3uiXU3tdnEhbljuW3mMEePCY=; b=WGvkdxx4SvbFtXU6EBri0B7iUSnxPjUDV0
	5qXSEQU35WaqAv/TXbQ0BaJepBs1rJ2Oq25BY5dXkHyKovdhS/V2KzAyVCOXLCAr
	6zX/jpbiAZteD/DRAdf8W//846dQnj9mGVVT7BCb47AbrOea7PnMzYxrRBj/WUNF
	hAJ0UkF4ohkzj/Z8Kg6Nk22Noj3DcXMK50nHOLGsL4ca1+ho/d9bOsLCqUBKzCB2
	+LkdN79NPk5yL+mND46CpracHhCnE5VWUTfJZDMdUAftPM9x5w5PVEt/n+uie4jJ
	RojiGt3dm0ZJ3IRKMROVsO2tnIQ+xU88pjjVTl8rQpj+dKopE1GA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9kp384xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:55:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7FQFfE036004;
	Fri, 7 Nov 2025 16:55:19 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012014.outbound.protection.outlook.com [52.101.43.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nqufjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+G5mlqiW5IZ15PAnM1vq9YdT0b5E0SnKM+z6EuBnBhKnD+vasplkiFB3QzrdCmAtUBvhdJgY+ZY9qjbUmNWUozT2kIFqqMj4vZvXp3r4hYITBugGuqQ26n67fOgZhQGtd/i74gDunbDlZRJJd1+uTatoa7M8PvHRqtoZyDUDBI9Hj3qrYOWLlrSi+Q+TBIvg/Ude8Y9rF9TcgaQmN/M4Tg1OkxnwCpJBdJmONJrRo/bgrXEb1KrJs2jmY69x8J+nHdPZr9J5W43F7uDpFPkWIQXExdSlEMCqbRCJ+bPNK4jvk1n0j1Y9AV6rRTnHTYhei9B88Wv904zSb/01ts8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnB+O1uiigo9Axqq7Ac3uiXU3tdnEhbljuW3mMEePCY=;
 b=QZOB3N1RESjPov8mWUISGDxjMTwfR68LI2whxU8Ju30IhXADI7f0nbQo4VwAJ3/+Xj/XcpFdINUzowGbamQKRl5eE/ib9u71LJiNBmKPYFqyxJlqUNCgcOTC8XAH+33fjVi3zqpubQMM3k/cdMyvWvzUXek6d6tH2gZO3Xu6WwmKOTpIQ8JCfCOQakUN/eQ3y4JpI0a02AADGOS9e9oQWaPg4MviCIR1SLKrNUMOQmFlZHFidJAtz4xTSkvQMYPz1CaWjRLGurUvubGLqu0bqoLpdwG0prvORxj2CjM2NBVR6Ih2eDJ0QIT/1Bd58gNppyHqBRIG+GJIaYUOCA2Dcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnB+O1uiigo9Axqq7Ac3uiXU3tdnEhbljuW3mMEePCY=;
 b=li8SauleuxFNLmdiIgx+DKBINRHQzYsqJVi5mY0NMsbWX8+vQkZcGNEaxh0PXlS57upq4nVg43fojSDBnciM9GhbAlLZ39dNx0yTOw+NI7k+OLOeGaKDRMDuH3OzxxPxvWX7RL+y+HSLVA6zjXw3hSPuWKndd3bUqQkEwFryLGg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB7056.namprd10.prod.outlook.com (2603:10b6:510:275::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 16:55:14 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 16:55:14 +0000
Date: Fri, 7 Nov 2025 11:55:01 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <bqbpshgjulakvpgykagfuez6ljnzwyzzv6sgepc4akewfh5q6y@bh6ritosdmmq>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <78de3d64-ecbf-4a3d-9610-791c6241497b@redhat.com>
 <boylgf5thjyblsvjlumxrwg5qfl43e4revh5i7yyh2yiddhgah@gtht57bgkuzn>
 <29da6069-1d41-4b15-be95-5c1889a37aa0@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29da6069-1d41-4b15-be95-5c1889a37aa0@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YQBPR0101CA0296.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB7056:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b3c3ed-ae8f-4095-54cc-08de1e1e6be6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cvfimLi37sG0QeB21TZ9E1S/FWgcdpoYsTZPaqpdj19aiOt+pmc7XOyjunOR?=
 =?us-ascii?Q?z8cy3ES1KMcscWypZIOdSX463Tu0v/MM8oJGVlJbn6DUrkiQQWID5kpgkoyn?=
 =?us-ascii?Q?DVkTF+1MBpyYqBUF3+S450fjHoZoLGuoG4iH0SdbrcIAIHi4ca3MLmjZHnzy?=
 =?us-ascii?Q?WMl+diItlh6kkKbO5F8oU4NAqW0Feb6n5R/7wjhl6h2j8/d1b4mSLVn7P7cp?=
 =?us-ascii?Q?k3Cmw9UHp3Oz3w6KatfyMPGA1bx9qGRg5cNLiC2aZun7MhUdt14EH5W9NgeN?=
 =?us-ascii?Q?g7pnFlFGtscC047H/OaFbuap6D8lOIGfX8TA18x9VWsfxfAC+iNAkd2w9A1i?=
 =?us-ascii?Q?pZJCcghmcfr7GJXDSoX6jsJYm2kvVzdcwptfUqYXV8EbwGz5y2tHEpASqs1o?=
 =?us-ascii?Q?384ZoBJEeFePIw+mfX/2Pjzgp+SJLaXua7GIlV2OQeH5d/6dqxLKV7Kt3U5n?=
 =?us-ascii?Q?R0niMOkGeshCV3K5Xak2PeYz36R99yUtX/D+BBs4T6TQipGDRQLgmO+aKzDl?=
 =?us-ascii?Q?K/2JflpWVShsO6CaPpkZgQ6Yq6Pm3rVtKr4VamvAuQpVt2ufW/KwivvLEZf7?=
 =?us-ascii?Q?g2dVGQvF/Z6tspEZ6yEHCZ/e2ZlBxFyTGZEsC4pnpTeB+8kfvbJZxrEiTDA6?=
 =?us-ascii?Q?N4yvlk1FFSaxBo16Y4BD4ssRl11sN/s8jBMCX6Gun+YiHAOfyfKjhdjOQwU8?=
 =?us-ascii?Q?yTou5gwmGnrZOLfWmVOtxFId43PSPVGps90UrGVpUSwJNa9nFNA45kK9ZBHi?=
 =?us-ascii?Q?rxaoALfGCRRB5EUGrNcGyAzDA5NDuKjlKNwbTYKTFg43i2hvGAOgmJwIdNLU?=
 =?us-ascii?Q?AjYQ75UUR8ALJTvXDq/MgVLHm2Gkit56qV1Y9j4PgJItHhjIdjTQx+GOOqLD?=
 =?us-ascii?Q?k5EPiz+/pbdbbtVzSatREjiS9hf4GD7SStjC3yAxaBjyYcDrCKtNTBN44BcQ?=
 =?us-ascii?Q?wFGBb0PnCJx3Dk1EespRk6BO2EDZZhmH5PAE443fS5Dx/tqRkGaW8VFFcC/i?=
 =?us-ascii?Q?HLSi6QvzTyRRRvUuA/jqargbfjFsRY51rFyYz0rUTT5Hrg6JvIKEvHacoFJi?=
 =?us-ascii?Q?+AFcHsT7Ar0s/6wDg0LAHByhssCuljnMyDTNcWI3T/BFur4IA0+Q2D73XIE3?=
 =?us-ascii?Q?2aDbr6olVjuEVXPKY/wwjPU4GhjOg3/aOIXIHI1FhrpJjsKxMuBz5ybZF+J8?=
 =?us-ascii?Q?7L63Y8aO/92/GSoEW7jrOlmv6WepmkVHaP/njfQB4/DHFeS/ZckSPb+buB0U?=
 =?us-ascii?Q?XRI1rdRafDAZj4NVtbO1p/aP+7cLy66zdsb6zwSlyikwB5+cxzq1aGYlbbEw?=
 =?us-ascii?Q?FrN60Bfq0SwsqTyKmZHZ9A39+YcBVwIE2nVrU8wtU6KwbOoY1sSnOuKy/C4d?=
 =?us-ascii?Q?pqDcbcEKutgMXOf7xAsHMBWGPLK4KdA7GHCetMxfXKFQDOQOlB7Y7Bwo3ZYa?=
 =?us-ascii?Q?/M9JKAWx3Q0hZL4Ss+d4aKnZazJYJNQk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xSortWClocT/ZLCZzSda2SZ06VyZnZYdrmsaj1fCe1Bv/rF8hhfl7XDSMPYF?=
 =?us-ascii?Q?tjvaTnxjZ8j3xkf0GqXoolGJghd/s2ZDM8jDrQrnFK9dRIpEf97CWhtxCBIG?=
 =?us-ascii?Q?TIQEEkV0eTlJ7bFY3WPT6iPd9mNzSFlofOs5kfwpkdE5v7X2LmUfGApgjL9k?=
 =?us-ascii?Q?98X7R0HZZZhJR5rH28ROwis3Gq4Sx9tg41jH6x0kCbCwlAzEZJOMmASFaj4r?=
 =?us-ascii?Q?JJYeXXpEhVVY/eewbAU5HL4c1RGElIvQMKbJyIKCufsijRTwECnrNufMhmAt?=
 =?us-ascii?Q?N1IoSzeP1pCGno//U2gMULjASO1Pyrv4/GJUYN19X+G4NAe1sarDfWjZ1J90?=
 =?us-ascii?Q?ZzulBqYKOvvHgKp80+i1ZU2p5w8ZCwxKtDEVT/Ks2mbyQ0QxBdZPxJnQpsrD?=
 =?us-ascii?Q?jPPIFkP7sq47a1NYi3WLMyrIZ5l0yOlQ9qxKf64pGt7ru/8faq1k35NkoX+z?=
 =?us-ascii?Q?1hVMjksM0LcNu47TpymGtZYAWTfbGUzZJvJSitWjIE+D0dFgETItSPukLggd?=
 =?us-ascii?Q?sOHS5gMqiWMS2cHAobfmqjwEkZvPnYCxwz/NhGDA/ApwtyKtAJhJP+PQDVEA?=
 =?us-ascii?Q?tdOX6nSuml1cpwSMoaDIqzSDFtMi3uodQrGTLKqxf6IE47T/KSM4USVh+3Mo?=
 =?us-ascii?Q?mpVHycIlhK3TEW+jTR1Ful22B9wW5s2t9ASPgSZCm6kTnVx/eNu92LDuliW+?=
 =?us-ascii?Q?Ruk+xbwsoiWJG42TKVuNspkPQEYiHZKGchdwnU2alizeeQnk7r9yZQ7+OKMN?=
 =?us-ascii?Q?EpLPzdGNOPrLX2YzNOD0+24Ve/FE1/d8kMTAwtjDiCS27xcFtb2DuQVSL60P?=
 =?us-ascii?Q?z32gcyjDeYsZYKuMUvZwCiqJZB8rOQESkRiCgIH9yzCtRVcIx46bcpZzD8Ou?=
 =?us-ascii?Q?Kym5pTgB1aY8NJOSvNoTdWUBSv9GM/z0u7e/iKInfRBK5kFcASjRYBP0uzAB?=
 =?us-ascii?Q?u2GpcUmUhaKuk6qNSHLNbbuoZKmpFkvpagJ1yKv0JWWO6FOYLRMLVPcm3tE3?=
 =?us-ascii?Q?5iQrqNJOpNmujw++UZT25YZ4J61X69sbr0RJ0TtTG5VRE6hIWEDYCaT2p8wX?=
 =?us-ascii?Q?2W8oQjk0xDxLD6Uu42ablZhS4wRkdQCI+/3jtAc/K44/KPGYyBkuiWjwspn0?=
 =?us-ascii?Q?IJGTnKnQwFqGSWAuHonpXGw17IJxd9rZvujAWKBvjG+2RsDMuyA794th+yDU?=
 =?us-ascii?Q?+mQ/hMV44FfoQHCwR2fmsmeQvLqXMcSWD9dYITBMikX30gjajb0CmVwJR7Nu?=
 =?us-ascii?Q?FPrsSO++DZRWaJFZj+CjP7KNpES9itbcaeG3xE+Tvej9hFeUmwBy3Kf03UTM?=
 =?us-ascii?Q?XN9HQ6r5cq3ZHLKC1oVaex5bLfl9mX+PaMce+W0xw8519kFLsllQXs9GDlTA?=
 =?us-ascii?Q?kaXWfDv8jm4tgmNJqE5c1plg1zmAJuSDypUwMpyADOykCQA4Ms81vNwkAQ3r?=
 =?us-ascii?Q?ZszOdCeOn3oz3YCVONgBEqud+j/9GxrteOwyQEIlqwEPwvWU7+j13vJ+k1Ch?=
 =?us-ascii?Q?NN2a2hq7BiFaDztcg03eb2OlMwTMShgXs/SypOwNrnBmB/kH2QNsqpuTEyyT?=
 =?us-ascii?Q?RWKadqJERyOVBVasSDZf1aI1Zemndrcol292K3ary+Vw+SVM2B2EalepcfI2?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	smcj+5Zr5gRX6AhNzg1bxBlYuzDFUg0hT176esaBY72PI/lyjyKgIPGunw3iN4sa/ibAZaJw00ITDOrmHGOqdypod3OPxu7Wid2p8RGyYzvlRCyA25TnCcY0sBt88xgKR9HlyKacmxFJOTsE94z9ehB8ZGfMSuK9CS7aBHZS8seSPNTwdAwaNOOgVBwQoUqXhLxNhnXvLkCtUMhpXIZywJ9IbjULBbCN40tTrgLM/l8WbkOuLDN1zdC9rqAlvXHWeHTqEJlaXM3RtYNpZyNBfsNbpABNz5Jl3nYo7lulwi1zlahGLCDrfbSTTfEySH36GyvZHQDLVOm+B0LLAUdCZPaoFkurXEvQW9J0QvY87dnJP1AjEe1SzR3Y6hBS3toEex3jvTHQFoyVkXT3IiOkXnsnENgyssSfyu9F8dhBxGZV9OYzzNZbf6NNmaMGGQ8H0EpSkKBo99zu4pHRm25YH14cgwIhJOD9vA9jcwLygIvE0WX3lK5szV/bwH60BIFLil7P5J6JT9EM85LpR+Vf59AVvt9Exw3EmtcHUIimhB4bal+yI+vidMqS1q1ydZDpQekOttkq/E48+DM9Yrr3GFLn3jysYxLPvgttEGXt8Is=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b3c3ed-ae8f-4095-54cc-08de1e1e6be6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:55:14.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwPw5sOrx73iA20/cR3ratBlai2f1PSzJfe4i6iuTiKXJGxvp5VMBs1Xw4e0qM7XQmWGj5KUm/dZGRxJ0k9m6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7056
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070140
X-Proofpoint-GUID: oWuOg5FkEHrdykd1hDMZe7ECKJ5P4PMn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDEzMCBTYWx0ZWRfX7YlFangxSyy9
 n+wQRe2BVMhJI6aiWMXTJ3hM28R1UoEOj/c6aiON10txjNXhJ3V/0dlyROv1xNHINtfR48ws1Tt
 DGOcjanfLA6e8LtAtPHHIpnj5lUClo+Pi1M0eT3dgOJVDBC44wZiZiNn/u57S1Yhv9W+VjkXOU6
 8u5E9Kc7AQ+HcNqxwaMI6xFOsFh41COWCVXlgICdYY8PocH4N5gF0SslJGDucaavcW7kx3DTYRA
 bNzD4b0tbcDFp+jPfiD91MARFyo7PwxrkFZpgOWzTLZaQvZs6QgT69e4bOIuNR3SwIPcxxGl6V/
 Z7CiSXHWgkhdeAvj+Jw7OJvvdZ+9g8cM6W8TJ1UnaZ7mqxM813VTNUyBBC3/p6FF0NgfEbpcYG+
 jqFQAzb9EycZ/eZRAOPIr51uw+LiBiByqcmIO7v9rkMtUhr0PcI=
X-Proofpoint-ORIG-GUID: oWuOg5FkEHrdykd1hDMZe7ECKJ5P4PMn
X-Authority-Analysis: v=2.4 cv=Is8Tsb/g c=1 sm=1 tr=0 ts=690e2478 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=po7VHTZ2C7o3EvwwRN0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12101
X-Rspamd-Queue-Id: 9A3444000C
X-Stat-Signature: qhsztaw3rd7i1o1gfjexw8pgujmjnuza
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762534527-422074
X-HE-Meta: U2FsdGVkX1/3B4I/nOjeoZ+3eEV3+q5jMtQi7tqj9jIDIUJDffnHXpvYyoq9wDX4zJT2pq28Sq3PTAzav0/hKW8bFfObfhA2yjq0JsRbXirzqIAAiJncC/bpOgEGo9I+EiF1H8qND4DzlXY7at5X3J5wNXFwZBG0QVtIjPAopa+vMxINJsf0kFgkesGVEbqOrMZe0iiQYjPuUHF3hxZUJmwamI3m4c48RxRdPirXg4XVZeJ5R5J+gKnZVrKb7D3d4tf6IdnLQ+fC7s8LmFL/GU6i1wnGL7wyQVd/qK9mN11VJUGfc5XWg6nDeMXdGUczqQZ8nLP79TrDH/wwUSd+L8fuzyQjxW7a5bEQbro5eB7mSkPmBx3qaeUoDRK6t0tc3zCsE+L2gYdEJz7dllVqAlRUXGO4lBiBXF6RczySqhvI0e2LywUKTF6+MlL3zxNrJBVW5Tip3t25DA1/lR11kk5+ZoyaMl2k0fhnDCSolklzfBMk9NhduhoqBRVeNL6YtWVwTVF26/ZMKXyL/3+c4V6bYHL6+RKZQZB15iUtr61SwHonZnvR+lDQqQbfPGjIE4sZA4v2a6d23zPBICdy42rkaeEtDpj7TkKWxwH+gUxId/czBQR95UHMRoxJ8fV6TT/52KZ5tt/g2nbTwwHs5VNs938PhoTJSItkaOQPxG3eTdnsDT3yMjBEflu42d+60KRBcVqgXK+PHRDxZavP8RXsRdJIdcJRcg+5plArzf6vxSY4qGipyocPJFMLE7LWPIjHXYmBa3gBSJuuNTJGHUiQlbc7WKpJstxXkVVY0ooB4mbhJrVcWD1TPVMyBYt8DPiURo6EsnftWVfh9FgywvshK9HXy7TEsVuU/HMYRBPOLpZ0uJGI4NCdAyj2sJfP762n7YYRQHQvaFav+QB7GPoaBTCeoQ77NwqoWUr70k97hYOcEsffEnMqMJBt649QvgO/hOS+Ex3qv9A0Vvn
 JuZoN/At
 fgvRb3xZl1WNNGwi4HBwM+oTkIX74BgJXtbUivb8D/hyUCZM/pNPcLiKagfdtA6p1wevA9tdx4m1omJFHS+8WNZ/MNIYdjJ0h4YzctrCWP906oGPpbMOFnETeJdrUeGAPYvq25JZCToyhDRhZnrdub0a0On2Nl/gpxNcRADVaxbYvYf0XPi2RQAIMBqODWT7pH+47AjWgFLnssdXdz1vc4S6R9hKxgUPTRGIDCuBFW/sbtWjOMWUKdIx7Tk51iwDFfB42CTVqU+zfftnglQxe4X2tBQbKvtWsNlm2uEczKvlmxkKyDpV5WRsxDazIIsk22T69hNV9oNZiUSDAuXKRo4xXinE0DI7EL6nLZh7vAQTKtux14crCEW5nuZTuUT6DVXRfPzk2WsJJqZAX+5lDQom9Y1xxuKY3kzqGLkja8D0BY6xXyBVmv/0JNg5kJpnWI2lVllr9L8QTn25f8Q121Ilnk8a6tCVGAThxfa4jRy0hHrc+yW951Yx15VSfEebq4ibCepBSuVH71hIA1UPGul00wPyzGKsuCRyWPX3EtR8JAa7B89s6M6X9PATFDYGipFv0Ckchvhv2jvh35zkPFeosMBFuxSqCOOdnJ6ygxdmEJhHKkRcb39ddVGlY4jQu4PmKGipB2Odz9M+rgC2Q3Gj3wZoCrl60Ny2QS0aQ2B5W5fdoPfy/5hRdwvVwMEUxxFj4zyAuSOb8kH2XMypgNsjV1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand (Red Hat) <david@kernel.org> [251107 05:16]:
> [wondering how my mail client decides to use random mail aliases at this
> point. The kernel.org change seems to confuse something :) ]
> 
> > > 
> > > > 
> > > > uffd_flag_t has been removed.  This was turning into a middleware and
> > > > it is not necessary.  Neither is supported_ioctls.
> > > 
> > > I assume you mean the entries that were proposed in Peters series, not
> > > something that is upstream.
> > 
> > No.  This is upstream today.
> 
> Ah, you mean *uffd_flags_t*. I was confused there for a second when grepping
> the codebase.
> 
> Yeah, not sad to see that go ;)

Ah, my bad.  I even continued to make that mistake later in my reply
here.


...

> > > 
> > > After calling err = info->op(info);
> > > 
> > > Couldn't that callback just deal with the -ENOENT case?
> > > 
> > > So in case of increment/failed_do_unlock, maybe we could find a way to just
> > > let the ->copy etc communicate/perform that directly.
> > 
> > The failure case is only detected after getting a folio, but will need
> > to 'retry' (copy is the only one that does a retry).  Retry gets the
> > destination vma, where the vm_ops comes from.  This is why you need to
> > return to the loop.  So it's not that simple to moving it into the
> > function.
> 
> 
> In mfill_copy_loop() we have
> 
> 		err = info->op(info);
> 		cond_resched();
> 		if (unlikely(err == -ENOENT)) {
> 			err = info->uffd_ops->failed_do_unlock(info);
> 			if (unlikely(err))
> 				return err; /* Unlocked already */
> 
> 			return -ENOENT;
> 		} else {
> 			VM_WARN_ON_ONCE(info->foliop);
> 		}
> 
> 		if (!err) {
> 			uffd_info_inc(info);
> 			if (fatal_signal_pending(current))
> 				err = -EINTR;
> 		}
> 
> 
> Just to be clear, I was thinking about moving the failed_do_unlock()
> handling on -ENOENT into the info->op(). And the inc as well. (different)
> Return values could indicate what we have or don't have to do.

I'm not sure on the structure that people want to have in the end.  I
moved the unlock here because the normal unlocking remains at the same
level and was easier to see in bisect-able chunks.  The annoying name
was to indicate ti was returned unlocked, and the comment above as well.

I honestly wonder if the complication of this bug fix is worth leaving a
folio sitting around.  It's to do with low-memory and avoiding
re-acquiring a folio, AFAICT.  It's a lot of complication if it's just
for a corner case, but maybe it happens a lot or I'm missing something -
I don't know.

...

> > > >           .page_shift             =       uffd_page_shift,
> > > 
> > > Fortunately, this is not required. The only user in move_present_ptes()
> > > moves *real* PTEs, and nothing else (no hugetlb PTEs that are PMDs etc. in
> > > disguise).
> > 
> > The hugetlb code had a different value, so I did extract it when I
> > Iunited mfill_atomic() and mfill_atomic_hugetlb().  I am sure there are
> > other changes that could be removed as well, but to logically follow the
> > changes through each step it seemed easier to extract everything that
> > was different into its own function pointer.
> 
> 
> Let me elaborate to see if I am missing something.
> 
> page_shift() is only invoked from move_present_ptes().
> 
> move_present_ptes() works on individual PAGE_SIZE PTEs.
> 
> hugetlb does not support UFFDIO_MOVE, see how validate_move_areas() rejects
> VM_HUGETLB.
> 
> Also, move_present_ptes() wouldn't ever do anything on large folios, see
> move_present_ptes() where we have a
> 
> if (folio_test_large(src_folio) ||
>     ...
> 	err = -EBUSY;
> 	goto out;
> }
> 
> So I think the page_shift() callback can simply be dropped?

Yes, looks like it.

> 
> > 
> > > 
> > > >           .complete_register      =       uffd_complete_register,
> > > > };
> > > > 
> > > 
> > > So, the design is to callback into the memory-type handler, which will then
> > > use exported uffd functionality to get the job done.
> > > 
> > > This nicely abstracts hugetlb handling, but could mean that any code
> > > implementing this interface has to built up on exported uffd functionality
> > > (not judging, just saying).
> > > 
> > > As we're using the callbacks as an indication whether features are
> > > supported, we cannot easily leave them unset to fallback to the default
> > > handling.
> > > 
> > > Of course, we could use some placeholder, magic UFFD_DEFAULT_HANDLER keyword
> > > to just use the uffd_* stuff without exporting them.
> > > 
> > > So NULL would mean "not supported" and "UFFD_DEFAULT_HANDLER" would mean "no
> > > special handling needed".
> > > 
> > > Not sure how often that would be the case, though. For shmem it would
> > > probably only be the poison callback, for others, I am not sure.
> > 
> > There are certainly a lot of this we would not want to export.  My
> > initial thought was to create two function pointers: one for operations
> > that can be replaced, and one for basic functions that always have a
> > default.  We could do this with two function pointers, either tiered or
> > at the same level.
> > 
> > Most of this is to do with hugetlb having its own code branch into its
> > own loop.  We could even create an op that is returned that only lives
> > in mm/userfaultfd.c and has two variants: hugetlb and not_hugetlb.  This
> > would indeed need the hugetlb.h again, but I'm pretty sure that removing
> > the header is 'too big of a change' anyways.
> 
> Yes, I think leaving hugetlb be the only special thing around would be a
> sensible thing to do. But I would expect shmem+anon etc. to be completely
> modularizable (is that a word?).
> 
> Having a high-level API draft of that could be very valuable.
> 
> > 
> > 
> > > 
> > > > Where guest-memfd needs to write the one function:
> > > > guest_memfd_pte_continue(), from what I understand.
> > > 
> > > It would be interesting to see how that one would look like.
> > > 
> > > I'd assume fairly similar to shmem_mfill_atomic_pte_continue()?
> > > 
> > > Interesting question would be, how to avoid the code duplication there.
> > 
> > Yes, this is where I was going here.  I was going to try and finish this
> > off by creating that one function.  That, and reducing the vm_ops to a
> > more sensible size (as mentioned above).
> > 
> > shmem_mfill_atomic_pte_continue() could be cut up into function segments
> > to avoid the duplication.  Or we could make a wrapper that accepts a
> > function pointer.. there are certainly ways we can mitigate duplication.
> > 
> 
> Seeing a prototype of that would be nice.
> 

I'm not up for investing more time into uffd.

...

> > 
> > I think there might be value uniting both hugetlb and the normal code
> > path, even if the operations call signatures are aligned and we just use
> > a pointer to a struct within the "while (src_addr < src_start + len)"
> > loop that exists today.
> > 
> 
> Right, what would be valuable is still leaving hugetlb be special, but
> minimizing the degree to which mm/userfaultfd.c would have to care / treat
> it specially.

The question is how special you want it to remain, I guess.

Thanks,
Liam

