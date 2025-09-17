Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93894CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D8C8E0062; Wed, 17 Sep 2025 12:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D7A8E0002; Wed, 17 Sep 2025 12:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC75B8E0062; Wed, 17 Sep 2025 12:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B41A28E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:53:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47EEE1405BA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:53:49 +0000 (UTC)
X-FDA: 83899338978.03.9E2A636
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id D07ED100002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:53:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gC3oeKC2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CIUImEpD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758128026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5Dqrrfpp4CxD6gZn1qeSUNFWiX/m2XAuFhxtoHVwmo=;
	b=LSjkZ0mMFv+jqtEgSKaRL5G+jUIA1Hg3bUNlDTsznF509+FP3AOQQjEz9NP5MZ6tE1l1/T
	GenIR9VgAGjg1HBPc3hp2jFRiQvP/abEz1Z1MFCOoiK3gBZbuDreWixuXbc4XI64GlCKvM
	v/8xhAtmTFR3xLYPpedX/TiIWxOFzok=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758128026; a=rsa-sha256;
	cv=pass;
	b=2xfXM7LGPxxTjO7ftS0ZgGPrzlm3rT5h+KmkO8Okh2Wdj0D3w0ayT+GHlbkan1GGuT88A8
	s+vflwkimRKFcUOvgSrdPdoVr5qIuvTBLB5JNiC1Iupiwwd74uSl6kjEGVP75CwM7e2GMo
	GIAh5bu6CJJW8XzomqYYE2673APCjfg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gC3oeKC2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CIUImEpD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIRIw001799;
	Wed, 17 Sep 2025 16:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=t5Dqrrfpp4CxD6gZn1
	qeSUNFWiX/m2XAuFhxtoHVwmo=; b=gC3oeKC2e1PJLQvVoKAnkwR1XlBgTt7v+h
	1pp9ORvvqC7QA+rUAE0wlqm5aW/kwQxMyDUbKPYQlWjLnUIPUSjO7KqHjehcDrx5
	ZSGyzOY4JX/V1CviOnlh/CL1+yTUmhKqJlpghjHyjM9DOCyMrsHTWe61IYrA3TO+
	ag2Kgw7YTNURk4p6rO7BrYrFIOxTWaE0Fm0/E7P7OsybCFOjKOq66AnCyTeY1S+L
	cxb/VTBr4Ksho2fxRx5rOPE/nyXHEiI9uTDn89rzNkKbY+ZAzK453UeSpywD+8hA
	aOCK0ZwoiK6h1HyJM4ulAlDIz9b7SWGoI/ZK9tum5sr9FQ6GkteQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxd1qjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 16:53:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HFGOhx033752;
	Wed, 17 Sep 2025 16:53:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011041.outbound.protection.outlook.com [40.107.208.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2e0mwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 16:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfvU7g453pdeQRAmhGiL4jTykUVEfBaEGePh8qjQWcZRAfMYxbjzZGk2kOT2/6pTyVQ2/1nci5xoiZIk7sG6qKkYqFAZfzOOR/pZjrRz8A/d1OAu5FzquQuwl3SiFFuOMfiFRJLoJXjneoAeujiOvTWa8MkrER2JJjvqKYXTxW0pz8ReNLl33CACQ1unTiKjDFpDuEEd4X/aXgMeXGSFpXNBoZ1NvJWEq8E9Fxk93Udd+515FrznH01L7sIQIAurZvtvxiKtcldblarSJohasOrwNEcf5zb+yVn/hpgpnx3idOL93UD4HIeBwogfPPdyCX6382E3xKgXIXJBDpeY7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5Dqrrfpp4CxD6gZn1qeSUNFWiX/m2XAuFhxtoHVwmo=;
 b=BGUrfSDuYyPNgyA9BAf0SwVaN/rX49mYtqDaW7DMKPxd+EeabsLYmJygPZ8NrihC1BvOI1Mu888t/1DDMRBZr5doB4AJXpGZCmETBNTSdD26lDsDq7Xx5RIJBFetlI9oyNKGiS06NBp32mRZTR3yNT9a1dV/bjbFk+BUp3HCz8nn8o/h7AugcfxiSmhPZFj3qXtkobCjd4++GXvXE4FeDxsHH5Q/gWbxlYsdf3pZsQ/9QKi4KWCARrk+NZh2dOuSw9/NthAXI7D2owgf4UiT5hweDUznG83UGf1DUOx7PDX0NBjb6Eruk7P9KIamO6E82Ycw1xChtqLjrR/i2bw/HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5Dqrrfpp4CxD6gZn1qeSUNFWiX/m2XAuFhxtoHVwmo=;
 b=CIUImEpDdZ144dCb8wOnUthw4Nuap3F4lKzrtXtRzDHDmFBR7y7q+DC0a81AjecOKiX97xJEFphP6dPcgelNyBrSkZBKbt6VrB6LocdJujQU2V1lsji0xq9heSZvgVtGxdjwfO9XhQjafC9kFkOQbX8zzcTPhAzmmmxlU155Y6k=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH0PR10MB4908.namprd10.prod.outlook.com (2603:10b6:610:cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 16:53:09 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 16:53:09 +0000
Date: Wed, 17 Sep 2025 12:53:05 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Nikita Kalyazin <kalyazin@amazon.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>
References: <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMp-kW3OLqtZs8sh@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0020.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH0PR10MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 30db4913-8cff-4238-bc29-08ddf60aae20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Wi8z+vjAXVjDoRIgLlT0LFSvt2ANCphpytGCSXd4202Yq2+g0rUO6opGtwD?=
 =?us-ascii?Q?4HBdro1fOmM/cF1VJM9sC1Aj+A1pcTZ6NzzY9gJL+90bgADK2BHbpQseFXZH?=
 =?us-ascii?Q?j52oTE5PvnNim8IapVm8euF87BIahN0JAAofovCC+/T6guurj9I0HFEhkDW4?=
 =?us-ascii?Q?7H3gLVoEOo3PmUAzMVcndnMC+1/0kx8lQey1h0KqF4ieD24eDuE/NN3FhD+K?=
 =?us-ascii?Q?fhGonynmjn4V4uJpwuCYu64izcvrnua+R1e1MjZze4z+OQ0dBg0UDSjvXaxn?=
 =?us-ascii?Q?vjfizOSq573/j1h5dJp4NsqmYg8yZL+ePd1fETXkoueQ+rMcHt3wLEeGOkyn?=
 =?us-ascii?Q?J2EQVqzoUlFDtN9bzVMZc992OfnBHT3aA8d04q/LU4dvS2ZFiWefEle9OoTI?=
 =?us-ascii?Q?G+lHmbe0IrPG/NCBOJd7XjdP3qFLAijiuLKo1nX+8Q4u+ktBOQZ17vTm8Q0k?=
 =?us-ascii?Q?6Q6H3R0ncxO1xTg0nE6abU1iJTst0yeWoMMSCXnixZVUgXq7FriCBN/LOZw1?=
 =?us-ascii?Q?A6WIaWlyFdcvj9DlbYON1WiFq+M3DMY/PfeUqnoHbilOjRAyiDldUWXCwgoq?=
 =?us-ascii?Q?i7BjYH12IsX3SEFQ+TwaB8YDvUIV/m+V1ucGLJnXmFDAm2Vo7RYQpmSkZY8q?=
 =?us-ascii?Q?O19z9GuSE1Qov0641tEHWddmmGHENbx8tWpgPaJQZ82tYx2+LfV2CH2/lSM2?=
 =?us-ascii?Q?71EfxWn66w4Sr0aqmNZstmMB7wLhTS6LX7jqJEzR5aRwyZ2t/mkdkseMi8EE?=
 =?us-ascii?Q?w05REiKPxyA5uZLESkmPaxDAdRl6nr+5X5tCLmGm8Qmhj/4TOJ0eXiiJ5LdH?=
 =?us-ascii?Q?ynUBHNO/JjopLa+v0SdX2Kk2ezzLlBMRd46lz1ozClIhqgVz3pwp77caF2F5?=
 =?us-ascii?Q?xnJTxb68Ge2cVU0897NOXjBlW6i3rC+KQpOl36CYjqws1EhGMwqhpkraghLm?=
 =?us-ascii?Q?a+MDAbqaM59xsUeig4NL+RKnHvVhZ5mEEWducuuz2p5If2MI8KWuR4J9JGrn?=
 =?us-ascii?Q?Ea5wht3+bMgYKgXQOMUxT1lLFYAEqOsB5gZ7vPkF8+2dodrwS8KnN/YxM2j6?=
 =?us-ascii?Q?1lhdEp36+YuJh0IHG+RKwo6CzbHrMEVSao8+9Kw3kocaa3WnqLdGtsPg8FZr?=
 =?us-ascii?Q?blxBdjc67ij3bMwkn3JoNcnfTDNG4xKMV3MlL0PIUKnZuBAC9rSIZz0/FNiJ?=
 =?us-ascii?Q?UHmMgPFX11F8ASwoVlg4Rw0K3vpL878uy9NDO6GRi6x9MkINqNnrGH2a19bv?=
 =?us-ascii?Q?wbuHyjyYGiiaWsyLaQc8Wx39CXKwtw9cyc0g3tjDQjAg+m9A4zFs1ZQ+le9a?=
 =?us-ascii?Q?yKaYoJFuLJEalFo5TJpiqybdhSXOjwc3cr+hi4GC7rVLQmkOSPjWhmDhJG5G?=
 =?us-ascii?Q?dma3CN26laD4w+Kt5fegSoE7ofXkJehFQKPY5GXcML4RBlJYcXN7ow6qdDIq?=
 =?us-ascii?Q?R+KfiTVGM8ct85lLjK525EayEL7kvpCrR3JGf9msQUEUNz9ZmCamFg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0ZjLScxmwyYu8guPzIESEnsb1xCYeQChDJR2VbhUL0DpuX17yHpsfIyOyC0G?=
 =?us-ascii?Q?/S2cGz56dRavZlDcuq7hLjKr6MzfI+VQ3sWADRBKMEDNcvR0spU+9JR3IRcZ?=
 =?us-ascii?Q?kKksL5yQVMc89IWvqK65H3uGUxrSv/aKFeDT5+f98p3I1QP92Dc77v8V4snU?=
 =?us-ascii?Q?wpwXOW2Mzlelq5crt2XKXYHOS+7fDgp/P3p8ToPDE0wzYyy65ajg/iAYhXD1?=
 =?us-ascii?Q?zAbcj3EgpMTVdrJKjWWuYTMx8zO7Yvjv62GOUnVYYofGVStkaNuqG5aKdeSM?=
 =?us-ascii?Q?RqIe8aj4S+Y4tVRsDGHQrX+pl0auiWRNadL61HDdH6mqAl8B19dM5ColXD7i?=
 =?us-ascii?Q?HtToOGZ9zqdfS/yk/NknhvW2g1E9jeZg6oy1LiqDR0Zzb3o2PeNDoRTi3cyu?=
 =?us-ascii?Q?VFjS8+cM0qGPSUIhrlFPZT7uObS4HjbRMD6OzW8NyGcX07ickwNlM89vEQXQ?=
 =?us-ascii?Q?YLy4PvZid5W2OHW8rujOq1ja/BlEZSgK9FCVp1MyXRNAW+8eJYySAscf/dBi?=
 =?us-ascii?Q?nchTYphg9hdbRmNXd7xWFWYW81AYXhPhKUbWc+mrn1zNyTpYB1CcHxioZLSs?=
 =?us-ascii?Q?uTfuXHE3j1kzapRb2EO3JAAWQCnDaCT/rT4gPlBD+0zTtSis7i4OP9QrhCgU?=
 =?us-ascii?Q?ONt61Ov4JDSTmgjk3zqgyFJb+J82AqAxeluI4s89Ue2dD/ACVJ4oWsmZVawX?=
 =?us-ascii?Q?MHe0UWA+J5klHD6t08RLioih5z63zIz56FaGDjvpSEZU7Rp5Dyckyr9fQ+Zw?=
 =?us-ascii?Q?l2c/LQ6dRtf7+HowjMkllqdHbO2KofVbpOaqPuozZVxg2VJWVlibUVZxAIvs?=
 =?us-ascii?Q?uS3mjidoaB8suvF24W2iXYBiWu5OFr6JojgcFi990OhvY6J0yQgmAnOXVVLA?=
 =?us-ascii?Q?QYBl8mxbmcwSfiJljbzhtO35bwVFVNUdv2UZ/ANxyllFReB57jQMhtngCxV+?=
 =?us-ascii?Q?2P+xHf9usDutV8fEI3BGk9TV8TxCeKeTNP0MY/WGRRkp55sXCqEH5/rRgLKW?=
 =?us-ascii?Q?gUwJt/17mwTDYjF6XH/u4N1zvVeMGm+DcRQFN+pYk5xauLWjc3iqpAAsE614?=
 =?us-ascii?Q?k5Gk52hgamYDk41eF0Q/ici9wrS4ktzNaH6K61lTyLfDN2vBJBHyKst3zn2D?=
 =?us-ascii?Q?+TXfHdVP2OQVXHH9nMqqg3c4eW6Ti6m5Xt1wyue2hDci2gyBgR9EyZeHZjSM?=
 =?us-ascii?Q?JhBt/kLHLDFKAcLScOOOiWfwSDnYDPy92kC3xFAe9DRoaqU4ihVcqIs2sfeR?=
 =?us-ascii?Q?XWlziqAjLl/y+vyy0e3wd86NN/O7xUBsDwgDICsxjbIAaae7qjcmZKtTLUKz?=
 =?us-ascii?Q?W3RNBU6FPzAEBpVd1EcLG9w1+VmxpJpxklbWHqd6qh8PyOi1okmUtoEnr6/g?=
 =?us-ascii?Q?1Bgx+4RFDB3cwhPiqoQv4BDToshwtFIEoFiKd6QhOW0LF6ciMQQ9E4qjzyOE?=
 =?us-ascii?Q?Z0dJPe2ADigAXr2nZMU8EzS2fpNE2XQAXbZt4cFSs+dBC5mqjAH+9ed5Iuql?=
 =?us-ascii?Q?5bOWyhneMo7bps4ZT9KFG8V/dP5vFgmS0pqW+q9n6qyL6YIzrBOTIfXdzRm1?=
 =?us-ascii?Q?7ubSwLA63sBrPPH7d4gV2yk233sgSTAQIzj7WNho?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xnt5WOQQOuCVZEF3jWZWQikpBXtJIOwIIuDnkgX95+kq0wWxZVRyuojw/qDC2VDqjVBHxTqinyr9ZI2OFS3pgxA+InMYT3qO8cVj66sWeFCrgj5Zl6WYvVNLApY0gFDTDLL+h6ud3+icnnpk2DF8KWH9F8PGREgPfBRFAcfWZeBmVnhKouhmA6OzgJGZOovzqceBSG4BmDt7FF3EWsO4Pg5hGBn0h0SP4FUyGGndcx+9/Km+eP7TAR9uyVBwoyChNu+Scan+2iF03aZju3gG2MLnGCqys5Po9T6kcwZC4ZJWzPzvqNEjzp7raNEZD7TCeVA+bLDvvxqccp3anxQtk8/DJHWS/L7Zh6LUu2RIWrbRpPl4tTsDn68RVtL6s1/pQFtCb0b0s1CX4x9rT4Rr1EnS5EJDOM9QxnE9tUhd+MM4QjdEOsxHjwFfhjTuZyv3rgr71Sl4I7YldZng1k1iswk/h11Kj59drygJTK8g0IVrsW03TmXa29pxrqsvkI9/YXtKvf2rsNbGrdLMo5bNeKzdpIaY3ZglhQMILUnC0esfglbtQErMYOYWtP5kCQd0zifi3m3jtZDCdMPqmtJbTNeypx3OEpE3gYCivWniTn8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30db4913-8cff-4238-bc29-08ddf60aae20
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 16:53:09.0099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxBJI0OWkJpfjYbtXT9gFkx9SNEiIo6Vw38d+qGSYR61Pyj4GMido5JJpCx4FN+BvfgLu6Ofi02fO2qTlJEn0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4908
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170165
X-Proofpoint-GUID: BL_mKsKvOk0bou0LESC_RFfU7CMxYt5S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX0uaQMbe93ou6
 9RhSwjrwNmoNHofnU9skCytG786U9bYEHLxCUKbi3ViGs2DMehGi+msFdGqQpavkcDLZ/X0qGCV
 Rv9vZylmjdbH1WmpyW5c3ay3pWbcldD5oCo6udRN8dcu8Y2BnkemknGEi3gwqHMWCxfL7iwwojg
 sPDK8RKkFLXFWy3Q6lZ7Vrsv6I3B6bLgF2LSqETPgZ7j+TpT3az/aduiSc39QNHov88dQUtqvCN
 GdUfjDa8pB7dJu8yGsqVlPb52teqVRv4qhz4F61QksWJV7hgyl5znIow/tJN79acT7Pm30ATTGz
 j+DAmDEgmJYmgZH7Jk93/IAfa3fdiJykYosrcp46g1Ej2DSlMdvrncbKHe/5NlVmN+mnoAP1OlI
 +t0vFDCk
X-Authority-Analysis: v=2.4 cv=cerSrmDM c=1 sm=1 tr=0 ts=68cae793 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=TKSv2Z_wpWjDpFy834sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: BL_mKsKvOk0bou0LESC_RFfU7CMxYt5S
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D07ED100002
X-Stat-Signature: ojx433z7knhujtzk63buk1d8d49afppo
X-Rspam-User: 
X-HE-Tag: 1758128025-481697
X-HE-Meta: U2FsdGVkX18hNVyk7L5TG9sMC0cQca+XO+AOFFblUZOK3kzIF04VIh3oOZF/MvlLzPLVF4p0+D7vDEBgd6b3AXbypVGOAQS9ExzGLTeQlysgY8RlaEIwPz7gEhypLVPnz8g/vN8hrGsr8n9NchiGCQ7HY7F8q+I0skBfYDR6TNILF3GWdYR31UEgs36cwyNeOD5SHijKXWk6oKjQQYYv/pvli+O3LNOnwPFZX44YVJlReWwleq+NXpKvqG5t64WYbvr9OgvmqkHkj53qGWJLMcyMnbIYU7XRZCjrrd8as01iyB4ohpHD/MfUW5CICtpnEb3REHyKmDVfSIAALwZZGunR9m+oOcXWbFAC/bQPsguyahkK8zdZzYr9ZByk3VS+M3yITSJLWW5K1qAumynz2dAlrcFyyjyCHdydQIJO6PKhYVjlpfdLSL1iHaS6NWmfWWMzugV9AXi2o6R9frbX9Nm+FSpdh2HqveRpXn6c5wXESakUOtQyzWOGnxD4uts6xix5FqMBXsE4BcsZfA6V++UK+NyD87i8K3l2LxAKzH53BFWyVqKaOTmgXwK7eqjzwHs0xuh55LhmPnTlTa4OlqPExPq6gEcFKjYoeOPvRK7ZcrBtY9ShfMU9gSLb5R+7CKFay1OURFyOIkD3gZh5fWppCGTPC/CtlKBVBd2vV9mBX/q/6PpCZj/R+ZQQv07qdZJcF/IV/X3HFaiHBfjIpiAf751RQJ+3X/RajS8rnpsSAIEx0b2GJCOJ1GW/PiLv7U3DcRRe/pvt1jpNC377+4ReV+0nOttEjO3E7qzeCdyY2YV+8twuexQxHJzu3ewH32AOWznzXdy21IdRYTnD5wNm41QboRhztkqjVdnbdSmXDMJFzXcmI14yPEbEw3pLOMX/jsbsv4BiSs/2wA1cHQrsm+yl4bnOMMfRAKx+FjLX6TuitHJEX/M3MmmT7UvgloF+WJmW0sw/+DSz8BP
 IZSMRzs7
 NyFeVmpfTqvvVkgD812u7qauVkKEbkP1nMA9oeo2PwHsdTEq915TLJAuRthiO0+7KMaU3fuzDp9rIgs7ALwRArIn0vshQw6HpAu5syazg34hRk7cvK/XjD4zYepCzNTeZ3zdFF6EZlm5yu614vTh5e1HAWuspDRqpykBTcRWvXL8iv5GOMPVggJfP/xCEmoe8e4/KNA/q0BI1nOM+NVmwxj0MO7zwXQx4utwP9QdXt+MraflS5ad+63eIZlApmP1LXHIEAzKZd5JmFVRNu/bLlcQf53hGtnFaNjYAUVc9gdqu9BmEKtblZlZVO8hL6ZzxtAqP3Zt8O0Sd1XvTuod43dXngVaavPVPB2DPDqSBLiKlnUCVz9GuTq1vkQHCYFyTuhvwwzVX+gifmDrGZ/LGQEQHKXXv7WwY0Ff2/vTJ75nAP/Xc+CEJsX9j+yB/oW5Q57yfehHiPjVQK6PlcPMHVEz5q4AZR3yncI3hA+E/fjGTorXAECmUDnLUylym6BA2GSBlr1M0XDEJFEhPkk/XCj6wmlWqq/d0+zvmHhVZHAA1gPw79s10CEqqFS9Rbj+zkYJ42P7bAojYlw9M5hqX7BaTu8uM1Yx7EKWnQt/73vtbaXYDQ+gHkljdQhG5LlKXf0IYsRCNOMSq/om5AHnERmTvKVC1Y8376PuGZ3A/aKu3jxaKNX59m4Hial8ble3cIwGarRgA1WlTBPEI6Dbwe/swPYBioYzBbDKF1Psfo1a236qvTCPBNQiWeO1j8p7NdNDvgEwp8Q0f+RbEiB2Cc9ojrPrLTaY5fV16cC8LBByfAeqQW2wfiS63h+5Ks5VStrNIMtzDAWv1oQxlU2oGJPizPgc/9SJ1ZvBvb6y8PZK9YwYVik/R8JI5YDNd93UyqtZK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mike Rapoport <rppt@kernel.org> [250917 05:26]:
> Hi Liam,
> 
> On Mon, Sep 08, 2025 at 12:53:37PM -0400, Liam R. Howlett wrote:
> > 
> > Reading through the patches, I'm not entirely sure what you are
> > proposing.
> > 
> > What I was hoping to see by a generalization of the memory types is a
> > much simpler shared code base until the code hit memory type specific
> > areas where a function pointer could be used to keep things from getting
> > complicated (or, I guess a switch statement..).
> > 
> > What we don't want is non-mm code specifying values for the function
> > pointer and doing what they want, or a function pointer that returns a
> > core mm resource (in the old example this was a vma, here it is a
> > folio).
> > 
> > From this patch set:
> > +        * Return: zero if succeeded, negative for errors.
> > +        */
> > +       int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
> > +                             struct folio **folio);
> > 
> > This is one of the contention points in the current scenario as the
> > folio would be returned.
> 
> I don't see a problem with it. It's not any different from
> vma_ops->fault(): a callback for a filesystem to get a folio that will be
> mapped afterwards by the mm code.
> 

I disagree, the filesystem vma_ops->fault() is not a config option like
this one.  So we are on a path to enable uffd by default, and it really
needs work beyond this series.  Setting up a list head and passing in
through every call stack is far from idea.

I also think the filesystem model is not one we want to duplicate in mm
for memory types - think of the test issues we have now and then have a
look at the xfstests support of filesystems [1].

So we are on a path of less test coverage, and more code that is
actually about mm that is outside of mm.  So, is there another way?

Cheers,
Liam

[1]. https://github.com/kdave/xfstests/blob/master/README#L37


