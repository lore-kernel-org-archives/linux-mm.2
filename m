Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09775EC1E8F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709516B0092; Thu,  5 Feb 2026 06:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C09A6B0096; Thu,  5 Feb 2026 06:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5962C6B0098; Thu,  5 Feb 2026 06:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44A946B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:30:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3C6B1A048C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:30:02 +0000 (UTC)
X-FDA: 84410183844.07.270FC37
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id A2B0120007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:29:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KoSQds+4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ciDU3nXx;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770290999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxngm5HMXKqOopgPh20WUVHN+qGnO90Yzk0Ylr1xsGM=;
	b=VvYsz95RX/9HAxIIWAQbaWGyZ4puBWQDXdapu/0rjKoj4HOlZW+KNLa6r8WN9RsxGhimsJ
	uQ+l+7bKQUv3z1BxqeP45vbyLn7eJtt5FvjF0h+TE5ir/6dpSMpP7EOB50w45xE8EuzQ4R
	UCy6aPkfz9PW67x+WNYNWdr5XPzDkz0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KoSQds+4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ciDU3nXx;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770290999; a=rsa-sha256;
	cv=pass;
	b=H8rDJB2mqYoyqrneylszDgCYQO+R3y8WdxgynA7fnGBoX/UtISm0729XiBhM0ojq4gpFC8
	OGfPy1Cjy5NwhDxXmiO236A9QaIQfUhYMc5igoN1k6ccJ8E0oVoUsgSWWAXH7WAYosvm0c
	Lkcl3s6t8D6ImGFk610NaK9uAZsF5EA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614NmNdq2453609;
	Thu, 5 Feb 2026 11:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dxngm5HMXKqOopgPh2
	0WUVHN+qGnO90Yzk0Ylr1xsGM=; b=KoSQds+4KJuQYPl0i+w6CqBob9SfSojQks
	6lDFnEBG3DUqBstBye0rWD9kHUkJKCgWuMFLQn5zbiQMENSTCcVCUoUNMiVA0T2P
	i6i5JML8oturzYeGm8k//NUziUvl5+Z5jglLVS5EuGfGPHe4nZCX+9l4chuhhfh1
	jcaHnVABccC41Ek94RfN9yG2rdDOYOf0Nmy/PS3zUfmz0d4gkaP7Gz8lTzM1N8ZQ
	5GYGwq+60X5eZZPJdsM9ZzXQy72CEWgb7ZnLQ6q4Ul/RAafLnr9Xvf1jmMMT8j0U
	2t3v8nD2mbO/o+1/oQwjTVizWLuw6UbhlZ0lZx+4t9QQYyyZb+wA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1au67jw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 11:29:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6159KiS2025765;
	Thu, 5 Feb 2026 11:29:27 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013036.outbound.protection.outlook.com [40.93.201.36])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c257bncn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 11:29:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VnNybk6Bh6IBbfJ9P08J/jFNcUC79N2pLrQfk3VpxUrSmYLF+TZvUqNLfwRRrObuWcD+JsNs/41jbJWtmS79B3/KL+TFMLVT+xQSCmHhIWc+p+ZFg1UjY/dpt5IHTNPseFZDCJlwkyCNjZxQfE+ILNrcYGbvRYH7qX8Lcs6NG+0cMjqh+DuSgbBYvuwBEf7AegAtR6rQGONshm74lshrgp/42lPLLNWA1+2/ZVgFy4pawOUR0tnHaUMDPHvqir0aWtE9RNaY5jtgX7yvQC4pLEgG1yiwZfT8VE6aLy7bFD+AwJYjG7N/L/ADFYfoBs/g26954j/NgRnH6mtrZ4NMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxngm5HMXKqOopgPh20WUVHN+qGnO90Yzk0Ylr1xsGM=;
 b=maQ2p0PMFOBZ9Zx2UMo21duOmAgrPQhmoh9OjiL7fm0/s4xbSyecAih/N/lO0vYMoxJGO9AWR8wqIOqbB1Z0EvKEoQ4tOiSwFDQw9hDKF81Ep6OQWwmm1VLUHd+JmFBvHpAl+peVH+DkWhPusQAlNNxUfHalHKS7fg5o7V2NOK0g6S1qII6nQzQThsD95Vcs7xkT0lucdNxZZ6g3f+jcxIxMkTSj7jq/v4/+ybIlYF03ef4ZeCn6/7L5Uu2PVBRK5RDL9BUEeMPDQInI5277YOr8dFCWNp3c2cbEU8KSMxUMLE9/kVR+T+HeWs52YfKz7IkszSnVWV1NLIkPOrMx/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxngm5HMXKqOopgPh20WUVHN+qGnO90Yzk0Ylr1xsGM=;
 b=ciDU3nXxT+NeD4553egK5MHTDqclX4hCe5trDKmtvqxfY+XM9mqNWjA8rdRPg3enQGu9KJfQG4eLQCzT+7qQ3OWc3M2jraj6EITL0rgCAgo88sGok4yq4ZQF66xC8v05CwS445+riEnlLiFLcC/VDBTzGuxomm5D/Pt6gSxUssU=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by SA1PR10MB6367.namprd10.prod.outlook.com (2603:10b6:806:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 11:29:04 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Thu, 5 Feb 2026
 11:29:04 +0000
Date: Thu, 5 Feb 2026 11:29:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        kernel-team@android.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
Message-ID: <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
X-ClientProxiedBy: LO2P265CA0092.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::32) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|SA1PR10MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: de4b5f43-56fb-45dc-4ca9-08de64a9c48a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zhkQvLb5hcGpSBodNIVuBvFoMG/IvLMDsj3HYXTYjZd4NiIxmJs5lwWOVRXm?=
 =?us-ascii?Q?LKCueHoINE35tquJzv3tbHh85KYGSBMrdLayRBkB5ZiiR6ZNmxUu4aR2r1Rm?=
 =?us-ascii?Q?Qnzeyg6qySdYJVyXtcctn8CNbYHZEN5mIUso+jwwR91PztBvSyJGoLZ7aWu6?=
 =?us-ascii?Q?qDlcUVmXv/L7GT34cMXZB6qphZc0x7lBBC+nekmM3DkQ4YfHDMtY48JuYeo0?=
 =?us-ascii?Q?lBXCumrylNWvtKWA2KFmVaDHb/AAyqZEtGiYSKaw5b+TGJIj2SF5Y/xqbnQC?=
 =?us-ascii?Q?lw6H23A4E4COY3I+y2Yp2g+/zVywIxR4GI8sbKZkRNzsE2pIUjrDxUKz0JYV?=
 =?us-ascii?Q?y06upfG9iY7cyNCUDAAsWOhi21pUUTW2/6hkUvgRfJrFSAMhIRnFSVPiHoQi?=
 =?us-ascii?Q?lQC6oayGWQSTBEdQ+wG0+9A/ELA1PtfNX9YGDedWqzsvkGt2AsHecJnD/Row?=
 =?us-ascii?Q?kYKcWA5rDBswiI2I5x/g9VTYSUkLrdUEMLP91IWUw0Ly+nbro1Qb+ok6yyY6?=
 =?us-ascii?Q?cc5tp487Itaxyq81PQiw7aTxjvS3uEU0zY0cQku7hGpt/qICRY01rDYyIVBd?=
 =?us-ascii?Q?qy+WkyAHtmawjcu3FcpnRVog7PAMH37xvNOI+Fu5idZHKGbh6+enRIcDEE4S?=
 =?us-ascii?Q?NkV6tnMgOxWfxHUM2IEAI4bpjg7BR6RPQWnEBiDjNV1EnwsBIvsw6hEt5jaA?=
 =?us-ascii?Q?6zTmWI8uFVGev0UzpYj9bJ6QIxFrgxwyQVEyw3rnfnicRqKwPS+KbCFspnIE?=
 =?us-ascii?Q?+1QasXNjeoY85adQ4OOCaK/Zo2Hn7NRdRsk8JRn+U4lzOygnncGCPLspqM5R?=
 =?us-ascii?Q?fq6xLReJWDOwNfcjQp3Ww2t53sVClixUbXoW+tHxqSrzS85Mq8OTvhiDAYUu?=
 =?us-ascii?Q?IHyOs4WSZ/wcRGCqsOexMDkpbuEi+gi0fNPzF9Jbu4KWyWPHHUPak/rLozEc?=
 =?us-ascii?Q?fkMOAaBLAKHvt/D2HhuQ6CHqN+46KzynDKFt7KfsV2mLliJAZvHpNqtYU2SV?=
 =?us-ascii?Q?gIAhvIIyUK+Q6a+aSsnfk0cJCDD+BSgaX+PeQvImNYEVuimUF9d5qyVPIVOm?=
 =?us-ascii?Q?Mq9b3M6kMHvphCXzLVALAK9I30cQ+bgdwPTkn6royC9OW1b2Dsuprmm5ErsU?=
 =?us-ascii?Q?8pEoUn5u8irdbD7atuABuqE/VfNXEuZu2Bt2zSVqsXS4CBaKMpD6S1kfGAA0?=
 =?us-ascii?Q?zo9NtKRRwuoloioESP8y8+PAiXEGwYbe9C9r7ADEkVfDunDCFFb2uQERfrId?=
 =?us-ascii?Q?+1Hl9Gv4AsY0V1E1c+3MTK8wOHPKvRyfbWafu/l2p8KFkFLQUDVupLIIxw0N?=
 =?us-ascii?Q?34EpHk68sCq3maVWC8Zrj7+AtcoxySiUJkIPRA9r4Vk6Y6gqL8P4QkFQTt4A?=
 =?us-ascii?Q?TPmKnxigmXbHJEzVhLyINN+UoonZmzhAU8VSi4e9lhw0eyS6geZljziOviRR?=
 =?us-ascii?Q?TgqqAdNIq8hu5Oyft5t/TUTE4mNUflM0FSRcGKClRNt/hUfcBaKkcupiMtjn?=
 =?us-ascii?Q?XugXiuAy5YhUvEnD3oz0m1KWSuhZzgAJoQbQTZ7kNz5SD9pl7sXZEccx+uHZ?=
 =?us-ascii?Q?H00vPp0XgJJuQn2Vzq8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L8MZVftn1azOSoO9qr9gdDxNozpLsFsJehmQGQKFpo37DTCPlnRqCobBsUUK?=
 =?us-ascii?Q?/CQEqZIqhnRM/84FlYmMzjMAkzGen8dJKCPvUogo9g0RthPBdU7Bf1B61J96?=
 =?us-ascii?Q?Iy2xAnC4uRxvXVcZyQE83kt6h+o5RWB8CPa5r8vggHfrazVuYOwNCaN0sTMh?=
 =?us-ascii?Q?fgCIt74/AunxPoV3etBDuYz7AuVIpAL3rGRt8CCKjaDrZmMockm012wHpK8d?=
 =?us-ascii?Q?08iNXlHPg8YvdO+s+1d0NxGzR3eihRwnnJw6AbIsKP3ZxzHG5hrnYn3pHUMw?=
 =?us-ascii?Q?gJ6G0i5kBHbwM3GNGfiipPvLLvAf4nhCC0oZ6ZUPHpM9oXAVrd8emNmTW2My?=
 =?us-ascii?Q?e2vZ+k7t8QzScVWH2Mblxmfk638yA8pGaSv6ER2Ex+CeH3q8N8Taa16uSGMs?=
 =?us-ascii?Q?Kgq2PhkpJAecc7gju4dZL8yF20eCSKkIUyLA8Ri9kaC1eDujg5cE344QwPZZ?=
 =?us-ascii?Q?0ku/Hesb24HsVhp37fNM2Ro6BfjwUTgNw/6ljBLH1NHEI34wEMPFfYVP+Pwl?=
 =?us-ascii?Q?NbY4STiXaCP+rPqAzBflDrgxjuHPVpQfBOLLpdb2gKruzY+jYPEsr5a+Xwh7?=
 =?us-ascii?Q?uyNaEgzqhwyB6hvmDAMna9JjI7Cc03WsaimMtZyIFfef3D1Z6OiZ/y2z7cZq?=
 =?us-ascii?Q?oyMU8ZXTE+GUKdhq6JAqeumIQRRXiGO8A79+CldcP6UgpbjlV4lKA3o5/Lrk?=
 =?us-ascii?Q?IjmIRqnriYzfQxvCuMxgM6tDXZr+rWZbgreKvsfGKO434vOMSei/CUEBqlZ3?=
 =?us-ascii?Q?uJAfkoaZoMJsUMKv5Z4najBXzIuFq28E31iLnOjlPlFGpLNPo9HOKSaWkxjb?=
 =?us-ascii?Q?68VMW4wDxpsV0ulQS+KXgq21hv6FVDG1D+Qe9k3YVAB6dOg7/QoxVyC1UGAr?=
 =?us-ascii?Q?OthHQ4a9h5zGOONdyqpsPohEECvnOAVHyU+ah3Vk8dASRr+y+ZaFF9YRJ1JE?=
 =?us-ascii?Q?Ox4qrncSBxB97h/+hKohcvY8xD2ReFZhoGnYWvhY2WC/zknEHz1BSYHLNZnI?=
 =?us-ascii?Q?dS6U1MH8gDFaX/RZtxZRlqqN96AcRAnU82aR9hCZB9r/X1bnNsQl3AfZQEy6?=
 =?us-ascii?Q?JxYwhXBfZX4qgoR/oIROJuiTsHeNox2hfHLdFY+YQUaLJCnBWSkFJlpH+dch?=
 =?us-ascii?Q?OTnhZS/MjEwXvvzpH+MQHqcSTOuAgDh4oew1y3wi+ZTPp841fUd2d1v8O5l1?=
 =?us-ascii?Q?/fJpqTlEQcCPr8YrlmrQ2vQoG0fz3AmixYLkzfInCRxPFJ1m0omc5n1v2TMO?=
 =?us-ascii?Q?KzgSpYbVGFnGAL9830eLp7ZOPOv7cSjiV8Fz54zOWKmlWaNc75MyFLec3dso?=
 =?us-ascii?Q?6KR3mdo8gSjx9KEUkRFlYY8YmCJf8qa1tTUQvpGkSZb0drFE1IEetVVK6l5v?=
 =?us-ascii?Q?pBgg+X+o+RwVDOQXy78VmGYo+ku7pKT0OHBmPeO3Gx4D1U1xomz3ViGcT+5d?=
 =?us-ascii?Q?n//FoL1Gi01T5V1D8kTLJ2g5Nn3a1uzcimJamTyd6w47/bfVlC+X7WDBW7kD?=
 =?us-ascii?Q?Rz/qf5rmIvqDDgK0XN4WDs94We/6H+toUJ3lLxXqAegnMY5TyDL2WP4zaMIW?=
 =?us-ascii?Q?QK92w0twYA2KdgEtOKgph1XxAAISXJqNvOoaV4hxfTlU5M9UzprntyeYH4/n?=
 =?us-ascii?Q?5eC4fJwU1hdO8PGnmXtktCearqKk199E1eZ6MGTAtTXdJYwbUsfdtox9z7Vb?=
 =?us-ascii?Q?QgliV6Ytb/phNnVQEhPkZZ05PlvD1KnF6dY/GyLMwoURSQuXacVOjO23702L?=
 =?us-ascii?Q?E5HsyqA9YgrxTJSz9DFb6SazHcjOkxY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7t9JkBVMRqZkYMA6W7kFGtcVbnKu32qetxjLj5VGPZqe53HGY019vzpjmAjDm+QsLfyt4DPyv0Gmb64pYo9vGV0ODdM53Gh82DvzyNhgvJ09bdj/xpywhhFx0iyDq9VLTblD367OptA1mpbGohXAh/QQ+ohPht2N/yRYF3SOe4mUQ6UpkczWCMN3SXV2cOsBqA3WkUXVo7z//yldO+ml9cls/3Syh3lERIC3C15aLLNKlLUkSlpncaAfZuzTo+y9eshu8oBJ+7Gi184ICZpkfBLJaTWadODpCbXBb0Thid1Xa5YiE/RGONYKsSCVa4kKYs3UQmLRVmunOuLhQSfPVaAr221dSbkbv8ONA76WtZdsRahLatooLsYu6fE7IEQB7W2PJ1xbBXg3u0R6Qch0ht/mhZA9DDZrKMbP0RlcQ8r3l6f0bJeV4mYKZvmWnaGghfVPYJ4m3j9iik3n90+yhczFxNDr7eipbGbZue/FCDskUvM/EUUUglGQPP13OU0Jdx2W6+HAK4pjh/B8ChadMiP65b4s6fiQVnAwzZsj4M5PW13sfdX5AYq5oMfPsM4SzC7zK2gM6evY1F6LK3X35GNSWs8y4dEcXuPGRNkbEwk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de4b5f43-56fb-45dc-4ca9-08de64a9c48a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 11:29:04.3993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iv+2Orm3hD2TWG3OzSUGg3N+Fmm/Xb6o4rJxF6zGgP1iesJHJZq2SdiVq0QP40dlxsAb26GH6OT23rytgWZHgnzr0KWpYdLBIpgOtz14ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6367
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=871 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602050085
X-Proofpoint-GUID: BkG4ZHS3iy-bFQBbWlMcnqiCduNJxOOj
X-Proofpoint-ORIG-GUID: BkG4ZHS3iy-bFQBbWlMcnqiCduNJxOOj
X-Authority-Analysis: v=2.4 cv=Nf7rFmD4 c=1 sm=1 tr=0 ts=69847f18 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=7TSvrpMDTLD2ydSLPfQA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA4NCBTYWx0ZWRfX+FD2cFluq6jD
 acUyP4pFCLQOCwbf7/AEHk/3TwrDtjZqMANrv+4msLxXCx0jfd0QBUTIAgqCKYnjCyPpK8+t6nx
 OjS04l4g5hXrcexA4YtBgugA4EnrJMFwrgvAilxTAytd3q09OHK69xhizmsLnn6y/xZGBVefFPU
 QY4+45YMvWJPge2WHUIVfvjwBry4PcoSWXgLO01ghB9YTm3JAXkyaZ87+c9yaKS9LT2+paCMjQ4
 X3JiYyUMs005hLksPmklppuClTUeA4iMrQukbaPbGHMLz0SbAGBQNcNqx60Ifpwf30iGpnNW6TC
 3pKHBbX5A3/QiKEgtRvvtij+ETGAf71ITGQwg+wZP0TwGXuMIg5RbOX8YP2WOxDk/+7smjqYsfs
 +nR2sYuM/Ge8vRzij3pqVDxXv4jxhyWBduwY5PgU2OC05tm7zsv/epuVu41rwF+w2LkM4fz6sHy
 BT2R6v179Z0iNWJxTpVL7zy8tv7EKZaL39AkNUec=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2B0120007
X-Stat-Signature: mhryy3nabzzebewoonwzhref7bxqjhi7
X-Rspam-User: 
X-HE-Tag: 1770290999-66435
X-HE-Meta: U2FsdGVkX18VU902w4po/Uz0d9mgKvYArMXDM9nuCiUJLK+BC1Xi79eMmGSlwpnB0PL7R2wKf4fGg49awutsWJkYDISOUwFqBACfU6dbpBm7HYz8aSL++5QHJpfLJIqRW5kZQ02gm8zwon0zwTD9cMoY5NtAoSAiwSz58KYuLKQU8dWZfUKzZxdxaK7b/Vt9BafYjfFwlZJQmpDPNPRjE/M9Uy4iRTc//2RXO+FoqSQEJsQ6tsFHvuNxWVmPpOp98zg1CZiiXP8OF7Br4f7Rd1o8FFU7mv6SRyhJhiKbqItbybeUhOhnkyO6j7ie8QIa7etRzToYISr3kwhCCSgZBJO8uiN4HbI+uFBhGxH807uidO6hqhIP1BDGUd0B4A5Kd3PKILPQfJH6Ld+4Kbpdnu9321p9AlS+yF1iutXmgSNtPv5hPIVnGsrNSFt2xBSLYEv2ZMWeqTYapp1wJuC9B/CoYZECppC9MfsMgBOJOSt542pAehssS0Ks3tPSVhWephQPfpuoIO45rF92gUA3MOF2mV7rGyY//W2jCCU8ClNJKn9xr7pf7f87KA+NBRzpuiOjyBs41EkiidnaLA1AkS8u2I3ZtmyxFsoUA+gXv1vqXHyKXWMSngMhI3NFPgmPUo3kiouMcbMwwze//uZXnb+XEFVRREyl7ZMCJT5u2FvNF9J9A/Y0u61f1Udax5szoB3w7J3Yiqhnf1VlNCT+uYYLtB/7bgV4KMZ1ZNmY+w94wuzgwXOFGP5kr9jmE7saTkFBKquBLaKrFG1zpGM9eFUJFEUvQuYkSddp2rel9qBPlgz+Abcw/Ht76+le0xLQR6i2iCCm4MyIO14XRDAnLzhPOHs16i7NLKWwARy+hLZBcmEVnTJKSgrpiLjy2rHm4uFwyKg/oCE4hCpjtxZMQiS9QyrqoQx2tNVRZ84/F6LOhnyfZYqE4dkHbKVqwiQVgK44J8cvyJPb/4XgqKF
 0zkgwV1Q
 QK7e6uYv81MkxprXjkij67sqq3ksVuZU+Q6nV/WdXplNYUMpPkZqUlRl9yFFcNfHT5a1+/kHvLF4qluiGP5f8rPXzZJNxpzs5oXbajdaDZ7jLMo5a9Y/Zp4tQwm5uGqC2J5gbtFzLYr00qOFv3ueteHEtjTYus9O26ekvrhNdGW1nNjg+yW2esvq7cVjLapb4Fe+59nSixNrBlCvPhdKv/+KM126EVDVKFkhKMNZxpXxPOdH50yFbkBQzqis5ejRJJf+SARagHb093FL5pK2eEb6wspYRtNkmnMCu8eJ11Nt2CtCq9M51Yav0vDIPfAuXW0CI1qbb0YCib9aWpXTrA/uu+NeB0CaM69iFSMrqLgtxIa15l76xwEy/k2fKaW/0AXZWStC9w+roK6ZI06BmVFaFfcYh6SK+03KG9hCj0K5ZMGNFOw52vHOr1jTgotHbqP2jOEFm/I2NIvmSsPKbuNPvHnqnSMP0tMwF+jdHthlse7hnbkOKZgejQyIygSLr3oSnrLx+qC4w8NEURncJAqnGKlRIXoXOsh5NNS9+pG8HsJpuUCke5x2TlypBhcDT5vMMb1ZYgZ7o/KDnwl+Tv1RrPAOLvmSEJX0M23p5KmlRjg1Q8e8Vm14iuvjO9c8wdxJhEvaKStlAa98ORNcYTkwYrPSWABVoBNLS3Fz7AYMhwYt4niO3fxkMyt9kExnQO3lOIji4HTfbUtVfF9AUpTrI2+USKJljWxjz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 10:51:28AM +0000, Alice Ryhl wrote:
> These are the functions needed by Binder's shrinker.
>
> Binder uses zap_page_range_single in the shrinker path to remove an
> unused page from the mmap'd region. Note that pages are only removed
> from the mmap'd region lazily when shrinker asks for it.
>
> Binder uses list_lru_add/del to keep track of the shrinker lru list, and
> it can't use _obj because the list head is not stored inline in the page
> actually being lru freed, so page_to_nid(virt_to_page(item)) on the list
> head computes the nid of the wrong page.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  mm/list_lru.c | 2 ++
>  mm/memory.c   | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index ec48b5dadf519a5296ac14cda035c067f9e448f8..bf95d73c9815548a19db6345f856cee9baad22e3 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -179,6 +179,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>  	unlock_list_lru(l, false);
>  	return false;
>  }
> +EXPORT_SYMBOL_GPL(list_lru_add);
>
>  bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>  {
> @@ -216,6 +217,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>  	unlock_list_lru(l, false);
>  	return false;
>  }
> +EXPORT_SYMBOL_GPL(list_lru_del);

Same point as before about exporting symbols, but given the _obj variants are
exported already this one is more valid.

>
>  bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
>  {
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
>  	zap_page_range_single_batched(&tlb, vma, address, size, details);
>  	tlb_finish_mmu(&tlb);
>  }
> +EXPORT_SYMBOL(zap_page_range_single);

Sorry but I don't want this exported at all.

This is an internal implementation detail which allows fine-grained control of
behaviour via struct zap_details (which binder doesn't use, of course :)

We either need a wrapper that eliminates this parameter (but then we're adding a
wrapper to this behaviour that is literally for one driver that is _temporarily_
being modularised which is weak justifiction), or use of a function that invokes
it that is currently exported.

Again the general policy with exports is that we really don't want to provide
them at all if we can help it, and if we do, only when it's really justified.

Drivers by nature generally abuse any interfaces provided, we reduce the surface
area of bugs in the kernel by minimising what's available (even via header for
in-tree...)

>
>  /**
>   * zap_vma_ptes - remove ptes mapping the vma
>
> --
> 2.53.0.rc2.204.g2597b5adb4-goog
>

Cheers, Lorenzo

