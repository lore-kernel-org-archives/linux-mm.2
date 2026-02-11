Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54ECBE9E2E2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 11:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601636B0005; Wed, 11 Feb 2026 06:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B85B6B0089; Wed, 11 Feb 2026 06:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DE06B008A; Wed, 11 Feb 2026 06:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 311826B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:27:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 231C81A0359
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:27:45 +0000 (UTC)
X-FDA: 84431950890.15.D250D2D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id B7897100003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:27:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k6OZOX9Q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YVFPLKGk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770809261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcAr7syd+on7GtflGpVsc8Olzlt077AWSpWyMVTF3pg=;
	b=unMOF3ATvFOjZNDBa3GRzBEp7x/HsvSGkZH/SUYEw88O7/DRL06ZkiGnxMfkzbzsxygdtp
	W711dXMxec60K1E4RcVK9NQrvIByp2ro/qi21DdAwlHEo2IV/FFhBwuVmEmDj1IvgzMJ9I
	7PtbVz3m4sa4RsKogHnS3YIOaQX2QQU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770809261; a=rsa-sha256;
	cv=pass;
	b=ZYYByM5BfjDheXZQ4bnZAThC0ACyPNPTkAMVlAHtYfAVgSf/lWxtPi/iNVxSHOdDUedyJ/
	pvOHwlnItTf7dGPOqE6EugrfE37m/GV0WY3nMq5HctppaOEK8sflEup+DGZFRbOt43DHul
	Als8xqVJFSzUgP84MHX8vq+5vYJYJpk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k6OZOX9Q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YVFPLKGk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B9wbbS1759280;
	Wed, 11 Feb 2026 11:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pcAr7syd+on7GtflGp
	Vsc8Olzlt077AWSpWyMVTF3pg=; b=k6OZOX9Q////nZicZaCYTv9VqzJzwbAMaH
	wmbstXU33jwJ5TwWOYBN7ZA06vebsOhHqQ0SprM0MfL8p/Ab6gmcf5E7WhcA0gXw
	Y23kjVAFozyrIuARO5XWvKDhBcxPhjg2QJe5eijmbSg2A2wgEkA0YKKbbGbbsX25
	ftSbJR05ksWqmAc4dXBpBw7w7sAAeuHjMT51+bZ8hthmvSPH/8Qih+XlxEWkb69j
	TzHHWTYA+WIviDeNMXmhrwqbwEi2lyBcj1NWVKouzNQKvnfLlwagJUleqlbPHVQe
	JhcZC5NMYuuNmP8Xh6bekkj7fkCc++sSZAB69YhxLoV0fy09A4dQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88n7hayc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 11:27:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61BB0ke0008155;
	Wed, 11 Feb 2026 11:27:11 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8235pf0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 11:27:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QkFq3+jkVgHTGdUd9OE1l5qUQ7ItFdeOluAgE7WC6kuYSyqCTVNUpeBon0WATDd2j/LYm2JVbgvrOeOfByXJI4BQoH2y2e+rPJIDviNbAd4AL2sau3R8swngGS8dXY9uwOfoYwJgi67ogI0aQBvtW6s8ecNyq8VVYRZePlZ3qHQxwkpNYHNp9CTOdH0BY+b6IUoObiqKMJtJwFgrC3E3d3PlwoFACUAsv8gk91mLtVJu3B4UOpJui5ZRWjiJPcrD2784X2sBVg0nS1WS986HgVGiQhh7dQumMgks3TcrQ6l298DS7Td2R3fRPMm60OLxteLUZ7yRjMIg6aNcRc2Y2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcAr7syd+on7GtflGpVsc8Olzlt077AWSpWyMVTF3pg=;
 b=x8eRaO3Rf/QADDuituJntsKExvSU3YUS7zoqFsxPeK5CLjhRHLrYuFHtkvV5bLAgSQVk/zw7V0PnfXW+9npDhLygnZJtEF8jlxM1UzZb/FAer1YmdHnA2afEh9k4YkZ3vLnxOKhr8SYIganu1SWXqZPq6GFPBCW4J5Y0nf5+lzxEDqET5Rt943FN0B6WLTzZx8sZODD88epjrFOU5bbrtKyOdUj7bw7mMZ1oOHamCmpfiWrb+L7+6JLgDool0i7/DnTokpevrdJl061DuMxMBJgG+liZsARITxDaCFDg9tN3N58JlgiBbXFbYRgqQ9JLNmS93JpLQzrAdDiza8k2AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcAr7syd+on7GtflGpVsc8Olzlt077AWSpWyMVTF3pg=;
 b=YVFPLKGkOQWb/7fl5LCscsx4ZYc/kziNnsEICUnQOS80F8zsbZYthO8H6auubx0pZ/VrmdeQAf+tYuinBMRsh86SfDFWXwyBrpdW9Rq4xes2NqRFepTh/SZZSFt7QEXyOgASx0sCmizsQX9fM+ewNPabLYWaKrYQAqL9fZyWhwo=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 CH2PR10MB4247.namprd10.prod.outlook.com (2603:10b6:610:7a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.10; Wed, 11 Feb 2026 11:27:07 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 11:27:06 +0000
Date: Wed, 11 Feb 2026 20:26:54 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct
 rcu_ptr
Message-ID: <aYxnfk6kCZ66CaOJ@hyeyoo>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-2-harry.yoo@oracle.com>
 <aYxXE6CC0XQr1KNK@milan>
 <aYxdleYc7_TWj9To@hyeyoo>
 <aYxfumz5IlwBDS4n@milan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYxfumz5IlwBDS4n@milan>
X-ClientProxiedBy: SL2PR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:100:55::27) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|CH2PR10MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: cdb75bb8-b1fe-473e-b1a9-08de69607ccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QqP8uGRL+uBmtmPWEuMt+lCbElk6R6wyP2w3V/uXTSANO2J5xt4/THuPBUBR?=
 =?us-ascii?Q?LYEQkecfR018CtxjoIxEreOhaIpAgz/PYwXbTv/RlZ26yf7GyWyouz6GVWgW?=
 =?us-ascii?Q?BM+6hknUb72OJinI1wplRKl7AfAKdO/tGuV6HLvn5dN8QL+zW55g+XcjpBUa?=
 =?us-ascii?Q?BmwKYMIlBp2FsUhHNWoKREPK2eqmpDnmZReWk9RsqRNGtwTGKuSqFbv3nza1?=
 =?us-ascii?Q?jHrSkCsgyG9mU/IckPjLBNL89upC79gu2OUyjfKI1yp4xiwvU+UvEmq1MrEe?=
 =?us-ascii?Q?LwgTtRUpKiqk0xYPMYaOGKOJpaSigIv0zIl4uVHfYtmZaZZrbdeORifz6KUw?=
 =?us-ascii?Q?WMOo7714VXyeZGNHQLZe+brQzpGF18BBpqlecq5xWu2EiERkKtCx9KneJmSu?=
 =?us-ascii?Q?HX9v2yn2yQBmfUaxgoaQCRZx4a/QZh22v9bl1p2IvMhpdRDTuQM6Jx2YLnoo?=
 =?us-ascii?Q?EcK8zoPnRPAPzDQ5Knx1rEUcJlsjoBSGlLeFmTf+91pqy1FJiRtypt0q9Eio?=
 =?us-ascii?Q?gfLPth7sl/SU9vitEXxfFKjLm7NfKHGL2+PFaJpUlmKWG9GWH29ZN5sTQozK?=
 =?us-ascii?Q?SoXfh2+hrP7YBTZ1QAH6vxwVsZMhNOQYDLV2BWMHFYIfEiXbx64F/OBRSEUE?=
 =?us-ascii?Q?hys4nxKj52g8digKw+yhK6hJBHAFOYJzI7Gi3YfF9Tuqr6NzSlultWDgN62O?=
 =?us-ascii?Q?dcJ1ipLlSmh7Lvxfr6WXKA9mPHLJp87fJBMJoZU+iqfMzRXXiz1l7bV3C2j+?=
 =?us-ascii?Q?2xACTzczOw6mQwm5gq47iSJue/vz3JN7NGDuyfyx5VV5TxQ6EsJNI0lxpd1t?=
 =?us-ascii?Q?RTgKiXPAhd+93Pqh9lnYupsC7YZce8NX7ZKbgCrUeJDZsfDXBEDkSIBkRaiO?=
 =?us-ascii?Q?KZWZV9Wd3L5bzXumyBOVqrrPG7rDNJHKLkRSRe+WzEtCMf8vn1HnKnSwnZKW?=
 =?us-ascii?Q?qJiheuIG0aiMDVpMdVgBRy91RvtYFiAttzqWHZxQoRbqgOGuw+xymn9lR9TC?=
 =?us-ascii?Q?o67t/g1wxJxZyiNUF1Ipn0/wanwKVooWVZp1y5xakmLKJguhg5Q8aXTzaKCP?=
 =?us-ascii?Q?neDne/St/yGFheJ3Wb1GG22M0BJ0CPxQCqOot9uuBDewJ61hQQui52gUQb8L?=
 =?us-ascii?Q?0Qtvd/F9ltY7UjkAebV1EeflswkWcNzI1ESYaaccR/e6TWeTBzyfr9ARYSbV?=
 =?us-ascii?Q?6oGCHpoc+n3wfhHYmYiYj8JFfYyMd4NdDjl1k+aHRmt3lCRKCTXLkzhwgmU5?=
 =?us-ascii?Q?/zyYZBtUk7cHSI89P+I+3p9evIi8qhyKthhlm5dSE4fmj/T6V+k0YfCqyU+Z?=
 =?us-ascii?Q?84ryh8C8hLaNtj9rQg/lwMVMnMSwCQbcnmuH96sNQ8L3aP+z4TrNcSKrzHss?=
 =?us-ascii?Q?CwXtK7+OpKTUN8HyHQfY/iPylttuw8Lygjo0doWnI3WY1GEhIKnvhMT/TD1+?=
 =?us-ascii?Q?OzTlv6xWEE3KIyahZDOKhxubnNT3L/5o38oji2ADAIQnVaxjZqvhGDbDjX0F?=
 =?us-ascii?Q?CM14tltKgq29gkTgo8+y9k6URZcNM3InoBZhlOON9JggRmMimuzw1eputTKM?=
 =?us-ascii?Q?cXgKahNDhdjxu8AdJy4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bU28c3L6s+LH0mu3cABhRFhTMt8e/4YpJWuHSLjMqIC6D7LNj7w4T4ZlMZMo?=
 =?us-ascii?Q?z6o2zuYda2Y88/Dfc2y08uHGXqBAzr7nQ36JwHHcRmmX6iUIeg2j2ozinX1C?=
 =?us-ascii?Q?+QAN8rP8yu/AIyOXgyv4eq0VgA68smslPXN/cYcZi0KHwgxpJY5qI+hyTVVX?=
 =?us-ascii?Q?0nK4yylpijEDUgD92COYUoOblYb9JTFSHj94G2kQsiBJumde+NifkmowHUuq?=
 =?us-ascii?Q?kF5G9UPKUa6HPbbIXsdjGpTdPQXef1ranfqhtKdgOPQGglcO9CJSgBcBaapN?=
 =?us-ascii?Q?EcqfzUCCbIFizJsLVYLKD8ajMqD1p5aZSPZF0tdH02nJi33Kig2kz4LbvAzO?=
 =?us-ascii?Q?sGUQnkpHcLmKlxbl/WuH6VLvUQzkwfTRo2ml18rIvNdmPROdELYhmHXOW8nF?=
 =?us-ascii?Q?PkzT0U0/0/b1cXwwz6GRiMfLvLLDXUDOxdEj118eAlAPRpP+s4RAK0g2Bhz7?=
 =?us-ascii?Q?q5S3TNEMNB5vWYrnql/otS13nYMI7sAW7Owg14jvlqhmKABCzlwMDL/ZdWZo?=
 =?us-ascii?Q?2PwFYMhXjLr7iY5qIYsFNHgLh2dzqk0YKiEV+I6csPVhC48mvckah1Y9okWa?=
 =?us-ascii?Q?Yk1oxD2+0p+3sByRJIhf+x0CpykZVcdN2D9UK71F4islpJgZqKSv/VZdX/jH?=
 =?us-ascii?Q?ffnBi2Xs2GKE+dksxeIvanQDNEAGSNDDjG0FF/WT3oKIcY/5cogRoy1X4OHo?=
 =?us-ascii?Q?XGdCxRLnIubJj9GOKNLS7yzYSZCfUM8tgBGNWqFT/M38GRt9rUBVujZ3J8SE?=
 =?us-ascii?Q?LOogxVD28wtkX7wZlRNRR+lHBHy2P7UKbo7Xd8jDRWWOccj/OM436CDrNBLD?=
 =?us-ascii?Q?yLCgHBBYaT16ImbSb+SBqX4XPo/nxjad1k2iigySje6aBoIcqDcGj2VNTY1T?=
 =?us-ascii?Q?V5tA0x3ZGuSnfq6nFwo6jiKhG5iz7mu6+CgX1V6UfQJG5l8uB5j1PRDg3vnw?=
 =?us-ascii?Q?l6acakWqfrEJoMBsC7oRKoYYm2gNNgv8wVrmVZzuugqiJsMjrn+kKsjyAIAT?=
 =?us-ascii?Q?nGtxtHGJEg3vcUpdbxlLHGLHfW0j02cOgW6dr7L/BMso+h525vLC++Ltn8Yn?=
 =?us-ascii?Q?pRIG0zuYE6r4bHFVZtiscGFbv6og11z7qws9kc4Tu2jJ0L1rIm9vyd994iNT?=
 =?us-ascii?Q?wxOMIW5DgLXHyEEu0cgQxwqhPCLK7fESHge6Zz3JdrrhSlrccSQWzQlVrc4g?=
 =?us-ascii?Q?oQtfWmaX05Ju99fXx5UPxPueXQFN56EhXnMOQNpNREecgbXi8oaGZRh1Y3FB?=
 =?us-ascii?Q?3Y5hfNrFMNZPTScrXWabrQuds2aFCMhFavcljca05+JQR8+qANUGYsRLX/gb?=
 =?us-ascii?Q?jBOKoECJFuIW4Iup2/SJ27Bq5kuqt8m9KmZDRpP+4xVKS38bkdNhxEld7nJI?=
 =?us-ascii?Q?HtN2l40Zy5VHUVhXvdnBGMtdh43vreG+muszEjjjWADVzddqjWBppBxsVbq3?=
 =?us-ascii?Q?r+h+bx8c3a4kQuqTv6Vi5Orep5AE+sa7CXk2DheY0y4PUG8yo5V8sjTrwhab?=
 =?us-ascii?Q?Bqx2xTZd7CMeg/APQNTe03BjglWZGLTO13qU3Y+6RDP8W8T2kkFmAACsdQnd?=
 =?us-ascii?Q?ILDD74rUzKYetbrPmqEvXg/qO48YQBk/xEJ1/J6iNaA2Rl+Be3cVMKr0eKOr?=
 =?us-ascii?Q?5S0JrRd9TJUgyUZKw04J/tNOeWe22G1s8ZNzGtLinqIzxcXkuGzb6EE5Y+oV?=
 =?us-ascii?Q?aomI6evQTW85X0JQZN8Y1xTRWxKedH7/zws1SPXw1OLy8cBpLe/JhXyRATCZ?=
 =?us-ascii?Q?gW3D0qYG2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4ETqOlnoOdW+R8yKg8xlu1kYIXk7Av2/01iCmgYR7J/lXLaiRKCjG+TyuW40aQoJIj1SgRrsbUrTR5XYCFK4zynzO9Qf46lbfuQyoj/aY2uE4jsDqB25dYCVOMniN6yK12M8J0qtrTrIn+uII5sjl96ruvAzp7Sf68/LxDhGQrjZXw0mWzTi1YtmXrn8b+vwpRFCUc0JCDgOd1u/wjWXaA4DxNau59AtbalYMYpn0Jxp5BAiID4ld2trz42t+WaqdLe8nYnMMoJeiCGL4lPP/PxteuvDd5SfY4nTvViVm+y7x81C44Q1AffSRBMtcgEQEeTD2yu6E2hZO2PHoXESVg4PPD9zVqTjluSsWnXmP2f0dJxTa9YBfuI40Z51wE7cdcciq39ECrPfONJaA3aFVnvvipE11mKaatzZsLCIIS3/iWVZdvXe8HJsg5916eXQ79GDo1gRdCvBfBmtfajFfUmYAjXDquVaYjyRLA+ZwvieR5H9AaPIS8bUwlrP9wKlNSh0pLoq4WQSkCYCmkVjtt6jg8QMAHj2R/5kqknbtmiNSKEIFD7balkPD/XltQUTEH5aLDr2j5fqo5W7HOgS2Ggu+UUrpgG0ur+0gAv0Q6U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb75bb8-b1fe-473e-b1a9-08de69607ccc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 11:27:06.8121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVAXReevv3/bgOMCWQ5n3JWCMGz9fqHEFKB0mqa2GMSJuo8Ei5T+6q4+SE2zS0Vp5/bahVdCC9h7GhpbWsA8wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4247
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=690
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602110089
X-Proofpoint-ORIG-GUID: 9FqIFfNnk8yVD1a9M19Bojq_4jWbGGe_
X-Proofpoint-GUID: 9FqIFfNnk8yVD1a9M19Bojq_4jWbGGe_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA4OSBTYWx0ZWRfX1P0PBa+CN3kT
 d8UwTxYl4vNigZzZSi/z48UCAUxGZKU8kmAJdg1IhqCHbZ94YRqk+WR70BtanM5ddXxyC1ShJCg
 weODM6fF6BHI1qegizo2L7ZyI7byQC7IyMZ2SYkorqu4oBk8ODvi4FYLq81sSqE0MV+VhAM/7rA
 OCdPdGRgpcNshLWZ/aqLIom7wbLB04bfTzomBzObnhUY+4XFFAJuw2xvAIUoN+OXH9hB9kj3lxP
 3RF2xeWrb5ksrqpBQ9FWe7BfZZW2wBEYIC38NWqRB7t3l3gCJxQ4wYjw9MMokn9Mga6IH+34xvk
 F3p62VrDlcyGR5YP/Vpb9wQ06aTeBLJTVRwt/E4vrO0CQWvAwpFYN6gjbWNq005Lrb2iOOA5Ez3
 jl/oWXAxXFEEsAG6aQlu579hMLFTMXwzTfG5JdFuC9laCI4dcrPx4WeFuZmtRlGgecicCWH87AW
 ZkvzO2PhWuwUVfi1wMw==
X-Authority-Analysis: v=2.4 cv=O5c0fR9W c=1 sm=1 tr=0 ts=698c6790 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnxX2X2mH_IKAZlS-mYA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: B7897100003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: foraxbrtnkqjau8nu6mkwz7f8q3uu64d
X-HE-Tag: 1770809261-774550
X-HE-Meta: U2FsdGVkX1+NrYRWvzvw5br1TRc2Bqrutrv/gA8i/2v1kJMb69qhsSPD+L88E+gg58y8Q1r+X6WxlsQ7NZ7B4ql8I9FKH8BXRxz03modVVBuDYQpQpmdMTZ6UX2Ycl13xFSFW6a/Q0ICW/2ohK7V4R65TiMV8Ml1vqBVqxewTlzEvMf48SBL5Z46Vo95DetXTafW9VrtssHh9KbvEI+pCOeEgQ/T/DxG7I47OzmsuXYhY4XXsXr4/E/P2o1o6z2ITqcMwfGSRzASaJRmZHYzUGETCvnNz4z22jzbeklTOHaBIcuZGTZrZQJ9LxsJjSmvkU+gLFGRY2j7u5wmslGh2a0aMkJ2M73eS294wffb/t4WJvXIefAmLN53SdNF1r0CRH/wfpEAPGamX7EImvPZfnrFGUDP5n+IyPHHwzWTZ33j/EGdZhoHPuaaRSXJ3ya8z40+s7C7tGvuS72bsH1/Q/VSPE835wlwLnkKDH+UNUodvGmEEiqvuz19c9+dBHCCf+Jn012ZlEAvNsflE4/X0VmGGnb8+fhWqRUW05zxRrEaKerMdDGyzVCpbTfMaHcjNig2Eq2eMPqMVI8q0hU9xheQyYMTESlUSf3OGNLW6uDTsnm/QDoIHbQ+NkPRnbtKfRM4wcEQF6XBycKbYlhCQeIcw0BB/a4b465c8BLGJDhK8ySK/RzpGZa/h/+l5wgcj4jwDTWd9VTcquwPR7hF5BA/jQAljOF4sxWkQ5O7wxQAVP/sJcVRpTcz0t+THQ9vrPTfaRZJ5s91759eF9sJep7eg60Yf3nHmGk5CPkPXL1v2EPAYw424h04DeJHTJu5Y4WhekXM7DAqdgn/tfZ6ieagX063Qqts2k1AgOro2wvFMx1yAPBURHwrec0fNuzjK5gut+qqYHr66scCnz9rEfH6Tzr9es0D5RCLA02WaV6MI5Klun/6amZATGNM233XOa1+2Yx4ivOxubUjMhd
 Ylugl0U3
 yqLonmNKqhkmw4tZDU9msyZZHQ0WkRZYCY2o5BypxpaP90mJ+vM/zA17q5ZJVUYZ1AZMJe1Kq1hxpmBmK2DH9rhqbXUYlZ3UIiVp8EdgJ7bsNIlb+fDYbj/k9gi1XuUZ3rGeK+xwDOd6USoECtipKZa24+FC+RI/fjZC0h15p+sXgWTVoiZYFj4K7dVuc/d2m/wXua3rjabJKrHVeKkR26e6xJQyj1WQgSiHy/gN16QFStk1ZLkKLPCFJHNeTr/AnB5N1TReD/7efapEIIaoJHtK/yvagapR1uaciOIqypI66pe+HQW5lGRkTdC4PzNGsjDhTs3o4pYzHN2KyscJAmMuFfywCApA2AOoc/jSwCaeLgxBMvJ8PktDEzgd9Bf9kSfWxkMcBU7wwRCQ1Nd5eRqT1QuE8u1lIPJX+vOjyg6bJgevMncNzgvrbxroO6JlSLFlx02s+8IydUxUPA6iTeJBVztm9fMzc99H+2WrO38NF6w0rXFcjfJPeFFGSY8pa+LpQ/gsl5R4G15qhILDPyvcFvc+yxk61yncp/brSYmrpfULTRtyKeuOxMzlkiErY8VXdR1ry0ryZDJNjTEr6SkrJvBux4niTQ5dkJDQksiRmbjl2mZ2i5T+7klEqbDDdLQzCMFDisC03smiJJ5r23bXiqqoD+b9j8dADPbf2Vj/U1+hM6gCsMAgveyVUyjarZowKOiXfkoCwWnHQjYJD9/jhvQSycJI9I9CXjjwmhn3tvmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 11:53:46AM +0100, Uladzislau Rezki wrote:
> On Wed, Feb 11, 2026 at 07:44:37PM +0900, Harry Yoo wrote:
> > On Wed, Feb 11, 2026 at 11:16:51AM +0100, Uladzislau Rezki wrote:
> > > If this is supposed to be invoked from NMI, should we better just detect
> > > such context in the kvfree_call_rcu()? There are lot of "allow_spin" checks
> > > which make it easy to get lost.
> > 
> > Detecting if it's NMI might be okay, but IIUC re-entrancy requirement
> > not only comes from NMI but also from attaching bpf programs to
> > kernel functions, something like:
> > 
> > "Run a BPF program whenever queue_delayed_work() is called,
> >  ... and the BPF program somehow frees memory via kfree_rcu_nolock()".
> > 
> > Then, by the time the kernel calls queue_delayed_work() while holding
> > krcp->lock, it run the BPF program and calls kfree_rcu_nolock(),
> > it is not allowed to spin on krcp->lock.
> > 
> > 
> > > As i see you maintain llist and the idea is simply to re-enter to the
> > > kvfree_rcu() again with allow-spin=true, since then it will be "normal"
> > > context.
> > 
> > It tries to acquire the lock and add it to krcp->head, but if somebody
> > is already holding the lock, it re-runs kvfree_rcu() with irq work.
> > 
>
> Check no_spin on entry, if true, llist_add, queue-irq-work. Re-enter.

That is much simpler! Actually, I tried this way during the initial
implementation. I like its simplicity.

But I wasn't sure about performance implications of the approach
and switched to current implementation.

It'd be nice to hear Alexei's thoughts on this; I think he'd have some
insights on performance aspect of this, as we have something similar
in slab (defer_free).

> You might need to set-up interval to prevent frequent bouncing.

You mean an interval to wait after queueing the work, before it gets
processed, right?

-- 
Cheers,
Harry / Hyeonggon

