Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EB4606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 19:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gvu1A139
Received: by kanga.kvack.org (Postfix)
	id 4063D6B00EF; Mon,  9 Nov 2026 14:16:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6FE6B05B0; Mon,  9 Nov 2026 14:16:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F556B05B1; Mon,  9 Nov 2026 14:16:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E54166B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:16:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 683611A0784
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:16:45 +0000 (UTC)
X-FDA: 85416537570.15.EDE1F62
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011061.outbound.protection.outlook.com [40.93.194.61])
	by imf12.hostedemail.com (Postfix) with ESMTP id 207C740009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:16:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gvu1A139;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794251802;
	b=VaWXfJ4CWNXX70A5mQyMI1dYdxIh8kFcsQxrctQQ4+BaNOKUGWOdj7iQzLZTR2BjI9OxAo
	B9I6iE51lIF2gDy70jcck8lq4437+VxN0U/+xnMp/N3oy2WRCOvojm3FWPrzMg7feTPX60
	4GGnjjiDc2aBT0bMpfhCSLTgjIea354=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gvu1A139;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794251802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8u5w95cAT4AqylY2+SjrdhHAzOziXGL/qgoxF07FL6w=;
	b=tnFPeN7/QuzERExO+I6aqYgQHDC1eWR1QzvmnZErRlmepI+Dq0ac1ofmY1QgKBFRa0O7re
	PYIZ7yUJMF+Wr7YjbX8NJ3Eu4ap5Y3LV6YYc7wZHCUJKR7U1TsHCKT/nLahAnUUTQSTlM2
	L9kT1RCQcGjysW3wGM156QFwBKjjzsE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDwECN/4n476MBjSN71dm6fsiWVxjlROKw78exYdiAXkhlqqTs1TwGKLs3A6pnHu8IuUcUbVw+4lPmBt7kwuS92rSlE1e0O1iK3opCEzvKIV7wEMkPV2s9044Kebm9HtHDnVPdrdUcmAtG0LewNwTboJqe4jY+DiJarXWPfQ65wpNPW0tv4kV/30bNEHxzOws6RJ3mZkHsSAWFJzjC8z2uov/fit5OVYgQ+BX5vcBlmh8hgnRAGi1s19uQ67j6lgoqa9/NNQUIZi2zSMd8WsCaIxrGyjiDOLhgNzv4yg1MdutFEEyV7/AAYe17C/hFvo7qWtI+hJb9q1MumlziqpLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8u5w95cAT4AqylY2+SjrdhHAzOziXGL/qgoxF07FL6w=;
 b=dLFO25Zg1Dx1Dmx68puaiusU/NzrfSDupCwqIUbJ9nCOtzd8AZerg5vz1dL8pptcBUqJ93HCrjioBNPAt1iRMY7lf7itx3/q+Md1eE78suv9vCBGeQWvF/amu4KsLBF9JlqxF8ESzLfvuKj07yZHs6OFDW3w0qA2VFi/Zow/U/DLoYiKXYdA8T6rs1eKg0Jab8WpUQP+rKPgC25b4cgp+fU7a8I1IbuXgDYTFe+iGlJgHPTnvSotBFzYKMdSA/iviSWap+d22i4CrpBDIhd3h6WaAlgD/4WZDIXpnxKEchwZPwZa4EivCNXOJUB8pc2BbwziCmrxkeVsWMw2clEYmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8u5w95cAT4AqylY2+SjrdhHAzOziXGL/qgoxF07FL6w=;
 b=gvu1A139lv3CLP+txip+pdTSVUptAzcTmKfelL0AbhvUNB1CvbK0YARn/InC+j2Kd2Q++wbX5MahoDol66G/JZUCyqXa/6ziti3Aq3gmDYH4hrvJmRssWyh402XmV7twi4y2Xl0iVkwXH+pg9KEf4snUP3hNAWtSUIDhRFCeS/E=
Received: from BN9P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::17)
 by BL1PR12MB5970.namprd12.prod.outlook.com (2603:10b6:208:399::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 19:16:16 +0000
Received: from BN2PEPF00004FBA.namprd04.prod.outlook.com
 (2603:10b6:408:13e:cafe::7f) by BN9P220CA0012.outlook.office365.com
 (2603:10b6:408:13e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 19:16:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBA.mail.protection.outlook.com (10.167.243.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 19:16:15 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 9 Nov
 2026 13:16:10 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 9 Nov 2026 19:15:51 +0000
Subject: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NzQrDIBAGXyV4rkU3Ek1PeY/Sg9E1EZofNEhLy
 LvXBEouYU/zwcyuJGLwGMmjWEnA5KOfxgzlrSCm12OH1NvMBBhUnAGn5o060Fl3GGmrF9NTKZ0
 EdIopFCR7c0DnP0fz+crc+7hM4Xu8SHxf/zW4qCVO85W2bC1rlayw0YO9m2kgeyvB6XNWX/mQf
 cAKjHBKuFqc/rZtP65fSTPwAAAA
X-Change-ID: 20261021-clear-pages-batch-77f72ef808e4
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, Pedro Falcato
	<pfalcato@suse.de>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov
	<bp@alien8.de>, Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke
	<hsalunke@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>
CC: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794251770; l=6052;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=Bb5seka6xNYsOmYAJp2YNJ60p2VRS1KfZvZfUsEUQBs=;
 b=EcUWwczM/eMwNTCxsByYAirBsxAtvCZLIaalTzmen3dn0lvU0Q7nkwCVT/EtoYc9+NsTzRto+
 HiPrGJv2LGwCu1+703ZO5sIWz0EbAZ7fy7JczygdWFDoTVW3u27cGkN
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBA:EE_|BL1PR12MB5970:EE_
X-MS-Office365-Filtering-Correlation-Id: ea5bf661-6d4a-42e1-bcd9-08df3e95ecf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|82310400026|23010399003|921020|260925022911599003|260925021311599003|260925021911599003|10067099003|5023799004|11063799006|56012099006|261021123027099003|261022075727099003|261021121427099003|261009223027099003|261026121527099003|261102123227099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	ooTzTUXhiaMI4v4F58fKC1u+z6O9CQHEzlL9kPzCMebSWy/a9/ydMXYnIyqy/Ya8hhd5+Lo+xmcMZBKl2W3RDGQTQT93ei34yRbRyt2/45NfVwz45U9gDmp2W5qqlfQ2gppleM7EpNso7lpgrFTiEfrN4QoqpW7t5PHjMhba0DKAebwISqaYPtO8V1PkkkZT4Em+cpIRLZ3iZ2sEd7ux151bJOISYieGzCJJMUwGvvuSRx7e0eV4UKa1ykm+eaddepEV46ZPh9pp/QAmzCC9k+Y+Abhkme6x8f4VKMGvu/f9TWO7FKN5FvAcuE62f1X2c7u53TXFIQ0NXk8eFUwegLGPkZFk0SHOuULSaAlI/Ug6/gsAvN0XnKdc3gBUdadudZrOhyolRf8tOpxkOOzbWbZtH0OtzDRhFvoSCeUeOca00vSnYIc8CvG1Mco7p4mtC/TkKa21wvJFJ77MDvWJCRnASyLvd70IdMyI6yeU476Hx63ncFu7g2K6X7Qo4SRnohLAuAnnd8mpZue4qQk26+8L5+6tM1IZYvx6PmymLTejgEDU1Gldc59wGIPE/2iWxx4GE8I/k9uQfFsOfdevUIHo6+qWwB7ZgnkqG56Em6a6rO3XwZMo+qV6c6ng74QQCYJiBWOkCYm3c7EvhraOgpmdNx1YfKLyTMeyOmWimQvJMb+VKeYPwPp6ip0019JUfF5OAktVJZc4OVVAzHaYVw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(82310400026)(23010399003)(921020)(260925022911599003)(260925021311599003)(260925021911599003)(10067099003)(5023799004)(11063799006)(56012099006)(261021123027099003)(261022075727099003)(261021121427099003)(261009223027099003)(261026121527099003)(261102123227099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jkRIKvL7oFAFwGgybgjzNvwkBeLwkJYuBcRJg0DS3VmlhtOlF2lN0O0yHTkjfxgAciOkrHYNdzmWqPD69PlxgnHFtg3ATCe39xZ3GUO1Yt28sCVLZgaCxyKgFcXtDh5hP8wY4QKd7UVAn14YwcI6M9ItDKcBCTCe2ubnWm5kWdH2b9Z1c1FrD1VA7nKtPILZDHI1eL5IcZfHODjsb5jlFbdoy/pi2CHqpi3565RAcsmRYgZDG7toGluvK1H2DCImKeXlFtfghhuEbrqMC8eq00PDMJSh7w98WL1sPeLOGj4LfJFwS+QFS1OingydlPGSuwDNZ/hRjUyeMlZpRprQOpkszYarJ17+HGMD4QtAFWsRTJ/0IzCzlnlcuWG9dMbQsXes2c/9xQXlD9Ea2yYjH8FXNd2r/NopWle5bsHCHkOmXIDzdNPGWxBX9lOkQVnx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 19:16:15.5765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5bf661-6d4a-42e1-bcd9-08df3e95ecf1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5970
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 207C740009
X-Stat-Signature: 11arp338xauhbuihema9jiqzf5f4oxps
X-Rspam-User: 
X-HE-Tag: 1794251801-147232
X-HE-Meta: U2FsdGVkX19VWSw8n5Gf0F4zo3RgItzoKu+jIbho2Pc3AWkEBedDUIlv4IRrAzUhr+46iv7Wqj92lmHAyrp0NA7oUj8P40HF16NZVsT9SSEe/0/60EB6FdCQ9Iy507Ic4/jCIHubllF4gxHIhQczoIUOjAXHhHmOzmUoGuvQGvuhEANrle972XlkfCzuIxjJSOHQdzy2Gln0BJwc/oMQEbOyvtC/x4+vVTH59RSkqgfj7bTp0UamluyRnoFizHC1DD8orGJea5aJsZDhkjzmUzhGplQFYb9O+iP18O3IoAnwFc/txsY+AdSjmfS28TnmTs1kL8X4yY/6Nj4L4iSm/xA567alL0E7N2vjlb9BdEjpw2S8Cj/BXnPaAQxWywOIHWiwaww7nOS/XB1vC6MNx9LzWSdTEWMnfDpSO8AE/cqv2qoZ/gZZnfnTNRmdbXGHPBID/4daW2FVBhHpPtVCBgVW8PKtI+b8hwY+naDYVFmDt+Uy3SslXPZAavJ9Cxdt2T8brb90FYQOlvTufDzYGShXxkjj3X4qLATLUl0l4WPSkNRTMDXpb8PFoKhoroQ41Wz661fCK2sfKnsOm576Sd6eb7xnY9wGosDR4q8wWZjAjzUEHRA6vvbo5GMY5WiZGta7TCWGWKwDx3l0S1XZ9PfwSuUkvqva27WPinMs9+qHiH17o1sJN2TrfTaetMmrI2oRlFqADoTSPq0Ps+QnN37xMNGiB4Y9wwrQuG+rRvSPmj7LACijWNAS6PhnsjOZKnlxkr89E+2q0ojqm+yDkUCnA0f8I4nC41Uw+ZQ+tEJk6yOmMbiFkkf8mozn0NhRyFM1aquru9bTXl5drOeOFIc8I+d2cdru0AyAtShCwHhsf2v81b/KAoX8+l1/8YdFZP0pmwoMPefBZHJE7MFazFm+WM80flnR7riWV8TA5cKndXVgVnuPf3u0pSyo/88UYYPDLOJhh+Y0hiUbT9O
 KAijzs/9
 SzMAw2EbHOL/lSmA4XCOs4wmXZuuou75EQUd54F8DpVKjGVah+F2vHOca/THlFPsiRV7XifXI2IyXHgwIs7+d/LL/uUatArvBIHf2GWiXcjhI24ONSxppdqvi43JdLEDCMbnAd+tFjQlaMF5S9OcbElY+9jzE26QKDnPKEP3s7HOfM6+ub3bHGyF+xFB51PE3fnBhJHlnsE4vacDUWj5uxfiYDoUu8/pqnjenSMn8IE4OFBcP7pPbVWnJExhM1Tz1SG/bnDA5BePmQ6erSTsaFxhS3DY8j/Z3aPRxzJRH/ueE3n97qDyMg3tFm9RIYcw3bYWyRVP2WGeZvRZG2pT7X679X4Y5539tGNjZ9Qbbq/kHC/hXSb7Ybr8doqF+RHGb10pmidrZi2hg48wIfG9wtBduFwLijxsYGa5DEI0JwCEnIF/8h4RyAC5znn4sLSU/mwLSod2ZnOa1U/MIR+J8soUVNTjrbtDgSCGICy6OP4ScP3YTYfmX+riHp+mRkyzxF7+g5y3gmimnZbcq4oJYBd5VMqL/ZmNr5OMv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

clear_contig_highpages() clears the whole range at once under
preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
pages at a time, with a cond_resched() in between. The batch is 32MB if
the architecture defines clear_pages(), and one page otherwise.

Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
modes"), architectures that support lazy preemption only offer the
full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
one of them, and it is the only architecture that defines
clear_pages(). So the 32MB batch is never used: whenever
clear_contig_highpages() runs under a cooperative model, the batch is
one page.

Make that explicit. Clear the whole range when CONFIG_PREEMPTION is
set, and one page at a time with cond_resched() in between otherwise.
Drop PROCESS_PAGES_NON_PREEMPT_BATCH, which has no other users.

PREEMPT_DYNAMIC kernels also have CONFIG_PREEMPTION set, and
cond_resched() does nothing on any of these kernels. So a build-time
CONFIG_PREEMPTION check is enough, and preempt_model_preemptible() is
not needed.

No functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
This came up in review of the copy_mc_highpages() series [1]. Pedro
pointed out that most architecture run with full or lazy preempt, so mm
does not need to check the preemption model at runtime or batch the copy
for cond_resched(), and a simple per-page fallback is enough for
non-preemptible models.
David suggested doing the same for the zeroing path, and this patch
does that.

[1] https://lore.kernel.org/all/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com 
---
Changes in v3:
- Use clear_user_highpage() in the per-page loop (Pedro).
- rebase on mm/core.git/for-next.
- Link to v2: https://lore.kernel.org/r/20261109-clear-pages-batch-v2-1-2e62c4f84f94@amd.com

Changes in v2:
- Rebased on mm/linux.git/for-next, and drop RFC tag.
- Link to v1: https://lore.kernel.org/r/20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com
---
 include/linux/mm.h | 28 +---------------------------
 mm/memory.c        | 29 ++++++++++++++++-------------
 2 files changed, 17 insertions(+), 40 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e6da76fbe8e8..8d14e45fcf24 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5250,7 +5250,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
  *
  * When running under preemptible models this is not a problem. Under
  * cooperatively scheduled models, however, the caller is expected to
- * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
+ * clear one page at a time and call cond_resched() in between.
  */
 static inline void clear_pages(void *addr, unsigned int npages)
 {
@@ -5261,32 +5261,6 @@ static inline void clear_pages(void *addr, unsigned int npages)
 }
 #endif
 
-#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
-#ifdef clear_pages
-/*
- * The architecture defines clear_pages(), and we assume that it is
- * generally "fast". So choose a batch size large enough to allow the processor
- * headroom for optimizing the operation and yet small enough that we see
- * reasonable preemption latency for when this optimization is not possible
- * (ex. slow microarchitectures, memory bandwidth saturation.)
- *
- * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
- * result in worst case preemption latency of around 3ms when clearing pages.
- *
- * (See comment above clear_pages() for why preemption latency is a concern
- * here.)
- */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
-#else /* !clear_pages */
-/*
- * The architecture does not provide a clear_pages() implementation. Assume
- * that clear_page() -- which clear_pages() will fallback to -- is relatively
- * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
- */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
-#endif
-#endif
-
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
diff --git a/mm/memory.c b/mm/memory.c
index c9d64170e47a..fcc7ea2a00d1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7650,27 +7650,30 @@ static inline int process_huge_page(
 }
 
 static void clear_contig_highpages(struct page *page, unsigned long addr,
-				   unsigned int nr_pages)
+		unsigned int nr_pages)
 {
-	unsigned int i, count;
+	unsigned int i;
+
+	might_sleep();
+
 	/*
 	 * When clearing we want to operate on the largest extent possible to
 	 * allow for architecture specific extent based optimizations.
 	 *
-	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
-	 * clear_pages()), do not call cond_resched(), limit the unit size when
-	 * running under non-preemptible scheduling models.
+	 * clear_user_highpages() (and primitives clear_user_pages(),
+	 * clear_pages()) do not call cond_resched(). That is fine on
+	 * preemptible kernels, where the scheduler can preempt the clearing
+	 * at any point, so clear the whole range at once. Otherwise, clear
+	 * one page at a time and reschedule in between.
 	 */
-	const unsigned int unit = preempt_model_preemptible() ?
-				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
-
-	might_sleep();
+	if (IS_ENABLED(CONFIG_PREEMPTION)) {
+		clear_user_highpages(page, addr, nr_pages);
+		return;
+	}
 
-	for (i = 0; i < nr_pages; i += count) {
+	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
-
-		count = min(unit, nr_pages - i);
-		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
+		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
 	}
 }
 

---
base-commit: 2683df3b7eac1d91380194955ad0c9751454610c
change-id: 20261021-clear-pages-batch-77f72ef808e4

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


