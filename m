Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F66CCD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578268E0006; Wed, 12 Nov 2025 19:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529598E0003; Wed, 12 Nov 2025 19:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C95A8E0006; Wed, 12 Nov 2025 19:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 286988E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C464AC072C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:37 +0000 (UTC)
X-FDA: 84103735674.05.4D09907
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CC8A180009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AqoeE+pC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=esqT4S14;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSwORnancKHNofaAf7B1cVMyDw6NILBinjf3KRFPY3k=;
	b=sjuu8ouXgCdQbx06Hcnx2axhdNUPpTB6HLSXUoR3tqwffCk17BiYfF9OsSTD4GHvVLBkef
	FMrPdR54wteqSrKhcCD2DCxbzesigglsnGn03dq5OkiYCheJIur452A3EvkzUWc+vuAycu
	ePe1V61i+xCVRasMcSgfLQ64TEuQewY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AqoeE+pC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=esqT4S14;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762994614; a=rsa-sha256;
	cv=pass;
	b=53XdrgEEgI1Hgd42bwum7geUw1u2SeLdqngFv3p7qSa2dzI1pmqtt7mfXe7h9pXGbacrFi
	SwgL6QUrMZkHagOfOS0CCZxajYMqfe4xODIhk0kCbZOaaDaPln7lynGxXIPQg7tuXF7j7x
	/pYsOMfkLJOXa9u+8O+U8baBDQUUm+o=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACNuotd010137;
	Thu, 13 Nov 2025 00:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PSwORnancKHNofaAf7B1cVMyDw6NILBinjf3KRFPY3k=; b=
	AqoeE+pCW6My3TCuMypPTpKs3QTQhT/35GJl5lcoEuUhRKFuwCO7aIym7Mw0H4oO
	wlZmd7mw7kh7h5r5vdXAYMK5F6dAlN9jUc+AdYs1joXT/A5uqqTyaKueqeDrE1E8
	qkiSFSMHKQZiaN4MY2MTWkPbOYNzYBJejaPzMh4xrL60NklQYUYy+7RkzL3wwTC6
	jLaF+T0yk/34LEvNlV+2ETxRZ7AgrGm/mBG9n6eJ9HQ+29IJYG+f0fBjtLUQZzwQ
	+tlFVlG19qTH0L0M65ABiLG6BqlAPnLH4EdHnQawjc1TRUz/98foC/6pxVHk3f1W
	Ymbhut/7YLxHlOmakFxo/g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxfvgssv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 00:43:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACMB8Ek011407;
	Thu, 13 Nov 2025 00:43:26 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaeyjd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 00:43:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpbHqIE11QV5LoCHHTjrg3qzzZOxJnNGYr+J6PLWJaCvypIhHYecufI7i9PlBjUXzeEf26l1HKfeK7exUg+Vhqozsrmi7ayIso/pfwJ14rGDXTdkvPn2qltELfAih1g8/Pnax/2BC/8tXimbEKsD4qrU9dCdSznaCqXlWWbxfSGqSmYsvBpoiw/ZTOm4dCvgUGhQ0Dip16jQhppp8c+ya3nHNxTrIhwFBI6b12NQOpsaSIfZYAtuEx1UmLU9hamWfe12yvPqkPVEAiDjQPVbbmhMG8k7YyQvP3HOoOVHTyKKSu5NMWq6ipID2amUBA1d7MMtAbHajVKRHCiKIIT7TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSwORnancKHNofaAf7B1cVMyDw6NILBinjf3KRFPY3k=;
 b=VaYwg54TYuwvatuZwMhpbwlTU4/NHbwSOdWMPn4A5aolkK5enDm/kkcdUT0eBWuP5mcYTZ7R3x7WUmlW5lI3cM3C5ojm7O5LldsO8sZFl+yo9JDxT9sQjPiNeM8qLoL0RTDoJmxsp9LAntjHa2xnkyUpJADRV7VHLgVvl1qWIFo1KHIF0x+A0b7fxqnETtn9OfQ+wAX4c5GLUJtS/qtTn+6j7kHWkID5rEdJ8ubM9+0oXyheBAT6gdu0hz2qMEmVQOy219o9yimmJUv2RDLLrhWBXHRfqa5rG7dIlLg4KM4ar85objfPCvhWXox4+DDe1C1e5XpouhpnaETB/qqIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSwORnancKHNofaAf7B1cVMyDw6NILBinjf3KRFPY3k=;
 b=esqT4S14oIx7utNaxpq8zYjnh+mvRMD0u46qCS4VH1HMqy7npghBopqbOBadMuo/qZwV6pqGt0vws7dUkz5NsbKlw2r28WhT6pUFrsDBzo0f4060w2/VHbzgf2DAWJj927Bj20I+4WfAtZKIxKrWmA8Cia9AJ63rD5+nvU3FCgc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB6810.namprd10.prod.outlook.com (2603:10b6:610:140::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 00:42:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 00:42:59 +0000
Date: Thu, 13 Nov 2025 09:42:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Message-ID: <aRUpja4e_ChaZa9I@hyeyoo>
References: <20251111125331.12246-1-harry.yoo@oracle.com>
 <eesmaqfwnhq4xcoduevr5aodsf622ugn5aheywvpbhpg5fzhcv@5zbfhikqmrtl>
 <CANfXJztJZJ4eaFf+FxC=deFeO7MG0__U3FVtBDcmS7iUk3gFgw@mail.gmail.com>
 <aRN_0P3CXDJujrLp@hyeyoo>
 <CANfXJztkO_r41SU6jNBnh=tYDSQ=rAFj4hZFX6Crk1WDAg-QDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANfXJztkO_r41SU6jNBnh=tYDSQ=rAFj4hZFX6Crk1WDAg-QDA@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0011.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 54cb25fe-588a-437d-b65c-08de224d97e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTc3YmFyQVZkY2lRMW5xc1lGWGU2bTVndGFiMXJiQ092QUR4dVpWQUhvRFR6?=
 =?utf-8?B?a25EVHZmWWtIbmZBQkYxOE5MbDEzaSs5NXpmU05NVENXLys4SG90WWN6V3Q0?=
 =?utf-8?B?YXZ5YWF2WGh0OVh6NHJVNFFhQjd1VnJpWDdHeENMYTNHbWtyRG1ZM1phekp3?=
 =?utf-8?B?MEJ6R2tJaTdjRGhqYjkrS01CNkVGeUpMSUtQUnFzUUhNWEFnL0Q3V2JKWkZH?=
 =?utf-8?B?WGNoWFFXVVE5ait5eHU0cVpXeTh1STNad21Ka2FWSjJjc2pISFV3aGd2b2Jv?=
 =?utf-8?B?UVVqaTBKL2RGWmk4cERlOUdjZlU5M2NubkJsYk1KRHFVdzhKbllWVVhPZ3hq?=
 =?utf-8?B?Z2RHV0U4WThvVTBwV2RQbHlTWDBybkl5Qy9TNThMTytBcHpxamNxVXBiVmx6?=
 =?utf-8?B?WmdVL3hMYWtZSG5rUU90R3d4UWRXeWFleWZUL1loWktlWTYxQjlnRDQ3SWdH?=
 =?utf-8?B?aFNLZTRFTTNHUVpWY1RmK1luQ21xVHFqSWZmMHRRSDVXaHdHQ0ZxK1ZrTDRP?=
 =?utf-8?B?RW5NVmFuRXZkcU5reGt3ellJUHh3VENiZWp6VzBFM0Q1MkRMemxtcDNHVG5L?=
 =?utf-8?B?Y0lZNloySGNLMThESlIvWmNvVmc2aFU2UUR4VEpZenIzcTcySnNzaU9DdmtN?=
 =?utf-8?B?SGdUNFZBMjBTdmZjbDdvak9jbjYzQnQxVzZFT2YxbmJxT0tlNXR1cHJBTklY?=
 =?utf-8?B?TkNDTUVkSzBSbURZVUlLOCtscTBScUpzcktQRE5DM2h1VGd1N3pibnpUajlH?=
 =?utf-8?B?aG9PaVVIK1I2NTk0TDM4VHQ0TzV1UFg2U2RBMXg4aDFLOGxuek43NTF0Szg5?=
 =?utf-8?B?VDJ3aWhMcmRxMkRYaEF2NE9IL29oVTVvSXRuQ1RoS21ubWxRYlFSZkdMbjZW?=
 =?utf-8?B?TVBUb0lFYW9ENHNUSmxJZnhwWUlqdk13MkZOMzNOMFRwUnJBN0tRQzBwNmlC?=
 =?utf-8?B?YkxXdlpmcXpuWHVoRmFqR2dEakxZY2RZaFVGb0swVGF0bzdVWlAvOTVTTlJv?=
 =?utf-8?B?YXZlakV6R3JEUHZWbWk3Q1JSOGl1YkNLbzU4VDZ6M3ZqTDZwOWpoYkxYbk80?=
 =?utf-8?B?OGs1THkyVHdjSVN5ckxDQWxUb1NsdWhJanp0eWFINDlCdHNwZDJ0bzFTTHZn?=
 =?utf-8?B?RUU0bnQzbVVmc1k0Y2JFdXljbFVSQUVrTHJuaFcrb2U4Z1Fpb2pwNnl6QmJh?=
 =?utf-8?B?UWdqZHJDRFZwTnBFWGpwTkREZ1kxMHU1bUtYYlJLZnJ5Y3lrdzRWUk9GcFMr?=
 =?utf-8?B?eFowY3VhTnEybjJnbGNqU2ZwQXNGRERHNkFWa3RpR0pubjdzY3dDbUJrTVBC?=
 =?utf-8?B?K01lMS9iZVpSNm13WEplY0Z4dUI1c01VMnpjWEJudGI2VFdUMVJBSVYydWo0?=
 =?utf-8?B?aDcrdU1iRE00ZzBDQ0U0RTN4KzRlNEFYUFdRT1hUWHRBa0tUVlA2Q3hTNkQ0?=
 =?utf-8?B?bTk5elJIM0d0R2VjbUhSM3FzY3NoaTJzbFVLSllBdWcvT3JlMXBOVXBIVkV0?=
 =?utf-8?B?eGZkQWJWNnNVU04yZVJlQlo0cjRFMTIvNThqSnVHNG4wb0Z6ZEdoYkVTSWVF?=
 =?utf-8?B?czVtaWo3SnhZZE9sUCtmWXJZKzF1SzJ2eGszVkpMajNaRVdpa2NnNHpVMk83?=
 =?utf-8?B?U01DMWVpdmFqT2pBS0VqWkplTDdYRC95TFJFeTVLMk1rVE55ZjFjZDNVWlp3?=
 =?utf-8?B?WTRmNzV5RHBaUUNlQVNTQlRsbVd1b2tnZDVLMjBGM242d3Q0a0Z5M1ZSaktn?=
 =?utf-8?B?ckdIcXZjaUtyc2tTQktGOUR0ZXVvQjR5a25KVHEvNkFTeW14UElyTHNFcE9i?=
 =?utf-8?B?a2xwbjZNZFJFcFJDTnk3QTdsL0tTbTJUVytZTWxtSkFFWjYweTFwNnZiSkYv?=
 =?utf-8?B?WHp6NFB4RVQ1clFVNmNNU1FvbERHelNWc0xrdFVWYVVzM1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHljVE9Bc1ZHUGJ3Y0FzM1l1VWROek9ydzVVb1pmTWNTNjVBczR6YUlHQjBM?=
 =?utf-8?B?Smx6cDhVQk9iTlp4UzJWWkpZbWxrdTZUTnpqZzB1QnlFNUxLTWZYa0FVblR0?=
 =?utf-8?B?Ui9nUHFYMERCNi9TL0VwYVBoVkZvMW1jRDZObElNR01rTGQzMHdQUm9idGRJ?=
 =?utf-8?B?UDhlc2N1cUh4Z2plSzR0dGpmSU5vWUgwTkFiSDhWOEFLUXdrcVZnZDlDVGNO?=
 =?utf-8?B?TkZjRFRBV2FJblpGdzBWc2NvTnBQTTZVNUdIbVU2U3JPMkI0am5iRnBHSmdu?=
 =?utf-8?B?R1lhbmdGZHhRcFp6MDdTVGhxd3NxcHlHTWIwSjNiZS8vK09Ydm5IcUU4RXNv?=
 =?utf-8?B?YllBaldjUzdvOGxuQ2JCTTZQaC9xb2pldHVlZHg2RyszTklKVm4vamhTWlNa?=
 =?utf-8?B?bjRNamg1WHpqQnNZWm80eWwxMWNSQ0Z0T1U0UDJybGZWRy9YdFVLYVZHTENX?=
 =?utf-8?B?UkVreTVDUlRWb1dpcjVPdzdBNDdUK1ZtYVpFVWRxNHN1UHQ1YUJKa3FnQzdR?=
 =?utf-8?B?M3lxS0xsS1Ava3Y1d2FQZHM0QnlweTV2NFlZS2Q0bE9SQlpLVXlObkJEMmJF?=
 =?utf-8?B?Q1ZFRGlwRjF1U0VqbnNzRWl0NzBXYzVtN0RpNVVna1ZTaHNvZmtMeDZHaVhC?=
 =?utf-8?B?T0x4SlA4dVJ2ZTZjTUVYaFdLRkZWMjBUdjFUQkRZbUhCR0Q2ZVJsOGtJYTJH?=
 =?utf-8?B?azdTR0Zjd0NSNkxLZ2tPSjhraW5NZkNuRExpSDRpNnRFdGgzY2R5NlZTRkha?=
 =?utf-8?B?cTRhQ0hJS2pGYms0OGlxUTh6ZUdaK2RZaGsyNW1ManNsRFoyZkJodmhtcWtP?=
 =?utf-8?B?Z1orSkVoRjBId3FPWTJDRVV2MkRFaWpsU2pNVnBoZVU3N1FvUG5HOGQyWVkz?=
 =?utf-8?B?ejdidDhWeSs2bGsxMmRibU5uejFsUFZCdjl1U3Z5ZzdxNE1jT2ZnVDZMOTlz?=
 =?utf-8?B?K0tqckVGTGI3ZEcrb1RES0F3NlIzYjRqR1FNejFjQUtGSnBibDdEVFZBRXI2?=
 =?utf-8?B?NC9nakFJQUF6VTBIOGJoT0ZPRFZ6bUFsbDB2cW5McHh2dnkxVVFyNXZva1ZN?=
 =?utf-8?B?MExvekZxZGNBWmtWbGRIOWlGem8xQVN2OEpRL2w2SHNWNGFUZG02TDZJeXZm?=
 =?utf-8?B?N0dNNnFaYWRIeUw2cUZZVzkxK0NhQ054dzQxcVBZbzYvUUoxenlQRXlrVXJY?=
 =?utf-8?B?QlNud1JyUFkzNmhPY2pWL01WbjI4OHgwVFFacE9IUHVXcWRtcXhaNHFQS2FW?=
 =?utf-8?B?QU1DNWpqZnYxL0VNUlNoZHNEd2JORVBmS0hEcXFDQ2dWWmhPbENyRXdEbW84?=
 =?utf-8?B?ZFhJM3ZzM1F4NHIyTUx3TDdrbkhrb2lsMmtOR01QKzZDNmNJeU5tSUcycEQ3?=
 =?utf-8?B?VS9RbWlzVTlra0Z4ZkdJMzJZWXNsOUk5dFZ0b3NhNzBOSHJjYkQyMkZJOE45?=
 =?utf-8?B?SUY1aWxvRUpIUnBOVDdTNDNvSy8zVkFwVGF5cVlHeGFkM2hJZE5XeU9LZUJQ?=
 =?utf-8?B?amdmSUtkWndJOFMzdCs2eE5makJoNVlJZFpCYmQvL1Q1WUV1V3VmcE10d0t1?=
 =?utf-8?B?cGtzZDRKc2FuRlZ3aHprOWdKOHJFaFpvOXFTU0EyOGpBRHRBMjJ1QTdoblV0?=
 =?utf-8?B?bk4wNVZaWjdlanJyejFEOEdqSDd4QjBSRmwzVmROZDBPOUZ0emFoNW9hWXp6?=
 =?utf-8?B?VUM4U0hNemtYdmlVaEJtTFlPVnIydTZ5Um9oeTlhc2VvY3kvbU40NFZ6d0ZU?=
 =?utf-8?B?RkN6aUk1OTBaV3phU2NjcFpXR2lWOEpTNncwbTQzcWR6Mk93Wm5JenBXWm51?=
 =?utf-8?B?YWpMVzMyM1BsRlRQS3BSdDdiNG5OQ0sxOTJVbU85R3ZuL0lSTXFxczd2S0Ux?=
 =?utf-8?B?ZkFCUDFyWERBRUt2MG5qblJ4WlJTZC9kQ3RPL0RQai9kUEZvZE9wOHAyTnJt?=
 =?utf-8?B?Ym9oL1pJQSthc2FyM0RnakVqZHdpMDNQZlFWTzI2emV4SHNXWUtuK1lTS3JH?=
 =?utf-8?B?MGpjUWJ4ZlljMGRLZVJPOWtnK0xPV1AxdGdHZ2czTC9TNGhtRStXQTNPZGt0?=
 =?utf-8?B?SWJQMk15RllWNWxRTUdqNXBuVlRRdFZFZDlEWS9hdUxtbWsvU0k1bFc0WWJw?=
 =?utf-8?Q?kUHYELl90fT6BaSQV0OADFDrT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	excPNMlBqvoGyz1svMvLVLB0HGm4jRY2ixHJgfhQW25NsrQqirSYNbCBD5jAIjOJax55QguEFq0dxCoXIo2CoHngn6no/EhFhQh9NsveqF1auHWccGZw91PhD51TyBxHZQGlxAhEtsLmhV/dculMPFSNUTCkqQgpvW+oF8WbyNaP5RXzykryVKe02j8LhVoxU1m5J80XHicPExl54sbmt5g+l/+MEguHFV9AiPRFWES9ntO0QfbBoP/su6MSse0uW5DDSffnsr8eleqpB2QBI/2mRWjRkZ2/MZBiP3vNSBQi+88mwhSxm0WnPD+M3Cu3pm0mK2jk/U0YhgxjbaHEmwsXGcqdQAk9KiUHJziO2u7MZRXeR143bgP4b/dcSaDqfjl5gwRb/wQ4AenStxN2HuCy3JJATO5PJSGRdnkT7xJrfB/fxiGCzh/wbpwiaqKxfniqu4vFmTqob7KVPivFRifHeDx8K8wE1sDVXVTiPbMCFnMV+seDnUbllYUBqmxzjFfbbLyeUhNPwDv5iqk8eMokmGUsZvyHXhbGNnuL6yz9N4FeFQNZ7zYjIGIvq/YgEFfQoZLqvHlBGwD3ZoR3HbSx3dWzOYikFTFKgtEy+bo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cb25fe-588a-437d-b65c-08de224d97e0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 00:42:59.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QuZCKJVsGYpnYILKPEjdg3j2O1mVMdsUGYxbv/cSOzGY+Yre+1RntkyP5cmUXbpSQbRLC3AGKJhqnVRYMjkbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130004
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEzOSBTYWx0ZWRfX4s2jAVDegeru
 1fj9ZRpb43LnOHn1obdsvtGwekySg/M0b3scmwXu2q6bZdYYKM9wQoIyRE2LAnfn0h8BPMBKCP6
 PtfijN5TAJcBtttKgCdnP3AixzV7DO9+g7vfpmInZYpHhC9RMQhtciuotNHtAH2bH9sJ7dzBD7t
 RfL6B2qY7grj90++1Jqd4Seu7gXcdraVAw6HcquIJ0M+oa2p6Jk+FWz1u8Y94xss+qrzgJU6q9q
 bJZm1x/uZEK6Wdr1FPyYu6Bz65aF7wKPOSMvCt/frXgF2hTV1dWO+RwgVbZuNc4GC8w/j2+oaia
 xjs9K6ilP7Z27UP7hzBdfFFaYHdhO2t3nFobZeGFfbDt3PLfRUfM41RH/F5e1Ns1dH6b+nrZkR3
 56+HRqlesk4hxMTUzqV+wKniwNarxtqO0vgYuOFqLrYCK6pulco=
X-Proofpoint-ORIG-GUID: pRbjnOb4uzD3CxvAb94MBxtM1ulzFCVq
X-Proofpoint-GUID: pRbjnOb4uzD3CxvAb94MBxtM1ulzFCVq
X-Authority-Analysis: v=2.4 cv=FKYWBuos c=1 sm=1 tr=0 ts=691529b0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RiUO8OP4AAAA:8 a=veN0lwCLAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8
 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=48_zP8mer2TgWXxrmYUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=pT4S6EOKtMxKG0oa1MSR:22 a=RmeQpkrPow5vskDdKIzS:22
 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12099
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CC8A180009
X-Stat-Signature: 3otbhd71grk336jjj7n49mdhrtbj34yn
X-Rspam-User: 
X-HE-Tag: 1762994613-492867
X-HE-Meta: U2FsdGVkX1/o4ento7+NqRvBSPgxF2FXB2bXH+VuTI3nZTi8xwSXiUbmkXnRcaXmE0S/Pn7w9In0iODRnrdJikxToZtcjmLaR4EOBadP04abs8gw4zKJUJYWOsvBzI/DMF//zQsGK4ulSNpLy0BUOVVWrpmbVYpOiDLtcHRbhqvYYl4ZDSX9u0GlA+InrREB3jYbJoz5sAbzSoCC8HBI3fIGsWIt16a+WrjVljRw8EKev9jYsZCvtBGsjtNmQsZVpIKuimextEs8hHtCaDFYZO25f2drlBaSI0K6+szjCbbdtYIiYFu/qRgTG+CBcyidLNHo9yp6FeZOBDn1+LSt8J7+P0xXSIlOofTFzv39iKEBGaeLpxEeFf+HI9emV8vlzX1E13BnxExzqS5u8xqMrv7fz+8QGkCTyj9067y8XnioZh/NxzAzEV5Z0RaTWxh3LaFnV0IaRmJm8c0tSXcrkPaaVwE5qhnhHY4fiwRZPPbllcZaWHPr0J9Bsy4IQM5PMwgloy+mIn/EfqWdpAFE3ymLFTg8hsIbjTqDoU1EmPKM/89DlFi8bFX85uo9nouGPBOX5z9gt++33yQUWCluJLVuCZ3Hc+Bnnan4v4ogw1fEWHb3D+u6bufARH5zy/EBpBWTnwK+9BQyKxF1RZM0ITNgykw+NhqHGPhLnW3kGnToWVq1/kLStiAVC9lgnt0wIj3e+YU+uz3Iw/HhbAd4pu4ajaBKtMa8vUTO44SucISeNWmK4EC3YKeZhkhnLwi5k2chs2HOquFja8DtEXieigvfhlldtYU7WTX2S095C6ASAr3OX0/eq+bZPVgpuDaaujbcWqajfbN5wKVYWOdLqT8whN7AYzT3k2h3Cmck9gr3OHHggnUP/f7KjY9nF4B1nALSbwLzzMxBBZvxmQztS4j2Q0Q3wiY7iYIr8mTfNMZ2eRCUpLgrCTCcQfiYP1flPTLPsGMahDI4+1+3fTm
 JUbX+cBS
 9sCohHDxDskx/uit8sRCH9D9/n1pQKeRnkJwa/bsWwrgqRAKlXeq11X4DqDzKnnr75MB8cdxL2ipXkk8hwKZOi1CXaNngOideFELsmzXnD0LlBVxBZ/IOt75+QBGabvg2XHROCaOnpY6vlZGU2q/2wJbnFzmBMYtZ9dnPVxX2lDFVI5hOlzv5g/yoDMTlPN2toRfv41h78HJ5dHFL15LbCJTvqP2R+g+UCyb4/vm28xVXfWOOAP46AhABZdyVb8a+ErwsftTTvaTyE5NJw6n97zyCiW6NLz6wR5hg3/2I6kB8cJiVbdQgo36h0UhNWmMAy+m36bL5mXnhVvj0clZKvdUvMQY3AL61URkSlYlzYbVxaW0/dSvEHaSGjN3iQsM6i8uJSlLAqEDsSgA69nIAwotxloJ2u6L4Es+AUzyEqkq+g+3akISkut/Jap/mqWt8SL5LeO49RxU2czcBmAp8YF9T7jerFHHMYYbA9GVtp9olMdoeYvPTFDBkp82xLfn+ZigeCAy/rOPELWFue2eSrHg7hQiy9g9rHocI6NoAI4+a2z/DA8qGNImD1CSZm803WR/0cg45I2yEO/FS3RVmhRs0s2uO/RgiZMJupNKjLxsqkrG80zzZAIqgn/jH/50CQCqdtfbMExgiTOJtDUJznWR5Ed/5eDNk2BbL2c3n1j9uJV7uNstuV9VP01FGph5HE8rZiVqhFP3RW7/oFBVEuQjh5U7S4SDNYn8ujp4zPWiNO+R50Z8axv1+tUL2C8C6BEZgQKno+hjYNqkSpyMv4ZLSPKWOiVuz9q1LOOzxtp5bcm8YnBAoz5GJ24nlCO85hOtqr2Md7KT+ZqXHxLbdblfQVT3H9qdi0pBQj4oBcCRumZrxeLkyTh7xAiBLRs/+gHzHUJjcgm/+mN+VeKch/AjO5m4TwfY022X8r0RmpzuoaeYQPYY+1belNFy4fGQKlaF8ViPhFtRRfhbdi/y1QkHY/X63
 pkPdg2ga
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 03:47:52PM +0100, Tytus Rogalewski wrote:
> We wont make it until next week.
> Maybe you guys can compile newest r5 kernel with that patch ?
> We are using https://prebuiltkernels.com/
> ourselves. We can do that next week.

I built it and uploaded it to my personal server:
http://download.kerneltesting.org/linux-6.18.0-rc5-fix.zip

But if you prefer to test images from prebuiltkernels.com, I think it's
fine to wait for a week and test 6.18.0-rc6 - I guess this will land -rc6
anyway.

> This week is full of emergencies lol

Haha I see, I can imagine what'll happen when you test latest kernels...

> If you can provide me two debs like prebuild kernels i could deploy it and
> leave for testing for 1-2 days.

Thanks a lot!
 
> --
> 
> tel. 790 202 300
> 
> *Tytus Rogalewski*
> 
> Dolina Krzemowa 6A
> 
> 83-010 Jagatowo
> 
> NIP: 9570976234
> 
> 
> wt., 11 lis 2025 o 19:29 Harry Yoo <harry.yoo@oracle.com> napisał(a):
> 
> > On Tue, Nov 11, 2025 at 05:48:35PM +0100, Tytus Rogalewski wrote:
> > > Do you guys still need that debug then?
> > > I think this is happening only when qemu vm is working.
> > >
> > > I can get results within 1-2 days.
> >
> > Hi Tythus!
> >
> > Really appreciate you reporting the bug and testing it.
> >
> > Now that I know what went wrong, I realize that `slab_debug=U` parameter
> > will hide the bug, since we disable "sheaves" feature for
> > debug caches.
> >
> > Instead of testing with `slab_debug=U` parameter, could you please
> > apply this patch on top of Linux v6.18-rc5, build & install it,
> > and verify that the memory leak is indeed resolved on your machine?
> >
> > > --
> > >
> > > tel. 790 202 300
> > >
> > > *Tytus Rogalewski*
> > >
> > > Dolina Krzemowa 6A
> > >
> > > 83-010 Jagatowo
> > >
> > > NIP: 9570976234
> > >
> > >
> > > W dniu wt., 11 lis 2025 o 16:37 Liam R. Howlett <Liam.Howlett@oracle.com
> > >
> > > napisał(a):
> > >
> > > > * Harry Yoo <harry.yoo@oracle.com> [251111 07:55]:
> > > > > The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> > > > > freeing") introduced the remote_objects array in free_to_pcs_bulk()
> > to
> > > > > skip sheaves when objects from a remote node are freed.
> > > > >
> > > > > However, the array is flushed only when:
> > > > >   1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
> > > > >   2) slab_free_hook() returns false and size becomes zero.
> > > > >
> > > > > When neither of the conditions is met, objects in the array are
> > leaked.
> > > > > This resulted in a memory leak [1], where 82 GiB of memory was
> > allocated
> > > > > for the maple_node cache.
> > > > >
> > > > > Flush the array after successfully freeing objects to sheaves
> > > > > in the do_free: path.
> > > > >
> > > > > In the meantime, move the snippet if (!size) goto flush_remote;
> > outside
> > > > > the while loop for readability. Let's say all objects in the array
> > are
> > > > > from a remote node: then we acquire s->cpu_sheaves->lock and try to
> > free
> > > > > an object even when size is zero. This doesn't appear to be harmful,
> > > > > but isn't really readable.
> > > > >
> > > > > Reported-by: Tytus Rogalewski <tytanick@gmail.com>
> > > > > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220765
> > > > > Closes:
> > > >
> > https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@linux-foundation.org
> > > > > Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
> > > > > Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object
> > > > freeing")
> > > > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > >
> > > >
> > > > Thanks Harry.
> > > >
> > > > Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > >
> > > > > ---
> > > > >  mm/slub.c | 8 ++++++--
> > > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > > index f1a5373eee7b..a787687a0d59 100644
> > > > > --- a/mm/slub.c
> > > > > +++ b/mm/slub.c
> > > > > @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache
> > *s,
> > > > size_t size, void **p)
> > > > >
> > > > >               if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> > > > >                       p[i] = p[--size];
> > > > > -                     if (!size)
> > > > > -                             goto flush_remote;
> > > > >                       continue;
> > > > >               }
> > > > >
> > > > > @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache
> > *s,
> > > > size_t size, void **p)
> > > > >               i++;
> > > > >       }
> > > > >
> > > > > +     if (!size)
> > > > > +             goto flush_remote;
> > > > > +
> > > > >  next_batch:
> > > > >       if (!local_trylock(&s->cpu_sheaves->lock))
> > > > >               goto fallback;
> > > > > @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache
> > *s,
> > > > size_t size, void **p)
> > > > >               goto next_batch;
> > > > >       }
> > > > >
> > > > > +     if (remote_nr)
> > > > > +             goto flush_remote;
> > > > > +
> > > > >       return;
> > > > >
> > > > >  no_empty:
> > > > > --
> > > > > 2.43.0
> > > > >
> > > >
> >
> > --
> > Cheers,
> > Harry / Hyeonggon
> >

-- 
Cheers,
Harry / Hyeonggon

