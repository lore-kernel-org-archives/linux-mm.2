Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAA9D3EE62
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0276B019A; Thu, 22 Jan 2026 08:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144336B019C; Thu, 22 Jan 2026 08:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BF96B019D; Thu, 22 Jan 2026 08:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE28B6B019A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 885921AF1C9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:31 +0000 (UTC)
X-FDA: 84359613702.20.0F1D35C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF50014000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iq+ZSlwz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="s/tRw8l0";
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qPzNPFbJwGQdHWf7qozyDLvsu8HrfJSQiB3Tg4K1dKs=;
	b=QdCvXrvkSzx9iX9nNHjyVRF6JsI27+kHbnIIVGuT07MaFXwz3qGl3nw3WemO8omU5Zjspw
	sFmbONqTGyx7I56QHqIEVu77FulhrL8NgLbYwPjSKAJRufMap7/hwQiaV0IyunAEXSvAS/
	Fk3wGji90U6Nr1vADc3Cd4gkMdFicQk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iq+ZSlwz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="s/tRw8l0";
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086948; a=rsa-sha256;
	cv=pass;
	b=F0eqiI77rl0C2zhNw+RGrYTU5p9poUGVEQlP02DurcNoQy2kj6Bj2FAz9D2EkkMTx0mXh0
	ia7yMdVYw1LqZeJkdTpEv6lFCW7TFcjGhw7IGN7mSpkvmxjbMBIRdYNvzXophwvWKWVbHY
	Jeul6sY3bGHQqVymXmEgUmp9ulOD+s4=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LL97LZ1160809;
	Thu, 22 Jan 2026 13:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=qPzNPFbJwGQdHWf7
	qozyDLvsu8HrfJSQiB3Tg4K1dKs=; b=iq+ZSlwz3eq9OTmK48ZyptutL1Qbw9xc
	pBmQwMqlBNOlTyjGK54bHbz3OQmIiJo+zOBriKTLxJTUMFsTWQZZzYDED0QQmK32
	1oVHKsXsMQHq9HDzMJzb+EMpblJCxmOxdpvRnAAuwml3EL2WEsAA/VbOI17Ie40/
	UnEp4D/GsX5eCp+6wuKv4NF78Pg4qdmrq6ZzwQ88qvT6rWmPR0IooiDbSraeZ5OF
	7HGVNS+DfILvxkk9inls0FyKXIeVSSKYJ7g3k+MsEnG+P9EMami9n0/oabEKryqM
	bZ5LPgKelXHs90diTTf3JG0XRv+1QR/UYlZVS7VeQgFA3ATvHe2zeQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qfuc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCrUcU038783;
	Thu, 22 Jan 2026 13:02:05 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcrw18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxyMzvJTq+SKjXZZ2NJPevyyVg7VABrb6FVCB4YdP0NeonfvvxD4fkdc3YXthqqmoKSdUIGeXpaNZGWzT/28Hs1x6hhh3mHgwoschvFs3AKHnsAMx0VJAjxNen/HRVKZNno+nzFBANykzJlK6rNhu0XsdgZQuVm+N9GN/TxUnHCdTbDDaS60XYQYCnZDW4ovfaNsi7+9BZNkrc4yLdG3BoBdPUKYXwd3/GoMjqf7sE391cjTRxP4EuMBwzOi465iuiWhefJGekF1Gu7Jz7A3mLHDtHD2Y/U/mjVESujOPWeyE7q08x3981h/fc5Iw0eD41K7NZvstXnuG/IyWs11Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPzNPFbJwGQdHWf7qozyDLvsu8HrfJSQiB3Tg4K1dKs=;
 b=vmjqdgriZnz0lTy9vdeB2jxWHKvQeMmYAhhJ8BPohQDD1juXudGsYERKxEPBxLGDSsgRd2oHXWgfruk0YSV/oLehAHVgk37udtDlsh5lCXewpkUkqVkaz3QfbUSBRjJL1QzjSRoA+dZVCPgymhNfdo8KLirTbYa3M7Fca7+M2MmTGaqg/ecGBgmOyzUGKQL5xv30gI4RuIOrSg5uGPIB9s3lJSdQgGuZLHy16qTRYlEi+IQAhwAbtMtGXPFnQBg47XLPJlijnW1Cf3xHGyApgOwZ2ttat6EPrwvsdJfSxQN/a0+O+gZV39gJFS2+grrDZAawpwV/1aN/6wj5XVoj0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPzNPFbJwGQdHWf7qozyDLvsu8HrfJSQiB3Tg4K1dKs=;
 b=s/tRw8l0SZ4xZ21Xl+rcBtzHcqTJzhso4pnv1LCPvJVhHpZYCW4vh9hUMeatnL5Gh+G+yqO/phif7rbj+rEhj6TUsraocLSKVOpliM095ZNw1zpgE8MFeN7iJdhM9hU06r5v6kH5ZuaDLHBkm76baFtqexBjwtZBpUcoSoqECDo=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6529.namprd10.prod.outlook.com (2603:10b6:510:200::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 13:02:01 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:01 +0000
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
Subject: [PATCH RESEND v3 00/10] mm: add and use vma_assert_stabilised() helper
Date: Thu, 22 Jan 2026 13:01:52 +0000
Message-ID: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0089.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: fe38258d-e2fa-40cb-7da6-08de59b66f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eyhKpXlROaOaKyB8aivvMc6dyXYYHf90eCX+uHycnLv6ilLUulkCvPrryGZR?=
 =?us-ascii?Q?Iri3PnPwe/d+DCSX6STTN4WH7g0aCu/I+eAvNtXtBqa0wCDriDLZlo7T1E8I?=
 =?us-ascii?Q?ZMPJA3kvXITg06GGXhNVpKePmpwuhzaYWy8nQwP2ksm4IBztTbVJ47Pvk0n/?=
 =?us-ascii?Q?TiaszQC6N0euKuroQnWUGXVpjoxkGL5jzJucIuY/AVkTR6dWuKuJjNsBA4tB?=
 =?us-ascii?Q?ChDhRx7uJ8kJokKW/b06Avq2VD+apB9QnBoh12T/jGg6+fY8bTBtF5thGX9x?=
 =?us-ascii?Q?M/TwCURFMiszkCY7ec+WNm5LKGzy5Vl5EIy4l6vS0+gy62MQeV4TlUx/XJgq?=
 =?us-ascii?Q?WAiAunjrmTvqmZ8Lhw3azZfmhJAm1itsfEKSPeq/LLd5C+AtLfkBzPDwJm9p?=
 =?us-ascii?Q?PV72s1gs1a6uE9BTAXxDLa+ZEdnm128Teu2bgn+sGz5RTqaCYhVDOicQKfJd?=
 =?us-ascii?Q?e/2MCuaTDDHKyXMKzoetcCIDxAqKD2nwWu+ShpBNl6BqryWUwKf69UMqOmOm?=
 =?us-ascii?Q?rn0qnGHLxTNnlIis7W5YarkhHi7SCLLuCGP62gRY+RUdHmjMkrIMRMdjnlDq?=
 =?us-ascii?Q?8fvBCdAaG3+AwU03uTz57g4WsBd5ApZvtg0NtktBZuzMPnwELtrsfELC/YDC?=
 =?us-ascii?Q?opn05jp1KuhGNerkcahoZ9T4BaSghsUZTfXsNipK7NAJrPLVdX+AQHevMZ34?=
 =?us-ascii?Q?fNRbwUKFn+sDnfTuslpWQtgpJex5VUJlK3+yysCPWLJkiU/QWXDqgw6PC6XI?=
 =?us-ascii?Q?0TCURGZerX7KDVZ9wAwYY7P4IzmvAdWnhPi1+tWDrE7YAUMf3fxaTBFkhBpF?=
 =?us-ascii?Q?bKAkYC0OF1f9ZQJJq19bIEkcV21dngna7coVMU0p4h6ZuNeLT6YlMGq87VeA?=
 =?us-ascii?Q?Smv5stPb3i76qTmdRRXLVhg2gxT2RFRN+I1yA0ZvelP5vDrrDKMZJOJEssyr?=
 =?us-ascii?Q?ozXuuc+TyWFSdd1NSblUR1d5c2QY8s6WjcHWtgjLk5QPc0QLFrVfXiq9AQJa?=
 =?us-ascii?Q?Zicr0z9ICFMKZgmpaY1oBGfTmZzf9sas6OfL2N77WcOCPYaDQ75yP4yW2Vqk?=
 =?us-ascii?Q?vXvjR9zuh2GH2EJHddtilaChGbGdIjISJtE3xB9Tdm2eDFzGTpkM3LGkvmyr?=
 =?us-ascii?Q?LkyeOdmQQxiCsAY+fDJ7PclyipCp1TWrAP6qmSmjDe+BnMZWF4U2g7A29RNd?=
 =?us-ascii?Q?i7KD8xRfgfsVq0CJzBK5GZfxR3nt5Dvy8IfeMlzYYEX6g48dn3qb+llQ2emC?=
 =?us-ascii?Q?CBCfL705fRrsgehwLY5Z5x9Nxv+VflC2fJLE77hC0vXTdScXhCjNpu5Euphn?=
 =?us-ascii?Q?WQzywlMEPeV37jm6pvF4RQYVmQfPDuWzD5oz6w1smbbOC9ED2yPyWJwsjS+V?=
 =?us-ascii?Q?0JvNaoYTWAp7olDomLSA6LPU2H29U5glUFJEgXTqf3y3mWQWuzkrnwiyRsWu?=
 =?us-ascii?Q?9PBFGL5+W56W6xI1F5RsJQruVZSTY7D5lgY43C4JlEyrTazREfCvDFZQDTtK?=
 =?us-ascii?Q?tVV0ZJuJRKUGxBPkt06hAfBuk8t1YuwWTqnM6NLAuzlG0DWKBgla8Sh0Ihm6?=
 =?us-ascii?Q?BSoOsDhHqitcGtymgwe0o0CrbA66YAoGRlTrYwaZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5Lvr3pVRuWfsLVm7CGuPLnehqJg6i9ZPsma6Ru5Kwp5znhcTBe84sigfyP2t?=
 =?us-ascii?Q?0S1XpUyYapSr0yK1eOsh+YyPK8PtKf+ijsToMbHvD8fV1iI2hnhiqKt0hym9?=
 =?us-ascii?Q?hsBAGHwDxYYZennVhSUgR4pCFOY6CV0r5ARwUd46dxSyt0yw6za9i6qz+In4?=
 =?us-ascii?Q?YGdxbj5/oR3l8NiXiWMeMiK2+c8b7lK6KWxtHs6vNb1+kmRJSG1qQFCDuqaY?=
 =?us-ascii?Q?Wd/7E+Jv4a1o+R3yq8ng+PIZd6TFuP7UUD+M7mG12xZNZA+7HdsgpkqiOtei?=
 =?us-ascii?Q?9Cteq5k+57f//FHbS2wmqmaOxcFJDy9KEK9jEn405ygegFl8HY2/7IHkSZJT?=
 =?us-ascii?Q?3vA3tBqVyrjyJaREAItLDYdC+I1krwG3MFmPC1Af+BQdju1ZWXgNpHhDJAqU?=
 =?us-ascii?Q?PLE2yubW5zqciK5kCl47MOZaODy3RgrOcJaqMhSizxLtqlI33g6niLF5UBq3?=
 =?us-ascii?Q?BTZkr+AW4nmkY5limAoPJ6QnN9e97oLtoM8xced80Jz9O7+kVoU+NHiZCfjE?=
 =?us-ascii?Q?+23+CXMJ+uvVIAQBIsLXunr7ODEowSj4gsb35YA1+dqWwByIelYLORx6M7Uw?=
 =?us-ascii?Q?HkRe7Cs56nJanpDdVJbtnn7QBCKIfWBDAeGG+sDsBZoNz0gfCNawAun3uQmL?=
 =?us-ascii?Q?4G3umhNTtLWCwXamHxSDNTeujCj6z9J/DZ5ANfAyyHQBPKP8p7ivKXDXqYWL?=
 =?us-ascii?Q?M2mjAWCtC8e1+ZUGb5Hz68/O74mYUd7/OOrRpUiXg1eyBaT//cadQ5s9zBq0?=
 =?us-ascii?Q?D9hOxI5yKAIfoQbSOwJzO8nmwCfort5gBd+ArzTaHuehlieKPXotmxxqHfJ4?=
 =?us-ascii?Q?C9I5kV6qdeBRVzbfJ0awx/EcBuShFFC8Mn4unS2VRn2EXQSC6fzJDo3rRXst?=
 =?us-ascii?Q?JX9AaSlfahJZna2M9bG8saq3bx1lSNBrxVMyNyZ4H37M0i3QCZDcZuEIRNUW?=
 =?us-ascii?Q?luQee6aPkXfZY+U67EOQi/RYBhorETJFiPTz9A+inggAZPUlAOxzh4jGvxYE?=
 =?us-ascii?Q?oIRVfThwZzFoiEeue5k+jEPt6FC80Cy8wvkhmIePcpWouQSZIaUMNVt9IfmS?=
 =?us-ascii?Q?GOlfIp0OJ/W/zIYESWg/hn/3M2PTIwAU9HOdC7qwSf/8MCsUFtVmqAHJeejd?=
 =?us-ascii?Q?/gbbPPc2fB9rISVK/l4WmlPhfgUs97VIkqJFO2PKHk1aG9BmeniH+jCbuCVI?=
 =?us-ascii?Q?yrM5epPo5OB3QSLGJeCDN4XfNKAZIz/yE2xgffhcayXbZdwwoMOXHgpUg1zY?=
 =?us-ascii?Q?t/65ogvmRsKVVDp0W936vIIqo7aUaFB2fMrsPrpmtlx6wCpFYjt3N5h9SpoO?=
 =?us-ascii?Q?SqYMDvj0IhNyCjiJwIj5zHEJm4O0aTel9NRKPXW6i5tRaB3LlZJPF+XBPUJi?=
 =?us-ascii?Q?456XOwj7wltorNdXEbNlVmQyGBL6HH2Ra7BtPBUk/GjdMF4OSnii3DgvvtBO?=
 =?us-ascii?Q?CiIQb3vAtJop3ZC+nSD2Wlr8sOegeQV8uluk4NZ+MYR2wRCL+bbkW6nY2Dz2?=
 =?us-ascii?Q?6JUtas+ySeFCxTeGVXfLJL5IBlkW/BTKRPw1WZetc7OpMUDppKasy5eFq6Qg?=
 =?us-ascii?Q?Qg0bGdMBz7ELYpUdZsq4LSmpM8zWU4v3l4YhLB74T2/25PHVY/DIX+JiDeDP?=
 =?us-ascii?Q?I4cbgpvHzXILaE33CUYIYh7LPh7/zWOrJ7RJahKPqVIkTUjc/vEEdmQrTIKV?=
 =?us-ascii?Q?XeeCh8yhnXjI6mah7Win/0SyCf14TybotZEmWkJr8Xs/FRl1f10QUJVX5ccF?=
 =?us-ascii?Q?PApnK6Uabu7EIrkdj2dJ71+Hr5PUvRU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K/+n8geDEKTxAugkYbACb5oSDiqJZ2EY4wohAuDs68feOu+n+bsTq+mzd3s9VJHUiDS5gxoFT349gyrU1+g3ZlCGpWWAszkyGkZpRacpic+9GtwDL0VqD2w192jeS72lZILSt3Ak66HOoOA1El8TNajZtmgs1iNq1BC1Pg6N4dp2+CvHdasf/+ge4NuhsC9MQljcrJmTpOyqVR5Usmbbp2J7xg0Sdr3vJGnJHTwHT5AsvcbZe5G9GUxp9fnB/IbNja3G4PW5OZMyVGlhIUF69BADxiEzvvhBqrq4g7++69tcAAxE0u8rOC26IhTPYLPGy7WSkSQAjdZ038nhBeyPlEJyoRczMrRPNplLir+yHrf4XjYmQnEukIhFxQ9lEiq6ABgz2tvGjVnWItz+gosdXu2hzb763wPFy39sORQNMtEflUQmbDJosWak/1nS1rZ/Kt+KWvzpESx9S0oqqfIo3QJ3fxnrKcZ10DEICWt5yoZ92jOaik07Rn6nXwomGri1U4uaQz0U2439BZQKRBC1ujMnLpYnBiJjiGVcsKF2ev+acEl9AbhxPqmqHuM3bG9zFDQcvjmHktHfaNnBJkTvlK9A49OUQhh+aFhn+VDDIaQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe38258d-e2fa-40cb-7da6-08de59b66f08
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:01.5781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGGhqeAtWzr0wtl5JL+DtWzs/j1bwY8kBNJQagBkJcqJ8HJJP2hwvnFU5YZKA/ivhRgBw4i3dDAy9i84GVSp64/cbRkCO7LUfd1wH12jPoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6529
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Proofpoint-GUID: rjUnpz8oV8SXHFn9FK35b924Od4LUjgO
X-Proofpoint-ORIG-GUID: rjUnpz8oV8SXHFn9FK35b924Od4LUjgO
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69721fce b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=F9VmE9P_SG1h4MgszfsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX7bNOG+ERBZlj
 xaWTvGCYjHWsdZJ+3czIQmsztRHZurYM36L1Dh2VKap+09Hor1tUiAiICYnPa2eZ17zhzygZQWI
 LhJ+D9GI870hr2jmrnhA1pgTaIHA1mmRgqP6M0ZpyaNtGlxNAJzzDG3BAND3BkYxmpzST2/fJdB
 oxwy2nW63sZ/u8bsQQqAakdKSIz9PFJOVQNqYUZwYKHfxNCVFYY986pq2YQ37c8oAAuaoiu1A8z
 hfVgOhBmfHTCSKeQCWmaZ0nJ/YZiPE8eQvO6HKLTyhySbcd0yyfb/297dv3fKspAh/WG46PEo5w
 z+2L/SVdpwFvsfW7dN+SRoQzwwg7JF6x5I1D+U3f8qc7WrMRQLtJJMvtzDmhgLi2ZJka6kIMorx
 BB4/gntXju70XYHWHHZAD/XYAztmI+BJqrjI/gGAaQbXYPNvKZhLqItaM9j4oHFplf0lqldLMHH
 8A+LfHw4EOMSTBH/03w==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF50014000B
X-Stat-Signature: 41fkfcm1s5eor4bp3uwwftwqqkw1kmfy
X-Rspam-User: 
X-HE-Tag: 1769086947-391586
X-HE-Meta: U2FsdGVkX19aP84ciGFq2cIqmMaLw/byCoY1fZj8deVool6R9mxq20ixFrwnBw2VuvbECGlK0TADXRFM1P7Li3nvtMijRkuQfFytUjrFnWPaHHcC7hv/u2G3MWRvWZyejvGZt7SC5ci+OMfT1/rb+mYTiqKPPPrfstT8rVmVX30ulfMXBoUmmlKnKGZi5QcjOpxxVWU55BSsrA000iKrF4202zMxMgiktZ3abgeykkr5KM0EbWPPSgOoTbCDjVDnD2f65sv5dRKnesxgOO5Jjdeogx8R1TRZB69loCY6fO+sJHFSOnc15vpz5AiGYAh1yrYUr+1IOtHYXCDjmVYHIY7ZgdhHpO+ipX+12UTjqkL3JoOzi/yhrXqYm5zsP8nseion1TsVXwN1eJKhhu2CAbCKGLM8VXwL5puVIG9JIi8/xlDjNf9Nez2QM6vgzIZpyPCMaTkS82BH3yF49EAHhHHse7UR4coWK+tcAfpZKxNJz1mFy7JXHNiZrdvVXW/s8w0csZEYPzEgBmerIdWA2pfWzWWli+LAotuf8v8up8Cov5mNGYB88fFRauqmdpirbVcKkhMfJou+4uMWc9sDMm1kpiv5/8iT50n12zPPLbU8XPKRTBSqrwrwBEeYbWchJbWEkIBBbCA8XCFrm3QUifTIxYo2Cjm9fuXw/oCBj0WwPo9x0MMAFAH1gKl5mljqcJs5/HJPevKdvFOq7Io+brPHjA6UcqOZWKpU3zyX8BBGlF62CkwX1aOC/EIu3JOwS/0Y7tcGLLY+8+wOCqVjWZ7xNukyZkg8D4zvk0xA/IP6M+1JscBSEEDTlkiccrOODSzdKMtUx1qAWpiZdchucJiKJBNW/LIBqfAvRwptUrt/rC+ypcJaDgv91psWYrZOiHDla5m/dv9UDs9rdpqPE10MNwsf+i4h7Ts+MzrIorvV4hAurF3SsnNZcvqeplHQb4qQPeWBj+Efcc8Pxn6
 DiMOD+iB
 /DTCA47W3ou/H3utuWddQetrThU8mL3SqDs5/SGEzvwmmN2ddXlIIuHFtykzheM2ivcESn0WHaQfQViUsjQlw4AZgxg8QByhNt3i+D1tiwyIWcsJavh75dR68p1P6AuXnr3dymRdlEfNUunACoX84n6QypNuJhDG9cZ67Ljt9O0PTslHBc8WMwJP9yfH1aYqLe9bYsrgOZzUEl2aKuOCAabMOUk1BITrlG52ciqdw/CGHeCdU5/hgraHW1nRwZIOkiNj32rSDs+EJVk3D5Jw/YZPp6oHnyaVIoboXV8b7kdU+69MfQGFGC1rLzhIKj+rT9zcwo/BDM9564Kn8vakTaFQtwLSHgaPnZFYrQXuSgWBVLw1V53Ad3zy92L+b30JL91A7p2P6DSZhZPFjDOtGH6qAOlc4IhOgJ56DucQUdjN+ZtH48aWHJoOTIwxsyjDiUX1qZBBaN8HJN/0rQ2iNAb+eBUzg6fGcxyy2jHdMkkMf0cTeeOZLtyfcVtODCr4u/dG9LefwCymQyPBYhCtYR/0jP0xIgPiYCWK9VVqtaXzP8GufOdDx7iexJLAhahAddMkS+o+2tuNkYxBzRp+9sKwZFRmCgfzrN250uacoWKAsFtiiw+741NMkjcnhnIOuctesqxHawn4nC3d2UkFxw/zdbNips6lR0APw7syVR6n+8IE2j/S+KDn10BcFPGRtT+KwV4o7cwqgePCWzj4tGJAJE65uVYHYthz05gJSAslzsL5rmRI/iG0s3Nhe+heZlVgRW/remo767TlHWi5GdPCymA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

We already open-code this in two places - anon_vma_name() in mm/madvise.c
and vma_flag_set_atomic() in include/linux/mm.h.

This series adds vma_assert_stablised() which abstract this can be used in
these callsites instead.

This implementation uses lockdep where possible - that is VMA read locks -
which correctly track read lock acquisition/release via:

vma_start_read() ->
rwsem_acquire_read()

vma_start_read_locked() ->
vma_start_read_locked_nested() ->
rwsem_acquire_read()

And:

vma_end_read() ->
vma_refcount_put() ->
rwsem_release()

We don't track the VMA locks using lockdep for VMA write locks, however
these are predicated upon mmap write locks whose lockdep state we do track,
and additionally vma_assert_stabillised() asserts this check if VMA read
lock is not held, so we get lockdep coverage in this case also.

We also add extensive comments to describe what we're doing.

There's some tricky stuff around mmap locking and stabilisation races that
we have to be careful of that I describe in the patch introducing
vma_assert_stabilised().

This change also lays the foundation for future series to add this assert
in further places where we wish to make it clear that we rely upon a
stabilised VMA.

The motivation for this change was precisely this.

Addiitonally, refactor the VMA locks logic to be clearer, less confusing,
self-documenting as far as possible and more easily extendable and
debuggable in future.


v3:
* Added 8 patches of refactoring the VMA lock implementation :)
* Dropped the vma_is_*locked() predicates as too difficult to get entirely
  right.
* Updated vma_assert_locked() to assert what we sensibly can, use lockdep
  if possible and invoke vma_assert_write_locked() to share code as before.
* Took into account extensive feedback received from Vlastimil (thanks! :)

v2:
* Added lockdep as much as possible to the mix as per Peter and Sebastian.
* Added comments to make clear what we're doing in each case.
* I realise I made a mistake in saying the previous duplicative VMA stable
  asserts were wrong - vma_assert_locked() is not a no-op if
  !CONFIG_PER_VMA_LOCK, instead it degrades to asserting that the mmap lock
  is held, so this is correct, though means we'd have checked this twice,
  only triggering an assert the second time.
* Accounted for is_vma_writer_only() case in vma_is_read_locked().
* Accounted for two hideous issues - we cannot check VMA lock first,
  because we may be holding a VMA write lock and be raced by VMA readers of
  _other_ VMA's. If we check the mmap lock first and assert, we may hold a
  VMA read lock and race other threads which hodl the mmap read lock and
  fail an assert. We resolve this by a precise mmap ownership check if
  lockdep is used, and allowing the check to be approximate if no lockdep.
* Added more comments and updated commit logs.
* Dropped Suren's Suggested-by as significant changes in this set (this was for
  the vma_is_read_locked() as a concept).
https://lore.kernel.org/all/cover.1768855783.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/cover.1768569863.git.lorenzo.stoakes@oracle.com/


Lorenzo Stoakes (10):
  mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
  mm/vma: document possible vma->vm_refcnt values and reference comment
  mm/vma: rename is_vma_write_only(), separate out shared refcount put
  mm/vma: add+use vma lockdep acquire/release defines
  mm/vma: de-duplicate __vma_enter_locked() error path
  mm/vma: clean up __vma_enter/exit_locked()
  mm/vma: introduce helper struct + thread through exclusive lock fns
  mm/vma: improve and document __is_vma_write_locked()
  mm/vma: update vma_assert_locked() to use lockdep
  mm/vma: add and use vma_assert_stabilised()

 include/linux/mm.h        |   5 +-
 include/linux/mm_types.h  |  54 ++++++++-
 include/linux/mmap_lock.h | 223 ++++++++++++++++++++++++++++++++++----
 mm/madvise.c              |   4 +-
 mm/mmap_lock.c            | 180 ++++++++++++++++++++----------
 5 files changed, 373 insertions(+), 93 deletions(-)

--
2.52.0

