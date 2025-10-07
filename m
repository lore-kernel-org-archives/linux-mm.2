Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A1FCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 20:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812918E000B; Tue,  7 Oct 2025 16:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA098E0002; Tue,  7 Oct 2025 16:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1448E000B; Tue,  7 Oct 2025 16:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57BFB8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:26:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19859B82AB
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:26:11 +0000 (UTC)
X-FDA: 83972450142.14.FD89C5E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6601018001D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:26:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RH6aM94U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=inpElGXD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759868767; a=rsa-sha256;
	cv=pass;
	b=Tp5cmZbtSP35/1PYUYQKY0azyUC7LT64OGZ02vSoVuCrsx3dddW+nGllDvEnvQlMCArk/J
	kGqoBGlMPrEYIzWmntEkBBS/Lyt+KtcpuvDCYwOHhIBtsQ3ITx1/3tmPdLRRtxanDr4Ipk
	8WPDYwTpKopj+md7Uk15Gx+aeRAZgTM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RH6aM94U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=inpElGXD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759868767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cG5+qZvRSYdc5hDQv6oC4cOUR0Gj7gRLALgWfbVE2tk=;
	b=Tm1W0VbWsA5WUUQVzCds+u9OlGqEcYWnQI3+OaFLNnv+o130SmMdMcCzVRVN7KZqjo5ozj
	0f5txeYWOL87g9HBLq11T0an+2mb4wEQP2p5VYysFU+4tj9AbbGkjO3uVoDjnnrQb+TG9i
	zYYY94aDqvRmlivk5UIcKQzpWfW2Vgc=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 597JixAG000618;
	Tue, 7 Oct 2025 20:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cG5+qZvRSYdc5hDQv6
	oC4cOUR0Gj7gRLALgWfbVE2tk=; b=RH6aM94UyLq2jAYqwqENuUfahxXmMQx2Fa
	hGjs2tAlFbk2T01lIiUe/JfjNTOjm921zGCT0cKPnL+4LpN0V6glENd7AI1e8n1L
	SJTKvkesKu2p/z3Gj+qIMp57o8bxEhhVGxTRdBReAMXWwp11udTTRpOzlHKH2k4U
	pS33tw9SyhzMsCBtS/RTlX3awcuUfDHfNokBgBs/KQ473i/BXozzz/PgmAWbY6Rl
	ZcvxWepOEhRTKMepeU5K+tGgngXJfrB2sztmymRKSyDVp5Pa1QEgsofjmm9Y0at9
	OzOZ8B9h/b5jlPPakfzGGl0PFxMMR3qhmJ6Jjnm2RbRhvVOldtIA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49n99jg2uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 20:25:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 597KDURP005696;
	Tue, 7 Oct 2025 20:25:58 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012000.outbound.protection.outlook.com [40.107.209.0])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt18xmxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 20:25:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uHj2jxenWIlhYIdm/xUr4wSQPKzwgF4ZweqobTRm0NmCqRhKz8HnUqAmZtaKfD91t5l979b1ulpRCQFWhkn0mkwpuZ01iV7eQnsYS3PECvasLe7SJjn60ZkIL1a48Iwdi2qBGW2LFtg2Krbjsm8L7UMfC3dvsWImaR6J5cuUiKr1jltSWdBeJfZL5y3DCdztFH1ZJtO50+FanLZx4kWDH/cIkxur3tXL4oQkbTAWB/Elgn+WkuxjobXRHj3uj92502Xe8zNPSaVxnT4u60O+lHM1eRuQ64rgVipN5jT34HpJlqdJNLYy0wazRsVWSdCR2oqEpaoymyF5tZnECdrY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cG5+qZvRSYdc5hDQv6oC4cOUR0Gj7gRLALgWfbVE2tk=;
 b=DZq0cGf9f6Wq4NxGn0ydKdlPQz1h7MUBbPXkQHRgK3b9E1Ca1eFU0DuZUD6L0rxSBUEDh7PexBfcxR47D+ELe0SepjqL+0l5a+6vl9p+1WBB2kAVtW8R97U1LXITxJGrtl7m9jogqRkdScbMr6BY3jTbfqCAzvc6IROucDi9sGLNwLgHlj3RBE/iXGzN794RWOQeti8s0nxJIGLiZwDSrAupA4QA06OjP4aRQSVlWy+D+hHm9OvOaGZtBZ7He7OsxA60wlDRqla35ByEQaXiZanhWF5sK5aiqN+Z0yoMXdTBsgXNBpIHjWRv6OlrGqkXwxhqH7HYK1A/AVMerLeliQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cG5+qZvRSYdc5hDQv6oC4cOUR0Gj7gRLALgWfbVE2tk=;
 b=inpElGXDG8frD4Cl6nWE+MoUawQEhoAX4e4pyIzxeTnav6J6kdDLOKY4L0z+RzPo7NyuN14tq2IWJ4kArC2G8td+Lw0c+enLpfVWxcA8/udMn5B7eawMFUqTQDHnwmea8jXjG1J1Nlu/MkBBKhFHXJn0m4U4nVBWBNe51+2Hwac=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BN0PR10MB5080.namprd10.prod.outlook.com (2603:10b6:408:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 20:25:52 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 20:25:52 +0000
Date: Tue, 7 Oct 2025 16:25:48 -0400
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
Message-ID: <33wnllmydtdlv4vf3rzz7ei3vg7t7x2gqqha27ib3i47lfd6mz@n3nyevb4yf26>
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
References: <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
 <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
 <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com>
 <aOVEDii4HPB6outm@x1.local>
 <6csw4pmymno4kdtlbzd74posr3dekamq4zkje2mfkmbg5q7xbx@y3o323tbm7h3>
 <aOVtAMm8PqEbGANh@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOVtAMm8PqEbGANh@x1.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0099.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BN0PR10MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: cd42a818-a864-48ad-44cd-08de05dfb5d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O3CTBKv3c2TmVXhuJXkWv+74whcLcFoDkxL//fjVm4MnalFXf4kk7Z3kPlZr?=
 =?us-ascii?Q?Rgrp//Jg6W+eBInfMEY8hvcWhnze9fWG/myqPX09pNBAyKuYeuy6OvAFTjam?=
 =?us-ascii?Q?+pNB92YqOHxI8wmjH4k6fR3uG96gq/yQYimzN7sEf9Vam9tW26QeGLNL+jF8?=
 =?us-ascii?Q?6t9040tD+/GgqeW6f38U6ZpqmVFPDrENOCEqmyDXMhHztQA4zfgIrefXPwfj?=
 =?us-ascii?Q?R3KshwA7itzSoGTPFrHO6pqCNSmAd3HO9eCvkNnyKx2BQ0+ecKiJf4M2HpfI?=
 =?us-ascii?Q?Xm8IGcE6Tc/aXrt6ZY/oV5wpaKhqYrI08AEvy3/8YAb7+u6cLRLzZzXo5A3L?=
 =?us-ascii?Q?L9E8RJ7f7GYHM6KIbfgbMj8ykh4cl1chGimTaFmWmqKmlTkSKMw/wEuRuTPl?=
 =?us-ascii?Q?k3hHaVgD8UZsSoOs/M4P5KnNQqig/00EMopl1rhAMUAFtGA8UQoCYcS0RD4W?=
 =?us-ascii?Q?sMthX0pnMM4+bGp764ekxBMs0W9ZRLyqyFXGR2Qv18w6CFM07TYmpohyOIKZ?=
 =?us-ascii?Q?TcHk3ewbLPAnAI7d/qX0UrZ1Ec7X7tORlCE/Dkj7wCSwFlPC66Tlv/1OaFZk?=
 =?us-ascii?Q?C8c6/y5g6Suh3tv7yvFhtwHEcOmU4AwYSgX/CRc6XblX8uEs62tiWAc6VJjS?=
 =?us-ascii?Q?C1FE8fs1U4Cg26AUmf4g0whS0+HyEcEb/jvoYkOi0gthXucrhZK1ZyNboqHo?=
 =?us-ascii?Q?kF94rxmXAKXcSllKZlO3gBO2uQSDkw2vHEiw6RIy4K6FEZbnPIJSoJ7g2ec5?=
 =?us-ascii?Q?vZmZNvoMUuv37/sEuknUvWNXCUd6zbBsqng60P5k99XXtYj04fJNMN3lS6IC?=
 =?us-ascii?Q?UYCYhiWm2vJn/RNBw6b4WzqGo3J0GUCogASq4yKMWueJoDhAx2tjUDWRH1JT?=
 =?us-ascii?Q?AA6FLsrfbV+lfLNnDn5Fz8lDdStY2wVsBGDioy3qqxQXr9sD60EmKer8ASNh?=
 =?us-ascii?Q?jMXbX+sgKmsUd2FQgpZcPhnrOL8+Irey2JGgQ8rlDUjzjnkEQB/3nwDMcPna?=
 =?us-ascii?Q?VHgn9KloSSr8XgKWKGmrJcX8uYMUHgX6wyOzcOkIthE68gl+tjxjsMdwLB+r?=
 =?us-ascii?Q?8Rq0CVGOQ5J7Aj+xnsuEoypI3z0mb3F6a59bRo0ySqHSOJ9NDXii2AR8AmMI?=
 =?us-ascii?Q?KXCWD4Uh0JEauN1tnfPGVUWpKPCugjhP/PWawiSU31SNlzcM5Cl05Vsz9zUX?=
 =?us-ascii?Q?BdByJmaBQHAUOuHBGZ5VN8oVdgRv7wmgTtXbasbS/2cR6LC+hUoP0sv1WFgr?=
 =?us-ascii?Q?eOTCI05REqvJgLoiJZoKg/eQgAPFwp/let3Qg0DHHpx7RILA/hz8t+iick24?=
 =?us-ascii?Q?R+StKv9RRiwH9JCzHuyBlxPT8idvgHGBMAy69ljajt3KYBmKWLqd5PiDqy2Q?=
 =?us-ascii?Q?B2+64LhWCyGmXfkwFH2VWDbbvoC5jFIncH6UMhm2JEylpI76RXYVRSWqOf3R?=
 =?us-ascii?Q?PfRt4wx7KbjoIFteUVjR8FQDssXlk4qeh0f4edYDsnI6BKBEJUdwIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+nXGKMmYzHkQowrVNNsw4atgq8wb2Qi3C6g51AkCTlLSiKO6F+S4qjl99wo8?=
 =?us-ascii?Q?nxon/KhSJLh5VnQHp2bULH837+ts7/27TwWSW/uVGiOJ7KQfFX4MSQz5lE9p?=
 =?us-ascii?Q?yEeFUuG+xe4l+B24Tp7tHHDJ9L1mBEq1CqrCpnsmNl5wd4rpEwsVT8mMRGP1?=
 =?us-ascii?Q?ahuZHuPJj3JnCI/S9+vu+mjHjoO2IWhLV5ULP3DQs8Ox/pRUX0i8u62Yx/1y?=
 =?us-ascii?Q?oMJvKIUXeYFkK1spaBzAtRPvi9Eq+NuHQCEDpCDCAe6mMl9QwNSlSai7HDIC?=
 =?us-ascii?Q?ZtOR40dpuJ+h9QhQrTVVG5UDhNnkqcHzd4gZmsLDiYjU2oRue3Cf/Tp5zeKQ?=
 =?us-ascii?Q?hjOSPmR62sM0ygjHzY97dtmWzzbOqtOlx7NQ0YH+cPwdpZoZ2GavaNrmCEbB?=
 =?us-ascii?Q?mG3ApOAWO51Lz5Y7oLpgItlEyCYsSM56+ea+uDnWHKixrqMsL5zUca2dG0V2?=
 =?us-ascii?Q?jnh0H3wbsFH406Y6bi6ugX6JsZhzFe2wvdKoykyNo426WCWMs8nuMmtV3RRq?=
 =?us-ascii?Q?zdYZWHJxvDxcGtQzbUEXqkK6u2mSheQG17gG/msBUC1NMcW7FC7OpkhbsU8o?=
 =?us-ascii?Q?yDtzZj0e1AH1i1MALQu8PdIuROTqyWQDeQrasCkANbFZzTLdIcZzoMFZMuNr?=
 =?us-ascii?Q?U/PdQ4z/KWpiUCn09RD3UxHOeBFC2wx/fjoHAPSwUpG2J7yV/Q3ZMfDPIbq4?=
 =?us-ascii?Q?T+9WWoQVJMHNnVtqdEqh7QTZfUZPk79RVrpwrCRUUEWbb4tiC7mwoSnXl9/x?=
 =?us-ascii?Q?ZwbW8jXwGBe03s2n9zcWcCztuIrvtrT6MWUI5uSuXFOqWWYa5kJuLbyQ/QJt?=
 =?us-ascii?Q?bus9Ko2qxiApOUaF9ke3iXXlfhGMhjTSni4pPYRCZmFIr5yYO4OR9rF3bWRm?=
 =?us-ascii?Q?B5gnqn1n8FsZhPq/ed/A6MRoQ7BAF6r+dFypt0vqliM8NR9JFi+ZY2QqsdyE?=
 =?us-ascii?Q?JKu2aZ1uKUh9oL1oTcPc2JibFxax/8NIvb9gXPsycupL8BrUnIRYkZ2sPV7l?=
 =?us-ascii?Q?0ylTwW7Nm94xk4NxXn9d3p6vC8+3WwSkFDXy5D0k7/eLiOeqcvloO4lSf0aJ?=
 =?us-ascii?Q?fkPszYQEpUMTxHsQXMuXo3STOr5XVPcbpHndDOex7rf7zI5EZOwhrOpobo5f?=
 =?us-ascii?Q?6V9lid6hM1PFt8Jc4GWu6JY9Z7zSx3PhiWUtmnlzbwcyOcP0Z/VvzFM7Iq2V?=
 =?us-ascii?Q?sipLqW+D+7Ko1/G7cNH6ZgABdcdlBsLbr+imZFamGVgTmQm9ksMwgI5QCg1b?=
 =?us-ascii?Q?NWl8CxEFE7ubEGvm7TT3tc3RP/nTXpqK7W70puXoamyoVUutNOlTDPEzhUxp?=
 =?us-ascii?Q?mzzmc/7gv6KGXl9x3n07mTYWggcNc76MLDS10/d1Rda2D7z4OQccrmrfflnP?=
 =?us-ascii?Q?qVwDibs1vVhHDQybGJaXlEufXUJD2FnjqsfTRg6LToD5VRywJP/l5r7v3Pzi?=
 =?us-ascii?Q?MR650n9VyK9SYulWmuj75gtuEcP8Xfa3IqzuGfsFQ7Gs1x74jmbnqLtedxXO?=
 =?us-ascii?Q?HqG5rpdJpOdTb3pCAHXYvFoKxYIpfQtzJaaQbr/7WfrcY2+ykd7FxsER6xzn?=
 =?us-ascii?Q?o4j8Kgcgj1+qXxFZR5VFClvRYHeT7oPutlcAh9qS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ySM87gzaaSiYvPTw510vPtkX7RhwYLsroyf5wa/yV2EtVkmhpSKrodbEpRonGxXfQw9zbTFXU5nZaHzzsPXnw0rHy2RoXSEfVCwTYLgXjVBoZUte9RK4yQm71F4vva3wevDcwrBQgulAbcOngbNwl/FelJzdjKXtKphIqDvlX3T6wVNngpLGCdtNtagYXvmTuhHu8Z5iUvIlpVtg68/e6UgTbcPAcBto0MDMEV2EHc/fThmugjN1cZGTdmx7XyzLzmaslC3E04l+hXKqBOZCyWPxBQnS0g6SDosqTsxtGgHOYrR1vUfijsXvHatbijcz2UnfH5FSpYUaN9vU/5By2vfEkbftEce+W2wT/F55jzpOl5RWo0RwtIdabAh42IKkTpPrdCvhY81MWmP2wPHrsWndaNa1MCvYimOBbrLwd4bvaoalSDqnh5jPyDIwR9jLY5MADSNmiZf70zdSXC5pxT564LV8FLIvq2l5wdbvEoObxh0HmuXfwtBJ4YxnjLwKab+0QGRjfw/t8AG1Iu+iktKoNfJ1xI//EvTVbxGK+WPsAlkoFrh8//6oqziTtxgBpK2phLvpP6hm8QjO4r/UD5MziLq74OnR70DthMpI/0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd42a818-a864-48ad-44cd-08de05dfb5d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 20:25:52.2334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4u4TDj949CvWsr45uAmZ2x2+RZqXAZTPuI8bVSRjAeMcPV0+dGDx+M+xIbfNMd17s8QSofgmTRt+eqqLF70J+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5080
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510070159
X-Proofpoint-GUID: ULFoKhGwhd3wcqT0M5pVplt4RtzhH8ah
X-Proofpoint-ORIG-GUID: ULFoKhGwhd3wcqT0M5pVplt4RtzhH8ah
X-Authority-Analysis: v=2.4 cv=ZJDaWH7b c=1 sm=1 tr=0 ts=68e57757 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=vggBfdFIAAAA:8 a=cWzZDOJZB3SAT8xF2lsA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDE1NSBTYWx0ZWRfX5pWg88APG9HI
 0a/iZ/k9GAn+HC2/4yOk5DuWWefTiN/ZwHmJFBZVGnNqiVjr2YrgsseegjVIpqyQQkCPGv/ABOf
 QWWQi+6mShzwZsRNhMmWJyEJTdN+daV/c9bPGOj/eSYO4RQKFfgnfCSCGalHCjzjbwz1WY4+EHz
 j7hlKwU3gAjshjIOMntZnexzOLVn4Y4jXr+cR96LdKnWGio+G+mbQYiw5vV6xZBHVaR7E/3A7Du
 z+5OkSyQWkAiYHixadIYOonv21yS3WggdZ92c4V0uwKTBGFh9CyWf+TEKwydQ41iPAtuzx/x5yi
 gHsNSm/m6MF+NywZ/IqcfobayIrKq30H4evaYbdTh9Cps+HeUc5ewRAjlXJMQtbYMZOkC1XBBTh
 /zkfE5u64k8L9cy85k+vCU0gRM2BUQ==
X-Stat-Signature: udpejcyzbbbf5qrzhqtp6uerffzji5pw
X-Rspamd-Queue-Id: 6601018001D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759868767-51891
X-HE-Meta: U2FsdGVkX1+FjT4PnHjXEoaN/2JxHzKpA4GKbrgkYchheULkcAWvwwI4EEusfpYPrB24797AZMTPDC12va9o6hwNYLw/tkb26uar25LorBPPe69F6n/OlK4pnL8+SBth/3IFjOsaMCeX6uVKcpZ2m05eed9FF7P1/rvliWOsC+TkUk4xUsUPzyRVretxEFsJgozwI1cIoVUOSyZhE4Db7rIOItZgSp6MIDgb6liCPdxzlFSH3gm9hxCYVf2pQ44BDvIXW011+9GqXPUi9L++Rvk7SlDlKTdfTstSXz+4B3nXMG3G7y68Z690grRBzmu6hvgRpxHYijB8nAbFH0z3U3Cr5C2kx0ODegK+ZBVTTbqv/qw6+N4sYqXUtXBVqnRApJkshgLt6wnAKpGUBcxgeu+xmkJ0bMV9JNj26hgAPal4z+7H8fPJBVSI3DSgufNURN+mdstgyUUc4kWi9cdBv6qWV2pQ9VCejLj0fnDs+vY6OecqGu5XVe14RVZ/sG5fZSJIzxCwW4+PIA1nZmvTtqzYxCV2tO34+vCn0v9bm4TbxDR5Sj8KAuyT11Cqi3u6Sw58AtwXKKnbwWAuqz50i5Go88lj9XJ8tqH7hyRtyZwlDoOhjddZ836tR8GQsO/hXjf6DKlmHZW9nUh1kuDXRMLHDJQo3UybSVT9l0N3DFxSBdLw106rrQIhCqLZwqyezUDtQf3injW7dZeGDp5w7V1ZoeA9LO0my8vN2KrswPJ2r4Sef530UYsuPumeGtnFQpqLidjWuy+8biEbK7dpyuYdfcOaLKZ6/PxzI+s3eO3HVe0YOiiiBjdCY1hWBX8Vt6UMizD7UOfZOLJG4GYIV9Rn0qviooxMjqQNos8Nfamp2HL6L7xfzyJbmAv/Q4/vfyVEdpNqZR4OgjDlHVkSQEvDY2ojc5k9qUfUWsRF9EmfVdQsXurdwtFEv/OcEBxHW22yNErfyqjmodVybkD
 bJqlvQfK
 yQdG2MV3tIEg2pk7l+P8dd0yZ/yb9v6nwAAM+HfWuK1gj3Mx9dX7estXvYyLzR+VJyxdDJsRAbFX0TYae16Tb5eBf95GEc6QxoygsmbRs/jYsAQaJs6254L90lIRaeg/mKh1/2xhFhwXnIp0UBS+ClxIRwjjlzIoftBH0+nr/JF04NgT7jLR9xvtKf9VjExUc3d0Hwy+7Gx1d53TGADaPxQ+W9frP1Vv9ukmGQdsiCMVd88xKN3cax04DsURQRXOiP/hgKwZqKZ+iSenM9i6SISK2ASmhgOWQ/6nVLj1SDrDWjbN94JoHQq9SLmGAXk+8pvxB6bjm3DUUUdZYnSgWyIEA1moc8zUWYGJ9equPDt91pcxdAyMr9RqL499KoWDPO2HAtQ6uQOn3slNUK+0Lq3Q8eBPG8YR98FWnkQSEM5z/QeGId12pco/CKIcn/Vii9E3pkaZDhc0KaGoXERJe1/jG1xmQhQqZO/Drvrju9Ld1reQEr87qgtegvp073mOMBLMnqIfmduMy9c+hug71nUq6xEFGTJahxZ7G6WqRPJOV/FRvS7gHJSdT604iNayO/oT0drq+AOTu9j+bVK2kh+aDOw3eYiQFtjKXPixIsmhOERUwCkwtO4Xzh0HB+8Rq0Btf5welBEQiUN3OT/aYXotb+1yMKheEflBcKsnd0R4Er2+AuhONrQ3fNKNBubX/yghTYFefEGCB301AimYl6BGMtgk7BAUCNqorL1wyehEZiLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [251007 15:42]:
> On Tue, Oct 07, 2025 at 02:46:46PM -0400, Liam R. Howlett wrote:
> > * Peter Xu <peterx@redhat.com> [251007 12:47]:
> > 
> > ...
> > 
> > > > > 
> > > > > This way is_vm_hugetlb_page() never really needs to be used because the
> > > > > function pointer already makes that distinction.
> > > > > 
> > > > > Right now, we have checks for hugetlb through other functions that "pass
> > > > > off to appropriate routine", and we end up translating the
> > > > > ioctl_supports into the function call eventually, anyways.
> > > > 
> > > > Right, it would be great to get rid of that. I recall I asked for such a
> > > > cleanup in RFC (or was it v1).
> > > 
> > > I didn't send RFC, likely you meant this reply in v1?
> > > 
> > > https://lore.kernel.org/all/0126fa5f-b5aa-4a17-80d6-d428105e45c7@redhat.com/
> > > 
> > >         I agree that another special-purpose file (like implemented by
> > >         guest_memfd) would need that. But if we could get rid of
> > >         "hugetlb"/"shmem" special-casing in userfaultfd, it would be a
> > >         rasonable independent cleanup.
> > > 
> > > Get rid of hugetlbfs is still not my goal as of in this series.
> > 
> > My example picked hugetlbfs because it is the most special of the types
> > of memory we have (so very special).  If the interface works for
> > hugetlbfs, then the rest will use a subset of the features and be happy.
> > 
> > IOW, doing the hard thing first makes what follows easy.  Doing the easy
> > thing first may mean rewriting the easy thing once you arrive at the
> > more difficult part.
> 
> In general I agree, but hugetlbfs is special when it is major-feature
> frozen.  IMHO we shouldn't design an API to suite hugetlbfs, but only
> trying to move it closer to all the rest of file systems as much as
> possible.
> 
> So the generic API should be designed without hugetlbfs involvement.  Then
> if there is guest-memfd / hugetlbfsv2 / ... they should fit into this API.

Since there is no end date for hugetlbfs, we should include it in the
design of modularized memory types.

And if everything is less special, the generic api that can facilitate
hugetlbfs can facilitate everything else.

> 
> > 
> > > 
> > > OTOH, I generalized shmem and removed shmem.h header from userfaultfd, but
> > > that was prior versions when with uffd_copy() and it was rejected.
> > > 
> > > What should I do now to move this series forward?  Could anyone provide a
> > > solid answer?
> > 
> > My understanding is that we need an interface for memory types so they
> > are modularised, with the short term goal of solving the faulting
> > support for guest_memfd and the long term goal of code cleanup, or at
> > least don't make things worse.
> > 
> > I think we all agree on that?
> > 
> > I propose that we need to add the minimum amount of uffd_ops to support
> > guest_memfd's specialness without creating an interface that makes
> > things worse.
> > 
> > It is very difficult to see a reason to pass in two variables (modes and
> > ioctls) to dispatch to the correct function in a struct that could
> 
> The reason is "modes" cannot directly be intepreted into ioctls.  But
> indeed ioctls can be intepreted into supported modes.
> 
> > simply point to the function in the first place.  If we can avoid that,
> > then it would be good.
> > 
> > Looking at the example you pointed to here [1], It appears the minimal
> > viable product would need to implement this:
> > 
> > uffd_ops = {
> >         .get_folio = <>,
> >         .minor_fault = <>,
> >         .atomic_fill_continue = <>,
> 
> These three are fundamentally the same thing.  As explained, if we have
> get_folio() we don't need the rest.  However we still need something to
> describe e.g. shmem supports MISSING mode.
> 

So encode ioctls into this uffd_ops, including a uffd_ops->missing_mode
and set it to NULL for all but shmem.

Without digging in and actually doing the work, I cannot really define
the exact interface needed.  If these are all not necessary, then reduce
what is there or expand it until you don't need new things defined.

> > }
> > 
> > Then shmem and hugetlb can define these and end up calling them in
> > today's spaghetti, but we are free to append more uffd_ops to reduce the
> > spaghetti later.
> > 
> > If using new #defines to clears up translations of features/modes and
> > ioctl codes, then please do that.  These should be removable once the
> > uffd_ops grows to support all necessary calls.
> > 
> > If there are places where you need to consult the modes/ioctls and a
> > translation does not work, then you could add something to uffd_ops that
> > is NULL for guest_memfd and use it to determine if the code path is
> > valid.  But this code should already exist for the other memory types.
> > 
> > What does everyone think?
> > 
> > [1]. https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/
> 
> Would it look better to you if I drop uffd_modes_supported, deducing it
> from uffd_ioctls_supported?
> 
> I believe that's what David mentioned very initially here:
> 
> https://lore.kernel.org/r/f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com
> 
> I'd rather go with the two fields, but if we're trying to introduce another
> feature sets almost only for vm_uffd_ops, I'd prefer keeping it simple, and
> deduce the modes from ioctls.
> 
> Is that ok for you?  So it'll have (1) get_folio(), (2) supported_ioctls.
> That's all.

This is still middleware - a translation of flags passed in to figure
out what function to call.  I don't think this is the best path forward
as it means we have to complicate the layer for every user we add while
we are already providing the most flexible return of a folio.

This will end up making things worse, IMO.

Think, for example, we add hugetlbfs_v2 - every place we have
"if (is_hugetlbfs())" will now need an "else if(is_hugetlbfsv2())" to
accommodate something that probably has the same uffd_ops as hugetlbfs
v1.

Why would we do this instead of actually making your uffd_ops a complete
API, or at least a subset of the API that supports guest-memfd?

Thanks,
Liam

