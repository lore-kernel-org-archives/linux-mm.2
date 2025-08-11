Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA44C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD138E001C; Mon, 11 Aug 2025 05:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184B38E000A; Mon, 11 Aug 2025 05:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0738E8E001C; Mon, 11 Aug 2025 05:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E91278E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:08:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C85FA11731C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:08:33 +0000 (UTC)
X-FDA: 83763900906.10.F4D6272
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id E1679140008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:08:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=01lttsQ3;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.244.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754903311; a=rsa-sha256;
	cv=pass;
	b=tBODyN121Tv5fFtFAna6YQJde9FmXxwsr9zb27vmmLC8EylvUKwMCns2DUsAJk0bEe81lB
	0vlNqhn1a7OmcSt6IiM0RSaoUcE6HE/c/WBKlAFvv2gW4pGakTx22yN30WxQvxIon6afDa
	uFUBvPBy98W1RW0T9XPfsC1jIdKDsP8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=01lttsQ3;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.244.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4q6fr2snxcPjm67BulbUwFEIA0kxCdNbJpLJKsOATvM=;
	b=iTMdFdDSzq2N/JWZT2z8UcwWvY/8C8iywtbk5MZVjwCd+IFZCCvOkmRRPKgO/caovjiNT6
	rEaWyZO0dkMlantLXrHJKlEjHtGju3Jg0aCOIoMjFFak0RUcj8YPmvt6WI4QU/INCxOqyJ
	mCn4IzZwRtBf1wmOLxUJH+AOMBsVeOE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKRtYUn1o64d9AH0vFP7vF3BSRXZ/H6BmQZ7mh7NMV/BGNEgATjOmaRd2XayZ22A3DFjSwwq6giMiKOOB0ze1U3iLdcVNTiZzgPjTW96sNktU3sDrrsYW6O6qrFX9wScOmEv+gkPp+fOZ123gNcEC6FPqqCiADf+P3UzpmbV7u4BZit7/shVvncGK6/GmClKr6xyZIWvjRoJAWsETLScZsTA914StK0WysHGxnCf+i//vZgeX7fvoy+dRCfq66HX2yo05R0waCwZp/fRv9vt1leJ72bJScFeff7msCBSc89ZSba8e4TNA92jfSOG92RAHHoUQs/jR0RMxKhb5l4vxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4q6fr2snxcPjm67BulbUwFEIA0kxCdNbJpLJKsOATvM=;
 b=q9NxeJoTzDDk7tI/55r5EXCE0yqUZReLooWPCpOjzpIFwE6NLPhRmFvHzzYr4Avw0FaNg1QSeV8gSl9WtF0cuxSNZkasgVHsgPU0qlhOOohaIRRTjsEcPe//GTUC9+44NTySzbQ6/UDAzGW6zsIQO9KnCu/ldCGCZdUYba07ki1IpO3clXzljyRI4Fr//Gx0m7/KT4CfhwU5a02x7ulxKqHUPH0hoGSYErQpkFChi5P6wmNYtFyhWX65Fnpw5i8ykLBI8qe71Zf7HtdgtyYV5dT45VyInfyAwQHS6KVvRA5fCa/H5n6sRnhXA6hx+O09sIsfLFTiDU8Msz+ZAdezpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q6fr2snxcPjm67BulbUwFEIA0kxCdNbJpLJKsOATvM=;
 b=01lttsQ3oOLQaYfeSx9xiCh1LtIE/5IwuVNwHewH41pCcde/rC2wJ9U3a+8KjkdpSsKzYr6EMqj9vLRP0VzB9buHFUTL5SLIF/xKdsFgJ2AF3rtQ6R48TTOxuN/DxR3Xuh2AXa8yPhMRnS/3DBLkNHm2k6+fmwLQmQiEUycKmQk=
Received: from BN9PR03CA0379.namprd03.prod.outlook.com (2603:10b6:408:f7::24)
 by SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 09:08:26 +0000
Received: from BL02EPF00021F69.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::6a) by BN9PR03CA0379.outlook.office365.com
 (2603:10b6:408:f7::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:08:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F69.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:08:25 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:08:08 -0500
From: Shivank Garg <shivankg@amd.com>
To: <seanjc@google.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <shuah@kernel.org>,
	<pbonzini@redhat.com>, <brauner@kernel.org>, <viro@zeniv.linux.org.uk>
CC: <ackerleytng@google.com>, <paul@paul-moore.com>, <jmorris@namei.org>,
	<serge@hallyn.com>, <pvorel@suse.cz>, <bfoster@redhat.com>,
	<tabba@google.com>, <vannapurve@google.com>, <chao.gao@intel.com>,
	<bharata@amd.com>, <nikunj@amd.com>, <michael.day@amd.com>,
	<shdhiman@amd.com>, <yan.y.zhao@intel.com>, <Neeraj.Upadhyay@amd.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <aik@amd.com>,
	<jgg@nvidia.com>, <kalyazin@amazon.com>, <peterx@redhat.com>,
	<shivankg@amd.com>, <jack@suse.cz>, <rppt@kernel.org>, <hch@infradead.org>,
	<cgzones@googlemail.com>, <ira.weiny@intel.com>, <rientjes@google.com>,
	<roypat@amazon.co.uk>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <kent.overstreet@linux.dev>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<chao.p.peng@intel.com>, <amit@infradead.org>, <ddutile@redhat.com>,
	<dan.j.williams@intel.com>, <ashish.kalra@amd.com>, <gshan@redhat.com>,
	<jgowans@amazon.com>, <pankaj.gupta@amd.com>, <papaluri@amd.com>,
	<yuzhao@google.com>, <suzuki.poulose@arm.com>, <quic_eberman@quicinc.com>,
	<aneeshkumar.kizhakeveetil@arm.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH RFC V10 3/7] mm/mempolicy: Export memory policy symbols
Date: Mon, 11 Aug 2025 09:06:04 +0000
Message-ID: <20250811090605.16057-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250811090605.16057-2-shivankg@amd.com>
References: <20250811090605.16057-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F69:EE_|SJ1PR12MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: f382ad3f-e898-4965-0e39-08ddd8b6a144
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KZBZtdxz6XzksrUYsaZpxtDgub6y1fGvn98kJg6vk2BoqXZkm1h/RjLzkOV5?=
 =?us-ascii?Q?PFmOzBwrtMUxcxesRyY/Jbo95snPcjkNWJWZexveWz1DyDE9DmLZ6yIKn5pg?=
 =?us-ascii?Q?2tew8IsSmzV7/P3WRMLznt/Vx5CTp6Q/W28WbxEcL8eb2FwMd9IZyGB7Q7yt?=
 =?us-ascii?Q?qeuSy5+RtjWCfDLNZlLmJgg0DYJZeIBJSoJ7deHdzt9DcrwXzXfLgbTZm5RG?=
 =?us-ascii?Q?yZlDY2ZtxfDnPfPLb+VhCj4tYNk9W7XNnV1RxUVlgkSKLTyooo8I49ro87OH?=
 =?us-ascii?Q?iSqKxaeYjhP+EBl480taKl0iBiQ/NOteUZGW0WOVchbO47UXgWItX7SRJXCM?=
 =?us-ascii?Q?3QyR/YzFUtRHIIGRwFvDkOV0HP/G2KysXcQF23c7d1QLtjofxDgvEaEpzFjU?=
 =?us-ascii?Q?VJL1hmp0Dc6a7zyL14ASDA4+Hdg9idHAD0DwJXslP8bPsrpaIinErQI6/HTw?=
 =?us-ascii?Q?DbxgoWvX2dSbQrqAf04S0d/00FsNUK2i5dBRbl8s/YZZ8Xpj/xdqjiMnCnav?=
 =?us-ascii?Q?14ZwUx8VnwjdlWSUytc0gTD/nCJ680uoQ9Jp26C+/flu9INn+b1XTH6KnliF?=
 =?us-ascii?Q?MFpEslGQBQlKtp/tf67ccCGuSwJpnAuROCgkStv2e/EeQYzIC2hMnWS2Z1uY?=
 =?us-ascii?Q?RBPj6bbJK3hy+c7XlXdtMRWVx/TZkn5d2DbmzyC/6Yk6DIVEHZMHObTVgnoD?=
 =?us-ascii?Q?myQMI9yvtufa5TPGZwVTPPcFmK0MV6lw+NBnB3SA54TIHlskQXDX/UBzjcuw?=
 =?us-ascii?Q?Pkxi3zrWSQ01uKmqsmjiLAoAK9ol3ZbdiStnyKmuYxKCZyjxgCVYNfkXYKTO?=
 =?us-ascii?Q?LfF1EWWptKRoyqXkybDBkhGCC8o58dkdIWD88EGrWdt8Yi6K8i3GwsWQIcbM?=
 =?us-ascii?Q?Xoos5Q9CKuERjLSMM1FdEtV/txfuzk844zLh54JQKqqWhAv9MQzuzgy/Zyg0?=
 =?us-ascii?Q?h4C+cc5eXr4IIhyq5+D0VUS6Updumo6MLo8n92LHbYHUGhe3EXNmqJnrU7v1?=
 =?us-ascii?Q?EHu99klhW5uUk254NxxVTW7ehUygtIlbuRAjXGNH1AAFcNdNq2muMW7xO2qD?=
 =?us-ascii?Q?ieHfwYdTdelb7SQTWYL05hnuyIyNJm+nBwy1gKdDATwvxXn3Ux7Cqr4Qn5Xe?=
 =?us-ascii?Q?lcCnKw2F+pi8NO48MgeqjDAkwE9V5KpEKayI00cTibupOa1FFZBbHiwPFsc9?=
 =?us-ascii?Q?FNZ4v6gn5oslNA4XHW5Q1clrga3vwx5eaSWjsshYvF3nuYLGO5rqweudnUn1?=
 =?us-ascii?Q?dajJlRMhvhuyi1t9aP5JPg3qYCNQld5v1Ej0805IYlJsaVN7z1Tv1/oGiUjs?=
 =?us-ascii?Q?33H8iEN8AmuucwJe/yha4Ul5bAkkUYxgOwI+3DmPzhaTpCjXeu67rjlgTKcN?=
 =?us-ascii?Q?hlwAvS4IpaZaVbyDE7yig0DmjSOaLW3Ow9BZuhW3qOs7lykfj1F4lwG0w3X/?=
 =?us-ascii?Q?w+JpUZP357wdqrEJU6sgl+pO2VvmwptwsBOxEuSgPPES4hQw2HMwwwNCCwAR?=
 =?us-ascii?Q?poBGqqGZYf4ruQ8fPr7+2hM/afeGgHNAbzjV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:08:25.7294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f382ad3f-e898-4965-0e39-08ddd8b6a144
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F69.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E1679140008
X-Stat-Signature: 4dp5g3y5ugzw8byaf84tzecah7egb3dq
X-HE-Tag: 1754903310-990581
X-HE-Meta: U2FsdGVkX1+LSy7AMSONSgixZzsrb28iaUAgF+NnA7ziw4dGrvS5LWvq9Xvo3Nv2NEyQrL70wR6J4eIv3We4I5fLA6vU9U/nw9/mZl9m2xDYEoeUWYO390WiNtvzIqouujuGpwYECnzcbWT/FQlevo66WDULd8raCCLTRWrBW6wS6LkafQFeMXMLNZJyUate4WMUmh5mNNei7YjORhFWwewYR6rwUAgoDK4w44EzJcVOSJ6WUdBnwQuJCYRroFgU0QVkqek/lDm43coQfQp6+WXX+HZxtOpKDQCHzjp/SkdWxbGmU1K3fNOc22GWP8LeDz0hjHV5QxlnX8S+iSa+nQqJWxCeoPQNypPNzwEDVkwGRCBl5SiCCh06OuRszgJsXXd8g4n8DWWeYvnbyUa6HgLjso1Tq/nAPCJtsBubvw0WvjyYNzQdCODcg6WBYudEzwZ9oB6bEB78csQXrvfrpiieto4FD3L/WzuHpgAqhicHpUYbsSVzzQQe4ZRdUcuSZlzoXDr0MCFc69d1wR0Kd/Y4qqgHo3SLtJg8Efyb+DZPIz8S9RxQvrnyY8Gp4znF+RPGbH+VwT1Op92RJH7PkSOPKCEzOFoQK5qSA2HHTPcHOdoYG2c+22+9//lrnBkPwD/W0rrHdXtzu1XA7y0i9C3UAGfBlBJUqS6R63eOnrb0RzuL5TaLxe3mwTwSf1+p+fmU4L/pZmfeCYBMYcBgP5HaUd8ezi27+YdaAsvr3jrqYIKmza6JxX9hSDX22WaFjcn3uybtSFEIxxkh1A8KN5xIwUYuPy8xJp1iVWjC69xnIIa/z8sDegUZSCO+WmcZdmsgufJD/48z2JOT6eNDtIZFOapQkH4G3bJ4/dPaHCsIDF67KMR0Z34bB2Szzrp6LHoeGIjvTSKYF0mi5MEytbbyyyZT/zPy42a3w1qSWH7NjnClvYX6pu2aYhhuE9SY19lt2FVd5rJOQzY0PfW
 xfQyz9TA
 jt4v5rA7AOeUBN2+R+jtzNw1ymi1ijvCBAHxA1GVudJSZVVLNVgrzET6wLj8u7/Cxa92/ulVq8SY1NS7RLTPH/RY68cOjWNTcVbMk3MuBku2L/6NhHbSn9BFbg3+dQ4/uHFyd3YLCBp3aSPWJdE8ZEiYMhkHSx0zpGa/SRm5GJZMlPalKXK/LfkdEWmgsLjUrxsVfkvPGJR8p8kDizksngWfp+AjFKwmygomoqJVDmsCjAw8GHfOsr0scPhNdADdov8zI0jDCe2Mx367cV9BUAGk286GUCEwRmzDmpj0ve+Mx0Ei3cXPKav+4IFN4PKzwJia1UDs3AhsVh1cJ1qDfIYWNCQSwWCHIZTSJmDe7lpZmN1+bDEU0rpSrp9aNtV5dwVL5Sx7cTVPrtRtq0TZrFwFAnSwY2FNpbHy1Q/OLuvXfEhPjgUqGLWIM3UGpH2OuY0nEqlA1KW74bn5/KWXMCVAzQuEngP2EvRqm66ME/9OU/pzC1L1RYlcEW69YVOT61doy7EH8evMQT/ytURs5YzGdh62OxTktQSqnMGhnMhggdLq8U/CD+HPtkQiMAq1tBwiAsn31l7gd8zrbXUd7vimfi/rT91RDbw23qhZRJOZNMH0fKkgXaLNBErlMNPEeUD4Te/WXlbZmHrtngmotM15QZw1Tc5FA3BKD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KVM guest_memfd wants to implement support for NUMA policies just like
shmem already does using the shared policy infrastructure. As
guest_memfd currently resides in KVM module code, we have to export the
relevant symbols.

In the future, guest_memfd might be moved to core-mm, at which point the
symbols no longer would have to be exported. When/if that happens is
still unclear.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/mempolicy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb83cff7db8c..d385202306db 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -354,6 +354,7 @@ struct mempolicy *get_task_policy(struct task_struct *p)
 
 	return &default_policy;
 }
+EXPORT_SYMBOL_GPL_FOR_MODULES(get_task_policy, "kvm");
 
 static const struct mempolicy_operations {
 	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
@@ -487,6 +488,7 @@ void __mpol_put(struct mempolicy *pol)
 		return;
 	kmem_cache_free(policy_cache, pol);
 }
+EXPORT_SYMBOL_GPL_FOR_MODULES(__mpol_put, "kvm");
 
 static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 {
@@ -2885,6 +2887,7 @@ struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 	read_unlock(&sp->lock);
 	return pol;
 }
+EXPORT_SYMBOL_GPL_FOR_MODULES(mpol_shared_policy_lookup, "kvm");
 
 static void sp_free(struct sp_node *n)
 {
@@ -3170,6 +3173,7 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 		mpol_put(mpol);	/* drop our incoming ref on sb mpol */
 	}
 }
+EXPORT_SYMBOL_GPL_FOR_MODULES(mpol_shared_policy_init, "kvm");
 
 int mpol_set_shared_policy(struct shared_policy *sp,
 			struct vm_area_struct *vma, struct mempolicy *pol)
@@ -3188,6 +3192,7 @@ int mpol_set_shared_policy(struct shared_policy *sp,
 		sp_free(new);
 	return err;
 }
+EXPORT_SYMBOL_GPL_FOR_MODULES(mpol_set_shared_policy, "kvm");
 
 /* Free a backing policy store on inode delete. */
 void mpol_free_shared_policy(struct shared_policy *sp)
@@ -3206,6 +3211,7 @@ void mpol_free_shared_policy(struct shared_policy *sp)
 	}
 	write_unlock(&sp->lock);
 }
+EXPORT_SYMBOL_GPL_FOR_MODULES(mpol_free_shared_policy, "kvm");
 
 #ifdef CONFIG_NUMA_BALANCING
 static int __initdata numabalancing_override;
-- 
2.43.0


