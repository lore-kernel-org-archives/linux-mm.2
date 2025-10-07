Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D60CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2E68E0008; Tue,  7 Oct 2025 12:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A768E0003; Tue,  7 Oct 2025 12:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942A48E0008; Tue,  7 Oct 2025 12:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 805318E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:04:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C053F11935A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:03:59 +0000 (UTC)
X-FDA: 83971789398.03.6D973DE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4C50D1C000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:03:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C1MfuDqy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e4Uzc9du;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759853036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0/S9g5HFThouDIsDvEUCVu/6WtMsNuSUaop3dC9khw=;
	b=kBuX4MH9GgSSHO2t5mM9AvLShCFyCMnMS6PD9fgTmkmrt7sYAclUpHZMcruKhllhZFE13/
	qAlJcjUUcdIpWfeNyT0wATzJwOzsEaSCJFChy0ZDp1YrwqbTcV/bukXX7XrvSTwUhZrqDM
	FPtj5Qt8fXAK8oJ0W/08rGaHkaFfmxc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759853036; a=rsa-sha256;
	cv=pass;
	b=eWvCiiY4dA3jbMrCyWwEAsvhVagk14zendDcANe2OivM0UymYVEKC6+AepJX9WS9T2453P
	dOXZzrI+mZiBVr6voL9WTYdkd9sSWgq495TTqCoidGvONyrsowqtXLs5hpU3djRrpPHoje
	yOIpOxONShMXQwIOL+cYksxAYnWGoK8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C1MfuDqy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e4Uzc9du;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 597FsYnQ025181;
	Tue, 7 Oct 2025 16:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l0/S9g5HFThouDIsDv
	EUCVu/6WtMsNuSUaop3dC9khw=; b=C1MfuDqy8P/lRZ2cSBXh2k9AlCl7c4KI/F
	ec2wRqF4VDGfYwsZev67KOg1Uw+uN8v6hdxAiPJScyw5EFv4FAi5WxBwFH1RR9x9
	rozXczcqetGdAAJTNwqRFaQfs1lgnemqevurD6IrXDzJdpu2lBosqjbQMZeBd/If
	HbiL1QhjD60JjUQpnsOKIZzXv4TBmdEdoQNiMXiLvaIxcZrJFoWaCnUNvyA4erMB
	mpCyDpGNWiuAt5vZWqmAESrD85FKpQWEcXQmhbeLeSfZOw8bzyFcyJfZ192Yd9Ex
	QNLvkEwdMUgGU+spSZtOTcVRbkEuiqdw1eqraDtVSY+ssvsiWsig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49n5wqr0kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 16:03:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 597G0Cuo028727;
	Tue, 7 Oct 2025 16:03:45 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt18dw33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 16:03:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ATtf3so4jTD/OSzBzfC5RRSjM/uHC78zRSCu4NZt6f+Bv792w+5Z9hHDOaBXXx31lor5HpPX40sUbkGlLEsjSjRRjmiFgjZuV8qjZJz36vnm+ArtFMVfxLlFOg96120yIg33XmkFmored4nk/EyEJQBhfdyKCOeVpY65xglqwtUg6lpGH3uLS5p7ggAx6QwWQEIZpHV9IQ3RRbBfe5QIYmQjYXRscGHQYazu1hL0gSwY3q1+5P7NN2VFOp0yxEMQdNTP6//NIn2e3ZcbMSA6WQvOyQFIG/2Ed4DoPxyJxR3zs58SOCEq6yJ7lHfBYpawHvPctUvuUKuBuBYVq7ji2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0/S9g5HFThouDIsDvEUCVu/6WtMsNuSUaop3dC9khw=;
 b=sqA2IMy68yNIdyXfXqrUS3mj3TFcTy0T8eEk+2/0Hkbt/Pioi/ECXWuQkK/kxHqckIhSfirmS+XmYZLb7mQg/CATpT0MC9bpQIDJhrBXC79xOR9NJk7nJyRyaNXSfwE0Ud+QZtSiL7o0DqQPdqfQ18OHL64wBWOdE9u48IExA4oAPJFeELfIu7OwpjvnjlSs9f6wLMSPpl7GLNLdYFZi9LL/g4XwWecL+Ceb0HIwZhxztRLHTE96VWdqF4WzZMtvFrWBg4V0ufCGcrdQuQSX31ZQbcczWWNK2otYNesveuniDaApfBZ+fIfaxA+StbAS17pO2MvkRKKgrKXdq3bYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0/S9g5HFThouDIsDvEUCVu/6WtMsNuSUaop3dC9khw=;
 b=e4Uzc9dupRQxM0fMDqI6Qi5vR//VTnShWjWRysN3jcOUNgiYK+Pj6Ne4gr1NEFeUHhFFKJVKXgppLOjjuTwaLdc+fJosFeO4FSbrr+5aQdqzwbtwjYUm+vOPzYAD95H9biXiByuF5FM/rYPwdnytzt5IB5jhKl9LgG++7M9te+k=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH2PR10MB4231.namprd10.prod.outlook.com (2603:10b6:610:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 16:03:41 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 16:03:41 +0000
Date: Tue, 7 Oct 2025 12:03:37 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        James Houghton <jthoughton@google.com>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Axel Rasmussen <axelrasmussen@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, James Houghton <jthoughton@google.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>, 
	Suren Baghdasaryan <surenb@google.com>
References: <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
 <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
 <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOUa8C8bhWvo5TbV@x1.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0052.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH2PR10MB4231:EE_
X-MS-Office365-Filtering-Correlation-Id: f4ddc0ab-a532-4fc1-6b17-08de05bb1587
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rr6gkXI0DhPEiYJQ1KwUsW/ldOMLBH1cCRocnG01cmMDA40kra/H9K19dzg/?=
 =?us-ascii?Q?UO14+9Oujnz7QPi5tdE12WIK+4cb6MmijpJQV49kU/C0JkBkXxsJGCa+JdcV?=
 =?us-ascii?Q?O4g39tCqUbHYiKI/KGct0risAibMO7/zgIzopqFElsOpedr+3RP8Q0yZocLQ?=
 =?us-ascii?Q?ilfrR0fAZ2OF6NAL5IirBkJFx1DNna41NPP98WMExeHr38d+fk3LPRoqjx79?=
 =?us-ascii?Q?ioTQbHln9ocRX8ByKneEa9j2RK5RV2BlizjfXq9zPAp3W6BgqsoQG2c0sX6Y?=
 =?us-ascii?Q?7dMygFjc3INm9XOx80E4ekxwcTLvBRVe5JgX/IQuLYPrjgFr5yR/teTD4Bhl?=
 =?us-ascii?Q?Mr0TN+rb2Oy4mI4l2H23V6IRsgvWUM0157pAK/OTwexWNHzPN9WTunRvo3li?=
 =?us-ascii?Q?vM6Ro3p0iiupoorqnLJmS/PjTb3D0n2FF2Y6weqVC/gVsx9FaMU6aTahpoK/?=
 =?us-ascii?Q?CaTkT7bUFFhQP4xVwT6lHq9sCJ3Hb4BvEA8YzV8WpX+ZjEaqnMvabz1nqTtz?=
 =?us-ascii?Q?yFf15Q3cwYCe3cDdf8UzG/kyD1OYT0FPARBs2iUARrr7qu+rVpqTJhfTAANC?=
 =?us-ascii?Q?W6ajXwbBPpaVtxQHDVXCo1AYZjqmYBaLVWfnYN4r3KbzsYAv0cM6rsfPsYnc?=
 =?us-ascii?Q?lSjr5o0CZPe8Qgef7i6HejDJAPNJ97vprw0Lf6uFE5WrNzSdb9NBnjm7bj2t?=
 =?us-ascii?Q?/fUOzRur9L+G6LeY86K2H+XYCgSALECOCI1tqILwdskwDswzKXszWQToFche?=
 =?us-ascii?Q?O264AJjjL7lnpkOrMigaJrdX1tIMv1om4HFmDfn2PeFRxjUYDBLhM3qOJjwX?=
 =?us-ascii?Q?eoIZv51vd+voAmdOGz3jMbb3sIq72DvXKnE1ZK7aVo38vs3o2gD2/dEKxsGh?=
 =?us-ascii?Q?wdTO+vW3kqJjQx3QRKOvT8IXAxFVhpCTSblWnWqg0o+wqzuf/H1cl7OqiD+y?=
 =?us-ascii?Q?m4THRxht2NxwgrQAGfEhbS139W0PzDQWDIs7F35YDdeF/PeFIVgtksqDu3B+?=
 =?us-ascii?Q?9T6hcUJaiyIZR38gOngCzuxtJSyzUmuQ4udfDkWNIQ93MlOBTP9fVH2DS0rE?=
 =?us-ascii?Q?brLYQn/A2NnxzYv8Dye4MtJSzZNZLK5ck+7VCeTmqWlXs6EcVQOE8gj+KFuA?=
 =?us-ascii?Q?XDm4nv7tg0VOb7M1aXU3uLaILpiNY1W4OIfqg0iaUUNyLZUc58H/Rr8zcjQ6?=
 =?us-ascii?Q?mXwLmaS/ECQ5ccE9nNnOJdEGROLOSPwzKFUee053Roel/jIuHcobX7lMNxPC?=
 =?us-ascii?Q?8jadxwvEDka3CFvShHCZwG7GJr5egu9Dt4b01xLG9E4RnZYLvfwNZka+RqLN?=
 =?us-ascii?Q?VxoQT0wUEnebfxp3OFW08+ujIqt2EhVM0Px45XGJXS5/w9TEt2JSb40yeQ3Q?=
 =?us-ascii?Q?bFczeG0yPGFRbQoBiK6x/cjVIOHvo/BlPTE3BXtOBXy9utRMYmp0fj7SKveH?=
 =?us-ascii?Q?+ywsR3EhTvU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z9rXzInTQRNVRCUmEF0W8YiqvdIujz5fMXMWN4Mko5oMsQGpi6/Pt+8ugTEV?=
 =?us-ascii?Q?OgekyCA+DG4kVB+FemfXtOJBiId3XJn7kmbDyKlGLMjym5Esb0rh+lTSl7JR?=
 =?us-ascii?Q?Zao2Zr2HbHCujzSniL1F1Q+l2DlJfClkrZRJx53y5mrO1bCEJfZv40aNT2k8?=
 =?us-ascii?Q?vC+cQWH9WT5yEi0VS/QW8gAxAvBxbJSUzXjVc1VuHpuGgKaXUAM+ZOP/Vde2?=
 =?us-ascii?Q?14JO8ut21z8c/md7rdgaVjX87Tye9S6pnFt4Ww1p4K5zo6OLcMYZh127kFAJ?=
 =?us-ascii?Q?xocL0IYoSB/SLhtBNq/lA6Qlukx7Fnd3b6vQvY3StnCscMeqohSAGQd5ReT2?=
 =?us-ascii?Q?Od5oS6+2RZQrIpiQUnT3bEnWaKmowjFO29XeX1v/Cxgzc6w7/QVpuxnP6nL1?=
 =?us-ascii?Q?KczBq5nNCz1MGdayKHvz1ZQ/OED7ukMJ+/09nUebhKuhAWHUtfIQauoQa4sK?=
 =?us-ascii?Q?pH4jVHcpWrXS5ZAtVq8uO0Sw6WQAVE+rcI5XiA+hHwEseWiDxiAqZAWU0Hn5?=
 =?us-ascii?Q?T5cetliIPSYmXO0kphMSWicQ/6jDS4YD6QObVqDJtG7Sx9woXJul6NoQWVXq?=
 =?us-ascii?Q?qRTJTI6ec7CcaK1v6alzSGjiEueguH7tOsU5857EN9AWOMx2t/+P3ofACaZu?=
 =?us-ascii?Q?08EvUKf9nydbcQ48952mydJmSxS4zVhTY680GmkwFNeVxWKw19Lpvwza7HmB?=
 =?us-ascii?Q?o4nYrtLeGGD7QqmXpK6LBtW8P+/9uo7uVpnUDBK9pHa9Ul6OMCvbOqiTUiR6?=
 =?us-ascii?Q?giqvGSwBP9qlE4eXUdieVjxbnC0NsvRWl06+gTCz33ro63SEFKCYWVGdYwfk?=
 =?us-ascii?Q?4dH70ZEbzmYQKCElnWinUTe1qTUU5GCT3jPjEp5mcHhRtYi0gcyk+3xxErEu?=
 =?us-ascii?Q?rFI1i5vDFoIr3jMEKL9wU0fITkS8t1PnnU996pz5SOU3EaB6NCJqMcrF66uV?=
 =?us-ascii?Q?1d00P0sO92IeZcbncxlnKXX9VtaY9gHM3Zr5XfDZ2mzHyypMZIBbReaivGsx?=
 =?us-ascii?Q?kzpIUmSXSGszNASVWRXSFWSQ4Byp3UyxvCNKs2P1wKXJZ705kmVo5Mr71fh4?=
 =?us-ascii?Q?B8IoeCjYWEg3cEKC+CFLl+NHJhxYDpClh301y2GJY763FXqlm2tVKLHw9RCz?=
 =?us-ascii?Q?Scz7XDGBRulUiQLZJymsjOu8k7TAHw8dIBJJNGxdfuDg9FDgqDsW7wD8HCDe?=
 =?us-ascii?Q?x3bgAHiYbCR/Qlye5uGW77zRWMuVEsm0OULybEot3FrhjtiACANkTWzYFDfl?=
 =?us-ascii?Q?yCW35PPdOmL/D1uQGJnaJgw+pIqF/2AogWgsSyVyOVM496lFFmVdM17QWir5?=
 =?us-ascii?Q?GhhJpJX4kZx81R4kUT47WT1xYJ+XvDgQnBvkdNxnsEd9qQzGnW7gpZNU9oEM?=
 =?us-ascii?Q?t/5/WzqnDXwtaWuN9jq/z/Hf+bMHuAHgBiHoQ6q/mvA0qow9urQIGk8u2IaN?=
 =?us-ascii?Q?mIYX0BhYzqCEN/slQ+Awo5ayN7LM9iNDczW4dANWbIyUWREd254zcM42MoKk?=
 =?us-ascii?Q?Xr7NTQRrmyyZlatfuWwi1s7Hq2sJQ7mxyEbX3XsdsEVp5WZidtZQ3MDX7zzp?=
 =?us-ascii?Q?t/1uJFiyf+jhRbPqFAypyu/c23UZKl6PK8LPhg6Y?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/EQs3yQ5PWQl41xzF31JASY5YIt6fSEjUcyWXEJuugzbtEUZoAQS7rdi9j2lLBHIWVwC4Q6CsDFVroe63uFBoAOsZbYk306vm/vm1Y3YoEUYUrvGoHnJbTzIEwc1L0LsAwvCGgN6APBK/QGL0ouwXKha3REs+2Dgvn3/8ayfhJetk+04BPTbSWiCHX/HhIrfh0thmDmIh2IKC1Z8Xins0sqabm4zy9UG2Gcwn7pcdiYM5oGcyfU475a7fnJtUMB70JLW61DcJ3LYbjscJX6KCOgR97CSVk3kCtHERc62dYbPLyrFmL90kv7KCOH4vyLIqPaAkb3g8J0dy/Wi90Hsp2QvuAVvohgtrTRtiy+v/Jg7k59VWRZRYg8aiCSbELWXBBdzKugDG8lfXh5hwYOesYYGiMKOLeIrfBpwg04h/IcE0VBD3mjzVvxCeVkc/BqA1MgvRFfaIUOhmvb29ZIQTOy5FkkhqOHTLeTAWBlAla7Uo1Tz2BNk08tARUBJ+n3aulsKyiEydhFfjTWVWiOqs6kOfolvPUhOfuN4fsOwbETvdAKX3ia7VRDdNwFDMY5DdR/OAHLZTDjyyl4eDkGBYtYgIIrJxyXZB0JbAOuk7Xg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ddc0ab-a532-4fc1-6b17-08de05bb1587
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 16:03:41.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: was7lA6u7ddmFSiQ0nTWwlDYhHu/dqFD3zsMTjeCpyRmgGgio6gITWPFMkvdMha29a5UfRNcji8k68THvOMhqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4231
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=979 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070126
X-Proofpoint-ORIG-GUID: jirInTa9R2qEL18GaxRNvBT_MaoInIY3
X-Authority-Analysis: v=2.4 cv=JuH8bc4C c=1 sm=1 tr=0 ts=68e539e2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=P-IC7800AAAA:8 a=20KFwNOVAAAA:8 a=ykrQMbOU440fKEU08KoA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf awl=host:13625
X-Proofpoint-GUID: jirInTa9R2qEL18GaxRNvBT_MaoInIY3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDEyNiBTYWx0ZWRfX6KYZHywGlaO4
 /ghJyxmHElu4zrVjJT2dvqYdGg0ES9uF+vsSnwJ6++raCKPIQ4oiEXoDlxvraX+HBpXMBgY9UNX
 tscVaPEOIUjQv9AgIbnWnhAO2gK5H8CPrRq6MOTQCb6Ur4QBnNegUijxFaU5KqREHHJqjUTduRf
 BGurM0s1N50mewh1ZXc3pmagN4y3eXM4+JsoFB3+eFIeoBNoLCV7qA12QmOc2ShzR8meS8DHSZj
 jkn/1NbC2LYsrgCx7X3FEFzpgKzjJWRC5bsY4aqxaGtkbTbaGyPR9HBZvqfAREr6pIN0TgLMB4X
 HSpDDJovLgEBkitRH+rFQJJMlbGrf2QbNr+Rxcy5DjMTu7agu4LRbhot+LJQgJwpTVVqGDjncf7
 OjykBdA2+maiX451eJIJ80Cv8kT/j7CXkx4VBxtUPUXl8iZf94c=
X-Rspamd-Server: rspam05
X-Stat-Signature: 7bxw6o5ta3bkd4u7pyfeahi8q39yy5pt
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C50D1C000C
X-HE-Tag: 1759853036-449448
X-HE-Meta: U2FsdGVkX1+v2Iq0LAw8uVyhjoNNGejp7/Xi1nT1o57e++hFM/WCTuVwqt0JgJ8hE+Wr18K10AK8NNtL8yEqFw7Br18xSqIv6XLZwVG2204h4kgWrxbNfkkAfipfU8Qt0lOSLLwvCQMs/NOHUof4zOmwe8E3GXor4RYnE+7Q7xSKigWDxPybbRkMv6Xb8/EGuFBKhiqT/Szzjz2/Wo/A4HPm/+q/qN6H6HJ/pWBLRGXeBydZ8NMYg1euwFADiB8ZHOMpNZf8W8mf01IspYqORMJ1vQiUNb0+JOIxrH+IWHKSjedkkUeDOPCBQi8dvTVSJprEkwehnHpmvgbCmUPXVWPw/tfdAJHaXNiKXNAJugwGA7RW4hj1x5dR9bxghlWSdjjjK2Giizj0UuAjz+Zgh6EkJgo60AI48KMNnIGHRNc7rvgaVVcLu4joz2cGXqRBIK8RmzhAb4gSfc3N9ve9/+fqIU9MMU+geTqljlDqrUcdJ/7gcxqbEzbIcKGnSIaWMaibs5ESnzsgwF/bdQAmatj6eubTTA9AUD0X4QwjVtutj10UtjKC8qpUvwMPvn5JHGv9IbBQJB24z2i65lfdmP6y64rKxZljUsdgh0C3Z053R372SpWvSnocQRl3OKQnUC9OmBxUEaNtk8fCsvLXe2o5dtWyu8L3ZKtu28+H/4N18GC6tvWLCuege6HEzwhPrS3PsT0SMAfQEEILCqaxRtzZ/sZobOTWInCvPKmPAxcp3SJgZq/L/ka8pu0jkaRlUM6qnHod3shA5e4fAc8f1KrjpU8HeLNuSgIZ1VVE5KuabY4NSqxrGoX1w7yM1ZiKkaC4zeSyXcbKZILfsmtEUn2HHjieVJyiHfz5uTvD/EPVgy0jAhcfffSaTj3DhLUGrwUFh7Ml8jN3yxMXht8cBRkVFFKS8VCe9NR+89KCD7EUoxz4l4FWW+Qm4dd+adk51PoxiwafaBw7ogq+ahZ
 rCpIHevG
 rCsNG3dHdWqqzvB61//tNbBhHsZwr9QllNVsx2HtERlSDjSUy3AEKld7/QUcBa5K3K6oc9K/9q8vujlUzCzh6ecos3oAXTL206s2n2GKQtFnSw7NCdjT3BowPaFpWyGnwy370oZEtEcKrtCLPRhSDMsfP8HC5EpKPxZ9X65IAK7veQmmiFyQrZjvAR9ZVpGh25+W3gKRdS3st2Y4rPSHUNtmcE3QYNVfrE+YdV2J6pSovSftZ2CsThilrSXafMatZSMyDfzp0zWYKSWYrbY7j6frQeaJ17iYMgDr4OTKMrhOIXRelWzS39B0myVg84xGlpkHxAW7hbVJsjoO1opmAmCsr9Dck0kLYmSKO6Z2SWXvyWjD3tW0MjgIGutFizJBkcMhIqp6gjjK1sqOFFAks/Ud1FY8xd+h0bRcq6fluWj+qnkc9P8ma0NVShZvWqBat3ugZXSJo4i0mZ0TPw46l+1uBUztDRQQDwjCmETP3tiGzcaEy+byDHWBykwUmyCG6bKPnObO/oGm7Q9Amt5wzNlLe00h/h1zphpIIcQzMICMXso9QauGvuRcPrwsDof8guUZsjqWCZcHzs78W6XxuEihQ6C+sbWjb+DRHFNbk7T+gIoDaPcb6kDaGG37+1XPOQsKjXHjTC/FhqWfBFboj72JN9o9FJSVlj+kU4hsf2yPxaG+zUDB2DymRaQRXisl7igaVBRzSRwgdOah33SUa4G8eRpvR9Os04qqG2ZJa6SkH0LmwZzAeHKL/4m6cgwLftSkbPyyv3zfH0bmj5TL6wBvbtqcngTVJmWeIHuPUweLVOfEoGJYUSGBgnFm4sULrCVebEIhe3wCr89ZL9Lr+JmV+fYsmby04oPRWVWrYos7t/erJbs8wQtK1jkxhkRMa5t40k+EgNBWNBfUjl0Vo9JmmJvvqL6LQK+F3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [251007 09:52]:
> On Mon, Oct 06, 2025 at 11:31:19PM -0400, Liam R. Howlett wrote:
> > * Peter Xu <peterx@redhat.com> [251006 17:02]:
> > > On Mon, Oct 06, 2025 at 03:06:39PM -0400, Liam R. Howlett wrote:
> > > > * Peter Xu <peterx@redhat.com> [251003 10:02]:
> > > > > On Wed, Oct 01, 2025 at 04:39:50PM +0200, David Hildenbrand wrote:
> > > > > > On 01.10.25 16:35, Peter Xu wrote:
> > > > > > > On Wed, Oct 01, 2025 at 03:58:14PM +0200, David Hildenbrand wrote:
> > > > > > > > > > > > I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> > > > > > > > > > > > are rather unsuited for this case here (e.g., different feature flags for
> > > > > > > > > > > > hugetlb support/shmem support etc).
> > > > 
> > > > I think this supports the need for a code clean up before applying an
> > > > API that generalizes it?
> > > > 
> > > > I would expect the uffd code that needs the same uffd_feature would
> > > > logically have the same uffd flags for the uffd_ops, but that's not the
> > > > case here?
> > > > 
> > > > Is this because uffd_feature != UFFD_FEATURE_* ... or are the internal
> > > > UFFD_FEATURE_* not the same thing?
> > > > 
> > > > > > > > > > > > 
> > > > > > > > > > > > But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> > > > > > > > > > > > the supported ioctls?
> > > > > > > > > > > > 
> > > > > > > > > > > > _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> > > > > > > > > > > > _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> > > > > > > > > > > > _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> > > > > > > > > > > 
> > > > > > > > > > > Yes we can deduce that, but it'll be unclear then when one stares at a
> > > > > > > > > > > bunch of ioctls and cannot easily digest the modes the memory type
> > > > > > > > > > > supports.  Here, the modes should be the most straightforward way to
> > > > > > > > > > > describe the capability of a memory type.
> > > > > > > > > > 
> > > > > > > > > > I rather dislike the current split approach between vm-flags and ioctls.
> > > > > > > > > > 
> > > > > > > > > > I briefly thought about abstracting it for internal purposes further and
> > > > > > > > > > just have some internal backend ("memory type") flags.
> > > > > > > > > > 
> > > > > > > > > > UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
> > > > > > > > > > UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
> > > > > > > > > > UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
> > > > > > > > > > UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
> > > > > > > > > > UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> > > > > > > > > 
> > > > > > > > > This layer of mapping can be helpful to some, but maybe confusing to
> > > > > > > > > others.. who is familiar with existing userfaultfd definitions.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Just wondering, is this confusing to you, and if so, which part?
> > > > > > > > 
> > > > > > > > To me it makes perfect sense and cleans up this API and not have to sets of
> > > > > > > > flags that are somehow interlinked.
> > > > > > > 
> > > > > > > It adds the extra layer of mapping that will only be used in vm_uffd_ops
> > > > > > > and the helper that will consume it.
> > > > > > 
> > > > > > Agreed, while making the API cleaner. I don't easily see what's confusing
> > > > > > about that, though.
> > > > > 
> > > > > It will introduce another set of userfaultfd features, making it hard to
> > > > > say what is the difference between the new set and UFFD_FEATURE_*.
> > > > 
> > > > If it's not using UFFD_FEATURE_ defines, then please don't use
> > > > uffd_feature for it in the uffd_ops.  That seems like a recipe for
> > > > confusion.
> > > > 
> > > > > 
> > > > > > 
> > > > > > I think it can be done with a handful of LOC and avoid having to use VM_
> > > > > > flags in this API.
> > > > > 
> > > > > I waited for a few days, unfortunately we didn't get a second opinion.
> > > > 
> > > > Sorry, been pretty busy here.
> > > > 
> > > > If we can avoid the flags/features, then I'd rather that (the derived
> > > > from uffd_ops == NULL for support).  We can always add something else
> > > > later.
> > > > 
> > > > If we have to have a feature/flag setting, then please avoid using
> > > > uffd_feature unless we use it with UFFD_FEATURE_ - which I think, we've
> > > > ruled out?
> > > 
> > > Yes, there was no plan to use UFFD_FEATURE_* in vm_uffd_ops.  It's because
> > > UFFD_FEATURE_* was introduced to almost let userapp have a way to probe the
> > > capability of the kernel, rather than the layer to describe what features
> > > userfaultfd has.
> > > 
> > > For example, we have UFFD_FEATURE_MISSING_SHMEM declaring that "the current
> > > kernel supports MISSING mode userfaultfd on shmem".  This feature flag is
> > > essentially of no use for any other memory types, hence not applicable to
> > > vm_uffd_ops.  OTOH, we don't have a feature flag to represent "userfaultfd
> > > MISSING mode".
> > > 
> > 
> > hehe, the overloaded terms here are numerous, but I think I get what you
> > are saying.  It's funny that FEATURE_MISSING isn't a check for a missing
> > feature, but really to check if the register mode missing is available.
> > 
> > I'd also rather not have ioctls and features/flags.  It seems reasonable
> > to drop the ioctl, like David said.
> > 
> > I assume there is some future plan for flags, or is this for versioning?
> > 
> > I'd like to one day even remove the suggested backend types and instead
> > use handlers in the uffd_ops directly, although it is difficult to know
> > if this is reasonable today.
> 
> The current proposal will be two fields (modes_supported,
> ioctls_supported).  If we add yet another feature-backend flags, that will
> only be used to map to the two fields but using one flag.
> 
> Could you elaborate what's the handler you described?  Is that one handler
> returning both of the fields?
> 
> If so, I'd prefer that rather than introducing feature-backend flags,
> because I want to avoid introducing another different feature set to uffd.
> 

I was talking about uffd_features.  I thought it was being renamed to
flags, not modes_supported.  It was pretty late when I responded.

FWIU, David was saying we don't need both of modes and ioctl listed in
the uffd_ops?

I was thinking that we could just put the features directly as function
pointers in the uffd_ops and check if they are NULL or not for
'support'.

ie:

struct vm_uffd_ops hugetlb_uffd_ops = {
        .missing = hugetlb_handle_userfault,
        .write_protect = mwriteprotect_range,
        .minor = hugetlb_handle_userfault_minor,

        .mfill_atomic = hugetlb_mfill_atomic_pte,
        .mfill_atomic_continue = ...
        .mfill_zeropage = ...
        .mfill_poison = ...
        .mfill_copy = NULL, /* For example */
};

Then mfill_atomic_copy() becomes:
{
        /*
         * Maybe some setup, used for all mfill operations from
         * mfill_atomic()
         */

         ...

        dst_vma = uffd_mfill_lock()
        uffd_ops = vma_get_uffd_ops(vma);
        if (!uffd_ops)
                return false;

        if (!uffd_ops->mfill_copy) /* unlikely? */
                return false;

        return uffd_ops->mfill_copy(dst_vma,..);
}

This way is_vm_hugetlb_page() never really needs to be used because the
function pointer already makes that distinction.

Right now, we have checks for hugetlb through other functions that "pass
off to appropriate routine", and we end up translating the
ioctl_supports into the function call eventually, anyways.

We also seem to call all the mfill options with a static uffd flag,
which then gets validated against that ioctl_supports.  So we already
know at the call site where we want to go, but we're doing it in a
round-about way.

I think this is what Matthew was saying about a middle-layer [1].

If you had dispatched to a fault handler, then all the hugetlbfs checks
in here [2] will hopefully go away, for example.

Thanks,
Liam

[1]. https://lore.kernel.org/kvm/Z0DOdTRAaK3whZKW@casper.infradead.org/
[2]. https://elixir.bootlin.com/linux/v6.17.1/source/fs/userfaultfd.c#L476


