Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1B6D2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8CC6B0005; Tue, 13 Jan 2026 14:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076406B0089; Tue, 13 Jan 2026 14:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18876B008A; Tue, 13 Jan 2026 14:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA8136B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:15:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FD181A0266
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:15:21 +0000 (UTC)
X-FDA: 84327894042.07.1679D42
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id EAD89A000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:15:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZBOjDyIv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V6R+8P1v;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768331718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cdmw/YAri8tFFTXOA6ezKwBVDHGkNMUk2Wz7RJHC/fI=;
	b=dZzjVAANt6TI3RMeYDpesC5gtHKcE8EvMLP0E5opBwwaPNeNvUC2AsnxNUEq2/SkIuZyzp
	PZsZJjSTAwOwGfKsi8kvbc9ZLrgHKtzDF5u5Dl9F2HzvcLM3g8QVewdaQaqsPZNx5RwvYq
	SBsfIz47fdoAZDe6Emua4N7+hQx392s=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZBOjDyIv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V6R+8P1v;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768331718; a=rsa-sha256;
	cv=pass;
	b=wfJdoErapIuzHmv6CgCQIrd+649+Ip5yeyTuSBEAA52wcO8/VsR8hnfJGQBmc/+bAX75IT
	RzWBwFqs6Gc1RhJTffMecGjPU9Tbnm8S7ZngVlj6KwP2JXDvSpKQ+mTgsYakqIrqtN54XE
	IboMITh/dYTCceeDWqkPyKpjuk21KSw=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DGAXvX2395990;
	Tue, 13 Jan 2026 19:15:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Cdmw/YAri8tFFTXOA6ezKwBVDHGkNMUk2Wz7RJHC/fI=; b=
	ZBOjDyIvTPp4ft0k7UglEIeRPvL2uUIVWYGdDHBokvD58LZiHu2IAe1cJlv9s5XW
	IfDtL91Vm17KfQiw1g6zjHsNJQ95j1zDOjmPQ5At4CwcVx2+fAIZWsPPYuiVoz81
	FlmIZaoq5udBIOMYTBmKshYA2WqebsyqIaiutJqdZW2qskBhB9bQ83lVRcXa97cU
	3kk/DUygzBKflFTjFlk2JuoEnBNfyVW4srZEBFeoTphsJ3I7w0VkY08bdZq+n/qK
	Fq7dEfkZSxj57v3bETMhp3czXndWoyyZaLwqRTvyz6ydWvqqWaIEfWwBZ2l+6CtX
	c/1JFla00qzy9733mQ2EDw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq54181-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:15:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DIXMMf029152;
	Tue, 13 Jan 2026 19:15:00 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010049.outbound.protection.outlook.com [40.93.198.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7jvqey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:14:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRKzS2oR9DrLrdwGslxpqP7NXuCKNzUGNYLdwRxSeqTov6kYf0a7ZSYry3j7A869C5dCBvNDaDnco/WxvbYAmQ2kuJB2A/5M3ntoWTvmbNOGm5moE9fHIjTKPvp1zdB46wvOc2CBfP7wWdnQVmOIsqp6BTHOe/ucgyF2eiI89GDkuq8V+jTUAqlFE5qB26knwEkEOOTTP7ZPzeu0TBWeuda1pQ/mN4CFJnPg/gamZYO4FG+JL8oeHt6jZjCl2GD5z4srARafODsZ7B2Rul5nSX+rV9NDQAFBpDk/NnAqKFO25N2w3/LmTz+Vuhg3LtUZI0B3tPzRjJ2aodXD2+pt0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cdmw/YAri8tFFTXOA6ezKwBVDHGkNMUk2Wz7RJHC/fI=;
 b=DjTcbVYZutAU57ZupoFJZK1Qwg7vBeiXRzqz71va5tgKVRCe/iGaD90IAePvXp+USmxF4yftxJ9FF2Z2LYpP3MYp1bj58Y6ooGShEMstYBg9wu8fIlrhvJOs2Man+mvLQ45jidlowDE9TVFdJqm97gH/uYaz7eKyExI+10mVPWSXIl7SZ++RSkVPPNkBTWh8Q4/oEHuRbQ5/Rbu5qqPOvuBwLPzeUnnxw4hHbnR9q/5fp7hIwXesEDeauw2FipAtJdFF0uKyDa6jkejs3lt6a+Swp6EZ2nNmzTlVYmZsnw6KaIYr34Lyu/fsf12eDRXo3HuRc6OqkgLddzCy1yzilQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cdmw/YAri8tFFTXOA6ezKwBVDHGkNMUk2Wz7RJHC/fI=;
 b=V6R+8P1veauxqGoPNj0H0SEOtkreSZEbabd0NVw+Nk3F36QIkfMMjZWY9y4e15PdqdntFnhOE+Aru8yu89OQ+7DZcbERsWOhnhe4BfU8ajALmdhf+qPRrZyHyf2MhHk4savK+AVWFII3+aqgqTDjg34NNoxE/zJGMplDleutA2s=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BL3PR10MB6211.namprd10.prod.outlook.com (2603:10b6:208:3bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 19:14:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 19:14:55 +0000
Date: Tue, 13 Jan 2026 14:14:51 -0500
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
Subject: Re: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
Message-ID: <slb6zdewxva3echxmflciwv45lgvenc2d2loqqschv2sj7teb5@vkqydhbjhqlw>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-5-Liam.Howlett@oracle.com>
 <CAJuCfpEqVNyYtEabhDc4DqHbgJdYXcMvryvfxmXU8uJGe0FdRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpEqVNyYtEabhDc4DqHbgJdYXcMvryvfxmXU8uJGe0FdRA@mail.gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0091.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BL3PR10MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: 66a77226-8d93-48e8-df2f-08de52d80962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEg3bVphYUF2YmdDbkRXR09uUk5jOENORUNnb2tRSFMwWnpqMGxqNUtXa0ht?=
 =?utf-8?B?Qk5DOGh1Ny9RMHNQdmNJT3d5OG1HdElCSnYvdjUwYnUvbmxYUXRMZkJ5aXBB?=
 =?utf-8?B?Vko1L3QvSFNMamhBZ1pwdlBlUE9LWE5BK05mWTQ0bytoMnB4bkRrSnpJdDdt?=
 =?utf-8?B?Sk1nK05RT2hNSWt3ZmZTa09YMWFCTmM2dlE3Uk1qUEFFRnNvNDJiWFpDNXVQ?=
 =?utf-8?B?NnNyb2NaYm9uUVErOFZ2YkJaazE0TVU2TE1jbXdvdmYzZklnWndIbER6LzhQ?=
 =?utf-8?B?eU0rN0JQcWg2WVZiaDFQK1RvN3JmMS8yckhGanBCQmZiV3RlMjNIREI4bitu?=
 =?utf-8?B?NVI3amMyL0RjT0NrUGlBQmEyNmQrZVFUR3BBWExBQnJ3S1EvenhlZTJmaDNK?=
 =?utf-8?B?eW91L25rZkhHc1V2bVNKNU5uTFdiQ3pSWDlEbzN1RHBtSG02cXZUUElxQUVM?=
 =?utf-8?B?TGJEaStmNndHSkpUVTdnU0JnVnZURng2VXlmNEpzUnBYM1c3NWFHZ2lLbG41?=
 =?utf-8?B?WThzZVpKdHZyR2x2RkE0azNKYno2c3R1UUFSVC9aMXdNMmRTdUhBa2xLUWxX?=
 =?utf-8?B?aG9nNitmK3phTEYyc2ZZVDJSK1V4K0daLzJrOEJjc0RUZ3JjMURIZmlkdWdj?=
 =?utf-8?B?bEdHbWdZTlNYVkNsYWF4dGpBRHYvd1NrWXJNUW5Bak4zWjgwRVpSa01JUkNz?=
 =?utf-8?B?R3FmMnhiNmRpRjBCMVJ1dnE3WFJwVjNJQU8vQm13M0xERmVPNUxuRFI0UGpl?=
 =?utf-8?B?aFJXM1JHS1BrYTQyT0twSVVwUmtXK3U5bWZ3ZEwra1I2OW1pelVYeXI3VDVM?=
 =?utf-8?B?dmdaUEhvSzA2T3g2SVdKalMxWlNodFNqQmhqSTUrSmlFeCtZMU5ucTd5QUwz?=
 =?utf-8?B?QmN3dkFRQ05PWi92UGZJQXpxbFlXREZyM01YV0ZjK2NzWS9sc1NlYUk5eFdu?=
 =?utf-8?B?RFpnNjlicmE2aUEvMTkrd1l4RVByRVN2dy9DWlBXMi8yZHRBeDhxa2NWVUJn?=
 =?utf-8?B?SHBIOVFjV3ZvMWI1N0hjZUtHbFczcGxJYkNqVDFweXo3Qzh0NTVGK3VnWHhR?=
 =?utf-8?B?N0p3b0Y1blRKUGNlcW53a2dCeEVNY1dPT3BDWTNLSDBURlhHRzR4Z21jQUJw?=
 =?utf-8?B?ajMvR2ZJR1JEWXd2ZitFTDFoN1p2NXVWdVVmeG1GM2RCcXpJVmk4Q29oNXVl?=
 =?utf-8?B?RzhJYnU5dFBjbFg3UHBQb1J6dVVRT1FZZ1VscStnYWZMWjhXVDJudlJCWHNO?=
 =?utf-8?B?SUR1VWlKRzFoY0F6QTBOVnFjTFNKb1U3eUFMVXN5WjMzTEJ5OUdpN0xXbXRU?=
 =?utf-8?B?MzNvTjBRZnVWTDBGZEpJbWtQMC9qaG5CUnhBOFVrd1BYeXF2amJ2ZGNJOEhp?=
 =?utf-8?B?Y21aeW4wRUlLVndvZE5ZWWJuZnRUaWpYa2hFVTdYR2ZsU3JCeVRqNkVpUEIx?=
 =?utf-8?B?OWRsUlVveDBZYnlrcU1nenJuWk1IV1pPR1lEYkdsVzRrNTZuUkVlZk1zbVpu?=
 =?utf-8?B?czZ3eU1SMmZLeEJCdjhOeTNkZnZqNkkxSklrUDVHNmR4WkdKaXFDUEZOcWw4?=
 =?utf-8?B?L3FjV2Vqb2NzYkJLb21zQ2lERlY2T2srNzBxNjNGbzFuQktJaUJmMHpITTAx?=
 =?utf-8?B?Mlp2a2VBV2wvZk00aVRHYWJma1AwbW1qTUI5V0RJbEFjbGxuS3Z4ZGxISVdt?=
 =?utf-8?B?YWQwTHNvY1F3RXY1bXlER0VqNmZMVkd1VUNmaUpsZ2NsNk9JcUVRVjY1czFX?=
 =?utf-8?B?VUFSYlQybDFTc0djRHN4akxweGRhejRPN3RJYU1INnhvLzQvU3NzN3NZNVp6?=
 =?utf-8?B?MW44eWZxZ1loZnF2VEdxeTJBWmVqT3NVUW9iNzVBbjl6cElGbVdZMFE3VEdp?=
 =?utf-8?B?ZTFpTFcrVU5rSHllZWYyditCR1p4L254dFFHR0RKU3RnUWZ2WGFDeHBUZkp1?=
 =?utf-8?B?L0ZqRXVwUk1ldEwxNU1aeHEyRXNGd3RYV1crUXRKU3d1TXltSk5mWUI1SjNU?=
 =?utf-8?B?KzNRYTV6UC94MHBCd0t3UjBvL1NwUTNPamFBbjlLM1FkR3ZtMHlYbldRaU96?=
 =?utf-8?Q?M7ooWV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWFBbHRyNWZuZWxpUDRSV3d0dTIvT3FEQjNNZTcvdXhzVWgyWUFJMHk3cUZj?=
 =?utf-8?B?bS81Z2h1NGE4QlJFZFpiNElLOXo4Zml4OFArL0JQRDB0SlAwUVZYbTZRNG9P?=
 =?utf-8?B?OUZSQ2hOd21ZOFlmaDNuQ0ZyM2RqZm5RMVUzc0hmY1RFMGVCeERBMEZ2RWJz?=
 =?utf-8?B?L2xmbUFUSkk4cXg3UnVBMlRFSys0c1ZkWUtQRU13SlB3cGlTcUZCUjRtQUFV?=
 =?utf-8?B?MkpFNTEwTm1TRVdyRXRNbjR0QmV1NGgzRW5iUTBaOXZ2WmF0S2Q4MTcranFj?=
 =?utf-8?B?WnVMNDBVRUo3RGZJSll2MDJ4WnJCa2gzL0lOSlQxVXUzamRmbU1vOVRoaUJn?=
 =?utf-8?B?NWJnT1NZRnFieTA1L0kvV1libGFjc1FqM2xraHRrMWNFU0wzN1o3U0ttbHhF?=
 =?utf-8?B?L0xtRVFWRTd4U0c5ODB6REtnUkF5NzBQeXpRamFBRDFwUnMyUWZXdU40VXJZ?=
 =?utf-8?B?TWRsNjZZL2NPNVBrUkdUQzRxclhmbUptVzlydXdIeU1CTkNvU05IdmhrbjB1?=
 =?utf-8?B?eXFmajVXei85M3gzZ2xvcGFQWUxQMkhncUM1Qnl5RkFPTE1lM01acUZCNWZa?=
 =?utf-8?B?cFI1TU05ei8rRFhOaW1iNG5EMkVIKzBEY3h4OGlKM2ovc1NNdm5PempXZzcy?=
 =?utf-8?B?NVBDNVFQR2t5eVNjRkp0QUd5Y3QyNkFHUUU0N1hZRFJsWXdnUWdTSHFRRnhh?=
 =?utf-8?B?TURxQmRXd1NsSVFqdG82RXBsR1RkUjh3MnA4M0JvMWlHbFB1Z1BxTERvQUFo?=
 =?utf-8?B?UWh2bXhEYjQwNE9GdVNxeUQvVWdlWC82MTE0OHVONGkrZmNZTUl5SVVpU2lP?=
 =?utf-8?B?RnpHTy9uZG1kUG9PLzFpaEdPQktPL0ZXQ0xLUGUzODUwQWdPSm1YL3RjZSsr?=
 =?utf-8?B?ZXBEVkt3L2EwYnJMMXM1Q3VpTnM5WVAwa2lZSVdPYkVjQ3BBb21qNVhDaFNW?=
 =?utf-8?B?L051YTFWbUNkb0NlZTVXTW1tdW5QYVU0SlcrcXBTR0dpQU8rRnJzbFVMNUtu?=
 =?utf-8?B?RU1qbXExTUhBak51dkFsVkRYNWlPVE1IMVgybG5oejZURm5pMW5mY0pRbHJ0?=
 =?utf-8?B?eUFoOGNnMHFVcnRLT1IwTm8xOFdsOHZ2MDV5N3NOMW1aeDJ2QVl0RWI3QXVi?=
 =?utf-8?B?aUNvWnpIWldiTFdJZjloeWFCZkJvdnZJeW5LTHQ1UG9ZOWRFWEU4ZXpDRE1j?=
 =?utf-8?B?L3V4d2FIVDhJSXNJY1JCb09oRGhmODJaY2xaMkk1VFhvSFBlTGd6OHNscmJx?=
 =?utf-8?B?S244TWhBK3J4NTFYZGJib3grblhOOHZLd2JlS2lPWHhmdnhwVmVMVFRSeVV1?=
 =?utf-8?B?M09FbGNKT0czRXlSa1B0cGtpNVUzdVlwcFBJclF4UGVQOWx4bXNZYVRHWGNj?=
 =?utf-8?B?QnJqYUxMaE0yTFROWlVncFc4aWlmUEN5d3NwRzA5VE9lMFByYTQ5Y3JnaEt4?=
 =?utf-8?B?Q3lnTVVUR05RSk50TGxtTlFXV3hWTktGb1BiZDlSQzlMNnJkQURBd1VLOHQr?=
 =?utf-8?B?bFJWUGM1bW90MW9idCsvOFQ1RlFJQjFqVFZtM0pUMkQyNlVHVXVMeFM4d2th?=
 =?utf-8?B?SlIyY04xZWVvM3ZRRFpOd3lQZ3pxT1RHd08veVNLT0hsYTl2Zy84Rmxlc0VG?=
 =?utf-8?B?dFRtQVNLMzBmMDAzWFRqcUp5NHptd2ZEc3VkRldtcktubnQvTCtMS2NTb0Zk?=
 =?utf-8?B?cDhYNVVnMGhvNXhwUXZlWW1DcDY1UEp3YzlVK2lHZktzK3RSRlVSV2JWaEJC?=
 =?utf-8?B?Y21lUzQ1U1YvZVprc1hPNko1QVh2RVBsd2Zjb1NZQk9yVGNHcUZCZWFVZExa?=
 =?utf-8?B?dHhpajk1ZGpHZnFCeW5xYVM4d0xFdWZZaWpUMU5lTGxvYW4wekdyYUwxbUdD?=
 =?utf-8?B?dlI1SFNESDZtL01Lc2UxWFdwa3lGY1ROVTE5QUFMdXk5Ny9PK2xIQ0tiOXFv?=
 =?utf-8?B?eXlVVi9tRFVrNnFLR1lIemZKQjNDakUvWWl6Yk5DR3lJZmZDM2RQZTNpMm9V?=
 =?utf-8?B?TmxWbEVqQVp4OUtvN1BnVEs4QVR6OUE1anp4ajJrZCtZZGpkT1RBSG80TVZk?=
 =?utf-8?B?UkdZVDFsR3lxM1VQQ2VaMVI0M0cvRUgzN2xMRFVFbmNNSkMvcVVYQ05PQjhM?=
 =?utf-8?B?ZVEzTjZjdU9NQ1l0ajJIdktCNHRNZGFrTW1aY0lzZTY2cVFqOVFoNjBMamlw?=
 =?utf-8?B?VFhBcGJBNHU4NkxNOU1VQUhCV2pnQ0FtcThQdkRZbS9UNmRGVVNtN2owQzY2?=
 =?utf-8?B?SHNFYm8vSTE1NXNsb1VzRTdEbXI5azUzMGk0NCtaQUEzUit5dmhOZXk1eTZZ?=
 =?utf-8?B?UUFaaVNVMDQ5RXEvSzdOMk9EWnVZelRrT3pGTlF5Sy9JNjdOcGN6UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7Yzz3j+uJB2q5Q6eYZz1XfwXK/cCG30v7pfw7/a762axSGb/9kN2mJBdgYRx6ha4SthHRZv3BKT4+hNcmXsLCil80lQSp5nAM4E9Za8WZhlxXnKXtUfdlOkjouqAx0yzbxR8gYlOxghAI9AfsIN8H03nWiuP0awi08UUR3bbHK3crlivpAgQv+VIYk9s9khI/K1v8JcdlK4f56jw3pqAlVDMD0+7jrwc1cGBQpAjrbpb2DY6JNsBmkZ6nqA2P9agcw5kmmAdGeopeAudm2a4Y/3RL8RqIfBabAeBzxKxJlcqqU/r1HZ49Dv7wLF6TJivu9uqXfThzry6q+MDAh3VpOIUzQFA8OoCNZRK0WQE4BRRVzcwejGjd9hTH114JMf8sP3t59M622twQ7TaPoecPGBNfBCT3rBk5dzFmP8bCE7vJt+q1LzzFG3MyAgheEMXxSXDtaJ8QTBJ6OWnz81x+1DvvhgHrTNaI/zxn7B24QBI1OiDu9UpRXWE/RU1XPDd0oxN67glwkAdHJiBCDdm5HLT990/BwXN/bV+tirsC2r67A698j17hOIQKxuiFnW/IVXUtc+TrjfdCVBpem5Ny+yjhq0S7kPf26I6gl8V/tI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a77226-8d93-48e8-df2f-08de52d80962
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 19:14:55.8177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxLNCd4iYehHdasdOwMIXZtU6bypX4DeCLtbArms7g9gxWsKF7NP8zB0r6FEF84ULPUM76kk+FdB0/1CgEL2Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601130160
X-Proofpoint-ORIG-GUID: GzKBir8u4pRY3fi4vXqe3YQFilvnBLt9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2MCBTYWx0ZWRfX6QjQVAhnga9S
 55BNoWFW7v04TJiwuw+nmYh8ar3zmQxZ6tWsxaBy8JZazql/0Ynx1c+PgM1j5UNyQ/tegKfrKPI
 GMlZ2UF4LxSIPlVZXpGim8+mV7HxHsP839YYV86yY8/qALh3hmu+P7wxdFBYgywr3gyrr6ogZUL
 JROvCeOD1jlq1FIcc5Egd0FRLsMJxHmJLBWVZHBtBPoUa1sxn2YlR7HIXDznY6V5Rv0bOwrNLM/
 jI0z/ow79XoRWTi50150BYf6MtYFp03TSLMCFd4kQTs+O+eO9eVVaDlcwSUYrrPl+WP7jpYcwuK
 M2bHtcbR1UeZnoZZldWh/H1cSIg/kNQ9WlIIXdATAlHfeILRFsgGACStkhvVeCIAy3hebei7ehw
 qq5ap5BO5ov6Y8PyyC4DT9ZH21SKm1Tpwr/dn5AtadpOxV4zXq7fOPmIFwBjP2CKuuhqj3KNp5m
 OlbOXtdhmaHBLKEHOvwMWjbfkaeFAiDLzct95AYw=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=696699b5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=q7Kl1mY7HeVpexYSZQgA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Proofpoint-GUID: GzKBir8u4pRY3fi4vXqe3YQFilvnBLt9
X-Stat-Signature: oeyqmcwbor5chewznfsnsyecw8m3cbpk
X-Rspam-User: 
X-Rspamd-Queue-Id: EAD89A000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768331717-977835
X-HE-Meta: U2FsdGVkX1/tJcuYR4ck5NVHPr9Fpv6J/PsGtaUUNeeSodXXFhjvUaU7NdBGuVqmth26akieHyMMBLP/MNzRwIYmaTpnhlpfdLdwZE9fdV7gtTL0G0vt9PAkpGpBPbxXnQZ2piruow5XmNfgtg+cA4L+0WgEjJzeJxMykiroDw3JNpHN4i45S8AhtBIruOpeeISJmtXZ1rhtKNE+EFqbC+GMLm3NXlWWOC+f3+/lHjOJEv8NdAq3BwFkxDVQyuZmoHf/R7Z2pOWzRro3WUnH/HvbjL9USQSAerMpox2lBHBHHwUopUYHD8v0ZXrtZCFU+jXx8jkRFnSMSar2mmlhzDWBgPEIWUTOmAXDiSPEwfoqODBq8expGUXR+rmh+07ZhNnuLBf6iRHW4WRszx85ykIMNfXt4KQTUisaaNRCcmyx0Cuxh0j28Xx3WKxOzXz6UkC+5gntpQFHWNZIfaNkXGKNA0yAmLqWx4gmyHSf/DuiJeCsYpkNmWg0MlcQAGoHGFQoYB8J0bXtaaBfoPYfFcNYLDvck3DLeVoQidA1M6IYmVFOdbhp3OFren7dRr+WAjTLzFGZO8GJuIuc43BkH8NzkBmf0gDkjO88fSU2zgNj1cdRkxzA0+PjhtO8Em2mb2WKsmWHB6ZOhhGeuII027OpYMJGyQ7dlY0xBnaecjkQI34Yw4MB1dyBgywgsNZsUcAnsXuET0DOpMXUIYJPJwEANNHLFxHCXi2h1zqURFY5FZaiKTIl5BUDvpHxYX5JGs3+/6VAknBbaCqFLheVYrXp9VpHn74Z/ccOjHzgHiurN/dkcQq7JFW0g9SumvvOcEAJ4RCLCwO+gsXcAtdUrvELVi9fHUlWVv4mHgapIXtuxINHeb35m8VF1HtP7SKas99NXUMs39NMyPm2amyWilMvwbndd/zbVeL02XxIdW5M8kExE8mzLGMdNt8L2XzfN6S2lwjivqMYYI6I169
 8BUaqClL
 JRfWkBlDguC2/ETIeahsrokS7AkGvg7Pa+p6vPlEAIMx8a66jGimsDBBJx5dVM/D+8UMhwxORWEw2+r3fo+p/VLrONK+NAo9uPGZQgN6so6qQ9BzTi1qDWhNxidAlVzFrDMS+22ZEuLDDGHYoEz2v+M157VmuGJM7nX661Hyk6d9B59wCw0S1Et3jN1r+tvOXvDe1vgbmSjoOzaK1JQShzps8aWFcG+adUliEpLL52HrQ08cNa+L8QXBENU7HbVj+5QFXSDNqMKlWNR68ees4NU93gchZB9+xb3ukNEbIrLyKROlbXgdUf1UhBnAV9FcBDOagNu4Il3CAgTfqyTZPodejVlvHnWgFccR7sXsTDYq6Gz3jES93cv/e+Gxxx2wyl/A5uq2sj34XxoO3j9gsu6rWbxnPOj1DHXCgqFIylJYc7K0xibKLEmjx4XIR8HsKOsB0U5V19ZELf29paRePQbT/jQHVI6I1Ai7sdWNrIto6cXmJhxzs/mgYucpDFU1O6DWxJW0zJtyNHZlML35EB94PGzAwIQQbwikl+yQjIadd5uJ9wEbFgchzqas/AbXsx4F/253z6deo8thplx+nRWCStUKEKrHDY1FxpKXSDdL/M0H9K8G8OSudlS10UoVlAWUVMzcglBtrTk0mrWEfNKR8Q24MUDWMo+/1pJLZD72cXmWCJymEYnBEer1sZabWSKXwFWSJtRfDXzRdUjuxncVsjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250909 17:06]:
> On Tue, Sep 9, 2025 at 12:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > The ceiling and tree search limit need to be different arguments for th=
e
> > future change in the failed fork attempt.
> >
> > Add some documentation around free_pgtables() and the limits in an
> > attempt to clarify the floor and ceiling use as well as the new
> > tree_max.
> >
> > Test code also updated.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >  mm/internal.h                    |  4 +++-
> >  mm/memory.c                      | 28 +++++++++++++++++++++++++---
> >  mm/mmap.c                        |  2 +-
> >  mm/vma.c                         |  3 ++-
> >  tools/testing/vma/vma_internal.h |  3 ++-
> >  5 files changed, 33 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 63e3ec8d63be7..d295252407fee 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
> >
> >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >                    struct vm_area_struct *start_vma, unsigned long floo=
r,
> > -                  unsigned long ceiling, bool mm_wr_locked);
> > +                  unsigned long ceiling, unsigned long tree_max,
> > +                  bool mm_wr_locked);
> > +
> >  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
> >
> >  struct zap_details;
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 3e0404bd57a02..24716b3713f66 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -369,12 +369,34 @@ void free_pgd_range(struct mmu_gather *tlb,
> >         } while (pgd++, addr =3D next, addr !=3D end);
> >  }
> >
> > +/*
> > + * free_pgtables() - Free a range of page tables
> > + * @tlb: The mmu gather
> > + * @mas: The maple state
> > + * @vma: The first vma
> > + * @floor: The lowest page table address
> > + * @ceiling: The highest page table address
> > + * @tree_max: The highest tree search address
> > + * @mm_wr_locked: boolean indicating if the mm is write locked
> > + *
> > + * Note: Floor and ceiling are provided to indicate the absolute range=
 of the
> > + * page tables that should be removed.  This can differ from the vma m=
appings on
> > + * some archs that may have mappings that need to be removed outside t=
he vmas.
> > + * Note that the prev->vm_end and next->vm_start are often used.
> > + *
> > + * The tree_max differs from the ceiling when a dup_mmap() failed and =
the tree
> > + * has unrelated data to the mm_struct being torn down.
> > + */
> >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >                    struct vm_area_struct *vma, unsigned long floor,
> > -                  unsigned long ceiling, bool mm_wr_locked)
> > +                  unsigned long ceiling, unsigned long tree_max,
> > +                  bool mm_wr_locked)
> >  {
> >         struct unlink_vma_file_batch vb;
> >
> > +       /* underflow can happen and is fine */
>=20
> This comment is a bit confusing... I think the below check covers 2 cases=
:
> 1. if ceiling =3D=3D 0 then tree_max can be anything;
> 2. if ceiling > 0 then tree_max <=3D ceiling;
> Is that what you intended? If so, maybe amend the comments for the
> free_pgtables() function explaining this more explicitly?

I intended for ceiling to always be larger or equal to tree_max, after
underflow.  That does hold true for what you wrote above.

>=20
> > +       WARN_ON_ONCE(tree_max - 1 > ceiling - 1);
>=20
> I would prefer WARN_ON_ONCE(ceiling && tree_max > ceiling); as more
> descriptive but that might be just me.

Interesting.  I wrote it this way to show that the underflow is possible
and since we use tree_max - 1 below, so I thought it more descriptive to
write it as is (and the comment says it's okay to underflow so don't
"fix" that issue).

>=20
> > +
> >         tlb_free_vmas(tlb);
> >
> >         do {
> > @@ -385,7 +407,7 @@ void free_pgtables(struct mmu_gather *tlb, struct m=
a_state *mas,
> >                  * Note: USER_PGTABLES_CEILING may be passed as ceiling=
 and may
>=20
> You replaced ceiling with tree_max, so the above comment needs to be
> updated as well.
>=20

Yes, thanks.

> >                  * be 0.  This will underflow and is okay.
> >                  */
> > -               next =3D mas_find(mas, ceiling - 1);
> > +               next =3D mas_find(mas, tree_max - 1);
> >                 if (unlikely(xa_is_zero(next)))
> >                         next =3D NULL;
> >
> > @@ -405,7 +427,7 @@ void free_pgtables(struct mmu_gather *tlb, struct m=
a_state *mas,
> >                  */
> >                 while (next && next->vm_start <=3D vma->vm_end + PMD_SI=
ZE) {
> >                         vma =3D next;
> > -                       next =3D mas_find(mas, ceiling - 1);
> > +                       next =3D mas_find(mas, tree_max - 1);
> >                         if (unlikely(xa_is_zero(next)))
> >                                 next =3D NULL;
> >                         if (mm_wr_locked)
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index a290448a53bb2..0f4808f135fe6 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
> >         mt_clear_in_rcu(&mm->mm_mt);
> >         vma_iter_set(&vmi, vma->vm_end);
> >         free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> > -                     USER_PGTABLES_CEILING, true);
> > +                     USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, tru=
e);
> >         tlb_finish_mmu(&tlb);
> >
> >         /*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index a648e0555c873..1bae142bbc0f1 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_a=
rea_struct *vma,
> >                    /* mm_wr_locked =3D */ true);
> >         mas_set(mas, vma->vm_end);
> >         free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_=
ADDRESS,
> > +                     next ? next->vm_start : USER_PGTABLES_CEILING,
> >                       next ? next->vm_start : USER_PGTABLES_CEILING,
> >                       /* mm_wr_locked =3D */ true);
> >         tlb_finish_mmu(&tlb);
> > @@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munm=
ap_struct *vms,
> >         mas_set(mas_detach, 1);
> >         /* start and end may be different if there is no prev or next v=
ma. */
> >         free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> > -                     vms->unmap_end, mm_wr_locked);
> > +                     vms->unmap_end, vms->unmap_end, mm_wr_locked);
> >         tlb_finish_mmu(&tlb);
> >         vms->clear_ptes =3D false;
> >  }
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_i=
nternal.h
> > index 07167446dcf42..823d379e1fac2 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -900,7 +900,8 @@ static inline void unmap_vmas(struct mmu_gather *tl=
b, struct ma_state *mas,
> >
> >  static inline void free_pgtables(struct mmu_gather *tlb, struct ma_sta=
te *mas,
> >                    struct vm_area_struct *vma, unsigned long floor,
> > -                  unsigned long ceiling, bool mm_wr_locked)
> > +                  unsigned long ceiling, unsigned long tree_max,
> > +                  bool mm_wr_locked)
> >  {
> >         (void)tlb;
> >         (void)mas;
> > --
> > 2.47.2
> >

