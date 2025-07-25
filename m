Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405FCC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 05:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DFA6B007B; Fri, 25 Jul 2025 01:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7A16B0088; Fri, 25 Jul 2025 01:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F966B0089; Fri, 25 Jul 2025 01:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94B2C6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:50:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12FBEB87C7
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:50:12 +0000 (UTC)
X-FDA: 83701711464.14.6C272C4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id B73631C0005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:50:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KIxm+4lL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bHii+gzH;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753422608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hj9rQ3x8poFSNc/ygNXJi3Nhg6iIFpBGnUJJ/llAJ18=;
	b=ab70GXpHfZDth8brBz1a72XpGNffNZEvBD/mOCPo0fcgFrRGdbM43fwde0NWI0Ra8CY6fi
	MXpBEtF1cZrYyHWvF+rbeqqFPp+iDKox21kdQMNBk4iDJzOcrHBlQnkxqO25+OkiLtmXhW
	3TAVN1miWuwzuey4sTiWhokcdAfPwVM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753422608; a=rsa-sha256;
	cv=pass;
	b=BQx5joI+vDhdtiu6d0c3d4VOUgDBeIYvnbD/CycxpkdGQNf/faYxjTF6BBnOvEkddy8q4u
	mPdFiKY2KqYQAZ8nWAs0EJ6K93GTCAyBPd+SoAvfuvbjQWoty5Kg8tdIL3NbmMh5kEsGnX
	SqKWGlazl4x08/x0/1RUFFrdJNA5jYU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KIxm+4lL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bHii+gzH;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLk1Hq011816;
	Fri, 25 Jul 2025 05:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Hj9rQ3x8poFSNc/ygN
	XJi3Nhg6iIFpBGnUJJ/llAJ18=; b=KIxm+4lLa+OlmO5phszib1KRCljM8zNa+P
	OdOaNZz47XCMr8ZMeEDy6dB+4aWxyedbzBSfnBhbEPkJs72E3+E9Qvj9nUdpGcJe
	wOBxP4yuROOH1kwhNC1nvR/xtpoYQFLB4vQW71bml9O3ldKIHnpXLZfSIWBfnVuE
	fFsz8KLwbtVzwrzE6yybeoxzbj/+TFbwf/vCFlm5eFB1hSFm3FpNiAX0upLz2dw8
	hoPbZ6Q/NDf55w36dWFsCV3xNqVbMKqE8ypHkKHb0H0CSN2fhSD6fBKoJyOxR9eb
	NfJtmoXkF/+Utm0ECFo1cx2eW7wDUWJCeei8K5+B7cfuA89wsWhw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k8csm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 05:50:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P5ZYHE005916;
	Fri, 25 Jul 2025 05:50:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcp5p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 05:50:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=baeF1M8GlrhtJoMSsAnIubkI337vgl9inwBHW9bDj2fr8J7pDUT5qDl2MAk5SACdkueD/o91QGnnx5m4oU2yU6WIjejbdP5KYBRS/AoqpYDaNmttjQfBrSWzbfZO6KhXwu6jgHMEevORgl12vyzKilDWhY5GvWOdyVEmmsvALawBLeIyL4GFfDkqSSONKF1vnTpJJwao4Ta0rgbUpstQl3kmS9zk37Ti2ubuZGAjOTknlU5Kcp6zO+6JuGNij1wZUdGWiz/E3zz7ffZoSx6ey93uK+GWLq7Ml6iQol+JshJqFdCtyPfparHxMtCjf+ZGzGRIjfI7qwEYlw2YHWYTeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hj9rQ3x8poFSNc/ygNXJi3Nhg6iIFpBGnUJJ/llAJ18=;
 b=na5/FortEgAJDND7D78Wcu6ZE5p5rFdvvY9OV/00gT2uFSj00x9Jo+OtAmnP3cK3/2Vm3yzlOPihfUzCXeTJYCAMysbQTMUIUrYs3k82U82CPCSqrirEOrZ8j2BjGVGGnzkOR7CJPXtCPWvdBN3xjNQ/uExkm7fjfsJslW7zXGGlw8l+Y1ItzxWT5jT+0F7c0lblhAuVqm9fy2Bd5uDjDdePeibEueu5TtxTn1jX/+0sAH5kiJN/lvQLDU3mX9vvLyFOtfX619hiNg5rfbtSAaFc4CyAeIiEQRgeJ8cdPv+KdwFGOIODJAibjSqwdYQDvGT7oJ7yzv0ZH1lz9CiTYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj9rQ3x8poFSNc/ygNXJi3Nhg6iIFpBGnUJJ/llAJ18=;
 b=bHii+gzHzGoW0iS/CD7WVUW4O2KnuYeQHrgxuV89KyOBEO05i5Lm+mUKZ4YYQWibYNMhQe3N2wOfW29z5ExpqHwMXHT3dpnNDpleuHkv6KPvBfoR9xfn7/EN/E1uvTcjhiDD2bFheW8kfNO6MxBgcMLHU4/Xq75gYFHM0kI8X6k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 05:50:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 05:50:00 +0000
Date: Fri, 25 Jul 2025 06:49:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Xu <jeffxu@chromium.org>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
Message-ID: <383bd3c0-988b-45f7-ac43-eadbe1c72866@lucifer.local>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <202507241352.22634450C9@keescook>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507241352.22634450C9@keescook>
X-ClientProxiedBy: LO2P265CA0371.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eda37b5-210b-44a0-afdd-08ddcb3f17bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AdkJPp6LH3ppWIrn1Q73IqICF7ioBVrubJsOck3+RSw9CH59pLnCWj7g9K4E?=
 =?us-ascii?Q?dY72gEvCpbnkCRte08dL02dygwsgllUfdiVjRTniniJFMzbIZWWrb8AAtkeS?=
 =?us-ascii?Q?fdHmfNZB2zNMoZqQdgtW5EBDC1jV/w2+mPPw9iuEDgn0V5MmDLrTnRNrwJQI?=
 =?us-ascii?Q?5WKt/rYhQ34miwRQI04IupsIDtzOhk7AduoA4IU7OKuZPvDRHtrLElAXR4cB?=
 =?us-ascii?Q?ucSNcZhVfD4n7zH3qr2cqL7ijjlKIKYLXj/SyejvSXvdNDQmkgeGJcRUyPn7?=
 =?us-ascii?Q?y5jB59rih3hiN4NpSr9aGYgXFfYkad50ayWwB0RJfFhv6V8u3VEzwraseLmN?=
 =?us-ascii?Q?uE010aOCZ62B+GMqo6Q0U0uKNdkSLXIfwj7lfpIH8EGIjCkJWZeu0vVURzvF?=
 =?us-ascii?Q?6/VgeuSm2S3fDSTF+pFFTtF8s0+KczEf0Fhac6d+a/7uPdpmGBdH3d4SQvYY?=
 =?us-ascii?Q?BkvBO/+SSwxwmftzOEYKwFdCcRpK+mfTTbOm1brPbYx9iXGGMmELgmsg3lNl?=
 =?us-ascii?Q?XiF+kqixBRKUFTlzXpq7otI+rx+JpEW36KRwF5wj0+qFdbbowUKoU59RzenQ?=
 =?us-ascii?Q?9sRin0QcKlizsNxRyZeTKrjWTr1Hh5dyGbP0Ipz5eWm/ajF62oFdFSgdXgDZ?=
 =?us-ascii?Q?AiOTRgyowLAK9GuhxDQGNImNiCkdyJsY6IeI0tkCjl9tUy9L7CtA04C3Nvmu?=
 =?us-ascii?Q?vkaTYYVv5TAapBmDjyl3uiVDD35/vUWzj9YDm6x8A8LHdeAKktfeA0g8V2n+?=
 =?us-ascii?Q?AX8o8GGKKTykkQEFa6anOViNsBPN2b6UhFLq8EudDX4vkJMMwNT9TUVmdvRM?=
 =?us-ascii?Q?Cj+M1foYR779yPCoskncChRuBjdkyCjpQF6Wyum4KTwec4Mp/ut2XgCzZBGg?=
 =?us-ascii?Q?lzkILqpCAkIiJq/vthnPX4YySDEQRPPPF+nXDw1hqVM0zbNtLNd2pyQPcCd5?=
 =?us-ascii?Q?q58GdfEimnPHZy7hjm3h71vmB3H/stUgx7+dDn79k0t3mSHQzNYBePPlzvdz?=
 =?us-ascii?Q?0CkxgXxxc8XVwceYdNivOx2cLbcVqRT3eM9pX6gu+ioWfLHGjzXVgB9MZxnC?=
 =?us-ascii?Q?Gz0sIIMPJk8B936VPtl5otPA1xjSCcIpS3X+m2ohVE21noqVV72JD8Uu7cd9?=
 =?us-ascii?Q?I3MQP4JUnulG2WB3r7i0+jeOW60zY+TrXhnw4xcxA/Hmoz/BLQHBIE43/8Om?=
 =?us-ascii?Q?aZyStB1mv5zwKa7qDdgBlr/jJQfdvPpz+HP9ylrdTYVWvGDLLetQGtdeSqvB?=
 =?us-ascii?Q?I49qONdlYdc5RpH+itmyEeumJzoboJLtRd/2VisB+wA+FSu9vncX08hR6/oz?=
 =?us-ascii?Q?xxapnu+DiAqOqK2hlT49IXo+xR1CwN0riT7HZOQwwVNJEvcthMQzlxa4B4o0?=
 =?us-ascii?Q?3nmJpB9WsFhlPQuCxMSjioraySD73ci/JG1tN2H+9oU/2qzw+vRiGmUERLMI?=
 =?us-ascii?Q?pBonScuoBvc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pyz4hlS1j5P8aDuGgG53cvWGOTNXBEw/AJQTNhtYAc/ojfydyR0cI1MGDd+s?=
 =?us-ascii?Q?Wn1L3SJBaZmYFv1+5ALWvjmhv8H0VgKmPkONlUWA7SfVaZ/xwnjDwV2f0Qjs?=
 =?us-ascii?Q?TSIZoKfBHfcX1t/BRB5a+x0mCiIAidEklyavrgdQKafuXx18Gx7HzV8wLhJH?=
 =?us-ascii?Q?6BSHM3bSZL9DU3ZIBi78o328CljUJzg+disNMafbqCEtlJVVK7qidNWrEjdv?=
 =?us-ascii?Q?2SF5dRcnqP/tT4lQdN3EpE1SPtu+EXzGCLiTZx7giR39Mn7qp863apo3644X?=
 =?us-ascii?Q?DzKUvxX6HDYpELh/6OU0nLjqTuNz/088TzmjW/aeMuWIzkXdJmSgJGXSRZ5l?=
 =?us-ascii?Q?Awiq+yKHGuHKN5SJZdLr6qhWpKTdHpfLzFNbNTgNb0V/2rq/QiwNNn5WAeKv?=
 =?us-ascii?Q?U2efQZ6tKYCif3Qo+q3kUOmbR7JYXMzCF5rsUSwcTqvSZeZpl8Q6hcN4mw0g?=
 =?us-ascii?Q?68uVZwqZUzzRWBHyAAyovqdUxMjxAXnuXUhXTxJmEv2bBitPBmm9BqziRohL?=
 =?us-ascii?Q?XarN7QxnYk4/EzPxGE/VnWgpahZD0B4UbtuOVgQRk9AlR+v+ClKw1W/Nk1oA?=
 =?us-ascii?Q?SRg6Px0Bgne+FSNVHM8uua+BCp6JurBkyNhQCr8jVxGXt2hGhrmvBvN/TnjK?=
 =?us-ascii?Q?1f2LlKWIUnFD1XNuuDM9wYbyiR0z1ae4uih9AxC0xhSfFuJGHICQJtKFuqqG?=
 =?us-ascii?Q?N2WePYmokPs36SPfsy81IX3q30K4rjkVDcmZJfK+oTKzNJvY6SPLCak5TwaX?=
 =?us-ascii?Q?QBffLYHfgxJhVp3nFPKdFVr91kL9FJVddJ5UyHMDmPre1ON+/+dnxYBoYDu9?=
 =?us-ascii?Q?2+wH14pGMbMGhXfrpyfhwCFwCdATLoMGPHwZtljTV7ah6MlQvfQTwvl9Tvcm?=
 =?us-ascii?Q?N0Ao7yjR1aYbBtLOQR1JEPPY6fOnoI1Xfu8CDSISmbOrWqo167yHjkmv8EI6?=
 =?us-ascii?Q?0iJzaWBFWGEpFhOoHwpbkWsQ78vRhXz/nwKLhIHV4VMFCYrD/eSGIz/vgCRM?=
 =?us-ascii?Q?OpgYiWsBB+OUeCKfnzVmuDmVsyZuGQzKBw+RRaL3ORBxiWVrAfwIdrXAZwCh?=
 =?us-ascii?Q?QZgfAGsdIZmvuv/CcdeIR9iiLR8uye/oSETrhCuGc3K1WGiAwC8SXnPLWE+b?=
 =?us-ascii?Q?gVlBqX3qIRjT9/ExEVlPExdB85cehadOUUAYKjM6073yUftm5i3sEFPARfRM?=
 =?us-ascii?Q?F5pbhK4KWzEmeCTbLtiQ0DpE+0TTXKsvFKuFqyygwObIu/JGoymhFcbqtmtm?=
 =?us-ascii?Q?BHO/cUx6WYv0mDEKysw5Ax9xw+LlV5AP8jv8WbtKCFs5SHTRcyO+rAXaOMCi?=
 =?us-ascii?Q?BmifNZMFWvjuj4tEqGBgMmfXZdYqs3cYIK/ax5Vz8CznPzxFAsRbq2fs4rXG?=
 =?us-ascii?Q?xnWqlhoXuk2ITQdVs2tJxcIe7sDJ9nmVlRZ55XsOnmUNCrHaEh/0aOWNQMe1?=
 =?us-ascii?Q?Xr+e/dTtQvcZCOPxZrv6EQrcn66txzWDGrQZoxs8yLIucuupbaCz4nSOZK4V?=
 =?us-ascii?Q?zQMDg9FeEPskzeYrlIidaY58njgPpFvtF4mV3SxMJlaOBtUUh5XPaANja38n?=
 =?us-ascii?Q?utN5MGKIpRPxCAvEVETKkxQ3s0UuZmKCy1HduTxLtHi5zILnNgDs+mxfK/Yx?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kX5jYPi7fkbJN5ns7+r5Gf/B5tSqadiw1tq/5eUiiIUd+qsAo5W7lQ7PLztXb2dCZJXyCGKSsnYRpFbj3erJeVgLE5q0tpUfvkBLAsrBVbNogDEEQSrwhrnM8pCm0/eclLU3jxEMGnu4O2qO8cJKsYtNZ7FuFOWPzBxdn2E45DmgY25/ofYuVRYhEUNKlhJEz/6IPpVvy1tAEBewp/BKlrOwuXunl8HO9MeqHzfeVnJcXI3/xox0ANKJ5YDS8bIghbgG8pJPSFNtXZ98K22Ar9Vf5bHg9PY1B4LSiq1OvQDGz4KSIYV7V7SEBOCtxhqVis3yFfN8mLUqfLoFOA6W+1DHwVcGTJujWru0CIDTdi/9QDuk2NJsfDdcCEaQn74TIW+PPsbB8rCIDzdNTpdSNMqUwSL47SFhaZh+HmR09pAwUGLHRHCjUGwqKE2kgmcYJmKgRje8rLUa+H3vtBnGiKzdyjo1h2YAt6QVh5/gI5WEEsKe7NEtOK+D72mUlVaSYZe5QluZz5b2A43RTfcUwEOa7P/dVCB7zf2XuTgmJodI1k3yfi2M9vh6UxU5xSOWzHDjG10CLhaGET6zccP/fphpQ6J6hTr/DYMq0ZSEhDs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eda37b5-210b-44a0-afdd-08ddcb3f17bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 05:49:59.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X8WsJyrsoxdq8jSsUOfn+kzv8lDNP1tUE7HoOo3GID3Wwp7vrCQvJirMaQPzGUbQxMWMiLIL4hFZ8Wjx6sI6hpalFmDuwovYCWHJX8LDgd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_01,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250047
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA0NyBTYWx0ZWRfX9OAG+LsN8AsB
 mIZFGitpOKNLPrb59I1252hbM0NnwnYHsG9NxtLwqwEGtGMzFl5LnEGVuzcaiufDh+Ka3oyvn2O
 WJ69SMOzuIdKsFmNVwcouRNLiVyO8P7OF2Ey0tM8ELADTz22D+gCSctPCNbNxsT2IWqVFZB5zQA
 ikI5P4ryLAyiv+VfflzgmP2pNzT+PqRz/q8seJN/bLnWwhidlnoPnAOfLgXdAOgCMq2whCF+g5B
 vDruouBSu9OYDvbR/YUMnl2MuvMAWMS0b6pHpMC1Z8DVSQ44phEZA2ZhsZCBS5zLBV0FFo8fo94
 ejtFxn9w/mu2n91axvbXSy74pXUHzB+J5fMMZHyzTu9ySGR4wJQ+E52r20yqubpzqLuWCajr+Ve
 ZHCidwhYuAulG8nLTlskjth+BadTyiL8gpKYWknwv6ZiS1nGYLl1SYo0hNOQuBm1twW3d1ix
X-Proofpoint-ORIG-GUID: nH2Z2_NQmlVT4l2V_HubnAf0XhxCVdL_
X-Proofpoint-GUID: nH2Z2_NQmlVT4l2V_HubnAf0XhxCVdL_
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=68831b0b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=OrzIZ5cD9KbUtGvAh-8A:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B73631C0005
X-Stat-Signature: dxwg3gtojpecd88p8pb8az7qey4enmfj
X-Rspam-User: 
X-HE-Tag: 1753422608-785201
X-HE-Meta: U2FsdGVkX189VL2FtRxBGoM6/4iui220L1FPB2XBBotzmVyEdA0O66IxDWdJMqS/IWmDvnGB8yjSkS6mpmYRKk+WPDNA7K2cBawmchBSsd0eOUCmHKMaAjjcaXoEC1chjSzK2erE5KGCAITVtmv4nAAqYRXKN8Umjv0ERYb4wkKgGv5VIJ4G8F2XWI9vWWWRs84Q+bBihsPqewACwd0ai3A3hxm6jB3IKm8xF7JmCf2epIN7clcBMjSlX6MAFgi6fsIcmdAid+d2Iu5NXb/iHkXJOHctxyDqtJYlb8c2QTAwUQR04iGjmluFYwrZLdnch8byy5ZgnGKoU3BH2cipFx5R5klCnWTfonbXtivq0UV8/WgHFV/0vWLuoHh0jUmJHqLDo0b3fdAaHLASgo9uiKpThMkc4qbJm5AvvWfLrof1023e21QO7LG/VrdYNdv+Xrc/c0wAAwnzfHd00QviIESo0fKt06chQLVDrH5i+QlCiw+nVzBzTASLEDdiKqNHYBRMDjdW+mQNpOTOaoU1FKiYMkGpsApD5EMHL2tkqj8dzaHK4nzMvhG2cxJshZTpOd+Pk5rfGBZvCCpodVmy0ul7L1tQXZ3Cl3ct2YZfCV3CqsQ+wp/2QNL2ECqTJXwVL+f5S0i2HqTeFPYl1lobVdCOCtOEH0VONLbbXORJc2NdwY7ljWhh/Wf0rDcNe1vbn54yQ1s3j2uMtJhNTqxf5ADXTKdlflcgNiwhDiqP1cJ4IXvRVhafai7QlDTZt+3M3QJbo38cNM3Z+nDq29clGkiKE/Z+bFihEOgTvqNz3cjoU3PVJTkge26EFmUVeEu7JromrBaXFzdT085DCcFQgMG2Osv5ajjChUmhDIK2xqU90fnL6yvPHsJ9TLKpjxEpNbsGatXYeJ5sQ0mSm+TkM3CI1wlSBa1A8ymlOvjRCmto4bgk361MExfs/YEuYI65wJ5lMv2gKP3jd2r56de
 zV/aR5tb
 9yv41pAdhZ7u12vDbAHZue8tXaugvdIbHkIs00emPw7CquwrEKQzP4wITLkc+OaFd268VklJT0LTJJQS/7wM9jfmSEMVb+b4+RHfbJVSPGh4GM1paRQObtH4vQnqyn4GuGeWoaiY7I2mcknCZ5pRUtnMXzqgJrh761V+XpxMzoMxJEZPg2DekK5Jqc/C2BKabYCUiMnWxLHvm6mX5pC0viM6XP2CrCmnujbvncdiNPE+3LZ1LrBbBMbRo2/ax1o4fByG3igVlmgAjZbS2miAdTboS4xDMG4Yl/fZX9+vCV0kji/pJVNihqg72jTjgNJ9TILWZDOeElJTJqJrs4gnWE4sH0iEtgaz3Oqv1MizhEh6cVRberAIIiYJcEUEfGb+SxH4rTjiosjRNy9QotvypnpM4v6iDZpibFYaUPv5wCG9jfaRapPfhjTQJ0dYvNpv4lGHPb5++70jVdRdz8MFjca7Nixkg3IQvV7vS94v5ACYhZu/fNF+zywlxMpLhUsV8cl8wUao/hgvA9zymNoAC6YxXCU6hs6UCy/fYWFRxUMy5g/PQuGfEHI25bjrRTmRur8PYndO6fsfLUDv6cedwjPJQLwpJljBi0V70vPXMfh2x9G8wulhMkxE4DJA+G95WVuMsX2cgzXeyyqbSDhEHxB5smZZDopw2SiTh46fV5wB/LI4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 02:15:26PM -0700, Kees Cook wrote:
> On Wed, Jul 16, 2025 at 06:38:03PM +0100, Lorenzo Stoakes wrote:
> > We make a change to the logic here to correct a mistake - we must disallow
> > discard of read-only MAP_PRIVATE file-backed mappings, which previously we
> > were not.
> > The justification for this change is to account for the case where:
> >
> > 1. A MAP_PRIVATE R/W file-backed mapping is established.
> > 2. The mapping is written to, which backs it with anonymous memory.
> > 3. The mapping is mprotect()'d read-only.
> > 4. The mapping is mseal()'d.
> >
> > If we were to now allow discard of this data, it would mean mseal() would
> > not prevent the unrecoverable discarding of data and it was thus violate
> > the semantics of sealed VMAs.
>
> I want to make sure I'm understanding this right:
>
> Was the old behavior to allow discard? (If so, that seems like it wasn't
> doing what Linus asked for[1], but it's not clear to me if that was
> the behavior Chrome wanted.) The test doesn't appear to validate which
> contents end up being visible after the discard, only whether or not
> madvise() succeeds.

Yes the old behaviour allowed discard in this case, because:

	/* check anonymous mapping. */
	if (vma->vm_file || vma->vm_flags & VM_SHARED)
		return false;

In is_ro_anon() would return false (we have vma->vm_file), and in
can_modify_vma_madv() we'd hit:

	if (unlikely(!can_modify_vma(vma) && is_ro_anon(vma)))
		return false;

	/* Allow by default. */
	return true;

The fix is to check vma->vm_files & VM_SHARED only in effect.

>
> As an aside, why should discard work in this case even without step 4?
> Wouldn't setting "read-only" imply you don't want the memory to change
> out from under you? I guess I'm not clear on the semantics: how do memory
> protection bits map to madvise actions like this?

I mean this is uAPI so it's moot, we can't change this.

I think you're thinking read-only is stronger than you think it is in the
general case.

VM_MAYWRITE is the key thing here.

In do_mmap() in mm/mmap.c:

	if (file) {
		struct inode *inode = file_inode(file);
		unsigned long flags_mask;
		int err;

		...

		switch (flags & MAP_TYPE) {
		case MAP_SHARED:
			...
			fallthrough;
		case MAP_SHARED_VALIDATE:
			...
			if (!(file->f_mode & FMODE_WRITE))
				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);

			...
		}
		...
	}

So we're only actually prevented VM_MAYWRITE if the _file_ itself doesn't have
write permission.

Otherwise we might at any time mprotect() the mapping to be writable in any
csae.

mseal() changes things, as it's a stronger requirement. You're explicitly saying
'I don't want this data to be discarded', which is why we should be firmer here.

I disagree this needs to be changed more broadly, but in any case, it'd break
uAPI so it's moot.

And wrt this series, it's further moot.

>
> -Kees
>
> [1] https://lore.kernel.org/lkml/CAHk-=wiVhHmnXviy1xqStLRozC4ziSugTk=1JOc8ORWd2_0h7g@mail.gmail.com/
>
> --
> Kees Cook

