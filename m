Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C356CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0C96B0092; Fri,  9 Oct 2026 16:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052396B0095; Fri,  9 Oct 2026 16:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9FC6B0096; Fri,  9 Oct 2026 16:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2B466B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:27:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1528C0201
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:27:28 +0000 (UTC)
X-FDA: 85304222976.06.CEF85A2
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id B67A41C0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:27:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PWSnP9E4;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791577645;
	b=TcFFr2koa+mJgxNyO76QEf7mrb6adyGEArNuth1Ce6AFFdVfK/S/J31sAuZHtg6z/FGOPC
	aJhws1MtBhB6K1xw1KSo7oTGw2E1g8ck5XuZZJWXlWQ5dxhycELULsKbBPXRA+CZ7jfGve
	3GR2cr7HD9DqX6ndZDlPUAMkZq3SwEg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PWSnP9E4;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791577645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSLrLC/0mw1IND1VhNU6i+Wa/Dj8ejkoFT/gSARp3/g=;
	b=bwMhH2kqa0SYeMRlE838IQNp9QPstNa/6LBG4ySb3UuHC3us1ePFsmDXjuswhfrKP4VoDq
	qzNKQkb2tSK6kXWEl7rVpx6z11h7rmALdt/nOJqz0nwHJ+KT1EjJTW80OFtbqJu2BSJtL0
	crFPoFduVAQVbGOq7C6NZ4pKRWrgpMA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6ICBE1nwi3C+No0pbJg63VtWGCUIN04J4FiTR7w88wtkzRTb8Q4gXK7WVwLYp/bUsKFtmtBZkiFNbiL6BPBiw4vKY80dpXGTGAFr0xJQOvZcg8XmpQ+Rc3lPbWy0JtW/Qr2ssrGWQFv+uzYJnrzjgPkMRjOoJd3I8Kwt+cB5QxXYZJnBvDgDCjplx2+X6gczCjfacxGxUI7bnFu+7/Fgafnhr9SkCkihT8wL82dBiDRlPAgT/+9KKTGtFTZWsfiThsVJUntDqfY2Kzsns0/ir0X8C50Efdd6U5cQ+rZ8Zu14Cb/YTBa4qR7teSY96g8FUf23IILooIMTxTSIBuDAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSLrLC/0mw1IND1VhNU6i+Wa/Dj8ejkoFT/gSARp3/g=;
 b=VPHM1dDF2lJljWhavV1y/HLUe0Rm5CDx+lGA4hOgHE+9F5TL6MLpkL6tOGDNB2DeMLWUdHisp9gadmoD46oiAdWbMAr72gxE2d/OoDtqONSe+hcGfWaN4OM0d2pEk8UdppBOajHUHNo/KGMRksOrADMHy5Gb9PZv4cmFZaPufNn2M77osUtArETljNPv8yQUqZ93aW05wsRVdcnHwPA31ltfP2elbrn53iJrSVfOR5DQ7dK/q/Vp6agh05/UCff0hbOv5Yxx8gWUEswFIsFxqQ9NokofRiPpt5rnEqV9b4zDa97WrV0eTkNAGnCMG/aYh8tV//UNl91fsDidZnbSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSLrLC/0mw1IND1VhNU6i+Wa/Dj8ejkoFT/gSARp3/g=;
 b=PWSnP9E4NBwuhTlRp8o4EtjKwApd71EbJ7scMcKuva2hicCOjSZDshgtBe283lNdWPU9k9Yp0q+T03iaoK7FqS1oukklf6GMSvOo7ekkAukHv8ttlbu88YSw4mpOQwmDwz2C3YeU/03x8PpRtrhIAwwZH/izXX8iF4vrnItQT2E019I+pfmpoGe+AJwdTi2xPhltIQJQbq/1YsuLERfOSd2aYSQP596Sota+HH4IyAMk1TwqoOGP2duXvVi15D+XWpmSfzUtqXqTuw46npGrzyBCgq+FnCSs+gQr7YeHVVOO2X4VE+2+yPcDDY5/hGvgjR5e/B9sFKzsqrZOsX9lwA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6134.namprd12.prod.outlook.com (2603:10b6:8:ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 9 Oct
 2026 20:27:15 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Fri, 9 Oct 2026
 20:27:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: avoid transient none PMDs during lazyfree
 reclaim
Date: Fri, 09 Oct 2026 16:27:10 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <55765FF3-18D7-424C-984D-81C316F323E1@nvidia.com>
In-Reply-To: <8db35dc0-eb06-42e4-90f9-534522e810e1@kernel.org>
References: <20261009165214.40212-2-kylebot@openai.com>
 <DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com>
 <8db35dc0-eb06-42e4-90f9-534522e810e1@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: PH8PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:510:2da::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: f719c99a-0920-4a26-79fc-08df2643b4c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|22082099003|11063799006|10067099003|4143699003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	7WiF1xVU3k+jRD0jGIjDS/mcVmC2fjW6xPOWb9Lfz0izwSAcJMJ+ohp3SK8oQT78M8T/5iTROukW3bKrcnS2TG6g8PgtJwLJWejwujLccPRe0qLxEWRJIyOZlEavHPQ4aAd7Jwt/qFPSK6BReBwBTZz+ZmLXlTs/7/I68boS2fN1ttZHQm5jAnbr2xDXYR0mo9m6cxabIRTArEtD17Rg3JjsZcDJjiW+vA0FpvdPOtKVn+JS27DdXbO+TOh+e7SkdEHmvsOkCn7374jxBazIypLaAxVa5ZPUyOACyNzU9xUaf3EWqwweRkwJ8TfQGJSWgYcdPsL/L10F71aREMJK6i7/69bXhobo34VpaJv6Vkr0AhIs9SmurXvzytK1sw/yqEaCfX6L51Sl2sgfiJ/EWAV54MeEIOLGJ3c0WGXU6+WvOE3BTT34yfU7dNF9Jtm7fTdBagImUCfyvTVSHOHuMcJ3GONoTLMpdTRk3fFnd8FvAJoOXNj0kQTRbwmoRQrYHlPqD7MPBPPGizfiPFMb+o4Hfw9gPBQ+PbIQBHekMl50bqfYlGlrO6FPvrua7IKJIDxXr0653JXziiv8WnNrp2xwiTSUyJyBzR5JUwc9DrfiRH0c3B5Ex3Bx98VBH21lYzTZ7kQPsQ3gRZVd6Vi7C9OZx0XlptOhcv09XZxn2Y4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(22082099003)(11063799006)(10067099003)(4143699003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b0AWZvdHaeROxpRC3EdrQR7knTTOxLjFMDDtbX7BBmZJLGwV9BHsdYhtY0zf?=
 =?us-ascii?Q?pSEuTyE6tJsH9bjjh7H6bgfan1dgDyyIrtQ5Dbq9/xnyiXNaE6p01/meizKQ?=
 =?us-ascii?Q?qczN41zkbGdiQaQ+IG0cbPc+3aGlfw4Jg9slIyd0/NkSJg4MU/wNyjTVxl/I?=
 =?us-ascii?Q?wMErm8x6eeerHUaKgPxVlpgLTdCEl29Qx5m96Pw7xpYd4kE8Bgwa3mTiCgf6?=
 =?us-ascii?Q?DNluC84XJk071RDz4Sg4716D5xQIrr1Y3RMHxWSwiuU06GcWsNHL7Ou3gAGA?=
 =?us-ascii?Q?HfDfQUMz+IsXgxrf4GzOWgMVZ/XoUU7hjm7gIci39hwX2ySNw8LlmwezgfAM?=
 =?us-ascii?Q?Wr0eduDi2g1jNTrlwiPSLr1B5uy0pK5gA2FKlfJ8x/cGhF3fvlbrLdy5PASy?=
 =?us-ascii?Q?93kQcUyxuVm+1kre/VC9+P46rSGSZg6ifnLoedM/U9WGOJCO1h8U1Qr6HgyY?=
 =?us-ascii?Q?Ubc9xzW9CC8Kucbc0llfFP2wST9QHPJ6FAW0NlY2qT7UfFuMTByLuC7jAxYL?=
 =?us-ascii?Q?Wiougwa3QfuiCuJ3SPQ8pAbfCkfR+bhqDnGCCBTFxZqvyzfzGfqCXWqjPvPf?=
 =?us-ascii?Q?KAp/zn68ORYgCL2bGqNd1jCvMSq/+N6wdfZhj6zurg2IqUcbVMjdsYhVZ0GE?=
 =?us-ascii?Q?X53k3Y+USAVqbvrMlRw5Xt3v5+njDTlb9x6OBjlQATKdl2b8Svgn8eTNq9rc?=
 =?us-ascii?Q?fqaibbtdaJ7Vei0Ts72t6wlMWZ0Tb5AFuGwAEJg+S1EeOdbaMsJRApb0jOnQ?=
 =?us-ascii?Q?gMxD59amIKLXVHoYomj7ThsF1EfFDbReZxpVRSBI5uWRnNqGqn0O7LMx1dmm?=
 =?us-ascii?Q?JyhzZvoK2zo4q9ioyxrtxb3p4dI5DYCWZPWtXwo0InHLsqg5Q07fCCStYT8D?=
 =?us-ascii?Q?IDrF3ujOe55MATVmr5QbZDHJsrjbOeLikU+7OzUKheuodXuE/4ZcUuiKhBy4?=
 =?us-ascii?Q?TB7ATJH9lOtR/Y+oQV+8peaCCz+gWGJFfkd31cUNisRRQfilqH7/553c4Wi5?=
 =?us-ascii?Q?CY0/lbizaDo8Ju5VR9ziKOV2aKe/dVNVqiwaEYRya1Oe3qboUGxdiELhinBI?=
 =?us-ascii?Q?S88QM3/+Nzy/mgpLxAn4AsTVcUzbfLfcmp0Pvlm/HorX+oGi3D+CPUiXIDnl?=
 =?us-ascii?Q?75egeCrXKrwj/BVcCmEMDoMgDqOuIrwS9Ebg/wxSWS0gtQ88g9+4apqdthW7?=
 =?us-ascii?Q?t0lw554DuXD/ChLGUTbgpwxgDUIcSHbzZCRmfb/U0QbOHiIxNXDyPp96m0A+?=
 =?us-ascii?Q?pOeOphI3YH6RM6uM2HQ1jXqmQMkg8FWT6Ebts14uDaWkH2hMINH0iZjAXvQ5?=
 =?us-ascii?Q?AAWrWsVgMg/uQeJ/iNiUYr8DroJtZvaJRNXr6mz0q6HEY7imidjlTuqxLzyH?=
 =?us-ascii?Q?vj/088Gtb9beLPGVnkGB5kKJAorrl+oyR6y2fVD2wtMHQc5Q+4JXv2zHh8o9?=
 =?us-ascii?Q?yC/zXPIi1UjPstfQiEk2FNIvF6jm3KOKq5cCYnfWyEuBvxdU9GADHGUYmq/e?=
 =?us-ascii?Q?hA3GsvXAkVkIhPWLWkfYkKUwJ+1/qsbLrhm3WjupALpldSWoFdVoo4ERW6ZK?=
 =?us-ascii?Q?A/CoogLcQEP+i48l3NfSoU+4HGdDS9S6pV5bsakVvs/+DEWelSoStnfoxJKE?=
 =?us-ascii?Q?B5rxmyWMkRAXCczEMN6t0GiGDJm/zTUnVSDK/Oi2USXVQdMuCkvTwqs3y30E?=
 =?us-ascii?Q?jGWp5y9LblwJYuakwRXVPGgnmdKBgqfcvojC5Ca/9NjPIjLN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f719c99a-0920-4a26-79fc-08df2643b4c8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 20:27:15.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PjdEzMoCaVZuYhJ8F569PS43OTMMwoJxkW7u4B6NOiBhecvy6f0Yld8Zlmd1uvGb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6134
X-Stat-Signature: ow5bzftdxh4k6tqe1mfwhui3h4hz6mkj
X-Rspamd-Queue-Id: B67A41C0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791577645-573231
X-HE-Meta: U2FsdGVkX1/8Nv7bGAhGqyy4naDlzPL6MglyWJz5tIVSSzrK/yKsBEx1tTfgSrl/VQ+Iv9LmtCjUrpjxR1yT5BaX86VIl7z0ZrWkW00jwdsyy+sLjRaUtuSWYiiHH3IXg8VTYrGXZKhsBCXjkK3jIoKhahDPE6J4l9X2ai8YMCPmh1cCiJRxi1EvBb2e8HxrxZ1ZHVHHm2G33HZPXNuLlu8HvsHRYf5oP2zziu8MYXPHhGoRhfN29LbnfROkJBpzwWa/KdoeARNMeM8qedjtC7fg64KSADE1Uy474IKQAOIya7U/caU/POzXsCLH4UFhr5vZytLesDiYc1XDU4jYWgrha01qJKEhwsiu5Dbf7iyh6zaQfV4ZpJold/pGbXR1PvMTWKbCr2FcZ/dcZWES7W6K1Ge8tsHz+9VWPZ3PPvun2IZ84btOadPvGLyw7QqVg5jWxeQD6NliQEnmp0RH70ypNO4eMxqQWZi+a97KdeV4Gv69fowASrMwBuyfem8NVwx6ayGqKp1tc94gOMrmb6uygj+edRgSSDuGcr0P5dNDJCqQoUgpBCMsltoyLgab0NF/ByGHGv6Tcn0QgmT3oXCpWFpxFOKKMwBMYiWcE62CY7veYw7vGVLuTic3DlQrpAkYGm70z1nurOXL01x9WvhPu9YH+N71hd7HEDXNwN90Cf9UUmoqcME7JHrRtfed45BRISFgJ/plgNo6Z4xoGlWqXQBICR/jiXq8Y8PSCIAlh/Ka/BL+e0TETv5yocmwBDrhMSIQOT7OQ/UCkcgKXq4nBoeqngQQZq/Z5H9vAGl6NuguPzVvO+HZtyXAehRqAWyKLIwP/EapWWM8pFfddi86Z/sIVfy0WNt+v4qdSHwQCLcKsBw4IMLKixoes8Qd3uwr20LCiulZ43yH4aRy6lV5SdLM89uJi6H90cCMwGvi3bYFmb+XBuhWoWpVXl+H2zIevscSoDVfhgAN+hh
 ZjwZxiBY
 bWxYEWsQ8GeGmBIDGCjiPnEqWaK5xtetyKWQIXhKCDHyYd7R30uN/HBKw9c0NpULtEwK00kaifTOQpqX3pHPQxuvx83Q99lk58T9NTEyqRqaAH5YqIp4euBoMgXP0G6b4rauY1dwtxqyWYT4H56bVN3V6W0z+jqA7jRApsDTSFzfZHXe9nfiKFC5nJ2fwjLTaVEAHcDg2Nky35ycxytlUSn1KcaMovrV+8dEOQRzUbTpa4MoX6ZxYK91wzyDbBkB5kqccepTntiserQcOkVA8m2JSjvVMQOMSuEj7+ifQ3GQjgkrY1Oq7uPYMkvfTaKoCtH8mTYmzyWcis6fx9GDUoujhVttWREAmWbrbMvDY1z8DX9q+zp2M0+MA2rHYflk1lxKHh0VWz9QEzk8qTvW3PYFSHPx/a3w94wUHgi12GSf0zAmdgT217IfopLRsWIJqmzbD0ovQEnKH09s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Oct 2026, at 16:23, David Hildenbrand (Arm) wrote:

> On 10/9/26 20:17, Zi Yan wrote:
>> On Fri Oct 9, 2026 at 12:52 PM EDT, Kyle Zeng wrote:
>>> __discard_anon_folio_pmd_locked() clears and flushes a huge PMD befor=
e
>>> checking whether the folio can be discarded. If the folio was redirti=
ed
>>> or has unexpected references, it restores the original PMD. Reclaim h=
olds
>>> the PMD lock and the anon_vma read lock, but not the owning mmap_lock=
=2E
>>>
>>> Both zap_pmd_range() and mremap's get_old_pmd() can skip a none PMD
>>> without taking its lock. A concurrent munmap() or whole-VMA
>>> MREMAP_DONTUNMAP can therefore miss the PMD and later unlink the sour=
ce
>>> VMA from its anon_vma, leaving a restored mapping behind. The anon_vm=
a
>>> write lock taken by unlink_anon_vmas() waits for reclaim to finish, b=
ut
>>> does not repeat the skipped page-table walk. Once the remaining VMA
>>> links are removed, the folio's positive mapcount no longer guarantees=
 a
>>> live anon_vma. Racing lazyfree reclaim against MREMAP_DONTUNMAP as an=

>>> unprivileged user reproduces a KASAN use-after-free in
>>> folio_lock_anon_vma_read().
>>>
>>> Use pmdp_invalidate() to keep a recognizable, non-none huge PMD while=

>>> the discard can still fail. Concurrent unmap and move operations then=

>>> have to synchronize on the PMD lock instead of skipping the mapping.
>>> Clear the invalidated PMD only after the dirty and reference checks h=
ave
>>> succeeded, before removing the rmap and withdrawing the deposited pag=
e
>>> table. The full invalidation retains the TLB flush required for the
>>> dirty and GUP-fast checks.
>>>
>>> Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shri=
nk_folio_list()")
>>> Cc: stable@vger.kernel.org
>>> Assisted-by: Codex:gpt-6-astra
>>> Signed-off-by: Kyle Zeng <kylebot@openai.com>
>>> ---
>>>  mm/huge_memory.c | 11 +++++++++--
>>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1e5d68acf62a..20262195385a 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3569,11 +3569,17 @@ static bool __discard_anon_folio_pmd_locked(s=
truct vm_area_struct *vma,
>>>  		return false;
>>>  	}
>>>
>>> -	orig_pmd =3D pmdp_huge_clear_flush(vma, addr, pmdp);
>>> +	/*
>>> +	 * The discard may fail, so keep the PMD non-none until we're
>>> +	 * committed to discarding it. Otherwise, concurrent munmap() or
>>> +	 * mremap() can skip the PMD without taking the PTL and later unlin=
k
>>> +	 * the VMA from its anon_vma despite a restored mapping.
>>> +	 */
>>> +	orig_pmd =3D pmdp_invalidate(vma, addr, pmdp);
>>
>> There are some gaps we need to close before getting this fix in:
>>
>> 1. GUP-fast cannot follow the invalidated PMD: riscv and LoongArch nee=
d
>> pmd_access_permitted() that requires _PAGE_PRESENT; s390's
>> pmdp_invalidate() needs a change.
>
> Ugh. We really need pmdp_invalidate() to have reasonable semantics. Thi=
s whole
> PMD locking is a mess :(
>
>>
>> 2. sparc64's thp_pte_count can be imbalanced with this change (based o=
n
>> Lance's offlist feedback).
>
> Ack.
>
>>
>> In addition, powerpc has a page table check issue similr to riscv, whe=
re riscv
>> fixed it with commit 9f4a88b8d01a6. This is not related to this issue
>> but discovered along with the investigation.
>
> Zi, do you have the capacity to take over this patch?

Yes, I can take over it. My plan is to send a series including
patches for 1 and this patch as is. powerpc fix can be a separate one.

Best Regards,
Yan, Zi

