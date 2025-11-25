Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F33AD0EE01
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1B56B0007; Tue, 25 Nov 2025 10:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9DA6B002B; Tue, 25 Nov 2025 10:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8A56B002D; Tue, 25 Nov 2025 10:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED8D46B0007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:42:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62046C024F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:42:09 +0000 (UTC)
X-FDA: 84149545578.22.D2EBDFE
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012023.outbound.protection.outlook.com [52.101.53.23])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A9BCC0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:42:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="tSjsOZT/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764085325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hK8vIrhPpYVenuHL0utwEE/WsYzWvqYCf+w0JkrZopI=;
	b=1g8XbmlptpOF+fy3fPbFHeT6130wZWr84mrEf7zKXleLRUUnmEMEcm+DK2n2FAagJLQ6fX
	6FmZ5neGJfIsbmksza0CzDkejrugIPMOV3L6vwKIqkaXzIb+WAqS5B8TNn17hfPVYA94Kn
	cpBwhsRXWJ1F5vbRp79/MJfzeNH2xh4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764085325; a=rsa-sha256;
	cv=pass;
	b=jFXnwOdzE+ll9PRxERFCNzNSe+c2hzW5fhc8UYW+WZ5uVK5te3xCnThNb3zgPjCHgTFe6R
	0Bite26g1iRBXFp6+I8mkm4IEm0vLPVNX18yqJIZLVZXLxNx8BXPxRyXHzDaAIOkxuMFwa
	DoWF9hvyYrgRzceYRds1k4JDe4JSQ84=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="tSjsOZT/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8VVK9oEsk/1YvHoIQBBWKOPciQsLrbe6gzUanaWx6VX1j7+aj+jxR8umaHoCMt61OmfOlJxxIqQI1CoLaqX7y1z6xotVxYpkRsWCrrM2WhdEuIQqEOtbmBWP6sEwVwItlzCBNvNfsnmXRmD/3T6+oSHNfoGAnz2CG9We5yTs/VPqZHF2oKWnZa1+iQ94ZmBpmDAubUtvggnXzltPuMF3zspHbdh4r4y9sMY6jjwfJhw6SsQzrcv7jGh73M9m1WyYaZ0bUpDXptDeizKQzVqmPjHfA4zQtZ8Z2kzzR0Em1plgqe3kUzRd/bG8KOuzYxHG2ZTjf2NqrD9EqCPee9trw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hK8vIrhPpYVenuHL0utwEE/WsYzWvqYCf+w0JkrZopI=;
 b=RgXr8vRVBPZgzp2Dz+sihY/nHA3sqUuojIJRycIKkfdNM3fuVTs7IoRhJgg9sII5tGIAtWpftO1Ofn1ctHo9vCEYxRIHDu9CHg2ViP+tWHvnPi98osaG77eOjrkzAqN3kY28+3DsI4VjGmBgUEHEQYm9hR3+g3oDpTu+QrzHsTFsq9s73iQfyKJm+JWHG/u3ETzQlw9dMkyhW/N3Bm7Us9Ukt57KsGV1PSDas9j34uk7zk48GxOiGNUBsNHXMpCiA1rEaouA/3kftzXCYXEsaGvGIN7oTYiypNfhU6MHoHli6szZ/YWGK4O20ArWHuM5hIxqShJJzCSNfmjdspDyVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hK8vIrhPpYVenuHL0utwEE/WsYzWvqYCf+w0JkrZopI=;
 b=tSjsOZT/L18fCBx9AYL8LjzbnQPZKZOEpRJbQjBNhFeC4z7acD8NH326+4fYEiZsaW0YIkl9TyIETIQmtI3gUByuwBKU+d819XlK5H6WFSZelqPPa7ycdVndlZ+zV8ZliBEk3LtkWnjEgMZI3Azf0fMSojBwObV9LjHRfhe0EuVrQnaPNaxGLMUrFKBiR+H1swRwejemJPsSy+us0WmslIJCqdtd1EuwNfcTIiL3Hmzvm+tvy1RsuMefPHJ5CTdY8LdgS3s2LoIIFf+/Clwe5jo84I/QvUJYMwmp9BQwIwdGF7poND1nTLkN+c4LaiViUFkOPIM7P0tNR8dDC7iIHQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY3PR12MB9577.namprd12.prod.outlook.com (2603:10b6:930:109::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 15:41:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 15:41:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
Date: Tue, 25 Nov 2025 10:41:53 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B393CCAB-0398-4BE9-B015-BFACEF603FE5@nvidia.com>
In-Reply-To: <5421c8d0-1151-48dc-8774-fd2e983735a5@kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <51675d77-9453-43cc-bfda-f21a2edfeace@nvidia.com>
 <5421c8d0-1151-48dc-8774-fd2e983735a5@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR15CA0025.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::38) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY3PR12MB9577:EE_
X-MS-Office365-Filtering-Correlation-Id: aaa8431b-b39d-4196-3329-08de2c39299b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?90/VbZc7TIRxqAAzaXUMs65qZiXWrRozgn+uJk/2SEUkSmjG8u31qLcvCMBa?=
 =?us-ascii?Q?KHsu8Ensqm3xv5lGBkInbMcgTyRAYVha5PWrHMyfKoUHQ1Z+p5uwM6eP/oiK?=
 =?us-ascii?Q?d+nydByMy9z09ftERo4NKp9q7FwnrR1fj3WNf1JiNxBNJYFhdtGLHci/aMTx?=
 =?us-ascii?Q?6XFWhUqyt9pjcJSw2Vq9GgG9SpzjTrcmwhGwr5J3g27z9U7qEE6JMa5CA8Nk?=
 =?us-ascii?Q?71pGChi+sqxvEPbgOpQynrB7dNlMCHlayT1LSMFgmXNvBVDO6BwkWoHdaPOS?=
 =?us-ascii?Q?Eq1XhycpyDjof2UVcXBm3jfbA4Nvpj+icZW9wWrunQvwY5CAEN9j9x3H7PCj?=
 =?us-ascii?Q?eN1JYowEMxiRJZviFI/m3O1s8Ga6jzagcPLfFyl0OgENuakPUC/aVqGC/xR6?=
 =?us-ascii?Q?h0x6oLdSSIJwFAv1YZMDfCaRyHhZCEzMnx3JekAML8h9mn2dqaVmR6VGgJO2?=
 =?us-ascii?Q?191zaihiHgDzNdfGvnE5bK/8OKxc4QbPvq5bjJgKCV7h/U7tz2PAdglFXP1M?=
 =?us-ascii?Q?tesdzfqqok7+nXcMK5xbKacq9ZaXHY9Upn6M8dzL+j0siwEKOjrHVWzAKL4D?=
 =?us-ascii?Q?O/CHlNhHq0KiQdMMUqqe6mYLDgz3lRvlnXmuAp9JouQNVul9kEG+aCbTcR6f?=
 =?us-ascii?Q?dCKmx3/tCersmPz4J/oQOqinE+DTR4tIX6k1CQNC2gTtORyLyuv+dyGqoV3C?=
 =?us-ascii?Q?hxN3T9et9yn04+SwskPt0pvhNeRn+N+WmksyZYJIKr2z5FD0r/NCGC6XM6+t?=
 =?us-ascii?Q?X7TIdtAV/iDy88RFGqkpBK4cDZNz273kuaElcHfP9J5QknqV90sgdaAdzSBD?=
 =?us-ascii?Q?emWEfTCvUeiiSwHdJbwE/zsjakFNpJlrVzf5QYtsU9qScNK4ttPiWb0HZm4y?=
 =?us-ascii?Q?ly3LENLAPZCsLXoOCK5KckwYlhman4YtrmMRreraCdi2lTqNg6WOtLny09lf?=
 =?us-ascii?Q?XX0/K3aoQEe2+mJi5HMwIQqut3GgJtZlzUYlkYvM1xUsjfJ0EAlX46wWdCew?=
 =?us-ascii?Q?6EgwZXFbZwj8yG7cImu1PMr7AKz6cJ1BEf6Kap+LSUqE+3ZUDrU5Pt3oUWId?=
 =?us-ascii?Q?rorGcc/raGgdZFOISHljHzbO0ljXPUDlCpbeVtO8W8FrdtusNQJrN4mNmMC6?=
 =?us-ascii?Q?Yc+XHsKTaFjFc3trHLCkSa8brc74JmCqApiq/vvptRA4MoPdBie+ZfXn7F3n?=
 =?us-ascii?Q?qgMDKFsOm6tEVdjBcS2Vihiz2RPx16M09DyI07lFoCO/Q0pFFXtsDtcKpFS+?=
 =?us-ascii?Q?61sN3uZDd6miWpx+nRZ8ILx/fZd06X5P0hlJIXoAeyhnxGKoambtTKr0bbm0?=
 =?us-ascii?Q?OjZcpCKTE61YrPv69w8aR1vmNCYox5g1+yAoIhQIA4H0+yruYfvLhccojxuD?=
 =?us-ascii?Q?Dol1nPy8AiEqohPZMrbuF24LVmXSKQZyVl14hbIW7+GuEPC5BdalrpZegmgl?=
 =?us-ascii?Q?ICDTzZXiw0IZHJs+UhhA2h3/j9T0k3R8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rEtaLVRQJ1KkfZ958A7Uj/Hg0dFsxp94p5Nf5ZAEqjv0mNalC3RtwXQvTQeR?=
 =?us-ascii?Q?dspOSnHVEQluiiVQ/vGSjM1jkghHeZizhYb9m8aMlyYELDSNU4xa03Wd132b?=
 =?us-ascii?Q?tCW6V5Yfnz5Wwn1G0lRHJINcCbSVbAyVNZ9/r6JzxEftEfq1ZRl5/BLgbAFS?=
 =?us-ascii?Q?5AX6LEM90hWTPH4619NC+KPEle+YFRUk3w4X7KjwhQBNv4MiRcbahCJMl+Z+?=
 =?us-ascii?Q?pvP835VwxcVJhmeSgZsNmozSth9ei0BHt9TAaHo/oR1LoScn60wxK/LPECfA?=
 =?us-ascii?Q?I7IF0v7P7zvjuTFaPVasg0Ogt4RZZGVnSXjvYHM1W5fb9gWcYE3paiUZLhty?=
 =?us-ascii?Q?87+pT9PudCWh+ROtexbiNq57Z1lfmR96dif3ZErNjPkPazUVnb9iCUq5QmIB?=
 =?us-ascii?Q?ogdt74U96CXpa6iqk+1YJAhghh3QpP4wphWMPjLvPOPNVl3BxIgCEIKgxDr7?=
 =?us-ascii?Q?viPqPAxfY2lOzbpqhWe430az6rdaVhoL4dmY3FaNiQj1/AkgLt5zZjZyofGU?=
 =?us-ascii?Q?+iiBUTns/U9ViYK82pBNNIDVAdZk8i1s3i0fYyIN8ivjGW7ExhC21rmSlcCW?=
 =?us-ascii?Q?RII3lhfh3sMKvx+Qb8nRQSjxGU0Ye3h/aUg4kd/MVmJI1+h6eyCob/sfd4+7?=
 =?us-ascii?Q?GCa7L+f8sKJHWy7W3YR6SD3RsvutzzgJntxRtsQeh2kXb89n9nA+HvDORaId?=
 =?us-ascii?Q?Nd2guEY8BS21YzvJkFU/lwzpN2o131azozrn38vs9ezLr/HiaKZCpXaPcHaJ?=
 =?us-ascii?Q?gxwymcBjASjhLf7CwQB+VzL+6/qWl5yoeBcR5oFyiBW+nEliyMS2ip9OEL65?=
 =?us-ascii?Q?Iz+f0LOuLFCfw3qF4UIau2edLHUi9mrxRg0ZzMTIE1JfMFqZ05MjRopFnT0O?=
 =?us-ascii?Q?pPA3au1GBvgVpFjCr6iWHtHDFjZiR9Ax0bNDDusOWtPqp9TeyUCaR0kP5Y5q?=
 =?us-ascii?Q?XIFtmGAWmkThqQofczR8VZQ0l9EQkS3L3/rtB8jJM1gsSQkDf4e8rjIa1oGU?=
 =?us-ascii?Q?JeNsEPDmHp14anfE0MyoTIX5YaD52pfQ4VU3e/GymZvT/q7yJ962Sr2lYlAF?=
 =?us-ascii?Q?rAjFZQeLPBq/3tECM6X1SWRnqVODr1/MpA167DY0zdAgSBAlbqooMD5O7spd?=
 =?us-ascii?Q?+1xq+1btg4S5tVb7mP1sTLf50Kz52o9DD8Wnu4xSkHvzWhKo0pGpH8B+Igd8?=
 =?us-ascii?Q?Am5uNuKkQ/uNULSsHKBy6MLNwZiS16Jz9rEIyo/cBWnHSRw44gK61Z7n9ON1?=
 =?us-ascii?Q?W2hCDueJUeWa5r7+FKJYJwps/4FWBSMQUSHljdJ/WSNcTQa0VPBGcUnwl1b6?=
 =?us-ascii?Q?8jxyvxiV5MabsERUDpTT68ils5CgwC2GJwVZJu7Yz4QimD6F0dHz/aOj6d4Y?=
 =?us-ascii?Q?qcAT3ivBTRrRCwRlV+47bVWGdNVk4x8W/7lTM4a2lnjYtJFtYiiBtghxCMEo?=
 =?us-ascii?Q?hP0/18UmB+qdDc6zVd8ZlQTjr3xCw17J9G/g7DjdBZL2TQ9ZrhG4LZ+N66Gp?=
 =?us-ascii?Q?cPrixXNxKDaOegHW4bR4PoCkdMq8PYbgltBoX9Z1/GIxldX/7tT523uZiCvj?=
 =?us-ascii?Q?dSKrUI3pSB1qaoz/XhNuCFZjzgRKok6NLg8nxOfY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa8431b-b39d-4196-3329-08de2c39299b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 15:41:55.7015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMvl3aNWCdSwK73+jt4/2SmdDFqm5Az7uJetRGk9dv8PUOYhG5dhgg45S+4Stz2y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9577
X-Rspamd-Queue-Id: 7A9BCC0008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: tyo4oquikuxgnxfk1kuc3u8w5hc9qzur
X-HE-Tag: 1764085325-483711
X-HE-Meta: U2FsdGVkX18S0+PB0EiR7F5yDDx12IP0QwN2REVRkaep5PHlm2zeeBeviHObbX2U2FGX9q0OiSK8LwuIz4X+ZrTfGcNuIYdxycgH6/ZSw03/fnT+I9I82R1GxWbXdz+o28mmTijDdcpjQYJJbR3b0Z1UJGOZHUljRSAvNWBORSztpR4rUnmHqmeCjr8QkE1y4cs1RJsMpqLwqwsSLaJM4m0AL9MiPc4JGWTrRZZ4DHOCt9bhvUrJ27q11WATBNVgLJzgoaZLUif75xqsUxaU0WNjuvREaPS6rjy2xRFA89mertWKFBil06vvW/wp+NrlGzfuvcrUfehlKKM+ySl9q80rS1SUIpmSy00n/eVrE7kEw3YDR/MeNng2+rfDOfk3nq/mUwPw7sHWcjAJuAv0vq1EVB+TBVKHfZsGm7sF4GSidoLI8WkHx1vL+dvDUE9Z6/ywAoWCAKLjWz9wt+kSIMy7taOKYn1dG3zf9CLXBJJjy2jEUJ5rY0RST6olRBgr+tFH3l6IULWxyZ2a+lxJU2zYmpSUF6/n2PN2mByWmGDtRHVBwvZR9KT/aOvUmbiuxn0LapP24clT8Gbbvu4V8vRqMCC9ynbIXBeAstt4JRvn9dPLzCpYLZfOropbwCnyIBP53kK2NQSqNVHjPGK0DUp5Yq3I0Z2cBrLcUxQJcFq4WIxvQKKCKdvA6sKaEhD7WWri5vlwxiokxqhhPdWeo582RnXYhv0XB40ByUCzVIES+aclb0dWMS0iXvXzKh4W7JWl7sDuBz9h7doC/l7dkvLthSzf3kXttzi2k+1XpmRm4y6dkzYqx2CqsAfflnpObn0Mgnj2GnQYi/n2SW0gZHFW9KDFi7cqXYdbyN8DCsPcU8ab6NVosKPjE9tiFVTOWcFPAliXvvd41sDwv54DQPr3PWFgFf//dGpoV3dQLCJSj92B1Sh91ATJN+K5gllwk1AW7dS6vl8fyELSLOT
 3WaFgWq2
 igZOlZ9VM4jSYoOV12jCsgyCNk+/+zYRKe0BYDkZptHVxIk4lDElFlKMg/0ZI/vxYYRRHvfyH9KhDQ9cnhda0heTNEMn8OE8WPGwiXYAYNMe+KbdkXpuEtzL20yPDTQsZR9/5U4zyIdKMEJ5OtmPa10X5pX1+vfmpKsB1G4uSpLz5nM44P7neIRAL5bmRVpaXZckAl1fGqqDEcVoxDVkIncBADfGek/WZMRT4e0khXrzFh19ExqiEPzOiLsI6R9tZ/jGAOmD2G8YWNbnPGBTXObZr/MIaJosG7I6uolPghV3lsO48GrCeecUWOn+pQTWopiGMoNstk0dxAkoaoD8FbrefIihP6OWYiVj+knFDZDBScnUp3lbYv8GcBqGdF9OBQNzZuoTHZoMvtjfbOCgH+1kwoO3PKpRlTggN8DGGb9odG/smL1gO3RnSuFP4TwFBBSJSPJ2qNQvTPUU4qWLBPToblf7kf2sCYl7+HqUug5Uy0qEPn18699w3XkXXPmlqFFjZToXdT9zTyilWLfxFlA1uQ2FRKvMTfPJdukIHHB8GuHP/d8RN4uNSMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Nov 2025, at 3:55, David Hildenbrand (Red Hat) wrote:

> On 11/24/25 23:14, Balbir Singh wrote:
>> On 11/22/25 13:55, Zi Yan wrote:
>>> can_split_folio() is just a refcount comparison, making sure only the=

>>> split caller holds an extra pin. Open code it with
>>> folio_expected_ref_count() !=3D folio_ref_count() - 1. For the extra_=
pins
>>> used by folio_ref_freeze(), add folio_cache_references() to calculate=
 it.
>>>
>>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>   include/linux/huge_mm.h |  1 -
>>>   mm/huge_memory.c        | 43 ++++++++++++++++----------------------=
---
>>>   mm/vmscan.c             |  3 ++-
>>>   3 files changed, 19 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 97686fb46e30..1ecaeccf39c9 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -369,7 +369,6 @@ enum split_type {
>>>   	SPLIT_TYPE_NON_UNIFORM,
>>>   };
>>>  -bool can_split_folio(struct folio *folio, int caller_pins, int *pex=
tra_pins);
>>>   int __split_huge_page_to_list_to_order(struct page *page, struct li=
st_head *list,
>>>   		unsigned int new_order);
>>>   int folio_split_unmapped(struct folio *folio, unsigned int new_orde=
r);
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index c1f1055165dd..6c821c1c0ac3 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *=
folio, struct folio *new_folio,
>>>   	}
>>>   }
>>>  -/* Racy check whether the huge page can be split */
>>> -bool can_split_folio(struct folio *folio, int caller_pins, int *pext=
ra_pins)
>>> -{
>>> -	int extra_pins;
>>> -
>>> -	/* Additional pins from page cache */
>>> -	if (folio_test_anon(folio))
>>> -		extra_pins =3D folio_test_swapcache(folio) ?
>>> -				folio_nr_pages(folio) : 0;
>>> -	else
>>> -		extra_pins =3D folio_nr_pages(folio);
>>> -	if (pextra_pins)
>>> -		*pextra_pins =3D extra_pins;
>>> -	return folio_mapcount(folio) =3D=3D folio_ref_count(folio) - extra_=
pins -
>>> -					caller_pins;
>>> -}
>>> -
>>>   static bool page_range_has_hwpoisoned(struct page *page, long nr_pa=
ges)
>>>   {
>>>   	for (; nr_pages; page++, nr_pages--)
>>> @@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *foli=
o, unsigned int new_order,
>>>   	return 0;
>>>   }
>>>  +/* Number of folio references from the pagecache or the swapcache. =
*/
>>> +static unsigned int folio_cache_references(const struct folio *folio=
)
>>
>> folio_cache_ref_count?
>
> Yes, makes sense.
>
>>
>>> +{
>>> +	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
>>> +		return 0;
>>> +	return folio_nr_pages(folio);
>>> +}
>>> +>
>> Does this belong to include/linux/mm.h with the other helpers?
>
> Not for now I think, in particular, as we require earlier !folio->mappi=
ng checks to give a correct answer. Most people should be using folio_exp=
ected_ref_count().
>

Got it. Will use folio_cache_ref_count() in the next version.

Best Regards,
Yan, Zi

