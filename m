Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBEF4C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48156B00BF; Wed, 21 Jan 2026 11:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77286B00C0; Wed, 21 Jan 2026 11:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2EB6B00C1; Wed, 21 Jan 2026 11:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 714BF6B00BF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27F6C5B40A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:08 +0000 (UTC)
X-FDA: 84356576136.25.119C711
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id B81891C0003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sah4o5PQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ROuPScr8;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=;
	b=cZOqHxK6Ux+2bbNxLv2+qwbiPVqLZvuPXCUpb7t9dLSdzna+GgqsjjF1ZFILB4BmuZ3yLA
	yd1kee95bRWpfyUaqCd1wg6NKlYvHh46RsdmwBNXWYL7w/sFjnxOIASIu123qGO9u2R+rJ
	OInkCXi+wc59h0jtiiMJndpSJJHnEoY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sah4o5PQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ROuPScr8;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014624; a=rsa-sha256;
	cv=pass;
	b=CYDOLf1drCiVPljcfisQRUP4dnMlr0YlwLEx39RIQb7eW9ck15O28H3bCcaYSvx0rhN9Km
	2yF/gUPeAxhd66RWcXrFzEOzAk0eD1jvvucb9SWv8LrrW+7eOshVO7CwXCWom6hrmvsfG5
	StcWYsdwxtVSTLjW3JVLtBk46dO8hAc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LAOBhc3420379;
	Wed, 21 Jan 2026 16:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=; b=
	sah4o5PQ0XeWeUy839psPeZ4n3bPYvn1Z4dIiwYPJ/VVCUNgOmxh8xmIW8DxQVi7
	BlEt9s8TU3U24aX26aM5td/KySXfJF+xfVqPXHJs5CTovT3BrZoa27eC9wEYrm8p
	qxUa/RtO96SkQh4rBFML0iBJN/ZEBW3whL6kZSAm0LklKCSko6gioNI0hhizxnv2
	QvIywdeT1xP+ipv5sxBoFdoz8Omgub5zqYMwOib2ujQVDqVtGP4W26vD2Y+ABzXm
	c/zlj5G4+pmpMTpPJKbiT7V7wO6Eq1huLKfGLBX4lnjM+pAgjI2uYXKwHJ+gsWUr
	nvvrnkeFoYd/uKXfj5bOoA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pe6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFn7Do022480;
	Wed, 21 Jan 2026 16:56:57 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vf9yx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dA4FnI63EcZfyroTwaEAQ+h+OlO+6VruiSo0Fx4K9A890oC6K7J5gfEw+eCeJGxr/jeTDhISSp6wcNFS/ePtDyTivJE6aV/HcI++kaFoFyd6Vh8QcQJKuEPrXVyPQ9ZSCQK9CwSyM6FO3yDc8cXI26YSKH8V4CdDlAIY+nHT3AY8TBhh2AGFo6PR+ZeF/D3uK8HOsgBqdph2jdUhnBC4Q0M5DvVIXy4yP9WSfy6oHUXdHalgTtvxzoVqXdcvKbE39F7r9CAtNTrVY+tbN5UVAK8C9DXi2bCa6WeVVlEEkxW2orkU+Epoofbgu2yBWx8hEPj3Ha2ZxQUPqtoHzs6wrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=;
 b=Dqclj+JaIJ3fA/w/QdZAQDh3/9yH4hFXpYbzcwcuNKfaoActFxpWnNb85gisGyF81nKTLEad02JabGgBZe4nmsNVii2/F2uMdjbQjIflBOiEreii9CogunGDGblaMfsgFpMb4l9FG/QLlVVigeOF6nDJBaJWxzjEOda8WQ5y4YKmBlNJQzQAZerp7kE/6HpjMMTQlqUY1kv6iuKJSfM40HCq4yEbiKVKjJufC1+tcQ1tulLbVHLYWir2lIFjLbm8QBLbaLZVTPfKXupMnYdqCWHtEAGQqVphgdQcinf0Z9ksDz9uPi9+s8HDUqYHz5ltvS29icwQgKphZczuWtDeXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=;
 b=ROuPScr8I5q61Tgdyah1tPU0ASzLQYKqOMVi/idQIAGn3pUmefi5g1+KldcfUcllK+zrVzdT2MUdK2RrS0o3tTo7KTnB33GNOhXr4CAkM9/Yd40t5OmZLSmkREaZroRgQ3VzRzuN5bjyFk6pXMTZ4w6BMFN5jSduh86Lf/L92O8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:53 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 05/29] maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()
Date: Wed, 21 Jan 2026 11:45:02 -0500
Message-ID: <20260121164526.2093265-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::30) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ba09e53-3fce-4796-1136-08de590e13e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d8hZy4whZOPsdyg7RLln5Dp0rp1QIDfF2vORZ4/sI5YwyoKQYNqzFfyVhAF/?=
 =?us-ascii?Q?P2mXiUNGpL4TSI8XTv/PYZ1VlRbhqYswGD1AT7rbPxfllZMkQoJHBy3RZPxL?=
 =?us-ascii?Q?R58+3H97wQ+/iPCT9sXvJsIhcp98Hwrdj+RR6yG0qtPAy9GVPKxeZPzJ7jLq?=
 =?us-ascii?Q?cXK1l3bxvxeUk++H4kZrz6R48+t8aJZlKPtCuc7OmYfgSMWMN51igY2wWprZ?=
 =?us-ascii?Q?PjfKvPB36t7VbTvlBDnBKccWPGRH9zynJCb77bbodkjco8wTOmor3u1X24U6?=
 =?us-ascii?Q?+mBdTt5wjfdd+B1eRQfy5f0NqGHl/4rB1Sicj1Lv/fu8rllxNCmmKpu3wN6w?=
 =?us-ascii?Q?RR+1LSV8g9AK0QBX8rABMo3hLZFlk2SGWMI5/JbubByEBHtldH3F5iqg2lpk?=
 =?us-ascii?Q?0RBPqnpfWCjtn5pDp2xXmSF7IFe2Q747j8caF9BbffyoZ0C0bvEtrkLrIqUb?=
 =?us-ascii?Q?TGivhTwgfo1DymQ2tdS2ziK5KvbUhL/tvzPXyQ1+AQYHvTDCpSmx4a6YN4nr?=
 =?us-ascii?Q?86wqfPL78C5qjPCTK4f+Qg/hqsHbLviSeA0wAHDdpdmm3foBi/1QfURtBzTg?=
 =?us-ascii?Q?kyF+uQ3pfGaPAgvyl1kVfvpz8lCap8ePgBuD4PMZfiFfIDofoQvvQLCFpd6c?=
 =?us-ascii?Q?ZzTnwza5BdkUWNbjBH7is8a5G+KcXeRJpZ6bjZ1vB1dMf5/nskpmVvXF3hyj?=
 =?us-ascii?Q?7TbDMsNNjmE/67NUoF+7V4dYanp/ESjdTmDGAD+qFKfDucKDBsnjVElJm09V?=
 =?us-ascii?Q?/dzemLQY41s5jQaV0i/7rPszCHnjr9AA3NX59dwc5ndB9bXV3OBe+vkYOftS?=
 =?us-ascii?Q?KnsxBwW5gLc68JKlFW9tJ9JxrV31uqgPzkodpqS+aeQOC0laeTIL4ft6jfWQ?=
 =?us-ascii?Q?qreqBpVl+9iuiLL+gQduBqRcpWlYxpuqysp9TGgE9rEOcvhvNlXwi3nu33e4?=
 =?us-ascii?Q?euZ1SCuLQI0u6u0Svkm6pv6E6hiEBMTAvFh6Uq9wnpq+cskL63m7iBCqInck?=
 =?us-ascii?Q?yARz9esvBGCY4l4OqEk5EdtwXP26xi27kHFzH3b50G1+aidmuu0+XgKuFYUb?=
 =?us-ascii?Q?M3HqZadKtryoB1wANakhWXiP9b6x0d9sdp7WRjExhZb1oZT7GLsWWYo3iQ15?=
 =?us-ascii?Q?iud7etJFMZwIlb3L1JXilxvK/7yzCqkUrvGNtOXWye6yeEpAFhUec7Po19Dc?=
 =?us-ascii?Q?hCKhU3RWJs2msvFbhznwsjm0fYrJ95E5CxzQKmrtMJwfoiuHBzzKFSfplyrx?=
 =?us-ascii?Q?5oqOb6/+iuAgkKF7wdF6FtF83LaCsPEMgrCRKDtvNotrJSpxtwR11OFbMaIT?=
 =?us-ascii?Q?up5mmgMKx4nR6SWmxvDlTu9PBwtNLlss66av9S2nPFnMChu6OO52vVWdfaJw?=
 =?us-ascii?Q?xyhcMeprk4nu3c0ox7Tp1SmDC2JfTZIelhv+YuiMCEQfAGu/MAT6fzVg9xRz?=
 =?us-ascii?Q?EvO+MgrSc3Gy4Wj7jBObC9GU83SMz5rSIPmcb4jmlZ44afFmp7Buf1PCGHIJ?=
 =?us-ascii?Q?CXqTDr4sd0LxAcrg9f44r5yaCIp53hwPv4ugYa4tIbmUBC1sr8Hh4hU9HrlL?=
 =?us-ascii?Q?fQhvow/MnLDSzTs+MOc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rte5d30V3tRdRQngxiTnhS7LilhyyxemtBTwk4zfm1WcuZDkTiQsa7c8b1bl?=
 =?us-ascii?Q?wd39okJVmVR6HJXfPw/uqKPmKxOhS9HeFRMnv4L0Pb+LCaysqZfkzYrlsfSR?=
 =?us-ascii?Q?ng0lIkXVHeaRcStT0EYxBvPdtuafTmJDP7Csl57NiVOV8fLryE4an03vOyr9?=
 =?us-ascii?Q?60gXr3JJLAn7LfdXEB2mZtp18S/Y6MYNZ4g/QXkNYxIgo84HMouh0URIZ92x?=
 =?us-ascii?Q?mDlomJHjjmyfsyJMgmn0MFONcqXl7l9iEAncEecjx17Ro27dlFig9an3SVTt?=
 =?us-ascii?Q?eRtg9kpeuccKxYR4KSC8mRHi1/ivkbIyuL1U8vK+zpsCPoDlSdUHAeY60Lkx?=
 =?us-ascii?Q?6X0MCbAhVpuTyX8GZK55wTTff5Jwy93YyHfp/oXfgPpr+ALwNJnxT5qgprlg?=
 =?us-ascii?Q?yklrs0AtJAHjfmu7Hh5Tzfqcpz0klXUNagGp1TFZxt5aEpllJ8SdK50TtmQM?=
 =?us-ascii?Q?AaLiFc1XpBXoeLkb+eNq0ebjosOkfEmDjJ4BTrHlPSFSzZ78a2em+2ANwHa1?=
 =?us-ascii?Q?UOC9ZRsMufSiAuh4sbXlGFxvWjGeIXOJK1glEC4Bp6DzB8E6h4JzTGTkA4kp?=
 =?us-ascii?Q?z4tkcRJkTAhnCClBll7mErmtHD9iMEj3aGGuRqXOjTXWMJXXyITrK4thxBNK?=
 =?us-ascii?Q?IYfuzBSV0uXVSN/8wnuhQmWLbrZBSk7EPrg2xUmtYBc/0YFuECBT2IUxcNfv?=
 =?us-ascii?Q?4dOIHpvQ18QH2HiX803gcezED2FXddw6PCMK5VKH7m5l3yu1mwHwg7PeKqSI?=
 =?us-ascii?Q?6jbOE4AhcBTTCuXy4q7SkGV/PmQUPume4cPrpPZ2Uy5qF5/Hht0kWutq4A9m?=
 =?us-ascii?Q?BmMKSOtpC/+XotClJYkNxkA7otaMwRuCaO+/cYv+3cKwZ5qmBSCdhmAAVgaq?=
 =?us-ascii?Q?UQPAsdB23duTL/bGl629ckOfOaaph1ELcFIYzHGh+mZxEwVEisClOGSWBMWV?=
 =?us-ascii?Q?+JuWoTfLs6IKHDpIaLkKGtIdojflOzeQJB+pyw8Wzfd/UFkckmAciGswwEh+?=
 =?us-ascii?Q?nDtFc275ovp0fWvYBe45TQkVccBxfhwk7qBP50r/YBng2vpt1aJUrULH6l5m?=
 =?us-ascii?Q?zqQYWIV1mNF04843yBB+wR2MBcceo7riAfQu06DWPN6WV4+xeTTnaCRkGYms?=
 =?us-ascii?Q?lqOAZ8XsWLojlBpi5OkEnyCgW9JTh38L6WIPHoqnLyguGp/5K8EkZo2u4uwA?=
 =?us-ascii?Q?n+L75KzUMn4t62q0soRKKaDWtTB/4FbKeSDLUgxKXlo54dkxUnCQ2Xgj1WRf?=
 =?us-ascii?Q?6m1xLyvUCELMeuPsYXazx/SMdIxxY/7w/ZilDEV8xGIZ4MI5NqDEdTw8jkik?=
 =?us-ascii?Q?Dv21X0TjgeCUVXxyCHdi+PbAT8FDOWNmpIutTGD4+tAV/sovciGvIez8QLN8?=
 =?us-ascii?Q?6jocKYHmv6FSK2GipqXrzGr4/iYcIyRollTdtwmnaWfSORB7vfeiG9BTk09o?=
 =?us-ascii?Q?N5gMg1SG55lWz77ncMin4Yy5Kn2+2j8moDH+8lEIXIIGvvyOgXl/grUA4iVC?=
 =?us-ascii?Q?ymlzqptUECa74Kyh0t8Vb7/x00Ta5ZX4PjNifP9ht3HEPkm0KC1AWK76eiV4?=
 =?us-ascii?Q?fIqsVDfxi1niXLZyUVockfnjPgOdBL+wOpIUWlGOQRSA30beKsveioE6bR2S?=
 =?us-ascii?Q?UaovKALtX5HhNax3RDTcP40557+YdiYUle8wLhw1BgJCZQgw0/gNOw4VALzm?=
 =?us-ascii?Q?52OARq273ee07UMEW1zmAuzr+d+WhCC7s6qja7K+TQvmQtm9DqJF84IjkUUG?=
 =?us-ascii?Q?CvJKH68hDQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	11Szc4/WW1c62OfcHjh1ceNSiybMaIgjPMDfVnlmMDRUbMSW+fq3SoNEO4laukH3c6mV1gmkfEygUaARwqWuT8EwC+MaaArYfr1t80ftL4vwol9q/HM83xh8eUMmruayAG+2hCaV2KXRPwMSef5wpgKGGlE3IqxwpWSj6NHa5aduT+5iVQAa19qT3l59BfPhm7usDMi9NidYvxjiFmBlHVB13eenwMArYYcPNF3UfrI6v9TO91hL9BDGtNe3RoebD+KWkXYxNKN6OpwaP+NtpNl+OyeMLnVFutHwV7HcfQdP8tjIFjseJjFltpTVbAtbctF7Oa3/xAyEv43BO9SpWC6c4GqJ2T0Ze13mZV3VUlgQHQRXeVjtpNAdWW8E4BLi1jH2uRQadbwTMuy/+LPbfhwQeez5sKQpm+4TZFn1njSMt2Gsi8WGdBKmaa+yQZaOUPIPuZvivuiJSRtvgLtpN8QK/CW2yPU1FV2ZF6+MwS/bTCswuGmWSRxspXddLd/apr8fjutGVrFart65wrncGGHjOE/INr6mBGl8Zx8pG/u8VL6bQgxBQllpJEGauIMEY/WGGIRu34wOjngcTF7aokmHMtKIDP2kbEmbjSi6O+k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba09e53-3fce-4796-1136-08de590e13e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:53.2476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0B+YoDMvV4hFnjtPPPA1hPJQoqxu3JAe5h6gZeBc24lQ62fRRm8IRPOzQV+hAlKOpKu0RDOqA7Bq1BV6r15dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6971055a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=M57lEg7Pwa7NdtlU3hgA:9 cc=ntf awl=host:12103
X-Proofpoint-GUID: bPTBXJLmfYxqZoOEtVKIlI18Tg-tVlD2
X-Proofpoint-ORIG-GUID: bPTBXJLmfYxqZoOEtVKIlI18Tg-tVlD2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXxtsy/mfkslI+
 IUbMKhCSmE5sIQtcDjSY40tOw5oYcw5AEnA91D3giVyKs5N+rym1LyREFujogNl4uXDxZifHoIf
 QCbdIINIZ90eiSHqTCUg1TzIrdHSw7v4tVPf9yvv2vQyrz5dZZr/Huku3l6QYKIJeOdRRbx/D0W
 a7ZgQGRG7L45bvdFCWWxUS7wiwgv1Qll8ccvTIoic2ntKMASvdrgihUktKQoFFzE4QfPZSlW2cC
 EEZR7UqoqTgb23lDgG4UOXl2NrL80FuKQ2SqJ3CK2xmILUV5K2NqO5eRjbb7Gb5aez83MdVhjpB
 0PMvhblpb81UX7IIqX1uEkZsk6gYZzQ+tARGZx9aWpTYOJeiyI9vNHYAspUKzgfCZaUWs5i/lWc
 P+wwBTDTV8GuZV8K80J+4S9+XLTVzuJI7nOkL1l9dZOLXC+lcTHru8qgxG/cYGBmgfStfmX7Qtr
 QJIK6bm9xjys3zSywWWNzYHQO78Jw16wsM89OXC0=
X-Stat-Signature: gkhsm7xz4k78w4rrxddrj863iypte6wf
X-Rspamd-Queue-Id: B81891C0003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769014624-842371
X-HE-Meta: U2FsdGVkX182dlUKMK3XXO82lXxcOvdDZ555G99/lfu6NHvnec7U7IeNzytopSRuuy51B1IjnbqgSwq2CypbHeq639TbjcTFC+Vj4g+KNHjwhpFIGV4lwR0Rht1ecSG1T7A/ddwQ4rRXaaA4gWEHHGbxEat3wsROZ+K7nX95iHPLiFgRlSmx4nHBrtoxIsnqZPebbA/5IFlwTWw5pFMbw+bymXSroMvjwP43mVSBbrI6fbsTWf3lrjcm2FgQ9G/35e04ea/D9oRlbSAONWDumgztCJS0wfu/hSH0GEcoWpNJBsJcvzGTGuSP8v5CzVZ0L3l9uLNR2rHNdKNPAoMBvQWVHS48DVhtmG+MJ+hbq6CepbhmDXATO6nDKt6Rs9QtYBKCB047PQC1E7pQcl4vMV9VdhVwUNKEkO1k4BYNvUGV4eT+520mQJMHYdsBdvifPhVB1gaw1llZWV5kkgT3PHOb6UR3eELRpLkmoprRn1J1sXYZa6rNkJB90sFp3wHwuBu8/1ofAH3c2O75HB/yCGiYET4a5NqbOmAL6qiCnSi35VBpCeI9WmGGuaYdz7y293TEUhROXHvD2u55kuV75nsGlfPgSBTrJ499z4d89qEJWmwX/zt+TB0rCIBdHjI4i0o3sUGbdROhf5okVPqXd5jiKv85EWQGHAFqAlmCJEREFsxTpo1a9HxIz1kie4lBBP2vYxxDqTr+zaLHSUjx59lTW8qosK1thpru4M/4bY7qn3P8hfQ1SSUEi9I+14CBYMaUliyQYj/uAlBom8v+A3F+IHRKuRIWxSbd12Vs5ZnfbbZSxkbPbGpbBAzb1GfCYbv/OTiDom531keMLhIfadW321Z2jaGrajrmsL9rdD44oT5SiCUxOJsWGmw2hKhxiNbjufNQ6pAvfS+QiBSIHD7iX6kOYQgllFoF+K4N4YmQTtQn0SdNXQtrfMepSwavOui8LrlfnVVmS2htZdg
 cwbTAwO3
 9DodPrgsBlDHSPoUyXg1/F9qix9nH0NygMhpoI8Upr2Y6xqouhNn4HWVkFmk6r8Vfvv4R/tkFLTEYhFUwsL565bkoEfF0zOeolENzqXn8VdrVuw1Aml6VmZZ07ZjEtphjpTKx/CB9Wyd1EkuaK0UtNm/n7ytaXxrw5H/8U+kRLX/TE0fwmvtderuiVGtHr+kXkkbmomoUmEZrBPwBqLUPWTpJ7Lttv63wqLczqtOl/qWYa4OTavpzrtXqYSNX2zrX+Y3BkeYq28fT+yLDPdyQwMyg8HHi6GB08kByp4RIEtHPtm95+vRgw2DsoYq4cZZAsiV6tjMxZSds6LSusoT/PaL9llV4m3vtEWRQ6lDFDnLKsih3ylHzCmUzzLd30IiQo8nfCV4k7Mfyxj9TjTAtFgzBYn2OYApPe7jZQuZlucpwSB/zQoV8fzB26Vi7hzL4t+gjvblCrbrVfqy+VCFlGyxxGxU1X6/SrOM/ZnYgLqKU6jGV35n153CGKDgC/Y0TwXXZG1znwoGuYSldDCA5zwO7CtFpWfOsQUvBssIZ/I7KxHMfLHUVVXeJ0/ratTllr00q6/PD5PzZaIOUzfRPNFp0vD2Sw9Nnnktisrr0mWeSE98t4QM0eojVtYhBfHQVmRedyG6kzkYjel/Yfo6B8fqv+UTyi5fICk/cBfQ+HDJQAL/MKsgVB4JGN5t6sOcty+zl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Copy the contents of mas_spanning_rebalance() into
mas_wr_spanning_rebalance(), in preparation of removing initial big node
use.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1e780427c04a0..fb14ce4a49c3c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2754,6 +2754,9 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas)
 {
 	struct maple_big_node b_node;
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
@@ -2770,7 +2773,22 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, mast, height);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
-- 
2.47.3


