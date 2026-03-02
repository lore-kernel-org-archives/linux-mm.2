Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F9EEB3629
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4714E6B0088; Mon,  2 Mar 2026 12:49:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431F76B0089; Mon,  2 Mar 2026 12:49:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC5E6B008A; Mon,  2 Mar 2026 12:49:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 176466B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:49:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C01A91B7060
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:49:15 +0000 (UTC)
X-FDA: 84501859470.19.2A4BDE6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 75B13A0013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:49:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r3vXopdi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cHM+SQOh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=temperror (imf15.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGeq+Ng63FjDH87ZEMc17etGLp9sbSL3huSx76eZgMU=;
	b=QECkSFfC4yMjSzSs+SgvZb38pUQJpLl7hQaov9Tp7AcoiyIUlCmH4/+9oNmUpH64V/tRQs
	g33eeBpYphH9e0yDF720JvpHSyfT4CDEQWnvOvjCam9HfSQPppx/XYAilKNKm9G5rgmpIB
	r1A6AEhZ7HcwAKX9R1xNwisNKyhj3ws=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772473752; a=rsa-sha256;
	cv=pass;
	b=06nPxvVEJrDvIMb+VGwrAXdyJC/zi46pFpgJRitPDe3jqkZAT3PtFFbavkObY2HhhJjD4N
	IEsb1iYhqFbEA3nGNTps0tm6Qxu/gRlsELvihjc2F9N8ahlvc9KpiMXzfL0MYBMLnKLnmt
	UD1lwW3ae8SB4f4xtJRFoM4DYzHA92s=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r3vXopdi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cHM+SQOh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=temperror (imf15.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622HWBJH2606701;
	Mon, 2 Mar 2026 17:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AGeq+Ng63FjDH87ZEM
	c17etGLp9sbSL3huSx76eZgMU=; b=r3vXopdiv6L+OglhSqSm35cBYqZQgmYIJm
	NukPIhFWpFQGuh6z3c9s+xK0bxgK6tSTm7ksZN4Ia9PNXyn0HKh34zbPYKbvDzgT
	b0SkRABfYvhMlr/N8T6lpYOrY49bVi4rKD18V17l8e7uJXLEzThN8yv6PFnEFXC9
	yGLI5WgFGXWZK5MihQ3CFM8xH2G4JcMYAJVyqDvloS4/Mg6+/RXG31oIKZXqxZ4B
	XTwUqsd9Z7EgaL6h1J4yWPmQ/7kh1WBT7HyOgoKge4y2fFLexnFNQdOtHQzOe6+8
	2jc3xztGLOAhf9DcbnAYTiYoDeoYL/Wukh8mSwbNokWOBhEscueQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnf1m816f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:49:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622HeJi9037818;
	Mon, 2 Mar 2026 17:49:05 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013062.outbound.protection.outlook.com [40.93.196.62])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdhftr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:49:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=htLE21RuvmvH7/Yei/pIouS9pf5yL7vrKvSo4X2a7OzPTiYXHm/wUg6OV3EdwsqeXdgTgWnY/IHL8YOxHN1ATkdn2r3XWKdrpT6QFUnutbjRgpTQTbh1zIj88W0FDCmPYTlWeUXwaiuJ37hTTomd32c/tg0AL5sacN9skI7r7bBz6vkFkIU254KGR4u37DWg79ns2i72ndofT4QC863UZN+IizPP3x3lxbJouuEbevnTirPDnsJxHF75hFwZmWdrIBo0ew1HDaRfiOiQCcQ9MCZTPbKfyJYA3ME2qd8fkPc6hDrAXPi51WlcGz2JuLL2DzkPKMjHBADzjwaey64v8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGeq+Ng63FjDH87ZEMc17etGLp9sbSL3huSx76eZgMU=;
 b=T4Cs3ss9LuowsxKYW9/rUrBD7ecrGiZwP2wY1omYCbDwrdRD8JMruI34g+vVpxKS/3b/i7nKPAZJI3M0l9x/1uTq+1h1O2+euHxlOdH25VukBiJzbROG864U5iIs+3SbwgM8OZWG7m7BGcDd677NIwSbmof/Dz3YKPH0cOYOvvFku6rOJGoingPQXxRiN5RidBdSAUrXdELg1mktzsw2ze8gLIEznFVq6oegMbKzAHiqeUyyiURwGVO34XI8NeU8EQCDt/qzWzO50aHaLXQ1rImqHYPw9rnzzIPTcOaq/dYeFanhvxpSR+mUrWToKdd1LFheBlMlEX7P0bkZomrHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGeq+Ng63FjDH87ZEMc17etGLp9sbSL3huSx76eZgMU=;
 b=cHM+SQOhpmOZeulRJ7w5BdC5jbAvQZPh99jA9XBLA3AmOYZ5pz1tETv3B+vzPEaFZ5zXJ3UjTOvl8tS/cwLud+MbFDxze/NTXYoKtpW3Cghz5t2WVaueZB24uvczI3ODSgcWfcDe5RZ9+1VmNKodHQTQgVrn1PlnmO1yRr+2Ykw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5774.namprd10.prod.outlook.com (2603:10b6:303:18e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Mon, 2 Mar
 2026 17:49:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 17:49:03 +0000
Date: Mon, 2 Mar 2026 17:48:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Sasha Levin <sashal@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, gavinguo@igalia.com,
        hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ziy@nvidia.com
Subject: Re: [WIP] mm/vma: clear dst->anon_vma on anon_vma_clone() failure in
 dup_anon_vma()
Message-ID: <a709c736-fd76-4bc9-a1d2-e1351742b321@lucifer.local>
References: <9e273ce7-8471-495c-a344-d9bf61cb808c@lucifer.local>
 <20260302151547.2389070-1-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302151547.2389070-1-sashal@kernel.org>
X-ClientProxiedBy: AM6PR01CA0070.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::47) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: 204846bf-e7f0-4be1-e5f6-08de7883fdd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	XcTpm16Y7FEjjT2AzUrc/GnBU7FnQ3zsH+olj8u0a+8myIJTEL7W4eNdo1JpvSOsH9+ztp4Vn59EYAqDzCis10bjaNvjQdLji3ibW5Xlftv1HkV2mLvW28A6I3zjgpPb6qtJZMXpg1L6ZxG+7BYw6AERz9sU2saPgwifCCdwO51xEg8doNKLCEZxtGILyM1i50QRzbg692i1cwuvfN0hPYej3ceY3EMjjRlmAPt/IXgfIOUu6cdZI8cI1FeeMpo9ZbsXIH9I5YhTH8qMTx5RtHPjmYRokRnALWzR/0xqVJkVmqtc+sD7p1gENGQ+7d/Mr12Td1G5zBkWm1kkfiuJWvWlEHPAwwiCrsMug5n9TrjbIjsGLdVHjHfGSKCsgH1X8x5gOgfTnw6HahzjqgYhZjWAp7CTYvvRi2uxzV+jeWzYJeytqtZlYZuTYmqMJQl8GxRIKrXB0SpVY2ZCQipPdRXTxaMUL9G6YO7B0VWtkHSIBhQfcNy7fUAtk/i6OtQc7u9ZDk20IkW34DUBeX5NQNuclNTJM0gHP7OVYp/wigE/5PFU3wL5V+8iuYplxakyO58xDvK9djr1K7lapkDpJZZ2zs73HJEMK+vjkTgpZjQ4/fZ+sBUmHeq4OSy7bOpc8n/lEkLr8jWzYH5QINdC1UPBobvLUAuxbuBjf+v1Q54Uo/UZOmaVsMzTV23NP89lFgGIdXCfMk8JnVewxYtzZvSzagj1Cu2xmLRgVOKJNL4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7YEIf3snxtW59eAVhojr309ljZxlhXj2mpaIBknMTb3U8KVsw1dQxgQ1NdRz?=
 =?us-ascii?Q?gY/U31oqyeSokm1ScmonQfjPjLpJT0RJMdcbyog7zB5JCGEpaa9rLZI8jwiG?=
 =?us-ascii?Q?aiunRG1svMCfNkt7VcROo7DXsClPgkaMUueYLlxC1nMhsWsipI7MHO1oRTSQ?=
 =?us-ascii?Q?WSf8PzeZ2Xz5zto/MyDQIMhId72UpuxfyuLxaM7LXgJPj8fvAmIFXs6Sf0yG?=
 =?us-ascii?Q?oCc9f3MZZJkDEY4WA41i40wMycvIi/6NWG1ynCow9bWp/YqFtnopUXWRnJaq?=
 =?us-ascii?Q?ry27PmoQTjJIbPHBFouTSDWS5yJSFLkOGIBX/D0if1W8f6IC9SJ4pqSOjpDt?=
 =?us-ascii?Q?O1L6LzHt4qEt6/Bo8XzR9Oi0U7J/rXPH0oXglmAD76fhyHnXH08uqxJrD/Pf?=
 =?us-ascii?Q?mRA/hKhMTqXF+ONDAleps6Q1gABXGQsqftmLWTIHaIxuxNxxHFLnTsDJrKwR?=
 =?us-ascii?Q?2/BiZ3Jsg7hJFMdA8lBzKFXGICXo42yU0tcgfsh21/Y9u9+Xvyuy7I3y3oXC?=
 =?us-ascii?Q?GiUfnorHezKtLy46D+QZEWU/AH19nWXFyWHl327+edS6RqhDWkRx/ByYAE/C?=
 =?us-ascii?Q?9RKL3JXQy1oWEGMg5ouv6sVOecBee0G6pyslFd7WPqNZy8yAAJl+i9tSNgO2?=
 =?us-ascii?Q?pq9hZVbE6DBzLs4PJh2EkYBFTPwD2ZL4raIfsKYr8APnA9Kh+SXHnphWKI3M?=
 =?us-ascii?Q?zL0bsQmVWs7eVuqAXpsVeYEzYBrCjbCYPZ7MPDPxHgd4pL2aD/3Qr181Qw5l?=
 =?us-ascii?Q?Gv0OA1OPmP+zc9ePMxRYc2Nw1rC+TvtwLNO+sbDqtsqVOc5uQceNp6ez/b8i?=
 =?us-ascii?Q?QtebhkkcU3yMfmd7fQfKMwbZ1YlehWkUcPQ/OBwmdfdvqsHKzBsZKNHIOtRH?=
 =?us-ascii?Q?YI0/CE18umlrxH4EJaHBRyJxEw0PzT2JWsiJTf8Ymi7VM7ba6HqYEkWWgNdB?=
 =?us-ascii?Q?1ET7KM+1FHwdw5+6uzMqOjH5bq76472cF1sF31DTIDxxsogCZiHN3MwU9EcN?=
 =?us-ascii?Q?P2oHguaPuSG9cZX/ZvNThDnM9icVvR0C6cbtw6Dj6ljP+Q7hXTEg56LNSu1m?=
 =?us-ascii?Q?0PkYAVA86/95K4X3G7XKXsldaRYs/DuPxgPQVNYOeD4iTdLQDPvYliqzokqX?=
 =?us-ascii?Q?7lfORPWBvLO8NJKOd9xHAdigoeyVaxfazqBrMhZ3Qi3HTWbypAXMqIqtxRJc?=
 =?us-ascii?Q?dmb74N2kCsXDbZEPxet83QRJ3tJINt4ARcNdi6cpyWs/+FXgZCWRrR47ciGe?=
 =?us-ascii?Q?PdDqMyPvBm8dT7yI2g5GGD/XEgsUmL5ryL4AgKvHxoWRp+84T3BRGfcZR4uP?=
 =?us-ascii?Q?MLrNZ1Cp0t6WsePk//WIfewBFNOJJuolHTKYW/GyepkTJh8aAJbqeVJVNqKh?=
 =?us-ascii?Q?Hk09pAiZ/q9B+iubOs9+xl5nfXyJa6xG7QVGWnGTUHEzIKZGD0P66izCKD8A?=
 =?us-ascii?Q?YpQUrRcJsGiitKoWV1F11V5Mefr/nrYFP2iiOUf+4jNVCSH+KXw/0DbXrhs1?=
 =?us-ascii?Q?gn2KbREfbk9tBzbxF6JhTjBn+0mL/AENcTVXeO5K6A3WMk13e766OTYpNPBl?=
 =?us-ascii?Q?ne5x5zJhGqFthm7L3L9dmG0A60AwZPnCfPcMUeGN1+XDeV6XwXNf95+ouHYf?=
 =?us-ascii?Q?WT6Yq85WF61b4x/go3hXFvtkZHyKgJ4Ei8Dn3ACQYsLTZ0LU6UU6gpPT85in?=
 =?us-ascii?Q?ceAejU6d2WJxszQjbe7BtMzxLfF0GCdDTehdQWwoBIUtU9odkg2UwrOFR9BD?=
 =?us-ascii?Q?T0jb4zQMgFBiWMYlkgv76j5heV7wTeo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NpCelCyIWdkwvfO+Mq/W7mvNbbDLNCjyuxfRvzmYmlGdr673ObenkddU1++H3n0VxolJVCxSvuGVbGUaD+wxyEf7fXkYOyMYau2IlnIUT+Fi9YFUIyvJijX9VVvSMsacly1IBYesEJ/I3apl0oMSou9uWEvQw1uR3pBzlFLxcCEJPMfEVqlfcQmvgoLCH6hoO/ma/TkYgrCXn68dm6ToSN5T5pQJxSn+I8vjK4LAuFkGTY9aTEg85QQskP5dLa+yiZpzhypbdUkUX8RvVFF4er+dIEKbxfrOcC0WbJ6qwWtbiAUEF/UEn+L5ZTQYLcQfEqoGZvQrhXQFDWL6Uf+C+kpFHbEEdWwoHpQ5DMTgPhRvQ9uokVLr5HenTZrBVWY/S+BJgF6aR2h/liGUDqQKCJ61EsBmr4jqZnSF86mcwv/pDewypH9aKyYpnsZja0aeVMekAqL/Ssl2XAtx9PfmcGZ93vaXQqEg2u72FWdpji4jLSjxFGQ/a79f8TkSXfMB2/yQDHKp2tGOIh9hHfl/m+ofMqsCnoT7jFTNMLZFIN3VB1xCGMzHpDicUOnMlyWr43aX/8CMkUg/R9l2DJutk/bhnp38LeDJUIHE/H1GPO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204846bf-e7f0-4be1-e5f6-08de7883fdd8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:49:03.0335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5WzqsQUdoxDMpb/OHBn0LlGH73J2OceffUd+mT789uhEa9JFj5FPfDcKWoQlpmAi8VScoenyyO0rpESgvjsV8ZpRcJ9pJJObYawDw691nM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=727 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020143
X-Proofpoint-GUID: y-GmDnVU-BU802uaIcZAl1yncXo77cxW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MyBTYWx0ZWRfX4W565P2bzsUx
 QDQzFuVo20MyTnadE04kFAgZU9AZczNJyZ8uAczTK07XYG1n0NYPX8Ed3MPpJtqJXOGXR+ZCh/A
 FXB4ElwH+F4LzSIE4NvfC8H46Jwvg1yBZXdH96hi5PgGUR7B1echEPQYi1biwd5Ro4ikqDXGAAm
 JRm9O764z2Xj/hSNFzK1u6Zprbf37iwljEbO5jGypddFhU0m7L+hJnu5nmUdYh3tTy/jNQRzM4I
 XbjBmXn3d8BHyXKBjXB/oMroLojpJMd8mzGpO0dV/AHpmLou9wX3Dxeapuzy82JnJRvkup+nQgM
 8P3yPIvttP/m85TqY6QxAyJ1HVvH/VS51rze2ltyEBOR57w1elaCfe2hQW0A7JyOSmVUwBESS67
 gXbeWZ0eavJv2J3udpW/LsMXoXXBA81oWI23KJHNPY7WseyS1F7ohyISgd1DPha3pWsK9y36CHA
 JLUb3IV/jbxCwjRutRhYOB+HzeE1L6DiHlORh2tk=
X-Authority-Analysis: v=2.4 cv=KvxAGGWN c=1 sm=1 tr=0 ts=69a5cd92 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=SkCAU4ZMq3g__PVG6SgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13810
X-Proofpoint-ORIG-GUID: y-GmDnVU-BU802uaIcZAl1yncXo77cxW
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75B13A0013
X-Stat-Signature: d3gn868o73z6bfeuz7mr3t4aizo6ri8m
X-Rspam-User: 
X-HE-Tag: 1772473752-41039
X-HE-Meta: U2FsdGVkX1+6vG1Udz9K1KMCz4WxmzlStBw33IKnmxSabwZZ5+qhamZGhNjeSSDdhNMjYM4ArBlmkn6T1x802PcIAX62QsUhUTr1hPzKQzLrY3jfzDLX84uaBOX4zoOgpt5DdOHSueVC226r0U8tgEjTqeCN3JiKCdyP+PsC1KDs8Aa14elZMOcMAXry4deKsRO/cvi6MI4Q6JLUQ+dPWas654E/YCrNGe3ckrWfyt3cSvV1EtuP8FPcClh9TnTwjsgxS9C/GQCtE1qh6q+bocUP0YjBkQf+5Anq5xcc1D+DnxwTzVSOSJWI5rc4IFd9Ihx28S5ZeYp8JXVK3gb2W8zCl4BbbxaFLbRB5t9+Z2Z/r1rkwGuRSINoJElB8QONJlnXts3xG840kEtnja0i/um8EGTMyQuqQl+4Y/dZRl13ve4MAWIuCqIHqdFl6Ecmv/VUggeRMwyEjuZt3KCWSxpD1lny1DDT3eYVQxOy7Kl3NL1Elk2Ks9nEizwu4njBc/gube/DDhIRgdsEWxpLyu2gFihQFay1Qy/l/Uk96DVfngFICar/iu9OsF9NutxSJafhhsoxm1UpLUfwpSyaWDtCFgKWVtSfF/FTtZn5lpB3A3csprUhBUmxWdg6tyU6mghJve1aLsEqeQBfuLepYeKQGVWujl0KYMBSxxk4MurMlIn236BVc+ypOwK2No6ZDRieAnGMN9wLDDVOSecS+AjoPcJe5R0c6jiBzHY1d4rob8/7KopjqfaFlGmxO/FgByc6lyYi2KXvnfkUEaxF0lz6bU4ha/C8FlsmkO+poq9WeRS8U0qZGY4nIKHFq9fBBD9JTkZC5laKarS3aQ3I+2t5pCUjt0g0bPXtpvTMe6SCPSI1b4yNSbW1viuR1e/iMFvMmfH1nHyPXGUSPd3N5/PSChL8TVXDuKiPAUA7Cm+hzzvyvsVI3Ij6MZA46JS7KqhyWgGuIW/MKfAK3i9
 s76Dk3A0
 rafZLkNKGkZtlHdXwEtPa3WGeqcaEiukhvB6g216hXq1KHxdA8fYr+q5GDKmlpyXYlZAg0yLCXlBoykBc4RWiiDac8hi83KxEuHHTviBSRqmyu/85Ns6vWyFOLW0wjgUDZeoBgGd0IEztrziYRhBnmL0qRnj2BE+fyHO/zv6OULuPDIOE+F83TDUfwM6Pva3CX1IuXafbBobL+bVRztRN17fZfqfLpLE7YU1hu2+GpBsafRjRnQJoApIWM2ezAjyDxfrA2CGxTRX+oHT+39J1TgnTguqXvjY8DcrILbLNsF94XboLYptCPr58KhlPliLqYm9qWjPyy5trW014PiBJBY6rTMKGtMi9sYFa0DIKOREop8p1PHZnScCUBXNsM2ZPeNq7C2EXL6AQFScctMRTeM4NXJbnekQA3ePGsXGC8vRtrF2c+Xcx0sEwfMuZaNJbZWO8EqEnVjCeT2bsF7I8/NmV7677nUh2oMitnH6AcHZ1pBgX3ZwTI7pk3l9yMfkE6dWrUmEM4zFVxJZIYTsMfUwTK/fsp8WPj/hTq4L42p8YHG9De5BEd7SFUOjrSpC02El+JP8cBcJGP6+nx+YWhvi8FINp1Z59EPTNVeMKAX92/x4wtXOAa0WZwyJraAXFAba7Jth+b8PZL8+utdCI7CCdZNGs4/imC9VARIt/HYGK9bIZDgFzESA5wgM3ywQt1Hqx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:15:47AM -0500, Sasha Levin wrote:
> When dup_anon_vma() calls anon_vma_clone() and it fails with -ENOMEM,
> dst->anon_vma is left pointing at src->anon_vma without a corresponding
> num_active_vmas increment (which only happens on the success path).
>
> The internal cleanup_partial_anon_vmas() correctly frees partially-
> allocated AVCs but does not clear dst->anon_vma. Later, when the VMA is
> torn down during process exit, unlink_anon_vmas() sees a non-NULL
> vma->anon_vma and decrements num_active_vmas without a prior matching
> increment, causing an underflow. This eventually triggers:

Yikes!

>
>   WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x68e/0x900 mm/rmap.c:528
>
> First, fault injection in the mlock2 syscall path:
>
>   FAULT_INJECTION: forcing a failure.
>   name failslab, interval 1, probability 0, space 0, times 0
>   CPU: 3 PID: 4261 Comm: syz.6.96
>   Call Trace:
>    should_fail_ex.cold+0xd8/0x15d
>    should_failslab+0xd4/0x150
>    kmem_cache_alloc_noprof+0x60/0x630
>    anon_vma_clone+0x2ed/0xcf0
>    dup_anon_vma+0x1cb/0x320
>    vma_modify+0x16dd/0x2230
>    vma_modify_flags+0x1f9/0x350
>    mlock_fixup+0x225/0xe10
>    apply_vma_lock_flags+0x249/0x360
>    do_mlock+0x269/0x7f0
>    __x64_sys_mlock2+0xc0/0x100
>
> Followed by the WARNING on the same task during exit:
>
>   WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x68e/0x900
>   CPU: 3 PID: 4261 Comm: syz.6.96
>   Call Trace:
>    free_pgtables+0x312/0x950
>    exit_mmap+0x487/0xa80
>    __mmput+0x11b/0x540
>    exit_mm
>    do_exit+0x7b9/0x2c60
>
> Fix this by clearing dst->anon_vma on clone failure, restoring the VMA
> to its original unfaulted state. This ensures unlink_anon_vmas() will
> correctly bail out early at the !active_anon_vma check.
>
> Other callers of anon_vma_clone() are unaffected: VMA_OP_SPLIT/REMAP
> free the dst VMA on error, and VMA_OP_FORK explicitly sets anon_vma to
> NULL before cloning.
>
> Fixes: 542eda1a83294 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  mm/vma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa7..4cf6a2a05c10a 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -629,8 +629,10 @@ static int dup_anon_vma(struct vm_area_struct *dst,
>  		vma_assert_write_locked(dst);
>  		dst->anon_vma = src->anon_vma;
>  		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
> -		if (ret)
> +		if (ret) {
> +			dst->anon_vma = NULL;
>  			return ret;
> +		}

Hm, I think I'd rather we tackle this at the source to be honest.

I think it makes sense to do this in cleanup_partial_anon_vmas() since that's
handling the rest of the cleanup, and this is what the anon_vma_clone() error
path previously did.

Something like:

static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
{
	struct anon_vma_chain *avc, *next;

	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
		list_del(&avc->same_vma);
		anon_vma_chain_free(avc);
	}
+	vma->anon_vma = NULL;
}


>
>  		*dup = dst;
>  	}
> --
> 2.51.0
>

Thanks for looking at this, this definitely needs fixing, albeit luckily real
world OOM's like this are probably near-impossible to trigger due to be 'too
small to fail' allocations, however we do absolutely need to ensure these code
paths are correctly handled.

Thanks, Lorenzo

