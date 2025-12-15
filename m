Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D783BD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 10:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217BB6B0006; Mon, 15 Dec 2025 05:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8746B0007; Mon, 15 Dec 2025 05:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0904C6B0008; Mon, 15 Dec 2025 05:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB9F06B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:34:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0C7A160B1E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:34:13 +0000 (UTC)
X-FDA: 84221345586.23.89E38CA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CB3640005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:34:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kVsYVjpB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kDEV6RNB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765794850; a=rsa-sha256;
	cv=pass;
	b=p7aC0L8gJpP97+SEqE00+3xKUD3dt4RAi6orQ8JKS6YLboI9w441clYIpBogtNRZAUE4xY
	0DpkvVkbO8dZA3mY0sYuTVLQ1BMeIQWvcATGHv80EB2oZ54sy+VgKoZsP0sdFsqi6wqEAe
	FyZaN9GWhT+VCDDLzVa28O4HMnG+CTg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kVsYVjpB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kDEV6RNB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765794850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oywe+u5zIOVrFqZfJaO8Bck3R9keSS4380DwAt0s0tM=;
	b=AcI6z/a6p2k3jDow1xYQWGAHq2H3AdzU14MmsoNrrcvFuRrnycsc+dopWtTz9QoT/ipa2t
	fkLpifsM7KkEf36hgfk9W/WVp8bdfEc5qQFJTkyVH8EwZGLlUdeGDspFMbg1O8RaNFK+Em
	mNdlLP3J7jMGIbym2LPjCo3NYQtAasU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BF9vcdA1925349;
	Mon, 15 Dec 2025 10:33:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oywe+u5zIOVrFqZfJa
	O8Bck3R9keSS4380DwAt0s0tM=; b=kVsYVjpBxRrMTCQ59au7QZtdGVj6cJR6Za
	Ob5Cj4NyNDCniGCkMCms4Hlugdf58a7tKlM6fwCeWudKGxM855PaJmKHufY8Z9qR
	SBg/0OJE1ZbMAAGdlgFwayM/uw2EOmJxjQYM97vsIPzVg15v7+aEeinJcoBjRohJ
	FWupmBP1/1foNa4kYWpTBK0MvOtjWrDrtirvZZGfTfrfEqyGUsG+pKP/9FWSuCNW
	WZXfXVnRkoznT6cE8kOfLaKxrgsepvGy2SCEOtDl5Of56rPJ6ul2XHDSS6mdfxt6
	PCjwouOM/H+l/UBqwLM5JXrDGYLnbjQYOH1y74VBxM4eeioE7Hkg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0yruhrpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 10:33:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BF8JrEe005911;
	Mon, 15 Dec 2025 10:33:58 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbsw64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 10:33:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Difwi7GKXZwD9wPnTAG4W7j7VrrDkYJ0MeFVy/tQRCasZa5dC/tCpZ5rBnpixeCI9Mc/V1uowuw1OIF7EyPXdW66s/lkALVuubqw29ir9Iq2j19Ha3taO3F02IYWrSLmljy9bqjjZvbkUcFv1x/iWW0qvU7sqRt4JKLWeUmvMV9LUiOQY0tfgyLTUVrAyu13zyeXrUb7AVKMZ/dNkBERIAOyA1g+1OoE/jqsW/eqrbVh254wbMIDc3goCF0aalwaPDLfSWeGabtzuLxbdMIuLhfPAM5TBsdGNxd2+TslRyE7qGYWk0GJTFahlMEYUK5YFW3q0aC2i5ga6b/gV/FzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oywe+u5zIOVrFqZfJaO8Bck3R9keSS4380DwAt0s0tM=;
 b=Q/uhBPKJGkvffj3nZNw68oDXJhaWdPEBw2uEQaJIYhXLnTq6Qt+MOiu++eMtcSNCjRpKSJDjzJ2rAUXjEjyuvuf7s2LLd4KQ5SeKwm4aoun9YktOrF6b/dTR9wxOJUWQvVb2uWf2g3nijrR+MhuzeZwDP2ewW9jI6qBD+eMq6K1uzc7H1seKRC4CF1ucgdYvhO07qm/aUxAWaMKehLgBSp6cF/oHA92xEyo9aIWZeTddRNqCaU720xFtuPI+8qmgeJfto4qt+jYkc2BEd0+uuUrWwFzx8bnNdopDt6tAdkVdsqU6P8PORT9ZgBM/7VRgpT0cJKDZOKffhy/J7d7+tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oywe+u5zIOVrFqZfJaO8Bck3R9keSS4380DwAt0s0tM=;
 b=kDEV6RNB8ShCwermgHuYoKwqnntrBRJ/97JXemiqc/lu35/Dbj7gpald+a7I3mHxiZOEN0rmBaw7MbiLkETZ5CB1sY5Y0WvwHWQLXAJMFE4mOm0/9Hm4SCaJLGp9PBL31LbqKFiF4SJTAjt6ginplwpnFCzeRfstxRMbNtJAQp4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6488.namprd10.prod.outlook.com (2603:10b6:303:219::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 10:33:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 10:33:55 +0000
Date: Mon, 15 Dec 2025 10:33:54 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anshuman Khandual <anshuman.khandual@arm.com>,
        Gavin Shan <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 1/2] mm/debug_vm_pgtable: Use set_pXd() to write page
 tables
Message-ID: <56560af0-6a94-43f7-ba9b-49ec476d1a1c@lucifer.local>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
 <20251211081117.1126521-2-samuel.holland@sifive.com>
 <12ac22e3-d943-431e-a3da-15987fbb458e@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12ac22e3-d943-431e-a3da-15987fbb458e@arm.com>
X-ClientProxiedBy: MM0P280CA0102.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 9912d4b8-42b9-4229-8b9f-08de3bc572e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ct5Ag0xhaaK7UDFpY4DmMpi3J9UkZ52ERjc2Km2iz8vl5Dt0AqKrQPTFl86x?=
 =?us-ascii?Q?p7UA6tGxJ/NCTjzicvUWu0+y1Rsja3WhogWLyIojBgWyQ8hAiFjGTu2vIU8k?=
 =?us-ascii?Q?SS2NM+sQaML9zw3sulDngCc1nKaITeIVxwsVLhUt/7zaTsrlGYpmYQ8SYd1J?=
 =?us-ascii?Q?Rk6+62W9w0NLOKc+ijsL6L8RgeBRL1dC7awBCmRpVPuRV/NfXXN8Lj04e9Sx?=
 =?us-ascii?Q?mtjllz3PRxCPfLdHVDNke7VUt3CwG3oLdnc+NIaeQvuxO/JnI3NOheUVtuBL?=
 =?us-ascii?Q?5dpVIVm9Nosjm96ctc03pnFuzNmKPd2GJIOO1rdfuzIm2ZVEDFQGu7AB2bgl?=
 =?us-ascii?Q?sW0cqIH3t7RelPIiDyVi6KIqzd1hiNbHSyCVjq+sbdMrFUwy3w+hWs3yr3iN?=
 =?us-ascii?Q?oXDblrL9ixwdDky4w8lEfjFMDSv2Hok0j1wCp8QqWjh5MesOUUWSHfvaZlX8?=
 =?us-ascii?Q?evB4dY9ICTl9fIoGRRlidCiOG7WDF7IaPDvBiAeFqIwcFA47bxdEOQkRyjil?=
 =?us-ascii?Q?fwwJhu2LLABnXoLu5bzQ/hog267R7v8lwEbrZ9EKV/ZB0mMkdZ3EHKBk0Tzg?=
 =?us-ascii?Q?u4UvARDtd48U2INMouVqpki6kxr1aNm9UheVb8SMKn8/wJc87Nt5x6fXFl4p?=
 =?us-ascii?Q?wdKxzVjOXEwULf++YZjCYl9kA/1FJP8kXX7xku6zfjSxSxQTURJki0JBXHTy?=
 =?us-ascii?Q?KzxzHCAw8oUpmjsTvT92raaIU3vwmlwJtKt+e81Rxox96hOqTw5oJ3nAQdsr?=
 =?us-ascii?Q?ODjrw82kVgwYmWRo45RXKRVuR7QCmLjYBZe6KKRptHy3cbYpvOR0H+XFEA72?=
 =?us-ascii?Q?6EHPpxw4E5/rlhLgTwMntDrWPYnchI7TMkn4rF2kNh8NYDtjnIKRqnKSe+xc?=
 =?us-ascii?Q?7rbvXsc/SckJMkw3IaTDgVKoeAzWM7DaBkjcVtuzNm4A58i6IJ4jKZ3/HkZ1?=
 =?us-ascii?Q?2syNd7PHLqIW+dOOOYR4YlQ7Gfxt2ch9NW54OFaQKCFfCy8avUxuu96gl3V2?=
 =?us-ascii?Q?HwtxYfbpfPbeGdyGj455skCESBAIY56crssW55s2nuDJ981pu+skauB/PQCL?=
 =?us-ascii?Q?5i86d/FU1B/6dN+ffHyQdWaRo6bQYyN5DMELi4YXOpTLmgbs9hYcb/8UHzwq?=
 =?us-ascii?Q?uZcwDWzj1uzjOjg2U+CItDz6/DakimCx4kdKgYC37xvWlN1/y5NJRkWvxtsw?=
 =?us-ascii?Q?kGp9qCut09GA+ob1wsF8/z5zRkTJAok7ei/SYoSFFvH9YgqJ4jFoTcvz6EyS?=
 =?us-ascii?Q?pS/cBw4N6fNF5dKXAtXPDQFN6azcbmIHClvAowPGrTUyPKd/qLvsWLNOrLVT?=
 =?us-ascii?Q?kbaGgBBiYNfRqAGfnQj6qXL27SX4cIlH/Z9nBLW5kDLNfjLa5T6Fau4n/+4a?=
 =?us-ascii?Q?SmpNxJi8nqCPZpdSBlH820Xh+seiDdkvXNVc6F0Cn2Byt+fKba4AcVwfHXul?=
 =?us-ascii?Q?yubxD7n2kF+9tu6Ki6t3EfX9DyhmvwaB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8z6bjJ7dLr3k698M6yy/wGS7KaCpUNRO9afV6Hf6WvIZlNNhbdsBAq4F4kBf?=
 =?us-ascii?Q?YdH9bc91I+0rn7exJA1QxqI5wWHmAv1NLXiBzJnn5NYbVuogwk5idfo0TTDg?=
 =?us-ascii?Q?D+CRABCTEFjr49FUz+MESS8VnxUjeFHOTGr4gnwm7LUhcuHmg2yclFFPzkrb?=
 =?us-ascii?Q?j9iY1WjP+zAAI1xeQjmutcv4Gxo7mP0y/GAXG6igZ9Dmch6Dq1wj50jWwZm8?=
 =?us-ascii?Q?tUb8GPj/U+j4hzF5AT0em4t0PD/V6DDcQZ7EPrTyExq819AjGZ8JKdLrYgR5?=
 =?us-ascii?Q?I2KdUGE/AvIBhzlhiW6+x/rQqyDBFuqHsSAEs+0PT51BV7Bkypn7z2XH8WYk?=
 =?us-ascii?Q?PYkZnqdR6QcqkVnqRaBCtProYNJn9kw+mlg9hsUH7GLUl0GXE8GAIErxLxQR?=
 =?us-ascii?Q?0chSOK8dil2lswnYytqZq+LLd1dv3tn5TRhx4QjhMw7rALX11ZdLF+egDrOy?=
 =?us-ascii?Q?YX9Sy4uIezK9ryeZpYn3NDz4g/1QlpCQCyLzJONJ8GPgPjPTRBbZYxwervZN?=
 =?us-ascii?Q?AHH+XA0COp4MAmjINGjvQOCVSnGZeLdXPeDzqGbsqWCXOAeDW8B0GC7Qhlby?=
 =?us-ascii?Q?Ix+KkfLV7u/Mn13OakSweyS4cQq/xX2H/+gGT6dgV+Q+8qn9jkcAv0VBa6VH?=
 =?us-ascii?Q?XITWtQBnt5z19HGHBqSk1zV3nla8Hpx0Lu9rdGOnq8Av9r1RVhosswk+vtEA?=
 =?us-ascii?Q?KopyBqXTtpuFCwnszMMfT0+2DbudanToXElGRcfOAr/iA7erYKZz7/xy+lrW?=
 =?us-ascii?Q?+kRubL95fbv5gP52hTZeP7ilPJMcBXPdRr6VAz4PFNleMhjV9kFHi98POcdD?=
 =?us-ascii?Q?+jPujPkpscWpePaJe8apV2virS759xxuhZQSf5lNdQw7YvzmsPR7HZP2dYv2?=
 =?us-ascii?Q?UfNlXxlET7T29Vd6iqyx55E6S825Mlkf1S/rCs5v5uD+pmNXMbCZ+suM5UMU?=
 =?us-ascii?Q?J1nr9RybaI46zemae2EWZK8EPZi2/KdeQu4nEVvtOrWdsHbaM2Ex3dPpOJph?=
 =?us-ascii?Q?lN05q5KpHZAd1DYbK/OHVZQ2hVPyIFtCnXXCSytwze+i/coeadf5ctOOsZvo?=
 =?us-ascii?Q?u6t9VcLBsjzKGlzxB7L/rzBpiiThnmQQQfBrNo+qfSZ4DlK3S4WKVJNp0vST?=
 =?us-ascii?Q?2WLh0vwY+Je6SApAWK9N7eZS+BrfVxyJ3KCEkpcxew8PkJSDD3ANZhsuTUQN?=
 =?us-ascii?Q?lNQesrxGrIx9evVf1z4S8P5vxear2cKGHUW2tdT9elUYo/l3pTKxkDaZi5l7?=
 =?us-ascii?Q?oLzI/XNBqk0l2Hcg0z2ikNMau5xby7h9cmO3fIZqDckQU2k3QKHkvY0uO5wg?=
 =?us-ascii?Q?8dSX925m9CUU4I0jZ7UCHaBHIgVcgbIn5EsmAg1le8hDjE5oULxEQo+bhA1j?=
 =?us-ascii?Q?cBoAqAdlTzpKRlBVsPgpyuAI5Q3/HCIzuAvXpquHxCFOOrxfbkKujj/39JaY?=
 =?us-ascii?Q?iD46bPHGvxj+0A6xx/aysvODlwO/uAMqJl4V7POZkJhv1OeFgLWlWZfcLBfA?=
 =?us-ascii?Q?AORGMiuGLO6RGT0kNPDN7HS+DrKIDpnt8Y6KRuYDpxF3IkhES/5KyHB/McfO?=
 =?us-ascii?Q?eSM7qjpQLDTyg8cSPHh9cC86oJzUV0lhWWA0ljVLWtvDGUti2pNWNB0bN36N?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aFSbPDl9FZnEtUjp/NTJiWfrF/g6PcIFD1RGQ/NcxmG+H3EOBKysFK5DxuMjlhznsOtsSucBu4CNE7ufAkvV12ARjj4jCLsFk+JxTAaExJiCNjMzshppLNwfoLjjWjdBTglY+HPRWv3MCLIQZ0hpMZrMmIfySttytiaMQAS2w/8V+fDiLFLh4GbeR+ZKpL941gZCou1LLVT+fMiYljaChYog6bEsVMlsIMqwH1a/zBVg9CdnOJwE1p5Diswrz9Li9gWvti1aTUTVWcWPXN0qVKN1khwkEFohRvbybNflRuU1meaulot27h3wNJcu3OAfkUakPQ8R/YtmERBOshHfjxOvy0cs9yfzETW4SIzRFHYwrKIker8k/GZnbtZ+v1yoJszX8dVhWBxbjChNmQZ21LqgYMUuTRMMnKpeXD08jpCsMR36mksLgo594WYvuXsh+PMU8NU7+RtHOF94Yhea4k63aeAh6AsltABygd770g7/yi3nsrrwZ5cLVTIVrTNDnFc7MYbKj5ak5yBZ7armGC5Gts/R0Bzb7aCgEIrGjUUdJAV7TpzmkjLz/zs8kr5apoug3LcyM0+6K4V2r7Gb92R/MK4miN1sSL730JdpSK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9912d4b8-42b9-4229-8b9f-08de3bc572e7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 10:33:55.7897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCoF24WpJD3TMiBQgIuYicqV0kXnZV8Q+qefNze+4GSKtXHgGdZNEjPSJeRfZh0iVM9sYFsvbDudjz15kBCLe8WUl4u/5ufg5hf6Yom6mcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6488
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_02,2025-12-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDA4OSBTYWx0ZWRfXxhdFI9kItS+W
 4MJKQJoOUalGtSnZQgBiMr/CMM0B9M1CFIEy7vXlZj4RlPXQWoiSSN1jx/kFYrpp505Y83lQbpc
 f150mNjgSSEi96jCWAfwePsNAydwSW30WlSB/qk9r/XFxNU6Yx1SE1/5kvkmQdOCff5sA3+J2FO
 u199U4V5ubZmug8bcp5p8tll1AIKSx0ws4KYD5zs7pkjOUniFrWXQwvD0Pg65KbFXs9cBhOka/4
 MdZ4zkyKAoba6gtsHXbgHVkR99DXaReNsR+BQS6vOeaOteqAqGt/Rca6oUhD7Q5OGGql1dlTjGh
 D78QsNqgTlZ4qjYKJMuUJs/a0toG/d9HpqFRXDVxdnaQUh/J9hj/qxadlDvvH/w8hQWAdwjcKRK
 H3pjWPIFMi3B8fpEqIZSbAjXmOYJyr/sj1RJft6DHlDCkZzHNpE=
X-Authority-Analysis: v=2.4 cv=TL9Iilla c=1 sm=1 tr=0 ts=693fe417 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pFyQfRViAAAA:8 a=z2iMRJHWYL39NEbNwWAA:9 a=CjuIK1q_8ugA:10
 a=oJz5jJLG1JtSoe7EL652:22 cc=ntf awl=host:12109
X-Proofpoint-GUID: tHgRGbj6fht9P6hnhmgb0xvERk6cjanK
X-Proofpoint-ORIG-GUID: tHgRGbj6fht9P6hnhmgb0xvERk6cjanK
X-Rspamd-Queue-Id: 5CB3640005
X-Rspamd-Server: rspam03
X-Stat-Signature: iabn9zea5r4mpq3gbzpsgybbbz6ffefx
X-Rspam-User: 
X-HE-Tag: 1765794850-219005
X-HE-Meta: U2FsdGVkX19VBceY30/7kN1GjLiLjIAk9EW/eBZPZZv3cf1PRuHTMZgqJf5yzCKEmHIel98eDfAN8Bldhy9/Vr2aIioX2hHkpqHyW5mdXHrbbWS0F+PmP2fKYFtG+08LGMLjZtVhkWlWwTJ9YtDURfaH382JREyRGSEKSdE21Tfgp1gdhwMaTNYuKfi+34Gi8ThlbVAphmR39J3Ylhal31Ztm/Nl6owvOBlINmgMP5WP+YwQcMcY2NtrzLSeckNoiUBrMI8bve+VB4/qkb84aTahKW6swGmvHXMt3N6tMlWV1iJjNJHWHWwJdJlPynRhYxOkXciToWtcbXN/gaJwqncmNZu4ghASD+Xkm9Rc/3bllj8t5GZWnghK4T3Qlr6V0wJPwxNTTDc+ThigFOEXoBPJQFwZtLb+ctx1z4rE2vq71OTXKRe7YmEjy4MTGEBwaN5ZoAQvYFAjvA5E2cbS0DMoJGGJgAgRBYodttBKKfunTjXJ8Bzi7cMe0KVy4kaSxY0g3urmJ2NTT2KApEkBrZyacLRVTY+ui66oIEe5Veeix1UtCP3E6jXDPbrydpAVA2aPJfkG/tKx9y4uiQPyPFbDRgvFl4xUX2X86DPpsOFmjIFKycCigbv0ze4nulL3C9+pwtyVi50IjMYYKmf3yX9R3m45/Tcj7rdkYeCzxQgUAn05zS/DX7MosdEYMeX+ve23nj5LbWVCsI0vtWZNNMXSFmfygqkyQAfI+hDPP7aBAWJK2IMELWbp1CoGevpDezmt0J3BNiwAzpFs+Pyl2U6/FLn77MTkgPyImpQzVntqHBivocflR/+gmD0iTp3HkDjI9CkNX1B+xnHAlSlU9TSjAJp/wJpNEwwpwDnMh7fqd+B/M8QPOVXA6ocQQehS5Yjx+bDJafT/8SQMGepfET2nz3SoHj3LMhD0mfYxxLuj49R5QNWfSuNuSuErEBw9pMqebAMdl9LVqEAgL0D
 3Gy1V+dL
 L0b6GexV3bvKc1e/cd111I19LtHvqjMKP4OHloRTB6DrN4egKCyH0LR/FxGKRUxBRPDejLzKJOaslV6JPyGi0FU9Lv9Ivf2L+1G+P0GaNbA+wO0V/XPrDQyQmZgla5QiwKaOXHivmBkswfea78f9GqeiM5XjxSAvmmkUBAqJSxO2l5hbAp1PpnaA2mybzJ9mg6I0y9zByaR/dCd14gXThhF6adHwv402yA/218BYIFsek8wOsLvfDbKpO+/CdivY7krgzwKI1hcCa9j8nywVvtQToMvSi6cQJHHctUznwZeJxJmJs+/4fia6DwLPFi3F/ZXdS0Atbvd0r+ZSlCwSpslwGzUuF4yPq5pO7ynscTzF9uRgORxyxvhuKFiUbrL53E0VjvMi8uJhZDFDRBVovvCPaBQqwwi2YkozisoKdc2dxgwNBjjZqjd3Byq+PCxxiPJb+wUmD3wuEc85r7w8t8/JTTp11WdLmtrDn7ygFwNbAiIgHXQdN2ZCsZIj9UaenLUV0es7it8L7jgvPp03TtwJcStsG3zdgiBYOTcvOpqsBFHct6/OUizwPKhzCd8upTkca19qld+m3g7P9h2IlJOyAbl02Vu1q9hEuIHjatujdeXFkHXkJm0GfY5cS5tD2ZQ2uw0aYqpQzT9fUzo22sMapT+TChsYb3MS6pOlVxY+pE9UcUGST6e+TEjUPpqRNLUbh4Hw29aHoRHhC6MZFwq03xD8mKEU8HiqL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 09:36:27AM +0000, Ryan Roberts wrote:
> On 11/12/2025 08:11, Samuel Holland wrote:
> > Generic code must always use the architecture-provided helper function
> > to write page tables.
> >
> > Fixes: a5c3b9ffb0f4 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
> > Fixes: c0fe07b0aa72 ("mm/debug_vm_pgtable: use struct pgtable_debug_args in PMD modifying tests")
> > Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> > ---
> >
> >  mm/debug_vm_pgtable.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> > index ae9b9310d96fd..8c7996d6c1f2a 100644
> > --- a/mm/debug_vm_pgtable.c
> > +++ b/mm/debug_vm_pgtable.c
> > @@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
> >  	 * X86 defined pmd_set_huge() verifies that the given
> >  	 * PMD is not a populated non-leaf entry.
> >  	 */
> > -	WRITE_ONCE(*args->pmdp, __pmd(0));
> > +	set_pmd(args->pmdp, __pmd(0));
>
> My guess is that this should actually be:
>
> 	pmd_clear(args->pmdp);
>
> As the "clear" value may not be zero on some arches (see um) or there may be
> more to do on other arches (see arm32's 2 level pgtable).

Yeah, seems on looooongarch too for instance there's an invalid value being set
that is later checked by e.g. pmd_none().

>
> >  	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
> >  	WARN_ON(!pmd_clear_huge(args->pmdp));
> >  	pmd = pmdp_get(args->pmdp);
> > @@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
> >  	 * X86 defined pud_set_huge() verifies that the given
> >  	 * PUD is not a populated non-leaf entry.
> >  	 */
> > -	WRITE_ONCE(*args->pudp, __pud(0));
> > +	set_pud(args->pudp, __pud(0));
>
> Likewise, I think this should be:
>
> 	pud_clear(args->pudp);
>
> Thanks,
> Ryan
>
> >  	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
> >  	WARN_ON(!pud_clear_huge(args->pudp));
> >  	pud = pudp_get(args->pudp);
>

Yeah I'm with Ryan on this, also as the kernel build bot attests, it turns out
we don't even define set_pmd()/set_pud() for powerpc... :)

