Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3B9F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ADE96B0005; Mon,  9 Mar 2026 11:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14ECC6B0089; Mon,  9 Mar 2026 11:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EF26B008A; Mon,  9 Mar 2026 11:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD2B76B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:39:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFFBCB726C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:39:54 +0000 (UTC)
X-FDA: 84526935108.21.E496207
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E36940009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:39:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mSrejQMg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sEGVHmfe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773070791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xe5nlXmBm2mLq5xaEKziYXKL9OgziiGThfSf1CYZhS8=;
	b=eYlymHUz4Fe7ihs2MJ7cDQ8evnYVVcuoI9gkOXRPo/0gT6KP0J+rgWzTRxK2/nrdtX9dH4
	TbY5uK8clMTHSmKup3zNIXgeKoAQRBgekAiXim42z/q0ZNunjG6h1cgwG2ZCcTPy9lNWwU
	Uk5+g/hXmxCq7aVtY+5z3r1MgwZbLss=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mSrejQMg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sEGVHmfe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773070791; a=rsa-sha256;
	cv=pass;
	b=15qihpr3IDUg/7OfqMZrsZ4uHWcccJYnwsRc3zY96tX6o9SMu2GLG6EwXrdPTUPMyfZESC
	jtAgj0AEgSh0N36kbF7/Xf0V406zniYEcwFInOcY6CoTEb7vpsx4+7zQ+1mGXey5NY0U3x
	nDzDsxl/RzQWV75kihiIti1KrIiCIsU=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629Ex2Xb733187;
	Mon, 9 Mar 2026 15:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Xe5nlXmBm2mLq5xaEKziYXKL9OgziiGThfSf1CYZhS8=; b=
	mSrejQMg2Th+rxA1Fgonj+ZeL8IBeK2raAvVdhjxcQ1uY1Ms+93BMNZfN+Rn+68+
	eSaGUZuRZcOzOhhffXdz8Ttzruz2MKJD00gfgGTpikpi+xg0Gt+8SfVVco2ISYQl
	M1nQyvjROtDHelPATv9+qInKbcHlokbWOQg0KGEm7vQ5WXYGmPVoZ8DIHhVZ99Hj
	MfNLr/fHelvXX0g4rdqRSkO2sSnXpwaRokLK/ERKhHfg0uEqXzr5MFtKU1K9pGLa
	iTLoss4GbPDp0vm55LurY+5444KOzuik/40rrU7eTaJoAaSXxXD4+qkrXCbLmHNt
	Q04hvYZDsMOiVcOD2j+Ibg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskyp15nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 15:39:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 629EkQHI014869;
	Mon, 9 Mar 2026 15:39:41 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafd3txn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 15:39:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9ihQ5496PrC3V4cNp9Al8mLC2pZD4KcLd3x5KvM+gr9oUOLyCv86G59aXHE8LkI0AXss3wgBVej/jYWwiozq/6zVlt9Vym1rOqQg0/XTe7o8JPb4JATZqQFEnMQNwPyifTKuS9qU8im6wOzolzB1HF/1mV2KRuMfPEXavyd1H7Z7HODPegoLafmDdErPvru3fZNe9oX5QdmHzJ0zIaVLFFWJyBUk7IV2z1jFL9yQ82v5KYzL3nzQI4dKG3L+qVryyYg2H+B0QBj0O9GdOP8pCGKj85TvjKaBIStNUDFupuan2VnV5D2UQXFM4dMM4HdhuxqfHnfZTDH5EuDJBdtVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xe5nlXmBm2mLq5xaEKziYXKL9OgziiGThfSf1CYZhS8=;
 b=fteRswrlH+aVpMdKObco6Ve2i9cilR3Y9Tvp4UT2+IhCAQbTwCRWO1LRnWuD+Duuly5a/l3JyvpLk12XWJxzQcYeYbud35+53mZsF2sCHQeAYba+cidtpk+mTnI5ENbklkvmfuvidSPLMu+6gqBWgWcHkB3DAARNGVeniRDR65mwRXTis4Jz7Cho2vfWzKbpyae0zArURB2HY1JV8vNmevzbTl5sPoDIQrsUwHcTiFXSFEG3xGxXFhTkh4KVXGr/fnQthl7w3v96xEOjdL9ukEibYTk4QJVII1lKaH/VLX8N6Z6DNUpYsr5aK3DnLoLNlYVuee51khUiRxq5HD/vCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xe5nlXmBm2mLq5xaEKziYXKL9OgziiGThfSf1CYZhS8=;
 b=sEGVHmfe8c709xhA+YKG9VcnO7SEwq6NoTh+soJVpXDllltwprhHv6138CLWB0gTTGFTjEq8s1rEb73HOXzDKr313fuCExtGqemP8fqerGshVgNQ8HL76Ki7p3S4WMG+t7uZbPGZVNdFy9N+UbzOnnNDkD3cCvN+dIAAvYK/044=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by DM6PR10MB4250.namprd10.prod.outlook.com (2603:10b6:5:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Mon, 9 Mar
 2026 15:39:38 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 15:39:38 +0000
Message-ID: <28842a9a-6fde-4284-b30e-6feb811cdadc@oracle.com>
Date: Mon, 9 Mar 2026 08:39:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
 <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:610:4f::35) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|DM6PR10MB4250:EE_
X-MS-Office365-Filtering-Correlation-Id: 64484334-b8ee-4676-95fe-08de7df21242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	ro9rQ29znwCutksLAEPL/QP8/DM5t1HyLJauTWUuHpPCHaUPOvgC/XFyy//a48eBv0oLGW1swVS1PcD51ZsX/jtXyru0cQuZKct6/wkdMeXFglFA9C0Dt5/Zw3qcuPuA84IsNS9R3y8GGnQzXGmztWyc4QMW/du9ROz41du8ZFTPsU+oB3twpeSweea5MVXO7BU3GRX4IzlnzyYRD3wanPKXioFTfpP5fPVNCB52deMGD4/ZvrN8ri6+dpDUoz9xIJ2aZNECcs3+TKTPqmbv2uPbw/COFYHeRri9S1bynOCWRRQGL7rHHzdU8gV0pKeeX+MBIf63xeInJm+smcURP5NAvKkEGm7Uv+8QKC6yQx4oFXP6XqN7zJpqPFn5YCQwimZxvRx6vHIw+x7sNcuwrhgvHpVFhGog6UE6Mz2Wvu1Y2QhxLtA1rSQ/k3ZFe9UWSeOnF1yP14Vdrd8x8GjzDAcrdeD07wQbBJOVs9praO7aiSMs3MsY/oQ+klmHdiJsHeVE9TcczHgrq+/5jEy9wUENhr5j180DmrWeyEo61gUbZAgK3hMEPzQmjr+fwFF4YQQAAxrYtrjpR9nTyW67kh/JHmefls792FhWI8u3EYJh3ZAP/X6aAJbyJhSezzmPO7nNyoZS72Lc8V60uaEQaPDzx9wUFktsSGsDrtgW517MX1r4Qh9rHxnfP0UjTLRRDMFV4xsqimqfZYvq9gGcYsxnVVvTgXDYJEFVWEzVy0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUN4eDkxNlNFcUNsT2E2YTZYSzlDb3ZJQTl2Z2lBOExnc3ZkMENwNVNWRFdo?=
 =?utf-8?B?T3A2SXhqWmhXU21GRDhTRHJtVlk3Mk9ocWV6ZEttV2FqOVF2cGxpWVU2Wk91?=
 =?utf-8?B?YkFnbWJ1dWs0SFBaUTVWOGl5cHk2UDNxYU1wYVl2R01uai9Udmp0UStzbER2?=
 =?utf-8?B?M3U3RVdORkl2cEF4SGMyN1A3OXhZc3l4ekJ6ZVl1cG5vaEFtR1RkUytubjls?=
 =?utf-8?B?cElZcFFiN1lPWUZveW5LRVN0TUx6YysvL0RMSUJyaUtCS0NPZDNxcjVnM2xm?=
 =?utf-8?B?NGVoRTY1bzFLYWsvTVZzeUFxVU9yYk9vU1UraWRRZm5vdk92eGx0QWdWSHpK?=
 =?utf-8?B?em5uQnpUdjRVY3YvUkEwTWM2NzU4UXlEZm5EMmlTRnEyL29VZzV5aW5jaWh0?=
 =?utf-8?B?UjFKM0xzUmNyMWQxaTQ2RW15cEpCQ21VZzhPYnBEaVc3WXJtUk1MTDdyTEtn?=
 =?utf-8?B?aTFiYnNOMFpJcW1wWW9Xa3M4L3ROcXQ2bkt6TVYrK2VLbXA1dVBPN0NxM2Vu?=
 =?utf-8?B?SjgvZlhkQk1lcU9wUGxBcEowbVlKczVPbjYva25CTEVkaW5oeXNsRmxBMUxP?=
 =?utf-8?B?UlBmcVd5ejE4bDR0ODNKT2xZY2RjZDN5c2xFSzVQTmJhOWdBOTh0WXRZWGFK?=
 =?utf-8?B?MHhuSGxZWnpxUTdsNzFyaklDVlNZdlM1TDhVNXJzcTBRUHowTXd3am5XRmdI?=
 =?utf-8?B?cWRmT25BaW5XaFY4bHNSSDdxRm5XeUV5R3ZqMkJ5THlpMkhwZnZNQWtpa1Mv?=
 =?utf-8?B?ZW1QeC9yK1I2SDh5Q3F0MTB1RWZXallZUlNOSHZ2U2VtZisrWk1wSVNUSUxE?=
 =?utf-8?B?azlmTVdLSWU4S3JPYXF4M0hld2xCOFJTL1BFWmdyWnVwQk8xZXdaWWg4SXdN?=
 =?utf-8?B?eS8wd1R5QXZCek1SUzRwOUtzSXVLaG5MenEzSExXSGN3QWRDQUxIbnhScXVu?=
 =?utf-8?B?eVVqbVljRy85c3hvMmZaZkN2T2pLbE0rTUdZd2ppekdYbERvangyVEp4bHJR?=
 =?utf-8?B?UFhta2x0WUhrUTloMzJGM1NkR3hkckhlYnhpTTRxSXg0Kzk1S2kxR08wTmFB?=
 =?utf-8?B?Qk9BTU1sblJVYzcyWTlMcnFEOGg5eFF3NG1hSFhUUUxScjV6Qk9CakI1WFJD?=
 =?utf-8?B?Z2hoZmJXZnpFcEJ0WUV2ZGUrdDRvQjJLbmpzR212SXdERDZBRldqQUh1dUFq?=
 =?utf-8?B?V0NCYnowOXNvak5SL0tGd2FQZm5iTlRPZXpqN1FWWVcwbjF4Wi9SaFlpSlV5?=
 =?utf-8?B?Q3puTlVDakNIZnMvVU9GWVVzRE91ZnkwWU8rTWVsWDNyb1RSY3A3aTBlVWJT?=
 =?utf-8?B?bnhWMEx3T0tyRzEycmlQUXRBNTJSbDFYSlhsZGNEWDdnRysrc2N5STlTcCth?=
 =?utf-8?B?MU82WUpWR1hXalRLS0ljM0hqa1BzS3NEdXAvOGlnbndFTVpwUWFQNDZCMkNK?=
 =?utf-8?B?Q1g1a3lHWXpoendSTHp6ZmJEbnE2WU9EWVZxVWg5WW9OeWxscFBkQmtQQms4?=
 =?utf-8?B?RHhONjVINVE4S3hIR1pjMFIydE8wQmdXWnhCNmJBZW5uN2Z0OFZLRitHUkI2?=
 =?utf-8?B?cXRVNVBMZWxSdHlDeFZpVjlicXM3UnJ2UHpPL1p1Q2dPc0VzYWhBQ3JvdDRk?=
 =?utf-8?B?elAxUHVhUVRiUnA1Y1VocUh0SFJJc3QyMnF6RnNneUhJMG9TQzB3QnBLKzkv?=
 =?utf-8?B?a0p5SFdwR0xFM1NtdEl3dEZuK244SndrNjZ6MEplOFlDUUVPcmJIUUtTY1JM?=
 =?utf-8?B?dXR3OXpwaG5xVnU1TU9pYnc3L2JsbFBXelhxejd0cFZ6bWgwTFFyWjNVRkEr?=
 =?utf-8?B?MVBmd1NjcG04dndtLy8yVDgxVkdaOEQ1WVczcGdFSWhFbHpuamZIRkFrMzgx?=
 =?utf-8?B?T2pJeW5xVGNpR3NZMkhOQWtLWlM5aHNMSklSWGdET0x2RmdhbTFlZ05jelhP?=
 =?utf-8?B?VzJBUWRWV3cxY01Ecmo5L1d5NnNGSlR0aEc1bkRsRWtCUmsyN3VFTEIvOU5w?=
 =?utf-8?B?cHRhU3dIYk9FclhtdjREZElrd0lVaXRTWjRxTkFIYis4ZXdCNlY4Z3U4Nmpt?=
 =?utf-8?B?VlFQWnp4bHlzQWJlRTAzOFgyWExlN2FRanMyY1cxT1B5UmJmaWIwVmVKV2pK?=
 =?utf-8?B?MnBWTldjbU4vd0dGcmVROVBrc3J2dExHTEJwVHk3WXBZSS80dzJnQ1o3MEMw?=
 =?utf-8?B?eHFuL0V3ejBOREljYzl4WWJnMGVoWUhaMCsrQ0Q3N0g2OGwxalA0U2xJbWMw?=
 =?utf-8?B?dzdVR0cybC9IMGZ6b3VHQXo4Y01qZjdIWDNVQUtieUhhSGw3b3JUYWZ2czRT?=
 =?utf-8?B?TUhGUGY0S1BVYU9CQ1lnVVdWSUc0d3RKZkladWV5YUlpbFZ6aDBZUDNxMzhO?=
 =?utf-8?Q?YnjxtVUnuZEvzKPE=3D?=
X-Exchange-RoutingPolicyChecked:
	KN66xMs1xK5yZf2Tp1G/G07cvyrBTSEsa5jc1/FBPO9XZj0DHU1663ONmWTuy0cqrcGdlX9SU4Xng95YZ3fT8Qz7lr57l7643uo5ikMQc313LJkj4YIqFLGCajVWjB0RiO1iJBBI3KhB4g5EeMBJ4GrVNRcvlNcCF5fdWODgBp93aY2WQcxD96bELdy+84+f6VbPWJ2XIGPuLXK0lripH4i/9o1jyhYVeiZ7LJmZKXWPv+5b+C1780uLgO6Y40wH+x5JDUWWVfm4dsrjIWKFkuFXJ3bEbij+e6Qj84DmZpvKmhWNGRKYgzbsEszhzNBOhVpylQR7jO1l/c1KefCjWg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Lo5aGP4IAnQis/zecG2i4VtgGDkhTHV8ngFx1zrDUb/dRWw9JhdjM20xHkVVIlgRMyzoIO+hePHyA5Hk4obAG8fIpFGfxXfLmwlzR/hf4XTjK568EScedgoD4il4JzDguS4tZ1zflWVbaIivzL3FcW/pZ7kiItKVUhaOayquuUKAnpWjJ7iRUr2cwkhFVGn67SSSIbTOhbqqXKOdYt9KauMDrxw9aCoP0jBHuBcOhPiCNyDIiQ0ysZYcic4SD7gYiFVCb+vM3GaI6ypwXARQbRiRbPltzPFdhn8YTqmeIEIMKx/T9KBWBI56YhUdeqUSQKDpW0sbg8Ev6OWlQM/YTs090ffLsGBrtXlKi47xC0FYmGtKg78qN0xh/J6HnyrKIl5fbJVetf5dqq/YBVk8K0iUkMd5QBkhOlBypp1ToPZDI8Hzx9D9H3OlMvmuN1zQqjJKipkJxdCL1DIrUQbRBIu4M7AS15EK3bZxFhVvIvOX8bixXppPWPkr4zXK/zUtejvXGOHqTb6InY2UPOw7LR/MXouBAhG6NjKYQUt7yURxJEXEqOSeGRwN1pDQmhqIfDI5pNlhK6W6BgTI/1+AhRSr0+IM1iw4RYLcpvR1YeA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64484334-b8ee-4676-95fe-08de7df21242
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 15:39:38.1252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMQ8j0/fnaLnKShCZWRJqoSTS0fCNNPspG0ko4dYJD76SpysteHIdnmbMkCshMkjpwWWHMRCyFs4u8DS5YzGlHNhu1am4FrZ81ggWK/Dl/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603090141
X-Proofpoint-GUID: D5-o7o5VlBScl3B3DpABD-0skJ9xEgwy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE0MSBTYWx0ZWRfXwY6YTNCRjz/S
 /+xoEolbJpywL+clO43i1pFdQ0gaiidd/GLTey5v58HeLdOJrjKnb1ulrybv8mhfhHS7fvVTr9X
 LHjD2cWExuyzn2Wm9rwNjA2WXLQ7GGCdlnvyBSjJSozZ5qq24eT+AJCZofBfa8/N+xE2dvQrwZn
 ltWllfAII2Zc654zHsMfspqiXEmZYvj42KRdfPwWdxNqy6rxXvJC2nVaM/3ob8sG9aLR6vdYp+S
 gHK+ln4Bzz3KL+gpUh1zyWmYd4XaedY6hybbFoXt+1uJHdbVIoaAp3/vQ+v5JRM+6SYKW/3R4v3
 u4wwszqZlynlC5DOaCn45mXORyGCo+3Y3leAE92jCkUh5G2A4kXrFWWRRwZTtGVDn/ihpz71lyD
 6TnXwDu2Vho5i1MKZSnKN+Bzg4VBGvFp91SAME0CBiczpluTQhuRujqXIaRt+rSHoYp6g0RMleG
 aPnpfeHyBbHDYkAdTEBlE2+Mc7LO2Q2P40X+lPMU=
X-Proofpoint-ORIG-GUID: D5-o7o5VlBScl3B3DpABD-0skJ9xEgwy
X-Authority-Analysis: v=2.4 cv=XP89iAhE c=1 sm=1 tr=0 ts=69aee9bf b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=94IvN3WNcuQ3VErRg3UA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12267
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E36940009
X-Stat-Signature: zai879fkj5x8m3ay8pa9abqmu454uq3r
X-Rspam-User: 
X-HE-Tag: 1773070790-52713
X-HE-Meta: U2FsdGVkX1/ECZOXVUxXDadoHiF84ZIlb3+F7Dcl6wuCmDkoMsqmDTPO4N4ump5ztOpDjYJxpA2DMnWrSV5HW10FWzUkcKByAYWMZ9yLrNUKdKqlvtE9Lwv3lxDrCSnlZMnYXi8nylPClaNcKmsDSRDOiJWT29oVhGbb0LrGMog5ygczye2M9geDnFsbwvlV7X5WnWU3TslwkSKG5gcEQg7B3b27kyWPt/eSBbQGluZBxVZRsR8EBZrGdIkf4gcyeOEEJEqAm8yUtnpLgoUtoMxzRRSNGha95bysSq8wXhdgNKPLncBou5WIrvsTgpJi4g5cBzXxwlncHGvKdtmnhD7xxpHvY0Fgop3qNjHfueHsRZeHnLf4Ryq3n+V4tcijp8yKT9gMGOrAUNRM+B3Jnu1JndI6qbkry6FJ9TEnj8yE3NXWpST5VplxzLUfSCt8opl1sK5E2rYJ8u1X2xUTJoXqM2Gd81O+TKKn8KD4end7238igJaEABwBUj0yGYznxmP2LFAaLpMINxXXXIPdPr+DqJWzyv1WtrbecDRZdORbcQnPXK1PAFmzuo4u2Kx5+sOAVueLI4WD9zE9S7qkvXG6dwmi8KteVq61qfNw71UxajvKBZfiWG3tFT9RCkK9sSqe3bE3eXbZPYEvuEg+7XVSzerzkqHJgyFJRi86hoCGnCdtuV2/ebLDM4TylvUBjJ6PmXZXF8aUMErD47JwxnLxrcn0LzK4FjFT2CO9EwQ68BE59Eatym1jv2vtpWLkRHJR7uCLQ3joTJLXUibOgW+53bATQqBEx8GJrpTv6kCe3KcPuOYLC5/wKL6Wvx4r8xPZZctYNc2ViPYrfjj7Uw0iD8KrVUud2EyreXJnBbwnryfe+3h6g+reZV0DkmyYK0qwgzPXkaY5BJpwIsjN4UxC4+Ppnr25eQ/fjBIy7JY1YEikelEGbBmWBr/T8E7hwUsVzTdKl46s8bmCqOb
 Bfp24SCv
 K3OVqboIkgb8jxoXiIAiQzgYR8CN2sHAsWE+/MuAkpGen7NO2cdw59iZ+KGesBEOFYjmKHPfAq416ZeCvGSQ2sNAGR28AE/4HoytWQuKnMwmkUzxc03Iv9Ll748vgjjH4bdX8tuAZsKKatO2ARlGH/sJwugTjvTk+bWY1P/rj8v+1l8Q5Mts5WyLvb0wWTEQRPN2RGH95qRqnIzct7o8iji22KWV33pZq6MUEv+njGCBRWARkd/1BeK7qVLHrMq3HqhOZwTkWkuOSyeirLEisG6hYiy1tl01O3C/nsTe14VcwrFiPQrq71eNh70qXiBD4YeEyvIi+FN+RzKA84BYqfRL9gBFDZ43gYUObJs0igL5hqoVULeMzlFTDVwtv+qHn6bRYxXAI8R0FWtaiGAIwRMnLVZe9TuKfegueIJLJD7Nr12K0Mq2sYLHjqoKACDpVHZZKHrGrquP2w7B+1rsjZuP0gxDktyagS/9Evx0EUIq2mw+lizoam0OD70a5Y3/vASMBkabZaCUjn94k+WL6WkgntheCqDX02iGEip42g99OenaD1DTymfQco2L/Fkt+lqgM235oAWcy4r+CwA6HEFXOxgHpmK69romPfEBlVeuDvaOLZ3AEhbuniPD7adNMmUrD6jbEbi/Wun5HjkYqCzQ8Gxt37XsZHeX2hVcrROOrp+02iadv4qSPNPlrsPFNhASCGwDTkiICvOcqOJdSKNIaaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/9/26 7:15 AM, David Hildenbrand (Arm) wrote:
> On 3/6/26 21:45, Anthony Yznaga wrote:
>> Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
>> to the check in mlock_fixup(). However, they will be locked indirectly
>> if they are created after mlockall(MCL_FUTURE).
>>
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>> ---
>>   include/linux/mm.h | 3 +++
>>   mm/mlock.c         | 4 ++--
>>   mm/vma.c           | 2 +-
>>   3 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 5be3d8a8f806..bb830574d112 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -574,6 +574,9 @@ enum {
>>   /* This mask represents all the VMA flag bits used by mlock */
>>   #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>>   
>> +/* This mask prevents VMAs from being mlock'd */
>> +#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
> Instead of adding that, could we cleanup further by doing something like the following?
>
> The usage of "vma->vm_mm" must be double checked, and we'll have to take care of making
> the tools/testing/vma test happy.
>
> Not even compile tested, so will require some more work.

Thanks, David. This is a better approach that I'll implement. One thing 
to note is that the check for secretmem has to stay in mlock_fixup() 
because it's preventing the always-locked memory from being unlocked. I 
can add an extra comment for that.

Anthony

>
>
> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
> index 593f5d4e108b..755281fab23d 100644
> --- a/include/linux/hugetlb_inline.h
> +++ b/include/linux/hugetlb_inline.h
> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>   
>   #endif
>   
> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>   {
>   	return is_vm_hugetlb_flags(vma->vm_flags);
>   }
> diff --git a/mm/internal.h b/mm/internal.h
> index 6e1162e13289..b70ebbdafe00 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1242,6 +1242,15 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>   	}
>   	return fpin;
>   }
> +
> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
> +{
> +	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
> +		return false;
> +	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
> +		return false;
> +	return vma != get_gate_vma(vma->vm_mm);
> +}
>   #else /* !CONFIG_MMU */
>   static inline void unmap_mapping_folio(struct folio *folio) { }
>   static inline void mlock_new_folio(struct folio *folio) { }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 1a92d16f3684..e16b2ea234f7 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -472,9 +472,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>   	int ret = 0;
>   	vm_flags_t oldflags = vma->vm_flags;
>   
> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
> -	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +	if (newflags == oldflags || !vma_supports_mlock(vma))
>   		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>   		goto out;
>   
> diff --git a/mm/vma.c b/mm/vma.c
> index e95fd5a5fe5c..b7055c264b5d 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>   
>   	vm_stat_account(mm, vma->vm_flags, map->pglen);
>   	if (vm_flags & VM_LOCKED) {
> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
> -					is_vm_hugetlb_page(vma) ||
> -					vma == get_gate_vma(mm))
> +		if (!vma_supports_mlock(vma))
>   			vm_flags_clear(vma, VM_LOCKED_MASK);
>   		else
>   			mm->locked_vm += map->pglen;

