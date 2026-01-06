Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A4BCDC19F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6046B0098; Tue,  6 Jan 2026 09:01:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67286B0099; Tue,  6 Jan 2026 09:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14FA6B009B; Tue,  6 Jan 2026 09:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F73B6B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:01:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E82687813
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:01:02 +0000 (UTC)
X-FDA: 84301700364.13.CCADCB8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id EEB3EC0023
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:00:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RZuWnOFf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iD7VwcnT;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767708059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVqMzpzEAOr0riPKs96zNboik2llP1OktUzsXekW2i0=;
	b=cIixaddp8Qk8mwljkXQIhhih7GSiVZNO0m1gg+CLLPDobT7k6T68Y5oYScyRca7zirLXSt
	7nfDxF36mmlIwnTRJlY5wrKZMLSxbsjp2iqufnNxE/ZZ2IPQ+tcPmumJpx+3FPggccJCKP
	4085OD93lGlE83TeXQBp+yW3KzdFLB0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RZuWnOFf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iD7VwcnT;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767708059; a=rsa-sha256;
	cv=pass;
	b=xU0F1pyRSkYlWaEs70DYGlrKYG1t7AyS9uk93NDwXFNgih8jdKSZhr3/MPpNrooRXGONMJ
	Qu3+rA5R0od7U3k8D3mPN4CJ6jwjG/DsO1kqr1l407y3rG5NrEvlthC6ducwotCI9R6gH5
	Uld8/pBb/OFnyc5QF6eDukB+l/nqbDA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BtmIA3785926;
	Tue, 6 Jan 2026 14:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VVqMzpzEAOr0riPKs96zNboik2llP1OktUzsXekW2i0=; b=
	RZuWnOFflOolX6GLj+E8oNJL3xLzlAjlWTkI12YvZGrTtYWa/2/D4HhldrVgV4mW
	sDnff2LWKWVJPiP9n+SwQkQxdMbpHu+wQsfM3ZTSRfF/k/Qf2ZMjAepy3ICyR7yo
	1aZQFMjR4VOl/01Bu6V+Lp2mSGeoJEehAbH+6lBfrKiXH8LO+T8furaOe1AzPBbk
	tPCX3F5LN8fiGxwDhExEVEN8rCC4P/9O0JlGVtIXcMbi2w+U58BYl0zGyf3fRqDY
	qwjPQkWi6XgvxSG8WrgHcUMlih3ouGU7hiHv7FAHrRGAjKwBxE2NffOuT7xcmMOu
	UOvlcq2Sw1M0sXZsRiysMg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh1xrr4ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:00:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606DJQ2i034230;
	Tue, 6 Jan 2026 14:00:53 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8m9xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:00:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+1MrQIayQ2Td8tUQZ1bZKhv16Vxpmx/1dxwf2htoGvTOewfQEk4x6G/gxrpVb+g8CA3oGDJmgWp83k4aubppFHchP2df58iWIENDu3ncE/FFPxxeED1oQ1A9CS7CMIfIyhneN3u0GkDDvkBYKh2hJkuJ7ErRBxg6VpiIbwF/eDagF8/ctRsFXS4/PM/Klz9U5Pd5M178+03NZUMDs7C8jDdR0OmBvoyMZeJ54awLJQrXPw5qq6NNg2t8eLl1XiD/hJXyQnMqSKFN2io2mh1RjU8gSmiGnIXu8N64lXA/aac2K50feAk25lgEp94R3o5MucgT+bkL+iEe/rl2FMvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVqMzpzEAOr0riPKs96zNboik2llP1OktUzsXekW2i0=;
 b=pHNvW+g50la6WpXQOP1gveX+NF7dKOM84NIccFPzTEdF6feKj9QeUfppjR+dSTAAxvKvpNHFafN7VYyIiHA/P3D/D7O9VwaPwCiWyqPka9s24Di2+99RgZU8O6OsaedVLzey6ewP5zOiU8fCFFTV4DuprsnNxc2wwMrCALJZW7sNwIh90z4dWc5cTXIovrHBazP/lf3Jal6sU0HTo7cKvGYkmaaLGG88yzsryH7PB3GRHLHlxXgtyhgaty2e0tOJWI6vuoUmA2YTpJA1MtAkj0tq/1msgFxUeTww/2TBoSov4BcbgFSvTjJFvCTMcUIxEJ1xkMRjftEu+z1UIhd8ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVqMzpzEAOr0riPKs96zNboik2llP1OktUzsXekW2i0=;
 b=iD7VwcnThUQR0pOa3+VavBpj7xJ8vqhf/MiLC7EHEvgrqD51+fW4DEYo3/93SrsXoFb7xI/8cM1UgDpI7BJ6wVGmTVau5eDbqto0foQGKmO/XGlNezH91kfTh9aGY5r2Ctf92Burs0JDUeHiFEjve381ZXuO44W5/GkNoIBQ6vU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6686.namprd10.prod.outlook.com (2603:10b6:208:41a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 14:00:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 14:00:48 +0000
Date: Tue, 6 Jan 2026 14:00:50 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] mm/rmap: remove anon_vma_merge() function
Message-ID: <79d15f9e-2a4e-43cd-9004-a56cb0945c35@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <ea57e3ee7b4d2d40cb7f77703baf0c3ef34bc304.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpFTSAyzHBiz3u599td_A9DrcTjhTi94vE+=V_V0Bkawrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFTSAyzHBiz3u599td_A9DrcTjhTi94vE+=V_V0Bkawrg@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0284.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 7530ef75-03dc-4e93-99af-08de4d2bfea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXdhQ0FYUEF3Vks4Z1RId1daTDRNSkJKaUovYVI3MVFqVEkvZDdBQWVER254?=
 =?utf-8?B?bnhSTEZkZUFuOTRPMXREb2ZianRaa2xZSmw5Q2t5bVZCZEpWNEw1bk10RzNU?=
 =?utf-8?B?VWd4SG5VRWNJaXEwS3hnS2tHcGxwL2NhMytqRkVBUldJMWFtMmMvS1ZsVlBZ?=
 =?utf-8?B?eUo2eDNJa21HbUVyeVE4ZnJGVW8zYU5SUDAwNWRBandXc010VVFzT3V6d2sv?=
 =?utf-8?B?bUZPdG85bUtISUNubmRSWG1CbjN5TXN2OFV2SVdrNHBrbU1hMXFVTWlFZmgy?=
 =?utf-8?B?Mk9sU0RoM01DWjNqY3JvYUdrM1ZKRU11bGVFTWVoU3ZEVGJ3YWliUHZlaG5r?=
 =?utf-8?B?NlFFUnR0Z0s1ZGNnWVlhZjkwUTF5QTl6REhSMWhncmd3T3lWYXpzSVR2Q25P?=
 =?utf-8?B?bTM5Y293cUkvZXllOURRc3dCdlcvU00vYSswdjFxMmFQMGtaTjRwNnV0QWgx?=
 =?utf-8?B?RHdsYjByNW1NMDFSaXY2cGVFQXRvM0JOdnN6UlhCM1RRTFh2MmxuQXFQNHRi?=
 =?utf-8?B?NFhUOG5YOTBmelRFSU5tKzI2RmsvTTlkYmpvZHZsYzY3NFhidFZuaEtvcXcz?=
 =?utf-8?B?NjRQb1RIdkVNZ3ZZSEJncjczSDFuK3VmYkZsdDJjR2NCMU5MaEE0cGFPSXRE?=
 =?utf-8?B?TDhzYVBGN3VoOWF1aTZNWkw2RHh5NlBrZWdza2xqVGV1N04zcXMwaFpUSHJh?=
 =?utf-8?B?YW1kUTk1WXdJS21oSzhOUVpVZTYzV0NrbWFlUXMxUStBZ05ONFhHV2NUaVF0?=
 =?utf-8?B?R1JCQmlwMEdaZzVFdUdaSnBCVE00UUdsZjNHaU5PcUNWWkZsbUlvMWVrRmd1?=
 =?utf-8?B?dnNjSThWM2hBTDJQVXNDTnpHcDRlTVIrNFJvczc5dG1jUlhpODRiUlpVdkxx?=
 =?utf-8?B?WVJUS1d5U09icWtNUUJyanIrMWlhaXZ2dmVsaEVUUmFsaXJLUU5YZGJ6eDAw?=
 =?utf-8?B?MmlBcGxxVXhwUDd5K1hUWG9Xb2Q0a2pIdU0zUm1jZGRBOUxZcGZZNVRKLzhL?=
 =?utf-8?B?eklwaXZQd29XSXpEcjBoUEdVWHFLODlVUlNXNFNNN2U2VzFsOWpCLzd0eXo5?=
 =?utf-8?B?UUpzNkg1RGhiV2g0NTFwQlhoUDlUcnFaK2FMMEZ5cW5Bc082UjJpUENWVUYw?=
 =?utf-8?B?a3U0THIzaFhRK0hDTjNuQTBGd3Q2MDYyWEF1RWZFRVExd04wa1JJaHlDUERx?=
 =?utf-8?B?MExXeXlQdFFabzdjZ0UzblRWTW9heE5LdUtrVVV1SzFiY1dHcXUyYXltMEZP?=
 =?utf-8?B?UDlIUDR2Kzl0d2d2bnJHRGlySExYYXQwS2pQWlcycWpXV0c5Q0NnNDNhSThk?=
 =?utf-8?B?UjVZNCs5YVREK3NNemdsY21OWkdVTHBoZ0tqYzdySUI3WFAxb05MNzBoTUpz?=
 =?utf-8?B?TUhqeCsrVXFqTWlGUS9wN1c3cGY3TUFRaG9TbzZCL2k5N2p5S2gyZHJXV1Jn?=
 =?utf-8?B?a3N2ZEJuQ0wwMUs5Z0hnQm5RRkkvOUlTU2tYU2t5WnhYMjRvVmp2VVJ1YXZF?=
 =?utf-8?B?QWJLOGI3aWcyb1NxM2c1WXE1RkRtOG9OYW9VYk54TzQwdGI5MFBSbjFsOVBa?=
 =?utf-8?B?RkZ0WWxENTl6eTJ2WUx0VzBnNFlLdmw1MXFJcWxOaVhmY0Q3RWFMVzhFMGUz?=
 =?utf-8?B?UkM4ZFl6ZXdJS08yUllhQlkwSXFzZ2VkQlpsWHhjbDVNSVRZckZqNjVHQjQ3?=
 =?utf-8?B?eWlxR2VHQnRJMkdrTmFWMkFmT0VTaGd4T2dESDhDV0ZUTklGbjdMWDBOa29l?=
 =?utf-8?B?azQzcnJ1Nkt4WXRvSStPWVl0TXg2cFF6MnFIR29xL05mY3dwbVduaEJxSDF2?=
 =?utf-8?B?K1ZYU2syMi9ROTdOR3Jmc0t5TTA5WHV1WldONTVYKzlCVGtYWjJYWWh3UTZD?=
 =?utf-8?B?dURpZ2lCWUZDUHZWU3N6clZ0Q1E4OTNrN2lLZE51RjAvbGJCdCtVSXorVTZT?=
 =?utf-8?Q?J3kbsew3u0P3UAVXCqKvrG1+tkuRRltZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGNKaHVGTHowQmxxdFJjd1FsZkM2VDR2Tmp4N3I3MXpFOVp4WEFEc1c5MFFH?=
 =?utf-8?B?NHAzUU0vdEYyakpMenU5bUhMWXd1MXdJT3ZWdmVhRUJYaDJzYng4OVpsZ21B?=
 =?utf-8?B?UkUvNHBYRFNWY1BHdkp6VGhwYkJpUGEvSE4xOUdRb0YwWXA3c1V6UFB0b1RO?=
 =?utf-8?B?ZTZxMS85ai9TeEtTb0FQY2NuK042RkVTNHR0dy9sMzRBbVI5cDZVZnp4b3R6?=
 =?utf-8?B?cXpDdG5QQ1RpMHJZd0lFNG9ISmhEYmxWMWN1TTZxeFd4bExYWFhmN2xKT3dv?=
 =?utf-8?B?SWxRS1J2RjltZEN2QVFHQmlmUURZelllakp0T3UvRDVNbEpldk9hMy8xN0FV?=
 =?utf-8?B?eXIwb2habStDM2xPMEs1QTc3QkFJSkc0UEl1Rk94MW5CM1I1Qmk0M0MxRjBZ?=
 =?utf-8?B?Tm8xSFFmUy9PRElXdkU1MitzTE1Fa0laQXdEcjgxQ1NhWkxWRHVZYXJ6QWx4?=
 =?utf-8?B?SytpK0pjUldoeWNmeXcwcHM1b2U0UWRPbzBHYWR1cHVkaEs4SENLeHRWTjUx?=
 =?utf-8?B?ZFI0UmdFVEhRVEpoSmJYT1RuS3ArWkdMazF6dnJBUlVkbTlFWVFOSTBmS05w?=
 =?utf-8?B?c3g1cHZMRmc1NFlLN2lSSlhRaVR0eTdOQXU1NktxN3hiTFQ5NVEvUFlTbG05?=
 =?utf-8?B?Qzgvbmw5Vm5tZUN0Mnk0L1lPenNuOUZ2VG1UNURNRHpQdmx5b0xhSXRNZUw2?=
 =?utf-8?B?ZDk2L3VWcjI1OTh3SWk4WVcwRlppdkVsM3c2Sjh2M2FyZ2JBc09NZy9VMnAy?=
 =?utf-8?B?Y1BxUHhXZzNBM3lUcHhhelhpWWNobU1SeXl6d24ramlvTFNjUVY2cWpzY01n?=
 =?utf-8?B?TGlPZDN2NFJaYUJ0VzNQSVVkaGhuVEQ1MlMwa1pveTZFdlhNeW1DUWRDQ2ZX?=
 =?utf-8?B?OHpueEZqdkdDK1krNEM3UzEvYm5hVXVwcU1tR3FSeDBqeG5TWmR6UW81d2lo?=
 =?utf-8?B?Z094cEtPeXVjbVpBbVlNcW0xbHFuVmV6M0FtVWpBQW9QMFpiOHhUTFY1SHpv?=
 =?utf-8?B?V3A3NWZjR0NqYlBGM3A4V0c3ZlZSZzVYWFpzMUQwbGJDMkpGZVB0R293SlFh?=
 =?utf-8?B?bU9IOGtUL0EzZVpQQVVtb2ZkQSsxN3BYREg3aFdGMExKaTBoUk1QMjBONnBX?=
 =?utf-8?B?ZVFmMjFiM0ZZUFBIeTFTNzk2NmVpbzkxVE9KZk13aUxPbzNYQ3BWcGIvYzIx?=
 =?utf-8?B?NGU3TEFmSzFya1c1UzJqcmdrVTBuMy9ZODRYaG1PNWJ1bFNqSHRSTGhmWXRE?=
 =?utf-8?B?cFlyR1VMbTF5SVJxL2pHTm1ld0F6eWMxcHE2T0kvSXY0aW9FTkRBUDg2RXFq?=
 =?utf-8?B?U2lhTmFwdXo4Uk5lZm5QazdrYWc5TzRDSEF2TkhnVWp5VWUwYjU1OUgzMXJs?=
 =?utf-8?B?Wjd5d0NnRFF2aEsxQWhhYmRnTGErcnJKTXcvY0dRR3pMbTZCTzZzMk9mRVhO?=
 =?utf-8?B?VmwzbnYwMmlzWVROSklDSTQ2bWlqNjVWbE13dERTQWtOOXppakI2MGRFRkND?=
 =?utf-8?B?TVl4b0VnUmtZT2tOQkJ6ZC9sZ1ArZklibzdtVEVyU0kwbkh1ekM2eFgzY3B3?=
 =?utf-8?B?QUIwTjVCL0VHUlFhWjZBbWNLWHNuSi9RLzBhUWRmcDZ2Yk84SEUvUlBWREpl?=
 =?utf-8?B?eDhQZHJjSUdhU0sxVy8zVFRON2FFTXFwUUVsaktYenJHanF5TmxPcm5abm10?=
 =?utf-8?B?cWxsRnBKcTh5VVYxYk1JelJtMU5pTmtZM1hrVVo2WThLUC9YMmEvN2JvbkJX?=
 =?utf-8?B?UGxDUUtPQ1VtQjBpMkhCeHhWYzZua0tXd3lUUlBVd2NhWjFMRjNQWGNkU0Mx?=
 =?utf-8?B?RXR4V1JiOVNYaUxMUlNaRUhtNWhJQVZneCtseWk0SWJpNVFWbGlqcjJxZGps?=
 =?utf-8?B?K1pFNmVuK0I1S3BHdzhmS1lOQTJUUWJXS1lZZmlCckZWelhYZjJPSi9WZHZo?=
 =?utf-8?B?RVQ1Rk83ZXUrZ210WVR0L041dTRuVUVQdy9sYmxZcWNwQmd1OFBPVzM2UnNs?=
 =?utf-8?B?VWwrZUFkeWNORUVPUHBvaG5GUFRJZTJHU0Y3SC92Q0NlT2w3bkhwa3JndTFT?=
 =?utf-8?B?S2hJY2xMeTEvM0h1RU5uSm1IWEU0OXkzZkFLZGpEVUJYWXVHTG52TEZVeHNn?=
 =?utf-8?B?d3JxZE1zWjZpOVpYNk96di9HUEhRSWlUMzJsZXhqSXcyaG9PMWIwck5ZdFJz?=
 =?utf-8?B?OEpuRU53dzk4K3FiVGRvdVgzRUp2SWoxR0ZLNXY5YWRHbG5LV052VUN2Mzd3?=
 =?utf-8?B?dFRBLys0NW5TaDJtUmQzbnRYQ0REMFVvNk5rSWFIVnFCVm1xWW9sQ0xaMmx2?=
 =?utf-8?B?b0tjbkQ4T01ZSGhyRExPSVZnR0ZXYzVjWVVtMFRTY1lqM1pIVllFYWF5bXJT?=
 =?utf-8?Q?izT4T5bSfJN01r1Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yzpI5OvB+oUPT0qX8eeoBNy+HS8pMaMhWQYcWd2aXY3uPFlq532xETHPdmfuQR5NQaKc2GBOM8syp58a1IdrmstuBmOvTonlRJmqZ5MphqpyXDSbzPy9uQe0MqZSHlXkL0T+wQpWQ9C/uiIqu9s95M2tvL0bBtLIG6RwMQiZ5GPU47HIEpKgglhTyJ2LRZUxHl/E67w+rgvTKTTH6rn/zeOzF3qxEjC4OYPV1LuKIotd6xWAtmuYLeqWapyNDRxbQ3D3IibO7SwTfEIxvh3tKtIP/gwUgDdy1NxYRJKVVXNOPrOk1ZJgtnsVD5ne/ggIOjoqsNSGhKqNmgvHfQWxc/OW5YrW+JLy+V/tmP5Beki34UTLcA+dbSqdQhhCi5EYIi9n/ojp5M6Hzm+8iAq/wQG4YwdG4/ovyFUgbt5+kZSHibuQr9573TZmxBvmok281PoFhO+Q9m0tNBpGaK/v8en6TZ9Oy9LTm7MtXgGNdLd7VPgkA5QkwcCjE6zUC7vOYcMenYAMBtuGL5j/HRmSJUqOYxocFGUF7pTcwkVsOuxzhgyQnigN2EGg+BsngHKNdSz9kpj0FDNlWVb4gLvWXm71mK2EPVg4guIaJZyx+/U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7530ef75-03dc-4e93-99af-08de4d2bfea1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 14:00:48.6293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3Wxl9Us0PUJ73VvxGTrwcgXEdPvNXXl+X/Fhu76iT02eJULa+0ldUq4S36qc7elwyDu+utwgIySekSZ1YdsSNJYPQ2gixU9goZKvfg1OQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=891 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060122
X-Proofpoint-GUID: WBVI5geS04Q-U9EFb0_qTsUtNStMN2LM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyMiBTYWx0ZWRfX7pYCqr8pNIEu
 6L3j+huzYoCSxVg29L75YBp0Cx/Mrht72Wvd0M+zS3ehNTb2Pwohy6y7RPc7qIL7pji4Zw6i5V1
 B1x8sEZ3OpqRn1tkx5aCnqzl4+idLOGbKaFQOJYpe4VMql9YAJj2fTv5SXIoMQEjchkVT3Ff4X/
 QEKsmGzCSnTInqVCyPl11sCay4Bwt6kyZX16OAKEYTF8Xd+YVgqsS6n+DbbWTN02CAE4vDpEsd6
 i2DcuxjY0EqBlAbKb/HC73WScE65/E8fUZWt5wu3ehKapnHyY8lcSK2mMePtom7d5/91l1vsjZl
 CSpIhEaxta9gh4WsWAMUMV14nL6bQ81XAuWeD5clrNY2dO7mI0eZoFkgRt9ca9lyHahi+7JESx7
 DfLUItH3PDd8bis1ueHukYpaSdfc3OUpzT7WokcdHpVDGTlTEg/xC2Qq5iCz2OvG7O8SKQlGm2b
 z42h1A2pGkGryoQ6R+w==
X-Authority-Analysis: v=2.4 cv=J8unLQnS c=1 sm=1 tr=0 ts=695d1596 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=8B3UESCDpgEGhwTufwcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: WBVI5geS04Q-U9EFb0_qTsUtNStMN2LM
X-Stat-Signature: zerg11bjfomxtayrw73wkxfr5urbu1pr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EEB3EC0023
X-HE-Tag: 1767708058-511977
X-HE-Meta: U2FsdGVkX1+tiAjPaunL9jQXmlRajIoHjMhPjVZLe6q4aRTbLfqaaMnJLen+aYaUC2CRofHMKI1XiqKhGXR3SVWIIL2jQ03W2W84lcVePDMKdX2S4XkBqN7Km97XvrPb38BlzXn+vYveSleRA5E0PPXexCKEvceSBfcpz2YYVogHR8cP+QudLJAWQD9gEaK0gaAZzGMUlPzErWV2VRhNp1due/iG8FDwgbhXMvfvvpbdHcuMk0YE0fCxNj4TrUkRX4ph8mAOXojjpp5xF8tUis9LlaSR1DQeu3g3At4TOHiUpektNy2hmMw8F0RMD1F1iO146I6CTsMwpDx1ZZ+Lpw49OGNWWDIKA/MpY5P1iR0X0m42H9VVtdNlHTSRpt5pgasEZvrKYgOhzHINjvlOYieB4tQB2MLRG2Fo3sjRC7yFMXNCMyLZkifPvQOqrQT3gq0uc9km5/N4GjcGW05J0h97IltW9wcaTzDZhvF2rVkS6fHpJYE4O636zrtTEoTBIeDFR7q2b6trSdmN/Fq634OuboNuZmww7Pigv+RAdgT+2IZ6Wq01jetHoguCA+qpjfJ+aqQWL0j/XJy7QbclTn5JPli22u/sKO7QGrSctltuEFaVUi2xeO9GPVo7bnOUxOls8Yrw8fM+puLT9qoBMbhZpWmnIT4uYiHDBKOq9gNl4bBXIp/YE9ZTZ7vW3tEqfwnaoipT7UUjc6pTc8+kNqy16biLl9Vh8nC5J5IorP7z6esKb2vd6IRKRg1FpgVY7bpk/HOJnpuD8DQvh/DLcH1U04qv4cNkPl8mFD1onHzFVWz4X2FauzWa2Orq9UX86hLOIc8zufukicahGv09kRJjxihYg8VRi8Pti9imL3av/AylhK8FZj/lBlXy9XUVX992GvMMUHAkKrioYDbJwJeHXACC5YpdF9+UwK5GflVb3YgiYdmwRB7n58Ry+iU5U3eHSU9fE8JCSsVxMmI
 HvBKjQJp
 fQRSxSyDIzRRkI654BR7WBGI+TX9QvcW4tFA/cET4C2tEvfLbP8QxjdciPqpb64A+Pg+khIlPcMwwEV6z/wJqs4yXHJ5oNYRKsZ4KBsI1oyxsGFwOlv5n/73SeHCdxrz+m7Es8bjp21P6S3DMR3bO0p5oJRR7yirKHHZatShIsRDPGklrYzoc3ylSgoNeuutOVsELUsc8scrCOEGkz2omDSIpW/j9ygmfc/w+0NvkM7918M8Cx55ldzPZwykrSOAV7y6LRsfNpGIyXTd0mSqwy2cb6AedFnt5Bhu6AX+yySeKO0QJW+gRQOrRT7NYUWX2YFr0xVdyfyQ2yFAzGey2/7fEu2TrDg0JLXi+fDq0npn+Hm9HaAG+qdWGYA8EeFgL0kAMY1Q0Eg4bzGbqYzYMv0KENJuAJJqA1gQZqpRItqaJ3IRa+vdwOzmo6n/lBur7V8QCL9nyCWApC0uVxXbUjrpBR0JgJjuzTVqVfsD6iwZxfSMuL80sQQ9GqPqNd54Fsyt43A6qm0prP3X/FL4oJSkBxGqNDXw4RjnxtNNIK5KAXAwYJW/Abs/WYyU4w9ZNOyvjjo/OEiO2VBbJrsWy38gigV0g59wSwb5xtrA15ZA4CjETbbt/lAAZsXnz6lxtQobG/t/ygyjV6xYHUZ7KOBgEdqzdjYspvDQNAeDiDVzm8i4fc4mDkZAqTYwQocKh5Ejoxi3PGeCLk6LTkrAEq0ZGZl64YSfhHKQxr62Uesof5tADpnwvhdsd3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:35:02AM -0800, Suren Baghdasaryan wrote:
> On Wed, Dec 17, 2025 at 4:27 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > This function is confusing, we already have the concept of anon_vma merge
> > to adjacent VMA's anon_vma's to increase probability of anon_vma
> > compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
> > as well as anon_vma reuse, along side the usual VMA merge logic.
> >
> > We can remove the anon_vma check as it is redundant - a merge would not
> > have been permitted with removal if the anon_vma's were not the same (and
> > in the case of an unfaulted/faulted merge, we would have already set the
> > unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).
> >
> > Avoid overloading this term when we're very simply unlinking anon_vma state
> > from a removed VMA upon merge.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

