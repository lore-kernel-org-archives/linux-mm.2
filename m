Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D404CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958428E0037; Mon, 10 Nov 2025 12:23:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8456F8E0034; Mon, 10 Nov 2025 12:23:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A718E0037; Mon, 10 Nov 2025 12:23:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 434788E0034
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:23:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEA9C12C4C1
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:23:22 +0000 (UTC)
X-FDA: 84095368644.11.536693D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0729B2000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:23:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l4MLg4kS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=htnhrsWU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762795398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZxT7gE+nU4hJlXvC3qdT6m5HHnar8eu/B72opiAEKQ=;
	b=MxIy0T180fYBxjuMppB2gXwiAB4fn8Le0LMvG2WMztRSLYafX/q5LGkPSgFgTCkuXbPlCX
	kgCx3AIhtW7sHccOWUT6nujtRVMzIPPNPT8LiX+kwmfR/4Hie5mF2O2KF2LD58BEHuXEUk
	+N8M7TO8IG0yApGOcyFzcsYBbT1QME8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762795398; a=rsa-sha256;
	cv=pass;
	b=WBLUC4WJw1m7aw4764w271AWg/sIw+PjFhuWQQbYFI7PdjJOfdu/Zy38ganalakDovvZrE
	zOIjw6ExHHg57DS81xxhvVNx9DjDxurpHbPP3SljBpREgeN+kmMGYfNPB5T08yXB56Fcw4
	I0hf6LzEIyf2ju7PNnDo1B8jCba2irM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l4MLg4kS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=htnhrsWU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAHKQ57032398;
	Mon, 10 Nov 2025 17:23:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MZxT7gE+nU4hJlXvC3qdT6m5HHnar8eu/B72opiAEKQ=; b=
	l4MLg4kStaJcAYzYw8xbSWChpq8rMzRYfRYwdFSVvKkrRmxteX0zDZW34rU1IzPc
	eZLc+Cg0gbY9WX6v8lOjLXYUd688iBXwLUDkBXUogoH2DoEOUPKCqGB9ihCyrxO0
	g/71E9g5rJk8w/ZkaCbN6PIVw0O+ZS/yvVTdk0q9aEVTqIKhpmqIl9PCLF+5bVmj
	IEaozKJuGvr6eM6vSeWlbWIAoz7E11pyMWi5RvSscr6u1HD3Llgv1DlbYdad+Jon
	UfkSf4KL/mxZw+qfLpg1yts8vRl9T0s1nFnBdaMqkO+ZjgPH6STeksTVDmyZMjbW
	XW3yBtoT3bHZQS3dxbHzDA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abks7g3um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:23:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAFn66c040197;
	Mon, 10 Nov 2025 17:23:12 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012070.outbound.protection.outlook.com [40.107.209.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8eg9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:23:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rsw6qcXL9HADEbbqCzRnMlN5qBJpI2fX+uqFLo/mlSkko+nb25Fe1oxYYdTtliyci/dqgsgf2setLfA7fkIw2qt7/aZ4YpJ9kYIUHQzQOskI2Xjkkhhv8qYYGAR4rKuZ1m2NknQmXPVSv1/joCERxlTfzbpk8Wtokfdh64DK/JDgCGzmL54FsFnIcVMopFjVsjBxJGjNous1Tv8ZeTpvUFv58ZHmdipQ8AhQWpHGUCEwJA+iMzShzkhVfAZyeCU8o3N0e6T168hr8zuTtXQYSFok2Ho7hvwzJhBEpm695cmOGjRf3Z0/KvH4PNl5Zuf+hRimawM3FPobiEWCjq/Izg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZxT7gE+nU4hJlXvC3qdT6m5HHnar8eu/B72opiAEKQ=;
 b=nOKIOHY14AHsLYvtDkf9Qiagtl6E9hS/rsNB9lXqlLdTeOFADtfldcTzh//xZViK+wlT56JmpSE2q4bsE0jKUhFdH2tbAGojZ/q350KewS9BqbWkqUZ6c3WbxA4IRIErfN9fojbf3YrcovtctyYUG6HzvDqZVEyx0iulcszOP69ZXaZHVXwA95hTq0jGsESsAIaJPYvdxjuI4t604orGw+tP2zZFsi+Fcjb7Ivh7aqItgULXi14nKV90b6eBsYrgYTdW1no+mcRggI941He8CUImBYKFiGuCKhY9raAUpu2JqA/VMV3IqPV3o6sy67Fjc2sV7WkpFYaHHBKzgdUliQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZxT7gE+nU4hJlXvC3qdT6m5HHnar8eu/B72opiAEKQ=;
 b=htnhrsWULv8WgZutUKjxZzHCn8xGPeP+/EU2XO6tsSiWjyBAb2+3s8XE6xWXVMnp9PDOxeSd1PtI5L5uyJ/vJRNZ8I+xCO+LthTWHK4AK56lNBcuXo1qo1F14lSp+ul41ngrkVdN0xdmgaSU9j8VPCPTxBf0C0rOsvRrj++kZ64=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5089.namprd10.prod.outlook.com (2603:10b6:208:330::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.9; Mon, 10 Nov
 2025 17:23:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 17:23:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/madvise: allow guard page install/remove under VMA lock
Date: Mon, 10 Nov 2025 17:22:58 +0000
Message-ID: <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
References: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0597.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5089:EE_
X-MS-Office365-Filtering-Correlation-Id: 4216e467-8a5b-4f7e-393b-08de207dd146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?opyBgcnin+zAETJK6NVvZ0zoijcjsBxg7vLoj4yDcFBlGFc2D1R1drUojINN?=
 =?us-ascii?Q?WlEoCHWqDHb/IQEi+n+r5ULlD855rNYmHTENxidQ+BmASE6uJ/pN1+oHjScV?=
 =?us-ascii?Q?a0zFquyOO0Kh2dA5AIZsQ5ZMUlQl7lbAQYEMJQ2Gzu1r8r8wxdsndwuAwhf3?=
 =?us-ascii?Q?lcvvd9aH1xOzFVZ1TV9HRPLljI3w5bBGOMcr/scWfkjNGeB6JA1Awi9crn4a?=
 =?us-ascii?Q?HI7a3ci6mJEkfs3ep+vxDZGWUxOhQuc7bNiUO9HP/FLQwUbT/vgjR3BbL77D?=
 =?us-ascii?Q?NkH96vvYZsBdDJ+7shAkXzafl8RDJPBZBuENMOFXoJF2UMd74iv/VVVZRpzH?=
 =?us-ascii?Q?OErKXaRuX47vtUBm2E4DLQVWTK3nr11aLwFBV7UBft/l/sn1MCfQ3h9XaBey?=
 =?us-ascii?Q?GNZW9vC7u5zgXWgcbsGXsSQA1PetEE2YpeU2FVuIGMHOYq+ZDxnJQspy3rGa?=
 =?us-ascii?Q?oxfkCm5L+OF4u2Z3hKR26xegJdvfNgVCtt/2m4RPGu1mnr6wxb6hQICBYNMW?=
 =?us-ascii?Q?IpwOttKWtnBEpseNctcAezuLZlGgcMdqZ4qQ8jyjMFi1GUFLT9Zwn8/08yro?=
 =?us-ascii?Q?0i/RGB6MqwNxkI+AWHBbFJ+iLtLLl4pEkix/TESY2nTPR+xBF/JuqmhyvI/M?=
 =?us-ascii?Q?dtmiMaRaf2MVg00gUoqg6NgZPgXZQgrDqgzA5tLP5t+wOpRrIjfUSULdK5bN?=
 =?us-ascii?Q?46Vv/Qt/Mflj9c7i5PMIkbwTPgEx/nbGNhEErY19YRUfkvWTs8NrqJ2+SFkW?=
 =?us-ascii?Q?fGvLl48HoLZIAvZW3AHXM1fxlnthkTpAXS75k4+6ndI1nNWgKH/jOz/rIM1C?=
 =?us-ascii?Q?KLmLVnOTvhsiyEEqlzxAzbKDU6GHHEiMssXEVP/UEai5iwoG+Iz6i90xk+0s?=
 =?us-ascii?Q?EJT88KbZujAAXScqXr6/miiuBsJVGNWKWL0HkNtVvb5Wqq+3c9lGBqQRbXEX?=
 =?us-ascii?Q?DpIPoJHx4j2zwC3yGeFCHcFQqiDn+y36rn9y5Ykj3QutLlfmesr6Z8aSGecU?=
 =?us-ascii?Q?p3CkGGN6i8mp1XAuadXQHmb5RqQ9AtWbhssP7iyMfZPDbLe8CCE3MCSrVTqn?=
 =?us-ascii?Q?X2A3/Rhz1uKOUZSxCAudJj4iU62pPeFuPdoAVw2NHlnsJjA5YI0sbqqYMfPH?=
 =?us-ascii?Q?bywFXG7Aki2f2uNOucjztFbW5mGUJihsIyPXMfBw/BNeC8gOmvO5ZuiysdC9?=
 =?us-ascii?Q?lLFvk6q7lnlDJBr5cXbAFVYqr06C2GG9C/OdzpsXFtP8Y/lUJdH+V+uL+XX1?=
 =?us-ascii?Q?mk9aAfR5zqdmT6PW1jdCeBBRNs2RXZBlrRWLxCnkae+ROqdwKwMlW56TodPZ?=
 =?us-ascii?Q?YveJieVBkd92M6iiUtwwlribFQNRseVGQmDgOzi01DWsMQmd+4krj6jWRMNW?=
 =?us-ascii?Q?/vyGTw5s87aBWEVU/xMLc7bT2zBkmO/ZeXDFfJ6m9T0CfBkvIdFFHXZnq8qP?=
 =?us-ascii?Q?77CGjxbSgUWS4/zX5Lk1Reggd8/BjPME?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?802ohsG2Cz3GuTxzRNrldfcCp2qwCBue1hbt4cG07WwcGkQVAJRliM89fDAN?=
 =?us-ascii?Q?OiDEVL0vSl/IRRpeaYibv+EnjzeqTmiR7cjF2KY1W/1iG9cROVTXnRhX5qEa?=
 =?us-ascii?Q?8uCehDwYn3Be4BVH5Hmcs7w/m/LYIc8ybQ7TSdY+1+QSLdss8ZyGRefyfz/3?=
 =?us-ascii?Q?yA2YHAZfiyPg+vuE6qtCCUTeymX2YV4x7fxZ0em1hI6t3siZ/CsTkl5DXynv?=
 =?us-ascii?Q?rljgwJw5uxgLKAipjWjrYuRVmf0WKpSfNHZ+XFBqbW8WEwr/uk8LPEqUYzQd?=
 =?us-ascii?Q?X5nFpS1RVDVRg8KPn66XGzv7vRbdjG+LANTaUEgklZj/UUYoQ5uNR7wyVGVR?=
 =?us-ascii?Q?NpVNoEl2P43GO2dPjjf1Ony60PHYOyD8M98BrwYqp7NNRU+oYNWtTich4Nqo?=
 =?us-ascii?Q?1WsBJYYeyT9MRJXr4MKToGrDyxSP65rE2GLz/2R+wOxWjPJCuupOFKt7wu8R?=
 =?us-ascii?Q?t17TFbZl1F0Ej4aO9EcnsKPt82y7A0IvcL8y/7fK5cZCz0LVCr57nqjEhARg?=
 =?us-ascii?Q?st72bvD+CzSSD9UQPXn58Y5GSq+WLqM4ClzJYrOpJLNyRkFoY2N5ZuHVH35E?=
 =?us-ascii?Q?A8YH1B9C4F3OGK8pqbQd5g9O8TVDHGmBUrcxW/T2rY8mVIcfrNt9phim6QJd?=
 =?us-ascii?Q?KwhOkkrnPdwE4dKYt+PlRhSioqo8xAldpIAAAz/uSMOVJd81mH7iSqf2Kj+T?=
 =?us-ascii?Q?MaOE4hybLP39FQGzwxLLf9NL35w+RBAR+ghmcZz7+tCFOGMibXYYAuIYKuXd?=
 =?us-ascii?Q?qAapcu0ZaBP+S9RiVFM4FynLAf1z8luNwjCkts+jpPh4o6PZbDNFfv7I7qMX?=
 =?us-ascii?Q?A38QwGAkKiD/4E/O0Dhfjg22c0rDJ7p0oBsOaa9uCPmxAF/8V8oFfNklGlcL?=
 =?us-ascii?Q?zdMXrr6fgvx7NWxDjlx0diMmVAcgC4LhcAzII4IllRs2lGTga1/w45tQ4+QE?=
 =?us-ascii?Q?hKR4hszyOr63Oe8h1oHdd7/iD6S9a/Uq7dU3WPeSv3FrS0iCELdGk1mifFr4?=
 =?us-ascii?Q?Nwl12PNmHD9HY28axaK82AF2n/Jdq+zRzHmXTKOI3hvwtUYomeNjQN3yRIN2?=
 =?us-ascii?Q?QahpQNHTyfJ4RTXtlv91S3zxPE5hapFbAitSB75rVsRL+VbqgxzSzgBkXxXA?=
 =?us-ascii?Q?fuJhi4Fkp0vBeRt+z2rfkcYidhMmSfmgnrBp/8grMNC82PhveFByGBXk9f3M?=
 =?us-ascii?Q?OBDtTgtozpyHBsoo7Z2K36BhveyxN0DNrGOQ/koH8em8JAhLZmTEViGcDKiu?=
 =?us-ascii?Q?tjf8BSfXUokzzs8QTLumOzvx281hqtdpsGLn/De5pJ1bwnTIN0s+jm/UOaNo?=
 =?us-ascii?Q?eTvAx330z2I+87mLEZ5SMTsd1s1x+YYpzNoIvsDZmjXisPHwwZ3KlGs0xdzZ?=
 =?us-ascii?Q?ykMJkzmjaiHZZkHwkLi8VcncTXPy+/df3eZ8twWnXJu1dxmxlYxRbD/wynIC?=
 =?us-ascii?Q?XzSUNsXh2P82fRK3o+CHGfRxfizuK1TOFogw5o/12dI8KomS7Hzg7jY8G1xN?=
 =?us-ascii?Q?+l8H3LLm3Kc4Eyg7qFtkhTnOFwqSgYTsEICgMhnaERMYGp1ABEveuvF8/P2I?=
 =?us-ascii?Q?eyGgClogyQLBp8JePSecVbQWoBLdZc/LrDJNJgLzjqoNti8CHYJXIoygPTLd?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4Xi5F3t4mfE7Dca88vlSNLik6sJH26aet6aKdROmErE7QhEy7r5wqb+E/LNFesamG4KYb47DhUQFjzUZk6OuypQYei0a1VDJffjZ/udTcXOAo5uonExOLOkd1+lsxt5sqLNkuT+X+afKkPYrV6KFegpkrsWl6npk6D9TAApT5U8qr81zEL7ix476bjUtMS4FrmEmB6Ko5Mw7CWxC0dtzeqiP0MUoTalY2owdrmqK4CfGBXHR9dE+R1O+/6ZwQOZ+nQIer0LWsCZApAHZoN/M+prDr9eeqDimSCkOYPmZUM4uwuyNHS0VK/trFuzZGoewgGml1mGcRh+LkEedTvt0MbSY3m/7LPoyKtHoacX1NXLb0nUnjHVHR5uhMRGhGfpE8ZKwA/vOtgwe3rvUf1pDerMFkOgUpN8mVGGAGG5vthmSffcieCNdf+LtHshQJvXxA8wa6w1wCO+VljzeRqn9jI6Imv4KbEXtPsquoWP0lAZWfUkz3ryHU6puMAtIPXc7PUTje7oUaL/tV4frhS/5kpmJgpHbw8AlRuQuT+uXgXG5qjcZRARMNAbM7jGd0DCz5YrlR5+4Lc1X6N7GTF9wn3m3qVmgWBDWEhy1qcPb/X4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4216e467-8a5b-4f7e-393b-08de207dd146
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 17:23:08.8754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0YfAf6Hwh01AM7SHVhQWesZAWcUQpWdkE834aiPkSoQxdlNNzYP1Z/BphgAJ06TTkOCio0hdJFVlc/yxSQExVcWKjFClHriGKUQpzqEIQr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100147
X-Proofpoint-GUID: E-zrNWCmjy-N8mGJ7SkcTOMNb1nu7Fkz
X-Authority-Analysis: v=2.4 cv=L7cQguT8 c=1 sm=1 tr=0 ts=69121f81 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Wu5hNObr_TVTc6B2G3wA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE0MSBTYWx0ZWRfXzMaGdxqnqf+p
 oFYRA6+VweQ65jgsD0GqSeFniv0mMMk4nffdqvzu9KzdYN6o59p6B1oreJKUHjrSFF9bufP62zs
 uZ2+HsnlSW2tLjymewNyg0yQC018UQS1bDGV2NCyY0F053Jv+9Yu+qcHyM9TGzoc+OlzSSGp0cu
 G3v4EzW6L/mwPMb0KxcfnpOx9HpdgXfc7Efyizv0U1gLZVIXdsYlRQSRFfIU1zsJ+l+AsOsLv5Z
 NGE3SqfL5PEYnGUVDShaGBicGhpGY9vjol1hxB/AS3nYa92uyAovhTq6ienqKYUJYCTDa+2GPvy
 H/actY8B8Nd9AfImta5/JcRDmpoPJIA88+U9GNqG/6O1dM5nGRS3jdHBkWa44xk3IzoDZ7XGtVn
 7NztOG4aVVxcCGaR1aOcCygYqqWJvg==
X-Proofpoint-ORIG-GUID: E-zrNWCmjy-N8mGJ7SkcTOMNb1nu7Fkz
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0729B2000F
X-Stat-Signature: adpxcdj7ukxe9twhiswy4bkc45gdxdhk
X-HE-Tag: 1762795397-278368
X-HE-Meta: U2FsdGVkX18FbLPX2s1LbG8LdrgdEUOVDbnHswe5+MWPBUV5kxpYOtShUZ8aNRRdtn6WjV08efoys/z+zACibHazHKV8umwvtnmuiKYys+hTVJ27QJTF0pYByHjGoehGlYzYqrkb2Bgz1gpgdOiS/XN6+I9pv10wh0SgeoQY5pWVYubCImNhYsQuHG/wgAI+aUwyo5g2PHT9bdgINlVQXoAVUCkVOpBwEi9Lr4GWoN8uD1Qkf8P48YRHyq7/Cmz9660mQxzPPimMf00Mi8UCe9mpo2h7ECcPGEkYlZgxKsNH9Ctw+eTagInpeoACcA5RVJb3MA+1Jx2A8MGgAlJEcWfJ7QV5sX5lzZU5Wua22wYXeMjHebb9bUsc4F3kwNXFzub1kNLU473tddeHMIsGRXMMgyqd9um+nrMWFiK1VzT2Jb8QK/F6JB+UDSKU3jEAO3oqtl60Xnixt/oZw+uthtIQhwAo053pzGK9R0M2W5dCUJ/6P3pU6sHs+paiRywMteMJ7mhuYzuqPo3YbNZxho9VW0EhyhXByPPSKiFK6LAOLKXGr73/QzFsPm5VU3a32DgQpsgD+9xgSAvbzavyx3OXFpnXjNO5WYzC9Hkyu93+sESChoRJUsTc0MpeJuNS0YZHH9H5GSgy4H05ba75j5U9iPD65s83i/DkEh881mBV1PEc2YEJ8OdT5ufBx6ODHUyIHyt21/Gd62Sj9Qe8V12iVe+LHJvcfLNDzX/BsSQJk4M5ci4J2xyHVqPG886luKHnw6fJTFP/SdccLymtow+9AyQhRRkobsSPASEBxZ84GylVyCPb7k2cvAFOnSgOmcwFerMcAJLWkzTxihnqyOew1jRvCj9OUhqj9iUZkh/PpuE4qEIp9A1zOGLN3UCujSRDHfGhdsuAlsuJ91uV4k9MpIVihkMi5sopP8AL2QtbSOfBNSzUptsD2VQkeZm1qVxwCMRYEiD5OqVl5ix
 jwLsmBL8
 7WRQkS5Fxe8SI3wQ52Hm/VwaTxU4TJ2Eaki7jGpsuPmGuWdmpKzbt3dOS6RKfmh9Xke/6CQJCuHfva++kHBwKFvpRn/ZAyVP42VcAe11otYPqmngD1qd+ZZk8lTegx1lLp99iIaD1736RwStmgaZDZn6V1jS1Qwt4PlYZWQN4pNYbNjgJRDTEvTYwL3cGt+Q0cCDqfZzStvmHMVe5+QfFkoLAxKt9SwYpG95c7G28mWzCf5Eg4aJzBMkQdUWolf5VsrFuKz3vaG6IZu2R65EOYCLCBxPK3n7NpOXS5KB0DQDZph1FZ5wGq8G271JIHF5vTeeyksrZI9eBj0aHH9OqvfoeanlQiYt4wNNoYkAWin6q6p5Tf/pTaWeyjpVuzYEOUV4vDqyr70X5Sbc8hztX3+tnql+yrObuEmu6W301jC6TN4hCC2Mt4e1rXXsM43srlv5PYwrzlWoe0UBL1bUsunDDXjdvkvyZ49nfMAywy0Zb571yCz/D5TvhBrecs3hfcbUXTn2IBr/BxupNdxEjAt/qdwi8Fot6YXlHcMFNv+jcc4TpOmxNWAPsjZbslG/h0sD60kbmYG/RgRm0gpfY8LCZ8JsgTRaT1ocGNiZzfbjbOUMIuuaIh8A/a46A3EFC/UcUuZPnqzBKaUY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We only need to keep the page table stable so we can perform this operation
under the VMA lock. PTE installation is stabilised via the PTE lock.

One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
lock. We can account for this by adapting the VMA locking logic to
explicitly check for this case and prevent a VMA lock from being acquired
should it be the case.

This check is safe, as while we might be raced on anon_vma installation,
this would simply make the check conservative, there's no way for us to see
an anon_vma and then for it to be cleared, as doing so requires the
mmap/VMA write lock.

We abstract the VMA lock validity logic to is_vma_lock_sufficient() for
this purpose, and add prepares_anon_vma() to abstract the anon_vma logic.

In order to do this we need to have a way of installing page tables
explicitly for an identified VMA, so we export walk_page_range_vma() in an
unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
read lock be taken.

We additionally update the comments in madvise_guard_install() to more
accurately reflect the cases in which the logic may be reattempted,
specifically THP huge pages being present.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h |   3 ++
 mm/madvise.c  | 110 ++++++++++++++++++++++++++++++++++++--------------
 mm/pagewalk.c |  17 +++++---
 3 files changed, 94 insertions(+), 36 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 479234b39394..3702fe4a4bac 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1655,6 +1655,9 @@ static inline void accept_page(struct page *page)
 int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
+int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops,
+		void *private);
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd, void *private);
diff --git a/mm/madvise.c b/mm/madvise.c
index 7b938ff44be2..8bf885b00ff8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1120,18 +1120,17 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
 	return 0;
 }
 
-static const struct mm_walk_ops guard_install_walk_ops = {
-	.pud_entry		= guard_install_pud_entry,
-	.pmd_entry		= guard_install_pmd_entry,
-	.pte_entry		= guard_install_pte_entry,
-	.install_pte		= guard_install_set_pte,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops walk_ops = {
+		.pud_entry	= guard_install_pud_entry,
+		.pmd_entry	= guard_install_pmd_entry,
+		.pte_entry	= guard_install_pte_entry,
+		.install_pte	= guard_install_set_pte,
+		.walk_lock	= get_walk_lock(madv_behavior->lock_mode),
+	};
 	long err;
 	int i;
 
@@ -1148,8 +1147,14 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	/*
 	 * If anonymous and we are establishing page tables the VMA ought to
 	 * have an anon_vma associated with it.
+	 *
+	 * We will hold an mmap read lock if this is necessary, this is checked
+	 * as part of the VMA lock logic.
 	 */
 	if (vma_is_anonymous(vma)) {
+		VM_WARN_ON_ONCE(!vma->anon_vma &&
+				madv_behavior->lock_mode != MADVISE_MMAP_READ_LOCK);
+
 		err = anon_vma_prepare(vma);
 		if (err)
 			return err;
@@ -1157,12 +1162,14 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 
 	/*
 	 * Optimistically try to install the guard marker pages first. If any
-	 * non-guard pages are encountered, give up and zap the range before
-	 * trying again.
+	 * non-guard pages or THP huge pages are encountered, give up and zap
+	 * the range before trying again.
 	 *
 	 * We try a few times before giving up and releasing back to userland to
-	 * loop around, releasing locks in the process to avoid contention. This
-	 * would only happen if there was a great many racing page faults.
+	 * loop around, releasing locks in the process to avoid contention.
+	 *
+	 * This would only happen due to races with e.g. page faults or
+	 * khugepaged.
 	 *
 	 * In most cases we should simply install the guard markers immediately
 	 * with no zap or looping.
@@ -1171,8 +1178,13 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
-				range->end, &guard_install_walk_ops, &nr_pages);
+		if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK)
+			err = walk_page_range_vma_unsafe(madv_behavior->vma,
+					range->start, range->end, &walk_ops,
+					&nr_pages);
+		else
+			err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
+					range->end, &walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
 
@@ -1193,8 +1205,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	}
 
 	/*
-	 * We were unable to install the guard pages due to being raced by page
-	 * faults. This should not happen ordinarily. We return to userspace and
+	 * We were unable to install the guard pages, return to userspace and
 	 * immediately retry, relieving lock contention.
 	 */
 	return restart_syscall();
@@ -1238,17 +1249,16 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
-static const struct mm_walk_ops guard_remove_walk_ops = {
-	.pud_entry		= guard_remove_pud_entry,
-	.pmd_entry		= guard_remove_pmd_entry,
-	.pte_entry		= guard_remove_pte_entry,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 static long madvise_guard_remove(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops wallk_ops = {
+		.pud_entry = guard_remove_pud_entry,
+		.pmd_entry = guard_remove_pmd_entry,
+		.pte_entry = guard_remove_pte_entry,
+		.walk_lock = get_walk_lock(madv_behavior->lock_mode),
+	};
 
 	/*
 	 * We're ok with removing guards in mlock()'d ranges, as this is a
@@ -1258,7 +1268,7 @@ static long madvise_guard_remove(struct madvise_behavior *madv_behavior)
 		return -EINVAL;
 
 	return walk_page_range_vma(vma, range->start, range->end,
-			       &guard_remove_walk_ops, NULL);
+				   &wallk_ops, NULL);
 }
 
 #ifdef CONFIG_64BIT
@@ -1571,6 +1581,47 @@ static bool process_madvise_remote_valid(int behavior)
 	}
 }
 
+/* Does this operation invoke anon_vma_prepare()? */
+static bool prepares_anon_vma(int behavior)
+{
+	switch (behavior) {
+	case MADV_GUARD_INSTALL:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * We have acquired a VMA read lock, is the VMA valid to be madvise'd under VMA
+ * read lock only now we have a VMA to examine?
+ */
+static bool is_vma_lock_sufficient(struct vm_area_struct *vma,
+		struct madvise_behavior *madv_behavior)
+{
+	/* Must span only a single VMA.*/
+	if (madv_behavior->range.end > vma->vm_end)
+		return false;
+	/* Remote processes unsupported. */
+	if (current->mm != vma->vm_mm)
+		return false;
+	/* Userfaultfd unsupported. */
+	if (userfaultfd_armed(vma))
+		return false;
+	/*
+	 * anon_vma_prepare() explicitly requires an mmap lock for
+	 * serialisation, so we cannot use a VMA lock in this case.
+	 *
+	 * Note we might race with anon_vma being set, however this makes this
+	 * check overly paranoid which is safe.
+	 */
+	if (vma_is_anonymous(vma) &&
+	    prepares_anon_vma(madv_behavior->behavior) && !vma->anon_vma)
+		return false;
+
+	return true;
+}
+
 /*
  * Try to acquire a VMA read lock if possible.
  *
@@ -1592,15 +1643,12 @@ static bool try_vma_read_lock(struct madvise_behavior *madv_behavior)
 	vma = lock_vma_under_rcu(mm, madv_behavior->range.start);
 	if (!vma)
 		goto take_mmap_read_lock;
-	/*
-	 * Must span only a single VMA; uffd and remote processes are
-	 * unsupported.
-	 */
-	if (madv_behavior->range.end > vma->vm_end || current->mm != mm ||
-	    userfaultfd_armed(vma)) {
+
+	if (!is_vma_lock_sufficient(vma, madv_behavior)) {
 		vma_end_read(vma);
 		goto take_mmap_read_lock;
 	}
+
 	madv_behavior->vma = vma;
 	return true;
 
@@ -1713,9 +1761,9 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
+		return MADVISE_MMAP_READ_LOCK;
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
-		return MADVISE_MMAP_READ_LOCK;
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index ab29b16abd2c..9ddb10359fa9 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -694,9 +694,8 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 	return walk_pgd_range(start, end, &walk);
 }
 
-int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
-			unsigned long end, const struct mm_walk_ops *ops,
-			void *private)
+int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops, void *private)
 {
 	struct mm_walk walk = {
 		.ops		= ops,
@@ -709,14 +708,22 @@ int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 	if (start < vma->vm_start || end > vma->vm_end)
 		return -EINVAL;
-	if (!check_ops_safe(ops))
-		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
 	process_vma_walk_lock(vma, ops->walk_lock);
 	return __walk_page_range(start, end, &walk);
 }
 
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private)
+{
+	if (!check_ops_safe(ops))
+		return -EINVAL;
+
+	return walk_page_range_vma_unsafe(vma, start, end, ops, private);
+}
+
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private)
 {
-- 
2.51.0


