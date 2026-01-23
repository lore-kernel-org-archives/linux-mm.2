Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BBBD778AE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4DB6B055A; Fri, 23 Jan 2026 15:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0236B055C; Fri, 23 Jan 2026 15:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0996B055D; Fri, 23 Jan 2026 15:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCADC6B055A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:12:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0F9CC23A8
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:51 +0000 (UTC)
X-FDA: 84364326942.24.EEA892D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39249A0005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bWWz9F19;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dsPzXDRY;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLbZr34JiUIBapcFS5ocHNpSQXz1NqrIgAa6UQubWMQ=;
	b=Wn+5WE9QsgcYBJnYYfXXR1+Xpax2t7F6SyTUnD1Ij4ZOg+o+fjGR3dtriJ93yl0NxPNCuI
	WqaNmmEl7Ho41K781zFTm8gf8OCmblCf+Gk0iuaCyLE01TzdN7QjpRi9oiD/xQX4mwEQR4
	1epQhVt5rWuFF/DMKOIGxWfnCcjQIqM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bWWz9F19;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dsPzXDRY;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199168; a=rsa-sha256;
	cv=pass;
	b=LorSok8qxtAo8i9icXGdPMdcHHgHNn7lOUy8jmyDeHwHVnOa9/ulfQLdhs0gREYKQgooUo
	t8f/YDqgIt9i2kWvN6LReoJ+4Ri9DS9fp+8QeX2jwUO8XHf8KBsaMiW44TPcdA0J0NwYbF
	fg8njFwNl/qUdfWXAoPDeYG6c+nd7cY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NERYfb2172868;
	Fri, 23 Jan 2026 20:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dLbZr34JiUIBapcFS5ocHNpSQXz1NqrIgAa6UQubWMQ=; b=
	bWWz9F19gY8ZeaOq4N+sNy41il2Yz0xnVZsfQVBjjVy4/6FV1bTiVF4wI43dQymY
	clwc+WBxEd1yWk29lXM1zltKEyu4BN0LZVmqcOyEdqfVECjLMTFs/gxT7BrXFG07
	tXVYx38PhAcibZrJUxDtDYicckIx9tyLdwAv7MfYTC/qpvYcLSIabHS3eXSj0tXm
	9uln5QBDwjG4JBWKCRD1oJo8+92zgJe6Ffm9NYo0y7Iwnf43mKaZgIStqRpfszcc
	Dr3FlFuQhd9SUe/lVsG0HFfzbONEfBx5l2uoBszXVSEUA5xKegKBZc+KkpN+f8g2
	ZygpY8iIqE3oKRue+ejsEg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd7k7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NIpV5E022490;
	Fri, 23 Jan 2026 20:12:39 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vjmgwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2bzRaGoF6YB4+iqBRxH96RpNClCYjQw8inO7WjlSguK2FkSVglgX8HnetRZQcSFhPkpWjz46fJgyvCf+gbHSR6TEmCkMhMUym045unRB28RH3EP4sTl9HcYLVGW4kAtWVJ65g1EuwIif5Ktmv++oCbdTAqdNK+dxQH+KsRlI3q0Gvo32aSNjXeiX4nYKGawB4nnUph0rPHUoqYu9vdvAKBStflncU+IdIRORKKRvT0Z5cTxk5BJ1IeD0lNmH0zjLbyUjeFbYrZEMBLj4/YJbDOgBjsz0xAsITO0BaJXIQGh+V+zUCqYTrDeaAMLX6sQ9LisbQedq5AJ6HBkBbUkGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLbZr34JiUIBapcFS5ocHNpSQXz1NqrIgAa6UQubWMQ=;
 b=kLchPMidBN3hxSNVZENETBGwY/36c8z2813P18gDWd8Pu7CHcSI2VafUZTfCSaXz+2+r72sgwTIvr8SdMdI/t+EQf+S8UJcZ5sZlICCAdY0aIm4WMuIm9VfgdT3U7IX1+BhfNDiwdwbuOcZt1hcaFuuoRIeUdXXZNqAuAMd5OvPHSdfj+4j5jLUewNDworpx9evUf2I5LfxKFcYi7hyAf0CyLtxDkQcV7SxcFyIPihTwjuJRdN5n3BTd8vDWPMZf3xdqjNrRKRyjl1PlEmpdcnZoqK2G68jRfgKK3xdUFv4+X+K8i14i1MX3ok+dgx2Cd5QtINCb7gZ/s98nUae+6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLbZr34JiUIBapcFS5ocHNpSQXz1NqrIgAa6UQubWMQ=;
 b=dsPzXDRYJDmTdQRyYlcFBUdVLiqNkq2k22fAwkv0QmQPSFa+XHa86btLQxsDvzuPLia4IAR2PioGUW1yPZr1otHYGwUUI5PTFfxKHkGYw3kwRIo0Zq++xbs34ii/Oz3GlXnNsiNnPH3x19nVhrFdorZzwhgbxxUKWBF9uXvmfPQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6877.namprd10.prod.outlook.com (2603:10b6:208:423::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:12:34 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:34 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v4 06/10] mm/vma: clean up __vma_enter/exit_locked()
Date: Fri, 23 Jan 2026 20:12:16 +0000
Message-ID: <33273be9389712347d69987c408ca7436f0c1b22.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0133.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::12) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: 828bb5d2-a183-4a71-5b35-08de5abbbeb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nv4b5MIKOnJ1LCB+muTmcSBCyAHZ+WrtmQ5T4Y6ncIgaowX1CtDs38gbTMyJ?=
 =?us-ascii?Q?FBXHDW11AUFWSf9EFE+WMyFozejCoVXjqcRLmFa/v7TsOWxm/GJLCXsTwenR?=
 =?us-ascii?Q?BhsKWHj/Kpwk2ozdglA/nGI+yZYRWlBWV314WAdOIausRPVCXUMtW40tJg09?=
 =?us-ascii?Q?cbt5BoGxarIpMdOaZltrsoX72kWcaMr4TMtHX0WCgVCVbThS3pm2BJglCLR5?=
 =?us-ascii?Q?nWlvJOPVaHpan/3H5joJsJv7rviNunxBalUWy5MuHN1iAxCBEZ6TnudqymwG?=
 =?us-ascii?Q?1t+wmhcKsk9radFBIoM7+3e2cGIuK2+pD+dSlFWDJjAAQy1RcjZdib4RD4wi?=
 =?us-ascii?Q?LFHAuUB90sGCWGa6ea8UFbsW8W58E0iVNaV4McUcj8KSMl7gtkJYrgW5HCiT?=
 =?us-ascii?Q?2BK0t4DFQCshJSSiG08OIFeOC5yg71brDpxuXJGhUyAvNjx+irYAY8DDAySI?=
 =?us-ascii?Q?+0ugiYuet66y1tVvWwEcS0RozmpRlPRIb8KA8pGwRwswV6nCVgRlHuYpR5Pe?=
 =?us-ascii?Q?xVDJ+2EPeIroBO9C4p64O7z/RQJYLRQuPYX6siPq5FHJFEDFLhBP/B6jLOa8?=
 =?us-ascii?Q?v9IZ72347tLTHri0BOXPVVIkTtbOZ9dq6FrYgzEnfQsMH/stI/bLnuda/J1X?=
 =?us-ascii?Q?AVW1povHFiTH6er7+lDyrgKnfW7Ky7tQJGD6sas/9kqvwfm6WRBwh0EQOpkU?=
 =?us-ascii?Q?/A2tF7nP+YeB5cOsEv67zFiY58cG1jmmWWDr5/ERU515anSA7ErWFRzJic+r?=
 =?us-ascii?Q?n2ythewxRu2z/nbMwDeFpPC2pwza5SBf3ivITD9+dg0OGCIk+KUaZ1DpxlKc?=
 =?us-ascii?Q?lUxNo7YkPkOA1ckt5EeBna/K2LMV0ogOMAwf+VujMOll1XKpafs7mM+FTJPi?=
 =?us-ascii?Q?ETZGhOdhnNz1icx5s8RiGZyOx8eKIhpM0lfRY/P0apMao7i1rZE4Yj0ixaoV?=
 =?us-ascii?Q?NInzaNIkDi3F8NRez4GNSHGZZDDkWWo8JNmRysO6pdEtgGwfr2SEK2tQ4Ykr?=
 =?us-ascii?Q?5YPsoTsJOvlRJ8gEnJG0hg9sUln4FgzDORoMNUByNxdrZGkIbI3agOx6tbAe?=
 =?us-ascii?Q?nLb7ermU5XiMYNWOlc/YDgner4iLI4lPXXXcIxPeRM5MxDsFl4EnO3lkQsXx?=
 =?us-ascii?Q?kKKy4yR1bJTOp4rUN+1HvG7lJVnFo14Hze/3O79+lrOtLKoSvGej4/RT2QW9?=
 =?us-ascii?Q?3d3DsJPCORZX8UYiOjVm3m3xCW9tRiqYIHUraBsxxCK+Kbrn/cVs7RSa4loi?=
 =?us-ascii?Q?YHwSZSY14uEf24W9gK/ZdA03CV8n8p9+XWWyzSdL/Kmly7kf+ssvuyCt0V+T?=
 =?us-ascii?Q?4ZwyI5/ATnybltdaIVRcxCiLY6rMu0fIcLcSfGSBbuFjUH518JH0WbEgajnb?=
 =?us-ascii?Q?U6aJnugA5/iDCOc7g5/RyW0JVZgAsh93MDNsy214nCYheVif03J/uk+2XdnK?=
 =?us-ascii?Q?H6oXtHs0zCTr9/or1D4bNAay6Zcn8Szn8vw7y+KWeXKROcu/d1f8LlTUqZIS?=
 =?us-ascii?Q?aHXeEVAzKZ1NluIB0rB4alhKmJHsgP4/AsSwyr0XTnsbuvSXnko5J3RhR22h?=
 =?us-ascii?Q?Q3GVt8Als5SL4PCLW2k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FtVUGwejQzCHp53dLfiyTEKs7SynB9CDFrsTPn+dCa3YQKjt91QhHpf7rVm2?=
 =?us-ascii?Q?73ZKiJ0+8LTYEHxQjGrnBbtKN0iWi0jAOZBi0hPSvYNLofPnjecby6TPNC77?=
 =?us-ascii?Q?bxFQ2NBpCUbi/9TEp0D5NjEM/H5XUQlVWPBdy6JL2stopdKJDLf4X2hE5x8p?=
 =?us-ascii?Q?5gTLNSoYO0vl5LDvLvtIrCryo2jzsWU7SU8fg37QvEHsAp1OTmgeet0cFw8s?=
 =?us-ascii?Q?MT7KAAgjup3ue2UzXhP8m9DbG2flWtZgD94GyS6jBS4p+23oWZh5lPIjE7E4?=
 =?us-ascii?Q?N/qXiLJA2xwIipofbTfXhkE0jldL6FK9b5MLUXGCwUwhQv1z0ITltlylS9F/?=
 =?us-ascii?Q?Fr9KUYhP7edgEPcjIafka7klfMvmNyy0+tXK7BYRrjQMDrOTntfjOQBL/dHg?=
 =?us-ascii?Q?z4iiN4y1q88/4CeAPq0eDiDx5GcXsVTVu8ceWUgucmm8PDw6QilMHcb4n6jI?=
 =?us-ascii?Q?cIRyB++SmYwbKKEQXrfYDrc7HE0OiYMEJgx+qAzoRBD29s7G0bI7kBRLMhCE?=
 =?us-ascii?Q?eup/jgawi1V8wO8YhvitHayhopR0XH+N5oEpDi+3XIgr/ZFg5HhPGv1tGtry?=
 =?us-ascii?Q?wBJhRwGdRiVkSZ7ZIDGuOdQX9O3Co1ysVekTRMmvhtWO3nSibkDf5BGDf6Ww?=
 =?us-ascii?Q?+uf0F6OLHx6vPInsa3IU/fNPoQ7vD1i33Chh3+wTfrSo7QwwvyBrKDH7xWeq?=
 =?us-ascii?Q?cZvrhA54YMoLQpOadjzBl54RIP0+37T3ulttljysTKzS/cIsJ5342Vgv7GK2?=
 =?us-ascii?Q?xepMKwLTDBZ+RxhKrVhVdDqdrro0K/heakd+t4Km1PcH2352KKDlZVRVBrPr?=
 =?us-ascii?Q?AvUnh5XQnta90rtoucbo339Pta3iiH+gP5y9wyLRsno4glkRYp2+CJSCwVlg?=
 =?us-ascii?Q?ONv+1/hJaIMhPDKxLJGBNt4DFYvH6EkeFIP0NsgXnDZlZTSWWX/xjt4aU9+z?=
 =?us-ascii?Q?iKH4vc0zVnGu6Sqpo0mUgmpo+j4Gc8S/0UgOXZprzBJS6z1/ZlmY7wD16KDl?=
 =?us-ascii?Q?q9F3V+BPoyEtUaxE1AfTSbLTq4RhGrH+HftAtgbqLVRSRYjfHEVO9LGjJKE3?=
 =?us-ascii?Q?bx0pm5fOV2dRTfIh/fKgBp1wdGHasrU8iJA8E+E6DqCAGz9KpnRFjvZklJ6S?=
 =?us-ascii?Q?4pM4Wy1xQGZBQAGf/bS7BZS3kb/qsbwBMs2E1JPYcrpkckCCVlsGOo7gOf1a?=
 =?us-ascii?Q?SUzV0Rvnw2+0UpFre1MNeJj8f6bh1SoUfkiyv4ArlPnBbjBDDFNiFSajMrnf?=
 =?us-ascii?Q?oyGncKny26xNXa29m51DSlwSaKW/+jHKDs4YZcOX5s7leLMujBeP+k1V7pxC?=
 =?us-ascii?Q?67sZy6vp0Lda6Hf4Mgh2eYuWW9bJoPTVdYl++10K87AH5hfGE8tNcKi17fYm?=
 =?us-ascii?Q?WxZsxqAjdbR58O6bZpCSd+NXNE3VsaNN+0vyJs5WAl5edkMUE35t3B6gJs5e?=
 =?us-ascii?Q?CyN2867QK0+DKzhDrfblz5up0q9RcEvnYaH7J5Tfv1UWxf/miiIVWF+fZYXs?=
 =?us-ascii?Q?wwAWFN9o4WohY54SjyhgWs5ffhbpdgUdd38+dK6TXIz3zcL0Us25rQ8DPzGX?=
 =?us-ascii?Q?TAxmndAGCnIlZ0lb6cULYi/+sAfOvl65N5RQmoyuHE8xAusX58qfYnJZee85?=
 =?us-ascii?Q?mGy1ovtnC0CWYD9MXjFUG2tbw6ouMtyYxOhQH4VEfTWabrCSeo0Ua3wIPkTV?=
 =?us-ascii?Q?5PTtDN94U7MF7xbDeyFihnelu1RZcBydHr5U5/7Hh/p9jYJ0/5Yu3vl6xvK2?=
 =?us-ascii?Q?iPnciwNkjGkxww145O/VEQgi2gWOl90=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kt/9xDdm6j6KBN++vxu0K1hXgs6jurYFpA5/yEBNXVSRluXVDvqMh0QNbPoOHlt4M6Qu3WSfBUWk+3Ok+vvOi6U0w8PNS14bNMXHnW6+xV8la8gHO+8o7jBuo8pZr2OCRUogFbU+QzhyKTRZX75/lez/Ll9tyfBCaHpo24s6qgtPtNnDR+IlYif5pOxBq/deW4hUOfX8TLaovNHZFUKw8mWM6U1LY4Ss0hiABWn4EPkaSpY9Y2SCqplaNbufnLxGIkohLRLy/Sz50lNhmhBm5UfbjS20/VM5uRemdJoPnbRuVuqV9umVCMJ5RT+okKo91CsXPEVu/JeHYeSGFhLqEKclRmm+hoMjHXd4KK8Yzs+epC+E+fB+b2vrlLi5j2P9QM8mthNnLY+UkW9O0bywVvDa0BcPv/ekki2s2H48WS+q+EMlsZZW3kEJ9JlTa69zynyRyzn6LER5Ed36MekVj2RK852zr9X3r09vvHxSWZ+DJizvC5JIv19r+l6rWar9vCdhc7FqFGfOAri6Fmb/LZ7h5yt3uXtDEhL5sgoU4I/AWDaQB51D3vea0VjzMEKXhTnCnhRZ5G37Bq70E7BHWV7y22KbO1omfl4EpXkeVYM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828bb5d2-a183-4a71-5b35-08de5abbbeb4
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:33.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YBE6TdPrAyyLzzaOchH7lEjbop9gmgbM3v7fcD6rzDoB3rylnxNT2AzGrODVvfgA8wG9wAPBQ/oUmWNjW2F8VGcuPTqhdZ5ri5syQZVrpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230154
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=6973d638 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Qfc5p1S1sjZ_rCI9KBYA:9 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: Bsrpjnw6NCjqnyql6Sk0tZPAM0MVbapA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfXwnji9dIs6bqQ
 6n3pFuPRyWZKxluIWbmfeWMkHqS9geUb2lkF2Co8wB1ebbpBOebCm4lM8HqgTF0scqyZKv7njG+
 bBODvIfvGox3+++v+Mks/arQYd5sLyYbskMpzNnVz0kZdz5H1cCueAdIfIIHQFSVDs8VsNHGJ1s
 ap8ScZS1NSZVAbZuz4B6/gvdDypB40ukpXaGFxJlsr5uXocJF8gUUI6GGJe59gGdXvRycE74F9z
 lYnmSs12VOYD0ffU0norPxozpFfjRqv5FuFD48lXr0UkwjmGMzXiTm1amEUfGaY5ZEf7DmXY//H
 Lqsy27QdKt+z5FmKMI0Q0UdBm0NtHYhNv5WAHVaXpKa8zeerNOcWkbqMJpWyp3Swt5WL9RxmyAe
 RPJ2Y6RQAbU6tnrUjTonNe2a3uTwkZ6FOhTap2aeH+8UpNZActqGh9YbqtFC3glVrM2thUdOe57
 xNTEO7e2gt7Wrjfz6FCKOKyZ+cKLphZpDI+vbiFE=
X-Proofpoint-GUID: Bsrpjnw6NCjqnyql6Sk0tZPAM0MVbapA
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39249A0005
X-Stat-Signature: j3qdiw4jmfticqt19tyh4g8tjt1siudh
X-Rspam-User: 
X-HE-Tag: 1769199167-748681
X-HE-Meta: U2FsdGVkX1/8yTT8Vbnvx6IUwxfBAdQx4rj0Pn0/3ZDCzes+4Bv1g1sH6KcdBg+OMeGI6b0XMGAnpHOUO9Hl4Dc7DpZUNpSsa5aanAii34VUc9mUvzx0GIz5+MjkU3x3cKtFWgSdy1kdhsrX54l8ZpyEOWTTowRaW8BcbNueVlhuUhWn+Lkq5OHj/ik05LwiY5HgOdiJObYVkcp/ZqS2aHQRM6X3AYK+DpUqvby+kzEV74+jnLOepoIsPLLUow/avSQiSbeMfZlZNMLfVYUmkQU0CytHezB+WUY1aWZ35bffXd0TU8gwn/xdWjSDu7jtF4FGQtPpVq2IPttKSDr9CeuDvIQFuDbSJLb575Qqdrex8KALosNBzv9X0fY/7uTccJr3NbLWk+oTuistyCvlxBP0ud3Jp1cdXT5ecYYMtd0iHlzaSYT06Qrc+7G7MMlNV8G7RuetC/xSFnRBJTKM3HYMBqIjXJUxvCjZAp9TkyBPgUGnoQ35Kzw8ZTx7kNjP6KnA06PpPam4xWmHl0J9jSWETZWQ3mItH7d9DXbRsb/B92eTO1xvyidejFWny2Xhl+Grc3MkjszItmpNKWJxHurQL55gHkbcnqNEiVqmE5XnzBhMrRw6EOJvCSYoFUqWFibH3CqWH/r9ZEibh3Ayp58Kn60+5Enet/BkmnTf1gyzGHo734J9EYqBjJP7wZn+aIfqqfCfvkstY6AzAlUeR+Pp7Rq0IYGDlJtfF2VLSn7iryxSgR0eHTirO49quLVpDN1rW0bS9QTz4JdzsIAXbggB7UHdRDb2djd5tc9jBM1+VytU2GB+TTYrw5x7zAWoNMmh1Bj7APXCc22ucHlrI5w7NGj3bF2M2BbO1LZff4xj7I2ybxibdzOl08c+OexLV81awiBnVxrV4U4kE5KuW9U+mRS6ZFd/ablgiOhW6/ArGrmHe+nb7UiDLcs/vzbxKnWr8DZfw6MOJAjHkBE
 jN+7g0y9
 5T9IN8PNUzfHzsif7S8lqw2fZ3ri13O+AmR8cHqM9hEabckwHf32spEXnIoAxVh48usLbGDzZzUx0pCuUq1s4bWT31VN/3W1kPoH0BG3YQ2HRnSvj+cUp4gNHmMuPEyNUxztDOAA29I1QZtIM/L3dlG7oxWq9kllK/u1Y9lwnaSnOMF7qa4x/8K3r8YHGCHIRXzoxjL5S4vvdOlNicU2N+wJCqD5EpsEKHfcD0nHIcJ41u8d0TeLxY+T/5tW5ex7VyEFvivoQbrfnFqXtyXhHaES/R5sFO8R/N8Fmt0LNorWbEBvBAryS2losj4/Xhxkfwyll9LuhWl09zxoxzR+yg7xXQhPpxG2rma599g1qWd6NPlKaK4DpGWeZyGKbwVZa+6J2MttxRj/8vNt+YHFf/GDWNHeqU1kHSfPpWALDtr9ODkiN9Lye8/TYqVOgD3XXkXVTvpHo/+cBgCzM/TeFjq8uXQBdqvH0p8F4Zj+R9LwwU0udgNMyRMShXY7EzTf+gIt4RMvHaAMVGY0qpEe01zWEhU/wGpAtOvZTyfsImAbAU16dv5pIOlTNjs0ciQcRdYnH6fMY1kajK0np6+fC8PiXGWh7xSph+RWrylaG6nNNJtRre7N1+EgevBO+m/zMhI+j4tF+ibwpOhPqQ+/M4beOUILUOIR6CPjhLCBWVwFy23A67+atYtToShyKvSCGUe9FixdrItzONxFSkl+fYn+aIBOJBRZwWEC9GgsEx4tPYKrBphOqvcCulHWs+JzCkwvY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions are very confusing indeed. 'Entering' a lock could be
interpreted as acquiring it, but this is not what these functions are
interacting with.

Equally they don't indicate at all what kind of lock we are 'entering' or
'exiting'. Finally they are misleading as we invoke these functions when we
already hold a write lock to detach a VMA.

These functions are explicitly simply 'entering' and 'exiting' a state in
which we hold the EXCLUSIVE lock in order that we can either mark the VMA
as being write-locked, or mark the VMA detached.

Rename the functions accordingly, and also update
__vma_end_exclude_readers() to return detached state with a __must_check
directive, as it is simply clumsy to pass an output pointer here to
detached state and inconsistent vs. __vma_start_exclude_readers().

Finally, remove the unnecessary 'inline' directives.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h |  4 +--
 mm/mmap_lock.c            | 58 +++++++++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 1887ca55ead7..d6df6aad3e24 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -211,8 +211,8 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
 	newcnt = __vma_refcount_put_return(vma);
 
 	/*
-	 * __vma_enter_locked() may be sleeping waiting for readers to drop
-	 * their reference count, so wake it up if we were the last reader
+	 * __vma_start_exclude_readers() may be sleeping waiting for readers to
+	 * drop their reference count, so wake it up if we were the last reader
 	 * blocking it from being acquired.
 	 *
 	 * We may be raced by other readers temporarily incrementing the
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 1fabda07c922..72f15f606093 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -46,19 +46,44 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+/*
+ * Now that all readers have been evicted, mark the VMA as being out of the
+ * 'exclude readers' state.
+ *
+ * Returns true if the VMA is now detached, otherwise false.
+ */
+static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
 {
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
+	bool detached;
+
+	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					 &vma->vm_refcnt);
 	__vma_lockdep_release_exclusive(vma);
+	return detached;
 }
 
 /*
- * __vma_enter_locked() returns 0 immediately if the vma is not
- * attached, otherwise it waits for any current readers to finish and
- * returns 1.  Returns -EINTR if a signal is received while waiting.
+ * Mark the VMA as being in a state of excluding readers, check to see if any
+ * VMA read locks are indeed held, and if so wait for them to be released.
+ *
+ * Note that this function pairs with vma_refcount_put() which will wake up this
+ * thread when it detects that the last reader has released its lock.
+ *
+ * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
+ * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
+ * is permitted to kill it.
+ *
+ * The function will return 0 immediately if the VMA is detached, or wait for
+ * readers and return 1 once they have all exited, leaving the VMA exclusively
+ * locked.
+ *
+ * If the function returns 1, the caller is required to invoke
+ * __vma_end_exclude_readers() once the exclusive state is no longer required.
+ *
+ * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
+ * may also return -EINTR to indicate a fatal signal was received while waiting.
  */
-static inline int __vma_enter_locked(struct vm_area_struct *vma,
+static int __vma_start_exclude_readers(struct vm_area_struct *vma,
 		bool detaching, int state)
 {
 	int err;
@@ -85,13 +110,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		bool detached;
-
-		__vma_exit_locked(vma, &detached);
-		if (detached) {
+		if (__vma_end_exclude_readers(vma)) {
 			/*
 			 * The wait failed, but the last reader went away
-			 * as well.  Tell the caller the VMA is detached.
+			 * as well. Tell the caller the VMA is detached.
 			 */
 			WARN_ON_ONCE(!detaching);
 			err = 0;
@@ -108,7 +130,7 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 {
 	int locked;
 
-	locked = __vma_enter_locked(vma, false, state);
+	locked = __vma_start_exclude_readers(vma, false, state);
 	if (locked < 0)
 		return locked;
 
@@ -121,10 +143,10 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 
 	if (locked) {
-		bool detached;
+		bool detached = __vma_end_exclude_readers(vma);
 
-		__vma_exit_locked(vma, &detached);
-		WARN_ON_ONCE(detached); /* vma should remain attached */
+		/* The VMA should remain attached. */
+		WARN_ON_ONCE(detached);
 	}
 
 	return 0;
@@ -148,14 +170,14 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	 */
 	if (unlikely(__vma_refcount_put_return(vma))) {
 		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
+		if (__vma_start_exclude_readers(vma, true, TASK_UNINTERRUPTIBLE)) {
 			bool detached;
 
 			/*
 			 * Once this is complete, no readers can increment the
 			 * reference count, and the VMA is marked detached.
 			 */
-			__vma_exit_locked(vma, &detached);
+			detached = __vma_end_exclude_readers(vma);
 			WARN_ON_ONCE(!detached);
 		}
 	}
-- 
2.52.0


