Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 485A4CEDD89
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 14:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3196A6B0028; Tue, 18 Nov 2025 09:03:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9AF6B0029; Tue, 18 Nov 2025 09:03:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A6B6B002A; Tue, 18 Nov 2025 09:03:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 001F46B0028
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:03:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A162DBA070
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:03:09 +0000 (UTC)
X-FDA: 84123894498.24.D0595E4
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010031.outbound.protection.outlook.com [52.101.201.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A4A9A0013
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:03:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YyURuJ8G;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.31 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763474586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tC74elaPpRLFLSTGYb/arQb/4NdA12LXcBNi94Z1w7Q=;
	b=G5xc9i0BaPBSDGfE0jplEehCwYUT6ryUWnYCfyJxeMzmLjmurDglTDORqfr/WoGHzdvVkP
	rYmFgAAUMmoYM1hudYObQ87Zjzr22vF22vlI2Guehnz5/eodFd9T4ZlkyMzwLCglg25c50
	zS04yV0TmatyWWLQa8EfoXdhxqFSy6A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763474586; a=rsa-sha256;
	cv=pass;
	b=RvQx3dbYd6bVUiEtonQZ1Fk4F66h3OdbssYZ8IpbUqJcIHJJZWFhj3lcKF2MrDfsoF5FvH
	q1IuQXtOkhiyWdYa5MOAM/IEwaex9lSMCQGi8QKfrsumrS0TOrrnMjSsY25vMilcEwQSIp
	Jkl+3WUwZAELVUVYn+mXQNtvdMDqzuU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YyURuJ8G;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.31 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NKGhXCUj9Zta+L8/jzw2uzOdkIfTgmRNLAW/yYcp0me+WeAORZ7LP4HIfsM2knQ7D2cmsGAZUMHR2ZOaKifk6zoQmUe0WJG+TEArdW0s2CR7HcA/28N0wd7pdiaYJx5HE3uAtWLEND636VICQTgoazQels2SBXAz+TCgJ6XwT+gJeEucgCt5C2rQbwA/drfxOsLbIBwloLwOvBiNXCtigfdydY4uiwcOtg3XjSXLj2CxOw6xqyfTjiyBTgmIf0sFTTZwjABBy+Rk/A+EymeuqR3k7J/rGDe/wuu47nlw8We4p6vHBXRlsRSfj9rrMXZ5tpkVHboDkisYuvB1/jUwzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tC74elaPpRLFLSTGYb/arQb/4NdA12LXcBNi94Z1w7Q=;
 b=CvcbT4LbF1ARCq0DEfY4W283/Wx5S+uU7rkaBDFcJ+uAklO/MXe8vCkNfS+6AnFmMJl7mQFX5GvRmu7RoQIDBQCd3DukAnlsypXh8cDFO87AZ1JE4jJRXxDiPvBLKZolBFJ62I6F7MO//OZo1Q8ZjMCItC2BbrmSxUJlPg4vx6KrecsQpuJtbDM8C8pAdwKG2ekDQNLD7EOlC03iQmOBNKgMt0ZjL4v5qhnWEOG/W0sRQg5zPwXG76r4SxkiO8uwvYzrwfHhjKKMhbPSEly18ZscDoU3o+us2Lv4FMzO/+NsZ6Ybpf/i2twe6uw4EnW5BcjpFIhktF4N2nS8iOH3sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tC74elaPpRLFLSTGYb/arQb/4NdA12LXcBNi94Z1w7Q=;
 b=YyURuJ8GaLAsYPhRP/tKjJ278RDfrsZz5hYWpETxKEQ4bVC4kgwOoOZaXQsAv/Pt3Rvcn+Xrfi6UtFpDabzBUJC+OPwf7Vj6RUp4Dbbxe9weB/VZbll6J59Wx2ksdfbgNsg/A40ETYNaHXSDvvT5z1ljdtS5INmWwBz5+fnbuGqBvVU30RmLwRuYod/eIlOf8wP+JmJoEXKHCJ79ZNMlJJLUMQjRBbp0pNfsc1BV8ZzrWwQB7o8ltyPAEVrJ6EPtS4FVFwrW/k46xNjX6NwEOZzcf2Vmp0y4VDV9VjndZ6NgCEZfuSgXWAYIbPoyaSKMxQI/IpvDyR4X+BhwBpRIZg==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MN6PR12MB8542.namprd12.prod.outlook.com (2603:10b6:208:477::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 14:03:01 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 14:03:01 +0000
Date: Tue, 18 Nov 2025 10:03:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com, hughd@google.com, skhawaja@google.com,
	chrisl@kernel.org
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Message-ID: <20251118140300.GK10864@nvidia.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com>
 <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
 <aRoi-Pb8jnjaZp0X@kernel.org>
 <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org>
 <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
 <aRxWvsdv1dQz8oZ4@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRxWvsdv1dQz8oZ4@kernel.org>
X-ClientProxiedBy: BN9PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:408:f7::15) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MN6PR12MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: f77e7518-f1e7-4f78-d946-08de26ab2f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wWlt5VgabeNYMrOagy7uJ/QxIqTMMlSI9lSKR7NDZS58FSJehGqF4Gh5XQnv?=
 =?us-ascii?Q?8a2PAHJrNzOiGNAxi9pKVJRny2cR51Czl3Pm9PVffcwRy3a8ahgW3xflHpR6?=
 =?us-ascii?Q?twHfixPx+nZiopNCHtFHG1AAv6ntFhQdCGO4ECi/LcROjyCTz5OGthG5aXxM?=
 =?us-ascii?Q?MutRbst83XCxnqLJG1iLj+PB5Ip11NmaKkRS5ZTnaNMaRDYsdWKjhInRS3aM?=
 =?us-ascii?Q?Wnng7tqW/FYJlgx6HQCD+YhmVzuFgOw21U/bBjy6//seX41ea3tyDmzDkYNT?=
 =?us-ascii?Q?KTMpK8QjKZ2L2Eaf1N1tj2Jz81N0nG7ehJHWQpnFRGuwZtmYaRmPWbuRU0D4?=
 =?us-ascii?Q?naJSxTovOKiVQZx+uwIwmkMkFjyC/W0JnasDrPd6ixH/wno84YuuTmtXxdEH?=
 =?us-ascii?Q?ZM1N8E3zRFruLSJm49b5SBKHS1lM+1mOS31Nd1RtJ6n5Y13jwGTLLw9Qy9Z8?=
 =?us-ascii?Q?trWHMQ3PimFbE6Ci794E2nQE6kDpjzLXRxHBZgEDdxx5f1HTE7hLn+pUJQIB?=
 =?us-ascii?Q?5ykWE/jbjkDkkcUCESjay8DyFNZi+I3c/9w7QyjhtiA9k3LNiJKyKEeRz646?=
 =?us-ascii?Q?795fLteJUCUfAc6D5GvUB6s/In/SKc+u6RrFdp2+mR9KY9KL7SR1Sprmbrsf?=
 =?us-ascii?Q?rXtGbaoqy1LTybFeR7Uw1obVWxBmiOIFUvMs0jmLZkWnXj7KVciEwk2D5rBC?=
 =?us-ascii?Q?VJpLW2Wk/cpYX2ZiNYkJtMNWfLK5zIyLotH815YfjIsslg6HqNksnIkyiLqp?=
 =?us-ascii?Q?ei/+irLqDGEeH9kC39AsroDOldmmSnZi6LybqsDMjmzqAM+RW+84N743fqJy?=
 =?us-ascii?Q?kIYm9QNhRD+NUsc0OYy/N/Q8mQ7h3DD7Yr61qgzKsFDS3+Uvr18L6zIbCmZH?=
 =?us-ascii?Q?ucr8HzOZYlwZ6MioJG+7A21Gyu6Z9UMASWtt0PAarFvWUppMDicRcStNzSgT?=
 =?us-ascii?Q?vK44HSHITrWCNpK7Wuo2zT9094ooJRmNhg/JGDmfTKJ2EKHtsaT+JMWOzEOf?=
 =?us-ascii?Q?XPJBWCP89GUUBTGYYcXaNeUULrOznNWlJGMKf7dcgbz9k4SXHUS6xBdz0ED9?=
 =?us-ascii?Q?5r8lGwp0+wd5zFTmQlTulvOMksDFi3yhBHERKGSMp1G1e2kMpZwpyDu9+V1L?=
 =?us-ascii?Q?UMt2IUQZksoSvnO2lCJwO1n1Nm6Tuq2l2CdIkUWse7uJHZrDVcUlLPTIxj3M?=
 =?us-ascii?Q?QWpcPefcIqjh6ldFExjLzURchyPk1kiJZCgDdCm7Mxwbfxx7fFTDr92M98YF?=
 =?us-ascii?Q?II/iF94Z6I0qJ5ievukfiHdXnHoWtMYpHSxtl5z8mSvWGv7iju5h2z/s/vDK?=
 =?us-ascii?Q?q+NrXa/uhyApcVJ5nVs7ZXK7mMQfD05zMwyGQwPp9d4ZR4+u7VOzomnyT9X+?=
 =?us-ascii?Q?ckUWn52fkwFg4oXVovtYlF6KMr4RnMcbssi+oPZ/BKGx4uVva8Q0a5IziTSQ?=
 =?us-ascii?Q?r9vYFXBzb+YaYf33BRTk/c9aHiXfkaoC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2xFJd3ssj7gnK9yxTdtZkc32xShdgIpex6W0QVLesLjxwn29RcUnMXiUKgt6?=
 =?us-ascii?Q?sc351IU+Wn//ocsvCRUCpXI/yUE/eYslWv/NBeAMl5iEwUCoa+IYbdGOzTHc?=
 =?us-ascii?Q?695ciKpE5ecqW0unNY+HDcRFS78uw7/h1XIO/LGF8+X1VD+x/U4oSMjRjF90?=
 =?us-ascii?Q?pm/qLQ3qKai358DOevVfdAquxpW1CAugmUj/byBfq/t6ZZN473j0umqXsO5r?=
 =?us-ascii?Q?7ikPx/uyyg6OP66uStbdtIM/EufPgSEeSLxUkAA3j+PMcvgJI58dhgEPKnY/?=
 =?us-ascii?Q?TR0mxDxc1/gXlrwCQ1FEdiUTd7q5INf7H8jTKcgkqQO7KJkJpfJcD8mIqxHC?=
 =?us-ascii?Q?Au/YqRWH7ejC/NXO1W9IdoW4OWJ/zD16qQODcPV7A2dl7l+OcDSaadtbmKBq?=
 =?us-ascii?Q?+SeCk35+aoqGkQYbaI+Mh/u8GIxqYztT8ED97N++y88kRyS3VrbULUHrXiLf?=
 =?us-ascii?Q?LnFokLUjlgypBaiYQAhhcRorhMCiZqFo21+n6c6k4b/XpjEJl9lJwC0+K94g?=
 =?us-ascii?Q?EqB2ZITF/ZV7bRVnvuiE7RNtv7n/Cw5rhd+v0zOAvlVwraSPRsCtUHtFMF12?=
 =?us-ascii?Q?qaLBdYu/5ECJR3LQhO+5MM8+hOdJJPamSSe+8in4txyTpE03NzJB4pYH8Ay5?=
 =?us-ascii?Q?RGewXtmTd/qxlqK8DCzvUk7dueTWhbh1jGe+q0zjy4lK47wrnE1YowOXNRQ+?=
 =?us-ascii?Q?9tKllN1OVkk9IX5pd3Ec7uYwTqJcYysZSoq7FTwD3PgulUOo4p1tNuppB3NK?=
 =?us-ascii?Q?cRe1QvKbYoddNyVX5CY5RjZSjjXK+50+4306gW8cnI3/e99YQfNEhCrc5sFm?=
 =?us-ascii?Q?fR7VgIMQYSscdEQ74op2CXnmZ3wKuxfD2ZNtg0j82n8YqYJp3MeTn11N6FTv?=
 =?us-ascii?Q?88yPfgpr8kTy1Zj9gnnjnEvTIstiOGspSg4+1E4BMN/tHLCvw0k8lnsvjE0S?=
 =?us-ascii?Q?i/FXHe4zUl2BYOPR76qYTXKTyH3nHr0OhLVyeXUIM2Ohzk3qhmsiLSCdsZdN?=
 =?us-ascii?Q?M9FW0QhmLag3iPjfepoK4wRICe16zHQK75jRZoI3uCwW5Q2/TCg9//1P5FLJ?=
 =?us-ascii?Q?VVJA+GBqdMuCpfK8vfvCpbaCmxhZTQ4GOuAmvWq/2C4F06//oj0CZKH3hKsp?=
 =?us-ascii?Q?V+ruy7qrhoRduNbxgMOXM89pcZlvhMSQR7oh0PLCIpgoXXPEANObHCVx1fke?=
 =?us-ascii?Q?nqDApz4eSadjCurCOPZShKZPZ6XpbP2e/2v5JOuGnh5Ve90ypXSM8FvZzcuG?=
 =?us-ascii?Q?1c+9KGW8F4/2cp/GH981QzGPFjxWcdSg41vGHRbn0Y743KfzN+PgtAJzj6uF?=
 =?us-ascii?Q?D2Y5hBbD0PuOQN4TOyEmTPmlM3+o2meFVyVkvTZRH9MUznfX/rn1cDFrk6jz?=
 =?us-ascii?Q?AF9bbF/DtrpiBicYYVUzhgQzy9MPHOjAiAjIWRTkJ3lbHj5exXFwrdbXL/CT?=
 =?us-ascii?Q?uC/qbJd23E8bR1g6BpXKAiALzGs7tm4pLwdBfi7ws5D97f4tFLwRhmMhStfR?=
 =?us-ascii?Q?YWGok8723XBddpJocSSRDYiZFJkSgUOrE/0KAhenvFsmBfFZYLkb+9pb+KE5?=
 =?us-ascii?Q?mOG+ELOAt8wPI5Po7LM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77e7518-f1e7-4f78-d946-08de26ab2f48
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 14:03:01.4409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWGmZkkGf7Rc7UPCXzH/r0Mm/RL1OzNxTFfrBdl1l4VGouDMArLy26tMGeTgWFSO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8542
X-Stat-Signature: akpmszekfyhfagzdhm97j6t5rt3hfh1d
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A4A9A0013
X-Rspamd-Server: rspam10
X-HE-Tag: 1763474586-113475
X-HE-Meta: U2FsdGVkX19gWta5nygFZFW2/DyMirnUDHpgDH89UGga4GlybeVfTKgSXp7i7G9i8q1RstWthc6iafxZHXUR+ZFJ30SDan1ertL+a0Kb3h5/6+rjQ+SBj4ZfibHvzruGP97Imz1mrMwjzCAeQhpqLfs2PdzI8GfWCco/LKVwbArv7TKIg+BtcXoQGQ4HJtTKN5NNXmpFXp7Os7iRgZW1rUCHaqNXFsDKrIFcfjOxVLn9b52LO9JHzKZryzbmf4CwCN8Fs7eY0cVd0jkFbENf7WAnN1SF99Y1xbaEKELGtEX2Alveo+2+Ox/RNtCF1yb9W6SwQojNytTnXYrRptWDZhcDBpAI163RNIA3LOatBO8lxSFO8FMueP6bSPNKRec1YgNfr95jmi6Ot6OI7JN03xaspuAwTqlJJcOZfrYRuN1gHWK/v3Tp8Nj+x9egY2Rrf+bCsynz3XEMX+fCSQl2NnSi+aGoXivXbVoPGr4euujYxI/Nn0pqoj3XtXesZM26/ZHTSE3xlrpqEUDbrlNFf9MVWMiHsmZYMN19G704JxOQ70jAfj0bJ6Zo61EhnO7g9rMw1WomvAJy1IGdMUHDF7PZoWn42ojTCdjS1xGkZBMrCo0tmR9M60xiSX7UX0d9poHx2ttmLGg5LOqVS2cqxcOz+uT7iBpfb5NT7LRLC+Xf8gViuKP1cs6UYg7M8v43dIY3kp3YRmWVGL4M0LZbs6bDPuBZYSPybm2yHOyJ0M3/Z87eTW4hUPsFAlwxH2cwhmet2c/v6zJjS4LWHm2tcyxMLbuOLw27GS0CuTFP1J3aeruiHfyE8QUw+5VtnOWyC+EHXpLYRII39NziBsgU5OQJHWrY/c2zxPVSk4hSZEkIfk+nS1BEtr78CiViCHQ6PZkXJOkSuVtmjaesxgRAgnmzpKj6QF71yImG8mrdD4dwLOEnEU7eX7CsB7H06lo3Fof0wO3yLgdwZXLFUwj
 jjevCGDE
 mhj4GJzioZCyWy2Y4z+ITpUDiqhzWwPTFj3RLw7DR/73/LSktjRr5JwXc1cX79JgR+XsgFnJJoHayGay2pPUbNYWMk9R6ITo/BLoTxNltc88Roa40DGvfm7lNU7F0wekcY4fnHBUQtNTBZhbbV2rIi6Ot8r/Y2lwSeL97x8nWU/O7rNYuCJeVD6GVonro146GLGAWvzNwHvNUBh2j706kaz7V5lTV3cr3yJ8f8jwoMLw/bE6Sn2RjaofTChdiJvPidTSt57z9cFEGzyZ/9go/3me5sv0V7eM7dg+lfZtCCYs4m+biPJuTCKbjtN0hm8+tv9XdC0AAwDus0GeIMvJWBAhf1vbZPyxChVp3dbuczj9SX12g8IC7nDC6BohC1eVAWu7+8dMt8pk/HNZXWUhTtqgM6aho5/CeRXPfloBKh0+kZhCYanVCqwAoiC9dQsFYStS4weT/jDU0OTsLp/yVn9FfV9KG4947yDl3ilz6gnOJRyC7FVvvVJ/6MCWw4Yt5l/V0AwbSKPrA+m0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 01:21:34PM +0200, Mike Rapoport wrote:
> On Mon, Nov 17, 2025 at 11:22:54PM -0500, Pasha Tatashin wrote:
> > > You can avoid that complexity if you register the device with a different
> > > fops, but that's technicality.
> > >
> > > Your point about treating the incoming FDT as an underlying resource that
> > > failed to initialize makes sense, but nevertheless userspace needs a
> > > reliable way to detect it and parsing dmesg is not something we should rely
> > > on.
> > 
> > I see two solutions:
> > 
> > 1. LUO fails to retrieve the preserved data, the user gets informed by
> > not finding /dev/liveupdate, and studying the dmesg for what has
> > happened (in reality in fleets version mismatches should not be
> > happening, those should be detected in quals).
> > 2. Create a zombie device to return some errno on open, and still
> > study dmesg to understand what really happened.
> 
> User should not study dmesg. We need another solution.
> What's wrong with e.g. ioctl()?

It seems very dangerous to even boot at all if the next kernel doesn't
understand the serialization information..

IMHO I think we should not even be thinking about this, it is up to
the predecessor environment to prevent it from happening. The ideas to
use ELF metadata/etc to allow a pre-flight validation are the right
solution.

If we get into the next kernel and it receives information it cannot
process it should just BUG_ON and die, or some broad equivalent. 
It is a catastrophic orchestration error, and we don't need some fine
grain recovery or userspace visibility. Crash dump the system and
reboot it.

IOW, I would not invest time in this.

Jason

