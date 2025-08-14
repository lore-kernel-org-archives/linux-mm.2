Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBF0CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8330900156; Thu, 14 Aug 2025 08:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33E5900023; Thu, 14 Aug 2025 08:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD47E900156; Thu, 14 Aug 2025 08:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8AF2900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:40:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 616B61604A4
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:40:50 +0000 (UTC)
X-FDA: 83775322260.23.207B6B2
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7DEB51A0007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:40:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OCjPtlvT;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755175247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1f6tMWCxwN6++uHzgz7rY2u3r89w/oJD6upXrWPFTdU=;
	b=ds3uezWMBvi8DRgE8xGICgkTP+ug0aP9OvjMWrtijYJXbcUMEMo0xt94YDTZjAZiG5cB4f
	CVf6H9H1D0jCPiNlpQFAw7rYeU31p55r5/Tlxg4jUxXIYoPP5sCg7w/pgVQufSgEPrXZXJ
	y9Ifn3QTAHgsjbor/DlRV4ya0qxKfM4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OCjPtlvT;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755175247; a=rsa-sha256;
	cv=pass;
	b=YwrcM/OoGECSWzR6z90mlm0xCfjgsaozPwM4947Mz27xpsb3s1J728Y/0g8c0sY3quR5Sq
	fCCvOpJq0GOpYtAjSOa8OPbnU/ZF0IGy+oBOP3XQF8nV30LjhjD9tZbJaaqY8/jsnEuKOI
	zzYGCHtaan+ideulkLwXYVbO9H0RFYs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uIF4+Wal8wYbYSK/PUfw7T7Jo4zBYzDKgsWyr2DlHwzYLqc99LC3cm5hkjLdR62ssY6y3XLZ0BJg53O0WxIZX61q0dmV4D5osc4h7OgWG9CjPHT4UjN8G2sV+hk1xJWhiuA8DBuAFDvu7OXOE9px5T2jG9PayBUTfwusTj2WXLDxLbIbLxR/4p+nKLXmu9yy4mmB7+QhhCVoJ5TCs3/9Mi+6vjRkkiZo6z6SCMt0X1gLSby1a5rORhwOXwWmOCbSsOZxkWnZHUbDXPCBXZh4zAN9MYF58gX3bHQJAIY4Q9v5uErvYOAmGHiRBUstKwgkgjwYY35pCpN/NgM8keSTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1f6tMWCxwN6++uHzgz7rY2u3r89w/oJD6upXrWPFTdU=;
 b=a9bE19htJLlq0qd5TA7aELkgqy60cVd4FfcnvmOAfbo3mWpxSn/OeTThJNvvWs5kn6vOhIbXKKNh43QGsyfTq8M/N0arfxeQ7Cw1C8o80WyKD7Ep0z4Q26h6rUuJigCC8OpjO8TiQlga2l6mphWouH5uYg6GoYAup2UyPruoQxfAzqpJ/SIm29a52mqNJh08JMwJqUopQNIBJ2vJOq7SBWWG6XwTMYQlXY6mu3k4eYPj8wC2k2e67FD2nwSzBRvOCDrDR75nrCdhVqxO1tZXBEjTDXA/bkihHmuaa0zscsurC8r8WcCY0Aw1la2v7oGq+tP/l9JQ0XxOPb6Ns10YIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f6tMWCxwN6++uHzgz7rY2u3r89w/oJD6upXrWPFTdU=;
 b=OCjPtlvT1SXPDI3fC9/pau/rei9B2mlHNONMpYOpxVsUaf7oT4Kty8u2wRV1C+YePaNmkUBQssipKe/jR5WVpYDW54lCT3amKiUKvJN7XT4pnNVIfF9XeQwz73jl+VbkrQQBFGlttv5PAY78hmqTnGu6IirAeWY8dAVdgkR/EXXwY2cVU7OCOd0nQISTv2fCUoybC/mIQyzAIQq1RmskZMh2zzY2VNL7HxqqOmmNgvSJskJMJLw+b8Mk91rqvoCDyvh7m9nn0wE2yBpv77YEOt8SVAwPh7pWf1D/WJzF7UwrFR73qB8pIWOAEzvIrDyzdh/0ANDdsWMsJ+8PcCg6hA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8332.namprd12.prod.outlook.com (2603:10b6:610:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 12:40:43 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 12:40:43 +0000
Date: Thu, 14 Aug 2025 09:40:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
Message-ID: <20250814124041.GD699432@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250814072045.3637192-3-mpenttil@redhat.com>
X-ClientProxiedBy: YT4PR01CA0390.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8332:EE_
X-MS-Office365-Filtering-Correlation-Id: a3310bbf-e28c-4b4b-ad5b-08dddb2fc84a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2JmMmhaUGl6NFlkTzZiV0JEa3kvYmJBU1I2RU4yS0d5ZWZ3SzErSzhqakpN?=
 =?utf-8?B?TDNBWnlZYkowRXBRWVY4TmdPSUU0WXpMRnZ0V0taeTJtZDRUdjJLZENpd3BP?=
 =?utf-8?B?K2NMdE12ckozL09NaUdMei9NVGlvdXNtNkIxZGJYLytGVlFiMDU0T1p1ZWE3?=
 =?utf-8?B?c21Jb3RXbmpuYzRSV2h6WkhRK3FIaVlSeGxVVDJsT2NhaTJ0K1pWYXA5RE9C?=
 =?utf-8?B?Tk5xWklHb0RiekVnWFF0M0lvWkR5TU8zMmY0NW45YWdXWmRnRUJIRFNQaFVQ?=
 =?utf-8?B?TmpaQUJlbWRTaU5NMWt6V1BLRUlQaTBYSjBlWm9wU0JYTHNkT2Zuazk1RjFm?=
 =?utf-8?B?cVdqQldXU0hublZkWkZjUys2WURvSVhDLzIzTERpUGRWRGlsOS9WVHM2OXZ6?=
 =?utf-8?B?S3VMdWN1SGMyRmxxZU8xNXh3NzlCTFRCM3RiTTV2Um9YWDdZbFNYOWhyR0FH?=
 =?utf-8?B?bGIzMmZ2TjQyTkxGOVBkSEZuNTdpd1M1UW9PemVYRm1XR3VWeFIwTWN4ZTNw?=
 =?utf-8?B?ZWNKSjl2dW1VNXA0cUF4ZGRjc0hOd3V0T0xrUGpuWGFyRG9UUUlKa082RHNK?=
 =?utf-8?B?MW5oVG5QNmowcGUyN09VWTF6d29XRHluMzBUM1ZnaTBsVmZtSFkrSVV0UitV?=
 =?utf-8?B?eXNiSURiTFpOQy9WYVozeVY0MDdqcjZtY1krbm9URGtkaExJaHRxdTFhNmFq?=
 =?utf-8?B?Wmhic284YUo0UkJjNzVsdUFuNWhIR245N2Z5OEwzUVhRR3hwK0RERFlHN0J2?=
 =?utf-8?B?cUdsbDNpcG1CaitIVmNYb1l6cVg1S2JqaEVqaG9selVtc2Z3UGJnbGJQaGVa?=
 =?utf-8?B?YVFzdDArZ0RLTXdMejJkRW10VDd0VzVWMTc4cWJnQ1dwZzVIMFJ0UmVKTXps?=
 =?utf-8?B?RzZ4RGxZSkZvNndwT0p5WHFnSlFiaVEyL1NzcDZ4c3ZKNy8wa2RBSjMza0I1?=
 =?utf-8?B?OVdMTGlsM3NlcExFOGJXVkI1NFRjWkc1OGpEZC9QVHdJTnc3TGpUQ0gyNXBu?=
 =?utf-8?B?VktQekFvcmlUOFVQZ040L3RiQXE3bTU5ZW1zU2MwMjVrVmt2a2h0TmNhbUpZ?=
 =?utf-8?B?NEgrWjlkQ0YyQTNiSThxWUc0VGR6bW5DajdtUHkxdkhiNmkyV090dWlsWGIx?=
 =?utf-8?B?VTUzaEJwZ3U4S3FCZm5tbElYZ09DZDFVckRuRjd1a3F5WE5ZZEZZMWpoaGlT?=
 =?utf-8?B?YUg0Q2dTS2NYN25NVnh2TEdrWUtQRzlVSlRxNkhRT1JTTnIyK044c3VUV3dD?=
 =?utf-8?B?RDhESXpibFJxTWRIQ0pIRTBiSWxJbm5JY2ZSenFLUkFyVFVFdGNDRjg0Q21k?=
 =?utf-8?B?TnBqemVWSGtoWHhiUTcwb094WE1TVkVDREZxU3pOSEpxNWI0SzZ2WGlCSUdo?=
 =?utf-8?B?SUtlRnJlY2Frc0FMODBnMVJsWEk2U3JvMHYvUi9KNmU0MGdGK1ViQm41c2Ez?=
 =?utf-8?B?TG1QZ2VMclNoL3llUXlGQURIZU9FUmI0cGtraHdON0kvNGs1VUc3UktpSU1V?=
 =?utf-8?B?eUtwK0ZNVnpWYUhuaWt4ckJKY2JuMzBsek5WeUNESUI2VFV2QnhPZERTMkR5?=
 =?utf-8?B?MXFxVUhQNTNBUHQzN2JzWFVpQTZvanZIVTdSUjJxTEZwZldrR1RycmdzRHhY?=
 =?utf-8?B?eXRtUzRFNjhQSzczWFY3aW1WTFU2NXZsR0wyTVJ5ZW04Z2NJbWx6Q1FyVTJq?=
 =?utf-8?B?NUpyc2JwRU1KbElWWUJab0xNRE84U2FXZ3NrcjQxbHYwVHhLNkxkNFFyQ2hj?=
 =?utf-8?B?MlhBZGVLRFlUUUlvVEhTckRsaGJGUG54aXc1RUdNS0ZORDFTMFBEMGRXYTBu?=
 =?utf-8?B?LzAyR1JkMkVER0grY1cvUUR2dkg5T1VlMCt1S2prcG44eGRicmNzZXMwekJu?=
 =?utf-8?B?L3M0VnJUQmtFdk5vdzJzOVI5cUhyRWVEUHl5MVU4eTZzcHY4SXNJbmpCZ0ZT?=
 =?utf-8?Q?zhu1jz9nX2c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3UvWHljckxVNEhkMU5kN1ZaNFFnT0dJbnpmUGhtem5sUzdOZjJsVk0xM0xP?=
 =?utf-8?B?YVhTODFiWHpVaWEyM0dTV3hXclhxUlErQ2M0azhneENvS01YZUFkVWNsUXZx?=
 =?utf-8?B?REdDMDl5VmVEVFNPVGJzbWxuTlpiQTVPNE5qWUdEdjE1ZGMxWXZ3RFZYdTJ0?=
 =?utf-8?B?T00rVDUrbjR1QVZiYkdtdUJ1L3FuL0tvY0RJNEN5QzU5OE5WZnVLelQ1VWhS?=
 =?utf-8?B?YmJqS20xakVOL1VWMVVLenlsNUV2VWd0QS9Vc1RqdTMybGd0VEExWDVLWlVS?=
 =?utf-8?B?UE9DZmJnR3JVbTJmR1czd2gvMVBOL1JUY3RkeFYvallpRG1wNGtlNmtra0NN?=
 =?utf-8?B?b3U2NGVkZS9BbXl6ZTF5aDhHNElHZFJDMnBIM0VHNG1hZlBrZUtDdUdKNXlG?=
 =?utf-8?B?cTJaSUh5SXk2b1dHemp3dkMrSEU2aGRlT3Q0cXVWVkIrUXNKMkxTZFpXWmo3?=
 =?utf-8?B?YzAxTTN5WUFDSWpaVm1FVlRweGMwdjhSSmxxYlYvQnF6YWw4UTk1VENRY2xo?=
 =?utf-8?B?aG10aGlvOEN4ZDFobnFVcExmZFdIek84TjRmWWVnWEJYTDdQRG5yOG1pa1l4?=
 =?utf-8?B?NkxJRlZQNXFKUFUyVWthby9rZ0F5S2FPWktoVmN3elo4NktJS2hsZk5tbUpi?=
 =?utf-8?B?eU4wblpHcTNhNzJqR1RGWWI5U2FGTmN5emhOVkxEWW1WTGpXSzh4OUdPQUYz?=
 =?utf-8?B?RENkTVJVY1IxSFFFbjUxbXM0b0tBeUxrbXhVYXhQRDRrZkxMRTFjREhobmNp?=
 =?utf-8?B?Zm9BQWlTSmQxOFJoV0c5aFlsQVBrYWsweFdKdWo4NUdUY1JEb3MzMmw0bngz?=
 =?utf-8?B?cngxZHBmSE1OakE4QWhVbkc2TGp2a3JrODVGakpDUktUQzJ6cnBBY1NQV25s?=
 =?utf-8?B?SEliNjdkSHFuV1krWUM2eisyZXN2Wm1ZVmx2a2kwVHhoUTJrVTZKOEQrQkxk?=
 =?utf-8?B?RlJnZi84Sy81WmdkWXVQNXl4eXRKWjNHVEx2T2dTMUhNb1EzOGQzMDJXclE2?=
 =?utf-8?B?TCtlbC9sczM5azkrUXYzY0NrODdhU0g3R1k5bTVKdjgrTFMzTnJ3bzZkdDMv?=
 =?utf-8?B?bVdEYU9rcUFOU2JjMDI1aDlSdEtlNGYxemRvT253RHA3WW11dVh1eWhBNzE5?=
 =?utf-8?B?WFhQSnFqNGorVFB2NUFwTzE5SHQyZ0w0dnFHQ1lLdklKM09CdWt4STl6NTBn?=
 =?utf-8?B?Q3EwVGVSVXFBblgvNTdudGRRWVdFS1lXSE5Pc3JacEdYR0RQeG1Hamp6Z0JY?=
 =?utf-8?B?VkYwTi9QejdpMm51ak1tTUVMT2VDNzdtTVBpa0k1VjBzbUZqblQwTlNJZ3Yy?=
 =?utf-8?B?RWVITEFtT2F5RzRCV2o1bUg0d1lVTHlyVDYvZkRSaW5SM29Sei9lSUZDNE1a?=
 =?utf-8?B?dzg0ZU9VcmQzV0duQmkvaGM2WkZob1F6WmFGQmlmSENUTytmcnB5eXZLUDFL?=
 =?utf-8?B?Ujc5S0VpNVJUaE1NbFdyUytwQVl6TFFsZ0pBSExUQXJyVmp0a1d0MldQWktJ?=
 =?utf-8?B?cFYrSDJJZktCY0lDbTRWQm12U3lBSEQ0VllOY0QwM0QwRDV4UGJuQ3k2SzNH?=
 =?utf-8?B?NklBSCs1ZEhKREJBSkJhVkMwazFQdkdiK3ByNEZud1hOLzg1QVNhTWtpUitE?=
 =?utf-8?B?azRmdkZwMUdDYVNMZ2tFQVg3d2kySmtTZGNzYVVwM3RsWUJHdmFMNzdPdjBi?=
 =?utf-8?B?R0hoMlQ3blNVbkJsVTFKZlJDaE9FUktCRUdOcnN5VDNwSjQrYUpwQnY0cmxn?=
 =?utf-8?B?L2dqSUVEejJyUmlnTHYyVzdlMWZWek12L0tuWE01MjlLK0d5ajFjSmNnNk8r?=
 =?utf-8?B?OThvTkw5ZzZWRDdsODJBQnpQNDNobjF3SUNjT3lqWmRDUTY4K0xWZ3dYK3cy?=
 =?utf-8?B?QXZES3FoUzF5RmV4ZzlheVhJSnNuekhNQzVueVRUL3hhKzd5dW03Z1dkamFK?=
 =?utf-8?B?Q2U3RW05blpMNlJvbjg2bDl5SlFvR3FvUWxNWFYrbmpRcWkwTUpwRUFyV25j?=
 =?utf-8?B?bVZTajVFWEs4bllIUGhTZDBRQlg0UWkyNyttRkM0WGhKSnVrMTNtL2EvbmQ0?=
 =?utf-8?B?ajhSci9TMSs3WW9MV1dRbWxMVTFoK3c0UGJ4VHVWSWl6QjRLQlV3a29KNVU1?=
 =?utf-8?Q?RIIo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3310bbf-e28c-4b4b-ad5b-08dddb2fc84a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 12:40:43.4989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTd+M6XhXM6RFsLSl8Hk49TYDB6/hg4RIlR6rGJ+4S8G7X5JyguNn2bboRx03Cna
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8332
X-Stat-Signature: d8eq4i66jcxez3f66b7pbye7bmdorjhk
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DEB51A0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755175247-417429
X-HE-Meta: U2FsdGVkX1+C6GzCHaW8rXqpfDWPrGE8E/MYQ3uJhhiRBcgwnzHkQPMHkIhRlhWazFXCoAjM0AOIJ/ppq5t/k8pG2+XTGEWVaEnDtpDHFWREan7jAnKPBXDhVrdtxL8SGcuSp952aQbuxhWXKetMVnVp/ZuKyAtOjQnk+H5s9qX2+TFT2Ksz5aw2EcvhhWqrtva3USRjfI9GWb8PU4sCwoR/3BmBC5bVR64xd57vn0BCRwsCBSI+hdKh1LguuNLpTypWSJI11goEMXTEjA+Uujhzu3y1AMqyQYIPt5P5djc+g3KLva1pm91hvBkRholpGwZH/8isFuJsXd063/1Hi0dd8ylamh11G93HHO7BAFBYAaTylbc4trn75ydIRpCqd8clqWtoC3bvIfUVyPt6u3GW+NrMIkmcS7jzzHMGWwbxPjYo5Eg+JGOZtPetdWdqi6Ncxq4SFdGIIdVY3v/sVm2Rw6qnwCG6p4fXEG4/GVmAhRGQj5bwifLRsC468uzUZetyNwrJjXFfX7UmLv/Ukzvgk1ELfGeyPa5/q8kQ5AkgqbBNQVekM0AMXJTHyptrOYI/Y3dB+u5k6iKzD1uR/vVvkFEB589ffCxL8rQ/rzmDJzyYEHsoiUKtVpCMmUy/h7NO3YFxiqgKCyICSZ+CPiRjOFkxmThULeqbuPmGtjQHvrxnV70nexfBuomGyDWIq0dY1o+Q+nctFeYBpORyP2e1lljx18R2rXlo7yZ30WSeKn03G0lWAx8q7cidghOkdHfCVnHGf0/p2fS92XuTsSV65f5mLauqJjntLmEzvg6mx9CZaD953TQAC1xBpShi/4dFSPMqdsc0Zv8zwoupwgcPBL88bEbjJFtAawYm4AsIABbs8ti1PUhylpb8GvTD+KrJteeiVDZF7UZkHqj3KtX7DjvFF0iGFc0lGruNrQug8VVAqgV0PIOelaxuFKSxl+AHhqNv4Sl6r/opYK+
 dcbqek+7
 /NXVgMFFe7GYO7qY9OeIkMDoaI+NlTputvQz/oYenM9v3iET3sjDpVKP/f0ojNCB+xBoUgB8zTa5xo1EMopcy7amOOu0ZnK+EcMq6aAAN2fO7Gx0dQ0rp32pc5hiH+g/F7qb3dGtN5zMKiEG0ARqhtBjw9iJVpCKLlo03gQymGrpbOiID9oZe63M3pBIBM6Wq1v3IBpAM0nangFMZEhzJhVtUYuNQEHkE38P/xB5xpnW4PeAm6enCom0JKHVbaC9VYTrXx1vwCd53Eu6gEUELOnI77kzoJohGS1zo3EIUmklZudX0FSMVcC6oUuKE6kGz39O2D3Ahnklaut/zWWfeBtfAMvhCjrhmuB7n9uPyqXSYEeFXtwn6rrVNlBiKxGKQrH6ekw8yJ0KjPT/yEibIN2Vv4VvLDdGqIXn11yXzn6XJzNRDLmH5rbsNHC6OMp2+++MyPOZrvs5TkoXCGSmp/5jWcCylHK27SjSDwIiAiqQjc0o7JpUBlapONZOuFnMhvW34ho+K/Ewq17IgrRWcjJNVfBQS+9rtCemyH8PpEkLyBrfkKvQ2i94H1Q5B8vzNmXkZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:19:26AM +0300, Mika Penttilä wrote:
> When doing migration in combination with device fault handling,
> detect the case in the interval notifier.
> 
> Without that, we would livelock with our own invalidations
> while migrating and splitting pages during fault handling.
> 
> Note, pgmap_owner, used in some other code paths as owner for filtering,
> is not readily available for split path, so use current for this use case.
> Also, current and pgmap_owner, both being pointers to memory, can not be
> mis-interpreted to each other.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> 
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  lib/test_hmm.c   | 5 +++++
>  mm/huge_memory.c | 6 +++---
>  mm/rmap.c        | 4 ++--
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 761725bc713c..cd5c139213be 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -269,6 +269,11 @@ static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
>  	    range->owner == dmirror->mdevice)
>  		return true;
>  
> +	if (range->event == MMU_NOTIFY_CLEAR &&
> +	    range->owner == current) {
> +		return true;
> +	}

I don't understand this, there is nothing in hmm that says only
current can call hmm_range_fault, and indeed most applications won't
even gurantee that.

So if this plan relies on something like the above in drivers I don't
see how it can work.

If this is just some hack for tests, try instead to find a solution
that more accurately matches what a real driver should do.

But this also seems overall troublesome to your goal, if you do a
migrate inside hmm_range_fault() it will generate an invalidation call
back and that will increment the seqlock and we will loop
hmm_range_fault() again which rewalks.

Jason

