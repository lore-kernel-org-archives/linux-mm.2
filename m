Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BA8C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4449C6B00F5; Mon, 11 Aug 2025 09:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5436B00F6; Mon, 11 Aug 2025 09:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295E46B00F8; Mon, 11 Aug 2025 09:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155996B00F5
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:09:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3618140197
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:09:04 +0000 (UTC)
X-FDA: 83764507008.11.6475B79
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4630B140009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:09:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qdof0B0U;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hf7YgCc1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754917741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CoyeuGHRJhsJ1Vse0Tqok+SkXFDvMG6bnSXWtzPFAmI=;
	b=WtRsNQDKg4j5qgPD1aBmEIR8BTya/WMpvImZ9kj/+ZL5KlTN3/kUAxR8/nDMCBr3oLmQ6B
	Onag0oFncm0U6pDbf2KJroKn7Ii38Yd2pc3nJw+7FMwrutLoc6MOL28iUqUWFUvBD22Kih
	DsoUeHDYPo9MaCNIx8uxPvRHQLWJ8Dg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754917741; a=rsa-sha256;
	cv=fail;
	b=qcShqX0CNXkQnWrUXYijIRYCeptSgFsQsmWYFjUIRu03FWKEietQfUUFCqX5wzNoriOILw
	NmlIEKdOb45/obD0NzKfP7TVDEWbtpauUnGgtKaUDdxMSwQoLYlVdLAxEOsJl5xvZ5NjbA
	x3Jdw87w1q09Tnzn1XhHNuye58fd3eg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qdof0B0U;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hf7YgCc1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B5uAdg023535;
	Mon, 11 Aug 2025 13:08:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CoyeuGHRJhsJ1Vse0Tqok+SkXFDvMG6bnSXWtzPFAmI=; b=
	Qdof0B0UIdonHC3cviAISUu3XMLOJchb5pNkatnDKkYHjtciZ1m2kp20HbcNWS1Z
	J/zDkcE7c3MoBczj65vE6a87YkLI0MRqxlJ9Eja41GfZmFqXxNDFfxgzB0rvlvA1
	BYGsDnAXQFMUrh+v+/dRmVP1uIAeJNxJ+1kNTBl0899hj1wftIYob8IPeorvnvfd
	7zJ2C877BkKz7LrKTAxwkpGagttDUmI5ReojHVhs/mIEn9H6uwpFz4zZ5ul8uIjG
	SAdohJ6TI5Yr8r1nSpnr1bIUYUUId/r7eFN5CeP0AqqVLogk67k9bbA1DvMfeYwo
	wL/cw8yWA1spHsomUstA1w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxvwte26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 13:08:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BD57Xi009928;
	Mon, 11 Aug 2025 13:08:43 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012035.outbound.protection.outlook.com [40.93.200.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsew3jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 13:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBhLDYm/gT1wyDm+fN5uHgPdeB6uMqnXerdKDzBGzP+UoRhcrD/uyT5tfyr/maX7IwrEmonb8dhmxTpLWSjScM6lEOjB/c8POs23gTg6n7s3LAociJEY5eNlYpyOyE1qj8DojP2V0ds24NXL938kHxJdW1296gcmdE5J5XyJFVf7+LLo4kc02pH+H+oqh5LfX8KxxMoF5KZzQ7QVROr7TuqiSJF9nlNGDFnICZO7jxfWyoeyFAcntlscpB+5BfsN4xJHIpUC3ARYiZVl9u6o8ZovVbtaaw6daoe0Cg1MRUbQZ8fxh71pm6VecS9v0bx0ZbEqJ6SSZaVhFX8aTy4wIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjbrUYucjdtZmcr6zu03w+nRyLou0g1OMpVWfZcUTL4=;
 b=nhwKyaIfY8KQYFPEPLTOA6yydOa4CQ7lX/16hWvdHXvD3cF/bagTM1Euz9NbxtXHp32m+01enCKjqghJmUTf+8zaMxxiaYwA1djgxypeoYAx1a8CCbieoizUqcgwdUJ8nNG8iMUTokwEzUvnlimp9HK0LYkVuSxEOuabc8D3xgyxrCwYIH31SDAHrvIsy0luYP7O2gl83lU8cWNNjey+r2cswsL4FeAcZIExX64DpDaY2yB0YA2ISmOk5MVIfnC3IoXiYcwm3//69cUQsuZvXfmw/AToZwFq5CM/OwaTjyvnplkDVb6LG1mAKAizLqT7hpKASqv23gYpRssBaW9jag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjbrUYucjdtZmcr6zu03w+nRyLou0g1OMpVWfZcUTL4=;
 b=hf7YgCc1X0WJWBMjAD9qg0thUR1EYA7123BrrgiNVagORpF5Vqfh6+dALH+3XJ7Ku6jC66BoPL5VJIq4K9RnlmXxWF2FRkgPVIOokHHtqg9h+WxxYt9shmejkb7EOp4gn/jjVm7YdAunQYVlN/i3g5VKga8jrB7RlngtWA/zZ9w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB7533.namprd10.prod.outlook.com (2603:10b6:610:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 13:08:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 13:08:38 +0000
Date: Mon, 11 Aug 2025 14:08:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
Message-ID: <904f85d0-acd6-4f47-ab45-fbf18b80f1c6@lucifer.local>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
 <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
 <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
 <29e080fd-5f9a-4760-876a-a6ccef33129f@quicinc.com>
 <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
 <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
X-ClientProxiedBy: MM0P280CA0100.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: c4d0f01f-f9c4-4713-50e8-08ddd8d83003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?8dCWRWcj+NpvXca8QxZnfwm3UHnmVmC4X6B1BZ6sRqV3g4jZ4d10eT7rEr?=
 =?iso-8859-1?Q?AkiSXwsBwA6P/FSGhe55wSA9hT727HXFiInpDLbe0vH3DQ+80nfVjp2SXH?=
 =?iso-8859-1?Q?mnvaAwnTrZijrVpJ7Z8AS6KuRb9Amlj1Edvh3Mxq2AYC1hLzTaohB7+n5W?=
 =?iso-8859-1?Q?FMZE1kHC+/fJQQKiLFGfkYjUT/JfxufpLf1x0ieCaQFqkqY7O6GDNKKjX+?=
 =?iso-8859-1?Q?1eg5G/YXZ57m3PWuO+Z1CkYjjjTW0mzCqrLJ9Ld0uxb4WmklTp+X4cZZ+U?=
 =?iso-8859-1?Q?cqQ+xY8yNAjcC9i1juoLQZK0/r5pN+hDr4vbIiEYAiHemFexrsjDKPr5fn?=
 =?iso-8859-1?Q?9FWdpsNV7b0EDasSE23jXmmoPe3yKNXbxcTGH0hNY+JrTo93p/xIOImCuI?=
 =?iso-8859-1?Q?eu0jXqh9rzy1YNpLLMwNk/cKAWEGx7sqWHLb71/6ORWRhtf0nokiU5qYag?=
 =?iso-8859-1?Q?IWCr62oxsKRx1SLENtVIXZCF6GHefUxqdPUbouqQ8ipeuGjgYQNpYgBq6P?=
 =?iso-8859-1?Q?zIek9qzP8WWMqhL6Lx7g8skxBZ+OGD7EIuChvrJ4fjAGFTFPSpnVfha6Oh?=
 =?iso-8859-1?Q?AvHI5czf8t8nwXTz5QtnURfzuqmzxuqh9Ba9Ccnw0szZwCwhfwmi0monqU?=
 =?iso-8859-1?Q?YRlSF6w/Bhc7/fp6ae+ERYv/Gi2uC4Ox8SYUo8H/WGSPCuEMDYQpsD6VXT?=
 =?iso-8859-1?Q?cRJY5pzAhtxMzvIhOhCu+aB3599ZPZ+UqFpCscQJIOHyR/Emvc/S5FdBeP?=
 =?iso-8859-1?Q?xycCKG8vU0HqlwqI0DveEbuPtB6BsY2NIJE3xg2KWC9WknBjkGoUhviTUu?=
 =?iso-8859-1?Q?NNcRmoBQZgDo5D3LKM32MdRA07GAjBVKPO6NT6leqd+7cP9L6JbK9m17N+?=
 =?iso-8859-1?Q?FT0vH8Yz61ydHbVfatcWPZI1VJLx/2gkz8wVuM8yFaTOQkZA08VXbOkj9h?=
 =?iso-8859-1?Q?LplkRezdzb3LtFTRuW3FKSZwj2Sqe443hixnw7+0plSJtV94ps6GhEZ5Wt?=
 =?iso-8859-1?Q?x8KATxUW7n2ouRP2BGtolxi/aBtSsAyFiDJjfbQ/rBYP2695krXiLFui04?=
 =?iso-8859-1?Q?jc2OI4t8Xxa1LBnBnpjyX+9luVxfaPsejo4AX5+b4W7B5bFO6pqN4t3/My?=
 =?iso-8859-1?Q?0IJzSYiQh4StuoSM8VO7+Ct8Xd0fIJpUxsweF+i1Bzcfspgp5XhRu4ZIMF?=
 =?iso-8859-1?Q?zmaml+nSy+Gp9yeWVzk4N165m/ugQpH7SINnqsk25Zo80etmbZ7VHu5btw?=
 =?iso-8859-1?Q?UmDeKe72b+k1KRcuk94A1nXmdsBKVhqU/WzQ6UyQRDDeA9AdqHvhhJtQbz?=
 =?iso-8859-1?Q?TfQU5QxaPKDq15nB3K5TjIjrfgPRV2Ql3aGe3b9+NfkFAfotliwUjXOr02?=
 =?iso-8859-1?Q?6P1H+nDsujj7MO8IMQBMTghIN7eMBdKgwCLF2lLcB1+8TrnHPX2jJfF4+J?=
 =?iso-8859-1?Q?JWALNOFew45bkSmSm20JXJ8BnNgDFFBeyBdD3WhrDCX/Tgk34yn9hqWSMm?=
 =?iso-8859-1?Q?E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?/QFmQScUEY1P9LClaHfaXwTgiUldZzNGrEjwaVDXkIM1MY3WNavrl6I86Q?=
 =?iso-8859-1?Q?7rpdAKLw4gpGWnJH4rL3dcC6wzjG81yoCYFM/fMJRkjFhxPf1SHZOpqIUp?=
 =?iso-8859-1?Q?kDowg4R9vQzAWxlGHYddzgtLvwXQLgMU1cYaqXxNNRV3AiOTBN77m8ftfA?=
 =?iso-8859-1?Q?Tk8MMXYoZDymGqsWuVkF9KWXdTcct8VMVLIma7B4V7durqMokJqNiqKSCk?=
 =?iso-8859-1?Q?z0fhLB6c4IDHv6NA5B0DxFSO6l/Xrs/zaydRk1pAJ7fo27DB2Ym5HYoan6?=
 =?iso-8859-1?Q?iAriUGmWH2L6mu9B+e4V8/UpgARL/I9Z5n+m8CAC1UnyBRHhMnoMn0sMWQ?=
 =?iso-8859-1?Q?D+OMlF/tBkMmL9GgyB5g2egD6Vg8+ATDI2F2x0/08bXU+BvLpemcL03dgo?=
 =?iso-8859-1?Q?bWlaZq0ioVU5GvIlmNNMVV8m+g4m67fSTH5AAHj1xQfM93dKujDmlgXwet?=
 =?iso-8859-1?Q?oX4Cy3ipI1WpFGM23vVTbCMyoQ+YwBYPM4yARsRHKOst/cnRwHRuOphMtH?=
 =?iso-8859-1?Q?Hrr9r0u+M0fJJnyUNUz9M7mYlUebnv39yfIdi2uC40zsA4tYubut80al7o?=
 =?iso-8859-1?Q?PfSEvac8cxvVM7iq3zGUBOz0SEuC61PkMOgusbdDvHde0ReOGqs0pb0E4P?=
 =?iso-8859-1?Q?9n1jdc0LRSMeQBpTRAo/4Wd01G4IaKgklow2MfG3WxmSPg4PrrcgunCnHc?=
 =?iso-8859-1?Q?eDhGDmm9cavrISlAwZk8Iy/eIB3H8gzJgc4Ns32PvOg1OoIYXGetm9R1ln?=
 =?iso-8859-1?Q?SAxeL/IMpJfyZeRBODLTQZUO2U1aZW7g5d3ExunWnJx0lRN3Rki0n8RgNF?=
 =?iso-8859-1?Q?Rl7PZecT4l2HA9JCtzZkHaMlqdS16IOCGZHO7tN8q92elcmdlOHlbIvisA?=
 =?iso-8859-1?Q?ApaIsDSLC+d4LQUv5OuvTHke1izHBnsy0eKKHWYbr+cAEIzvf2GogRfsxn?=
 =?iso-8859-1?Q?gvUq4P/ZMjtgSlJwyFyGXf09GL0VLCDmV/riFGYqV2HunHoZgR2U7geHZW?=
 =?iso-8859-1?Q?JLt7dBDX+a05I+alcBOyy6qgerQYHAAnC5taTtaNiRrlNDSL81ADoLW+sA?=
 =?iso-8859-1?Q?xcGFUBgBCY9o0N3jXquLJkLk18WbsEi849VpvZuI5bfLEX9dII+4O2j4Kz?=
 =?iso-8859-1?Q?uTnifoDRChyF6ixDWxlqCfBkPWjPSNupL0sgrKg8M4t84IpVD7bxnfMkqG?=
 =?iso-8859-1?Q?KgS3PKNM/geLIUx2uQ7ioXo4MgZIRAxIYIgYxgXKOXgJS1ANA9uPsJsncd?=
 =?iso-8859-1?Q?zbnEqpc9cco9/rsRJC4bkXLXqjbDzuHvOYEveuAfC0Qa+1mkMN+FgY58Mz?=
 =?iso-8859-1?Q?o8q1SQJ1F65fY9R3GnnfuK1HgbSf5314mV5TKHvzgcCBd63Jgh1OLeHs/t?=
 =?iso-8859-1?Q?QeiyIdwGUTQcfKl2VBVo96DGQ2QyhPluCtcUx3FBoFY1/EkEjSmLSO/JY6?=
 =?iso-8859-1?Q?5OwkU9cLTC1VSthk5emXagzujC5otjVjxVLRaw8wQtg1uhXXndJ20S7eUu?=
 =?iso-8859-1?Q?ul9QW9v9eEfgTCdGgAuYzS+Owmi+25gCyo91phQNNSeG3F1PVgEoyN0fKh?=
 =?iso-8859-1?Q?Ku/xLGx/QwKt5iMVLD9lHFlqI0Fbuy0lv4QWbMOpm/p4BEtZ8vS0ChlLQ+?=
 =?iso-8859-1?Q?8HJcRdVTs3cHR7srQbN2SRyMMHmNKlOQvqif4Qj1NfZ/1pqSj+9C7ITw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	73/nSopYYpy7vHrjHr3cCQ9Wz7/YCIXTOkSkEPtEzoesICRJCtEJ4CJf0bBEwcjmwZepSuP2MfSC7UDXYbIbgLL2N8oGmkUODHKLHmaotbIEM5uCOOniyu8fqX9juHPAHSbOriWCW1S/P+GERszSyvx7Bn1QL8KKdoK/BB1bXC9zEmAp4MWStZsDhPyWiKgiGSivSu80lfLjdKNhb9GBhf1QxcubCMNDT7zp/V4Ns9h/rqILbneeBHtRiOFUJ3XqSYGcsxfIj3T0sMKnQjVBuseqJVl5NPEepnDOJ+F5HvvMGk3/NiMjhGPVxM0rkJv41uPxG1mR8HqHlE2gobssgLxeHrZSVt5cGPhssku2VP1eHKVVtUYTTnunR+2zZR71FRAKKQAdZr5pICekc5LCB7yqVIpd7pQwNAw6uokPjFnk/13Ul5TqCvRLS3bayyvMo2x0AITuu9pMn0Xhdy4xYAim9AbSzK0fAybVKLAjCOrlWsHH/nzeBWSdqPj/Rgc6lGkQR1J4GB3edWr23oHqmL7Ns/JRCOl92pf/0+MewAkdmzHbokCIKmqtk7xKUOXU0thX0Ojc446KIw+ExptVd1l9wy7yr1zlme4Dp+3PTtA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d0f01f-f9c4-4713-50e8-08ddd8d83003
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 13:08:38.7219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5xZ32b5D1rbzKenKUuOt2wgo+fdnLIwH6zrxrvKNsgIdT64EDO7wnkzXHchqFEOgQ9ffP+JO2Ep3cDpd/4gH3cWhQE9Nkm63MDcCtEwb2v8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110084
X-Proofpoint-GUID: 5u2s2uoFD9B5JoWIPbs3kImn1Dwhzpr9
X-Proofpoint-ORIG-GUID: 5u2s2uoFD9B5JoWIPbs3kImn1Dwhzpr9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA4NCBTYWx0ZWRfX+PMekxKL5L/w
 awnAYSO8askEwiYKZXsSVkaQ2Sylup26CHlBEUb/C1H621lmEef23di+07i0krMoRXPhbFTPO+x
 tRG147rPLidelr3Wqk7CtogowcOahX5Xnfv+580ifORyfVNVRPR7HAqsN08H9rkGCNcs0njUlNC
 enk3eUVN9lMEjgDG9EJfwSsO1exHEBPiaXMYIiCVn+cLLHNpWC72i24wspFy45IxfCIj7QCdSiC
 dck2tF7jqhzCzR/La/H5Izen/48GSl/Nnw5WQRQ0yF8I7qCuXBZ7zc0+rTn9vbzSqfvDog0C/Qw
 5bgDtGRH9Ei4PX3p4seCA/GhJGhl0VIRmtaBxCvbbNteIdVE5xIAVQqQ8wV/lmJHgqxWdEmStus
 /Rl3ecU2G4Xou7sSvCn2mkip/o+akyUgWGmloCKMngPy2C51l/8bM7FrEouEYxNK1VFtXQJv
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=6899eb5d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8
 a=2QBAzQDmyTSnUfVGkxwA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 cc=ntf
 awl=host:12069
X-Rspamd-Queue-Id: 4630B140009
X-Stat-Signature: b6oeqhz1p4nkfsc8q6z13tf4pquj73ff
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754917741-492215
X-HE-Meta: U2FsdGVkX1+eTUWYVhebmnlrvXJqLIrEe+LR29x3vZ75wvs2wM2MenFzRDSQ4D0BPvlG1csJmOD0rjB6VICdJT6QGPNq3/r4PDKzSH6DCGJBgI63uMHukNpGakXLI7sofsUXiU9fEhPvsYASN7IHnlVLOXetHu0PaeSCq4wpEvAB1HgbxCGPnuTcyavWvfpfYaij35w0toAt9BknAgVwPpQKYZGroWhpKdg1UhtyswKNAFe6eeZwtL5YwcxPiD5vkgCQ//aOEN6YLckdMpqmzBx71t/vC0x6e+MXtUdMJxFvUNlLzlRe8n31f5vTHL3wgfUkm3GlVTE0WIQrzfiuQGaRTafaVN3cMb6W0hXQ1LGjv6MeKW0QDsejeTy5AzJprYIUiO0+ACJFTD4kIUl9a/4Ayo99pP3WWra0oYFx08O71/a95Lg+gmCQsYua8Dix25AdiwyttpMwsC/sDTKw2C2+tB3epqTF0I1KxgJgbyVj+wprbkHjM6Jy7wvyC0baekDMkIsPIY4FqLjLE4ZY9US37OgvoBZJi8PUoaSzo8xsgXmFheRKqy8+rtAbuNJoDAdIrmIuIcDwf1Xc8WiyK7005HPoQZO2P8nOLM0Go3Ev3BVtPCCalTzA1Cq/Rf6ZBbiqmDj+CIntvrSbz+IqvawOlOSnUdzKvgOv2uokQ1GZLxum25uNQW/gwXRaRbsatpfqGqd5kelUaNMWRt9F44Lm6XHGiaNThOOguRzLY2c1pDT7q4/otQZBDCRrc+uKHhTQP5dx9V4MCclMM8LhsNHcQ59eM1tbD56gIPieilpYhhy5yGIUm7S0MtrAUhq2ksb8buVXIHhZHoQyVh9nL8VfG9n+CD+nNqShOUewgJ+czFpj8m1cOtDughnzvPlvIjA1nZ7RabiY2RR4VtYliTzki1GDQowWVzxxJbcD2BOEI0C93hekB87RPc2H91kx/oCiS1udptzOxa2/sr5
 2IUl62kn
 VDqJrtKOMBWbm4B+C9wcCcuqNgmHFdnTWaUzw4bm05MFCuhY+UlGvhDvvetvkAW/Wnb8LcLM8um7aVUUyi8PUz82DsQ8WkiC8UikiHmO1JH3k6awrKmE6z5YHkfiYhY0iJW76iVRX94Jnazuj1EptHdcoUtQ7W/z+ETcSTC36VCPPe4Dnbxs7JjFLJBoutvAh/uFXUzQblRhSiNFilMMNVQqmvtOjy1K8SASLfx4YbYCYjLzOOapCSS7eEgpnMSCafIXcNDqMgVKPFPYApWyULlpMcAT8XpgFD7b8g07qacc74bhLiJIAyEVJdqY1QBLbYH4Y2u1+nQhaVn1apnwdxPdOJPrFq8NSTZzjxeiAHyjFMAUPNcjF+gO64EOcefa3ek8bHpjN5//wQ+SvRJymT/hulCd+j4UXx4xyKxOR3D+l9rlE7d99TKbk6aUubtRd7n0gg8eoqNpC2jxX2M7EhOH/IVBtTk7XaZV1eUBBGJFeZHgJesS+p37hYjHqcMlXjPHvIuRESeBJxCnmNUdlWDp9iaXwNJwxeLb5aPkio+72Vr/T6w4gXbtfvH9IwRz3phTf9ZybYijceIK4q7xTasnmCIasV1rS4CkSNHDX/EdNgVCKXr0uf4c1/9SjmdWGs7Ofl37z2M/JVunymGnEOKsomP/+tUagwQp4YtFwIuJw/q8APZprCCjVx0gA/ScmJiPesI/5N7le2ndVvfHzs3vtjr1R5Wt//zEH6nGYaYXtG4pXAbM5Ij0ce7LwVThF8GbXR4QU0QuIz5S4HT9s7vRXph4mipi+CecRb4OfvXYzeEK1MpFvxrUng/Xs3cErW7GLW02awbOP4vOTXLYpLUhOcx2njto1AK1T8yzIj5SMLulQO0irZW0b8csXRf7kZ3NgmP7JmVFmQaBcaZ0HgST+U8T9T3B0v9ePnwXPFVfKelUK81DmFFjmOnYREuyS2izFsRryXts2c1qUmVuxQKxtqZ4m
 OALqDLmc
 kNPnGdtwaVs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 03:03:36PM +0200, David Hildenbrand wrote:
> On 11.08.25 14:14, Lorenzo Stoakes wrote:
> > On Mon, Aug 11, 2025 at 03:13:14PM +0530, Charan Teja Kalla wrote:
> > > Thanks David, for the reply!!
> > > On 8/8/2025 5:34 PM, David Hildenbrand wrote:
> > > > >          if (mpnt) {
> > > > >              mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
> > > > >              mas_store(&vmi.mas, XA_ZERO_ENTRY);
> > > > >              /* Avoid OOM iterating a broken tree */
> > > > >              set_bit(MMF_OOM_SKIP, &mm->flags);
> > > > >          }
> > > > >          /*
> > > > >           * The mm_struct is going to exit, but the locks will be dropped
> > > > >           * first.  Set the mm_struct as unstable is advisable as it is
> > > > >           * not fully initialised.
> > > > >           */
> > > > >          set_bit(MMF_UNSTABLE, &mm->flags);
> > > > >      }
> > > > >
> > > > > Shouldn't we just remove anything from the tree here that was not copied
> > > > > immediately?
> > > >
> > > > Another fix would be to just check MMF_UNSTABLE in unuse_mm(). But
> > > > having these MMF_UNSTABLE checks all over the place feels a bit like
> > > > whack-a-mole.
> > > >
> > > Seems MMF_UNSTABLE is the expectation per the commit,
> > > 64c37e134b12("kernel: be more careful about dup_mmap() failures and
> > > uprobe registering"). Excerpt(s) from the commit message:
> >
> > This really is whack-a-mole yeah.
> >
> > >
> > > This patch sets the MMF_OOM_SKIP to avoid the iteration of the vmas on
> > > the oom side (even though this is extremely unlikely to be selected as
> > > an oom victim in the race window), and __sets MMF_UNSTABLE to avoid
> > > other potential users from using a partially initialised mm_struct.
> > >
> >
> > But... maybe this is better for the _hotfix_ version as a nicer way of
> > doing this.
>
> I would prefer using MMF_UNSTABLE as a hotfix.

Yeah, I think MMF_UNSTABLE is probably the way go, this is what I was trying to
say :P

>
> >
> > > When registering vmas for uprobe, skip the vmas in an mm that is marked
> > > unstable.  Modifying a vma in an unstable mm may cause issues if the mm
> > > isn't fully initialised.__
> > >
> > > > Is there anything preventing us from just leaving a proper tree that
> > > > reflects reality in place before we drop the write lock?
> > >
> > > When you mean proper tree, is this about the your previous question? --
> > > Shouldn't we just remove anything from the tree here that was not copied
> > > immediately?
> >
> > Commit d24062914837 (" fork: use __mt_dup() to duplicate maple tree in
> > dup_mmap()") did this for efficiency, so it'd be a regression to do this.
>
> We're talking about the case where fork *fails*. That cannot possibly be
> relevant for performance, can it? :)

I think it optimises the overall operation, but as a product of that, has to
handle this edge case, and that necessitated this rather horrble stuff.

Obviously we don't need to optimise a 'we are about to die' case :)

See https://lore.kernel.org/linux-mm/20231016032226.59199-1-zhangpeng.00@bytedance.com/
for details.

Cheers, Lorenzo

