Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3EA606A683
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r/SUKHu8
Received: by kanga.kvack.org (Postfix)
	id 752A86B05B3; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7299E6B05B4; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618856B05B6; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 286B86B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54FAA404F3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:11 +0000 (UTC)
X-FDA: 85482393822.04.EA7A931
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012021.outbound.protection.outlook.com [52.101.53.21])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0A8CE1C0007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="r/SUKHu8";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of xinmengs@nvidia.com designates 52.101.53.21 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795819808;
	b=hdk1hGWTR53ZF5ROXJEToDFgzrRcrvIE+C/K8JFobppt2crnX3/8uiy62tusKbGnq8e3p5
	/Kg54RDX47ViRUeYmnsIuLTKV9nDMTDhxroc5XjvoxkeG5aIxUjpdGgGEaOmd9QHmr3dQL
	uttag5EY6Lv/8g4bI+KoJKO58WxJAJ0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwxdfYMjHbt2sfnUZXPbSOmjL8jGXQHf55Cx0O3yXCI=;
	b=6uAYYS5xhapQMVItvB/u8Qx4RvlA/LqgNd4o/4Ifo7ZNb/MBV7SaulqWs1j0p9XljD5ldT
	anNNx94PTlq+6b9WbnMPAFooH65U0N7IXKn+JVU+8GNEbjvX1xrrnw54qJRPrO5vfipbJc
	1a6WTqvOtLJYwk2byikhNSRoImC3U7Q=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="r/SUKHu8";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of xinmengs@nvidia.com designates 52.101.53.21 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PQmOWUs7t5+dwo2A346MkBLc8j0n27ueuvmh7qvurXvHbtyUdsW9upl3PTw34CTeOiuGs/tXCvRQxxUSMsq1d/jpXhQpQwnYC2/1FWGNwU0XMn6nw+X43WsMAnlDO0CNliVqRGHef5xV5jtkalWLyxouXqDYOj3q2erNfJN1dBTFGYH3tWxdPAOlibFv5xYnFStigV6b9KC7udOFmJY84zLyp24Ingq3aUtAAruuyVUXu9JgOOPnmWOGGb1ykOrCQLgMs1evqWhXvwKe9GPoaJZDk/YiFtavimlFC710FnskV3PbmHMr0GGELrQEOTV5mS8Ylm3mhsYBS6Iyj11VlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwxdfYMjHbt2sfnUZXPbSOmjL8jGXQHf55Cx0O3yXCI=;
 b=ErAhjqo8ShWJCtroFXKGN7yxu4vMYQJOUit+CoKjvJ9OUobdGSKqAljtLrgM6tx5nxLafNtM6cZmEv6RS2EELTALSe2G4+MWVDm5xg/fn6YBhY6hieylajBzpGIABKIwA6KvzqyTQY0KvGo+/UxWYil0cuhmF04Y0habJgPlgPKiXr80+6P0UO0FQoQxRfRGKnCaGK2toE8inll6M1lRBy/ry4RL/upo0ZLJ9XhRuak6sO6XtfnzZkPmtDawu9w3Zy9G+sqj+ZTONtzYCF3f8BEDChlZ0rmXeDXHqCUkfYb8nQEAF3UizXdDs9436S3GqRtRdR/Mk/QyHiuq1aWW1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwxdfYMjHbt2sfnUZXPbSOmjL8jGXQHf55Cx0O3yXCI=;
 b=r/SUKHu8s5G+tZ/lYjlp4VyJVDzBtnKbhBgzvoE+IUHlyQSTFbEudpidXaTtQ0Fz+AesxhcNtl63KUf0b7Gu3uRkqgc20y1dPXE4MD6E8uOmZWB/J5x73/Hr1U7nZxl8a+uShz25N3GM12UhoPbukClNRKhP7++T0rv3UmN8lrMCeudD7fI/0zBBJCvOEQGdR0eWDk7lfZpF3gHn+1XKjX/x43ziXTIQjrAJ9Z4krYVp16yXg22EmnVosp0jifmGiMJCYwdmrYR95h9XRMfG0wqTr3AMjm0DJof8cEil8V3Unqh67UUZBUuwAGLl2WpySGJHkgZqBkpn5FnDpiwtqA==
Received: from BN9PR03CA0477.namprd03.prod.outlook.com (2603:10b6:408:139::32)
 by CY8PR12MB7267.namprd12.prod.outlook.com (2603:10b6:930:55::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 22:50:00 +0000
Received: from BN7PEPF00000092.namprd03.prod.outlook.com
 (2603:10b6:408:139:cafe::5c) by BN9PR03CA0477.outlook.office365.com
 (2603:10b6:408:139::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Fri,
 27 Nov 2026 22:50:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN7PEPF00000092.mail.protection.outlook.com (10.167.245.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 22:50:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 27 Nov
 2026 14:49:52 -0800
Received: from xinmengs-dev-vm-linux.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 27 Nov 2026 14:49:49 -0800
From: Simon Song <xinmengs@nvidia.com>
To: <dakr@kernel.org>, <acourbot@nvidia.com>, <kvm@vger.kernel.org>,
	<rust-for-linux@vger.kernel.org>, <nova-gpu@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
CC: Zhi Wang <zhiw@nvidia.com>, <alex@shazbot.org>, <jgg@nvidia.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<airlied@gmail.com>, <simona@ffwll.ch>, <ojeda@kernel.org>,
	<alex.gaynor@gmail.com>, <boqun.feng@gmail.com>, <gary@garyguo.net>,
	<bjorn3_gh@protonmail.com>, <lossin@kernel.org>, <a.hindborg@kernel.org>,
	<aliceryhl@google.com>, <tmgross@umich.edu>, <jhubbard@nvidia.com>,
	<ecourtney@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<kjaju@nvidia.com>, <alkumar@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <zhiwang@kernel.org>, <boqun@kernel.org>,
	<daniel.almeida@collabora.com>, <tamird@kernel.org>, <work@onurozkan.dev>,
	<jgg@ziepe.ca>, <bhelgaas@google.com>, <kwilczynski@kernel.org>,
	<dri-devel@lists.freedesktop.org>, <peter@colberg.org>,
	<xinmengs@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
	<linux-mm@kvack.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH v4 1/5] rust: vfio: add common VFIO device handling
Date: Fri, 27 Nov 2026 14:49:13 -0800
Message-ID: <20261127224928.1511382-2-xinmengs@nvidia.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261127224928.1511382-1-xinmengs@nvidia.com>
References: <20261127224928.1511382-1-xinmengs@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF00000092:EE_|CY8PR12MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 454cc026-ce0e-4198-efb2-08df4cd8c4a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|376014|1800799024|23010399003|82310400026|10067099003|5023799004|56012099006|11063799006|261026121527099003|261028144727099003|261021121427099003|261009223027099003|261022105027099003|261022075727099003|261026140227099003|261102123227099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	tdxnoCOeoQmsHfATdOcQEvnvjxh/A+FuJhmfBPkEUWxHa6gNOt3CzAaaMdxVeyfJF8qVpm/fAOtSbUD7ZUBLYD9HO2748oSN0IfV6CURXXp6+xL95IJrnarzbbPujHQgd6vZo8QXwchHhxQfFWQDY4z/WjUZxUVcVo9y7fvP55zo3l/lk3mUXcvdIQYVblek9CAW/Dh9qWZubcIFHQnzLLjcsUKlvdeIWvGDwzC89cfv4XbCK71RS2RM0OJ7bs2mrTweFWHtPymUCoqf5a3yilXvhGBoNsBkqwMXwZnyH6NT+u2TOHnMfwXooblBxuiU9Fw4TxBxTtmmOViqVYjrjrUY2rX/drjvOSIbdysE76Yc6c3qFRx93rGsIVY0Oz7U1tphmobzzKB5OVgb2YE+fUNIZZGJaL+VWsqpDRjF7RCRHGQs01v75Dp5IQQ87cTazrXOB7REHUEEfh+Z3nHRm3+iSHcGN67q30TrQC6lAgfmteD0brzT6I1HUq/6s6dLby3K3LxAmUmEbLXH26qUgZ9oe0ifRp9lc9fbWwMU4VMxu4P9r+ElWuNGST1ULfmO5NY/ibG64ajoVLU2ovi2fG8CV1fUoXfPce4R79hx/0pnBB1ZMHamXnt+2qB5meJd7tbtDFTDvW/lyFZMRgXoaFjsP/i1l7BwVkJzpQRHxEkHOgfkOOUcsAMyDMYiZi3sdedvpC1jioeZkoOf4Ovjdg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(376014)(1800799024)(23010399003)(82310400026)(10067099003)(5023799004)(56012099006)(11063799006)(261026121527099003)(261028144727099003)(261021121427099003)(261009223027099003)(261022105027099003)(261022075727099003)(261026140227099003)(261102123227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6I18DN+XHQ92Lpbp3csua05K+I1BAa3ZT7tgbC4OnJFaAb5KogWECKVf98byuscSE4it4evjlrIbdceHyT+yWsVlXX4vNrbnoOsW42rWba20IWqdekTMQmM7bTRMwJqI13cBtobUZ3z+8ZOGfp1MqSBhZn9q2h0hlYg+HYmeZwDUuzqHytOBfPUKwRrBJX6hy36Wvxr1TDDq/bbu78U5GZXhOSQK54hBtskua41zp4/ewcsPmEjDZPw+S1JuMuCAzXcldWykASmsaNTRovM0/mraI9ZI9n9bVNqg9Xara85Vm8mNr10KBsOu2T+hQ+GsibrPsBx2wU/1fMFKG6hZoecV3VMWtb/bSyvLB4Fr8dX7aa7trT+3WyLM6BR083eH1N8oa7mjYqxmWx1uHcqmrc63A2uyc424lsHf3W/00oBAqD4iMkWA0BH9rbUXBrbo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 22:50:00.4390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 454cc026-ce0e-4198-efb2-08df4cd8c4a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7267
X-Rspamd-Queue-Id: 0A8CE1C0007
X-Stat-Signature: jknqx65azy6mxxyijzczn96ipd6r9ggr
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795819807-148832
X-HE-Meta: U2FsdGVkX189YdhMTyZ1rvu2KdOzBDBtQWZVgiJchzQEdYzXDkJxKfA1yPUjjc8lS0N52MiTb/P1NQgjphJswPxwszQuO7r+1N7FTpySstuk3efCOsCnxrIVFbSRG3f9/VU1fdIAHdCjfK52QwKQgGUB5X8fZi/C+DkdVcNrWUSCik/RoIzZ7+qsSNcleeDg5UFhhYH8LftlA0+jxxK8FsRRuCsI4nHgFhLrZ9SmgxABzsoqVyyvFvkHDJFZIu7FoJu3Evfjo5vZd+iJz4J3XLjidJpbQfOr+nbF/d1EcD/U+DV0/nfDSGDigBGTtIwOHPnGmxkNACotKofVA3DL+x5UV1l0Lf8L2qRO/Ej2z/tThDCzg2K6kbn2ISlr+/+HA3JnvMVUcdDYIjUmGNZqihENmMlVCM4O+Bb9Q7cQOIak3BUmYBTVOr4PXV4VuxMbuGOouDe2bzdxZ7xXyGobAuHfZlMuELbDtLioqLF8+HWvzdANigqDnJ9/4vR5RQgrRIiENvm2x4hhVsDmHv5zJL8+oCh7fqz3BTtnxhO6vT3nv4wSltpw7anmFC1x7xBn3Ga7ZtFSw+NciLDnbbB98y3hUJc2RdghjGx3U3m3TrIeGBoSk60/VUlPFaCL6ZsJpWOHp8BGkQkCx4WXzTX7Jx+Wp531Eag4bSs5Aoc7L2kCE4c4oPHYei8c6NSX+GIhuKluMBxI0Z0Yz9MpA2hOuQ34sYYdFEnUY6aXbQFtmbzlXRREtna4hxCxwFjTR+0BBBs/a5BCWr6q3xnzy3zhQ9z79v2MLk8cVhn+l7bcCQZsHbC5ms9Igspi8w1U0gCYIRKfj5kVcgE+k8VCn3wZ5ibRkp55D2NF6y8ML8tfRR9b/ecJPv/5eEjvGCuclsBIn0kHD+uAV1gRopjkubiYuXCbRxo66zqZjwUDU0LTgqfHU7kcy3myOfXRR/yxiXVcWlLM81dD+plft47Dfvi
 /HnO4E3c
 a+BL4sNk5DUq/c+fy0n4m0ckyzrn2PDuL+c5/ZVgvJZxGq8fCUsjNmHGsc+hfSzGB/Sr/aAZK6YxPdbZXk09qUICKNDi+W4p8gZlx0M96baJSYYfdaZR24bquBd9joH2pEAdTFsHK0ivTRfd/QJhJby5xwxmsCT7IELESvsV1ci2lMJaNZjBVmZIdU8WsexcKBW78jcoRQt7/1NIkxDaNb+iAU/c2D84tGwarJi8ernNnR6XvgrGZbAaqR/3sj9RmA7vC+47fXhStvXF/5NQoERcKRWxBUd777FO+0+T5uw2SLIhigBAuEvITNhEdDIJOXUo5ei2bR3HwRotvCIQ6ckTMYkSuAlolw5A4MzFkKZcbKI1bROlJWrzHEw8/WHrWX7hQft9zS4xQRxMaTpMICJKqtooXMAhu2xL0wGuaOe4xl7Tnf6nv7oimm2vdrsOU8GOttd54VwGFWMeQvTPAZNOVI5GLbR4ITP4F3niD16hKbfEQKBQ2xshsNlwj3ocDe5xYkO+DCMQLBXcgQCWrXnQnXCEQeRZayWrgrVqbou6evJX/f1sOoa9ihzRKTlHnBqyvaMYIbp9QHZZ36T7j6xBR9NFe2bkNuioBhr5v+tKn7ylgI/wcf8luccsps1D+7TCZMZjUAa8GyvIfWiX4SJv/cTmkfoZjFqhFt0Ao84jXA/7gexw85ux70fz7sHQtAga6k99Tk8X0GPI5tiJNkOd5ifBjkOVe3MUSliVUKIsqTTjHv5aU+oN+pmyPQar8/SXpc1s/be+3QlNRyDIh1HzHk1R9R5++8Vecoyxwbw9OMmGlFC0yoYNHaCMnm+a5M1isHijaXnwfccK5gi+hPLd0K2tFaIRfUcKWE6KcpTd+cXGAKfjB2H1vDh0e+jTtKlCUxXc8uwJh7MgeBPdfuAjdSiTiR5V0JpRb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhi Wang <zhiw@nvidia.com>

A VFIO PCI device contains a VFIO device. Expose that relationship in
Rust so common device handling is independent of PCI resources.

Add vfio::DeviceBase, a C VFIO device structure followed by pointers to
callback data, and vfio::Device, its alias for struct vfio_device. The
data is registration data and data kept from the first successful open
until the last close, which can borrow the former. Share reference
counting and callback-data lifetime handling in vfio.

The helpers are unused until the next patch adds the PCI abstraction.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Simon Song <xinmengs@nvidia.com>
---
 rust/bindings/bindings_helper.h |   2 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/vfio.rs             | 454 ++++++++++++++++++++++++++++++++
 3 files changed, 458 insertions(+)
 create mode 100644 rust/kernel/vfio.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 3791af0aadc73..a5781bc1ea85f 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -93,6 +93,7 @@
 #include <linux/task_work.h>
 #include <linux/tracepoint.h>
 #include <linux/usb.h>
+#include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
@@ -115,6 +116,7 @@
 const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
 const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN = ARCH_KMALLOC_MINALIGN;
 const size_t RUST_CONST_HELPER_PAGE_SIZE = PAGE_SIZE;
+const unsigned int RUST_CONST_HELPER_VFIO_DEVICE_RESET = VFIO_DEVICE_RESET;
 const size_t RUST_CONST_HELPER_GENLMSG_DEFAULT_SIZE = GENLMSG_DEFAULT_SIZE;
 const gfp_t RUST_CONST_HELPER_GFP_ATOMIC = GFP_ATOMIC;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL = GFP_KERNEL;
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index f7f720b9888a4..9f7789ce0db43 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -150,6 +150,8 @@
 pub mod uaccess;
 #[cfg(CONFIG_USB = "y")]
 pub mod usb;
+#[cfg(CONFIG_VFIO = "y")]
+pub mod vfio;
 pub mod workqueue;
 pub mod xarray;
 
diff --git a/rust/kernel/vfio.rs b/rust/kernel/vfio.rs
new file mode 100644
index 0000000000000..f49ff5931df56
--- /dev/null
+++ b/rust/kernel/vfio.rs
@@ -0,0 +1,454 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Virtual Function I/O (VFIO) devices and callback data.
+//!
+//! `DeviceBase` combines a C VFIO device structure with the data its callbacks use.
+//! [`Device`] is an alias of it for `struct vfio_device`.
+//!
+//! C header: [`include/linux/vfio.h`](srctree/include/linux/vfio.h)
+
+use crate::{
+    bindings,
+    prelude::*,
+    sync::aref::AlwaysRefCounted,
+    types::{
+        ForeignOwnable,
+        NotThreadSafe,
+        Opaque, //
+    },
+    uaccess::{
+        UserPtr,
+        UserSlice, //
+    }, //
+};
+use core::{
+    cell::UnsafeCell,
+    marker::PhantomData,
+    ops::Range,
+    ptr::NonNull, //
+};
+
+/// Reset the VFIO device.
+pub const DEVICE_RESET: u32 = bindings::VFIO_DEVICE_RESET;
+
+/// The context in which a VFIO device reference is valid.
+///
+/// Callback views can only be borrowed from the corresponding VFIO trampoline.
+/// They cannot be refcounted or shared across threads.
+pub trait DeviceContext: private::Sealed {}
+
+/// A callback context in which VFIO keeps the device open.
+///
+/// Registration data and open data are available throughout such a callback.
+pub trait IoContext: DeviceContext {}
+
+/// An ordinary device reference, without callback-specific operations.
+pub struct Normal;
+
+/// The device is undergoing its exclusive first-open callback.
+pub struct Open;
+
+/// The device is borrowed for a VFIO ioctl callback on the current thread.
+pub struct Ioctl;
+
+/// The device is borrowed for a VFIO read callback on the current thread.
+pub struct Read;
+
+/// The device is borrowed for a VFIO write callback on the current thread.
+pub struct Write;
+
+/// The device is borrowed for a VFIO mmap callback on the current thread.
+pub struct Mmap;
+
+/// The device is borrowed for a VFIO region-info callback on the current thread.
+pub struct GetRegionInfo;
+
+mod private {
+    pub trait Sealed {}
+
+    impl Sealed for super::Normal {}
+    impl Sealed for super::Open {}
+    impl Sealed for super::Write {}
+    impl Sealed for super::Mmap {}
+    impl Sealed for super::Ioctl {}
+    impl Sealed for super::Read {}
+    impl Sealed for super::GetRegionInfo {}
+}
+
+impl DeviceContext for Normal {}
+impl DeviceContext for Open {}
+impl DeviceContext for Write {}
+impl DeviceContext for Mmap {}
+impl DeviceContext for Ioctl {}
+impl DeviceContext for Read {}
+impl DeviceContext for GetRegionInfo {}
+
+impl IoContext for Write {}
+impl IoContext for Mmap {}
+impl IoContext for Ioctl {}
+impl IoContext for Read {}
+impl IoContext for GetRegionInfo {}
+
+/// The data the driver of a [`Device`] shares with its callbacks.
+///
+/// Bus-specific operations traits extend this trait.
+pub trait Operations: Sized + Send + Sync + 'static {
+    /// Data owned by the registration and passed to VFIO callbacks.
+    ///
+    /// It can borrow resources of the driver's binding for `'reg`. Per-device state lives here.
+    type RegistrationData<'reg>: Send + Sync + 'reg;
+
+    /// Data shared by callbacks from the first successful open until the last close.
+    ///
+    /// It can borrow the registration data, of lifetime `'reg`, for `'open`.
+    type OpenData<'open, 'reg: 'open>: Send + Sync + 'open;
+}
+
+/// Callback data stored after the C device structure.
+///
+/// The registration data and the open data of `T` are both written with the placeholder
+/// lifetime `'static`, because the device has no lifetime to name.
+///
+/// # Invariants
+///
+/// `reg_data` is `None` until a registration publishes its data, and is not changed again. The
+/// data is pinned and remains valid while the device is registered. After unregistration or a
+/// failed registration attempt, the pointer may dangle; its pointee must never again be
+/// accessed through this device.
+/// `open_data` is `None` outside a successful first open, otherwise it owns a pinned allocation
+/// until the last close. The bus-specific layer drains callbacks before either is released.
+struct CallbackData<T: Operations> {
+    reg_data: UnsafeCell<Option<NonNull<T::RegistrationData<'static>>>>,
+    open_data: UnsafeCell<Option<NonNull<T::OpenData<'static, 'static>>>>,
+}
+
+/// A C VFIO device structure `Raw`, followed by the callback data of the driver `T`.
+///
+/// `raw` is the first field, so the `vfio_device` at the beginning of `Raw` is also at the
+/// beginning of `Self`, as `vfio_alloc_device()` requires.
+///
+/// Use the alias [`Device`].
+///
+/// # Invariants
+///
+/// - `Raw` is a C structure that begins with its `struct vfio_device`.
+/// - The data stored is only valid as described for `CallbackData`.
+/// - `raw` is initialized and remains alive while borrowed. The reference count of its embedded
+///   `vfio_device` owns the allocation.
+/// - For [`Open`] and [`IoContext`] references, registration data is published and remains
+///   valid for the reference's lifetime.
+#[doc(hidden)]
+#[repr(C)]
+pub struct DeviceBase<Raw, T: Operations, Ctx: DeviceContext = Normal> {
+    raw: Opaque<Raw>,
+    data: CallbackData<T>,
+    _context: PhantomData<(T, Ctx, NotThreadSafe)>,
+}
+
+/// A VFIO device, wrapping `struct vfio_device`.
+pub type Device<T, Ctx = Normal> = DeviceBase<bindings::vfio_device, T, Ctx>;
+
+#[expect(dead_code)]
+impl<Raw, T: Operations, Ctx: DeviceContext> DeviceBase<Raw, T, Ctx> {
+    /// Initializes the Rust fields of a newly allocated device.
+    ///
+    /// # Safety
+    ///
+    /// `this` must point to an allocation with the size and alignment of `Self`, whose `raw`
+    /// has been initialized. `Raw` must be a C structure that begins with its
+    /// `struct vfio_device`. Nothing else may access the allocation during this call.
+    unsafe fn init(this: *mut Self) {
+        // SAFETY: The caller provides exclusive access to a suitable allocation.
+        // INVARIANT: No data is published, and no open data exists.
+        unsafe {
+            (&raw mut (*this).data).write(CallbackData {
+                reg_data: UnsafeCell::new(None),
+                open_data: UnsafeCell::new(None),
+            })
+        };
+        // SAFETY: By the same reasoning above, `_context` can be written.
+        unsafe { (&raw mut (*this)._context).write(PhantomData) };
+    }
+
+    /// Recovers `&Self` from the `vfio_device` VFIO passes to a callback.
+    ///
+    /// # Safety
+    ///
+    /// `vdev` must point to the `vfio_device` at the beginning of a `Self` that remains alive
+    /// for `'a`. The caller must provide the guarantees of `Ctx` throughout the borrow.
+    unsafe fn from_raw_vfio<'a>(vdev: *mut bindings::vfio_device) -> &'a Self {
+        // SAFETY: By the type invariants, `Raw` begins with its `vfio_device`, and `raw` is the
+        // first field of `Self`. The caller guarantees validity.
+        // INVARIANT: The caller provides the guarantees of `Ctx`.
+        unsafe { &*vdev.cast() }
+    }
+
+    fn as_raw(&self) -> *mut Raw {
+        self.raw.get()
+    }
+
+    fn as_raw_vfio(&self) -> *mut bindings::vfio_device {
+        // By the type invariants, `Raw` begins with its `vfio_device`.
+        self.as_raw().cast()
+    }
+}
+
+#[expect(dead_code)]
+impl<Raw, T: Operations> DeviceBase<Raw, T> {
+    /// Publishes the registration data passed to callbacks.
+    ///
+    /// Returns [`EBUSY`] if registration data has been published before, so that a device can
+    /// be registered at most once.
+    ///
+    /// # Safety
+    ///
+    /// The caller must serialize calls for this device. `data` must point to pinned data that
+    /// remains valid until the device has been unregistered or, if registration fails, is not
+    /// accessed through this device.
+    unsafe fn publish_registration_data<'reg>(
+        &self,
+        data: NonNull<T::RegistrationData<'reg>>,
+    ) -> Result {
+        // SAFETY: The caller serializes publication, and callbacks only read the slot.
+        if unsafe { (*self.data.reg_data.get()).is_some() } {
+            return Err(EBUSY);
+        }
+        // SAFETY: The slot is unpublished, so the device has not been registered and no
+        // callback can read the slot.
+        // INVARIANT: The slot is written once; the caller keeps `data` valid.
+        unsafe { *self.data.reg_data.get() = Some(data.cast()) };
+        Ok(())
+    }
+
+    /// Destroys the open data.
+    ///
+    /// # Safety
+    ///
+    /// Call once after a successful [`DeviceBase::open`], with all I/O callbacks drained and
+    /// the next first open excluded. Registration data and the resources the open data borrows
+    /// must remain alive.
+    unsafe fn close(&self) {
+        // SAFETY: The last close exclusively takes the allocation published by `open()`.
+        let raw = unsafe { &mut *self.data.open_data.get() }
+            .take()
+            .expect("VFIO OpenData is expected to be populated.");
+        // SAFETY: `raw` came from `into_foreign()` in `open()` and is not used again. The
+        // allocation is destroyed without moving it.
+        drop(unsafe {
+            <Pin<KBox<T::OpenData<'static, 'static>>>>::from_foreign(raw.as_ptr().cast())
+        });
+    }
+}
+
+#[expect(dead_code)]
+impl<Raw, T: Operations> DeviceBase<Raw, T, Open> {
+    /// Creates the open data from the registration data.
+    ///
+    /// The [`Open`] context guarantees an exclusive first open of a registered device, whose
+    /// registration data remains valid until the last close.
+    ///
+    /// # Safety
+    ///
+    /// - No open data may exist.
+    /// - The caller chooses `'a` and `'reg`; this function cannot tie either to the time the
+    ///   data is valid. `init` must therefore use the registration data parametrically, as a
+    ///   function generic over its lifetimes does: nothing borrowed from it may escape, other
+    ///   than into the returned open data.
+    /// - `init` must not capture references that are only valid for the callback and store
+    ///   them in the open data, which outlives the callback.
+    /// - The open data must be destroyed with [`DeviceBase::close`] at the last close.
+    unsafe fn open<'a, 'reg: 'a, I>(
+        &'a self,
+        init: impl FnOnce(&'a T::RegistrationData<'reg>) -> I,
+    ) -> Result
+    where
+        I: PinInit<T::OpenData<'a, 'reg>, Error>,
+    {
+        // SAFETY: By the type invariants, an `Open` reference only exists for a registered
+        // device, which has published registration data that nothing changes anymore. The
+        // data remains valid until the last close.
+        let reg_data = unsafe { *self.data.reg_data.get() }
+            .expect("VFIO registration data is expected to be published.");
+        // SAFETY: By the same reasoning above, the registration data is valid; only its
+        // lifetime is named here.
+        let reg_data = unsafe { reg_data.cast::<T::RegistrationData<'reg>>().as_ref() };
+
+        // Allocate before calling the driver so allocation failure cannot follow open.
+        let data = KBox::pin_init(pin_init::pin_init_scope(|| Ok(init(reg_data))), GFP_KERNEL)?;
+        // The stored type only differs in lifetimes, which do not affect the layout.
+        let raw = data.into_foreign().cast::<T::OpenData<'static, 'static>>();
+        // SAFETY: The first open is exclusive, and no I/O callback runs before it returns.
+        // INVARIANT: The allocation is pinned and owned by the slot until `close()`.
+        unsafe { *self.data.open_data.get() = NonNull::new(raw) };
+        Ok(())
+    }
+}
+
+#[expect(dead_code)]
+impl<Raw, T: Operations, Ctx: IoContext> DeviceBase<Raw, T, Ctx> {
+    /// Returns the registration data and the open data, for an I/O callback.
+    ///
+    /// # Safety
+    ///
+    /// The data is named with the placeholder lifetime `'static`, which is not the time the
+    /// data is valid. The caller must use both parametrically, as a function generic over
+    /// their lifetimes does: nothing borrowed from them may outlive the callback, and nothing
+    /// borrowed for the callback may be stored in them.
+    unsafe fn callback_data(
+        &self,
+    ) -> (
+        &T::RegistrationData<'static>,
+        Pin<&T::OpenData<'static, 'static>>,
+    ) {
+        // SAFETY: By the type invariants, an `IoContext` reference only exists during an I/O
+        // callback on an open, registered device. VFIO excludes the last close and
+        // unregistration for its duration, so by the type invariants of `CallbackData` both
+        // slots hold valid data that nothing changes, and the open data is pinned.
+        let reg_data = unsafe { *self.data.reg_data.get() }
+            .expect("VFIO registration data is expected to be published.");
+        // SAFETY: By the same reasoning above, nothing changes the open data slot.
+        let open_data = unsafe { *self.data.open_data.get() }
+            .expect("VFIO OpenData is expected to be populated.");
+        // SAFETY: By the same reasoning above, the registration data is valid for this callback.
+        let reg_data = unsafe { reg_data.as_ref() };
+        // SAFETY: By the same reasoning above, the open data is valid for this callback.
+        let open_data = unsafe { open_data.as_ref() };
+        // SAFETY: By the same reasoning above, the open data is pinned until the last close.
+        (reg_data, unsafe { Pin::new_unchecked(open_data) })
+    }
+}
+
+// SAFETY: VFIO uses the embedded class device's refcount to own the full allocation.
+unsafe impl<Raw, T: Operations> AlwaysRefCounted for DeviceBase<Raw, T> {
+    fn inc_ref(&self) {
+        // SAFETY: A shared reference keeps the initialized VFIO device alive.
+        unsafe { bindings::get_device(&raw mut (*self.as_raw_vfio()).device) };
+    }
+
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // By the type invariants, `Raw` begins with its `vfio_device`, and `raw` is the first
+        // field of `Self`.
+        let vdev = obj.as_ptr().cast::<bindings::vfio_device>();
+        // SAFETY: The caller owns the VFIO reference being released.
+        unsafe { bindings::put_device(&raw mut (*vdev).device) };
+    }
+}
+
+// SAFETY: VFIO serializes open/close transitions, and callback data is `Send + Sync`.
+unsafe impl<Raw, T: Operations> Send for DeviceBase<Raw, T> {}
+
+// SAFETY: Shared access only changes the embedded class device's reference count. I/O callbacks
+// share `Sync` data; VFIO excludes them from mutations of `open_data` during first open and
+// last close, and registration data follows the registration lifetime. Mutable C state is
+// managed by the VFIO core.
+unsafe impl<Raw, T: Operations> Sync for DeviceBase<Raw, T> {}
+
+/// Capability buffer supplied by VFIO for a region-info callback.
+pub struct InfoCap<'a> {
+    #[expect(dead_code)]
+    raw: &'a mut bindings::vfio_info_cap,
+}
+
+/// Opaque wrapper around a `char __user *` buffer from a VFIO read or write callback.
+///
+/// Provides bounds-checked copying of kernel data into the user-space buffer.
+///
+/// This type cannot be constructed by driver code — it is only created by the
+/// callback trampoline.
+pub struct UserBuf {
+    ptr: UserPtr,
+    count: usize,
+}
+
+impl UserBuf {
+    /// Returns the buffer length in bytes.
+    pub fn len(&self) -> usize {
+        self.count
+    }
+
+    /// Returns `true` when the buffer is empty.
+    pub fn is_empty(&self) -> bool {
+        self.count == 0
+    }
+
+    /// Limit this callback's transfer to at most `count` bytes.
+    pub fn truncate(&mut self, count: usize) {
+        self.count = self.count.min(count);
+    }
+
+    /// Overwrite the part of `data` that overlaps a completed region read.
+    ///
+    /// `read_offset` is the starting region offset and `read_len` is the number of
+    /// bytes returned by the read. `data_offset` locates `data` within the same region.
+    pub fn write_overlapping(
+        &self,
+        read_offset: u64,
+        read_len: usize,
+        data_offset: u64,
+        data: &[u8],
+    ) -> Result {
+        if read_len > self.len() {
+            return Err(EINVAL);
+        }
+        let read_end = read_offset.checked_add(read_len as u64).ok_or(EOVERFLOW)?;
+        let data_end = data_offset
+            .checked_add(data.len() as u64)
+            .ok_or(EOVERFLOW)?;
+        let start = read_offset.max(data_offset);
+        let end = read_end.min(data_end);
+        if start >= end {
+            return Ok(());
+        }
+
+        // These differences are bounded by `read_len` and `data.len()`.
+        let buf_offset = (start - read_offset) as usize;
+        let data_start = (start - data_offset) as usize;
+        let data_end = (end - data_offset) as usize;
+        self.write_at(buf_offset, &data[data_start..data_end])
+    }
+
+    /// Copy the part of a pending region write that overlaps `data` into `data`.
+    ///
+    /// `write_offset` is the starting region offset of the write. `data_offset` locates
+    /// `data` within the same region. Returns the range of `data` that was filled.
+    pub fn read_overlapping(
+        &self,
+        write_offset: u64,
+        data_offset: u64,
+        data: &mut [u8],
+    ) -> Result<Range<usize>> {
+        let write_end = write_offset
+            .checked_add(self.len() as u64)
+            .ok_or(EOVERFLOW)?;
+        let data_end = data_offset
+            .checked_add(data.len() as u64)
+            .ok_or(EOVERFLOW)?;
+        let start = write_offset.max(data_offset);
+        let end = write_end.min(data_end);
+        if start >= end {
+            return Ok(0..0);
+        }
+
+        // These differences are bounded by `self.len()` and `data.len()`.
+        let src = self.ptr.wrapping_byte_add((start - write_offset) as usize);
+        let range = (start - data_offset) as usize..(end - data_offset) as usize;
+        UserSlice::new(src, range.len())
+            .reader()
+            .read_slice(&mut data[range.clone()])?;
+        Ok(range)
+    }
+
+    /// Copy `data` to the user buffer at byte offset `offset`.
+    ///
+    /// Returns [`EFAULT`] if the copy fails, [`EINVAL`] if the write would
+    /// exceed the buffer bounds.
+    fn write_at(&self, offset: usize, data: &[u8]) -> Result {
+        let end = offset.checked_add(data.len()).ok_or(EOVERFLOW)?;
+        if end > self.count {
+            return Err(EINVAL);
+        }
+        let dest = self.ptr.wrapping_byte_add(offset);
+        let mut writer = UserSlice::new(dest, data.len()).writer();
+        writer.write_slice(data)
+    }
+}
-- 
2.43.7


