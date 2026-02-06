Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C578E8B364
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D676B0098; Fri,  6 Feb 2026 04:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704C86B009B; Fri,  6 Feb 2026 04:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9506B0098; Fri,  6 Feb 2026 04:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE1B6B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EAF6C29EA
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:26 +0000 (UTC)
X-FDA: 84413523852.23.91CA32E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id AAB6C180005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="rHE/dVt7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Dkb1aUMa;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYYw59/yAhEcHzjCYtRQ8W7r7qHX/FjLRZ4HfwBuvGw=;
	b=J2xU30ptw8Cumz5EPBBMkdV/8GwiJPJnogfsMoZCQHy5mBI8HVdaZyJS7pvP10Ce4yX4ot
	uqqFK8RRVsAeNUkwCLydLJmSDZrBmKzYsZEwjBsj2NSr+MBfyhrbY2o8unXqEJzLnInBos
	e7Pu72TgUHG1U4EkLJYaJ9Fr0BvAby0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="rHE/dVt7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Dkb1aUMa;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370522; a=rsa-sha256;
	cv=pass;
	b=qZdW7bZHIFcPPGjwhslkZAn8IzaXB+4cNwt8O9JqASw+vCSEtEiMzWgzaglbu6i5JMia73
	VyRdn8FVO76dmI436Shx3yf/BkRVN+Ygf6rrhgEQhXWJEmi6PtBzsIvXYTCSQ1udcZV+jh
	0PHXVUwdjYJSVkdM/TBJ7JObvTLzq1U=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6165RHf2730851;
	Fri, 6 Feb 2026 09:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vYYw59/yAhEcHzjCYtRQ8W7r7qHX/FjLRZ4HfwBuvGw=; b=
	rHE/dVt7pecDVbnaHj9sU8MZfvweWdElLVQfaGgut1PAbGOxW2A7rpftWph4VQZb
	u+t4QUsMPNSm02XjhIlT241k4RkqtxrIH24MVi8veFJqAPeTESfg/ObKc9fyWzDn
	PTKBEOhY85FnlfVRB/+dCbR1sASsFlRFHC3qZBwwNIt7aQ0N4tJ7jY3J/Ceim2pZ
	WA76Vok0sX1cRsStTLYrPwY8bcte8ZvzuEdKRUYB0JnqvH0ataNSfXlrpjU/PRuv
	hT32RRfNApZDz1x8R8D6l2F7MRorNXBu+KWuf3w6v2ibzxLwh3kqx3eVooTHi5EP
	6jUZJP0NtpSHvHr6DX8iiw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c4dc3thf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:35:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61672qtp040083;
	Fri, 6 Feb 2026 09:34:59 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c55gbx3m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ghB/xQShrRvzlpw1RvLyKeXVeoNcYlf+6r3uCR4nFmi/75LAcz764Zjig9t7O4syhpLCbLVY0j7qX8lo5huQ34kDg5VA8E242fD1n4kLdhtgGx7237wj2naAZyN7UT6HyZ6PI7wgf0qzmaw5D1+nD7DdcyR8ZFpRTpnuvCFYbk6Bwbg85cT49lp/VW2pPWTfMEPJbaAhlBPfmwzrs0JTcE1MnXbK3RzzNHiaXcemuJ3ircDAWHjonGZd6BS/suowvT4+kuAWwrh0JezzAyGJGB9gJQ9oOAFMdIwMLYPXQmYg3RficLlfOKLSgoLa7EAd3ogdiosxxcuqQqEtj7kTkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYYw59/yAhEcHzjCYtRQ8W7r7qHX/FjLRZ4HfwBuvGw=;
 b=Vid9Wg7BpoP1tO5NX92P2vI2KJPm5YBwDjHXhBsL3yr8PhIKDkUCRfaPLwii3qUE8w0zbV+Bgaox9fXvV/OZ1LWqmOu9zKD1sRn148U7ylayTfnowqoqEFLwSCoQJT7z16L+UPwbGBQ7WeEmU5ltba/hJMtzE5kdzoCnWntVKRzVdFkiK+YZmBBt/U0Bqg7p1IQT6pkjqCAhabJ6SQi2s/aQlk6x+1puAWscJOHIkiXn38tjeI4ztcMPEGNPe+35a5oiosxBr+UxIBjyzUqhqhTFn8VuNSB9MXy2X95KT/QYt2G62eAPBiN2WVntvTYx6nC+mj/m97XztZ4UXv/pVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYYw59/yAhEcHzjCYtRQ8W7r7qHX/FjLRZ4HfwBuvGw=;
 b=Dkb1aUMaRbTsLB5Tx+6ep2ExcIbPV+nF4ctKeVhlN1yB/h3EyEOTUf+c/qr2uQ8LZTJLToz6k/h5uDMtechNWTbPhDE/SEufXjMKc3IeqEJkMVx7VV1zKAaTmBvGCOSJLaGOx+/MrT0Cs23MEEKhxNNXIremuqwd+JQRY7YWbNY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:34:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:34:54 +0000
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
Subject: [RFC PATCH 4/7] mm/slab: free a bit in enum objexts_flags
Date: Fri,  6 Feb 2026 18:34:07 +0900
Message-ID: <20260206093410.160622-5-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0199.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: e33fec80-632c-4ce9-ee8c-08de6562fbf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YT3hZZb75Ws9Sw6f94R4DfzH0DyAQovOXwtAJ2Ce44gLEQ5tmK2OmK3m1bS5?=
 =?us-ascii?Q?EwsG8qzjLRMjwpNuCVc7CxhicZc/xhnS0TqQ/Du7dqyy6zSAR+rW8tcoTevz?=
 =?us-ascii?Q?4DYvBOKhPfB6Uo1mTqhE7DpnEIZhH8H6XZXs4nlvpS7403zSXnGrmxDFYdrV?=
 =?us-ascii?Q?DqBo9dtNWDnkpGlZ91v2glsuRTot5teqDabMyZ+7MM+VlfQAZVdla11yu35P?=
 =?us-ascii?Q?HvnNew0RU62CWSb0xTNoBJvFU7CAtr1b9oLnLjDj+Uq1GDqowlepQEHlpLjF?=
 =?us-ascii?Q?ZdcrIJm5P6LllPmLHz5BB8dhLSsbcElwMmkrJ6g6Wiiv8DXLHaS+V/tdYd97?=
 =?us-ascii?Q?IurFPMN4jM3S0e7sS0xUs89ZpgxWOaK0d7q6HEPxGZDVbMleWlAtj+QVv37Z?=
 =?us-ascii?Q?4bY2qVwXAdwJGtYrrwEOHreaAhUWIbmuejW59Vx86velL8TC6XK0TE8lBzb9?=
 =?us-ascii?Q?xd21S9Nk67GlCahEEanQVUpnqbfRnBe573Ke8RLbz4uPdU+5jiC4fJBQhmQj?=
 =?us-ascii?Q?9KB9+aZOcwpAGV/DLbo7gMaOrHsDROJDagIo3OU6bpiPmVTB6rbZIOsFMhnk?=
 =?us-ascii?Q?nIqZpCbE5QoGj8Vd/VBBNKf6oyRpkbASnEHwn+W1VQ/4eVca4Zv0vmEg1kVZ?=
 =?us-ascii?Q?YRd7qNNk5ASyr+JdXjnFLEabJBQ8gZvIKgkm0WiYqb52nw5E/AcG3U4GQdtc?=
 =?us-ascii?Q?iajjjwqGov/2tOYkAvk8hpKoBdQXKITUYUrfiWkfdZVwRTfl9WI2rdD7rnOf?=
 =?us-ascii?Q?fnTrIJcJKfidlEdxTQFG/JAXOFP/Yq65e0agisKis+PJTbSUb+JGxeXrw7ij?=
 =?us-ascii?Q?/Gz3AU6Ymgi0SaGB3yqRGZoBpJjcJMLYvJcWhgcOHwZSO0++H/u0jyeqs9xV?=
 =?us-ascii?Q?PVlEXdUeipr7d2+546XKY9YyresSxVjllVEs1Am4kVUMlEt/Xqpg0GSyNZ1o?=
 =?us-ascii?Q?OXl+kLqbbbM5WksSI3BIU3wI6oMkBeWPlDFqP0WiuZATsLpAKWObkx/BucOB?=
 =?us-ascii?Q?wZlwKbe2uL8BBLJTRDg4/7awnwYwLnurOkXg2SHFsuH6nlu4aobc38UcMqqx?=
 =?us-ascii?Q?8DwL93CnvkMYesRvat+JEV2b/R2C6Kb1hxeT3abaLjx6BV3enBRC74onCd0Z?=
 =?us-ascii?Q?5FEgroJNZIiFQIN3jhJO0MfkfmIlP6NMstZ/Wlyd0oRsLb1x7xYEmfonRbDQ?=
 =?us-ascii?Q?mpiiFzBtlK+XPYt5XYlI4rWaMg1Fs2s4gV+ZsbaWazBrVINi8iVak62QIyFY?=
 =?us-ascii?Q?iTrt0JfI//Le1yZqJQlux+1SAchvHKk4tmMDNM+zcw1BwlJKRq6fp6gQeXyD?=
 =?us-ascii?Q?4aWAlUX1XnVP6lvQutAiPGOOXjKFyiUjiN6xUB2jcsFyBWtnr9QMBlz1QoJK?=
 =?us-ascii?Q?yQCCnGqtkZJY8+MB/YlwGDI1CGycBOEsLtaqFJCQj8NSVc3lQWu/9TUeYu0y?=
 =?us-ascii?Q?YbGpeN3Wkyd1YQ9+aGvB2IOUeFeGIs+OC55nHj8ukRqD3iP8TGHEVCc4d9ey?=
 =?us-ascii?Q?OHpG5OL05S+Zfa+iHyUm0/b7pUC3G1fexfyoQdrnslGarEk/hdeO78MoOFQZ?=
 =?us-ascii?Q?fkdLHGLKCHI9I5ku3Xo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YZlXAnKkoUT6OhzRMvnofZJTzpp6i+wXVA3+Whd/7ywhL076PQnwEy3jEtVX?=
 =?us-ascii?Q?VoSwWp1g9F7Fj7yenWVyQHoocdUOO30ZkenVMM6VD6yGmf5HGtWXBMGL/PMy?=
 =?us-ascii?Q?WXTofmqnqdzYmBq0uLN6x4drrVnNGYK9nI3wdVsyWHeBIuKoL1ObgHeqYrBc?=
 =?us-ascii?Q?5LmkHGmNe7n8plFeExUkf1J1K0m6jogdxxEntDJvQEd9ll0j4dpayjHY2FHM?=
 =?us-ascii?Q?ukYKgqPDks2WET+FH2fXcth2sUNlpBFoJp5Ei9gvMy+9UJ/hnLQuTB2vTqf8?=
 =?us-ascii?Q?sC0ukpabUU9Z2C8uOhEDGw5FDe5l9FqZ6Zd4b0WkaI/JdExLzh3dAcdssf7K?=
 =?us-ascii?Q?DoEU+aeegUcna/MfmavyIpQdvPy2sq5/LITMlY/V9GIOYtdgONLPGE9TjBoo?=
 =?us-ascii?Q?jK+Vqocw1h5QOGgUt/sWP8htI1vJjWe3k/yE4fU0HtRlA/Sf2A/rO2GVvfKV?=
 =?us-ascii?Q?eZ1c/QSHBtC9nwYtkmllfjSfBKLPKE/HrXJnEfLRkdDuubAly4z8fDUM7JW/?=
 =?us-ascii?Q?j8legiPd9ggHQbZaI1TqEIBbxu3ENIMUGwm4HYywLGk9RkK+6ma32xtM/04d?=
 =?us-ascii?Q?TDLFNnY9C3JPqIvdRZlySGE6apt0IkihltEnjziPnMdmi+2t40a+tidWtsRe?=
 =?us-ascii?Q?rg1pnUqyFpswTPXO/R2SLsgTtibGjGTjCYnB1TtipbueWdsD4MQxevAUZ/qn?=
 =?us-ascii?Q?9VtLd0PVodkOUG/C7hXRNmr5iPqnUhfkJc1T/dzp94pf6EH/WVbaXJY2sgAQ?=
 =?us-ascii?Q?BB7+ssnWpDfDkGLgmiZVBVAs3QH92+TLoUBIyey1HmT9Z82QCVg/+ChFGDz6?=
 =?us-ascii?Q?a7N+LPJznH167/JpF+QDEq/7nOQpZsZN8DEJvAu9IEYXVnT5aXf0KVQ1nx8T?=
 =?us-ascii?Q?Ws+flfp0clRjewt8lqEGv4Xza65wI3xp9F7y0W/YZ/3mSmDWCH1UGxEnsSax?=
 =?us-ascii?Q?oKlWCCJhStyffhiSRO7OxofiVEvlrPtWMZ9YG7a4guyRzJrLMEvwjHSihJih?=
 =?us-ascii?Q?F4yizmOVchyuzbdFhFsS6szZAx2aA0L8PLqJJIFiS9MotnyPRoHS408xuRNC?=
 =?us-ascii?Q?9OA+T6170A4plohmqAf0n4w9iTDDMVbdlmlIJrQBuMXrptCMi75QcUSPqwfo?=
 =?us-ascii?Q?woI75i2aX+vdIdvnmE8QIbVAY7kPtUuAXYOcvKmxpwQYryqRD8gCeylSZMcb?=
 =?us-ascii?Q?qt1JTAgMHJDARNDfI+xwnH1VMLZfSzHyhn9dAxJ53yBgj3wHObZi+XPHM6oz?=
 =?us-ascii?Q?HLBCSbjWAMhh6ztjkQW/eHHfh8iC5p27NZjMfui9JQGNteqKWQcKVMgYkU1e?=
 =?us-ascii?Q?FvTDaJN3jTWRoDsZVnOjKyZLmonL6RyeDWO00pFlA7kMRyhXBuHeSCmMKxWz?=
 =?us-ascii?Q?+L3AcyvVC5lSE6FfCw0lotBDNNU/0RPD/Ys1Qr1dsIrI989jKPEFtnu1hbq4?=
 =?us-ascii?Q?4cIk7EyCklN+AZDB/NJQ0NbG7rghFf/HjvgFYBpQ/xEp/5w2fC07fZn7J98u?=
 =?us-ascii?Q?ONFwHbtzF/XjBCu41bk7vWOzSgWb5IdJWOMMEye6wl8GnDbTxSWrtsx9Nocn?=
 =?us-ascii?Q?20cD4jb9eFIDBo849BC48d2xFcm9EVOBxIjedyDfTF5q0QMQVEx7IyYi/pEE?=
 =?us-ascii?Q?9QytlN/wbDL3v69/GLIJy+1x5wgancgrgYWhoorGTgYKSoSFp3LmB3972EKU?=
 =?us-ascii?Q?TePYMFYWCPXGHJlZLaTJB72C+JKOzo7K9CJlpl0J7lL3OoLfL59dn03nIWRY?=
 =?us-ascii?Q?0w7Of07BMg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f1NwL6ATfJvG5sq3kciS5Nv9O/piqWeYUVLT6a80tDMZ1dC76LXzKd+zH6995roNMefaU+/xtcQWnIgGel9YWkcT6kpoBr7v3H2V+oEkfaL3e7RcKMtCuZC22EtBKP1moNvchbQGhFxvjDZ7xq3utgVXiadDlgX+llX+dmVe2oM20mz+yWf+WIMYFOlkhEw9R/8UnItfePNdyV71cvuVz0aST+1GAh322M8/011QwhjXTJPSDEAW+g3ot51q34VxuRwogyjpMhm2uPxvZcw973IjqfS25UKDPI4foZIND3rSt67KslEVx8QenIiezHLsQdbxwTVB5JpBy7YMx5qxbmgbjMPD8HNiQ+OEqUm+WNgXEt8XOvdk9nJySVagiscLXfK580PC5kvkmqhd2Zd3WzDx4MJ90V46t6blZF8W8qu86uxb3N5vUVLg6PcYFstgyvr4YS+3Xj1rKmU3VPZdBla7jijoN68WZC66zZ2KfksoO8mSw+HXvViNE7EwoXytrHuPVuffjg9BoXWkTO5juTo/9l029SNlps/Wr5RiogafZN3zQfUO1rzNyXS7y6f/W4Cz4NvgNXZeyxJs14vjZ85xbiY/sQ8PEh1J0YtdnIE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33fec80-632c-4ce9-ee8c-08de6562fbf7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:34:54.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZtaxON8lOGX4WrmZ81yryJISp/ohPll8U1zPYzVvENa5zzlCYOywtAbnOvg/SxDSJtCqWS6/HMI5wkIpXJEPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060063
X-Authority-Analysis: v=2.4 cv=SMtPlevH c=1 sm=1 tr=0 ts=6985b5c4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=zjV6mD0EZtXkyTl6xJoA:9
X-Proofpoint-ORIG-GUID: cs6kHAB1ewL_PSmAKvqjhwabfJXGdKmC
X-Proofpoint-GUID: cs6kHAB1ewL_PSmAKvqjhwabfJXGdKmC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfX4YPt+e76rv+q
 t+GT5XMBciGT7Cis0nrp8ywvqxxYWpPkBqIVMEh1JX2lggsp3yEwMkPkLwh+iZDksroedMAV5uR
 VeSRPKDIJoBSDtFjMKjSrmG6Qr3ej4Ch9c/EFRypDty7+945IMy2A5QXSJHbODuL34Wh6/ifaWr
 6CpfJY2S3P3vaQeN02DUfBT/WWdXMjKLJ/fh7KL87NgDL7aoRNoOGuPd6sO6WBzI/CEc4AGniFO
 80vgOl5cTcv1V8aG/jysDrNVmq13YYiFBCAeTmlAF3TZ7FuzbJfjLkIOx7+JKd4cm54sbui5gn7
 GXY033PFv8N8vpq9dGrx6jxAAPO5U9hDyv4+I3OdRZMpCtgFlxsrYoPzEi05Fa5llM2zuAcZvIs
 iIpD73IA35RRWmjPbe9AF7A57fyRlKzpkEK8iWj6CQdLWWx+6nkwQbxeqHhLIy+79dwOyW7aPnG
 JmTRrZJpivpsOa4a6Kw==
X-Rspamd-Server: rspam11
X-Stat-Signature: xtm9hjx6njw45if7pnprnxe6fac5qc5f
X-Rspam-User: 
X-Rspamd-Queue-Id: AAB6C180005
X-HE-Tag: 1770370522-191756
X-HE-Meta: U2FsdGVkX19vsD+LwwN+Q6isMoUxbyPpMRQQRE56dM4WCXSBnnBtGENJvv+R5e3yc+MMe9sV1D78i5K9Hs6cX0/B4HRh5CbKwOfivR0e9o+/gSC1svnvjhgCI7DniqDXOiq3x9gJgLnyluaPl5UQABxsD1xnnAo5A7uuEtBKYcrMe9nxQyemFpgERfN2rAoJtMqlfQSEc8z8BNtBXFlv+3iCQd0jrbPRhx6T4kNQsWHYOutwXYFWwBZhjaeiHP8O+JaC9c8emyHg/kl+XJgWg0QSnjPYLDqEVBZoMIG1Zcb88e5CYO6DqVL6EEGgzkozAM9Ik8iU3VNdCOvFEWoy1TUDWg3F3D7BZWlOTSrKf0HbVIGpjAwLUfUnimPAmnfoGKtHYrtHWkMmvfl3XeOWa14WSPiE2tP347DuPqDI6VyjWIaVeEi2paBnz0PRxV56NCtz+qcjPQZ6H9l++dsIal2+Gr/of+fkN5eiSlFIrxKoDN0h3OiXjKuFrZTzRFQzmPgNgYhAqnjF/o7Y9bcVVJ7BL9oHsOD8fuAX19WCrdSRn+sirNElYMZSzTiD1YzaDGa9iIDcS3soONX9lwTL7BEWgIgOK52UgQ3WiYjaMIeYDbPaE1fg451Vo3nKorjUNvw2ZzcxBAXyk9JDAgZDKzHBB3KZFm+2QwFesbnzuj1g/G237QSmJE9xGVZqozizHNFZT7MpIXtEl0Hh8JGVxRIa9dqmzFWA5jtVABVOKnz/qX7/9vfs6Mngz/yTVFNMDThG2/1Z2cbTC2mwH5hCcjoTHFAuDs/cmM1FYhnWWqa+NdGYklcQAoolBu6fzqRh21kLOKa2LqOKma7LoT/oG+8DgN7BSB8hpPmLLfrXQw4lxrdTmzaDMTFg8fkQ8jeWGUIqhh09jDGTjR/HCxZw268pf+W21pd969vc++mE4YhmT0GjZr1nfi6/AIVi9zinWuOcHhWpjVP3jSvCPc1
 6tJkw9FG
 56bHHYgaEOOpSIIiUD4bOp4Yoebth/zY2Q4A0ZWAN9tZBeOJpNlxKul8e+qmcMB2MuNbybQ/SGBaYb/f90Rh1/hRo987330XpIXUtErL+/RCTon4pYZ8ub8MhRA3gsfqI4ybiyThS/nB4AQsWUYDXeHPWLvxZ9SJsOCxoqO+WkwUaXGAoewk5yJS0Fd8QgX1Zbc4nnDA0xw6vlWSBaII/ACAz3Wd1VJEJTYiFTqRBEwBFghPIgmoKi8f8d93CzCW70q4+a5WX8MzbsrXknfB6oKLCeudhRU/BwSyKMNDdvqIatvwvBRmlAgoOTSOiwMBqUL3XP0/pSnKJtEatOUutKcvjkIXW9UbYEdYmX/WNjoQrLEQeQLRDF2wwyKeuQjb7I4tzlFD8mYk8Y1H2wZQYaZ5inhqsxF7vvBuRFIBfiO95IzdL/y4rnMeBGvi7XBhgQcWWb/yNMbOhL0c+EX1143bYVupZtTfB/ftA/gEVTYQFY7C0+nPZtd4/HS73I/RD70KamcVOIh+7G+4WnWIfWfQkNQ/KBpwA2Y7tTlLrNKqUtWBoRo52LmxltT1dOTTLMwBmCFXjPSeIrQYYqOJJj/dKOuHZteXeWo1Vq47gxLEjU5Ler8gMO8s5QqjjLAf88Gmi2X4VtbIhf+9ahVW1+5xcVy59FZ5e2tCEm6Akvvpem7/Ju/9q+kSuywR0kGfwx3pKB6U6hiztR2bF6wy6jcl/gPFJAH8G+5UPHknXtFVy6HoEbMzQAuZr19UB3gg5DMPR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since kfree() now supports freeing objects allocated with
kmalloc_nolock(), free one bit in enum object_flags.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h |  3 +--
 mm/slub.c                  | 12 ++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..bb789ec4a2a2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -359,8 +359,7 @@ enum objext_flags {
 	 * MEMCG_DATA_OBJEXTS.
 	 */
 	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
-	/* slabobj_ext vector allocated with kmalloc_nolock() */
-	OBJEXTS_NOSPIN_ALLOC = __FIRST_OBJEXT_FLAG,
+	__OBJEXTS_FLAG_UNUSED = __FIRST_OBJEXT_FLAG,
 	/* the next bit after the last actual flag */
 	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
 };
diff --git a/mm/slub.c b/mm/slub.c
index a118ac009b61..ac7bc7e1163f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2186,8 +2186,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			virt_to_slab(vec)->slab_cache == s);
 
 	new_exts = (unsigned long)vec;
-	if (unlikely(!allow_spin))
-		new_exts |= OBJEXTS_NOSPIN_ALLOC;
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
@@ -2210,10 +2208,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * objcg vector should be reused.
 		 */
 		mark_objexts_empty(vec);
-		if (unlikely(!allow_spin))
-			kfree_nolock(vec);
-		else
-			kfree(vec);
+		kfree(vec);
 		return 0;
 	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
 		/* Retry if a racing thread changed slab->obj_exts from under us. */
@@ -2253,10 +2248,7 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	 * the extension for obj_exts is expected to be NULL.
 	 */
 	mark_objexts_empty(obj_exts);
-	if (unlikely(READ_ONCE(slab->obj_exts) & OBJEXTS_NOSPIN_ALLOC))
-		kfree_nolock(obj_exts);
-	else
-		kfree(obj_exts);
+	kfree(obj_exts);
 	slab->obj_exts = 0;
 }
 
-- 
2.43.0


