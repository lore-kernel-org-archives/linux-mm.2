Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CA6C44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39EC16B0088; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375D96B0089; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7066B008A; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 075046B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 966F7C095D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:07:36 +0000 (UTC)
X-FDA: 84355392912.17.9F535E9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28E7740006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:07:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SkaYEgd3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jIZplL8K;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768986453; a=rsa-sha256;
	cv=pass;
	b=QcFMkSBF439LrjsopdeQ4jmkNd23QoRa5gnz2AQiG6ox6SwJfFjri1V4m6rjzjjtoHb61n
	m92AQLS7CYAlGuqg3jv5jzc8OdczX8bzOOilJhZrAzctMFFZ8xHjHjNYZzll/CTyJ8FlN9
	1T3xZECsJv697W74RPwJpR1HmB9091A=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SkaYEgd3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jIZplL8K;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768986453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32CDZBVZFDR5jw80/DbiydgvOiUVX6P0NK+7lf80VwE=;
	b=I3JQJfo3tXB4VM2csykX44F25wWMCi8sHsJaSCK/EekeVUxFOuQu2Betjzmhzb0bSueGJK
	FRpdUImBTItCCd+bp6OTM6vKMOnkJzCDleRzSKKYNK8syk3AAvkKYT7KUlu68w2cgIu0rr
	oFPJAo5SFdr3Ti3gslLm4LnG92ocVD8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60L3hLeE3523936;
	Wed, 21 Jan 2026 09:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=32CDZBVZFDR5jw80/D
	biydgvOiUVX6P0NK+7lf80VwE=; b=SkaYEgd3ssuUoBvM0c1rOuT3XC+p3RXbON
	UDPMt38/MfNOanr+5rFnvNytCExDNA9ZZooZs7HJfukZuVopYUJQ7psJhfCPzEOw
	C0XBTR9dB86n7oOaffLXpzTD0DbKTcvBum7iH/K+o/j6FzPS/NWf0QXU7vptda/j
	RAyP3pM5lGWDgUzf/tsORj3TepfPxTXfixAmRTXMB/bPTG0Ufe5HlxQtTGzHHXiQ
	SaXTl4eMLk96eEk+NvjJTgGRW+F+Emfc9ojHpN+ECCDUvtVppOawd3+1KQREyf4q
	akYjHoH16JK88fKGv9l4LnqNVoHNeggYXz2TNgfrW/dmafmkAN0Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qdpgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 09:07:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60L8NUuZ018230;
	Wed, 21 Jan 2026 09:07:17 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011021.outbound.protection.outlook.com [52.101.52.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vayqs6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 09:07:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYS59EhhZD9Ceiv2RnMv9EPXesqNY6jexyfzV8w5xfzFZPOEVX2BupBKxa1Tvfsj00aTFaIs5DI7nArCdmmQ/A8DZvMQBPlZ92Ff8w063tHN+rn0T6jdCLtvxx5fk96LWUecsDpYVptNqPl0DP/IoyIkg1StQdgSMq9nek4WCh4jmgO1dLF0dwjkJReuyjeYMSPxNuPNcCzmHihq8eSDSFThC8xrvHfV5g4+nUJ/c0jcX/TfMUpAqFIbb8mRpK/Oaw3Hx8r5LVcwJVEhfGwy2jrc9mPf4mzSWV67qVIZ46hzCjbTaPPbqgGBr9rbRbFKGiRDbsoZ97ARhbsivihdhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32CDZBVZFDR5jw80/DbiydgvOiUVX6P0NK+7lf80VwE=;
 b=il0bqE42oO7bzCr2jFDyiMIUm8wMrkXWl5/5uWzNNG0hCSVwuuYucp5UcVwa2g1sAJcnCIvoVzTrBefzylEAjIgSTeWNbSFD6hqK+pYVCLrKwQP8kK7J1WyOtGB1V/HXzTysZ58ZdQqKNzgGGdEx8T30QwZsJ2wnSe/dVW7755Uxa55NlTsV80+aSi65Vtc/OXlO4+YQks1KBWVd8zixhyvisliMUlEJX+UWvk9QyIIJmpRx0zbneo95lHhtVjDi/NLu3ZRe1CmDzADitvuM9aJgXJ6GsLP7uxnbRdT8UsIrxtVxH//wAcxIo+Q+6Dy994THD9oHWy+ms7J0OAWxdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32CDZBVZFDR5jw80/DbiydgvOiUVX6P0NK+7lf80VwE=;
 b=jIZplL8KCipWGjtPNzusJ6+nG5yDfC01CuRHgCiTiwnmG5ZOKltsgrjLzqn8cRQjjBoPn87o4x6HHKPEVLww5iP4C18WlpfO6cYLNvwMk7QgjNtkR/mSOPpUGr/TK7SZ2UNBA6+4h2xKjMy60iORoN1KGUL+oKWdpHM/SMBU/mU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DM3PPF72E3677A1.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 09:07:14 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Wed, 21 Jan 2026
 09:07:14 +0000
Date: Wed, 21 Jan 2026 09:07:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] mm/vma: use lockdep where we can, reduce
 duplication
Message-ID: <2e7c8808-99bc-411b-8d54-d84d8b3858a9@lucifer.local>
References: <cover.1768855783.git.lorenzo.stoakes@oracle.com>
 <bd410fd91d22eef37f9b617327cafce33b267b09.1768855783.git.lorenzo.stoakes@oracle.com>
 <30f843d9-03cf-4c7c-8a29-8e11b12e47e4@suse.cz>
 <61ca35cd-5c08-4196-89b6-ec3feda69e36@lucifer.local>
 <f7ed3125-e7ce-45b0-a077-a2979a6238b3@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7ed3125-e7ce-45b0-a077-a2979a6238b3@suse.cz>
X-ClientProxiedBy: LO3P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DM3PPF72E3677A1:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fb4e2da-06ff-4112-284e-08de58cc780a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cpPa3deUaFntBxvBqZEgUf6dJ847qyCo+E4ZfUl5tr9zy965QkSFMVgNLZQd?=
 =?us-ascii?Q?AFURpCejuSE4s7vU2MdEJAbPM7Ept8zw8PShaBeyfAzo3SEbCZEAsstydIRz?=
 =?us-ascii?Q?sr4fR2z/IWioq0/elRN/DNLsrWQBX+qGsFnelP7gYGxcnuYQtN1vMgVzoWKY?=
 =?us-ascii?Q?O4+wIwNT633SWRAk5p16BBETzhp5hc417ZZx8cjEyMuLQcz0V0+lO+xDOC/6?=
 =?us-ascii?Q?tsxptOoS0Tw3hFKOfOkKz1KR+vOi6J9MwKC/8Rrv/PDDgDoKZGK1ijamxWuV?=
 =?us-ascii?Q?l/rXbdtXv4cVKiuRRiaEuVIiqbSJ2PCAz+1eAfzAOVsam5A0XTyiVDHmOce8?=
 =?us-ascii?Q?9rPEYn/A3RgxTBjVI0uVXOYq7iuIpMZadxLG/+f6otS7gD8WZk2wr0l7GLKP?=
 =?us-ascii?Q?QY0+/3DGDrC65855/i7pwWiN/VtdWsKJjiQOed4PTxE49Zq58ZyAR/b/OkyG?=
 =?us-ascii?Q?jt7JrbR9l+J7TQqPmvUui1OfVl4eZysM+CInqxFXQiw/tSqVvYcjvoAQYX28?=
 =?us-ascii?Q?O9hknzbHuYB8LlZU2bP9Y3LXCoMUrs0k0ERikDuqRQXFXVS5q0+mPJHpefDE?=
 =?us-ascii?Q?06+hwSdwJBtKDJ3/nXGaGwbEqKGVDj525fcZMwcUnd1eIfpJZNmHjKa1WL6E?=
 =?us-ascii?Q?BMd4V+auRwQEzEnY9QXA+vjnwxZP9hMMHmYadrlySqDlK84xH1Ds6DOf1GDc?=
 =?us-ascii?Q?VGYk4NnLzLTPT41avmtfJwHIrB+ScWkWgfDMlq2VXrmWmaUuemX8kVMLmA/r?=
 =?us-ascii?Q?3DS88G+9RdRNAFBlH3XQEIzxbmhlsJbYynfGm8K3a5ILiQHgYEox2eFze1u4?=
 =?us-ascii?Q?oovqQs7DsQl5ZkfDoDp19EjZlPwBw6fN4wbXCGEWVUd/TNX3hfUsZKn6dmsO?=
 =?us-ascii?Q?d4w0PLsBdj4Hh0eSxWeBP/90fSMH/KaEv+r5E5sTqjg7ppbmC3UPfeT8d8NT?=
 =?us-ascii?Q?WDhMyMENFztddmHM8eg0qb1jMuNimyVpEQbuxYU+cyBFFmxcFekOB+zPdGHn?=
 =?us-ascii?Q?gXyQKjt3bercnscusgP7zUZObYBFvw7MEy771WFa9zBP9ASik6d8O4t322L6?=
 =?us-ascii?Q?emNHw7FFfbFxyeyeyiUX+yqTDyoTwoUt3vdqZGP6jwEvD3b1/Uk0K3QI5B+Q?=
 =?us-ascii?Q?Ux05KOF13Vmt+fX66Q2IiIouz3lQ13ejKJImXpFJssVktQRNq76ArEKfrFRK?=
 =?us-ascii?Q?dBEOqx1fEAodyg0xqVICZXeZkhdBHAHqu3zyhouaIg5sUyvBIZCU7IPtFmA2?=
 =?us-ascii?Q?mX3kPx5vU28rqq5hYb3AbzxBbilMyldbdI9ZpI/oguzexLRX0mE5RSdVw63l?=
 =?us-ascii?Q?TwfwC49UdNyPFk8CCRMbP/8sVgBPVaztrN3/aWFklHsgYfnWHA2wBXiYMgRz?=
 =?us-ascii?Q?yZuuWvkRwfs7sESVe7lCEdS9VY4ND5n3XS5wn6zzOdfucA4l3dxzxLHo2uQ/?=
 =?us-ascii?Q?NCqy4tE72R3raTgpp/Qms0kbc0FUpzSb+eeG0I2gg+pKsrwVzpOcVchDJNYY?=
 =?us-ascii?Q?0oQUmTKigbtRZSRytHn7Dj6WoHL8OzADAASoZEDXYcm+4UTchKQHmDOlbhkc?=
 =?us-ascii?Q?QP45ewI3vtrJ1tgbDEo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gd7lU1raDJzZjox42MMH7fgDHPR/1rVhlSucae+94JbZHEA045GDvHW9Blwm?=
 =?us-ascii?Q?AvuCgsZKaq1ayQbi73mIh/3g07U6nD/15GI5bv7hJKh2SIYVEalDYdAl/Mc7?=
 =?us-ascii?Q?CQs0Xvh4tSk2B4RJqLo+XwMqAuVxZm0VCX9WA3XvTs61bSFCYGFiGHx+na5Z?=
 =?us-ascii?Q?gVqjAFRp6ap1GJv7fdbzL1gR80+9jx4UPkJVhjmkFpXOg2l7OSLuMN7EizhX?=
 =?us-ascii?Q?jq19nVDUJRz2ytEXye/Il95VQdxd2gJOu1+K48XUmaqYqrJT7Tv8IFQMYJ8J?=
 =?us-ascii?Q?CbpKbUY941clk0OKenjM2SF0Qg502C9/UmRZTSPanw5GKMTIr6FqR7UMSWI8?=
 =?us-ascii?Q?ZeLjSVc8tLDnsH6+/SESLib1AdmF2l5fvnqHYN5KECssgcFt8pQvlLQFmpYo?=
 =?us-ascii?Q?A9Vr3T+8fNovyimTzyDi05ed6IdtbJP8BNRpHwfpDBQg5vPXf2H4FCZBs66z?=
 =?us-ascii?Q?qLwNAOL0J6VQSWEsHxoWUHgrh+EsgUkdTfT+5fMh8mALH6JBH+Rkeuw0BSB8?=
 =?us-ascii?Q?Nt6BQ9P98qW53ze2R6RKdIpdet6x+fouygYwj54x7ow/PwY2RQ9CCIKXcNTZ?=
 =?us-ascii?Q?VRdwhYjodfKlWrbUw0VEXB4idDIpgz1cJ1ZxWYzpbmiHDMu3uCrdlDFkGqsW?=
 =?us-ascii?Q?gxpVE2AoFByhKB+1co+prt7FEGVsJRw88Aqqpp3BSPKRi1reVQ7csorU8Yiz?=
 =?us-ascii?Q?8A5QQiefQvg5SsQ+kBMFfRKl7cGIlk81yxZowyWtyEdKwwQEBi5Ry7tSm45w?=
 =?us-ascii?Q?p3tQIFfNL1MaLUQiG3UV8c0bgb6Kxg2FbDEHFKKPydtjPcrTGiJf9ZFa3K4c?=
 =?us-ascii?Q?dh8iIBMo9ZKxIz0t9uqOIYrub7OCEC06vrYjEgLs/Xcqhj9YOo0WwawvAOcn?=
 =?us-ascii?Q?dO9Pex7mHiFityBaTQjrCBQeZhX3d6TJz9OB6Qw7ttVOVH9XvWdPyZS7qX3k?=
 =?us-ascii?Q?Dz+eYDHaYN3DfAIsg+a/w0iK/zHW0eC0Uak/kEosIXo8BEB/5LmEpdqYGi9J?=
 =?us-ascii?Q?tqgoh1LJqvW8jrxWf3XA9ZEMxWrHWobHr8+cKFFSHTJXBdiy6Nxvk9U93RGB?=
 =?us-ascii?Q?3qOQNimhX5P/rXC2cEs5rJtpA6vr95iS4ouaj+lySUR2tBcS9nvCcUoNHH+7?=
 =?us-ascii?Q?PPswiNbhbT7/0/rsyslKWTXJu5v2qHe+Q9eTphKUxiNfwJnBFQrSHrVZ9u6j?=
 =?us-ascii?Q?rMyvZug7YW3tAgpcI6dlClItcGGMHJrxZ9+PhJoTUGHj34n4alqcD3I1AFE6?=
 =?us-ascii?Q?NSqv0Zgxmc73KZx8UAb806EuVAbLCS+B9ZQYwvgNgRKBLaIwd8edqzH/h2qy?=
 =?us-ascii?Q?4/BnaQ7BJ8eYOaSo0RJ9/pjyO7mjuIWv9ZzOH0mCFJQJKxzJMJZywOwNNN/V?=
 =?us-ascii?Q?ZHYfcrr7symYMPJwYEHZomiTK/4aSavch2N4ua/Xz8cywu4nkPnbZ6ScTDU6?=
 =?us-ascii?Q?t7eYRRdDN/g6rje2L0JOSpeuHtaTVLyQ87SpvmxFJGJbE2zMuKCmEDIpYMvt?=
 =?us-ascii?Q?ICpixWuF2Xb5uyOR+F6eww6pfI2xMeXvQ7ccp85zXT158jnc3Sn08029WMnZ?=
 =?us-ascii?Q?UMgNT8LdWRspm/bonDpXOjgeTTUeffiA4my60xTAJR80VGv3w9CyoPzfI7ek?=
 =?us-ascii?Q?REF9/pagPYz4NQOwIh4eK5EXfjoOHDDvck34PProuwnt6P9OEpNyv6ivUykn?=
 =?us-ascii?Q?bbomrmB1huO1a/Vkt1XqP1+Dm7g7wg2fkt0riMxC6Tm9USPfUxvcBnkwRVeF?=
 =?us-ascii?Q?YihextIVGDJhD/+MRsaMlBZzUzpWd5k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oVPUcwpZUAT5OKbgkGPNPM0OLcRfudcGPEPQvL7FeXUaKfxiNgfA/SIuF1G6edahIeQ1GKkaYonKW4YN9un1ep3nqE+dIWzyfJzBTE82Q72FcpwgVYpB8tp9+D/4fx9+Kbwq0gvRbvko6hKLRmMqJVxL39kQcnaySr2Npl7m+yRTVapQ1esr+IJrP56YBXYsWuCbKPmwGCllQ5vLGlyVgY295Vz2hqTUDadO2y3Q3OaMLEyYtODxz7Y10VGODqSdOXgOu9kwJtgV9qiZ0SArOw/VA1zHW5VU5MgZMTpsHtRpRLGonD7YE7+faacHY8viOv8szJiesf0k6IBCnlrU5gwGOvdddQy/oEJOaJpUvIBX/Mpwc1O8G1jQLPlsH3sNTHzuixg+hOv2iPFwNspnjOrj653JbnUph9tWaTmgucnxH+bgQgWa7CXd/SD0/oyQMuxc/ibNRurrscqxMzH5JDg/bfRHy1wKrRPBVoow1zZfGbkw//QybfV+rp58EGWq8+N4WHQFFV4pkS0hpjm/2Gn4uBcbp01RMEWuG1Q4ChBBt56Rwynr2on13t6JP84LCT9EsHYpSIkttjflUx7059jndqkbUzew8YpPB6zuPd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb4e2da-06ff-4112-284e-08de58cc780a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 09:07:14.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ln91NqPYKTvmIqajgACFn+56sCwzhXniIcb881OM+jUZ5YIWfKFp0O52IsesVqPjqVC8jEqDGojN13YVpW6raKZoowczwgCUyy/qC6i2qDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF72E3677A1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_01,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210075
X-Proofpoint-GUID: -qQbwS5DvfwPt9JDaP2Glq3n-gbb6gHo
X-Proofpoint-ORIG-GUID: -qQbwS5DvfwPt9JDaP2Glq3n-gbb6gHo
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69709746 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=O4_oMzoQTqZgAKB8K_cA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDA3NSBTYWx0ZWRfXzbwCVs94wDDw
 BLa7qaW0Y3rxxL9YHojA2TGaD/8XRm/1Kj5mAqKc+EbmImrRJTjgnO6noWI5xJz4Oy3ZEqj3mTm
 Hjn5OOqJLD20Q+Avr6Ff0h7WLGDpM6RhOjqgzN0XnrI6gGHbSvInoz02jSclUPruQaQyDnebKVs
 nxtSHL9mXWSAss6ieMBglTOwA4IEOQzs2TeBZGgU3tVj+Z4s7nGM176l4idRp2rNbs/SYBcTeO3
 SJYjM9l5og2rb3CpHqQRY3xbWv9EINBFDqHk2txcLSxbNHQkMNq49AbZ1J6sShQVf94Sqtq84SH
 lGQEK0fw/vweEML2TRdTnATTeNEam1N1Q4br8VWWM7cMjj/d87ULJ5p7Sn+tz8Y2bl4xt5iUVFc
 ggcpFrcxsZrWh4+oy02jS/YvLt2SC8knd8uKqy75Ckw4f+EBeVEwoKebHsUz3pY/ssvo5/321jG
 K9YDELiRHbBzrOJpTWA==
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28E7740006
X-Stat-Signature: 1wd5ixnut14tubksmw3uz1fnadqkpn78
X-HE-Tag: 1768986452-640525
X-HE-Meta: U2FsdGVkX1/+NQZDTpahXdqSIjwMefiTan6B22Ric/3bQTnurzysiVNXE4cbrusTIxHAomkMarSOOCGyJss1r5U6RuvSs2VnMRenfwm3iDcVa9CUOAxJfItiFK6fo8F75JfP/5d+LeqKWLZDv16liUuvww0UvJ1RS3/YsUPB0qK82wfylN+mQ7b0ryUW3Z5zZyMSqHJ9FxYC9ngmj2xpv1zNkRp7f3P1mQq9sAZKl1TgfRuggYbilXCiNnzfJkwTWDMZt9Dq2novBMIsz8htY7y1BfzVdERCA5VhUXkKfpIaXzD69BruIsy4JX8GfOo6Cp6227DbqK87NYoZL4sY/GTjZBJVFNBsiyN45jc5vYghHz2tCsE6yEC13LDZ7FQxibM5q0wCksbQhY5xVZRXo+Rmu6zR7nGkziqR01rb46jD01GeEVYxE2DE7uBqLL2Fgi3JfvJu+oVhYnsTt2mIitNNHaay2X50a7J2s1N0GSfUwPiZgooZfNjljD2XIo4xLjtU1gwWU0u87hZbMKTTAm03avqhbdtb+GlCKV5Cyz9BnZKi7wzvDTR4NgRlejzU74835ygcBRcSCM3NspXevNZ1TYHk2g0/EwZ8x/s6NYyptX9Nm08GYWRqPHEcvPhkU/h5b7fuz5/kvy2Zk5fvjYmnNYYvI5sUrxwlQ/jpTdf7Fs9+pC9Uox+5pBrqaggV0czeAOh/AVqWA2fqQQ6ge2X//xm+7mxlKTs0NyVXY0uUdQvstdbBsfLEiM3HQMEOclahgaL8dAWISuMPZ8OFP/x2xsvZ/Lp2ZTDI/Q2T+7geucW72+EJtAqlq3lVa2atxiSXA4Dzq6w9KoN7QA0TYGv85vnb+J6QSp3zqnJpYqPe46ErBUtF6usPUYxZKozZrfn3kfBjUy+3CNoqMokmp7+s/tF0Kk0HrzUMYmTYZKbMMs9GscSdYod97oYFkRrulx+QWnFbXMRcUT3LwhN
 bS5VKheJ
 KRl9G3q8VWLqrpAU+DzsCHr0Pn1wVSKxON1SUp0+YORC51azEB2QHG83peDT067WdlTbV3pTyeqmQvMicWKtVcJXgYFqxYv+jU8Xh59b8h/tzgdG8UC5ZsOio/YaiajqYtyhxP53XOhBOpqpNsUWK2pILbR1k4toOKC04WrnqHXIKCRzBfVdf/ufLGhexhqbYBQRi6z8h9CxjWhXa6xUkkbP6DSaRiDRXiItN2piwCm2GkxRPZ/pcnDRoRJDzssmutZnspw/oFlUZMEPhA3pQKLX1cXYPiiHjhIQHmEHra9u08Py6BaoRx7qhxIbMaUFVDK2JW1nPvkiZQv9Hv0dHYthufK6XNe4RN/JHuksbijmgiKVWkFczv1fCeWsmxfikuJf02b5O8m521O4C7hWGG5TitUKCfCkledWI6tsa5lpV3/T461WKeL1+3a6GOzZsoa8LcVTLtT2UJ7GKaJhQBoj2bIhxnFJPRE73vVsWdDkUexF7N2rOC+xcK2xH396a0ivxaX/tiMK9Gpnwvc0/xBqBvZ4lgeoiEeWAEYyU5xej8hYfyjtHNKKhrH3fw583TWjq277e7gKmlxdFG1ez8CTatqrL0McdBww+u5bNR1R4SyCQkIuZm/J5oxrxm9uXueHr+//yfJOJIY6iHxppBM1d6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:28:15PM +0100, Vlastimil Babka wrote:
> On 1/20/26 18:49, Lorenzo Stoakes wrote:
> > On Tue, Jan 20, 2026 at 02:53:30PM +0100, Vlastimil Babka wrote:
> >> On 1/19/26 21:59, Lorenzo Stoakes wrote:
> >> > We introduce vma_is_read_locked(), which must deal with the case in which
> >> > VMA write lock sets refcnt to VMA_LOCK_OFFSET or VMA_LOCK_OFFSET +
> >> > 1. Luckily is_vma_writer_only() already exists which we can use to check
> >> > this.
> >>
> >> So I think there's a bit of a caveat in that
> >>
> >> - is_vma_writer_only() may be a false positive if there is a temporary
> >> reader of a detached vma (per comments in vma_mark_detached() and
> >> vma_mark_detached())
> >
> > vma_mark_detached() and vma_mark_attached() I sasume you mean.
>
> Right.
>
> > OK so this is all very confusing indeed.
> >
> > This function is _only_ referring to the situation between
> > __vma_enter_locked() and __vma_exit_locked().
> >
> > Despite their names, suggesting maybe they happen on lock and unlock
> > respectively, that's not the case, they're both invoked on lock and enter
> > on start of TAKING lock and exit on completion of TAKING the
> > lock.
>
> IIUC yes, for the vma "write lock".

Yes.

>
> > It seems __vma_enter_locked() is more about getting into this state with
> > refcnt equal to VMA_LOCK_OFFSET (detaching - note elsewhere we say detached
> > of course) or VMA_LOCK_OFFSET + 1 if attached and waiting on readers who
> > are spuriously increasing the reference count.
>
> Yes.
>
> > So fundamentally is_vma_writer_only() is actually asking 'are we in the
> > midst of a VMA write lock acquisiton having finally set the VMA's refcnt to
> > VMA_LOCK_OFFSET or VMA_LOCK_OFFSET+1 but haven't yet completed acquiring
> > the lock' - e.g. having not yet called __vma_exit_locked().
>
> IIUC in the current code it's not used in that "are *we* in the midst..."
> sense but "is there a writer in that phase that we are supposed to wake up
> because we are the last reader", where a rare false positive answer only
> results in an unnecessary wakeup of said wanna-be writer, but nothing worse.

Yeah sorry I phrased that badly, 'is there a writer in the midst of...', not us
of course.

And yes this seems to be the case.

>
> And AFAIU this patch tries to reuse the function to ask "is the vma read
> locked?" (and we presume it's by us).
>
> > With __vma_enter_locked() called from:
> >
> > vma_start_write() / vma_start_write_killable()
> > -> __vma_start_write()
> > -> __vma_enter_locked()
> >
> > vma_mark_detached()
> > -> __vma_enter_locked()
> >
> > OK so in __vma_enter_locked() we add VMA_LOCK_OFFSET but then wait until we
> > get to either VMA_LOCK_OFFSET + 1 (attached) or VMA_LOCK_OFFSET (detached),
> > since presumably refcnt == 0 is detached, refcnt == 1 means write lock
> > finally acquired (but you have to check the sequence number).
> >
> > And _there_ we could have spurious readers.
>
> Yes.
>
> >
> >>
> >> - hence vma_is_read_locked() may be a false negative
> >
> > Yup.
> >
> >>
> >> - hence vma_assert_locked() might assume wrongly that we should not assert
> >> being a reader, so we vma_assert_write_locked() instead, and fail
> >
> > Aside ->
> >
> > 	Every time I come to this code it's like this - having to refresh
> > 	my memory as to how any of it works, getting confused, etc.
> >
> > 	This speaks to this being a broken abstraction similar to anon_vma.
> >
> > 	What I mean by leaked abstraction is that you seem to need to
> > 	maintain the _implementation_ context in your head to be able to
> > 	correctly implement anything. We simply are not abstracting details
> > 	here really well at all.
>
> I think this would be true if it was applied to users of the high-level API
> of the code - actual locking and unlocking for read/write. Do they have to
> care about the implementation details? Hopefully not.

No I disagree, a broken abstraction applies to maintenance too. We have to
consider _everything at once_ even trying to do change that are relevant
only to one part of the mechanism.

It's not the case in other parts of mm (apart from anon_vma) that I need to
remind myself of -the entirety of an incredibly complicated self-rolled
locking mechanism- to do _anything at all_.

>
> Here we have to think about the implementation because we are trying to
> improve the API (to add assertions) so that's not surprising? If your

Err what?^W^W OK just read the 'intermediate abstraction' bit below - yes
this is what I mean :) not the public API which is relatively OK, I mean
the intermediate levels which are very much not ;)

I'm trying to add a very basic and simple assertion of 'is lock A or lock
B' taken. And _just look_ at how difficult it's been.

This isn't a big change. This isn't a fundamental change. It's an
absolutely minor change, and frankly something that should have been in
place from the start.

I decided to add it to be a good kernel citizen (I have a MILLION things to
do) having (actually it turns out incorrectly) felt that the hard-coded
version of this was incorrect as well as wanting to be able to assert this
fundamental state in those places that we need it (very many).

After the feedback from Peter + Sebastian it seemed obviously sensible to
try to use lockdep as much as possible. And thus the voyage to the lands of
insanity began...

As always, no good deed goes unpunished :)

It's a hallmark of code that is not well abstracted that you have to
disentangle the _whole thing_ to be able to do simple things.

It's also a hallmark of code that I feel could do with being simplified and
more clearly documented.

So in the respin I'll do this.

The point I'm making really is there are _levels_ of abstraction both in
the public API _and_ the internal implementation.

The public API abstraction is generally reasonably OK. The truly broken
abstraction is in the layers below.

> complaing is about an "intermediate" abstractions level like the
> "is_vma_writer_only()" function then yeah it's far from perfect.

Right yes. This haha.

>
> > 	The fact I got this wrong despite staring at this code for ages is
> > 	indicative of that.
> >
> > 	Also the fact an ostensibly simple series has turned into a
> > 	'restore the context' discussion this long and taken this many
> > 	hours is further suggestive.
> >
> > 	I think we can do better. I'd rather not do more 'cleanup' series,
> > 	but I think this badly needs it.
> >
> > 	So maybe I'll convert this series into something that addresses
> > 	some of this stuff.
> >
> > <- Aside
> >
> >
> >>
> >> Howevever the above should mean it could be only us who is the temporary
> >> reader. And we are not going to use vma_assert_locked() during the temporary
> >> reader part (in vma_start_read()).
> >
> > I don't think so? Spurious readers can arise at any time incrementing the
> > refcnt via vma_start_read(), so the temporary readers could be anybody.
> >
> > But they'd not get the read lock, and so shouldn't call anything asserting
> > read lock.
> >
> > Anyway I think my use of is_vma_writer_only() is just broken then.
>
> AFAIU the whole thing (vma_assert_locked() after this patch) would be broken
> in a case where we are really a reader and vma_is_read_locked() returns
> false wrongly, and thus makes us perform vma_assert_write_locked() and fail.
> So the scenarios with spurious readers can't cause that I think.
>
> What I think could cause that is there being a writer (not us), causing
> is_vma_writer_only() return true even when there's also a reader (us). And I
> concluded that could happen only in case where we would be the spurious
> reader racing with a detaching writer. But when we are in the temporary
> spurious reader situation, we don't perform vma_is_read_locked() there.
>
> > We _do_ need to account for the VMA write lock scenario here, but I think
> > instead we should be good with refcnt > 1 && refcnt < VMA_LOCK_OFFSET no?
>
> That check would tell us there is no writer. But there might be a writer
> (not us) while we're a reader, and thus that check won't work as a signal
> for "we must have the read lock"?

Would it? A writer lock implies refcnt = 1 (or 0 if detached) right?

If another writer/detacher is in the midst of taking the lock then it'd be
>= VMA_LOCK_OFFSET.

We might actually encounter an issue where another thread's
vma_start_read() happens to pass the lockless check, then increments refcnt
before realising write locked and decrementing, but we get just the wrong
timing and observe refcnt > 1 && < VMA_LOCK_OFFSET, but that's very
unlikely.

Anyway the conclusion is we can't have vma_is_read_locked() at all without
lockdep. Fun! :)

I want to assert the right so I guess we'll end up with:

	if (lock_is_held(...))
		lockdep_assert(lock_is_held(...));


>
> >> So it's probably fine, but maybe worth some comments to prevent people
> >> getting suspicious and reconstructing this?
> >
> > But yeah we shouldn't be asserting this anywhere during which this should
> > be the case.
> >
> > So hopefully the above resolves the issue?
>
> I don't follow, but perhaps I misunderstood you above and it's late here now.

Well I think we've reached some point of zen now...

>
> > It's still racey (write lock might have been acquired since we checked but
> > that's just the nature of it.
> >
> > But if we use lockdep as you mention we can actually do the same 'precise
> > if lockdep, otherwise not so precise' approach in the stabilised check.
> >
> > Let me respin.
> >
> >>
> >> But I think perhaps also vma_assert_locked() could, with lockdep enabled
> >> (similarly to vma_assert_stabilised() in patch 2), use the
> >> "lock_is_held(&vma->vmlock_dep_map)" condition (without immediately
> >> asserting it) for the primary reader vs writer decision, and not rely on
> >> vma_is_read_locked()? Because lockdep has the precise information.
> >>
> >> It would likely make things more ugly, or require more refactoring, but
> >> hopefully worthwhile?
> >
> > Yeah good idea. Will do.
>
> Ack, thanks.
>
> > Maybe I need to make this into a broader refactoring series. Because this
> > so badly needs it.
>
> Yep :/
>
> > Cheers, Lorenzo
>

Back to a respin before I forget how all this works (again)...

Cheers, Lorenzo

