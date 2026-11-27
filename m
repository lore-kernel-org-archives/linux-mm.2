Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD5B606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VY1x5/u7
Received: by kanga.kvack.org (Postfix)
	id 333B66B05BA; Fri, 27 Nov 2026 17:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30BDE6B05BB; Fri, 27 Nov 2026 17:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAF16B05BC; Fri, 27 Nov 2026 17:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8BEF6B05BA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:50:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20EDC1404F9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:20 +0000 (UTC)
X-FDA: 85482394200.21.D7A0036
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	by imf31.hostedemail.com (Postfix) with ESMTP id DB02A20005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="VY1x5/u7";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of xinmengs@nvidia.com designates 40.107.208.9 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795819817;
	b=jmOC0SbpD03n27g5KYRm+fDx1uvxu2sbV0Jh8MO74ju2tAETrD991yk/pUvsL6k9Dg4cGy
	1guWeC5YL0h+xH9EIAX1I8EolUcqibD3Vi72oD1Jc0hMnZj1UL3d9pEhNvU2y70182y/yC
	3VYAtKpCjOJGpkIvO4rcBpyhp7+xKmY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHGeFSlB36WEIRUtoibAweZJWaA85GR+UD3NO8KlBFQ=;
	b=oAQ7UOBXkFzSRFoNEbV2m+q9E14h6XqzDIa0xmusVobONcqgYbn0ZH0FXz0Lc6LER1fKmQ
	ky1SyZ3HtlVDwLoXaUhXo1PXNEaf6ZBJ74cPpjpyNmZXymvM7+7HGYhKi4g4O7rg7Dq/+u
	n8guSym987agybvKVP4+N9Lg66IOC4k=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="VY1x5/u7";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of xinmengs@nvidia.com designates 40.107.208.9 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCT4z3SrnhAXwlqGTCpHKO4U5WyqTGpDpJEc19dQLI6hh2jjJcsA/I67Sne6qGTXztpzY7t97xCQgczdpI59Er9XSNsRVIjMlwf4++Ga1E9QQI1xvDaNyiJHTlEO3l/7M8wkVuj/Zw+Ys9YkoDB3VXHnzDjCrNwGPUFgXcIiUAo4U3kEvdpEoSIeGyhIX386ck2kjxD0uhP1aFxkZswAEqSWX5LSQsxvKC/E3VSuPB20LKRdYGuj0h3t00GIXnAnj+5zDi2SKPEzcxaP/LMQCtdfLc9rmccw3GepKecl3OXQtZcFa88rl2206niYbh+xdAJzMD+LuSXG5NmaaLYIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHGeFSlB36WEIRUtoibAweZJWaA85GR+UD3NO8KlBFQ=;
 b=cMBxZAkjHDRkoyWnz7wp/NWr+DI4J60mhcICj1cb7vfmG8oo1HsmjeZo7aR7C5fH3h0E8vxYfW6/3h3lY/Emt+P+Xl++vMxsbhw9e3KgUtsgF/7InZW039JYnwPWyRxtu28H+VOqgYXBGdzkGTRxTMPuwMteAElcXgVsQULHw4wIKyD1Wr8/a7SpAczVAjqP5kFEqkk/tzsa9N3vxfE3RB/S9t+xluBkOwFuPEIheEO3xsCfLGs2qlAwPie7bavAboxIZqLg5rjcFrvlG24qS9RhCgdEB/1msT1dtDq2QsbuJhaI5KEMVuMo5+0qfjZHJBVL3smSYwf7OPo/hF/Wuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHGeFSlB36WEIRUtoibAweZJWaA85GR+UD3NO8KlBFQ=;
 b=VY1x5/u7sWaaDQTjzWMJ9JOU/+PZJadCl96PInhQywGQeORhCoq8hPBfPKoELg46NidhK91h4Ts9irav/WforT0uMJggR4WteamQA2DL7R4yWU/xhvHnAJYug7D7d6AgvMmmiQntJMIi2ZtF6ZlpHp+2Z/+932rLFjd/I9lqVu7SU4q2DylDlntKyPDq/p4lGQtv/+eug8gqTD5IXkjEeEc8POYNxognu6/b+vQVghJYMda999JyjBW+GuCS4z4urLo6RwqnbbPVbomoqIsJfuyP6pHAkSeTzS+5MyVQxo+eKRt6NC0TD3zyEViR0m46gIs3xqc2dvNJFC3JEe335w==
Received: from BN9PR03CA0472.namprd03.prod.outlook.com (2603:10b6:408:139::27)
 by SA3PR12MB7902.namprd12.prod.outlook.com (2603:10b6:806:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 22:50:06 +0000
Received: from BN7PEPF00000092.namprd03.prod.outlook.com
 (2603:10b6:408:139:cafe::ae) by BN9PR03CA0472.outlook.office365.com
 (2603:10b6:408:139::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.10 via Frontend Transport; Fri,
 27 Nov 2026 22:50:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN7PEPF00000092.mail.protection.outlook.com (10.167.245.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 22:50:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 27 Nov
 2026 14:49:59 -0800
Received: from xinmengs-dev-vm-linux.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 27 Nov 2026 14:49:57 -0800
From: Simon Song <xinmengs@nvidia.com>
To: <dakr@kernel.org>, <acourbot@nvidia.com>, <kvm@vger.kernel.org>,
	<rust-for-linux@vger.kernel.org>, <nova-gpu@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
CC: <alex@shazbot.org>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <airlied@gmail.com>,
	<simona@ffwll.ch>, <ojeda@kernel.org>, <alex.gaynor@gmail.com>,
	<boqun.feng@gmail.com>, <gary@garyguo.net>, <bjorn3_gh@protonmail.com>,
	<lossin@kernel.org>, <a.hindborg@kernel.org>, <aliceryhl@google.com>,
	<tmgross@umich.edu>, <jhubbard@nvidia.com>, <ecourtney@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <kjaju@nvidia.com>,
	<alkumar@nvidia.com>, <ankita@nvidia.com>, <aniketa@nvidia.com>,
	<kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <zhiwang@kernel.org>, <zhiw@nvidia.com>,
	<boqun@kernel.org>, <daniel.almeida@collabora.com>, <tamird@kernel.org>,
	<work@onurozkan.dev>, <jgg@ziepe.ca>, <bhelgaas@google.com>,
	<kwilczynski@kernel.org>, <dri-devel@lists.freedesktop.org>,
	<peter@colberg.org>, <xinmengs@nvidia.com>, "Liam R. Howlett"
	<liam@infradead.org>, <linux-mm@kvack.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH v4 5/5] vfio/nova-vgpu: add the Rust VFIO variant driver
Date: Fri, 27 Nov 2026 14:49:17 -0800
Message-ID: <20261127224928.1511382-6-xinmengs@nvidia.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261127224928.1511382-1-xinmengs@nvidia.com>
References: <20261127224928.1511382-1-xinmengs@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF00000092:EE_|SA3PR12MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: dffa396a-d387-46f9-7599-08df4cd8c818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|7416014|1800799024|261102130727099003|261028144727099003|261102123227099003|261022105027099003|261022113327099003|261022075727099003|261021135927099003|261022115727099003|261021121427099003|261021130227099003|261026140227099003|261026130827099003|261021123027099003|261026121527099003|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003|261009223027099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	kWkkSU3W0tVQVfF2v5tlRyOc2Ay7PyHj16GARGEx+xC0z/fUVAgDgsi0WRJT8xy4Sk8dpx125i0Hls2yBwDJXiS5SV8hTVp+oLNydlMa107rjLVloQDH1Vg4jyOGUprnspelAvCDh4f1kQ3yNBNsVeoyWArtvUs6vB9PIkAq81dX/3kqoQE8cf9ThPt49iQ/lpzCmndxwlXjtM+5yq5q8/SpABIUU8Gzo9IoWJRAtlU2tIaiDbyIO5K9Ksy5eovnEp6+h2pXFSGVsHYC9VriFfIS2ZWjhX1CRl/nWfPG1+NRc0M4PcfcifE19EEZ6w2eOFsWDxylGmRyZ7n4fpzagKrms5WS/MOuV/ZUk1XybmaVrWaVyrfL+u6zyxAO17m/RY/TxL0IzexKzb0GDLADHD6sdzo6Aqi+RRhdIX7r82dVGiJpO+dtAM+hkIZZeYYu5p87o+V/EpcBdHiyix+Yak1xN6/2lb3w5aRc4mTqrq8Zong9VjQgApQMSziBqdeBXOc6JPBx88aCIr/m++lxhji9b8D8+LOoFx8Pnh2MadEt8PGyNjxG1AXiUpzshW6skq8i607YUarbIEB/DzQOW8J7nMQheMI6gJCAMaBQt06ll91hq5+2g4pGJeDLqQMCQJ4gvVCbQZARJzmP+YVS6BucO3+dwWgB9M8VWHUufDn3+EvrXi6TtijDd73wJZZ8owkwTr4qpIFNlKn87idjGA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(7416014)(1800799024)(261102130727099003)(261028144727099003)(261102123227099003)(261022105027099003)(261022113327099003)(261022075727099003)(261021135927099003)(261022115727099003)(261021121427099003)(261021130227099003)(261026140227099003)(261026130827099003)(261021123027099003)(261026121527099003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	r1dZGaEFjb4Av0X8YDRmsEL9aqe0f23lp1CqyQiW68G0DDXezlpRwvde2+O1zhj8FtTfmMTnF0vTXAM+dUo+hE+DcGEpbAfm5M1yJ6j6g5LQnO9+ZzaJxuunWLVj1SJ6YK6qenVPLBHmSri5EkvwK4d8U77ce1rraY5BZdMmPBwkWPFJ5/uBSmXuRHgl6b1sepnDw6BnLYj1KXrWuXxJYi5/O97aBQpsuJKGdAEza7SEm6qqAGgX2/MW/5IoVjA7XZQwHpyFlR2tSVwNQ9n12hHs/9a3BU65NsqBPt+R9YfzT9gKJqUNY2gC5ALBvW2icyYiGttEYCaZz5w9I8n0fmqxla9q3ipTdFgf/PiOpuxjhyU0hOYy6wbO4CnfBBfh9zpZJ5RKuK6B1tinrolP0N6TqIhssP7BcUAIJMUCd5cWvIbbPVHj75ir5KY+AZvE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 22:50:06.2241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dffa396a-d387-46f9-7599-08df4cd8c818
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7902
X-Rspam-User:
X-Stat-Signature: xwhecbcobiqpnqcwpikd46wnu3de7ih7
X-Rspamd-Queue-Id: DB02A20005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795819816-595199
X-HE-Meta: U2FsdGVkX18Vw98R3KNwUFpjcQo+KZ/X+nGQ2yCL02Od5VnFBvjUJy4xq5C04/zOfhRixqqokAb2ypTC1Rd/bZayxsaGcXn7HG8mHV9Mpdwq4/0i7rzG9Q6M2Nwvin1giZZKXkIGZVD9EfVcjDFi3ucGwWYOj+jPCf57P8XNVral4PgArhwRw76oi6GgASowFzOQQyBv88IWKDksGPGQTdpbslN2iMnk6A226+pCwETovhExxOVy86SB6039+xpvqTEXbcMC7vAmDmdNRUPDM+UEfD2KRdsxiRO2PDFmjBepI6Vd6GatA6ByvSoix5cKQj1/lwmJsMFMyq7PxbNW3XggR/NhYauhb7uejqoypCsqiT5blADu8iee9Afd+mMX0Zp/dK7R4JrDe5qR1R8na0dkjRpMGkrVLsW1oJwy16UJMaGoeVek2qxEcATbU9JRqxYBKmxw0meEpsdEWIQeAFwdG2L/HL70/neQ5cxLf8ab/FzXF4eO0J57u+0jYdW5b2PcKe105nS9PrvpaGfq/6y2ND2zwVzc0ZNfESgOMJbDpcALLtVIC3Fd7L0cvofHI8SOMNCDImEbbFd+KauPSRnPoSYUQuFgSlCXRZZ+rDCHOVOvKjiWsk4JU+BVEXwdDWD7drI/GynwzF6KD6r58eMOVemQ2t9vJ2NSh7M/YCC7xo5Drfa90udOhoS3U7bhoDA1qQCTXur1CuYctCH2jM1/CppjiCKzoksBBWEYnS3+P4HKWCwstIRTx+hrBbyXyVi/1UkDhjbzYoX1Ec/QDnZGrYR3CnxSHOAqS8ldlOQ59rbdr1k64bbcwhAcWVSxEjYwx//1Wr2ufhtTqHmqgVYBJWhxkiPjm/kAODQp+8Td/+McdMl35t3ifHNL060vpx6PeGE5aHe1ZNHcGHCh55Gt8vaT8B5n38nEhKfI3nIXRHorg6Co1Vbc2AQvE9tiUhqFNUhF1I5JqJL5q7P
 RYw4Iz4k
 /mMsNFXuM8pgxglxI9dCt9tRmVquIYcuje+JOud9wvB4nFxUG/0mvzsUEeHD/ow7+rNq5dlkyDA0xahsgrPe8JGwApsIORi1A9nobX5FRdCwoKE0hb7lrOFuqCKQG1ys6BhTa8saVsc8LDXQml9nt22kDXQKYMbhqxO94JZowVF7y574AAv/DNKSjk7vSUf16aPEfps/M0ckDJJ/h1D2PpKUSGtWsgq602FuARFgSw6RUKAbX0+dEZp80jKyqCtnWRyV+3on8iztnpWoVZkICADvo2Ev5aZNPQE6xFpO5leL5yOCBPI1xacAGEN6PjukqEZykTBpsvxWhR/oZfVvx4mOta7Zix9B1R0b7ibsITxRMO3mcDobM7W1goyVGrLFgdR6TWjLeDDpBr0LRm5df5QknKM/iLtkgRJZWsls60FwFtqNH0gXlLixs9zk+r4QmeKzWAnKHUT6xt1JfTbCx0Q+1XcDPhWZGUb1LYg9S7ftaW0O8M29zDs6QcQZMmoRJTROpfl0R6rURFYusHy9OqGS5UIp8jf3pNJ0vtQccCNs6NmuxoKGo1Ms/HsM+bQ/HAbeHP+RJJfR5cwiYL/51ZxILXYCccppncTwNuibzL1hyeRjTRj9sMVCvQFVio8RBl9AaMjFLZlK9XKvp1r681sTFjz4WtGWnr2V/l3BU9neJBLPFOBKAsSYCf3mwE/hiNPsqJnwoSMqnHkqcPEIvfLHpbr+kojjP8yeecVnafEGJ3rzSYS4dPxZTMBY4zq9atvCk4Xfw0E4PTueZltKC7P9DJt4coHjEOc2NJIPgJvQ1s+EcdEX3zymKlVZfBW0/VPaAmD/z33TqLjgocdHoHghec3b/WfJ5oLVQRchA0NTkAp5ySj7e5DY2FNGgihTAFwUZt+1CG5Be9X6WNnzb8zdTp1wb0mkx2LG066n/fQ6PCSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Danilo Krummrich <dakr@kernel.org>

NVIDIA vGPU VFs need nova-core to manage their instances when assigned
to userspace through VFIO.

Add a Rust VFIO PCI variant driver that uses the typed SR-IOV PF APIs
to create an instance on first open and close it on last close. Expose
the assigned device and subsystem IDs, enforce the assigned BAR1
aperture, and reset the active vGPU instance on PCI reset.

Match the supported NVIDIA devices through VFIO override-only entries.
Devices without an available Nova vGPU interface use ordinary PCI
passthrough.

Register the VFIO device from probe and keep the Registration in the
PCI driver data, so that unbind unregisters it. Extend the GPU build
rules to make nova-core crate metadata available to the VFIO driver and
export the Rust symbols it references.

Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Simon Song <xinmengs@nvidia.com>
---
 drivers/gpu/Makefile                    |  15 +-
 drivers/vfio/pci/Kconfig                |   2 +
 drivers/vfio/pci/Makefile               |   2 +
 drivers/vfio/pci/nova-vgpu/Kconfig      |  20 ++
 drivers/vfio/pci/nova-vgpu/Makefile     |   3 +
 drivers/vfio/pci/nova-vgpu/nova_vgpu.rs | 418 ++++++++++++++++++++++++
 6 files changed, 457 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/nova-vgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nova-vgpu/Makefile
 create mode 100644 drivers/vfio/pci/nova-vgpu/nova_vgpu.rs

diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
index e372fc02139fe..5fd610a172ad1 100644
--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -19,8 +19,9 @@ nova-core-y := nova-core/nova_core.o nova-core/nova_core_exports.o
 obj-$(CONFIG_DRM_NOVA) += nova-drm.o
 nova-drm-y := drm/nova/nova.o
 
-# Export Rust symbols from nova-core only if nova-drm actually references them.
-nova-core-export-deps := $(if $(CONFIG_DRM_NOVA),$(obj)/drm/nova/nova.o)
+# Export Rust symbols from nova-core only if dependent modules reference them.
+nova-core-export-deps := $(if $(CONFIG_DRM_NOVA),$(obj)/drm/nova/nova.o) \
+	$(if $(CONFIG_NOVA_VGPU_VFIO_PCI),$(obj)/../vfio/pci/nova-vgpu/nova_vgpu.o)
 
 rust_needed_exports = \
 	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMBOLS__"; \
@@ -57,10 +58,18 @@ $(obj)/nova-core/nova_core_exports.o: private cmd_gensymtypes_c = \
 		$(obj)/nova-core/nova_core.o
 endif
 
-# Output nova-core's crate metadata for use by nova-drm at compile time.
+# Output nova-core's crate metadata for its Rust consumers at compile time.
 RUSTFLAGS_nova-core/nova_core.o += \
 	--emit=metadata=$(objtree)/$(obj)/nova-core/libnova_core.rmeta
 
 # Allow nova-drm to import nova-core's types.
 $(obj)/drm/nova/nova.o: $(obj)/nova-core/nova_core.o
 RUSTFLAGS_drm/nova/nova.o := -L $(objtree)/$(obj)/nova-core --extern nova_core
+
+# Build the NVIDIA VFIO driver here so metadata and generated exports share
+# the same dependency graph as nova-drm.
+obj-$(CONFIG_NOVA_VGPU_VFIO_PCI) += nova-vgpu-vfio-pci.o
+nova-vgpu-vfio-pci-y := ../vfio/pci/nova-vgpu/nova_vgpu.o
+
+$(obj)/../vfio/pci/nova-vgpu/nova_vgpu.o: $(obj)/nova-core/nova_core.o
+RUSTFLAGS_../vfio/pci/nova-vgpu/nova_vgpu.o := -L $(objtree)/$(obj)/nova-core --extern nova_core
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 296bf01e185ec..dd9b755262a4c 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -74,4 +74,6 @@ source "drivers/vfio/pci/qat/Kconfig"
 
 source "drivers/vfio/pci/xe/Kconfig"
 
+source "drivers/vfio/pci/nova-vgpu/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 6138f1bf241df..1d9fb11eb3c21 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -24,3 +24,5 @@ obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
 obj-$(CONFIG_QAT_VFIO_PCI) += qat/
 
 obj-$(CONFIG_XE_VFIO_PCI) += xe/
+
+# nova-vgpu is built from drivers/gpu/Makefile for nova-core crate linkage.
diff --git a/drivers/vfio/pci/nova-vgpu/Kconfig b/drivers/vfio/pci/nova-vgpu/Kconfig
new file mode 100644
index 0000000000000..29fad96340ce6
--- /dev/null
+++ b/drivers/vfio/pci/nova-vgpu/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NOVA_VGPU_VFIO_PCI
+	tristate "VFIO support for the NVIDIA vGPU"
+	depends on NOVA_CORE && PCI_IOV && RUST
+	depends on VFIO_PCI_CORE=y
+	help
+	  This option enables VFIO (Virtual Function I/O) support for
+	  NVIDIA virtual GPUs (vGPU). It allows the assignment of a virtual
+	  GPU instance to userspace applications via VFIO, typically used
+	  with hypervisors such as KVM and device emulators like QEMU.
+
+	  Devices without an available Nova vGPU interface use ordinary PCI
+	  passthrough. Both paths use the VFIO PCI core defaults; vfio-pci
+	  module options do not apply.
+
+	  The NVIDIA vGPU allows a physical GPU to be partitioned into
+	  multiple virtual GPUs, each of which can be passed to a virtual
+	  machine as a PCI device using the standard VFIO infrastructure.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nova-vgpu/Makefile b/drivers/vfio/pci/nova-vgpu/Makefile
new file mode 100644
index 0000000000000..0875c782602e4
--- /dev/null
+++ b/drivers/vfio/pci/nova-vgpu/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+# nova-vgpu is built from drivers/gpu/Makefile for nova-core crate linkage.
+# nova_vgpu.o (rust-analyzer marker - DO NOT REMOVE).
diff --git a/drivers/vfio/pci/nova-vgpu/nova_vgpu.rs b/drivers/vfio/pci/nova-vgpu/nova_vgpu.rs
new file mode 100644
index 0000000000000..3a7a5a26b49ec
--- /dev/null
+++ b/drivers/vfio/pci/nova-vgpu/nova_vgpu.rs
@@ -0,0 +1,418 @@
+// SPDX-License-Identifier: GPL-2.0
+// SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+//! NVIDIA vGPU VFIO variant driver.
+//!
+//! Nova VFs own an instance between the first VFIO open and last close. Other
+//! matching devices use ordinary PCI passthrough.
+
+use kernel::{
+    bindings,
+    device::{
+        Bound,
+        Core, //
+    },
+    io::resource::Flags,
+    pci,
+    prelude::*,
+    sync::{
+        CondVar,
+        Mutex,
+        MutexGuard, //
+    },
+    vfio::{
+        self,
+        pci::{
+            GetRegionInfo,
+            Ioctl,
+            Mapping,
+            Mmap,
+            Open,
+            Position,
+            Read,
+            Write, //
+        }, //
+    }, //
+};
+use nova_core::{
+    NovaCoreVfApi,
+    NovaCoreVfApiHandle,
+    VgpuInstance, //
+};
+
+struct NovaVgpuOps;
+
+struct VgpuRegistration<'a> {
+    api: NovaCoreVfApiHandle<'a>,
+    gfid: u32,
+}
+
+#[derive(Default)]
+struct InstanceState {
+    active: bool,
+    resetting: bool,
+    reset_error: Option<Error>,
+    fb_bar_reg: u64,
+}
+
+#[pin_data]
+struct NovaVgpuRegData<'a> {
+    pdev: &'a pci::Device<Bound>,
+    vgpu: Option<VgpuRegistration<'a>>,
+    fb_bar: Option<u32>,
+    #[pin]
+    state: Mutex<InstanceState>,
+    #[pin]
+    reset_done: CondVar,
+}
+
+impl NovaVgpuRegData<'_> {
+    fn lock_instance(&self) -> MutexGuard<'_, InstanceState> {
+        let mut state = self.state.lock();
+        while state.resetting {
+            self.reset_done.wait(&mut state);
+        }
+        state
+    }
+}
+
+struct NovaVgpuOpenData<'a, 'reg> {
+    registration: &'a NovaVgpuRegData<'reg>,
+    instance: Option<VgpuInstance<'reg>>,
+}
+
+impl<'a, 'reg> NovaVgpuOpenData<'a, 'reg> {
+    fn new(
+        dev: &vfio::pci::Device<NovaVgpuOps, Open>,
+        rd: &'a NovaVgpuRegData<'reg>,
+    ) -> Result<Self> {
+        let mut state = rd.lock_instance();
+        let instance = match &rd.vgpu {
+            Some(vgpu) => {
+                // The firmware DBDF format has a 16-bit PCI segment field.
+                let segment = u16::try_from(rd.pdev.domain_nr()).map_err(|_| EOVERFLOW)?;
+                let dbdf = (u32::from(segment) << 16) | u32::from(rd.pdev.dev_id());
+                let vm_pid = kernel::current!().tgid().try_into()?;
+                let instance = vgpu.api.open(vgpu.gfid, dbdf, vm_pid)?;
+                let info = instance.type_info();
+                dev.set_device_id(info.pci_dev_id as u16);
+                state.active = true;
+                state.reset_error = None;
+                state.fb_bar_reg = 0;
+                Some(instance)
+            }
+            None => None,
+        };
+        Ok(Self {
+            registration: rd,
+            instance,
+        })
+    }
+
+    fn bar1_size(&self) -> Result<Option<u64>> {
+        let (Some(instance), Some(fb_bar)) = (&self.instance, self.registration.fb_bar) else {
+            return Ok(None);
+        };
+        let physical = self.registration.pdev.resource_len(fb_bar)?;
+        let size = instance
+            .type_info()
+            .bar1_length
+            .checked_mul(1 << 20)
+            .ok_or(EOVERFLOW)?;
+        if size != 0 && !size.is_power_of_two() {
+            return Err(EINVAL);
+        }
+        Ok(Some(size.min(physical)))
+    }
+
+    fn limit_bar1(&self, buf: &mut vfio::UserBuf, position: &Position<'_>) -> Result {
+        if buf.is_empty() || Some(position.region_index()) != self.registration.fb_bar {
+            return Ok(());
+        }
+        if let Some(size) = self.bar1_size()? {
+            let offset = position.region_offset();
+            if offset >= size {
+                return Err(EINVAL);
+            }
+            if size - offset < buf.len() as u64 {
+                buf.truncate((size - offset) as usize);
+            }
+        }
+        Ok(())
+    }
+}
+
+impl Drop for NovaVgpuOpenData<'_, '_> {
+    fn drop(&mut self) {
+        let mut state = self.registration.lock_instance();
+        state.active = false;
+        drop(self.instance.take());
+    }
+}
+
+impl vfio::Operations for NovaVgpuOps {
+    type RegistrationData<'reg> = NovaVgpuRegData<'reg>;
+    type OpenData<'open, 'reg: 'open> = NovaVgpuOpenData<'open, 'reg>;
+}
+
+#[vtable]
+impl vfio::pci::Operations for NovaVgpuOps {
+    const NAME: &'static CStr = c"nova-vgpu-vfio-pci";
+
+    fn open_device<'a, 'reg: 'a>(
+        dev: &'a vfio::pci::Device<Self, Open>,
+        rd: &'a NovaVgpuRegData<'reg>,
+    ) -> impl PinInit<Self::OpenData<'a, 'reg>, Error> + 'a {
+        NovaVgpuOpenData::new(dev, rd)
+    }
+
+    fn ioctl<'reg>(
+        dev: &vfio::pci::Device<Self, Ioctl>,
+        rd: &NovaVgpuRegData<'reg>,
+        _open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        cmd: u32,
+        arg: usize,
+    ) -> Result<isize> {
+        let result = dev.core_ioctl(cmd, arg)?;
+        if cmd == vfio::DEVICE_RESET {
+            if let Some(error) = rd.state.lock().reset_error {
+                return Err(error);
+            }
+        }
+        Ok(result)
+    }
+
+    fn read<'reg>(
+        dev: &vfio::pci::Device<Self, Read>,
+        rd: &NovaVgpuRegData<'reg>,
+        open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        buf: &mut vfio::UserBuf,
+        position: &mut Position<'_>,
+    ) -> Result<isize> {
+        if let Some(instance) = &open_data.instance {
+            if position.region_index() == vfio::pci::CONFIG_REGION_INDEX {
+                let offset = position.region_offset();
+                return position.with_temporary(|next| {
+                    let count = dev.core_read(buf, next)?;
+                    // A VF has no device ID of its own, so the core keeps it in vconfig, where
+                    // it is set once at open. The core reads the subsystem ID from the hardware,
+                    // as a firmware update can change it there, so replace it on every read.
+                    buf.write_overlapping(
+                        offset,
+                        count.try_into()?,
+                        u64::from(bindings::PCI_SUBSYSTEM_ID),
+                        &(instance.type_info().pci_subsys_id as u16).to_le_bytes(),
+                    )?;
+                    if let (Some(size), Some(fb_bar)) = (open_data.bar1_size()?, rd.fb_bar) {
+                        let reg = rd.state.lock().fb_bar_reg & !size.wrapping_sub(1);
+                        // Byte 0 holds only the flag bits, which the core has filled in.
+                        buf.write_overlapping(
+                            offset,
+                            count.try_into()?,
+                            u64::from(bindings::PCI_BASE_ADDRESS_0) + 4 * u64::from(fb_bar) + 1,
+                            &reg.to_le_bytes()[1..],
+                        )?;
+                    }
+                    Ok(count)
+                });
+            }
+        }
+        open_data.limit_bar1(buf, position)?;
+        dev.core_read(buf, position)
+    }
+
+    fn write<'reg>(
+        dev: &vfio::pci::Device<Self, Write>,
+        rd: &NovaVgpuRegData<'reg>,
+        open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        buf: &mut vfio::UserBuf,
+        position: &mut Position<'_>,
+    ) -> Result<isize> {
+        if let Some(fb_bar) = rd.fb_bar {
+            if position.region_index() == vfio::pci::CONFIG_REGION_INDEX {
+                let mut written = [0; 8];
+                let range = buf.read_overlapping(
+                    position.region_offset(),
+                    u64::from(bindings::PCI_BASE_ADDRESS_0) + 4 * u64::from(fb_bar),
+                    &mut written,
+                )?;
+                if !range.is_empty() {
+                    let mut state = rd.state.lock();
+                    let mut reg = state.fb_bar_reg.to_le_bytes();
+                    reg[range.clone()].copy_from_slice(&written[range]);
+                    state.fb_bar_reg = u64::from_le_bytes(reg);
+                }
+            }
+        }
+        open_data.limit_bar1(buf, position)?;
+        dev.core_write(buf, position)
+    }
+
+    fn mmap<'reg>(
+        dev: &vfio::pci::Device<Self, Mmap>,
+        rd: &NovaVgpuRegData<'reg>,
+        open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        mapping: &mut Mapping<'_>,
+    ) -> Result {
+        if Some(mapping.region_index()) == rd.fb_bar {
+            if let Some(size) = open_data.bar1_size()? {
+                if mapping.region_end()? > size {
+                    return Err(EINVAL);
+                }
+            }
+        }
+        dev.core_mmap(mapping)
+    }
+
+    fn get_region_info<'reg>(
+        dev: &vfio::pci::Device<Self, GetRegionInfo>,
+        rd: &NovaVgpuRegData<'reg>,
+        open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        info: &mut bindings::vfio_region_info,
+        caps: &mut vfio::InfoCap<'_>,
+    ) -> Result {
+        dev.core_get_region_info(info, caps)?;
+        if Some(info.index) == rd.fb_bar && info.size != 0 {
+            if let Some(size) = open_data.bar1_size()? {
+                info.size = info.size.min(size);
+            }
+        }
+        Ok(())
+    }
+
+    fn dmabuf_len<'reg>(
+        rd: &NovaVgpuRegData<'reg>,
+        open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        region_index: u32,
+    ) -> Result<Option<u64>> {
+        if Some(region_index) == rd.fb_bar {
+            return open_data.bar1_size();
+        }
+        Ok(None)
+    }
+
+    fn reset_prepare(rd: &NovaVgpuRegData<'_>) {
+        // PCI holds the device lock, and VFIO may hold its memory lock. Open and
+        // close release this mutex before entering the VFIO core.
+        let mut state = rd.state.lock();
+        state.resetting = true;
+        state.reset_error = None;
+    }
+
+    fn reset_done(rd: &NovaVgpuRegData<'_>) -> Result {
+        let mut state = rd.state.lock();
+        // A VF FLR leaves the vGPU plugin's software state intact.
+        if state.active {
+            if let Some(vgpu) = &rd.vgpu {
+                state.reset_error = vgpu.api.reset(vgpu.gfid).err();
+            }
+        }
+        let error = state.reset_error;
+        state.resetting = false;
+        rd.reset_done.notify_all();
+        error.map_or(Ok(()), Err)
+    }
+}
+
+struct NovaVgpuDriver;
+
+kernel::pci_device_table!(
+    PCI_TABLE,
+    <NovaVgpuDriver as pci::Driver>::IdInfo,
+    [
+        (
+            pci::DeviceId::from_id_vfio_override(pci::Vendor::NVIDIA, 0x2bb3),
+            (),
+        ),
+        (
+            pci::DeviceId::from_id_vfio_override(pci::Vendor::NVIDIA, 0x2bb5),
+            (),
+        ),
+    ]
+);
+
+#[pin_data]
+struct NovaVgpuData<'bound> {
+    reg: vfio::pci::Registration<'bound, NovaVgpuOps>,
+}
+
+#[vtable]
+impl pci::Driver for NovaVgpuDriver {
+    type IdInfo = ();
+    type Data<'bound> = NovaVgpuData<'bound>;
+    const ID_TABLE: pci::IdTable<Self::IdInfo> = &PCI_TABLE;
+    // SAFETY: VFIO hands the DMA ownership of the device to userspace. This driver never uses
+    // the kernel DMA API for its devices, directly or through helpers.
+    const DRIVER_MANAGED_DMA: Option<pci::DriverManagedDma<Self>> =
+        Some(unsafe { pci::DriverManagedDma::new() });
+
+    fn probe<'bound>(
+        pdev: &'bound pci::Device<Core<'_>>,
+        _info: Option<&'bound Self::IdInfo>,
+    ) -> impl PinInit<Self::Data<'bound>, Error> + 'bound {
+        try_pin_init!(NovaVgpuData {
+            reg: {
+                let vgpu = match NovaCoreVfApi::handle(pdev) {
+                    Ok(api) => Some(VgpuRegistration {
+                        api,
+                        gfid: u32::from(pdev.vf_id()?) + 1,
+                    }),
+                    Err(_) => None,
+                };
+                let dev = vfio::pci::Device::<NovaVgpuOps>::new(pdev)?;
+                let fb_bar = if vgpu.is_none() {
+                    None
+                } else if pdev.resource_flags(0)?.contains(Flags::IORESOURCE_MEM_64) {
+                    Some(2)
+                } else {
+                    Some(1)
+                };
+                // SAFETY: The registration is stored in `NovaVgpuData`, this driver's bus
+                // device private data, which is never leaked.
+                unsafe {
+                    vfio::pci::Registration::new::<Self>(
+                        pdev,
+                        &dev,
+                        try_pin_init!(NovaVgpuRegData {
+                            pdev,
+                            vgpu,
+                            fb_bar,
+                            state <- kernel::new_mutex!(InstanceState::default()),
+                            reset_done <- kernel::new_condvar!(),
+                        }),
+                    )?
+                }
+            },
+        })
+    }
+
+    fn reset_prepare<'bound>(_pdev: &pci::Device<Core<'_>>, data: Pin<&Self::Data<'bound>>) {
+        data.reg.reset_prepare();
+    }
+
+    fn reset_done<'bound>(pdev: &pci::Device<Core<'_>>, data: Pin<&Self::Data<'bound>>) {
+        if let Err(error) = data.reg.reset_done() {
+            dev_err!(pdev, "VFIO device reset failed: {:?}\n", error);
+        }
+    }
+
+    fn error_detected<'bound>(
+        _pdev: &pci::Device<Core<'_>>,
+        data: Pin<&Self::Data<'bound>>,
+        _state: pci::ChannelState,
+    ) -> pci::ErsResult {
+        data.reg.error_detected()
+    }
+}
+
+kernel::module_pci_driver! {
+    type: NovaVgpuDriver,
+    name: "nova-vgpu-vfio-pci",
+    authors: [
+        "Danilo Krummrich <dakr@kernel.org>",
+        "Zhi Wang <zhiw@nvidia.com>",
+        "Simon Song <xinmengs@nvidia.com>",
+    ],
+    description: "NVIDIA vGPU VFIO variant driver",
+    license: "GPL v2",
+}
-- 
2.43.7


