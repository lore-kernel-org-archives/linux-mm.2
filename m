Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680F9CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 16:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E798E0005; Wed, 24 Sep 2025 12:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EC08E0001; Wed, 24 Sep 2025 12:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616808E0005; Wed, 24 Sep 2025 12:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 479E08E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:33:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5017BC0F7
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:33:39 +0000 (UTC)
X-FDA: 83924689758.23.CF1506E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25919C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:33:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="muRmMe/v";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758731617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6hS4iPqa3jt+PuId8Sr0WlnHDzCqrTrfbrck3rBKPg=;
	b=Oge0T40n+yK953l1ZfMszvE5XfQbe9Q4cEXujUVkkSuRcIfkjAQYHI84KCBXjO4JaHDN/D
	TA8ILeOgo54y01egdgKEvZi4ImjjKoxhNNgjQgRXU8CLnI9qZO0i6Z52LQQ1Zxo5Iu0FkC
	VIjuYRUKRhglecKPyJQFrCAa/Sq5cco=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="muRmMe/v";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758731617; a=rsa-sha256;
	cv=pass;
	b=EHfU1u+1xPUzN7pD47c9OW7yjeo/d52u/Jb4QV6Wo1x9Rc0fflt1c98ulIcXMcskuxHPsz
	nFH+ZbTwT6Px7x3iW6jNh+iwpeCOjk/zHreSr815/Ef4b11sWmO92OvOIxf0dlIh814N8J
	9/1ia9hftIgPX+4q70S5f8gOeSC6YhA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QnpiwXdiZMvtEYyvVexxxOckPrce6P/Fomm5r8zVsT8GOpB2pGK9X0TXQOqopG6QFn/JaBR6X15iC8IqAtI62zQOifqnJeF6p1z0b7A8iljv5O7/lZLTqgZDjPEO1weMfJGKepW60hjFyFBhWW6Syo31OS394mMiMU3Jn9JqPJEC123AgXFA+K/aTjaaVo8C+3UNUfl0U0f9lBolViA1lI1g9rPyWNFe7KT3d3VlGI9WVSD791s238Jh94cTZZzB3bIwcWGZXRNXqagzxdJ+gaLOr09ikal2TPqllWLFxk1FEMqke+ZgPUMFsNR7W+MqYocfpLLXbAbSPtXxtoODXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6hS4iPqa3jt+PuId8Sr0WlnHDzCqrTrfbrck3rBKPg=;
 b=hPrYwP+sH8bKwoNkCPuK7j+J+yV6bzx0G7g4lKE+DPFeaO61EedlX4Q1SZTll096hjaBoKyT1NZQy+Oo+60HuOi0QGxdbVUgFSjn9702GCEL2NEH3dlzCiXiuw14MMzYERLJpa+ZbD8SXj7LdAmsFZnPK6PuXrX45sHe4Gdxm8FbMTmNBAGI5tXrDxTS2TMzecsLoWIauE48HojQzu+Z6dI4btf8yVRUHtNgD/0nYtYJJAY7CxY14GknBHWUqE5wKQYDTCRtQK+D5E0+KgQ7NVv/pXA0UGkJkzOVnSu5j5ZN/p69Sej4wlZvo4WIPU/yHJRwTy3dNm32HN+aHwr2TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6hS4iPqa3jt+PuId8Sr0WlnHDzCqrTrfbrck3rBKPg=;
 b=muRmMe/vLpr+Al5eL0RzWSm7l6qcyx6qerKA0SBfS2kV0yVIevJB4RXIpedH2f2Rx+xrt0TJGclr18aiUnofmz5vOd21Ru4r9tzNFjCed7iB6eL7ntOC3VR93gf6b1JmYSKGdm4wvjJwu2k74zRTZgeksVibppIJ49Yt6rndwEJRtuSqu8qkjDABk3YLczAmAryiPX3r7ckjH5DcmCFlg7TAFwoqAbAU4GsWje0v+OAu96Q/TYFbxX7X/Z5HU9haEJUMXXCjiV9pwvU86UDLhoCEVTlimz3EiAdeL8hsY2rCT1zy7cSSgPXIUANAvD3lStZ/aHs7LMddPSFFUt+bwA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9644.namprd12.prod.outlook.com (2603:10b6:408:296::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Wed, 24 Sep 2025 16:33:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Wed, 24 Sep 2025
 16:33:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Wed, 24 Sep 2025 12:33:30 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
In-Reply-To: <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:408:e8::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9644:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a61541c-29bc-4e75-fa56-08ddfb881a05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4c8Jju5TiJWecCtFdsP32oK1dGWzF++9Ke+lvYdg+SbWceJMKnt9SKN20TIb?=
 =?us-ascii?Q?BBl0/0Kh8lpboQ3s2WJ46rE1+OtDGjczEtxTE+J9fp8Br9Wi8aGAZhMvAwEn?=
 =?us-ascii?Q?HPEg/NVfFC/3b4bOzSxKeF1+umpSbsT0PIxzIJhF8t7ywC5o1XEAYV3w4/yr?=
 =?us-ascii?Q?/48lR9xOSp5S9nU5WE6LXDlXebKC4hnOv6oYYT+uudpIxN7XI8WJYuzRjxaO?=
 =?us-ascii?Q?zqWLYU6a44mZDzZjyP4wlZUGkniZBRaTOMt76uYMOn9suRnvOh66NltYYzeM?=
 =?us-ascii?Q?qmy+IiABKic4dUHC+h1R9aykV+zvtD+PsMW9g0x+IjrJNunIaNsq1NsKeEIz?=
 =?us-ascii?Q?7aAetGIn8HNVylk89ULOUa4t6KNtWvFBOiCKzcZC8j8xnuhTfbcJX8hv90pN?=
 =?us-ascii?Q?vDdikbasLuLB9GzKjDygs2D6P/H0405bXS6xhS1ZUFwOGIIzPzzRSLEAbV9C?=
 =?us-ascii?Q?PUcyyXSyyHAx8CTbLNLp3Ul4qKwIzXlW3/T9I7TRLoD0WqirdpJDVLLIQnRV?=
 =?us-ascii?Q?1HFZbhac219BLP7y0DUrg11C67r14xPXK/jtqs/hLmA9uwHAfpe78znsU/+v?=
 =?us-ascii?Q?Bqt4QXV8+xDyp6MKXPmPIwgOPeg02aBokV8wg109Ofar86G74puWoBDFDQ59?=
 =?us-ascii?Q?FLsp394rjh7WKwGBPabT08eThW+Nik56/N6DHey1OwkKVwyrNUMPXcQKX5UE?=
 =?us-ascii?Q?GbfIit+cNZE5GUL8jEeuzF5TYcbNs3QKvv9yGGxFGD5JTC1tq2ddqqaAIxgU?=
 =?us-ascii?Q?xOZV0oVW8cOgmgflSHul8nquhLXMJhrb83lJKR1oeAg2IrakBC3UzZrJ1wXX?=
 =?us-ascii?Q?fuqyVWJTVzIDkpkUH13LEWpcixtE07FDZ7k75PXS5lUuCeP51BRiX9YHbWcW?=
 =?us-ascii?Q?IDOWE+d+jr90HmtOHTZqGC0qx/9oNySq0Sz5G58gGHIqHTSflmj0H8ZR1bTe?=
 =?us-ascii?Q?yXo+iNwytrQl1NolPqvLLustfIoBJgTNDwNXs/lyDhc2C5JtvIbFKQzbiVsL?=
 =?us-ascii?Q?wnTfbG4xUvgtHgh7NpOo0us1OBIn61Iq8EYqcRSluFbiJbFO933Fe8BkhmgN?=
 =?us-ascii?Q?Zqu+FtdfQQFZyAR/NgnNmTz/MpHVbPSFxYDcI+KoqdD9QJS7KRzDopBVKn5J?=
 =?us-ascii?Q?EfyQApdTYJ5kaQ3J1B5U5eLbI/Uc9Ca2WIDzIHRnRWgfeV8yzpWNR65X0VMB?=
 =?us-ascii?Q?GmOHDoEXoVY3SX9WXqEnkSrgEhEuVIXH4Nj5f45GjRt5R3OIcT2zoWSMjxVH?=
 =?us-ascii?Q?0yhK4qlI8+b6N90pAiH6QWnsYzqHO8v723lualk0zCowk5HFaPa3pH1ZNK+t?=
 =?us-ascii?Q?b9D7Vbm5XHDfFrtM8KCh4w51nP7vTVZgIxHtVkqMwRqGRs9ITrzWGAr6KLQH?=
 =?us-ascii?Q?qotfvzG+Wft5TLHdywuTpp5akl1ZjsGnmVDEqc1g8Aqdb5GG2yu2j8U2pfb4?=
 =?us-ascii?Q?DFgp3q3YbKA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sj3ca7SHEbwN42L4U9Q3wYd8CjK3yUHhln2bfGJ9nId7UfyuUGoury8isOAj?=
 =?us-ascii?Q?muxGtRoLTRa7GfhlDHvUm9Ea3k6QactSkH3isWtrNvpapV1CR4VUkmY6bquW?=
 =?us-ascii?Q?XrzoGrCGIEaofd9XUkr6TLgiCvD2DM/JUtaeDc9jANYOclRszWvNNpmKviJD?=
 =?us-ascii?Q?XXXHdwLWqZGDlzoqsJBTtMIkjjgCojFZ3LrQctpiIi55RgkT+84+rHH2Ktf0?=
 =?us-ascii?Q?RJRZt2MenC+DWlEgETcACpNEOSOXYsuhbDTB43Onoy2vFr57xjXgXGF4YpLX?=
 =?us-ascii?Q?U1dXd2OcyqBlcmvAU2VA+E5YbrH5Emb2vBJ3w3lRLa3yNN1ZBGbaoxDefO5i?=
 =?us-ascii?Q?0kS+SrGlNfvDjmM4Hic0jbKN0K+5fGfY1fMohyd6a0kvw6HBjzMbsO0Hd7Z6?=
 =?us-ascii?Q?S3HIDGxZSQ8S6Fw/L7/bcVyOQKZYxUwC9fevhn/zLsAh4B03E0DQnkbsZBBw?=
 =?us-ascii?Q?Mpj9g/3bjOU42lTCeou+sNuJlxBLPPGGDkGplJHkfdr1F7/vREqzIydrjvsG?=
 =?us-ascii?Q?ow0xjsJ5klS5IqaRGBTpFovHpizfeJkQc331SBM8s+KzOaS7icN3cWweEqYo?=
 =?us-ascii?Q?B4kIBZNufpafy3I6tbV8xfprORHrvwjN0ssMeSyR/+DIKoAmvug0y5K+08LR?=
 =?us-ascii?Q?NPCbxsLjKCy7k2sfQxvPWd0bmqaaGTv+H7A+koCvHFlUcB50XQdo+MVgw35I?=
 =?us-ascii?Q?Ny5WcJ3r1BFYW+OSaeTyns/ys/Uo4sRMSnbPJMcT56VYpKiQDJReoiOzzlxF?=
 =?us-ascii?Q?SSuRFvzfHm1se3GS2TtukBk6pewAP+uxBwlnVcBsqyvtYqTGiJ1chxB5tJKY?=
 =?us-ascii?Q?kuYQxCxuvB+n3h38QDtm0zwiO/3mbctarmHWkc4bpDKwIMMXKiGjLFrLfrop?=
 =?us-ascii?Q?xH0PCRiQw88z8oACeJ+AvQ+cU6Tgffhebe+vT40IkGr/HGhxLf4drPzzdoY+?=
 =?us-ascii?Q?7iTCajJDvZhWz/rGb1Z4Yj3kFEaUvH2CInY3CAOiXR8RQIhNhPHLppeAFLHk?=
 =?us-ascii?Q?mDYW2RPD7kwTwwqF0WbNbfigtURU5Gq5PXILUmfkfk57+3UKMeBzchYQN+B9?=
 =?us-ascii?Q?VMNSQpNdw27kzLt6vl4pGDEfU2pPkh2KfkK+bmEJxCTAV83E6SjLr9KcSQIC?=
 =?us-ascii?Q?ujoPr5RpS+iSt276sHLfb1QEi7CYasmrytjcgk36kEtbwoeAsgpVzKCNc6EL?=
 =?us-ascii?Q?pyRwJOMp/6wHcRcWjzvcmSqLzEef6RG3/DlDwU/7qIrO9Hd3F71gg0jDyA1w?=
 =?us-ascii?Q?5XJYMgD85QsP/As05wPPSqn2gs4xCzjqDy5JhGIUqRd+XAnEOsi5qecragsz?=
 =?us-ascii?Q?MmBwiITX94Wqx+CV3at2PMhXqWrwebrD3vhW7WwpnmsBdoQn9sWVjIwLXPZU?=
 =?us-ascii?Q?exM4aSd0cVbuqdDWeX4JKAR7aDskdWBbvVt3CBi3FTz09Qi5l4cONQZZDcA9?=
 =?us-ascii?Q?O7w1LXnCVE/nXLjWROb0pqk1fIzYDBawwQbQWpCcegv944VgAUpQdpnIV9ec?=
 =?us-ascii?Q?BKzhGXvP7yDczmSPXQJ4NXbbmpSAK2vqvYfM4gDsu8wQPm6IpxOIuC6aKO1r?=
 =?us-ascii?Q?lUX+QgzYs1yj+VF7y/MUZWstZHgyyBN6tjlTkKvT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a61541c-29bc-4e75-fa56-08ddfb881a05
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 16:33:32.8631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2ep0VvndqJJfyRCm4lLYPJaY56wltDgr/lsdiSqP/23mIPMxJq6TQJDG5mEwK3h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9644
X-Rspamd-Queue-Id: 25919C000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 99p9c5oywwh61s6fa8uq9dyqsuo5ty6j
X-Rspam-User: 
X-HE-Tag: 1758731617-547227
X-HE-Meta: U2FsdGVkX1+rg9kbXCOTpuRHvLV2BtBq734stvLyooYp/g2401BjbgiX7Hv0edWuC9m637f/3uuWgjaTeo1+uQ/MawDPn1WQdI5wrAvjvEXsZvWcFf+cRNS4rbenLL94fhRhEWFVpvSx7D078rnuL+xhKoCIgtq6vip7vEgsMwUX1FNhXpC6B27sEyuPUT3y2wWdy5BI33De+6dxUbFT2h2kwTtNDbAeeLVfCFRDU5CTIF1sdJ8hVDaxrW4QOfYKlrObKBfIOBZjHhtRPVZ9JADRnis+9SS4htbBRLU76GMxN/X+N82zV0xrx9ejdYIoMi6Qmk/nasb/FZ0KsVMlyUfO8MSmvh5XA0FGoFvzPZLZlxHDrt3V7+q160NlEfBVqyU4w4T4XgIkeX90R+LWEAKy9uv/rqOB/wHUTTA3SuIOg2Yael3hAdBa7yB1eD+Xue6UA0ftKMXH10sVtT+rXkolD+aysrQJFTqthFu4ZmrvzyBKcs+ha7/Al6WC4bX05cnlmqyOc0nKPSmBeszUs2ix0A65cS/P5OvG1LbXmsBEsY0CTmUCGB/n5W3p2IAvYhPoNIJcnC0Fk3t1nk00kzLDCJPiktUQ1rDuY73jzbCg6RvyMQc+pKgAJgD99KbMdSM2TxFBgUJ8RG6k5q7hTr6E612W7kPatCSYoZSgdDsEGOuf1fTpT5XWn2haWfU7o1dme6YFVC+oOd2sdUDDbJT1SJ8gfB6iplsuk74FF6pnkB12ItlEQQ33+r0YTaidlEZURVQwLn0HOqzjUfM7PP7z+j4hTbRGRNCZoGANzyYeC3scFXfhvUSOiV24dPh9IUw6fW5n3vFrU+Dp0jH+bRKfa3+Z9LJOzmeI35Bvx+cMMDUooDFQ6kuqXqIbQcsZ0cgXWxXByt0TM1jJ4f3S4v4s0+elkkbR7yEFHZShk+9e5Dcj5DfKn9ftSwj+Avhu8m8aXKOGgOk/u1IlXy0
 RBjnv462
 9lXr8S+RO5WdPI2ShS2Xl4mCWV9mwjSFJX/52Mho9rRwMQkeK2dPV90hwUzo76MyHGIWlZPjNW3viJoxMUmORYFqt0cBRqs3Lq0XZOZq1kROl4m4P6VQaDf6NU84o9yexPl9vE2sba8x/RojVv0dB/Ab08dNlv34v7oz5OUH+d/9EQAbBjT+v9VWACSk8o1/xp4AHg9mBGfzqN+Dc8WukVPKwXCPAr3nFOUGkz6+MOGoPJ73S9XEgSvgyQaR1V4jl/yq3ZfiR3uSWiZBo57UZyK1qUZcnZbUFPm3GcywmjcSrQcERYdQjnm9yHuwCZam4/XpTSurpvTSRd3Aprc6xAF7Bgb/TEN0eBAn2awUI3YKoRjxEK8NTlrXMPsLbbWsLqpXdycLs2d3xKbMxM5GL6k5U1cZ59MMACG9JAeiRsRyqWOVSof1UljqmnEEWHhs/IiWxV6QzvM2NSvMgR3YAw+/KRu7xYnh/h6eRjW/DZsBdOxobY0RQt7Ryr2Vzh+yvCj8HUbtXIOpq4266aZVc7ciAQnz/plRxiE6fog0SyUzIIpXYQ/Ea1aWk6xFyZX0U+tDUaq1vGOZY0ahbMFoFUwG2mnwGyqLBJCvsapJB3gb/OJa20DtITru86NKbhPICWhOv560KX8/tbjZxI9CMCP2ZRgK2m+hI60JM7WDC8RL8u4naWq/XcYVfBPw4cAniX8Tgz1nEOkHISoVg7uZ2lydguGUxY9ox7Lk/EIfu+wPTFEcwrOPb/uN+kHgWgzqf/W/iFkm2q/6CwEnT965x8pUuUtmympI4CYjSpzOSfbU/BwsSBmvk0l86t2HKMByyOlot1RLnz06Ejext1tMu4d8OKy75bK1F3eJpIlTDaZMWEzH1mRhpTeDzrKbhzjQ2qHZ/zGbQ4NaK+uKWvfCEukw41Rco0d4HyOSW8K08OeueZmIMMOdfyk2ewhRqMMb40Opx6B1rSaDTk9mWUXrw19uWnv1r
 G9uHu+VS
 ul5kHBdrqEYb+G097CYgdMNGf7PsygbQ//j0vjZCDFeSJCy9Cu6e7NJItEtsecql+EwgJawLaemTka8lro95j7YdxuqWDGUsnVI8bfNUbQ4VnGO9Wr1NddPqALOPdcE0hH/ia8Esd+xB3aNiYFNcuSRloPeXHjj1VnlUilPUVxpbdx8ma/aafaYczvxnE/IV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Sep 2025, at 11:35, David Hildenbrand wrote:

> On 24.09.25 17:03, Zi Yan wrote:
>> On 24 Sep 2025, at 7:32, David Hildenbrand wrote:
>>
>>> On 23.09.25 18:22, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    b5db4add5e77 Merge branch 'for-next/core' into for-k=
ernelci
>>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/=
linux.git for-kernelci
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10edb8e2=
580000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd2ae34a0=
711ff2f1
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3De6367ea2fd=
ab6ed46056
>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f90=
9b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>> userspace arch: arm64
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14160f=
12580000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1361627c=
580000
>>>>
>>>> Downloadable assets:
>>>> disk image: https://storage.googleapis.com/syzbot-assets/6eee2232d5c=
1/disk-b5db4add.raw.xz
>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/a8b00f2f1234/v=
mlinux-b5db4add.xz
>>>> kernel image: https://storage.googleapis.com/syzbot-assets/fc0d466f1=
56c/Image-b5db4add.gz.xz
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the=
 commit:
>>>> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
>>>>
>>>> Injecting memory failure for pfn 0x104000 at process virtual address=
 0x20000000
>>>> ------------[ cut here ]------------
>>>> WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure=
+0x18ec/0x1db4 mm/memory-failure.c:2391
>>>> Modules linked in:
>>>> CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Not tainted syzkaller #0 PREE=
MPT
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, B=
IOS Google 06/30/2025
>>>> pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
>>>> pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
>>>> lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
>>>> sp : ffff8000a41478c0
>>>> x29: ffff8000a41479a0 x28: 05ffc00000200868 x27: ffff700014828f20
>>>> x26: 1fffffbff8620001 x25: 05ffc0000020086d x24: 1fffffbff8620000
>>>> x23: fffffdffc3100008 x22: fffffdffc3100000 x21: fffffdffc3100000
>>>> x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe00033793888
>>>> x17: ffff80008f7ee000 x16: ffff80008052aa64 x15: 0000000000000001
>>>> x14: 1fffffbff8620000 x13: 0000000000000000 x12: 0000000000000000
>>>> x11: ffff7fbff8620001 x10: 0000000000ff0100 x9 : 0000000000000000
>>>> x8 : ffff0000d7eedb80 x7 : ffff800080428910 x6 : 0000000000000000
>>>> x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff800080cf5438
>>>> x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
>>>> Call trace:
>>>>    memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
>>>>    madvise_inject_error mm/madvise.c:1475 [inline]
>>>>    madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
>>>>    do_madvise+0x190/0x248 mm/madvise.c:1978
>>>>    __do_sys_madvise mm/madvise.c:1987 [inline]
>>>>    __se_sys_madvise mm/madvise.c:1985 [inline]
>>>>    __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
>>>>    __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>>>>    invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
>>>>    el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>>>>    do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>>>>    el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
>>>>    el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:=
763
>>>>    el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
>>>
>>> We're running into the
>>>
>>>          WARN_ON(folio_test_large(folio));
>>>
>>> in memory_failure().
>>>
>>> Which is weird because we have the
>>>
>>>          if (folio_test_large(folio)) {
>>>                  /*
>>>                   * The flag must be set after the refcount is bumped=

>>>                   * otherwise it may race with THP split.
>>>                   * And the flag can't be set in get_hwpoison_page() =
since
>>>                   * it is called by soft offline too and it is just c=
alled
>>>                   * for !MF_COUNT_INCREASED.  So here seems to be the=
 best
>>>                   * place.
>>>                   *
>>>                   * Don't need care about the above error handling pa=
ths for
>>>                   * get_hwpoison_page() since they handle either free=
 page
>>>                   * or unhandlable page.  The refcount is bumped iff =
the
>>>                   * page is a valid handlable page.
>>>                   */
>>>                  folio_set_has_hwpoisoned(folio);
>>>                  if (try_to_split_thp_page(p, false) < 0) {
>>>                          res =3D -EHWPOISON;
>>>                          kill_procs_now(p, pfn, flags, folio);
>>>                          put_page(p);
>>>                          action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FA=
ILED);
>>>                          goto unlock_mutex;
>>>                  }
>>>                  VM_BUG_ON_PAGE(!page_count(p), p);
>>>                  folio =3D page_folio(p);
>>>          }
>>>
>>> before it.
>>>
>>> But likely that's what I raised to Zi Yan recently: if try_to_split_t=
hp_page()->split_huge_page()
>>> silently decided to split to something that is not a small folio (the=
 min_order_for_split() bit),
>>> this changed the semantics of the function.
>>>
>>> Likely split_huge_page() should have failed if the min_order makes us=
 not split to order-0,
>>> or there would have to be some "parameter" that tells split_huge_page=
() what expectation (order) the
>>> callers has.
>>>
>>> We can check folio_test_large() after the split, but really, we shoul=
d just not be splitting at
>>> all if it doesn't serve our purpose.
>>
>> But LBS might want to split from a high order to fs min_order.
>
> Yes.
>
>>
>> What I can think of is:
>> 0. split code always does a split to allowed minimal order,
>>     namely max(fs_min_order, order_from_caller);
>
> Wouldn't max mean "allowed maximum order" ?
>
> I guess what you mean is "split to this order or smaller" -- min?

But LBS imposes a fs_min_order that is not 0. When a caller asks
to split to 0, folio split code needs to use fs_min_order instead of 0.
Thus the max.

>
>> 1. if split order cannot reach to order_from_caller, it just return fa=
ils,
>>     so most of the caller will know about it;
>
> Yes, I think this would be the case here: if we cannot split to order-0=
, we can just fail right away.
>
>> 2. for LBS code, when it sees a split failure, it should check the res=
ulting
>>     folio order against fs min_order. If the orders match, it regards =
it as
>>     a success.
>>
>> At least, most of the code does not need to be LBS aware. WDYT?
>
> Is my understand correct that it's either that the caller wants to
>
> (a) Split to order-0 -- no larger folio afterwards.
>
> (b) Split to smallest order possible, which might be the mapping min or=
der.

Right. IIRC, most of callers are (a), since folio split was originally
called by code that cannot handle THPs (now large folios). For (b),
I actually wonder if there exists such a caller.

> If so, we could keep the interface simpler than allowing to specify arb=
itrary orders as request.

We might just need (a), since there is no caller of (b) in kernel, except=

split_folio_to_order() is used for testing. There might be future uses
when kernel wants to convert from THP to mTHP, but it seems that we are
not there yet.



+Luis and Pankaj for their opinions on how LBS is going to use split foli=
o
to any order.

Hi Luis and Pankaj,

It seems that bumping split folio order from 0 to mapping_min_folio_order=
()
instead of simply failing the split folio call gives surprises to some
callers and causes issues like the one reported by this email. I cannot t=
hink
of any situation where failing a folio split does not work. If LBS code
wants to split, it should supply mapping_min_folio_order(), right? Does
such caller exist?

Thanks.


Best Regards,
Yan, Zi

