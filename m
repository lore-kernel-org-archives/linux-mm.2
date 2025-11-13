Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC6ACD98FC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8965A8E0007; Thu, 13 Nov 2025 18:08:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846058E0002; Thu, 13 Nov 2025 18:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F408E0007; Thu, 13 Nov 2025 18:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD188E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:08:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EFB2C01A8
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:08:29 +0000 (UTC)
X-FDA: 84107124738.16.4D49C4E
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4559B4001B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:08:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=o4e3Cx6E;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.201.56 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763075306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G1TVTRQ1jER/DxMt69RxdvETRcnKUbIgUoXddV1bGNU=;
	b=EPZVA9nf1foXpXC+1or7irSuc964jpP5NQDbHPQwZyCZIGm3tbk7Yw+aQqOwdnIy1arbrD
	WPVuIF9OsM3VPTQ5gfEjEJnlAXohTVqEN5idppKiOtMqOK/Km2Q9eC7NZ2xvGjoLTEb7U0
	X9d77++RGjh2xBfY5JinmMV3y+0RPcs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763075306; a=rsa-sha256;
	cv=pass;
	b=7Fxyjtqce74H9cOrwrjN7LHA5C/CjcuxQDUr8bGtzMlxWSm4k5DP6fBQCLV+BDHh6VLHR6
	ur55FzTCn4EwX5dXr/kzJIczO5ErPoWDG7iWsoqXNLLrNovkKVbJx5uZwgInKtZsD/HKzn
	hK7mKgkMoBmVN19l41JaP157liEauXI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=o4e3Cx6E;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.201.56 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hNOUVyurBsvf+vcftDuVBCNfiydhc+D8BuAtQebeMwy7BvPyZsYe5qKXbGtFdPvgpmMymgcMUoLpf30/eDAfFh4gUmoIJP6am1d8bR7I6LP6RKNjYxpWZPQT03u3IwyqWByKzdfgmTf9+LFAQJfSQSeT2MKSACXi5cvUvoBl346lqpF3772W1BASspIMKbgFAlAOmzHHLWC+OmUUP/UfuInvuj0BWGEbdMcjdoyThaeo1csjFL2sJrQrUoe+8Vc5PEBa06g61RWSg0CT+YrMWRJ1p1CV5YNetYZuZvu9voz+2pNf8YbW5GggtfxyugdGwU55a/pUQ2cRVuDf8EV6mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1TVTRQ1jER/DxMt69RxdvETRcnKUbIgUoXddV1bGNU=;
 b=F9tnML1yTDaY0sHQGDPlNSOXZjsIPDn4vm6xpM/sOnAU/oGa7D2gMOS1Efw4FEJl80jUDBF2BrXWNn9Ywu+Zl7Lb8d/RDBESlJmqdszwf6m1iuiojoWlixzNDFSZ2t9y+xRU1X1Pw2h+7sGDajhhgZqmVKfrj5TUpmoPc9BJhOvarKx5n/+pxdGAzzBrzzzUQYyK+AG7iI0Gmj1qcVpy3cDXm8BVNF2ln4o6k+uRdcnfySfgRzThFmzIt0MTFy72twT2+jSwqAhDJ6c0L+7vJzl5Y8d9IwX++urz6n3ue6oQHALrhWKBcDp+LPj7hKb+VlvfnBW05+MbXhOSzpueTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1TVTRQ1jER/DxMt69RxdvETRcnKUbIgUoXddV1bGNU=;
 b=o4e3Cx6E+JmWlhmhzclM9dqeX0rMo5veDg4iTnU4YywE+dcqpSczM9BNerGy2LZj7enNY9imJX6TXydXfR21qY5us//HIz+fKGcOQH3sD+neXa5JBwgVZ0SNJH/TABe2r4mLGofsikoyTt5AR6t5jtM7+fDX7kQ+8RvrRPP5Lp0=
Received: from SJ0PR05CA0069.namprd05.prod.outlook.com (2603:10b6:a03:332::14)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 23:08:18 +0000
Received: from SJ5PEPF0000020A.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::17) by SJ0PR05CA0069.outlook.office365.com
 (2603:10b6:a03:332::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.6 via Frontend Transport; Thu,
 13 Nov 2025 23:08:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF0000020A.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 23:08:17 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 15:08:17 -0800
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH RFC 0/3] KVM: guest_memfd: Rework preparation/population flows in prep for in-place conversion
Date: Thu, 13 Nov 2025 17:07:56 -0600
Message-ID: <20251113230759.1562024-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF0000020A:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f82279-0bcd-4775-3c7a-08de23098848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uijjmEqF2zQ98WcLtCU7KtTQMbqWwYwY+2vpFnn/3PhsL5i5176xw4XuQGDc?=
 =?us-ascii?Q?CqyMYU8rfOfDc5UeoW7SS40fYVi/q8focJplc/ZV0AfEyWe6LL0VdbeqkMh7?=
 =?us-ascii?Q?0Q4IqFOj/64PErz3xXzrhWMultUaKlE2IxD2APwuuKg9+EJSKrj0Q9Uk9+Cy?=
 =?us-ascii?Q?4P0CRvIys2OefFxut3x805TtcUpUCqaN1GHopzw5n/J3cj2lP/yUOJKb9ruz?=
 =?us-ascii?Q?jUQ97n6iEJQZtxQutMfKrsZqMNk7hBdr61VaUyUMeyK8jjQANpduININswqD?=
 =?us-ascii?Q?FAqFOh04ca8V8YDH+FdSPCDwn6axfYmz3pwoRx/WBqRcskaUdwPaqg18n1px?=
 =?us-ascii?Q?NQdGDbzCQ5lM1uGBap9qt7P9VxVJV/BZDnlTSRgJsoPKBu692O+vWGuJpkJO?=
 =?us-ascii?Q?UMtmuEsKWvLlmKWaOy5zbAuoRfEGbXdcvm/UUAZ9C/J8PF0Vgc9WpKSLeg/B?=
 =?us-ascii?Q?JQFxPlk6Wi3oqBNFogZCEhCvBYnkaeBEsx/nu4E7fMvVTkjg0wwuTvIDL8BT?=
 =?us-ascii?Q?1DjbXV1dQ+c+g/pw10E0Guf1h2giXMZXAlWDTUvtqwkuoW2R5ptvzUIhx6Wf?=
 =?us-ascii?Q?ceXyaVMSOLHrMnuHrHhDoYwS503KxNrjPj2Ecxqv/AaSpu5Svpd/y6QJ5exC?=
 =?us-ascii?Q?VZjKrDUOqYAAyP4DzdfKQ5dEkesjA4PrC5htmxFCO9iCBCA5Tf1254UeP24B?=
 =?us-ascii?Q?QZEg0Zi8kqBZoHR9RQYrdzKVxLM0QO0QHbAPOZROiRKezWQL0o6eak6bhzrr?=
 =?us-ascii?Q?LfiL2L85sG/iODOeY8uggFWLEHK+ubXn+ecZq0HRDuwuNU12uy3OBXCAAki8?=
 =?us-ascii?Q?6qAGKpxRrHbqx3eVou1copWKCEdyhIZl+w6G8MuAXPgZcU+oWypR8CU9Ykzn?=
 =?us-ascii?Q?u22fA/HLxxsi6+/OaiqV78baSohFli7quyuFv39Iv6IEFEjb5XYB/RvI0kxr?=
 =?us-ascii?Q?KU5Ng+WDAr/+SSxZhl9uF8qSrYnptYajHEqoFOD0+m5JB3h+7XDtQWsCOylH?=
 =?us-ascii?Q?TzruxmQJVUIHbCAOOsuVvARlI5wo9nX8oYh7x3KYYKPM1aq1y2cW5lEDqV5o?=
 =?us-ascii?Q?ygYs9c9v8ch74yrZg4w4Se9RDkZWJCI32RzPH2MFKw7QJ5vYJHDzNe2DU2EV?=
 =?us-ascii?Q?mtQhlHt7kHNMKLAsByFfrTn7FMYAB6z/qBtS60iAILVDDuTweTl7GxUf9RlL?=
 =?us-ascii?Q?kMIxLft+srGdWoJ/A7fAOKth/YvjNWA/njqSenXLNZJeTaf0tbO1BBSJAMbq?=
 =?us-ascii?Q?j6AvPsBUciphGyjdXPXMp5NcK05hNvVikSiAoGxNk0gVJrfl+07VoBmK4iBk?=
 =?us-ascii?Q?pBG8gCqIwdE495b6Ry3Ee0jWXHohf/XxWvhBuhlF85Z9PCZnJ3ho90qSJKkP?=
 =?us-ascii?Q?UPvY6kMGJL3fX9yUBZ537nAgr6vtITmFP6QEh/lEdfxb6Ja8Js1Y7vhDqN6O?=
 =?us-ascii?Q?uRkzpCvDQX+wMLWY2p0xY6AsPygtMARWWLeyZHsNKucycwDS5tzxnZLcWS8R?=
 =?us-ascii?Q?wPtY10cF1pdRfItj9EL7HfFJlelhPlBHWc3SEghll+gSli/l9BMq4VGfiD/o?=
 =?us-ascii?Q?zqWCKOapfSeuX0K1PTpWqEFW+hhO1PNKJgGaSPaa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:08:17.9974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f82279-0bcd-4775-3c7a-08de23098848
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF0000020A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813
X-Stat-Signature: 11rx9m4wkgooydmy5ihgikc3knrcpp5t
X-Rspam-User: 
X-Rspamd-Queue-Id: 4559B4001B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763075306-167450
X-HE-Meta: U2FsdGVkX1+hB3Gm02legoiJGWFfIuS4aWwl10hSi3RBEyttjdD6pCO6qWhscXcxfpyWCSftjkGY6nFnuyZUU3NcBmh+ssH2PYaECvIISao45Wi6q4MAuHh7GCeatxVLg7j6U5xHVI3HgqWSqkVmHWPD7K1K3L0807vRuJVzxC5XLWfqPnYuyq5CvvIHrkZ1AuhALtdAKuqywUk4PGBBs2mhGEbFo/icSNWbQgmFul8ZY4t7UlLzqZIsF/zss5Q3WrxQ7T9Toam0CDZlIDx3jMMjvfj+VWKfL9e8uDwqkQNo0ya5CWi8XiCyekAn4gv3bvnqzjUfgAS6AezyVv/WMQIPtcPT6F/TFuqisYOQWfgH0ygfWtdz9tVrzyOzXC3OhAJUmry1EAatPaoX5uima3/OiR3qX2sdshnSn0sT58024X+68g5meLxJQ6zX3w1UMXvKK3AHt4KaMYNGaA35JpjFiBZqHZeA5/wiiAxKVHrKa+IOMgQucZaz4gKsX53dayHDwh/hy1lpzl54c1frFibtDlzG23+lXK5DmfMxto8dz4UsqRN42LRh6BYaaHmAho+9wrZs0cNKTAdAl9qbLT48MoHTOKB2ZKQtm91leERn1H3NQ/tEybyA9hgdrcQal0woqeaV0SUEyC28AjZ0Bsf8tmMjXHVQs6OATKHZvInboN1uVwaDN2xLDyb9iqpyvBy++LbDsEdbJKcGv6FWWSOBpcScYtyC7K2wvvDzL9Pz3DYPpMiKpVhLqzBH4Eu9NZUCOVq7z5HLVoYu7KApTwO+BI4QrExgA8Zyp0vgmIvsme5j69EuMJsoitmFcNJVY5u0/CiR7bQoJG8rJz4s+ALBjBTo/Z4+O6H20ovkRtHTM77cvdC656SjGYA5ycRk/a2yDdDxW0WcI0IjJGcZMFHei+HHGtHhEcbMgypEHU206Xmt57r8+4yHvA32faTAQrNCz773SceBXxNuSVq
 GXmf4tSm
 YM8ZCSfwaaSgBovHoG6JHSeuxKP/cktOTeGEE9JOlImlxwz82UlJ1/syVFgNKLUwVx/u7XOHIiJ1Oo5WTaKybIeeFIe+/TBOZkWjyY9Q1C8gSPMXrVgau5iLko+m7BNAr/ieH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is also available at:

  https://github.com/AMDESE/linux/tree/gmem-populate-rework-rfc1

and is based on top of kvm-x86/next (kvm-x86-next-2025.11.07)


Overview
--------

Yan previously posted a series[1] that reworked kvm_gmem_populate() to deal
with potential locking issues that might arise once in-place conversion
support[2] is added for guest_memfd. To quote Yan's original summary of the
issues:

  (1)
  In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
  changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
  invalidation lock for protecting its preparedness tracking. Similarly, the
  in-place conversion version of guest_memfd series by Ackerly also requires
  kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
  
  kvm_gmem_get_pfn
      filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
  
  However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
  in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
  filemap invalidation lock.
  
  (2)
  Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
  resulting in the following lock sequence in tdx_vcpu_init_mem_region():
  - filemap invalidation lock --> mm->mmap_lock
  
  However, in future code, the shared filemap invalidation lock will be held
  in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
  - mm->mmap_lock --> filemap invalidation lock
  
  This creates an AB-BA deadlock issue.

Sean has since then addressed (1) with his series[3] that avoids relying on
calling kvm_gmem_get_pfn() within the TDX post-populate callback to re-fetch
the PFN that was passed to it.

This series aims to address (2), which is still outstanding, and does so based
heavily on Sean's suggested approach[4] of hoisting the get_user_pages_fast()
out of the TDX post-populate callback so that it can be called prior to taking
the filemap invalidate lock so that the ABBA deadlock is no longer possible.

It additionally removes 'preparation' tracking from guest_memfd, which would
similarly complicate locking considerations in the context of in-place
conversion (and even moreso in the context of hugepage support). This has
been discussed during both the guest_memfd calls and PUCK calls, and so far
no strong objections have been given, so hopefully that particular change
isn't too controversial.


Some items worth noting/discussing
----------------------------------

(A) Unlike TDX, which has always enforced that the source address used to
    populate the contents of gmem pages via kvm_gmem_populate() is
    page-aligned, SNP explicitly allowed for this. This unfortunately means
    that instead of a simple 1:1 correspondance between source/target pages,
    post-populate callbacks need to be able to handle straddling multiple
    source pages to populate a single target page within guest_memfd, which
    complicates the handling. While the changes to the SNP post-populate
    callback in patch #3 are not horrendous, they certainly are not ideal.
    However, architectures that never allowed a non-page-aligned source
    address can essentially ignore the src_pages/src_offset considerations
    and simply assume/enforce src_offset is 0, and that src_pages[0] is the
    source struct page of relevance for each call.

    That said, it would be possible to have SNP copy unaligned pages into
    an intermediate set of bounce-buffer pages before passing them to some
    variant of kvm_gmem_populate() that skips the GUP and just works directly
    with the kernel-allocated bounce pages, but there is a performance hit
    there, and potentially some additional complexity with the interfaces to
    handle the different flow, so it's not clear if the trade-off is worth
    it.

    Another potential approach would be to take advantage of the fact that
    all *known* VMM implementations of SNP do use page-aligned source
    addresses, so it *may* be justifiable to retroactively enforce this as
    a requirement so that the post-populate callbacks can be simplified
    accordingly.

(B) While one of the aims of this rework is to implement things such that
    a separate source address can still be passed to kvm_gmem_populate()
    even though the gmem pages can be populated in-place from userspace
    beforehand, issues still arise if the source address itself has the
    KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set, e.g. if source/target
    addresses are the same page. One line of reasoning would be to
    conclude that KVM_MEMORY_ATTRIBUTE_PRIVATE implies that it cannot
    be used as the source of a GUP/copy_from_user(), and thus cases like
    source==target are naturally disallowed. Thus userspace has no choice
    but to populate pages in-place *prior* to setting the
    KVM_MEMORY_ATTRIBUTE_PRIVATE attribute (as kvm_gmem_populate()
    requires), and passing in NULL for the source such that the GUP can
    be skipped (otherwise, it will trigger the shared memory fault path,
    which will then SIGBUS because it will see that it is faulting in
    pages for which KVM_MEMORY_ATTRIBUTE_PRIVATE is set).

    While workable, this would at the very least involve documentation
    updates to KVM_TDX_INIT_MEM_REGION/KVM_SEV_SNP_LAUNCH_UPDATE to cover
    these soon-to-be-possible scenarios. Ira posted a patch separately
    that demonstrates how a NULL source could be safely handled within
    the TDX post-populate callback[5].

    
Known issues / TODO
-------------------

- Compile-tested only for the TDX bits (testing/feedback welcome!)


Thanks,

Mike


[1] https://lore.kernel.org/kvm/20250703062641.3247-1-yan.y.zhao@intel.com/
[2] https://lore.kernel.org/kvm/cover.1760731772.git.ackerleytng@google.com/
[3] https://lore.kernel.org/kvm/20251030200951.3402865-1-seanjc@google.com/
[4] https://lore.kernel.org/kvm/aHEwT4X0RcfZzHlt@google.com/
[5] https://lore.kernel.org/kvm/20251105-tdx-init-in-place-v1-1-1196b67d0423@intel.com/


----------------------------------------------------------------
Michael Roth (3):
      KVM: guest_memfd: Remove preparation tracking
      KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      KVM: guest_memfd: GUP source pages prior to populating guest memory

 Documentation/virt/kvm/x86/intel-tdx.rst |  2 +-
 arch/x86/kvm/svm/sev.c                   | 40 +++++++++-----
 arch/x86/kvm/vmx/tdx.c                   | 20 +++----
 include/linux/kvm_host.h                 |  3 +-
 virt/kvm/guest_memfd.c                   | 89 ++++++++++++++++++--------------
 5 files changed, 88 insertions(+), 66 deletions(-)



