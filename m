Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E715CEFCEC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76CD36B0092; Tue,  6 Jan 2026 13:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7438B6B0093; Tue,  6 Jan 2026 13:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6057E6B0095; Tue,  6 Jan 2026 13:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4586B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:43:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B951C2A25
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:43:14 +0000 (UTC)
X-FDA: 84302411508.02.73662E1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 928B0C0014
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:43:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f9BozF4Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r9lBOqaN;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767724990; a=rsa-sha256;
	cv=pass;
	b=w/46fGfAdWl00q1HbSumskjqGIIBpd5npXAfHDhdOvTXP2naGoJYZXUbUx2oHKkvrondcd
	F+Tt3vNoFrXXZpn7n7MjZNBAmi3AAhwZMZxANyeD1HUetnKhUrOmlKZbN47bJOS9SbWiY4
	YmdoX7tQM2+7Ve+cKRyWL7JK+JwbYWE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f9BozF4Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r9lBOqaN;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767724990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwdrW0tqe8X1N6q6+mjkNDaX5K4D9nSgDTHp3r84k8Q=;
	b=34sJDROt8VhF9xx90WJEAF7QF13TlfqNBvhDFsIocPQ6E+54E1UIud9aXvrxztQbG+h25z
	7N5THhWesMmgwJQBtkUhShawk+qVigmeU6WbXIL8CYxxRFwcbBLqlEtqN4jucjsXiyDeok
	JTT4m1p8h5CM9vylClg9HFveLfTvyKk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606Htkmo137653;
	Tue, 6 Jan 2026 18:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XwdrW0tqe8X1N6q6+m
	jkNDaX5K4D9nSgDTHp3r84k8Q=; b=f9BozF4ZLF1rm1Ar4ycVJcqtuM+w/e5MQs
	mvUzHoXa9j4urE/COqb1rJlYl3dX+W+rq7FmGP/xxsDupQecDLSO5qHmlW1tWzeS
	Y4qj1T/GkWnqcRxV2nSom3JcPL/7niDcu+2P+H9/ha6RhGaZvKf2VSJOZW2OWQnU
	7hpOsGa6smi2ED6pIe4LdDujS+9/D+RyVJKn1Ri1KkfUvK9bkn38xCZw9++klQJk
	5hhd1rnBP19vjnsmI4fIWOpiw3dSSbnwz54lMW/r/y1g64DEZsMpFrFJ6IeShTFl
	GWvxe2qcebho3h76XN1+BgPxNvxzN8imOPrgPTW0RkvSoxkQc1pg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh77qr2nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:43:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606HZKvu034090;
	Tue, 6 Jan 2026 18:43:04 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8xd7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:43:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tYNziroXG0jHd32mn84qFWkYyNx1NjPNWcM3PVjxdW9lXJNc1Lm40PcpZPxRqbSRl5eKsb7yv0azSBfizNHtbFTmONWPrepOodDNBX0kseeqZgRzw458scQAdsineuap4lI7QwSJH90lDN96Xdh0k/ng08Cdk1ju+YWsIVaPnH1/hkyF942gZutErumKLRqgKRuFi4GA8mRudx0EAD9yu3HLqOdu8bt4W6Y9b8S9MQLCurEg/PsqWdef/q313+W6rJa29B9ZQxYHcTbvw4M/srOO3nSsxWHxAGTGnuHHfTLrLnHaez09744/UsWLIVW0Rfbyb4tS2teu/IQ02WykfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwdrW0tqe8X1N6q6+mjkNDaX5K4D9nSgDTHp3r84k8Q=;
 b=ICevSoJcJD/oyfgD3XXQEaVteEw4wy7iSM48JOmO7T7DrO7Ja3UTaUmTvqoZb4YRc/R1hyMfqaJ7370i3PwweIQsqLc6VDQTTHreVNv+PbsW0Np94XTVIr0figVAeWoqvk00FBwdCjr+9db5Ib0aTuwcswFrAtUmV8/3O3jczMW0UtQ1CHctQMHnAFcJ6sRwi7XObw3MLhkegQyaahveROmmj+rhNhrwocg+iJshvgufE44ehifDaJCS7gRlrr2TvKdsPWlWf8MWGq0ro8IvTd/VuPLBAwp2s+AyzoKOwIL2aB+wUJYACt8rqHyY5+3sP8JkRa8rQeVx1c5JtiF/KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwdrW0tqe8X1N6q6+mjkNDaX5K4D9nSgDTHp3r84k8Q=;
 b=r9lBOqaNEjmxCBgMXam8jbeV1/SFTyB9U10I5RN4QTMgc5l7GOfp+YcZlQ1XSwNhMQv4AUohwx6jTFRg93gjyMRT2tneIJPfbM12G+A+/Oz75Dz1L8IGZBMsYD/7oGhMj2XtKrDN2QGoHVa2wzATromMxqU26i0vHQW5rEuccUM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 18:43:01 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:43:01 +0000
Date: Tue, 6 Jan 2026 13:42:58 -0500
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
Subject: Re: [PATCH v2 4/8] mm/rmap: remove anon_vma_merge() function
Message-ID: <crfyj7sjuscw5wdbhkwxzqzjwhrrzlppyvn7hik47kiv3w2lqa@5ytfftnrpwh4>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <1f5d605c2b35462194782fd17212a4d6c060e278.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f5d605c2b35462194782fd17212a4d6c060e278.1767711638.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0336.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: b6df1705-aa2f-43e7-911a-08de4d536bb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LnQNBZ18VOL22budD3m+0BzVplX12OvaO+MvgIL4Nyf4nBrz3OUReapi/KlJ?=
 =?us-ascii?Q?KSaWGGwnbQJZerOrVmqRwPL3aiFIjQ0IHoy6XCPR5P/tb66CgaTph5sGNTU1?=
 =?us-ascii?Q?gnZDuBU51Fmx4L5NEPJj2Lpr0idSK1TfnL7w2i1fMMxcAaCi6HwMXmvwerC/?=
 =?us-ascii?Q?gcwE74BMloSU/yWh27ETpzXUidyb3j1SI8P+4VR/DwaRuXZ+l3FG9BgVgc70?=
 =?us-ascii?Q?JyyMyFlPoAv3ZfBvFVCTAD0/wO+sbz31I3wV8naQx5rpx2J3NqK44Uulj4wg?=
 =?us-ascii?Q?Zc5Q+vvvnP35AAP+EwmH3XTx21p1OPbtKVSUPllWLlGLxcDJPO+as02mbqdL?=
 =?us-ascii?Q?n689YlwfpTosYaXNNCJvbim5dneb7/CgRnAc5jEDV90c2JtIk/OkADz5iAIW?=
 =?us-ascii?Q?vEUp+Hb/v3X9SkLUMwSUQ3GHbVjUnIDzMoQZzFgnvVb727UF6ybHXfErMx0z?=
 =?us-ascii?Q?vQypUz5MNU6ICokyACBZMNo0SUNkqo6+pfVWf2nY9l9+ttUsCz1pM3i6zlS9?=
 =?us-ascii?Q?on4MgFFpDn8F3l7X9VbLmshEulPCFf/ypVJNzAtywtrMz6o59fvXeDX7ZgI1?=
 =?us-ascii?Q?Sqp+rZMFmygiHBkQm4BiH7LhUDyxTroqxYSbm+6Jm3Cb6uG26IGz4nSrgRgf?=
 =?us-ascii?Q?lwqjsdMUtgXzY3RNmfZBfk3LGVSRo3tYMwyyLi5Lem4VmkbTVGWwWcOXdE/D?=
 =?us-ascii?Q?Bsj50YLFSyxXTgYt2p6/tp7QTIy+sfANVzlsdR84fZC29ZoJO1/7XR/WYbc0?=
 =?us-ascii?Q?RHoQ0yGcbA72zsnmH8KMMd5M+p7fbvBaLricBCJ0ogCzXb6n48Eo4St4eFoa?=
 =?us-ascii?Q?Cdpo1QNf0qLohKAgtWCUM5WkWjWRi9jU0ixuzHOFGI59NYzFEaYT/6dJSLVl?=
 =?us-ascii?Q?oQRCder3Mwx6Z10VWXE2cA9QDUM+99a9JgT3lFGNqf0wRDiugw6rDerSGbzd?=
 =?us-ascii?Q?cEeouuQPOh42pS41wQo7toKAs6nV4f5LNqTQqpsbDXznG1HSaFx5ylr4Emug?=
 =?us-ascii?Q?oAw8mwUrQ49+m4GwBVsEYfAQrlRqH4fD94RFPZUgmYAJoAY8eqAupALgYfJs?=
 =?us-ascii?Q?A31ScBlG/TWymVqJaJFb9nweV7WxPQCx4N8CmqrLUkDnoCnoSPkCIGV7tzYd?=
 =?us-ascii?Q?lG9T+ud91lo9j/v0/JqiPU8N4dld+bSvbiURgPMMonI6TfXK0b4ar9es42Da?=
 =?us-ascii?Q?sy4NbMZ2iv3BzlEOSj4sMOurwdsD1nLZBHWYbyAEhUtDrql2mnPUhmzx8qpw?=
 =?us-ascii?Q?kxYe6Ow2dkrlBasEvdX1GUU3rHTb3kgp9Fh1BeiTpbZcLs40lzvyrrOqv5OQ?=
 =?us-ascii?Q?vHDLR2rU6ZZfSqqJJL9osOQ5YJ72rmUqilAdXyRBgD6Ww08XIBqjmP8rTXy0?=
 =?us-ascii?Q?rHqOvV592mBRN6F66vVsg0Uow53uLW658lDwNxRDmkG5bkWgYN+4PLRFN3gf?=
 =?us-ascii?Q?k5iRTQT4q4OeVKAPsQOy8Ru29zufD1oU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FLDE/u/MsNXnUgz2mXbDxdHISu2DxtZHwSdCJwnriyWxM9nIpSPY96Vg+5UZ?=
 =?us-ascii?Q?x+JnYMqS2TOBB0TIN092tSUMIRchBkxmA47UjDmeE66X+0DuggxOxJIbNOLe?=
 =?us-ascii?Q?M2FfFE0i2RYo1J5Gv/r7plB2QZf1ZUTDPu9rJ+PxoEcf+FCp9I3a0/rbWy8b?=
 =?us-ascii?Q?omHcAV9r+G57FRetcCkPsoXVeffJC0sx3GbdUXXhizr/PkrqWko9Hgm6JXir?=
 =?us-ascii?Q?HfbNZ0D5mhYbL2CtTi1ebh+p7RBUu6YcGQ4oN8mWUlH8dQZFOz5oo9xgAktO?=
 =?us-ascii?Q?JHfS6GrX3VB+2YgRG67OZ2N3jq0+NoMCGvGa2tmDzze0E8XuJGL/zc/5GaLI?=
 =?us-ascii?Q?L0aLxNfC9xAT7Tmj8kZvSIA7vRe/CNDqcyDgCmKD99hVW8C2mG+FLo0u9WsT?=
 =?us-ascii?Q?Mehq1bpgr8ug5KXtX1tNkVlTfH95fDLES8g5DHxYv+SMy9TSmp5IpAgiComB?=
 =?us-ascii?Q?hS1OvhKSkCgUG/Lls/4TrTj2xmE18zv+qh2rgwBa1UGruW13BgOHKim5qjsx?=
 =?us-ascii?Q?jWEKY5+6tXtbT4nkMjqpc76ry1HhsCUmGph9Tdfmabpmvdj2OoQgyLzwc4Yp?=
 =?us-ascii?Q?d5DnDeEcmUpVcGh8zrr8tXX5gjyK/8L8VU8Av614Y6dHyalP2O5TMTI8vEsa?=
 =?us-ascii?Q?dDMbZsNUFoKjR+G1jlHr/JvFJ4x6nXJoZ+BCd2dvQds836Baq3/x59d9Nfl1?=
 =?us-ascii?Q?y2J4VW0kQRaqbLAj6QRWDK1wgUCYPXfvHt/sOqkH344ARc57br53NrMpKcF6?=
 =?us-ascii?Q?VEvoTA0nKkoklfRnhQkyj7Eg2uGD6JvpVak7XMyOYigrygExxxgxIQnNWXlG?=
 =?us-ascii?Q?j7eYfhR/Oy/6ZsbEmBjguK7k7ol++QmOgoy9UP4lv7TWWlCiwOZW8IL44RHd?=
 =?us-ascii?Q?leLWylNAnZ0RVT5MeZs3rtmOktRzYWwnzzM+ujoUZuz0uMZhwJSkNPY+vJS/?=
 =?us-ascii?Q?DFThDbpigXn/bFQAn6tl5GaAzu6X0qAY7ICmH2f/EHWUS+MeNVoZ4K+MgPSZ?=
 =?us-ascii?Q?fQ+N008Aq3ozVYpxnq3qrk8i6fFayUGeJeQq1cIoK5P0UMtuoCDyW8mxfw1a?=
 =?us-ascii?Q?U/TZbBGouHOuMXe97z+qYHRChJ57uU7QXrW8E3mu0OaGWkU3pBR0gBa/n7+p?=
 =?us-ascii?Q?uyFBa/Egh5RQ/x9irPNM4oOUUL9Fa2rN56K7SABQoXjPnhgVZnuMpGDxsYRg?=
 =?us-ascii?Q?IWCaKkggzH6AAne698bEqXvCyQOEu2DtrTZVLZDnn0XYdzyuVAihIZWy/glC?=
 =?us-ascii?Q?sNpYUNwTbdOU/Ie5IPvU0ghLp18zjqFmJwpH0rFjQGyypNG/mYfenV/4jHjy?=
 =?us-ascii?Q?m72MA4YLWrbLKTzkqIpmt9GOs2ZT2Wz/RwfBrkkifBJ/7b3h6CONFVKwBjwZ?=
 =?us-ascii?Q?NeEsiasOE2PaVKqkw/x1B3Isidj7UWWnnC6hr0DkiK/qz84uXJKR5dPB8HRW?=
 =?us-ascii?Q?yFmhLAIoCv1WPh9yiLLpR4V5L1BjUW7PzDDXpS6p2t7d8+SOWkhVLIBURWl6?=
 =?us-ascii?Q?g/fCZdVSvO6tzobRjAAjHiLy3JtjoXOjWB3x/kBc/LybRl+/k4dmU49fUrvF?=
 =?us-ascii?Q?AQ8Yx2Ejbg0faPi0O0/VFxL9ZRUWJp+1tdLqDo+HtFl3Ln1TNw4gNxdmTTwz?=
 =?us-ascii?Q?6lfgXJzfLlLlH0CPP037K8QdOMnz7uPSi+JeIVybI9AN377Sqye97GSlLy7i?=
 =?us-ascii?Q?kwCGpxh4COAPKK6G/ECgqN+ZEHEBf0TM54EC6DUUb0qJp1p5Zw/BAr1wr3P6?=
 =?us-ascii?Q?X/Dj1qyEWQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T1BpDE54E/j2gRWyJNcc8mWn73DxUPtuNf+iqjHDyEdvDDsEkMdLfmJK+6siXkKnJXa5H1Im6edI3tz+Uy+uatMeQo6gJSpxWvBxe9Kmcjd/dZriIav0iPD8Win3wUbT6RVkRPgIMyQR4I03Ffl99CDVLiFzUOIJuSY/TGNC52pZpKRLYpgqvDO7JavMLRoRkjE/DlwkzZR0epXJ4m/WSrJLb9UYUageK3q6zkizD6xtEI7eiTkS8OeY1CnHn8wpjR8BPFrdQJVkNa4oHhWbGMTwX22wysdx7pv73garP6bTGpm/Pgr851SUaUvklCGNirtaD8LGJM7P9vCiLndxWkR3MTAUwpDZg5nItDR/a0Q9jbctZAXzCBIb08vvFasg+RVHBSH4HKoKDf/tKK9ny6upAFGbMbLYYsuOC/GyFXMlMsBqMPa9gCWg/2JZzKfE5MmzXzD5pibMuui6b1ZnZRZLqypgsZPIuU97/t+DKxmIfsxWGPNVexXqfgdoF9BV5QIhIX8ch6f5Hl1J8QqIBlLsbZpUlJAPsOZaihJjjAwDRYJKca+7DaElAPohtELpaeXu2crIqyhlMmfii/QQx38BGDGwxNw4ni3lxu3j2W8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6df1705-aa2f-43e7-911a-08de4d536bb4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:43:01.8792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bgJ6aJVk/z4WrJucrAD/w2JDYMn/d+VqKTnUlpeWdxtAlIfCRrcaWt+WTyBG75963mjupg0SSdHCY3qc69RFgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060162
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE2MiBTYWx0ZWRfX40wGWPWzeB+L
 bPTZRo74tjpU9qU/8PuD3Mjz6ryiCsIKRhHWZZXkFSXKtfj+bKItDEYARC8q6j18YFWUHOjUfjL
 bRZWUtcnohXW5+qmQoELRlfqk850hE6NwNmJUbuZWd8H1W22j+KVMowfCW+0IDrr3oTBS6qxivQ
 cqX2K66kqtb6rYnnrkFWFvjL7OBBd3UqxhKFk8K3hWwOy2qd+EUpU/MizNUxfLDxHRIPjkdzf5z
 Boccy+8cjMVzlRgmjGYbSHddmBqyXQf1Q6Lz6Z0PIvYcsoP9fGCWfWoNDPNo8WmwzdaLKyVPidn
 gfzWr5dqtl7Przh0EFIURFZaM+0lm+Cx3lWa0yx4AC9QwEsDchVVcvDi6VYfEPjxhf9hnLQcC1w
 vAxWbzNRSjuOlB6AXFMNH21c6WJl8BYjzUD133Dbm3ZzOsHqrNXYQcOpZjqQVoKXrzG1W67Uvz0
 4Vo7Oi773Aj74vn5mjA==
X-Proofpoint-ORIG-GUID: UlLyGrVY0yD0Sr7RXIczJoebsEEg-qwc
X-Authority-Analysis: v=2.4 cv=Zorg6t7G c=1 sm=1 tr=0 ts=695d57b9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=IWF7GtomgDq2LsRr7LgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: UlLyGrVY0yD0Sr7RXIczJoebsEEg-qwc
X-Rspam-User: 
X-Rspamd-Queue-Id: 928B0C0014
X-Rspamd-Server: rspam04
X-Stat-Signature: mxitnibc8qz77kxnhw5q9bnijr9xkyx3
X-HE-Tag: 1767724990-900970
X-HE-Meta: U2FsdGVkX1/RAzGDZt/NlQMc83tcWZnaLYcUA7m5+30BL/r0If/gRVNsXL+q+EHp9vGsSUmKMThp9sCOZyETAVcc3OpgsFa9PNZWFzzIuqe7GJPsU4R/QavqJOduFWIY+x2Xbd9m/37mJ/HlSc+mlQMYJc+QoLmLK1A2szS7s+t4NaoghkNXWAWsNRE/akATRZJQ+jaWFPC8BjL+PifGKJmLG0erxJY2LyWs+7ig4Mvw5OcM6L3nc49vLo0ZMZXwWADs0/g1lPOzQHs3ycVLW1Jr9AuGBApKicTZR8Q47IBx1TEqaCE3R0y237V2kw4ikUgVthNjqszILgNaXW3jemlyKTVflOyZnjUBMrLK9sSm8/dIUPbWXd/f3vxucnMseDjvgNemDGbaTyUt1u+ehD2VTmdYJNgB+wUZ1fr8+bNGO/nz4OYvdWZsdg1AJMKGDnruo3OKBeulVDaBdnQ3ChdUEmeck9tbh+EAkv4N6fEIt3ulkMA9A3y/y56KPG7ir7gQ5ApcLnT2RXQfwmTEnY3WqcGaCjH58SbYkBpuWee7x0w6UbIILpVrx9yKTeYsx2/3fC/7OCWoH/4tyKQc5gAS8hPso3nba+MBZ+tqHHGJiQdjRN5yt8WjCtiX4TWXCB5vxL6BHh5xxjKnlf8HjKYVT/ZnMTooWdXZjf4m072VMMpl2vxB7r9a+Gvz8dh01AvECEym1jO40oWI2IT/gv0sYG9s7J64Qdwv/B8XJZ65PmjwE/zX06uNTNPadodKZIwa0gcudRxsu4wDC3cqnP8K4jNIN+oEKP4euKXkwDmmlDLaf92S9cc+edRLvbwc0I7/R2sGTvXYapX02A54X0qjZLnPYzNZemBWSw3dHLQwVGCXVPgT7dqcCXPnZdePcZO8pYJ9Rk6Q7i9Wwc+zNVD2SrECKp8aLIPsVe5VEz9KL36NUVxyuz/uvnBcw4If2wDlSdPQE55JgDXmEUu
 DlVs65C2
 F6s9u9hWz+ENPETw+RgxUh9pxJPee2WmDOkSK5YV/ep5CTLAUVyDTbwf4q3aSta1toxfXHWR3RydLbsVviamTm2LT8ldf5WqonOPmLDZDMzoPRKObYuT+tUhrqtYDnx/8vKTHvreo1Bgl28UN8yfJ+7Ld+39Q5O2swicUudwWebUgwAv9pmdbiYZThbFR4sfmQIquRsNb2c0N23QgXajeAE821wwduSaOBctwULlgjv5Uocvv7FCNLOtZ80ZBOt6FytztgLH+wmEJPhV6sIyqbVPnRpBQP45uc7TRfVoTbBjD+LxJJXvqg7kVB6Tt8+LNc1rL4JpRBVuAZszpTTyCBRz+V4QOmh923Db5NU2GUD2IvTxvxmPyPSGNdFUCDBIvEoD19Bvud0FyvODSdMMr38JSSyFT6hwC06EHEscKT/irmfoy0T4NMAtZrmR8vSbyW6nGZMtZmVG2wCLxCPcVw9C6Q0ERR++EpdcS+lFhf45+Uum2OUpH9ZXz4am/PUOoyGQzzGemMBZoebEI7bC7ZEQuTxWWc8IL+7Dy/NShGeKWqsgBhnX+ckI7EhPBBpQkPmCUSvlmGwgH3CCQZez1+PZKdbLXK9uHDUW+gC2RkjYYP+NLF42NWdk2qMAXVoX/f9Li7HpFPf7TsQCPEmSvRi8nxwc27d7OoGofmC+N4cek1KTWBQvvI8x/cTu4A4jUcHmycC24jDqdWbBU67ns6RFzoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:04]:
> This function is confusing, we already have the concept of anon_vma merge
> to adjacent VMA's anon_vma's to increase probability of anon_vma
> compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
> as well as anon_vma reuse, along side the usual VMA merge logic.
> 
> We can remove the anon_vma check as it is redundant - a merge would not
> have been permitted with removal if the anon_vma's were not the same (and
> in the case of an unfaulted/faulted merge, we would have already set the
> unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).
> 
> Avoid overloading this term when we're very simply unlinking anon_vma state
> from a removed VMA upon merge.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/rmap.h             | 7 -------
>  mm/vma.c                         | 2 +-
>  tools/testing/vma/vma_internal.h | 5 -----
>  3 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d..832bfc0ccfc6 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -165,13 +165,6 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
>  	return __anon_vma_prepare(vma);
>  }
>  
> -static inline void anon_vma_merge(struct vm_area_struct *vma,
> -				  struct vm_area_struct *next)
> -{
> -	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
> -	unlink_anon_vmas(next);
> -}
> -
>  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
>  
>  #ifdef CONFIG_MM_ID
> diff --git a/mm/vma.c b/mm/vma.c
> index fb45a6be7417..4294ecdc23a5 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -379,7 +379,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
>  			fput(vp->file);
>  		}
>  		if (vp->remove->anon_vma)
> -			anon_vma_merge(vp->vma, vp->remove);
> +			unlink_anon_vmas(vp->remove);
>  		mm->map_count--;
>  		mpol_put(vma_policy(vp->remove));
>  		if (!vp->remove2)
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index 9f0a9f5ed0fe..93e5792306d9 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -1265,11 +1265,6 @@ static inline void i_mmap_unlock_write(struct address_space *mapping)
>  {
>  }
>  
> -static inline void anon_vma_merge(struct vm_area_struct *vma,
> -				  struct vm_area_struct *next)
> -{
> -}
> -
>  static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
>  					 unsigned long start,
>  					 unsigned long end,
> -- 
> 2.52.0
> 

