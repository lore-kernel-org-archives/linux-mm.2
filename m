Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E413DF513E9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 02:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217C16B0005; Thu,  5 Mar 2026 21:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9286B0089; Thu,  5 Mar 2026 21:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0705D6B008A; Thu,  5 Mar 2026 21:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E78F16B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 21:47:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 780BFB85F2
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:47:10 +0000 (UTC)
X-FDA: 84514101420.13.1E8D3CC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 028FE20007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:47:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=o4PfDgeZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hdp+SZ97;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772765227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dece5oLaaXHkOXL/2YkDxMC7psn72UhNbh0rSL9esm0=;
	b=ZWnbQZo/aCyUl0mdExCDKKBYVQBIPhpoAdbNJclu1goWN6ECvY2WqMI8NZYu4NBZZEQbqQ
	TmSjvg8J80VQmyOYIPGUN9A2DtNp4n9T9iXl3Vrgt2NrpMhOGcWjs0dGJ5YCXkvhRuPjC/
	EYgrzITbkJNGUe2VX5ZkUWcp41nh8rk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=o4PfDgeZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hdp+SZ97;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772765227; a=rsa-sha256;
	cv=pass;
	b=wujkRhBsVhaQzCvrpAAaY7fKrmyUH/532x+PZvQkkJ6TnjLJ3E/NVGOIwv06NGWpJH5f9b
	pS7MEeeC9rEKV/CNKEbBuWL7EZFKjsuxg6E86Z6sy9Kgj+r0eRyjEtWOO/gBBtRTX5D0zd
	VqGNje7ZcgyuF727D17v+z7QhIB34mg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6261Xlgk2180538;
	Fri, 6 Mar 2026 02:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Dece5oLaaXHkOXL/2Y
	kDxMC7psn72UhNbh0rSL9esm0=; b=o4PfDgeZMGStNVlOAjT8PsCzpfA+WZS+GG
	G2LR5/1xLNmkZD+neJyMu7EHCXiW+Nrb8GCl78vfJuOFR+Pnqjr2baJtlWPd3cH9
	DVVl+SCtoIWzEvgTO16nyaGxut4Fm1nqHHasyDFznKHL3qvDY5Yc7q0OSriX/yHz
	jT4KhSXYHAudNfzbQVbwCxRZPq5iT416c6VPG9q44mZhJBLTZYYXBldeXLI5AiaE
	QgtV4eo5sZrZkxfW3p9i7TBLN+t7Z8oUWZFEE595gJDynxTG8d2cpGCKPKaGOoMv
	eLiPkzhhcJ9ODb/rG5v5f6/x3Iehn5fZ6ZbfRQKzF89jW1slE21w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cqnbwg25h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Mar 2026 02:46:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6260UNUW034772;
	Fri, 6 Mar 2026 02:46:45 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptj3ypd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Mar 2026 02:46:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odLMIq+z3tqoAODbm52Bcn9+5vK3RKOVcMfHqrbx+eQSnBZTm8QFH4HctVUIQmjGLBc+whh3cyprt9T7T9/+esXTaiXIkRv3WnXpDCg2NYThyCOOInUJjg3ZJagCzNw4J0m0l1gM36gHjQRvLuwggMU940cYY0h6lAvH73cx4sVNVhuOXt5g35XQq9gaBojU32RfF6m5xaeoKjap7zceKixl0ilRpYrj65diK2CXbjCVu1+xZGQBhPJa/4jlh6tXPHtuPnIcVQsnkPmluyVxbZ4hx6TRZOemEnQaK6F0MzOklEmAgGvZUvwCpE7e0NlWGE1AXCq59TnZ3tNChM4meg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dece5oLaaXHkOXL/2YkDxMC7psn72UhNbh0rSL9esm0=;
 b=FjJs2DhdeCqYDii7VnrFrSTVHutSsopqrS5A9iT1N6B5JVSEtO779umTiTpBbZ02Q8Ul7vkbQ53ZAPpC/OF612fnhJ+ZyL5dam4m/Op81141TY6BWsZzXIDxJ/CT5Wi4MGFLwcBWbL+UQFWTtl3PCYB7pFEH0xdrxV566PE8+gsETNmPDsKR6jcQLnO0tAoEnwi92wPqWZTb2ZppbmH6mT6f3JeFzd/lq2YEnw48L7c5vx80WBWKP8IftMlDqohOrUsXE5v2rahfhDGYStqjoHEiVrtLFxSQ0sZk+sSF3RugyHjsflIqu/ibWZdbse9ri8C9A3TeJGSHzaBIf9gAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dece5oLaaXHkOXL/2YkDxMC7psn72UhNbh0rSL9esm0=;
 b=hdp+SZ978muvO8TTIeWJgOttF6M9wi6I1IArWjG0U3wOlcv/iXhecE0ETOOkeqvPrsrUCxsZvthoC79aa1Br81ChvY476DUaL4n00BjX9LEALENw7uhOJ4v26HNLlMxNcT9xJiZvVQ09IdYJF07oy3xElcl+kF/JrAHCwdC+sfU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM4PR10MB5917.namprd10.prod.outlook.com (2603:10b6:8:b1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Fri, 6 Mar 2026 02:46:41 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 02:46:40 +0000
Date: Fri, 6 Mar 2026 11:46:29 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: linux-mm@kvack.org
Cc: Dmitry Vyukov <dvyukov@google.com>, lkmm@lists.linux.dev,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Daniel Lustig <dlustig@nvidia.com>, Akira Yokosawa <akiyks@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        David Howells <dhowells@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>, Boqun Feng <boqun@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
        Andrea Parri <parri.andrea@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Mateusz Guzik <mjguzik@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
Message-ID: <aapABVbVYNwhEV55@hyeyoo>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ_lJAqxh_hNGr_v@hyeyoo>
X-ClientProxiedBy: SE2P216CA0171.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2cb::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM4PR10MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dbfd4e7-a32b-4db9-1349-08de7b2a9827
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	ZlAMqPtGqb8Eu913Xmsw2oM9WANWx/2sotmxtA3ALDfoPGHI5bu2zGbeTTbqmVCcXktXb5CBJyJOwDyv8i6i5fKaj2Hfg3X0cI3oJxXUae/r97AG2rX8rXRJtJlifMoEg2L9xEXmCCxYmEbU7V0BXUcA1uHbbzhysMBaTA0miUbeRhumt7OE0ORBbhlWzOtZi0+Lw7riUo0qt6YnZKj8SNfdPrqrqoyqAapZTaoWafYYQhgKlQozCaoegzw1JlLvdVxnLdBbfMLSm9eNpKSHCiRUB20z/585T/JLgjtppXI8Bk500WZdP+SanUrioz9NjMkr1pP7IyUNvWUVDXBbnT5pDXtbNlIXPl+RoL1wszgYpMCWjHJmL9dzLlW8OLp7u2CiABxNg0CeMq0HIicumFFY93FhqnrMqnO/OBZaJ/Aa6Ce3VgjzVQntzeipakMAVyuxM9BrJQDCBwVswi1fYx3fhGUVI12rauofY2/x38c9w87Yke1DJ0umi3ICF1k7+3i9qGVt4CGX+9rYIzf78XhiVqaTAz9dA98dbtdlCB4x9Rj1KCeAQUtvB4nVE+Ft7Hr9WXsmUkPnLAKpecnwfJQUtJmDMaTTqvj+EaKDXWddwt7yFB4Nq+Cy08lFIEu8bdgVTZvz145PXoB3jIiaC/yrpvKHZcBqqmappt2+QCm+ZU0DWqtPH8I8NcSyhy667jN55HwialEQ+hgLgFlAfzv0Jr1Z+ecfYI1yRWRaSgbyWRhPSy9fBdl+j3b9NtIo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Su1G+GRb7xOWP0XCQKAwlkjbe7NudKG/IPe/zVXeSq5hREveKG7+gXhBQTF/?=
 =?us-ascii?Q?UKMMNRRlnzBF3V/SOIHiyh7cLwTNvxKWkxc2sAH+Ux9yuqgnqX9jw20CKSVZ?=
 =?us-ascii?Q?UOuVwGTD81mwmsLqp7yBsAG3Y8htjRMs+QJC09jLkumWu4Dg5z1hEleKwYfk?=
 =?us-ascii?Q?q/VlRmZ9T4WOpjjS+Plyg/CCqyYFJwjuRQeGDeMGbLd7wUmI/tCdsA6I80BS?=
 =?us-ascii?Q?pAaSKy4lM8N4jdAfy4ZqqMpWx3X0V3oVAOINVCRotLSBblPaRSsJ9qUfRr2N?=
 =?us-ascii?Q?ga/lXWKKGGh0UxdsB1D2lNHOxnG1/UspJkj0w0wg6cXz7ldRtLPBiEqjFbL4?=
 =?us-ascii?Q?QC9Ru+wFzRQwGnpzRAcxY6b5adJ3GJsYCbwNtkrMkHc7lvcm4mmrRDsefVUk?=
 =?us-ascii?Q?nu8ibeKBiOx6i9Pe16PYkVoigbuVDZryAZM11+2sY1hFp2BXjld/z4YWtb5J?=
 =?us-ascii?Q?xmeMEYMzc50tr6tj6xEleV3DJe8Ma5Aj4YxpjGGngpPS2Sj+1I+JZGaPxcgd?=
 =?us-ascii?Q?PwyW8DPWw0HDxEoYKN8Rmc/6AMzyTF4ihTZh88m4gYFjRkG0QA8tJCZp77m8?=
 =?us-ascii?Q?oSo3O4YXD11F14Qci7za9Pz+EfAs+SjmPUqVh9qi4h2J2WML+MyoJUJQo0b8?=
 =?us-ascii?Q?8w1OEv7PNh6m8GF4UBfF/5besMhbsfai4GQp7VxJTwbwvgLFze/9dgqyK9fq?=
 =?us-ascii?Q?cmeFOxhXVZFdPgl0lcEsvI0nGKyP2hAhd5q0bgGnXFvzlD/uqSefrI04JrNZ?=
 =?us-ascii?Q?zD5VGgvKa4LWbpmOoui/8iaTo2bjl5oxLhazjPM6W6hvnUaf6fBw2J3Liijh?=
 =?us-ascii?Q?EYW0mIZph2yPU7Ni5cYaa+gqlDv/Y6V0tr01SU1XOzV5U7LMLAISf4ujQ31O?=
 =?us-ascii?Q?ZAX7MktV9LKbaWgWp1t7nlRUubDt50hlexvZaMcF4+56Op/QWN5TpaDd46AD?=
 =?us-ascii?Q?d3usF5nQW/FvUrHqxsPJaC0O1Umak5srnQsqpd04OSAsY6uYFVj3eB7PYBLf?=
 =?us-ascii?Q?i9BnA9j/AHFgsPOss0jlnMV5M9fZkoK/lsz+rRsKwF+eDPCA2/VQTLm95K0B?=
 =?us-ascii?Q?TEWH6XW37BniFkVnx1CMW/SZcNV/oWwEh91Gs4M/FysrDHXqE4BW9bQXVop5?=
 =?us-ascii?Q?RfdPXdfy2znMrSBBE6M40GoYomn7KvSETr7s8MTQbjMvvcsSpwYnVNeO7C0+?=
 =?us-ascii?Q?qR4RTxY9OrYQnebHsMPHyKslS4H29fmiasEGYVojLh0fNIId77SU5ilPxrz6?=
 =?us-ascii?Q?Eza5u456eKZYLdFnH1o+rTdlZDH739kfI+Nav4DRwymXO/m57iVPP5lDp1bl?=
 =?us-ascii?Q?W3w1fPMdHAq4XLIi4OZpaHxuj2F6ignMEIDu9yl3wQUf0cWWLxzYB2Yftj26?=
 =?us-ascii?Q?iAz1O45bEHOg3F8PGGk9LMgvRMphDCkLOfu7Yx6JZMGp7MLu/ezRppv1sYKE?=
 =?us-ascii?Q?TGBNm7H5hBXJ92cliqCc7DkYRMyHSlmFebEdxnPnkLOEn7/lacqoT7zupURm?=
 =?us-ascii?Q?yL2a7JQ0bHnrBanG0vvFmLxIwYtzV9oBvHqTkL/GUQw0sFE4l3joRM33rLN3?=
 =?us-ascii?Q?fuis8i5b+ICiuChWLza89Ach8dVzs0o1up89p36cZeTGSftHhJ/sXy4ptbUd?=
 =?us-ascii?Q?tAm+S61rdcidzlsUZPMJMTzUMmqmLvb6bPXvl6cVm4IASqP2QZRqn/ZYV6IQ?=
 =?us-ascii?Q?c8IHjU3+IA2/KHcoldN4aZjVZw1vEXlAq6SXzJcg7Nh1uYpJrUwATrqOtujK?=
 =?us-ascii?Q?pegLD9UVlg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	vY/HOV+XyTI5eUgvlKneqX32xe3/x2HeLD6GhJIWCH1vuUSRG2Nxu4WXIPeH3Ou0Sz06p3xWh/JYvwZOGpbWwQU8CXi/OM3zS0MqMTIyluFaYWmL5uNQ0nJ7J+J3Cxmo/g0LfvwMbM5WzWJRDMe9DtlzX05MW9IpNYfNZc0K/sJHzdhsxDLjPzHQlswT+gSkwKZiA/JXXyUbwP3NG5HVbM6ifxeehsioHjdqTnlmzBGAzco0i8E6t2N6U6RCit0cWSivcp7PljRnLfZLj7efuU0bW8yLsEezEYWR7CZQbZ1OHEO6kHv2mTn5R1VqgtE6m+76PiB6jFX/zvluV2I6eg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h832hIBD5Gi3DMAmqTuy+cCSbOlXa8M1u7IAqtYMJGLKnmEyxcPxpxdjnyraPL+tirJ4UOIMVFOpmUSTip+9eoNtaU1ADXQf1mR5Z3KLrQwWSAUmUsb0LrSzVJQgntsCSrik/X3IqGMCs+CYv/owGwAFtShhLBydAwpAUneIlKvIc/gK98ZwC0erSBPsoGeVv6xOIlSmscWRH6FuwKcaWgGgYuDrgdI+2pCslz7VBQO2457hp66BEv9SszW5nomFsZnruoUnTVOdDagxSgaVnZFgKvAuiMHqC0H1gbhoySvrLqZXxr7/YeDyed/ECfa9d/4QzGZa0DGXn2sCgFEmF/5zsYq+8rJUR3ixTYMFYLMAsryE4lrmXvtwIequo6RdfBzhUhRPjLeezAXmZrcZ0dzUr2AFPK59Ql9Ib0xjgnQt5y9coS6X6/d5/4n5wAqhPXCNB29J2B9NMPTPEOh65NN+xsiLUARd7cn1xGWIgchsaBKg3cZ684euDkHsQxmlwvwcu8H+Eio/7m4T0Dsddq1Kp8nrmtl/hSaKk0TvHg+w654Vcb+MfOROnwRC3tGlwijS11HCvLKcQyk0C5uT4IT84lTziO8kwBPu8GavZj8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbfd4e7-a32b-4db9-1349-08de7b2a9827
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 02:46:40.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DXmBW9fiZVE6mxbhA4wAZ7QYEyL9Bl9K4Ozs0si/M4MKKAYaZgxBUxUaWziO1gTOgmDKZkMStzQXHtplL6w5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5917
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_07,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603060023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDAyMyBTYWx0ZWRfX5K2mW6+Z/TMk
 PC3AdG/7h/EXA8GlXH1yWtaTdEVlCIq+br7rAWGeb5Yi14uI4y1vR49h+uvT3utxZqkRMAsFz20
 ApuLRVtwq3okY2nybEjqufprQIkaxStuPHgHPtsqTDF/dPfK0mbg/eC8txMti9Y05tV+q7Ruc36
 a7ZCcCRKjxW5Xiqn2MKOB6IWN+Lp/n54KDNCvnwWVTVNeU1z1sOQCIZwTy2B/TheF9GeuUuJCi5
 donIuPh5l96sXgRoZUqGGAImktY3BwpVJuLNg7uEIRgcSJAio8yXU+CazCnJw6C6Xbsv5vD+WcQ
 3IFXuduDmriwN31nf6f9qY8/or5Phd6TOYNzWFJv6J9LmwLk5hC4fmKqmwHgNAGnMr+n3vKsL3o
 PqKDjdEfXfIj8DqPkdshpmm6MQdFifRonlMYKqxvnE7jRMC1KcvlBfQ0bo7MI5P7iUz6YnLP6gc
 aKX+pKNUH2K/T3JWENMK4OfGv95iui7cCx7HPcPQ=
X-Proofpoint-GUID: MNIsIYbN6jLQBJc88Fg7VozUt6oCxnv0
X-Proofpoint-ORIG-GUID: MNIsIYbN6jLQBJc88Fg7VozUt6oCxnv0
X-Authority-Analysis: v=2.4 cv=AOdXg2Ml c=1 sm=1 tr=0 ts=69aa4016 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=BGGeVFAilU1g4D6xJpkA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12266
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 028FE20007
X-Stat-Signature: yijemd6m1jz4abdm3hoyztqcydseqhce
X-Rspam-User: 
X-HE-Tag: 1772765226-227667
X-HE-Meta: U2FsdGVkX1/MiVDvmDLmW4cNdrMKiIBOrur8CXpFYTVYHJ3qUeZ0yQuNauKcqCIVYGgBG7t7jKyMBKyOlV30liHMeV/Ky/2uTNGG3d9eg8YXWmmpwycNQ7BCV48d6LwPPZTWP3ygBn6UwgMF9hQM7VmLMROsKxvCqlxra73YZe9CkbrbNr6dbuDkDAoT8qJhCynaGdhOZM0F+3nWxzrhXfun5zx0mzSqyP0RdNXjfHSHq7CsbvcAJ+4OLSORKSfelUAC1fE5c9rUYGHliPJggUCrNMAZzoNBxLNxagDw5BBmyKvRfHj7BgKW9w3aTW9Y4ukPHaY+h/PyceIOB6h/ZauydpHxn1M8ZaAWyAUHQaasCqk0EGArpy3RKejJsHZ/t3CKW1f2yJMXPIX4WO7rixDgbNsd2Z8ysWnJwHLuJFQ3HqI5qXyzN3cGe224nVT0HpznDEJr5gga21y/lZ8ineAyZj1LGdLtWpIdibQ5wa2NHTT8PrkHDN8cKS6DAgW0rkjv2fp8GpQdybgS24wNC/OBQAfJ3OgwWOqhtbVhGd7XIWD471dHFmgt+G+Vr6ssT5exs4DnbJhfiWNKo4awoAdAHqGpGKeiSf7x1Oz/9lRJQM1ntXysXq2uzxWFBKUxBPVHlXEY7ypVIyR4W3x9g64V28EqbhLxjRX/vQ93TykpUg+4tGJORh4s/GrJ8/GChcmOSAqH2OnlKxpemeJVpaYgEiG3edRlBN21vo3pa+KEizra7DJhp6VkWRF9jtT2JAhupPjvsCCCG6fZtUCiY0sq7XEU8WjlualCOpgpdCKY3AS35hVXUcx1ZfqK1AyKobTOo3T4X0/19Q4r/kz/x0DLO057K9m5piAAKY0ph1/63IS9cE7oViHHkX0frms+v4VCa+xAv8mt3s9VHEsxoyHmX86iAQeJIY7l4BUxFpXHFhJ9iChsqriJcgdzdGE5DFsrNwpKDIjZLKV2BKZ
 WgH2oJEd
 WJkWvpfcSUFUhUJWVxkbVIFFQff9crMw+Jmei3Uo8JASMJrhoyKxJ4eZdvBDJsx1pGpZM6NbJPgVzJcryy8TWy3zPvMeWbrtYva8XMvEgXJY8ZDzaYXWi5qQbTMpHb1nKPeXi7ctvBr8RRmA6CI4mvr5M0pfN2AaYPljrwrW1FZua5zY0cssaIYfVUYyO+gPzFppBMJ8vEolqmRE4Ry7pW/ty63xkdR2hcnHNgHfRLxQKi/ciOMxwcXZRzXsa+X1C91EBo3ST66aEFOasb03lAvJYPjIv0M9jEMamap5g232pSw+CtTWCGx9kDtNlpzhM9u8DKQwS5S+2NwEjWGh74Fp4JdhN4gs1CdyLx6uUuXcdIQ0/cNYQHs+JkPB+Rky2z7jA62VHw3T7wuzgvqoIh8Mei/0+A0uAUCjsvw8mfEwo2PjB+9mpuoN4nNRaef1mT2DIWPqQnnA6WsYMB3NCekAnCXUqhm/tpUisiz/6D4sC8OzQ57ApuQvcxq114VYs9S+ju9HZXafWa9ouZ0rG80IKlKsC3RmESmqRhnj940Brj8JjoE+m4J96slJzfTIYPH28mpirgclkoZOc26asN6cDCILYKhz67ODq5rZS874iy4OJ16MItpiQ4z+3eZiZCTFQZE7Jy0UN9L8x7ziUUF9O4XcFx0BUQy2v2lxrHDaPd/2sCKDmTpndna2bkQWIyUC99hy6qDp68VKEkbSWy1xGaHXK+YUtHSUbhkRgAtcKlZ2kVpLnSE4QDlsgM0JZd3CtLSy6v0ftkdTwpUKGpsBSGHZkqLyzVnXUVKgjnsXBPI14I6pXGUGzcs5N5pqF498CkovcIQkFsTFleVU1Isw8cU275bbJljnClCsgisQjZJpSNzBnZuOMIf5yE6XXzTDu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 03:35:08PM +0900, Harry Yoo wrote:
> Hello, SLAB, LKMM, and KCSAN folks!

[...snip...]

> # Now, let's take a look at the bug I've been investigating
> 
> There were two bugs [3] [4] reported, with symptoms that appear to be
> caused by slab returning wrong metadata (the symptoms: incorrect
> reference counting of obj_cgroup, integer overflow as more memory is
> uncharged than charged).
> 
> [3] https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com
> [4] https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com
> 
> Hmm, if it's returning wrong metadata, how could that happen?
> 
> Well, perhaps it's either 1) the calculation of metadata address is
> incorrect, or 2) reading the metadata itself is racy.
> 
> Shakeel Butt pointed out [9] that there's a potential memory ordering
> issue. It suggests that no enforced ordering between slab->obj_exts
> and slab->stride can make the metadata address calculation incorrect.
> 
> [9] https://lore.kernel.org/lkml/aZu9G9mVIVzSm6Ft@hyeyoo
> 
> Let's say CPU X and Y are allocating/freeing slab objects from/to
> the same slab. They need to access metadata for the objects:
> 
> CPU X				CPU Y
> 
> // CPU X allocates metadata array
> - slab->obj_exts = <the address of the metadata array>
> - slab->stride = 16 (sizeof struct slab)
> 
> - stride = plain load slab->stride
> - obj_exts = READ_ONCE(slab->obj_exts)
> - if (obj_exts)
>     - metadata_addr =
>       stride * index + obj_exts
> 				- stride = plain load slab->stride
> 				- obj_exts = READ_ONCE(slab->obj_exts)
> 				- if (obj_exts)
> 				  - metadata_addr = stride * index +
> 						    obj_exts
> 
> 				// Wait, obj_exts is non-NULL,
> 				// but slab->stride is stale!
> 
> 				// Now, metadata_addr is wrong.
> 
> Hmm, this could definitely happen when two CPUs try to allocate/free
> objects from/to the same slab. We need to make sure that, CPUs cannot
> see stale slab->stride as long as slab->obj_exts is not NULL.
> 
> # How I tried to fix it
> 
> An expensive solution would be do:
> 
> CPU X:					CPU Y:
> - slab->stride = 16			- READ_ONCE(slab->obj_exts)
> - smp_wmb()				- if (obj_exts)
> - slab->obj_exts = <something>		  - smp_rmb()
> 					  - plain load slab->stride
> 
> Then, CPU Y should see either (obj_exts == 0), or
> (obj_exts != 0 and a valid stride). (obj_exts != 0) && (invalid stride)
> is impossible.
> 
> This fix [5] seems to resolve the bug [6], yay!
>
> Before testing this fix, I wasn't fully convinced that it was a memory
> ordering issue. But after testing it, it seems reasonable to assume that
> it's indeed a memory ordering issue.

Apologies for delay. I had to confirm that there was a confusion
in the analysis above.

It turns out that smp_wmb()+smp_rmb() pair didn't really fix the
underlying problem [10]. And the confusion was that the bugs reported
[5] [7] are actually caused by lack of enforced memory ordering.

It's true that there was a theoretical memory ordering issue (now fixed
in 7.0-rc2 [7]), but the reason why stride value was invalid was because
stride's type was unsigned short, which was too small [9] [11].

So my previous argument that "probably there is a user that violates
slab's assumption" becomes invalid. That's a relif ;)

> [5] https://lore.kernel.org/linux-mm/aZ2Gwie5dpXotxWc@hyeyoo
> [6] https://lore.kernel.org/linux-mm/84492f08-04c2-485c-9a18-cdafd5a9c3e5@linux.ibm.com 

[9] https://lore.kernel.org/linux-mm/20260303135722.2680521-1-harry.yoo@oracle.com
[10] https://lore.kernel.org/linux-mm/aaj--Lej6kWE0aV-@hyeyoo 
[11] https://lore.kernel.org/linux-mm/41f1c856-2c41-4d11-96e6-079d95d8efbb@linux.ibm.com

-- 
Cheers,
Harry / Hyeonggon

