Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494ACC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 19:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5388D6B00A2; Wed, 21 Jan 2026 14:35:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7056B00A4; Wed, 21 Jan 2026 14:35:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E7A6B00A5; Wed, 21 Jan 2026 14:35:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 247136B00A2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:35:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9E4D140A8F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:35:29 +0000 (UTC)
X-FDA: 84356975178.08.3EC275D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4995F140011
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:35:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TigNKK6q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R0hWYOeU;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769024126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEuvQTQe0VBAqN1mWOAHrD10UHsX6dWHbT1dmFqj9Gc=;
	b=fo1FdFQj5iO/yaObEKdAwlLQOJPEim/ZQI3z6tmG6jQIEIGdMBOt5UqXHv9QqQsdmD+i4V
	anH6xLjAZ9ew/ewCRek3TLI7hhn2wJsQ3snKe1m0FxW5RktD9l7cEl8/ADUiUwu57ZCEQJ
	RIPqMAvAVrFvFT8X/4n+tlzBdllmlFE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TigNKK6q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R0hWYOeU;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769024126; a=rsa-sha256;
	cv=pass;
	b=szaW74CmvkZ2p/8sss4L73/egTceLVqSzBjyeQ1MVua+lMIvODVXfKKeTrLsQxwmm7V+t+
	aIbB/FW2Y06wlRowhw7/sHzIsx24vi7BYiirljJXgD85Im5B4f3NzPDe5P2XUIKwMrDqIB
	cSh9bd7ljNntuQZO0OnrRe7GqWr+v5o=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LFGc6R3432314;
	Wed, 21 Jan 2026 19:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qEuvQTQe0VBAqN1mWO
	AHrD10UHsX6dWHbT1dmFqj9Gc=; b=TigNKK6q/pQbSHt8PfyK/3oBL5MA1mGPuU
	PUsAuoLl76Gx6zj0oxR5OegeKm8DdYUTFOzE88EggQljLUNWsuEcTf++lmS7U2Fs
	q/xUfeSepgNiyW5x1RqZoXQvCW4Tr/TF7jTXk0zXp8V6LaXkuJiL9FNQkBaRZFPQ
	I6UrruI9GXxMl9Oqi4tX4DheCQn/tTJbx2wvVsll1ufsa76bAtOape0jC9HUJ4eH
	z8ampsUN+2sDI5A+3m2cK4x5nyvmK2mqerhaKSi88feUrvPDv+iUdkRqG03igfy4
	OuvY5nW3Mv7GrfR2nJ00M61vHyj4162jr2ZnAvdNfl04yQQpLemA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5pf49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 19:35:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LI8i2C015498;
	Wed, 21 Jan 2026 19:35:05 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011026.outbound.protection.outlook.com [52.101.52.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbqukd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 19:35:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VMyHEBSta5ELyy3iyp62m4U3RYsHoCnIkFQw82dVEUigBbet3LfhkqO/DJGIaLjTYjzK0AglNTEfOKHdCV/8kas5h3KTvNkqAQFaMsThocR/k3SOYXKhoHxof+oEZWLvmCy4VmtbzhbGXy829088IhigUwOT+7ctrperPTieyUOFRAxmFK6ZlRhpcUg7oT1ZcjNL8Sxe9Veh7opKaPQzLJbJBjs38NSGRYviBH7R4WyIHjtbk42LwFjrEkEZMjtSZzqamrAArjb7asCuJiQ6tT8KF5oUBEllU+ZR5H0XvGGEyHc2Oj/HUJPskZO9bfweb9RNQ93LE+aS8ezOmuzseg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEuvQTQe0VBAqN1mWOAHrD10UHsX6dWHbT1dmFqj9Gc=;
 b=A4fX9xaTaRO09q75VMuqZg5VwjNXkBlkOy7adZDg+jJKzQdSoisgKkDHt5P93oJU5pVsbKuxkjKYGOaF+IbyS8IprLlL6tE/RMe2J28PuJ2BREoSAc1o5YY7nSgepTPRbX+0IL85OgxEPyAT9wzIdVKiPD7J43gxdmVhPX9jdMd4ytFV2k2ynIflnx2NaHkba2Y+reBa0qtmNQyS+KmkWBDl80OseTw82+FmOouZtf8Y2In0nhyw5QIZGXTjK72GudIFz3/qoAKMqmZRmyo0NBsv4oN8R4VD2jVGNtafYecMIvE78qUITCQmAluSXvZtynTJfR9YVKQa+ljy/I8ebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEuvQTQe0VBAqN1mWOAHrD10UHsX6dWHbT1dmFqj9Gc=;
 b=R0hWYOeUAHRxTJfvIx6vTuHinb4xuSd2smkdwSA9Cq3MoXp7U7598mocCRRwey8/zVmpFKJFT9TjBx/y+M1XAR84Xql3bsOnenx5dXGnXsrllGJG++bD2nEf+hwlhSM/w6HVkKk2Y4BPRjc6MAastD97xCvnYrmkCS+peEzXDZk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ5PPF1EC0B6C27.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::793) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 19:35:01 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 19:35:01 +0000
Date: Wed, 21 Jan 2026 14:34:45 -0500
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
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 00/11]  Remove XA_ZERO from error recovery of
 dup_mmap()
Message-ID: <ddyvvndzveegw47wpvlqdushau2qqbue5fwfsylanntoi3apyz@l7ah6cnmrpnp>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
 <20260121105915.5513fb9de156c3f415a1dcd3@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121105915.5513fb9de156c3f415a1dcd3@linux-foundation.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0391.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ5PPF1EC0B6C27:EE_
X-MS-Office365-Filtering-Correlation-Id: 824f2874-26cf-492a-eed8-08de59242b4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4+13OubRzmvleQUDn2MNdV8HPXLky1/spidjuuDNnAGNOqNB2YmJHvUMz6/i?=
 =?us-ascii?Q?KOLsnyfuPAUzx0v8N7/2+gf8KJxDKWYFbpIutS5Bsre38hMEAZQ037vdAPt1?=
 =?us-ascii?Q?D6t3jslQDwJzZk0Uc60iLVYTE+FKLYiHUn5y3+hM6V4bIzLBqrXDLsH5DcJB?=
 =?us-ascii?Q?bolvYS3wITaYSp0Vn0g9rmy8UjVHnuEmeNu2SPMu5AEbvKvcJ/j9qyZIbEZZ?=
 =?us-ascii?Q?0NYXlGuP796JhbVWJhkWvLu4I5vp1tT6TP6VpFMkxaSiPGaoSxjaz0Cp2L+b?=
 =?us-ascii?Q?dSyJfX6U3W/XPTDNtYFiWnxZGVmwODH0o+09vjg1k6deaC7ZEaERlkpY7afe?=
 =?us-ascii?Q?/jv3C2hFpSRGAbjBH7no1Wu5uDqqVegaMI0lSxZ5d1muLf2x8Dd0/DrcmTwT?=
 =?us-ascii?Q?/KWg3d+R+Dzi7e6AZsIpIZVrhBjszqCy0qE1OwWKA92cMVnKCmL46ubMMoNc?=
 =?us-ascii?Q?XTz1Hv23fghZZ61RpAAuk8d4oH74mrsDx/oPOOn8iO5zLkiUDYPzmbm4hG4d?=
 =?us-ascii?Q?wMeylFy15naBmpp7WK5nkBzCACS0k83gx3G4XzPt2xgaaay8cJp9ux7VudMk?=
 =?us-ascii?Q?3XnI590ohwUQ/LZdPtco6/bBqC5LftL2xk+Vbx4BJkUXTIO3DE3Xq+Wk3GSu?=
 =?us-ascii?Q?GuqQ0olkvm6zEma26RTKPCdbMs7HMt+adzAjqHxDA4Go1a1qxzfe/MHu/wYr?=
 =?us-ascii?Q?LkrEJ4ElkeWDVh3zYbKbgWtf8gnbPlPVnrdv52yJkLG9yyYPd57u+2lAHVQh?=
 =?us-ascii?Q?ANZf8Pn45QEd4oNtRzY8TXEIllx85oxahWkY3xzK+gKPTURt3+qFzCsIy/uH?=
 =?us-ascii?Q?Awoy8dF+qqLwyPcWEI2V1zxuaEUTGRfdtwiZL2qHRfEpT/csmVqdWA4QtxTn?=
 =?us-ascii?Q?3/b81Js/xwZUpfmTyS19pu/SU4/TpnbGxxT6+p4zLnB4mJI1vLBIEMGpYq/I?=
 =?us-ascii?Q?1c8cbcZccOwzDSFriWdi36lKlSwoxRqSlH5VOjYMnq5hEx8FvhgYH8qGXu2p?=
 =?us-ascii?Q?bQxDeUIvy1YT/kV2QSQg544UpQlAi3SNbdTvxw1ft5aDrJ2mT2ZiyUZnORM+?=
 =?us-ascii?Q?1Fp2zOPvE3NFdQXqF+sVBfQpocq18VHCizJU8m8BEkWmiqEgkCskCZVAWZlR?=
 =?us-ascii?Q?/YjSGZjo5dwobHHx2AaD75jmh/sQ3cVixgBgseKjGWe39yQ1SqLET1OLOEn4?=
 =?us-ascii?Q?63sjt/HqtP/ufswebX8XsQwUeWiuFlir7/opXDBQepagIxbZu0DAAOAax3P5?=
 =?us-ascii?Q?TDo3QiU/Im0Y/j7gPNbBumnqRbWqKqCZzkV96sCaXpy87OhwPO5QJSSEina2?=
 =?us-ascii?Q?iaDk4f2kxxyL9QOblV8eeZoFWlwuyy7RY2EyUnL4ddfaXlTRFA9TlFxdX8Nc?=
 =?us-ascii?Q?hE9dkNK1YSvoPrWe7reP5q4ckhVkGUlv/6uvbiJjicmWQp91uoICc1jhxJc2?=
 =?us-ascii?Q?6tIADNrwG/WHuXezOrEhMqr8NPR69rmj7NzalF8yYfOMZuTfEptsFVpOOcrH?=
 =?us-ascii?Q?T4CBBhNJZ5RAtNGzAuuwUhk5kg33O3WdCQTmKE9yp56pmfM5FIoZqzLSUGAa?=
 =?us-ascii?Q?zI5uX8PYwrPvTlMOZ08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UowC+eWtwQ1fct0wldJmhklJTWfB+UHwzW4WEYXp/UHfdFnuMQKJSQJnA1Fr?=
 =?us-ascii?Q?x6VfBfJYgbtI/lE9/3odlEX0drlnW0r38a/o9acWSJZxnDFEs9IOpLtX93zL?=
 =?us-ascii?Q?UujhIIb7tOkR78TRGWI0Vgi7mz+5TRAEo49UXVbmvk9isCge0NrNn7c0VyMr?=
 =?us-ascii?Q?JWCSjuIA2w/zVrPek4YCW2/HZOSldiV1NnA763hpL1KHhiiCjyui59ZoKQyz?=
 =?us-ascii?Q?5ccKOR04MeOpbxOfr2xAFOwqf/i0T5TedM5ho5PzyUCjh3AtMbAjO36R6YLt?=
 =?us-ascii?Q?JKCefCfE8XOVXvPpZHgy8FuzcoreclxXZ1UcpMAA0OA3xpZ+eHWoz+yFBSul?=
 =?us-ascii?Q?wztSUPlorG0CnVWMk4+1BNK/LkY/dcHReuCuqdpeHaCS1ufs5jdq+7Scc7dj?=
 =?us-ascii?Q?r+QS8QQ0q4f+ZaMKNeJQ0dr6kClmHE+wZ0uAdfiqiHxaxKVZscik+KTo6svq?=
 =?us-ascii?Q?1PzHUDUGhbd4HOlNssmtWdDKdMtPWHZ8vxPNaaHx32pe73nof/ZvG1NzCqFK?=
 =?us-ascii?Q?vitKpHwOd9rMLSSsy0y59AzFi2gCFpoZtRCaxmTkMp+VyiDRZbVQZ9im8rbO?=
 =?us-ascii?Q?6kuYAtbWb5QLrNC4uBjpBAPSeSlpdSo+e4B1i05tF201/4wpmKvn/zjkQOrP?=
 =?us-ascii?Q?rh6NV6glFIaXtiglTxy5Pvge7d54uBvYW5wvUTK3PzHYrxzxH7CuHGIKVFrL?=
 =?us-ascii?Q?+8OM7j6buVspdfR0eVevP8lrJDkRu36NpBN1sTcodYvyA3/Hc44UBLj/U/+9?=
 =?us-ascii?Q?jYla990Bsen94bJkP3hXTAJkvo336dkfSuzStUd9rJxPqcBpj4E1SarH+eDa?=
 =?us-ascii?Q?EFAGQWLUuQsy8fVI6wjwNs1Ub0X+8x1CFBG4aDvOCmiOuUHxR1brgKcTkoM1?=
 =?us-ascii?Q?gnZBiF2oZ6sTB2LRQAaTP8EX3REBjIGWQvPV0g2QjIZ01VsTwpBaJ42ZmxWU?=
 =?us-ascii?Q?joTjAQSmUQQoGzbZxRFTauX4GFNJMT+i/jXfe35K4/hkSRsUjJxGGSPdWBYb?=
 =?us-ascii?Q?Eq3IE+wxzHjIhDCKJBHvoO++NcFXld8fnAZjzEAS69Vj8ZaBRr8m78H80vGA?=
 =?us-ascii?Q?O2E7xzOScGaH7KCQuqiwG3lu9ShiK+sOubdgfS9E5E57BPdex/YsSnJsV1+z?=
 =?us-ascii?Q?N5/fCJncrGuVEo01i9RbhPDMw+6BcvwEN1ReEttkqBWKTmNQDS0rC7LaiTsb?=
 =?us-ascii?Q?2KkiLa5ZtUIFFOUAqViSuil18pwSpcsrohbO8qXw90Iuvl5sWkK2VTGnM5te?=
 =?us-ascii?Q?Ewu+4DFXTkuJsNXVCCy0RoNcaWdiVvSG5zsqG0EO63iPJ16rw+bAvoaHS2dk?=
 =?us-ascii?Q?wQuau6Ouqhm61+vtrv8MmGHOZwaE3Uyy0jeEdBPvSGreSWbKwc06wu83Y2B9?=
 =?us-ascii?Q?vURM55fRf7XpFjrvyX5Ker0L3G8Kd+1YaYM6ZViH4Q3AXBFfW4olYW2HEPUf?=
 =?us-ascii?Q?oZNGAeni0PG5zkBLecQ860RBgUz4SMSx97+A94Rx77Ah2uqxH1c9zH9B5Los?=
 =?us-ascii?Q?zEUgklolVJrTu3F8OQElBooYndl0/WKvUy9CIF9u3NNKIITOD22o+z903cHJ?=
 =?us-ascii?Q?XgYjFg4c5nv6JZOQQlqwQh9ax+WViID+W1zYIF3xM7FhYATgFpCYNM/jML4H?=
 =?us-ascii?Q?C10T0jUydadLF+0p2txYyHth5GwV/gzgEgq9/HbTit0KP6p3P5U09nDVhMTl?=
 =?us-ascii?Q?nqAO1+Yg+7d0/UYEJvLgsZCRyBoROtGhwwLPz00ogPUuHsIVzGnTapCq6WLj?=
 =?us-ascii?Q?NLZNnValHQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xPI8kBsNOWt0MS/gps9g84s7rSCpGnh9h8HjwoJQtkKm0RQgXuyVFQB/Aie1S5fbeLsV4L57TO4hvjGjzkRIcjrfxuawhKaoHhus9kZ4dpZfr/dN4LBZJ7KWtUlCtkj2weAtqUFqY97npeV94yqXVjO7ObVRdZ5pt5JSC5f/yLyQVpGLJifm6dVi+UhZpTO3l2is+q76zdddqNXv0laS6I9o6XWKUtswsNhd8U7mWSFDh++UI8w9iBZr6G3fsrEBMDH0iREUzYw0H0LyZgvMucib+R3PsxlhTec4AD8UzfkotfBoBgKgzCGMjT/AuVEYKzfPhMATBA3j/xOOeTg04yM8KHEx9zceDLo/ltaBOWEq7fT2jsoPs+BJMAvT8CvIPq6z/IGslyPzO3Txt/9NWDGw/GPclVSWmiO/iD4wNcuQRuIrSWBRVC09m00zabptaSqlwxVLgHpeSYMtYZkfpJFMa2XX1QOFygB6H2sGP//nvyW9H1Hqe1RDpsPwvPZRBTcEJKqnY/90bfHAS+7EjdP0c9zi5hmXq+xp7wOCnqyVCncoGYwOBHuMi94joZ/yw6r7x0M423PrLfBRfQqIPdVWu6ilnvKjI1eq3e2mWdY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 824f2874-26cf-492a-eed8-08de59242b4c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 19:35:01.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZhYvFeTl02hWc3IAwmFMFS6HuFVf+1L/U//LhpmjzaltLipgOZigh90wbYLQ6DSXxhdYmZ7kNPpiUU9CqVTZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1EC0B6C27
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_03,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210163
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE2MyBTYWx0ZWRfX8BPs4htS0lZN
 +m7H1vLgpyX31ujOEjSwqM77CQOpBZr3kszXvRZ0AfQWmvg7aTdVPPxJTDqvFhTYWksp9NKHD4M
 AfqIss+5DMu5143ChKoeskXLY5qYNiiPn9LBISoKatdoq5COmkpQtDYozbXfdvhsFZuAl2eG5Cz
 91iqj4nmsUafHUUPMqIK4vfJdvvjKdIBcdHL+VGkICT898nHZcn79JIslyqXTYli6rKlaDbhfVW
 bpgHtY7B3m019Dyxe3fMirhfSZ2HhQKss1yCsG7yfSqDpGl0q02XXb8IQgFIGusYZfQ6WNTMbEV
 DEKWiBFo0Np8Jum0wm75jeYJf8dsjjLU6+rWT1NdV+LxClwDMTZauf3SJF/0gdLPByQ2vboGqCc
 hiuONk+ql++LO8msiFL41qa/1rtWulN99pkbAVVPAaf94PK/1JHseVOlySP7q8SSeBiqKO7/JcQ
 o4F3KTi9RSgLcOMj0UA==
X-Proofpoint-GUID: eqW-fNx670_EqVchPQxqNYJvit4CAcZI
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69712a6a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=-6PxAIypZGhGUC2Z800A:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: eqW-fNx670_EqVchPQxqNYJvit4CAcZI
X-Stat-Signature: eh3xfiauu6u8hgugcbtn15s8kdgmb1jt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4995F140011
X-HE-Tag: 1769024126-296563
X-HE-Meta: U2FsdGVkX19VrgxZMG4+0/Xz2AZHIoHVM2WJ9XgcMXCfaUKgGM0t15sdxoPWly8kDY23K/DESWEKQVWgwB/TZTLQMMv2bPpB8fFEM40FDW/QfTZYRILSHhQZAm5vHai3286gu0CZWVQGKpUf7hj5zdZXtLmhGKOPOMSe+E0tBxJt3cvPVFime3JALMlFGwug56y474M50LXFXpt3nGCJP2Fvq1I4wgxqCQI8GzW8SqJIz9bRe40au6PL8pAH8Csr2Rh2vncZ0dBbv2xmDA9kulRC8SeA+CWDJ8V4zvdDhr0Vg4d0pdd3ZC0KM1armRUWJ7bcRZ4ICzveCIV8pTc/mpISwwz+j5R+HbhfLaTXYxlyUFzw9aoeaCz0uY0s65zO6tjcodnbYdT0zMP4IPjW1qUhE0GdHmcPmc0e5Nymz90Kx0tqT7AypQB28ZZ+z4vI2HPcEAvv6BVAxiGUVmfucqum1syNn2FUngr82ACuSdMY0/ek6fwAkUkRSXsTJ9wRvcLrJb5UyU2+jN+83Ey5GwqHULJZr2VFyDl7RV+PAG3BKSkZaM+PIgf8OiZiyisgTd0vRwrxLAlx/y/qWAlHTtQ0KL2V4EIdTl5MpGDm09OKC8WTOo2O/LXGMuiX2rWPlW0sW9nbsAhaUKOMCrRDwzJCRw40xnR9mgblYbKt6o+rWEOthZQOGO4jq77iU7eg5RrtquHtjOTwmw3KbmA+XZ48sqmH/3iqzATtNjrGHVVfLk3K0oJeN9B5CkRLc1BkbQ2mI9f6l6ZQQZX1sxBpc2+YesqH5CiGEX/vabavL28Q+Q7nnFkw8AVBDxG/SuFikYuqv8ldF+cIHgyuGEZ2neE9aSUuGr1tLpQsgc3uQIf1V19XbpEm/6c6zbmzL/YqzPpci91fEYdveOGbV/ajtTQ4xrKPNUlWAj2tSMUZYoCdE22z9KImGbwyL7/Yso8clInxeam6wY9rh+6aHiZ
 C6+/02ev
 lTJCPF5ZQgxepoWPKZuXA4dL7zhtZDY9IH7iNCsTrY9qgf1aV7RJ4F5r8fcO/O3H+gmqyL166MAw/+lYPW6zNsuIg0mKx0Gk/zthR7CdBSd+BlykezJPVGsYUBk1gAoSrBe6cIu04qE8WAjPCeEJ6DgPc7roN0PgGx4YPsDHsCv4Oe61rZckTogbAowwXCfYZK61ErNgFCQEDHRdNt6InIT8p2LVwZz5T20VmuSFDOCBFc3f3aq1nX7K115qF7zmqtXO2xp8athiVhAXO8BMRjT5aq167tRr3qoFLTOvDCz0Mlh5U87lW9OT8QW/ZCsNk6kXDS0Jqa4cpWx0Ly5dtQA8S+UIm3uMsXMJgaWbTrApNWTgYJI1CkCxQa0JFdkttRAxan3vr3pkDnqDHB36wX0VBf1tKq0LVhDe6OKOREG5VjOZZQLMERSvjXDv8pAmUNvraydlxUJO/umVGF6tbmdZDT9gZ0vgF158FqmS3zF40AHTURfpsNjP8LhfpHqTMv+lle7JZCtHrVtQjDFD3OCxJ1qHwhcrIF1gR67Kb0x1Smz5HvPF6Hsi4KQOdnIxJPAyNnc2DOh7hfn+7L58Om9w0jCjdypOdaGO1IZUXQJOzkOWr4KIUSu91bfnrxauQQoBC8ob3twM2HGArnwHSN52pzS5eDEN9tTJMJsy6fY7NAJ4vOEGNMIzC1WPP285LMqDUxd6larDPYHvqx62YX6REbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andrew Morton <akpm@linux-foundation.org> [260121 13:59]:
> On Wed, 21 Jan 2026 11:49:35 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > It is possible that the dup_mmap() call fails on allocating or setting
> > up a vma after the maple tree of the oldmm is copied.  Today, that
> > failure point is marked by inserting an XA_ZERO entry over the failure
> > point so that the exact location does not need to be communicated
> > through to exit_mmap().
> > 
> > However, a race exists in the tear down process because the dup_mmap()
> > drops the mmap lock before exit_mmap() can remove the partially set up
> > vma tree.  This means that other tasks may get to the mm tree and find
> > the invalid vma pointer (since it's an XA_ZERO entry), even though the
> > mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.
> > 
> > To remove the race fully, the tree must be cleaned up before dropping
> > the lock.  This is accomplished by extracting the vma cleanup in
> > exit_mmap() and changing the required functions to pass through the vma
> > search limit.  Any other tree modifications would require extra cycles
> > which should be spent on freeing memory.
> 
> I've updated mm-unstable to this version. thanks.
> 
> > Changes since v2:
> > - Fixed header issue - Thanks Lorenzo & SeongJae
> 
> According to my thing, this is how v3 altered mm.git:
> 
> 
> --- a/include/linux/pgtable.h~b
> +++ a/include/linux/pgtable.h
> @@ -1660,6 +1660,7 @@ void arch_sync_kernel_mappings(unsigned
>  #define FIRST_USER_ADDRESS	0UL
>  #endif
>  
> +
>  /*
>   * No-op macros that just return the current protection value. Defined here
>   * because these macros can be used even if CONFIG_MMU is not defined.
> _
> 
> 
> So I assume you incorporated SeongJae's fix as-is.

Pretty close.

I messed up the whitespace, which is probably the delta.  I also added
the header change to this patch (from Lorenzo), but I probably should
have put that in the later patch (like SJ said in his response to my
patch).  I don't think there's any harm either way.

Thanks,
Liam

