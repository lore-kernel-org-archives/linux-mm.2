Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237C2FD530E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8985A6B0093; Fri, 27 Feb 2026 04:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FFF6B0095; Fri, 27 Feb 2026 04:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B0F6B0096; Fri, 27 Feb 2026 04:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5524A6B0093
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:04:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C919F1B78FA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:04:01 +0000 (UTC)
X-FDA: 84489649482.11.BB06394
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6F0ECA000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:03:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mcr0LOvn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q0W6owRR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772183038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zky7bcALhtLRFXjOeOtyJaqlu3BGzLJSqqc0d8ZjrUA=;
	b=M4By+kfhddrJJa4wSZxxrPfaMOFszjwBW0uXfE1ez1sSDLokXBj4UaG3nM406Iw1LZakg2
	YSxD95sWwCykaCzwGq3cGbQZeiHk+ivsQlRUO2l5Elh5f6tWXXw/JtBX6oPlluSIQ4py3o
	he8PoNHLUNAMIsLdwaUIkWzwIUyiagk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772183038; a=rsa-sha256;
	cv=pass;
	b=hOH/Zygi098t/PH0KrCXNkCBuoMdZmjFs1tRxYxo12mTTphejkRrIXUlduoAO7EBdQsdmi
	vAGq8fnHddUyy9yNuQQ06HYr1Xf9C4spyvw6De4EPe+4FD0OO+Un6l5ljutgbzSTQGohbW
	YBD8oR/B2q+AWxdGlL5ulFZcj7JxU6Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mcr0LOvn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q0W6owRR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QJ9Lx4561377;
	Fri, 27 Feb 2026 09:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Zky7bcALhtLRFXjOeO
	tyJaqlu3BGzLJSqqc0d8ZjrUA=; b=mcr0LOvnXNF7lZ73IMgPxlU9LAeENdg7pt
	zcsgMmnFutqQ9ZVa72H01RSCicXygmf4hQqR8czxJBIDVMl0binURUqE6pRVnnQX
	4WWO4/9oTKEIHPpvMpFx6OLqbMXFHxWxq7V6xKBl00JN14D6w3PyUBY9Y+rQhS3d
	UFCaNjWzFHQhLOcjbp9AYX2ii+mJKLf/l7Mplc1/GTjjs/B5+Hxp1bfINOWoA++W
	yOSwiEOITzxY0/U8NoA61MG7qKxJaLuRCxt3FPGMQCJ+1Zi44GpF3y4eRunb3IOE
	9rsjcQuwcjd6OhV9ipwWjuqkRcA23q+YESbr7tqA/YLUbPKuwkvw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cjgjft4xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 09:03:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61R82m2Z012455;
	Fri, 27 Feb 2026 09:03:39 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35hv5ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 09:03:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KFuClJSdIUU774hs1WvDCddtMtCJsINhj+b/N7jWFjps8PFxz4HoA1kidwqRKLWskShOuuYxMU0l+zeB+0EPBgyhdYP+O3xbkUwWOTp04Nb8UqGaD6zuNq5Ix+4Eg1b+aas7KaXPK17mXGy59zFQ6zd6cXZ9SI3ay6n6ezkbR52VAsNMJyT8MBsRrLMpN1soWKY8yzz9df6diS8ojfIxf9vnZ3OQ8A3jHN+uEajw6lX7mMQb2Qc/7bFo+uS9Hs+1bAxcY7YZNqfjGQf9Qb9zaZmRPYBURIDmz5FBRWWvSI5ZrOvZLfrAu1k0TrMYlU2rLPkFtVmbMMJuLOhHa7BUuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zky7bcALhtLRFXjOeOtyJaqlu3BGzLJSqqc0d8ZjrUA=;
 b=REDB8Dkie/pHMz6d/fjVQJwApDpoysA8/YRTN1xu41d5eApAXyLxoq+JePuLx6xYRRT7Ku7u9w/+08C5Ba0+IHz5IRk30oeLhPOS6LloERMEas5mrGbEzXBJzYFyrJM/LtTbMZH0skvJPPIhbvWZivju9P3yB4AlIPIAviGKs/78/4+NcDrAfwEPJynlNVOzfbfiDSQkCbaSRzIP7LhNOYmRxcaxPEZZKkgJIcmGnM1U5LpKJM6dGE/kTSy8Qzof7EnAqe4gIa2SezKzBHrlBQ7ebjxQHn+9PV1Ei2X/VTw41SH5FQxQdKo2THofOJTeL9hEUIYKbNXH6AZ8eg4MJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zky7bcALhtLRFXjOeOtyJaqlu3BGzLJSqqc0d8ZjrUA=;
 b=Q0W6owRRZvR9QrNxm5FfHtIJALZ1+C+j7lZEHCVD+LFoDqT3TTTIILeSJGH2fyrfkb8nj4oArDDOVOigpkJSTtLvAlJLTP0dIoFdRTuSKc4kTmjC3KFKB4gf2n3VeL24AZmW4af++5U3dbbS5CFWbfT2XGdMkOlPWLL6G3kAp8Q=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8514.namprd10.prod.outlook.com (2603:10b6:208:571::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Fri, 27 Feb
 2026 09:03:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9654.015; Fri, 27 Feb 2026
 09:03:36 +0000
Date: Fri, 27 Feb 2026 18:03:23 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-mm@kvack.org,
        Dmitry Vyukov <dvyukov@google.com>, lkmm@lists.linux.dev,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Daniel Lustig <dlustig@nvidia.com>, Akira Yokosawa <akiyks@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        David Howells <dhowells@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>, Boqun Feng <boqun@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
        Andrea Parri <parri.andrea@gmail.com>,
        Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Mateusz Guzik <mjguzik@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
Message-ID: <aaFd21CMhQCB2rkU@hyeyoo>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
 <9dcd02b9-42da-455d-aa08-165e6ff0b921@rowland.harvard.edu>
 <aaByMLSAIJM8HdbO@hyeyoo>
 <yf7gon3s3efwiwpsdytujnhohnxjc3fgu7oabmia4tbhwqgcs7@rzb7sfy2wrbu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yf7gon3s3efwiwpsdytujnhohnxjc3fgu7oabmia4tbhwqgcs7@rzb7sfy2wrbu>
X-ClientProxiedBy: SEWP216CA0106.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8514:EE_
X-MS-Office365-Filtering-Correlation-Id: 090fcaad-40bd-499a-87ee-08de75df1737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	A9t04OhylAjChtWyzu7K74Imt21oZxPjcpl9PeHGqWqaAnhJ+3flA4L2zvCDLSc5szVBRMj/PM3ZKS5D6OmDJ8fQAe6a954j5VBjydK7D+OoKVZBv3CyYZ2U1pLoO+rvK9QqugsFvI2hSi4CrhRN9AvFqDPb9Jk9YiMFUAHWAC/D1qmr/t1Ynwj3SeaplVB4lBO1TeYfwdO6EiFp98W2ftG84X4qrmDxlYhAZaEx+3BrK1lt2V4BoadvRguSCrjTqEM9QzrPYgY7Dr9vNpcApvMGPTZRQrpj5zR3tdF/MkrwGoYeDlVyVoQcTFqb5yLcdO5gjNJ4hIFf2H8iZdWmHr4pm87hLa/XSTi24Y8v3qUhdsJIzItxpzAL/QjpJg4rb8VBPA1v4+X74446Os1rT57KrLnpbysb15ihGx9FnrjDFavjlZEjrpNohpE9OIAw5lIOk8pSkKCkadX/fpjjvgfNQWSfQNJWVoSzjFXiRtyra8P6TP3wJ3nKw0q6ERKCF9jpakW6zjCqEGLdLSwklxd8YymNijG4V2f3L+YsCbUgDLdFMIl3Vnqd0n1PSsq5Y9shnd/UPHKTYJegclLMK5K2vvw4pYCO4E5d3B58QpJEW9yqQc3J71sj2Dpq4GDJ1P6S0Dndo3s+sxtd4wYJqGqMku6cx4wzPwurGeew2XRWI8HidY4sWt+sfyy44l+NI+ofQ0RbdmShsY61h8Xq8o6nisaux7dyM7EVSZUEcKA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?35IftGZCmij9WrwklwmdkYef+tfnZGb8nJvVJy548iSqnv6MSDBGKKwjDHIr?=
 =?us-ascii?Q?x4n29EOyT3HMhMNB00Swzmd8eEb/Lbj4Aj4ZyJKBgQ9zrTGijRJBl0FSQ4RR?=
 =?us-ascii?Q?sf30xKkj7iWjZNmqgtZGzWitKSSpc6VCYFUSE1fkeNS1GUDAjNojV2wVC6xq?=
 =?us-ascii?Q?zr5sVtDX1rEtuuEvDj5F9uTaoFYRxFWEmJLDNJ2pOVtv+0lWAn3K7B+Wruah?=
 =?us-ascii?Q?KOY0+BbGfroTZ+UeVhn8bXw8z6djzMQoBGaXwqKbSmwguoOw4BXFNCQPjsOZ?=
 =?us-ascii?Q?yMIto5wlEscibub/VInWCmnoA5YrftMhE9QmwNZio0DPMldu5VATkWXjnzxi?=
 =?us-ascii?Q?XdnXtVpdoq+5xiH5jZk4v0eC+lWyzEvg0Wklhr8evOVNP+1NqI1Js8uY7EeR?=
 =?us-ascii?Q?OML5yMEJRkxHzg+zv/+PQSC14E2lJ8VMNql1Rn3M7jRVhFTV0QF0TmL9bl+6?=
 =?us-ascii?Q?WEfjchTnD0eye2Yh23J/VUv79RQX72aoKQ96AJnWYwyuasYVDp2nrNG+5RHm?=
 =?us-ascii?Q?Qbt+ALWgwSJasx8/m1Nimtxp+k3rcoMKYVC6Vgom9AxCLa4Z5UWoT8sGWUoK?=
 =?us-ascii?Q?kZGFLrPucC9f1yBLgKg5dTh5kavn6nUn0I5LNwGA6Do7jaM1Kng7Ozz8sIFa?=
 =?us-ascii?Q?hWNUmvYwfpFHRHZlmUZOumnxqsJsNNciofcvbFhFTykzvYL06nXaUUVYk3uk?=
 =?us-ascii?Q?FcwlBScR+AVBUYSyfwv7DfJpuFNMVXMM6fTH7zt4wF0Mazgw0i3V8hZH5tAS?=
 =?us-ascii?Q?DUR7+UnQK5yQAXjVlp2fC2QvfENX1XtTpKEsvuQX2mvt7XuZUy2max9QjMzZ?=
 =?us-ascii?Q?JP9MJbJ/NfU201VMjGMDeXimvy67Ywa3KJZt6zhW33zWEW25GTFxDcyqv5Ol?=
 =?us-ascii?Q?SEztHmVYtKJEu2mpeb9q7KvUNDmWziH1soQR748+MAtTbkkaXvaWLM+kwcSU?=
 =?us-ascii?Q?jaMONAHzT6SzYlFIuGHPuvcOf4BWFZO38NjqmmZ4r70TM2eMSJ0Udoi8hFxZ?=
 =?us-ascii?Q?OjDakhicBp5h6GEiRlV7S0HVruj8VD8mIv1BchneOBH0Br8h5+qQaeHoqRQE?=
 =?us-ascii?Q?0hHpCmkhC/iDY/KR2KrKtiujkfam5fJHKnNJJ2md6VFSOKnO9MJ+zPm4Sz0/?=
 =?us-ascii?Q?2hyOV4ys8fgYcKXcweLKMeW4EJ1uNBX4ldd6kD312nOYQxf+gxDhICklvoAL?=
 =?us-ascii?Q?XOOzTBkO1JrgyGPq85vpPNiu2/+qf2DfY4Y7M8eIyajSEDFyKyMgDdiRz/i9?=
 =?us-ascii?Q?qs1F3L91b9rT+Altj5To67zoCIBL/dlpEKQe///39VZo3LJi4rIGFZSveoAS?=
 =?us-ascii?Q?eeAMukract/NsXXDoMzzHnJiV09h5D6DMmntokWcMImn/avW5tVUb2mm+uR0?=
 =?us-ascii?Q?Uae8Hl69ob6+lIIExWjcu3EIprabpe5E7CWYMwX7Gz3PVRNd+qcS3MUHfbeV?=
 =?us-ascii?Q?f+D03DrZpAx60Pt/LFs18aLS2chBYWjpH0ivy1nM3oZISYkTqw0Oa7ZfnxxV?=
 =?us-ascii?Q?a014kmRiWKO5rUMAcCWafFr09r+c1iPSOgSXJnxbOefq6ZPMidohOW2o7tG7?=
 =?us-ascii?Q?X48dlWlpST7QMIGfz1pKIPcMA+E0yEaSLn4f5RTDYc+GM2eR/6azv+fZ5tV8?=
 =?us-ascii?Q?0I13yjK77C5QV7gSw439aJrPyneXLw+FMdLQCdj21Jv8TRKqPqkQulXeoVmF?=
 =?us-ascii?Q?U2U+qQYE7qf/iqgnNwTgHlGeIYbHtfU2vv4u0ZIjrir+rvda+/1JAfNHyLJ0?=
 =?us-ascii?Q?TMUmz9gv4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vY9jcpbUflXmlZ5Rd1V+rj0CxtXyW/OQhDRjYbQdpfA56BC/t3f6YWbw0SjWZM2JZvUzv63KoXSDPBg7mGWX/wP9eAY3xco7Mrus05d7DyC+Jza/gQ7frRs33W1ntUKSSI4qi9Bn/Cns6hrlzCqrLDY347J8UUZDwE/YGzCLFei5p9plgYzprHrLdbPUSJWT8Be/6EYMDxEo9dJCG6jDxwzJeBsQTFwnDslr0EoYIxexDA2fw3yAtmBpIJQZ6O5yWzYCTaq6gsnTJ3lfU/Amw6LPo8EE5kFB1hb/mEfjqyKgqrtcjSJEY4e7wUwqBnKUjIk4UTfYSjR9vrAJgOpysamoJHRXk+lY35QsQ1p8aGarFRUVGSNyVWsPQFLyDCLcvI1ysGGANeaW1m8ZhGIKOWTgV+ywe98RqGHM46Qr0sgOzvZlrD+qAgiRjy/nHkzyvG/V6P7Iu3e7f4xtOwFr1LQiXjnV1r+NdFIKfgI0dGlJmhGijOKZYMXEsZ3XXtgzKN6ujleAAxzchK4mVSIhlkqNPFWIxIxgPf/YvyR1b6kOJLmYWP865xKjs+XYJsIUtzIqaL/iEer4C0tpDWp58j+u/8aAU4jIz1X3qrH+x5Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090fcaad-40bd-499a-87ee-08de75df1737
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 09:03:36.2506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Brua/TcMPxFxc7NN7oAI7mNCub4mbJrE9UTeQTvF1TNwYBABT2YO9bV3Tvscsl3ewXf8MSufc9Weaw99PSLomA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8514
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_01,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602270077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDA3NyBTYWx0ZWRfX5RyFLXVnWxHu
 E/qrXtFuCJ/iBtIbDmvHB/TPuV/qtLjfBVi1wkjNUqPQMdcv5oc0x2e57Tm4Z4useEYntmCrnhS
 RhhDvZdT8GtkLz/YlEJjDwsSb6KaAlNHzgN5ejW00pn33W5vHiJlKQEd8d/oV7ovZ3AgdGh2p3G
 mEMN061L2OnJO5+pDtfC1zpKc7WastTwTD3L0aqOPJ4tSnpMTGG9vVYobwQ3JWniA4T/uI1zSnT
 vGOgX2e497zzyoCAjRErr97Bbwp6IIVi4TAb2Pqw8bJLO1xZG3YCdEWgl+byHqHCm6B/AuEk84e
 wF1b25gvY9D+tbhYRDqSIhhZQD4f4pHr7nJmR6k9Nn67epJZ1IQAEIrdFZBuZ6dq29+jAdSJgDd
 mik/hSmSZDJtNNgnZeG6WcvoGTPS7bJmFz0PavkIKOYP7HEPsFQiyoVF5KsepV+Af8LdvO9rSHq
 DMGPoVxZEnur23njvRph+nvw+35ogjjJv+mTAYRA=
X-Proofpoint-ORIG-GUID: i3TBJnYXX1_r5ouncAVJHQA0sjcNFLzg
X-Proofpoint-GUID: i3TBJnYXX1_r5ouncAVJHQA0sjcNFLzg
X-Authority-Analysis: v=2.4 cv=L/oQguT8 c=1 sm=1 tr=0 ts=69a15dec b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=LBBRoJ99xtOAT1XmIQkA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13810
X-Rspamd-Queue-Id: 6F0ECA000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kfzcj5r8w8y16oxmefkgwg69w8n15y9d
X-HE-Tag: 1772183038-571037
X-HE-Meta: U2FsdGVkX18dipKBZ4AD9kjhKe6bFJgxY8Tot3cD82Ver+jN9jWb5WZveAEHUZuhwrLgjGQRhn9zqKp50Mw8nxcfyyrt7Yz75BLk/DDGjg7pnbw7FqsVTyGoTuwJ+sTGQDN6oThdlEFxArTspRkMkZCxspaiwGwIqnCMnOZuYpNIaTzCo9FFfdjsQHtHHGdZavlLBKkbA2MUlZdR/A6ujCEP8gF9hl93dT8xRiDXWU0nj1V1A9zu2XGSi7d0KtbXK3UYxuuCibFcxHho+mB4+/9bZjQVQgLfTtqrwrHgcaJstn0StCVcM1EFAqIY1MD7q1NdvUYMwg0bQHWG8B2jsfjOycSVL3wWimsahjRoeVn23/oPJoYRTfNy7rb2Qk5OM6bfsxSKhOIpZPVc3lTYZrRcmSx7q6t+D4FG5TqrKRToTYd1hI3vAxEansImrfTZIyEebe5jWqG6SSEE5d9isN9VRT5t6uXEUWpQRnyEnTh8ZBOm415PO5I0HPNLjfuCEXXPHwolbaScYBLF6Lvxw4Dk8k+qpifMcB+osvznyD/l6pqcHA8Ss8mRzOQ4n0YExTnro9u/DxTh3iDe2TpdAeYqLO1t0WQyzR7slbW8WCVzpaECzCXkI0Tx/ZEUmjf4OrHzKAwS9vDuLEhU3jU/OSgNZCpqZnOxL3bLNt1mtCM+UJe11MOsRjdMSttSKIcRVmXxLHnFz5Clh7WJYSxGe6eoAiEWJc9Hj6gZ2GDIIaKAzLUGSQfwGSayF5eE+roFyc07Zh4wiR05aU718H7UPE/HUxF6IaqgsrK351Dpru1x4TyAyDwANZoLo4sf7jTWWBB+Z+7gz0j1n+REYYI+LDimCq/ZqdOEy3mB4I2r4WKeHAR1p0XNUjgDJR8hpRJbBd8ohfx9SPuwknSmekSjomQNtMDN8T2I0II+3YjtH8d+GcI20/fH3q4buKduHpUJvQXFLYAxNyP20p3w9eX
 Q3gReZja
 Yk3YWxRdPU9VSgvbW7K/31d2nA5RLvRlTKFxoAzUQEceaWZBP8ssL1IE9SqZ4qOxo10RQC0HYpTe/bxMKPzOn4vWAsbwvXHMeu2DPavH2Cy7yiFsp0muB6XHKCwI/6tl9CrzQS7q59bq8YTNUO15okuHcR/wvziEJ4bGbCmvd5q/cmj1kInU0uku809UPWQgeuEJrOb9fanFVc1cFidoK/+9ZsjOQv2cMuuJ9saRrmyhZLBuEGr9c3jJ+dslFk8I74UaeITc3CHPnUJy4+qi4TWPfxGKVv/3fiL+MdrNf6rpd1iNM4jq+aatdnMmMlkcJD6NFvsHAByYikVG1mqiR+J/12Pmdf5yDpK3FyOWBSxid/LbCHxNVlCLxOTVqep7cYjohUwOAdCW0p6AbuDTGAndGkKh7WoDtzh9pdCqZOAdPPg3sRpMoN6oIk9ZB1Z4yVkCfBIh/TtaOEQYFvHvxG/1zCAqYqCqFuU5d93oR4iCRJxVUAjKYxP74Kg9+XzUCo1oU4w5E72uwPQhZCpBllhCV0u+GRhm0HylI72kzqt4JUQ5AO7rIpQ8CfNUoQKDcSX3EW3nzUK9/yxz1xiJao/XhJgwgepdi21ZNq8JBUF0Qyjl0I9H3dCuVM0BoSEWNoyRw74iBChEHDlbPK/U1i8ltKhjYRuQCctCt2667VrXnNSHPZARgzhe4lw3PgITIB6Fctc+Y58hCWgHJH09uvPnPi3WZNJRFqzsRRwVMgUzoVxeSqp++8BvvXuxmE0o6vvcEFW3A/rN9s8v9fnjtxPJ/2i2OYUBfeW6ErKLiPxYCtuOws1qnyRllyyTXNqt2rXlT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 04:06:37PM +0800, Hao Li wrote:
> On Fri, Feb 27, 2026 at 01:17:52AM +0900, Harry Yoo wrote:
> > On Thu, Feb 26, 2026 at 10:45:55AM -0500, Alan Stern wrote:
> > > On Thu, Feb 26, 2026 at 03:35:08PM +0900, Harry Yoo wrote:
> > > > Hello, SLAB, LKMM, and KCSAN folks!
> > > > 
> > > > I'd like to discuss slab's assumption on users regarding memory ordering.
> > > > 
> > > > Recently, I've been investigating an interesting slab memory ordering
> > > > issue [3] [4] in v7.0-rc1, which made me think about memory ordering
> > > > for slab objects.
> > > > 
> > > > But without answering "What does slab expect users to do for correct
> > > > operation?", I kept getting puzzled, and my brain hurt too much :/
> > > > I'm writing things down to stop getting confused :)
> > > > 
> > > > Since I have never thought about this before, my reasoning could be
> > > > partially or entirely incorrect. If so, please kindly let me know.
> > > > 
> > > > # Slab's assumption: Stores to object, its metadata, or struct slab
> > > > # must be visible to the CPU that frees the object, when it is
> > > > # passed to kfree(). It's users' responsibility to guarantee that.
> > > > 
> > > > When the slab allocator allocates an object, it updates its metadata and
> > > > struct slab fields. After allocation, the user of slab updates object's
> > > > content. As long as the object is freed on the same CPU that it was
> > > > allocated, kfree() can see those stores (A CPU must be able to see
> > > > what's in its store buffer), so no problem!
> > > > 
> > > > However, when e.g.) the pointer to object is stored in a shared variable
> > > > and then freed on a different CPU, things become trickier.
> > > > 
> > > > In this case, I think it's fair for the slab allocator to assume that:
> > > > 
> > > >   1) Such stores must involve _at least_ a release barrier
> > > >      (for example, via {cmp,}xchg{,_release}, or smp_store_release())
> > > >      to ensure preceding stores are visible to other CPUs before
> > > >      the pointer store becomes visible, and
> > > > 
> > > >   2) The CPU that frees an object must invoke at least an acquire
> > > >      barrier to ensure that stores to object content / metadata, etc.,
> > > >      are visible to the freeing CPU when it calls kfree().
> > > > 
> > > > Because the slab allocator itself doesn't guarantee that such
> > > > barriers are invoked within the allocator, it relies on users to
> > > > do this when needed.
> > > 
> > > It doesn't?  Then how does the slab allocator guarantee that two 
> > > different CPUs won't try to perform allocations or deallocations from 
> > > the same slab at the same time, messing everything up?
> > 
> > Ah, alloc/free slowpaths do use cmpxchg128 or spinlock and
> > don't mess things up.
> > 
> > But fastpath allocs/frees are served from percpu array that is protected
> > by a local_lock. local_lock has a compiler barrier in it, but that's
> > not enough.
> 
> Hmm, this memory-ordering issue is indeed pretty mind-bending. I'd like to
> share a few thoughts as well. Happy to be corrected!

Yeah, it's indeed confusing :)

> For our current problem, I think the key lies in the relative ordering between
> the two variables, stride and obj_exts. To address it, we need to ensure that
> on the writer side, stride is assigned before obj_exts. And on the reader
> side, we need to guarantee that if it can observe the latest value of
> obj_exts, then it must also be able to observe the latest value of stride.

Yes, that's a somewhat expensive way to avoid the problem by enforcing
ordering between these two variables.

While obj_exts still can be set concurrently (via cmpxchg()), if we set
stride very early during slab initialization, by the time the object is
allocated or freed on another CPU - it must observe a valid stride, no?
(In a similar way we always expect slab->slab_cache to be visible
after slab initialization)

Then, the ordering between those variables doesn't really matter?

> If this understanding is correct, then even if the slab API caller inserts a
> memory barrier between alloc and free, or uses a spinlock (or any statement
> that provides an equivalent memory-barrier effect), it would only ensure that
> the writes to the pair {stride, obj_exts} as a whole happen-before the reads
> of {stride, obj_exts} as a whole. However, it still wouldn't be able to
> guarantee the ordering between the two variables: stride and obj_exts.

-- 
Cheers,
Harry / Hyeonggon

