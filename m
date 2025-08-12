Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE30C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27748E0175; Tue, 12 Aug 2025 13:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDE48E0168; Tue, 12 Aug 2025 13:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876FB8E0175; Tue, 12 Aug 2025 13:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 765E78E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:07:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E43AA140132
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:07:06 +0000 (UTC)
X-FDA: 83768735652.28.0FD4DE5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7400F180012
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:07:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FgbmVKNP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hhptruq/";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755018423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULm+Z5W2dJUBW0QlOg/cxfxUjmH31m+ETbSrRjeFt68=;
	b=G5X91VLMMaI55Ws1qVfzLxIOqeE1c82hMaSU8sffK0d+FN1kRTWVMLvFVbVf7hqKo38ZXp
	QNx9MMHjS6JFTkSg4U2ZMG5z/u1dyhz3dTxfFDsGdJUjVmzV1WYmXcmqgYEAyU6086b6oT
	5hLXOUcW9jmzN8ZS6xnXDc4cR/JKFAw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FgbmVKNP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hhptruq/";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755018423; a=rsa-sha256;
	cv=pass;
	b=R68R/q0SUtVW/v2NJ4AqT+sLvbL7rikTgyDa9wuC6OrHKyBl5FFjN6o9vvxQDbi0nATbCX
	UjKrDtMde7rY9lcdCQ+/7+Aag36Xi5uE64PIOi37ItH9lYqunCYtK4Kw+VP5etUH0bMAhy
	EHsZfoiWCfQn4vHPf5XqwAmdZiRv4GQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CDC8ln010988;
	Tue, 12 Aug 2025 17:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ULm+Z5W2dJUBW0QlOg
	/cxfxUjmH31m+ETbSrRjeFt68=; b=FgbmVKNPjHCvoZVWYkHBykFQQn1EX2En0k
	noJrtK37uv1R56jCtZIt/c9ikme//E6YT3jAjKPUitkUxNSSqef5Ol0VgYiLDJcl
	d+rTSsuK3xdW9SLgCZyBnAJADo4IZ57+v1o5IaOweG1bzyZfG5I9uT2V2VdS9JU1
	q5zrb+kW/WBxxGpasYzj5YGTJw7+G41Wq6vgVhDnUhfkkgNL1UbyvLjCc25m7ian
	3PTbPmmuO4OYcxM1m9yk75ceReu4ZOoy43FvdxQmJ2g0RrwuEpTlGTQ43/PAT74m
	khe1KvhasoKRvDL4j8GJlkc/D+U6GuPaYVygjpGQO84QicW8qijQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw8ed6cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 17:06:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57CFe2wA030104;
	Tue, 12 Aug 2025 17:06:53 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsa8dh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 17:06:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FSC9/bZ/8n+rC+8NUua7saEsD/SRxfpt+lhTFTB/DlCOCiWzougsEh2GdkBIRP6Qb5KqxrA5E7pQtRUEaJMuy8xyvEyeXozMnmc0TmbsK3vloO3BO8684KjteccuoTlcHKyfmqsYfM9Q+ftxhbT6u7i2D0+5GZqZFmNUKZCeByEAzeqfM5Z42WbR1jXgn4alNVotXAJ/lwz00hjk8q81DlM1UmrZGC2glh3ve0F39VF0U0A5u8E9WSYGz4Acc3PGx5Rs2nmksEaZ2R/0qQ0mUj+29E9mcN7ex4DZvD4MKW4EUzKH5m5zClN9BdwN7pQ3Ggczq9+F4xRGJIEuWIDMgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULm+Z5W2dJUBW0QlOg/cxfxUjmH31m+ETbSrRjeFt68=;
 b=BJzwSJ+3UbugcN84LyJjT6pr136VOM/p4JppELn72g6aCAqp8lt3QtZjyDvM+Wzp0ensa+A6f1bqEFdMmm9WGR5zicBuicFCGkGKFnt21brWrWfYT6Vsa558uWpeRdDOINviM8TdpA5zZ8SGX16NuuGP00U4ca0XgFZNDAT9wQKcFT72dhOl3oriZcEziypX/Q7YL4fqQpbPFkIQwLctwBkV+7FyW77Tb/sC7kyvx00RxbKFTLYNRI93qAtz72Qgm1l4JG4BmOCV0TuaVwu8fcE2gLmqlVL1nWekcz02rJNJlEwNhxI9yhsDd/A6RzaiddDQw/l20fIFzH0jw6JWIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULm+Z5W2dJUBW0QlOg/cxfxUjmH31m+ETbSrRjeFt68=;
 b=Hhptruq/KcGkoug+M1rt1ASdE3+f1TZ6K8S+gUFyBAj/l4+TZGAlofIQhWAUWOPhnP2ie4+TeIcFFe7+iTjm3orF6UBVBIe+7yZZxFjnVreZlCrH23ab4fc8OxNY9l/g+Y2lBvAlGWpcwK3ELMKM4bZW27eiHzewtntmsF14b0Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB4886.namprd10.prod.outlook.com (2603:10b6:408:114::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 17:06:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 17:06:50 +0000
Date: Tue, 12 Aug 2025 18:06:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baoquan He <bhe@redhat.com>
Cc: SeongJae Park <sj@kernel.org>, linux-mm@kvack.org, ryabinin.a.a@gmail.com,
        glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <6a77525e-8ed9-40cb-9c56-053e38296906@lucifer.local>
References: <20250805062333.121553-5-bhe@redhat.com>
 <20250806052231.619715-1-sj@kernel.org>
 <9ca2790c-1214-47a0-abdc-212ee3ea5e18@lucifer.local>
 <aJX20/iccc/LL42B@MiWiFi-R3L-srv>
 <b5d313ef-de35-44d3-bcbc-853d94368c87@lucifer.local>
 <aJtBJgC82CpUkwTi@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJtBJgC82CpUkwTi@MiWiFi-R3L-srv>
X-ClientProxiedBy: GVZP280CA0017.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:272::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB4886:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ea8a0d0-ca3e-4955-20ca-08ddd9c2a0fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?naYfaydcSbbvky61E+9f4+Bav733nCB9W0PoXR3ybUmKNb+X501SeZrHeweG?=
 =?us-ascii?Q?MtIds+KtNgIPyLCODdSitTRmKA50MZ5O7A+NtLsDBvEoOceo7kvPnk4AtnsN?=
 =?us-ascii?Q?ueUxuKtD1NL83HbHOqpEzEX7Vfrzl3NCb9sAMXHRA6VlcV7mP3M5b3z4P3Us?=
 =?us-ascii?Q?cPA3sEL0ig4dLriEpr8uWC1ywFSD53b7XZg/3sF8cazEXyAClYtnZAVvvjnf?=
 =?us-ascii?Q?laRw4tROalpkevlEXyrv7omm40L9aHxCFUo+WA6qDPIYWnpauzHMky15djto?=
 =?us-ascii?Q?VZh8+IApMFtthyuvwkXraqynmYQ4w2iTgFWI3MM9haPOpzS0WbzII7cXgttU?=
 =?us-ascii?Q?LgvacYwnY7eSI7zVRX7HQ4LTJYjJEvdfE/V64Dr/G8uylXpP4/JED8AI0Adh?=
 =?us-ascii?Q?ZdUaFQBMl7Vy9usQ2P2EiypZEHvwnMDRwXjPI7J0UkMMM37RAeK300rhIOMo?=
 =?us-ascii?Q?Uf4xXYLw0v2eXZ4YYxTzMEMO6Vrou1pUAD+J/D/na5n+APlfAYJ6phTRBegL?=
 =?us-ascii?Q?DD5Pt6uqUCDXZb6JYJjdNbbKgn8AHAVnhDvDDhj0xTr19Z7hSPckKVaafhJg?=
 =?us-ascii?Q?1F2p6roOlUfvjsVCKjiEeotnIt07qyOzEXbVU6YtTEQS+dywIPQbinsv8mWZ?=
 =?us-ascii?Q?hDEoZ09kEQav9CKyfaMJuIqZv4SkSfJ3nxDLUFbEb8COZBCfS5/so5rF/QXI?=
 =?us-ascii?Q?p67ceypr2rb+r50V+5JuJ04Yl2lhCpqmUH6ihO4zQ1Pu662ww2NdI7nDYwXI?=
 =?us-ascii?Q?APa2OgviDmFMJSIItrL/3okDnxz1HbXbvgOvse8XwTst6PW8+sBhRStCs77V?=
 =?us-ascii?Q?OnwJX18UV0ons5r+46x8EB3Dk6AHr1a5p+v2zLA5nMhBHHUkbwQL29Sb1C9m?=
 =?us-ascii?Q?F4opwD8DAeSu7RzW7ynZzVvPMkU72K6Y/PpXgS/Z4KXzONUe6CZERyqkeohV?=
 =?us-ascii?Q?6O1EvVIqWt1fxW1xdO04YkyVWMPdL/zrL8cX2Wgwc6LuBx6UZ800yS3/phis?=
 =?us-ascii?Q?5tvKK5HUYcCf825VLT7LuTbwixV2zsEaGiex9oi/Ow5vR867mVMzTEHJd9xP?=
 =?us-ascii?Q?CeM9sv1PoFg7sJ1T0krG7/7QuhRnTrq1hk0QbR8R9oqJlR14z1Yhn7N/z8l3?=
 =?us-ascii?Q?1ebbumNL314Qv5WSL708LRjIRTgZi1Nd4b/Va5Kj/GlzVv6cHC8wiTVL0t9Y?=
 =?us-ascii?Q?f3k9MWT0HKyK5XB106zgyikemOXu6mGl0OdmuF7smWVNGcXegszn3SaNL5sj?=
 =?us-ascii?Q?zVBjIZNYdsPcIrR1SFOH9HI41YmOuq1S0ho5YeA95HuP5AuFi8CA08mLGP0B?=
 =?us-ascii?Q?vEaLfMsxJiBvG7mhPpWECHFkHD4f5JzeMN+lEOoHiS2DiIwqVM/dhBBbRPbR?=
 =?us-ascii?Q?P31PR0+YsGtZAmS04uvHL3Ub3P6RByjQ5LHZtlnL1W9X2vEvhwmzK3slOLaS?=
 =?us-ascii?Q?fV3x3JlprQQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V0n8CwnZI5gIJlOhel8DBTqPQWmYilknGP8m42jBugqYe1r3W9HK75yFHOgo?=
 =?us-ascii?Q?Gtf9S93mkUwu9kiP6DtEKLiYqp0XMpCMeIhHIUDscJkbrjufGbSXayGm1UTc?=
 =?us-ascii?Q?qqOh//+kSLemAXOpB48UuARz0gblEQ/dFAHgT/7/PG5DpuQMkAKnA2JSa/ZN?=
 =?us-ascii?Q?bNODXwWbGBdM+wpMfAs1/RtkZWIpa9RezTsPtWqcUn88TpJjhgfXcHkdwVly?=
 =?us-ascii?Q?LFiqnv3HV4arpGzZMU52e69iFX9tL439d2xlW6YL7QwMEOmvgC82MjAHRqxE?=
 =?us-ascii?Q?FzgLckR3eWKvgAYwMXFSt6UbPOqZeKYkFE0tWsWaCDsMGZ/B2w+hWS9Z4Zyx?=
 =?us-ascii?Q?XrRqRWYWpR1ukbaVC87gocJqkweVpL5C9xLsk+I9AHk5Kzu0N4/bLam0eEeF?=
 =?us-ascii?Q?NP1aSC7LQI8Lx7Xh1XfOmUj+x7gRZURr20seetDaf0Io++jRApM8STdZLj8V?=
 =?us-ascii?Q?Od12o/eSMffjz6SPP2eQ9CRJsASrVfBw7P2fDZ51zUjZVEdre92IYF6+qJ0r?=
 =?us-ascii?Q?9ExHyBnBFX0CPRyQNNCAZvoDhcKIpwWb+EFrN7SG/QPIvowBmh0kpNSwPBM6?=
 =?us-ascii?Q?2/AHdnP+OfKRRtVK3Zp4ZwIUmtdfZFmOJNWfXC1JveAAggPbVkz9tcwe5yWy?=
 =?us-ascii?Q?y5HdrW3qZya6ivt8y1YrtSJyGrxq0+iJa5HOn+Lo/1XwF/Ryu0fwQsMZu1FP?=
 =?us-ascii?Q?cm3MF0OWaGmA3YBpDY4Nk1YBEpX8Av8mXEWG6ZUBBIbtS4WMjNlIJSo/tD4t?=
 =?us-ascii?Q?RhwV6f0cYv0ColXs0zo+nNcBk7f+mRlMs7lTQEmvSJ1cShiylKYMY2XWV7M0?=
 =?us-ascii?Q?roBF+S6pEUPvxR4EH/xOaPWpMSt7u/warwBaAa7xCDLmgkdTVml9KksdGrKe?=
 =?us-ascii?Q?X8q1kU0ACT069NmVEBibfXAOepMH/9OvyH8+kjunXPIEHxdxUKN0QAz00NC7?=
 =?us-ascii?Q?5GqmPnfzFUJP/YqeD4soZ2rHa/OuVO+y0ZOlMYIt/N37gIHRfOcULSDMg1EH?=
 =?us-ascii?Q?VcEZ4sjvNVm6W6FJ6+AbG/WG4og1c3pVL6g/tHaDrv3GkAtBJnj5p1nHZwb0?=
 =?us-ascii?Q?6rppochx9shbVZn6mvcJ6CHuokMgOnVLslv1qmraGtgyW4c0wrLXPmv7I6LP?=
 =?us-ascii?Q?1i3AtPg/yOwKivLI2VcBckuLXxxyheyYkY/X3gGO6f2lAIQCyCoYr20X12Ev?=
 =?us-ascii?Q?DvBwFsRWTx9nGBi5fNIILr/dGVXhd2BeTkJzBKPjJXKR3SifFqRhkDoiikEj?=
 =?us-ascii?Q?Gv6AvXWudytB30bnBENn7ElGBWnN1RZtMMZpGPGCu+pxl4jP8wVaprkrFKhS?=
 =?us-ascii?Q?j8oMPeOYHJKWm1c7RaDkAnMlBAa4TNxat92C0omYI8pve3oxOxIyXWCTHWj7?=
 =?us-ascii?Q?cRMi4tS1SPH5nHddjJp05o3JJa3/sIaX+TIUGWDkFapaujO6saS3Dgev55Nk?=
 =?us-ascii?Q?kDVvC1AhqjQYlhX70jdTA6+I9W6lQCj27lmD4c60G856fWuz+6Hy9wsZjRfP?=
 =?us-ascii?Q?X/+lus0HVHuCQmFS13HyjWeNYnC0wx9V7ipuOxUMyscx86YAERLRinhYS2ru?=
 =?us-ascii?Q?IDUk/odShpX5Se+6iltD4b8FJbphU3N6f7jiNIjRKhKjEWAojiCw0wlzoPmB?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z1Ole54E3ePISKRkerAYMS4ufpbx04TquWj/4tt/LX5gkSeu3jExpUQbjRci7AqMQEIl3R7yXRk6IoS/lRW7vAOlF5vuvJAdBrwpfY+bZ9DtdNnNhFXjjDQiXdM8lPam9DPPz2HipB6ZQIfq50KlyiSXEeq1cIfhTOMYBmFysrh0bQ52KNk30/1MjGRRKHLDf82seVw7kHaYe4haAsfYu2bWotT/A/NRHGN+N3+eMzyrw9P3qILDVpEsEyScGkoMjnLc1PybMD5MEFjIiBY1nmMQAEZRrxRa7UbfgP43Wc04Ka6MhNblaiCfVt4T3+vxEA80WR/YcK4z6ZsQrzR3f8+zSjSl3ZyX+y3ATMyK4cCCX8aa3nJi5teS+KfVd5Wksr/USlsqu1znQ9ETmlgvYfkKjoPF/9RZPLqZSln5aZKZMWMpFVt9OIUPiDI8gZVdo988PXzuRGpLd+G5yCpLxqrkjRqey5pJQGIHFLPlLdv1JK7UGf8jvbDo1yH4bI0h1pxf65yE407sTr4NkOCn7CZrMYIvwZ367vOKCrcn6N2ITqJdaXIA3/y4WEQJ9kdPCN4zvdyhlOIgery+6hyUtDK1a+C9G74t/UxE1RpVPpA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea8a0d0-ca3e-4955-20ca-08ddd9c2a0fd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 17:06:50.5153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TczTZ/aOgdw2R81LH2g7n/b3SkQzdf/HslnUl1fZcpTNj90Zgqz3jtYuACNH51eaydOLq09P1wXnssCDEQG7oiD20hwXboTXvkK54MqWxtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4886
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_07,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=861 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508120163
X-Proofpoint-GUID: -7U993NcxNUSGsnW3eIO1NRx6iHNCRpO
X-Proofpoint-ORIG-GUID: -7U993NcxNUSGsnW3eIO1NRx6iHNCRpO
X-Authority-Analysis: v=2.4 cv=ePQTjGp1 c=1 sm=1 tr=0 ts=689b74ae cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Uv9ryoJrkueFjJXwpicA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDE2NCBTYWx0ZWRfX4u8rDzfnELGP
 BJfFE7ciWHPhtohC0TjN1kTUjK1OvuxIVm5fZwkesJNwFw2cLlD1PPSGEYN3XZGAmDCU/bidQz6
 R5xLZj9t+8Jiv8O1J6WZBtPZFLR7FcDKQgz5NZUtcn9ZU/KXhmXLUYynoxwrPhu1zxr3CsmaAA+
 Qxl3lZ5Uj3hNXuSduI3fMxmgPIVnOLQ/KN9kRTYMvcn3m7ZXgxEDoaptArCf++/8igOPSxbr0Kj
 0VdesQSRnjMfMlAT6A+3Jv8V0hgSRKTYev37YswSFR8mxwmalQF7g06tPqTRmzNsXPkGVGS71RT
 7+LTMAOg9Lr8hNUYdkBIB1SD+UtYEixMqUz96Cx5R7X7dS7uyGFMjqtVnP+KAIg+e1nrPp+J/pW
 IT0uIRbt3e76wEPTDGkbOaIhGVL00Es9ANZ7moOjwYKjO9c7v74xy4c39TBPkcDxmeuJ3bmM
X-Rspam-User: 
X-Rspamd-Queue-Id: 7400F180012
X-Rspamd-Server: rspam06
X-Stat-Signature: c1g6975f3u6apgprutq19qykox4jsuas
X-HE-Tag: 1755018423-929973
X-HE-Meta: U2FsdGVkX1/qPdzmsaaA6RNiqAuTU4t/a6AQd+VXQqHMLqy3S8KCDJBiwK5Y8YVWHC6o80UPjKTTkf0MUN1PTzcJv45UrrY7SogfhMN0wdEW4IkpJ/FeSjiYD2djljz/7aM9cv4HORS5fXliMj0GB0nh6F0KLaKIiFxLuRREtVJolXdzxQMMLzlZaqnBgl78Ler/N/AsPHNEFeV5Pd9dsZSgWf10sPmSusfoykY6e1mdUYAv5cto11oTfEdnKv9GEvGbr7mAifPoVFs9q9QFndmQTiuHdnLNOB8X/GJLjFneIzEngz+m5kwRGs6Im23vau6g4DDfZWF1QHxbCLdYHdsBxmzXHzmIiG4HbES54OnRlW6AZRhtpyhE47GIHuBK+ncL8FyQuo+UCQORTe+NX3PAyt+JTJuCZY/j4Ts6fUd0sqKxatNcbALXDMJhgbcvjsthlyvN3XZiRDKn4LsKkPhJCBZYYhVTb+tJcooDpQh3Hv51Xgj6maB4imKLOuqd0qiHBxYbk3DEF2js2NSrrkw+kYnbRHX9HDUx7SkyK+ax4LpLxxcJI99fP/4pgxnOvo9UNB7zx6/XuBQfp340WQyt/A/rov4KO64UfNEUByJwVqdSNioXNBh/f02cNVANZQRwCDr/fSl/VRrwdzzxDy9icKq6H4cmPHhj1Yk5iGco3FZbyKD/sxuKGYRjTBqnqMBu/2R2DJ+JOjOzs8j3IVW4+BeYag+7g47GQlu/P0Kq4MxB7HQgSkUF92s+LeMplKctozz/K0fAT92rm97ZSLc5GbDNYfIQX/SEBeonK+Je3aIlnwgy8zP3avjnPuvfAD3tFctGRrzRwvcZcvlNPpvwaZsujDaIPSATmJze9WJ2KEQ41CSxfcjwEv/b1j/dB5sii2fRLsTyeYjpthFBO+iq+2REJQMIgbE0xA+l+ttFdmzcIjeqNJ2b6GzCSE18QfHH0IIS6yAaRAXTHqx
 v4HzR50J
 QznWX02KFekUbvjYDJoTUU/BByhKmgWpVydkie1YxwgsMuuXotOzpWIQlfsh9ryOdmkSUegnko2k3s3wbo5UV8YSCh+JhP3KctVbz9yULJhmX7YG4u+7QAoizBA831rbXJkvQ4N3hKjIp8lnXWEnEgRvskGemBYDGi25ieAV911VcvvTY0GBJC9V3wfyjwYzMH4MHtDLALwG/V0gACG3kmUHOdbBAndIBKTJppBPc8B3ZHB58YxfurhFwsShOYM/u33fInVtUEa3Lx00OkTho7MiOsOpzVOIXKRoc9d0swpuOZVB0RvwZR8Ynifirwr6t9h3FOJtDDrQOsREqmSCgVnsDhHmpA4a7Bof941vpH4UzSjB0vLAaIG4CwmSCG/Q7pCD/9EWB2SjzeuyDVgwWAIwwyyDZYkEMmvvTLi4iFeQOPBe1i0S5RRTWGyc3o1X2e2Jgcb6iqJnjJM+XU7C1MAUsWGCLySAisd8AiJudcmFqovwddEgmSkIr5bopB+zt+zHzQEO7bkpBZorIVokXLicYuiiuzGAdfJ9C0mBrDGKNfV3IvzU9/aCY85HEok660DSrHZAYqfdZ/Q4hm/mB9Q3wiojVOfS2/0QDQqOYfWnQEhLYhK8+APS995LmWJyMle8wndjKsbg9K8XBZGdpEQwyMg+6ORO1W9zLlszv1lfoin55MoF30CWsFHbXdwGPw5nADbRLl8vGKJ7PCLk2rtmX6r+AWLe5FFo/3De98rcl9CPfn3ThEl4wCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 09:27:02PM +0800, Baoquan He wrote:
> > Firstly I _LOVE_ the term 'ifdeffery scope'. Fantastic :)
>
> Learned from upstream people with expertise on both english and kernel, :-)

:)

> After investigation, I keep the CONFIG_KASAN_HW_TAGS ifdeffery scope out
> of CONFIG_KASAN scope. Otherwise, I need define the dummy
> kasan_hw_tags_enabled() function twice. I am personally not fan of the
> style. While if that is preferred in kernel, I can change it.
>
> #ifdef CONFIG_KASAN
>
> #ifdef CONFIG_KASAN_HW_TAGS
> ......
> #ifdef CONFIG_KASAN_HW_TAGS
> static inline bool kasan_hw_tags_enabled(void)
> {
>         return kasan_enabled();
> }
> #else /* CONFIG_KASAN_HW_TAGS */
> static inline bool kasan_hw_tags_enabled(void)
> {
>         return false;
> }
> #endif /* CONFIG_KASAN_HW_TAGS */
> .....
> #else /* CONFIG_KASAN */
> static inline bool kasan_hw_tags_enabled(void)
> {
>         return false;
> }
> #endif
>

This is fine, as CONFIG_KASAN_HW_TAGS implies CONFIG_KASAN anyway.

