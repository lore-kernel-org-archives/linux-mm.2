Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B796D74EDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 14:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041BD6B04DB; Fri, 23 Jan 2026 09:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34CA6B04DC; Fri, 23 Jan 2026 09:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BBED6B04DD; Fri, 23 Jan 2026 09:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBD76B04DB
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:42:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E96101AFD12
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:41:59 +0000 (UTC)
X-FDA: 84363493158.10.D0381BA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F0B180004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:41:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kBVy1fO3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f7bNaXTr;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769179316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22N6jsQFuzkhZCYIDn3lp21BNWtq4nlj/kB4wc1kSFU=;
	b=khJ/7s4hBdSTmTmN2rMGX7O02JA0UZpl9PJNxm4FrifaZXrDMCG1I/YG4srKi0PZ9IicAT
	r4F2Ujq6gywGQV8G4oHNSXUJD78bLA9SNX5+rjCjUHMtdka7uvW2IFh548OiXVRW2cArQm
	fwxghj6LlgzOqzJvwfB65wbxOEVP4eg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kBVy1fO3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f7bNaXTr;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769179316; a=rsa-sha256;
	cv=pass;
	b=WBGyZA1yS9c1bmcnr9ixgxNGgu1+fRBVUI8Bwy9gohfuqpW63y0x8AHDkQpl778dYSWnam
	pAQiCm5XepFReWSITyqNdWy6E07YZFX2ZAESsTXA4/2GKtnv6ln4HSwh8QrxHFppkRyWtS
	ow1xXbzNk5UlccyHKHaiDOiSIK1KTbo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3EIF11631823;
	Fri, 23 Jan 2026 14:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=22N6jsQFuzkhZCYIDn3lp21BNWtq4nlj/kB4wc1kSFU=; b=
	kBVy1fO3uGMaSk0ReTF/nLkg766sHITleBzaqA46KKBtQslKobA1qRodSzGb+99G
	6OlzWpqoyWpEYrZjaY3orGZscwa/6hjtQMKs3WURb2u0WTwkFJYGeEDvcSPFwLRc
	xAUH+5SoSsnrlfIjCCvwwIBLmFRu7MWnf58BnpOicxps4G7e0Bt5cb0xUs2+qqTw
	foRSSDRnFa/U6wqOxY/8mSlIhEtNweotNRRva+uJr8iqDzeY+/oWb9svcz2dCw48
	gqNnHKHxo72o3zFjyl9A6rR80GLx37E/ENojc1/Hvlb3mLz7UBuMspIS86bUaT4+
	+qH5CBXw8IMqL6Smvx5b/Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yq2csg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 14:41:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NEDijq024911;
	Fri, 23 Jan 2026 14:41:42 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011053.outbound.protection.outlook.com [40.93.194.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bujd1gwvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 14:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/mFe+REeS6RtwXH1XdEMUUSlu7O9hrDZwrbt//avqA1hed3e5M7IWXMeUIPw3u1amoFqaLeLIQC1dOcWVvjnCRpmi9V5WNVNc35okGpdP6BHVWzLHC5v4kvI1uVADGGSsTmSXTobWcG+dVxeCOrG8jw3ey7txsEfE35rs/+ALyvuWPm93PvXATjSi217WClWCG03jNxYeyk87c6s63hVzpa4MqjkH7vBbbNdvWGlQOr79yUfs0WW3t1x6p/lEOkVU8KjM9gPVXnmruoPTtB2MNA4ge7/5s5xXfVxkcQn8o0YHRB/pgoNI6tByMBfpbyPBSWXOVIG0vAtvGLO30Vtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=22N6jsQFuzkhZCYIDn3lp21BNWtq4nlj/kB4wc1kSFU=;
 b=frT+hDVeeWbZe1FMyPPbC2R8DwswdAEAcWPeAxpikbfBYuZZv/scbv1mfbfr5aYbdE/xOurFwTdR1gsUhiNKBpZhdDv0qt02tfOTcsrI0ISpIAp7Imi0w60TT8olTJxn6Klm24g127uyIuAw0tHZNBxDyPQB8B9vc8QOlUp7gCUFEbnpTJGOw7hhOkhuRnlq2MnEfge2NiJ/Se8ksLdw3jATKl9Qp+v+UIcIEoQp29b2Irq+mnr/4sLB3aGL3AO4ySIG6wii1BOXhh0Izy3xn6CVoHMvwPpf2IdR3rojmyuqBCeIR5LollZfcrernSTxqwRUSfX/CT6/5EMp58BVAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22N6jsQFuzkhZCYIDn3lp21BNWtq4nlj/kB4wc1kSFU=;
 b=f7bNaXTrNL/ecTVu/U3oM0odYXal9M0vxH8HFhY0IomMIFd3SvHZBOzHbAdT1RPXFKRummO6UkhUlvdPc0sp5vPNHxmWrq2gKagFjtDeNpAUFJRMU2q1f+M3gbhOL1e4uLMW3cSp1FfmdRbh27Qlh1GwPf1KO94PJzuGnEq+h84=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB7184.namprd10.prod.outlook.com (2603:10b6:208:409::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 14:41:38 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 14:41:38 +0000
Date: Fri, 23 Jan 2026 14:41:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
Message-ID: <108e3f4e-cd4f-452e-9bd2-1a5b892f6d60@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
 <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0182.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::12) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB7184:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb24512-d50f-4161-af7d-08de5a8d8418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVBiQzJ6clJkdWFUdEFtdlAxVkpkRm5SaUZMeXplUk4zd2xSTFVPT250TW43?=
 =?utf-8?B?bzd3ODB3anBxUEtIMS9LM3JVUnVER284MGRGdUhHVWlDZUlGZStra1VkRlFF?=
 =?utf-8?B?eDFLNElhYktWclBXSm5jenNwcHBlWVpscWRaWE5nQ01TditTd3lFSGtTYmtE?=
 =?utf-8?B?VlJQZlU1MHFZMnRkMHNEcU51aDlQTzEwRWJmbjlhSHBGa2FXd1JhOHE5R0l6?=
 =?utf-8?B?M2YvOXRoS0Nva2t3MmdlTDFRUkZpYmNsZmpadFYrbko4Q0xjY3VXRGd6a1Bw?=
 =?utf-8?B?UUJyYW1xMHF0R0YybnFkeTFiNHdaQVR6M1pXOTJXdEtmaXV2UlpEOElNT2dj?=
 =?utf-8?B?aXNmL3hBUHVXVXdEMXk4ajUwc3U2R1ZnL2p6a3dOSTlacHYyeFhtbTlycDlI?=
 =?utf-8?B?M003UmJ1Q2hZZWZBczBJeC9aSGh2OUlOcUdYRFNrV1NLZ2tubzBucU00NjA4?=
 =?utf-8?B?OU1qbFZHQW01ZFBDQmNnV1VVUEo5QkFNV1o2NExEeHV6N3BWN3g5SUxTeitZ?=
 =?utf-8?B?RU55eGpVUDFzZTNkV1YzeG40N05OVWJCaWhKR1l0NnB6aXZVM09XWU9BRDBs?=
 =?utf-8?B?SVNNUWs0QWtyM2dLZjM3RGZUaXNoeVRQQ1BmdS9ESTdwWThidXBqajB4bExX?=
 =?utf-8?B?dFFyaDh1ZzhIb2dFamJjZ1AxTllKbWdTZTVEMUxTWXROZmpNWWxKL0RFbnpG?=
 =?utf-8?B?L1NZbUN5cUZXUG5INm5oVThvTXZaWEs0b3ZtTDc5OGVnYjQzVHZscnd3bm1U?=
 =?utf-8?B?d2dGT0pkT1Y4ZEEyRG94a2NrWHdEVnlhM3ZPNUFBZFVFcmF0UnBJTVQxVzU1?=
 =?utf-8?B?a1JQUVMwOFIzTkhWNGFzUERZOVg4aW81K0lJQ2o4bzdpcE8zVjFURDYveG1S?=
 =?utf-8?B?QW5GSjlXUUlqbUt3a0NJakQ4emp2U1MrcGJ4K1Vob1d3NjFOazhMV0kvQXNM?=
 =?utf-8?B?RytRSnhYYUVmYkpQV3ZLWENGKzRpcVIrQmtsUTVpbk9JUndrdGs3d1FER1Ni?=
 =?utf-8?B?S3RNQS8zaUg3U3RVN0lZU2swSHIrb25SdUM5Z2g4OXVQN0w4cEl2bzgxWDU1?=
 =?utf-8?B?MEl2OWNOL3VrTDREaFBNUHVBL20wSVI1ZGJkK2J0Qi9DVFF0alRMUFE4TVV5?=
 =?utf-8?B?TVNZSVphN3JEUWNLVVN4ZDV3c0J1Nys0RTFaV3MyK0VzU294WmNUbHNQcUE2?=
 =?utf-8?B?cGQ4SHloUXQ5TU9QL3AwMXcvanlpUDQvL3JtdVU3T1ZPSlN6eVB0TUVITS9D?=
 =?utf-8?B?WUxOUnJVNmhSK2hOc2pYUmZTZWVCbzdCMiszNjJHSmNBL2xIWEdFaGxYVEVC?=
 =?utf-8?B?czA3V3Q5WG1Odm1jdW5KT3RmVUJTTzBEWDA0TFhjNms5QTNMU09tNGxJOXFO?=
 =?utf-8?B?SElOQkpKTXdDNFoxSWFUUFJaYjNFM1BNZ01iNTU2cFdhVGhaNk1hanJkdWVN?=
 =?utf-8?B?c3Q5RUZXeG02cnlmcDhXaDU4dmowdkxCb2d2TzZ0NnRZNjVPQ00vZklJSWRN?=
 =?utf-8?B?bFdMNFBMSHRqRWV1eXZQTWdYTm1SanVvaTAzOWx0bk0zVGJTeTZrNjJNZlZW?=
 =?utf-8?B?ZFpLdzE0YzlKOURNbm5ZZ0E3c0tRNEJ2V0NZQ2JaYm0wZzdJUnR5VUwvZlgr?=
 =?utf-8?B?SDY1WGhtbDJqNXZ6S2crQ0JYRjFCZWZjSFVKb09JT3JuU1NINnhqa1NGb2s0?=
 =?utf-8?B?bnM0enZ4RHBYYlRxczV2WllYTTRVVHVuZFZCRTN6R2UvaUhwcDJlUXNISW05?=
 =?utf-8?B?RkF0T1hNcG93NXRuZGtRQ3JsUlZlVkxuYkFsTFpOUi93RTk2QU41aFQ4eHRk?=
 =?utf-8?B?eGF3cTUvNDdwYW5LSGFGRUQ4eDJRVlppTmRDcGsxNkFMOVhlT1d2V3B6ZEty?=
 =?utf-8?B?MFVpcTg3UExyV3A1NkxXRVorVTdtM2xkc2JGcjQyb0NBOXdHWVJzUTF2Q0Y3?=
 =?utf-8?B?TFF3VmxRRjAvbUNkTXVMTkI4QVRCLzJsWDE1Z0RmaDlsK2xMMjJRZ2ZFNGpN?=
 =?utf-8?B?eWlTeURjUG5aeEpoYkxTcnY5UEFrS04xSVFpeWR0R20rbFN1UldyRkNOQ0Vk?=
 =?utf-8?B?QkFYKzg5MGFtcXpCRHlCUzNZMkIvZDlHN1oreloxQnhpME02enM1L2pEelRs?=
 =?utf-8?Q?GN/E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXZ5dHp1WEN2ODlLL0krUjdFTENLQkZFcDFJT0Y0NXJIcCtBZGZ2S2FFSnds?=
 =?utf-8?B?KzdRSmE2TWVNYlBkV2NqMVRjRnhQenI1bjVrcm5JTFhiYTF2aUJKVjNaREQz?=
 =?utf-8?B?MG5LRlVMaS9kTGVXTENpeEMvckl5dEZ1bGJRNXZiK1pVVWoxN1o2R1R1ZCs4?=
 =?utf-8?B?clFxNU83TkpGb2VmQ2NnRG5XS2oxdGVuSHh3L1lQSDhQZEZIcExUalQyYXVa?=
 =?utf-8?B?OUY1aVdYWHR1eWdjUThJN2QvZXkrQ0hrSEFWTzNhMDE1bXZHNnBTN041Q0FX?=
 =?utf-8?B?bmlOakZZVXREUmgwYlVWTEtKRzc1c1ZqcExyYnVEdHBNWi9GWEN3aGhWRHJh?=
 =?utf-8?B?aUJOUFZVT1Z3MHJtc3lQNi8zaDB6L2czbHJNaUc4cHZlRlgwcklGY3Z4MHBH?=
 =?utf-8?B?MXNxZW5iQzJic293bTlDTWxBSzBzengvS0NXSytkYXpJR0JTaFErT0tHb3M4?=
 =?utf-8?B?aXZ6N09FTmRvTzVIc04yQVpOdWRuTm8xZ1laZmVxcWtoaEdWUlJ5K3dRc2Uw?=
 =?utf-8?B?TjBENU1PV2ZqSUxoU3REZ3dVTUIzZjhDMjZTUXVhTHlUZ04rVlBybm0zam1E?=
 =?utf-8?B?YmhVSFFIZ3RoOXB3WVdhdWFiYUU1RVBqRnM3MVZyVnlYTDRCY2d2WGpJZ3M2?=
 =?utf-8?B?alBwWXNydDZHRWpWYTlFSkx4WVIzNHNFOUpFZ2lFbFpLazlROVZXYlZvQ0hJ?=
 =?utf-8?B?ZDdoMHV3UlljcEdsTkhkcG1TYmN1UlRyVEJvMFAxSG52MmEzSWtWRHZKRE9B?=
 =?utf-8?B?OS8va2VnUFRQVmFFRjR1Uit2M1FTN0lZb3JXS3pwQm5JKy9xaWE1c3NTUFpK?=
 =?utf-8?B?RXh6ZlJYcFZ1T2xGWXAvSEduM043aS9sdkplVU14czFVdC9NUkhnSnc3WHhY?=
 =?utf-8?B?cm94SzhtdVpGNHZLTFhqdmtlS1JtalFLUTlZVXpETUw4aEdaZkFCSm4vUkpR?=
 =?utf-8?B?RE9GV0Nmb2VBQ1cyK1F1RkVVZjBaaVRCTURSR09WT0tRYlg5MzYyTkd6dDVU?=
 =?utf-8?B?SXRwN0NlUnByd2dZQlZNVXgvcWN0VGd4T0RZdHZOcXVrclRPbXRiZTZ5d3I1?=
 =?utf-8?B?Vm1QVXNRZkRiZ05TM1VCd2ZYbmVkUy8zcFo2KzA2ZVB4SDRFTjJLcGpvc1Mz?=
 =?utf-8?B?cTJKd3pZOFRyQ2lOSVhyTzE2cHJ4ZGUwdncrVkZwVlp3ZGY2YVpDVHBWUnVT?=
 =?utf-8?B?bERtZThEZjNScU02WktpUzlWUW9BcGl4VW5VQXZxZVdVbUhWNUNPRng3ek90?=
 =?utf-8?B?WitGMkViUVdRbm9kclJZREFKbzV1TTFCcm4vVHNyQ1hkODYxNUs0WUttcVlB?=
 =?utf-8?B?MEczWTRSN0IrbXNQNnJXVnh5dXJDMG95bjdmMk41MkhNUE1zOTRBQXdpZ2gy?=
 =?utf-8?B?c251em0wZWdvYnR6czdKZTNVeGI4QUZHd3hXejY0aFoveU5xU2xKQUI0dW1n?=
 =?utf-8?B?UHRpVlB6RURsbHFqUnptT0hrNUFEOWl2OGs5L1doaU94eWxZV2doOUJmOEhk?=
 =?utf-8?B?V25GSGRaRHh4eGVoY2dSVzlEcUl3RURjaTFCckZrUzNvNmZGRVE5emxsY2l0?=
 =?utf-8?B?OGh5TmpBT0VlNjlPSU9LR04rbk02NndHY0xoRjhjMldWbk81eG1TTVdWL25o?=
 =?utf-8?B?TkJDV1RCd1RUSXNNZVVGcEk5NitmcVV0NWpPRnNLS2tsUVNNWTJQMlZGRDg3?=
 =?utf-8?B?MXhQTXpqMDNoQURYTCtvYkxodlhVR0RhQzhGOXR0RFo0YzNzZGEzOTdkMlhI?=
 =?utf-8?B?bzRCN1VDbGJsZTFFUXlGSG01bjBxNHpHY05VTG5nanpoWFdQalk4cXJzSGhH?=
 =?utf-8?B?bHRlU04yOS9GUDRrK0c4TnkrMmxVemh2enJrNk5TMEp3S0hIQkxWbFhPTUMx?=
 =?utf-8?B?ZkNNK1RJM0xLRS9hUlNOTVh6T2FMMUgrbWV1bWhlREdKOW5zUGlXZ3hRZTl2?=
 =?utf-8?B?VUxwdFpSeFlUQzhqeERwTTNKb291VC9WWFhnekl2c29YZXczZ2tHZTM5OTZW?=
 =?utf-8?B?ck4wT3RHVlRLRFZXV1BNeHpJYVVWQUxyYzV3ZVZKZnZYOWpoVDJWVm13THpE?=
 =?utf-8?B?ZHhoamdlcUZyRDRJRDl0K2FIUVhGV2xPSWY0cWFRaUs1N2ZIQ1U3QzZmUDh2?=
 =?utf-8?B?U1EvOXZLQnI0SnYvaFJZV1duTWlUNWtneXZQbzJBU1JqbVo5T1J2QitkWWFu?=
 =?utf-8?B?eE1uYlVTZEtUUzJrNDBIaXVLTTNZMCtDcVpJUGtFNkd1NkVQTWhxdU5LSlFE?=
 =?utf-8?B?V1JZUEZvSzNSZE5Ob250NU52cEg3OUpGeHRaR1ZPUjVnQW8vYnd3U1lQL0No?=
 =?utf-8?B?WVF0WjFkalY2UFdzdlRVMEJ1bWtta01TR0d2Y0J0MGFRcVJBR2ZScThFUlND?=
 =?utf-8?Q?zw92tlVBrol3+s8U=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8zZkO3QDbavPHycD6shsBaTRkJ6aoz9o2wJZTi4XFJ8MlzaJCzxKaMQ+wXYeKxg4m/z/k5p79TxPyvSOcXukFAZZZuhz6l+EQXUbArP6VmfTn/VW30X3+tt/yY2Srt8+rkluYPH6SqypddVtySFxsiqYCxK5fOwOqyXUT5zUYHxC5LVvoAGn26ajIgGwUh6LGSYPoMT5bfNx4aicV9czK/Kemkpqvx8Jal8nK61SAerHWV9rh7pI9lrtCgM+ylWR0ZG8HQbx+0wx2S0Po+NkCcCKHogt2g/Ciom33F4UsK9x4MjpeayLlNiWxTJckQRvYHdFNkMvOS8xUV77x33WLCxTIoxp8grZVZhkAZK6g9iZ4ZJuAq0pdsY9jHGOekxextpfHu/gJNxEwkiYTmlFa19EQdxY/Uy/V4l/nZfGeo6C+uNcgtEg2X0HiVmIQQIDjK1l3fVKCoj/bGMJ8sxIl+pCOku87+pekChh3+RKRYP2mt/xiPKEJtz+PbSPX2fMCo4XOe3QfiKh3pcPuEsgx0C9fh7hyMm7foWPHmCoI0N8LjPFvl3pjcp5BGhnGpnrAzI61UjMeK7gn7w22u9Qz7DmpfRHGb15mnE/oif4u40=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb24512-d50f-4161-af7d-08de5a8d8418
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 14:41:38.7514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJmN27mMnvmrfy+osDkV1z6dERBUcDE7bI5JlyiF0U5qp4pqFD40fucRXR7PdwBwFAv9GzPm7RWATErwb8uyN7TqLxXEbQG4gsuQrx4UaU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExNyBTYWx0ZWRfX9Cff11yjNpmD
 1MyVLGIRi4HAGuddOT9eNyCePfrs3ulfc6yHO0ixy0LOiiOg7/im3QJH8okJtoUhxHNmLqo1EvL
 /58Y7zqa2bjC78Eb2oUtpooHdtTY6IuJQdP/HQPW7v07vdSj4BJtkhvyaR+BDbUxVmojArVpiIS
 Hb6F9E8T48nvOD0UGvS/XZzejZztWLJMs81SA9x6VCqTp4uw93g3I/ZT2Va9yNeCi049QzV4At3
 zOOuoJgclv7pEuAZt3RPOu4uFSCa56WKYeRwLDoT8MF764kpTJBQzngZNMwQWZyXEc1WKZTpt7G
 9ku86GSpi775wfx1iHX5aDmeWAIm3KMD5ozxpeZdZaXFeNtIN3/cY9V/e/Fgvn2F/QyXyX10ylE
 uUq3WPnA+uQ2+sXkt4ViqTKUGADdMaaHAQdTzmImW02NsVinVIDvco1ERaSiJktDKOQ+9kUWnuF
 RPW+5h+04KMB3LS0V5bSJpJnmOcZYyHYRZj3apMw=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=697388a7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=5buR66NMk2U5ZcO104kA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: LRZpxtdfJXmHMDFOjcjBMGFus0rFNx_x
X-Proofpoint-GUID: LRZpxtdfJXmHMDFOjcjBMGFus0rFNx_x
X-Stat-Signature: 84uexgs1xppwyexkffy5sse4cztudysf
X-Rspamd-Queue-Id: 6F0B180004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769179316-475254
X-HE-Meta: U2FsdGVkX1+7hZY6srLgckPToUnkMIHBSoCqmGaQfX18G50rvTVmdYv6J3ohFhUhqhCK5mP22vgiMib2eMnYwooEUBI05Uo0h++pAqZN9ibmZFd/pMjExZnTHF/gkNhBMVXCp7VrZ3Y+uyfEX5e+uWKGVVvkabP0urzZxfcZ56flhb0KsB0DAhx33VfkptKm7feVGxJL116BSrovHFl3OMfiuyNaQxkWdUAgm5kV+5o/+HGEmz9c/sCAbF1Jmfbak/D4OoS+Z6As1N02boOz9/HyEhvcJCxpx78jLKNUiEQOCxFV1wA92sNZZgsNxkbWpKvuxjJI+fOEg5w7fz3SyP5bZPL9WfCqw94v8mCelYfZiu8WqcH4qruUw9p4/FYJnCeaqLkpFfoGI8owygMfF9h0Zha9gr95gcIKKyeZQq947xzUpD00kDeAckKf7CAaRyvcOPwcD/hZeF/EnbaY0mI5+i2PzgmMhar0At1jwy40JubWAs9gxv15ata8GdM7YSUQdV9U3hte135RzNbOr4hQNNV7e25RNMmm/MKBuiRRH5Z7ymVtFts831HLBeHC1r2rOTnG0Y3fypKKZKL211W6FKvqxKRiVVRRlNPUoA2r/UhcD/8JfbDEsp5j1BGMZRCCZZIT5z2fWkd36LGgcWGK9fnOEgTsJ+rbT6glw+SOk1KCo/jO1U1bRCJ1pd9LMZHB0TG9AbLJC3jbDCRXBBfhsikwlwPnzltq4AJJyNpGRYK9/cNue1W8Spswj7ZRWeHlhz1qqaXdw7AvSkA0izh/OaQCh8CRt6G44umTqblrist+tc8F5q+1EBkUMaiyo0VYkCuj9D7ACWzPCh2fLbRrMXLYQlIR0zOcZPn8CC7yVw75hsFT0wcXpdEScylPbYrTJ8hffqo4Kc+89NBCTgevs+07Cl2jEXot+SVxpHbX3NbG1pGJxurXQ8HxVnTFYm6SZo8awNCVPqMm8LI
 eiOzgB6u
 wzpVzKrTE4hV60B1hNwLvOsoutrbhDlBJCDM5KALiEcEjN+VZIU/VGNEwnwwdkkak3nIk35ed2KeZgwJ7msewU8itvTlHy6T/zSxuJsbQ5Bwu9JGBmjtbpPJ3r8R4F/QfRRnHb4H82jKrgFibOrP+cgjHFGi0hh0Y64ytpS012Got66O45pNkajJ8ZKX31KZOBbk7mqEvHr8l3ym7IsTgkOoGXNEBBlcxWLeKk98L3BVsj4jhymlhIzeRiYURQF0/fe3wNLN8Yg+eCScDyMH4GX0O/EQvpN3B1EP7HWQ/TAJdTWUGe0EY+snAkv3RDT7dClw3cCygUYJIG4Dm5BrxS1u4gkAsOZBvfrWzU+gtMD6KG05uEC4/dSLSxu3MXaobyPPfhpU4k1Asjm0iJQkbmPyjLbPCGFg4FhVXetZX3Xx04Jyka2Jy9vXl3GQjgGIGYDrIZplJaNzS+HNBjuPQRI8bPE5+UvPEfwm5TTd2IJJDj9YTtwPzsl6mIMRy0F8JFzzAKIQFJKblC+ghOPWvLSHBnUvtJ/HpBkTCScD7UQ0cJVcmV2i5lcFNCfL7UGPGzYKH195Jev+1ROblVOt2hpwnOEm7fYe+WRy6+yfHo2owgJbmbChkBkpRLQTp3mg8KJWVGIoOgUuHSDB0s8COb4e8NL9HmWetr0Ospcg5KWyKuSYq4mBq0VgQ7ZlNKFqjXlsQo6AMwLg+qxIgOzm9jvjumjsyPLu1VPQ41y8IsmqyvjIVJXlGtH6yel7ZIm3yGDGrt9k414X3aGNAF9eFfsVqkCYDjwvOhMdeHZEnd9cqDDesT0UqT1FqfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:31:05AM -0800, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 9:36 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > > The is_vma_writer_only() function is misnamed - this isn't determining if
> > > there is only a write lock, as it checks for the presence of the
> > > VM_REFCNT_EXCLUDE_READERS_FLAG.
> > >
> > > Really, it is checking to see whether readers are excluded, with a
> > > possibility of a false positive in the case of a detachment (there we
> > > expect the vma->vm_refcnt to eventually be set to
> > > VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it to
> > > eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).
> > >
> > > Rename the function accordingly.
> > >
> > > Relatedly, we use a finnicky __refcount_dec_and_test() primitive directly
> > > in vma_refcount_put(), using the old value to determine what the reference
> > > count ought to be after the operation is complete (ignoring racing
> > > reference count adjustments).
>
> Sorry, by mistake I replied to an earlier version here:
> https://lore.kernel.org/all/CAJuCfpF-tVr==bCf-PXJFKPn99yRjfONeDnDtPvTkGUfyuvtcw@mail.gmail.com/
> Copying my comments here.
>
> IIUC, __refcount_dec_and_test() can decrement the refcount by only 1
> and the old value returned (oldcnt) will be the exact value that it
> was before this decrement. Therefore oldcnt - 1 must reflect the

Yes.

> refcount value after the decrement. It's possible the refcount gets

Well no...

> manipulated after this operation but that does not make this operation
> wrong. I don't quite understand why you think that's racy or finnicky.

...because of this.

I only mentioned in passing that you might get raced, which you agree with
so I think that's fine.

_I_ feel this function is _very_ finnicky given the various caveats
required to understand exactly what's happening here. But clearly that's
distracting, so I'll rephrase it.

Have updated commit msg to say:

"
Relatedly, we use a __refcount_dec_and_test() primitive directly in
vma_refcount_put(), using the old value to determine what the reference
count ought to be after the operation is complete (ignoring racing
reference count adjustments).

Wrap this into a __vma_refcount_put() function, which we can then utilise
in vma_mark_detached() and thus keep the refcount primitive usage
abstracted.

This reduces duplication in the two invocations of this function.
"

(Adding the point about duplication since it wasn't clear before).

> > > +{
> > > +     int oldcnt;
> > > +     bool detached;
> > > +
> > > +     detached = __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
> > > +     if (refcnt)
> > > +             *refcnt = oldcnt - 1;
> > > +     return detached;
>
> IIUC there is always a connection between detached and *refcnt
> resulting value. If detached==true then the resulting *refcnt has to
> be 0. If so, __vma_refcount_put() can simply return (oldcnt - 1) as
> new count:
>
> static inline int __vma_refcount_put(struct vm_area_struct *vma)
> {
>        int oldcnt;
>
>        __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);

You can't do this as it's __must_check... :)

So have to replace with __refcount_dec(), which is a void function.

>        return oldcnt - 1;
> }
>
> And later:
>
> newcnt = __vma_refcount_put(&vma->vm_refcnt);
> detached = newcnt == 0;

This is kind of horrible though.

Maybe better to just do:

	newcnt = __vma_refcount_put(vma);
	...
	if (newcnt && __vma_are_readers_excluded(newcnt))
		...

And:

	if (unlikely(__vma_refcount_put(vma))) {
		...
	}

And now we have vma->vm_refcnt documented clearly we can safely assume
developers understand what this means.

>
> > > +}
> > > +
> > > +/**
> > > + * vma_refcount_put() - Drop reference count in VMA vm_refcnt field due to a
> > > + * read-lock being dropped.
> > > + * @vma: The VMA whose reference count we wish to decrement.
> > > + *
> > > + * If we were the last reader, wake up threads waiting to obtain an exclusive
> > > + * lock.
> > > + */
> > >  static inline void vma_refcount_put(struct vm_area_struct *vma)
> > >  {
> > > -     /* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> > > +     /* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt. */
> > >       struct mm_struct *mm = vma->vm_mm;
> > > -     int oldcnt;
> > > +     int refcnt;
> > > +     bool detached;
> > >
> > >       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> > > -     if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
> > >
> > > -             if (is_vma_writer_only(oldcnt - 1))
> > > -                     rcuwait_wake_up(&mm->vma_writer_wait);
> > > -     }
> > > +     detached = __vma_refcount_put(vma, &refcnt);
> > > +     /*
> > > +      * __vma_enter_locked() may be sleeping waiting for readers to drop
> > > +      * their reference count, so wake it up if we were the last reader
> > > +      * blocking it from being acquired.
> > > +      */
> > > +     if (!detached && are_readers_excluded(refcnt))
> > > +             rcuwait_wake_up(&mm->vma_writer_wait);
> > >  }
> > >
> > >  /*
> > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > index 75dc098aea14..ebacb57e5f16 100644
> > > --- a/mm/mmap_lock.c
> > > +++ b/mm/mmap_lock.c
> > > @@ -130,25 +130,23 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
> > >
> > >  void vma_mark_detached(struct vm_area_struct *vma)
> > >  {
> > > +     bool detached;
> > > +
> > >       vma_assert_write_locked(vma);
> > >       vma_assert_attached(vma);
> > >
> > >       /*
> > > -      * We are the only writer, so no need to use vma_refcount_put().
> > > -      * The condition below is unlikely because the vma has been already
> > > -      * write-locked and readers can increment vm_refcnt only temporarily
>
> I think the above part of the comment is still important and should be
> kept intact.

I think it's confusing, because 'we are the only writer' is not clear as to
why it obviates the need to call vma_refcount_put().

In fact vma_refcount_put() explicitly invokes a lockdep read lock drop
which would be incorrect to invoke here. Also I guess the other point here
is we don't do wake ups because nobody else will be waiting.

I think updating this to actually explain the context would be hugely
distracting and not all that useful, but leaving it as-is is confusing.

So I think the best thing to do is to add back the thing about the
condition, which I've done but but placed it above unlikely(!detached) as:

	/*
	 * This condition - that the VMA is still attached (refcnt > 0) - is
	 * unlikely, because the vma has been already write-locked and readers
	 * can increment vm_refcnt only temporarily before they check
	 * vm_lock_seq, realize the vma is locked and drop back the
	 * vm_refcnt. That is a narrow window for observing a raised vm_refcnt.
	 *
	 * See the comment describing the vm_area_struct->vm_refcnt field for
	 * details of possible refcnt values.
	 */

>
> > > -      * before they check vm_lock_seq, realize the vma is locked and drop
> > > -      * back the vm_refcnt. That is a narrow window for observing a raised
> > > -      * vm_refcnt.
> > > -      *
> > >        * See the comment describing the vm_area_struct->vm_refcnt field for
> > >        * details of possible refcnt values.
> > >        */
> > > -     if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> > > +     detached = __vma_refcount_put(vma, NULL);
> > > +     if (unlikely(!detached)) {
> > >               /* Wait until vma is detached with no readers. */
> > >               if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
> > > -                     bool detached;
> > > -
> > > +                     /*
> > > +                      * Once this is complete, no readers can increment the
> > > +                      * reference count, and the VMA is marked detached.
> > > +                      */
> > >                       __vma_exit_locked(vma, &detached);
> > >                       WARN_ON_ONCE(!detached);
> > >               }
> > > --
> > > 2.52.0
> >

