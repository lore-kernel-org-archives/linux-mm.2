Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FBACA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982116B00AB; Thu, 21 Aug 2025 11:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959D66B00AC; Thu, 21 Aug 2025 11:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8211D6B00AD; Thu, 21 Aug 2025 11:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68E3D6B00AB
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:09:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06E43835DD
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:09:31 +0000 (UTC)
X-FDA: 83801098542.06.A59AD5A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5FE671C0005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:09:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dDIPM8fW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="o/Q3RsXr";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755788967; a=rsa-sha256;
	cv=pass;
	b=H3xQJSJu8a6aZ886uwSWrPW3OxTvL0cTafuFb+r2TaA6uK2T8HDwYkmwnC+SvR3khcZyS5
	A6T2EwGEhmSBgu5idnl+mhUsMU4UZJf5UGMeEFrBGXvN7DCVcOA4RNI1r6Wn79RAvYl9MS
	jW4wLut89eq9ztdo7yslUytPPEeOqvc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dDIPM8fW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="o/Q3RsXr";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755788967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LveoKMAk45kPtR96RegE89kbNbayebfAB3L2O904MH0=;
	b=C3zXf47Mt/mftJCIW4Pp4hx3x32AzpTPeq3qd/HsoHIiG86Wj744R8ukl/MV13a+NrdVeC
	2bhoA94CkZZJSxoMxDijP+ike0MU43cIDjcqdng2Bv64JI/Jy/mFpqS24dPX9K3DbwmdMj
	h3CQvCnw2iJS1RrPfRpXGhp9+fc4GcA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LEkx11001908;
	Thu, 21 Aug 2025 15:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LveoKMAk45kPtR96Re
	gE89kbNbayebfAB3L2O904MH0=; b=dDIPM8fWTJswbRwYxmsfAev8ET/jfjLPcV
	AbkfnMh8K18MWGynCjzqFtnXz3R3Ty3OdAoyI1IRcaG20dBYtL5yw7qVjpIAgxg0
	iP/1f00l6UyMMrHILxIw4jNfJdSZJZXpU5JoNlo3EkTt5MURpM8NJ49CsCORn5+w
	QvjWtI5XBMK+IfVDEUg6zP2jrno9Y0fWgQmTiMtGVH01tCsbromaDQSQ9yS1hkEN
	MlKCq+iQs3lLtXLZJGaqUrLQ8UkSaGxOkQsn30sC7aWRaW0y3Lj2OXz3bperrw9U
	8MQvIrhad5FnZViCNWhwQob7jGF9swuiqVvptTr1lcuk2+5oCPNQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tt3r2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:03:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LEnYbC030239;
	Thu, 21 Aug 2025 15:03:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3vgc3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:03:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6GygWI5dhazKTpNT1uxAKoEKFVSsbrZMAVvCzY0T6Vlaf0qN9qA0M3S9HW9iKywu59hnv6V/DKArRlpqwC2ceFsbjm2eT3i2xf7CMFIpdmcgcxtWkvWrLp56uNl4bEradKw3zEpcs5W4idIByxHYXj9I0X066biR61S8NSzzwgNsRxrERjlydktPeRpAvTUiU7r3JDnhlw4lWznhsKAxcWjJeR9gpkIlpRW/IoTTomshiMug5MQ/nKjqwDizbS/D+WdsnuaNuKUFdFmv4OHWCAqKRWFvykyJCHpkwe+O/lxKsbxUeb9mOKnIFDYPoruv7lFV5xz4Qpq5cZsGPPzlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LveoKMAk45kPtR96RegE89kbNbayebfAB3L2O904MH0=;
 b=MA6kQZmrY5I2O0+8XjA5H/6I/Pn1pSodKG6Oh06+Cyut7WYng2E73XyLFZsBdK+g71DkZbDC0HZTvrqTgSGI8YyaU7T4t+1uaeYr1HtdK8jbCfIFl2JVAUTUGjPeACbJdFIgXo1Jj0JYHWA8D3xjCb3BhZgjr7FaLLA1COOWRGS40moSm8DeS0Av+OsnS86JWQn5U3nCrrxmKVDHTXsurHHCo1JS8QCkhfemIViS8hHCcRSvaPtQoQo4fNgGDUWG5ErYEU2mX/Jy/aQNBZhnqHQVXk+KmR7dGDR01nC4iynf7t2YXyM8oViBzpTvsVh4MnI8QQ26A7Bibjfqi5Uhvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LveoKMAk45kPtR96RegE89kbNbayebfAB3L2O904MH0=;
 b=o/Q3RsXrSmgFKMy3V6r4gMSZPiQUhrlYdKEuWThMgVriwE0yoBib25EF8KR0Jh7BQasIvCKwkMQBSMkMOeFQNJfyh3RxLIx3W7DjOFpRdrMmf2a3BBitEMfdkO8g2uB8ANyFifTQPl4bKTlvunfWuxjBCm9pqJ4/qP9eh9olCqw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5044.namprd10.prod.outlook.com (2603:10b6:208:326::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Thu, 21 Aug
 2025 15:03:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 15:03:50 +0000
Date: Thu, 21 Aug 2025 16:03:47 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v10 13/13] Documentation: mm: update the admin guide for
 mTHP collapse
Message-ID: <383886bf-b502-46c2-8703-37941caaf2a8@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819141742.626517-1-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819141742.626517-1-npache@redhat.com>
X-ClientProxiedBy: MM0P280CA0092.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: b20ae1c9-4af9-41f1-985b-08dde0c3f00e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qjFRBU9oidwqZfJxMZFlxbxEh5U7hl72WtZD2J/Ms0uFuCxDpdTLFL6nDce2?=
 =?us-ascii?Q?qyN7+QvoehuBi44imzH9B1DQWBlAvABX5Q7EhEeXyi9DHSrVQxRsYhXiJFfm?=
 =?us-ascii?Q?roynJi7RWRNpKp+Xq1oKmyY+mcYykMJ2/ZmMThSS9rqIhxZe/MG05cZ1Ahwu?=
 =?us-ascii?Q?hmbwzxpmmv9388y3sg4Zg8WKPaFcAnkHMN3j8nUXPMGatmITtrTrYkjR2lX6?=
 =?us-ascii?Q?wNrF+TNfx3geldbTOc8CfLXtVen1vG7c3q394YJcJjHEqVstm859uxo8/X/X?=
 =?us-ascii?Q?t7MqIP0lcEjTBe+2FyrCRd1JZFQTAhXMR0Od70CsZUtpVwzZhRATFG6kyipj?=
 =?us-ascii?Q?4QkRh+IdAfeZC8Rj86tMdzUPFyzT3mo7gMr0qWwQ1sQanMEHFJXZSn42wSmA?=
 =?us-ascii?Q?fYLQ3+dbdamX18LdWJ+zhovqS7C7GE4f2ffMzEgcneg9e6gKa0ZO7fbzlKR9?=
 =?us-ascii?Q?eKlh17tU3UKuNF08HlGIWcO5hhJ4kYra1zusidwF6Jtqco7bP2HgPa1AzwAU?=
 =?us-ascii?Q?zA3LskvYi0TkLevwWG4raPoNSnfdaY8Ub03TGqmzRUPs8mMzYuWgSjDexFZq?=
 =?us-ascii?Q?+HaQMxz0On7awXEEOcch9+IGFOU6YA0ZftJjaJZI1m645cgRI4J9pvBqrG4q?=
 =?us-ascii?Q?6HPp52YvCQj4riDE31IsBaKiB+ZbdVPw39fKcEBMC92F5SvXjEbn8fwSS+n0?=
 =?us-ascii?Q?+1pfaEBhvcx+whiXkzb8G3S+kJwYAZoPNAZiLI9PS01Zw3VZ0zFtgL7IgNlN?=
 =?us-ascii?Q?LSNJz1lXdkccPgExL25nlfPhIxNyyN4W4pt72c88EJ7I/tePhhnfSh1ueuDU?=
 =?us-ascii?Q?MZH7fPrSHpIIHtOkOMyKbjBxdJLTOIku8u8/ZJ11/vYo4KRKLWLHs2NAeEz8?=
 =?us-ascii?Q?Mpg88aZUjafXrlRLMoPR/8jAtWR1oAXGFw6Xzqok4mCaJWmPzVfF4J40xb/+?=
 =?us-ascii?Q?45dU1ralIAEcudB9/ox7BrKBc/fnVp1RHQWbAS1TWgkChDPkVd4mMqc4XROJ?=
 =?us-ascii?Q?r1MDiUU2WE51cUIe/rNFDZ/JkQfKm3pN9IduKOqBR4P22da4t4QkhA2jRlVH?=
 =?us-ascii?Q?z9Un86l/b/x5lgluHdmNHWm70hUL6V4ZiHWumFYkS3LNYgHPYKCq6l3nikl5?=
 =?us-ascii?Q?BGY7ok69iruCm1vxCYkgVEwLUa6X/02g6EweJk5TZ/MkVIRFChU8vDY94ZUE?=
 =?us-ascii?Q?EUIbRk/GLQ4prgRbGEdo9opI1Hw58NEEQAzff6/wFtSh12FvhCRCzb93dSZa?=
 =?us-ascii?Q?8XRULRhUCyXg8RQ4+6hjkF/DPu5Vw0rclw9s4iMTdoOnsfEFIRVxgj3Adayo?=
 =?us-ascii?Q?zCJDE2cmTEIXq7U8AHlc/0gyBXwam4bE7GGSF+9jm/vgstrhMRXjFfrKFNID?=
 =?us-ascii?Q?1d8GBEieT8CHgZl8aZyIXIdDfJ54iq3+f3IhDiMgmfE16nwh3TXhCUxm3wd8?=
 =?us-ascii?Q?suuaAJo+MLU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rSJMC9kNl+2MZer58mXTC9dV2tvnBsSRXdu7Q2GEltBxqoHIabtaVdM9fngP?=
 =?us-ascii?Q?Kss519nASuKAV/S+mhlevz9YF7yWsH68gdZ3BXuFX39XHsEJW0A/VSvADLwy?=
 =?us-ascii?Q?PMCHH7F/W15Ww5/0abq/hB8aSHXKuGWajuHlE4xc97zzDzdfMlaxHMtoFASZ?=
 =?us-ascii?Q?An8vF+dNxWq9OegUPmrZKgwIn7YZ/b9J/XyrL03LIEEeI8Y+HCROqLDNiyZu?=
 =?us-ascii?Q?oB9wkUztEEB9Hrd8nAqR4WNQS5ZovwMcDCKvxMmkWqofOgD7wp5RIitploB6?=
 =?us-ascii?Q?lLC0YqXAehZJSoPimg6+qfsXKaJZ0rcj+/yK4gvDKz699X1XVKBO94+pXt7o?=
 =?us-ascii?Q?GueIBJhVKpMGHLoI3Gnv/gXExN/x1FYiJQS1T3k8W47f+NaXg/0WPFHy392V?=
 =?us-ascii?Q?LBs9qVKaJppRTCaPZ8jX3xpNS/E5Y8svw6MFldY6tS7UbN85D+PayIjdUEx0?=
 =?us-ascii?Q?FHz3vRokjSnR1q6c5hHQtxk8vNy0uInR0BDVS/MfOquBMx6a3oRuZQaFnSQ7?=
 =?us-ascii?Q?15/5uI62apezns5WTaRvBpy3qi/oyQg7HOzZWatuh8ihfheJoqzckG1kgwPj?=
 =?us-ascii?Q?QJv9ftgg8xjuxO2KDWHWKF4JSc7mYuu/m/GiFj9d6edcJqTazZNNdSxsCAnb?=
 =?us-ascii?Q?xHtLj1t2KUOkv3P4l1EsuuvMU9kWuQxshpOZgq+sIgTX6CZmBNLtNaaUHC/G?=
 =?us-ascii?Q?cn58T6kteOxq+n5KuXI4qdwcwL9YdeF8R/j+MS6YhOQ2nqLE9lRkHzd8eQ5G?=
 =?us-ascii?Q?igWCpFasyBnlW+bAzJ1F0kgcFkTuUzlFzV3HsUAnt9URNUyU1WCJDvYMxwzA?=
 =?us-ascii?Q?zcB98w5YFvjCK0RTiHm9NG7bc/O/FEE62kLG/kjADe8jBxBahN9Y/IOrlF+L?=
 =?us-ascii?Q?g4tjRt3BS44q40v3vigThCW/w8d1DozgwSoVbVSHf5d1gPlFMZQR1I5W18VT?=
 =?us-ascii?Q?2jR6AVnPy5jAcFiTiUDVVJjGXN8VKQpu+Cqgm64uMyGGhYssABhmpj9PUCNk?=
 =?us-ascii?Q?wxxSzwMG6FIraEBWGYLZ6TJaiPcet3v6b+9kjtSjW8i1xgX16rR7By+izqp8?=
 =?us-ascii?Q?CtrOE1nyBab7ujgfCNDMhmSC3uLPTZpnF8gEsNSx4EIe+DRzmRHq3NbU+Snv?=
 =?us-ascii?Q?cxwIF6wMQULt38h7N1BqV9hGXYZxcHn5m9opKQZZ7x2mjj5LFVo0MdzY2vb4?=
 =?us-ascii?Q?llRbspJzazUtThbf8lXpAU4ExPiMqAUUDmUGa4J85ztZig2FTmGbbLMGK8Ee?=
 =?us-ascii?Q?EjvuTQSNYNBzySgzJB1rjychpkXgfQBNPN7NoNHeHPkJWH4+BUvSZyuESd/R?=
 =?us-ascii?Q?1j2hqn8wS79NP6DuHVV0lCSgYTODOBWbj/l55dFNhnrE40L/NYJr/cEbc3+S?=
 =?us-ascii?Q?kjP8znPpUy4PfiIFfR9g8+5I/1BhNT4FdepGqbQ8tjKC7brXEHDOevCfBKM5?=
 =?us-ascii?Q?L+6ecZdgqdoXBriH+eufjfENRo7IGP0ox4UOzCqLBoh+aiIRslYQgpdT6dOq?=
 =?us-ascii?Q?5P07ra78zIt+/bv8daYEIoyW9lNe+bON2lrnkJtMPGvyq6+TRQWhZCuHB3mb?=
 =?us-ascii?Q?5FFubW+6DflQo00qUjC6JXQCP7YaQp5GueSdipjYVsCnxJELFYqQFVleSjNc?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LzeZTqcc4W5L3TIhfKAVm12fzn/zlo6Omsf83ZQ78mugoyVsjCxX2MRWDL8vWDBA9oczxJ5l0s80vDrYyWC7x/UXqRe9p/UlmxBbo4H2h2JnbpxAi2JHOISnr9zaOX+hvQ/8m88YFIP4qY0GdMW6azGVpRKuTak9iJzorqMsqubsbGV5lGiOn6EOE5oEOJGsHoGxGLPc86Sp66G3MrJJVSbQRW34ViBAz4OEzR8JUAuJj9tlKRdlrbCTm22ScGCI6zDhnzrrQE981ESHV9q7aVwos3ffMguz1bu+k6/SLnyTgQDxN6ukUd5iL7dLDntksuW85K1KCLN/vmjSzK76k9pl37hS3Pj7G87lL+J1BOGRs+Tt0+26bh/Boz9HQUprIzkBWNfTc+UxA7/N5MCTk+2qn4f58t9L3PgBD+84RT/juHVouKDNzz9IF1K/E6VB5xHkY1f7L+mwTrtEyZ7BeuoYHoY69XU6lNguIgKskBxbWuoBXz7ConLTx1TzupApS/C58VnH2ebtcBkVDo2UliIYrCNu+vHApWaKqOldmi2tOcZz502Tq35sHhuyBJxEDFhr725CCkdy9J0IPL9TSUoGmK0wGu4tiwRmlkNxwUc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20ae1c9-4af9-41f1-985b-08dde0c3f00e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:03:50.8167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDIfm/My/BOASlFH/KJMbFSQKzNLUBtVu7aMjhnyEYDq618ESa6siI2jLzUZ6vvw1CtYzFsG4y2KZBbl3g1hDR7E6PVLX8RDU18KIlkJa7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5044
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508210121
X-Authority-Analysis: v=2.4 cv=YvRWh4YX c=1 sm=1 tr=0 ts=68a7355b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8
 a=ah6X3bEbKCZZ-d9mM-4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: 3kqzNtHJPcI6uKE-0YcC-NJMvE7KqhL3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NiBTYWx0ZWRfX6WIkMfNVqT/S
 DkbJfNDwvKUwuQ0oP2qIfnMPUGSLjveiszJ58HgxneoDDi2c+XR6psJlVVBOP12FPf5DKX7Mmwh
 VF4dJQ8aLH9Wu+vjIkogaMBorLjCdyRQfxvObl6myH74p3zaODkyYoJrG0UMN9UU+SnNiTS2S/X
 j6aYHFIK0dqbgHyGmMPOlnKz5430cof+LJQSZRnkda0z/Rna+75DbKr45Xx89kWKm745384xD/J
 havB13cE7RelMJHwgBr6Ac/s5HtzZsHrRrfYMrIsmae8tRLx3ykt+NFr3wr2Pi21Hs3mQ8X61UT
 z+HNa3thuoecX+HpVYd/g6pHY86GKaltq5lOQlnrELjXn1xa80vF1N9rPEI5YSE8rZBqAUv0MCb
 KMYK6kpRjKbphsdZXMrpIreHHw2nnBqM9tqt6wnsq9wcRBTaY0Y=
X-Proofpoint-ORIG-GUID: 3kqzNtHJPcI6uKE-0YcC-NJMvE7KqhL3
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FE671C0005
X-Stat-Signature: wy1u4iqtnjat11x3yn9eb4ahoke9uoge
X-HE-Tag: 1755788967-824403
X-HE-Meta: U2FsdGVkX1+ZKbb8PE+UKN6pl5Ug5eYm3p38w8KsHstbv4uwvZIVBZM6BoDj8oH9FnPUqWXaX01T8h5WRRbG+wH3jQyeGA9UTWiLk0iyYwL5qR2j2q+DjzKZ4sCWuAkwue6gXwfPKS+96ceLeSun8znuRNXukp1VlHZwgWzmI7USVvKvg/6nf/cfrK8h3ViiR/NhxXtBLTWoWhm4bklhEBv+9Jk7OXXUWcEaILaVIWdNYQF4FcnF6lNKreI6pUOqq1I9EvenNSeYyyEp2QSraey4EdmPBaZjCfX/V03oCINII121gNIaT62uddIPZFYZPVbQdFdYrnDyhS3tjsCUQHEybJjnTygy/QMWoCViaXKMx7uDDQj4p9Se1wk5CrI5uoQJE80kDeBX50xLG2oqVeZoW7nUKhm/ywLzkyv63DGVuy58X/tnaQBvEVjQaS7pdqzvnoaUz2iketIuVSkIIUcN1CRWYm6sa8Le/owcSq24Pr7lfVzTWx5LTPyGmqj+Kj/NdRSZAqIJ9k57MSNAQHfHuavrvJpUpp6NMNWcpvClfvdSfO4dkDcxR+uZB+tEn4zO+sQtDIX6Z9umO9vIfSGv7rvswWv7I96jPmddBtku8ebjnCQF5fCF0cNgPWqfuwD6YgPFicusrrBlV7XyEkiuzfV37xVbcV6tSKDFsz5UwvDDHk/X3sbZwdgV4Dy31Kroc/2Z91dqnfghC/c2iEM3k4556lnC/rVoJkKzWRuMkiesThlUQgjhFsDJ8ti69hUira6WjmtaFCUWuT3nqNWd4NPrgM9sX3zkjoZPTzfX3pxrYOv2O05gzp4RQXEP+oIqONbu9PM57u+RlyqZPKAjPSuxBsP03H9IbMnJqWq8h0Ns2Gs2SecDeLtJyCUV6YyO5zaPjtVi5ZD7L283imNFEtXmXsgDzvIRulZ3TYnG6iYWYD+gVqRVzGkxfgwyuFQxdHlzidmYSUB8eka
 dhJ8thmg
 o7mBRZrpB0xOlJC1trbshNRZX2eFkY06LSzuu5ScRHmsPM5Slb1hgsigUSM+Q6CL/U29OjObUAKIKxm/XZvLozlFrNavQOD7/hqrlIn3dShHnwpdkGjR7JnWxfqZ06SlEam6Iatdfvowu9O9QrkXorzH3wWxkPy+AlAVm1W4MA0vLtBPp0QiCU27WsdYwlmnnmMH4blL2cImWrZODRnpCt+z6HOEK4QMYbFvgK6tNUr8tpZiDII2NsYxOBWYSh2XArcQEU9ERNZ/6sIOOXsRAm5M4lQ6JwvM0qlwjKyxjnFnXiKaOQbV41Yk43VRmcD8ySsCTxDWIAk1nfBSqQV5uURD4pMGMk3Z78s2Jf1hvCSYkD8R/aol5lTdiH7YQcOfrm+HtdkS9PsE9FEYzTNp9APUMXjGGpeddeBWM+kpKTHHaCELjqyOO5AxVRA0qVMPKnt8ow5BYl15zp02N20DJOPXuxYt6tDxCdqIVCv+iJf8wd5H+fwZkB+w+lLW9xFspG4URIe1A52HkPRyaLQ8qZGD0HXLEi1ovdJ4PO88culQ90lNFXnO86Kp+OOEGx0J5hC5tZZliimy2cutfsejspuaaPX1LapPnAZlC33YBx1CmWbedFrfv96fU08LI/dz9aLdgoA6O8Z66/KiTiZub1Foo1OaoyOU853YLPhF/U7KBgInbc5ks87fKgywH8wmgTNBM++tpOxoenI6jX9J1C+Vyj2UuKWPMoAdwM3wtTbGdcQnCLi+uixuubbhB47CZjR2yRWJk2fhUfDsc1wi/ALEubWUZreuuT9zmUYlWlcLtHX7GObJqk37fxez37vweM6ge6Qyh5p6ymGA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:17:42AM -0600, Nico Pache wrote:
> Now that we can collapse to mTHPs lets update the admin guide to
> reflect these changes and provide proper guidence on how to utilize it.
>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index b85547ac4fe9..1f9e6a32052c 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -63,7 +63,7 @@ often.
>  THP can be enabled system wide or restricted to certain tasks or even
>  memory ranges inside task's address space. Unless THP is completely
>  disabled, there is ``khugepaged`` daemon that scans memory and
> -collapses sequences of basic pages into PMD-sized huge pages.
> +collapses sequences of basic pages into huge pages.

Maybe worth saying 'of either PMD size or mTHP sizes, if the system is
configured to do so.' to really spell it out.

>
>  The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
>  interface and using madvise(2) and prctl(2) system calls.
> @@ -149,6 +149,18 @@ hugepage sizes have enabled="never". If enabling multiple hugepage
>  sizes, the kernel will select the most appropriate enabled size for a
>  given allocation.
>
> +khugepaged uses max_ptes_none scaled to the order of the enabled mTHP size
> +to determine collapses. When using mTHPs it's recommended to set
> +max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (255 on 4k page
> +size). This will prevent undesired "creep" behavior that leads to

Woah wait what??

OK sorry but this is crazy - I've sent a reply to the 00/13 patch as this is
really concerning, this suggests to me that this sysctl is completely broken for
this purpose.

I think the series has to be altered to introduce an mthp-specific ratio, anwyay
let's discuss that on the 00/13 reply thread please.

> +continuously collapsing to the largest mTHP size; when we collapse, we are
> +bringing in new non-zero pages that will, on a subsequent scan, cause the
> +max_ptes_none check of the +1 order to always be satisfied. By limiting
> +this to less than half the current order, we make sure we don't cause this
> +feedback loop. max_ptes_shared and max_ptes_swap have no effect when
> +collapsing to a mTHP, and mTHP collapse will fail on shared or swapped out
> +pages.

In general, though I actually want you fundamentally change your approach so you
don't need to document this at all, this whole sentence is far too dense, it
needs paragraphs and some text around it so it's easier to read, right now it's
really quite difficult.

> +
>  It's also possible to limit defrag efforts in the VM to generate
>  anonymous hugepages in case they're not immediately free to madvise
>  regions or to never try to defrag memory and simply fallback to regular
> @@ -264,11 +276,6 @@ support the following arguments::
>  Khugepaged controls
>  -------------------
>
> -.. note::
> -   khugepaged currently only searches for opportunities to collapse to
> -   PMD-sized THP and no attempt is made to collapse to other THP
> -   sizes.
> -
>  khugepaged runs usually at low frequency so while one may not want to
>  invoke defrag algorithms synchronously during the page faults, it
>  should be worth invoking defrag at least in khugepaged. However it's
> --
> 2.50.1
>

Thanks, Lorenzo

