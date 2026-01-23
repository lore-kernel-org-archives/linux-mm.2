Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A29AD6CFD5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6226B03E2; Fri, 23 Jan 2026 01:24:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB246B03E4; Fri, 23 Jan 2026 01:24:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211506B03E5; Fri, 23 Jan 2026 01:24:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1084E6B03E2
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:24:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E09481A0300
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:39 +0000 (UTC)
X-FDA: 84362239878.26.377A7E1
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4FB6E120002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oD+iJ09P;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.33 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149477; a=rsa-sha256;
	cv=pass;
	b=rZBKlXj+x+gKRrl3y39xiPv+YBJz0l8WvRA9LknNn3uFAPNMPnariSI7NZmBMDb5oaWFlY
	jGefRfrgJsLMJw7t33ma+itsppn6qhyEc/TxTi9WQLBsOHiXD8WXFSGLBw9hIYlp3VJIIs
	A2BeEIE4P7VOR87TK8jbpwIszrgC9Qk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oD+iJ09P;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.33 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNpDZ6J/oyytDGcMeQugmLlfiij7RSr9gPcUpy+Y4Ts=;
	b=owrvgrHRa2E1ipuoXWbote44KbrCIQbx8bTezBWq/FAl9VnR2yQ2+FQ2sEMmL99S2IhJAA
	pnvKGy/hCWZHv/qyJzqFTaE5aBDEkurlVhy3rYMKVhFIieBEqYNB2uenBeQqgKC94jN5Zn
	ev5sorxoe2FCjJGsEh558hHPjwOS2Uo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vjjlx8iXjDqGA27sdF4MuuVOLOcIyibXgZjDK0m64hXgTYJtp/0yF0c2ySXLDoKAxtRFK0qTG/OuAMhG2MeDbRBMzdRLTMl6Ujo2AVXfYddWR3yPoRoNwE/o852GVC22+ykjqf38eHkFc42dEZWSAOrdc6NV+Sq8KkECossIh68SK4UyQLm8qSoxE5zLiTWshGHcRSYfMSdc10YFMABHUHNwn44xKQSdt6YUzBk9L6+0g9mCfEl3tCuSi4TsUDAlk0/62Opli7+9spiSi4qQTVZ3h4KBmveY9CjHu/w1ci8WHrVj7ILHzhFoCCzv1TAWaqpRPoFlj4OVUCM3OixOKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNpDZ6J/oyytDGcMeQugmLlfiij7RSr9gPcUpy+Y4Ts=;
 b=g0aIMfRHMpCenaaiZDKdERGWD6c3J/inuJjitTDaAURmBUxFWm3yGLY7rXZ2qp6KT8pb2lAmsD4Q6bkvwqqEcUxIW6p7Fd+ESlUiGEuoi+qy/JA5CjvdNt68RXC+sKL7iT+sLqc/AeBlb61PsSrqIcypKfTtT0M/HgpXzNPztEb7l/VSJ3Zdni+7KtAxE9uG47VIiN6dPhlwSl6N0NwLEjSxuKGVH9QVvlpGfKaNDk0Gmjt5tb8G8OovVkIyjC9N7p74OoI3mCHGY5VU9yuHmm0XlnvAF5B1wxZshoS63dQPVAr3MqL84AkM72wXla3r2cLVnl24cRyFLQxN/HjbyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNpDZ6J/oyytDGcMeQugmLlfiij7RSr9gPcUpy+Y4Ts=;
 b=oD+iJ09PhL4Qincn4ZXeOCTZ9LU7xMbReaF0nKKNSozarbubchxrrVmvi3PB6sXpVmha042eeoHDdNPGrheDQpOzhYamiyUbdiNLkEDxntumlnPiRhFHKBfFXR8vik+Qnf24CdBWj4CbLxiAHJRAHIIB3lwPwHdtDf5I8ztaFEY+/7yVJeucnWZFne8Hoy4PpoZnxv/GfbRegTWTzHFjcIwRocxrLcG40MWK1TtFoHO7KfnsgKxrw1NJJJTSwDPK1yqvMdy992LDxFf15W5i7JlKUF4UgSAe62W1VWRuejRP+hx/8D4qwpoDrIV0mec1+o7dva+mgtxeXP2fFD2YnA==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 06:24:26 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:24:26 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH v3 10/13] mm: Add helpers to create device private entries from struct pages
Date: Fri, 23 Jan 2026 17:23:06 +1100
Message-Id: <20260123062309.23090-11-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:a03:334::12) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f57d908-315d-4853-ef9d-08de5a480e85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CUFUCPGi7Gho/2hMDQgrisqIXNP2qKPcywmXQ9juXeM3nztL50X5lxjTuIGF?=
 =?us-ascii?Q?rugKiEO1WGylHBAOTK7Rz0KfQNzhlskkPjRpvBNP5wUbTKKmHl2g+0E7OvZJ?=
 =?us-ascii?Q?TGfXl4dJ7gll3myt6uTYZKBQV1hQ7Yyn6TP8rdYorlZAuPIbhTpshLyGvrRv?=
 =?us-ascii?Q?2/uAUAr6hVe7y9JYRAGvhw/BHAMYKbyNEkWT8aAAYj9sGMkVdA8/lFnwVBUR?=
 =?us-ascii?Q?qN75GRdTzlVwm/C+Pm3+2ll4BucqyIS6J2uZc/rrl8Mr85+++YAyQonka2CK?=
 =?us-ascii?Q?YJKY525y+XEZ/zxqwYjxCOWPih0elcGgIcy1mu/2Cbj4EdO2fqU6AOmkDFm9?=
 =?us-ascii?Q?DbibvU8irehdMo4gYoS+noUBNZyMvybXgX6aFVxUTBQlNV1xO0u2V10LYKLh?=
 =?us-ascii?Q?2CsZmiIXeTrMJC4Evgl1OhR4XInp75LcSLCBPGHM/NS8G2ZRjrCGgtj9WVnv?=
 =?us-ascii?Q?XhV6q8GQXxehVl7K5j9h9wtLw7fNWTVPb6ve1/ZwLbqpu/Hkd7gKJ0p9+TB7?=
 =?us-ascii?Q?OsD4SjZhwS5U/KH/biMDhaFntnVHMJP9YGpSabfRqouChZSBYlz9H/7oCYZH?=
 =?us-ascii?Q?UMeP+8EOiXTuNeDZ1MwgRkwUCDYr1MWZ2gQLKG2qnCC/gTkWrP7/F6g3crzq?=
 =?us-ascii?Q?fhPVceOpIsbKY4aa0XH4goTVz7V50DbTv9Q18y+fD0ZxSP8ANIn4jjVGsXEY?=
 =?us-ascii?Q?IfdRGyUVViYmhX4tccgnacExnHRuHUjKfSyNMa81y1hFlt4uaQQ8BkpIIFyN?=
 =?us-ascii?Q?viRIbfrRizuLWtDAOBKELQ2/1xKPimIHwzhVV0/eEU1lDDTVozFxJuofJ0kQ?=
 =?us-ascii?Q?ZEypGX0/60XqRO9Ue/Q9nz9bM82tQDRDzmkmcK/k/ybvVE70wa10qJyaDqJP?=
 =?us-ascii?Q?YQJbqWPwjy9lzlWVhXMD6O3fFnsSvEC+dbEP0oKhE9luq4cJNkCzxYPPf3qa?=
 =?us-ascii?Q?q9UDa4WwocBUJbpYzQ5fgHhtcvQdjDTcIoydrRw/xun61ycXx+iCsyP7YCQa?=
 =?us-ascii?Q?ML+N0+OdiH6b0urLnLaBmtaBPpmH8k9HCxwBtSmGgKPHEJrg79O36RzFax+G?=
 =?us-ascii?Q?sx5+Eof3GiDQienKxE8AvrfeQLPw5zLiizPB89Jury6S3hBsWayJ92Ru2iKv?=
 =?us-ascii?Q?EvfRwp4UPq6wATErIim1WsP4AQKCUALJppm/5uUyXKQWNGLHVfJEZDOjMEFS?=
 =?us-ascii?Q?dX1iK8288ULNjRA869Xjb4bvzYqGJd62ez1NNT2PIV4ZRR2UJi0mQ7x5E+zs?=
 =?us-ascii?Q?IT9eFhqwWheR13sniBKxFAzG89uuP62UozVeDySi32Pc/fsFTogtpcC9Y3jQ?=
 =?us-ascii?Q?aRL1B+XTUCIQRfcDSMSohDv0EDnRY7mZcyJrChlcet7Sqh7+1W4x6rVA9fb2?=
 =?us-ascii?Q?5RYg0ZYE1WsU0mDS4tJnoDCwNlb5F6ie/Pwj0rCIgkWNOfPjUP76vC+3n7Ee?=
 =?us-ascii?Q?E9UjamNxjBkq2udSVBJgIRH8kOSgKkCs1Tx7dHH2CsQRJboHn3aAzV78ibCs?=
 =?us-ascii?Q?W22ov9Maj49cc8Gdz4CKiGuTlh6iifz116b61aaTvUxdhgJbrUiMXZfgesah?=
 =?us-ascii?Q?HCzR3UuwO6L07BGnipY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1KmBAJpwOQTHmepy/Ta+wqCqAJHhq0OxOLwvGWo3wYDJJrSCb7RZemXYwqo9?=
 =?us-ascii?Q?pRCchFGB0k4F3Ed/KZ1sRUfXP5qDLmfInP9LWwxem8EJfwmwYIkV2qSZbMlI?=
 =?us-ascii?Q?G3FEQf11TsfAYKqgXnB523Xd2w7bs9PNlcTf3D5shfqziHDMMRHi6uovs70n?=
 =?us-ascii?Q?+siIY0pMkiDaMq++wSww7IyBYqK50Mf5Nd+D3Qs2EwstnzrYb/ltUBwvtsAp?=
 =?us-ascii?Q?7vHJlSROwtF5Ove2oXDwYSs7iEufmJNnZ7Zpyqp4BUcah7vJp4LcXWCDm0hM?=
 =?us-ascii?Q?AwGqZjPv+xmF6I3zIwyez2Pao1p9lQdDWMtNo+pAwNOQ2Wd6z7I16PFe9n1o?=
 =?us-ascii?Q?NALMcr5bNY49N4ovGD2G98jKjQ6+bDG+ks2RFs+MAf2GgirONd1qM+b24QTD?=
 =?us-ascii?Q?6+D1BtntVQC9U5/y/PAezQW9zu0xJcmGdprox6dTcLpIkhzbfNzlb69qwaAu?=
 =?us-ascii?Q?cTLhUd2iMX38qQNZontmIhhvmdSBgsghoBcL0yhWsW9Q/auYtsrvag8Odq13?=
 =?us-ascii?Q?4MK8mAAZWw0lvVfu1hNcxfHtHhIE4N465cfJonQ7eLVJFQPT8hc1xhINBprR?=
 =?us-ascii?Q?q1Ds0KPe9iH3sa+BD8m1txUWBi2rBrFMxjVH2u8py8sWxahGYPhyK/Y8UwiO?=
 =?us-ascii?Q?wnw+NA8+4/CYkmNXMvS28UE8AJLXwzvMVkLNA4Tvm3XK3LJrPmRKYowchmvj?=
 =?us-ascii?Q?Qu5QoM96eOlz+fuDtGIUF8DwDaq6J96fpGceq01mfZQUyWWLyLxeh+2OEUOY?=
 =?us-ascii?Q?ZfSuMGZAWQZt7NAUqZrokirO/mZt3ZvR6a/oSRbfBKh4iFhOaJFgmMmMylJl?=
 =?us-ascii?Q?RvlkMaceB+Pe8IO2frEqVZBqFeOzEpMGBA/0QhGJ3ibzvu532dNOSGyu3Xaj?=
 =?us-ascii?Q?zpfZLV4o/I8saeXVXOCEQ91zlwhUd4X8CHxiFzfp3T9xir5kfLP1ZQ3IwmuP?=
 =?us-ascii?Q?Aadf5uVAMi/a7pDS8mu23MYVfDM3luAQCuvogGe5Dx87Xi4ADXUCmmJcq7CF?=
 =?us-ascii?Q?W0K+1e2Eq7fNPAyISHuBlvuDabf+XNXMlswfxwj29mp33W+L+7c/wYQAsHhY?=
 =?us-ascii?Q?y6HV9WSYbSt2E1Zm/RpI5Cw7wGw9+waUxu9IHi0f3+gU/xuV8ziZIbOexUJ0?=
 =?us-ascii?Q?9XMSjm7xKAHw+ytUT5bYCZ53c8g31Ib8lXgZOPaGB2JmX6rRjvfuDHyyMWiM?=
 =?us-ascii?Q?nCxFeBJy5Q8r/iJrGmn31CWS21WzgFtRvZoSnK/JSzMiG+s4Z8qfCGVh7Yjo?=
 =?us-ascii?Q?vOBxqcbrW2pJ4w51o+Okk4T9zw0jFJ2zVWyXISgz8yI6UAGzhyNvK82f/9RL?=
 =?us-ascii?Q?sttWJeyYgQxAfy/1YRTvDma9l8GzZB5zJR9Clso1Y+Iesfu+2sgpqrsMHnct?=
 =?us-ascii?Q?WzeugZwp2iEfXlQ+AY6c6uUCKb3fGi8jQ+s8ZSdB1xGxCjLriejcHTTr0Bft?=
 =?us-ascii?Q?XhTIrgz9zH94WNEM4KU42/gOGsQavVSL3aW9DoJqPeSRxzorlYXSbKfr2i8G?=
 =?us-ascii?Q?I/Eh8Ehpawc+1mLSfCcfCRiDsXL+COq/2u4+QEGQVXS+TkElNzCa0XjhwZFg?=
 =?us-ascii?Q?DvQtgxsik+CyjDowshS+QnORt+nPMc+fRwgscFSFRxZjfQ/QKtnaq/ERxeN9?=
 =?us-ascii?Q?Myf7GE9ucevkzsjLLlJ2WT4K1NyrJWuuKoausp5ZWtgoYPLtIiwitl4nrt7T?=
 =?us-ascii?Q?g9knqCR5q4DVSfI0G7WCKdEUVDWzu571o5HLuvScK1VRGhkGwrMNHekPRZeA?=
 =?us-ascii?Q?5jiabQR+BA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f57d908-315d-4853-ef9d-08de5a480e85
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:24:26.6223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g//YKzO6Q3+5jnVyMNtzsci3X4xegcZU5jdd26Sfd7pJRY3y8iReYZCrS0nSSB189VtxAXGeczIL28ivRCVMZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4FB6E120002
X-Stat-Signature: 5afute3ege9neejdkkjgtor37ep8b4za
X-HE-Tag: 1769149477-874393
X-HE-Meta: U2FsdGVkX1+qUGgy4KuTbBjnNN8EIS2ZgMHNIxLIJzMFvcBnIAFZm2Rq7+PLAYu5Uq91HoLjKqDbL/e6RhY8ZrBWGNLX1J80A03dchmilPIlNlsDN2Wnd4LxF10ts5zr9QKXZeHSZJKsbbgNhwWUuFR2O11E124PB3K/hKGqz6oclAnH9kJuV+Umzxp2GStOFAxTOGe1CJpOXTLixnpZ6kwNCH38npC9/5RpTS7l4RrJwyFmG4EZN4Mtl3kdto3q/pSI3Hf+mL6J06cYFdq2CjIKA6r0MhzA/rY+5W4nhwBLULS/qO7EXKuzERorr5u1V2OaJ1KHutwtq3PUZS/7Mx8GySIviBTiRk9pwpqwrGwUij1mE35sj24VEp661tmcmgoU1PCezBSqJsQ7DwmoUNuVvq3wttLB5V+A7MExo7Pn9VkMNvtIqNcERUUVaJyt7kM1U9sPP4LWElEtSc+UzP59j6zFUK+psiIy643S7IOSjocDT/8d4e0RBVPk3YOZjlp/7V8B2GuU4UtzKVXExxwid9gM3itOgbL/D7lTBaNuPNJh3HbbL3tk3aq8Ul3rWM18qNGNPneI0kxbmdVujgPk18bMxtHkfyKuGr8uXzGw4MGqxERn+OtrUupcETk9bnz8zAai0nGZ48NMbqagXjuuZAXBatw1hliQ/4UfTUvtk5OhF1K62uVs49dIT8zaifNNeAr7ybeW7iwlYi6oH5oanPF7Sii8iPYMnxq5UnoP9iwTRERmNukfKiqJTxQD2BLyCtgZ8ku6MZhFyWZjIr4JjbEZf9OUN6ltlgNJtUj6KD0F3EZhzZ7bqO6SSwD/lq8lLaG+M5Y2/NysJmbmsn825UseMladvkEhxhdssx2dbV/OmLixU/WSocUFzgfsV/ysCdqPkKfYPnQ01UUGO6zxkqgpLIr9ATGbLB3ew8aalAnu87ZAQ3igUQ52y4oEcEGVO0na7sSS8r0eMJA
 4ejCZAFd
 ZwCvv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a new device private entry for a given struct page, that page
is first converted to its pfn, before passing the pfn to
make_writable_device_private_entry() (and friends).

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new set of helpers:

- make_readable_device_private_entry_from_page()
- make_writable_device_private_entry_from_page()

These helpers take a struct page as parameter instead of a pfn. This
will allow more flexibility for handling the swap offset field
differently for device private pages.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v1:
  - New to series
v2:
  - Add flag param
v3:
  - No change
---
 include/linux/swapops.h | 24 ++++++++++++++++++++++++
 mm/huge_memory.c        | 14 ++++++--------
 mm/migrate.c            |  6 ++----
 mm/migrate_device.c     | 12 ++++--------
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 2591ed914d22..b42c105e60c4 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -138,11 +138,23 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(SWP_DEVICE_READ, offset);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(SWP_DEVICE_READ, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_WRITE, offset);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(SWP_DEVICE_WRITE, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_EXCLUSIVE, offset);
@@ -169,11 +181,23 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e3a448cdb34d..03f1f13bb24c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3219,11 +3219,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			 * is false.
 			 */
 			if (write)
-				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_writable_device_private_entry_from_page(
+							page + i, 0);
 			else
-				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_device_private_entry_from_page(
+							page + i, 0);
 			/*
 			 * Young and dirty bits are not progated via swp_entry
 			 */
@@ -4950,11 +4950,9 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		swp_entry_t entry;
 
 		if (pmd_write(pmde))
-			entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_writable_device_private_entry_from_page(new, 0);
 		else
-			entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_readable_device_private_entry_from_page(new, 0);
 		pmde = swp_entry_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..6cc6c989ab6b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -399,11 +399,9 @@ static bool remove_migration_pte(struct folio *folio,
 
 		if (unlikely(is_device_private_page(new))) {
 			if (pte_write(pte))
-				entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_writable_device_private_entry_from_page(new, 0);
 			else
-				entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_readable_device_private_entry_from_page(new, 0);
 			pte = softleaf_to_pte(entry);
 			if (pte_swp_soft_dirty(old_pte))
 				pte = pte_swp_mksoft_dirty(pte);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c876526ac6a3..0ca6f78df0e2 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -836,11 +836,9 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page, 0);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page, 0);
 		entry = swp_entry_to_pmd(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
@@ -1033,11 +1031,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page, 0);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page, 0);
 		entry = swp_entry_to_pte(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
-- 
2.34.1


