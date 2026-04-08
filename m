Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FDD10F9956
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 16:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE416B0088; Wed,  8 Apr 2026 12:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95CB6B0089; Wed,  8 Apr 2026 12:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B842D6B008A; Wed,  8 Apr 2026 12:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAB676B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:05:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3960A1601C7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:05:07 +0000 (UTC)
X-FDA: 84635862654.22.0C06724
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013033.outbound.protection.outlook.com [40.107.201.33])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42B8D100006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:05:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s+PPslXT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775664304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J98erCuPj7nEYC2cQYQtDytVuCEJ6r+39SvP4e3XcuU=;
	b=3kp0CIVI19nhMlMsDpeumwt09RrepSVgHqGYnQMl65djT1a0MglJWIvABSiSEa5zjvw3Ns
	9wyWuTJekOS+sxztjsrKW22Lbt/bPMUiUfk8NH3Fre43F3ngGRBy/4iv1bXFTvcJySYNco
	tNNor2cTUchg/dqdtxXMvQib3G6FExQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775664304; a=rsa-sha256;
	cv=pass;
	b=2+JuRZoNLBP5oAdaBwN0cl0f/sBMKWpf7S0MjMBzfuAv/1n3DZoGzWMs0KTM7/sIX5OkJ8
	h+OJwVU+471egPOmja1alNWQ629/os/802jmKaJ7sArgTS483neiiNjOjb+2KDL/CYw8ud
	Peo8cBYFaIXDq5qUw/qqc0g38uGQc7U=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s+PPslXT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G19lVJQfnW3ttgjp2JMgL9/5yIuNNGuqvmOW+mgaPXR1PM/5HtEY48Ek0c6bf4ktgXUWlHXI0NfDGykXbxm1Xsp7HNh6n1NGONQmuDVMFfpAoLWBxR3Xo98vx6/XW4tkW1Gju7l3/EzMwpO8nXotpYJTpd0lOEEs7x0F9XO/1I3tf5K8o8v49r1diZRiMoemcC+/bF/Lnvt8tPmcqhyv+7Z50z5Qmd/sDCqBsr7+R9iMS60jdzh6f7WXAaeytYmpB9rUij2j5nG8pWzx9cwFkfOm+VmHjoWiiOBUNDpRElOV0F9vcwOcItOyohrCLtskPQ/NBf9mg82GUr5BKHVloA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J98erCuPj7nEYC2cQYQtDytVuCEJ6r+39SvP4e3XcuU=;
 b=MweAnaPqYGiEWxochwDBzCsAtQ46D4C+rZlgW97hRGk5o+hZNI/3mteE0mrVN7oFhHcVYTAAbxdhvQ6ru1bAZODkQKojkil5EABVWgP+Tcs0W3l0W8HqI3mYM1u6yFhvgxia40QVG3EDDZc8hEytUaoi6L9OkVmjyT2YR2YlvpDpwC9/SiTr/EbLO/J13+N/1tSMwNlxk9udy5tDdLqzsYm7YNzJq6ScCyO+ZpEVw9Ji7K+HprXJG9n8HjDSfATydLHU7dhgQ9mpBKd+z95lYTVOlxc7zjKDQCmW8/RbzBcWp00K+PwMf2RBDYL4NSVU+48hIpjkDrFZWGHm6KFjiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J98erCuPj7nEYC2cQYQtDytVuCEJ6r+39SvP4e3XcuU=;
 b=s+PPslXThP2jXRac6i6DcMX4zzCrYamz3rh+ZMcr9QecbB09MbZwRA8VHoQMgeSCPoUPz5WgpO7Iq/0qdyuFgmtfTMeVgSZrbQgrBfJfuDCZ+6AxX/m2f2kegLMYuue32eXXnktTJhApmUvtEB4+d0+WrGKr4DvGKFiPJn6f3WKdC0Dzv97tWKDYAvDTyB94jHJjBCch/l7qXjYlFUJ1RXZF2+qUrtcXGFkoVTNHClkY8Gy9uT2BClmK0QlNMnYL+eqQdtM4ZZrPeTZAQ4BbE3NO2olNfPgShZYMvWy/jA0LCQ7onGEIYWTo2qkFwRo3NlFpo5yKPfHu+63RzNAIiQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS3PR12MB999239.namprd12.prod.outlook.com (2603:10b6:8:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 16:05:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 8 Apr 2026
 16:05:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 0/2] mm: huge_memory: clean up defrag sysfs with shared
 data tables
Date: Wed, 08 Apr 2026 12:04:57 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5CD878B0-6C76-437F-B1D8-2CC40D6D1457@nvidia.com>
In-Reply-To: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
References: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0311.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: da8ae81d-e254-4c07-0fd0-08de9588963d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qr74kSC3/IEJjyh54SqFBUEg8QTnX0+TO9t2oLi/C4g6r8nt2LP+RmOOCRPVcBBQTHos37zKLOn7I8B3Z7jHQEGiUzqp7YMBzaf8ckNFBI//wAEtDLxJNPJSZgAoiIF5dV8CNf7oMU9hRmGR9lRJhiaieKnCFhJC/1FUm36oe7AypLJq5/O30dxJFXf7uLpgZZrCMSOEv69onnlf8MiGhRuZ4BFjNrmrkS9YBkIhMNQzEPxuHyekdmdByqAPLYovZ8g0Vs5+mxk0RWghxI85O3FhZYAtFugZB6FqtWge90RPCWeLc0TIdS2LUe3pLqSLC9djT5E+bcWkMuqz0i7VV0EYd15xVUIXQ4werrigfm3Gpjl3uXakZVMDN8m155VEppQAWIvUbmXCmB0W853TpzCOzMYgpnd/F480FODll+rGGbFQnQ9fCvK0ULSwLNlXfWXrymirW8Xpmzb93OnyepJkw/hHUs/ZYVGQSPAw5fzDBtOP/VDqFuGSWrxRETebhrtSuQ+ypGpnUnOwkUF2xf2PjqUJkHaHlzFeRPqBlJ8Vf9rxrGSeAzWX+QB1zSPueTbyLJXsk0G5m3X/Lt6ikIbp3n9KeO1VyERyj9ANqXaCIG10FKP6fp2CRGg3ZNr/GyI9yXPzyGm+FCDewuRxOt5OhfJRL++94Xsj0UUFcT2O/Jlwiqmn3r2eJE7mpP+mrr8rXX+hSEuEM76oO4YXVTaPe43+vXWv9d10/QYtM3M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7k2NROkJTtYDfsbAwu0rKhiBru+uZsn58APEmERBSNrtrW0b1ZNG+JFZp5W5?=
 =?us-ascii?Q?0XxeGkB67fgdwwWUQ9sJBhLtc2zvL49owWvd6pcqwIySS0dn8b8mBk5zZqbD?=
 =?us-ascii?Q?Nt4x45X2k4a4OVeYEOYk3ibwuLUThoF/JVKRKoeRw32gfxzkkmoFpq/vjJG4?=
 =?us-ascii?Q?RVS1Gaif+gPaT/+rP+FpzJytWxT4EUmZdTA0gyDKVRG1GsWeyOqNLg9YrYOP?=
 =?us-ascii?Q?IMe/9PQzYe2o6lPDShN25c7FnSl3KLsHRHIHoUMW39LMO5oiyP5x3tk5JeTG?=
 =?us-ascii?Q?jv56g3YcnMfjyAzJEKwCsvv5cSNTYHqFu5eib4HW5iUYRRj7I+KLL7EJm6d1?=
 =?us-ascii?Q?KokqgAgs0UAlwKfaMTCWkWB9lQq1E/Hc/B7W+tyPVnUkO86Jo+WwgG6gRkbm?=
 =?us-ascii?Q?KRJ5XjLFwrDqaW6CXvJBojKvGWmBT9C52UpDH2HhAG0ylr7aKOlFPHyceoY5?=
 =?us-ascii?Q?JG6c+T3iaoXJl0OM5hIdeOsuMiDm0TKX90lCv+qapey0+pgK2lAfbism9ay4?=
 =?us-ascii?Q?ggafNQYvLgNKzFfguLLerIgd/A36lm1NAfCWNF6TkpYufszSXkgvppWa0L8V?=
 =?us-ascii?Q?ZWIneOJPkOBmZv54gWmTJqCm6pCv1GiF3WmMUgF8KNatnLYQzSMS9mHoa8Tz?=
 =?us-ascii?Q?mptmKYsKtNM5VdCZjKBbUmBrDjbvhdNicmRy8Li93+2CIT203BUlTFP4Km8O?=
 =?us-ascii?Q?KhkbUplyYYBIYmAL7K1R5zJQfw9z1wDSuzsRZ5MpjeSVXPzwGumI+SH5eUoM?=
 =?us-ascii?Q?a+G3Y+iOyH3b8qyzVz2Yu/3OrpmMC42QAulY+3nYiv6zmm6/w7fQnxrvWFrr?=
 =?us-ascii?Q?hY0QBRRsm5bsDM5Fexa1R1IS5rR2LHXR/8ZWAu3ivhdn+CB0srnjdM/TMK5N?=
 =?us-ascii?Q?UVvGxMbS3hzwUtnBlK6jfnwkt2/HWVdKAe/vatKaLKKN31mVenhwQ/o4hBG6?=
 =?us-ascii?Q?YzSKFTF9zAnmhijkOb9N/HpAnlPB2zUlu/rbbyX0bQfOIr5wVhq5Rl+7KndP?=
 =?us-ascii?Q?JDu0BidP4+suTnd+b1VJiqSfI6wtiozeqbfAnWrfKCa8H6Ns4A66s/7yzFtz?=
 =?us-ascii?Q?IzPgMMxKC2f3RWmEz2gH4k6NEl2NuvEmFQ+Veg3W/CTam9A2OzflLNXLgH3O?=
 =?us-ascii?Q?d5/9QUMhaGvhsOSdbKKz9xVDuYe8ajJIYN70lTv4FTkfm5/sigFb0A0ytRqe?=
 =?us-ascii?Q?WIx3RkPduI734/mr+Q3fYE2QkRAfqg5RQ+x5JRB78vvYyjwSgycDn8a9HZ7o?=
 =?us-ascii?Q?I6HAbzLam3M6Ft3uQoti86LSTJadUi0auU5JPTX9Pq+TqRP2kS8DMXCWoNKU?=
 =?us-ascii?Q?z7Lf4/WRhEPqFka2g/7qT7BFgjZwUlGb38Ya8UNOmd4FCMtN2YLq+SwkYZ1V?=
 =?us-ascii?Q?MzDeU1VzFB+P0TzyjBWEqagasKEgdYYOCIxmU4W+85Xvkxaylc7PvljYeycc?=
 =?us-ascii?Q?aaQ/biQIgUL1rSb7nkf4LarbUZtzsbYWT0Bdui3+THJ+lY7ruaaNmEvJAfpH?=
 =?us-ascii?Q?mipznE21n6h85WWE0OUNkfTjna6inXSGz9vvO85OjMyw3Se4MUVwOLj9GNdH?=
 =?us-ascii?Q?un4d527BdmCvULPVa+K+6/wNZYxu+QQACxRoLXdV2vNsFYXYMxKQeWx80jKi?=
 =?us-ascii?Q?30pTYjYSIqXJ9juATpbjWZ+2vsXv/6HTiRC+Y5TlJCf443CgNcnSMBTgqYpM?=
 =?us-ascii?Q?nkjioa+ialUI2BFBauAQ7BhdmZt4Ux2jcfcIoauXL6UcI+tK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8ae81d-e254-4c07-0fd0-08de9588963d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 16:05:00.3089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rEbyHqbHRcvE6OPQdjy94++mElcJRkTb359YA1bTYOtDMc0/PCQaPB27gLi3wbR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239
X-Rspamd-Queue-Id: 42B8D100006
X-Stat-Signature: rek55zs5zgdqzepkxysyjo1qe3trf4b6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775664304-348466
X-HE-Meta: U2FsdGVkX19CCf+af1xreCggbSwPU7LjoQ6GeGfflLDKKRDe1ea69bh/CblVeRJE4aPGjjbmWr5xTqH8UxRwHhVXMbzkPBmZvOeeNlY6qRgRTzqJW8iIKoq2CDdhNf+Jf4gSNvnbtp3CkYFmIEFXijeBjlpZq35tNAZ6g2C8+YMaQF3KGa/G/KKgquG9xvMukftviV4APR68joJ/5hMdvWKBlEj74NrGPAwErGScUq0HqO1saTi+UdpG4WzhCPoRmHD1ODhpVoHCPzKA4+5pUWHqJaLapRfbdx4rt66FR6zd8QW+XToTQmoGUdaRa77UdAjbKy3v9WZUUUOvwCD2WjJD1BcIKp5HeXtVkHytkfPgwrGZkv+j8eIzrgluUnaQXkOSV6d31WquatWMWMmyH4fvQK0hDYP9HFigXBOr6okWKXnCgNEuxBdQycw10dgcALfoPIrQXEyad8dnh36y3GF8Kv12qKQnnhCbRGIgjN8MYWR/C+OzDjEkhoBBoqXPN+cRv6QOOfkO23E951I9efIAjVSFVLljKJjbEOWggjxljiCmrAZrJ/l6ZNN3pqESlxjGfoZO0J3rj2zxKueDJ3+RNbwy4ppeVshSq+NTQ9d9tk8w3kborbKHMiCYH5pVz/KsThyUf3NMTKHDj6ZxymEvZdgxvi0KHo2zSpPeHYb0rljqYZJb4DBSyBYnLRxbPaHT2RNEhD0TN/JIHruJeefOfPsdE6QL1xWDb8eCm2q214E6IbkUvxAt1w4CXy+LP1TYQvLJbJEyp42L0S3ljzm1SavpCVoIfYL27Nu+5aWnyg750JFDvtB3SK68agWy2dGddsN1bEbr84+4nmCkev7wuCNK73D6VDkOHeNSp7L6v/GXtRwaCuZLuPBYkGY0raqW49mK6m0kAUckc+LbgBfEM8abkgfzr+sY5LNLOR1Vjtoh2ho5NZoMFPAfjSZv/i+wTSfadAaJtj+HUXA
 bcwXpOU4
 149m9M9exjQSFpbTjfpJWDtChRljsPN5/zax6hhaBL1FFW/cXiYcyJNHbY51Y58DKOzR3K+pBbLYIbDdVjXGcaY+A6I24Yfp1xy7WRpAuaVzNCoUv+4K25m3U0EmId6bHL/FMFIDEtkIZsVdtjSQjdhXjQ9/BAwvXmnhrw2C+z0EPlqzLg4HZdi8P+7sCxxcKwUlhW2nvNC2jUSjSL6+8m6iO0EyJzFN9LjGwe8dNRie0dVgHuV9dmig8K9T67FqzDcGzxwA/A8zvOVel+fOReGggqk2R3I3I0nmfN+EY2wYO9SGjqOoo580KCBK396CA2FjM8IXENq5omJtNZIyQcJfuQEzy+thkDoPDuN3o2DhvBVHmRNKskhtXksbGtoxNC27lOoaorlNQkfyFQeNKV9roRkET74cjnAv2Ja74vgXRReUcrklYFXe5KlxMVUl1jY92sGR+eQKlXsYSEyU0qgyc4Vggdeu92+RkXzsAfnCQ4lvnXS6Mf/ILSlMAINjlmc7hxubmEs3QXxytwOq5jgL9EW1/+4LSB14+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 11:46, Breno Leitao wrote:

> Refactor defrag_store() and defrag_show() to use shared data tables
> instead of duplicated if/else chains.
>
> Patch 1 introduces an enum defrag_mode, a defrag_mode_strings[] table,
> and a defrag_flags[] mapping array, then rewrites defrag_store() to use=

> sysfs_match_string() with a loop over defrag_flags[].
>
> Patch 2 refactors defrag_show() to use the same arrays, replacing its
> hardcoded if/else chain of test_bit() calls and string literals.
>
> This follows the same pattern applied to anon_enabled_store() in commit=

> 522dfb4ba71f ("mm: huge_memory: refactor anon_enabled_store() with
> change_anon_orders()").
>
> Breno Leitao (2):
>   mm: huge_memory: use sysfs_match_string() in defrag_store()
>   mm: huge_memory: refactor defrag_show() to use defrag_flags[]
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
> Changes in v2:
> - Do not be too verbose on enum defrag_mode (David Hildenbrand)
> - Link to v1: https://patch.msgid.link/20260320-thp_defrag-v1-0-6ab15d0=
d26eb@debian.org
>
> ---
> Breno Leitao (2):
>       mm: huge_memory: use sysfs_match_string() in defrag_store()
>       mm: huge_memory: refactor defrag_show() to use defrag_flags[]
>
>  mm/huge_memory.c | 98 ++++++++++++++++++++++++++++++++----------------=
--------
>  1 file changed, 56 insertions(+), 42 deletions(-)
> ---
> base-commit: f3e6330d7fe42b204af05a2dbc68b379e0ad179e
> change-id: 20260320-thp_defrag-540fc4f1fa3d

For the whole series,

Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>

Thanks.

Best Regards,
Yan, Zi

