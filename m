Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99760CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E798E0009; Thu, 11 Sep 2025 08:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCEDB8E0002; Thu, 11 Sep 2025 08:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F688E0009; Thu, 11 Sep 2025 08:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F54E8E0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:43:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5171014045E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:43:39 +0000 (UTC)
X-FDA: 83876935758.12.6EB7E08
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id D7EA010000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:43:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hL3v4dvQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FOjJGXAU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757594616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTovxf0n5KM9Ga4M0zY1MZ4FuuwTy7FZa8mU8i2C4EE=;
	b=TVfzg5AfcZS4r18v1TMsTbNEXMPd+12YHKOImGlmvD6qh0EY0ilFNJhyFCMJrHiMDtgAOu
	N6T0/hmEGzeCFsca1ctkf2pLjh+9Q7lLzTVxsxYkBDB0A1SuMHCNapojAJ2Z9pGmM2Ll//
	tP+o4ETqxCQPf22wEscAvy2/BDWUXs0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hL3v4dvQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FOjJGXAU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757594616; a=rsa-sha256;
	cv=pass;
	b=OjHjttknnav6+5cM274wslROTa8kRMrydwox1uAl6aE4TJnIqfXsKFRlwwGJ425YAqx4kj
	rNH1fPw2orIzRGnAbL8FRRDAt1k1807PZFir8GaDz8WVdMhuySAVcsGv6fBH3pheX3v6xD
	8GRHd8yjBwKHF2m9p9/QCreLJlf3dBM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BCQnLT028009;
	Thu, 11 Sep 2025 12:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qTovxf0n5KM9Ga4M0z
	Y1MZ4FuuwTy7FZa8mU8i2C4EE=; b=hL3v4dvQW1Jnk/DdLYJe/DS7g4lnA7OMur
	YyWgkTh9e9KzXYwY7Rqw0jCrtfWwC+igP0ZgqAunuu1KmImqKGH2u6lgSG3ebu7T
	f6kSCHcunDN3gmQGPk9KwXhkT9UW+7vmgtLrk1Ji6NFFIEHk8aBFmFRaCoU6wWvr
	QjqeepBSp3F8DLku3xJoc+Ic0dZtiCl5a+kqiuU7Ip8i1Lz3c+11nuGJog8zWaQ2
	yAWW19DpV5m8a7jiYLbVcZxGlc/8YtUnEipcnwTgFKVk3lXU6NIifZHUUHnMXeoO
	XqmozHdEQjGLTCnfgSLTex3f+w5JQ8gdU6N3hdeT3nmvDkqzzduQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49229666t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 12:43:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BAxDQa038809;
	Thu, 11 Sep 2025 12:43:29 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010025.outbound.protection.outlook.com [52.101.46.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdcdfnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 12:43:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LTwp9cHfiYQHUIA7xdgkZphqT2soKU4d7RJkxLK4uxCYlsZD9BRWUyPYrlyLp/v7YZ1tF9dAucpm88l6lahRUVa0CueeF2p55i3BCtM9JQsWmbpmv/FfZ9NStQMVRphBYigmvOfPBlxbHNHC3M5qjkNWf25XMtoq7vN25lrnwba20ipqH5HrBnyrI5US7B0F/pDU5OyMsWKErydb3MwEWhI/yuQWcgO0mII5vNBFBzt9namGPdUqPPnVvKcZY4lEEEiJ7N6hEucO3s/m7xsSqX4rXRxqylirifKJFW2Z352RAgy2qhIzzh44cdi6KKg1RV0OpzwIG589ye0v0h5d3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTovxf0n5KM9Ga4M0zY1MZ4FuuwTy7FZa8mU8i2C4EE=;
 b=cl7RLHVqc7Iq/r7jOFSZhMG2xfiPcEyLyGIRhzgv4h5pOaCaG0tKu64ucAL/BgXb6KywMOMv62nlLb4ASWSnf64tBjc5T0Uv+zD6Pssphlp12eT4hTyZA1X5skBG91Y5ushRVm6wyRqDPHXvlhOjKWYn6xBsYubKMG7K5aNyswzjFpV8bwOpnISFCz+zNqK/CENK8vQKfbvRZqmUbbOcngFUduT0hZHI0XerySMpQtSffEYCv5DQVmuUXEf9MLnmLsjhQeOIDyYzP3UF6MGC6qmUI3NHsVvIHiq9JEv4H7/cXAAnul2mK/Y9KW481BMb5Tn9xkbe5iFpeezXd4awPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTovxf0n5KM9Ga4M0zY1MZ4FuuwTy7FZa8mU8i2C4EE=;
 b=FOjJGXAUUZIVNpOy7gCDbxbmxlt4TNnVcabw536WtJGgKKr7iEVgU0lHbbANL1y0xIbQg5e6c7DjYBLNsApFiF6YrA8SLGHzjqyT3VxwI8ndkyB6LxrSK6gjpdLyXv6OznY3GPrltCzphNNnQ/ww5PlOoq0Cfh0LkTvgQAN8lc0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7394.namprd10.prod.outlook.com (2603:10b6:610:149::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 12:43:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 12:43:26 +0000
Date: Thu, 11 Sep 2025 13:43:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: vm_event_item: Explicit #include for THREAD_SIZE
Message-ID: <ed2fd382-7b56-4007-8915-88e91cce11f5@lucifer.local>
References: <20250909201419.827638-1-briannorris@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909201419.827638-1-briannorris@chromium.org>
X-ClientProxiedBy: LO2P265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7394:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a859076-bcbf-4a85-ba02-08ddf130cd71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4nzaxL8CQYkQRSm/PJ7YLtA3ug34AmLT4sYosfek/9aXL4xAQI0mUYols3gr?=
 =?us-ascii?Q?BhsHD9KKI9SemZsI4zbbJ4r504WGOok9HahISs7G3NmfnB8Z//13Ac2oAl8i?=
 =?us-ascii?Q?4JdxVul/rAvGD741sLGk8cRiyb3+aLqyTIYN4nNHNjh+vIruLtCCGuqog+rd?=
 =?us-ascii?Q?2CcshD3biIW8QZT2h7b5JfIgCtizJxQUiJy5XW9BX7tAw1+eXc0qUsSm91DE?=
 =?us-ascii?Q?ded2Xx0SUWAAGvkg2Jkij4rvRe9B9t1F4I9TkmoXI8Ap3lB75nYXIKXMujre?=
 =?us-ascii?Q?FqerIcovBZ0wpb5Aijc/1dhPGuK0DH0/GNO9rAwvfsbnmRwigVbW4H+Mq9f/?=
 =?us-ascii?Q?QIcJmj/kCy+EE+PwwFBcV9NjEft5+m1znKYhvFeKizI9Wf8w+of6pP7id+oq?=
 =?us-ascii?Q?8ZnIxNsHkoGPZBpH0kPCJkwJ4AcCY5i46O/cH4maNKSSAk8fl3nB9VwEj9Mt?=
 =?us-ascii?Q?K5AQPcewZ98OI09NbQRRkSuwML/akX2F0S6U8S2d73h4bJiVkK+EarhVipTf?=
 =?us-ascii?Q?wmbUxR9mswKNipaP6FyssE0ZO2RZk14/Ap/Szn+fAWBYrbvckYZ4KvRo+hcG?=
 =?us-ascii?Q?T8g0jRPKmyWma0kYwLY2p3muNC9wH8+Oo1ZGT6kYYrXOmVkJy16tcPkcMtEp?=
 =?us-ascii?Q?bm+4NQrCgc8+Y9U6R5LdKZiZAaJeDk/wRcg0TiCxNcG7IH45xCnQcPLGy8w2?=
 =?us-ascii?Q?Pxk74zKphF1Bd6De8CtQby7N1eOUrFxgloEqLVVqMtXuhPDK6SsAXNCF3SNa?=
 =?us-ascii?Q?UAjWE/1OzISDrcJ7o7Gx06yjgck6GqQZNHKJPvLykqfrRkdCj60+K0XgRKdf?=
 =?us-ascii?Q?skOOukJyv/BxyInOwTXMJTbjht941fVPoSY1lhsG5sAqSSQ4/rgoiud+Xryv?=
 =?us-ascii?Q?iiiEUWb5HZMqjuK8yszInATaQ5oI+tkAuTesxcaySGu5njs20sESpcIzIUP0?=
 =?us-ascii?Q?SIrFan1pa0TzxEoLbVyUK1jvreMrvh9k3KHXLIoOAJp93nURSWDgR8jXUIpR?=
 =?us-ascii?Q?+oUKaincegScgFv7oyY05K1PMOUaKqFm/fLW78HhMqHIR7MmO2bXo7hXDyCv?=
 =?us-ascii?Q?bVMKKEWUJL9k6Y4pQb65ywfaL4Oh7MZ6tjwGx5q9bDjXsFt+A0C0XOAm6JCB?=
 =?us-ascii?Q?5qryGsIUB1Eu7Sw+O8UwCA6WxI15fPnRQkTwZIDbwHec6y/P+CDMEtQdk24J?=
 =?us-ascii?Q?rGHd9Vl5EFdUeNtYr3D0yHbTa8ufbUeY7iyMMQVMoFFdqbCXsUvYug9mlWHT?=
 =?us-ascii?Q?N0ROFZYx1kaAP0uKX8IMn58LynJnQOmNZfO+bBdjGxLz/5ESvZR28NWcXqk/?=
 =?us-ascii?Q?jdJ+n0kKdvSPq79W+H3/8bfF9WByJSL6ijVpTQtE/3ZIrUGeRF3W8MyWLMu0?=
 =?us-ascii?Q?dN0wRw8wFkrkcV992QkMYr9yE6UQq6ghF0/CWH9J8xzT6ibBmjHf/DZkumie?=
 =?us-ascii?Q?erPkhbcgmug=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DRA28CDDJbsp8yrnILNncsfNLCs6texTZ7uDt4CCPA2/MAwvwQZDCtCWpPLZ?=
 =?us-ascii?Q?oZaNSRoboMSv5kRDIs8K4I0NfjoPHx81SFVi2FFnV3/Exi0DAKsIMNiLtAFW?=
 =?us-ascii?Q?J7jDI9ze/gh9lh2XT2CUdzcOCMu2CVU0cS16a3gIu+1Nr2VeExOth4RUC6lU?=
 =?us-ascii?Q?LgpEwj13fCOIde2PNaBzwMlaeA+ijxi8vsPEromsEdS5etgS4nUk64SOjGqR?=
 =?us-ascii?Q?519UILlaeDvKcVPuJK5swhf3GbOA068jMz69JS9V5HYCPZrfVbB4BHRb/Xt8?=
 =?us-ascii?Q?4ZpwOQeBfQi9fk8pncMe76LVMM7q4ItDr5QsWMRULZShYsC0+h4AH1M2poob?=
 =?us-ascii?Q?BXHPfmlLZxpxdykmdxhiyJ6Fy+esSvVZCOM8G7VetFtsM4hB+u9bdK6qnJ1T?=
 =?us-ascii?Q?E3+N+jgoP2VtNCFSaLJ+lrYY2m+/MtBiqM9fkTWoxwqQbq1JPm/g/tKPdSw8?=
 =?us-ascii?Q?yVFaZRW1kk3C7KhT89rP6WV8VEB53mNxF8h4b1/zOtyOy7NNy0TeyU1C9g4i?=
 =?us-ascii?Q?wlSXsgGuWpNV2pvX2GOyuyOyYu0E1by3zY1g7nBIrPgCjxQz+Rp+cZ3L4fvy?=
 =?us-ascii?Q?83OW1RmDX5Webq6m6kE/iV8u8/PCp0KKk0Egd9AHy/IeFVhzMYmiW0YVk+e0?=
 =?us-ascii?Q?F1+lFBlOKpgz+1B5TedzgngFo4pldt8aqv6w6yeZh5CU8OCdiVKJa21WevnT?=
 =?us-ascii?Q?l/B7hUDOUqIpSUO24itg/ArNSEmwdJzJB+D6B1A6ryPll0vVDjBhgM8KdVnw?=
 =?us-ascii?Q?G6eNjiPsjZtulKwXR/xXAZSCM5WJpr9cTA4ahxlJ4ibvZ827zIpjIu4HMcyg?=
 =?us-ascii?Q?swojANhuNu/w/aTHQ78vv+BeXrZ6tXeLetz27Z4H6PiFLBw2qgiK02Ufkgae?=
 =?us-ascii?Q?4Hpr/Yr3bdvD5vRp+jtbyJkg8ClAJomz5MAIgvzAiyvqH8+Alout44NAlWby?=
 =?us-ascii?Q?TrQEXB5IPuPf2RaL1MzG1LzMyKZQ2iuWZeG9sxYWHlTaq+87LeF4t+QUw1Em?=
 =?us-ascii?Q?G6D6mwi6qS8ax0Lktyj8zZodkvOLq4juqqqZxuPmiOS32Iho32s6tmxuJ9Ej?=
 =?us-ascii?Q?38eUm0ooZ79dPxFuPVpGBtEJ/2gj01BhCJRhu8TuPV8gRuNv3o/cKQFlfuWa?=
 =?us-ascii?Q?axAMjLeOWN7MgdoVSuvamb/F0slV5oLH1yTfB0jfgvmvEG4UMm/xmqGvDTWO?=
 =?us-ascii?Q?RiIwOAaTaSn2NGh7ACTkiJIocFpkqHG5V5UUca8E5ZHCyVhOMcGhU3hyQOG7?=
 =?us-ascii?Q?R5tByCn15JKTSsKPGBKuVXjvhEcRGTe3AwnOcqV96wkYKD/zcNqg5n5p4dnv?=
 =?us-ascii?Q?smiybJnmjJUNWYFNSey5hzrFJO6KECgXx1XEVOO6/9Of/ctZJkhDVelh+Vhk?=
 =?us-ascii?Q?Jfd//B3D14jL4aOFbuze7mVFavnJahTyke9G5k75dCf1XsVnNYw6uQhBCXPw?=
 =?us-ascii?Q?pDJqwpCGzEEQvUC5Pd3rIoRfc5mQJUkjlELm9O+cjotxcwvAaE58QDLPW9TV?=
 =?us-ascii?Q?q9CVQSfpXPIDyICc3hu98ruqZXUq1CQmDz8tfmC9JcdMa3MVBmqapFQxJKsF?=
 =?us-ascii?Q?g/xEhhFus15jc6lASYkcUcgErw+FVLBHrSC3EaD3xYSo3ZGJKpnFyATr1k04?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VkTiBpY5WA9csBYFWKcKWUyzZjlYWffldcii52M5pB+Bgsk/pYV8i8chcggv39/NqOmyt7fmO8WCq+AG139jlbkpHksgiCiJ6f/kSc73kfr1tNfWJAuNLvw9RArikHNd9UUhg+POeInOjRYzn3bc0dd1bT5YjO23kDFonGdzd8Zoy6MIWpZ/WWhUDo8rsolDWcRupP/hhZYLW945PIEGOU8S03OMv/zEw9VTywhIZ2uhVRFFbYhrDE59sY6V1bzLcaTDmnXUhREM2120CKnPY2CrYYVbOkWw99CSTkqqkbIcv/tLvLIh6137vQ48eWP6BWZwkAilqA9uCFXcXHhiTvnc6mrho0rwRhiJIb4KAQU+lhJOmUQZ99qomZN+0E+cJFlEUW3Wuvnm6NjodJW02OaYh6Uyf3P/3jO4MSpbZHsGI+6ORUd3y+B8YHJ0Gnq3JivCqHwH5R/F+lvkHLyHgYkzG+Rpl2SHm2UCas2YunsVeeoSDrNuMJH+XBjwGhyU3bpo5h6Tmsf8Kyjafhc+0oj6AYRcjyvfh9rsozXvGDAuVJLfNICkcnSeIPRLy3urQXsIzsNQybU1pcFv5OHIaZpwGRQyNYpRmAoIunIklcA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a859076-bcbf-4a85-ba02-08ddf130cd71
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 12:43:26.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vRONeO/smF3hA7ecAXVU1o0zMTfyg4sl3Pan/P38tNMH30UOimkAO1q7Unzipyv1cmBHSjC5kImdMYOeCjxt/SpCiuwT8Dq76b+iLLQm8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7394
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=905 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110116
X-Proofpoint-GUID: 9Xot9GmhrHSA_y8n77mZqkaP_qtkFU1P
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c2c3f2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=cm27Pg_UAAAA:8 a=yPCof4ZbAAAA:8
 a=N-gz2q-RA3_Jsx_tBUsA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX0OHrAYBegcjY
 mTt9yEXnowbSUrifdiNDY4Q51JBwAE2keOVfC81Kx/K5fnMvbgQemSy5w7s0nAIn9x3KRO4PNUD
 OHlpdmok4pc4GEO3dBnQNas1lmv9/lmJLzyniJleyUIH34pwaGxpOhV3edL/7kn7nO0VJmaOnkS
 eDHS80OSXzULPXiKpuG5PRRFU7vVi7SGv1g9MyM8/BCJF1/sFGC+N2SAf5WUD6ECHkO46iY16wQ
 /5HzkmI4pEIxYuAiEugKfRP7tCy5BLXo7u6+9PdCB2QrIwPc8nuzNDDBE/lfc3BWrjhQb1BfRq0
 EkXbTPek98Y45DXfLury7cF0S08KsPUNkoapBm4d7PYootubvlxxqL3FDYsieWsRfmIf0fInjED
 PBBiwaX1CZdYFQi3c8dpk2b56Cs6ZA==
X-Proofpoint-ORIG-GUID: 9Xot9GmhrHSA_y8n77mZqkaP_qtkFU1P
X-Rspamd-Queue-Id: D7EA010000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 4waje4juxn5a5rmhkdj5uwy5ejeu9pgr
X-Rspam-User: 
X-HE-Tag: 1757594615-882804
X-HE-Meta: U2FsdGVkX1/HMtyhbkQAEqBCARGEzk8+03YDKpNbsoPEujQqyOgpvWrgEMGOFyLJYBeAzc6/Lb4CwmwkFrFqImGi1dMHN2rkNX/urpxptywVkrid3p5YZ3mHVsfBJx3ljP90QBDSVbmenT0sQYq77DSov5ecmzAl/qcS9A58kiiv9lLktahD3aoyDqrK9G0mgGECpP3p0qAJ/nyEqsuL/JtdKZaihlPcDEOMGftrK8bN1Bsxk5j1Li14PzfNF9Pc7p52CJZT+4gIMk9/5YkpbITR9cSgkagP+JWczQS2RdTqs5DYP+BYu08KdplGeNoFy+4h2uWiBN+cKU0yKtQU9F8iMC4k4XfiAA7qXAo/XBDoVaFI7AifPq9wwppvZp5/GQ3S06pnU8z3B9rbc+Yq/J8VmlXWJEE1yBqQNZ4C/QHcIU6j71V2UgtbKXam3suvm0AT7EFHV6CGNGCeKh9Ot18q7lG4CKBrGgbnO/GmkwZbK7ASS4QJM2oFZTsIaEwYW4H4z2go5kQd4v874JUyVjJJcqYi9FhiRtolSfg4XxSYpHPTUvueQUw9XDA+D8iKg3Rbw35XQ9EdUKvHAXDp6sjkvO0SRPTFxxaCG8uLLIHHl6O8jvPpnVlWssnEQnzogpc0BDgUKVRj/PsArPHjxXrlnx9bJrQJ13ckSUyqA8xcVNwVd6CLHPDs+OeiEy+iyR9iCbJSn1QGgpTbgFxXSXh9RAGwZiT+nwEjH3uZjYQAP4LfHz9MaQ8xBj1Z/ZCtjbF9DgiZpsf31f3H9ulytg8fEajKsPQN77xtrN4ed0rQqI9BSsV83JDQH/xvciottualjVUNlz3+tvHUqMtm25PDvISd8qCDvODc3TzIhlarhAVktkqq2y1I5CKgpKuziWwKhP8tWF7/LKjfxRtD95qlXfkF98xOJjt7NjZDNgoXaVasuhj90m2LFwrHMxpHMFQVWrltFLrzCLL0/ru
 JPSZmWAS
 vrOrM9MahmmygKdU4GBsSw3igNNQ3q82p3W1YxOll2jl9iOgRbhgCvhvVQyhTSNdSGV/lq2vqy/lLX3rUpsCp2xsICzPUemKOZBFoYyP5ZT+61HlNvzObNsPsWU0+A0mLK/6X5Ku/nVcIpGcB7XTcNtURd7npRJ22I1HiPykRPdistCKp2KyYIov8ucTA2qPh+B75BLteXStwSsXERnt17zVel3wGF9ktSunh0j2xFhx//EfjsiZu0Asxytn7BBvGFiRfIjSn0YF9L4Tmy306YoCGwJyyDjfmYeYLXlXop4OuoQlR4Rot7A/1OJ34b8uJkVhkt2AbE2nyYNWOjGx0lJLBVav1+6DU5ZlKv1fpeIwUf5tdDWDaGyneWnYo5OuTmSPVKjL6K+q+hsb/MZfFRHZDtgHIw4M/nKqi3/FsrAqi9O2ad9x26+1S9BKBm9uhmDudLsHKq6286VBu9g6VBzgkDC0LcLWwgEEjxAaPcN32LtMj+Gy1NhCJt23j5Jb+3KZdmXGYKocQxm8NSIyBdEZkpfjHe8GlJN8iW2gRGZfX54o1SSlIMEZXhGhjy4XFgbmbIrkKm9DC/fPQ7jVXjIFVWbbmo9LTS0MA5tuMAj1o046ZP1ErO+i6QR8Mtg09jdLrm+jlYtxaLZG0EBVZ/odnugD1ITyiHAKgAhGJWOjV+4P5JW+YiuaS01nE9WZfdIPBkP1FNM6btSOELGJiswa4ySewYeppf7QI654UpJtG9wwPIsr3MyAJxXoPpAtA1DQWGVsAdGai9xlyC8DmgWvFKNRLP6hApnwftaWjg8m1QxaUCtQvqLcUUFC7GwyYjuhu1ZF9kE7hPcu1DJXn4oBeSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 01:13:57PM -0700, Brian Norris wrote:
> This header uses THREAD_SIZE, which is provided by the thread_info.h
> header but is not included in this header. Depending on the #include
> ordering in other files, this can produce preprocessor errors.
>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

This LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>
>  include/linux/vm_event_item.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 9e15a088ba38..92f80b4d69a6 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -2,6 +2,8 @@
>  #ifndef VM_EVENT_ITEM_H_INCLUDED
>  #define VM_EVENT_ITEM_H_INCLUDED
>
> +#include <linux/thread_info.h>
> +
>  #ifdef CONFIG_ZONE_DMA
>  #define DMA_ZONE(xx) xx##_DMA,
>  #else
> --
> 2.51.0.384.g4c02a37b29-goog
>

