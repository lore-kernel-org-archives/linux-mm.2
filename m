Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BB7EB26F7
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 17:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA336B008A; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5946B0089; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9463E6B008A; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 736606B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15E391C566
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:44:55 +0000 (UTC)
X-FDA: 84429272550.07.88543C3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9E33020011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:44:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cZ2pDOTF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UTyR++iy;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770745491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YunL/DP3JNTwU7ZyfCxP0kVzPDumc/PLb/tEugkkHA0=;
	b=0We1WLyZGUBpMZOtFyifADCeWD0SffKXcrmqs5A8PGwAZfSkA3CHB8dR+ry/gdpSb7tUei
	95O7/ILFDTfEu1N6HTAMiiUR5UlwfAQSO75Gb++yAjKr5rCkzGLLjLhqUEbML0R7KMnaS9
	zasQyN13fUv4Zemv88LidC9aWb4MZko=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cZ2pDOTF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UTyR++iy;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770745491; a=rsa-sha256;
	cv=pass;
	b=lyJaGeq0EVFmT/vHbntJ1zNRhIvfGVnOop+80SlKunjksLgkmnZjdQb5qt5UcqVmLxZD1b
	T2allOqfbga1MmKgxd4xf8JkHRgtLWc+GydlZ0PNbzTXri8M3RTqHWP+n3p4RolFcYy4DW
	vOCroDLyYpk9vMcD663uc0GXAY96bb0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9vnW83922791;
	Tue, 10 Feb 2026 17:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YunL/DP3JNTwU7ZyfC
	xP0kVzPDumc/PLb/tEugkkHA0=; b=cZ2pDOTFYXDVVTvXvcbDOl0fV2iul0UQ1b
	W1AtWMxbTwBLyaAoW7ms8t8fF7aQusyYDkQ29VAjZiS7sQM1jAEhRC0oICNXClvC
	pT/0060FTKM2gOG5DG7xQZyVNs4/pp6npfNdnVylNyKLALU+U3NAk2qpQYURtJQq
	RiTIuU5psgqb6QDlLYLKANHb/A770nzUu5/iekGaNYG62/CvY/8tawOV7Ixnq45R
	ZbqRTHgMY+TMannb86sHgqhyiQJCp+l/994ZLpqoYgPY+E7SHlt+1DVnV/nikwd/
	QrLSQ5Qcl+UWUoytRkGegoEZG6SH2Cz9zQKB3iK5MsY5f/EPZ/NA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7rxu1ffn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 17:44:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AGH3Z3022501;
	Tue, 10 Feb 2026 17:44:27 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c828aaj6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 17:44:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bMOYwQsX55SY/2kS3uHnpJoFV4IYgDjJ9kCLm2EuPM3GO8YdQyLNQUd7e1rY09lhD48PbEAh85CrlanU3JkzlhROIdJ08NlbWRbZaijoUADGbLznDrs+wNDK40N2fodplU0+c8TU/wyoNeE7Tq8BDgCyq/qKFkJrzkifDkmDsoRd4UcTQ+GfMbYdEtOieo/dsylUPq+HL8rxYIKdgk5uGrO59dw1OOegtduPRgzbcu2am6rl1yA5gVU5DQQInnbdO3KrbhZMNL4R6VRyg2KhN6mNqMm4cYNYITNByg2EVQ54OWLEFL612lYsg6dqiWCAYlHGDf906FPhCDXceBm0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YunL/DP3JNTwU7ZyfCxP0kVzPDumc/PLb/tEugkkHA0=;
 b=A4r6LiJtTZONraXkq8wA21jlmWCkwxFjakYqbSNlMwAhaNJCYWFkv11/1Dl2yx4KPC7crURY6EIsT6r9np5MTyCxTyJYqXbiUqtmOwA0XgyL0DnVpFWIx1UHxE17jQ0GjpULhoap5CKnRJ1oOQtQBNVsM7W/NFALYKOrhgqNchKkrw/rtE9gRumxrDnae4JRusHs1c8zNCJchTPSyKVUvqQH765CazawbP38xnRJ7YSSfId7XRlHxdiLwSsXAlbRczquufOYa3lGwiCPUsn5GmDXhAk2QqKf3mVJb6W0DTGbC15Sr+zHObPnq8e+Eb/dyaMeTCnyG0/6LvEojiBOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YunL/DP3JNTwU7ZyfCxP0kVzPDumc/PLb/tEugkkHA0=;
 b=UTyR++iyVVfD+1Qzta0bwebRaqvF7+VdTT6aTKG0iQs2bAjU24zzvm8z1eMbWwxEWjihV+MGRERe4VssdZYr3h2OX1Zvu40NvJQ8kdDwc0xGlSH+J+YLsRMd5sqMp4SSV8M7VA8r5V5WNHl9d4xtcHUUC+5da8i+s+7apMuEmDk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS4PPFE2271E76C.namprd10.prod.outlook.com (2603:10b6:f:fc00::d51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 17:44:21 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 17:44:21 +0000
Date: Tue, 10 Feb 2026 17:44:17 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 01/12] rust: xarray: minor formatting fixes
Message-ID: <tkaaldguch3ozw7orexzs6wmbf67v4ljqj4h2wxkhk2vd2byqk@7tmht2rqynwq>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-1-f777c65b8ae2@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-1-f777c65b8ae2@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0470.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS4PPFE2271E76C:EE_
X-MS-Office365-Filtering-Correlation-Id: 6691075d-0dfd-42b1-997b-08de68cc05af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u9zh/WYD34q6ruatZ6WU+bInFS8bKi+Df4UB/tPA4n93m+7uZfLdCeNZrKQG?=
 =?us-ascii?Q?umYdZkLaNpzRvJsbjJa0OYRX5DFvlCNuHui8NCPGf8YXFKlLd3nk0NsKB/O8?=
 =?us-ascii?Q?Gj/lYVFy+hznWmUbYKVLnJMXU3Kmp+NcaIw5uzuf0OX6W7bJ+fqhg7zn3G+G?=
 =?us-ascii?Q?s8lHfH3NitK5MBy6kil47fd47ml5sIdrLtyLgueRk8HKVb7Ge5TIksS0Xwhn?=
 =?us-ascii?Q?5SQZpcN2y8CcKb642pIMASRvXZnjz06aIY9rrBqwoCCRJVX1mEflX+xG7lNa?=
 =?us-ascii?Q?OuO+E20uwWLnkurlMbiLqtdTaNJle10jFmWWvEqlGLfvZUi5RgtvUkCjoTTu?=
 =?us-ascii?Q?cPzySbhH3s1Xjd2O4aXiS57LtGVBr5XAr72AQd0q+PAEBZob9HKP10E6Um2O?=
 =?us-ascii?Q?37U5+HrCE65EDUkfRznkgYYjdB2IrP6GORiZMz0Gbk6TkOily88vxFBtsl13?=
 =?us-ascii?Q?7QoLfeb8DeeG/6qlesFaITFx27m8dWyB0/wemOyya8qrhHqADokTbnQ8XJ/P?=
 =?us-ascii?Q?lOhlRwPapF6/PRdS2Hw/AodsmjigGvApU8/7UUM1fAeV0v4SkGjq7mSh/+WQ?=
 =?us-ascii?Q?TCySjZNwj6DbB9+1x0PC/LseRarDsbxebjid8hTuKirOOZ+uVcvpkbCIDZuj?=
 =?us-ascii?Q?Y9OCSTZX+NGMdUN00viedjTS9NHRlCsSbFwlUFzVMiVzRWdxRkkSZs7oMZDr?=
 =?us-ascii?Q?bobG/SIPWk81EIA/WMpHr1R0CyvyO6crlDi+VXairhQ2a7rC03Q7dobz2eXJ?=
 =?us-ascii?Q?bWM0taCeVsGSUbHdbz81LGFkLiIc6zCmU8svFn6augkiK31JWG+rhxqO5Tiq?=
 =?us-ascii?Q?A757PDPcxz2Q/y1zmPEg+MtksTkYOxtVbMIBF1XViMTaHM40XxkAZrSHHTWE?=
 =?us-ascii?Q?Q1Vbc3GzIgKuUKmM+c5Z0I2Dbvr5QL45h4cBu49c+SnGRbLQAOV9pWT5aJFw?=
 =?us-ascii?Q?pHsjvQmFjEretGOqoY0hWbB3gKEJ2qFJQNDuejMTzstlH0PCzwVZLKJdMrIp?=
 =?us-ascii?Q?2DJfnF8jUFAThRq9mjh8rDfuTp+5/7mTNda6NWlmNjdut8TPtn4cJ2Bl/S9/?=
 =?us-ascii?Q?ydas3Al27QnbEmQuVUCUAS3MskiTvQpkuM0WQb6Ktlw3E2L1/70DNG6wsXMw?=
 =?us-ascii?Q?isPX4vfVG0J83w+RSnbmsXkaoIzw0wAoP5OPninpI0vFM01Y+HnUSpaJTYN+?=
 =?us-ascii?Q?f/+h69pdZx5ablHHZF/k4MYx+lJMz9TuUz/sUHzsf2zh7SiIJwxJemWukvu1?=
 =?us-ascii?Q?WonK2AL5UYJfOxYlFMdfAWGlTl30DAptoEMZ8JUD2AHAaqZE7dDWdUdVCeCy?=
 =?us-ascii?Q?FG2P65YT5iUJnLXjdZ4T2L7Q8U9LDUn2Mimym2DV7xEo+pQMPTcVaqZ5aybh?=
 =?us-ascii?Q?d08FE3t7WF4vDwHj9T2/lwIwsGr2Omc5Tlxq73/9bcTYSpLwW+hIhTqZ4gFf?=
 =?us-ascii?Q?FpKruxZTzDT/RCE6stoNueqcD6LY4ujhYOnfUlLkc4RecSRMLOH6MZu5y2BX?=
 =?us-ascii?Q?WvE3hZGDS8T3wSG59A/1VcNdfyzALvNHI+c+M05LDSe8vUofCanPKbzhprOv?=
 =?us-ascii?Q?PARXCdlDh2NqgfkNviE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ooTRxIm+dxeAF7i4AcrfhUSMxeyKtYbhGFFjHNz7euG8OYV9J3IQa+pX0NQy?=
 =?us-ascii?Q?G+TZPCrTDub/sXmZr/Isw2TmMeh+207Q26u6qh/2rHiyxaBpSs0e7oLxJPJE?=
 =?us-ascii?Q?nqbAfidGDkAk/H341YEsEQubmWRGH4bIcE7ddJTyRQxMmWjPca/0YP+E6pWi?=
 =?us-ascii?Q?EB8AJo/ekyuje3Dcg7le+diLoGIgv8xVPIzr6ucCTM5SXKZmcFrS59+GaoAK?=
 =?us-ascii?Q?QlQFXRKK+IOVmTagWMetGB8gquo0V1rc/xh2PjmfPXnc00kQqKXj1uk/qka+?=
 =?us-ascii?Q?m+2yIeyqUemBhGApZ6Lm0ol9IhOveXCi1mWqDPVXZ94gyP/5wS5WpPX48L1i?=
 =?us-ascii?Q?/ynIhup+EBu2o8wph+RDWOgT9tz+15H/0hbPlUXi+RPTbOWzHE1OnlF6/B3V?=
 =?us-ascii?Q?7h5B1x/NxpzDCYKScg/Ow3azPYYNPqSp+tj/rjAWqtft6mz1h7FZ/K2FRG2U?=
 =?us-ascii?Q?iQuqefWPqWmwyXfMrUVHTQCbXcXnoSIUdnYPJt7d5716uGJZwRqcDjasbZ4F?=
 =?us-ascii?Q?MRAhIVGqIp1H2Ms882k1dch3LqW+k3MCugCMcOYbgBr9S5n46H6r9Mhjp200?=
 =?us-ascii?Q?4iNfA9xA/uBg0CoJU5iyYumPmw4NDNbKBmwQKLsaoMieNkbfjoD5CU1nCuot?=
 =?us-ascii?Q?NHyDRiC01BMIKPsMqzv5g/JnKtAUPigm4E1z6HDySw6cJ/kaKAOWdl2VrmqO?=
 =?us-ascii?Q?Wz8pMR+m52J7uBs0hzfIyxwwdyWnbuuiR5ZF5nEI6QvauGCAvPDa3mAr4SLL?=
 =?us-ascii?Q?p/Ez8pPneu9trPtpUQPUP+VosrQCSThSjAxz+TqNqhKdub7Sms0qoxblR7/u?=
 =?us-ascii?Q?Gj68m+Tu70VrO/YQNA9gU7y4BNs8ssKbBugVgYmERnrhdncrQ9M+2yIaiuZ/?=
 =?us-ascii?Q?+qNsFCOvRjj0OPHFXiovV3tIal6xQZFeT3au7gIo0QPS6PhEm0/q4JwMbQR6?=
 =?us-ascii?Q?xOJInk1PXTyb699h79tefXOJE9NAZYOoVSSn++8AR0us4TaxFavciLsx/VAf?=
 =?us-ascii?Q?J3wrWQfPd7m5ak9RkH3I7c0hXbCAkSPHeXahIZlaTnpsW1f/DFdz1QWDlgpA?=
 =?us-ascii?Q?xOICDadnd1BFSpOIl08SzccaPgClL+m8mMw/Gr4q2uW9V4wBg0Wx5D0tG37T?=
 =?us-ascii?Q?OcSQwFbBjZUBXYKBLc0YQ1RfrPh3uWBxMhn7eZJ11m5veOvtVz+8vgkp/s1y?=
 =?us-ascii?Q?2S/fkXqgX8EqJ9TFbH1uIEAfYHUpQ5vwG+ZAG5JvvyVZV9rb98oh4Uz7oJH+?=
 =?us-ascii?Q?gGe14gIrAfp+48aCFDteBt4YDVcsm3aAPX3bDoZDoHQa4Ipy5GziYfJL62rX?=
 =?us-ascii?Q?z6BprUUCUjDkGHgLiYYJMpHFsAEhW2cg25QfekVK2YEOWyBCyixR7drUPIsk?=
 =?us-ascii?Q?L9Dq9DNmIZhiFXFjT6uGw1DyyU4PMzh94CF8IQWvZYDdbhvDCq4nfL2Mmllm?=
 =?us-ascii?Q?SzLlfwj9Y42PLXYMkT32Mdw64+Op871pQdSs2L7V/TMAFboeactxky9e3ckh?=
 =?us-ascii?Q?nLkJCmk7r6jZKIgpZrxViu9tgEc93YYXhFklSBs2datMRu35u9Zxcic2dt9p?=
 =?us-ascii?Q?0fJ2MxJ8TXjZQiegzcp/vw2ceCjGkpNbeBYvuJ91p1IcySbLwdpERXSCSzEe?=
 =?us-ascii?Q?uYBadRf+9U0j+WHDXPldfUoQQjeKIYbF8JMcBP9y2s4hm+xcCGNNiilir4EA?=
 =?us-ascii?Q?yARbGa7MIpABrOJIUDQUkd6UdTexlrt9TFqVm9Ki5dR4Guilzqu7pvLsIOe3?=
 =?us-ascii?Q?uqFyr/gI/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r5wGb+5qdHaTyMHH5WUkLtFrTLA27BJ852fADeJbjNjZblRskJGO71vKAk0PQyqUptDVLwyHcaa0xdttApRCU+wj7j4nkh90PHyTPgMc4vA6B8lVh3XJ79/ZQ2Z+4SrwQylZ+XWp2q2EzEYoakUYogUUxv+tarmUMbzRZbVBiadEWPotH/NZJGYlE1hY5go+bo9chraCrmlC7WDcnPTlTvTPjQjHIh692Sw5LRrdY1aBGdji3FSAE0bEYAU4tWIKfEEp79M3U61PByoE+L3veR+SEUDGQK/YxspEYXCHVzVZGKWjV4F3YamMVGWigkVj6LtKMHtsNDHoWeb/tzp7r+VkjmLWU9Mf0esRD1XwRL+f8fDH94czkV4b3SY79JknixKbvaVJyb3xKIgI5BwDAvkd5agM9pNO6gZWth99LiNixfieoFWgQl7x9OWde/8j7qTCEQQdIY0b8VyUfyyR77M1QtjKekyrsJv1j7pH9UMXUG+M7+H9wM6R0/z94vlDFgNBhlAmvBlGa2aWFx6k5ahbD57A8Z61kUlVKxkjEYz0MajRx2qG6e/8qEvcTP0TvWGKuAGUiLJ/mofobZQ6dcr7yYMBtFUx3+A+EUgfvDQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6691075d-0dfd-42b1-997b-08de68cc05af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 17:44:21.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7MLgz+Lz4d+VJyItTLREosmTWkTI9sZuD8XarMexfTyl91LWLOAhkO7xBPwW33GfR4TVycJo4xHtO2oQf7rpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFE2271E76C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_02,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100148
X-Proofpoint-GUID: WWhjKLyqBUDIoaT9rMu84Kc4uUVSY220
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE0OCBTYWx0ZWRfX23Spwk8KJThL
 L5t5G5mbBUMb5WyRr6tDWdkEQmCZEkB10VJXmdYObMl5CMTp1etK0dyyUIaYY4TO7I3spvlWm7A
 I41UK+Yhw13I1hYG77sj56E0PYG907YFf3FN4NOBQ1GiVdrcsz23Zr061vbGYZF3tezlFJiIm3m
 aMeJXjdASCRxpDC03HCax1Oj5POLIgExSxtolXngmBbVbsaYhuGa20b0WQh+4A+GcTj0VJ/HZuW
 A+BasFhuuZ1xp/FhAydPqqAv8YCJG6WGGBB2H45CnIXcIWAmN98UHgJt0KWf/iHSvgK4uDkXCGi
 Pka+rnPkaaBH84t9N/deB/Z+DQd3R84QMO0meOSLCsjwVa4FgNFNt2Iyn5rZgSwk7bBlivqFOa3
 TfL+UhSKHwcyDkWCOWqUAKsDjZsADDrgmt6JIxSBxbMBRtN7ADlE2jFiPHPU2JduvYmzeKEWyQI
 W8I8e/8KoGxmYVbJunx9QBmGh5RdLmApPXlYMjw4=
X-Proofpoint-ORIG-GUID: WWhjKLyqBUDIoaT9rMu84Kc4uUVSY220
X-Authority-Analysis: v=2.4 cv=Y6f1cxeN c=1 sm=1 tr=0 ts=698b6e7b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=_2yia0w1AAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Wy0-uDvsgaaMNhTY1pMA:9
 a=CjuIK1q_8ugA:10 a=4yAS8WwzZ1jAEY03B-5r:22 cc=ntf awl=host:12149
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E33020011
X-Stat-Signature: xq1fg5qiwpjuxiwbsnjkrgxurt8oktkn
X-Rspam-User: 
X-HE-Tag: 1770745491-373578
X-HE-Meta: U2FsdGVkX19pvOwvaM/wZBQlkScTMkoWNOc4rSHLt7SsYNXgSzRYlsUgbbn5hgH0Who5jCkzMO9Flt0Fm/XcPc+Ik6iBaTCkYelb+JnVSOdryYTE/JRaSRW3nCGhfl9IM1FbjAHnSYHdzdWCcydMW7ylmMYUmaurGwOY04/DHWBFu+Kl5u0kU7yAM2CAlpqcvuMRNmj/q7CdbH4ilFZ9QJGls+Fs7keiLpKOGr2Ph7RUlXvPBVJgc8nl5oL0+J05H/oqGooDJU66gLfAAF7THPwVIOILx0ck7OzJsBM5bKKGtNQrEnTwWUbkIA/0CLUmASxq6yJz5Y6nzq6guKuJlHeHoXkQm47Lo+/6EL34RlHJAw/Ta+3BOsTu2dxukRvgS1+f1aIHEo8/1bLx6O/yoKnvIh1WnhCZqlkvnSEjkUeOTGXNN7ExNP01425A4A2xGJf4VsVBEDmujrCYTvMbm/x38+Lpk4idkY83wCPiuZmcdbY1X4/zGpd6jnil5rJbjeDhA2NcNnBXhDcoaT5KnoKcvGK4EQTa6aLb4dM82KD3jo4JNfNwQz0mLi+8R0D9jkbqPXt4W2C2yAkKBwKV6YP6E9WfV6XzLxLuxlInlWlJzUuWKBHDtlreJ8AcdgdtUFOhfBfMIFKPYS0nWvULtHh7KrwyDwznbkoRVjeNwRSXq0iT5Rl3Ub4XTGJQAXIJ1867LCDZWRGg3Qpqx0j54I4KL2hH6+K/yNGGrChh6jsxzbL1fOajaCUek5rW8pDUtWkalbeY24ocL4zpdKE5WTeTx6fGRi8X9qXuMG/WfrJ+4i4XqzdNQudZVT7dacCkI+0ZLeT97pDUkNyHrn592iYAn/m6nVv+RjJPUUYbHDS8bnV+jI1hW6guKIzpCnQD33DHcYuGPx+E4Zy9k4PZq8Wp0ccRuaaquQaW4bW1uD3rn0V/EmRjjsnNGAvYxDRDnHbnfgtYW7wDYErcIev
 igHs2AIj
 1cE8H1o4jL7nVBqnsKfzG38GisCKiKUlmkvNW4fKggIqal5mkhTbJ8ZOw/8v01D7Ym2X7TTln1wNU9V7cyHq85Y7GRE1aLI5ZQ844YKDpLB0ZYyZ9EMEsysZyJjZvQQP4q2ElejAyDEVzjOU+wybzC59NZExIhv8dGJeaOUFKDPpUqQMF4LbSj+8KeAjyZkD3OVUAH9/Jcog7PPgsNev8tRnz09fw6vAhqr7Ax918UDhoXlfUqkUJcreyFEQR4xAWcR1QTF0HeJPBuyVWfojI9blZtpPWF9KO5gvRTNMFl7hgusUpEmuPDCuuT9DlRKpIRQfiva6Q7CKA95/211fsbGzffUM5NghgvXIqEZSFB8DsGDO8mujHGErtwpKJjrIrpkeUPb1bTSUbwchMJcCCO1rak4VnjMIdRRLgTBwElnKYJ0Gec9sDyFsBqJC4srozuaDwcok1fR7fnLxoVAvdeaIBKxZLovqQnd0v/8MqMM/MQXbw968iCbbJY+iKMFMkYZQtmMY9WJ1bvmcVFX4HN3BybFZf/TIX8k/KjnxKWcjysbVjcPsQ+H+j7xq3uWQTJJIHJ/MoCtBD5Ac+ZKhTda3X1va4RRfLStKZz62Q1oNx9NlBAvUD6nVwWSKq06zMpVYHI/vjQvWmsCoRkjOC3obzf9f1hZe2lAheaELlGCFKyvi+m4Gu8rCpuOu1b+aWtOWF1KyDyRax5bXYj278QM3KIV6jOSDgCflItZNhBWxln6s12WubZ6Ar/TnnENMh+pGrHXSkF2yDKVgh4sS11FD9qVXYDRnXxu7eodaRLrgsi1MftLlNdhldD4EVR8lkc3PPs+tTA+iP9zQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andreas Hindborg <a.hindborg@kernel.org> [260209 14:39]:
> Fix formatting in xarray module to comply with kernel coding
> guidelines:
> 
> - Update use clauses to use vertical layout with each import on its
>   own line.
> - Add trailing empty comments to preserve formatting and prevent
>   rustfmt from collapsing imports.
> - Break long assert_eq! statement in documentation across multiple
>   lines for better readability.
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Reviewed-by: Tamir Duberstein <tamird@gmail.com>
> Acked-by: Tamir Duberstein <tamird@gmail.com>

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/xarray.rs | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index a49d6db288458..88625c9abf4ef 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -4,14 +4,33 @@
>  //!
>  //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
>  
> -use crate::{
> -    alloc, bindings, build_assert,
> -    error::{Error, Result},
> +use core::{
> +    iter,
> +    marker::PhantomData,
> +    pin::Pin,
> +    ptr::NonNull, //
> +};
> +use kernel::{
> +    alloc,
> +    bindings,
> +    build_assert, //
> +    error::{
> +        Error,
> +        Result, //
> +    },
>      ffi::c_void,
> -    types::{ForeignOwnable, NotThreadSafe, Opaque},
> +    types::{
> +        ForeignOwnable,
> +        NotThreadSafe,
> +        Opaque, //
> +    },
> +};
> +use pin_init::{
> +    pin_data,
> +    pin_init,
> +    pinned_drop,
> +    PinInit, //
>  };
> -use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
> -use pin_init::{pin_data, pin_init, pinned_drop, PinInit};
>  
>  /// An array which efficiently maps sparse integer indices to owned objects.
>  ///
> @@ -44,7 +63,10 @@
>  /// *guard.get_mut(0).unwrap() = 0xffff;
>  /// assert_eq!(guard.get(0).copied(), Some(0xffff));
>  ///
> -/// assert_eq!(guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(), Some(0xffff));
> +/// assert_eq!(
> +///     guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(),
> +///     Some(0xffff)
> +/// );
>  /// assert_eq!(guard.get(0).copied(), Some(0xbeef));
>  ///
>  /// guard.remove(0);
> 
> -- 
> 2.51.2
> 
> 

