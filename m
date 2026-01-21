Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8CAEC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA426B00AE; Wed, 21 Jan 2026 11:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E456B00AF; Wed, 21 Jan 2026 11:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14AF06B00B0; Wed, 21 Jan 2026 11:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00AC76B00AE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:56:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0143D3644
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:56:56 +0000 (UTC)
X-FDA: 84356575632.21.68746F1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4620740018
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:56:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SvME/7Eb";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RKx5TT5q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014613; a=rsa-sha256;
	cv=pass;
	b=nOGGeXWP2p2Kk8ZtYschWHSfaPDBVk1rDYXtOLwHtRZbwARjr1mlJ5wpLL2AAPhBl2E+ca
	2PGMeMX8Yk8Kpfa08N3hCbvnwAvFTP7ELjNB7oEXnOCMeQMpCS3OmOQOIhzNETdcDSXq+J
	W2POL6Q+ZanNwd6I7TbbHDZGHdxlDEg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SvME/7Eb";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RKx5TT5q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hrud5Q+hrQuCcR4Fv1ZyQ+/Vq623TnVLRB2ezBWGlS0=;
	b=g3lKf3j0WxJf7gOtvDrD3NB+Cl6A1VvtzOA8ZlZSYxywSRU8WzpZzRiA684o0yZE0k2L5q
	9EN/6A76CBA4/DdsQBqvJHzfavbUoiWCs5RaxVfnFYflqZzbZeAlgnLmQFP4PCyh+x0bFH
	ZB0KXxyY8PewgZpOQUWkBdus1hLnoiw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LElKjl3523898;
	Wed, 21 Jan 2026 16:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=hrud5Q+hrQuCcR4F
	v1ZyQ+/Vq623TnVLRB2ezBWGlS0=; b=SvME/7EbP+dtpwjIykCdkaj2eZbQN2tN
	44MqWxqax86KPz+t0LvgQyRTsenGavhESs4mf4nFdFLFoixGU0/F41bp6N4+8XI7
	2Tlk4gOHrtfRPS2t5YSjl2Kzu05k2aQwIql3Vuo7nQU9xexPFT+yO/v3xW1ldn+b
	lb/F5wx4jW3XwWHYsR1FNQk0ciKnKSZmy/dUESF+BDBMvGj4pSU2LlUeb3NNeYji
	7oRHUC7pHocgSTWxXHC0ANWf8r1jGTRJexYU5Us1Wu1bqwjDGUCc3L5hCSX6LljR
	SUX3C8zF9VqyoB5UzyaUcOibJbh6obqvRT4hNFKj/HaSfI4RSXNU/g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qee55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGXtpd008491;
	Wed, 21 Jan 2026 16:56:44 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhs9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDFyCLe1iHWi9VXilwwmu/l83ik6L5DstoU/12vM+cowDKGkWzQuuTfaLMJHMZ2NMP6P3tmi/65Zu4e++9lWFvpZ5wp8ZQecGwkaPnWaGPmUnM2nUmwL2hZ+3q4Ha8+4ZHzP1VXOvDn2ZB58LxgJPsqrnikgajPJ43tohsvsk2hcL7Oi8HCMXGL1ipWDohM4Xb/wEutuS1DZR3lV9RhVguVlcs/7lh04gIPpr/2YEyb9fMFomgf4iUgB4wiStT5Ae08mfEcH3WiipurxpYSUGY58zXn6FoXjdZiGITCMmF45j/lS8n++h4I82Qkc5wy/b2LNN8Qcbo1lMvztm7ISeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrud5Q+hrQuCcR4Fv1ZyQ+/Vq623TnVLRB2ezBWGlS0=;
 b=Gd5V1RCcqalxdAgdE1kRnuphuXwdCkfbN8njxIwUIZPsonELLW8WVIvTIKT+rZG5zgamiwqoDfLUz8X0TRLdyLgBI8IORwdiqXW4Rq0I6SB7sfWSFwq04M0qIGqGJEHI4yAsPQ9muJIX/OwL08F2XuEBV4hRlPMgeJfFdSCVhx4iV6O/F98YI/vNO9yHAJmY+KWrp3eVDrnFYJ2Mcpk2g7PzhctreSqROldgPiomLwfI5KA7hM4htqjQL8pIjL/NHKVL5qwgwQGPN8Vw7By5ZlS7bIN9MUfCDfniqDFsGbFn2MyhBcTBISHq0pqP7x9bTw0qOvHhP9C0BCojwZVJLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrud5Q+hrQuCcR4Fv1ZyQ+/Vq623TnVLRB2ezBWGlS0=;
 b=RKx5TT5q6y/1GJWaW2ZVjSiqlxCs2prJ2SsId2CqUDQCecpxE67IHMPXkswprTE2XZ1kj5xXA9KX3wTxOFdKbUnVFAOYzRVcN3rlbyLYDhGGZGcgUkIzx2ejKhFDu7bSUsjFn7F84RrjMG6MrvrNpt6Gm1SPOeYb2pxZKQSKafo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:41 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:41 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 00/29] maple_tree: Replace big node with maple copy
Date: Wed, 21 Jan 2026 11:44:57 -0500
Message-ID: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 816f3803-81ac-41ed-bf1b-08de590e0d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dEIUBLjIksAgqo/bUgPtWTFJ68d7cviv191WWTYDU3alLEg1LP3ZR/aaiKjn?=
 =?us-ascii?Q?uzdp85SGjNjpuqxJ6FXOPNltSZet4B3grbAKvEn1QhCC3bHU8BD+e0KcLZVz?=
 =?us-ascii?Q?66edHLlo6iAEQM1zICilp8TpMuiXpZiFiX3M5KdQwKnGfOZO+Pz3E3Eg8ycD?=
 =?us-ascii?Q?W6IRvYrpuwQHC8aIpgve9fO7WRWhVpEoaO+4R8PLUMW9HzOrcvb7fe9Qa2Ad?=
 =?us-ascii?Q?QIBErWunU3Sp70lxsSMy3BV9PqDJTUGfUAA0/ohkASmhJ2WlLB4TmI8+PrqE?=
 =?us-ascii?Q?WXAZBBxPVMUUsMll9xmHBOgx6Q28hqWJ4g13cJYJoyhew8R9inpblXMDn96l?=
 =?us-ascii?Q?7Vav4jypIWxZKhChZZ+BXKINfi1UQf7a99820FDbRdhsggkL/n/tCdrOCFop?=
 =?us-ascii?Q?+E5zwr3mg49drldVPWCmUk9dORvKXlfETZHRNDALQscpcLjfb+L74mONCR2k?=
 =?us-ascii?Q?X1x2RDatMYq487vJniKyXttH1zfowr/caFhSonE7NQoR6DCXh7LUd4CgRSc4?=
 =?us-ascii?Q?WXHBccbacrHYLyzKKKl3naTq2ZwTgmPAw3T9zE09Ez7ryXaBH0ErSCGkaU0S?=
 =?us-ascii?Q?oHMHlnpmDmh2Zx1aXRF4y8zowvfSLwzaoLCp689P5vY44WeV+dA7ZSj8a2eb?=
 =?us-ascii?Q?llugvNdInHwPp5LfNx9IXY754x36zavUYri/WPDLFiLsoKrq+/tO2G+lC/3j?=
 =?us-ascii?Q?SkLPXRS7aSm8p9/UrOiSq+wiBp8+Gpx6bUSZr0Un/BF0IDRUCf7phOeB0k3w?=
 =?us-ascii?Q?qAREesZIKAYyXRZatoYyDXOa+Q6XuVObSGaRfjnPSams3DvoWu7us1ody+1w?=
 =?us-ascii?Q?u7TwFLtjCy4Di+jxIbjAtOGSIqOQZb75NM4et0NHXJk4ng4WuesEwhRhP8Ul?=
 =?us-ascii?Q?PpLqa5DtJaynLUSm9UJ+C4//43bG13vqPOQnspFRSYmaMh1/jo8F56KO2Jxc?=
 =?us-ascii?Q?0f2K8PBEZ4TVb+j4BdtBxMDwlN1gs4zXqTVIQi/1JPgsHO9e4CqxNnaTtA2r?=
 =?us-ascii?Q?Ttn01LZIf1VHhq4TcVuTqm32ePVXwF/L2PxfUbWXjLsD8owY3fmkknR6nv01?=
 =?us-ascii?Q?hZwhjEcXfnL1f0EJToWJnbqts3NqGaI5AtGV1OvZUn//a5h4YAzht4HSczdC?=
 =?us-ascii?Q?u0fbugsMsorCSflWy+AA53GA/6YF5478dcyG2g7LvIwg/JlNckK5XGNWkP7z?=
 =?us-ascii?Q?kLKI1tw8Ucob+eHLoiaQW37kN4NCxArp4F9oM6pZj/hrNVExEYJneJ4p0ov9?=
 =?us-ascii?Q?BQuM5jTYT2ViLG2EbQUPzhz0QRXKSyYReIS2LdJashvD4qKHpuMiG66GIf++?=
 =?us-ascii?Q?FAakcatBvRopcmOv5kP4+9G/3Rgxv49uOlrgQKITgfpQt2lR6iglR5DAHR5B?=
 =?us-ascii?Q?OcZpmeUBpLn6P7suXyoxZ+aQ+01EU+4ZMUKfiwwMNzRp2OE/H7648S1mTHW3?=
 =?us-ascii?Q?u+xSM5kVgC5cDUJ0i8m3AAlbn5sjx/1wzjJq1ejcu3z5MwHokySW5uKsz/gg?=
 =?us-ascii?Q?nflrna7tBi+1zg3Omzz9zTEzh2N3orD0PQm9CGaVGFSEKlKBzxqP0YMqd0S+?=
 =?us-ascii?Q?Jx3BJNkj+Gy3ww24uqM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kre7gpRU8g+UW2Nv4yKY03iSbqfjW4THiEoOJ/NmM0HzPMxJXTr7ZaPn1RQy?=
 =?us-ascii?Q?+hUAKc5uYcsCMlSB5IM9RbAHvYZmp4ufEjUWzuyb+ogXlA9yPlhTiD6hs74K?=
 =?us-ascii?Q?1BXPG3BUsGJ2VgOVziHh5Ru//qmE50Y9/BBRxjRRfhh6b45gXsoAmNfb4kWA?=
 =?us-ascii?Q?f5TljlKuy6x8a902WnQjAqwjTpH6OUbw97zDEwLws916pkI5FltB5YXcRWXA?=
 =?us-ascii?Q?EX1BkHn9K3HL1sxh2kLRmawbdOJcX/EoMalUc9gAjCwrtF+dAsFVU2HrqLQt?=
 =?us-ascii?Q?TasyZe4cmHaNBM6m2Kjo8GpLIqHurkJRKphzAOtQZTzqp83f93whd3fi7rMg?=
 =?us-ascii?Q?UpKH2qUq4njun6lyWEvSmo0qs9id5jJ5eVtw7TfFi/citVak6VKTNrqmf2UV?=
 =?us-ascii?Q?BKKe8umgZ5hXahSNrTweClcj/Ep0LmtDZoIhBkXLsRfO+SkeMUfcG73mgIpY?=
 =?us-ascii?Q?c431BpjXP/POuQzNtembHPHETrbHLBZGep5qg7WWE6lP+LXA2I6vAJ9zCdks?=
 =?us-ascii?Q?r90vOehQrntIB71E0mdQSvZRInlpiX/aTvrJY9UeU9a4v0agDzoQ6HbEx7/O?=
 =?us-ascii?Q?XRX/z2TSEbkcDcZXNoun5jF6T9jGqK6dJYU5qCONU2PAZKskOQAS6c0g3tPl?=
 =?us-ascii?Q?nVe74CZ9EiLUxK+szzsC6vhdqWtdMLnxV+c9+O08+IoDNu6aJhbtD8D3VQOI?=
 =?us-ascii?Q?x8ZRa157zRoP+oXbokuufiDqB02M2rrIS8n+Cd7URuxgYAQhaL7AIRd7N/Ep?=
 =?us-ascii?Q?1Eb8GucqseY945n1tT/OI1jjZmqrpGsomQCl6f6Amnz1yIGUS6EUUGkmsvku?=
 =?us-ascii?Q?OOWZSpjj41KWkrZBjF+q8zfuMQ79RadTk4curQVxVlNvYCJS2pmBkOTnDdzA?=
 =?us-ascii?Q?D8z4OeInNPcOZum0jeKjwPMFkkQxt1lC2mtBpdy2SNtW5xn/RiOJTnbif1NP?=
 =?us-ascii?Q?eQI7ny8R8VPQfseQDMKHKSuj9Zf+Cycg4Xv/xwS6xTNu/cL+xbdvsXrSMRM6?=
 =?us-ascii?Q?+GsyItP+fq/jxlvqp5yjmtAhBRnz5nPogWyt5+HWmwxpx2nLIH8loC6b5Dqb?=
 =?us-ascii?Q?lzDjH79sWsb5QaVvX5GN039/6qKdlZ4qWnnat9UYxigBMoeLbKppW8D1R174?=
 =?us-ascii?Q?bUmIBeWhU9G0Xo6MlKmJCxj01+SlXsHP+j7QtCzt6Dc7HzwhkxauA56aycrU?=
 =?us-ascii?Q?acuAbxG7R44rogMLXgYkp91cxZtUzYD7ksw6rfKZLCnt28eSv+dFKq+8FZDk?=
 =?us-ascii?Q?hx8ZyooJYPoKGH5iwhPdbQVvdzv0vgREO9elFAD3f8/RGYz+B06a8yKP1ldG?=
 =?us-ascii?Q?LDZKD/KAhFQma+1aDAypyWYzvbPBKY8miAoaFgPapctfX+Fw6WcylfhvcLDI?=
 =?us-ascii?Q?HaNh78h/ka6q4i7o/glInkw7OmvRpZFObkyM3AeX1bIVfJVQTfdti25MjQm+?=
 =?us-ascii?Q?431dc1e0rwgB8YxMnFfdD7ZNkawKn4ESTvH3hjyBFuuBSrCCIKpLz7+ovjWE?=
 =?us-ascii?Q?y5WnXTeSWPAA9BW5OrIRjwlC+L/rnNCMh5MWpqQL40Ev2gK2pXT5p+/zTvtN?=
 =?us-ascii?Q?yrRa05VBmV/L+VxvlGFsp5SLYg3aS6YQqtkYI9HkQCFNz2pNQVLc7Kvn6DVG?=
 =?us-ascii?Q?kiBNbuvQwrbUHddHo9k/SZE3JpHJDufERwEMScxqwJSETlqbcZMmdkDAGi7C?=
 =?us-ascii?Q?TCbaTSjdLUiABKYSHcP3ZNYReccKK0zD9BimZP4+2eHjSzvyzbLepGEi8AUA?=
 =?us-ascii?Q?UmvMu03Q/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z0xxah2FEZRgidhd7SwsZrUhglbuuzJC3iHXX0JkEAShbi6pavRP+g9kyRInFTGiwA2Ce2kc3q3m/7JA772m4M+DjjnCrhnvGzfR9SJUXTU2rmd7FNftGQkugy+BuJjCVP9mheu5d4JNvVQ789KLmgw/r3Jzm7kXSmQrXBNq7FeDR0VomKcSXWYXcPM40QfrdI3bnEpdXNBy/hQH0f4I25kqnl9vnGWXGf0ICYkZmods3rZ4h42ZDU5XI1B7imo612sdZd/aVGNSmOJ1RY9MOaY6oP3WMA9jVkJ0EO5PNmZXK8NtoMBri3ibyAuIMjyrhbSu4BnmOS5AuLVD/6K4nGQdQuQYI/3vK9wE1MImNf2oRVnz7kMB8VoGM/X4vbh2zycVgTIsX1YS8o+q88gRPKMiooyTNQWvMnyUqK0NdxLe7dUsAyBeApFs0azVRvijvFiOR3sdKtewB9oK87CHhmPzkng8gVm8htuF3HNnFfVfbsq0Aul5X0yGLeUulfvDYG1HYbw1rSwgR5g+Hd7/H2lDfMW2M7fcokauArCZzvXMwaTODpEgDi453q/rJ+4bDH04XSuTDtufD/ShcYOOlxY1EzTvsttsidh7UcDnMSU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816f3803-81ac-41ed-bf1b-08de590e0d0b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:41.7965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgxKgAx0JvdJz+JDRqPl6K8supy9IR/gU9+pwdK/axYOEwp9HDFd1Z01edAJNSudVS/i37aqVxF+hgPHOaCuLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-GUID: rpptg3SKC61holXUvJMklRN6X__iee2O
X-Proofpoint-ORIG-GUID: rpptg3SKC61holXUvJMklRN6X__iee2O
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=6971054d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8
 a=AccYbpKY9h2kkeqM32EA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXz7yKn0Arq568
 Ya7sty4GbJq0urW8xzQnfw32BP4OSMAdenv7Snb3qdMZU0nCTxAPgUhHaTcu2rCXV19sVmVrPJO
 g7T5Pepje56qL+4uZC+uGV1l4fyATGvTqU5rK/qJTga55dKklWSrzYQ0calAOKOFos48lavcxHd
 3htwM//ljzdhkpWO5d3/5ZXMs6m8X1NHvinN8ZIMCAWtnjQarxIH6bwBahc5uRjz1iBOsLXgx48
 Kh/PfX+K0q2/DFb/ZlrtsQD8fJTWpCwcsE0E2dFyl8RhRujbtrv8gzjZSqbJUCkTDGJhNhbciWA
 82y0a2SA/EqucfhiNLRb/n8i/B8nHb06uXIcacTeDQeCnJXF2Adh9/tBDCFiSzkSj1JR2mkv4Lc
 XCr4KmAGxHVWmjoDbOw0ilm/4bl3G4FoDXoKE3vbSEof7f7cwfqqIDRH3c2Q639bcam6wlrJStT
 IvzRA3qZRKgjKmCSFNg==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4620740018
X-Stat-Signature: jpd66eaftoxhsxqd44ht3n3n4x9sftyb
X-HE-Tag: 1769014613-882927
X-HE-Meta: U2FsdGVkX1+QOUP7b360pDbDPKd3bP28E/sm8ZMExv7HOSZO8yhUGI4b297cogiQDs+WdptV+fo8RambXlWoE0JyBmZM1DlKROc83zA9fIqI/wjXSFPDJm9q5J590cNQd8Fj0WUZLCdd5CWQzQxs4aD25J6U0BDFUAm424L9PuALSNKhi50Xz1KD7WNTW0rcE6xMdiZTofR8yxHCW3pC+daHToM8Hbs4Zwve1eIMEmaj2frjlT6UMD+/jNuvTIEVujedhq58Gfu/Pz1wCuJ5EiaCaGDK38wqkUSaQ1f544iEx21XFrPDctK7ZTJTU5s18A/m2cp8D9Pi9Ks6ko1KJ2mz2njQpoKXP60nrVGFduHO1+Q8DIYS1YzEdoMWVqz2H2EfXqPaRWRtKQRqeqK8QAwOQThNNM/zUW1Rm3IWFAsHQ9B/WmH7q/KnS5I0PiYUIz9uvl2/1R5n4v8AXIS2vq9g5yO6atskaTCtKEQjBVLHOaD4p48RkDAH1UwQ7r8NazVeZ9hBY+rygwstVAOk3u544omQgidsSHlH40YiSbhjccgsur9k3cJJqsLmjk2o3D17edMYgYe0hn8/YmrDvEUes391XWupvAlxr12kd/BYo6zHsArkx0nD2Y6FngW28OYSi6nD7vnsVkbXXkBI7LNr5gQLfy3pN6EmQikFSjK0hxdT6fxJCrz/+5oylaPAhoc9gytg3UigsjV5PU78h8v1+jLYLw8U9KMHA7ci7iKz8Fl3uTRajYdywxNfPVpsh3lQU9iDk2VMUSDhpwkp+PTRIJ1kKdtdr5K5RZPpQaVIbsONyaViZcDKeyaXWNu+SLOK2k0SoJUoUsm2hzwWaRwlZBFUrqAcOEpKh/N4d+MY1KOG/4sXqqah0/AJOeOPtXPIGBbeL1D9KHrQfwyhn53+DhuKkEOWkFZ+yIpPLa6Or0NZpsPlrNwHqswdG77ftt+QrJrbiyrkZjBx8B0
 A8m2rrwW
 3ACsU5TfSP5Fpb9axjoB2U07DWXXNUOFYsq/FNVWN6lT7U1Yb0wFd8cRBa9gv/53VU/Xu5qz/xOMcr2ShjmXhkijMUW9/F1BYPxGf6D6qhKCCXA+qTn0TgHiLkFfbMEvMkuk6REovx69hwWgxjuVndMx4d6vMGO6tQgmQmyneea+wo3NbMAAaUYr96fKpMZ/qp/Lkh3wLKC64c8dbe8UibqpDiJRfGY89TSjEdnyhQGejWnDz9lIYy3YtwgsHUDUyW8tqyAmZtWZpCm8Z+A+3/kSXYmL6YMIiQHrJnJaz/NtfUpxf6ti2NcjLm1PKEIn8J5fHcdYkbblqHqGRBGxrtferxb3s5l/6Mwx1PQAvgyR7U3/+sybhn7/R5ZcEw1S89t1lYW7xSD+fZpogMMcx1kQWWsQPVYKOahe75qZScvdsJafj2SwxfSr4U2x/6T+FN2hFWhD1MzD5ClIl/W/9x0zo3ptDL51XQ4vgl67zTS3+BfSOqeeuEgvXyLlp7o6RSRvE5WpxCrWwI9WlQIF2Gi6Q0zqZyr5fYFUfzYi6vUHQAMDEPErc67RAD3y/R2jfnmMUcOlf0BAatqVWiBj+zNbUxErYBuUbrZegB/IgxtErLKi8AI7KppcSsDJuE9i3EVEL1UFOFlVAl2Fsiqpmsf9+6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The big node struct was created for simplicity of splitting,
rebalancing, and spanning store operations by using a copy buffer to
create the data necessary prior to breaking it up into 256B nodes.
Certain operations were rather tricky due to the restriction of keeping
NULL entries together and never at the end of a node (except the
right-most node).

The big node struct is incompatible with future features that are
currently in development.  Specifically different node types and
different data type sizes for pivots.

The big node struct was also a stack variable, which caused issues with
certain configurations of kernel build.

This series removes big node by introducing another node type which will
never be written to the tree: maple_copy.  The maple copy node operates
more like a scatter/gather operation with a number of sources and
destinations of allocated nodes.

The sources are copied to the destinations, in turn, until the sources
are exhausted.  The destination is changed if it is filled or the split
location is reached prior to the source data end.

New data is inserted by using the maple copy node itself as a source
with up to 3 slots and pivots.  The data in the maple copy node is the
data being written to the tree along with any fragment of the range(s)
being overwritten.

As with all nodes, the maple copy node is of size 256B.  Using a node
type allows for the copy operation to treat the new data stored in the
maple copy node the same as any other source node.

Analysis of the runtime shows no regression or benefit of removing the
larger stack structure.  The motivation is the ground work to use new
node types and to help those with odd configurations that have had
issues.

The change was tested by myself using mm_tests on amd64 and by Suren on
android (arm64).  Limited testing on s390 qemu was also performed using
stress-ng on the virtual memory, which should cover many corner cases.


Changes since v1:
 - Fix sparse warnings for RCU - Thanks kernel test robot
   <lkp@intel.com>


Liam R. Howlett (29):
  maple_tree: Fix mas_dup_alloc() sparse warning
  maple_tree: Move mas_spanning_rebalance loop to function
  maple_tree: Extract use of big node from mas_wr_spanning_store()
  maple_tree: Remove unnecessary assignment of orig_l index
  maple_tree: inline mas_spanning_rebalance() into
    mas_wr_spanning_rebalance()
  maple_tree: Make ma_wr_states reliable for reuse in spanning store
  maple_tree: Remove l_wr_mas from mas_wr_spanning_rebalance
  maple_tree: Don't pass through height in mas_wr_spanning_store
  maple_tree: Move maple_subtree_state from mas_wr_spanning_store to
    mas_wr_spanning_rebalance
  maple_tree: Correct right ma_wr_state end pivot in
    mas_wr_spanning_store()
  maple_tree: Introduce maple_copy node and use it in
    mas_spanning_rebalance()
  maple_tree: Testing update for spanning store
  maple_tree: Inline mas_spanning_rebalance_loop() into
    mas_wr_spanning_rebalance()
  maple_tree: Change initial big node setup in
    mas_wr_spanning_rebalance()
  maple_tree: Introduce ma_leaf_max_gap()
  maple_tree: Add gap support, slot and pivot sizes for maple copy
  maple_tree: Start using maple copy node for destination
  maple_tree: inline mas_wr_spanning_rebalance()
  maple_tree: Remove unnecessary return statements
  maple_tree: Separate wr_split_store and wr_rebalance store type code
    path
  maple_tree: Add cp_is_new_root() helper
  maple_tree: Use maple copy node for mas_wr_rebalance() operation
  maple_tree: Add copy_tree_location() helper
  maple_tree: Add cp_converged() helper
  maple_tree: Use maple copy node for mas_wr_split()
  maple_tree: Remove maple big node and subtree structs
  maple_tree: Pass maple copy node to mas_wmb_replace()
  maple_tree: Don't pass end to mas_wr_append()
  maple_tree: Clean up mas_wr_node_store()

 include/linux/maple_tree.h       |   42 +
 lib/maple_tree.c                 | 2126 +++++++++++++-----------------
 lib/test_maple_tree.c            |   55 +-
 tools/testing/radix-tree/maple.c |  183 ++-
 4 files changed, 1207 insertions(+), 1199 deletions(-)

-- 
2.47.3


