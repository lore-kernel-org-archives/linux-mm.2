Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF497CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 12:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243FE8E007E; Fri, 17 Oct 2025 08:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B648E0006; Fri, 17 Oct 2025 08:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3C38E007E; Fri, 17 Oct 2025 08:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA4548E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:14:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 838961A0165
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:14:55 +0000 (UTC)
X-FDA: 84007500150.26.B8C3678
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011064.outbound.protection.outlook.com [52.101.52.64])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4A26140009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:14:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U8Ssj8e7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.64 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760703292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpsSx4k7D/B9Gs9VawATPAQgMNmPKKq0reMBIh38c+M=;
	b=YNQxH8EzooG0VsV8wFE5RGX3LBwDcPFBMLvSqWE5V7+cUxhrugZf43j2OZE0uoZdV0rzVX
	w26GZTKmvI4tmTjnnazpkQNSpLrOZ9qfj9FapYrHZEACmSGO0ba62ZBdhPcbbJQJuDfXc+
	22E0ENR9XH+QaJ7TIzopOdSD3iNIgxY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760703292; a=rsa-sha256;
	cv=pass;
	b=fnifyE6mn/bAdOMNaCfVgVTPh+M1D5MlKogHCAzhb2e7uhPtSrIS3Jl3UG6Pp9SrwvDpuA
	SiwSxoSk8J0Fe0k9MepDHtpxdwl3m3SaWjgozk5ps0tFJZejiILqZ2QJtKHW3GyPfOFo+Q
	GS87qqZ0AKus9FRmCDskco54XGfkncQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U8Ssj8e7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.64 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cf/Xm9XN/5y56O+WH201Me/2k0DB9wJWytf9KkHt0XtPA/vwa7EEMAtXLI3rFh9iEDhG3g3l1tEWNquM7kO3DGn7IGvMW93uMi9qWupF33ZEzYXXsTTV0G53e0NJ5wvaGbhH8A9ulElTg/6epAJS6ngAOipLhlr+GgWTYAO7NICcDQv2cTU7BU3wd5cRBv+1UD47/LwA0CkROfodk0Gx/GsF9Bkc0S0td+rAgwhBmi6tDiDR72H2fNVzS3PvCuKOm/583lDNzdSIgBpsvTsuJPMlp9dFeRysKAmJzs6eJtXUORFFslSKT56fzMQR8BaYJDdpa85FivB9D/NhxCNChA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpsSx4k7D/B9Gs9VawATPAQgMNmPKKq0reMBIh38c+M=;
 b=nUrkIcsVk2LcbT+XKIMKwWwjfSDtvZufE0VZjlK/6jaSGhMvcJ+uqymIB5Y5ZEv5i01li63wz6ceBT74dFlOur5hQt0TX82ZsEXHgwgfvsl5YFZmEvmIt9obeIorNPaBkMnmN4cDrTtLkle4Xtt1lcwufxpfchECq3nkI4Q5sQgqUS+VmU8zGAnTRKZorEeH7RrcUZETB6Ks/6YvFhIWH/r6qcjoYppBqE0L2hyGUDWsxyzXAlqDCBkSV+4VhLTo2Bz2lif0+JKuh7iM7ljEFFbIWtEBmLVHX4xWFTjfrvJmKF0ZfYA2uhO/peKz/k5LNafgkLX5UFFA6IWLUpms8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpsSx4k7D/B9Gs9VawATPAQgMNmPKKq0reMBIh38c+M=;
 b=U8Ssj8e7P3Xi6JCKq4Nzcf6B8DyzY2zrWohEkNehGCTlXnUADNLXZ3DXyCMe8Illm3eqn5dgmzLui/1wuNggsZ5HRQfK0Q6oCYfxyF/AiWxCrBLmOkUXY5k79RgrEcD0ZhgZLz98Npl2mPhtt5o78GS8oRGx7B131/4pC95Z4ahvoYguAWsFF8Kf1GFVnSL4+qfiCEUIezPHvSwiFUId3SR5Hqt5I0tVW3+sHmnfv/TD0ic3APhFdzbJI9X34ZgQkIz30dXUmdHRgrKMJ6a63ZPffQOGGpVwUMiz8PbhZOfjCS0HqSa9Ld0aMAcdsD4rvPXC5kYhxH42FVwvLhzy6Q==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DS0PR12MB8414.namprd12.prod.outlook.com (2603:10b6:8:fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.12; Fri, 17 Oct 2025 12:14:49 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.010; Fri, 17 Oct 2025
 12:14:49 +0000
Date: Fri, 17 Oct 2025 09:14:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/9] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20251017121447.GH3901471@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
 <aPHi2c2BQNB4eqm_@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPHi2c2BQNB4eqm_@infradead.org>
X-ClientProxiedBy: BYAPR01CA0067.prod.exchangelabs.com (2603:10b6:a03:94::44)
 To MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DS0PR12MB8414:EE_
X-MS-Office365-Filtering-Correlation-Id: abacc03d-c5f7-4ff3-c7e8-08de0d76c4f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l6BbK2fi7CUSMcbmPcJHUmDXReOTpvR2sbe5e6BRrA1in380VdjYqbgcADbF?=
 =?us-ascii?Q?LSig2kvlhJzcT7fc/DYf9Fd6KOWAiz/jDFRmuWoj4qc1xouS4dOdFbe5NFPG?=
 =?us-ascii?Q?u6DL2Pwh+ZktoQUv0iQmYzvcJIcexI/Z3oqvDcZ4pG3VbcZuvhlWPh0nF+HO?=
 =?us-ascii?Q?qfL6zyCFZbSM5u7w9EgaD3iK31E5+wu4WqhUlZxmdN8r4VwQh7usZyGR9eYE?=
 =?us-ascii?Q?SWu600H8BwlXt5M34gOpdmtGUgt0B7U7GkcH9EeMJk+lViYQ0EVMUshvCYDP?=
 =?us-ascii?Q?2YfWy1xViPW75LvBROB6jpa0NmARaz0qzSvwF0wHctFkO0yqx4QARnc7XHq+?=
 =?us-ascii?Q?ItYMhUjEmC7qOJrJQAiJh2Cur4C11/Lt1MpsgOQC788YA0OwZQmblBz04D2A?=
 =?us-ascii?Q?9vwWD/xkaHvJxVy2T2m7v/xXltqI5fLNUJ8uMcSgeZZ8AVsi0Ozy/ABoa2c4?=
 =?us-ascii?Q?gzC31SjynJoYQpASsJgEgc1suXQ/IrF620hU+zCag7onH3Xs+5xwE9chxIi4?=
 =?us-ascii?Q?X8A5RCCcjZ0WsgoV6fGMlTTHesv+OelTyKe27vrVKdbeEJbLrpBAY6rxdsRX?=
 =?us-ascii?Q?KiCxfppZ7DCnwPzmVeD53ECVurxCd3oV0zh6vAUksMTpf3Gwb8KPGy/eKxh6?=
 =?us-ascii?Q?LsJwS/Yq4ROAFN9f9gue89psB9GtyS+CsGyXHm3k+3SWbQoJsQj6DngbWDbj?=
 =?us-ascii?Q?nj6GOI0vMyUNG8D/zE0YUhpXsmO21+CKrTywGjUNflcSMRLwzKdPFJ/QXZ2j?=
 =?us-ascii?Q?/xqSAj82m2mpvuVjG2fV+NX2MFWchGoG/qTbLvpBmLqmvgSjjfoOlb61VcnA?=
 =?us-ascii?Q?1xo3vQReE5IwlNq1EbKSjK7DN0x/FOmFHrM4emrR8uBAoghHXO9gopnZnMAd?=
 =?us-ascii?Q?nZQtvsLNZS31oUX4eKZYK7pu8hzssErbqLiUrKT7gxvJyHngfBbcMe6Chg75?=
 =?us-ascii?Q?PFW1LxHzx70kMw9atLUevfDRoysaKFN0hR7rM4QLjvjUlAe/pFu/I6ruR6Sv?=
 =?us-ascii?Q?lgL6QF8n94d6+kOCc86YDYuev2idC1ekFpv6L/7U2mP7jSZCrU218oGZbdKv?=
 =?us-ascii?Q?4ZuqlMRnsGm+VUKc+HKefrN5n6wjBUmxDppQJXchndIDodGOJa02U9e/Rl9O?=
 =?us-ascii?Q?V1A+CFLOr/VXBn9YnbpDpBYuOavezTOd39Z6uzXuyOL2gDda+IVd8i+uLSvs?=
 =?us-ascii?Q?EdBksTqpSw6ef+lbq4u81k6t8O4rgliEGXzMKWUwxKYxYdF7AWSFbbv0t17Q?=
 =?us-ascii?Q?fXnjJAMHYNFVbaGNsIF6ym8Rs/kSyOe1ZDId3TNzuZ44nJR+QMhFNMPvV5F4?=
 =?us-ascii?Q?fo2dG4ewcYhPxu4TXI7zberTTfp5C4qh1bXjnpLw4ByAeE+y5nYOsAbm6sB7?=
 =?us-ascii?Q?cYIE7xnf7E6Gk6IgJP5OuxigdKFx/isWi0HQglaRlZoTOt+0VEuaHXrTnXE1?=
 =?us-ascii?Q?vy8oyJhSHWNtOIRA5WHLT7NiThoXDiLi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1DObKrcr3mXC5tjCQenDuifyUayieSqbkoNqhaDxVrsoctpfg1vX8p1s6mTq?=
 =?us-ascii?Q?NdfCFY3VkVVhTFW4ObEy82sCJBpT19c98BRLvQKv/0pak7jb3JtWv9MiMzbx?=
 =?us-ascii?Q?HDaweGZde8iGKPjgJH384j28oGGeQUitFoiLpxRkUeR2rDL5NhUwFcAxW1aW?=
 =?us-ascii?Q?IpvaStkr1P8KTr9nNxzVM5+NQTmWXgsBQnPrJtzgi3oMlfkjaA5eBuSkuQ5d?=
 =?us-ascii?Q?2PeQOXm1HwVIHpHIZ2MFpur877XmszU7d6iZuVd5prx+N4VgeA32PkR3yO/Y?=
 =?us-ascii?Q?1M4aLUvr3iOXsizivt2bK6Vqg+xeYAKIMbZQfDtenEx6PVnxFH8sJM9CFLAr?=
 =?us-ascii?Q?xPZkDj1GayVsMpY2zmYFR7T/Cf4F9VeRDYJM7QFHnkkzmesBbLWuqEtYPcEB?=
 =?us-ascii?Q?YB/FNMw4mnY6fy6lM3D8RDdWLzOUb1F7WgNKGL7NAVnp1r63/v4zbF1zcoag?=
 =?us-ascii?Q?YMMV1MgwZdqV5RvobhUudzw1/12q2rsWB1zLZlvZVgmGTm2WEpIGYpo0tRvr?=
 =?us-ascii?Q?et+sJB82TCo1KF5DkroKfYUuD1Pf33U/pJRXfCSWu7JEsUNL6Sz66o2wuH1a?=
 =?us-ascii?Q?r2dywONqf00x1hg6RIpFBQjgHaciw+CwCF7TSe7alTvp7D+AtpOxoMpSM7CP?=
 =?us-ascii?Q?xGSAzflCIRNoEt0AzclCG7grF2qpQ+ObLtxyCnmmrb97uVrzG5QSBXs47SBr?=
 =?us-ascii?Q?absk6t/De/E67fRBhp5bp6vm88YCxwYnEyiwcqFpigE/6b1tJbnv1LcSSXPL?=
 =?us-ascii?Q?1Ok3nKZLp+58yxCUn0O3jgEUq6Kk/6zuyCgJSKvespoiVFaBu0CJ+dT4mPoF?=
 =?us-ascii?Q?sUfYMPZx0M+/S//VFWYF5sRpt5inMcmbVAoLf5b2P8xDlyDh1QpI0FeL8DDP?=
 =?us-ascii?Q?THpeYmJprkSl7qC7OEwEFkPOwFBMqUcyISfTxT6aMqdpgG5koAlSd5GQgtrT?=
 =?us-ascii?Q?PQEm314ahBRkEqaMt908dNEm5ZQBFiFvWd2qI8py2kru3YjJmtT9qJZf/U1F?=
 =?us-ascii?Q?Is2T0e0Tu5lKVrQHYQ8FVM6z1GoLhEKhV4pwWVhHYM0q7Sl8isRoEHeMcTcr?=
 =?us-ascii?Q?SxfXAkMVrC3gnwtnA8Wrh8SvmHy1ZTEODSTfIPGrHZs5MZdzjW7psZaxum+q?=
 =?us-ascii?Q?aVXjmZDh6kTk2iS3FZWMAHEtJzlQrfDlSOnRbcDi8+7M0P/fcMBCpbeKLXkT?=
 =?us-ascii?Q?TviB4S6Qza59PPzdo6ZeCS7jPRArATQc9EOHVI9zTkwjbZ8VhuLgnsvPE/lL?=
 =?us-ascii?Q?Lk75ihI4ZPjfMjHfYWtH7su1Zhe6GJzt+YtoAwIp6bDia438e1LFjYXDHtvR?=
 =?us-ascii?Q?54V4rECsQ31iYVAl+ZIMZI39QjXTOJLCkT3LzJM79or17xzzQ8OUH6cygwV5?=
 =?us-ascii?Q?i2/OSBCeYUgyPTZbeuZSB2ZB+l0DKQN1UhbvwjIgC3+dlEy8IWfaoCzWqsvK?=
 =?us-ascii?Q?Imc+AGBHg8TYDJo6oJYzuMnYIOTU7glc7j2sDJQfg9BG9cA7RfN1Th06IVxq?=
 =?us-ascii?Q?s3A8c5XYuz8wdNIpSsYSm2P27N3I/HsW7KTh5sGQ7GfYqTcUtjDuxAbrrSJA?=
 =?us-ascii?Q?t3+E29aa1mml+uRdtbt25PKBmSiB5VxkQnKiRa5D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abacc03d-c5f7-4ff3-c7e8-08de0d76c4f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 12:14:49.6795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1V+iWJoP3ckTlim14tV653MeUfTJlKObgZMfHX5inOx+l1T30tb9YbbCROb1tIzF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8414
X-Rspamd-Server: rspam01
X-Stat-Signature: 4qb98uieiaib18u3zebhyd4so7tmn7ru
X-Rspam-User: 
X-Rspamd-Queue-Id: C4A26140009
X-HE-Tag: 1760703292-154877
X-HE-Meta: U2FsdGVkX1/motRCEiyhW1bEFx9ReeJZzjBhz+MkzZTmOehvWoX5D88yHtkhPEcFFct6TnOnNaYvTMBLbK7mgqPtqGCh1su7l6sVPqVl2HgPkT0nL3sw9TbdP18Rp4x3Udo7w2rWKVWWWgHdCd1oIlrZG7wl9qoprbMdzRlLQycpm7RhjU2b3V7IBJVM4vmVWixgOccvOQkSjqSDs7REOQd9bazHy8FHQu6wP/jCWIk6nLhgHBS8JKBcaKG5D86WIfBFcKAfKLes2JOtRWbrBB8pizepEr9HqMKNn0muQOKU1fhPceWfPZHi6fjZWtpX0GdPa9Vl0sSBpKQ84glfkScTtf5X4lox+t1wTZKa3WEYxZyB0omDk/cQwg1inMsRWlYWwY/UKTJA+dD8xcckyyPRFqfCcOoFdXnkYXIaTIxndSrd4UNLMa6+Yksf3sCMOb3ZWNI4w1kBCkpw59L8Rlp1NcC23UOOPB3rN8dM3QS3DDCfz58bByKL6fvKEbChA/mRcqzhDVmLoT5WBZNx7gj0i6rhKoMdvuVJHDlegewbbAvCCfiReA4Lxk1LSExyKw5Kf8Uj9PVIcWhMqW6PY2z8iwPuXrOS/UpLvdweMcPi69pzRI7V2o5FHRCuLy06jKPY/z3igtQ4qQ6kwWUf2FndF2u/hu/iJHmbIzUUHpaQ6dObXFgexkoz+bgC+wGeM2B7wOWLTUkUEzvjGjQoalbcGlY7OijGMw+L1G7srxR9DHz+8YrUKIRfQ2WymSZL6kN30UqceWdfClCTNFQzrvFbW9uk4k+iARg6ZfEx7gR+1kBlA0QY82k3BCMgcw3C3mAaCpHq8Esw2ODYgQC3HsQQbsqA4K8UTkA/gwxyw9Z57WQEhKU2GTwD7C0MMGUvWjmhZ3Z3IkhYhzCug+5r+qRqgEQJjkKiozok1yVXJbR8UFBdVst4JUxs/xasFiqpZpdqM52EVJEB6BSJ4Yz
 LfBZ7WO/
 dXuM5IJGnXo9HPjS5AsPUBYeRBI4VpDo7sPPAYvJ2y8vXdoQaYEsOs6GM6tGGa8PVSXI7z36nm9WhletW4RVL6qy8ZpBAZms/FP5t6b5ZyNEqjWY8VzqJF/6PvQnOjofJLvOF/ZMluf6LyywUHzJuKE6n2XZjs09ywta789/eDcQXfiQML71hbsCUE/M+gcss91HX3dmWfiq1KR+PE2vSuWmMQKPjlS7w6A2tXa3LaMwJzU00cT+AOubjoGbrYQiyIa5rn72xAhuiTC/xG8h1Sl1p4dfcobRby8NWN4V2rMGlcPcKVor1+qtpSVjacDzTcoJpSfTqocxr7PMAPlK6zMaH3XPN0N3dE0kBna8ZvPJKOR+5zCfMrgYMVuM0Sm9NQr/lK/2d4zw2t8JjrQysbITiLiKPJ1KkayqyhI0rPo5iVStm1r53ggVDwEpVIX7SPAGb/YM0YDaG5rKKqOlEoFQ4MrR/BrU3hiIqXo4hJrfsSCISfaOkcdwb9FqCxIypgKR4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 11:31:53PM -0700, Christoph Hellwig wrote:
> 
> Nacked-by: Christoph Hellwig <hch@lst.de>
> 
> As explained to you multiple times, pci_p2pdma_map_type is a low-level
> helper that absolutely MUST be wrapper in proper accessors. 

You never responded to the discussion:

https://lore.kernel.org/all/20250727190252.GF7551@nvidia.com/

What is the plan here? Is the new DMA API unusable by modules? That
seems a little challenging.

> It is dangerous when used incorrectly and requires too much boiler
> plate.  There is no way this can be directly exported, and you
> really need to stop resending this.

Yeah, I don't like the boilerplate at all either.

It looks like there is a simple enough solution here. I wanted to
tackle this after, but maybe it is small enough to do it now.

dmabuf should gain some helpers like BIO has to manage its map/unmap
flows, so lets put a start of some helpers in
drivers/dma/dma-mapping.c (or whatever). dmabuf is a built in so it
can call the function without exporting it just like block and hmm are
doing.

The same code as in this vfio patch will get moved into the helper and
vfio will call it under its dmabuf map/unmap ops.

The goal would be to make it much easier for other dmabuf exporters to
switch from dma_map_resource() to this new dmabuf api which is safe
for P2P.

Jason

