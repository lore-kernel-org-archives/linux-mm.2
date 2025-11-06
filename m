Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7A3CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 18:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A658E0003; Thu,  6 Nov 2025 13:46:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31668E0002; Thu,  6 Nov 2025 13:46:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA3D8E0003; Thu,  6 Nov 2025 13:46:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC5D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 13:46:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15126C024A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:46:38 +0000 (UTC)
X-FDA: 84081063276.30.935C3A8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8D2D6140008
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:46:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BoZ3DK2A;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=neNiDo6J;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762454794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFKCEXmZj5ujeoiG+UVXo9Ywi1hdDyYmtZcBBaQqass=;
	b=5WyvfWK6CnUTv9a07teSIy2cgGouhF58E4rpiHFp+6WEJdEqcNHpSt+SuoCyPbUwGCIepM
	g3WvkthnuI/cx6moujK0bIJ67qLvpijS/H5xOKSc/Rlkhdq3YT65uO/uKzY4NVxmE1/c5Q
	3NWrWEt8/mT0uR3W34GmNPJbAlG0BU4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BoZ3DK2A;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=neNiDo6J;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762454794; a=rsa-sha256;
	cv=pass;
	b=lYc7egHs4p5Jh6aBL03mvZTHzm3Ip1uXfeKTFAcZKYQ0lITQIdF5L53mTtDZz+qQEHII6q
	N0yyPfKeo37WvQ7BT8VtXMVXdK6dbe90oeZc48B8QvaUatvny9MGrI3MSRil9gnSKxk+3+
	8fA20/HsB4wYYU8HgD1gXfe2ewIxWB8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6IgOkZ009164;
	Thu, 6 Nov 2025 18:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uFKCEXmZj5ujeoiG+U
	VXo9Ywi1hdDyYmtZcBBaQqass=; b=BoZ3DK2A63dREcRCw0oA0h2TL5OBEBwGuf
	8a+pttlVX0WfN3oPGJDWvlf5tYsjg+zT+39J+Ibiqgci4u8Q9Z7FXURYnA1kLddC
	dGQkCxp7EPFQZ6DRLv/WpEKf8EuGb6p2NZLX5FR58xAuYUeRc34I7FFv5liQklvk
	ofOLrHZjY8bcMrQs5j5tn0PoRMiyqiwgGMKLPGD7rFt7hKUIamlw6dYEo4ESvPgg
	s0PfHPj3ro2OhZ3bQtpb2WXwRPV3KERSEnlTjHIT0EaFRMFGTwWTIglQzsluNylf
	olwtFYBdBBewn4xv+qmT9H68iSp9RGGQ8e3djJKhz34RMwP1wMYQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8ykwr7uw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:46:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6HJpau035859;
	Thu, 6 Nov 2025 18:46:02 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58npm53p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:46:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eEk1+fZ+an+DRb2CGIpt6TUqsisxjshmiv4kTPs5QhURNOpqxC63BWzaE1pMt4wQ3zBOjXbEL67TANLUpGUXK+/bXQdiNkYZF7fKO5vNPKtUxAho6e98JjrH2GvdThaNSJOobiVGRJKp0B5WxYGgzvk1gtutc7e28cIZPWUiIA1aKdrO9RgDtgYTBGV7ymY7jE2wLgKsW2BDI2X5JPiuXpml5Yw+PSK3mRwRLmDrEWGhMbNtQxLKdPg7Pm029plf0BUYY7QtkaJ1K9Gm3/5N8lexUDf+3DWPgEm58UNMDC/6s+NQL3xhUMXirXTl+DYXPkVTDX+IWCyaAmzMb2ZwSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFKCEXmZj5ujeoiG+UVXo9Ywi1hdDyYmtZcBBaQqass=;
 b=ANd8ybNWGcCXVYRsk2suf3HGTjy4P9Y1jDvG8B8wlLiKyYwbU6jDt2CTx27VQ1IhPssjWQLzHYHXEbinF+ljN+2PeoK/VmqYpibdJEGlll++Kyn+VdUSo0r6kCm2mQJPciAXbPOcb8juec8mMsxU9AxuQGe9lbulP96J7JQROn+MIhaTLtmVKRjo4D2gI4QHV31ax+3vdHfsVVefbsGXDXyW0ratIqZzU4F76rfMtR4McW7SeKBWs5w28Eb37oVRxRcguDeNDuVcdQoSj4KBWVQcZ93nEd9QFl8rR87mrEnz4VJdEyIsn0fdmy1MxwS+f9f/f5A/5SaXdQUs1gEImg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFKCEXmZj5ujeoiG+UVXo9Ywi1hdDyYmtZcBBaQqass=;
 b=neNiDo6Jm+bluPIv/N4rY68y2YjKsUi9ZdcLqPP9QldEbDRp+o+bYZJOMWfzju77i+9C0NdXDJF9sOw56KhTr7PAkMAS76Z1+IuW9vk8bNsmJP5L6qVmcrWpQ9TjuKncdGKgLVHxM9pI85mxOK/xPVCvOYS1u8CL3EzF3m3zAzo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4455.namprd10.prod.outlook.com (2603:10b6:510:36::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 18:45:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 18:45:58 +0000
Date: Thu, 6 Nov 2025 18:45:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
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
Subject: Re: [PATCH v12 mm-new 09/15] khugepaged: add per-order mTHP collapse
 failure statistics
Message-ID: <ffcf2c28-d0ae-4a45-8693-10fb4dff8479@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-10-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-10-npache@redhat.com>
X-ClientProxiedBy: LO4P265CA0053.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4455:EE_
X-MS-Office365-Filtering-Correlation-Id: c52325e9-de07-4390-4389-08de1d64b9d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X3BPgGJN8UXDLpkQ/gRzndedyCYbpF12J7sv6dXIMDBkcBxBHPJWf11/e/6l?=
 =?us-ascii?Q?h76+QqE2jIbvgb3YO+qj8idtyXdXWfKIUvoDTV5KKO+UGDKIigedHHHS9X0Q?=
 =?us-ascii?Q?roAearyZDkauKOx9smwj0fh1ijp49Q5oUfOkzHH692FrO0PENWzA05GLKof/?=
 =?us-ascii?Q?IfK5UffiszWxdS59KdgOGv3vnGwj5XfmUJxEh4gF2eKAyBt7rJVAg9KgNaDy?=
 =?us-ascii?Q?gsU2hheFWhFHu1i2hEYA1d0Z3QddSyjs2aUh6i0nR9l5X9K7xtqCNdldO8aS?=
 =?us-ascii?Q?2E1XxX9i/gYoQiNSEZpDnyw93fkqXISvlF4gl3ryI7fJGkLXQu02upchcfVJ?=
 =?us-ascii?Q?+XwLkMQeojYLXn5uliaLjEW5yFf5vM2ll1RN0YGRoid6/6VQrgwLHwJkUNxD?=
 =?us-ascii?Q?N3peD6fb3a/PliZFZD1mgEa/dVmNaZ7yQppnFBb8VNkTA6GAWS37w44VHLQT?=
 =?us-ascii?Q?sA+qPfUUzXvxb37hJVh9ho9wLF5vdcCfZEmBt7aiF7iwyATzl+Pdbjf+6GTU?=
 =?us-ascii?Q?4iJsbD+NHqbx79xmHbfJrFha/Z2ZDbJhadbND/2CVUpJs/vhv7G1Gz4AuQxY?=
 =?us-ascii?Q?JO+cR3CPNsZ7H8W1rwgux38YIAy6eDAEB7yNFMi+rIpfzMsm/J/Kpp0D0eo1?=
 =?us-ascii?Q?9we3FYwHr1lZkm3yyn+5ukvRGVq8gZLs4spDpAYfoExCdrQfvIfH45mvvvRa?=
 =?us-ascii?Q?sI9RgQ6LULMZfvDdSUTojWohz0AbtrOm8ybCH6s1woMgeIUHKGfvlJ5Eq7PZ?=
 =?us-ascii?Q?QMIH+0NSZLIQ4Rk0qCwO2N4JtZYdNgn2TDC07fpllp6jcPXk4Cn7Px7tRIW0?=
 =?us-ascii?Q?U468PbsDVg6Jt08eBkRsrkv4TfLJn40X4YEZWJMjGyNtr6QKFsOv8m1A3npx?=
 =?us-ascii?Q?AALhsIhmJiqet3MjRqUNLIC5776Bmj7gUkUz6KO0uAl3i35xv0aWOj2wdm9T?=
 =?us-ascii?Q?uG4Re6irtddU2l1OTjNxW8ccZ1MbGaQh4WKaPmFYmDvVQ3c/KFsGzFpIfEY0?=
 =?us-ascii?Q?NEffZ9qqywfA5ic80l+qKzCJ0bQ+DrTpxtm0yCxAslQliuHG9nxXRDcHEidr?=
 =?us-ascii?Q?t26oU17DCx049Gm+y+Tb0/oGXA+Ixbrbh6vYCwB4MXRN409xB5r9gvL5XF1u?=
 =?us-ascii?Q?5nUitCD7vMR3GxXuM66zy389kwlwVGUCEeFnf9UxKdlwjElj8R59IuxCiX9O?=
 =?us-ascii?Q?uLYOBzMv2vx4Y+n66L6uZWoJMfbzYeuLBD1H4Pyq90kYTsn5K70JOKUTMYhN?=
 =?us-ascii?Q?2kFc+9fRvRzOTp7uxlHZfw5bBMpBon7eCRMqmtFLW8C3oyxJkqsD20jeN/PU?=
 =?us-ascii?Q?60Ik0SKImPYJUo/c2tbDW5OVhA6A8ieOXv1aPTq1vKO2No8t25GnZVQW85fu?=
 =?us-ascii?Q?zRQX1n/X8ArBcMbHUtTWLyrebo9bj2A9O0Ejj6+mPmEHMuYIBf9AYJirs1rl?=
 =?us-ascii?Q?05DU21alZl5iAyPBhsSrHyIsnVH+q0Uf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iEnuJCf4512aJJ/Qovs768fpBluTizwvkunEAMSpWC30qth8Q+ni2ZRaLjja?=
 =?us-ascii?Q?TwUuZ6/mRjI/K/iKNnowaWq6fsYGCL+ZnV36uJO43bFuOq3XIixRCizJvTWU?=
 =?us-ascii?Q?ygSTzHKM7a5qaqSj5GMLaHwunPgyIOfxC0MwM0sSHwskkWc9srhOr/gQBhgS?=
 =?us-ascii?Q?+puULjYXHitMm1DZBkGDy+eGJz72leCRu2ig1yWmhLq4ZWAU3uolMCJmUlxT?=
 =?us-ascii?Q?gwInwdSuNKlKl0vtVPBaiQ5+3vO0N9wL+vmP6VSM0WSPFQsPGNPZwt9wRzFu?=
 =?us-ascii?Q?cno/vI/jZA1gOOQv/+UU/wSWXdLVMVYOG2YuR4E2hNlwVCk4YYl11Lr+KXM5?=
 =?us-ascii?Q?XTwbL2UnlYnSRc1NrWdt4J/8wuG32TRtHdi1ZxwuAP3uAVhYy3jMz387fH6A?=
 =?us-ascii?Q?JoqIBxORCvojK3hwzHylFmny+K+IoKmKKKq1jaKYx6r8V6mW6x7EZ9l7fVKU?=
 =?us-ascii?Q?QqzG8pt27X1fZEb4h7ZVC3mJmMDsb4G/xPmzbYyRl7gmnoBAKbnfKG3BwJjS?=
 =?us-ascii?Q?zXA+P35WUWy9gaE85/4vLJHyU6RrrleBgBslkbavr31xQENpwE3ipp80Y14i?=
 =?us-ascii?Q?wX+rNj1SQVhkrHCtc5cON0uCO39nQfzX9h6fFvLwxRBiA+AjL56sErH4TXkH?=
 =?us-ascii?Q?Y6C8cDd/MQzkwLfKwXAGn50XB2vepZQaLkgf7DI+a/fyhfV5+ftDouRlMWgv?=
 =?us-ascii?Q?qdJ0RCodujpw/wgUe7L0y/XqvoePQbXH/7OMDfKZJPTV2FfH/DE9939n1Buy?=
 =?us-ascii?Q?tyBrXtqFiCP9KTztwEulrmN6lchLp8dMyx2oa243/VBsSUjkTB5MOvRWjF3k?=
 =?us-ascii?Q?1x6Y7Z66n2dqC4Xoc7rGXF+6oGMgf/cKaPTepB/gM2z4jvu/MPwKBl5h2vLm?=
 =?us-ascii?Q?tZwoXjU2ilhyNOntA0yWI2aLQ8xTr+D0qnBZTKi43GcUueB81SNbjOY+ZCkR?=
 =?us-ascii?Q?XXG4fa2aWNgxojI59HN0YjYOLsjrVV163fYJ5R5srg3WQUJ2F4eZhMKa3/Gt?=
 =?us-ascii?Q?jTun9X0PTNaj4R/FHnlVsa/iGWHcX3pI1Yfti6eIW69dpbDT6bs+0vvy9uUJ?=
 =?us-ascii?Q?VkxhRlH4kacqCyiGLHTDWRk2Pny+wLGdz/KmI0+GC+9cdFRIByXMLPNP64H+?=
 =?us-ascii?Q?56BIPQSvuNN8BvByaCJdND8HdB6Il+WXwEohaZ5ETBP+dVZldN9qkiSNbqpk?=
 =?us-ascii?Q?qOE7DNBzokzbFekgxyQkpnuaU4aIbT9cNw9EvfpsJ/ayZbnu32PBw2PYGFtu?=
 =?us-ascii?Q?A0aQct2Qz+fd4T9EWFePbaequigMnnc3ZKMYGaKsN0azTZeUxKl4TmcOM6yN?=
 =?us-ascii?Q?/lYHtIjVbd7zhLrCQF/zMHcFrU7qqPGgIad8dHrgwHYE9tXsepD4trclBzAL?=
 =?us-ascii?Q?2sTLicYCD8GrBDIX3Q7bOtSlDGuaYzn2Z+tGwsGN0HR2skAWiC63Ajmo0YwM?=
 =?us-ascii?Q?1NyCA/dK4sVVzm9ZlrzrLpzPVd4nHg285BjoZF6yFt6GZghy4z6hibxOOr8m?=
 =?us-ascii?Q?C4VUTltrV3kHKVv8VlZMupTuguP5JpeMyUQhtw1csHQ2xXWkO9+cvxAXYCZE?=
 =?us-ascii?Q?1vdaV5K8M6MLlAl62aUNk75DPxqDEo4+KRieviSEMoNCVe6lLFcdVsf78KGe?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w0ABI7+amjMiBdmq0SZMLdCWe3RtFDNxnbeWYfAQf5X/ZPEzgt9ukyPlM7clI6tQhRsOT2UFTRU9uYT3aaY+iZN+H2GYNLw2oGKoWm8XIVbgOSfL4w2kMuY2mO6GIjLnAz+RcB0AKJcBGWjpXEXnjgUCxn8jvmJa/IbkAaR9FGo5TLW8L9xCSc+aZKCfKIF9W30Po3BE2A61dcvlBHKjcWl++wn2uA41o9O4AEogqPqMJ70pF39UcK/9rPe1BmiSJX/c60T+2VAonmrFSny2iNYxIJ+nB07YcPBEjEc1Ege3mDnrbewME+rC9YdoCjjpYfaluTzuDZPMO9+Ze3JBdyJR2TwXCqTcTEndbhyxuMLXp6N5xMVfq/NqnRrKjW5Fha1PMs5aL5IrESVrAc9IryCp2zpjNq55uhtvDXF8O9JNSpuGW/fpeuYmEySfbPmcEVPyJXuiQz/x22tmyJh2MemTQCmVQcPuhZ0ZNWTG/U3qPmFsIjaybFBknJYeVrC+lO/nQJhTbFGxtiDvogOiSTAxUyTH1tzqh5ARBzJdab/X2INHQAsn8OI2m7FYn6hHfuMAZ5kZ0PYZ0JtI2pALnbGfwlp5IpT0Z31xgVU4AjU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c52325e9-de07-4390-4389-08de1d64b9d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 18:45:58.5847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWIeAmMOn0oN5j3r7hMnQEidVDuoEVnm7BNoXe86exDXWGVP5OCPtAhL2o4tUAhOJ2bxNlByjRQbI66DIhliiGG3bqvjWc3rHyfFmeQwPmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4455
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060151
X-Proofpoint-ORIG-GUID: mzfx4_O322hknjjGBaQ8jYlSC4LDCYRq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzNSBTYWx0ZWRfX9uzvmozKPCP+
 rgLIvy7OisHdTIKjdbCIVL1JibCQPwoMZ9GDLqFYS/RBmVLKBpEgt/7+Ql6Bxsin8sPVtD0WC+h
 NcV1Bq342JUGIUE7B5PDse8gr5suTyjsAmda0W/B6e/2xQ21gqkVpeT04scc7MEdScztXKWvuCa
 af+rIgXmzr4ZKVQBi13HJV6Ik1lMw3LQoV1JptWQZZYh4TZcRGARsf7QAycBS7LfF2NqYOMfsk4
 BIy3jEc0L+8B9Jkt1Y/MHLPyZ5hn5cbP4sVEIIJl8cZrX4ukfNgWWmypbMpijsFusfOwgSeL3ll
 ln/DuoFIWon+VIUOV9OuDcNWcxlSo36+jlKgtPB5vhNf0AbV4DTQoOGdr3CdtkZF31VTHFU4NyH
 zxB8DZiEf8iNKofYBd+jW3Xgd0JbzBZn7hO2qqrCJndBC9IzJJA=
X-Proofpoint-GUID: mzfx4_O322hknjjGBaQ8jYlSC4LDCYRq
X-Authority-Analysis: v=2.4 cv=T6KBjvKQ c=1 sm=1 tr=0 ts=690ceceb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=pumSfOYkCOYgfgdkRRwA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12101
X-Rspamd-Queue-Id: 8D2D6140008
X-Stat-Signature: 8okb5t6ze3hapob9k19yuhbpo47j93xo
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762454794-710673
X-HE-Meta: U2FsdGVkX18JSr1EX79JtIZrmzWREPaDsbMdyajJ0ZEY4rfltZO82yITK+JGsApH4Qp7z4JLaUZUsBfWHtwa8xIGSq/QJgE9DJ/zNtA+Mft3yiOFzPi4ovcvLeHealC5smmfsUrkMVIE8XaI17yfnbmBvtM0DXB3+ZG0dfjLkJmk3qQEawxKlufV5smaSa+f5M8+niDAVsFeDz4C9e/APGhOUtvkfuKYh7BDMf4VK8olrW1x+2bHMSZ8bLfVYhYdkB7ArzU2NozqedibEK+H+3bkjibZAw207icc3SgNtYhCUmL+kM9tvrybajX37+aGIR0xj+i1tNPTf4qZ9z50Ej7XvS70BwCxiC42yeCGENqU4TyQcwJOD/Wo++fhC9CC+HDwCyJS/h2T6NeunSn5vTA0lx5da8TC+OzI2ZAAD3x3ot/j/jBaa5tjNZpTJgmGTH1wZg0oHjyuI4GLcQ7zMVn/sFxR/K9suBUGhk0sDjGgXC0383Iiv/5RcenbIiykFyU7FHp0bcsRhvBMGxUFZiKb9X0bhOXK5rsYQQGxu+7/ySk5g4YGQQiEJd4336Bx5GB+G3DzrkhYTjtiiwsTcypV8CMH16AetWROO8B5ySdwEjyraKAYnkDU23r4l1lKtPUC98BAOqe0UZ/Bq9T85VvCDjxHwn1OIeFwhvOs+N5KR8Y+thcBqs4UqRA1BR5PcqAFvROdB65T6cB43pVURTlVsvHIxq4W/bln8JnMWTBoNqG+ducZK2Ko8HmjZW63OKVFjPseSYd8fqExQxFju9zu4GlIrPfktQY8yfw37q6T31zhv5sST5laa7g0kajMR2KkCsdh4gGi0Ty4QAAooZTgNNC20AzNwmVugbG2MV6DuheMqBrqWWgmFps/X3mXvdaQF7eqbqP9FzS5xnhpI2Ddd8A7v3gn4YjnMm0zowhzV7qC6XjVRmtlgtVwBuLMIB+bs5u16mt3ccNBqvp
 ECoUB937
 IZ4BNRKW8FNDnsQNupEDpzP/VOf23meQLHgHw9akplLkkwNDTqIYxwZjXgFx1Cbgp+/a7jZ5Xlat4GxnrDUVIeu8Y8DPgP2qPbrd5dBT7TWrZ+bIAii3VnotyB9xNtrhGkq69MaImophDumn1qTiepp1cV8mclNGlQcJfI6VG46446uxAKXusmcd93sy+CqApLJHeLmhvrzvrbhD3JfEoyDT8TEJ9VO2m3+Q74zUZYBdFnxy7OgZHaGo8wETuEHp7SemtMklO1nTgBownHN1erYAk3saJVCHG0a5LE1yiiur+xpunGnewdvGyLDgnnDmQuog6ovsgwTX7VcAXOjGEbvwOnYIrBrA6dvJzvjel5QGsKMxxpD6fp15MNIQS2nizj07fwHbusF0EUjNmNr/vygg6CQYRZh7/kLEBugl+FUCqBovdw0AJRiG+66CVnZCa8JJUwTNa19QPBUrE2r8IxJzyTNA/PHKhp42Q3obffJJzicfluq9q1+CxD534IqVHZjzXU2bYLJou09ua2KY2OD3UUHlWiJ5ICHBX0UaCGtdoaIUM8fNyfLKy6a66m7XCiN7WHsWT3MfCAagbqf4D6q6jR08HgvXeyNUO7l1TADwIKj6D39JTF0UXE1XeKabBnd56WbxYJUd5BWbFZ4V03l6yFp1C3OXVB7BX8KIlPlR9GqajNi+wX+oeS0QHD2nxriSc/IiTofzFy7vGvxrzh3Dz49i43pBtdlmxxvhKdy4xbkLbpnlAIa6iIiyernRZyfemT0M1olsVghsOXiH9u2ENBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:11PM -0600, Nico Pache wrote:
> Add three new mTHP statistics to track collapse failures for different
> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
>
> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
> 	PTEs
>
> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>   	exceeding the none PTE threshold for the given order
>
> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
>   	PTEs
>
> These statistics complement the existing THP_SCAN_EXCEED_* events by
> providing per-order granularity for mTHP collapse attempts. The stats are
> exposed via sysfs under
> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> supported hugepage size.
>
> As we currently dont support collapsing mTHPs that contain a swap or
> shared entry, those statistics keep track of how often we are
> encountering failed mTHP collapses due to these restrictions.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 23 ++++++++++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 16 ++++++++++++---
>  4 files changed, 46 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 13269a0074d4..7c71cda8aea1 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -709,6 +709,29 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even though it
>         is not actually partially mapped anymore.
>
> +collapse_exceed_none_pte
> +       The number of anonymous mTHP pte ranges where the number of none PTEs

Ranges? Is the count per-mTHP folio? Or per PTE entry? Let's clarify.

> +       exceeded the max_ptes_none threshold. For mTHP collapse, khugepaged
> +       checks a PMD region and tracks which PTEs are present. It then tries
> +       to collapse to the largest enabled mTHP size. The allowed number of empty

Well and then tries to collapse to the next and etc. right? So maybe worth
mentioning?

> +       PTEs is the max_ptes_none threshold scaled by the collapse order. This

I think this needs clarification, scaled how? Also obviously with the proposed
new approach we will need to correct this to reflect the 511/0 situation.

> +       counter records the number of times a collapse attempt was skipped for
> +       this reason, and khugepaged moved on to try the next available mTHP size.

OK you mention the moving on here, so for each attempted mTHP size which exeeds
max_none_pte we increment this stat correct? Probably worth clarifying that.

> +
> +collapse_exceed_swap_pte
> +       The number of anonymous mTHP pte ranges which contain at least one swap
> +       PTE. Currently khugepaged does not support collapsing mTHP regions
> +       that contain a swap PTE. This counter can be used to monitor the
> +       number of khugepaged mTHP collapses that failed due to the presence
> +       of a swap PTE.

OK so as soon as we encounter a swap PTE we abort and this counts each instance
of that?

I guess worth spelling that out? Given we don't support it, surely the opening
description should be 'The number of anonymous mTHP PTE ranges which were unable
to be collapsed due to containing one or more swap PTEs'.

> +
> +collapse_exceed_shared_pte
> +       The number of anonymous mTHP pte ranges which contain at least one shared
> +       PTE. Currently khugepaged does not support collapsing mTHP pte ranges
> +       that contain a shared PTE. This counter can be used to monitor the
> +       number of khugepaged mTHP collapses that failed due to the presence
> +       of a shared PTE.

Same comments as above.

> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 3d29624c4f3f..4b2773235041 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -144,6 +144,9 @@ enum mthp_stat_item {
>  	MTHP_STAT_SPLIT_DEFERRED,
>  	MTHP_STAT_NR_ANON,
>  	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> +	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> +	MTHP_STAT_COLLAPSE_EXCEED_NONE,
> +	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
>  	__MTHP_STAT_COUNT
>  };
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0063d1ba926e..7335b92969d6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -638,6 +638,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +
>
>  static struct attribute *anon_stats_attrs[] = {
>  	&anon_fault_alloc_attr.attr,
> @@ -654,6 +658,9 @@ static struct attribute *anon_stats_attrs[] = {
>  	&split_deferred_attr.attr,
>  	&nr_anon_attr.attr,
>  	&nr_anon_partially_mapped_attr.attr,
> +	&collapse_exceed_swap_pte_attr.attr,
> +	&collapse_exceed_none_pte_attr.attr,
> +	&collapse_exceed_shared_pte_attr.attr,
>  	NULL,
>  };
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d741af15e18c..053202141ea3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -592,7 +592,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				if (order == HPAGE_PMD_ORDER)
> +					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out;
>  			}
>  		}
> @@ -622,10 +624,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			 * shared may cause a future higher order collapse on a
>  			 * rescan of the same range.
>  			 */
> -			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared)) {
> +			if (order != HPAGE_PMD_ORDER) {

A little nit/idea in general for series - since we do this order !=
HPAGE_PMD_ORDER check all over, maybe have a predict function like:

static bool is_mthp_order(unsigned int order)
{
	return order != HPAGE_PMD_ORDER;
}

> +				result = SCAN_EXCEED_SHARED_PTE;
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +				goto out;
> +			}
> +
> +			if (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);

OK I _think_ I mentioned this in a previous revision so forgive me for being
repetitious but we also count PMD orders here?

But in the MTHP_STAT_COLLAPSE_EXCEED_NONE and MTP_STAT_COLLAPSE_EXCEED_SWAP
cases we don't? Why's that?


>  				goto out;
>  			}
>  		}
> @@ -1073,6 +1082,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>  		 * range.
>  		 */
>  		if (order != HPAGE_PMD_ORDER) {
> +			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
>  			pte_unmap(pte);
>  			mmap_read_unlock(mm);
>  			result = SCAN_EXCEED_SWAP_PTE;
> --
> 2.51.0
>

Thanks, Lorenzo

