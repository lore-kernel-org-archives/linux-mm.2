Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC35CD2F35E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240D76B0005; Tue, 13 Jan 2026 13:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4E66B0089; Tue, 13 Jan 2026 13:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044666B008A; Tue, 13 Jan 2026 13:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E12946B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:51:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 861718ABA8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:51:31 +0000 (UTC)
X-FDA: 84327833982.25.EC81948
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D47E40011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:51:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oyzVOQ4Q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BiDjuLWq;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768330288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdlup/f+YIR1dO09xvEGWxgBX0f0AjvEMdu4/Obai6A=;
	b=Kclk+z8HUZjZHbywbXCTSJ9YueDd7LPt+MvIWFfki32S9hUr8NJYUl4g5vCWEKQyuwXGT9
	nct0DKKpWOM6RXobToDnHbF0JLybdDUnd7zj0QaL7cPnjQRmsjKFvkbnafgK+gx4m+/xht
	0OHJnpTQXeXb0KJqL5yloqcZduB57i8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oyzVOQ4Q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BiDjuLWq;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768330288; a=rsa-sha256;
	cv=pass;
	b=G6MRNHGuiSd2VS7bQyHNZOc3WMbUsflgjTE7InSMzEmwMcDC3i4p6OMQtkSj/nOKEl76od
	GFcawXJF0qLJlOs+KqlY/HSrLPer8SF0meEaoqpxHA53dshSbZEck6lEBUFNDN2ltL+/X5
	As1/AUO48B2C+TIIDnoOUHnjBDpPkVU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DG68ge2811661;
	Tue, 13 Jan 2026 18:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mdlup/f+YIR1dO09xvEGWxgBX0f0AjvEMdu4/Obai6A=; b=
	oyzVOQ4Q2v7j5fPbbMsbdJWt5qSBg9eAbJrFUGCjPvcp4J133bu6MfYyMBXXVeyF
	DBVGU1Eu0lgzOBmwIfcAqLoT03ZFZmjIY2HnTuqZWvRvZBWmGGC/tjQLfEDGHvFi
	KSrDNu/QiOTpbc/8LKGDhJ+kD4lLGXnbXtEEip0POSEyRs/WL5LWSLJaDjP/mYPu
	Umhi4r+sQSk4J6aDz5FeVGF3+K4cCLhSJwnqHaiWhOkzq+K0ImlN0sOn0UfYsvVv
	svXGLPyyASSmgayo5CZFsm+1oUgmayEYnF8bUudqX+7Dui8EqO7taH2jN5PDIvo6
	TPtvaLC2RnUIQuq+SAZkoA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nm5ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 18:51:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DHUntR004570;
	Tue, 13 Jan 2026 18:51:03 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010015.outbound.protection.outlook.com [52.101.61.15])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd792wrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 18:51:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o3NZ67h5ZJQPI/3YYleVPUdm4nx03kYD+l/or2NzSP0AhSAV34WUe9zY8zjhzkn9TgFGYT0dwXpx9Fb2+hSu16JqvJ4VK5ZE1B5JokbXdlNzhtnwkzYzKBhnlUsUZcJeNZmA3nyVf7KhUuLYl7WDcjLNLbFNW98ukEMkobeDQjDjI2cft37RQMzAEbhp+g1Ij2DvKpx/d7QuxuuyfzTuftwXIbFvLafy6/HiHV67+WhdxgcVKRJsy4V5otRN2Yfha3d6EpRlLpwR/xXdpCj4enw9Wi/YHdwmnEiSe1I/fhBTkopYPtcEBi2d+GT9MapEi4LsZTvA/8BKHbtkbDAEJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdlup/f+YIR1dO09xvEGWxgBX0f0AjvEMdu4/Obai6A=;
 b=NMn5Siy2tivjt4z+wPYseoW+g3SlXGHOiRgwnL94GLLhEJ/2QmEtP6bitayoR6/hRla/bqxZbZe6l/cjjfa8lcfmjZLXH7VDcN34oh6hoxGafOt6tCMynd+gfpMW8qnI+nOr1XMcD3JtN8W6JKsL58N940/BKtgK56VS5mwJzYXQi3o1kD25tXct4hLkWfaPiYRVpQHjyOpts5NxeLiUyx7XftgGvYp2t3drcqAj8tmFxvr4YbFmIa9OLeDjt6ANy/Ifrw287UFjw4u+h7yXdyIGvi3ofzJregchN9cBMBSSlXE85hFc+qkx68nvABWpB7Dn6i4QobX4TZogzCw/jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdlup/f+YIR1dO09xvEGWxgBX0f0AjvEMdu4/Obai6A=;
 b=BiDjuLWq6Px3WsEaG+WfZDOJCpIZ6nY8Dea9ggHnEvqTAMc/fU0ULMOPoteJ5jfrJWxRvQ0C6aSwaQz0NMBO9EYrez8tCh+t5atQbHUBzASW6eiSEuqot8ecRl5brzBPJabFl8PfgEuyVlfFZMGnTh9MleHonrYyH4rwQOuqmY4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4810.namprd10.prod.outlook.com (2603:10b6:806:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 13 Jan
 2026 18:51:00 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 18:51:00 +0000
Date: Tue, 13 Jan 2026 13:50:46 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 2/9] mm/mmap: Abstract vma clean up from exit_mmap()
Message-ID: <7m5jsmwxr3cfjyivmq55uz22iqclugklsyokvipfwbcsl4eujn@xu55xp2cullj>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-3-Liam.Howlett@oracle.com>
 <CAJuCfpFOt3_W+YQNy+xPzY_R6JUM3EOsbaZh+uznSNpF1RKX0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpFOt3_W+YQNy+xPzY_R6JUM3EOsbaZh+uznSNpF1RKX0Q@mail.gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0007.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: dc2ae104-f6c3-4d7a-108b-08de52d4b1f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHpSY08vaFJNcGE3MTViVVorYWZ5NzFQRVpOMURYYTRIVWtVdWcrYktydWpm?=
 =?utf-8?B?RWpOaFB0Z0MvS1B3ckdyMTlZSUpsamJzTS8wMWN1YzU5aittS3VQRjkvOTBw?=
 =?utf-8?B?V1d3cEJhYW1tbUlDRWJDc3BIS09lQUVtczZvcStWU3NDYkNOK05lUFNwQW9H?=
 =?utf-8?B?R1RsWEx0c3dSdUI3MENWUC9RdU9sd3Zhc1BLdHY1dm9EcTdQcVR4WXhCczg5?=
 =?utf-8?B?WFJIS1VLYTkxSzNuL0lnczgxcm5RZGpIcm5mQU5ZY0txVWFJL2VrTzVzM2py?=
 =?utf-8?B?aDVSNytYK2E4dko1Sy9lQ1ozYVl5a0JCYlE3ajFvODc1UW1RVmViMkNmYVZP?=
 =?utf-8?B?cTFWdzdBQ0ZZc3FIdVM5NjNrZFEwQURJa1BTVmo1KzFFNjJjdnJsZkJUMStj?=
 =?utf-8?B?SXNFTmZaTDRucFhja0F2TmtCa0ZuM3NxSjRMYUtmSTZnSFV6QlpJUWJkUk1B?=
 =?utf-8?B?aXV3amJSRWtnc2lWLzdONENobnJqMUJTWjN3MmM4WkRRNnRDWllXMkMzbHNv?=
 =?utf-8?B?elBEKytpcHBqODJGVk85RHkrT0NmUC9NUUw2Y29PVjMyb0FTNzg4aVJnZXUw?=
 =?utf-8?B?Z01ZWFdlSVhoeWpyYzJscmZlZmpGTGhHZWRjMytkbk95OU5yaW9DUlFPR1Vl?=
 =?utf-8?B?ZlBYK3dvWFhrU1BOczJsejhXQ3FjMDBsaWNLM2x2aDlSZE1UdWIzbWJ3MVFw?=
 =?utf-8?B?bldkTDVBTFpnbVRzK3hnSGtUQWNnbjNnSjFTZHRldTlzMW1EU3VoODBhQzF0?=
 =?utf-8?B?OUx3SmsraUJWaGU4aDNlbGxqODNoMm9iYWJVRllLbjVWUzFoTXJ4eDc3Q1li?=
 =?utf-8?B?bm1QVmlsbmdHNzZiSEM5OEZpcXd2UENZa09YOUw1L05XRFFRT2MrRnZONmFC?=
 =?utf-8?B?UGs5TDE3aEhROE9NeUZ0WmIwNEtESGE1Z0lVYXM5eVZRdGQxOG5qMG1ZL1Vn?=
 =?utf-8?B?aEg4ZktMVDBtd2xERUdtblQ3NzZrVFhrV1lDQ1cwQWV4azNTSE1Ca2lBS0Fk?=
 =?utf-8?B?bEM0L1BFZXFwbWxBV3U2YmZUenNxdm9JenJRYjdQN0hJMzZoSGtyL1MrUHho?=
 =?utf-8?B?enZ3WjdaQ1I1bVpWMm5wQ0RNZjBsQzRZUS85TlRiK3VpeFpubVFKSVhEL3RZ?=
 =?utf-8?B?eUxJOWFGWXVBbHlWTFNleHl4SEFFbnFubElCWnFDeWVnb0NteG9FOVA0SElP?=
 =?utf-8?B?bVhDazd4Y2o2S2djalVXNE9GNHUya1JlZkN4bVN2N3ZxZHZPcjc3QWs0VHc1?=
 =?utf-8?B?T0FmV2tocloycGJUZW1TcFZMbEtDZXNFaVRlM0c4c0crZWNtYjZZazBBV0sx?=
 =?utf-8?B?NG5sTVVxODR1QlJMUWg0UExFNGdIYWQ3azRiZVh5bDdCWStscFB0ZlFWZFNE?=
 =?utf-8?B?WXQzSTdqbVNZR3JIaGNTOHF3QmxtcVczS3RYdnovOXNpNzdKQzU2d3ROVTVE?=
 =?utf-8?B?Vk8zb1RsY2tXK3R0NnZxZ3hoUDkyeWVRMHNSK1FENGtKZGE1cUxwWDlIbXBK?=
 =?utf-8?B?eGNSbm9BbzBxZllxMnBnKzBIa3IwcERhUzhDYUQ0WmFZeWtIT2FJTkpoa3FI?=
 =?utf-8?B?YU8vYUxOK2dHNDdvSDQzV2wvQ0dZdnB1eXlRYWpKdHVYSCs2VmRrTG5ZRmhH?=
 =?utf-8?B?N1RKTnhnNnFHMkIxdWoyZGZvaHlpUjJaVFQ2dmNiWDRacTNNUGptUlEzVzBl?=
 =?utf-8?B?MFVxSmQ4UVZhRlIwU3h5bEpERnFUZWVUZjQrSkhzTUw4NlhHK2V0MVNYT0ZQ?=
 =?utf-8?B?OEQ2bk1GMVRNM1pjbnFLMGpkREhBaXF4dE9oSVJobE9mbjg5WG54RlEreW5Y?=
 =?utf-8?B?eFhSZ1JuUXcwUHRCbXc1SElxcjVha2RzTlNhbXg2ck1DMzliT3hGTWNuMjcz?=
 =?utf-8?B?YUd6N29kdUdyaHBYeEZZNDFVNU5aMTVLSlVwM05iSUlVZC9jZ3NpdHkwWVJh?=
 =?utf-8?Q?7R2ZMxATDybst2ndlAJmdMq81blET/gI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFZjd2ZKeW0vTGVqdzJZNzM5YzBYTis3Z2NWR0Jxa1hhMVFEc21GNFgvWkJq?=
 =?utf-8?B?UVVRT3ZiS2p2ZXFuazB5N0YzNUNNNHk4byt5MWN0WkxkZ2gwbTJyZ1RtN3pV?=
 =?utf-8?B?clRvSGdZeWFJaWoxSEpaeWpWQ3N6bjVTUmJEam5DRG1rTXI1MVJMQlBWVFpH?=
 =?utf-8?B?NDFLNWdHcEFzYlVkNkFzZ0t2azhvNWUyV3lVZU9ZZzVlOGJ0c0xHTGpXbi9p?=
 =?utf-8?B?ZjJGUit6UVU0VnF4eG1adFFjdXpTTmpDY2s3RGJ6OTcrUlE5YU1yWVdYSDhx?=
 =?utf-8?B?UHZ3cTNjNEN5Ym8xOThoTVBGQjcycjI0M21DWko5VVhSbFlvUTJOUGRDeHY0?=
 =?utf-8?B?WVkyYmd5Wm5wZW00dEFyaGUxUjVEc3UvN0ZLNXZvN3Jta1VGekRHSTZlU1h0?=
 =?utf-8?B?cUl3NjJ6eEg5Q0M5RGxiSlVBZ1V4USt4UXNhQ3lXQVVXM1RlalFQSFNsVFNI?=
 =?utf-8?B?VnVpUHJ4QjIrbnVibmVEZkJWYS9wUVk5VkdOdVEvbWJ4VEZxOFd5TmlNNjhI?=
 =?utf-8?B?ZWdKNGY0bjA5THo1WkQ5QUxLbzdaekl3UXB5UzVXQ3FXK0xuRVlGTFVuVzFm?=
 =?utf-8?B?ZnZBa2JhU3kyUW5IRHZqUWowcm4zTEpGU0s4b2tuNldsOTBSeTZsY1VIMzNB?=
 =?utf-8?B?dDlJK04vRnhJeVdqc0djVVkwbyszVmJrbFBNNjdJYjBaTk56c0w1UmJoa2NE?=
 =?utf-8?B?UnNTenhONG9NaDJUZGlTQitIY3l6YnVkaU1MYWgxRkpxRFA2a0dkZndjK3hk?=
 =?utf-8?B?VThmWkt2cUxEaTlyRnEvTUdsdnZJRUV5ckw4a0p1NndHVXN3UGduby9pZ2lM?=
 =?utf-8?B?dHVSWlhZV0FwNGV6b0daRTlYVDZ2Qk93SC9kMnpHWEM5VWtGTm5pMnRjNkFn?=
 =?utf-8?B?bHVDVmNrTk1RT09XQWFHdThWaVlMU3JSczVWQnBkbWoxYnpwSElESkxnWUk3?=
 =?utf-8?B?THdjaTZIaGI5ZzE1bEw3MkNjWFdKK1lucXlmVk9WWVUrYzVnR2Rza1I5SDBZ?=
 =?utf-8?B?ekkxR050U0tSM1pSbEdxWFZkWndVQ2FhbGo3ZjNmWncwTjdPR0R3NVZUU1hq?=
 =?utf-8?B?TU5vbE5hMVR6N0tDZFFQVk4xOER6NWtiUjdDeGVmWDRKQUEzWElhM0hUTmRD?=
 =?utf-8?B?U3gzTUsxM2creVYxNzJuQWUvYUdlMDlnY212SWMyVVVhR2tWZGsxNTdJakJ5?=
 =?utf-8?B?S0RLTzZWOTYvcGFQNDVmUERpNG1mc0Vic2lNVmNMMTZnK2toVUN3eHpOVkQr?=
 =?utf-8?B?TWVHYmd0QkJ3Qm1XRnVzUnloWUNheHhLdFRPYVd1Y1dCQmhsR2VjVGQzQnV6?=
 =?utf-8?B?VDlxT3JsS2FLZUVBY0tHbmJRMFg2ZURuZDg4NTRmVU9vSmdIREVaTlpmdFRM?=
 =?utf-8?B?aWFkRGgzVnFjdWFHbzRxbTQvMDRwNUl5emJIVXQzVTFhUHpiTDZJSENwYzN5?=
 =?utf-8?B?eEFCd3lUQ2ZWUkRDa0FsOURPZWIrdVNZNjZQWnV3QmZBSGw1UWFRWDVUWGtl?=
 =?utf-8?B?L3A4d01Nc0ticDZzbzR2R3BKaFIxR2dqTVFqbTEwK290WU5KUnRuM0FjVWo3?=
 =?utf-8?B?ckJocVEybWMyd25MRWdCemY3b29NOUdFdVMybm5weGs5L2YrK01XRnZCUy9v?=
 =?utf-8?B?Q0hlY1RaVDBaL3RzODFYbGNWZXh5d3o2OVdkZ29raDhpUmFLb1JvRDVMMEhq?=
 =?utf-8?B?SFBncmt4bmYwOXg1UGtoWTRrS0ZsS3owWlNBT04xOW9hbkdOYW15U29tcHJI?=
 =?utf-8?B?WnhLTm9CcTVzVzB5ZmROUUIxME9iNHpwZzI4NzVJNi9QUGRTb1liZjB1anhJ?=
 =?utf-8?B?cWdtbC9wMmZiYUJXOCtCTlhCc0pTOC9Tb0JFRlJaOWtqL0V0TlFPTHVob3Rk?=
 =?utf-8?B?dXlKd2Z5eTJzV2JnNmlaekMxb2UvRjZFeTdRU2dJc0djd0JxaFFlNG5wM1Jr?=
 =?utf-8?B?cHVmSXhiSlhVVFZzNGdLVVN1ZXdpMDFzK3V1SkxUc1R1YWdoYkpqZkJETm56?=
 =?utf-8?B?bW1TSzJSUFgxak95NlBsTlVrUTB2WnVucllaWURsbmhNM0ROZ1grT3piUEF4?=
 =?utf-8?B?emdlSDlCTHI1S0tOczFkRThhcERyOXZtNGRVeVdYNlluZVRSNnhNc3NwNFBp?=
 =?utf-8?B?WkZlOXFzdk9ZVk84M0tOSlBkdDdNdTQzUHZoWm1BWXZqTnNuSW5iWElOTWls?=
 =?utf-8?B?WU45cWxPcEZZK0F6dEZrWkx4YmdIeFcxWGpWbUFpOFpFNWk5V2FMM2tWbC8z?=
 =?utf-8?B?clVVN0dsTDlFTTlFK2xIZ3o0ZWtEUVVSVnY1YmVvenNvWWtFMHYycFNsT3JH?=
 =?utf-8?B?eS9mU24vdnVVdzBSYTVCY1BZNytRbWE2TUpmdVh2VXFVaTRxMGRYdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qPDQIk6lrlSHJHOgShvGZ7H35Un97miuhyg5cVhMlfJNvrjklvftakDLEsVzOPSNsOO7XEiHbr8v1ea44Aub2WY+23XQFOgZxkNGtyyrJJDEMfGip17rsnuPQlo5+78wqOfkDNAhF1JoAMm5Y+TAqWGf3he8nNxbznKymrvpVkgMY/e1gy4rJ+l+u5w4KDj4HZ1Vks45SUu1m89s5LG4tIbZd0IwZ3WHKw+4PwGpjz9SDpN2p9jWUOaTcIo7p7+8DVik5XL29Pf9YeZuA0Tl72ndARS78CwHgf8WF9XWLrxLMqlPXylCtdHQ8q6yBYfF0ojVAL+bWIGsDbNfgRp1Tbmk64ci7Am+NcPZ2VChIgFMPGeDOhQS5v9SCyHkaWGztjKi7TOlusREVwrhR4cjKVQjijPY7vN6Kwpt0NCZFxkicHSbNgFpt1lekP0m+zJ8jAWNTd5RjgtY0+EYoj4EluhKObQVdaVTHU46cubWOruKIehOh/4O9i1QVV/OYJyc+9FXbxN2O6r05ZX3+Go0LcEreWPdVNUSgnwbfmU3QVyXygLH0J0nGlFaPckJ91JLVjCMQyGO4v9quAUVK6HevC2zLJKTEviW7EpF5L+aUrE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2ae104-f6c3-4d7a-108b-08de52d4b1f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 18:51:00.7581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QFhR49DX3dDXBOT2jrXPCE9OE1r8WucAEcrcFSuhjHYDDUDVkF90P4//ZKoUlrPfc20VbCkPJ9A6imq4kxt1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130157
X-Proofpoint-GUID: u1p0DCMP4DWaZ7N8_Ya3cQpiIj9xdCB5
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=69669418 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=GfI7W31lyZoJVn3rpl4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE1NyBTYWx0ZWRfX2nd6OS+9TK40
 /brGsbrkL0RPLv5bBP61IJMyog26fbXp2u9lbPT1UrsoFTf0IBeGTaFcIpqA1u3rLC0mm++QV5u
 wjgks1loC0107QLqCkm0MDcOfXIykfNZ07J0Nen+wT2Eh3XxLBZwl75g9N2ZPJNNl8rQpffnLFb
 LiVmTtMuWZvzadfKtfgK6A8qULP7K9I0oqCin/ST55iPwppzI+MAdAtPhITiMP3XnBk//lWBG3J
 O7+qm1tk82l1+kI7dAgYomtjCvzFvzzSfSHyaMaBj8rrx+cjy+SSOAg/1wv644euXe5Vb372ggz
 NAwFaHBsxy1kEO1Nkun7EpbRIhRefJ5gAxCeI+V+8bMXP1+2kVHLvkNhZIWvi91FOHXxFru+2gc
 lm1DFaL17BWqjRAUCQE5yZeCfBKjsyR88nonB3z65VdNrHYCg+/C4x4/G9wfYMVNq/GQpKLqpSd
 Ufv22cZT1pT0ojoXj+A==
X-Proofpoint-ORIG-GUID: u1p0DCMP4DWaZ7N8_Ya3cQpiIj9xdCB5
X-Stat-Signature: bkc3ew8gosh5rybjs8bap45754rfh3eq
X-Rspamd-Queue-Id: 0D47E40011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768330287-44993
X-HE-Meta: U2FsdGVkX18xN3rG1iCFlEVBjQcCQfEDqGYn4LwtuVxyPa09O8UjhALeLNONsqdqGPUDRFwqtBwEvIwTruh5Fjy/VH5NONkX43jWUOWqh810x9R7sPFUNhmykKRXJMRGxbGpdgmn8ZmIyCDWZ5tjTgBf4SMzGw46KcSXrsSozmqKfS6fCAyW1EaDSDRpxErWQJuSC10wkLrj8OKzzVh/rThbpDjDrQ1VOwHZXaSlPAafwnTPgKsWw7ZZd7B3uKfXJrFAFgxFmQwA0N7NNUOO5DzgHvA27bJIyTobGKLxJhWyUqymJ6+WxKRI9wqZldOvIACRRRcPu0Fe6R8fIPZOEWxqd+qcloUJ8hEXk91saBqFhoHl/lT5n/zAl1CgNBM1nX2DNKH9qm1HYLHEba/VuRzb2k0qxGPiO6hDOz/nvFX5HB1hQYoAyiK5D7e6Qc/oUT/a8jnmf8yPIvPnpz9NM47voURqB6wWJpDhWyXEP5aSFsSr2BzkhaLW1G/ZD8aEbQYcwfogm4Bu/gcm0D31GnYHoV1w+rs6HcUBovewgBe9JPrKjTQAvlOjYYl8IR/tJBjNfq4zgk34JdSbGeHsIGhZY0zsaT82T5/09DOSKw2AJA/u50NJFRJ+nrByXdzVngdx2GWB2UDxKooXVIj3AERVlDan0Qp6FxSslXkStFq6oRYNMrTn8GIBxZf/sX/iJ5StKuQGvQNuRfQ7wEvgtqHBX0wzgGhvx2NGiSutSAKtqqjLVhS/p+geu+2nke5j+Stq8ft7MjyXjyEqUIjpp7XFXrmB1s5omjQVrzo/FKOMFxcWOJA4GXInSjujAzlipTUnPlXsBltwI4HxHdEHTWT4klyh4rH6qgd8k1sx5BZ5mGoH9rbwMAXvNZaDIwencfv2xM4UmuekNe1q1vKJ+Y/3wAaoY28ZRJ1dgWicLcwMcy50UuRL+bIjTn5Hy7w+i6aOLmkvTckplwJDvF4
 wIdGGyrp
 QP/jRZIz4QggbHh02keywD5y0/O3GrvBpz27RG4gMvxAR3CI1ZQ1lh/mzD+nHA4PHvzcNSy8t28iQKveEGVGaYNW5y/r8XTGkHDze0p9omu2Eq+R47IzgHKHbvHaJHZeGjgn0lI/SJW4hGqqeP/5or6uFotMz8dPuWH6dV2Q1Ziq7h5oNfst/GJOKtMGVAjhDdk/QSZFrxawQwCqVVkoN4OvBX/tBvxqvmbaqejlmXRuuT7hvv3JcadPaHBIlWSrvsTb1deTxf3+cnYMhgUZQ50Y2CbA06d51aX9dEe3irmpZrGO4kF/nJLhcGg6eOilmfd6ZyACgd48WOSEznvGw8Ok/sUYD9OQeBqu0hmeuYqqt9puRFsl2kepDstvz8cHdkD4/fxCV1sALnfG9HMDNxK4M8Adz2b/Z2R4bH6gX2pLspcbDkubU9cExzM1//yQFPZw2J9NYzhz5AXH5QqQYGxPyJFR58NbBpxLvt/0+hJBLy3mg0sv5JO8OQ4T+a3wtw7wFrH6CY1ha7mhgfeLsprLPYcoMsk4C+OGnDT64ChaMCp/Zi4j63eTycIb0u6ASThxq6UyDFMeiy8d/qIvRovgU0d/O9oJKkcwwwgEhitwx0nvAH9bEbu6zW87JIbE6ANQHecvLrChANrZZelaFYzbr317UFRYKHPwg6yJwIgvkLsErudg4xXpnkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250909 16:09]:
> On Tue, Sep 9, 2025 at 12:09=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > Create the new function tear_down_vmas() to remove a range of vmas.
> > exit_mmap() will be removing all the vmas.
> >
> > This is necessary for future patches.
> >
> > No functional changes intended.
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>=20
> > ---
> >  mm/mmap.c | 37 ++++++++++++++++++++++++-------------
> >  1 file changed, 24 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index b07b3ec5e28f5..a290448a53bb2 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1250,6 +1250,29 @@ int vm_brk_flags(unsigned long addr, unsigned lo=
ng request, vm_flags_t vm_flags)
> >  }
> >  EXPORT_SYMBOL(vm_brk_flags);
> >
> > +static inline
>=20
> nit: Maybe let the compiler decide whether to inline this one?

Sure, I'll remove the inline here.

>=20
> > +unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator=
 *vmi,
> > +               struct vm_area_struct *vma, unsigned long max)
...

Thanks,
Liam

