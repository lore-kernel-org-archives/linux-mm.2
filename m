Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CC20C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E106B00AE; Wed,  5 Aug 2026 02:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675A36B00AF; Wed,  5 Aug 2026 02:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C996B00B0; Wed,  5 Aug 2026 02:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2836B00AE
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:42:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4BA380397
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:32 +0000 (UTC)
X-FDA: 85066272144.23.E308076
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010023.outbound.protection.outlook.com [40.93.198.23])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7C891160004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=n2tDDe60;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnhcPNIeFNxUodYSdgpowZtRY8vOzvsSY6XGiEauKxY=;
	b=hiv10SRDItwYIMUVQuoVGGY7OyS+NJDFDNDMz5la8o2NgXaLJJoZiso+snluuYCfrI21IL
	rAStZ8KXdY9w79pooSRz555pUTqJkprVatjlBJJ07ZhVRo4PMSpdbKcdxvUyZ6kahTKmd/
	oNVlVl/bcdS+VwVHg/vfYe2mA6Mald8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912149;
	b=R1ZqoM/5h5Yg4QbjdAOkccbqFY22j1ex/bWlMQhHK721YVPVaj228r57dktgmdEzdD0Qzv
	HPFKVsoKpLx4Q3QY5NP7yMAPtXC2mzMV//uw05u6kCnb5V1k2h9uDhmpgAAy1kD/O718Wc
	H+3d4282TBXTl/ttIRxP2FmWLiqxqC8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=n2tDDe60;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YFmpx4iZTdVFKb2j+3j3f5SLwUAOTR2aheKAoL9mCkepHKIcaQueV/EpxjxcWD3CTaIVq6aC5WDATWS+mir3XyNr8X8tY5uXlA5MtWfmkg/OJqzoHgUbm/KqhkNEeIVsgedqF6gvxx6oDx+Obz3FcnoSd7n7S8C1q9Gt+TZ1bvBoL6qS50nTFVEs98DTQw/1eZdiZbs0PWL9oikHMLaxPPiFuIlpiX9HO9YVvC/R/511/rc0ncWaqlO06REZPbWTllgFaXrMtjn463DzHL0eDEfQ7DcKN4k7CIcBiHMwAkK59KmptagXbDHDiHcclx9L6dk8/UvkfoUy9bztIfDXaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EnhcPNIeFNxUodYSdgpowZtRY8vOzvsSY6XGiEauKxY=;
 b=n71HPipXB1ly9MNuptxT1B0SWdJZiOVs012rw/09w8DJjDZeAZPsrPA6C/n91JsvHUJB3hq+wMGH0Z8wQtUs1iy6CdR7vhgJ/UN7Rx2yh4xvJtJKEV5RDJe9UgUhnmBQYNaVkuijs8pCsi7vyjG6H67HhZ1qLpXvy2dVEvE6LeuvxuWQX5XFKnOt0F7BNmyey4IDg7n6GEj6bA7mIn4d2eGRXhvCq7GGa4ODeIBmAWgBzaxiFXcV+LeGv/lqdxm99nCKd9k7ctjC0SOEYA4UU2cuDwsOXw60MAY1jfVPV/x95o7dvfz5iMoscUE6cBMcprsTFUf70aqG9E2iOaUDOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnhcPNIeFNxUodYSdgpowZtRY8vOzvsSY6XGiEauKxY=;
 b=n2tDDe60cWx8akmqW51vKh9D6eWI356hjuWED7zflzZT76JQECpXk1Ms1u8xUV4ABeo0mWkE9JDQF2S/cg7jdkugoXXtbrjAu8VkO2Ib136YhWRzvVB5DeiS8n00hQz2ETtUgqHMNmWVMbhTD4qkIVn5dq9qQN8jJL4N0v+a8iI=
Received: from MN2PR14CA0012.namprd14.prod.outlook.com (2603:10b6:208:23e::17)
 by BY5PR12MB4273.namprd12.prod.outlook.com (2603:10b6:a03:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.18; Wed, 5 Aug
 2026 06:42:22 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:23e:cafe::52) by MN2PR14CA0012.outlook.office365.com
 (2603:10b6:208:23e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Wed, 5
 Aug 2026 06:42:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:42:22 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:42:10 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:35 +0000
Subject: [PATCH v3 6/9] KVM: selftests: use BITS_PER_TYPE() for NUMA masks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-6-00d8bdec4e1d@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
In-Reply-To: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
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
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=2319;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=QoGpca2K2qIzQz9CVG+OIW++7fyOjuSFlIken4lrZuw=;
 b=HlwIDg/sPwl77pxplq1ds5y8ePBb3vnB6VjW12C2wAxLXFoGUarTaj7kv7p/M5Li/VvJSKCWB
 JZfsN1ZnA5bAdetNYLadYSh5m4qoqkAZF/iyC+GeZaWAfUZdQbMO10Q
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|BY5PR12MB4273:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ac71140-e5dc-46af-ef60-08def2bcb42a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|1800799024|82310400026|921020|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3w+TDNeV5YC5VqnthjgRcLq3RtcWBpP12tpBSugp3PeWDFt6QQrAYegcuqhwUrn8I93CHqhg2In4rzQv59/FhnlFOCCkmmXpUzEzE4AcTYD/esT+7xAw60SXGdiA8xY+cuben5k/c/Of4lhgf3pS2CzBjejKZLdtdohapOHj2JmKa3YFs2jT5sACJB0TzyZPW8JkywmEws2xf1vuAl3EVGkGDybtY2shw8ZzNPF5qHpL+0l41Dofm5J/OoK5COqdCT8WAf3zbSmOsHvzJliU05UGgAx/5wZOEVner5XbzYhHOj2682s6JO4vgtMm0WTAmooiyfXb0mx2bmrXPsNIRsz7VuszfbxWWZv71YVHMiDAmiSQs18uue6xldzh3HGhzRIksMqHSPTiZ2pjNXiMCxRpG0KmQXVm4uuDzbvnrY/c/FdXffVrKjODLtWk3JHyRpf6K9bLUpcN/VnKiEly3BHEaAtVWJv3plVe3kwhfnPS7zy670owLGv6gX5hXOTE9isRFFc4a9XzGJ27JTtJFOlj/zlGk6lc4h3CFCJ3D5mi/r2Yd8p3q/MQDjVOgfH7s4tysAZoSOGc9VBtuHqeBc4MI5fj6pkh2lux3Xz4hlhqz59xyrSSv38IT4pE081l8zbULwGvHS79aVtZ8bApgLTWd/MqkCGAEc05CUzMJqbQF55XZlvzIMKzo+MxFsSXr0TstC9ieZ7A3qwiw+KMEzZTWZDmQZZM+zbAsb4ktOdL3BWalORqnqiWQVCxx4By
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e6rQ8/sqdhQW9WkiaNTTrtOxNSDqWADcrnR3URn2I7oX7zJ4GER0Jb7qSNxYeug92qknaWbX/IA6ZMCTlQ1fMZhUju3tRd4nvILkWvVL2km8zAQWM3ZK14sF1AHn9RCVEGDNN/OtJZ4BWRcCSURzcbv66ezFEolXoOke9aGvx12U48Kq8WqXd8cLCakO6/tvggO+uIFPVIeEokssaYpkhEEYmXLLz28BLt/nvKjGyf66vweyDevDMzbZspbbdW6hdcGYzDpUU/EkrUM3eC/OopJibdkcppfGyUYGhG7K4pQnlTouyShX97i8JiO/74/YSLMAN0COUR3qJIaoHqF2AY47QnaXhd9IQxCl6stD33oN/n5XBSd/kDCvsZyZansLrhonZso00udkz5RCiNgxM/jjVf6veIzOkIX261PKz4uToFGIMrJwzlzAYYzWWwFI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:42:22.3265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac71140-e5dc-46af-ef60-08def2bcb42a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4273
X-Rspamd-Queue-Id: 7C891160004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ehebcdhtm8zztr1x14gjsnsrbpwiwech
X-HE-Tag: 1785912149-988866
X-HE-Meta: U2FsdGVkX1/KVNWK6xcpmtH2pPtqICdMvct+qK2DAoNKoA7DK0BsxcJXXbEtk51DHDHF+gZ93mJkdxNKJjDhJzj/qcd83eO4aEgUQYFBMWiH2izmhh2n5ZiR36iyKCOkvX4YHlunsNtH//BX/QpH8aP8B7KUYclAWIMUwivMc2zd6spWj1eqPEA6ex7st/yb86tPXutpwW/M/Cgc1rVwjpvz+WKwgfbYEojESd353LTYzmoZCl4BPE9kpDcRVd9W0jYncZip/C1RSE7hUrADB0AWJZrhu7AOFRLwYPuPVzpj6rxjVmqyXSZijFWyr2JdY+bH3LdchtVgveLXqMo+xRS4HQq8aYrRYmAJweZVrhB3SLlH1ZtEdX3QEWdG6JRpRN/P0dUaGmHzxZlcctYSV4e60Ry7vPAN/ZvnAfJC9+K9fZsoRz2SZXmxTHGvT8DAYJ6RGCVXlYJm/CUlm05IYdwz+GCxos7C61EwG+qo6AbHmooSvrW5Nl0/d6KIzKg/TByFQvjN4owPzd1Tvmqzeon6zDl7syZP1h5q8fQbDugnJcBNKeXi/3CF+fJBJa7N+u6rohWk6Luzd57FiEGxRqr+4xqmXXJZAjxi3bJBB1ZnvupIemTIKl/aOic5Q24GyU6iKdeXRDSe0lgjSUz4WtvGQBLTxCMqSd3fQmZY++ZlYncA+k+375Kb+m8FYspGhlIN0c9dm97JRZV37u6IX4qq5itrneoxdK184A6GOlmLdyyN+YERyILiUHIdfv2i5H65UKYEXH3pxxZYn2i3FoGdYX0cd1yN5egBGy7jLUrNPf5Ue0pEtoVCts4lvOA2tMpZj8H53mf4w4pKqOBjq1uEUvX2QppJvshTQgTKAsiPSVAjv0Tv+Yd6bR3J0kZ0YRe8iZ82PFXySlW5ylZulNLAKD0AwRk2SYwXBwyeJ+zEiyPUFG6tbHhN9W5tZy5lJIfULfCW1jQPsQvU8cK
 jYiQPdzt
 WYnOgeKP9WRfQRCqa7EoBrhV7cYhCctBeiGi4WV53kH7yDgmOPs/Pzg7yLIBquMG/ge0MLKvo5mG2qQ+BF6zJeHkyaOQBiHf7c/tDQVHnbHSdF2rz9ubYgX9YWl6+CUKP0l6X36hwRclM7rruD7ndDmGW7KgXYvSc2q7fp7mKwDNp/7XgwndqGS5PKs7Y9Nujs7A4rSruJUpItCWChsl7JSpy2eE07Fhwbiqs0p+Aw/orywyx18H1URRyF88GKsVcdA3HvYW0by2a3TusYBwIQ1zbJ48a8Cd986/iL4QfpEGNOrhCNXQ01A6ud4LdGGLJKQKiUnD/dq5IpKOOYPL9Wg/vGuMNAbFg9N7fKMIa/dX2+ryq46O7dk6h62mmuWfGLbAVrYqHmxZdFNKJ9JW6fnXGBGhKLx0qw19mY9k2vfen1D6NPNh7+rbfs73VndTcvol9cZAYps8uttsgWS5Wom2rMFyk+WV4WltwnA7g6EfVh/dQrVGCM31kzAjfJZwtloF7z9JSIRNPhg8cLEVsVGdtfPYLSCE/8d626Ql6NyG7C/3Gty16T/DcUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded sizeof() * 8 calculations in do_migrations() with
BITS_PER_TYPE().

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 761e47e4cae2..769d8d95ab2c 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -252,7 +252,7 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 {
 	long pages_not_moved;
 	unsigned long nodemask = 0;
-	unsigned long nodemasks[sizeof(nodemask) * 8];
+	unsigned long nodemasks[BITS_PER_TYPE(nodemask)];
 	int nodes = 0;
 	time_t start_time, last_update, now;
 	time_t interval_secs = 1;
@@ -267,18 +267,18 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 		delay_usecs);
 
 	/* Get set of first 64 numa nodes available */
-	kvm_get_mempolicy(NULL, &nodemask, sizeof(nodemask) * 8,
+	kvm_get_mempolicy(NULL, &nodemask, BITS_PER_TYPE(nodemask),
 			  0, MPOL_F_MEMS_ALLOWED);
 
 	fprintf(stderr, "Numa nodes found amongst first %lu possible nodes "
 		"(each 1-bit indicates node is present): %#lx\n",
-		sizeof(nodemask) * 8, nodemask);
+		BITS_PER_TYPE(nodemask), nodemask);
 
 	/* Init array of masks containing a single-bit in each, one for each
 	 * available node. migrate_pages called below requires specifying nodes
 	 * as bit masks.
 	 */
-	for (i = 0, bit = 1; i < sizeof(nodemask) * 8; i++, bit <<= 1) {
+	for (i = 0, bit = 1; i < BITS_PER_TYPE(nodemask); i++, bit <<= 1) {
 		if (nodemask & bit) {
 			nodemasks[nodes] = nodemask & bit;
 			nodes++;
@@ -310,7 +310,7 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 		 * KVM_CREATE_VCPU ioctl. If that assumption ever changes this
 		 * test may break or give a false positive signal.
 		 */
-		pages_not_moved = migrate_pages(0, sizeof(nodemasks[from]) * 8 + 1,
+		pages_not_moved = migrate_pages(0, BITS_PER_TYPE(nodemasks[from]) + 1,
 						&nodemasks[from],
 						&nodemasks[to]);
 		if (pages_not_moved < 0)

-- 
2.43.0


