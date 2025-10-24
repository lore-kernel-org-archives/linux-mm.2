Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7911FCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B688E00F8; Fri, 24 Oct 2025 15:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B548E00C9; Fri, 24 Oct 2025 15:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC3A8E00F8; Fri, 24 Oct 2025 15:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6B238E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:55:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31D5E5DE91
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:55:05 +0000 (UTC)
X-FDA: 84034061370.14.EF2F243
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id E25AA140004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:55:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Jz39KH+1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GRaG8hiC;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761335702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pwbd1bj4EMVC5vkk4YlZoXej+YNOnyNhgUka3SoAUjs=;
	b=ummYkHgOoU46LOOMfwhOUEtDsKXrZ3IziaYEdYtuJfY8nUQQZTB19L6R3XrqU2LqmkOtkG
	aqxN8Xsn9oDOPbvFucEfZcDHJI/ejdOkH70itQcJeCl8Wr6Wh3LUtGDjRNAtP6czikclBj
	8nTOiKB9rp2SgZNKAXP5fSADKdI1fls=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Jz39KH+1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GRaG8hiC;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761335702; a=rsa-sha256;
	cv=pass;
	b=E5B00u/yJ1f9yYzl6ANFie5l6IVaGd5JqFgLhMpyi6UYCiVDAP3bHCG2cXnn1cfyDeTyma
	hOrkoPDNADVMfxFkWMO1oUi51HSDTknbXLZecsxFYCaRavFOc5M/unL2rtyuBF8/N1Ie5L
	L0L1taZfxiVEw6cgtmjLbDqxMSFPcsI=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OINF5s020056;
	Fri, 24 Oct 2025 19:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Pwbd1bj4EMVC5vkk4Y
	lZoXej+YNOnyNhgUka3SoAUjs=; b=Jz39KH+1sW9q2qb3QWI8haCbiKe1xgEMzP
	BcyHn6QgUW5EkCAGAG2gRx4dLKThn4TAzokWxtVN3tzK1tcDZ99OkpeU2FaT16wB
	e5NSoT/CdzxukrdTQa70k+GavOxEpdE8FYcGvb4g0udC9EvRXhKW5U+tINrHZfXa
	XM4iXkq93do5JJhWus8MLLbRZ/5DMPl2RZA9oIu6uocCDeTO3CtZfsv3cRodJShZ
	bjY09qbZzzpa36pC8Jft1N56bBQ/sA+249n5cSBVjBDdtmrXdwEAjLYc0gbbZFT9
	M0ojTW2p8d17DQXaDv4qZQlW5i+GUCFnoyb5gUCMwA6FsX8T/12A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ykah39c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 19:54:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OIAIBm006277;
	Fri, 24 Oct 2025 19:54:54 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012038.outbound.protection.outlook.com [52.101.53.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49xwkauu5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 19:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJeyzmwjAERX3NPLckb9M/XOLuqDcmLvhEHSiemDOf3H66Axu4+8zaClJf450z3c8QeOnIhFQgCErYZlK4orUUwqd4Mqia+2Xn9UODsrphx+ty0sL0vFBTTPZoiixscIw/GDlnd2D30OQ5TlYm2mLUeIVAhMZvCA16Qh39vhQcXAj42antdq3xb4Wxrq/8lXVaquMqlvAPz4KEEz3Cw8vFedMRvMwrggItXkDC1GuMG2axsoHn5PhIRggIQbzqu5bX076fd3FV+rf4aBDRtXgFNX/yM7WeE463WRWWWosZRezbkzqj3KA5ODtDkoGYA2c6jUdpi8Mbe7D3xmceYdrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pwbd1bj4EMVC5vkk4YlZoXej+YNOnyNhgUka3SoAUjs=;
 b=esZM0VrU0TAvY496wTb3iG99lF7hJdEYV5qS9099bBggOEYvf2mfTjlSSLxUDugZ8NlTi+wmhB1ZuBQSP9zdkQZQNVWBvo5oeXR7srhk+/QgVde2Fx1DXu6Eg6ulpp/xt4iTPslerTw7LJbaa9QiUIrRao/RkwIKVCekfUYJEQYGX9JS6kCLZ/0P0spiv4SsAcWOKax/XjXm5kBGhho3qlNiGaZDV5LdkpT4U4U/Bo9pWzW2tyq3Bo8CfgYKng8C+FZfajvD4WJ/wEG+M0e2YPR8MJQBaH1H3EmNvjVCSozPcX3I+uR0eglTd62tzFuyZ5249PgNpc86PCIzHs87Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwbd1bj4EMVC5vkk4YlZoXej+YNOnyNhgUka3SoAUjs=;
 b=GRaG8hiCDZf9yXamFzpjsbIwE3ZHscGzz+eyulsBAe9zkhPv+pQ675p2qS/xhhMFz8nejRV7FW8XmRqxfm3s0Va0ViyL6hZVYuVycKTe8WGk1Ojzda22CYq0sPm6UxassYSXdYht9b9KW1UiXMe3bgD94h/pS8SpWlmg3X0F2JY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6449.namprd10.prod.outlook.com (2603:10b6:806:2a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 19:54:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 19:54:51 +0000
Date: Fri, 24 Oct 2025 20:54:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <34281230-c54e-4e2a-a872-c7ec6e9ed05a@lucifer.local>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
X-ClientProxiedBy: LO4P123CA0538.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: 08c8ac78-e22f-40a2-853d-08de13373203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xgnNs7RPwqTJK7Ev10C7K8aHqqbaVkdrigldsOQka81XNqpFsEOaBX2GiXeY?=
 =?us-ascii?Q?vg3bSns8WpZwNUp+Ia4pmXjH7M2RrdEFpRpYXQZsWPEbJ7pawDDwH8oLhJwI?=
 =?us-ascii?Q?XmfJ0AZZ/GID1xScrLwoIBFBrZwmrc0JIAqIsbABx/lfRd2xwwqOrKGNZwNm?=
 =?us-ascii?Q?XE6NUA/BvTlfSfH4BA787oADzhyBWSj2VmlvWU+oB8H+PF1Mbo1Mafjg8YUZ?=
 =?us-ascii?Q?6FuaNG2TIKgQBEQmfIcOwyNeQiY1JLiFZHmPoe+9WhL8gljPVTWWOV8EMEE8?=
 =?us-ascii?Q?Ncie0YfSteTmItlpE3RnjC7NvPgXkujPHhHC6gvHFUuHYk7i+luIsFYf/t/g?=
 =?us-ascii?Q?zjj5u21n/TYQ3nziX9s//lvUsWpkQOXXBnm4Kc/qH+B6szTQWZq2RfobtyWD?=
 =?us-ascii?Q?FmvTclFhLEOZhIzz8PMhQWxO3qev8Evd2mogiSRGQEY3cOWir5BgtwmfI47e?=
 =?us-ascii?Q?Lp4PzcOfMHYE6yGpyPhTM+jm5s8IKw1ZZErh8DIpFaLAru9iJZpMI40SDVMN?=
 =?us-ascii?Q?UNMwF9GCeStAZZJ6TUq+peWb5Y/blNRIcb6XhoFd2pohK6bxrLlIfodshNMI?=
 =?us-ascii?Q?FSw67v2CxX3QkC0UONf72rFwR1Ku9cIuUrGDYNGYngoVdY0g+37+fxrpLTUy?=
 =?us-ascii?Q?DdZO9T4s7uLtOkOBsPn2HTLrSMDtmvY/tg4QINEsVVDJBDxCqx8Nn+tqGfA1?=
 =?us-ascii?Q?ut6wLhvKFE+JcHyoKAsuAdDTjHX5GtZu+htY6o3g1zTi8TKDRvBFOFYL9Vbs?=
 =?us-ascii?Q?vGljZE0a7ep+8MktmHCicYBfmk8E1AJWJe//pLxKl7jFn0b5heHGJ6HHYuI6?=
 =?us-ascii?Q?YUqTLrEF0dOSEOBa8VR6nknRZrzDNKGvWkBiMpPa9OETAqwOEGPimaQpykrg?=
 =?us-ascii?Q?iKaBFp3pT9dIusvzqbUBeBUhD1aHklbzS42Nbbsj7VKomv9To6e/zOdAujrN?=
 =?us-ascii?Q?XlsshgXUkXoAUUMPw72/Gj4X4JVrnJcWzPONTZkP4cS84I4Ox69D3e7WCjvO?=
 =?us-ascii?Q?5f7G3ky1SqG+c8kcBmHpC6nRTr+mQlKVf55K/1oKrkMnO/Gr7s5aoWWYFSSx?=
 =?us-ascii?Q?pA05D3HhFFxNAwwGMhumq3oTBAaPx+tGMbb1Ls2QtphX/tLGfm3w1nEUmBk4?=
 =?us-ascii?Q?a7Y5LvohpjpB5wxupPgdQ4d149uBq1fGoNgm2g63WEV6buUi490J9ZawfqRI?=
 =?us-ascii?Q?lRTYwAPrnRYlTKyVuVnM76oOe2ZPUqbjN0cUhqRnIn+Lek++OzrF/tsCtP+r?=
 =?us-ascii?Q?rz2Yt1nKYUOwDAg1Ut74FxWs8EKTr5ok0hua1bggsMsCrfBoZMNOtxAKQkTa?=
 =?us-ascii?Q?NBhSJsQE1z8eQuLWW6Jt0Q1AjCvrHCSW9gSJUJie3ZbSdULG6rElWFQ65e6S?=
 =?us-ascii?Q?eTQfiiVh61P0y0HJqrl1mloPo6Y4TDbscPGalBtB6pvO4YtUJiOIUvRigIh0?=
 =?us-ascii?Q?uV0mjJRlyyEIRM6rmjZwLidbjt6d+W1l?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Que5HTtIzjnd3QIckrzM21VfGsFHWSLhypwL5dnnjc2tSgVoLhpenVTYCQH?=
 =?us-ascii?Q?vTZGSBE17pQkWf/+TMcd4XHrfNMFWm4gig8z/G9ksuSiDaoDsvsFsM0iF7b4?=
 =?us-ascii?Q?mrH1SRC56FrbQdXZnm6j05I/NrHVPoscCno8mmr3sSHlbBQULMOVl1WChaOS?=
 =?us-ascii?Q?kZA6/c86U4SpoCDc3M0p/chkSQ797svLfXSL+J5Lex3tPHVQYBhSTdclFdPO?=
 =?us-ascii?Q?lozG1+u/q5YJLU/GGydamWbDZJsBi0iIaofB4xJb21/A9at9Ni272TOTyR6j?=
 =?us-ascii?Q?AaROKI1DJ3xq/v6Nzkj43cJGL94HMCF25LaU84nCScYz7FutHCVXEyYhgb2k?=
 =?us-ascii?Q?+saQvEpBhe0ebMnV5kxIe5DGyqY7x/LOoRPzC3eTxY+88Vpl1h1FXGTp/q24?=
 =?us-ascii?Q?PDY+X0S+RAXROmKhMQvjnc5i6G6i4fFDsyNADyrL917fzMdSbJApOx5ef8Mp?=
 =?us-ascii?Q?CYwb2QlC+pkNSk1MTHItSRwfALBbrg6IBrUHKqhcNNP/oxLUAzHSTbvtyt6x?=
 =?us-ascii?Q?bvyZIeeYDu9fy34/ahTgyoy8sQnmQiH7+leyZ++pzd0XnsQhoZhQu889iK6u?=
 =?us-ascii?Q?jlRN2Fj0+SKjYdL/ate2166uIm+65rAyjkYX3D8YZe67TqVw4ZP5gtwb6tqD?=
 =?us-ascii?Q?vZazANhj/to31kZYWQJYyKVoZYh/QFb9LZ0PVQh3Fhy1h8ZQH9Zj57eaowHf?=
 =?us-ascii?Q?rI61z0dZ0J9CaahjIFutjl0FA8cjGXFAbHAc8zV7OkYPJBDKjOWXD38zToRx?=
 =?us-ascii?Q?sJA3JhmexPuj3r59zuMSRKjbYZES7mWXym3xh+wzQvqtcz+SNMFDhFW+Yl36?=
 =?us-ascii?Q?J0sE8Y4d+AIjuvwLPkAKU0kjJi+SNdPyLdnWwSmv4tAUO0/hFHuOSuWAH4kA?=
 =?us-ascii?Q?BFpks9eZOxYuuYxGsx77dL7C69Owgxt+tscE4sCpZPDXdRCKTssNAP7BaTiU?=
 =?us-ascii?Q?XUNZ/k0cY+ty87saFIX3ztXy/LXs5tSxdc+hA93zvxN4MGsMC9r2KfAcm+BU?=
 =?us-ascii?Q?SrNNExCenXV6mapZlFx1RJ7eTMUiYgnukxF5kqcglrBI3QSwDW/3C5ijeO+G?=
 =?us-ascii?Q?CnTyvsEPq3hcr0xo5wWwwzvTCwoSo04HKp3ZauSklnuueg5mhOIkICicOCWg?=
 =?us-ascii?Q?Ai8wX4IhBns+lTpBfIiQouXHR58KFTiYT++jvzuZXfPcXRIsmxW1KNFNUAz8?=
 =?us-ascii?Q?b/2eFje1bBMWfZ5/FYPbE3f1w9yw4Ud7uXWwOaTRYrVOuQ3cD5VWwNmGaBMy?=
 =?us-ascii?Q?BYsQEC6NCEBGhWRROxWlqHCYflQ9Ux76LoOhvXaphlZMbopEyG12STcy4Sfr?=
 =?us-ascii?Q?1nA/I0L/QMRUg2dhgS3jnTIGdTMEcyfH8WUYctcO+66vkTU7wjak8UX//I1n?=
 =?us-ascii?Q?U0n3+Uq8Oz28mHcU7o9kRppuiyZAZ9a2TGOs9icuf8+6pzQR7KwoBzGtTnNQ?=
 =?us-ascii?Q?38xaumJfw4NwJepE6osxxd8cmfHD7wNA/Ha/+4LYx8ZHEbYvJ/fh+w3XGf5P?=
 =?us-ascii?Q?8kMmtyRKPGVug6AJAzmfCUIZHi6Ah2qt7fUmydC3LqfK879KxdbuSvnocvyU?=
 =?us-ascii?Q?ZtQJ2L+T48umPEa1zebsykfqZeyXgbfhCVJ9Oo8dSxuRkrpAWUt8xV3UEarZ?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DVf5DXruz/UiuPKCcis4KC0ayHIFllSzwKsuLndUztCjHE0wKaUcVGi58YLrChGypMqyuv9L2EaGej0yvNYDW3ZkPyk7KRuJ18Nu4//NSZYHESaHH+njM82nqsN+HU01wyAaDGEv97o/HYFut7NwuVZFC57sVCk+/FcPoYVnNEKwaDxGhubzFmoKXP5Pw+mI99rhqn9YquNcHh4jHZ3AHZzumIhe8i1hyqDbqeTy54rSic3pQS1DTNgsT3uOBTYGzmdt+0g6ob+J5AZYfwxYdT9SMEOeGBbsGEfCQZ+6MgYtwCu2YyHZnaEJ6KUJ7qLvdPyjMjQETHM1p/xHVvqAbKK/nfL/HUH6l/abxfp4nB7jfp+40Iu3x0vVJUzgkUvdOSRQBBHVB3M0oSo1pptBFOfP0H717ScS3n3EMoH0XItbJKH8wNS4LH5LgnTLfE00kNCFDPwaUAOXXFzNfW+Q74E2x6S46LYBcU/kl97xq7m1Xoc0nkQKerj/nKPzpkpCqsuPcZjge1l4zL0B5RqJ8GZYc0FWmJnswIGeQnupMGrEsjszWblbTnmGZYLfK5VUYiB6wEZCYE7H7V+YZpqX9Y706hkLbQPAMiLxdViVpTg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c8ac78-e22f-40a2-853d-08de13373203
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 19:54:51.8096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMq3QAsM8+ObJ2UxtGS4KGWQ0qW58h1uhYvLzCRafk2ctPfT75JGq4HFHz1B7vCYymckp+STyTHwHm7smo6hxjQmlKdVMDkf/gDz4ri3iUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6449
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240180
X-Proofpoint-ORIG-GUID: P_JCNr4XCUmP5TvdgwdF3MQczg0Aj2wc
X-Authority-Analysis: v=2.4 cv=XJc9iAhE c=1 sm=1 tr=0 ts=68fbd98f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QaIFIwmdAAAA:8 a=yPCof4ZbAAAA:8 a=l2Npek2ewvgVSCFgAD8A:9 a=CjuIK1q_8ugA:10
 a=H0j26ktMJjVwFu0eHUYC:22 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIzMDEwMiBTYWx0ZWRfXytDh4mCGNL3J
 WS7yibo9ue8+fKJvxTp5NhiGv9fXgkhq428Kx/U8vtbZ2j/HtGNAoPfWAKoH8lmHxS/Ia9x6C+t
 qEc6UcN5DhqeLUSy9U2Awur8fLom+YEQN+rlO5TEayCzYqOG1g+NWFTBlrDSrWzCpZS9BdCbaW+
 AsiugqAjSCX994rx39/dck2p5LvkPwFjBbDrqOStTrCxVgGhbGujPkmwaCSOizuubhtIFXZwYRJ
 2stv5gXO+/UbrGEN24c6Ij+tbk/4xdfHac49JSa7y23UNWLAiX4J3cTfv7lrJ8i7149Lou/51r+
 lChyWzB72dHy0zg6Y/bLRE0hRclO4tUs7+xvreMHtbAwIYlQzyl1chlTUDAMEpTaPG3gVZe6oJg
 1c+m7JPP1yd6ooyzkVLcfmPOAPdWbuXw3t5oGN5Yvge5dGivXCI=
X-Proofpoint-GUID: P_JCNr4XCUmP5TvdgwdF3MQczg0Aj2wc
X-Stat-Signature: amzrm7n8bn9adrpdspi9cwcc1htd5kez
X-Rspamd-Queue-Id: E25AA140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761335701-9066
X-HE-Meta: U2FsdGVkX1+Reu4h7tmAVtPpEn7rdBoGIUq+D9OhlkAt/aKeIBB0ZNWagkHUaA1ppyiPEPanP9w0boU3nUn2T+uQgbvJOs7RMborrDUOAAn/mcWtxOnBKHQvVv3EMal5uHYTZF1aLj/2OOpduTWcT+qHIxWEava2OyF9Eon5vTK3mEXQY1nZY6nmGHO63ttZeoHimoha98BoamHpvAj/CM2j/N3wxc6vMLwyYbrRtBOUSMI+F2Uugtg6tlZslLKvA1QrnKgZks/XOhLUQS0T/QPpEd5ipH8dEwtJ89hGpMUXqVJQ10OHE3u6pJqblLCcPFX/wKZKXCCCveEYQRFl5MYR8czap/oCchb+N5ck1c7yjcbg+kgAMfonFOsxPg+K8026JViGs01ZHNOwYI92q3gnU3QPm6Ek78Ov5EmirVgkNmEhV5Ow1SN2oJgDoBOohi9K24f6ZfWclgQegcsQ0xUIAOVGx6AaAwArJKF6XgTsbn5OQi39qNmLXb8tDCC+Y/jWBoGDCQ/mz3J7NRdDICqn+KVYRP17Lw2UjspH+k5S17zDt6ya5Ug78eVNPdh8tob3QHdM6i5E0Fzp7dZMQ4i+sDcAYU/xIN19O+yZYRi8r7EpfKTa9xon/MtIyf4BsMkUtbqwDiSj3PHNJ/o04P4wmbajrLc8xL8LuvEfIvgj04LuXF2eMZHDZgfETyFWGm9FNIFfPc+5Erm6lTXeEr+jSg9oky50l7SWlWWLjZ8M5AZYGLRGvTWWYbcWDWS/vgicfeJutUorVnEWsNkR7FtmbPK23Hfq/pQXZRCNt5CZ1v6GsZeqaTMdvhttgI84EVvU/gbwvVkarK5nFGPgFJKaa7Rtlu07WqlpBsuUSHRwOmVOppnMSdkt7u/9RCuuA+Hc5/oBAnup+NctXTkydSUN297pk69DywSMHIuUrDHS3EFHPLJsIr66dOovVp/+30vngfQfnx4+6AroWAS
 Cqo97Az5
 8J7tq5H1Hg3ueqWv8CKQOlT24UQW42HzUH5zGGNc2nX5DdCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 06:12:02PM +0000, Dmitry Ilvokhin wrote:
> Allow to override defaults for shemem and tmpfs at config time. This is
> consistent with how transparent hugepages can be configured.
>
> Same results can be achieved with the existing
> 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> in the kernel command line, but it is more convenient to define basic
> settings at config time instead of changing kernel command line later.
>
> Defaults for shmem and tmpfs were not changed. They are remained the
> same as before: 'never' for both cases. Options 'deny' and 'force' are
> omitted intentionally since these are special values and supposed to be
> used for emergencies or testing and are not expected to be permanent
> ones.
>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

This looks reasonable, thanks.

I guess one fly in the ointment is that these settings are only applicable
for those THP page sizes (both for anon and shmem) that are set to inherit,
but of course we default to this at startup so that's fine, just an
annoying point of confusion in THP generally :)

Based on your response to Michal, whose question is really at the crux of
this, LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/Kconfig | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/shmem.c | 33 ++++++++++++++++++--
>  2 files changed, 122 insertions(+), 2 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e47321051d76..5ceea38edbe1 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -853,6 +853,97 @@ choice
>  	  enabled at runtime via sysfs.
>  endchoice
>
> +choice
> +	prompt "Shmem hugepage allocation defaults"
> +	depends on TRANSPARENT_HUGEPAGE
> +	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
> +	help
> +	  Selects the hugepage allocation policy defaults for
> +	  the internal shmem mount.
> +
> +	  The selection made here can be overridden by using the kernel
> +	  command line 'transparent_hugepage_shmem=' option.
> +
> +	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
> +		bool "never"
> +	help
> +	  Disable hugepage allocation for shmem mount by default. It can
> +	  still be enabled with the kernel command line
> +	  'transparent_hugepage_shmem=' option or at runtime via sysfs
> +	  knob. Note that madvise(MADV_COLLAPSE) can still cause
> +	  transparent huge pages to be obtained even if this mode is
> +	  specified.
> +
> +	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS
> +		bool "always"
> +	help
> +	  Always attempt to allocate hugepage for shmem mount, can
> +	  increase the memory footprint of applications without a
> +	  guaranteed benefit but it will work automatically for all
> +	  applications.
> +
> +	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE
> +		bool "within_size"
> +	help
> +	  Enable hugepage allocation for shmem mount if the allocation
> +	  will be fully within the i_size. This configuration also takes
> +	  into account any madvise(MADV_HUGEPAGE) hints that may be
> +	  provided by the applications.
> +
> +	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE
> +		bool "advise"
> +	help
> +	  Enable hugepage allocation for the shmem mount exclusively when
> +	  applications supply the madvise(MADV_HUGEPAGE) hint.
> +	  This ensures that hugepages are used only in response to explicit
> +	  requests from applications.
> +endchoice
> +
> +choice
> +	prompt "Tmpfs hugepage allocation defaults"
> +	depends on TRANSPARENT_HUGEPAGE
> +	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
> +	help
> +	  Selects the hugepage allocation policy defaults for
> +	  the tmpfs mount.
> +
> +	  The selection made here can be overridden by using the kernel
> +	  command line 'transparent_hugepage_tmpfs=' option.
> +
> +	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
> +		bool "never"
> +	help
> +	  Disable hugepage allocation for tmpfs mount by default. It can
> +	  still be enabled with the kernel command line
> +	  'transparent_hugepage_tmpfs=' option. Note that
> +	  madvise(MADV_COLLAPSE) can still cause transparent huge pages
> +	  to be obtained even if this mode is specified.
> +
> +	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS
> +		bool "always"
> +	help
> +	  Always attempt to allocate hugepage for tmpfs mount, can
> +	  increase the memory footprint of applications without a
> +	  guaranteed benefit but it will work automatically for all
> +	  applications.
> +
> +	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE
> +		bool "within_size"
> +	help
> +	  Enable hugepage allocation for tmpfs mount if the allocation
> +	  will be fully within the i_size. This configuration also takes
> +	  into account any madvise(MADV_HUGEPAGE) hints that may be
> +	  provided by the applications.
> +
> +	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE
> +		bool "advise"
> +	help
> +	  Enable hugepage allocation for the tmpfs mount exclusively when
> +	  applications supply the madvise(MADV_HUGEPAGE) hint.
> +	  This ensures that hugepages are used only in response to explicit
> +	  requests from applications.
> +endchoice
> +
>  config THP_SWAP
>  	def_bool y
>  	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
> diff --git a/mm/shmem.c b/mm/shmem.c
> index eb8161136a7f..a411d7fb6e5a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -570,8 +570,37 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  /* ifdef here to avoid bloating shmem.o when not necessary */
>
> -static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
> -static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER)
> +#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
> +#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS)
> +#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
> +#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE)
> +#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
> +#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE)
> +#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ADVISE
> +#else
> +#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
> +#endif
> +
> +static int shmem_huge __read_mostly = SHMEM_HUGE_DEFAULT;
> +
> +#undef SHMEM_HUGE_DEFAULT
> +
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER)
> +#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
> +#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS)
> +#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
> +#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE)
> +#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
> +#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE)
> +#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ADVISE
> +#else
> +#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
> +#endif
> +
> +static int tmpfs_huge __read_mostly = TMPFS_HUGE_DEFAULT;
> +
> +#undef TMPFS_HUGE_DEFAULT
>
>  static unsigned int shmem_get_orders_within_size(struct inode *inode,
>  		unsigned long within_size_orders, pgoff_t index,
> --
> 2.47.3
>

