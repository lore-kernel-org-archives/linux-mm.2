Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5471CD29C36
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31256B0206; Mon, 19 Jan 2026 09:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836BA6B0209; Mon, 19 Jan 2026 09:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E802A6B0204; Mon, 19 Jan 2026 09:52:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 707D36B0206
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:52:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42C2B137F39
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:52:04 +0000 (UTC)
X-FDA: 84349003368.17.D693F10
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id A8593A0009;
	Mon, 19 Jan 2026 14:52:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kSibtHms;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oS6r4VD8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768834320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2K016m38mdEV/RNOqirq0/F1aHvQZr1QbSBTNZ2dIE=;
	b=hDKr6SJ2eQzWdCHnQuyrxHCog3NE/JGd0kI5QdRhwDrj+Id0EKExk+3nh84H6PSnvDNxvQ
	ZLiybGwyaH6e4xzBVo1/t7VU7x+9QlLHw8/hmofzW7VNFmOHzeEFEj1B87mgVhmokL3fTl
	S1EGZLk4E3GTt00fryPQb74HAc3AlnE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768834320; a=rsa-sha256;
	cv=pass;
	b=bBC3WbvO89CLDBpmlVv8FJGcNGkDkNL1BZGCG9x09r5uJCG+u1XgoHaskEtEv9HeiJmpCY
	ukzB0ueMkwPIT5VYE9hGRvhDJAYvmHwRdIxXvu45FRfWc1NAMtXLigp+NrFkVhVfok9C08
	Mu0kl1wQAH1hl/pTOWuIh6J+oT5iQB0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kSibtHms;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oS6r4VD8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60JBDNPl1512384;
	Mon, 19 Jan 2026 14:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=q2K016m38mdEV/RNOqirq0/F1aHvQZr1QbSBTNZ2dIE=; b=
	kSibtHmsRHP3Sw+RqAxkuIZ29lJQTlsEsNcGwMlSO8LdYHCoFULcvTuQwB+l3nlA
	PS8TS7MJWBdJkOVNEuxUmxFPrJJ3qniIjsjMr3fz6lwR4GJP4r6PYP3NADlEeIQK
	f5R2z8pvk/kj/gBq3QdN3TqPR2fQi8m2kWcxZrYMI9X3JU75cDt96IZP6ZZh9Yrq
	ZJs/BNXwrfZ6xUEK6lMh7eRldG6+S9WjcW2cOHXvQDI11BtXhbt2u7oYwgD/lVsa
	mIuFldoMVsPRePpfjsTMbkt9+9QNRS6y4NbvqLWr1yeJsuk1btL1UcI5Iwzv4BsU
	+9opBvOsGX+VChHFRu/hKQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qachg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 14:51:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60JE1tPQ000505;
	Mon, 19 Jan 2026 14:51:34 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010062.outbound.protection.outlook.com [52.101.56.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vc84x5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 14:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Idwws75RdeU5JLV+b6ydBka+I/hGjIKjNG9HlhiSFzHMa3e3h7IduGMwPg+eDiKM2qFj61c+dMea+VbOhojkWgHN6uSEkVwp9hvSwX9w9TsuZ4zjyj5t33mUiSBSKHArkpJTCFULpkOHESuLJNmc0ltLLoxLsdt7e8EOf664objCfy9FKPCyEOMOcvSD7Fg6ftGxOsko9Pj8UQrYeB5Ql/qyBlCxASZq6ai4A9a3SHyCX0zpUAbes6HTngQObP+/Em3978ZiJRLQQNnCAJkEMq/mYByFwRVbENyeASLgGU+7uBTZGCbHEcCN/6tr8L4Fq9qk8UIzjza+40+XfGLa1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2K016m38mdEV/RNOqirq0/F1aHvQZr1QbSBTNZ2dIE=;
 b=oJRefa+gTx607r+zzJXMNWZvEO4XvyX7W6nEVKWVwqoIX9Xk0U4wkHxYBwYHb2Ko3lv2Hwlq3J4XU+tCiOLo1UaWATtPOGUxnZx/HzAqOFmXrwbqr5iAab4xld76a3f1zP8hYwYJoLFqgZAOttDXjJfsz3EfPFRMO8KPDS37hi59LpHCjCPXhkgrFZ2SVbo5VuI4ov9SOCzCZBfui+Qr/u/1NOBOKRy1sRSvxjZpAG6SyJg+PoX3RbU+VmK5sh0yWG2QfMPbNFkvNWplq/DdvTioyH2ElfBD6RfcVmr690b8qAKuB+zOkajoxLbYIcQ55YvQUCCsi9rhN2v3mXIuaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2K016m38mdEV/RNOqirq0/F1aHvQZr1QbSBTNZ2dIE=;
 b=oS6r4VD8AIxc62mXT7dB4ZJ8AysVXLO5EwxoiGtQn5n4M/OUuvTBphLEitI8OgcAt2aLBUed2EYcR2dTmsOADb1IxRXIhEJCMice7OwaIyw5vXySV/prSEJrecUWy1TVLQfdg2ONAPJMsk2NPWglmsk2wOyAfnlMDfU+rK7r3ds=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS7PR10MB7300.namprd10.prod.outlook.com (2603:10b6:8:e3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.12; Mon, 19 Jan 2026 14:51:29 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 19 Jan 2026
 14:51:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Benjamin LaHaise <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Babu Moger <babu.moger@amd.com>, Carlos Maiolino <cem@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Howells <dhowells@redhat.com>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
        devel@lists.orangefs.org, linux-xfs@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 02/12] mm: add mk_vma_flags() bitmap flag macro helper
Date: Mon, 19 Jan 2026 14:48:53 +0000
Message-ID: <2eb7bd931e63111207d434a50b355dd19dc8a814.1768834061.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768834061.git.lorenzo.stoakes@oracle.com>
References: <cover.1768834061.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0463.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS7PR10MB7300:EE_
X-MS-Office365-Filtering-Correlation-Id: e67445d3-c721-4b03-4f2e-08de576a3a00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VE4bngsuZWMCrnrgSziLpkqC/8R+GlzZph145F0tKlUsuvq8NK98Uw+HkfrZ?=
 =?us-ascii?Q?qqwoy0Hp8hfZIi6Tiv1RLj/JxOnwvsMt49vSY/T5Ss6bta7GO8Lv4N2nUJ5u?=
 =?us-ascii?Q?XRn5NFJmkl79PAKSgrkzmZePnGDCKY5nvVExuwmNW2t7/eok87g1sYMtBHZy?=
 =?us-ascii?Q?GWKZ9cBzpy+Yr2xt5Kmf9z9HohPpskaYUt/jDog3eTu1w2acz0b9nuM+7u3Z?=
 =?us-ascii?Q?QlCOXoOW4P2RuybR2P1ekLpUapyz3lnLZQuSzhEIxgLOvZvVpE44Q65IoTBq?=
 =?us-ascii?Q?VCeFoZkwJsHHednFjxapWpidrFGPFPwPse4yB8wtPZGy3g/l06ltVqoiRYfg?=
 =?us-ascii?Q?ZKPCEw67oBb2oBmngQ/RGy2j2zBQ2o2Yk6Bo/LuLSloGwqK1ierrfcpQP0UH?=
 =?us-ascii?Q?VSgFrhckHdQnUBdjt6GJTLUYpdRfOfJb3Zh0So+kua4YNGP8l9lXflwpaphn?=
 =?us-ascii?Q?qFBxTHwYZJqZSSAH8Jgd5VSkJ/k+D6tIpqnrapfAneGJHbqmj5uPzK5YtWFT?=
 =?us-ascii?Q?XX/W5K7Pe/TAMJtdMv/9KGvbJQOzxHhKLBiVsVeXn2abn1/nvjlhgsVEr9v8?=
 =?us-ascii?Q?FeHVveLmzwHcZkg++tk8OUjbVT15r5d8ZwAb9OmIk9D64wxhj82l7O06qCyi?=
 =?us-ascii?Q?QphJY1bEY0OzAX25vJhleHBRb4JtIremJDDxPU/8bsO1rXx3EGO1RaEhBN9Q?=
 =?us-ascii?Q?Ub62OB3705VU+yDOaJwRxLWWW54ittrTbH7mdi82FQsXfj3zhLyEJqji7BrJ?=
 =?us-ascii?Q?pC5KuT2qu7id4viSlBlVHmtrzydNnJB72QfeWR0SP+Ph9Gh/inaUYwOVW4TS?=
 =?us-ascii?Q?QM0OZsKbpjZjyCQ3YUwRxfrhObwvM0zPXHoQehVXFhANcw8dgt3lpc8qSiBt?=
 =?us-ascii?Q?MR8lsIB/jRw0aooCSYUQklCAcMYbzzg7QtEnDuk1GEg518qju1FdiKY5Ix8R?=
 =?us-ascii?Q?IHzWC9ufG44JInQ5iOQZ/hNzeHmz2UYSIhNdM7iNq5GvesKR0x9ZC9RVEYjI?=
 =?us-ascii?Q?hcDLO02OYk9R8MCT7GKGU4MoR0B6tbRkRvg3O0SSZotH7RVGUwfY61m2lTTu?=
 =?us-ascii?Q?29qUi6rs2cObgXKCRyFU9Fc03Kdh6RMkQrsMVUk0NB/bGvMVfSYrjr2TBPPA?=
 =?us-ascii?Q?uVMnF1GCBJ0HyYvYJzLMeRUb/daQc6Vlo0HgSLDTlIINIpkPTeKqAhSIJhC7?=
 =?us-ascii?Q?2GmrHvyx/72oschS7/gwP9Y1bbjDOWtbpIRSatg9jjMjGLcPwX0dsSzWxJP0?=
 =?us-ascii?Q?7JmZMi3Np+bVV+ypQ8rUfKz441Hnu7pRPw7PUiF8Pv8UMVmfKNP57ZYSr/ad?=
 =?us-ascii?Q?qsUC57QmLY7qFB/ZbRIuhgJ2DHJ1HkkdGq/PF9AYy1FCKRSVRkhKu/VQTdHJ?=
 =?us-ascii?Q?qlM/t935REo06vWTOZDhxBkruBCU3aIbWBGP1KDz7j08LnhgmFsk7rY0H8wR?=
 =?us-ascii?Q?x5E5d7hkfo7uegHDaiwi85N1Jhb0GR9nbRRXGIDF+G/yig5AxDUeEiPlEfS+?=
 =?us-ascii?Q?N5qOLvxUGS1HjqOdeEVNmjrIZX3qs0QIPwvllKSAORccpKhTE95KTFHf+WX3?=
 =?us-ascii?Q?3TqOVrI7w5TyOi+wFe8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wBrVMwx7O7RzbpafHkOl4kzoNOlvDbL15Roq5c/2VNjs1NuAQ1x5bJOK1RKK?=
 =?us-ascii?Q?0tZlTnSVYztbJzb70W8f3p/WIn7Bd1PsYLy5yZyjHk00q0dVJgrFiDA3dvhu?=
 =?us-ascii?Q?u9nPI15EXwcrfVmsRdggDlvjXOAUc5eWCDu0SPZihOMpR4iB6Bx9WqEJrLIc?=
 =?us-ascii?Q?oAp8tVMfPlD5MSoodeosYPL9zKZvee6i7Bhcg1uFPko/TbvJ4Hcb1C8nbWP2?=
 =?us-ascii?Q?XoDAsyj5bvxK747LPbyL/EFv7lrlgFatLoAVrz+RHPQ1S+BFPFiqkZDVk+0s?=
 =?us-ascii?Q?20MQ6LtdCw4pwJITvE/ISoVo4/Tq5Uz7vjwDptUfBIXzVJdPmQYVoa6ZJKCY?=
 =?us-ascii?Q?hcWUA4yoIGx9JMBQCUcOcgtCruh0R51njFj/8CBR/nI3cUE3CKJlSXqAYbaJ?=
 =?us-ascii?Q?2lAozSy37C3DNVHwDwW9dhK/uK5nD3LuBxvhB3nK4YzdYi5aYP+4iOK0xyw3?=
 =?us-ascii?Q?3JOZPBDnWR2D3XbPHX3LmNX3dwuXvwDEhTkzjp43Q8xsyq/lAXw639bHCSQC?=
 =?us-ascii?Q?SmgVqmCrt5vV42Tw6ESbWtyJdtyK/3IxQQP6tLxkpE4rYItDek1eJ6GPAdSL?=
 =?us-ascii?Q?ZZlV8m0+vdAsJ+pUxTruv1ZT5xyXgxwYksqHuXeGUmCgjneLzcobIUJqQvnN?=
 =?us-ascii?Q?uX4JGlOPpmxPoyq2XA1xC7QT3bkFnDSS0eqUun2uO36Mu5u3Zxg0Vx614TwF?=
 =?us-ascii?Q?qHGRBGUW/NUxVcL+tKdXbZafE7lQNxRINVm37jwRICaaeycYdUroupNvuziY?=
 =?us-ascii?Q?s8ug641M/aIfA0N9jC7R9RYDukIYuAJzWStc1+MR/e3x+LAUlXISbHdAfNMr?=
 =?us-ascii?Q?3x3GnvU8wzw8eweEBD+ggnAc2Lo9OR7M8pBhCZCRwkrD6rwgABEi/z3ooBNo?=
 =?us-ascii?Q?GqXBd+RT/xA+rHuPhoxgyIDeweHQU7ycJEmYbodf3bQPGpJDtUTXeD6QqVrI?=
 =?us-ascii?Q?kmfOmGXSDLGqwVcASOn0BaP1YfeyTsIqr9jb/qMqqLm6k0DGLycnkMsAGtHy?=
 =?us-ascii?Q?ttHVlvo00ztzx77r5RsPs85mzvOLGEL+IwT5cizYT6andRsf/VL8bH0xQKS9?=
 =?us-ascii?Q?aJaE2xxhDrvN0j+jlrcrdNSWOk+Spvhcz4odXLYkjDE16S3URv8TXoyDyOXj?=
 =?us-ascii?Q?KC0sWCs4yaCa7fxK7ejd8w2QVO9VEyYFP7u3mJMo9FQLiuiE8Q3zBrLf/wrl?=
 =?us-ascii?Q?1NL46U9htxiByWRhWunHK/91Pqvt2MNusFSCZm79pRZVtaMHneuq4LzxyUO2?=
 =?us-ascii?Q?RUy1NpaDd1j2k47fzI8/BAm/nR+HQHvHwWa8H7nRjYkN+UJ1UhM+ZgH8SlFQ?=
 =?us-ascii?Q?7FUhxFpSzQIOAo8MwB4+FX24xdVuDGE7/iaDclw2hdbhVpqb9pdJWuoLlGAA?=
 =?us-ascii?Q?/bqn8VZlU+xvGKet9l2ks/ddVYTI8C9OICr5M/bLkj8DX0o+mOZh3xuHn4ss?=
 =?us-ascii?Q?uV7HfPqdcSImwl+g6EYmalsFjRCas81fWLKhcDqCRr+Uy1D6tXctk7fAVQ2V?=
 =?us-ascii?Q?XLcbwCbSDsEdPZt/ZBRoPLyhnwcmwZXa73YNsyITKYJ9C0fLmGSH4BZUzQyQ?=
 =?us-ascii?Q?6QdWJ6udqS9WhjNel8+XuVv9sRDZRGPQvFTdSutxTRx+JP8I4OJVz4UBiC06?=
 =?us-ascii?Q?tKC8ptv6dZ0G34nprs/aM0IWzcVJRdDJhQbQxAzahLAvlfhvEkXW97wTt2ax?=
 =?us-ascii?Q?u/rV7qOB4Ddol43neOqJWQ4X9QOW441e5FmZFHEVPD+3pna1cIAge8a9nXnH?=
 =?us-ascii?Q?F6oeHSZiyXSvbBbTdwUSWqT0ZrCF9yc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T2yXdYQNIWQfMvtK+99AnWwN/MOopTOGoZ/l/gwOjxPVjPsYfQ7H4ApZJBPbnRHsB6x1Pn7/i+qeG8vbZ6erJHlGzyoc5h57UfSCIOXeE6EBukRTs9unimQ0t8yrkGwnEbK3MW/XIxtdfQ22Uj80301K6+2Wjz0fLoqvJJdsXYN5x8u2skH2m9IXVCUqJxL2aaxM0V3jaJLSo6I+hiuMj0rR62SrxaR4LsNKCLwhEIPiFD4NOVkcEh1wa52avCjq3zO2VwUEmtC7ZdU3ax3qMwV/mKdRBSo/JCjaCjfRAMa8N6QmOFAUH5aH29lMo32Sl3AlB8Emr2KrsflxiRs70cleZiqr1HgqJzKDU5aOYKDTpskwKz8oKvrVmOfJypdGutLrbFxBVZj+zmBhoM8IXZpjJ07k14BAqZB4hxjzc8G/fHVo0WgkuXhSzIDltL0k+3HN/vvQPpPmzsp3MlsD9t+99fHAphSRHXg+eF6AdMiNzkXNynuCWpe2k2p8HLnlFgikHYp0qYcJCMzEkeK5cDrLZNDqzf0N4w68BE+rHOYBzey/bU3fMFwKo6KDrJdavwwwVIRddnd5fzVnM11McjOu437b0ElPlZ+aBpG0yWM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67445d3-c721-4b03-4f2e-08de576a3a00
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 14:51:28.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wm7Jr1EAD7vU8UUENHvwK1E1A5ahxlxg/WNYp2/pqwvMKPj/0hMTpBOVMaEGbXdvyLf+HCxGIUkH/mO7EA4N/8UOHWPTz5h13MibKlEATc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_03,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190124
X-Proofpoint-GUID: 33t-8mvCdz5SmXWHmCAaoVXSh1PSGMRs
X-Proofpoint-ORIG-GUID: 33t-8mvCdz5SmXWHmCAaoVXSh1PSGMRs
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=696e44f7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8
 a=X9FSn9lvzeJUOF9phsgA:9 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDEyNCBTYWx0ZWRfX0nGxTril//aN
 DJ82Q0V38K0T6IuYm+yd7uqaj5XaqKSvjUttFlUq6WsZDpsOQJST9hvHGCwxG9qM88euXgJc+9M
 EEdkslrHIImMpgbl3Yko1bE3/b33w+OCVNlj3eJEBnEvZyJ0w9AQNTV6D8oWO9hm4ntsnho2/jS
 IlI2mjyyqlWhCG17hEqJHrMi41HZtqfbx4vF9RWWUaRlKZpu2jhQdYSexKc0luKnWkWvWwssKES
 dqHisgqAumrH6rRB8JjdHjhVcZhD6A7SiI2EFizyy/FaPd0KSDUoO4GPfORY6BQ7yye/2jQL0E9
 tMuURe4oIwwk6tfotw2Aa4p+P3/zfGDz0DUiLcb3JPEZ1WFxEAJ+VVRhF2pPHkZAlYRb6AH6Qna
 8WwYOrf6n15zkbmivtWW/GJdVcKK6HO5OiS6GWN5rAN5Faj1ztf2EKczgHjjQQsFP1CyBuX100A
 10gjY2/kTno4MuMUXWCRnZu/T+v7Hcmi7z4ElBB4=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A8593A0009
X-Rspam-User: 
X-Stat-Signature: e1oij55q3p5pc1wbxwfcbqwmpsj6zrwi
X-HE-Tag: 1768834320-418306
X-HE-Meta: U2FsdGVkX18evRyHgqXJaoZrV+IowO82TKPGYvAd/5vLQCwF5DFUyDaV/Gfp5S9mg4bccKKZlKTyM/dTtqkE4/lyhOVN+dgFZae8GU8aQUUTT3L1QfB0HGvgOMe0euLu4T+dcr3l3ilVesNwc/4NvKxiY+LzXhbe7gNYZyamIoMbCpshyL6XFNPUbDoKnLJP+B82Kzc6AoJjaAYKbGjP6tshZC8m1yZHeaP/sn/9WUsB2fu7lmXBBJLUDUoe5navFhJjWYlx4duPrpQfYInUYAWTHW6dwio9FLcNKEv+z7ibrOQwukCF9rMbSI1sB2m50czuTCRPzGlhgbPD6ImhAPcGC45tq6+iBnQqKpYO7JfSobOOm0JHZs0QQrhYQnfcsOyhPuG2Acaz0iqQJoMwcwPvcnJzxPfTON/jbIxvwxRwicktoGDYt8/3s5xRJ48BOHsYGGhHyQXjeAtTIt+6kVkz9GgkjZOJzT6loCxvdOyd2aLPQsWesrIekuQFO9dpJoSoVX1qX3uVrTPFOROd6Bi1huG6xe7+lVYXiu1L+V6MSV0gBm48gerHWH6Dl+IRKEPsHuDbLc9HK1k0ikI8zG69n79wiNcNmMx+M+z+WyczGrQts5Qn8mdWAuWt/9Y/nkksWBbwFLOqCymtAbQFCQff9DGdLLHH7qCvllZy5UmDzcUbuWMhbatrpktG1Fkrt0laYYdaVVoBlTm5vKlYHzK4XxXUm6RmJY2n7UzdLhMA6azuqmiB3KiRdzNyCcEjpTbYRMA8TyP3vkCA/7OJXxVzXbyp7vNhHrQ1xhXGstmCoGwyTckBVRkgqgjMLpnU6IJN4Kq+n5F7h1C46qMQnAUNmPJ48/+IBwz5uXBV2v2pctcDfUTW+CeZZ8IENO94XITl0aJm5ddRE5z0c3Kx2p5dSPGYWz/cKxhefGr3HmnZAwOD1utUQXSYkGnLN7enGih4X4rIEmuCy3VMi4G
 AXPO5oul
 6FiogT6Szw6yiKVeYpk9ovhcA9MquMzMbM/RO1Bn/lXT2N87L2iBS5boDMjAimdfomlZNmJJwOIislDuH91bHEw3KcL0s4Gn2WNSNMw+mYuRRiqhVrM+UH6w4y13IqwZvQzYT+oVhRNzVZCREGJj8dWe8stWM7JEaTT2FCKrsPq2ya6cY0k94h1RQZBc722k6b/1viijC/wwJK3o7yMm5uDkfFBN++itJl3fxr8QKyPYaH+efT5JksrzMsH8RsFayCeE73NxTOeasN5AsL2IAyPdstbFEHtiwn8wwC74mq4Yo43EkitSmoRU0HKSQqnkorfP/4SmYYFSoCS1aPV/MIxGAZR3bJfLA7RHjwA+MPBLEt1PWZflKkHksEuQn498WNo156SIofumedj1s1n4Qg65kHUHhgI0NArbYI2cc0z7B/W9hXZnvffkfVUC9pedGV60ui9w/VlKKpb3TujxHAbUQp11l8OFgzvFewsnP7QE8HEAX6E3KbD9DQscYBj+dJqunGhHcrXZHtS94DN0Z8b55ISj2JtvWDtxlEowrpP1BHTuRzt6PFbJE4LxkAA3y3l8Awf4JpDWJAmvRR0DfxgzwU5DtcGA2eGkiuGV0WlySUqhhn1ZA4ByGEZkzyCv9jgAvsqh4aCmsMAU1D7PL/hEXUaAULKFAbvpTWxQDBDU89xV8OqIm9wR/zgN3Q2EUh6uo0mqv8Yb5DiK1ZQ5w2ZGqRlnRH0pbm4juXRERQTMWwcMw+gAakXI2tTXykbuoBWt+V9gXoWjZ0CySRTANR0CIZ7Vwr/Pe/1or+DSNDcRUSr2aMpVpF9kTeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces the mk_vma_flags() macro helper to allow easy
manipulation of VMA flags utilising the new bitmap representation
implemented of VMA flags defined by the vma_flags_t type.

It is a variadic macro which provides a bitwise-or'd representation of all
of each individual VMA flag specified.

Note that, while we maintain VM_xxx flags for backwards compatibility until
the conversion is complete, we define VMA flags of type vma_flag_t using
VMA_xxx_BIT to avoid confusing the two.

This helper macro therefore can be used thusly:

vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);

We allow for up to 5 flags to specified at a time which should accommodate
all current kernel uses of combined VMA flags.

Testing has demonstrated that the compiler optimises this code such that it
generates the same assembly utilising this macro as it does if the flags
were specified manually, for instance:

vma_flags_t get_flags(void)
{
	return mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
}

Generates the same code as:

vma_flags_t get_flags(void)
{
	vma_flags_t flags;

	vma_flags_clear_all(&flags);
	vma_flag_set(&flags, VMA_READ_BIT);
	vma_flag_set(&flags, VMA_WRITE_BIT);
	vma_flag_set(&flags, VMA_EXEC_BIT);

	return flags;
}

And:

vma_flags_t get_flags(void)
{
	vma_flags_t flags;
	unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);

	*bitmap = 1UL << (__force int)VMA_READ_BIT;
	*bitmap |= 1UL << (__force int)VMA_WRITE_BIT;
	*bitmap |= 1UL << (__force int)VMA_EXEC_BIT;

	return flags;
}

That is:

get_flags:
        movl    $7, %eax
        ret

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 25f7679df55c..36c3a31a4e0e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MM_H
 #define _LINUX_MM_H
 
+#include <linux/args.h>
 #include <linux/errno.h>
 #include <linux/mmdebug.h>
 #include <linux/gfp.h>
@@ -1029,6 +1030,38 @@ static inline bool vma_test_atomic_flag(struct vm_area_struct *vma, vma_flag_t b
 	return false;
 }
 
+/* Set an individual VMA flag in flags, non-atomically. */
+static inline void vma_flag_set(vma_flags_t *flags, vma_flag_t bit)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	__set_bit((__force int)bit, bitmap);
+}
+
+static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+{
+	vma_flags_t flags;
+	int i;
+
+	vma_flags_clear_all(&flags);
+	for (i = 0; i < count; i++)
+		vma_flag_set(&flags, bits[i]);
+	return flags;
+}
+
+/*
+ * Helper macro which bitwise-or combines the specified input flags into a
+ * vma_flags_t bitmap value. E.g.:
+ *
+ * vma_flags_t flags = mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,
+ * 		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+ *
+ * The compiler cleverly optimises away all of the work and this ends up being
+ * equivalent to aggregating the values manually.
+ */
+#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
+					 (const vma_flag_t []){__VA_ARGS__})
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
-- 
2.52.0


