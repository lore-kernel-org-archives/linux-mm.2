Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA2CCD3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 17:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF526B0005; Mon,  8 Dec 2025 12:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7006B0007; Mon,  8 Dec 2025 12:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F1A6B0008; Mon,  8 Dec 2025 12:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B05C6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 12:03:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E1BE883FB
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 17:03:12 +0000 (UTC)
X-FDA: 84196924224.17.D387CDD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 065B5180012
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 17:03:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MScYiowG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oxfFg6Rw;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765213389; a=rsa-sha256;
	cv=pass;
	b=27uneAK/ZEEZaTS4k37MuINHb9oY7wuylvINgoezk/y2LoChMDU8Qq5VqQLA9CvYLC+okY
	cgaEPTAqNV64V77XZUN+oMuCttnSH5zwIJBG2Z7KE4bH97l58oO/EZqnD/20EA5/hm3rra
	w1pgCw6vPtn2etaayR4lSza56mFpcNk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MScYiowG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oxfFg6Rw;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765213389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzSkq86YbJFqFPvu3zJQdxzzKEE7gVzi5G8rfkYNr/4=;
	b=k5UayL2iVeDeDi3a4YAiU7MMwRuN0Ajm58Lk0dC2+xBDsq9HNPLxaWAqmK3zeEk7tnjgwn
	hbtlzct0IqvPGNsNzvArY6Gz4BnzuF24mIJZNmju2FL+cRzmDGmUOOJfTkNI9MD4UP4mzC
	Mnl8tZZ6CysXyu5I08SdIQG3znULBJ8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B8FKV0B2642032;
	Mon, 8 Dec 2025 17:03:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xzSkq86YbJFqFPvu3z
	JQdxzzKEE7gVzi5G8rfkYNr/4=; b=MScYiowGz0hPJ7zgxLCyZedZBeUGGfjxxu
	qkc3B9tuIjQ4I0A1xMGx99Mjc+AdvrAbVH8PyIZ4rSXm4SXG07Hq82Jlei7gKvzk
	Za5jgbOJsEWiE5okMvS/xIEQ603EpyQEZ8zk6S7xxmYxVFp4VloS6NQbE59XC2s2
	UFniodtG0EE45PDGH29uIwiHRTKxnfPixXeUbf7DD1dqtBY2nhnAuoZbSyDp8i0+
	smN2m8zj/LpberPWPvFvZTRkeH1wHN2Sze72SSXqhXNlrpTuQ/1r8psluBw9sog/
	54+65Fsii87lJTZJKy6vGKq5uQlj9dbjcifuMs7l+UAjkCClzNEA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ax17y85w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 17:03:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B8GMbjH020893;
	Mon, 8 Dec 2025 17:03:02 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax80d5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 17:03:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ffXKwOC2jpjl5MuqTorJCd2jNzUQsm/w4J+Ek9BZZZn2zDEFaRa1Lb8OOq4oB0NvERq6VN6eWzKhLgzEthVRZMppe7pL3R9CtWAmBsfsVsvaX4ITves35Sb4vAYL+7HpttpfVK4Yak00Lq/fWL+tGG7Nq+pnWTs2r6ByNTUEjtB76QnUx7FJ1zxtpcN5mEnzSUwf7dPSKfY8KnVQ2uikHZzqiOCsZgvZhESY0laDLrIDIbfq8F2sDt9wEmkx604nba1NiXYD1UGTZamt4OStSaM+k5KwxgdVzgGo+D2rOrQcyzZNQK5iby4AWJK5xiu4+8C3ICj5/SzVhm8FNfHeQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzSkq86YbJFqFPvu3zJQdxzzKEE7gVzi5G8rfkYNr/4=;
 b=r+uyk/8942k++idpkFT4U98YCDt5GGahp0lSpNWvOecNTfVDZoXKIhE1Gme1SN6MDK7Rn2+QqTQzz3UOIJs7xnZjanKVyDOjhiDpfStFVpD6i9zBeMo45wCdqzAKAAtzqr3/282hqrU3di7cOKeMujzCKK8JegonwQaZgmWIhPjEbP5I+zrmX+mQnNt2aDo6sYBuQKEgT3DvTL+6tpZXKM5mkzKRqytfwUKn+bY8z6QCiU4d5JHJxwiHz+mbboAX2FdE0cjuvDL04C4hia0v6iI+Nc3E61TWMrJ6f5TdROAXlywL+fa7fKvkuC3/kCQ+y+2jgE86MIRoMpf98mgWlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzSkq86YbJFqFPvu3zJQdxzzKEE7gVzi5G8rfkYNr/4=;
 b=oxfFg6Rwn3pEJ34s+iShsPAhPOFlSglmAF1W36eBcxxpWTbPxbis3R3374t5Z2JBiW05obolVwh0Ep/9MNNKWOQd/1IoTaDe+wqT2ZOYwBoiYxBsb5ce0HAUnVcCn50BMqoRMaMyfiSONKAA83mIgGpMdK7oYSjZgMFzQu0KF3I=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB4959.namprd10.prod.outlook.com (2603:10b6:5:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 17:02:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 17:02:59 +0000
Date: Mon, 8 Dec 2025 16:42:43 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
 <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin>
 <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
X-ClientProxiedBy: LO4P123CA0388.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB4959:EE_
X-MS-Office365-Filtering-Correlation-Id: b9c66323-524d-4c15-82db-08de367ba3af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?idyFWkLzyBu1bKy8Zy52q9SIeFeR+YTsOKoUivEIceeymIZdw3zdVa3ckTT1?=
 =?us-ascii?Q?/PZQ9KEYcqB7T5AY/gbNyPSukdLJiil+iumFy4jz1qt07oIkr35riwUCVlzs?=
 =?us-ascii?Q?Y4HH8gqadGC3odB55rjL5H3w4TARKb06A38IJbPss/UKJ3NA+h7VKNj4E6t/?=
 =?us-ascii?Q?bJdCFB9vhOlrS2Zb2np3exyep2sCaM879zY59cniIrm5oFXE/oC5pJtMh3nq?=
 =?us-ascii?Q?4Rl7g6RwN/Q+uJSXwZ+amWFKfKdONW4h+H6iL8j3cv/It2KspeaPqspJ/DEZ?=
 =?us-ascii?Q?ddvCBi8NBdBoLB86ItId+L9iFQOM5zXTDs+a90PG9rF7N9KChXwT7COf3EIz?=
 =?us-ascii?Q?MHUvl3tJYOYsJbgjqX77s6n69HnhyA8DIvkhisDSF8YyNUexQGt9Fs8wcVK4?=
 =?us-ascii?Q?+w+Ph6Cn2AFpemgBNpi12jxavCguEnPCY9nV6CMb2pMvRHti1r8pmr6QVpMS?=
 =?us-ascii?Q?jQlywhtzt+dXbMac0FT8Of5oMf47Qa7SmPrECU6tb9SpP4wulcN9fOgmBHY9?=
 =?us-ascii?Q?VZRff5eSYgTjmookbdrnxURtijfIIL8P+xjGYXuVIg4jQs+6RAzMbjc+O9xf?=
 =?us-ascii?Q?MBZYmlDRrjvUlyKLMsqNVZd1fxNX8j89XMj3DGEcoHc0ZU5I/Ud/39hSCwkd?=
 =?us-ascii?Q?fYqR1O36oD6R+nHcoAoFzhfCxkVSbtQcQhsmNvvAk315SgMtw/IMjtsqT3F3?=
 =?us-ascii?Q?cNSM1hsdB6tWQqpBx4378dV6n1mCjXHt3jgC/QIVkR+//L7hHTe6fcw0zHs3?=
 =?us-ascii?Q?VqobK/2d5GVwXGY1iBmvRr5e8X/0RC3YOd87/u8951YLu9k2loUKQzW+GRZR?=
 =?us-ascii?Q?B1nn1/d/vgPzCu5eS0tzgWKG4RJ/Ol6PtWHv5/ogaL+/qpbLuQNICZdzgfe3?=
 =?us-ascii?Q?RqKV0rsoUbMQStXlGAPDc3TJpne2ZKSpfz4ugWgDP1VmBTHihBt2h0FF+rC7?=
 =?us-ascii?Q?LD07g6jpd35ZAgczMDlGl6x1/+ZNVSh/GcWtfW+dFtK3lOk+nyySkx5uK/yn?=
 =?us-ascii?Q?ZqGV8Y65Ff6SFV8v40YbWn/jpeay9Mbk3p1fnO8ccoxJvicaAzXM812EanDM?=
 =?us-ascii?Q?V06F4Cre/ARJvptITE1qID5Rs7/LuLBvwcP/HyonrxNVhlEckZAHJyOD9Vtt?=
 =?us-ascii?Q?0hFKZxJnsx3tiI2HLBAPPiJk/xq0kM8XIHqaIthqFme0QWQrWxRJ/v5cYpGJ?=
 =?us-ascii?Q?pC3TSEo/6jHVDgEhGyT97XWvi7wfakCIla4rPr+HgwhAqJIKQaXqVwUoJsu3?=
 =?us-ascii?Q?oNkKgAPuSCagln8IMvLo6F3YpUbBShARw0Do60Pm1tFKoEpa3NLdTGeFu0cA?=
 =?us-ascii?Q?AB6aMws8/b/yBIrWO8JWIiM5SwSW/Eyz3mxJ+dP7yCKrYP8s4ehFXq6INdPT?=
 =?us-ascii?Q?ppsimlqyzffIM73DGHkUdwWBJ7EsjQJj7rxqu5qaxbmod0vScFbgD9fn9+zx?=
 =?us-ascii?Q?6UMyy9c7tRzOFn/1jAecR9KtME4e1lE1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dBekifCKLuDxHIdOiKHuDmmpxzPa/41lg3WtMEWN/SbFf0knQ4sQFn34wVk3?=
 =?us-ascii?Q?IFswNShRllBPg4b50ssqRfVINkcrNesb9cLswz5CEAwTscVhj4ZgeiWRmncp?=
 =?us-ascii?Q?wpt5Fqq3OaihBD7/QW8xRLPBTvzpK8FcTWBbdoLeTcLY8RPMGLRr4StvEJKn?=
 =?us-ascii?Q?TjPwP08OQAJTGfpieYsU73OlVoN8nLXvm0IjpI4QORVk1wqRJzbcdxSbAwDt?=
 =?us-ascii?Q?n8Dp2gLIOepOMzW60sTv1/9Gq5U/6iujYomUkHhMfisgHm6FbxzqqNMHXX9F?=
 =?us-ascii?Q?0I/WzOPqkhLmps6dQhViLU5QSCcsFwQDq53KaJoLay8U+ijfkWb8XwkAtFDd?=
 =?us-ascii?Q?s66zXlmw4ftgh7YzpU77oFq0CivYB9uxsPTAXpGhLbTu2bSJANoox9MHRBlL?=
 =?us-ascii?Q?2SA83JwtYlrVqm/DTxd9LqcqqCg85B9Ds5MZHcaQ0Kr0gBzzIW2Gdd1lavBR?=
 =?us-ascii?Q?Onft3UVeAX8R5rfXOcEqaYk3fRowveFF2+IozEquUBQUee3vBjAMj4et/koR?=
 =?us-ascii?Q?3TbitI9jFFkFk0HikEp+fZzjP6srx3euvH2BtaCUmEeDhm7INE+szNnq0xo3?=
 =?us-ascii?Q?7VlK65du/k20GY42u7sUpb3s4UTsd93rvoiImDvI13wK9IeIbcui17Ze/5AH?=
 =?us-ascii?Q?9LVC16wLO6xCNj6Nop+DDGsrOEvlk/fQom7NSuYwWqvzTsSN5NZ4D7MPzPPJ?=
 =?us-ascii?Q?klRbz4Z5z8l6nwHr2JCySDkNBbaVeJ/1Ws8Bi708H6KGD7r88sv39MylweVe?=
 =?us-ascii?Q?SGlCyxykPy+u66meznWoPzSt73Wp+SjObKLMbaaNFzQFNuIGtQmrEiOHZF9S?=
 =?us-ascii?Q?+dwBdox9xk6gLEDUaLF23OPy/3erB7ZLVgfCouoDwLSXvEG26nFC6FuHt9IH?=
 =?us-ascii?Q?XRRh04jk9HvRDKYGDS+q6la1fRkZt459pTMRElYiFrYO+0Xaiud5CZDBJfnp?=
 =?us-ascii?Q?um0Z+UJa5bpIIHl32TBt9BKI4CQOhxCS6c5/xp8Lu98+/qLrt8Nn8+Q2vI6I?=
 =?us-ascii?Q?ZtJWjT+go3now+4yGANLwYLfNn6JBzuEwGORcbc/QjQTUl6f/LV6VZdPQ0NJ?=
 =?us-ascii?Q?QpWW+GpYmHRmImCoKmxRdxIUekYMvU9u7al+HD2NCXSDEquNx7h+5X0jE52b?=
 =?us-ascii?Q?Lc4YffTM7JDG/d1gXoiStOwDVpFs3X6BSbMPXyx0Kls8+uBA6/SDCvpiyWBr?=
 =?us-ascii?Q?alH9FyJYlGVAp9Iq8zpfMj4V95XD6vqhW+g9Dh2DKAWA6wYBidEXYlE3zbt6?=
 =?us-ascii?Q?GTmnt3QMyN0LOI1sMqYiZLHWEFuPPqxen3pvZgC1bi8RVuzIBJDVWGmzjk/c?=
 =?us-ascii?Q?fLZ+ucDZ7/Fi7L623RwSki9MNsAluPEJmQHi0kCSzzQPFKW9VVOAVC5+396e?=
 =?us-ascii?Q?dlgahUu8QtLfRfNcHm2cgD0YjlEtGvRwaOZQWS/EV5xy5aLCHsI82iWICiNS?=
 =?us-ascii?Q?xVxvc1Y463s7QuNrsi1wFzuK1IiHhdxjClAbzwFLPecii36nZoHzyNBi+5ws?=
 =?us-ascii?Q?XsAl/2UniWOabuh+MqGpObEO4jW6dx9O2IpV3oMRQPg2CerWDXebz6ecj8iH?=
 =?us-ascii?Q?u4WWj91UzqgQlXzC+2JzJvxl4d6tNKZKoo6pP09vQ1hEJApan12u3p7bs9JU?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xYYv/962L+OhAC97t0TQpl0LV3IsSM0xG3f4wS1XSc+pA0h8y1CI1hAJqI2qQFkRZvVflffhF5xpRdDFbb6Gkb6dZJa4n/A2Mzd/iLQVq/COfutHs1MOLvpJsXOD7atXEQOwhiNR8r/JGcv0rKehMFgU3WpI0Ln9bVpNijbS3ObFOnDUQjctlLf9fqUFR26KClps9YEczsqsb9IwbfMEaZM+2LWsup0oSE8Gtmneo1tEUGmJdxXbwm0Vmki1fFhVTpP54fY4X6D+9xgcCXkk3jKxwHdW7s5cImj0UUurw2ciWjRxiJnRXuSMqL+kQC94qMrV+OPiXmUsYBRTeFmjFox6QLMGeOyU1bnL+5GeoE8rzOg0LExbLM1reNCIihaABryVzdsWRw3YgDR8WH0rYRr/VPt9nqFoKrGA0mxlOtpF4YpVthgJNABYZx3iQTiAqId3efUiDtFPIZMkqNjm3vNM3UYXea8rvSE6RzGQTIi7b0GEO7L14SJES6F8GqPaCc8mFgdW6hRLng7b0L8t+y2ONBbNMdj2BxH6PXAwBtaxujej2yeoSIvsT/9DHfzUmdGwKQjQdsLRz6vDGBRtefzoiTdCZzn2zoMf4ABmLLA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c66323-524d-4c15-82db-08de367ba3af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 17:02:58.9852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3T+gAhIvjClU86MtMTG8T9DTnLHBDm/LEbk2Iy/1gfhDWlq5hhheU7DH+DGc88hiDcLY/uhKEXLOkq/SgYAS3jIqDHRqiGkBXc/jCBN5+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512080144
X-Authority-Analysis: v=2.4 cv=bL4b4f+Z c=1 sm=1 tr=0 ts=693704c6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=cXk37wsRSh-1Tf_tsFkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: WT4E11eSAsxDkE3T3m9bn2WFYKn1GEIS
X-Proofpoint-GUID: WT4E11eSAsxDkE3T3m9bn2WFYKn1GEIS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDE0NCBTYWx0ZWRfX9eeivDpqLzHQ
 Y14JhTJpmKObA2rgC++Kt3eOnzENWFWA6EnZXgPF69+RDDcodWeJHpR8NdldFSlOddzERO32KtV
 l15G+oduAGaQSekYImkNV6YYCCaZjrCYMZgXbG/pdvstbagrLZPWErhQfqmKMvydtKCraN9vhK5
 T0/0NUEotWnu7bwzrSLI+eShMGjzS8LGmLod2w7voIN7T1LC5exDcKWgSY8JW4CXt/U5Cl3xrN6
 3Y0EUSw2/4LZcl6cqrS/elxQSAfg13zyl7Bw/RXE/VP6pbbFUtwCXe4SEosnxU2S19FH9jWYj8v
 4VcwRz7Yplr/nHbwmlUz45Wt9OopRy0wpUSBAU9slyNL/CRvFdnwuOMNbxLo1ThGk9LWpzD3Qo4
 3PU9Rlo5XGtbkcHFjSyBzi1u5gQPVQ==
X-Rspamd-Queue-Id: 065B5180012
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: orae8fyboqbqt7aupw1kor5xqzkqfy66
X-HE-Tag: 1765213388-297480
X-HE-Meta: U2FsdGVkX1/WWF7CzLuqiZFC8A57HghNY+wGvjFsPNHTyH0t6Yg4IjSsUXaH4jmVmMM3B4xLre96ULvkJz4F3C8UDOeMwHPM6p3xGdls++h20/3SQzbUi2jRBGR9zDYOgFaA6j1AiNvw8+GOek6woG2AO4HoCgdv89MX8XmsGHZQENspoSu+0WY04kaVTJ6/P1kCqnPqpgYzByYiHHCA0K88horpwSVUdNb/plSXDsgflNt/RRXe4YtFlnrVnrWk5Q9RNQ1eHdMNo9HF8kAUynpSQzMcxB7Zm8Nj6oskaTvZCR848/a+9E24E66y4TtHuVm4rxjfxgz5xVltxVGMcPHxIb25GnFafBVQ82W7tL9yST0qgdIFhOLYb58qBDA0/vJLgEEYa0YWZHZyCpwYoMH8Tegc+inU+vupzD0KeBAKFJipOgDLY5aaHvLvlITb1D7FxqEHhZZogU5W2RRZO5fh9jM0CVjCdT5coSM+1PL9Lqly79HMLURNnue5RSfgFOSoBmtNN2znLED0gd3wT1+ykCU7r550lCdS8qI1heqCOpvSb2dw4v3G/VsqUZHoCcXiT74p8JG6+DDP/dFXwWpt0UZ/Ruj1iyrtm+l1t/W/JEgkEJB7RI/nUcoEUJI+9UaGJxY1dpQViWh5JVfRxPkNMfKEaD8f3dyffs52klZS5d/xyarkvF+9spXEuk4DXS8gL5K0FY8kaKj8pF2fzY3wX+63UYIFtddo0opUa8qjj+jPUbPcCbPHqlbOku5uwHMs81NoWvcXLD2bXrP/wSmw+IfIj0F0BLLTITtTnGWwitkSLUXCb3PwiwyigmlUqN/lTwPVJZKL8kHAjvd2jRLQoWDCjpS07KW2V9lrhf7Rfr+Wxqn6y1E1CKE5coMyVsy4v0ElaSTzQ1KlhB0GZZKwKHLVGHhhwzAz9GmXIsaxw77Ae6lanMXoHgLqQyC2L6bMr1jFIc3lVqzEbbZ
 V9Sr66J7
 7ziaccaJuAYKiHoCx+gTmIBsCXwt1E8GhLubzTS0fwBPMxRhoktLlTTcc3q99U09+QlUHejTWtm0WK2vNBfDbcZtnlJILuVFhcx5PMaVEi3c058VesuD9fbBXsnWpo8wOK3VQOlhjhIUYoC2bfAJ86uc7bBLVuYVMc9HTbWGkA18L/IM3NCiIWE/mtnKRMxAL/MXJaKm80xUfxjJRSrQYX75/GZe90vcEza5rcTn1Uw6xK5ijxVLBFdKjUkaq/2R55syZ+4CPNKubn+dLrpozxFOXSKKZ0b6iBmHkXj7kwzib6bOKQo/suX9wRdypr/bjT75sBi7mmYnI6E9SFdhVaUKN/8UmGNb+qaKBL10QJGYmPC1QpPl+Syv8wBWDrenEfAAW56m2xAehGkL+qRBRpRHXOPPwZdRuZcEzQ2OUQZIAv9mJ8EasLNwgwElkl42sYcyrr4GHZhdkbaLqjjC6AQAh2wb8tydM9M8Q2xdnyOzLxY0kBvw1vyWgj1JQOLP80qDz+gzy6dK4SB/j+Nc1rGo8XOyjBk3pp00etD9KqxHSFqOPebljzzE6bz2s7MXstOasmq3p9L4sUIyZAq0Fr7T98WoTWsnaI1pQ67cZNSWQmqb7GPPHiNl2FLz+IkSQL7gClmqbLptDpH42ZThXX5jssv/BKOtvvluLcktHd75HwLZszcS9hvnncQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 04:43:57PM +0000, Lorenzo Stoakes wrote:
> On Fri, Dec 05, 2025 at 09:34:49PM +0000, David Laight wrote:
> > On Fri, 5 Dec 2025 19:18:56 +0000
> > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >
> > > On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:
> > > > On Fri,  5 Dec 2025 17:50:37 +0000
> > > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > > >
> > > > > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > > > > how VMA flags are declared, utilising an enum of VMA bit values and
> > > > > ifdef-fery VM_xxx flag declarations via macro.
> > > > >
> > > > > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > > > > the newly introduced VMA bit numbers.
> > > > >
> > > > > However, use of this macro results in apparently unfortunate macro
> > > > > expansion and resulted in a performance degradation.This appears to be due
> > > > > to the (__force int), which is required for the sparse typechecking to
> > > > > work.
> > > >
> > > > Does sparse complain if you just add 0? As in:
> > > > #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
> > > >
> > > > That should change the type without affecting what BIT() expands to.
> > >
> > > Thanks, checked that and unfortunately that doesn't satisfy sparse :)
> > >
> > > I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
> > > that this is an issue.
> >
> > I might use some of my copious spare time (ha) to see why BIT() fails.
> > I bet it is just too complex for its own good.
> > Personally I'm fine with both explicit (1ul << n) and hex constants.
> > The latter are definitely most useful if you ever look at hexdumps.
>
> Thanks :) yeah I just didn't want to go down that rabbit hole myself as I seemed
> to have the answer and wanted to get it fixed, but obviously am quite curious as
> to what on earth is causing that.

I did wonder about _calc_vm_trans(), given the 'interesting' stuff it does.

Maybe I should fiddle with that and see...

Cheers, Lorenzo

