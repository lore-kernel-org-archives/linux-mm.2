Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1B8C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46228E0005; Fri, 29 Aug 2025 05:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6468E0001; Fri, 29 Aug 2025 05:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70268E0005; Fri, 29 Aug 2025 05:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A54AC8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:01:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12BFF1605F4
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:01:32 +0000 (UTC)
X-FDA: 83829201624.24.29F9D1D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id B98A2100016
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:01:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IVDOzIiP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="YNQTVVi/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756458088; a=rsa-sha256;
	cv=pass;
	b=bsbr6sH1D2RSt3l38WMWYqmaaMqRvT0R1B4pupXeHyJn9iU0dzJRIBAyvsRNH2N9SFRJGa
	6Ii7duE/imdTGUSUn3DHUg0Dt/aMkJeS9VjnxysuhwA8gJJudyl/xDJEmPSTtmhEymj8Pi
	qJ/j7XfPqGNc8MiKSIpdiMo4NQNaAq8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IVDOzIiP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="YNQTVVi/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756458088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tw4VdKaOZpoebSqa0WJFQK8tO/6LneB39HFQCBCuBjs=;
	b=MJkOM/Oc0IkThT/cDVZmiKT1S7u3l9cWLSq0n6n6tn8pIPtOYepPWVL9bTv4XrY6IGdbGf
	3LlSc2kote38PPJm20MXndOPybW7G2wPds0GgnZRD+vHLWWg7H1aWBe8Y8CoCVfoQAVwUl
	nJv3oZPTnz2PSk4KW7KdDAY0iThPwcA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57T843oK027562;
	Fri, 29 Aug 2025 09:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Tw4VdKaOZpoebSqa0WJFQK8tO/6LneB39HFQCBCuBjs=; b=
	IVDOzIiPFW7hFhPGW7NqhVIZ0HXVstA0kgU714ij5Ube3CVozbyoYLyfTLiG+cWn
	rfq+gQUYHxfkVUYq4ukE9/WL1WcMUHC8p1ui3hW8g+LLQLX+Mv6huK0qOls0ibmY
	MQK2Qa6ZUbBDGqaQZGGh/DgWT0h+x/uTAew0K9GoPg0/Ic/bbm1GzthY8GQ+ipd0
	fFlR4fhTb3/mR284KJvD1z/CL9W3s9gr5M6XOmkfYFsjqi1tmpeassVOfIUNZha8
	hac424o43U3d2lq1CI68ooebMaiC2BKdyh8bOU2cqRsxyV70MFd8Zh//RwcNz70J
	uOqARSZx7gU+7z791PbtNg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t9ytr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 09:01:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57T7f3gk005012;
	Fri, 29 Aug 2025 09:01:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d191v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 09:01:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDJDaTrIfmAODXH3IF8OS4m/x2rgBwpYCD88UVoqXTNNACu4arxsapZOnRFumsE/2XgSI1wVZyYJEvSQWLVftLs2bquqWiAzzyIoUQfXFhulMq9QcKC08N55F8TXu6wFTkw4kqg10gDWf6YO2YmbsGhBPRVLpKlA0LYEMzsSR5APgtGXW+MaTRIHNN2TjEri1qgEvwWFqD2W3TUP7ova5XQG5szQmPnA9P7GHsvERsHw3zqyCWGkhB3kWqJqVi8Q/efk0fmNLUZB8fF7Efy3pwl4NCsHwB/xbDviu0jeoGTspG3gGhjufxEjNTmABFxX+G223I7OZmbPJezFhviYHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tw4VdKaOZpoebSqa0WJFQK8tO/6LneB39HFQCBCuBjs=;
 b=Wjx9FA4FuELZfUSBOMAVmWt1iJy1BDPqtW/wjN9y37wMY1Hf3nYgsLeRJ/kFnBXTPF3xD2UKpfjnpAlrZDdCqshIdfOfcHp5IcRA6792DQuB4Q4GcZ94lvrZQCNfaUvh138jTxCOwDlSO4zDjB8mbxtKxc60BTItfM+QDyq//BbtHybMFNCHgcv6nCkccwJ8rA9kL3iaFo9vreounnjLyi8NGy+bgnvm97sK3UIPUHgbIsA2DTca9jdTTOy27Ucsu3CplvjlxwVz/e8wOQaV+WHG1qCKHQd6DURDsAo0JMrRgwrPoepuMNh5QUNtgocW51/BgXI+Zu9PnTLbfFD5tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tw4VdKaOZpoebSqa0WJFQK8tO/6LneB39HFQCBCuBjs=;
 b=YNQTVVi/yL+Nn5tXSza50OpVLKumIG0mL9uc4ImF9H0WzcLtCJNX1dYrDSr+9uThlICu1XDYDJbQM3Z0RbWsAIpOTG7T+KbIpcFe7qJsQGl4OxQoJHb7OAqlnRTkS1FV2IENDCzpZtWWwaJdziE3kTjw3uxp7mvoVhaMqkn0SO4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6834.namprd10.prod.outlook.com (2603:10b6:610:14a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Fri, 29 Aug
 2025 09:01:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 09:01:15 +0000
Date: Fri, 29 Aug 2025 10:01:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <f0f9564e-7b4f-4799-b335-55b47fa7bbc3@lucifer.local>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
 <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
 <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0077.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: 805f4c36-d684-40ae-42fd-08dde6da9c3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzlCTXR2a0hwU0FXamhXT3lrV3pqRUxuRW9RS3ljWDVxcEVzc1diU1ZHeTVT?=
 =?utf-8?B?ZmhBMm9RMm1ZdTBFZzFhVENYKytrVTFBS3Y0NHMvRkN6MUs1bFpiTk9LRnJ6?=
 =?utf-8?B?NnJ3anR6Vkh0eXpjSnYyVVRkcFROSWdTZTJuSUFLVUx2OWFIRG9IOWtlSi9r?=
 =?utf-8?B?WWh4eU80cksxK29qZ2YxelZjVXplTVQvMEFqTlJYOUMwL0wxQ1YzcEFjUU9k?=
 =?utf-8?B?UkowVnlsb2QzdVZRRXBvN1pFQm5SOTJRNWFpQ1drcm03T2hKUm1GMFBMK0J3?=
 =?utf-8?B?VmJiKy9xeGhpVzZxR2xQQ3NPaGN6b3kzV3pvUGJLay9lYUNBMHA0YXlWSENa?=
 =?utf-8?B?RWNQR1lId1hmVFlrRkU2QW9qNnFWNHVOSSs2NnRXM3A1Q3lYVEwwekxRcFJa?=
 =?utf-8?B?RDgwRDRkTjNkYS80ZlRKQjk4eDFVREhGUGRIcHlXRm1MQk5ZajZidHkrb2NM?=
 =?utf-8?B?UFYxdSttQU5lTWxFcG9IYWQyNU1VcTRDRFFMOGtyR241UkNrOGVXZS9NcHJ1?=
 =?utf-8?B?amxPWEhldEcvSytJNkFvcjNCZWFway82eFljWnR1V0xRTlNWVm0zVDBXL05R?=
 =?utf-8?B?RzZ3U0hPdHBqd21Sd2pQb1hUQVlCaWNCUDdXM0FsWDNmc2paYzB4K1JkYlBs?=
 =?utf-8?B?U0MvTG9qdERWRmVabGlhZXFKcDhtYXFhUG96YWZNTlkyTTlyVVdoVlpxUXlT?=
 =?utf-8?B?dmNtQmx1Z0ZqZGdFaTIzSUx5Z2Z6bmpuQVRpRmdqa2NyZ01mN2ZyM1BVSWZC?=
 =?utf-8?B?bjA5bVZPaHB1cE1teWR1QUhXVWo5V0R4cnljZUZJMC92T09FWDVJQnhVMU1W?=
 =?utf-8?B?OUcybmF2QkpoTXF0cUlmRjlhUUQ1bi9ZZXN6TXBpR016eE1kOG14ZzhNcWhi?=
 =?utf-8?B?U3hmS1NsTmF0N2VFeE9CY1A2MXhrTWRkUjBMZnZsMG81U3VRaElmaHJOUS8x?=
 =?utf-8?B?UFo5NGM5U0luOUlkT3o4MThFSllQblFENnVVNHhWMnVqVnJITkZFcTMrUXBr?=
 =?utf-8?B?QXRIK1ZoSGVzaUVDdXJMRnhlTDRCM29BalZlZ1N2S295OHpYZVM0aEVzOTl2?=
 =?utf-8?B?Nlo1YnJHTDJyajd4bEFDUUZZS1BVK3Q2UHJLVldHckpZZ0FsU3VtRnFXSjQv?=
 =?utf-8?B?Vnk0dHNPZjNiQk1ZbGw1N0t0QllTdGlBSC9pOGRjVFplZ0F4cWtLdUlKWlhB?=
 =?utf-8?B?aFMwdS9sRFV0ZTlDT3h4TXh1WHRjakd2WWFGRTBqYVBpa2taMkJPWHVhMUNi?=
 =?utf-8?B?V2xwd2ZsY2pZYkJMaGVIMVJZMWNNRlJlVHU3QlNIU1RkWks1WEY2bjhrZCtq?=
 =?utf-8?B?TDg0eHFiSXNXWVlWeno4NnJ5VFJBQnNERHk1MFQyNTNYRHlpYU1veFpnRU5K?=
 =?utf-8?B?NTZDelJSSkJYNk9MK2dlblZ6TndYNmxnYktqTXF2NHEycDQySVp6YzlFazBq?=
 =?utf-8?B?V1lqajVJcTQ1QkZPQ0ZlTkV6SjRKcXlqaEpya2xOSzUzY0ttTEFJaXNHZCtn?=
 =?utf-8?B?enA3djZnVVR0WGhVVm44a2tHVkd2V29pdzZyWDFaMW1uU2hhNjNLOURSd0pH?=
 =?utf-8?B?eW1WWE5EUlhiL1NDM0xtaXREdHRIMXRXck9vTTdadUZSaGNxdWUzS2tsRXNC?=
 =?utf-8?B?QU51cnljaFpvajE5eUNCenVsdnk1NGVRMy9udGJVQVRwZlVxT2R5TVhYZmZE?=
 =?utf-8?B?SHdIZUQyTEtOZ1ArcWgrV2hOcDZBdVBDUXZLUkNXL1N6bUdZVktSWEN4Y00w?=
 =?utf-8?B?T1kxRnZNMlM2YnhrNXZRdzFiUXRLN00vWWh1UmJsMHBPZnNCLytrS2NkLzBO?=
 =?utf-8?B?TTRvTkxmMndhOEE3ZlhYekhIUlpkUnhEUkQvUTR6OHEvR1ZLZDhCL1I3eFZq?=
 =?utf-8?B?eVNiY09mTms3SFUvc1QrYm1vb0JNOVZBYXI3U1Bxckpsc2Qyck1FRUlqYmNa?=
 =?utf-8?Q?leODgzY+Q6w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGxxaUswb3BtYytidURlTDI3bm9uZ0h3bVlvei9DenlRWGF3WGs3WXdZcDl1?=
 =?utf-8?B?QUxnQVUyZ0kzWlpPQTVmZ0N3OGxJTzJvbTc3VXRHNGM2dTdpb2R3NkhiY2xN?=
 =?utf-8?B?bVBpWUttYmdFUHpUa0xETFdaOVlIczFqVXQ0SEgramxuUU43NzZGZUlIUUho?=
 =?utf-8?B?TDkzUWc2YitLcVBHbFBNOUl1L2djdlo2YUxnaUgyNnFjM0ZmWU5PQlVJSlFN?=
 =?utf-8?B?bWxBTHlpK1B0MC9TYndnSUYzT244RHV4TGw3d1phUm1GMjVVeGM1MDNoUzBE?=
 =?utf-8?B?eXp5VUhKa1pRaDBQNFRmQ25TVWhwVE9PYUFBQ0RmcExiYlE4NytBOE1zWGxm?=
 =?utf-8?B?NTYyalpQcll6dlQrS0VWQlVuRUcrMEpBdGdiZzBjMUh2V0sxZEFRN2pCSVdJ?=
 =?utf-8?B?NlZRTkNrUW00M1ZCdGhRMnZXVUJtSGxwclBCK1lzOTF4bGNHdHVMY05TQTU4?=
 =?utf-8?B?VEY1eFZxU2FQQnJwVFg5ekkzZjQ1RE1Ec1dXc2RXQ0hTaWpiNzVmcmZRQjU4?=
 =?utf-8?B?SS9lMTRjeWRvNzh6M25pV0JmK3MybnZOcUhvbUhMeXlJOGM2UXA5SkI5ajJT?=
 =?utf-8?B?NklhdzcxVzVQaFFvOStVWWF3NW5GZDM5V1Z5cm4yLzR6RlV1TTJteUxmSHdZ?=
 =?utf-8?B?RFRiK1BTSVhjRWRtd0ZMNWF1dDllR05PVS9KOXVXZERhZTdTbWpIMXdDRkJQ?=
 =?utf-8?B?UXZEZGpLRjcxUHBHLzVHenRsd0VXOGFPemdMMWoxbUpTMFFKT3EzemNnZ3dm?=
 =?utf-8?B?eU1tdFJHL0NIZklXV2ZvQS81NmhWcytTeitWMXdEUTZIb0RBcmVIeHREOUFr?=
 =?utf-8?B?N2Q3dHRhelJLa090THN3ekNzcUhsaWwrdFZUdmVPMmZyeTRMa1hPVW1qUldE?=
 =?utf-8?B?RTNDNjYrNThZYUhLRk45aUlFY0VHakExVjFlRm44M0EzdEZtcklwYnZVQ0Jm?=
 =?utf-8?B?N0xpUHV6djl2YndsS1lDMk4xczVYMTQ2WnJvNTlZQzdISWJuMXF1R0p0MFhq?=
 =?utf-8?B?SEZVNy9FL0lQQVVtUStMblk3TElqcllzYnRMcjhJZ0NEb2tiSFI1dnQ3blR2?=
 =?utf-8?B?V1pmckxBbVRsMWRaNnhpUUtpYWUxb0l4cUQydkViM3hkc0ErNVlZS2tOQmNz?=
 =?utf-8?B?R0pHRzl4OTZxS2NGVXVkMkJoS0dHekRKYmtQSVhmd3dqMnExbi9uOE5aQi9W?=
 =?utf-8?B?NVpzZXpLNGV5MXMveWlJMGRRQ2dDZEhRNmNVU1FTclBIejE1NngvS2NHbDVI?=
 =?utf-8?B?cjVJS0pvUnVrSWVUOFQzVDRiZSsvSkFTVFFpcHA5QlNzUEFGUlhISVIvUUVF?=
 =?utf-8?B?dEVQYzFjYzJxc2VCU2cwRC94MFFtRGxDdTdlSTE2emxQQUJGMklmY0FFUTFV?=
 =?utf-8?B?c0tFanVaMFZheHVaN1pBV0JBSU9nQ2Nmbm1GaHZwWi9JMVcycndsQ0tJbUh0?=
 =?utf-8?B?V2dtdm9RRnJ5T1orM2tzckhnekluVGZMeWJvVHd2UHR1M3c0ckhFY2I5ZmFx?=
 =?utf-8?B?d05ZUFNPbi9NeWFaeVZsakdrMVFqbDZMcGsrd2ZndE9mYzVUdUI3c3pCMDlC?=
 =?utf-8?B?V3pUa2Q0N0ZmRmQzak5SSkJNdWcrZFVLNGhDcDR3cENRWU5XRTlsZFA3S3ZO?=
 =?utf-8?B?OVVQd08xejNOdEdmSTFLcGs3NHhJVnl1ZkNqYjRucVFiYVlxbS9uQXZjeWI4?=
 =?utf-8?B?cUFNUjZpQnBNYllmR3dQRm95R0lTNmtncUJEK1NpTVhBVTl3RDV1eURtWEZh?=
 =?utf-8?B?bzV5OVo1Zjl6MDh0NjRYYmpkTEhaMVh5RE1NMlZkd2xRMk53d0dlOTUzdnZR?=
 =?utf-8?B?SGxya2ttcUJYVGVSTVdESkt6TUV3akN5WGFNZi8vQmdBMUNuZGU0bWpmNU1R?=
 =?utf-8?B?cUtNWU9RWlRadCswZk94c0ZvWCtOYTNjK3p2Q0dBNFVRN21leDNFMU9JVFI0?=
 =?utf-8?B?MjZ2UW1BbmVoQ2hyNGZLZFo4N2hGTGhpdkRjNHZENzNZWFNsYlNJUGY2cDhn?=
 =?utf-8?B?RXdNN0NDOHRNVlJpWTFyODFyRzFMd3V6cW1kbFZ2M3hhRjFaM3o4dEhERjhh?=
 =?utf-8?B?OHBXaGJDeGFnZTc1YU13NUtXWjQxTVhwMFQzRjlacitjc3R1a1hnNk85aHh0?=
 =?utf-8?B?WjNuVGxzMFRyTitnaU1hVmJpTnFvMXpOL0RoSjRYQmFqYnFKaVdkdHJUOEdN?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E+uv1qHCCzV5VQd7B2KYlKqsRLO64nOf82wP+1uhWanMHnjgEZNQ6NWSx/ERgRg5sbtM0aVxeAdlpJmkQaf8hLjXhPIUjk3U9FdTgB0azjBSCD0azfcxd67ymXbbc79LXpbkzHghwAuMw1GeY3h+YYksP7KQqwCCZEE/4/ChMFoDx7e5My8u7WIA6xr/4wDLgzrH3ILwb1qniHHCqlnT0TnBqvWQPaEK6pGahBWlFhLTTvEJ0vsWnQ4ElBs4N0uubO/JY3TufHhoe58RyLMPcMsyaPRbivrgKsVMT0z/AFqPqSIOqUteWdktaT4SklkpsGhTVfovpFadpRfpqwSUf0KXtDJEsDvTiAZN8SdHofsVSl9oFd2ZyjSgQqPNHGAQC5Um6iO2CBLjnol4ti9YpCvKPutzcP/uMBxFxd56kY83IY4PeF1ErbpAP1U+46rKab693huBFyIuyHnMZYlcAw+DuJjzRZTmnTWtMEObBSE5kVys2H85FafmW2iojtEvuOgawaR2mxBeorDgn/r6LYuXFsP25oyobUssrySixHTwnphoPzdxrWVQ5zrQNuN7YZzLZyrZbpdLiG86tkYfIJMsscEri5KTh4uPIl2Td6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 805f4c36-d684-40ae-42fd-08dde6da9c3d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 09:01:15.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBlzAovpOFU/P1jjt+apDIRm2fU6wIYgW2+wwBNHWbx0I5ATmndG30Jr5OWgJHsZcxdZGLdEQa3iffVoHLibCnRlzK49fYd9IeI6fJOLHGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfXwo3yy8UmM9hE
 SZ67O2jc+sI55G2wMEwhVEfWYRrVNe4/u5QsndEhZ1Q/4NQSdbTsDm/ZIqk4nR26rIb2s6RcY2X
 tSnNLBu06Z5cfrui0rMTH5u/FvmMdNOauxTd+kCZHqPl8MOnnR8dx8/P03WcarRiX3Yo3/+Tb5N
 T6ygL3LI/HPaIdgjQxYU/Pkxxibjve1ypb95VvK0LB0GocNVLUzAaq4PPDrO0O04+t2L8iBroXH
 uSHP0gA20TSo4I2kkN1QVMoeUItCLKhR9wKPpwh1RAuRXrV8ahOCNY4iRrT6ao/o10CDbu7mzWh
 XEWYRv0WRNbksrvLHAViFi75LIcNRt38NbTaQ26ukuBXwtnNkDZliXaO3XmWV+W5WxOFRUW9Lft
 O8rg2ExF
X-Proofpoint-ORIG-GUID: LEYn5cQOC7PZu4a168OQEGconOttaLXm
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b16c65 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=UvikB-AUStXCGdsmodwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: LEYn5cQOC7PZu4a168OQEGconOttaLXm
X-Rspamd-Queue-Id: B98A2100016
X-Stat-Signature: ef7i4af4jmse5qsq5pimfh3k5i1p3o8u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756458088-1339
X-HE-Meta: U2FsdGVkX19y31GCk6vmsGLzDiq7Ty/HnahlRymWazvgWvDuHv5b4vqUNBJPgPotumu/ZCyXtWpMpY4Qs/oYSyB5EHPi/neKOOZxLwkUNKqzjZDUdhBLZsoGs8q/JOlqtpsIVAfotulHVslZWF588lK3uXb2vGG/2lgGn4WLtNRJmaXGQbpcQWLgqwK5i3dUsvO2SPX1LOLLaQGrwInbRJ/bnViGDaTvMz2XIrN8PhWw70WRco514Ba8iYW6WoRr4HIRfpIaetU3E2dOullYi/6/7MCyZWA9pn7Zx+LcV1Mk3HwykvWcvHGuyeiax3aNWLSg4S5kbI/fblZD7jHypcqZ1YUsB6huc3nvjDpBG4Zg5Ff+WOKElIEd8dG6Zkv31thdYfb7zhDvq+2QlX0jAwLQjyIU0ag+sazxGGMHjt2CMZGAwIIsZqcSysSpR1wFNMuZnMYPeE4UgTOsu9oo0b6DyPJvUd4PYKgs8QGgBumfaZJsZYpvu2/rGVDrupFgTb6HqWwD3Fk1C1r7ftcT64x6Yt+DyxBPmHi5HZbS1mS4+YWPlqDT4R2ZD/aPp0Q5eDFndSgcbJNnyBqUY0vs9Rrnc1pfpt0VfanYu0f5mw8V8vEOpMT3LkqgK3ENuusAf+e9be6NR43RsZtiHJ3DKg+zaafscqN1VzIytWYGgUqKG7d00yh6M90J20qXenbz7cOwkfe18G2EPXjrj3cBaGVnqEQkHmxUciIFozdNNZU0M77z59iIhYsYcYtB3LI0QC90XLtAkcFRd1bh/N03Jh2YxRtFQrLVOOUgLm1zD52WA5DbAkaQtL95r6JroPiDb27rn3NjKTlS9yxJlFpYvDjyX2wlUxIayjbjKaK4BNFOb7VjxxXQINyL9rMl6W+lyuOvzOvEyykpVS1KCWNBLMQP8ZJ1vxb+HHVBBPzz4hvEIzMjoWNKdBU90zrtv6xFtpjG/39VcLTTnCETkED
 qR65Xdbd
 Dh+W+kgRk2rlTUKbEziNa7TXCc/cuk7cW6e7JR97VzwiFCYHPCbvyVRPVUopbb/JoIhyFmRy+kYBh84EMXDuspvZ/iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 05:23:56PM -0700, Lokesh Gidra wrote:
> On Thu, Aug 28, 2025 at 5:04 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Mon, Aug 25, 2025 at 05:19:05PM +0200, David Hildenbrand wrote:
> > > On 22.08.25 19:29, Lokesh Gidra wrote:
> > > > Hi all,
> > > >
> > > > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > > > non-ksm anon folios. This necessitates serialization through anon_vma
> > > > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > > > involved in rmap_walk()) are to be updated. This hurts scalability due
> > > > to coarse granularity of the lock. For instance, when multiple threads
> > > > invoke userfaultfd’s MOVE ioctl simultaneously to move distinct pages
> > > > from the same src VMA, they all contend for the corresponding
> > > > anon_vma’s lock. Field traces for arm64 android devices reveal over
> > > > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > > > user interactions.
> > > >
> > > > Among all rmap_walk() callers that don’t lock anon folios,
> > > > folio_referenced() is the most critical (others are
> > > > page_idle_clear_pte_refs(), damon_folio_young(), and
> > > > damon_folio_mkold()). The relevant code in folio_referenced() is:
> > > >
> > > > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> > > >          we_locked = folio_trylock(folio);
> > > >          if (!we_locked)
> > > >                  return 1;
> > > > }
> > > >
> > > > It’s unclear why locking anon_vma exclusively (when updating
> > > > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > > > with folio locked. It’s in the reclaim path, so should not be a
> > > > critical path that necessitates some special treatment, unless I’m
> > > > missing something.
> > > >
> > > > Therefore, I propose simplifying the locking mechanism by ensuring the
> > > > folio is locked before calling rmap_walk().
> > >
> > > Essentially, what you mean is roughly:
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index 34333ae3bd80f..0800e73c0796e 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -1005,7 +1005,7 @@ int folio_referenced(struct folio *folio, int is_locked,
> > >         if (!folio_raw_mapping(folio))
> > >                 return 0;
> > > -       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> > > +       if (!is_locked) {
> > >                 we_locked = folio_trylock(folio);
> > >                 if (!we_locked)
> > >                         return 1;
> > >
> > >
> > > The downside of that change is that ordinary (!ksm) folios will observe being locked
> >
> > Well anon folios, I guess this is what you meant :)
> >
> > > when we are actually only trying to asses if they were referenced.
> > >
> > > Does it matter?
> >
> > Also another downside is we try lock and abort if we fail, so we've made this
> > conditional on that.
> >
> > But surely this is going to impact reclaim performance esp. under heavy memory
> > pressure? It is at least a trylock.
> >
> > It's dangerous waters, and I'd really want some detailed data + analysis to
> > prove the point here, I don't think theorising about it is enough.
> >
> > >
> > > I can only speculate that it might have been very relevant before
> > > 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive").
> > >
> > > Essentially any R/O fault would have resulted in us copying the page, simply because
> > > there is concurrent folio_referenced() happening.
> >
> > Fun.
> >
> > Thing is we now have to consider _every case_ where a contention might cause an
> > issue.
> >
> > One thing I _was_ concerned about was:
> >
> > - uffd move locks folios
> > - now folio_referenced() 'fails' returning 1
> >
> > But case 2 is only in shrink_active_list() which uses this as a boolean...
> >
> > OK so maybe fine for this one.
>
> For shrink_active_list() it seems like doesn't matter what
> folio_referenced() returns unless it's an executable file-backed
> folio.

Yes agreed, was chatting with David I think yesterday (my review load atm makes
remembering when I did stuff harder :P) and was going through the code as a
result and had a closer look and you're right.

So it returning 1 is fine.

> >
> > I really do also hate that any future callers are going to possibly be confused
> > about how this function works, but I guess it was already 'weird' for
> > file-backed/KSM.
>
> Actually, wouldn't the simplification remove the already existing
> confusion, rather than adding to it? :)
> We can then simply say, rmap_walk() expects folio to be locked.

Yeah it does simplify in that sense, the real issue is - will we see contention
in some workloads.

I'm sort of gradually softening on this as we talk... but I feel like we
really need to check this more thoroughly.

>
> >
> > So the issue remains really - folio lock contention as a result of this.
> >
> > It's one thing to theorise, but you may be forgetting something... and then
> > we've changed an absolutely core thing to suit a niche UFFD use case.
>
> I really wish there was a way to avoid this within the UFFD code :( In
> fact, the real pain point is multiple UFFD threads contending for
> write-lock on anon_vma, even when they don't need to serialize among
> themselves.
> >
> > I do wonder if we can identify this case and handle things differently.
> >
> > Perhaps even saying 'try and get the rmap lock, but if there's "too much"
> > contention, grab the folio lock.
>
> Can you please elaborate what you mean? Where do you mean we can
> possibly do something like this?

It's vague hand waving, but generally if we could detect contention then we
could conditionally change how we handle this, perhaps...

>
> UFFD move only works on PageAnonExclusive folios. So, would it help
> (in terms of avoiding contention) if we were to change the condition:
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 568198e9efc2..1638e27347e7 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1006,7 +1006,8 @@ int folio_referenced(struct folio *folio, int is_locked,
>         if (!folio_raw_mapping(folio))
>                 return 0;
>
> -       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> +       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio) ||
> +                          PageAnonExclusive(&folio->page))) {
>                 we_locked = folio_trylock(folio);
>                 if (!we_locked)
>                         return 1;
>
> Obviously, this is opposite of simplification :)
>
> But as we know that shrink_active_list() uses this as a boolean, so do
> we even need to walk rmap for PageAnonExclusive folios? Can't we
> simply do:
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 568198e9efc2..a26523de321f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1006,10 +1006,14 @@ int folio_referenced(struct folio *folio, int is_locked,
>         if (!folio_raw_mapping(folio))
>                 return 0;
>
> -       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> -               we_locked = folio_trylock(folio);
> -               if (!we_locked)
> +       if (!is_locked) {
> +               if (!folio_test_anon(folio) || folio_test_ksm(folio)) {
> +                       we_locked = folio_trylock(folio);
> +                       if (!we_locked)
> +                               return 1;
> +               } else if (PageAnonExclusive(&folio->page)) {
>                         return 1;
> +               }
>         }
>
>         rmap_walk(folio, &rwc);
>
> I'm not at all an expert on this, so pardon my ignorance if this is wrong.

I see David's replied and he _is_ the expert on PAE so will see :)

> >
> > >
> > > Before 09854ba94c6a ("mm: do_wp_page() simplification") that wasn't an issue, but
> > > it would have meant that the write fault would be stuck until folio_referenced()
> > > would be done, which is also suboptimal.
> > >
> > > So likely, avoiding grabbing the folio lock was beneficial.
> > >
> > >
> > > Today, this would only affect R/O pages after fork (PageAnonExclusive not set).
> >
> > Hm probably less of a problem that.
> >
> > >
> > >
> > > Staring at shrink_active_list()->folio_referenced(), we isolate the folio first
> > > (grabbing reference+clearing LRU), so do_wp_page()->wp_can_reuse_anon_folio()
> > > would already refuse to reuse immediately, because it would spot a raised reference.
> > > The folio lock does not make a difference anymore.
> >
> > folio_check_references() we're good with anyway as folio already locked.
> >
> > So obviously shrink_active_list() is the only caller we really care about.
> >
> > That at least reduces this case, but we then have to deal with the fact we're
> > contending this lock elsewhere.
> >
> > >
> > >
> > > Is there any other anon-specific (!ksm) folio locking? Nothing exciting comes to mind,
> > > except maybe some folio splitting or khugepaged that maybe would have to wait.
> > >
> > > But khugepaged would already also fail to isolate these folios, so probably it's not that
> > > relevant anymore ...
> >
> > This is it... there's a lot of possibilities and we need to tread extremely
> > carefully.
> >
> > if we could find a way to make uffd deal with this one way or another (or
> > possibly - detecting heavy anon vma lock contention) maybe that'd be
> > better... but then adding more complexity obv.
> >
> > >
> > > --
> > > Cheers
> > >
> > > David / dhildenb
> > >
> >
> > I mean having said all the above and also in other thread - I am open to being
> > convinced I'm wrong and this is ok.
> >
> > Obviously removing the complicated special case for anon would _in general_ be
> > nice, it's just very sensitive stuff :)
> >
> > Cheers, Lorenzo

