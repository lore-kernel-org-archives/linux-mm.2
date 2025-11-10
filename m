Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82194CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D688E0008; Mon, 10 Nov 2025 08:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4EA8E0002; Mon, 10 Nov 2025 08:53:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACCA8E0008; Mon, 10 Nov 2025 08:53:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86ECF8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:53:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3468C1407AC
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:53:14 +0000 (UTC)
X-FDA: 84094839108.21.2E849E1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id B93C3140004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:53:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l+zZVTUf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=khTV2o7F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762782790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfqNGLcdVBhKL7dpcqMZrJ8HAfyN+En+H5l7fgIw4Rg=;
	b=mSYsaDDEf86DCLqNSSn7YNFqQ2gHpDXP6kD6G3pT94X6mBvr7E4VW28vHEX5dShj6XMpx/
	sP7xFni/beoyoVdM2xJEJEbx1OJAexc+RuK9jSOGRlJZfjReL476rSHrYDNTfzUlqFYOrN
	MGO2dHMmu+EFzkb3PWl79ATOhPFb2Go=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762782790; a=rsa-sha256;
	cv=pass;
	b=7mfrePNZ77WIVKkKNCChDwMoo0gH352Y7vHQ0AkCvkt0APh7dyLrirQDXKR1lWXy18kAPj
	OXTrLDxEwIrkt1whwDF2s6PwdNEULSzkqHh6AaGtTZrfj9huz/XiwcCMW9ZIEIxcYRAUW2
	TwEbuT++ieF0AsBzntE2TTvjqpx5el0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l+zZVTUf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=khTV2o7F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AABhNSH024221;
	Mon, 10 Nov 2025 13:52:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HfqNGLcdVBhKL7dpcq
	MZrJ8HAfyN+En+H5l7fgIw4Rg=; b=l+zZVTUf/WNfa3Rp0qflqN1220ue1Hu73B
	4q+1aMoK2+5jzqCAc7pYtTwuNxH2er30P+92H3/swHkqT8SOMrrxjQxNHKnKfwyZ
	jmC8kYr8Z4YAS6qE5FII1x4XTX7I/RlegO0lS2twjdXvalWbaw2Q9JT1irjvvvo/
	eZIQ7viHn15fHk2K5Ggx25Zhc94L5sPEncT8FjYz5H4V30nUyzWqTumNM4Ch4sUt
	g6M2SsfxN7pJaSD/tqrKevNICtvekX3TjHsYbUmviVfBMT/sSSeIs+XWSid1hFiu
	CG1llHABEoGxMJKJDZotOwdnbOneKeF54gI90kWQ2u0fjfmsalLQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abepk0av8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 13:52:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAC4tYq000889;
	Mon, 10 Nov 2025 13:52:52 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012069.outbound.protection.outlook.com [52.101.43.69])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vac6715-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 13:52:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n3PXPzeT5Pud52xoCYFnVWpJ0tgS8TALDxkhJ/DwgtCKdRkJAOjP6vfCNjAyyvv9aWdJxhOcRCKnmGvpm7z2F5Gafga6V7ACjxcAZkpqpViZ3l7tcLL/ZzqItkTgZqnVfoTChJbCKpPjP8r8HfngiCoTaj25RANAEbjUUCaqQxajdb49X2ngL07hjfngSfd5cgzUW/YMruDdf3nL6KDlv0Rs0eoSM8bXf5Qfw23B3EHIjwGVKXV/4aHe9txYxcTPI5hxaleGeh9K0xykEgLbKhB2eyDKmzjaKiw2rlPxgCw+gHIhpxvEP1lB+SZ98w6e2APIu5KamQQyRgRM7gMzMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfqNGLcdVBhKL7dpcqMZrJ8HAfyN+En+H5l7fgIw4Rg=;
 b=M6guIQGvcf1QaPaRJwMK//+spBvqM/5+QTK1R9BQ3WDGJnBkrf+qI8cQI+11wdmyECuB98atkFDWEc39kf7zhW7rwfKqZF1nShkhJRUwRavQZQhHOfQeumqUj5oI9jNlREj/3gcbtKnQxk7cqaIHmRCEvbwduIRN2uPdCqjbWmtL5kcSz1UJOKOYYWYsUDq/EqFUocTDnCn+/LE/J0MIW6GHtFUuU9Fb9GNIR3Cn9v3SblhweamQs0dHhYr3Zpn2PVnStWAA2O8Fp/ZqSBOVtlm5PkgopkUZYpzW/gg4sYaq+2I4mTIq3C/R82z/rILXJLvnqNwMnoKtIs/vuVIHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfqNGLcdVBhKL7dpcqMZrJ8HAfyN+En+H5l7fgIw4Rg=;
 b=khTV2o7FwwF3t08zV0AZcpkocxSvs8g6TirMmkmfrkyhXIppdC1ir7RSwwYi6a7L8Kk9FqFHUQg4aDSDGkRmqOM66/hA9rZ6oT3ZN05PevZI3Q3vE+F+NTo7UekU6ZE/m62QAaT2O/IpHoODQbp7IOMQsoaCiirJiFOMbyX0Jhg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 13:52:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 13:52:48 +0000
Date: Mon, 10 Nov 2025 13:52:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Shivank Garg <shivankg@amd.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRHs3pA2kOr_uD3k@casper.infradead.org>
X-ClientProxiedBy: LO2P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4680:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e884566-62b7-4ccf-d2db-08de20606f2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?62BQLY92YeCYjfCJyePzZXJlIKdT4ssEamxqKlYCp+FJa6Ahr02zeYyO+m+K?=
 =?us-ascii?Q?IoNYMLpBSH3EQe/6ifXGSRAjv6HRqcVLzlvjmDoZn0pwqKnG0wj26DlUoxOr?=
 =?us-ascii?Q?T16pzUIaJJk843xN1Oe+It7A9dY4lPxAxh0tVIpP/fn8j7WAF5m79Q2XDeiJ?=
 =?us-ascii?Q?pL2D1CoXez7OxFTs75TXpVKajT+/GALWUUwAzkCUQ1WYdplOe6bjF60THAEt?=
 =?us-ascii?Q?thvbJJFNOkEqr6eoDd+1IjIdiHYJjsAYFH7N+N/77e0TT9A9pgT3ZJMr6Dvk?=
 =?us-ascii?Q?BmaUC7fHy3tuA+r+HyLfUZ0G/jrnkjxXIq372DG1tGLt0/dC/7OQ7LKnstCa?=
 =?us-ascii?Q?etzl8vwUm/09w97Kmsx3GSYrSptmRynJU9wOwyxJo8CoadzGk+8nC0wjqY/i?=
 =?us-ascii?Q?MDkxU8aF+B7lAClk5mwJUokf0wYSEnyS7GKQ2UAqfN8vf3PPrOHVPs/zTa+E?=
 =?us-ascii?Q?z+kX6DyPUdjWKgj+FIW2+ywoiwusohyjyN6AUk7Axbtnq8kbf7djPNrvsSE+?=
 =?us-ascii?Q?8mEGOAOZsvj2BaWmUjQ3OOhZ3RloB2XTjnAgaYfauixPfaECT0HtFoiV5n+y?=
 =?us-ascii?Q?CwaVRMzlcPM//0eWG+0JDBJ1cSvOdi+bym4jO/XLaJENIaDViNJYbWl1glmY?=
 =?us-ascii?Q?3wci/Q0l9OPejzFBJShS6DGbILxUqaQd6fsWbxcGpWX/MMyDWNQwXR1Wh0xG?=
 =?us-ascii?Q?+C79DSZu8etmD7wXHABggAbWyYA/WkXmfcrDyAQbn+Vlb15t2TH3/sk5LlXb?=
 =?us-ascii?Q?+EaZlCfk24tTb60qEaX0U5vxxKmDnDIdAEscWJ/Ovpu0cWy2TkXy2vQ9hTC6?=
 =?us-ascii?Q?6/Qkg1P6mSrlrd+P/t4wA2GcmN8g0FYfPwEDva1RAgLBsD46F/MIHoV+9oZA?=
 =?us-ascii?Q?xUHSnXSu9vXLgT0nq/6DaxrmaW+Ime/oa/RGI+mJcSMTLosImp284zQGd3dq?=
 =?us-ascii?Q?vhAwXzm4Rmxa8vRM3VeqzQUxV1x4nPKAIXQICRA/UJVpAOHPnEl3iC4OHmsM?=
 =?us-ascii?Q?xRynbd0DNJqfh+TAvBEfEkMbaUtPLPs8UOn41ZFBWKvvUM8K9t0xgTwPsmB5?=
 =?us-ascii?Q?GaB6Xe6CajA5tnuxobq4iLIlK+emvC/fvzEyPWN5NGO8gHuOkyd1AFHoP0aE?=
 =?us-ascii?Q?H2c4+KOf9moUcXWGZ9/bqVLuqXsqao351+BPYAVLHFCcHulF5nXZ8jqTMNWu?=
 =?us-ascii?Q?QKalSzUsBoeUU+wCUASoCFMBe+2nfABoa2JwtApUPOfj5RYCAqfFdLF3cb4F?=
 =?us-ascii?Q?10MQJhn7rEU0adKEfUp2UQ7/ngQC64aP8HipFYvD0lo7Nha839gYXyBG8/bX?=
 =?us-ascii?Q?cKsTSaEuJOXpbIMhs38SgAfTqZuSNAa3zfgG9nmdyEARy2flF9Sa7WWaXTng?=
 =?us-ascii?Q?oqufuQ/Y5s4n9/xfgjrIzl2HZqktJ+3kyEN0cDpcZq+qSllZku4ZqzmUks/h?=
 =?us-ascii?Q?GZiGZwDBq74V3w01opEHBpxqqd1yTAdf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/sYCrDrUdhH31TOj0VMi3yzXQTVJYfIcLflaEA2RmPd5b5ESZTdUIzpf735m?=
 =?us-ascii?Q?tF3SXvQYsn4kVJR2eC77qYZjq57gvYjKqXWWvveGG/AT+NEEVnDSd/uGON2c?=
 =?us-ascii?Q?gbSvw/RyIv1oCrOc1sSPKmhsfJ/Ws917Tq8yklAPnd6XV1sik3+E9Xuiz7fg?=
 =?us-ascii?Q?692sOQMM2wT4JD0b+D463BdD3erOEs95gOjPhvDMYFTSRlufLp7iZR9tBfe8?=
 =?us-ascii?Q?8YkZbnwSc/Csc1AS7ZUBynYnT/NxaQZgdzWRkqroC+kPNJbKPw8GoQDKSGj+?=
 =?us-ascii?Q?EJQkvz+2oy8bdGNztLIXjQdGRwlFnCOQMiCaZ9Rc/XPu7aKk0vDhWT79Jcjk?=
 =?us-ascii?Q?to9wzMqGArQTOzQsQC07wOJEzqcBTtNpeq8nc6AScPpYnOeb8v+CUqeYa9dK?=
 =?us-ascii?Q?z30MuSN+lQHSrOtj20mSQ3KoJTf7XeUSd9UPL/k0m7Wis3PIlT9NL5V38fYP?=
 =?us-ascii?Q?dKCojUeAnp4CdvdjB6HXJq5YrEEZ/VdTrAkE+hTutj1vGm8TLaYpaIE4GpMx?=
 =?us-ascii?Q?qPkI+38881hOdkA8lTKh3VRlmn4xVwCEUNav59aecxSCXgHO8PAT61c6cGLN?=
 =?us-ascii?Q?VGEfNsTgRzT7Kwqrarw7FWVVjXK490L5B0ZrfuO98CkwP4CZn/Tu4EANYBVz?=
 =?us-ascii?Q?b4pnB9wKq0WtwV0Tg0t4JqomYSI6MZRturiTHfPE+zKhbIQiiHeLv+lBn9UL?=
 =?us-ascii?Q?VxGSUBvFUd6SOZTLH/2JW4iOLtTyqBXr6JL37hy5JUa96b6ZWVfx3auyiZx4?=
 =?us-ascii?Q?MpChV8dSf+KxVpksn/622l/g/rmFGhydQZ9ilRqkAUvSyBGNNDwBRJNwNInF?=
 =?us-ascii?Q?Q5KIeqzGPbjjnufK5vGftekdXOjINvzVG9S6iRj6TIIAvn5kI+o368Xh54ha?=
 =?us-ascii?Q?2/z3pBx9TR8S0BjduDB1y656389foETFna5KJ0A/uaQnckbstRxkHcApdQLG?=
 =?us-ascii?Q?wOEx3NyUI9zSND8TlRLDlwqVSHPfftyup7pzNGn9vBEDCQIOffpa0PMHXpR0?=
 =?us-ascii?Q?tlcmaoz3JxTGsZekBwKOFjo6wBD7dVJz1CWbYm7oZyWjd6/tTAVOLEka7gWE?=
 =?us-ascii?Q?6w6v1dnVwh+mSpL+GSgSxjd2MaIrSzqDdGMoW+LXZp9yV0bQ/GcdoWNFiniS?=
 =?us-ascii?Q?Ge6iK5/TumEv+PewtXjzRQmX0EsbOMagXNglrjqagezrCEKyhY7XewgbubK6?=
 =?us-ascii?Q?zBW1zpMbgyOvCu7Ryp9VP4WdMlq/JizilSu1l0TafJmK3R57OZfOAcSvw3Wg?=
 =?us-ascii?Q?5+RWldBNsJJsi0rBPh99hUJyefadalHzjB1XM/X8oFV0bipQYTRLUZqBkqrd?=
 =?us-ascii?Q?Mp4Ht8HsOBEJJwnm5/MAClw0QDHdxXqML6LlJhwyRndbPB9VORzezdGaeHL9?=
 =?us-ascii?Q?L8BZOUISTTpCjLJ57WrkkgEkeUWKG5g2ufH02jSpPz4lxT9QExjHpr/FzPPT?=
 =?us-ascii?Q?UM5MwSxb4iL9hKc40m2v92pCV3NPandYb3nT316oNv43rh6UQQxsOav1o8wl?=
 =?us-ascii?Q?Q3eDAieTvx6Gt5j7vv8KS1OxzAxzxYRtvGRjxAdUBTq29Yi04R/jq/mjScZW?=
 =?us-ascii?Q?wG3MgcJADGraI6j+0rIFhVS8Slcum7yRfpVFrgFrrYhYQZD39jpcEOwkrolL?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o88uDB4+G7MlFkzsM9runTzsdMi6NtxegQ1qLEskaesodQz2YT5rld+eZDVrD74zjVHYB/LECUiq3eTMYp7GkjT5B4fpt7uHWGXGqPeKWxUGZ8UQN3sR8AmCegacwdvxBtVGVvsUE/Gcs+4eYG8+mdPS2chohAeF396YAKdCzVocm/XwZcsds9mJteEKRMJr6GJm0+GwphlJXV+VA0suzdV8TYg4QGfaJXG1c1U6LEdFi6bjOhL7SswiLmdJZyS5wtECRF/RIu09kYjuugZzxzzFquTIXBzCXyyZSOL7CgfnL8XixA+4RHuDdQTAY2tv4uh5HDWTBFzuhIITKmQ4o8EJzuYrIBt5nbosD/dtGld8kfUKqzYYKUdyukLBkoJz3PDAVjAeL4kkOQp5AndP5eitqFo7uVBvBzeCobGnEF71mwjShQWLmTLHZC/zOdeSyEG01Bdfkau87ox5km0kfOlxaPBKeTOxVXCbPIw1fz5T91TpQKXcsbTOvA7Ln0Nzl8XxeGcv5l2ruGBjE+j3JBsYf6imCxDmr4Uw4XGRq4q7yu3qQxLlIWne30ukO031afhdkgnR/YCjGd7hK4vJVzGdsE0lXHLyABodn5SJSoA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e884566-62b7-4ccf-d2db-08de20606f2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 13:52:48.8335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TIzpEqfvtvv9Gk6YzK7kOYvw4fg1aGR3owWDjOpcJmJtHu48A+GHXvlGzoctkrpOvBoU9iAYTm19MaTwpgD9/Zsd6jJpI0zh/8d5SaPaq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=910 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511100121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA5NSBTYWx0ZWRfX23BeQ84H0x7D
 Lvm/hgwUoxsscXK7p10YA2VVDbnJcAyncRRvacTVjKO5L0Z7BthrGAGuflQINJokdpAvtsVTYFM
 AEHBf+O5vrxK52JpEVn89cBRm+AHpLEvXk+KjSP0AtETvikOAOMwj5ET7LjlEJYeyDgZav+XFOx
 iGB6Y9VbB+ZxSLmhn9WZgZtwV4FzhmAZ4mYrLByA0yP7gPPbodfz9mIb5O1HjxoM9Sh5i2g5BhI
 uvBA72dVlU6KeDKB1x15o+ulzItH5q80Cj8mJ+ADTngE6nsHufcN6Dda5kv6oFdqp8RjTS7gju/
 mJxRuCQOr6yfW/JKLBjTswe+Zkh3tTvSohT2QpAIWYE6JXoIk2KAkQ9PL7WVjqRWCnMTvKJSpiu
 65DBDYUrNKBlnIhjcKC462jli17wgmYsOk6D/W0jWOdQQNtnvyU=
X-Authority-Analysis: v=2.4 cv=R+cO2NRX c=1 sm=1 tr=0 ts=6911ee36 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ror3zsDvhH801L2WNdIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13634
X-Proofpoint-ORIG-GUID: _wAmnRDd9anqUcwefwjuDcMBb8QW6I10
X-Proofpoint-GUID: _wAmnRDd9anqUcwefwjuDcMBb8QW6I10
X-Stat-Signature: ryjpsff4w18twgo9uimsgpxzk377iw7d
X-Rspam-User: 
X-Rspamd-Queue-Id: B93C3140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762782790-772574
X-HE-Meta: U2FsdGVkX19NktF2arwO/oufdGtHivjKFTzSMO1sQ/o/7RVXzxWfCZ4saDykAwAcmSORQHDryBqkpD1+Q3UJgZ5sw7aqDNnyJVSuNpZlxc0mzgaIb4QlTFSwvvc3HRYa8qAWadOGF0lnLRVuaKsz+LGOiaADt1LHZEpOWawnhrHhiH5Ej5+eW1V+LedCetHvMTbEDGeo1fOfNLFiOvq/YbRy7bDxb8uMrqxOyP+be+TlXsIcSDYgyVnoiNWXnK9CfdYelbAFNV62kjVIZ0ndgBspZxNqKwb3D3bm2dsrUzulurSOHW1GHt97doZydt00WXJaHKdLPQ8eutnTIRxTtjI5Qj+114pO6IHvZZYJEaWeINpkZ83ICssvXigW/X+sPVZuToGzb8RU7JOXa7389srMj+9vT3bl7IOpiduhfTjCxnovxDQSYnBDKCh71vtoNV2vQbXGnXmAeU7b1FvEoFxo1/nngzU96mqzb3C2DnZdcJHUyLyuYfmdqsGGgNo6kz7+t7EgLy0TgSP8x/4qGm7N+OMMtfOpkO4LQ6bK5oKkCu2TOxo75gswTTW/oDEU57iLulN2Y8TVykS6zIVSfJzOQ8KQR4scd2Wnm7TF3wauj1X4HmqlohZcVvcw3Qb/utt9fOMwKRQrZ3MDzT2tRnd+KM25vdrB8jYQzyaflt5Up8ParfprlZR1tDs16phfp2LwuaKUlKFD7hRKWivdstct34FKd/4vWbLvQLEK2e8rhd4t6LnYiN3I+sblrF9iwRi8esVPIHY1TcfAST1Vg8uruLZu/Zg/HnXfzC60RVZZww+mUGjeLxAzgHb361c4UHlcJXuMWYopKo++qLN823iqbQLWoVBdLoy3ge5Jir9LNWgcaqehabNIJiWYYRfvoqFaMrhiJsFeNxjggfDhwVd9WyjOBcXndV2SPRQmHUSqRlvIvMK/Fh0isjjJLDhWlzNZMxMhV2SbSuSzN9H
 UUFscNLI
 5fiaZjE3vj9nSx9Yz/bwwDT0MGzRPvY1ra1IEGKSLPSMeipCzhV41+hcDE+8Qw1GcOf6XUsd2bAfC7tr9ZTPiiyYglJv7byHJ0dZBqOna6w5xU3yguEMv8HZFgkq85nVuwX64LMyECA7WyEY3AbWVdVgZq+7xobJKoftVNsFEK9lRCOz7ip7fCt9y9BbgSENBzB3UbgfkbsggmxIluA/jrteNxaTnuRUezfpjQQJDpAUrH5+Xup6cp/WNCDo8Qh0oMB+R1HfRx2VuvC0Mjltg2Cwc1nu2x+d0QxnpEZsrPnRl/+VxwfB/JbjC1L3YH56R4C1pcQ7HEBCoHnGycyPHU0H7lma8J4bZY1SHWvlRXBmrtNv3wZL4ldrU/rS0PWeD1ENdju3br7Xl/Q+XF1g4G+9hvKjdJOK1t1cvv77308GRTV154GlxxO4SqUiIUbWhDpHoWqMwwFRp1axrhEheczDXCM640Ew9vTcrvgfZuW8wBhApGosRe66Yc9Lo0AjobwYytHbhyKwp/F9XETWs/uDCIlCfAdr/F6m8AVYH7hoAgBWG9RDfGPuzrHIB22PoTqliUI2LgBx+hZwPC2McZJQOvyW5lqg9z2gNVZFpGF4uFFTSRBlS6ZlU3rMQvFQGRNP9swUr79gl2NHF3fSFlg2jxQ2apyd7tfOQtylOqyZEcyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 01:47:10PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> > When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> > text sections), the pages may still be dirty from recent writes. The
>
> That explanation derails my brain entirely.  Text isn't writable!  How
> can the pages be dirty and file-backed text?

Because they just compiled it and it's not been written back to disk yet :)

