Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D21AD46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A276B00A0; Thu, 15 Jan 2026 13:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465516B00A2; Thu, 15 Jan 2026 13:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F9A6B00A4; Thu, 15 Jan 2026 13:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7276B00A0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:28:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C753AC1D12
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:28:02 +0000 (UTC)
X-FDA: 84335032404.16.65A7DF3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 55AC01A0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hr4Ib+99;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="QJ8g/9BX";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501679; a=rsa-sha256;
	cv=pass;
	b=axYVaJs0Wf8qcQym2n8yVQPT5zNFOObiFa1mmtp7ZezNl+V4jkkG9+79a9LfhdzmrnOyBZ
	n6Iqkj+v3M0wGTi2mxuF37W3ha8iQPm6vsdJZDhMaQd3khdFIJaFgzoX6gfvzciJPnWsfw
	jr7M16rXMCVAV9qEnwt89EHfJMltaTo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hr4Ib+99;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="QJ8g/9BX";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=;
	b=mJDAiW0LWKrNyXNl3GRWaSuL4E3S1S1lh5pVDJNAGYPPT+AZz2PwPhrRrVbmrjJGe8xqSC
	kmW/QrGbXeb4A4FFClUlECQCWLfaxGMBzObCM7smzm0pcRKp/DNZQIkeEgKKQTixrcfH+p
	QyQFdKPa9POMRW6KDD4EhLY8HglN8FQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FGnSMi2420224;
	Thu, 15 Jan 2026 18:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=; b=
	Hr4Ib+99JFdVh19YuFi5yCiG6nMTKMv4u8vFQ1aKUgW/LVCDKJ9raOiMi5m4D9xJ
	1Q8+jHba7m9e8hwgWS2aAQv3aOM11/IYcTHTTlQ9forf8xI1oBjdRhD6xm0nFwIG
	XqEVYQJZdOZpzXHMB3OGRklwrbsfoGUtt/DQw/kRM4CPc3O2aICiOyS0GAGA25Oc
	aPl8diJsOMPdQYaU3UaP469uO+QMIGScQTb+fx3KzVvN00hGDZ0W92VervPebB36
	Fve325pC9Ur8dLckX9yvI0f9MQRSCFCUNqT3h+O/E4UioKcP5Z3kZKfX+6P7CSB9
	VVSYcuK7GjtCvxBnrs26fQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre40du4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI44wO035388;
	Thu, 15 Jan 2026 18:27:46 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bn9n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbwZomLgocdYtHHksw6r+sAkDm5Q/PSsDi4kYNjtuf64w1BfR37fJU1cvUrk6jTRnc0WJIGCxlYUMTkOnQ0+x5wey3jmx9FsNspD+xBEgYhNPxPHlM8SDiv4FhYD2ARPMmi1F4OD9xez//iA8ETcRL4DsSzlnDQNVkjEEjx4toBszqph9kpRBdO5CjGbCKeUyBwqF/SuqFEAUAP8yLQRifD4/u3ailP9YYxn26cI1j/FAGxUxuaVTm65BBcWfvKm6Eal+oIjjh7DirmChqSLlARZSEq8EuxPfY1OQY3tImSKl7Nep0Auxwvpo8HQsNSbKNFQxWhIE13MNFDF/7DiKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=;
 b=IUHmn4XXw2P/poE5O6AbzUreXHVm26RxQrndRqmdbJER5PqizBVVUpq8Q7keL0RT7E8QjBVyXxSjyeuFotVPUI5ZyHll4cRBtdFtPTpQ30tyWEs4kZ3zv1te4fJpRi6oczC25iANqad2WEJj+RVGA37X9YAuvZtDeAHiyOXqn9a55jUy7Idt8cSGfi0vyn41h8YBGyIp4Z+u3Dx+UECOTOYj6z+9ZbHa1AEc9owe+9MC5eQCCuF2/Rek/GItZU2x4mYEtvyAwqsZk296s+zylCqBcP2KvLQ3livw5PZNm+UPq5QaWy8gq5+SzyK7S7/36c9b0QZVgjD8Rejuv397SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=;
 b=QJ8g/9BXXF1TJDrey15oBQA9/3/+8jyrCOXNqImpE7YYAxGsw7Hgzkclnx7Op7xo4Sw3spO3WrO0bZ+j6zWaFP+xw1VnkZ5r9YifgY+B8nBkTrfkM4LBlg01vKXAqtpPtt898UDzJtzRY9TJy4FMf1Jc0mSZjtCbWd53HbbB+mc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ5PPF0BB87A13E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 18:27:42 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:40 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 07/10] mm: Introduce unmap_desc struct to reduce function arguments
Date: Thu, 15 Jan 2026 13:27:17 -0500
Message-ID: <20260115182720.1691130-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0086.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::25) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ5PPF0BB87A13E:EE_
X-MS-Office365-Filtering-Correlation-Id: dd8dc847-2dbc-44fe-c6a5-08de5463c422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?32C4hAYjSOVuUQs8F8sTJ9+hEzXdc7K3zJzId7sc0tPzuoxtoEcrlZNZP6nV?=
 =?us-ascii?Q?tvbSeoctCpAr2dcikCYWToTrTRc/ilCHy6BaewRChAIoyrXYWppauPoCkD7N?=
 =?us-ascii?Q?bWBgsuE7dycL6bPkjbxWPqx5JnwrEA/CFFaZk9Yuyyzztzab0bArTk+Epa7k?=
 =?us-ascii?Q?nXxcZpZ+YvnML6MSWDrEgIYcnoeI9BoYxs9HYLKzcRxzoQe2C8YBPa81HD61?=
 =?us-ascii?Q?Coi4Jh0RUx4ClK2M5c+OKvTrZKFH/TRww3Auy5DP5PgSvjNB2A4D8UzimSuj?=
 =?us-ascii?Q?DnOIlaXxbvqVeujLlMSOz6syt9F6PVYZCd1Lyoi/yCX4FfS6A3XcPIxGwiu4?=
 =?us-ascii?Q?L2tdjAYOpCT48l8x+p28Q19bL3gLsTU9x6pWPLQI+/KgMEAdLajpVdHxN9F2?=
 =?us-ascii?Q?ikSm9aS/bMvlJKUE1UdHFJzXA6QCluQjvYBmorhXH/NyyEIHwYjw1crqG4nd?=
 =?us-ascii?Q?vvaRllrTto7ZG7VgFLyZiFCr8tmm46MwVmbOV6ZBl3fwrja3vqgrunAoiIEQ?=
 =?us-ascii?Q?xk3p0Or9XdP3mMNlEOcrG2Kuy9AOqQ/DNmsaOphvSVZdcx8pRZ+IDG3bys5X?=
 =?us-ascii?Q?nUlwiXXtWeZGpryf9m8NoBAwmISTydJCh4KN5N/SlybTWBnCr1owXMyDe8eJ?=
 =?us-ascii?Q?pWATIQxrRJFcFtFrXlDJVXJMC2erSpyRYaMGp+RPIqhlkt9q6WdG5xXboRzj?=
 =?us-ascii?Q?Ppy1rkiy9TBHXYktZbkKThLQk9KWRaH5EOVqePaDaSuYMgGyGBWrxqkxBhC/?=
 =?us-ascii?Q?nDGgRb8RF4jiiOguyK00/niNFfprrT1LzsP9rCg6cv0YGGlQYUZwRC8muPrf?=
 =?us-ascii?Q?L6NXKvu4xCszPuZ9dXSwSm08s42rFRwkBZQv25rmfYnxq/K/Gv4VzMp4iuek?=
 =?us-ascii?Q?A/dF4hYxTQFYPZ9p74jhmavXRSmBSDEnePG1Of/GYCsnCRQeD0T5rNvGBP0i?=
 =?us-ascii?Q?pGiVhTGvpvmr+GMSI8KlSEs9Pk39UmKMVIc+m5kkYNynr6ZeCDzxZVOidtp6?=
 =?us-ascii?Q?1PtC/fIkaEVeZ1u7LukmdwA2GP6htf+NaY3505e0C9IB+MWrUrUl5uzULzhh?=
 =?us-ascii?Q?a71bLxIL/vA8ji3QO/FCoLlaM+wQqPfSQQ8aDw1iVL5HcgaIUGmfgrQgdasa?=
 =?us-ascii?Q?wTIWpDQXHvKk1v67ljLEPTQukQr9lp5banLT00kN+zey5+Za4e3SPDFCMyE+?=
 =?us-ascii?Q?905mdiT/hyMPjx2PzUL4DGgn3737h5BRao/l4IrI6/LgHUCAOLwBsQlExFUn?=
 =?us-ascii?Q?pwgNKpLpk/uF5A+55Szn2S+DBCyaaM+6mh+ozeLXau7Gxg3Q2dT3SehcHb0h?=
 =?us-ascii?Q?rsQhOTMT1UTlglR73gs1qzXBzIyCOecr+AxDT5CYmXF0tG4EKZlnz+23HEqB?=
 =?us-ascii?Q?J9E21jpcPK35EVcEFZImn+L/Il5QxpOu9qaynwlLfX/wxO3wO85Q+PiEO0R5?=
 =?us-ascii?Q?LlRR1PEwGLSNccf8tQgtA4PE0m430fv4SlKGCvG4nYNnnSC1YJ4v9MFx4K/8?=
 =?us-ascii?Q?6tI+MqGnm8Exil1Yfn7W5DEWjDmIReIo5kOrM/JbcR+yYhaByO/LhC4wDHwr?=
 =?us-ascii?Q?bdQmnMgkppzq67Kq5IU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yhXzrwBsu0XI4IIGDQkoSa5oto5Rg3LmykHO/47T0d8Yi6fQfDJrY4J0yrLb?=
 =?us-ascii?Q?aqrY62+hqQU9pzrb5UKlQZHv334WVfGFfpwAxeBKh1s+MHGVn0u3tG3RIBPF?=
 =?us-ascii?Q?BK4bpyEdB/YkDtWGcTazPB5RA9NWtnscEOf81H/Rqj4sNwqkugeey9YZb2r/?=
 =?us-ascii?Q?1+5RqRiwla/et0bvZaFX6Saiw/j81YTAt3dlJU0BD5Z+rCAcfIj4X2WnlWKv?=
 =?us-ascii?Q?hkkym4LCRO6HfPUXQkuJg9Y7gTHP4RivSl88fDRMDsS5/ba3VB+IuOu3g18s?=
 =?us-ascii?Q?BjzwcGx4kKjbp1mPvZaM6lqEdSivDthZT77P2Ls4vc58OJJwTsTYUQ/slOI+?=
 =?us-ascii?Q?l6epkxrwBeauN1K6d8xxNmViyAXuGpnfNxOdIk1qvVQZ1EIcH/weYB6jUI/h?=
 =?us-ascii?Q?LCNFI0KL1hhUtIvPvgIEGuQt6rFLVbaV2Zn2Pw1duJMKwoNYHB7PN0sw6dMg?=
 =?us-ascii?Q?VyUiDet6ZyQ6rjE5MI9i0vFCzKMgVRNw04OTE1OBGV9t8/EPfD0pgtKxisce?=
 =?us-ascii?Q?6kxfMAw2YUpIAIHZaEEYNIl33Bu4B1I3017QYmHWN9XHfD4xEcc3CwayxZXh?=
 =?us-ascii?Q?lNwiTbWviAfAUZqsuFU0NUC70GCpY3UYNh26Oy9yrMhs0OJTpPTASAgiZRO3?=
 =?us-ascii?Q?FuyUwrLnKSr9J8abqWIRZGBZaTEkV2OplK1oauQKx+PxVgilKBKSx4Tj3HYF?=
 =?us-ascii?Q?X7jfiikCRoRYzuxiA/FWNJ+ibaHGnzaFILOqIL/ncdiMiSNs+IRtn9PvamYg?=
 =?us-ascii?Q?s8JQB0WpFX3ixHu+/VbAGHvUHJdDj4l5We/Byw9fZ2nPFmoAfzjmYNA1Nddv?=
 =?us-ascii?Q?xp3eCmJR6xaBsHwnMuo0xVQjbLthsRtPoMc5Mj4QEAHb7yFFoIHb6Ag16RZy?=
 =?us-ascii?Q?0caxQS7ofWEQcvHWirDyWJILzTdm6OGPrmsj49k2uxuHhLxXFihjGYPP/r7d?=
 =?us-ascii?Q?wZU+atipFEtNWYeiriB85r7LMAofStXsVQlwZs4v1qBx9mwrWDOXfolarS3h?=
 =?us-ascii?Q?kwGYJmZ50wlep9bL9mKSgaR5jU+yhNt95hm4nd/hd8rgu1f2jtwVl3RqBrV/?=
 =?us-ascii?Q?Lf6Ddy2lIRLLzEgL94bjGckrmI89o2KpWoe1GWiGrAc1uLqKc3gC51OrXRmE?=
 =?us-ascii?Q?kgJfTwznRHh68p/briMLE3qZQzSOcjz0AL5YwL7WbbLc5LZ80BGPjEgfbn/i?=
 =?us-ascii?Q?6tMJpamibWSCbVK2RSktkHLUsWJbwST/Nwgl3tsP0fLMiEOG9Vywtk+GTm4x?=
 =?us-ascii?Q?si7ac9GbpNyrUB3q4ZUPb6XFVaTkfRzYSSZ7wK6VuainqVYeDyMYSuyWx/sG?=
 =?us-ascii?Q?EMeBmaAk/cn3zsNQPGlDYi9I4SnTMpd0+4dR6p3oy9acTV0qfGtE0FSPAC/y?=
 =?us-ascii?Q?+N2q9OQ9pX+8cGpflwmk1tRPfqv9EfoFZO2w46aaj3XgRks+1AHYSE0V6vFE?=
 =?us-ascii?Q?hFBqz+Tv/l3OBdIqX9vq+CRD6jIy4BbzowZw8V8IbC6PwDgVq5BYyURYZloI?=
 =?us-ascii?Q?5fxnHIgIeC4P9PdK3usGEDRiZEdPFSVmoLjowRX3j3j1LoUFnKhN+TI7vvtS?=
 =?us-ascii?Q?gGq5s606q/WvjpCOYidHhfinPWFbxH5c36WAeVNvj96S+9LXvzXJzizonL+p?=
 =?us-ascii?Q?idd1KA4WbssnmMNgH4QQ+iYYLdlLSiC3Qk3STAKGNGBI61+EnzUIMRcdcEaN?=
 =?us-ascii?Q?CwgR8rtcwRsZ5NN6EuORlUoBRBDUe86ZbcUjoYIQEWz+LDiaYk9jhXJYa4C/?=
 =?us-ascii?Q?vNIKMKZq5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3ZyNXxHHc2SNrA8EG+kW2AHCp8K78JnGxTOs8NtQrj8JXWcqj2+QOGcK12z4bCnGkl4+Zy7sp0okBrqHGm09iYbbCBWXCToM3twe4Os3CIt69SH6a0sYBzsGwCe3jM9zIxR6scckICJgJ/hTS9gLJR6HUb6+Y7cywIx0qgPVNAEv/0fH2haETI/xe2U/WTnJzOFJp3ea+1Wwd9bwLW4a6N8v33RQ8Uw8Fm5T71RJlepAPFM+w4UeGdcpESk4tAux5JILsk5lybKg/0rD9k3tLtr+USISn0JESoAnUOPMnmnvYhJEx93I6Rcv1dZyJOj66fu/dcqLLBBrwRtoDsguJGc4XVFX9Acd2or512sDL/m4YF7DY80+2cOW2iYrY7wbWls5hiGUKH1YiKzFfZHsvHPssCcT8HHwp+DTTdzWSmT/phXiaW0jStGULLQpwu2Gdxp4Dpl8KADTl7G/dYga7JhHoHqOJVNrQFZNz9+0dKEfPYpmWv/XW8k/TsClY5CZLAE3csH6bVRWTHxWDvDHPxFmsXGHCK8F/ffjXcvFOV7dYK8FeXbw6vFl70AuK310gVXSouDq1uWun+LyTblFM+HPh0ywW2nroKDhDsk8Ycg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd8dc847-2dbc-44fe-c6a5-08de5463c422
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:40.3483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xonPkjajLCEvtIGSQn8ZAJIgsKGvluN3ET0T3ohmq6V+BvA3B3wfcne97KN01DZzO+SJmEW5fbooS+i15wlFpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0BB87A13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Proofpoint-ORIG-GUID: XfbTDqtKSHrnKfivpGcPRLHCZAC-DXmK
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696931a3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=ba_3bG9lUs-xoXSSiEUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX5oNpL725gUQJ
 kHXFnqr8BHw7IhBjBTzKON8xv6t66sWcbwi7FIe+0Fg2qQUeofND3Ts8zu8HdZIRwKjPgFR6olz
 hDyD/t1hc0PY8GF5RA2GvoO+TktcILEcnRgSpA5PB5PGeVTjqczuhiUMmhRyFzwwPJzOeLq+06s
 XukKwHIu2tKo4S4SaSckxRHrChmMVKxtkFqTR4L+NDU57vAPP6Z+0l4BPm1G7b8kTO1BT0C3wWd
 64uo5zxP1s7b1M/W6cjS48BeNzLowMQVfz3bg8Vv19K0/c0Pxo263aBzzeLaK8C+K0Gs7BXHTSD
 H18BuOkVNpvaXaG1/deFJlt8HCR4AZXZwXaK/k3pxwL+H4CX2FbPZnQFXkw6uu+glguQAEpi/JG
 ukVi6ZyF3CVoK0lMJuUuOjuopjpyDg0ABbDWYI3FgSP50dcsl1Am4c15c+HRg+srNVGvC6qiZRY
 iuOUXucItZh0SclbfUw==
X-Proofpoint-GUID: XfbTDqtKSHrnKfivpGcPRLHCZAC-DXmK
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55AC01A0006
X-Stat-Signature: yca6fcznertrhbfiswat97j4z74bm77c
X-Rspam-User: 
X-HE-Tag: 1768501679-779125
X-HE-Meta: U2FsdGVkX18dE84l+S4QLdpHlh/ohWKVAdJCP/Gu9vfmqnW3Fk24JtMGoLnUq5SA/GMuWlZorQAmsxopOXaEsrSeblGJ8HovxNn+GyCARYlnOlZevuSb2AWTOMGau9OuQpzfpnoS4uI2pexhTztoBWDtkXtaeULBcjasOPA0bb2obQHe8+2HiduYlyYTslDYhKKjHUDMhM3wJOuXpbA8S651MbSinG5wymzcHmeOUN5/O664x+vP2YTSk95TtpkTraiDRj/MFwcQMjC7VNZxQisqRW+EK/5jkA//0hd5X7io/hn1jrDnbm8Ef7PKjGS4i9tV4XJB0SLynzNWe5MYAXsNixW6XtVnHN7alTD9YlTlg0WLAIyOzauZnIqwInguKOJ0qwvaJXJbt9ZMvEhwJ9BqCilz+cbDMKFV/xjSx8p9PER2i38VWCbqm3RbhPtnIHCFpV6oYNWiha8/CaynUCBif0eT8irgFjhrLYWkyFQ4aWhQzzO3a+Er9f/TSrb7/een1zStPrRCs9S06uEQP+rUQpfWi4SKtXmlAoYM2kz42J/i71/ngnfCnV0+m85Bd4L6+BkHuGAeLP+TgbnGLuY6RTUh4+ok8vZVKtbXwYL/vYO2CGmD989UTR5O8NanpJzbF/Femka9fDS0W01YSVq452sRd3c2bYs3LnEcrERgQNSXhZiL9ZSCzIyLvrzLrNeHcZF/ozypWFxzHmaxmBu+/jwMpez5OnoUffQfPkcC/DEH8pVjZTTh3xEADlxAwxNKN4JZVrIpjffJOxT5AS3YGG43MBFxg0i0twDyYztO2upbcQKocjkPW6wHrEmo6PXwuMOqM2jfCbo8Zixh+4ljzUQZ0Tc/AmlYCY7cRW5PV+RzgdFOjNTX1Xu7CXUj7izzTpUk6v1Pufo84PgjGIIhjZ1c49u+8PlJveAWKovDDDr0H/V4shpoCIgxiRo/uCWw7rFIpF4XveOsqQh
 NrtawDRv
 4qZUOdej2XD1RsQi6rtsG8xHCV3SZt0N5Ck+EqpwbnQ7gSDMLcOdpwaYg6bcfhjfnE/tTv7gH1Jl5uJb5tBWD26Qy5mB01HNJKPY3xZ/g8pIOqgJ6E2ZCUxaAs+u6vXAfARMFnstTdxbSusaZhPQX15WEIKft7drZTmk0A0Ra+G8b3z5nzYqlQc/vZeUYAMugS0tk18p6WZCEq9a/hOIyf5cm6ugD/h8DVfrkR3Ryx+ATQnAgzGEK8xmoyoLU998ZduQdHFDEZ8FyKlZfqJ/E+RXwoJjVh4peZbX3A2dzZIsaJJqDHQI4gV5OoZdVNpne6oGqi7cgdH2rNgUNYG1/tW4khz8swa3lbq/zeBCqHbj5ZKHSefKrsbD83gyX7baqxGfKdhEa7twqxiwGOczOUf2sBwC5EbhYUh/xgiJ0Sxaz6tJKHntssgrXwTqK1drY9lySU0aAs5VtGo5WJ367MD6RgN2bIHfur90Z9KIgrNKv+gQzPq3GjXggvRcOetxJuZ4FG/uTMkli1aoXjAh+ogKAqV7mvyxasD5hmkAkMSOrhjeyTclFkNCCfIFNriEgiwvOQo+3llo7In7OoP9kxdExK7qxCJZYsK8F3xGhUGtDcGYj/JaZxspNkfCHCV7XeVUZskkQAHDSc7lsmrCKCth3O45hZ7RXkHaT+u1D+fk2nkBSZ7TjorVUokgYYGIqyAMPgkMKz1zRkbJ/J0/9jKhEaj/lDGUFDYH5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unmap_region code uses a number of arguments that could use better
documentation.  With the addition of a descriptor for unmap (called
unmap_desc), the arguments can be more self-documenting and increase the
descriptions within the declaration.

No functional change intended

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 14 ++++++++++----
 mm/vma.c  | 25 +++++++++++--------------
 mm/vma.h  | 35 ++++++++++++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 48dae3d48e46f..4500e61a0d5e4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1876,11 +1876,17 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (end) {
 			vma_iter_set(&vmi, 0);
 			tmp = vma_next(&vmi);
+			UNMAP_STATE(unmap, &vmi, /* first = */ tmp,
+				    /* vma_start = */ 0, /* vma_end = */ end,
+				    /* prev = */ NULL, /* next = */ NULL);
+
+			/*
+			 * Don't iterate over vmas beyond the failure point for
+			 * both unmap_vma() and free_pgtables().
+			 */
+			unmap.tree_end = end;
 			flush_cache_mm(mm);
-			unmap_region(&vmi.mas, /* vma = */ tmp,
-				     /* vma_start = */ 0, /* vma_end = */ end,
-				     /* pg_end = */ end, /* prev = */ NULL,
-				     /* next = */ NULL);
+			unmap_region(&unmap);
 			charge = tear_down_vmas(mm, &vmi, tmp, end);
 			vm_unacct_memory(charge);
 		}
diff --git a/mm/vma.c b/mm/vma.c
index b92383e5eebd1..75c68c74c062e 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -472,21 +472,19 @@ void remove_vma(struct vm_area_struct *vma)
  *
  * Called with the mm semaphore held.
  */
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_start, unsigned long vma_end,
-		unsigned long pg_max, struct vm_area_struct *prev,
-		struct vm_area_struct *next)
+void unmap_region(struct unmap_desc *unmap)
 {
-	struct mm_struct *mm = vma->vm_mm;
+	struct mm_struct *mm = unmap->first->vm_mm;
+	struct ma_state *mas = unmap->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
-	mas_set(mas, vma->vm_end);
-	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-		      pg_max, next ? next->vm_start : USER_PGTABLES_CEILING,
-		      /* mm_wr_locked = */ true);
+	unmap_vmas(&tlb, mas, unmap->first, unmap->vma_start, unmap->vma_end,
+		   unmap->vma_end);
+	mas_set(mas, unmap->tree_reset);
+	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
+		      unmap->tree_end, unmap->mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -2463,15 +2461,14 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 	error = mmap_file(vma->vm_file, vma);
 	if (error) {
+		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
+			    map->prev, map->next);
 		fput(vma->vm_file);
 		vma->vm_file = NULL;
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
-			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
-			     map->prev, map->next);
-
+		unmap_region(&unmap);
 		return error;
 	}
 
diff --git a/mm/vma.h b/mm/vma.h
index 7c2c95fef240b..cca7553c7d641 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -155,6 +155,35 @@ struct vma_merge_struct {
 
 };
 
+struct unmap_desc {
+	struct  ma_state *mas;        /* the maple state point to the first vma */
+	struct vm_area_struct *first; /* The first vma */
+	unsigned long pg_start;       /* The first pagetable address to free (floor) */
+	unsigned long pg_end;         /* The last pagetable address to free (ceiling) */
+	unsigned long vma_start;      /* The min vma address */
+	unsigned long vma_end;        /* The max vma address */
+	unsigned long tree_end;       /* Maximum for the vma tree search */
+	unsigned long tree_reset;     /* Where to reset the vma tree walk */
+	bool mm_wr_locked;            /* If the mmap write lock is held */
+};
+
+#define UNMAP_STATE(name, _vmi, _vma, _vma_start, _vma_end, _prev, _next)      \
+	struct unmap_desc name = {                                             \
+		.mas = &(_vmi)->mas,                                           \
+		.first = _vma,                                                 \
+		.pg_start = _prev ? ((struct vm_area_struct *)_prev)->vm_end : \
+			FIRST_USER_ADDRESS,                                    \
+		.pg_end = _next ? ((struct vm_area_struct *)_next)->vm_start : \
+			USER_PGTABLES_CEILING,                                 \
+		.vma_start = _vma_start,                                       \
+		.vma_end = _vma_end,                                           \
+		.tree_end = _next ?                                            \
+			((struct vm_area_struct *)_next)->vm_start :           \
+			USER_PGTABLES_CEILING,                                 \
+		.tree_reset = _vma->vm_end,                                    \
+		.mm_wr_locked = true,                                          \
+	}
+
 static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 {
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
@@ -262,11 +291,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 		  bool unlock);
 
 void remove_vma(struct vm_area_struct *vma);
-
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_start, unsigned long vma_end,
-		unsigned long pg_max, struct vm_area_struct *prev,
-		struct vm_area_struct *next);
+void unmap_region(struct unmap_desc *unmap);
 
 /**
  * vma_modify_flags() - Perform any necessary split/merge in preparation for
-- 
2.47.3


