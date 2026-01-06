Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B754CEFCEC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 19:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1EF96B008A; Tue,  6 Jan 2026 14:03:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC976B0092; Tue,  6 Jan 2026 14:03:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858E56B0093; Tue,  6 Jan 2026 14:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA376B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:03:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 262E51A8AFE
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:03:03 +0000 (UTC)
X-FDA: 84302461446.23.4CA080E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5312120002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:02:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L0PSItHe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZPKvxDh7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767726179; a=rsa-sha256;
	cv=pass;
	b=XIowLPN7GfTMSqNc4x/QZbkOuIoDufMwOdade936iFuoRXYX3XaM5qP0QLOyzwL3SMbHRl
	GPfEam/aXv2mGj5FkOQ7Rt0FlEL054W+KpzGzLbQ300i9AC9K8QJLC+L7NGwvLmpJKN2fd
	xkabfDih/RxxDLf7J/p/g2ieas57nBQ=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L0PSItHe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZPKvxDh7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767726179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WC4wU42u1IxFfNHNaVnqP+d+Hs8VfyUwapTeYqApV0=;
	b=7VoWnZFnS+xwt4FGTMx9orNySGORza0Hj2sc5EkDSgns9MpiJCoGfMdC/osMa0x1lfvEnr
	7cYzrDZkq+aFdyscfXZtksC1aNwW3VGPUg34OmFmVLVu8YWuGXH97BVRIezx3T8sRI0lo2
	mDeNXJkZrbomkDx64zG5rnU+Q/7hMnQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606J11O6310947;
	Tue, 6 Jan 2026 19:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1WC4wU42u1IxFfNHNa
	VnqP+d+Hs8VfyUwapTeYqApV0=; b=L0PSItHeweLTdLiKj/OipWR4qDVKbM4x3n
	Ha2CxHCLRx3YdtcZOBfpUNMAIKviZHuawXt5Ocu/qg4cPWcthqwqh7WrBGlHMUT4
	gOB8CRcyg1+48m8XBAbDK210XSc/0eT4U94z/e9VZwG1fJflmcwStpDPR3lcD5qv
	gQfZPUYl+aWIQ6K6ZaEsXvf/Bg64mFnA+sT4bhKFFFnjl9c7D2jGFDFWVo566Bbf
	tNslbwJJskxAFyOYJPIbAYUEzNe4wiC7M2Idn0xnBMXLRmVHMe1nNDeVfsL5/zRj
	77nOidkCXvJnpQ+mJTkUsnJu/Z+Al9qIx2eH+anelqlsxM2MKbsA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh86ag02f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 19:02:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606ITQF3030826;
	Tue, 6 Jan 2026 19:02:54 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012055.outbound.protection.outlook.com [40.107.200.55])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcytqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 19:02:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mpcPkVFNPlPekh7QUOLvN0bBVOUzuQERJOeGzZKkUenJ+RxtaFq/e71+3o5lclxkrIpt4cJ6cHMSAzbKJsZlAbpqkhR5U2nlqRP/LjUPpIDNdT4J4VtFLxCfbUc6aJxHlfrlATqB1n0m878M4vFBT10tRAfg+D2GJmLgs7nm1Y7ENuFshEkugbNnt1SRdNrlZAODbQW1iQIOVqoXmG+J9JGclHGIJuftnqi4exSrPUG71I33ltxNOYBuar2aqvoQ0I3ePSl41G2EYvgsd9Xjo0BbdsqlT0sDHR6LwqsLk1mlFYmnAFCUuS0kSGgJkcyym8TxnMSDqCD8pnDkaj6X+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WC4wU42u1IxFfNHNaVnqP+d+Hs8VfyUwapTeYqApV0=;
 b=TKXWjSSWkAaL1aDyKAADHauojJcOyn0WwVGoNZKfSV7YuLvUni6UbvXNFCTb8pMTx4g2OnEpQD8IxV65LFcQf6n32F1Dll1Cgf1RwaUV581m7T697Dm5dM3j/pO9S/wQtc2mZPc7o5ZlpuTugL1P/XgCNrzDYxtPYcjZM7CchirzB9HL3czNFrKpCrh5i8WlACQwnn0cdUFMLivPNAcINFUaWGmo79JkYOaFtmFUDvNE5CCYX1VDsn/g2bMwPf+NY2LOwAg8ZbyM6TbZuZBC8Yx6nN9nVv8p++ahlh6IheRvxryU8hfTKAUGS0TlowVHTUyROaaIFjRa4erpRvhWyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WC4wU42u1IxFfNHNaVnqP+d+Hs8VfyUwapTeYqApV0=;
 b=ZPKvxDh7bBdmngcMRIAKPbrVUfdE35ThwoYMvYWt/kQg/uD4Ue0Eb5Z7gV89jKqhjbnXxpnQhN9Z9Y+5Hm+Ol+eT0ltJI0HY+iP1osI6f5k+9ae+rwp2pd+NDBJh+xdm6qtK9UARoTbYsETkWp55U74s3PykOyAI5OpSMT2IDJc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB5782.namprd10.prod.outlook.com (2603:10b6:806:23f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 19:02:51 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 19:02:51 +0000
Date: Tue, 6 Jan 2026 14:02:48 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] mm/rmap: allocate anon_vma_chain objects unlocked
 when possible
Message-ID: <r57ezh55nc7x2uzepv4xxacmt5ar5mdlb732vllfh5juxnavv4@x3e33a6m2gxt>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <ff2651a4d5b73c7cc8160c55d46d6e5385996e62.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2651a4d5b73c7cc8160c55d46d6e5385996e62.1767711638.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0019.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB5782:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fa1d84f-0f48-4a36-534c-08de4d5630c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MctlcfqBwC/7792RBTw5Yg3qeJid1k/Dp8xNP29RByXNcjH4Am3kLipbgKMP?=
 =?us-ascii?Q?Q+W2daFGb+w9gzw/gwa4Oh2Za5eX8KpbAhUvYkIv3lwPnsFHK1uLVY06zvga?=
 =?us-ascii?Q?rsUs7dxiGqFdqpmZFJ3q9b/zs/DtXI9BfpEs2EDzVVLzL+Ti8Fk90XBmypB7?=
 =?us-ascii?Q?qzuh6JIZcbrhnsVnl7eLtOJWmpWwNCiuZhh3gVQXuQZFjY48tZWr1joOFSwh?=
 =?us-ascii?Q?NW3/LJd0KFWPrpu6fDbadw3ai2q2bIQr8lJqwhiLKmCvGjG2Tnnixfgjj300?=
 =?us-ascii?Q?UINSBzzm8FMhsnuBBl39hyL1YnX7MO1uivSwHFCoRrGVoydBv2zP6LQVdYpt?=
 =?us-ascii?Q?TYlbgWOH8mWPxFZRhvJThJeO+LkWGlb4yCyK/9s+9rJrumJGr4HFFQ+cWKF+?=
 =?us-ascii?Q?ghjSqsB4vcS3XMDJbIl2aHxVfXq3e1KKZK4mHieSog/EtAFahAhi9hmhKmsv?=
 =?us-ascii?Q?gy5D+BLUkLSu2eAWdrJitQR3lPL0P106aNqhwHAji/WqjwREVsaNUmpugFfe?=
 =?us-ascii?Q?DXVrOvAO87yYj1DFten1YO9v1jI8efMyHfm8jqtzd5nyoK86qeBVg+EN1vo1?=
 =?us-ascii?Q?cSP7I0Gl4iA40c1fN3s72JHew9wsM+kvD/a8hc8mqiQAlqR8wS3eDslMuiuM?=
 =?us-ascii?Q?SYRLLsq//caJCx9z/LZIHchLAr3bUVA6JZZZbh9YTxxw3yT7XuqsEwXD7A0W?=
 =?us-ascii?Q?O9ojV8pbgYdRyQtbou3OzVD4vyqwcvEaVyQmzKMumye2baOknfgMKS6RSpKJ?=
 =?us-ascii?Q?VFckEbxqUuDVdEoQBIJAPPyA6BtRkgOt10OlSxaiFJK3EIPJOMHiy0y/kQW4?=
 =?us-ascii?Q?3YC3oiUItGXYxfanuDK1ARXAYCinkNGkVky8Wssr4P/ryaMBJBUsPq3yZSCp?=
 =?us-ascii?Q?dX17iEwV3Y6E6CHDbISAiFLGM1fBvWjGVuRp8tbpB/gfHFYwFe/uMYvhLPeF?=
 =?us-ascii?Q?5pwWkeyG70zXBXWgPbgaY/FUqzcxCCQksQK8/Wxd+PwSqF927bl4GfJwxTlk?=
 =?us-ascii?Q?lZC35/9xiTrUCQmKyECSZkmKir40Vv6hOa8El7Kk5FvgjRQI5JlKa6gPUwr2?=
 =?us-ascii?Q?k7kJDYgqcpVGDkJgqYvSEIXb0GPG/ZS3O2BT+TGr25GvRr7CrPu4U0fAV2lj?=
 =?us-ascii?Q?LpdkX+5Y6DzGe9Ekagm9x6eYtWzcrhPUi0vRSivSDBFqQlrDT4MHM3caUo4a?=
 =?us-ascii?Q?x/bT3nXE8xAoP062kHhLTtnAgFi3kk0psFdb3vZQVvjT73go/m2ZW/PvO2O3?=
 =?us-ascii?Q?w4LClBkW1ViTSpX1LduLOxJDeX0kNov9noN5tT+PnGpLbMtUm0ZKFAvBJ90H?=
 =?us-ascii?Q?x1lpe80kMl9s2lGkDzEfPEWeieLM6Pkm2P6MYSAp/Q39t4V/HwylAtS1EhG8?=
 =?us-ascii?Q?WcUCPIPpvFKO6Y4d7F4aii2lnkR/aNmohbTBCZE7n3KxHWDuN3H0TTjMlz7N?=
 =?us-ascii?Q?00Bmcts60CXJ7AbZllLvMI3rFItHPUiJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?df1tfmyt7Q3KcwN8JXum34jrFJKVazZfgQTrAkcOXe2rUp7Efrh2NRjKafai?=
 =?us-ascii?Q?vjKpuc071Ud2KFbNRDfL5vw4PARB0EC8QNYYFhpNLH+uau4ByNmDyOcwkDQS?=
 =?us-ascii?Q?jt5ZEHAY+/kacum8Fy5iGPVirVI6jjwQM4nB6zotl5nNvKM0ylUtAOATNxwS?=
 =?us-ascii?Q?+Ln0HYRUrsAxdDulB17wlEaWtnO5/d+MRYb4V2O0apkmiMWkKLrgky0UGk8G?=
 =?us-ascii?Q?8XfgwvAXS/hIBt+z7r4KDstRKmfvBqSTjzfx0IVNzeOpegvfx8FiT9zRyT8v?=
 =?us-ascii?Q?G9rXq4V+9r5IjvLiAdcxepexw5XJ2QQd5cmfK6JYGLH8czYUdT8PrRNT+b0x?=
 =?us-ascii?Q?pbb2nVXbDwPtD1QS50bsNk1LqB1F8U2v4Z50jfcpu9RhgctyQxNvHiOF5Rq3?=
 =?us-ascii?Q?ddWjKrDb+tdgX/Ovv/c4VhJUsxWFpbcvS0m6Zo4Du0tI9891JSQgBFO/dGXh?=
 =?us-ascii?Q?8VhENYmBXdS1P6dIeqwEP+35NW1ZWpfwzuoFy1yzwVeOQtZ8+nko07G72clQ?=
 =?us-ascii?Q?aMXyfrfOYXFD+Jm8fA6b1hXCES2D9kCtg4Z9S6BzVFzgVyuQvYnocuTr0O0V?=
 =?us-ascii?Q?oE9v7UJP7Wk3pS7KHd0APvRnR31iQfqyKUk1IYhmQ1j5ZRmsq2LUaWiKEMDr?=
 =?us-ascii?Q?udfpUaLU6kEnIdy92ZWkaGCXUFcxHZAAAwoxTO5fDU85cnY5L55AJJBJG1zQ?=
 =?us-ascii?Q?32uZMteZRacV6Dbh21WAFXnXt7fVot5ubEVa0tw/026po+X/2Z5gynP1FXHd?=
 =?us-ascii?Q?wKLHFr+kk9U8RFHmLBe1lUI9lYyjiDL7zT7ahgP+Q72n8ILIJaZWJke50YAH?=
 =?us-ascii?Q?vVsghFztxEBzjUH1GqZaXkHeTaXcTVFL5q0XC2zzhmzukqWB3D9ZFqgUk5q9?=
 =?us-ascii?Q?bu6HuxEO4KXunTST0uFb8Laha/0A7JFI7Wj7EsXmk1vRNzUHt6RvbxbsWmTv?=
 =?us-ascii?Q?gL+5NKHAXwt02bFoplimY3ZL5vpTaEwv3setnQzXzGZZS/25f8XwguOF4H1a?=
 =?us-ascii?Q?NtcdUBHV702PDUq42pT7XuIkdWFnvUDeZ72sokyYi0duylWGbPf8d1AXopsz?=
 =?us-ascii?Q?1zKAFbniDUOPMwOfzFtdqjdREXcuGb6bHtUSO3Zjh4H/rOdWSHvVh0gAKaoq?=
 =?us-ascii?Q?SYvF2RTmBeDA065j+81rOTDvuw/HhOn9U/yseENcOUZNcATcb3JLyTPjepXA?=
 =?us-ascii?Q?OVusEV/HQvdD5E/Rk7T6k6C186/X0NJOIeS7VpSI6/HJlqbNfr+zlRxjTS5m?=
 =?us-ascii?Q?8RpwyWIJDMuIdzJbbwWbMhFBVuqAhei3PoFuI9JNTG/rsNckIWXOzhNNP0VP?=
 =?us-ascii?Q?aI1Bu/LTn9So3nH1p75VoGhXuMPQcSAqYm4paUvo+QwtqpKXx810ZxyqidnX?=
 =?us-ascii?Q?oxbaiAAutjNPZFznwmncDfdavn+F5Vb3wZ42yRLxFkI5oaHIWqim5i99KicL?=
 =?us-ascii?Q?R2R78VGCmJv45pQqnmpG6KdozrM9InWle/ybqMWgNZYYDThm8QfBsmH1bQsP?=
 =?us-ascii?Q?BV7U2fWZN8k+XVK/yCiU2HbECNUhbZAU1HaRoXY1pDneXgn9l4bYNml7Wn6O?=
 =?us-ascii?Q?pha+pQeLfb1tw8bWzKu66fjssbN2/LEzNFtp1kH0cvkefhkuqTOlWIT2Iw7d?=
 =?us-ascii?Q?r825COw7Df9OHJIordhUDeFE4dPw9TPMRHzOiVaLc8vkVQ3My7YC/TU+osXO?=
 =?us-ascii?Q?6BdfrOVdkftvqfXy3PnfqKcTxj4yDLTh1RP8ZPChP0BcDGKQgfc1aeo5WYNs?=
 =?us-ascii?Q?wZ+lUcHNGQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OxOkosU1QDzLMfddryiFNX/+/oC8J8WKppKytNPgWFuupPCxQmL4Q2Iiks0BV2byl3UtDs7i6Ln55q37zDhhRaLhZ825eYykRNnesCDcNf+AFJv9ih91W3L+sEMo+eX2vMu2Fm4YneR9JE5N203I6tAz+5zXijbgpLA3fsLkv4LP4nMGwWuvPi6E/NDgogp3NDOocdLY3jQrBtpEJkhIWfEpppkliQEx7b8sxn7J7sTiYoDX5/Vfe5cuQER14BpIs+UTWq70aF/nAuaPAbQqTX5OJjuCk0hHgEGlSjBi2EZsrykXd5p7hW/11kBje7fDgGx4Fb3Tbr2vSbQb2VgjpycvY1H9LXJ73j2jxbkfzN6PjjivEugD+rG1G2PVkeol7ueTROptQZoSfQVenjixRhyzqcQYWn9akFO6As8Q1WcJ0SbRK2fLgIf4GjgXB3FCUSV9gvM/Xp98uPe3s8fpzVyZntm4Yh7YHUJ8qgA58IhKAqpzqMoCRHT9GOB6y0J9hoj2psWhYUspc8b/nQP16ZT1qHKLGLgdFlJ5ChOyXASUGr0ZODVX+11fLWisVd1hseT44yMmfWNhOleb06B/LI76IZpiFJbQ7x5aJUC81Bg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa1d84f-0f48-4a36-534c-08de4d5630c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 19:02:51.4864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmHbLxW0c7imxRuDrA+ohZ9UHOlhjIHE33HHiifWIXOZ141hp8iZmC5ZMjwV+ktTUICWzm2MrpRtnQEGs4HWGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060164
X-Proofpoint-ORIG-GUID: 679SEQZlrnc9LaA0Kp4PUTUcGtoRXunA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE2NSBTYWx0ZWRfX3ONKyJTpmJLQ
 oiZTwgdssTGRlcJSP3RsxSE7PuNqPYSFQ1B2wGxaUyOLWZ4b2iGcgCEJuRgJcf5wuviNj8J68gF
 AYBxqXM85TMzRnsqf4OtVEGI7qTvMdoIZ346L6LVfHSQbbI1I8YT1IGKcZiDGkkzu4C846B+xq4
 Olnd4VlzJ6Y3rmiDi9WZvGAcPgIY4Uj3XLuJ9t/rSqY50OCz+b+5PIiKYkq43Xu6pGdE//cHLpx
 NSrA2HXeeUz3yJpaJ8LODk0abQP4h9wZ8oohQMnhHu1evv3JzEOlZVWR1GsW+lNjzR6+jKUWaOy
 y/kpgTpSDssEQ2SuSr5cCb0cHbJAD+ZX+WSKPf30tviRqh7mEwV06tpNtIbipdzgrsRgPHRiAmd
 HThpN6gkWJfHTzf+EWfVjV11H5U8LxfQkii25EBqjR24Sv8P/4T5gavANCBqC51goLcpcomiAkh
 lLei0P5TRkHXBy3LcvrCz+WFn41ClRz+puaPmJrA=
X-Authority-Analysis: v=2.4 cv=BqyQAIX5 c=1 sm=1 tr=0 ts=695d5c5e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=Io54LoVeZBncPc75EekA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13654
X-Proofpoint-GUID: 679SEQZlrnc9LaA0Kp4PUTUcGtoRXunA
X-Rspam-User: 
X-Rspamd-Queue-Id: B5312120002
X-Rspamd-Server: rspam10
X-Stat-Signature: kycnf34jkxh8e7a7wsj9z887hwy9et1o
X-HE-Tag: 1767726179-653882
X-HE-Meta: U2FsdGVkX18CH5/Z4c1C4AXaCngvrz8lCTGj6OmnnCkqBjbxQduTnVCiNlfJ9N5PFv+5ZwsR13iJUwIRT7QGghe9fqmE7zHhooWu02e/ImT/bjAYDQWoUHG1LDYZlxsGSaMo1aX47Ovs5FkZH4fVcdsZYXGD7EJ05Jqd2T8/vV5sah475yQuWSgaNmpr2NX5acYT7DE9tQMs8Jo/Wixw1I8dfJKbEqdIUVu+VhClwU7g0r1XaeVa1n5EPzO1njdhDxrayOyNyYrys59HMvBcOAbq/82prVDyAk0SCrO0rOfjAK/za2Kxf1jke0jh+gLz1FI7U0ZAflpj4aUGSF5PwQKrslK2hTKUdoAFufxZdrFxbwRZUCA79OILlTq7JvO8SCkrCe/CIQ9Lr2Mz5h4nVANURsG5JgOW2OMG2ZZ8RQS629nGFyK7kmNOh5If6cjC/dIZhODJtlu9SxTV5ID10pfYR0n8TcPnFVMWHA7Q9/77me1GrdpEMwP6q8KvsXsEqd8nSZSsg1aZ5ZQ58fEH+KZ5DOgYqQKeBJPDYAnqjd9OHWgD5IkEeSrv5jPq5PDlpfUSzI9SBKB9GybZNFCrDK2rgjKl7D3LlGocNEz9UYHh31CFV2r0g8w4oInnbEV+prViffCRfoUGwkA4GhxPD8DSEk8isqfXkvEMuUtWA7WQ9wi1H9Mt0E/mMfUqy+X/EnBdMEvHtjjUgA5Ebg1TF/euLMwSpNQpmL3nChMpHiPqLiTelK3jbP9xBNjEP6PH6Ctabw7gpkaH0sbqfPsnEmnipq1HkOgM5mkttUcOdwQqZ3tZJEYc1f3ocKGi4JhKtPdp+AZV8OjWFmu51g86RIEqTuQRbJ2aIJE/oxIvzo/i/w/FGdScwGcQDYix0SMY4aSlXEpDFum3HJWwm/AoUhDRQjRonfjN+CExQvolezdPdjQeHv/MuFjPF+ygnXBWv9y6xpvhyVDAjxLlnoI
 IIcFsEBG
 yJ+TtJSX+OmqnHf/eH0YpckMev+gGqO9p6jPKhlTFtSAm1yi5+dWbiNBFpDYxRBj3j+6MY/YEYOydtL0UwOmIEBXGVMP2IXvshopN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:04]:
> There is no reason to allocate the anon_vma_chain under the anon_vma write
> lock when cloning - we can in fact assign these to the destination VMA
> safely as we hold the exclusive mmap lock and therefore preclude anybody
> else accessing these fields.
> 
> We only need take the anon_vma write lock when we link rbtree edges from
> the anon_vma to the newly established AVCs.
> 
> This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dance
> introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocation
> under anon_vma lock"), further simplifying this logic.
> 
> This should reduce lock anon_vma contention, and clarifies exactly where
> the anon_vma lock is required.
> 
> We cannot adjust __anon_vma_prepare() in the same way as this is only
> protected by VMA read lock, so we have to perform the allocation here under
> the anon_vma write lock and page_table_lock (to protect against racing
> threads), and we wish to retain the lock ordering.
> 
> With this change we can simplify cleanup_partial_anon_vmas() even further -
> since we allocate AVC's without any lock taken and do not insert anything
> into the interval tree until after the allocations are tried, we can remove
> all logic pertaining to this and just free up AVC's only.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/rmap.c | 78 +++++++++++++++++++++++++------------------------------
>  1 file changed, 35 insertions(+), 43 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6ac42671bedd..8f4393546bce 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -147,14 +147,13 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
>  	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
>  }
>  
> -static void anon_vma_chain_link(struct vm_area_struct *vma,
> -				struct anon_vma_chain *avc,
> -				struct anon_vma *anon_vma)
> +static void anon_vma_chain_assign(struct vm_area_struct *vma,
> +				  struct anon_vma_chain *avc,
> +				  struct anon_vma *anon_vma)
>  {
>  	avc->vma = vma;
>  	avc->anon_vma = anon_vma;
>  	list_add(&avc->same_vma, &vma->anon_vma_chain);
> -	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  }
>  
>  /**
> @@ -211,7 +210,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
>  		vma->anon_vma = anon_vma;
> -		anon_vma_chain_link(vma, avc, anon_vma);
> +		anon_vma_chain_assign(vma, avc, anon_vma);
> +		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  		anon_vma->num_active_vmas++;
>  		allocated = NULL;
>  		avc = NULL;
> @@ -292,21 +292,31 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  
>  	check_anon_vma_clone(dst, src);
>  
> -	/* All anon_vma's share the same root. */
> +	/*
> +	 * Allocate AVCs. We don't need an anon_vma lock for this as we
> +	 * are not updating the anon_vma rbtree nor are we changing
> +	 * anon_vma statistics.
> +	 *
> +	 * We hold the exclusive mmap write lock so there's no possibliity of
> +	 * the unlinked AVC's being observed yet.
> +	 */
> +	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
> +		avc = anon_vma_chain_alloc(GFP_KERNEL);
> +		if (!avc)
> +			goto enomem_failure;
> +
> +		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
> +	}
> +
> +	/*
> +	 * Now link the anon_vma's back to the newly inserted AVCs.
> +	 * Note that all anon_vma's share the same root.
> +	 */
>  	anon_vma_lock_write(src->anon_vma);
> -	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> -		struct anon_vma *anon_vma;
> -
> -		avc = anon_vma_chain_alloc(GFP_NOWAIT);
> -		if (unlikely(!avc)) {
> -			anon_vma_unlock_write(src->anon_vma);
> -			avc = anon_vma_chain_alloc(GFP_KERNEL);
> -			if (!avc)
> -				goto enomem_failure;
> -			anon_vma_lock_write(src->anon_vma);
> -		}
> -		anon_vma = pavc->anon_vma;
> -		anon_vma_chain_link(dst, avc, anon_vma);
> +	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
> +		struct anon_vma *anon_vma = avc->anon_vma;
> +
> +		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  
>  		/*
>  		 * Reuse existing anon_vma if it has no vma and only one
> @@ -322,7 +332,6 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  	}
>  	if (dst->anon_vma)
>  		dst->anon_vma->num_active_vmas++;
> -
>  	anon_vma_unlock_write(src->anon_vma);
>  	return 0;
>  
> @@ -384,8 +393,10 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  	get_anon_vma(anon_vma->root);
>  	/* Mark this anon_vma as the one where our new (COWed) pages go. */
>  	vma->anon_vma = anon_vma;
> +	anon_vma_chain_assign(vma, avc, anon_vma);
> +	/* Now let rmap see it. */
>  	anon_vma_lock_write(anon_vma);
> -	anon_vma_chain_link(vma, avc, anon_vma);
> +	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  	anon_vma->parent->num_children++;
>  	anon_vma_unlock_write(anon_vma);
>  
> @@ -402,34 +413,15 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>   * In the unfortunate case of anon_vma_clone() failing to allocate memory we
>   * have to clean things up.
>   *
> - * On clone we hold the exclusive mmap write lock, so we can't race
> - * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
> - * anon_vma's, since existing anon_vma's are what we're cloning from.
> - *
> - * So this function needs only traverse the anon_vma_chain and free each
> - * allocated anon_vma_chain.
> + * Since we allocate anon_vma_chain's before we insert them into the interval
> + * trees, we simply have to free up the AVC's and remove the entries from the
> + * VMA's anon_vma_chain.
>   */
>  static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
>  {
>  	struct anon_vma_chain *avc, *next;
> -	bool locked = false;
> -
> -	/*
> -	 * We exclude everybody else from being able to modify anon_vma's
> -	 * underneath us.
> -	 */
> -	mmap_assert_locked(vma->vm_mm);
>  
>  	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
> -		struct anon_vma *anon_vma = avc->anon_vma;
> -
> -		/* All anon_vma's share the same root. */
> -		if (!locked) {
> -			anon_vma_lock_write(anon_vma);
> -			locked = true;
> -		}
> -
> -		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> -- 
> 2.52.0
> 

