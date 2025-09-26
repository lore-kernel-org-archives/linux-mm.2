Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1607CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 07:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268178E0006; Fri, 26 Sep 2025 03:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EA18E0001; Fri, 26 Sep 2025 03:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D198E0006; Fri, 26 Sep 2025 03:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1EE38E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:38:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D5BD1A05DF
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:38:35 +0000 (UTC)
X-FDA: 83930598990.16.828F9FB
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011004.outbound.protection.outlook.com [40.93.194.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96271160003
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:38:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eyYKDUg1;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758872312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nO6v1jBPXrL9qfNdMcZLxyETTA/u3Yf9lFrozO5XKw=;
	b=QmPWiZe1w0J9hE03jfoZNZSnVHAcCq3R++VBJRH2WvLoV9yLzsBoHmhuYrlbjlA8nwIhr/
	2WF9kX6DVjqg8sQg8Re0Njso9/h3srntSZL1ZiRWNVF+0qz1MTpoywaW7cKH515uux1Wn+
	JwsMu91SsdbguONVngS3j/QpmoBVIwI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eyYKDUg1;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758872312; a=rsa-sha256;
	cv=pass;
	b=Pvk7rbazoSVPEqqI8kkOPM5jKDeDJzhjvcnpw0qUnVN6GCLZn1NPDTitoMjbNA/zeehPo9
	Kdtg5wqVhhNjQlp5INGOSvnBXp03WV64prrkpP5JiWOt+rzyeE3+V2FU2Igxh5+mkVIBwp
	qhrUozDrfrdIxtv6F2TGDvTju7XbV9M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVOYIbQqfMUx3/6ZPoak37c28QM2MyI1jpWOpcR2IBoWfwtlGfFb1mDe1vxsLCe+V7bjrmRYOO4QCEwij9eOxIYEoUTbyJ9ZJVteDcNJs2zNAGe/Sojf1i1c1A6wMhA7a2vnkJsN5jXHTQlK8UbX4wTM7s1osh9rQMTSvG34lR8UIzz4uSS5QF6wup2WRJikysBz/6tielaPcrTzKv/krRYweZB2oSBpZFVeM16rIK/ZfNVOW1leNQ6Y6MMuXjcN3dTkcQHqKnp0g2pCOCJC0i3EEgoFaQNh2LAormoThLzvFlirj5wvGqpgotpfum6wjIDPNyi0DbVKAzU2ArfgIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nO6v1jBPXrL9qfNdMcZLxyETTA/u3Yf9lFrozO5XKw=;
 b=exjy5DTx3WMe3VNAthT65JIOchcWqanLq+xBW0Weluu1yb9rLZ/Mgrn/6xlufw8nu+L6uQa9BwRmig7IeFSEeAFL4y2rNcGFVbdEOiAxvBVae7uACUf29N1ZHRKBe8IttLmDsqPgJSZ61I3pK8PUHRMGFQcJ2j63n72UkNt4g+OoWcFamj+EWVGCeXtYN6w+k0ZjpFqTgeApGYEPKSGZ1aWmSQ+cIApE+MipJGK62M4W+qJ98V5rWJRgNS4jDyT81LOCqsmLLhlTJ13Q0qa+g0Itw+FqSZR9sHkQnNa5yHmW6lsashnhObTpaRb8YzD3GR3wTFp2SonTSw7YhoKjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nO6v1jBPXrL9qfNdMcZLxyETTA/u3Yf9lFrozO5XKw=;
 b=eyYKDUg1Vcce3H74yR4y6l94iMdafVA6VM32B3gkZ5y5DSr9JsjwIKDTzsGHxhF1JbujsHRoG9+r13VtSS3StpKl48SVW/mHcGvQ+7j9HD84m1JHAeCeoPbywBz5RFmI5onCWwDFEsCtUcUV986GLJA8gXw6S9XVefRDRQy+2/4=
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by PH7PR12MB9068.namprd12.prod.outlook.com (2603:10b6:510:1f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Fri, 26 Sep
 2025 07:38:27 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 07:38:27 +0000
Message-ID: <0e986bdb-7d1b-4c14-932e-771a87532947@amd.com>
Date: Fri, 26 Sep 2025 13:07:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 7/7] KVM: guest_memfd: selftests: Add tests
 for mmap and NUMA policy support
To: David Hildenbrand <david@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, pbonzini@redhat.com,
 shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org,
 viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com,
 kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, ackerleytng@google.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-10-shivankg@amd.com> <aNW1l-Wdk6wrigM8@google.com>
 <95ace421-36d2-48af-b527-7e799722eb17@redhat.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <95ace421-36d2-48af-b527-7e799722eb17@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::14) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|PH7PR12MB9068:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d3eeee-162b-4ee2-bff9-08ddfccfae33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K094SHRzZVpMVGNpYVFmdU5BcTQwcXJTTC9DQUVabXc4cUtScCtHYkxPcGFo?=
 =?utf-8?B?RElyaS83REZIdlIrV2RzOG1zSmNwWkNhUytwOFVqNGNDOW9ETGdxTjQ5d2JJ?=
 =?utf-8?B?Vk5TQ0JxWW0wSkRaK2x6b2wzNHdlcmNBdExpbEljOWl0RzBKNzI4YlFXVHgz?=
 =?utf-8?B?UXBTMU5GY2VoOGUrZUliSVFlcWVUdG93K0YyT0FQRXA1RVQ3Y0QzUDNBZWp4?=
 =?utf-8?B?SXZzcUFva3RwZThZNUQ0ckxRNXNad21MNWJ4L29SeWlzTnB6U1hobUlUZTV1?=
 =?utf-8?B?VnFYMExTVXFZcGhCOEdhOU5wd0Rtcm9RTmNLb2JKaFljODRUQ1FhS1VneHhh?=
 =?utf-8?B?aU5pMk9ybURMTmpudkdjSFBaUXpMbndTUTc4L2RVdWV5SzRSUFc4aFlLL1kz?=
 =?utf-8?B?Ujhib3U2V25wcElYWklsanlreEh4ZEQvUFdvWFBydHVWa0p0emZJUzBxZkhU?=
 =?utf-8?B?TmxhYUJSWHJDeCtsZzRJWGlVbXJXVVdVU1dvUi9sR1A3bUdUSnFFM1FKL0tr?=
 =?utf-8?B?SFVpMUk0RkkyU0FmR1BLQm4rWVNDUEJ4cmVqcGwzUDg2TlZKNnVSbjRvL1Av?=
 =?utf-8?B?dENjUWR3U0FvMmQzSGw4YitaTTIvU2lYLzFQUkxubm9CSW5FdDhyTWh6VjlP?=
 =?utf-8?B?YkFvVjJRSFdMTjFZOHpnbS9hSTVEQUN6L3lLQ3Npd1Zmb0pqRHNTdDVsN2NR?=
 =?utf-8?B?K01jOFBhQ1hCS1pYbUNScDgvbnMwR2pmWlZsakRsVTJRVCtYWmhUQ1lRVXFo?=
 =?utf-8?B?cTFwbFdlMWV3VWcxU05PUzMvSXJsZTQ0YjlPYTRSMGs2ZHk4blprY1NoMHRL?=
 =?utf-8?B?dmNQWjlUVzEwUE5rOTgvWExwSXB4STBlUXlXWWwxczFjajRVeW40c3hkcmZK?=
 =?utf-8?B?YWZuaXFZNElJUk41MEpwczJGdit1akJFamV3TW9YN0w2RUVTMFVZc3ZtbFZV?=
 =?utf-8?B?SEx0ZDExL2NhWFFCdFc2cFJscHFNLzloRzMwRkRCeXJvQ09PVDU2U1RJd0Zy?=
 =?utf-8?B?THpFSHVwV1Z5Y05zSStmUWRuNERiMWkrYW00S0lWcDJHNkk2QU5xMGRuR1Vw?=
 =?utf-8?B?TmYybThvMUtUalpINjZlSzN6ekt5Qk1FbWtsQzdOL1lSVElaVUNRb2xmWUlt?=
 =?utf-8?B?VkdhMWtEejNlQVlJNzFGNzdubUlKZU1MU3phalA0Vy9PVHpDN21Ba1BOcjJu?=
 =?utf-8?B?UFZXSlFTVzFTUGpPS3ZGT3VHcExuakxaK0tzYXNOYy9jYjhXVmJndGlVc2li?=
 =?utf-8?B?SENHVVlhd2U4aitra3pMMno5b1llYTdJWE9vTHFHcTNQRnBSZzhjSnZlcFdl?=
 =?utf-8?B?TitkMnpUUVJ5bGZNMDBDQzhpQksxUTI5eGpLUEgzU0s2cXV5Y2tqUEpGN01t?=
 =?utf-8?B?YUNaSFhzNU9WZUhTRk91aThObmYyVnljeEtTQzFqNWtUMS9oa3N4ZDh1a0ow?=
 =?utf-8?B?R3NaK1h1WnBHR2w1MHRGTTBzR3UzY1YxajdRL2tWdDdZdWJQcmlwUEdxSDRR?=
 =?utf-8?B?VTVrdGpOYUVDZDRmeWNnMm1CaDVJSkJkWUhtK0wyMDZiR1BERnR0WTZtV3RS?=
 =?utf-8?B?SE5YSjludWVEdDlOTWplcTNPbWNxNVpONFRkMkR2SmhCOEtNYVVWZFJOTXAr?=
 =?utf-8?B?OHovMlpnWXQxUm5KNFVJM1dTbEVCTzJhdFlBU2lXM0pqdHVwa052ODFtc3Vh?=
 =?utf-8?B?OWJENi9WUEloT2psZUVYZGxxcEJzbmVZUWVXSU5PSVZoYTgvaExoVTlHNnk5?=
 =?utf-8?B?UGhLTWhqTXlNRFlERHQ3blJobGdGMUVCT0h1Rm1CWUJmMmxOaUR1TXN0NnAr?=
 =?utf-8?B?SGkxaHZqSjhuY3VHSFNQb1d5RC9OeVVGOXFPNHdFbWwvdEpOY0dUYXpWSEJt?=
 =?utf-8?B?TWxkdk4xTXo3T3AvanJPZHNmenU0YVZHQ1Axa1I3QWo1aXFaOU1XR0hIeW1V?=
 =?utf-8?Q?uyn4ioYfTnZ9jmnje/2WgMXE68bRDrcZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmxmdzE5UXdWT0lyblR5OHpHUmlBUEYzSDBvRHR2dEllZ1hGTmgyeTQ3RUdq?=
 =?utf-8?B?L05mcXFULzdmRlpldU1NNWR0eVQ4MVlkTXhVZVJQVmJxU2lQUXM4allhRVNK?=
 =?utf-8?B?UDFHWlRNOFlaaFRtblcxWW1nYWtMNG8wZDlpT2FhYjZHbkJiQUZ0Uk1mRjFw?=
 =?utf-8?B?dFpLelJMbHFza2J1M0NNd0k5L1Vxak5iV2hpMlVHeXQwUE1senpja3VEekhH?=
 =?utf-8?B?ZnB1d0labXowQ3AvSWhBMUxvOGdUeFZxTEdXSlZHSk81M1ZCa01GRU9XSTlM?=
 =?utf-8?B?Y0Y3YmdMdzJXZlgzM1VQcGVPYUY3cVpSemRBeTNFOXFMZDZmbmkwQ2FOSzdt?=
 =?utf-8?B?Uk5rZ0ZxcTM2ZlI4Yk5SUXZiMWUrVFNLa1d1eENWTGkwY01rZU5XR3lYUld5?=
 =?utf-8?B?T28xM2FxK1c3a1ZxNkxTNUN4Tm1TNCtIdmRVQXpQOVhkWFg5NlVZaUNZelBQ?=
 =?utf-8?B?TFJPVDYyRUJSR0ZzWnphRG9GMzJhNUk4TktvWUZBZlpDMzNCZ09xYTdmZFBY?=
 =?utf-8?B?c0loN1BZTDJPV2lxVkd5TWszZEw1bW9PZ2lrTXh4QmNNNGdoY0lsd1VUMU9T?=
 =?utf-8?B?Zk8zbEZIZ2pKcTdHTGl3OW9SUTlKenNYM2Q5ekNua0szOVFUaHdvYzlpOGMz?=
 =?utf-8?B?Tk1EMFBjMUhoaTU2SHpwWjBaNklZSVJ0ZkJma3BVN2ErbG1uWlkvb1NUUHFy?=
 =?utf-8?B?UlZUajRVNWhYRm10ekZLRS9mK2ZCb0tSaXNTVllLemxJWXdzRmZQSmlkZDFU?=
 =?utf-8?B?QjFhWWZlV0ZKNU5aNDRXMjFtRDRpM0dxZXBYclRQeVBJbTZPTWV3Vm9tNDRU?=
 =?utf-8?B?cEd0NjEydjdRb2RWY0Y1RnpsbmdPR3hVR3VmTlptdU1SUjdobGJVQm9xQmtQ?=
 =?utf-8?B?Mll1UVBxc0d3ODVCMWJVWnJ6Nm12M1dpMXd1WVo2RUpzUGFOZWJTeHN6Wk9h?=
 =?utf-8?B?Y2hEb0xQWWpjRzFZMnVHcHEzK0hmU3VaSnZlOWF5M1BOWHcyZzdySEJRcW5P?=
 =?utf-8?B?YmVWVG42c09PTXphbk82bXRFU1FXWGVlQXI5MWFCcUgzUEhocEVlTXBYeDIy?=
 =?utf-8?B?dmh0MG1KZTc1UTVYa3JjaTYycnpUemluQ0ErSEI0V1lUZ09ZUkVWMlhlVE1B?=
 =?utf-8?B?Tm4rWUtpNjlXMWI5VUt0b0F4YXpiSmFKVGZram1Ta2ZPWVYydzFaRkhKZ3J6?=
 =?utf-8?B?SHZMK0czcVMrNDJ3YTVycFE2cnl0enIyOG1ZUk1DeDBsZnZIMVNlQ29CMS9w?=
 =?utf-8?B?WGE0OTF4RG03eHk5MWtIU1J1MzNSZkZjVGZZaWVRZDJsWDNGZWNCWnozWkli?=
 =?utf-8?B?ckw3aTZQNXB4UkJNTGtHMDIyUFFsMGdMSGdPbU9ENUdoU1JSdHZOQksvZHpz?=
 =?utf-8?B?NkUyeDNJZzJaWnF5TlEvZ1JzTC9pZVk1aDV1M216bURKNmZWTVlZUWtrSk9r?=
 =?utf-8?B?VEltVU5ERFlOMThQWElzYkdvL3JvM1EvTE8rQlVYblphUWxqSUtFS1RVVURU?=
 =?utf-8?B?Ui9TV1hzc3Nva05RcDFrVnh5UjczUHhNekNXSXVsWkUyV3J5dXNJSXQyZjda?=
 =?utf-8?B?QWJYV3FZSm1WeXRyYXlOSmEySHU0N0xaRzc0RU1mWDdJa2srTEwvUy9QSFVn?=
 =?utf-8?B?akhWTDQwS0N6ZWJxYUU4bC8rdGtvNWdNN1BrS2xtQ0w5aHBMT0xzTlpEb1oz?=
 =?utf-8?B?eDllQVM0UjExeGZZRWVGL2lQanVJeC9LSkh0UnUxdFArSDQxdkwxUnhDbTB2?=
 =?utf-8?B?QlhuRzNNUE41eE1DQThoUFVrNUZkSU56WUpVQk1vT29NVkVpM1hKcU5EMnNw?=
 =?utf-8?B?VVR6aDJNY0VtVThIcENFZDl4WGo4VUZ2N3BycHBtSzJTTzdRQUtrRzlqWEdn?=
 =?utf-8?B?U1RqS1haSnBzbG9jcWJhVnZMNmpoZlpIaXA2d0N2NG5oTzhpV0g2UDMvNEtK?=
 =?utf-8?B?T3RwWDl0MTBwZk5veVFrbTBmL0gvRDJiVUUvK05PYXRiVG02elhraEJzKyt2?=
 =?utf-8?B?TUhaSEhNZ1NqZDBqazRwY0hnbks3cTA3dVVzcFNFaHRxV0pKSmpGOUxQckFL?=
 =?utf-8?B?WmM3eTNrb3JOWHdhNzZ1ZEtzYU1yRGdFYW5pZnppODJIOTBSU0x3VjhFbWZ2?=
 =?utf-8?Q?9OsjLMHb9IDzFFJhMHIaCRTOm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d3eeee-162b-4ee2-bff9-08ddfccfae33
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 07:38:27.2978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qERhmwqEDTTUsf8EY331X197pDmRa9i4UjRzF5ANHDGMG30Nz9UbWrBu+vEtGiFy3YjCGFJaVXGiSwvWxOrrow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9068
X-Rspamd-Queue-Id: 96271160003
X-Stat-Signature: uafuqrnky8si1akj8rad1mhp89dhn8pb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758872312-510508
X-HE-Meta: U2FsdGVkX1/f7v8e16m0ha6IGJvq60zszfqwkPijiyYre/i+8P+SSl2rYE76Tmd+ziXkjie7PnKfiwPBBM87+LOlcBwjcN1q6XscDvAclUYWXKaiE5XSS3QTOYhnXYuHKmcl/0VuGjjfxQFJgMbBWMhhd9cxlc7XciBE5G0TvuIYVy9PhiJ3Oh3Vh7bzXIV47W9AWL/ygBpRp3irzznXqOMnTtcZhN5c3h7iZlRpN6cW9xQ+9whqKWH8LKnAinZwsfwr1Z6avov+XNJMheYfUv8IL6ULSd8eMbN7o0pbX+95gOIdNVfichVFqDMbvEhFjVlg/Pa2TvobE9TsURmuqrcyq6arRTKFcB3Odm8SDHZ0SLmPdsm9Zv5JsqW6IRJ+7s/uMO/Sqk7gMXm9DpsRermkdAr2xOX7GhPB3KtDXG3PESgEH0tAyiz2524dJqS+RAxIvlJiADS6vGJbX9J5h5apQajd+IM3cw3MCRCo5pTKNieqNG6uyMMM0ebDAaSFbD2oZUtpeCNfC/pvTBi7B5hVFvQmBEm3+oEKUUeY5/oez/CZfyqJaApVi+7Jlx1YW+rbsbxA4pRy1yNqHOQ7fjZ53pU8aySwjyPff1xbFZvCVLqSOYtlGa1OqaKOeYLI/tgIA0dyJi5tM6yMTKVnnvypDpsLaqTzviIey9P8QYFwiGdIvHfIQnIz3SsnQLI5rSni5NkkoPTZwcSDCMAXN860ZVj+k5jDruKUCLpFW1uffaC6UUK/e/KydEo8EZmhFxKvR+TL7IWx8YrRzXHlL5jXk/Ac04IlH8AJjsb6Wm10HQfn2cqfidKB6tvvQKjG7/IcjjHYWEnWOfum2LDsc/c/O+xUo0vf6NW2BS7iwTOlAIkir5OSfAhDvVBxT6RJIrwiVuEp70kvplByYHjTy9QlSiOAxntktH8HVCQ3FrVUIhkDP+f810aIMcmpOd9oWlqa/oYnNx1Mq2v4hvO
 CeCZY/ej
 cvK3IqKpvRIKTYA2g59jAnjQzyKj63SgKW7bMaz/qqWZHq45FArrNHaZZXEYp9AvLNB3lO3Z0uTPb17lvscU3vuK9hKxA/4J8K+K2eW/BBCk85xKYWoiZVCk+I4i3xkJSFU0jx5X6EmbiIhD/z7W+nzfdeYiPdTZCK29D/sIDlY11kiQcTQjC29aouuZNJe6rkv+1+/+5Rk95Px1IxdD3WiLNGtrZx/HkGvdqaLc1bfUVEotwB9zkaIZ+kwvmfJlCAYYbpitRVtQeQmAqTxRg1FP66uB5bXKP4sZP3ln8arnqWqZ3+m9JWLjUZWwSsAASzey+iUTnr2isaBqwd4SAQ3tsvOVWNDld0QsQvPoAyQP+RTIY7qtsHGM+kjI85qtenKZsiCLNL0Dg9R2QDt7U7Gx/iV3MmQDn5njcVx85pU1sqowqdGFw0/YarL0aFQEQijwYcRwr+haHJYg/GoyvFarsHt2aOVwya1A3lVOe8fF2fTfSw9Q6HiRVjLTekvKkGw3nLBtHOtNjTtsoBwnAyY+wWCwNTY3dvptVdbdu643mKZjqZcqsXST/j1clBZQ75ejDtizk1hO97evSAqbIkIrr3P3kCkfZELuCC1FhydENzHDv5JsDhXPAVmmXRYn/5AemRZ37ywXm/5PXOojxcvMUr5CBiTMLTpBq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/26/2025 1:01 PM, David Hildenbrand wrote:
> On 25.09.25 23:35, Sean Christopherson wrote:
>> On Wed, Aug 27, 2025, Shivank Garg wrote:
>>> Add tests for NUMA memory policy binding and NUMA aware allocation in
>>> guest_memfd. This extends the existing selftests by adding proper
>>> validation for:
>>> - KVM GMEM set_policy and get_policy() vm_ops functionality using
>>>    mbind() and get_mempolicy()
>>> - NUMA policy application before and after memory allocation
>>>
>>> These tests help ensure NUMA support for guest_memfd works correctly.
>>>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>   tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>>   .../testing/selftests/kvm/guest_memfd_test.c  | 121 ++++++++++++++++++
>>>   2 files changed, 122 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
>>> index 90f03f00cb04..c46cef2a7cd7 100644
>>> --- a/tools/testing/selftests/kvm/Makefile.kvm
>>> +++ b/tools/testing/selftests/kvm/Makefile.kvm
>>> @@ -275,6 +275,7 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
>>>       $(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
>>>     LDLIBS += -ldl
>>> +LDLIBS += -lnuma
>>
>> Hrm, this is going to be very annoying.  I don't have libnuma-dev installed on
>> any of my <too many> systems, and I doubt I'm alone.  Installing the package is
>> trivial, but I'm a little wary of foisting that requirement on all KVM developers
>> and build bots.
>>
>> I'd be especially curious what ARM and RISC-V think, as NUMA is likely a bit less
>> prevelant there.
> 
> We unconditionally use it in the mm tests for ksm and migration tests, so it's not particularly odd to require it here as well.
> 
> What we do with liburing in mm selftests is to detect presence at compile time and essentially make the tests behave differently based on availability (see check_config.sh).
> 

I have an alternative that drops libnuma entirely.
If this approach looks reasonable, could we potentially factor these out into a
common test utility for other selftests that currently depend on libnuma?

What are your thoughts on this?

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index c46cef2a7cd7..90f03f00cb04 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -275,7 +275,6 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
 	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
 
 LDLIBS += -ldl
-LDLIBS += -lnuma
 LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 
 LIBKVM_C := $(filter %.c,$(LIBKVM))
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 9640d04ec293..12ce91950c44 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -7,8 +7,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <numa.h>
-#include <numaif.h>
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
@@ -75,9 +73,6 @@ static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "munmap() should succeed.");
 }
 
-#define TEST_REQUIRE_NUMA_MULTIPLE_NODES()	\
-	TEST_REQUIRE(numa_available() != -1 && numa_max_node() >= 1)
-
 static void test_mbind(int fd, size_t page_size, size_t total_size)
 {
 	unsigned long nodemask = 1; /* nid: 0 */
@@ -87,7 +82,8 @@ static void test_mbind(int fd, size_t page_size, size_t total_size)
 	char *mem;
 	int ret;
 
-	TEST_REQUIRE_NUMA_MULTIPLE_NODES();
+	if (!is_multi_numa_node_system())
+		return;
 
 	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 	TEST_ASSERT(mem != MAP_FAILED, "mmap for mbind test should succeed");
@@ -136,7 +132,8 @@ static void test_numa_allocation(int fd, size_t page_size, size_t total_size)
 	char *mem;
 	int ret, i;
 
-	TEST_REQUIRE_NUMA_MULTIPLE_NODES();
+	if (!is_multi_numa_node_system())
+		return;
 
 	/* Clean slate: deallocate all file space, if any */
 	ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 23a506d7eca3..ba4c316f4fef 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -12,6 +12,7 @@
 #include "linux/list.h"
 #include <linux/kernel.h>
 #include <linux/kvm.h>
+#include <linux/mempolicy.h>
 #include "linux/rbtree.h"
 #include <linux/types.h>
 
@@ -20,6 +21,7 @@
 
 #include <sys/eventfd.h>
 #include <sys/ioctl.h>
+#include <sys/syscall.h>
 
 #include <pthread.h>
 
@@ -633,6 +635,50 @@ static inline bool is_smt_on(void)
 	return false;
 }
 
+#include <dirent.h>
+static int numa_max_node(void)
+{
+	DIR *d;
+	struct dirent *de;
+	int max_node = 0;
+
+	d = opendir("/sys/devices/system/node");
+	if (!d) {
+		/* No NUMA support or no nodes found, assume single node */
+		return 0;
+	}
+
+	while ((de = readdir(d)) != NULL) {
+		int node_id;
+		char *endptr;
+
+		if (strncmp(de->d_name, "node", 4) != 0)
+			continue;
+
+		node_id = strtol(de->d_name + 4, &endptr, 10);
+		if (*endptr != '\0')
+			continue;
+
+		if (node_id > max_node)
+			max_node = node_id;
+	}
+	closedir(d);
+
+	return max_node;
+}
+
+static int numa_available(void)
+{
+	if (syscall(__NR_get_mempolicy, NULL, NULL, 0, 0, 0) < 0 && (errno == ENOSYS || errno == EPERM))
+		return -1;
+	return 0;
+}
+
+static inline bool is_multi_numa_node_system(void)
+{
+	return numa_available() != -1 && numa_max_node() >= 1;
+}
+
 void vm_create_irqchip(struct kvm_vm *vm);
 
 static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,





