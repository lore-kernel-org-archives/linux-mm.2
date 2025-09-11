Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C05CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7DF8E000A; Thu, 11 Sep 2025 04:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898458E0001; Thu, 11 Sep 2025 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7606C8E000A; Thu, 11 Sep 2025 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56BA28E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:57:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D33D119E9D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:57:07 +0000 (UTC)
X-FDA: 83876364894.27.776E956
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7791E40003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:57:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oGyLL/Ck";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TVyDbK9D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757581023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0RrDqlj6OZgWuzkVtqvA2bMLDFwx6aL5F3XSDdD56w=;
	b=4sEedAWCwG2vPT4ZPb5nksj7/VdWRfSzpaIQZWX5bT8V6jjfYvaYx03TQ2PIkiSIHfxl47
	OPlawM4ZFMtem0PI4rlRs17k1CwSBM5jIJ9mx/b0aG4Jsnj1+kuwbvKnGBM0vzh5QcIauK
	OneMMDqhDCFRcrmqdJek7Gs3+6aAMJU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757581023; a=rsa-sha256;
	cv=pass;
	b=mHi5OJ6r29HEFc1OEKE3qdXhnaPWoaoDds0/zQ/QoitpiklJr9wJE+xLJb5YKAdXwUrjIh
	pv3hWCmje7DLbHmpByvZczV+FXJlnbqU/IxQITudFv3spHxggHiddlHZ4+GujCIZ3NDTtH
	oY1dPWioe9FFABgjdc9tMTeLeU40H2w=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oGyLL/Ck";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TVyDbK9D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8fxRd021315;
	Thu, 11 Sep 2025 08:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=O0RrDqlj6OZgWuzkVt
	qvA2bMLDFwx6aL5F3XSDdD56w=; b=oGyLL/Ck4q6Jb+p9Om4OjKmQ8oHP3QuWwy
	x0EOGZioMJEt9JKp7NsvGMjZM8PMpXMa4fIwynymcamCF59XaQdrAcdQ9SNMz17N
	TDlofj66b0v5DKFLfckjOhVrSyJ67pK/LbVFfaBXUQsPz/28ojW/jeINQ1idYeZ9
	/A4mwLsvQh1NWfjBLTGJGV5K6Tp822bjSLX3myOOAq3zaiefSKy/qvvQhf3E/rnU
	GNcltCaNZEfWBN+WqhTyI/TtdDievopVZTjvZx2mHGZVP2HbLEJgm3XF2sQgGgo/
	PcudhH27Bb7Zb2uHOxsIzG1tvc1eGHxS7XQlVVifz7bo5QI4HxjA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1p0eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:56:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B74SJk012877;
	Thu, 11 Sep 2025 08:56:51 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdcc6s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:56:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pk2K2nN8vYdCBapEnkmyH/TaHI02TLhujFgvvS0BFDX+bKx19jnd4zZwvfCQDkELIj8y0g110eYZzLKCantJKVE2Ezs4o1T4723zWjgwmDilNmakSDl3Coj38ZQkiTRCcB+HG5k63BKybR7Ohh36XjJiOExYYlQ8TJPyZ3V7vYFTZrYlyLUs90hCulnSVIvZ5WV7CuWpoD2EzEzPaujVXX18OvieBml3frrCIzC9Gmuz6+kGmNxfs04ROFh90kX8ExDxK51QHaZ2k9zeWGFm//n1UiJ7G7KKBX3NweJCYnhdghmqhX4Cri0Hafare+AoS6D8OI/xgBvcld+y4qIVWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0RrDqlj6OZgWuzkVtqvA2bMLDFwx6aL5F3XSDdD56w=;
 b=PQqxgBvCZKvwtfqVPFVaGI9y36sIoh3tsy8VhNpqcU8Ui0yR9y+bKPrQ7ibth+xwvHWbRdg38Sq5mGRNZnjvp9tVMiAOpiWNt0JiCvHAjFtrlFBtCaejp+f727p65zeM1DAbROZ+R3qzllRO/pem9NU9bZIAME3lm9+knWA8nYaOVTsFv4bWuv8Cm3UazVx3Mp1p6jxeOykNOpWZeVl8umfmbLsu/q/c9UQhCmMj4BjyC7P/X3KXkylSUcczNLqNFkRVCu1MqQSS4pWiDRiyq1DtTk+ZUbHLAL5F9j2H6f3orpAntVSNpzEEfJlyTIYZmfwu1+xTlnNN/duZ1mAH0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0RrDqlj6OZgWuzkVtqvA2bMLDFwx6aL5F3XSDdD56w=;
 b=TVyDbK9DdZjRK32+rcyemLzWw96iPIoV6TW2zP0Pc7hx8NvHJioBOlyvpSZ8vZg7u++5vf+jK76Nr5421gDdkpw1IN+ERBRXO/girGsjgbn7uRHKQE+AbOVJ1Kwqq1itoQM79LhkqgrTcNLKkDskRTTNCA5RaEnZIOfGbct4jus=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA3PR10MB7069.namprd10.prod.outlook.com (2603:10b6:806:315::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 08:56:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 08:56:49 +0000
Date: Thu, 11 Sep 2025 09:56:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 3/9] mm/vma: Add limits to unmap_region() for vmas
Message-ID: <3744d50c-caac-4208-beb2-0cb3c6889b51@lucifer.local>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-4-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-4-Liam.Howlett@oracle.com>
X-ClientProxiedBy: MM0P280CA0073.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA3PR10MB7069:EE_
X-MS-Office365-Filtering-Correlation-Id: f1a03669-6db1-4df9-416c-08ddf11124d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4+BEoIgBKyxVV173th6lQ9cqFkWYBLFpeA/kZ1mPn9SgCp2dLljmo64M3ZbA?=
 =?us-ascii?Q?R+OK/i4wy7cnLzkhmgW2j7qFqEtKypfNuMYvDltimKPBsHZAbZ3iH6LqehK/?=
 =?us-ascii?Q?whY+HOrwtt1gr+sQEU3iuz6a3S5CGYw2b5oIlYDcG1+BbqNwkpc2WMp9nY10?=
 =?us-ascii?Q?e1Fi18P1EqbAErMOy7s2Lq7Yl00CFeY1kRL/ZHlosZuHQUWwqtqR0muOiFWx?=
 =?us-ascii?Q?sUHWxSgY1Y/vJUykTJ2GwBIuIlArhpGxbSIrJngWjQKmObBEX4LSN6UAjzUl?=
 =?us-ascii?Q?U02shFWWtMXJk0u42aEIfWhbkfA18Gs2OCu7KdOKSUR61MiIjy3efmYTKRzS?=
 =?us-ascii?Q?Wv8H+X/NZItGek5NsCOMawGPPNOUnlCnyGiMLeq2DTXjyXYBlGbeObq+kpEq?=
 =?us-ascii?Q?PcuVhS+CdY5eYUpkTMvzYQsEsnyBKSCM48Kwv+X4OIs7pLvgKDrIg4XUxm1M?=
 =?us-ascii?Q?rif/oQaek+ejwaWLgD9uOy9TtieyIZ4xQFcfTsCYvJ3WiNJgPbfRg0lbCTOC?=
 =?us-ascii?Q?hobkvOuU/tXx/cL67R8m58YZ9z7e0Nwpt9O5Rn9lLkORC3XxvCls7aLLQHZ7?=
 =?us-ascii?Q?unIF8hlQxkAaEtZYs5yYPKnvYP8AFQd9e3BjfjFrEgyaeVGpm70O1+o9Glpe?=
 =?us-ascii?Q?Wm+PX61P2zoDs3ifoyh1WsC5ZurUEuPSuHiwUzCxYFiHAOeYdZkSuWN6mep/?=
 =?us-ascii?Q?fYS6alcv20wxFiAdzD7dPlB1/4enwiOGgZkZmeO8nGPc0BJxwBLbBZaKJnGU?=
 =?us-ascii?Q?Nj7ECVhVPlvOMHhBFF22vOPponRYdhjww8lwgeIYzRRNMfTG0f8DXkKmlSDL?=
 =?us-ascii?Q?5pGmfrE5Qiw7t13/ewNLk4LT74YB43/kkluX07RC2StmmNaM1mnuINmbBmGt?=
 =?us-ascii?Q?A7DKEVUtT4RZyrEpI3qHzvyKzA6xC4q1uBeTPVCHgmsmZQIHjwabh/ZzzA32?=
 =?us-ascii?Q?Xo4uzRctSCmawrqc90iHaDYERBD9YXGn9Gn178NCgL0kOlqWGFa/KJi6rEyL?=
 =?us-ascii?Q?BU36E6NFdgR22iAkvDun6s+qsCz4bHLyLAY+gQ5+0HMwyYDKHqvkPc8bj36i?=
 =?us-ascii?Q?EozgXYzvc9suFBftvf9y0RbiMJojszn2dVsw8Hcw52g4aIne+eFGGj0oQotC?=
 =?us-ascii?Q?Vn1z+xXbE6lGnNvgE4RWgwHiGYz8dhGG+ykSmgqcVnsbGWgzKG7Ckvm7SkDE?=
 =?us-ascii?Q?ksPUPo5SSLLHG63OG/1kLlsguqjtldoUNorjdfC9MCubOgztzV/64vWjyGuW?=
 =?us-ascii?Q?O4fKMa+0WUUl9RfcQSe22UrSTbZonX1baIk+I2HV6JSOtLSFpgsJ5ZIUPE9D?=
 =?us-ascii?Q?fEq20z0SEaavd4XerIMFe/UduNNLhmC4viS50GRXsFxq1CTTCBEaEYUOJChp?=
 =?us-ascii?Q?85RtTdZOLtIC6Z3PXG0APoQJWJvAzphV2XpMY4rbIRWjnWhJLpMu/KJ2ahep?=
 =?us-ascii?Q?E3oIwXpcMZs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t0QZ9J8tjghoF0iAoPX87tpq9PyZ2dtqtCLVaA8SUtLgWmYWFvs8/oafTnhB?=
 =?us-ascii?Q?mVLlDRuz74XdKUgBD3QnaAA3wWdRvOAAwH+ky8+XWYbzftK/bmKLyfhfeNV/?=
 =?us-ascii?Q?PyW+wVdvhfu0fDXaprSDwcK1ffh3TOdTSVRGkSie+bogsgoQCNB6GhnOwEsZ?=
 =?us-ascii?Q?kEZANAxekZkFR3jLSjBLVKTzSNH0DHoJtXlV14r0DQaYpoverOWx19MEJXtj?=
 =?us-ascii?Q?2w4lydYxOhWvbJsH2wxQKoV2zVgMMoH5SrS7VnapLeOh4ncsepQ1D504qlFd?=
 =?us-ascii?Q?gxEScQLMMe/vMK6Xn8zNABaOAgIVDKRxwIaZyxueOeBljj5Vo9DbvR3fuOXp?=
 =?us-ascii?Q?Vni4ExrewJ4LyZb6cpmSNjYkCc44wyd27AiZZzvs8CHF3/j1tWSv56n5dPia?=
 =?us-ascii?Q?IXntLgnUO30mVrWn6J8EFkILjJXDOyOYE4os+LB7hUVqX4G7aRKPFx0Z5ynF?=
 =?us-ascii?Q?oJfMOCEGeGEqQiebcrbsrJhSFyc6Jq2yvy3S6oMWpGuEISljX36jHFZ37ype?=
 =?us-ascii?Q?Jel/OIdtfYmsxMaBm5IxTLhTbdRSb2mjI+lMuSA0ybBbbArExfdIzxePhip9?=
 =?us-ascii?Q?gOJiirZZkafMfhSJXcfzYaJFbxYWR1UzoKTTEn8wnyXnGaFOnIKs4YMvVGGO?=
 =?us-ascii?Q?hLfDcchavucUYOkPsuGMk+5Um56pVzM3S96roSJlUxztw06oWf2hbfauJ+2c?=
 =?us-ascii?Q?hx3dzezKx537xstAlaj1ZAeXJ3K2xJK0VYU80HOoY/3HBQZ0lfyv8bZmUYNN?=
 =?us-ascii?Q?9qgmY1m8EyI7LAwBFvspeScyGYwWgdEUwHKluWrNCWPp12eDJvH/I4TAOLE/?=
 =?us-ascii?Q?M9yOxkFPLCHCSW9hX7Xc0M5BVaRbyahBsZAnZvxt6Yd5iY7Q3Se4ULY2wPZF?=
 =?us-ascii?Q?93s7aTlftPGLtqAlUtYYQIG24oKocN7wdE3fFomRoSX11SNPsTt86S5pbGfX?=
 =?us-ascii?Q?Rh4F9rv4kSvetskQ/ALjUuWUXoUSbPErTwydlWR7Nj3GRvRBaCkDRiVMYvTH?=
 =?us-ascii?Q?GRgXBkuG6QSPUU2jRoYbRLqUSvSKU+QaAoM2Ob7wZifgreTh3XiyC1DRMSIT?=
 =?us-ascii?Q?00TYjiruQtnalPYvj6Kg3cLZr/T9rrfqRwTrfvdZteUVHhP3OfhkzgRPDNbB?=
 =?us-ascii?Q?tjLswDrKRJYmJWfltyYJP0P4E8zEXJSWy0WvC1oFfkbbSWkDiHArRJblyGuw?=
 =?us-ascii?Q?D50uucYCCk1Gpsvay5LwcSNpsEMx7nH2eVIwRJluzMIITEsJDZEsVg8GEO9H?=
 =?us-ascii?Q?Cow1V3HzJ5kqPvCjMCzN/XeevCgfW0sbFvv8iOZr2/rDmc4de6eqbcGSEqJi?=
 =?us-ascii?Q?jjgBjiF756dQtivOZ/lu4aHJzflBe1ak6tvt/d7zPEgwZ/16KM/tyGmWFQvx?=
 =?us-ascii?Q?aXQY+0cq5vElxAlzbRCissPcOo0BiQh/9E6Kdgb+uUZ6I6LqUMHewgdF9QD2?=
 =?us-ascii?Q?gJ62NjV/MYqnaksDH9IQM8IhtMzgR0gz0fhNuBuSE3ghUoc+ihxbAjvnAmGT?=
 =?us-ascii?Q?CmvTUhqa7zpQ4M13410p9A+1KCut/sPSqNL/m+EGhF3E8JSBX552bMx+0+nY?=
 =?us-ascii?Q?1pqZv4YFLKEvuiP8TkBG9ccXZKcHUvWVz9E9BaReNdcJsyDhRil7IMMMojOr?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5UqZ17eFpUp2OrcgWS7+F6uUuvw0mh9t4L1dD8Xi+AdrV6cELSV7WtTpPLo4d2fOwL9RYXjUybeS0ubEUOojGwXireR/aCiSt0JPXIyXdW16PP764iIT1g7Ogf0Z3cynsZDLZOMZhI/7sMXraLpY1Utp2D5MlWQdtu5dkrn7VRBDybqxXfObywWyHlWXM3dPcTy8nXj4YmJI+LgiJjUauxRF8Ih8TcgjRMD98oECNS/M9CFrBd7r+kZTgciqPFl+FJVhv33Mj8tXvtLext2Qj6Cr809XiQxkCOmi2/JIuvV9co3xJH4ZdOCxRHX3svnSkvUl7Jq30sZ6f7RkZolSRXigOLVFidy/yYFLu5bKm29NZF+4FkbjnjxKm/q9a11YveXhHAj9bKJCVjwz0FDKIJBMuQE5MZyVp8+BOq9bZWcgk5t1TIyeFSU6ItJRiHZ2VyKRHJoVfrgb9NbL2t3vfQYIx5KABFIwuHya6yzQH7mPBp3XGlO/4IG2HSj6l1NNYmEkfG3hKdFMfT5WSOk48ok54Kr8avyeIb/C59rBQoKP/67cfFw8FbuGC3SojviH6e74KfD0kbpWHc61JC+IftFZz9QGWTYAhSCJBA+RnIA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a03669-6db1-4df9-416c-08ddf11124d6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 08:56:49.3117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3nnj4wepz7K01tsjR17nFT9KZXJbT2kLQls97iiL3WGjYJw+cOedzspmQk2doYBGwGpXQnYU0yTZ/w5NQ6BdomQHa8BkQkJYXC4Z1Xw8i4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7069
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110079
X-Proofpoint-ORIG-GUID: KMDCs2rMTbK5TTLmb9rHgNCVa0Qdmgt5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX6pzCvSNURNNZ
 MveUw2GZ83uP8AUDBZWyHaa/7qcB27/sQkMZBPq7vAElqnyH9St5H964bPydNk7lfUiXAQTgE4Y
 D5XD6UpLuG4iNrzexQeIi/X3e68fI3uir3EM8b0pk0IJmvuzyRx4xADjL7djgtAd4appoP8qGE4
 1tfu3rAMDFi+zB9LtIK0UKFwoXdWzA0zEpb+goR3BmxOwmTFKUCVRvcOxy3/ZOJREEzF0tG4fC5
 QuQcKV0GKYsEgNuBztuAD7BvqnwWppnjELp/SWDhJaD7oE3W/+qR1YnuWnLplb2gL80xvo7bFaM
 S0OOkbsG33E6ibr9RPbnms3qPpqeMV1JxH3u30Dq6SYs7htst+7jSJRDV95+pLdBF/F6t6FCcbJ
 bZuSDn3f
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c28ed4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=jNs0LQAXdRVa_bgHXP0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: KMDCs2rMTbK5TTLmb9rHgNCVa0Qdmgt5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7791E40003
X-Stat-Signature: au4tfdwd8mqj35rs4o9ebz9wmuw9rkkt
X-Rspam-User: 
X-HE-Tag: 1757581023-61551
X-HE-Meta: U2FsdGVkX1+IVjs0Zg3HkJaJKoiMIDfCfQflpO/D7LhZhbsRCKEl1JzmAr5btBEL41NENljmGF0YZO2tJRkwYiFObuGppSj6wqT8eQBlUox5LOadTPDc6mioegViBPk485M2S8v6rCLVfbXBlK/jzwwhtuprsLbIXYdbviOGuh3Yh7lShhb3Eg9HuuG8vgjam2o8Z5LjRQ2k8vfvu1AthCsNC6YgudA7xRbyLd0sbpLnZf4j52KJFuGP65msj70PV6BA2y4cNII1ctCbGW5+Uodjpy37TvyBYy0AqzC0pApFU4D5axL8zooyeaSv2cuSnGte5ONAeApJMa+XVDL4/XHEsmV6lgF46QriArG4wNZhU/fgH+nsNprAHFMg+/RteBJcf0hb1qDLFID0l/Kq0wdnBfRu1oxKJWlQMkK2+Qyzc73vBEdUxQ/Yl7kTvEnU9bbHwc7S3B0n7tjTc6yLJQTFi+CpPNru0uF3g6QCOMRaOTqSSMqwojOcg2/7oi2IVQDTp98U9nRgRDPBG/tUjb0MGCf02q7KoXTegqKcHugTZShIOZ+l6BqvydXKPzxMcwx2aU6rRuyQWKq+2pKXxHoFthxh0EVNTNmVdQx8434+7Lyiohk8GAuBdu/xpnij18+NLIWnRHQEmXDiJdbAqulOuwXjVvGlag2vk6zUZT+hawg1WTwU5JMgGZYuumLpxvLSj4lK7bq8jCkNvPbE6m+lyq4nf9q9aF+UwFpSrbdidO62Y60fTNNuFcYk7dK6veBCnUAyJB8AGCoqp8s6gN5Th27olj74Sb0Hl0Z6XGUkaCHd5GhtQpl0Z/55VvrBb1cUDVv9CVKpFzRk0O3GHR5CTsCBfi+brxXNZRtduVJyftKYrubV3N2ohc3GMPQiIssZ/aiZ4kmeOhvePTYpyOmmfWsJ6D+meiBUrEIakL1o6CRW3FQcR9wJHhfnDr6mZDdo3xymuJ7DS5851/I
 X7omLhA5
 V8uYVYDAYupnjkZpG4pH84kyJxfM77FG2Ofw+7OI7pkuUfqGaDoGAaESDL3wl3rJTRdBuBv16LufosG89/FT9JTTRcIXl4axmLT40Y+/CY1Rv+UBGsAFllhA48rtL6xynUsjmlEVpe/z2D/HgIkgm08q3+gqZF94Uhr8PPfhRCNBnkY+elHybFLcbl2k9HV2PsBOqUdVh/Md0a0SjGLx/dEKVKtZdde4++3CVPiGiQ6TdQSMG+EFRh+bmBVMcoD5Ykr3qF+NGjiFmunmLtMvkFDTou8ssumGb9e4bV3paIx/Fm1GBSDudERx6kAA4P+/zXU2Ldiwkf/mC/7sqLjBX2IZ2ySZbFMIaPM90rxuuskRk0iNSPw5KJteSoKdz7c+5/ULa7W4B9PCR2xSdkVtSY63k3tKGS5w2WjNrkK02JkNPfmAKCpFY3PUW8sNrudeoI3a6MxeWQGRQWnlPvpOKGRWMcKMfXSM7hyWD0pDISvqGekJ8/Vi/UdwLOPNnghwdewVtfJFU6Kdo9ClI+KJJj/L7a4+/52V7x2jOE1efnlqa5BGDUDMaLY0hmmmbD56hRimgfrK+nvxY7UFUlIuG6voshC4FT/C1zWIwZ4GroQ98IAVWCmItROz4IfV/0nknstF9g3weaD9o5Y5xb66zP7iRq06DU4qPFBqZhN2SMoNZEsY3jcczO8WuWtqq9YYA7AKjr2cxbyK8HL37tW0/Gns7oFitCjsKT69ivxQSrGnr0tcK4uyyi3GLIyemZbvmrWKnth5P0tk4q4vqOkX0p/FTC94XprGuDMlTLXLu3P6mLIHEq9ENsKZQitxfEkYDIMmG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:39PM -0400, Liam R. Howlett wrote:
> Add a limit to the vma search instead of using the start and end of the
> one passed in.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

OK I see you are splitting this up then addressing the args thing in a later
patch so that's all good :)

One nit below, but otherwise LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/vma.c | 6 ++++--
>  mm/vma.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index abe0da33c8446..a648e0555c873 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
>   * Called with the mm semaphore held.
>   */
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> +		unsigned long vma_min, unsigned long vma_max,
>  		struct vm_area_struct *prev, struct vm_area_struct *next)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
> @@ -481,7 +482,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>
>  	tlb_gather_mmu(&tlb, mm);
>  	update_hiwater_rss(mm);
> -	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
> +	unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
>  		   /* mm_wr_locked = */ true);
>  	mas_set(mas, vma->vm_end);
>  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> @@ -2417,7 +2418,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>
>  		vma_iter_set(vmi, vma->vm_end);
>  		/* Undo any partial mapping done by a device driver. */
> -		unmap_region(&vmi->mas, vma, map->prev, map->next);
> +		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
> +			     map->prev, map->next);
>
>  		return error;
>  	}
> diff --git a/mm/vma.h b/mm/vma.h
> index 9183fe5490090..a9d0cef684ddb 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -261,6 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
>  void remove_vma(struct vm_area_struct *vma);
>
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> +		unsigned long min, unsigned long max,

NIT: you're changing the name of the parameter for min, max to vma_min, vma_max
between here and the implementation. Let's keep that consistent!

>  		struct vm_area_struct *prev, struct vm_area_struct *next);
>
>  /* We are about to modify the VMA's flags. */
> --
> 2.47.2
>

