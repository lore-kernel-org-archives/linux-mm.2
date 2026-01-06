Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6284FCDC19B
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7EB6B0005; Tue,  6 Jan 2026 08:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0276B008A; Tue,  6 Jan 2026 08:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D036B0093; Tue,  6 Jan 2026 08:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB0E6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:17:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 236A5592C2
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:17:25 +0000 (UTC)
X-FDA: 84301590450.27.69824C1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8F1D58000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:17:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kWWLa4P/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B8pFc3UE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767705441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxdg96nQeSV0xjCWyaP8eGCF0VT+md1l/OIaK+Jsnvo=;
	b=QfQ4cTALcEN4uz8Z2ddzS41B7ftbpFA/XaZpL36wLoeS9JB6BJ7JFpIuznpI+oojCbVj4T
	T5Lij5lkaSLrocD3R6LyCVwW9nANDreBf34hnFeugGUEwRuhvB+TtTz1bNWhQ42B2M35zw
	aAclH/QvlnTbZm2KFbhROc1AexiEaPg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767705441; a=rsa-sha256;
	cv=pass;
	b=ppXOa9gLoaMiOEuQA7FIwlxzAHPpylvn+tCkMuqLSfc52HL0OJ60NrAhQyVCkxcyRU1Zsw
	pgalCUGpY6wWSyI3mU5xXoELJHBkBtW3zE9xIrDOfIeU4j4M761VLlMv7Af+CTYTAU+lpj
	zg0JguDGUusbIEe6W34TuuFnIC6RJ+s=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kWWLa4P/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B8pFc3UE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6069Z2W83243328;
	Tue, 6 Jan 2026 13:17:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qxdg96nQeSV0xjCWyaP8eGCF0VT+md1l/OIaK+Jsnvo=; b=
	kWWLa4P/CfL14dv5TqQ+UpdW3xtVAiYbtZvCEN+ggWQELMYyd354DQ9VpHbcWD7E
	8Zl6c6/S4An5NTQT3sa2dG8wuTdEBv2KrvCzHuOmek4AGcnhBZyqt3552STFPL5g
	CsEAHaa/m13A+2L/TRFawULT+b8KUfFEIv1R+rXid0QNv2WgVwM5VRBqqvcrxd4+
	RXKfGErBS9C7C4y3opYQanprvuZfdLlNv8W/bNW8p6RCdWs57QMZ5e/wM/ee3Ryo
	huPPkFP+0NkqwvjEbB4XrEaiO7ChQFzvs0ZWcGrYGVpMdhbCjOnyEg1iKkSCq87d
	PfSH1tn9pcmHBFbC+YSGgw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgyw006r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:17:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606CkIQH030738;
	Tue, 6 Jan 2026 13:17:14 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011042.outbound.protection.outlook.com [52.101.52.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjckdec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:17:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gBDFe4NQjhJC/V/UdLpVqs3QMdzmqaI/qKHFlnDDpB0411HeQAqGhqCnZloJd2UEv02X0aOyK3dfby1/R/cYcERyBe/+JYF0Q8KA5uQp8JLpBRzFwe+WSp2SXX0vQ81mkoJSTk9u1UlqWDzhNIVcOxanRaWHMyedY+nbttWhg3mM3TNJtAQsuxHWBg9DCgzRlCPTPtD39Hp/TyiD3kNM+pNMiW66sosabFOWvuoVobXmfJV1//q4uBC2XYmpVMtp1LT9jQGwYcdAsSA1jjuwYdjHm+cFWIDc8q8zInarLtejQ8G1D8ooQdT+QBgWESQeaQDQjS1jtZqvUsTEkrQgDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxdg96nQeSV0xjCWyaP8eGCF0VT+md1l/OIaK+Jsnvo=;
 b=yN7/MNfFG3e3IXoxhIV8tzBmfbYJjVWUROiBwMiW/h4oSw7haSYTXeEoXxMFI4IXsqFxdUOH09BaWDgI3/2nNA9uTrdaN058IWrMsZJ0bYOECM/1BwZZbYkpfwzwk6OkIVx4Bn1WIQAk5sj+DvDKO6QaftYi+xDCzXI6dp4a0WnKxLg0PgS7EYlbgUXEdAmR4LRd454qq/FkurImY/D+ZFWEt2omEgBm8lmHw2RokrlH2NOyzJbjrvGos0ctY1D3lKep1pJRhjirpLhOKd8ceFdHx+q+51qfiDs2E1906UXDshXkPnveO/5bcZSgOr3KmdLDmqm2doZL8V70L53wZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxdg96nQeSV0xjCWyaP8eGCF0VT+md1l/OIaK+Jsnvo=;
 b=B8pFc3UEd0X8ffhTNAuRzHCTQbif4X6XNRF+BVw8Hyzd90InRwGNMmSDoAhkF2eaElCs+aRCjGrOV4TlVY8FHPtqVtxGzDsvNivA5mzu5lAaoQGEv7glFYiSdrZ2vTDPNJMTTnZVgaBcxjP56CcB7GD1NAudjreJHbMLRiBI+EM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Tue, 6 Jan
 2026 13:17:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:17:10 +0000
Date: Tue, 6 Jan 2026 13:17:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone,
 unlink
Message-ID: <a1d78ca9-88cf-4b3f-8999-6307c39db0d9@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <b2b22973f761a97751487144f7726bb0cf868305.1765970117.git.lorenzo.stoakes@oracle.com>
 <nmflwd25h3zz3vrdpfgaztko2dcascl3bbfyk6slml7n472kms@ysxtp4xlxf6r>
 <CAJuCfpHq0G=kLBD=_0cgujT0Qu6yQ-EDB1uyXQJPGWmpSQGYGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHq0G=kLBD=_0cgujT0Qu6yQ-EDB1uyXQJPGWmpSQGYGQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0602.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f63888a-2df9-4a4e-742f-08de4d25e60b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmtsVTBaU3pOYkNsTy93UUZ4RWxnb25iZTJYWjVWbTBJWTFMVXBKTWxZUVVr?=
 =?utf-8?B?cFJEd1F1ZFlsTGxPWU51U2VpRE5pV0d2SHRjY3BpOUdsY3g1eHI3SEdnamRa?=
 =?utf-8?B?N0tVSjhYLzdtWUxFenBDVmwvQ3pDdFF3b1JrV3pUNXl4WW1HeHpLbzREa2F0?=
 =?utf-8?B?aTF0V2NKU3ZmbmE1NnROTW1rMnhaQnN6ck56MEI5YllhajhLLzJwTGNFNUxX?=
 =?utf-8?B?OHIvdUdTRVZhM2J6Rk94NjM1dWsxQmVwcHFHK09GaUVTQ0t2UmVHWVRhRWRR?=
 =?utf-8?B?SkkxU2FESjYrNHpESVBhYmRINHE3RE9pUllIYWZybjFPM3k0T3NCVUQ3bGVY?=
 =?utf-8?B?RlQvTjRyYzNPSEd1bm40RVF6eWlSZXJ2bU1LR0hDOWdod2dQcjVZUnhOd0My?=
 =?utf-8?B?bEd1aElWSm9sUVNrUkdVcGU0WnlWbkFqMTZyS3kzdkdVdHF6cXFCNHhFck9o?=
 =?utf-8?B?WC9aNGE3aTBiSnN0Y2ZzSVZZS25GeTFuTzZ1V2kwbWtnS2dvbkx0OFdaSkJT?=
 =?utf-8?B?eHpDRGE2cnpuZUZ5cTV0K1ltc0RNak84ZDhGdjE0MnBLdmxpK25XbWFjcEt0?=
 =?utf-8?B?SXp3Uk5LUWhwWWVHYVhSNWpEaDUrYTVUTVI2QkppNXRzL0xQNzI2dTRFL3Qv?=
 =?utf-8?B?aTVMcEdBKy9GblovV0wxZUxDeFdGTnpvazRLVjZ4QUY1encyNy9BK1VqdFVF?=
 =?utf-8?B?NkpBOHpWVTI5b1I2NDJjaWVwZlU2c3djN3RGanNRVFhkRzR1cVdyWjUxY1A0?=
 =?utf-8?B?WFhSSDBicGpCdndmY09aZmZ6YkJUcG04ZWJ4SlhJT2dTNnZkTFpKL0p5WHpR?=
 =?utf-8?B?UG9JdHFSN3hQaGNkek1JZG4rU1ZJNEY4RXNPQzZaN2hCcXhiK1g2V2JBN2c0?=
 =?utf-8?B?VWF1V09lMjhQK1VNcHAxR0hJMm5nRU5QS1dkblYraXlGa2tGWklGK3hna05w?=
 =?utf-8?B?UjJJOStFVE80R0NnNFYvQmlDWnVSU1YxZFJXanphcG9YMGlLRnlKWE0vRXVV?=
 =?utf-8?B?bFV2R1BxQ2F1RGUxMFpSaExiYXg5OWxpclJzUEtYMVoybjN0dWxNR21QVEg1?=
 =?utf-8?B?YStoUHpNb0d2cmw3UlVWQks1SkcwVWlqTDRlSHAwZWJBODJZdUlUUHhFOTRY?=
 =?utf-8?B?bU5Pdk9vSG1lVlFlK2lnODVBdk11YVRxWGVsUkRUbGVlNkEyOWN4OUg2MXVw?=
 =?utf-8?B?R2dkMXFsSHdXaHVSbWFkNFBsZjgyZmp3WG8vdTIvaDFLbHpFNzBaUk84QTl2?=
 =?utf-8?B?TWpUeEdKajlOd0VsYmZjK1h0M3hYYmg3WlpTeEd5c29JQjF5SkhBcE11ZnRq?=
 =?utf-8?B?MjZPNnJEaWFheGhXSjNwQXpjYm9KTi90end6UXdOWmdiK2Z1ZGdxRjhKb2JE?=
 =?utf-8?B?NVRwWDVNbEJ6Zlh6cjlJSTZvWU5BN0p2UXZYTU1yUU1VbWF6V054K0oxUThY?=
 =?utf-8?B?YjZXcWhiUGxKdmhYb1JJRGtPQlpwSVFPUDJ2M082M21Tb0Z5QmMzTnVNRDlC?=
 =?utf-8?B?OGtmQVovb3lvMkR6ZldidGloVUxtR01oTUxuYUVPMnlkUTcwZnh5SVc0VnFx?=
 =?utf-8?B?bXdJRjRLc2Z3d1JoQkJtcDNHTm1rMGFEZkxLYXFRU2pLWnlsQ2tKaHhZY0pk?=
 =?utf-8?B?SGRCckhHWFhQVVNxeC9HN1dQWHJIcGUyMDdxSFMyVXpYeHRTZmNaNGN5RDZL?=
 =?utf-8?B?QmVoZENXbEl3SVljZjY5ZnVxb2RTOWR6TVE2S2htbnhuVmppNmt3d0VQUjdw?=
 =?utf-8?B?ODY4ZXV2Zmx1dVIyMXhieUVic3Z1dzZSV3pFaERqY0pVd3FvY3Y1Q1h6UFM1?=
 =?utf-8?B?blFxc0J0M0VxNFM1c1djOEs4N2pvU2xYYkVGbXVPWHNVY0ZnYTBhVFVad24y?=
 =?utf-8?B?Ri9YYlk1dVhIRWpKa1gyYWhJaVdON0IyekM5V2M2K1d4N24wMitkR3FrdDFE?=
 =?utf-8?Q?sAAGiYYqsk/kl27UUEbc3a4s2BlVECdk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmlvY01xa0l4dUhXNTBQRnNmRnFCZTNlaU43VnR6OU55cTFFbGhTSHVUcG92?=
 =?utf-8?B?empoL0duY1NWT0J2Q3ZDYzdQUlRPLy9TMjErdkJTMnNya0xVRnhESFd0ZVhw?=
 =?utf-8?B?b0R5aTJqM1VJcVVYaHBtY25WYTVXblZqUkxXRzRjVmNPTHBNSzZ4eGJyS3U5?=
 =?utf-8?B?TTQ5UW9PS1Nyc3h0d1VZVEU3M1NWbWhlWUZ1U2p1ejMybTJzdXJhV1VTMFZP?=
 =?utf-8?B?WW9BRi9WelZQbE85S21TN3FMcTV6b3lWMGtnbmsrd3dmRVY2cSs3eDlXalo5?=
 =?utf-8?B?T0VzZnhtTXpRZGk3ZzlmWXJyMEtqaDUyeXdUQWlTTFE4MzBHckN2RHpVTlJp?=
 =?utf-8?B?OHhESUFLMnVoSmlQZEp1RFhpL29tUFVVVVJMbGtKNERwZUNqVktaZU9aT09F?=
 =?utf-8?B?YUJBOGtFL0NYZ3lYMTVFVHVLdG14NW9hUStabU9KdW5ienU1UnZPYk5NWktM?=
 =?utf-8?B?NnRydHBpdUZqLzBxVGtwVTdVbERtR0hBb0NDWTEvN0lOWEJvR0gvdzVqOXlX?=
 =?utf-8?B?L3oxcnhhall0Y0ovWmE1b2kwcWNlbTdIOTMvWGp3dldUdy8rb2o0ZVVFWWRW?=
 =?utf-8?B?cXloVVc0TVZoRG1QTzFJWU5lZWJ5amdoUjlBN1EwYzc2TkNsL0IyWWo3WGcx?=
 =?utf-8?B?V1hoSjliREZxNWp3dVloWXZnb2pKcWgrN3BWVXpmc21hVlVRUXdramROU0s4?=
 =?utf-8?B?d3B3N1dMWU9uOXh3UWtqRHhDV3FSVjkxSXJlLzZCZE91blhLR0hUaSs5MnNC?=
 =?utf-8?B?K2FXYVlTcHdyOElIYVJaSitEZXZBbDNLMTNHVlVFK292KzQzNE5ZY1NHZ2Vq?=
 =?utf-8?B?ZjRDZEZMZWpjQWVwRFd6WVQ2dUd0a2VDdkxIc0x0ZVg5U1MzcmtTbGVtNlVo?=
 =?utf-8?B?blNTSGVGMWRBaytybVhCckloRlo4UjN2UjFjZzBZYjJRTW1RNlNYY3JGM2hm?=
 =?utf-8?B?d1pPMThSc2xmMVB0cHhpNXM3cStvQWVwYmZvMlJUNzk0U3JwOVdkNVlMNTJu?=
 =?utf-8?B?TVdoV2lGMzRxSk1OZFd6UVlBYUlHZC9KRnJoTjZ4VGxJVldhRnRuUXZydnMx?=
 =?utf-8?B?bVFLL1ZMQmdPOXRSSFZkUzd2UDYzL0MyeWs1emJuL3YwdUNuaHFtWGJCQzF0?=
 =?utf-8?B?V0tYbVppdlNvY25tbWVYRnBaNUxTQ25MT3ZILzIvQzZURVo5NkZnSXdqV21k?=
 =?utf-8?B?eXhXRTJSTVZXQi9paXdway83THJIanhLZk5EVWxxQW00VFA3T3MrbGZaWmxx?=
 =?utf-8?B?M0lHdkZmTThRYWI2RHdYQW5kbXc3blZZKzZHdnpkZk9jcTN3bEpQWkZtYkk3?=
 =?utf-8?B?bUxVSDlRRkgyTEhuOEU4c05COEtpNWI2TXIydTI3T0ExT3lyNTZPdmRhcFRD?=
 =?utf-8?B?UUxESjJPbGJBMGVNNDI2RUc0UktSOGNFWUxDdXFiQzhuWUtmNmo3ayszMmlj?=
 =?utf-8?B?TCsvbVEvYkY2dGYvRUs4SVdnSlhxcm5kSDJ2cmZwL2xIN3ZZRS95c1JiaUFa?=
 =?utf-8?B?RGI1WTFjT2U0QTZFL0YvLzFxcVdudTFXNXpSWEptYjRGblUrSENYUC95ZXA0?=
 =?utf-8?B?RVVtQzJrMDkyd1JIbFdrK3hsTldkdVlRVHJ1SjhGQ0dMVGZSKzRWbFVmR1BW?=
 =?utf-8?B?NGJxbnozbEN6Uktxdld5ZFd1Z0V3TzVORDk0eGhyYU1ianhWN2l4VVJ6dHEy?=
 =?utf-8?B?U3dQR0lNVkVJTDZ3cFJkVVpzMDI4bVFRZitHdVFqZXUvK2lyVEVBNGdyQkhB?=
 =?utf-8?B?cXN1c0ZzSEcrR3RoKy92cUt6SC9rQWZNZXl6Wk5xaTg3YmhQRlBiRFJWMWFX?=
 =?utf-8?B?b040UFU5MFloNkhqbDRMN0RxM1crbTJWNTVYSXlsZzd1U3d1Z1R0NjlHcjdM?=
 =?utf-8?B?UVlQVDZIZ0hvM1lpaTNTRWFyZU5zMzNFM0pGRSs2b2R0ZXZ5VFh4bnVCUERo?=
 =?utf-8?B?THR6U3ZFZnRNd2puaWMxTHM2dUtyK0dqd1FMT2dnUTFxMUZOUjBwclNUU25B?=
 =?utf-8?B?NTBSNDdRVWJ1TVF0a0xXZFQ2NndjejVMTWltTnBqSFBTR2grRWIwUk9Ebm5J?=
 =?utf-8?B?dDlteDlJeVBrNDJYTWFubFNwY2hzODYyL1hub1p0SURsYk5GNGFWYlpXY0Zm?=
 =?utf-8?B?cU5uOUFnMkpSbDd5VlcwTU5LSStEUGp5cWJ4SWlQYTd3WkZQTmprOG52SXc2?=
 =?utf-8?B?WHFpbVc4clhGUnA1K0tPQWtZVW01eTcyelorN3MzYlJrWERoWkZSSVlJVFI5?=
 =?utf-8?B?Z29mN29IS3cwUE5oYjRjOGxWbCswR0lMZ01yZnNxbTM5VXMzeCtjNE1QRkZY?=
 =?utf-8?B?VTJsVHdab0lWY0lnQXdWUzZJWWQ0SnVJVGp5eVNuVFVZTE8wbDRuZlloRnZG?=
 =?utf-8?Q?EURKL1OBrU1k1acM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D2ZdQuIPBZQcTcwEOGfbttBSkJhiItfxZP3RdcVZU6KffMJtCRwOQhNBA9ycjwl14J4CjKiuN/zkj3Q0Vto/VxtI32uSYrMwxql/OLMxB/H3mjjSO4jt7DCvVSD23jgSB6I//Vzm/JHLiN3fPfCc/PrPRvqK7e6DznvNnhb6YxzvHeRyX60D97+VMhsv+EMJbpU7lN5FLgABanxk5khn8D8xcjom1KQaVz56kxoYRgeMaAsOoz3P3pXUqN1H62fa0lxIFWtWtGPDsJoiKSTH0oPBL68ldfeThTuHJGTyFNrkoGNx7y59A/ZETnE0ds1MEJzGqUsm5k+hfGTFtHYm040EdR1h1ufWiPmbcrtA5yb5Jyi4hVxO835CCsWF8u5yx1rM70n635bO6e01mL/+Z/4zs+SbGZ/hJJDZtS6iQ/qM+UXDSGLwflp/vqzil33UK8t2KbI4hk1/l9DDctxZZR9R2lNlVeGLNKt2YnMoZpXBSkIb5n0muk43ieKAlAJcTm0A2i9WEY1mIhEwR6V73XCvrZGCOPfM2ozf+d2gMCWOJSpEC3IJZEnjJhMVlqcVCmnHYM/+F7ISamNJ6W+iD2oSfaRWxuzcIcqcyz1mEow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f63888a-2df9-4a4e-742f-08de4d25e60b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:17:10.3283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KtIN5z3vUgaX0oD2+HX5gqrIAWPuJtfplnk2312seLdYwU6fMHyhIcU6E2j0jOutgwhORW/v6tQmbkCD0oDiagZQAysH/F7yulAzKV/mSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=830
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060115
X-Authority-Analysis: v=2.4 cv=W7E1lBWk c=1 sm=1 tr=0 ts=695d0b5b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=5_gi8a9uNSRs2YktVVYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13654
X-Proofpoint-GUID: sTxxzFlD6mradQP8X0EZCQIo81ADVWKE
X-Proofpoint-ORIG-GUID: sTxxzFlD6mradQP8X0EZCQIo81ADVWKE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExNSBTYWx0ZWRfX0wo902LvUCmG
 qIyARSTsGjF8FPK87tE/ZBNKfpg6kDy1bjCYu1BJAsKhGiPMVdnAhJRCiO5Kr6dur8xSEeVDciE
 aa5OXhTYxWATNZs1Cgb2hSFwzIfMFiZDqT34QV9vzndIpnzJazBDrItAjjFYAwG391jpcQojKvA
 d1A0ZIjv6GpMsWdP35PDEfSF3EXD44BMO/1UOfa39FWjQSTHiex78KAbM8nBD5AsuQqtyCpSNRP
 zoX4SRuOf86ojiFQDae1Z6+19fh6AmxxhnR9mukMzELmbRdAhpv4O3obcqjII0r3yehcfCgP9LQ
 /WaecX0w+46K6sZrEiyt7v1SlAVeFLEB+P8lNnR3dTK4Qtdn/79w7fLO+q8gXhtTwohswTcnSYe
 XnHCnkbQa/8U1wmBW45bQNxGl5uX3w89p6zPqTzzybN8Ztbot+/AGALKI2It8jpJKhzaOXaDh60
 qwtb9xuM84ld/QXMfWjDNLkXSFpUNy/O/L6C6BYk=
X-Stat-Signature: 47bc349fehdfu1ytoa1m49axgqsck7e1
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F1D58000D
X-Rspam-User: 
X-HE-Tag: 1767705441-935881
X-HE-Meta: U2FsdGVkX1/zw9gDz36IOFPGVbQNnX0BQ/PN5uZB5RRey6MFMGah1f2aX/i+a8TaF2LbSbtr0i3w1qg/jSpoTjQllwcrep4JhwxViSqu8jUInONln8nohuTd+/diuihrq7NjYA+XqUZrR24FxZv2XpZh+9QZe8tYXSR2rnBRR6aFM01iFoIOI8LUgvBKRtZEW0Z3Vft1MqfR2RGp7ixWmstXIqxjUBBSHxmouqpCG9RFhe5wWF3AhxGMZme7/9DAR76iI348cgV9FOCGuYITcgF36Dn20Oi5Q8sw4VQ+yyU4RyvPC0qvrTZM0zWZgy87JYgtrw7v/8hNqUL487vOGrxFwY3IpgQ42hBdMRO4nLWf4SFvrp+pdut47nqq5qGtqoKh4/SBNtYSLK1o+iKyBPBKZ9xMv1aWhDrFyiOAqsKMvxHW4CSZdG+f6idHwaWoi3JWFiHsN3UY7Jq40cNpfveihUiX+c3ZxI8zJ0gh8DoZvvgcKC1cRsHuX3sSEK3NxpMro9gF6bfK67+gKl33RXsF910GBxhPjOs2yiwYwW2/+paJ9/Hn1CJOSnw1/neD2oFU1M2LqkWTy779GsBuRARTKeJJCjpNVh+JoNh/yYoaSy1WBGtDOnkgmTl95/sdORzqbKqgGY5CotY4t6OS2yBk0THAyBDXo/oy+E0Vd2oifZcJLIYnm7YK4wQxSLELV0zTV2JUKx578ppXKvW+zfdElJ78wnJWA0ZQ/zqeLRb6T+W25GbVhJGX5KqEXgmp6dyCDSsILQ97diuLKJYOL6eygv2a+STW5SpUGFbRmLeq/SOZmCmaofASgwnRexkSadFUHMVggZZWjFgLALttrEKoUZk6Aowpz02ErAXVnAgpqPf7KoZ5snozWBF1aNHX7fx703SgfbMv9iSOlZAHZkGg/d4j0XkBqeOIiLx30gIkp3Gpp5UvFuDs9hnzAtssWaQektATsF1zWAhxk9Q
 r/AwBL/e
 Zkuse+Hjg0PDgji11Xr+++kBwDeaFjgIN/NZKmdhhAQgVD/fbqs1jyNn8KPTGZdUcp/YXEycSCUcVfqialnfd/kBfEzc6OnYGoWeTAP/fnH4VDoyLrMRB+hUU0EcBFGB1W62nTK1ORbjEZv29ny/sEYHhVZYRKOO2U34j89qDJkxSQjwIfNO06mHLejhsJYGPS9MFc9EV2iMQRQ0BzrzNiGkFInAzL3Mlg9Rgh2irF2X5SleyulaM+Riio18LiQKlLZZGiZkxjMU5VW1fqo3fWsvSOoLFF8hrVVoVTVqvJsfO7ZMPRfb9VZ89sPfe/Lx9MXH9i9JGlMgKahJZC97weyyb1fIfTgQFjefjwkQF5VoUQj1yWRcg7qfxr58KYgQeYpd7ivEh3Qhqt9qXCVQ7CtJTEIOMQNIIQh7etVgiMQew+985Y4vCliwyqwblbkd4H5qkr9nfnhJPs9QmKEg7bNf5Z3vXXE7pynGtntvSAsqVab9KUPagyY+Hc7+W3s+7HDl233YegnAiJqvUlTg11hluesJ7jgp7SOXbLLUlkVX/v+IjcX8FQ4IeAknu2eP4U6ROvJcq0AwZbelY4rbqNwN0c1sbRR9K5RLsK1HrZEX7c1SJ59zWpOFc6UY3F6/lyHX29tFkpH1rgZNHMMFrSqtWiaMX252r2tP9sfDGuqtqht2wZarsw51Kb7O13puptvJVnRkt7YpxdmW7DbUJMS3rxk/1BQmglFRK9UqAfqa3ITAPSaOz1Zrj5SVibordrOcE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 01:41:10PM -0800, Suren Baghdasaryan wrote:
> On Fri, Dec 19, 2025 at 10:28 AM Liam R. Howlett
> <Liam.Howlett@oracle.com> wrote:
> >
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > > For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
> > > VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the functions do
> > > nothing. Simply exit early in these cases.
> > >
> > > In the unlink_anon_vmas() case we can also remove a conditional that checks
> > > whether vma->anon_vma is set.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  mm/rmap.c | 20 +++++++++++---------
> > >  1 file changed, 11 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index 0e34c0a69fbc..9332d1cbc643 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -309,6 +309,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > >       struct anon_vma_chain *avc, *pavc;
> > >       struct anon_vma *root = NULL;
> > >
> > > +     if (!src->anon_vma)
> > > +             return 0;
> > > +
> > >       check_anon_vma_clone(dst, src);
>
> check_anon_vma_clone() is used only here and contains a couple of
> warnings with "!src->anon_vma && ..." conditions, which now will never
> be triggered even if the second part of those conditions was true.
> This seems like a regression (you are not checking conditions you were
> checking before this change). To avoid that, you can place this early
> exit after the call to check_anon_vma_clone(dst, src).

Yup am aware. Was because later on we do stuff that assumes src.

I guess I can move it and then change the later commit.

>
> > >
> > >       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> > > @@ -441,7 +444,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> > >       mmap_assert_locked(vma->vm_mm);
> > >
> > >       /* Unfaulted is a no-op. */
> > > -     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> > > +     if (!vma->anon_vma)
> > > +             return;
> >
> > I guess it doesn't matter because you just added the !list_empty()
> > check, but did you mean to drop that part?
> >
> > >
> > >       /*
> > >        * Unlink each anon_vma chained to the VMA.  This list is ordered
> > > @@ -465,15 +469,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> > >               list_del(&avc->same_vma);
> > >               anon_vma_chain_free(avc);
> > >       }
> > > -     if (vma->anon_vma) {
> > > -             vma->anon_vma->num_active_vmas--;
> > >
> > > -             /*
> > > -              * vma would still be needed after unlink, and anon_vma will be prepared
> > > -              * when handle fault.
> > > -              */
> > > -             vma->anon_vma = NULL;
> > > -     }
> > > +     vma->anon_vma->num_active_vmas--;
> > > +     /*
> > > +      * vma would still be needed after unlink, and anon_vma will be prepared
> > > +      * when handle fault.
> > > +      */
> > > +     vma->anon_vma = NULL;
> > >       unlock_anon_vma_root(root);
> > >
> > >       /*
> > > --
> > > 2.52.0
> > >

