Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B426CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 08:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600B86B0005; Wed,  6 May 2026 04:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7BB6B0088; Wed,  6 May 2026 04:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FBD6B008A; Wed,  6 May 2026 04:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37FF66B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:59:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEBCD1C0374
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:59:29 +0000 (UTC)
X-FDA: 84736396458.30.B0DDDD5
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013016.outbound.protection.outlook.com [40.107.159.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8F4481C0003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:59:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DRlh400h;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DRlh400h;
	spf=pass (imf18.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.16 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778057966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GShkpkdjVof2AkExZ8P++AdpEuTmRQ24CmQcU23pB1c=;
	b=YkE4sIh5Y9xNCAb3NOWqQiSGjkwRLd3UmWHkEmCCSYj5BuzYAkoWJS4fZ1ZltI+Aaec9OR
	SBAyquZEcyKYm0vPB1cX/OXyACdiEa4LUzFlFsKJYwcTGOh4d2icI1pzaAaGM1c0xwbk1L
	n8SfoTi27+n3vqIaWUuzwd7p+wwoeRs=
ARC-Authentication-Results: i=3;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DRlh400h;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DRlh400h;
	spf=pass (imf18.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.16 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778057966; a=rsa-sha256;
	cv=pass;
	b=kKYWXtaCCvQM80qMqYVImFEqBidJi7SBBa786jvOrHbZCVuLi2NMdsQ7qfRwqFVsKhBGuQ
	gb0t7I5PdAuDn6IQV3VsRFJ1v8A8RLpIFZXVy3LkTmqrmLFYeWeGPrPsJLTFTl1T4ggOzB
	0wooSocMwuVjFmL71avxDdjxqK+7NqU=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SGmjC8FPCHZn2wwnqfdlDAKxWsLPXbEQLXx5GHzrxRqTH7kHpKjFNJ1jSRLFkhaTu1SQhAr23NPV/T4GJc15IcwviZGoR6gHIVmqTZX95JUJekeRP1PPgw+7AGOJS0EwcMkeaftwvOtBRqLJVI03hvtaX/wYwWRYOyDU/lPBpDDQDQqyghLbg0fbVpn/gaD16MpjQX3xgcEyPm0ewLJ6m+Zh+9KblJ5ayMZSTc+OlicliwQGXmU0ZUrmUstPbGDUVNAEqordZ4++4unIHidPXjHDGtjVqt+KZS7XH0feeL9iU8z5iZR1K3KSIRCrDJ0AdMPgtAEi9g4or20viWkWig==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GShkpkdjVof2AkExZ8P++AdpEuTmRQ24CmQcU23pB1c=;
 b=WZU19LHo/oc8xHjoJ1/uLfHF9gKEYclGuplBNxEiZz8jUK9AfayZPA1mGuI8tla9gFdDcdTRbjVG2tA5PfeGwWu12/5iARFd5NCQSOyJodbKpPhCDy0B7z9ab6wTbNOfq3vm5Vt+58IMx7LP8K53mzkWFuHQuOdFmdU5T7RuLSuOKBDg9QlLPjmOXUeQatnHulJgrH2v0OVFJP1saVE6esLNCKuxyiV1CKGHZZmGCioboXgfINYqOm8bGv3SD+UBvpoaHLTwn0mMZ5wRGRNIEDsLGPeCpb+HbphOiFN5L0HfTYe3afov3J8PXYhjCB7YUzBgwX+bT5uAIbo2V/rjPQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GShkpkdjVof2AkExZ8P++AdpEuTmRQ24CmQcU23pB1c=;
 b=DRlh400hR0UHrQmsVnVpAeFI6czagFGZr6FgBMrIj7e6q2E2KrS6Mxzej4Mio0KPY8ds0w1L32630BHtTudbQLH9CQ6Wh+Ncl0t57aY6jOrDRQ8rebdXd+nUA5qI1cVrnBUX4bR+A0VUC8157vbwTY6xiBAOw6/qTSoNH24LfXA=
Received: from DU2PR04CA0252.eurprd04.prod.outlook.com (2603:10a6:10:28e::17)
 by DU0PR08MB8662.eurprd08.prod.outlook.com (2603:10a6:10:402::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 08:59:12 +0000
Received: from DU2PEPF00028D03.eurprd03.prod.outlook.com
 (2603:10a6:10:28e:cafe::e8) by DU2PR04CA0252.outlook.office365.com
 (2603:10a6:10:28e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.16 via Frontend Transport; Wed,
 6 May 2026 08:59:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D03.mail.protection.outlook.com (10.167.242.187) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Wed, 6 May 2026 08:59:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L5+WOdJ2IVsE+/+VXBPWRg+88rk1Fj7GDD544N+aH+NxanXFoskOfhukdqp2nqPiyhWwVurnP0tkQSJqTwJ+RNRLq9SjUUFnzBCwbf8YfXhOVGmQ/nieFsUeoNYVLSeh1yYkwHUiujFRLJrjX5MHVMHw3KJM0nX1I1rPtqCUxr1ZbXnBjdXuMT7CFVtGu6TOdd61t1LivkzuKrBIzwq4fN/STahAZNdtGILf/3g+gW8YNZcFn60BE2hn1FOVLg6dSk+iqqiAvhYb8dTdh7j4FigxD3kiMVXS7i2FcrgdUzH+uSHRVw0UiqFYuXWXU8DNJtK2RFpiLTfz8V1VK5AuUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GShkpkdjVof2AkExZ8P++AdpEuTmRQ24CmQcU23pB1c=;
 b=kMP2bDlv4z7d0qlKlOxs74sQPcW6QELmyUXQMf5odvorB0jtlxTbo4FLi/XHikaMUirCbDhuV0yXZqNTp83WptVFKm+YEWeQgoGJ/3W7IP96F4AwYhsNkm3dcvOEfw9PiKXhiSoPGNMpgAUYtMnKhqdIPU+SOaIx8ikh9qcwQRmhffu2o0Zm/6O8FasVw2K7If/BxpixGkN4FotnKt5GCHSukARwrfr8mgpQTCL9Qj/dWmOATI5gAi4EMqef/JNQIpgoDww6fhRJyBfTGSCo7rq/5Us2CbkEZ+CP+jRr9DiCeF2FEmVzOxO9J3o1ubAVHds65WE86SVbNjmlxrTEyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GShkpkdjVof2AkExZ8P++AdpEuTmRQ24CmQcU23pB1c=;
 b=DRlh400hR0UHrQmsVnVpAeFI6czagFGZr6FgBMrIj7e6q2E2KrS6Mxzej4Mio0KPY8ds0w1L32630BHtTudbQLH9CQ6Wh+Ncl0t57aY6jOrDRQ8rebdXd+nUA5qI1cVrnBUX4bR+A0VUC8157vbwTY6xiBAOw6/qTSoNH24LfXA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS2PR08MB8695.eurprd08.prod.outlook.com (2603:10a6:20b:55e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 08:58:08 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 08:58:07 +0000
Message-ID: <01fc006c-4a41-40ef-81e5-fd9f1963a0e5@arm.com>
Date: Wed, 6 May 2026 14:27:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/54] selftests/mm: protection_keys: use kselftest
 framework
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-18-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-18-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0239.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b1::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS2PR08MB8695:EE_|DU2PEPF00028D03:EE_|DU0PR08MB8662:EE_
X-MS-Office365-Filtering-Correlation-Id: aa83fea5-4fe0-4c2a-68ce-08deab4dbe19
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 D/KW0K60zj2s+mlW8Gkkh2MKJO7GRsZH3/WvFTXjnqQJpmsI4FIyxW1gMVJ8d0EiLe84xVSccOl3/Z1NBTa2No8S0vzyol4Fi+kwgHIjmXoq1cDR1EoJ5XkxEP/nmb3q7n9KdsLCkFeeztBJzDUHqXnwf+nrPgk9Rr0mgW9/toQcItZTOmbYlp042IvtNEIQB9Uf0+5k9CHRzedDSWYmohTQA97h2Lww864oWCschVG23AuOGVP4Xr1Gt5XGG2W2dJ2F+W/dOrFJo4dWmCMmPLGn8CWPT9UTkOhqahuCjsxkhWTT1YbEF3OOH3wl+aRE5CQFJM6cXcopRv45DQXc47B0F1otkXgKsuFUcsDf/YxZZnLRvKf9SCXPj1E8SKn//8Mxo6lRZDUYJN3+7usTwLXHvnhn61UQ/AzGPMG5vlPbJADoaKT8wsNGUbpZ6/X/M0ajN25SSoq29N+60/As5Z3sJF04AGrvVmOYWlC33Mkf0mKv7swv14fxYihXTxZk1KEpRKwFqOTUgzFl6jTNs4orF3OZ0YXTt/FFGHbFLNdXxv2gU4hJEg6dB9lRSEhAfz5QXDHsSGFRsnaVl9xbVuNcOB/w8xrI0f4aNHJIRT6C2/A9hhqZSz4EWWg2vjnD3iWJShoenoTeFh0q8aJ+2X1Kk+HzRefMPIR9g22v4unBTKEzYs+5IlOcEDQFZFpT
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 wouQ5taFZH4bo+S6rd8Bj1FiBXxBFVSL0hHt1OhEPsGysXtC1etzagnBZmy/9XUKLs/ZQOl1/iuuv+P/rcXmzu2LwJneoVxr16XEwVbZDcrT3ug8fR9QQCAiGHBT8m+9lRiAkmTkC9nInHV1On+s+YmQIb6qL+CYaNI4VUtoTvg2BxF0CYLjAsz0iZIBV/VomtUadE+exKbnz6Kz3lhUKxbLrF85lRsayLtl/m3Ol3pJ9fFHQwTQpCPhV6GXk1ceRiPjvnUF9/XyWu4nEJ5MYxoAfLseq6SIWHPe5thfoDvupwG4aLgnUITQ9epvQ55g0wxEdNLwmFES8QQj11CX5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8695
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f1a7ac5b-0b21-4a52-e9e2-08deab4d9741
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|7416014|1800799024|36860700016|35042699022|82310400026|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9URCdKnn051LSUnkl/bxXjrzew9Lnj0ydtyYtNig7p7ocjh02HzG/+Udp2Xg1hDhcxbG+2pyWsu4prq8ZZFK43s4CUt06EQgVPD9wRpjkggfo25x+jRVPhXsyTpLkDrMl0UIlvwhqUE025TGRtSfeiFXgzQDGetU72BjQRUxWbt7ZmSAG0nSr/cHAJExDjW+jnpk0RMCrhu+1pTO5QzdDuH1td4s+lvsswTzc+RiMFiwpkQiLiW71qasfH41xDTPDNwOzWvGKOQvG+FV4UYtHMMjY2hYPngkZ7X/TdqbAHBCD6tlKwsYsvytrLeG4K1VE5c7urrUj6av7ftIumATFWxTcu9tD6kqYwaKddrynS7IVeTl5ogfmXR6svAaArvh1wXRG6m/8Ep/tDzQ8ggZhcffgNMkKgYuUcDBZkns4FzFVhrVhva7ZHkZ1FrK/FOuzGtEpAauJBjXvNbiEeJ3ulSew2B4n1HoAX9kHS2vzdkHqQgXgWl4BOnsBJX8AILNqRbtzDefjL0ZPFy/St8VeVBAg98vYuozeGAx/zD4fvXuJ3hCzhkqmkHizlSkNP4gxV8G+XQqdxdfYPZaA02jqNBNeFFI//x/5ZcnsQeZR8gDuyW98I4jVV7miI4M2z/y1XI0aSWsCx3H+zHEZubP/dfeJdnvARSNnkNw5sBSFAy80MKbzBFsqR5pmPCH8o3kmLdHP+/USWXxYhu/w70SvMuRKzg0WXBUKj0JKBCGZHY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(7416014)(1800799024)(36860700016)(35042699022)(82310400026)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EQ0fLJJ/uZNKLyjcOzRpP6+Z5qkrjmxxUubpzFzn2/y2rwdYxd802SKi0xnhqQbbt3yKSRJKkrG5f7cXM78Z0M/fZRLFt+Q0ud4tSHhctY36R+u650gYa1zuSDEP0IB6TXSrgWnRfRbrq/lmMkYrOnGxaIzXv5bTa+XdlONaJ4A8W9FPn2YWzlKsxTz18KIbyjvjQRUZ3nMLDl0/H/bz5vZ+m/e1Pz7JLVgBSMT4BDFnUgP+zJinhgly6gWHuz//GNV7hU/1p71pNNQVehe6ShL1+h69olTOdXEDoJbmR8EiVY79xWIwtXASCd6+Gni26QDbW2nBlbECJB4g3phrqYNuX6hrspS2bbaUWfbmaXaHVCNt7g2cFZr5rY3li7aU4a8kLA9dW6TD5Elsz6C6ZpzILBw1U6P+dIlyNeeDUSDjT8xjMiZE4K7VASkihI1d
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 08:59:12.2206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa83fea5-4fe0-4c2a-68ce-08deab4dbe19
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8662
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F4481C0003
X-Rspam-User: 
X-Stat-Signature: ic9k9puknz1zwdknhq6uo1uc3fqjho5i
X-HE-Tag: 1778057965-775706
X-HE-Meta: U2FsdGVkX19eqTLYFpRUBLDJY0hOygpnk8zLYPVEhI1bWplkyiqoDcrwfYApHPGLRoiIAcrAJcknFC4mFPWDpwdhNDzQrMpk5hEugVG/Ejo3y5whH7URRDfGoks+e03byxk4SzI1fZ53okvGKHQt294SwS9gi4mwgMH8Ht+fUHqB1b0cp0ppoKhh9bPIbWiqvMWpYHqbFyTAsIo3OXmFcRg6JfpBHducR/skR2DfFlfmwrjSi0SHBMjwjL4PbInuCJflwCL8GHLtx2FH8Z2Fnyn49yAOuSxWK3u2d0CmgujwnaCJgkDZe1EASEH4CiIjZtNNhS9uSy3fse5zrGr8pYmsCdUcAWYv9o6p4v8qpSIByM6GgS2sQE9fM4LW7JYoavHB3MkRgAJihqZ31z420hiPWVUFqfMflqKZX1LNDFOXCrii7Bdc36nf7fcpC2IwbUXxLQhn7DZtZEFSq2BBcBkSGM2eR/iHqJsUXLWBwmxLv7dqwVEESgwK44Jky1Pue/swBWbFDJHqxuKGrosvcaxZ4oLCaK0BKa1nFUUzCSdQIUYgQyawVlnUqqyGFboTe3YZGOXn+ALY9Z8A6HbtMdl5GHpAjTj5pbUmP5T7f9NHFnNSR2OqbTbZrLGyPz7/TK2BsB29ZKGipmLQX/v3vJU8WzXhehSyZcn777rRxWJMfhBty/Q9/7Sl9HpP7JsxFbZ9vDX1kScWxZRZmwhWhC3ib06x0vNDOFCsrMJJz/T1d7KODt/Qu6Jx0TGJQ8/jjLiDkVJvNQpLyP7IL4R3BRXTpc8FH5TE+2zFyqHkwUXLZbRnB5vOBvEVTjf4R4yqVd0fwkrrPoP3JSoNcn6e5Iho8gDNi/GnYz+lsRyJ5E83r/B6ZfPO8bJO02rl0hezXqjfkBrnd37yIJVCD7Gp5PwtRlgB/d/ATyF/ezO6meeT3pIJzPWrCRB5ALfkObtgqK4vDZurNiyZo7fDLbw
 sFynZebm
 g4bSSaVfO8qOcuf1MVt1WR0gbK2S7gaV8eEc6fhgseuVNxcMPxX6Df7vUpZfHqgJ00QZMUB7sL+9Iq1cTGHv+fDX+07+0m2RqrF5l6LPii7aDL/T+4wlLqsNmumygp8XBQioVRfAIUec0S8qjR3G2eGTXg01miiXNroRn2MqRrkRuk/lCVMQqiQ0bTE0e0JfAb1tfio9gDafzBGIEk6lSwA53TSoHhhyuiy4vGDP2ZFv5DhelibiAwSwpEN7jC7Jnl4ZWkzkH4WsT1W48tRDVtr26AMviRjVNK2qE1XCMaUNNpQA+O3nYOs6iplSYHRgoG0eRKpWknYuQepevScBXU3cfXwdMc3sW8WPTtW/E0Iq2CDBJKkV+YfB+ZjLd6UFb6H8Qpmv9XTmNtISYKOwb+6mY3LRRu4M+sMiHdJGhKrAzuTIF5jc+tgMbIIWOBvG+0zAkxq5zlPX8bXRulmDF1dqRqq1p8gr+w3RH3MivL+JKC8WL0kkfzpdHg17P97Lo+hu/wf6e8CJOJGByz9qTt38spv7prS1fD6sUAtBzGZyhlLHUG4GlIbtt1HtXv+hF7SRqo3Ioa0mTkDMBGfZKEo3yE3ZpJVK46n0DkfddQLoXNlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert protection_keys test to use kselftest framework for reporting
> and tracking successful and failing runs.
> 
> Adjust dprintf0() printouts to use "#" in the beginning of the line for
> TAP compatibility.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. It correctly
converts the test output into KTAP format.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/pkey-helpers.h    |  6 +++--
>  tools/testing/selftests/mm/protection_keys.c | 26 +++++++++++---------
>  2 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> index 7c29f075e40b..ae010b075417 100644
> --- a/tools/testing/selftests/mm/pkey-helpers.h
> +++ b/tools/testing/selftests/mm/pkey-helpers.h
> @@ -71,10 +71,12 @@ static inline void sigsafe_printf(const char *format, ...)
>  extern void abort_hooks(void);
>  #define pkey_assert(condition) do {		\
>  	if (!(condition)) {			\
> -		dprintf0("assert() at %s::%d test_nr: %d iteration: %d\n", \
> +		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
>  				__FILE__, __LINE__,	\
>  				test_nr, iteration_nr);	\
> -		dprintf0("errno at assert: %d", errno);	\
> +		dprintf0("# errno at assert: %d\n", errno);	\
> +		ksft_test_result_fail("test %d (iteration %d)\n",	\
> +				      test_nr, iteration_nr);		\
>  		abort_hooks();			\
>  		exit(__LINE__);			\
>  	}					\
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index 80c6124e8378..d617b41dda6b 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -136,6 +136,7 @@ static void tracing_off(void)
>  
>  void abort_hooks(void)
>  {
> +	fflush(stdout);
>  	fprintf(stderr, "running %s()...\n", __func__);
>  	tracing_off();
>  #ifdef SLEEP_ON_ABORT
> @@ -370,8 +371,8 @@ static void signal_handler(int signum, siginfo_t *si, void *vucontext)
>  	if ((si->si_code == SEGV_MAPERR) ||
>  	    (si->si_code == SEGV_ACCERR) ||
>  	    (si->si_code == SEGV_BNDERR)) {
> -		printf("non-PK si_code, exiting...\n");
> -		exit(4);
> +		dprintf0("# non-PK si_code: %d, exiting...\n", si->si_code);
> +		exit(1);
>  	}
>  
>  	si_pkey_ptr = siginfo_get_pkey_ptr(si);
> @@ -719,7 +720,7 @@ static void setup_hugetlbfs(void)
>  	long hpagesz_mb;
>  
>  	if (geteuid() != 0) {
> -		fprintf(stderr, "WARNING: not run as root, can not do hugetlb test\n");
> +		ksft_print_msg("WARNING: not run as root, can not do hugetlb test\n");
>  		return;
>  	}
>  
> @@ -855,7 +856,7 @@ void expected_pkey_fault(int pkey)
>  
>  #define do_not_expect_pkey_fault(msg)	do {			\
>  	if (last_pkey_faults != pkey_faults)			\
> -		dprintf0("unexpected PKey fault: %s\n", msg);	\
> +		dprintf0("# unexpected PKey fault: %s\n", msg);	\
>  	pkey_assert(last_pkey_faults == pkey_faults);		\
>  } while (0)
>  
> @@ -1753,7 +1754,7 @@ static void run_tests_once(void)
>  		tracing_off();
>  		close_test_fds();
>  
> -		printf("test %s PASSED (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
> +		ksft_test_result_pass("test %s (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
>  		dprintf1("======================\n\n");
>  	}
>  	iteration_nr++;
> @@ -1773,27 +1774,30 @@ int main(void)
>  
>  	setup_handlers();
>  
> -	printf("has pkeys: %d\n", pkeys_supported);
> +	ksft_print_header();
>  
>  	if (!pkeys_supported) {
>  		int size = PAGE_SIZE;
>  		int *ptr;
>  
> -		printf("running PKEY tests for unsupported CPU/OS\n");
> +		ksft_set_plan(1);
> +		ksft_print_msg("running PKEY tests for unsupported CPU/OS\n");
>  
>  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
>  		assert(ptr != (void *)-1);
>  		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
> -		exit(0);
> +		ksft_test_result_pass("pkey on unsupported CPU/OS\n");
> +		ksft_finished();
>  	}
>  
> +	ksft_set_plan(ARRAY_SIZE(pkey_tests) * nr_iterations);
> +
>  	pkey_setup_shadow();
> -	printf("startup pkey_reg: %016llx\n", read_pkey_reg());
> +	ksft_print_msg("startup pkey_reg: %016llx\n", read_pkey_reg());
>  	setup_hugetlbfs();
>  
>  	while (nr_iterations-- > 0)
>  		run_tests_once();
>  
> -	printf("done (all tests OK)\n");
> -	return 0;
> +	ksft_finished();
>  }


