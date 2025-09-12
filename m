Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0A8CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 11:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0538E0005; Fri, 12 Sep 2025 07:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B910C8E0003; Fri, 12 Sep 2025 07:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31C68E0005; Fri, 12 Sep 2025 07:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5848E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:57:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58BEEBB32A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:57:12 +0000 (UTC)
X-FDA: 83880447504.09.5488B1F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBB22180004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:57:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X56J3VL1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VNI/xjpG";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757678229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=av9MnG38nxwhbJzmjtb4Uoh5a6qLsfUABFNvfqZ+fJE=;
	b=W+HrSd85I53mWDpA0TOUvyfOursH9Fb2LlyLGBL2cqkgVMF0TtMPzKjb9WqMRMPeuEtum4
	SXPGAaAur1CRx+zvb3EcvJTz6zkgWxyAASVafvXEuS3GDpci2aX0C4aLx8bW1bHNoyHnbS
	61ItveFA9Ulfek6LQhVPTEy54HvA2pg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X56J3VL1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VNI/xjpG";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757678229; a=rsa-sha256;
	cv=pass;
	b=5QJq6y+FvOAp5EtHyuV5wVHdZ+64yBMoBn4ka0ItbdLlaoSh8DV/eK9LBX7RTCYsclNkQR
	lnmy4PsjQlRWg9B9HoVzFJEYTM1dH1InwLoZV/15uK7ahqFH0Tz0uXJGnNYvtTcQmyViyX
	ISwJ2tif1Gv8me0a6L2t3lReRohaMTo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uEow022712;
	Fri, 12 Sep 2025 11:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=av9MnG38nxwhbJzmjtb4Uoh5a6qLsfUABFNvfqZ+fJE=; b=
	X56J3VL1NnfAV4RAcV9ZdcNc6JBKZwHoimIaIvLHN+Bv62I7l9+PmQKDcMIn2Jv+
	PUnX2nAwRB/hoZUtdec8qS4pr+iVmKMoFIbqg6Bg7ik4uHPJepXjBHEKkLxKAPba
	9nRDjTG/33eUG8uyqG4pSUdR49/NEnC5Bw1UqT1ubsh3mY12gPwtqbjE3w9j3w+E
	JtB94BVLdFKf75eTNgCdQBg7UFFVk1rSVXxcxmQBgN6dIow+UAXiHgT6tX+mhHjO
	1VDNZgyOsYxHsL7M+nibbgCSYSR5nn2l7tVrM2XtR985gTZcM0jyIS9IhkdvVQS0
	2KuOka8fl2jNSg2ShZKH9w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921peg3cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 11:57:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CAoEwD013563;
	Fri, 12 Sep 2025 11:57:00 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013016.outbound.protection.outlook.com [40.107.201.16])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bddy1vj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 11:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JnrsRW74Zb0pLLM7qUQ781ny86X3qo7QV2iYc1w0rZ4W/M588aFzmijt7yDJuii5yHYJJjHJ9NcGNB/3Thogq5so+SrjYj1USWM0Nj6vFdL1li51HrQKl2aYJBwWg6XUbF+f6dMxuDcMwR7Z8Bqx5K5p+Mfi/XMrTxZewaZ+9K0EAL4y6edkzOUNNQEIjaBt0hHRydAPeE2ZVXcAe2BP9uzLtnI9x4xQZ9zPty93WnELT8KpoMjpoRp0eYeapBeaAdLCU8TaawIAg2wNjsGqmYuoZDN/TgcU91nXxAxduNuLZQIhW73b+GzFLOAYPUFBJCStA7yUHIIrUD9XXyaT+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av9MnG38nxwhbJzmjtb4Uoh5a6qLsfUABFNvfqZ+fJE=;
 b=TLJuP8HyppDgJhbkJo8c5F8JxheP1OS53wkyelbI4LwN3MlLfgFwlXKchmhhbnkMElVZG0RQ4gCqC1feDqsmUasOgZtTHVIgQhvuT7BYOe15D0mu+SiLnODJFrpVxD+bjt+8WErccTB0gAAdvernZB6nHH9X0qG8aYlJd59Ym9MtfCbBsX+ouKBj5slxnFebDvPPF0kgiYMGQoz0IGboBdI3tHg9u16VofjCTRYSIt7SD7yCElISdLR9BHMtfvUNWg93br0z1EbA6UzmhgUOB4AaRRxkrPWYgLqC7W8onn+zxwwSdFLr3P4WinQKYrKxssgoYuZEqUIPR/O7BlUFog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=av9MnG38nxwhbJzmjtb4Uoh5a6qLsfUABFNvfqZ+fJE=;
 b=VNI/xjpGOuIGRpEzAH6MmCtdSOnFfjDxVSgWeDAeACJXJwOSaKdwP20RbUD3T/75lny1lf8/t00dKd8Wc3HlPvOa/20w4toPC5ZqIGMD4vKJv1ILlvGFuPcpChy5N7jxpQ8wZSd+xScMwcMYOQ93ODzYVe1OMCPgMcwrYHN+81g=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW5PR10MB5764.namprd10.prod.outlook.com (2603:10b6:303:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 11:56:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 11:56:57 +0000
Date: Fri, 12 Sep 2025 12:56:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        Kalesh Singh <kaleshsingh@google.com>, SeongJae Park <sj@kernel.org>,
        Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <9fdce1bb-797c-43f2-931a-5e3115a281c6@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <a67129f8-9ff6-4109-bbbf-4209f6dfa3be@lucifer.local>
 <CAG48ez0GVWV024kPe6kSV8c0LO7coACYXf9-85iqw+T+paUi3Q@mail.gmail.com>
 <6558e0c9-fb6a-4f2f-b9e7-0647ff64ba66@lucifer.local>
 <CAG48ez1FXUMsvKEcJCFcUBUP0BM2=LTWzH=iKiHhL4PurN6q8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1FXUMsvKEcJCFcUBUP0BM2=LTWzH=iKiHhL4PurN6q8g@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0527.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW5PR10MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e768f39-8e43-4277-ba4d-08ddf1f3799b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHJ1cHBkeXF5dDJSYUVoSG1LaVZZN2hqTGJ1M0F4eXd6QWltMWZWQldDdzFj?=
 =?utf-8?B?SThSOFhyVy9CcWNRUzRURFNoK0xMRlNKWisyczRWYW1tc1dSRkFVcnB1Tko0?=
 =?utf-8?B?TVBDYWtQeFJMUENXNldlOGY1b0xXQUV0M2tHOEViM3BIRDEwcWhQS0V3UXVM?=
 =?utf-8?B?aUUvNVlxNUI0UC84elJMWWlvaHFhekYxbys5aVdHMFZlVGxkaU9PUkdudlRw?=
 =?utf-8?B?cnZkNmFJck9WTElQUCtSTnFieksvczlZa0ljS0U5SU1YNnRRY0VxZ1FVQlp4?=
 =?utf-8?B?SkNrWk5WbU82L3B5S0tOOCt1cktoclFlWmJIOEw1VDlKVDVLeFRkbkhtYXJs?=
 =?utf-8?B?YjV0eXhlMFFTT0EwZUhJSEFOeE9GUE1uKzY2WXRIWmpRckRrQkE4dHVyREtE?=
 =?utf-8?B?Uy9qeWNXZ3drUldRaGFKdlJqa3R1RnJPMDlBb2tweVVxNTVXYXc2R21JK2la?=
 =?utf-8?B?aDdXUGNwSnNXa1FtVjRQQUpPQS9kejBDbUdqeE5TMTRPc3RJUWRmcW1aYWo3?=
 =?utf-8?B?SWlmYkh3aTZGRDNWVXVCSHdZeDJ2a29nQkxQak9RQjhyL2FzU3hraDZGV0tI?=
 =?utf-8?B?TE5vTktrOTZJMkwwdnpnejRiVElDWUZEeUZIUGJTYi90MldnbVQrcSs5UDRT?=
 =?utf-8?B?c1dDcitEVngxcGVwblJhT0RHRisvcTM0TTUzamlnOTE4OTlsU0xxNWczNm9O?=
 =?utf-8?B?K3Bqd0JnOWNqUnVxQmRyQ1dpYUd5ZUhGYTFUamw3TnJsYTJ4K3dLYkltcEIv?=
 =?utf-8?B?bTZBRFp1NEVvdTN0TmFnalBxcnIzczNJZTZLNFlNL0lpdGRRN1FkVWhoWE9i?=
 =?utf-8?B?b09sU3VEL0hSNWVORjZWR01EVFBSTVlRRGhjY3ZBVFZqQmp2VVVWMjA4ZXcz?=
 =?utf-8?B?QjhJZlRwNHZxRDRNSkZ2SFVYYmlsVTd5TkhoYjVtVDRicko4NHQ0UlAySVhr?=
 =?utf-8?B?VUR0NzA4bGRDKzBncm9Rc2NYQXQ2OTVYelBIR3F1R2FjdC9zaGFLbHJtSW5C?=
 =?utf-8?B?NTlJY1ZGYnphZWZYb0lwUU1PMEFwWFZsekdyNE82NWJIVURvU1hEbGNCV2l2?=
 =?utf-8?B?VWZIZXFXcGxENkF3RUFhT215NTI5OUFBQWNnWEp4WndvV28rcDJtTnlISXNk?=
 =?utf-8?B?QytpbHN6Q0RFSXpGRE8yODY0WWRtWmZlWXpXeEt5WUhDVHFHWmZKbW5sUDNJ?=
 =?utf-8?B?ZGJ2cDBka1RLWncxQUxaUlZnTExacVF4U2lBQndHY3pLLzUxYnpRRzA1NEpL?=
 =?utf-8?B?Y0E5S29DZ1dreWlaeEYwWUluQ3N2NnE3RjNYbWR0MU5kTW9IRXM4RjFpMDZV?=
 =?utf-8?B?RjJsSjk4K2pjNE53VFZiOW1GMGxRWUhtdi9uMHdmZklpQ28yR0EzVnhFb0hU?=
 =?utf-8?B?VWJxemVnQ3FFY21jcFVzSlg4a1FZVTB5aDB4NkYyb1BCWUkzc1RtT3V1SHU1?=
 =?utf-8?B?M0EwdFBkTDlGVVlCMjFBZU8xclhjRXV3RFY2b2VMVmE4M3IzYmgyWWFtbzlv?=
 =?utf-8?B?YmJhWUhMU2NkckxxMnB0dXhrTXYwRFBNZklyOEpSKzZrWFdtNW4rV1p0UEdE?=
 =?utf-8?B?ZVovMlN6VjNuWkFINUVTdWNwNDZMZGRjMDN3MFZzb3JBZzlaM3BKWmFLNSt6?=
 =?utf-8?B?LzRxM0laVXhzbk15UzRZS2s5cHlZUTNScmhpNkNnS3F0dnRHNW0weU9DME5T?=
 =?utf-8?B?ZDJ6T3JuNXhYdWEzOHBYSzE0V0pZeFNPSVdxZ2JRcXFmV0gwV1dtSS9MK2Nh?=
 =?utf-8?B?UDlaZUNrU0Y0bCt2WUJRZVdnWG5PUUFGbExIdzdrUkpRU2NkSStsWUk5anM3?=
 =?utf-8?B?L1M1UlVtNWVRR092ZFFPZ1QvNE12SEVzRmVhNERTUVE3VGNtNXNtL2R6YS9O?=
 =?utf-8?B?WjFKMloyVVljL0UzRGFBQjloLzlXQUlUVkRzYXlzelcrb1pJQTJhTWc1azlL?=
 =?utf-8?Q?4fAS/9l33sI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3puYURVYTlNMzIzc1ZJcU9RRjhrT1lXbDRPanhhejd3RkV2QUVOOEtldDV0?=
 =?utf-8?B?Y2s4RFhuRWlFYmRrb0lGZ09tbnhhWHhlSXA1RHg1QzBRUmlEbUdRS3VPRmdF?=
 =?utf-8?B?U3pGd3l5QjhuZEtXYkZ0SFhnZlJLQmNOTXVaOGJ4b1hNbUdWRlFFUzJmSnBo?=
 =?utf-8?B?Q1ZaVDhNdlRTeUVMdVJ6SXFYblJPSzNtWHN4bEc5am54dHRleXRLNWNnS216?=
 =?utf-8?B?SEtPL0tJOFU1L3VHbE1DSTM2M1k5UDR2OGU1ckJQb2wxdVhxVGpuOU1sZWEy?=
 =?utf-8?B?OXZ1WWRVZVFqL2ttWnNiNnROTnVoK1FleWhMTW5Wd1Y5MGc5Mkl6dGhKSjJo?=
 =?utf-8?B?RWlFei9uNDBzNXdQZEdmazdSR0tQRDVFbWhESXRBTWdQZE5TTGtIUlpoSFZo?=
 =?utf-8?B?dVZYRHJ3eEhjNmdXb0x4cjFEKzU4UEVlSnJMbDNJdEhvK1FNWHBuTnRiTHM5?=
 =?utf-8?B?Zk9GdDFrSUMzcSt6L0NTcElyekhPNEVaWUxWdzM5eWVuMkZBWkpmb3V1dHRZ?=
 =?utf-8?B?dlN2eG9mcHVtcWQ4NGE3a1ZTMEN1d3VmWTNqZ0tBR0pLSEhsOUxMNHQrMGJi?=
 =?utf-8?B?MGora21aQi9VV003SDMxeG5NK21GRWozb0JHM3RYKzdiMDBPY0NCRyttUEZ6?=
 =?utf-8?B?Yk0vSXBoMGZVZzNFSHdRUWU3Qk1DcHRKWmRMV2YzN2VDMGViQk53aDFDSkVm?=
 =?utf-8?B?cnIwSnlHN3RjSGw5UHVmbm92QTNYU0wxV2ZKQU8rWnJaMXV1YlNiMEVLMVpR?=
 =?utf-8?B?VTl2THVLSndIOHZoeHNzM3gva1Y0d1BvVG9XME8rTUtsWVR6TkFVUDBDQkFu?=
 =?utf-8?B?Q0IvRURwaVlZdDFzbjlMMDNTcnl1ZWxjVVRnYVl4S0JpUkJmTk93SlY5ak12?=
 =?utf-8?B?SHEzS0lPLzF4WDJxV0R6T2dzd0FhWDhJUXVROHFaVUEzS0hHQ2NrdFpsejlw?=
 =?utf-8?B?Q25HNVVLNjhSWnVCNjlCRm1VMVdhcXlWZmxSS3Jpb0JqalVHbUFtbkVMZUZG?=
 =?utf-8?B?UFZKUmNFYlpQNWlGbWNoODU2MElMemZjT0FHTVR2ZFQ4c214N2VXaVluUFRo?=
 =?utf-8?B?ZDZHazYrQzhrSEdEMkVEYVRJeUhuUGlUdmNWbkFSWTREOWRraXBHVTdGdGpV?=
 =?utf-8?B?ejlRL0dzbzlCcUFUSWRsYW1WV0YxSlVRU0s0SFJjU3NLTW1PaTIwaVA0eUxN?=
 =?utf-8?B?TDVuREhHanZLdTJwTm0yMGlmbmpEbUNHMVZXeDRCbjdWUHJOaDJ1d01Zd3pi?=
 =?utf-8?B?YU41bmpvb3ZrTGhPcWRETXpDWWMrdEhQZVMrQzRKZGVEVGpqbHZ4WHg5dmQz?=
 =?utf-8?B?S2FxRmxSbEpURGtUREdTWTRmS3ZGWjhHZVpCNWgrc0pGQTNXdEFIZmpKNDg1?=
 =?utf-8?B?MmloMlFuM2ZpemdPQmhlZmd4a2ZnQmlENE9LT3k0bXFkdytZNU42ZjBJU3VD?=
 =?utf-8?B?MWVteEhzTDlQTm1nM0E0aENwaEtYWXhNbmt3dGNTNE55dmljVzYzYVpsZDkw?=
 =?utf-8?B?anVvM2E0WU55ZmdRbTQrdktIU3k4MURlaWlxZFFwU3NNaEV3MnJueHFWMEwx?=
 =?utf-8?B?alJDN1dOa0ROTFRZNEdxaEdZQnJ6b3V6YWV4YWdIRENMS0x1ZnNIWC9xN2tV?=
 =?utf-8?B?UmRkbVdrQmRxVUs1QUlvU0REUVF3RFRxL2xHZytnd0gwU2V5Ym5sQlMvVlVZ?=
 =?utf-8?B?ekhjNEhobHQxMHQ1U1JhamkwNjRtc1owRVFYb29VVTJubmhDZW1JYnAxUG8z?=
 =?utf-8?B?Sk9RbVZDbDdaSGlycVhLN0pSLzhnWnRBazFxc0hiTFVPcVFDcE9YKy9QQjF4?=
 =?utf-8?B?dVZLUnpVdWdoVkFzOSszVHBSQXY0WDBvMmlTU3M2K3pNcVhIVkVnaXdjZGNt?=
 =?utf-8?B?TGZnWXdVZ05ac0paWFpsaUJIZHBZT3NnbU5CdlVSWmtNRE5UVCt0TmpjYkVD?=
 =?utf-8?B?eHI4a3BTUUdFdlh6NVllaE1lcjdaQlNkcGVGNEhBbC9STWxmYXhBRkJTM2s4?=
 =?utf-8?B?YjFKL1JSYVpMelBidHFkM0x5ZEhnV0RFM2ZlS2R5bXJSYVVUQXMwUGJqdGU2?=
 =?utf-8?B?cUpJdVFvS1UvSUkzbk03cHRNU2N3cmVsd3BVbzAxdDAwS3piQWlCMjdsdjVi?=
 =?utf-8?B?Vnh5WElNKzZCU2JVN2JZRk15SFZ1MjZZdGZHV3BoOUFDTzF5UTRzQjJlSnFH?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JVkxCBIq/Zml62XFI9IxamQf+rAx8RsohlWxg7di11xikbeWV4ZRR7bNWFPY4wkUopNmSpigQxKwZo79y0U/8Q9QNNnNXedrea/n2qx8J4JE3vND2fyy1JWjqK3KXoFnIyPRTC7qJ+PEygExmXNwRc0CXa3vgOTthD2LmYCqE6z8cR1NTgj56uV2HOqn0mJ2b+WWtnPLwoycfofEMOzG0Hqni3UzpGqeaKzx6ArGG8gcQgm+8k6DwMXuAEFbyURVS78n8e7veaHPXc30U9ZlqrXammfv5SPmkvAF+TXjoXrrf17Z5RO9ruMCPZ3uDoojOfzVJF44dhMeKE5llMQ6Rm7QZQ5uQiIowI3STPH8PVjolfM68YHzTGF58//H3GhSPsxenm1dMGV0QDCRj+lA2f8O9MwaMcN56rJwCjkrv+mITjXmFSf5cbWhifnLb5CZVdRduWx847bocdriACbHB8UN95FEDnV7u0cClJFfrCKzNiu3fVVz196PbxkfYJPB3C/VjUZH/HHU5D1mEyrHsavEe+LZGb5vD60bJl6jIT6vkIPmDF5FNket/jncG2G4FUsk+JUhKE28V3CNnEN77gpvhkvBIX587Q/jSgTomlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e768f39-8e43-4277-ba4d-08ddf1f3799b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 11:56:57.6728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fKHdkwliKAo5RoZtz21yXhmBc+YT/UQiSTR26L0JIZX1H6MS+ROHhJWB0iKcV8B6txPD5Re+CraeypeKa/m9juj11SrbLtXdW9W0cu5EAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5764
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120113
X-Proofpoint-GUID: g4aNFad9vIZq9G7XUbViJpeWsvzirK0Y
X-Proofpoint-ORIG-GUID: g4aNFad9vIZq9G7XUbViJpeWsvzirK0Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfXzfnKGNahFxUA
 984L73NLmBnI36IqfokSm4aWY0xXHdZfG2IA7fqT9zLrRGTWwxs79ovE0TwiOqox4PV2zyW4kv5
 31RNwIegCuoG2bWHE4G35fTynXpeb/QTNGdpWuBB+Rw1LxExyyPlzncN06W6UEC4nb5zLR/FeK8
 7v0S2wlAvz6k3sLF+upikbtBrZQECSBu+hpb/iwfcicPFAUBVoSegbc4IF4A7siQ8u+7B170Ohv
 On/skLWt/wSz4UYFhRQ/LbVvzfTRpxQoJdnjWUC2ZeTDcZJc6K1cQWG8OzoZgHtToDSQnNsHIN1
 1VRJ8yqCBOwoL0UV5jdC+oi/uUgjG8VSJkVdw0+ZOtJxGXBwUk5hoTCnKbBXadiwlqJjKVMZ2Fi
 Con9a1Pq
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c40a8d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=YdMXeH_Thz64oUSYUZEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: BBB22180004
X-Stat-Signature: hzgngbboidwuqhsyhazduxc9u3zjfkyx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757678228-708771
X-HE-Meta: U2FsdGVkX1/b3kt74e9u6XYCLgqkkIKo9EcFQidC42WW6k65Xb9S/rti/ENsFuUKhZRXUsv3CPjS281/mEgCPQ+EsedioPX6nvqBCIihH3A7AB8kKESa5FCViHGMiK0LsZa77Vvcv3C6M3IAbM1auX3v45pGiWNdQvjFJgDKi7KiDBpdDGaYIdxvVb+q6QuxnWGdkwC64y8Q9IOdkoHcBAyCMlFHCC/RWoD6D9jDijopNjAUrD343sOzgFaHTSFcBHcylBENnYiY6748+W9QGfQ8Emcs2CaTWfnpRdT6VOMCr2ka4wmIUKwraZwogH5muT9CJpRnvgrG0Sv5GGl4Iodsvx2ANP4PhsxbKGnAEiip0KVSIZ4hBKFzsPyURqTuWBKkXgTdAf2+komUGAI3VSHm94JtpzUeh1DD93CaPQqfcfCeAOdmu30dBWTmuLdIKzW00dfXFQZt47Y3Jd3tmvdK+KqXCOoV/nsKK5CahEAF/j5d11eRXTxJOVwVQkSW4+OOcwoC5rwLYVVwKpiW89mmjLkABqjiZdrlTwFKd18PlNjDYcTNc6OrbgXKgYqPK0nGGy3Vai7RAJ/tXN4hvo8+dhJrFT5cgUK6JgH4MwnzAT9kdPiiwfv8P6UFpK+GGAf1mPiJBZK0kByBopMztzV+Rdz3mAi/kd7NWJXGFtTIB8RTMOnhZ5WDhqw50+zO+SCsmIqNaikn0bgjV8Z77nrS5l2S5AhA/4FU3V7QoM3W01WJWHFxcPlhY/EfbBswqO8GowSYkwz+ktrWOth96KrepSG7Kk/P1vHXr5kYP5AvRaKCP9GUP1Tx9z0nmRpvwF9BHmvq3HO2rsFD+BQH3g+2rdwI7e4gNoSy6KWaCg3kC8Wp3N7riOArg3Gvp7ai7C4zLr5AQt29e5nj0aInGxvFKkCA+D4gDbEZzSlp1Azz+gxHij4kf9cCCSg2zCGL+MxFH7uYVs3D6gWDcvw
 H+KvQjqO
 YdZVSmfhUPsZQVGpRXRrCW5AzjHTnTi6HkN1WDmVLyTKw9Eszfpk4iI8YEU370aTcTgop/1RCCCGxxWwZhvX7G363bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 01:37:35PM +0200, Jann Horn wrote:
> On Fri, Sep 12, 2025 at 6:49 AM Lorenzo Stoakes
> > > folio_referenced() only wants to look at mappings of a single folio,
> > > right? And it only uses the anon_vma of that folio? So as long as we
> > > can guarantee that the folio can't concurrently change which anon_vma
> > > it is associated with, folio_referenced() really only cares about the
> > > specific anon_vma that the folio is associated with, and the anon_vmas
> > > of other folios in the VMAs we traverse are irrelevant?
> >
> > Right yeah, true. But the AVC's link you to 'related' VMA's which are
> > across the hierarchy.
> >
> > I think really the refined way of saying this is - yes, you could, but
> > you're then putting the weight on the VMA side, and the VMA side is
> > being invoked _all the time_.
>
> Ah, fair.
>
> I guess one approach would be to do something hazard-pointer-ish? Like
> a semaphore-like thing in the root anon_vma that contains a normal
> reader count, a hazard-pointer reader count (limited to some small
> number like 2 or 4), and a writer count (up to 1), combined with a
> limited number of hazard pointer slots; where a writer can ignore the
> hazard-pointer reader count if none of the hazard pointers match any
> anon_vma it wants to look at (but readers still always have to wait
> for writers). The write-locking fastpath would just be a normal
> "atomically add N if zero" just like with normal locking, and only the
> case where there actually are hazard-pointer readers would make the
> locking more expensive...

Ohhh nice idea! Will look into that :)

>
> But inventing more artisanal locking schemes is probably not a great idea...
>

Well, sometimes it's valid!

I will come up with some 'stupid' solution first so we can analyse it and
shoot out an RFC.

Also thanks Barry for raising this - this is an important issue and we do
need to figure out a way to attack it.

I think a combination of incremental work with the current anon_vma impl
and also adjusting the design for the new anon_vma approach I'm working
on is I think the way forward here.

Anyway will send out an RFC soon! :)

Cheers, Lorenzo

