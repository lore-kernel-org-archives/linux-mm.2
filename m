Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7EECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2674380193; Tue, 28 Oct 2025 13:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F178013F; Tue, 28 Oct 2025 13:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E05380193; Tue, 28 Oct 2025 13:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC2C88013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:31:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0FDA1A04DB
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:31:29 +0000 (UTC)
X-FDA: 84048214698.28.3F8A7C2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01EC6140009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:31:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Jjahe7J6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LdWKROff;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7Jg6acVQQzCwkDWl/liITexpmXsEWq6hTBBDp4owYU=;
	b=7Cju9W2jG9aPtfVLoF81ZyvbD7vlueIXMTVBolZY2PxdyhZgv7QvrDm7lPEFBbFoJk+5wV
	83l3W96HZsaRvtYCo9J9H8yGhXfd8fhBOWFpBCoBco/KqMYJBFxG4hBX3YoyK0vc7s8oGZ
	BoDb8G65HqeuJPY8T2cjJlvHwqDXDec=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761672686; a=rsa-sha256;
	cv=pass;
	b=h3IWb2If96s6FP1Wj29N9vFS0YIk/sQ5AoOEFan7+EgbBsaQKN1T1g/vgpWVxHau+UIg4U
	lT6uVXuV3WvMy98xBlf1hziVzI+ic6ARqAHctuPK05rlMZ6GkZ01I1Dc7XPr/QnWyoR3+3
	PV9WCTerYuI3nioj+/PgQXQWs2MBw4w=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Jjahe7J6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LdWKROff;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHSC41019378;
	Tue, 28 Oct 2025 17:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=K7Jg6acVQQzCwkDWl/liITexpmXsEWq6hTBBDp4owYU=; b=
	Jjahe7J60x85pSCueDaaVkTQer3rgZiC1uZXLbRfd5jI+cLNQGG/VQkwKRATIIZF
	QBurqFqyEu8QMkL+I8X4pYOssSLXzma9brR4u6inp1oU/95JUsGlE07KaJJDGOXD
	Eh9suaGiba2a0Oo84jGHSkG5gsJQzv8t9qhEnwHyIYFVZjNRU/q9Z8nzRgjuVdMN
	kx0GtdzG5zcSz2U+5+V5AYt9jQpJKEj44ixho42+JgLf9eiwdU7L/el8l0Ipd++/
	phoGC6dP80/yAv381rVaapfXZuVzMPshYPEwWYAZoQKGU3MzrDmf8SAnPemSKvoS
	D9qZaEBu/CG0k9YLHLadLg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uwm4p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:30:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SFtbAv025092;
	Tue, 28 Oct 2025 17:30:06 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08rqbm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sgr6Px/fV//hxg+50rc8kfyejExVgg6dqCUiTrQK2FyILoEFL/OMTKcSNzuOG8gj+eYgeXlIsViw6nUvzL32Rmh0s3mNs13yN1ZzPM/fxjtNMwXYE3hZKqfgyewQk+/jxY4eX5jXlYdlJbiH6Y3+/S3JHk4u5HC0eNm/BZRYFnmZxTwl4jPBAeveJ7YlbX5dRKuMMWpYHVPh6ZPy6HwR4BRa8yPxRc2TmPTCfj+o2hlyieUoQTbCvtbmEQN0GnIip5GZDXREVibcOKxXFO8piToOm9US0zymH9Ra8W2TMxCnyg8EEf9kpH1KTO90ixBTJYjnwjNpaPNB+oHFVOdnqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7Jg6acVQQzCwkDWl/liITexpmXsEWq6hTBBDp4owYU=;
 b=R4ykJEkEmQQACh08scmGH7TnBNWCZrccGIkwgI79ETap5JLsDc8sDVwcIE0tU7OL8cB/KHTq2nyd8HmqjX0bvcAxTUhj/Dmv/x9PuZl2FwLBAP0oF2QhP2dThyrmriuowWB5OCt6GtVD7xSlLXc22EqGczomyaW0X9YpY0q2u6+Lf/5YLAOrrwainSDxnuEd55VaaXyAFQ2CjSwjRlqKt0BN4wQDNeSrE3oyqFvJ0sw3Oi2qRDirmihBSlAou57RLMIDU4sxGjb+e1qXev4bHcrCfpAKD6BC2JcgX0fGlrtPmjmI/vUQ2gN6P+ecKozSUjY0j0Pj7s48jqbW3kxIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7Jg6acVQQzCwkDWl/liITexpmXsEWq6hTBBDp4owYU=;
 b=LdWKROff8laX9SaUeZD4elqvaulmODOwFamJDauAO2Y1F8jGTIjMK2i1D099SPPMkduCX3Uxkq0HUWqKWh+t4vJjKgABg7xdEz3XywgfA+objxffwetfYvBLVG/6lDRkwtvgPqCiVxp/vdg3pGpvhIAD4JT3k04tSdg3qXNKBFo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF3367D7B9B.namprd10.prod.outlook.com (2603:10b6:f:fc00::c1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 17:30:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 17:30:01 +0000
Date: Tue, 28 Oct 2025 17:29:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
X-ClientProxiedBy: LO4P302CA0013.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF3367D7B9B:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d3af14-3c22-4f72-1d7f-08de16479fe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2JHbkthWU9zVUNyUGVUaXNGLzdPS3Juc2VFM3RFNzRYcFFxQ00ySDNaLzJp?=
 =?utf-8?B?SjdSeXFlU3dCWjBmenhVN3piYkRQKzhuVkpJU29LWjc2aitKREhOelcvM01t?=
 =?utf-8?B?R2pTNzdrMnQ4ZWNoSFEzeTdZT2U1Z285RFJQTzQxclRNZDlkd2xaZy9YeFIr?=
 =?utf-8?B?M1ZTd3BJcE4xVTJYaS9zcHJKNC9jT3dJQVVTaGtpWnFmVTQ0eW8wWnlnS3Yz?=
 =?utf-8?B?Y3dSYWdkOVhlMVg1Y0Q5eXNSMEs0UGEvTmtpMHVPZ1NBTmgxYng0dDc0NnFK?=
 =?utf-8?B?UkpCUVZ4dFYxZnVMNGc4NElkMnNPUUN6ZUZrekhVNTlQc2tkS3YwVk1yTUhN?=
 =?utf-8?B?elhsbHhqaTc0bnRhcFk4N2RiTTgrU1BVY3piNEJ5Z3pjWVdyUDJKZ0lKQktm?=
 =?utf-8?B?RldNZVdhL1JyRGdOZXVtZlVlOWFDSTRlcjUrNnprUVM5d0t5dGlwOEdNWnI0?=
 =?utf-8?B?aGFTZm04UWd3Mm5qMXdqWWV2Tk8xTjdWcGZXNVIxU2NCbTRJNUVrVHNzU2VV?=
 =?utf-8?B?SkZjREZTUUJiSlp3OFloSjcycmJLRHRyUS9HZVRYMkpMUzBUYVNaeDVmbUhv?=
 =?utf-8?B?M3B1NnR5OThZRUcxMExKSWwrZU8yTEhQUk9hYWpKSURyRm4veWd3OUhLeEVM?=
 =?utf-8?B?THp5OHZCTE00MDRqUzk3YS8rREx0RFJiYVoraFM4c25hQ3VZNTZuOW5nZ3ZW?=
 =?utf-8?B?RnN1L0t6SXF2dW9JS1RBTmo0RW9aNUNLZ2pUY0Q5S1U0RFc1N3pqWU5Gc1Rj?=
 =?utf-8?B?eTRxNVlpRUxkYWJKOU9pZThSYWxDU0lBclZqVEFKV1VkRWl2TStwdWxKL29v?=
 =?utf-8?B?STJDLzZWeDliSCtINHBxSFN6N2hDOTVQTG15VjByZ21UdmpYM3FKbTduYkRv?=
 =?utf-8?B?cVNGcElvbGhWOHhSS3dldTRWV0pydzdpTHd3NHpLUm1HUFY3cFBNVGdLamdw?=
 =?utf-8?B?WkszWkhmUGMydzJmb0xkZUlUckFPWWg5OEoxdzBLMzFSdXpSQjFxbURmdDFV?=
 =?utf-8?B?MEdEZVloUGNQR1VkZXA0TnZuSFJLT1BLaWNGV1o3Yk5Pa1Vwa0dZeDZmRjFS?=
 =?utf-8?B?WmQzWWtxbFM5Z3RQM1NoOVV3c0h4MmhhQlNJR09VcGVnaUY5VU5HWlB4MHBD?=
 =?utf-8?B?MjdaWXVyWnEvRFd0MGczZm82RHc0L0E2TFdTV0txbWdmNjRWNzNOeStoY2J4?=
 =?utf-8?B?MWR4MkVlSVg3TE9qUkpaTnI1dVkzRVNxcUVhREtsRHQ0akdvajQ2Z1NqUjZs?=
 =?utf-8?B?eUkrZGh5czJOM0R0ZU5vS3ZSSnh4SERVZ3Vwc2NrdkpEeVkrbzBZaExVNS9z?=
 =?utf-8?B?aXV6ZHhDMkJ2YThjSWt4YnNZd0NmMC9tbk1ndE8zUDl2SUNHNjhGT2t3cUFE?=
 =?utf-8?B?bjNmMUt2d0ZPRHBWeHErTGtsZGlyR28wZHk1bEgvM3BkY1NkVE11UmxzaGtZ?=
 =?utf-8?B?TjhEblVLZGJ0Wi94U1RuYWtHdHBOdWg5c3lvaTh2N2lmeWswdGZMZEhYSmpP?=
 =?utf-8?B?RTRXR05EN1g2L0diR3dUaGhKUkpicVNxNlI1cXR2TnVHVndoQUF0aWszM29M?=
 =?utf-8?B?MGFkOHRyNnBJc0pWUFpQQzBReGViaERvaEYyemh2a25kVXJwTEREaEp6NjZi?=
 =?utf-8?B?OEh0N2NHWmVzNlNNT29Jd1A2UWV6RTdqTldtKzJuSzhubzRiUTdVbGRuNjFH?=
 =?utf-8?B?Q1JJRS85UlhxdXg2V01BNjlGZHRjTEtuNU4zWnRvVG1oTUZybWVRRzMxaVln?=
 =?utf-8?B?cEJHUmxCK0ZvQ2E3TWFlSnBQNTVxZmI2TklTZmFzcFpTb2Y0NlhxTGdIaU5G?=
 =?utf-8?B?bTJycXoxbXNpT0lKeTF0K0hFT1VHVGpjL2Uxa2R4MWhPMkhYbEozUE05UTR1?=
 =?utf-8?B?eGJ6QVJiaVNUQkxpZ1o3UklRM2E1cG1pNUpXUFREdTVmZVpLS2FlUUdsY1pB?=
 =?utf-8?Q?pQwz/5suNQzr6GiW1I+sxljrt0CYWBio?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVQyWWNVNGtDY2JHQVNoQTBENmFBQVFuMkZ6c3hsOCtzd2paSkdvQ0JiZWZw?=
 =?utf-8?B?R0JXR1BacE0xbzl6Z2dLV3l1eEVsRDZsWDFjbkRXSW1CeGtLbVlJaUxjUXlu?=
 =?utf-8?B?VkpGT0dacEpXc1BoU055RnlZREE3MWw5am1HSW45bkZYM1IyNExWUEVNMVNy?=
 =?utf-8?B?b3B4RTNuZU1seENENU1PcGtibVV5UXZnZzZKWWNQYjU5b3h0bllPTndSSXdj?=
 =?utf-8?B?WFkvTnJidlI1dm9YbjdFV0l2OXRocUNGK2hxWFRSZjFDZmlsRmdrYmhuR1NR?=
 =?utf-8?B?Z3JtcUZLU3BKYkxuTlpDVEZ6OHUvUVpaZEtrUVJjb3dHQ1lzTGkwbS9FQjR0?=
 =?utf-8?B?NXU4WEpyekhXN3NhZGtoNWFFWFU4UW1VbWRnTzczU3BMOXJlSitGd3l2c0hm?=
 =?utf-8?B?VnZoMVFUQks2Wk9wSlR3ZUVuVC9HdmI2UmFmNHNCV29tbmdjTEZuNTlieXNX?=
 =?utf-8?B?TGJKOEc5ZXNlK0xyTzlONkJPeWh1bzFtRWdTeDRWYXJxWE1nQlRmL3dSUmFm?=
 =?utf-8?B?ekU2Q3NsV3NUSjdYNHJ6U1BGYTV6R29RYlRtSnNDNDF0OXZpamdpZEVLMkd6?=
 =?utf-8?B?ajJnSmtOOE9ieXlyZkRiSzNYenJXN3JSbWxFYVM2d3l4QlpRRDBQM3djNy9H?=
 =?utf-8?B?bnR1cndqOVFZVjZ6TXViOEcwMHVnQnFlTTZ0cjY4b2VGc3pjWmdRc3U2eXBu?=
 =?utf-8?B?QXJ4TXlyM3VpN2dsVHhJU2d0U0lBWnI3NWxYYmJCUzhpSjFIZ2lHNVRicWhz?=
 =?utf-8?B?RUR6ZDZUMHVkS1hEaUFwOUFDYVI2eTRrK01YTDVJblQ3T09odnR6OHc4REEw?=
 =?utf-8?B?cDgrMy9EcDZoRmJXK2tvK0pkeXJXWWJlNkozcmJTQUp2NVFkQi9oR2NiaEsx?=
 =?utf-8?B?OEtCZ1BBWHZSb09lK1UwbUo4aFUwdkM5bjBDOUY0MUtySUpqQUlBQlhIeHFI?=
 =?utf-8?B?K3NkOTZPM244SGJ6NmN2enp5MjlJZGZ2RjR2c3Y0UDRqNXdicm9XWHloVDk4?=
 =?utf-8?B?TFNkckZZVGJUYnloMkp2L3BkaXlrR1RCNHZKTlh4VW1JOGsyZFNsN3lQdTFn?=
 =?utf-8?B?YURHZlhxYktxY1o2ZDdrMkZkbGdHM1FPL2ZsN3AwYmxma2h5c3NWb3pXOEtH?=
 =?utf-8?B?VkpnTnJOQWZyNWt4TVhkdEViN29QYlFNdVM1VDBHZHltejJ4UGxMV3dLdEN0?=
 =?utf-8?B?dG9WaDZjSVd5aG9Lamw0aFczNU1mZHh1Vk1qMjU0eHYwbHJCL21UaG1BWDlm?=
 =?utf-8?B?TDVjRit4WGVpdGtENGFzWEtnSmZ1R21Odkw3N0dzKzZmelZhVUZmM3Z0NkUx?=
 =?utf-8?B?WExTT2F2QjIrelVWb3VpYTJPRVZLenhnNVFocmtpVlcxbC92WVpabzZ3Ym5y?=
 =?utf-8?B?TkZxR211NDh1bjBiYUVSL0NEaGM5ZmxvUHFQamU0UlRnbFV5b0pyWFFkWHJP?=
 =?utf-8?B?K21RNklPU3Z1bzJhcmxuM0M5OHo0YWtSRXRQV1NZaU9RbklvQU5zem5SY01x?=
 =?utf-8?B?SFFxSlVZZXZUN21IM2dFbzczR1ZMTXU5ZXBSbmYvbEk0ZmNCRGFGOElmUzdp?=
 =?utf-8?B?cmtOSWZUblZlRTlEN1k1Z1FVRzlLSUk4ZUlFTGY5Tm85K1hlQ0w5MmxJL0Nm?=
 =?utf-8?B?a3dtd055SjZnR05QVEhEbmg0TXlNc0RLZDcyMFFrZ2hzcTUzcGNjdGdudHRu?=
 =?utf-8?B?K2tjRUN5NXdvTVk2WE9yUnZmSzdSNjhYallOMnB3Q3hoNmM4VVJTb1RDM0Ji?=
 =?utf-8?B?SUpUblhuMDlKWU9iVFl5R0NENGdOSSs5eHZFMTBqcnZTK0tyaTZONmk2UEh5?=
 =?utf-8?B?ejFUZHRkS2VXL205M1B1NmF1UFh4Y210dk9ONXZaYzNLSTFWNGZGM1lYTk1Q?=
 =?utf-8?B?L3REd0k5Rm1VdDJ3bEI1YTQ4ZjdrUUZZQ045dFlhanhwaGVzMGZYSVEvWjRY?=
 =?utf-8?B?amIrYjBoZ0VCWFdIRGhOd3hORFo3K1lUNVc1L3ZTZ005OU9zSU9nKzdFRHFi?=
 =?utf-8?B?eE52b2ZKVlJUbFd4OEhvODVXMHYrNnJEODk1cUZyYzNPU3ZsZCtDYjI3QW40?=
 =?utf-8?B?SllsTTVlMjdVdHlhZzU0WndUOGErbmFHSHdPMzl6MENTUWZUOWozM1NFeWE2?=
 =?utf-8?B?Nlp5OHZuUTdhVmRJb3pkamJxUURYQVZLVFA3QjRiaVBvZnVOQWhUNXh0S2lQ?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KvpzqFRVEvJdSXi9IYhnC+5gGiMM9ahuR95XlFOMWszLwdxbwycDn+TS0DLBbamQSLRwY3zXxsH+xwlFSxtZuPd8xJh9Oxkm0DH/IBhojMQc5tJ0vY5+tst7+MHMWLPdDpXwRcS3mb/Ni8ycqQMfMwrlLdXELpFA/NowtPMIvs2ygFWwKxZdKz1GkmXI84/hMwx9LSNAEuB13Lmv9OUzDLBFB58lnVXRR71ooWMitWsmBip3QWP/AlL7kN0dP/fAXJoWj7TIjZkYZE+w00uMYrX2mIOody1Wrmv1M8CZlGzDemk4k8/bLBnMKNy+2BK+IQGzj0aesQPkW48gniALXC6s3q/dZN+1+jL4Sce5JZMjz8Am+iVtPHUH+Fh3dGrg0j1SOcfoqFFLnGbzvLEcSYBnB29HtQg75+nNvrOb6/Aj1Cm4Ibx6L7TQ7CWxhROzGYCb/fHkp6OEiSt0af0a1WUdLFpIdWlwiRo6Q2qL5nv3yeP5yTua9GIGGdy1GeeGNiprWa5tJeDYMuaOpDP+r4oIjVzuR4Jqsu8lRGI4iPB/w3VTlDX3eg+2kMZjODSTB1ewolFS3MtlLwg3BYUzKRq4njGLRTVky5R5Hw3htqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d3af14-3c22-4f72-1d7f-08de16479fe2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:30:01.4800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyjcuBiNB1XDLFUm1dDg8qaA0/rbqoOvmbLVtl65Zdz56RcQsVRuN8XEb2MTpf0yGOYVvEI/yOjY9+65cAoykF1k0Uhhs1/oh/PDrp+UP3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF3367D7B9B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280148
X-Proofpoint-GUID: ajHeEIqIzjvR9gSPbYbu78boicnoCGrY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX1v+HASH/wpq5
 9QH21VkUpfq+zjy2S5rTrrgOoJh3JC6/9K77O9+A68E1MZKfLdYDkJTpEqaTaFUoOiXam+FcrcZ
 p17bUEuSfAl1viKv1fsakpdHi9n95mUuLvsb3qq9EG2QBWMdKk+xf2bBstddjRxRS5iMQJ9/qdv
 58TFtIiclJaPXqt10dEm44qAGMVrpxyDjnhGYH31PtWquvJtAs27KVw0pfMDsvIY5YCeOULH4Q0
 dDXyNIp37nFK4FKVPPw5nBye+/IQbH1dJqaVH6Cyz8ZsMHDXUWramB8wb/tT1+VqYF12DLEqNGL
 iwCQR5uKhhu6gCmLkILQH15g1huuuopLvDdgx6Ywp/+Dp36bKec74kiHo/zhfm6JoIjsCUwOqC0
 /MfJ5b978qNTqAJ6zEMVbsPqWaY4uw==
X-Proofpoint-ORIG-GUID: ajHeEIqIzjvR9gSPbYbu78boicnoCGrY
X-Authority-Analysis: v=2.4 cv=Ae683nXG c=1 sm=1 tr=0 ts=6900fd9f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=hQnaECUAx14urkMNP3EA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: 01EC6140009
X-Rspamd-Server: rspam02
X-Stat-Signature: hegndjmeynzxnfu6i33ksk9bjmjmq4aq
X-HE-Tag: 1761672685-949672
X-HE-Meta: U2FsdGVkX1/wWNf3zwUh9YH2pHlUJZu/Z3K3yldevCe8HUwlkL6Rtb32Ypsk1J3jbU260nS2ensHPd5SHk1FiCyWJpNeHJ1jk/5OqnEVM4cDxTmCqr7a/r4yZomUzkF0mbEeO3WgRB3kN6426lbW9d31LmApkjOezJQGFXFGgWw7J9WIxyNzz0nUgvbgX7SxYZsy6QOsVE/efWuJfvWsCrZVi4Y3DDmKVpw9VvB6C31FNnuA62eFE3Vwr3mb9NRT7y09Y/Cx3os6KMzf7IRODQW8usXAAlZj30u3U7eZJTkPksa5Uo+U5e+BnMJrA30iYMFdgyNCnhoQg7Z9pB0YqTqhFwoJCs8WAUOUXA0XTXLx0hpqrNy2MFQg6tH1MvD93f4J3LjhRI1R+QeO4goGqUdD9KdOgvCGdWPcdaR2KkfZjrHHg6r2F4boZRQaOwO8reMbDak3knRxHVa4JDtG5f+tP7EdAqQ+QSoQOg9qgNFeCcA1CtaVi4DTpvJtd1mppiUqzqLkZfhd7WyLDvcOVzw+wB5Ki7ynVGuM1kGFLkhtwnUuZkOqAUN5eJmKF0WX+eSj9IB9+YdWYz7LOfA1KhgVGrlwbXv6jdEoHS57LkpFhZcBamjqukZ7Jgho3y9FXSFTcV6d8bYMytQOgTMmxjxH2qqHx2ZaYZq4pUAHVD+yd12nUsKHRHuO2fiW94nQAwEzlaxLmRnAwNU0Ku+YqantEbe2pkZf4VfMtnwCd6+3u7/JfZGywz7UZah9OoYLcAxkf6kAsIl+eWirDsNfAtnOMuFQzBFzQJ0KgtBc/+rP0aSRyAbdOLiu3KlCiRgo8AW46M5uMv/JNK53yay7R0FAbZeX5BL1ug5Yd75uWed3tZK8zrZkOuszGj0kjH5XWWlAVfUTe40ejJbEZldUbjZ1G/qmj/dBhtTidyAPHtzgZSF2oQoNjI03vPzVaiD+Kp1JOhUijSb0voQ6aW6
 aIMevO+L
 XIhiyT2eoTKamkd+FBUwh+4j29MMWiZQnA50eE1A48oayeA/guXNx6KbvQpHlIEv1u5EKrH2fupuvML4T2T2PAfL7qLRZST1wewTEazU7ngM6V9K2q1HHHN/cpVOIByj6Oo9kEvK/mx0NUAv63lZz2/TxAdmkkRSPfnFnIrQ/FARYsopYN2iI2hUeFISUtfC8lZC8pePJzf8T+dDPj7eJQQ3YNVRuLO5hy+T0rF/Gco/lATotn03hNtzU+PeFbaDkjWEA4QSN8s3xyLr8TP8Q5hQDmmzg0gXPFgARu4QYcyWib24mLfOuW2duMmor9XwGSxHW61OA9GlBbV1Nq2pDz20sWeuUjxrWh7KK1fW8x8b3wu2Uz4hnzDiA+uq5sEzxqVHIp4ZmJ9WKGBsCIBA6xpv63n5s2ONEEssezmDUohxps+wKAFWOKv+RP22k0ezQ8W+G3Pbu29ucZE/LjKn83ukR+oVlrMiQwVvXSQsB2QQ7GXLq/sGeiYSnL51Jqw2J95rcyZFhQzc0Z3i4QWrp3BzJQxYCyBxU3th4/Bv519PrhtsGbJfbU4WHV/qPWQsUN6BWBzNY4CEdNCM2OFMo8VtvnTuQBpiuw6y9bMmqUBzDbaFbMUq+B2Gll+788JSL49omDkDwGUQSSf/rN+WTj5lQmFID8l4+4VIAqpNy3S1UIui91KmUkRkWTMfHzalWa4HTbgyt7RFDKh9KVZ/ATxa0m5KpoA/sDUJPUUrw102XCtziSRBDZrAZmRTLHy5f/zmDiJe/eQBrp5yEYHwEaFWXq8fpdi0HSZh9LJoA1aRvmjp0AtC8GuVRbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 03:15:26PM +0100, David Hildenbrand wrote:
> On 28.10.25 14:36, Nico Pache wrote:
> > On Mon, Oct 27, 2025 at 11:54 AM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Oct 22, 2025 at 12:37:08PM -0600, Nico Pache wrote:
> > > > The current mechanism for determining mTHP collapse scales the
> > > > khugepaged_max_ptes_none value based on the target order. This
> > > > introduces an undesirable feedback loop, or "creep", when max_ptes_none
> > > > is set to a value greater than HPAGE_PMD_NR / 2.
> > > >
> > > > With this configuration, a successful collapse to order N will populate
> > > > enough pages to satisfy the collapse condition on order N+1 on the next
> > > > scan. This leads to unnecessary work and memory churn.
> > > >
> > > > To fix this issue introduce a helper function that caps the max_ptes_none
> > > > to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
> > > > the max_ptes_none number by the (PMD_ORDER - target collapse order).
> > > >
> > > > The limits can be ignored by passing full_scan=true, this is useful for
> > > > madvise_collapse (which ignores limits), or in the case of
> > > > collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> > > > collapse is available.
> > > >
> > > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > > ---
> > > >   mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
> > > >   1 file changed, 34 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > index 4ccebf5dda97..286c3a7afdee 100644
> > > > --- a/mm/khugepaged.c
> > > > +++ b/mm/khugepaged.c
> > > > @@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
> > > >                wake_up_interruptible(&khugepaged_wait);
> > > >   }
> > > >
> > > > +/**
> > > > + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> > > > + * @order: The folio order being collapsed to
> > > > + * @full_scan: Whether this is a full scan (ignore limits)
> > > > + *
> > > > + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> > > > + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> > > > + *
> > > > + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> > > > + * khugepaged_max_ptes_none value.
> > > > + *
> > > > + * For mTHP collapses, scale down the max_ptes_none proportionally to the folio
> > > > + * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedback loop.
> > > > + *
> > > > + * Return: Maximum number of empty PTEs allowed for the collapse operation
> > > > + */
> > > > +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> > > > +{
> > > > +     unsigned int max_ptes_none;
> > > > +
> > > > +     /* ignore max_ptes_none limits */
> > > > +     if (full_scan)
> > > > +             return HPAGE_PMD_NR - 1;
> > > > +
> > > > +     if (order == HPAGE_PMD_ORDER)
> > > > +             return khugepaged_max_ptes_none;
> > > > +
> > > > +     max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
> > >
> >
> > Hey Lorenzo,
> >
> > > I mean not to beat a dead horse re: v11 commentary, but I thought we were going
> > > to implement David's idea re: the new 'eagerness' tunable, and again we're now just
> > > implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> >
> > I spoke to David and he said to continue forward with this series; the
> > "eagerness" tunable will take some time, and may require further
> > considerations/discussion.
>
> Right, after talking to Johannes it got clearer that what we envisioned with

I'm not sure that you meant to say go ahead with the series as-is with this
silent capping?

Either way we need better communication of this, because I wasn't aware that was
the plan for one, and it means this patch directly ignores review from 2
versions ago, which needs to be documented _somewhere_ so people aren't confused.

And it would maybe allowed us to have this converation ahead of time rather than
now.

> "eagerness" would not be like swappiness, and we will really have to be
> careful here. I don't know yet when I will have time to look into that.

I guess I missed this part of the converastion, what do you mean?

The whole concept is that we have a paramaeter whose value is _abstracted_ and
which we control what it means.

I'm not sure exactly why that would now be problematic? The fundamental concept
seems sound no? Last I remember of the conversation this was the case.

>
> If we want to avoid the implicit capping, I think there are the following
> possible approaches
>
> (1) Tolerate creep for now, maybe warning if the user configures it.

I mean this seems a viable option if there is pressure to land this series
before we have a viable uAPI for configuring this.

A part of me thinks we shouldn't rush series in for that reason though and
should require that we have a proper control here.

But I guess this approach is the least-worst as it leaves us with the most
options moving forwards.

> (2) Avoid creep by counting zero-filled pages towards none_or_zero.

Would this really make all that much difference?

> (3) Have separate toggles for each THP size. Doesn't quite solve the
>     problem, only shifts it.

Yeah I did wonder about this as an alternative solution. But of course it then
makes it vague what the parent values means in respect of the individual levels,
unless we have an 'inherit' mode there too (possible).

It's going to be confusing though as max_ptes_none sits at the root khugepaged/
level and I don't think any other parameter from khugepaged/ is exposed at
individual page size levels.

And of course doing this means we

>
> Anything else?

Err... I mean I'm not sure if you missed it but I suggested an approach in the
sub-thread - exposing mthp_max_ptes_none as a _READ-ONLY_ field at:

/sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none

Then we allow the capping, but simply document that we specify what the capped
value will be here for mTHP.

That struck me as the simplest way of getting this series landed without
necessarily violating any future eagerness which:

a. Must still support khugepaged/max_ptes_none - we aren't getting away from
   this, it's uAPI.

b. Surely must want to do different things for mTHP in eagerness, so if we're
   exposing some PTE value in max_ptes_none doing so in
   khugepaged/mthp_max_ptes_none wouldn't be problematic (note again - it's
   readonly so unlike max_ptes_none we don't have to worry about the other
   direction).

HOWEVER, eagerness might want want to change this behaviour per-mTHP size, in
which case perhaps mthp_max_ptes_none would be problematic in that it is some
kind of average.

Then again we could always revert to putting this parameter as in (3) in that
case, ugly but kinda viable.

>
> IIUC, creep is less of a problem when we have the underused shrinker
> enabled: whatever we over-allocated can (unless longterm-pinned etc) get
> reclaimed again.
>
> So maybe having underused-shrinker support for mTHP as well would be a
> solution to tackle (1) later?

How viable is this in the short term?

>
> --
> Cheers
>
> David / dhildenb
>

Another possible solution:

If mthp_max_ptes_none is not workable, we could have a toggle at, e.g.:

/sys/kernel/mm/transparent_hugepage/khugepaged/mthp_cap_collapse_none

As a simple boolean. If switched on then we document that it caps mTHP as
per Nico's suggestion.

That way we avoid the 'silent' issue I have with all this and it's an
explicit setting.

Cheers, Lorenzo

