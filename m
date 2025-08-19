Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8999CA0EF8
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5008E000D; Tue, 19 Aug 2025 06:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD1E8E0002; Tue, 19 Aug 2025 06:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375118E000D; Tue, 19 Aug 2025 06:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22E8A8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:03:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9246CC074F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:03:20 +0000 (UTC)
X-FDA: 83793069360.27.C0FA94B
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7DB0120014
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:03:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=hOByNF2u;
	spf=pass (imf29.hostedemail.com: domain of apopple@nvidia.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755597797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMIRFWkHLyrI9I6o9zQ2M19UBmOo2E4Bw1/ACsE1H48=;
	b=mXVuanoFD90By+BHgNqg8pVG/Jr8fBOVaIPxjpm15AgrTBh3Zuz6J59keoa3AttGP8gmzn
	UwrpZkT792zW/K7Bro9u6vWeAZUIJOjG5j4G+rFfLpUEiimpeZoZjszV+dDEBqONhW7nH8
	fGYONmVb1E7yadbvgpE3WDjQ+hzBaVc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=hOByNF2u;
	spf=pass (imf29.hostedemail.com: domain of apopple@nvidia.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755597797; a=rsa-sha256;
	cv=fail;
	b=NRaHvkHYn1agJJ7VcSpxjM80kRoetGPHSePYKfScdO4xjCRa8aThpdzhw3ajM3dW+8MNcR
	e4KFqd+B+0LMQGD6lphPl07U0yE/sR4rIRsC4jl46hAhV2jWAGZUIQWbFEV5ztEaOv5xUs
	tPpJCdGutp8FkUpM5yoYTdFzD7qV+6w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUNSCFRBhurTU/CNM/z/1AaFNFmpveR7SJNbRXb8nkYQCpt4RQ/PVj4RgoZAWklRvVdD4a95WV8LUcrfmVIOOFUGoyxZqheVonWhcfzgzqIc0FoVexGmqY5tL5P9TzcyhpHRHgPgKQu5CsUIjBx68Mt0MJOhj7fHB6Su2zOKtcYbtgWNrwICcxTSnOQzTHNRKk12WloSL6UV8ZbSE7L5Bd1AmbaISwDbYJ+YbV6Az6q+FUfoptq06Do9XRweEk+6DZl8YniyEI2ajwJzoKIrQ3gdAqYzGX/vEN8JgsQzPq0WCprnx6PLGSm6BARprUYOsB5y6aIunR5N/SpGySJpXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SumC/VSzvpwE1LHGvoFyRPRuH37QUOL8/IN8OMRO4P4=;
 b=CKx0SXLUx7FwkvMDasIym93sWoyXSpEeQw5YGV+Q8qb7Tu0WZO6YJWaIBTeGs23KCSCChF/SOeEQdKe1uEwvxOsWYQ1kUAU24wfQ3NiPe0DBQxWEafVhgWLNvy8ptvvXvhEOE3oDZVqfR7vepovWQMVSKNdePYsWEYqLHxXrwL3joPwjj7shZspze/ESIDrqnMnMMv80GwhzQgRS1b8Dwyt+lNemvCQLnwqHN7IbbVnhyTfKvo3ZRjx5pfS4sO+FwUnYfjUwyy4VZ3rRZ0xfBdipZqCEEUmfeb/LbI51bfpk9lCyKqUwvkSvZbMTTJ99bbjzcaqLYi5Xa0dpKjJaqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SumC/VSzvpwE1LHGvoFyRPRuH37QUOL8/IN8OMRO4P4=;
 b=hOByNF2uqa3vAtJk2Qmxb8M0uufZYfwDrbcfMjr64E6C7ialrJfz7o4JxajQNvSjlLETo9kn73QVXaL7udsR/NLiTKAv/klddOm/+LDAN16Q8l+uhP6+Lm1wK0sREPzHMxAV/YYf6MsXQzkDIFPWjQjytF2dHGCbabVNVgA3/hWV4CBRr7+MKjtXj+lhDSNUgxPrD9cHMlWiB/Hq/vq+0uzcd2EoIxs+aHFqpapQyczyrhvFbHCG/aeAKGGmSyGi2nHJ6rAyGtRI3Cr4ziBqCing6uVEoghtykTN4xvif46S0EzAekoruW+SStdaTQbkGLcFBN0UnFKAs++NtDFjqA==
Received: from CY8PR12MB7705.namprd12.prod.outlook.com (2603:10b6:930:84::9)
 by IA0PR12MB8207.namprd12.prod.outlook.com (2603:10b6:208:401::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 10:03:13 +0000
Received: from CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6]) by CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6%7]) with mapi id 15.20.9009.017; Tue, 19 Aug 2025
 10:03:13 +0000
Date: Tue, 19 Aug 2025 20:03:08 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
Message-ID: <yzgn3nbaeftrthqwddwt3gap4uni4api2r2uik2gxoimnpdiy7@hty77udv6un2>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
X-ClientProxiedBy: MEVP282CA0068.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:202::12) To CY8PR12MB7705.namprd12.prod.outlook.com
 (2603:10b6:930:84::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7705:EE_|IA0PR12MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: c29403ce-3ca0-4eca-38f4-08dddf079c3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Q/ezvpKl1oTp6BYtuQc7sRsXChLhCoJLGYSuhJo5eaAHNdtPlA7MwB2Shp?=
 =?iso-8859-1?Q?cv0oFrIAyk37CmANdXAWIfMXdya8HcLQUCpvaKy0RXLkO1KEydYMtNMmRx?=
 =?iso-8859-1?Q?wlL/u5sqDmR+AC9z3wtSgHAapTzTMDTWlbm/RX3bYAUY6Co0vyCUjMovhw?=
 =?iso-8859-1?Q?n9s+f2okXOVzEHfUZxmTz3az3A4GU0n2i2ZcDDoffFOpsvBaJY4XVpXhc2?=
 =?iso-8859-1?Q?s4sv+z0FSXVQuYg5L9RVuV6GR6DUNCX1lv6Rd4kUOsRxvGLq2wvb87E8yw?=
 =?iso-8859-1?Q?Uh8aEOA6iKpaiAchTb7aR4CdtyS4P4AfWVb2AbMFEH0Dliqln1uWkoP5Bo?=
 =?iso-8859-1?Q?cEXgD5LsWcCpIl5LKRgpDm/Adjcb5HMyB9OvVt2+BPHeWp5lxIrkefqeGY?=
 =?iso-8859-1?Q?vxYtRnG+92FMKF7Cjl1IKA5xj23Zenux3cu2YRcQCNbHs1f7efxG9lknNL?=
 =?iso-8859-1?Q?CNtDZ/xc91xyuz56Mx3+FyK9JZaMHPC9f1tfmQkXIGfvlL1p6PvVM7DY4S?=
 =?iso-8859-1?Q?SAq50gJJA8N49cBKDK8jbNMfKzQfKBCKXJSzs0U/IutTLx0/DmhnUpui+2?=
 =?iso-8859-1?Q?hXZ7axQwjXT+Pp0hcbVlDguMZc6VvC6Xe091h9KetK44aX20QcB8+WOY1s?=
 =?iso-8859-1?Q?Zx5RUOhxmOviEfknalJQrF0/PvP/GHkQ1+ByytEOFMh9IFrJ13G3XZoEoj?=
 =?iso-8859-1?Q?sKO9U/MT3OPoxJA7siNi3waGqp/fn0AhFJ1TQp2nKSb60fnwa62sIHGIbr?=
 =?iso-8859-1?Q?Aryyi/6nmxFPZzALaurGoq6RFN33nsWJl9+TULk4IpIE/IU0XRdHBYAcx0?=
 =?iso-8859-1?Q?tBJCiACrj8kylxUxuHTCKtCRlthN1sqUrjPZ3aXgEHIkwK59qtUc+VhBmD?=
 =?iso-8859-1?Q?lQ2HpwE5rWWH4DAUqItyL84U3qegj3NObKZsb8Cqi4gD+HnrUVVy54geRT?=
 =?iso-8859-1?Q?rx7yBjr7wASMSOhNSl7DFBYcMGKZrV1LtrCMKLt9cbnVfuNMCDBzWLidd4?=
 =?iso-8859-1?Q?5L+SZNtEwiPP4NVs1XNuzjTTt8eOc8SVfldpjTTv/i6vAUVGbBBtgpm7xv?=
 =?iso-8859-1?Q?1ZnklEytSKvbzUklIcozyRJhrolZdXuaCHfyM8Dug6taNjZmoqjRbdKHh5?=
 =?iso-8859-1?Q?oOeIFWWcWLrlQYri0ooH/oeDO+7LUXQS8n1CVWV1xKzjsrr3o74SLW5JhJ?=
 =?iso-8859-1?Q?LvNsQ+ssmHNmrMhNgBhgmasHJ5eYSo2nXk/tdtelr89MQJGNbF/9L/SCfO?=
 =?iso-8859-1?Q?Ypwe2UrqW85ssdKl4HHKR6lMtvhqw47Mr+ioSaFVGEPTx10B8hoxVcyNAD?=
 =?iso-8859-1?Q?G0QmKh0tuw+hNyAQvgqMSIHctFfA3DyYl3VqT7vI29INTgzF/RmOnt9nwm?=
 =?iso-8859-1?Q?QCydp0rMmVsnmCnqPs1t+WaZsxXnclqymCzNLl51fV5ulWYfxmyiwd/lRB?=
 =?iso-8859-1?Q?B5Z3zNjuTjfZOhAZjV0GjLTaVCS7XVlrEcQuESPEQGF47/WYwANXF0RRV8?=
 =?iso-8859-1?Q?E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7705.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?xdxL5euI9JcKZFG0W2hICIpyif9S4SaDFzuM09y33QvWOHlzZQ9JuRVsOk?=
 =?iso-8859-1?Q?YjSJbfYf8oan48VPvPo5rb5GlU18OiN3C5EbzhizUxz4No2z9OS5aPEaR7?=
 =?iso-8859-1?Q?cJ3qKNsXvPVVvC3XQ12BcmjgQTm92BupMPNnnOuY95TZkQcmHg2XX87RF6?=
 =?iso-8859-1?Q?UeZXf0IyBhMebzsLJM30OYXZHO1pTDfWnGBHOJYh+Z0hWcQu+FEtDaH4a+?=
 =?iso-8859-1?Q?PYDmJB1v4I4HO4ISCznuhoBstFsKxPJCa9PFj5/g5AMVggroHnIRHJWeoi?=
 =?iso-8859-1?Q?DgMhdr5MvhosIlCbhkjok5pjfZWefbGV1zyyy9/nEUUYJ5IM19Qwz23eO7?=
 =?iso-8859-1?Q?M7Jbw+v0SJrrJl+6Ud5anpbcJRL+JwHnnmOXqN0u2ATwBDZKTNjZYSC+qR?=
 =?iso-8859-1?Q?HBKjtw/GHuH75wkbB1i+sHtJT3U21RHJu9OREpesp2EfoU/62ZkynZhjWw?=
 =?iso-8859-1?Q?WW+QQ4VsSLKfOEDyIdxqDfYi+5Y5EoDdEyNw895sh+ZsfkGfd+sx9u0Ojp?=
 =?iso-8859-1?Q?fW17bOVvcmgaDLCwrsU7p6iC1AB8YgoyGax2seZTevWcRiHEU4Rih8Qm0r?=
 =?iso-8859-1?Q?rn4JjXKsBAHI5xqfkf4A0kQu0SL0tbtIy3CRv7tYyFGihaMuew0gegmo3b?=
 =?iso-8859-1?Q?AhN8MiCpv52ZwJCCA5BNvExq+KvyY/luMim0Z6O/7GZXiNwysr+uPp45Xx?=
 =?iso-8859-1?Q?IQRl2idP6yOpLDZCLs82Fu3Fwww49d4gLYVaBXK17xqBViwnADxs1JW0FX?=
 =?iso-8859-1?Q?ftRiorA0ts55xyKM2QZsl2h/fNHS3f9Kd3Qv2mv3jdgPH06FjKghJJJSCN?=
 =?iso-8859-1?Q?Dw6Di3OLIA/In49qEhEEVRkVxUWSopm695Gk72LyCJHHtmFyH5b1FDkIwj?=
 =?iso-8859-1?Q?3O2k6Bhwi77Na/D8ZLtL4nW6lhpqhvt6UudkDE7krChVsOvEyj90ZMzgHq?=
 =?iso-8859-1?Q?Hb74dO6I86AdqtUXU/VcuRXJhLPub6gIPQial95an4BBISh8u8i7rqA23M?=
 =?iso-8859-1?Q?CDG8swnwCW7z4uB5F2Z0Ova8TZWgAs7zg5AlZT1IpdJ+jgXlnFabLVbPnY?=
 =?iso-8859-1?Q?1297PMxWxPhp9UCiIqsMrEzMNSZw8LSngQGhnaHbb6td0KrnaLUMYv8j+1?=
 =?iso-8859-1?Q?Sr2+h0MBPTVKkoC6TLV2YeRZBlbotOU56baDP+/A9pU/IXJf8n/KIxXxBD?=
 =?iso-8859-1?Q?8e6ZAKJta+hgqcdLTFDzlApBNcVkKsaXfAyyYzvU2lA94fRwG4kwjsTOEv?=
 =?iso-8859-1?Q?IyyloUCZABJsLDbikBTAn0xSmcB6kkpy5aFi2UrKJ2S1tsvLwWfmmYPoF3?=
 =?iso-8859-1?Q?2Mv7AvpSEAqHG0masEM9n34R0TPW3EZ1TJUJOmp8iCYIWM9nZCXPZuNwS5?=
 =?iso-8859-1?Q?fIsAUBnLAJBNqqfKZul5XbHj1oQGD28ja+H0Y3weGANbPN8G3f1wA2GOpX?=
 =?iso-8859-1?Q?e+MC/MsHp9iRhNbDMvw+uKf1Kn77xMo4d4Ru0ozF7TbioXyHXjW7t4xDfK?=
 =?iso-8859-1?Q?gggfz568FKkImDBtS7ELn/rTaBdXAZSblY4dsxzmJD0Lf935lW0WZIRn8Q?=
 =?iso-8859-1?Q?w5TMlc1PVq0od6fJXgAaUClPlRCcHAgintpvZ4k55wu35eZUtNmQ2kdiD5?=
 =?iso-8859-1?Q?UHRRHHCousM8PC82QT+cDBoSJqzKB7Zom0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c29403ce-3ca0-4eca-38f4-08dddf079c3a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7705.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 10:03:13.8027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8p83f+86GxI1M7F2+w6ciD0ljRF1/peipv5s1keX37zkmxfYgpfdRIxg+YQzqOFOztnK7LBfkl/qtdf7zvS+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8207
X-Stat-Signature: jcksw9pubt76jthm6en4648xfa8g3fbd
X-Rspam-User: 
X-Rspamd-Queue-Id: A7DB0120014
X-Rspamd-Server: rspam05
X-HE-Tag: 1755597797-545831
X-HE-Meta: U2FsdGVkX1/7m9HSNPpjJwAtzY4CejDWbqXGYZrg6EG+suFkY2bKbn9yskQxt6FzBO5rvGxU1/E1w9nHqgMtJfzi8uffu51bTwYfafUDY45yEaixdx1tBCPTKcC/VxpwO0/U8iRnmMqcNW5klS/9or0zw0Pa3LipUsimIla96Gx+5WdHuCdlTDdgcmzPz0ZDiJXJdl4A1qyOWiaXcKHyr0DOXYRv5RotoF8JyfLj5b8TtyXwaqOOtDse1MQznEy+PkL3CWez2roJcS3mX2+6xYpgl89+w4OA/Dx/ixAPJvhUu8NFyn2ChAvLVQ7QHSmK2NcRP8X1Yg7XwvdQd1cxb90oV6uuM0745up8asGt/L25pjYX77Mm9MY/1QDYMqvtCkvgdhU2wxahOSmnAtpl4mmCxCXczAMETjRwjEyWLSzfR8Goq4ozCajZ2Y7OPbhkQ5BouyTI4ZcRHNHD+1uav8sj0VMXo4x9ywQMSmyMzvXxNhrm2/rsnCO3uA8vC6SrCQF9isL2aX6ZBZjHUeAs0wR0GDEQAtpG8VjAhM3qNtUUaPjqzwxxQUYsyBG1PoRnOYguXGB7eZ375tidENNj43ZbvHl0Et/lwMnx8HWXf93b1A0YBOgQtSCbdJfcMkSQKBw4D5tjGN+7MXIjn7NL8GxAlYfc6OxO+/mIXmvz01IuFeNRJLF//g8YYT/1TQGJekoKtzSOssvzB7zJTbjOXRWnVsdv6o8Pv1hTnCGadag2GSLDMdfjqavdkCIEKzqfoIocNS+x2IyBIOQD8A/h8hRWxv1lMwyWqxSlSZCBl7BiTPeJlR/EzoPpXEmbYqsMZR9eNqDnoI86swKvVTVB9YwGNRnpJJjN5ZYPs4M0/LWm4nWnx76ptwY03zcExozTxwk9MHYYh2XHxQd4h4lST1QpdpNOIrbu2YS+cDUp8e+GmtIYq6ngT1oMOg9119YHfBoYDoYuoil2kzrWenN
 dRMb/DIq
 b+tcfOO7vX5vv2UP2NZyb0jlYBOJS0UA03OJSJzPmiRK+JFgwkaYe/dyomm1j6z/TMpPlVLvHljV8FJeS9EWxuc6yXFNeatIPxOZHQyhJqc97J6bPVYOrS1SoX+weVVzcQRrOLEG5OITvx/kNgt4XKtFXYlxj5JzT9KuuOwgdYfbssRA7Ct/fMKRqWA0qrBLj4qlYjiuNiUlzPT5lzk/H3TBDveSoDQ59F9NwmlpObXU+6srQSCXCnZtamzts+kEJDnrkNK0Uwq8cgMXhblLUHA5wTZwiQxY+g0vkj9U+6Ei8LfIPJAoskA3qg47wgdCk5JUKjDyhFjBeXh1UjHgFPhGZ47QxHZB0WRNcwPHI6g5r/DL8b2Kk6xvUwp11NMn2JgGegK4fN+PYN++75h+Wi/T2Ie1lDQWaj3AyT5CE0ZNaJuntLfwXSDGkQV+5Nc0SbJDD4xeb2Kl5yA7DrRjz4eAPWIHHsl1eGTdQy2Um1Yrs0XSLo4FXqfrR+pDSukk4E2iIibdF9SggkM3C6ttTAbw7AAGUGcKjPyBLIjZNXi2u0AwRVuCGJ9jzUEntex83cQ0p98JH9zv1Da8mOTbWGymuLFyrjGntPoVlFRblCIo+sEdaX7gkz4Y6ZatKgv/pQHMWD3K/HgQ7UsKQQQusHEMFLLY6E3vO/89QOzEh6uvNCqf1JGqw61m1BzFRvVdyxgKMBnym/3aeWTl5v8SB6cRKfbOuQuwi2uFMZjrxEY9t7Q1Jxa5hv9GzxVT6I5dsqvAUm1nLNnqBjgJ/lXfuuqyv6UOxPNAq2JSOUJur7Q3gHYjsNujaX0qgX1bSjc9WV96ZDraACVlylyw0urtg0dPUSZkrgxqBmz/005dKXVe15dwFiGJSqTd2hNc5okb1yOS6cXVxo8YtaXFuHjt6gsQFEtanYCGuqOYQQbsAjqDVwmTwuPmAPqSUh2BACPrk97ln+QDjxuTyThhn/WMVEcogMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 09, 2025 at 03:51:32PM +0200, Thomas Hellström wrote:
> GPU use-cases for mmu_interval_notifiers with hmm often involve
> starting a gpu operation and then waiting for it to complete.
> These operations are typically context preemption or TLB flushing.
> 
> With single-pass notifiers per GPU this doesn't scale in
> multi-gpu scenarios. In those scenarios we'd want to first start
> preemption- or TLB flushing on all GPUs and as a second pass wait
> for them to complete on all gpus.
> 
> One can do this on per-driver basis multiplexing per-driver
> notifiers but that would mean sharing the notifier "user" lock
> across all GPUs and that doesn't scale well either, so adding support
> for multi-pass in the core appears like the right choice.
> 
> Implement multi-pass capability in the mmu_interval_notifier. Use a
> linked list for the additional passes to minimize the impact for
> use-cases that don't need the multi-pass functionality.
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Simona Vetter <simona.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: <dri-devel@lists.freedesktop.org>
> Cc: <linux-mm@kvack.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> ---
>  include/linux/mmu_notifier.h | 30 ++++++++++++++++
>  mm/mmu_notifier.c            | 67 +++++++++++++++++++++++++++++++-----
>  2 files changed, 88 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d1094c2d5fb6..1107a8eafd8a 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -233,6 +233,32 @@ struct mmu_notifier {
>  	unsigned int users;
>  };
>  
> +/**
> + * struct mmu_interval_notifier_pass - mmu_interval_notifier multi-pass abstraction
> + * @link: List link for the notifiers pending pass list
> + *
> + * Allocate, typically using GFP_NOWAIT in the interval notifier's first pass.
> + * If allocation fails (which is not unlikely under memory pressure), fall back
> + * to single-pass operation.
> + */
> +struct mmu_interval_notifier_pass {

If we limit the number of passes to two maybe call this
`mmu_interval_notifier_finish()`? ...

> +	struct list_head link;
> +	/**
> +	 * @pass: Driver callback for additionall pass.
> +	 * @additional_pass: Pointer to the mmu_interval_notifier_pass structure.
> +	 * @range: The mmu_notifier_range.
> +	 * @cur_seq: The current sequence set by the first pass.
> +	 *
> +	 * Return: Either a pointer to a valid mmu_interval_notifier_pass for
> +	 * another pass to be called, or %NULL if processing is complete for this
> +	 * notifier. There is no error reporting mechanism for additional passes.
> +	 */
> +	struct mmu_interval_notifier_pass *
> +	(*pass) (struct mmu_interval_notifier_pass *additional_pass,

... and call this `finish()` ...

> +		 const struct mmu_notifier_range *range,
> +		 unsigned long cur_seq);
> +};
> +
>  /**
>   * struct mmu_interval_notifier_ops
>   * @invalidate: Upon return the caller must stop using any SPTEs within this
> @@ -243,6 +269,10 @@ struct mmu_interval_notifier_ops {
>  	bool (*invalidate)(struct mmu_interval_notifier *interval_sub,
>  			   const struct mmu_notifier_range *range,
>  			   unsigned long cur_seq);
> +	bool (*invalidate_multipass)(struct mmu_interval_notifier *interval_sub,

... and then this could be called `invalidate_start()`. That might address some
of the concerns with naming.

> +				     const struct mmu_notifier_range *range,
> +				     unsigned long cur_seq,
> +				     struct mmu_interval_notifier_pass **pass);
>  };
>  
>  struct mmu_interval_notifier {
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index 8e0125dc0522..dd6af87db103 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -260,6 +260,22 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
>  }
>  EXPORT_SYMBOL_GPL(mmu_interval_read_begin);
>  
> +static void mn_itree_additional_passes(struct list_head *additional_passes,
> +				       const struct mmu_notifier_range *range,
> +				       unsigned long cur_seq)
> +{
> +	struct mmu_interval_notifier_pass *p, *next;
> +
> +	while (!list_empty(additional_passes)) {
> +		list_for_each_entry_safe(p, next, additional_passes, link) {
> +			list_del_init(&p->link);
> +			p = p->pass(p, range, cur_seq);
> +			if (p)
> +				list_add_tail(&p->link, additional_passes);
> +		}
> +	}
> +}
> +
>  static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  			     struct mm_struct *mm)
>  {
> @@ -272,17 +288,32 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  	};
>  	struct mmu_interval_notifier *interval_sub;
>  	unsigned long cur_seq;
> +	LIST_HEAD(additional_passes);
>  	bool ret;
>  
>  	for (interval_sub =
>  		     mn_itree_inv_start_range(subscriptions, &range, &cur_seq);
>  	     interval_sub;
>  	     interval_sub = mn_itree_inv_next(interval_sub, &range)) {
> -		ret = interval_sub->ops->invalidate(interval_sub, &range,
> -						    cur_seq);
> +		if (interval_sub->ops->invalidate_multipass) {
> +			struct mmu_interval_notifier_pass *second = NULL;
> +
> +			ret = interval_sub->ops->invalidate_multipass(interval_sub,
> +								      &range,
> +								      cur_seq,
> +								      &second);
> +			if (ret && second)
> +				list_add_tail(&second->link, &additional_passes);
> +
> +		} else {
> +			ret = interval_sub->ops->invalidate(interval_sub,
> +							    &range,
> +							    cur_seq);
> +		}
>  		WARN_ON(!ret);
>  	}
>  
> +	mn_itree_additional_passes(&additional_passes, &range, cur_seq);
>  	mn_itree_inv_end(subscriptions);
>  }
>  
> @@ -431,6 +462,8 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
>  {
>  	struct mmu_interval_notifier *interval_sub;
>  	unsigned long cur_seq;
> +	LIST_HEAD(additional_passes);
> +	int err = 0;
>  
>  	for (interval_sub =
>  		     mn_itree_inv_start_range(subscriptions, range, &cur_seq);
> @@ -438,23 +471,39 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
>  	     interval_sub = mn_itree_inv_next(interval_sub, range)) {
>  		bool ret;
>  
> -		ret = interval_sub->ops->invalidate(interval_sub, range,
> -						    cur_seq);
> +		if (interval_sub->ops->invalidate_multipass) {
> +			struct mmu_interval_notifier_pass *second = NULL;
> +
> +			ret = interval_sub->ops->invalidate_multipass(interval_sub,
> +								      range,
> +								      cur_seq,
> +								      &second);
> +			if (ret && second)
> +				list_add_tail(&second->link, &additional_passes);
> +
> +		} else {
> +			ret = interval_sub->ops->invalidate(interval_sub,
> +							    range,
> +							    cur_seq);
> +		}
>  		if (!ret) {
>  			if (WARN_ON(mmu_notifier_range_blockable(range)))
>  				continue;
> -			goto out_would_block;
> +			err = -EAGAIN;
> +			break;
>  		}
>  	}
> -	return 0;
>  
> -out_would_block:
> +	mn_itree_additional_passes(&additional_passes, range, cur_seq);
> +
>  	/*
>  	 * On -EAGAIN the non-blocking caller is not allowed to call
>  	 * invalidate_range_end()
>  	 */
> -	mn_itree_inv_end(subscriptions);
> -	return -EAGAIN;
> +	if (err)
> +		mn_itree_inv_end(subscriptions);
> +
> +	return err;
>  }
>  
>  static int mn_hlist_invalidate_range_start(
> -- 
> 2.50.1
> 
> 

