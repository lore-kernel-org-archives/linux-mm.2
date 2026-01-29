Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77DCD3F09D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 16:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B856B0088; Thu, 29 Jan 2026 11:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219896B0089; Thu, 29 Jan 2026 11:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C746B008A; Thu, 29 Jan 2026 11:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E679D6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:48:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B4D489966
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:48:56 +0000 (UTC)
X-FDA: 84385585872.30.9ACC3ED
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 238C8A0009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:48:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bpi1Pvfv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fx42PgA5;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769705333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+ixgUQzSYVZrl711Hl/tgZFwqMVyLmTrfYcDI0yE5M=;
	b=jbDsiCxrhs+74Gz3WFCsyRD5rcS7mwpU0G6EbABsfe3WU4HOskF599xQFpgNeF05rdnQjZ
	mvvPgAky9MBU8CoP8KAGnjYHrrdtmc+tP+MCmDJSwIT5jTG9JQYCF2TDOpe2nVGe2X7PRC
	H5Tq/XgYJqL7HfH23oVNLi5uyrBzIio=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bpi1Pvfv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fx42PgA5;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769705333; a=rsa-sha256;
	cv=pass;
	b=4cJhI3ICOyAPoXhjbOKXppET9W49cX0hNoQddyeJkfAqTVynsMFhGFt98qLz/y3YFLFodT
	v1121pvJ7I66JoRTV5UUBqh/qdWtQuWiv2FHq9LXLrwtgGi0ZmbnbApYGCSnWHcS7hDW3J
	T1BV8FQNDCY4Px7/Dpk6nYwT2PEUWIA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TDgGgJ676658;
	Thu, 29 Jan 2026 16:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=m+ixgUQzSYVZrl711H
	l/tgZFwqMVyLmTrfYcDI0yE5M=; b=bpi1PvfvJhLRQ35onJy+1Ug8f/3OvetHhQ
	T3Mb0BqA+WTBycHMOysfakDKY1qmY9ssQjXMNVFJKdTPq1ym1MdhUni3hrYdVq1I
	coHdGv2tSQYj983oQ054yjfSoZUGmaXtywutCXO2IHOvL3sMsOOheSwf8SFT1zq+
	Ia73Pnw0hp+xS7jk04y7Oo47R4fYcjvSEJDFh/75bC+8aZDBTSDnx5wTPsweDZnK
	Dc1yZ6zJjtIMNK11fC8s+k+AWtxowslTqTBHnxKjahF+hcq/hzv1PF/ktFSdca7e
	nVO8LfkEdcUGeNwIsXUeac8eaeZgcDoSzIZGqIyGmm2jT3r7XYWQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgkpbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 16:48:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60TFo61d036353;
	Thu, 29 Jan 2026 16:48:31 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhruxue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 16:48:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PveSz83xdnx2dpnPnBzyNX2/ZHPWfmtktnEWH/ey8ElM3nP5nLOBdSm6/nIC3C85c2bt05EQngAGkPNGdt1rxW99zwAPLosPJjhaFKUIR7RCI68JUMG+pepMdCMuRaketTzgUeeD3mQgUpj1SPEuQjnqnei5urAszxzxUqc8BcFLC6yaf2bajwQgEhrazy/NHwJDcQJUMFXRnKtqrY9lcil05LtZ/k6Mz3fMHeza6PSKeh0/oy+nIcvybH3DjKQhxVtulA4rSImo8uYctiTGqldLBUeoxQnH2Ah0CfMZllOR1SXQ3Pc5SxvMrRXSa8chjqxoizY9z3e65PxEJApmgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+ixgUQzSYVZrl711Hl/tgZFwqMVyLmTrfYcDI0yE5M=;
 b=ozl8PnZYzkVurcBg/8kP6MwXQF7WZFF/uC3Yam7M6+BIx9HMSOMZ8dwmocnfZk1aGVgq7ONLBQzRYudjI5+PTC/cQM0A4vx3uBHtxBQKq7xR6R10uwEnOAJnjsZ7snnJhSWo2BbMQSJCqWxmZv0jUUSpss+3ZBGxGBp9h5QZSx4DFkdwP7GpbnOFbFPHzdcCsbPb0WiSnNZuqsgoHotVC8OmsxrJ5YLDRJ8vunTOn8+fTICAqZi0AuSAbYG6gHqjaAoW5eblMHcyMup6DGQtfQwww24KqAaaWnVVeNEjwwjP8XR5bHyRJ35SPCzK1H5vXF/IppioBA1axR1dd5uB0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+ixgUQzSYVZrl711Hl/tgZFwqMVyLmTrfYcDI0yE5M=;
 b=fx42PgA5q1IhtszX26N4cV4F9SH+wl0zPLfhI7DUI1jbb6OmTEDJqtdCtWM2YYrzXfomQjZy0bqT3wqx0XO3PDmzZOFIlIL4NyvDtgIXa7RphAAlx0m3AwmTLA5Z/LaNeVhZgKTperWlIVbwrTdGL7putqS6NEpco/I7ShZlejk=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB7034.namprd10.prod.outlook.com (2603:10b6:510:278::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 16:48:09 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 29 Jan 2026
 16:48:09 +0000
Date: Thu, 29 Jan 2026 16:48:07 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
        selinux@vger.kernel.org, john.johansen@canonical.com,
        zohar@linux.ibm.com, roberto.sassu@huawei.com, wufan@kernel.org,
        mic@digikod.net, gnoack@google.com, kees@kernel.org,
        mortonm@chromium.org, casey@schaufler-ca.com,
        penguin-kernel@i-love.sakura.ne.jp,
        nicolas.bouchinet@oss.cyber.gouv.fr, xiujianfeng@huawei.com,
        linux-mm <linux-mm@kvack.org>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 10/11] lsm: consolidate all of the LSM framework
 initcalls
Message-ID: <14638978-b133-457a-ae9c-31ba54e3964c@lucifer.local>
References: <20251017202456.484010-36-paul@paul-moore.com>
 <20251017204815.505363-12-paul@paul-moore.com>
 <20251017204815.505363-21-paul@paul-moore.com>
 <0146e385-935b-4f66-9e6d-51bb47ae4bdc@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0146e385-935b-4f66-9e6d-51bb47ae4bdc@lucifer.local>
X-ClientProxiedBy: LO4P123CA0441.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB7034:EE_
X-MS-Office365-Filtering-Correlation-Id: 7598289a-8fbe-40cb-27b6-08de5f562ee8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g65tFLNChCAQE9w0RXtIwXd4u9zl77B8OGt1Ht5p8L1j1AnXNRbuH2CaToeH?=
 =?us-ascii?Q?sGTytvA3S3IBOAqgH04OS0cUxYZ+YRfUodNRHlqOEdhV6WAZvuVBLl4JMDSt?=
 =?us-ascii?Q?zZAo20ETl8bBjhGjvu3M/bpO7xMBsLG+NTBraZc4dT83VvU8tepw1j7p6wzN?=
 =?us-ascii?Q?0rsFXC4qZuuGHTloh7EL3LnYZXXxIheyz7iEZiO/3Vofwv09N6FqcFmlFKtQ?=
 =?us-ascii?Q?RCpWW2fBd4rmoVwXiM9zO/cPuWNMrDGswYFWkOAGcqlEucpGgY1MgKNLaNYS?=
 =?us-ascii?Q?BjADEkDEk8YQKMhCAGjHgkEGm4p2dl3UFP2RbAH6kffgcIeLoM47beZSUUxr?=
 =?us-ascii?Q?qupncSm1lkTm/JsUKJ4v51nZoVhVF6+eYHe4ad086d6SomXEiVIMX0PXcZ5V?=
 =?us-ascii?Q?p4XovnZX1VtsPua4uvEnj3mJ39u7gnjpRNxAwbN9Tr7sYrSJCmZUK9Ly2tBZ?=
 =?us-ascii?Q?WBJx1oPkIOAzXBv/jaFtB6RpbTL/BqQkPfv0ENc/Uebfi5FBeFPLmzkEVIhd?=
 =?us-ascii?Q?OFivU3/rL0s2lVvlihqoySUkaXVStOPuEMOHmN+7kgZH4WDnNDPHtNw94LSQ?=
 =?us-ascii?Q?rllre34ILCqfuiyRV/7kPn8tvdZOBoo3Com0QJNEpGP5teA3n5NYJFqtU7Cv?=
 =?us-ascii?Q?4aUo5anz1fTuqfrgFx3Hvb+wmzz5ymH6Hhj8xj4+hfQNDj7xARv2NlP30uDS?=
 =?us-ascii?Q?thHZYQM5rhvmg3adN33iJ3ng6gEWIZXBLzhXRQbOvDtrQ6xwTQO8MJQuApgo?=
 =?us-ascii?Q?4yno0es+fvABSafi7wGYEJRGPBxhLLTqKd6JFsW4VRJCO9BbTR2587+M2Bj0?=
 =?us-ascii?Q?34IpcH/MeANt1lS4lUGQKpfiUJOooB4u/TnEja1z9f2rk022mFNQLUaKd1K8?=
 =?us-ascii?Q?F6ZMLEO3M+5wBxeT5nThTrQGKVpm6dhCXkTjY0YhcvIgUuEu6OwxLoXI7hDK?=
 =?us-ascii?Q?K4ji2oZFrlJmMs1VkHNpML+cW1Vyh+gxVWz4EmQ+TfwNkOhI+YpT06+GQsAW?=
 =?us-ascii?Q?8VCm34ljLivaIZ8PDt2KxnmlTBowgkOQfROeVOv2B7CtYrNd7wtYgckBUNbU?=
 =?us-ascii?Q?vO8MRM4m7Xq1rkbjAGLWJlYmyn3oQOuBT9mvmfAJ5sMvOvCuXyxcL5NvP1L1?=
 =?us-ascii?Q?iOwK6Gj0c+Q2rESpMjRz/B4e1n8cm4kb94Crdz5ElRf/Nbcxx/ajclWU0Mzf?=
 =?us-ascii?Q?e+HiUZcqfcZUsb3a31dT6TGJw0nbVneSTOUHCCcj7wLJ5Clfdy7VepIGKjIe?=
 =?us-ascii?Q?4rpWQu1bgfsGnPmdfM8YPVVdUE1l8mHB6Yekgo4KY2GzEv5I6CBanpfrgGBN?=
 =?us-ascii?Q?TQP71l9XxL1+pHifA36Tw/vRR5vR8UGZ6C8vm9tUxTCAwSJkbrENnflG+xOo?=
 =?us-ascii?Q?xkmeOwmqalRbm5qbK4R/ZAUJzFucf95Q2Lyjvw5r13vGqeoUoVPGrgDxmlEy?=
 =?us-ascii?Q?37sD+1HFF88bR5j56zw4ic/K9/6ua5KBYLj+o7tSlnyVXhZxCaiyDt0Td0Gq?=
 =?us-ascii?Q?dtFXrOVaIHgn+BFq915rcykp4Jil9MH+A0lfmWiagE6BJ+QpW+eaezHO/fxN?=
 =?us-ascii?Q?Na58aReZ6PJ5v6FfOLM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jYg/2eb3Xl2foCuFE5JMIy8cwCgM6FC9onRrTzqxw4/010wN8gNJyEmIqATx?=
 =?us-ascii?Q?vh9olca7yZlwi4TgpxAZlkAWq/v0R0BiC0UKvvVqjUePpjasWCJFe8Asyqeg?=
 =?us-ascii?Q?o4beQp+rA+WeL2PHzv36R5pG5rr3jva/YdhwbiP/sfMX8dayc7WowmWOmLlh?=
 =?us-ascii?Q?sv07ro074E1rliOxmguRq87HI7O539TRBgnmCbDKtC/nvZ90pPL3wTcsb3KM?=
 =?us-ascii?Q?pmLnsceXTnuG8zFMKLZURbWDQOCw+OPwL84CkolxHholBysfhJPwCBZLW+X1?=
 =?us-ascii?Q?c4KwhSDNSUh9gsGGUSWFwoTlDbGxoKQy0uDmDBJEeiY5MmsDSQf54zwl63P8?=
 =?us-ascii?Q?o01khxo+eR+7eDI/NjwxTrYwe9OGsthQ6LPcrHOwr4AiE2Zmpjd5rhLl3By6?=
 =?us-ascii?Q?AuSDvQwhNt4XOjkHOOnVoZYvj/Ditzx/RuqIB6BPBJ6d9y3tEyeBg2kUk6nR?=
 =?us-ascii?Q?8Qtd59sfoE1b1D1uZHsW4S/Vl2U+o5SDlb+h76A5WLJA2bxlTNANteIwXXW0?=
 =?us-ascii?Q?groi5D17JIQGqlByJAjUSaHIy//3//qpsMA7rhc5V5JrheLto/JhDHpuTCRT?=
 =?us-ascii?Q?pUKy5a4lBoFkq3wtvfOwHfSzWEwr8R51yxU76TcrvZG2nqMZKhnuYFNdxYFX?=
 =?us-ascii?Q?Ag6ENkKUEVQfgPiuGvXVg6y8oDGiSgFwhUw91w8zu0BDtAIx6EKTjLJ84ns0?=
 =?us-ascii?Q?tkDYEFBjF8OWzgUN/aNUcF7/lSq7NcRKJMdg2LRfYOKJjY9QZrT9h3jxrimS?=
 =?us-ascii?Q?xLhAJg8dDZcihgRc4Pq4NNxvMp+KZghpL+qyuN9u4Uu8gfl0C1r6qwkiwEMh?=
 =?us-ascii?Q?IYKnL0avfe2VYneXIz1pq9Luax9zUint406//HFdJ2lXVlmmn1qQ4kXicaaI?=
 =?us-ascii?Q?6R/MI8GqFgtP2nmeHVGcN+VMyHoZsUOKPP6QWaqiMP8mUl+Xov7mXhub71Bb?=
 =?us-ascii?Q?J4+fGHD5muCZOwYh+sMlDm8fn84CrTtCE45aWjk5Y6zM0698ol5AcnTHttDh?=
 =?us-ascii?Q?swcv3gbdqIf+CMDIi7SRMkakKKyoADUrg3upfd8+4C6mMhqkBIs02i/fYsTV?=
 =?us-ascii?Q?GsjqOqQ8H8kmTFc6ADltT7unvO51ziF8wZExujThvRipm3LeyEw8obumgIi8?=
 =?us-ascii?Q?Uz5RaKQGrQur/0ShXAfo+Ge8GuX7x5e1+DOX7bvRZyp8SWlMxFDFeweM2Dvx?=
 =?us-ascii?Q?zdrnFNenc4Q/6sNqJJHYeLegGFX4cmG6dJ9X+Jd31Lf+3Qj0mhRV081rF9+7?=
 =?us-ascii?Q?FhTcQaY8D5uohX3s6TGj8totBysbPJzFIsH4qafFMj9D+qpTQtiVOCKGCgGk?=
 =?us-ascii?Q?hnudxEkz4quyjJb73Qt48v2TA5uitjnfg7SUB8ZwW2X7hzC1HeG8h3dXBTL/?=
 =?us-ascii?Q?F6+aj/R1ioC0fFEurX6brYfd4PXGTQWt3xqtqFrer1WBlsSH89Ep+V53pkwM?=
 =?us-ascii?Q?H4dZltUlbmYIQE3TOHweDLBvkM93H931uA2oYIm/ybK2AGJ+fPEmnUXGAeYN?=
 =?us-ascii?Q?q30G+KP+xxkq60AAxrzWjiefPOeOl40ah3TmjY52BfNFTLvyhVVff7bYH/q8?=
 =?us-ascii?Q?KoliVxLl1yoo/iMWUYqZeHbAkAr6nswpllTOvg+OChIV48b0/XINofzrwnY6?=
 =?us-ascii?Q?kQo3ysPdqJAaPFW5Seb4ltfmd70h+83TeqZd5czkjXO9u5m1ZqBsRNXy8cua?=
 =?us-ascii?Q?+Dta0ba16XGOe1ZcJv5sHbKNfd5qOB2bS7sRjEJf4QfcVTKi153Xqt1pN3JU?=
 =?us-ascii?Q?Pn1hOBfrg2iYdOlb0OS7HTE4GwU8pTc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X7rg28+znOAKSU5qhAjzTAAioTD9JxbwbKDZjNSN0qGLqjVge2OE+45HjJp6phCHZDfaTZK78OFWUivbaK6cAkZwd3aTQE/rnVp0J+idDZXKbHAmiv0wUH/uZtZ3/A+LYVFyFVa9udBSda6t/ZJcsh3cMmkGrIKMA9B8ass9H7uzIinBRwQfT8tRJ3clKSOjsOgvje26hBHRrfihXzkRbr3W/kROUozPGkiax6Qn/9wL6cUeBSJJ3psokSuDsv0YA69kZsZwEPfgaEt16WXbjrv1wuwiHKW4pKIj+uLQs9JJQ3agoJ2cryeEz3nqpaHGsE9vZc9N265vLuWk5fYvsTTBAPvKCqa1w2FvTiZrnCz7N8wcYfNWkxRHSCLKJ8CnD5zpk4wxwCHLJAztr418nIoesuOB5yAK6JlNV+K6oxxS9KodfQJZ6nDUYKcH5jC9lHvgdsWGbHVKKjgP1iTkR4cHNvCSkUzJPyqMfMFsCUCKxfAgme3kzfP6Me5Yip6FJeWdjN5vimcD+Ld5Gj1Qkka8q//FPTQjXgAJ5SqDrxrJVqbOvu+zwERnK6NZdCg3h/hdsOZiU6zFGfeXC305jYg56Wx/+yg9VjaHf64UenY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7598289a-8fbe-40cb-27b6-08de5f562ee8
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 16:48:09.3117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UOCHxzdoJd0DBY+otCYexaFBzcrz0j9ii0PX9TM/580Lk5vtXCmqPcTTShhMvlsuNSl6YgFr46w+WtlJE6sDCEstiYzRtBSOyNh5/9atC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601290118
X-Proofpoint-GUID: RRmLWuG3ik5zyUtvIylxp0iP94lirtfW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDExNyBTYWx0ZWRfX0/qYXnDDu+SB
 XRO2/6iMKsEScwTZ/YHeRn3xCXBISyXMqk25k+palfMqkuEQch63GUH3u88uyCGB8TrHCXxgDPe
 ARH1GAoW67+zbu4i6Fb20H4ouDyQZvWxIGuUzxYTaOxXpaNG3nsO4lv9Jh0cOq2LV+fMhBKXahk
 mExmgG2e2haUvA8asB+Q/PBDlBC6vLMJXVUQ1X3BbBJDZwPPuSeWetLBektbLaCU/0cCOBUQTul
 d327ondWjxhhbxcICxCPQKp/AoCEQbeGRxo6/EFluj2gCdiNmqrOSNrtV7v0xR93VnKbgivVdJW
 cOZw3j3q79K0dfK4s5WrSr30QYLIIsuvWjinCDqbxjgR2uMfhdPhqMJT9USAJgEIM6587DonmQu
 HqLJap6SBAWBcoo2q68KK/CtgeWX4BdCZmEwzrahs+NUo3SW04aauH15+3ib629eemYTdkXma1z
 pBdkw7GqGceD0SZxInkwveILMwNhI6FXM+FxhYXw=
X-Proofpoint-ORIG-GUID: RRmLWuG3ik5zyUtvIylxp0iP94lirtfW
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697b8f60 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vpqfxihKAAAA:8 a=DfNHnWVPAAAA:8 a=xVhDTqbCAAAA:8 a=LIqmfhf5tv9GQyBJQXIA:9
 a=CjuIK1q_8ugA:10 a=AULIiLoY-XQsE5F6gcqX:22 a=rjTVMONInIDnV1a_A2c_:22
 a=GrmWmAYt4dzCMttCBZOh:22 cc=ntf awl=host:12104
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 238C8A0009
X-Stat-Signature: jtm6x6epk4zsf86r4axb3ayaz9cyzcd5
X-Rspam-User: 
X-HE-Tag: 1769705332-69451
X-HE-Meta: U2FsdGVkX1+4l3cGiiyxBcWky7YKluuSp81NjMuM6lq2Gd36qqJvtAa4ZOhAC2XQ+Utvivu9x3IgM6H9T4izE+Tr4r26MkAR4a8tA6BRqkBRiT029rNVgBCZ6zjF/RjA1tqcn1nm48rUmDyed0BxIaZPN+s4Rjjhq9MtJk03K+XYlDaxFKxUP55R+agUPFhW5o+MisgsCOB3LQa6I/pSn5jG1BiVwafy5F7IKbVRhVTzCUmM6bcC9mwt/Dwsa7V3k5xKiOmbop2re6SdXGOTSCPAM63zc/PiCBsdyEHiuEVczsjfjujAL08D/dc2BpE8hCfvl3itDyhoS0cDSmTWhOQoBNubpGSDIeg0+h4g6zH8bupXtkflxlB0cNegV2BSFxA/yNeNE0ci6k7BOKW1nDeAeX5DcYgKdsWRDcX1naiu7ZXr61htGuF9ZOuhIrMgc6urFadmzvo/YAe84HVhQhVi1wyc2nPn2heHYrjYx0XhgoOpPczU03qZXfqEbViwAFRpwHXrOTP6Nn9zrurhGK9J/OKMh0ofV5fxbFcl5pXq9XltqfiY3yHYvXusYyzwh//KsU1yHFOhAbR1XgfPTRPTlwWBPgbOn2ptzS4pltqruO1Vn4/CA/CD6tEge5Ha6irPCv1yf1CqUQMhFtuktRiYM7Q17YOxEwrVWDTh6m1DhKUJBwWSiBX46DFVbm9K0GROEq6/GZpUNnH/cQo3ZlnSqBbMtV8tMYkyu4NV2HBX4OFftk13gC4TQA1A0EipliEYELhVAog0FV84EN3KF88MXaNM5OcOSFN+T/QrH8pYxujclWz9g9aCRHmDhBz9E1JA7W/dgmItg2bbS4hG2OsdtKfpC/WAVAyhAQRFMhMg7PM8fw4n7MImYrY1+2vJs5JBZV0Nwc1NLrn5Hcab8itiqUCb5IIvpGic6nwSF9RcWCXExZJJCth9Vi07LS7Geni4ABpkIoDD7Irl8V5
 SFhFGxYt
 ArYUqmfgCoGv9mClfVo/hStzN1CD7c/OtS9BPJqwFKjFBWBW7hZeLn3atGv4k/8mUJfj5Z1ZoM4WnXT3Md0mClBX9rD8lQLMOB1zKcet589GYjsbaHz7qS88muOPFetu6o3SkE0GwGOpRTxCw7/JhlgrlLx2ka21iOoDn6Rzk7lHdi/LU3kTgUXldF2ORThO/qpJ54rhO1qz88Fkb4ZiCk15BJ7XjTKv/4uvYflt9GnLwJ8vCwyyR00WkdZ8Ra2NHA2oh4HQ491PMtrRli2RSW1o9F6eEyZF2CNnOrRR5JiUiMPiL8wxJp20/dG/uZkU+Nf83sMYAYf5O8uVdx0GohSNfXNd2TN3C1A1ZowETTvggNMkvcPyC/qmCFYXHHBDWB7VV4LfHF23s9CpjX16skhIKc7fyll7n9woyQKupTWJgyTVeEDpLJCRwd3Sg06Gtr1/sjANv3/KChJCiASt91iTqlJTtxz66ocFgebcruAzcgtuEzqSc6rpYh3QdjPsR3UGBvTHlCaBFC55BB5S8U/uLJTdWU4p4XFm1sizwBnR0Lc2ZwNnHDbeeILmwlVJ/qiFx2iWClQ/tQD43PM//Rtb4hbqbSW90C7gFAF3Y4p6t4HuOODyqxYXQgEsTHeZ06qmvnqWk6LwuiCbTOUYZI+0bLVv7Xh2uSr+0rBY/6aUUTi6j6iHWbN9Nvd4JAvtLn6fSw3Ae7ascKuc4vuGBH2VcckAfA7oBgNLjP0Ep7KOdrP0BPNtU1MJ0Cbhvgqc669tjlyjUBVZ4Q6Sf/f77VaxxlyZqXlrcbZopsyMnD9BtmW0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 04:31:16PM +0000, Lorenzo Stoakes wrote:
> +cc linux-mm, maintainers/reviewers of mm/Kconfig
>
> On Fri, Oct 17, 2025 at 04:48:24PM -0400, Paul Moore wrote:
> > The LSM framework itself registers a small number of initcalls, this
> > patch converts these initcalls into the new initcall mechanism.
> >
> > Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> > Reviewed-by: John Johansen <john.johhansen@canonical.com>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> Hi,
>
> This commit message doesn't mention at all that you've removed
> /proc/sys/vm/mmap_min_addr altogether if CONFIG_SECURITY is not set.
>
> Did you intend this change? If you did you should probably mention that
> you're doing this :)
>
> I mean it's a bit late now as this is upstream (but not _too_ late as we
> have rc8 ;), but this has broken something for me locally (mremap mm
> selftest) and I bisected to this commit.
>
> Note that CONFIG_SECURITY states:
>
> 	  This allows you to choose different security modules to be
> 	  configured into your kernel.
>
> 	  If this option is not selected, the default Linux security
> 	  model will be used.
>
> So is the 'default' Linux security model not to provide this tunable at
> all?
>
> Though I see LSM_MMAP_MIN_ADDR depends on SECURITY && SECURITY_SELINUX, the
> Makefile in security/ has:
>
> obj-$(CONFIG_MMU)			+= min_addr.o
>
> Which suggests that min_addr depends on MMU only, and not on
> LSM_MMAP_MIN_ADDR at all...
>
> And I don't have CONFIG_SECURITY_SELINUX set yet have
> /proc/sys/vm/mmap_min_addr?

Sorry to clarify here I meant to say - if I set CONFIG_SECURITY but _not_
CONFIG_SECURITY_SELINUX the tunable does in fact still appear (and afaict
still work...)

So LSM_MMAP_MIN_ADDR is really weird to require SECURITY_SELINUX, perhaps a
historic artifact where we wanted a different default or something like
this?

I know that we use that in preference to CONFIG_DEFAULT_MMAP_MIN_ADDR if
specified.

The description really probably needs updating.

The key config here we should be looking at is DEFAULT_MMAP_MIN_ADDR which
emphatically does _not_ require CONFIG_SECURITY and also in its description
explicitly mentions the tunable:

	  This value can be changed after boot using the
	  /proc/sys/vm/mmap_min_addr tunable.

The mmap_min_addr global value exposed in min_addr.c is referenced in
several places in mm and other parts of the kernel - fs/exec.c,
fs/userlandfd.c, kernel/sys.c, mm/mmap.c, mm/vma.c.

So this now silently going to zero everywhere and ignoring
CONFIG_DEFAULT_MMAP_MIN_ADDR is surely a userspace-breaking regression and
needs fixing in rc8?

Which means that... people can now mmap() at NULL everywhere despite setting
CONFIG_DEFAULT_MMAP_MIN_ADDR > 0? :)

That seems like a _really bad idea_ (TM).

So this is emphatically not a report of a trivial self test break, but
rather of something more serious AFAICT.

So yeah I think this has to be reverted/fixed.

Thanks, Lorenzo

