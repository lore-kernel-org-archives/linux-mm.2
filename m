Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA044C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 23:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EB76B0095; Mon, 21 Sep 2026 19:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704F06B00A4; Mon, 21 Sep 2026 19:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3DC6B00A5; Mon, 21 Sep 2026 19:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0BD6B0095
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:58:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5E6EA031A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:58:47 +0000 (UTC)
X-FDA: 85239437094.28.3E44380
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010006.outbound.protection.outlook.com [52.101.46.6])
	by imf17.hostedemail.com (Postfix) with ESMTP id E489740003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:58:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=diYyJ46e;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790035125;
	b=58/MkgmUitbQ1fOAIb/QiOBBTGjng2Mc/fRv0MXGGdQi0tm6ac6qV/qQZzJbNWP+HdxVgk
	jIDQh7WPAntaHaeda0Si2AQUR2pEBYfYtvUCKduxChYR6tOxSPCpJXCDjouo2LcMFXJXq4
	vqA9aikTv26o1QwizHgyWOnGiShVpTI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=diYyJ46e;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790035125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=962Mt2h7QOcLQNVaR1nqT71k5Ww6URNqOqugZkBl6SQ=;
	b=XKypLf8BZFWfntHt42zX9whXpJcG57R/kmjHh+ZCrtGnoajACU+7GlCJcYk3GXjf0KMGA2
	QM1oYm0s/gE0QfsDyNv3ceRG6PG7KIPw1mB5yBgTNDhH7YSn4QM5Y8wFfsrj9jgHobmbxJ
	vV7fE7tQj00FJ/W8ch61nST7df3XeSE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaWAWvixwO0Ly4G7nvPrPTja/aYf4Uq/HIsx8Y5flRSh7SOXKPJ/ruYgbf2GQkn1MNhwzGfl3m9Ihv3hcDzxkgl+fBmwjV/4GLVt/98WdWnm3SoM0zH34MSLHUkmne+1M6l1rY8r6shLgCbiyAdA/zncgegGJhuwLsFhEmgvguf47DQHW+UGv9QsqRSo1Si59N/d40/f21+Z2q/cA4M+j7cZKLQ+qiqKRgENXl0wLqFvZxGm19mVmGuGn18KoMih3aZd1Hpq+Wg0NZKvW9l5bfrhZ1KqdBnIt5P5wUCYRETSeY315c3pe3b5e0rPhiPpGfcVVnW7lp3cUhB0uBKQIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=962Mt2h7QOcLQNVaR1nqT71k5Ww6URNqOqugZkBl6SQ=;
 b=tlXJf4XFfkEjGLt9dYmE5PnnHUv5EjLXCjwIY4WV0YCuyKHeh6emkFR2TjWSJoZurXM7sqdYh26SCjBxPq0lWg5SbFFEE+0bHyW4Hg9rWTTGXkpfuItB6CtLOCZ9O7gRp+mvrmDieD7EW9dhozhas11vTB78ql2Mwh2JzqbichmoHucJkZrVQOtJxLYQOrCC9nMiL4p54BZJRQbIoZFy7ugkFDC5FknfqBKVh7yp9SaooiUH1bXMB75H0+K7TMCW/KrqwJ7S24qk0Ck8H8dnfiRLZF21LnwQ7jSc6DBqBmqRT3fq7u4bzte7qM+kxDeGz5hUxFaZKC9SjcQYd8N1Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=962Mt2h7QOcLQNVaR1nqT71k5Ww6URNqOqugZkBl6SQ=;
 b=diYyJ46ekIiNeA1bulj4nZgLclI4tn5OMUrPWgjrVTQvtDhrfp07Qu4IV2z0It/U84OUisNm3PK6LON8ARuhlqitsah/dSeQYgz+w4yDtdGr9fgB5J6S76C/2R77RxkgAaN+/S/VzljUSGhQJsHvhUVTqkQ3e57fsHmRe6Fu5dc/mpWNHANSO8zKA9BxLvoYipPgpsBgIWHtE78xvl9Fs46hg+8Yx2AxhfVK+mXUr5vM77xi/1C92QxoTWmyzsiVYiCIvWDP5pw8tExLWcrIOvACZ1veG1+/DIfmO5s9RcXcDtsVEpJki+Pvg9bdusB5a4HrfeydOqO59vVRzIpYKw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF816B88375.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Mon, 21 Sep
 2026 23:58:39 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:58:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Date: Mon, 21 Sep 2026 19:58:38 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <72A76ED6-51F5-4A0B-B34F-C8F5416F640C@nvidia.com>
In-Reply-To: <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
 <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
 <C7A2977A-CDD8-4EEF-9448-A130411878B6@nvidia.com>
 <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:208:236::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF816B88375:EE_
X-MS-Office365-Filtering-Correlation-Id: 6051b857-a040-4b8e-e403-08df183c41e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|4143699003|56012099006|11063799006|5023799004|22082099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Bsru9Hhq6gwB6gzsG+1o0XC57MFQO3EqTw1k9CAyH0v1akcxcUimXPUrHpLmNhOrnPOsdk1g6UukjuedgSrvrG4c+9gxJRKYmo7NaVgy9a+ynRUwzwtsVc/H1/W45F9rw8/CFeV63ISYQeVBD0/yarNZRZVhf6p6cfesR6B8SsHrOtyEenH8OWvXI77qpgCMljhcL/sPrbJj5ipB8Rs9e5tU580+fngw+23F+gWZKZIFZIonZUBZ755h2TX1jcRcWsjh+VfdGzoMsXUXrxWwVM3Aiws5au3vIpZEINkz4mqeU0bN+EuW+eP5GvCn21rQ23+oMO9xt9DZGh/gwP0Yto6teRQuD/yTwZKSm4Aj2Ev2iVV5OH94QSBdQv3TF+kCfZIGyp43f/rAqTiAaFvwW09DFNiSHWrFvfkCtl164E4i7kdKlijWj3cVeCSlZs39a1ul5f+pUgNAvXRwE0wOgqQ8K8pa+fx12P3jKZN1OpxUWapbRhkCsqcS5uI6KNYa3esck35VGsqt7iXmWURiM1ywzMECvEg2DaO9T2T+TexK9sdfp1NV5Dj+vkHiII/Hsmo94usltCS39T/vh7rJ/OUnNfyBYsdyixxtetAgTTDrC768N1fzP245O2y2B3EJT+Ywc86ArUk7PQmdAmvAqA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(4143699003)(56012099006)(11063799006)(5023799004)(22082099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AIw3vjFoCFUxjZrukLvtppCNyk6Am8hJnEnozgG4eYhQBxDAzEgORr/Gy+8X?=
 =?us-ascii?Q?GInCGxxN3PoOtrx1Wm1EnaKMJIDnpIPMXyPLc6klOdxZjadCUUV5bfqM5q7+?=
 =?us-ascii?Q?W/fMhtpUUbwnVOQlEdHGzm+hYrBbG7TyoAJ+eGQGfaTFP5yY2ENq5sw0ze5I?=
 =?us-ascii?Q?eu0bVyEkXWY/NieAk0JZ7zRiItvT4/IhMg2TR7+nBKCIW2pUzF13IB6pz1VF?=
 =?us-ascii?Q?0JoNjR+DmEag3RcwtQPAoBJ+HydFUap2iFmlzVcH9thhphYicCNZXzmW1uw3?=
 =?us-ascii?Q?sGNNNjY8qRkiBj0TA9yyMO+l5UljCQMN8IAnSuQ+Ghg2HS2mRdJleZcJtGdH?=
 =?us-ascii?Q?obaT6Ada13VlGPt6DdVByOELyphpTiiIOBP48OyL2RJiedhAnBsuhQ896xvi?=
 =?us-ascii?Q?sgNrC11SJVZCEQxebjux22/SaFxjIqBTI+la4wjK/+GS7xZ6SSEGT0F1c6zK?=
 =?us-ascii?Q?G2HILBXf+EGKx1OJzVx4m5wp0uzlM+TZnosP+7mmEvNyCqAIwHom/E/AfoAl?=
 =?us-ascii?Q?36ZOOY1G4wX3dTRwaAGSRlGNrxUV7uBP/8cahmj3YwIKa8jz1ADeATZy+TOd?=
 =?us-ascii?Q?SVdhdtviEvE2ZpddMfuV4SS31PLI2i1ZMVMjJpEWjLQU//QnBtBb6iiEqHtv?=
 =?us-ascii?Q?t1icJS45oGF+i/WOEWD4B0KcvXIheB5aJYuY68ZwRzohaPzdHxGIfZlvLxK4?=
 =?us-ascii?Q?KesEGSWaHFlw5Elvo5cGfgoWkFqbmc5k0IAputRjUhu5nBu9n6f2jspPhHT3?=
 =?us-ascii?Q?/ayKKFALOpDyzGGF6YVFM4D/kk601MgsiXQdYDGOBG8iKBrGLcHhHzIFfBAY?=
 =?us-ascii?Q?kLqEqyFyLa2ZuzldLrlf5zM7MnpX/8Ci0TAuvSSH1g7qxGHeYfBuTmXJrXsp?=
 =?us-ascii?Q?SvRIxlpOU7TFF00YtCGd7HoXGVuI67URBKw79c4HELc9VFA5No4UZcaPNCQw?=
 =?us-ascii?Q?dLw/2hzFoxlg7Jdni0LtygMTEga7TobD5VCTMr3S3Iw3l5Bz2PykLozOGPdl?=
 =?us-ascii?Q?9ZmbTvT6pZRB6yXkK/vXH/EPqtMLDcsD0AZDw1a2Vq5SQv2IeznNS+bkepVc?=
 =?us-ascii?Q?O3v1YSRtc0cEsAs28wbCBqxm3ZMBB4Rb2Hpw2tKOPBBhYknQZavymNGlbez1?=
 =?us-ascii?Q?NSjJLu4mMnP/NtadjggaNGIQuj/KiDQsS6p/j1H1DHvuzjqm2wa0VlsCEw0z?=
 =?us-ascii?Q?avVUbtg7pG0LPEiVNK2rmLcTNLgDqcCP4RoRCgEs0NwxFSopT6BadKoulPuY?=
 =?us-ascii?Q?TBtg5VK9dh7CE8NqgTBsQCayVLNqu0Mleyo8RpTDlTq+qvgK6tWBjHROyeA9?=
 =?us-ascii?Q?6VqiFaPmfyXUcKH6YJwKINAH6GS8Qef+rexRdoCcehOge5sVTREqQtmyw8zv?=
 =?us-ascii?Q?Mbt4lELE49WRRCit26HHqsvryU+29nNkvZpbru4cid/eOpy0TxtB/SgUU3dF?=
 =?us-ascii?Q?U6/wut0beHivN1ZVCJBx1SvJTD2Ebnm5f7bdvRgr60PBwigZIxInEFNcyFmk?=
 =?us-ascii?Q?Xm4x3xUkE3cLG/0gnwCBdqoR5X00+mSo+Bn7IOstB3LnUWwM8cDvPy6/ClwB?=
 =?us-ascii?Q?C3ZAa8nykJboHtWQqmcSpRU5j3rxO4Ta5LP5FpPaWDK030YUnio7U19VuMuS?=
 =?us-ascii?Q?UH+aGRBLOaj/jD/7x0636HeuLsPhn5JuZvwMTVQRkAcgQwCW/X+U6HH/JgNX?=
 =?us-ascii?Q?a9o0QD/oSVRSKmRb5pfmguMdan0OOe9C+pwK0qHdb2p8z86P519cyE+8fHOA?=
 =?us-ascii?Q?6wWcUpnT6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6051b857-a040-4b8e-e403-08df183c41e8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:58:39.4970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mF1e4ShaSNoVlVxJhwuOFDEeTTDL7EJA4hoLEQYtPFLk6n4a7WBEAkraBTxWMLAL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF816B88375
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E489740003
X-Stat-Signature: a53eczith1bmo73mibpzhuj7ntzt9m9f
X-HE-Tag: 1790035124-644356
X-HE-Meta: U2FsdGVkX1+G3wginDLsiCydFHjI2zFz+5BwE4cOJeDA4wTZ6HREIDs0jidi+GxCuv+RLCZV1jnamCRMTuL6VDlNYR6O2YL8DHXfYy4H37iZ59ZDjzmFFnPqCvOsNs7A3xJD6J48KQyeqxNQQTXjdnVLTotK1DWJYMWfrBKUxpHLOtWIwZK7O2B8Xy67E24yV4zqSDI7ODhXTjujnEOba9vBp6NSy0SjLeDktIAdWfngYQvTCIoyHKdTtbj+bCwyaNMoJErTHLjT+sm0/jY09m4GXe6YJdzLlQVZR+UteGKjblbdn+WoOKQxRqJ61owPr11UUAaOpv3l/lEH9XnrE6Osb9qWRSa3e3l3Db5yjao1DywWw2KvUlvuZfzAj0fV/VtyLVGibH9JX8SzTHlP3Q1r0s9sY3F1kW0VWqIhm66i2d5x6vKo8vrfd5t2w38WE60ErXiSCvp9yidks0mpiCJ+oB9vs2BZLxo+AGoGHSU5Hy/MFz6qqEI2e6FHkgNzrieFB2rZMXtpI+F+02IBEF1QHoPKG8+Tk/g3xOtSB2hSn7TJMhd1EGdQHviC66V1YtuYGKXofdJYrUwcHKfZWyc/d5/pyL08xtlJxm9Iy5co/kRJ6vbp+pMJoRlrpbzolmutE4zACMIct9qfKxjBvjFhAr2AH7hn4mb9bUGsiCgQ0ZlK27kkiF2BDEsfaA6+IuaEY4oCqpMP0ZKOZFyTwYx4iS5v4wMw9gBi09KGkmuP3fhujdv+iEIjG6VjPsGf09Gx/MSj0oR9sNuUfTWLqBFz3Qi4j0mTcOZV+VJvjCnCmXOmgovqMfdx33fUZQNal2SXMHMHZK2qQ3nuX0Sew7LwEeVBTEp5eaWJg8ER3l81RIZBDmrdcDA3NVw2RcHirRceCa8+grWDovZmf90YhQVQZKubelG2p2WOT7gzMt0QwE/P4Mw3p4CtC0jI6jTeXr5L8l/ai2UBBtJR2Dr
 rHIfPbjY
 vuZ41Phnl4lCrMDK6PEW/deD5yMiMHsys+dFqaXzxRmltI9kHztqBxV0ljmbKUe2VjddgNxPFJ6J52zTsWycZ+P5ERy4EJtbE/MkwJXAz3ikm/Z0p60pNVzAAI/qDurxofp39TKjZa9oLK+ypHUuBor+1WFPAOIC7ZpI9PS/f2UwOKqSEivo7sRz0zoZNGcxegex4bGRsuXlrM/5du1b59/XZwBaKLxdPn2Ql0fiNVpLzBy79csCSKJNHCvkMqimsHQLfYEq5NC0VijNsV+Dmq3RwhuVDY53GwdJSS40jOTIdW3iMs+CT/aOsdsFKxWRhE0BJxdi8asXtW4dZtP5KqClOtdhrV3hdNyRyRcCwwxGoxF68hUZt9GuOgxDYPjf2LF7ANTbcxzLNfkVbywkdLhx1TieijcTfv4J8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Sep 2026, at 12:38, Gregory Price wrote:

> On Mon, Sep 21, 2026 at 12:18:12PM -0400, Zi Yan wrote:
>> On 20 Sep 2026, at 23:29, Gregory Price wrote:
>>
>> OK, ZONELIST_PRIVATE and ZONELIST_KTEST are not upstream yet, right?
>> In theory, the new zlidx can be added when you add new ZONELIST_ types.
>>
>> I am OK with adding it now, but you could mention this change in
>> the commit message to avoid confusion. Something like,
>> for bulid_node_zonelist(), use ZONELIST_FALLBACK explicitly.
>>
> ...
>>> And add a BUILD_ON_BUG/ASSERT that forces any CONFIG_NUMA to have
>>> balanced zonelist additions.
>>
>> Got it. Thank you for the explanation. Are all combinations of
>> {ZONELIST_FALLBACK, ZONELIST_PRIVATE, ZONELIST_KTEST} x
>> {N_MEMORY_GENERAL, N_MEMORY, /* private only */} allowed?
>
> Slight inaccuracy on the way zonelists are actually built.
>
> Every node has a list in every zonelist.  The contents of each node's
> list in that zonelist are limited to the candidate nodemask.
>
> So consider the following nodes:  N0, N1, P2   (N=normal, P=private)
>
> With the following candidate mappings:
>    FALLBACK = N_MEMORY_GENERAL  (_COMMON)  (all normal nodes)
>    PRIVATE  = N_MEMORY                     (all nodes)
>    KTEST    = N_MEMORY & !N_MEMORY_GENERAL (only private nodes)
>

One more question. What prevents one adding
build_node_zonelists(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK)?
Based on your above mapping, each of ZONELIST_* has its own candidate.


Best Regards,
Yan, Zi

