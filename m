Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0522F34C4B
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAF36B0089; Mon, 13 Apr 2026 08:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BBC6B008A; Mon, 13 Apr 2026 08:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DDB6B0092; Mon, 13 Apr 2026 08:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7B226B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:28:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B9A51B6CC9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:28:58 +0000 (UTC)
X-FDA: 84653461956.09.89499B2
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id BA701140002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:28:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=OszP8mxc;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=SfTlaW4s;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of "prvs=556ba0798=shinichiro.kawasaki@wdc.com" designates 216.71.154.42 as permitted sender) smtp.mailfrom="prvs=556ba0798=shinichiro.kawasaki@wdc.com"
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776083335; a=rsa-sha256;
	cv=pass;
	b=SwyecafUCCZ5oald4nyETrQiXTUNd3Nr0tNqnbZwGc5TsDa8PQiLKJyzIru18jfk+LulLR
	UEdP0osYaZOuggegmpyO7IQZOnivCI0ZkYUFQZzHnWgKDg9T6yzJUwxC6fl5L8wPwfSiMX
	mpUyYOd7NRxRYwuNuur7p2DLo2ybU8c=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=OszP8mxc;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=SfTlaW4s;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of "prvs=556ba0798=shinichiro.kawasaki@wdc.com" designates 216.71.154.42 as permitted sender) smtp.mailfrom="prvs=556ba0798=shinichiro.kawasaki@wdc.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776083335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/aNtxIA+wgrqiwNnRTCX/cWC3OzBlklNNTN/GfTI5c=;
	b=KG5y/EYFWrDcpzq6dIdbc4SlLCy4BYSeX4XEBJ+r6Jqyx11ndbGrfVjolartuyKsfoCxKB
	IC1cL4Im73ze+OMxJ8c0HHFnwQvOTYK8MmcdTTuO5hx4GegrWhrDPflbMyD6ipwfbC91EH
	utjUengm0NVge4CM7iZBIfgZTmAVpVo=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776083334; x=1807619334;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k/aNtxIA+wgrqiwNnRTCX/cWC3OzBlklNNTN/GfTI5c=;
  b=OszP8mxcjo2vzyvLu+pIsZQ2DkR6wTVVEFa7M6qIWVZgB6cfMEvybKce
   saz9Rt+rMsqIxyg1Zan0ka4oG/ntcPkng/Q5Yj+1IC1Hwkm02CI+G+zh6
   zCushi7QUYAjdr/gazf+FI4HTJk5OsBhzkes6YB07ULdNZ6qthrRzJg7Z
   gVZhW2WSVI3xadwTXoSSELR/9Wwp7LcbDfG9UsuBnKXyrpjf13dokgMyE
   2vzfuFbQ0oppUu/xvj85LMiqHggLstqU+eXCMNP4XHtbZTDtd8pHNNOtV
   O6Yza/3FVu6cHBCsLEH75xzDFzPAt/wBFv0ScpR9OuABnJrfQ4l5eymVA
   g==;
X-CSE-ConnectionGUID: 8/Q+AttPQ3WhXWUH89/aWQ==
X-CSE-MsgGUID: mp+ISHVTTVCP6ecenYIzwg==
X-IronPort-AV: E=Sophos;i="6.23,177,1770566400"; 
   d="scan'208";a="140672291"
Received: from mail-southcentralusazon11013021.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.21])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 20:28:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6PYt8EN6NtPqh9ILWMQ93wOo1pEMHoY0g2IfmSiRRvNuAD/qgg1dGSSd50krFza4CbPdltXW4IaA4LmIHUVaQtqOjXMFJK7C6GkCmjDySGB5UkxYdKES4RTu8GaafFA2pS6G+gKhQMj1ny7+kLtrYR8Cy0Azvf5cVqCJDzwI1wSZCkUwciIwan6g5uu3NUVSzzzucR4wSvs0GkhJbTueop9LRyq+QtbGZBzQ0UVb4jwjl6fmKLHzum++T1yIJRIMeMj8HgjEY2r+Sav3dXR4MuKqQEYBimUbrqaVpUrTKrUK1g4tJcGOw90FyVEqIz5NswzwgLTd3J2GkwTPxuumg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/aNtxIA+wgrqiwNnRTCX/cWC3OzBlklNNTN/GfTI5c=;
 b=QSCQvePJ0Rb9ZIzvOKAcy0iQgNrJb/AJfTLp3o+bFxjI5dh8B1zymms8OhYLdzFJUCz0cPVIbbyPEwwNsW4OGFkHjX6MEGUF2LJnSRvRVakS9kCRDgcJ/ZV3f7NrDVfsFYUZDrK7gVGLvBs7OMddeHr+LHSQoMIMgVbwc+7vCIxvvAdJzL0ZaIZcXsoZfdMSBF8LackeGOgQoH5wUpmbPluaiU/2BPtBoG/ldBR6wy/2VuNb0947A8MnzLBkp8xolmufxGqin6+qkh62Ke0RdENPEFiWqapE6rvkvOeYwOtSvwK/wNmdvp6kf0mAIBDd3txJ8uKS9oAFzHR2boze+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/aNtxIA+wgrqiwNnRTCX/cWC3OzBlklNNTN/GfTI5c=;
 b=SfTlaW4sn0ZcnE8gPtv4JXYu6P2tiY4JIfatRG/n+Z0SANEaWjCEw2Ybm9LO58mAD7OFkQemtnuRs9oWLch4eCve5lEpwfHSOIE2D8YUVnfyQCBwgzzAfyofbMWxz6Brq/glVgO01k50Cs/aUlew7rbkr/Pl6OIUIIen54kpwA0=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SJ0PR04MB7344.namprd04.prod.outlook.com (2603:10b6:a03:29f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 12:28:47 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 12:28:46 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH mm-hotfixes] mm/vma: remove __vma_check_mmap_hook()
Thread-Topic: [PATCH mm-hotfixes] mm/vma: remove __vma_check_mmap_hook()
Thread-Index: AQHcyzRf1umTanX6k0SRtLxnV5dLI7Xc67uA
Date: Mon, 13 Apr 2026 12:28:46 +0000
Message-ID: <adzg2DWDWDR3DFJh@shinmob>
References: <20260413105713.92625-1-ljs@kernel.org>
In-Reply-To: <20260413105713.92625-1-ljs@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SJ0PR04MB7344:EE_
x-ms-office365-filtering-correlation-id: d86fb260-249c-47eb-592a-08de99583575
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|7416014|376014|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 2IrLJz7UC/QR28IWGwvazifHMhsScPyxFHwncGBJU0iTRm93ENbJ2LSk0sd/s5krJ3l0L9QH+Y+aL4DZGx3g3kBdXoMAMFDyw2UIrEmh8nzzXf+Vz9E8EdpW7AHdQ5rebxxM0P93dSnWY+HL0X5hKiOYOIUGqyk++egsM4Nr7jsC5uZ1nr9uJDUXXLbO9Y3Aqn1NUi3xXnI/P/ayNs9fpWQbtNmQ8mfCeQU2YQPcmsyhwf6MBTBGL35o5iW5bAQlG2yiSL1Kzbm0F9Pqmn1eYsrRr+Cr1rX+zvvjKNjVe1TUyif5ouizAwbvXTEuQ97+P735hyNLhA+pCGqGwNA418TiUgk6dZNCVj9irp6kGWT3KL5K9m+mDU2q4EHYHls7Y5Fv4alsqTS1IDilaSIx3O3WVim5yUA9DRR6p1QtcOx+UmN/fnM4EJpvH8BteBZhmDcbq7xD4niQg/sKyspaYzCQz0wSm9VzytDhrlOPHY/CoSAEkb5sZwDBQsl0KSYSdgR3iWPVZdsfPuf2DnOztD91vvCFBHfo3UcNa8zdZhV2F/LgHlRxpsfkHESQX/KRNo+c4OTv6eoJCs7jpCFQ9IBwg3PjfFzKv0OxbqxqXh4UhdoWsU0WiE1qGnydYKlqyV04qPQ83BRVbrrEeIvCjWYjwk8j2p+zYeskvfQjR4DiTsvLeizDNkp/g5GYiTM2STFp8mIt1YamSwzMIHykmNel1mABqh9iFlY2BwMlIwUhtM6CfN+XLgXyZjIGZ121BI4UDTzy4xCDeJB5hn83mN/TE0vfqiyrJJNZmeIy1Xw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(7416014)(376014)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ehnbxeuEjhgOSuaz7SXxQuJ/DWi70L8UXdeKeHLzk8ZFpk8t0IVyiTtGrPBr?=
 =?us-ascii?Q?dLNktBP8AdQ+mpVZqzSb73RethmzHfkQ/xpACEbFfIsrwDfZ6wRuq59XyWDW?=
 =?us-ascii?Q?aTmP+o2XIRD08MZVdGg1vnIkVQqJelydHWszNa2QAJG28KXVOaN3bM+nk4rX?=
 =?us-ascii?Q?9EF6md7sMp6S2WUpUGboIpq+8dlflwH9WNxhY3kKthihpBmAB/Fy3Poq5K/s?=
 =?us-ascii?Q?QazNl6crDoC1DEoOaJDI2Us/p8K3oz5sYJEYNjLwSFzSj1YvuDsyjwTZztGD?=
 =?us-ascii?Q?1OUS/87IcR4C5TA1J4xiJKWWIys7qT16M4nAIo627BCshwpTtlqAxXPfU/aP?=
 =?us-ascii?Q?W1lrdr2Ld0CWVgNqwXIf+WqAQQ+bRD9v15ADER1UgNdza59Umtt1NU9KVxrE?=
 =?us-ascii?Q?2pe//o0PZqnAlApWAFOt//ISA1hlapVR4s7+BKOVC9HrTJKUu6s3CbndAoQ0?=
 =?us-ascii?Q?Xm/J3Lik3p0fizpkwTbTd3g/8lNgZe37xIvWDn5Av9mav02QLoHUBfANOkY5?=
 =?us-ascii?Q?lBl/r1TPWI9pJmtA+Dpz8CyR9pEXONK88KAinbGkquidcIBrZHnjhIDKIy6e?=
 =?us-ascii?Q?mRsB5Cl/Y1Z6ELHCXgsDEQGrVaTOWj+Q9vCx340dLBTLympAPP08SEwwG96Y?=
 =?us-ascii?Q?ezLtMnHBc5J2Hd7jNUWqDmfu/DN+TkQV95Pyyu/1HN4ko+OjO/URywodFD+g?=
 =?us-ascii?Q?Hw9JaYD+2MN66a80PFoDJk5/W6RjoiMGMMu1ZPAr2b7XnhBxh0WhLNM+6WdU?=
 =?us-ascii?Q?7ayFX0jnsPgbUPwsyauyfZo6ALw2Paum6pUFo6i6wpp2Ea8J3ZWQkmw95z2E?=
 =?us-ascii?Q?8v6dVNBrJxaKTkGUfGjdv1j0JYB8PiKHJaMbRQrOftLGqfHTEErbvP/ILgNs?=
 =?us-ascii?Q?ZrB/iZXozdyxggpSOl7o1vg5ix5qwSeD5HemVPOBZipcYKaf4Ivtl9ZEcQVq?=
 =?us-ascii?Q?cMaOshE0tQpoUQ0OoXaES7hZgGKB9x1O1i3pSsDN1wwOgkPD5wNXHualIB50?=
 =?us-ascii?Q?ASNEClHQ4nFFZFPfHuBa8BJacYBggbZHis0zNf6CXH7YsSEUeMTnk3yM/obI?=
 =?us-ascii?Q?0uqc9sqXwSO74D4BRvYgcDLXzANEAczHLL9uNqhP6I0yjbn+GFaI8IKOOTss?=
 =?us-ascii?Q?7n3TFNVDSZstg0OAOSlcS02D73oGPiV12JGUo4aDr1cElXjfnTQuMzrjXKl7?=
 =?us-ascii?Q?xX+g9ROpurl+2YhaWfjxeERaHGy7hrDS0+WQFKrswXsEYwg+UpflnKLf7+ly?=
 =?us-ascii?Q?zJ1rGpn0MADODRHpWGhZ3c5LIjSZOgkQPshmd5Tyu4eeFE0oJYWxnTm6IRlf?=
 =?us-ascii?Q?qjv6WRAcY6yDh7WwPH7HMkNDgKeii2ovkp2k0WJGQNJSMQ/NaeTiOKgCmnGD?=
 =?us-ascii?Q?TvbDxjST3H7hsKqEdMojeZJWCpI54xLa9dQwhxL1S/D4f8HudhNni6R0U7zr?=
 =?us-ascii?Q?vUg+3qMB4Naife6me9VmxFSZDsZB8vrGXTK5LjTJ0YveEBJxoLWnQo+dVnhy?=
 =?us-ascii?Q?6GMqw0wWdWfgqhuvQc21Ly/ggMvrKCrTCc4Q8gRy++SqzJoWReK8YisTL3P/?=
 =?us-ascii?Q?Pjmkm+/8jtYG0EEkmg/DHN6kKNgZA9HlIt8pJByWNEAL3qDFR74lG/a+ml7a?=
 =?us-ascii?Q?Y/MU/4cC8npBHbRLeGrO4hqX/Yff7SDsGfWRjwrZLacLRp4teVDWVJNMUh0u?=
 =?us-ascii?Q?9Lg7zBZz8/qSkigr/mQBP5SAVdwf6lCK9hbhOj4TntNOtxrThntrt3pFgnVT?=
 =?us-ascii?Q?VofgMshJNL7JQ3vBr0Bfcr9/aBWNRR4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FBE4B584CF734F43B38561A3B68255E4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	EypQzhR8NRe3k90dcAPVb2dggV7wvdSZz7vLDBHPFrdD5vvFsZjJN2bExQCk1Ih9o81RDH81Hj0ZVZA6+gqoAAxa00S6pmvvQ81x7zsNP7tTDkS60istwJldeU56yMPWQ/xzxNrgxk7Pf3PC8s5UAOMdWiItyWinqxoxvGXNsq7GzIlnVnawqjV0fJyzu//LHkQn2a2auZEeB4e1GkYDILKsbA58d0pPE6BeZ2fgcE5dGzgOQftSObbCDPSZ4L80kPkBWszECr1BB0PETJq9SN2hZDUjWeo25FNM9doJqKQxacPgjWZZLJV/+J+fu40WEN4nrFb5p+/dCb8/fBOZXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T040UJ+a21xZii2YAWub/TRUXd2XlyxivkBjvXbbQLBuDI0Hszf3vsgJToo5/RbrtAQNRf/HcexqZBLsnP/uKt7ffc069Yi08hyvLWIPtG95EnC7GeyeEQydI9Ox0dcgheDUhQrtg48WH4yg4M63A/YNGsDEPkxPnhXWKQvvhaxUzp0Y2Znoyo+p1iPXXqs2bvDfxKN3n4m0hAknkQhRg+CKsVYz/mIhtTYNvRVTPbKXgvYWLSPRRP+kJx52P9t8SI2oJkDZs/3AZc0E8acTxKwOi107+G7/d+DuSs1uvyF5TmQ8JR5BPIovcEmCru+75UBnH7LeTmaQrEel6Uy1Fep9X+qjKcbsCxbccjUQtpksWC9PvgnQF14tR5PUDCacA0nNEZ6mEBoJoJDfCvYG5d/QGhY+5FvIcw69V1YTblyXXt3lc5b5qxZ2Y9Q3Jb7G5+FlvWg24bn1ADfVm2ze2q+MqsCwQyktn2UDMOlYWqncef0Da5A9eI2lRoWUNUJgawhxBcADSFrIEAzJgEFigC1/gD9hIOUiigFB6MjDWs0aOxO9TPVR7nXsUmeeMIrEgn6BmWN5ZY3raRDfENtt9Ua5x0X4MFquNM4LbitwhvEBVDbSmDwo+S0Ef4CGmeuj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d86fb260-249c-47eb-592a-08de99583575
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2026 12:28:46.5453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6gPOKzHCARUUvq6cWvIF5AULFcwUtKzfQRKNJyt7Vt9KAgsR6WbqVbfEgq+bCVrS3sL19XYElsRAOEJEcQguCb4G0wmuT4cJtsTAkRsuTXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7344
X-Rspamd-Queue-Id: BA701140002
X-Stat-Signature: j1wgt1hcq9oxmqto1z3uxxfkmx4na4jp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776083334-109774
X-HE-Meta: U2FsdGVkX1/Z7WOwz1AlpasPkN0GTIhkBL+uJ/90z9UsrGLNOFbbycIOBlxBe82hpt3KcwqI9CIkc60bhCmGBa6TcZXlR+B4HecdBXyWho4NxBk3jyXwdYLnJK/zDwdo+epCVo20XEOzzhYOhBdqrlm0SvwWmb4YeTX5Qp+Lq20K9x9UJG4RBgSJ6WMjZqmx5edWEX1fp2gbs5zVBQ0eOEjSkoBRDqveSqXWnlHYeEB6aQX2u2HgVf/K6uIPx2nbKKOyiqqIFRGF0mJbSXvt87t0QB/xb5gdi+d6VdFDHsCTUqTP5I3dxWxcsmiOWx2XuASV2X6YHs6NHefd5FOOk31lP6TS2LToMl/n2KBjNsNqa+zR++GPjlR/dnQybTQS9V0qO6yAtAU1P0Lm9SvjVYoFXc0Vq1hQx0S+3HU+G4yxr2Sfa9XgB5hJ/xJAVBp3c6X9wezE5A9hzbo+vVHp/inBGh+7Xbhynx30sNQqg/VTosvbhTdPbZ94XHCK9srX+rL/Rxly3wRueupLfAc4w9HOB7THqMZd32TPNsYQhAHYKdh0v9uYOP4zmnYocQGlBAn6r79AaZBoVNv6oqd6sApeu6ggAabvcYDUthjdlrNm4aBXF2klnixINCUeM8RbRwJJSGLW+SVWhiybfPoSGfBbgYuZvWGLwtfO5dwABAHggtN6sjYHldmV9sNPnGzyutE0gYpAVK+M5/JTVwSTw/bGd+T7c6tlgCAyIxna39IPLzJF3Rt/onI1hnP0U0hJ7Fq7QfuTkpaWzoYKuRnMGtobX7Yok6kIcB6cFkqjy62DgHC4ioG7oTCKYa8B8U8Pl+54c0h/H6YKAKVznHpbEHVaecVZ61mi4yfKkPoYYYFCIa6Uvh81s3OQ7xQV2MqVPpkS4VBmDMG5dy3ZhTTDx8sx6jSpMGeiC7CUJD6Uin1MUUesLwZ6um+VolXyIOEvUc0x8fC1QqrE9ADZOHg
 Q99g2MPn
 tgV2NnseeiRY8FGFyrIknu7Fx/YEOfpeduAx68cYBc4tpaLBu7UTGLVSBflKK3kJzmVHW0RYvD/Xh+o4RXITs46WL8b2JH1Eol+jb0BEggqVNKYCs1GmFPrzhCTvynuxxbKA8p4sWtPAS+P0/GYXW1lglovf9KBOoC7jySsCs3d6FDACSjpltgBHbrL+/aXQMKh6ktHdj20WSTgzFFgfc5badqULET3M3UN2s+WhBEkQa7U4LQxkZYdEnQMQShIWBz7j9eQeeqp+g8kmGZOtKVYjLKgmzndrcnb/9dLzY2qfUza0cQEKbPwnROyf7/qvENRt9ebOnLCal1TdqpIXrwHxfc73m92MXuPAbiZCUoFFky+tG/axEULJAcjFNqVcQgPYUPV7wzvTK7hSAihr2NuZoNy09yBYoDIptlx4vp0UYmIoys8gwAvGSjwLadgwdwGiiK7wY8S34lV3iIjWwo9W+ymg15/2Rw2Et3JFTLVb6wmLjhAj7HNoUoWCsz49QV6xhxISCUoQz+adYMnBwUJXduCIV/pA+N3r+ORlYUcEePUF/9fUYV8X8BQRU+exQfsIpfRtqHpRkuacgX4QgXl4W/rRXme+yoxiGE79oyU4ToUij39WIeE/doJTSGnNfJuJJ2ylpCThhAxX+86qwwvcKTLnObWpOcMqMuYuwWd20EVGDkGYCZCdyF/O8qz41ZQmuQFBGsLx0KLziz9iVUNN92QTWdgI3AriaNoWE2B/YHqdz2b4+anypwLExzCrhFFtXt1WcS+J7bGl+Z7mKyrMn337ozS+Q2AAXnFKLZ5DH9zDesR80MVX4npXEppg2dYztQcZ9cRTYHpLp/VOWvA91RwFCcIIKW59UO/XkuUTFmf79TNHMN2LBac2hJTwYJi4E23XBOOcEca/BY8GhidxL0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Apr 13, 2026 / 11:57, Lorenzo Stoakes wrote:
> Commit c50ca15dd496 ("mm: add vm_ops->mapped hook") introduced
> __vma_check_mmap_hook() in order to assert that a driver doesn't
> incorrectly implement both an f_op->mmap() and a vm_ops->mapped hook, the
> latter of which would not ultimately get invoked.
>=20
> However, this did not correctly account for stacked drivers (or drivers
> that otherwise use the compatibility layer) which might recursively call
> an mmap_prepare hook via the compatibility layer.
>=20
> Thus the nested mmap_prepare() invocation might result in a VMA which has
> vm_ops->mapped set with an overlaying mmap() hook, causing the
> __vma_check_mmap_hook() to fail in vfs_mmap(), wrongly failing the
> operation.
>=20
> This patch resolves this by simply removing the check, as we can't be
> certain that an mmap() hook doesn't at some point invoke the compatibilit=
y
> layer, and it's not worth trying to track it.
>=20
> Fixes: c50ca15dd496 ("mm: add vm_ops->mapped hook")
> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Closes: https://lore.kernel.org/all/adx2ws5z0NMIe5Yj@shinmob/
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Lorenzo, thank you for the swift fix. I applied this patch on top of the
next-20260410 kernel, and confirmed the failure disappeared. Good.

Tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>=

