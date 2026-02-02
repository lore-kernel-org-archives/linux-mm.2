Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A1AE7314E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6EB6B0098; Mon,  2 Feb 2026 05:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895526B0099; Mon,  2 Feb 2026 05:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722536B009B; Mon,  2 Feb 2026 05:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4656B0098
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:53:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA374160B46
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:53:36 +0000 (UTC)
X-FDA: 84399205632.11.BB10019
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 88EC91A0008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:53:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="P/6kvKN5";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="M4flwB/Y";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770029613; a=rsa-sha256;
	cv=pass;
	b=Dy0qU5G51ko21mF7qqvzJU5l3eg7okbgO/5Y8r0Tr+BnGvgxMwSlBkfovZnuDfAb5dq+XS
	fK98mEyIp8KhJUzSbdpklneA5N6XHoieqIJDvo6BLpLsahGEQaMWKN49yT3iFGaNHQ9NQ1
	CIpltOTWRyPyRiZqW85o2mRTXqeZU/8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="P/6kvKN5";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="M4flwB/Y";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770029613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEsUNx0ecuXxKD220W6c5uxv7ydAOUwUvGp26zUXbCI=;
	b=lmoIFXws7JJ/2GQMDOac6LZ99epxTj4cJgp6F8rGgooccdprKfHXOxRnhEARg0XBiAMXCR
	X4oD3v14lRsFTMDRePkKOmJSP7SfV1XnEORTphuqIIx3LFlENPUG1PrWMgMmc8RYuIJqgP
	sUks5qWNcO29SgTKoxYpKgTNpZIixKc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128udGd1383463;
	Mon, 2 Feb 2026 10:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YEsUNx0ecuXxKD220W
	6c5uxv7ydAOUwUvGp26zUXbCI=; b=P/6kvKN54dKbEkE++2xsU/WmQTmZWEyJd4
	jvEHD9lso6vRpHgxzEywK6A2NG8kIPLc0P2gd6wMSFilffInn3/J2lb9dxlufwL9
	MQ5jQlXdCnmTKD+WRrHh+ccIfi2Xt6n2LIgdN0jcUDEPWHOYsrli0wWSd9u3Qrrk
	enGerHeOrrUH7XJKCYa5kWLn3LKGviosudramLt38gAZovbvHHM2eBALvYdP/Lbt
	45aHGuYLIqd2QJ6aZ3WRZVWAT1ZZl0arv/aMSNhU5glA9yjwhPyuG+Y+vBkNaPDe
	DcKZpEOxXTK88Pc858FB3o3vNHNGFhrTpDSDGBx6/UjNm4tBy3Jg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1arhhy9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 10:53:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612Aq6Pb002079;
	Mon, 2 Feb 2026 10:53:31 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013017.outbound.protection.outlook.com [40.93.196.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186jrsay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 10:53:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=prS7313JgBQh+HSfu6kc+cTsleGbQ/ZN60I9ZNCGUmHd1/r/R57D4OopQgHcK/nTWhL9B2bHK4Cr52G8KNNPLg0SP8fw4ejyQ9o6JsTEq1MQHTei5h91AKt8K8H3XDrZoZZUmhO5fqh8VKTOy+uHLmSDxyILX7izGQekWnBReDA8fzRPzowW2jcaEv+ji6CEVaZH60kOqcrguhtSw3H3VLMiSVEgetKVf72tcITaPS8hGmHFy7Yq1QbMOzpzh/EX0TcCvvy7GRzVR1fy3Y+kiIldGCUasPFGbzkT8fE0Llum2LsCHN0vy3Zr0nLoBKOPaIHlAYe5dL5OA7Cp/GtGcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEsUNx0ecuXxKD220W6c5uxv7ydAOUwUvGp26zUXbCI=;
 b=i10t2g0OysCMwRRq1Wt5pRS0/IsDu3CROOdxoHLRNJKhOciaY69TkJQ2LEPPNcvfg/2eR5ULksdd4oZN3tUmXjxwiu2TErnbQGwaVXSq+9YObA2y58D0SXloE9QsxK2xofwOO1eZNRkD2eCGU+tUAfOd3Y/BWORK+VfWmN2FihQt/sX3L8+w89i2iDzF/VNj/trwQ1WtPFPx6wL/mIaWXLempi7XO1CsalazF60ioMJI84kIsNug46asO4s+gEkQotoPURZMZElxUFhZ4XeCobGx2VJAcF2mu/9/IlXabDdZv92jcQSPixDpflZACR47FntsSZPRs2n59hDAjRt0sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEsUNx0ecuXxKD220W6c5uxv7ydAOUwUvGp26zUXbCI=;
 b=M4flwB/YtCiQ0wjoIPp/BEZih4lKZEOKIODgsa1iH/TtrECc9IQyFXy1LHzSyo6nr1MFkvOa3gmEs7o5vN55x+L0CVcVPbid+UqSMwE3718IL0djvSU52iYZscmrulyrhKqCV3Jo8BNq9nyu46P0a7Ztq3El5QQxt8YyBPSGTjY=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS7PR10MB7373.namprd10.prod.outlook.com (2603:10b6:8:ef::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 10:53:29 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 2 Feb 2026
 10:53:29 +0000
Date: Mon, 2 Feb 2026 10:53:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] lsm: preserve /proc/sys/vm/mmap_min_addr when
 !CONFIG_SECURITY
Message-ID: <38c9c9bf-3912-4e16-b15e-60890390e8dc@lucifer.local>
References: <20260129225132.420484-2-paul@paul-moore.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129225132.420484-2-paul@paul-moore.com>
X-ClientProxiedBy: LO6P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS7PR10MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: d963522c-6393-47a2-1c3a-08de62494ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QnQtx9lH7thlaMNkTKZGoPfh9v5X8RAafMtROJ/nxX9T6VsLrhbsPnqn0al+?=
 =?us-ascii?Q?clX+SOnt/SgyrR/lQIuyW6/Jxt+qX/XCo1lXvmWyyVn+B7MDXTnNfOlU+d47?=
 =?us-ascii?Q?LdKPXOouWMjH4+P/g/SJaI7Ydf01MPPTtWHEKtxfBjbtCdl8JJ5ETbUV4RhE?=
 =?us-ascii?Q?I7WNWQFmg+Vg+ZMCJAmXJSr0JnlKFODTJOg63XbIBX/1A7fPrgFtYVQOEluh?=
 =?us-ascii?Q?pApgs7qJkae6YDjlZsq8jB9ZIU4eRXoUnYPMnxA4Q66cT01D56ktWu0V2Igs?=
 =?us-ascii?Q?HxLBtzn5sPoS8RU9PFlMlKGxPpUdBUJ3YIncV66XL4/JTCD4ns6UTzqhH2iX?=
 =?us-ascii?Q?fMC/wzqgjWSv5RhUL8D3gOaoLOkJ7DpEKmmjRpfCrWpjEGnd5UhVubNh8gva?=
 =?us-ascii?Q?njjWktbn7O8PUy6BIh4foHJ37HPwsw25EncPoRsrN8h1ufjZeb7bNZi3uT5U?=
 =?us-ascii?Q?hyC9mb/pYt4ZB8pr4jTMcFge6wy4dBkvnCAkaK6yAPAP4MlvpvjlaoPHMgNY?=
 =?us-ascii?Q?aHFOiuMi4iXfhSfgSKvSLetYQ1S5Md0WmDtYKqYgN0lLwMLxU2EuG/CC8AcN?=
 =?us-ascii?Q?XCRitR8N2gZ8Ff1jhRuvPpTyOubtO7qiyY8uigy4aPjzgDnNHOCdF4arMvMa?=
 =?us-ascii?Q?DzeAcMPtgERAThX0SlbeoeYkpMm+PoLVDC09qbBM+xY37JKREVeQ6KZnZkcJ?=
 =?us-ascii?Q?Nnbsc820Kv401Cl2f32Q0vwp92Sr34LEXAQ01d55mn0G6bOXGATOXWH1gLvs?=
 =?us-ascii?Q?NsjkaQ8G7eC1DTNSYfp3jyGiAJbLuw/VfQXhpIHpXfTggOkOtaSDbg6Mti/i?=
 =?us-ascii?Q?/OI20z4qJd6F4HUKznChSNb5cnpbHND6v5rlGTX3pDIMEpK29FGwYq9Z7Nm6?=
 =?us-ascii?Q?QAaAgcnazDCC+J+1EirjL/NlWgz0HJhGVSs38lT1RfEg+LIK4wq6JvG8CUD6?=
 =?us-ascii?Q?5+SJxm3iVuExun5zTHg8nIT1AUpfpEOXZL2gLwaq7oDlJxNPLZEt64V4GGsz?=
 =?us-ascii?Q?L62XR/OE0Is9Ela+sbqM0iez87OPASwi4c82umNk5n9rdnXROj+DxjXvIc8H?=
 =?us-ascii?Q?RLTq34N1HpDPiBIZvtlzrS8jtStN9IqbM566YxqVZlRfN+HJrtnORb/Lg0BQ?=
 =?us-ascii?Q?YtT1DXrtJRq/N6mfKEZ1O8i+60kM7bRjnutpbvcRzUHlBKuAOSEBeqFWEkLR?=
 =?us-ascii?Q?BaXyb4WXKc/Zg5U30bzLg1R4sJcSaX5QHWqKTxV5qhYzGWc+n6R+9/rY8Sz7?=
 =?us-ascii?Q?xGJIzT6ynu/BoQPMxcl1UC6PzRTMPhen7lEUa5yNZOJwd1pdMnNnoCCIupwl?=
 =?us-ascii?Q?RU7chV5DxIh2/0hcXP+1PWdYpznoSAOEMmGxRRZLrzp6ZmYE8uPl2JBZWkcQ?=
 =?us-ascii?Q?a0x0aZoS1ZkBXK4GMrz/AZdBLIWohe4EANDuGL31S3nmP/vmij9i4efXtYh/?=
 =?us-ascii?Q?j8Kq1aw0ff6XeTBQIppVqlqIMGoq7zHj/NWVNl8vdFKhrtYi2Cv/0cGNaao9?=
 =?us-ascii?Q?VzPjVOCK4SgJ6D4B9gUIz1BsC86hhVvkUGRXKmAaK4BasZ1PnBIITq4I/f19?=
 =?us-ascii?Q?JnXvGGBYRIuZfO7Rk6g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MAyHSXXBKQm+w8lsD8lmG44Swr1jZKRYlKv+WYfkmXYA9blWZjcLgNDrNjNW?=
 =?us-ascii?Q?HLOi3JigH2TFk0n9ksMVUXTsHYDpiZJ7glDMh7wESEQ4GJzO31yC8MYK1nHy?=
 =?us-ascii?Q?2IYUzX7PAdBRHsRRveXr3jTSf8BTdv0iokuZf/wjQKA/u6o1fCYjfYybjKho?=
 =?us-ascii?Q?XRSCiQBD5x82gjzBznN+Mq/8n7WvlicrpAD18yGhoDG9XHxGTmG3SO81O1P7?=
 =?us-ascii?Q?5hvQzYSe4ALWWnuteR2i4OseO3OxDH4xp24aRuNwGKW6iAQQRCZDoQGCBM9a?=
 =?us-ascii?Q?lBs2HoTgWzvuvIh2M+xY6t4KsHP7TqxY3BYWqu5UCfYCm2uQ3WVRAfanEORM?=
 =?us-ascii?Q?aWzywh4Gb0UnuqClIXBTCm/9bKy0379u5JCD1LTvLuSWmP8clYWw+0qAQ3Mi?=
 =?us-ascii?Q?mVS0o68r1qbc33SWuTeOqMkSpHMMtb+/QHkyQZ9SfSUE8s2iRrhmDZMqfdml?=
 =?us-ascii?Q?/pS8XRFFq+y/ei3wClXp9P9daPX85qOUy4E1Y/Iuk82a6rUmbBLedi0+C7++?=
 =?us-ascii?Q?pDhiTSInbnvPkfjulHFcgJ3R2xPxHQnq5LggpuSKw96u8OIDaOWhXJM6Qc5a?=
 =?us-ascii?Q?skzunipImSVKGdtg0ioqwsIHnzD7mBs3Vtsj9Y5FSyQeKfvOpBMaVyP5QnUW?=
 =?us-ascii?Q?Mc1DRTj7bLmUao569xl71RpPA3WKnWSyEETuMQ2NZheeHGvo48XkafW4/8VB?=
 =?us-ascii?Q?KJqngEMc4LAIRYWVdAKPjV197XoEHUcsyMdKB/SRx8iyMhe9IcOfqasWGl3D?=
 =?us-ascii?Q?ukhlM21vMjrbIJdOD3IZ/LZsbE1n+Kp3UeubQhZ28Vbr8OgF1UU2SnRElzq/?=
 =?us-ascii?Q?pH7Ru0cuu+L2wrXVa73wIv/7ggJu6ISx580vyto5v5Tp94jNB0dq5qiWAjJZ?=
 =?us-ascii?Q?OQS/S9vN1mWzeiD17J5GEvD11sdWi7PiF8QtqsFy3rFpCBv4xGLR99KdBpZS?=
 =?us-ascii?Q?giOFXt/HQheY79UAZxM+TiIA24NiF07l8g/2Auh21zgjPfPOzpXWUJm3gp1W?=
 =?us-ascii?Q?DvVq3s8IL6VKiQcmw2i4PhnhUy98ey+PNjOKSdGASSTxcoic8ci5ErEyrg3l?=
 =?us-ascii?Q?VgnAxGBcj3zZfE0Eh04vh6OCFMElERU+UKeGH3cpBwEKP+wmz77BzAt7w4BV?=
 =?us-ascii?Q?hM5Hxbn0lAeu7Asie9KW47hKXv1AGDepHifzArdVGv3Bb4UrsXQtSa7E2jgK?=
 =?us-ascii?Q?vPFgHgefk0iUL+69fhsF1W4o/YOzg3KHXLTTFr4NQsaU2SVo29HTmQn0gCei?=
 =?us-ascii?Q?ziAR2UXEh9vDly89rmyMGAuE5iaUcH/n9s8Y71Tzibwv04gVbfWtpy2XsaVp?=
 =?us-ascii?Q?R2vuuqcu7eBUziIRBkHjW1ge1Lddmt05bsGiSl1RmX2+G6rOAvlPZLPEc7pS?=
 =?us-ascii?Q?iDF8uHImlGrdx9itqSxVUGWICvgJwPYGrEPCKXPgzYVIFopoP+0bl4vOW05c?=
 =?us-ascii?Q?we1ZLHs3860TIH0FMMf2bW/llWravuTMswyfNUm5VRFrwMPA+yLLW4CzVMGI?=
 =?us-ascii?Q?ZlKtPW+/kCcNjEToGWBtDwTK+etREpSW7DDhrsX3kO7aculKeVDxISaPTtgD?=
 =?us-ascii?Q?1+o5AU02OZ0srtzR7j9Xbzgp2XriZzhhqOn91UfSt4Tg60YZ8LM9xJJ4yn5Z?=
 =?us-ascii?Q?HRzskQSwyhtJfCs7kS3MD/uGyF0Y1vSEg0/2gzfmQWuu0ZkigfNF+etNrNUf?=
 =?us-ascii?Q?bopZwzFvBk0ljD+xXwTOLA3VmBNbarH8DO2WJ9wv/sm4im0CkcLPfz9Tm21P?=
 =?us-ascii?Q?tboBK1W2oKQ1ltskTeerlACVLhsFbl0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	667DzA4LhCo4klEP5lw5lOtyfY3QNnya4zs+VLLC1sfzAF/WX8HbYvM33kuwVlflDJNjtRUYs9S/bRdApXrBe7ZeSalhmYXwlxYh/zDDQhGU0YWSn39IzEzqLJADwcaf7rVnJF6g5rh2DRpYhxuSs3uCrqymScBepNvgVmFL9HTXHxTlilLTz/ayf6fSE0JEaysT8Z4efc8WVfIgl1fQn/k8RMHt17OuyCdApYFcyR7XoBq+ad9Zsef+FvgpV7KlHEvvfGzTKQbytXS2Qp63KmaP8femiPX4jSQxLe6//Qnmu3fisKNyxmaWBedtmJpGiPu/YjA4JMoJ+oIweHVGNljUduo5YwN0ftNZCz/5geHFWaI/nYSMB87E56cpooOAf0a/sD2W59pfkHHl5OzOyDmNMkQzr1JJyENd+0VyTpCJra395d+rbvbY/1lNfKrd1CmSFbAavmJoHVUb/DqzyVpIltlcLUkPh+Krx/wzUlgitcRTU+sHpfRSk8qQ9/OFatExNdrCDsGyaMAdDQcsXdDso55dC30vei+fRUULHEXT5OO/laMJZ2agJzIbbb8fGswvD1DCskg2XNRF6SKv+Q8qAymhkHKt/HrroI0GpCs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d963522c-6393-47a2-1c3a-08de62494ca3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 10:53:29.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7XjV2Q0UUD0Q8HgXCmnbUSekw2JhyToyKAildEFIx0JvEOgUHovbZFNQE/r0/b77uhb/SyEKcAf8xpLINkN4G6vCuDGpXtSOxbE7xsd4R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7373
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602020087
X-Proofpoint-ORIG-GUID: al6XZq_0Kjx-A5E4AI4VZWx2lSX8g3vz
X-Proofpoint-GUID: al6XZq_0Kjx-A5E4AI4VZWx2lSX8g3vz
X-Authority-Analysis: v=2.4 cv=fdmgCkQF c=1 sm=1 tr=0 ts=6980822c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=xVhDTqbCAAAA:8 a=6hJo0hV5HX86MnkomZAA:9 a=CjuIK1q_8ugA:10
 a=GrmWmAYt4dzCMttCBZOh:22 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA4NyBTYWx0ZWRfX1CwlflrVda4i
 kzaQxIl1Hr/9z/wfJb8xjCjtZfVVRrSNHfylqAQUuJiOstCuIGf/hf5fHnuRlWWz6HMg7vbEEnP
 Tc5hdYYT1wmkMrq4j1TaBd9c6ZrZilwt7eg8sHp9Txu4mUkzKrPwMak2wJqKCMZ2LsoA0kipbIn
 4NwcpV5AbGCCx2NFwh/Nm3x2BxcXzZ5JDD8MSneNNhQkcoA/5+58mI9Gikf0Zf12SdKpSG5nzyu
 W/0oJWDfeksSgWbjLrrQ8+ckoyd3wL8VyZ9ueMgTPXP8iHl+9GBiNQkgzYZsc1h5AgYkIVw4OGi
 GCI/+eCHK1k1lJfOvzGkmMgxSx8vzyAtIgeKErhbXYlivsWv7EYhkM+Enx7bKEoOafkhb8ybK9i
 6JSH7fVl87n3D1KCd4HYH0Vus9P+SBaCVHpy2ZutZdKZLL2UhZmhfWy3G5AX33d63NexT0/7n7y
 gwf+CKP+s1IScWmd13Zkm+oSpJHpvSIdcL1VkKGY=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88EC91A0008
X-Stat-Signature: 7ntuyij91huw7ghmqctshrpyqmst7fkc
X-HE-Tag: 1770029613-787884
X-HE-Meta: U2FsdGVkX18OCtAk89YrvoFPOshwLkQGQbTG4fiNiP+Oe4IidOTKtKEN7s5ovVTDUGNray2aDA0CZD19uTk8tgcT3j2/SBg0EnXWgwiyUxU9HaEe1HJfSxqYJxTwbhP/GGqwxtZf08kodd1wRUPVgn3rrnc3rGLo7cmTz47kHb13njZIDr70MQ2uLYSfu67MumTOaY1yZUmFGBbpBAPZ7P2yTY6L2dyaOnXAKlECZ0/fIVwZCzLpWFf/y3nfTtCOL9ft7n9vWmF2507Bo4RYuvxX5njlqgxS5TlpL+WuH52OxyvI93+6pgRBY2ASJecUESJcfqvZVvqzEQzjmVWICOa+tmsB77j3otX1AalQA8uJPchba+kFmxxTHxVHym7k+CMtjCty4W0YlUHR7KFD+z128H14S0Y6AbbtXdqNWrYBcSHf87F0BcNW+yMKBQ1JUheQS3+kra+AL1wRWqGzKCrZJexhyXyTvGcGiSZYUpzPr386+ZEk9VK6g3Wdxm/g4R4FrOENbpVyyg7RSTHBZ2hH6nssfiR/aaEmvKlY9IrHXpUPcsQThTAHo8+Z9JQQl+efYuqlHYxzDLKt/YivzWEo5/IzdVUOpfqjQAM2bpMzAUWg3y2ueFeCGRG3zqYcGnaooHtoTy3tIyvZq22kbZI9g6fN5wDJnwK5n06qW202K11mOGuIMWJE+DuevwWo7swWkUgYwGo5DszxwTAJR0sbdkX9SOmMi3fzBeR9tKE8J1x8CIhocnvckXwikC6LztlUexlbvKYxh4NxKv91M95nAf+KwXxUGPWuPvA09ucS+ZMwIta72GoFWpo+d/IlqIiH55ekz6etTXAAucGkTxWJsNhN/QtnthRbvrcn7UFS0sExIQN2gT5YxtDM4P9gqjwHbaBkB+BXMHvEPJJwpJ2FQEuhBf+Z0CSrYv/DCnz+BLJrlGtz8rxtPAdBzHfe/C5L4nKJqVaO1+KeNMW
 4RGNJdLm
 H/JwYq5MT0DZngjAFW4YC5VrF8AJf7rwVVeVVbVPj+1NuFCbNAj03J/UcnEjXBqBSJh+njIHdGJarKeGsyVRZtiDouQXhIvhQ3YIAgFAVSx4MWcRWTaMEn7QjWdTBACQALmmhJZ2HRtCgeOFm7Ahay/WqoN4BDzSWxtTANRjL/1YeBW6QVwmBNyYzqXMd7+SdN1nJ3jxaxeXSYT+xfsR6kY4PwzpEHgRddKBUNw7EHxJdmrRzUaj7mR6ojXUppluAmiJGnzRet+8QH878H2ZMKwKp9I2na/ddEaFBLIb29d/knPoIZZGWoLJV8b3yDqdPHiMZQMkKbB7Jn7QCky7/OXk/ifuqIz9wPhO6Z8O0eiKy1731ZD0oW1+yG50m+y2UiC5tC8DP1okMOZbbqdRfKN7l5dyb+UXeliDio+rMojwJwI6dUF2MCD0Vg769raQlLq6m4V5ClkpVIz/+tRdG7/YTia+PaQJ0xPw7mZkk5Wm3nR1c0Nf3jhtMnj2fgoBebyCi6lumk29lwKq8Wk31C/ky+eQ1yOYMrfDwZX7J+yRJAfuBio0p23lmBw8O6Yz9QEZf3E/1oLlJnrezrW3JmlNyv9B5P7qnmT5w1T1YmWzcM9c9DXVM4+jvmX8lBHaAB5MUF/asQiHWw5LYeEVQxssw48dWdWeIRd8yyK0q6Z3wgLchpPQtdlfxfXXiwq/dCz1leInHgfS8tTelyuONBNSpxvnD4ITWUoUC2U87dscEWRZkxilkY8pWvtpBXVzuiLCp4k7BAwReNSozRagde288WVpU+w3UdsRq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 05:51:33PM -0500, Paul Moore wrote:
> While reworking the LSM initialization code the
> /proc/sys/vm/mmap_min_addr handler was inadvertently caught up in the
> change and the procfs entry wasn't setup when CONFIG_SECURITY was not
> selected at kernel build time.  This patch restores the previous behavior
> and ensures that the procfs entry is setup regardless of the
> CONFIG_SECURITY state.
>
> Future work will improve upon this, likely by moving the procfs handler
> into the mm subsystem, but this patch should resolve the immediate
> regression.
>
> Fixes: 4ab5efcc2829 ("lsm: consolidate all of the LSM framework initcalls")
> Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>

(Sorry was at fosdem from fri)

LGTM and tested locally confirming it works, thanks so much for the quick
turnaround! Feel free to add:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Cheers, Lorenzo

> ---
>  security/lsm.h      | 9 ---------
>  security/lsm_init.c | 7 +------
>  security/min_addr.c | 5 ++---
>  3 files changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/security/lsm.h b/security/lsm.h
> index 81aadbc61685..db77cc83e158 100644
> --- a/security/lsm.h
> +++ b/security/lsm.h
> @@ -37,15 +37,6 @@ int lsm_task_alloc(struct task_struct *task);
>
>  /* LSM framework initializers */
>
> -#ifdef CONFIG_MMU
> -int min_addr_init(void);
> -#else
> -static inline int min_addr_init(void)
> -{
> -	return 0;
> -}
> -#endif /* CONFIG_MMU */
> -
>  #ifdef CONFIG_SECURITYFS
>  int securityfs_init(void);
>  #else
> diff --git a/security/lsm_init.c b/security/lsm_init.c
> index 05bd52e6b1f2..573e2a7250c4 100644
> --- a/security/lsm_init.c
> +++ b/security/lsm_init.c
> @@ -489,12 +489,7 @@ int __init security_init(void)
>   */
>  static int __init security_initcall_pure(void)
>  {
> -	int rc_adr, rc_lsm;
> -
> -	rc_adr = min_addr_init();
> -	rc_lsm = lsm_initcall(pure);
> -
> -	return (rc_adr ? rc_adr : rc_lsm);
> +	return lsm_initcall(pure);
>  }
>  pure_initcall(security_initcall_pure);
>
> diff --git a/security/min_addr.c b/security/min_addr.c
> index 0fde5ec9abc8..56e4f9d25929 100644
> --- a/security/min_addr.c
> +++ b/security/min_addr.c
> @@ -5,8 +5,6 @@
>  #include <linux/sysctl.h>
>  #include <linux/minmax.h>
>
> -#include "lsm.h"
> -
>  /* amount of vm to protect from userspace access by both DAC and the LSM*/
>  unsigned long mmap_min_addr;
>  /* amount of vm to protect from userspace using CAP_SYS_RAWIO (DAC) */
> @@ -54,10 +52,11 @@ static const struct ctl_table min_addr_sysctl_table[] = {
>  	},
>  };
>
> -int __init min_addr_init(void)
> +static int __init mmap_min_addr_init(void)
>  {
>  	register_sysctl_init("vm", min_addr_sysctl_table);
>  	update_mmap_min_addr();
>
>  	return 0;
>  }
> +pure_initcall(mmap_min_addr_init);
> --
> 2.52.0
>

