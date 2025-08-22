Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89963CA0FE1
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 10:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90B58E00A1; Fri, 22 Aug 2025 06:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41128E009D; Fri, 22 Aug 2025 06:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1A18E00A1; Fri, 22 Aug 2025 06:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 858E08E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:41:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D1C1BB08C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:41:33 +0000 (UTC)
X-FDA: 83804052066.10.59DCDA5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id A18DB1A0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:41:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jJtQIRkE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GMjzcVUd;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755859289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xqG6R7hE8DIoGQZjWN20nF4tywXthNSHLRxJy+p9tQ=;
	b=oCOuVRWAoVU8lQ5kt3eFQRqqmCsvyOc2IepVr9QFr0XteEjBN90Z5xiXskFrJKtq0S4aC+
	hfoWFmeigoNtv7+59UhQ8NH14H+tqYBd9LUXkq3tnd/ulh1wWo0RWxV3igeYMBuhR4lWl8
	2WBfn+eQ0QREF0YiNKQH18Kko6/ZVvM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755859289; a=rsa-sha256;
	cv=pass;
	b=FhunXEO+MOTkJo7Pr7U8w1heT/0duMqlQx2MPu9Y0V3IScK4YHWYUOcjeAz8lji1cG1UGW
	uFJ6oWQ07RB1tipfBsM44sSJoR3H3aWxgsEG6G3mTSdVZBXBmQVg1yECb9VWJf2N+kZtfo
	jGlW9ImKqsX8pIBR2y+3mRDJl8h4Mf4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jJtQIRkE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GMjzcVUd;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MAfQjT020321;
	Fri, 22 Aug 2025 10:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+xqG6R7hE8DIoGQZjWN20nF4tywXthNSHLRxJy+p9tQ=; b=
	jJtQIRkEjmYotUGUXwtQ59Vokd8kE1eBP1RNlLLWhJ8UrdAk4nehim3AjU13QWBG
	XOewXCAuNP7Ndu8W8iZJy1fqS0vfk5c5Ia3SbDN4Yi+ezH5YYQX0Pgm7Vav7DSne
	ggaHzW659tik2Eybswvzzyz0N945dv/STdzQpZQ4udwlKImNkadKjX8tP12aO8qb
	Ocak8aIGJmhBxCKXHRk7yzHHo10qZh2L0kicLDt+de23bRLUkhdZF/uIWx17TL/f
	hGXWnzpayqswfzf2SuEtPR0isVReD/bYdSolG9Mtfs3Gnwwf4QG69/pgEwdfr4j6
	rBcYuBr+UHNaKPV6miPciw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr57j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:41:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57MADslJ026351;
	Fri, 22 Aug 2025 10:36:41 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3syp1j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:36:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R6491aRjfNvhlSKdYoISkOPt7KS3RW1U2dgdEVhql6BTibE0xxBjHwYUgbXZ1cEnF2gRmpjlbopB7S1PrxfVoYGtWxl5NMpwY3nZ/H5cZ0ynu1z0x4kNs0RABwMRyoPjxOzLYJRPeh4FbzD4DOVbHTKK5Gcw0A5OEtbauY5XkBbSkYB9P+9OreqH+X6j/fgTbhm7gg+YjaVnLNdlDcbWQ8kcGnD+3blxV2wKN+5mVHgLdjN2ud5M2iVYRNYKnTKW3cR25xhtVHuqKIEYiyIKtMhwt3mpsgU4mJOa4N3cMJ6ALi2QBeh8D33So/j6FHj6uCrfGU+UsiKDDnk/jwfbDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xqG6R7hE8DIoGQZjWN20nF4tywXthNSHLRxJy+p9tQ=;
 b=yAN8xUJUI4qQU99RBQ1zcGMyf5/7iEMQs+6ElpiFc4EEEIAE0E3l4USy36XehQlW6whc8FMsl25+L9OaafFBEZuvF0jriL81CDdf9j+AC6wTaprHmetJM46celPKt+0ed5FIosTTd359Lf6vo7mw8srB+ClkFQlwQx9dB/J2rwx4xccVctULrBFcbL4nDchn9W9AniEPu1K65IJ3YfQwlo5BvTphmtPl0DzvYV3/XBj+tUqFlogDULSsT4TrX2oezjEiAD1nE3EsW9+ODjWOty18o4MF+gvHM0lZpilaoi9ihosbNrTSDbdFw1Y9Wnxu+a9OL4vZAtAuGwZTDiMIqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xqG6R7hE8DIoGQZjWN20nF4tywXthNSHLRxJy+p9tQ=;
 b=GMjzcVUdaxThwqMPNpNBEXdawEGSaDg9yDZv36wUidWD8qlSzZZgHeWaTJovl8VrvqOGZITSU83vw2omr/oLZG5dubLp9e4AGryw5fjAR41JskzRnENixZ/RZ5F+fCZ2q6KrWIHRoztqK6mpbQcKdbD6yutM0rfxJlz2pSV/e1c=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN7PR10MB6450.namprd10.prod.outlook.com (2603:10b6:806:2a1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Fri, 22 Aug
 2025 10:36:39 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 10:36:38 +0000
Date: Fri, 22 Aug 2025 19:36:31 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC] Unconditionally lock folios when calling rmap_walk()
Message-ID: <aKhIL3OguViS9myH@hyeyoo>
References: <CA+EESO6dR5=4zaecmYqQqOX4702wwGSTX=4+Ani_Q9+o+WUnQA@mail.gmail.com>
 <CA+EESO6iqowMAOnBPJjERqZym_qvd6kx8BDMQG8+3xQSrNFytw@mail.gmail.com>
 <CAGsJ_4xccre0rz5zgRTA=NbFzF4FLS-ZUohgLFnfTGY9Jdequg@mail.gmail.com>
 <3133F0B4-4684-4EC7-81FC-BC12A430E4C2@nvidia.com>
 <CA+EESO7_-64GU5v1FTMXbemQixPX+xo6SGm8r0txohZJLs97cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO7_-64GU5v1FTMXbemQixPX+xo6SGm8r0txohZJLs97cA@mail.gmail.com>
X-ClientProxiedBy: SL2PR03CA0014.apcprd03.prod.outlook.com
 (2603:1096:100:55::26) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN7PR10MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: bf996795-e3c5-4448-a19e-08dde167c694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVovdjJFMy9DNG90VURpeXIyY2kwV3hQeWFTS3dsNEJsSjJURlh1TCtxME51?=
 =?utf-8?B?RURKeUE1YmFEMlVaRDVMUkFZWFBmYUhqNE92Vm9lalZJSStBeTBnd0VDY2dK?=
 =?utf-8?B?Rm5lSnk1UzY3ZkQ5c2NNdUJWak1ja28rV1ZBeG5uL0MwRHoxZnlpcDJKMGw4?=
 =?utf-8?B?RndDNUN2S0Z6Nkw1akIra1k5VmlTUEFSc2NHOEJITldOcThtZ2N2VndLNWhO?=
 =?utf-8?B?Y0FEM3ZQWnZZRHRMbTQzTGsrVUxYRU9wMVpsdmJDT3d3VG1LS2JJWWIyWFVC?=
 =?utf-8?B?aGZveExmMjE4VG5iR0pDK002bDlHdlRtM2tTUHczUFdhQzI0RHJkUFI3dmdK?=
 =?utf-8?B?eVNObjl4T1R4TS8zdkk1TG9mVUNPUEZiSWpQM0JjRGtDZkdQTGJJWWtVaXBO?=
 =?utf-8?B?WDNNWUJ3TitsTVVPU3ZmN1JMaFZMR0xFeEMrZ3ZLUGd0aU9jTUgwVktvM3Zq?=
 =?utf-8?B?V0NNOUllYzBUSXg3dzVhRnFOYkpGOVFzTHMwaUtkdlhhSkhJQ1dYSkJSb056?=
 =?utf-8?B?b2JiNkllZ2hKYWg4dXVhV0g1bW82REtGQlFFMkxhSjBzT25ZUmliTk4zSFZQ?=
 =?utf-8?B?T1NrZzFKOWtCMW9pbS9TVEh3TEJxK3k5aEp1S09BQnRJNFZqWUtwaWlSTnJP?=
 =?utf-8?B?TW5JRU5WVnBFNTBpVWJxREsrbi9sZTlVWDIraFBGK2JGOHc0M2JVaVFHQ2VR?=
 =?utf-8?B?QkY1cWpTeDZnWFBBdkZYRmZyUThFVDRwdzluV0xWZnMxaGpSMkh5cU1iNWsz?=
 =?utf-8?B?Y2pESS9jZ3B2ZEMwL1dRVERYa2dtM3RQTU5JblZ5ZG1VVzB2b3RvbUdESnZQ?=
 =?utf-8?B?NHNIcTJpamtvREZ2SzVWTzJIQmo2dWg5UURyQ28ycDJQQ0c0cnBYdlNRZXdk?=
 =?utf-8?B?WFFya2JMaS9OR1QzZGhrVVNnVis1S0MvSS9QeXBZRnlSVU1GNG1kUmR6Vjly?=
 =?utf-8?B?RHhiWTE1U3NyTE94cFNxMldaaWxwZXRMcEZNa3g0VDl6YjdPU3VKNmFkOElO?=
 =?utf-8?B?NVA4c3BqVlpsSTFWS3dCZE5FS3FFc3hLeW5SVG9JdlpUeTVBaGxWeW9hK0RT?=
 =?utf-8?B?SFpiaVRRRDNsVXlmMXc0Njc0TmtzN3ZFNUJuWThSb3RLMktGakx1a0h0Ri9J?=
 =?utf-8?B?VzhXRjV2V3NHNExnSW1Sc2s5RmNITW5jMG11NSt1WVoyYk1YQlprM3JiSkVi?=
 =?utf-8?B?RDJOaHg3UUVJRjJHSGNacTBxOVE2clJ3bFRTbnlweEIxc05vblRwR2NHRUdx?=
 =?utf-8?B?SjZxd2pORm9PWElTdTJ6aWNFQzVqemtzNDZsaXd4UmdJUUdpOEJ4WDMxT25n?=
 =?utf-8?B?eUFTL0ZvbGdod2dBUmlpak16SnB4RkIvMzJyOVRJL1l2OU80RUtHNUlrNDAy?=
 =?utf-8?B?T2ZkbFphdUU1bHgwc0cvVmJFSVBuMG50bmxlbnh4T1R1TUdOeVg1Z1ZudDZ3?=
 =?utf-8?B?cm9ObFZxYk1Md2JrRklSK0dCbFR1M2pIdWdLUU93RTk3L295OWFkM0pYRkNq?=
 =?utf-8?B?MzJEaEdzeVZETnpoTW00SFJuQm55NDRWVzBYd0NIUDh3SjZBMytMM2RmY2Qz?=
 =?utf-8?B?QnlFUlZSY1laVGduYllmVmUwNHpoUWNIalRFMlhmNEw0R0toaXJhb0lhTklP?=
 =?utf-8?B?YnB2L1V2YWNscXAwZ3RxQWhxQmF4bU51VWJ3NVpSSzVIRUxqakJxdi9UWGtt?=
 =?utf-8?B?YVZ6MWhCZFE5L1VUUU44SmdoSWpEZTM5bWQwTG1BaFNQWklFeHRVTXZXdGxM?=
 =?utf-8?B?M1A1NXNpMHQzOW9pUjZpRTNSbE9UM2NONWoyZDdDbVRJREUrQW1PMHNpWVBG?=
 =?utf-8?B?cmNEaDdRNGJJUkVpc0VBRDFrc2k4dWtaN0k0TkxDVUNkWWN2Sks4UDZqVzlw?=
 =?utf-8?B?QWpiT0NEYVFtTkRzUXpWY1QyUFZnOFRmaGgyUUg1R1cyUnRTaDlrM3YrK3Zm?=
 =?utf-8?Q?7PUo8b3cge4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnRUVUdCMWN1UTMvMW01NDhFQkdvTFBFdlJuUkpxYnlqRWJ0ZXE1bWhka0VY?=
 =?utf-8?B?TTNUSEhGVHhmQmZwNlpzMituanlSemxUb2p6WUt3d1JQSWl2b2lHVXh6RGpT?=
 =?utf-8?B?VzBkajQvSXNyc2s4S1JHNUhoVXNZMXJ6UmFMM0tFRFEzaG1FMzh5aFdDWXpT?=
 =?utf-8?B?R2FNQ2ZPdXFITTRlQVU5aWdqelNjTmRuZCs4RHlxRkJudTRtTGxYWXgrQlVC?=
 =?utf-8?B?bGJ4QTF5N2xpU1dJeEVUVEowbFZ5ZWFPWnNWODJ4REh3T3g3aWVjZ1U0dm15?=
 =?utf-8?B?UmdpWVJQUmhGMHVwNW5kV0MwbkpOQkZpbHlDWmJybEpOUVdzeFJRVWNVNzZ3?=
 =?utf-8?B?YTlJMkFUS2xkRHFSTkJVTUd3eXVObStzaWhOQnNKbWNyZTdLZTBWQ3N2Nzlv?=
 =?utf-8?B?ZUNka1c1a3VmdmpMSWVHekRKVGxaUG5kQmRvczBGUDRvSEduL3NGMklvUEdV?=
 =?utf-8?B?dkxkQjhDWG4wNmNheXZvN0xFaEJNK1cvby9vN1JULytEMmF6OHJTTGlxdXVP?=
 =?utf-8?B?QTljUmJKaFJSOC9UeDd4TW9EZzZUdVB4NU9weDF5VnJ5ci8yMHNkVzhaS0t5?=
 =?utf-8?B?b1JNYjEzaFBrTWw1ZjlSanQrTUFzY3BpZm1LSzdNRis3ZDFBOTFISXF2UVVW?=
 =?utf-8?B?TE5TSTJyZTMya2YyWlByNU1IWS9DeDFGNVhaUmtSWXl3MHlQeGtITEtnUUw2?=
 =?utf-8?B?YTVROE1GYms3NHdzQ3pYVDM3Sy9uU1lUTVNHT3c5UEV6VE9rWEU4Q2NzL3RI?=
 =?utf-8?B?cTh3dlRnTjA2a1Mxa3hxaXphbjl2d09yU1R1cldEREZ3R2UzMVorRFN6TGts?=
 =?utf-8?B?MmlXNHB6alFXODMrNldzY0hYQkxFSEIwM0F5VkEyZnRaM3p2UFdTYUJmZ2hH?=
 =?utf-8?B?UVpCU2RhemZNQ1J6a2NXamhTSGdjY2RaSzhoZjdMUFZaRnVubW9DbWQ2NzIr?=
 =?utf-8?B?L0pUTnh2c0o3R01MMnI3MWxqY2V0ZnlDSzdsMXY3WGhoSTIzM3ArVWkzcGJk?=
 =?utf-8?B?MnE1ZFMrclEzZTczQkRCRmNXVXRKazU1QWVKNFRKb3NGUXA1UFpiRk9xUzNX?=
 =?utf-8?B?QXh1SEsvTW4ySEtlQjJ4cElUbTY5VktzNzNpQzJMUHRjek5VZE5DSnZORi8v?=
 =?utf-8?B?TEJMMXpjY1U4aDI5ZXlER293SVF6amxSQlA3bEJpcGVpWmFhQ0M5WnRud0R3?=
 =?utf-8?B?bkhNU1YxNU9RZVBKNXlTQVJSNDBMT0tjeCtMc0JwMHVIZ1cyYUw4eG0zc2Vr?=
 =?utf-8?B?Z1BZY0R2UkRyYTNHc0FBYWYxcnlicHlIVVNzdUxaNzAzb1p2SEJzUzU1YTBt?=
 =?utf-8?B?NWNMNmt5Y3VnaWJsdUlYNy9pd09qZ0RJbGR3eWtyVHZ0RnMwNmhBR3hQQVov?=
 =?utf-8?B?RnU1Vy9QV1o1MzA2cklFOW9NQ1VZYysvR1JqWGREQThnVHpGZmNaL3d4dmF0?=
 =?utf-8?B?VTVFZXF3RC82Wmcrbm8rc1FkbnlYTlBPTU9xNHJ3TDl6YjU4RGxCU0Z3SGRJ?=
 =?utf-8?B?NlloL0tuWjZtdHJkNGF2aW5yTm83OWdVclhxeWdWSFNxalhSVmFJMmN3Uk9R?=
 =?utf-8?B?WENoTDRGaGJXOEJ2Z3Rna3NZUWk3aUQ5cVNGN2N2VWpBdEZaMDdPeXVBejEy?=
 =?utf-8?B?b3BBWjlSanZLc2RHMm10ZWlRNncrd1FZaVpDaXRpQTQ0cXB4clZ0ZUtZWnhj?=
 =?utf-8?B?WmovNlVVQjk2UEFWaFJXbzlIdmlKZ1NydXlOTzV5QWwrdWJLc1cydjlGSDhD?=
 =?utf-8?B?NFdaNDY3dHFZSWpOcHlzbEZvK3NMZ0kvT2Y5UnV2a0JUVXJNRGZ3TEN0NU1D?=
 =?utf-8?B?MVo1ZHVDQ0RZdS9kUUc5ZlRGdFgzZitudjg2SmFjWWdNVW43VXp3bGhQVVlm?=
 =?utf-8?B?YnByOTRQdUNxTzQ2VFMxSG1lWWZQaFVOYWIwMzlmcVB5SkZBa2FnY0Q2R281?=
 =?utf-8?B?R0tSeGF0V0FEZldLMjlIazVhd2hoUkhraS9XVEpBY0ZmSWVSR3ZqcTUwUDBo?=
 =?utf-8?B?SHU0S29XeS94Vkw3bVR5aS96a2l4aWQxYUc0V1RGMHZlSVk4OXE4RHJKd1pW?=
 =?utf-8?B?Z2JiNTZCSU1FajgzaDZsNTd3Rzl0S1lWamFnVy9sODdkNWxTbUd5SDJEeVdV?=
 =?utf-8?Q?xECAlyTMIHnEXpj9693RV9tXX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pYZRM/XpNu1M3jdKsPEBH2VK4+mPmgWvI/ec6c/XgKTglrjEYp2Rtj9O5mN4g/Hw/BQorZj6lL4iI7zkGUDix+jQXlY3rrHxc45s/uQvMZvj0CLIeZqURYkX+QZoQvM/O/bii69+/5q0Xnsbz+hFSO/ivQo6hRNGtK5mYRyQ57Wrv+3PCbiZ1o6xqLce/2Mh8bfy9RpmHDBeD44V0WKI8tqfmqusdyIRyb9lBg4N18XAJTJ4mRa0X2md1wV5dt0ql19aXl4PM1PTziDiA0NBL98FkvPY8tMyD3qT7Rpm5KPm4qVAKOu+V63KRYidaoqMFsSo+ESQjf1MWHJX0RB9WMNaCmdY7F2u9ulPD0SQtL+zvjAyn9EHDVK4J5jMmm4FfpyOPr0gGwGUgP7DKgr0rWVmu7LGpVxgWElyHyva1HyoJVcyMlMzU+kNKWyVGgNB3ey7jUjTx6zmA7yDVfQLve8DhWry2dtN4N2yI0SRtzGluf5McRcvJ/6EBsHfY/yIJEqStqlUkrGiK4XrPHUSycBiHVxlLrRnDWGoXknM5vWcBkWmz9VQ+Vf5sUCNL9J3PZLkh/1l+kKDGP765j6AjX2sdn1r/+wS1f/CQNqULGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf996795-e3c5-4448-a19e-08dde167c694
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 10:36:38.8038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53xkz5Tu1p2ayc2atnETWGh3aEuAIp98UzCDqrnQi0vTvMF3owEZfDCLECn/TCPczNN/mHWjU+PmwZ0jTUe0CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508220099
X-Proofpoint-GUID: _ThZNQCjbm2xXi5M3DuZfD8ikeh7fRaY
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a84956 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=1XWaLZrsAAAA:8
 a=jHcd_Q1HIzopU70C1AgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: _ThZNQCjbm2xXi5M3DuZfD8ikeh7fRaY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXwroKkBC2dIaO
 pgsupIyvEwjPVAfyb/+afhrylPIiP3tbND2GbKYBxjExJiIaxMw+MPZqBXZrOPbF7KYAlPxAh70
 frd3deP/Ii02j+vttc4TllEZ9A8qtIrNSps3zZ4fprFEIorVa2wdP6TzohBbDiXoB3QV3q6RvWu
 hyGEIJpanEll427SK6nW/TkVye/dZG5F2+VcpiVpouCPvoN+SjTiabgIQ3Jr2QQesh9EQ3oOux3
 Xz8cz942KIvqbsBs6PkN2WKy2tjgMLI0c5i8dXmPeo78xJOxe5jGzuxEdkp+d6YoYoArfmLmkOr
 IFdfiO68ZQQRDtx5JHFQrQ2AWmznykg7v3bwu2GQIvC47gu5CvBP6aOV9Fz5b6SKbKtdb5AkiUN
 HWEc5/LPLSsVnFZLul0fZEtFdA2SgQ==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A18DB1A0003
X-Stat-Signature: 8akmfgbkjwajiwohhnabt31hojck9crw
X-HE-Tag: 1755859289-510348
X-HE-Meta: U2FsdGVkX1/tJnEP2gdlkmh1rYBhan66vwGR1wQLq+YcVJ0yRhvOlXeKZXij6oYz5k6JBQU9GirbmX13/9KdM4dHlJps/NSvFiFcs4o8F7ocglF9O3itWfhW3Vw2Do7UdmgkElT3GJA217ZJ9vtLimJx0ctGu4LHGijRx/J4bCM38ISCjRU+B4V6XKR4Cby9V+YzpQfOuHE2ZFrCjugbFDwkB65ufaw2CR9zM9O9EOHsIpATD5pvy6UZg62LNaNWp6g1W/Di71uRxWaZRKUnf6WHEDAhhzRa7ChtjTQuNI7lo+wrGA1VYU08sWEjM4WbbnBN04RaPQFkvKX8cThnSni9pLOQL8hG1pgqaK6oZiiQyqTk1tWEMKGBrhAtQQ5R3MDgogG9lDtsXSDduV4zX6lYSDs52Xoql0TZvrjUuUXtyxQS2aD/lrDil06gDu55s+3iiLxZl4b0opllWR4nXDVaZkfNA4/FQkhf0eROHpOTiGYo0SeZPP5BVDgN1DBfk82LL6QfDvkf/RFpnsvevOq1YpiBGo4z/5L8McqIEFApxTuIM22W/ScBH24y918trvN9Caoba02zdDAIdOoA4yNTWvreW1JzqxgkM1h1AQJbDBzhorx5xgwx7DHEHYhMGgRVSpN79Rmbdu/HIeqg33sR9qdHjRyJjdmwFAqJhr9r2/7+89MTrs/rBPyZnL0iCakEis+oF3fiQQagvHbY+B6Yrr3Fl8Py5X1iPZGGcIwYMNiy7834Vn6vsydukjr/zL7pBwDo5Ihri/f3dEPHAA1ney1H+gNtTWXTO5ThjzAyuNNeEna9ayPqc30yhNJtFCXBFb5tygcsh3XF95/eqOVWgSuHygW/fRHQlde4wbhgHxozEXvhGlT20hUOtbC8NI6UrF1H3g5FNIE5kFpcSfLbR7NZXWg45lI4o4JUejNOxrjVmZMNzLp635AsooNPY/fVdGWQ6KP/5o2TNSO
 vXWqdOuf
 yFhQ8O8/pItxqbfgLlQRx0eVm6lSVEKVRn7QR/G++Cv3b4jzPjRRm4mIgGnXdZIS3aIef0mghV1EM+2+JFCxSqxxQClUrgCykepaD+rIMKtJU6Pdq9QxZXnPHLnwXi+Cdq8EtaU6oZGhnTNdUdUw3UP6rUxN2gd82PdZAOsf92wb7TglAqAURh2B+DP2ytbA4+O0v8K8siUxpUHJROtHTxmjjwludPmVteR/6raCsPfKF8P+X4ihEU0O+eNPdhcq0FEoE/NFZVs4ih+lsg7oHur12lZjIb8ZBcQVT4JH71X64ET7hIljv2plisoD+RSFQnFTKImWDhSNrDTelr2CKRTDJ0gWguWnXX+X32Q/KfkLkm5Xp50ys8hjzZJyqgKHJpSiPD+tXB24QkeZKpPD2Giev5pLvCpbIGTdyZADPGH+cTih2ewaBVitcmTMGSCirrp1YFTEdE+dcvznZh3tpDygXzz7hNdXuJW7R+VdeHt+hbm0zm4rj5U9Bf4Q1egd3pHAi2yjQOwrDL4lgFmSCdjJfOcFWOKiupWtZBT6ivnP8tpswkuLo7wcZ4HNOej4K84evvQJ4LwddrMWmxMTa9KsuwabLAFjG5PfxfaLsroHl31gIl7pgJvgTxpO9oprkrtkrH6WB2TDhFu67FDmtqVDK5Bw0EMVbcI9gRM8NoTwA+WjShv8xXhRo9UHmnS6NNn4lkBQ4o+ybslVSq23tgrshCHLRme7XRzuSg2o81cX7LFWFPBzSn+3vCRubOXK5NeTAN39sa2wXEx2YqnctcMnGbTfv6JPYdUueGCiARMkxKO3fdEPbpCNM3i1CxNl9bKjZ4HPBPM7Bwt4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:56:02AM -0700, Lokesh Gidra wrote:
> On Thu, Aug 21, 2025 at 9:14 AM Zi Yan <ziy@nvidia.com> wrote:
> >
> > On 21 Aug 2025, at 8:01, Barry Song wrote:
> >
> > > On Thu, Aug 21, 2025 at 12:29 PM Lokesh Gidra <lokeshgidra@google.com> wrote:
> > >>
> > >> Adding linux-mm mailing list. Mistakenly used the wrong email address.

[Cc'ing MEMORY MANAGEMENT - RMAP folks]

> > >> On Wed, Aug 20, 2025 at 9:23 PM Lokesh Gidra <lokeshgidra@google.com> wrote:
> > >>>
> > >>> Hi all,
> > >>>
> > >>> Currently, some callers of rmap_walk() conditionally avoid try-locking
> > >>> non-ksm anon folios. This necessitates serialization through anon_vma
> > >>> write-lock when folio->mapping and/or folio->index (fields involved in
> > >>> rmap_walk()) are to be updated.

For non-ksm anon folios, rmap needs to take anon_vma lock.

Simply acquiring the folio lock instead of anon_vma lock isn't enough
1) because the kernel can't stablize anon_vma without anon_vma lock
(an anon_vma cannot be freed while someone's holding anon_vma lock,
see anon_vma_free()).

2) without anon_vma lock the kernel can't reliably unmap folios because
they can be mapped to other processes (by fork()) while the kernel is
iterating list of VMAs that can possibly map the folio. fork() doens't
and shouldn't acquire folio lock.

3) Holding anon_vma lock also prevents anon_vma_chains from
   being freed while holding the lock.

[Are there more things to worry about that I missed?
 Please add them if so]

Any idea to relax locking requirements while addressing these
requirements?

If some users don't care about missing some PTE A bits due to race
against fork() (perhaps folio_referenced()?), a crazy idea might be to
RCU-protect anon_vma_chains (but then we need to check if the VMA is
still alive) and use refcount to stablize anon_vmas?

> > >>> This hurts scalability due to coarse
> > >>> granularity of the lock. For instance, when multiple threads invoke
> > >>> userfaultfd’s MOVE ioctl simultaneously to move distinct pages from
> > >>> the same src VMA, they all contend for the corresponding anon_vma’s
> > >>> lock. Field traces for arm64 android devices reveal over 30ms of
> > >>> uninterruptible sleep in the main UI thread, leading to janky user
> > >>> interactions.
> > >>>
> > >>> Among all rmap_walk() callers that don’t lock anon folios,
> > >>> folio_referenced() is the most critical (others are
> > >>> page_idle_clear_pte_refs(), damon_folio_young(), and
> > >>> damon_folio_mkold()). The relevant code in folio_referenced() is:
> > >>>
> > >>> if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> > >>>         we_locked = folio_trylock(folio);
> > >>>         if (!we_locked)
> > >>>                 return 1;
> > >>> }
> >
> > This seems to be legacy code from commit 5ad6468801d2 ("ksm: let shared pages be
> > swappable"). From the commit log, the lock is used to protect KSM stable
> > tree from concurrent modification.
> >
> It seems like the conditional locking of file page/folio was added in
> a 2004 commit  edcc56dc6a7c758c ("maplock: kill page_map_lock"). Later
> in the commit you mentioned locking was also added for KSM, and now
> only non-KSM anon folios are left :-)
>
> > >>> It’s unclear why locking anon_vma (when updating folio->mapping) is
> > >>> beneficial over locking the folio here. It’s in the reclaim path, so
> > >>> should not be a critical path that necessitates some special
> > >>> treatment, unless I’m missing something.
> >
> > The decision was made before the first git commit 1da177e4c3f4 based on
> > git history. Maybe it is time to revisit it and improve it.
> >
> >
> > >>> Therefore, I propose simplifying the locking mechanism by
> > >>> unconditionally try-locking the folio in such cases. This helps avoid
> > >>> locking anon_vma when updating folio->mapping, which, for instance,
> > >>> will help eliminate the uninterruptible sleep observed in the field
> > >>> traces mentioned earlier.

As mentioned above, that isn't enough.

-- 
Cheers,
Harry / Hyeonggon

> > >>> Furthermore, it enables us to simplify the
> > >>> code in folio_lock_anon_vma_read() by removing the re-check to ensure
> > >>> that the field hasn’t changed under us.
> > >
> > > Thanks, I’m personally quite interested in this topic and will take a
> > > closer look as well. Beyond this one userfaultfd move, we’ve observed
> > > severe anon_vma lock contention between fork, unmap (process exit), and
> > > memory reclamation. This has caused noticeable UI stutters, especially
> > > when many VMAs share the same anon_vma root.

