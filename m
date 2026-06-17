Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB53CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 10:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB12A6B0005; Wed, 17 Jun 2026 06:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62216B0088; Wed, 17 Jun 2026 06:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50AE6B008A; Wed, 17 Jun 2026 06:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 941C26B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:17:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0008A1203AC
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:17:52 +0000 (UTC)
X-FDA: 84889003584.12.26F7968
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011035.outbound.protection.outlook.com [52.101.62.35])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7AAEC0004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:17:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GfoUfGtN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781691470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYoLKD/Hq+RQogNkKKkiCQy5Jqj66QUmx0jTEOnqpUk=;
	b=GdF5durj9JIbn5vyCa/yKlASJqy8TOAJihKl03OL4zQddklDCmt2+1Ti1JSWEr1827TBir
	FTZxB9MGaCKOz6AplHhBjujmwPIis80+cGqAf7S67obmFMbC+PuaeTbM8NBa2jPwf+a+I3
	HKS82nWliAyNS5qF1J711LIX6Axr1p4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GfoUfGtN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781691470;
	b=oFqTAXNRWWALE1+zoHbEFLeM7xMWPftgO1NaAVeKpnYrWlqKT696168AwUp5JH6BgY9UfZ
	NOerGCwZOCoK8PJQ+zF2ScS91H6vGGKBngPF7bsD40xzfI+jz0w8i//5Cv3zuex65lrq6U
	rWWQ3LKetXJv47PRsWKj+gSZCwSgv4Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sm5cj6n7Q0W1og652BsQDyp3PsedO0nqG/mwo6DDebye6q5Pdk5pFJpCEhOZo4D+X0xgxrgJSXgYw0NG+gSv4GGfSfJ9mynvJGn04hBp6//B/D0M8TF5acllkmXotJym/OSAh0XMutzxIHYs7QoB4N9RRG18DPpHNivS3teIOHENQJ5XA/xClT6OpdYtKhR/ElgiA3lYpX3XoVw5IBGWTZmJVjWr61eJQ5rACVHog5iXP855OnxfFpbuiemZZKCa0wJFZt2VZr14X0hXjUCzTTGqW0qj86bnrb/yBD+H8UfoLit0+yKmjI7H/xTk/0wvKxeACrgv6/Ue3DBJGvK2vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYoLKD/Hq+RQogNkKKkiCQy5Jqj66QUmx0jTEOnqpUk=;
 b=cr9/ZVMo2euOKFmdc/hVStsfWoyRFVR/zegx1eKqljiYo1QTNj0bOTr/xecgpOaHPohPot09ToSzVutbMMpqdT2HTkIcbK+1lKaZ6IUgvBvL0dc7EP+9ulSFPnjeJ7tC3IkB3bSF1x1mLEU0F77SG08D+nOBFVMaIaNIFC+dVTa7YplyrPymVOjVnH8gWt/ZLL59as6TvK3huct0u8sXAi37y6+9wCKRdpHZlD43yodhCX5+j+FYnI0cyY3jKqE8oiKVgINrWVbxDA3yTfvusrxgOt0Qzmr7Rc8TLZKDFbab8wjCuTtEBD+yl6rrKtVFk6nLZqW3vTX9joeSyGQt1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYoLKD/Hq+RQogNkKKkiCQy5Jqj66QUmx0jTEOnqpUk=;
 b=GfoUfGtNQ9g/ycmLiIIn3n7YrxyLNJl7x1gowp+tBwFEweC5q1JfhSPLCODpXjdT6u14x3hmnChud/Jt9DRf+SxaSuM4p3VVSb+PIG4fSWSrtXkCrUJWSV8b3oT7dytqSNgdb+oBltbxcwCe5p687fGFQZLIf1h20dkUKhtBKLI=
Received: from PH7PR17CA0037.namprd17.prod.outlook.com (2603:10b6:510:323::28)
 by LV5PR12MB9755.namprd12.prod.outlook.com (2603:10b6:408:307::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 10:17:44 +0000
Received: from SA2PEPF000015CD.namprd03.prod.outlook.com
 (2603:10b6:510:323:cafe::44) by PH7PR17CA0037.outlook.office365.com
 (2603:10b6:510:323::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Wed,
 17 Jun 2026 10:17:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015CD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Wed, 17 Jun 2026 10:17:43 +0000
Received: from [10.128.112.233] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 17 Jun
 2026 05:17:32 -0500
Message-ID: <90768c5b-2268-4faf-ba0c-27245d73a0d0@amd.com>
Date: Wed, 17 Jun 2026 15:47:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] KVM: guest_memfd: folio migration for
 non-confidential VMs
To: Sean Christopherson <seanjc@google.com>, Alexandru Elisei
	<alexandru.elisei@arm.com>
CC: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
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
	<tabba@google.com>, Vishal Annapurve <vannapurve@google.com>, Nikita Kalyazin
	<nikita.kalyazin@linux.dev>, Patrick Roy <patrick.roy@linux.dev>, "Pratik
 Sampat" <prsampat@amd.com>, Ashish Kalra <Ashish.Kalra@amd.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
 <ai_XK__RTXMCEcCG@raptor> <ai_aczmeH2IA6JaB@raptor>
 <ajA4z_Wkb93cTW4m@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <ajA4z_Wkb93cTW4m@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CD:EE_|LV5PR12MB9755:EE_
X-MS-Office365-Filtering-Correlation-Id: 247f7d63-bc4f-467d-7fd4-08decc59abbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|7416014|376014|23010399003|22082099003|18002099003|6133799003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	4eNayiqcVY/u2wMyFEHSfItQDnw1id3GvmZHn/xDoItXXYrr8MMFLpmxk5ILgbkomy7CYgkPa99/tmdHmz20V5aMkCwf1neQm6yOlZkp3XYIYzU6er7PY+W9YCIX4IusCdXQhLIr+Ra1Dv1h6d20BpfGcnOw+dU1BwBJbiPu85+M4ks0AayqDX1XU7CtxJj4Hpta3n1UEtNozE0UN9oV1rUFeYi5q1SZjQeFPDrKrnDemnU4a7OaSoKTpvScQhfDUXGzAkkZ9hCXWUzUKO6Dt+cb3ECcyrGYctAE2JUJnCyrR/oTxO/7D2bO83DWkMF/H3GP438XUOfTNCHLEucezAmU/M6MXWCS72bi9C8E/Lz+ijAnqnaF2SbhztW+3zdx59BAEVXBL20cSNSnvixFxY1VTUjuuPTIEhYBDDpgPCZnMUGJttnvdSbiZN7NJKL/wUpk3XrQf9fwbOBg4DjncPVoOqnydE2KZLGupZ9I1fS06hRr9CgfmZzbNFeGczxIm0tU518vgHuw4XwEymyyd28KsbAtM7XZmfFyI+TK9Avf0nHrk3lLMLG8/msv0aZ3pCDetNqng8mowg5vTaSyme12FxCYtI1eEwL5Nj7xmGQ59UZ0cENhkBQTBOXbIMuB4uOEe/TTEVtrEskCLSp9M0FCb+KuiAHQY1HHFNSf/FX10QvUOB8+AJDZ9JREsHPauYLpr6NFzp5ur139cGlxtFHZpFqqfK8FSspSeKiOX9w=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(7416014)(376014)(23010399003)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2NC22HYElG55apYsrlgkl/XXTG/cKWaupwzDwXycqBkrEk10ziEzp3p06ESgg6vhpO4SpoYN+R4y7tCXEZ+ayCLqt6BFhxpit4hqcGvniEkQpYsI/L9Ecko/7jnlhYH267z6r4CvY7+r4TFA2d/anbJINsuvB/i297TvZ0knCPiy2E3rxNFAsfKFJhQrxnE/SMy4BDMFfQ3ahc51B3kNZlIt38OiH4sYTnZ67LCH0CK7iFlsT2FkeSwoUCjWtUUEMjE+fk9UED5XSjd4Xb/kc44QJ61/96r4FkeZy+PX+LcXsEeo9rd+bBZ+IOv0P7RFDNJjQp5wDmxBvGDeojZq0CzMDgVSTaE2M2L5PtK4gQV3Uhls/VVOrb+qwgddNYCaM6LKmtq4FCyKqRfDRC5mgAEFWJzxMeuRAtS6mERIGyZeVsq6hvjGYsKyUiqs4O6x
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 10:17:43.8020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 247f7d63-bc4f-467d-7fd4-08decc59abbe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9755
X-Rspamd-Queue-Id: C7AAEC0004
X-Stat-Signature: g8bcoaa3ipu9dj9za3tciaozcuwyr7nr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781691469-727948
X-HE-Meta: U2FsdGVkX1+VNquQnCz4keU20sPRWLG8GVr7TROB4g5ROIi898kKtCK2r3K/ZYK9S5mNyfbd0oIczh5qYCFuLiYUVJlMpi8cds3hrWxlhgCiO52Abjywtw2l+OjiFEnwQgEUC2cwkJn2W7nuTwSu3QW9iZMiAxqyhEzFJqp/wuUPw6AqSI7aVogrVsEWR2RLf2ESJsNVbFOKLJ6RxQ6r4bsYa6nhgXxZ5NzjctWKiuUl1xw2wJhBhPjX1SrfHdto7LekeAevXJcmu+FLn3TWt9GN69iPVZGXxcXZol6Cu2Z+0qTd7W6WBL8tfJaEz5ilsAvJw0wjn3QrHFTiqpx/4w/4oGBsQh7acJiOQOs3hFowQLYwCPBmHcLqSAbgkQpFghX464k6XztU4gTlKsWK1XaXdlrz8pLF2i5oNl024N/PChNm82cTvNMbew2+DRR9E5TzjquyQuHbuGgy+0a1dz5NAn8uCWWHpPivdPx9E9OmFCUO/jemKRwzv3eMGOkxmns/DZBCkb2u9nM1a9R9TtTHVsHc0lEFVP7Gu372CVoSXQTO81c+E77g7/W/3r8vjREjsKD3USiBndZAcFW8UiZWTOelHPOTu3s6oOTpJZdvP8eUZzKrpbAgs9MXNsGVBQo3oi2xI9SjujQE40YQYDLb3iD/t9jyI3gULSUdT2Zgz86pYucty9PMwbJaHaIBc/q+zGYRTLb7cIRmDgt5d9wPt2gVeRABSp7nrWaBKjdhagIuEJwmK4a+Pff0gCWE5cJeavn4gt6OPZcV2JJ6lGpI7ktA/vranERclC2s+mj9WTXXGDw6VAbGPnlQNz8ON3Bx7H0obqv5FzToCfVI08VYqtes9K0gs8Iw3PP/dC9DUnCFHbTzTqNl8s+xFvDgz7ZnUE8eOH4gvFtdu8274n5XTTAoqh7jhXt8MS7CMRkz73Md78lGPq3xwCCjAtAVFpHuqCkTug2R9poxJR1
 DmKyoSBs
 nVomjdN86nrV36A/9CLUcGiQhzbFIOpYNoUtb1wzK+/dD1q63ohebC8TlMusJ/l8D5SJcCiUAIIYvQN1IlI5F1lsPVPtrKxkg7mZ4j+TIw4MFRnW1YUztbiywiyzWNZLV7RYJsU8IFMUCtO7r2prpB4oMHtA6K/aJHeB2lKrbCDDGt+df/JGkKCJQyxE1ZBHtgxLzAkg/6Oh/fZjzLxPik+by3T5UpxSaGG8CPQprSY2eAOK2q1rYmUVzWQHqYt33XPwMZL6asijviiq4bZyTLJkd0rLy4wlFl4j85G6e94oFF/+ITgiPznJShduh4qPVScDgsKBs/Z7Rk1NkfB3m/XV4hg5YQZEc492mF+8PlWC1VBB3l8CXcJqEx07oZvQRfuxR/aJIZ/oQ9s64CrK1ru3sTc1nUVpVXQ3WDxFoDF7uKmcLZ0heAQ3Dscn7Oyx4k+gYnP9eCbHuPOTh1QqWPAaa3zzDRsN27eF3TTGssn0iU+QKmmhm6hiCerjYGNcCPFqsmHgVZi5D1wzR9SxOqIG/oeDLvAsFECvVLyNsseWIJVudcMFCxxR0IKGIh9uSgPt7VBsk3ZmnGgWMDQRjna3c8aXbyTs1Uk4PCGntu7kMrQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/15/2026 11:09 PM, Sean Christopherson wrote:
> On Mon, Jun 15, 2026, Alexandru Elisei wrote:
>> Hi,
>>
>> On Mon, Jun 15, 2026 at 11:43:14AM +0100, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On Thu, Jun 11, 2026 at 01:05:07PM +0000, Shivank Garg wrote:
>>>> guest_memfd folios are currently marked unmovable, so the kernel cannot
>>>> perform NUMA-balancing, memory compaction, etc. This is unavoidable for
>>>> confidential VMs (SEV-SNP, TDX), since memory is encrypted and copying it
>>>> needs firmware assistance. However, for non-confidential VMs (like
>>>> Firecracker), we can migrate the folios.
>>>>
>>>> This series enables folio migration for non-confidential guest_memfd and
>>>> also lays the groundwork for migrating confidential guest_memfd later.
>>>> Once firmware-assisted copying support is available, those VMs can be
>>>> made movable, the confidential folio content can be copied separately,
>>>> and the destination folio marked with FOLIO_CONTENT_COPIED so
>>>> __migrate_folio() skips the host-side folio_mc_copy().
>>>
>>> I always thought that one of the nice things about using guest_memfd as a
>>> memory backend, as opposed to host userspace mappings, is that the host
>>> cannot unmap VM memory because of KSM, automatic NUMA balancing, hugepage
>>> collapse, compaction, etc, acting on the host userspace mapping of the
>>> VM memory, and outside of the VMM's or KVM's control.
> 
> +1000.  It's not just "nice to have", it's a core design principle of guest_memfd.
> 
>>> I think it would be useful to preserve this behaviour, even in the absence
>>> of confidential VMs (i.e, guest_memfd file descriptor created with
>>> GUEST_MEMFD_FLAG_MMAP).
>>
>> Just to be clear, I was thinking that it might be useful for both
>> behaviours to exist (migratable and non-migratable) for non-confidential
>> VMs, and allow KVM or userspace to decide which they prefer for a
>> guest_memfd.
> 
> For the purposes of this discussion, we should separate the physical act of
> migrating pages from the features that trigger migration.  As I said in last week's
> guest-memfd call, I am a-ok with supporting page migration as a mechanism, but I
> am dead set against supporting NUMA balancing, KSM, LRU-based swap/reclaim, and
> anything else that goes against the goal of guest-first memory.
> 
> If userspace wants mm/ functionality, then use anon, memfd, hugetlb, shmem, etc.
> 
> Shivank, what's the immediate motivation for this series?

Hi Sean,
This makes sense!

Tbh, my main motivation was to start a dialogue on this, since the
implementation+testing itself was easy.

Compaction and memory failure handling were the cases I initially
had in mind. And as David noted, ZONE_MOVABLE/CMA, compaction, memory
offlining, virtio-mem cases would be useful too.

I fully agree that NUMA balancing, LRU/reclaim and etc. features
should stay out, and keeping the migration as mechanism only for
guest_memfd.

Thanks,
Shivank

