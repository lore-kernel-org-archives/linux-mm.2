Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCF1EF06ED
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 03:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5879F6B0089; Sun,  8 Feb 2026 22:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535FA6B0092; Sun,  8 Feb 2026 22:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3936B0093; Sun,  8 Feb 2026 22:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 274826B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 22:18:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A15B13B6C2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:18:46 +0000 (UTC)
X-FDA: 84423461052.07.BCB8F5A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id D23AFC0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:18:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=goArv5QB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ky7w5adq;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770607123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtAsUovzPEWrQdmfzoEMaqyixwbExfZ0Pkd9skpaiyg=;
	b=y2SeT70M+Fk/PLcKK52KyldIU7eifRFzMfW8IaSw1ggCdIhMndbUOMl88rk0V+17nFhL8b
	wJLEmzHD0mslZr89CHEYZAZIaVjcFUMJW4kj0Fbv9JwhmK7UBNv8Vgz28aDfz7UOG9Wudy
	VY2EH4FZIbCsHbjffQ3NxDsLkNaK1fQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=goArv5QB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ky7w5adq;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770607123; a=rsa-sha256;
	cv=pass;
	b=7xO069AzUQGMYMftW3HSxhgDvYVsLzqshohbJKcGtL6ex6nxz+kxQnQOZjwgdWA0iMYFqu
	44uMDCOp4kKyryraQwQE8twQ9vZH/lWWoBZHnuhtiur3CMkqqj3pAQd/ydlgAy0s2XuKB9
	cdpwJwT0efy74NjA/6QTWcK2id35JHY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 618NecwC136611;
	Mon, 9 Feb 2026 03:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YtAsUovzPEWrQdmfzoEMaqyixwbExfZ0Pkd9skpaiyg=; b=
	goArv5QBBNSEqRpaMmLDh8D5rzs9ijsRYvVnSOyfQ12DgolmI5L23ystZfUqlvhv
	+OwmYux1K/t4oeQFJfmInBBz9HIviXg7I/AeLKlRfOs7cWeWulfUaSMYWMrVHyN6
	O/kwZJHO1ygBOdRR4fzcMFdfXzXCgGUxPLBOiR06UWU8KZIixUgEjL1VBSqoGAll
	YDTqAP2CBr06EfrfDBQ0Xul6aqO0xNrIfSYUHAtsFJ3JdaWH84gmjN9hot3Ggzsb
	M/tKNHyiD/hKMlSvUhomLBd3t2VaY7gsSFpjTF+zl7Zkj1GstrspqRGFsk1mszl0
	nmgKSjTbst68vx81RVEToQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xhu9ag6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 03:18:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 618LtMIW015019;
	Mon, 9 Feb 2026 03:18:29 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012008.outbound.protection.outlook.com [52.101.53.8])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uuk0j4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 03:18:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8TDNs3eFDzd0HSoRBab3/Db7igHMIKXOaE36Osv6ZcDUU96ycdYNBMDMw+AGarlbarrw+p8Co8iH4xfqw7XwcIOPjSmVCJoV8yIitFJBHpJInhJ1xllO/UZ9l+cTilAarpce+qFeXOrx6obwYsuec6ENJFboZ8mgWYtWoj59IEneCA69oHUpxBbZAYkIyAp/FebQ/juEH4mBANwFM+yXU7q6n4n5w/X0an7Xv1ivZuuwqTjRqxLtRXDL391ICy0hm4aWjQ+ZdlONiwUAP632TkNzlGCUbX0NSiAqwy3W0ms46k6sdHpsk4/wAjgdcIszfRa+y61EqZAme9sOsw2nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtAsUovzPEWrQdmfzoEMaqyixwbExfZ0Pkd9skpaiyg=;
 b=AVYr3iIGxpB+QSLAxZMMHKFKF50+PE+i/qpSJPA4kUhbIXOhMnBuhBV3VWGyb/2cBgcgWsFd8YiMoTQKEKkErlRidIRGBws0/fgwk3Uul9U15KnLr8kOHU4WEpe5qNlWcDPNDx3b+PyIm+1aHKj7UhDX/38EuvaQsMAOG4cDVVk81bYtPX3MJHNqHnXyVudX99QCbmlTu+MgZmZnx9udxUQZvXg0aWO4K7ms+Aw98oMZhh1m51FIAk1yciMbk8dU3kKmYilCoYOhuGlxPxMTUczqgicI7DshI26iTYQWyunhAKYk6X0Mvh1uEyi/S7uEDC4w5P3LT79C7xp/EEsQ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtAsUovzPEWrQdmfzoEMaqyixwbExfZ0Pkd9skpaiyg=;
 b=ky7w5adq9Ukjy5wJrEs/PK1U0v2Tr8GF8/EfN/VQD5PcejPKyxO5G/D9Rs0NL3HtvU5ZzImM1oSInoKHjuTR4bDkIDnmCQZE4SKoyFBR8v3rn4zxEqCmrUYy767VtfAMOJx9EamYvSavw6RpPLEZRRld4VUNMDBjlqTV/yGiX7g=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW4PR10MB5839.namprd10.prod.outlook.com (2603:10b6:303:18f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 03:18:26 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 03:18:26 +0000
Date: Mon, 9 Feb 2026 12:18:20 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
        linux-mm <linux-mm@kvack.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/slab: skip get_from_any_partial() if !allow_spin
Message-ID: <aYlR_KW8xj4LJaYt@hyeyoo>
References: <20260206171348.35886-1-harry.yoo@oracle.com>
 <20260206171348.35886-2-harry.yoo@oracle.com>
 <2ce1eac3-98fd-448f-8a73-01bb3cb5a7d5@suse.cz>
 <CAADnVQ+1RBXBWNQtshEfFNZEp0tDZOFKf_vedyjgdz=wqWdG8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+1RBXBWNQtshEfFNZEp0tDZOFKf_vedyjgdz=wqWdG8A@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0137.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW4PR10MB5839:EE_
X-MS-Office365-Filtering-Correlation-Id: a2bb291d-4974-4992-22af-08de6789e373
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnI1cWRZSVFaTDRidW9KcUhOa2hjS0JUZGduOEZwSWRWczAzRVhyN0JrM292?=
 =?utf-8?B?Rld2bFdSdm5EODR0Ty9UU0p2V2tuaWdTVFdZdlVGYXZobWxkdFYzeHZLRnc1?=
 =?utf-8?B?ZmJvbVcvay9vVUEvNFZndGpCZFA1RVhhcXM3c0JlK0hPWjlxMHJncmliYitO?=
 =?utf-8?B?eWx3bUNhNDRGSFMyMWdhNzN0ZUUzZlpaMmhIMzRnNndpeHBydzRHalZ0cTJU?=
 =?utf-8?B?L2k0eU1yUkdMZzNULzh2a3N0OFppWm8yZHNwU1NPek9OdUphT250TGxHMmtl?=
 =?utf-8?B?cEtLdkRlSVFVTEVFZ0FOMXlsdnhXT3dYYVVDdGtVK3AybmJ6QzVURXpRUXBo?=
 =?utf-8?B?bjlIYVl3d2gvcVpaZDVRNGF3MFZlRkFrVklNLzAxOU1Zc1Y2YTk4WTBGSHYx?=
 =?utf-8?B?YjJ1NkgvWno1c21rMlJaK0RMbVh4bHFnRjB5ZWM5M24vZkhEOEVuckdmOWJH?=
 =?utf-8?B?UDdUUmZLamtXVmp5S2NaMURHWTJkS0F0V3lSMjZSMFNsZStDdTVJS2I4Qkox?=
 =?utf-8?B?MGdoUDNiZEQrS1B4aXpmR1lobml3YzcvanVScEJ3WU9NMUlVV2VQZWdCcitD?=
 =?utf-8?B?K1IyYkRxVnpJYS9LdVdDMng5VnZLYWo3dmNleER2Wi8vc0tnSmNZODlEWHFT?=
 =?utf-8?B?ZVNxMkNZak9qYWk5VkI5a1dob2FoWEVscFN0b2MxSzc3VGl5Y0Zrb2o5WkZt?=
 =?utf-8?B?UnRVWE9BWTIrWFkvQXBxNTIwOExINlVxUGFKQllSemlpUmF1dmNFRFdCbE9W?=
 =?utf-8?B?aTZvby8vMXFEbHBqa2lWdGRNWTdXZ2YrZXk2TkkrRFFLcGtrSHp4cTZSd3NI?=
 =?utf-8?B?NUxHVUM3Y210bEl0eWFYRWtxbzNDa0JmR25qcE9FZXRJa3hGUHVCVnNURkhk?=
 =?utf-8?B?ZGEyUCtDMURZZDhOeHVjZWtsU3h6dUxhWTlTQlVlSzBJVWl0dHBJSmZoNEpw?=
 =?utf-8?B?blBnb2xNSWc4NkdMRC81WVRENUxXL2FFUkxrTUZnZENRUTRYK0NXMTVDMU10?=
 =?utf-8?B?a0svYjdqLzd2NEZTUjE2Q0ZQTVJoVzZSVGxRZWt3T0ZMV2o5RnhTMXgvbXc5?=
 =?utf-8?B?dDVlSzNjQ1dKTnlQY0h5SUVSTTMrQ0QyWDVCZ1MxZVdwSDAxTDlBVmlFUlpT?=
 =?utf-8?B?ZmFyUHZhZ0psUnZUVjNsN3BVa3dyQTFsa0p2Z0o1MDh2SE9kTEZLdStoUkxh?=
 =?utf-8?B?dUJPR0gza2dlOGk0YnpFMCt1ODg4RzZnc2RsK0YwaGdaSlJKN25hejRVWi9q?=
 =?utf-8?B?aFNRV1FteTRRbHg3VDBBcWEvSGRISzBuNEk3cHc5NVRSTldiNDAwd2J0cGdH?=
 =?utf-8?B?cy9UNTVvQzkwSkR4bngyczFrSVgzYUlVa216dUZUN1JYMnozU3lMdDhobWRQ?=
 =?utf-8?B?NXAvUVZKTXdBV0V2ZkZyMzkrQ3ViUEF4Uklrc3RPVEJrZ2d6aXdNZlAyVkpP?=
 =?utf-8?B?YnRmakZTclp1aHI2enpIMFdCVGh2ZGpYTjNrZmhkUWw4TG9Hb1RTWmdISG5M?=
 =?utf-8?B?bGNuQkJYRTVobWVlcmtMaDBxTGFSVGFOaVRXWll6aGpNemFRMFRHL25YNkRw?=
 =?utf-8?B?Z1BZdDdnLzAxNHEvWjZVeUxmL3VOSWdTLzNWNmlIM2F5ekRRalpaalRIS3lL?=
 =?utf-8?B?ejJBamU0ajlMcFV2RE5vRWlNWCszeC8vUkNnV1FESytkN1J5UVBLZG4zOE9y?=
 =?utf-8?B?REFEeDMvSjNCTmJnSU1TajFlem9vbm1MY2Q3ajRYQzRGalhQTWRDd3lUMzlP?=
 =?utf-8?B?b21oRXNVc2JFWlk0dVZLdTZFdWJtbVdkMnJ1NFpJUjNKdHQ2MDI3S1FsenNM?=
 =?utf-8?B?ektSN3FBZEc0M1ZiclI4NE5JWDJFYlZyVHlhbGZUT0EyUTR3S3dDOURyNFpp?=
 =?utf-8?B?R0tyTGFaNHp1Um92bDhEYmVYR3h6VEQrTjZRbk5ZdExmYVdoNHVoQzRDN1h5?=
 =?utf-8?B?MEFKclZQUDl3RS9hazVRdjRwMkQ5TUhRTjZoRGpmTldtU0JsQnlaRlJaSWp4?=
 =?utf-8?B?Qk1Rcm5kSkhhb3pxbmJkeGVDQXVrelkxZGpnMzJ4aU4rcmJpZ2R6Lytid0pn?=
 =?utf-8?B?MlBTK0FSVmIxMEovVzZ0SVoxVHFnaWlGMWRyL1g4L0RhdVJ0WmlVVjd4bHZI?=
 =?utf-8?Q?b8fI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnEzN1VQZzk2b0VVRG5MMElOaDNmdy9PL3FpNTZoYTRSeGFFNEwwZ3hoU0Nk?=
 =?utf-8?B?VnVNK2RLZ1QwVy9abUtGRGd4VW84WC9paFdiK2xxY1RLVzU3K2s0Q0Ywb0Z4?=
 =?utf-8?B?eWordzFaMlZ6cSthZmhsU3BENUlDaFQ5bk14aWVJKyttWmNYbEVVZjlhT2tp?=
 =?utf-8?B?cmJTbHQ4dlkyMEprLzZGSndOSzNMZVowcGhEM0FOSXZCMGtNVVN2TGtXT0Fs?=
 =?utf-8?B?b1ZjcnA2Tk1FczJjeTcvdVljZkZhMkdBMC9PQzYwSzRZN0FjbkY5QzVud3Za?=
 =?utf-8?B?M3kxeEZuZ1gzbWJrRW8vcnRFYkhDSFg2Zm4vL096U1B2aUJFYmNCVHNhdDJa?=
 =?utf-8?B?T3d6MVRSZlIvaGsvSU1LeFR0RlZydXFCVTQra1NBcUhRQWZaWk8rRVdub2tz?=
 =?utf-8?B?ZjdqV1lEZnY0LzZIeHhzRDhkTDNwR0hOeVQxLzRqOXVxSFpYMmZFdjd1b000?=
 =?utf-8?B?d2c0NTVEOW9LYVM3RWl1bmZiSkFwbSs3UktlTDRHU0RYUVVRNzlYbWkvcmZV?=
 =?utf-8?B?SWZVSVhCRysyVk14SHZIMk5EN3E1R2l4bVc3emV0emZTeHkzZG8vVFFpQWYx?=
 =?utf-8?B?Qk1KRjViMStwUThaQ3p6SnptSXAzWnZ6SUVLZGdHaGRISG5IS0JXcUNiNXJG?=
 =?utf-8?B?UnhIYWdPOFJPQ3lVcDVMMjMySTVHUXV3a25qZjlOWW4vbXBQT0NpRzhNbi9U?=
 =?utf-8?B?SkR0TUJyYWlKbjdSRzZaaWlJSm5NVENoTlA1SmcyU1hiYWgwWFpTYmNBSkZh?=
 =?utf-8?B?cnh0bUNLc1lrMnIwdTdjcmhnV0dseGo0U1pFaDVEckVHTzZJV2UrdU92S2Vr?=
 =?utf-8?B?TXlvV0s0SnNVU0tWZnpIbHBnTmpua09KenFDR2EzN3paUG8yVGhhSzVFcVcz?=
 =?utf-8?B?K0puREF2ZTZzM280N1d3NkQ1Vlh1MW5YVmt4ZlNPcmhqejhVQ0U5ZXpzYkdy?=
 =?utf-8?B?NStNcjlmQ2VxL2ZOVEkweGFsaGsxOC9rTWdLbTdGSkFRQU1XRDJuQzlIcUFU?=
 =?utf-8?B?QlNpYmVPU1pqVUFuZDgwNm5RS2VUbE9IMGxoaVFCVi9IWVF6a1dEMmw4SE5z?=
 =?utf-8?B?VzZpeXoxVUQ5aUVwdHdjRUNrVmRPNmo1R3hxYWhITGtzT3EwakNEaDRKbUVm?=
 =?utf-8?B?cVZISUNNS254S294RG40L0s0TnVXSGpEbjhIZWZKZ1NIZHR1bVozUXcxV2Fn?=
 =?utf-8?B?dVUxVzFxQVJ5YzdDenA2TFdPMDZPN2gxNzh6NTl5dVJxWFQ5TmRTSDhzS0dR?=
 =?utf-8?B?LzZUNm9uczlIMHdkcmx5RXVxOWF1bmhLKzlrbTF3QytNQzExN2lGUHpCZVY0?=
 =?utf-8?B?QnVYK08vcmdaR2JZUUM4QVF2V3VCa1EwZzhYM215dmphYjQ2elZsSys2NnZt?=
 =?utf-8?B?SXZsQTgxaXgyOTBadTRVV0gveGxDd3d4dTdLajFTcERjUmJjajNjZWFPQ3NH?=
 =?utf-8?B?THNOZzVXQkxVZ2hrQ2JDMzNLRGo2bTRlVzRnSEhzMTEyR0hoYTAzd2RKMTVH?=
 =?utf-8?B?N1JlV0cwY1F4dnhWbDNxcnhtcTdVYU4veU9DZEhmS285NCtHRDc5aHd3RTVw?=
 =?utf-8?B?dmErMnlRaVJaUDY1TzUwZDBZYktuYWMvK0s2N0ZHd2tCL09CTGZ1K2drTHUy?=
 =?utf-8?B?ak8rVGdaMXFYMW9ibVVpb3hDMkRBTFk1MExvWENReGVIci9DUjNUU01JZ0FZ?=
 =?utf-8?B?ZmxyNHZmR3dFa2xQTCt5NEtRa3N2ckJMLysyUnhBQ0lTN0ZsWEhSK3NSNDZ1?=
 =?utf-8?B?eVdOc1RBNmozZFpJSVBRS1docDZGbW5sbFFpYnRYK1VScG1NQzJzeGUrWmZM?=
 =?utf-8?B?M3oxMGg3VXJKWk9maFplNHUzdGQ0WThscHpyQW5kZmdUSjNnMXp2ZENvaDhX?=
 =?utf-8?B?Sm8vbXRoL0lZUjYxZGpBRUNJQWVBUFhuS01meG1aMXQrVG1jY1VCa0p5TUND?=
 =?utf-8?B?UjlNNWdmbW4vbmhMY1dhWUtpbTZmdHpERUppbjlEOG1sbmMwNWo1K0VmSVVO?=
 =?utf-8?B?Z1BDcDlFczVuNzlIUER5ZkxRaWdvYXluekNiZ0NmeG51OFNRcm9vMW1ZNmpQ?=
 =?utf-8?B?Nmd5aHhvM3RBa1dyTHIxcXNKNlF0ZmwvOTk1MjJqaDQ1VVVsTkVaQVlqb28y?=
 =?utf-8?B?UjlaNk54QkIya05Gb1FWSks0a3NnSFhNWDhjeEQ3WE44d0FuZ1V3RWJqRW5G?=
 =?utf-8?B?a1ZKZmZVY0MxWTJxdWEraXQyTVhza0VEb2RvMkx5SWlCY3g2UTRPekRwbkQz?=
 =?utf-8?B?WmFXSlBJeXc0VkUvQzdodWtVNk12Y09oTCtuUWl1QTdxbWdTSldVWUU2b1A0?=
 =?utf-8?B?dnlHTmd0MDZrME9UL1JQNDJQbjd4QmtnQ0xyNXphemNVNzhlVTZxdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4msudbOqv4ssMXRKZlt9h7FwhoXRYNkVv6yfRzocnnV5/DDITgVbk8R7cF1sASPk05GXlWoSaZr4foYlatsI+2kDAibp77wz5Rj78/vwaVTaijaTKSxEO3VaZiC4GVTyyDhYGLukpzu4ocBTukJmiUUwZNJkXKhEvchmTl372jNIGanMmscV3sl+vmc0VM19FeYxIaWWYQH6rigOTTyNB9KlpJIUfIjUdWamE2FKczG7vZt4HS8xN8RgdcqOVZXKqLWC1cFbVr/YkpZXXUpWQxxDSmQo1+eixy1/TtPKPVCthrEHkByKKNwleqtpKvyEzxc7IL8tbjSmDOOzeHOHUdenZVUobOvcMNqZvbZcnE63XCOGCdnHXlLQwvJpNOXnMpWw83HjuPW34FwiDWUal88GiE5DQBtzwaLv5nPU17mPSqpCHES266jN5dKIGlmlOW11nXZEVzamw+vKKFIouOKK3D9Xlku9uicaJrtwYdqndkj2U50TBSUnR/JQ2gJFDcUCONXP0Vlsno8Mi3/YEpaCNPLrfvIg+Vh0CC2kED+XmtdMdSB5DSN1Vn9WzeEFYU5CDxC+kOl6ULeaqN0neemx1CoZbpZnM14HWDDKYWg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bb291d-4974-4992-22af-08de6789e373
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 03:18:26.0869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+y/BQO6Lc6VeYM+ruNSuQ8FeOKlKVvZtxnVhjkMHML0Om7Px1gcO/oMP2EwVyBshmZMJ1JJ3MlUWxn2LH8lrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602090025
X-Proofpoint-GUID: _AEvV-uM_cxq4CfBbOFVAPsA_JbxpV9g
X-Authority-Analysis: v=2.4 cv=FIsWBuos c=1 sm=1 tr=0 ts=69895207 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=usVUPduaKBOVpunCJtIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDAyNSBTYWx0ZWRfX3CLZzNX4Jyfm
 3Re6n9rBQuuMF0a0V8qU2ksRHGRGEko3lDYedN3FY+zP/r3189HJGul6Dd5gVDfLbuSmJKuNhVa
 0kz+O6MMkEXTIXH77TBBDf4CacxJLiWAqKKV8sVdmzVgZEzXNO32+N6J/rAl9ZAHj1QPSOOvq+0
 d+NF43zps20ylXT2/9MkJpvoo+PJuvXX/nfAGIymRfvZcUeSsDPAnsFxbF+Oy1iBI12EuXsSirJ
 IYVvzepas6yJYEXxglg4E8EzKrPDC5tJFIb9uKbX4p4gNv4CGgzJIFJ00GuWQTZpefLnHXKp0G9
 BGORDZzDOdPvttBqPt+xpdtyHWIqqo1dF2njTn7ovpTOyQIKekSy04RLNYXjhw+6iCV2XH3X4xt
 +UlDr9PmASv4UNpgIq198KR3rwiya4P7cKyqz/Yq9X0XWA3pw0G/WR1OVU8/FHlTJVIdvxROibZ
 r1Eq7TNmvnhoee/woZzwt/AjdzGAG2Wz+lBqcrwI=
X-Proofpoint-ORIG-GUID: _AEvV-uM_cxq4CfBbOFVAPsA_JbxpV9g
X-Stat-Signature: gstbzy9q7cgpj944y3omeqsszg356hxd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D23AFC0005
X-HE-Tag: 1770607122-174647
X-HE-Meta: U2FsdGVkX1+fFG+4dBxLWafAPzWWJOnONwMbr9xXgt2fhws3uG8FX9fN80tFToT3wm364xtmlKB+glDLOAJSAPAhVZSmtAqZrH3g6l/pPbepYwrhQZBk9j6sCE72iJyHhnagHa9LflHi9As97wKmUeXhpn8yK/psyV1AzElFNHZLJZ0Rqx8nY/q3oDDSj8IvKWCPla+MedoREQcLj87Dt/aYjuIpmgJzJXSifEy3anCAdBpYGWkeJGHeBTyoc1fI6r/5UeEpUlPBwp4fPVJmD5cewPejrFz6oYWlY3EblUsAc3ZgcD1iHjF4GuN9hwNGm+Rr+y7Vj6ID31KbhPIg4p2TIA5pzsyUPNY9zD3fKmeVp5c+UEGRDUGWdpIr+KdKa3m2mvJ6H/DN5iQigpCmacHWMy1rD/m2vwDb83OO9ffuQdD0l8WT7XZelTiUvowlbzCplgHim9JcHqhGJ9SPSFtk283/M4HBl5Nf8DFNR+HsiHZ5RyP4krw7YWSe2da5K74p/USzob4yBQsGwp6JUPOSEFu886/5LKKsNleutx7ivl4das7/YI+5ARlQ0iLhmtkJFnM+lMziXrB1wKLBR67+DvYmw1oQXJgBqGueN01qjF4lgiLnRyqqVjudpFpR08vR+kiUQ80rmJSCicC8GHlaqLScmegLTxC/vvMJ8MAhzB2EexUg+/bjkPkZmnoy+V3ppTE0dKA2sqwCkiMyrUKHbsaauiSmaE5gflhJbIBVjiH37Z8IH+B1FiWlvKKRigPhAf0f06K5RliPcr1xKA4eKwZQI/gozg+3aazxtGqQ8zgSTvM1bU+83S4AOk5XNLH+oDIIN6k1G2tHnrumW+uN9cVuJDsO2pVvOw3WIGGHyrjySjrfmWbS6S/fjSNnPzvs+wHlVgp/VtD3VeviVi5W7ERWrKeTl6ivl9j6cehjTz/mProzLu7ovm456nA6HI65Nra2zGMky5B5yPW
 16DXqpKi
 SMv6+ycp3eJAzJNXiQk9Zf50bQkhSDtCT1qFJJsGHSpTz7VEVtfNZMzkV+aNAliCWHWrLZoqrVIkxUKrriLpXvlGvFeXcmpBLL9TYk7SRXySUTunIdk1hMqbWGNPn+ZddLTFZc/dQ47XZrHCYjPPvGyx4BFDlRzaJYBKo3R+qP9+HmM6tXnckKdbAVDaNVvSs+xCZTuTq7nOv1KR1BmAq0UFawYBJ2FOVDfrVffrCAfLyziWmHdpULhq9yZtQ5b6XtFIKu6ZEBezW9MVUM68R1tjQadyC7r0QTMatIdOMtvh3e6KA6hiwj5OLQFwJq9Mhf+I3VhA8VPpYkay4S5XD2z1B1rtzGwGRoVy/+6UrKDwT3I34i7pJhZwYTL1OQX9yPKxzr70Bqh7+c2fcmePVrIwIcJPBO3VDYLlQh3EebdO7aKdS8iIBamrQsL+GE+56o2VH8vwwcjzPm9WRo3mAJEHX/CjnwRpfGgax3r/0Y3k4tbzBahjzyKYqW+EibNEib0U1Dha5TOj6tsWwofjhRnid7VuWoDU4L5lB32sm4/Ljit8UCDoXkiQBPKut6FhfAKUkYKWIX85EYjtkcckN+aW9uHfA4//PucK1LSzGeN9WMFd47JmR02Nh4jUM34i4JdjsnBBoczjzJIwZb3Z6DWn937XHtJXxfHHqOlALRs1CEziDa8gZ49B3IU6vg4OKvOhqgtsCd7H9F9qtj6i4KW0Bf1iMsWrIKeywQIe4rppKK+m/CuDIacC2tSY/y3IZIb+BnIBXwsdyr7SnfbkmJBDZa5AnEiRTenml9dzNwFvbjN65A2ONMLYLEjNiCSgsChBv9Chq0nsv0tN5jZQn3gr2UMJQGcHbAZZTMXBHp+D73Qg6lawM+cywMBg4GE5NVuE7UoAt1+dLmcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:19:01AM -0800, Alexei Starovoitov wrote:
> On Fri, Feb 6, 2026 at 10:10 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > On 2/6/26 18:13, Harry Yoo wrote:
> > > Lockdep complains when get_from_any_partial() is called in an NMI
> > > context, because current->mems_allowed_seq is seqcount_spinlock_t and
> > > not NMI-safe:
> > >
> > >   ================================
> > >   WARNING: inconsistent lock state
> > >   6.19.0-rc5-kfree-rcu+ #315 Tainted: G                 N
> > >   --------------------------------
> > >   inconsistent {INITIAL USE} -> {IN-NMI} usage.
> > >   kunit_try_catch/9989 [HC1[1]:SC0[0]:HE0:SE1] takes:
> > >   ffff889085799820 (&____s->seqcount#3){.-.-}-{0:0}, at: ___slab_alloc+0x58f/0xc00
> > >   {INITIAL USE} state was registered at:
> > >     lock_acquire+0x185/0x320
> > >     kernel_init_freeable+0x391/0x1150
> > >     kernel_init+0x1f/0x220
> > >     ret_from_fork+0x736/0x8f0
> > >     ret_from_fork_asm+0x1a/0x30
> > >   irq event stamp: 56
> > >   hardirqs last  enabled at (55): [<ffffffff850a68d7>] _raw_spin_unlock_irq+0x27/0x70
> > >   hardirqs last disabled at (56): [<ffffffff850858ca>] __schedule+0x2a8a/0x6630
> > >   softirqs last  enabled at (0): [<ffffffff81536711>] copy_process+0x1dc1/0x6a10
> > >   softirqs last disabled at (0): [<0000000000000000>] 0x0
> > >
> > >   other info that might help us debug this:
> > >    Possible unsafe locking scenario:
> > >
> > >          CPU0
> > >          ----
> > >     lock(&____s->seqcount#3);
> > >     <Interrupt>
> > >       lock(&____s->seqcount#3);
> > >
> > >    *** DEADLOCK ***
> > >
> > > According to Documentation/locking/seqlock.rst, seqcount_t is not
> > > NMI-safe and seqcount_latch_t should be used when read path can interrupt
> > > the write-side critical section. In this case, return NULL and fall back
> > > to slab allocation if !allow_spin.
> > >
> > > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  mm/slub.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 102fb47ae013..d46464654c15 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -3789,6 +3789,14 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
> > >       enum zone_type highest_zoneidx = gfp_zone(pc->flags);
> > >       unsigned int cpuset_mems_cookie;
> > >
> > > +     /*
> > > +      * read_mems_allow_begin() accesses current->mems_allowed_seq,
> > > +      * a seqcount_spinlock_t that is not NMI-safe. Skip allocation
> > > +      * when GFP flags indicate spinning is not allowed.
> > > +      */
> > > +     if (!gfpflags_allow_spinning(pc->flags))
> > > +             return NULL;
> >
> > I think it would be less restrictive to just continue,

Ack.

> > but skip the
> > read_mems_allowed_retry() part in the do-while loop, so just make it one
> > iteration for !allow_spin.

Makes sense.

> > If lockdep doesn't like even the
> > read_mems_allowed_begin() (not clear to me), skip it too?

Yes, lockdep doesn't like read_mems_allowed_begin(), and thus
we should skip both.

> 
> +1
> Just unconditional return NULL seems too restrictive.

Ack.

I'll do something like this:

diff --git a/mm/slub.c b/mm/slub.c
index 102fb47ae013..cc686ab929fe 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3788,6 +3788,7 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 	struct zone *zone;
 	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
 	unsigned int cpuset_mems_cookie;
+	bool allow_spin = gfpflags_allow_spinning(pc->flags);

 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -3812,7 +3813,15 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 		return NULL;

 	do {
-		cpuset_mems_cookie = read_mems_allowed_begin();
+		/*
+		 * read_mems_allow_begin() accesses current->mems_allowed_seq,
+		 * a seqcount_spinlock_t that is not NMI-safe. Do not access
+		 * current->mems_allowed_seq and avoid retry when GFP flags
+		 * indicate spinning is not allowed.
+		 */
+		if (allow_spin)
+			cpuset_mems_cookie = read_mems_allowed_begin();
+
 		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
 		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
 			struct kmem_cache_node *n;
@@ -3836,7 +3845,7 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 				}
 			}
 		}
-	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+	} while (allow_spin && read_mems_allowed_retry(cpuset_mems_cookie));
 #endif	/* CONFIG_NUMA */
 	return NULL;
 }


-- 
Cheers,
Harry / Hyeonggon

