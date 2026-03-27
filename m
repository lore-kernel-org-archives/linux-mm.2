Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB9810AB838
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863166B00A7; Thu, 26 Mar 2026 21:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839C76B00A9; Thu, 26 Mar 2026 21:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750596B00AA; Thu, 26 Mar 2026 21:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 635B26B00A7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:45:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D7EBE1513
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:45:38 +0000 (UTC)
X-FDA: 84590151156.28.3C562AB
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id 748A3C0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:45:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NJ58xcq9;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NJ58xcq9;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774575935; a=rsa-sha256;
	cv=pass;
	b=uYGu1IWPb3pZD3EcTbvVdEIOH/ewsyZyVhADMhEvC5Tw9+LXUAQu+Mk5yY4FJXpeF+xcOi
	ooBOASwnpblBNMNmUN3ChaxQI9/NsEWvR4C/Zy4eZnV+BEP590F3spAEqwr6Q2JFLjiDw9
	0GuxAV2x8J5+p3UmJJCMLyTNAOi7B0A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774575935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+HC3XRSMhUBoGzAwri26E5aQw8VzOyP1Ks5RR/GuQ4=;
	b=blI4zBJmIkhSgaNoUY+JgOh1v2kkOPa+Yvs0os0FP2xCNaTwV4Az4JgbpcIvLYGNKIq8sx
	iOr8LGLW/jvFXUHDFBJUhSvTrNwxlqwOl7IbTR0ZRLDYoFXTY/Fegq/e6NjFJpLjvgjEz/
	z53bpNUMywcjqfajjzEL+h8OXWIXvSE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KiGmleYSRDinvWazzNy2RSi3CGMT6FP86K4ntjaRFosWI3qvFjqzppORYpyHyuBNjsScdV31EZQ//Pq5daC9VlElnNiag2dscFWbLu2HtEOPuzTmX27jUdBk1yeY+xS/apl0pUUZg2se+8hIXK6bF2Z69IpdEyI1xcwkyCBI4/dvkSwHqCLgEm8D+Ff9p9MtDorT+EYs0K8qnAlq68QNGhGotnXEzP7rYN09XGF7MGsBVvYO1Tn5g8fNu20CR8rksvnQZfySYV87OKwPqSV/lXErmLAv9xYaCKgYaIMygzDbmhVoHo8zBMBNjPcg/U7Ycgya1Ez6UnkMH9jbM+nuyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+HC3XRSMhUBoGzAwri26E5aQw8VzOyP1Ks5RR/GuQ4=;
 b=XAbc4/QcRFS6XA2KBxazsSnTRiOLNc7p221R5ULxn3vdhEMnebwd10PAVgyeix3cxRM+himoAc0/Ysh4Ui3XxOI1uKqiFRYywsH6vYu/f6FRi032OjC+FTqnh3byx7vc+L41l/dMM1QOpmWG6IdCGEv0s+MZ/KGAbSC3nAjXzDTkOE0CI4qKog8XxHKUMF/bdXZ6mBbjTALlcBOd6dojtMa7Vy2xMCxlvHA7iDkLtoEHLuOriXPfaGX7cy8PzssEzwqi8Ba4fnS4K6Iwzs0kQXULXlywmkXR/HFkxD8YqnxhmQM5vsPPr5FU9V+gXcdG935DOdhAqVoYvXJjfI2LdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+HC3XRSMhUBoGzAwri26E5aQw8VzOyP1Ks5RR/GuQ4=;
 b=NJ58xcq9o30ZXA8q4hizHfrJ6wZsGEFRxIvcUkKeX39s0uhUA0R8PqZVYYdqe77Y7ektG+YTadXDEGKHLKieqMVLw5REU+dwWt7R9xvnLDlkZbZfsuUwghkiLaN3+keneC5K3wWcSDGe1i6I5h1e7A0qOJrtqQgCc9StNCtHUSZBI/7sMZzHWA7YDGwomKNC+aVoDUgDpkAnNrJrU9AGwdxxjUtflRUBsrLzFjbQPPVKTrLjJH9QhTS7NhZUDYuO4bgZKguWSiQcYD7K8Ia7R/nKRLyaw+d56EKIXX9BPcUeULGW8pRrPuicaN17kEoIXtlnUlTAMHqrbae07J/QGA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v1 08/10] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Thu, 26 Mar 2026 21:42:53 -0400
Message-ID: <20260327014255.2058916-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:208:23d::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aede310-12cf-47cc-cc96-08de8ba23704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 vMQIkhgKWoYNHr5LNKTbVwd2xVm1ksEzJz7KIY58ABK0/1oGeO92VoNZpEZ3R9NJYz81v3F0w9O78PK7pDpeTo5sfPxmYgRVI5diQUyyFXj3SAKbXbUwnwi2Fjj+MIPKu14Q7D/Yqio9xurJe16YddGdUs2VevfhgnR9P+oF5n7Odr2rLnyd2N8h2oczoOa0lZuLQMrcx1Yd14rokCLk1G3ZFeFGLvsGR5wxBtoYdgW5VpZOkYiCKFB+x7HNbyycqLUSlhB4ip9rm3s6mKmZ3HpbOIKc+GlWtey4NhgFzRon/rdKK3xUFe7tKgt8+uHKCRH3j7PeTxIohP/AgNHlRsuijys/McNT+JEv58VL+4y2IwOnRxPVyg1Rj6bb3JcK/R4pd0G4hxa3s8yme6TpPec3N+ygdvCvjislK9C2m7dkN8DfhDMSKmkaBIglCHv/ckQRbCPXlTa4X9byZ+wmn0uhfSTZBc3w3+lqErX0rICft5n9tGvZVx6H++cFPlirw1mCCKtYC9qiq0zhYgUfhH24x5kMfWWGf5IjOojXki7ndjk2S8NZylJbKcp/fFdS/CqqpySFi7PX+twNGghYs7EXZr4izVtAa9QVFkib5KBWMklTOHWS951i8fXsITelwqYyNnaZGwrP9aQ7pc4UBd7UooH2W1p8Pu9krntMiS+ONcKhNK/qOGD5TnbT2+2x7tJpHrEzV+dfPlMexG1uvAyxy6V4hBOsMFD4Dsf5pBw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?UCXJy8ONDP32eK7tI0YTQr4qPSwc99gDZekxXABkZXHAV7KcjE6NcvXra2Um?=
 =?us-ascii?Q?tBLRojJDZL+8SBDJI+yIrGrNggH2qgPWRHnQCJ2H6Be+DPTHhSK3Dd9PgkUh?=
 =?us-ascii?Q?VLlY61JYedkUsQmhsJ3TmwH5u27wOfcSR+mfAUa5noFcZJJEmvVQgPhmfyG6?=
 =?us-ascii?Q?WkPA9ArD1+idfICvO0UqfOxtsCUMA6w99UaFa9ErkKE7F2ST/PbZZYxw3nXH?=
 =?us-ascii?Q?IpCPVXh9gPmTiYdYZps7ZWdGK3qb/2lbGHvdTawfT8Vim8zu2+de5XFcYQEo?=
 =?us-ascii?Q?T8Y5w+mUxLUcfVrFSTTzAInJuN31BDWuHYwwK68lafEGNA53KCjOo0d6qk4H?=
 =?us-ascii?Q?7V57Sk51ddvGP/baFE3Yn+kUSI+ekxPkantbUHFGnuaH3GsyvX/G9dBgf/Xu?=
 =?us-ascii?Q?JkdqqKwqCXIluUSnmZHMzoyR52tHwFjpXE5GsYTcIl5XjttkvMCrEa5mVIED?=
 =?us-ascii?Q?sUX/ndBrIos2RoGmDjheQex1qrGN2J7NMg++8diNKQaN06ciVr5J798CkWVE?=
 =?us-ascii?Q?ogiFGEEv7VzD20LrPqrREEDw7n2V1XyaxYWraygUvk7aRRXRopNUkWzwGs7g?=
 =?us-ascii?Q?P+YD7Lp/7IeSNyvpxPC0eINxnOngU2SXzNgnJsSzjaYOr81uNtViEviLBfQ2?=
 =?us-ascii?Q?qxzjioyvx0qLC232uokNo6/1XYL36uORqlmwVfJWQxB9ysgOtm1m4urbg+IQ?=
 =?us-ascii?Q?k195H3JxWLPoJ874iQM3jfzUs70ypma7+MdQ/mVqsNOYQSoHXw0eoVpsJf1k?=
 =?us-ascii?Q?xSYN991uyavwRNr1/H/IQgBdsk8Uj1utEraLw+pSxHQ11TSz8r4gaS60F6/q?=
 =?us-ascii?Q?BCBtXc9mSqLVTD14xevTsbrqRcLdqCoqz6KbcvFBQx2J8UEoL5aYFB1WcpFs?=
 =?us-ascii?Q?Mdf3LdHNNXCr+2YxXBr10Fc576m96WNw/figLE8sBOrxGe1hsyAIFK/IB4M2?=
 =?us-ascii?Q?RpZIjYUB+ArPqvhCDJgvq/i4GxeCW5urNyn1yJT/JBl3Y8AzBe/K9Ux4lIoc?=
 =?us-ascii?Q?qTynffZKxk2K6U5UdtqvviLqE1DIt7f4IQwnJg8czfvbX+jEnyXc930Npg0c?=
 =?us-ascii?Q?JTM31ozVat3MW/OTOMumaNqHxb8w3ZjRrlpLILgaNKbxmWBL/Q4CvIjtSWtg?=
 =?us-ascii?Q?4c650UgN6e7Qx5RfjeYul32hAdskr5E56354iPHXhKVap4uHhIfJNvhusaYv?=
 =?us-ascii?Q?JWelVWrdfOoWOZry/FDa8yx9+AgLMx2+gnnNVYCzeTyYEE5QeU1YlgtbLuGB?=
 =?us-ascii?Q?Kwcco8bhZLl3GQO2rq1PJqemuGo0pb3XNjBPu1zNJ4s1M1pZrOynIdWt25uy?=
 =?us-ascii?Q?ezVzsUwJCQHmqC7w6Dnl/zK8WrWj0GkEpIqq/WfU4n/bY3qIFfUGIjqM7OSV?=
 =?us-ascii?Q?wt1cuIEOf2aHpp3PdKU/RtiaXDfJcQv0jppFkmhjwOO5DPJSRNKyHTppHv/u?=
 =?us-ascii?Q?NdSUA3+pJ0fLcGPoBAqz3/Z3DAmUYdy8xbjqHWAVpBwfgO5DmQ7uCOkSwKsU?=
 =?us-ascii?Q?YnAmNA2gMCLDQU4vfscNfHVmIQnC1qFh+dk2+IBxCo3aQxArFvtB2OENJb6N?=
 =?us-ascii?Q?GuEaRqAf98oF+5xpO25QZiLqyHwQ94EYTtFsTp1MXwkJNS7m4619BA3V69LI?=
 =?us-ascii?Q?7dcAYSVJDoEvJhJpsC22SP55l0EgnHAYjJAmzTvEaY7E3QujWXDQARotVK/+?=
 =?us-ascii?Q?YX3FCeQOSOHv0/45yY7EPpheygP139vi4vVMyUSaYm7kVup1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aede310-12cf-47cc-cc96-08de8ba23704
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:15.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tuc8Nc8qT5NcjAj+DKp47f1pzQkm7ElgnXVgO/jVU1lu8TmlYmYBJgD2UlFMaGKZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 748A3C0002
X-Stat-Signature: ip7dw1zikbygsughi7cjtrht3knggekn
X-Rspam-User: 
X-HE-Tag: 1774575935-400400
X-HE-Meta: U2FsdGVkX1/WIad/VPKqZZzBNkV8ql1dRxpiFkORypq1+MQVD3MXotugjXllJEcor+JcRMvUyndr27G//B3cdxwxYgZ+ZFR/N1S+HdqdhGL4ITnoPUM5o2dBvjAjYWCJZFwjq0CWBtiEZ1AEmCAJTeoXWTeBCLpQjpXwZ+aGSpKuxIpnHs2yX8dk9KVKNP/jUyEZdx8mOc2n6zzjD8jY82ukCS05YRr0FfvVz4eKVhdPOiYhbsBE5VX34epOkx8ptjem9bvDNFUan7icCB1yvw+/UmpW5PTRQShGHMdf34RORuGAtkal1wL+mbBImI4YnITzddaxOlIhjdQXiOishofPSNcM4vRmxjUIf8sq4fbrkgfoQ0NbC9joTp1RW6TQxPP7fkqe6JMoOz+3xA6QinTIVIJGnKRXLEpWmlrI4Uy2dGhJ6Chs5XP4wdzA2htuqw1aalb22QKwQipoBQ9d5Pz/t8Bpf6J3krv8lty9k6OnM/c4/TFQgQPjtRtFNUBdBmk/gvsSyfJ1Ou1vPBXgF8u/gkbobe/FsO5iUL4z56yvQXIz10Q/bEeSP5FwUjleFFtv08LJqUHi+e8o08Rz96PfG//kXAOBu/E1kawI6AGmgQ5UX39szZWUBgUkg+e+d0viom2Tw1K0v/ZKNSESuuy87W41FGca706kzrgOeXnmJ5JiBLn4N3PhlnGEP/vA3OQBuiqgRKdrwYnprQU5/iC0/TjdboNkWhRoNUJhNwfvmQ5wehBdjmyrxHOIeZrysDaM9HsPKFm5TQoXLGHa9JZRTaIzJWNOuRt/9fUun8h67uMrFNMrREn0G4K2eDnBtm20jTZ5DFFXozHel28L7jLzcvlqSnlQx1pLgE5WcJkOYSTGp48CDmbbaEiiPuM8bph1zHWd82tBIUSEybumEll5wVVMav/i6G9qT4irpZl1juCKFEvfRDxPaoLaJOAKrLxvDVkp6ONmu67MoPj
 0MsjawLU
 PWcIiJb7cykvIKMx2dKVRr3aIS8+eqogZzlb9x8vDSFTb/HRWPZplvmJYNTdbBEWJZkzcTocgz15RCER7Gja8DBPKuM17hPlZaskAVY/nDmhxCg8Pryihl6WX95RDcJ3igOhl3QIcp6FXqPotDvByIs1+raUAWOW3tq61KEZylA+vCOKqwF1GZr2ZjsJWs2yVIg7Ig+eZMvpz7CsiH4lk7cg7GNxjBITyWdae/eR7meZb1pgi9N4y0bsUkCI1e7DZw2/5t5IFVFp6c4hMKBtodE9+8cFzOg/SrwKdxwoniMn3VEslG/c8A2miM1411pDQdVOSjK4p/5Fh1wDvuM4kMAgXc1hTtbSzGfJiTfz8rgk3DZ7uWC+zfzUy19v1V13+evrK/xl3+lQCHsZ2+6MNrnTqdttJXfTnodIvTvIvzTdIKC5C0r7fmOh5MZMpHmcjt1PFSaGY7AOdYho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4..a8d49d9ca981 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.43.0


