Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FF0CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4D9900002; Thu, 11 Sep 2025 04:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BBCE8E0001; Thu, 11 Sep 2025 04:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38451900002; Thu, 11 Sep 2025 04:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20F9E8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:34:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4B00B9555
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:34:30 +0000 (UTC)
X-FDA: 83876307900.25.DBD0526
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 433FE120009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:34:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L0N+7oDF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VcQh504Z;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hk2X96xZ2swDodg5kNpRz07OwfHVH6i5dgMUGFawho=;
	b=WVwq/y74isxqkeRvCeIgIgyKtxspGFJflh8t238TuwugWv6ksP2a7ZNYeUirAIn95VbNCG
	l2SvE9orzB0ECLUyj17+QlYe+t2So4ahAmiVolTZu59GAy/Z0afI1Rf60pwAKDtRgYWZc0
	iy0xZnLXqVIU+TX5JIjyK0szsbK5pSk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L0N+7oDF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VcQh504Z;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757579667; a=rsa-sha256;
	cv=pass;
	b=qH+VtCKtU6KDv/7JO1NGhkJnCzAmfhLhEdFHabgfWunRbhq5PMybYRMVCr3t9zTCV7CEkt
	z+K7W/zGDbQ7eF8LpIBnBcWe6yD3u+HBr+oGpXpPIvXcp1ffvYHUkn7GfneNLw3wPFYA7p
	jCZmx5FCwzxJ8I37s2Vt6RRU3oNqBvo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7tfm0014059;
	Thu, 11 Sep 2025 08:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7hk2X96xZ2swDodg5k
	NpRz07OwfHVH6i5dgMUGFawho=; b=L0N+7oDFOV99xdkgnrVdTTSmAdFhOjSnL2
	CDoENYDnUOACGu/IiVguTsIlEp3rARUiAWnWDbQ4+7pAi/jkR/+sGcoVa6ug3G/k
	XGHMPhpP1UadR6qnKDJ15QRGZDm1JSO+ssHSyllcw8dItsBqoaMsR7b8PGCU1IhJ
	9V6IDlNHDM6pyWILiuucEzDkYZOHDUsWLlLiddkmN8s9BdrebSguc1MbbbCzvjfd
	GfEYb39E0imFcjL0YCL3z5CXpLUFr3zAlyCiqWvnvPsqkY13O+x8McZdioQhGuwb
	QYoApH1Y71uRqluedkOHOsaORQp8HzVCTjZDYh7iwwqyxtNAvjyw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1ny39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:34:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7AKR7030767;
	Thu, 11 Sep 2025 08:34:20 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012051.outbound.protection.outlook.com [40.93.195.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdc4472-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:34:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyJgXvupxMrF64KcHbY+fzKa8twTEHDMnuF7ubKPPDyeoxujOtuzQTzbpDElZRAe9TPWNSGR1/B1q3reZfYLPAKpY1v+RyHNEoR/sPq1nbkEjCvVSdWHZEsgKBt332Boqx3JS8E7hMLbyygd8XOWGx/F3S0uVx7c+dOmz2G/haNdaXJZfGCWhw7/GRAhdXb6ZaaaOJYiDraQrrWbcJHUExP2jmCEhrnPSrCVl+4oBTPy/suRMNOgIJlRTTk8hTCTw7POJObbvdPbMoMyRaQmV9E2WoNYY9h8dX5prcPXRta9vcwJVc+3fmV4uSxQRIxF/2NRaih4erxZsJ8FeRlLIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hk2X96xZ2swDodg5kNpRz07OwfHVH6i5dgMUGFawho=;
 b=Eghhjlsjji7vhLyg72JTn91aijb8c8uyrVWmrbqVKyGpcUtfgPriwymEbqAj1f7U3D5m6vYBKc9Jbz9/UE4XO+BGdjZgagQ913RT+8/pa+kbdtzFW1dpf1/FjiwYxFhfpWXhyGFFhXuqYsOKU/Edvu7EyJiOxdLcMmhCQjXy1TINx+veodhDsOKbz2bHtJCOfEdjm/TUJpCgx+JpvWnloMv+gbvE2wH9C+TU3LNWAJNkkAgEhPMKe8I38B/S5CDA4132iG7Rb8KxwgtIrRqVPac3K45Hdds15HuMU+eMkX/gfJH1X3ox8tVxpG6zTWcWLsBLcsm7VRkfGZT9MEvcXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hk2X96xZ2swDodg5kNpRz07OwfHVH6i5dgMUGFawho=;
 b=VcQh504Zt+G7kbHJleOZZd2bx7Ba9dzTCsAKnrkLd/akYG6OFbJYzJQuv7KI9tT0UBAko8QG0m3B1MwS2tMhD5oOAjX937VDuG4DZPiBPo7Sg9/h0GH7SSiLMqneJ5AlOCkq3vJVGWkhvQu7YunVjZ872Idx5i+K1Qk8LO6xnGg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5594.namprd10.prod.outlook.com (2603:10b6:510:f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 08:34:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 08:34:12 +0000
Date: Thu, 11 Sep 2025 09:34:09 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <974c11ff-a4b6-4273-8ecc-da80b88d5847@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <fc37efe2-53a2-483b-8c59-bccafae81d97@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc37efe2-53a2-483b-8c59-bccafae81d97@redhat.com>
X-ClientProxiedBy: MM0P280CA0063.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::27) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: dec9ff50-1bbd-4ea2-3673-08ddf10dfbef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8lTvZxp2WMhJMp2u2i/gRAkNJzuiO8jkE6kJhF32Epb/BQvxUNLdsewuUCE2?=
 =?us-ascii?Q?Oi5M/mLMQMowoOG6kZOkYLZ69x9dxysrZlpfSq74ibw+J1P7ug+jp/NP9FTg?=
 =?us-ascii?Q?N3oYksOm0wL65B3/BqWsWxzlOybObddHDlksDsWzDe7AzwxMvPH3U6R3AnUs?=
 =?us-ascii?Q?oBrw7OYcoFPjXG0yV2iZOwMG1GNymD7QDc8G+wkgesD4I1Yz37CyTL9Krs8a?=
 =?us-ascii?Q?qxoqnlDwkN6ek9aKUtUXkcNo61BdC+jDVJcwSHq0Za7iLLxj+SoLdi+i9wA8?=
 =?us-ascii?Q?V4IIH7I0ueyNMBEL9H/ebj7ROhdFoULajDIlfDuafpCjpELQDyuSbZ7T4bML?=
 =?us-ascii?Q?66o7U0Yf7Px71o7toU1XIsq7l57T1OMWquk/Tm7IDNm6z2PIY1lXv7K8ld+P?=
 =?us-ascii?Q?67RJHe0/lDN7HFWHuEp5mFX6vuSV9BPT/YfgQ9156h4KJumfpEnEoLmrIJ+1?=
 =?us-ascii?Q?gKGMlxkE23aiNU9ztF12zex6Y9m1ceclTOahF+0Rs6VcknuzcOvDuMRHR1yv?=
 =?us-ascii?Q?rXc/Q0ZN0V3lNA0pZgYyydiEJUbu+a/pSjxjPHUbM3673rrYl4cTJsjPCR4t?=
 =?us-ascii?Q?qQ/NjYb5Xv5gh0LDf5h+kAbzKyoWiLDmJUY1f026se38Q0pkYJ7a1P8h/LOX?=
 =?us-ascii?Q?b0yfxFU5grwT4XMKfvuqnHKEkAw5l/KKdb37mgE1gVx6CAUXTSHwBH8rFVvW?=
 =?us-ascii?Q?jUi+tiyxf5fUw64AxWIV8Esk5SezTaWEw2J3dosHrOHs109Qch35zgj1wEqm?=
 =?us-ascii?Q?QuQLnbky8OAMj7xdXBoa9wQQ9WIXnrG7PLQOVvsfsUdqI044c972Ha54W9nQ?=
 =?us-ascii?Q?1PDv9dBjEw0hYrJ50kbMDRpn7REt3xxEMth1UDbtDvSNWO+vTfIYdmqIsV/2?=
 =?us-ascii?Q?O5nipJouTGqxE7SFNMSqmdxTa90/QXMD+2iKULaP7nKq6C0ggCYDc3aBg9LT?=
 =?us-ascii?Q?y+E1vyoPxgv0UANfYmtlvj25Q7jK5cvsQEzP3dXU3J4QsiXYPIXryeu9j3l0?=
 =?us-ascii?Q?8yoIxTlrnG69n0UXhg+rZ34IIvrd+ghH3JE22t8sPBT5f3mzXfdhjMWEwbTI?=
 =?us-ascii?Q?6KGM76K/DIKLaaYal8lFKzh7iBWmp2S+JgFfNUIBF7483XuZxq07BzD8S8ee?=
 =?us-ascii?Q?zY9LUXP1KcDlKWCzQOSPMOOe5h+vL80y3HeciqVAzhUKqBLE/eFGtt7vXHP/?=
 =?us-ascii?Q?wUF1Dk8WhaN1hm146zBVp2zeEHDocFaTMrhUAGh7U68N5H/KmBhoPgrIiUkD?=
 =?us-ascii?Q?sMfBiOLVlROEr8AeDlPXe5aU5MJXEHVRoyCDOlpN1h4Ruw+NzDVM0AmkroRk?=
 =?us-ascii?Q?Sbubd31N5QXYU4a65eTQENNYkvYlqQcxwsULZaJq8qk6jJqOzCFFF2IOSxpd?=
 =?us-ascii?Q?z+UE6BZ/NGNrV30IJNsQ8wX8pligHtIhqNYAaLmjeqQW1szt5bIhE2pAgX+5?=
 =?us-ascii?Q?h4pm1qRul2U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rOvA7fHaz9PJtdytq6908w+ZAon3qiaT9H9qmDxKEKAYPDPb6ml8SolRFBTg?=
 =?us-ascii?Q?O1OrdEh+zXRM0wgolnl4Sm9dffnot0YWhppBwc4oA9b0YfUWQ2VbRs5n3xl9?=
 =?us-ascii?Q?tMgZ54MLkfmc3E0HKGBrLxRhQhvhzKiAnn3qg6mRtFe0mOJw1SA8UEwIIp7o?=
 =?us-ascii?Q?duybmzcx4r5xHkJbQQ743NMs5QyGN0FtP5DySyVzTUffphLXqpjUoWKelkv8?=
 =?us-ascii?Q?BFHrWS5wPm5E34jYgDnk06USKGxhpWypv+blR0LMsPiXOiRDFQPr8tboi/4e?=
 =?us-ascii?Q?1DIPSc6yMUX+lNurMkhTnnEdpNK8kAfTmpqZryvAIiBn7EXYGsJSmk3Sn73A?=
 =?us-ascii?Q?lsnXn8SsQfPPkMRJrHQvrn6M6Vl5KY8IhuNX3j7jAVVcExp8OslkKAr5qcCf?=
 =?us-ascii?Q?3jnkCxqg3QcMcMJ6Og5I7mX7I0vLr/w7I4tqgdqvHl3eSDN9qTVz5VxB6RJo?=
 =?us-ascii?Q?A05sBC4zyeyi/ANmmPoOlpKhL1zwgheMkwJKCaLWTdFKOA1ZUwV1gbWJFhLV?=
 =?us-ascii?Q?RmrcxKI2FPCWCQgLB3ZG9w3ovagYDADbI4Rq8XOpkbZsf7zYPcJsfyTYQXEs?=
 =?us-ascii?Q?5t/4neJjl4CvcVJkG/hWImPf/3I0E1z4c6Ksg0kLie3xFV97dKAQa3fK7zL1?=
 =?us-ascii?Q?BpMdh5G2qPM4Kiho+mbDPB+FaYnrqhd9StYG93pbiWyGpZam+pgrG7qrT435?=
 =?us-ascii?Q?oj7pwpexQJFBuvyIE6g9/NmJPOXoQLYWVQdUuyyXeI0GbmAaEZJ0b7BgvUnH?=
 =?us-ascii?Q?/FHizvfu5XZHDasc55SI+rnmKiDht7HLLOHRiAQiUsBmZusT1GuwKkFLGaaF?=
 =?us-ascii?Q?nJiAWALJteQepXAIi+/xNr2jvfu79JPMaA5bj+IzL/8xEVd0begt2jjEJCAZ?=
 =?us-ascii?Q?Jrcc/QVs38+Pwm7zIvSSXsiSAZYa9IgIyrzFoYKd4trZciC1UEX6H+Ueovpo?=
 =?us-ascii?Q?Bb98v7MKIl3vwxwuCEKeqtyH71zUBpEtdsdEbaMBz/djOBVb6bGhkY0+k7QU?=
 =?us-ascii?Q?Ypevj/H5KiFvqQvtCH27jNm4EgzEOt/xKkvNdC784M99aJKf/u+wzALdrqui?=
 =?us-ascii?Q?evryfV98tQT/7ry8cZSlsHx9LNwTbJFlQmSt629+Y0HydO+ynq/BoFddKd9W?=
 =?us-ascii?Q?SAiBCDR7LeGZ2aJgtyDGyNG7IQSOIPeb1de5DuH6cJ7F1A32zvB/1tWZ/dyY?=
 =?us-ascii?Q?Qaf94/idqoAQVUO+JWnuaLjimY32KoD3PNixj8uegu/JUyejGVvWhduUq1ho?=
 =?us-ascii?Q?eoV8jL8IMd6zIq8lqRzmtZiHuUHfnO0Wc8EbcXI8OwjkeTGfDmiNLyb1ydKh?=
 =?us-ascii?Q?zQLXsBazxWpmTibPZpPmAZhyj+o60BWVk1K651miX5BbwdW7hyumOJ7libZ3?=
 =?us-ascii?Q?SPNZkZ5PzI935+2TnsrxU8NTOSnME1zUfwh1A1d1volEW/uaKDV8VgOqaJFP?=
 =?us-ascii?Q?FtVxhNcrWBdVZgdNRiNPxFx+X8J2wtGZmfD35hOlkApr7+rhZF+cXQbp5Ker?=
 =?us-ascii?Q?UqaqnIHx3xBPS+zqZ3A/MrIQ3jeYLCLRn+fDtk/RVqzr3AlhyuvAOrd8JZ4h?=
 =?us-ascii?Q?yndKS9HOdvGgdnP+CWrg3HlIcQkej0mcAMBp7D/0uhJYuG87FMS1HbKTxh3K?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DJprUSrfNJEhKaKk3JshddWK5oc2TaDbNyG9imc2JMLNsjuXoGi+sg22yEWgrFX7A/j93UZrYq3n84e11L7FAGr2tpCU8JrikUsPbemVnBxqahUnDc14YAA6EbyN4MByO/LlXkXAqCx/i9ASgUo2vI49ym71Ff8z/eXrE68HWh6lgY5VMMsnxnut/+EGgTX7fmSd5KY78zAKWodBjqnZWFLUzWuxe7ThuiuMC61fE6gU0CkeuEXGgmnLdvrfM3Hf0mxckcR9gv09qgMQFdb5td5gjZq0UhfHTqebstjDt/3pEHH6LF9+J+XZBZ0wrYYwXsK4gPizm49/GGBRaUSW04hWGi7+Z5oKTsSUefAupmNkzRjPLw0AqLV7yi1/k2LODs1mn7wpL5k3egprveRGQFIhh+fRSPVpLt4OotIJv9PPJ3dWiZKiletrEXdEqbRowjN/4WtwOF6QCdYj0r/u3D4eiIOSxNwSs5q7OgBedoaR+okfUTAMGU1jKeB9j4sQ0p0J23IHt7CBkb+6YE1IGceNYtCfitO4FyPyNibGGrPpiCu8wElWmD8JJk6kFXfk9ejhQz3a9gwzFFa3zu5IqNYxY4IzcZH0S27h6y5zgbg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dec9ff50-1bbd-4ea2-3673-08ddf10dfbef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 08:34:12.0684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF/MbkzxLHVLFGXSgoW67Lakk0QScghaVvrHRXXMo0waHgd81QcjrCJaBQfzcZ/ocfDYtuGvslWgHHOUJlrxJR+8Y0JEzYTMlHJJUAkTrb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=979 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509110076
X-Proofpoint-ORIG-GUID: 7a9xBdK7v9U8t-rdR2M1vZxj7Da6xj1u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX6J1AnD6du+B6
 3ZDywSZ46BwJ8LyCPgz8xYuVav+wmQ/CPngZkl16SYyZc7IOUnokg17Mu/VQPH9d1xyddN7MWYU
 If3NahiVNGqIrJ9LtWkzPYYNC6ztIxZ3YiplXXGBVLUkLqnnA1KQSu+O4mkk89ymHDoXvtHAyq2
 AFoBiemv7ExhND+ManDSngu3SXKi5OzCC8Wj5Ls49wJ9o/ka+9zB8EYC0erAq7xqIh/0n5rWeuv
 vOZdX8lLu2rwJPhfpPZEvmhY1R2y9uhEriMP6Q8TmsAOCaitfQz1daQf22cdLnCNDGpBl9i0Sk1
 iZJ/lLgqGNbXlRmyQnHErp7575z9HvZXCZehpyOmOS9EjPcJPthgsazigT0Cx6VWIE3JPptQsqW
 LgOgygm7
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c2898d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=pB1D1zVdJrHP_zLLr88A:9
 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: 7a9xBdK7v9U8t-rdR2M1vZxj7Da6xj1u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 433FE120009
X-Stat-Signature: ecuc8iqna8qbzosroxp87adrbpreame8
X-HE-Tag: 1757579667-595356
X-HE-Meta: U2FsdGVkX18CVVFx1xdO5xSq5vkvP3+9GAyyD1UqruULbq5xXbzvhayC6Fi+PyOrQjG8vuLQnSnNuNPKeFK+SY/sJgBjmq+UzGA44DhEQdEzD6EXp+oPh4l/OQ67f0JDPuSpb1A3LRY549AAglpX90/er4Vlz0e5hxgEH+VirFwjMmtvy+6W/cw3CsW8ZG9+f7tzxkhpd5ODdj+IPldKLPpQkjxodQe/OOwWs6xnqMvKu+RiY4E4qc78TmakL25LeWw/ToxTY8oundED/EzoI4lM/dCOVHa70YGR6yBL/aGL47buDDq/OTKNZ63YRWhUzN/IAA3e4/3yzT44hqDJmayYBHsr/DnbZzWKozyaR7WgDHteIZUms7U/4ETw6wr0pOtlFJAylZFZCoPtZ1MctaIvgp6PS8luoBEQKq5xK0BlnTj3EFRJExKTp8Nn8Cl/spYTGVdF3Wx/6EpCIzMvlmRBUMp1Pi1YARBfg4ZwcaxEFUXbnF+IMgY+ska5fQKsb13eiMSUbgHfseuw0K/5ANSM7GTc680xXtz1RPieZuJyejBM4f3+TCPc/wV4KmOI5YIpDK4iNcmHB+nobyD0kq3D6VzmnFJ8nB93Xm46j/fxQKFMBT8Vvqfgzm+UC4BfLTTqrv3xLd5g57SF5fzPFnYQHGQ0F6087CaesKRgCFGpu5ZKWR4WmKVUFDRksdPklnfY06G0acbSdr8N3HJMATsS1qScWHI26L89gTHDRCToognZUimxQMmDzwT8Qg9Q0wVn6QeJ5su6V2CxTeXe9gcwC8e+cZXPqLEVpY0KL8xP34/J5ByaoOoYawkJQEGpPgh4jmF/xgv4BToRYAfHCBcBadGGJOP//6IOLnlCRd4GuZ0Vq0HtdJ1uyEpXph7jpDpZ9VERep6+f4qbUwQE5xF06o0Qs0remjaOOmQswtQM4b3EZFIsLOfLV9H4eTLQsnnMj+tZRUwmYzCnP5t
 HB8rl2wQ
 NW4kB61N6BPPj/a64EDe4c4zvbP+aqmZfgwRsvclb3rI+RSgWvKoCsFGu66kyDMKMSZ2VHnG5rektMYBvHS8Aa6bPcZBoRCOOczddSpYvQKmx73cmmPBKaOeNvkRyzV46pDIULzVaEzbiu3IwxGhi0/xbFNJxNG6K9UsVXBVlpIzfg/Bvcf2mJFnbWbXoQ8s2S3Wzc7yrWVBKIS9NeZgE6phrTnYK9xTng2VPI119d3p6yqOpC6eDMTN3VVj3gVdbecHevTYg4VmE502Ljqmd3PRKgaf65ClO20wbHCGWfeT2Ixjixe5h8KSedFtFYv4JPSzy+DSfcVMiba2czjdM22Grq3TmKwYNXH37Ryp3W5ww3suifhyI2Miwgpwki1srfnj0fJoSiWDqYRalKEpT5ElRJGHZ6qr0JQRryoI+r6CVh+VB8RWYgyulU7v+Uu2C3RN8uJuEcZaLInWQFKFC7X7MB9hlzdbMJpyIV34iyJxtnIpJqZ3YKQlHHdRMKinMljY58Q3/JlJBzu8iixkV7UNW8CSYNJycWLW23CJWCUzTC8UKm9BSQ8QPwc15vlFejAcUBaMoo09Mj3aLd1rd29xa53gHVTXhhazxS9Qo0FOfo/NAMCzAKN8e4VqZ0FnnYCfBfbIFB6ZnWr0gcIqWjYYmTWCOfJopMdlKjPDFUQppEjLs271QQn7nAb2Sf0D6iI+J1jcXZO1KXJiLX9KwJlcZgDXC1G7qQsLoZ3NGXgARgQjIALRFruywhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:14:26AM +0200, David Hildenbrand wrote:
> To summarize, are you proposing a similar locking scheme like we have for mm
> vs. vma here for anon-vma root vs. anon-vma?

I don't think that can work, because when holding the write lock we will drop
interval edges, not sure how we can possibly have concurrent readers at this
point.

And for write you'd have to analagously hold the root anon_vma write lock so
that'd be no faster.

I think really this problem speaks to fundamental issues with how anon_vma's are
implemented (that being the case is why I have such an interest in attacking
this problem).

I can try implementing some ideas in relation to this, as I do hope that I can
find incremental ways of doing so... - Barry I guess it's fairly easy to repro
some of these contention issues to test ideas out?

Cheers, Lorenzo

