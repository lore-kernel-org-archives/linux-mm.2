Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3D2606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Q9GMfbnE
Received: by kanga.kvack.org (Postfix)
	id 50EB36B0A15; Wed, 25 Nov 2026 08:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF8D6B0A17; Wed, 25 Nov 2026 08:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386836B0A18; Wed, 25 Nov 2026 08:33:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 036DD6B0A15
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:33:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95B391A0E08
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:33:39 +0000 (UTC)
X-FDA: 85473733758.27.5E96B17
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010058.outbound.protection.outlook.com [40.93.198.58])
	by imf21.hostedemail.com (Postfix) with ESMTP id 66D501C0002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:33:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Q9GMfbnE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.58 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795613616;
	b=Zu7udf0dd5GU6m5vEsDBnyuf0+2ULPYBpWdNoLJKSvG2QndyFMgW8+jRSxbNd+twl3XJyr
	pIih7FYY8vzMUWeGanjp7LxwuWuKtWcgbqmglsF9fYPETptjG2T7O82uFJjQwMNXSbymcJ
	NkTHFQKzzzaSD7xXjpbA8Ez02D5ijiw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795613616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S62w6zjcW3s/J+PftCdLGf4vo2CWiGOIoXgabOAgCCE=;
	b=4rB4f8jcESQ5GZBFPZgjyvhiyEIpblqmuSc7TI2tK9xyb4GsTGxZ9j1OIALStaY+jHJo+5
	nirtInFYOcKiiGv+Xb6fKHCSx3gl1S6aGKvMThWYWjHhWYoCNzAvTzHpNUC6bVK3nt1hFb
	iMwd2aClBShW8/i0x8nAnvb2n/DmcNk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Q9GMfbnE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.58 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vRveqmgsXDxuv4NY5oV+eSydFSlKp/fu+FEtNlWGQLLVgmXbmzlNgJHgGQbCQhKEv5GrNo1k/sZ3a+9tx+rWRWhy4BHpi44zT4NfwiFOjS9ZVlWkZSC7LtjttN7kASskq5xvtCH2XNE9Msm+WpoGfo/mL6p04Mp7vFjXqALelrcO5HZayT/odjsgLQQc163fMp8Yys9D1kiM8fBU2bRC8pUBGvT0EWLjnYuBoHQnev8gUYjrGDp6Z8b3kGQnjLxf+jKsJFwzgPRHXCeb+1Y2+dj1jkx9wAckf8wIbRgMr7oicXJmtAubXFJaE4wSCRQsP0C/fhSnCz18KvdWq3Ep1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S62w6zjcW3s/J+PftCdLGf4vo2CWiGOIoXgabOAgCCE=;
 b=nXg1YwGdS4i7XdxrIFghNWYBM9/hKjRDe1UojNdEwys11tKzwahKhc64TYuScCCbfZ6o/2LSJlwwq6aTUVLHo+dQ0JYbDvYb0dFm4QdaVkXy/s2hyqngDgGhcE8NM84IMvD68QSSZ55XHLOBa1ytVh2sYwFdFnXU3uT5mhNXl8o2zdm4Y8mPt8ZX/g9dVpZbbJjzHulM2Nys8j4RGGAfcniPkc8pDOSCr2J/CTElhPSKKgpsjJ2bEsJgYHOXi2VhOWPtkujJEvC3Qj4/D/N9Fx7ON01vNuozV4DfDZex0+SIBjCtzIxuBSsT3c99Ntir1YBN4qSoBXmAhoT2VNThgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S62w6zjcW3s/J+PftCdLGf4vo2CWiGOIoXgabOAgCCE=;
 b=Q9GMfbnEip63TZEDghlfa4h82DqYN0IhAFsBSFG9gnRfF3KrwFFp6pIwOs458XfS6DECBmqrNgOIGqSe2zER1AtyNaO1lYIXUC4TjSiblYLEh+hBKI3vZw2mok+llY6bRGnE29mM9CGW9IzYYLtmS1KcQ1NVA3MMrMNdHFA3J14=
Received: from BN9PR03CA0327.namprd03.prod.outlook.com (2603:10b6:408:112::32)
 by CY5PR12MB6250.namprd12.prod.outlook.com (2603:10b6:930:22::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Wed, 25 Nov
 2026 13:33:23 +0000
Received: from IA0PEPF00000046.namprd04.prod.outlook.com
 (2603:10b6:408:112:cafe::41) by BN9PR03CA0327.outlook.office365.com
 (2603:10b6:408:112::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Wed, 25
 Nov 2026 13:33:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 IA0PEPF00000046.mail.protection.outlook.com (10.167.249.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 13:33:22 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 07:33:14 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 25 Nov 2026 13:32:27 +0000
Subject: [PATCH 1/3] mm: move the soft-dirty fallbacks up in pgtable.h
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c@amd.com>
References: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
In-Reply-To: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Dev Jain <dev.jain@arm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
	<nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Peter Xu
	<peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
	=?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <emmir@google.com>, Andrei Vagin
	<avagin@gmail.com>, Paul Gofman <pgofman@codeweavers.com>, Bharata B Rao
	<bharata@amd.com>, Daniel Wade <danjwade95@gmail.com>, Yin Tirui
	<yintirui@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>
CC: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795613581; l=4846;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=nVG+o7H7zKVc74+mKyu3/hRn5ugI+dylRNZVZEKpQG8=;
 b=o2v9vqaAeRGQXMu8q2IPQDHI1MNVPa2O/cxD6JXN82bVHDgYx6GQXWlgvpG+VoO0lCjdC3eWq
 fCgF5sw4FihDoPArErwp5EqYVEkD0ESi2N3wDpV176AOSbuG22W/zc4
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000046:EE_|CY5PR12MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: d0009333-1b6c-45a6-0474-08df4af8aceb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|7416014|376014|1800799024|82310400026|921020|10067099003|11063799006|56012099006|261022105027099003|261026121527099003|261021121427099003|261009223027099003|261102123227099003|261026140227099003|261022075727099003|261021123027099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	h5dzVHQzbKni1lmzavo+5tooyAL7veA0CfS8PS32igm55j3mHisNHq3S7tizznL98WR41jjwNnS2PNaPU0335Wc/ImCoYIF2fBvRjyKL6XIBYPTn0cTbBDW/HeA98xAnypQ/GOTRNpWCIxfx33L+eKvzZu441k29xPqdKxqbr/oEHSYOvGOHFRR+3hdgu0TOs7eWB0lJPQutzznmYzoHUXGZ/nVAjdUItSs5wd4eCP16b7IdZc9g8SacEVo3512xzwMkUmR7dQN1fi1ac6ne0GvWMPHJ7hw42DVVR8hDsm7KCxcbPwG0LRkkCohFpCrFIqXCV2njT+foAy3EN1cxBfjQgBEqA1ey/XO4ffc1ZgfT+RehOUPtLMCzqw3pRrNnUkq/uEHSdZuy+6e15k3rjDGFZcTr19PmjekspDhaLdSpxP2KeHFiocdgWvO5KTCjO7d/a0zkMeypD9azbJUdoEQS4QHYiOa3wDjnET34EdkjZAxuvnphvS6snxRsOvdO0rNmH8uje32CRFdcVGswImOL5i5Gvg3iSvcaY5rPgTZVAWJj6wS5TeCatAlAcyOugUK1M1Z1pN2wghMKJqHfFlWLw50b9Pf3fOGISyvY6jSxw4jz9XjL5mmditM+FnzT6PNGKt5yOTKCck8t7fqa6gPjoGrlBbmw2kQeJrmbCMH+0Bf1qodzdzZ5ydoZy0L3eoPjGlq39VclzOZ3NFsctjgJy8LJ4RcjkfIzF3PSXLohm7qwCH8QvtwlrcUEC0fX
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(7416014)(376014)(1800799024)(82310400026)(921020)(10067099003)(11063799006)(56012099006)(261022105027099003)(261026121527099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026140227099003)(261022075727099003)(261021123027099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CkwkkDQ/7YY+BeCZ0w5K7gfMoai9w4jXNozyzfLtKIHpyqDvTIAF+iAYyBY54CaHye/9UJIKYCKAB/OQUiTQY3AXnaO20nEFCswliwqr5qNxbvSZe6C2IyAWQj6HquDOPU7qcA+6zZZqmazdrHBP3C/t5SdQaOyy4ZTp1oC2dLYY73KUDaEdEVGDohYzAg/tMYwJotNbTzAG4NsbTdYeWJ+TxQwh9xSyrAStUHe2p+KtPrsmKhqaP6wdsTAC2RBCtD3GqGxrF22DT2j8vYCWj98JaoXDOpy9sPv7FkuOjcpnd2+WRWiBho8BlHYBj5SSCmJ8y2UNFF1UFeXhzMYFjVAXa2cMIt7nmg2IbCOje2+SfRNJwu4Q+phaoMzn5IxdeeODBbGqx6hx5a/ok86zCMkqVRWxyIE4aFsdiPeTK3cCyT0zQejew4wm0y9oMRal
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 13:33:22.2879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0009333-1b6c-45a6-0474-08df4af8aceb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000046.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6250
X-Stat-Signature: uhaa9bam39tc3g5iqm9rrs5a98a6pooc
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 66D501C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1795613616-674524
X-HE-Meta: U2FsdGVkX1/ipeglqd1SG4QzJBn/7Tq1pTdBl1hBlwJFhk1JNJRQQHBRUuD0a0G95nY9rIvBCiKIDWZbQ3pLl40xU9fH/yz22+PJPiIKj21qKTJmwA+a7Z/KMYUjjjaNvHoE+bNnNWwSqTbIQfZhLAr89VQSY81WsNzAQWFz2i9st8OVsbgquEddoLcFGym+gMNbDZqND7Dg3WMhX2zmoLW7lvDUC9gusKRzSFofc9FA6yLNUGHWvcIcui8iQyX7vaVYxj6eNX5Aa1wOqzL9kK0CmDf55wp9eajOT4EgsIzqdbyZDiMsR6CSumtqhGZhDijCuWaDx50UptXwpu4g/78/Ngg4qCaKdMhbJr3YB64c1kCAOyyicwGEanzsRipMUEqeCo9EV/tfPHykOvi0wudLzjm7DRp/ptzHi+ogIfO2APiyXtFoQw5r3bZ+kIuCMZVxmX9UjOSMoezd/Kky48BWP/U+OY5fjkiQokvHmdkrbiz7ChPbz30po4laLnUELfB/kgqG/S91ERg4qSkRyQkhOqZXyF/jLByhfvu0WWgAYZOQpoUI8qkELmpu314ypzGdl0HbX3T2ER5smljvWyTpQBn4ORJVaPHcmKDC1gj0gGtkkjbtqjvc205FtoawDgNn1pEDeodWI2yNlzHEEI/+okfaAw7zmbA32VnAYkrI8sOiUK1nagWUPvFE5cKSAlFkpvXA6B+8C9ZmLHCsddRnKEICG83nJ7MLxA6c5qc5krRhnanvm6aRImeI9wosxWOgDwYgiZL0PQr2DXX6INz49CoxGooT8S2yVptks0XQ84RqsXxSCoGBhy9J/djEtQ8tQM4uNK6inX+Em/47oW8KbjAQI1TR6f5baxp4G9ZvT5uYeC6omIMzrJtmBPCyl53uyUCOM4w5b53WnhUuNSs2OaSAxRff3wrqt/2JYw2ouHXSzGiQqGtl/9olh4gSRIm27E7UqkADSlrxBsC
 hmj64gV+
 aCaVliFlzOtiaXjBlGlvahB9e7rhwZ7g95dN/wi5R92n4bvHlDByXk7rsgUApbzFG+qNNDgrJ06BepqyAwdVbnfr9IvDsEh6kInWUsUKguNZg/w2w88pjA1uO40pfxAoT4I3qMec/SlJ3HItUOaK+SV8pLLGbh+jI9FCZaEEE6Hp/qmugKcBz6QRWuzWiNMXFS8KgSIS5EVNuUNqYjMXM8ZgGkrGQdsAHPiqyutj6dnkhdJ6nyLNoI/F85qZvdDPCqIjOR4b8+qB7a73OEUHdyKvXGeZnpoShESGcRkec+huu9v/6eTwpaRnRpRRJ0Reeprnr5gxl5grXcTVimfVIIq7H2Vn0WOR4XH+NMoVQ7QuklXbuoMSexTe33KTtQD/x4P3PCNRXC/LNo2ufMXscJw/u7EF1GDQLHCCUkL0sI3U080Oha1XO3EgI19JiLXgWILL6AfC5j5NK2szH0TlJsay7nF2CJNfIp6cH6wNNb5ghq506C48GPKQ8JHO+PXKhceRA7YyiqA2ri2gK5bpe1+r+N2qNr+sbsOk4eBiIqjTccCsqeiR2EKpgUasVTCGVsOpUDL/NjGp4P0W36q3r9zmwJvbhDJJ7Jooyogq3bVS0WHs+Ki/QUdPKMPXWyjJ5Z997Et5Xym9e4iCs0f/ZOUU8WUcqTsYixxMxwmugImgNbusgMby5AdpB4kbPalFewbuhNZwq2lZA/9OacqML74+VSAvPpEROGlgLL0htQqgzZQym2Gx6X8FSRJoUIDNZgPZYllB7Q+CigT6FRyH57hJhzW2HLh+kD8Rn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fallbacks for pte_soft_dirty() and friends on architectures without
CONFIG_HAVE_ARCH_SOFT_DIRTY are defined near the end of pgtable.h, after
the batched PTE helper modify_prot_start_ptes().

Move them, together with pgtable_supports_soft_dirty(), up next to the
other generic PTE and PMD accessors, so that the next patch can use them
in that helper.

No functional change.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pgtable.h | 182 ++++++++++++++++++++++++------------------------
 1 file changed, 91 insertions(+), 91 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 66d369870a74..b1db7aec5362 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -194,6 +194,97 @@ static inline int pmd_dirty(pmd_t pmd)
 }
 #endif
 
+/*
+ * Some platforms can customize the PTE soft-dirty bit making it unavailable
+ * even if the architecture provides the resource.
+ * Adding this API allows architectures to add their own checks for the
+ * devices on which the kernel is running.
+ * Note: When overriding it, please make sure the CONFIG_MEM_SOFT_DIRTY
+ * is part of this macro.
+ */
+#ifndef pgtable_supports_soft_dirty
+#define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
+#endif
+
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline int pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+#else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
+static inline int pte_soft_dirty(pte_t pte)
+{
+	return 0;
+}
+
+static inline int pmd_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pte_t pte_mksoft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline pte_t pte_clear_soft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline int pte_swp_soft_dirty(pte_t pte)
+{
+	return 0;
+}
+
+static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline int pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+
 /*
  * A facility to provide lazy MMU batching.  This allows PTE updates and
  * page invalidations to be delayed until a call to leave lazy MMU mode
@@ -1850,97 +1941,6 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
-/*
- * Some platforms can customize the PTE soft-dirty bit making it unavailable
- * even if the architecture provides the resource.
- * Adding this API allows architectures to add their own checks for the
- * devices on which the kernel is running.
- * Note: When overriding it, please make sure the CONFIG_MEM_SOFT_DIRTY
- * is part of this macro.
- */
-#ifndef pgtable_supports_soft_dirty
-#define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
-#endif
-
-#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
-#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
-static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline int pmd_swp_soft_dirty(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-#endif
-#else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
-static inline int pte_soft_dirty(pte_t pte)
-{
-	return 0;
-}
-
-static inline int pmd_soft_dirty(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline pte_t pte_mksoft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline pte_t pte_clear_soft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline int pte_swp_soft_dirty(pte_t pte)
-{
-	return 0;
-}
-
-static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline int pmd_swp_soft_dirty(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-#endif
-
 #ifndef __HAVE_PFNMAP_TRACKING
 /*
  * Interfaces that can be used by architecture code to keep track of

-- 
2.53.0


