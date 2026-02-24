Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BADAE9B269
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE29F6B0088; Tue, 24 Feb 2026 09:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66C56B0089; Tue, 24 Feb 2026 09:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6326B008A; Tue, 24 Feb 2026 09:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 736C16B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:16:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF4FA1B56F8
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:16:37 +0000 (UTC)
X-FDA: 84479550834.03.17380A5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 780331C0012
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:16:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZnnVdiih;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Uc61t2sk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771942594; a=rsa-sha256;
	cv=pass;
	b=IDL9rxbxt+nXCKGi5aAVHBQSlFYscwJE7nmLF7eJMyOV9n0EcaB96WSO7r6XR6joLeKY3v
	s8JRsRuIv6DcLeqebjMUS3ztENOs9EyRBXnkUoy3Hl12iEcn+gtSJrpfPBA9RF9LaT2tDe
	BktaRtgHsq26Tns6cpV4KCxMAj48fGY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZnnVdiih;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Uc61t2sk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771942594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYU08FmcSYVxw0173XHxsmNZWsZ/kS/qEA2/WsyoArs=;
	b=joVgm4kZG4e2wsShCBtKoSS5LdBclEDO1ru2M1SLDq6VEys0M/lJnmwJfFKzUcVM1SvvJc
	NZshISGlgXkndKI+aIvojjLUek65aOE7r8D5gDRWG3ZRkBuiKP2vuJK3IRTbIz9QX9QEuG
	57GL7gKbBPPO1uX17o+k4sOz1HSquzs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OECOtD1476045;
	Tue, 24 Feb 2026 14:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pYU08FmcSYVxw0173XHxsmNZWsZ/kS/qEA2/WsyoArs=; b=
	ZnnVdiihyp5d0WSLM0ptewDyaOkZmz2ePEjeGTx0VuiQnRL2xhvidui97AZ39kg4
	5PMfsEqPDqx3dHPUt9l2O5iCupAMXvMLESKjmjPfxoiNQh9haQTjDNZV0M/aDOJN
	t2qZpKIR7EaCr4HF20gWLedw/gNo+O6hv9P+JuYwXUOibi0sQs/doKUKJhp8XN3n
	GapenKt1s53oQThHFNWn8vVIREx3CmvXC3oAnbD6uhMxpxFVO8nxZ6OvvYG1XSso
	Cbfjd2WufEnOYaxYjyP6nS39JK1qlvqDeyMN0b73vqUw/0+rHDlKcu7vSeBs45Yk
	BDNS/HJciz2a+8ag1Au1+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbcayk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 14:16:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OD5l2r028662;
	Tue, 24 Feb 2026 14:16:23 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011017.outbound.protection.outlook.com [52.101.52.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf359rktv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 14:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BeORt9dfZA/L9SO18vZoo9AVhPqwAOn4EM/eqKu6hlIfzxBlYQP28+5Mr299m+pHbDUvTSiDmqgNWgfvEfwjhdrcqzKvjBrJ6F6NoInkHqgnlmLFyQRYj6syAFAdLm90e7maX84hhyDifexW80xh4OOuWbsNHpSDVUxEaOFGI3ucGrddIIuzw03PGbJ3T/QQWqMV6ptOc4ZxbuUKBI0OBmnDIhgqV8+oiD79GuIdEjZXjaJlXVzNRX8iOf0A9ZAQ4Gm9LO7v7GPopRL0/56UCU+X0BqWrcX8HWk8do2Kjfb3SzVX2EJ3xk9yQz8zkVbzZZCwgjsLrlzEkZ2o6bIBPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYU08FmcSYVxw0173XHxsmNZWsZ/kS/qEA2/WsyoArs=;
 b=hcvBuXuCgULJzi6k9enT1c96VNUmxAclX9nOlkgxtYNrJYOfHrH/+t6r+EYVMFJWbgg5o6ZNhIYzA4rRJH37fGDdh7UvBQCYgPGn7zzrjs0DzYOvx4vw9artqu8bkb5Eo07pldaiMURsg2DhImHP0hrSXprIB3D/gaDrUd4C1EjpJP9TIGW19La6fvvP97TGFQ569HNNA4WGs2Md0N8UTEKNzq270ZLQdy195GsaDOJK/WbTt9cWCCWLG2rgbPk6csxQdUG8IkwG67E0YaimSYgt7ccTr4S6tZuDjtCamdK1+O1RZ7gH1TRvO6dz/7Bp9VkKlirt2DXJ4E+Czx6EFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYU08FmcSYVxw0173XHxsmNZWsZ/kS/qEA2/WsyoArs=;
 b=Uc61t2sk0MnBlGwt/Gd25MXv08Sub9G4RkVQK80xy4UN/+JdsG1M8LZaPywtAf5uKTb76r9tJQYiR5qdbilSwjUThiiMQqWBs4xIJFgqfB0MiVg8FqI/ag2q6WjG+/9U4IDhZHnDRzsTETMr3+/ZyZ1hxsR0XY5w5PccYcLv7aI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PR10MB997647.namprd10.prod.outlook.com (2603:10b6:8:31f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 14:16:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 14:16:20 +0000
Date: Tue, 24 Feb 2026 23:16:12 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>, Vlastimil Babka <vbabka@suse.com>,
        vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during
 boot
Message-ID: <aZ2yrEz2ZVggT7UL@hyeyoo>
References: <20260223155128.3849-1-00107082@163.com>
 <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
 <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com>
 <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0104.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PR10MB997647:EE_
X-MS-Office365-Filtering-Correlation-Id: c426b518-9b3a-4a78-4805-08de73af4833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzRkY0lQNkRrL2hYK1ZlZmpJa2hCMXdVNHQrc1IvelFQYUQ2Sno4THNCS2Ey?=
 =?utf-8?B?ck1mL2I0ZlBnditoME9kaldNY1M3SjJWQ3FVZVVFbS9qTGdDcGR0UHBSb1lT?=
 =?utf-8?B?amtnMVQvSFFkQjZOaUg0bC9OUlc5Ykg3NWVrSmpsN0RDRHl4VnBLdGJXU2N5?=
 =?utf-8?B?ZlJvZXhjSXBua0QzQk5XSGtHbVRwb2J0MGlFUTF6MU9pdkFlOG1SV0Y0NUdq?=
 =?utf-8?B?ekdIaGNOL21ac2U3bkRtT091KzhNWWxmd0VaUTdKRGNWcUpOcDFnNldZTXRM?=
 =?utf-8?B?eHRoTCtTVTIxSlpQNVE4MnhLYndZeEVwMXBMLzF2VitnOFNuaTdmNmNlemFo?=
 =?utf-8?B?aUUwTUN2cVY5UGhWb3A1bnJ4WDl1N3hXdlljM1RmM0V2TnkvOHcyTzRQdzMr?=
 =?utf-8?B?N29qbjRvM29QNi9yNVgzUE5HNDZwdmJuT3RJZmRVRGpkbU9TS20zbTVkV29F?=
 =?utf-8?B?RS9pcUhpSEVKeTBLY0pIWlY2YlkyZjN3VUpJQUIxcXVESEpCUVlQb1dVbmc1?=
 =?utf-8?B?ZWdyRGd2ekMzZ1JXWSt0VlFESlRndGxtZy9jSU9zME8vcThNMjVTSi9IRDlO?=
 =?utf-8?B?MEM4ODlPbnpLMzZERk55Y2wxMUdhd3BaOEFtRjJZVUhHSS9UZjJKZjIwVk1W?=
 =?utf-8?B?cU1HWGIwbTRnSGxXdC8xeEM5b3lFbjRpYktwTkIzZXJoZTZRMEkvMGMydEtV?=
 =?utf-8?B?UzNvUnREZTZCcnlWdjlhSjhRbkt4MjlWamF4NHAzNitLSXJ0M1NoNkkvNDll?=
 =?utf-8?B?dUt2K0RYVHJpdUprNFlZOURwaDhRRTJ6b2VpZnY0SzRpa1BEMkdTV2NleDJG?=
 =?utf-8?B?d3BYV2xDZktPSWpLQ1phdWllUkt5Rk1ibmVJWkptb0dXb2xBQVR4enVRVUpl?=
 =?utf-8?B?bVpMc3RBamhRUmh6NGJEdFpVM29UWGtyTUxYWFZZTUJKV0wrRUdYUmpQRzBr?=
 =?utf-8?B?SXM5dlFqWkRoYUVPVGU1dnFMZHRUYmsxMkFJQnNobHU0YTl5bi9vM1dMdVBj?=
 =?utf-8?B?WkkwbEdPOEdsNUlyQ1NhOHM0MDFMb1hzMmIzNW1yZWkrTnp5djV2MzdqcFdU?=
 =?utf-8?B?Q1JtVXk5N05heHBCY25Rd25Oc1orRndXL3dDLzlka3VaM1FDMUMvNllLeVBq?=
 =?utf-8?B?VmRYRmNObFFCSzJiZVNJNmhtMEFRK3N4TTJobjBHRUxScEhnV2plVTdXekxo?=
 =?utf-8?B?dE9JNjZKTWM3aWtlZ2xYQnVrR1UzczBjMVVvd3Z4Z1ZTTVE0UTBLWGJzTlll?=
 =?utf-8?B?ZzZ1aTg2YWJ5WkZJcDBqNndRVmwwQXVHblhPSFFhb0s5b25xK0c1MFI0UG5U?=
 =?utf-8?B?TSs0NWFlTW5ocGZXVlVtNjBuMFUxKzJjcUJkczdCN09aVHVKdnJCMVFBZjJJ?=
 =?utf-8?B?R1g2MWdWclcwbGR0d0tvRTdTZXZ6Rjg1ZG1JbTNXb3ZuU1gxODZuYlZDU2Za?=
 =?utf-8?B?SWc2dGd0ZUc4Ujh4a2RNUkNZbnZaQk1WbytuS1VYcHhJai9TMk94TEJtTUVD?=
 =?utf-8?B?SW9xcmhwY2xkeU1od2JFakpUQWl5T3lxbGs5azkyQ1lETmhzbFJVWFloUVly?=
 =?utf-8?B?WXRQQXViVUFHM2lVM00reE10akpBUFN4T1N0WElpbTZoOWMxcUhXMytyOUxO?=
 =?utf-8?B?c1dhL09uTFNLMGZCamtIRUpFdzBNbmxmZDZUK09pRzhPZTlqMWxRb3M2UXhC?=
 =?utf-8?B?K2dkSG1OdjQrdVREWTRkangzd2dqMGhDNnVaekFLa1pWKzREMEJUTWFHREth?=
 =?utf-8?B?SVVmRG1DejZES1RLUGUvQXhPSG1PZnNvRTQ3RkxOUDk1d3lkR0ZMQTl5blI4?=
 =?utf-8?B?bkJpZjRUNUFKUGVtN3h5TFJ5RXZod29LUzBjRlBCSFgvb1NwSXVmMXZNYktW?=
 =?utf-8?B?QmtOZVVram9hQ0x0bEtvNi83dGl3MGI0bHo4ckVza0tvait2S0g2djNlUTBw?=
 =?utf-8?B?RGJVeUJEUHMvOGl1LzRXeGVVblJUSzJqV2xuL2Z6YjRYNGs0Ni9LSG1QQkF3?=
 =?utf-8?B?UDAxak5YeWduUVcwNTVxL25EYmg0QVkxaWlDc05JaDcxRWJYdE16Y1V3Zm0z?=
 =?utf-8?B?dE1aT2E0K0xvcWZDWUx4eEFveUhkZmF4NlR5bk1nMnVqZWdrRUxBZVREUXp3?=
 =?utf-8?Q?8w7g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVFESWlhNjhDL3p4Y2Q2NzBWaEJkV0Q3QmsvS0YvMktxNk4yWS9MNlVrbDlE?=
 =?utf-8?B?N1BrTEtrTVJkbnBPeWFDWDQvMGlQSFFiRXVwRGtkU2RGM3YxWWU0ZkdSVVBx?=
 =?utf-8?B?WGdmM0hLdkw0MEN1clF6SmZHc20rN3ZHSlNURzJmcHl3Z2Z4d0VJSHpOVldB?=
 =?utf-8?B?Y0Y4NllueDlXSm5PbEVvTExQOU1iOGlwMTdoMXRwa3dMNTc0cUwxdTYzTnM5?=
 =?utf-8?B?QUxENWRVUWhLcnQ1d09zRXJ6eDk0MXVwSWNsejZMZ3pNL0pPaFliSlN2bUUx?=
 =?utf-8?B?VkRBci9oUXY5cmRJdWZiTHI4TFRQcXk0bXNLZ1dUWkdBUkF1OU5MUm9oVnFX?=
 =?utf-8?B?RU5qc1NRNHR1dFluRzlzd2dWT0JzR0dHWkFIcGRXVmx2NGY4bjBPUGpTNFBh?=
 =?utf-8?B?YytuYkVmRXBzZldGR3kzTmhxU3dTdEV1SzVMcFpZVisyLytxVkJnVUZ1cmh0?=
 =?utf-8?B?aFVTV0RuQVhjaFNCR2gvRjkrNmxhcmx5dkx1T3RGYnFYbVc1K21EdjN1OCtY?=
 =?utf-8?B?UkgzK29sM0hqVGRia0J2UmJmK3ZrM0JtTGxFMU9kWnU4UjFGTTV5bUVOR2xj?=
 =?utf-8?B?Nm1nZVlUTDJDTG1lTHpkNnN6TG5sRUw5cUpodTZzd2R5cWJPK0pBdXBuS3pX?=
 =?utf-8?B?LzJvSUFsWkVCeUtZdTVFL3NQcWVRaWZ1MW4walpUMFZ6VDM3d2NsQ3RQVXpw?=
 =?utf-8?B?WXp4VFJsRXNHVS85Y0hFVE1sREVRUythR2k0aWw1am5yQ3pmZExxU2drZW5F?=
 =?utf-8?B?UnEzRFdKQjFpdmx3V09pUjhLdEpieThTZGRlNXRHNkdJVGh4c2FPTHo4K3R3?=
 =?utf-8?B?elR6WWZpVTdKM1ViMzMyV21SaE1DODM3c1oyUWU0akpydnBtUCtFZit1WGtV?=
 =?utf-8?B?bkZjc2JKY0hHVVZhcTZzdExqVU1lcVViNDd4VkRtYTkxcGR3cC9ZMTMzeSsx?=
 =?utf-8?B?K1M4cUpyaUIzWDEvbnlzd01sSFlFR1VFRlNaOFByVHovWUdOS1J4Qm02SGlZ?=
 =?utf-8?B?VDdWdE5lV01TSkZpZWhqTmpGSlM1dFNRUVFYVVg0N1JWd2phMEk1UVpRTWxq?=
 =?utf-8?B?WU1XWXI5eUFaVWJ4WE1Pa3NFdkVsSHBLM0VaekdISlNoZXl0L0tET21TSkFl?=
 =?utf-8?B?WHIvNGl4UzVkOU9UQm1ZYi9tbHlENHBrQWZVbG9yOXpWK04zS0d6M1JvNmZn?=
 =?utf-8?B?TjREOUVFL21JbWRHVklhaENYeERwbUNmVnlPQjV6ZDFkVGloRld5ZnpRblpF?=
 =?utf-8?B?dXVuNVNOanY3UGRlVEQramdRY1RDdjBhOHErTXgxR2NMOStKQWZYNXYzRmRv?=
 =?utf-8?B?cDViaVZUbzlid2x3TEpGWmUrSFNqeFp4M1R5bDFYNmkwM2ZFaWZxQ05WYWp4?=
 =?utf-8?B?dDVkNDRLR0pDUFlOcnNYQkxSTTM4ZHNRbzI3c1JTeGFEZi9ncDVwSTB1cUNm?=
 =?utf-8?B?Z0NpTW1OUytSY1VQSExZTlczeW5YUWtkMDBFdHh5T3VrK3FMVHlJcXJkRDlC?=
 =?utf-8?B?eTkzQ0JNWkFWZHVXSklSYy9Sck1RQXhEbEhhQjNlQnczdkxMMTNYbnJhWC9S?=
 =?utf-8?B?NHh5bGd4SnZTaWxKdTNaMlVhc2YrTExkS1FzNXpreEZVWTJ5U3l1UVYzTmdU?=
 =?utf-8?B?NENhNVlHZFJScnBpMDRsWklSOUU3eUlJclhWZG8zd2FmcmFpMURSb3p1aExB?=
 =?utf-8?B?cHZUNjNZeWd1RG96RlBKbjdGUU1oUFZVbjlWaE1JWHpDSFNrbGZUMmhDYVJo?=
 =?utf-8?B?RHVxY2NjYnhQdHk4RjF1VnlucVowMjNlVll6V1hiZzVNcDJ5bGVYS003RjZ2?=
 =?utf-8?B?WldBZzNNc0NtM3pFamNMRnRxYiszVnVERzc2TkVNN3lMWThXSVNnQWo5OFZt?=
 =?utf-8?B?RXlNak1UVGJnYVE3b0ZlODFFUUI3NStnQTVxU1UzeWZMRzdxVXpmaGNYMzdq?=
 =?utf-8?B?T0tSektCOC9POGgzZXBMRVlJZHFtSmFEcnZiQ1BlZTk1aFFxTThka1BZN29q?=
 =?utf-8?B?SUpmSytvcG1vK0x0L2pURGw2UlM2NW9zVXAvYjJWTks3S2JkNHphTnJWOW5q?=
 =?utf-8?B?eGlYUXJETE5acUorM25LbzExM0RybmxIaXZRZkdjSERJOWNBeWNZbVFLc3g0?=
 =?utf-8?B?Uk1jNUtpeTBLa2lUeEUrUHRXelRqWTZYMk1GYWpRTWsrMEczNWhtYVhiRHd0?=
 =?utf-8?B?bzNTMlRaL01USjZnbXNSdW11MzlUY2gydzNWdmtnM3JTaDA5RnpoalZmTGha?=
 =?utf-8?B?NHV2aTZBR3hFbk91cm9hK1dVWEdBUzJSOS9UREMvMjdpcnBiZHVZV21Udlhi?=
 =?utf-8?B?bjVKWHN3RUhVQk5tNHNSY21MQjB5THVHWm5rR01hSGt0d3plbitsZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/6O3LaJkKCH67mrDpu4lghqlseJ5ZOvZtgf0/xzGtaTfy536wcrSmCyOVSXXB8u/rveRt6bzSh1kkcGjU3oyRG1a5EQX1p9Kittjdenw9KUrRczdB5kWPzt361sprz2G2Ac7RrpFUQhKwLSFUP7LFxE8H+BGkCNtiY3xPmTrtxrRTU4TBm8tHiZ3Lqcz5sqgsJ9w1tjwqa6tcyzBoImjYVqFGQmSebYbXKQnUPa3gH7MuofGbJI/ftpC+lh2Ar3zsir+WICU9leNRoixd+nq0WWPo1VuSP6getz1JTb9Yzv4j+XdG1PmuBIqqRdd2cN6p4x4E8nEsUemsbzobqKSgzFxo+itc/P7JZSbTYW/g1m0+LQt8AmSsbNAC/rUYhRjlNlvnNkTBktZ6A31HkVN9+z2Ytl+9W3A11o6eVZ3pBFrM7/JWYIO4TWhb9LVsKIYq4Z6VCcwgSmiEfLkzrdFGZRdWXYkPu7jKzRMETFc7N5P9k2LRLnLR0PwJyXv2H1ZtnQJGt5ASb0GbNr/LJegq3B8pXk9HJFxu4VBy1x4q6FhhHyK6ORSvHy6LRUKK+eN8fZDqGboy8MoyXDTBVwDmhR2haZzPp3DMiXkziia7Y8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c426b518-9b3a-4a78-4805-08de73af4833
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 14:16:20.4850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Avl829jR0zBCrSEEu8EGS3Xy7q2mY6w0cIfpw1V9kn+PLch8XeYvgS3upkr651sl3oTkMzBx5MeN+Zj8p0d6GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240117
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDExNiBTYWx0ZWRfX8MvVG2ocCqx9
 uvmH50zCZENmg7jyZVeFfPomCGi3+CtqMeNToJqsw59j00vqZPKE/5oGHUc7LFhb5BQJdJaSUk3
 kNSvneYtECFgXvT0fU+iuxs+tx9Q8/SNeNZ/+3fLPlUghBXVw2r1fw2jE2DigZyLb6w/ffCuWIE
 4VCY0i693s74VzoYXz7c1gbNjBoknQRH6nqRt6+XtM7pBrFQyKkCRnjAQIB1NVfmfWJesO8pJQU
 NkJTxYLmBzm6qfHWKjORNqJL3l8SImFJssF0Rvj/zIJ1q0L4GEFXqOEcp0aa+068EC8dj40gsx3
 jnuvSjb/oz60TQnL1cZVGpUZQyRdx5UwwFeSZyxgipXt0WquReEmDEFBdsUSbNP9bd0xVpw6gYl
 c7WbUdkxk2K2cF3egPZ6RatqDu4ISkZ6ZJZUVJ30RRbYdRgDF9Jdyv01WYIGl4SXIBuemEhS+tY
 UB8C2qCx6qgCO+T/1MA==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699db2b9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=Byx-y9mGAAAA:8 a=iox4zFpeAAAA:8 a=nJco51Lk2zwWpS9Zqo8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: YJ4EGV0sZi4X48G8KDPGVszfKrXquiHQ
X-Proofpoint-GUID: YJ4EGV0sZi4X48G8KDPGVszfKrXquiHQ
X-Stat-Signature: unekg6nxfbkbtcmi66pueuconeuag85k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 780331C0012
X-HE-Tag: 1771942594-806823
X-HE-Meta: U2FsdGVkX19iUXREC/N99uJN6u9a7cTWQmbmLuLXFMNfonVVXuj+TorU74c6eqxo8dfgnramDI0Y8VbK1wDb2kX4ygUSqV71zACSnXU2Q09RGoqcooabxlabJOfF31+WhDgQBoF0lSlzlgLg+NY5VqrxGyZ1OIAA4DBIXAOmxZV8dz/wdI+04djpXAhksEhP8DelZQGBfFPtf+vWxzpUkR0vnwmTtVqNJGRry/4a2atBxB+u6ZfxwNK/GX+85OzKHhL9SwM8eLTLooWYHUtrPfb+8glN+EL0U2RL9t5lUDp4qzNzg1q3bvOoWW8TWXcxofbxtqyWQ5DmkEmZ6ZIYPPrzaLRBueNKsIFU6jdS/Sf0VcZJze0K8rtTpwrU0ydJcpnDa80nw5Gbz/prqHAUMgW5Mpkn3fkf0jv9Rc2FRnXH2E0ekkyeazPblUADRl9rfl0mtmdS7k2n3hvofx5I+FPIHdAN7jjIIInQ+bFnr7uFy7GMK2R8GtlPzGVCVx8wjzPDNQMSneZXsx3QLTCEZ7GoXaH8m0ac5evVM1Xs6X8pUqHU7ehzMJWZzmVFDGfwhbQfog0f6KaEdw21FaYWpG0jA6k6sZJPPU3poQYU3yTU8q7VZLgl4ffJYrRN0T+mfamJps2YG7WzAhd3VUDgCpaWNh+SfovRE0MoYNGrKOAaBqlRuZkfIE3sQtFA6sYa8t9ZDACyaOOLYGT6pUsgqcqusLI+qMugXPfUwn20lYpiuG9zAJaOAuNX361pL+NCe7O/j9vG9FiRy5pFO9r3ydsgDS52UMBnakmZUhxDNqrqvPCblUntmdRslNjkVp9Ivgt6Zt/v7Tu4U5Ctl5hWVPHNNxWHekR+C41w20uYGelVegof9IE+IwIOgwLGbZrBqpxWcbJWhLQiuBHmcr3IlQAP8/e/SX1BsT1mUDT2+c5zASF5uG/+tq6jmogvqfjBaP09evAfldH8CrBdjfZ
 gaCynN7i
 YBXTEbaQ2YKGdn1djMutwFAjJM8+aiPKsuboecXn5QkAoWxSBiCjtKb/Dl5OICg3lZVIgxSFA9aljWM0XID49WNnoc1YjOeX0Z3xPGX2FLmZAxzJSalMoPs5AkaFY3+5esuE4MiX+dj9L59qVQ7lz3MnjsfXIqN3E+aG47oFIT4PwcEtTVllB4bnX6PXMtTexJ6lFMWq82mV8glXTw6FjyVBeMl5O+cB+IvVv8Zp5s34UfjDZ/dx5StwUMuetXZFrYmJmHQuWdwTs4xd7Sm4mdsQ3B+FCN4xOhYfsjSOcI+LrpeOqANtSfaN1tgNXz3Vwir3BSa5LLFrIqu3CXOVgywUmD9pJlCgy+GXmNLlbhm5h4SdGTtWRqTk7lt3OUST2OXZkCPYqJ4XdSRz5RLe0y6AXa3hE3Mb+DIzPcx9vKuuRKuQ526/o45gx7QpBU2iVipxz+K/NoOMqd4Hk6nnNEW5KUFs21FNaNpxhSyDhvNqW6+IM67Cc1VPXcBAJcKHKPf0oAKhWH42FHprnHNvv6VcB4y89c7UCsXrjm82U0Tyn8DUNH6y4vSSUriHAAhOmtSP965/5PsBEarbjyIV/Ion18+6kFDOKjLcJlsr4iLM+Naq/I/CNV2wMlOwaQGf0DxOOf2C5oLvzJ7WZHQRL3LKs2ZIeMYAePHAo4cXGyZz/MLKf48fgTmGgK1s07k4br+JLdhCUgm8KQAh8qenDkSWq4Ca2h5Ia66vxcWqSyzKosdG7bwFmK1J4JfmiwMmHsujDXx2XEV8ZsmZme7Lpbl9FtZqhsy7JSXtm8Cw9MgzSdGoMNlguXUruIMCbTwxlPGhk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:07:08PM -0800, Suren Baghdasaryan wrote:
> On Mon, Feb 23, 2026 at 6:28 PM David Wang <00107082@163.com> wrote:
> >
> >
> > At 2026-02-24 01:18:32, "Vlastimil Babka" <vbabka@suse.com> wrote:
> > >On 2/23/26 16:51, David Wang wrote:
> > >> Hi,
> > >>
> > >> When upgrade to 7.0.0-rc1, caught a kernel WARN during boot:
> > >
> > >Would this possibly help? (it probably shouldn't but let's see)
> > >https://lore.kernel.org/all/20260223075809.19265-1-harry.yoo@oracle.com/
> > >
> >
> > Hi,
> > I tried this patch, but sadly, it doesn't help with the warning on my system...
> 
> Unfortunately I can't boot far enough with your config to get that warning.
> 
> You might be able to track down which allocation does not get its tag
> by first checking for current->alloc_tag==NULL inside
> __alloc_tagging_slab_alloc_hook() and dump the stack if that happens.
> If there are no hits (which is probably what will happen) you can do
> the same while checking for obj_exts==NULL. I suspect that condition
> will hit multiple times and one of those will likely be the cause of
> this warning. I'll look into this more tomorrow if the cause is not
> found by then.

Just sharing updates on this before going to bed...

I was able to reproduce it on my machine I have a working fix
(nowhere close to upstream quality, though)

The reason why we're seeing "alloc_tag not was set" is
because SLUB allocates empty sheaves for kmalloc
with __GFP_NO_OBJ_EXT and it doesn't teach memory profiling
how to handle this when such sheaves are freed.

When __GFP_NO_OBJ_EXT is used in alloc_slab_obj_exts(), it later
avoids this "alloc_tag was not set" warning by marking alloc_tags
empty in free_slab_obj_exts(), just before freeing obj_exts.

And we don't handle this when allocating freeing sheaves
that were allocated with __GFP_NO_OBJ_EXT.

Passing __GFP_NO_OBJ_EXT skips 1) allocation of obj_exts,
and 2) alloc_tag_add() even when obj_exts is already allocated,
and this confuses memory profiling later.

I'm adding the fix I have now. (I guess Suren might have some preference
on how to solve it though)

  1. mark obj_exts allocation failure when slab has no obj_exts and
     gfp flag has __GFP_NO_OBJ_EXT, so that a later obj_exts allocation
     will mark alloc_tags empty.

  2. Set alloc_tag when obj_exts is allocated available,
     even when __GFP_NO_OBJ_EXT is set.

     Because it's already allocated, we don't have to worry about
     recursive allocation.

diff --git a/mm/slub.c b/mm/slub.c
index c7c8b660a994..4dbdfcd46771 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2060,8 +2060,6 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 			return;
 		}
 
-		/* codetag should be NULL here */
-		WARN_ON(ext->ref.ct);
 		set_codetag_empty(&ext->ref);
 		put_slab_obj_exts(slab_exts);
 	}
@@ -2361,6 +2359,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
 	struct slab *slab;
+	unsigned int obj_idx;
 
 	if (!object)
 		return;
@@ -2368,26 +2367,36 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
 		return;
 
-	if (flags & __GFP_NO_OBJ_EXT)
-		return;
-
 	slab = virt_to_slab(object);
+	if (flags & __GFP_NO_OBJ_EXT) {
+		obj_exts = slab_obj_exts(slab);
+		if (!obj_exts) {
+			mark_failed_objexts_alloc(slab);
+			return;
+		} else {
+			goto tag_add;
+		}
+	}
+
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, object);
 	/*
 	 * Currently obj_exts is used only for allocation profiling.
 	 * If other users appear then mem_alloc_profiling_enabled()
 	 * check should be added before alloc_tag_add().
 	 */
-	if (obj_exts) {
-		unsigned int obj_idx = obj_to_index(s, slab, object);
-
-		get_slab_obj_exts(obj_exts);
-		obj_ext = slab_obj_ext(slab, obj_exts, obj_idx);
-		alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
-		put_slab_obj_exts(obj_exts);
-	} else {
+	if (!obj_exts) {
 		alloc_tag_set_inaccurate(current->alloc_tag);
+		return;
 	}
+
+tag_add:
+	obj_idx = obj_to_index(s, slab, object);
+
+	get_slab_obj_exts(obj_exts);
+	obj_ext = slab_obj_ext(slab, obj_exts, obj_idx);
+	alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
+	put_slab_obj_exts(obj_exts);
+	return;
 }
 
 static inline void

-- 
Cheers,
Harry / Hyeonggon

