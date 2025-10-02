Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17817CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 09:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0978E000F; Thu,  2 Oct 2025 05:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B82C8E0003; Thu,  2 Oct 2025 05:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0587F8E000F; Thu,  2 Oct 2025 05:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF1BA8E0003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 05:01:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7625058CD2
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:01:16 +0000 (UTC)
X-FDA: 83952580152.29.52B86B0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id BB47D1C000F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:01:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m9Ye3oIk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B3dDG0Re;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759395673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnxAb/x7pdkE5Jf7a+Hfqv/i6yZ/v1cZavNvrA3n99c=;
	b=OayaqByvoc2tM+HAn6yeg3MzzQIG3S95BOlKTFc82NEsxPufWVh4ZVUAqDwmegnaf3hadW
	kQMOnIm0sYT/duqokvP/COvBInJBPf/pAS1lpRdGswIulu6rLdhARxGatZtnUEsJ96sGik
	XRFh43aLQ4ZseoqBYrhlu8hQp1ZKEww=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m9Ye3oIk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B3dDG0Re;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759395673; a=rsa-sha256;
	cv=pass;
	b=RwdkcZfsLrwm22nUDAFB5oggtW09Fdk07t7u+WLo4pSjCN6R1x82JMcer4XmI6KeCYT/F3
	fxTZLpu1rlw077RxAn8HoAQsnJyf90nGLqdjYt+t7e/5H8z2SoF7ES3h32wjw59ESwxAPn
	euNeDW44N4zcS2rM7WUIzqMdJ3vB3lI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5928NBPN004521;
	Thu, 2 Oct 2025 09:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KnxAb/x7pdkE5Jf7a+Hfqv/i6yZ/v1cZavNvrA3n99c=; b=
	m9Ye3oIkMITuiQqUrgZRdCNziWslC0KiGfOxls6KPjM1pa6AKyh4lKuX7POzKrx6
	u3wMBmj8nTRaiyXTPshH5/fn2et1y7EOsEqFpBO+sIyisx3BoFzFoqdsn/Y1EEWY
	q7FWejZ4A6lIfpiqQYo1O8toGH2Cg+m7RH6YuJbspPwXeBl9fLYeIIRCHCceK4Zo
	Q9gTPoIDiXZ4/OX1ZomJiZyWIgtcDAPH6laKAUjGKqJVGi3wMSPs7IaWIDToMhJ4
	Fn8V9yeiak4kpwbX71hdaZ5iD88MtEoOBMWoOq4DeVU9CvdsTl/5TiK5cXtsHhmF
	vfCu6LtYg7/z4wI/CS7NyQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gmcq301g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 09:01:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5928WqSj023268;
	Thu, 2 Oct 2025 09:00:59 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cb58ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 09:00:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MIYz2/SRWgbFtHPOnFAQG/7wG5I97PTUbqIqiJbFvNVl/9x2cWA7jH34p16c2ax/b42V2TH7GS1X4i1dLfmJX6fHOxHwhx2T4GGGpZLpHF8ATVd6wbCjQfThuW3oblOOgqUUm/JvTxDj++ugoy6T5XNc2KBQTEfckPCnw/qfEADrmcW+X6yjPGf7ZfGhImzdrkMmRuzYEcE1+nIj0Yt/Uirylpvx6hKE0Bsw7Ies9AnSaUUQebAOf7/FPVMj/AQuKnL3jeCGDGtUW1/AYRIJogF8Aa6FoOOLScVI5ebeus6m69si/2izVpcok0sYsgxYUnV76GmjjqaPv28YQZCoGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnxAb/x7pdkE5Jf7a+Hfqv/i6yZ/v1cZavNvrA3n99c=;
 b=kfQGi2x1hoPSGCdSYZZyVtRzuwfN+60p8kRpgFt/VNQWifstdOSANiMMdn1odk7g7NLvFe/9x2bpfQ+EzMSurlQLydQ/JTJaKhK/k1X22cHuh+IyTd9MD1Ddx4P2gEPFo3KicflDnudZhKRn9pK6mRIL8yHV+Bli2m+i2tTbPxbahdMfiTGBoQQ+XwyawdC0nCbAwyUzCPx9qoGDR3Lpi+dO4OKQYBszNfbQ9GroGJ0bkSzkR+h8jud21RXJ65Yo5yswIlX3vklB8rZO5PeQI+HLmD5O1ghHskCOUH9mAhSX1eky8gugVLClRUF+7X/DwAZpUqL+XTKawUDGQdJ7TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnxAb/x7pdkE5Jf7a+Hfqv/i6yZ/v1cZavNvrA3n99c=;
 b=B3dDG0ReJ1Z8ujnJ/mPUCG7ey9Kgtz99CNbDwTOifYN4mgcSKY1xGsk3TdVbGmQY9iWlibKh25Bbg73QUDDdVGIr/Xy9MYz4Ru1bDDD+uPnpRSZX+kYdJO15KEbyRcPuLmXHkEyqzVRxtlcjzXiT2SRlRyhMp4IY1ltLj0nDflU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB6857.namprd10.prod.outlook.com (2603:10b6:610:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 09:00:57 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 09:00:57 +0000
Date: Thu, 2 Oct 2025 18:00:45 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, ranxiaokai627@163.com,
        Andrew Morton <akpm@linux-foundation.org>, cl@gentwo.org,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] slab: Fix using this_cpu_ptr() in preemptible context
Message-ID: <aN4_PeDcDQUhv6N-@hyeyoo>
References: <20250930083402.782927-1-ranxiaokai627@163.com>
 <aNu2xJMkEyYSdmW6@hyeyoo>
 <CAADnVQJ-bkd2UVsZmhdb1L5ZrXjZbTnRcaJ-D=ojsoiRHmHwaw@mail.gmail.com>
 <b9fb0a69-6cfb-4285-8118-ef5301115948@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9fb0a69-6cfb-4285-8118-ef5301115948@suse.cz>
X-ClientProxiedBy: SE2P216CA0061.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB6857:EE_
X-MS-Office365-Filtering-Correlation-Id: 0acec73b-fc03-4955-78a1-08de01923261
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkpGOERRaUFFV0c0Q3paRzRNRjROK0pWd3dGSTBOQTh2b0E5NkozVjNvc3hi?=
 =?utf-8?B?UWxTWTNHMUJoNERZK0dOaXd4VnNNK0IvTFIzSUNMTjJOZTc4TTBLMUYvSUVi?=
 =?utf-8?B?bnZVTkNRT3VOcWNTblg4N1RlbE11T0VpWmNrNnhkUmo1YVF2YkF1N0FheURN?=
 =?utf-8?B?SUFNWUcrVUNyejk3NWQ1bUREdkxqcS9RVTZ6TVd4L0Y3SDIvZCt5Q2xUWkJk?=
 =?utf-8?B?UlhaYzNGYnMyU0p6SStvSVY4bk83VEVNRHBzUFNZVDRqWXJ0aGh2YnBXTFE3?=
 =?utf-8?B?QmdVbXlBMHZHVkdyMEJpYVZwRDVzUlgwejN6QWprVFdjMEtucVk4akFjR0VW?=
 =?utf-8?B?L3hLc2lmOFh2TS90V1RoVEVXYWp3aXUya2hlUVRXQ0VON04vS1NuNmEyQmV4?=
 =?utf-8?B?TE1PS3lBSFF3dEJ3aHJoY2M1T21BM2FCbTM3RFBRK0lLVXBEdWIwRGpmeFpD?=
 =?utf-8?B?alFLbWU5WmFVL1JMY0QvWXF6bTJBNE5paitRTy9NOW9MSTBZVWh2UEhZdnli?=
 =?utf-8?B?bHk4L0ljU1NLbWMyUmptM1VYL004UEJUOE5zUWtReFpLaDIxbjdzQUdJOFR4?=
 =?utf-8?B?SFpGcWE0Q2VGNThNRG1mbSs0WmxTLzhxWU9JR0JyNTMzOUpTRFZDT2hycSs2?=
 =?utf-8?B?LzdQNU00cTd2T05PaCtLTllxUTd5YmpLU2VrV293NHRKaytnMDFKZHUzQ2xk?=
 =?utf-8?B?U3RvajVrUEhWRXBZMm44Sk5SaklzZExnVlVNVldDa2NodGFOZFZNeTd1bTd3?=
 =?utf-8?B?OGxSTVJoVVV2eGRuZkZtVndVOWdteHU1ekV1VzQzdmMvOVVJVVlNOHdydThm?=
 =?utf-8?B?SFBuSjhzK2czTGhnbGVORXhiVTVUUXZsVm1TTjQybHpINGo2RWswZjcvZDZR?=
 =?utf-8?B?b3N0WnVWWTJmcjJLTEdCZFpYeUVaQjVGZWZMVEZhQm1VWFExWDZpTk1ob1d5?=
 =?utf-8?B?bGRoMGlLUTFKYWtBd3lOa2ZMUTJsbkJ4MXlxUVdvVGRhU1UzYmFFVjNzUUtC?=
 =?utf-8?B?dGx3NnFqZHJXUEtRV1F3UEh0TEE0TDFPRm9QNVIzV1VnNVRQYzBSLzZCVXlj?=
 =?utf-8?B?WTNFcFI3OWV5SjZmUE1NRGh2UmhMU20wZy9WOUhlaWNESTZVSy83eVJ4LzVU?=
 =?utf-8?B?RXY3UmZMd1VVQS9VdmkxVjNpSXk5WmZsQVNLcTMyOG9OYWtXZzlra2hRR09w?=
 =?utf-8?B?c3NDbURXdVp2WDJHbjdxMUdkUGcyamlUR3Z4SGdwWlRObnRpaCtjU0NnVUVZ?=
 =?utf-8?B?UDh6L2dLNi96RTBNM1VPbWgrREhVM3lNVkd2bGtYNXhBUng4RnRESEhMOGty?=
 =?utf-8?B?WDFYUGhiRmgzb0hqcVlLRmFUc0U3NFVPSitQRDllRlVQK1RoemtZbzBaVjRi?=
 =?utf-8?B?ZjBvUGJ3cUluMXRBRmJHM0VyMDF1OEVDa3c2dnVCT1NKRVFRT1NqbEcyNXk3?=
 =?utf-8?B?SFJIZk1YVHZQV21xZjhCR1Rzc3ZlMldBV2hieVdkN1F0cEdxd00yZ3BGOUZU?=
 =?utf-8?B?VHp5R0xMQmhyS0lWUVM2azBrM016TDZ2QUkySGVRcVJndERMdWVjSCszek9y?=
 =?utf-8?B?QUppS1JZUnRmNzBYZGdjV3M1Q3NiS25JY1c1K1VtVDUyUm9UTFgrVDF6bEhy?=
 =?utf-8?B?KzFnRlhES1p4SElYUzlTdzI5T2VNREpyaVZoWFlQa3BLNDFIRkpOc0cvS1or?=
 =?utf-8?B?K1JJVm5MMVlMMzIxeXFwU0FJRS82bytKMFpLakljY0NuMFo2bXFuRnJmVS9n?=
 =?utf-8?B?MHV3c3M5YW1zbUNSdm0xb29teVFtMGhKdXBHVHloWDIyWDY0eDZqNmNBRkJ0?=
 =?utf-8?B?R1Z4dEtzcUlUUkVJQmxjWk5wRDZnWGxQVUFVK0Ryb3hwUUx6VjdBcGxCbjBO?=
 =?utf-8?B?S3MzUXhDMGRkZkhhSUYwT1JXS3dTd0l0N2x6ZVNpanloWlowc0l1czQ1L2Vs?=
 =?utf-8?Q?zUik3/0Yquzp4z7sOppIyWPMBpBEnFcr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEFJNEpiaTNkTi9RYkJ1YmM2K1dwRzlzUy8rN0FvS0R1blJ5TmFRdW0wYitB?=
 =?utf-8?B?OVRIZm9YMHVqRFlBQ0QyckRnSmw3V0Q1b3YrTGphRGdnOHk2MjhCcXZDOXEr?=
 =?utf-8?B?SFl0WFhxTjhiMkJHMlFybzZrSmtwL09JS2w4UlNsNVV6NjZKbHRBM2JpblJ0?=
 =?utf-8?B?QWpwbktKVHlOVStrQmtrbW5jUEhyOWRoY2k5d1B4dkNpT09ybUk4LzBFcDhn?=
 =?utf-8?B?alpTcmZsMXdmTGlmOTRYaU5sMXhFQkZoL1N2d3NYMUlOR0J4RWIrUzZFckR6?=
 =?utf-8?B?Q2hlaGxDaGxIQXgyeWs5Y0JaL0ZZaGVzYW4rck5XbERUSVFTc1RKTTc1V3pr?=
 =?utf-8?B?bnpPRXNKVmFxaERjTk9pKzRyUU5ua3BhZE5zT2l1RVVLTkYzaHJxRXlZNzhl?=
 =?utf-8?B?MlI3N0k4cEVXak9oZndBWnU2ZnhXejFONnZIcVBhNUtJdGV3dDBiQUpIWTRs?=
 =?utf-8?B?a21ta2FiN3hwdHlPZWhDdFZKNG84NytFbFRGbHBKL1FUTGxQNlpzZGVTcmdu?=
 =?utf-8?B?LzlmMzNiTEZTOHZ5YlhlZUxySU1ZK1gveUhCT3FJVUVHSXpXU1NUTlBXNjZG?=
 =?utf-8?B?a1NiaUlMZEhWMkxzUUtOUmVZY2dCRkRvc04vc0FRaTViRjN2Ykc5dGowczI0?=
 =?utf-8?B?Q0pVSURLT2ZDV1o2Y0IxaENDOU9LdXBPaFp6R0FpalVyL3JxV1k3OSt4K0Fp?=
 =?utf-8?B?QXg3VERJTE8zem1LWDdwblcwOGsrRWNocTFVQWZRVGpWc3BYOXNsVVVNUFI5?=
 =?utf-8?B?anRFalJlUnF5REUyb1ZxUGxicHJXcTZzMDhCZmlINVpmL2wxL2RPamF3c2Rn?=
 =?utf-8?B?aVZWdVNsZ0Y2clVteE1TQjdLQXhvelcyNXBQTklIbS9xc29Vb1R5T0dMOVJu?=
 =?utf-8?B?V0Qvcks3K3FaQm84SnJiQ2JDWTlsdkJiSkdHOHRvb0N2STh6L1Z2YWhkQzly?=
 =?utf-8?B?YklLQ3BLeHlOUVIvN1NtVzh4aFNIYmpReEdLdlQvclRHRitub2h0YnFGVFhG?=
 =?utf-8?B?N0xvNFk4dC8rdVAyTDFvVnlxZURWUzZHSWtiK0Z1SmhnL1c3Y3IxYTZiYm5o?=
 =?utf-8?B?MGJRMXRqMVVCSG56MFlZYXhsSjJtMWd4WjBZRlFYdmZpNmZMN0UrSDdzK2cx?=
 =?utf-8?B?Ti90M0FmRFZhK1A2am5WMmJBQ1dPNVdqQVowdEhTdTNmMDdoWVlqTnNNQW9p?=
 =?utf-8?B?RnFrWUdyTW1KNVB3K0diMFNxUEU2cXJnYjZIbUtPVnhhZFJDb2RIMzNSMmwv?=
 =?utf-8?B?WEp5Rmw1RTd6dFA3dXI5WlcwRFlCUUpTZHI0KzdHWDltcjIxN2NnOEFBdGxu?=
 =?utf-8?B?V014TXErMnVhdG43TmtaMnEzSlFaNUUrTC9zTXl5Um93NHhob0gyMTNhVTI4?=
 =?utf-8?B?RDN6ZHlWcXZ2NzZPaTVrRit0d0tGV2p0b3VRYXRhcDNZbFEwRENOdmViaDRE?=
 =?utf-8?B?dFZ2NHN5amZDdlViYy9yMjVibGRtQVBkK3paNmJCZU00Y2owMmRHT3BsZWRJ?=
 =?utf-8?B?NGRnTVQySC9vZFBROHlPdWxDcGRDSUkrT2svUWZvSmFOSHNFTW4wTE85M00z?=
 =?utf-8?B?WVlJOWViVGluVUMxbDAxNzRZRWZsRVZDR1UzeHRoOC9KbUZwclh5UnpGeUxK?=
 =?utf-8?B?bHhPem9TQTZHUzEzQThpZU9idEMrdmVrQmNhc0VnN0pxTU9oM2JRR2dQRmNT?=
 =?utf-8?B?U1RGcXNxdjM2dDhNRkluWVc0aFR5REE1UTI0UUhaWW5oRmIveEJSa0J2V0Nh?=
 =?utf-8?B?TjFaZkh6Y3YrWTMwMDJ2T0F1eWJ4RGY0OEozVGFQanJNbFZJNXFYOW1Vc01h?=
 =?utf-8?B?T043cnRROGdyZ28xbTcxT3o2enRMMmY2ampxRkRTd05RWDI1SGs1UDZzN2tw?=
 =?utf-8?B?RmUyckx2ZXhWeUNkZmFKVjd3YkxpWGVxR3dESWxJNEJIMTJNMWl3SkdLb0g5?=
 =?utf-8?B?U0svNW9OMXdpQ21CM1JLdkUvcWYrcTlqczBDZi9XWXIvZ254MmQwYVhEUWU3?=
 =?utf-8?B?dkpCY2NPT1JwejdIb2FzUWloREp3Q0hkbHdlaXB5OHVJZ0dVeXQ2cE9qbndI?=
 =?utf-8?B?cHJWa2pZSGdFQUpyUGlpcjc3OTIxQnB0NkN2VW5PZWJNTnJZRFZaalprM3lE?=
 =?utf-8?Q?p/OaZLItYzUn+PnGRhVw2Qvx2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xyjcL1U5rH4V6kTkRhbmCzOK8BwCkryg2+rcMV5AE5Vvj6Jdz+fJdHAlWQUs9Ybch8rM7kSunkmaISLLNAxmxCjzAnUbDrcILi5Qm6XY77Gi3/5eNdglOTAJqs2q+QuW2Zmg+RoWip0JjwTBwqjukecry1I5zFjRIleQ2wpXi3KgD9GPETV09UWRkcvW5Yu1Ccv8iWV3mir4ZKXYQCkqTHDK2biHQ3S7qBsz9MG0lxusKOQ0VcxcBE3W9SrSHHNBhg/maHU++ShJse1hicThjjSl2eSbj9w6HnxindFd8B8ttivD/AOI2PTGD97m5QvyRB36DWq2bQGQx7z8iUuj1rPMA1EBXqwpE4mZulYaRN4VshCh266CdMg+3QEwex2YlChFCc3ekPwGKPy5LXO7yvcDmOq9JFpbq9fry3Zkh7o7P3IbMvk6t+G22x5rJLQ3s/rPZDmoMVnJItkJLBuakD6I2hvyE2iMy6BjY4yWgGcHE0LRUq/arbf8d/RWDmVG/FcnRkaNx71IpPlgKSmY6A3KPQXWgVnf0Lbc1UMnjTTkJtLolPcv6/ofQaKfrjCzf06CAxVuJDTQkBvJqKnSXyYs6qT9GyrCEA9sO2zL/VQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acec73b-fc03-4955-78a1-08de01923261
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 09:00:56.8745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wo6i25mwjySJ5rXX6YUcduTXfFijbzvEpQY3zziNR+3vcSYM+WN9qz7q+U/FMrkvSJRWWEmUH3f033VhRFsQgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_03,2025-10-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510020075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2NiBTYWx0ZWRfX/Ft6JzO2OdPX
 /4do1WmYTVndX/V1o1oi7yZi/UqnfjZOLQzz4BEAsN6sxooyvCJ5yPX4AAaYatxlz8YBKDcvGXQ
 fCHUNWq7qV/tXuMnlbWqdLIGi6VqBuJ2P96XL0nQxFOnI4+sMU9VFa9aLpjZi190OopZceV1Bif
 xf+bkBpF22kzOO9EGRNIpyczzhSgIEY3AXCLL1VUNKy0uGVPek4Zf/9DE1ijcpf3YerysCVM/1B
 lQNjrVdjHQmAyBxbP44UrDoEVewb/0h885JM2nfqJ8cbpMwPHy88BvswkRiX9NSlHdAkfgeNElQ
 4Ka9HhId5eRhZiDBknwzeAsqqj8ThBZyE/7ErLOGsLhdYeLHHhGAKzydzcz7ZD4gQYjdKUDZzi/
 n4S/3/rzxMK2hrgOgiF4ilKgFctPpQ==
X-Proofpoint-ORIG-GUID: Nt85o4gIqJcrQhlwBJ_EKR__m8RDpGxD
X-Authority-Analysis: v=2.4 cv=c7amgB9l c=1 sm=1 tr=0 ts=68de3f4c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Byx-y9mGAAAA:8
 a=1RTuLK3dAAAA:8 a=OWyD4sRVhJ9q_nbmn8YA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=kRpfLKi8w9umh8uBmg1i:22
X-Proofpoint-GUID: Nt85o4gIqJcrQhlwBJ_EKR__m8RDpGxD
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB47D1C000F
X-Stat-Signature: anxrxaqqiecd61b9prpr5e6obtx71t5j
X-HE-Tag: 1759395672-980511
X-HE-Meta: U2FsdGVkX187XfdTg48hykP6DERjX7mlkoIpHj/vCcObXnYmdUzJzdmugD602P4N8MvBDkUpuawDyX9ByM/C7UXxXOYzHNlRS0hq3Axxi2ZypmoJWHhSJpB5Hmsa5TM/aZEUlzwK2bkiNSwNr8p6RWQSmCyB+9+9dRV1gAyaVouEaiS4K1Na0ziS5K2eUV2eoqB9smli7ob7MFwEO74Z2Rmn1pLO3hLLJNZ9sUYAYc2hQOXDAgFnD8rEhvd/hnVj8eu3QHDo1zIGopNvuO0Mc4znsRkv+a3smeZjG0D1gbh4obCIomXDRncjKx4Bzt6fW+YQG47Tn1DBwCfd0WqBrWhz7q+a8c4L5bTcwqU4oC4MoSkOGReuRk4huKvYjlBJuvpj8wsyGHQA933ojjl5tqpGx3VF7DDPguwAnhoo2QWb0hM1MsFvhRHHQ64alDrwN0i9v2XWxzrztI2mOKU4VaBjyOBp0lEzXFT1PdlzA9b820wsUFcPfhmX7aIQ7Za0vkF9ruDD0eI2jiGbApCd0/PJDygs04XmV+eL1LFYIDb7eOw972UV75OD0qfKiVtgP/5J6zTsALgia0oNM1LsffZ6fi2N/BCZG5J+XiwQP/HCokDNJpoYP26ae+PBZngS7KeixfouOlmRXDMCb/jD2pecVEFpvfrKABQaNfoDGuUz/WNlsi04zo48/RbWGhpfCDCM8BoPY8+eJsDWsQ+CjI/LW40BouTbxQLzXSZbnNBPCOaRcm+Y6FpqlXyzOb9jTEa/Q5dGSUxXUPzq/NmS8TGPv0fWO1DtgDMCDe2Fngdfxri3tldFpfihXvddhIBW+ZRccZO3gD8pEgqVS4YhvXab1ifWe2nibZQe7pBBMXVheq6rhws1owOs+Z/RKL4rQDtDDQqPDIrMGEpYxrg7p6DT2/itmA/CXM7aVpIqrYsbrd/4GmkUrqOqJDWhXNfXCs0Sc2kZv6153jJ5jNn
 b1MfXkHd
 YNqAeXt1Gidbug2KUGR6ajYz/EZFbPDjlB1EkEZ41/KhPa6KlRdR2NNrDCMDVrQlPw47T/HBhEZ6aUnzu/Ue1owSjZAuWJhWpT5FErLKcge+I2snro8HBe+K1fMPvUZSip7oE0LeRHAw4gZWB0D2PRvVNBl0xTUqBsr0aH9Mo2cJsB5ztzTVLKqA/a0mLH3B8obGoJtXMyWJiSo6XdgZ09j9X3AI/g67BP7kI12KiwrhHH7UXSyH5BIRkOjFCE6n2v5QhqP+Ttm/1b4t1R8Vgl4ASrjCzSsWTAr3oQhcyN4rvjo6ojKj0iraxLzNQbSHTXH/Qb7RUNHkGL2S2F0pvdXuzYtVOMX0gF/eXTFRkJHrWbyzwnFXM4EbeEBYWwARdh+u+pvMUIMsZiRinqI/QLmrec11VZ699XfBIFzt+oT7h4Is/z/+pEqnafcLm6LyTQ8yq2tDZPcoEu0Ih6NlYnMnOn7z1jE9PFaQlrOp1rqFGTT53cvCH2WOjXn+XufJQvOiD/3YNwJ3AOXNbI5Y9wxmQIfT3EfELLafSEOR9CthcTCkaFlV6UyRL75UkkRqUWxAMsyyRLK7zLT5ijGqanFkQto24bn/1fRl9xkwUpWri2vQsIVEw2/UJOlY/jOfBJxnQRysi+aZZz6Gt4LVh9TtTkxreGfXOzt9mYfPjvbwwRFrSDO9HDBYog1gD4KZDFV7KJRVaZl/JyI2qHcrnRPO3nGGItKPX8YbcwpX8SL4WvW4v5mC+b8PbrD2sYopmqtG1Aso/7Kf20O3QxwYOXcVGvUmHBhpQULPBR5qsTFBJzHR/K665GM0ufXWSHD09PFLW2EMPq+rFNtgFPKm3wmERYhsLgt0GP2h42IQJE+2L6Mx3cdxIxS+EowfCmuaYowHzPOqUW67NPDDY17PDs3uD6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 10:14:55AM +0200, Vlastimil Babka wrote:
> On 9/30/25 13:19, Alexei Starovoitov wrote:
> > On Tue, Sep 30, 2025 at 12:54 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> >>
> >> On Tue, Sep 30, 2025 at 08:34:02AM +0000, ranxiaokai627@163.com wrote:
> >> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> >
> >> > defer_free() maybe called in preemptible context, this will
> >> > trigger the below warning message:
> >> >
> >> > BUG: using smp_processor_id() in preemptible [00000000] code: swapper/0/1
> >> > caller is defer_free+0x1b/0x60
> >> > Call Trace:
> >> >  <TASK>
> >> >  dump_stack_lvl+0xac/0xc0
> >> >  check_preemption_disabled+0xbe/0xe0
> >> >  defer_free+0x1b/0x60
> >> >  kfree_nolock+0x1eb/0x2b0
> >> >  alloc_slab_obj_exts+0x356/0x390
> > 
> > Please share config and repro details, since the stack trace
> > looks theoretical, but you somehow got it?
> > This is not CONFIG_SLUB_TINY, but kfree_nolock()
> > sees locked per-cpu slab?
> 
> Could it be just the "slab != c->slab" condition in do_slab_free()? That's
> more likely.

Agreed that we're seeing the case.

> However...
> > Is this PREEMPT_RT ?
> > 
> >> >  __alloc_tagging_slab_alloc_hook+0xa0/0x300
> >> >  __kmalloc_cache_noprof+0x1c4/0x5c0
> >> >  __set_page_owner+0x10d/0x1c0
> 
> This is the part that puzzles me, where do we call kmalloc from
> __set_page_owner()?

It's

__set_page_owner()
-> inc_stack_record_count()
-> add_stack_record_to_list()
-> kmalloc().

> And in a way that it loses the GFP_KERNEL passed all the
> way? I don't even see a lib/stackdepot function here.

Oh wait, we clear __GFP_RECLAIM on the first attempt to allocate
high-order slabs. so gfpflags_allow_spinning() returns false.

> >> >  post_alloc_hook+0x84/0xf0
> >> >  get_page_from_freelist+0x73b/0x1380
> >> >  __alloc_frozen_pages_noprof+0x110/0x2c0
> >> >  alloc_pages_mpol+0x44/0x140
> >> >  alloc_slab_page+0xac/0x150
> >> >  allocate_slab+0x78/0x3a0
> >> >  ___slab_alloc+0x76b/0xed0
> >> >  __slab_alloc.constprop.0+0x5a/0xb0
> >> >  __kmalloc_noprof+0x3dc/0x6d0
> >> >  __list_lru_init+0x6c/0x210
> 
> This has a kcalloc(GFP_KERNEL).

Right.
 
> >> >  alloc_super+0x3b6/0x470
> >> >  sget_fc+0x5f/0x3a0
> >> >  get_tree_nodev+0x27/0x90
> >> >  vfs_get_tree+0x26/0xc0
> >> >  vfs_kern_mount.part.0+0xb6/0x140
> >> >  kern_mount+0x24/0x40
> >> >  init_pipe_fs+0x4f/0x70
> >> >  do_one_initcall+0x62/0x2e0
> >> >  kernel_init_freeable+0x25b/0x4b0
> 
> Here we've set the full gfp_allowed_mask already so it's not masking our
> GFP_KERNEL.

Right.

-- 
Cheers,
Harry / Hyeonggon

> >> >  kernel_init+0x1a/0x1c0
> >> >  ret_from_fork+0x290/0x2e0
> >> >  ret_from_fork_asm+0x11/0x20
> >> > </TASK>
> >> >
> >> > Replace this_cpu_ptr with raw_cpu_ptr to eliminate
> >> > the above warning message.
> >> >
> >> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> >>
> >> There's no mainline commit hash yet, should be adjusted later.
> >>
> >> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> > ---
> >> >  mm/slub.c | 4 ++--
> >> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/mm/slub.c b/mm/slub.c
> >> > index 1433f5b988f7..67c57f1b5a86 100644
> >> > --- a/mm/slub.c
> >> > +++ b/mm/slub.c
> >> > @@ -6432,7 +6432,7 @@ static void free_deferred_objects(struct irq_work *work)
> >> >
> >> >  static void defer_free(struct kmem_cache *s, void *head)
> >> >  {
> >> > -     struct defer_free *df = this_cpu_ptr(&defer_free_objects);
> >> > +     struct defer_free *df = raw_cpu_ptr(&defer_free_objects);
> >>
> >> This suppresses warning, but let's answer the question;
> >> Is it actually safe to not disable preemption here?
> >>
> >> >       if (llist_add(head + s->offset, &df->objects))
> >>
> >> Let's say a task was running on CPU X and migrated to a different CPU
> >> (say, Y) after returning from llist_add() or before calling llist_add(),
> >> then we're queueing the irq_work of CPU X on CPU Y.
> >>
> >> I think technically this should be safe because, although we're using
> >> per-cpu irq_work here, the irq_work framework itself is designed to handle
> >> concurrent access from multiple CPUs (otherwise it won't be safe to use
> >> a global irq_work like in other places) by using lockless list, which
> >> uses try_cmpxchg() and xchg() for atomic update.
> >>
> >> So if I'm not missing something it should be safe, but it was very
> >> confusing to confirm that it's safe as we're using per-cpu irq_work...
> >>
> >> I don't think these paths are very performance critical, so why not disable
> >> preemption instead of replacing it with raw_cpu_ptr()?
> > 
> > +1.
> > Though irq_work_queue() works for any irq_work it should
> > be used for current cpu, since it IPIs itself.
> > So pls use guard(preempt)(); instead.
> 
> Agreed. But we should fix it like this. But the report is strange.

