Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B6DC2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 08:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C6F6B00EA; Mon,  5 Jan 2026 03:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552FA6B00EB; Mon,  5 Jan 2026 03:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A636B00EC; Mon,  5 Jan 2026 03:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE286B00EA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:03:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE93313D977
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:03:01 +0000 (UTC)
X-FDA: 84297169362.05.E6BE0B4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A590140008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:02:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UHHKY9zA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nNQqB/Hj";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767600178; a=rsa-sha256;
	cv=pass;
	b=OwF9+ZWPFiQhCR1OLQfeIn3UslwgvH4oRrIjQg9UJzmU41TZSKMgE6XWDaKwUpkX2LCUtx
	Ozri8qkixcfRyRmPzkftHVNEq8u1Q1iSBz6+7TDT/znfi1mhL/W0JaYPr2Qd/mUYK0x+yO
	e6VcBm+mj8gxjlFf2mj5Fvrz7l7xrSw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UHHKY9zA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nNQqB/Hj";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767600178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JdbvGjnOT7W+lcdNdBTnuYbs9kmWBY8TiLlCbdc6zMs=;
	b=gtRC5Gt7eYGpIVYO99q8oVeCI9IkLnLWo+AEBcaZj4Z3Y0fB2FqxstVpeFyQsdXUhWO1hF
	dE6cO+NPgeD7ym7JiOBir6lffahrvrtP1cHr8/IrzcI3XkbUgNLDbHH5Xwi6cRUOdwhzE+
	bHo9uKfCjSiTaolIysGjIOM5D9zouCw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604MQRe9554900;
	Mon, 5 Jan 2026 08:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=JdbvGjnOT7W+lcdN
	dBTnuYbs9kmWBY8TiLlCbdc6zMs=; b=UHHKY9zAj/ImbWvKeicdvaSC5xpwTUmJ
	b/7WupxRjLfTBerUZyQQ+rmquz2ZmvGGarRB1ealH+65Ntq9qUBrw4xEoCDdYKEV
	GVxNFASWaNVEHxXFnc4833ACsv7msoLQ57frzSHufKTr71Rr1hv4T5jZyGyfy6r2
	Qp4z1uAXbxLk79lY3UjAnaicO6uMcITXFep4+ADEKVLhW0Y1hNxdsgO7L7szL3NN
	93j+gAEU5+IBQiMHYpEkAYABmYBCbTh3LKRBPJPTSSPcwKRDn39ZsSSjVm+38cQb
	P5FeKMExFtganFkyuyFJFSmg1BnHJYPgCpd2udEBe0adCwEUUD4fHw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev2jhcbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 08:02:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60570IeC030721;
	Mon, 5 Jan 2026 08:02:44 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011059.outbound.protection.outlook.com [52.101.52.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjb42ak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 08:02:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3MZUK2stJetEQqQbZf75aBFzMLPK4BAZwP3B0WhTzUzgWBvfCPSk4higYN9diPfrVPsk98N4QFHh157aOdLNaaKRdtMTBF+Mt8oLX3E97JY0YY4wL3zBBm33ub13oitDHymL6yeuRykjwJRzxRAP7Ju6WyU3MwYgTfxd7zPAZ0FJgqJD3BDvf8QRb6AR0ZVHLfJVqzZew/A34oungqoYXqj0lD9HLI8qfbOQcMspnfwAaz7fZxjWFk9Z9GurKY1VvZOGQSf1ex8C6GxZF63Uo7sn7wx/7e6Y3cOBTLjQRMNoKJ/FgUjDIGmxR0ktTHrUfuNGtzyF/HIYpBy7lYcTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdbvGjnOT7W+lcdNdBTnuYbs9kmWBY8TiLlCbdc6zMs=;
 b=w3CRD5C8Br95rtq/ri7bZv02PWlKRX9G8p5tQvwn6OWleujv8DhXhtbP7+z9sNOR+ixufgcaBjYkTKHl7mW50wM2MWFsAjOmZmly9z+Wlrr1m/FsC2VCy64xOh2FVEDLWfPwslDnVfO68rSmSGoXASPutAYjginhKZmp2xK3wdcKexWF5HXfzQ+FhfQGXNhxkO/Kena5Sj2/KH3iXlO4SUZyEfjka7JcRvVduaq7MMFUqNacS6iOtl7/0XsPV/XKTqYh9E1mPeTP647kLljSMoZtXgoVeVCtJ5CSBQ1E7RHGAhtHfEszt9tf42VRzu7vR3ENuB6rEsaulNh7e3uuRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdbvGjnOT7W+lcdNdBTnuYbs9kmWBY8TiLlCbdc6zMs=;
 b=nNQqB/HjoUnHVjSS9bz1l2kEExc3b/03/aqRewPKaZePd37IoFqOamrtxn9hCXcOs7s3X92GiWgXwLPouBR6yOcAiL1v8naW6768gjTaRWN6jS/GbkPt830Hh5ZaBTj/2+wJE3w1PtUcJyjgBvCBaO7MfIOv8UbBY3fFWw8NQ3g=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7531.namprd10.prod.outlook.com (2603:10b6:610:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 08:02:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 08:02:40 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        hao.li@linux.dev
Subject: [PATCH V5 0/8] mm/slab: reduce slab accounting memory overhead by allocating slabobj_ext metadata within unsed slab space
Date: Mon,  5 Jan 2026 17:02:22 +0900
Message-ID: <20260105080230.13171-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0222.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7531:EE_
X-MS-Office365-Filtering-Correlation-Id: 62a41233-47a4-48fa-10ae-08de4c30cbff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W/S8LvbTJ6scFlsoIxV01eFaNPc07PHuLgDTeOmk6tMYk36pkQrVlZ5AcyjX?=
 =?us-ascii?Q?mU5hfsoTh8OjBtaKfu7ha8fXjtmPKwxLhR/Fke90Adrlj4oNmpeBYJ2px5s6?=
 =?us-ascii?Q?Iw6u3Krz/CnAE7HX1AEibsJH9OjNnK0gtoaiMav1N0Q+xreYmlRl8EI26/3i?=
 =?us-ascii?Q?Bt9NWVImxkE2cnjOR8/5ERJlCbGHbdR2H8RlehwuVYS39D+wbcDhkC+QLGRt?=
 =?us-ascii?Q?R/LTTb6RQwQb/PyILopBypxUcnI5Fny/La1enuhR+/rmgl78wuvSTmnYGvr/?=
 =?us-ascii?Q?MMxzVrX8zWtDDlfaT0EkD8Nb0Spglm4S+k6ken7Uh80ChRTbHAO0eF+kMK60?=
 =?us-ascii?Q?pZdt3p+f9MgvlWYipmIH9RHLTpjSg/KBt9kNTzigkk0R9sxAGifHAkGIB5pW?=
 =?us-ascii?Q?d95R7VJ0VzsIzBA1oFu/mdRgZ3q6U5BR4s4ensaLQbTn6fZaP8WEvFJzcGGc?=
 =?us-ascii?Q?Jr1WFv/ZIaZKiPXR/FZ2qEYdeT6CLTuPyqR8VNzY3u5EQJsdicsFWPgHZflo?=
 =?us-ascii?Q?R8Y9vRaGazdkY72buHOL6FtzFDas4EECdc4RfGQHgvtJt++Dwo1/yy/EAG/O?=
 =?us-ascii?Q?HwUYsGPTVlJ6bZeYeG5WJ54WvMfcDScomXziBE3FxeamDUABad95qn1SkQUS?=
 =?us-ascii?Q?lCPi0J0pRT8Ned8fK8ArppwonDBrym9RrGmSJngC5YEFJhUFVpgNksARdpdd?=
 =?us-ascii?Q?WoBp5ZmhDWniqF4UQIZRqEQq8FZwHXkn7RrbtMs0yv/fXMIOLyoLfB2uyYGF?=
 =?us-ascii?Q?/g5p1UyVlF4kJM7vsfhjf4+mwCosv0ZgUQtC/EA8H6cxvQdf8t9W6l0/Bryx?=
 =?us-ascii?Q?zyU76qDKjpy2DWpu81E1H8zJwTXu3FnoCLbwRtzAuerdWMPmr3jjC3jdIDzu?=
 =?us-ascii?Q?3MO/boCUw9h64PQiWR6ThBhZOFRCte3cBLE3Tqb+jKZBTImOkJNIZqVvYndo?=
 =?us-ascii?Q?nl8KsflHkO+Z70+XDYQiDxsPoMx7OzV/ZU+Een4n4Jz1lwHsFtHxx7XQueKT?=
 =?us-ascii?Q?QdyD2xazGCCIjIZ/2hu7iBVCR+Ch30sIT356FMgYgN9CuMct5WIWrjvb6zPG?=
 =?us-ascii?Q?L+cApZqS69Di2moVl+73KeiC1yokAiaTKORFBjm9Yvrzmq58r05Iz9k9hekL?=
 =?us-ascii?Q?OejiZd/QjSQy/cvITrBNpMi0e6TJKmLChzXN8gB8l9NC8ifiadTkNYclOhp7?=
 =?us-ascii?Q?s6RU3q1qm08nmehmoMiBLoV46iZNR4GqdKDMbhUQwHdfDxC9Q2o9AH8Lv7zP?=
 =?us-ascii?Q?JaUltj00ImIND9f6InjQmzuv4uS5obHrFjVrb8a86Gol/fAJqbw9WyI0WO9z?=
 =?us-ascii?Q?+C8ya7CFSEZic2URfIBeY3zqwScxvscU2/R+DaP2iogW3GbxZLBK8ePPvhI3?=
 =?us-ascii?Q?RwZKRH4PYcBgcKsRzN0kbQ6umxxdETEJHj/CD9Gq7Ze5hps6UcNnhPFB11qv?=
 =?us-ascii?Q?Bh+66TZaCtisMy6A2dKTIn3dPuqs0mdvZWjagcvZEKqxg3bPbZclzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6ucVIc4huAuoe48CpfjAW50c2sYe4Ag9f2XXBcNUoBVK/DkROsEZy48fTi9s?=
 =?us-ascii?Q?WioP2iw+ja/N+scyMgMYqhiPatktJhvFobRwRKqsPDJVwLlpJ1Hp9LStd4LZ?=
 =?us-ascii?Q?+WARv/ykBV6JuRR/DZvZX1UTrR0eG5/dB2+2D5xBXev8Mq7A15EAme8EN4i/?=
 =?us-ascii?Q?c/vz5UU4cvnHpJDvkBFQq3R7FCI3SUDjW6Nmv6pznAQTFIKqL0Jc0Xh633Av?=
 =?us-ascii?Q?svDCoX280N7T/3UHG7XKQ7H9VjeJy4vFhn5kSwpr3ZkogcmV8CibNTVAYuEv?=
 =?us-ascii?Q?a6ECLO0GXwgGx0Zsq3cI093iqBC8L7nMT20RYC+tB6E3sCJEDN+EScMl+4yg?=
 =?us-ascii?Q?Kmf/JS84PldE/EOBBhoCxFEDatkXPSpfnCHbKbx6FKEmNaVpADP1B6aTF+06?=
 =?us-ascii?Q?H/AHzjg69S4UU9HCQdJl5E5ZpUtvj0D7C9OQXGD1sY5rgTIJcLZh64vSZ+rb?=
 =?us-ascii?Q?1tOV7gYqt6fhWxy3wRrRaMls5XpfdfQKm674IdkG4yH+FYr1o1D58SF9nf3R?=
 =?us-ascii?Q?643bnH7CYzmROoWOBghbaGyahlaHqbfAiPmhMapB/TlmWazXPe0cSppX82Wh?=
 =?us-ascii?Q?aOshSkU3FiNr3GOJfbaWOLdaG6mI9ge+uSXvtld1XYlRu2bWAe4EOm+U3qhw?=
 =?us-ascii?Q?jlRi8TlJtCvUzRVufSz5D6ehJrAUAJcAMsFRdYSA7uFkqee5+NriNbXbQGNN?=
 =?us-ascii?Q?ul7BX60dWKkqlE/qTYvaB5tnWu/3R8AbPNmFpgtXP56rs42xUzO4lCauCKyx?=
 =?us-ascii?Q?ElnLUeBZRqqyNQdoFvohyWcLIRjzubO5fbQWJu43vaDUPS6MWqctDtMUGzAN?=
 =?us-ascii?Q?bjddiOGLi5B7Vy3qMVVfU4EpcPZ8AyVLakrRRegtIPt8zqVwaLL8jUDYsBhF?=
 =?us-ascii?Q?ngvOnh6fdwKZ2bRAoWl0lVHC5eOQlhy0Y/rvaJ9jgqRav3Y8I0hgBu1bmHVY?=
 =?us-ascii?Q?yBy0U+GuuVs5oLOYkkyRfIOlz0KN3dOmf2HKZcjHp2bVIVPESTgiYWuc99Ni?=
 =?us-ascii?Q?mk00nVnHKn3wDqlRTPRHwAasfnhaCfSNNyPngnOeHZghv9raglF9PVHlEbWz?=
 =?us-ascii?Q?hv796RAzr8/Mivj8B8cbijKEQdA4tLQKWaEYXNu0P6VS7oDu5OzO/4ddxcJe?=
 =?us-ascii?Q?M1ZRVl0oMbiMW4qCaRJhOf9PoO/1HCh7m2b5S8U5Df9KkCIhl5fenzhT7Zc6?=
 =?us-ascii?Q?EyeFRlfwSJpCR7ELNfoWDmEZuYW1rP2qI49L1eaICadO1q6gp58/eqPlsIro?=
 =?us-ascii?Q?rfJELSbR+YbYJ1vLje9PDUV+BcG4qBQydGU4xxqsJReYDbQAwk0EMT7byfP1?=
 =?us-ascii?Q?YcsXGIxeIuCOrp9oLzebQgJqEyQWXCxORj60yqclkUxLjemySfan2hlgX9Rb?=
 =?us-ascii?Q?sLXLk2falxi4Q0cmf6pmT04xLmPy3a41ze4H48khqUSgxVdy00B1zQEdVl7r?=
 =?us-ascii?Q?A3kjsRtDnB9QzGsv5SFLvdo78AVX9KuyMoalaW7Q+G9h8Drkl2OnBRBQ4QiS?=
 =?us-ascii?Q?XHdi/cvA+8FU/PB54PqXqNA8UqB5z13mxeM5PgwCkbjw7dsQj/qCxpGHFoFh?=
 =?us-ascii?Q?zrz31rB7N7I4U5rtv67mxLdgOxOqqAsL7Zb+AVoTnFtI+371TaLBnmx914L7?=
 =?us-ascii?Q?wjYYwdUh+N7OvZSZqu56zIeqn/naHg9dZS7OrsyX3e0Z173XI4/3VCcAEwgT?=
 =?us-ascii?Q?F4iBQZRxrs8EvBJl02WnbcKh3YgjtAwcIXx5oP2wKIZLbP36VlCW5P/OKuQL?=
 =?us-ascii?Q?ygmTkB0l1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XlT3UfyGEW23vlErSTwQwQAekt+zZZpdh1mAqJHpyOhG9AhYub/O8DV0lXPKoLmIZe4A7QyEBIRfBkND/X5RUTV/O5gMxeQ6ZYA+z4Mr4ybSkLyI02x1savsQoiBKxVDKFMrFpdXhISBzvbEEu+18g8VYzZqhSZfD+sKpIw0bH77jEAtUIM2vZUU4ZecccQ9T0Vgkrc6lCj6yvnjL0FFRvQTpQDVe6SoM4YT9ZqN7PVCMos/+UvrcXWM5z8TTX+v3OUq5qMC3MYg77+b/k8F+exEbJT5kW+OFzHV32XUcI91JRrzc0xBJ4dQCfRDJ8cYoHdU1f3qSBWLLqqPgCDq/CjyOoO7Cte/nsJtfHeSNJmLyc1cOL2H4CZApLdHMsim80QprP+tfPye7t9uxxzrojAnA++FI99VMLoacIm4BYzXADziUfHcRObsdaAMXLcoub9dDNzZhEnoz3GjUS4VUZmtTqCuj7AAoz9IHuim3ow1A6N3Vbl6nwLgl7NydwGbS9sO4HE333mCINY1NUJX3CMQlVxlP58Fv4QGtFnwBCWYtOd0ZoBvT7xc7Geovnihltk5FC1HHMuyqqkDYY5xn157b80q7ovE3NCrhGbc5uA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a41233-47a4-48fa-10ae-08de4c30cbff
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 08:02:40.1634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: la8bk1YpxdYZxMB/UO1xVu2i8d8WjwhG/yCWE9AVw/XvnZew6YaxHve18LK6Dl9qjEem73Gu7ExAs0Znfe13JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050071
X-Proofpoint-ORIG-GUID: BvqC6U-xEjeVNyiwSfd3anMyFCVdX-a-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA3MSBTYWx0ZWRfX4249GatGrdl5
 visZssaQ/zxCSal7A3oP+YD0CdX3H/PSI94RuO6nER/1TCPeEbYRqHJzwSCHN26A6YPHX/pausF
 h2XG30P0qwtG9Wn3xaNgMxmlq6HK7ogIjrU7RrgC9Vrrb0V18Wy2O1a5HiDdqv1JGqmKshoTu6w
 swNDiW+UohzdQ5N2S0d8rKqlmUi/mZCAYIXhrtPYDLCOkJKi975103mN8Z9UBMvl9ol7LKmjOIK
 ieRWTXAthhRzo+387xw9qoP/yV+KidnOl8U2f/EnGedzFyxBkfg939FX2qCiQn944HXp7zJIMZ3
 ZCGQPl7GIsG7CJUSzIcVN3tOMClYHyKjFEfA/H1/aZwmAb0SUAzQR/Gr7L0SgL/pziBp/dhxWE4
 n8/79PkbCZ/umszRGaH41GsK0KkvX8Xc7M0t+I7nbIDuTJCI69rgbLFY1ziz8syQfuLQlcfld1+
 4hbGlraO+yA9xYb7/slw0AY5cSkWiRst7dZliBbk=
X-Authority-Analysis: v=2.4 cv=A9hh/qWG c=1 sm=1 tr=0 ts=695b7025 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=z-fRuOrmXyTkV2CazT4A:9 cc=ntf awl=host:13654
X-Proofpoint-GUID: BvqC6U-xEjeVNyiwSfd3anMyFCVdX-a-
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A590140008
X-Stat-Signature: s34hyckomo3jpye8r4wtpojqk8crkrhr
X-HE-Tag: 1767600178-368883
X-HE-Meta: U2FsdGVkX18iNjVrOttreKzxuD6FzZus6mEdda/tcRim44a7kN4/3J+h/xvEoVu6kaCjeafzBLlrVyK+hiGoDIPK3Gwk892q6JG/6AavRfLkVhx2F9rwfl51oZBRydfacnDF5F+04Ngi25aHeF/rlSFyadPXUFR2lmPKFF8NG2RSqrstP4ybd8Iuj6EAymB1GX8KiznEzcdNSWnTGNEiR1h2Y1gM/BKuuiZK6ysIp6xeDZB9OzwOuLm5JQhS0vhq5eYgwkUQFcuARk0rqdWMy7jmYkszAqlrvU4SlicZ7FZ2nvWyjClQVZkvfPh5gYG6lggS5KporSRomwJKlXlSJqwwHY/bOxEg73N6MSfwcmthBDIyHy/sWV9HU7DlI6hpiL0C74AAsoTk3Ha5bNa8JdxcxwRcvXTktrEGT+Fv5HegBDyVmlufgQapwQY+YoZ+Cr6B/L8zzUowPPiCGREY9y8YDQtb/ArpqTsyriuE3OAJwzDHbqmXX3VgO6BAzeWNJoo3rpKWbT98GS1rnh3qbzACe0zheE3HSzGx3kfDP8WtDF8Khl/KtUvpHLA2z2q/sap5nD/9kefFqh4DhOcaCClKB+GrMxLjPOCF3d/z4XsTPhp18WOzJyxq165ZJ82ZnDUQiqxeLmbiTVbUj4PNrjanYa0ftr9Zk2PXZUH451RCG6WX0zjREzlHHZAa7i6289CpjnIcSgdCMnpfQEa7/nlocVpqc7g9M2Z6yn23Yv3ys5NxOxw8shtYj/BMofkzasogrBa8eVpy5TNs1QdxT6O/myTMGWVqw/tIWBKoqZGa3YZuS4UonaQh5JSQbpcjKBiBIE4ER26c+N1mrDGY+/0Q6ZOuik8aHiGUosYpAw7K4gW5I3F5z/sas3ELGfdTjiSYGENSlE192/VQdBbD4Yz01YUr3xXa3H2mEL1nvnWwr/PSyExJTJ+Pgskwprx2V8wQ1k1g7jJgRBV8phG
 5yynxSka
 R+1yFF7KFAj4aNg/zGOlaHZH0kcDe0MHc7wm3IX+lr6XcUSlMkVd76sJs7kjXW+yhwSItuxiAU0CEEA199RQIBPiJRIH7eeVFvjDY2G7FEsSLwZXDG73pAdJnBR5oEGXAZOSxSQf+cehsU2/kRUxPWFQwTLlegC7KwNYyCdqrdTMFf89KQwDsL09Ndz+HleLDuwqb5qDVb26xrP3jdTTGVxVgqRQvOdIcEoXsTWaBgVzcX8WT9odKVmnTibS7gN1SQ7X0OodZ5IMs0Lx6InwiKyosLisgz5ZZ1sBzmxxTw26bGCoF/iv87bXg8BM6IQXaQCqmbiOmBNeYi9RtWWuV868wX5I9Wry/muIkhK8ZkFcVpgEUAah8VTHDx5TDBU1sQco53LZYpayMSwqhiOJzJbrsfc1wukGG+ZTJXV8k+Kp6wqy0Wrsa97X7S/xrtbB8NJNjDlMDqSfXFYGpTZ+zZjdXKZc6APnPVFRiGUYxnkTHdNmKkupNb2zNHGnQXXTosecezvjNb/M9yyMN85O72Yzr8fobi+pouT0ZW1vBGLsQpWYwM3omzDkFXPwvBUAmWv/ueek1lMMU1V0IfLA33WXWml9itSpaOJwK0qfSbzJrU/t1KPQNuiQc0bxF9lX1LlNgb9WkUxH+joIC9x4geUz49QpBsMJQqCfpikHFdWFgUf7YCVW0lh7VFxydUN5OiLPmZ9DO/zA+9SjALx+UwdItrHg6kSfwowHZeAbPepZqV5d8bLML13kppjwOWi+c//mwYMPbfyR+wCEty18fFK6rmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Happy new year!

V4: https://lore.kernel.org/linux-mm/20251027122847.320924-1-harry.yoo@oracle.com
V4 -> V5:
- Patch 4: Fixed returning false when the return type is unsigned long
- Patch 7: Fixed incorrect calculation of slabobj_ext offset (Thanks Hao!)

When CONFIG_MEMCG and CONFIG_MEM_ALLOC_PROFILING are enabled,
the kernel allocates two pointers per object: one for the memory cgroup
(actually, obj_cgroup) to which it belongs, and another for the code
location that requested the allocation.

In two special cases, this overhead can be eliminated by allocating
slabobj_ext metadata from unused space within a slab:

  Case 1. The "leftover" space after the last slab object is larger than
          the size of an array of slabobj_ext.

  Case 2. The per-object alignment padding is larger than
          sizeof(struct slabobj_ext).

For these two cases, one or two pointers can be saved per slab object.
Examples: ext4 inode cache (case 1) and xfs inode cache (case 2).
That's approximately 0.7-0.8% (memcg) or 1.5-1.6% (memcg + mem profiling)
of the total inode cache size.

Implementing case 2 is not straightforward, because the existing code
assumes that slab->obj_exts is an array of slabobj_ext, while case 2
breaks the assumption.

As suggested by Vlastimil, abstract access to individual slabobj_ext
metadata via a new helper named slab_obj_ext():

static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
                                               unsigned long obj_exts,
                                               unsigned int index)
{
        return (struct slabobj_ext *)(obj_exts + slab_get_stride(slab) * index);
} 

In the normal case (including case 1), slab->obj_exts points to an array
of slabobj_ext, and the stride is sizeof(struct slabobj_ext).

In case 2, the stride is s->size and
slab->obj_exts = slab_address(slab) + s->red_left_pad + (offset of slabobj_ext)

With this approach, the memcg charging fastpath doesn't need to care the
storage method of slabobj_ext.

Harry Yoo (8):
  mm/slab: use unsigned long for orig_size to ensure proper metadata
    align
  mm/slab: allow specifying free pointer offset when using constructor
  ext4: specify the free pointer offset for ext4_inode_cache
  mm/slab: abstract slabobj_ext access via new slab_obj_ext() helper
  mm/slab: use stride to access slabobj_ext
  mm/memcontrol,alloc_tag: handle slabobj_ext access under KASAN poison
  mm/slab: save memory by allocating slabobj_ext array from leftover
  mm/slab: place slabobj_ext metadata in unused space within s->size

 fs/ext4/super.c      |  20 ++-
 include/linux/slab.h |  39 +++--
 mm/memcontrol.c      |  31 +++-
 mm/slab.h            | 120 ++++++++++++++-
 mm/slab_common.c     |   8 +-
 mm/slub.c            | 345 +++++++++++++++++++++++++++++++++++--------
 6 files changed, 466 insertions(+), 97 deletions(-)

-- 
2.43.0


