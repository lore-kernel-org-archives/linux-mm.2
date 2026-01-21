Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B5DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690946B00C3; Wed, 21 Jan 2026 11:57:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548816B00C4; Wed, 21 Jan 2026 11:57:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2102E6B00C5; Wed, 21 Jan 2026 11:57:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01C316B00C4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C713EC2B47
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:21 +0000 (UTC)
X-FDA: 84356576682.02.59B144C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 69AD340007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rOmGuFO1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k3iWpjnc;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=;
	b=NXbs6wEXDtcFxQIvn59GLIY2vdg8VM+j0PGeWGKJD4OCmpXuxLho/nA4YF5au+wkKZYwfF
	F9GW7qkXhx0ciq+dshvECE+bmCUiPztSqIIXoJYMVgbZGCcCVAyFaZzyJv0fnxrGzNxNxE
	qUu5bWsg8+wkqtrzDFFFkOa0zOKN0rE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rOmGuFO1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k3iWpjnc;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014638; a=rsa-sha256;
	cv=pass;
	b=OcDcq6UE4h5xY2J9b9/1lz2z0V6F8rSHnNvnZzKLIrwTsmr88WZD0WYTz/4Vezdti5vLvB
	/A1GnkxaNr4Nt/e9q04Pk2M5zFNsoe2wmPEeGMXizNCUyIDOK6MAqwZPaxJhNJR42B5X25
	wPeir5qzX6X+sEBVTcuWaFRdXZpJQzw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LCeNZP3524038;
	Wed, 21 Jan 2026 16:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=; b=
	rOmGuFO1hmLRZu7Y8jDMHBPd0tU5cXUSMOr2nRegnmRlTKlERmGz9PwZjuETw706
	1lvQLgx3Qu0B5SR2NhEFP+eF6QwYyJho2ItMxukk6ocRMbOlhgj0DWc0ZQw3yryp
	lSvD95WNesCtTUzFKi76hyak1h8vMD0O8Sc+/7jIJFHLTEgQJhGwNAr2b46KmFnh
	b/S3kllnA1V4DhoWszlex+ji/gUTDyHWZ9xnCGE1H0/XgYasJZZuy6+jOcyi5EM8
	N9suoM5ZU3I9g9aQdDC9eTadmsVE29ElRd3dwiiJT1PHFRcxElq30uFxGNz6Sun8
	+SoA3+HOfe1Vr0KGRStSBw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qee75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFhhvY021910;
	Wed, 21 Jan 2026 16:57:11 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfa0a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QxofxxaQyELv0e8PS0D2oN+Bb1GXCeV9JGT5PvohjU1hXj/zsBY2MtgMu4FDZmvfV/oCxAqkddpUNn6GYTUMYcanLyVhpYUsmKcby/v3Ydu16CNYSZ/2stLgfZd+CjV8lzZEBIDVssrgvyUxp7y+MPAcxHl+1zrpMq7rFlEoYcyJ0lSGalPd7gr7qT1Jhks7dDxHl9SOkzg3X9AWE8051S4reryeqOFWKiphx+Qh1H77Hq5QGYT9VBdKVEEV9Tf5L+GDwBFNqkVyHML8iDrsk4d91QFs5Cyscl9ficB6a1l45Btkay7fi2p57+Pnv3GEBkDA1WYz4CeXF4FUhVZmLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=;
 b=MNdXVmcqD2+udu4MP57qYo8MMWacXu/EIzmZNBPdjQG2AT+df66Xu2CW5thoeL8P0Us/rWkxw9BGhR6lec/dhfXBVrLf1uiv1PBrE5cun7p2RyhIyyOlUIIx7gNNcRGXUeSq3R3xtRMWBBvzOlvBk+HkJE2/EzBBcTiwbSjbpNK2JSa60RtkicvCQmkiSdq5Z1fa9aNfeMZZbFkQrn5mgYfUcKGe8RhYZVC5Affhw7xvsPpijMcx0auhpI4ttkCbo7crABkG9ROXwvSQqxs9w6sHJSENh6hHATTcfQyKeXTjt8hG841xZp9dDjNOK7AJuXDtovB0oPzeHo6UHl5TAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=;
 b=k3iWpjncqzLPBL8HT7FBOc57VdB8wFbambLR+TTVo26GudIBVVRdc4+gqTPSVZNztFAaIIpE5GTcKmZX85Bzx4FkJtsoj7k2EvSg7V3UPmeS2+QIGPvf9KJ1rIQG1j5o9ocCtY5zsv/590Ez8YY1xQmPkBkg/V5kHL581nlNbnk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:05 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:05 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 10/29] maple_tree: Correct right ma_wr_state end pivot in mas_wr_spanning_store()
Date: Wed, 21 Jan 2026 11:45:07 -0500
Message-ID: <20260121164526.2093265-11-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0028.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::33) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b09c2d-4e53-4223-a585-08de590e1a75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nBi4MAAJbTIsmuhwG8P3vGeOERrQsC3tRSvbNbqNHLsPJ+edgxgKyCnUiXzZ?=
 =?us-ascii?Q?Q94LfDFu3L/dBeCs3hdbbDPgHlmgGRFxp2tE2pSQWX90JASC8Z1fiDmv0L2B?=
 =?us-ascii?Q?wv6vtl/6sgza9kp2I/+8jxSHSCxYDs+nxY7+kWgSAXGEUgC9cx16+bfMQGZP?=
 =?us-ascii?Q?V9fHLDrWf4kaoCr3UK0HxGRPvqvUosUPkNUABM3ngyJnGjakFuvVfKJbyjfV?=
 =?us-ascii?Q?bAOxzxvAF8M1IlPYr/c+eg8eUAVoEIQVKO2bq3RlTNUj+iydcLDFCLlWzePP?=
 =?us-ascii?Q?9S1LWdYZyYihDtkwgER9ZpYylpOKxSTX1dYZVhf/wfIHlWjUCEae6lreKOF3?=
 =?us-ascii?Q?xRsV0YUEaUL5FvYuKRNKzpa+cflHOJyVysKDnNKuNSQGPJa3iYhpfFauEbnM?=
 =?us-ascii?Q?uynuG5kM4jId5HPGCTIPU8fq9pkkLXvTtDJQKI3nOZNFnXJEew2qwjPFzNWJ?=
 =?us-ascii?Q?nVmZ/6CRPdV8+p/zNnMZWHKY/+ORwTbAKZ6nur1tcaHOtbeLwi8HZ01NPAmU?=
 =?us-ascii?Q?EwDHEjD+fGK162ikm1O2CWTSDvDFvQ4AXRr2Enu+9Y/gK6v0vvMGI9T0hFIY?=
 =?us-ascii?Q?h2KnYfEvvlDxtWjEsuIyRR5TzGO+LgdloLZppA4EPPEQsXZTRI50BjeKXnYb?=
 =?us-ascii?Q?Zft7YJUh8bKn/x/pOUX4kLiAOl/lk0gwDlZpsg5lDaDn5Ldwyb2t/kIbgE43?=
 =?us-ascii?Q?w+dgiOWW4U+P8j18Opj3auzbJAbd0EH+AFbD1n6cwRmBXoyB77U1KLlHf5T/?=
 =?us-ascii?Q?OIoGtm4kbUQ8ing3hQ/3wIrQ6zN5CHkCJoRLbrzRERtegt1PmekWcUg+Alfq?=
 =?us-ascii?Q?aQPCcASUgangNOXYKJoVYmzwCDGoDmGC8l6F39Y5ytpBo6e/pgiI8kp6gd88?=
 =?us-ascii?Q?9loE9eh6ePltHo4eQ5cNuzEbbGzDS/Vrw1t8m0o2pBudZY4iuHnraWcISoSI?=
 =?us-ascii?Q?5onx1eXVT62X9SpAGBahLR0t2pkpY0lRpoucBmYRl1NmlF2u0l/8Zeou3MAv?=
 =?us-ascii?Q?BcxPQK6Zv11RMw+ajgwEfbNpyfTiSdo/E64m3xCSme6Rz6bUdsxM0Z+q1pO5?=
 =?us-ascii?Q?Eu2y31C6g4lrJ9tiEBy/s5tZaL8qQKjGsIputszI+0DgF9AegSOeygFp6s5s?=
 =?us-ascii?Q?g82iTjPwxrKDvbSlCxZ6nECj+tNiy6mv/i8ZTb/ajGaAq8fI+AE3JOtZEBZr?=
 =?us-ascii?Q?7I0f+ayiCsJI9wi6YPi4zwbKl4yh94if+LFM9JUoxccnERM0wgNUk8e9gh37?=
 =?us-ascii?Q?o8U8PwzDNBU8OjoWBDoJPZUeCdMaBq+0Du8j/WZcjJjmxtO79sXuLO2uu0B8?=
 =?us-ascii?Q?eTnYVdCfIWdjVT8vOB/culUzYuitXOMzA4EEwa1qQ0/F1pXVdpNKO+ezokLy?=
 =?us-ascii?Q?hiUvDQfBBU9oi5OzgRwqxifG+D/N0H6lw8YVqKd7IEL9oNB+dTD8tjZPiUnh?=
 =?us-ascii?Q?UXadGVvtk4V8aEfQP3qxJusmzVR25VL7csEjF4CJasBJRdZJXQNoeep1O0aq?=
 =?us-ascii?Q?PkUn8zIxvWsfDBPCXBBqHE84jOhzFh1RIi1DWvkCWP2/g7wvyqCQ3cHl+GlK?=
 =?us-ascii?Q?l+pVCkapN8yxdzBs1QE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KGnfnAaQS4yErclr7tPxfX1I+q9RaBxdI9Lzx+u+3Y4LmxLR9z6SY2NEtDz7?=
 =?us-ascii?Q?xS3atwqx0OkwLsB+4eIDzAao95QkYqutwoUuhun+AMsqGrw2cUzIMys0GsVs?=
 =?us-ascii?Q?sxAxMGLuiKEQV/yAFgaqIsQ2pmJ+qBmVf5JCiEHzhgjAIBROIJFqF8EgMNef?=
 =?us-ascii?Q?3Zb9JRZPd2inby8Wv6xgihLmHPq4h9EHYn6opniQZm9ck2uXmMtSpSoAYHbc?=
 =?us-ascii?Q?GLMqmPYDOHMPADc9KTpMNI/6XFgELQA/LTWszGf5gXybJsmVCeAPWrpgDzZJ?=
 =?us-ascii?Q?Y/n0P20qWgHPtqObgj/APqWuR7fzmr/6R+OlIhTWehvDvWjsEqYC4enXWCF5?=
 =?us-ascii?Q?6nmXOt48ym5ww2UJaOlF7GqWgvDJZelO2LE2k6NqghvGn90NuW3ccKeeJcDk?=
 =?us-ascii?Q?Vysw2xVrlwoPnkfZOewbHvVZwHu3y3C1Hzyi5IXPP/WmcWheafEOXYqwCGxI?=
 =?us-ascii?Q?XCpC6oqWNpKfAqJPErSTUattMBHjbd9eDo3Th/AJOc3zS7pxNmFCcvuNsId5?=
 =?us-ascii?Q?O6vAW9U9XUaq/+zIv9FgALXLCDjgSoc/Gsr7vz6Qq2tl0yNEWRHp1MBpji9F?=
 =?us-ascii?Q?vHhboHf5ojBvfpOutQQ6h6mvwIWdASgDUYtNitl5CG/NSg6/QnY+nOOnbeCG?=
 =?us-ascii?Q?qpcP7Spk9B+kdJh/BJXNg3mlZ54MN7I4hx4bHYsPq1FQXVQKVxrQjnWdtIk6?=
 =?us-ascii?Q?jmHBDyC9JvJMfA3ZlI8mE+7iMLpcLjj8FJhYxWpqnfzP9a23O0+pSwLV9wvb?=
 =?us-ascii?Q?nPmo5xsxY3FmRh8SNviX9qWdSyyQSD6bMddNbpm41FGYhjxj95xCqR+TLget?=
 =?us-ascii?Q?O7LTcNRq72yiDn8UeKGJXnwTfOy1feVwIAZFgLM40BjDCzFr+3UyZHhUc7Zu?=
 =?us-ascii?Q?i20yeTNkPKc1dmka9FcKuTqeVTzfnfz4IyEsrv3xsYNZI2/u/tEKb14Uz1Rl?=
 =?us-ascii?Q?De6w+U/i/R12mIIqX6t4Bxz0NImpaJVkfxjFd6MNvt/BJ3+kj/LV0GTcSb9n?=
 =?us-ascii?Q?MYYBA8iqYR+3pchbWdv54CxYCz7fIgIibDg6RGQyZAji3wxbw/Im5oOFRg2A?=
 =?us-ascii?Q?YHQBvldlZKDqejEbWOYqjZlh7ZWHrJACo+ELrbAAjVfAJ8gorvmtW3DfChgF?=
 =?us-ascii?Q?oiFR7co/535jbh4hdqCcLzyIJCDGJVyEW5hQ4DUIUNgH7Ga9mFBtJP277LBL?=
 =?us-ascii?Q?hQnepLIvinUU1nKfKPZGjMIEiTiQ4SuTw+c5wksbNRsxupYZ18xp6XLPeTjA?=
 =?us-ascii?Q?DAE1alAEfiiVR7klAfwvA2jFYK+MIFK4+TmGL0wdIy8THSqP57LNRE80h1se?=
 =?us-ascii?Q?BF1unoR2Zcq9ErbxeXN2C9UvBYV4ZJ3g/J+C4wRwu6qtrcoqPhUJB1DJ5GyJ?=
 =?us-ascii?Q?G/jpdtv8Xx0OKkhN52o37ERzJTJE6FR9YF1rsXRB4kh2m/qA2v6o1vQiY3eq?=
 =?us-ascii?Q?lKYwT+CUSb63LgLxJL20CIhrFoCB43sg4UGfoASlDvru3m7wljcV3G6RiM9g?=
 =?us-ascii?Q?wELfFXHr6/MdWeHpYIydCA15nR5ZWIyVeFrA6eVAHbe8XV+aGosueWekzLgh?=
 =?us-ascii?Q?gksqLxTReVtUf3ZaFE+vPKEQsZ3sMGkBs+/tUL8q6tizG/h/o1S+mHKX/8ZJ?=
 =?us-ascii?Q?8WKnFpAw1NR1FPUBcSkG/dbR0n+WBF82gXk+gpB07GrEWB+ymsKXyiXvMww7?=
 =?us-ascii?Q?/VKyp0e9fTji7JVvlBxBT2Ra43CyWNEUqq9ftuZDrfZx/ifMSwNPP4a82YYc?=
 =?us-ascii?Q?+2B6bOqFNA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	87Xy8NThUrvjybU0t9QqBrwejZHmKx7lLmzQKlr0vofw8Exw1/K1BIwzCPcF0PdC4o9zl2VV0BbU/TkaK2ulXJ1v3/4KGkXRHQg5M0MXj1LKrWy/LwcsdmTcQ1xpT1i9Dtj+jHsMJRyOWvtG+t75Ipvjok6ibg+BNsr5aK1dn/5YPHpPNTixEpltmr92v0NnfzrOeRtCXyZuN9wH63H65ykjwtlZWAjdKAv7QRU8v0BD9H3lRj5pE6C4NCXu0vmGGsaeLd+J4mjdXKZDbAxd5cAaqskORFOgmIuWMjv9STvpbkvbtgVEbeEKmS3iRbMOVpYNQEOKkv02PUHW9Fpi1aBsFUeBygdce+hs0OAoo+JpoXs4XdIAjMn3gsOLix0jEzJ12rnehWUBzLtTXFYsIGauDFFER36XtO9plc5fMHmbKPVJQWYnOW4ZPszcfuhw93e9q1Do4gyKs7nJAGt7qVrLX9Fyyd6a/bqzPBpm0kd6qWhNq9VPDDGJSb//CQa4eEsNabe6mtos5qufQDDjKWyNtsGnDThPXWQGmteh1Ev55LrJfZ6T+OXLu8xs9ygpOLWN0YNQBEDoyM2/RNUdfPWTffRe76wYeumBzNWC9SQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b09c2d-4e53-4223-a585-08de590e1a75
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:04.2327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zzmfkVAXbragNAo73yXyGbcBOkuEnCYtqguY2knSfvk/FDhy2DhAktkbR4oVQrc2rg+0t1a5+IZRyHMRxZzitg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-GUID: -KsqIu6qq_uQ2TR_s3gVUXj5W-H62vdb
X-Proofpoint-ORIG-GUID: -KsqIu6qq_uQ2TR_s3gVUXj5W-H62vdb
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69710568 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-8DI_9cH-nddbzlGVogA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX6T8+09c32/8s
 KqbhbSDP93xnStTDWEzwrE46kH1ujkqirUrrXx55lPX9c93DJ0A1CuqOilC+IuAJPDRjH7gmqU9
 XDefSNNdQiKrnwPrrWoLa5vvkxoHPSBCDH0A9EdWMgB5g6u/TnZoJwIUqhGj+b5Cm56klLEmUrg
 e1uRzWHIyJWuG+fBoYZoRRQCEJO/p7KR6hYxDOGSwbO8u7aivbnUZ2mlR9HB47FZ3xp6tx1NtxV
 m2xZe1My4P1PXhBtvULDFM1TduK60JubfPk53Do+RdcH1VvikPigQzvRiI4O58Ci0WAWRXV2WHY
 8Fnche7peLT+7PRnnXgEt45S1yMe/tWwue+Swz9U0D0Bv+5cMUW3d4OwDtuRLj3M+EerWNCmJtD
 s+AkC6XT8hDuOxOY8VahzDkAbvHm8ww25QHko5MxR/9QzCN6CkgrLP5xvIuFCayPosaRLqgSi1y
 zpN7ispIDHAClXSE/nV3ToFVEkLZ9as9/zD59WXs=
X-Rspamd-Server: rspam11
X-Stat-Signature: ouo7fibmoh69oqpwxtpztgzqd69pyjqi
X-Rspam-User: 
X-Rspamd-Queue-Id: 69AD340007
X-HE-Tag: 1769014638-827392
X-HE-Meta: U2FsdGVkX18TRYf6lxMo+6iQx6PCBQGTE6TP3qDWPNkqxi7O5QfZKI7ePC4zWyPoRRrTlq7DbPtu0yOsVdmzpFRV+2CIjnTk1lq1n1i6CP66d019VF1H2Vz7hm+3wgSZe1FZTuOcQW1sLwReWGBiGWm6YlVL/yoYkt6QRWIvES0hYIzmIJputjIX7Bv1Y8Y0RD7tyxqfF+Yw6YL0Y3fb/mCpOuhPwZHXPmLV9b0+KdZpMNNQDqKavP9hzGTfPXx/0D+NKBFeJ0KWXBUduRGfH/vlAWAzBqyjrRelKnWeYQ5eTYtNJAF/xgCHx/kXiUR2C8Swk5g+bdUN5d9OskiltWYcgz2Or+ASuA2lKXYHoW4rEdUGmnp68gDfMGokfiFITS349/4Z5//efeISageBUCFPcgrO2xlaKmEDnnBl6vEfvFj+ZWtXdlW9QKv3MbSFs9Ib3Llcsp1WwHYXmAWe6u/7iQYtLkjOS4HLvTBDVZJ7BKX9ELP5h035nSaD3MpnSM8GQ/16165E3EPqaeSO5L/65YJauvymuS8N0V+p2YJFxJC18V/CSOw9d/Hj7CvU87kArzEEeB+10PvEbdDfyu6Fbp2thFr3oO5e/2LPyx+aYVmM4iAN54GEkmNfa50FFUyPr9c847TQ6d3n0e0pEhhQ4QCGZ/difFaXjgzHCFbdFa41kZ6zYO7cfi8AnZvDlFB471Iobb7BGpd85VGZ48//MfVYM6I+CIDPvpwvq9KPuQ5Hmb5rSgORkhMldqX7a2w0h0zJ4sPVxp6O9sD9ZU8i56W5lf7XvXOnqMzXMkZ8MIMdQ+ms0di1TLtJ0HQM+LF00INXMXJuRr5OHaXwSvcf+Ruyiqe1Da931cwj+JLg2d4zK+TusJqTyIoIl+Cc7rdfFLheSL0JLdgtYnRQJ84xdcYUJ/uUX3tdI2tffveZNWSEGzpojtSbDFGbqjewSWq6hmUcq5TxYe1+kJg
 ltN4CTsk
 l4wKhZWH3lKkfF6kSfw5PvZsOdJQz81bHtEdWMHtej86XulU7zBmlmhVedd7ETYxExRcwiuw0mZn+B4v1/GZE7HDfCCQ1PdQiJL628wuwwWhsh+dKExOFpDoneC7Uw00DO/EPgd068o2OdLpdb1OEVpM4gL81lpUctecgBf15vC6mu5PvFtTh5OATIkkLWNYGuj9Skt+KMyr2SM/Wn7vFNxHGMucmoZEhVy61NHH0L8i9oMZ1PEynjTscS33GtiVA28l3zQM+D0ENrwWGA8a+hp+Dz4FQ2DW8FubUuEoR5FPUve6LAUU4W6uyXP7bDRxrTzhaIiPcn/9TNCmN/OfCYf3dck1VIh1L5//Vt9Sa9bJtDdnarfHfXf8mRL6cGTIc7piNmbh11XaQb/JNVZsvvBHgV7FCYVqR5hTozZuxlaSpRYc39I8jhhwps+SyWEYuCOooExd3V5qKp0vFfnXFn+rGz/ueZO/QkCQ+qdEp4IhKGf719PJBP4hWsESEC1Z/JrGjrX39Of5Cnq6XzkBx4xq9/R9bg3xBdazsg3XOI6oYpLaqTISVM6NO3BD+xJpnyfBeOO42BrwzXLl5hjNadjOqG78bCvB4XUBU/bWPYvFI3Cyox9edzRhN1j7G6QuwB0V32Fj75bSZbySM2X2gjbtJE5xM8dDyW3UUPSJ3KefencvtcHWMgSTM9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The end_piv will be needed in the next patch set and has not been set
correctly in this code path.  Correct the oversight before using it.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c5bb341da5e9d..caac936bd8d40 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3494,6 +3494,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	r_mas.index = r_mas.last;
 	mas_wr_walk_index(&r_wr_mas);
 	r_mas.last = r_mas.index = mas->last;
+	r_wr_mas.end_piv = r_wr_mas.r_max;
 
 	/* Set up left side. */
 	mas_wr_walk_index(wr_mas);
-- 
2.47.3


