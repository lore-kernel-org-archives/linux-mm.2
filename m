Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD96D46956
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0961C6B00A9; Wed, 21 Jan 2026 11:57:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023526B00BE; Wed, 21 Jan 2026 11:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33996B00BF; Wed, 21 Jan 2026 11:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C193C6B00A9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60FA2C2B1A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:06 +0000 (UTC)
X-FDA: 84356576052.04.3B84A15
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5F62C0008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=foZFLDmV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bs308Qv8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=;
	b=qs2SSQ8i+3N7cuph3WmM0j77l/YRBiSym+6vIvSwNkIxva4eAkB8OjLteISToGBa1W4nyl
	QlhyE32ASFHFuo9q29CxeOovSl7cFOy/ErgDOQ7QmXy9688iR/4UtwL1K5+pS7pq9dxVxb
	Gppfk6KIMO1oj6RgLVsTF/irJgXA7KE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014622; a=rsa-sha256;
	cv=pass;
	b=gKZgrgv6SA7UYYNQZrzuc/DUFnRj9Gn5eXYgIlPMqXjouLNUKjqbS6XDoqO/l95tlz6Pi1
	yc0mdXWVQr34iV4U1EbiZLFW4k5MezRIRs2JbMcYW1+yYmML++Ng3ga6AnGDQoCpZ6gmTL
	t7JI4AI/eOc3VYDNJm5bEF0+wdV947w=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=foZFLDmV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bs308Qv8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LEAApH3417394;
	Wed, 21 Jan 2026 16:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=; b=
	foZFLDmVlBAc5SxLgF8qh0q2vtobTZ79N4TqxrmRXlZoGAHNXFkrPlnHllkqKX40
	vTF1PW9hnyP9BQAg7/e4hCwe0CtfNtdLXuwVLSWm4gs1edZNiOTuyV9FWz3Tb8K+
	sOcXvBcqsG2ssDODnfzv4j7lxc/NpMPl/Y0kTSpTi/Jui/HVPFxSPSOiWZmLAyqD
	ykrmF1NXPxz9mIlO0R4rGVR8LuUF71NQfdwGwUjKIKb4a4/Q3SMj9mV18WJkG/Y8
	N2QLUs9MPRlhON5OUVVfJE7Gi5CY+o6jGjDMImvkWcPzR1pfLl2be2Ieg+FT4G1L
	/FKoRYRYKWIZBvkk5BLvBw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pe6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGKKsA008437;
	Wed, 21 Jan 2026 16:56:53 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhsfr-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nvjTmYsW1cvdpp3BXU+132dxEJPDeU1boB/w5zrATEo1OpvDTJXd27fDEo0UrtQyXITp8ck9zOY+PAG98AihbbN5VuNCfklUvg+V1yhv7UsUOhSQgxHMAswIXh4MncV8VQwKwZGFh5hgA+XnrnV6AKQ1M1b0GVF0CujiEbHigw2CgF1mq6+ovc/wE5GuUVuU3SSvDRCNRJfm7pybq+sTQv8857LxwJaDba95tkQuBH+w6pKbO8WgSBo5Fy/wt8bR7mTqIg6QIrLat7fH3QvND4TaGXgQ66IMb3HmS3tJ43s4kLnmq1rC4vLTWx1z//E4+roahJCyQnRNiur2CKaskQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=;
 b=sChgoauNyf9PMelxH5ZYG2bb7ijksVmeRjafFHOtCfpnPbWIwE9Ugxx3x57K0OnAMVzE3FXLJRFy+Dg8NQlvyqWjqUL33ypycDmE32KCIgeldsH+nw0eUj2cVN4ii6KeILrlbfwgLSfpuFzOgq6cUmoOFkzOt3j1dNbbXylzGvoFJYb3crk0YXSyd1px3dmPoZqJZKe2P75ods6uVWAowEvIHYHANp8tJ+IIdJl5a6hsxNjGJfU/ChiUCBfIsexAry1uAFQzZoWniDlgFhUPKMamqGAycalVRCPhKsFsiOoRPBFf0Kh7XwKP6zhNLhg7X1MG4Dl4UIUumNh+cmrU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=;
 b=bs308Qv8xOfXWoSLExDNRpoHNCGgg7LGg8uN+Ho/BZPEdK6J41ZZmXqCML6SxJuY8dYUdezkx3gtZLSeZFToLmErDbcv95e2sklC3w6fS+qqxjSLbEOp9XfDFenfQwp9t1JFnncO5pfJdLAduaqf5SpBAnE8nfqTsPcr0SAH/dM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:48 +0000
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
Subject: [PATCH v2 03/29] maple_tree: Extract use of big node from mas_wr_spanning_store()
Date: Wed, 21 Jan 2026 11:45:00 -0500
Message-ID: <20260121164526.2093265-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0103.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 713683cb-3222-4d88-794d-08de590e113d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5MX39JoEJyIspDs1P7Pywjx/Mli1j+c9sm9wmmYnstrQFeFD9MjpfgGyuDAU?=
 =?us-ascii?Q?v3vEEFceJNb6ihNEQqCoTBUbDGC1UTxCyVkN5g2l0XHooMVeIWauzeGKtpdG?=
 =?us-ascii?Q?EmOpP1C7P1WTX1VNfg8NqyV6l33ToLN/3jhBa3GnnVhCzFEpgmSnrrvPVnVE?=
 =?us-ascii?Q?XlRjK2TJolVHprdbTP+GKuh8BP1KttJ6VfzlYJ0znQGlrG3gej276KUeG6Us?=
 =?us-ascii?Q?+iFXQ3NB+zV21Bk8GWIx0jNwwNKPhF59onKgypq/Ika3dme/2Xbu0lN1mcdb?=
 =?us-ascii?Q?H+xKUOS7htJfdSm9yzAJUKgEwY0aicP7Zb+wSl/LYtLI4Fz8O2Afb3TyeBTl?=
 =?us-ascii?Q?Jx7siuUZy8XdI5/q1UlakEfYxSfYfZtWSSBm3U+mwx+Fm0Avbc1l1Hwr+gqS?=
 =?us-ascii?Q?oMi8aRwxVV9Xz8K/f+T+RLOC/IeiPX+QTeLMW/jESMXdQlzGMdgPY1fJwC9x?=
 =?us-ascii?Q?xuYbrDhtWs2xBJQP6ua8efFNQTaa3iQ5vh5CloxV11pHOOUhhKymUVfgp6MY?=
 =?us-ascii?Q?OBRum4prB/AT5VhgdiRj2Ce5yt6V2UsNBOX6hdB4wiNHnDXMy94NySVL2Rnq?=
 =?us-ascii?Q?HuUJUMq61ZCuDsZAueTUwQrDzextDIK3MI+JiiOfTMB+VW4bIv2IiTPAM8nD?=
 =?us-ascii?Q?XfwzUbV5T95gR4ZNX7K3eEIlowRFGibWDvmiMcsd5/QyuX2RfaZYrNeFmMFs?=
 =?us-ascii?Q?4GGWRHJUGEyBZ1HIRLhcdsd4Nt0Gb96y9pFYVoFI/I8Pc4J+KrO86FQBASGe?=
 =?us-ascii?Q?DNECm4J/Sp2HF3QEujb8j8xMl2CmKdnt8Z9e4IPWsajc9OgflpHZA38LzmXk?=
 =?us-ascii?Q?B5rvFti8O/mDTnkI9P6CM4XydZySq8fzr46rTZa+YHauyYkm78ptF5lQUSlS?=
 =?us-ascii?Q?y1Z4yEKN8e25lIy7qckEvQSOk27zBTEi+asC3FTAQohoU5m3+Vs8RDHRoxZT?=
 =?us-ascii?Q?bYDdC7F9wP+FsdMfu4h1+dAL/x1NZHXqe7Ti34ZFt6a/7+Y3dyw9D/DViT8H?=
 =?us-ascii?Q?aCJUdPSLOPhzVWhA3eTpt3IazEIse5oSwF8c6czJYUl7WYuDG+bf54nRH9k/?=
 =?us-ascii?Q?ZomB1p2xDPTBp+5BbhG2UtMWAj7nuzbzpHIICPZ6jSY4ZzCT9I7y/fOngkIy?=
 =?us-ascii?Q?aSj0LL+UWA+QUW0wruy95Yz69Lh4RDOkIwO2aF2niLkVq8Kr6b8rXp5T6GXA?=
 =?us-ascii?Q?E3oQ/A/ugLtEhVoulsC93PqdnJHonF8wgW9Hm0JxOJkJLknmAMpIuaerunPh?=
 =?us-ascii?Q?hKx/dUoi9tiDx2MmNAMYGghFc1fY/pb6gl17sZdmNSSA2tTWvxsZdgIMoo8w?=
 =?us-ascii?Q?ZS1BbujNJBqxKXXesaNlmJeYZF65NlYe2hhvekimNmoNQpQ0mIhVEM7/AcFP?=
 =?us-ascii?Q?JOjiwzY0ssx3bS9kvl8d0sy3RZWjis49kgNpHLUr+ExTGUoRL+vNx/JPTA6V?=
 =?us-ascii?Q?+ikJnuMC5u0gbx1qlun4qwjnk788TDBrB0nisgAYdkhJ4K3AARLLUXbWuz7J?=
 =?us-ascii?Q?iDPNx1lu1RvGafiYYTSM5uphFHfbBFEk4qfVzuPVuDZI/1pU9V8MraEupVm+?=
 =?us-ascii?Q?20E0twGxsZ18EDdF2HM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VL1K7Ji5M6aBg42G64KEx2g6tElqtRfObBLqo4HbN+6eDMU4lqeWB4WgKLR9?=
 =?us-ascii?Q?T2TX0i1L5nWgapUA+PISyjFMDZGQ9LvRWchbWaOwIou+JalCL+GmQTDTefdq?=
 =?us-ascii?Q?3TwOZN7xgJ9oY171fTdMUngZZFJUHQ1LlQcacnUVeWq8gs7FTLpBz+NKt+zn?=
 =?us-ascii?Q?p6fuXvAJrc3RSQIZkogP4qY/bW8UezI3gAuP6j0lv8uQu3taHssNBaf6ijp3?=
 =?us-ascii?Q?TxDNe9XJUBXwOSc079r+WoZWjcU1HwhlmF6Z0mS6ozBxjYlTDNpgpbk4vcOz?=
 =?us-ascii?Q?LCWL/xhRufXpn2yzXlTkGc4srPnQXn/S+WnggJ5MoiZ8wcfly5ecAIokMYD1?=
 =?us-ascii?Q?1U+i57Jimy09btYofgt2FJH7r2tIP/NG7QKbFio5gBem4a+LtZHOvHf99NPd?=
 =?us-ascii?Q?jSgWYqoZ/ISihOPwRu6K6+JL4J4Pg3WdfLmQhQRxjpLWgSUv6zdFIH/MZu+v?=
 =?us-ascii?Q?ZAtUWPlk4CYkodvgSAUxuPfKCpxApB22gmAYnEYd6ooR9Cl51YbIRxUt2Zm4?=
 =?us-ascii?Q?hVU6UcIMUkSb0+V7VyY2jg2gpIe5DuNCj1OxkOzSR4ce6/8j951thT14uhtn?=
 =?us-ascii?Q?S3EMZCXXyXwVz8TZFXXIcCoGrOXW+rFghCd4zerKow1eipdDYkoO8dhY60Rc?=
 =?us-ascii?Q?D1ZD0vn5wuiQSFt9naw3qeQN7933OFAZI9smC7liDiDwmzy4HGpuJUlHYVfV?=
 =?us-ascii?Q?NuvsQNOCwc9QZ381fU3LO1Ba4bTxdCCqutRDPTMal5WNkhRAep/gdcDBFKY4?=
 =?us-ascii?Q?+8ZEsa09zymkugj14RGDyyOVnidZf+38ZallDel8qf3w16pC4sPM+G1e6cFj?=
 =?us-ascii?Q?hOpqwbPVcCrpvSKjOiPfX+bYniE8EnUoX7e54Vk1eb+Bexrftr4a3KKcXULC?=
 =?us-ascii?Q?8K40annLSa2cF8+myEtQy0YjgC2UX1dCGMk4yWTcQ2yrSEP4kfK518PQADnz?=
 =?us-ascii?Q?xPBBG7m+yH1gxdQR52dkOdCSJrwimgOHbEKzBn7Fco4PupquOThB3nP4t7t2?=
 =?us-ascii?Q?jzyLQLDtHpjHCaUTH7HzoSC1pWN1vyTbV5k3lgld9byoaiyJ1AbYEa8roZ/W?=
 =?us-ascii?Q?DFKAi3WOjWjnb1ymwLHGmy+O55UwVr2u/0Tn9VRC0n8GaBb13B0T5wEVPhXf?=
 =?us-ascii?Q?VJlejQr9wfnuOWhNX+apsGxNDnu9LQNMDjNbTkZScHlir5G8FR/flNtMIPY9?=
 =?us-ascii?Q?+kehcVWcJB/B6u3LLKZZAayZXhh6f/JJP+EF/sPCi2BoJUsojybDFpQbzkzZ?=
 =?us-ascii?Q?+pfs8CfEN4XkdfILJCJE3SfFsrZZUuhdygm7oEsOH7lfX1hMMyB6poo9NpnW?=
 =?us-ascii?Q?yCRCsEFX4i20cP36fzGkQcdJe7CTuIkVbSUD2uwNPx7d+zeed6oWja8BkCVy?=
 =?us-ascii?Q?DCx1C7P65MVsXDS7fbmKZtvspJpWjL6Bp6iEGUY7AnyzRTRr3yScFi7apnGD?=
 =?us-ascii?Q?9pYHgyKTPXTwuDIDhlzH2lg368hyFjeY2RE+VyDjVrHHoHeX0vSw9bpZ0elI?=
 =?us-ascii?Q?WtqYvN2KLq6t20L+ypGRr6GFrpGHpUs+sJxMJprsNv0ZDTc9w2p9oj/Bc2YF?=
 =?us-ascii?Q?Z6ctxWEaihXhW5GTtCRO8K2OFcxy0HN5t8yJki1vAeH1GZ8TRPqPrUeQ6hiI?=
 =?us-ascii?Q?FgmJ4g0tv39otCS1H74NYJzVhcic20UR+922Nb+PZ7XtZY+Bx43Kc/MfYVYb?=
 =?us-ascii?Q?/wvj+3CnuNWGkfpMDVCw8/I9aQlkgL6XzChrqTTT1UzMURm0N5LbVSM70UyR?=
 =?us-ascii?Q?5qXZ/ziYqg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pVlA2R93NeNx3/jpfcwjetyvcLX1NpDeQGuR0rY6tUES+YaCm91UhoauHIjhQzVrk1e+tEE/2HvognRPnnu9Z7skiaYmof+tDGFflaMA90jsS7q5sLDktGFdk4VD7+RDhCTIHDlGZ+pAfWrt514YiO7grTuHZH1GZDGVAzcKzN43NIUlzSTtO7zG2pe33KB2nwOwd3ZjNOfewdof9Fqeua5kOYyeoPz1+cpJWdU9uWt4wJuRCd7ZGU+1A5gVQoXswoqB1YTYO4eLKOj/LiS/J47/FqJy7cOcuVHwUE3IajDamxHTKxkcjZhFv89cwv9K+sK53L6xYJBgpeK+NsI1DfdrPdavZKnSI+hAJzxZmrZ64Q/izWZriKWonVlLTyoD+A7bGhPX++sr297mmBDaxvqtm24PzGTwhgm+D0MVmn3ox18WStPAhWwJi2ONy9cmyXrU1S532O3JMTQCja0ZFxsO2TbijGwLtIqNisXG6Af6B6k3qIAHsnJzw1HJrBYlKlv4ldiXUhk8oc93SccyFLU8TAtdCdnyYcYyg5AxQNn3Rp/BPTs4cPNO+YkFydop4dfWh5UbqZlx/hFr5B4KGsNa91pRSnWB41NlleyhbHg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713683cb-3222-4d88-794d-08de590e113d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:48.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIXFnZeK50R2FCH48Fs3XtLZAcllnQyO7gQ8j7aZxCF7A4+vVCY/HiMFLjK1rLOomqxzEJ5NSUOUVy9tko/2Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69710556 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_QQW3CUrkSdKJg9byCUA:9
X-Proofpoint-GUID: i7MJiHoQrEl6FpyzzskqL4Wpvr_U5wsR
X-Proofpoint-ORIG-GUID: i7MJiHoQrEl6FpyzzskqL4Wpvr_U5wsR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX5Z6ksG3tDxVs
 ZJkD2evibEOPlVKN2rWGTsS8yUlOaLb6duwVWAfOlwwq1a1W22wm3r+Zz1VMAtGrcTD4BUwy+A7
 qyiPHcCw1Vz1OhUqCckWpUGf41bZil1roOrTWvotJO3v96uH5DccN2+v64h5IU/Jd5xa07p/AM1
 j2cxedmv1zX2iQSLsv0nGFq/3gu6dMfkB1fFVOJDhMsQ92Uv+kUAgEk/3VULKtYlbfsi0QlgJEV
 LUgbW/tmnP5t+2SdVMme+6zs4+6N5b9Pl0RmHRZhASPd6YIC9ahRaWpUOW78hR8V40/Goq7XFrH
 0g3B4o/RWpbn6EHKBzjGbdyyfsDmp33WN+Kn6yyNwSb5BAkLR58E66nRoV0rs6ot5eTHQzh0GC2
 RZ2fTh96+IV0nBAA/lFbq4bVN2166HjNQ/WS4qp7FAHMkw6KRZdCA0EuVO3LE3Ap8AaDlyJTYt3
 zsqRBAbVpPkrghbXeqg==
X-Rspamd-Queue-Id: D5F62C0008
X-Stat-Signature: 4e6hpn4xhq1rua6j5f7efmoy7zhaujk3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769014622-737493
X-HE-Meta: U2FsdGVkX1+hTSGkIZWwjXc4k3Pv6ADGyEXMO6ge4KZZxMYxNbiFOXYOilaiHl06CfAhh9HrZaQxZ0BRtV4YTtppbxXemP+JQbstjRGYGTeuSuYc1J+OwgSa7FmoLsZeeQMX6j1TvNrkFKt2OGA53LUcUNHSuUNBHUgcjI/XXeyn/eTvXrqh9JSAzvCrN39mq/MwiA2kiZbYx1qO+04g8ZQK6mfaXTR0SSBCa0Hfr2aGlbqbult8qqwxx5nfluBZnaoFI0wyOdsnXakrcCgSADIKnB156vaTXxYwkCfHBrc3liPB/2VE5Qfbad48TA6oLKUcnPi5OqAldu5uaJ9NV816zCX2TCoJ6Iag2B0ts1TwIoD0/UWhlpaPs4Ibe2TEM1hpeZsDQxyQtyQ4SfGCbN1494sMwDZDIIQWjf8MJEqz37uBbKzXzwVgOdgS3p5uAgXNdx0AGzJqQ+i/1QT5mq1H+JqaRPnb9fs/C93hzc2bYAcCgA0CrfllZR3LyR6apOTUszCD5F4gbP6D+g/KoCuQmj+a2b5qqMg36F7UojsO2miMsToMAosAsfvFO+oqAn2+t2FPKxOwD2rdY3S1GDqcVJQAixn+Wz5G/trZ1IMVYbeGnQpK1qxIdOZHHyxGv/kTBbUFsfcJQm48JP7OecWhY3iJDeJ0Krxj4+o4E4KK08G+Wz7oB3x0JKA+VrsQlkATYGUvLwHaY+FZY+UvZ45MpM5HOLm2kb3c5a76O6R2PzZTNiI23GcMTpQPB6UYa0YIGHlnznzkz2O6+G9qfM2jgAzqDe8Yh3duMvk2B0ZnGcHJjdsZKVI7maqToea0GCueMnOMpPSxd0sw4zdQyyw6klPqUUmLi0AdIF8q6E7cM7fZNZNHBy9XN29TwfK0Buf/wgiBFhDfGguxwxuUFhksAbiOM6yeU1LW29LJLmlUvfCjteqVDIzvnw6aiwFl0ISzrt5314ziy5NghtP
 ZgOzXAgQ
 wPOBS3aED8KAOKOkji92jLwI6F9I9tIUoQGaK1u4DmYFQFV3yPtTmthUDeLLIEE2AO/N2eWmFs3uaXB3ON9WcrBROtyKjYtp9Oe45YRM7HPxxpMXp+rMTMBm8YGSQDiI7NRD2Wx+KTFK61J8vW1sdg6sk1Fa5l22snMiAWD/ra/hc1vweDYluTlzbRUVzVRhSZ2PUBkjeLrV62q6nbq7VS3KD4+bB4GEfWkb3nnmVThii5/qACJWoLmjsjDVE+LLoi3s8VzPZ3ExHpJLHzE5AAvNIXIVOXqajDa3BToepMO9/tum7TyJaGFOIfGcsmrZHRAjbgO7oLa9KRWn87Mgyy+VMGW9+ghQdK54v/3Uia5Abr/PkabWdCLZrkLO0qay08afH8gBLFF/py1eARJljxMUNXp73QSKQpZPPvr24ik1lqAqtnYj2q5/XVcYmQ/HYO6ZITbCQYCUZxsqGDCtDEpanFPNvHeCo0hLsf9YHj9Pt7lyGHzxyCU7IyMA9gXWgERp+q/+/VhJo5oCV04A/tBSLVqN5bZmYtmnCWfD+vq4zawo8tmlRlEw15q7Kj6lvVWHKK0/Oc9n7Cb8V51gPfIApGh4GxmypnPCMRivigK01qrNJYBcJ+rTIyliGa2QiOBTXMPATs6MIvcUphUWMhyDZhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Isolate big node to use in its own function.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 70ad474e6ed14..9ab42821ee2dc 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2748,6 +2748,30 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+
+static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char height,
+		struct ma_wr_state *l_wr_mas)
+{
+	struct maple_big_node b_node;
+
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	/* Copy l_mas and store the value in b_node. */
+	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	/* Copy r_mas into b_node if there is anything to copy. */
+	if (mast->orig_r->max > mast->orig_r->last)
+		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
+			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	else
+		b_node.b_end++;
+
+	/* Stop spanning searches by searching for just index. */
+	mast->orig_l->index = mast->orig_l->last = mas->index;
+
+	mast->bn = &b_node;
+	/* Combine l_mas and r_mas and split them up evenly again. */
+	return mas_spanning_rebalance(mas, mast, height);
+}
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -3400,10 +3424,9 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  * span.
  * @wr_mas: The maple write state
  */
-static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
+static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
-	struct maple_big_node b_node;
 	struct ma_state *mas;
 	unsigned char height;
 
@@ -3467,24 +3490,9 @@ static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(&l_wr_mas, &b_node, l_mas.end);
-	/* Copy r_mas into b_node if there is anything to copy. */
-	if (r_mas.max > r_mas.last)
-		mas_mab_cp(&r_mas, r_mas.offset, r_mas.end,
-			   &b_node, b_node.b_end + 1);
-	else
-		b_node.b_end++;
-
-	/* Stop spanning searches by searching for just index. */
-	l_mas.index = l_mas.last = mas->index;
-
-	mast.bn = &b_node;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, &mast, height + 1);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
 }
 
 /*
-- 
2.47.3


