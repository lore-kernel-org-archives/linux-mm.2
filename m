Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D054CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFC66B01F7; Fri,  8 May 2026 12:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9130B6B01F8; Fri,  8 May 2026 12:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C066B01F9; Fri,  8 May 2026 12:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63ADF6B01F7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:36:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E06C41C0062
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:36:15 +0000 (UTC)
X-FDA: 84744805110.30.12602A9
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012032.outbound.protection.outlook.com [40.107.209.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 10E8CC000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:36:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I20ie6Qr;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.32 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778258173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkDTPXKQ+VBbsmAsYlPAJ5XT0+dJPK8v1+QO+m/Qovc=;
	b=Elzq4RoBKSvcctDOxR0bbpQo1DmgBq8syXbVJWG6fj82heg5Q5HNJWP6pRLVGkQ7AdzgSK
	2KHT+ea/qi+xmNJ1LeiTM31/bcxQ0BFIA9bnvFsurWWlH4T1r0fAKLgNSIpnsFx1ix+56t
	6o2zAWl2oy0d6USJ58KNfVb/IfZcOzE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I20ie6Qr;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.32 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778258173; a=rsa-sha256;
	cv=pass;
	b=UMXag/8z0WUU6bBXW1pP5iY3l88lM7oPILiSi/HXBzoZ+UFfRxIaCB11elWQT2MmqcltUW
	ccTvALSA/BdALC4l/+ATNfLyeN6YyOkd5wdFBf4SO0u6eqgFDwLQFArOWUgmb4dEMWnn0u
	EDOA4SR6ci5oDE6R5hRbCdNAYDsgJ8s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jXW1OlqVVm/raZ+mzHTYeTrYYTml2ZHHGAad6E2kD8YUv/T95JJ9NvvwKtdI7Uday7ZRcN4DDmqBYs6OUP8mI3E6qtYgfGa87UCrX8Dz7cZgHXKR9into6k+YDUhBKzBU1iZhXAUP51CkfblXi5/iEK/odY7gAQX4ZivttAWR3R7IAbN7914UnBLVU/Fau5gQvSoB8nOBlDH1kXFsoeY6rmOXoR73mycdu+1t0G0GU+7OpU7m8ByCh2qTdHBTIzBOIA4ka4dl6VeBiFYYKHzf7xQ8cT5T6fcQTv6brY1j8hhxcq3hCwn8L97EaYk0/SgSaU6omZ/9uzvxcLgcGteQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkDTPXKQ+VBbsmAsYlPAJ5XT0+dJPK8v1+QO+m/Qovc=;
 b=II75D6as9lFIc8zHBF677BtbOtQ1Xg5Zuhxqlh7Gc0BPjFEHdb4xeCG0EUyJ0mTRYwZnd5RSaeLfXGyqFUdp9QJNEdRe6kZPWxEYdwm/GwQmRmFfwg6GejJlEjDjFjeaARK69P1vQ//8IN8+00hGhHZmhTMBS2QepcUu6nQjHZnGAv8cUTMvEEWa9eTaXdlsetOYoTD/1khL+R3mSuqvZNupW1G+olYN3Dh376gnyfQ6jd7Bbvg78rcss2MICgNDnVx4Q4GPi0YYvnmKkH+svHVAdRL4/7wzEUG8LGkGYNuXNhV0HEYR4UztRm8Z8DHn6sjn5LJ0VnTEtwwEStb2Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkDTPXKQ+VBbsmAsYlPAJ5XT0+dJPK8v1+QO+m/Qovc=;
 b=I20ie6Qr/V8n+xpiCQg2rTXbvz2NnnOYeJONpD43GQd6UA16UnqSWUp2NvKSzQGRtJSihQNl8uDom6j0yL+GVON0u+6mtIDi/tnGCOFVolO2eDUOilH1K8CGgV4nZHsOWIIh/6YXClPS4HJYsRyOjEZpr4GmgDSLyAU8Yx8CVT6oRLKf6jxkIeRTiIjt2N6U2h+2hkIp6vXyxc/rZGN/T2XH+XnWi9+Ib0NYbSTcB1ddX3JU7z4Ij8n2H/GFgDn4KECFBw0A0hasZh0DMNxH1IOhpOBCpL7j3+Nz/Iimtw/ZZNGrWY0JHW4VdmN2qu9YQ1ZLxkp+1magCTXKZce8pA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CY5PR12MB6597.namprd12.prod.outlook.com (2603:10b6:930:43::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.19; Fri, 8 May 2026 16:36:07 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9891.008; Fri, 8 May 2026
 16:36:07 +0000
Date: Sat, 9 May 2026 02:35:56 +1000
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
Message-ID: <af4HwfEtza4JYxEd@nvdebian.thelocal>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
X-ClientProxiedBy: SY5P300CA0043.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fd::16) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CY5PR12MB6597:EE_
X-MS-Office365-Filtering-Correlation-Id: 83319044-775f-4638-1d2e-08dead1fe771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zOjhdQZ6664YVXLDzfZKIu0cd3hZSH2fu2JFCZing+aFQiy41572g00gBiUSFZ8rKBT23/mAu+6OdC1lECE+ppFkJh7ZwPxyWiBghYZGr/XnPS7GOX2Zo5p+nwCyB4kHFNQvsLT+Son8eTubMmFLCFyi8zPh5zyIRVOL35LgFBjnojHmRmXdIkLj4LxHcANKfG5Sfye8vCJ0aRmAmmiorWtuJrd941FQdrkHhmB+hObgeZF8+U+TbKuR+eO46nVdKeIWRrSqshP31Odm+c82/44OfQb1hMmMU6plTnnyQehYjYIc3KMgAESsncx3dVQj5K5L8yhOL9V6kjrBHlluOCsueH1CMS6O7f95onm/p4Rd9YSi2c1i7r2kX4BBcqux44l9V00bGxWWs0fDrVQ0R2Zru/Y6/lO6gdQN1oohehXTHkKjRMPz0BsyJFw+8D/A2jPdWcdnz4XDCgClSvxvnVhs2WksEC8OqX4Zo8eS2j2NIhunm4rQJQY+viEXc2k32y+ev6PCM4Xp+5VU5AcePZocGws4mmjoRFiold+3SSG+lHufHNvpJuGHdpbF6o+eWYe4HPEBLNLyOp6MgV6pSb55G6Tg3EeBzjLSa7juVqjuqEhzRAJj3Hu/cwe/2QGOTSAcFYoDQOBHHXQQ+MNL0QBYWP0Snkrd7VgIpjb9BoVmtAGCe6YWJ8HaAdL4fNnx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6QRleL/TRf8ZzXnx8ACTnOnsP5qOvYUntqvsS4Pfgarqr+t86F5hmGAZhBzI?=
 =?us-ascii?Q?bFfNoerY5EhDG5tNEp9PSfzpqaoJh7f4NV4e4GyOnRYGfhOojfE17zl4NkT+?=
 =?us-ascii?Q?qN7MO8AjvKW7SHF89o13d5xhHEbhBlQMGI46B9hlNlumrVlhMkuvmdg6oVjP?=
 =?us-ascii?Q?V71/aaybamiKLIwgBuBEBek1YB0AAbrdoeHGFFLAjesyFWT/vH+oLvoPjwZT?=
 =?us-ascii?Q?RkrLp4rpGXOa5iJuCmnWT3+GewDzbysCMeoTpSZyswAzmKgBO7ud2HIEj0iR?=
 =?us-ascii?Q?34mmZwzUJR9bOPFkXjE63w6HwskvGNT9EQiFwc/pudiL4kpwY9PgtYndV8jD?=
 =?us-ascii?Q?rKSXeQPa/CqREuX/1BI9VhqHZ7sLxpTnVxFPoMmazSjf8pems+hxggwIaXAl?=
 =?us-ascii?Q?IIqkNPQZsAdeubAAd3oz2FboicTILy74DTFmwamBZRB6a1Ybf/ulaGkYGQUL?=
 =?us-ascii?Q?ppX8z4/hYj79jAv7uln68vmaSjLn3vqKZvj9hsm1O32G5kMvOKRulOp0pRlp?=
 =?us-ascii?Q?eg6hfFGY5/SdTkbpvWyn/SHOJIv06MWhrMD8HpgtlAUQNabMOn7lEREIgVQv?=
 =?us-ascii?Q?KBhAA7+GkT3bIMohGUNfB5V568mX+ZMIh6+xBluaKXsuFloNoPHwpE4cqzpU?=
 =?us-ascii?Q?a/dV4heSChMCxEjcbTh4Y1Y5KQFrem3nds8yWZskzffkIeEsUvEKUFTHE5+j?=
 =?us-ascii?Q?OaHFxR/YddXyKOSPTkSjiQcvHtWDCU05OjhhtGCg4oi/cIK2CVUU144wL7zP?=
 =?us-ascii?Q?SkgYilRExhmCaa0fRVF0BrlOTu/g+k7IAZ0pDBmb98x2a0Gm38Tx8QBiViKb?=
 =?us-ascii?Q?D4lHJ5sx8EUioA3eOblwOIYsdylbHESbCiFjcuXVgwfsM+5ruAZTis/ZJau7?=
 =?us-ascii?Q?wyk2I7eopS5kK+LrwLeU80UicnXbQtpocYhUfT/4auDtyThc2DMWtk2y+uOB?=
 =?us-ascii?Q?fx2S5x/tWvEVljcbDVNLKUXoj9Vq7LxGJdT+QXxFNpBZYMT+hF8P0/rlxdAL?=
 =?us-ascii?Q?p548A6RcwsejoJLjBk7ZCCTZKLEyhVmfvCHFAlT9Agw/BG8rO+imylT+E4Xp?=
 =?us-ascii?Q?d4BgKXQKFJbsMWazXDjpjciOosy8AhJywXNurjFjn7tq+ZFfjkmvrcF+KA8s?=
 =?us-ascii?Q?+MMO90li0KEJJtaEquxL3u2d3Ua5WKAmKUcy4xdVPZqunGHnzmsUyYLB+Gi8?=
 =?us-ascii?Q?1tY6HeBltJhr7qB96YAbSCoqSifHnA/+2oNmo9Lg1QfvODpcuZlTl7bCCCIw?=
 =?us-ascii?Q?fU3rboJsy5SkutstwiXwa0JRgZ2iCiArufXy4kjSrzYC3/7LzkteWB/nyqWo?=
 =?us-ascii?Q?mPTwGFkOXBuuh+VX4PX8Q6QL37wV2+PgZ11fgvDO71MVb143bfOXc1MF+BAd?=
 =?us-ascii?Q?RFy7TUlS8PLFUCuVhMMA8EaI3ASbWkQrRSGDe3RLFAnHE+YDUnAyJS5DxQaj?=
 =?us-ascii?Q?XoSu5rCp37TwCLUvPSxSTKbqI/0sAct0rUP7fBUMFtwB4HCjO0OaUuOsFRyN?=
 =?us-ascii?Q?TDzs8D4JU+L+oOmb5KCoJqFrEGQ+htqa5MYFuEbQ57DqcADiJkrbnlqPDx1B?=
 =?us-ascii?Q?q2rctTAJjKEKdkQ9gB3Kgkux77PFS/R3EJ9T8BvhJrL2H97q27JvE4g9nFQd?=
 =?us-ascii?Q?U9wp8AKr/naB3bvVhixZfgrkBLxH51qn0xGYUckBcMK8CXoenihbRx5O+qxH?=
 =?us-ascii?Q?1V0t2RjdoZIny9nTI2TNlhoPGZaarwn9OU1JS512CXKK4zUQugWMJRf9UTtn?=
 =?us-ascii?Q?jX2BO5IOYA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83319044-775f-4638-1d2e-08dead1fe771
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 16:36:07.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xb8X/iKxvmnjRTVGvNizPrEFuZSgd/QjK4kLZxfQIPSOw0sABhOMdiKQgGhGlmpCni0wBEy0M3r0cA4QQvDYCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6597
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10E8CC000E
X-Stat-Signature: fqgycmpa69ngrrdresaq7knq4r1k9act
X-HE-Tag: 1778258172-949181
X-HE-Meta: U2FsdGVkX195cT5tZseB/hReaUsBOMBCie98Lb10cK0ZF0n0hCkHrTJrXMq+m9+U3p1DIJQWYJI4ScboNDzo/JeFMze+ukFm31QdH2XzkLnVhxuR0mx/zFvE+rNAUkmiaWOz2w3FIq1AdzzWWwn97ivqFDqiPb/rV5Uu+a+lIm2H6FOfLSwvGTjlgfguPLVFjIbHVe8SbusIzfvWk7lC2jD7l93lwJasvvP9M1DCiSxByS0BtuDo2E5JQATJSq6v0hsM0vCLNcxgk6zlriZBdFpLZ3S92i9Y8/SnwRje2nYXWe1zdjp1rPptj1jNfuCm0Kjx9msSDchQrAHWIoaWFvVrncoU5wH16pvc3xBP67YamG5ZgMLVoEgBGEyYm3yr4g7t2CHl49kT+HD6Pr/G4sfaDQ43eH2S1x3lKdnJ7f7blscpVI9/QPR+a8QvvVVgsgOUmvuSGkqAN0wo+5qDXjidxz65doRWelYTcgmHlrExho9Q/Qjr1t28UbGfJvdPILtmhPcAVMmZTwYtKUw8Oqvg5KcRlEGi67WB1S1+TFGLRas6KAcENAK9c10MtdwG/PJ6ZyhKVlPd91qNNsKlkvTh0yDbWqlau1vPSmr3zWM3dlTSEplqKGn9Byr/1/amfr7lDEXBneD7AaawmvfSBN5KAGuCnLU2fWAU3SLD07W8sE1P/yIbq5y+2+7XBrldhyV1YhneBkVYLzWV21ttw/lReJzSjvigVDtMfXOLnZg1c+GJGz0LIRTOFhhzHnP7YjM9WZyKol62NGcrdS7y+1bswFOfb1WAtaW/5Azwl8C+U8hWczQSf+TBToz0tuhee3vQOGdZLZEHqPeJlBQvRDNQ5dhbMYEZ861MxQq902EOWdK8nmZIVQIRmhA4jUNulp7fjtlSvbQhZ2TaKby3rEcYcFGA6LgMVXrI7DvOh3eOnOwl5/q5T9Myr5xvZdQH2hAiN9JZfSpzKWir2I7
 uhiF58vL
 ZXZ2NSu9PPcUJCRSb7nm63Z/MJ//k9acFw06yi/YON14VYsqyzSO14ABBKhxHkqUOvu79B8EQJnyq3dr8Qb771umiP1DCOGJY2izKoJnJ8m6I4NmWD+nZ7GPGlUIC5sEo8W558xLB7UvISiketp2Hh5kt7XPDenF08hC6aVtASle10WaSHx30FOXuWZ8pFbAzJU6JwNTm+UEb/VuBhhU5lzb9FRh0sXhcl3FSnncBsum9brlluDPwLzBdZ6g0ddsT/vcID0R3A33yiogYTf36+rxk3hCQ/41QOHLAUzxx9JkQAC5C1va68gejUzWJIxbfgzR38CDS7sT99SH1cwIOrZ4Vqzfr/L2SY8ntBTSzqCzqAdtmY6Kgu0x+t0ETdY94rV4ID2vhqu5AROTBsew2sF+qbCNKR8YjNaaB6BV7co9G08FZdjzMOBPzWCgFAkss1ynSm7qAVzfTFB7oWC4r/4Nn6HXO273+RwgD/DftMkvDsZVfdble8SE1dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-08 at 21:53 +1000, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 5/6/26 17:42, Zenghui Yu wrote:
> > Hi all,
> > 
> > Running mm/ksft_hmm.sh triggers the following splat:
> > 
> >  ------------[ cut here ]------------
> >  alloc_tag was not set
> >  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0,
> > CPU#5: hmm-tests/2020
> >  Modules linked in: test_hmm rfkill drm backlight fuse
> >  CPU: 5 UID: 0 PID: 2020 Comm: hmm-tests Kdump: loaded Not tainted
> > 7.1.0-rc2-00099-gadc1e5c6203c-dirty #285 PREEMPT
> >  Hardware name: QEMU QEMU Virtual Machine, BIOS
> > edk2-stable202408-prebuilt.qemu.org 08/13/2024
> >  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> >  pc : ___free_pages+0x2a0/0x2d0
> >  lr : ___free_pages+0x2a0/0x2d0
> >  sp : ffff80008345b530
> >  x29: ffff80008345b530 x28: ffff80008345b700 x27: ffffffffbfff8040
> >  x26: ffff0000c41cb360 x25: ffff0000c0c64008 x24: ffff800081aae400
> >  x23: 05ffff0000000200 x22: 0000000000000000 x21: 0000000000000000
> >  x20: fffffdffc5f20040 x19: 0000000000000000 x18: fffffffffffe7c78
> >  x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffe7c98
> >  x14: 00000000000001d1 x13: ffff8000818f3d58 x12: 0000000000000573
> >  x11: fffffffffffe7c98 x10: ffff80008194bd58 x9 : 3ffffffffffff000
> >  x8 : ffff8000818f3d58 x7 : ffff80008194bd58 x6 : 0000000000000000
> >  x5 : ffff0001fedb1088 x4 : 0000000000000001 x3 : 0000000000000000
> >  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c7f58000
> >  Call trace:
> >   ___free_pages+0x2a0/0x2d0 (P)
> >   __free_pages+0x14/0x20
> >   dmirror_devmem_free+0x13c/0x158 [test_hmm]
> >   free_zone_device_folio+0x144/0x1e4
> >   __folio_put+0x124/0x130
> >   free_folio_and_swap_cache+0xa8/0xcc
> >   __folio_split+0x664/0x7fc
> >   split_folio_to_list+0x50/0x5c
> >   migrate_vma_split_folio+0x13c/0x25c
> >   migrate_vma_collect_pmd+0xed4/0xf68
> >   walk_pgd_range+0x598/0x9a0
> >   __walk_page_range+0x90/0x1a0
> >   walk_page_range_mm_unsafe+0x194/0x20c
> >   walk_page_range+0x20/0x2c
> >   migrate_vma_setup+0x18c/0x224
> >   dmirror_devmem_fault+0x188/0x2b8 [test_hmm]
> >   do_swap_page+0x1458/0x185c
> >   __handle_mm_fault+0x85c/0x1ba0
> >   handle_mm_fault+0xb0/0x290
> >   do_page_fault+0x1f8/0x6f8
> >   do_translation_fault+0x60/0x6c
> >   do_mem_abort+0x44/0x94
> >   el0_da+0x30/0xdc
> >   el0t_64_sync_handler+0xd0/0xe4
> >   el0t_64_sync+0x198/0x19c
> >  ---[ end trace 0000000000000000 ]---
> >  lib/test_hmm.c:705 module test_hmm func:dmirror_devmem_alloc_page has
> > 16744448 allocated at module unload
> > 
> > 
> > It was tested on kernel built with arm64's virt.config and
> > 
> > +CONFIG_ZONE_DEVICE=y
> > +CONFIG_DEVICE_PRIVATE=y
> > +CONFIG_TEST_HMM=m
> > +CONFIG_MEM_ALLOC_PROFILING=y
> > +CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
> 
> I assume there is a weird interaction between alloc tags and simulated
> ZONE_DEVICE memory in test_hmm.c
> 
> @Alistair, any idea?

I haven't managed to reproduce this but could imagine that would be the problem
- not sure page_ext is supported for ZONE_DEVICE PRIVATE pages.

I'm still travelling back from LSFMM so will take a closer look next week.
Thanks!

 - Alistair

> -- 
> Cheers,
> 
> David

