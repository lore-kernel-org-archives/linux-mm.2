Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63906075868
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=VacjD8tJ
Received: by kanga.kvack.org (Postfix)
	id 7F0816B05C7; Fri, 13 Nov 2026 12:33:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A25E6B05C8; Fri, 13 Nov 2026 12:33:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AEA6B05C9; Fri, 13 Nov 2026 12:33:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF78B6B05C7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:33:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D07F640202
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:33:24 +0000 (UTC)
X-FDA: 85430792328.03.157CA0B
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010023.outbound.protection.outlook.com [40.93.198.23])
	by imf12.hostedemail.com (Postfix) with ESMTP id 96A4740006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:33:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VacjD8tJ;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794591202;
	b=fwY5KVB8cRGi87LiH9OgLptON0BSNRgExIdvKH+qHXdqUPjS64rU8A3bZpdMMvpT72ZMRS
	b6NrWkOLw7LsKermhrJFtTR7hQyIQOADxkIIAc/e6sEBAYOW76QuAvbD7jBgCMnFSKeu0z
	NMhIdiJFmwoTFlPQ+QJo8HYmDU9giVU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VacjD8tJ;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794591202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dpJWAOoXl+6YfoYlsoi5QksE6iEyc707Xu/3Gv1Sn9Y=;
	b=R/6Iwm/h/LiZWS3JElyDflstZSQ29qxgZ6GFIi6EigbQmMgvrCCMbD9vBoSHd2upWElzHu
	kWRmhblLfWzky0HK1QyP93tpbeVGyIAs6+fzVCgYpRCjirDTg1BJIYEq+ho9XgkqsSW0nN
	858+MClcHDTEcvIZcX16i2xqDr5nVhg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kBTsqL/sMFI1jPrJxAxNaddzylAGmtALhck9pV70MElvZaezw+Goxv2OwDuCnxWGcUzpPXQEJUEldD6FSoD45OG06r0mE8xu/SIzCICcSOtR8bcQKbTuGYpapMtck5jFnElPQIRD+AFzZs0bEY7hpscHnCEJWEQYNvgoBWIU09W+hzkLNpZaRmNqY+aTfVVEhNFy1AOwiOuSixd1Y7iAZAGbRhLnv4FgSVD3kRa1QlqNXhfEgmiVwKVUXr8nvrt4XzXQsnwjzXpGWbLWhp6U8suuv890dtej2OjWN5Zzz0MYHIyUTe4ACY7uxfO/RjDVeSH4bbsquOY9VGlVXnDl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpJWAOoXl+6YfoYlsoi5QksE6iEyc707Xu/3Gv1Sn9Y=;
 b=VbG5aCYv+eVRzPaHHd0P9PKxT9rGdkxbQu3GUDznQ+hSFRFOe0YMAs/PxYNCZtBkFPfN5nhe0s1EaH7xQIvI5FGG5JyHrDkysxnpGyTIn953u+mblOk0b99g/fU/9q7aNxYsFw4u+CbScA1Kw8335JKRe8GE3ijtweklzWU5/DkgVB5JBrrW/1JptzPJZXC9ZCYe1Wxt1EVwlQ4whnzyeoZZa8zG9B6HYCBt3GAu6CNcHJj7TYk8jTImKFq4WVgpjRa+YwcY4R+DpNJJc0901WaQNjFM+xWtrT06/fZ5j+ZD43K/sChRM/JiCeyAdk1TIB04gV4qdgPzguzHo/a4mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpJWAOoXl+6YfoYlsoi5QksE6iEyc707Xu/3Gv1Sn9Y=;
 b=VacjD8tJiqMJnhYPWStgKtsg2g+FSIdoHLZ+rrMo9KogYAB66T667ce4LazVORjjtMUyMd9G/kt5P1HohQMghrebkLPyew4yi6Hynaye3U1weKVziN8Rn91FDiyEmitYi1DMLC6F7BTOTRB+Hk1pvEqb9Dua9rGRMHdXMmJdHyo=
Received: from CH2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:610:50::17)
 by IA1PR12MB6235.namprd12.prod.outlook.com (2603:10b6:208:3e5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 17:10:19 +0000
Received: from BN6PEPF00000072.namprd03.prod.outlook.com
 (2603:10b6:610:50:cafe::32) by CH2PR16CA0007.outlook.office365.com
 (2603:10b6:610:50::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 17:10:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN6PEPF00000072.mail.protection.outlook.com (10.167.248.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:10:18 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:10:12 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Fri, 13 Nov 2026 17:09:21 +0000
Subject: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1XMQQ6DIBCF4auYWZcGqJTYlfdoXIwwKguFgCE1h
 ruXuuvyf8n7TkgUHSV4NSdEyi45v9V43BowC24zMWdrg+TyybVo2Yh7wJmMDwdTKMdWdYKTslA
 fIdLkPpf2HmovLu0+Hhee5W+9HMFF9+dkyQSzWpG23E6I1ONq78avMJRSvlBm7MikAAAA
X-Change-ID: 20260714-batpagecopy-5a2b45910e5d
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Borislav Petkov <bp@alien8.de>, Ankur Arora
	<ankur.a.arora@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	"Thomas Gleixner" <tglx@kernel.org>, Bharata B Rao <bharata@amd.com>,
	"Hrushikesh Salunke" <hsalunke@amd.com>, Ingo Molnar <mingo@redhat.com>, "H .
 Peter Anvin" <hpa@zytor.com>, David Laight <david.laight.linux@gmail.com>,
	David Rientjes <rientjes@google.com>, Linus Torvalds
	<torvalds@linuxfoundation.org>, "Teja Vojjala" <tejavojjala@google.com>, Huan
 Nguyen <nhuhuan@google.com>, "Pedro Falcato" <pfalcato@suse.de>, Peter
 Zijlstra <peterz@infradead.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794589811; l=7386;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=dVWgGBtqpCC3ANy8Ye7+zxKYvKb5hvxDp3JD5u4sVhQ=;
 b=NwjNYeOyibxuNoLy4ejo16LierH9cccGxb0+PlkdLvuBHNq6xbMiBfjHMhjQdRzjmrcaiWwr+
 TqQGcZWI6SWAUGMqEx/QI7oXiZL3qfjtVBxwU6bB6RiOZDjIG3jfhff
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF00000072:EE_|IA1PR12MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b9ea62-bce6-4da2-6b6d-08df41a8fe46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|7416014|82310400026|261021133027099003|10067099003|261026130827099003|261102130727099003|261009223027099003|261021123027099003|261028144727099003|261026140227099003|261102123227099003|261021130227099003|261026121527099003|261022115727099003|261022105027099003|261026135527099003|261021135927099003|261021121427099003|261022113327099003|3023799007|261022075727099003|56012099006|11063799006|921020|18002099003;
X-Microsoft-Antispam-Message-Info:
	esjb+8aBysIU8QR+4Rufn3J3ppvti2wBo6E9wHlmtzNXDG7sEz1tQ7In6pUT6TODa3clX7dZPrmjTCrpVkcbtL0c7nML0muZJuO+iR5cdVHMzus3zlDV9H7DQzNnaEQzRbU7oCm3DUdgGqfCg9PM4L+G6CH7XidA70DdLzvxs5J86OQxyptkKviCwDIjBfaZwQRA1NZbY+cXq9pLz500OHiJOnLMBYM2cT8ojtkNvUojIeEXrmvWk7WWmD2gwZvt0fOi97Ryjlfl3od3i06Hlv2y1yuaDRLDAAFh1wI2hcUEv8QDIZfZqSxV6CtpZXr1Is4gFvwGBw+hSeBsQ2dhJGArOzDBLzskM+0/m8RHV9G2LqK2Z3LbnVkBRyXXrpMAkyPFOxqR8yGLZoxob3wI0v9tiUgrRpZFG/cpr0U0Kq3qt3yTMPv3UWSYhZPhnIDDrr7BHJlOjnhB7kE3z0WrJBTe1XmPuHB4Urb6yLWpKxA7lIn9hUTVbDM6oiqIKlx0529tBeeVE6EkhE4l1ktuAZz3By/MWAQI0TZK49+tAN3ELubNRh8RZU/UHprJGVSqSSU4UymrpitvjNNSe0qQWs7GHJzTf4Yz6Vh29Xwy45YiyOFgrz1GMemjcwNQOCfdHPXKV0rlNYG+q8N6RSXI/LVvmCRcK7BxKTx0o/RGVhtRhqzQXM7rGzF1ELxEFABQwSozhUpw/0wkoD88/PVibQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(7416014)(82310400026)(261021133027099003)(10067099003)(261026130827099003)(261102130727099003)(261009223027099003)(261021123027099003)(261028144727099003)(261026140227099003)(261102123227099003)(261021130227099003)(261026121527099003)(261022115727099003)(261022105027099003)(261026135527099003)(261021135927099003)(261021121427099003)(261022113327099003)(3023799007)(261022075727099003)(56012099006)(11063799006)(921020)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OA493x4hFPSA82KOwUX/sK351i5GRb/xEY+inyRcslQ1Ji7uRqVNU2GPYgItZpWFd2sYy3hI7LC5Rc9ZpWJvjX3JJ97K+Ved7wpHQssOOWoZG+hb+HBFnTpP7hz0JzONjgKSyQl5MCy9Z0Nuqv+WIeMVrC8teDJpAOqP2y8Rk5xXbyauxlgGJcCh5U42c8jcfsuT9ZSZaqZW3DnOdlND91mXZKBpaWOSDEg6ggwebVC1/hzee/TmHxM0+rDCtHFzgWF8ALA4evRZ2vRw5TWi4p3C5k5yfW/dYk6lMunr7Gw+KQda0umZ79Qmd7QC43ze6J42bc47UcuapyTQSpF1MPfQEXRcheRMVf3/+7e/0++GWRNvRp3gOtnWb9x0orwTFjzC/BohNEhzbw1vU9LtdI+vcOBAW3jKJqlZcd2RWkHZiXxBKw3OBJj9Mx86HwZe
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:10:18.5854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b9ea62-bce6-4da2-6b6d-08df41a8fe46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000072.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6235
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 96A4740006
X-Stat-Signature: pedjwf4m8stdf5s98gmzue5gqxyrymgn
X-Rspam-User: 
X-HE-Tag: 1794591201-504549
X-HE-Meta: U2FsdGVkX1/+JsNeZG5r25uzrpXnHkuYnNw/GQfpiy7pzLHVjgFYTiEYmEaigdMJYZsFeMuaprtY6OQR0T1zCwMpCaGmfwAUuq3+6mgOpt61ZL4XaallM6/8fIQZbd0ODcs1Z8GaswYNMX+A3Arc+m79hfP7S7AVEDW7NQZT4vX70WNBEDNRTAlovTN5Jmhfw0M0CqpvCWQUEWWOPbUpvWznfsqX58iUGRIiX4YKDd2F/ETOSj+yF59fvOa/5Is+FOAQCMWBpnCI+QM4qAwyY5IaIP/ROSUojrpUQB86LZ/ylQ5eQ+PV03m1nrSKsH1siQveH+n5Z1eUPohg6fPSb3FawyKqRjPyp+Dsr/JPg1og/R2Ix/YzTomVYlxejQnCkfNxgvGbVMnAMMfR+V3GLGvTmSJ8n7ix4oohlUb1KPJq+jLvzBBdV6PJK3PrhtD1Uwd1cYRabidWrEzTz0OppkegKkb+WhzDpk4auwTcY0UaJUHMPI4cd5SXX6g0DBt7P6wxGBGdtbmzf83yc7WKBqDuj5wHvjYCKXR0hh1Kdbh75zsszb5pA2Uq/Y/j1oRWfRYyuyYSdHx+mb4m8OXTJUoylBpmhJsRMYeyvr+k1H6gjV8VRj5uL0DFwAeQZzhurN7iYOFZzFt/1Emc3PTmDKItruvxnho4ikbp2EAY6Ww3bIvAKe/3Gx1epfhgVaf+GoFe3P2vqkeZELl9FMSeFLsFx/kjqcHVuAhuqbv3ylnR5EqVFD12MS3jsyoJvFv3H0J6C6z689WlwFo1j8Ugtqqwr89txk4jIVMUkbEZzcp102TQB9K1+6Sign2vOncz94BYt8B0+TRPKinJjWShz+tpJax5Nrh1wTwXx1GXzPEZxVCI1Tg2Dk7uhsvLt1ZW5qu+edqqGVNW3ZS68vKxq05WcUgoGKATmkEB+7wTo1JAaC9v7nU7+Wmi+Atk2WCIRmiLzj4uoTFRKnIgRGv
 KDK+BUtI
 KnxSCkgdoBeOu5NtRKCU2pdtVtIAVWZ8B4mNOVCW9KvhXcJixfv79d/l37Rs2zTbZ0+bFgxsb4WMzBVyF0BQbMlsvVibKQ8+VR0gKADPpjlYfucq1vnELkkMF1+A08c1BngiyjiJXgfcj3ghGzDuPK/rUip2wFpX7TT/EcZFLQ+JJSkQ5GFk/VYxAqdWLj9sLdzZIdcA4YZOd5/J5vvhcs5TaCDRo8IjXYVloUgd8Xr00UMJCFF+bqbjjS6AAqAlUahmcnm3xmeqSWDpVpRuYBlXWcbvMYHboPFRqIK1zSt0hTTCRX1DLTUgETW0hXpQdT3Q07BsYddnDd1flIEOIz9sCb/mFzY8U2vgvBgpLJoFm8XVIeMX0cg/g/XU1v8qPMLH2FHshclxeBzw1puhdA9ZjfFM3GZnd+Ouf3niuYVe+WJOAnAK/50Ls5cn+7rM6yxod5gxMrGxzbUrv9RmNXsMAwV80FWZ2DT16iEFWj2AcNo9rOg2yhjJM/v7yd6Y3kbknRSpFujqeML6RqYtC0+NtyEDvafh0okaRLD0XyrVCvpTAar59kvyv89GYFk/V9106d5nt7/A58GHiWtGYwEYc24QIEq0lWUo4KGbqxh3k1m2Zqp2g6xiiqz0BdEdS7CKW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
so a 2MB folio makes 512 separate copy_mc_to_kernel() calls. Each page
pays the startup cost of the string instruction ("REP; MOVSB" on x86
CPUs with ERMS) plus a cond_resched().

Introduce copy_mc_highpages(), the page range variant of
copy_mc_highpage(). When copy_mc_to_kernel() is available and the pages
are in the linear map, copy the whole range with a single
copy_mc_to_kernel() call, so the CPU can optimize for the larger extent.
Otherwise, fall back to copy_mc_highpage() one page at a time.

On a machine check, queue the poisoned source page for memory_failure(),
as copy_mc_highpage() does, and return -EHWPOISON, as folio_mc_copy()
does today.

copy_mc_to_kernel() cannot reschedule, so only take the single-call path
when CONFIG_PREEMPTION is set and the copy can be preempted. Since commit
7dadeaa6e851 ("sched: Further restrict the preemption modes"), x86 and
powerpc, the only architectures that select ARCH_HAS_COPY_MC, only offer
the full, lazy and RT preemption models, also with PREEMPT_DYNAMIC, so
they always take this path. The per-page fallback calls cond_resched()
before each page, as clear_contig_highpages() does. Other architectures
keep copying one page at a time.

Switch folio_mc_copy() to copy the whole folio with copy_mc_highpages().

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
On a Zen 6 system with CXL memory, move_pages() gets ~1.4x faster for
2MB THPs and up to ~2.8x faster for 1GB hugetlb pages (numbers below).
When demoting to CXL, kswapd uses ~31% less CPU per GB demoted.

Changes in v3:
- Copy the whole range with one copy_mc_to_kernel() call only when
  CONFIG_PREEMPTION is set, otherwise copy page by page with
  cond_resched(), following clear_contig_highpages() [1] (Pedro, David).
- Handle the machine check first in copy_mc_highpages() (Pedro).
- Rebase onto mm/core.git for-next.
- Link to v2: https://lore.kernel.org/r/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com

[1] https://lore.kernel.org/r/20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com

Changes in v2:
- Drop the folio_copy() changes as there is little to gain here.
  On architectures without copy_mc_to_kernel(), copy_mc_highpages()
  falls back to the per-page copy_mc_highpage(), which ends up in
  copy_highpage(). A batched copy_highpages() could help there too,
  but I haven't tested it on those architectures, so that is left for
  a follow-up.
- Add COPY_MC_PAGES_NON_PREEMPT_BATCH to limit how much is copied
  between cond_resched() calls on non-preemptible kernels.
- Rebase onto mm-new (2887e63d2e8e).
- v1: https://lore.kernel.org/all/20260427142036.111940-2-shivankg@amd.com

Test setup: AMD EPYC Zen 6, single socket, NPS2 (nodes 0 and 1 are
DRAM, node 2 is CXL), with and without this patch.

move_pages() throughput
-----------------------
A single move_pages() call migrates 1GB of anonymous memory, as 512
2MB THPs or as four 1GB hugetlb pages. Mean ± stddev (10 runs each),
in GiB/s:

2MB THP:
  direction         base            patched         speedup
  DRAM0 -> DRAM1    19.57 ± 0.17    27.51 ± 0.78    1.41x
  DRAM1 -> DRAM0    19.44 ± 0.12    27.33 ± 0.27    1.41x
  DRAM0 -> CXL      18.66 ± 0.18    26.90 ± 0.51    1.44x
  CXL   -> DRAM0    15.38 ± 0.59    16.60 ± 0.24    1.08x

1GB hugetlb:
  direction         base            patched         speedup
  DRAM0 -> DRAM1    20.34 ± 0.13    53.88 ± 1.48    2.65x
  DRAM1 -> DRAM0    19.10 ± 2.65    53.78 ± 0.55    2.82x
  DRAM0 -> CXL      19.53 ± 0.08    44.10 ± 0.19    2.26x
  CXL   -> DRAM0    16.41 ± 0.07    20.89 ± 0.06    1.27x

kswapd demotion
---------------
Node 0 is limited to 16GB of free memory and demotion is enabled. A
single thread bound to node 0 writes 96GB of anonymous THP memory, so
~80GB has to be demoted to CXL. Median of 10 runs:

                               base        patched
  kswapd CPU time              4.25 s      3.44 s     (-19%)
  kswapd CPU per GB demoted    63.6 ms     44.1 ms    (-31%)
  demoted by direct reclaim    14.1 GB     0.46 GB
  allocstall                   7427        370

With the patch, kswapd keeps up with the writer, so the writer rarely
falls back to direct reclaim.
---
 include/linux/highmem.h | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/util.c               | 14 ++------------
 2 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d7aac9de1c8a..a79e9d68359c 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -484,6 +484,57 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 }
 #endif
 
+/**
+ * copy_mc_highpages() - copy a page range with machine check handling
+ * @to: first destination page
+ * @from: first source page
+ * @nr_pages: number of pages
+ *
+ * Range variant of copy_mc_highpage(). On a machine check, the poisoned
+ * source page is queued for memory_failure().
+ *
+ * Context: Process context. May sleep.
+ * Return: 0 on success, -EHWPOISON if a machine check was handled.
+ */
+static inline int copy_mc_highpages(struct page *to, struct page *from,
+		unsigned long nr_pages)
+{
+	unsigned long len = nr_pages << PAGE_SHIFT;
+	unsigned long i, ret;
+
+	might_sleep();
+
+	/*
+	 * When copying we want to operate on the largest extent possible to
+	 * allow for architecture specific extent based optimizations.
+	 *
+	 * copy_mc_to_kernel() does not call cond_resched(). That is fine on
+	 * preemptible kernels, where the scheduler can preempt the copy at
+	 * any point, so copy the whole range at once if copy_mc_to_kernel() is
+	 * available and the pages are in the linear map. Otherwise, copy one
+	 * page at a time and reschedule in between.
+	 */
+	if (IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) && IS_ENABLED(CONFIG_PREEMPTION) &&
+	    !IS_ENABLED(CONFIG_HIGHMEM)) {
+		ret = copy_mc_to_kernel(page_address(to), page_address(from), len);
+		if (ret) {
+			memory_failure_queue(page_to_pfn(from) +
+					     ((len - ret) >> PAGE_SHIFT), 0);
+			return -EHWPOISON;
+		}
+		for (i = 0; i < nr_pages; i++)
+			kmsan_copy_page_meta(to + i, from + i);
+		return 0;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		cond_resched();
+		if (copy_mc_highpage(to + i, from + i))
+			return -EHWPOISON;
+	}
+	return 0;
+}
+
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
 			       struct page *src_page, size_t src_off,
 			       size_t len)
diff --git a/mm/util.c b/mm/util.c
index c9c3dc4b490f..1277daa3ccd6 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -776,18 +776,8 @@ EXPORT_SYMBOL(folio_copy);
 
 int folio_mc_copy(struct folio *dst, struct folio *src)
 {
-	long nr = folio_nr_pages(src);
-	long i = 0;
-
-	for (;;) {
-		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
-			return -EHWPOISON;
-		if (++i == nr)
-			break;
-		cond_resched();
-	}
-
-	return 0;
+	return copy_mc_highpages(folio_page(dst, 0), folio_page(src, 0),
+				 folio_nr_pages(src));
 }
 EXPORT_SYMBOL(folio_mc_copy);
 

---
base-commit: c6e0cad6c9b4180bb229db06e5b062c5ce0723bd
change-id: 20260714-batpagecopy-5a2b45910e5d

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


