Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAF8CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBA68E0003; Sun, 17 Aug 2025 22:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93508E0001; Sun, 17 Aug 2025 22:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9820F8E0003; Sun, 17 Aug 2025 22:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8558E8E0001
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:22:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4497083C7D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:22:12 +0000 (UTC)
X-FDA: 83788278504.27.311AC96
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id C096114000C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:22:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IIiGLucW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iU7vRhbG;
	spf=pass (imf26.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lsm2c4PZha0GH5ADmjx0rFlxEYcqSTYgF0rvWW+K+nQ=;
	b=AsHUAmwVp7OqiLItD+HN452CKFO7V2kRONZ+mpo7Ce9RV1ZGiwdBfRf3E21zOcve7QC6tk
	vfToF74FLbwmg68UgWBNzy971quSlQ3Z39pz0TWUs0o4p6Fw+JpA4yByyqe8fP31ugw6D7
	ySbc48H3Etwmd6UJtcrvrZi11UKYhsQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IIiGLucW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iU7vRhbG;
	spf=pass (imf26.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755483728; a=rsa-sha256;
	cv=pass;
	b=cgTUjQi4Fo8beUYHLtEy/3JQUuENzscy4aapVdSwAWm4AXoMygbXE7geOU77y9uYRyl5qi
	t+LjdMZjv53nX5ryEDphV9BJ6oGYNZWX8hPMhJ0NvBtnikAldMx33WnhyXsdx88EDiSbnm
	Nz60A12OcV1wO4Y645Dst4me1urT5r8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57HMhwej021832;
	Mon, 18 Aug 2025 02:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Lsm2c4PZha0GH5ADmjx0rFlxEYcqSTYgF0rvWW+K+nQ=; b=
	IIiGLucWnyAixvvfY8ae9H+ogLSLj3/2DgJ4XKE17ZQzQXbbm+zzrC12aGnThNqf
	UhR/ueX9VP5BPrBU8XRyeXVzINvLBhXxAdHqh5a+PyaL95qmUVGhmuGNYpk4FZzV
	SuEn6pYdDhw5dvmC/Sg/I9Ic9+FOv+/BxHvNW3eUxFlHuZ4n5PE/SPxdgProUIvx
	6g2OaO/ln3tHORuhKIsnaJRFD5QIhI1tqpb+ATIn4a6e0u0Uum1hBOAQ47RA4vH7
	9tWIFVXMmg5jHiFClhwBt0rWPzN4/PGDA+L0TY2olYVdAqZ0tt6HecPgScSHFjUd
	5QYHMlINGJMn/kGYL9djPA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jj1e1y3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 02:22:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57I1lSP4011581;
	Mon, 18 Aug 2025 02:22:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge8kee0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 02:22:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KZXusFsyM1jRVbwnNH03AN/EAzoHfhZySUOYFT4htiQdLfLQETt8b/0MGqZF4VDkEZYwYcNrhzBJ5ez1yIw7erpA2BS1rJ9sdZKhjZD4DCrZWqjF1Dt+0xnRTuiPJ8YmpjTnt80HT0bgTXXFVJSXDw1cftNhE/NPYDqqisac87TnbNtEaTPP52LpBPmWacQvCxB/KcMAhp3UhX0dQEpS+/ZjPFsWY/hG7TPQxTt4snu8xfxxGc273wF4Wj+WkgOIYjbXBxeF4Ik4O6YKOhKK6NZjCs0MpnmlUZpZhqq2MINVhwQqs+C5oNciGAtMlpZ+jJT1odXEYDWx5hLqs+aaEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lsm2c4PZha0GH5ADmjx0rFlxEYcqSTYgF0rvWW+K+nQ=;
 b=OHOg3trpDoopvzMGfzj8bHVDuetQy+QaZsUvUH9Ch/E+xEQjF+9kzPnAvcBSfBx6I821OC/AsVjM9vp9Ri7v2Yk8YOsP9rUJe1IC/TSM24aUGdNDdMDDtHQBrkjvqSDrD/o5dpjqEGwXY8g5Kqs21PK//ZVMkn4qcFQ8vf4RDHvALq/wYH4k5jBygOQ4T8groWL8n48sSfCL5hrgZs1fyP/58qpKMcCKDiFQFDL8kQlhYbwaBclCEBVuk3TH6x1I2etAdShVJuq9/8pQw0NJmL/dIW28A619NoELW4OEkPqbVGoI10O6jUxbMfnjAz0/U8Eh60v05tkCJT1d2xjmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsm2c4PZha0GH5ADmjx0rFlxEYcqSTYgF0rvWW+K+nQ=;
 b=iU7vRhbGWvIHPAVjreoCszl5U4LrrTMmsIhlDumk8I9l0TSBZXW0GMcZYxjt0c7jtsB78vk7jpr0b9SI9j0lTZ/kkwky17wxxOze/n5v9yaat4aB3mG77rO/B2N3Br80BGUM4LhwKr39Clz39WJsENaC0SVD2/FP2rudOp8paV0=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.22; Mon, 18 Aug 2025 02:21:58 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9031.021; Mon, 18 Aug 2025
 02:21:56 +0000
Message-ID: <08cc4405-948a-446e-b198-5745c32f9ee1@oracle.com>
Date: Sun, 17 Aug 2025 19:21:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][v2] mm/hugetlb: early exit from
 hugetlb_pages_alloc_boot() when max_huge_pages=0
To: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
        osalvador@suse.de, david@redhat.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250814102333.4428-1-lirongqing@baidu.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250814102333.4428-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::19) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca12b50-0db5-4018-c540-08ddddfe0113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnlNZGptTEk5QTMyMmwrQmNCMTdlamNFWFBaWHVJamlDbXRJOUEyNDRPM0xa?=
 =?utf-8?B?bHVmbDFKTmY0ZnhMUXpiTHVIbUtWVTBkcVY1OW05anNwOFlQOThvZ29PMHZQ?=
 =?utf-8?B?cC9XTlZaOUpDSUtDWmZMS1ZnMHliWVp2NXdtbkFYWVdySHJZR203RksvWFkz?=
 =?utf-8?B?anBxNXVmOWZOUmUyNVJ1Nnp1OExZVVFod0pvenhlVHA0OU5zWDd4RVNDbm92?=
 =?utf-8?B?QVNmcnc0ZCtVckFuYW96RFZZU1RjS0xoeWdUZXhWdmZBZmtHM3dnOUhyREJw?=
 =?utf-8?B?QzF2WmRTVk1Gb3d4cEVYaFZNK25SQzFMbEQ5V3pZTXdtN1l0R2hrMDZzdmJn?=
 =?utf-8?B?REE3QVRQSmRKS1FtS0lyTTU5VXRtZHlzUERrSFc3TDB3MVBicHpMUGFad0Ja?=
 =?utf-8?B?WTVTcENLU3YvanJBSlh0VlJxckVxQms2N3FMUkhQNys0eGpON3ZUbEJ4K3dJ?=
 =?utf-8?B?M0dlU3hWL3lzenc1M21oV0pPQkZkd01UaTZvQXZtbS96NldUMzdkcXpQUDR6?=
 =?utf-8?B?WlEvSXVUZ0VNNnk0TkY1YkRRckpnS3JiNTVQRFMvR2lzUHZySzZGZTllem9y?=
 =?utf-8?B?WXIzekx1WnMyUUhjejRtdGVOSUlSazFUYUtuMmszNlgxNUlSeVZ4b2h0Z3Vh?=
 =?utf-8?B?TzlwcWEzUC90a0RDSjZXZExXQ3E2WkY0c0M3ME1nWHNFN1p1aXdSUXJBOGoy?=
 =?utf-8?B?bUIrSEJHZW5BOUZrbE5RcW44MzdqZXVjTTh0ZVlwSUhMQVIzMzIxR0xzOG9i?=
 =?utf-8?B?Z2syclovZ2tvaG9EUm42L29uMW1hK09odGh5OTE4aVovNEF3TUhMVkZnWWth?=
 =?utf-8?B?RmkrV0gyb3hDREVoNTVQdTB0SW9rVi9FLzYwWUxma3FZNXlNN0NxVko1akNo?=
 =?utf-8?B?NWo4TzIrN05kV3k2enFKNC9WOFpkK1ppM3phV1JoUGZDMFdoQjdnRGdwVXpW?=
 =?utf-8?B?K094ZUtwUitDUXBPWlBLcmNIMUhTOWlMU0ZzK2tCL1NTMzdJaXlPVDMva2Vw?=
 =?utf-8?B?cUhlMnVGOW4wdmxHSUhqZUZ1VGNXUWYwdjVzRjRUbzdKSkhkQlh1bldIZDMv?=
 =?utf-8?B?bVkvK1NDVngyVERYalJFdFQxOWI4WHFjMGk5SXVBZS9ncUNWdVIxWmo0UGoz?=
 =?utf-8?B?REoxckozd3FwemQ4QnBaSFRKdFkzbUpGaEd0N2d3ekE2MUxRa2o0U25rb2FF?=
 =?utf-8?B?VjFmUzNpWWgyZDg5ZTZlaXJEK2dqQW1MbzJaNlBDT2lMekE0N2wzWmlnKzBk?=
 =?utf-8?B?NDJUYWRQdnNjTkdjclpYWEN0TTg4R0M0bjdETjV2em9xd1kzVTJTZkE2L05h?=
 =?utf-8?B?WmVvMVUvZC9sRC84YTAwbHhWL1d5NXR2VFFRUWVGbXpjdG5MWTlPUmo0N05L?=
 =?utf-8?B?ejJSekFBQ1lNVCsxOVpVNzg1cWN2Y3BJL29ORjdOYk9XUml2S3hpQVhoWFpW?=
 =?utf-8?B?UUN2ajVubVpHRzhQTHQwL1pad2NpWG5XSGl0Y2NMQXY4SGVodjF2ZzI0YTht?=
 =?utf-8?B?NzUrcEsrT3JIREdnRHo3UnFueWh6L00wdG1zVXp6TklaZ20yNmlUaEJsanpF?=
 =?utf-8?B?UnB0VEM0NnluVmpocHBvTllDNTJxMWxPMzVOaGxDaFY0Y1ZYWHpVZ3pxODAv?=
 =?utf-8?B?eHAxWXBWKzRjMXBQZ3J2aW9jcTNaWVEwbDRpZElGTG1oZ2tYVCtOK0pLRXV0?=
 =?utf-8?B?ZDhKVlhZQ2xVNFdScXl5Y0ZKZUlNSlM2VkdQYXlRUU8wdkZoekR5ZVVrRk5E?=
 =?utf-8?B?V0VYRVpiQXR5RkN1Rnl5OFJ3VjMxek90U0NXM2VLQmJEUEVQM2RKY2VZWXhO?=
 =?utf-8?B?djg0Tkc0MDRVSGpoQ3hlUVNjSXF3ZzFka2Mwd0RzeFIwZjk2Y0FpMGgreHdw?=
 =?utf-8?B?SVpITFFod2RlcWJFc2pXUHNEZDU1VE5IM0tzbzNzejZWc3FVTFNTeVlIckZn?=
 =?utf-8?Q?NXx6v32NdJk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnlhQWZ6OGdOTG8rb21UYUdlNmx4Y2hDQ2pUNHVBM1c2UXZuNlIxbUk3WW1M?=
 =?utf-8?B?TmgzUTdyeHZ4dDVqVW5ITzFJUmUzYWFkRzFubVlXTFhMdk1TSDZXK1dxRmRN?=
 =?utf-8?B?dFBta3RWZDNhRmRRcHBENEZHVjdCWUovSnFtQ1BueG5uZHRweGVjd21CRDBr?=
 =?utf-8?B?MnVUZzVPQ3FjU1lLbFU4eFFJOW90RHc0dk5QR0VZVWhHR3huam1VV2RnM1NR?=
 =?utf-8?B?ZVIrdXRRcytKSlhWQSs5T1A1Tjh2UUVXNzF6UXdJNE15ckpMY3ZWdDFXSEQ3?=
 =?utf-8?B?MzUzMitxUVE3dkhrcTR3YWZNbDMvQ0dWQ2p5Z3lOVnluaERLek4rckJnZjdp?=
 =?utf-8?B?dXNiUnUvQnNYZmJ1eHBOMENrTTlobjVLNVlCZmcvR0loKzVvQSs1UjRrY3RQ?=
 =?utf-8?B?MFhKYUc3Uzc2QlF2dkJWZFFkaVozbzBFNHpKZnZJcDhHQ3FMcGxNaEdBS0hL?=
 =?utf-8?B?VDVjRmRXWitJaEphemRxcU5sU3poN0pRNVNWekgzczdVaUM3dUNXTlQwdmE2?=
 =?utf-8?B?MnpxTGxpbTl2aW8zTVY2VFNuUGh0RmJvaXVkYUFRUHg3V3krWkNDb0orVmJs?=
 =?utf-8?B?TUpYcUpJa3MvMmxUejlwUDZBWEFkSnhHaDBYc1cyMDZlbnp4Zk10RElRYjQr?=
 =?utf-8?B?MURzK2lBaUpyS0VCeVFYcCt2b2h6blpManBMcDhMN3puM2NnN0ZQd3FVOHU2?=
 =?utf-8?B?N3FsR1RGd041WEJyNXZDSSt5K3E5NnBFUlliS2xET0N2LzVDV256TS9RUHZu?=
 =?utf-8?B?azJLTnJqVHpkTjdCRWV5Ujl5b2lrYURTVEQ4WDBxNk8xRVJrK201Sm1YREdT?=
 =?utf-8?B?UzRCVlJKM2haNFJXRzhDK2RxZmducnM4MzhjcExoR3BGR3RjNmRUOTZVZUNi?=
 =?utf-8?B?T2JDeFRxbHorMWpSamZ1NDZUMXdvR3YrOHl3ZmluVmw1SXI3SC9kVTBVSVQ0?=
 =?utf-8?B?azhFZ3JkZ05OSUx2dGpiVmJlb0YrR014OENHeWxaN3VoWUZPRXJDNG5qK2tp?=
 =?utf-8?B?UHNoRjd5cjFkS0VPMFNqY0pnYS9WbFBoM2ZGOGZrOEt2aUR6eUZEaWx2MC8v?=
 =?utf-8?B?ZmtYSWplQ3A1WENRaHJiK3gvaFcvcmtNY2RDMjR2bmtIMDA2dVJSWlVKY2Yy?=
 =?utf-8?B?SXV3NTJJTVI2ZkQ0RjlwREMrVTlkb2Q3LzNQUzVtTm4yWVRIOWlSMWpjaWdK?=
 =?utf-8?B?bGNqQzM5enJNVWg1c0RpUXZ0UEFld05aOUZvOGxlV2EzeWlwNjU4NmlMOGhl?=
 =?utf-8?B?ZmZTRXVrSjgzVXNiT2RqdWVNV3F0NmdLT1k3cUhRVHozSEpRb216OXVqb01j?=
 =?utf-8?B?ZjRGaFVrcU55SzlSc1FkSFFoaWIyQUkxdHBoa3pERTVzMHlvb1p4M29yWDNK?=
 =?utf-8?B?V0JzcDZRZmxMWHAwQnZlb1JjbHVvSVNkUFdQa2hsYTdQUThEVCtUOVBtVW5n?=
 =?utf-8?B?N0ZaSjFwRUJRU0YwTExIRC9aZEd5WkkxUEJyUnAyZlROSXZjRC82ZGowNW1P?=
 =?utf-8?B?ZDBLMGFrZHNaRlBxaVVMM0tDc0VMU1dlVnRSQkorZExzTXViclBFVDhRV09W?=
 =?utf-8?B?bnBmUzVDQWw5cVB1SVVkZjA2MHBxTXQrRm1VRE5vdmFmWGZaakZVSUd4OFc0?=
 =?utf-8?B?SFYxS0JaZC92eGlBOUM2cjRtVDBVbTA3UzVDc3VSTGJhL1R1a003dkFFUVFM?=
 =?utf-8?B?STk5YlpyMUtYcGhYaUJ5bG1GVzVRYmVZekhLQlJoUWRFWUwybDJqNjJJbEhh?=
 =?utf-8?B?UUQ3aWtQbzR6L244Sm45QThLUWRJcGVDczRYUmJPNVAvZHBKUkl4WFZpUjRC?=
 =?utf-8?B?Q3BGcWdIVGJFa2NUVzVweVc0MmdKNndCMlR0eXdTeUJZdEcxem9YNE8wcG5X?=
 =?utf-8?B?Rldxb3U5VHNSSWk4ZXIrRGRRaWZ1MHMwdHpzK21ISGVoZTZmSzZqSkNuT296?=
 =?utf-8?B?S1RlNmJLKzdqMEtmUytiNU5pSzB0bVdFMmJSaHlCQXFYMjB6U28yWmNYKy9D?=
 =?utf-8?B?RERyLzRZUFBlajgrUTdyb2pjNnIxZ2w1SWFNYUtmdlJNenVRYU16WjNJZDRv?=
 =?utf-8?B?RWFUa2liYlFrcmw5bDQ0QWdTdE9kSDEydXJwcVl1R0l6YjJoZlQ5R2xYc2FT?=
 =?utf-8?Q?EP95GP3KyltwD+vB/4b4Oa1Wj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8tNmUZC3HJxkxGZBUI9QHSOW6/TVx8AWvbedliKH4LhblbAzKaTlLh983CSHZcJxBlyJ36gdCwpNn/Xrh96/VoZ76Eo5Eo8WSbEMqJ2cBh3TcSD/XBKp10FrrIVuVzUZhySzcohDcff8GuuHrQZ+zh2D9P4GTT84qI5Rwu/yw83mnx100ZoyzOBefvoDKLYtAhqBn61McdLaYXI0t9GvOST8ZmlBX8kwS0S+Jiua6BMGt3/lxr9zP35RP6VOqlZAQBJRl1VGmK1f6n0FNGm/9S2NBwdY2xm+g08sHj9Dic9R5gK1oq0KhIwxwN+fuxxUY3G6TZJ+lm2V8RbnlXCZDdRExZx48+VjxxLWfCR9WNFf9LksAOQtKoYpshi4PQ5qn+IYz3TTWzi35aX8r/amfL52e+DSviSTfC4sFN63QHuSdU8UoR8Xjsx2P2R9es7XVLFxbvaVZWw3AT5SAWHLapGZkhY2ZXIBXH04kk4+2UpK9qZ2WOIBEg/k0WU6ecCJHO5x1p751Fm098fSfptQD7e0v5KOeZrQmTy829TLABRUE9qle2V0cvJ6DiZNSqlzaklccOkmkqiQXpCc2yekjo2Fu+s79sHfXACWRehVMyk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca12b50-0db5-4018-c540-08ddddfe0113
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 02:21:56.8151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9Bd/yJa1ZPOknMsJ3hfCrpSKE2mzBMO8bkO/wY7Jb4tNHXQKnuuuCr+Z+Z9AyuC91ZwB3rn857ft4fzyPSLmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508180020
X-Proofpoint-GUID: ay5ZC42Ms8iI1ibx1TGXemnrtNm9VCkE
X-Authority-Analysis: v=2.4 cv=dN2mmPZb c=1 sm=1 tr=0 ts=68a28e4a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=zuLzuavZAAAA:8 a=yPCof4ZbAAAA:8
 a=zUuTS4Ffj5G4EHAs-5kA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDAyMSBTYWx0ZWRfXyG7MySQgFumg
 AGpwZSydzWeevOOwqQ1iIaPDLilGmFQFT9c8DrzRuFFxbCflvz+i9DKd12TDSxvR49aoaQG5djO
 fux1wn3lMYL/HxGop0QiDxfbxChHlH7IzI/E+UdXyu1J6TRVh7qmdJanY+GEnQNT3Tuv7+4dFAJ
 3i8xaAlJj/GQqlIQdBmwpSkNIiMW79/jjvaCV2m4MyYRmGa4YDNQUiPiyXPKpaoOs68cSFSK3ci
 FT4HQLQQu6Pdkby8lFAcml/ucC/etFY0bRlKjxq24mBLt6iL1oZxOAEcwqKAOoLCev9Uq8cHWuX
 sHu6whRTWfqnOHVDEfy7WqbCuaS1V6IhpGbX6C1tS9j1l5RQZHkv1BXo2ftlMiJzlDiY3KKSm7D
 LtII/++8ByviZ48wiSuWwTc4vJYmSOGUF1eZu3Rw/dmaJGuBOlyzq/gkjCGaFtka5IaoHI6y
X-Proofpoint-ORIG-GUID: ay5ZC42Ms8iI1ibx1TGXemnrtNm9VCkE
X-Stat-Signature: 1ekrjkibf4r63bj37pswccoo93xxaubu
X-Rspam-User: 
X-Rspamd-Queue-Id: C096114000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755483728-103352
X-HE-Meta: U2FsdGVkX1+omo6iKqiM/5sDvk6f/hRRGrRz8eDow/10fdFth2TmFaLqOeuHObWEhdLWHSBzBWzZogrxUld2QEChz4BmFCtgRvvFvc+6UyO06gJTo/dnRExaxSJ4Q+ZK2AI15b9utGEjKjr4z4FNycxssRYiW8uTLyRzH57BBfZyvR2Z+lZGdqRiVSIOfszx6k/5YgWUbPDYJ+yvgUAvwzaG7p3SiWvefoB19PbowBxHGTfGh1K12qRZIlgP6nvzMrnCbsct7Nu6T2rhQgNGbaBrhLfNXIx7kAKhzW93srKCAn+MLYme/FzyoPJdnjnW93ozbsCvnaocYWyBsbZIREgx3Mp/HdiX8vXPQ9eH3BpJvxlkzncnzidvqfF5Ggq/STF7B0hKluVQpf7ZFox9R6wOBwmAq5G/G61QtiRB3wPmwYEYinc2aeCt4THloZtMvaxYvT5rMr60TLyj+qLlDUI+C0EJ029StqBHFyhEMox1Jx1bTx/5IqjNw0CIOSGxY+BZxt0EGLUfdvqJ+dHCFykKWENzFjmPXNHyJurRRv95YQJghCn92KHKzqf+v9t4WzXQVqPhdBWutBZrZU9uNdEwr4xz1qxJ/+k1YHegL/Z2CC3JOg3NQKEjocqn3Fpz1EtPKqymZ0ANPlt2UENBe+c7ou9GdSB66gq98WSvyLrkUdXVPl84o85oa390fqJoylfw8YSpE8A2fvdhIy2OY3TPgnFiNl8Lm18UZTkFsRznCszcXYjDPufGM2ahxZPMV2M6RJ/P8VS6jWNN8TVwg+uLMsFsvcrcWvuqCqVDX/DCYZEp0MzvtC0SmCiMtVnLS4tt50mkNpkLoobM7RLtflS2VMBDiuhaQNk+UHm2WJPwbeGmZTeYViDt8H3XP27fVgRghY99JlSYd7ughNTe9o4nu1c68GoPijUr4PJR5sqe2LrGCMDbshMy9zxZX4YDCJWu5k4bVgs0oMhTCgj
 qXNtSs6E
 G0htM3Y7Hr53KaakqOCcK7FOaFfPmXMsNyhLlxjBgbMuVI2dzw2MmmePIN+/uJWBxC9vECHI/rhYkDnU7Xg83E+z9ZRIfGD8sYbfoIAHeg1Bi5AeQdN3lxM6rp2fwXyp7cSR4NdP9hDbRNmkepqLyLI84CtSZW+KULAh3ktsojxfBbvCml9QB5/eDSkYJpWaaJHsPJ0gkwND+I0++jDcig7ezAblfP1dLLhVeect3coYkyEBx1H7N443LmGZ0c+xp79cTCW/t+I8ZovN88u7aly0lWHY83ZI+/2GQpX2CTPUHfQQyKCkv2oqqMa4S7IFl2vW6Y3ALM+0EYombyqI+dOpKExQ6UytfXn53ZHTKUdeuK3xlLV1P41KQp15brG1igUdyHcQHl8pZtbB4kjOA0Dxno1heUmd0oc6Fp9AkYwE3tg7dhUylQZBYL3Z8j15qha9oSEe0oP1u01LMfZcMJ0CXmgQe6K2npzMpTkrnFTsltdCJLhuawH58QCtDsxfH9nGfs+B6bFSe7q+Dzl6+LWQMKi2tRheT5aGSPKxUJBqN11iM5HHYHxDWF4lykbEyon8fgQCuIL2+dUnjHNj+il+dWCNavhAjI7QAfX2w7AaVdJAWq9b3yrqjWt7kVAukuTktueLbkh/uYnUfu5T7GYkeCBN1dHh5q8PtxA/rKr0SWf2GO/2xGgwzIL00neLN7TCmXX7Cr7tg3tS04UQ5kxlwsOpzMMtXaEk/FN5SdnwHjAtW7phr/SWWcl0mCXL4+rVvbLSJQ7A2lKpqXq+IwnR1rr7vXn3ONBNccKsx+y7SXtMs1AVb+V0dnX69kKtheN0JLKKXS+VTokzMVv9A7qB8tnbxi2cS6aAt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/14/2025 3:23 AM, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Optimize hugetlb_pages_alloc_boot() to return immediately when
> max_huge_pages is 0, avoiding unnecessary CPU cycles and the below
> log message when hugepages aren't configured in the kernel command
> line.
> [    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v1: adding the reduced log messages in commit header
> 
>   mm/hugetlb.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b..514fab5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3654,6 +3654,9 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
>   		return;
>   	}
>   
> +	if (!h->max_huge_pages)
> +		return;
> +
>   	/* do node specific alloc */
>   	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
>   		return;

Looks good.  Could you add stable: ?
Reviewed-by: Jane Chu <jane.chu@oracle.com>

thanks!
-jane

