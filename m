Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3417CAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 23:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A588E000B; Thu, 25 Sep 2025 19:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341498E0001; Thu, 25 Sep 2025 19:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB158E000B; Thu, 25 Sep 2025 19:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF878E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:04:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8341B96F7
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:04:28 +0000 (UTC)
X-FDA: 83929303416.15.FECD5D8
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011069.outbound.protection.outlook.com [52.101.62.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id 387F24000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:04:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ug+7LUIF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.69 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758841466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKao8HJwvpIeQoGVjUsM1jhX6PHn5tobkbs0HBICdCU=;
	b=8nio1LD+zBjqjbxHo3QoCqN6Nq2uGuWAQ2u7pOVrVzMNekCPyp7mNxFWkF61i1Rr1w/RSq
	sh3P1LiRmwtkUvmYmdaxoP+Rhdo1ipFU1YtPfTVdnN36YfNxb9pbeuy1ZigqNpG9YutZq+
	dP+tuBzb7DY4WTFbVJt7fN37X+X1YpY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758841466; a=rsa-sha256;
	cv=pass;
	b=VrmI2vTisgqxA7uuryWg7HxveQH8aKSry0gkOkTyzs4cI+KqflfPae0lk/9X7MQwK3QvPK
	7xs28GJOKxkXb7WZ0HzjZXUqsqOMWZvc1ql6p7zgjMoMoPbVpeOJ89Qqg+0QrQDv13hSEn
	tUaLuK87qSbqP2nJoVW+QAzFLYaTwcQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ug+7LUIF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.69 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ATInZTBd69vEM0PXEjlLTNFa5SaIAt3eyjf1VeG7LxcvoiAVe2YWz/g6rwQe+KMnzdeGAmlk0BTOygj6O0D11G7DBkXF2QZFIEIxsK4fsZY+ly8CMIawatymXmAp37U2+0CDy62aEDsq6DAUT9BJoNsjX4vtzJHw7jCpcO4iAdQ1TCrXlYmAODPs+M9vkteGlxys3IyJYyi8gnFnAM96n9WXdPZiXZQqsv0DWoUopJjAAYTelKLwb/BCFej4YS1xDR6V083Uk/yVC+f5m8ZVRCuJjIwB5s/Xv55IB+8bRaGDvKYGvI3VfNQYUMkK4e9HWScENgrdO4hCLsQq54oRhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKao8HJwvpIeQoGVjUsM1jhX6PHn5tobkbs0HBICdCU=;
 b=Z4ONMJGVuRUjxyzIXDXyUcMhEzsiYovGD8GUUJew9ByVzm/2ZHLsbOOr4SYrSlE54ngSpF1OXxL4zMCeSjcZPmO79XDbK9qRfgsWupdmomdnqmhxFe/kL9cuwvGxvhX6uR5DqB/b7gjbtOA/pnX0Wjxmk98pGEM68q/9+FHJro5ZzV75F4IAa4FK13MyiNo4Q3irllw8espJgdLRgvP3BtCN2oPsiuKAgz98grr5EJQmtvNXSVmQYtt0Qz6VgcX46rrtMW23QCVc9dMsBga0ZLFl1G/Rc5NDBkZj0URfmKcoEfi+3CTEMKVZx76AlANzM3OvjuRmqAfX/wQmd4eGPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKao8HJwvpIeQoGVjUsM1jhX6PHn5tobkbs0HBICdCU=;
 b=Ug+7LUIFVn4m5+KqBadgNsp0wel5rzQeiaLy1v5aNHe7r9DIVQHd+aNwZO1zxV/H5UDzmTTdauo0m+29synuURJSwTFGX0iu32n2kCm88PgG+lpwaYwKqwuvb3TgaoBHAhdQiu2Ct4w1iolR0yYHI3RpFERHZvgg7ueBynBfFGiqkycvvTpFSOyrZnAf9rzmxE2TzQqoblGtzA/3V9MOmnlqMSBMs19uwDSkpkZsebeyjBCbaAhI3HP9XPbaQmck8LTEa/9FDQASy8VrnXONXadDBbrw36K51KaT3NfZKRsV4yJh8ZViZgA9OaBif/5J9MQ7A5jr4wjVQw2X4D3fYg==
Received: from DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) by
 DS0PR12MB8455.namprd12.prod.outlook.com (2603:10b6:8:158::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Thu, 25 Sep 2025 23:04:21 +0000
Received: from DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff]) by DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 23:04:21 +0000
Date: Thu, 25 Sep 2025 20:04:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, willy@infradead.org,
	akpm@linux-foundation.org, david@redhat.com, pbonzini@redhat.com,
	shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org,
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org,
	chao@kernel.org, jaegeuk@kernel.org, clm@fb.com,
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	lihongbo22@huawei.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	tabba@google.com, ackerleytng@google.com, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz,
	bfoster@redhat.com, vannapurve@google.com, chao.gao@intel.com,
	bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com,
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz,
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com,
	rientjes@google.com, roypat@amazon.co.uk, chao.p.peng@intel.com,
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com,
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com,
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com,
	suzuki.poulose@arm.com, quic_eberman@quicinc.com,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH kvm-next V11 7/7] KVM: guest_memfd: selftests: Add tests
 for mmap and NUMA policy support
Message-ID: <20250925230420.GC2617119@nvidia.com>
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-10-shivankg@amd.com>
 <aNW1l-Wdk6wrigM8@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNW1l-Wdk6wrigM8@google.com>
X-ClientProxiedBy: YT4PR01CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::13) To DM4PR12MB5769.namprd12.prod.outlook.com
 (2603:10b6:8:60::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5769:EE_|DS0PR12MB8455:EE_
X-MS-Office365-Filtering-Correlation-Id: 3836b33a-33fd-4724-390d-08ddfc87dd0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0uKy48xu78VOYFaHJVK16BBu3/XQ41txItbK5Vcx9cXM4GOG18djJBn/r8M5?=
 =?us-ascii?Q?EVB8YbxWbXoSw4d9gxht3/Dc158117KukqeeZIJgwyjQVISz7eHcZB0BpUyz?=
 =?us-ascii?Q?Bns0Wtf9leAk//k3/vmpdP3FxI7CSte/0gFxR4DjrH10siVJrFU6OacSmIPl?=
 =?us-ascii?Q?whxG2aKxZLchp+mP2tBLzao0xkSKvpTamYMfJPXzKFkh2StQ2ZQBDVF2mGmg?=
 =?us-ascii?Q?d9Y0ZDoLpu0E0LCEonwymX4PMlUWmSN/ARdn/cRbxWO4k6sJsBQ5RF9coL40?=
 =?us-ascii?Q?lzr3cX9k+IDD+xlZ/JinhmkAveQTulsHBhZ7EYlwRdOyJxoHrBPstNF7XA0Z?=
 =?us-ascii?Q?u3/7GMqqvUiacKxg2T/TftGvQHGPRAqkVH14tBrMvJnTtqcg1uNMq14CC8Ew?=
 =?us-ascii?Q?R3zDf8aTku/pk4G1a3sLhQzjf0+C3As3Wo569vG7bSy25Dwjthq/6YEuCpWu?=
 =?us-ascii?Q?jnxwdGWp+FqFyiqChhVrT5KQ3yKa4NuVr9P3yUYghEcBmp39AsXcXLCjRuhs?=
 =?us-ascii?Q?M/TVOj6+3DahXURcigAjbqRyqccB4VOL6oc/Ngt2pFSuW2z3LCMjZ4+VwCoh?=
 =?us-ascii?Q?hVK4U33aX6pQsSOaagB1s9ujQ6Ptd8tg13NJpTuVemYUBD8mHnefd5PXiWXt?=
 =?us-ascii?Q?zpmZipK+BM7zogc5oEPMqGG6O1ioCu+UIneUKiuDeE5b+60zEFuXrGdshIcT?=
 =?us-ascii?Q?pxphArmKNElLYL23ReIlR+v36Re/DCkuwsLayh3kJg8WTNmm8WVgzShUcS9g?=
 =?us-ascii?Q?uEpbi36IstAaXhnxqeMHJMFUx0I3EgqDvUNRpxV6r+EzAJw5f75ZQTXFlV+C?=
 =?us-ascii?Q?vwEyg6Mcvl64sgn0RIfvVRbDePH2Haw0w0PnnpCIuSWsdF4b+MxAaIrMeNrS?=
 =?us-ascii?Q?gp/gzTuHBHJHL+ZhwFB6hyh+T7q4rVP0SmxFGO2NM1pqjGrZDq3qYdeORfUX?=
 =?us-ascii?Q?b3O7JB3l4k4DJ2tG1V6NupI1UaclsLBPOujZk57ss2rkN3JXUzg4jyhqMfVW?=
 =?us-ascii?Q?xArmf+vRocogZdeGJbQabdk6fPgd0wdLWw+4SoOzB8PNVrqgjP9FxkOsnnRo?=
 =?us-ascii?Q?9ObEiQU8PDfDiib2CeaHI29/6RBctPYBbV4wRhPx3xv0+ikJuu6S9nda4Kb/?=
 =?us-ascii?Q?9GqRn22v4wNzsdSCGpeQIeC9zzveaKoniDRTxw9r/tiArIb6E2kKXKXIN22n?=
 =?us-ascii?Q?/CJ3ePVnaNXjEoe/T1RPFA9fjcYM+PMmmysP+1Guatq0PITCDNdrLGGNjtZu?=
 =?us-ascii?Q?S9RUJesvp9SDnWeFqjqqf2JnwJ7Juk7b9KCT0d6bKTd+8m4jex+l7nxe0EAH?=
 =?us-ascii?Q?nwulNazbDWWzP8zlPnvh3q5IgX5JSU5TWefHO1zB+JTufjsXoG5NsTjdyI1Y?=
 =?us-ascii?Q?i/RcoLjRdPHMqbEyPRmxa8koigoSNr5gPuyjhH8/wO34M/Sh8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5769.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xMVJnQhszAwt8cquuiP8OFIq1jZNn7n5sFCFz9chGpkP41QUdQb26qsxioLy?=
 =?us-ascii?Q?1PeOa4yqslrcCxQ4Tar7ovA/gXHRin5qLMCCMD3mVTQyLKigs1RQ80C82cXP?=
 =?us-ascii?Q?yq16U/26huUFSoxh2EkOghN+ka7y1GsKWHLqx3p9V3CP7GJjJ1LX0B5zlLx7?=
 =?us-ascii?Q?VuZD4/th/VsaBoeX7GIoROZB4jXp4US2eL0wpUrbpvH7gJW27l0SNH6lZ3Q9?=
 =?us-ascii?Q?WdrYfJwD8JXcfsF0vHjS31TApGsFpTH76h96+1YPB+dDruV1dUwN8hIWXnSd?=
 =?us-ascii?Q?Tuqw7uZ7LaDkMyKITv2CkSxcssy/BAHrp/Qt4Fw5t8vRZYtNd/136ge+Sw0Z?=
 =?us-ascii?Q?qREZJzHTzneJqA0FuuTNSEkFVF22w0d4+Se1162nZvARoJBuGJsnIbZreF2l?=
 =?us-ascii?Q?GiRXsQxxSUSy15mOSnZWJXe7oIPRQv45Z5Fpygc04YbaudGhhThYddVdYX6t?=
 =?us-ascii?Q?Vsib8uGu+o4mQ4VYzNskhFu6CvJiQ2mPXInoOeDIbQRX6tgvrzyqHsKp6OH0?=
 =?us-ascii?Q?ub2qer0xxnNywbbxen3PvmLIaizU9aoubxN1vxozPhksRTljuR9JVEB/BYjJ?=
 =?us-ascii?Q?Jtups2/vSR+WtSv6jUcxT6gJ7JMEm8srd3KeLoFuFfSLjS6WSRnjQF2UIMSV?=
 =?us-ascii?Q?RQ+cUX+pX6/m+eayoQVILudCmR95Nsft77DNvV3uzcLC5pxgHImCTRmc7SzB?=
 =?us-ascii?Q?Xr2mbK6uJtNmMNtajCD3BRMTQtkwGfoS1qBPSDgsMyFPO+oDyyO7bpzJWIkM?=
 =?us-ascii?Q?A1tgK4CJVr8tsaJ6pOmtCDxzP/VNKQu6ZeGNFJidt3QKfGFLbun9FhDo5vo7?=
 =?us-ascii?Q?F/dpTFdR991QYe5CEM5KDdMTjrW9zI96tIzkg9Y2hOegKl1yRMkjGXhQ+N29?=
 =?us-ascii?Q?K0iTvEv39PO3q3+n+whtwkmAa+3nugASXjANsH2Vxrwf+1LNUFPNVclDCl5h?=
 =?us-ascii?Q?tgE39PPFrURWePg5hLS+pl4pK7Bxz/pQB7Rkt01ObnzxsdbaJBDJN5ErgVeL?=
 =?us-ascii?Q?jFymnggZ7nEoJ/zf+XE1slj0wDqSivNlZAU1XGPsfTw49+7UbfK5yyJCXrrk?=
 =?us-ascii?Q?BgljF7O9Xr5a5BkuClfEl+egmNO0rqtjeamwdCjzIzp2uLLqRmhUnviufWuu?=
 =?us-ascii?Q?Nodvx66rCQxEt+r02HQPF9RToLrvOvQqhAQpQHpRJpbHcz9Y23ZuRyhbvFod?=
 =?us-ascii?Q?xIhPkxmMSb1bO7OqZ5QvdlAaD/R2ZL+NGMvBwCFv9jQyv8ZvfQsJMshbx/mi?=
 =?us-ascii?Q?YoGeOV88lX+ugf7Ha7QiNTS2+/9vsFK7dng1hCYRaTHH7msb95+4Q/BGSpqM?=
 =?us-ascii?Q?vPu9eoThHL55oDkufxBuIm5haxKfDkuEGSyf55lAOZ5q0g0aSfl4LgPssq1G?=
 =?us-ascii?Q?Q8/Nks+C7pL9kL8+pULAeu7neWLDeruMvu19Nn5Rf0H8A6wx31XCTmytZ2XO?=
 =?us-ascii?Q?irXGogcrYCv8b82NM0W77iLuN+Ls/T8ORkTIG/3Uc0m79hy/o+1mBMwGfzAE?=
 =?us-ascii?Q?617FyNAiWqYLgCYgbaf4a5TpUOW93H5QkVwqXvuM5tfk53IWe/ka9O4ooA84?=
 =?us-ascii?Q?XIiOlD7eBoIuPrE792s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3836b33a-33fd-4724-390d-08ddfc87dd0a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5769.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 23:04:21.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5Nm/mSx2bTvquCfWiG4n4GBb1Xe01KU5VQzh2zqinhauhupIgO+ZaWme4gfRIGX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8455
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 387F24000A
X-Stat-Signature: 6uknaqo6iw4wnp6p9gwwfpnhg4r4mhzt
X-Rspam-User: 
X-HE-Tag: 1758841466-93977
X-HE-Meta: U2FsdGVkX1+ik3eODdLtUxfngvtZJpVZgtx1ntaMmjwQkVF17l1m/DP+ScMdOHZHOUNdBlwPJ935XLcRu1/wNOe3uiXBpi8SnioPYZ2DrcZwYVIbI+vs/MDwIoknCvQG5M004ehSqOAEnfJMd/HRGA3MvS1JBEd7/ND6/kD9QNmeUmJXflzGqwLxZwqSeRoU33o1K4IWImrStGFeiRcIY2Mt2iZ1XQq5uUPa7CNv6iVL79JvyuqOHDet8q0AakK03QxraovcbBElfV4dnFERlP3iKjdHJU+gDr7vTay2RaEiIgLDOLnByrQlTXPl1//07wYJwnKgJOat1LHLq2+H44jdFfJ4KkO/1HmxRiMqksKa1uhl4e0nnrYGpWcyy681GChVpS4S2APLwirpL7BCMMQAh7h556pYga7nStw333COoD5V1d3TXHnZu0aX4YDrJjx1iZBG37x3NSQTFhWydWAInaPaMn72PN3fOKJm7220sPvKJGV/R/T3SKdED3wx8FEmYwpFl43Xrn5P9e8WIw3W887mlwmrL7NeXJhkLlyhansLgmod0BVwEGm4JEgAP6QpMX8HSAYjE3T2js99GmHAf2sTBRnX3EfLZ9PFV5Opnq6OHCqmjc7UXwV+lHgoRUMxYt+02WH33H+IR2GVSCoRUpFGSDBNGiExzCiu/N8yRfv7wHCcTKJP9ZPxbNr72UECO8snKS9L38WqE29+E04+zQqQr0tP1Ca61aXcRyQFAafpL/w7ePUmMgb5IvAch5HmL2+XlWmdp2EM3B31784f6htjbCqMSLgvfeKmy6DicWAVETmE82j+Re0ajwTvKrxWgLRF+/I9Bk7K1PN5hw+TjFvjgjgIfaOwRayxzEj2oD4jzBdERDTAmWzcv6Kbbpb/i4yRdy64BYbU5QNuu/Eo2+E0vivEyIbnGjN+BTz0LjtCAjX03wF3jimPTDiKcWdrh3d61gQy1UKi70j
 VbdL9NsH
 3nhFSSnau/I13CfkauP54Cpx0uvjYft6DGjOba54m3Bd2xqsU5ABIXUVsUy/gbW3VRn+rjRaGRD5YZK5TCywKRAwW+cnWDYJpl/NpTZcKDmZctgrqkZ2aFgh7domu1QTVbkH3P+n1/xpKgWroArbztcSo6uC9pn4Za6tICIi1yOr8IFsnRtVsFyLRigiX4wHiqF6RAnR2Zpo1fkFDM7qx35XsmAOGfHJDmnn1aTxlqcbtzlgi0lxgLiTK3SybMSz8uP6EqlMxDxu44kIY8NficToLzkrvPNvajJiL3JlooqD5VJUS9Or4CKU2rqPSBthcQmqJKgmmnylwVqiPyhha3qs+6CnThNSRUWvYPl+5JKzlINsUC3qwM1+HIJ5+q461J/m1pMz2QUAJM73PE581HAOPbezpwvMx1WdAjoqfHEDWLSZGHy5dUHpGuL0jcUS6ZpgJnoa7z05Am8kBwbDCuTS/VVkoFV0uvq0qFktvuMV6BspaW3qjRHb5sEqHJGgGDryOGYF8DlVo5+AkLs7g+ZApkBKayygu/SqaNQrNrul2I/GYkKe+9NeA+wAUExF6Ehnj06GvJPF/O7MnH3jh/t6aJvl5vYBl+gYGiRTEKc4FAdo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 02:35:19PM -0700, Sean Christopherson wrote:
> >  LDLIBS += -ldl
> > +LDLIBS += -lnuma
> 
> Hrm, this is going to be very annoying.  I don't have libnuma-dev installed on
> any of my <too many> systems, and I doubt I'm alone.  Installing the package is
> trivial, but I'm a little wary of foisting that requirement on all KVM developers
> and build bots.

Wouldn't it be great if the kselftest build system used something like
meson and could work around these little issues without breaking the
whole build ? :(

Does anyone else think this?

Every time I try to build kselftsts I just ignore all the errors the
fly by because the one bit I wanted did build properly anyhow.

Jason

