Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3434CCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1CB8E0018; Mon,  8 Sep 2025 10:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899608E0007; Mon,  8 Sep 2025 10:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788318E0018; Mon,  8 Sep 2025 10:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67F968E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:38:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F7111A0186
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:38:29 +0000 (UTC)
X-FDA: 83866338738.16.169C394
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91463140010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:38:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="GLC/z13M";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qC3rzBs9;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757342305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zdbs8VtoT8Cnt3EmDwXE3QRzhl6R1dU4fNHgdHQDGs=;
	b=aZ/q07rDy3qfBDWODsoZyVL4wG7JcN8yczerJMgMLIy6ug8er5yFWk08SXrRES5Zh3bHrh
	9FLOB1BVLHcHW8DTDyVPY/2yz5CErgu6B9aLl2koICwgF3ObYdUGDsfLHdbJ3Nx3o+st70
	6VyJKpXjZszntYIaxPpnTS9gxKA947s=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="GLC/z13M";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qC3rzBs9;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757342305; a=rsa-sha256;
	cv=pass;
	b=z1q8YNQW9hkr0aPcbKhvI7HER1jEZGl+7qMugRYofrfHPu9SYL4kGUeR1op3eBrTk+b5o+
	HhzUxNLzsxucocO0z3/jCRnaFwvVESf1VY9t7UMpbFPjdwo0uc4Ol/9UBBxla3rqBBQshY
	qV5SHhj0p9gBw2ZO2Tz4qSXp5Jo5u58=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588EJAmU000627;
	Mon, 8 Sep 2025 14:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6zdbs8VtoT8Cnt3EmD
	wXE3QRzhl6R1dU4fNHgdHQDGs=; b=GLC/z13M/JCx1blp75glIuDcNBultqiNiS
	NO5cAlJQuwVyy3/kQ1yMt7Lq/aPBH+AygEHSvF7kT1l2K4E2AaXRpizWGpEs2feP
	1MAlUgvrMvjAg4j2mnuWtO1UUj+diHRn4crGIOLQqP406tnKWp8mE86CqMviClko
	oW92lHAEqXUlZa5lzukKS9ndFKCJ++kl8Bpz4j14Om7mpsTlAWhLi5kkGP9l8yku
	MwAs79VtoDTMnQxfDAJRqgEglf6OX+fnScMsrKNKlv1CtmQejQXxg5Q5R+yyHTFQ
	gjMwSJW+O+AXowhgTL+K0dKUg+912xi6SclERXUikqsHAa744yIA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4920swg1eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 14:38:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588DciPH030639;
	Mon, 8 Sep 2025 14:38:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd895hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 14:38:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewMcGBvZESisiKAmNvFuO84vuJOeOyRDxB0NtrdtduINEMp2xrfudxgqw+8aRaPK+Cxxp+qGJoCx7loWW6UgVhGMiOeYi0yR/bpCAIJ6kdL8Ak6sHFumBHqhkhBLzYXUUJKvRcO6mFMcJpH3KMa1qaTuJvpVG2dxhQLnQU4L+GH0Gq40Np+AphTiZy7WQMLbHwZ4wHHgtn1aOt4DvlNiFPuTunukB3PKHLhGn5ttozUBZQhewBUeEKdtb+QIOYrmf/JpiRT/BGilEIV21bl4ik+MRLIPlPlWHW8N+3xqI0Mngsqz6VU5N6Cs66ovYIggBr1gc1XD1ksuFpC7PiyHJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zdbs8VtoT8Cnt3EmDwXE3QRzhl6R1dU4fNHgdHQDGs=;
 b=nbASw3gjTTp4hcYBBgFIQuLjDYcyELyqVt6tKq7DmOD1eo0iZtJi7LriGXhwuridxHmwwQK5AxdqPeVoc1f+iWLt0MJ0e58Md+SPWOMQS4ienoUJfwBw8XHUwCQAGZqvR9bsf7zuNGITlWWHF1bCWxbhiJ0HIBij75KNZQoFB9oXg5mFaRD4b/EqM2Fg62X4Cylf1klGHXlNn9wg9gSgdyQIs0W4sQTF9WhfwJevlt5oHnhao7f/oG8zl0GKgsWMEGio8xeRmthl4oNqBIJnqJE380RRTtCtmLitglcuRdguLtC9W2pZO1bKUJSiJJcweUGmFeO5w0qgyiL1EkaWiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zdbs8VtoT8Cnt3EmDwXE3QRzhl6R1dU4fNHgdHQDGs=;
 b=qC3rzBs9LH7BuO4wt/nS90Z1j+DtuVZeVsZ5LdpRvW7K1ffVXZWg+O8aOT8OjlObc467cTGRjZDITV6xPquFS/U8qRk9ufjUzOHrzfUOyWpceXp1e+q6Il+30zLYYxwwCmGY3GDPPN+SvGmfFTr5iJP7bP9RjfDHNYJTwlTpMoc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB7469.namprd10.prod.outlook.com (2603:10b6:208:446::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 14:38:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 14:38:10 +0000
Date: Mon, 8 Sep 2025 15:38:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] mm/rmap: make num_children and num_active_vmas
 update in internally
Message-ID: <adf8d523-d7cf-4484-905a-2000741a58e7@lucifer.local>
References: <20250908140505.26237-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908140505.26237-1-yajun.deng@linux.dev>
X-ClientProxiedBy: LO4P123CA0431.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: b81b7c6f-8cc8-4b21-6e52-08ddeee55551
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C0jo7OD6N80bLGe5hqdbQAoaIL8tEe4zt34iJiApi1tLMRZOR2a1O6VgTC1/?=
 =?us-ascii?Q?XUhQZwAY5pXZ51zcAMaSBLQ2MgN69VfKZrALdei/GepeUL/KxYcC/a4lOFwK?=
 =?us-ascii?Q?ipBRXU4woctofsi6dD1Fh63DEPMn9tuesmwjFt/WD7xfHeFs9oRe7gZOAdXY?=
 =?us-ascii?Q?xbp1Gxd0AZ2yvUVfsdAv135D5dOcEeZ0nBqRBaIbtSWjQLpUrqR+Ls9EwPR9?=
 =?us-ascii?Q?3SQgrlIf06PRyPrdYMnVHYoILORDXCmprsNvbQ+4huZ03TksUQ7nLbl15jaX?=
 =?us-ascii?Q?Zf1CWGsmwOJC8jAezXor9KrDFNCnI9IjPNdsyt7dA/8FI/p+aGNvvKggYEU8?=
 =?us-ascii?Q?zNqJUyzHrsOamVa4u88qMf9AXWoKpb1SO26pnd1+QftGASEyuxYAR1sWo89M?=
 =?us-ascii?Q?5OqsnLBYQXW1Vo2sMhuvsgB4yauFes88ffHEJaesK3/8tjHsKetUB9UPAQaj?=
 =?us-ascii?Q?VqApY3hKsSuWTRz5TRG3VZgDg+f87213VxqBGynwFOFtlH1y9gcoHzla62Dn?=
 =?us-ascii?Q?/BvO6u7tzdwkTorJhG86aXtYdfT8FKG5jmKIcRhlZlylGjKiz2o5iLrMsN76?=
 =?us-ascii?Q?CsNHo83qVA2sgpiGz/I9PnEVHQ06O9OtQP2Q65rMGH0eOpzB5Z6hhqoKTPy/?=
 =?us-ascii?Q?tYeaGIXpvwjNAbpic+nrLR+lkThYV3UuxEsTKmneBMsF54UtVsvK/I/yFkNG?=
 =?us-ascii?Q?PKN3xUdKwrJwflaegOUNFUEBu/U7N6etdAbHex6Dl/onA4fnJrvF8ztRJvT3?=
 =?us-ascii?Q?RWLgbnubpN3geVRC+BV9V6bwf/QaS/wi6nGQbaFNUBului3CKsSEFTUIWwTd?=
 =?us-ascii?Q?Ufgea+aeP3rtnYh2M8i+YSqtDGndamRIV7si31fImdjyWhmRPztrtqRbx7WH?=
 =?us-ascii?Q?6CbiUTMUj4udDwqIGdVFPAaQM7ysTfh4zuXHvrRbmbLkwiye/Nw90K/eg2cr?=
 =?us-ascii?Q?mOYH1FfaHG+hzNHiXyZ7l/fxn+QnyRY1Vut+nfTgyXEo/0EV4ltYG3Z6CF8h?=
 =?us-ascii?Q?a1s812OVR0RVfkiJOtyZPybOk/jVOqmgoGOvkdOgIgIfilsIuWTERnXUUi1A?=
 =?us-ascii?Q?EF0FdEY9FFw8Tw1YfqncTplywJ7HXrnsS0Y+flcridZU7tUhSZiWJ0Aax2P5?=
 =?us-ascii?Q?vmfHbztzxrjXW5jKjVtwbGaE234bNa6cOe5LQtjt8f1OD3SsP0YJVN51PUK5?=
 =?us-ascii?Q?NY/xfHFABeD6bjyaa2Vy84LKhvB781X4biq7rdNp4ViD2ObazfTux8LDdFLS?=
 =?us-ascii?Q?vfNZfMSxYBk5xTYvWBbXo3vRn/0jlHDh70WcAdHs8jdOEi5st75uLs7OsoEG?=
 =?us-ascii?Q?/l6m1fO5DuM9ar4ToqBDW3OE4c4vD4DW6CbpnIuPZXFdYKQYy4iBVPgQDG0W?=
 =?us-ascii?Q?XcE6bmoiVQN9ojfzAfzg6vtnjRZ+JeMRQnv4id5e97MgOaTbRchXzLvoiLlR?=
 =?us-ascii?Q?UPstEtLGAEw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0ZCkfg8baNjN0R4zc4sCE8k1t7pLPISqdYEsRsQilOQLfBzme7W5gUu2Fc5k?=
 =?us-ascii?Q?S/MAMQMN3kwSOsT/AN/Ic2KqcX0Sm9cqTNd8Kq7R2+yNOJc0BvepGEnjZc9p?=
 =?us-ascii?Q?dyQ4ewmg9w+zilO4WCPd3UaV4aWnsGACqZG7KwM6LyK2NRw9xVYSC5B/XUA1?=
 =?us-ascii?Q?WIg59oFjM5ANw2xgZhHlgapdPZef2iXrb6rjls9h2ShK7KzDv6wrZOyN6b2j?=
 =?us-ascii?Q?JOnUobH4fGgFnzt8pvWuP0c6JEC9KaDU17D3Z2G13znvho438ImyHLhvVc4q?=
 =?us-ascii?Q?Sqzotd2GqzaLQYefYAu49vfLfQHomfvkpgQ5hymsegnlKDv1BXnjK3t16oIv?=
 =?us-ascii?Q?AZFbe6ldVAki3QhrDRa1aHCNEHrsmX7qyQmiWPEWKgx1rcHN0sRwB4QAb1dx?=
 =?us-ascii?Q?dPkzyi1Dx5fRHANWIUE+Rm30dDDcDMKkDD5crD9YR9/MLzY7rU65Yk0j5X6x?=
 =?us-ascii?Q?Wyb1NC6h4ZK++dEZXXpipuaIYxNsJ14lMHK4wt+BESpQm53NdB/IKPgesiwh?=
 =?us-ascii?Q?7pYZy+6lnEGRqH/r+LwFI0WXXUrKvEEcWiRl4KSCoeiB64Q3b0arXl9vv4/l?=
 =?us-ascii?Q?FLg5G3TJx1pyQ9Bqn5Maaswl/UQEG7rsc1m6L9QMMLkwBpJXA4SXi7YTkMkd?=
 =?us-ascii?Q?J07KoMC4TMsQ1wH07koB5ajFwycwiG0AT/oeEwb33r7jpjPxye0uxJJLAYwx?=
 =?us-ascii?Q?rJNUi7Hq+vLTUUYbNkg8mQ9s5A7zQ8F40onKuPtAJZA09/Ob7Q/w1ndBTGGx?=
 =?us-ascii?Q?m4IJIsjlAZpJRn/2ItUx/z272OeUdcT+PCLh/ivFOjqnmkXHA67A1x6Joxt+?=
 =?us-ascii?Q?Kpxm+ncVzdug8O3d5JlOnCC6XCs7ShMWrlO7FLxjYXWJZxNhj9yRgjtYa21N?=
 =?us-ascii?Q?Dvjh3RZQcimbKV6AFnO79VqUWaH4B3WugvcgB9iV2bDE4tWzqkXN9pgY7IUk?=
 =?us-ascii?Q?8EO68zNOQ9Mp+9HV41Wo2aMP3RoqtGXhYV1/d77CYt089MYxUhKyFBNPwqti?=
 =?us-ascii?Q?76qW5zqgPmLxkKe4WOjtvz2fyymrcAyodcs02TQfxX6YJk201akHHZjSXars?=
 =?us-ascii?Q?NhClQ7WMOHqSTfn/M5i4ECdPRXlennqTZvWpYA3tvTAJjhPFSEQrEYcdXmk8?=
 =?us-ascii?Q?uNcmnQ9vyE+R2KaGkMhcisByNjsy7UEgm8T7NQ3Hm8WUZxcsr/taEovwWfHn?=
 =?us-ascii?Q?5NM9psf2j61N3uF89yKbWazPo8DsIOGFpjSn8VSHlHIkaXiGsMnJYq03OZ7r?=
 =?us-ascii?Q?XBkNgLtjoBn5Rkm7PblbFHyXuRTU3XQK4y59FcK/hQotzxSKZf/sju6ZrYEd?=
 =?us-ascii?Q?Z3ppOxNT7H4bPfxyc0wH5HyyXDcpYBXRot825OZdnisCKA5qfNMo6xG0eJQK?=
 =?us-ascii?Q?vBsQk9blpEbzmgbCKDsQVZac8QZk28HlVZtr0+MzZgQDxdIuVItNwhsO+oVk?=
 =?us-ascii?Q?+fnr0zY/Ts01B2G7TX7xtfKYwAMdKR6yhdHxLAe8Nq+l6dazN7m1JMW7Qo4H?=
 =?us-ascii?Q?2J0BmPs/jHMq0y4aZVlymxt7fF3bxa9beGc9+Qq9bsfGTeZA40LnDZ2gYrpn?=
 =?us-ascii?Q?cFSjjGTYFeJjpIzHG2BhB9Vi55dH7DMs3Ya3l9gKfTxJP2b6xkk4pCE716n8?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ANUiDwk+ZIbtIw85QYM/atRfQH2erNbbO6oE8wgO5j1fuNwP3harAJiU8aZ7uQ921YvCQ9ixMKEnYB7sxNlAAVMorL74LqEyV2j4lIxj0rMBYMhXAQSbEE7h9o5ss5KXJciyhMb7PPGFGU+z9CcBOzJJiSf559gfX8GcTZqaiLNG6a5RlfM7O9xlCwfgVDZwehqZ0AHKHV27Mz03kQOBp6UgUooxxMG+U6u5bt/O99zGUldHDuCh0ogOqLUGF3ajiefLNvYXGuh6wEQmDSoBVWGpxHNaXvLBssaUZYV8E8maND2VaWbyBOiwW1a8yu/BEItw9JL5YDKHRQ7zIwT1NlF+tz3tgrsHexZg/ErV5g0EF87JNJ7Jx4YX+vBBH34YcLu7k2vZQk5WAImPrh3SZxxl9T+NqxdszthjvJEUqKBNJ4ZpMymIv5ObHosrOcAN5fNpBg9K1OBmWpdzfn9uPe5mmKlR7Y7WrWnQd0M3Jpoq5I28iQQ0Rud4AM1SSSmNDk6cdSN6wlD7MNxie3tO40sUOTLtA6P28u9F47e9kioBTLBVpvgpD1v5h1a8dxN5+weOCyL49LoPGEmKvj7NC6mWP8uNo6XGF/dGX9Ql90U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81b7c6f-8cc8-4b21-6e52-08ddeee55551
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 14:38:10.3521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWJjNCP0lgdbio7UC032H6VfVNmtMeETlFYfdZmGqQbADyA4hX+QQeELK+7Q+InejLrf9RFPDMgTIbOIGnjT2ZVu5+bi0ulP06B3/7RPNpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7469
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_05,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=602 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509080147
X-Proofpoint-ORIG-GUID: aVcnPnJOqSGIByR63jApD_wL589ogg7k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE0MyBTYWx0ZWRfXzAX7QHLcgHVZ
 deJ1wMqJF1iLoOBvEjr5SpO92TDoxr/r4uHc5dURF9ppUn1ufaWrikxxfSwiFZBsI5S2xTdoXtr
 G9ht7SbY0nG0iXzts9OB5fUi2sc8OQm1GHLZZfN3q0Koxx6f4K8+aSIKuQXbnIv3bJlYQs8nbB3
 CdIqBpU9uSWS58v9KgvZauMj+BXk2c9qpv/BnIwfX8qJ0Bz2t9t22iH8rPQv2NCAjRrmBEoQoK5
 hREBoBfv/M4SCQLo7NFIiZabg7zFZ447PXDEMQwsPSThbWuixNm3ySl2DMmPmQ+CtP1b1MCypT5
 wRapdBmagJfazf14byMnJWOAZiJqFXjberaDkUO/mfBAmQUkRAefJxSxaa/1qeCMDVHCd5QpeBl
 D+3cZYjZ
X-Authority-Analysis: v=2.4 cv=B7i50PtM c=1 sm=1 tr=0 ts=68beea5c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=rGqpgs7pQxE1GhH1U3wA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: aVcnPnJOqSGIByR63jApD_wL589ogg7k
X-Rspamd-Queue-Id: 91463140010
X-Rspam-User: 
X-Stat-Signature: ya36mxwyq716hkhidgia51ods7pbpwdm
X-Rspamd-Server: rspam09
X-HE-Tag: 1757342305-621318
X-HE-Meta: U2FsdGVkX18Lf2ijC1jnu90jbbsc1daoW+8CZQWCNPu+5IyHiuTgJ2+TUNRt3zt7KAgR2LygsqMB4+TBBINHAcOI0CwS/9V29SY9TOsIVJ34C2yP2IyS9ik4uwFMUDo9DGKS9SuWL6ygJNjorFIkq/y5RbSAprTs2hE1JmANQINEyD1HcE9ItMz22MkhZD+94kEjc0CFgJTh76M5XR5ZK1Fru7WSUCc6GFKiUK7QFJzjcHwcbd+8uW4s/TckwoWK8uG7tNnAqIUVn+Cvs1XTYkOqDhcPR4CDR5rQOxZYLrIpqoX1zKAyMzH9hmxJljEpyFMn3QKSmAt7mT6pmrrhdOl5KRWKpGVUyuuJIZfhSercIox+zVD1ZEHkzlxSubPbmbrdLrVsWslc9nChwtnAnu5qCbUENAJFdSJ/XUfN56Y3y3f8sLrUf0ZJYZi4CcjJhumX583qKZbLT+GYqKX2nO5ON93RDlveQgKKwQsOxB3LbkI/PbDNV3nhNj1333gQ6KhSD2pyi8jNjToOsL+G/2vrcYrF2Yae9j6NgN0AtEIOTUom3iiAVQcnB/gcTqa0zaf5/M7luqsKBpBrPWMVOvZyD1Baz6qewy1PCbtOKF/CXnCY6jgb/OZej9q0RAyI9Mp5ysYCRfMA3OZqCeHIqyyBC14MBA0pp+4KACRLyWwuNqdCTa1uBL7QCrZSOAqmeZ8yKfo9d4bSY1lcXkdnM2HOLxjBqFYNTEkdRF3vKpsWy59flTnL0UhfkzShPoJD9GsEfh8ruSA0iI1icrOcumX/JjPUhdtE7Pa2x2v2I5uJD758kgg28j20g9OUqRd+YmBKnktYZBtuXSJnYYA+xzy3i534eXl8u5O2F2go6CO5DjWNM+a43TmdfaZPLxQNRBHbsYuroV4i4QbYNQsit69ewPFHce1u/w0uYqMSbuakkdR1euyxUpELPydfYuk2SYwhijMstfCoPg2WA8J
 JYTJq3O7
 NirYe4UhdH60pdA3GpUSv0Q1XMwAMo2C/ZZ862LFiDYQs4Duf6Q6ts0OIl7V4IfGgEQktL9c8aY5j6YpLb28Nxbhleq7ExQp8hrRqoo9OeTueRMoHsZJcPcaJdDzGSRJPnLnY1KEZ5EyVQ2GqQr3hpY8VBr0rtBFQRgMrs0vpQNdl6JQezSx6sL1pwF4LOlo0hlI2FPXERZQYo1T7bBwvRAATuwmZPaXOt0vHjtQUvUKvpDfAY5AGxFb4v/xXGZQ9xSS/Sp883x1L5dT5UoIwOOKwt+bjWPGh5VqlGF1EJAIRz9jpkN80BwB35Psncl7mF/HxRxHnbyDTWNmoQ65pibf8SJrWMTqj19/7hd0ba2pZzycKviYuBOAXRFE9Py4xy5jSmX01GwhYdYUDUn6ct2Eu1T1iasTBF8gBjEdM0M0GTQEOhs4sloUXbjKC0LoQ+NWhWCtR+KRhhxr5lKfxuYt9dv2t4RtsTLILQSknBGTxm6tTckh4PDKodBOceSZ2VTXgD0/HH534DMPf5G969g+EWUJGmErZjNE8USATZFhItzirHmT4xe2pEj76C/lHTVPVJMaF7qnyZNWhVrQ3NP5ra3NzGhc7Eg+F780YqVy7lle/3ROGolQM0qTL+Lzkd9L37lLY3rpUoNrFTVKttyEoGuUGev9vnpYTTZXG00zIxQVsAOZwZsJMzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 02:05:04PM +0000, Yajun Deng wrote:
> If the anon_vma_alloc() is called, the num_children of the parent of
> the anon_vma will be updated. But this operation occurs outside of
> anon_vma_alloc(). There are two callers, one has itself as its parent,
> while another has a real parent. That means they have the same logic.

No they do not. As I explained to you at length.

>
> The update of num_active_vmas and vma->anon_vma are not performed
> together. These operations should be performed under a function.
>
> Add an __anon_vma_alloc() function that implements anon_vma_alloc().
> If the caller has a real parent, called __anon_vma_alloc() and pass
> the parent to it. If it not, called anon_vma_alloc() directly. It will
> set the parent and root of the anon_vma and also updates the num_children
> of its parent anon_vma.

Doing exactly what I told you not to do...

>
> Introduce vma_attach_anon() and vma_detach_anon() to update
> num_active_vmas with vma->anon_vma together.
>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

NAK.

There's so much wrong with this and you've ignored review Liam and I have
spent time giving you (a resource which I have very little of), it's simply
not a good use of my time to look at this further.

Please abandon this idea, it's not good, and you're not implementing it
well.

Thanks, Lorenzo

