Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B8CCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 01:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3CB8E0008; Wed,  3 Sep 2025 21:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA42D8E0001; Wed,  3 Sep 2025 21:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BF88E0008; Wed,  3 Sep 2025 21:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 858B18E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:39:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED4F38695F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:39:01 +0000 (UTC)
X-FDA: 83849859282.27.6A16952
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77DCA180003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:38:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pl8ztPDT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pHxbfc6y;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756949938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4uejmPsJeFlMc2yTN74U6R+lMTfqhu9bR3pRGrokHw=;
	b=Ao63XCr3F+yn8uzKXuFrx2HR9Ig5OsNhzu4O7COCHBNYdhgy66Yk2b+VhayJK0hJ1hiyaq
	WRSvGk1jZ8Wo/Ge2e4KBMITC2myOFXqdVGVJ5SpQgc46AGMUxqFH4nSQv+8/WtMULu82mD
	kBtQ2PHuCkkuj027BcJBS5r23szO2vQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pl8ztPDT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pHxbfc6y;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756949938; a=rsa-sha256;
	cv=pass;
	b=UFvL3X9b2IUGVNH+k9/os08onPFtM7wWtYYA6m2wrihSM5J9jdNr6HXNkFicMIFBD1S+Gc
	hGEm4jc5xRMekil/mgbi2+epP5SXKIx//cPU1E3cDz4zsTtHGlNrwaGnF6MuZIPcNQ2r8N
	iS6Jxrby9o4S//RUm2MuSskI+N7rIpw=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5840uMML018024;
	Thu, 4 Sep 2025 01:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=w4uejmPsJeFlMc2yTN
	74U6R+lMTfqhu9bR3pRGrokHw=; b=pl8ztPDT4O99RIJo9p3meyECXq4nN3Fgpx
	ZIkBxUzVTScvBFmf/iJO5DeEoSwRVvtL8Qa5vlA74+Lfbfbb/NIA8Mj/W6MjDK/w
	VwUAxQ8IRuMJpSsc5S8NVCyHn2sjOQmskpTAQ+D0/ziqnPMY1eCHWQ6iw4K5pZLH
	x6oRP67YJpqU5mSRvTbXD640q/ud2MD/1+9q49kmC9dMhjNGTEF3iOqIKxwTKIwO
	/AGsW4M32qT67pkD+AvRSlkwNRfEa/c/h8WNqwj797aUHtwSPRWmY6t+dDQnSvUA
	53C+d5ZndHaiog3Jj6Go3Jek9oQ0YNj4G2vsOPbgMidDGwgJsDcg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y06w02qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 01:38:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583NVmZu036112;
	Thu, 4 Sep 2025 01:38:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqraywqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 01:38:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/fRnOz/ZtzEJjOhhpNOvlvySHcG847oEfIdc+0BWdom9n5Pu18FrBEkFIcRSBUO00PTfLI7DL2zpnwRrQ/ZQxcVmWj5NOfaQ4mkP9uas+hP/xebi/LA7RqQKraqMhFIMT4sZRAnrSMAXnhLkvNRl9507CYaLpWYHoxDxej8gqzY/9sPqJb60qL8a/UiGJP2XwWwVCUBvrXcqx35akyPsWS3PRmnzjKY2u81OX7Z3CWPVZ5GYSnCMEsqB6z9IaYS/+odvUfIcSgdx3pRfDswRPMZMNZnTFueE0XuNw0rCLmHEqxePegC+uG9hcZjHc2OA9uikwvn3qDD4JGluP2SBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4uejmPsJeFlMc2yTN74U6R+lMTfqhu9bR3pRGrokHw=;
 b=nIupJxgE0frt0+k4svQXCIeDh2/HtZZCsT3RPjdBsyJtWaxZuk6GwMz/0Qm5Ou5QE0kg9DSnJ5Z1H+geDqP6EwAl94OU3K0pwdg2QLaHKR0JTz6owRJ+b/H5OlHSR17HnSWeqr+IRxVbu3R8yGXDXJiqQM+QY5or3FlPBWPfY73ppdUCPATqBZ5IGkGM13bvcSWi/S5GvTWMM7B5CwMzLnNYHR8KZpQ/SCKyD2oEpYrK2BbitEeudWSqnRoPdd5TjlkDqA3sK0N/WWy1b7dA+oCJGXcz4R7bkn9I+YzoJeFgwvplVuvuLf8aB+InOO2C947nAz2AVB7cV3j0QFZ2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4uejmPsJeFlMc2yTN74U6R+lMTfqhu9bR3pRGrokHw=;
 b=pHxbfc6yi2fUKY7HU50UXcsLtUvGte4g1bYkXC+ZHV8QI1zg0ZJaf+0V90yriDGSXeu6f6vNPcxA3vf3mJMxDVrz/aB6x3t9NehJ74opISyKXhaAGipTmQsybUzRE4irmo4WVxYV9SeZi3Z4N+kOsE0nn77qaUMJ+EMRZPlRbEM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6489.namprd10.prod.outlook.com (2603:10b6:930:5f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 4 Sep
 2025 01:38:45 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.015; Thu, 4 Sep 2025
 01:38:45 +0000
Date: Thu, 4 Sep 2025 10:38:34 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v7 01/21] locking/local_lock: Expose dep_map in
 local_trylock_t.
Message-ID: <aLjtmm70QBr2rdoS@hyeyoo>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-1-71c114cdefef@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903-slub-percpu-caches-v7-1-71c114cdefef@suse.cz>
X-ClientProxiedBy: SE2P216CA0007.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 1018bb7c-5151-4034-b741-08ddeb53c911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MYfRwdSPpirE5tvz0bTtMgd47e0Db/R6x6jbnX74q7vukwLc1hUX4gGkt3PA?=
 =?us-ascii?Q?y3WcPbaSfHHPKjBqlTU9fe4+dYB8fWl+47I21FrTWGeeBHw/J+WSBFA/c9IM?=
 =?us-ascii?Q?Ciiy/itF9QdPiGo/6ub0JOl+ALbB+myTA6GYlWbEx2VTucBNZXIuGvOoaJ+V?=
 =?us-ascii?Q?ecdpvmZ9qE6UlkUWnzwRogi140W2Dp7pncihgrEIVGTEtRgRSUcxDWp6QLPa?=
 =?us-ascii?Q?f+9b3XSU9LBfKeqe4YZzY+M+I1a9CAMS1b5PhYJDYdNvMl9gSM4i3zwHmSlf?=
 =?us-ascii?Q?FH1pCSB+JDvCVgoNNpB+tyQzRWL+rEQtq4qtIRvi/qD0CsiS3b48xOhnpVLl?=
 =?us-ascii?Q?hRikyRhp2GQ0NejtQsP636skLCozQg1z3LxpxWv4gX5Fr0jT8cImtDhiLpfJ?=
 =?us-ascii?Q?KjwRqOhilot2AXQTLcUozEdMgdSUGQlXRW0e75xC6uVnQS9TVuMmSlwBycmz?=
 =?us-ascii?Q?a3y3UNYElDsjCdRJ/Ajm7nnLSxhHkN+1nhUM6QKStvoZe+VzCfaqFBQ92kr+?=
 =?us-ascii?Q?8bho/FvKUndcbc8cYjkR59Yx9NRqybEeN0uZXxacOpu6+qJzyTkHfmRrQMr7?=
 =?us-ascii?Q?odYGay98jVa0xf0OJKUvHZ1Z+nj+bMs26o86ua1C97jpDtuCWkTfMA6r3UEz?=
 =?us-ascii?Q?u9L5Ws//br/fGMNCkdFdaeDlcSWGcDc9P6U2LuHMMMqnZHCRsSfyvMRQfx4U?=
 =?us-ascii?Q?tkGHDzr1n7T/myN4SzoW+zoQMawUQI+4hCYbkcysMTTVqZ0v30jyZaZrn6nz?=
 =?us-ascii?Q?UkZAkzT/QkaqR8bEhr5+mVHsob0fc5VD4C/s3jgBTBxNAAHm5LX4DH3Z7kNY?=
 =?us-ascii?Q?TtCFRaRaK98Ty7rvC1/GLESYhxWO8pMQJ85IpC2kId5xUtig+W38q165+Y79?=
 =?us-ascii?Q?GgwmIkFTR4j1EIdiUrDra6f5yPHRJE7hxyrYHwhi+U42zZO03CEBYt+WoDZM?=
 =?us-ascii?Q?pbmNK18TZJfcRlqvg2DtdN2fEYF7oVsESWy+/NXlqjM1EWaj52BR5r6JbzM3?=
 =?us-ascii?Q?TJjMFRzcmq3sZUwdOQD0Ed5Y/txs3816V1jU7qp9gKi0tZEig6Ag2sDW1XDb?=
 =?us-ascii?Q?c+CODMDO0duR5cf7jAWH70ZYehF916Qd13sjRPC4FCBTYAbkZT2f/Ywet32p?=
 =?us-ascii?Q?ikQk4s20Y6WRvq5W8+twh+/hR8A/JNXxlV0/XX0XbZzi0yry5lmMsbGEjXtO?=
 =?us-ascii?Q?2F/CCGjrTWI7JxP9d+TyiQwGyg/f1kwZlUozMbwHmRc+ZJcCCeRWke0fGw95?=
 =?us-ascii?Q?gMk+KPATcJWE+wGrEeRnJa62TUM000d5b+CbdIc+jpLA3rs8JHMPifk7Tc/I?=
 =?us-ascii?Q?ZDRQgAMbUfV8H4/19Cwb8wo8QNYaYHZYMAYVQp3YzZuq+GQtQkrFNxf8RoWI?=
 =?us-ascii?Q?hCgtKtCt8PZvewRceSkZJRTKYqFMsyBaP5hcHYzhUkgbdt9liUVa2sr7xAFY?=
 =?us-ascii?Q?6lzKpeMaB3c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xWU/3iby6USMtawnsQAkutVVGA9v8go9qDslw507/Z2FyEItnBeIXjERLlt5?=
 =?us-ascii?Q?mV2BRPYvSl7iUZuZCHzErWLvtTo0wI5SYMXMir/fAWpZeoiFgxV2jPWRVdzq?=
 =?us-ascii?Q?feq9SJbmMVdOdAds+G4lXb4+kFm6kyqjePgRLFePlqJMlhehkIKCM4p8t6uj?=
 =?us-ascii?Q?VbMuWmSNGNFnfLT2FpAykr2GpjsjYIV8f1tTchZOED3rR4UdnU2u8LqujD7c?=
 =?us-ascii?Q?emQI+MaQIcB6IQX3qsxrXlx5ST+SIRFEgtrzhV4uNf78+hQwucJhzVhAurXQ?=
 =?us-ascii?Q?8HWHSJZ879zcxmQTeZ4n78uTJ7aZoqdqvSBrTqWwLBYU1570gSeFY+I6m8fW?=
 =?us-ascii?Q?Zi2HayCOEkPoUOLH35i0blYWBUUaz3TcSd0mwq8qHhfio2fodTbJ1ROyZ74A?=
 =?us-ascii?Q?CxAAPTJdNZQzKjY0I/K9d+WD4LwaubLshD21QhluIDnRXphBEjOP3XH0S3e4?=
 =?us-ascii?Q?Pcq0C+DZjW0KKzAgsqiDQveb74kkas3dttMow9OzsIThRatF+5+BVG1UK0K5?=
 =?us-ascii?Q?VSIjkYa0H4h7YAQYtbs6MiZjG19na33m9JL2mJ/psGQa27+8UClle+oY7IWl?=
 =?us-ascii?Q?ttt89ntL6ODnNHo9NbtqRcG2SWHyruoebMy1QuRu8xCCSDD2FEvtq0OChLKR?=
 =?us-ascii?Q?06PX2OXpKe9iDtfqDhXIoMBSYvPx1dxvrggyQQZmburz1pRGUzJFRWiBrWsP?=
 =?us-ascii?Q?ejwXxY4lCA5vLTTr9BpfIhBkacMRHzvjmjTtoJWjm2fp70pa5U3K5G6Btbws?=
 =?us-ascii?Q?BCudcSskoIdQ6v+qAmSmBYFsEhYWIz2MB67AdPADM2QvtcVMVWqZYFJxd/T6?=
 =?us-ascii?Q?iPLsVe0ymMUpdePRmAHXjYD+HEwBN7wD0/gYEhNzctDo0fsH2Z6xSCBB+RZB?=
 =?us-ascii?Q?ItZI0vRx2wMW0k1beca8ZEGbDsZXLgfNive4W85fTKbkBu8kLBtgnjrPAZfa?=
 =?us-ascii?Q?aQ7WDyCirAjWBzXxnCwDArxSztM4I95uHBfdbsBRnox53wNU3FK0VebM4dgg?=
 =?us-ascii?Q?YgRqCzOrqa+Yz1gB64R4xW1f47vNEcpHBrOI2+MfNyRpOEsJui3qMcxUl/aU?=
 =?us-ascii?Q?t63jv3hNThOjXHoAHn9Pq4bQ7tS9zRvG/mcK7AWUcX5quKRS1EuwEPL1IQFT?=
 =?us-ascii?Q?fTbWqjrsHty1TTu16mnmvjIPBQnSRo7CVDyNqv3o67/6kD/+iA9j/kQbOweS?=
 =?us-ascii?Q?ia5r/kzfcnBN9jCtkrULDj6p7DO6v30tDwGCo1JOGNxuRgD3Lkly/h/LTnYX?=
 =?us-ascii?Q?xdY24v+7azRet0ZmtoT5TcwmoKSLzloRy5ewFpHKz67X/1cXcSDjstezetZ3?=
 =?us-ascii?Q?oUGwUCXUcPlY/mfjZna0tJvF08WutNNCiuXzHjeS5gbtEGp6Q4IvGqdcRN5b?=
 =?us-ascii?Q?eZqSzEq1TMt5wH68eI/L5iGPTy+AzAQVZkHjUGr2r3hzsMUYnRE9M9BpxD47?=
 =?us-ascii?Q?4OPhEZhjnm1o/5a8lRKnGpbijfX5Zqk75c6XHTT3I8NYlhT3AIESud29brus?=
 =?us-ascii?Q?uV7Z0uabPffIp+AGcgFINUmhY8pdhrsS1n/ZjAZ+t/1gk6d274lcfz6wrs80?=
 =?us-ascii?Q?+wZwjs9QuJjg7u5dIzDTHKVuNrvKjTishGXn7L1S?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VPKkKmV9UIX/wrT4642meCqjXLb9hdQerZEbcDu4zbi5lJ2OKYqFbMo+pvidE6U6rGKuTswU+Il2qWMZfaOJ71vfEhJXC6shKGYUrYYedgwjbAQ7mCrxqV3+0A4qdQ8lqWTzVSW4PQGKFCCzEcLEVDWQQo5jvYf5vvqWLhYgXU1M6CyiC1GztzDO/Rb89uz8eUaNUuAFxnlsKgeZCiFw/dC4GBd/aaM0gLJhwiEZ1NBv1565qfW2kue1XxY6SWlIk2gJeP/BAwJDIaOsu1mWRc3vNzsKnaMDWJIw7Bq+Rouy/Y6VWhKySiR+y60wOejYqa2kI1/SY26FB29B6xCGMtJce/hI9nYRtzS7RtCjhx6JEZGmrz74OXvSPsFTwflR6mBcAdyB/bUlFC5RqhuT0ZmhC+UsCCeODrAk6JZZJ/NKJZbhaBl6aF46lDI7RtKBG9I9qrA4AMKT1ajMBTiMvm/qI2SlDBnrFGLiBRA/JcsnBkSWtjvzVsMnw1Ng1CpSyZS9Ey6pBsx0prtC9ECAjoSHHp8JUVKW7HyDGvcVoUUg0vNFoMGn4OVo39gfw5OfAzhWIXRtPiAW2/bAH9n4Za/77rQuecuE/6lIjUSfcLk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1018bb7c-5151-4034-b741-08ddeb53c911
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 01:38:44.7771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpugaDK09tuffo4t/PFF4dw05IWWvdwPTjRXzMS2PEltUlnD+mt3VvlxYn2jzzG5VKHESJWyE7HcEtE58mrOTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040016
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDAwMiBTYWx0ZWRfXx+l/H/R6fopY
 WRdxB87Lxjfjqi/OUYPIwTT3uYBGg4BUnNte/sd6gFO5SuMYdBZCLK5sjW63LaGqOeLCxW0jEn0
 oPyhA81PbPj2DcMzI7ZuQxJxrKdvM+WtE9aEOQYyC9sbfHCQlQfWMyq0IfgmTJl6K2FVU54X+JQ
 6ImEJkh2i9RHe8e3gCDjVZgfTgq+mZwFwFuOiG6BoqdeV3qH/JWnWQAt+RY2bsagzV5ZipWaXa/
 U2zYrnOLgP89h5eClgQeCqXazlqq/REvbQkYfaKBrSG/aNMWD+6khgvHaYTLuvrlyBvnvEB5AS2
 zKJ7HDrCyDfnNlOsQzEAIgyQcid9Uxm6aJOvk3JXxMxAUkT9KZdBsM6EJxvTp9MbHCBdjwBGDJP
 veDTb9xe
X-Proofpoint-GUID: X3xbA2m6Cj9WIeLf9ZxFy3nXewCw-Ibp
X-Proofpoint-ORIG-GUID: X3xbA2m6Cj9WIeLf9ZxFy3nXewCw-Ibp
X-Authority-Analysis: v=2.4 cv=A6RsP7WG c=1 sm=1 tr=0 ts=68b8edab b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=t8FGUepNg4ASZa2tAxQA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: ywgwp9u9ppttdu14mzc1dte7y5h3hfkh
X-Rspam-User: 
X-Rspamd-Queue-Id: 77DCA180003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756949938-537848
X-HE-Meta: U2FsdGVkX187rWf5KHkDNCWYDgEgd6LVPxmunuUjQ0fs6jSJJppBToo1JCI04Wmnqvg1nZ+NJvc2dAGq7Q5LFdQbYvREr13edX2kXVTJjfZiZZKelpu9HX6eqLw4vXSEM7f3IzG3XK2bODgAMdPAAcP7A1VUWNPtMwYc5HCRk4ypMc4NU9mONIE1gviv6UnbCY4GqHqX8SFbfnhvOsBw09JoNapPCiVBCyXSB0O4pCt3wEnItIKNqJa+ZO0w6AwcwQUWifVRaXiQxjT5nXba9IbEAvfAzx/0+QQIef9iuiokynOc1K/AjG9kOv6YCC92yu/H5zJf79eqnCEcaY63dr6a2lHXbrhunhE2oSNZj8U14OL/3SLLSh5AD4yZ3h3ZCy8VCkOv7czbL/QfB8aq7ye/1YGsAat/LCpyDweXpvUnGmySAN+okFXoLC5S5mVLSX6yhkKdXIoGyXufIlUHw2ByrCSP17pNPo5VCitAAp5olBZ67L8hvCypjw4AjPouYPUTYmp/pcaw0QkWWoYJTRDrgfq4Zbr2cGkf1BwNjlsLHOcNPevI3iqsVokwD7gDofqIk8WnScHBM4KnHUqwr6kB27ImoL1aAPNuy7dq3GBLyx1hRqYtotKAwPv4ye9yJ+lHEgVKshD8fbglrF27EN8vFgvixRfkPKCLUnQ3SvngaTkPAB9odi58hEYIOnmFKZvqnJKC+zkvuOA8s6XfmyvwRrn5vPwA0kI/cI5M1AyzRXtTvsya+0sNS8ZS0xMV1ithP/Dw03RnDN6qLxdeJCgj6ZeQ2DmwX5AQUB7ymOxQhNmVUCvsjHCuUYZ1QENdQD4x6bdi9H1WRwsIEHWSLBzkjJP4BxrcI/8FFLwRMnNntFTJq82VRX9maRK2mJPlQ3uhTK9Nu2IAE5oUCrrjrhEMpP4HPzHbBbS66yjxLzKSQT9mtyB/d/W29PMwW12g77aGjU7NI9VSLclXruN
 YhNprw8X
 suxxyYVsSa9QRt1KzMfOK4V1VrEHw5L4ec1mHIEf4uUco8by3Pr/8aqazKl5p8rEP0wvd7Gj2vL0/VXnfaVwCN1nj8JS8zOctTwK6XThTj6iHZrH0U3LalXB78NEI9FIRD80FOqRWJK5xuRg2qg3QnXkJaR0VlCXutbuvJOlo8GpC6u15aWXoO07XfaekrZWuNGK/t3LllMeqIeuBUlYLjTlV9EztYg5RMGnkpQAhMIs0q7Vv6BMq2j67dvSIOHjlp9dV7sktBY4bA9Sa5kaP7myxSuZ6+zTZw+4bjBySulTSEuU/qc7L9Mt+EvXEzZGnafxIp2xGEfIeRfxNFoeWh7SUG0LValZV+FGqFsxV5Uo0V4/TVdThhhPVhHYqXL2mWMr+1fi+yl0hHD62rSI/R+iIA+OpiOGOB10uEeUInJQMygCFfLPSrO62Xm6B+WaAmA3clfIBXUX5UbdDnrjRojio+aHSOeOpkWF4agbQgiY0GdnqlW6z+nxWfx39ppD2jUvdYmR0gaKGRrgFvzuN/JQbEE387DQ4IEK/51VfDRGUulEMmnkpOYJXemn3e3WbGwmM2OpjQCaqD7WuxBeufRLV7/pAKLUlIxTZ3TTIopPruwfvK0REzrZv3LeSdToTYnXDIhWSBfmyVmTTQC0fd/MSre9eyLFXGZZTmCOTI0YV7QcLqAGBKke2snWZr7Zdws3YJxZECUmGfVM/H9Lgeda0wrNqUMZAxxMoB0y/Sf68sFceiPfLpdni7w0qJMztZQjOosLydcPmPEbrKvdexOJS3ieOxUYonxnut42326GxUekeWDuMObc3QE2QGSeYjehUCRgEbK7rz9aGrBWbHR9ji7VZzs6SUPeGlMkhs4wFLluqq91JBJyGuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 02:59:43PM +0200, Vlastimil Babka wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> lockdep_is_held() macro assumes that "struct lockdep_map dep_map;"
> is a top level field of any lock that participates in LOCKDEP.
> Make it so for local_trylock_t.
> 
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  include/linux/local_lock_internal.h | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
> index d80b5306a2c0ccf95a3405b6b947b5f1f9a3bd38..949de37700dbc10feafc06d0b52382cf2e00c694 100644
> --- a/include/linux/local_lock_internal.h
> +++ b/include/linux/local_lock_internal.h
> @@ -17,7 +17,10 @@ typedef struct {
>  
>  /* local_trylock() and local_trylock_irqsave() only work with local_trylock_t */
>  typedef struct {
> -	local_lock_t	llock;
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	struct lockdep_map	dep_map;
> +	struct task_struct	*owner;
> +#endif
>  	u8		acquired;
>  } local_trylock_t;
>  
> @@ -31,7 +34,7 @@ typedef struct {
>  	.owner = NULL,
>  
>  # define LOCAL_TRYLOCK_DEBUG_INIT(lockname)		\
> -	.llock = { LOCAL_LOCK_DEBUG_INIT((lockname).llock) },
> +	LOCAL_LOCK_DEBUG_INIT(lockname)
>  
>  static inline void local_lock_acquire(local_lock_t *l)
>  {
> @@ -81,7 +84,7 @@ do {								\
>  	local_lock_debug_init(lock);				\
>  } while (0)
>  
> -#define __local_trylock_init(lock) __local_lock_init(lock.llock)
> +#define __local_trylock_init(lock) __local_lock_init((local_lock_t *)lock)
>  
>  #define __spinlock_nested_bh_init(lock)				\
>  do {								\
> 
> -- 
> 2.51.0
> 

-- 
Cheers,
Harry / Hyeonggon

