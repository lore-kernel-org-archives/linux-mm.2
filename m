Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99A0D30CC1
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 20:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0556B008A; Tue, 13 Jan 2026 15:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A6D6B0093; Tue, 13 Jan 2026 15:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0039C6B0095; Tue, 13 Jan 2026 15:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC7D06B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:09:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75CE557981
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:09:40 +0000 (UTC)
X-FDA: 84328030920.16.C048512
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0139220007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:09:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PsBwbhvv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hg/99qRR";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768334977; a=rsa-sha256;
	cv=pass;
	b=VVVIbBRdEAxRQv5oYe4MVe4/pR7ZgbMVvOram1AxS4EwPaHNHr7RvwnLrb3Z0Bv+WnwJlY
	n6Dy0d4uxYg5/OKOea7tVda6Q2Qe1b6GVRa3m0uG/CLHE4a+XyMFdBRkRq/Ydn5MBhQDxT
	Q99eO8iOCX1YZvTBQQKC0LxdJsGHAYY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PsBwbhvv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hg/99qRR";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768334977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTgYFbIzmaMOTfwcYAfrMQtFQ8N0DcIE5y9SghK40hw=;
	b=dMbUgDuOmDbJ/6Tln2M4WLQawj7tBYzqmM1Y1RDvGGZbLm/DhNMpurBk+S5eAP7JWO8O2y
	ZFFVNitiTK0QQFLo0ibYD9bnRT+Vy3DtIwGDbeAHzu0C/UnlkVoGv37JqJTdGiMT9p9zS2
	BxyeKBB0A5xwcinwoxNdJKK3J9YDOpU=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DGGJEu2682337;
	Tue, 13 Jan 2026 20:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lTgYFbIzmaMOTfwcYAfrMQtFQ8N0DcIE5y9SghK40hw=; b=
	PsBwbhvv5nNgVbw8znj9ZauOIsaBSA3ovBXlt5isqwUcSG1QVIzebb37g7PzJwsW
	w8ZPhpHRA3UTTGKwCkI0kBteyjNAVF6Q9yfqpnjV8d2F5sbx7Ya+e97ti1A8zL42
	2ETcTxkbSuCOksE2Z84Vn8IyvrX4WexsT9EkQ7WpuEXemR29MacGv1w5TuyZSEdQ
	/x5XjuQyrnB5XyPdR041bQet3WHGhdVc6QJaWmG+mdFLg/rr731RTUznZgGAJrd2
	DPVRwNKbtWt0BOFTtQlj3yAOUplw0pp1o2v7FAC4dPy5wE9lm1eU00AThAVoBuPx
	2kspASsO5YhlYPLEmzOFIQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb45dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 20:09:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DK98hC001930;
	Tue, 13 Jan 2026 20:09:21 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd795n6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 20:09:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PPkku6KLs2I7nSZWNYgBpqijubDDHfZdCEVbHFoVur5htZvtiruNPYcbMO0/IUvzfmDrCfpe6IeNQe6T0KG7jtZfZr4DuKY2kqykkrem0ZEpjc17pIbcAN+jvYV2vr9wC5ptqwo6WAJl+9IGy383253Ey7jWRGEQOj2/IVJWuyl6PsGf23TjhASZdPZBzAqBoCf6wWWZKFgbmSxB3z9u4GN8EKi6zn4OdFpc15y17/XpQMcV24+QSIAQ0kumpCOQMhVpR6v8yvwyX5gjL+3bnE2UUZPopNDxfA5XOlg7aNNBBVBwtjSWA8+n85rhnh41Qmslu7JPTbPThaH9LSaGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTgYFbIzmaMOTfwcYAfrMQtFQ8N0DcIE5y9SghK40hw=;
 b=hanvfnIJYX8I4xClYkUw/NxF+tRDZ51uT4m2fYOxG5HDMuZdMS7oyEB0k063jvNUffMFDlmT4v41W1ML7cOLkMWgPxrCXLBPUFokAUco8WWuIB4CNUmpYy9VHmhSyfbXhnk2pg0md/wklhXjBNPm1j0oSbDYkMrYmBOq627/u7RPG4/+Mdh/FOuXMHWIeQGEiG6q+QiobVK3CsRsWtp51gRhZYiLeUjTmErn2IXKUL2XljfnOzTFoxYbsK52auBeH1T3LuKpsmCwaXWQkaB0ptclHQcXnh1qP5lJhKGUBFxvnDENVYimJeSE6RPAGJ6NGjQjV68Rl8wh29/TJgKBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTgYFbIzmaMOTfwcYAfrMQtFQ8N0DcIE5y9SghK40hw=;
 b=Hg/99qRRS9VGxhf2PH7nZGrMKGbhaDtzEg7YTvhFVVBJNzBuqtkMBGZOC8IGk1e5FnbWZDCIZ6aoY8QMfv5KYIkQFvdoiaHyAlbfl9Hc/HKPaLTAtMNaa+v/E7es0KKoJzY/DrUCPaLSMH/t7KD2ub01yQoFWmQZH7rl+yD6iTQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6605.namprd10.prod.outlook.com (2603:10b6:303:229::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 20:09:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 20:09:14 +0000
Date: Tue, 13 Jan 2026 15:09:11 -0500
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
Subject: Re: [PATCH v1 5/9] mm/vma: Add page table limit to unmap_region()
Message-ID: <qoa4jbke3gd3q6u2dyt2cgvkoxfibxlo4t5vvck4j2efddbdh4@agowka7u6qqa>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-6-Liam.Howlett@oracle.com>
 <CAJuCfpG6US+wPA7V5-0Dkho+BRs6uNUCYCV1GyRrbvpzC1N=sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpG6US+wPA7V5-0Dkho+BRs6uNUCYCV1GyRrbvpzC1N=sg@mail.gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0071.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::23) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 796cef8b-fcf9-4108-1fa3-08de52df9fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R21rRGZJRkc1NzBpZS8xcHBzQjBBZkMwWHNIY2dVdGNUZ3ZUTXRLMHFHdlZY?=
 =?utf-8?B?OHVCU012TE85N2NlZ2JvY0VEU2NMNjdtanJ4cEtkRW03aGlqTzdtdU0yOGYw?=
 =?utf-8?B?ZmdiTzF4dDUyekxhTkVvTGw2VU55RklPdCtadWhGdWFKZEh4UUhHenZudWtj?=
 =?utf-8?B?YkNmSWZSTmdPL0pGS0NlUVJ1SC9jMUdlRU02eDBnanRVa1NGbFNodXlMeWoz?=
 =?utf-8?B?N3JjUmRUNUM2Yk5OVmh1R2xNRnduYWljRWhGMk9Bb3phUC9WaEduNzQ5WnJ3?=
 =?utf-8?B?QXFzUVk2K2Vkc1gyR0E4SzBxakxUNFQrckJqbGJaY3ZKQmh6dGQwWlVBbXYz?=
 =?utf-8?B?akl5aUMzcDUrczZQL0Fad1BvOE1FYUJZcFJDMm1ZSDNsNDNMdlNqZzhtSDE4?=
 =?utf-8?B?R056empGOFdhMnJPeXZVaGVHSHhJb0s2dUpFZWI1REMrc1pBZUp0VW95SmR4?=
 =?utf-8?B?Vm9ZMVlnNUhUL1djYzJSZ0E3WDBQNFhnbUtxNXoxbk90Vk5QamZucjVoQ2h5?=
 =?utf-8?B?QldvYlpHNkpJeVZJa1FYVUZCRjhwRTE2YytoYnQ0NXV2UTY0QUQwZGlWdlhU?=
 =?utf-8?B?WkxBYVozL1ZqU1I5OVFnTitxejU4ZjA3S3ZiT0t4VkQ2OE42bW1jcncxOTRO?=
 =?utf-8?B?SjhTU2N1MXgvNENIbVZKd2pDSjg0U3granhrc3dES3dibVVYdHRlVGJ4Umti?=
 =?utf-8?B?Q3pjeURzVHNPb2p2ME9jVWhES1FYTi9NQU5GREQ1UTB4blNxMmZRVzhuN0hU?=
 =?utf-8?B?cktQU2xsUXBLNEhzeS9yVFNFZEZoclJDczVXdUsvMUpuNUY0Z1J3U1RYL3Zq?=
 =?utf-8?B?NFFIWVRxdW16U2Z2L0dTZTRIclJyNXFTdHhjU3lPVXZvb2xkQkFsSG01Wjdx?=
 =?utf-8?B?R0QrTENxdEJiell3OE1DK0FWeFlzdHFXSm44c0d3Zjh2bDFQdlRZNmRPUFFO?=
 =?utf-8?B?L3hDekJGNlY1bG5LNk1qVTBKeGtuNU92MlRlOFdSSElkQWtWWnd3SkJESDh4?=
 =?utf-8?B?cWtmRjN3ZWwzMDl3dVdjK1RoWVFaU1BpSkNQRHJHZk9ZZ29Uc0FGRHdSSlZP?=
 =?utf-8?B?SXNWaDNpRVgzS2RseDRQeDRseGovUEI0MzJPNlVWbFV1bWdpVGdJV2tmTVlC?=
 =?utf-8?B?dThKYW5DMnZWcUlvOVIrdXArczQ5SjNLTndhb3ROVDE3MGUxbzdhV2JvcmxW?=
 =?utf-8?B?MzZyM29UN1o3T2tvNlVnMWg5ZUJtNENNbjZZckRrZmtNdzhxaVVEOGRUd1Nl?=
 =?utf-8?B?T28ydVVQN2pBbm55SWhFN1ZGdS9yOTlwY1NWY1hMbU8wU2EwYzhLMExobWo2?=
 =?utf-8?B?eFNCZjYrd0xSMWFyUzEwTnNzSWIrRnJIOEEwRVRlTCtNYUlKcGdWUXVQSFFM?=
 =?utf-8?B?WHJSUjVsaGpLSkhrUnhybnhsQUhYZ1hNeDg3S1Z4aWI2YmhxdXdqSEtobzFL?=
 =?utf-8?B?a25DT3FreW5wRzJhaXFLNm5oZnVPM29KVVZDamY2eUg1YVlmOUoyM1RXek00?=
 =?utf-8?B?LzFMTVNKVU9FekRGUE13d1ZGb3F4MlNsUFZNTDNDZnJibXNGY28zazNQcmhZ?=
 =?utf-8?B?RUt3WUhBOG5ibGI4NVFOeWNWWkFTNVA4Z2EyZE1Ld3FwQkc4SHF3R1pBMjZ5?=
 =?utf-8?B?NUtMNEJVMkR6VHNleEJGTXNIa2pRN2dPMnUvbXo5MUFCK0dyM0ZHeTdKWmRE?=
 =?utf-8?B?Z0o3WXMybUdSeityaUtUKzB0YllIM3dhdGlsN2hmTkJ2RFZUbmIzbCtSTUsw?=
 =?utf-8?B?Q0tjdFFESnYzdnhBK0tFUVhRNHl1MTlhN21Ndjk5OUZuYU4weEtkaTJBQUxZ?=
 =?utf-8?B?bXNqaW9SVWVVUlhITDNtS0ZEMGIwcmhIZ3E4M2NQSmkvNTV6Rjc2UTBSLzBz?=
 =?utf-8?B?OUx4eSt2VjVoNXluVUMxVzZMRHYxaWs2NUpTWnJ1Q0c1Ty94S2dmQjRybGtR?=
 =?utf-8?Q?LlseosAuFvy7u4XSfPqBnvLIIIDB1HFA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3U3dzY4aGhNYjJ6MTAyaFErVkc1U1BJdWcwSTJaUGZJcEU3TjlLUllOUmdH?=
 =?utf-8?B?Q2VyRnRzRWwvb3lYOGV0VDBUZ1A4Rnh3b2oxKy9MYzhPNjJMNkJxTlVudm1m?=
 =?utf-8?B?MHN0RVkrbFJPcGVTQ2dONTY4M0pTVGxoTXV5eU13SzZLQXJCM2gvKzYvL0tj?=
 =?utf-8?B?eUR0UDNPZXVjZ1Zna1JTWHdpNDY0ZG9CeGdDejZEMTVYRmUrZjJDVGlzZEkz?=
 =?utf-8?B?MTZ1SXpRbkNldXVQUGRJdzdsbzNKdVRub0NXN0UwaHlJVUJHVmVFaTJSR0NR?=
 =?utf-8?B?bzBUc0E5bjJxRjI2ck44TEhXZHdNNWd5Nnc3U09NMC9aNVVpT1V2Q0RIRHB4?=
 =?utf-8?B?T0NEaGtidmZOOFdrVEF6R3FpOWtidjFONXdXbGMwcEVqOStieENuNEVqU1h4?=
 =?utf-8?B?U0pObC9nMkx6K2lJU1lXQ0NQR2hwOTFrUzJVbXc0L25zcmkzNVF2ZnFTelNR?=
 =?utf-8?B?SFpOQlJqVS9TWjNOM2pEMmxyNTMrMG1vOVBYTW9XbzlxdlFwYkhxUGE2WGI2?=
 =?utf-8?B?UnV1ZXZieEJkeFhZUTNXZVNlV3ZNZGVPcEErTVZMMkpTaHF3MVVjQzN6SVFL?=
 =?utf-8?B?bHR3dmVpWHQ2KzY2MWFlWE40VER0dVpZdmI5ZCs4RWZMZ2RNOS8yU0ZuYkt0?=
 =?utf-8?B?YUpoRmd3VUpUZ3VaTkxQZ2Rxb2hwUGRKMWhnNklZQnNEVW5jL2hiK2hJTGRl?=
 =?utf-8?B?cmFLMWtYT0lVSmVBc0JLOENlcDFOdzRuTWdsN2NmU0o0MlNxMWRGcUxxVEdV?=
 =?utf-8?B?b3FUbkxsN1VLdlhpZW1pTFIvSUtCbzJuWVVtSG9MZWxIcWxjU2hCa2JIMmpG?=
 =?utf-8?B?dVlXSkVUWDhNT3BicHBDeE5UMXdybVk0eG1vcnNqTnZYU2ZrTVBlZW9OYk12?=
 =?utf-8?B?dFljVHdNNkRVYU9BRU51bTRnVVNmRkdlS3dPK1FVMmltRkhObnprb1BIYUg0?=
 =?utf-8?B?dnF4S0RVUTljUzJBWm93UVR4WEJEZTd6WUFSaUdZWTd0LzNERjlNUHJMVUFx?=
 =?utf-8?B?eXRiMXF2R09YbERWZWJwbFlubURNTnl1SmJla09Xa0JMTWk2aVhZbjNFeWVN?=
 =?utf-8?B?OTZqQmxKdzltYUF1SDVRRXBvUTNMU2psOWRTT2NJbkl0a2hESlJUUEVkQXN3?=
 =?utf-8?B?akxhRTVXVW9qaDJrcy9uQiticGhjeXo0eDdFb2k4YXhyYzFBWDI0Uzl0b2Fq?=
 =?utf-8?B?ekh0T2hWcUNpYlZFTGJRVmJEaDlEK0RQWmg1MGVoaFBHT0w0M1ZTY2taNFdm?=
 =?utf-8?B?d0dvOUM0S0lWRjExSEZ0NFZ0NUh5ZFJnYW8wN3hkUldZZkFMa3NSY2lwSVVo?=
 =?utf-8?B?VGt0a3dPQkcxcSs0TFFzOUZIelBSZWNha0UyVVNiR2xuSWUxNXdyWjYwbjJW?=
 =?utf-8?B?dHRkNTdPdStwYkc2ZFo0eGppdlpLeTU2emFWTitDN3R4ak0ya2pmTndjeVZ4?=
 =?utf-8?B?VkZvNTNvT1pVSUNDTnBCMTBwZVYyanVOK2JYSnorZkRWV21ERXljbVhXRWRE?=
 =?utf-8?B?aWJ4ZEpmNXFyNFBXUVptRVlTUzFkd1QyMDRYQWFpVEFIajEybm1zOS9pZk5h?=
 =?utf-8?B?OGMrb094cjluL0NubWdhd3JRYmJQME8xbWxSQjFBZ2hPbFB5ZmZHdkJiUHhC?=
 =?utf-8?B?SzNDT3grTWNZTkQwdmVGeHc5NDRUbEtVOU9URjdTWUZtVXYvUUVEMVU2L1do?=
 =?utf-8?B?eEp6WHdqWk5LZVJXeHd3RWZYS2VrSFpLYll0Mm9MMGVZOHJXTEtMNzNheDNr?=
 =?utf-8?B?TkQrRmRINWo2Ny85SzdOTmhIOFI4TElla0lzdHljdk9FRWZVOWlLM3d2TWFp?=
 =?utf-8?B?RnltenhQK3FRZmVGMTJrOUJYMmI3QjRaV3ZDK0MrR3RiVDdWL1M0c0E0VEMr?=
 =?utf-8?B?WmlsZlFzRU5Dd1ZlcDdic0lqbWl1cmQvUExZdXZsMGFxa05QSmhicW9IQ05Q?=
 =?utf-8?B?S0pUQkRLNXFFRDRaSjdPcmMvZlpWQ0MyelhvNmhRcytCQy95MlVjdkJ4ZUVC?=
 =?utf-8?B?dll1akF4Um9MTE9IM2Z3d3E4Sk4wOGFsZk5IZnBGLzJFakNQWE4yazAzU2tz?=
 =?utf-8?B?NnhIcUpwWDY2Qlp2cnk2eThaZXFlSW9JQzJxRjA4RG4vYzVnNHJQTDR3dVlD?=
 =?utf-8?B?QjN6MkdhbitaR0pSVFIzRHlZUmVnczNoSTVQdTVMMTgwMk5GdTgwREFOZDJU?=
 =?utf-8?B?TXRTNUw5S3V0S2MxeEMwT2lxQnlXbG9HckhjRnZHdDBvemprYnRFMUxNeWVQ?=
 =?utf-8?B?dXFFVzB5cW8rZGtsSjYyK0FnZ09HMFV6bkNsR3J1M2lNNkR5QjQ0dzIrRVB0?=
 =?utf-8?B?bDVJUTFVK3QvcW5aeHUwS0hUZlU3RWIvd21zUFoycDh2YUZ3bU5pdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n6xOhbHi1J6zUYxUaqaWzbhO/0TWeO+Ldixmw75wSSxidEjx065Kw6Giut3Vwm8roppceY7kuj2Qx8/0wIEYC44vPxL+nLarw8MsO9QSpI/khY1E08TzhFz1THSOrR4xZA1XbDnCgGkjkHZbUP/n2iVqbV5IpRMjK5KAMCuBXAf1NjErgSndQetajrI+EQPFzxJOb/VEU/NJsfR0O/UdxCQNsHzvzgAyaU4rf/EndfW328HJ6JM/03ksUa0kL9PjQ6jJgIoU54EAUdE+ae+fCgBBJgv0toVkvoZoIA4ShdBFGQffs00Yk8da+kfEm0p5K1kGeLtz5GZehRiRe2Cb2OSSKHi2TCklDclQqb6T8oXOGs2/Nv8XnZl+FRluoihxl0x37oaHU4Dca5X+A3PLqBOZF6jGjGJYtiSH4dD5VcHGS2J5CzNeJCYIaXwBmjJQGKn0iJorawpDJlLLYDlYNO2BEMM7gVKZ6/jMGcxxRdv3v2c3/IoPeluoBwi00J4FFU3HChTMhC90OuGbkMRrBOA65pH//fqwZ3YIvomKUMlEL4LIffqKZ0HVK9sOwnTfcUEVKhALNfk+KHDuetOtpZNwXrGgiiaW/tSKys496WI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796cef8b-fcf9-4108-1fa3-08de52df9fe3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 20:09:14.8664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbCy8VEE71TGJtHSN7HSEv9iZMLYi036t6ud/qTKBggwd+M62bpndVnL3j9M3/9QkXPz16J5xgu6u8Ac8MxsoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130166
X-Proofpoint-GUID: zomlUR5CdCyDZBUnwdVR5RhhX9qO-1tc
X-Proofpoint-ORIG-GUID: zomlUR5CdCyDZBUnwdVR5RhhX9qO-1tc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2NiBTYWx0ZWRfX7bqLg5r5HfC9
 Dc/jpjIRutG5slR2BMz5522/AesPx6d3zOHXwmsjl439Mj7DzrIs/unYL8kLHD5KMiyvzQLrqja
 DYCVlWI7p1OjQDek83xx82/pICLCQKR17JFkwiN6zX9Z4hc1C03GMBXsMwBnZziTT301JsrvIXE
 PKuDtE09HmSWDqasc5f7SLnSd/5qIrTypPexU9lANKAH0lPGUg4PrqS8ptT5xI7RbFpx0igpBB1
 z8DUTL8ivDaLU3fs2MAqnags/iwtONHpKvKoJ61TFfZDlWF2PhzTc+cnhLAM8JxKQTHMCPGOrks
 A5hHuc8lC3YkLCtHb5ORnRlui22I0Drjj46NBWb8JX6++BtCqW2JwsvdldZFvCNR+aw0tRzRhXs
 Pw9CMS1qFJa3cBeumSW2Qmo6xCM8ksGtr+Vf673IXtzpo8lSvcUozM4DD+r4lVIdHAil3m+dKFh
 RqU54qVWDT0FPMtB0Yg==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=6966a672 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=HcBd-jJop3_ckuttBGoA:9 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: 0139220007
X-Rspamd-Server: rspam06
X-Stat-Signature: m9n4qy93r1ju4qhyqktubijetwx78dur
X-Rspam-User: 
X-HE-Tag: 1768334976-427777
X-HE-Meta: U2FsdGVkX1+SNHbK5JhLFxWS7ygG769A3v6/rzaKiOD6e0tPIfmhv6lphsESW8CIVrhHosVc+nq/YDZaWyWpN7v0WTTaA7tUnEh7QDlgCpUAGkcUax1Mb7KwMapPYOb91W7RZmQX0QVKTybhZv8e6YHhnhBXzO7BwNJF+DrL0VyrdBe0SzkIVxj1dwS1T/6mKloC0FxGEJ3eZY3AGFZRKjpcGEWS/+LomvnxK+zAznQt7UWZr7oF7BO7/0/rVc7kbAYS05GErBKr+R2PeQwNxLMqBNBvp8su865kqssnWVV0hNvhai5GfZBlNvLzEHwN8YA3N8BmWBWbldyNmEwdxqivP0o/kTFTu0nX3eV8MhwsWTcgxEjPM24Y/2ZwUPa8Pi3qm3ygSiQ5CX0+VRY4HDUAhFAUeWrbeyVT7HTjhcHRI9Fr9tSJuL+d4lKfluFnB1OGclVU44y7TU8ukAt3tDcCQ+hTSZe36SIEEgVpVdG1AYBcoBJmI8PNCsrQW1wAb3gxADPw/py1tXVlv99KAVIMWzTTCfJPbWnC8DBvZ+1i4u0b3AHGso9XZy/3V+d12LGCETHaYhZjfJ/ZR/Ww8EpIJFJxh/n4o/gqbzAJiXGsgYk6/A17zbevnCaIcQTygDAwjq7jCvEMZsfs3KvviUStuskDvtYJD89LMyd3Cn/H536XpV1jmTnv3jedoONj+HqbCvtr2sEWcp3tSY4rxlExc633naEJbp7r0YexLExAkuRcvueF/w7Aob5oBu82z/edv3F/p0KQZbROKNPpNXzWUWvhOqBOwPeG11lQGzGEq+a0l91Gd0OmAihnvqAS1Hr3roRoiE/71l1zDUsnsB7yNFtqJLu+OWqhkkehwCi/9/nIuxLiBqaduUHo9i+r0ib9SkDorxfcfUSI++c8rIDM6dyhrV2CGMvFIDeMZOIC9aGEdvSF8GFb+6qdqtSMXA4040RGJ+XLnNaIdoz
 /Uhb9O7o
 XRzMlWtUIkuPC7CvNF0OTf0oAwT9cnk4NUpDn3fK5P3eGxw4ngopwtMShN9Wb09X/QYGRtBHtY/Sn4IdOeWZOeZ4QwMj5D1iEiXyxwaXtc3f2J8x7cG4i0Z2+UhRtATSr3cWilJij2TruwkL8C1gtY6KubeiPbHPBRxWTdh0i4KzOoguWlttJLTMkzpQr4bEWh51UybJ5V6lqG4/iccoHQfOTa4CmU1YLv+2l190Pl49baSXyP1xhImBdaoBt1vSVGg7LEXWosknA7KLCw3gi53uiqUBjYpF3sT/QN4sGNvnLCRbIIZOnPf9httBcA608zTNhrEGoORfLdm05+qPLrXmdMnQruRg2bQ3aFZHU8cCX2LNS0Zoox80eiyV98XDMG+1ojIzzdP6fbUSRAAS9ULUK49c+7SqosdOo5X7Snet8/pQORlKWRf1QxJWceJpLQ9wXAJYLA6ZleA75Mcl5nlgEYXa4LXCr/D5bfWMSp1oUpZZNg+t/lzZN2cj/dtiyniJN6N5wugds92yrSTmWfNb3XX+fPOIKie8K9KvNaVpj5BNa09G/uo/h82uXSTTCbkmT+o0+USGvyGyVM25iqjvfNdInXyrnzZFxQVg3Tm4jZsm0p6KYHsGmI3j+wRt1PVmdrY6nZdoo6LIGKh8sBJUDaDVHpSihySrk40rkCJN+IEVO8NXJ+GxFxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250909 17:29]:
> On Tue, Sep 9, 2025 at 12:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > The unmap_region() calls need to pass through the page table limit for =
a
> > future patch.
> >
> > No functional changes intended.
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >  mm/vma.c | 5 +++--
> >  mm/vma.h | 2 +-
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 1bae142bbc0f1..4c850ffd83a4b 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -474,7 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
> >   * Called with the mm semaphore held.
> >   */
> >  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> > -               unsigned long vma_min, unsigned long vma_max,
> > +               unsigned long vma_min, unsigned long vma_max, unsigned =
long pg_max,
> >                 struct vm_area_struct *prev, struct vm_area_struct *nex=
t)
> >  {
> >         struct mm_struct *mm =3D vma->vm_mm;
> > @@ -487,7 +487,7 @@ void unmap_region(struct ma_state *mas, struct vm_a=
rea_struct *vma,
> >         mas_set(mas, vma->vm_end);
> >         free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_=
ADDRESS,
> >                       next ? next->vm_start : USER_PGTABLES_CEILING,
> > -                     next ? next->vm_start : USER_PGTABLES_CEILING,
> > +                     pg_max,
>=20
> Hmm. The free_pgtables() parameters were advertised as:
>=20
> @floor: The lowest page table address
> @ceiling: The highest page table address
> @tree_max: The highest tree search address
>=20
> but here tree_max=3Dpg_max. I would expect pg_max to mean "The highest
> page table address", IOW we should have ceiling=3Dpg_max. Either the
> order of the parameters is wrong here or the names are misleading.

Ah, the order is incorrect.  Thanks.

> I also think in the previous patch we should have renamed
> free_pgtables() parameters to vma_min, vma_max and pg_max like here
> for consistency and to avoid confusion.

vma_min turns int the page table floor, so that one doesn't work.  If I
update one and not the others, it gets a bit odd.

These also all go away, so we'll have internal series renaming.

>=20
> >                       /* mm_wr_locked =3D */ true);
> >         tlb_finish_mmu(&tlb);
> >  }
> > @@ -2420,6 +2420,7 @@ static int __mmap_new_file_vma(struct mmap_state =
*map,
> >                 vma_iter_set(vmi, vma->vm_end);
> >                 /* Undo any partial mapping done by a device driver. */
> >                 unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end=
,
> > +                            map->next ? map->next->vm_start : USER_PGT=
ABLES_CEILING,
> >                              map->prev, map->next);
> >
> >                 return error;
> > diff --git a/mm/vma.h b/mm/vma.h
> > index a9d0cef684ddb..b0ebc81d5862e 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -261,7 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct =
mm_struct *mm,
> >  void remove_vma(struct vm_area_struct *vma);
> >
> >  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> > -               unsigned long min, unsigned long max,
> > +               unsigned long min, unsigned long max, unsigned long pg_=
max,
> >                 struct vm_area_struct *prev, struct vm_area_struct *nex=
t);
> >
> >  /* We are about to modify the VMA's flags. */
> > --
> > 2.47.2
> >

