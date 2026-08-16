Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D67EC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 21:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9956B6B035E; Sun, 16 Aug 2026 17:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9466F6B0842; Sun, 16 Aug 2026 17:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835546B0843; Sun, 16 Aug 2026 17:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3846B035E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 17:47:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58B51160123
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 21:47:49 +0000 (UTC)
X-FDA: 85108470258.12.B5DC4E5
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 62812160002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 21:47:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KSHNJDKw;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786916866;
	b=3rjxelZ36D9YxTdrgDhqnXYJmvnp+b3+Yxu3eAsyEDHkngl57BRSnY5yJqzDiBaR1d7KC7
	DI+czRSs1DulUM3lqola+P4qP2CqkfOjTfUcpMzV6Rax/W0oC1LZpQ1hKyBoPxbvLvy+r6
	0yvC65emZ9OY1gP9whkvmpF2oxvweZI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KSHNJDKw;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786916866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iw1c2hskQAnJ0l6LdX4uZCVkF/H8666W1CCYcdOnqo4=;
	b=fJY50Wi8u3dFhdsj6ZdLHJGLXy1U8Hil+KrXXS9GzhXksF/BNcGHNKCABybSuWeiKD3VGs
	+Y4pbX1h+2IVrol1lgRMfgvekl6XrKQQA26ibEeK78RiUZbSUJP2e/3TfA4nyWW1tNMu+i
	8hfCCawgSAnNHs0VE7El55AV6ZxQyAs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U4O/OecJ7IxKwlUr3qwZyZIIKzb8AmXIS7YSjJskMHoYTNA43PEqVIpGqc8v68Skb46zsP8JTVrX2sUYVX8kB01T8oU8Wcp7R4Qo8ZDynG3kw/qheBcXGXRHmX2OHV3OZIPugYwKj8wB4P+qC4XoBfg5P0QkUKNG0Wd6k94xqvPmhYavzD9Egm6gJe8QSkI7k1zBZFzZIGKlKFPhACtAeksJgl4klN5lYa63vBIxVRTMphlC4WMy9Dn7JQljtEKnpSVAZAMBAj6vOlTusZOZZX+T11M3+j3bPGL7VQ7JT7MuepFVoNHRUx5oAhaEdbL1M4plws1Pecjxq2snkHIsaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iw1c2hskQAnJ0l6LdX4uZCVkF/H8666W1CCYcdOnqo4=;
 b=w4v3gnwPoiUC6RppdzdizjIH2aTP+7vFBDAoDoPothEwawUSU2YA+ayM3vJv19f0pHmyEbRnLwY2rOWIorgoBF9kKJ/QkzDmbtBREQI5rBQIYszoo4ZuR6NLSjkJpXYrRohT5wZc5MMWDiYA2Wb256/UupVErlBsWkjmKuv8ex9ozyM6bKnGLiBq1XaRQhyMv0z/WzUn3l50k/jIvSou83wRLR4db+UXuVUX9l/oznwIHyVb7ESIo5/M/OxltKPUgz1Y37fFq40CpjitgxizvUIcMWAQ1xspEUvzccbY9DHZmpaM6Fz82OxohtrfvyMH2tIf9D5bkGhUcHNxcU384Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw1c2hskQAnJ0l6LdX4uZCVkF/H8666W1CCYcdOnqo4=;
 b=KSHNJDKwkWhagepglpIgJ0Ctg3cDeKe7djMuMApii1gYY1IZr4JobkDVn9SXo1Q9lbZrFQ3oTJA5cVj+Qz0DRVgUntIYmKFcvF/KyNd6mBjVG1Qc8K17YcYqRvQk+1ZytUxgI4juELOCvtzTZ3HlIELniK/yeEEJV0QtJM5zgnnW5q0CvRVOMpjCTJ3aNK9eEEqm2ORNaglZNbA7mOcYF3LIWYySZBc8dtSJ+GfZdgHnQk2vA4AldASU2qrNzqMeI5TPV4aKYptWdn050e3W9uB0A5vVrUBX69+0uE/6GKH98Cyzv4IMCX/gAdZCN6FOx7JWvHaRwZh4/ZOYS0ytMA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM3PR12MB9389.namprd12.prod.outlook.com (2603:10b6:0:46::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.17; Sun, 16 Aug 2026 21:47:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Sun, 16 Aug 2026
 21:47:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 16 Aug 2026 17:47:34 -0400
Message-Id: <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
Cc: <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>, "syzbot"
 <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
X-Mailer: aerc 0.21.0
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
In-Reply-To: <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
X-ClientProxiedBy: YQZPR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM3PR12MB9389:EE_
X-MS-Office365-Filtering-Correlation-Id: 028180d8-3792-4176-d76b-08defbdffc56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|6133799003|22082099003|18002099003|3023799007|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	qftWpSFyCMNh+zpkPLyqQhhHKm0LZDdyAgHLDWxwIwb0SqwfCiRC7E9/BegIxs4nfSi7n9GUzPc9SThJzhXXAB8n1CrnkmIMt4vIZ/BsawA2gnyt8JNxZjHS+FIHS+Cu2erk/Aev00Bu3NgdE/OV7z5eT8dw1G2eVrqoxhUX0MJmSbJofz8aluA+rRYkmir/ULv+AH6kxkB1p+oSgFHWO7K7E3LUWk6Vq79WcxegIUJIW3ERP7jItp1Wi8mCTo3M1ZBVhggEBs/f1ie4mJai3RHyi7jJObsy1BYKW99X0IkwzyGPhaagqHATt5nDDPtBM68fFpxiuFsvh8KjZ9EbnxO7R1UyZVV+HVl223Oqjr4HYmUa0R4a9vulRZ7JfYcCO5WkCL809rfgGlX28cwYWCzu5eYv+zrN0uVSZXKwMh9VcTHqr1GpZvGvresCoNHpjXK8C2Vu5rNc+0regL3Tvs/UmIUkIiIrjYeTJDi6WhQ/DmRRgn8PJfiLrEKrZ30sFgIwmiCWrDI3akSNTDvId486m20NulAUtxX5yAswjAB2FqEX9jUkn1WH+9bG2uB3yZnJN8iIOjoZsw0MzP0Tf6icKqEEIT3xzOfHYGOXpqZMzljYdmPdxL6c4qVSgM/ybyfr1Y2Xxuttzczw386FRAW5XPJm97igw92HonJXDAQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUlQUG8ycU5xbjRjcEUzak9idndMSWxTakpKTmtoQkxYeEk5dFJaeCs4Z1l0?=
 =?utf-8?B?T1VaZWovcDFKQlpJWGZObjl1a2hxVWVtblhzSGg1Z3BJa2U1Tkc1VllTdFVT?=
 =?utf-8?B?YnJLN3ZuT0UyUWV1cnNUY09SYmM2b3o5WkdHUnUzOFU5SXppaWxaa1orb1Qz?=
 =?utf-8?B?WlNqYkcvUFRRMjJPdGExY1hYNHhnZ2Nod2Y3YWxRMEVRM1pYdzRselpjYVpq?=
 =?utf-8?B?QitwMnVCRHVnaGVVNXdvR0pYS0U3YklrZE9hSExta1greHo1TENYSHpMY2VD?=
 =?utf-8?B?UTVFcUtuRWltclBrUkE2RFpDcU14YUhwQzkwTnJiMHRKQ3gzM2NrdkNmVTBK?=
 =?utf-8?B?aGx0b1lpUHhWa3hYK2ZIVW5xWmxpbFV5ejFvTzlQMER2NGJXNDU3d2tScnZu?=
 =?utf-8?B?RisyYzlqMmFEbzZTUGdPMzRhRkR5SXNnRk5BSzArWE12UjQ5OU9aalp5VFk1?=
 =?utf-8?B?bG01bXltUzJqVVM4Qk9nRHF5WEFRaDdWYjRLYWNDVzlaalhDUVFFcnZydHha?=
 =?utf-8?B?MExNekZjNEpNRm5LNnZkZitONkt0ZkxiYjRHTkkxVnEybkVDZDZpQkYvR2Rj?=
 =?utf-8?B?YzVnNFhaUlc0VUUrVmZ1c1R2amlTWWphcTRFNWtoTVUwdTVmTWJBR3ErZ05G?=
 =?utf-8?B?SjdqYnlMZVo1WGNxWkgySlFIUW44dHhTNDJZbSsyWmJ6RTNMUUtwZHZ6cmZE?=
 =?utf-8?B?N0M4Zzd6VXZBc0xBUHl3QnhUS1pCODNwOC9XTkY1ZmR1ZFZMYjUvUU9Ua0NF?=
 =?utf-8?B?U0dFTmVuVUtCYytURWswSDhRd1Q4VkZhUnlFTnpDTHByZ0pKZjRmUnRuUkJG?=
 =?utf-8?B?UDk1NDVHcU5UaEllL2NYUHg1emFYL0VNRjRSZjZBSEw4bFIrT0oxWEdEVU9G?=
 =?utf-8?B?TjRMVHlNUHhuaGNyRlJ1OVBWaGo2dUkyd0pTM1pYTUhwRVRLVDdRd0k3VnJW?=
 =?utf-8?B?L2sxM0VVY1lsVzZNcDFBU3lOZ1hlVlNPRXVlNkUzZldoYTVucTNGYUVaMkto?=
 =?utf-8?B?MXpzNys2dDhQWDM0UW5oUnhOb1MxbXJoT3NCK1V5cVF5OXlFM0dtOUtOYnhj?=
 =?utf-8?B?ZVFveW5VWE1odU1vUWhkN0JuNTVDZG4yVmdSZmhpRktBMVp1RGE1SUluakRv?=
 =?utf-8?B?YngwRVhkcHM5TWFQS3dpT3JMMU9tUVNSM3Q1V2R0djlPWEJwbnFKMUlRZW1j?=
 =?utf-8?B?QUxURUt1U3l3RFIvbVJUTGRaUnMxTnZGRmYySmYyL1NzSHA3TlR1K2ZJVUR2?=
 =?utf-8?B?Qk1vWnZMNUs1L2E1dTVCeTAvUXFMamVjdW5nSHlqdzE2UGJzaWVMWi9rTVo3?=
 =?utf-8?B?b3U1RUdOL0JldU1Zd3NzQ0J6cXJIRHV1aXNBSm1jMFVXVzZnVHkwTjR2K3dZ?=
 =?utf-8?B?S0x2NWs3UEJXN1llZHZEaGFjRnNWVlFDNFVDSEhna0JuU0dTNldlWWtvL3RE?=
 =?utf-8?B?QWw2eXhHc3VkZnRkMmZuOElTZStqNW5IKys3QVdOaEZXdFdxcU8rbzJmZEEw?=
 =?utf-8?B?ZnFHVERBbG1iWmU0RTd1TEV4MVZsSWJaQVY3Z2g4blM0ZElwejEwOVhIZC9W?=
 =?utf-8?B?Z3d0K2p1VncwZDA3V0VjMmZnNWcva2hHOVEyOS9KQUNoUUJtWkhrQ0NVRWhK?=
 =?utf-8?B?cndNS25Xb3gvRWR5YUhKQW91eXBJYzJ6cDZ1K3VDM3BXUXFjSXV4SkdrUmtU?=
 =?utf-8?B?QVhJTEduOFluREpYaVdUOURjcE5KWUprVGh3aHA3Wmx3S1U3TWNvOTBDOE9i?=
 =?utf-8?B?d2ZqYVZhY3FzR2lsWTNjbkl3R1cyQmh4SkpJcDE5clJMemFSRTBnaWpvZkZx?=
 =?utf-8?B?N3d0RWRlTzNQbVE0TmY5cEUxN3pBZE5UaUhHQy92M0dYeHVXdjVndjBVM0Fi?=
 =?utf-8?B?ZXlKZG11a2tzdE1ZMmZVbHdmc2lnVk5Kd3RxV0cyS2VLMmNTS1ppbTdBN1FX?=
 =?utf-8?B?U1ZTdk9GeTVmRXlDeFBJeGk3NG5VVGk3SEdVcnQ1dTIxNXdPbWYwUENyZ2lV?=
 =?utf-8?B?dlF2dmhZcE4xdHpVSElNQ2pqRWg3TWN4V3lvNHA1R2N6SkhDL0pDTEVhcElO?=
 =?utf-8?B?T21ZemF2dE1XS0tmTE8vc3Z2eHZPendHN29GQmFJRC9iaU9MaENNRmhwSG9E?=
 =?utf-8?B?VEZPWUJFd2NzUDhnMnhhTk84YTB6NHhnOGR0QldRSUxCTTdtNHkwdnQrcVU0?=
 =?utf-8?B?RExQa1d2c2ltNVpmN1JYVmZIbnlRMDNZbllyc3daUENIb0JJN2duN3NTVm4w?=
 =?utf-8?B?M2RZeE4zZmhWaWh2TVJYYjB1a1BLRDNpY2tXVHByZE5yOHFQSmxCb0FwanpY?=
 =?utf-8?Q?15EBCRJuIt1AfSV3TZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028180d8-3792-4176-d76b-08defbdffc56
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 21:47:36.4164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESWIhWxNa4oZ79vS4V6ZzCQHsSp2LFeK5/RW6bSLh12JvOLlaiUv+ouxBvtspuCc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9389
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 62812160002
X-Stat-Signature: gewrcygm1xyrubzntfq7r6krdqg669jw
X-HE-Tag: 1786916866-543668
X-HE-Meta: U2FsdGVkX19Kg2b85Zs/dsRhXKR5XA8oAWicORWYqMmAfrEzBBAGEad6Nuq2PPGqnE82Lm0BADlHasTLG/V8r3+fe0wGAEled90fw3TiDQdB6ICrdHFnqxoIrk1D1pqf8ZgxedbKUCxl2r7y1b5AsEveXtVk20E8SnuOXXlYK3g1Gb3dXUcoGXP0XdHrb0/mRHQkUkIFNrw0Pw4cRCcO5tXxNFBSbE3riCJIUeZhk1L9YssPXvxIjaHP6pFQJ3b2Wxpz2QdTKb+pAzaGRPQcQi0jh6+s9QHOZsxEDi5NwkADUwVQPoybfkfCuGLswZ/QF8TgngRWmokU6fsNlyYSBmUHhBLVMtsXCAxEQu1B6G8IzoWZ8RfP+0kToHOElLeA/B7a9I/DxT3oDjUoOrWu4FTUsX83eVWqnjuPd+c52s3o62ezWtV33g1KT7crVtGA6Z2cY9flk3/whLW+HjkZaAW6M3+slbihR27jC38n96s6i9sY8nhlQoIVcT5hfZJP62CJE1J/SXKWM66LbLNbUdEwHBHWGWBU9j4yRdzQi9RrE3L6rGd1DXvcmQtOcy6bw6tp7jtlI0sglOJfVpGkog2lbLLMMqWXB7Afr2v/g85y4zxPKQvA4yMqOuDsnS/oXPvbDoGvVZ4saMWjEjrHQCFYViZ7ag4YKx8qYhZbVuAnfSprK4kCJHqv6SkcvYWpr18edWnbAQFRB61SkC6IhAHNyd0j38VCdeNHlde3uhcP8fV8JaluVYlFRPaHigbl9Cw+t5e2acqRionOY66789sKhMWk4v0xQHFJioVya63otEjGKy271U9zkrW+0hgciT1hF/OmKqtIcMPj66sNphsgNg0ALK8GuiMnrtmAAG+FBdnE04DltfmtDz2NB/hqpXJJfAfr2wCx+kcurk4hzo5dam+u2pU5stiXYcGyztCleMfs7W7nf2ZDY3iBCUspDZq9Hg3HBWlwHT5WLcZ
 BfFi2L+U
 M090pvG0TDYQeaAdX5re5X+t2AzoRQJhqI3RLvRJZ9S+zxYPkypZiV2RV01/yacakzmPVhtftjz47SUD40KJDy9vUV94A58bDBlOCJJ+0moJa8cnqgn4iIht5rm7i7+t+V07f6Pzm0NegMF/9ySxNi95hUk7rSzzxPaJU0U6NmXMb7sEUe5wdbuJX0pjH7AtrlJczTm/KGNecguXMgGNp6nOx65ovk/SYjDJn5C9+emn23oZfL6bHqvO6KKKSapUbXGi/cqkRabFf+EkbP7286AfPqjs1S3lUm7sG3MuYTMwjwS9YYzz0a4k8n/LBwYmPM1d4o7gqY+gvpNMnAUFoWBs5xpC6SGbvWl7VG6yZScMlJgHCJYDT+8BfFntM9oJcum49SYcKeIaVxZmEkn8EeVDT35FP4XBiWLoyoSaNJRWRTEey3UxKXRssk0QcttUjisSrEgAxZcYWChRnwnXHJc6VEOcl8jCTUOeHd/XBv0SYYsto4B1OKZGGwanfmY4iL69Fm0HkWfM3x2WMnuqlfyM3TI31KehJ/4VBGlFY5HR/bDDsCiar7Vf0oHWxvAHClBi+bNPd+GAK8TQUgV4Ku+fs/52nzrRUeL+mkdoIPjiGijoqXilm/ou4CG3dQL6SE5qegWCu8IDV/gVkJui4/lj0N8LvgJnbauHwojed/8MzVD7L1TPDXfFYOjPTPn7OemC5XFblC2TUYZvSAh7Q+H4Z39ozPYhZAzAI/8Du33SX9qeE08QED1GSeJSquyyHRUGFsdS3U6FV/+6r57DDyBqYb8mOq0OWCrydOM0Pxu1x+Gh3lS3Z2X4uf9BV/XBWHJAt9Da2tkpBbc6tSopdelBpMPGYG/ydOh2VuQb4ng4zRWfsC6DdKvIu5MsrUKH3kAuN7opQdw6Dc/eXbusj+syxMv9Jv2T70qFMlJVYaanC6aoalQyddl5zDF9MLtkyY7LsznHE1S6Q1yxy125VXWc6CZt8
 1ZZNVf81
 GDMQiMaiyXKagylk46oxsVLx8rn7OgUoCYXONR5j8gdsBeGHsGx0R4ufdN9o+AmakNrgEc/GSwBn+ZMqJtjjjUXtwGPO6NPtLCENDa02MlxH4BLoxJ2+fKNXD4G661PfBmVF24c1qS6NJIYNPBgziz9LFlgysh1zg9K6Q6CPg6P5BfDU19pUJ+9QK/oJLYb4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 16, 2026 at 4:52 PM EDT, Andrew Morton wrote:
> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@sy=
zkaller.appspotmail.com> wrote:
>
>> Hello,
>>=20
>> syzbot found the following issue on:
>>=20
>> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.=
or..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D159274795800=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da59830cba91a=
1981
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D805630f1453e49=
0427fa
>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e2=
55-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>=20
>> Unfortunately, I don't have any reproducer for this issue yet.
>>=20
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/=
d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlin=
ux-3d6d8176.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/=
bzImage-3d6d8176.xz
>>=20
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>=20
>> gadgetfs: bound to dummy_udc driver
>> ------------[ cut here ]------------
>> 1
>> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380=
 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
>
> Thanks.  drivers/usb/gadget is the offender.
>
> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
>
> I expect an easy fix would be

Maybe it is better to stop asking kmalloc for unreasonable len:


diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/=
inode.c
index d87a8ab515107..20905f254968f 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -645,6 +645,9 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from=
)
 	ssize_t value;
 	char *buf;
=20
+	if (len > KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
 	if ((value =3D get_ready_ep(file->f_flags, epdata, true)) < 0)
 		return value;

>
> --- a/drivers/usb/gadget/legacy/inode.c~a
> +++ a/drivers/usb/gadget/legacy/inode.c
> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
>  		return -EBADMSG;
>  	}
> =20
> -	buf =3D kmalloc(len, GFP_KERNEL);
> +	buf =3D kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
>  	if (unlikely(!buf)) {
>  		mutex_unlock(&epdata->lock);
>  		return -ENOMEM;
>
> or do what Gemini said.  Me, I'll add some cc's and run away.
>
>
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(f=
ull)=20
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1=
.16.3-2 04/01/2014
>> RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
>> Code: 74 10 4c 89 e7 89 54 24 0c e8 0e 2c 0e 00 8b 54 24 0c 49 83 3c 24 =
00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 95 d2 18 0e 01 90 <0f> 0b 90 e9 1=
7 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
>> RSP: 0018:ffffc9000e13fa20 EFLAGS: 00010246
>> RAX: ffffc9000e13fa00 RBX: 0000000000000013 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000e13fa88
>> RBP: ffffc9000e13fb08 R08: ffffc9000e13fa87 R09: 0000000000000000
>> R10: ffffc9000e13fa60 R11: fffff52001c27f51 R12: 0000000000000000
>> R13: 1ffff92001c27f48 R14: 0000000000040cc0 R15: dffffc0000000000
>> FS:  00007f6f4a58c6c0(0000) GS:ffff88808c549000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00002000000010a0 CR3: 000000004323d000 CR4: 0000000000352ef0
>> Call Trace:
>>  <TASK>
>>  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
>>  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
>>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
>>  __do_kmalloc_node mm/slub.c:5322 [inline]
>>  __kmalloc_noprof+0x405/0x720 mm/slub.c:5359
>>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>>  ep_write_iter+0x1bc/0x500 drivers/usb/gadget/legacy/inode.c:669
>>  new_sync_write fs/read_write.c:595 [inline]
>>  vfs_write+0x612/0xba0 fs/read_write.c:687
>>  ksys_write+0x150/0x270 fs/read_write.c:739
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f6f4979e0d9
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f6f4a58bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> RAX: ffffffffffffffda RBX: 00007f6f49a25fa0 RCX: 00007f6f4979e0d9
>> RDX: 00000000ffffffb9 RSI: 0000000000000000 RDI: 0000000000000004
>> RBP: 00007f6f49835024 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f6f49a26038 R14: 00007f6f49a25fa0 R15: 00007ffc6cf49328
>>  </TASK>
>>=20




--=20
Best Regards,
Yan, Zi


