Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8671C982CA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB776B0088; Fri, 16 Jan 2026 10:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA686B0089; Fri, 16 Jan 2026 10:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C823C6B008C; Fri, 16 Jan 2026 10:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B86CD6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:08:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F7C3C0303
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:08:14 +0000 (UTC)
X-FDA: 84338157708.21.082B86C
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E365180008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:08:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SQASWSA8;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768576091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rvd5MGh2IXFs0HIdDtPh+tMuDj+N5bKckvn4+0LLZE=;
	b=gLYblVADqhcvOb8XpbwSajHp5IQ8m94pOXHMjRWztZAn8+mNslEWPG+YdduQ7HaMM0w59W
	VJWxplQIJyko5KntYUot+6bJz8VY4BPelZFANicYjnwh4EdmMwNpRwa031EKh37gPcftCj
	s4S/LQY81lO/ykOEgWcR19Ud8lB+nnA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SQASWSA8;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768576091; a=rsa-sha256;
	cv=pass;
	b=lGnNic2W69OAbs7ran50cC3qi7bGpZEZBCWQLCkVvsDysaVFYVq8SgaAgjIzmBzpWBXsVK
	7rBRjCT4ceW4ZSp1nBaoBdQmV2+jn3OL0f74EUySVzGn9MwiEdNumC3W5G1s+a5MR3v7mc
	SLH+aqnD7cqAeDw/mM3zImsCPrRwYGk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OWytbzyAP12udExdjLcHgAF3J6Cyd8C+Jzxof1KkdB2vdqvrFvAFBKkuM3B8ohElbrqfWR8uY9lKRm16+Yo/KDOr4Pi3sPT+BmTacICorNbeD5hPwrKfcIsQTo68zS/NbMKMbTwy5eLhgl5pf8vsmueOxCegbrcGOy3JezdpUfte/H97/DnLkbQf4Z4Gh61CvawBWVP7gJ7wG05dcqV6u1xoAF/1zmxT5hYLz9ezcfkS3KebTE6uwjKVm8OdFgv42j4PWeeNBYnsG6/I0/sMdjNYB84bQuc9s759DxPgdUTxiKBnweN/s3ONJtAfzM6b7Y60OS7lmyDa3XYl3+RG2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rvd5MGh2IXFs0HIdDtPh+tMuDj+N5bKckvn4+0LLZE=;
 b=qOk0G58k/hfswlGT0CvAu0wshDjOLymeKckaAp2VGIxGyG2bJAsyb+4wNLcEteCW5FdZzKMz3dOaF72mVgZbBlSHfQJUSABkJTnwvxWWLeILCrW2EnElEclBIOf1SYmzTJT+8rXPMwJY97OsTyBnplx6q2FbFQCJWrP8Ii44oiu0TyZ+CZPRI/5LOIsC2SUSjBcPyMqRLZ9BAiYW/qIlsBcdUKKyAIUCKSZBAGJ78N3XC1MNEFGbgW+7REZo4ayVfmR/UQ/3IDKoHHD5bPY+i6kLkTyb/JUffHJ6uZREPJJfM/UJQgbKCZ56z73Ukg0o2mrfsZwQRkg+y91oRfNz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rvd5MGh2IXFs0HIdDtPh+tMuDj+N5bKckvn4+0LLZE=;
 b=SQASWSA8CfXZj64PD5QlbQdeYA5YRFvWKK+0THAF3N2PkLJPupvannp13EIoN5ItAgsytZgqLSGUISfG1gEuwxTrzuPCB5GsLYp87Ru85e6krgk0Pc5tHk8Sx7Yvrt7psM0YplnPQvpW6KFtdKDiNcf/nhK6CCmMyC5w6Ofg7yDxbLW28eHFP7/h2aRXS/9f5IMorf5fTUZrjJwftSc4pOc20PdGRjaYpteCRt6GDRHllBTvqfLd6NbOuOQyRexOyqIRUAqptlDlxLz59tal5e2/MfJhR4Ynmo+bB218HcUIFhQcNjioIKmZkHTBdaT6JoVis23ISud7Aj7taUTVFQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPF7671D5CC0.namprd12.prod.outlook.com (2603:10b6:f:fc00::653) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 15:08:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9520.006; Fri, 16 Jan 2026
 15:08:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update
 non-lockdep asserts
Date: Fri, 16 Jan 2026 10:08:00 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <84A469CA-3497-42A3-A3BB-42B7CB1195DC@nvidia.com>
In-Reply-To: <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0402.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPF7671D5CC0:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df609d0-9fc2-464e-969e-08de55110bf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YDXKeL46LaEiawQANVlrgI8LDq/iA422acAE9HHXF5PMOmsYOe99Op1dFs9p?=
 =?us-ascii?Q?F6j3CNiY6yhTlMld2i7iyeja9EH/I8IQ2f9OGHzbsJ76BxGSBhrhAUhVAyRA?=
 =?us-ascii?Q?6M/+ng8eBdQCyR0jLW9ZZTf9MZxsK2/CnFzFXkTLx86kF+mZDkPBq2YWjwLz?=
 =?us-ascii?Q?fBUujkE25kF3UV8XwA66RnR+DTDEL2dCVbPSL02xbpm/dZrZPABob+kw0izz?=
 =?us-ascii?Q?vbog6FfRMJ2JuboPw+x3KT8QZ/4HHdXpOp21/7h6Vi82eJRlDH2IGXU0R8Eg?=
 =?us-ascii?Q?eJHGwcdl59aVWXQkMq76PPM7i8GR0r5dnwtNQdOsBrTPVPAYvlRlidr3o8uY?=
 =?us-ascii?Q?IUltLr/hI0ylwmc59wziDNARRHUEmtXx/VfXQbGJHlSuXYT4OTJkKBIhtigs?=
 =?us-ascii?Q?6L9BgLHRVwCi/UM9OJXc1peiWGTV8rSx0uCGvwq9hZ0qA9Bf4lte5Dzz2TB7?=
 =?us-ascii?Q?H06bhJQD0sPG//cFA9k58a+WHGlKLPjYBxklQSONYmSs062Kv9nCOG+fmPjf?=
 =?us-ascii?Q?nO7IIsv5XZq0IC3xNgIqivxXSUg+AyULPjlJQQun709h48CXambE87mntFPj?=
 =?us-ascii?Q?P9lWi8Gr0m1L5c+eJqC7VhBL9nUngNvTbDuQ3IYehbi2yk+VeMN81MmuCWVI?=
 =?us-ascii?Q?FtM/nMXSEzgil3Xc+C+/9Jms3RjXgi93Cyk7q9w4AkmSEyI6OaJ32DslPIm2?=
 =?us-ascii?Q?AEusOrv64+9S8EwjsJo+VxbMl2nnr+/hDtX8z8/rfSAWxihlGyQmy3CxIf70?=
 =?us-ascii?Q?meMt930PuZ1sozJAZjXCzwFiBWqp/cwVAB3Sf+FUyIsM5jJ+mbYilvvqiYfa?=
 =?us-ascii?Q?lGAegLDDJaN8/SyeJxWa2bXwPDzMoAbV0XzChkgRODMYsrE0CzHB24xzjiCl?=
 =?us-ascii?Q?14WY1PsCZ3d4LJLXmXc/dtOwSBciHjlu4O8m47JrgP9eBao8m9joN3exao08?=
 =?us-ascii?Q?2v2zE45nVaodmz+UX3vRPIAcYG4FE8A/90PUZRDwCtRY5F6kBUbQZZlNolqH?=
 =?us-ascii?Q?hUZXmn34/3sVfR8oy03FoGiOhj24+41ghCFqjCckpxU5aY9zzbzZtkGzuCDe?=
 =?us-ascii?Q?0rO+NvrxG658Rx0EG/Bqz1ewuLvMCvkQXNfxH35A++yucEFc3Q68MYaRoKRs?=
 =?us-ascii?Q?I2X1uNGQ4Bj0GpDygs5Xz1Pyid8KijIPkhWfUzgM13ChUekfQR8Lno40PJ4m?=
 =?us-ascii?Q?MrH+1RqhPEGKkaUWXi0UHthJCEIRDJklGCicOhE+x2UUyR8UkiIqN6HtF8s8?=
 =?us-ascii?Q?vLYzzzusWY8+/uJovTdvhox5jUxF8mLV45rDFx0ndyXl7kYxWPNxw93hn3xa?=
 =?us-ascii?Q?8ergITykpME/aP6/D00HWS0RkHc7HAJayQrNDlgcAKy/E29K5hKvUZgIHGZj?=
 =?us-ascii?Q?eBClo4V02Dn8pt6nUjPvuF5Nphg4qUKA3xfButGP1tGBjItPBBdLKQDeMlJ9?=
 =?us-ascii?Q?gQ2AMyDmY1DmYzlp4QgG3BCPlhAvr3t6ro1u6hVeNyWq2UQEnUjAs8Qn4Rx+?=
 =?us-ascii?Q?p2yb0AP6LKa7MQFmAuuVEq5waJNcNetNFYUrlsK5CkCtYq15N4/ZvEh0hbr9?=
 =?us-ascii?Q?/X6STPgDQa5HEudRXCU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?66OxiW2tqcI1zS6SHErm7heVjhM2eNfj2OugyYJKTHXNOeBxYrjSnzkOpc+C?=
 =?us-ascii?Q?4xN+IxjJ/wpNNhiNQYYxouP1SWuW0vK6EdAHQnlSMCp36KU7dcoftEMN3dEg?=
 =?us-ascii?Q?VAI1iVNi4efPXMNeZOHuuX0KD9Y0Qw5xs2cuGi5bZpFpbDdBOKkz6VaEbckq?=
 =?us-ascii?Q?bk1JdRJ85qeJnnu7flxaY6BX6j5g9SBznjl/1m0to3nnZdbTVRV9dhia7eJ/?=
 =?us-ascii?Q?EG9RWnriysX0O2NZMc8RVudt5bjEJYaOdAuedq417yUb2j++rkWC1eL1v2eD?=
 =?us-ascii?Q?qFwflV6sX+L/p/qYZ/lUIiGSVaFbBANZ7on5nU00QaveDI/Sy+Rcv/5C5B1m?=
 =?us-ascii?Q?09ijaofiHnFZSKdlAm/iaZauhmSspJlWAFarI4tidtXOl1Fs7GIwvgu7pg57?=
 =?us-ascii?Q?TYWUyACHrq8dQYHACBjNZCsBJll61z+PaLYU6V1/gb7AY0nXdn15MGR1lHQV?=
 =?us-ascii?Q?v/98MkjxgI07DWSkYEmjvhfZsodNbeggGSWI5mn19n3TOkRSS2leaPlZBw2/?=
 =?us-ascii?Q?/IPOMpyz5Fx0FlWj0GCe0A4quDhGMesk9zo+rN12O2aGaWd4/13nyF49zHuD?=
 =?us-ascii?Q?V2ns4FVbokjVdYhDnwHIHOme9tjcOwPdFD2/Co55CzzhhxSfP5glVGvNnfIV?=
 =?us-ascii?Q?YU78omq6TXqZTPuBEHYwx0efT8BJlZF1+HxAcJ0ZN4Sb/4eqEEQeab2IJWhJ?=
 =?us-ascii?Q?1GAz+puVCjo7iRoEM1O/hx14y+sT8qDkm7n2XnSNx109108TgwWUfmrUv8OV?=
 =?us-ascii?Q?p3Cb+UkU03AvN1MpT9Md3wBT5apA9FTQXCVmD3F8CzhsuGSMNBkihCy9fVUe?=
 =?us-ascii?Q?10TNKjic+kvhkMZqUcxhE7GegxIDNsJiKX25SiZKTDX34DWTGvvdHHem3KF+?=
 =?us-ascii?Q?irqvYIuReKX896dyUil3iaiGD0wYTQAhWUp8LMBDQwsaYhcDzOpuVwtwWERl?=
 =?us-ascii?Q?phgFTGt/EWRszD6rWQitCzXets/XgMTyNow9zETH8oGTVsHOUL6Sszzqy0yW?=
 =?us-ascii?Q?TntbvvwpJCwtP9nPkIB9am/o5oBR9d/QGHNJ49pziKT7fhwHQ9c3++6mI0rF?=
 =?us-ascii?Q?6KNsjb4ErEdwYGXnuwxquhNglzV+HYSMlAjvmB5M8CiGa9eKa3cbj6nr1KGq?=
 =?us-ascii?Q?hkWYuXcuvPTc62K5la+apDDeGkHkqaYD0+e3lgob6C0OJZy96uoEMxlA2bLK?=
 =?us-ascii?Q?6MaQY1masRVpuv5HcjWJVDn9t0VRy7cyKTq+ZDiAsTioPYEj1eLz3AVs+MZY?=
 =?us-ascii?Q?BwU5WqlXQ8BOE9GTkotskeNVjBrTIRCKzobrIg2ds5JQbrmqVfKP3oQpW97h?=
 =?us-ascii?Q?j8PsZaRtdN2PgnrUsJSRwi1N+qtEKIShRdjYUE6FVpkD+bQGRUa5fWsZ7OsR?=
 =?us-ascii?Q?jd6gErDqsNvpsdNzXMlqzhzgOqg31lsUebPmFYmhO1d4xZ8Fvx5850kKiloc?=
 =?us-ascii?Q?NzJzkWEuJ2pDxnfcj7oTxO0Ymh89GtYhREra6NHiv8ajLotu48tLSp5IOd+K?=
 =?us-ascii?Q?IGkEfrRVFwlF9cRDkCKiwjZ6Pv86WsKaR6+8p74u3Av0cLnsnWeU2eG1vc5H?=
 =?us-ascii?Q?Sj+DHbvQA+itdkkdU11LRDCPkjvPZLBH37cAkBTCxlRylsFgfuNMEN25cMqG?=
 =?us-ascii?Q?wwWZMsgO1GlB2IrdlcoRGqoMLezKkmGOPb64jz80P1GtRd8NdYuhgrtV1EDz?=
 =?us-ascii?Q?spv9VUGI4hZlkTgE/YiOrJX+VOR3bHui6Em0zZlTg+7cRSF5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df609d0-9fc2-464e-969e-08de55110bf5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 15:08:03.8170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6LfsYauNTpT9IbgNVhh8EUdGzHKnJCuC+/vAwRiKb6oPdUpz6UHHKSoaDhEg8yjk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF7671D5CC0
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E365180008
X-Stat-Signature: drza9781553rbm98a7raxosm43x15gje
X-HE-Tag: 1768576089-561834
X-HE-Meta: U2FsdGVkX1/RER+LMMYJvV00XoBcqdlAyfvxmSJd+6eDX573fw3IBfAxjTp566+JTBNAj1JvgqZsgSw2NNKfdBefbz7u3F+ITVl7vGJ/vLLVPdmg/F3U21VeYa8tV4A8tbohZ9ye2djdtU1BoUIk8OBtcRVWgzAbepywo7px8sIFJKqcoBD03WH3G4fd3QWc9a+AOFcpKgKOyYe1McK8tNxv6R4H2LyfCP4dYLHp2NwPHoFEJKZUHBSqPwupspL0DGp2kl/tOibSezWgK/6M2NiIenkGrFX1H3F9voA/OcfHOwj5AcyU2CBfKnzfLZX9gbbySTN56xwLpHztc1Qrf+GTSvX2maITmiMx6ganrP+6mzbGe9yakQxf/WlkleRpYR6lJfNUPW3ds5G7izNORPFOeeI7Q4mYoab9zVDCWkKL4NXfdHk7z3uUEeJtlVCC8jU/ZbDCRXm9u4S0+EQ4C8EZ57TJf4RDcDtRwmcCvhZ2sv6Mp/s60GxkbW6lID+lIFTzxT5fAaknuHewO1t84yI5VKLHQ+Kcy7bQK6o+vj5YQ66kBiLB1z5AR41ZkAcb53Lb8K0fUcqcPRQa8HqKRjAC+qCSVIJ4/ZZWD5anGgIc2vr++5LTedHHv551ZciQZeUxOhHc4ybK3oZ+9B0EYwgyi0KRhxab4fZHLGrdaLLvcG4lPxYjNIZ+FhNsO9KJg08lsQ4WmTH218tdsEcUyhTsW/5l9X27w+aPpxM46Zgz97G2IgtXzEP5g0Ujrs8NcUPBsaio2jKJDn/O0aX5a9rhS23JggUXRsJDGQA3TxRYnrgEn389eDqmTK5f3TsBCt0EY10XjphqE9mQTjTXRwQRyP6SW1/rsJm+8PFM1wpOimsmW1qt8YSp0O4MWCvKhHzk6/Fjn62RUJRjJtTmMxRxI5imMGZ10G3KKLnq2jSURoYm1R/XBRlN/+FywGFrIoiE/HnVEoumTwUoVHS
 NAr5lA4s
 UwLMwnZu9x+teKLQCVIkEV+dSYujtbO2L2vPz+EXIDwjv4AKhbb1FgMAjhrhJl4O4x4huzfzTqztBLDQSh8yleIIVNhVXZFzT276PSC/PFuaPze3SrPGkoyGF4NdJ5iCZoP/iIo/8JFwg1FkvgO9mWmgAQwvqoogrnK70bYQLdwc/b+GjjWeDxwUvNH6xjN+ruc3lIpBKM4n8ZnK4zaO6dkPBd9zCT8kCPmsdnatVa6wjL7GN3SL44CWOjanmTsL0b2d/INn2pVfSoJoFQB4zqwA1fsN88sjF+cVFcxuiBNiQRGBqmKfW9lwQFdwFPiiZp71F6RDYh//Zua0hVoCVDu5sDAIiaPhi38cUNQH4FCK9TFFo2DkD0+8k4EWjjs59VgUmedAr0h8pn+fEBxCXPYS86Lf/hEzp+YbvQE/A62PlU3bdBwZ0+quVAUsPVnh3kYgVgajgw+4JypV6wCpVmPQBgqauGZpL4NVweL9AH0qcNHop7OQhsAykm1H1ZRRszQS+ZYr56UVzNgay9g70/zbKBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Jan 2026, at 8:36, Lorenzo Stoakes wrote:

> As part of adding some additional lock asserts in mm, we wish to be abl=
e to
> determine if a read/write semaphore is write-locked, so add
> rwsem_is_write_locked() to do the write-lock equivalent of
> rwsem_is_locked().
>
> While we're here, update rwsem_assert_[write_]held_nolockdep() to utili=
se
> the rwsem_is_[write_]locked() helpers directly to reduce code duplicati=
on,
> and also update rwsem_is_locked() to take a const rwsem and return a
> boolean.
>
> This patch also updates the CONFIG_PREEMPT_RT helpers to do the same th=
ing
> there.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/rwsem.h | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index f1aaf676a874..b25b7944ad99 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -70,19 +70,24 @@ struct rw_semaphore {
>  #define RWSEM_WRITER_LOCKED		(1UL << 0)
>  #define __RWSEM_COUNT_INIT(name)	.count =3D ATOMIC_LONG_INIT(RWSEM_UNL=
OCKED_VALUE)
>
> -static inline int rwsem_is_locked(struct rw_semaphore *sem)
> +static inline bool rwsem_is_locked(const struct rw_semaphore *sem)
>  {
>  	return atomic_long_read(&sem->count) !=3D RWSEM_UNLOCKED_VALUE;
>  }
>
> +static inline bool rwsem_is_write_locked(const struct rw_semaphore *se=
m)
> +{
> +	return atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED;
> +}
> +
>  static inline void rwsem_assert_held_nolockdep(const struct rw_semapho=
re *sem)
>  {
> -	WARN_ON(atomic_long_read(&sem->count) =3D=3D RWSEM_UNLOCKED_VALUE);
> +	WARN_ON(!rwsem_is_locked(sem));
>  }
>
>  static inline void rwsem_assert_held_write_nolockdep(const struct rw_s=
emaphore *sem)
>  {
> -	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
> +	WARN_ON(!rwsem_is_write_locked(sem));
>  }
>
>  /* Common initializer macros and functions */
> @@ -174,11 +179,16 @@ do {								\
>  	__init_rwsem((sem), #sem, &__key);			\
>  } while (0)
>
> -static __always_inline int rwsem_is_locked(const struct rw_semaphore *=
sem)
> +static __always_inline bool rwsem_is_locked(const struct rw_semaphore =
*sem)
>  {
>  	return rw_base_is_locked(&sem->rwbase);
>  }
>
> +static __always_inline bool rwsem_is_write_locked(const struct rw_sema=
phore *sem)
> +{
> +	return rw_base_is_write_locked(&sem->rwbase);
> +}
> +
>  static __always_inline void rwsem_assert_held_nolockdep(const struct r=
w_semaphore *sem)
>  {
>  	WARN_ON(!rwsem_is_locked(sem));
> @@ -186,7 +196,7 @@ static __always_inline void rwsem_assert_held_noloc=
kdep(const struct rw_semaphor
>
>  static __always_inline void rwsem_assert_held_write_nolockdep(const st=
ruct rw_semaphore *sem)
>  {
> -	WARN_ON(!rw_base_is_write_locked(&sem->rwbase));
> +	WARN_ON(!rwsem_is_write_locked(sem));

I thought it was wrong since rwsem_is_write_locked() at the top reads ->c=
ount
instead of ->rwbase until I see there is another rwsem_is_write_locked() =
above.


>  }
>
>  static __always_inline int rwsem_is_contended(struct rw_semaphore *sem=
)
> --

Reviewed-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi

