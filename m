Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FDE1D6261F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2E66B0195; Thu, 22 Jan 2026 07:51:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C368A6B0196; Thu, 22 Jan 2026 07:51:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84216B0197; Thu, 22 Jan 2026 07:51:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 925BB6B0195
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:51:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55FB8139E01
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:51:20 +0000 (UTC)
X-FDA: 84359585520.30.9375D36
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id D75A84000C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:51:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qR8rkz4V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BJMOUP8H;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+IZC1ba3Jkh+iRw6g6wQtQfVmo3xUtCqTL/ZaWBRzk=;
	b=YGDiH02tTL0mHTLhKicb4hh995kP+R+VG5DozCdySDKs/x4ZDAIXlEAPYU0VnOEKb8XLk8
	SSxn7mcIOV5IPwHXChTmFVxE5jxzzBiL60Y8NWkYOes3O2/CzI0YSla6DfpmSoJG0bK1Lq
	3+bZ1K1Fz1Uwx+Nk6VflLe0vmSm0dUs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qR8rkz4V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BJMOUP8H;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086277; a=rsa-sha256;
	cv=pass;
	b=cjsPUjpSLdjmaewj3jZJh6f41HjpXWiWIif9Is5RlI+ll4mwJzxt7A78WC8l13QVwRuH6G
	/7nEqc6kiMOGKKk10NR08/3PszCpspkpKjs9Ic+EI85FtMhaAIQ2/MksQZyTrxMPvATylp
	EZFfnjLjEOZXA/jhvFTyXB2C8QAxQKI=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LMOs3d3029082;
	Thu, 22 Jan 2026 12:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=z+IZC1ba3Jkh+iRw6g6wQtQfVmo3xUtCqTL/ZaWBRzk=; b=
	qR8rkz4VL63jVnrjcoqapyCgmNSPB4/HEmUvi4WOJs0YZ5xlDry+eCLaMw6kwiy4
	4/6Zj2+wJGjON0C1Piz38TtFLocg6NZhWo8l2fDcYUxEEfsjyK+UXJat44HxmcsS
	o4mUpNGYlqLsSTxotdEqGJlim25Bzgav87Hslec0Qma83+nHL5JseVZWu1mtq0rH
	vMtSb31bLj9TDFMmsI0dN2ni6v22sniORYMiHiQyoZXALOveMlVxwFPh/wPErXFC
	y7jPwyWRfLy0hW7IUruahpToKo77hvSsH8UveKbQpufgyDmI6r6TI/D6YJWnLJHb
	d89lxzqkXnqHKjNJlrzcXA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vynax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCUmXi032183;
	Thu, 22 Jan 2026 12:50:54 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011015.outbound.protection.outlook.com [52.101.52.15])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgk1tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kaUWN8TMoCiP+GT/dU4aLBKTP+vfctvqh9S1e87r8pawZn+rcZ6J0tFVQnl283KJZcAfFM/nMphlmqY1mWJrqQiwMOn4iegD4TXF4uw4KMPgTEGpxf6SaQd82J4FlbUGzvUm5diQS5qIoEkSNUPTVQ3Xv7ecqnzCBRDCQskXXxVvSGijY33F/ELlRAWrJeRuj8/xXP9q5lk8i9dkjF1x22qWrRqCGAtkwj1lV0mcPE2OMjIaFPJDfQ6sPkvdnGZe8pLRPOtwi6O6J0LrbVwQ8twLcAkKxh/QOMEFtizMC9WLX9Pi8RHbH4UHexyrOAjOdvsVgLAX/nAKdbjVABIyQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+IZC1ba3Jkh+iRw6g6wQtQfVmo3xUtCqTL/ZaWBRzk=;
 b=grrXrOAEAiDbmcZr6aBVVMCTLvLUQZkje1HRq8FRIBaGMpbuLfBhlJ6L4KQCacApBSrdEhFSFWXga3EUkBqpwjqLnx1Sel09NCNda7NmqjpfYwETH3OaGnpEZWqHC7nnJzVTXSLXH0DXhN0xiLAwp9Y6uraoEjxHMqs6BGepLzjjhiFmaLJ19/jT1fU0UQArBzoEcSATY9us5C5vZEo29KJaI9UdVzy1ncKyowwtXEbanIqzFoAbICLe4qzfWUfCKbYDpQ1khZNM/1z5TlCGNBZNoDrDLBo25ea1JTh3Lld0+QOiljqL0tq2pGRyqqp9p/d9vPeNGCdGjHhpaFj+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+IZC1ba3Jkh+iRw6g6wQtQfVmo3xUtCqTL/ZaWBRzk=;
 b=BJMOUP8HFn1uqDaWCXx+jUdB1Z4fFxiK0hucOP4xGiWaVBSy1JP7+omg9xb7EUxLVgTTNorJwfcmRKwAHYC/9rsNXgcu9uQdZq3I2DhiP625DFQuJyoqwG8QqoGyvQkIQDYFFiTkT+R3wrb+kIo4kLYCHSKLPRk4iq+lHpUE7Z0=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 12:50:51 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 10/10] mm/vma: add and use vma_assert_stabilised()
Date: Thu, 22 Jan 2026 12:50:30 +0000
Message-ID: <69fe64ac89cc9640702af8f1a669f742eb6a30f9.1769083595.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769083595.git.lorenzo.stoakes@oracle.com>
References: <cover.1769083595.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0412.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::16) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: ea75c6d6-3529-44fe-ea52-08de59b4dfce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yma2ul1xl+iNmGiNrogUvPA8lRfh7E0up9GxF9ZID3R6fnhVKrgnXR4s8KpV?=
 =?us-ascii?Q?nkdnJtJZ+Y5G6IJ4AwGWPW14GFmuqZfaUQs7xba24n5V5/zXXgfFecqJ83mr?=
 =?us-ascii?Q?jPQmP8eqT0o7im9PD88okl0btEQ/6oNmhKKofbJf/oLXdD2JKUId35WnqHYU?=
 =?us-ascii?Q?N2jn3jC1W6Ewd7YIPj35m/UOv/sTR8bPd0cGnrVBjSuHB+ZYMSaJMUDchbTD?=
 =?us-ascii?Q?8E7rZPeLY8nXfzhHR9RKGLbwSGyFk7obIr6BvEoqs8V+zPIEQhnVntfdhyLN?=
 =?us-ascii?Q?STclqqQIK/jZ7fvl68EqPEM8d4UQpKZZ8clZVD99y15Ji3SD808XRdme7eY7?=
 =?us-ascii?Q?720ANnFSzj3tyNyyiXqthxRpjO34th4ACFewGfdiywPv5JbcfXcRUj0rukVM?=
 =?us-ascii?Q?90bI9RKoHUiqv/CbTtJEbF8/OMap/2dncJhjsFA6zknBYb+k96itVnTEgTLG?=
 =?us-ascii?Q?G7h7YEwXRzBp7XdwKwAXIPByXzg16dBjsIFxo4EOLEF3Rd6Slu5CAAfoc9lb?=
 =?us-ascii?Q?aeHyqHaFvRZv9JC/IDQzJqtikb4ItXaQpvw7n9mNiHv50XJbI6ldPnl0FlHV?=
 =?us-ascii?Q?Q+nUMMfQJNSvNKshOqpP4QwfxpmhLdfPMpo4XEeD3WvizFL1k2j/HBbYDFOu?=
 =?us-ascii?Q?I7qnIZZ0A7XH0WAy6KzCZNYobkQ4y9Dk+Sh3u2lxUBLdO+dSCEODX8KKLKMf?=
 =?us-ascii?Q?gHVdHbpwRDYSIkrXQcdWc/xnLo0T424l9TbaglAhr3vVd7nmYTsaZDjBp84K?=
 =?us-ascii?Q?eq60V5As17jl/98tmU/jJEsAEgWDZPtEwLo3VB0YS3nwb9i4AN3CN/2IdTg/?=
 =?us-ascii?Q?77Tj74IvBR4tvti6NUicAoxIiSBD1qZSF+l10a3Ufv7nsApG12zYqXHYLGqD?=
 =?us-ascii?Q?UKFTgnTxBaPF38I1fzgCWNpkFrPDbXbRUiZLcIIGWlP6YbZXbEbQjuRu20Uc?=
 =?us-ascii?Q?1jG0iowPiLGA0MR7soIGGLKSNAGof9MbUo6TfQCY2hK+ta6GuKI5XESUKfVz?=
 =?us-ascii?Q?le0atUON6HntPgf+kD62ZVwFn2AWtRePD1IUoGk6BHdkCLnt/Pipjix9Em4R?=
 =?us-ascii?Q?s6G/eR/TJxGVVukmngHGalLlf6QqUtSm6H+cnvlyPsVQbSh9YXoc1dr4jeCr?=
 =?us-ascii?Q?Bo8jC/l1AMEFLYkywRSR88dHZWhXsILicC8b5gGhp2YnRAnLxIuyDVJMn31W?=
 =?us-ascii?Q?8DsPHh/e7KtPAfTM450zCrKBE3M+6ELv0GKl+Bw0hrHLJwg9Qn2Y9g0asCR1?=
 =?us-ascii?Q?KF3onrx6dge5YCXu4r3/2RTFqIW996XlsqzjdnjIBwRxvjqxNPvR/WzpCskW?=
 =?us-ascii?Q?s4NLQ3iZLKsyuSRnFrya6V9a0ZB3MPvgE7UygRrmbWdJLwMIzghEePUpDrlt?=
 =?us-ascii?Q?Duwmr5lwkI/pACEeE723SUpXfmB8kk3NmNnTvPAebcKL/S/IMG3kH+7Tv8Og?=
 =?us-ascii?Q?3A8QmcsRmo1f7+Mj0WzzSK3ETdWBAbgic8hqo+BOS4lJmyTnVOOJoj2LBmfF?=
 =?us-ascii?Q?rldgwlGpJ7xBn7KJkh++rvhGvQVGykq9TZhJnLE8y+tJzNDnXFz2kawQcifZ?=
 =?us-ascii?Q?Vh+GSTvNFkZIPEsou/Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YYDmvqW0tDXcSzTLtZ7uN52rqw03KQbkA7k5sOhJDB31iEGrU42Odp2WMkFr?=
 =?us-ascii?Q?mYV3eminWOuDPBVorBMsUNC4G4NcRzlm31JjPJ/deqp3yXZcZDbbLJ6ZgWRn?=
 =?us-ascii?Q?NNVuH0+4ddQCh16uhXTwpPysrfOw91H+/hjn77RCA984rZCI+aLg0tzpYS+Z?=
 =?us-ascii?Q?6SpxpjomncO4vhc73FcJFh66DxwKEJez+ogIPIj/pLq2rvCmRPAhKEyPCGSS?=
 =?us-ascii?Q?cpH6PfQ10IRvjOQTjQyAWv1KwNBZEUyXp1PA8d4xvJXZ5WYTe+8J8nZ6iMej?=
 =?us-ascii?Q?sPzwENoUmuI65tdsSrRSjEXUX2oIheOqlEEj39i+Try7dlJQTwnG6MKCNTNF?=
 =?us-ascii?Q?cu74+7WWIQDTrVBb6wjHaVCi60gjEjPII1A4Q9kZaDwStPg8b8ZTSn1JlqjQ?=
 =?us-ascii?Q?vvhWI4lheQZtiXIHfOKCMiqxd8dsAnAgcAc680KG35TOtSk/vxYBnH4W2YDA?=
 =?us-ascii?Q?W+QLmp51eS4OPeWPisJdo2JRzf+3vTASC55d+4zDbDxT7U1TWg5TjbaC6YIV?=
 =?us-ascii?Q?FFOTCOfAnhFqZgviDl8mSlqWlItf+g18DAXI5MZF62q+wOqu1j0JUKC8Mk+o?=
 =?us-ascii?Q?d6ZzFgkqKfuiMHeJ09PFQ68bTnyefh+7ZVAI82nnqfC2PbdLw1yEugsZ+FlR?=
 =?us-ascii?Q?uV8mCO2+Bsxttv/12aWWaM7gEzchJF7+Iucs1l0AGME0kEvJKWYOraNImaF8?=
 =?us-ascii?Q?pKl0jSg3lJ0SG2fcmfiNm8Um6JddOQKMb2rbz7miCFthbZVOx7zGYoftw9GR?=
 =?us-ascii?Q?dYIkig0eL5efmXxHsl6nAAxydxeDvTnpsttTTpZEE+qzeFiPFW6/mIfMKuRP?=
 =?us-ascii?Q?f0fnh8WJme++U+R3Z9KZBmMrV1xQud5PNAZuZK3zMhoKx0dhmcthsmPY6PBd?=
 =?us-ascii?Q?gRW1hUdO1HMDvtxQHUWQCMV51Amal8qY0V4w9/hI+xNHG4Qsr4+uMsVS4UzI?=
 =?us-ascii?Q?uwQY6W/9OR356kd/7Ip50G0qW7oNS4psMdVJdwVwjQPM21vdynFGvnEdpKCl?=
 =?us-ascii?Q?iVhYbAmDMRi1snBOD/zOnO0bT6IX+Q3FJwtu8PU11+EL1m//tXSWipjl8zWF?=
 =?us-ascii?Q?RLm/tijRrTsbAcYTrR4YHOZm6X3Nrr4KOnhuGZEQyT+JMkIk3dU52jC+nxyZ?=
 =?us-ascii?Q?sl+m9FWD9nWl8GATE4g1iIagsrigNgMjk7tawUP6Xx5/M7BBkM7lEG5Vx48f?=
 =?us-ascii?Q?qSFThxk5iHl3sUAZof2Lbitzahsb4CxXGu51j6Mp8JbhyfZpoIs9Cf4+5PBv?=
 =?us-ascii?Q?W9DVsregF1YZo/xaT+xE6gFYVn0Wo9her8O+myyDKaXwMyM99vF9T1Lquowo?=
 =?us-ascii?Q?s0KZMpC1RAXMqnJqr1tdBKcDtkN+RSBgQyb/3trm752/c8OZz4xf3oiycLYV?=
 =?us-ascii?Q?VmD/V6RQCbfMzat78twHX8idylIW5EZ8t0QUrc3vULAnme+VMcGctecz/kG/?=
 =?us-ascii?Q?fBMIw2ECD0b/WUjgBjRZoNvNPrZob98SZJACeTEnr9xfJ9mDKah07Qdarc6U?=
 =?us-ascii?Q?O1D25k0V1qdYE9A19/1j46qW4lPV4V4ZggocgF/Z12kmwes8iQ1GUpsxY3K1?=
 =?us-ascii?Q?0a/ZXhajyM2rXU4IXOnSwUawjjnbn/Hk8GskC2s74VdmebPt+YTAL7U+wKQi?=
 =?us-ascii?Q?Gsopi0caLkZrJwD+piVprbdIslMSSnHetsbL6uvRj6qTDSyz/1M07CC5AdHh?=
 =?us-ascii?Q?NF04Ix+zpIBSHZ5q9QnynOc0gwDntozehewlBSLt/iubiQa9c1semabgLT+2?=
 =?us-ascii?Q?KQAko9Yn2jepTO48veiIotmDKDGaa2M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9mpdibqAObMECHV6ErZm7jMGXj9PeQO8G4KybzGdz1fayXQX217DXjPqlrzJOOkDTWnk2Cz8MBG94j2auaSu/AaWHRXSMT7L3fe+J3+TzHmr4RyFdIPWC4GE8Z/o/qcxGEJu1U7Ij44b4UFExupmmequiXicCoQHpETmH4EdAAzuW/MF2+zngesGEt5LhgZgFaQGyFp/1GkL6kL44QbQ4NCvAeQuioij0crxLuUYgHXlBDjGCMJCNayh1qnyAoUg4EvrPkGDQsQ9PThsbA0HMU5PVfX4ha0i/MnIBCtAfRqmSL0GW3M0JspxmlswEhBL6dQwF00PqfShtT5q5JMRwHpsgmiNKCx+MIDuJ93AqncDdmPeQFwm2IVQivz71Goeds2hS84quSxoEtP44PholF1rmr+AgOGRGgZBbrIKj+cyL8eSh+wrbuG707CoaQFJCOwnYwCr6W4QOWEYG82M42r1PQqqfSyB8NQUb4sr/tRHJ33IQPES9YH3sGaATjxXQnLOoGX8VB+XPq4u09FxImJ2F6IMrDq8toQi72TrOJaCScoI0m55KrLXp6e8wzsS8pAw8PLSbGGKse0Dgah8vrCHCNQzQWEgVZ62mZd7dik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea75c6d6-3529-44fe-ea52-08de59b4dfce
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:51.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3a20KMPnsPXK+fBvjsbnL0/TSyXjndK5YRowY6Tz2VGEvPvmf0c00QrqbvRxAZkTJEopulXfBpSOiGBaAAe/x5wnfbNrtRl4Wdm3qj4Nv0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69721d30 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=myXMqSKX-38MvfvLfZoA:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: T6gB_P6g5m_dg6CapX8QC5rc-x_NLeJq
X-Proofpoint-ORIG-GUID: T6gB_P6g5m_dg6CapX8QC5rc-x_NLeJq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX9R+uCZnFOoiL
 /yvB2p6AXHcdfUkTHZsG52Ji3fz4+jOtd74mTaLZezBJSfivRJnMeulJ3TGKEe4isyiLGDTw4MX
 zLXL1heDkcK7RIMkaYvXuB4NLyYg8CZEtJ7B3Fca+/7YxOXO6iRWofYdP+aeasLgfzB9Ax1CCZI
 yFK4I31hxt5H5uePiEeAS8i5xRwtZAt+Z38w88mkilH/NIddPbF5SiIWR55ZsXUyT6WHzTiFpCT
 Jpe4ohgmeByW2monwR1vuPrHr4T9wWVplSc5WLE711hQe2Mc5W5wOxtFuH8tEtJMu0xpHIMWvUp
 qDLds1U47AUDIBLC5ZINseK/8yxtYrKumL7yfLEjQC5MtfBLPjbdxDw/3xv3LNXZYXESnQ7TdOE
 cPqSXXvcC0IsgbdrilSThUvarfVqTBovb22WEJGjr/mrryr6ceJ2DsRowr7wG09Et+jof9pIbDM
 kB1SUZpjt1rocUgcJAyUDmGE67IumNUWBZzCve2A=
X-Stat-Signature: ifmee5by16h8rc7gztoc88zjzb68jx9t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D75A84000C
X-HE-Tag: 1769086276-900737
X-HE-Meta: U2FsdGVkX1+0XrZ0TVtchz6JLn0Ci8DhwH/Q+zAV7xijFzMCSfbMihDs6ddT+3lVXsVNZO9bVz/PbJ3XlKGlb39cvIeA61mmFyg+TSlkyNt40AZ4r9LuxiDfeakl65mJ8Ryr6Tef8CF3QpuUvsWGpwcQLo9e94w0D8ma3diiXrYuy8E+DRc8HDFWaOlwWpGsUZNZbow3WAzphN13/UYa+LD6JyUBOYHxjX5+MXUMGLIHibq908wrHENDhqreyYyrJh7pwlPHLQVSaMoXSxb0u+7ngO2B5rsYkyn6GoVuaNsKBmKYL1/vUy+8VmLjD/TEmcedSv7h/ZoD2r4JSd3aA0LCGzeMhTwjfu5RneT5b58M3wwyNaoiZg02ykWx5WVY2fF2iRM9idKhL3g2m6TBWEoAIEPyq2RHGXtYDHaRmcyBsH0JVGsyNUfhAvhzl29GFOInxOG9IebYWbpKt1DG88f6HhRkmlAB5otx8gSfl0LhTCB0qPBVwTESEFBFVI2Cs+mAEfRjGTVndGju0BXGiwYyRWd0r6Jv6hWeUkfFu0ynhXaBkD6Pcrb12Ypr+loZi68qKB0ZShWuviljYYqdzxg+I1OG2d3HGvhQ8lwI/Pgg0dVgz+6/KgdB0vVPXzKWt07oJvopABbt5JvV/Pj2tj+pcqyWcyu6Rv//wnEL1Kz+aaAweUlDGsINXrfBWHYefi0yQwHarBrLgKNHbuIM5SPYhY72DIfofRCwbCrP/NTvl7KNroI0DeUu79EHjOcTU+kFrTlq0/VP2oOotBYJLlXEu+P/Hzuw4z3rL7NpFh/UQUec82fxtNsFA8+j+zHANfJjbEg8bSbNqEdPjRTFsIzzCoUwx+8qxItKA+UndwXQelOG6croWQxSURcMFIfIhdg/YKsDZ4pjNljFbgptoiXZ4oR1rp5ZdG69aqoZ4ynsNlrszRE1dNibqQrje6BvqdfcVWVnKcEtPiFCjnV
 r/KcZ15f
 dAFIDYMtfSrC+HPZLaGTZP6cGEcTDXTXGICJgH3vPA/KsA6akZAk5d9OZSja8AUoDpxdr8k6VrDDMqGDkECwdedMcGqOQanaMU8Xody+t2U5+Lm5j3PdNqaf6nc5JlIipxc95IOx8xQSLOOBOM8CnoNzjZc0bJxv9zhWy5InT9ksKYAO6PVaP7zLS/FLOT8TbgmhQU8hD7BvoCsqBhQJCTqf86egC2nqSO5IMaXOhqzRcZ2LmSVXKnjJmiW1fAWnJKe4ayuLmY1m4opzgUNodB1Iun4+LyJ0LmvNEWeJHicEGj+IKX1YmtuHrwIKJCAfvZIY7EKxqO3/XkFweiL1YcwT6Erh9tCk2SoHXM5Y0I4CeHLcqBF/mXnysxwYl54bYWOlaYTPbx0X/eaUfNNNjG/1wFQdWtBsHI4blS3iqt/bvOFmHXrmsgtD+TRMUKhsdunDWCrmYQR1j2LWeJCeN+SHIaMXLZxFoN2kApspROwoqnMp/S65Vm0ZqBTCsNPQQoS3Loral6IwOOSNicxkWjFE1dx1u1ujbsyCTwV/1AovpbIp1FM/2/pWrFGUwzEUJwyTsudr9DYRK8S8ZBixjk6IeHJuICiwlEMb44ltLT7qQFx6HSSvhRp8ddzGvfmdAiU92CJcJ1lKEa6BvUADOsO/Mz/W507xoFZTChKMohJ9hExOQ2klSmMf3+cLt8fVhN7eg2UJi6zzMet61NQeMRPJD2gbpg0Fb16dPfg4qvR36zrQDQQlCV+Cok1dC8qQoGb693gT9C2OZNWqqtUX01+gjkk1LLDY0Knf/eHm5VZ3fPSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

In order to do so, we introduce a new assert vma_assert_stablised() - this
will make a lockdep assert if lockdep is enabled AND the VMA is
read-locked.

Currently lockdep tracking for VMA write locks is not implemented, so it
suffices to check in this case that we have either an mmap read or write
semaphore held.

Note that because the VMA lock uses the non-standard vmlock_dep_map naming
convention, we cannot use lockdep_assert_is_write_held() so have to open
code this ourselves via lockdep-asserting that
lock_is_held_type(&vma->vmlock_dep_map, 0).

We have to be careful here - for instance when merging a VMA, we use the
mmap write lock to stabilise the examination of adjacent VMAs which might
be simultaneously VMA read-locked whilst being faulted in.

If we were to assert VMA read lock using lockdep we would encounter an
incorrect lockdep assert.

Also, we have to be careful about asserting mmap locks are held - if we try
to address the above issue by first checking whether mmap lock is held and
if so asserting it via lockdep, we may find that we were raced by another
thread acquiring an mmap read lock simultaneously that either we don't
own (and thus can be released any time - so we are not stable) or was
indeed released since we last checked.

So to deal with these complexities we end up with either a precise (if
lockdep is enabled) or imprecise (if not) approach - in the first instance
we assert the lock is held using lockdep and thus whether we own it.

If we do own it, then the check is complete, otherwise we must check for
the VMA read lock being held (VMA write lock implies mmap write lock so the
mmap lock suffices for this).

If lockdep is not enabled we simply check if the mmap lock is held and risk
a false negative (i.e. not asserting when we should do).

There are a couple places in the kernel where we already do this
stabliisation check - the anon_vma_name() helper in mm/madvise.c and
vma_flag_set_atomic() in include/linux/mm.h, which we update to use
vma_assert_stabilised().

This change abstracts these into vma_assert_stabilised(), uses lockdep if
possible, and avoids a duplicate check of whether the mmap lock is held.

This is also self-documenting and lays the foundations for further VMA
stability checks in the code.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h        |  5 +---
 include/linux/mmap_lock.h | 52 +++++++++++++++++++++++++++++++++++++++
 mm/madvise.c              |  4 +--
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6029a71a6908..d7ca837dd8a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1008,10 +1008,7 @@ static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
 
-	/* mmap read lock/VMA read lock must be held. */
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	if (__vma_flag_atomic_valid(vma, bit))
 		set_bit((__force int)bit, bitmap);
 }
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index f7de79703d84..f002eccc3165 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -372,6 +372,52 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 	vma_assert_write_locked(vma);
 }
 
+/**
+ * vma_assert_stabilised() - assert that this VMA cannot be changed from
+ * underneath us either by having a VMA or mmap lock held.
+ * @vma: The VMA whose stability we wish to assess.
+ *
+ * If lockdep is enabled we can precisely ensure stability via either an mmap
+ * lock owned by us or a specific VMA lock.
+ *
+ * With lockdep disabled we may sometimes race with other threads acquiring the
+ * mmap read lock simultaneous with our VMA read lock.
+ */
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/*
+	 * If another thread owns an mmap lock, it may go away at any time, and
+	 * thus is no guarantee of stability.
+	 *
+	 * If lockdep is enabled we can accurately determine if an mmap lock is
+	 * held and owned by us. Otherwise we must approximate.
+	 *
+	 * It doesn't necessarily mean we are not stabilised however, as we may
+	 * hold a VMA read lock (not a write lock as this would require an owned
+	 * mmap lock).
+	 *
+	 * If (assuming lockdep is not enabled) we were to assert a VMA read
+	 * lock first we may also run into issues, as other threads can hold VMA
+	 * read locks simlutaneous to us.
+	 *
+	 * Therefore if lockdep is not enabled we risk a false negative (i.e. no
+	 * assert fired). If accurate checking is required, enable lockdep.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
+			return;
+	} else {
+		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
+			return;
+	}
+
+	/*
+	 * We're not stabilised by the mmap lock, so assert that we're
+	 * stabilised by a VMA lock.
+	 */
+	vma_assert_locked(vma);
+}
+
 static inline bool vma_is_attached(struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
@@ -453,6 +499,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 	mmap_assert_locked(vma->vm_mm);
 }
 
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/* If no VMA locks, then either mmap lock suffices to stabilise. */
+	mmap_assert_locked(vma->vm_mm);
+}
+
 #endif /* CONFIG_PER_VMA_LOCK */
 
 static inline void mmap_write_lock(struct mm_struct *mm)
diff --git a/mm/madvise.c b/mm/madvise.c
index 4bf4c8c38fd3..1f3040688f04 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kref)
 
 struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	return vma->anon_name;
 }
 
-- 
2.52.0


