Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4B5D10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94316B002A; Wed, 26 Nov 2025 10:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C036B002F; Wed, 26 Nov 2025 10:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D347C6B0031; Wed, 26 Nov 2025 10:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF46C6B002A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:06:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E06F13B6AE
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:06:12 +0000 (UTC)
X-FDA: 84153083784.06.A796A81
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA8124001F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:06:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ka+Uncqx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zcEQH0Js;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764169569; a=rsa-sha256;
	cv=pass;
	b=W7JEx3mGMPaTXm5n7JNJ0pVRVvh4xZw+OD4TQulieWOc44tNIQ6Z3KTRLW41bhcHDr/NHo
	xpQATxtu3knj9WfYGrMSNxpDeqmsq85+RgYXXGAHJFUY8BbCUy5zLz+NJ08BwP1QUwbL4W
	hHwx9OjyZcOSLgtXdykDjwNuWDVng0g=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ka+Uncqx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zcEQH0Js;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764169569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV6ngxkjE7gLkivzx9HvmPUp8ebol1BiwQ+h7NI7XQE=;
	b=bWL7eY+9vuTEUSPGTxWbVBxsUxvounvEHn0u0dpfLDkFZ0GRw0J2Gg4lVT9/BVWDwZ0c0w
	eW6b7LppfAPRylgEDKZPc/UR6iAuKwXSGJaY2V9RImVJfLk2oWxkvT9XxufJNM4EnoL0/t
	yytFUFcMsHHfPH386LzXQkTYLHA1Mg0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEuD5a2463599;
	Wed, 26 Nov 2025 15:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qV6ngxkjE7gLkivzx9
	HvmPUp8ebol1BiwQ+h7NI7XQE=; b=Ka+UncqxM32+DNm1jtZpfI+cck5nBoMKkN
	AZqGjZ24Fg7ckApfkpmcJYQv8bKqyiH5tCUeX4EzZE5UqGCQ79BCFXZfDIsms514
	aBNhB9KsiNVnpbX2AO1VPl6tWRAILbByWbAHGtaIfQZ7/h6ywUPEbl2sHSSDhvnN
	JEGyvfT3XqIaXZT33n1LUXnJ2GNVigGoA9ZnCjKfgUqUSLQDEMZrgKzLXZ9Z91mH
	TLvFRZBEGwpjzk6NdZUcBS1kvoUxjdUnnZmU3dogggh8dQP/59VOf2WGocXWbp/l
	YmLkoTLdip8Y7bT54F96vZ7x/TevP7oj9EUGMIpaRwI3SJZekbQg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fkmfs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 15:06:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQEPPAj030106;
	Wed, 26 Nov 2025 15:06:00 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3memug2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 15:06:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dHpO7Z2AvzRUFl4OPDeU2i/lP10J3/M5GvYqqN4qV2k04cDNaIUF4Z1aJ6AIFJztEGdBnKKpPrvc3clu2tQBCPTJ43aLzhxyRJ27Axfujtt5ofiVWqAFAIheFAPN1aw+781c6RZg/wqOps2sIJwGvzlJY4FzQ/Z3HvysLb/9MOXKXufXYAfHswqUsGBFUZDlUWdcLFJ1NdX2z1CCN0uRRXvUgaiS25grDT1caUKj1Ivo4XUrd/VSAwpZ32IuT+bQBqcX2vQBGyMevmITu68TT7y/6PwTQuOzDBi1o7qRPycDA9owGNXT6ITVOx/hxOnsJwsIvs+EBoKEF2iQJDBoZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qV6ngxkjE7gLkivzx9HvmPUp8ebol1BiwQ+h7NI7XQE=;
 b=p+LcjSk0E86aS59iMnxeFjIx0sJ5Ht6hAiJWnXMxLbO/1mqUEcy//ZM8QkUnS+uIMYUOi4g0DB+0s03ma923iVxTla5lux8dZjuENZsc+9y9lTJVPXDGsepHPqyeyLvOWhwbC4eHfbwvpOXQaQAysb5KGBAlAY7SNa+WJ6tHdHko5p2QrxIyLjCvwz2agisvemaSBP1Wc1G/EbGvV3vuDgJo/U51eMZxt1SBJNNW4WcdAkW2vxmbHkDncZ6MDs/E1ihjGgBGFQ6gmbUB+5mmq8F3slQkV9veQnynyYdObQBH2ihlDaUKWFGU5Q46WgewpAZhd7HXZ7Vq/VXr8hYbFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV6ngxkjE7gLkivzx9HvmPUp8ebol1BiwQ+h7NI7XQE=;
 b=zcEQH0JsUj03HSaaO6v8kdWl0o7nFoNa38zNlEWS/+GWLmzE1RGu7flqLhmC0o9vrv5oA76kts8fzwM8P5jY+r+xVnk6bqSBfl4DFLOcu7yH94UmKwQvJ0py+TioUJi8zSvgjbXYPOVzNpw21/Zh8PcXnn5G3jI3m/fhzlAomY4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH3PPF18C4487EB.namprd10.prod.outlook.com (2603:10b6:518:1::78b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 15:05:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 15:05:55 +0000
Date: Wed, 26 Nov 2025 10:05:49 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
        James Houghton <jthoughton@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH v2 1/5] userfaultfd: move vma_can_userfault out of line
Message-ID: <i3qrqbj6nhqpjrnolg2zf6nmbdwsw6ejgmugzkeg6iqsi22jjv@ycv5iw7iaeol>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	Hugh Dickins <hughd@google.com>, James Houghton <jthoughton@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Peter Xu <peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-2-rppt@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125183840.2368510-2-rppt@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4PR04CA0288.namprd04.prod.outlook.com
 (2603:10b6:303:89::23) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH3PPF18C4487EB:EE_
X-MS-Office365-Filtering-Correlation-Id: 37aba908-9f8d-46d1-f82e-08de2cfd4c1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f4VWeY83vzZ0sfGEp5iSg/N3h5bG4LDPOffTxK2MpFJsY3gNJiEJaQfZvYyC?=
 =?us-ascii?Q?WDGXZtYV8gqvvuFBIjLfB6ykTItFNem+elAR4/wYSf6Ry5Lj9+fyhawI3O6q?=
 =?us-ascii?Q?2YBJGJBqpC+cyQrJNQx1OAV1j+q2VWXY6kKSYIYiJYJa+JPmnUBIDl6YLvyA?=
 =?us-ascii?Q?zTeNwGQ1gms82Gnb/bV5N498qpZ+4sBWOE4efKyxwM9I0ZfxVXeHyKTskqhu?=
 =?us-ascii?Q?eC34ZIoDHbSZC6mlKp3Ul6XgEr4xfYsZBva6pa26KV1M1k0RBKM90S9C4sgL?=
 =?us-ascii?Q?OlwnzyYaQRstkZ0U0jyWxcFW8nlLcIpt6/N4b9F+Lq3gyoFKNtA/dIBOzEbS?=
 =?us-ascii?Q?7srNKB0Tvo3RE/v8xzeJFcD+rda/GuqmEWdNkGZ1akyaf0GahWeWAX1k1Dy1?=
 =?us-ascii?Q?tWLt19qwS1W1gHtD0nrhnCPymzn6UwVxtvG/HFc9YxJxSAiKMmAsM70fl7Dw?=
 =?us-ascii?Q?aQn5ZtkiLm/u8zSt5QSHRwM6V4M7KRMMvIZs/kgDJN4JI0Scitk2BAEnUY0s?=
 =?us-ascii?Q?UXQ17KCtRZOjRzdx3oB1/e/Tyuk2PgWrJ+KvdhsGYFCi8gm6agGfVtLZ3Xn1?=
 =?us-ascii?Q?AXrmOovqmIFpphiDDMwIkAAznAqwDLOJBQGq3kbEP8euJV6wXpvtFvvKXAkd?=
 =?us-ascii?Q?mSVJJ+plinwWjYC4ig/LMziptrD2XV+J0mBuj3l5F0ikQnu1Zuu5ahrF3h6A?=
 =?us-ascii?Q?leD/HWBNlCMTH2ILIM/cW7R325UMqhHUOvlrSSVMkdO3oPUc7CNmhAcfk0Qm?=
 =?us-ascii?Q?HHuUhllPvIytrMKAOUWX9r+F4ditAHEbfp0zIntPyTx7mzgFSyABTOUjVX7c?=
 =?us-ascii?Q?Rebt7tIo513oHPNgo+Lf6fGrIagiZJgHpmd+0UEZ0LYeenXeQYTrS2K+XHUu?=
 =?us-ascii?Q?ocvOT/5yH3NgS7gzxxGwv4z3T8cVnjnWHBDoRErKw6OHYpDA5GpAlUat1X5m?=
 =?us-ascii?Q?TNwMO0w6d3EsuD/Glr3qcUmYf0cT3OfRRwEOTsg3xwTj17uaPnZ10UdrkFyL?=
 =?us-ascii?Q?3d2O+doyCVPgnvXApQ1VO4w3DvPQ/rf/Jog9eyqDILnCazbYpNgh23sUjeeq?=
 =?us-ascii?Q?sIK6PM+hpLY9sQpOLs8G2s/p+Q6moBvSmImy0UBCo/WWpc9392cc8TD6rX+B?=
 =?us-ascii?Q?2N8wU7AfF6/F1VFSBqgtCbJuY/tIE9Rbb5X+ObEZeSyom/jOEkjfsYnWaKih?=
 =?us-ascii?Q?XUc+p4UFiqmTH83PAvSLf31SQhtlIFCKRlKa77BD6e0R3zQJ9anjKPCjJki5?=
 =?us-ascii?Q?17vnYnfgVHvHiXnGQPl1dJbo9eEtY0YsV5QjMQc9LRc69K4wrtqYnrMlLEZK?=
 =?us-ascii?Q?0eRQ3ONBIf4tRZvSRnBjRwazu3ZgfY5ce4FHI7w0rZfaID5wuy/kO+5Xyp//?=
 =?us-ascii?Q?5GP2HYEi4RN4pv0UqzqNFewgOa2f27kSc2eW+BKTKKRjhLRAavFbxyrg7jlI?=
 =?us-ascii?Q?bzp8Oqdtk+/1jwepS5gZG/3l1gn8IlKZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x4+bJdtEwF13KE+l8s7KdwLcWelueGZ9ajaoYzmYFnO/EUcggEPCBaDsC0pO?=
 =?us-ascii?Q?Lnq/ZkNVJ6m1feBHgwlhUQWZO+uyB8r5f4lBmoCmLPbmMPDMJMF3Iqmhu4+Y?=
 =?us-ascii?Q?J/ecwskpA1hLymS9hXPRiwIlwfEHkq25NtY03KXDKq8ifwZcbwmZOjmf+ckd?=
 =?us-ascii?Q?D3tCNVP2X9zpn3025sRzxqRRERpXtBPw2tb2VjA4MSxC4mIhBix46aI3iuQe?=
 =?us-ascii?Q?R6rSCiuDevuXisuwiYMRnqOpP/6gYrzG3W6SJa66Twou2wdVDYUNQsYzSaQ/?=
 =?us-ascii?Q?yuS4S3l6JPTyS4PZzg8ZOPW2ed0AG7t262Gnc/bkbgCDnvF6ijh5ZLccGudX?=
 =?us-ascii?Q?SeglpHIileVPGRHMamQcLgjQdgK3za0vAO1aaJTy88kievMLTfc6rrVfm9s2?=
 =?us-ascii?Q?Ne3auDU3bBVFJZ+ORfDIHyD2+yIDdMtd7ii7Cgf/W/DmKWIuVAp3cUNYkZhA?=
 =?us-ascii?Q?99UqiJ/OqUguGp7UmDWCRTXqgkHGYW5XLVBB2aq6XXXcYUtAdwpbm7RgFMdJ?=
 =?us-ascii?Q?HWz2gKSzqo1mGlVBWQbdKHkpE63EcLRziu6WWKYWuqU0jWa7uKeandHQOGTt?=
 =?us-ascii?Q?TT0YOL71+aevEWDR70KI9AuelfCgoVGAa82kuzrQlGUDCKX+q+oIrUFfsxUS?=
 =?us-ascii?Q?383QmHszRgmoc4lrLB0ns0j56xNQj7HMmwmszWkqrpnAQ4U+o4QsgcfTXko5?=
 =?us-ascii?Q?q396yJM9uezZ6fNSudOXNGEkFe0a//Rx/4suE8vWErSc3Xgi9R9kuxnaI9qs?=
 =?us-ascii?Q?srxORGH7n6IDZUhCQx/NHsdT7cVkqK1YulT/bHz/tHEY16I3sCEgDzW6JUMD?=
 =?us-ascii?Q?eDi3mE1v4yg9p3z+yqxjpIH+M8R2vzBVx3Uz8PdkwWY4vaIffaPbZ5j5QAx7?=
 =?us-ascii?Q?sPO5jj6P1O+TaJ46Is0lM6G1ZUcI9XgYMn2aAHxMdhDxzQHleEfmeAPO82br?=
 =?us-ascii?Q?4zuu5X3ucNv3ECVU5ORKUMiqlDQto1wXPzXfXz0aE9Lchc8h3cBNl47jIKS1?=
 =?us-ascii?Q?iSuneBO0qyIwIZbFKOpRoZ479sJxNK02lxF6JZmpNzjFi6i1FnnS8oijatQe?=
 =?us-ascii?Q?tWBskiFmMlhnPSYqmhoV1/4w8NcucQfXYwQiNirA4WaFUnt5E6uPB+suPwLQ?=
 =?us-ascii?Q?phJVLsgJ8cIUre0Co4OsFd/ecy8YYTSQchKrXzcKYbTRdLYyGb73u5p7iDNa?=
 =?us-ascii?Q?lnsXs9IJcVbVrO0wNaDc0dvwCCMXG37yFmr4rbFTsC96JvmiRmNfR5NBC6O1?=
 =?us-ascii?Q?RneaSvnD+sXroaK/Xu9hctnF3q9eSAEpDER0MdIoYpPWIvwcAumrhUDLw9Mp?=
 =?us-ascii?Q?YYjig/uJ47/S6jA4/LzvL1PCwVfkfu0Au66fZSUvj5A3KP10DXVyC6rJP/4R?=
 =?us-ascii?Q?1BPfo+Ajq+1xLhBLsJlwHPpauSSa4EfiPBzkICVCg3PaAiyZFyuYatFWf8Lh?=
 =?us-ascii?Q?zX1Qks8tY2Duk5IPPA2b9h0CcxFJH8DIKggeqpR1xL8eBz6dxkehpuXK83wC?=
 =?us-ascii?Q?xjqKook6vwim9ugPNE4/EUch8rEBzr0msiwJQoxp8TrokMTNCw7vjMZch4TY?=
 =?us-ascii?Q?F+Ng/dRWA7fLpBPBHsPq8QVW7c8P+IwyUyzlU6s8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vCmqX/V4oLoF2Ee9yuMGVCSJyq4Lrp89pmgVWZCPSdlzXFbiAYunTmfcP+jkiMtVSK28QTUhzzTFEFbpBikZq736MH4fq5QQ18yW5eT0k20aLk3lOYavWknOGwVIII9GqikB6vf9WkcJNRvEF7yFFeTmusgjPgXFdZVKT4N3mEn92QFjymhIky/FUfBFTcTeNgoxzcWaTXxoARwYsp2jxeUDJyOhSIOMF2K1QsiD6do5wtgW8HhT71LCR25heGyNhX0CTvm9iCaVksV7rGMrpSGI0JhbWAYOehtqreLHl6dmTxzmJz4wjhDjjKx5EtMRPQ4aTbZhSDjB084wU5CA2KRQ3/iIMV6iPuFyqGbo22ShevEvJ1PBLi7zTwzPtmBh7hJg1hUDlBo18tl5ODEbbdbCD0hnvjkZeKyJgOPXPWMwmB/Fb98XtkC6g26npvBe0JS4QjPfSFLu4PPZ1t9jKt/pCK8jfrd4ITBL5EtFzs75SLOauMFheaTiqgvsI7wcuGlQb19x9Why6XuC+1Q7AgrB5+EZMSeupYLd/RXj1nUSGyC+1/WtFIH/hdZcS0n3cUJ7VtQCSjeFhc8oSo1IIDfXDiBfe7b3yfinwFDsQj0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37aba908-9f8d-46d1-f82e-08de2cfd4c1a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 15:05:54.9952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cX6BBajU0/v8rXdwdF22nfp4CW2hXU4q1YLfOm91QcpXdT3ZRIFg4+msk76Uw5DF4d1yyFoLrXqe3ZSiJHUHOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF18C4487EB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260124
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=69271759 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=LGixd4EU0KPlbEVDNxoA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEyNCBTYWx0ZWRfX1l0t98/6QbkS
 icPftf4PJjO31lvGrJC1YcV/QHKFMRvBcGk7mYt9qvPncI8jkV9OAS6CG1wQFpQFBzsIK+sUSvl
 pb3ZyFVz43rgqq50Wx9tzsx9bXama1CwreNpYFTQaUifH1srqP+JH38VZtDtbL+SvYfoC8M3WV9
 0XqjGfhNVV958DXsiRlcmOZo1zE1cf7c09zARrfKB6Utwm6jNju6s3UNejpg+D1pfOcA8dNICaG
 UMi/6yvZazh4mKk/vlGIc8oE4/9IP/qHe7NHiRfH475LERwW7Y1lSPagjoa57Q4HO6TF525XzHu
 nhwpE2GqBx6Dw3JMOTYB7UubbaD0WQslADnZcrk+IjLI+ZPyu+tOtM27v2nDAqZbnDY9Xs2KXy+
 7m3NPkexqr3aW0eTtqU5dSnkUhBkyYaMlng2qBPRQGzzlEiUl6g=
X-Proofpoint-ORIG-GUID: sT-nZesz0ybPlyB-qjS5ckQBAi8Nwz0i
X-Proofpoint-GUID: sT-nZesz0ybPlyB-qjS5ckQBAi8Nwz0i
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA8124001F
X-Stat-Signature: 6sspg8gjihrj57up58kopfxzoift78c5
X-Rspam-User: 
X-HE-Tag: 1764169568-355968
X-HE-Meta: U2FsdGVkX183mDWKmd/HFyXbVnQUfSi3yACK4nhaYtWjko7qcFtmYdTaA+yJG2BjjIJcYPvc9TioCJQvFQTjOzAKFFJ4krnJgcPULGTCu33IZjsPGrHYYljCpUATry/rwECO+tH/LcUlNgzmNIKn2DzJ2p23i0ISqbpizeaMIpPlIvUEYCNADX2/mVvNBYgdifEbrZnnhGJjDjYJ+IcEn46671L2RvialYSgDwbr7qgNmiWyq8nc/j+c5LOSAr56vqsbm88yLjW1mxAmg8vhHYFt5XhlYpjQH9dMZAn90sT85r28bOF0agsmMDmrMrL3ZqjDC/OOM5UpxJFh39Pa7s5lOulAWUlOjC4bko1mkWNB4dairNbsZ/sZmYtXCu4wG7B72ZdHv/dUkCAIv/6zIwIqegwwuoGtvGdqgKAuHJ1imf7KpX+Meaypht0H/cK8bAevBxho+g3EZySv73Q5TuCPPiycuF0siA5UMppo9cyL3kuU6c2iV6MtfwDeFV+xNYMa1pE+Yws3mu9qrLLGoQzn9U4S3zH3dVFOZgVISUuF0nY3frl2IFaA1atucYMp6Csx57w+pM3+AcRxBU02Quov1EQzyDu4X0NhLAqGppfTJyeBr5O6394ZJmUNTsRnibSUj+FZfp4dPDpEZcgC9qWrRhrKm+UFQJSZQz8ExjSY0m0+tC/f1tXQ55a8/vg95X4szZwsqoZfWDfMUlnUZw9RpDaDBqP4cISo2MzsaFJmh78e1JPkm4rkCKh91fKwum056QfhV06q9IcF7u/9ttD0wPh+nX7JEHXYwXUXEnFUHydAFqhfqlQ8xGETSWDXMc1zavRZIIgxuUZFHT60F4SOBp5wdJj87nKdC+/P92LINza672mT8FSAT4VmdVu3kerGD0qBV3IDH6OvW8D8UT05LlVmJ1aA7vZMFBhS/+PXmQ5Ce5IwBVJwnifyX87cGWgNmSdC92rlqlVhTIh
 TG3nthLG
 We1KL35XcRgtfvF1ntsb975oIIdA9CODA6l5ooTeDEHHjL0TWHkGH5EfirOqEKkpCs0rntrdYjDrzPifPcHhM2KQL3AqhHfxQ+TsSBiVYLTTTmwYZ0NB7krE+0ALRktRBf9xGPCw/lsD/nbRCqGI1Qs48Vz8wcA5PFAh0ceom7JbeQ42wPSeFv4RtTrOXKk37fle1IA0uIcLmQMMwRuP44xhHI+Pcf6KgBuLBTMEhegjeFW36eA7j5DJJO+NQMy2K115X3tufHtQadFgF0chNWiWle0a80ViOb+NMSMG4hmAGQOBklL81NXz6IXefOsta/T7Php+XZ1VPoiX4AGbhN74OnV5DsrtjMmC640dyKOeHXq20zQ4A3cHQiBe5qgEAD5AZnOPScl2zSp6k6pPCDnRjH0QnTD3UAX7yyO3BjwbqG8SkHy3k1KNBUbCDtm2wZTgjZIod3tjZP1YIVSpgcvo/rG5vW/w+3J1dFKVT6FyUqDfIWuOJxNvlp/jvMUsk6SjTjLNlUUGFcaCmnI0M3MsW99J6X8i1R9++qidr5B3OlD8m+Sjrb2BVelzSKc7nqKRLg+qjXBHzn/m5gG4gmz/PtZcMZBTjTkzX9Jt9csKt9zNx7padsYWdsfb1uujxguwGBScrFbr+IcGox5kp6GJatrCSpUYy7MEXHCADe4NWPGV1dmFOjgeIj+cSHWeAkE/7jcdM/54AaXLUg7uMt/RNTi9DKQd1wgvGZI0XOMKBSFRH++Mk0D0RaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mike Rapoport <rppt@kernel.org> [251125 13:39]:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> vma_can_userfault() has grown pretty big and it's not called on
> performance critical path.
> 
> Move it out of line.
> 
> No functional changes.
> 
> Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/userfaultfd_k.h | 36 ++---------------------------------
>  mm/userfaultfd.c              | 34 +++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 34 deletions(-)
> 
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index c0e716aec26a..e4f43e7b063f 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -208,40 +208,8 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
>  	return vma->vm_flags & __VM_UFFD_FLAGS;
>  }
>  
> -static inline bool vma_can_userfault(struct vm_area_struct *vma,
> -				     vm_flags_t vm_flags,
> -				     bool wp_async)
> -{
> -	vm_flags &= __VM_UFFD_FLAGS;
> -
> -	if (vma->vm_flags & VM_DROPPABLE)
> -		return false;
> -
> -	if ((vm_flags & VM_UFFD_MINOR) &&
> -	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> -		return false;
> -
> -	/*
> -	 * If wp async enabled, and WP is the only mode enabled, allow any
> -	 * memory type.
> -	 */
> -	if (wp_async && (vm_flags == VM_UFFD_WP))
> -		return true;
> -
> -#ifndef CONFIG_PTE_MARKER_UFFD_WP
> -	/*
> -	 * If user requested uffd-wp but not enabled pte markers for
> -	 * uffd-wp, then shmem & hugetlbfs are not supported but only
> -	 * anonymous.
> -	 */
> -	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
> -		return false;
> -#endif
> -
> -	/* By default, allow any of anon|shmem|hugetlb */
> -	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
> -	    vma_is_shmem(vma);
> -}
> +bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> +		       bool wp_async);
>  
>  static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
>  {
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index af61b95c89e4..8dc964389b0d 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1977,6 +1977,40 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  	return moved ? moved : err;
>  }
>  
> +bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> +		       bool wp_async)
> +{
> +	vm_flags &= __VM_UFFD_FLAGS;
> +
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		return false;
> +
> +	if ((vm_flags & VM_UFFD_MINOR) &&
> +	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> +		return false;
> +
> +	/*
> +	 * If wp async enabled, and WP is the only mode enabled, allow any
> +	 * memory type.
> +	 */
> +	if (wp_async && (vm_flags == VM_UFFD_WP))
> +		return true;
> +
> +#ifndef CONFIG_PTE_MARKER_UFFD_WP
> +	/*
> +	 * If user requested uffd-wp but not enabled pte markers for
> +	 * uffd-wp, then shmem & hugetlbfs are not supported but only
> +	 * anonymous.
> +	 */
> +	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
> +		return false;
> +#endif
> +
> +	/* By default, allow any of anon|shmem|hugetlb */
> +	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
> +	    vma_is_shmem(vma);
> +}
> +
>  static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
>  				     vm_flags_t vm_flags)
>  {
> -- 
> 2.50.1
> 

