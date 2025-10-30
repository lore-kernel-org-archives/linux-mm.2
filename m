Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F4DCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 10:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97B28E0123; Thu, 30 Oct 2025 06:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F428E007D; Thu, 30 Oct 2025 06:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DEF8E0123; Thu, 30 Oct 2025 06:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C02648E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:56:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74570C0A18
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:56:39 +0000 (UTC)
X-FDA: 84054477318.02.BB4DC29
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1446414000A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:56:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O6mwhRO4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BzWTYYlJ;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761821796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJf12GRVxXOS9i7MfZ2XSuY5XAJn/wUMPCzJPK2LF3g=;
	b=h/s/X0Q8lwWu4ov9fceRB2pB9XqJutLZdU6zZlIysYQOMBz5TFgNzvq2SCWPJsu7ynE4zR
	IFrztbD6YIEfc9799bdhfgdVE1rj72bzU8Ehj5SeKz0dQmsyQ+Nj+ipBcTdyjjRxyK/gHH
	nemva9t2cfhCwM6O8OIMOn2zHuvClC8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O6mwhRO4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BzWTYYlJ;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761821796; a=rsa-sha256;
	cv=pass;
	b=DtTtD2G2S1s1oHsXkqlPK4IDrTTGAMQ5OKmbk1pz/+GpD+qoo4PU/YdScAQeMTyyHDXLff
	+T+I4ca+DvwVBeMWMc9DRUM24PCTJPlznWYbr86AKjQOqV8SbqW7rDM6r/WMeHbFvn+r8c
	ef/9kwkBsASCyXdqlodIK0qgnVcDNcs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U9iMxP009104;
	Thu, 30 Oct 2025 10:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UJf12GRVxXOS9i7MfZ
	2XSuY5XAJn/wUMPCzJPK2LF3g=; b=O6mwhRO4zrzexMod6ia8OeF0RA+Txwr/Mk
	+P45QRbRVG+lwJ/mj7kaceXNNtRY7jLQc+cawoe26iutMrPnPMAd1ICA7eua7V2N
	w2EVLt5sst+omdKSz9up9yMPZ1Yg2SQoe5DKytvCMUUfKhda4uFsV9TheSNsvqw3
	F+jGqVxQojSCowNWw5YLS6ml6LNenOGOYLbqxtOOEKIIj4o5tmSZ0Dnwb46Y7Hpv
	GC+pK94bDtPZMXgXCc4U/XuAyPP9otsHLnd2PTUO9HF/6M8Nggem7Z+NDQToFy83
	pNWOjzZA/y9Vgi8r5fGc+21jXjJmQx48AdOfOgk3aKMc4c1V9v7g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a45nar4eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:56:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U8nrHv011262;
	Thu, 30 Oct 2025 10:56:31 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012069.outbound.protection.outlook.com [52.101.48.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33vyfkrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:56:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hMEOeoxgsqUwH/q3F+9zWTbYI7H3DWzbWW5aXbAYzEItwQrsFYtIMDL9rLngMgqQyDSNp617x6t4tSTX2LCbYcYWo99+npfRUF805sNOTeorr+w0kuBiS7LPx7eeU9QH0OzUoIEVWptg95EZV3wZE40Ic/wSmUtRHPHPduYiojSTzaQR91xaWp7bmW9mUmn8AmvV5Z6yMQkvOxCskVHzOW/efjQTU0+rmnStYYyWshu8MOMIwg1or4OrUkHA9he0j7EHGFO63Qe1Dd9OCHDBlDih3Kv1jyzpW0SXY6o4afFXBawm/lWekSvyzPqNKi0+uFsN8RLJ3lm0CJcQhlOriw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJf12GRVxXOS9i7MfZ2XSuY5XAJn/wUMPCzJPK2LF3g=;
 b=J555Xogr03yoGSIAEs+rqMGs92bcHa5rRawjqSxuyJLgHvmAnB87N7+XZbawMLa8JSiEE1uXEIDpsAes+kpT/EiZjGfgHcbltnLKXLG+XI63RPowXXUtz/FhUU8NfPARSHz86Xq9tImd40siDddP2qV8ytB0RgBXyHmlmd438IGhtPGeMfygmIs7nsGPgT4C8unBZUga8ZFO/b376jwd/iGZLzopd6S5Ilu9qpzox/c6wWkND7ELZaX5PlIoWkkJsmGaC+azLIh0fvloaaQk5EsmL7h4BV11WXfZorPt1EG4bUGLTQwsBp3rTwJ6YC6ZNb1VUN+Ih5jtZmikIFGMag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJf12GRVxXOS9i7MfZ2XSuY5XAJn/wUMPCzJPK2LF3g=;
 b=BzWTYYlJ2LNkI7Q+PkrgseDyFLKtapogEClGd8YFCVnU2S35TwOs1wxKCR/lYQZaAGguLiIf+GOG0Me0S9K3O0hzB6qFWsCHPmqcHB0LVQkFjsza7yWhfBVtBrHhuSqqaerslpR0xWvCF8FpAwHO1JKKm1lMUd/EYKA1MSUpgbs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6329.namprd10.prod.outlook.com (2603:10b6:806:273::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Thu, 30 Oct
 2025 10:56:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 10:56:28 +0000
Date: Thu, 30 Oct 2025 10:56:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Israel Batista <linux@israelbatista.dev.br>
Cc: david@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        osandov@osandov.com, linux-debuggers@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: change type of parameter for memory_notify
Message-ID: <004bb148-a818-43d2-af04-2f2ed85cbd67@lucifer.local>
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-4-linux@israelbatista.dev.br>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029195617.2210700-4-linux@israelbatista.dev.br>
X-ClientProxiedBy: LO4P123CA0698.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 433b700d-1cdd-4df6-6a31-08de17a2fa60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yhHOFDp+bFr/VjuTFilJodK1zl+0CS1pFVMuh6GlJgNt8g8Ppg3Rui/LR/BW?=
 =?us-ascii?Q?BunOsHxqFI0fofHTxqNs8wz/q2XBgFvjPszOyRPlWhFH5wSP3uNwUliM6qI7?=
 =?us-ascii?Q?QQoUzvTaQFDyuNCzHIajLSXdrp554Li+qapD9B5HGgEQ7YMxZI4Ptlwim8Ss?=
 =?us-ascii?Q?n4smHISAjY76XPZz6YtuGWYPRzoniZnzqWGWYuncmSKFl8QXcFThdtrKsJHd?=
 =?us-ascii?Q?kSJSbbBJk/AlnPXzRMm9NMwp4bBUnPzItZSjP/ol5wGz2U0LISVtYixpT5t/?=
 =?us-ascii?Q?fZedXRHIOE1I1Ikolz365WC7qUqUdmfkkynUg6jeeDVzA+bY0rTtiHfDPdsf?=
 =?us-ascii?Q?FnfTf+SDm9ZOysSjyhYkwfCvT+uFW3VFq9aCIpJM1MyST65M4ZtZMr45PY7P?=
 =?us-ascii?Q?uLAMXN4Se75l/3/F+WUJZ1377yGHXTVchtJnMoaol2tzU/GeXRjf0aD5JFBx?=
 =?us-ascii?Q?PIfZ3/57FYCPF2LvmUSDpdDIJPuSg5cWZRyJMcV2rcDokMqE/SxKW9erjtd4?=
 =?us-ascii?Q?e6NjJbDV7w0d3fsfdp2n7Sj69JJBler+Vso0uQWJTYcxtG/X+mMFoP9HzCWX?=
 =?us-ascii?Q?xU4DCLl+u6TPozVWLQpe5affgzReUwk/VFjupXYY8aWJpM+6KN9gnsoxI4+S?=
 =?us-ascii?Q?f+s47XtZPYUEI09iu4K9W6eUm9kHnlbxoN7AcHEK7BrNq7gujeXwY5Zi8Awk?=
 =?us-ascii?Q?MroRoLzFhBOYiwpnuA7DTLhHatFi/LtRmk+IPKejoV1Hanp4S98UWVsKVodh?=
 =?us-ascii?Q?43ovmh6m/S9ziafnW8J0kiMZlyguiRpzbJuOJzboGGeC+7mmGN8fmWSz1gW7?=
 =?us-ascii?Q?7M11/M9k7FrBlxsNkvXJ0OiuQJDi0r1OvvUu3zto213PqChd3czK5PDQJ5co?=
 =?us-ascii?Q?Yau125RyvDHSxHAwhEH+Tdo9Wdr1SwFBCS2zXtsgGJwoERu6A57Vzuw+MQPP?=
 =?us-ascii?Q?8c156k5fzr3aiRiK9Ro20BeDFXeUtZX0y4oyHocYavJ3pdxPEer7VcQPKPkE?=
 =?us-ascii?Q?V2S4azlivm32vZcTIXo5XFY0cXLugPxj8SaKjohm0+UDp3GglZGgUBvWfb34?=
 =?us-ascii?Q?1XyyuOlGA68jShMmtQXC8LzRTLOGXMtK143ercPDS5GDVrrtpiY4tc48W9fy?=
 =?us-ascii?Q?d55bK3R9gTKzALYW7Wm2wQDIENDtheRfGKthK78sv+9d6uAiZwknXmWsr07c?=
 =?us-ascii?Q?F78K+k0dW4/MoYZoENT3rjdPQBca7Nh+USzN8ncyfpIeWlRil/fjr0RhfThe?=
 =?us-ascii?Q?PktC1Y95XrffwYMpSrnsDYAabmcnYj6JufDCQx8Ty41BEdCR0v5Z1IGoPkTb?=
 =?us-ascii?Q?UASxTE/S6O9ZU30zpFvD0ahOCp1zP0PQwY5YDUXLeUC3HmkDq3V5IcLZcrQG?=
 =?us-ascii?Q?j5JAOxpRK8DfuSDPgbbkZHGI8aauc9W837Bg75FOZ5Ogk5mmEtxkIWb4gR/d?=
 =?us-ascii?Q?77dAlseCNeAbZo7mrFvuoJbBn60S93iD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ruQX7YL5hCSI2J4tgfZuZZAcLPHKUV5sN7ce/vm+7ZZNlzbmYtqPPi0Gce8y?=
 =?us-ascii?Q?6AxNuf4aer94YdUvldzKnnr1naF9JsAAPxXza2g0Z6kRRU3TJGMDpIG9NFPA?=
 =?us-ascii?Q?urKlin7lGu1MbtCZa3y9fVAV3/Tcy+THIOPvbUYHQ49/WYSh77w5Et0zcp4t?=
 =?us-ascii?Q?/IUdwCcWoAFGTW2vtC9UqgVrS5Ym+BP2nwmdXj1FsGDjrTc+vlSqlYPKhTPi?=
 =?us-ascii?Q?X6jA0eS4/0Q73tQt0fUZ3GWYWdfFr1AB8p2QjKVmlHexYPyZGaV0nKqRZ83M?=
 =?us-ascii?Q?n2US+ccG7gRmD1Dv18EhGlr0qfxNhxWIlZlZlm8wYE+P4HTU2ffWeuK4TQI+?=
 =?us-ascii?Q?tk31wxyhF/hCLPR8v2N/9Kgiy/+uhP1OiL29w40KjV0F+6WpKAQJyUO2M7j+?=
 =?us-ascii?Q?dqfpeQO4qaSUOCWG9BnpH78xkFsGMvPGIN863XaTtkbRWlO1B5zt7c++Pq5N?=
 =?us-ascii?Q?LDgVg3aBVs9wrrx8Vj5iEHxPV52CsEPGTWmO2MtfPmT6ydnWjcL0cVsO1tzx?=
 =?us-ascii?Q?UkytnOzKwchym57z5ga6ua1huvO6Sr6uCA4xfpbnmu3ql9yaNOl4D9+zRTrr?=
 =?us-ascii?Q?rR7dw6rxoG0lQk2d69lBfMN76UDMtZFi8WJB4J+dbxY4eY+Vx22hY5Sd1GoF?=
 =?us-ascii?Q?WOjTDfr5YVgiCt5kEdV5wTdiQXqxjn+E07cyhfBSU6mJy47e5fUB0JPINObs?=
 =?us-ascii?Q?gXlod+06EPdoBwnI1Mdt1yQBJdhz8xoLLVlwrLX4dlHVcf+NlmzSljfJGw/2?=
 =?us-ascii?Q?qeJAJLV3uacDDbnYS5FqUHhVdxiwgGnrgAmgB0jaxpnSLXvlUicrqsdpqmRU?=
 =?us-ascii?Q?+EPI9h1kO/uRr2nc5O/sqWDLxhKocIh9VFjgeJ7diC50JVWkmkZ33K4CpMK/?=
 =?us-ascii?Q?6xpmFxwaYOv1GuXy2k8yKBBsYMJ8VSjRQWWscloDzuf9RcudvbXgEwy/I9vv?=
 =?us-ascii?Q?IeOdDGCdDTZwbYFlrfoy6rr8FJPfoj4HjWDhIBcduWu9xG4g5+wr0M39B6SD?=
 =?us-ascii?Q?qjWqgdY0dMLQkPUyoQucJIMtv8ncN98inxPkhyZxiTxNdPOlI4tbMwUuSo1u?=
 =?us-ascii?Q?Nvp6mRYkfWPPGNN8a9E/Gxd5OEk3nykWX2QVQG6q01uKo9bJ616CSa25hCB7?=
 =?us-ascii?Q?aJZNUt/oYI9ih/DdEAwy2gKyTs2YLJ1DdWOS0iMP+174mXgm7MwsImAWzGR2?=
 =?us-ascii?Q?018Hll4BORzkQNhWHak6NaKfFmrfb99Ma5wPtevVdsjh7IEGQ00Ks2AFsUXA?=
 =?us-ascii?Q?F59zmDuNDWPFHGCQan/vEU2rsYbDJm4fx8BDWBgfpohsZ9JUQKTB5IXcsJfK?=
 =?us-ascii?Q?RwSWQLJqTit3Lt0Vb8mA31F0O8x0KOm49g4jz1d4cVCY8SWg9eMsyKlFisKO?=
 =?us-ascii?Q?ylZxqi1CJ0FuAd1BnPWo1E6cSCWHOxNoSHFqFYxj/3m4hhhwA9sIyzTuGF9R?=
 =?us-ascii?Q?ylyXN/tTA4OCPYhLIciRThu4trMfZ31pIWhbcgN/L4ZF22h/9k9gCkmltoor?=
 =?us-ascii?Q?CHeiBZpsnnyl6LdO/DLwKLpspkf9lsywwoEAyqKJg8F7l2O5wViQm7K1gvXY?=
 =?us-ascii?Q?tvSE1Dwz+dqqhC5UY7xAhNAHqdb8gU4gQ114dZ/DDaHh+5ARhVFdQSfujORQ?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AhnNYghp8fG0ezbu4Lto8noPcgq2r1yvydrjv9TF/NDCWNUwM3z8Vx5Yn0sOG7BM/ag1eQZU2q5CB1PiOidBcc8/z/74wg/omTYR4Fg3Jj912brZR4aPu68NnKSNFk/lg1z2UrqQHaydFfFRM+oaWbpTxBwE+wLuKylpvhkUU56fi4hLWXo2kTSxZibMV5YG52Ln7aub+FdhB5yJ+MfgwccpXe4uy2zxS14MJliZUwTVKfaaLSAF6gWryweXtbG5G8f/bOgVdGfYJs5JNvFzoGpGetT5ysQBnqWlkCQclcURtVxD5AZI2sCdtwdOmGxcPRc9FuSaooP3YPY79xmO0Ix33qxZYp2JJc892ceQXDbZa8AyRuuDOzZyq7/OpE4n98MabX72OyXs6wWbCXcidUhyw8fwWRZwTGaRUtncVxCn/gIm4sQ01YZxRPm7MpoRvrIqWBE31MTeCJYZNt6CaHLv3nyjLEgqWrL10foe1K30BfaVMH9l87g+izty1Dg+ypNOX2SvAhZqqrVDijTcTHn4xYDnW0IhmJXmACb9HA7wjSvCnV7uA7oN9j5bEXZraZ1ZAOb93enMEHD9nMY2l3jiOkycjRSygG89D7bZtXc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 433b700d-1cdd-4df6-6a31-08de17a2fa60
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 10:56:28.6643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YwlAHf+z3iscnKYH3/BshXk7bOf5AR0eEAcL8ziXUWGSGtXCotXRuqtJ4C7ZHFvRc+wPvf2SZ67tbF+hkYI2vb65WsdFv4Qva9Zf8vkv74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6329
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_03,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300089
X-Authority-Analysis: v=2.4 cv=buJBxUai c=1 sm=1 tr=0 ts=69034460 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=e-yu0iXp4107sXkw1KwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDA3OSBTYWx0ZWRfX5x8/JNrEPz67
 w/XfBwUnvH0zkrQds79hfehocYpjbeOS5Yi6xXiuctLRGpXHWGApEbUWlJrmGlIaUSrk3Y6mC1t
 vPWdb1H3Wdh9cNL77LnYTdAw/EwEjhUON5RaB0foezMrVG/HhOW1c+h23RmxBqKtIGQJeDTtcFr
 TtXWv6zc/1IWaKUhWAGrwDcc7MWQVwM728zxHrFX5H35IGxxGzpXYHK81piX9nOj4iUt4uQDjKw
 BFcro9xBSX8JSlCdDCuPS07U5tbBArC1Xl1mCj5YAjkzpbRg0VfEjcwjsWFdZ/YbZRQS0d3Bs2w
 FWVhViJEpzk20b8o2JsqC47Yxje38Rrp2S2A0Zpyp6LGRKRD+FqXMfh9+Eu6FD3KM0yMdKxOLMy
 bCHHpeDvoeN/Q249XfICRej5l7+NOg==
X-Proofpoint-GUID: C4kbytny_TFH27NwRrAtEQWMGDDYpKiG
X-Proofpoint-ORIG-GUID: C4kbytny_TFH27NwRrAtEQWMGDDYpKiG
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1446414000A
X-Stat-Signature: fq5juxzeqxgkq6zt895cqeen6mg35qpb
X-Rspam-User: 
X-HE-Tag: 1761821795-811285
X-HE-Meta: U2FsdGVkX1+9XWURBtaZEuVmsk6v4O4QinRsZr/siaHLsTXL6SaK1a9Zi6YwqOBCl2L/sEphCwJXNKX520Ygw4UYJGESKym2hf+0l64SvSnjrDRzQLcKsKKuydkh1KJXrsU6jiYNagi3c5pi9xGlgPukxp5bAFS2YBR90DLwos9zs8YnszhkokqY7I1eXaqreX1QsygwTrrRzNTFuwxEgpBFu2OH9JiOhZFA9t8jbXUSUEO2gIlhA5PWCCOUz99ltQhWhGq+g35Z/ZQRs9is5WZZ2P2Lch52UXTbl5YrzTzvWRRIaT1emG1BSS+YI7BY2IoZsCSknbfxn2HiHk8q3KRacYyBriu2YzYu7cxdDpiBI1p3Re5rIHZ7Up0W6AdlskAJBSvDlg8cI/Ml2/uyntFJt42UOohgAaRlCs60y/UB2vZPW86BHoO4G9VTKoVuerXlgsOb1yv4fvyT6PqPvjiQ27U5ccyQNjqghIqCRSTntNRHlxADDPSq+t7hvxz7XbbvVP5xof5vsic61imkNjSfRK1Eu+Dq5rgdkfct1qgBoXv6RLMBrxDm+DPGUT34mTXlr8gKHn/4EimL1LPUTqo0WDF+31qtLnXBB/AjLKH3qM/vZwv+vlOkyrPQXB2QqMoAsgp5pMdLLFBRN8V8BAGS0HytTqzFyRdmegO9o8ZGiq3DF0EkLluXnRKR2xmNMp/1SaqVNB85ezNDJoPsZwndyEuXkNFOSDWUeh454nkKPe9amRe8qrzxz3IXgR67qfnDUVMlTUhpbFm80615m5REFfFBbpNbcwdNMhaopUugxtTDmdDpdD4IYgv1EHwJBAnYFCiEOnTmh9Z3P5TmdToNGnB432idOn+8RxWPvgM2O17AwyNeUaBM535m1PGsiWh2m+gwgMrMdQU2WQwsaEG1KZIDW0rXhQN8vwTvLLqjJydE1Yn+XYNjQ5Ov08F3lRy6h/LVa8eJ0GUS3b5
 I8qGiEdy
 OFTbH2/BtYEtc92Rpjk8I5A56xiJBlMt5cQqvcnsJ/3yYroQVC8zGI2Fn1+qVqXG3EJ6Po35CHpbl1pEMr5eCIVBFLA88iCtDQF8d42jv0G4wavfo0NX6cbCWEtMyCNhYHbIDIXoyjPmtgaPBgSAlokd994a5MjJAVZDyyfBc7Wd6baFurtYGbrnmcr4kTTwpOm1nweVgtWA0R6VOiLyu1jc7mqAVm3vlpT0eEwBwoi/QGlvSaR5ISek7I8XV7vedrejOD66AXeZ1GhZqLGwFhzp6at7ClpbwhxDhsxUOR5oAZkeD04Gpala9LBvWUAu7qc4LcaTPYJUv0jE/z6zDhr+bxujF3BcKrIteIQAyh0X7l/9+qnI2V+Zh8k1EI8/h7os5eFlvBdqXfsn/5nay13kikPMAQ/CKrho9TLPPXwXQgxGJL9RRC6CecHbLkee7Jy28hTt/AYFp81dRVpsTePrFNlY0gFatpaJQ2KfJ+p72IUto09+C2+e14nkTrj+8U6kgSdFQviE6T88y9M+6KWsxewvlmNADnzWm4ET+G1CvVkIN8HdfD5W3Tt4PFMYCy2E33hniVYAJ2uhKPlbq3bCdLmo4IB4zuOm/aSqLWcS+PYOGDbYVf0RxOy0kTvZVS+tkTZIZgu9yit+SosLGxuMW4MVwa6u9ID53v8wQFtxm5VtRLiIGBbQngaEWg6+itdao
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 07:56:32PM +0000, Israel Batista wrote:
> The memory_notify function is responsible for sending events related to
> memory hotplugging to a notification queue. Since all the events must
> match one of the values from the enum memory_block_state, it is
> appropriate to change the function parameter type to make this
> condition explicit at compile time.
>
> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>

This seems fine, but I can see a whole bunch of others like:

kcore_callback()
mm_compute_batch_notifier()
page_ext_callback()
reserve_mem_notiifer()
etc.

So I think worth chasing all of these down?

Some of the switches which don't cover all cases will need to be adjusted to
insert a no-op default:

> ---
>  drivers/base/memory.c  | 4 ++--
>  include/linux/memory.h | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 3d17dd774947..c03f3b5e5e6f 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -204,9 +204,9 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
>
> -int memory_notify(unsigned long val, void *v)
> +int memory_notify(enum memory_block_state state, void *v)
>  {
> -	return blocking_notifier_call_chain(&memory_chain, val, v);
> +	return blocking_notifier_call_chain(&memory_chain, state, v);
>  }
>
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 36d733283329..6a2456686bf4 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -141,7 +141,7 @@ static inline int register_memory_notifier(struct notifier_block *nb)
>  static inline void unregister_memory_notifier(struct notifier_block *nb)
>  {
>  }
> -static inline int memory_notify(unsigned long val, void *v)
> +static inline int memory_notify(enum memory_block_state state, void *v)
>  {
>  	return 0;
>  }
> @@ -165,7 +165,7 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
>  				struct memory_group *group);
>  void remove_memory_block_devices(unsigned long start, unsigned long size);
>  extern void memory_dev_init(void);
> -extern int memory_notify(unsigned long val, void *v);
> +extern int memory_notify(enum memory_block_state state, void *v);

No reason you'd know, but we have a pattern of removing extraneous extern's like
this when we otherwise change a line.

>  extern struct memory_block *find_memory_block(unsigned long section_nr);
>  typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
>  extern int walk_memory_blocks(unsigned long start, unsigned long size,
> --
> 2.51.0
>

