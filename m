Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BC0CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 04:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68196B0005; Thu, 28 May 2026 00:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F806B0088; Thu, 28 May 2026 00:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2DAC6B008A; Thu, 28 May 2026 00:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFA566B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:13:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44382A0780
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:13:56 +0000 (UTC)
X-FDA: 84815510472.09.6677FDC
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010031.outbound.protection.outlook.com [52.101.61.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85F92120009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:13:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VoRUAQTS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.31 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779941633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oboPCJiPTkb1xQCb5sybWsovVY18H0BGd04oVfKii6A=;
	b=1CHqWI8UEbkxpmLdToLGsJh3dYeoUa/YMV+wIf8/Dk6Y9n8JPcdrBzRtd6zGIPgW57aQLJ
	olsednfELPW3pI80enb/FSfwSHuV/YwlRI4zYJ3uF4aAMI3/azGMbOQPE+29om+FDgkf+e
	1tK4nNgigv+CV8eSgHtS5zsxaKYxnvE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VoRUAQTS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.31 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779941633; a=rsa-sha256;
	cv=pass;
	b=VgSapQjPaLCyFwviDrI8/LUPLTGUj+W9zFAiNzDQNFxf8Wx2hZ/CV2lsDoOEdhHmd88g4r
	qceO6aI62PdJP3mTwPs+h8Br5lryrVzISITvmsa2tlNgtywUwdiN9rC/5l5PYSk7lYdv2B
	tHHivD1xk0fgp45fslQ2cAnkTfn0AkE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiW8bmwOXHFuZq4QRsogFVT3xwrV9E5XHm1pQ+iLpGxHPeUIfskt7HLnTkptXJGn85ipPaCxrnQ0DU2E4Q8tCP0wMNQk4cBEUh+UagDf8yqMiXjgEPBExoY8HHJkUe2tv35N713soi7eIzJMzOY7cAZicYdFa/YTQyD5K3dyuWOwBr9nq9JWFlPMrNoTqrDiS2//bGX6RnlNVC052EBxsphOL+dfRI31lQiaz5E9+sljsksW1V2beR8lknzdd8Kv0fSx8FJZyJvl/6J1eNVu4+sVmXxwv5T+hRMz/0MkyeYOwmss82Fz/J2/rbmFi4fKYo6+H42p2nFVkle6pwQBkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oboPCJiPTkb1xQCb5sybWsovVY18H0BGd04oVfKii6A=;
 b=irgAWBT/1S4xzxWNMu8XV/XYf0VTW07hXgE6F5bIAvrsuiqCAsOlMDBjKH+BMGpO59VEOgs0yTYcYy64thd+xNyEA1o2ymZ9NnUKPLT20AHgdjcO1bSC8lkCzKF3jj5L+1etCPjrHU1QhwH0hu4xBsuhY15J0rC47S/zb/igGDYtLkfSwxw3CziceLLrAOnFCAqk6c2Mgm/K1cG20Tfw2NHCcv4jhvUk4zi7PqkTNlE/ExoeROnSLCAu6UniKScGxDq0JN1oyx0ZkHH/9ZET99nvhrfo2PWjmFUDb90YxXk3NamMkg351LzpXMPbZs3+WZvXdPGXNXiX1IRPZpLaEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oboPCJiPTkb1xQCb5sybWsovVY18H0BGd04oVfKii6A=;
 b=VoRUAQTSaVkHdAcF+wgFEkwkAwOobB1+q3kl//XgaFuQElEXkscC7ZYFan3L4s+/LD6SQLO3LpJEGHInSv9O/vunmIdkLTZVOXB+WJc9U2UMPlxr3qQZEpfSwgRX2N7ZxxgEux102yhpw0Bryv9SI3YC6S6GyLhBzUlf/q87g1MOCYxzyt+SArKw8juOYldQfJbICeltHe7B1l4uBCcJwRNgF5qeFujHiNUoYPMHAkleK2h3OzsJG56OCJCFai+tmar8FLiR13cSenTRipWpLKgMrJRf2JAkfyvmFZlRp9UGkkbr3fhUIPCZDmH69kS0RaWbUCIP1viDZAodmAb9lA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.13; Thu, 28 May 2026 04:13:49 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 04:13:48 +0000
Date: Thu, 28 May 2026 14:13:42 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] lib/test_hmm: fix memory leak in
 dmirror_migrate_to_system()
Message-ID: <ahfA6THt-gK9ieSf@nvdebian.thelocal>
References: <20260528011336.20797-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528011336.20797-1-hao.ge@linux.dev>
X-ClientProxiedBy: SY5P300CA0011.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fb::18) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: 643d8374-6a15-4081-3a1b-08debc6f8483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	TVYpvXmmJ59hpLGtohF5v8iIF4D67Nqd1okaD7x2i8uo2NDx5clONwOXmgvOyn9wILXcuc4py8O9OPKAT29bhOGBnl0TyflZqEIwmrNfjW3/aznjHcPTPpmBDEskNV2o6EUG2GfIL5o2YC24WbuZYNQxI2/W6VKtKxaFuH/QLd45RHNi+i7GFIE3PnmcPGdyDGItcp2UxAYhBITrQJvbY4NPdcO3qJCJ6K3up9caquFJ3h6HivmppD3pz/jNVrao+rER2r00Kp5Yr2TD5L5lJL9fYUAuC23h+I4O1qAcQj4Hz/lnJwthoebfaq5pqp7heMs5pgVYNFtss07JBxpMou/w8GdLzDAQvALq0nAuZqFIC3TZJKJA8NA9+k3/hWCNRC9QmDMeq7XNTKsKNt2c51TmzeVIzRc8U8Q56ZST8mTbVW97wBMFOyM2JxwMf69j5t6twVrTqR6jvatzEcNKBIULeWIkppXhklmnL0DrnqkvQKZrXsW78YqiGBuFsB8O+fmA4ANsq6e7NDBSxw9d8EZqOcCDG3FKXa62xBceIo+lT13FzwX1QU1a+9YS4lDmSkjGTNz+6V60N+dJ4ZKX5dEMY55NBY4a9o1WIFQbUyvkDhNUNnWaXOfG/zixbpBNSh3kTsLZrcmQ8JdkUG5/yOuAS/7sNwtc6u2Gpdv/Ny7AQ1l2HF4cRlSCD8VbzoQ6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fPXcgcCiXiXKM8JiMiXlqXiqbREZGRd8uOkhzpeol7KBQ87tTcEQaNHJwzfT?=
 =?us-ascii?Q?ngbLW1rlXpTXifaJfeVHAjvaqeap4J0qEfbszEhC2ejRnMOkf5Tp0mkH1xVV?=
 =?us-ascii?Q?rdSLJ14hYOgGmhQGEAg2H9hUr0mztcEBVfHaMHOqkxko80GUyoWQZ0RYtWs4?=
 =?us-ascii?Q?3LOvOuSC5dnAhK5c02ciuhO9FrAaPLxR2dKn8pRWvl7XcScltf3cQdrrvApv?=
 =?us-ascii?Q?FuDQtEJpdkuSFUl+LyGIL+zL0rFwCO1tCmgoFW5SDoxQbBI/xVf2KhQwpDsp?=
 =?us-ascii?Q?9taJFWjx9HZ42jfjgBuKRrOboYWA1I/2oIBoKuODUJvHKlxF/GP/5SC9Yrot?=
 =?us-ascii?Q?0qBswuuUDqnWKD659AekL6B3TzfAJL3DwgQUcUKablvVNgFqgW3I7s2Dx23N?=
 =?us-ascii?Q?n1QOEOMKZ9YF8PNLVnkT6bie/ozpYLQ0GZHJ07th1cCkJg0qRv89bEISyDRE?=
 =?us-ascii?Q?/O2JtQaaOa/6wijYb4Sa81pF8UoVuJl2vLMQG72yGzrQ7vNxcgGkrcmp1L0j?=
 =?us-ascii?Q?WXfoOAcfuEQ/sZ/0L48RKzTjq3tHwURVi6Qg5hkjlGFvK3fqyU/c/3c/Erxu?=
 =?us-ascii?Q?exLl/E+HN4mLCmwgzkgoou4kkjeGbRjQkYnMU6SYSgy+Cv1VKpl34uQe9kg8?=
 =?us-ascii?Q?bUt+DN/EDa5i0CuExQ6Blzlvrys4IVwav1OMY+7ySP1dGFrOJSlP3JywHdoL?=
 =?us-ascii?Q?rZwdxgHo7d/B4HstoqcJOSKY0Bc/80wKsyM2M0ZYMXC83lqTYEITi2zn1Zgu?=
 =?us-ascii?Q?ZbuOHQ+t/NGqpXYANQYnLQYHwacHmhFrV8Cgau6CrhX7BCyNyyvIRadtxLBJ?=
 =?us-ascii?Q?X0zoWSni8kvWtbf80y1MIre5FTam5WePBrOOsQss7bXILLTz2ce7JCv3es+5?=
 =?us-ascii?Q?4bjHtK5pzzm0lOQf5k4rZ8xl/0jAVKptlVJxmQeZSwmdEL0T4dmmETJDIu/Q?=
 =?us-ascii?Q?y3Ej2vSQ1bVXpf2Jn62jh/LZfvyS/lFMoTt6wNjiczO2O+P1KBg6pNhBEaXu?=
 =?us-ascii?Q?2sYIgxbo0F8Frf7Ry9mZO8oc8TR7qjomI0HSy7xZkb5hzM1DYs7gNhOjBGi+?=
 =?us-ascii?Q?7IOQK9ZqcFif6/3AXlgIDvZAM8m76v44TUu73fmfOttUAM0mx+PLXZWebfXu?=
 =?us-ascii?Q?TVhRC8zVWzqSq6uPJeUJpAqj1kKFWRB/C3/cWehNBdOHNXVnQ3riODHhHyWd?=
 =?us-ascii?Q?cSDY4/RUXL4i+Knv/QEuEnrt78Lby89Wxly9mPI19Pu32JG8GKs1kqLQqGjz?=
 =?us-ascii?Q?d+Zgk+Va1MeAb3ey1c6ZJ+U6tQ6QIV3jIhV965ckHX8eiPTiL2pq4e14isHA?=
 =?us-ascii?Q?5byVdccTm7ZLmRWeP6ajd9r/4dGnwqOcp7oCuyXeBs7vRgJxHAfU7xqvhUt7?=
 =?us-ascii?Q?C3Ovy+eZ4F6rw1m+Jv4SGf/ewY0MQTOuN4qBuutXU5y2zelmXFmqJpt92Oae?=
 =?us-ascii?Q?2bYdlEjc59lOQQAZKM49LOwS6FpYBE7unQfTp6DASdMOJeBxlNzlJ9w40HzS?=
 =?us-ascii?Q?11ih3DbjYH4dGXfQE81uiQIPCLzrJJ3gRlQj0kWbJ2xp4MfgAnwqU988ihZy?=
 =?us-ascii?Q?IznIJbGITKvWkjTKV3rUQ26wOKCP8t7y5bwYwzwalWOYx9iZMB0ZNwDQf0nJ?=
 =?us-ascii?Q?NeFiyRCh8hWEvUdGgeF+Ahy2v3m6d60GHwu5MWW1lXOZSbEpTtux53Q0dvTP?=
 =?us-ascii?Q?07UThNLwyHKEG9S/3kw2KQTLn4ZHgUe646qQQ00h15fyw3U8eXK02N45zFqh?=
 =?us-ascii?Q?F4Q9QGZ/9A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 643d8374-6a15-4081-3a1b-08debc6f8483
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 04:13:48.6429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AqnqRsGqgswcwblFOd8EuMJpAoAXuOJinB0VF3HA3Wq6W8jn8b4goJa0qLu2lpBMpNEWcPLcAIG6vOAld1eo7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696
X-Stat-Signature: g3g8dufihz4yzordda1kxe359o7nfq83
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 85F92120009
X-HE-Tag: 1779941633-458289
X-HE-Meta: U2FsdGVkX19WbFQckE5SmwNbG2bvx8rOKcWEADnjN5w38JbwJh40PHM0fi9dfxMawu/G8KVHRK42Sp/mbbO9YELhQ2IBWI7K+alyTZ2bfAZWHUL64lUJthXX7yNGE6N275uzVwkfHr4XFjYgFYzS9F4LZ6kwCzPFVhgmmbm6jnnPw9dDKcR73UdnwHB/YB4swZrKNQrp+dzRKr3yMhqbPqTV4iiB5FvSu1m4SoQtIQ9HuShWUeow3IBZyS8gTp6uqZQaL60KRXcB1lHXHlCHUgWP5nWilxmsOkIu5CD8rl6sXZ0R1DT3zt6USCATszDMZYmw8uDVy4C7/OJQuxWn0+Q7QKULaj710IIPfjrG8z2k7lyHm+cAkWQEb72AKFIcZt9OVz/kiyGoEucEG9fxIOkcFWA7kpB9WSHrZAH5nffmOVKrHxcf/+3LKOuP1HfJEyOQyTjbpVdA6sNa/9j0Y5VnDBTVpP6byxvItJO2H3xSyiA0n41ObaCpIr8ifbkQszl3Bv76NvkjaTR4qH7bbEztD/Hngo9P8AmcjUnr835I1xJ+7LedIVI92PUC/7tP/pyFIwAhca+mchKKlzz5JCpgckNWqM/KdYiZhDYNPhdMh7aYtaL64rt0WfGk3Y6H7brX4anWGrzyJW1BFXwKzawDqU8/+nhEfa+c4O7vP/amoCS/dQkajBoWvjQ+Vau+jSQlmrK67aQG5nlS+wofw3g1YAD+0uLN7oSrR78LmPizZ6SURzPgNwowIisStw1Z3qO6C10uIjwjpxT6bXgw3pZJrnBBNuFW0jLRDbVmFYBTZZbwcznM9FpfpR/vLZLO8Ao6CCzFuYsE8m//aYIQgcDoeiApZBjU/pljKZAZicoDgnPN+H8tB25FMltkCzIdcGsPR/dQdTrF9XG9yqFGy7wpmcFAu3K4ZfM/5j0ZN89aqi0JTqcyAQEIKQp2KZ7oqx+fm7kL2Atd5HrY2IO
 pkRKmtcx
 SCAHgYdxeDIVEdsqzwWGApb+S/miN/gryt7jdYdcvPv1dstxF3VqqGZvNfccI2NFFF28GgHF7xucF74jBbNeNdnQmxKqLywk3Ei3CgBCRJpdivG9ilowtERO/n15VMA/oiL8kS2DA/3RPpojVWEh7dCdyYwazzOoPbu2nzqEIZ4HCZ1/AyVCSp+MOT3l9ZqY01PufhG6ue4YyEczSG49GHEKr/5nohS+9UTkVY380b1anLSzYXJrwTvq7VOq1N5dIhcG9Jcddm9nuQZlyB1i7HwBt4fBgVGga5zpJi5Uk6sGi7OlbgJbSkEkb95z9klTk26f/qpb3j52kqkd0Y+Q5pn74rMIsT7Ev8lMwMlYp+EiCIth3Mklj1KG8dGbygAtuyGP/RkuNF3J0Q6ElNc7R7m5Y2q87AxUiVJJz/wk20aI25JAH/C9isaUr/ne6aKkbOkWM4uSgsZa60eEtBdSw3wXv3D+GMtKZ0xMOi5rUZ5hZlTt/HkL7ciVkYvrxPoVwtfuIqlBhst82RRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-28 at 11:13 +1000, Hao Ge <hao.ge@linux.dev> wrote...
> Move the kvcalloc() calls after the early return checks to avoid
> leaking src_pfns and dst_pfns when end < start or mmget_not_zero()
> fails.

Thanks.

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> Sashiko report: https://sashiko.dev/#/patchset/20260513082525.154036-1-hao.ge@linux.dev
> 
> It looks like the other issue reported by Sashiko (dmirror_devmem_fault()
> leaking args.src/args.dst on migrate_vma_setup() failure) may have already
> been addressed in mm-new by 84808b0e9f75 ("lib/test_hmm: fix error path in
> dmirror_devmem_fault()").
> ---
>  lib/test_hmm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 213504915737..0c02871b97ba 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1111,9 +1111,6 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
>  	unsigned long *src_pfns;
>  	unsigned long *dst_pfns;
>  
> -	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
> -	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
> -
>  	start = cmd->addr;
>  	end = start + size;
>  	if (end < start)
> @@ -1123,6 +1120,9 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
>  	if (!mmget_not_zero(mm))
>  		return -EINVAL;
>  
> +	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
> +	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
> +
>  	cmd->cpages = 0;
>  	mmap_read_lock(mm);
>  	for (addr = start; addr < end; addr = next) {
> -- 
> 2.25.1
> 
> 

