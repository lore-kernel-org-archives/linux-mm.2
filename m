Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C49CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D8E9000C6; Wed, 13 Aug 2025 14:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D2E900088; Wed, 13 Aug 2025 14:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786CD9000C6; Wed, 13 Aug 2025 14:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEB4900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:48:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCC861403D6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:48:58 +0000 (UTC)
X-FDA: 83772621156.25.D1548C2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 03DD4180015
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:48:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=igT06t17;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L0jc0e2c;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755110935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WluDeZaciNF/fUPrjlth/4tB16xKEKLbywLeJCe0pjc=;
	b=pr2BqtGHGLMospcqhz8WfEjQDqHyHHNeGRYYEugXPYbjfd4ZZCI09AHGNPGjzwHqDFpqpg
	1m6Bz+YiUKoExtVRoW8XtimDrzQpFJRSdYw9l9rRPumrUfZ6BRCvLL0LOnJImzMslKbOiY
	fW3IQC5i6fzYDanKzjVnMCz52Uj18Ow=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=igT06t17;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L0jc0e2c;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755110935; a=rsa-sha256;
	cv=pass;
	b=lKC0RYAmBRhPd6qR5vReWTrAC4qWBZv4rrSvQP1sQAGECL68X651A65eKp/iZ7Lvst34Yi
	wFr0TqO0tz8N64A7lPOG4foWfk6O1z1UucjO3itbr0j/qcPcSGtJRhv+UDYsa5mFHJIpdh
	V6MQm2vaGTzsZAEpjRp43k3fZJZPwx0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DINDW3014488;
	Wed, 13 Aug 2025 18:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WluDeZaciNF/fUPrjl
	th/4tB16xKEKLbywLeJCe0pjc=; b=igT06t17EmVnFi8b2QOJzjV3lk/3O6+YnE
	od1jY1pIU9X8a+I4Y2d+8w30nrcIdKgJ5xqEC4xFPttNn8HXCbp6+Ttd1nN9gJwH
	OWcPbSvki9Eelz940JTljytsca4LD9XKww6X2TKU3PijvJjDVwWxE0jAw0fZv3YT
	wTtU/LQ1tXpzO9F0xLVPpuVeHYABv9BF40RZOJxU7EfVb0u+wKjrvoG6RgfeWDR+
	yscZ+tlZaqHQECR3W0GkMFJEizr7LCh1erOiw1h8T4sS4KMIC3QziaE2jRsejP2m
	MImD+k8YsMnBZtZJdJsfVwnJMvnpdGvCadXpRV2y06bWFwma4Tzg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxvx05em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 18:48:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DIbYSn030164;
	Wed, 13 Aug 2025 18:48:49 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsbs7xa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 18:48:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hNmNOXlY9cv7Gy8y8ZUmF+WSd8apqDcwlLWG3cKETYzRhKBpEcDsznjZs5m2eR4NonSIudIEi0A8D9NzM4Bm2okGRc/P+2WSsDf0XhV1PKe6ZYw8hofdvRSiV2RlJVpn+UdTsRpG0iuaCLYSF+11FA+dXKdzx5fnBOyoarLQ9UAVl2Hv8Jn9MEsmkwAmWKwroDwtu93MCMZUO7p/wmGzo44Fr/FZu8eJvEF/mSqoQdc7I0KwLsKVSypwOFHC5EY1GGE/gNGfL3TuTHCt9lp+6xh+rtBi5MH5RLiTltojNYO1+PVQYlB4AHsztqavvEcrlPHJUjhnYWt+s8LFN4UU3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WluDeZaciNF/fUPrjlth/4tB16xKEKLbywLeJCe0pjc=;
 b=BgRIF1YcXDNczASJF0D8jMb7cx2V0oK7KmHCNVdw6RvLiQuujqweCb5+qEjFbYIztcoEYW40vJblxhlGhyNngKX9j5o03gKuZAQw559hbGqeE7wmXekO+KNDzgADvKW6bcc1smW5CtMIrZCkGUx1eLSag3/QzDXDEhXAY2sat+4L0Qai8rbvCBn3zYvVgC/VV9gb+VW5Bus2gLqETdmBj3Gm2gbew/CZMBxGGfHr7vE3mEzKZS/hCXSqqaXWbOVFCq0PnFrlm3QkZ2hwE2d6EtmBeVTAA1w32k4GHLrhBbNBcYTknj93ls+sX3Hp+Tbjxlh1QVkNkmn3C1cJBDDlEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WluDeZaciNF/fUPrjlth/4tB16xKEKLbywLeJCe0pjc=;
 b=L0jc0e2ctKVxiiZtMmFreBJM1AkcAH7N8VR+l2Kjd7BvFTC0h8yEZVTjktpdEE/I23y2ksLYZnEBE91/cWFHlW8ZP/3DJF9WH/uH1WsrHzBlEuzxkdG8Qmoknn3Vddrtl7zhOxNGqUthwpIf/p5MNceAaThV4mV6G0vTazpNiP8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5001.namprd10.prod.outlook.com (2603:10b6:610:c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 18:48:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 18:48:46 +0000
Date: Wed, 13 Aug 2025 19:48:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [akpm-mm:mm-new 125/137] include/linux/sched/coredump.h:23:33:
 sparse: sparse: incorrect type in initializer (different modifiers)
Message-ID: <c6078dad-3c9b-4d90-9b9a-7011690e3d87@lucifer.local>
References: <202508140219.D4jGTlbP-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508140219.D4jGTlbP-lkp@intel.com>
X-ClientProxiedBy: GVX0EPF00014AF3.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::308) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5001:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e342da8-20e9-4977-d9e4-08ddda9a0879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GXG8LkHoIV4spEQ4D24aVbFVO0HAd1huFzZpqsmUROsrNS05zpcqcMJ+n/Z0?=
 =?us-ascii?Q?epvHMn6IkcEnZ5umA7MSS/wKJ8pd4RBr746pT3r8f9cMytSM12yJUXZiacyb?=
 =?us-ascii?Q?0l5RetZhu4Lbrv4HuEIct32+d++vvFbF4FG63ZCLZCeYWnGgj0qUaVMts0dn?=
 =?us-ascii?Q?0wim4KiamFqbazLYNJTsT6o4bQ2XD+BWiXYVwiyc0J28Uo5qLbQzHH63HSUj?=
 =?us-ascii?Q?+K1XGTQZfmN49uNlBAE8fIuVYcgO8cXJg5SDIZCbjH+sCY2SxRQ2wKOuWsmV?=
 =?us-ascii?Q?LZdVbBQqZUrDEIRUrxUIo3zRi/UV33jEIdjSPt4V3GD1ON2SxJjRzgfF+M29?=
 =?us-ascii?Q?eWW5sUut7naq54bRsXyZj6N/kQWVvywKt8+NH+g8EjkqTmasD1ujJH5vltaw?=
 =?us-ascii?Q?DMjAP5eniBKvjqTMH/PhA16DMVq7AjH4D6QQxXkhjrhc60ei8NDvDz3hGuxs?=
 =?us-ascii?Q?SD/2ghTJyGeIkcLaUuIsfFZoM1zvw/Vdm8mmhrpw0ipNXkxVI50wUY5ybZbW?=
 =?us-ascii?Q?cjwmzf4tpFD2Je89C8JrSSUKDJ9PerBRySyN5AJYhUBnYBVzK6QiuoKBRuCg?=
 =?us-ascii?Q?1AzT7KA1EJXrBOk1o1dpY88X/Ywnqk/CKC075AoKPQqjY6AsALf/NhSgmhFJ?=
 =?us-ascii?Q?d+R0epHyCpWhKNxPE9x+Z3xQWr3ZUwftTFn0iOm4E48lvNxukexssSN/8cy1?=
 =?us-ascii?Q?/TV6b5j4z4m/gIV11v3VOkwDQ2W+XXFuNlPLXdyuyN4D03A8y2JXLyZwIrFb?=
 =?us-ascii?Q?1GiToavUmEPIeW1nMVhKZwSFZbx2T9tQar/j4MioydaGiFFiOUSCAfUs9NYT?=
 =?us-ascii?Q?riyEz47xl4CJhGQFrSAHpgQamP1HaJiMyZOFe6J5YeZUQlJ0bV5GUtDq+yk/?=
 =?us-ascii?Q?EYddtVXCsHSpLq7ghuWD73B9U+qbwEwE+u2qI31P/YeM2Mi1cQaktrCnDfFU?=
 =?us-ascii?Q?a7z/3LLaCw3Feunz0kUdlbx+DOK8E8jlXE3VWfo0U0tYboYfmKr2+HeQ+r7q?=
 =?us-ascii?Q?0TUC4sOrna4VGm3KgxYud3yNarMFBOt94OdBd3QW3oByd+n3sz/xdNHY6+95?=
 =?us-ascii?Q?3rrs5+TViJvlUmFqyVpsgE6VS8U0dn+wvhGQtVWQPqe4Oc9u/IJdoMIESFCf?=
 =?us-ascii?Q?ZIUbQytYJavvgDIWQ4OmOjLG50C2ZRJfp4svkuFDKQ+ax1+gWT9EclS5HDnF?=
 =?us-ascii?Q?xMs3jZGyTruPpIRZB95CFCn/DZUG6Pbj+8PziknrpnGeEstKbOYDqF7loL1/?=
 =?us-ascii?Q?4FY/OYgOgZ74rJP9u8+4pGkt9pRChaEL5BaV1VTewyXWT3wlI+aOwm2MI0yf?=
 =?us-ascii?Q?wsj7GPXI21oWXhsvyBQJXpy1EbVjnkjaaW+0v7GpC10IYJFtCM4/ziom8wba?=
 =?us-ascii?Q?K06X/uw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8X6ASmcSsF/Tm0raDQkvhuKEr9FnWCHJE7VJaH2g2fnBzIQ57t/B25V4DyF7?=
 =?us-ascii?Q?BGRxOIqSi2qceIH9Q77hs3DOE6WWDxh8ygJwYZ3n8SEJtJEsKynGP6w8C8Hr?=
 =?us-ascii?Q?5ZvIuplV67gqxPUVYP1trHBd9TWneOHkfF9yxLtZi5QC0v6Hnu18quDpfQUf?=
 =?us-ascii?Q?N35AMzdXkWr1cnLdbRuwr63v4uroZJWZE+4ZVgVWzobzs3Pt8H0BLn7aIAe/?=
 =?us-ascii?Q?4diBwXYDcLf61RTBGV+wNYRbI8anSmw+r5cWoHzm+g+GqTeB/eLAXK61s62G?=
 =?us-ascii?Q?a9PsQbBaNqhg0nCDhLIQNEb5FJza4jaMnsm7AE0npxJxemo0hnZnqvxZzWeu?=
 =?us-ascii?Q?TTKQYCEq6cnqNfc3qGtgRroGGTAGq4HgL/12Z0rdPxZkKb5t+jRVJc1vBesB?=
 =?us-ascii?Q?O6Wo52g7rUK0SuvOPwIMymKkzgJVhLX1frU/z6hRsotHffgyNWlMEd+b93F7?=
 =?us-ascii?Q?W6tn0MfNDwiAcAkJDFjFtBriMbDKkU7ehhbTJHXAj94QRGeisu0jnrsaEO2g?=
 =?us-ascii?Q?vGtd98GIdxjoABpJD/2KcunuelwQJMCUOjcl6C81BMYTWQ0t9k5VpP2Jvk2V?=
 =?us-ascii?Q?RXJ79mkIx2x3x6/RuXBl1OSaMto435P+QF62ZJvh50fnpQnQr3HW3KzBzXRh?=
 =?us-ascii?Q?Lw5wJVzEJ9T2Cs6SUHTMlxmHGFVnalKwegevBAdRRubrvp1qLKKpR/IE3AaV?=
 =?us-ascii?Q?0TyX2vEZknGoYpsGls4FsQIvCXmUf4beStQgIFi3Wm/3MNUDuP0/IJvbCVR3?=
 =?us-ascii?Q?RB199bZWgk+B93RsWtqaHIyt4+Dmq38qL/j+RzxLmkVMWTkqxZtjfsmS9xji?=
 =?us-ascii?Q?bFdX4S00lgjMRGS0FL7eaCdEFRYI6TwC4nUROBXlQOqvewCJMCj3HLiu/j6z?=
 =?us-ascii?Q?hwMB0YLzUKQoWyQBpCNlSIDZ6wUZw6J/VtGZGx/nsLLgIU4zoM/yoGC90lnS?=
 =?us-ascii?Q?YXJcHEslxB/73kijrXunypoeE2xLB/GZh8veOBQZZ7rPyLVMBnFwlRYXfgY3?=
 =?us-ascii?Q?2MY3O9EkLaj7UVVRieBsbNscNBQjKsMbwjf3PGwkIA7pF5G2X3B+L8GzOk3r?=
 =?us-ascii?Q?W6NEmmeGgO/IAKjo/1ALsWzh7Lmh4JgVTMUHGIAMZq5IwLZhya8OEXjRPQhh?=
 =?us-ascii?Q?1trZvwznPrFKtR/+Rpf4jv0DM03OLfetaWtwAdBFLjlH3dIB7WPn5wDgZtbl?=
 =?us-ascii?Q?esKzAxzcM81NS4ECtKYhd9ozGGpDsQL7b4TcGCqPiX0PJCnLNrZDy5IriuPn?=
 =?us-ascii?Q?J5WHo8KBLLGMTmbx5ABxi/XLA2pIs5Qn5Et40IHAA0RI/YUKYRKii+Iv4xEd?=
 =?us-ascii?Q?Z6poEoLhemYy5Fzg1yFh98+Kf6AXa0l/Lh4kpUjK/VLfgbA4x3u85lXQSA25?=
 =?us-ascii?Q?gZFjTk5WMI4r8DAhnvuVAhKD34asJGfLRwE12N5BhwS11i/vpKwzTPGu2r27?=
 =?us-ascii?Q?Pc/VHHynV7dSmMw1onaYG9fZ7XrpXm9vwVfSe4Za2yF2oov4E/LAwlN1nWUr?=
 =?us-ascii?Q?UaA4wkWBJbbKrOyS7qz/Y8KJZDKJvTQxZjFrqmrFUk8bT4PUz78mUQWirgtM?=
 =?us-ascii?Q?K8ng2V045YID2h7UbB9ZJIzQUAHfdFqjoueWu/i6w8y576KFPOQSCK1BsspW?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PF8Gp6I3/xg+Tp1/jqCYStcQiMe4EjVsvzDae7N3ppnaQrb6uOwqKrrRvfwyogYG1xq5YJDSr41jE/Y6WMc7BWjRCNXi39NFqegsCKFBdG1iWmXjQoFIgBNiEHfRRzvOOU+JIiV5itmO8rU3xmeYh/mvp1dco1H16O+XbU/25pHDV6MyWYH+I+z1yFlCpYgQsYTvU1bcpcJHaWQZlalaXle6rb58pncrcXgeCDMxda6UoTIf3M2K6I+m77hBd3wlR1htfxsXi9vyz+D/XSPOBDTrh6VXGS9PZYnHJd2P5QsAcKzF1tfyLTsJD8G0/VC86QjePhAfWrQasJJAICVIVagAmxqOx8aau2UeJCtyCyfVUV82scci173VnSZpXBbtyRx2w7vnxFvV3UaLLc4yp2pxzH06wannNeHOXEi3lGbQaMbv8Bih/HolF+51ePRww0sFeBmW+RdJa26gTn/J9AK5YQsE4u+/Hm++NfAFSYzsgEO36aOgutTOipMzUzQ5Nt+39x24m+xCryx4vJSocLxTVFm0JCOoaEDKc4ef5ubAum4oHRJzYi2KEAdWv3HxE9X2/td07SsddyHHaHhQfCkAJyCxhCpV5/cp9u1xZTA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e342da8-20e9-4977-d9e4-08ddda9a0879
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 18:48:46.0475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EA0vTnI6hh7i7QM4cN6cjpU7Kw7ZMO450cgqSctY3lNLmQW1dfzlbl/qcyXk8X7olbhfjS4kDLDvwMrZ+1vr86cu6usDVRuj6UpKuhaykmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5001
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130176
X-Proofpoint-GUID: mU-JAJVzdHNZzHYNjPKi2A0pEpBPiRtC
X-Proofpoint-ORIG-GUID: mU-JAJVzdHNZzHYNjPKi2A0pEpBPiRtC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDE3NyBTYWx0ZWRfX4MORa7fJ6O6r
 TApnJrGkpmPXidSfUO0zWROAc93s/L9Mw5kYCLN+wQv8/ywT5UGz4qAdUhl90W5ajRdzUqqZF30
 2zlXG9aosTAXhM9Bhb89+fPu48mU9y/6oHzzlgKX8+Ps0VoRzh3JaK/zWmDqBhzjGdxWF+djCm+
 d9dqr5uIDIX+Q8fTRo5GksZWxIqfb+177gbX3hwRLlA6KbTsjVcvRKR6gDTQHFPMeagrCU8Q+09
 x7gik6r3SFAnQrobvaTb2OgYq3PhQNtkfNMnaafLtzjLGTk5vDWlAFxLLEda7UPhYxfMU1TgSUb
 Y1UUansqcbxi9GCnfPtpJvnCJQdz6Ql5HyCo7yEkUk1JnEv/jQk6NSEXh7oHDrJU38tKQ64OkBj
 anjf6P6qpwWatPa94/IbIlFqTBFEl3bQmRc0KA4ifcOfyMOotIb9izLMf4zhXJPWYVE1ghaE
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=689cde13 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8 a=58s7ZUjMcFMmG_oONMwA:9
 a=dGd4uSqXEzJIxgVi:21 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Stat-Signature: ja9wusoaa4dreutac5kojazn8brxfnq5
X-Rspam-User: 
X-Rspamd-Queue-Id: 03DD4180015
X-Rspamd-Server: rspam05
X-HE-Tag: 1755110934-444144
X-HE-Meta: U2FsdGVkX1/z78aldoqsU7eIg1ul+v42L7v47D0Hy6z1EFlAugQiI7ZNn0BRaspYJGPJeFqJ8EmVwL4AWPibGmwF9b0CmfRY7H1YUb9OAxMB/gURuzOGN6bSInRlnL8TRWttSZw/GYAzmj16dPPccjvcGr2O1qrcgioIo7Xki0etqCJLv2cJsXXurWwh0z2fv5C/w5BX9oVVeaBymIWRfHeeKwnmmVaeH0ySCvYhCVOARZ4BPa8sLjcVC4LrV806KDbwEL0B7PRWThGdhDJcMop7i3byZBN3/nH1N6UDtbYjvWncR4oCNLKH9q+dg5OQOazh/94PFUogtoW5XC6YzcSCg1tkc/5rwwBqDMUxU+1rcauB/LXcJ4+1nnZZGLR5T6DuR2JzEsCk4BO8d8FxIOndd1IhVpwEg2xH+nU4hSAW2/YtWe+5+FMzUs6r8ETbLXQ5IWf57q/tPyK0Lp1LcyGwxHa2ZkRVscOktSR/hSEN9ItdRZSGC8ZwpHa2unh8Cw2Wk4JYH+DJaBPhNeOPXr+jMF2WPCqxnYTV70t9QQadVvETe4eztAEEo09kf2YR/dbqf+9JuY8gqIr6eV76GSKgBvNXxf4cU+g4QM1Cc5ySWBZBOTbADZge/dZWVqGeS8Ud3Iez/q2vxrVRzE/jvMTBZ8AQ84Xv5IBCCug0Oe3gCxjnW62YXp4SUzrwRgsXnUFO8uvHjLF0zk2ZYckyaVcIH6+jf1qkUvQMlNmuHWzWAiW+xRjp+OKGODEeFHHH/7dxKRfBjFLDnoeZPdtmdJjovoLvDe4uymJ0U8bNnW+PRlV3FBldyRFIjUxOw/o1ObkfDAOspIZqT/uEmygzI0Po96nopJPMeJmZEUm5SE7/XjzMJis24JblA76OsVfk0gHbqLCYycduCKJ8UUG4avWC4Rvrn0R7ikYL7BKA2Q760UdgN1XbiRnf+kinop1xnjpj//+1gkdP3Dtnyf6
 IQK7VhsL
 WyQsHFID5nmhZxF002D2g8KEK1LcwyZ/8mqietUTXuNBIZdQV+jwKzG7+LARm66NHb5KFX5EUeswSXe8GHZL+ZiVRPR0A39WRbG4cU9GqMC5if2xRaQI9J0krhH9QuCNFb+BIeBQI3726d8tJjN+iBYFQlgw5eTCMrrKEr9uwt0DLJIDNhkSbkm9YSw7V0m2SeE8PFhb3OzO8nu2m12GoDzpr3Cnu01df/13wVkQ6VuxU+rY7ImzFgPu/AsJA8mJWG5gPKYvdnC2tCwA1jFyPreOLbVZczmUoRlicXR778Xarn+EX/+a1W2tjZ5mktBrSancmPGytkjEFgMBL66FW8qJpPOH6G46wb1n7wxGYXZzQVw+ZtKb8W5W5erSLEmJcj1UGbw0vShB1M7spx8xSZDHmEyU94mOJ9Yr0dzeoOv8InKnKuo+1tPnk38DxFgLZ54KPR/yzTf3MfY+Tfy3JVawpKpncVAgEVgimb9+ggM/nGBtnCFg3j9C/Vatr+mf71TXHc8JseyycSfDFl682rpczBNsQdK7VH6hVr10zsNJqxGHx+VE0lW+wZ/T8ZNC9tNdING2/zmRMQUn9nb6K62eSWf6lGGAyiGCSXZor9U/y6kh27MMYVzZn2bVYGQEDQzElxkMULK8y5qpSU7f6m2TS57yx0AOEnvoSdoaujgtDsgjvA54f+HlgXBIndOD3owxjZf5++aF3SmJsSqiVgMR56IfCAe01wWc8xthGGW1p0t4gS2Z8S4YVB/QgY0rJ6T9QFVRqqtW/FNBxbV6JGskZJZazKdoqz+2U+A2PY36oaiI7ADJ2DxNLij0Uuw1GmFXc0p8CbEroUA5B+L26qYehx9E8OHn2vPQapwoTKrlaMuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 02:29:47AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   694c8e78f486b09137ee3efadae044d01aba971b
> commit: 63e795236094c47c4030f1203c798c511f9ac6f0 [125/137] mm: update coredump logic to correctly use bitmap mm flags
> config: microblaze-randconfig-r131-20250813 (https://download.01.org/0day-ci/archive/20250814/202508140219.D4jGTlbP-lkp@intel.com/config)
> compiler: microblaze-linux-gcc (GCC) 12.5.0
> reproduce: (https://download.01.org/0day-ci/archive/20250814/202508140219.D4jGTlbP-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508140219.D4jGTlbP-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)

Yeah this and others are due to the funky way in which the __private stuff works, will send a fixpatch.

>    fs/exec.c:318:31: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected char const [noderef] __user * @@     got void * @@
>    fs/exec.c:318:31: sparse:     expected char const [noderef] __user *
>    fs/exec.c:318:31: sparse:     got void *
>    fs/exec.c:911:48: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sighand_struct *oldsighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
>    fs/exec.c:911:48: sparse:     expected struct sighand_struct *oldsighand
>    fs/exec.c:911:48: sparse:     got struct sighand_struct [noderef] __rcu *sighand
>    fs/exec.c:1017:56: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct task_struct *parent @@     got struct task_struct [noderef] __rcu *parent @@
>    fs/exec.c:1017:56: sparse:     expected struct task_struct *parent
>    fs/exec.c:1017:56: sparse:     got struct task_struct [noderef] __rcu *parent
>    fs/exec.c:1052:47: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sighand_struct *oldsighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
>    fs/exec.c:1052:47: sparse:     expected struct sighand_struct *oldsighand
>    fs/exec.c:1052:47: sparse:     got struct sighand_struct [noderef] __rcu *sighand
>    fs/exec.c:1167:26: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    fs/exec.c:1167:26: sparse:     expected struct spinlock [usertype] *lock
>    fs/exec.c:1167:26: sparse:     got struct spinlock [noderef] __rcu *
>    fs/exec.c:1169:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    fs/exec.c:1169:28: sparse:     expected struct spinlock [usertype] *lock
>    fs/exec.c:1169:28: sparse:     got struct spinlock [noderef] __rcu *
>    fs/exec.c:1693:70: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *tsk @@     got struct task_struct [noderef] __rcu *parent @@
>    fs/exec.c:1693:70: sparse:     expected struct task_struct *tsk
>    fs/exec.c:1693:70: sparse:     got struct task_struct [noderef] __rcu *parent
>    fs/exec.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/slab.h):
> >> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
>    include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
>    include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
>    fs/exec.c: note: in included file (through include/linux/sched/mm.h, include/linux/xarray.h, include/linux/list_lru.h, ...):
> >> include/linux/sched/coredump.h:23:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
>    include/linux/sched/coredump.h:23:33: sparse:     expected unsigned long *bitmap
>    include/linux/sched/coredump.h:23:33: sparse:     got unsigned long [noderef] *
> --
>    fs/coredump.c:508:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    fs/coredump.c:508:27: sparse:     expected struct spinlock [usertype] *lock
>    fs/coredump.c:508:27: sparse:     got struct spinlock [noderef] __rcu *
>    fs/coredump.c:517:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    fs/coredump.c:517:29: sparse:     expected struct spinlock [usertype] *lock
>    fs/coredump.c:517:29: sparse:     got struct spinlock [noderef] __rcu *
>    fs/coredump.c:556:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    fs/coredump.c:556:31: sparse:     expected struct spinlock [usertype] *lock
>    fs/coredump.c:556:31: sparse:     got struct spinlock [noderef] __rcu *
>    fs/coredump.c:561:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    fs/coredump.c:561:33: sparse:     expected struct spinlock [usertype] *lock
>    fs/coredump.c:561:33: sparse:     got struct spinlock [noderef] __rcu *
>    fs/coredump.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/slab.h):
> >> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
>    include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
>    include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
> --
>    kernel/ptrace.c:55:22: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    kernel/ptrace.c:55:22: sparse:    struct task_struct *
>    kernel/ptrace.c:55:22: sparse:    struct task_struct [noderef] __rcu *
>    kernel/ptrace.c:74:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct [noderef] __rcu *parent @@     got struct task_struct *new_parent @@
>    kernel/ptrace.c:74:23: sparse:     expected struct task_struct [noderef] __rcu *parent
>    kernel/ptrace.c:74:23: sparse:     got struct task_struct *new_parent
>    kernel/ptrace.c:75:29: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cred const [noderef] __rcu *ptracer_cred @@     got struct cred const * @@
>    kernel/ptrace.c:75:29: sparse:     expected struct cred const [noderef] __rcu *ptracer_cred
>    kernel/ptrace.c:75:29: sparse:     got struct cred const *
>    kernel/ptrace.c:129:18: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cred const *old_cred @@     got struct cred const [noderef] __rcu *ptracer_cred @@
>    kernel/ptrace.c:129:18: sparse:     expected struct cred const *old_cred
>    kernel/ptrace.c:129:18: sparse:     got struct cred const [noderef] __rcu *ptracer_cred
>    kernel/ptrace.c:133:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:133:25: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:133:25: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:160:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:160:27: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:160:27: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:192:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:192:28: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:192:28: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:198:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:198:30: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:198:30: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:251:44: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    kernel/ptrace.c:251:44: sparse:    struct task_struct [noderef] __rcu *
>    kernel/ptrace.c:251:44: sparse:    struct task_struct *
>    kernel/ptrace.c:494:54: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *parent @@     got struct task_struct [noderef] __rcu *parent @@
>    kernel/ptrace.c:494:54: sparse:     expected struct task_struct *parent
>    kernel/ptrace.c:494:54: sparse:     got struct task_struct [noderef] __rcu *parent
>    kernel/ptrace.c:502:53: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct task_struct *new_parent @@     got struct task_struct [noderef] __rcu *real_parent @@
>    kernel/ptrace.c:502:53: sparse:     expected struct task_struct *new_parent
>    kernel/ptrace.c:502:53: sparse:     got struct task_struct [noderef] __rcu *real_parent
>    kernel/ptrace.c:550:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *p1 @@     got struct task_struct [noderef] __rcu *real_parent @@
>    kernel/ptrace.c:550:41: sparse:     expected struct task_struct *p1
>    kernel/ptrace.c:550:41: sparse:     got struct task_struct [noderef] __rcu *real_parent
>    kernel/ptrace.c:552:50: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sighand_struct *sigh @@     got struct sighand_struct [noderef] __rcu *sighand @@
>    kernel/ptrace.c:552:50: sparse:     expected struct sighand_struct *sigh
>    kernel/ptrace.c:552:50: sparse:     got struct sighand_struct [noderef] __rcu *sighand
>    kernel/ptrace.c:743:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:743:37: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:743:37: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:751:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:751:39: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:751:39: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:862:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:862:29: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:862:29: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:866:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:866:31: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:866:31: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:1221:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:1221:37: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:1221:37: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:1223:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:1223:39: sparse:     expected struct spinlock [usertype] *lock
>    kernel/ptrace.c:1223:39: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c: note: in included file (through include/linux/rcuwait.h, include/linux/mm.h):
>    include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
>    include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c: note: in included file (through include/linux/sched/mm.h):
> >> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
>    include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
>    include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
>    kernel/ptrace.c:380:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *l @@     got struct spinlock [noderef] __rcu * @@
>    kernel/ptrace.c:380:30: sparse:     expected struct spinlock [usertype] *l
>    kernel/ptrace.c:380:30: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:409:12: sparse: sparse: context imbalance in 'ptrace_attach' - different lock contexts for basic block
>    kernel/ptrace.c:500:38: sparse: sparse: dereference of noderef expression
>    kernel/ptrace.c: note: in included file (through include/linux/rcuwait.h, include/linux/mm.h):
>    include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
>    include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:690:9: sparse: sparse: context imbalance in 'ptrace_getsiginfo' - different lock contexts for basic block
>    include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
>    include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:706:9: sparse: sparse: context imbalance in 'ptrace_setsiginfo' - different lock contexts for basic block
>    include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
>    include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
>    include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
>    include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
>    kernel/ptrace.c:1384:9: sparse: sparse: context imbalance in 'ptrace_request' - different lock contexts for basic block
> --
>    kernel/sys.c:1144:32: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *p1 @@     got struct task_struct [noderef] __rcu *real_parent @@
>    kernel/sys.c:1144:32: sparse:     expected struct task_struct *p1
>    kernel/sys.c:1144:32: sparse:     got struct task_struct [noderef] __rcu *real_parent
>    kernel/sys.c:1894:33: sparse: sparse: context imbalance in 'getrusage' - different lock contexts for basic block
>    kernel/sys.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/mm.h):
> >> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
>    include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
>    include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
>    kernel/sys.c: note: in included file:
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
>    include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
>    include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
>    include/linux/mm.h:747:25: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
>    include/linux/mm.h:747:25: sparse:     expected unsigned long volatile *addr
>    include/linux/mm.h:747:25: sparse:     got unsigned long [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
>    include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
>    include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
>    include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
>    include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
>    include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
>    include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
>    include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
>    include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
> --
>    fs/proc/base.c:890:65: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    fs/proc/base.c:890:65: sparse:    struct task_struct [noderef] __rcu *
>    fs/proc/base.c:890:65: sparse:    struct task_struct *
>    fs/proc/base.c:2326:25: sparse: sparse: cast to restricted fmode_t
>    fs/proc/base.c:2383:42: sparse: sparse: cast from restricted fmode_t
>    fs/proc/base.c:2483:48: sparse: sparse: cast from restricted fmode_t
>    fs/proc/base.c: note: in included file (through include/linux/rcuwait.h, include/linux/percpu-rwsem.h, include/linux/fs.h, ...):
>    include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
>    include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
>    include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
>    fs/proc/base.c:1170:36: sparse: sparse: context imbalance in '__set_oom_adj' - unexpected unlock
>    fs/proc/base.c: note: in included file (through include/linux/pgtable.h, arch/microblaze/include/asm/uaccess.h, include/linux/uaccess.h):
> >> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
>    include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
>    include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
> >> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
>    include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
>    include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
>    fs/proc/base.c: note: in included file:
>    include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
>    include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
>    include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
>    include/linux/mm.h:747:25: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
>    include/linux/mm.h:747:25: sparse:     expected unsigned long volatile *addr
>    include/linux/mm.h:747:25: sparse:     got unsigned long [noderef] *
>
> vim +23 include/linux/sched/coredump.h
>
>     20
>     21	static inline void __mm_flags_set_mask_dumpable(struct mm_struct *mm, int value)
>     22	{
>   > 23		unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
>     24
>     25		set_mask_bits(bitmap, MMF_DUMPABLE_MASK, value);
>     26	}
>     27
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

