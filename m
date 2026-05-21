Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F492CD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692296B0096; Thu, 21 May 2026 19:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642D06B0098; Thu, 21 May 2026 19:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532096B0099; Thu, 21 May 2026 19:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 419516B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:48:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3FB41C06EE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:48:43 +0000 (UTC)
X-FDA: 84793069326.18.375B8C8
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011039.outbound.protection.outlook.com [52.101.57.39])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2D116C0006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:48:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gYj0Cz3/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.39 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779407321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgnY25yqNxUKOJpfH5fcM6fKStwF9bq2Z47pT+hU0yA=;
	b=rV2Mbn3nzXa+6qHyViek3N58zMlJ0RFf4yw78bS4wJUoEMpgQECTIXtYBpSBUgY7QeVHkM
	NBttNgXON0Va7O0CLNb78G3VMyK9v/zpPCakqsIuRRwl1Ym/rzTvRbnbkflzQ2OR5FkyZQ
	Bnc+KgAl9P5eB+Esw+a6s3MzZp4wvv4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gYj0Cz3/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.39 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779407321; a=rsa-sha256;
	cv=fail;
	b=2XlNHvuiLJV+7q+vWP2bcOb9aF1PPkQcryMf2RsIi3Iy2r5nbjezEiceUZ2MssMf2Xh6jq
	SDQVxEue+qMxSok6W8kV4ovHAIrywem87Xdcgsdjs5C8Wa2fqIUk+NXiSGkTKZ0xPZW3Gw
	y5bIm00MH73Sz3xcw7gBxIMYU0cSeGw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bdW+fg3BirBT3C4m4lzc4/00wK6xni/tGxoKyIzkfVIu5MUTkfqZSBg18TczCT3UnMPtTxuhTtfu4bqwKgfm10rGRZQPWaMFSpnTBWUjmeoRnTUk4reOMiyYH2FVBuoh8EhG455OhxR9BEvZ16k4poyCl54g3yZcwOGEv4bBb51wHURYMp9uPtK8zrWnWXKcRxfW0e/M88/AuPmr/G3dLFFbODDIudkeLj5cBScfRgYbYWRqKY/PfTIshw6BjLofp6qRkr83/NzR2893C1I65xk5JeNK4674cjkW3l32N3QnC4z3jbh2Csx3jbvmcN0F6hziKLUnlRTfFG7x0WnURg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgnY25yqNxUKOJpfH5fcM6fKStwF9bq2Z47pT+hU0yA=;
 b=U935w2ItUqIA8EHSJGrTcjysMztSsATnVXwN/axK803AxjI5oJKOPtKrQ/R8G1by23/t/e2qqmXesAZyHx4ZFial5r3nE19gT7wcUh9vFHExtcbv/UHXfudtEv2skAXnBtX42LUF5GDTCxnCd/WANUPN9oxGuM0BEkMEaa5m9Yr6zLDpFmMl3vBogy5qN5FtrU8k73oeAfxVMsceKYAi2dQJiveAJ0rGsRfZxSK3U8l3hV2IAGDeY52Xtl1M1Xf5SFLY1lOn6QqsaRBLnf4uu5VyBgUtn2ke2saiS2sLmttChId261PKXAOqsDyrSEeXHE58HP3Qjj8ppibzAhGqSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgnY25yqNxUKOJpfH5fcM6fKStwF9bq2Z47pT+hU0yA=;
 b=gYj0Cz3/A0uWcWSxXnlzIarVNpTfAUS8cTyHKGWB2ydQ/g+li1Jx6NwQySRlw4RKdAEp08eBfxTPltR/dard8F/ttgbSRyFcsuR6kB6TXybaS5keqZNG5OXZEEXe1EQbF+/w6d1SNmoQzgJb/YMK6EKHsJ1d5QVd4dURztAFrD/9JxyBkm6ghueh6lUygZAB7VjSRE72mDUd0gc97VMnp/1DqmvO7kAZosEYfM6t0MSRPZdQmC9mdQWXAoJ+76lGMByVjx0AQw5fSnIuoZzM7sqQgNAkLTnkDbXx7zO1KELdoXqgvltpij/aHIUnNWbu3Wue+himI3V3EhsjJ5umpg==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 LV8PR12MB9084.namprd12.prod.outlook.com (2603:10b6:408:18e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 23:48:35 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 23:48:34 +0000
Date: Fri, 22 May 2026 09:48:28 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Balbir Singh <balbirs@nvidia.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	catalin.marinas@arm.com, will@kernel.org, david@kernel.org, anshuman.khandual@arm.com, 
	dev.jain@arm.com, jhubbard@nvidia.com
Subject: Re: [PATCH] [RFC] arm64: mmu: use range based TLB flushing when hot
 unplugging memory
Message-ID: <ag-X2xdLVv31R0Wn@nvdebian.thelocal>
References: <20260521042426.2128731-1-apopple@nvidia.com>
 <bc96d822-bb68-4945-9f74-68f77e389ac6@arm.com>
 <ag7fy4Q9foBBlUcd@parvat>
 <60542cd7-d01c-4247-8957-8423b54ae99d@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60542cd7-d01c-4247-8957-8423b54ae99d@arm.com>
X-ClientProxiedBy: SY6PR01CA0094.ausprd01.prod.outlook.com
 (2603:10c6:10:111::9) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|LV8PR12MB9084:EE_
X-MS-Office365-Filtering-Correlation-Id: 248937e9-2a31-403b-6b88-08deb79378a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	nrRTrI+G34ld/S/ZuEb4NNrwwJUEgE1/5sN/N+QMsFQTdQMocVxsvJF7Vv4v2zW6F5B0JctKaj2FoHma2xn5i8BVciPzSnzvFT3quZkho3ENN/v4LHBo4FWDv7iGL1Mx8qQQfFDhFSA6Dw29mvsihbruTmggbRoTj90+1v1VkKSgB+rMMgyehH7nbXFsZT957sJxt0yIFqsdNYtR/ix4fYZ6ThyrBxkXpMfryX8v+EKF84ncwFVn9OIeHnb8LaLJ0F++FUjXdLSNOA++G8RkPtmFYJW+qbt5QhWh6MOhBD7OwrK9n9Wk7kdnlRrFllRsXTSRAZHtO99ILYegRlNbNkKp6TDLBaSCWT4zHeEudsGltFSazpnVZ+xxUm3WVyR1M2+rozPg7yJ5AizeA2XHIa8UpbY/kgK8mB56vHnN+swMx80g/JQwxetPTRZOIsM4rACWi5/beLtXpk3vXIvQ692oVma3NO104zAheVLefNdeL3t+Am//D0r/OFQ0Tfcj4U95EIMo8bBsdO5FKftiYF66maZkjt0DBgrzgxL1qK0FC+wA6wlFXfLxPLoRlW8RVgILmGwgNHsbp4uiPrdXWMZYGcCqCjNWHA0xlp0Pt6wVJ5AbA3w5dJ6HZaJ1LwzSjKZRCeP3vcDcKOIly7PtHe2azE809ug6PFxq8HdzTnE6ANWmvv5VzfxGEgQ2grxX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3JjzFegRUqGG/Ng8EiNpwUdDS7uTqb5tN64T6gvHbSjTaL5YbiSOngICjflp?=
 =?us-ascii?Q?HF1V9OSQIKIwZV5HoQJpmrxGb/X4NEu0eCnCHdMHWUDK2DlR8qy3yssPd+dE?=
 =?us-ascii?Q?ovNuT5dWJouMEdhuwjE5pJx+xBv2Cky7IpOGFlx9xMFj9UIv4ut17HYudu2I?=
 =?us-ascii?Q?oUzGfEq2UK6/Pgmrq5aoHdUUyLXHGozqfovrTcuZWYM9DF5pYi1eT6bRduol?=
 =?us-ascii?Q?2Op8cm28wt85JdM1jCYaCqBJiD8A5meopS4x1gixyIjH3dwAHIRSgw/xaDho?=
 =?us-ascii?Q?AkJ/FPeUO3c0LnpZQH0F2IX54tkfpL4D9fOx5CX+BR/qDgCn8dErTMyfTxKn?=
 =?us-ascii?Q?d7dfbthMKi6iBoDiA0+d+rKl8f1xdy5TI8OSEpGYaPXn3WLrD3Czp89H+Ej7?=
 =?us-ascii?Q?Znbq/mfNC+YfRM3w4aYqingvmhXqsNaQ2F3IVyUnLIGTsDJgoTocKKt7w0wB?=
 =?us-ascii?Q?NOxnWZE4z+76W29BEPDYTRJz2kZzhntZF/jh0ZqRXBNbJqcBrkxeoDUq3C/c?=
 =?us-ascii?Q?SuhrDP0gTLKIsc2Z7H6OYzDGP5pLR9gDD53RnhcxodwhdI8Rmuf009+0jrfS?=
 =?us-ascii?Q?l4S+fy3r1P24nmO3OT+AH0Ey+qu/iZgbSgYCfUuVNo3UAsfdsAwEE44qVInM?=
 =?us-ascii?Q?S/ENaG4LB93awEB3rHy59Eckg40VB4UTW1dMlLe6Uw6fY6z+x43E9ytuF+At?=
 =?us-ascii?Q?u2I/ArpqcFybnDRffyC2AI6qdQblrbWT0nOWCXIsqdp0bGZ1ng39bmaJ1kBm?=
 =?us-ascii?Q?TI9Eivluwj5Rn/Q1bFnNJaa8b33Pw06VRX+mANoc+a+hFdIQejvjCrFeAZ6s?=
 =?us-ascii?Q?A1VyBmSZP1qwCEHwE3ljlo/apX6G7T3GeHqQyaTMGEg/RPUwtXuZ5T2uCTuC?=
 =?us-ascii?Q?nf4qjnQEh2qzOd91iMEZpQNd565HYavI5eF9jU0FRfiVEgnPsBcJs2SbEJAp?=
 =?us-ascii?Q?fzTyyxIwbXqG5VXSuSk2pTVKsvcw0vj2uKU5PRMhWc2HV6cb3raLwyvZcGV4?=
 =?us-ascii?Q?rZxIGXipNLqJOXp8+YXUX2SUTFtajU2sgb9tVGdD/YUzOauSzHe5wRtJjHmy?=
 =?us-ascii?Q?8EiJDdi5UjNukDVyOoRp8k6kOh0MzRI5b9IVMB6eQhYDV8EXxIMnF53vYdWH?=
 =?us-ascii?Q?9lMOQPOFUdXk4+7lVSWPGofZtlJEewsP++I6tcFK9nZeTHIeIl+FfDvcDJZk?=
 =?us-ascii?Q?uLDgwF0W7Job91bC5sWF5qvuBFTF3ygWvqAXtg1a7/xgrM1Rm76Eu5xltmY5?=
 =?us-ascii?Q?WDa21/cAM2ExhoGV5cTPhMQiXU1OU3kfmase8eitcYWzrnS6muh1fzqmVnQN?=
 =?us-ascii?Q?wpGTGZhHgk4EHlAaIkQuzTNNs5J6QgDXQ9suP3y7x+t3JnGBqh/AFIhdr+rB?=
 =?us-ascii?Q?oG75mioR0JuYzED6t1NY9MHBr7e2nMsHn0tvt725MntTTJ7Nj1yt4VOU/Juu?=
 =?us-ascii?Q?61A7hVRPHDfCFvmVEtpcg4BaGcZqEwu2GeXQVbLEhxRMBpZ3OALVqYUESKOi?=
 =?us-ascii?Q?nz3hf9UPidvjHcrp9+0ZcHlBn7G0UDZPrsPeL7v0rdHSHIPrRUtbCXvqMqjn?=
 =?us-ascii?Q?328cvnqtei1FHVuNNM7cH1CQVylzm1qjgdbtKuN+XdGf3YMwbzBOGE6pxTpA?=
 =?us-ascii?Q?vbVOQFUlDtxfMpSd7IhzZs4CbG5NR8XNEjf6UBayWrwxOQRbhNnZTRT84m1v?=
 =?us-ascii?Q?RsC/kmnBTxWEkIPtf7rQTa1DBHHXaIQKDyYMlJ0OxtyjaxPVsCrIInwJCyhG?=
 =?us-ascii?Q?C7DuF7LVvA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248937e9-2a31-403b-6b88-08deb79378a1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 23:48:34.8210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dU1ljfoBnQ8QkbkOmcMiWLQDFOu5+LQwoq6uAd4y2rfPxkbjKIgWjyda+LXyGmKwMxKDh4I91LVsSxwRQAxAkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9084
X-Stat-Signature: iokro918m3rjymet5dtakapwj4icctc4
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D116C0006
X-Rspam-User: 
X-HE-Tag: 1779407320-720182
X-HE-Meta: U2FsdGVkX181kD2ERWJjMeJqzWkijWkWRpJOjvnkZkfD2LXs+70VP2ucsdgfxYU/7EX2gVPFAoS4I/2XqR5Z/57wpKk9PwyyuHAKWIpmOvMrId00zfqsaAcAsrOoijSDaZEkUfqOURrcwf5p0rgG7Kr0dT1HBY/VLIh0qEY4S72Ue8IdM6KWwg07UThgtzH+XVbRGtIhX8aR7nc3aklhjOsrkICXu92UCaALbzVtYk+Ctnmulq2jX4W8qO1AgMc4kxWD9yvrO1OYhZJQy66DKCc01EJdukJw/YCr0gdPoO/agy7ju4AknASDOMcVaJh+tKrhvyjF+ScfCqEuIYzKkCIEYIh7wrSGKdU2GJDDAzBztxyuBmMZAZk5UgvfL0IMSW7uxhI6GMlY1PbcIt9Zc0MMurwDfK6ZJKTuf5xyu9xPIOIlJun+iD1H6iEjVLfnjqI+N5iGKzd5mF3oRLjoIAzq0LOkVLzD8FSgs+2ZDfoMifXYqA+XXAu6FpGuU7tU2fMbDDSWffMBzHJlgG7Vm7UXZ0cwUkkEtDcpiaYozPy7vAGKWC1h/4pwGem2x2PnM6SySHDkY3ByXyXjMcq9W2mo9FT0uelt5NjqQ49HN3+Bf1kPxD9EYK18vZm3gPcHCSTYofTH9vQwOowcddVaO6uLevXCR8apguMgP5YGBc9zda9dJygl5kq+tqmOsCvn1uaW9JdLXQCoq8gqEEU9Gv48UT2WvV/LU/C9GZvW/CK+Ig/gvvgFLKaEWS7+GaocPimFDyb3dpOi5aZwzMtlc/TiWIEUUeEtWJCqV9hH64fGsxv+sa5Y2pkI2xt3AWg1kw3UTeK7dTDp3yzLeZ7f1r/mRl7DFUXP9NSN+P2BWULhHEF+gTf+acnIQBaqM5aFIJlOMmceQDqgIbplxicnZOYy/wc5W/p0i/CaZUHwzoZB9h/SwAD4i9kblS17eiLo17/gjrzMrY0B4oKkVeH
 BxGSLeJ7
 gLI3xxylPzFrwaPAYgH4HNqOCxMXwVL8tAQ+4j/BHPAZIg+CLAuWNwW67ZFqHgP4YVHs2eQJ9jEE4G8hbhj/LXJtWe2DiXIq02A3MpKYYN/0taNRHPpyhrFG/LMCKTMAvwPfnqmu2KvXM0F2xQGGR1zU4h3gqm1kfVk6K+mIm6xgBx5cBD8uWHgfWZEEaJ95xKYdgH3jk3V3nLlIGDJI1T+PsOlQMd2T/CIobpUWMNYMz1HggnYuheV9SRn/xD0WKJkvXxDGDLof935pqnDBvweQHGFYOsFjHqZWGP6g9gFMqhkSOEqK1L58+o0HeF0lobkqz1esGtg3xYTAKtJZ5C4e/p9/J/fhwhwLLVK+1IZWnNgkm1t+oal1FZ6SlqtmaBGZceH2hu00Yj0BjfcMjpjcQr9o1xaKlK1aKNsE0Ox9s70LznZBhl47AjiLLFjLqNop8UfYyVlP0a0lOF0CEfw0Y03+G62m7401k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-21 at 21:24 +1000, Ryan Roberts <ryan.roberts@arm.com> wrote...
> On 21/05/2026 11:46, Balbir Singh wrote:
> > On Thu, May 21, 2026 at 09:50:04AM +0100, Ryan Roberts wrote:
> >> On 21/05/2026 05:24, Alistair Popple wrote:
> >>> Hot unplugging memory on ARM64 requires a TLB invalidate after unmapping
> >>> the page to be hot unplugged from the direct map. Currently that happens
> >>> one page at a time, meaning range based invalidates cannot be used. The
> >>> result of this is that removing large amounts of memory takes a long
> >>> time and in some cases can trigger an RCU stall warning.
> >>>
> >>> For example on one system hot unplugging 480GB of memory takes ~1
> >>> minute. With this change the same operation took ~1 second, a 60x
> >>> improvement.
> >>>
> >>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> >>>
> >>> ---
> >>>
> >>> This is an RFC, because I'm not sure the change is correct as it frees
> >>> the PTE page before flushing the TLB. I'm not familiar enough with ARM64
> >>> architecture to be sure this is safe, for example I don't know if HW
> >>> can update PTE bits such as access/dirty in the page through a stale
> >>> TLB entry.
> >>>
> >>> If so this would open a window during which the page is free but could
> >>> still be written to. Likely the safe option would be to collect all the
> >>> pages to be free on a list and free them after doing the range based TLB
> >>> flush, but wanted to get feedback on the approach before implementing it
> >>> which is the goal of this RFC.
> >>
> >> Hi Alistair,
> >>
> >> This patch doesn't apply on v7.1-rc4 because it conflicts with this patch:
> >>
> >> Commit 48478b9f79137 ("arm64/mm: Enable batched TLB flush in unmap_hotplug_range()")
> >>
> >> which has a very similar performance improvement, so hopefully it solves your
> >> problem?

Yes it does. This issue has been niggling me for a while, so how coincidental
that I finally try and do something about it just after someone has fixed it :-)

> >> There are two paths which use this logic; unmapping the linear map and unmapping
> >> the corresponding vmemmap. In the latter case, the memory is also freed, so we
> >> can't safely do the range optimizaiton there since the TLB needs to be flushed
> >> before freeing the memory. But the linear map is the big, slow bit so hopefully
> >> it's sufficent for you?
> >>
> > 
> > I assume vmemmap path is for tearing down the struct pages corresponding
> > to the physical memory and vmemmap teardowns taking a flush should be
> > OK. It is worth checking if the issue is already fixed.
> 
> Yes, exactly. Assuming you're using 64K pages, I think vmemmap is mapped using
> base pages. So you'd get 1024 struct pages on a page, so 1 TLBI per 64M of
> memory that is being unplugged on the vmemmap path.
> 
> On the linear map path, it's a single range tlbi operation to over the entire range.
> 
> Alistair's patch is doing it per 512M in both cases, but is unsafe for vmemmap
> as currently written.

Right - hence the RFC. This was somewhat sent in the spirit of it being wrong
in the hope that somebody could help me figure out how to do it properly. As
it turns out though it's already been fixed which is an even better outcome so
thanks for pointing that out.

So this patch can be ignored, I see a similar offlining performance improvement
on my system (~1m -> ~1s) with 48478b9f79137 applied.

Thanks.

 - Alistair

> > 
> > Balbir
> > <snip>
> 

