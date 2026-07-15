Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C46C4450E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FCE6B0095; Wed, 15 Jul 2026 14:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0E36B0096; Wed, 15 Jul 2026 14:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262CA6B0098; Wed, 15 Jul 2026 14:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4F016B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 499991402A2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:52 +0000 (UTC)
X-FDA: 84991789344.13.40074F3
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020141.outbound.protection.outlook.com [52.101.201.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5AE7D20009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=F9kdg4g2;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sA1rTbZ2jNxhh/LL5obxZYJeX4N47sBqb4CadZn8bo=;
	b=sGvGPebuiJCxNzSaJlaqCiNmraebA3Peb+eQI791wZTkPTHcPzMTIckXPB6j6wxRqb8bZg
	UXhI+OzTkMevmc6QJPN6F0Gjc5DFICjllhLc0CAy6HhGCitgJtw5T/oJWJ/vSSs9s8+eDa
	X54M1O4APH7WaZjHVS1vy5WA6qt6ViY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=F9kdg4g2;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138749;
	b=bhAbUUXhccxgRMObwsDAL9EhHSllBgSnNdj6DjNHoxfDFbX8j+hgHACnH+7K0W2FT6O7Wh
	nZGmph4OZuS/MCTnn0vtiKjYXJXoJ5BsL5AicrT6jHi33mNHym0STPASsQ4nNmDX30oTZK
	iDLrKoysFy7qiwK7qgxs3SCvhHorviQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJ70x4nCZRvHASmk/uP0G2k/nt0QYNITtDZgCveE+Loxj/KBUQTMp4WUsKieKVqLHB8TAn8RgWGTj6B54HsIKBIa8jEkEarTYmbHf2rBUqWXacDy6THyRCLLW4XvXVSiqx8qX/cVFClNoATmnTW273uukyf6YcaT1MZhImAnyhzb0PiB2gRpRcVRAWlA/2flpFI2oqHN5+G/BVAJMgc294w7F5wQvn5IzpcDMsU3pIAgYpXskUyyw6smgmM6kzY+Xg+lcOJURnjS0whkvUkBZkpxrJ4J3Ric67/thuTGL3usLMAgFAANCfc3sNcZrroeU0WynZZRpTZ0bwcCATQXTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sA1rTbZ2jNxhh/LL5obxZYJeX4N47sBqb4CadZn8bo=;
 b=ySbf2TF76KmwRd27Th5juVs3T9sEOmRGudjLJuzLSK4oxoKa8hoGhCdK5RFeJaniCB9VRO5wkfutw99ALxJLoTCsSBvvELH1z+0l89JJ56KCOFyzHAh74l7wNren9m3tsaMhjSedpqh3J5MsQgyFqv/W9Iu2+zKtasMCiNPzVazJJRlwzuDvn4o/zD8orDd6oYrwWU5HDNZIrCEZb0A4slXNYC1dWIKTWrgMNQ1G5KuyOglqaCvkryOtvdCpIovuhAHIgETTTyjgMsDzd6NNTSVXF9nPPQ/3MKSxQLhCVgNhygh+erBhETtanJbrB8ebpW2pVpj+sxCd99glfJfAIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sA1rTbZ2jNxhh/LL5obxZYJeX4N47sBqb4CadZn8bo=;
 b=F9kdg4g2eVl4p/rztq/m7ZUcrPE+O9gqSfueh+zeldYyY1H97gqbZxQy9eqKEIfqgiLreaqtuLpy76zW6GuxIjqvq2A2PkQRG7kXsTzN6PKOiO4rBcOU83znp1a33dAuyUdCKT8DsNfLa7WT+WyZUrfzrkjFeqn3BCtfzAPqHy4=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:41 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:39 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] arm64: mm: defined {pud|pmd}_populate_sync()
Date: Wed, 15 Jul 2026 11:04:08 -0700
Message-ID: <20260715180455.515692-7-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: 441dc6b4-cded-4a35-d455-08dee29badb9
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	l/+AtzMEL/FYa9qx4EpxdZ+JqNYhGv8crxd61afWUXL8uTcTyhloHLUgsjP+07GHLxJNd/Rj81HopEr8AJRyEyBZIEyniE/ZVI/JSgU2Uyji3oj/hhnDM0YPDW1SyLd/ic97rE8B3KLxs+rIu3c4PtyPwANSZHt3Qhxf8JuPLz0Syi5mKkb8T4ev1Y6EkMK41d2Xf/atsZOj9/oqARb81Tw187KjImmaZpenDQz6aKb2V72AjjjeH8+ZWRKoeJRRQWe+c2L6f2oz+ojC+KStniXklHhY9+Dg8hHVLpN/tDFDw7DwqsXUZ8OSjesKHjlbpjAuQOBcepbPDakCBU8wCZjLif0/0tmz9+8nfhsGwyKa8r1/b7HQZ4AbUb7EbFatN0H2QZcMscDWPseC9KHcWk6XOjN/Ak0XQ8SINaqVFlS9f0srLpZm7OfxuDWYyEedsNUlJS/S7MDPKQDcpETBfoPgSJkHbNf/uBhewrqotfXr2qbCKZBTiv0jZPJ+SJ/R47THEBaVhPDz5N40dsm7iqRQyWPR6xyXR2y9/oZs0W44YSPNLjW8exD2Xqw+m9LucDBxMSKc4Bc+EV8Z5qV0orIj6SqEJDs9kVScIplqTzWKzCHjsrWEQA3ItaoQ8SsaISTyTPF6gjIak2/s1BxsXfR6iyRwtnq4gQiYPrTVc6pJJvlDqWmRlz+3nm8rOYmP21G3rkfeZd8HTPZqKpeDgQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(6133799003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dnTDVbdQmpwWiBbnXtMPjZnwdwyebhJ/lqH5JcOLgFgC31AbVfG45/RuSGSR?=
 =?us-ascii?Q?yh4KXmsIgWjtmovlgOaJxT81lOBUonzYHOUAxHfHVY36SLgJ5b55C+osWh4A?=
 =?us-ascii?Q?0jxHtDOWb/y6YXRq7nGDSPUuXPx6+Aly553GDnW7WAHI+MeJa0sw3v9xP/Iz?=
 =?us-ascii?Q?+FwYQO86gclyUMynAyP6t499jT8dzmLJZl6cHNRV1DtGE2rTASR5XSjJsRFW?=
 =?us-ascii?Q?V7ZgFy0MTanCZ5Epx2umwJxfLJ3dYAN95afBLGzFLgyg/gFK9NAKfXhMNubm?=
 =?us-ascii?Q?mQmH0UmIckD72LUjrFE5PoOnuRCczjs6PTKbCrhc8fHrmhuugXa3xlWRSc0f?=
 =?us-ascii?Q?N8fOTIXZfVt4uJkObCBFKr8YaQ4eum6z2OO4iQolS4YNX2R0s7y2R9ogwvbs?=
 =?us-ascii?Q?9Sz3b9nN2JgfIJHK8Rkd0PtIUmqsBn50DdBhnqJlXEo08q933PFClRevZh34?=
 =?us-ascii?Q?+5m+Xb2W1lqRcEJxr/6ubEXOKbuyRfHt7pCRrHDe4+ApN0YILHSS7tXTMarH?=
 =?us-ascii?Q?s08roBET3odu/bOS7dtkULVaYTPLXSpwKTz+s+ldJcDFMFZl2oN1lo3A4U6i?=
 =?us-ascii?Q?KCEb3qJe/R8d3zvi73NDQEEMep15v/1VhB7wJCz74c2MSmQC8dIOlzDQjIM3?=
 =?us-ascii?Q?rEsbyR/9hzv7tO1/Z8/x16opEYq4TzL6PUvjiMT6bUtWQOEnsctKWN1RHOLa?=
 =?us-ascii?Q?zI63KPd/78BRvCxdcqabxB3ZQVH1aqUAlJDixta6vrMrjDRJHvpAj+6AeYi1?=
 =?us-ascii?Q?g87ouk7SkwmVZIViDGjBdRz/QQIlN7dhq5HokbThwgyvo7WvcFWUWwgQ+eeL?=
 =?us-ascii?Q?+ky60Oov4NmZiJOiTEFZfhzpKUxSev4VcjjAg8ryiMuLom9oOgsfIrHJoS+j?=
 =?us-ascii?Q?TbMreuaOrVc704xGILbCDHOJaov3EZXMS2Wj4H1JQwshGiA4O7xqvDcwVWuR?=
 =?us-ascii?Q?vYtinPpAYIzz+beZHe9QstP9h6l48jyqUUPGDzxLrHFxtpSrCkguXrhosUFF?=
 =?us-ascii?Q?MvzTNFtJUhZZM2GuVyNVs81C8bvMvYdtRak0SvWXzNaB5Bs5jLaRm4lxf/A7?=
 =?us-ascii?Q?Y2IVvZ2orTnRnRLPIbZ6CM19LQ42onkNdS8our2rax8QsUs7P4Tt2sFmGl/m?=
 =?us-ascii?Q?AxeCJv7lWka3p33/2wR+hiL0bEmLhw5CmG1bIJUV0Lt0m6Pf4uhcKQtgdNN9?=
 =?us-ascii?Q?6E+dSGqV/uet0OyD2+Q7j+cPzOAgEMlk//B6QwlKAhokmqc0FvwW2FZmK9ps?=
 =?us-ascii?Q?FkTzC1t6mAdsXb+CTkQhGO1QOy1VopbdZUHXuVhPk5BA9nmFEt5PNVI/Sht+?=
 =?us-ascii?Q?QRTlF7KIBBqpakrmsFoaA42xZAh3Hn7y9eNTLgDetT8EIcVkWie0rwQKHaS/?=
 =?us-ascii?Q?/Y63Rhs3dXo8VyyKfc8e/llp1SvMcCuzc3DNXGt4lqkx/O7MEf0H8ztJWtUC?=
 =?us-ascii?Q?q9FwZQagGgqhX8/PyhOrEnIlk5cuPejrl4wYHx3n06zr+UbICDRGjAVyVoyq?=
 =?us-ascii?Q?cnUSbYlcnXKXDNDPDB+6tDsYtmMh5UbCXwTg7+jltjALCMpTYPQw+S23DPQg?=
 =?us-ascii?Q?5FRidDW9ERcGY3peGIs++J+74Pf79otkzawMpE2UEM1QOBCAX48eZ1dPQQxz?=
 =?us-ascii?Q?ry8l9oCfE340fMZGtnFonhL2Qx0uYuU5fqlmA1qgr3ckUV67XC3VHd0HfCX6?=
 =?us-ascii?Q?uNwHZ9dNi2unPcHxlZ5e0KKlwCNjQ3Vqf/CAprjoDcMLOWpjIAvrhugcHXEz?=
 =?us-ascii?Q?ZcDU488weG8UhCsl9TO3DwxZ3BogLpw=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441dc6b4-cded-4a35-d455-08dee29badb9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:39.7382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyCroOkm8eysBpenGAyCPehoXy9cgv8/ay7cORmfh9eB609lTSw3Rxkxe4jUU5aFmR7MFvsT3y0rJiDGlCCaknxxptD8HMPa9kWsMZqmwDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspamd-Queue-Id: 5AE7D20009
X-Stat-Signature: 8gh9ss41hn56xjkzhdcprtebqzez4acq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784138749-799768
X-HE-Meta: U2FsdGVkX1/sJWS10Bvt3fFPzf8QxCIXCYMyiTEudpAU5fr3uxqhXwB3MnyK6ORUpZ9uIrHVLcPW65gSYjEnf3gcNv9FRj+eTa58Vpvjk5tQo4XgExrHCRo4qB4gc0Ndkh3GzFMyeNBQEOihMH/+PHlMFzBmHQGOfr/VJYu+TKHSXkH3T36IB5pGAvgltybZ9CpZs/JQKxsMaku35BeEM3fXkjG+rWPFR/ASLtm8iSiqyntc4vsLZGRCAZ9s/ltKQgn8s2BpRKEC7CWJ1Ld5fYea/hoJgTGJQcZYnLplreTOrFmFfuJI3ylki0K8PC4IgAo8l3GDuvDQ7v1qCxoyNAAu6V0KX7GEgvnc4/zs3svXZ/2XZ7K40RopdWBEsHUN27iR5WBRu/GQBspPjVxs0IAnFSZQtX/uHdDNUtr0vmAp8OUWUwN8n/J4hBQMp1yjdNGxU5c5sCCOy+7eBFBUMm/VURrqxoFEl5Azr14zdUdnMZawyFamjjzCWbsF1/95+K/NI3ApGnCWGQHIOduEoYShjMMibcMlElUleFEMuXqHFHWoTtXu46P40ze9XZTHgB3qS5Qa19nda5yMD/kMzWi7FYPnEJ/infWMc98YhPGiNpGlQgsoCkpdjxM0v1jrBeYr95eZbAqjVRy/mUkZg4uQYFf8WUQmfSxNCuSK4QQ3lucQhu5fwSGLAGEPhSKNNf+h3Pmzy6PgCj7VkuH7BbvrdDcwpO1iYHkHFFLhz+G/4VNMHFHLfQeNllGdBXSCqT30DpHICTeuguuWS/aZ/ghT6JUjsGradUgfkuqwzhRTL6Qy7Ab+IWtk8YcCm6pWUJRlB7jZeeraZaSAZxlSxxfpt5l2+beZoKBiJlQ658X0sFlzNEpTBohPAynozzyVDpn5DnzoCcZDy3BYzeUno1GXZX0tgSghc0o2qugIBnO44RzOhEjVv1xT60cR5jpEFOnTMWQqPgNA3M7T/X3
 OZVgvIf9
 59U8gkJJS9nStljmmobmiOSHjNDINWTOf25OfseX4qzvGyDKyYk/KPyv0A2vqIeDZU8S2OJnyOLParU+8zIGGlFKKkV8P3IaDspfH+dSrhVlha73rCiqjLNwDALX429zjmZ28yshXmRpfcfbg1K4vJOY2bXCeo/ImB1B18+SxAMQDZ+K8KTQepzbFWD1Qbz1GWgHU8NMkMuAo3ze1/0Cr7HB7J5ESGXr5Ex4hR4zvMSUz/h5upFvuqIoZO1Q6G25zpv2IPzFEFSHd1ctQe0offTqrzHBMECPg4gXrLVwLntCRi8JVAI/f5cZ1YCKAlBPvXdl6t9rzWX9oy5B/b9tLm7/q863AFw0Ie7ja2nsQuu98OiH+1e7j+TPOWj/IFic+Nwqd4qL00IPYWthRr3o8KO01rbVsY6mAyxlSZBoNml4W6LX6Nm+5DIfXXVUvg53+v7Aud9IDbzN9GAT2IVtQFmmTF3TkMGrILsVJCabGoTo2xwqrHojGhngF7Hkmcydrw4EvgIdMtV6yHXIJW8ALQSHmga4BfpabWcm7Ya+/62Ab2t2MHCaUlSdYDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement ARM64 specific {pud|pmd}_populate_sync(), which sync up page
table.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/Kconfig               |  2 ++
 arch/arm64/include/asm/pgalloc.h | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2e1bd79a579c..23cad9fc7046 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -41,9 +41,11 @@ config ARM64
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
+	select ARCH_HAS_PMD_POPULATE_SYNC
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_PUD_POPULATE_SYNC
 	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SET_DIRECT_MAP
diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 1b4509d3382c..dd1ac84a1160 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -33,11 +33,27 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
 	pudval |= (mm == &init_mm) ? PUD_TABLE_UXN : PUD_TABLE_PXN;
 	__pud_populate(pudp, __pa(pmdp), pudval);
 }
+
+#ifdef CONFIG_ARCH_HAS_PUD_POPULATE_SYNC
+static inline void pud_populate_sync(unsigned long addr, pud_t *pudp, pmd_t *pmdp)
+{
+	pud_populate(&init_mm, pudp, pmdp);
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PUD_MODIFIED)
+		arch_sync_kernel_mappings(addr, addr);
+}
+#endif
 #else
 static inline void __pud_populate(pud_t *pudp, phys_addr_t pmdp, pudval_t prot)
 {
 	BUILD_BUG();
 }
+
+#ifdef CONFIG_ARCH_HAS_PUD_POPULATE_SYNC
+static inline void pud_populate_sync(unsigned long addr, pud_t *pudp, pmd_t *pmdp)
+{
+	BUILD_BUG();
+}
+#endif
 #endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
 #if CONFIG_PGTABLE_LEVELS > 3
@@ -121,4 +137,12 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_PXN);
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_POPULATE_SYNC
+static inline void pmd_populate_sync(unsigned long addr, pmd_t *pmdp, pte_t *ptep)
+{
+	pmd_populate_kernel(&init_mm, pmdp, ptep);
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PMD_MODIFIED)
+		arch_sync_kernel_mappings(addr, addr);
+}
+#endif
 #endif
-- 
2.47.0


