Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D8EEB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3906B009D; Fri,  6 Feb 2026 04:35:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A1F6B009E; Fri,  6 Feb 2026 04:35:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C196B009F; Fri,  6 Feb 2026 04:35:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 648D76B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25DCD160884
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:38 +0000 (UTC)
X-FDA: 84413524356.11.2BB5B8A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id A3FA640006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=muP352OX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zS1Y7Y3l;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O68ZAwrU/DVBYV1jhqNTcK6XWL/38NRj9eKpvb3jlmQ=;
	b=W3vGPHou8m7QncsdNgM9LMOhmDWJSGIj2o2OtPlYsnpo44eA8PTYJsayci7OGsaq0ZD4UE
	VfTK76OgG81K5/PNgNSJb+OC+Ek7fKzKaXiXsfEQMg7glVMUoJuGe/3f5TkWUQe74a0qA9
	f8vygzUKA4Wi+5ELlURxg/fPNXOoyTQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=muP352OX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zS1Y7Y3l;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370534; a=rsa-sha256;
	cv=pass;
	b=VmVfUmPMRql3NMOJAI2DuhRPNYT37WC83N/C4R8DYGNo8carnHTfwY9BSRtD56kOG4BQ/Q
	kRuGAP4W/rMrO2+g0mjH7m+Dupg+3DKzVmn7APiBvkK2XBQVNVq1x+E8STVe9u//QkD55j
	Mqct0mkjFd8jY6NxAycWxmC1bXE/WkY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615IKrn31076776;
	Fri, 6 Feb 2026 09:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O68ZAwrU/DVBYV1jhqNTcK6XWL/38NRj9eKpvb3jlmQ=; b=
	muP352OXvOWzh3cCoOYPmMfv6rmTQ/9b+igTk5KEyC4RA8C+UmV2KupL85KMwUL+
	5DSsZBqB+nD5t0ROp328xvAV1+EbgQA5cfHWhNecH5BY8m/7os4J/VwSxtBZ2iXJ
	HpsRyc3UAxhX1757xACNYe3XzvruMNS1/rt3UgAwwsrUV+LDOmN7ptBvNeX4eunY
	64py76p07Wepgx4nlSGHm7U/49pJIOrTxrYUMLtp2oguLvgX/LQtailzhQ4w5gwK
	7ftaxQkcXhaMQAsrkLz3Oqu0o3mC4VkcAz+r90jr3jvZCpohsJMMpldjgkAqoKbB
	eC7FLIraZig1nmqpXMNgQQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50ddgwu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:35:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6167OVe2040230;
	Fri, 6 Feb 2026 09:35:05 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012008.outbound.protection.outlook.com [40.107.209.8])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c55gbx3rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:35:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vinwp+ts+NwO//k3R8P/6STw0yNL7ThtWY87mmfU6+jdB7UgIlx28YvonyIoKdWB08hGjDsLr0I602zXpX0D7DELyfniLEXczdducwbx5+qgk8qFcupSPqpjOWOmEI35ijwpfeYciCi4+H46R7HXM9/1A0DZVCHoLG9wWyZoRc5SixNg5eYQsOWVZFilOexWXy94UURRKCC0BIWzzIjB++Vk6L10ci4IkPYNQ05Zml5eULeWhkVXiZ1/p95DojkyubY3wcGwkl5x1jKEKTb76H8oHmTPLTawwlZVIDGChXksjYkp0aZThDlLKJ5sS8Ev35ioYV0C5egm0aWx3lWR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O68ZAwrU/DVBYV1jhqNTcK6XWL/38NRj9eKpvb3jlmQ=;
 b=lnQKOGE5/xzpBuYBqh03XANf3IYKyPUxELAMTcvEuY4g60j9iRU5g2NgFCZK7VNLBgixLTViotdorFYK395xYYSoAD215hBPDqhCDyoYGtDpWug7ALyIhpmVYTkGpitP+nIkFriycdonFbH7CzsO0yJBwzghrcMspDhbcHOqxF9x2lN9LOM2+I3b5oWnQmukQYnBGOHNPuzfWK4STyF9SYOrw4csSHXEIcdV3ua4Dc2l2AMz6v/VLQ5TXfI7xgGr5VR0rIhEUpa+NzmVwMJgLIKBKs5ClF3MjAq1rvATDJN25ZAgRED3jLGaOZdEQ9huXfNErmfYpWuzdqEre+qIcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O68ZAwrU/DVBYV1jhqNTcK6XWL/38NRj9eKpvb3jlmQ=;
 b=zS1Y7Y3lpz5vEhpIrdTGGKSa4CWG1E52bV5ztkBxX+dTuNgy90JZKuSuPWl/qHHFat+yUX3izhjf4BwNZigN0iIMTpAMAp410w9/w/ufQ4KJgaFlqWRMNBrVl06byXIwpXN5e94bY7EjLhlHmu0hlGtrxoStsGw/CnHtxscpnQE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:35:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:35:01 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
        Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: [RFC PATCH 6/7] mm/slab: introduce kfree_rcu_nolock()
Date: Fri,  6 Feb 2026 18:34:09 +0900
Message-ID: <20260206093410.160622-7-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0207.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b1e1e3f-a42c-47af-b453-08de6563003e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b+o09tQV9H+gmBn9nExzcdUJqdZXWnuTGDoHIjuAVNEtsmaC1PsAIYNsBSkG?=
 =?us-ascii?Q?L3il7daV7Q7HnO7SZiriVt+DRUqgUHr6Vj4IxnwwJJnzcewU2Fj7grcYdfmL?=
 =?us-ascii?Q?I7iTYSTVdA2WzRR4+BWJvza6nRAYQOlLDHDGwsDJSAk9cb7xf544Ms60oD2q?=
 =?us-ascii?Q?Zia43lbZyfQiFXanxCCjwYXemLCEHCZdnZ0oaoTRggiYppIORu5HsS912cWX?=
 =?us-ascii?Q?qbncfBMad035FsyZEhVYvShYrM9CBcUL23vfbWn7BJY0Xzkl4kX/MwkiPtEI?=
 =?us-ascii?Q?ZdchO7vyUGIKUuEndIkm7p6fZ0pavbdOwXLfwgOjsOmGxd+W5UmATFMRO+Fy?=
 =?us-ascii?Q?L25kEX0jwMB+oZKC7nwwkzv48rGzlN8VEx/T3FWw8s3QLmvbwaa8shoydmNw?=
 =?us-ascii?Q?LBfU18N0p2H3srQie1V8Z52SPWs+AgquG5SNuO4tt0l8nH3c9QglpMcAEr+j?=
 =?us-ascii?Q?XY5YYvmvAobzSjuVo6FShelXayfVTCrTILRThi7s6Rsg09YHLsuPA14b4hvZ?=
 =?us-ascii?Q?FQoPztrAtpmk+Nl3JH8VJb8TdgzUkaQdjBtLCA+i+2acxWoFoEcuNJtd3btQ?=
 =?us-ascii?Q?wOoJc5M3Ewu8pYk5QMgY2hHrdI/6dqnVxSZSykp7IbSzNNMyp49HtTeR87ZT?=
 =?us-ascii?Q?+xsFBO6dwE+pY27nA3GR0scVSbntcM9GAywOo+NRsqQ+VLejwNw4mQwUlGoO?=
 =?us-ascii?Q?Uq+50van6ciCnGrnuqASv3Fm4wXe5xh/lPpQV8KjSAy4DN5d2VNPmp+Exh37?=
 =?us-ascii?Q?PpwFV9HGDDShfsmIYPylalFR9vG6T3wTIU7wucVrGgUIV7nl4Sqy2W8pKKIq?=
 =?us-ascii?Q?FzNUxsn/fdOxGwvY/pT5dn+VgbToeniEvqFHgs6ZayFvTaF1S7BXFDA1JWDn?=
 =?us-ascii?Q?1tz3DW24vM/6++TkmO0S7uk2kItUIj3csNS5yJVheMVMIvYpeWdhv//IyQy8?=
 =?us-ascii?Q?5YCX0sJ6o/APtTbmTYTznmXCk1V2ZrAm0lFQJTuxlJq5C/zfdZTquFC56P0F?=
 =?us-ascii?Q?Cid2M/h6VEjhH0m3pz+fiUkLPL67Ro5Y1AMWpzQQ/Lm7MfuMcXsK+tAiCMnd?=
 =?us-ascii?Q?o3XFPbW9pRrHAr6+yh2Ny9s4i1JqZI7Q3MlHOYxPd6VXRlc/92YnErBfJwZN?=
 =?us-ascii?Q?68GetrOipELZBBam2OHNGr7nuWKbMnWEBlEzRY5FMsu/QqJLc4jT/Ws6Obuo?=
 =?us-ascii?Q?14E5D0hBoxpBlxaM87ZPP38Fm71W+d/tWKfswBCG/gAFJeiAhuxw8KSgPMmH?=
 =?us-ascii?Q?F4FgkM2JSykZYGuT5fQzlbBrw0Oy9wrXEbXsxU2ELHoW/yXmTuRYVLrlbLV1?=
 =?us-ascii?Q?6Gfn3vlIN5PM2VCOhpJCOjyFPlbAyXtdk/32puZAmomoqVjjpgmW07OUCENb?=
 =?us-ascii?Q?6RPGoDzfnJ61uM9J3peuald2RK/Q1Yq2lfpFmraCbJfw8XcdZpHZt+RyNwXn?=
 =?us-ascii?Q?/rtBOrU05jvo3ewBIaePz6kNzksGznX9wz8ETjVMB4cD8Y8LTGsZj1K/XaOh?=
 =?us-ascii?Q?vSdFaaBcLfbdzv7IVp178xUutdf2Wy08QtujYC3poAS8vmA6BgTF+RwGjlO8?=
 =?us-ascii?Q?fVrnuFw88V4aysOfkTE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iA/tb79bCHrHS6iCaZ8FSEfg3NclmvmW8VehfT9X+dildACW15RyZgdrfukq?=
 =?us-ascii?Q?uxLraVyDOMcwu2IPiqyLSE1fGpL0+nfEVWoq5awItAiAeeGUA1TJGFohLyjs?=
 =?us-ascii?Q?eJikdhKs49uZXqYv0rwZxWSbciuDlSQT/+27Avf+FcZFsgR1RsThCH226HYM?=
 =?us-ascii?Q?j6y4TaQ/ttnHe8hDQueOwwzxVi1fLuoJ9I2KMA7NB2oQkwcKzLJiwsirXd10?=
 =?us-ascii?Q?pL6aGMopBcaip8c1NGOoCOtfQVx6L6f4aID7cRC7Nx5Me319v/NIdGdDfU3K?=
 =?us-ascii?Q?IPa+K8jyyr49yAqeCyzaT8ZRDzJQ8E7yo9CrkYwp3HJZh5IH9BZT6QXJ+Fb5?=
 =?us-ascii?Q?+/ttOapMQqyQqS5sQNfcjKUrCWj4r29AtQeZd+jJ/FoexmL+7EWK1tNPfDik?=
 =?us-ascii?Q?a1IHGOwT/AHOA+oIcu1Cq3MEzrHOG22Sm3/3+Xf7SOs3UnWNrzqr46er6q8J?=
 =?us-ascii?Q?N1yQyu/tlISw27Gb+LF7B/83AJAwJ6+zoc7foKY8WbyfL6Zm6MdsAKGxia+R?=
 =?us-ascii?Q?+h4TTTIbdxOtMDs9ZBGVG4ua+zOq8KXDpt2BL3vN7WRgjAgKtgfmAA407zHX?=
 =?us-ascii?Q?TuUmajnPKK8xL766EDS8ef5PNSfeQbt1ZS0EU9Bl/MELqw9zZUtbTVslIQ44?=
 =?us-ascii?Q?mgvZR08rqfnbhZPpDLQs3PZu3uHMjXOpV4u5k1zqNCmayLq4drbX/IM8JBFb?=
 =?us-ascii?Q?eAbxFStyoVqSUEOg/0eJ8Ny1uwCQ+V00zoONfjBu0DvKSsJyROyO5rMDPFaq?=
 =?us-ascii?Q?rk6T4V/m8QIveiwfAFyBBnxm7GKFbdgZQ0/tOvRu9f3plePsIUN4j2vOwaf8?=
 =?us-ascii?Q?t4wgJIxSmBsGZGoClkvay42xXc5F7y8lo/rHt27nAjwJh32VAPPJv5mamwjC?=
 =?us-ascii?Q?WpURGQr/YqtPuYlItSKiGfAo4zi3TVI+nWmkllPQQOjyL0e11SWQ9eLLmfRF?=
 =?us-ascii?Q?58QNO5OvlFGVr6/q0OACuLGEhK0QtH8g444qe1aCvsx/KNxo2QBxDJSIZDIU?=
 =?us-ascii?Q?p4J4jzXPYx+VwF9z0C6pvZ6gYdEueT02Meuvr2UpBYZtejSPhIvpPBNWC9bX?=
 =?us-ascii?Q?4ZLpJDfZm8kpANM2tWXWaLD4A6qHPCiPnS2biCYGL8ije1bdXICOwYl7Hshk?=
 =?us-ascii?Q?lkgqGFgCIb27K7mw2hrfT2vK2NhfHqh8roXDSwbVXrkIl3NMYVm6VdsQDrzc?=
 =?us-ascii?Q?K60j0YpR4A31N8Cs7m85TyyBAcEFn3pVmwklLYg4zQH3pGA75Lwq5PInHjFC?=
 =?us-ascii?Q?okV2G8Q3U13Hpt83ddqlgtLTxGmpNLtIa8kllONm6I6l0BKkUc39NX0EZisP?=
 =?us-ascii?Q?HR/joAa4ctfk56lOwMxGMf21i+N4uKeIjfFh5ETgRBdn4VogMfukaXL7rXnZ?=
 =?us-ascii?Q?IR4C5Vvk3dCxLVR5Gs9zcTkbD9a3km8luXaYUB5/ferRj8+xoiDEF/u6zDmy?=
 =?us-ascii?Q?iUQ9n9Iy9hPxAyu/r0mcASK8/m7ovyuxvC8smeCIGAigPv0+ZTLrGWpegrFz?=
 =?us-ascii?Q?vOSHurb/cG2nwqfthPnKLjeCDyzCZmbXEvZ4uGnmBXaMYDaI+aF1wAepoJnn?=
 =?us-ascii?Q?rPaIKxwxsmoXwalgYGlv9baHMScDfdy4s48BxtI+Bu+V9DAQBUhTp6WVURf2?=
 =?us-ascii?Q?+szBCD/7/ZoXzPbedIHTtE1R8Y7ZkRt/W4f5l8tH/HUqrPYi5e1GWGlmLhJX?=
 =?us-ascii?Q?W+Pbmr4gTagqvMSGep2UFET0CThSYtWNz5jc85MJfG6Ezp7EFVzQ71thOcdC?=
 =?us-ascii?Q?IEqQPnYDoQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lscqtI2eyZ1hkHH3hIiHiKhax3FvBoFGF4WgLP6j/y6jAiInjATX/7i7iMf/vKMia4U/hKHHTbJk9PjqFWQ5Afz25m+j9w/vc2c12kVu6NkOrqTjMDdvjQmpKiZjFQSaxqJxvd8U4QRwS7iAeJ6dGQZX1fm7A8QWNKyzqZngS2tWpUaxrV86wDT22NYuz/dfYwRmtN0L/rZWwltkQwYp940sRudckkRidqWtlui2/l9M9mG2KoHB+a+ABn7hjusMoLxuBNe272iDihUrW5swyzqVAe7Jj8+Np9oOPjRvU94IdArpb1upls4fMxUPHByYFry8va/AXqMQAlEaQvexwBxX9j1wsHVN40eNWqks0IToXuJA1/80kt8KUZFCWBRUltnJYRq6zBl9oMMUYY+c2ts+zC0RyPaZmXw9B+lz+tzwuT7bNWl7wRNPTDofsxTf56qe2yOvyDOjDw5z+EZ0mG5HoSQSrq1Lz/npGmi78ZQElxjAcZPAL41++mufSF+Uddu7hTOuK4FY1LQ1Oo9fbkeVk2i8xs8UCLp1wnZLDZHoxKWA/3lTrOjIzMBjR2GEimHVZSK0WohACO5a0RdNeCvDySKlaCgndvb8iMbraXo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b1e1e3f-a42c-47af-b453-08de6563003e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:35:01.4715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3robA48wVKc9u8CcMoaojkrzUbZbhZVzaKnxkOBMfU8GUdzx+xOuNSYOx8R2ofcUZwwvqJRLc7ZmKoyyW0KwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060063
X-Authority-Analysis: v=2.4 cv=TvvrRTXh c=1 sm=1 tr=0 ts=6985b5ca cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=giRrVTgzqWd79vnxbhIA:9
X-Proofpoint-GUID: TWOs1ZGz2eA00wIwWfMIjmj28AwKodtC
X-Proofpoint-ORIG-GUID: TWOs1ZGz2eA00wIwWfMIjmj28AwKodtC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfX/LxFwTH93wrd
 qdYNkGdbHjjyJFRm8StM6MNhKqEe+NkYMcdcu9MIsvN8dn3IqsZkmfQsen4AGxAViWogAoO9UoY
 rTXCraSnSuxm1TMMT9SP5Iw7UDhNnw7ciS5jdb51j0KRXUmWNR5FDosm5AJzAGG+ve7CPDFl7TX
 lEtjSnabipsjzhXwRQgbvletQ7mlGls50gsGouPHHp0FvHrWrN6rz3qBM5E0L/Oc2vpM8L1LlVI
 fsz8GsNEHEujb3oYStDXwH702gdTygeO2+Q2/sUBo3uO/DxR9kHyu1GrKqxMpzm4/2JE++OGzNb
 10w7SFkrOGXSJAA1Qcx7+Aq0pw4SD/Ar2eK7y7w8vkD2EuF7hKBISO+cN1mrrWFd3oEnG/XF0g2
 pnmbPO15u/Q1fFlsYYU0P2AlMi29bwdCw79xo9Lefgkv+8urCAm+WNe0R+8WxbkkLvKjcQvTVrb
 igeMpQW5WjwioA9eFPQ==
X-Rspamd-Server: rspam11
X-Stat-Signature: pdpq84y7jxr76um1duj314a7s17dpzuo
X-Rspam-User: 
X-Rspamd-Queue-Id: A3FA640006
X-HE-Tag: 1770370534-566949
X-HE-Meta: U2FsdGVkX1/ZfLz/Lvo3WVduEhI/ZBICMMqbiBbDaFzX/6gTKn3kCVZlQKxIHP9dC9RswKzz/SF7izDcciYNt6XOpKZcSrC1pEmBTBAdTPWOBzBOp/jijjWAL0eqwdFg+/Pc5B6ZZA560AwW9DAeA/SwwzQ+ESsDOBUHaMKpf4gFoWu+uXnNaTesHc+D7izIRpIuea9QhrSlmttHzpMMFFExPZUH44Oczz4LgPYda/9RmFyvIMekRc8uX8vC2NyGD155haulTQ/BQaLw3aNMBPVsA5GOBTeWDOdbd/ZD7pHBdySk9Z+quAe0jOHTo1kSfHSM79olPD3+PfIk9FOqnrza3leYe4UhWuPIUCLKc7dfFMEMUg3RhMIFXoxKqY4ETbk9R+LiOlQEFKUSAvIY4OD4xbkY8DSwuvfvDgOARm4SDoB8IEcj7/zG1c+MSUF4NtDkWYxlNEzWi+HiyFcqi656+QBAbC5dOpTWGbBpdhGSCN+dn0pqqMW3S34ekmkwR2ar60v6iVPBcfPjbVFPy1AURwvdMUbPqv8dsIqOY7XTcmNxp6++LCQTUN65S3+uplG99om1lpt9NAHd435PU6xAOjfQx+or4OVRtLkP/uYHoQaBNHIOeubtxVMPMpdHUn8uNzhTv6kL1A2fbLAY8UvvXacokLW/5wFapGiMl4l9iEbTaTboS5AteT1kfNaaRPbaxFZSF4elBfjpUrn+WO6Hp1mgzvXkBhCLIgvxkf68QWjnOwIoLrqSePl17TTlTgeeHMPVCFCcfZS27fHB5WGZKgBoqIfYvGXgac2Ud1aeZfbGsPdvEoY7JB/SfJtek/9ZDy6RC+1pmwZTNwfNb6JVpe7ep3eaOBs9IJ4jhV/60T6RcSf3x9wK97uOs4jAa8F8QAD0dElRiirnERVtqTpJwC+4ZT5Ed8vXfoVojYaELnpNXReer8bQui3IyCK5NzwoU4x/MI4HpEAGFI9
 cUGjzuYp
 HRMfDIblwt5oQmTB4DsJUFunikL+vK6N6oUkIMaaDuTcQ3LWYbBeQkLzVcmUlCyYoJ7WNg7Tl1evvD+KpOqQZuAHJ/Gy0mrCmGdvtAI6I2GMNVMLfn69dbt3JVNUwXnxBx9u7ISrhyZZx7PjojNmWYpxk7x2gRaTvKK/gWCfYqBo1O2bBhVFyMivzgWR0q0eHf5xU8DQdub65tRgsKOC045rWZ6HYpOJwyAgwkKhVgiUsaleLflxIyTQieifplFJ4m/B4J1ctaKa0AYXDqptIEQ2PgMUOhEAYPZ7nuwf8YTgQa6IPlbJ8Ql6e1p7gwoFJHQOXN3/oJuqnqLStrNqYBVRpPTAu+NBleD0x0AJMpVP9TwH8e7LxszuIzsi45lfjBUUUaBMt/HMT6AKZ+hFJPPm/tvnnM2CcZc/3cHndbLwxAGhHQM+sWKxWMkneLG5aXYoMxigkq60lmrG+D8aiXTAsNVDfLVWaloW8tf49WKCmf9rMkYJHCtP67cCFcUaM3wi1wdHmMauc2UhUzKS8IQJiHO9Rvqv237eYw9AF7wrvLUBJugMNNLmtodcE9HKMirxtj1jz7kfegiestPT9PxKbfwmcbfmysH3TNmB2qIEBWv5lgbsX/c2S9m4akYKWYvONVa1N03iWmFUlFIJeqyLSRePzRw522MfLlY/0nPZDnDMu3pc5kOMhLUHvtVNNguNp1yBvF0LvzSLy2QjwhxBYqpuVtRv+ciUAQ8jreAgrvjkohNv40h1ckA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kfree_rcu() cannot be called in an NMI context.
In such a context, even calling call_rcu() is not legal,
forcing users to implement deferred freeing.

Make users' lives easier by introducing kfree_rcu_nolock() variant.
Unlike kfree_rcu(), kfree_rcu_nolock() only supports a 2-argument
variant, because, in the worst case where memory allocation fails,
the caller cannot synchronously wait for the grace period to finish.

Similar to kfree_nolock() implementation, try to acquire kfree_rcu_cpu
spinlock, and if that fails, insert the object to per-cpu lockless list
and delay freeing using irq_work that calls kvfree_call_rcu() later.
In case kmemleak or debugobjects is enabled, always defer freeing as
those debug features don't support NMI contexts.

When trylock succeeds, avoid consuming bnode and run_page_cache_worker()
altogether. Instead, insert objects into struct kfree_rcu_cpu.head
without consuming additional memory.

For now, the sheaves layer is bypassed if spinning is not allowed.

Scheduling delayed monitor work in an NMI context is tricky; use
irq_work to schedule, but use lazy irq_work to avoid raising self-IPIs.
That means scheduling delayed monitor work can be delayed up to the
length of a time slice.

Without CONFIG_KVFREE_RCU_BATCHED, all frees in the !allow_spin case are
delayed using irq_work.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/rcupdate.h |  23 ++++---
 mm/slab_common.c         | 140 +++++++++++++++++++++++++++++++++------
 2 files changed, 133 insertions(+), 30 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index db5053a7b0cb..18bb7378b23d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1092,8 +1092,9 @@ static inline void rcu_read_unlock_migrate(void)
  * The BUILD_BUG_ON check must not involve any function calls, hence the
  * checks are done in macros here.
  */
-#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
-#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
+#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
+#define kfree_rcu_nolock(ptr, rf) kvfree_rcu_arg_2(ptr, rf, false)
+#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
 
 /**
  * kfree_rcu_mightsleep() - kfree an object after a grace period.
@@ -1117,35 +1118,35 @@ static inline void rcu_read_unlock_migrate(void)
 
 
 #ifdef CONFIG_KVFREE_RCU_BATCHED
-void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr);
-#define kvfree_call_rcu(head, ptr) \
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin);
+#define kvfree_call_rcu(head, ptr, spin) \
 	_Generic((head), \
 		struct rcu_head *: kvfree_call_rcu_ptr,		\
 		struct rcu_ptr *: kvfree_call_rcu_ptr,		\
 		void *: kvfree_call_rcu_ptr			\
-	)((struct rcu_ptr *)(head), (ptr))
+	)((struct rcu_ptr *)(head), (ptr), spin)
 #else
-void kvfree_call_rcu_head(struct rcu_head *head, void *ptr);
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin);
 static_assert(sizeof(struct rcu_head) == sizeof(struct rcu_ptr));
-#define kvfree_call_rcu(head, ptr) \
+#define kvfree_call_rcu(head, ptr, spin) \
 	_Generic((head), \
 		struct rcu_head *: kvfree_call_rcu_head,	\
 		struct rcu_ptr *: kvfree_call_rcu_head,		\
 		void *: kvfree_call_rcu_head			\
-	)((struct rcu_head *)(head), (ptr))
+	)((struct rcu_head *)(head), (ptr), spin)
 #endif
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
  * comment of kfree_rcu() for details.
  */
-#define kvfree_rcu_arg_2(ptr, rf)					\
+#define kvfree_rcu_arg_2(ptr, rf, spin)					\
 do {									\
 	typeof (ptr) ___p = (ptr);					\
 									\
 	if (___p) {							\
 		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rf) >= 4096);	\
-		kvfree_call_rcu(&((___p)->rf), (void *) (___p));	\
+		kvfree_call_rcu(&((___p)->rf), (void *) (___p), spin);	\
 	}								\
 } while (0)
 
@@ -1154,7 +1155,7 @@ do {								\
 	typeof(ptr) ___p = (ptr);				\
 								\
 	if (___p)						\
-		kvfree_call_rcu(NULL, (void *) (___p));		\
+		kvfree_call_rcu(NULL, (void *) (___p), true);	\
 } while (0)
 
 /*
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d232b99a4b52..9d7801e5cb73 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1311,6 +1311,12 @@ struct kfree_rcu_cpu_work {
  * the interactions with the slab allocators.
  */
 struct kfree_rcu_cpu {
+	// Objects queued on a lockless linked list, not protected by the lock.
+	// This allows freeing objects in NMI context, where trylock may fail.
+	struct llist_head llist_head;
+	struct irq_work irq_work;
+	struct irq_work sched_monitor_irq_work;
+
 	// Objects queued on a linked list
 	struct rcu_ptr *head;
 	unsigned long head_gp_snap;
@@ -1333,12 +1339,61 @@ struct kfree_rcu_cpu {
 	struct llist_head bkvcache;
 	int nr_bkv_objs;
 };
+#else
+struct kfree_rcu_cpu {
+	struct llist_head llist_head;
+	struct irq_work irq_work;
+};
 #endif
 
+/* Universial implementation regardless of CONFIG_KVFREE_RCU_BATCHED */
+static void defer_kfree_rcu(struct irq_work *work)
+{
+	struct kfree_rcu_cpu *krcp;
+	struct llist_head *head;
+	struct llist_node *llnode, *pos, *t;
+
+	krcp = container_of(work, struct kfree_rcu_cpu, irq_work);
+	head = &krcp->llist_head;
+
+	if (llist_empty(head))
+		return;
+
+	llnode = llist_del_all(head);
+	llist_for_each_safe(pos, t, llnode) {
+		struct slab *slab;
+		void *objp;
+		struct rcu_ptr *rcup = (struct rcu_ptr *)pos;
+
+		slab = virt_to_slab(pos);
+		if (is_vmalloc_addr(pos) || !slab)
+			objp = (void *)PAGE_ALIGN_DOWN((unsigned long)pos);
+		else
+			objp = nearest_obj(slab->slab_cache, slab, pos);
+
+		kvfree_call_rcu(rcup, objp, true);
+	}
+}
+
 #ifndef CONFIG_KVFREE_RCU_BATCHED
+static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
+	.llist_head = LLIST_HEAD_INIT(llist_head),
+	.irq_work = IRQ_WORK_INIT(defer_kfree_rcu),
+};
 
-void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin)
 {
+	if (!allow_spin) {
+		struct kfree_rcu_cpu *krcp;
+
+		guard(preempt)();
+
+		krcp = this_cpu_ptr(&krc);
+		if (llist_add((struct llist_node *)head, &krcp->llist_head))
+			irq_work_queue(&krcp->irq_work);
+		return;
+	}
+
 	if (head) {
 		kasan_record_aux_stack(ptr);
 		call_rcu(head, kvfree_rcu_cb);
@@ -1405,8 +1460,21 @@ struct kvfree_rcu_bulk_data {
 #define KVFREE_BULK_MAX_ENTR \
 	((PAGE_SIZE - sizeof(struct kvfree_rcu_bulk_data)) / sizeof(void *))
 
+static void schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp);
+
+static void sched_monitor_irq_work(struct irq_work *work)
+{
+	struct kfree_rcu_cpu *krcp;
+
+	krcp = container_of(work, struct kfree_rcu_cpu, sched_monitor_irq_work);
+	schedule_delayed_monitor_work(krcp);
+}
+
 static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
+	.irq_work = IRQ_WORK_INIT(defer_kfree_rcu),
+	.sched_monitor_irq_work =
+		IRQ_WORK_INIT_LAZY(sched_monitor_irq_work),
 };
 
 static __always_inline void
@@ -1421,13 +1489,18 @@ debug_rcu_bhead_unqueue(struct kvfree_rcu_bulk_data *bhead)
 }
 
 static inline struct kfree_rcu_cpu *
-krc_this_cpu_lock(unsigned long *flags)
+krc_this_cpu_lock(unsigned long *flags, bool allow_spin)
 {
 	struct kfree_rcu_cpu *krcp;
 
 	local_irq_save(*flags);	// For safely calling this_cpu_ptr().
 	krcp = this_cpu_ptr(&krc);
-	raw_spin_lock(&krcp->lock);
+	if (allow_spin) {
+		raw_spin_lock(&krcp->lock);
+	} else if (!raw_spin_trylock(&krcp->lock)) {
+		local_irq_restore(*flags);
+		return NULL;
+	}
 
 	return krcp;
 }
@@ -1841,25 +1914,27 @@ static void fill_page_cache_func(struct work_struct *work)
 // Returns true if ptr was successfully recorded, else the caller must
 // use a fallback.
 static inline bool
-add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
-	unsigned long *flags, void *ptr, bool can_alloc)
+add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu *krcp,
+	unsigned long *flags, void *ptr, bool can_alloc, bool allow_spin)
 {
 	struct kvfree_rcu_bulk_data *bnode;
 	int idx;
 
-	*krcp = krc_this_cpu_lock(flags);
-	if (unlikely(!(*krcp)->initialized))
+	if (unlikely(!krcp->initialized))
+		return false;
+
+	if (!allow_spin)
 		return false;
 
 	idx = !!is_vmalloc_addr(ptr);
-	bnode = list_first_entry_or_null(&(*krcp)->bulk_head[idx],
+	bnode = list_first_entry_or_null(&krcp->bulk_head[idx],
 		struct kvfree_rcu_bulk_data, list);
 
 	/* Check if a new block is required. */
 	if (!bnode || bnode->nr_records == KVFREE_BULK_MAX_ENTR) {
-		bnode = get_cached_bnode(*krcp);
+		bnode = get_cached_bnode(krcp);
 		if (!bnode && can_alloc) {
-			krc_this_cpu_unlock(*krcp, *flags);
+			krc_this_cpu_unlock(krcp, *flags);
 
 			// __GFP_NORETRY - allows a light-weight direct reclaim
 			// what is OK from minimizing of fallback hitting point of
@@ -1874,7 +1949,7 @@ add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
 			// scenarios.
 			bnode = (struct kvfree_rcu_bulk_data *)
 				__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
-			raw_spin_lock_irqsave(&(*krcp)->lock, *flags);
+			raw_spin_lock_irqsave(&krcp->lock, *flags);
 		}
 
 		if (!bnode)
@@ -1882,14 +1957,14 @@ add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
 
 		// Initialize the new block and attach it.
 		bnode->nr_records = 0;
-		list_add(&bnode->list, &(*krcp)->bulk_head[idx]);
+		list_add(&bnode->list, &krcp->bulk_head[idx]);
 	}
 
 	// Finally insert and update the GP for this page.
 	bnode->nr_records++;
 	bnode->records[bnode->nr_records - 1] = ptr;
 	get_state_synchronize_rcu_full(&bnode->gp_snap);
-	atomic_inc(&(*krcp)->bulk_count[idx]);
+	atomic_inc(&krcp->bulk_count[idx]);
 
 	return true;
 }
@@ -1949,7 +2024,7 @@ void __init kfree_rcu_scheduler_running(void)
  * be free'd in workqueue context. This allows us to: batch requests together to
  * reduce the number of grace periods during heavy kfree_rcu()/kvfree_rcu() load.
  */
-void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
 {
 	unsigned long flags;
 	struct kfree_rcu_cpu *krcp;
@@ -1965,7 +2040,12 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!allow_spin && (IS_ENABLED(CONFIG_DEBUG_OBJECTS_RCU_HEAD) ||
+				IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
+		goto defer_free;
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
+			(allow_spin && kfree_rcu_sheaf(ptr)))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
@@ -1979,9 +2059,15 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 	}
 
 	kasan_record_aux_stack(ptr);
-	success = add_ptr_to_bulk_krc_lock(&krcp, &flags, ptr, !head);
+
+	krcp = krc_this_cpu_lock(&flags, allow_spin);
+	if (!krcp)
+		goto defer_free;
+
+	success = add_ptr_to_bulk_krc_lock(krcp, &flags, ptr, !head, allow_spin);
 	if (!success) {
-		run_page_cache_worker(krcp);
+		if (allow_spin)
+			run_page_cache_worker(krcp);
 
 		if (head == NULL)
 			// Inline if kvfree_rcu(one_arg) call.
@@ -2005,8 +2091,12 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 	kmemleak_ignore(ptr);
 
 	// Set timer to drain after KFREE_DRAIN_JIFFIES.
-	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING)
-		__schedule_delayed_monitor_work(krcp);
+	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING) {
+		if (allow_spin)
+			__schedule_delayed_monitor_work(krcp);
+		else
+			irq_work_queue(&krcp->sched_monitor_irq_work);
+	}
 
 unlock_return:
 	krc_this_cpu_unlock(krcp, flags);
@@ -2017,10 +2107,22 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 	 * CPU can pass the QS state.
 	 */
 	if (!success) {
+		VM_WARN_ON_ONCE(!allow_spin);
 		debug_rcu_head_unqueue((struct rcu_head *) ptr);
 		synchronize_rcu();
 		kvfree(ptr);
 	}
+	return;
+
+defer_free:
+	VM_WARN_ON_ONCE(allow_spin);
+	guard(preempt)();
+
+	krcp = this_cpu_ptr(&krc);
+	if (llist_add((struct llist_node *)head, &krcp->llist_head))
+		irq_work_queue(&krcp->irq_work);
+	return;
+
 }
 EXPORT_SYMBOL_GPL(kvfree_call_rcu_ptr);
 
-- 
2.43.0


