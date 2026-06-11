Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C187CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08ABD6B009F; Thu, 11 Jun 2026 09:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0622E6B00A0; Thu, 11 Jun 2026 09:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93C96B00A1; Thu, 11 Jun 2026 09:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6A2C6B009F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:06:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3DA7140603
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:28 +0000 (UTC)
X-FDA: 84867655656.20.DD6E3DC
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 765FF20012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GMLgGNHe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.49 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781183185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJB722PaypzRvTXm5hm48EyoMXKjFx1PJFLvryrUZto=;
	b=gUQaEiE2dULqLf+9VPbxKUaYC5ITkl/z+yGzbgNdm/KhKNRqcZMBShasUNO3TrUA/bQLGt
	Pulgj7sRmVEipPOsW2LFhVw5AMr+U0fCx4Zq7Im+wXkZ53JQGSrbV7yEfADMVba7v/r/D5
	6dtX4+50D4sbINgL2YtYVZS5Z4BOlx0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GMLgGNHe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.49 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781183185;
	b=u5xkf7slDjd2QorXl6UGmTQB1CSsKKw/8vsXavmK8IW/1m/GrZn/q8kwTC3Jgxnoe9Yg3O
	DM1M0Sd7bRQya6qxAAdUGdcGCXqDwl8EXuIgSyDmealiZFNiofgq4JV9ToCYKfGI3ylnWy
	SRIJZm67KLy+gPddCsHUeIVD8ViMbZE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uq+nrUXvEUpq5/Je93G8OlF23ArfQOmUHB4qRLyozlyW5tcbmggWTotIMVdbJyr/5Khz2bybe5cRt9da/yNaGH0Hyheb5J0n3WKHFIAggjUblfe1MvRtfmjN9zTP+R/PyaznrsNgFFpj5MACcA3ecf2kIOhyFLLsdCB+da3IqwnBr2fPOlKAsvlZOu3XlrhN50Br6++og79G3iqyxwtKjbuyPUOJD8yZMQ6BW3i8AAkOyAb3+K8tUXGFQMnKPOjO8R5/gyrZ38D6rHDaRt416n0rkAX5ZggXinW92UD0tiep/koYG6KMMVyqyASpEySLIYfRu5QvLoFHXgH59UMOPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJB722PaypzRvTXm5hm48EyoMXKjFx1PJFLvryrUZto=;
 b=ri+3k8+PeiwGc5K4pFRxIPYIcxPAUBIoHjKjjw5oWI7WxH+y6eNqRGeNlGeifAZQW+qq7jFve4T8RLhsg7Ka1fxbFJa1K40/EtOL1KCySojNV06rSl5oL2OmABh2qv3FNwGnC6Wj2MuObgCfZSpAWNfqt4nBQTtryufs8GLTubnyw+Ox7/r/OEM1R/w/h9t+4BJ5IMZBJKvQxsAFTa4wDwldGsK4sEwb8zLeSme2Q2X0MBeEGsPZ/wnw1g9GqgHhEob3Ux+tN1iDjadnuUL+xjW7oBGNwRo0VVKlxs30LNElQCE/1+p8XaMy72Mkit0Di7lUJGYFswimIO9vXYsMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJB722PaypzRvTXm5hm48EyoMXKjFx1PJFLvryrUZto=;
 b=GMLgGNHetTzY7ucfi1Q7WocfwPBLWmHreZ4jQeSAswPhKafNN+LAbOabdgtMOKUJGJ56+FMFVTLFAtbNRmoOL5OAV4lNUu63gTn3PNjvgkdY3Qcmg2UprAUGHXe7S27gKKCySxKU04TvlJi/NR6hNaqeQyCrPqUcAg1ibRY2Rgk=
Received: from SJ0PR03CA0296.namprd03.prod.outlook.com (2603:10b6:a03:39e::31)
 by PH8PR12MB8605.namprd12.prod.outlook.com (2603:10b6:510:1cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 13:06:15 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::9e) by SJ0PR03CA0296.outlook.office365.com
 (2603:10b6:a03:39e::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.13 via Frontend Transport; Thu,
 11 Jun 2026 13:06:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Thu, 11 Jun 2026 13:06:15 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 08:06:15 -0500
Received: from [127.0.1.1] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 06:06:06 -0700
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 11 Jun 2026 13:05:08 +0000
Subject: [PATCH RFC 1/3] mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260611-shivank-gmem-migrate-v1-1-2d266bfc6f95@amd.com>
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
In-Reply-To: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Chao Peng
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, Ira Weiny
	<ira.weiny@intel.com>, Michael Roth <michael.roth@amd.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Ackerley Tng <ackerleytng@google.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781183157; l=6346;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=2ltH2VfmfecXarnyIZ1h7eQNXMTYMXLNz0JRmU1moAA=;
 b=eqEoVL1LBPcb978R7d7shJhAdTmsmHaQr7Z4KaeJNxk8rQlICSxriWLaRb26almAeYQhX14cC
 64T4aPVHTa7BHQ5mWDfZ0bV5NZPtdJupNAhq3yRTV7r71P4/MgrzawN
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|PH8PR12MB8605:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc8170b-f296-471e-2b2d-08dec7ba3836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|1800799024|36860700016|921020|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1CeEF1l7CVXVHhkVEyWWq21kIViFLCaRderjD/pJu/L7qwT5PF3l0swIPzTfqKyJXs++UpVF/mj2grB2qrREam9y5LP7XLWkD0Qjl3NOU3bz3hjVYzksVikr4TSZ1fnZWCEmDOPrv/ZGFE+Z2R0sCTAcjnNL7+iv0GNKOdjZs2Lln5Z6IDcD0Qh+MNDaNobGdxdpZu3lLvUZU/gNFsAFMO1nzSZKhLcvdSn1h5u8hKTm+j8EEej6g4U6uXwBgnbQ0OuckwMoGVke30mo2VTnCm8IUFb1cco78XClnqylZUp11x+8TkqStyU0HBPsLtgqzZVuhcuyXKH0a+81bIZQ8/KlUlO9fxV6L0OWU6gH4sOILFu4LbbTNwf9GVq+XHq16xsx0QIDxl7MHz3Ha8rR+z2EjKb6pEorgRTKA2a2xju9qFm3Z7PLUZh9r27P34S5X4RnOi5nugZnzD+2CSdIVfrer1gBMf8QbdEiFBPUzuZKMX3mOQKJDPvMvQ/Eu8Z/oZ+qHxwETANcgt6gpZA62jhd7iHhDe5FkbEWlm5ZmodVwwav+JMsnWY+IsbE5n1mRCpzVdfD2jZcQoh69fp0gRpv6mKm8/fDqxA6Gw52xyZuZzabHjepmk6nWexEIl4g/kIitU1vCzDOQ4zpdckdzd1wsII2vKPRHWHPXAosK7LVfPnH3W5gy7KoVH2GklESI6EhNa8xo2lZ/6rCcR41IdbD5eM11T68D/ivcNgHs1kpqLKwoDRj4xN5usSSpd7vAnAjV7iA2mLFneopTfSukw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(1800799024)(36860700016)(921020)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wly1TKdTbVlwGFwOTzJZQFjQaZkCF6NLchRkqTku29XBoNt2tXhchRnXolLn0/7SGqCIMvN2KxhDsAnzaBhTN/ue4wU9SH+3J3sNaKRdoWNtz22O/JoDfcyOFqtSU3w5oeIxYuiaBWcnXGCdxDxPAliKTG6HBoWSNkQGkWyUIkYafg1jobBSdLSdlCUcKijrXPzeKp/B/Kk9FDglHrQgaIQkm2oJqMy+epBlT1TYsQNNteAV1blY5pPzkj/GCuIBVhffIBL5umoTiBEXtBqEW/BUQV/lMPg7y7d21V8ea+CM0Dig8rpPFOlL7jwFg/fUoPe7TU7bRfP9tO3P+M2HcS09BYLWa8eUCSVvBQDlg1KA0e6V2NeP1OpXvJA6LzAf0H3WEfIml7eFvWfnCUGkjuUN0FjwA99m40gHjoxaSYKDxKmnFh0jxfIg6BLMyf5W
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 13:06:15.2994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc8170b-f296-471e-2b2d-08dec7ba3836
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8605
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 765FF20012
X-Stat-Signature: b5kg19p8h9nx5goqsspimiyti3ghi3cz
X-Rspam-User: 
X-HE-Tag: 1781183185-363270
X-HE-Meta: U2FsdGVkX193NR614U5rgwkSNGb53K4Zhx3FY1NycP4trRgNrZQr0+AQMNFDmfdZeyz4vOZ6oY9NjlzwTFc7P8svHhmpEMPI6SVznPn5viXPZH6mZYMLJ1GTjBcrfzmPJbcILeazsOEVaZ1TWUHvkn2/ZY/N3lxqNOukkyZYv/9q+7xft2LrEAcNui2eZoWmGy7S36ZCmipLLUYUv13i3H6AFqCd2EePuzOp7mvf3CFJncDBK9yBNUenHPOZ5MFEU1CKz4cWP+9Q2xolykxgu6p+N9WK/LuTPz5Qb+qM57CJYPG+LxIvKxRty6J8Hd+yrQTnd0YoSyTQu0q5NrmqEGjMNC7SztG8Lm+0yJEi1+jGnDFbY+ePSIutMARoNP+YNjDImVnpMN+qT6yY3UeymRo9dH1IKmXXT5+rJpnPCIxUmicIBIewvM3mNU7snY2uo5FzUgXcpOSpV9wrzb451G14IzxGDOs2g+NsZxst0PHGXTC0pnHBZn4LVB/n7RUkpAs4rLhFC0iAPW9Sbl2ICXvCWs27kHTIRGXDo4oGyfKWYIe9DwsWfHYpBD5ntZQHqt6aVfTJOG2tALcBmgsL2qKhQuDz5Rw4PbbdmbjhkXBPdHdjSfyr16K+G3R4V6Ukp8OgSipGup4Lzvb8rQ+eefjfk6l/ogrX6ITsnVMumizAHoxFnrtrhaa/DlB8dc/HLV+mealfEf0bChC24uqk1ogWg7G9ZDLm4YkY8GJ7QvCPz/WyNy55GJcB3iEiCufyphRRFAKPD93T4t+Qjzu/jRcH9xqWW7IiX9Vp/ZKc6KF7Me7GtY/Tc5JzhVV8CBuKKzXw3JxXEz8B4PLk8azNoDUhKTVsPyJMdJVWFtLxDz4OUtWIu0bspD2U483Ljk69THWziTPHlJ+CHCp4YDY56+EWtfo9VfzOdntS2ZsBmB6Z09azPc+FOpY8401oHcJcMgV5DK54K7MMLyUXAzz
 5rRhUtpr
 e4s1CBukG/C2ojNpA+URs6jrL7G3dZXxCveEYpYrVndDLpUxiq5EskyF0utgs81zuJWyMM/sRNWfCQyRA4/tD6Gal6ajCYQnGZxPLYQK/ltRRq0CKWP4leVtH/eHcfLv10CB0br9bxQv4w47QCRfKU/5tHMJndR2BvQ79j3HlBgRBAIfL52zdyg/UExKKSQc1wGwhXasJ/L6WEKScQSA99PGFZaRtd3/I9SNnaX5778pZYFD7CZpDTBI2FdIO3LDgxuv6OFdqTe9dPzA1yYaHxsZ5mG9cf48u29Y3cEQcM3Yu54NAZlXqX2ZGlEiwJYPF4+oVGYW3rRQFIODDpDVMM0MaCjnvkaa+iXgKhKMht2ERFcfgNU5iE2rbXZu2b19NVyK6jCxWeca4DxoU+/5Q30NPN5is7ZEGaH7fUjY6XQHafA6FLOgFjxM0z97n0sAwRV1MrOtXUGtr5OFzRvfa8aJtEkmwM5LEY8m/tdqsVEJBm+CfnpltduvVeSC6Dpd3lvViiR4/AjNFHg8wlFqIM0ZslGpckndvj41TnIguc8taV7x6MpaaH4QMGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 27e6a24a4cf3 ("mm, virt: merge AS_UNMOVABLE and AS_INACCESSIBLE")
folded the two flags into one, on the grounds that guest_memfd was the
only user and always set both. But the two flags were added for
different reasons and guard different things:

  AS_UNMOVABLE (0003e2a41468) marks a mapping whose folios cannot be
  migrated.

  AS_INACCESSIBLE (c72ceafbd12c) marks a mapping whose contents must
  not be directly R/W accessed. Its only job is to stop
  truncate_inode_partial_folio() from zeroing the folio.

The merge assumed unmovable and inaccessible were the same thing.
This cannot express a mapping that is inaccessible yet still movable,
which is exactly what guest_memfd wants.

Reintroduce AS_UNMOVABLE and restore the original split: truncate keeps
checking AS_INACCESSIBLE, while migration and compaction go back to
checking AS_UNMOVABLE.

Currently guest_memfd sets both, so the resulting flags and behaviour
are unchanged. Preparatory change to support folio migration for
non-confidential guest_memfd VMs.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pagemap.h | 24 ++++++++++++++++++++----
 mm/compaction.c         | 12 ++++++------
 mm/migrate.c            |  2 +-
 virt/kvm/guest_memfd.c  |  1 +
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9d9850d37185418349b89e6efe420..17f5abfa6e7be97c0dcb634346f21ce076798495 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_UNMOVABLE = 11,	/* The mapping cannot be moved, ever */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -322,11 +323,10 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
 static inline void mapping_set_inaccessible(struct address_space *mapping)
 {
 	/*
-	 * It's expected inaccessible mappings are also unevictable. Compaction
-	 * migrate scanner (isolate_migratepages_block()) relies on this to
-	 * reduce page locking.
+	 * The mapping's contents must not be accessed by the CPU through
+	 * the kernel direct map or other internal paths (e.g. zeroing of
+	 * pages during truncation).
 	 */
-	set_bit(AS_UNEVICTABLE, &mapping->flags);
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
@@ -335,6 +335,22 @@ static inline bool mapping_inaccessible(const struct address_space *mapping)
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
+static inline void mapping_set_unmovable(struct address_space *mapping)
+{
+	/*
+	 * It's expected unmovable mappings are also unevictable. Compaction
+	 * migrate scanner (isolate_migratepages_block()) relies on this to
+	 * reduce page locking.
+	 */
+	set_bit(AS_UNEVICTABLE, &mapping->flags);
+	set_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
+static inline bool mapping_unmovable(const struct address_space *mapping)
+{
+	return test_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
 static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
 {
 	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
diff --git a/mm/compaction.c b/mm/compaction.c
index 3648ce22c80728b894cffce502d8caa3e4532406..8262f08c01ff407eff8732ffe1d0eb4de469eaf2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1133,22 +1133,22 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
 		    (mapping && is_unevictable)) {
 			bool migrate_dirty = true;
-			bool is_inaccessible;
+			bool is_unmovable;
 
 			/*
 			 * Only folios without mappings or that have
 			 * a ->migrate_folio callback are possible to migrate
 			 * without blocking.
 			 *
-			 * Folios from inaccessible mappings are not migratable.
+			 * Folios from unmovable mappings are not migratable.
 			 *
 			 * However, we can be racing with truncation, which can
 			 * free the mapping that we need to check. Truncation
 			 * holds the folio lock until after the folio is removed
 			 * from the page so holding it ourselves is sufficient.
 			 *
-			 * To avoid locking the folio just to check inaccessible,
-			 * assume every inaccessible folio is also unevictable,
+			 * To avoid locking the folio just to check unmovable,
+			 * assume every unmovable folio is also unevictable,
 			 * which is a cheaper test.  If our assumption goes
 			 * wrong, it's not a correctness bug, just potentially
 			 * wasted cycles.
@@ -1161,9 +1161,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				migrate_dirty = !mapping ||
 						mapping->a_ops->migrate_folio;
 			}
-			is_inaccessible = mapping && mapping_inaccessible(mapping);
+			is_unmovable = mapping && mapping_unmovable(mapping);
 			folio_unlock(folio);
-			if (!migrate_dirty || is_inaccessible)
+			if (!migrate_dirty || is_unmovable)
 				goto isolate_fail_put;
 		}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b44c401e1e0356bf39588e7b5d7b0d..c81b3900b5afd150681d973484e71982a8936221 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1100,7 +1100,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 	if (!mapping)
 		rc = migrate_folio(mapping, dst, src, mode);
-	else if (mapping_inaccessible(mapping))
+	else if (mapping_unmovable(mapping))
 		rc = -EOPNOTSUPP;
 	else if (mapping->a_ops->migrate_folio)
 		/*
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 69c9d6d546b287b4f75ef69868259c082ca50933..806a42f0e031a1c7729f53c786316d2502532553 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -592,6 +592,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_inaccessible(inode->i_mapping);
+	mapping_set_unmovable(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 

-- 
2.43.0


