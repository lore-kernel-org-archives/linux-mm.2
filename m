Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E56C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA876B007B; Wed,  5 Aug 2026 02:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B906B008A; Wed,  5 Aug 2026 02:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AFE6B0092; Wed,  5 Aug 2026 02:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64B626B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:41:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEBA71C0C19
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:22 +0000 (UTC)
X-FDA: 85066269204.13.86EA26A
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011006.outbound.protection.outlook.com [40.107.208.6])
	by imf30.hostedemail.com (Postfix) with ESMTP id 98B3C8000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oUGBCddW;
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.6 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R3x7VEe6Nw3J8dp/2fK+blzdJ9zV/j4pRmT1R964lPQ=;
	b=NjBmy+k88uf+oGDxvBXOKcwB7zzbT3yygtFgwPKNADxntxbZrq+fwnJc+XtmuTTvQfuedS
	YoAGlULWrWCXe+diuulTpKP1buzePsK4LkxqCAJkjnsvhuVvczFY92c25JBnZdB8XhVJkf
	HdUZyugcAl/ywot3/J0W1tn+oJapNq8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912079;
	b=ZNS57pyS2Iaw3cXZE+kD2YSjhIcKvNrad/39HlkKHzIfB2rXF6gJiHfj3YeRZQAMiahpI+
	1Tsxg+gYKrK8A8a+Q56M6SOnMwyO54kOhxpb2NtcY3RyG5DhxzRAEeRF79RwDQEtLKbk7Y
	if6t8JcmMG5eY52o7SUnYNtFCuYU6aw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oUGBCddW;
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.6 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGAW3w3LViXmPsh8V3DEGzvOaXZj1usnWwb1+I2wC+BitNEp7HYdk7ta1W3sEPi5HjIcNR9smmMLGkAkhkPfXZRDNsOBb9Nz5ibypn3o4/VHi5sg/K1UbU9GkHd5gJA6cycBPt1AfnMRcYCRpPLMQFKnoHzy0PX0dY/9e7BZ/U70Apr/LscaK6FYOS4fdJAbkfbOdI7/1mMyCL+ypVDa5KiX3dJyF1BN/v6uBYmtttAl6Oz7ITMreostKmP1J9s6d2StHG5oNxqgbK8k3ONjI/Q1iT+pnyhNJWjd+PY5h8mGSp2C3owL75+XoGroSw2ApSIrGCZ/QMYgM/touG48Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3x7VEe6Nw3J8dp/2fK+blzdJ9zV/j4pRmT1R964lPQ=;
 b=QzQB8/KZNBW7GJEEFl7bXp34pIb3tw7BoY6j9/g2mtd9JpEGpxXlfJEKv+fqcLHrslw+AJLG5d8GaSuWzT/lWUKzguoOfsB3yrvxSYu2s4ivGy9r6OVRmC9EYFw6py2FQpvOZMOcvNYwe9e7SqDhauCwVlE15MGocBEP/lK5J7PXF5/F+iP8RRrjYkn9dt0Q8eNPzegqKrgL2efVSsB9g6mEo8Lrk8j3T2sBLBEQ2UgkOuJhYuD0nQM+SnGBmberp7/bUgK1GBgy1CaRAOQTZbwMj1HetpXQqY7hiX8ONRPiKP2Y1Tn4XL61OMB6BvtTn6YnBU9MVgy+Ws6wOLgmuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3x7VEe6Nw3J8dp/2fK+blzdJ9zV/j4pRmT1R964lPQ=;
 b=oUGBCddWlHegtqlGGkykEgKyh25H1XxVfe2sFapXL3XxctJzY7/N4cBDuc7LKDwnY6+8NusUPlFipSGbPhiwArPfrKb3IDyWq2uLNeITqRobIXq99V3nJr/h7x8uNtFtErJy5p+/p/6J/ZE7Kkcp+OzhccTTPz7rLKqKtcSSnm0=
Received: from BL0PR05CA0008.namprd05.prod.outlook.com (2603:10b6:208:91::18)
 by LV3PR12MB9117.namprd12.prod.outlook.com (2603:10b6:408:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 06:41:11 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:91:cafe::69) by BL0PR05CA0008.outlook.office365.com
 (2603:10b6:208:91::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16 via Frontend Transport; Wed, 5
 Aug 2026 06:41:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:41:11 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:40:59 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH v3 0/9] KVM: guest_memfd: folio migration for
 non-confidential VMs
Date: Wed, 5 Aug 2026 06:40:29 +0000
Message-ID: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN3acmoC/4XNQQ6CMBCF4auYrq1pBxnBlfcwLkqZwsQUTEsaD
 eHuFjasjMv/JfPNLCIFpiiuh1kEShx5HHIUx4OwvRk6ktzmFqAAFWotY8/JDE/ZefLScxfMRLK
 y2pa6bgplUOTTVyDH7429P3L3HKcxfLYvSa/rHzBpqSS0gNg4i64ub8a3Jzt6sXIJduIC1Q8CV
 gJrY7WrzgTNTizL8gWpNTKA+QAAAA==
X-Change-ID: 20260611-shivank-gmem-migrate-8c1c519b30a6
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
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, "Ackerley
 Tng" <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>,
	"Vishal Annapurve" <vannapurve@google.com>, Nikita Kalyazin
	<nikita.kalyazin@linux.dev>, Patrick Roy <patrick.roy@linux.dev>, "Pratik
 Sampat" <prsampat@amd.com>, Ashish Kalra <Ashish.Kalra@amd.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Peter Shier <pshier@google.com>, "Jim
 Mattson" <jmattson@google.com>, Ricardo Koller <ricarkol@google.com>, "Ira
 Weiny" <iweiny@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=4784;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=6YpaUZG/dEytQdwZs+uQW7CIHQm9uiyT1mCFeYw/aiA=;
 b=N9UBFTS3Klw9d7OkUXWnt7t1k25cHHAtXyr/C4esTFUtisMCAIBlE0Iehm6wGSmcMHIdgagk2
 O4T2PiVurvkBhnU0k7FccTVO6Ss1TZZijn5xrss25UZi64RBL6MWwUj
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|LV3PR12MB9117:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac01d0a-20c9-4f66-a3e6-08def2bc89c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|1800799024|82310400026|13003099007|921020|6133799003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	k5WxsUpEjy+W6sM6mYdAQ59xkWyKr7LFUET5BMGtY5IAC++hKH90PPN4mav0l3ulh/jLfGq5eNx7Ap6s8pwvJsxX/ryjmehW0pxoU2fWE77xnTxbF6egZ2KwoK8F6k7NSaa0i0Cs2YeMerH/nQ1Fmo7AfEwwzlkZG5U91qt2k1jXiS59/hwo7PsS09L9MNFVWLMI39gY2rfLyTIVSv/G1eoS2RQlZm+mm3Q8/KcTuBSsb1bPUDIuHOYq9QIjgEAPNCt4L4NnOPANLa9dEOekLXSFmH6qa4n7eLbY3Tb1y0KBEZWod3qU11eWY3pfgfby7VcUmxsQ68j+sebC0Jel7sdptdeYy4Rm7mD9y//aQASZKcSQUHo3r0az8ga8ROuPMsWNyQhYmfSG+AAboHcSJfIQFyeC5aRuVkg7yCyQbtrk+fg6qVsmoElgN73Gd0hHEBuq8Udz6vQz+Cg3qWOw30VhwgeY8W12ehVg2RcGywBcpa5aryrdi06gbTUN3wpLCyRqeA9BBug50RCNyb9HErni2r8m0W+mGuDdZTYUaDuVFSEm7Vysnj4JCJCRPYp1BvzY7evTbMdV6APKUfkav+3Qa89+ITmHodAAAA3D1NblVsBZmG5VBe6B4BMwzu5Ug2NJS2ZZDltqz2vfFuWEIvxYfPNMcpirxHA8+9E3EW6ca+EYacsqFN37mEai0qBB
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(13003099007)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ykodeOeYq94s5WR8QSr2rY8/M/wrVcJ8k08vAtY/KkU8Gfb5dpAt+S069A8TeDze8o55cgMXPXF7Ghcbs310pZmWH+8HCWs/k/8Arp97noUjcSrsWBcXN2SZBWDNIDjA7t0SZ/bcWB69+Z3yGXOi2yF5UYlUdcvhOYKbb26UYLma9dqec98O7sCAYmU6ddq5aMcHcaFtv2eoPhYI9t+jiBBgIS8LgmCuRyEkrgCe9XuyieiAP9YRO4LmiFsTjtGiEvrmCVV8iQ3plYe4Tcv83D+TFKGGoWeDCdmkVgg8CdZt5afGe5FY6ubo+pbI6j5Ewelw3v0Ha/jY3BJylwBYo6gS1KiaJxmnkZab7ktzQO/Q//2xNHER05OQmEgxoRtQdl5FvBsVOGXK4MFTjcV7ok55mphWM3GaFhHJH8m4LD2hFj0eCbAipk6RbJ4fz3V5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:41:11.2085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac01d0a-20c9-4f66-a3e6-08def2bc89c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9117
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 6199eyxkz35rj3siubfoiz5kigju9mi4
X-Rspamd-Queue-Id: 98B3C8000C
X-HE-Tag: 1785912079-452916
X-HE-Meta: U2FsdGVkX18MjHhlyt2gS3D8xj1MaHZLh9/owuc/6+QmgrYbJqwBTkXKitWbZqqgwajZ+QovPiP0hCPle3iYZ57+PdP01qG+R+ONPaZT0x6NsExa2gLQKs+ZMXiozSB57yQD9MvJKQAwk96Qkz0j97zOtovpni8pE1dFEw2oKx8gJNEYrKmI6dUCmpfOPtTIj6b602f1Mi9yGOVwB+V9K4F84ldr2LVMDv/52wxe/aaHnDBz2/0dxLcM+1N+qcha5Iqycm/9gYYGs5MLAt/rmB0IzNEfJlzUacQxAdDcfog0d0f9nF2l0hKy9FCx5cgsnA4xEAdlpFIhTZ2rqLUygeII3QqUWEnc33rIBVKSzSlXhwWkYPo1j442ii+anbZ/0E7XtEWdO/s54zCkX1JWV6x9SJcG1UxDoQmRRT6dI0R0sm741Mrqw7A9jqfHX9/I2uw3Ct/U6kB15rB0lYlm1bmCDdtkO0QXG+kwgxQqynOGQkk8YqUAA399QLAvD8wxXCv/BjjsEufK857R2wuih/NXurgeteQy7NwLTwhhK1zisk860mGQ6mIYrF7VO8VZjIKfunkSJY74lukGSu945hS9DTCyluOIulJ2/L9GSt9PrUo8HR+LwqRKJ4DpPL7s776ppsJhXLYR8VTWkRqO2EC1g0rL9CHDZ8f+Zb+4fWd5L55vzL9LpaaFdDjW9Zr6mfQsUOFgM2mOW2Z+lbqnl6z7cqp1S8Aj3WEVv6WDVdsFjN6cWJ1B+TTInAxR7K0i9f1keCPbVFlLvLwcf6FsPCGPBr+p5MPLA1AXUuybIz/N0EopE5pdt4tOIjkKbJ0qBBDfTMnC5n6Qb6pG5iGGd/E5gqNXeUBPnRmuaryFLrWgj+uDrT4x/tVyWUkP4uMT7P6v8s1QAHMgiObtJQiHKHo+kqIgJI1exgjlMq4mtw/GWFaZBwspsvUcHbC92GRqE9NV9vce3k+Zp5LfRAv
 cxDi/IjS
 +v93ye3uOLBF5m/o1Rj6UGKLIpqQsEZmJPhud1cYxnnpIeDicMqGSerKO0zpYEaIJDkDKRigMuwqtO3HNO3Z4u5EjFm4xCR1EFCgNW0u3FDty5wZsZB9lLpD6lQkQROl6W7Wf/1FCbYkkzEBD5skQYtuJ8BaSkhp1d2MhyGHtosHw6Zn0rFCB+XpvihHUX7SmrBPvImSLoCNsfahl3/DbFG0YKavsA2SRsj9aerCmVzS4Xt3XeZ+Pb2ll00GArHt5ksf5Xwm5bNewT6yYROCtPWJfNFXMv0H2vWBDECkz5BCvMaga3I18YjISAkC8bmZWVzRMilKw9Na3XTuYt7oihOHBlhvYUs8hOdqhAhfUskHAZhHF/4xHjY6NdtyXQM3dStklP7rJI2NnVKOvqxcF4nZqKGldiLbVwpdGfMP9NhqhUjiMn5Fpr8D483USuKWLP/x5tTDSwrek9uZ0DgrAg8ztoHbbyiJvs3xnX5cEVYemz8YH3iSiEqcotOOZOPmH/GOkFphOK8+9dsbn8i2clKqtLwtZR6N3ZcPdPSX+8Dmc6oRwNAffcf4qLOUl0wWpBKFJqhPyKiFBUsX7mkVV5GYwDmoWwEmIcs4mw242k84z3n0VUTZmTIqWV3eSb+KUnlROd0mEZaMew9Q04oqHEjwZbTpyIRwV/SIM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd folios are currently always marked unmovable, so the kernel cannot
perform memory compaction, offlining, etc. This is unavoidable for
confidential VMs (SEV-SNP, TDX), since memory is encrypted and copying it
needs firmware assistance. However, for non-confidential VMs (like
Firecracker), we can migrate the folios.

This series enables folio migration for non-confidential guest_memfd and
also lays the groundwork for migrating confidential guest_memfd later.
Once firmware-assisted copying support is available, those VMs can be
made movable, the confidential folio content can be copied separately,
and the destination folio marked with FOLIO_CONTENT_COPIED[4] so
__migrate_folio() skips the host-side folio_mc_copy().

Testing
-------
Host: 7.2-rc6+(c21bb419386) + this, AMD EPYC ZEN 3, 2 NUMA nodes

- KVM selftest: allocate folios on node 0, migrate them to node 1 and
  back and verify resulting NUMA node and the folio contents at each
  step.

- Firecracker [1]: booted a microVM backed by guest_memfd. While the
  guest was running, forced host-side migration of its folios via
  migratepages(8) and explicit move_pages(2) of guest_memfd
  pages. Verify with /proc/firecracker_pid/numa_maps.

Notes
-----
- Sashiko pointed out a pre-existing ABBA deadlock between
  kvm_gmem_error_folio() and truncation. It's being addressed separately
  by Hao Zhang. [2][3]

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
    In builder.rs, add GUEST_MEMFD_FLAG_MIGRATABLE to bit-2 and pass it instead
    of GUEST_MEMFD_FLAG_NO_DIRECT_MAP to vm.create_guest_memfd().
[2] https://lore.kernel.org/all/ambEdSPjerZIVN0b@192.168.1.215/
[3] https://sashiko.dev/#/patchset/20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95%40amd.com
[4] https://lore.kernel.org/all/20260630-shivank-batch-migrate-offload-v6-1-da95d7e8b8a2@amd.com

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Changes in v3:
- Fix unbalanced mmu_invalidate_in_progress count unbinding dying guest_memfd. (Sashiko)
- Fix maxnode handling in xapic_ipi_test selftest.
- Add GUEST_MEMFD_FLAG_MIGRATABLE documentation
- Replace open-coded sizeof() * 8 calculation with BITS_PER_TYPE()
- Add get_numa_mem_nodes() and use  MPOL_F_MEMS_ALLOWED for allowed NUMA ndoes
  instead of hardcoded NUMA node IDs. (Sashiko)
- Extend migration selftest to verify rejection without MIGRATABLE flag and
  move repeated checks into common helpers.
- Drop RFC tag.
- Link to v2: https://lore.kernel.org/r/20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com

Changes in v2:
- Make folio migration opt-in through GUEST_MEMFD_FLAG_MIGRATABLE,
  preserving unmovable behavior if userspace don't explictly ask. (Alexandru, David, Sean)
- Add kvm_arch_supports_gmem_migration() so arch can control whether
  GUEST_MEMFD_FLAG_MIGRATABLE is advertised.
- Allocate movable folios with GFP_HIGHUSER_MOVABLE. (David)
- Keep guest_memfd unevictable. (David, Sashiko, Sean)
- Split migrate_folio() implementation and enablement as separate patches.
- Update selftest with new flag.
- Link to v1: https://lore.kernel.org/r/20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com

---
Shivank Garg (9):
      KVM: guest_memfd: take the invalidate lock when unbinding a dying file
      mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
      KVM: guest_memfd: implement folio migration for non-confidential VMs
      KVM: guest_memfd: add GUEST_MEMFD_FLAG_MIGRATABLE
      KVM: selftests: fix maxnode arguments in xapic_ipi_test
      KVM: selftests: use BITS_PER_TYPE() for NUMA masks
      KVM: selftests: add get_numa_mem_nodes()
      KVM: selftests: use allowed NUMA nodes in guest_memfd_test
      KVM: selftests: exercise guest_memfd folio migration

 Documentation/virt/kvm/api.rst                   |   3 +
 arch/x86/kvm/x86.c                               |   9 ++
 include/linux/kvm_host.h                         |   4 +
 include/linux/pagemap.h                          |  24 ++-
 include/uapi/linux/kvm.h                         |   1 +
 mm/compaction.c                                  |  12 +-
 mm/migrate.c                                     |   2 +-
 tools/include/uapi/linux/kvm.h                   |   1 +
 tools/testing/selftests/kvm/guest_memfd_test.c   | 193 +++++++++++++++++++----
 tools/testing/selftests/kvm/include/numaif.h     |  52 +-----
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c |  14 +-
 virt/kvm/guest_memfd.c                           |  76 +++++++--
 12 files changed, 284 insertions(+), 107 deletions(-)
---
base-commit: c21bb4193868a8de71fc4693fa741e195fdf5d86
change-id: 20260611-shivank-gmem-migrate-8c1c519b30a6

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


