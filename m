Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102ECD38FE6
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7871F6B0092; Wed, 14 Jan 2026 11:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757806B0093; Wed, 14 Jan 2026 11:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2536B0095; Wed, 14 Jan 2026 11:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3246B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB2B31A0564
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:33:09 +0000 (UTC)
X-FDA: 84331114098.08.2A7C44B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD9E0C000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:33:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MoqVJW29;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XzNEjkfp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768408386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bs1BjGFAyVhkM1Hi7V6h18Xma1h20BaURXXuBLnS0gk=;
	b=K+BwOzZjbGJNtZmz8VXLRPq/EaaS7ck+M9GDLHzTeZ2qaZs7ScA5Pa/BJi2HnWPv+O5Zrm
	LIyJPtDVRi1XwWZU2AkuJdI/VqSVpYR4SsAUeV+R9+cpGjDsrVW5bueFwSGjb05QY5z4eW
	uK58Gen101rM2UFljampgWpyxq8VYt0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MoqVJW29;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XzNEjkfp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768408386; a=rsa-sha256;
	cv=pass;
	b=vbC6Az5hBdR1wDU77cqBBq1sduSC91goQOJEljUol5SKatyljIyF8cEH0tjLjf3a3C/Xpo
	Upw1T+S0hM5k5kvKjHIV8LoaHdKol9GPWaBYgDZhBD77DZzSj9Pgr+zoZwnK5D5QeEmKjo
	Pg2FnyyA+EjBQVrHSApuOSg3CEd/tzE=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6NwBA1299107;
	Wed, 14 Jan 2026 16:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bs1BjGFAyVhkM1Hi7V6h18Xma1h20BaURXXuBLnS0gk=; b=
	MoqVJW29K+u4j+9qOquaoyHMLzPZToMe9A+9BqVWoP2TcKpH3ddEbmOfb0xXW7oY
	NP6li3lp2w0IfG7cDii2va5UP4hhr+UwzyDSAXvO1cMZn4Z6JkZoskh2L1Qm0oQh
	Oz2O9EgXLV+1OQlTiDcohMjJkG5QIMlS8O5bMfYWlZGuBh6nilSV4PKi3+Uo/pa5
	Gapt0WPvZ3xi2DIP19IN1G/ynEsgkjbTkyKz8RfqkVbjD0C9phyAmh+JVe/uAo2H
	Q2q/eOD+TqC6943DxDwrzW3uABoy5+JFV7aL2+dhpIgZ1y1+ei2I5QNIXEJ5qXNy
	yrc0t3l3bZC3CLT3eCgmNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc0ta4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 16:32:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EFA9Pe001848;
	Wed, 14 Jan 2026 16:32:40 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7a7mu0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 16:32:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVmYYoVATgL68KRwp8xVM5Ao2XS97DlNih/RRRzfkkkL4bMl12iyE8iGYoEPTLBEZ6i/EcTGPfwPuQie+Mn054F/NtzHtc7vevhENhpfDUTyHz5VT68ybXWh/KEIZNAIhI2MEN5G6b7SFU7jkS14Vp3LXJssphlQwzaJuhgpjqj4xIDM7KnXcRDNIE3Gy6P/i+DJGcAjwOxVxiMXmdHTkgjYnwmZtXqBWGPPjdDDlkJViwC6mWbaPhe7nEBHYuPrMeO6+pya9wE1rhYKTCnebWJPPxuPpL/dFAYz0/eYQkyeC1PGa4eKwKDXQxwXOM26Hx//mCpEk5YYZMdtEvrfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bs1BjGFAyVhkM1Hi7V6h18Xma1h20BaURXXuBLnS0gk=;
 b=KWGxXlt8qFQz/tKNkUFAEd9h9efVkuAoGWJLW1OtD+DjqktEQOTmmwrpocZu1lPq/ZEh89KPC1d2+8ka+TjTlRCqBrAyPsl8yRFEcclhOiO2Z//0aO7/zfUMHDpP21RmC6mUCJMnj4tkEVlJXyKd9lXX2dOFaA+eGphrW3clDX3+oa1WiHF/7mj+2rlW9NYQmKUKeqJh0lFKKHA0LdX8lWA6f1QC9dXjIJKUIhhZSrFprC+aNtnJdMJzqbpETJ4QqHkDJwU0qWJmJeRMkckELlAw+YBJwHCmI6Wy70flXhsDG0pleaXq5pzq0EnZSLbsfGfj1tL2UyLYzFJLICCmWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bs1BjGFAyVhkM1Hi7V6h18Xma1h20BaURXXuBLnS0gk=;
 b=XzNEjkfprXS3Sf9FoeCeJOWH+JjWOSc+1X1c28YLeCb4zjEkdBv8AyG7d3nWwXpwRroDS2nz2zKgUF+WuuA1C7nuH7CeBHVvwKKHXTVZdCY9Q15QxNY7ZIJM8ESQeayjR4dYuSSxneysiIGJFU3YMaKt3apBDLvfNy6llbscMe4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB5868.namprd10.prod.outlook.com (2603:10b6:806:231::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 16:32:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Wed, 14 Jan 2026
 16:32:36 +0000
Date: Wed, 14 Jan 2026 11:32:31 -0500
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
Subject: Re: [PATCH v1 9/9] mm: Use unmap_desc struct for freeing page tables.
Message-ID: <ixs4k5ynmp5mpsk67fjulvy57ih52pfpngrvsqdiz7p66x6rrn@2lgxj4e7xpp3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-10-Liam.Howlett@oracle.com>
 <CAJuCfpHp2sgKBqrfyn+xfCJTA-AFGFUTdhSz4dxNff=SNYLJgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpHp2sgKBqrfyn+xfCJTA-AFGFUTdhSz4dxNff=SNYLJgg@mail.gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b98f87b-9734-4781-8afb-08de538a86b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amNkYzBuYmdGQ01EYUtiZEZyazN3TkZsOUJoMGtBeVpEMXZzMmhiNUovZGo5?=
 =?utf-8?B?RGY4MTJaNkJlYktHSVE3WXpLUDZFVTRLdlNsRk4zTERPS3NBaFIyRm9UbUZu?=
 =?utf-8?B?ZEVZM3FlbWJEck1CWWFwSGFxUndjTzlSSmY5R2F3eGtsZ2twdExKL0lZWnl0?=
 =?utf-8?B?ckRqcitCMHIyUjl5VlBESGV1SE5WSEo0eGhlajFFQmpOV08zTTZZb3J2d2ls?=
 =?utf-8?B?QXh4ZTZXQTFDUHI0cGVhWi9lRXVDc3NpTCsvbTFMdTlhbDRMRnRKelAwdEpC?=
 =?utf-8?B?cXg4ZUVmOHA0TWdxaWZkNlUzSnE5UVdoMGdTTDg0NEFIY3FHRk5jR0JwRkNt?=
 =?utf-8?B?VytUcXp5RVo2M0phZzJEYlNtUWkzZExubm1USExpN3dUOWdyYVlVZVBRMUpH?=
 =?utf-8?B?MUlkdnpud2JLeS9DaC9Vbi9NK2pSdHQ3VDhuQ1VRR29NSVZ5MUV3aWJUZUdP?=
 =?utf-8?B?WFZ3aTVJTDJacEdyYW43bEFJMEJydXBEZGNYOGpXdGZtY2RYSVNxL2VKUzZG?=
 =?utf-8?B?V3BXaUxCL3lhcnVkazlGTlppU1IzNWNiTUhYMmZTK3lVcWp0T1R2cHNCeG85?=
 =?utf-8?B?MGRBdVdsb2t1Wm5Odmd0OTVxa0J6SFdOMlJPdklxeDMwWXNEMTJ5cGFwM1Vx?=
 =?utf-8?B?QVlROWl4S3EwcTdTSzFPOGtuRE1qYzlEQ0l3eFd2TFZDMGx5dHlkTDZRL1RS?=
 =?utf-8?B?bDlLN2NoRXc0Rm41NlRMaU5Ja3dZRUthZzk3NnBWZVpIcXJQU1BUU3JQRlY5?=
 =?utf-8?B?U0lTTGdyNnB3cEdmSythNURSTGtZRFdkVTJYcWdYeG8vdkEwUHJnK3htT1FC?=
 =?utf-8?B?QTRvdklGWUJQbWhRS2dlZmNtOTBpQlFUTU4rUXE0Qzl5bExTNmJ1TEZ5ZkNZ?=
 =?utf-8?B?cU02b1h0cGd4dzU0L1c1a1QvcStQWGh6S0VSbHFVdTVieHVuc1VQbXcxbXE2?=
 =?utf-8?B?MzEvYWJrVDBneTd5THFDVzNMZ2JRcDZXUEpLenY4U3BUaUs3NUdGc0xmK0hV?=
 =?utf-8?B?VXgvVXliOWRRREJTazk1aWRQL3RTVmpzYm81Y0lRdUw0anBJdlVXbmdUbGZv?=
 =?utf-8?B?RFZyTjM4cGM1a0lHdHoyN2Z5RWxuNVhPaU1UR2ZzZkVkclFGOVJLVllhWk9T?=
 =?utf-8?B?enJMUjFtRHd1QkNoYW5ORjhhMlRlaTJET0RWSVJzL0N4Z1lybUhLOXdOTDB6?=
 =?utf-8?B?RnhYMW5MVjQwS1o2dTVDSUYzSTc0M1kyRlhlczVmRXZZSVVVekpwa2NjVnps?=
 =?utf-8?B?eXdBc2IreGxmcitOK0xhbjl2djVMWlRBb3EyZklGckwyMmRxSUMxSndBME43?=
 =?utf-8?B?OFkxYUFCSzhEak5pQ3M4Y1hmWVdzdy9xMTMyZ05ZbXlVREJjTGNqN3RYcm1K?=
 =?utf-8?B?VXcvb2RqSVYrYi9iSDBhRzNJRnBOUEttd0FUSTRGT3ZXb2ttUTloK285SFVV?=
 =?utf-8?B?VmlCV09LRVJ6VXlNdGVHYmtiWGxBeVB0a3NyMkZXNzBNMlppSmVOYUJXN2Fh?=
 =?utf-8?B?cnowSDFHU1Uzb0ZkdHZzcmVyQWl5cm5yTTdhZThqWmJ4N0RBakFGcHRycEVM?=
 =?utf-8?B?ODlHQUdzUU5mVUROblkzRXI1VTYvb2ZhZk1rajhEU3lCU1QyTit3cTZDZnRU?=
 =?utf-8?B?enFMaGtJZm90Lzl1eFE4UXVLc0JqdFFQNkZ5SVlNdUlTUXcwczVGdXF6SWRt?=
 =?utf-8?B?KzN4WXAxUUlLQnA4bXlUQWcyYlVKN1BmREJtcTQrcXdiRmhPbnpVeWVXNFJv?=
 =?utf-8?B?WEZOV0UxWjFWZjVpQnh0SzMxSWU4Y0JWTG5GdSs2ZGdFVituYnhlbkJMalFI?=
 =?utf-8?B?NnJXdWxGUHV4N0pTdytCd0FFOVRubWZBYjBxaURJaHZUdDF6a1JCdGRGNGR2?=
 =?utf-8?B?RFdmMXBwQXFaOWpzU1lFZEdyNlAxaWowQnQ5Q1l4SlJYSy9qdEt1a29ORzdZ?=
 =?utf-8?B?d2hlZmhDOHFSUitrUndsY1dsMTFJVlRqSGVQYmxkNmMvMGRDQ09QTTZPQk5a?=
 =?utf-8?B?ZGZzdmkvMTNXaUNQeG1XdzdmUFExU2JQQTViQ3N3cTFGNm1GK2dXbVNKdXNy?=
 =?utf-8?B?SmJoZ2Y0Sk1NRHphTkU5ZlFuZml4S3lYQkQ2UXU5M0dZbFgxcHpvTXg0aHVn?=
 =?utf-8?Q?nKpE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVk3WWpHRFk2MkVMYXpiZGNjT3cza3hNdEVETytJNzBGTUlLaTRSUndtT08x?=
 =?utf-8?B?NkhrZ1VJTHJTSGYrdE5PZlJhSit4K0trdGVqV0R6OTk3V256b09jbEk3aFhI?=
 =?utf-8?B?UnB0VFE3VTNhUlFJY1ZZcGxLSndZLzVlck5TVzNURldYaWJWMy9wR0ViOW1q?=
 =?utf-8?B?cWpVeEJIdnVlSnhxNnJZZTNkSkRhQ3JjdDNJZ2tHN3VxSzNHamFtOGZDa0Qy?=
 =?utf-8?B?ZnlMWEhXOTFGMlJvcGpmQmhDMDNkelZTNnhqMGtYMWFrcncxSWdCWVdvMUU0?=
 =?utf-8?B?VTFubjdmK2Y1TEdqcVhlbjNDWkdQWmNCbUIwVDI2emIwTjdFZlhVZWkrMTQx?=
 =?utf-8?B?TjhBR2lhR092cXVBYldXa2dDWlI3a3FwV0trQXRrc2ZQSE9OYVlwRXJ5OE9E?=
 =?utf-8?B?UkxsRm11WGVYYzR0bVBrZzk3WngwSHNxbXlCYmUyZFRxaEhrTzMzZTU2M2Jr?=
 =?utf-8?B?NS91cm5KT2o0dEo2T1E4ZERGRUtsVHcrRlJueHpvQW52QmpTN2Z1NXdXSnNO?=
 =?utf-8?B?QmZkVXAyM2FVZ01jZ1Z1REcyWkpHbE9QdGhhNGdqSzUxdkNtWlBZUTlnSUt1?=
 =?utf-8?B?Y2I0eFc2ZjlyaUFLblQ0eFF0QWFPNkE0NitQNy9wYklUaFB3SWlzRXBjU0ZT?=
 =?utf-8?B?VkFUKzkvekJKTTYzSDN5NnJsSDBiN21pbXZZYVVtVjA3Rlg3T21tcXNYRHA0?=
 =?utf-8?B?MDE4eURDdXMzdmVpaFlQRWkySDlSTk1YWUF4OVkvTGFoaTBsV0FLZnVialJN?=
 =?utf-8?B?UEhIUGtsV2hpMTZEM1FZci9ldlZYbklGSDlZNlVFZXJTenR4amNFSnMyd1lN?=
 =?utf-8?B?WlgzL1lCRmx4WGh4Tk9HZ2xkeHM0UGlDeDR6NzFka3NpZU5Wd2hGNmpMd2lI?=
 =?utf-8?B?Nm1vZlBlRDNKZnFDaUdnTlFFRkRINGtzOGs1VHpJdDJhWlZ1RmFZRDRmOHRO?=
 =?utf-8?B?QjBVNFlHUWhxT3NLT0NlaThHa0xKaU5iem9NSkFRV0tycjhrVnlGcWRkamN3?=
 =?utf-8?B?ejdhK3dmaTU3UHdtaURESFRFWW1YalhTZkZtVHJ1S1dLUVE0Mm5xL0RxSmtu?=
 =?utf-8?B?L1RrRHg2NGxCM0xzSmVhc2Z2ZDRVdzR4WXIyK1F1RW9FL2NuSHFjMWR5SGk2?=
 =?utf-8?B?R1dmdExxNllnc1E1UkNCNjJxVVRmYloyYlhJUWVobTJTU2ZFZ0RCQURub3B0?=
 =?utf-8?B?dHRhLzV2d05yMUp6RFhpa1pQdFVPMDNHL2NzNFBEVTJvM1MrMTVBNnpRQ1RR?=
 =?utf-8?B?eVVoak5Qbi9valpMSkw0SEFadmFLRWpNTzN2LzRUUE5ranFLcVdnY2dTWnBJ?=
 =?utf-8?B?NmJHdXpJcmRjR2t2eWRKaGNCZXFwOWtOcWZZd1d5aW9WWk9rM0NJTlZYRmJP?=
 =?utf-8?B?L1RzRG05NXl4aDNzcllYVXNRNkxpOWVJTUtlWE5QUVZQdFl6aTVUVVZCd0FM?=
 =?utf-8?B?TnhIbkdYaVFTWEk4QUZRZFdqei9tN2NLbTFQa282OEZ4U1hHejBXeTZqZUdQ?=
 =?utf-8?B?bUJUcnpoalZ1SHY4REtTR1ByRjNxU2xqQzNOQnVRTDhVRG9ucS91N0hVb1hS?=
 =?utf-8?B?dDFudHAvYzE0d2VDQjFPTUJ5SWZhTHViVDM3clZ3ZVRKTWJ2QW1VWHg1cTZF?=
 =?utf-8?B?R29KcnBhOUZ3TmtUR1h2UmJ5SGJyK2k0dG1TaFNIZno1dTFrd2ZtU2Npc2Na?=
 =?utf-8?B?N25YeTlaNVBlMGVBMFU1ZGhlTVlTL0o2dzdIektza2V1V1JWNGphM3ZKK0tE?=
 =?utf-8?B?QWl2bExGRDJ3WlZIWjhZZGJzd3JVSkVuYmU5QXE5YjFiVnNNZmlQMlV1SWZC?=
 =?utf-8?B?L210S3VUelB3Zy9zZk4wSFZjY0ZtbzZjUCszRVpsbitaY0VYRDFPQW1ZcXQ3?=
 =?utf-8?B?OFVWNmo2SU5kaHR2TWVXTUY0STlXaUNkZXROeHpGN0lPOE5nbk5VdWVPWVI1?=
 =?utf-8?B?anhRSFhrZC9zVmVLdExJVkhiZS9sNG1LcWdQK2hCL0hrVXl2VVhibGtHR0tt?=
 =?utf-8?B?OVBic0phTEtzYXpkUysxWm9IRUVSQ2RzbStJMWYrMERlN3pYeGFmWHp0Y0xD?=
 =?utf-8?B?NVB0S055SnJiQSswdEpqdUI4ZVNQTkhRbEU0aG8zZVhuTWhyT00xVGF0cElL?=
 =?utf-8?B?YU1LRlVrMTBkWFF6MUg2VlVseXZlMVRmMmthb2hodzVGS2JteXQwMUhSU1NM?=
 =?utf-8?B?OEJVUjJoaUVSbW5HdHlYY1JnNHNLcVNjcW51ZnpTMHpKaEpYKzRNK1Z6T2hT?=
 =?utf-8?B?dkF3bHJOc2JMOWY4T1hsbWRTS056TVFxWXdCa0NMMTh6RVZ3azV6Z0x3dTg1?=
 =?utf-8?B?Z0FZRjZoSmxySnY0ZjJpSlZkek9jdEFISUVIWGxTQlRLbS9LdnlVdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VIB2l1/QaMLoFytVidNhm1ahJFpaCvwB7+N6Fi3ADiFtZMh5iBB6pmVro+nOxyFIviDJPeWRSHd3MNwg95mQ7rPWxPU0R+4O6gElOrCPCtpJx0CtknPrL/BUYtqSG46RFSItn7O3TyOJAq0uTQ6pjeaxo6ub1SZ0YJTv4rYdZ0YBVUgoS9oIN8/AUsntEKUV4QVTENBmSN8gu/iIHren/emC5EOes+dWT20y9opYw/NBM6aygL6UOP9w5CpO/SKu+pvK2llZ7zoptsdRKwAnr8InBuDhUNueVNYvxbqYUD/Ym7mAxVPbiUHvYfr/ANVjgOzEDqbuHKTsukW1pCdhZooaJCwgXTmbubRpZXEqffEG9BDRNB1amDZt9t0QSx1BsDJhHVCAJsoSWUv+a9ImN052+jwVDKjwVnTe8xY2yO9MiWBkHHt8dx9Gyz9D5+eqLyjnkbngbo6m7bAwY3cul2jkvmRd3eHDhZ55CSDUEWmUEZMYis/dsEcxolZihZC3XbhldWqFuB+EFydePlFF0xcQX0PyMzEA0765eOnWYllp8NhUEcKTViaRns2+IFsIsee4s2yZOxdvRxQwp3FO18FmXFiVFaWMnBwjcdtMvV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b98f87b-9734-4781-8afb-08de538a86b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 16:32:36.5125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIlzo4TV9J2Ks2AVUhoKbyEwhzHW55jRxfZpETBoqb7ZDfp0y731+IGLeKVt76tCu86772WLEgUllryP1EXUOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5868
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_05,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140138
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=6967c529 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=q7Kl1mY7HeVpexYSZQgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: iWjeBmUCTNtSj28dYkPZm84Up29zt1ig
X-Proofpoint-ORIG-GUID: iWjeBmUCTNtSj28dYkPZm84Up29zt1ig
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzOCBTYWx0ZWRfXyo5PH2GspEva
 IYfSrySD2SlGmnYgZQZUyT7a+dh6zqIblypmGqU0W/lNYjsLG+FvwvH+FEW1xdDAJJIciEVYV6N
 8nrZcKw0R0+vNl/xLwa5+I5q+/E80ZzkgzQdU/5kZk/k+Yjq0JMro8oBNGp2jGQX3w3ufnOUBGO
 6gc7dO2IxYOWEFMpuSs9AlPTFacIVD8YaYrzpVH9Tnz4EX20dTd4xq47aw8i/UIotv6US6lwxFv
 C+rTg4Q+/a/xJSbXp+4WP8OI2ClVGuZTLlYDIXA2SMsdaSMiFL475DnC+wu98ldHWRcluG7/i5B
 6CT4m2T9I3Xd/uKiFNUfIRxYi5g1yKYbgtObs23l/dKpyAHFVwEViUvFxGe0ZhrFJdaa7tHb+xu
 HAyR5VEwYZN+NdFC1FZKOEH62Wzdmbr+rMnAnnXbLSBYXiDvlGty+Tj3C3Y9gTSnYMVJZVdyLHE
 iJa5YdfEW7W1ojkRgww==
X-Rspam-User: 
X-Stat-Signature: s3d85ppb3fpcu3zy1qpmhr1wd8w3r54a
X-Rspamd-Queue-Id: DD9E0C000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1768408385-363501
X-HE-Meta: U2FsdGVkX1/2lmKxwFoDidfTpi6pyf0UubuDjiGZIEUkH04bp0QEUDA9bhSy1RCJmkDPskSyuX0cKriceJnyQwO40diJqhIN8ME0nOi0BVBS+rnplcvkSObSk+7dlRMVhRk9OoYBKFUEO9Qqrjs7SEVuSM1jWBy4eANQ0qFBsi5r3ZUamtvXQAY1xq77lzpglhrvlk0DyUlLl598OpZfacevyDo5Rg4HXxDO1d81h5dMTYUIfFiTmPIDP0+KLlnBYRubYuhkyX9oya/CjOdeqz57ow68k8VUZpC5gUxopneoLi2yT1veBQgUbijUdfrYmLeDZKy9+Bw/PZmI3u6vSyRuxg7tTxmykMQQWtL4v+bHH/sJKSF8LfsLtTC3LM7kNxZFkFQdrNMj3a/BgGjmaFEJXNG0od8Coh2QLAGsrzfs+T6VP3GMfYeeJNoMPMWhTnhOoJpauzkKtuvQ97EWG5R5oaNrDIOk39eTlcHiD965ZBFbFw1byx6PycZefFSdhwMmqrddhr9Ju+EGsxEAu2Rc0vLXBNMDgHiepA4VcFWwWGxOSNjCGND+/Y4tDMvQHdWAyAEqTFLpgE39SDqfeCWeZ7KZPIdHu9IMv5QsXIQL9h9YYFeQHrPc0VK04oF0jq3l6AOnfZR0NPQtAcfiH3qUjJokJbeArNDA2/bYbZ924LArdXPWD6SGywpq1Sb/dzeCYVikv4p5yebQaXh2pBZL2cbYNi4bOcvBN7smGHbCF1xyUg+oAu7sa/xNoA0k1co9SdM25V7KEEf4fz7uX8Zz8fs+JHfLlmX1aQiAtu4hDD8Xe7rRmnl55t2hw5ERER0F73dY2vl9ozJl+ENGkrT7L34+SCnpiLpOm+PXPRWF5WcsUFHAl8n3dzZkKoxptMDqEY+6JUCAxX3EIJ6IW41i0zJ5MPgaEJQKJznxkJPVB+nYFwPRGpjzUhTr1I9TNVl6J49YagTYGGpzxh5
 MCaVN9AK
 DuQzDV/20aQNFjGie9i8sGL+4rKixi+uLwLYocKYV1Y5sWB9C3dpyhyHuFBnJQ2mwrNFIRg6c6jWcVVSMM+o649pX0CMaxiolhZANvSjFl5iISJbXIRAo9GnxaumP5E2IIMg2j+blN1ElFdTBvmGAg3YRPqSo70T2W6BaeI0z4XbXdsHIJxGVGGnk7mV0p1iNSRY6xD1Na0bCXW3wdMcPXuiNGcmINOnevA9iasG+xRowkc27Jd4bykZIFctiwmNxNWA93iEO1dkYifApru7mpPvE4YpkpI6qJmevfiTlS0p6fUQ4eS0n53vHH7+cO6W5dPoGhO0frSDu4bKdQsEDrQkT2/FbsQyjd/smpufSxYOZhFliceZF0FoEN5Cjl5F1F3YtvuA7hwmRXra6hoOA/PQ5yviW33hWBuwBTUZmtudnLoEj8kIsYZ+mC0jzHcb1/76XpXJW8ifBA65KAMsP5cFr1V+tctv+3tkuEQAvtOWDOHLsQeTdyzJ5D5wMXjW9kKY0NTN+N6QqO2q1nBExSBScWB9vQirHIZ/pP8uJd7bBLCGuWG8hcs+fPXXxPG9Q9vVLuer6P6Gc3piZ3Q6iNjnyu9THQYeL4Q2EFYNQXj/lYh6YbQ64mtTIyNKCKS8HaIEgwLgdkZRuDV1kKUlHNH5324UVgIy4Cw54nyKgDfcbRTKqT0ix28si/wWZYT26Y9RIZV7s3aTQQqosj35HKfqmmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250909 18:27]:
> On Tue, Sep 9, 2025 at 12:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > Pass through the unmap_desc to free_pgtables() because it almost has
> > everything necessary and is already on the stack.
> >
> > Updates testing code as necessary.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>=20
> > ---
> >  mm/internal.h                    |  5 +----
> >  mm/memory.c                      | 21 ++++++++++-----------
> >  mm/mmap.c                        |  6 +++---
> >  mm/vma.c                         |  7 ++-----
> >  tools/testing/vma/vma_internal.h | 11 ++---------
> >  5 files changed, 18 insertions(+), 32 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 1239944f2830a..f22329967e908 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -445,10 +445,7 @@ bool __folio_end_writeback(struct folio *folio);
> >  void deactivate_file_folio(struct folio *folio);
> >  void folio_activate(struct folio *folio);
> >
> > -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > -                  struct vm_area_struct *start_vma, unsigned long floo=
r,
> > -                  unsigned long ceiling, unsigned long tree_max,
> > -                  bool mm_wr_locked);
> > +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
> >
> >  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 8d4d976311037..98c5ffd28a109 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -387,15 +387,14 @@ void free_pgd_range(struct mmu_gather *tlb,
> >   * The tree_max differs from the ceiling when a dup_mmap() failed and =
the tree
>=20
> "ceiling" is not a parameter anymore, so the comments should also change.

Thanks, I'll fix it.

>=20
> >   * has unrelated data to the mm_struct being torn down.
> >   */
> > -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > -                  struct vm_area_struct *vma, unsigned long floor,
> > -                  unsigned long ceiling, unsigned long tree_max,
> > -                  bool mm_wr_locked)
> > +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
> >  {
> >         struct unlink_vma_file_batch vb;
> > +       struct ma_state *mas =3D desc->mas;
> > +       struct vm_area_struct *vma =3D desc->first;
> >
> >         /* underflow can happen and is fine */
> > -       WARN_ON_ONCE(tree_max - 1 > ceiling - 1);
> > +       WARN_ON_ONCE(desc->tree_max - 1 > desc->last_pgaddr - 1);
> >
> >         tlb_free_vmas(tlb);
> >
> > @@ -407,13 +406,13 @@ void free_pgtables(struct mmu_gather *tlb, struct=
 ma_state *mas,
> >                  * Note: USER_PGTABLES_CEILING may be passed as ceiling=
 and may
> >                  * be 0.  This will underflow and is okay.
> >                  */
> > -               next =3D mas_find(mas, tree_max - 1);
> > +               next =3D mas_find(mas, desc->tree_max - 1);
> >
> >                 /*
> >                  * Hide vma from rmap and truncate_pagecache before fre=
eing
> >                  * pgtables
> >                  */
> > -               if (mm_wr_locked)
> > +               if (desc->mm_wr_locked)
> >                         vma_start_write(vma);
> >                 unlink_anon_vmas(vma);
> >
> > @@ -425,16 +424,16 @@ void free_pgtables(struct mmu_gather *tlb, struct=
 ma_state *mas,
> >                  */
> >                 while (next && next->vm_start <=3D vma->vm_end + PMD_SI=
ZE) {
> >                         vma =3D next;
> > -                       next =3D mas_find(mas, tree_max - 1);
> > -                       if (mm_wr_locked)
> > +                       next =3D mas_find(mas, desc->tree_max - 1);
> > +                       if (desc->mm_wr_locked)
> >                                 vma_start_write(vma);
> >                         unlink_anon_vmas(vma);
> >                         unlink_file_vma_batch_add(&vb, vma);
> >                 }
> >                 unlink_file_vma_batch_final(&vb);
> >
> > -               free_pgd_range(tlb, addr, vma->vm_end,
> > -                       floor, next ? next->vm_start : ceiling);
> > +               free_pgd_range(tlb, addr, vma->vm_end, desc->first_pgad=
dr,
> > +                              next ? next->vm_start : desc->last_pgadd=
r);
>=20
> Much better names IMO. Thank you!
>=20
> >                 vma =3D next;
> >         } while (vma);
> >  }
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 6011f62b0a294..9908481452780 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1311,10 +1311,10 @@ void exit_mmap(struct mm_struct *mm)
> >          */
> >         mm_flags_set(MMF_OOM_SKIP, mm);
> >         mmap_write_lock(mm);
> > +       unmap.mm_wr_locked =3D true;
> >         mt_clear_in_rcu(&mm->mm_mt);
> > -       vma_iter_set(&vmi, vma->vm_end);
> > -       free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> > -                     USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, tru=
e);
> > +       vma_iter_set(&vmi, unmap.tree_reset);
> > +       free_pgtables(&tlb, &unmap);
> >         tlb_finish_mmu(&tlb);
> >
> >         /*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index ad64cd9795ef3..ba155a539d160 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -476,16 +476,13 @@ void remove_vma(struct vm_area_struct *vma)
> >  void unmap_region(struct unmap_desc *desc)
> >  {
> >         struct mm_struct *mm =3D desc->first->vm_mm;
> > -       struct ma_state *mas =3D desc->mas;
> >         struct mmu_gather tlb;
> >
> >         tlb_gather_mmu(&tlb, mm);
> >         update_hiwater_rss(mm);
> >         unmap_vmas(&tlb, desc);
> > -       mas_set(mas, desc->tree_reset);
> > -       free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
> > -                     desc->last_pgaddr, desc->tree_max,
> > -                     desc->mm_wr_locked);
> > +       mas_set(desc->mas, desc->tree_reset);
> > +       free_pgtables(&tlb, desc);
> >         tlb_finish_mmu(&tlb);
> >  }
> >
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_i=
nternal.h
> > index d73ad4747d40a..435c5a24480bc 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -892,17 +892,10 @@ static inline void unmap_vmas(struct mmu_gather *=
tlb, struct unmap_desc *unmap)
> >         (void)unmap;
> >  }
> >
> > -static inline void free_pgtables(struct mmu_gather *tlb, struct ma_sta=
te *mas,
> > -                  struct vm_area_struct *vma, unsigned long floor,
> > -                  unsigned long ceiling, unsigned long tree_max,
> > -                  bool mm_wr_locked)
> > +static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_=
desc *desc)
> >  {
> >         (void)tlb;
> > -       (void)mas;
> > -       (void)vma;
> > -       (void)floor;
> > -       (void)ceiling;
> > -       (void)mm_wr_locked;
> > +       (void)desc;
> >  }
> >
> >  static inline void mapping_unmap_writable(struct address_space *)
> > --
> > 2.47.2
> >

