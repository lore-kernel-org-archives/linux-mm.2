Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E24DC2A096
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 10:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39556B0128; Mon,  5 Jan 2026 05:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09B86B0129; Mon,  5 Jan 2026 05:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB7D6B012A; Mon,  5 Jan 2026 05:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F88C6B0128
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:59:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B69013CBDA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:59:54 +0000 (UTC)
X-FDA: 84297615108.24.AD394B0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0637840014
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:59:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BubL4FmD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=S0nx1HA1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767610791; a=rsa-sha256;
	cv=pass;
	b=ndH+qu3EzYq8Vah3NcWkaTQ7yp/aZIg7i75NXUYy7GcaFxwFjW0rPz4It6HQNIeYe6Gawq
	CFX/vWcNCNbY0F41JavYAwjrl4o1C7ZL4hl3VhhGkWoZMxyT3xnrkquT358nZQlD2o6868
	ZCG0KeK1d2xxrin/LqMDG0S6vbyLcsU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BubL4FmD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=S0nx1HA1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767610791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOwK2bNIfCef9mHgRPvkGUlwiJ65N6SwyHUS8bjlRfA=;
	b=J+9kzmPJ9O1ohVzwbBpJGRctLpaTRwP6V0UfsT1AR7OyqM6rQV2Putl+bJ7uACgKdpCG4c
	dpUOfYvMJbe5B1y57oGQag5nwMNVyAN6ZhC4ypSbbsRSx8v9xwYSOoJjDTmQ959yAh/zDq
	dybFeiWX4asU1Uyrlfrd+LpJcMS3C9w=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6051GrcX345276;
	Mon, 5 Jan 2026 10:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JOwK2bNIfCef9mHgRP
	vkGUlwiJ65N6SwyHUS8bjlRfA=; b=BubL4FmDhY5ReyRXZ3hJmE11MSP9jitAhA
	TVZ2ySqWgziFsxYI7hAwrMpDzj84Opjmvj/lTCzAsksmLqKS72tF/YRAIopBMgkf
	vUDx1TuRkvYv5ovo6nIy4i/s1Wrexn5IeBIROQiKsc3/7bSLHg8tLIjJgh5tBGsF
	z7F8aBI9D4/1NgVO7cjROY4ulQI7mIqEKwTptClU6Qab4bufPZ4hXgZJig50ZqY4
	X3HykM8A7rS1G8GDq3rIkxso70TfzU4HvKXPVImgmSrhP/uSzGiUmOEMU3in0qoW
	TuHSmsrznxqNBNUmeEUHuwdBD3k2HyzLrrN4nYNQLe4OH43kQT8Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev6nhhw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 10:59:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6059VoJh020426;
	Mon, 5 Jan 2026 10:59:44 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjh8kw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 10:59:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wVZyQ6cR38YMpfdrH9nJD4WMQY3kF/k8hSwgQ27QJEdu3d3iYC5GEvVfSCffEUK6xC+I5b1sMGKJInNOWeaOZ1oJpcJ4HujkoFLhofPSqc0aI2kPJixLOm+tOB/sA8LRnGEPPX7Tpm/BKLdeBI/bdjJHJNCwnDzCbSQgJRMIS9Wo8IF2Esc5vuzHXcWkYgX/XUsQKtn8uOaMV5/fU6Mm/LZl7iKEDliKyQrNqISOb45eihaqlgg64iSaFTF1DJxdGg+b3WLlko92rJj/QeOM8z27KM286xRSYAq2RP9I+BKXk7BN6TW/uHP9Bq+kNWVDf9zhZ8Iw1+CgYWu/LPubnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JOwK2bNIfCef9mHgRPvkGUlwiJ65N6SwyHUS8bjlRfA=;
 b=Bc+N9/7EnS4V8IKql6x4FU4eWmMtcMRsO7ko09HqwRvKPNBOP/+ggPdHdLK3zlnhtRX7Ql/duqPDAx57NW1klfdB+AeNrAWdnwsrKv7xn6CsoXzKuutIZXivyfROQjK08k/16PkOQ5/EbH0fVvA+o5Pjdxy85dKPhQY5VEgqiz6d2VMiJNLGF+RhUEHfvjNJjGTa/ndmAD4rNmgVbY1AnbrjK32mavYbZn50QtkbcqOhLV/D2jbButEfu1f6yqB+BwhS9BJL/QQJRe0E/TrNwVy3UrqA2cWmcxmOjPs7Cdq5lk9DY91KfxKtnWElEtplan6SEODC4AVSMAPz226EbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOwK2bNIfCef9mHgRPvkGUlwiJ65N6SwyHUS8bjlRfA=;
 b=S0nx1HA15CZAAC2Uza+iF/VydKXmAmjnDjL0/YBXYzZUA39mH8xMwkLlh1DELs6lId4J5AIXdx5e5mcrvQ5cPAN8vs5+DZOw84b32cIFGN15/wCJ4PlskDF4S60zNSz5RGwV+frqI2Rn/b5Ttmvc2GHngDqSB7GuWKkGyrIg9Io=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB7199.namprd10.prod.outlook.com (2603:10b6:208:3f9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 10:59:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 10:59:40 +0000
Date: Mon, 5 Jan 2026 10:59:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <1a0ffc1e-1989-409f-8dcf-5d1d025e4c70@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
 <0826eb09-216c-4d00-b4eb-ed1a2ba204bf@lucifer.local>
 <4e45bbf5-29ce-7cd6-8b01-8fb1331ac758@redhat.com>
 <ab116128-e11d-423d-9ef2-dee0193f7ca2@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab116128-e11d-423d-9ef2-dee0193f7ca2@lucifer.local>
X-ClientProxiedBy: LO4P123CA0525.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b7f3589-9982-4eea-e396-08de4c498666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?doG96XE3SAqOm45X0uH1+1z0RIJcWo4Jio/RTu0rkHy1QCNRDylWjUkYxba2?=
 =?us-ascii?Q?1Hjpba3ptIblcIvGPH4n2HdocZ1s4f1dh2JgJvekmi0neBZbpeDKJZnpqhpf?=
 =?us-ascii?Q?UznOwIiZW9df2EIF16ELQKNYr5v/tsZhu2wyA/AGBgmSbIgwqYathwFr9mYy?=
 =?us-ascii?Q?6FywPCFnxe+k9tD1Fbcqa/c6a/XJKy0IHlA4o9UYAOdMhbEHdbQCL6qVgXAl?=
 =?us-ascii?Q?oHGNcW3SB8ZV/kKkjKMG0S0aBUo6gyk8Cd9fXvv0T9FOA9PItP3GcZCakz4S?=
 =?us-ascii?Q?ixhCow6x2DZf2Z1FjKQeYzbyXRP+q4WGUzbqXiUoXe7wFVEIJlUY3ZmE7VOg?=
 =?us-ascii?Q?oPtsn23lPXwEqNxjBTbU2yppzspPCIC/CoT0YG1F1mqm7GfGAmozDgUB5nlc?=
 =?us-ascii?Q?GbDm9QMALjWOTlnnVXLJNkVaZYMyUaOEwLi5BTsVPwv2BN863kWEvslt6teu?=
 =?us-ascii?Q?VLfJB1v6bZwuerb6teELoMD2PoR8Hc6iR231mfVB9ZlXOF4SZPzDU5DsbPq4?=
 =?us-ascii?Q?4eEESZqMzcbYOrNhKGeEqxJhmYVak4PfFNe55Wc26qADHXmDecqRlz+tSLmv?=
 =?us-ascii?Q?0frCYT+WXrueP2a+Gn5Op/tyj8MMRWJc8XTlRt3fLFiRbgWUHOd0IT78/yG0?=
 =?us-ascii?Q?Zol5qBJvgESN1FeWYvgGPvx/RQ29y0zNyfR8t02PHM1T/uobYkaTlWHL0Qtr?=
 =?us-ascii?Q?RRqlHwrrdKLEva5oLDw5h1a/kQgbLO77kzsIf1ly8fRkPbQgBEXa3tmpWITH?=
 =?us-ascii?Q?NAfKNajszgr3z5WrDvEvDZsWycW/A4SQtL0+JhwdBNCvK64X2yqnT6n00tSE?=
 =?us-ascii?Q?YKBuaTDQM+SdMcuw5ZgBIC13I10lUNYmeF2eBC2Izlqlj3OLY7R2hCa1l0xq?=
 =?us-ascii?Q?vDaxcAyxbDIdZIFcg5ta9W+ttk/ypoUagiyh11+KtUvYcMO95tNousxNyDPd?=
 =?us-ascii?Q?tycRlVjMyfmSgaEvFrinkxv/jKPI2Clwye1zdCeqJ8tH/PhAsrluF8P7Kow8?=
 =?us-ascii?Q?7BNHfqHmZajfRjYqul2oK9czj6ewvSs4F984eCFQXm+4LiwliR8vvjP/DFS5?=
 =?us-ascii?Q?xK17tp/efSEqJpCO+ETz4HC6mcAw0XJGTK0dzNP9TG0enklDQK4VkwKFU99l?=
 =?us-ascii?Q?lP1HbICZ4Cg2/I4tk04PLDcFJ/BTuJv43wh2kdh3AjzKex4tSTREuisJo+4P?=
 =?us-ascii?Q?BwiFzysC/orVH/iAXZrV/TSpNlBTeKAh9qZmnhd+ckUMiIh1kyO98Ok76iG7?=
 =?us-ascii?Q?bxsw/0l/ewMDngLMbgLTQ8zQVQ+SjjBZSFpe9gw0kC9u0PbyHmh+R07GqyHu?=
 =?us-ascii?Q?Q7e+lDu0buVxZrQ7GfdCDhdJ5m1em8mPRedmUf6cidPm2xuPWBihxnpUSN+f?=
 =?us-ascii?Q?XR5AfrOqe7kNNyf77cHD/meUWmc7xlIwdZW6llhIpW6MFGb9yw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?349qOUsSzgwGFd1bqcka5NMhNkeXDCYx+u383SN3I2iDg6LuVcjKiP9BSEZu?=
 =?us-ascii?Q?TiHYPPYZU4OG7F5uUSN258BE1083tGz6J/wvDpGaHcU5+6NOm1UAynEdGgtg?=
 =?us-ascii?Q?oUvJuH6vD2qUMPJ0uYd+MowWTm7L3siKwDxSNX627Jqpkn5IveTGkm+/rzGu?=
 =?us-ascii?Q?j2aQq9oAfHo2JBJ0oKU3ZItgYEqKmrNZqkhmL6rMVojlhOFEUNEpTC5RfjTP?=
 =?us-ascii?Q?GUk8/G+y7ewtMViWW/CgHGl7Pi/Ga4iN4dMioT69Z28UxXmVqPpnVWo3IMuf?=
 =?us-ascii?Q?wN6mfm7/BhF/OVwHRYAHag0fuxdJA21AXxKW2LA2iO1jY7/OC4rqhs8SoTHs?=
 =?us-ascii?Q?h5CEtVw8b5SrsIHOoSI7f1Sm3xjx3oenqdXWxU2H27FtljBTzuBWgewIhRSY?=
 =?us-ascii?Q?iY2bETU1G5BFPyABqzni3VKdgo+s3eQC9ekf7935fVgglrscu5frb6DY1WNo?=
 =?us-ascii?Q?BK6Mgqx+GFJaOv2mVMisiXqyG1ZXVf8sXNsaaePBv87C1zA8txxUXWU12xBk?=
 =?us-ascii?Q?b8z5sZNUrfL80IreDOdbEvIsnv2BjmwSoRVJqirpZO0iD2sPaTeFMUOqKkql?=
 =?us-ascii?Q?cr+4xOiqn9c0MpXroq2xFmxoaUR9DjS9GivGFnBzsZmlKczkjJZ76lRqg1f1?=
 =?us-ascii?Q?/Ds/TVyJrJXkAMzcptyyr3bodOB3Eq1py20N0WrIZflsl5Vyx3bDYKrJNzTp?=
 =?us-ascii?Q?0Xzakz7SI9tlM9hRQ2csFnpF1d7BXfPzbOYbDvvK0zvleZdvUBhTqdIxJx4D?=
 =?us-ascii?Q?oC1vnj0UuZIXbC81HxXp/7ufhAWA33/q8pmYpqt2mkGv1S/s91o/UyRhqmg4?=
 =?us-ascii?Q?nPU5lPjUzxrY+XbveFevnNeeLPXoJgtwYFss/vS5ytSR8tL16xkV+rhh67/u?=
 =?us-ascii?Q?8xUKgWBKw22xsebChWPygwN8k/IGOKPLZGhEfgBcRA4GqxACEyly63msiEyj?=
 =?us-ascii?Q?IJ5RmpeLiN0WmBLRbvCfdUgiNIgLTbuF+Td2HmoaNwVOe/KFAomP0GzBgDSo?=
 =?us-ascii?Q?cw1nbfxL/6f9fU2MyR730XgmS8bfveeWl1uFtRic6x50x7/xwgEgz8/uB3qd?=
 =?us-ascii?Q?l32oA8mUZiGYRlhDxK/6UHrCKXcaX2pVeC9fye7ZIzv9dgG/PaPmzsXb81ZC?=
 =?us-ascii?Q?1q7Iju/A4+hCmXedtZ5Gq0ttLZWKs4AA5ot6MhIb3D9QdzSl1KBZ7BuVPop8?=
 =?us-ascii?Q?n1De9KdQZ8AyEWoxyBWggJ4sYozuF5cTeF7PqNkFykID9Pv7IShv7vKxxhci?=
 =?us-ascii?Q?4ypZcEk5lZeZcFJHpl1D4j2bVuRUd+5zWXJ+wTjuGfhgGhZotHcdzmClP/0X?=
 =?us-ascii?Q?2JtfCqOyMgR4FdlxgpkSGTatLRnxH0xqz3qY0bXGd9I8Lc9zt5/GSBDBE/dq?=
 =?us-ascii?Q?LcADkBf4tt4aUwlG6K0lJaaAaiUmMcpHEW9u4xAkO4JekQVivSPkqWUBQO8/?=
 =?us-ascii?Q?gtfq7MB5ITeXe6+BnNGsOtVNq5U3nVv/iPfHfvdKfnv9I8eHcYyASetZZdO3?=
 =?us-ascii?Q?Q6tjUStTx7eBHbW6yAn3E/UaGFsPD9kYVFXv2rRi74suQ7hu2XCHLYWJmtR0?=
 =?us-ascii?Q?D28Hfb1x7dKGt5X1poEoEVbeNqtXJeRpTF3Bwn4CDkUtZTAVqzwPvRASfXJD?=
 =?us-ascii?Q?31BKxBYbjk5UfzTEWzCMhnmX2jDjCXL0dXZrGChbSWSbC24Pr4m/t6d99xv4?=
 =?us-ascii?Q?srT38+w5jKkn9Q3RvQ0OdjMmoXikJF22fXpnbHuQa1kxwy5vyJC45iMrWHrL?=
 =?us-ascii?Q?DubJ+00hSQfTeTDtEDq08+O8GoZcb4s=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tec1XDiyuekNI8fHWh1P3S09NubBktHK00iOp9lmwIM8IjMqbNe13KEwT5AA61hAMiKCILDYuFPtCQEFCoiGAboMAJR9ffbo3RDUM26kA1W2h1k78Cu19A1mwkssthtbc2ExuP4FxJI+TQzMHiMbddXJE8DKJmRVaT+91VQQwuzVrDC7LMROGneLTWUNessk+NMb/9vbmrwRQVaFOD6bhIhZotZaU7IEIKFYBOMy0auRreZni1FIqrpc5Er3uMIcChl6+cX3SMQUah/E1R5yVCu/hAElY6Mf5xBM8mgFcg9gkJs0x6Clm5I9FY2D01vL3kix/PCAbmh070C224tSdF6oK73MI/u/K79sQKuSTwlsbC93FA+0cCMKwpOT+2N0X+rDvYHlIqatm1g1QM5LWWyGZdReGpOuZfrOrg84VR8F0lonj9v4gV7kWhxNGS0BrLCJPJePE7nfKFcNo8T3pOkeDOiITFjb8qfv7OkTIGwXXdmmw0KgLQQrtB7fIsdiWqmPRjqTYFRYcqHZg9S36ekI0s+oV1z9EfUdjomO3zDTL0SZ7xKIxd9R6VEr9BluWbufG6mvg8yHJ3dgrmP4PVckUqqCrXwyW/3dzca0XBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7f3589-9982-4eea-e396-08de4c498666
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 10:59:40.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RT2P2oS2n1I3wOEwI88cCq2TnzBnk20JXdd886AOAn868wrosMWxcBSupq//YguTLE5cpK1Q9sfBFKtiraxh/2bPmS5M1ciJaCb6i6U4kw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=540 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050096
X-Proofpoint-ORIG-GUID: cD2UajBqxQLLzPDLkRjnt86m5TkhOG6K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA5NiBTYWx0ZWRfX1DVwg+EmiUYB
 fjXNekSWwDkYL1mBgZ4Unp4q2JmEZGg2O/I6guB4BlAmtAEPcdEc97McnLgZuwM2I0S2i4v4qdB
 +DH8/XzADpigIYRumIy0dTPB0qOpXBPrkpiXiErf/pgfS7iELfHYRRK6Lq4DA8rqccKaQ2A3O+c
 p1ihDCR6tBXezKBRaSvFTBgpqDjv0DIlPzZQVwOOMlJz0I8T9QxM/hOxAbizPmoqUJ9XIJY8KmD
 7Vx8Xka/qud43nJljVqyhQ3ZG3Nkpwy2To0Hxo/5+cp9gr9SthjUujd/dZtX0HbNWfk7CD6S2lr
 HxfhZw9YUAgxPyoZBL6hU74GE4TKO38PQ9oy4pg6Tm9h1i6bZBrErmyRcs4VdtvXSBdUdH4kINN
 hyb9WvZJg6dKKqV89aAgfKiTRHMe1gcYjtNBfagLgVcSHmRBhoCkAjjwAz1uIEAgod3HD/QjSBN
 i7tMDiW9jkn503wnCQuhq+8jWYdE7WJPf5XEg1+k=
X-Proofpoint-GUID: cD2UajBqxQLLzPDLkRjnt86m5TkhOG6K
X-Authority-Analysis: v=2.4 cv=QtFTHFyd c=1 sm=1 tr=0 ts=695b99a1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8 a=_FFHNvDLAAAA:8 a=nvnVJezV_YK0ILpi83YA:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22
 a=c6drlLOehFC_xabKdUMl:22 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0637840014
X-Stat-Signature: jf7cjsoaocet8b7txk9k55qzioco1oou
X-HE-Tag: 1767610790-515593
X-HE-Meta: U2FsdGVkX18K6eBixStm22vsvjqLQC0FB4e+5gXLgGYHiD82M0faoWktrov1e1sdrUqy9egfFIul99dwl9eMmBGjctT7uiFgx1VFH+NdJmEuLygUv3M+vLFSEpyTUHcEeLFDW3S8fHiYNv+h6HC3zteVSmFnH75BiNFLmKR93yep4PnX9+fLgzKXcclNiFvehpIWl/MxozPb8cs7AVCdhUVjzDjocoR3vQQF5CS6L76T2hm+TXlEqgXPvnbRNFKlbHRjeeqdNO+BhZwsdjNTZYJsfQPdRQugi+OGRU8FkdrNh379iv9pNaOC6O4eMCj4ARDCQzYiPGAMgV11VJFfb6HrvaK6YoLxvGLlspWe8CCtvDfdpkMd99mOG5qkFQBG/Hm8zkXPWrZ0yk2BEy+6Ff+RZQ/qsvrqrMSMuo/uZ+6RgtDTul0KUpe3hcEI4mxH5zU4xA0q1HU06uiRGj50v/TReSOrnI55umo8s2eUgHBJNwHwzxfT8MMpUjIKzTRnQMzD4XpZhx0r4SwSvu96GGCyzZwdAAcEeCfrG4pjeBHoPVOwZVUIyju1pVRubc/E92pYQy5YF7CjG+nJrcPhlinQcXDJr8FppvfygTARQO8xFkZkqxyHrdZqei4Lkaz+0yEazUy7Ybwzu350PwriPibHK1eCWKDD64kj4vfDFb1ltROcd3/iMgkbM+JzgT48VdeTC1E9n7fKGf92oTOPggMjwRmEzRatiXJZQyVrjYbHiNUN12XOHbeJBrMMBvlx4KGpEk1nSFxpl+Ag/0oXpdrLGgfQGsCN2gvJ//NqPEemZdmExTonjZc5scs9KNvPx6qt6X+IikgP2bFCjaa1jbRCsZHvQyk5FGr5UGOLnJcZHyZgYuiHTB1bjdIOl4jOxikk03uJp3581LOsPGq0J1bjnluBzDtGC2ArBAYzrv9w9XmjHzMb7xuiJJ3wspzi2/w+N03YGt5/F5hVd03
 hcfOGxOK
 bufzIZfWZ1EPZUadbgbiQAI7J18zG1fBktehOckx17Ib8wlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:45:25AM +0000, Lorenzo Stoakes wrote:
> On Sun, Jan 04, 2026 at 10:12:50PM +0100, Mikulas Patocka wrote:
> >
> >
> > On Fri, 2 Jan 2026, Lorenzo Stoakes wrote:
> >
> > > +cc literally everyone you should have cc'd in mm :/
> > >
> > > Hi Mikulas,
> > >
> > > You really need to check MAINTAINERS, you've sent a patch that changes mm/vma.c
> > > without cc'ing a single maintainer or reviewer of that file. I just happened to
> > > notice this by chance, even lei seemed to mess up the file query for some
> > > reason.
> >
> > I saw
> >
> > MEMORY MANAGEMENT
> > M:      Andrew Morton <akpm@linux-foundation.org>
> > L:      linux-mm@kvack.org
> > S:      Maintained
> >
> > in the MAINTAINERS file, so I sent the patch to Andrew and to
> > linux-mm@kvack.org. I should have sent it also to people on the "MEMORY
> > MANAGEMENT - CORE" section, but I missed it.
>
> Yup things have changed :) scripts/get_maintainers.pl --no-git ... is the way to
> be sure.
>
> Understand if you haven't touched mm for a while you'd assume it was as was but
> now we really do try to have people assigned to each bit.
>
> >
> > > I'm confused in general about this patch, you sent it on 7th Nov? And it's been
> > > ignored until now and then taken without review to the hotfixes queue?
> >
> > I'm developing code that translates parallelizable loops written in the
> > Ajla programming language (www.ajla-lang.cz) into OpenCL and runs them on
> > the graphics card. Ajla sets up a periodic timer that sends a signal for
> > scheduling purposes and this signal interferes with OpenCL, causing the
> > -EINTR failures.
> >
> > So far, I worked around this bug by blocking all signals around the
> > functions clGetPlatformIDs and clGetDeviceIDs - but it would be better to
> > fix it in the Linux kernel and remove the signal-blocking hacks.
>
> Sure I get that, I'm just confused as to why this was suddenly taken to
> mm-unstable-hotfix out of the blue a couple months later.
>
> Anyway I sent another mail with review, please rework this patch accordingly.

OK sorry you already have, sorry I am catching up with ~700 mails after annual
leave :)

>
> >
> > Mikulas
> >
> >
>
> Thanks, Lorenzo
>

