Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B285AD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A33E6B008A; Mon,  1 Dec 2025 05:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052556B0093; Mon,  1 Dec 2025 05:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EA96B0095; Mon,  1 Dec 2025 05:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB6036B008A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:39:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFEED1DDF9C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:39:23 +0000 (UTC)
X-FDA: 84170555406.13.3F8B11C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32ACC10000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:39:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aLlt9kNg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IoKyrgb+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764585560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1B87j9KzkAG7QWTeJrXKo+bPytxK9/625ZZGdMVf44=;
	b=l0qzgIAvc/YAR6D1Rzt1YRC+NGogiNI0D/C9Hpgvy0Ut3O2BIT6yLZLIOo81Y1hJo7+EQ5
	HxadSXp+VPlfxmQi+5efp7NtDtEzkpOK5SQDnJ2J/2CJD+F/SnZkARRMhNOy29Xxn4WHlg
	PssBwvMM1p49i2U/Pn9tDPPYJktBFV8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764585560; a=rsa-sha256;
	cv=pass;
	b=zYujdgVr9EEvwMAlDxUCHpk2+sRRvaDHMe2AbPINl7Bu0e8CjWSZy3KYfkK8YXTgWjLjvD
	DKGNsiXTvE/ti99b8yQKUfx2g2spfkVdb6ZkyBP/TrPCVuxK8XIR5YwBRk9FFobzElI+Jq
	r3zkD/729JzrCttj8ZYcgM2uUA9qbLk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aLlt9kNg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IoKyrgb+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B18rvrP1542892;
	Mon, 1 Dec 2025 10:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=K1B87j9KzkAG7QWTeJrXKo+bPytxK9/625ZZGdMVf44=; b=
	aLlt9kNg8PkRvtj3QYDBTIdv0CndIyv2Nqh9AOiZhEd3/RjU2asZbK7j5NTlZP8W
	cnOdZ66ZrnuR5gH1SBcPiICmcOILx0SWsO0nEBFbxTln6V7kneeywpOskdGctNyN
	EPucsLUsl9v3RefdWzfpXHMlrcnedbT7MjS9lxfbwie+Fhs9+DZ/FCUgHCvMgvv2
	mxRe1q0+dubMaIw02WgmpFHLiAKtxbjShYcpp1IomuQ3N/KxKMsdrKphYuqdQkzX
	u0muhlgCI+U8YNqAwk/wcLDXAJgADyFqulRUjd9Dq6uikT9r/gfQNOQLZXQER5nh
	kP2bHtUmM1xAsB9bwHainw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7wn85vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 10:39:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B19jCsO017713;
	Mon, 1 Dec 2025 10:39:10 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9hunse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 10:39:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHWHls7ll0wGDvsBTc+okElPuJn6ohORVBS08PmLdBM8HTipjpqlmhMIK8v+Md0aewiDr7p5htyoKKIGGnXpB9I4eGhdNHMl+3bn1zDDyoAvi+PSrTFJyu3G8oe/qwixbpDJ9A7UTdbGkSNaey8E+GaI4GNMPq+jCQ3rbyPqgriOdCHn02nwtSir/4ncq0+1GoM9OjG7iYIBgxFE5/RXdUZhvC9UeAgXOppZggkU2Shd9TwdfiLIOUZEJcLInNDTuO+SfLRmZMKY/OVbWbiXH7K934UQhWwetsFp7GKNEQ2mVDoVjXZ6gqX3GraHU//gzO6vkXfYW/Da7DSrcaSvBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1B87j9KzkAG7QWTeJrXKo+bPytxK9/625ZZGdMVf44=;
 b=aYtoi22BkRGDvyVinHTlVImq1D6GfXpWJr3yivFZYzK39klOqSdHlrsha2mLFrpwDbZD08NHqMwv/aVdHXiEVjy9X6z+gcrJAoZLV8wj1i8y6uPfHwQo9f0JNU8kA5+fUZm8/Ld4P9VAUpux/NOET4vWNoA5n0KdoYAhhKnwDxZK5BEHnrbQnMfyE5grm+Kx6GphazdVBDOQ9CMUT+dmJVsjBysyO62es1f97qZyU6BxmWMckJoOUdjlXW/7GNH3BURH6yMxPurGoqrGIGVenZLl7wCJAEBBJB7GfB8ZaTqjoWb9NcvVT9MlRHm/JAzQmdZxBECgBfdw8f9PWtYaBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1B87j9KzkAG7QWTeJrXKo+bPytxK9/625ZZGdMVf44=;
 b=IoKyrgb++s7Z2pQsPxq4+APH5w8ejgqzEupNcVi1GwtzQEtxJaFHlFCBICdcdEFhV609BmN4UFYvxBNGDu6zMuTKyJme4D6O7ydmTtrfnm2H29DKqwCWWcLDljPK9IOxHDuGBcm4SrR8WCf5LIqW0M0RQ38Tdu6WXlCZCx79XVY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 10:39:07 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 10:39:07 +0000
Date: Mon, 1 Dec 2025 19:38:55 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
Message-ID: <aS1wPxSdd-WcU__K@hyeyoo>
References: <20251127233635.4170047-1-krisman@suse.de>
 <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
X-ClientProxiedBy: SL2PR04CA0019.apcprd04.prod.outlook.com
 (2603:1096:100:2d::31) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 252d2a6d-fdd8-4a4b-7adb-08de30c5da89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUsyT3Z0d0V1Vmg2aDdBbEg3K3VRNzBCcG1RdVB2WnpPR28vZGp3WGVjTVhB?=
 =?utf-8?B?L1RCVkpnditFd2Y3RWc1WXd1SUxYZFBEQ0Nyc2REQmQ1UTJGNGg1N2QvZmk5?=
 =?utf-8?B?ZXJiZGd6YWxKS0Zud3JaZHBld0czV1VZTjFnbzcvVFBpQjcwTGNhM0JITncx?=
 =?utf-8?B?R1JtT1JoVWxYdU03dFV5S0RGaDJhemVDQnVtWTdVYi8xY2ZaYTRsdzdtaTZJ?=
 =?utf-8?B?bGxpd3hWd2g4QmhMK3o2TnV5RmZWQUl3azh0WEg4MUtWWGJXRVRSOHZSM0RI?=
 =?utf-8?B?aGE0VFJ6cmtFSU10N0k2SmZ1ek1Kc3JqQitwNTZ1SzJtVEM5OEsrbjVrYi9r?=
 =?utf-8?B?OWNWaUVTNjJYSE0rZVZZVEFoYVVFZHVheUFvbWprZy8vSWJsSmFZU2tVb1Fi?=
 =?utf-8?B?Z0p6MmgzSzVyMEJoeUlLWFova0NOQ2xGdi80SlhPUXJTeUJMM1ZETUJaRkpp?=
 =?utf-8?B?OGkrQjMybWZBdmpuZEIreFl6czFWNDZSVmFkM0xVZnI2aUZKVFpsSU9HL3BJ?=
 =?utf-8?B?dkFrdDZnSHc5VnBkS25YNUZaSzlsdiszQ21UUnlWaSsxbEdaR1h5Y2xFQ0N0?=
 =?utf-8?B?dU5YejdLTGFHZDFHbTJKcjFNQ1ZmSGJHM1F5SkdNQnRIa1dGa3Z1UW5JR3pu?=
 =?utf-8?B?SDg4elUwMHg2bkppNkM4ODVMSmFZUmFkL2RKWjF6TzFJaUNaSlI4SU0vaG14?=
 =?utf-8?B?NndDQlpaWjBTYlRkWFJuejBVY2YrNm5xRTZFQXhqUkppQ1ZIbEszSWdMTjIr?=
 =?utf-8?B?UkhsWFZveVB0V3MvM3dVRUVRV21CeVppNEhtcHBLRDMvZWNYcFpWM1pWYkhY?=
 =?utf-8?B?aC9PODV6MFgrS095WDRmRjMrYlgxV3VIVlYwMW9NMDVnclowOVk3TEszam11?=
 =?utf-8?B?TmJmWDRzclEyVmF6LzBVWEVzK1hBUG9KT3ZWR1FMalBmQU02TFhjbVcxYzRW?=
 =?utf-8?B?TUxuYnJQVjd4UTlHWnJEaStPM2o2QnIySUJlMWdSZFY2dXJ4ODQwdUZhYUZI?=
 =?utf-8?B?d01mVmZNKzhhQUdsemZxZFlCSlVsaTNSNW5yRXBCNkc4RkdqUE1sT2xpMFZI?=
 =?utf-8?B?OUs1UjNaNzFtMERMTm5JMTh6ZmdIMTNHUXQ1cXVJWnN5djlGOUN2UGo1R29i?=
 =?utf-8?B?NFRFaW9FT2lXT1pPUW5CMTJwUDdlMjE3a1JFYUh2UFcvKzBmTm9ZcGRGY1Jr?=
 =?utf-8?B?djZGaWJraWJvb1pjVTlaSHFQODZIWVlwTVBDd01XZ3BrUEx5WkEvUXhSWitw?=
 =?utf-8?B?bmpvamtkbXlDLzJ5V20wWmRVbDAxVXBmZGhMSkMvb3VEUGs4ZWhvd1FRTnZr?=
 =?utf-8?B?UE8zZnJpNkc1TzBNbTNRc2NMVzdNYmRpbTU3VmdsNTB4Y3FCaFBDZlV0N1kr?=
 =?utf-8?B?WHIwNjkxRDNla04rTW9jM1Z5OWszRXBIcWVSZDVtMXdxV21FcStpZi9lTGRr?=
 =?utf-8?B?ZWE2aWtsVnlSOVBUTEdEMDNiOEswa1daUkY2US9LcEFMdzI4TmJncUE2eGJE?=
 =?utf-8?B?OGl1MTdWMERJNnMvRGlHZ0VNVlNZU3NXbVBNNUlLejFvdklHUkl4amlJWXBT?=
 =?utf-8?B?TEthUGtvM096cUVIOHZFNXFkeHkzazlyek1NUlRKVFNGejRVSklDaWpucWhO?=
 =?utf-8?B?cSsyamo2Q0pYS1o0RkRwTmh3QTJ4SGNOdGdaQ29PdUs3WTNmU3hUdUN4MXgx?=
 =?utf-8?B?dHdpR3RzcktIZjJUeUYzRU0wcHk5Z2VQVGRieEh6ZjdmUnVBUVpzbHFjajVW?=
 =?utf-8?B?c1ZyVjVwaURmTUIxaU1pS3B0ZGpCRmFSMUZCZTdHUlRqZUpmNVBwbjIzcUlt?=
 =?utf-8?B?Yll2M0dFMFUwNGpOQkJwcGpJcWJoY0x2YWdTVkVleHhlaDdnMk43Sy94S2FL?=
 =?utf-8?B?eVR0eUpRN0lDRytVbU5pdjQ2OHVBME10VHl4MHNBc3BpK3pncktqazZ2REN6?=
 =?utf-8?B?eVZlbUttRkhTa3l5TTRXOGhxbW5nUW8raEt4alpmRlhnU0xGOGlkZGs1Tnpk?=
 =?utf-8?B?bGtUakg0Y21BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVVoSFJQdEpTWjVoVzZ2OUNkVTlQRXJ0RXd2aHNONE1sbmNGSGNDcDRXMHN2?=
 =?utf-8?B?QkNDcUdGRHRrb2tMV054cncxU1psM2dtZjcwWlFld2ZoUVc1RzlaSzlpWmdt?=
 =?utf-8?B?d1FIOFl1Tk4rWnNmenRydDFSSmhaYzBidkhqbDJ1R3NXVnRsM1pBSXJtOTBs?=
 =?utf-8?B?U3ZvRFhoYWdqODhxdVp5RXhodzRqY1NVZnJ5SXhKVndYWWNRbXA5NENOenR0?=
 =?utf-8?B?Wlg5eUpzTk1ibWpZcDR4U3dzQk55aStIQ0JUMHpISUIySmJYTkxRV1BSemlE?=
 =?utf-8?B?OG1zWlBJRUl6UE5lMWhqN002RlNBNm05UGJQcWVCU3VZUlIrQ3F6bmZ2bmdh?=
 =?utf-8?B?MUFEc2tMbEZ4ZTNRdC9sckZ3SWdBWmRQQVd3NWNtZThqRlhSdHRzYSs3U0RB?=
 =?utf-8?B?cTNDZEhtN2RPNUE0U2xDU20yTElwa2xydXZhTFA0ZUE5b3Baa3RwRDNMQ0tW?=
 =?utf-8?B?blhrSWZCYisyN0o4U0NicjF3ckhYSkZSSzZBSm5lbHowMnRlOTJLMnd1Q0xm?=
 =?utf-8?B?c0RKSTQwYlN6Kzd1ZVh5VDA4OTZnRURycTd6dTVxMGV0VVFLbUFudTRiTXh5?=
 =?utf-8?B?MGZtZjBYWGViNDRyeW9MNFBDaFVGak5jdjRPbWFXOXZiRzJMbE1PWUtjaWZi?=
 =?utf-8?B?aWpBUTQ4Ny8zTlZzRURHOGR3OHhzdnVOdTI1aVRuTUpXYTlMSEZnNzVDNStC?=
 =?utf-8?B?WlpOMWxUaWpkZVhlLzdUTUcydE5LdTkzRFp2alg3aktUZjhCdkVPK2dsOEFk?=
 =?utf-8?B?WUNKUmFTSnZQdEphUnVVb3p1YWdFY1huL1hmR3N0Z2Rlc3N2cGZ3MTZDQWc1?=
 =?utf-8?B?cjhyZ2h0U24rUzhpWjVPeFVUZ1dhZUVBYzhRZ2dyMWozSmxQQnpUNGRHdlBJ?=
 =?utf-8?B?cVN6RTlwUU1WSkJwemc0UlNJOUVISU55NlZlM0h5dE9sTnBuWWdxb2E5WjMw?=
 =?utf-8?B?eHJIMkRwSGFUYnFKbFZjNmJiY1hPcmJESUJ4bmVTUWNEK0YyYUE0UFNNL21H?=
 =?utf-8?B?SnV1cGJtV1FGWmFKZ3JFdWllNlhqdDhvcnBtNitGQ0dRN1N1T2RLdFlLbjRY?=
 =?utf-8?B?d2NMWmtYR1k2ci9sZU1Scm5OcUZCZUdxMG1URlhLQ0g4Ti96KzYxdDE3MFlC?=
 =?utf-8?B?LzhtNzFIZEEwNVZ1bGE0UHdNakIrSUROWFJkb052QWJuNUkwaCs1RTNNOGpB?=
 =?utf-8?B?cHkrazROZHVBWjNPcUphd3Z2YjRXamFMdjZpeWUwSlJQOC9OaWVTQWgrNjFr?=
 =?utf-8?B?OEM0STRwRWF1T2NoTTZXbzZqdS9ML21yZ0t6b1hSRlpKOEF4SWpZQzdwMDZ1?=
 =?utf-8?B?OEJwYnZsR1RWdDZ5M2tCZFhZUGlCOHZOS05CL1plbWlITWI4MjlySmhIVWZZ?=
 =?utf-8?B?YjJ2MWIvTzdQMnk4bFVHNE5OSjVnWkZGZS9ZcExtL0k3Q3YxcDdNbUtvZG1s?=
 =?utf-8?B?RXJHN2FDS2gvcm9CMndIcU8wTWw2QXJTOUUzVEo4UXJuOCtQMXV1U3VXUS9U?=
 =?utf-8?B?QXVNRVBrUWVhV3F1eENRUTBwcW1RM1BhRmw1NkZ5WHpYYWpuUmxaaE1YSVpD?=
 =?utf-8?B?SjBMcTZlOGJJWEdRNXM5azhYbVRCR3c4dDZZMUdFU2JCODdHbXFUM1Nxb3pn?=
 =?utf-8?B?aEFBMDR2M3kyMXJ1czBMQmJNNExmZmZJMmJMSGFiUStNcVhVaWQwaVVQbVE1?=
 =?utf-8?B?VmhaTUNjVjhtZnBRT1RZMDF4bzI5d05nd3ZOdmlBWERCSzYrcHh0YVUzVzlH?=
 =?utf-8?B?Uk5DZnNzMGY2UWlTK0o2V1h2TlpyS1RKOWswVmo3TW56VnQ4TWpMUHB0cFd6?=
 =?utf-8?B?UnI0c1J0UHhMb3VmTGpqbGY1U0JPaVVrNk15clU0d2FxY0VjTnBRb2FPMGY0?=
 =?utf-8?B?NTgveXQrKzc5RGVKaEU4TDBKYmNEcXRJL0xsaUlURXJsbm9lTTBzNVVueXhr?=
 =?utf-8?B?d1ErZnZHc3IwMXRsdU9WcnBkNmZkaWFmdlljbWg2K3VlZ09rcGx0S3k4cy9M?=
 =?utf-8?B?WU1Jd0FiSm9MTWRTb0lIdzgybWpqNHZQWjVFQ2FrQklEbDJqRTRjNm1oK3Zw?=
 =?utf-8?B?ZjJMRVE1aTlqcE1rekZlUjB5Q0pBVkgzN2VKRUdnbHpUbklSSG83SmQ2SUNw?=
 =?utf-8?Q?MqiqCwd4LmOej5oQXwG0oj8oL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u6i+fBgUPU3jslCh2GfeHem6fOEsawENgMe014KWdg8WpWKJ9lpJR/uD7BRMue65In1Ih1nNZD/Trog7w3fFC9PBjH8g9BDJCtEqvuJOGviAhaEujSrlM7Tzw7zUr2yfOYvxxo07T5whYhsYNQs/AzILSYRFCWFv+6iSVziQXd5MRbRbMDnOX51AGMuknkShp0r+3u9WxDXtTRulNsctIzPi6WQ8d3lSE53ljzLS9BrkDQIyDu3COBIO+hHjFLVjELWCs536y36YshZ4kvkLKPTH5d9EtKnuIEOL9x9jQK3k4SnfybDKqa68OmLVVYuHFDSb1pKWakjoTVu7PscKq6kosPkUoFaFJGZ8Mg5mKnlNJwc/Z0cFkYIk13lplKTVPYCpQj03xh739Tb5ejIsKntmkjJyuEqKk5nLq6XOlsDDagtAcYrZ8WQ1QzAbyyNq4DkjqZaDVufn4vbDirlwAamrUPO2oI5EtLPvvEq10v+B75npbId1y0Ud7bFbDn8AnGSdYRLjghw8pGCptbZSRMN34LXGaMdGB5ZR1MUVQPMzyZ+MA3pbXJQLEo4kh4Vh0DckzgumQpFeuH/mJ9YNHfrMIq/pJ5Kn+rCsVCYbpUs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252d2a6d-fdd8-4a4b-7adb-08de30c5da89
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 10:39:06.9652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /B9B+VnG2kk8SyTOzBevGNPCboLccsrkc8PwHnqUGwdqrZERpDoor53u6cqj40vh1a1PfiFOyGwqNNymgSQfWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010086
X-Proofpoint-GUID: lSK2Svr_cr_3uCqACiaO1Kom7fY5EF3Z
X-Proofpoint-ORIG-GUID: lSK2Svr_cr_3uCqACiaO1Kom7fY5EF3Z
X-Authority-Analysis: v=2.4 cv=SbX6t/Ru c=1 sm=1 tr=0 ts=692d704f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=p0WdMEafAAAA:8 a=2-NhFculrKlzvXbWJRoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDA4NiBTYWx0ZWRfX43pr3IPgEACw
 210F0xrsMHaNBobYr99ubKm0+PH6F4aDDx/Kk67DAQ+G7wqO9iMpZk9hsidrUWGapOxNc0qvWHA
 Tq6vEAUDZ5MaxvxE1WVI311VzJH3tAzC/lANuS+AGtLn00UHtC7gGU+Xn79llzBtVhZQOwPsO15
 qxUrVUO4bGE7REUqeKo0L9WuB3P57A1T4ARFY12/7fuhsFTHltAGfA9WVJfT4eJUl68YFM5HyyN
 LR/wiDlyetrL4RD3tExw4dzYwSVmFYtHg0AfA1H0dQMLlSeVcgXMEJIW1PwpyhE7uRLWKp/+VZ2
 P+vgnbdtyPv+1Ce4MgZPmc2DcQFq0ocPKLsqLgSzGoeoOf9rb4ps5tSKC9iSv9n1znYNI9mEZD+
 XRQNO9dmTopDo1BrhuKW+2zft1Y/MprfvAji5Sw6twf1PuCfZPk=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32ACC10000A
X-Stat-Signature: taoapk3hergjpnoy35kiwcg88qzp1xs6
X-Rspam-User: 
X-HE-Tag: 1764585559-739690
X-HE-Meta: U2FsdGVkX1/WSHYdFWxNlKXQ+nh3dL9TaLAVYjecO1PESfvVknUix3dKTmLRwxUi5WvWm39Pol6eopShvARQWk1bHM1hIvbTjOhS0ymGpeZyd7G7b3ylOpb4zSJAWh01cHqPRCCCiGEUv4/ZTqZll04hTE8vynXuAdvUVjihDN4Mynh8RSzqtcz/6FWWMr8anhLiql5pzOfW020O7ddzl1siFKh7hKv3jLeNrAxXBnbBsw/SBmazJbQR5+BdeVw9WjI9LjU8xyMpSM2VCJU69eVfJKYbX8+Jr/ykf/O3AIMwT6z3FX16DJB5QnC93p9W09aYCkCkFcO9hkwUdInlaR6mluRzy2g9VzulXCcU5lREKQcBrPvve3ietRZ7e3CmxovxvNsSBK/DSu/b5WHU8uXsF5SZRfUO9UvT8zcsb+xzLG7V6uxxeUvacy3Se24TrMuYvn/XwtIV5nb0hXPgJtHvDOLiv7YocIytqsul13Cu+yVzQLYeCrGyHgse9utfCrsz0aQsqGYWgbty0Q6DdBNlk7HyjnLxDQuy6lwzKDKXLb02asJnwB8k7ynuP7qCervBStAm6OnD57eOBnnO7tC+hT8UQtduZxi9y2C5r3vLwxeo9NFQRosUPjnYmhk3VFTYM5hpUS7N56X8PB5QlaT9IrLT/12OhPNPA69hYkmxEzUTwYQ0ufgRoiTVG8D8+MW5+z1oZuoHJqutjDv6TmMg5LQBrGiUeIQDE07EesNbnfWifA4yP7zqN0EPCBxSISqJGRed0428jL3rP3IWkDFvYowfCEvz3wXC/dqKn8fkWk/QXJagbknhn00LbiMeQxKmu+XBD0ht7HUkzIzF5OjJuBks9c5F8u/Kf/SoZBcxQMC/D5M93MAnjBZKMaA/VgeDHAA0Hv5o9t6g9BoAO2YmsYgJhCBhAacsXyb30nnC93LX7OswMUfe3ciavDtzjxfl1i7azyAC91MvYyk
 OuYOadbw
 dt75416zJmmm0BEXA1D2b3fw8Oa0BKi1CcGHPEcNDUatPbK3O3p0Ntih6i2CANyhgRiaumWLazygOEzX3X3e9EHg/34G/NruK37ptZI3JOXTNS0e/dzNV+GNilvRhmgLaX69Gs7UcNVdepLU+QyE4jB58NMaVcM7y2DvzA/Gcw9bw7vb0gyQOvAH/u71YKUkIersS8I1jMZ55c7WN3OTIb4GQG9jfiuzUr3evgr38iIkrfKffzdA+2jMXp0PNvZgNL/9tmH57OzSX7g9w7c1BPECDf2hCuS+CtA+SlVpmFwcXPEOxmvjWUS2yoEeSQLC6yaDnO67H03841mTVWuCYgs8uwr8PIuBD0aTf3ZNZ8CQ4BkIORnFxZtBUtAc+z0RTtqnegas/1tNbWlkzuXsundaXuyIOgmFfoqFZQ0y4Qh5laqWr5Z1GuHulPWWJR5wLQW5nbG26d12MD33EFjjh+h5NeO+VYPjNI6O2h1SHORAmoO/axoDSffJWiXWtQpYz3H/5aDOEGCo3wjGB+RMuR1WbktZGWMWXJjXj0MZtUvFuQEqOUcpV8AI0dfR5A/0yeiLnXAcokdXj5YNgGQZY1L2AUZ9yqPTQw1Hm0JRvYG3Any+F0XNtrLRwhZQacyuTsyDT2fjARjfvogWRWnW9RXX3bRAi5otynU1Pp7DkRULyeabvYLTICTuRD4fIovzh8o2Gy4vgNjQg4K0ak2vOzeIFNYQerIwjGcqFtxILUMbIiQmv2IfjPt0C4NjxpYHffMkW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 06:57:21AM +0100, Mateusz Guzik wrote:
> On Fri, Nov 28, 2025 at 9:10 PM Jan Kara <jack@suse.cz> wrote:
> > On Fri 28-11-25 08:30:08, Mathieu Desnoyers wrote:
> > > What would really reduce memory allocation overhead on fork
> > > is to move all those fields into a top level
> > > "struct mm_percpu_struct" as a first step. This would
> > > merge 3 per-cpu allocations into one when forking a new
> > > task.
> > >
> > > Then the second step is to create a mm_percpu_struct
> > > cache to bypass the per-cpu allocator.
> > >
> > > I suspect that by doing just that we'd get most of the
> > > performance benefits provided by the single-threaded special-case
> > > proposed here.
> >
> > I don't think so. Because in the profiles I have been doing for these
> > loads the biggest cost wasn't actually the per-cpu allocation itself but
> > the cost of zeroing the allocated counter for many CPUs (and then the
> > counter summarization on exit) and you're not going to get rid of that with
> > just reshuffling per-cpu fields and adding slab allocator in front.
> >
> 
> The entire ordeal has been discussed several times already. I'm rather
> disappointed there is a new patchset posted which does not address any
> of it and goes straight to special-casing single-threaded operation.
> 
> The major claims (by me anyway) are:
> 1. single-threaded operation for fork + exec suffers avoidable
> overhead even without the rss counter problem, which are tractable
> with the same kind of thing which would sort out the multi-threaded
> problem
> 2. unfortunately there is an increasing number of multi-threaded (and
> often short lived) processes (example: lld, the linker form the llvm
> project; more broadly plenty of things Rust where people think
> threading == performance)
> 
> Bottom line is, solutions like the one proposed in the patchset are at
> best a stopgap and even they leave performance on the table for the
> case they are optimizing for.
> 
> The pragmatic way forward (as I see it anyway) is to fix up the
> multi-threaded thing and see if trying to special case for
> single-threaded case is justifiable afterwards.
> 
> Given that the current patchset has to resort to atomics in certain
> cases, there is some error-pronnes and runtime overhead associated
> with it going beyond merely checking if the process is
> single-threaded, which puts an additional question mark on it.
> 
> Now to business:
> You mentioned the rss loops are a problem. I agree, but they can be
> largely damage-controlled. More importantly there are 2 loops of the
> sort already happening even with the patchset at hand.
> 
> mm_alloc_cid() results in one loop in the percpu allocator to zero out
> the area, then mm_init_cid() performs the following:
>         for_each_possible_cpu(i) {
>                 struct mm_cid *pcpu_cid = per_cpu_ptr(mm->pcpu_cid, i);
> 
>                 pcpu_cid->cid = MM_CID_UNSET;
>                 pcpu_cid->recent_cid = MM_CID_UNSET;
>                 pcpu_cid->time = 0;
>         }
> 
> There is no way this is not visible already on 256 threads.
> 
> Preferably some magic would be done to init this on first use on given
> CPU.There is some bitmap tracking CPU presence, maybe this can be
> tackled on top of it. But for the sake of argument let's say that's
> too expensive or perhaps not feasible. Even then, the walk can be done
> *once* by telling the percpu allocator to refrain from zeroing memory.
> 
> Which brings me to rss counters. In the current kernel that's
> *another* loop over everything to zero it out. But it does not have to
> be that way. Suppose bitmap shenanigans mentioned above are no-go for
> these as well.
> 
> So instead the code could reach out to the percpu allocator to
> allocate memory for both cid and rss (as mentined by Mathieu), but
> have it returned uninitialized and loop over it once sorting out both
> cid and rss in the same body. This should be drastically faster than
> the current code.
> 
> But one may observe it is an invariant the values sum up to 0 on process exit.
> 
> So if one was to make sure the first time this is handed out by the
> percpu allocator the values are all 0s and then cache the area
> somewhere for future allocs/frees of mm, there would be no need to do
> the zeroing on alloc.

That's what slab constructor is for!

> On the free side summing up rss counters in check_mm() is only there
> for debugging purposes. Suppose it is useful enough that it needs to
> stay. Even then, as implemented right now, this is just slow for no
> reason:
> 
>         for (i = 0; i < NR_MM_COUNTERS; i++) {
>                 long x = percpu_counter_sum(&mm->rss_stat[i]);
> [snip]
>         }
> 
> That's *four* loops with extra overhead of irq-trips for every single
> one. This can be patched up to only do one loop, possibly even with
> irqs enabled the entire time.
> 
> Doing the loop is still slower than not doing it, but his may be just
> fast enough to obsolete the ideas like in the proposed patchset.
> 
> While per-cpu level caching for all possible allocations seems like
> the easiest way out, it in fact does *NOT* fully solve problem -- you
> are still going to globally serialize in lru_gen_add_mm() (and the del
> part), pgd_alloc() and other places.
> 
> Or to put it differently, per-cpu caching of mm_struct itself makes no
> sense in the current kernel (with the patchset or not) because on the
> way to finish the alloc or free you are going to globally serialize
> several times and *that* is the issue to fix in the long run. You can
> make the problematic locks fine-grained (and consequently alleviate
> the scalability aspect), but you are still going to suffer the
> overhead of taking them.
> 
> As far as I'm concerned the real long term solution(tm) would make the
> cached mm's retain the expensive to sort out state -- list presence,
> percpu memory and whatever else.
> 
> To that end I see 2 feasible approaches:
> 1. a dedicated allocator with coarse granularity
> 
> Instead of per-cpu, you could have an instance for every n threads
> (let's say 8 or whatever). this would pose a tradeoff between total
> memory usage and scalability outside of a microbenchmark setting. you
> are still going to serialize in some cases, but only once on alloc and
> once on free, not several times and you are still cheaper
> single-threaded. This is faster all around.
> 
> 2. dtor support in the slub allocator
> 
> ctor does the hard work and dtor undoes it. There is an unfinished
> patchset by Harry which implements the idea[1].

Apologies for not reposting it for a while. I have limited capacity to push
this forward right now, but FYI... I just pushed slab-destructor-rfc-v2r2-wip
branch after rebasing it onto the latest slab/for-next.

https://gitlab.com/hyeyoo/linux/-/commits/slab-destructor-rfc-v2r2-wip?ref_type=heads

My review on the version is limited, but did a little bit of testing.

> There is a serious concern about deadlock potential stemming from
> running arbitrary dtor code during memory reclaim. I already described
> elsewhere how with a little bit of discipline supported by lockdep
> this is a non-issue (tl;dr add spinlocks marked as "leaf" (you can't
> take any locks if you hold them and you have to disable interrupts) +
> mark dtors as only allowed to hold a leaf spinlock et voila, code
> guaranteed to not deadlock). But then all code trying to cache its
> state in to be undone with dtor has to be patched to facilitate it.
> Again bugs in the area sorted out by lockdep.
> 
> The good news is that folks were apparently open to punting reclaim of
> such memory into a workqueue, which completely alleviates that concern
> anyway.

I took the good news and switched to using workqueue to reclaim slabs
(for caches with dtor) in v2.

> So happens if fork + exit is involved there are numerous other
> bottlenecks which overshadow the above, but that's a rant for another
> day. Here we can pretend for a minute they are solved.
> 
> [1] https://gitlab.com/hyeyoo/linux/-/commits/slab-destructor-rfc-v2-wip?ref_type=heads

-- 
Cheers,
Harry / Hyeonggon

