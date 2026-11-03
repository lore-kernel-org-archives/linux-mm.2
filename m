Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D805606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=fa9GrIOj
Received: by kanga.kvack.org (Postfix)
	id 0F41A6B05B7; Tue,  3 Nov 2026 11:24:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CBCB6B05B8; Tue,  3 Nov 2026 11:24:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F242F6B05BB; Tue,  3 Nov 2026 11:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC4176B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:24:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60AC91C3C4A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:24:55 +0000 (UTC)
X-FDA: 85394331750.19.0F352BC
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010060.outbound.protection.outlook.com [40.93.198.60])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D595140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:24:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fa9GrIOj;
	spf=pass (imf26.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.93.198.60 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6zyMxWVaLRlrzyt0tmMAewN95mt1HurEOoa5PZ+1XiM=;
	b=xVSDu8/oWOT7wZnn3pvMP0RYkXerm2Ec1HTVxq3cTMt839dr3CBxoEzAhu1ZJq9TDfoGv3
	IZ16SLhnEoLmkjgJyvTBjEQbw1aelTPH5MWLWXMNqLis7kXEhXeiQHXhQT/V7CQGbotcq9
	5KUTlCOTYAWfQnIL1k7bWXy235itpB0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723092;
	b=fYuZACa5eI3vNSPayrza107RrusStkmMRyay7COMwf0M3hDyP1PL63pyAdcCXqv8ZIynjH
	doCcnG7J8vdWpGSBpBFLKmDMfNrLoBmKZkpGWlT8Hy5/TUbIxVmZAfA8neq/EseE6FvDyG
	FgPAQgACceDa1JYqtYVG5PIINpoj3Is=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fa9GrIOj;
	spf=pass (imf26.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.93.198.60 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xypmjGs1kSXMUZDFXKDayybtsseuc3iUrikOJx3ZN8G09pp9nk7Jpv1uQIpiN75Q6TRtfKbg5yQvhhQupWq1fKIG8lfJFPRrhKc3HVKQvVEAS1Urh7RMkIv6GqM/tQ9q/6LBszwaHsVlYk2x0fuxVFXRCPIs08E8qFN5FZibGweXq5qc/4BTYXiXrbqaMSdrG+Af0RUwLggUYK8EN3woULYIwN02CryxYe2DwWoXWMpEq8Sye+xHnxa8JcqpAVAFhdC7i8XTBFzJIIUJJ2twBj4bpHMIB84TAsblg/DmOVvFmM0a7znYB2LaVl92YgJpxTQaYVIR3RI8HGpNyGsinw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zyMxWVaLRlrzyt0tmMAewN95mt1HurEOoa5PZ+1XiM=;
 b=QKDBFM6iVo4YjOmvcaRfS5jM4HvPUNDOD0KOmImCxJJUqCS/fX2idbBdy1GeN2UdyswhhpFbdEGNTCgH7ws2cgGubmxvGVLhA5aEEc9xA3pKdQ4iatSXPQLW0mwBcEnPou7MhjazIAbE4lDVc05CJp/d538B6fKFC0/v7tfk7q+DE3h5YdyGuzHP+7zEnJhjoZm6RT0YAzNeneoOJUnR6z1LXr/DuFYav5oiBtdoqI3GMBUW5+6wFDSVo7/cIsjl32yqQYtklk3cHbihfUW6i6LT036talb7IdSdSyk63s+4kHXAVKFGIZn/cazWshbEFQs8LVQ5yOAgeflQyMIo4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zyMxWVaLRlrzyt0tmMAewN95mt1HurEOoa5PZ+1XiM=;
 b=fa9GrIOjfxkvoyllV35c+8hEPOpOJcfs3i8E9F3yWTdAd8V0+VmiTDB5yTxWe31zbjH2lVg+0LPzEPuC0uOFWkCYJDwx1Ky7mXDz454HAOTWS7hpzSoYTIh5WcejgadPxDfT8GLEbQCWWR+aCLoQEFRl3pP5Ttf+KC/ItJk/fRY=
Received: from CH0P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::6) by
 SA6PR12MB999201.namprd12.prod.outlook.com (2603:10b6:806:450::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:24:49 +0000
Received: from CH1PEPF0005BD5E.namprd02.prod.outlook.com
 (2603:10b6:610:ef:cafe::95) by CH0P220CA0008.outlook.office365.com
 (2603:10b6:610:ef::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:24:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0005BD5E.mail.protection.outlook.com (10.167.244.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:24:48 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:24:46 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:24:46 -0600
Received: from xhdradheys41.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 3 Nov 2026 10:24:41 -0600
From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To: <robh@kernel.org>, <saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <m.szyprowski@samsung.com>, <robin.murphy@arm.com>,
	<baoquan.he@linux.dev>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <iommu@lists.linux.dev>, <kexec@lists.infradead.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 0/4] kexec,mm/cma: do not run the next kernel from a fixed-base CMA area
Date: Tue, 3 Nov 2026 21:54:25 +0530
Message-ID: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.44.4
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5E:EE_|SA6PR12MB999201:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b4ae8e-8581-444c-18c2-08df39c6fb08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|56012099006|10067099003|18002099003|261009223027099003|261022075727099003|921020|261102123227099003|261021123027099003|261021121427099003|261022115727099003|11063799006|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	LuLvjFVnDBrU91Q4OP1QehB+udeusNPB+vvs0j90Avj7BssmtFwsSk44ipPx0vuEzIbSoFEfJzKt0p6DIFQXKuiyIho98OXIX1fwhWzoDRcheUHmaHxwrBWX6R+lNY+zt2YzPCExmbviL5znD4p+PLmTvpI+H2AS7duxJOmHTBs9IXmXmz0BJw+AdsJD+AmRnOTnfI3UYXH/N2Fv5NW3bujojxwdpyuQmrlxxXQshFSudNzIE8Wo6lMR7KV43nusWgNVgEN3+fKflrJP/CXSCyHwykMT/vyB5oBSS+XaGLO1wfzy+PdsNMmrCJAkOuDH77PuK26BNDuAUrErSHAxlL9nG/MVAT/4uiV5RyWNlx2lAFYdQ0aMnLxG1H0U90F/GXsl7p0mLQTPdq8KeDmyaEveHcoAd/v+aP1vMk0XQ9kwlCoXjDrlAleBQsRj2h2yomkGrbpBDTSaMQ/jQwz/FtteeXxNWH7JZgvn/ImhK9ScFGTgHlPK+6UgruXAPWFqa2/dweNkWDTBuIYbK62/3hsuah9A6XNyIkuIeVPQMWRfV/rSmlGnHVlWjVruRZWiLhtrESn4okvFp+0hdYVXn9Kwaqjsdt4PoIMu+9UcJwvW5aUTT7FFd+MHx9yQZzUWYdWR5xzhVWlphCgfGTrkdRbM6Nw4CdsabJl8UrBVYm/9tYvFT0+Jv4c4PtXwYvkQ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(56012099006)(10067099003)(18002099003)(261009223027099003)(261022075727099003)(921020)(261102123227099003)(261021123027099003)(261021121427099003)(261022115727099003)(11063799006)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dNjv3IiiTvWJOExdT+n/aXaOt24uPeJgwW9EHjE7jKsEpmeVAQMMigmVO3akbgxqlZOB9FcA7UyxuzFLLdbpaV8G/qkqMN7IFVop+2uHY8g4467tfR/jKDHJzWwTVo+zdZEUAUYBwJ6HF4c24K6B5B/g8z3o3c8C2rL7fQ8Z5UkoYgj2QPNVcEXemXid2STOIMYcAQz1CluVSYC+Naz8Mn/COk1fPHz0VV/YY3N9jv6ihcPficU8XGbb/IdxQxYUa13gRp8w+d5MqLpmerGZI5tF5pcgu1lPIel2LSaKgGxRWA8yjGv+wVg+H6t0c8rlO/pfQ4yWnH3KPIxCuVU9jbLpRYZwkZazssrLRkcxIzprd4jpv6B+ClVf7RLAej2Z022rPMX1kgU+gFD6fhf6hrtBafhL9xmCnuFTqrHQzsKKvC/G9h3/TmrYo/ei237y
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:24:48.7263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b4ae8e-8581-444c-18c2-08df39c6fb08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR12MB999201
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3o5gboin6kdwehwj9ym6namyahqhwa4o
X-Rspamd-Queue-Id: 4D595140007
X-Rspam-User: 
X-HE-Tag: 1793723092-647675
X-HE-Meta: U2FsdGVkX1945I5BPKM+ysgd5PddbhOuK5F5uhDkjCWnnGwBB4o43s9EnoKRdPcLUZ3xvxZht44fVFxRtlJNq3murxHmEppsA8Z7p4gHnM/z+dZNUY6gg2lEC9oQDjGAFv3GmXChvVgFmOYPN+sSKDsEGpP01EtP72Ys/QOxrH676byOXjxQ6mNZH+hbfC8elBDCWoJkGa4X4lFCgTekykDlbny7Awe8e5PGQ6BKbGC5zxpn2AU5al+HBieFis469BfwrwLuhm77ZWwL1W5ZxWWzUljIzDFiWS/u1Al/VrGO2WQj+mt4oE9wNuull1rjabHPTW/HQPh2ooxRQ1JNa+5mnOb5qfh8sR+GF6bgdC5vPqbcN/yA5LXaJDmteaDIfpo3ePRtuOO8/0lbvDD3sRjOoAmHZuhTZVcNwCJMZycQ9E8Gbt0ZWrmchFNX9G+motMJABNMnsXHtlnKSVCeVAt7VMEFHSU8JF1AS6XbeRvi/Ues5296Xmks9Hp7069gkdUojqfFgqD6H/3HA6bHDf3z6PA1rI0q3gzcJuKFpVky9rNASG//OESa47RhQUiempyAXcBQ3MybtVzLxhePjdzUhTdznmqTQ9ZzTYFc4TZGJtxSwBXaMIM23ffnwlEDPMf5zXVIoFiZPz2kD5LMSTi7qLP+LXQyjrMcJedyA9+2ESJnQroMGNIOVI96M2KenviFgEvGzeKd17D53IQH8Pl1FH1x1CJJfnNqpsVul1+2cpWB0zcjDRud8PwPSv1l0VaPzLmxGJRtSnePISl+3OP2NgMX6ow5/aBCeR566LsWl4jyWRgrcRK+Bc3DHWnO6beGqFuI5cRc2/MfhsEn4/zg508TvkCHCWN/Pn5qzKE2EL3YL2uxL+PgVvUie6nmtAmeNwCI6aRSiIqYcf3H5ZMzCLdEC7IqDchMy05iDwc1O3LMmDIZVZp2NTmjfZq5ICPCBKLcvAw+byfdw6N
 T+pasc0n
 OntR6jfkqhy8cnBMgiU+4clIHpunfCdwVpkc8efYdaLvLnTJReK0Y4O5q2EG6T99ebZ3lpfTnojk41j2VB1uA6S5N1FuwlJPp/j34+Z2DTNUzV7enKglrLKfVrj4nBvu518O/WrY0oJH308WcO2sERYHVEcpZ/V/dtMyceIiwQ7ddRSv2WWfqicxZkVNYQpiGAVjOv5XgJp0VTyBDxyF+dW6THTzL7kml3LwlzY33+kDpn2k9XzZN6f3p8lDqXzgbtVsF8lVa3DOPDWxEbToe0qTGrUpiTP12vz8z0QXBe8a5C1thyUP18dcRKiCw3ZgUoHP9dVQrxjQpxo2PBfDKXTed2xrV2ApLQq7h8zZ+akYo0p9w+/jXceIxFe0+qSkVLd9QrXmzalHUa/SLva6PNZ19Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 07d24902977e ("kexec: enable CMA based contiguous
allocation"), kexec_locate_mem_hole() places the next kernel in the
default CMA area and it runs from there in place. If that area has a
fixed base the loaded kernel declares the range it is executing from
as a shared-dma-pool, and cma_activate_area() frees its own image to
the page allocator. On a VEK385 that corrupts kernel text within
~300ms of /sbin/init starting.

Patch 1 is the fix and stands on its own. Patches 2 and 3 close the
same hole for a device tree placing a shared-dma-pool over the kernel
image with no kexec involved; patch 4 is an unrelated cleanup.

Changes since RFC:
- Patch 1 records CMA_DYNAMIC_BASE rather than CMA_FIXED_BASE.
- New patch 2 answers the RFC's open question (Pratyush): -EBUSY from
  node_init keeps the reservation, so refusing an overlapping pool no
  longer frees [_text, _end) along with it.
- Patch 3 reordered after it, returns -EBUSY, rejects a wrapping
  base+size; both Reviewed-by tags dropped for the rework.
- New patch 4 drops the duplicate alignment check (Mike).

Tested on VEK385: with patch 1 kexec declines all three device-tree
pools; without it the booted kernel refuses the overlapping pool.


Link to RFC: https://lore.kernel.org/all/20261014145731.3431527-1-radhey.shyam.pandey@amd.com

Radhey Shyam Pandey (4):
  kexec: do not place the next kernel in a fixed-address CMA area
  of: reserved_mem: keep the reservation when node_init returns -EBUSY
  mm/cma: reject CMA areas that overlap the kernel image
  mm/cma: drop the duplicate alignment check in rmem_cma_setup()

 drivers/of/of_reserved_mem.c    | 14 +++++++++++
 include/linux/cma.h             | 10 ++++++++
 include/linux/of_reserved_mem.h |  5 ++++
 kernel/dma/contiguous.c         |  5 ----
 kernel/kexec_file.c             | 12 +++++++++
 mm/cma.c                        | 43 ++++++++++++++++++++++++++++++++-
 mm/cma.h                        |  2 ++
 7 files changed, 85 insertions(+), 6 deletions(-)


base-commit: d6bcfc94eb4da6e089c5473970cd96727292fd97
-- 
2.44.4


