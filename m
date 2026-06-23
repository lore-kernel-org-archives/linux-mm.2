Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E113CCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C096B0092; Tue, 23 Jun 2026 07:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCA56B0093; Tue, 23 Jun 2026 07:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB5F6B0095; Tue, 23 Jun 2026 07:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA8C6B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:15:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C5F01C204E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:50 +0000 (UTC)
X-FDA: 84910922460.02.9FE9503
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021092.outbound.protection.outlook.com [40.107.130.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D792C0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=IPm75NVT;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782213347;
	b=jKWzWp7iAonq0/mcOkfSPRzW8DHL+GE93WNl9YlDIBZzNaCJM5d1Qqac4PUEjxGRbH719K
	8lAOr57vSHnielE1vKdbAVI+WHxvnYBHggXzB2ef/rIUGqQ4bBoSSkrJnq0fxFI7J+bSlG
	wzX3hxA7qHnjwkQCZy8u2pIFrPf2pPc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vdc0QsLVq28JvKfkSRqyzi8qzBdIB1LyvSAVuBUKuSg=;
	b=FYfH1JEuV1yl60YeY5RE/n+adIHewpo8isjtAiyy5tK1IT9Rk1MuQP+ZkUhFH/+2A3FeCM
	gweqdfWqsAobO/PvokBn2us0wJZ8LmICdNy0E9Lj/D2iko1pSqAuozD3dEVuMHXAeTSJ9H
	nEWgwOfat+hdZLoHD2ArlF7sqT0xENE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=IPm75NVT;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=acBubLu4QcQ8hcU/9FQWZVHBn2tUA2U6ql3Kgi4yQ73Psp06h3Aaq5SHHfjTpMJa8e9AV5N5pzR+D5KVSPvYMsN19zZ1u9TZzx6L+AmKzK4yAqW18cjzoOvHNpgbzflLBkHIqa2XzYqkxQaCB+5m4kS8o30M4xN0dKEbN0KwrOQ+FilVySGK6jNYWJlImTWcuK6RrZuLTDWbHnVEy/fmpyYatYGNfTSyetVt4+8HKtAyAC6rO+umqf6FZi3yl9hfCZrwJQITth+b0uDmMmCRXgPvbZJUyjNeGUACW5zDlY+4a9Kub25rU+s1XC5b8sBqmegBrGvgcwaBItAfE/O8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdc0QsLVq28JvKfkSRqyzi8qzBdIB1LyvSAVuBUKuSg=;
 b=KLCaWh+PhkmfGX8LPHCxe3CoEmVkSqVx8ilZb6Jm2IImwU+qTwNxUt+oycNG0R/fcPHfvuUKa7ytXKbndz2rC/3cf6tIFc0KqBIVjK41DRciFMUXVFJsBOW8f6YEgUpzywUE24fHi8HHwvcgZsyVO1LHsn4ntpb/krpVlG18ivwAvB7hNj6KyrmaigoDSNjcTKHZyxRxbCN0bBUML+4XsDkfJln4lgEWIqKJ++5K5rDAeKTj0N5kh+RNZ2w862uTRWvs3F/Bho22Sxs5pcME3bszNBQRIlLQQbAsfITGjmJWKFxnhbI3vS7SYq7eK49Bws16WDRhohGF2ZWBealoiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdc0QsLVq28JvKfkSRqyzi8qzBdIB1LyvSAVuBUKuSg=;
 b=IPm75NVTaRxY3UhFH3PsKZLLIbHhG6MNeep9bK3uj1Ip5J+AhcPSXzrFSEftcvbezftVzf644eXXT5pdFsJTgnLXwNpCEnyCmPRnshu710E79DeCrBdFuifPTjSDj6gebB7Ydv+TFAdH0KUv2Gsz3EdKxnzGcuYfuRTeowOJnjANay/L9sTyVVoG35G3kGZetkRpWwcZBW9BGRb2K2bHPYY7eUDgHaCzQJ2ESjbKz9q89pBT/0K9f4Rs/BZSBtJKjRmmD/CZLL69rmiID798baYyrVF3HGlArOPXeOO76K/BOYtwUjUqIuI6OPcTc4sU/WyuPXWise5NTL4x0L/zdg==
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AS2PR08MB9974.eurprd08.prod.outlook.com
 (2603:10a6:20b:643::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 11:15:43 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:15:43 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH 0/3] ovl: make cachestat() work
Date: Tue, 23 Jun 2026 13:14:47 +0200
Message-ID: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|AS2PR08MB9974:EE_
X-MS-Office365-Filtering-Correlation-Id: c1c5559a-7ccd-4bf3-e08d-08ded118c3ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|10070799003|366016|376014|7416014|52116014|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	DMCZ0mP1gen3TNwhrwndYeCD/+hmJmeA8n5e+aKSEDdnW78uMglDvlJGq3HAbgILhVWi304ON+eDy9u/HpoZH/sUiTydIL9VfPfRaNsC5ls9UCSfBkAlg3uZK6Ul1dFp04+senqVQczEES9K6sH1lZdDziTIXsDg2pSAz7VpxNwaeo/BfSI0NrbSyAbd2UkQT6fTuD28tWoYprg2xDmV8adEGy76rmYnNr8ASxdYHJ9ex1+IOqPnfq5QCHgyUMJUstVYF3iz9caXB8DnEBpDlVtEb6G2zeWfpzoAkPBl0i8gqdJPR2feyXgGD/ybkqpQaWAs3eg/uYCw+xjU5dj2LGNMGPx8vFJXEMsnuDvq/NmgTJUdeMqMy5h3wXAZFljbhc4ASutp0VZIEHRbLSgerM9NleNCbxJtDtJ/uzovXwcqs+LbevS2DQPEZ6JpplJ53xHRmxiK68fY9o/2HISBh2nOjtpFRkSGkKOrtT5EdGQCEkh0Uj3YeuzDnOudzNhVaIQIIpOSuQlMtdkM5sWk7QIMd/sjQJZT9ff142Mla4Oy8usXCrxDJ/gC9HLAZTiwVlqBZD3nnjF54Z/XDwrvIyXSTjSnG2OqCrtX00wTVpqw7g2v6h0CrKPB+Xbfk5ZHWAGfgvvzX8qNSoumtwspfKvd3w7XyxJ4VoE7qyiMLnE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(10070799003)(366016)(376014)(7416014)(52116014)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F/uPcyfTGxIzGjdBVmd1z5XywUBU591PhwTaQ2+dbU7HGh0z1wQH/fBjleBb?=
 =?us-ascii?Q?vCb9qm4HalrIc4lrNZ2EH0PMdeePpOfCSFRBqhUxFksj6M5V7La4mAU9OsTd?=
 =?us-ascii?Q?Q5kVORgp9GqawbpEgSQoQVI13o9ocHgheYruJIbaZvmYPhkXQGXjbGULNtwm?=
 =?us-ascii?Q?e/pSyAU+3+kgjH2iV4CD01U83IZyF+1imFVlequSAa63PypY6i1c0rPMvqJb?=
 =?us-ascii?Q?CEux2vndibpXtaByHutqacV7MIPh7CqDHQa6sXGGPNvA1W1I3x9A/S3E6j93?=
 =?us-ascii?Q?n0zYV6uYKms2PQJpNgPfDe3DzIQZO8Iagtz/FjT2HMqdeYdCPoNX9pRjJReD?=
 =?us-ascii?Q?qS66/n3gHpFfTq6WwbnHIInYcxwHxTkd2gIJZsr8G+btik+wEXgo+IVBLtcZ?=
 =?us-ascii?Q?AyWcGbiTv0JOBExrD91XMwNwIJbewdesG3nKO/pnoE8dqjO7kZO1S/q3Y9pA?=
 =?us-ascii?Q?VIDBSxk2PCM4f+sQWuxUDuHx7mHpgPfZW0kyRMGQMntPoeknMkeVmtMPCMI2?=
 =?us-ascii?Q?9aFQdUmUPQJ1LLmFeYVuvh05xQ34nRvcJTcR8zM3dBN79+KLkeHLGMoGZuRf?=
 =?us-ascii?Q?Xcfktczrh2vBCaQH3jBbeMBvaIFwUN5szorWLaZKkwE//TN21n7TpPdtUH71?=
 =?us-ascii?Q?jax+8nHpGcoCpHVlOJjSSTZuIyc4wx4bJ8/eqxeMf+5PjYEJM05gt9R5q/S6?=
 =?us-ascii?Q?lLufHlpjQ22w/Z7443BvlvlAmjO9G889XIVFuGx1rHcbDfTHs9K1WuyVMMI5?=
 =?us-ascii?Q?dwWNOFDsP7jiYdmOTIGCdRYqV3KpsQX2smo0/izvBbPGCTDEUqHVHcpabw49?=
 =?us-ascii?Q?+wjRuTKVVB38D2vpLAQuLgdqUdXqJqfvUDYn6whQ0p+K0Ot17BCLYvlllBU5?=
 =?us-ascii?Q?oJ36RH3v8L0tn5kWBAPW9ZgIhsVQP0PGD2dsgYIRIDiqMT2slDBb7175cd5E?=
 =?us-ascii?Q?GY+vbLtfMPnF6SANxu6IBZimZM1/b5/s6PSdgwDM4BYXH7J2e2DnAh8OhHMO?=
 =?us-ascii?Q?sBu/BRV3mSQ7MV6n01UmCL4CoMiMW/+HK2xjOczxob5vXpnKkkKG2+tLSte6?=
 =?us-ascii?Q?KfEozkRM10KSv1lAxyQCxxvDaOyqV2eV6gI3iCB5IKrX0KHeTcPL7Vr2aHn/?=
 =?us-ascii?Q?QZfcIcBU+nBcj6NUS8Nz9SnUzsWnreruIMBRzP+h8KlIx0UNkU/71qJeNQVJ?=
 =?us-ascii?Q?uq2n+SxErjx2T3z48uVzTsnTh9u6rw4ccJcYifGNAo01uBwYTAAugvCf9IEL?=
 =?us-ascii?Q?yFhiuH72v7vQbt9a7bj12g6SVDpi3cUBjIFDGfqID0pMOEOdHT+i0LnhTpIY?=
 =?us-ascii?Q?Df9DTVsGG6MwBocz7R914MJDChvNBM2tYgwiM4Y2uGsINjgufXLB+UvrdOvL?=
 =?us-ascii?Q?dPIn5M4EnDfizrnZ2aA4JAYRdbSYzuFpbNM04BOmj8BsIJu9uwW17UpjcxBJ?=
 =?us-ascii?Q?2/EANNvV04K/cDD4izDWUj1qv5m0GVe1aypRKsxQiDwBBnJkFDOzinqvmrdm?=
 =?us-ascii?Q?9bSfxPTmsdvORFo3ds02XIO4e/C7e+MIKkK6FDHugpYqvRms+Zs1lBWSGMmM?=
 =?us-ascii?Q?/P6JfKxcTWloMxrniQvuotGPo+YejGId2mm9wt+LaCZ17z2253tb2p/y/2jg?=
 =?us-ascii?Q?wyldl1eJUWL830mHgHk2IW0PYyK1ka4wYptFPtahi2b1zU9pGABQ38O5DaB+?=
 =?us-ascii?Q?S4Doe1/2BG2eW8DJyAiEVITzH1ZAdJoRcPRHKr9dJHkdnXlfwMpci+4yIbHH?=
 =?us-ascii?Q?aXnv+ZyS4JlL++oRjyIzHDMn1tlfxMWW7ug3CBFmSsUJJhJmzWLvlRhqLphy?=
X-MS-Exchange-AntiSpam-MessageData-1: +aY7WzR6v17xeWR0kbzhNdalTWW5kdSZUTc=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c5559a-7ccd-4bf3-e08d-08ded118c3ed
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:15:43.2405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXG2CiqrI95srvXHNFzvgSKY7J4GdFu9lFbM2ZfeBMHXGeXkWfHfCa9BUjqABg+7bxypcZu/Pm9wJoEtAvL1xZ50KjvP3vNnIGwrlyOq6ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D792C0005
X-Rspam-User: 
X-Stat-Signature: 5gafaxo4bokmn8a8pxhu73hb93xq67jy
X-HE-Tag: 1782213347-787310
X-HE-Meta: U2FsdGVkX192ffKoEe082J7aaO9R4EP1cE/982dRROF1cgoxqmba/iVZszCz0Tq2RUypBh81sA+3WVNYS8L2zRLgVTkSzgtTUbefP0ZcXF4uP1hFSaTOL6VGdHQ2EPEwH90RYTbhtDXKcQx7qkV6LWoZVaECj+lRZxjg7oJWYMhsjKd9SvEkBbc0kyP/EcwufiL+SAlBrQpUWN1ZZqZYEBbQZ7TDluZMlGDc7IpifS6RdlWDPA9k9Q+uvpoq9Vai+k9LWakkkAPF22obVODSgy8DRzudtjoyuJx1Oed6CYPxM9KgoxVkr+9AsmW2Vd3adhhiZHGNuJeWucO8OdI1VMrwCfKbtQdWVC7Yhr0gW/PIw0gMBNjGAxVN2o69SQmgeXo3yLMRN2DPOoVNvA5efK50vKkP6xvbYSiUi+SflYlStZ7CXN5odV6bUQLWIxZ5DqG9HlC1PnXy9rM/PTqrBP3+xL/5yFWRrGPqipr5+XAjwaPDHLZX3yHXRZrAYfKOoO16kqSNcxWBdODurS20szonHoEspI86gdntZdguUrk7Vv0eiDCl2IJoxNpNnymrXoaln8tK5ebS+mR0fwRAs94T4jR3dejd6vX+gLXHWZ0ReS/ZFDd7R7AzxPontIfwXr08NXhLdLmT/cOutRJKc2Ks8Ko/U0iRHweiY+tlwloYjzYA6QS/1OZC0KSFaDuhog3KkQrdHJgtsK3S4f5zde5vDS4geR/z81AxY1omlnl6C9ylMpdldQQaFQ+DRm6Bpxu8K+xrKh2bXeb28YKbV7DiWA2IAxWmD40KOqEF45BeTgNZRpLBmALiT2yarC+WNh7V0WwWrlxFMukt3/wXvbA/jV3+EgB6lbKQZJAfVfTxQpTLE2wEGRiHsz70DlCC/LlcDk/fUYvfpzlO75eSsQw0M+DCHXpsttKQAHFUA9fFxD3B5ykyepAvU5ByXgPRHCZMMKyC2WDsGpueJaj
 J+IRcyV9
 B8Q+9MuO7Bii8eG8Ee2pNbJgT4xhK6dcnDNx+cI2NRiTwhWEn9F9VN7SE9Pneza8UqfBO9snqbtKb5LG0xn3xEOmDO+jPtNl13zRchankDXePdB/H/q1duml2q3JnB/bx77EttUGqR14cK4xKS8iQa7Rr5gpFPKE7HiezHxhcg0uadE7tYh387M0qaO/GEY8/A+MKbfhpGctZ38FbbdQxmYpfo9n2VYOq8/n/PSHyWFOif3xawyAlNILp2oqmJuoYDWwXrb1MoyxkvY3FuBqTKk8eFdU3YI/H0qaWEDPdlqw4FyzB9fZZD0oCaFAt8QzdQSJFbFZrfDK7Dda6lSVmWQcvphxgHR/+ohbpeuG3QYgWMnsSbV6ari2P8y5/CJ+RMF6NbA97B3ze/KuG3c9hv1WWcVZCVosITjkYNEh9GNqlNBeisiQw4rot3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We were using cachestat() for our internal Virtuozzo cache related tests
and I saw that test behaves wrong on overlayfs, syscall returns all
zeroes instead of any meaningful cache statistics there. Let's fix it
similar to what was done for fadvise().

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (3):
  fs, mm: add ->cachestat() file operation
  ovl: support cachestat() syscall on overlayfs files
  selftests/cachestat: add an overlayfs test case

 fs/overlayfs/file.c                           | 18 +++++
 include/linux/fs.h                            | 10 +++
 mm/filemap.c                                  | 43 +++++++++--
 .../selftests/cachestat/test_cachestat.c      | 75 ++++++++++++++++++-
 4 files changed, 137 insertions(+), 9 deletions(-)

-- 
2.54.0


