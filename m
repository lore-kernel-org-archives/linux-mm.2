Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2386CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F476B000A; Mon, 24 Nov 2025 05:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046C96B0032; Mon, 24 Nov 2025 05:51:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E506A6B0062; Mon, 24 Nov 2025 05:51:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D21196B000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:51:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82CFA130119
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:51:21 +0000 (UTC)
X-FDA: 84145183962.01.78D4859
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2FB584000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:51:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ee69JMig;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DUMBCyWv;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763981478; a=rsa-sha256;
	cv=pass;
	b=5eIzp5CW+HzrmJ0BfcZcKH8FeiKkYCrUIFcySuGVgDxgn9SXjO7g2kgZsSy/QUKpWcufge
	xLHcvD1yRDjZJpZQdYwKEh/wlsaPcXmhe1B8F7WiCDmPK87MGa7aMBDZxZD7kMEvMeh6FB
	1TpW9FN/YZkvWc7/Dr5LDNrEyuPAy5I=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ee69JMig;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DUMBCyWv;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=medTzSfOv/9miFtOWmHiGduaRAU3+P7iP4hYiRIhfdY=;
	b=Zo1vIjuI1CRfcs9oFM7b59lDYzPXgyfp9e4WZIB8ITprCCxhe2aGkNu0Krwl5Yl9zuVxDJ
	DJbG/Pc53DAzFDsgSuzZ0fiVPanPRXs3mk9riEQsiReelUjUQFY8yhaWE/v6p8uMc7BOCK
	B7/Wmbz3KTpy0n5An1EwYJZW6g5XrQo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO8v7rH724932;
	Mon, 24 Nov 2025 10:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=medTzSfOv/9miFtOWm
	HiGduaRAU3+P7iP4hYiRIhfdY=; b=Ee69JMigbBgR7UDtiW+LkjdJD7OphscFpV
	LqzJQLI8COSaDAGSau8AMrnHeQIG46Y7CfXe5uWt0KdufaKpiGhSpjGpcdhLBonT
	J5WSOA4y1GJ52HcVKGMvuWgGbQNqF7Y/O9GzAy6zDLc+etp/Bc09xfSNvMb7xaUq
	Jj4ui2j5mH2AKG4dMX+5u4mi7Pgxjl/VJj4qIYdlw9U2SDqFiYgNiFf92ouzxyvn
	HBS7tBDZkX9/vVyNVwr37/KV+ksJ2XKWnVIap5KGyA38uPZbYNrILTviQQuQYTBw
	gL+HOw6kC6BkHbaRiEm4ZE5XJKLs0hYeyBz/X0tRTUhTF+4A9YYw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7xd1spt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:51:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO9C86Z032064;
	Mon, 24 Nov 2025 10:51:09 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010067.outbound.protection.outlook.com [52.101.61.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m7yb4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:51:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F20quYQuQleTlpr2s3itTLRtFa+ECd41XQBmL23oWO3JoDJBj05jgdmzdn1XYjvHZF8BDuE5VrbeS+5iIe8gT8FN82D3n8cZ0FvXr2DbFZvwiuB+pYk6SPC/QLpk0IwjKjD693/anTimG5MDANNCBJIHl1o88p93u5ZCIE2Gai+h9uGtafRPjS96oPkwmPf68LKix0TclfUdpA62TvUF5uSCvsozd0Xo864zVEqjKObT8GSXr0YBPltwepmUdO/SGmuhlJq4XDuTjw1otdpPHE6CmKfpydIXXBJwx77KY/EP8H9nTOcx1MLPvrOvoKD6KKygjPVe+nlWKjghGX9nyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=medTzSfOv/9miFtOWmHiGduaRAU3+P7iP4hYiRIhfdY=;
 b=P1j//8K+Olle7WqG19PPHp9UF+3qBQMJOS1a/2yQCIfyC3s9tXAxqMh7IxNaYck33Rjhww9aMQ+LHVcW8yLOwl+g/61yLjzQxHm9bZTKEJO4Sa02nBGGQhoqsRZwoLizC8fPWm/L/+kjnG6eP41tWixN80XMpsBU0a4X3R/lPBrYqtJxvpFiKnCYlussmtitDW31uwSB0xzpBwnv+X/eYt+B+XEsJp16b7byPE2qHlfzDqn4JyIW5odxio0xxpnD1V/RkKvBqdqr8Cpu5F5tEsziDQ+OPY+ixcc90xsDRGycQ8LSU5LMOHp2QmD/upJXo50Cl/JgxqEWH6Byykz72g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=medTzSfOv/9miFtOWmHiGduaRAU3+P7iP4hYiRIhfdY=;
 b=DUMBCyWvghEiPBbUfFxXy6X06s85BbrOWVibfkXEm4faC4bMYhtCf86V/dqvVXaORd3F2ieDMmAc+gAV8SsGlI2b099GB+YpPxND1hQEhTPYwrmriNPphI1PoCJjSw4omzIgoIuugcu7vkjGIp+aPT2vXCGZA+FcC7jytkiA7ks=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7979.namprd10.prod.outlook.com (2603:10b6:8:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 10:51:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 10:51:05 +0000
Date: Mon, 24 Nov 2025 10:51:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, mhocko@suse.com,
        surenb@google.com, rppt@kernel.org, vbabka@suse.cz,
        Liam.Howlett@oracle.com, david@kernel.org, akpm@linux-foundation.org,
        Vladimir Davydov <vdavydov@virtuozzo.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] pagemap: Update BUDDY flag documentation
Message-ID: <ccd47ac6-439b-4c17-91fc-15c4f007af80@lucifer.local>
References: <20251122211920.3410371-1-richard@nod.at>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122211920.3410371-1-richard@nod.at>
X-ClientProxiedBy: LO4P123CA0308.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d82c94-1d15-4e30-b455-08de2b475e36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qr3CMyQjRwdnQcCT2pWbBcGhBtmSQbV9gH/VYG4eIa9wrxhIwJVEGLMqkBXo?=
 =?us-ascii?Q?wr+J4Z7Spo7jvAB4wks9kS+dm3DHhwt258G0t1w8AiipyilyWUMiwuxn84cy?=
 =?us-ascii?Q?RAaKt6plSYwLWDKmq1tMgjmhU9QE/L9EzeENMRz8DWikfN8FUmSt7umsStu6?=
 =?us-ascii?Q?qXTz1c83tEC2qhm7wPdz5/VXf6S2c0QsbdU1HrwJSzcNp4K8w3mElubdrea8?=
 =?us-ascii?Q?hdVGMfD+OESvZpmERHMzTsJCTUA0kud4BhYCe3ACa0POYbhl//H6kTcRllQ5?=
 =?us-ascii?Q?oRmIpfZScoXyoASN06wRfst01tABOaluR4BNzM4Nfa6Oy3b224EDdQSDMHJK?=
 =?us-ascii?Q?GBjS4NI/6ZFf/cRCg/EXOe//D5lYu/iB/nSXLiNFxK2/Wq63jNc02EeN72YT?=
 =?us-ascii?Q?hNsGkgD7XjqGFMH12ovvYhWo9MluXLqfj7JYIP3Nw9QYnzd3d7EWhDOUWBLS?=
 =?us-ascii?Q?7L9CRy9X4dYVgBRpHt4bRkoj8aVxbmTWglTbV88n26M9mcXamE9LBg6Pn+rZ?=
 =?us-ascii?Q?6MV1YKltAhRkP3OgTDWZ1EqdN99hJtl9/UGTox+UTLsHemF80qE2RE85Hiiy?=
 =?us-ascii?Q?uEqQ0igftb/lVfpWw/J8zVGfB6wYWALTZ09Nc9jXjwo6HDcv512eooigy2hN?=
 =?us-ascii?Q?NMF+o4LWwpI7+gWmeYDotbnGhddW2A2KQ/MUL+nE2jlBbucurfq2eEufc+i1?=
 =?us-ascii?Q?Noa5jM5b1PR22HK60VhRBy/vil50tFImRZwIjOcRr8fGaL5xTefM59Ygby4r?=
 =?us-ascii?Q?mcYV3KmHWH938CZl3kXmMrpWYNt9tyccwBFTm/zwPbC5f9xcQqOycrcv5K+u?=
 =?us-ascii?Q?7Z83F5RmK9Jiv8v8byFueOC6T6ysIFBSvNAwKGGtfhPG5fYRwLQEzDJT/wZ5?=
 =?us-ascii?Q?o28UjkG0Eht9wMyftrMtoJVAz9kft8gnx0u/472n5KKPOSoWEQX6iAX+7CRu?=
 =?us-ascii?Q?IzV93tBrh1wB4upMI3SplEDpEnDgqiXoaWuJdDbORaIMz0EYCAuWEaV8WzGb?=
 =?us-ascii?Q?ShgPYPGIPsjCaFhcV5dlXCVpOkEfVXi1GY43lHK6x4CINJstplndS5mEi1lg?=
 =?us-ascii?Q?+yZzAYsu2VhxpMMS0sobhU0DdpuRKAVmQKcfvXLdKh4lNzVkeyewcbRPjHPK?=
 =?us-ascii?Q?1NMmxVwgzS/w2kTDC/C87QdjD13VEbFo1WoCtZNSO0IreAP9dDT3QPSjstXL?=
 =?us-ascii?Q?8UlA7Nt+gzls6STKv6yrZIH7HIArB96wFeUA6EuMSvkOwvsUgFQF/zkHCj8T?=
 =?us-ascii?Q?WwdESFiK69TLUecxd1pnzPJr3ZbE59L97Vy4kf89Urrs3Q5hUJMrwhOpiOp7?=
 =?us-ascii?Q?wdN+1h9K/KSlY9h16GA2toewIcrqsqzlNA5ne5RfpEiWL7r+Uyf7+FXev5w/?=
 =?us-ascii?Q?6bRhMsXJR+IURyqa2RYxUf0ZlrDRT9ofOtkG/k2jJZ9r9ifGi/rKxC6c/iSE?=
 =?us-ascii?Q?bLYmG5tVzZQqZDXX93IBRWM/vOvYLwvi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MPr16viMLcn3bOP0s+ahusHLx2fMGV52P7/vAGwAVjX+hw3pW/X8u4F2re0m?=
 =?us-ascii?Q?kjNp+T8hkz/XCELnpkB0kx/g59ThiD+tbMPEsg07wsD4xcv4R074OGaYczHB?=
 =?us-ascii?Q?mWQyRT+OQ2gkfQOIrsCypSCII+cCU3UlESnJQBGYO9+y5++fTq7iAjrtYNqt?=
 =?us-ascii?Q?6o0zHKsG5lZU2ML+W522hkceB49h7j3wP9jRtoey0Tez+zZ9JN+/0DFOpZGE?=
 =?us-ascii?Q?Lp7tSyWDKyHWmwr/3z8DOXbi0CYE/jarADjB30/W/yA5IGeeW+hlENGrXBj9?=
 =?us-ascii?Q?BCQSrtIxCeuOvjUMkKaoL/nejgiLF6Hf8+hE9oVyrE7zbvQf4yvhdT+th/KH?=
 =?us-ascii?Q?QmXiTypzvi0GYGphFuolfLUZZhSBNtk6mfx7+Dc/dhF3THJaI5ArFK+ESSz2?=
 =?us-ascii?Q?c+c0D2oBTAlQ23QIFYtbR799RyPQFu8G/Hf8rsSjtla23Uo4KEN5HA25ok6j?=
 =?us-ascii?Q?eLAGKu/XV9R+3b4uho1m4qQruFcg3ZMZZMmbyTCoBe/qLiFjh8igWOSnw1Mo?=
 =?us-ascii?Q?ll+Wxbm6p+qfSBgn+4qTRIEwnpOg5799O9EaNEU8M6NeRqT4BEiGsXQP8FbZ?=
 =?us-ascii?Q?a3xLtUvbSL4WcnBem0IthhnpmZkp14ISeElq2zcCiccHlaMDQAm5EqmW4uv0?=
 =?us-ascii?Q?ltBWcW73oQdBK/ka1KnSJiXLqTQZxoH8qh+7ksfUBL9qWQDDKYMKJ6F4GNu2?=
 =?us-ascii?Q?NWYmjQvo/VtR4eRUMbgibh/4+ssGT+IWQ7uZr8H4/WocgPU6FbvSgNoiDmM6?=
 =?us-ascii?Q?jxE97hWhAfiri0r/9AghlFqj0EgQzFQBdZKEUOhstZTE9+P4i/JeMsQ1fuu7?=
 =?us-ascii?Q?NM4oF5G+dqofDWQyKJrk3lga+pG5VhQdRhsKJlZ2lpqVSFio7lNUUzyE3B6R?=
 =?us-ascii?Q?7uVjgdKj49G8Joslvwjk3ip5uA1Uc1mFT8WLBHitKQdMD/b8FYK0hjG6ETCh?=
 =?us-ascii?Q?+CXlksVGTFpD4/zIei/K+q+jCpf9RAOQQqtl4Qd6OYuLdI2JH8ZmOQIsoqLr?=
 =?us-ascii?Q?2I0nV2uhvSVBUDXa1eS03CZr+qQ/ctpS/NZzxM9NOnhd1Aoq+QDOaPlijEgT?=
 =?us-ascii?Q?sUb/szBtxTowW4vSI3PBAPhVv7mNtzgrQSzxrVzofGGV6kJfJCC3D5oetSB0?=
 =?us-ascii?Q?+9PbvPCAfWpsseHQXHORHTKTXxsFRc4tuumYVnzbsrBkGmMPvg+rbeZldT/6?=
 =?us-ascii?Q?mYqCLNjztWpypvLgO3IZg4eR6101UysP/VMVio9Ot1fDF9jmIRZpbK48QZW9?=
 =?us-ascii?Q?ChejNopUL/ahBWr06CcoHJvUV881UR5BMy99EgupPuqE25aQQkdgfRG8QUpj?=
 =?us-ascii?Q?dHX0T5WIlqWcxhuVTYerBPnA5ncbGLD5keYvYh1hyo+uv4IXkWxzjUUCQZJs?=
 =?us-ascii?Q?/mR97wCq7fqMx1Mj8sj5rLqXZaox61cGCqUpkhnPunVaQSiiJPgXSKIFCqjE?=
 =?us-ascii?Q?mYaqWEcbvT+BmrN7UaoxloI2VN2yygXg93fXMTHam+SY1LiJKmgZGCBEYNMS?=
 =?us-ascii?Q?YWODr8y0mDhUW0mxOfGqSb8zax37/+6EakOJ2NLHLO1/L3miyt2zDrAi2Zjq?=
 =?us-ascii?Q?KhewNvh/S8yDTtk0xKqlXLeGNV+LrPQl/Kx7TwankTkcaP24oUfRZTJO61xv?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fLF/aWIGqHxoNZD0H7LL6RUixrxVjF9qlpM8bn7xkGbiB4ENZNTB0GkXiTxOuUgsYet1QEuWeXyVaRhoazSKIkmmtctNIKgDT6igx5qBdWU/LvL7R+yzuvXkstEWJrlf0VJ/Pm3iLDdDeUhULtD4BAlfIYpPi00L1P+3RhzlldyZBEF3+2RSP63LANKJdnCNotVfYk+yA0ECCLPxSBk7oSxNa+MBknXGZnoz7YsAgo7hqGkUBO88pnqATW9bFpS3wmJPUW8BH44BFdGktTqV8kx/Zk1Qnrt53rGGWYUIsI9DOTmUANwZ0AZoP+azYoPWMmK0YI2Whk5gVAI/+Z/TsJoJVIpSNgZIxRA7+TQZfqfMnT4DZGPXzkZU4v9v5ldKjtBquyatvmKJHTk4NtwzG7U7xKkF/1Ts+r/z/1CMPV2Qsm38XQV8HuyEZMmRNF4Kyl1NRaXY/VaNAl1vTm07Vm2ruhf03k2U/j/i0HkLDGYko1a1qquGqMTlQn9yFFVO0X1wXe/2B6B7M2WT4gvAQkWJwqIbVToG27IRQ2EvMNN8Y0Vm8eiBQDcOc+IVaqGGgTbp5jOmDkGFnHo/nacdJUIuTnhaZjkQ+gCf6XUEI6c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d82c94-1d15-4e30-b455-08de2b475e36
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 10:51:05.7095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOqF6tpQfXe84oDXpFzhjTV3TRD0bwJS5gC/KC67D9ktTAQhtLML7iA+Tu/In2ME9zrxGexLy2sUnOWcugd6X+fXGalTIgPHY+LX2mxphVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7979
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511240096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA5NiBTYWx0ZWRfX/EYZibGCB52E
 33uFUc0G/hpObvKc+Rq6MP+HXfUGAY0j/BhUb9XziabDpyLpeQmvuh2b/rQwuJJZQHzE6r/ga4Q
 cuSP85IVdVpDhqEKxFyfIkmrlhTiE2sFEHNE00q0llTtUVC40K82smjdqKcu2i8acMLbglslkN/
 v9IP1pf6a6R61JmTiNtmMsJUtn8Lw/LsAk7HwKONmAdpTFXPOusTDzLjVuUp/uoMhRAYb/Gbarp
 YuXCV9jBLYODSyqU2FMu30ZGGLo4WCVnFg344IDPSjzZ/AVqNsOBrFyx1T5FHk52IPtwovWgz1S
 p2lLRNL+u6dqcgmzK1Vf8RmyEiIcv6wYl6dl7woKct0LWied6QRTsVl0GoZHmuz5XF6fifOLSzJ
 D+GVeLbXgAXsja0ejyk1hwI+s4vV1A==
X-Proofpoint-ORIG-GUID: QNJKkTmYSDtSHKN9kPvGj5QI0fVnf0AX
X-Proofpoint-GUID: QNJKkTmYSDtSHKN9kPvGj5QI0fVnf0AX
X-Authority-Analysis: v=2.4 cv=K88v3iWI c=1 sm=1 tr=0 ts=6924389e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=TYBLyS7eAAAA:8 a=pGLkceISAAAA:8 a=nrACCIEEAAAA:8 a=Z4Rwk6OoAAAA:8
 a=yPCof4ZbAAAA:8 a=05heOZ5wPuJRuppo56YA:9 a=CjuIK1q_8ugA:10
 a=zvYvwCWiE4KgVXXeO06c:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FB584000D
X-Stat-Signature: 4p8yhbos1wph8eqwyjqo76iisg38jiqb
X-HE-Tag: 1763981477-630794
X-HE-Meta: U2FsdGVkX19XWSUHvtn6s7g2HCuI4BR8dQx8Or3/+bPDA7n+wLqEQkK3YRpC6HQtL2NmKj++wXwhjEEov+0amxsXCJqWZFLkPCV/y5NQ6ldZCe3z695uKQl4q7SoUX0+dInSPaUW4Dcgyg4VzROQL45dzmQflVae8uu7LhghzLrUFvIX8McubKk3mMIqBJ7X9iFByChODv/J8xs8w4+lybB0TK1y6ZqpuJvQHVDcwB3xAQtwwzfVXrsUkM3tqzQx7jt0oAT/uLFPjuWZch1DKb/CbZeVOd21LZFMwcNZBehOny5U10dDj4b2kozDN/LhV9whBgTO9UNIbmCKfllLPOrvd4flpSEI5eSRKau0gVIulJ17dgt0WlmY3ncHPwDCdEusr8MnfgwZQCYcXl1IRy3vS5Kuz+fhCTXeDjZUoqgjYssV/AHE6INGI62q6D7q0Xeenadp8ITNdGjcLcn4HEWQBW6sRblH/BYveiFrSDzW36L8jiHsfAhixpFYT38AwZuOBtC0rZVuXem6NRHlK6uSfiQBUavRoelfD78Rfhbxk2k3oTZ3BhsGvz4psK2y4ACp+7WliOHWY1dUnQYA+s7EnPdiL38lmGv00xGpsfcV5EW+CK9iWPHiU1wmXAZj31iL8I7CFfreHVHjt64Bi2r2kWSBTxMKLMTqYnKtv1/3iNTEJgH88S3Uyky9WJsw0Gmjg8hEiUYD52VO2uQr+qcNdQKVIMQVH31Cn373cplR77U0NZsYoHC8fRs6SJOwgtu22Pr8c3OQeGld0Sn+us0WRBc6tulLjPje5Oeuh2pmFX18gPlg/iHXZrZ0rAKPrQinBJ9/BVSFxHdE5BY6xjETmkOzMca87uzjGpjMuvOeoBiTkkosdBW7uq4qbg+UHvvRHoNl7a9Zzrcu3F2VD4BEFFBNepvJMmtGoMw8qdMl5jbJhb0GvZqB5XufVP424MtFcpbKLh83nHIrUax
 HXfoj9lq
 xq5Y5+aSqvyZ0N4xuQbdShtcA7Uu2lA5nO+9llsFRP6leWIRTO6eO2QrhVm8AIhqWP/JWGrNVuD6WZYgdf1C9qR3c1SvTY2WGHBs0nc+h1gE9OmpXugzfLI/QZGJlvyuo/IrwHx9FLAIS0njRJVobOT1Dkr7dY/5377q5eLhX6aeERxlpn2OTHIcVIalLKF0DtfJxBiIwb1lHTQyphbbVPTMVcYXR1pzH3f1TfsaMq3pksyGLLQTOV50ik+e9VOxChfEiNeFKra/oefBu/pLxUFA1S9LHA+I3AWzlBSeYIlG0yAvvUzzxIcZF0HyXJILHK53vcjPEFphQydnG+vDVqDwRVspLNUUV1GZrQqiOBNCCM3uv0FjkgITL12Ot/ijyHDvoviNpEyit9LupQya7oMGOrh2cxmhU+kzM1kQSE835IbPYSFI6gdoTNpA/OyAlsL1xRLQ18wna7egOp9vlpYKFUVmGLB6KwN9b297YNw90DH6lhNKob6sLIEfVnkPyyuWP5g/iRhU2JusXQnPHZ4RxXI+OTjSuoH60X78o7pzh7ZzTkrH/qH6slJTLFW4onL6dYZdM2nJ8l8tch1IfvF8v/JOycCRaCFii0iHMpP4yMuxM/S3qyXxV2BxM4Y3CIJZMq5I53ftBBBSlKqK1p9iWz4VVmtS655yrcr5CzcIdX9Q2Y/URpj1+2o0UZ21IgvYCh4P1qxJp2Ihj11TD0Hqoipz9JRiyw+bh7Vc5NaU1Q4ldQdssjgtXfXLQwsN2CgDD+t3u/4wssrCA9GdtKudlyqHNC2etaj5lWw4+S+Y264s6ndAFWmt/FQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 10:19:20PM +0100, Richard Weinberger wrote:
> Since v4.6 the BUDDY flag is set for _all_ pages in the block
> and no longer just for the first one.
> This change was introduced by:
> commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for "tail" buddy pages")
>
> Strictly speaking, this was an ABI change, but as nobody has noticed
> since 2016, let's just update the documentation.
>
> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>>
> Cc: Konstantin Khlebnikov <koct9i@gmail.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Good catch! LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  Documentation/admin-guide/mm/pagemap.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
> index e60e9211fd9b2..c57e61b5d8aa8 100644
> --- a/Documentation/admin-guide/mm/pagemap.rst
> +++ b/Documentation/admin-guide/mm/pagemap.rst
> @@ -115,7 +115,8 @@ Short descriptions to the page flags
>      A free memory block managed by the buddy system allocator.
>      The buddy system organizes free memory in blocks of various orders.
>      An order N block has 2^N physically contiguous pages, with the BUDDY flag
> -    set for and _only_ for the first page.
> +    set for all pages.
> +    Before 4.6 only the first page of the block had the flag set.
>  15 - COMPOUND_HEAD
>      A compound page with order N consists of 2^N physically contiguous pages.
>      A compound page with order 2 takes the form of "HTTT", where H donates its
> --
> 2.51.0
>

