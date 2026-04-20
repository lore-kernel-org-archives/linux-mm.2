Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0540EA71B1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 01:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56F86B0355; Sun, 19 Apr 2026 21:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C074B6B0356; Sun, 19 Apr 2026 21:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACFCA6B0357; Sun, 19 Apr 2026 21:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE8D6B0355
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 21:40:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD3B51B8BB6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 01:40:31 +0000 (UTC)
X-FDA: 84677229462.05.171C3F4
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010003.outbound.protection.outlook.com [52.101.56.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC33D40004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 01:40:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=p3kMYcRa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776649229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bL641kLXVS3MO9pjfFZv+/CUSc0GapdElhnJ5HlU2I=;
	b=Uask+2lMSci2sCgfn+fsVuwvEN4+6lmWqIBa/u3z6s4bhSMcln0GoUx1/SQlud57QA7UsX
	EOmBXXHpH+0mi9i5qxgyC0ufoscEns9pv6S5SqKQuW1gB3Wa+/IER5VNz7TdjldDit4ksB
	oBxJUcUPdZA0fmKpQZEkXuyRLfYyAUE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776649229; a=rsa-sha256;
	cv=pass;
	b=4fk2fjysuJYvNKsFzJIOAqtkZuMiaDfmTgAQ6ys295AknYkTu/m4TdMiG/6AUqhTAzgjtG
	eOfeQk2931J21U2SDIRS06Kl6caPuHilliFgiiDhUJwdTmLcJ32OTuU4F3v4+JNDgv4QMD
	8Dih7WGJeimvgSzhrcv6GdHF/Ij9M+s=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=p3kMYcRa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6u5111LZKyO16fVsZvhWUK7tAF08uDsF963z3196ArG02Vwh+y+2OMRgIyekNPqfrGAYAF6UytNzfcYdVHDeR54MGrg2HtI4x52K9u2JMJEflUHriIyVtpObhEXpYw9KSfAeIU0QfefVRChXVBGD8ZW0qcP6kVMd37a7BRQ6m+5neJVi/LaIozJn7XsYapduJ7tN931oOCxFZgcE43hIF+Ses2q6+H3bbJNN6SV7hbDDFU+uFf4UzPIcJu7HBm5M1jxaWqRP/M064XOjAVajXZh9jDtMXYOl4btO+KKhwrIy4ZD/rYcZMsfhexBvCAFdmfb915ZN53ClxsiRa2rhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bL641kLXVS3MO9pjfFZv+/CUSc0GapdElhnJ5HlU2I=;
 b=Z3fhbZ9ZCQxxINdw8Wx4Umpt07pvCxfHo2PloPCYunvrj2skEv/H7TXzWw7JY976PbXnmnH2LHYCQaHUP0ntzW7vesUOrgvKQLy7e9mNzLM1yNKl1mXFUt4wnHVXPHc2irhHf5X2BtX1XBBzNjrfjNfGtciETM6g01fGi5l1HhdHGNO1LHuMP9nG08WONBMjAYQArFATCXaD9Z7XYJ5ZnPnpO4fE0CArTd0Br4th8KjToMoi60HVzmOdonn1sTNE7UV7MzLA+r2HFfXd7nnoYDJrsweJkzx8UZyREcnUnYVc7e/VTkioBTCPu1RRB1rUoPdWC326FKinIS9woh98JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bL641kLXVS3MO9pjfFZv+/CUSc0GapdElhnJ5HlU2I=;
 b=p3kMYcRaLgpjUCzxD6rIGA6az+MIS084uprQlJghayITpV5+DB41sQsEmgwDF9m0MEC7jCtzIyvKNvZ7QrdgbMQ6X+0/aqvuPmaZYsKQMWViHVqK/6UQq0PYaULKon/9oLz2k1z4dVO7UFN+HbStJTshNvqehqUMyRw9XVYKZEnYZsQ/zz04XKnLXquOjLwiW78yx+m9ByoZKqRYhR0ahed7AfCZ63cjeVVYvkyaGr3Q/68zKjElT4ZbW+rjCICMnmfvcojk+4hmPTtT5wEqjFQqZh11SmqTuBcAEKx+6ozuZ/hmAV3czd7GWNha5y12+WR+CfbDxuAUJHDcQGVE1w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7332.namprd12.prod.outlook.com (2603:10b6:510:20f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.12; Mon, 20 Apr 2026 01:40:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.014; Mon, 20 Apr 2026
 01:40:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Rik van Riel <riel@surriel.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [RFC 1/2] mm: page_alloc: replace pageblock_flags bitmap with
 struct pageblock_data
Date: Sun, 19 Apr 2026 21:40:23 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <20AA822C-F702-4EC4-B0A3-5C5CEB1D1952@nvidia.com>
In-Reply-To: <20260403194526.477775-2-hannes@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
 <20260403194526.477775-2-hannes@cmpxchg.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c231ab-a687-441b-728a-08de9e7dcafb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Uy4h6bY+FrWY/i1PCS8qeJVceJ+xh/U7toEMImH3UPID/Gz7JztFqrTQKJwJHSmeuPbdmFtCVl+xvzPlIjl1JZREv8Bcw2XYuL9cUKDmGkyu2XiLstO7BswtC7RAcEIv1qXC0X5hY5OBEX5uTxwXbThO2G7oEikf8dTSVi1b/ihJWnCQK+zW6gjm+bdkMkJls17KiburggnqO+Km896sCoeMADxuE5WqVr2vnLAL56U8LPy7EGXX/TjHieJXRB/W+dzeqRgW9nVOPf7zVp1D5N1ntEj5zkBhXXaMerUsrb6cQZ0VX0xIbERNisroF9GOGybP+cOLAgCxgouv/ddeR8oxL5mbXB5+AkB7/5k+SzucFsYbgTcOYDWK9V7lsNHl47gavrLSb+szmSn6JN7Wg9wB0WfbQxtWh+1rhj5hF6gwz9fZfLw7a/vpgFbWSBfPKByyMbNN9qkJOGa2/zQ5PDRKvfLcvCgV9r81X9PVNlYnsAMsuZB9xLQA6wzzSrtCsXSv+H8LUQchEDegK5gpL7hnredZm8d85ixGlW0eNRr7vNKVK8nPN9xWlBoHF3tdBSgUBMCFVjdDA9lfCobn+huuKpLAmh6qWFbQI1D7H7jnzaVvwFtNZ6JaebhPOHSsYGn0Bn+Jv6SNYkpD+/k8Ri6ILDv4LL4rfHCY1N77ygFIH3XFABzE9VdbUWpXaYvfvzrOGU7Sl2tx4K02bpWh7x7bwCIZyOalGR87XPF+prY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oaEjoaCpgABVfyUS4fXQsiZwzfKpg/rxnZFtaFR7tXaYhkhCzwuwhKK4e+gF?=
 =?us-ascii?Q?LyPlAUzKaKnY07lR+qPYKLLsCbj3D66RHTbLYO6+vDd4L7fQBYjbY2CHUMaT?=
 =?us-ascii?Q?bZMNEDgkJBR7HrF47Dl7MvbSF0vzF1mloa9ZU2zC+zKALLva1jBbFMmOl1rG?=
 =?us-ascii?Q?zYwde7hhmOwNONsYHezLuDKHB5+7L9uU71CL3rJoCXOohV8hfApm1bvALbpf?=
 =?us-ascii?Q?+S/sBII40ss8HIh5UY/NJsItkwUD074Ha7D2OxQwFqJG2E4VppQlN7OLbfON?=
 =?us-ascii?Q?FMUCw/8r9dmHkdeaDNbm9XFtExWnVHvkPjIY4m0+sk9F0qOIiyJGBS6NMu4a?=
 =?us-ascii?Q?/wbch8v1LshSlvE1FvEqm3EYTFOqKu7XzZVmMtCmcmBdGMJhkPWOKR8wYDIW?=
 =?us-ascii?Q?VUM1TlFk3iN9zMnk6xs9/ignFVNMHuLvrRa0vGWk9+hMydXjOIgumK3hE3rc?=
 =?us-ascii?Q?X46UiF+GM6qIQZ3sepTj8P/+u4klk6Valvs/8hB9r2goTW+NiDTK6FjaDc37?=
 =?us-ascii?Q?d5GSpzls79uScUpSCBUDYrOKvnoYjpQV5W9lwFRwCF5I/i8+t5gC6Dg5nf+m?=
 =?us-ascii?Q?Jjj21RQc1uPs13fqhbDvkJBi5DDonR9dD1W/OciwyCkX04f6Hq4OTO+yEKKn?=
 =?us-ascii?Q?uVenxCg1SoGwCQO3BIbr702haNMxFAvnPBEiyZeDHnZVyQixJp0AZJRAgC8O?=
 =?us-ascii?Q?B8ps1AKIDymIz8kl2S+GqG9DA/SVNepEz+p9Xc0XHPUKA+lfOwtpG1UW4Z5L?=
 =?us-ascii?Q?6UMP1XMBdbN+Tr+TxdLg5wqe3PGS/vdfVpqbd695C7jksbLEl/mHcodMSOZO?=
 =?us-ascii?Q?w6V5n73sLTba7s3S5riYwZC9wm3pO5Kvwm5kE1Jj+MUuzm9mSFMWJEiP7Ehw?=
 =?us-ascii?Q?XtvDhjsUiURF9RNvhIANTNlx0mMCJMSg5ic0Z6mDa7WwxffW86tYd/VN64DA?=
 =?us-ascii?Q?bJjktplXru9kXHSqXKduE+S4ToFgEWb1kSoAR+XUX0w0l74r+OLJAZPFizsM?=
 =?us-ascii?Q?yeasJU1ySJ0H3qHsuNS+T9c6KnfWQEY/bzgT9EOn+TJ9d460a/Lopfp6f9k2?=
 =?us-ascii?Q?FRFnEaZ19c6rW8IwFNpgwvdey9sYMh0/R0s99DtgoXMW5ltZ9xlYctxFaaMJ?=
 =?us-ascii?Q?voEvM1U4pqswyM1vy+GyxC8i5zg/1VwgZk3TPIv6cx/Rf43qZRRWhurjCU6D?=
 =?us-ascii?Q?fjggA6QldkNvgUYy/74NXT4PjNqszgggK+spEeinHqL4iETJCMeLYmb3/gwR?=
 =?us-ascii?Q?rMGVY0+pNTzdSLi/t9rAjeUI5c8ttUWJA1AeUNL3XRP/Px+DpSiBv6tgWiaA?=
 =?us-ascii?Q?1GN78BYJg+9yr7Srck320jJgM5SJKw7fPtTwwwzDuTfoZ1MB1TleehNnwOmV?=
 =?us-ascii?Q?scndZrA9YcJiIHrhBHbKx+tSkRlvJHvG7KYL9mdDzm4Bfu1GK2kemm2q8Daa?=
 =?us-ascii?Q?3jK0fZX/I5WUirvQ7pc9dt+OxF+NiSt6aCGt6YZPUyth7bs3/1wJKRK+K4ec?=
 =?us-ascii?Q?4AjWTeHFeMbsC4f9a6v8WJxOk/3G/WnVhvhi4776gapUv3uNl15vzPASOM7y?=
 =?us-ascii?Q?OCkyDO7RCvQsZjKlumHHJ5fnlkD0AZQodqog33uewiUuAwv87qsZDmqD0F9q?=
 =?us-ascii?Q?36YakfNYRzrqQKplf/RArTjEo4Z4SByc2PwodOoOA5rHMiLl58Nym7mAGvwM?=
 =?us-ascii?Q?URKCuK6QUxw6cVnKgbFlLfWaKN38P49o6imqAhyS68ay6rb3n4YzsbsWfRVj?=
 =?us-ascii?Q?P/GjKHRtPwbrma/Z6MbbgoXig7PPYztf+4HMqLQVdGAwsEg7GiAy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c231ab-a687-441b-728a-08de9e7dcafb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 01:40:24.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcJJsqWHxVn9qS79mv35omW+TL9DT8s5KdXYWlACszVZdw4sGAcMISmeY8gofufD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7332
X-Stat-Signature: x3p6znfk7hcdfdg7ati9fz531sdpr3gu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC33D40004
X-Rspam-User: 
X-HE-Tag: 1776649228-639112
X-HE-Meta: U2FsdGVkX1/VQGa1Wm5h3yqyWMtkSEV0q0VnzmTRE8sA+mU2gH/L/3XI0c4qHK4C82vCl8sry706BJm2YGyE6lDdLfEJzRZwh9GVqSgNtw3ZCiO+pJXWVVZCsm7Ocf8lzcC6/mfTq7egiIfqcfBRcxieJqvTX0K1ku172e1IAG8ZHwUxo4Cp5Gt+RyDkaNRgeBH+H9KfLmMv0A7VH15rBlM4XU3tJuyMnSnf6wnTOwVD5WTsxqXU2/7rsHcHUgj6pmcJlz8S6UGAAZ6MCFql5Zos6F7LrMstGmGVohP96aljl5qN0c6r2qWPkviHcuVviaFhQ1KH2TNdFKJoV7CGyih+pBRW6kLOFqWFBuiGP4TVZ1qi4Ljn0ilgW+OTfcYEQ85hfYziBBn3rNRdnRX78DtcmPLpM2R5q36zzZE3lN8YGLV9edX40a4ZRYR63oLch2SPLwqaE4xq+ez4zKuGAVPzSplNAFj/VwOG7y/JJ6liMbvpYdOwphgLcRVa0L47uNYLBOu7UmeXAiZ3Fh3PktsgKG5lCFMdOulUSR10rsE+Sm3vPp13aJcGuDpUEJ8B6LJ6sgK4MKXm9t4UsnnqJtzCH8yKQz8wpqSWkIdUOuzeFk16zP4e+jOhIk76McifF+RKp32/mX/UkdXENyhLbr39NYu9Ywxk+yfPon3nytsOnGc6mZllJIgA7QZbR+EGXh/aLJ7B7XI49S8kaivLVlOuwdgZ6+bDkCbbRnbkEv4l34KOv96Lfk4FxEw0/XekB0Ek3OGtJCal/iI62Sd5WtVAR9JbvQfU23ZN8fYZl0NWk/axy7wZfs/vWmGBvdJyeMUYAkbUanXzC7gtzf57TQy4AYNNBvllj/DYf/RXLLYEQLbexFxx/Mw+/vxyE4T0uOjyDwCa84lpS2m13vXoPiIv365HapNOopm/Sp7iW3QbKZWKUNpEJcAz/CmwUlb0wjbuR30NyZM1O8jcgNp
 wcK1qpcg
 aH3x9G/ytoXHUZvE5x72JD9DR2fQfaTjeO6Luj4aulRb8tjC24JcdLS40Bokxbx3Qu0SWpd5W4JpZM1YNTVm8QoZh6BvOIG3DAqvYIGRqY30PlvaWwDj5nEl+SFwP5SPFVShbG78wJDiYqudG5AVH1wnLRlyRHlMwmYnXSbUG5Sges6Q0Vyof9+1AtQCzelj46K9P+paVE2YMR1J6jcOBygk2ctCxXxT4q9Pcij0P1xWGpc9PuXggpq2YrOC/NGJDf6R2wpiXH02nQpQaSsamsmliMPKPGfqR3BgnG01xEC/VZRWk3V9E8NjOl+UZqZAowWm2vqBGpu1kvyJyw0aAUCBpffRFMNBv0CKsZuboV+IYl8fgudXKrDLqEvWSCvPeUldFxrwuyJnOVoDYMUjtb8KAZ67L0SLva8TDJhIHnkK/j3N0GxPsqX+EVgYqGolCWFlc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Apr 2026, at 15:40, Johannes Weiner wrote:

> From: Johannes Weiner <jweiner@meta.com>
>
> Replace the packed pageblock_flags bitmap with a per-pageblock struct
> containing its own flags word. This changes the storage from
> NR_PAGEBLOCK_BITS bits per pageblock packed into shared unsigned longs,
> to a dedicated unsigned long per pageblock.
>
> The free path looks up migratetype (from pageblock flags) immediately
> followed by looking up pageblock ownership. Colocating them in a struct
> means this hot path touches one cache line instead of two.
>
> The per-pageblock struct also eliminates all the bit-packing indexing
> (pfn_to_bitidx, word selection, intra-word shifts), simplifying the
> accessor code.
>
> Memory overhead: 8 bytes per pageblock (one unsigned long). With 2MB
> pageblocks on x86_64, that's 4KB per GB -- up from ~0.5-1 bytes per
> pageblock with the packed bitmap, but still negligible in absolute terms.
>
> No functional change.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/mmzone.h | 15 ++++----
>  mm/internal.h          | 17 +++++++++
>  mm/mm_init.c           | 25 ++++++-------
>  mm/page_alloc.c        | 81 ++++++------------------------------------
>  mm/sparse.c            |  3 +-
>  5 files changed, 48 insertions(+), 93 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3e51190a55e4..2f202bda5ec6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -916,7 +916,7 @@ struct zone {
>  	 * Flags for a pageblock_nr_pages block. See pageblock-flags.h.
>  	 * In SPARSEMEM, this map is stored in struct mem_section
>  	 */
> -	unsigned long		*pageblock_flags;
> +	struct pageblock_data	*pageblock_data;
>  #endif /* CONFIG_SPARSEMEM */
>
>  	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
> @@ -1866,9 +1866,6 @@ static inline bool movable_only_nodes(nodemask_t *nodes)
>  #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
>  #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
>
> -#define SECTION_BLOCKFLAGS_BITS \
> -	((1UL << (PFN_SECTION_SHIFT - pageblock_order)) * NR_PAGEBLOCK_BITS)
> -
>  #if (MAX_PAGE_ORDER + PAGE_SHIFT) > SECTION_SIZE_BITS
>  #error Allocator MAX_PAGE_ORDER exceeds SECTION_SIZE
>  #endif
> @@ -1901,13 +1898,17 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
>  #define SUBSECTION_ALIGN_UP(pfn) ALIGN((pfn), PAGES_PER_SUBSECTION)
>  #define SUBSECTION_ALIGN_DOWN(pfn) ((pfn) & PAGE_SUBSECTION_MASK)
>
> +struct pageblock_data {
> +	unsigned long flags;

Would it be better to make this uint32_t if !CONFIG_MEMORY_ISOLATION
and uint64_t otherwise? MIGRATE_ISOLATE is the only reason to have
8 byte pageblock flag.

<snip>

> -#ifdef CONFIG_MEMORY_ISOLATION
> -	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 8);
> -#else
> -	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
> -#endif

We probably still need

	BUILD_BUG_ON(NR_PAGEBLOCK_BITS > sizeof(struct pageblock_data));

just in case in the future we add too many pageblock bits.


Otherwise, this patch can be sent and merged separately.


--
Best Regards,
Yan, Zi

