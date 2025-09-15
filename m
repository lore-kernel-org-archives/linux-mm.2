Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79126CAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5AC68E0019; Mon, 15 Sep 2025 06:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B7D8E0001; Mon, 15 Sep 2025 06:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABEA8E0019; Mon, 15 Sep 2025 06:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A51808E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:49:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5158759007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:49:14 +0000 (UTC)
X-FDA: 83891162628.28.8D73244
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id DD158180010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:49:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L3sb2lrC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A9A00h30;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JdlwcJTVLf/Gb79Gy2qVXdcktzsP288vX0Gb+23gmU=;
	b=EDvq410E7XNe63b9XD3XYXZPr5Mhh8fjMK4rz88pD7TUE6ctPWvHl3XkVVSqd4iiyDZsTX
	oqt0sLhbVmS5IV6dVBiqFZGwSQgAyO3H0oD3oYlHr0t9sr2S4h3OcPba0LzfXwHKxzpoph
	eoDLXynWhsSCSbgp8G28E8ORVNG2jhU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757933351; a=rsa-sha256;
	cv=pass;
	b=g3OeAE9N4nhl+U+zkha5U7gYgYSnz6pkfs+KmLPWrHmVSQZnknIp2oIMCUxNRNoLDXGGpz
	v9HiV+PEMMysNVVUZtIvtXd5bW19UvBHRJKGhqpMp88bDVVNANo/xhvzKrCCxgn6cZAUnr
	pX+OVdgoxGm5aOYtTEq5VNMksqGSMq4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L3sb2lrC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A9A00h30;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6fwWt031833;
	Mon, 15 Sep 2025 10:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3JdlwcJTVLf/Gb79Gy
	2qVXdcktzsP288vX0Gb+23gmU=; b=L3sb2lrCJf0C5CoPg+ba+8qb/XbZnI8eG2
	cFs9VQZBXs48Z3ry9pB+n5lN9hTiRTuD/J4KdojvRNxWZgUjW3JbjW/DAEILCL4G
	M8tEkl2XfnbSlEQx/PKLWfetg4YGxm8ezK4Si+C/Yxeb51uzs6UN2OrtVAPLVj2k
	9oBnxedHTILzsDV0CxqhS8TipMSB5NgW4x7soLisKwbk+P9z3KF+ciKitZYdqkoB
	+qK8WdfTT4xBpM7bOkD+z9uKtXdBNx0AYnKFgAq2B4Kf4n4AinTOx4yYOowWI5C0
	jSYsjSfH9pi/a4zPjYOd8BciKDDPX6KpboF9Hl0eAVJ+g5mwxDFw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494y1fj3sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:48:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8Q0E7021391;
	Mon, 15 Sep 2025 10:48:51 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2audt2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:48:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VcwvR/7k9+y5HGtBvNOltudL+GgfoEfj1EwnPk+6JsEoA7xssdz37c780sE+fG4NmT0PgSnC05iKPaX9cLo5pWoYAiRxErgrSr80nENEVFJuWOd+lHLk1aLGsJTj3ojORwNT7Wql+LyHWz/wzLDdOHB+2bkifQ4zrQODOJWRTAKj3KF+OCZ+Qdt3TF8Im+fx73hsSjvDpR+G7YLQwQy3wrgTZ3+1k6Kk+ojP6BqZw5GR7HRGZK8aJ6p3pHTefYZyvdquyueh1jODUx/hV42YvWoHnHJBKhx46qzNw5QFqqSU/clDR2SAkz57jXxFl8WHO2HJmt7PSaWveEqEn+vbdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JdlwcJTVLf/Gb79Gy2qVXdcktzsP288vX0Gb+23gmU=;
 b=FY/jCO86X/5Ul1lHrpQAM7qGzvo+utz2uWVLNpY4lPRWdtv2f0LGRX8Z03fgZQstyuLE+JOs7T8ZMZYrbVmSbgK4WG1RdSzNgaV7V+0CqdypOrtECY7C9KMxtajyCNqE7dJukJm0QjkXauv8JzCDRZB/Sd+TYO0STr7lDwXOjrkOLhgWfYxisaffFvsuFWt4yDvXIQK/LCkoxjSrtOOCtHGdigXqjBRBbyLS1hoJD3iE7CHpprFkOCCcvdo7hfu6EPzXxCePHG82o5wFZ677iqTWP9TP9YO/3QzXpeE/LXntfj0+Ioz+hoFGYNpyLn3yilSPY4RVVdPqGwUDzewm5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JdlwcJTVLf/Gb79Gy2qVXdcktzsP288vX0Gb+23gmU=;
 b=A9A00h30KGNxNMSL6vOURp4hbGb0L91+EYHsXEfJ/cK28ux4TQxJz0QQTpgWyC3jEl2fcQZ1OnvQFhA5THuTG2+K82Yy4fwrm+uKgrALdIY9UCz9Wy2bAYhOU2vRSpY9dfY9/x1JViWCE96IO7ysY5WWcmpK2VWROFnQNlC4yHU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7189.namprd10.prod.outlook.com (2603:10b6:8:ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 10:48:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:48:48 +0000
Date: Mon, 15 Sep 2025 11:48:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
 <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
X-ClientProxiedBy: LO4P123CA0321.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: bc46aeaf-294a-491c-8847-08ddf445734a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hnDOv1+/y1HLkzlxu4PUbGULXFUc3qDxBZ741ITxTwcKwZwfcozo6iVNUUU1?=
 =?us-ascii?Q?Fk+c6/7pOQzHMTuJTL74wQiLKjcW7eu4uPXKHGyXqN3Vof7QGjTkCHwdOIjH?=
 =?us-ascii?Q?kS0ZWoSSFi1s8Z18AswSL7W2DxiBTK573wPKJmvHeJS+EMa8hsq117MmfFCZ?=
 =?us-ascii?Q?jYqbDWbCgS7sqaEkzzROGkR1zYS8CUKdxIp9kxb2uybYnb0OZn2y+/IpEOKF?=
 =?us-ascii?Q?DyUkMDA5LJt7S0n+o2+s1yWPRPXrVZlkKmyRWuzxlYjQ2PCup0Vo1k3BA9Js?=
 =?us-ascii?Q?SQygakKb10chP840ZROKxFY53g+zPz0ucrD4MenWjMPecbq+eKEtkMTVm3B7?=
 =?us-ascii?Q?Y0pXmiK31G3wdjZvXCgEmIoyLbNTFBshfpnZR/HUlbPXY14flas4UzOBCIv/?=
 =?us-ascii?Q?I2QcS9ggPvq1m5mqJOXvWpvkbfOxcwOD1AQ+ZaGnbtBkIWIXkTJ8NAuUp4iP?=
 =?us-ascii?Q?BXzIMkNtOObOXOCh3iBljR0MoTJh53VwOJu3usZZbGb8fXRG2McTt6Rnz8+s?=
 =?us-ascii?Q?DfALyNniJk3nS9PS6T7rod/wVADUWKV3Qfb66gEBSEHteFqiVufY8PWP70KK?=
 =?us-ascii?Q?fQnNOq/7UvNRS7jZ34tJ4jtm/u5lpPY1u6y7FWAldqbO2wd0tFLwatAEUBGK?=
 =?us-ascii?Q?ZlIu+/LtJKhbqDQlKtXazRu40kKRRd81dox1L210jNFXKObnNKZH6y7XOtwE?=
 =?us-ascii?Q?DIcvNLraX+heuDfLiP7rcuF4kGStliildy9NlJXmXty7wWkobIvY1ipz8IdM?=
 =?us-ascii?Q?p8gbd6zB5vBsU8A8nbxTeFMPjPs4LQw/vDhqTL7oEoaUbtqZK79iaCfsWtGT?=
 =?us-ascii?Q?hs+OWFR41rIndzZbvrENTN54b3lk45Jbr1Do0l44wzoNEkLpDyr4k/Lv8otX?=
 =?us-ascii?Q?ehGKtdLXdEJ/ysCXhkd/80NbVn7w8uU87xDFWrxNyb/C0O60+qtlP+RMLaSC?=
 =?us-ascii?Q?++9nD+2OZxIqB0oTPBlWVuTTDxOk9SF/1NwEFNFEepJTD4O6rjplRD5GSTCa?=
 =?us-ascii?Q?/3IXJPXhejqubhRRM7XqWF9roPpgdamxw1GcLtI9ekPfgq9yQB/gElnIdiPv?=
 =?us-ascii?Q?cx2sLsjKTaXdeDwSQbovzJv1ECdoBCKFgcP9E83ZS6fQQzVwuQRu/Yg89mS4?=
 =?us-ascii?Q?7Q/dC2Ug0EgYTHctdHXUnVdwSHb/iuGkanO95D/5Gjjt1HKURP5wlh5q+caS?=
 =?us-ascii?Q?A47LH1pbwirkr4shPNQZNgn5GV5hJ3jAlY9n87m/uWIPuxKwmxiCtlvJDoSY?=
 =?us-ascii?Q?C4Qk1YsRQTScIcwVtb+we9LzHNEFe9Q6z2sfxhEFDBY5bcIyis6mYqoRGpyX?=
 =?us-ascii?Q?WULumZJmoB34TeWYdWXIAx5/hCdZeZCjjs5PQH5l9QpXz8rpjZ3Re0mbbnjR?=
 =?us-ascii?Q?Hs0y6XctGs3LRv+PE1vT4yoSVwt8Yq8QDOAUDt1wpDbfhBUuB1BtMwcDD8eQ?=
 =?us-ascii?Q?tgVPRcJb/sk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rFoXvNL0v3kJRDbZp8af70wCZk0hmuCrEzMCmH105CFl4Ir12V+9/SWxmijE?=
 =?us-ascii?Q?1/q9AMeT0BDBBE+t7dB0525YAgNLPgYJ4Y2fMPiT8wSN+ZdOg7NY2wvDesjt?=
 =?us-ascii?Q?s+k3Fz1V1TJqDimLpeDPfzIDH4+1NMdN5oiEzRdXiHLU8CTvhNoZAKh6rwwb?=
 =?us-ascii?Q?EzUYjDylSqQfUXWpFtF7FbhIVnJD+1FlRmrHm+OmwfVqo2kvHbW5i+DHRvVq?=
 =?us-ascii?Q?fBUk4266KKMHbZVpSnTdd3CqICzbFHO49hUzYY9JV46VqMByk7dAc8b4t+To?=
 =?us-ascii?Q?1HYMEL+UtAYGh/UilhN8dTIYqjPWTNUCS1tGBtXinH2bSisLQd2TQfPChXGS?=
 =?us-ascii?Q?4aYILOrfx8+NiiNiz7Dcjs3Ad0PYxieRPujbJcxsi3DqOcu5o9rLFi66hZSn?=
 =?us-ascii?Q?THywaMXus8CKwDcNeuS+MOAt/KohjZCy+CCPmlXWdb+3BoXipdz0Kc8hMFlk?=
 =?us-ascii?Q?QAnMo7iZ9oTdXNSB+/kzuPjFvUucMn4hihWTjWjJlvxxMyFcdVm0BMHwKFpb?=
 =?us-ascii?Q?E7uAy/Tt4Gq49B+SZH+fGOHvQqfE4hrxsASNCa/4hYuWeSxkvkbtgk206tfX?=
 =?us-ascii?Q?8V3CbomANCH8RQDZ+f3S4q7iJMe5MxGIIPyebiL0Ne1hDjr0aS135eqQDQFG?=
 =?us-ascii?Q?t+OoGKWvbiefS3TMFenJJCOXRYf2Oje2E6Rh0c1w7hjX0UwrifxDH5Sz3t3K?=
 =?us-ascii?Q?hPlaZpJA8tUWRe64dbA7JYylf2nWhz40Q7rcJRto0PkgcGLoWiSymdIANHEC?=
 =?us-ascii?Q?SBKWIAdKZ4vsAsPJTdJXjwkaajwHxbCbnrss6xM8Lyw/WHctRQETsL7BgP0f?=
 =?us-ascii?Q?D4JScK9vPkn2P95/Yya2W0CwXFV7qgUgb7cq86Ox3dm5AEirIKozJHkbZ4Zo?=
 =?us-ascii?Q?X1OabbNstOu9S3oXoMKYuZfUUjk5C7EM8af6EQ5D+t/pPC16mG6Ygu39ma9C?=
 =?us-ascii?Q?eqjmIq4ySwwWH3sduxw8V7dFoF4ZXHCLOen4p2eLoYPzBOVoAV2Xg9UM3kBq?=
 =?us-ascii?Q?cjGeX//A/TD7dzcQeqgy0npKN3KdnY8dlBWNd03umsq2Z9hlbMe2naVcgh/Q?=
 =?us-ascii?Q?lsCANJvPjJOsjNgIRghDVJrhdmJggAr2S5p3Df3xmDXbvbiWZELLpSzzJXei?=
 =?us-ascii?Q?eqD9EzyT3J0Ungh0C7hdrPgMlI8J01NVlrUxsC2mDCAY4p7nL0xevOx3QfFF?=
 =?us-ascii?Q?X2yOldjbGSjwKvKkHki309NmdDKuwhalZyvNyvnhxk1aup1KkUvcwEgUXN6L?=
 =?us-ascii?Q?zAdR8IFtkZFt29vTE1LOD2zjvVXooeQnvk7mtwdQh+mGlLepiU7EFkg0UthV?=
 =?us-ascii?Q?K4WpUgBljuBbPeKy8qJaMa7dYHEnvExALXB9Kd6t25FPOqUR24gWTBF4Zpoe?=
 =?us-ascii?Q?P5GfXFUTSc8smvRhoLtTMOZtK7fle5jGQZX6QzcAKjuz5ulQRF6TIErLi9AJ?=
 =?us-ascii?Q?eDzM7Dhb9zDuUos+JV2DE9TT6WESdA1xdjpFKDfhamDAqbSBMJyMqEJSjnXp?=
 =?us-ascii?Q?kfB8U7MZaQ31DKjlFIJkRtpldYy+YbM/napSfv+h0/xTDVRTQx82Ovk0Qhb6?=
 =?us-ascii?Q?3CnfjmFQ1uZz23vf78WZTWcu/NRTjDdbEbL8jsq6GdTwLjf/8V6IDQT0/01F?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R07cLABR40gmc9LMhpiERhNY75J1INVgBasH3ihZ0IucI7qcBmf4bY8qQsoytu/SaG+3gxjfKUDEmA5zsc6f3lURlPVTDiqjmyKVbU6J1l6SDUFXFEMReb1Qg8XGd6GGy/OkiK89mxU4TFDEMHL18MfqkSC2XqLP8XCMpvwzNQATOBqpTm7k1eZJoOqwv0Rh/cqUBo8Vg3VZ4TfceOE37Fb/RGgMOKEXKgBtyD91MorPzkEvU+poMdnwc7i21s0GsxT0ZqoyeqkgHx6BUQ4dkIMPCqS642yF/E6mCsjl290bPnp/kT/280+HZ2aoK+sIIgJfgMMZqjuDwA4fHlxPHF7EjCEfwIcdTFhNOXsZ5ewDWMnzitjw0h18sAbCnmu7Q15mi0fe3GiKRz4qUvFG65TgBxqsOeCeWd/kpV0t7eCDW9QLECdW814yyYr9o/f9IdJrpfT+d2X9Hl28UvtM8D2kg6mDs7VOXBRNEDKiBNC/ueSXYHdPAvceWT3giOW6I4BeSjXKcKAGfYV14cLrhlWbQXWIEyH4bNsMc0725F6/tnVWwN2qWd0UyzZtd+Rd5rnTc8K7VtnS09++hLGyX3H9MtUzlu80FBQgThx+VQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc46aeaf-294a-491c-8847-08ddf445734a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:48:48.1402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kPxBmKUBL2Zd85h6bl68gdpqg7dYSK8vGEmeE0cOcS3dSUGxU/BcY4c6MhR1Qa5V6wrjNx8CpSbpOJdGGgaa3XbkatwIkhJhgNSyrEki1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=941 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150101
X-Proofpoint-ORIG-GUID: VsKdP2tRatEg62yyTWZNHVPxZnE015fo
X-Authority-Analysis: v=2.4 cv=KNpaDEFo c=1 sm=1 tr=0 ts=68c7ef15 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=LBFiYQ4NoQVWK8ZG8pEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: VsKdP2tRatEg62yyTWZNHVPxZnE015fo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMiBTYWx0ZWRfX9xt11h4pu0e4
 +XRWuvJfPk1rLjyqXyC8OMPafJ1zI7hZrd6fGs138Al2QiSW1IjP6RpSZK2Vt0j2V7TSQ30lji5
 jNmXhEO6dx+sEo1O63xQkA7zKJnqTKVjnpSvVF1stpNwrLnr2aUDKehv72+CAPGz3FdFip/VSlN
 xPwrdPDFZp9li1bjOrpQZSa/QBNZ5H+/uz3LDd51mQQVess6QPKoWQugI0eyGW7fMI+t3P+eQmj
 yaMpDXPNXioSAVPL9zeCTU057ndGzFEZpRarA98tYSnTXLWSHCWMO3TQOP3RaOCjMY8Vn/wqoqU
 2pcFqCK5pYuWx/MiGQ5bvgDtzhjnueKX70ACGPx7pOD5KoP8FoKAcpLprilWKX01Z1rWrLsgE85
 Ad590U5r
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD158180010
X-Stat-Signature: jhn4z8jqiczhynszjt87nxo6ycwbcx9q
X-Rspam-User: 
X-HE-Tag: 1757933350-350485
X-HE-Meta: U2FsdGVkX1+L0Ts4uZd14+HOpO2uEBcnYfjC9q+FQL5avme/QT073rxaq21LYqeuwSwbPy1BE6Srhi1MTgfzjQDVkx4OUYJfKSgdfs9AWWKYHnmmyAr3Av6DfqxLbpPAe27nu1lDIIcb+Ta8n3jC4j6y88/YhVxF77fkwDaf0D0nmS7rvk+i4Z4pkbMbzuqQ/krrlktFUtuYNNtufqTrwiYzKNn85ercmZGd495FrFUHRHqRNMFwrGLWjHOpCa4UM1gseCp8SWYIZ3NGm8ShUb/DcWDYZ5Q8H3B9PHzv5WupD48hfOmSI3poKpOxGq+3mO4KxQh73si//N7VJgHaD2K281JWTJOy4XAsgqmdLVY2AO4hUvbKJ+UDiHXcUdzTQzOKW10tU819ugkcFSLdwQ/ZfwHyhaVE8I5BZBZAN5W6j0VC6FfQaF1bGsK3J5N2R/be9JcCVAH8ldwAmHE2xdj+6pD7vJCgoYGiJxca3sxSUyTCnXg2+qsGEFEOLSLPZatBC5H1/syxbpYv1js6LNzPd6xw1SKX/l+n6XPMLEyynHu/SxQ8ZRaCBktHb3Dr/rNVXAbNQJaXR0ZOfiMPbPGUVukTFeysOqnpFZHy6F3uXcoy6imR86AJTcKqG1Tpyme85rdd+GVTwz3jEwWHbupNdb216DeGDLA83nBGexiEndrKaKN5rc5xtxQkmxXG2E4f5Q/OzzuuKNEbs70rx9kbjwazQnGfBksdZUCL5HuSzBfsljcWDznk0CQiwjl/xZkyedZPKGUAeUjw2oln4R0l2/I8l9TWCpEav9OgRSCSM8XC0zxF95A/0PiwEvwvJRnV+zNq6e8jG1yaH/oal/LP6KpiJ/Bgy1QNysoEcnOcFEApt+HgcgfwOopqJsnPalzmGFaYlJwFLaa3TcMSQLPwoo9UXqiieLhnP7Mm9w0eUQ5LEcfwYjbfqlhi6eQ3Sx+4bXwNedQ2Yfezn67
 wPqkfxkM
 km39nZkmimCu1M+XgS77BMYRwHfWkJgpnBoM5ybVCJUmoF3Kb4IzmZajZ0LsopnQLrCSMr/fwORfYSMtSp0JlP9nARH0MqrB6TidZGfn5RB4c3oebwDtKxNeXlxf4xTfQfb89Coxfw6gnIuFEc9PafDNiqN5YE2XggpZR1f6Aae77uQiJ85SHNNm/ZrJ5/ASolaXX2vS6/SLam0xZjJVeYiCz/UoF5ndilM7pvtPpiRQxlCNrIHxf/PMNlkWXCmrFMM6b2kUhmgMqY3SCGdqvYYjnbq/JUUaPPBIeQuDJxHs1QvKLbmmMopYQWXslXDzziVa5LNiB1JEuyTPNMql2oDKuHmSjw+QwyOe/n7hTJQZ88nWKYpdvbxheAHwEwnZ1dz3VjMcghDwbwKQTUEf6eyqM9lXj52NXvPSujJrtDlVJutnhXiI+6Q1Whnewr+1pSy6IkOov6GjuLWdjN04nlarB7Om686lJIj98bxofG01gITvt1AHv9TD+BYN8wwaA5OSA1kedgYhRW7eJLrBv/TsIwDu++eHN86gI6Kz4o9fxpJtFeOJ8u6z34ZM0TNCoiZDm3Gv3Eq7b61mm2pjkC2DoL2dlIvzQW1vJcDPzXDo1VRcya3UQUsp7nJjc4bsVEcEBMMwLuT02lxWATjtVV0cLfEuPJY/9yIGbDeeW6b0Rz4CK6ne91Fxw5gp3NLOHix3zlTN7Cq36/FBlA5v1aeNSI0jk2SSittIwtOYW9QrBlvWEkYorPCrXJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:44:34PM +0200, David Hildenbrand wrote:
> > > > Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
> > >
> > > And at different mTHP levels too right?
> > >
> >
> > Another point here, since we have to keep:
> >
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
> >
> > Around, and users will try to set values there, presumably we will now add:
> >
> > /sys/kernel/mm/transparent_hugepage/khugepaged/eagerness
> >
> > How will we map <-> the two tunables?
>
> Well, the easy case if someone updates eagerness, then we simply et it to
> whatever magic value we compute and document.
>
> The other direction is more problematic, likely we'll simply warn and do
> something reasonable (map it to whatever eagerness scale is closest or
> simply indicate it as "-1" -- user intervened or sth like that)

I don't love the idea of a -1 situation, as that's going to create some
confusion.

I'd really rather we just say out and out 'the kernel decides this based on
eagerness'.

So either warn or have some method to reverse-engineer what the closest value
might be.

Or perhaps just accept 0/511 there and map to eagerness min/max + if non-0/511
warn?

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

