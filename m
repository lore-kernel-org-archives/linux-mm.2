Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57735C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4586B00A4; Tue,  7 Jul 2026 12:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379936B00A5; Tue,  7 Jul 2026 12:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292406B00A6; Tue,  7 Jul 2026 12:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F387D6B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:14:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 788F51C8166
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:14:08 +0000 (UTC)
X-FDA: 84962477376.24.73CC946
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94F2A18000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:14:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EgO0QNTU;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783440845;
	b=EOAc8CY8lFCGtXSf+m6pjzd4yL2I6B9cMQ9Jrk4C2oOXrQVMUtfx0nUZCzUuFkSC2UcmUP
	T8af1FeeRnX0WAMHYjRqhy+TasHjkPbfBwy1K+LrIOJZBG9rOYm/DvmxRTfPUE8sJTn3Xl
	sv0MrhBKhSbu341vs8BtvDpcbt2ZZyo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EgO0QNTU;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783440845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJIMhVIQH0q6EGmxzUVFxvjS2de0BSkMd4bWQYpKqKw=;
	b=eV9qazmbPx4choaoQECNuyNUk6bLwGu7HiOf2xwN0Ij9gfJojotIXyco5G3gzwahLQKTgL
	DcjzGaDCZuw3Bq0zSVKdKpXtUMoi2x1A3nr2AJU9s1qqvOXcX8VoZ43kYnu/n0MlvVjDz6
	TxZ+uLLAaJGKE20lgPmXAQM2M9cRqhk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qiq/ZiXoNU+wy1UA2rVC8jqpQwRK+IVygvIRXmgl7XtIbGWZawnnmIpxMoawJfuooutP1tZgmR1+o3aJyV3qk4Pri7av/VPrKLU5Z2Rc78pIsoreRzqKjuA+8swK73TDgNVPt//nr0PH4f/WE7fW0CDg7mdiw/QR0yjsO5CMV4jJopr0Gxbw+gMifIJrNDOENQT3Bcs2DMhlPzBqC0rn5QYZixHkxRe86gf+pwuhzDdM2tHyABuR9dBnRLmoF+jRLRbsSy8OIUD45hpkybSy4GPe+CQv4YjZodN+l4x1jN21O7vtU0dPEPx7wm4WI6IN8w08P9HILhcdxoIYaLOGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJIMhVIQH0q6EGmxzUVFxvjS2de0BSkMd4bWQYpKqKw=;
 b=WA85cJk/qIRynZ8nPmjU5Uwy1NKU4GokYT6Ow6KOUDhAXzGuJKRzXWDR2Wu4NWFOlFJxfIIBiFy1piC/oAo3hFneHJA2Je0BpK/eiqhOsmgrRgxLHTUJYd/Ow+aTaVEn6HsrpIU/hhQhiea22eDOVE7ZsLSac8n7HX8MOwM6aKQVNjK2ypXf3a3sU1b2Y+VaJ1QUiUduN803AOTYpLrNJ+4OprfnDd+stze67eDQdR6ytm3/zlgiW6FcuheDaLCvqFR1yaodaOq5x5smaOBfytbH7q4KZJJqXVxutZg7FkVYuVJWR0hcc02lQahFEP2icWHn61is8zc+u3cvmO+w/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJIMhVIQH0q6EGmxzUVFxvjS2de0BSkMd4bWQYpKqKw=;
 b=EgO0QNTUvvroENxyuNHCuN7lsVqDv0dj3IDSlZPVaz185tDhUKtmXF0v229SWQYqX2nzt9RCSUW/rgfve5gCnV459Tu0onlEZogJZNefkHUcQezOME06+lscoJMhVVEyiczm9/sE0jBbexvW9E3EutlPJfYvcutyCYk9NziQHQVGrpGAmKc0uIY70oDpe0a53UrmDyjFV4/NBFujhjH1aFcrYYCr3KyszgwryPSCBY/U2CzwCh98fmS2Z0H9yzKp6n5gmNefPV6xvcQqxT/fUsrU1FF080g/ttDdrHPdpiNw2D7jOoYttpaDNvuQx/q94EgE3M4RoBxo3dVCiD88xw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5735.namprd12.prod.outlook.com (2603:10b6:510:1e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Tue, 7 Jul 2026
 16:13:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 16:13:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 3/4] tools/mm: add page_owner_filter userspace tool
Date: Tue, 07 Jul 2026 12:13:54 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <A2C60605-893A-4536-8404-60547143D6E1@nvidia.com>
In-Reply-To: <20260707115411.1714314-4-zhen.ni@easystack.cn>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-4-zhen.ni@easystack.cn>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0365.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5735:EE_
X-MS-Office365-Filtering-Correlation-Id: d9c8f228-91d4-4434-ed3e-08dedc42be3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|18002099003|22082099003|3023799007|56012099006|4143699003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	uQjTOnzoCyY7bsaos2dguCEsDr0ryQmXqfHPrnhn4dcvkgmzhjB8NENKqCse2iY5FdDPtIEXe/dSXMAbWYyKdF+1ieshtR65nUmAuSCULK4Lo9vRYW0sH44gPGJnuwI3Kp2I5e6am6CfxkIexUnmea4/KoV6QmfFVTEgRDC8UCOQP2Bbat/smExXLI7T2X0xIm0eZ4xh7yCST9uUZ4kkiugid+cbHJ4xbp/mH6G2hmxjruvkl/6kFztlA5uLrJxW/ZznjEF5FouOn9VbakJWR62VxxxmFiAI+1IU5m01WdK4heCu2Dmu8CbSZRZ7vyJJZVVufl1a9BTSPGdERF0g7wFXHtvBSPQqA8jGvABQBA5QOa/FZc/ZAz65/lEG/Um+YdRGEu6JAb9KOk1XtGr3qUjJuKYTVzPIg1mx+zErTxgGv8kRie2kzacSVF8G/5yUyIwRoDtywjH8wy0+JVvIuYoRdixxD3a5fP5iiyRzIZ9B0Uytyrrf9i/iPcAtHo+y0zFMEOh37sBsF3HMafuEHPI/uEh2l5EdddliSWBGgye735BLx+9gda1ju38qxdko36e6SzkReflAvO78ZXD9skX1N0dLOTihaR5aVHTkD0RedIT0X9QEvKOerbBXenaW6RTFI5s5thPcOpRE7e5uAqNbaQMJ3UFJpAyLKATdBcE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(3023799007)(56012099006)(4143699003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UNHppSLT70xDgEEPfnEcItAjUAO+uoocXa+1EHarT3s5+4ulRBplus69MOyd?=
 =?us-ascii?Q?WxiVLhcXUGd170vQQM/sD6jpX2WR7bVSiNAVYXDX2jne54kMb78zdHyR7oMI?=
 =?us-ascii?Q?DUf+AmsXUr7LiOETluuAnpxTZZ6GYZpa5300kFzgVaOxPk5YRuZHeNj9D0Lc?=
 =?us-ascii?Q?ksAft+vZnMuOl+OJQbd/TYkedrH8DBvi/fLJu3kvGOXqX6rXQc2PoFn4OgZ3?=
 =?us-ascii?Q?QHijZHrcoTGtTx5nsIbBuL/M4F79BZJnxjVzL6ZP/uDHEJ+ffiRxtDKKD0iJ?=
 =?us-ascii?Q?ijcSB4RAJvEoKVTbiGINW3koy8UVU/lR1mUNi7NQ3COvS+OzhFjZvRdCFpfr?=
 =?us-ascii?Q?jRY6cixBrgPRfEJpl++5DnvUDX7axMDEzbaQOOn2AFtSr9Ftqx37NX8xUZLk?=
 =?us-ascii?Q?7i+ygpP2Gn8YRrcn5voYRWtGrLdlsRlQQPvpees+vtgJ06sJDALN0GLaCEbX?=
 =?us-ascii?Q?7d74ywBVcr1/omMtFA16/oBcmu7klEkOqqqycurP2mu3eVKPRJIEmydxAKp1?=
 =?us-ascii?Q?9eX6bB1GcTk8ZDXIR2FEhDN8ARmJPUZPyozfc1UsrBA0XVnprphPGFtR1UD+?=
 =?us-ascii?Q?fLKKqa2B50ZWWwxNd2vWkoKa8eKQZmVd2EboHYdhMw5bDwdVno4Xub9t68oZ?=
 =?us-ascii?Q?crXLWKKTO9BeCBz9fcMxBpcMwMLjgxTpiSu5Fj5QK2LG/GU6alSeVyBsQbBv?=
 =?us-ascii?Q?chxJOy7IdoVG6eAJLHX9zxQI+Zm8/Hf7rBRRgqMCd4SEIFE16k/lsligNNjh?=
 =?us-ascii?Q?pbFRMCu6Y16Y9sySTpy4z57ymjLWjahdhxCSP3/yN7M9l3n/K35o/OkPWZVS?=
 =?us-ascii?Q?ENmyzk0212JDxuJhZQcMSyXFnj8ihT8+Bu4O823MeDLJpDtxA79NumNAQERL?=
 =?us-ascii?Q?TvpID/l4QDyNM4BQkDSv/NFRQjStu3MGF5YGrU+7q6aD+mnf4ztTkTFOJW/+?=
 =?us-ascii?Q?MM9IEGN21ru+Urq4sPLBaWOkrb8EOENFxYf7WinBDmcjLFTl/jG3bmJdNiHZ?=
 =?us-ascii?Q?qeAGdtqGuPr7TpUTi+Ep2AcxuG9cerORYPLpQiI0VutxjgEG39Ie+HAKc79H?=
 =?us-ascii?Q?9jjXJf5j3BaD9IHitRVyiTQm3dWaxH9vLOGJa8uNLxxVab2GZICUTlLfRuaj?=
 =?us-ascii?Q?DXWBH9EgIbMsGjI+IzLTYiEsBwefJgx2iGvWq04AmwL2sU9Y8pm//hvfc9dE?=
 =?us-ascii?Q?MwizwpXsGZ+stMCi249BYVoz1cKcCEKdmyjwkifR6JcuSqTrx1eNUsxGMtPr?=
 =?us-ascii?Q?z+qMbk/emI9qfaB/+pZqWX32GmYhDHnfEC2oEt4mGdbsE1s2uha7vyjUK2wu?=
 =?us-ascii?Q?rLqib/Nya+WaS2Qm0/6Eu+iRWzyMqIknHGPADTicXpOBIXynFUS8JJne1DGr?=
 =?us-ascii?Q?8V8uCB8wE96Ufp6eIYsUJ177ndZpIHhVxLrE/5ceDwQtVjG5wIY6CZ22Guir?=
 =?us-ascii?Q?reXfU3VI+O9dpDNZHdLqLXZs3YQ90OKcIFlEytiulOSa8dtYWf0XcEQ2Ke5h?=
 =?us-ascii?Q?FFOxDIw4/4IJVIQO2zUntZxS7n7c+QIDfAJT8n5Vlwnal+V4eRhYrkg83Rn3?=
 =?us-ascii?Q?LYtJNtBDad791WKyKY8ANy+puMAb7c0So7tu7yf9a0TVH7xLuAR0uGd8mq6s?=
 =?us-ascii?Q?9GMwdk9yO270Xk24+m016QWi+eD77lZxK7wxH1bKi/FG6PHWVUNFhOrxtNDl?=
 =?us-ascii?Q?xkphuc2vdvvSjDUwWVESBkopozhT82O0jvwO+LQID7IgI/w6e8BRgqrWCys/?=
 =?us-ascii?Q?tH8nIrlm1w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c8f228-91d4-4434-ed3e-08dedc42be3d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 16:13:55.2369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tiYnSxFOziQSQGFWcBTH45BRu7fkSymivtESoKIs3WTfWnzyitO9goGLwfYfDN21
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5735
X-Rspamd-Queue-Id: 94F2A18000C
X-Rspam-User: 
X-Stat-Signature: r88efxcyafi3ksbms7xnjj9ufnjhq3nt
X-Rspamd-Server: rspam03
X-HE-Tag: 1783440845-349077
X-HE-Meta: U2FsdGVkX1/Dd5cse9daglE9XnRF49cF4hV1mb1omQmF19Dwr8pj74RBCS5j6S8wiHo8ORLTc33O8hR6GJC6c6RoKWt0maZokJavEpxh+q3w2S0xAj6/1A7HGrv0t9VCeIRu7frCRWuYFDw0gp7OtNPF5pR6u/MLOLrl3jqTFg+88coABuWF7MCgIu/SBjEdqjCHi4kH06lMuXy9c6cSlzsGdKUUx6IS8vMAwQWou05wMxdsy3ZP0Buo4/OoJYo+BZ2h7Rvd8V3xrzusNxBjnt3Qek3zl0e10TV/OuuEumby+gX8JY4JWHv2BaFQMQ2dGsgMEtQQescXmQabiXW+4H5xuO3NLlZeMa9bWnzOs0rlFihKGWYo9d+JDsKX67QfHangnyFetGjy3tFK3F3hrJmdGeecHDBUZRJH3yhjV9sjjzw65uXac4JquRBI/EIJW0ZV6Op/VqiSdv0sDJLqgSDc1ZrX97yU9khWdmDW7v6g3wKUeGUCG6N6qVsn31l1kOK8BzTMJWOKkv54kABzoSQ1z70m75DFvriHCaX1QVFAedtcJbNaCvoxHVPCk2EguMSxqG+Ql5OC/RjLVClfJcwYRbowL9OScrCpQziBKFImXkXrXOfDELREO+FSQvefYbeDaBts67OGYDwDIDmkSj4Z94ko+kvwWjkb/5rx4IfG/gNuE9A/mhW9+3ye6T8bEow3733D8sBRaG20LL0PgMio+JFoXDnh6famjvTTsMIjAh/9qVi0MLDvVa4tNvZIBcwtNJ4oJstOd6R6NrG6FrugOyUYy1x0Wx09tAHog+0N3KKJ016Ua9gAAYuINuttlPzTxzeVmVZCScrOqvMDZfiybBwqm2s6SF51a7p7SxLFKECNzIljuq+m1VUQiNFfdET8/HB8REAO2VkbhMBOdNKZrQHCwdnYQU082o0+HEV/XAPPkH9v/INH5ePxxekw1FYZV5Gge6MqYnQx686
 +XHLc8oP
 7eLqledeYiCMXBZnhq6Ue1W90ArdWjnsQd549MuRZJCtUs3OTz1xrDEIcG5+z2gsXRBZ6mg8/zoK2KWNMsOZT+hMD3TG1qtw0fMddb3e9Vu9mUzKDwtilr4s9e4DIr1CUjKyttounCKQbDDc11aI5H/uiMtwZDa7Fg5WjuwbLCsYL0muGGwLl5T+t4iImLJhOsrbqbx1mWAHWnp9C7vEHCY/aGXYW9cUA2PieCnWDkCNcjcnIAB5v+vmB5Mi/s30D5oGnvbFi7+2PYwRo77Bwla8jh/joaeyOi48EbsjAR/pCrR++iI/Vy4jiFOuujneQvkfjh0lMZcTYYq4UD+f4teAQXzXoSguUF3CdnqOdTyMbb92LoiJmzUUh+DWY9iMKcjbdjQYnc1sVVjTbGfF62NRCjKuReJ0Cg1xFU8Kdch85O3X6TdpauIvcrG+avHIhGz8codh4sLj0M3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jul 2026, at 7:54, Zhen Ni wrote:

> Add a userspace filtering tool for page_owner that supports per-fd
> filtering with print_mode and NUMA node filters.
>
> Features:
> - Three print modes: stack (default), handle, stack_handle
> - NUMA node filtering with flexible formats (single: 0, multiple: 0,1,2=
,
>   range: 0-3, mixed: 0,2-3)
> - Per-file-descriptor filter state for independent filtering
>
> Usage examples:
>   # Filter by print mode
>   ./page_owner_filter -m handle
>   ./page_owner_filter -m stack_handle
>
>   # Filter by NUMA node
>   ./page_owner_filter -n 0
>   ./page_owner_filter -n 0-3
>
>   # Combined filters
>   ./page_owner_filter -m stack -n 0,1,2
>   ./page_owner_filter -m handle -n 0,2-3
>
> The tool validates inputs before sending commands to the kernel and
> provides clear error messages when the kernel does not support
> per-fd filtering.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> Tested-by: Zi Yan <ziy@nvidia.com>
> ---
> Changes in v12:
> - No changes
>
> Changes in v11:
> - Add signal(SIGPIPE, SIG_IGN) to ignore SIGPIPE and handle EPIPE grace=
fully
> - Treat EPIPE from fwrite() and fflush() as success (broken pipe case)
>
> Changes in v10:
> - Improve error handling: check fwrite() and fflush() return values
> - Handle EPIPE correctly: treat broken pipe as success
>
> Changes in v9:
> - Fix isdigit() usage: cast to unsigned char to avoid undefined behavio=
r with non-ASCII input
> - Optimize I/O performance: replace fprintf() + fflush() in loop with f=
write() + single fflush() after loop
>
> Changes in v8:
> - Add validation to reject multiple dashes in nid list (e.g., "1-2-3")
> - Fix snprintf return value handling to prevent command overflow
>
> Changes in v7:
> - New patch for userspace tool
>
> v11: https://lore.kernel.org/linux-mm/20260625043101.338794-4-zhen.ni@e=
asystack.cn/
> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-4-zhen.ni@=
easystack.cn/
> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-4-zhen.ni@e=
asystack.cn/
> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-4-zhen.ni@e=
asystack.cn/
> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-4-zhen.ni@e=
asystack.cn/
> ---
>  tools/mm/Makefile            |   4 +-
>  tools/mm/page_owner_filter.c | 310 +++++++++++++++++++++++++++++++++++=

>  2 files changed, 312 insertions(+), 2 deletions(-)
>  create mode 100644 tools/mm/page_owner_filter.c
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

