Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC69CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E736B002C; Thu, 27 Nov 2025 18:57:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F336B0030; Thu, 27 Nov 2025 18:57:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA7D6B0031; Thu, 27 Nov 2025 18:57:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D84F46B002C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:57:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67D19130DDB
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:57:48 +0000 (UTC)
X-FDA: 84158052216.10.9F1E122
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id E975C1C0007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:57:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="f/TxZVac";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="h7rp/ZmM";
	spf=pass (imf20.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764287865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIbIplWHWjnG6eW9QkjXs5s72IVTbhuKaBjDqWJV5/U=;
	b=l1SelTTDyc03SLM69o3y+ol7fRidk14kRV0SW2LtON7NO3uxTeQtgJsgO55ItfFe7oteYz
	XxzmYWhj5iWJUasnVsFZG3P6QiA3ya0t3nURVlUxHlC/a8pdOYNE2n5Dh0sl9fp6TZwPLo
	lVpQ6zUG4TK2AxjmomhUPTOKK/PT3RE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="f/TxZVac";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="h7rp/ZmM";
	spf=pass (imf20.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764287865; a=rsa-sha256;
	cv=pass;
	b=oTGnRYTosNHnR0+4nHBgqDmr9feaBUMQkoCvMBI3BEJuUdZ4aRlX6V3bQG26Ht3mJeNRqD
	iyraHiuKNrUbwPbIwKOIylTsp/ihzv+8PqNIUATq9UjH4PatZezKaQr4JvB62W5+adyJLj
	BA6cVhYap09c9tOgJhfDlnmGPUlLaQ8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ARA8O5o338969;
	Thu, 27 Nov 2025 23:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hIbIplWHWjnG6eW9QkjXs5s72IVTbhuKaBjDqWJV5/U=; b=
	f/TxZVacRuqnEXcnaZT/7yKZ3YN/cNuBrt8fuvIWCHplbA4bkZIPVkF61CPrrZ2b
	/Qg0Pehl2TV+BePkKkdHIf7P6RWyKfwHfGx+W+PpEcGepDM4b4Xo1YzrdsAY2G/n
	ljKuAZ2eE9PLKI813IVATViT5V0ViP9ZgevH/ckDf5HDmHr0nU1oQOyAhY7ZKf7o
	1aOuXHlJIizLC+4J8WPhXGhFuAvGMiPxNviaaGHnTqqIF5PUKaG+N4vxTh+xSfhY
	WE4HLXMIDx3v0YIM9u8Uk9q5lpJCY3NikbiYNtJWJoclP5ID46cKIXa18C5ayFET
	7dVozPp6bFjoni37yfzvuA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apmmnrvuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 23:57:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ARJNZwJ019551;
	Thu, 27 Nov 2025 23:57:21 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mcpkkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 23:57:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzfOFRDJMdTP6dV+rh05CEoO5qC3ZJQMlNNJJQbCJo/b4GrKyhOd42qpm8vn0L1CIbLyXNxI30ZcXQVfaU4gD0lCoea/lOLSDmrvM+hjbg4uLLkLr7OTD0zY8wvCrkJH1UUhOaEQJIKvEkPvXzWJ4pGEDdCcfA/0+tELpQAgzxnvZcY+ncniOc1lkoLA3XSqv3Cjjzblfp/GyM5d5OKxuFh0OHi8AKO/XADRvlzmLhrZC4Ffs/48hXu4M6ahWUk2frVkQf9aDC0m8p8Iv2Rw1Mhye2iymEP1LLNbD2E6Ng1aMPj4OWBUto3KGiYBgE29hVGk32yTJfW/xB5MhW27CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIbIplWHWjnG6eW9QkjXs5s72IVTbhuKaBjDqWJV5/U=;
 b=L75+t8qtYM6+xhHYVsYmjZ4r/t20kywQFT9w2GaKFtGqpSme/zCvtMPvXBSVA6oedJFn9h2dq9NVMZBNjbFHZeeARjYMWdTlcULysX17llwFIxQxDWnJ8Nz45UGWxJaexcwvsfn0jB/bR30epLWAVke/xsGgwCF1tcxNKkOR1jqHLeQHcXMXVtlYnGTeQHEIxQTCdAK66Mx2pNmBLp9QjxQ6iQCLgPC7ti9Rr30JQQ0Hjkelior0z3ormI13vFWRmjDCCM/o3xBIjORXZF14s9BWVRzlRlvtRkH2rbouqCAYwOfrWk/xkEAmzf5d7fE6j6+hRAGZV4LB8bHnB0+Esw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIbIplWHWjnG6eW9QkjXs5s72IVTbhuKaBjDqWJV5/U=;
 b=h7rp/ZmMHSsPLqXlVHGZ2BlLeEk0I5xPoQ91ZXH3LYbr+DgOqNnQ3wZTDZ7NOByB9rPlbH9p1YxD5igaPX5JDGIEwRuG2k8vfRINviyAEv3CX3PlA5BKW+LY4TQ3Z8ZTjQLsdO21SfvVCdeog6GNTK3EMqbbyn9dOCac6iQPMzA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB5670.namprd10.prod.outlook.com (2603:10b6:a03:3ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Thu, 27 Nov
 2025 23:57:18 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 23:57:18 +0000
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-2-ankur.a.arora@oracle.com>
 <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
 <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org>
 <87bjkq8s7a.fsf@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        "Christophe Leroy (CS
 GROUP)" <chleroy@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v9 1/7] treewide: provide a generic clear_user_page()
 variant
In-reply-to: <87bjkq8s7a.fsf@oracle.com>
Date: Thu, 27 Nov 2025 15:57:15 -0800
Message-ID: <87tsyf58ro.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR04CA0382.namprd04.prod.outlook.com
 (2603:10b6:303:81::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB5670:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a3f5d74-59ca-436e-a58b-08de2e10b161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkZ3MjM3em1rNy9CZ2FBK2hOeXJPU2VZN3oreGU1MVNKOTRHZlVaU3o0c3Jx?=
 =?utf-8?B?eHZ5V29qZWdNWnpEZFpObDRNOGRiZXRWNU1pMjd4R3pFRjlIbFhnOFNmYmVo?=
 =?utf-8?B?YlR4cnJiZkZoMnhnalpOcnVJaTh3enZmcWRtZkRJQTR0U0swd0tkSzdGTkxi?=
 =?utf-8?B?T2lVM0lZZnZ2ZU9lSHI0NmlNYmYyYmVEOHhuMUNPYVA5MXJVRXp1dFFZa3Vq?=
 =?utf-8?B?R1NFQ0ZqVXB6YkZWcmJYNXMvUlVFYjF3NjVSc1VzZHpHdy9zOU5IaUZHRDBu?=
 =?utf-8?B?YlUzeE0zbFFLM2xqWG5oMVpiQU5JSmhyaUhTNC94MnFDNzR1M296V2MxQ08x?=
 =?utf-8?B?bGVJYjY0UE44V2hDQlYxc0o5TS9oVzJCaGd3eFFSQnlhM0J1YUx0d3BLYU1U?=
 =?utf-8?B?ZWMwbC9wNk5YR0VPMXlKOEJiSm4rbU5OSWgza05KMC85MUw4a3RDdnoyRHhI?=
 =?utf-8?B?MnV5ZTdNS3hDWXpUS05pUjVSVnY4MmlGOHg2VkxKdy83aVU3c3FqaWtkd2o2?=
 =?utf-8?B?b2Zjc25BTnRxdytSZFZ5QzhQb3dWd2FFejVRTlY1ekJxZXg4a05PS3NINktk?=
 =?utf-8?B?WUlIdFNVSG01cUpHcnVvYmgyeUNJWkxhcFJXNEpUZ3VMdUJXdzEybWYwTHF3?=
 =?utf-8?B?amRPdU1aVklURTRTUFZHMlhBVmFyc0J5aGhxOWk5TGlRTEdWaW5zc05ZL2lw?=
 =?utf-8?B?MXQxZFRsdVRUdk96WFlYMWk2c1BzU3c1UmhLNkpESWQrZUtKaTRDa1hQZXRt?=
 =?utf-8?B?ekZVR1lDNDE3QkFyb0o0aVpEK2tvaHBZMjEzaTBxYldyOWc1c0tIR2daVE1a?=
 =?utf-8?B?dlF2QUJvaWN6dzRYWHRHOUFXRVZNQ1k4UjE1MmFneWl6NzFpcTQvSXk1cW5F?=
 =?utf-8?B?QXJ5Uis3YmhPc1FkZnlwcE16S1dPYWtPNlFkOGc3b1NEbjQ4MDhCZWl4bWx6?=
 =?utf-8?B?R0gweENsM1dsYjNGdmJqbWs2T3hwSlRFd1lLTEV6d0U2eXBrU1kvb3gwOFpi?=
 =?utf-8?B?UnhzVU4zVnpSV0ZYZUNob3RaUDA5aXkzaEI3OFIrOStidk9vL0FXZ0JUT21q?=
 =?utf-8?B?bXdBTHFTNUJyMG00bTYxa05Lei8wdFJrcXluMG40LzdCbVNiWS85NWk0M0tI?=
 =?utf-8?B?Z09wY1dIcUFRbWE0eVhkTmRBR01SeTlMWmZ1NmUvL3REajRjbCsxN1FFUUZU?=
 =?utf-8?B?RVZpbExRM0g4bGtSYjNsSGptVCtPeG9lL0xxcHQya3d2M3NDaDNCNy9oOU9K?=
 =?utf-8?B?bW11bUozTlpHQWJRSHhHVTNRQ2VJb0UzdjNBUTV6ckttU29yL3o0a3Z3Y05I?=
 =?utf-8?B?blJFK3ZScXpMdktxNnUyZXJRNzhuNnVPWXc4Zk4xanc0Q1IwakpOb3FOTEF4?=
 =?utf-8?B?OC9Nb3I1Wm9WMXZlMzNPc0ZITmpxVnJmdFc3TzRsZTMrNFc1THVpbGVHdUhZ?=
 =?utf-8?B?QkF3UThGSW9tckovWjVWTnNraWZ3S3ZJSUhJbDB0QWw3ZHdtb3lDYlZnYlJ5?=
 =?utf-8?B?Q0dySCtxMTl2UHRGZUh3d0FRNjBFU2pWWnhOQ21FTThkdE03YWgvK2FYd1VE?=
 =?utf-8?B?eTBZREhFT3hhRnJmYW9CU0NhTmhQaXFmd0VnbzhzNkJxS2hNTXRBTmcxR0N6?=
 =?utf-8?B?UGpRZU5PQW1rRlhKNFJKaU1kMFlYOXpmcTNsc3EyczZORXo1dkcrKzdyWEtS?=
 =?utf-8?B?QTZaSEFJendoYkU5RGF6b1hZQkJlN0V2ZFhNYThrK2dOS29rdTd4YWtjVHhE?=
 =?utf-8?B?V2JWdEN1UjJEWnVkY1NwajNJbXRhV0UxUmUwT3UxUjg2SXF5U05EYzJvblQ4?=
 =?utf-8?B?Z1ROSkZSRDgrMTVDYVZaSzduNEN5alVhWGx6V0V3K1d5blpHcFVBSGxkelpF?=
 =?utf-8?B?MDRjWFBSWTB3QlFPQy9zWE1vYUJveVY4eUZvQXpFSlpkNCt1TlRwTit5SENW?=
 =?utf-8?B?S1pBbUZrT0ZyU2MxTFJValE1ZEh0aUM1RG4wUzdDRFc2QitHOGRjTDRkL21S?=
 =?utf-8?B?RmxoQS9ISkJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1QxYlcwOFYwdWFsNTNzb29QR3ZhelZ2cWwzcHhad3JxYldMRk5EUVNtZjdL?=
 =?utf-8?B?dU9BNlhyYlZJL2FNeTN1allPalRkNnFMWWJwRGt2UHU0VzRQWlQvRnhpdDJt?=
 =?utf-8?B?N1R5NllOaG1xTVJ5VDZWQTFmWGVmUytDUStwWWprcVhSSE5hOHArUHNIZU96?=
 =?utf-8?B?YUVoVWJ1SStkbTVQS1hkQVBSRW05NkN3MnZnK3NxNnVOOVJGY3RxMkxqdGkv?=
 =?utf-8?B?dEoxM1BEcStTT29KbDB1YytwM3VZSnM2U3dkazhmak01bnNQNm8yS0l3TlNq?=
 =?utf-8?B?SHBQeDNMWktQUURqVmZIQ0V4SnJCd0VVeURXcGcraFp2eTAvNXYrbHBuUlRK?=
 =?utf-8?B?WjYxMDlMWElyaUZDUEdJS3ByeG9pTkNNRkVQUU9nc3piYXFFN2lMTGk3blN2?=
 =?utf-8?B?MDluTmxIc0w4UkhjVW1vRUY2M3ZKRGlOaHdlV3N6MnY3OVVkTEloWThKNmZX?=
 =?utf-8?B?UzdUblVVdmJjbU4wanM5YSthMVN5V0dPUG1kZ0dyM3lXK3hnZDl3VkVYRkRE?=
 =?utf-8?B?Wi9nWGlvMFV3bDluSE9rVjluMWg3MGJEOFpyVFdZZEVWUnVnMEs3MGxXcStu?=
 =?utf-8?B?U1N6RTNkQU9jbi9zL2h4Z1laNm1SYVRCRjBqUTRVMVRnMlgrVmR2ZVpndzda?=
 =?utf-8?B?TW5YTXJySjUzRmFTL0Z2bmRGMmVaSXdKcVVBQmdmbVp4MmgybzNxNjRrLzJM?=
 =?utf-8?B?SjNnUHFIamU1Tk5rS1BTcFBJUWZvTG5CdHZKVmJxLzhWaWFqUzJUTGNPekZD?=
 =?utf-8?B?NjZYNGNwVnEwMm9xbGZndzN6Y0ZOSExCcUNIL2c3N212aGo3YWVIVE5zRVBx?=
 =?utf-8?B?ZXU0L0M2NlpqaGFKNERuWTRpbFF1SHBvY2VDNVhhaUFTTm9NYmREUnA3NnY3?=
 =?utf-8?B?UHF2WG9nZ3RSaVFrbjBXa290TmpFa29aTjUrU0JXRTAvVklnd2k4NVZYbGh2?=
 =?utf-8?B?YlRDYjd2em1EbDhvYTE4N2lDUC9DSHA0WjdXTHV0czFweUIrLzVLbDl4eUUz?=
 =?utf-8?B?eElwT1hxQW9Nc0tKQXpUU0s0bWZWZU1NTE15bVJvMzBDTWk3dlRKT0RicUxq?=
 =?utf-8?B?dXFrclhVS2NidTVXV2ZoSndOWWxHSkVjL3ljbjR1Qkcwd2RXNHZBLzBjb1lr?=
 =?utf-8?B?SmZpU084ZWxXQVpRRFFXS1lxa0JveEh5TU1FZm4zT0NRQzVUTzR2eWhWRnZL?=
 =?utf-8?B?NnE5YnIwd2Z0M2FUUGM3d1JzbU1kZ1N3SUJycitpVGFXRFdhSXR0bnZNZlZt?=
 =?utf-8?B?UTFtRUxOY0JIOWJtc1lFcDBnaThTcG9QQTVOcUcrZkxUS1psNkJvMCtObnZw?=
 =?utf-8?B?UlZtbHFTeXBKQmZYWjRhNkVKRXBjS2xBSGEzVmFVZzJmV3pSdFR0SmxuOUp1?=
 =?utf-8?B?MXZXQnVmUkNObnRLMzFmTnFkYjNDM01HVDJvOFRWNFlNTm42S0RMcm5taTIx?=
 =?utf-8?B?MExEMVJocThwY0VEQTNoQzRDZ0dod1BrWXdNYmhtTVlEL3ppVjQyOXlhRmdN?=
 =?utf-8?B?YzZDSXQzU1M3VFZKQnZrR3hOZDJJTzlCbGprRGd5U2UwT01BZUlIZkJabmRK?=
 =?utf-8?B?N284S1lOUW9DSG5QZVFOaWhaY04reGRqaEpKbDBKcnpseExkM2g4MUQ2WWxu?=
 =?utf-8?B?bmtSQXl4ZFBSTXY2dTRIK0lyOFA0TkZISmJ1M0lpL0k5Q0hiMFJmZldkeWts?=
 =?utf-8?B?MG5xZjdiMHdaaFlLNDVxUkhpYk1QNjM0L1c3MXlON0lKZ01rcXg3ME1rUS8v?=
 =?utf-8?B?LzhZUG11VGk5T2V0c3N2ZWlHdldGWkhGaGlZK1ByY3RsRTZtTWVUb3pZR1dY?=
 =?utf-8?B?WE8veUlKMVpGSEd2Lzg4ZURDK29QN1BZRkFYV0h4U1dianZPRlorb01SOGJB?=
 =?utf-8?B?Y1dyQW5yUkMvZFd6bGxUYkNEQ3FLUm5Ka1JxRmRmVGR1bXRTUllxY0UrVzF0?=
 =?utf-8?B?VEd6NnF3SE1mc2duRExKKyt0TnJoR3JaMHByeVlEWGhWaEQvM1g3RksrN2pT?=
 =?utf-8?B?ZTJxOTFZR2Y0V0lJbHB6aU43WS9LMFV3M09qdTl3d1JhWVhQZVRVUGkzaUhU?=
 =?utf-8?B?ckNEc3RZLzFmTTVScWJzdmQ5Qm92VzJLakpOaDJMQzI4NmFUcjk5bFoxSlh4?=
 =?utf-8?B?ZWI4Qk9RRWFDRmtxd3NYMldlbTlmU0Z5NUJrNG40V0pselBaQnBWSUQ5a3VN?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	50Iq8xMChSS5jXm3wAAoWoycSsyvAJc/yLADG/DiwBRZrsmK6w4vygfDQlOtHOLNpBf/Qv7FKuxjtI/MYUQyDyn514THQOUWcXvKBhjQddJ5h59rbOD1xsGxlk/DxXlOUI/gxdGcyjuMGIwyhQJyogVtmArhxOAoFGA1zKXXeP/IZSRIgIo6Kp7OiZjJ7lEia3MQMiAZOPhq3PPRH0Fh7nEnjcyVS8XDy8v1hyy8NbCHHORHJvf4pmN/uTnaujHgeaaAybGXHDmcYKrbUbXKfeMP4pyCn2AI798xjMbgXXzfCZJ00yFNIrPu8U/U/9LrelJrsJRYtOIWlRnwOfez+CdleWrFU2TW6cJKJUOPPBhJDBjWd4j6i6Z0aUEQG/TgqAqFqrTsW0X4RZZcxyywncJrHH0DYChE1KffhfK82+DQeSG+mVrlf3vrLcDauzkUTOxhSY1zuperKLSWBFWaosfHVxM3qaTkup5BeddiuhZ1lXxqQ0jguNH7GVKrb4KgJvSxexZq6KdvnZOeu5QZNqrm1wXSPYagpoF/T/hvP8fiSvTfaDQJRMg20H4wFr/VcVu/oBIIOF2ZxCPVzb5mzcMZFqtYCkjIjIvq3GOBRmI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3f5d74-59ca-436e-a58b-08de2e10b161
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 23:57:18.3769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vd9VPA7Lv8MWlMsk0VCGYEeOozNVY7TrAPqLBx1yrs72nvqu2ioHxBrV6AykrelAn24vhys5FzVeOaIT1P8YcWnKc0Le8q8XxbDQlha6uLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5670
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511270180
X-Proofpoint-GUID: quFtj100Do8Juf01v5s79gw53mKwmKgg
X-Authority-Analysis: v=2.4 cv=TMpIilla c=1 sm=1 tr=0 ts=6928e563 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=NEAV23lmAAAA:8
 a=ipmlAbvLi9DMxBJ7yNYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: quFtj100Do8Juf01v5s79gw53mKwmKgg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDE4MCBTYWx0ZWRfXyFSqqCZcHvji
 yCTg++ZIbWA5x6trhoS6kiCvgNc8zCV7pL9KLxy0uMqacnHyvvGMtQPvfsxRImaW1dzPU2jj+Xe
 KS5d6EqeQrmIaxOP24Jb/ykg8hh6aeUl7C2i6RYrRJrcnKVxoYyz8DcS+3t7xkcr7PS2oI0b1ZA
 bWNvU4c/JhVn6N8gylncy4nZCKTkECbIFgNxw9Pa1apFdEckkk945mS53VPi0gRR7YZ8rG3S8h1
 3JHbXQ3BSV/d7JE202U0JIdgwmZ+ljGHhN/bF4XZrbaV8V95eRV29L/Y+FMJGn7Pc4LwyQnH7m+
 JKH9qR1s8Xwtrp+PVGnTjWYCIPkVTTAz6/qz0IIAwF4BONDlgf+KURddpDEyYj/Ackz9p+Sejxs
 cgTDpaER3lVavIgG1OQF1VpeHLVpPg==
X-Stat-Signature: 4ss4p598ob89yqc85wgahc633z5ykw7j
X-Rspam-User: 
X-Rspamd-Queue-Id: E975C1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764287864-550646
X-HE-Meta: U2FsdGVkX18HUF1PsfJI1SH/OOY+OZVzTaVU8OcJS3h4sbAI0O5tKrDMSw8vm/BJUIwBR3ltBEfUwAEhUUbaNeu8yQh+0hSVAdqQ4VWEMSUgtjvQ3NDmhgrdA+8odmxV2XY1RAgojR/a9wWIqXX89bX4c+d/ctI4Zqxnhl7XlMctq7fRX8gIoaY1ei8cKlsmLkR/RlUM9A+myFfQaNCUFI6jbSGm4BShIchGR1vjywHNOe37lx1k3DQhAc1xKJVbw8wyKF0yLatltQUS3/2pVfQakPND61Tft0y82miJt3QQ4CgDJtlqdUOXE8XgP+VpnyqLyXLg44ayrXNDojwQ3UVieLPoeJgmdYxEzk0jKLLHUX0RRX9bX18/SMr1PXKJYhhpAcPVYP2bsF30rtb9a141rJj3LiAP7ZshCyaBG6UtSSukNIvKKblXvZr8jcrE3pp8OuQK/ayHayZu53Tnz6OqtAuYRXaPBfPswVP2hSp9auZ2NPWIS3hZCYnddx/ztzofgNSsDC+oITZG2Q5awG/qCVxxw+4LBmURbGHs52G1r8TBCFPSKdVma+iqnjfpGD3XSdf7P79mmzekdcSG/3fvbLoALkvSCdewWcmMKJOhEvXrU6A+vkjGtndh32XkbyHqEAgnkKhoAoOOvjW38Xno1SQB08UZen6F7e/GrhdQ0CkTyaXAXcazuYlTaPjNwmWtQs0k7fbOEJD+9mLttH7ClHAz41xF+kM7VwXmS2B0SgNL+gYJn04y0bvCORCRXcfDZKJqPhzIkKWBHoxl0IZmcCFMPsSGLBnJR4O9k+CaLSR3zovQk+vfFhwnghfZzLR5hGbt0sfPApWFZr3GrjBG6D7MuSiKfbrTBs4m/OF85al0FdOb4/3zBFtHwmJ4T6BpumokIbOgaZoOPeAL6yLoeRkGlBStLRSpasdW8cSjqp7AD0wZ4EFxq7XOPALEiuwppeQRFRulOtq+PQ8
 S0c2MB5F
 OAFcs1/+Ct6jGheS2dAG1a+pZRxJpDxyIGLzQawSpVKNlpF+3X/VgNEbQBOienfu1VfIWYRZ7s0ciWAl7WDQIGvSMUm/xIxkYlJ6Yb6VKssNYPGdtEtKPyJNUMnhwj89d8nW8avnZxZBREf+iCktdGcf1RwEoj/bFjDP7d1DVUmAuXbelMr+caNuvTdACHQGdavBp+Y1F8bS51Kodo3OsCo7znuQl/5fUhQF4NEvDcJXegMsm0SIKIcWGwf9+hwhU+APqSAgrgoFfiRAJUG1IcgDSs2f82j0s44omK2LPes5bBLPMDnDjuinYQuHXrf9I/UzWWG8xo8ZaoK8XOrgpnDBnyMEdSsFLOTjmlpEfI5215FqQMvvWjA0hHr2MzevcUHKgtn0gdAjr/bwONYbXIN3HGepnIbYI+Yoxyx/bWgdb4N1SL7CpTBwzr9go1oUQ6CPbnN7kh0R/BkPhLP/Y9Rzygq+89cDbNzPAtiSL83Kd5aS+4aJG7fuZrpUpQniZL8cNsKXeI/aewn+26rI+psDWlmPmNs/n8BKNmwM3qnuJyv69QH7Tkpbr+uEGPM/FJGw/x7wkI/ubJzYNg4QUjUz3qKdHCamCqNKJIyMjATliGTNQMBCl1PT0srnlHL2P81cAKxiySAKmxzkruxOPoSfqjxwr4+WVgbp3veVGKp+rK5J8egh/Fql7XX0HIpPP6e65RTX5kSqLeGFRyea1Ayo6ENEQpJivYrIDP2wP6vWCz3ctcKDl4zcrgVV3Cj9lAOvHCLAp1PeoJys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Ankur Arora <ankur.a.arora@oracle.com> writes:

> David Hildenbrand (Red Hat) <david@kernel.org> writes:
>
>> On 11/23/25 12:53, Christophe Leroy (CS GROUP) wrote:
>>>
>>> Le 21/11/2025 =C3=A0 21:23, Ankur Arora a =C3=A9crit :
>>>> From: David Hildenbrand <david@redhat.com>
>>>>
>>>> Let's drop all variants that effectively map to clear_page() and
>>>> provide it in a generic variant instead.
>>>>
>>>> We'll use the macro clear_user_page to indicate whether an architectur=
e
>>>> provides it's own variant.
>>>>
>>>> We have to be a bit careful if an architecture provides a custom
>>>> clear_user_highpage(), because then it's very likely that some special
>>>> flushing magic is happening behind the scenes.
>>>>
>>>> Maybe at some point these should be CONFIG_ options.
>>>>
>>>> Note that for parisc, clear_page() and clear_user_page() map to
>>>> clear_page_asm(), so we can just get rid of the custom clear_user_page=
()
>>>> implementation. There is a clear_user_page_asm() function on parisc,
>>>> that seems to be unused. Not sure what's up with that.
>>>>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> ...
>>>
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 7c79b3369b82..6fa6c188f99a 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -3879,6 +3879,28 @@ static inline void clear_page_guard(struct zone=
 *zone, struct page *page,
>>>>    				unsigned int order) {}
>>>>    #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>>    +#ifndef clear_user_page
>>>> +/**
>>>> + * clear_user_page() - clear a page to be mapped to user space
>>>> + * @addr: the address of the page
>>>> + * @vaddr: the address of the user mapping
>>>> + * @page: the page
>>>> + */
>>>> +static inline void clear_user_page(void *addr, unsigned long vaddr, s=
truct page *page)
>>>> +{
>>>> +#ifdef clear_user_highpage
>>>> +	/*
>>>> +	 * If an architecture defines its own clear_user_highpage() variant,
>>>> +	 * then we have to be a bit more careful here and cannot simply
>>>> +	 * rely on clear_page().
>>>> +	 */
>>>> +	clear_user_highpage(page, vaddr);
>>>> +#else
>>>> +	clear_page(addr);
>>>> +#endif
>>>> +}
>>>> +#endif
>>>> +
>>>>    #ifdef __HAVE_ARCH_GATE_AREA
>>>>    extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>>>>    extern int in_gate_area_no_mm(unsigned long addr);
>>>
>>> Isn't it chicken and egg with clear_user_highpage() in linux/highmem.h =
? :
>>
>> No really, because we make use of clear_user_highpage() only when the ar=
ch
>> defines it, so the highmem.h variant is ignored?
>>
>> Not that I particularly enjoy this way of handling it, so something clea=
ner
>> would be nice :)
>>
>> (in particular, relying on highmem.h defines in mm.h is a bit suboptimal=
)
>>
>>> #ifndef clear_user_highpage
>>> static inline void clear_user_highpage(struct page *page, unsigned long
>>> vaddr)
>>> {
>>> 	void *addr =3D kmap_local_page(page);
>>> 	clear_user_page(addr, vaddr, page);
>>> 	kunmap_local(addr);
>>> }
>>> #endif
>>> And at the end this function is the only caller of clear_user_page() so
>>> there is apparently no need for a generic clear_user_page(), at least
>>> not when clear_user_highpage() is defined.
>>> I think is would be simpler and cleaner to instead add the following in
>>> linux/highmem.c:
>>
>> I assume you mean highmem.h
>>
>> It's not really highmem.h material, but if it makes things cleaner, sure=
.
>>
>> Might be that the compiler will not be happy about that.
>>
>> @Ankur can you play with that and see if we can make compilers happy one=
 way or
>> the other?
>
> This looks like a good change (and from my tests on a couple of
> configs seems to build fine.)
>
> Though clear_user_pages() is also only called from clear_user_highpages()=
.
> Would be good to treat that similarly.
>
> (I don't think it can be done because how the arch code treats
> both quite differently.)
>
> Anyway I'll play with that a bit more.

How about something like this for clear_user_page() (though maybe I
should be always defining clear_user_page() and not conditioning it on
the existence of the generic clear_user_highpage()):

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index abc20f9810fd..ca9d28aa29b2 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -197,6 +197,22 @@ static inline void invalidate_kernel_vmap_range(void *=
vaddr, int size)
 }
 #endif

+#if !defined(clear_user_page) && !defined(clear_user_highpage)
+/**
+ * clear_user_page() - clear a page to be mapped to user space
+ * @addr: the address of the page
+ * @vaddr: the address of the user mapping
+ * @page: the page
+ *
+ * The sole user of clear_user_page() is clear_user_highpage().
+ * Define it if the arch does not and only if needed.
+ */
+static inline void clear_user_page(void *addr, unsigned long vaddr, struct=
 page *page)
+{
+       clear_page(addr);
+}
+#endif
+
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long va=
ddr)

And for clear_user_pages():

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index ca9d28aa29b2..b9b3cc76a91a 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -223,6 +223,35 @@ static inline void clear_user_highpage(struct page *pa=
ge, unsigned long vaddr)
 }
 #endif

+/**
+ * clear_user_pages() - clear a page range to be mapped to user space
+ * @addr: start address
+ * @vaddr: start address of the user mapping
+ * @page: start page
+ * @npages: number of pages
+ *
+ * Assumes that the region (@addr, +@npages) has been validated
+ * already so this does no exception handling.
+ */
+static inline void clear_user_pages(void *addr, unsigned long vaddr,
+               struct page *page, unsigned int npages)
+{
+#ifdef clear_user_page
+       do {
+               clear_user_page(addr, vaddr, page);
+               addr +=3D PAGE_SIZE;
+               vaddr +=3D PAGE_SIZE;
+               page++;
+       } while (--npages);
+#else
+       /*
+        * Prefer clear_pages() to allow for architectural optimizations
+        * when operations on contiguous page ranges.
+        */
+       clear_pages(addr, npages);
+#endif
+}
+

Tree with changes: github.com/terminus/linux clear-pages.v10-rc2

This seems to be fine on a variety of configurations.

David, could you take a quick look at it?

Thanks
--
ankur

