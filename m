Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3874ACA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB0290018C; Thu, 14 Aug 2025 11:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AC6900172; Thu, 14 Aug 2025 11:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A626990018C; Thu, 14 Aug 2025 11:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9031F900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:33:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B71883539
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:33:44 +0000 (UTC)
X-FDA: 83775757968.30.FD3C2D2
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C6D11A0006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:33:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qJDOxJhb;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.84 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185621; a=rsa-sha256;
	cv=pass;
	b=DdqQzVf+OVNIMJGK3Oy99TjMyyCVoqxIDX8b7wIASaGgCXRjVbaGvToyYbjghFdyw2oxhc
	534BXXPT6F2ZVAWXS7MfMNhUlUlZhhiMQ/aBLCYYtIstgblarQ51Gbjl0pHi+zHI6kfodT
	qhpWzSzoYzfSfbZbn4FiKMaAddAmP18=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qJDOxJhb;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.84 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JGE2DJS2OcZ1YYW2CRsS8unO2SfFvd01Lvw9o6ftf1c=;
	b=UUO7AFQ3MJvQJosNeFprMYtzVRDADityrQEK6lwtQTIkN+7oaQtKTjcMcsbPZNTOp1OvpY
	X7u/x4yitqkQJB+hfT3ZH1+ew59VLaPDb6uMuk2aUN9btFwF/CFbvAJPKK00z4sI6z+3N1
	tXfus8fnR3OpkOQ5RTVY1SHpBIiCBUM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nc7l5OW56vUVmKcu0yLN2yBWSF1SBx/HdjxKFb6R9JUfVq/tWv1hn4wfz6do2hB3bWKuTQecULITWsWSWUrYZ0A9lDYH+VZZ8vT8upoHfPsVP7nOnnthUyUfAyBvKle0qnhELeZNYLyH7c2udS3/KOS9mt/1FKND00Xsjw37terfCFrsI1RvEu6L3k6VZ4bga4cIR0oJ91VUHq+2NUQ99PRDzclNgLmgR598b+6FuF2zPZ92A0HdI958q4VACwweVu/bXp8GuW0pGkr4wyGPEhNsAHvuZ7Guk2n34kLNdnzk7LuSDhvk0ZgPkh8ItkokbjLmjO3fRdiOsgjNy7jvVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGE2DJS2OcZ1YYW2CRsS8unO2SfFvd01Lvw9o6ftf1c=;
 b=PtKZHhcZVlCDM8q/bbR1/inFiLq+B9YRrv1934D43OpppUadKO4xojHDtLocvxvL+EDqCynBF35sr1S7k500GPaSf4jnjZyqLVg/x5UhJsvRaC1GZBu/T1eiNaz2irYfzKtfl/fl+Xc60knaJ9rFzQHHNQuwSebI3zWvhFyb6tG3/U64VUvvs52xrRyCdljwI10oC9RZPnxbRLNUJXb1AvHiulFi7QYoXLUnIVmKIFHLMJlCEKPE1/REglnK9kUV9Mi4nnXVrOGNp1e4d0cAqOHcCO0H9ncfyhKSzMCP5OESKHQv0OsdCbfPeOz22m4Uts56rsU4rxyfL8JjK9axIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGE2DJS2OcZ1YYW2CRsS8unO2SfFvd01Lvw9o6ftf1c=;
 b=qJDOxJhbo3uCtFq82KJ5aIf/gsPBzCBVoJ83pfMsE1ObcW6dWn5IXv5nZBzbqgPUO16uaTvQ9fpGNa76lUHsFRLbHYLkmNT9Asu/68KIeKHcHXaZsf7TvOD9ZfpFOKDdHkajTgHVcVI3QS5cLbWtt3mevbj6aJ95jd/BC/wazc8=
Received: from BN9PR03CA0371.namprd03.prod.outlook.com (2603:10b6:408:f7::16)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 15:33:36 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::1f) by BN9PR03CA0371.outlook.office365.com
 (2603:10b6:408:f7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Thu,
 14 Aug 2025 15:33:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:33:36 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:33:21 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<yuanchu@google.com>, <kinseyho@google.com>, <hdanton@sina.com>,
	<harry.yoo@oracle.com>
Subject: [RFC PATCH V3 00/17] mm: slowtier page promotion based on PTE A bit
Date: Thu, 14 Aug 2025 15:32:50 +0000
Message-ID: <20250814153307.1553061-1-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: cadffb43-47d0-4ca1-33d3-08dddb47ef8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VkHeIklZwQX+EdPcl9mGICTKACzpiCO9GiRHM9DCZTMXtQKq+PIiK9+CfX5K?=
 =?us-ascii?Q?eiiIZrIyX2F9lN+bDE9Abjuo2scKPV9RBHNYzowEBrtAbk+GcDnS5hU6n0zI?=
 =?us-ascii?Q?EsQtOQk2vybGAiepaZ6cLTzWHgQSxid85w+oNENupnFZMLXUjkW7t0AQ9hs+?=
 =?us-ascii?Q?h3UyE3mwhLV3SQOBkIVFJ+ObJDdCyoCmKQv0D8rgv1fCZGR+mP231BmiocEm?=
 =?us-ascii?Q?ECVQuOTy4loQpch+ZTTjqb+DOUe1MGhKaHqWuGdkWt4AbanhqEAbDgYlKga9?=
 =?us-ascii?Q?VyZ90MlpRrrKpsaiHAF3JWPpOVbA7rDYWzP3FAVTZPvlRTsV/Q2IAhVEPMic?=
 =?us-ascii?Q?4PX8M98ZzY2jIgysW1rC/VE/e4sLC8F/hIfbRs5LDWy/sIW839ycitbfpsOl?=
 =?us-ascii?Q?cpir2/2f8YzB2pFrTrb1Kf4hzOTYtyl/0HVhpobXMmlVkAyW0/Mfm2dNbWvb?=
 =?us-ascii?Q?vEIizYlBYA6WAzsYd6Uj7j3GFEK60hZmBdZqSrySQC3E61Hlk0LUug2eqzao?=
 =?us-ascii?Q?/Iq02dhXFFAJ1fIiprlY56cnui1pN1/bANGMzSCAiiy2tskbgzdS/HgyHfXp?=
 =?us-ascii?Q?p60odAXjhy/k9RZQtyie5bsKYAMBjrFdDReM+QFSsO96yGhYW9Mh0ybslTYi?=
 =?us-ascii?Q?tMufN6K/x3kWJaVkPGBTDmiQhHnGLYA4x1eLA+Y/I4tLHlq4jXFZVWMYn7i+?=
 =?us-ascii?Q?B14akXEVFAbM63hapZMhn282B3/Y7SIy8Sk+HTvKoiU50EoZNR+/oj1uBku4?=
 =?us-ascii?Q?nE5APMv+fqqU1QVqKHubrYgLc74Jk/FA6VbCrNlJ8pG/qYzgPN92F2eBNZms?=
 =?us-ascii?Q?qBAVUPTsuURA+LfN6bDyr5aV8N6sJLItwEmJzShmRQDRSN5zyUW8XmSaZMAS?=
 =?us-ascii?Q?YtAe3ip+I2cRYGrc0INoIu4wIrkKdbwEpxtnnk7tyxz8rkxGMfjQjTs1XJg/?=
 =?us-ascii?Q?Gw9eBjc7SIXKZA+Xdl0zGyVeJsXm2q17IvYwJR1SUgHpp/xYRrEPjgT3u3WR?=
 =?us-ascii?Q?w6whIPxMoFBSqbWJH4rtj+Pv55QmYFJd/6N8FlYprFfEyW3Eo3t/b1Q9E6cK?=
 =?us-ascii?Q?aefHUUAc+sdTG0liHevMekpxmUps25wuQ3ZLmWwstZT1bFIBdHZxO88if2g5?=
 =?us-ascii?Q?yePaS0xkaqYH0KtrvXtNNOLBalYm83i7alUMk3QNrTAxRmoWzdNRYCT5z8Ya?=
 =?us-ascii?Q?yAV6kJFyMYCRu6Qjg1jEEkO6WD7LPJ534e2pjE0PKNchHA833zsmPJIAPWFL?=
 =?us-ascii?Q?66kzysHhhtw+5pkWu/gpsOEMvjND58WbN3yNsyUy8k2HdfMl6kL4T4no5QnA?=
 =?us-ascii?Q?DPmfVCWpAlUf5YWC0A2r1xd7ObVh5c1lEGahsl4gBqVSMFyCMHgd6uA0pY33?=
 =?us-ascii?Q?VP5rIV9uwEgMM+68oN3obVcc00QT9o1bglOcIoia8xMc7euyqoGSJfXZmtyV?=
 =?us-ascii?Q?/bgVwqjQg71EDJ8b+AFNb0WOSW6tE43eA1YUeIneY5unUJi33o/T7g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:33:36.4215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cadffb43-47d0-4ca1-33d3-08dddb47ef8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C6D11A0006
X-Stat-Signature: jbxdorhzr6upj4q56ss719bktttdq6zs
X-HE-Tag: 1755185621-247125
X-HE-Meta: U2FsdGVkX1+u6OvCboxbwZa455hb7QrtFHfjy+8V5kChTkgDDJ6fhzpn2VTLMtjL8jDXaTa6D4eMIZexbRJJC6AI4uwTcB7M+26w04stoZQ3ZNvOVw36deeEyOwaTiPEvahlQxtO/sVINKlpwiST3mJILIHRFnazqeRPZ253UhWYtwxvZbfgafrtJeSGZwMP7gsrJ/WilpiIOIAHI+ziDSnqVJy1lGUZxEqb6An3rFggps52lK669ccsdmOCseNjvubpsjLGX3+UZvjQCmmHnmRb64Oqewh1q4y253R+U2upkHUazlrpITfcFaoFdpf3qBC1TiSt5Gf7obiIbdDQGAt5U+vPeZ9NbBA1uVTgPYdbYcJ1ZVJyqjhIjGWtfLLDMWh37M0llnutMN639kyqcfWeMBtOonZrlra2a+oMe8395mKKrHXpdls1B/3C74NLGU+l6TS36ZOZjvDpjKj3yjkjLd2tBSE/RBX5PhGHKDzDw4BRPnNvQvlD2Cw/GugK31mrd5dDAM3/qDaoE3wxWiTHZ6PPkUMmh+LWONbLPXYE96cvdqk9Qe2fOwQefq4p89aLWMGe0gA9gjuZ5542K802EPy+Z49V8SXVNCmnYc/vZ9rHjOAq2LB18Wd5OPt8bFMqhFbfEz6+XYRrCabjGwKni9fEpMIbpc7xrOyjYxlgyb0ulyi+b8ilj0svykS7QWa+GXs7/NobdVz4RWUleJRd9GsVRUNnSU26HWsdLT3AteP4LXtYf9ayfhbfgyKNzza4v1qj6AS7s2xN+6f5l+9TW0JZIvCuPOlpl8MzBzBX2hCrV+uJWJWuOsVIG92YP3EJiU5wIE9h/BXg7CTwSs0nwlxEwErnwk2Fp71JBvGiD2hfaEat9/wjoGtsC6b+h0tr3wH8nKGkOrCZ/dPwV/kXYK3GZXjXaQ0GIGuETgoku0DwYuyFq2vHWxkiqUXUX+nqlGKgHbvKCdr4wO9
 do4YLtnh
 mGpsBxXXVkwtMHcqwEK+bFcgflmMo1/hxHS3/J237Kp45v78DRTZGum0iSAprooiVnDC8cWn/6mlxoYSP8dz9u+xoV4/sKyMP1/xo0r5DYNHyVQmSoSZpdaCRGrWsHTu4ORfB1Qz8/iDMi1sL6xH9O7UvumnG+VF4IXKmQCd+BtmkrhjUyDZBlGZLSnITDsj3/szU/hYrqykmHeZ+m3IdIEI1LegqZuwsna1moGjYviztHP4Vkti7g2QmTkOBd6GLr3jI64ly4qIPBbzRURVqVVvaMnQOK4dGwqOHyysUZXFlE37EO06XRTKQNzVHlwg+ZGsbOfHlZpgHj/CrCndUdNt9f7pfiQuF5bZIMhPY6KlNj6OWlxTBG2RSyjouXa+u0Fu1CCiySc6jOIyY29J9/Wt/v+qA8sjDbsSPBItbuPXQE4ktEtSIH3cyjFiRLtEj1jouS0ktE2OqWv3jSEvKq6T9V7B9zLYH6WKdDMePc9FwoZoLENbiAyPTTcZh3nbfTWyNVX0CCnIGM689TZj1krgfrKbfnO3cGjQv1o5bJBJLX6nYRA5+TyfaYAFb4am5jh57oQsXzAzEvP6EOATQO5xmVJiEHlDHpwV7S4WET/wFviDgTrhL+5ak/HPAFzIM8c0gMwakvFjdAywyIDNR47lla3ioA8yOqPHJ0C87wxVcWWfp2ajw924XyIhq01hMytvhFjvMjxzzJB2NnzX1oNgxE4oWvSn5yQOpvBTRAPow5OgX+lKKYqmu+fJ2Bu8o7Rx/AlJxpY4dod/o9Wsftl1v4MmcdmSomL6Z+n+lCpbPq1LTQXdidNT8rzyt0JqkJdcbX6LVGRB7p4sAHqdgGTBxgZxkEkJZww97aZY7rl2JzA8DsEHBlbj8Wlj4fGxkwHVDuw3tGk0LRr7ZYeI+AbuZsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current series has additional enhancements and comments' incorporation on top of
RFC V2.

This is an additional source of hot page generator to NUMAB, IBS [4], KMGLRUD [5].

Introduction:
=============
In the current hot page promotion, all the activities including the
process address space scanning, NUMA hint fault handling and page
migration is performed in the process context. i.e., scanning overhead is
borne by applications.

This RFC V2 patch series does slow-tier page promotion by using PTE Accessed
bit scanning. Scanning is done by a global kernel thread which routinely
scans all the processes' address spaces and checks for accesses by reading
the PTE A bit.

A separate migration thread migrates/promotes the pages to the top-tier
node based on a simple heuristic that uses top-tier scan/access information
of the mm.

Additionally based on the feedback, a prctl knob with a scalar value is
provided to control per task scanning.

Changes Since RFC V2:
===================
 - Enhanced logic to migrate on second access.

 - Using prctl scalar value to further tune the scanning efficiency.

 - Using of PFN instead of folio to record hot pages for easy integration
with kpromoted/kmigrated [4].

 - Rebasing on top of fork/exec changes in v6.16.

 - Revisiting mm_walk logic and folio validation based on Harry's comments.

 - Feedback from migration system to slowdown scanning when more migration failures
 happen.

 - Masami's comment on trace patch.

 - Bug fix to overnight idle system  crash due to incorrect kmemcache usage.

 - Enhanced target node finding logic to further obtain fallback nodes to migrate.
(TBD: This needs followup patch that actually does migration to fallback target nodes)

Changes since RFC V1:
=====================
- Addressing the review comments by Jonathan (Thank you for your closer
 reviews).

- Per mm migration list with separate lock to resolve race conditions/softlockups
reported by Davidlohr.

- Add one more filter before migration for LRU_GEN case to check whether
 folio is still hot.

- Rename kmmscand ==> kscand kmmmigrated ==> kmigrated (hopefully this
 gets merged into Bharat's upcoming migration thread)

Changes since RFC V0:
======================
- A separate migration thread is used for migration, thus alleviating need for
  multi-threaded scanning (at least as per tracing).

- A simple heuristic for target node calculation is added.

- prctl (David R) interface with scalar value is added to control per task scanning.

- Steve's comment on tracing incorporated.

- Davidlohr's reported bugfix.

- Initial scan delay similar to NUMAB1 mode added.

- Got rid of migration lock during mm_walk.

A note on per mm migration list using mm_slot:
=============================================
Using per mm migration list (mm_slot) has helped to reduce contention
 and thus easing mm teardown during process exit.

It also helps to tie PFN/folio with mm to make heuristics work better
 and further it would help to throttle migration per mm (OR process) (TBD).

A note on PTE A bit scanning:
============================
Major positive: Current patchset is able to cover all the process address
 space scanning effectively with simple algorithms to tune scan_size and
 scan_period.

Thanks to Jonathan, Davidlohr, David, Harry, Masami Steve for review feedback on RFCs.

Future plans:
================
Evaluate how integration with hotness monitoring subsystem works, OR
as a standalone integration with kmigrated API* of [4]

Results:
=======
Benchmark Cbench (by Bharata) to evaluate performance promotion in
slowtier system.

Benchmark allocates memory on both regular NUMA node and  slowtier node,
then does continuous access.
Goal: Finishing fixed numaber of access in less time

SUT: Genoa+ EPYC system

base 6.16 NUMAB2 (because this has the best perf)
patched 6.16 + current series

Time taken in sec (lower is better)
               base           patched
8GB            228            206
32GB           547            534
128GB          1100           920

Links:
[1] RFC V0: https://lore.kernel.org/all/20241201153818.2633616-1-raghavendra.kt@amd.com/
[2] RFC V1: https://lore.kernel.org/linux-mm/20250319193028.29514-1-raghavendra.kt@amd.com/
[3] RFC V2: https://lore.kernel.org/linux-mm/20250624055617.1291159-1-raghavendra.kt@amd.com/
[4] Hotpage detection and promotion: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/T/#t
[5] MGLRU: https://lkml.org/lkml/2025/3/24/1458

Patch organization:
patch 1-5 initial skeleton for scanning and migration
patch 6: migration
patch 7-9: scanning optimizations
patch 10: target_node heuristic
patch 11: Migration failure feedback
patch 12-14: sysfs, vmstat and tracing
patch 15-16: prctl implementation and enhancements to scanning.
patch17: Fallback target node finding

Raghavendra K T (17):
  mm: Add kscand kthread for PTE A bit scan
  mm: Maintain mm_struct list in the system
  mm: Scan the mm and create a migration list
  mm/kscand: Add only hot pages to migration list
  mm: Create a separate kthread for migration
  mm/migration: migrate accessed folios to toptier node
  mm: Add throttling of mm scanning using scan_period
  mm: Add throttling of mm scanning using scan_size
  mm: Add initial scan delay
  mm: Add a heuristic to calculate target node
  mm/kscand: Implement migration failure feedback
  sysfs: Add sysfs support to tune scanning
  mm/vmstat: Add vmstat counters
  trace/kscand: Add tracing of scanning and migration
  prctl: Introduce new prctl to control scanning
  prctl: Fine tune scan_period with prctl scale param
  mm: Create a list of fallback target nodes

 Documentation/filesystems/proc.rst |    2 +
 fs/proc/task_mmu.c                 |    4 +
 include/linux/kscand.h             |   30 +
 include/linux/migrate.h            |    2 +
 include/linux/mm.h                 |   13 +
 include/linux/mm_types.h           |    7 +
 include/linux/vm_event_item.h      |   12 +
 include/trace/events/kmem.h        |   99 ++
 include/uapi/linux/prctl.h         |    7 +
 kernel/fork.c                      |    6 +
 kernel/sys.c                       |   25 +
 mm/Kconfig                         |    8 +
 mm/Makefile                        |    1 +
 mm/internal.h                      |    1 +
 mm/kscand.c                        | 1754 ++++++++++++++++++++++++++++
 mm/migrate.c                       |    2 +-
 mm/mmap.c                          |    2 +
 mm/vma_exec.c                      |    3 +
 mm/vmstat.c                        |   12 +
 19 files changed, 1989 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kscand.h
 create mode 100644 mm/kscand.c


base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.34.1


