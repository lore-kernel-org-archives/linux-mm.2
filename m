Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDA56EF8FEA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DEC66B00AF; Wed,  4 Mar 2026 08:44:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388796B00B0; Wed,  4 Mar 2026 08:44:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B9E6B00B1; Wed,  4 Mar 2026 08:44:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16E246B00AF
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:44:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BED3BBA018
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:44:53 +0000 (UTC)
X-FDA: 84508501266.14.15334CB
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by imf13.hostedemail.com (Postfix) with ESMTP id 123D720003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:44:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R7nRy7id;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9bn0G0BpHgJ2dsfxLIhslyVs7HFs3h12V45Adash94=;
	b=emeWvUHC3ZFcZckFljKCVtU8NTwV4IGrZL221yUPsKYZr4F3lfuhL/22eOL080k386qF4C
	npK+yfOIAy8xTsif0Qtvnxi4h+PIb+7HLAhNr8zbHIt3aqOyRVeETpt/USwJRKl1dbvyv1
	9dfxOi1zdxu+dcjUYiaJa+0e15eUt2A=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R7nRy7id;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772631891; a=rsa-sha256;
	cv=pass;
	b=mCUy7VQN71Spld5fWTFBzKdCYhuCfWXLq1f7cwMjhvp0u/OWlbauEiXwMIjoefo81onoLt
	hA8dgPppPA3bJ4SXHr8VintEOH2Z4oo17OjzYWk9YARjHlemAVdaySEbVaQeGFMdHCVPW7
	l32cfq0XOl2ILBzEwcW7tMsWmzSKvTs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dpf2kiVLfbu6/Hx0aNdgmUZ11v03QSIEp1ys6R9rbxIG6JdH5w6o+kYgycakIKkOiuBoVcIqD1Y5Y8XLtQ7qjDtVWR/wvnf2Jh3422gwIt+PNKHheY83Er8bG5nwWDSI1JXZMZ4IIPaDAe72sXY5sDZvXqr20dsqF5ZbciQco76gOpiGcXgutHxJvtt5td0EQovaoUENN3BhgV4C9cBbPuvOaJoZ9cBZZ4/a9QqIISg5ZFBJfInYdLmTuj6JHYfF5GZ0GAPVaiB0rvG6YftGZf8dTd7rjHPen5IPEf4r/huJRbEIxuS5e0i61tJpV532kyXVNvLHpOcyMxNM295hEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9bn0G0BpHgJ2dsfxLIhslyVs7HFs3h12V45Adash94=;
 b=bI6b7tTMYAzZkPsAbDvrOSjIRl2FKcIORdCyoqOZCg5QjVUoWxCLQEaxL/KbPmZHDDHph2mQ6LCwyF0LZdEfaTeD20+9mLBzBRASMpSb35fOUjCZI1UfnGHtYxN6lARaKU8GTjXzJYvWerVidsKonlYiF6qjFKgVeDTQvVxVIuamoMr9r8z06389gBg0OrtiHR5olpfocSWs+VG9a/z5q0H5J/Nh9IGsP74VIrfLmfin6OY7UqEdOVhgtyvvktwlpx6GLmpJhLRgoq+/PPBikcZaW5WKQM6PzxDJxvGJeiJbIwERGySeXk8X0rfPt2J+c23m2+tjsNhFk9EMwW7Z3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9bn0G0BpHgJ2dsfxLIhslyVs7HFs3h12V45Adash94=;
 b=R7nRy7id9kwRX6eaA8UpO2RF19qPof9RDjpRGy0sxh02vegBqX4dLHDyH092Pr1ip+H3+is0PvRT4KnjRoo8judMo8r/3JQGGvFF6WIIWnM2vNxTvxPt5dkACr0ODXteTkdb23lru0WC17AvikadXNqFZc6sfu7Uk/57hDRTwDCKpxpmxe/doQh42f7IUbftperC9CdfJbo1Oi7hy9QMbqOWtfvxwauJlVovfkxoTwJRbuc8lJIpKazlu3IlNvPW+L319IC+zI/Dsd0XlK/D9ezce6Ekr8wdbudKYy5RY3n6nnjU3aWDPkyc+fFkOytTHIbbXh/ZY5qXlsDEaTU8YQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7422.namprd12.prod.outlook.com (2603:10b6:510:22a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 13:44:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 13:44:47 +0000
Date: Wed, 4 Mar 2026 09:44:45 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <20260304134445.GN972761@nvidia.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <0a10ea33-937a-4294-b9a1-9323c706434d@arm.com>
 <aacohVRfAK46lOjo@box>
 <20260303191217.GD972761@nvidia.com>
 <1080db49-2f83-4fec-ba73-94c6b3a8f7fa@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1080db49-2f83-4fec-ba73-94c6b3a8f7fa@arm.com>
X-ClientProxiedBy: MN0P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: a214ca69-7392-42d3-628c-08de79f432f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	TyCjhN+021woCMUt/c/jkIYbKo2BrGV9rRKgRQd4DDvD6iGKOMvFhfjapjmCdA4Wtxqqducl3IxPKwZ33h97BrUIEIygI4qfeP66JSaWBFJ+rR3HT/0LEL1GFMV+yuVMZn5Aj5/3JOXdhVrV/BMM6Mf9HeJsS7DpuN+PLVgabm1zwUfsgJkoynfM2BSQGoiCcN5cLG7lxr9+X/+G/PDUGnE0m07UH6ilmIL6eNRlOlyvunhnQMEXmVGBzPkoLyqX3SmSGDkzxKMuzEZMZUu4ei62LV7+GGPsfUXPAUhESYfiQs2AuM2nuocAko5sSYE9HaLeS3Ddqa+T+n65CLNhSlW0CL1aBk7ZIuWJ9cBnP9Lxwhf+UfyH6Bd3BGu5v7jLGhEo9ZfVSnBDjTrhwb388myiSInfuR2Vw3xgt0BjEh6bgOV+tu59OHH3ntz3q1L1NrfgMY4TfW/nIYYCxnmJu+9mNq3Km2+GIbuqnGPLWkoCCRaJN4BYyduaGS1ZOoFP3SOb2vsaUNr+GFU0AmtpXs30g8PnIhrKFG6B6qZDkJiq/E1F8zUFevkY7VXePLyF3h+fYHAhXPrkuVSrOBjj5H0v6hpv84G8ZI62mLrjYb8MTCBaHUpN8MYODoh0hkGwqCXe2oWegCBwDyDvXJPge7H+WxmjqTmVvBUgollXAzEDtnPbxKktr9rzBTdoBQtEQhHWlNUfpEGaDadxzQ6UwMBdLB/Y97TDQvawp5Bbzj4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PHCtCp94ofkZUXd3gl/bv3Eb69WGkiB+SUqlKWgcmALf7NhVcL8tqtSousr6?=
 =?us-ascii?Q?1kxlgnCYANR74JhELcSNlri+4g5KHY0B8L+Us2iT2lanRF+23EiJ1paTcFfL?=
 =?us-ascii?Q?K6QkJ7keW4/lCoAdXkqcczp2pXqNVcKvPhJrGDMngMoomtUlA2udzbbSdfpX?=
 =?us-ascii?Q?PholbQpgCoc+uCjEC9KUMnUadKk5NN9fqihlQ590FAiTJYQgpAilyCJqNqZK?=
 =?us-ascii?Q?swBDg3Iza/nU3pZ3NmvVj5WXh3bU0IoZRaOyTgw5dWtVp1DeBJqfCbcJUW61?=
 =?us-ascii?Q?qiSXc2R9FJub2zhr49X3hrSc/d7RkYpHd8nluONNpMbwDEGTIIgrOBshlHnR?=
 =?us-ascii?Q?5dtRZ/WOktISs3NSKzt5nr704++PvVlQ5XrIfieTSWBFAvpTnbod5NTu9cEv?=
 =?us-ascii?Q?uY8cg/sK7Lx46XWECw7V+swmquUj9nRdYJkmKwhmimCtGfDIkafAOFRqiH9Z?=
 =?us-ascii?Q?8q3wTNtUr4JLv3nqvUwrYXHkK4wVXfs6MXjkGOitvTng7ovwua13eCnWSTcD?=
 =?us-ascii?Q?Rc6aahuQIxEAcFst0uMgMGMxWJjCeqn4iAwWEeh/iQZoEhLLresT5LKaazVZ?=
 =?us-ascii?Q?DtM2hI90uUWnI7QQPF1C4I+CENbfTOihOHW3njxz6gFVsBl+Kz5miVDknJII?=
 =?us-ascii?Q?eTCraHMC2ROV7sn8SRLyn8vAthdRfHjXs1mlELR0Yiyuvpc1ohAdKAc24WvO?=
 =?us-ascii?Q?ijd7zHDZE60gbFQhB4/N21sguP1nBO07szVnXrbunFJpgPDsWriCqgzieEcP?=
 =?us-ascii?Q?QJju7h0vkAYpJdoAEobnHcl8TQ4/kf9gWcddzXkGzwHINQfQBV4e5xZsU4jJ?=
 =?us-ascii?Q?G+nomHoHeDWk12dXH5fwWrFoXLqqBPn9KpqVtWTBraKE363aucNvSXk2XZU/?=
 =?us-ascii?Q?0crsYfBnZbSyTy9MjQO3k7ahqEk1e2mNnFis57t89DJO7zx0mG6RxublLVEm?=
 =?us-ascii?Q?tLo0E+WrwqkWEWYoPkQsZsSbqhqCpHAQCBPdF45mm23lS/u8bJv7BLZO1hWl?=
 =?us-ascii?Q?Wvvtr4MrkykANx3oQYJaVptJV+k3bhppSXZNbDeKt1JVGeqNkD75ttVcjRKi?=
 =?us-ascii?Q?E87Jr24YQA8BU9XxHxqJ9WKRAdYuSpgSZ/kSDI7A5pPfGj0WuCs8mbj1MkDu?=
 =?us-ascii?Q?8Obnku+AnMN9OR+/oHuqbM0i/LCB0HjqpKjaMlzcjFYwCGhM8W1JbSXqux66?=
 =?us-ascii?Q?G859OgsvG2mAHroNkYfdbFznxE25DuYQ5P1XescJokSUdH6buTo69KJf7I9z?=
 =?us-ascii?Q?X82I6N0yppVa/X1ioz0ZuHcD8oUhOmeGM35kbnQVr7fI6TzPE0ZR0J8fQbjM?=
 =?us-ascii?Q?ccMXmXKimydJOvDZfqMIPGS1KLxis6C9lk3c6kQDF8BXOAeGUdzFy0QU8SNr?=
 =?us-ascii?Q?MRQiLrrbQQljTXEmWZZ8wYNhrTvdSorjGpm4rkedo2+V8JtijXHPooV5fmQc?=
 =?us-ascii?Q?alh65ZJ6w/3qqlUkPED3EYhF4O6w6B3wQHu1wzdkFy9f7wkhg4T4rUe6A9c+?=
 =?us-ascii?Q?2yzDHTvtSZALtt5ORZV8JUbYkKUfuQ4v8Q3t7RRLI/lofThvFWVKYuwlHkt0?=
 =?us-ascii?Q?eZFBaC/ceX0c6m5FtTwYD2y/rp09TiGqOnNJvEBjOnSoDFhFEn90xy9i8Nq8?=
 =?us-ascii?Q?Lz8ezf8meEUXrgBV6qAw9M9XJkm8lBkTnPtN0qaSTo7XiRrCKg4Orf9fXw0D?=
 =?us-ascii?Q?FBYTi8otC5f1wIxTo/5LB0ZYhS/DTWZl6kuBkWG7QXsD0RZPCxKK/jbkzFm5?=
 =?us-ascii?Q?fvv0G05Tqw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a214ca69-7392-42d3-628c-08de79f432f7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 13:44:47.0202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2YObPPYNACpZ309HAzo+gmSjqojqSTqYye39klcov3nOFqhgsW+oMM97tmaCtL5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7422
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 123D720003
X-Stat-Signature: zrmcofojgnnxf67piu77c7a38q13khck
X-Rspam-User: 
X-HE-Tag: 1772631890-967373
X-HE-Meta: U2FsdGVkX192z/bNH/V9shBpCV2UrHaHe/w4KI/umlbcHKQFD1Y99A8/fUXcKnGaalH7J5N+uGnE+3wzc3tOqm28B1EYmx+52+UOQPzWfv0z9j+tKKdKnY9A6rtemVzbgxT0z1s3vQz/OlY75fKir3jGpq8tYDZObRNtnXcPRrZo2E8k29By0VDhUGMKwSrd68DMHZKHbB9eHPNObfJG4tEpgvdoj/+uMEVwjgBa8CG7reGnb1B9kvB3mPl0mp2GyqnMbAuPxZB6JdfICBRrsXFIHHTKtRKerv29F3afuL/BHrLYEMHmI4k9x9ZOt5TL67LkT2ON8qt2ed8b5LVzZIPSVaA9ywZNrZ5DhudCgb5JkP0bDevO7U32j3t6M/YsgUt9V3MC4ThC73leNy3NF2hpbIoOvEiy+HlusCmKJl3pYaxF3LJV9bAM9/r1LlkQ9anUv23ou8AsiJ0lCJ9y0ktBgkzt4iawxYJSPyQyU9Fpg9pQYaHAg3PA+2M3WYbW2lklbrZv7QmQo/Idz5/GAECKgFxU+/or5Bsmu7iQNYhZBqr5VJ5rSIgqmNlzPaIj+m/GbMQsubPlOuo7v6qAzDWzEnkUHJLBJetsTqzZ4zIwvww+Fh7lnvtBvnDYjb+p5ZdrP82yaaUJ6/qeuwNNkfKR80pBfUJY8XVgL9K3xQa29PXxN5hKiLPoUgBdZIL6ZSuFHUaJ7qcY6fQ6yxNW+jK72AkfigoyiYvbDtAMER1xk+xARaCXl4SePDaP/hwWWHtXB5YdSJsE6SY4YqYHBd0Cb1+4/KFgxmdmV5vP6/KuCKlHKv2Me4aO3q1A4X82Eau5B0OqU6DDnKVhugbT/JM4z1LfPRczZhpMgLZqB3OIw7NToOqDSh+vYC/HRv0T6J3UGbWcywuebTotKKF4i2K7t+hsRldyXEVpcj9NQXHA8UKCtkElJNNzpcfDi8fFskd7V0vglw0W/+abjQF
 hqegZpt+
 7YaRjU9y7tOtOCLpTOmdXe76nKc5aSYODyZtb1qigW6wcnREJukWbWaA2JUk5b5dbfYiveH5/ERZLnkeJY8KVuTz/7P+PrA4wQkevp9JwcjgjcHDLPu+YhLjE5mFt9xCsXlJHUAjrq4j5NyQcqhxFy2BxkTTq1CTjkbGX/rZ/gzWlKdI0kq6npP9WWI+1kdN25ZMS5ud9In1bGE915gvclnLZ/U0sWVVPnEcGLAkGqP4RtVxJ3f9M4gIlxQUZTG0/FXBy1D84UrR6oTDRTN8UQaWD0hwXJs1tiFcyWlb6tHkL/DLSNr0HrnsyyXeckmYi3xH2umLumwVkR4hBHbGxtrEaRELbNzGHahN7dDdVCMDuzBLcU6gZDdjsRh5h+vmdhF8AdHD0bNBRBaehAM+CKJwOq2x1Df6/7B6DV4MJ/emFHx0vZmUXEOtdXzjD9L1XGIPHP9/gjddI3mE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 12:20:31PM +0000, Ryan Roberts wrote:
> >  static int __cont_access_flags_changed(pte_t *ptep, pte_t pte, int ncontig)
> >  {
> > +	const pteval_t access_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
> > +	pteval_t pte_access = pte_val(pte) & access_mask;
> >  	int i;
> >  
> > -	if (pte_write(pte) != pte_write(__ptep_get(ptep)))
> > -		return 1;
> > -
> >  	for (i = 0; i < ncontig; i++) {
> > -		pte_t orig_pte = __ptep_get(ptep + i);
> > -
> > -		if (pte_dirty(pte) != pte_dirty(orig_pte))
> > -			return 1;
> > -
> > -		if (pte_young(pte) != pte_young(orig_pte))
> > +		if ((pte_val(__ptep_get(ptep + i)) & access_mask) != pte_access)
> >  			return 1;
> >  	}
> 
> I think, based on all the above, the current version is actually not buggy. But
> I'm only willing to go to 95% confidence :)

If I understand it right James already found and fixed a case that
violated the invariant right? Maybe it is wise to be robust since
things lock up if it goes wrong.

Jason

