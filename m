Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2A9E83F05
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2BFC6B0088; Thu,  5 Feb 2026 00:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03B16B0096; Thu,  5 Feb 2026 00:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D836E6B0098; Thu,  5 Feb 2026 00:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0CAF6B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:18:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 356828B7BC
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:18:34 +0000 (UTC)
X-FDA: 84409247748.22.F9A7160
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id B6852180005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:18:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IAIA5m9S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=To+aFh8b;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770268710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1MeMNVPiVUZs522vejZ7D4jJXjwAuRwEkv/ao40u6o=;
	b=mnGF4dXPYtPQ50/F8GD5TC9I9Ma7KM+NHTSCQ/uyL9c0LLAVWmimAKQsXQZj1ukQmkdvZZ
	HCLqdNH+OzDxWuejcvfGyqZhR5QHwyicGq8wxasMYUOPX+5jcyLbIpuoTJh+3dKFbe5kSP
	Cj2QKgszNN0X9pxsIafedjqvYH/4kts=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IAIA5m9S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=To+aFh8b;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770268710; a=rsa-sha256;
	cv=pass;
	b=brMf27NJfgxUPrP5bfH++4aOzEi1mB+yXYd4BMZ/TnGQxMeYWqYLko1yl1HDpElve0miGO
	Wx94GxR+kqAT8nzehurNuaXjuNcjapQQ8/sCT0ahwofDbyf3VI69YtI6JTS9HAGfEBoW8I
	3vjs2x+t1HM29mUgM+AALCMvTam9rlI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614Ka2On2731262;
	Thu, 5 Feb 2026 05:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z1MeMNVPiVUZs522ve
	jZ7D4jJXjwAuRwEkv/ao40u6o=; b=IAIA5m9S3GenpiRLkbbqOueRTqL+Rb/IPh
	YoL5LE5HLDQQMmX6Ot98lwV2LkRGkBCuknatSNFDwTP+Xh4DeBb4O9NjAKmnS6qT
	1Xjp4MY0sKeqdhf8PuIVhQhc0zVmJONaFj0sDZ0yzs3hn1IZWlNhu7ACkq92TRIg
	2j8QLkT1CprpG7xiHcqkREVq3ADimuTP+f0KXFkQNYaRtYQuhUvVyzOBl/gM34ux
	OwzmXb19gpaupUVoyfs5Z0WO79I9fD5mWC8pAA7A2kDlWrViTkWI6eI0dj1hHLT4
	D/6d6zttVzCFmrBaTf1SYlGcPHac83NCQqClqM1ebbzQaFk00A8Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c4d9v0f0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 05:18:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6154eiOm001539;
	Thu, 5 Feb 2026 05:18:24 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011015.outbound.protection.outlook.com [52.101.62.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186chrah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 05:18:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/N/fBeNCVhQIkq0g3MHMIYoWoRwJIjxi+p3vKpgkr4UWSV2O0Wan4JkSYc3Kic3aV7Clb7eGC6h5fz1e8ZIFGkkLU8gw7E8ZFIve4V6Xt01E8pzZS5m++L2fqEjqYZAWdld48HO9Nr/43XsxAtJoAhpyGekcxMfYTI9dmk5vGN3E+lphOQV8a/NOQ/lO/ADlGNCVzgG2X597+KH3RFsyZKKIgrR9v5npa9E3XnTX8mcTy9EKb2KZ9SdMJkt5zM9EKzYnKvYpQCnQOdbuerMjOgrysQYr+EKbLrkI5EeewULzA4Krh5wTaaFPYytu4hyDMsI7KcGGu5tHN4LJwvT2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1MeMNVPiVUZs522vejZ7D4jJXjwAuRwEkv/ao40u6o=;
 b=gLmTUSWNO/C/E24DT0tniCKiloucE49wocgD1bttJO2aROYDhr+9v9HHTmM2t6rEYcYWc6DhZmjCNg/+yo0psMdPSjKfZVags2O8Ds6XzYbMVYeeVqe6JD+gcBS/Kzkp/5VTZl3WLQGuihQNI4Pjv14voeOvBXUhxfIzGCNq44cuF1jc6YwlTIBDgBni9mdRwd6SwFm+iRIFM8ALpYRjEXj6IE/e4N7+2JHZE01Uw+EbMKxXhWnyzH0aEvokJ0bwRFducLxyDZCpRjo5KHFCIeF5KWacXQDt2gUX/huF4uZ0RiPce4Z4HdQNVrPTzewgYLfdvosLhnYuOcPTmqiz2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1MeMNVPiVUZs522vejZ7D4jJXjwAuRwEkv/ao40u6o=;
 b=To+aFh8bx6qXrT1KymwNddp8EdBkurqcg6QPU92sCA0vFZhYD2EPexixvhL59pnSn6cPQ0WgXMc4OxPgjbJy0QuTTq1fBY3Zm7L2LinsXWtt8gFSlLL3vpKhT3GRWBVYY8zW5Kczw1+17XbU/I9EU2o1Cx3CvHJw6zoHFSjlMRo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BY5PR10MB4179.namprd10.prod.outlook.com (2603:10b6:a03:206::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 05:17:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 05:17:55 +0000
Date: Thu, 5 Feb 2026 14:17:48 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>, Hao Ge <hao.ge@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slab: Add alloc_tagging_slab_free_hook for
 memcg_alloc_abort_single
Message-ID: <aYQn_Mv93Pi2gnIu@hyeyoo>
References: <20260204101401.202762-1-hao.ge@linux.dev>
 <75a2obu7fk4t2h5wj54gkbtyie4pdenw4mzecmmsgzwbhvxfmy@7mrdfx5q5p3h>
 <51489c81-1adb-4582-8564-7c97b6a1060f@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51489c81-1adb-4582-8564-7c97b6a1060f@suse.cz>
X-ClientProxiedBy: SEWP216CA0110.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BY5PR10MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: 790c77fb-a16c-4b4d-6ee0-08de6475ead6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9FprSIwJwJHBAcpBweHiq6reXUlZxl97JFXChAso/fGdLvtn+IHPZAxLE/XB?=
 =?us-ascii?Q?DT9vX5jJpgCdR3GGf5dzwqwvV6Irvg6bqm2h1zxauwru5G6tCk6SAqL4MDrO?=
 =?us-ascii?Q?sKc4XDhVJ3AFnEUu16BnO342UbGpww5usJ0OqxqjOBIZfQj18S806pgsfjJD?=
 =?us-ascii?Q?d+bcnGTxkupBy+qsmPcqNMqg61iB9BZICR62O3K2A2/PfctaRwNFVSIMFlEr?=
 =?us-ascii?Q?WEO8WjmqVg8eT7WczolH9wiQoWupyJ7VWXEZgElDfBnMMJblYU+lOMO5EouV?=
 =?us-ascii?Q?sEYLkJYuMoYLwf6z5JIkrXvfFA7EG0pa3wnZCRk6PWUA6K+t5ggG6sPfnGCC?=
 =?us-ascii?Q?5xVpmMQouxr9fUO+mDIXvXfKOMJf4S9i82CqcPLZddhc5WkaO4xAYSB+zSNV?=
 =?us-ascii?Q?DIxd+wSL+WaAsx5orbzGYeycuNzuMmsJ5Nw6q0JfAk+JUAkvnoikDrhUDtvS?=
 =?us-ascii?Q?kwGdRgHi7mTp8tmNZU6ao8/80xAy79nYsvBUCn2Wtdc1DxZIoy5UjjnLZQYY?=
 =?us-ascii?Q?O3C/xa3xFtEvPUAK06CuDpBSieLMgGB7k/q2a8CeA1IXRM1JVw1K//8U98BI?=
 =?us-ascii?Q?tewDLWB2F+nl50c/sJGkwh8WrcO3KAn5PVpjrt+yXA7UxfevFt3iUNjf3eMW?=
 =?us-ascii?Q?yXJpy37E2PQH4mt0rHWGIK2mTd1E5QhyOoHnok2cqmk5WTIEhQc4yUsWkRW+?=
 =?us-ascii?Q?38G4Mt0OCy7Q8VRPQOfdAKuUugGy7yF1aKrnm1Gi1dmhQNBd6J8I3TGL91Rv?=
 =?us-ascii?Q?draMx+e4WH7D5jTsKm+XNVuRTG/pyDibARWNCesA1TNSz/KEqqQV0WLgJEkl?=
 =?us-ascii?Q?99XQLAS4H7Bt/jxjw/9ljaS/dwzspkB2SGDhuW4Q86arHkz7Zyl3fDHUyv7p?=
 =?us-ascii?Q?aE7NfWM5VjyuWw0S876+IfFM5K+y7bdIegXkDyCYwFckWqyk1dL4iUigVUBR?=
 =?us-ascii?Q?Gxw4zzSVRBLm8Z3m+xlxfw8JHN8aXkW/7EFp2Fd82nqS9KqoAlni+mrbPkRR?=
 =?us-ascii?Q?I8B1blbR/Jx57bCL7wGpbi70+0fPnl9jdtE4bRILpvx7TsKIGRPISncZHZpB?=
 =?us-ascii?Q?ysSW948Mv1jRb4Yubq0fqVCvWaP8TfxXbJvEhdBUd4rCafPfliKfvvMrSWv0?=
 =?us-ascii?Q?+QV/TGbhTN6Yoj1J1EhUFPUOlxhvbbYSwvYSvDZ3jIAmzLajwVBpuWpDoDSb?=
 =?us-ascii?Q?xyf76cjTXS0YG5t7p3jGnf0F8jz1KicmwhicWQDuz54Si9IyXzbM4t6wu/m4?=
 =?us-ascii?Q?LCs8iN5WkjJzqZFhX+4PYuwAtklPgeOwxYvMTAUCOy89y/FCXE+yT4K84wEq?=
 =?us-ascii?Q?CSA5VgjZvliSUNfpJc8V9ab4kbfFUSgeixCRl7A/hcdHrh7AwsCkUx5ybjZU?=
 =?us-ascii?Q?7wRQXdYIQpn1RwbnyrrQjZQChs/jE34LOtg0b5ZgictmBAcTu+sm4MQvJdXP?=
 =?us-ascii?Q?GXOBoISDmus/pIpUs/9ohSbIcwQHGLdxOgDlpfzULdiKVjNa0J2OSPi30F35?=
 =?us-ascii?Q?FcB020MP8Ag+UsoXwDzaUrGPRTrGvulsbvRb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LQelJCQNmyRtp8pJdXSXo9zSvim6OxfZDDB1g15jSQ5PKHaeoqgqqBnFcPLU?=
 =?us-ascii?Q?OgN8hG9/U0LEAZfFqbnu3l9oDyyhK+Ub7aOvyE1mRcyu+J6dynRKBoypINQn?=
 =?us-ascii?Q?+zpq/evjUQxsZRaG7zry9B46jMlDO4RLloLNiEFQCvVfwHIlfYk3UrwbOsgG?=
 =?us-ascii?Q?EVcRkCeIOfy5lD53+nAmg3N0+Xb2ynLfh+fbGKnDH7dsX6k9X3n1ZmB027/2?=
 =?us-ascii?Q?Ok3LMb9sqB58EFKsR6PI34Oxa76JDNR43hEwgoNsQU0Pxf9hanNzo/F5bd4n?=
 =?us-ascii?Q?mWmapNkcwWzSvH3QlG842X/iRzAC2k79EqVM/Pwjg4HdYQLm+5qK/iGBH5mW?=
 =?us-ascii?Q?/NGsPuPyhKU+MNQj83yKY0byU/FVo4eAPCu6Wsj7vwfeXG/wk1eLHBu0k57y?=
 =?us-ascii?Q?bDgJPoscb+pTp7D/OXzusBxo4SGvhtxyW1vf30ZoWUjGXwvxeuYK/cCMvYXG?=
 =?us-ascii?Q?PJcbYGGxb2crFs2E5L6PHR/QG4vn/yQjM8OQl3pC1aGLKkPzZ2eEzgxP4Cns?=
 =?us-ascii?Q?uOBrpgp+Y8c4jEDQLcIcIWHCO1NXpBFvWz/BuVozn5dm6jrgUINLsvtkEJxo?=
 =?us-ascii?Q?h3LafYtK3C/tSgGUa443WK6GfSuFd8np8G7lCDmm5eL9DWPquGY1O+aZ6x/t?=
 =?us-ascii?Q?tNbvIYWZs50Al9gAmP0gu7694B8Riv3NsYcZwDjJapg4nENUeaHZkdhd8rKW?=
 =?us-ascii?Q?n+lymGwwDENjejhTLFI7fM+SvoWEM7mhvwbc4yRjQutA1Nel1SCcFLjKwsDE?=
 =?us-ascii?Q?ybwTXQ6M86invk4xj6XUsDJ8NHmDXT471RVuLHZ8imHPPJueaYMVfKpfo7jQ?=
 =?us-ascii?Q?Ktf7pc2gDg5ossImZ0MIYJ9nycRZDnYJLimBOLAqugZe6ovsG0w5uhnlhYoz?=
 =?us-ascii?Q?uL/6YWWSzEIIPz8/h7wv53f9jcFNitNX5ju0D7eOCJWV3WLGGpN7LQSWV9w4?=
 =?us-ascii?Q?16IXj2LDYL5Uk4DkJIBBQONRUn1sOuG6YwF7/NBahjW8b6cEieyjXX/F523o?=
 =?us-ascii?Q?w3R4YbjKVUOkTsoN5aNkhEYY7G3vbIfFHcnasTDyUzmsJigB8wizNLt6wwvj?=
 =?us-ascii?Q?poO6YuPSDJXP7HBJ8PAy7bkyHaSoD19ZV2D9n+gQrtx8o5rCkWH3YMB1/z4O?=
 =?us-ascii?Q?6YQqMJZLjqQoA2vjkjoNPSXdtHFskrxNCHOIcvN1cxSeY/h2NyAADDPc10lc?=
 =?us-ascii?Q?7IZKJKjXLKNVwAOEPNlGlxI5crhERZoQmTSkGh77JrVSt991TGECvajz0T9F?=
 =?us-ascii?Q?Y6hxUw4hoBEaqBoftZvAUyVrmZQ6hyPjc5vJqsC3sAaMGaLUY2rueDlF4pu5?=
 =?us-ascii?Q?cAEiDb1JMLDGlQNkRjdeFtMSSvvQtww7doDyYiWTsns5I7ohJFu2G5h6kdGJ?=
 =?us-ascii?Q?RjGlMGjtnJNWjjWRyG8O4+AvxEwCjaZa03CK7SLchyQeexo0/6c3AuKidwZs?=
 =?us-ascii?Q?IbvEOI2P23O6EFDZOPqGgPd/LuZntnDu/jIEvsIgkKkU99FeKvNYwI/dZSNC?=
 =?us-ascii?Q?FVQls5camm8pg5xntcS8VCt3W0y/GiZ/EVSIEaqkB1tT/2fzumeoW+r3ZiLX?=
 =?us-ascii?Q?d3AR3j817v5ZFh5aUpEXd3rDdtBTTLuOI8qbNL16Reuukl4dWoUPO8rJmUe4?=
 =?us-ascii?Q?R2Y2A2yrIQyk9h9B5r1pLQ7oM9mB/qPdnpyRQABh4kmYGUAhnYNOjRjzGk7D?=
 =?us-ascii?Q?ZbSk6njmYhr9YT/1XF/llEVs4+j7vI/UB+jw+wiD2m4Qj8T9hgkuQihEdBFE?=
 =?us-ascii?Q?99r/KD4d9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cvTK3+ExEYAd8Rn/R3QOF6st5HU/TeK2roEoG7qMSJiCn6+jWcIKET5NDj2TxjRxqdVaqfPjKg77iB42Ma0hlC7grHkUhLvKdLeV5A+STFZNPCCmPzxEt84sAri2IF41SLWAf8DczTLDnHaFUpssJ+KOaKZG9hxMcxAHCCpJ2MKspvhK0/pootAhKBWTBzb1Kc/iHIC4Q39NqX0MoE0Q0vS9WTvzvexMJEafFWeKoTn2Nq3wGJ5v31YaKE5VV4LHjGoWITvRfUC3rBMhEsQWisXr/7efNm5u0uDLlyA4CwqEXyqDJKme+jpYKA55pkRMSw+DWS5Aqj16gqVe7Gno6L32obJHOpJsIOfxNBnkM0XrF6O+Zs/GgpzlTDEODopaYPqH/TPW4DNLapWWNAZ79U1eisxhLtcaH3Ufn6W7MuFvf3QSJoGykXVKrZptLrYbF2fUR+hzS4vcw1BGD7jiiuNYblmyfCsqLDPyPxWuzH3qkperIRR1z5LKjrgH3WcRac8lAbJ6A9qOo4jYuku8xM7UrLQ35nQujJMfLPgBQhFLntbVZnmJoFjtC8941fC3Tho6FmbExB577p9lMKNqbKFWJZZPm8ljxcBZ1wvkf+k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790c77fb-a16c-4b4d-6ee0-08de6475ead6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 05:17:54.9932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlL5qBRrufmcHgGJVdpwQHKDMbHphd0XZDXbcCxEPGoOE6FySt3YSMPuwiXSmJuwZFlZznT1wBaG4G23pibWww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_08,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050035
X-Proofpoint-ORIG-GUID: ZTsjq33maSDYORlbO84T1cYEvgVB13D_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDAzNCBTYWx0ZWRfX9HoIDnIZJ1fp
 mfRrEZ0MJREmPSttB7zQwsrpjsxjikvdgwDQ0Ce0AA/ONDSDklNiBuc0kZxFzhcR2+kXNxT5eyH
 xx2C2YvKRc2pY/tgRXbjvcoBynIbgpONZUil4HOYgDLC2vtQnrcBCUG1Oxw8VC5d1Jysz3LBBgN
 1Flcu7kaKlI5NhmTdT6Fhuk9zULHSZJel+cSD3iKzvc57BNV4fR3tMghxNAvDUGwjVo09JWAi9L
 Yd2Q21NIRWpmhvKi7r2hgx9vuaujJtbsL/PHhPw9SECx/+Fe2TBhCvpITC1K6v9stCHSq6hke7r
 4HtVcyUYQaBpxdVjmKN2ClVV0U183UvVy9K5t3AP/pTEKbAJG9vCA2i76XHkxdVVNrPa5uua5Gn
 ZdpOW+aU7Due6SafDvfjhtGtIMBClk5y7E75/9kLta0LyOanibTaPdSWUtEyuWr4fvCeKLvgowV
 h/bbCvQuE5pl1+xY8+w==
X-Proofpoint-GUID: ZTsjq33maSDYORlbO84T1cYEvgVB13D_
X-Authority-Analysis: v=2.4 cv=NprcssdJ c=1 sm=1 tr=0 ts=69842821 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=WeAauocvn8VwdxNAiJAA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam11
X-Stat-Signature: rhmxo6hrc6cxykkt8pjkg4qogdsr6mnb
X-Rspam-User: 
X-Rspamd-Queue-Id: B6852180005
X-HE-Tag: 1770268710-299769
X-HE-Meta: U2FsdGVkX1/APyMYAMAc2XgwLnsPqs4UPczkEzIJp1wmTTNG0rLzP0Q0KOJcgRB3mWzc+I0DRH+IEATl1+bac7aItlsYCb1K2Q2P4JFL/4xLwjbjJjozGyrvyt/Ep5F/xvQhVKEoC3D52u/6xxNO0JcHsvnkjAf++7U0s7JLxmV0xwOVG06yhpWrh3fl23iLgnkWkm/naQ+Nh/9tK4KhmS5P9+++vBEdb7EjUXvQqr43MAR4voTqLaKAa+ADxbgbTnP/8/0Q1iUGArkA50frFwguZZi621Su7NHJSbaR+7tkEhOVXDCe8YnBIRCuCZsrJNllBo16X1X/Iu2zdjZ4GIQlZx4S+IRXHTJ9FUPVZPrz0XV7GtK9IXvlICvFKvqUzQF8k65cg0Rkum3Z8BH4//GF2MHS+dGtXJeh2Q64DOU6ErFf16wB7ctTGcbqXA1f33jwp15tM9kjYnSeBLeponGqTG+V4Ked4AGdXFCAdlNyIOHmhLo+bWjx3/zOwNA+1zthnaABBIqdhfyk1RU66sxiDqBy9GRtDfkSIEOmVs5NQ2rddpJ0GqO9tnD0Y16xN9dEJbYob7rpsPG7xxcVxCuSITxRAj6XrvN63F1vyWrlwciqty9c6VunKbrmJ6TnffiUkTYEbSQnh7LE7j4xiiGUZQ4PLukOk04V5kJW1PS5e6zbMgYgzfni6fJZ1WWPyPP1oD4B2/9CcejHaEVBvj/gVIMk95DNREy9G48D2u3SpifVQak3xrSslJyI9YurZfKnD0jdLk9assUFeHfLTu9a1Ri/FlQgu7WKIkjA1BKPLPrFSNc0VVRKgCU27W6XZ+IQM+M3IyxDtjWlBKlMf+z95xfNu6owYUGFrPLtfjK3SnWu3QntoQMC7JNnIvU5yE3NxhX33+FIPZG33sqXGag0UjYIvlBjBu7MJKTJC1HNWaglD0SofgSBXk10Fa025Nr10+WGHos0W80CCx1
 QGTq9drp
 WjXOpl8QFVL/AVLC3hZueN6eJrsgVDLlyJbaP1s7YRVXxARGApxvfY6NUtcM5apTntPxkyU/81R0WyRHhcPsNZX+gRLp3sEOCTqvz4tfijRUK2E90wM1TQG2ESeTY8jJqxsI2Rp2r53cY4v60GSAnAJObY8dhuWWVa4G5SCkLjV0LTiT/DzMHC2xEAe8BfOZXw4pYpTT9vAeO3RNM2YzWVlecZ1DZR7UWJHQ0zY6XY9O1BhsFSU8YKeovXpeg4gxmaYPn1utAu+WAEoKIrRtFhPAPbSrAzUyG3unapJ+3kkb4+YwhcH4oTThA6NqxXnibmqVhr+Krpk0U3RDhVrJ660ifr05RJ3KFhpOa57B/DwP5QOz+fZC4S+Lmp3gEa40Cv158ls0NaIBFivIk6diQINrfFJQPkJQFix5nfb4OWLimXgINGl3pJQO2cOOKwFo+AAjmS2cz0b1VDv3OJdFWRVFIjWKRVn0s2lN4YdArBte5Gz1H64oK+q2JcIjAH9acUGm3GchUpvRSZRh3H+W6uW4eLhvAJw8b098RB+2YPRzCf6QqXNBBsrj2FLFWGT2IeQk5uTtKCxprBAkhD9PuA1PLUWB4+wV48cIONhm4kIAslKFps+yJ1vImjgpJEgb8kSD4GOkcaBYMEMovubS6wJ7vW+1G1u42t6Xsdt42WdT6qTaAvQs3L7F24AHMMTtj9u8T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 05:28:34PM +0100, Vlastimil Babka wrote:
> On 2/4/26 13:00, Hao Li wrote:
> > On Wed, Feb 04, 2026 at 06:14:01PM +0800, Hao Ge wrote:
> >> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
> >> may be noticed:
> >> 
> >> [ 3959.023862] ------------[ cut here ]------------
> >> [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
> >> [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
> >> [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
> >> [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
> >> [ 3959.024182] Tainted: [W]=WARN
> >> [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
> >> [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >> [ 3959.024199] pc : alloc_tag_add+0x128/0x178
> >> [ 3959.024207] lr : alloc_tag_add+0x128/0x178
> >> [ 3959.024214] sp : ffff80008b696d60
> >> [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
> >> [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
> >> [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
> >> [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
> >> [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> >> [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
> >> [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
> >> [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
> >> [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
> >> [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
> >> [ 3959.024340] Call trace:
> >> [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
> >> [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
> >> [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
> >> [ 3959.024369]  xas_alloc+0x304/0x4f0
> >> [ 3959.024381]  xas_create+0x1e0/0x4a0
> >> [ 3959.024388]  xas_store+0x68/0xda8
> >> [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
> >> [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
> >> [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
> >> [ 3959.024424]  iomap_get_folio+0xfc/0x180
> >> [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
> >> [ 3959.024441]  iomap_write_begin+0x198/0xc18
> >> [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
> >> [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
> >> [ 3959.024461]  blkdev_write_iter+0x38c/0x978
> >> [ 3959.024470]  vfs_write+0x4d4/0x928
> >> [ 3959.024482]  ksys_write+0xfc/0x1f8
> >> [ 3959.024489]  __arm64_sys_write+0x74/0xb0
> >> [ 3959.024496]  invoke_syscall+0xd4/0x258
> >> [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
> >> [ 3959.024514]  do_el0_svc+0x48/0x68
> >> [ 3959.024520]  el0_svc+0x40/0xf8
> >> [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
> >> [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
> >> [ 3959.024540] ---[ end trace 0000000000000000 ]---
> >> 
> >> When __memcg_slab_post_alloc_hook() fails, there are two different
> >> free paths depending on whether size == 1 or size != 1. In the
> >> kmem_cache_free_bulk() path, we do call alloc_tagging_slab_free_hook().
> >> However, in memcg_alloc_abort_single() we don't, the above warning will be
> >> triggered on the next allocation.
> >> 
> >> Therefore, add alloc_tagging_slab_free_hook() to the
> >> memcg_alloc_abort_single() path.
> >> 
> >> Fixes: 9f9796b413d3 ("mm, slab: move memcg charging to post-alloc hook")
> >> Suggested-by: Hao Li <hao.li@linux.dev>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---

Woohoo, nice catch!

> >> v2: Hao Li correctly pointed out the root cause of this problem.
> >>     Per his suggestion, this patch adds the missing hook call.
> >>     Many thanks to him for the thorough analysis.
> >> ---
> >>  mm/slub.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >> 
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index f77b7407c51b..452a92544c6a 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -6689,6 +6689,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
> >>  static noinline
> >>  void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
> >>  {
> >> +	alloc_tagging_slab_free_hook(s, virt_to_slab(object), &object, 1);
> > 
> > LGTM.
> > 
> > Minor nit: It would be cleaner to store the result of `virt_to_slab(object)` in a local
> > variable and reuse it in the code that follows.
> 
> Did that locally, also added Cc: stable
> 
> > If you end up sending a v3, feel free to add:
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> 
> Pushed to slab/for-next-fixes, thanks!

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

