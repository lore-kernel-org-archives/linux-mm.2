Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B9DC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2806B00CB; Wed,  2 Sep 2026 06:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572226B00CA; Wed,  2 Sep 2026 06:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370D06B00CB; Wed,  2 Sep 2026 06:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1CCC6B00C6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:54:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9061416018C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:54:44 +0000 (UTC)
X-FDA: 85168514088.11.9965225
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013066.outbound.protection.outlook.com [40.93.201.66])
	by imf16.hostedemail.com (Postfix) with ESMTP id EA265180003;
	Wed,  2 Sep 2026 10:54:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NTgjTX3D;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koojTOYdkiiZND7qr2ZlBjOYh7v1IXhkGuZoYr86pp4=;
	b=4LdRptSlsYUBAPIrSuODwVUQRpfeXosTOPEmQOrGZTGQKt4CU18SpzTe7MevK1j3VctZdC
	lQcOWQlEI3EmXwCBU3IfpAIUVsmnwbquJTtjqtcRfeXyXDnEFT1RNXt2nVotyX1U8pCOEe
	y08tQkaGzZDjqUVUkl7eXvUkrDzwUY8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NTgjTX3D;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788346481;
	b=71DQCldbw/JN8WgzqTF6BMfLCiOXtK+MKoc4nWgqeMEKdAEcUT196AYeT4NNiPkQEXILIF
	1HWWvAxxyXpONxWbATv8gpvhmc2e0FSYW15Pz+P5mvCUC10RjZkI8kDGgN8S11oPR9YtBt
	e58ErramjhBHnHdHz46hAJwHcTr94PU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rswb8q8M64YBiU0SUKi2xX3e/4/VCnN4Z0Z/SIaQk7GFH39L4LiLBjZCog7Ae6a8Pb2OmYnRYJdN95Qmqacl5Dw3ugcT2oiiHy8BAvhfIiBMrgCt0DMoqZfkw+hFwK6ED3skYji+X0bWFKslpM1D1FWA5u7H5jZYP3dlO4VphbESEfFg7cVaNXZsVSDStkQYnnnkKHaB1JdVi/0gotLDKFrDYHpORgOA16hgg3DpQmR/3yg8KuwC5yNHVInBom5DBXs7LPx96k9cYqrC7B2ckyxgoUUiCoj0/PvwCWNnenH59zx0TQWzURis1VDppQxsKqhSQ+T71BR5h4WjwaFT8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koojTOYdkiiZND7qr2ZlBjOYh7v1IXhkGuZoYr86pp4=;
 b=M1ZM5qbossP+fyLniezhWDswAJmnENeLbf8GLwPUaIvjvoEMG9wc+GmMI0/Bh4pydmR41WWWs0Yi6FrvjilBaGLl1q0WjzfdkyD0/bfjuhfwGXWjJpfrUCr1sMgKMSQI+JJF2BMqbjKhdanFPb+77aJDkaJjhM6py7Y5EHxInZGAFpM+DDYaN0Ml9EpkW3lWgFUuAV3TA0fBdCdR0soLiS6YZTyeazHSUVrR3CoakIt7jMZV/ZYzHtBh7AzATtdZX/wuR3MDAY75F5M8jW/kNGWJvMJHAVJkqKANj5nfC/RB48smrDXbVXrMHg4ED018WAABspy+vNA4a9ufw/PK+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koojTOYdkiiZND7qr2ZlBjOYh7v1IXhkGuZoYr86pp4=;
 b=NTgjTX3DYTbOYYAwbQGXuUhOUO4Lbrxcqq2wzR3ofTMU2xQOwPoOs9GJmHeJD0Ic3MQLuKzxhgwP54LhvD7BV6mFjUZwo1JIeqSLIDOabPsiVB7DHVyqcVtHSyLQaMHRif931dBG/Ry16eP8aGe2H5V8DSpSnT8zS1rk9xBFUfs=
Received: from BN0PR08CA0021.namprd08.prod.outlook.com (2603:10b6:408:142::16)
 by MW4PR12MB6681.namprd12.prod.outlook.com (2603:10b6:303:1e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Wed, 2 Sep
 2026 10:54:35 +0000
Received: from BN5PEPF00046987.namprd02.prod.outlook.com
 (2603:10b6:408:142:cafe::53) by BN0PR08CA0021.outlook.office365.com
 (2603:10b6:408:142::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Wed, 2
 Sep 2026 10:54:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN5PEPF00046987.mail.protection.outlook.com (10.167.245.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 10:54:34 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 05:54:20 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 2 Sep 2026 10:52:22 +0000
Subject: [PATCH RFC 08/11] mm/migrate: move LRU batching into
 migrate_lru_folios()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260902-migrate-refactor-shivank-v1-8-9dcca87669c4@amd.com>
References: <20260902-migrate-refactor-shivank-v1-0-9dcca87669c4@amd.com>
In-Reply-To: <20260902-migrate-refactor-shivank-v1-0-9dcca87669c4@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	"SJ Park" <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
	<jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Miaohe Lin
	<linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, "Oscar
 Salvador" <osalvador@suse.de>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Lorenzo Stoakes
	<ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
	Benjamin LaHaise <bcrl@kvack.org>, Chris Mason <clm@fb.com>, David Sterba
	<dsterba@suse.com>, Muchun Song <muchun.song@linux.dev>, Dave Kleikamp
	<shaggy@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
	<anna@kernel.org>, Mike Rapoport <rppt@kernel.org>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Bharata B Rao
	<bharata@amd.com>, David Rientjes <rientjes@google.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<damon@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-aio@kvack.org>, <linux-btrfs@vger.kernel.org>,
	<jfs-discussion@lists.sourceforge.net>, <linux-nfs@vger.kernel.org>,
	<kvm@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788346348; l=4077;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=DCCSRJxS6zqpx884DZJiD1RXEp4RSjaLXabCPBXH4QE=;
 b=iWZUKvsWOy8mQUDpMHuudCi9GxqEOGUHUA7WVUzj1iVzL/XrVKKYT2GjjYldTEEpf53g6YbXz
 f5aUiwYXYeKC7ybklBQTt7fsRz2v3IluZ+WW2obwJGeaMLJfE22F2c5
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF00046987:EE_|MW4PR12MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: cceebce7-d38e-4bdf-cc11-08df08e09334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|23010399003|36860700016|921020|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	arDuwY6bPoGJqo0qIUkcHZzlKvq9oyUL4748ZLkhmWhD4Rjel91CSjKLILfuaGz+/+VDmbI/z4FglllyBklOprQ5vLoX3GUhEfD4BQroV3pXeITlaIcrZhhP9dvweU0xWe7ooiNa15xBhRfrslJJPyCtAZkspFlrE97W8hDry54wsXrZhlv222J0E0AEAq45vROKlnFR5/0vHFJyegNI6vIn7NTMUEldizX7x17RuEv6TlDU1cjYfzpQrQUVgvIYH6kaLFlpvm05UberJlby1d5uYX/nqSQ2SzltK7pDavZ/U5a7JGQXyF8Wkj0KNHSxXiQ2P5bPxPABM+tWY57WksZFGN7cvL3zGTxSKZoQNtuspknNeWVRybg7knFdC9oxyE4H0MOKmLMwAEEU8B/lD0+pgw4+Bx+qVGEn2abrsXXta4b9PAMzWMwfIn7dg2MV0pKh7g617uGDZ4AW9NrQdfwwmlH7Eo5xndhYs/8J2xXu8baRk814xuYesvBXLHnrcwYKDpogB13X5lU7mK3SJ+GQJJh+NDmuWhFa2JdrRLjcd95FXSiH9XHKrwooMpMux7Pm/m+Qeh4psyCkxSon62S5V90ruEGVXKpLmvziXDRI0ylZ9jfXg9oQLFvMzVbyB9UkwO/JbK5nS4BlZDb7JHEP+9yqCcVKLypKn8HL4Of35rkOjgJGJlM+7KFbM7MOvQSRjtZyGFhNSPf1AQBXjgrNa2+HGPl6atnT5Uw0+Vmtfx/ZAbO8GPhcUxEHdASC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(23010399003)(36860700016)(921020)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HzTTJNBcFqq99LcVkpcumXu9lTQyo2VmchhFr2LSebVuDWLvEi0Tahx9dGrK9xeJdGQSkyGLoZ6XgqdiRq4wonTXBdbYyQtCfBGvc1cAs2mW4Lhn3Xa4L626GI4kud73jmONKb6qRgKTlWI7y7fm3InmFJRUSV99nKlS7u2yRO+A28HVUHw2mXv9csUpsRAi7eRcms+g5SBk+QTV1ULRlHTxKPYL+GS6kWft6RPizaQL3j9NM8JfvxY+EmvQLOkVfYOISb4862iXtgHnUHaCQFqwSU9oG3ncwLbjW0iCWJsY2N+N9rzvVV8zUveuqLE2q6YeGYVjo8xyZXxnX1xH5Z/0jGCe/y3YcpvK0tQ11OOQfXh0SSJRmq3yzL/8d39XvyUmNXpcJBIzwN4pnDCUu0uvax5py/dMhQibMo6n1XQS6RDuQI3GXfger0FwcJdC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 10:54:34.4883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cceebce7-d38e-4bdf-cc11-08df08e09334
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF00046987.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6681
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: knu9inxq7758bh6k9hxzr3djojdbjfcc
X-Rspamd-Queue-Id: EA265180003
X-HE-Tag: 1788346480-943393
X-HE-Meta: U2FsdGVkX1+VB32+AgRlwppDPpNCquT4ulRVaTUsKIiEgdIdUdQG5/8eWvbE1U7AxJwadIC0fiRzTdvaXTyVahecTlzXfcvzZ7u42AhAZXa9F3WPfJYZtmAdVhuEU1yCzt4pH95Ah7Ehg79lAGNE6sYytkGCad7dj9XDeTK5Es4fzK+QLoyps0asKE/NzwMCnVjZ4iTIMDfaL4i08gK1Fusn9LqY5KKLSMlP9hr3f28NbfTvSHV3rWMiKrWBb0AEPx8gb5i1n3llonNeu1v2aBhIE5WQOb+1VDMS7f8Ptr/EFr5QV02eOz+/idyuOU+fYpXclxmtcEDxD3Whj2R0j6NdHzweVexQdLnThd8XdLTaz+qM27mrP7Ky8FvkUOOfH8hIMrJz6hNXdLBDe6B6t3mRxjO1AFiqPBcp8rMiWqNT/9TNjHz4FDr7DnGoxYgL28juEvfryghiAIhZtinKdsvprKBEL5hWeJQt3PdK3jLVj9dQLKOTDy2LoPGfudKSujd4lBb7RvuQ/77mx8FdXCgU1I9cqJ/ozArWA2HwowmW+3i57YUQr6S1nvOp6lFix7Yyu7eHkEb+3uqCwV0gJJy9wrJxmH0LQ0F0d1weO2UiekfaE+dQhx31ryy3MHVicBrFs8As5TkFvQg+EbfX3GOZrk0pobrBZ+7eIwthX0D6UurTWgMit2CSKf1cR9K1Y9+byTlcM92BA5xfK7qDLsgEFZ1gwhHil4V0nH+M/p5AdNVzzzv+qfDrRWgo3gPp1DnnkdT+rgAp+mV8X1OUOLjW7AIbNl7LWz9SVAZgeDjVVkQCRf7xFn3+06iSOlYjPHj/34TaZg63RYsbx7hwMvh5QYK2ZjgbnH5xL4cMjlQeCDe8eNpC5cCYu7eX3phRhVKk57i9n2zfEd4hyhaI5DsqmLMev9BOXxNIZ3W6nd6QSdpo4ZbtMmRZL7DHfEHIfG+Xez/rS/SJZmXTc37
 6oP4T3Ch
 TXViVhoqF7RNwB/ivIEall2GBeyLXxAsQ7vKZL7XMHtkjSd/H4VXkPH8c6jw87Tiaqss5Ni191uapdTcKaLmXavozm9sZD8tZyjxhui3L6l1idmJrSGO4U9DQTqnAOktVVfttqlalVLqFgYcgMTmWNncErPh5Jv2z7IhCC/7xZNtJzso9U+Q3LA90qQMWf5IudnSwLVxV6AVdNBAUExp9YL7Iw7CRd6vpuV1Wdy958RbXT9HNqMA8nc7no3YqFFQIwTgUzRmsYi7DuOKzL8AaFg32nB9DGm3ufO+1ar966XX5BkBKdFACdiQjcXu5BIPHFdaHs6PvswRFjIglbdzHg/gKzNVFlVSNoKwTj9Rc3kBY/PJ1LcAO7YsK7aziiEZUVqy2ERwxGvbXKBqKJar6rE/nHrSzGj98VXr652Y6ncehYrr1rwmRVq/ouS2/ZEHDZWrUK08xCJReE8S2P4BybX7MUY0RD3HjA0ptVzlYkzDfeN+ZMmvIKO6lvd9owI9Itci3/6CUUPk/Oe8wy5UYwkhvCsyy0nOOmu4XGxRYtS1E3TD34mIV/ugRkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NR_MAX_BATCHED_MIGRATION limit is specific to LRU folio migration,
where the batch engine can keep multiple folios locked at once.

Move the batching loop into migrate_lru_folios() and rename the per-batch
worker to __migrate_lru_folios(). This leaves migrate_pages() responsible
only for dispatching the different migration classes.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 62 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d39149cbd43d..8914358cc434 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2183,11 +2183,11 @@ static int migrate_folios_batch(struct list_head *from,
 }
 
 /*
- * Migrate LRU folios.  MIGRATE_ASYNC processes a batch directly.  The
+ * Migrate one batch of LRU folios.  MIGRATE_ASYNC processes it directly.  The
  * other modes first make a short asynchronous pass, then retry each remaining
  * folio separately in the requested mode.
  */
-static int migrate_lru_folios(struct list_head *from, new_folio_t get_new_folio,
+static int __migrate_lru_folios(struct list_head *from, new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios,
@@ -2263,6 +2263,45 @@ static int migrate_lru_folios(struct list_head *from, new_folio_t get_new_folio,
 	return rc;
 }
 
+/*
+ * Migrate LRU folios.  The batch engine keeps every folio of a batch locked
+ * at once, so feed it at most NR_MAX_BATCHED_MIGRATION pages at a time
+ * rather than however many the caller supplied.
+ */
+static int migrate_lru_folios(struct list_head *from, new_folio_t get_new_folio,
+		free_folio_t put_new_folio, unsigned long private,
+		enum migrate_mode mode, enum migrate_reason reason,
+		struct list_head *ret_folios,
+		struct migrate_pages_stats *stats)
+{
+	struct folio *folio, *folio2;
+	int rc, nr_failed = 0;
+	int nr_pages;
+	LIST_HEAD(folios);
+
+	while (!list_empty(from)) {
+		nr_pages = 0;
+		list_for_each_entry_safe(folio, folio2, from, lru) {
+			nr_pages += folio_nr_pages(folio);
+			if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
+				break;
+		}
+		if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
+			list_cut_before(&folios, from, &folio2->lru);
+		else
+			list_splice_init(from, &folios);
+
+		rc = __migrate_lru_folios(&folios, get_new_folio, put_new_folio,
+				private, mode, reason, ret_folios, stats);
+		list_splice_tail_init(&folios, ret_folios);
+		if (rc < 0)
+			return rc;
+		nr_failed += rc;
+	}
+
+	return nr_failed;
+}
+
 /*
  * migrate_pages - migrate the folios specified in a list, to the free folios
  *		   supplied as the target for the page migration
@@ -2294,9 +2333,6 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		enum migrate_mode mode, enum migrate_reason reason, unsigned int *ret_succeeded)
 {
 	int rc, rc_gather;
-	int nr_pages;
-	struct folio *folio, *folio2;
-	LIST_HEAD(folios);
 	LIST_HEAD(ret_folios);
 	struct migrate_pages_stats stats;
 
@@ -2318,27 +2354,13 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	}
 	rc_gather += rc;
 
-again:
-	nr_pages = 0;
-	list_for_each_entry_safe(folio, folio2, from, lru) {
-		nr_pages += folio_nr_pages(folio);
-		if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
-			break;
-	}
-	if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
-		list_cut_before(&folios, from, &folio2->lru);
-	else
-		list_splice_init(from, &folios);
-	rc = migrate_lru_folios(&folios, get_new_folio, put_new_folio,
+	rc = migrate_lru_folios(from, get_new_folio, put_new_folio,
 			private, mode, reason, &ret_folios, &stats);
-	list_splice_tail_init(&folios, &ret_folios);
 	if (rc < 0) {
 		rc_gather = rc;
 		goto out;
 	}
 	rc_gather += rc;
-	if (!list_empty(from))
-		goto again;
 out:
 	/*
 	 * Put the permanent failure folio back to migration list, they

-- 
2.43.0


