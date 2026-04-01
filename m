Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A0D410F9318
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 03:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9006B0089; Tue, 31 Mar 2026 23:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479846B008A; Tue, 31 Mar 2026 23:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A176B0092; Tue, 31 Mar 2026 23:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFC36B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:27:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7D361B7FB7
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:27:35 +0000 (UTC)
X-FDA: 84608552070.30.6820201
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 340A54000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:27:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MPv6W4wf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KNbfv8jH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775014052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yZcTei5OaSH1NoIEOBgvAwBvtEJmHndKwaGMdvxq+s=;
	b=i60yVMdfDwa73+SDbnk6sVEspAvS4GpUwKG+yyhtD92IF8/fqVk4UwFUfbyhj95ZlI84/S
	1C8YCvE+bWf3UqH8f0Vq7Fa1uNF0I0X/yvcEaiv9TgsCJFWRSvKGDeYYOTBZvP8OEXayya
	qz9IflTV7QIQTUQL5dYMBXvbQJtO9e8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775014052; a=rsa-sha256;
	cv=pass;
	b=pGU8ZKhR9sFqSQrUmLDrYg3c/PKslhzgscunPR8q+5j8aKCvjt1FPZwbD9yRs1HnkLmWF4
	MUpzxbVtWAi9pt1DMOD++TgqhANHRuf9IsSYlgqz8VALtqgXQjjakvkR9irmJhEj09KC1c
	hQK0xfD8F47bu/mazboTjnwT8awyWkU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MPv6W4wf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KNbfv8jH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6312GdK32835571;
	Wed, 1 Apr 2026 03:27:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4yZcTei5OaSH1NoIEOBgvAwBvtEJmHndKwaGMdvxq+s=; b=
	MPv6W4wfnnrQ/iwe47RKqL40BRXWtPgII9MEAl/aR8Q6QmhxCOVQ0On5WHDGZOBg
	gAy5rSr+VzJ5uk1w2GVUKcvRUklrUhm3mOKCe4ZoillLWWmUIAXBMRl8lYWXTdBT
	3RYXSCIgLVLSrL4bWugjefKQdrLepncddVMlRFrIzeCfwTsRzfVqZVvJuTNIZlIk
	cG+RsyXBTiErSlwGc22z7BN0FQQ/7cuaP8SiWSLJ2cxdS2WfO99o/dKh23aSnP2O
	vwPJVJQ3j8JwSJ90+PKXaTBy+eiTDbmUoE7FdEnem/OoFXVvepR82525uZdPJvV+
	8gtCPua+rQnkZG8UqJgE9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65dadktv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:27:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63103FXN009862;
	Wed, 1 Apr 2026 03:27:29 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010020.outbound.protection.outlook.com [40.93.198.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ehb6bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:27:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcEZvVBMtAXi0Dd4zlObGNO+aSWNkJ0L4frJNWuFXbJt/L2sXhMIzovzFM+JIVW494dWCLD2Hog+rbTi/RfAadeolJrdOXruPq12Q7x5y+fBLROWeSPqepLh7yUsCIMMqAvfJbQijlX6dugXza4ngfe9oLiBZcpXqjwnci+CWbnB1h2MFVB1It7W/+TmVHhOEQuuASvV6oXfs3B8r4eHpbhQEj1Lhmm0g4/ipAYOvpTBssi+zl1WDc0IX1oiZtNQt12B/1Wj/TX/LEen5DV5BvPNgxHCapWHha/CFtg4dPkrTRt7Up2G0cN03iQyxZ87MdmW/B9OgkqmqBvprJQsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yZcTei5OaSH1NoIEOBgvAwBvtEJmHndKwaGMdvxq+s=;
 b=H1ZQJAHuHISWb0NqB7RFFtXazN+YR9JRScSiLIIqxqddqY9p7PYScPvv3auLMA7I5244pZ3bb3HWu6kCAWEzlm+kY6wbdRH5cbh2eg9Q3N7Hf3WDrX3LyTa9BljvW52YFQsixIPRgJB87dqfNvSEkNPOxUDjvCzTPYvM6urHIiWrNWzb7pm4ZrRIbQTMS90xgSGiINi/ggXyXp0l2wcRAqZ54rIXmKgR1swT/DV/kUPEXR7VHC2lDihoFqz/Q5hgFm9E3vPKiw2gA3QpSnFo/NW+TlqK+B8KEwxUK8o1dfwO5uzYI+O344yNJhVSmG7DYLFLUPPuIEYkleq6FZKqOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yZcTei5OaSH1NoIEOBgvAwBvtEJmHndKwaGMdvxq+s=;
 b=KNbfv8jHHKzTVYFreVU0riB+TqI33RHGKlzuVksP6cgpE9/4qC8YF+dX4Z/5fricE2uXoYJlMbNIrkBZrvwB26HUveJHHr7tM+uLJ3El6Q9D+EBRggeWWLxq/02in+CV0ztoIsuRpa1lnzmzS5P4McLGisCNkyKI+7llBlabnVs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA0PR10MB6745.namprd10.prod.outlook.com (2603:10b6:208:43f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 03:27:23 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9745.027; Wed, 1 Apr 2026
 03:27:23 +0000
Date: Tue, 31 Mar 2026 23:27:20 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, Josh Law <objecting@objecting.org>
Subject: Re: [PATCH v2] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
Message-ID: <uiq2elysm7osapc2rr6rcyqwfofqmuxn4fg4kgp3i6ltwdj33l@z3azyih67up2>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Josh Law <hlcj1234567@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	Josh Law <objecting@objecting.org>
References: <20260313073132.159184-1-objecting@objecting.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260313073132.159184-1-objecting@objecting.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA0PR10MB6745:EE_
X-MS-Office365-Filtering-Correlation-Id: cf40f87d-850f-43bd-4f3c-08de8f9e96df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1Rd4IzikGcRd400OU2xEEoGkb0169Ov3qtUr7X7B1x8vaaqxcqK/M50PqYYciwbvZZVvQgI7QmT4RYRxVV+CmZmOxAmJzN7hJjPEeh/H5EO3tYR3+j4l79ICG9R1trFtSWwkBV0VfwSWL4Ti55Kp1u/NiufgAjIlFMKZG/pvXWY9aztHurqukK7cGNrJSnAtAneeqEN/ZQdVCd9ns9mrZWtcvMJAQlvlC3ZuhgD+v/AYs0cXFoj7NPZBCdEcGCn49fcmObRsLBgOuSIsrIjiKpbokPxmqh+CQ7BTAk/WWsFQkiTjMXKl7KNgqoEbOX+ntCJBx+ALySiA+VBc0KibYyYCPYVpY50ddm8wctBPdtIOhugVzX4rmh/wKdtH7iif2CLhN7icHIOs2EjFpW8wEmappEfPi96K72E4Blv8KNUlu7mEcTf6VyUipXPPp0lJmZPZ7R7dTrWA1z+OgArY/bhYTmFhXNZg+mVK0AURg9OAGofJcm1dr6W/3DJBFABjEXXprDaXNjGFcMoWm5Qb+MXjjcZWIo8Y0faA6+BXnvRNH4LXog2eEbDA9l0RKCGlQAwoKC+OT1pF/EOxfvqfbPaOp4/37rQM0Hm02iPnuinNBFbFQTYOjIHbwa5oeK1NThYB5M7qk8XP02EuiA3NF7SS5BcQlpHo9RKnn12Byzg72qvDhRs/XXFnCTyst6iALP2EAEv+U3tTodCTtthY96XSSWafDEYF0W+c8tLVc4A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bStxYlcyWXE0U0piM29iRGlMNlFBcExVdE1vVkZNZFhTUXUzQ3pMakM3RTgx?=
 =?utf-8?B?Y0QyNTZQS280K2UrV3JqcU56clRrWmxCVVhOSk5iTTZnY1NRMnhiMDdXZHJh?=
 =?utf-8?B?OW9MNDdUZ2NwbFZITEVNUitBYk10MmhlTGxFREZYZ3BuR3F3cXZUb25mZnlw?=
 =?utf-8?B?Q0lNc1g2TkdPa1VVVmYzZGxnZjlwcWxjRG1pQVpmNENKRm8xWkZzcXpDNGwx?=
 =?utf-8?B?bnNnYVMwWEg0bnRnMnJhbnJxeEl0eG8zZjNrL241OFBMZnFSclJvNnJjQ3pF?=
 =?utf-8?B?N1VjY0M0NVdpZS9pNU91dGN6eHRJZnArWE9hbnNOZTB3eTllMmQzeG9BM0l4?=
 =?utf-8?B?bVgrd1hKdmx2aHVXY3RtTktUaGVrWmJBNmJ3NG1lN3JMdWoybzlQQi9wZ0hC?=
 =?utf-8?B?eWl1aUswdXdKZWZqbzNXdlA4eFAzYkY3OTJTK1pIZGM0UmtiMjdyWkk1aEIr?=
 =?utf-8?B?RXpKVi9DNVVXVXplZXE4L1BiUi9mTkhZYzR0eUxzNjdrUXRGS3RiRnVVdlBV?=
 =?utf-8?B?c29rRnNzTUdwSlQ0eHAyckNiTEszUGhvZ2JrYXh2ZytRbjNxZi9tOXRZWklh?=
 =?utf-8?B?WEtCZ0pST1FBRE5IdHNpdUdPOGl1QTZkRk5PNFhsbXRrMjFGQ2JNaVgwR0xs?=
 =?utf-8?B?c1pVaDZsMWk0SWVyZzhQNW5aUXBrYS9rVkNJaHdQWkFucDdDTE5zSUxGOFd1?=
 =?utf-8?B?TUVnVm1LcGNlclpyWDJ6Z2RpL1BoY2p3WUV5UlhpTUpVbFREU29Fam1sbU9s?=
 =?utf-8?B?QlJYSlZ4VVNmcVVpeWt0WUVyOUN2RWZrNDB6dFlSQjVjeWxvOVkxWXJ5Wk1S?=
 =?utf-8?B?QVY4WnRDUmxjZldqVHdKajdjOFhzZUJ3bEdyTTQvMUVBcTNNUEF3VGc5K01q?=
 =?utf-8?B?WlQ5L0d1U2JqemIvZ0NpUk8wakZsSGxybDJKdkQwSnpqUk1saG9FTkFkU1l5?=
 =?utf-8?B?eFZsMG90MDA1VnNmMEVES1RleU5raU14T1pHMlQzaXFVWjJKZnJzb0piR0dn?=
 =?utf-8?B?UzlOQ050bGVmeDZuNkFPQVVVOEVENEFWbDlSaDdOdHVFamYycmlZSms1K3Y1?=
 =?utf-8?B?byt6SUhwdnVCQTMrRzJPM2U1K1J4dXBLS3gwM0pLb054Ym1adi92ZE0yTk85?=
 =?utf-8?B?cmF1MnhTWGpaVnMvSkdWdmtwUXpRTzEzZWVQZktzOGh5SDRNQ0tSY0xpVFpv?=
 =?utf-8?B?RU9pUGF3SjJSUWgwQTJPRmVrdlRZMVozY1lnZmx0cjBkWjc4UEVLWGZWelor?=
 =?utf-8?B?cXFxYVpobEd1K2hJNksvMmNReHU5d1FIREYxNDQ5dWJuNGZxcDRHS3RwSzVk?=
 =?utf-8?B?MElGVlJVenFSSUtYOC9NTDBKdkxmcW82OC9qc2pPUkxmSFJPeTB3SS9ya2NU?=
 =?utf-8?B?QlJETVpPWTVWMGdxeHg3b0RiSG1oODAvTFd1K0JYY1A5RVpyajUvdng4WXdG?=
 =?utf-8?B?SjY4ZUJydmVWaUtQU3REamZRYWpZcWJFc3Z0cC94cXEyVGxPUTJPeUxXTVJJ?=
 =?utf-8?B?RjJCRS9ieE1GeEkxNkxGNHNQcEczTUphaTFIY0lmdnU1NDZSYmo4SFM1eUhS?=
 =?utf-8?B?TG5QaHJHdlF4eExPVUFrRmdlbE85cCtKNDhvenNFbjV1dHJSbEROTXdYREpJ?=
 =?utf-8?B?YUJjZkQ5WEtsUnc5YWlVRDB2ckkyakJRZmhMZytvSW1DRlBBdkRJa0xRUCtJ?=
 =?utf-8?B?V3dlTGpiVTJiQThZeW12T1ZwcDBvTDFmZlJpd251dDFrTnB3UzU2MFIyTjFP?=
 =?utf-8?B?V1IzSm1nZXY2WVFYcjlZWmxFaXBEY2VPMHNUc0Y4b0lNZ2kvdnY0OHF0R3Fu?=
 =?utf-8?B?QkNaMEZJRW5TeDIxbmhyMWdzVzNrK3FLcjgwQXRVT24rclFUbnlYaVZTWXZz?=
 =?utf-8?B?UjBCRlhnTk1hQmt5Z3phTnJYcTFGeXM5S0hXSGh0S3FKQ0ZUYWRUdmNRMTlh?=
 =?utf-8?B?anRFdUtuckx6ZDJTYURxa3lEdWtkN3ZYWElQYVhETXFUMDhGRU1JQ3NJdFNi?=
 =?utf-8?B?Y2pIbkxqMjBPN0N0Y1ZGTVdnUlBWQUdtSW50T2Y1eWtKZjB2V2JrVXVrOUpt?=
 =?utf-8?B?c1dRTUlRTU5Xd0t4UC80ZGxlOFE3aVFhNy8xeVZQTldjS0VPTUlYVUVvWS9y?=
 =?utf-8?B?YTRnckhUUzZYaTQxRkJZTUpETWdIVWhZbS9LSzl4eG1mMnAzMTdrWnF2UFha?=
 =?utf-8?B?MjdockNLTnJGR2Y3VkNMSmUySTByS3hLMnppZGVTU3hqZWRWZHhHS0IyOHA5?=
 =?utf-8?B?R1VJTjJBaDBVbnA4QWhGK0JMcGk3S2lCTzVFaEM3M1NyR0JFSkhRRjVWeFZO?=
 =?utf-8?B?Y2tiYmdkWENpL2l3em1NTE52cjBzdk1ZaGxFcExWK0VFQ2dsQVlFQT09?=
X-Exchange-RoutingPolicyChecked:
	okp2F7LroB32UAVGWKGKr95LYMdFe0ypWN9m8lTdxuMvzL4ZG0zqR/h364PYCKLtEV1eZb4N8XGITHDTn8DCgzByp73d8E6Fd/Vb6sgfVptCVAwvmQg8ELJpYkE6TSA5eZWP4PEzbAxF5ZDf+1JJYfPeHEeqvgImUU6l/tyhz+v+vJFpIhfX+BEpTvpgMh38HekC4tj3+61/VDu0fofXYpOMGpCR9qIA9JtaPJ4DgYg0dowk3gSjNrtWFf8J+mxK4h5sijVQhFx22Hs3CQAV4gVZiV9pBKjQ/+D1OpNlB+pqce7K+g/b29Fp9v9JmSTs5ktozqfA+2UViuCA6uJTPQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y0O2GQUGKPSLAeO+GCZsjbpMEjtd7spUEnIZX6VzfTJKXSTS8pXsYsJDL7KLsBaFVohAvOJpiXhDeBA6yeVR0Jx4Vz9c5AqkvvRa3FJPRLh9CfEZxP0O/v/MN+fKx0QVcXefdRI8HZizFZNKaIPArBATwSZKb/z9ZqkJIf1FqQUpwnNG4LxMgrYUod6tT4tEycuTyPk3W4Vj50akMlHYx7wQNUjs0S7HVb/74dtcpaxlBKS7o5TdvZ8Zl8IR9Tf5YwJ1ccvvwWmjfxrFwjic7mjodXlhzqv63IBoEHUWawP2dGuE4ZsWzd1GfTgWbW0rbQEISqdUe+pL1dNJ4FFrhJcZwV0sngyVdw7t/MriKFNBVrRMCfXENDqwFWc9JmRW3FbjXyt8EVVqn8CRk7uoS9+mBHaIpKU1ZfYknOmn/7FBpL6EHdzZnZ+5BJIcakI12hEwJc8xLJbxbYXvrtZRyFGEZs3JJJUHXsT/5naTHxaCK75R49zGU4Ap/8Nd3FvCAJW/CJMCl2Vdo+6ovolQoZElUmgmgm2PNE2po/glBZmMzrECXOR2FkJ4rXC8kxOp0boCPn+AEJ5j6zJINrAQnWs11CQbh1q6sUqOmc8hYag=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf40f87d-850f-43bd-4f3c-08de8f9e96df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 03:27:23.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LlQDNVPjNwQ1BbAGLqzcrknV+/e6WRUkV6vM8UD5jgUBKxnIWowCtylwARYYXEfLModVkbqe5oSi2uOqPN9mYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6745
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_01,2026-03-31_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=983 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604010024
X-Authority-Analysis: v=2.4 cv=IPwPywvG c=1 sm=1 tr=0 ts=69cc90a1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=pGLkceISAAAA:8
 a=yD-zjvGMAAAA:8 a=evRA0So8NVOG8ed6bgQA:9 a=QEXdDO2ut3YA:10
 a=kLuJvYmyrWYxQwIM_9hz:22 cc=ntf awl=host:12292
X-Proofpoint-ORIG-GUID: 8tocDbO6I2zVoJKM2j1CqvAFSpAMHB71
X-Proofpoint-GUID: 8tocDbO6I2zVoJKM2j1CqvAFSpAMHB71
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDAyNCBTYWx0ZWRfXziPJXnhHK0Ky
 BoYqHa8qmADoGRjfcu3Oa/BSUFAmaOth4nU0+BvTsodYmnZhBnPM2t3QjanlgKWHqLISQ8iFIgk
 KRSGJgKMbuoYnVcT4kSJT/2ZqmGdK9Bite3ut+jd2Ond7eBqMJoog6ZQ13KUEGN4rkm7MnS1+Nk
 PXcr1GUObFljVpPb+vJd/4ntpxgVx4m3nq6UvY8K0RKP9UfmcJm5xh6pRZby3jWxChHmU+/JdeI
 LRtZC8PiAj24oJdpX6CUsE8Ab9qQg5c+K0DaaB6w17Q1qFZko3DVmJQppuEtl0he4YOdouSJiTA
 CIgK8YgA5mluqmRXjkp8x8YBcEuFl++4DlMO5mSYBXpbN6pVqMjFS8ILRCmCKF/NKdvt4GjJBx4
 vQzjMnGhyPFqqQwciLsJL8u64GhNYPZFchxmtplaHUbFehjTBzDkKsopJKepXhw9H/X79xjfCDa
 BthzG77SFS0Z4ogpJCtdaU+H6lwzM0aZdowl5s1U=
X-Rspamd-Queue-Id: 340A54000F
X-Stat-Signature: 7t5xhaibybejmibuwtrhg4ay4uqrazah
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775014052-550437
X-HE-Meta: U2FsdGVkX1/33mzZCxYA8Kdx95Lh9pPC3XOJs95FntBBi8N/qe70DDj2AioNGtFu2dxtd20C+c3kPziOrQV+uLguL+V6ug9/Zo4TVR5sBc1InB0N1inPuykZzUWnhseKcdRpuD4ehF4IDCQ0Lm3gKa/9/qQU4XSG4n4DN8SK1mdzktlBI8XVKBebvERJW6J6gqW4sVjoG5hKPPOylBWe5eR/PzalVj9C8ppyP9OUiYZVnPc7QTkj+gGLA0prmUgK7ZUTo/o7gkyNbA0HyyY2ytLnCY4/cjHrGCCl244HYLZptUdN7YRTcdsgFg54BqEi9vbHnZZxUtJPZmbYdg44e8uWXmcd+SfdQ0v8m+kc6DakQpKOyVLc2HDm1fO4F12chTiFXCUfAqH5Ez/K6tsXrup/+1n2c6WIjfGGtvPg33VaNOgTPu4O5W2afoquPRhCrdcFGoyVBgz8vOU4i4+JuQzHhPToOlEu6HhdKhAwsP1R4QihG4VVZnX9NRMA4PI+h2tBQQmUyJxmerIYGHNjiSu8TnU29R4/fvaywGER4EbbecqzBnBO420FH/bb8nBM1NtiVjHAnC8kncG0WVzskTXiNJM5r+uYc7whh4Scd2B4B+vpT9mTxTNWV7/FJlkoVGpDa2FVqVtQ25wg/DGZA33by+k015yvFl5MtU5K38rKOIE807r1jKPyqN8xIcUo4F2io2B+4n+dOfxRSdPW06GSM3PG8H75uxagfwLTPIUyYZwGhWVYVt2Aw8Gb2xX9oR2/Pu+7hXKhDAmdX21oFG/jMu+Ev7fS5J1TRZFyUyTn0dRIFeB+uAEXCaHoiGX0zBQ6+UmpaKuP3Hww/MD0ZXOIJgniVxQUFy08KJYowKI0njiTMbh4QB8sJDlIBU0Fa5cspDhIwqVvamlYepMosmv3bvvrcCSEmwoekCEu+YvHWBA73bf3viJj4PuEvl0tFKm3gjrmhEYFAMm5UM9
 c5/iKGC7
 AWQiRgkSva0rZs5QDKqbDwmD/UlC0TvnlmfWe17V1DGs9uUOaFngyr75cp/IbVp9qZq2w35nfD+fDjZM0MDVpGHjEkrHXhnDuE1mPJNz4PXp7fSlUsiwmdBFLr9YOPjg3ad4dyf3uaL0o6GOXxQRQPwHKtFyzRippyLRG4azmMzysM/3SPb4CpdSnujMbuClChuZibsRTRv6vBmuEGqiYX0tHW/dvtQc8g3fHTK4jrJGtTUqsUcOG/YhhMQfIvsSGgH2Zjj6KUprOSb4xetrePu2t6Tkeub828Ar0kswrPPxImcppoiw7FOXWgW4Yw9YfDZ6vVi5R53cWpSn5M8gCR6IoAkm+d/i58izOCtXgSYI+ceVsRGtRT9wZDRzW6vietMbocgziTdvUEu3wP+gsYfCKEm6uA6Q3Eol3QJFNsTtZnl0/+Yo4QZJ3ZxhCQ0nGPYMZ+QjvEg1iaEITcDDMtAMLlokQqZjQUJuHL2zoCncMNOEwjL3++YNdvVd5y2Exlz4gewiV50nqDAh7xF+GLvxakxGCQJGsBbvEW+jvd+CrwzmwY85AFe1aa98lXY10ErQyhZFcP71IY1zLMBQm7HdhhHTEmd/7LFCm9Nsla9fKDcn7F6wtn64s2dw4oqzToyKX0f4aZ8NpJgovrEe4hTHd/OY+778XA0g06arDR+bfYiUmDx4t9q1EwPggLT0p4anrxTewMpKm+mVqcAOIKCsikQrId7Lp5a7zIRz5RgrnBwwwI2Q74dzC+JBOG5QBOmUx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Josh Law <hlcj1234567@gmail.com> [260313 03:31]:
> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
>=20
> Add a NULL check after the sheaf allocation to bail out early.
>=20
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
> v2: drop WARN_ON_ONCE =E2=80=94 this is a recoverable allocation failure,
>     not a state that warrants a warning splat.
>=20
>  lib/maple_tree.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 739918e859e5..1eaaa5f964e9 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_pop_n=
ode(struct ma_state *mas)
>  		return NULL;
>=20
>  	ret =3D kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->=
sheaf);
> +	if (!ret)
> +		return NULL;
>=20

This isn't necessary, as explained to v1 after this was sent, I think?

What a mess.  I'm objecting.

Liam

