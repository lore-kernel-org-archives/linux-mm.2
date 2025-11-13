Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A660CD98FC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3158E0008; Thu, 13 Nov 2025 18:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69AF68E0002; Thu, 13 Nov 2025 18:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589238E0008; Thu, 13 Nov 2025 18:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 441FC8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:08:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC463B6C0E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:08:46 +0000 (UTC)
X-FDA: 84107125452.25.0296B2E
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	by imf06.hostedemail.com (Postfix) with ESMTP id EA6C6180006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:08:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wiOIrpet;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.195.58 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763075324; a=rsa-sha256;
	cv=pass;
	b=EUQmwrXpJjlwzKb4qBsk1/bysBTVlD2IYazlfqks1IOQ1F4gelFW1qqv4u5n4p9dmFtvRV
	yMubwOfgxAC/ynluWGz8K2ZniUhUL0jWaboxlHdN5oD2uMwje405bkmi1VBPXnlQtnIkqT
	gJwV1nIM95D+Ctg/emDmG4VPRZ2LBQU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wiOIrpet;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.195.58 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763075324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXkUAxV29gzA9ctRApxVOMCFB0Pe3g1OFlchS32WXr8=;
	b=TPHxH3UKZDzCeHp3cSZjWrad1r3+3kW7gIPy2VrfCPucfQ+Ll38Rhqx+YuQV0MlXBLi2Py
	+il8CruE64OA95Ev6TPUe9bAvB1qT6et0eGjJgWSdw0aPivs8VungJnK6uIwZNJuNAm9gl
	SR8scT2aNHQ2VApMjna+/+7pBgiOk7g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPRzgwWl5LPjVgVH0U39SPDD83JaA9yo/vfC4Yi43nfMwFXy43cvNirVqjJZqZYZgcvOzEc+FK1G+sYWhWzl4RzegFXDTNiqaOeh77vNyG7uaiu3zmEYRLhg2kBW4nVKW68AaZdDBysLHpXJR/hjnsx/MHhFSEWr5vWRGeENnaECpVm+iJxuIPq2NihBYHMKWq2XMPdEBRQuVkDe98mN9dDEB3dpKouBeMBz5K6trxvffBb/quCFRBVKmSu39EPLT24rTg0nz+5CBRVh8AgntBgTkmhVvow74rU53p/kZNKa0xPCK9n4iLeUlJvkNbeBGIMftDiEJ0yCkEH/6E/KMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXkUAxV29gzA9ctRApxVOMCFB0Pe3g1OFlchS32WXr8=;
 b=w0xLuM804qJ2ceR9PK5ypxFkdLJ60S3U7VyKJc1qPCrFJnQWsGXc8bayHOoBokTvP2/a+KYYXyihAAQenjfR//J2DzWphmqMhging58XzCEd2AI/nfRDLxJDB0xRR0Tc1pDpvKkIgBNp2RFbShZTCILvWAY8hLgkj8pc6mjCEwSYXHnEhGtEWEfBFvFxN6EkqtpCcF7k2gvg2CzGdF6UHogCJhjuqVfXlQsCOKZaLAq1op92YVfalefXutWjtDi/CSmQwScsPf+zyvljpsLugLNrHkFKEqEE0T1F73WZ389KCEhiyEpoT9xQCUQr8OaKdwv+PDC1Zx6bnZ89iDMJ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXkUAxV29gzA9ctRApxVOMCFB0Pe3g1OFlchS32WXr8=;
 b=wiOIrpetNdm7HdNrjAB8i8ba66f37G+fK2wKg4JsJPwRmzRG6ca514ddhb+L04Quo3oQtjgevqkKjc7nq1NiLROnCF6pmWJ3VpAQOArx9ZcOt5Z4FBmu43bHNeUnqds4KcSl8GUqGmxx/H5fRia1CJPp2n5JkfGdpjgIGTDPMgc=
Received: from SJ0PR03CA0072.namprd03.prod.outlook.com (2603:10b6:a03:331::17)
 by DS4PR12MB9707.namprd12.prod.outlook.com (2603:10b6:8:278::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 23:08:39 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::71) by SJ0PR03CA0072.outlook.office365.com
 (2603:10b6:a03:331::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Thu,
 13 Nov 2025 23:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 23:08:38 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 15:08:38 -0800
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Date: Thu, 13 Nov 2025 17:07:57 -0600
Message-ID: <20251113230759.1562024-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251113230759.1562024-1-michael.roth@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|DS4PR12MB9707:EE_
X-MS-Office365-Filtering-Correlation-Id: 35b22e47-0448-459b-b702-08de23099499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Zu8iPGAppimqAFbzu5Dn8fZBrLouqZGDx/Vv6BFoInO/sYa5FRBK90ab0Fe?=
 =?us-ascii?Q?/QpTbXXqo4tUMcMVve0IV7BeHa8wW//4pgMHDFFrhaagTrPKBcqbb4/dgeik?=
 =?us-ascii?Q?g6wDhyJur8wRL8Wo3vplu5k+HWgZaL2iSOcpWrCvycdr5BPrCao37icX9sFo?=
 =?us-ascii?Q?Bx2InKcCezNHBoVE2cO50XOYZAvY4/EC5jBhWiturI3/fLXSR8ByGFvO0X9r?=
 =?us-ascii?Q?H8jwsXMML6QspqkOUIU5z/R1gfTBQNOKOQ2kHaRw7i6gj1sEtdp8pFI0i7Bb?=
 =?us-ascii?Q?wDcHrNcbNhtIXuFiG18I5CMWLYJP5TLMdSQJKUfTLovOMVsHVtYB/LZnqeoy?=
 =?us-ascii?Q?NJXdLy76rDIvRW7v1bjkU9P2d7F+YIk0nt2JgOlaMB0LxnYWNulf+XOCoy/G?=
 =?us-ascii?Q?7yt+N7g2VdCpgWKt9ztomiloymeCat7CLksb5WpE/UVNlseT04RktpHpIiTy?=
 =?us-ascii?Q?J85Yp3o0Mi3dM10wkxQhyR7K2UKg88UiD7ilEWt45dPbzBo0WLRASn/4Ernn?=
 =?us-ascii?Q?tU4tbuvBl0QoVv+wkcsv2Gwqgy4mq9ALpEw1ohT3cB8SIMbNGzi88SW+8/Jb?=
 =?us-ascii?Q?pAJBfejANC84HQsjnbYrPeGrmc89uGGP3RYItpfs4CiR9m2X9hBhuYwOhKqa?=
 =?us-ascii?Q?XSfhGyPEQp1qzi1YcrSJ/9U0pjVJXdIg6f88IuLYM6NOyEivJvh5mIOG0qwZ?=
 =?us-ascii?Q?OWf9cJp2TugTC+qtee7eTkGizICALndqfI/jvwa89vS6q3OfXwWmABZqjUoe?=
 =?us-ascii?Q?HHeDhrJNDyT/KUxT41k+RhHQF8VNqVxw7b0whJQQV1nd1KAb+gje45Mp8JTJ?=
 =?us-ascii?Q?cc+TlQhpq7bmebSv+BTFHYVqCDEhbbodDP3XtdXcbUNsQZGNB5qgWyOgpswx?=
 =?us-ascii?Q?TVBpYFwPB0081dgh1PM1Ey0Gb9HhdyKfWLZ1EcGI+7H7SparNsp+LcgMGquL?=
 =?us-ascii?Q?46gOo1WlnL+7S89YTAVxFwrqaYIU/OlkRxctvNB1VcYGO2i1kL6Yn5Dizv4S?=
 =?us-ascii?Q?2NTcDg188zW7hMeRTyrE/WzFxBw3etYCVqbHWuq4Rfo1OEUpZNsMRj9J2aOP?=
 =?us-ascii?Q?6KQvupoBeI0CNxm1MQd0/c4EJ34xSLVXNCk5uhsEi/0d0hHixSb2irvtvccQ?=
 =?us-ascii?Q?KPUWwvdj01V+Vl3aZwsifoqP2QFtlRFc2yab6yd9d5PSFiz9dLRNs9LWfJN6?=
 =?us-ascii?Q?VmgQ2tpd0pTea/DPhPV1WrLkw4XMhcMKjM7mldMtucWMeh5ggtmpFrvGBIKV?=
 =?us-ascii?Q?OMznyqv5L/Ai+QG3+xtQhOEZanh/cp+u56+V+nUVTHAkwSAWejPlCIxN9d/l?=
 =?us-ascii?Q?Zlys5dHnArAOHS8wY9ShFBqoNTL507voxoaH/oEZ7e9do59O2F2SFCaWmgfd?=
 =?us-ascii?Q?hjagPGmAOLQTuTV14YLkKc9IepwYmlbLK/hYPspp4dhb2m4dyxgfvLk0hpu+?=
 =?us-ascii?Q?ZUJTGC2DmZxYRVRoVSsjC6Xjk1n7LJofFGW2PwbbRu+NvwlDKt59zEJisGbo?=
 =?us-ascii?Q?ev71XOJP/wA10iq7lcd5UkN/1Z8FoYHfkVzmkuhKs8wA1l9NzupDGyl97ram?=
 =?us-ascii?Q?Y7TlcTK/N3NlwAVPWlM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:08:38.6622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b22e47-0448-459b-b702-08de23099499
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9707
X-Rspamd-Queue-Id: EA6C6180006
X-Rspamd-Server: rspam07
X-Stat-Signature: r5i4sy1hpauspywdijbdw41w7kxfxa8i
X-Rspam-User: 
X-HE-Tag: 1763075323-685010
X-HE-Meta: U2FsdGVkX19jXaLTJNEZue4LEjuvRZoqZJCTGqGdWJ/oqmpp6ZSQ+Tc2lG8AisjANFr3S0vb2WZor8uYnmkJuiWPl5TAN4fGIBq4g7Kel8jNwzplANWS1W7qssnDg9G5UxKh+Dut4CMRb9WVfJBO6PZcYwlfJzA0iJJ2oIoga869p8Wcyu3WzwPvNjYMr8/oly53/ihMiNURNe10AxE/bPS3goB/PYUsYJ0bzWIpDRkkqJvi2G0b52lQDc+7XutnX9leyEyrhhAO7rm/QPtzJ6BJRFnykLj+0pusJH+aC1bgk4kGjpmQV+H7sa6060hmIgulot/+OELL/AgMWHQc/PWS2G3CiIfeplysWGrlaHyobYpfqaWee9HAHwN5IM/uixfTRopJXrMc16hhQGDVhQbBS6oTRBNp02AUh8Zl82MWH3LYwC18CUj3GYYqIcWnSoTD8d0ZFH2aK2govqDdZBEMczB7fI/ht7FYK4P08YWtJB4luU01gMFH8806xeNsXdpvVu5pc56c6b1MVPR57EIRn8zdR+nrVgaOUf8lZxJQ1CDnhmNeTv1PUAikwPV/UayBE/qyprZsJ0Ysjkdij7cZg4CFOfAkcjWJr3mGfX6nCXJkFulX3XDq/hpT7r1iBrSrJ9NSfN/w0WKaCv8gRsLO146GewyDTvDCWI3RZw4YTXxe0ZRUBdxdmn5KEvwuX8XCQ5qVN4+OLQE+f+Z5MGDNiJAUBVK6SXJH2t4uViE/ZljudvawDAjTFXEpl2j+w3U4P25A7YpTcjurWASkRDnxmSBG3gqPwaV3IKDEy1Gnh5eZxKjSY3Eh8hXNAbwDPi7spI3Bzd7bk1x/Hj7FgU8otvh/zvSLqEM+hY0Yrvw/BMTIG84MCWLqhZ9fq1PA8xKTFsd0TO83/hiXDeGwMcw2tZiZOgn8trwOWEFx/4mFPe1/r9qgxWrzrTfWfcZQBDuFz7qZyYwhtK4Lfwu
 R8Qti87+
 FsMAbHDjMo37QYpmlgRohw8z6H4fNd/J2bk8rhaiXH2cM14FKXicgGe+uDEEEFVouWM4Fv6oSSaU59d0eFOhf5pXeL7Q4ltfLIptVOd3n5QVZqeCBL1AWvaRPBQXfjCm5w2YJONz3kLmgbUWSBms8pU9Ntamm5uLo7eX6UxTfQrSSu564R+4LFJPdXnFDpzR8BZlZ8gre1YgrtlpcsPyZ4UipcrxCngjmB6QK4NkxVpNEzAJMSn/0jjbqNJT0fdLDLYs5zEpwZ0niWsmkm4uq2yyzxLx0JplRpHuHdr0VLsPaTSpyLNjxMlVKutFxUlY/MsYwF0LLWnIehuwEyNuHP9/o/gzJfsmkUDZ1M2+D1D5IPKFReWQDfW21qqM+bRGoa6UwwLO8xCC3+zl8hwVK8VUgem3AodtjbpKzZN6MKW6oOmQm1Yg45AHFvUDKW3WKVcaqsWQMrSwoEya4m0UtXj8Bw5tkE1NAKDyPQzJq2D06Fq1pDHmJIMCtbIZkAIcnFtLwT65eiCXqs18xB4xHxDlBsE9DZl5IcTOQUDoL44eIuzY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd currently uses the folio uptodate flag to track:

  1) whether or not a page has been cleared before initial usage
  2) whether or not the architecture hooks have been issued to put the
     page in a private state as defined by the architecture

In practice, 2) is only actually being tracked for SEV-SNP VMs, and
there do not seem to be any plans/reasons that would suggest this will
change in the future, so this additional tracking/complexity is not
really providing any general benefit to guest_memfd users. Future plans
around in-place conversion and hugepage support, where the per-folio
uptodate flag is planned to be used purely to track the initial clearing
of folios, whereas conversion operations could trigger multiple
transitions between 'prepared' and 'unprepared' and thus need separate
tracking, will make the burden of tracking this information within
guest_memfd even more complex, since preparation generally happens
during fault time, on the "read-side" of any global locks that might
protect state tracked by guest_memfd, and so may require more complex
locking schemes to allow for concurrent handling of page faults for
multiple vCPUs where the "preparedness" state tracked by guest_memfd
might need to be updated as part of handling the fault.

Instead of keeping this current/future complexity within guest_memfd for
what is essentially just SEV-SNP, just drop the tracking for 2) and have
the arch-specific preparation hooks get triggered unconditionally on
every fault so the arch-specific hooks can check the preparation state
directly and decide whether or not a folio still needs additional
preparation. In the case of SEV-SNP, the preparation state is already
checked again via the preparation hooks to avoid double-preparation, so
nothing extra needs to be done to update the handling of things there.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..9160379df378 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -76,11 +76,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
-static inline void kvm_gmem_mark_prepared(struct folio *folio)
-{
-	folio_mark_uptodate(folio);
-}
-
 /*
  * Process @folio, which contains @gfn, so that the guest can use it.
  * The folio must be locked and the gfn must be contained in @slot.
@@ -90,13 +85,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
-	unsigned long nr_pages, i;
 	pgoff_t index;
-	int r;
-
-	nr_pages = folio_nr_pages(folio);
-	for (i = 0; i < nr_pages; i++)
-		clear_highpage(folio_page(folio, i));
 
 	/*
 	 * Preparing huge folios should always be safe, since it should
@@ -114,11 +103,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
 	index = kvm_gmem_get_index(slot, gfn);
 	index = ALIGN_DOWN(index, folio_nr_pages(folio));
-	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
-	if (!r)
-		kvm_gmem_mark_prepared(folio);
 
-	return r;
+	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
 /*
@@ -420,7 +406,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 
 	if (!folio_test_uptodate(folio)) {
 		clear_highpage(folio_page(folio, 0));
-		kvm_gmem_mark_prepared(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);
@@ -757,7 +743,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					bool *is_prepared, int *max_order)
+					int *max_order)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
 	struct gmem_file *f = file->private_data;
@@ -787,7 +773,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = folio_test_uptodate(folio);
 	return folio;
 }
 
@@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
-	bool is_prepared = false;
 	int r = 0;
 
 	CLASS(gmem_get_file, file)(slot);
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	if (!is_prepared)
-		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (!folio_test_uptodate(folio)) {
+		unsigned long i, nr_pages = folio_nr_pages(folio);
+
+		for (i = 0; i < nr_pages; i++)
+			clear_highpage(folio_page(folio, i));
+		folio_mark_uptodate(folio);
+	}
+
+	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (is_prepared) {
-			folio_unlock(folio);
-			folio_put(folio);
-			ret = -EEXIST;
-			break;
-		}
-
 		folio_unlock(folio);
 		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
 			(npages - i) < (1 << max_order));
@@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
 		if (!ret)
-			kvm_gmem_mark_prepared(folio);
+			folio_mark_uptodate(folio);
 
 put_folio_and_exit:
 		folio_put(folio);
-- 
2.25.1


