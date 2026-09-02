Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC805C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDF56B00AD; Wed,  2 Sep 2026 06:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0436B00B1; Wed,  2 Sep 2026 06:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE2A6B00AD; Wed,  2 Sep 2026 06:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A45986B00AE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:53:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AC221A0186
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:53:07 +0000 (UTC)
X-FDA: 85168510014.25.7082584
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013029.outbound.protection.outlook.com [40.93.201.29])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7DC6C18000A;
	Wed,  2 Sep 2026 10:53:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XLlHDOjW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.29 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opo4fFYNUWbP/vzFTuX+fFp2clt1D0XJJIbeiibySew=;
	b=UMd0s0w52vKI1WE8G019mXmDgn80xm8H4uFWbBxOF5yBx1nOtYtEk051MpZ1h0yfh/9fMG
	QFzQa/ajdk/afbdCAJ8ur63ct0Y9QC4dm8hSHRM0tjWNJLIweNHxZiOo8hDjRKGVblSlRn
	Ae9JWM4MXV/+arB97YeFxrFNXrsHwZI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XLlHDOjW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.29 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788346384;
	b=IvW9mArS00gh9BWngBATEYv8/Tjd5aePCXnditbgUfHHqGcOBucoR6EtZ3bdiCpngm47Rt
	uf0HddRm7BkJr6YBP1wcm5SPLeQ5hSDfstbiPzCKWJ7K2S8kxcKI593FMiOZZUVvOi4oZK
	/8eXTgYY5gQvrSFIKkXEf71yVoxfyng=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJh9Jt/GduqL6wt2A/iILGVsC7xDTYhwLbkhxfj3E4ZLpbS/w+rCBFeN4/7pRmNbTqaJmxJGJR0ZETGJz78zBdWDUs5bIy2u2B82Hb4LLVqZfCpQLZxNio4Z0pHbej2IcxrpYzqhIGPOiw9DC1Ij4xr4U/68N77ogd90QpX69ZLnHmdfEnOwZoB9H5NuyNudeeePeiIHBBHDcE9QvJCNVsM+iqVb+D/EAu3k8oq8aTi6LirzbaC3A0bH2u08U6wcLpmP3b02zfHrCVMPljBIyPMwmPxs0b4317M4K8TXCBnseS6ciN5+jVStb0UaTAkU3HrvPYxsVVqC9BQBriongQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opo4fFYNUWbP/vzFTuX+fFp2clt1D0XJJIbeiibySew=;
 b=T8HTyA+5TKNP/KVu2uxwHMQnH7DO6MeKcYenVc4SARRXW5KEqFqMFuovfE7yMru98IU/nAC2e5gmDEHQBL9oGpDTpieOz5AokjSHCIhoz5O9Ma1ddki43s6UgOIgi9/syVDP8ywDnliLQFIDeSiGa+552rTRe0nYnPbsOJhhfOw6KXtCgJP1YOIf/FLY3Gt2TVCxjt5qT5iLL8Hf0COzUq/yhdFa1kSZHIogA7066+nTkZ/42+8NjoNc4dkp6xdl4uxMgocHkgcfOQRrJ6j/PcfIVqEUVHCPcUsGhnty8LRKBkkJ5Y1ZSpa7WyrdaM0/CxT9c9MKrkRTI3REmMLdEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opo4fFYNUWbP/vzFTuX+fFp2clt1D0XJJIbeiibySew=;
 b=XLlHDOjW+SzKYn5qwjMuUsH3dQCZpAPU0fJCV6XNozjDOuBewdZI9dGiuNIiEWD2E72OEWyZmyvLSBR+ZvobaY6cVxuxNeXw5HMb9bWGDlD8i9Q/2mLdMTJT5G1HGYjoIOnMedNUL1/nWLmpcAk5ry4lSsdKdYGrJSBH8w8Ow8I=
Received: from BN9PR03CA0043.namprd03.prod.outlook.com (2603:10b6:408:fb::18)
 by LV2PR12MB6014.namprd12.prod.outlook.com (2603:10b6:408:170::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 10:52:57 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:fb:cafe::21) by BN9PR03CA0043.outlook.office365.com
 (2603:10b6:408:fb::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 10:52:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 10:52:57 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 05:52:42 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 2 Sep 2026 10:52:15 +0000
Subject: [PATCH RFC 01/11] mm/migrate: extract folio unmap phase
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260902-migrate-refactor-shivank-v1-1-9dcca87669c4@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788346348; l=6697;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=8xeFRHABNScN0jpjYHKuyRPcy+HQ6Ma6c3BY2BbVZAc=;
 b=axPoZ3keUNUxapQCqastHA9QugWbwkleGKZRjhNsPoKYn8kDP41y1DN2g9SXNf+DJH0JJJbmx
 RB2vCPFbJSrBjvmI/RWEZSRrX0HLun0BCdutuAoOAyTxbouo41giDlW
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|LV2PR12MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bbe204d-9562-4505-b567-08df08e05955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|36860700016|82310400026|1800799024|11063799006|921020|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WbFXNrJu82ii08KVEh1bhu6CjcYUu57L4yGygaGeCe+K7SIqhjpSLgMMk2iqYrBpTKqQH6OoE97ay0mtKLRMntAZ5/eZFbMxcVye1qOa7D87d5wn3aDT26qdUF5knkBLZEkC9ciRa+mZIv511t00J6nnDptZb4ZgfPO+AnfkjApAqM8zk5jROywwFKoLR8bf0MLHxvu6WO9I80RqvE15B+yJU5N1PXwtp4r071vitaqNJuM2B0PrmlApIN/ih+w6mRsRQFbLNum0OCW9IrD5qtNGWS5gNPTi3YylYdU0N29meQ5kmjleSJCdeApfop2CvqFNc/v4/2dGFGTYvoEWQn+J4AGkgqNtVyIIAaKN4HUQNiDoMWTbcGg2tvkrYOVKY832rtHQpYheb2IcspfiBiYspdXZp4QslFdwOJrlLR202S6NC+wfnVpMAG1Bf5RxaCsH9ObEZZ2trggAzmYhTgK72G8RAuDCOiRwZArksTFXqN3eGdTpK5rKgvDlBc6T1JqZlXrpGxB7YA3LyMspS3fAoC9Zc9WKYLC+TM/hPx87KA3yz76qGQBvPltUSv8xyIjEml+0TEN4POhhaSiFDMW/svzQSxUN/Ny7geHqORl8s48pwR3QI9/03XCoX0AqU3h2p13J/9Woaw8mrbPfFfuHncbTv1rQ1T67XILzfOsxK5UXx2+/fmWoMXRhSqcY4Fld2mUh2vhg+nLHFxp2SXfyPv60uzTAZiLsOkw9As0rCYBKhZXWjFMo25kUUthJ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(36860700016)(82310400026)(1800799024)(11063799006)(921020)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NsmhZT/F2qLzsgjoW0FnfUdYJa+ezpTvcLgiozeHpN6cqQjcZx0koMUahi90SarJufnyqz84wZnYsknZBWNZN80NBEIbBKVxqbZnLB9WtTgP89Mm3tFdm/axcDy+7XxMSOls2YinkOyaBdInAnByQXy6TAA+x/twLQ68exaqZEZF++s1OHDT+6SR71/EjjNAvLDqYCTpAkQ1/KrFnxEw5a9/jVHomH/u5MfDSb0QMSHgRqCQfEXKuCl2u11x/Y4cD11yiXxknzgM3S26xTLtVIKbaxaAyiTH4IZDG7u7s0jM27vvx/jdAr0PM0ODe0DGMgPAEmU15lm48PdYnanz0Iw7buvzm8jLZYl7IQeJj4ug0/efiCy0GshZ/uVJ6GiIhFmjuIN9KNGrBL/O5PhZwRiTMdLsMV7zTEyAH/K3edJ465VXAXCQHNZIP668yEbd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 10:52:57.3962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bbe204d-9562-4505-b567-08df08e05955
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6014
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 99q5fc3cz13as1jrrkocckegt4r3ioaj
X-Rspamd-Queue-Id: 7DC6C18000A
X-HE-Tag: 1788346383-198547
X-HE-Meta: U2FsdGVkX18wcGH3yVtXrS3dsZSUNblZdHX0ActEMU+pML4s/+auzqiKNtgutoRHilQkU48TjVAYs79F3YRzHN1qOvu/ya3gCsI4JGE9qQTqnRHra4RcHc2IQ2otZ1y1hHPkWy7kHuD3Nseo2u2gfsIfsZ+od9914XMf+Un+otK0lPxGPKFdXtOphOKPA5UpAmR/14OIguVV/GySZB85bIjK/HHn9x0JspoKQiNBCSBwUXTtoNspj/1FxFmBoSwbrNtr2zY1nA6ftJ2uQ6YWWyq64CNVboLfn2MwB7SPnyKp5otllbgX3AuX3VyBBexXNxcustIZYyO3be66qLDGoLz/F2OUR+taVVN/mjb9QH+1ZWlW+hlc2foh/lgsRf0qWj552UFl817uV4lq/3lce5YIP4pZccmEWijZuIiL+uKIIl0Q99noQJltrfykR3GQUEKDigX8Uf2xEmiG/jcioVKRexrF4ip1P4ihbwN6go/Q8Dink4naFi5JOJTHoJZ6PvLqw/VrLJTa0XjigAEXITgqi3SL4aMWmcm2VzBKKK7K+u9MgqU7wKczeVB/2WW7G1Ip2LdZMg/tXPDpchFzB1B1STHfTsQWP8N8F6I4CheyyrjA4abJOSwHbZqqJ26yO3LxVJDxgZMeAqYM2opStnnatlgqcg2JshJKcuFJX4hZ11BsmdLA0yR/JXWl1KNK8xvvRe9UxpGSc3armKTcRWKuw5Rym0JATDTzPfrx/CD/EpAaBqn/UftviysZBzk0qaL6x3MK517VLmBPmmsjer5EbZCKKbwSsio7kld6evyd83mQs4wY+aICrg70AnQIQPUSiqwheXohQcx0JfHV4Fkt1yutnoQldH7jGbi4/I+tMl9bK2G6sA7FU6HZR515keH46/dgqN1oME+xqb/xm+seDBDpn3bLrJcblF90jmrhqULvADSoPBJ4B7EfxuEtfRzsjt/pGGjCt/JtAVK
 BjK4z/f6
 3lVJDCRzfoQM4u18bPQZIllrGO62FD8HRCxHHugXYn4SMjB/YjpFEG8W3TYdJ74LhdxqkyS+oP4y8WTR75A73Nvioboany4R6PtuzcyW3Up1rR+QzJzZivxsGbdfODeOb5avP9Kp1Euo2cry4IGoWrRz4e4SZgkAmfTt2sM0pxp5hQZ40iA7uB8I40ebt/4g8pqFYd5jkeQYlmxUlh6RNQohoS8n4/NTdjh+2zeOIwQs8dYpdcE5PkGTG+5F+GZOL4mH/BgmTS7AtO4PXpuH1k6kfzcm5L0mt7MVmUIYTp4LnqFvhBOC9SxgRA/uNxJywedxZn9wulNQwtQziejp6aJLbuvZ46lFrk0cVzkOlog7Ptj3JzKtW6qiyllU3CUbHHghutAlTc9IsRbz6+BUq6c7KyZiH5LQIAA8FDMfn50H0P8dpOfsvEh11SZfgnqjxNilPNr0tPB3ya+p3RFo8ZhQy0hr2Z45QYhw475idUX5LUNQouFPJQNX61fKXv3pWv3kCk7Pf00n671N1Uo3GBWJbigu/GwTSuR76
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_pages_batch() was hard to follow with the unmap retry handling
inline alongside TLB flush, move, and cleanup. Extract the unmap phase
into migrate_folios_unmap(), which fills @unmap_folios and @dst_folios
for the steps that follow. This makes the unmap phase boundaries clear
and the code more readable.

No functional change intended.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 89 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 30 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..14a0f84009c6 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1800,36 +1800,30 @@ static void migrate_folios_undo(struct list_head *src_folios,
 }
 
 /*
- * migrate_pages_batch() first unmaps folios in the from list as many as
- * possible, then move the unmapped folios.
+ * Unmap the folios in @from, queuing successfully unmapped sources on
+ * @unmap_folios and their destination on @dst_folios.  Increment @nr_failed for
+ * each failure.
  *
- * We only batch migration if mode == MIGRATE_ASYNC to avoid to wait a
- * lock or bit when we have locked more than one folio.  Which may cause
- * deadlock (e.g., for loop device).  So, if mode != MIGRATE_ASYNC, the
- * length of the from list must be <= 1.
+ * Return: -ENOMEM on destination allocation failure stop the unmap phase,
+ * otherwise 0.  Folios already unmapped remain queued for the move phase.
  */
-static int migrate_pages_batch(struct list_head *from,
+static int migrate_folios_unmap(struct list_head *from,
 		new_folio_t get_new_folio, free_folio_t put_new_folio,
 		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
-		struct migrate_pages_stats *stats, int nr_pass)
+		struct list_head *unmap_folios, struct list_head *dst_folios,
+		struct migrate_pages_stats *stats, int nr_pass, int *nr_failed)
 {
 	int retry = 1;
 	int thp_retry = 1;
-	int nr_failed = 0;
 	int nr_retry_pages = 0;
 	int pass = 0;
 	bool is_thp = false;
 	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL;
-	int rc, rc_saved = 0, nr_pages;
-	LIST_HEAD(unmap_folios);
-	LIST_HEAD(dst_folios);
+	int rc, nr_pages;
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
-	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
-			!list_empty(from) && !list_is_singular(from));
-
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
 		thp_retry = 0;
@@ -1869,7 +1863,7 @@ static int migrate_pages_batch(struct list_head *from,
 			   !list_empty(&folio->_deferred_list) &&
 			   folio_test_partially_mapped(folio)) {
 				if (!try_split_folio(folio, split_folios, mode)) {
-					nr_failed++;
+					*nr_failed += 1;
 					stats->nr_thp_failed += is_thp;
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
@@ -1888,7 +1882,7 @@ static int migrate_pages_batch(struct list_head *from,
 			 * list is processed.
 			 */
 			if (!thp_migration_supported() && is_thp) {
-				nr_failed++;
+				*nr_failed += 1;
 				stats->nr_thp_failed++;
 				if (!try_split_folio(folio, split_folios, mode)) {
 					stats->nr_thp_split++;
@@ -1925,13 +1919,13 @@ static int migrate_pages_batch(struct list_head *from,
 			 *	-ENOMEM: stay on the from list
 			 *	Other errno: put on ret_folios list
 			 */
-			switch(rc) {
+			switch (rc) {
 			case -ENOMEM:
 				/*
 				 * When memory is low, don't bother to try to migrate
 				 * other folios, move unmapped folios, then exit.
 				 */
-				nr_failed++;
+				*nr_failed += 1;
 				stats->nr_thp_failed += is_thp;
 				/* Large folio NUMA faulting doesn't split to retry. */
 				if (is_large && !nosplit) {
@@ -1951,7 +1945,7 @@ static int migrate_pages_batch(struct list_head *from,
 						thp_retry += is_thp;
 						nr_retry_pages += nr_pages;
 						/* Undo duplicated failure counting. */
-						nr_failed--;
+						*nr_failed -= 1;
 						stats->nr_thp_failed -= is_thp;
 						break;
 					}
@@ -1960,19 +1954,15 @@ static int migrate_pages_batch(struct list_head *from,
 				stats->nr_failed_pages += nr_pages + nr_retry_pages;
 				/* nr_failed isn't updated for not used */
 				stats->nr_thp_failed += thp_retry;
-				rc_saved = rc;
-				if (list_empty(&unmap_folios))
-					goto out;
-				else
-					goto move;
+				return -ENOMEM;
 			case -EAGAIN:
 				retry++;
 				thp_retry += is_thp;
 				nr_retry_pages += nr_pages;
 				break;
 			case 0:
-				list_move_tail(&folio->lru, &unmap_folios);
-				list_add_tail(&dst->lru, &dst_folios);
+				list_move_tail(&folio->lru, unmap_folios);
+				list_add_tail(&dst->lru, dst_folios);
 				break;
 			default:
 				/*
@@ -1981,17 +1971,56 @@ static int migrate_pages_batch(struct list_head *from,
 				 * removed from migration folio list and not
 				 * retried in the next outer loop.
 				 */
-				nr_failed++;
+				*nr_failed += 1;
 				stats->nr_thp_failed += is_thp;
 				stats->nr_failed_pages += nr_pages;
 				break;
 			}
 		}
 	}
-	nr_failed += retry;
+	*nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
 	stats->nr_failed_pages += nr_retry_pages;
-move:
+
+	return 0;
+}
+
+/*
+ * migrate_pages_batch() first unmaps as many folios in the source list as
+ * possible, flushes the TLBs, then moves the unmapped folios.
+ *
+ * Only MIGRATE_ASYNC may batch multiple folios.  Waiting for a lock or bit
+ * while multiple folios are locked may deadlock (e.g. with a loop device).
+ * Therefore, if mode != MIGRATE_ASYNC, the source list must contain at most
+ * one folio.
+ */
+static int migrate_pages_batch(struct list_head *from,
+		new_folio_t get_new_folio, free_folio_t put_new_folio,
+		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
+		struct list_head *ret_folios, struct list_head *split_folios,
+		struct migrate_pages_stats *stats, int nr_pass)
+{
+	int retry = 1;
+	int thp_retry = 1;
+	int nr_failed = 0;
+	int nr_retry_pages = 0;
+	int pass = 0;
+	int rc, rc_saved;
+	LIST_HEAD(unmap_folios);
+	LIST_HEAD(dst_folios);
+
+	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
+			!list_empty(from) && !list_is_singular(from));
+
+	rc_saved = migrate_folios_unmap(from, get_new_folio, put_new_folio,
+			private, mode, reason, ret_folios, split_folios,
+			&unmap_folios, &dst_folios, stats, nr_pass,
+			&nr_failed);
+	if (rc_saved && list_empty(&unmap_folios)) {
+		rc = rc_saved;
+		goto out;
+	}
+
 	/* Flush TLBs for all unmapped folios */
 	try_to_unmap_flush();
 

-- 
2.43.0


