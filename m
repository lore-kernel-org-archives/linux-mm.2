Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D515ACAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32D3A8E0048; Wed, 17 Sep 2025 11:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304548E003B; Wed, 17 Sep 2025 11:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBF08E0048; Wed, 17 Sep 2025 11:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0660C8E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:29:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A91201A021C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:28:59 +0000 (UTC)
X-FDA: 83899125198.18.4A88D48
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48FD2180002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:28:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F82baRTL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="CgyAZGk/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlbRQonMKDjbz4yTfEx+r61YgOZiBx8qReGx8lVlMqs=;
	b=1gl89aJFZ0u7XPAQ64zZWL1VDJn5kXkBacdNPQjTLHxqh6YN4zR2xeh7WiU8FNeYLaC8LI
	lk1Mfr1L3ZWz0C0h5UkHbZ28Ag27jXorjHdiX63BuTVcOGo5NyT+VyRgZK8p3g+xR8Vh3J
	Eurs5PJQSvDl0cX2rpJK4Mo7OJuY6XE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758122936; a=rsa-sha256;
	cv=pass;
	b=sPF0/GLDFpZ1f0Bet3BsPdrcEy2Gq/xrGc7OlRe9Eth9J8mJ4SELCqFK079U3Kwv08SMpg
	xArJmU8vef54smKi+ejNnumJWe3Vd1Gapce3Nuh6FJtkKl7nV6r7L3XkLNzijRbQPDw+Js
	VTo4RyE55rDIj07SRTyd57uI5plV5Mk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F82baRTL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="CgyAZGk/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIUgD008330;
	Wed, 17 Sep 2025 15:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HlbRQonMKDjbz4yTfEx+r61YgOZiBx8qReGx8lVlMqs=; b=
	F82baRTL4EQNp3m/RkAWvYB1DPAnqQad64zD546Nc3H1bVPMJ28zV9C6I/yun926
	il8645Giml4R/jnQNSRaUrsymFUEQLskM0Nmw2uXikBpvPMXO8tEBzfK0A8radmf
	NlMEP5woNHmWlZ00BGTEMWwzncAXf2ID3HulldN5Uji8erTSDxZp5X9vZIknAkUC
	XBJvtFnETstSDq3DYt10boEzam7+LXgDEdcgK3qJgq6egUt3k5HvCbrnWtYv7smn
	jSXyIiXvtBGbMZGsUTcRnDJukPo4CuRm3NZMhSb+2/KC4tKP0uqP4z0SW2GbdVlH
	EshTaRSDHnr9YS6ZDjAkKQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx8hg37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:28:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HElHe3036955;
	Wed, 17 Sep 2025 15:28:39 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dxydt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:28:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VgNhrIDVPH7VTM0t4pg2ABsveHRg8Sc1ArePaYlmSG3TDYU3HhsYd45zxxEn3XST+hdIRn/D+HN2D3zDIl2KFkRr/77QcQt/UYZ3QqnRAZkyIHq56nndxiIjpCPDGDVrIgvGPkuF8gIPb9gvz7rRAm8punKu5isoHQtVtjwdCJb5PBC7hzrsrCT6os7XiuzXQRikfzPo7py3gWW82uSoKeBbbssClVx1COqT1erAOqYT3NM99+pqQUs2c2pjuu3311LIbHXs1VhMzqr6anL9/6zjxRV++xes/fM1v91MfyQS990fEAvkf9dUkSPwHW9fJ9X2jvEfVLfBbBPLTa/DbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlbRQonMKDjbz4yTfEx+r61YgOZiBx8qReGx8lVlMqs=;
 b=JlR8TpQfzEJWIGQ/3j/QxQ2840gP9l/itrLAsNrRmNCFt7s5jCi3uR35sE9MxYnqBjDATL8zr7q/gSDJFRxMT1eMLEumlgJ/BfesNM3TJmmI/3QK/IzYtBTXzoewnS9l2HAwLCI/c5vmcb1Dvt3pptVJyYufUAY/gGS2Gnkt0afDszBco4TSdTWpHPEYRQKbj28h5ayFTWWcI2CuXjMhjhb44T9sVhcn4XTbn4leUG1r2d9Bku/967QO/gzQY83jSzgGEISQ/hDib6uFDBi+cFuoXDp6WDtiN47VirnGXhCmw7MqzdhyjmIUbcv5Qbbq5i4PHzXWtNin+s+GAFlLtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlbRQonMKDjbz4yTfEx+r61YgOZiBx8qReGx8lVlMqs=;
 b=CgyAZGk/ZK9He6m1EGePETguhNlAeHFJyxvz2uUlhwd6iTgLLaOxYR9dcYjtKfcUlrqsdQghylwpNzKT4jQzmTCWuf3+rCdi93EvtsNnxWM3s/6qf/nTmB26gIDkvB3OwPsRsck+wWihCIJHtIcuWiFpJw1UzG5clpjtBbrorP0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 15:24:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:51 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 15/16] x86/clear_page: Introduce clear_pages()
Date: Wed, 17 Sep 2025 08:24:17 -0700
Message-Id: <20250917152418.4077386-16-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0049.namprd16.prod.outlook.com
 (2603:10b6:907:1::26) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e34363c-956c-4207-4fc3-08ddf5fe5878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GbHZbqF5C7BQwF6vGqkIsbgQZy8BlTi0wDHRW/gPxuiFqseE9ie0DOAg8jxU?=
 =?us-ascii?Q?qegbi9TVuaYguI2SM6Ncnz8ibShY+jPXKtbE0CUqv1uM8S0lLKC1gJStiSkR?=
 =?us-ascii?Q?dVQrRJOUWKOJ0uav5Ar3fcIPOs7P/xwOj6E33Xb9TX1FrRkijEt8sRfahKqd?=
 =?us-ascii?Q?fNNUW4qkjFeyLxAL71JqavJIjVuFwFcF+dSbVGSC2mzfywcuxM//ZpTdF70i?=
 =?us-ascii?Q?WuP1TeZWS4SUjikC7j3FN+Y9uRHpc8eoAtNUAoDckrdSJ9yh4VUrjqxydJCd?=
 =?us-ascii?Q?ex/tlhz48nnMZS7gDxglWoxyYexKXiblzaMovCA21pH1jdzbZd3UjAQzbHaB?=
 =?us-ascii?Q?9Mok7YnqLKyRbpbSp13tx9/pxBpNRT1kf8lxqpheXjPtn0USBqzbCEcHhBmM?=
 =?us-ascii?Q?PcliAjr1ql++uMzhbuZzHI1jjAeK7LgxOeAYIl5E9D7yEC4j8owD0rourHhj?=
 =?us-ascii?Q?qCzRPBsRoPsbIYc7KucLp0hbZryrO06Vgk5jfSSIfw/mpfLU2+EdsK24BHU7?=
 =?us-ascii?Q?JGvebFw44ukhXLN1cvA6sqxFGpyMt4yuJ4yWHC9WhQiVGehPBo7KKN6Z/Gto?=
 =?us-ascii?Q?peJRLEELqS5Ltx2n2Ofzvq8cIfITbAlyl1QmgMRql2z37VHmLgKrGKfrmXy0?=
 =?us-ascii?Q?2ZPqM/r8c1vF4AeSyhHAZZYQepg+pIOHgzQ1c4xcU+ToNHbza3LLaGf22Ttn?=
 =?us-ascii?Q?7OpBSLWw/PTghvRS2yknlqAiSeE1nPsXYAINLWikZekRg4fsOyzL385Lp25F?=
 =?us-ascii?Q?DmlpAaNQhtL/YLNhFqMJ4Q08NzpMNOKC7kJwS2x+ngOIMqhPVbQO5VJcLML9?=
 =?us-ascii?Q?1t3pC3nhGxtVLCTs/IuFv8KVlLCmrckRMjuAtTQfKZixLAPJrlq6ygs8nHVW?=
 =?us-ascii?Q?u9GB8bhBIWwNdqnluxDDZ2pk4bHvNxLOgQ82og8x45y7HsCmPr5CnQrU4d3E?=
 =?us-ascii?Q?lsD1hxvlmzXLEEUXyHlgh/Hgh28GMyfmR4aeR5OIRiBpsQxwhHtLsxLvPd6N?=
 =?us-ascii?Q?czNLVZHtpjfyWBf6jc/+OeUSQIo77Dk/WvO2K/qk/dd9W/Pf2RY6P9FSnn92?=
 =?us-ascii?Q?mEcvLzt1cj8ZAWWNOKIBdbBLRQ+vL8tuj5ELP+kE4JTSp3YEk885C8ABH+Mt?=
 =?us-ascii?Q?CTdulAE7yV0V+VG+gMyC9Xp7teuNUUjDAgnc8qUOoMttsm5Vo98HvnJSdlOp?=
 =?us-ascii?Q?R8DVxnS3y0JZ5tL8GGPp9kxNhmSCpQgeLUWfSxPikmeW1BnoFXT42EL4gMBx?=
 =?us-ascii?Q?Q6CA+n/BobLDmzvzZ/2VgGD2V1vdPlWA3kRrRbzfa7ppOXS84bUJ8JFCQTtt?=
 =?us-ascii?Q?CnaBrVys/Zs3NqnzN9BcCu+VN+FWXF8rOSEDTJ9DaMalpRB91pxdt2ZOP9pO?=
 =?us-ascii?Q?JmO3RfnQ6yH8plXtA+E2/Vg371SPv5kQg2IGzVkvFSmuPNZqV/lYFS9Q71rb?=
 =?us-ascii?Q?oXBbb0fhsws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4zUKHHmXI37Z4OJ/oHHlgEC1HnlKqMlHY4N6YM6qSU0Mzc7KpiGDgFxLOJCu?=
 =?us-ascii?Q?5Y67QCRf7d//p/GJ4khk8Vsg0sFJL0QzsdXAeTVuvvRtn3kIIiS+bC6clIeb?=
 =?us-ascii?Q?Gv35lhQr64tcms0vMr+kwvARk1W/Wbzvbi+aew1/QBjdH0MG5A5jmEcUOieG?=
 =?us-ascii?Q?epOiLg3PtkhQX6k5z18o2zGdMVzjuoaWF3F0dkYdbpSPec4Wo/KFRphqVVhA?=
 =?us-ascii?Q?fOetbJJOucqqWo+2o8SPyxAY29QmVO7OFkDXkkbeKioBFHuF6PS7HSswYQbV?=
 =?us-ascii?Q?iA8feXQc4/wJQHBdFgopObs+EdQhOt2EcvT/Bm1yqEKu5QprfzA7NMIlbjVV?=
 =?us-ascii?Q?CEeQwLPlaz4bNKJ+33Zob9y8vyCNB6IqilmSGDci5eibu9VuSQgVLiDhz8oS?=
 =?us-ascii?Q?BnxDFOz5ARwyNJ/VxjRlYz4hI6/Xbx/PtC7oFNLRK8XGm9OU5rIw5i5b3dLv?=
 =?us-ascii?Q?wWOMdkGmtelWATkh3DZQcG+r61kytJ9jHMTPwzKihBcN2uPT/2cM4bQrzWaa?=
 =?us-ascii?Q?HLtXgJcjFQwGlCTeO1idx6NWMGUbf/RHAB5aYcR+jYeQ4RJNcupz3GsOlTLm?=
 =?us-ascii?Q?3hM9/3ZhCNb7VOQ1/SNJ+cTe7SFR8fwL79GMXYH27ZBFGe/UljgTeuwxZxSI?=
 =?us-ascii?Q?lCDgC0pG+xaC9nL4x0/TawKtg3402fIsRtj7Hj5GItsrGPvc63Zdk9duYXDk?=
 =?us-ascii?Q?Ke+y2zEcIHIHIR711SWm+f0xhdeAQny3Hrnl8Up6CIbOOXusyzJifrTXVInU?=
 =?us-ascii?Q?yuVl2t4TsyJ86wSjghe7tJDxfO/eQzS5Q3ok69ECBMA9r9MJZYNAlaxOivNk?=
 =?us-ascii?Q?2oUhtos9m1yEYSCumXYlSHxEEpQchGz9qZX+GGVJ0Hqu6zCL0rrBglUs5MbZ?=
 =?us-ascii?Q?1nblCW7kDhm4CpsWVkOwmOzQe9aITbE3h0+mbgsB9wzDvygxbXqIreW663zb?=
 =?us-ascii?Q?9RIqzf5XG9wrFqnT03D4129AhzulDZR123pLDBiKEvU/IL7Q/Ktck2MgvtB0?=
 =?us-ascii?Q?cQuPzdWztHu5Fmh5z5whJTbX84pHeYq15dhhkmetxcSyRJVhHQCVX9JRlUtc?=
 =?us-ascii?Q?TneToMmRdU/aR0TEdc40zZc9lv/4Oot92tzzZKmyNfCFWuqi4cEn15kdfSrL?=
 =?us-ascii?Q?P/NiMRzvU/7xA8HRTcZO1HGSzC/PaeQCEMPVTzL5V4/toVyA6OiwgCSGnaDc?=
 =?us-ascii?Q?D/JjIFKCcA+E5HMp7VGLY4XW4GvbPBwehrbvGx2LJh3rFEOcL0PwEkIR2Ty5?=
 =?us-ascii?Q?rx6UOZ2156HADUhqPTSifanXIDe0DmOZVB4ZXoTNn8+fG4GY3KDL2OLi9puf?=
 =?us-ascii?Q?vnM/iK18DGWQJ27qrTSg5nRqdDKPXaIHteoDuC9WQ62QgQ1TvUEmsBCcbkp7?=
 =?us-ascii?Q?QDGDgQS+Fp7GeQBrlQN4p5cUoBpgdpowI6jaW7l3ZjB2W9ssd93rq8ZWssky?=
 =?us-ascii?Q?znhew4Up2MTaaSFF3HBohN4aKBEeBhzx9EditInEhdi5zEZKub2mnQOBbQ8G?=
 =?us-ascii?Q?mKhePYLxdQQ9IaNh+RvzM8H0f9H4vBiuDmtO+TW4frBkeSVcBdDepHyLF/xz?=
 =?us-ascii?Q?EtOBtMRgCvra3EVaDtzpcO7zI/ajn/D+ZaDp9EpIKtcvTp6ofB/obA0zDJv7?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TAF3GQ5eO7I0/Ys+khh34ZUhvv7CNTY0VzR6VuJNZlptjV/sVXF/BaF02qL6MVQzb/iYtfW3XBVUWvXStQTxL55YFCSagAA/DLH46Toumhk6p9pkjA0bZnuvDyHmqztaEd5bv8G71RbHffNduHRnDZ8klZLsHPyt6Vsi2swGtyoK4BUhInV4do6RQocwCKUAwvInhOen67Dqnpo//Q7f7AuJdN7+GDlRnksBZODN67NePMhj2OxwyJsywh6R8hkP4MpFInMz8CgJnC5idsfegf15y/Ma89J7DTFZqPC+ObraXAjH2U2FlI1dJ4aiqkF6kG0hQbH8TPlGzJf3W3RjnK8ZWkq+VHdUAjIji+gcMV/ftLtER+BhwJ7tavBMaA+fbPSBr8IZn2hnjN84w7NUWVMm9iee9bPfmaN8IwwckOR5Z6rI0wTho1ECI6l9jdQf6NCcjH7x6Z+joafFySc82Qn54k6zGAExX6P/JvdBIbBgiWYQm94PihsJpv1jyksrKQ0KL2f3404YLQ5CQ0R62rGaDdApc9KAnYY8Iwuf4U6E3PC+ei1wMrSN8s1Z1OU8Fzcd9zETc4Ml1U1NVwJ9mxmnq4wzYnyYY+2alKsyj7w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e34363c-956c-4207-4fc3-08ddf5fe5878
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:51.2889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIOiwpWQmdWIn170lQnL6VwYKozpwzavmlBSEyrqx2Wg0JuhaZtrPGfSm4S0S+4PTKF0iKtAJ+9Yr7EFnqtX0SMqh3QYSPUc16r2DQ5yW2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170151
X-Authority-Analysis: v=2.4 cv=JNU7s9Kb c=1 sm=1 tr=0 ts=68cad3a7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=M8a9pf4_m8jl-BS7tPkA:9 cc=ntf
 awl=host:12084
X-Proofpoint-ORIG-GUID: qz3Hn4wITg6EF79yW-vgL9K5X7-o3Ecc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX8e8BcImXV1Od
 V7jUItMGQjYMqhKjR1wZEqB3RVac0PBpb7N6GUSgE/70Oqg0SfS4vzWgK2ufakSmPhCtzZELoRo
 v6uJeCCRBXl6EuJCvp4yUmSCw5mTo6PRqtwMlAonckpJ/SBXjuFw8SfAfxFqTiZ4nPLIPkrdO8O
 b4EX5alUh53DLbshbd2CrbSoYHGW3vKB8IGiNvJemJSLwSYaFwPPYGYsJntVPi6+RA4jSm+acRK
 xLcETnv2KNTUUVKo1+askz8VIFWFfe+J7lIddU3eRCSIRSKFnS1fqVsc1LuCEfY0SY4AYRCDnW6
 bUJHoWKuyNNJX3rtOIKeR7EC08r6j1HxVw4+U3etRV6Mf19f6M5vI90ygy+i3J58MZAGKyvvDLB
 s0C6SIjBNAemcLtwzPxnSyD87teG1A==
X-Proofpoint-GUID: qz3Hn4wITg6EF79yW-vgL9K5X7-o3Ecc
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48FD2180002
X-Stat-Signature: 9cwdu7xhjj7qhnbqg5pcbxbgfmi1nbq6
X-Rspam-User: 
X-HE-Tag: 1758122936-556752
X-HE-Meta: U2FsdGVkX18x52wYjtFLPuAdq6pCBWM0vHcxiovqauXvebQ6GJ8Fj/fbh285gQYheA5jcnCmYqgiguruimO9CX4JSD6tvItmnnB2KaVogZhD0Q69IhZduSI3Iyq3TGOKhqOERpCqdgZ0GdNjKdfKApM4wFtvMrlJo7BniJkZQiWCjR4HxXQXt3+Z+wmB1+76+sdd7ywdOw4ePdIyvyptRPv9tckM4DjN9Fh2kjcsiiYDvQizzv8oZUTkgSbZ+P4cLmi3lvFKZrTLyupLB+4Q4LQv4nBTT8Nqv2m2tbvxwWkP0DTUd/1Qgax1XgKoUUZa0X4mLzrFNdjGI1jPZywrcn5je9PUxvz29c8a8sug3DoD2OmvgIFCwdcnamY9+4NxiXkgtfYOfd7p/Yluzp4CRcxS1zjwC2ddMqGiTa7ibJpTIcYaSQQb5rIsU5/OiVOtch3uDeV6E6Mmyd4/mE3nNeoYWBy1K69X1RIhLMPsZR5U7MTSZ7T1CllJ52wQvciYrG0C8G40U5Df0a2HqqVqYhKlActbztSbs8PED4xELtOkgs1u6kqVHRHB0RHrJkYC13cajnoxHIPB0HBWkxrMxNnGuKv//zsOkgDAXGVC6GOelGN9Y99D+Z1LSSssUemFOB2cF9DKHT4Jg07e+Axqyp8+Nl3gFUPtyuJPOetAjNRUjQTnQRHkujNm46Q5lNRTgkhL/0M766ITzJ47TbJ7bKBWl0CJ1HapUWLblUsRC7hTUfXJkJu7CLtsEdntswvKEdhNm2OpD0Si639764wBqzPqMsemNGM/IXCWWLXQIQOATZkEhUdDQH/kcMcH+4LLHym5O988Sl8eB7LrhSO2X2kOAbNyqUBShdMHBOcaqepXOOFIO/3zjz8QpP42nsWFULhGC6n1KcQ+5pRWVmhNkTKGEx6yYIGSJduGcsFzKF/pOTchVbZwEwk6c4cQfJItt+YFR1LSpUaV0t1p/aL
 gjK4qgu0
 4gnuJ8oVXmrus5SkHrenMZnYLlaCVp1bQ4X0sqSb0yMVh/JkGXMZktiRurbYaC0HoLa2TAtf8DyD1qUTZKkw37Ge9UvQhODVFZOpo6+PgtA59YepBf7SM9KpZ2M00ryngzljXiEbARyt8zueCNaA43V6OMI49nBWLQz0/QngP7AcCViOmvsyoM7uEnGaz4ObJL0awzLlxHvTT3jlhYR/6euYYJjGmgKNWLSspj0vK3Xsv5n7svxo5xMCdqo0fsdMjbAt9lJCIAyAhsKq7s1exUYV9HPTMoBxIz0CcsDGfh1vVtH6Ei63jI9cl6+6l69we3FrZ0s0mAdLSvVdk+h1gO8Ux/StpReoS+Fkjk3LmhSKCQaT5W7ZIA1H5xJqpdlw7fgCj1bW85xbz1ZdqwaK2C942M+RfuJ1OrxHdqXyyTEnhiw32bBek6VVDAofkD51aniq1di1rDHx1cD7JCcXhjlHYbv0lz8dXs1KaqxSobH8y1J6LR5Ph4jpknEsOU7+S7BkXUQfzmOwkEJhh88gF7H7ur6KKLzskCfhRgUo0uOEE7Enw3u2L0rCt6BfEzpcc6dbGhYdaX+HUTV89UyJtV+L4wP/PKh5sJ4tb+ltnX6McTEyX7vFZd924apiIuGsVzZUzW/32Qv86JZ31lTesfVTwcm6owKlkXyRduwri1PMf7/G5ax9BQxjJZ45g8S57iQaJX1Zu++xYlD+Kv6w+MGsAztFBTVMQKBek1aS8BaFSdcsr4JCuQiK6c20PBVDRlPWStaplkRhc+1MsA5HIT3PBrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Performance when clearing with string instructions (x86-64-stosq and
similar) can vary significantly based on the chunk-size used.

  $ perf bench mem memset -k 4KB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      13.748208 GB/sec

  $ perf bench mem memset -k 2MB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in
  # arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      15.067900 GB/sec

  $ perf bench mem memset -k 1GB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      38.104311 GB/sec

(Both on AMD Milan.)

With a change in chunk-size of 4KB to 1GB, we see the performance go
from 13.7 GB/sec to 38.1 GB/sec. For a chunk-size of 2MB the change isn't
quite as drastic but it is worth adding a clear_page() variant that can
handle contiguous page-extents.

Define clear_user_pages() while at it.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/page_64.h | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 17b6ae89e211..289b31a4c910 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -43,8 +43,11 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 void memzero_page_aligned_unrolled(void *addr, u64 len);
 
 /**
- * clear_page() - clear a page using a kernel virtual address.
- * @page: address of kernel page
+ * clear_page() - clear a page range using a kernel virtual address.
+ * @addr: start address
+ * @npages: number of pages
+ *
+ * Assumes that (@addr, +@npages) references a kernel region.
  *
  * Switch between three implementations of page clearing based on CPU
  * capabilities:
@@ -65,21 +68,35 @@ void memzero_page_aligned_unrolled(void *addr, u64 len);
  *
  * Does absolutely no exception handling.
  */
-static inline void clear_page(void *page)
+static inline void clear_pages(void *addr, unsigned int npages)
 {
-	u64 len = PAGE_SIZE;
+	u64 len = npages * PAGE_SIZE;
 	/*
-	 * Clean up KMSAN metadata for the page being cleared. The assembly call
-	 * below clobbers @page, so we perform unpoisoning before it.
+	 * Clean up KMSAN metadata for the pages being cleared. The assembly call
+	 * below clobbers @addr, so we perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, len);
+	kmsan_unpoison_memory(addr, len);
 	asm volatile(ALTERNATIVE_2("call memzero_page_aligned_unrolled",
 				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
 				   "rep stosb", X86_FEATURE_ERMS)
-			: "+c" (len), "+D" (page), ASM_CALL_CONSTRAINT
+			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
 			: "a" (0)
 			: "cc", "memory");
 }
+#define clear_pages clear_pages
+
+struct page;
+static inline void clear_user_pages(void *page, unsigned long vaddr,
+				    struct page *pg, unsigned int npages)
+{
+	clear_pages(page, npages);
+}
+#define clear_user_pages clear_user_pages
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_page(void *to, void *from);
 KCFI_REFERENCE(copy_page);
-- 
2.43.5


