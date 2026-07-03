Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF6BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FAA6B00B5; Fri,  3 Jul 2026 04:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10AD6B00B6; Fri,  3 Jul 2026 04:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF726B00B7; Fri,  3 Jul 2026 04:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 694B26B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:25:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1A3E1683D0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:25:40 +0000 (UTC)
X-FDA: 84946781640.08.635FDEC
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011059.outbound.protection.outlook.com [40.107.208.59])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11CF9C0006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:25:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=r9rSqd3q;
	spf=pass (imf28.hostedemail.com: domain of icheng@nvidia.com designates 40.107.208.59 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1783067138;
	b=JQCCe3y7mNrAL8GInIx7ayjcW0UGkS96qqCtj4IWBZpNlj1lxtVijlvQtShKoBAcjKzm7k
	BeUVp9moJ6lJLK98IMThJV0eUByG4yQwdo+BtFJlGXj5IEfc/bl4S/qnEn5wX9+pHMgGSI
	A6iBat7WC53QQFcmwmYVDZ06fSn5wKg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783067138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2neqEZnjAWtpK+aV77DLopafm63JYXc8wbevzdgcNk=;
	b=jqkxdJ3LyfPQ09Sl7Q/30gEEa8vyx7sA1bo1tJaPhsMjOiYBYSGuAR6cl0ZURc/EENqrJ4
	WzZ1oxKQ+EQgfsZCHBU9ZGaxQR1ua29Eu4N7KPey08AM29bmkxtQGaB2x+BTqk/mpDCNVj
	OgYj23k6ywJUYzYMF8XgIfROnP54HBo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=r9rSqd3q;
	spf=pass (imf28.hostedemail.com: domain of icheng@nvidia.com designates 40.107.208.59 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rtUQMIIkhR9eScCv6Rey5UQECP8eukQ+fZnnzP13OF5u2Ls765AVVaXG5tL1wvJAO/oD5/miD2ZyorsPYsRt1Ak1T//l16BUdT/ZfOwZko3Z6kF2sQJL05JEqemLADcN1bOD15xC0/o9Mx9wAvwAT4mPm90O+Pu3GJxVdMLW2PZxIXVZxiIdj6Er8txcxJkrnkPjKIurQDsb0dars0ODY1uEZAAA0pAo36kZdDL9roKx2T/xb91N0LRSuciFXxApNm3OJneRSlwhJrtfnCmJA/m78VFxT7LMJZBNBZVa7SNL8W8wUHT9AMo0kap/63whTXqUZynKwW+kDnW/G5HeEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uz0/L9YVwtpGFehPW10JxZ7LuKsNBp0TqK7e46Y/8uM=;
 b=FpCLBn3ceTIdQw033dlxhGH2qyiLPJUehaxuwMPr3C0xQIqAKAT+h/vNCs6JXPY/b4g3BcFScjuz3oDLhN5uIXgLFeaD5k+OoPkKRdeCXPM8N2CY5bkkc9mw55fwoCN74AQOEP7vxTDt+adSnDJFaNg3OVZcmK0ooWH+6Av7zNa8hjobWQlkJb8wT3A3JtANT2GVPIqp9fXzufq3AeYk2tf8KYQUsJaRbQ4/hpCf1y9pIb/hMOJ7H7EgC9Sjgi0fgFFVg2BVm2OQjh4RA5u7JWccBJLB0ePpLgRK6SrPZCdU7/ff4/wYDcyvWWR4aAMz7CdR+vHOaGsBJb/J7f7GOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uz0/L9YVwtpGFehPW10JxZ7LuKsNBp0TqK7e46Y/8uM=;
 b=r9rSqd3qiuB6YPcyYXKwmMYOy8e0YlkHjOfiA2UK3Fr1SkKCxpARkI/5ZmFPs0+9QuMY+33ZkkFb80VGOdWC2yPSepQATVGEItYnBFCBSmo9V5QuMIzx2/B+Jkh4ct+hMzYyZ91+8WvhfPwMCBBihaaJG0zs16YJlNz4b5EPLYD6KUCPMlxzjYQgGITK9+BPqJvbwPTxOVdt3XdyfLakMR/UJNH4Lh3yOmofECMyFFe57boS8TJd9erDSTlA36e7zwhDCPB6uutgzfQvkSIJUvB1yvYlQg8Am1qjoqnShFUAzpcxpmzvO87Z6PEBb7bckylcGy3EqA+QELxdrZ5DmA==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by BY5PR12MB4065.namprd12.prod.outlook.com (2603:10b6:a03:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 08:25:32 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 08:25:31 +0000
Date: Fri, 3 Jul 2026 16:25:24 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <npache@redhat.com>, Barry Song <baohua@kernel.org>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, willy@infradead.org, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH 2/2] mm/migrate: exclude hugetlb folios from
 MTHP_STAT_NR_ANON accounting
Message-ID: <akdxUvWGNS5d4f_L@MWDK4CY14F>
References: <20260702172548.37075-1-npache@redhat.com>
 <20260702172548.37075-3-npache@redhat.com>
 <4c67ac7b-e021-4e4c-ae5c-07bfc0fba9c6@linux.alibaba.com>
 <cda9bbdf-5ea6-41d5-8a68-629c2c4ce465@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cda9bbdf-5ea6-41d5-8a68-629c2c4ce465@kernel.org>
X-ClientProxiedBy: KU0P306CA0045.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:28::10) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|BY5PR12MB4065:EE_
X-MS-Office365-Filtering-Correlation-Id: b44bdacb-6d06-48ad-4a06-08ded8dca56d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HmmqWBhGzEsNVLgh5KU8mq4ZxwJETGXgbncDf+jbKnqwb6Xaq5Whbbjo/Kt+dqM8GxHjK51SnAGWJ7jkat30CwJqwT4T0UR14pdW9CODNtVje4O6jxzIVConovI4sI8EsXBAHuNjddzdCJvF0dSfXhDq4+bnuWrzVotdzGJzoYNsnx+zK/wX1yWr5Zj4ajzeqlk2xSrqR+/TAjo4ekEUnH2nXs45Ycp2Lgu1zomBy2a2p8B/UXcuih8uGzIPlcBp31zSJ+oIa/h5u7yHwigH3X03gVf2/3VCF/s7Ip+ELp1myFLMoeLhMBKBb6sJ6jbKYOvPfA9esud8qv7hiWn2+c27/p7/MU8VrijfEvND5pFb+DCSFRYynjKBwskm3G1VdWT/vk4JnOnfwZx0/Rpp7fjgB35KwLQJ+34LpQK5/xmXCQeQsXUgjBLdeAV/uWxXhB0on17v1UHocXHPGZatE84hDTWZGSJc3U0UtjJ5948s+ZjfJRdwvdwbBJ/x0cFJ85JthL+OyyxkqlrgB6C3kdaVoRRS353tz3FRWFuOcXb8zWUBRKb/8pX34P84sgOHjioYKCF7PAZgeiVnpKjpeY72Tk4XXFot7cIf5JdzkvY1nhNvw2Pd7F15YJVUP4e2fapuZwbHgXnAbS9nG6LP0moNxdDpOyz2MMw+Jg/Ppmc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?B+EpLWB/dIDUnOwu6U07xmzAfXLpBi7MevJKXf80kUmyNStwo8ebbF6vhy?=
 =?iso-8859-1?Q?pwCgaWCEDqlB5lYUrZr/EEVunRwtUF58zUZ93bIhMqDFVheJwmgxC7Xoyc?=
 =?iso-8859-1?Q?1f+Sd7EYyXsv5L6CayZXf7jqInkNIcQXM9G02M7MQ4LvXJxlOgUvvOWrqi?=
 =?iso-8859-1?Q?eI/9O1pArUDpIHVwfaWgiO55qHHk9kgUe4QADOMiqg6CFgBcUJ816mkpVY?=
 =?iso-8859-1?Q?UnEJivHAv6z+RqrodCtEPwQXbPvjfhJDFS7leCkmvZNkCWGNdvyWDPDh1P?=
 =?iso-8859-1?Q?EemvwbKk4QSeArVlQIy0RMuZ1IMsDADsqYqK61uy1s9d0A5kvHlFg7xLqn?=
 =?iso-8859-1?Q?PVYBo98tkGaiwrLiugb7r5khJDLiEQoZRSw7b7tKzo2YxGQu2u4C8uwHPm?=
 =?iso-8859-1?Q?iFemL8ppvu1Zi40XDNpfTcvgn5Wml1KwYpItaYgYfO0aHFBQHzFLOrk8jt?=
 =?iso-8859-1?Q?uHxPkQ0O/UVlBbdW/h8yphkTXdGltRqe5G1ICUGD6PKad6K9ipiiV97JSA?=
 =?iso-8859-1?Q?d/Nd/o8fBWsA4gVo6QgIxbZKko0DxJhlQmipX4LNdF+IK/Goh42oRd8MGd?=
 =?iso-8859-1?Q?uvTkfshGRNDpvVWjfhFHfzynEapBJveA4ySEMPqRo7h+H4w0A3m12VCNH4?=
 =?iso-8859-1?Q?pKbSnBljiOQkVpR0FoLViuPZ7jyPMqn4NYbki3cYEsbQjwPTr1gN4TB3AM?=
 =?iso-8859-1?Q?e9LSwbRSc9mD15xCfASeEC9kmpj+7W9ftmYm4SVjVBozp1333dq1h9MgE1?=
 =?iso-8859-1?Q?+fDLv/PsJTNu18aZ+CVME0NoyccnNoKXr6g9aSRHBw9tjcruNZ6HLE6OqZ?=
 =?iso-8859-1?Q?uroAkTcwJAl3iO6Mj253jehydSiKbCW+qxCyOg5AEHB3Rlx/K5/i3pOZ7u?=
 =?iso-8859-1?Q?qzfInGF4KyqhVZdyCm6wjiA9akGuuU7ULLM5icp2+nTWr7qIQqlkF2v+EC?=
 =?iso-8859-1?Q?7k37106/992wh4V5Kvig2ofDNAvIGMguyyERv2mlt34Fa8Unz6Hl9cbX7b?=
 =?iso-8859-1?Q?1FRw7vr1ONIbwGnKrACgOhrFBLSONd+2mZjzHr5MIuclOsraSCmbuqigXo?=
 =?iso-8859-1?Q?glAXErPMY2xfu/vY5GNFes5Sr1+qwDgq39hXjlsAn+I0Lyp+j2zqo76lzM?=
 =?iso-8859-1?Q?w0MoFBQzAT4DF4QVk1rDZ8H4l43FmCGU2ad9IgCZ8gxM5VrI87gx/9YJtQ?=
 =?iso-8859-1?Q?LtuYfRiJ0L/nDRPm4hErK0ntulqlJozwKln91vwhLZyQvfpYyNGvMnuJmp?=
 =?iso-8859-1?Q?j18LlYsS50higKt0mOyMnr8CuXEw04OdnVuQsEx0lVFlKLS3J7r+Wg1pdl?=
 =?iso-8859-1?Q?PjZfkBAuYygQRdhATz+9ihNnbFoenHcJ7tE07rQfwG8qTdqYaQffk09Xwt?=
 =?iso-8859-1?Q?x79sqc4PVV1oq0/oKbtkcMjbjIkFpxRdAugd2sr5A0Gu+GiojwaM9eGXCw?=
 =?iso-8859-1?Q?Cp34aorUpJch2NnSFFIr+WkSi9HQGePtVZgqlO4DAjjePJJS6rfhSHrcJ1?=
 =?iso-8859-1?Q?usjD3YMMEOLSfve1I0Uo4CuoN0hfptizCpYNHHlI9N3rHi4IhmjCgd7ZnM?=
 =?iso-8859-1?Q?oe7FRc/O1wisZoidGkDI3xHM2H1lZayXAu+QlAzx9lxJSS20NxdmtQfFPm?=
 =?iso-8859-1?Q?NSdukBiKoNBwZgRnoAtebf2f/EJeDdO3jz0fnG0FtuXaUK4vP1qawmfH3/?=
 =?iso-8859-1?Q?w5qzNVwSbWlUA3Cj7equiaxqvoeUXwBk/p3L3bPkv3IF32NZIJrdLeRol8?=
 =?iso-8859-1?Q?/ISIOujVLObfT4915mB16P7GnjOe1ss36YXITvPbl1avCE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44bdacb-6d06-48ad-4a06-08ded8dca56d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 08:25:31.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTCI0B9AzD+t9DL5eL/f3mpE6CjKnM+mu2N+7B31e2ow0U7ABl7PA9BKST2udbTICMPdVY0wmQZhI2v3uB7k6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4065
X-Rspamd-Queue-Id: 11CF9C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 68oekqxeupa9xmdmjejr4wtfcq31c71x
X-HE-Tag: 1783067137-980605
X-HE-Meta: U2FsdGVkX19m5te2XOfDvf8hiiL/5pYL99egp5vCa22WuCYhkQD4zpbO3G0p2PG88i0F1QFGzjfgaDT+EqYJc7rtLuipKV6uiMIv9IzeZ7zg1onXdY2CY/krL8qSiX8/nE7B/9MqewBcXa85+SGbF/XnilSRp7wKx8dbRKMr0EO1Cmc+s1KO/2vRiQYtaxrHtFucp5uX6zZv/1bRKpvodVAN0+5ujpjX9J8yHI3ykm5tcE4mIWK0Rrq9Ck6nT42PObdL30EdgbkYrRh1HXB6tMVtbZeckJYTqsb+hppiRzh4bG1zdX44lhQjBFiMWC8zaKcYgWGSijFzAJSdQyE+vQD6faOPM+JY5jZlmWRVVzQjk4yXCE7wxrL+S1rurdvb7o9K1QO6OMSCg1t0BBtyXqcq78Q/IkH3LRO/rC/CLQhVX2p+tVPhb4S6ALnC3wYHlyn7p9q4FaTGr7lYm+Rz5qd7aMquSr8Xweq3i5M2MfBXZp1dvTLqRJnZ826Vpbaizfwbs/wctXDYKT+T5MMDd9AcLl5ElXtazH2pZ4XDGlD2DZK2KZ7yn2NAmkHmioLxpYdQAWvdRPHvhf2kP65qDn5ZipXhU39zQUd6nPhDUHebW/Sc+FqBvjNo8/yGIyPixyuC0atDihT5EK+wxpoOhauP+y8OvvgZDjUOQxPmMvlH6PbbCZZFB4GmQvHh/K/NRVysnNmjs2B0FBKx/tIsPR5iMAzsd8NbJkORsUnYAptA95ETMD1Dfa11u0jzCEThx8Sa0eS/8zg8Uq2Hd25IOuy+d9sx8xbraLdM3gOp+ozpdICMvmUYUebb5ioCfzwEc2YwDmLudVzSJOVRiZhT3k9xEZwKFQKKhMLgd8wB6A+FnYW24OlBcHLt/2IYa8n9895889yPlilikHi5rgCBOqtXbI7BXFAAS71NIu8P3SP5xvExXkmhWES8IvWn6RcG07B/jRWSC0a98mxhqub
 hy5vKiFX
 iHX3pAhVCrv/+C9kZ6LMBeunZM3/PHtwbVIA8GD3CnsRFlKhkys9tyadXumhYpz+h1/1zY4mxQ8e7ncc9XX+C/fh6fY5rFToXI4etpIgyOPcpYf+ISh+jbOlaJRJOJKsFpS0HwDhs+mSrDGvw+v8ks08vP5SJ2qJXjYF4TsP/WcRqTsxxxpoB7HjkXMQIcS7/RWVjvHCZBEBlAdbRQzj9i6s0lz81SAB/+Jm0Oa12pkg+0bVVHVNK1C6lVBe/JohDKsdWUnS1ySNaIcjhHGsa2+xRje/MKxilgsLj1I9awkaRDCfnkBNDflV1H4gJmQ0RgtAQbH6RA04VQzapOU7sGLEnbF2cBDiF+lr6PgXtVD2DdQLnI6xfBykvL+MYq23iQR/nnjI4Ve8LcrEYVeKxvwlRw8VLfJHSAvlggo18mzbsgua0pe9B+hieSwrg6IOWXtvIlmBNwyulxeuuf+TaJUJgrwzv9d5Z0IOkeFNz8dAUTKovh4s27IwdCeHIvlwt5QCuwbA4r119PZ33vMAZn3j07unahbqn/mz0RyLsfKNMTND0AEEYOGQlUPXqfM1foIz7IplUKeI4RkcbqUgi1LyxP0w5MR4xZBDcGnoQ7dtmyE897lighyJ0A1hZwYpCYjyz6FSIQQjtxb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 09:13:59AM +0800, David Hildenbrand (Arm) wrote:
> 
> >>       newfolio->index = folio->index;
> >>       newfolio->mapping = folio->mapping;
> >> -    if (folio_test_anon(folio) && folio_test_large(folio))
> >> +    if (folio_test_anon(folio) && folio_test_large(folio) &&
> >> +        !folio_test_hugetlb(folio))
> > 
> > If the hugetlb folio has a non-NULL mapping (i.e., it's a shared mapping), we
> > should migrate it via hugetlbfs_migrate_folio()-
> >>migrate_huge_page_move_mapping(). In other words, shared hugetlb mappings
> > should not reach this path, so this hugetlb check can be dropped. Or am I
> > missing something?
> 
> Good point: we should only reach here with anonymous folios that are in the
> swapcache. That doesn't apply to hugetlb.
> 
> -- 
> Cheers,
> 
> David
>

I think this is right. THe second site requires folio_test_anon() with a
non-NULL mapping, i. e. an anon folio in the swap cache, and hugetlb folios
never enter the swap cache. Shared hugetlb goes through migrate_huge_page_move_mapping()
as you say, and the only other callers of folio_migrate_mapping() never pass
hugetlb  folios either. So the check in the second hunk can't fire.

--Richard 

