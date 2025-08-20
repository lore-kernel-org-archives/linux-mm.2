Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2932ECA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7C76B00D9; Wed, 20 Aug 2025 07:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF9F6B00DD; Wed, 20 Aug 2025 07:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96CD6B00DE; Wed, 20 Aug 2025 07:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9625A6B00D9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:24:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45D0CC04EA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:24:31 +0000 (UTC)
X-FDA: 83796902742.22.3E960C0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 20BE6C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:24:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I7ZMPSy0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pAzoXWNt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755689068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RC1wHnfGuQ2/b4i0bPlr2yWUrb/RtgX+Y4fLw2JjIPE=;
	b=2w9RmjenUKqGDnssM2dpY2vh+/0c2New77wPcmohTVJbvvM7hiaUHGcx7EjPHQIjsj6tZp
	xc1oyHGzyp2R2qS1oOoAYI8LKGksvkBJfU+A4GfnaMD2f9C69xNowp3v3tamMQj7LQaHB7
	0n3wxfgcTsGTK0c37dplqg/WYitUbTY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I7ZMPSy0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pAzoXWNt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755689068; a=rsa-sha256;
	cv=pass;
	b=xzJ3J8KDv5ewjLZIQDE2lw9N2uQPcWVxRDPJ3DTjzpq4B6CC4nmNHqcK0WvxPKq/xU1XZX
	BJnxTj6yq1ywm9dvt03gSijJ/6PBBqAj/UP690Nwgq+5BQPLIKK1T4MEQUdKurtztDZ/D+
	Q2g+utBMblP1KKoz62v0GCHP7Ak+pW0=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57KAxFLN012214;
	Wed, 20 Aug 2025 11:24:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RC1wHnfGuQ2/b4i0bP
	lr2yWUrb/RtgX+Y4fLw2JjIPE=; b=I7ZMPSy0OZrmRllMQpIxehof3MzR3X7tmK
	wuJq9oVicNPSqwWNICdxSy74CnRG3MqlISpgej2Lb3vTC+5LxPNKtusBmIIfvtQI
	8Le2Ho0ahm72QyFzccS325uJvZwpjRPfoS6+uJycd+XOUqfgaL7voym4I39/0XBh
	788bEkDu/nkdrtprfl/bxMKbU/hS4RNy+1RHe/5YQg59M8dtKIW86ZJQ0qbslX1N
	aoJdZew77bOugdHiq630KYp105E1bl7XjcpK68jN52y0Na2goGtzQzUPw4B3visG
	FSLLNG9fMml56brAHrV5L8DqLNJV5aK3QYaQvNhiOc6/4ZuZBTxQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr125t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 11:24:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57KAkCDI030334;
	Wed, 20 Aug 2025 11:24:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2080.outbound.protection.outlook.com [40.107.212.80])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3tw154-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 11:24:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qp6xEvR0PknpohkMG6yL68jR721wNqbczwfYOKyGHPUDnsrcxjTC6ZeyPs0jolETbAbtcncJRpXMCBqapLrp/vn0om/368J5/MRUXPC1IW5vua6CBs1wl5ZpBKXwzjbmSQt3oy21u/dLboyf5EpjBLehkk5iT1rDaC73I3R10MNhbuIwFUn+dd69N6oW2zQcsAE3N7BIDR22h4evImh017QmtYYrmAn3WB7IV5SfVZ5t2MX6GidiEptVpzwWxJsK4Bk4e86XmXSrVUJf/R38FwFrfZMb6vhELfsAohzLm0IdTPINfyhMUYQ6IZ4Aia2xSREY/+z9Yh3g2gpH+QnGTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RC1wHnfGuQ2/b4i0bPlr2yWUrb/RtgX+Y4fLw2JjIPE=;
 b=ocDOirmSdXf+PkZGXTJnU4Jefg5gSLLHMlSjmsmqCDo60yEh3hE/ncvPWuT5ql5WI4DmK7YtM5auqN2RFm9IT1/S9nq5IIqJD8GoYmFHFsGV9V+7rmsNcfpLf8+FKzZPXjkltjQtdCBB9j1dyZEvB0gL4MLpV+qDujyRLqyb3WNdSv/V8x56Nu6dorDGVY0eDoA0oudXKWkaFNtXXApttyNG/4DVKQUTTXQnyasHjAt/IKEnrMIZIbcYyDUfwb42+X63VzwSa0sgaa1w98Kddo5EnKiv3eBe9UsPlSivZ1JamXK5+zZjHtQ2P7gwJW89shE2Z4JafVhHZbslEMUnQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RC1wHnfGuQ2/b4i0bPlr2yWUrb/RtgX+Y4fLw2JjIPE=;
 b=pAzoXWNtqlctw/TqVBpKMIw7mnpidFc6G9yVwSta9VrNrXw1gbDp9CGA/4VNM5q8MfnluGrG7TEW84Rjzy4H5RulWATVV9hgUzN6VpkYFLuNYLepr0pBiDPLjRie7zyob7Nb2On65JEW3TbCZo7te3sBuGPl6UyGKIJOW5U+5GA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6363.namprd10.prod.outlook.com (2603:10b6:806:26d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 11:24:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 11:24:15 +0000
Date: Wed, 20 Aug 2025 12:24:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/3] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
Message-ID: <2c7f0625-9810-480d-b29c-43b5cfedef3b@lucifer.local>
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>
 <uvh2e2jjdk44tdwrhmnd46atwgdzwwmny4kczxqv2vm33gjqpp@63lsupn6y2u6>
 <fb880acd-25df-4386-a13c-9b68640477ef@lucifer.local>
 <jmjlamoqau6rs32ldggra4ojiwim7b7h7xtgzh63m64xejsid4@cdnae7mjdeh3>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jmjlamoqau6rs32ldggra4ojiwim7b7h7xtgzh63m64xejsid4@cdnae7mjdeh3>
X-ClientProxiedBy: LO3P123CA0032.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6363:EE_
X-MS-Office365-Filtering-Correlation-Id: f78b2d70-0e04-4657-2f35-08dddfdc1829
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GN7KObLYqGDAEoIMQ0yWzErziEPh97z2syVVHtQ2x+dPyYuiZVVkp+hTsdHR?=
 =?us-ascii?Q?3nhFH3jiJu0GwOvZszjV8HpaKJlcbTAVQ/Dk8X7Ruc2pkPPCqeU/tRnIXLGZ?=
 =?us-ascii?Q?8NQtNg0JzwJcTzu3VjCBZsa6DGDNIGQnkroIgjyWoYjS1cx0v/7ICVPYqpFi?=
 =?us-ascii?Q?gahO8COkOGzTcsTWMf7sEpLeVvSigOGokmQMqs7cEXW5fKV7taf+Ia8nnojg?=
 =?us-ascii?Q?QOR7KSoU2WPNlbOscDI15bw649TmzqqwItSl8kmZqZL40hldQQRRPILLd4Es?=
 =?us-ascii?Q?iyh5KZROBfo4r9EnGgagVsZedIq3MEZrZQAROGAgdsR7oRyXEPARwgdT64aD?=
 =?us-ascii?Q?WkdKhg3SoLbaOA08EWFNPI1Va+lQT/CnsXaSMuaLR1TNpIAm0SiNpreUsl2i?=
 =?us-ascii?Q?HYPjir6IV06JC42mbt3R2RCzfq3342mblc7Qk45aRi7bSjF64yMCim+N88Zg?=
 =?us-ascii?Q?ofPsqu2MJRD1n/r8wY44te100e8zFWYD+h8hbfR3VCEmFO2K2iFXPc+5HQpq?=
 =?us-ascii?Q?AZ8t5bCHuxWcr/lRt0ZPYkwKAoOopkvU0ooDmgE5iQX+nyojPJWFwfZc5XhV?=
 =?us-ascii?Q?YeKAJAKkmfmiDiRnIV1JChIJXeMfjRXhe7DgNm1Vug88ByJ5W7kemd5PJ7Yi?=
 =?us-ascii?Q?uqLGl9D5LGJ8bz1v9jTi+YBJkLBiqu9wUqiVhW04+0Vb2pUk9HBzCirg+6SD?=
 =?us-ascii?Q?rbY02jUllc/5EY9TmodJCjUEGVqA3VGuZven3f9WjUOO7w4NwHdbqoN0lVq0?=
 =?us-ascii?Q?y2Lg9XRmlZ16GWQbahJFO3mDuWth8esG+hGRhK7ST2rSzskAy4SX4J/rp0s1?=
 =?us-ascii?Q?HdIdb3uaWgkl9ZVLrXcqYPcE7hvYk99H/lQnmA9r7UmVu/B318jazdLmy8Eu?=
 =?us-ascii?Q?FKIHfSkBS+uoqq933GpgpWHej8fOpn6cNpwyjNMg+zDrtMt3nR6Y0KMDQpyA?=
 =?us-ascii?Q?8KyCUnyAEipKvO2wjFUlVNqYJyJaj2/Qk+9dytVwNrcmIHACrUsNRaSkU7Xz?=
 =?us-ascii?Q?VFFAgOxGWmWEeMZj7LsVNL2pB81wCi3Cdp1wXVChrnEYgzeuBXFMGrwfnlq8?=
 =?us-ascii?Q?+iWFlx/RAHfqyoM6WzMKOv3q1zZSG+alTCzaB/S6MRfH9LoOFRW0i2NerOoU?=
 =?us-ascii?Q?JM4VojuwBNwb2fdKrZSZioGgBSlayNS4YKueCD8eOJdXLGRxWyesAelMTvDn?=
 =?us-ascii?Q?qPrRT4T+x3j56HweJljGTS5z+UTnThtXI08RNELP6wRIuYhpMP2xUz+akt4T?=
 =?us-ascii?Q?uo/9ruR2xRLHWMfzAyTgyk4G/1OcxBiXXI4IIwENY2hQb2NxcY93ZLCKTtsr?=
 =?us-ascii?Q?tCqzrREwQiF20KqnvJ/kud8O0AHFIFaiTH3bRfsBuOCChVURMTcLyyyr+HZd?=
 =?us-ascii?Q?CUmA4bPOGqpIfpylHhDBoMr5VC/9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yMQM1q4In6rs7SVWNyVtl/sH+PVvcfuNj+LVx7AD509OiDT92D5uNy+Ibwah?=
 =?us-ascii?Q?LKckIorDhCgl9ztQpSn6YJEchJAFB86RrVJy0AC8kFU1gS9kmjiXiTm46emr?=
 =?us-ascii?Q?A58psZPOLNzTG4DrN95xiFlR2wYoC9cGzTVSh4A+lSq1j+mKJ+3kmzDq8Rjw?=
 =?us-ascii?Q?9j35nLsUmE4sEURxCZhMyrI8QHYUatMceD2iLlrKFSfi4o82xK5mtbDnLVla?=
 =?us-ascii?Q?m6i272qGsck0KXFxoc4jRdmVNw+JqOS3CiqItSCFioadNGkOuVAtNaIyHo/o?=
 =?us-ascii?Q?+bMaJomchB6ViiPw16FEL+IQ3DwIxIR4uBhd6sLNBjEbJHADFH2m0kUOrljs?=
 =?us-ascii?Q?LQKRHgI1bBU2KinACEFYzP+qXl0TWoQSKJPGvO6ufVaGSuMSNlxPL9gmOO/2?=
 =?us-ascii?Q?WDoRGOQw2bbCaZtTi9wzLdAoHzmNILHiE7oUaeBGDBcEUlU8i9hsEbWj1oHF?=
 =?us-ascii?Q?+e2nP9qoKYq2/pJugViz0SaTFykd5hh09f4QyUsJFS8JvK0psG5+G8Tci9T+?=
 =?us-ascii?Q?nwzT9TJKoofmFoY4xmuq2NouTEvJkHKCUlxlxQUvHiOEbjRRAjWUGODxXJuu?=
 =?us-ascii?Q?v9BUHP5jFne17mgQfQIXPFXgmlioIYv2KYwTZoJhIgMt9XIf6N5j4v0tfLpo?=
 =?us-ascii?Q?k0CGuPON8qx/tye5/zbHi2s8DVLdQg/MD/bcq1vaOPPUvwtZbRwwLcR5JlD4?=
 =?us-ascii?Q?2Wlu9rXJabveGDFmkYJeaJjZHSCsLhDKV1HhZPDXVfA7NcBzQi5ZRKKSaiMl?=
 =?us-ascii?Q?OogkaK4T4JvAqZNzTW4KALbQJC/uerTsb5wrCI10jKzUBLdJDcKI0akz/THx?=
 =?us-ascii?Q?1Ty01no0/zj9+On56ZB9yZNoUSM8xvokOXl5vwGPwzRUM+VLXBNMwtC2FbJR?=
 =?us-ascii?Q?7clDtB29na7xWPRkk2QhDbkguPXiOCY6To63bDakUqOlAm6Ldh2ofNbtGtzm?=
 =?us-ascii?Q?bDMY4Ku9mH4M9Hl0cZSXQwUmK6sfxzQ+COLCEV5IhErkhhthmF3CQzq6I2Ks?=
 =?us-ascii?Q?6+gCiUpCJbfInDvB7Etz4vjzx7tsy4Zd+ehSpCggUA5T2ek7iBC0ksHwnkFC?=
 =?us-ascii?Q?rMX1cjC1kSNWqkbKWCBKpsU2md6eTD4m63IxjWLjAr/Li/b95hE3p/q0bbjD?=
 =?us-ascii?Q?H8qaViGEu9+K4Q+/pMcSoiVXP63uvBp6VczGDwIZ6WlVETmp3osXHlbb9RTK?=
 =?us-ascii?Q?lnIH06RDAlcX38lxPwKeK+1yV0ogjM3cKspnOTeN0OePxt2DXhYxA+nRVmNj?=
 =?us-ascii?Q?xKeRwtshr3qFF3MnN/3bgT+BuJPk31SB+u/98VCFWV1TLjbmFWhScjWYTKX7?=
 =?us-ascii?Q?JDuaxdpEm7Gb5VcaPdkAoYZ32B8zQbNHcBTBg0WGJPVHNfdeO8o8KxRqRot/?=
 =?us-ascii?Q?IDwwXySlq3GvZRLMvjMrVTDSp780j2UOYgTw1eu7hpEdFlUxND5VoxRK+dTw?=
 =?us-ascii?Q?S6uUl3qGvtfBS6V1Jz0BJ13tqLp7xTOKDDz2mkgQAXwpi6EsUL6sIyu5Oahm?=
 =?us-ascii?Q?OB3Oh0dZoBj06gysZBb18JoXfG7uluY535oQM+qhI5gSAX4wez5hFiAa99zJ?=
 =?us-ascii?Q?OJnieeCagtNBU3O/VzSK+p64B9gOFnaWt85opyY8Rr9VMbCXgPuXg1eS9I1r?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wvh+VWmmJUJfyze5TtOem+x3CkExN7pqCQtqo97ImayHeUQGzVw7OuD/fK6zKuNqlLijDT6r/kUgH98VQN9g85MQF3HOX4FQp4YSazy7ihwA5lN9+DwefjtFQBsQTi7FseiEwLxw9X7egbYvwwU3yIoLMCWBhjPrgAM47vsTexx3jmmOtx6fM+0gm6TIBRP5lRhaO9eFc3UYiySX71dU1v+AfZPst1J73/ROR93KHxS2BEL+pSy31bl3H608t3i5uc6pCezKTi13tCtF5UcWDXCQPKSL08EkmlOP0lGYuI0wY64GGRVKcjx6TgysYqNfY2kJLwT5L01mVHRMj7UMiZAHUV7ue2NVZ3SrfcRLDbXxuJsFais7Mvcn9Iyv0IQvx6gThcBaLw8Lf5eJ24/TmL5kZqG7SDv9n+9DtFNFDcfZih+6+cMb/z6qANeO70wOF9OpDNR/BvWMoesH7KgwG2M5QqW1l0aGx1Io/KVkfDIm8H7XMtKzH757wVV/qmQC0B4zXMF0SvQAxudlie/NznnNMjj4l75NLoxTs56uL0zOV9gTDMQxT7lwsm05WlGy+5GMCIZJ+2ZJ0KfP44lPFUf1EmhSbZoDnqxk/YKrKYE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78b2d70-0e04-4657-2f35-08dddfdc1829
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 11:24:14.8549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kvi6t6YfERGi4lavfdiJM1Be59d8nWmsRRScQjvjhaBexpvVN01AAbcyzuud+gHc/G2/kI0R3lcoZ88NqBxoRBAOEsIJLTT58GpabGoyULs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_03,2025-08-20_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=995 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200100
X-Proofpoint-GUID: GL21NMdTIOUTqtYPwMqWOjDcGYWnrm-A
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a5b067 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=MEjK9-KKAAAA:8 a=rBu-zQOFr9hPmMrUqdUA:9
 a=CjuIK1q_8ugA:10 a=wDCLW6yMUrMVbYbmd6V3:22 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: GL21NMdTIOUTqtYPwMqWOjDcGYWnrm-A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXzVeu2qFjZhFo
 wR+2iwfUhQ21/FdhmzGeD1XW52ahM2kv/AfIQXncdcze9mRoaNJvTDATHSRz+aSrco0KRVbbrDb
 2GydnAafzB7Kve5yWocBQy+Wk0MwuUn9a40XSGdes9NYLhxCLOVLFJF0dxelQypPHTWO4i21dkO
 tROchPyEkWf8LPDJRvr/QzomC6+oGIe116fnBZAoUthx+IG+VNbQFFZgeqxDDvHmyk0B1YDr5t/
 r/gOdG+2Qdh/sukXyCyG3TCrfsHjIkCummVpx5pjdnuaIYtwJYRuI9gP9CLKRpWAJbTGj++XnYr
 vBgkgLnu//DeeAj7/EfH9pdtbAY2/SpQByg3YE5nK0adQ+iseORtdZtsenbVkvMz0G4SDLzu70M
 YHcZEHi51oHJgQAp8QFb8KSNJQ82XbBe/ArWTDfyku4D6QlEi6A=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20BE6C0007
X-Stat-Signature: 7pwrnqci68zz41odmy8w76ey97ugo4ga
X-Rspam-User: 
X-HE-Tag: 1755689067-513301
X-HE-Meta: U2FsdGVkX1+2bfYlhOv5N7EJpDlO2tj1Jfz+/3k+TLA1twLqPPf8MR87Efk2xAys9BVydfSgtyixXxLI2hPPpAt/yKrvUQgXJXGiKrkFKEbQau+h9H2yv3TzB0fz7M2g5ZpDchOpm7yiDto5ClNyvj2crEnqcA+5LH7DgAmlnAhLe8lvXctNABQv37eyuyBz/+/UcnMZKPx2dOu63CpwDITK6EWgsviERWCeoArzWFiSPeMrN2MQFQfQGVDkzulmcLhkeUTodBnUHUwB85iPXOiiONUHC20JWuMWs2LLYwhiBQSAq1BnRX+rItV3lm148K4JCtpX9ZXHL0rRouDXnPQZioR/CNqbUft2hz39WJcYsLOddjPBn18nBVSxjmAF3E/Vr7SeY+nJh3yiO5QAmoBn1IbSIOcpte+Zp4ZGMeSy5wXwTWDOoPz9jSzZZmeZZCAxF6ram/CSrvfrlWYbwV6iwu5J6+XZcDbSUuLMFcXXafh4ZFENYLhmzDRkdwQ9W0teBa0iecafmEQ8e5YLZ1fWrhbiZl2yfBgNIHCAv/KboyhuO9hMbf7EgM7aqMPqN/PNAMsu2ARBi64IwKstZK8JG0T1ENBDOIe2Jvhm4fBLYUYK0nWODQ2pt7h39aQ+eAmDZPpJBe7/PMNmLZPWDNJ+PzK9sZAXm3iLR3jK1Qi8XVd0Yv/I1zrfphTCKIyqIAcUVNh+pJh8x4xhgYC/b4WfoulHURG4mzCbfydvC1vuJQWmp9bVUdO/DunzTRem0th3r7Yeu3m5yckIOZSXtNIDFzKDjeUIl8Wf4SdFDxT1Ok2RRyP8fr7oro2FafpBc/PFpLKOKkwY1G7WXpYEF+7QWE4hBSV+6iOtMZity6J5+xQCAQ6gZWbX7F9ex73eORaup63wWAB/jSD9eKahQCGnk8kSDQjyNxHF7dE6U8FT20T3tOWC7BEJLnns/C3SXpFn6KVM+v8uHbcXG1o
 y6k70UPw
 CZaC+bcGh3ZKF+tUtED3qdg4tmn9EoqdZNiUum4ZbQe/2X+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 12:50:25PM +0200, Alejandro Colomar wrote:
> Hi Lorenzo,
>
> On Tue, Aug 19, 2025 at 09:37:39PM +0100, Lorenzo Stoakes wrote:
> > > > diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> > > > index 6d14bf627..53d4eda29 100644
> > > > --- a/man/man2/mremap.2
> > > > +++ b/man/man2/mremap.2
> > > > @@ -47,8 +47,35 @@ The
> > > >  .B MREMAP_DONTUNMAP
> > > >  flag may also be specified.
> > > >  .P
> > > > -If the operation is not
> > > > -simply moving mappings,
> > > > +Equally, if the operation performs a shrink,
>
> I've changed s/Equally/Similarly/
>
> > > > +that is if
> > >
> > > Missing comma.
> >
> > Could you fix that up? Thnks!
> >
> > >
> > > > +.I old_size
> > > > +is greater than
> > > > +.IR new_size ,
> > > > +then
> > > > +.I old_size
> > > > +may also span multiple mappings
> > > > +which do not have to be
> > > > +adjacent to one another.
> > >
> > > I'm wondering if there's a missing comma or not before 'which'.
> > > The meaning of the sentence would be different.
> > >
> > > So, I should ask:
> > >
> > > Does old_size > new_size mean that old_size may span multiple mappings
> > > and you're commenting that multiple mappings need not be adjacent?
> >
> > Yes.
> >
> > >
> > > Or are multiple mappings always allowed and old_size > new_size allows
> > > non-adjacent ones?
> >
> > No.
> >
> > >
> > > I suspect it's the former, right?  Then, it's missing a comma, right?
> >
> > Yes could you fix that up?
>
> Yup.
>
> >
> > >
> > >
> > > Other than this, the patch looks good.
> >
> > Thanks!
>
> Thanks for the patch!  I've applied it with those amendments.
> <https://www.alejandro-colomar.es/src/alx/linux/man-pages/man-pages.git/commit/?h=contrib&id=21b1c7188ce1d66ef294eb1681361315a35e8070>

All sounds good, thanks for doing that and also for applies for other patches in
series :)

Cheers, Lorenzo

>
>
> Have a lovely day!
> Alex
>
> --
> <https://www.alejandro-colomar.es/>

