Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC88EE57EC
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 08:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E92B6B0088; Wed, 31 Dec 2025 03:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397DD6B0089; Wed, 31 Dec 2025 03:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224976B008A; Wed, 31 Dec 2025 03:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB336B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:50:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3840413B91B
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 08:50:30 +0000 (UTC)
X-FDA: 84279145020.08.998BCF2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id B227680007
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 08:50:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XdjhnzBz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LJP+H1dO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767171026; a=rsa-sha256;
	cv=pass;
	b=1MqoOdvACC7oAEWaZ9bNpqSCTYMRZXWCE3lqo7Ufyg534Mnta45cTd+Dd5IQqsSlWEvjNe
	aIbi3izabIluqlzIgeoq0qPzHhI/KHOHpk8Mun/wDUdfWiNRTVwNFfngh3gAVSfGkGgyjn
	GK8WJB2b5A/GoHih6fb5kyaOPQOBD+0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XdjhnzBz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LJP+H1dO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767171026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeIhAqdkoFrTeDOw5xcLajVtkeq7qyaTuiRiQ5e88fo=;
	b=OcJUGJyg3eI958KLbNcWcR1UW2R6Q+QeihhFEa2QveEsOjz1cDX9IpQCka7sLnlNST9tOx
	h2REXROA1pnzYhAW8DEFCX1z9YBNFHSPpMEaoFxMQ80TXDHVbfJyUq8dlyXozKewnCmNoA
	+jPrpaKDQRteKjPLE5H97RtdyIJ//OE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV4Xvdp1605921;
	Wed, 31 Dec 2025 08:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GeIhAqdkoFrTeDOw5x
	cLajVtkeq7qyaTuiRiQ5e88fo=; b=XdjhnzBzi4kVJ1QUbboiD2ctAnWT/P6BGC
	eUYJ3QJlQwIlObUDujrEg4hH+ZpWlk4jTerI49f+tLrTUm90gmhBaD0Xvs8JW+y3
	njCFHe4v+xxo3W/mOIPW3+hcCavyTnBMYTRi0Qfnernt4D+Y8/BblM8etu40Yi/G
	RC1rhGjR4PzahGbgb4o+NMkGSLIWkaEQLigi/v+1na31btiCRFE/UZWJlkYS8rYG
	bFF3TgHdNN7yNyXo4bRMZuyOhWAjlF0GeF9YlCd5YOwcQC/4C/YF8unLZtC2tJg3
	Bo9TQO0Fc13b1z8P7BFzOsGYAeVXTO1A7N/xuNCRvQmfq8MpOLjQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba7b5kef2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Dec 2025 08:50:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BV7fsYC022898;
	Wed, 31 Dec 2025 08:50:19 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010019.outbound.protection.outlook.com [52.101.46.19])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w8f61h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Dec 2025 08:50:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFJ+Wj4Xf+xV4dgve/dXzvgkspbtSIh9WDCpI7hZUVwHjqrDjbb76CwQgASnPR62CbLHuLEeqbdIJlytdY7Q+8xT8IOojNBE5iQr+/hT8V3TwzxZ0+Q2Wsu1L0t3Lo+vZrkCVYPG9mxozm6PFnvS4tNhVK2D6KtZcZKvIIkT4CtuKiPEJ2vE/Qjk9EdH8ZSnb/K7btX5Ck1gRLmHMZg0Ts4zgUq8HMDrBQJ6AiiKfFdRC9grOo6WsZForIZ3uN9oJ4aEIXgkna3IyoRQbPo0X++teKXrAb3xvGh0OiO5wzMAc4X7IOX4oObDHnzgLl2GFAyP5OfnYGXyxB2sTEawzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeIhAqdkoFrTeDOw5xcLajVtkeq7qyaTuiRiQ5e88fo=;
 b=aM7fzBGpqQuoV874NbzRFWE2RFQs1s2H1TWzQNmgAkhIoIZ+VUXnPEdR1aDSzL2WdsLRZNfwMDVcS4ykFJZ179mhK95r4QFC2aviU119H6lnoj/HNA7WOhIV79s2HUDzFewklUW4h537TqdB6+6GbW4TRXCJ94b5HaAainIfCIpIv+3Wq4AYhj8rigsFLdMf2cGJuYTclNXKgZYk09FCnDE+WPcrikr7EXSJhnwA9E9cc66NuQe982c8axVJRMZRAQt5YyMNgeCT/EiT/bvYVvzDDlvSDdgjlfI1siWQG1LJqqis9rjQZvBrv7LSGw/SNzN/QIYXhU3Ecnog9eXrIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeIhAqdkoFrTeDOw5xcLajVtkeq7qyaTuiRiQ5e88fo=;
 b=LJP+H1dOx9MBhmJnEHKrTpBqM4sAt4GDIvmlRhmHj5ffiZAHDh8lhy+SNY+GjEBbk602y3TY8ElTlAwlceK1TN2hHc9JypnJ9V/4z36c7S4vouMT2jLA9bpL9KKraed7P6chSTeCgcLm7oOhh49lBWo1mdz4/xCOUZ4DdiWz6rQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7529.namprd10.prod.outlook.com (2603:10b6:610:154::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 08:50:15 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9456.013; Wed, 31 Dec 2025
 08:50:14 +0000
Date: Wed, 31 Dec 2025 17:50:06 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+5272541ccbbb14e2ec30@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, riel@surriel.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in
 folio_remove_rmap_ptes
Message-ID: <aVTjvi6FCp1IzQME@hyeyoo>
References: <694e3dc6.050a0220.35954c.0066.GAE@google.com>
 <aU5dA6qq-h-0XszI@hyeyoo>
 <aU-IVkmsD1IN2joN@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aU-IVkmsD1IN2joN@hyeyoo>
X-ClientProxiedBy: SE2P216CA0082.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 23e0e407-4689-4860-2251-08de48499d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Lv/Odx7sfsWTyTWLM8DzYD30hmXWSj2556BYsP8AYHruyK8nOYK4PeaDIyK?=
 =?us-ascii?Q?vEXC9e5HTZ/K9/jkZ28UJdEwq6IH7a7alo0+y9jmvirZC75q5O7B2GEiawGT?=
 =?us-ascii?Q?6cx6G5DtWtx7mLaNX11L8165RkpcyjAheLiOy1pzpf3071UORgyrTvqo1EG0?=
 =?us-ascii?Q?E2MnIX1OTlf3mAPW4qgH/yEbxpw0DVoexVhXLoDGL34T8kR9ctMv0b0fhN2C?=
 =?us-ascii?Q?u+HmUGcuN4XEZyIlnIMvienyenFj9EtF6+Ok354w+hx5rxoLek7Mfe7oHAoe?=
 =?us-ascii?Q?Y/Th6zPyYuVF0YONPR8EYAbnAYFaUlHWK48Pr57pALC67GWINKDuL3LfrsL2?=
 =?us-ascii?Q?m5bO7uVuxvzm3P+pIDEH2rdN3FesXsWq/qJQF7nKyQRHtCPgezE80EaRGBXz?=
 =?us-ascii?Q?zb53IsWI/WPvltrcVNjReaJ3ndf/nBCcEE5krT4P0ZaJ4ZBx4CdE7KbUKyon?=
 =?us-ascii?Q?JpaXO/iPpXP8RpRo7cOgTHaw6DrffvgwQR15+Ynuk5muUqK4vY/CFL87doNa?=
 =?us-ascii?Q?ZSALB+fKiZe7fyggu6b7W1AiA04WETqc9uszNiPNwJX8Kpy9zphPNbHZoOPh?=
 =?us-ascii?Q?T69CtNsHbyjsWaPY3uO3bnNG2bMepSxr2/Sx3pC9UGgtTB27EBTvcTzRLdtO?=
 =?us-ascii?Q?QrY3bzqWvaUI6nrKOhdj9XeYs3OHcxKpyNWn/Rw1e++jhbudTnfLVwUeK23E?=
 =?us-ascii?Q?xSsXkL9ICH4odA1OMmcPAbzsZ2q50wWJEd7+O08t3WF2X8HpWmB1pRwqoq4O?=
 =?us-ascii?Q?7XdHLeh7AJXt+GLSkiJ2byyOfGN/xEDhwAJYBJpbUYyKHx7ZMh74VFobEcKn?=
 =?us-ascii?Q?i5VUPJ6kO7hYMJ7uxEcXCeNh8DGkQHoqJElHgFe66OK5Vw1aaYNa6tIBc+7t?=
 =?us-ascii?Q?xZuP7rGM9czXTyMIjsU4zq0KOUZTv4QNDQJ/Ng9/q740qkk0MHCDXVEmVQLV?=
 =?us-ascii?Q?GMJ+Ejb7k+ybZSiM/qku3U+S+ehGqIDPFfYV3uCmVpoBPUTrbDDnEKl43sO1?=
 =?us-ascii?Q?m+TXYNOj/Oa+zPle1/VUQaaoYmMCV16gtcCZsv8lWDNP5SPpUv8xqwZs3UXM?=
 =?us-ascii?Q?n9ToPCnUdtIli+7oAmtR3KO0rAiH82vgd+HwaD+tbatu2eNPR49lwEFOBIsV?=
 =?us-ascii?Q?LzNAnXXqBAOGpjqk97V43PfGMjGgWveRNBQAp7/G2dpO9BWQ5R9BvV0NbCG9?=
 =?us-ascii?Q?vZyS1zlCXDNRTb9cKytl2R8qqkFpafw4xn2SeSh69FjBJ7SS1t+MprdNli9y?=
 =?us-ascii?Q?IifWpK1uxEBLGK2k/k2B3nvlCBJvnrUfPj63n7oPvOrgRsfSgl3Kc4u8znab?=
 =?us-ascii?Q?U1NEMVsp39Yuh7sSP6OlV/kabBbM/lNplodC4eAGU7W/W0da/iyocnRBRQQe?=
 =?us-ascii?Q?ohaGI7xDN6/7xZ4UxfqDu3duxBdbfdnTF+rJ/nwjSh7K+8vc6qmb5IVWpm3z?=
 =?us-ascii?Q?yEtaED+mH3UFxSYzoifPklrNuQSlyiKH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zp098RxAdXTpILcHI3Dj0bTlO+ZNXvq1Lq7lVy7elOPNiOK++gWkYcqWXCwq?=
 =?us-ascii?Q?1+GvKmlbEKFkmPJ2445+/m5xpKr/aKh6y+32hAx/cOTDCPeuZ4gvcOVthRUi?=
 =?us-ascii?Q?RjBfNtwIKqx7+lwXBHh7sgfOIY6px1uKUCfI7n4NSo4Y8FwT5MYXE2CZXk8G?=
 =?us-ascii?Q?itiFiUkYvD0F/ISemYtCcTtzANSnHJFWw5wecqgohqO2YyqucIctHnZqRiSu?=
 =?us-ascii?Q?kd1MPyI+Lg9pN2EFkUC9FMTzrmPFybdTr3yjLmFb+6QF+TFam8vUgdeqa8sC?=
 =?us-ascii?Q?0BjxjHX9PP00LR4EOaA2YPvEVJ0E7FsXJvgYp/YYQJNXDiFBsB1AfqVeWQK6?=
 =?us-ascii?Q?+vUiqG5mNbgOdEp1F2PupyE1ZR7/WCHkqvtsxLjUXX6DZ+QVVMSsT1F7jhiJ?=
 =?us-ascii?Q?3AbgJy/fNWFvVlybn0io6OhFH1rxI4DJ1kJ22Dj+o2h2b6YwTvPPM2kOmVhY?=
 =?us-ascii?Q?WniUvy39m9TMt2lrCK1IPZ1ECIdaJiB3LYCjwXinJiHoH7iKktvwGw547Ydp?=
 =?us-ascii?Q?R1Zt4pGJ6HQKhTWutGs6T2gNmIwyt81Tsqqmuhy006K9uqAjgSSOP58Ipaij?=
 =?us-ascii?Q?3GYMZRJ1HEab5wV036ZbMr2YoGychySxgZj9TpTyACbzRVjBE3Zag6I47a2y?=
 =?us-ascii?Q?2VPnMqcqAdCDpOzhkIr7v28JqtvaaQtR18REXQfBtOUmgfBliWwadvan+4w1?=
 =?us-ascii?Q?ySZLK9T+xm0TfdeX1k4nyGPBooI3Bud8VWekOaN1qjOd8hLxvR1a0n58dYiw?=
 =?us-ascii?Q?lMHuSPkaGJe8o3zfuw5CsIz8nqnC0GJ147JoEN2zBKIntz8JGv7TrpwiP4qX?=
 =?us-ascii?Q?65CrpHXX/fOXHoEryYIk9ortDMDDX+hiAi4X+1Ygj0NfQYUeRgEdXgljVB+z?=
 =?us-ascii?Q?t82EOTGrpaAX6LVLcor5rahpytk1KnuWCIcr/uh5A7qK9cBp2y5sKOCCuSZ2?=
 =?us-ascii?Q?qO3X7l+JIH2hq68eWJVni0D/7l3b7MGnRjlEGLF68xqLjapCAxSGWN0qxjtA?=
 =?us-ascii?Q?nJcPVpExBtLjLsjTw6d0KLbWL2BzN2sHlYv6vJHkj0T/z4LRaWotI7ElotY6?=
 =?us-ascii?Q?7fKUozWX+2jcabAUNYKkmlJ8if+6J2P6j/LiQb4Gs9rw63GukCqn685rkgMF?=
 =?us-ascii?Q?A93ZCZzqwlA0j1StJvbcQwhE8VJQXGFzhPNEk/BCuPg4GuJzFbpavhMpyk36?=
 =?us-ascii?Q?FCSsnWr0yEiPXP1U3ceJiDjBDSrMCgqR5Q/7zXpY9TpqzYBW209emMdYcxtc?=
 =?us-ascii?Q?q/KlWg7ghopzyO9VDo3fvNKiBOZzKT3F6HewMd5wj0FbUkVjs1rw1KLQ3SNo?=
 =?us-ascii?Q?oBQTm4AtBRTxqMAtz3M8e6BQA5eOSFJ5lol1W14n59VF3snuaQp4ic188LAi?=
 =?us-ascii?Q?XYJICL1uWCU7hOMzGpAakh7m4S6nVNIfTKmd+VgVgPA9ufbWCS7My7J/2gDl?=
 =?us-ascii?Q?M1OaleMxVtVg9pLXymgn3clGYG0p2XBPe6dYArQME5rUYvCoOR43GueVTUcd?=
 =?us-ascii?Q?DQ2y3/4czuotHl40PemONnNVoI5PkoctO3QGsX8ZVAfZOXvPdlM4jO0Xp68/?=
 =?us-ascii?Q?K5aenVAR83djGokUv5pFvpVvDyus6Sdil9J7/TTx3IBr+kUqswDaKIxz7p4i?=
 =?us-ascii?Q?17lpl+30bKMiX/8137xYeWzdcJsa9IeEWJLwS/ClLDKJf5AUcH4+QIkCSwM1?=
 =?us-ascii?Q?MqmDcnv/6BOVqGZABTFbFCtv3ENh8Tmgb2aDl+BWoefLwd1suY2LqlLjqdad?=
 =?us-ascii?Q?mruYnUzLnw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SqGjd0WzMxk8Wy5US8/YFbDWUC4PJ61VLqXmS3sLvlUxTfM9ZGW276PpzU+lGqGA8abQ2SYs0PMJ86f+ms0m224Ui89gsDEGoGZy7Dq7TYjyS47MZVqcFbHBZg9OnOugQGhq2ANbPh0xJMObALrvj9tEZrnvy8Fg8xlpLA0PDlX+jHjzm6iqR9NwW1O96QLek54x1ibVFxX666f/u7iujIxj927Rq0jgvkfzd/6QhLk+1UDJtq5tB9cm4M3Dferm6jN+l9uRF96AFuUOLBJATgxQYWtsaSLweEhuyn9eYpNfSmCNebdyomgA2LQT1WzDpk/A4MrDcUgtLzaYBqk6gbT8L1JdRgF5ckcWsHub381tkO53VyotG7duYMeXubqL/THLHyZI01VhYkbwzRnqsbygrOBQCcThsfpztIUQZ89/HMkutC5InoT/mPXbHYYy7TKY7TYNFYvXF0BMX0DFYs5ok3Bkij16oebTRMrG/YhKGU/dioSapZjU9C53+mV5XHj8Co5fUI3xqrfLVqJhaZ8iIjDdferI24pcJJGHtpFQnfdvw6JOZMESkQ6qAoXjolohTZFG9K0fSPstCdGfccLougKlX6x3xhj1Sb4HRCs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e0e407-4689-4860-2251-08de48499d6b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 08:50:14.7098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LbUGxGoGVe+0k3TWyus8Hjm8Dm3HzFbmAxlcsVIQReWgFlwpeiO/7J39kn4Idxnf2RONFetBhY7z7Y6cKj0I9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7529
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=894 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512310075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDA3NCBTYWx0ZWRfX6ACzdjmQ5YSw
 Sfgz6q2ZuME7pP6mzrkdeVPm53WhYATYZdfEunp3d1EJrXRmKKDle4s6SmLdb1uRq3uWlIhHY2C
 Ot+KJ06d7NuMaK74jwaC21jUfaf66ha0abFxH4E0wzDhq/TlfBSxJ1OLAdJqxPXKh0p3D1b8ogh
 pOUa/2S9ANPRjsBj5jLkTbd1Bzq1gwoc7Iv1SLqoD256C1hjcgKY0UZ1ZEf0Es/IcAW9QiP7BYd
 dozhKz79lpoWFwZAf+cTdHC6Nr1d0naiDvv3UkVrd/PE64BV1MGHqf5l9CGDFuVzpBOSUlr95bZ
 nKS8psC2I9YhOsrNt4Bz6a3UNDTs4F4ckr/vybGebzL19Ep8YF528sv7hZxNP2ROmS58X7nNTm+
 kPe408BsfucdqrgpJL9Uu00ZwFipEoZqfQ0JCKHvjo0Yd4EX7CvTXudrPQb7al5HPf2lCcm0tra
 7954ym6tfhf4Zv1a0KA==
X-Proofpoint-GUID: XzCZvrNqH4QWZSrK6Y5LMTu2qhi9MFYM
X-Authority-Analysis: v=2.4 cv=ccjfb3DM c=1 sm=1 tr=0 ts=6954e3cc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=q1JfISnEWjXn2xUAv_EA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: XzCZvrNqH4QWZSrK6Y5LMTu2qhi9MFYM
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B227680007
X-Stat-Signature: zz3fsb4b568f3g6ynrh36sggdr13ehj4
X-Rspam-User: 
X-HE-Tag: 1767171026-337225
X-HE-Meta: U2FsdGVkX19OwQUo8woXclJ2Xl9YPkl26ZdsaAjgQPmxSB4DsPYTGZaFwe0vwwPLTnIVC1pkT6MvFS0njCx6VJvUIAczz/omrWFNUsYndmdrbrpW+EJ0qlXRwkKNyQYpZnwn+Mlkgx1BqeaAqXP3pcYt9giWS1x44ew+t6iRX6f6O0PWwpTdlmOGM575Mblq8zoYvaXyLNwxHgJStKiyftoUmtJrQOdoX0sN8z4tnWFmGfdlmmwBVwZSYjekxLfYLRX/7h5jXBuB7h51P4rGsGRXnGpKNIVn5m678Vb9HtSV9TLmYUY9SMHsJsThbeTaw29WBIiXoNeXdERWJ5FR0gmPaBwLsAZmPYeuKttF7Zf5cPCUPa3AB1dtO7yhFGMe/3QrZnW6FfUM4ns46R6JL69zSmJHeM5LfR1AEtduArVjPBo/ixGV7hUsVtGmiTw9eiTeDkc71C4Ew6e1gPYRNuP7V7rxvVx88DurSX1gMAz0XRNZ+gSTl5/O2OxDMwnqWRDh4ymIgvEemTMTwXF6IgxxjWzvhuil3mhmwzmy8qGjC8sdQZYLrIAAJRfRX18I2+zsigZovZhry9pEvvyNOAk0SMQl/I9TLXp8c+kKtbo8fTgfFqVnr0D/l5qVlCULM0BF8dIyjGEOoNmBPWsyuxoUIeeIlxMcZ1jEjJNntOD25pNtAVGcbXTvl/dkDYlynOxVPo1bPCAL0byoVtJxN0aGPe4X50kEJJ2gGtbpnXjpFOAYwRH7Zj8aDJRDrp7pnL9hULDaN8u1jJZqhO0dpbY4FJ8HAQ2ZxwieXYJF2TWt+sMM4x+NMOgVQ6J+TIHH+wzuXk2HEWcT5/0vOxXwzvTiW2OOc7NRINBG0QPm//NFvVNBvWZrzjLcfNEPWhqHuW9NefrDCmqFs9XiAQFT3St/14KCgisxMCVuVjXpeiNXoEo8cQwDm5phnlNgprBQhsU5epqyfguPB7ge+VC
 WZsHz7EW
 zzIaJnlYHd6zitXuO9XMfDa3sMWPI4fTIQaxzRUMrhWLc3n0cO6FALqjen8nf1ZADYj1iYPTj0gBU1XybsWTcwcFZltljWg1Kxp0ARf+Xt5sinGA+OOLtF1WYvD8f8z4mKtZv2VHDGfhSoeh338ZCrp7b95FmCIGmh+7I34aULCO9j99yMt4+5pweqcWn0eTkY0B5m7XkdFZWtLnPxURr+cKj/d8XB376TtlUbg7u2xK+/zae1xNSQO3fPX1jGpVCyn+nFTeq56cXTGLFsoHYspFCfQvZqETyD989uvhSpim2LJCenQwMDmA2TLhqJEAKIzDr7nnTG4SCjRVLQyikH1fSdvj9DDc7gnyVsqFzB90KdhYTHLwRRc9t7SbjfHiZkbnXLqg2XLQPEpOVNIQrwLD1rPpq58PwWVzKQh+cLC3ObRoF/oF3b/8ftsld7a/tZ9KMh5D3gIs1Iitozskp+AedvoOV+cxoFBSJuGt2oClk6CvVCTIhgWCzXcys1txUdiFys1/mrjtnUm3zFhIKopUlLzVeJl1efKpc17FO8yQBHWnuNiM1p1gisxlwatGjCCJPt2K0cVDkf2nwTa7T8u+f1vR2ZKzJ+sB6AIE9aGmHwsd21ufKJBTn+QUWmmtza7DAK9RTxdOyeSbzJWhUiF9zjD0yUEbqmig3SzfV9Dxl4ziTMbtfvbXkrcDfBz4wOI/gm1MNKROCNyx714o8uaH0ahSEHgBFtVgZw7Lu8gQNC3gdbb3esIM5yy2hciklxWF/zqOu4+OlMzk+FJ5d7MZuJMDwckcA+nmZBpUpq7cwqxIv24YzBY3MQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 27, 2025 at 04:18:46PM +0900, Harry Yoo wrote:
> On Fri, Dec 26, 2025 at 07:01:39PM +0900, Harry Yoo wrote:
> > On Thu, Dec 25, 2025 at 11:48:22PM -0800, syzbot wrote:
> > > Last potentially related work creation:
> > >  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
> > >  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
> > >  slab_free_hook mm/slub.c:2501 [inline]
> > >  slab_free mm/slub.c:6670 [inline]
> > >  kmem_cache_free+0x15e/0x770 mm/slub.c:6781
> > >  anon_vma_free mm/rmap.c:136 [inline]
> > >  __put_anon_vma+0x114/0x3a0 mm/rmap.c:2780
> > >  put_anon_vma include/linux/rmap.h:117 [inline]
> > >  unlink_anon_vmas+0x58a/0x820 mm/rmap.c:443
> > >  dontunmap_complete mm/mremap.c:1265 [inline]
> > 
> > And then (potentially) it was freed due to MREMAP_DONTUNMAP.
> > If it's correct, now we know when the refcount has been dropped to zero!
> > 
> > In dontunmap_complete():
> > > if (new_vma != vrm_vma && start == old_start && end == old_end)
> > >        unlink_anon_vmas(vrm->vma)
> > 
> > It calls unlink_anon_vmas() on the old VMA if the new range is not
> > merged into the old VMA.
> > 
> > Hmm I'm having difficult time understanding how the commit 1583aa278f5
> > ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
> > is supposed to work when the new range is merged into an existing
> > VMA (that is not the old VMA itself).
> > 
> > The merge will succeed only if the other VMA doesn't have anon_vma
> > or it has the same anon_vma... which means we're reusing anon_vma
> > of the old vma, but we're calling put_anon_vma() on it?
> 
> Hmm, no. I tried to write a repro but it didn't work because we free
> an anon_vma only when its root rb node is empty.
> 
> Looks like I'm still missing something; How can it be empty
> when it's actually in use?

What prevents an anon_vma from being reused after the kernel releases
the rmap lock and before it calls put_anon_vma() in unlink_anon_vmas()?

Something like:

T1                                  T2

mremap(MREMAP_DONTUNMAP)
-> dontunmap_complete()
  -> unlink_anon_vmas()                 
     -> lock_anon_vma_root()
     -> remove anon_vmas from
        the chain their rbtrees
	are not empty
     -> unlock_anon_vma_root()
                                  mremap()
				    -> the new range is merged to
				       a vma with an anon_vma
				    -> reuses the anon_vma
     -> call put_anon_vma() on
        anon_vmas in the chain
	(with empty rbtree)

	Oops! it's still in use
	(due to reuse in T2)
	but the kernel called
	put_anon_vma() on it

                                  exit()
				    -> unmaps the all VMAs and sees
				       anon_vma with refcount == 0

-- 
Cheers,
Harry / Hyeonggon

