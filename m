Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA91EFCBD4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 07:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43966B0156; Mon, 16 Mar 2026 03:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0FA6B0158; Mon, 16 Mar 2026 03:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C740D6B0159; Mon, 16 Mar 2026 03:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0FF56B0156
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:49:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52E9D8CE4B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:49:26 +0000 (UTC)
X-FDA: 84551151132.24.6B23ADB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F63740002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:49:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OaHfBMN9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Y1A3/f6D";
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773647363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjNbd4KXGhoZ0ekrH0mayNzW8rY5Bwe69ycMyClFCvk=;
	b=tPnvJn5OAqIELUrsg8W7iw8K9B9AVkPhb9nZ7ogfXwETJENnMr4/Ez2MDPjKmtwcCUlo/9
	jVE/wZycPY+pb0eWDNi3IvqkM20+Vj4WazZmQ6fD77ky1J1jfxrxbfdlkN1uiIJI7AM9MN
	8gDMSKIKtyharIqATbKMUZsuHMa7Ywc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OaHfBMN9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Y1A3/f6D";
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773647363; a=rsa-sha256;
	cv=pass;
	b=utRIcwj3VF5p0lRANCLdCyRlaGQvDVjuxfMpQVD6v96uTZbbQtt4PdhbvDNwxY6a77/vH3
	0qro6ei4WUTi2bj9xMpjJP/f0urMX32vASjJFNL6RVO4o2Od7aZAWc+Vg//ma/mkzuHDKA
	MEwSfsJZ/4oxdEwgyJhwIKq6L7LCgRU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0KxAI1338917;
	Mon, 16 Mar 2026 07:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LjNbd4KXGhoZ0ekrH0
	mayNzW8rY5Bwe69ycMyClFCvk=; b=OaHfBMN9VIfG3ExJEMFK8BY8dE4SMPK++u
	AjvguzKpor1RN/iMIJUUCr3rl4M8z/ZL9g1E+8NhmVv+emMZUWlkSMbcJN45J9kB
	Zptcyv7fBINCPmxnZ7DfUY81xcU1ywtU0RmBh0IjDCoLABjm4K0HAQ8JEWURVXMT
	FgdC1cksKwctGsKOs2KloaCiIQ48uQkbchz5I29b7pTzLoO6WIHFk4/wyy8yIjHN
	0nioa/WwGScmAmXFyuvv9CT08RvsZHDR4cWh1r060WJbBGkE0g0j6YySc/OVDkvp
	w38EhG5BXpeM2foT4QTKKcCrZ0aqMEt99GVomk6ctRnyZuQaAzMA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx3b1qgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 07:49:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G6MJfn017758;
	Mon, 16 Mar 2026 07:49:08 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011035.outbound.protection.outlook.com [40.93.194.35])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4js87c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 07:49:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WDWSK+XYeRLm1a85HSIXxjy85jfnDtmPugTlMhPXEn/ALUgG1TC+AKLJVn03EtonkXaKnR0QbSFMZLQB9dk81i9K4P+T3NfxsruotYxbqv5mWSvRbCY2ebj+M7+vg8eji1Wf9aq88wJMw4t3THYSGeOBi+l/HI2BcRqYvrxnGrxfaGmjTfcyJtzM5/XujabQ34pFL3EG3+HBMPVOk/kR/6TDwLMGsWcSfrWY/2fnlI/moKyJJh008MuIsFYfxhfkvR4IwQ0zLqP641JEM6fu3r7FxmUSLj/kTMotBMKR7AX726/gI2LP0ROrmA2B+xr8u2WWYz9n2pDzH8jOZDg8Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjNbd4KXGhoZ0ekrH0mayNzW8rY5Bwe69ycMyClFCvk=;
 b=XVM9S+CPsqxkLYyxTZL6g/syz+VkcAYn9TKDVIuyzHPA6o+LyrCxDC0IjXCR+TzRmkjkJqIQZK09pX//YXieyFoTUy1pmPdTnAfUqIDNomKP+jzKqWnJR8bsPRinv62Haezta9PYPSWJ/BXVfhMI6CnGeetBzdgl6EsVAsVWctCl9o09awj6n7BXnw9xa9AUeYsIi831FZ20byrMyaE0p8rWRswDqSWjPP70EHV4/j2bg4Bzm4LIEVCTUOBxAjrBTerSMeX6CN22l2mqttxvL48638AcAcUdKBgPLWnVDz+sDRcuf7wJmJSAQtMh/PdXWsq1kWGh5qiwNc3002OAbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjNbd4KXGhoZ0ekrH0mayNzW8rY5Bwe69ycMyClFCvk=;
 b=Y1A3/f6DFcI2CA6N/Lf9FElB9ootwEOOx3P/mvORUOVM8QHOi1FoHmeOaWWfnc+MiCRpdKCnfzhJ/AjO65wZylYUqEwGzMwxfQFKSRZ1DIIOjxrUtsJNfvPTUMS6JEeqIF4Crk0qzrqwM+NFaPO0nfJzaFA2LRKBE3D0L+5Mqxw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB7556.namprd10.prod.outlook.com (2603:10b6:806:378::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Mon, 16 Mar
 2026 07:49:03 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.022; Mon, 16 Mar 2026
 07:49:03 +0000
Date: Mon, 16 Mar 2026 16:48:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
        James Houghton <jthoughton@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Oscar Salvador <osalvador@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Deepanshu Kartikey <Kartikey406@gmail.com>,
        Edward Adam Davis <eadavis@qq.com>, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/15] userfaultfd: introduce mfill_get_vma() and
 mfill_put_vma()
Message-ID: <abe15T7cA1B9lG4F@hyeyoo>
References: <20260306171815.3160826-5-rppt@kernel.org>
 <abe1FHyYinvfLYnw@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abe1FHyYinvfLYnw@hyeyoo>
X-ClientProxiedBy: SL2P216CA0123.KORP216.PROD.OUTLOOK.COM (2603:1096:101::20)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: e99808a9-6a65-4b83-2b9b-08de83307e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	EDPv/EoMhBvt1SeX65SNjd5/ppEUct8JpbUKWluUbOAS1cNmRBrylNCaLCDTjgQXgt1fFiComlYCZle71yyw3Dg08eYCQetm0gjv268iDEurZbo3H3S2EC3Z2SToPFb+Dn5H7fQ3x2C2ztD5gVs319XVYkMxFXugPPYUfcCLR/ijgj3wIJ4MRP1lk5HNQqLaEpvh6KwImgFmhrHrn4RmECU+EXTuGWreUCViIcwXHupDrqcbS49FaW/o2bM5oTvytg9kIwAqeddoC1tI5BwzKKFvLSi4UjrT1Ysww/lBk/3imtGCqnyYBHIRQ4c+rhbGzo4bZro4nDor8Wj9wgpKekxZQXHiI9s0LtwYhG3KJNgdY871sc+Qng7obm6L/egXrdEHDzwrXa4CSPXUqHHbbGsE4XBPskp0cOl6q7laLajgigFA96IubSeDzaux1QJEwA3F+TH28sdFZ64iTvNiIgAasE6grfv3fpqyi7UCnmdwF/ypdaO6oQdfUdedZVgkVjwp+LBEfMOwviySocu28IbZFLKUHFOJ2hCoE+3p71nITt3p4ZUAGpnrUOJDbkwLq6ibngUBwkiQtVDcLIAFoicbKgmyvkbc36d4Lya3YqUshRF/qJKKE3wqKvyZc/C82/Up9uPYH0VkG8N7p7KHUtIpTUygozvN5247IaLZ9/YLC0rNjL8s8gs7wP7eF8R9YxHIFm3/mkHtw603S3bXn/Qua06//p/FqLEaKohcCcfNYjQGb/O6NFSiqUymvj3w
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hEimK2kz0i66IBqlEnLq2isyguTfwCEcfaZrPFOh76ejxfrCyI1U0f1fmQkE?=
 =?us-ascii?Q?FClsFHej7dOpmvBf4Kdedfjt4+UZKqXGlNH9kVyZoP2zpuOv5mxy1gKa03ek?=
 =?us-ascii?Q?55qMbcq8Vl7PqQDg7ASjapI6cNo1+eufWhB5NzYq+2oChiI/tU2GHdeQL74z?=
 =?us-ascii?Q?7VWX6j/K51RMeYsupU3xwY4uBtr9LtSd7Y+TGDVcJlKGz7aRh9A/nPTfrEsY?=
 =?us-ascii?Q?kXHO6mY57o1u6+KYBpADpkNR31FEVU98QN1i10/CNVGisK56/SpncN3pyaJD?=
 =?us-ascii?Q?ILVGk+AujHcWqAxAzVIKKZ//sLQJYYD/SIOxThePcOktYWm/9AQ04dFo/VTE?=
 =?us-ascii?Q?efIAQl5IyqbsEwLAnFGBVLX2IrwWgaRzQAQm/dzwdGZfPevbuETcyGSjA7al?=
 =?us-ascii?Q?0HxHCj5xL2xaJBnVo0m+/M5waarTwUUCN5cHojB29C5I3fr7JWs1Xtuh/YNM?=
 =?us-ascii?Q?t7luwMCW1hkc98nThMAbXAKbFRkk3cx+5FnC0Kd6K2QpOOF9Okw5xCkE20Wl?=
 =?us-ascii?Q?Oeppww5Zwxz+VEqQRKNSStOOYXnCuIKwwjOdFjGdj3jyH9gEj02Bf2tgEGcd?=
 =?us-ascii?Q?9de82vDoZ6eEeqKuXwXidq2NypCJMrSmDdsEhUxgLijn5UORYgEmxNqzP8Q7?=
 =?us-ascii?Q?1HdsGNJI9zDUDfJZtunrGFkoI09gMON7cLQAV3KaDPG4rw+cjzjzM0LzrRfj?=
 =?us-ascii?Q?cwkj032xR6qMu3kUcZl1LoymXblJuPzXiai3UpqLLZBd+wIkqZFk81ZxxBJz?=
 =?us-ascii?Q?jmKK6Qu7EgHHfgG/x2V5fcLr3HVIGx7vzB4RYoFwoE8bga5GCSEOIftu82F2?=
 =?us-ascii?Q?XiZ3RFDAdssY6nzIxIEwDqMxzg6Wg9kGVZZdY+6VYYyx+Znw7eCDo/+Zoi0X?=
 =?us-ascii?Q?/RUhVBhXD9wsubyo+t7sJJE3lDEj+Z5IQxVqOGElghWdkogYy5KRkW3lxch7?=
 =?us-ascii?Q?8uqsRIjaffGTXbt9KlRrbdKq2B3V6AYXPvl5bAc7w3K240rGW1yf/8rEpmpV?=
 =?us-ascii?Q?PaDir+6i59I/OcoPjCO1GxUO/we7idVfgdUCxgcqzx20mGlJCrK8eIkueKlr?=
 =?us-ascii?Q?KUz96MJiYHIRbG56b/fFXe3icN9mh6tcfj39s6E2KAgXBL7VIRVY37atkc1N?=
 =?us-ascii?Q?d70BVtCiEBJ9H5lGcLdiIcmw/EHOMyhD/R0J4bTro6KZRb27zMrhYaNsOHU0?=
 =?us-ascii?Q?wODfuxLDozHr3YBKMnxdBKTsZjUHmNdTdskdX5uemuYOWKsJSvHEIQA0in6V?=
 =?us-ascii?Q?7BGwvu7ND2ShDsnXLGD+CFW1QKdrD/LNBt4BM47VDFYZNnli83nUpeTuJkJe?=
 =?us-ascii?Q?vaFY+JDriaIRR9IhLrsig74JRM/JVK1SKqyrO8t2H7xf4GL0A+T0CB3lmGed?=
 =?us-ascii?Q?CIuR27QXfucLmisOhfY5Zxe84TsB4MMgjb9m+lz7PRiRN//FtgZueAy/iKRU?=
 =?us-ascii?Q?rMV1MTZrZTTeWgRNLsvgH9cjOum6B2pWuT6QLOXbuJEAyjFSIXPxdZn2uz4/?=
 =?us-ascii?Q?8UBvMHmYCC832b7VCqHKYWcCe3XGCwBoNvUc1DbHxfWAZfKFLvSFwVKslpKU?=
 =?us-ascii?Q?fM24Vkntfrmfrx4ET5xOvAH37Cgr74AhcYguCzED3HRRiG1KQw4U0hS4DH7T?=
 =?us-ascii?Q?MOMnH8XAqq/nYpNkf1clcb1jn9kl2zhA2laNq34eNnJmdpYiDeeCDq9Qkwyp?=
 =?us-ascii?Q?UXv1nSNddyhH0XxJyIxBTiwE3oH5i4UuZu88NIrNxgwZyZKJ1RDsUI1Gvip/?=
 =?us-ascii?Q?e2y42inqWg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	s3Ax6oPzRNgPy8OzSqSCFHUFi/RHK8t2Qu2Hzz3MNWzhxAUIl5oxOovuCJToj9EYYynK/HI4cgx8NpURQA1yMH6PNlLcbrE0lENJ8KHPgpGoCyph+cbTm8eqds43LGV6A5K/5r4xvbtQC2OhglcHk1dv027VJlUJPrfFZnNM7OZ/1grTAykWOErPBjJYiAzfyurbERUoNf8FPz4U5QXL8iZhTqOX7QBzsDf8MhNhNFK66oJ0elnQvr3JrTbEIxJrry/Cv2PaWZnP4L6Jr15Ax1i7o7fv1CWm0L/K7/2+e2TOof7ma0X2lJxg1Y8vnsDMZxiLrK0chVLiYiMT5iNW5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ag+fD36u3cKmu2aFO/1W6A7fQGI7YD4Y331eVdvdkAW1WpuYk6JRhxY3yl0lsegsV71qUqBHb5cIa21UkiYt9RcAvbTGpsZxSpmV+kpQUTja381nxA6P0UCJVnrZ0UA38en1roeRQzuw+fQB/e46AOk1bNU0mOBfYQwsXHpsPpBXpgo7S8UsAuhLDs2Sx5o3fqR5jzvijCLMaI7ag2QqJyxje6c8xJ8lIfhBoqMKdNfC4MbLLoNmIqCC/jkAMKNHJgfuApZfMorLIOVWJN+N7jxtw9phMyS7hUEeW9u9kRYJ55wQyMjaZaRLf4ILuDpzTBwbd0kxrPY2Iuye3XuAAIqDGbymkWxO5rN8QLQbRhRse4Q/I+cXulzfLA8EX9qEY0IS3rp+C4/af6yJeeH7ZOQwfNI7sz0Zy/kCxMP1GtZT9lcTcwxS8FUpWWQjeV2ahUL/8B3MsYEkD/+U2zVFrpJA+GrMk1H4sAwYcmuZ1WF3W/8LqUGBCD+s3whq74bHWoUXu4U90MBCxcuow19Ce+29iLXgmF4cvGwPsN5EGyyG5on9IvE2zRpAnOd1DJ77K9+M0zZYAJ9hLVs1t3VYeY7Hd0GGEtkUT1AqjIvK+lY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99808a9-6a65-4b83-2b9b-08de83307e46
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 07:49:03.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltX50i/wGf3dhKfqdVpauTFOm4mX99Nv+8aD6fRJhdG31Plq7fQgFofGyAePWW7xe49S7kNKrTEbGcIJeDJd6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7556
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603160059
X-Proofpoint-GUID: 4l93gyUIfXaX9kKep0wYRmG9KcYP9-bI
X-Proofpoint-ORIG-GUID: 4l93gyUIfXaX9kKep0wYRmG9KcYP9-bI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA1OSBTYWx0ZWRfXzjJHnPbZqbBl
 EtzeFqeRXCWcZkGFL3AjRnRJofVjEfY5urkhas42Q8nQQ67KOOinCysNqON0Mlg/1rUg6wAKg8q
 VzKbQd4uY9DnMNm0iPq3Gr4nWyQ4hT2DQSTZ+7q1pn/F7riv6AcP3a3joXE8UMrhWhU36dPeeLH
 ZT8aW1U1qMtaa7HJJWtBpa3T8hW5kDUo6YhzishBRkHUOVgi6htw389jmRaipkAdQ6vlOMvvQuE
 fyDdyy/0/DK0HqFOxdIM0X1D239YGE6aM/4FtBFSZfOL13uuzOeSVt0kn1+/GCgOL5mtcdvyu8q
 TL1S3zx3CUs03x7b90QNIn4vQpKThQNmZOElqoPGwap48LRU6h19KoBbhVvrrri2afA20IMuebw
 bDbwVSCDa2B7gHqkycZvs9pjOdCXq0Yp3OGn7k9c7zRceS0Vaiw1H0zyg0twvKwejj611n0qNee
 oBWRFCWD+6Urj8LtgLjLDARS+tqzgSQmxb/Imu00=
X-Authority-Analysis: v=2.4 cv=IN4PywvG c=1 sm=1 tr=0 ts=69b7b5f5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=dZbOZ2KzAAAA:8 a=20KFwNOVAAAA:8
 a=Sn8dFVw444JMH4kESNEA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12272
X-Rspamd-Queue-Id: 1F63740002
X-Stat-Signature: ntae14udoimu4cd16auuaj7rtyngjk1d
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773647362-259881
X-HE-Meta: U2FsdGVkX1/HfAvkhZL1APjRG3J8YLH+AxFyr6bhOeQ3sAX3A/PaINQ76nLyOiwIYk3xZBBGRVwjH1I69T1FFILC/YX8YPEddORsndKsgggWKI6egMJSf3A8G6DA5YSSa8A4agJtYfSxEtrCxxOJ/6AYTpneFCz9M7Uq0/F1cZCM/t5Louf4PC9lwEnG0RALB0CD6Br6Kdw9STx0kJmA2KHQ9X3HtPNfPxjvNA4B2n/QAcSWa1TPiq7SJ8joACJPY6YdPsiE/bdCpaJ54kVE4NxuWZZUa50/oDSjIBluPU67QYC01D89pR/xbYMvLf6FZ1o7+3DNiT3kxQJnaXf15fdpwwPsKsmxMTdBpo2FmmY+qgCWYgeAhgz+uOMBw1OFLSdDhScpB+g2gHXqh9C0yJ025BWbfHcjTsnsDTknvvQzBBPyCOtioIkVNhVS+YKFWfc09bjHcx8rjtI7I0xir6oYbzSPCYNagSlyjSM1GI3Hvy21N5j4vs/5pjIkZm2dz/hZwszmnpnV1Ifx++iZO2zMHJ8Bortd/Jqsw1C+fZ0fKXfWJWDLJ2x/ZL2w0QzoaFPxPsABBnkCqzMykuKiLtF+cFsjwgugUX6h3G5lbb+cRaxHereH49shbFThHKo8PX6Sd7rZz4raMO4OJz22ql9dEHZaVvYb3DOcj49RB6otgHzc3jP98KaSJ4CfEGfNHYebvb3whnGEy6WgV21a/rNTPiqIqCM+uflnY/EgLl5MAIiLpAxUcJtnQwu/RJ+0V9DN41jxxf8ImK9s+wWO6lE/P2wUfASAL6uY0AlYGa8qHXfdCgOL/h9LJ9ibUnvJd3RCy83iqWw/YrFSwYj8lGziyrHUeP9tt8s899RZaHkfyRAg9H2yv7vLIDBSiMbabntr6VIfZwDAhX3QJVZrhgHP4/wnrFgfKKCJArTCFwOBVSqhUNHa0Chev7ji6XtBr36oEv0r0rl/DtcydBV
 kGleLEN+
 lqmaMrG7K2Hzv7p1eojs1Fm9gpG2YqvtgD0vsixkBx/NhVrOiu7TKUNpEYoZJrPT1XwXZ9wSMlqTOZZYU2BOFE7Dcy04fsIP7c4PnAIPmbCVs03kxMYKqcm1uBlN8b67oBw7a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Adding missing mailing lists to Cc that I omitted by mistake]

On Mon, Mar 16, 2026 at 04:45:24PM +0900, Harry Yoo wrote:
> On Fri, Mar 06, 2026 at 07:18:04PM +0200, Mike Rapoport (Microsoft) wrote:
> > Split the code that finds, locks and verifies VMA from mfill_atomic()
> > into a helper function.
> > 
> > This function will be used later during refactoring of
> > mfill_atomic_pte_copy().
> > 
> > Add a counterpart mfill_put_vma() helper that unlocks the VMA and
> > releases map_changing_lock.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> 
> Apparently this patch seems to have two issues...
> Fortunately, it did not land mainline yet and can be addressed.
> 
> Deepanshu and Edward sent fixes, but it should be fixed
> as part of v3 (if Mike plans to do so) or as a fix-up on patch 4.
> 
> Please keep in mind that my understanding of this patchset is limited.
> I'm just doing some mechanical analysis.
> 
> >  mm/userfaultfd.c | 124 ++++++++++++++++++++++++++++-------------------
> >  1 file changed, 73 insertions(+), 51 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 224b55804f99..baff11e83101 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -157,6 +157,73 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
> >  }
> >  #endif
> >  
> > +static void mfill_put_vma(struct mfill_state *state)
> > +{
> > +	up_read(&state->ctx->map_changing_lock);
> > +	uffd_mfill_unlock(state->vma);
> > +	state->vma = NULL;
> > +}
> > +
> > +static int mfill_get_vma(struct mfill_state *state)
> > +{
> > +	struct userfaultfd_ctx *ctx = state->ctx;
> > +	uffd_flags_t flags = state->flags;
> > +	struct vm_area_struct *dst_vma;
> > +	int err;
> > +
> > +	/*
> > +	 * Make sure the vma is not shared, that the dst range is
> > +	 * both valid and fully within a single existing vma.
> > +	 */
> > +	dst_vma = uffd_mfill_lock(ctx->mm, state->dst_start, state->len);
> > +	if (IS_ERR(dst_vma))
> > +		return PTR_ERR(dst_vma);
> 
> state->len is always initialized to zero in patch 2.
> syzbot triggered a warning in folio_add_new_anon_rmap(),
> which appears to be due to failing to verify the range
> in uffd_mfill_lock() (at least syzbot says it's fixed [1]).
> 
> [1] https://lore.kernel.org/linux-mm/69b7a9fd.a00a0220.3b25d1.0023.GAE@google.com
> 
> It seems there's another attempt to fix the syzbot report from
> Deepanshu Kartikey [2], which I didn't take a deeper look.
> 
> At first look [2] looks a bit wrong way to fix to me though,
> because it allows operating only on a single VMA nothing should really split
> or shrink the VMA if somebody is holding the VMA lock in read mode
> (and the validation of the range is done while holding the lock).
> 
> [2] https://lore.kernel.org/linux-mm/20260316070039.549506-1-kartikey406@gmail.com
> 
> > +	/*
> > +	 * If memory mappings are changing because of non-cooperative
> > +	 * operation (e.g. mremap) running in parallel, bail out and
> > +	 * request the user to retry later
> > +	 */
> > +	down_read(&ctx->map_changing_lock);
> > +	err = -EAGAIN;
> > +	if (atomic_read(&ctx->mmap_changing))
> > +		goto out_unlock;
> > +
> > +	err = -EINVAL;
> > +
> > +	/*
> > +	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
> > +	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
> > +	 */
> > +	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
> > +	    dst_vma->vm_flags & VM_SHARED))
> > +		goto out_unlock;
> > +
> > +	/*
> > +	 * validate 'mode' now that we know the dst_vma: don't allow
> > +	 * a wrprotect copy if the userfaultfd didn't register as WP.
> > +	 */
> > +	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> > +		goto out_unlock;
> > +
> > +	if (is_vm_hugetlb_page(dst_vma))
> > +		goto out;
> > +
> > +	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> > +		goto out_unlock;
> > +	if (!vma_is_shmem(dst_vma) &&
> > +	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> > +		goto out_unlock;
> 
> In case of error, mfill_put_vma() is supposed to unlock appropriate
> locks but state->vma is not set, so it does nothing.
> 
> Pointed out by Edward Adam Davis [3]
> [3] https://lore.kernel.org/linux-mm/tencent_C43C1BB425D6BA16BB6533FC9E001BC64B08@qq.com
> 
> I think, this should probably be fine in patch 4, but patch 5 adds
> `if (!state->vma) return;`, leading to unreleased locks on error paths.
> 
> > +
> > +out:
> > +	state->vma = dst_vma;
> > +	return 0;
> > +
> > +out_unlock:
> > +	mfill_put_vma(state);
> > +	return err;
> > +}
> > +
> >  static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
> >  {
> >  	pgd_t *pgd;

-- 
Cheers,
Harry / Hyeonggon

