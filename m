Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FA5D44C48
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 13:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD336B0092; Thu, 15 Jan 2026 08:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B326B0093; Thu, 15 Jan 2026 08:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26746B0095; Thu, 15 Jan 2026 08:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD7246B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:55:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 859D61B8FC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:55:42 +0000 (UTC)
X-FDA: 84334346124.04.3E97B6F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 038BDA0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:55:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qYroEA7y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=egyQZ1Qd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768485339; a=rsa-sha256;
	cv=pass;
	b=0E0PvXdLCFbP1TIAt6nDBtSmjOBhuI3G3RQCoy2d4AtDmpZBKgkI1ZAl2CVxhIRzBa/Ic5
	ApHVP6QQNM/2QyJ3LvbRlfY5flJ2QqQu1xcAj4yqwTc1vqlgRbKrfFk7HWO2lxVf8rpRCM
	QzfxK+Qoa8N/aDhTILrkIASex/ZgIqY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qYroEA7y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=egyQZ1Qd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768485339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYGcVHv6GBVven2JTlwGSp11PtDeofmrIGx0jxYggV4=;
	b=Aw4Ogi7+y7+ZHlwuQ9x+ZWjftz6MlOM6MmywSU7vGC3q/YojC3PsyeBX2yf/YydQVx4bTg
	2Cqy8IPuxRANaPaw8JfANw0jTwsjUquP5JdowPgmqNT/+7fOInllv+2n6eSVE/WBppe1P8
	B+yTlbKkDCW/YUYReCPQ8oelDxM1L/c=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60F9saSg1296007;
	Thu, 15 Jan 2026 13:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CYGcVHv6GBVven2JTl
	wGSp11PtDeofmrIGx0jxYggV4=; b=qYroEA7yuJeCcs17peG1ENL65iWxNmcBCw
	JrnBOyg/uWuKoMB5gIKcYotyWcUGSpg39KE6aqkfQMbCfOehd6z3tRBFGdxKpqn3
	oFL9NFMATATLYVOwLtcKXT9r+0BJCbQlkfjG6NTUIOLmw/sWFNuZLGtzicF9LzNV
	Ks8H+K7AgOa6CwmFx1DHAwWTGwoieSqBfyDuKsbYIMdPH6RvdjEuOZbiteMYXmHe
	10N/n/gcno95GdBEXuZEMnqu4kEo+9bxaJbbHGxiAl/jMEwrnAqBL4BCG+S1ay7X
	UfYM62U5uUZ1hwlni0RA1b7ntAjY27YomyW8PrNo/Y0gKeCd0A5Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc36sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 13:55:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FCReo7032190;
	Thu, 15 Jan 2026 13:55:12 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7f4p85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 13:55:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MiYQ26+CrDAdtXV/Qdf6aMZdU+r3HvTVMYaWOpcC8sjAA+U73WEq15xJ4EX2i4C1ToTUW6hRBWyytyqplfxjH7wYVqt549DA9t5n/YlEW78RybrznTfjPDi27bGfPJ/6XWYniA8w8BrrQZDSf+5sOTp7OuBsvYupuVwyUoL0xrLg6D6kQWD3jbDXikAnLBUZXSREQLZ1ntANQj3HBCjI1ebOjd95i0WKzIstLxLzzlFEm1bWvKmxjxqdSIZxNLggmD4BQUBN7PhCnop7OeNq7Wyi5J8YLW4TCAaumUf3eooVwylJaZkXAJOs+YL/RRZKFBDrpjr+lPI58NImnXocdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYGcVHv6GBVven2JTlwGSp11PtDeofmrIGx0jxYggV4=;
 b=GtEY/ezXF7n8FT2/0qZGicfyDSDoQT/VtC6XlUVqn9u3lDGsSy4XYplFe+xw9HQ+L5ZRmVzS6jJ0xITjEla/JJ8mmiC4VrYQntfHhoX9e9OCO+FsFj3yPOlGA1/aAv+legQChxrVyCRk9VBMFnNfYxfgPfNesJjHOZxLcbQwKmGoAZ1EEslCOlzGaYkvNZjrwIPkZe+NzMyt4tbSpgD4due49QDlNE5+Ji7VmxtZC46h5U1/No4cCLIkmGCN6nbTNdumJb9BjDGpzWnGSb+/1IjNVvEVjnsQopbzLD4SdQoxpyyH46kVvRYoG/s+qub404UBxb/sjWh7QGr3OrgQRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYGcVHv6GBVven2JTlwGSp11PtDeofmrIGx0jxYggV4=;
 b=egyQZ1Qdg/BQ3uwBzKICpgRHiBp3tImHcC1Ma1VXTBRl38OI57Le880j/FI9UXLMpioqlma/aSx+3XI98t6BpMTZOgrNKxuvDNLoYrEVEGUl071KvD9FLSjYZ2bCNIU/zN7uWK6HrnGbQtZRacAO2lnPTybBtZPNj5OvfBgIqqw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CH3PR10MB7561.namprd10.prod.outlook.com (2603:10b6:610:178::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 13:55:08 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 13:55:08 +0000
Date: Thu, 15 Jan 2026 13:55:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 22/23] mm: rename CONFIG_MEMORY_BALLOON ->
 CONFIG_BALLOON
Message-ID: <219f7be4-8355-4376-bf97-3410c6e23867@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-23-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-23-david@kernel.org>
X-ClientProxiedBy: LO4P123CA0271.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CH3PR10MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: 959dbdf4-0107-4909-db2c-08de543db1b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XANOPyZXfBHX61hGm7cYtT6rve81Q8hS1cW+BSADlDDtOmpLPHuyxrUA6SsA?=
 =?us-ascii?Q?5mVaNqGJies2ebijZ4S2VaXiRhLM4LScmTKYzDjvMDxpXRLeoOJaifQaIar+?=
 =?us-ascii?Q?7UrZlTjNrJ2bAZ+0GCI45VxvNi3q2XdeVSBZWHARJMLg3t2CGHNit1QERpeR?=
 =?us-ascii?Q?I3le3/EwAcLjWWuY93UoQ3xtXRvOgMJ0WQXzZd5tWjBNS0QHSuWepjWuWf4R?=
 =?us-ascii?Q?a1BAvtDwxE2u50YKtAPfQXw3auKUibEyRaRWCO71j602/xtILAT57uST3LY+?=
 =?us-ascii?Q?20vsz24xZg+q06ca15M/w4F04CqSXdFltaqNaI9TE2i5gxCC8cI2vN/NrvSH?=
 =?us-ascii?Q?AnQMI0T60L2Mes6bg7mLzc06hCDI/IKN6kdsG5pjqQ3POAToF4PmWXUdcoNX?=
 =?us-ascii?Q?zlX0N5ZzxcnYSIaxz+HT0fiW2TGsK18cjjvRmkOXODXsH7cf1uvM+txuZ+o0?=
 =?us-ascii?Q?1YoDFMaTN5Kf2Swd6PWfaka7JNQqylB4rqTinqWepEvDfoZtDUaOTOKjUZ+r?=
 =?us-ascii?Q?E7XSHtIAaQqXIAXnkxdWYNTEQ3+pNYVZ3O7TibhMJ08cednamdpkpJ2rZpOx?=
 =?us-ascii?Q?D7SeZrhAz6Q2Vu08jXnHAXwHrJhl5X5FnRuYV35QmrI5One9rTqK1qtUCVCi?=
 =?us-ascii?Q?/EnIwskYL89XghoU3GSjA84u3XZFl22qSHIYlaoZbQZM0WFYOEDFj4vuzofH?=
 =?us-ascii?Q?DVKFUJpbGAit3N/o+ITFSgi8G0KNeXP1h1umxhQdRihW8DQuLUVA9t3SmOfp?=
 =?us-ascii?Q?vWUZ212sMMIEMKbT/m5n1OXXWdBoZnQT6TUKvAUl3j0QXHZVJww7z9HaoLNJ?=
 =?us-ascii?Q?dQ94NCOC38knbmJzFTGhFK8nDc8jocN5H+lsmpRzkjqxNQDMlOodCRCmeJNx?=
 =?us-ascii?Q?4gP0FR64sYvlid3eL4MBGsxjL8WzPsIx+Ih1WuZumxsE0VyM0eVIcRweB8Xc?=
 =?us-ascii?Q?AfkyUusSMvN8y/mKqApACjDb+dtkpYADv2paaQ5ENGefTk+PYphFZRETGRhz?=
 =?us-ascii?Q?juMiH0NQ2tLZJx+8Eh8yRdxICB17/cXUEGM3O9SXhkyPdvSFQZ5kXFHbZMo4?=
 =?us-ascii?Q?piUyAqCN4+C2uHnikFcQlxeHoWjzGPWV/JXCrs/PDGDpocx0m+4uHBZWckCj?=
 =?us-ascii?Q?ExqF1cAZkUWmyCDFv3ESmOylXw+Ls4ed0Sna0376xmCgOMoujF0gHcfHm3rG?=
 =?us-ascii?Q?xt8LJroLa0f89LkjstaL2Z3cWrvW/DI/qHz0AWKhjOuY4TMnXTOKVZtPZ7Lg?=
 =?us-ascii?Q?2PgdGkmBH+PwwuoisBAkM20qKiBXbRqbGF/XuNqhgRfyrCH0NTRG7x1gpQGO?=
 =?us-ascii?Q?S3fdzL6Fb4OVQGdZuXmTHWErO38HPyjTw3oNdq72ZP1CkeLJj3Vjy4/IePTk?=
 =?us-ascii?Q?8rZi66skrWo62ahz2VAHBR6v/CsUvcG4j7PxYc376I1WwRZNAAoQrZcIvJpa?=
 =?us-ascii?Q?VBX+kHCyhOAHAS6xHe4RddhgnQ5vkV9fq24/c0R40z1l4RGbts9iMKNg1BhO?=
 =?us-ascii?Q?PRlsLB8sd9bgCXlxRetcysn9VI9KapsMOsrONgw6mEED4GK9Ls7MW5i6vvAb?=
 =?us-ascii?Q?gvvMtYBS4lAKXHzhs4M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SSDOcjFxreF4VzBNbFQs/Acd4QelUrOVVoQhArtehySVBvpkrRHqXdHFF4df?=
 =?us-ascii?Q?7h14DWrNq5QkiGHDBXrsVhYjDbyFjys1Ct/jGY/myNCAz69uQMiCuHbxsBaV?=
 =?us-ascii?Q?uohsYEjhnkVpMxHd7AjTWYtuZOopFJuZW56iQHFAn1N8/A0EgPMq9Yg10AXz?=
 =?us-ascii?Q?geba4qBtJUE+zltt2tPnjb0Lq90Zn5HvGYwvDARpQHriDIw17rINZpmgGiFx?=
 =?us-ascii?Q?eEbjYxArTb1V/bssG2nTtQNq3ZyV/PwXhvljt02zeWWLnz1y+c9X4XiVJ7AH?=
 =?us-ascii?Q?hiizUgHH2baML9ItYOIDAnmza6hlTKxSg8xbOtp3BwLyIMXK0qOcPIp87X/j?=
 =?us-ascii?Q?oW4M/yqEmVe9KnZw53SzETeyi09vfOb8lUdDgNdkDNVv8kkNs5s4HqCiyaVz?=
 =?us-ascii?Q?+V7s5UVnGU9lFRfoO3P0hU+vTLds3O9WFcMXbwtZH5cjDXjWDVr/rY9oCZAQ?=
 =?us-ascii?Q?VZfpOySKgI1D8vdpH2oUHGdKj6yu9mBjopJNjLSDR9yM0u0NngjfYIdzwSkk?=
 =?us-ascii?Q?RBZAIS9RRnQm9LaNkv8P9+vB2aY8sP7zpFQM6FJxQo3ryOdo5DLmT7MeAqEV?=
 =?us-ascii?Q?XYVyNXu9IDok9oMAESU/3N4MJOfDPdxQOYVxNH/bYLiS3AeDlFzcGFcR96si?=
 =?us-ascii?Q?F60jf0A46Z++89LLfy2oz6rdtJ2GF3Bd7x3dv4yWJuf75lTV++zikWaJEFYq?=
 =?us-ascii?Q?3tYMfYE8BJhKG0LeBhcLXdRx/4vFRmb0Hio5dYzOGJej2MHJszeGk1GYiPMA?=
 =?us-ascii?Q?ePWEc3YlfwIMMWMkxZYwBCd/wsTmPlkYENfZ54DfQXwGpDrjTZ6GSMqaccJR?=
 =?us-ascii?Q?jxOzhE6Ut1InWsg3Ihu2bbFk9bE54qJjBItQWAMkDl1vF+/ZbTAQP7gU6rYG?=
 =?us-ascii?Q?pA0jIOC1ZCfLTC6uwwUr0PLAXPTJ5FFxEevYnh+pyI4QM7FGoScXhZbruGrv?=
 =?us-ascii?Q?ekJTxJ6bzKnNL3cz0YhRvBDVYIpo2MW0x9PT6q35ylSMzDTig84YC1mSkIdz?=
 =?us-ascii?Q?CIcnO4f/h5S+h0w0vV3bWb8z6uow5vFx6dwzzRcKzZfi08VqlgEd074rFxoj?=
 =?us-ascii?Q?lqgJLBkHIIA/UqgXP5bZNim96Esa1Je+DxHSd+PzNZPjSjYKqfMYzuRFVN0W?=
 =?us-ascii?Q?qZHTEABddhHQ8wXiit7TAxKQoZP3heu3nG5348a5v9eaw6tT3Gwt6vGfN7SQ?=
 =?us-ascii?Q?TisQ2Yw96zcupVmqzgtBnZ+yKw+Zm2BY8LHZftnYfDu5nRbktrSz1W+50y28?=
 =?us-ascii?Q?xM9FrkrlYYSsWRk+W5eAFMguYPSjCbPwmvK5F+MJjUkt2GhHqr8hQWGVn2E9?=
 =?us-ascii?Q?JrN5HvBNFI4vRJ7P9DGEAUSEb+h7snf74a+8ggLYQTdYbtnGD85tEYhPueHX?=
 =?us-ascii?Q?xAIOvRwC2xeGdNCGpWxZoJXcOEjSRVzk+fmdiUxkqxBe3ysr25R8a/naQqGW?=
 =?us-ascii?Q?CyQzXV7WVkyCGwVsCA1h+MrR/ZtSehzWA+pm1puQmdQNxHn53G4Za0G6ppfL?=
 =?us-ascii?Q?yJQmJVJG4zBld/Z4RK8nmpToHGfAoKivhtuAfk0LcbKXr9mC88vPpCY2FL7X?=
 =?us-ascii?Q?7kX9T5VAPKQDAmRA/AuwtPOPuDuM1QYcdrH2GUUoLl6j0dg9d0tpVrPddf8N?=
 =?us-ascii?Q?JCBJ4MKOrvb5G1CJSqAZmb7zrA0S2tDyioOC7T7RTI41z2YgGFOTdFJM/iXX?=
 =?us-ascii?Q?/OIWUjX03MBfcMMJwrAU08HuDWeu4smNfZO9YVtH/lo8swFf8PuDOaGFH51e?=
 =?us-ascii?Q?4uLxbyMSV2G4uC/T1nhC4IdsIw8tO7g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5JxhwI/8RM3bJolRzVEI9ELWRaf+bEIRqYw+HVFC1Bhtyaz/2OMjQIVMeSfpq1yVfIxQOCtVv1F9EDYkN+4oaovO/qYX1ymFMfQhWlD7JYwHf1MXvnRh/jbO/XRgd0pulj5POs1HOJxTknciKv0ivDhR7dCJZe2Wzmi7MVkryu2dR5V2dLbnljGUxHjabAkSoOBAyxAZXSK4Tlc5rLI2gJ/3r+iXRLg34ycvqrb4W41/mXZ4XX1qJz1O5clD48PVQBtQ2CLxC9lI5iss4/ROc/I5OWWFc1ljzmTyseLG+jMkqIuTCRR1JSp0JWSlWBWQ/XZmujsVSlwRTyhlRe2zc+imAQxj3PErO7RL3BxW7ClyON+I/FkoHGy+t7qU6byRvv5xDkaEu5/0GyI7GfZSEL3HbMsPEg19knKSRcVrn3jiAOu7wCY8NWT0thtAyiETR2EcQzDUT9ML6lxwRu7+p9FfULa43utKGgo5qAnJoQFGgA9ytPUygJdnOSB9FQHkQx939udOwAJPvr754I/UsePpD6lb//oSJ7yVxXjI4FyAvX7bfHSgFs+NDZMBjaGAs9RrVRs3+5ZQ358y+IcQv701pJZTw/Ju6AQHE88h1rY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959dbdf4-0107-4909-db2c-08de543db1b7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 13:55:08.5697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lu+d9KZNnTU4NPCZOCxPX9RYhmzb59MudBKKCmyrxKZ+We18bsx3XNU1o8achI5WHulT3lEJqDHIIE93Ab49mWikCPuVJRONFKrByWbZ57c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_04,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150103
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=6968f1c2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=sBEWCj9P95Ywb8woPbgA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13654
X-Proofpoint-GUID: Zv6ltIHmY8kTKqvF3-i8rkonMxwC7vzn
X-Proofpoint-ORIG-GUID: Zv6ltIHmY8kTKqvF3-i8rkonMxwC7vzn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDEwMiBTYWx0ZWRfX+5HPCz54WKZL
 9SWKANZhf2XpKTXo8F6v+nGm7AcAOdI4WamdOCfYDZiI6hjMvR3cQS5kBAYX558CUkTZggOj88N
 NMFgrmwrCsCxbQPJsDeR/qOD8OK0bYXg6YCbW+tb1uoOQn6QCzJVKrMcGZBvZ7OLzgBp+K5gZDt
 rYFW6KEU2zREe8WswZmhUSoqo2ZRx9fPldJrXYOqS275LcdnDFh98aQ6fLrzWNIrsOHU13qHmqg
 odxiqJivQb2ylg6fztaN884GckvC82FS3jkBqvaI71BGTPmSfWJq+IUDXoRquGj+STyQwU1urrS
 OF32NngHQXl5h+aXouSbNtKRpZ31vuoko0izdBiqnbrYiONqVJxBLFIKqcD0uC/8TEyQx0ksb4F
 NqM6wwMCGQKQeImiBq9N+8SS/iZTv9ue61Mm2yR0jIbRNdKxcTGbseZzAc/1y8f83XLjlCBZ9P2
 FYXdV572aaYDnIEINvHs4GCLOgBvY/pjySoOJLP0=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 038BDA0008
X-Stat-Signature: tp8qdg7wt8jy6xgeixeckduquufacfn9
X-Rspam-User: 
X-HE-Tag: 1768485338-707847
X-HE-Meta: U2FsdGVkX1/NDBS6SHrTEx4UJ/34O9y8LdKJjs7eWVHdsxxPTDVkVfp862fVEMSGRdUs17gUKp0A6SnRQcechV4bp2i4j60T86xG2wPXK/iiPBQhG+JQe+MsiHO5yqI79o63NmkMYLRZMc6MrXkiDgdSC6pTTurZLNTHRPOvRNiNprZHxjAD7jNQSE7O754YteZbQFlZLt1rYGj5Z3odglX17Z08s8RVlRnIqgeQ+X+BswLbzmH4A43iEaxnvLM1jcNA+TunIjq3wF8l6s5HF+9Cc0acMUB3Dvk3FzGxAOhuaYgxc0FRG4NJW0lWFYZKHQK+Z+YbnjlyqP2AH7SGGxD6VJ/oj51YcOLYtMNBt3PCnPjza/WEQjcHjTbHENju0rOw4RC82GRkPa0TH2701VFfY+XtCsRiBX+swg64frUWkFMZoBvP8fvq9w5CsYDuCwdmhZycWbvEGCJ+2Htq1yVAFI0o5x0kRwdClYpuM62oZKasrCtsTgNLuM/6saWbJQ4+glxDbwNgt8nc1wxfYM09mQeO1Tu5mxxQzpKRiEOi/OSCFeVMomVA3qkPsyNT2spRPxyOhWnfcodbn0tyDSj5q5eVLAaSC/OuSG64ELl3nd69eMpRPE8ndzRmMH8Al1koPvg7qcNXsCfBztJx/ysCY5vOIy2+2jPGt2O/sD8DFPdynUaQQOHVaHgykZAozzOjRs/T6OKq1mEGegx9Ki8pIzAFbYfHbnpK7vgkPS+We2adfjvwmzSZuBTO7jVt1XT6zQigvM1JHpsfE05fMTKTgDYO4HiH+7cXLcv4I4rCdg1ogDt19BRLbp1S7SQylwLdrApDMYqpPJwjh9R6YsrJQa7XzOrSmXRRsvvOdbnvqlBEl0baD1Sk3TQLWrD1hniHY3MSQeM/fc2R72Mo9ufvwoBTI0yEtwV+Fk9OLJS5NcXQWRhEOv3yAJpMwI/z6iAWmKvehFAoyuSpclr
 eCgzT2yl
 4H+F3LjUxwZdKGULosvJn2CtIbKbjHDBcoENUOXm66qvWsz0hgz+BrsMcuHjeARnWA8gb/jinruedOTIe3Rcsc70W0y1sIp+NIMDVWQm8VKdBbGyv3qBl8hIB28OXjK6akb+QJO9xVITnbjFs30WZYm9SWnc/Os5MaXr/XjvxUUi3pS0TouNRluiYBb230yIxKj7x/6XNHpCXA9y1WPVxBLQXj9givGYCFFSShBqi1CkcWYlWQ9wdrWqRlBbwhg/OzQnKYA2gGUpCTM0IunK7tVsGTuqjfeiloP/odjkUwmL3iImJcPVoiS+bEP7+yyabkNu093BQkE6KFpVMPbSbRng3tX6SLQ9LAI4QkxWV6N455st0fNHp3DCHPFeWB5OUJ6IjW8uUMT8aS57FVdoQdRtXKqHGt/c94zjCshiUfB0sUuwXymvMJfJGUx7UkTR2EyvD/rzYTA45BBzUSU6gETkkIqufyryiAJi+wHAyzso5g5Hd4EESeyqFEod/vPTDKg3iyPdgyEoZ47KfcEgms83pPFd1UFCu08GBsioNhPzTuYnX8fCtmr486OstH6mdxvtgh3zAERIskq/1kFyxKINIV48s7O95Bw88t0PnQnzmtijpM1Ccm8EB1JJ7MsSzjHCwmDq45AGXR8VHPdZEKJ1cbKcAmka7d2IRiqK97doroCDFAmZwv01NApRIs5V5DeaagGvfnAiZ2Dsrv8pvmvAW8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:20:12AM +0100, David Hildenbrand (Red Hat) wrote:
> Let's make it consistent with the naming of the files but also with the
> naming of CONFIG_BALLOON_MIGRATION.
>
> While at it, add a "/* CONFIG_BALLOON */".

Probably not relevant but cheap for me to share :) so grepped for
'memory_balloon' and saw:

include/uapi/linux/virtio_ids.h
44:#define VIRTIO_ID_MEMORY_BALLOON	13 /* virtio memory balloon */

This maybe relevant (I guess this isn't actually used anywhere?) though
interesting there is also VIRTIO_ID_BALLOON... hmm :)

The below doesn't look relevant at all.

drivers/virt/vboxguest/vmmdev.h
326:#define VMMDEV_MEMORY_BALLOON_CHUNK_SIZE             (1048576)
327:#define VMMDEV_MEMORY_BALLOON_CHUNK_PAGES            (1048576 / 4096)
355:	u64 phys_page[VMMDEV_MEMORY_BALLOON_CHUNK_PAGES];

drivers/virt/vboxguest/vboxguest_core.c
278:	pages = kmalloc_array(VMMDEV_MEMORY_BALLOON_CHUNK_PAGES,
286:	req->pages = VMMDEV_MEMORY_BALLOON_CHUNK_PAGES;
288:	for (i = 0; i < VMMDEV_MEMORY_BALLOON_CHUNK_PAGES; i++) {
333:	req->pages = VMMDEV_MEMORY_BALLOON_CHUNK_PAGES;
335:	for (i = 0; i < VMMDEV_MEMORY_BALLOON_CHUNK_PAGES; i++)
344:	for (i = 0; i < VMMDEV_MEMORY_BALLOON_CHUNK_PAGES; i++)

>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Otherwise LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  arch/powerpc/platforms/pseries/Kconfig | 2 +-
>  drivers/misc/Kconfig                   | 2 +-
>  drivers/virtio/Kconfig                 | 2 +-
>  include/linux/vm_event_item.h          | 4 ++--
>  mm/Kconfig                             | 4 ++--
>  mm/Makefile                            | 2 +-
>  mm/vmstat.c                            | 4 ++--
>  7 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
> index 3e042218d6cd8..f7052b131a4c5 100644
> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -120,7 +120,7 @@ config PPC_SMLPAR
>  config CMM
>  	tristate "Collaborative memory management"
>  	depends on PPC_SMLPAR
> -	select MEMORY_BALLOON
> +	select BALLOON
>  	default y
>  	help
>  	  Select this option, if you want to enable the kernel interface
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index d7d41b054b982..5cc79d1517af5 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -410,7 +410,7 @@ config DS1682
>  config VMWARE_BALLOON
>  	tristate "VMware Balloon Driver"
>  	depends on VMWARE_VMCI && X86 && HYPERVISOR_GUEST
> -	select MEMORY_BALLOON
> +	select BALLOON
>  	help
>  	  This is VMware physical memory management driver which acts
>  	  like a "balloon" that can be inflated to reclaim physical pages
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 6db5235a7693d..ce5bc0d9ea287 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -112,7 +112,7 @@ config VIRTIO_PMEM
>  config VIRTIO_BALLOON
>  	tristate "Virtio balloon driver"
>  	depends on VIRTIO
> -	select MEMORY_BALLOON
> +	select BALLOON
>  	select PAGE_REPORTING
>  	help
>  	 This driver supports increasing and decreasing the amount
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index fca34d3473b6b..22a139f82d75f 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -122,13 +122,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		THP_SWPOUT,
>  		THP_SWPOUT_FALLBACK,
>  #endif
> -#ifdef CONFIG_MEMORY_BALLOON
> +#ifdef CONFIG_BALLOON
>  		BALLOON_INFLATE,
>  		BALLOON_DEFLATE,
>  #ifdef CONFIG_BALLOON_MIGRATION
>  		BALLOON_MIGRATE,
>  #endif /* CONFIG_BALLOON_MIGRATION */
> -#endif
> +#endif /* CONFIG_BALLOON */
>  #ifdef CONFIG_DEBUG_TLBFLUSH
>  		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
>  		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 460a148d5b71a..8e23af521605e 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -593,7 +593,7 @@ config SPLIT_PMD_PTLOCKS
>
>  #
>  # support for memory balloon
> -config MEMORY_BALLOON
> +config BALLOON
>  	bool
>
>  #
> @@ -601,7 +601,7 @@ config MEMORY_BALLOON
>  config BALLOON_MIGRATION
>  	bool "Allow for balloon memory migration"
>  	default y
> -	depends on MIGRATION && MEMORY_BALLOON
> +	depends on MIGRATION && BALLOON
>  	help
>  	  Allow for migration of pages inflated in a memory balloon such that
>  	  they can be allocated from memory areas only available for movable
> diff --git a/mm/Makefile b/mm/Makefile
> index 1e31e0a528dc1..0d85b10dbdde4 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -122,7 +122,7 @@ obj-$(CONFIG_CMA)	+= cma.o
>  obj-$(CONFIG_NUMA) += numa.o
>  obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
>  obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
> -obj-$(CONFIG_MEMORY_BALLOON) += balloon.o
> +obj-$(CONFIG_BALLOON) += balloon.o
>  obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
>  obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
>  obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index e96a344ab5974..0f64c898f79f8 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1419,13 +1419,13 @@ const char * const vmstat_text[] = {
>  	[I(THP_SWPOUT)]				= "thp_swpout",
>  	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
>  #endif
> -#ifdef CONFIG_MEMORY_BALLOON
> +#ifdef CONFIG_BALLOON
>  	[I(BALLOON_INFLATE)]			= "balloon_inflate",
>  	[I(BALLOON_DEFLATE)]			= "balloon_deflate",
>  #ifdef CONFIG_BALLOON_MIGRATION
>  	[I(BALLOON_MIGRATE)]			= "balloon_migrate",
>  #endif /* CONFIG_BALLOON_MIGRATION */
> -#endif /* CONFIG_MEMORY_BALLOON */
> +#endif /* CONFIG_BALLOON */
>  #ifdef CONFIG_DEBUG_TLBFLUSH
>  	[I(NR_TLB_REMOTE_FLUSH)]		= "nr_tlb_remote_flush",
>  	[I(NR_TLB_REMOTE_FLUSH_RECEIVED)]	= "nr_tlb_remote_flush_received",
> --
> 2.52.0
>

