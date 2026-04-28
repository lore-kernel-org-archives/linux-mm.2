Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81CDAFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1EC46B008A; Tue, 28 Apr 2026 11:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6886B008C; Tue, 28 Apr 2026 11:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6566B0092; Tue, 28 Apr 2026 11:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE3D76B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:52:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6304A4016A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:52:21 +0000 (UTC)
X-FDA: 84708406482.29.ED44EA4
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011010.outbound.protection.outlook.com [52.101.62.10])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A84B20014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:52:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IQWRcdOD;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4xms1cijBzKJu8O/pAsQ0BL/RdmQNHdZRvXeM9xbLE=;
	b=cRfWuOq6Rvuh6WUe8sEP6xjzVnPIBwHPaVv9YdRqBhoWSeqBWIh6INoNI94TR3DZJsARET
	KcLJv5u+WGff8nLqHWw5ZM4gvBCGPjf+r8O7zGqUzxuQAy++7sLfOpmbOfB6fnHaRSbx0R
	IJpzpBJUT5aZl0RyzP931QlI0wG1oJ4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391538; a=rsa-sha256;
	cv=pass;
	b=Lg+UV08ZH6uZDF3mXjbdRzW6aFuCvVvi22i7ZtY8MlbZcHTRi3czstRKknlWPSUFOOXz7L
	hTUg3UWxzRYP7brOd2koIB0H6xR/uexXR62otAnAHEkC9M143PCNNbHj5wU1ylp0QYbQAr
	XEuNy+b/NBqdxu/43Y+ihaAXOcIftac=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IQWRcdOD;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w114zZToBU0thxIhAy+NTk8PH7N6SQTMYWEdXKWGO5K5V/siFeZDhVVybXX0XMAF1zRJHK8KR1pZLVTeUWxXJZXMIIIt7dZov6xsNWGauBrRAx2PghvhH/d94YWZD+cJyR02tanzWqGNHyrpljK/sypNqEvn8OLT5lsTs5kt8ZUE7PvHG7PsxIasrD7Nzyn9nXmsb0VDmUu+QmhUARCVOF904Z2pNQLSa8+ivt82vCcNu+OmN7WT9/jxohi1VRs+I6T/XR7OecswNkxa1uDwJLVjnY/A8ogWDUitgQ+5hWeI5lzhNXwNbrOIq2W2Q86RpTvLez9jZl7xHUTy0ghtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4xms1cijBzKJu8O/pAsQ0BL/RdmQNHdZRvXeM9xbLE=;
 b=yLaBPTaM7IIbLtY3Py9LP+HcUJSF+EPussQUxqwc1UhxYGUcqXMgoQPXnNMsi5fII1VhbHg0K5MksM1fuvf/Qs+s2Rg7lKkKu4DkHr9jH3MrYDLY2OZi3ByR/fWtwE+hXotbrwyrC8pOGlDHG9qFfydOcrwexqi6gAxcJtRhWKr5g8Suti/afNQibnUU4DpwMh0WvZbdPhHfWIZIq/GRel04vNEk3GQ0gOQgjmYE7CBmhC5457AqbRMYq1hvLeag6OGBsPK71qQ2UrimpkS12gBM7VmieIUQDcKN6VaNVEUHNqXm70UW1WgWltose6YvZH93h/tu8aVo1GG+ezSImA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4xms1cijBzKJu8O/pAsQ0BL/RdmQNHdZRvXeM9xbLE=;
 b=IQWRcdODnXUjN23DsyVNJx6UTD5YftYo5Ml20kheheyw2w05PYcaAJ4t6zba31kGRujsMyOtC0IowelWyDjt35VNQcxM5ga0RY3kh4/kL7r+J9RgeuHMYQlAswHRbYCtA0xKJJS3CaBDgzpURSfo2E0l3/jlQYQ9Sk4yqPE50nI=
Received: from BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18)
 by CYYPR12MB8704.namprd12.prod.outlook.com (2603:10b6:930:c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 15:52:12 +0000
Received: from SJ1PEPF000026C8.namprd04.prod.outlook.com
 (2603:10b6:a03:d4:cafe::d5) by BYAPR06CA0005.outlook.office365.com
 (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 15:52:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C8.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:52:11 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:51:53 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <kinseyho@google.com>, <weixugc@google.com>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<rientjes@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <jhubbard@nvidia.com>,
	<peterx@redhat.com>, <riel@surriel.com>, <shakeel.butt@linux.dev>,
	<stalexan@redhat.com>, <tj@kernel.org>, <nifan.cxl@gmail.com>,
	<jic23@kernel.org>, <aneesh.kumar@kernel.org>, <nathan.lynch@amd.com>,
	<Frank.li@nxp.com>, <djbw@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/7] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Tue, 28 Apr 2026 15:50:39 +0000
Message-ID: <20260428155043.39251-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428155043.39251-2-shivankg@amd.com>
References: <20260428155043.39251-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C8:EE_|CYYPR12MB8704:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f4a7ed-b4e2-438c-9088-08dea53e1ca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	gQEmw4aapZepwWUEtr+Q4Q6GKSu2ui8iE9/RoXXo/AlIB4XdupG0U0RtjcBoMaX0WY9OlAroROAvdeSeZ2lfWIKpl36gHF2TNmN/KXFnh2K6NTDdQqjmrT6dre/1BvCs+qbfwsAENdtohukczvVk1H0TbgiEgubfS0r/FaHpriBz8n/tbCy3ZCBYuTmkbC6aiTVaVgy4yYMpvIZX2ywt4nrhItnJvhdpz11LpPUeNZLkw12U+vPTtmI7zfi5pvxITFCHqTnPRrsAQOYernDtHnigp4kegc9aWJft6V1CVfnTTEQY4x1389NqiVj6+HoooNeomQzmEMGGBZF2MVxeiU19Glf8ZrJSZZV8ZJocu9iaz2HXi++K0YOqMCAjHj9OXmrTeLfLherjhjQiBCRVdJ5KGdXQDJ/CBCSKCb/8YikNMZyjL9AeyofkS6buTasEQrz8tL60eFbsre2PFKrrK9MjDjbXrRKq5Ns4daAQSXiZOaWbd6RldthZLfZBxVa7OQFmn25Nb2JjIu5zxKumUpJgNAlJmypfI/ci09czX19SoYR/ITv/NGEnIxAqoXrwwPg/P6bOZ/2zXiIxQonOv2DuyDhFJVlbKItYcQ/54yDkD+UA5I76pOds1lPdpZmMIMF+gEk8CbC3BPqX3OXLT5ukfOsmitFdPlTl9NZZQu8e/aeyFEwyBF/q13xq9LWzcbeLOWjuQ0qMIhJYDcWMWZLfI/ASz/GRs/BxQO1eKEfDBrs40wKzDXOW18rCrULNIHNc9iuNFjjXpKiARdeggA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	okaJK36rdwdAR3rOjMRvQSNDQsazaVV3EofYMBqatQmgKJa0oZrKYlRp0A6j9ZWtxw6cSzLHmWBXOrtoLYbUSfEg+mfz5G9AzcCS0Y62QxCDkx8pZx9rxqKGHLPPI0pf4iW3AvqPJNrhHMRsLw1W3w67ws/mA8yMTuy9aQiZCSMlZq6OeVCeGwy/h5XabT/PTD+l00U1/871/Cy4yjo7MIvEHW6+AC97iZROvxayGDBUY/UvXS+fPR+E24Q8MZi3jf6PL2eLIr1yQTpvGKU3n1sBFzErWbQsVNxbytLuPHzvfMAGvE3Tmu+0xIiV5enrVCAohD11+bpkEW0vZnLv+7gkJF6cqyQtZCSy1N5HfDvInZgS3gUggDgRYd0n1vDjGzbZ3k/0MmQsCKQVQpCafePWI8zFGjNa9l8GyfB+MVrYI3BKXHG4qJ9NJ3hlgmQi
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:52:11.8759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f4a7ed-b4e2-438c-9088-08dea53e1ca1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8704
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6A84B20014
X-Stat-Signature: ca6b6jgcmccoi751tngep18fd8twk9hq
X-Rspam-User: 
X-HE-Tag: 1777391538-944725
X-HE-Meta: U2FsdGVkX1+GJy/1/K5dfonTnvhaj6hv/azW3TBjjn3kkuq09AHNZT5bJSnOQ/NshGusoncJh5DwXsPzCFBeoBWYH4Tg+6z5HEDHuZ6KNeHC4WycJ6I8cMI7jQAPbeLRlBwFyarN7/PJKxLr+Q6ClEgK4N3P/TNNwmnqkmpe+bLgeUoIOoUyoNSHZYBY+C32hrySDut35HtNb9BCi/kCZt8phB/ggr7atFuVtDt8LzHeQoWm5XfMNIDVsTHYnI8XbAVUmbEKTVb7ipOGkYi2JSC2ZIcedxCVDWTymBejj4IyM8OBBfjeTLahrmTmDcKu0/YnVB48C4ubyecPL6Doy5GyPrbrHnvQ/QPgysi9DU6n7tQUVpXQ7JYznRvBxS5V7us3QR6oyE6JRGz3Kl4T2chfdU1e7Zn5m4QxV/q3xhHrWrzuQV8qsVIb6cd0JvyjaUvLtW28ttwx0HDfxoj+XkUFYlqnRA7C1kx8ZSsOFOTWsjCHa1e01KVVXoTzIzddK3Zw+nDTlunwyiJNt7VETdKlVHDHmkfjiBNpECi6gAgsyBqS6ypXO1l2+69lE85h9AlPfZ3fr9tcHg6nsjkhDNO8E0VClHUvofEHm5VnGWTt0uchVH67KQvQrvPZU2KYopPCzCDPe62T3HiDFtr4yJQ70jzDGC5M8aVhNWcHs+cv/71tmpisgUcEh7nyquAf9Hh1CYe7PfW1waBhJP5fMqEP8P9KUnOa7qcE3AVs8WKxpSFG0N3WaiX9g4/YMbueeYbq47vaPgr31uvqstVUX5TU/oZZ12+V3tHDo/1ck4X2UtJ9gJL8IMtHQXdYyFFG3skTwj9/1YYJ65zTkEybvIK/hL4TdE2h0yVql6nOOfLjtY/9BThidgOMGZUm50Me9a53d73+vn2z4neDCh+Oz6B6/1aznqySJ3gSf7yJkA07BbWjHpI67kzICqFs5L3up0L9Oge1HHzAhH27gP+
 9+qdEyEi
 8ICSBIwPZmH1SPrb6LeOD2N1zb3jt5ybmh2bD9bg1+mK0QA8IChkIoM0zfKYHCx0UzGmHCKgqQMLM6uaEIN1BYY8Zm4AelMibz6jvYonCHJeqXr9XTmi2+l+iDFu3zSlxvLa3AELCkVq1AF33j+QbdPaE1FMsBbJYVweCHm3YVajq0nYVdDozzfhFJYFPktMFaxjwcctMDyEVBZOWU2J2gslvRtTpK+Kbuaaqo6imkZZ+K0vhg6NOPUdoMpgIrJ7Zz/7s6mksw/SgmQR2iMrS2WqtLv41hhvDQd2MRYAMnIWbNyKYq5L93OkqGOE0PEjG6iKZAeOP0uVIx/tbVCzb0SkcQL9CxpiWGiu9ua2Cth+3gRXnQQzAeARLVKn9zAL6QoCwj9CDqzps+zdwW6gc5z+NILMxd4VlDKC4eWosS/3z57chSeWcodKJa8MwTxGrKzyqzEfZbYsobX0TDFj6HehUaEj4kjx9yiLq7ZiYWA0boiBGVcbciKsSRxStlwWcgHC8TamfkWeLMyfUOEk6bH/TkEZf25my3L+0PpAhC1JiLpx/XsZwhAyoDggVbsOMlZ5aBW1TMEuLAjOY2IT8NWUX0xpge1hazybeWEAJMb2BPKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These flags only track folio-specific state during migration and are
not used for movable_ops pages. Rename the enum values and the
old_page_state variable to match.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..0c6a0ab6ecce 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1135,26 +1135,24 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
  * This is safe because nobody is using it except us.
  */
 enum {
-	PAGE_WAS_MAPPED = BIT(0),
-	PAGE_WAS_MLOCKED = BIT(1),
-	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
+	FOLIO_WAS_MAPPED = BIT(0),
+	FOLIO_WAS_MLOCKED = BIT(1),
+	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   int old_page_state,
-				   struct anon_vma *anon_vma)
+		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_page_state;
+	dst->private = (void *)anon_vma + old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
-				   int *old_page_state,
-				   struct anon_vma **anon_vmap)
+		int *old_folio_state, struct anon_vma **anon_vmap)
 {
 	unsigned long private = (unsigned long)dst->private;
 
-	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
-	*old_page_state = private & PAGE_OLD_STATES;
+	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
+	*old_folio_state = private & FOLIO_OLD_STATES;
 	dst->private = NULL;
 }
 
@@ -1209,7 +1207,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
@@ -1253,7 +1251,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	}
 	locked = true;
 	if (folio_test_mlocked(src))
-		old_page_state |= PAGE_WAS_MLOCKED;
+		old_folio_state |= FOLIO_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1302,7 +1300,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst_locked = true;
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1328,11 +1326,11 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
-		old_page_state |= PAGE_WAS_MAPPED;
+		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1344,7 +1342,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	if (rc == -EAGAIN)
 		ret = NULL;
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
@@ -1358,13 +1356,13 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct list_head *ret)
 {
 	int rc;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool src_deferred_split = false;
 	bool src_partially_mapped = false;
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+	__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1404,10 +1402,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_page_state & PAGE_WAS_MLOCKED)
+	if (old_folio_state & FOLIO_WAS_MLOCKED)
 		lru_add_drain();
 
-	if (old_page_state & PAGE_WAS_MAPPED)
+	if (old_folio_state & FOLIO_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
 out_unlock_both:
@@ -1439,11 +1437,11 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return rc;
 	}
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
@@ -1777,11 +1775,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	dst = list_first_entry(dst_folios, struct folio, lru);
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
-		int old_page_state = 0;
+		int old_folio_state = 0;
 		struct anon_vma *anon_vma = NULL;
 
-		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
-		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
+		__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
+		migrate_folio_undo_src(folio, old_folio_state & FOLIO_WAS_MAPPED,
 				anon_vma, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);
-- 
2.43.0


