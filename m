Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC5B10F6FBF
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD7B6B0088; Wed,  1 Apr 2026 11:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEA16B008A; Wed,  1 Apr 2026 11:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6764D6B0093; Wed,  1 Apr 2026 11:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5444C6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:35:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5DE28C7BD
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:35:51 +0000 (UTC)
X-FDA: 84610387302.07.9358C6A
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011035.outbound.protection.outlook.com [40.93.194.35])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E01CA0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:35:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oWI39OY2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.194.35 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775057748; a=rsa-sha256;
	cv=pass;
	b=h8RQonN6QkaJGzSHMaU0xuL1GRHeXJwnD4AT8fKz54HiMK9Koxzm34p5FsKHcag+sLhsYY
	jvNoIPd67Dyycx+LGXZQSuSBovUTbXZ3JITZ4jSR1iTYFliXhSAP02FPwXyIPx7gGWeopQ
	tckKejoOo1Ke3xwM1rzYdXOdhz00DLU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775057748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUl8++5R8i+376WORrDUkvPeK0+UyrLpft6eU56aOIo=;
	b=vYQLzVX00sLo+9cm1l+Yk0f3rg+HYt/h7LYO6K1aetUZ+HOXp7SfqgVSx0cphV+GB39P/+
	wFrh8Ck5YTh7jKPPdReEBRfnmWC1ndrkMsCmTrTJc0iO+1GTUU6wvLJrhio07ghLlNJcu2
	nbp2D/ie1ju4W4mBDI30g3JJl6bw3GU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oWI39OY2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.194.35 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bRwg66vu7CLtmzCb+qDoG/nofIvshQgMQAzfVk1OMj1Q5hT7+1yYbRfjWBzx7lWY+FN82Vk84uLwkEgYDplgJuQEWbw0yJjInXGyTyuvK2cClWTnHtt60iCZMbdyx357kfmFo/eurETRDXWxMag3PK5ufohwkQ8za9inCmFCQUhQ5+iXSR55nOAg4wzxKxLXAJKZtC3C/55dtBMqnsBo9tdHmHfO/KdS7oytUuS8uqQtWN2qE0UQ659hJaHO3rGnVtfeFhHqywRpddgXGrT+IMNLFadbCHCR+ziWYSaEiQjFj6GZIXF1j2/uFMYOjIY1DLdew32Xt3hyKc9eRn1vWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GUl8++5R8i+376WORrDUkvPeK0+UyrLpft6eU56aOIo=;
 b=Ocjzq7LsXb1jKy1Iy3nasnCwvCyy41t4fclXhaeSun1WrzVrHc+fnE8w7/RU/e9u22eRqOFX3EHjlhEhWRVUsemVFddhYazBBxcH9NdXky9IruZQZr2uGsPZTMrMk8YdzDWpacPGulnMklhTXOAMhQJzAKc4NIZ7drcO3BeJdUoYF4SpQSJpI3iTZx0KXqOLg3WBfcx1Fakpl3oYQJ1ut0pOOI7IuMIZ51kt9x9KpoPiylyxQQq2r6kU9WUea7o+i+INDzsrOuoJ6RqOqZW9bZtkPnAlxougQZGZmdTuaaYxzrZwQnUuntBKeaGGbeF5UdctQes4RpWsdzrMz15spg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUl8++5R8i+376WORrDUkvPeK0+UyrLpft6eU56aOIo=;
 b=oWI39OY2PProj4lsqKqzXksVNN6NeNd/0m1somBaqEODoOo+eWDkaDeXchMXd7/7pYIqnff9yzqgTSIt/h7/P27ZH/LV7vhgTJhtemzji5DqIe4mEysGpfA9JNuqtghQszlsVqUhXdPa3aMtnTn9O6Eskc0jFf6V/Jzryrb22n8=
Received: from BY3PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:254::12)
 by CY8PR12MB8313.namprd12.prod.outlook.com (2603:10b6:930:7d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 15:35:38 +0000
Received: from BY1PEPF0001AE18.namprd04.prod.outlook.com
 (2603:10b6:a03:254:cafe::29) by BY3PR05CA0007.outlook.office365.com
 (2603:10b6:a03:254::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.16 via Frontend Transport; Wed,
 1 Apr 2026 15:35:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BY1PEPF0001AE18.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 1 Apr 2026 15:35:37 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 1 Apr
 2026 10:35:36 -0500
Date: Wed, 1 Apr 2026 10:35:22 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jroedel@suse.de>,
	<jthoughton@google.com>, <oupton@kernel.org>, <pankaj.gupta@amd.com>,
	<qperret@google.com>, <rick.p.edgecombe@intel.com>, <rientjes@google.com>,
	<shivankg@amd.com>, <steven.price@arm.com>, <tabba@google.com>,
	<willy@infradead.org>, <wyihan@google.com>, <yan.y.zhao@intel.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE18:EE_|CY8PR12MB8313:EE_
X-MS-Office365-Filtering-Correlation-Id: f125971a-3aa3-4637-1551-08de900452ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|1800799024|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AJnads4jmiXsvFdLUCF6RLnLhW6S2cxdJLHlK2D7wkdQ3DfQwHuZAqJiD9U1UlKdy1KBZOHWe+WgjuCokcAli3dM/0+MONL3KHXZzWCG2e5ImlTuxvZWLjMr4GG5imUb6fDN9R4WxHbsqbjsovemkeC50iICRi2JfHvLiuYBD9uhIqNRvcYIaLKTUsVSPBxmTC8nDU4AeQe3jyYlBHecXL7tWn3JQB3/t7wAr5NQXuyxvtR0cDMztryAJ4afPAi/CnyB96VFrUtDi6izeY7+E5PyEnfYR7aRD2L21b9Lu/ETd2feQztHyeSZFFxhpS1NFj8YqEUocl7ceB3dxAlEg7OpDmh2sIqGIEDoG1Lt1FrhVbs+DzIFP6yKG8Cfypo+RiXBterkhW8Td5OnX0Gl8bCmkiL0Ep5uhzN6VXEm0cvlLHT0CUwN+owmqBY9fJ4pUlehEJLc4F/oc7t+UQgl8MLHD45o2F5NQgEtZLyQkLEEagw2qgd2poKW04Cnr5T1dFR+sIpZMxx9qzG0rgQKfm3t6E8SwFg6AulKFk86rn8oiawMsRR9JSwNRUtxVNiuph8wl7CxNMwof+DeGEzYbm5pzq7iOkx4XuRxfq8OwGFvihDHDeCVJTtla7lxyn2PbxmdYQ1QmaENzfuqBqFPMLM9AQ3UDxQLuCuAKt58t6SLcD9yQyhzO3innK7OMp48zAJo/urH75gocqyIiQpIHUq9DaD/SNtAXuqiejWoWDfowVQM526r2s/ciWlFMkwc6QbYUxBCC+FC/7ow823xTg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(1800799024)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WNeHO8uorJy0j9ANXxHDeODqBa3FnAf7oRo0XSzEeLlSBmKceEq9VFnSdHksjDBqH0u6shwYXXfqlHyRQGMgZDKGTphSN9ItYTIG4aBsBNyTewcldh5va6uB0++LpR9o5OpLwcYIXK6hpGKTo8EBZSks7oyNwgRYHI0/X5n16Gv9fHSuErqDAjIC1l6VKJV6oqF3Fw5EvnJ3AWfs63PjIg4cu0zOB86NpNqIRcK/uixrn7SZhEyhC6EfP2UERp1m7W9LxuC4RI8pLjo8n4pnbZ/3mAYdBPxjTBx3jRLlcQLkaMVSsPHYXaDWOsP/dadRjaZEZtHcIEGHmfZUitRRzFhWBUv31H8pUwIh7xMwMcx8FfF4XsDbb11HclmU2LktbnEruGSnHJMUOiqC94qtb3f7N+SYeCV7WrSQmB+976eoFSvfEchAh8xEm+v5jDq2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 15:35:37.7294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f125971a-3aa3-4637-1551-08de900452ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE18.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8313
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E01CA0005
X-Stat-Signature: u4zgtfi4ostguitw37hyagsf6uaq7rm7
X-HE-Tag: 1775057748-932367
X-HE-Meta: U2FsdGVkX19fMbvCLmav5jVz3JEmMnJADEIxyOeoQ6VBtlNYGuFCagOuBzlzej6rRtfNeXzBY6DZhND1csCV8wNrw0RqMZa+AYW7UUOvQxu0WwATeDRSg/91OCcSNUYz2Xc46RHlkSb5l+Kokh5dpn3ez1jvRDa2mRMerPmRzXMzmEU6cstuSyFiZyLjqBZ+6/UeCnhAgso+cocfwhjtLhz8oEKgxX0xLDLOM1ND2FQNP26xHApEUaIRh2eH/MX6di5JS9jPb5AVamCXOwe9me1/xld0+2pjYdeSUpNlz0a8PrSc8BwJYQDbr0U5IlGyYNmvsbC3RLRipllaQUqiIRGrcu6uGJJwc5z0OtluUT84RFg709bXYeaRQh2F4eLET7BIprawAEGvK4zFnmiC8F1ZAzjTSuEJmnUgqMwUqXObcdewcCFN+th8KlSuMh//y0tLzju9+VuwTecShYveOpxyIXcZmDnAUTCPRcA6Gu/S0TvIJUKXWofAQkq7qn/kI3C40cdM4I0T0TZ/blUOedEGoju9UMsB8X0rL9ofQd06GwiPAuCYa/sUOMeW1ZAedlHFqGV+LpTYe40Xg9PZcRiE2f4up6Maxb/xt4cBHQVUv0hTISWfTU88+fE2qhTHB9ta4srh7sTgLqA5BoHpd0WNDi1CMJl7uhF0JHLmoDcQALAKo2KM9EqBRxhUudOQHBp2bwpkbER5yidsEqsQKQkM7slHnyC0y/FDrHpe4Vr1L051OrjWMPSqUN1/1ZU+wvKJH58xlgMXifqS6509R7JhAyL5YUkfCMNlFDvvgvAL62YdKqLZYlUptBsq5O6iAUlzau2DYFIhAluZ5nt7b2fl6WRupqy3XhexdKXMZxeDkZJczjRYhh8oBp5muWIwyzpNHF52z3yvlHlPAUrJTHwjKdhelNPbaNPsUYhx5g6zrvJc0XX7aqOz1TojLGuxr4mhSjLgPZA0GvBMiLQ
 dL57DgvF
 7A5sPUIztT6d7oZhJQ/3Rsie6VFY/uYrn4M7zA+5AVFUJDXhnOyeZ232OoECAXRg95u7Qm8I0r/49Cfcxm+c1uGKCuOB++EbdlTvohKbWYWjKYvI9EDz6OYo4Hl4S0UierxXQE8AB1/R9knbAM5dVaQNiY/XxVAvN3A7qbLeAjKrns/c0sLNokDUE3Hzfyd5g+nRWs2KoNHoAcQYyiK84NjMWzUaWLznSRgmfTiRRVLnKgDuHf9SVomfQOa5DyxrxsWMDnTcolPJT/jmifLhrRP0xlRdjhOJVhFwghrJMR3ETfidUfz1mlC6jm027sYyTCodNZGOzXpuOGZUPHCZQCbosWDsrqIeWfYxAon9+AwtzPhmem5OKOzr17DlZSpaGeoFcLjOnpodp2PIMYye59o1OdsNy0tQ4Ei5ZqkZEMG32VB4OztmDdVBy3URBnr1sDq+HjHviNU8az3Mqm+4TermBa2MQ7kC3AMW4g65jLIxvvyA2MoGteA79P5uNwUj21qYK6v4//sfvueZCBVZKAsrdvcO6DoUANcxGQfJSMCkwAUZoOx+9vNjjsHRerwE6IZQ6Y18cAP7ZnQ0f394VKdHpPC/f2l+i4SZM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:24:19PM -0700, Ackerley Tng wrote:
> For shared to private conversions, if refcounts on any of the folios
> within the range are elevated, fail the conversion with -EAGAIN.
> 
> At the point of shared to private conversion, all folios in range are
> also unmapped. The filemap_invalidate_lock() is held, so no faulting
> can occur. Hence, from that point on, only transient refcounts can be
> taken on the folios associated with that guest_memfd.
> 
> Hence, it is safe to do the conversion from shared to private.
> 
> After conversion is complete, refcounts may become elevated, but that
> is fine since users of transient refcounts don't actually access
> memory.
> 
> For private to shared conversions, there are no refcount checks, since
> the guest is the only user of private pages, and guest_memfd will be the
> only holder of refcounts on private pages.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/api.rst |  48 +++++++-
>  include/linux/kvm_host.h       |  10 ++
>  include/uapi/linux/kvm.h       |   9 +-
>  virt/kvm/Kconfig               |   1 +
>  virt/kvm/guest_memfd.c         | 245 ++++++++++++++++++++++++++++++++++++++---
>  virt/kvm/kvm_main.c            |  17 ++-
>  6 files changed, 300 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0b61e2579e1d8..15148c80cfdb6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -117,7 +117,7 @@ description:
>        x86 includes both i386 and x86_64.
>  
>    Type:
> -      system, vm, or vcpu.
> +      system, vm, vcpu or guest_memfd.
>  
>    Parameters:
>        what parameters are accepted by the ioctl.
> @@ -6557,11 +6557,22 @@ KVM_S390_KEYOP_SSKE
>  ---------------------------------
>  
>  :Capability: KVM_CAP_MEMORY_ATTRIBUTES2
> -:Architectures: x86
> -:Type: vm ioctl
> +:Architectures: all
> +:Type: vm, guest_memfd ioctl
>  :Parameters: struct kvm_memory_attributes2 (in/out)
>  :Returns: 0 on success, <0 on error
>  
> +Errors:
> +
> +  ========== ===============================================================
> +  EINVAL     The specified `offset` or `size` were invalid (e.g. not
> +             page aligned, causes an overflow, or size is zero).
> +  EFAULT     The parameter address was invalid.
> +  EAGAIN     Some page within requested range had unexpected refcounts. The
> +             offset of the page will be returned in `error_offset`.
> +  ENOMEM     Ran out of memory trying to track private/shared state
> +  ========== ===============================================================
> +
>  KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
>  KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
>  userspace.  The original (pre-extension) fields are shared with
> @@ -6572,15 +6583,42 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
>  ::
>  
>    struct kvm_memory_attributes2 {
> -	__u64 address;
> +	/* in */
> +	union {
> +		__u64 address;
> +		__u64 offset;
> +	};
>  	__u64 size;
>  	__u64 attributes;
>  	__u64 flags;
> -	__u64 reserved[12];
> +	/* out */
> +	__u64 error_offset;
> +	__u64 reserved[11];
>    };
>  
>    #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
> +Set attributes for a range of offsets within a guest_memfd to
> +KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
> +memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
> +supported, after a successful call to set
> +KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
> +into host userspace and will only be mappable by the guest.
> +
> +To allow the range to be mappable into host userspace again, call
> +KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
> +KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
> +
> +If this ioctl returns -EAGAIN, the offset of the page with unexpected
> +refcounts will be returned in `error_offset`. This can occur if there
> +are transient refcounts on the pages, taken by other parts of the
> +kernel.
> +
> +Userspace is expected to figure out how to remove all known refcounts
> +on the shared pages, such as refcounts taken by get_user_pages(), and
> +try the ioctl again. A possible source of these long term refcounts is
> +if the guest_memfd memory was pinned in IOMMU page tables.
> +
>  See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
>  
>  .. _kvm_run:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 19f026f8de390..1ea14c66fc82e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2514,6 +2514,16 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>  }
>  
>  #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
> +static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
> +{
> +#ifdef kvm_arch_has_private_mem
> +	if (!kvm || kvm_arch_has_private_mem(kvm))
> +		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +#endif
> +
> +	return 0;
> +}
> +
>  typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
>  DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 16567d4a769e5..29baaa60de35a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -990,6 +990,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_S390_USER_OPEREXEC 246
>  #define KVM_CAP_S390_KEYOP 247
>  #define KVM_CAP_MEMORY_ATTRIBUTES2 248
> +#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 249
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1642,11 +1643,15 @@ struct kvm_memory_attributes {
>  #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
>  
>  struct kvm_memory_attributes2 {
> -	__u64 address;
> +	union {
> +		__u64 address;
> +		__u64 offset;
> +	};
>  	__u64 size;
>  	__u64 attributes;
>  	__u64 flags;
> -	__u64 reserved[12];
> +	__u64 error_offset;
> +	__u64 reserved[11];
>  };
>  
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 3fea89c45cfb4..e371e079e2c50 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -109,6 +109,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
>  
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
> +       select KVM_MEMORY_ATTRIBUTES
>         bool
>  
>  config HAVE_KVM_ARCH_GMEM_PREPARE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d414ebfcb4c19..0cff9a85a4c53 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -183,10 +183,12 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  
>  static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
>  {
> -	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
> -		return KVM_FILTER_SHARED;
> -
> -	return KVM_FILTER_PRIVATE;
> +	/*
> +	 * TODO: Limit invalidations based on the to-be-invalidated range, i.e.
> +	 *       invalidate shared/private if and only if there can possibly be
> +	 *       such mappings.
> +	 */
> +	return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
>  }
>  
>  static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
> @@ -552,11 +554,235 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
>  
> +static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
> +					  pgoff_t index, size_t nr_pages,
> +					  u64 attributes)
> +{
> +	pgoff_t end = index + nr_pages - 1;
> +	void *entry;
> +
> +	lockdep_assert(mt_lock_is_held(mt));
> +
> +	mt_for_each(mt, entry, index, end) {
> +		if (xa_to_value(entry) != attributes)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> +					    size_t nr_pages, pgoff_t *err_index)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	const int filemap_get_folios_refcount = 1;
> +	pgoff_t last = start + nr_pages - 1;
> +	struct folio_batch fbatch;
> +	bool safe = true;
> +	int i;
> +
> +	folio_batch_init(&fbatch);
> +	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
> +
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio = fbatch.folios[i];
> +
> +			if (folio_ref_count(folio) !=
> +			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
> +				safe = false;
> +				*err_index = folio->index;
> +				break;
> +			}
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +
> +	return safe;
> +}
> +
> +/*
> + * Preallocate memory for attributes to be stored on a maple tree, pointed to
> + * by mas.  Adjacent ranges with attributes identical to the new attributes
> + * will be merged.  Also sets mas's bounds up for storing attributes.
> + *
> + * This maintains the invariant that ranges with the same attributes will
> + * always be merged.
> + */
> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> +				    pgoff_t start, size_t nr_pages)
> +{
> +	pgoff_t end = start + nr_pages;
> +	pgoff_t last = end - 1;
> +	void *entry;
> +
> +	/* Try extending range. entry is NULL on overflow/wrap-around. */
> +	mas_set_range(mas, end, end);
> +	entry = mas_find(mas, end);
> +	if (entry && xa_to_value(entry) == attributes)
> +		last = mas->last;
> +
> +	if (start > 0) {
> +		mas_set_range(mas, start - 1, start - 1);
> +		entry = mas_find(mas, start - 1);
> +		if (entry && xa_to_value(entry) == attributes)
> +			start = mas->index;
> +	}
> +
> +	mas_set_range(mas, start, last);
> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> +}
> +
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct folio_batch fbatch;
> +	pgoff_t next = start;
> +	int i;
> +
> +	folio_batch_init(&fbatch);
> +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio = fbatch.folios[i];
> +			unsigned long pfn = folio_pfn(folio);
> +
> +			kvm_arch_gmem_invalidate(pfn, pfn + folio_nr_pages(folio));
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +}
> +#else
> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +#endif
> +
> +static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> +				     size_t nr_pages, uint64_t attrs,
> +				     pgoff_t *err_index)
> +{
> +	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +	struct address_space *mapping = inode->i_mapping;
> +	struct gmem_inode *gi = GMEM_I(inode);
> +	pgoff_t end = start + nr_pages;
> +	struct maple_tree *mt;
> +	struct ma_state mas;
> +	int r;
> +
> +	mt = &gi->attributes;
> +
> +	filemap_invalidate_lock(mapping);
> +
> +	mas_init(&mas, mt, start);
> +
> +	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs)) {
> +		r = 0;
> +		goto out;
> +	}
> +
> +	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> +	if (r) {
> +		*err_index = start;
> +		goto out;
> +	}
> +
> +	if (to_private) {
> +		unmap_mapping_pages(mapping, start, nr_pages, false);
> +
> +		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
> +						     err_index)) {
> +			mas_destroy(&mas);
> +			r = -EAGAIN;
> +			goto out;
> +		}
> +	}
> +
> +	/*
> +	 * From this point on guest_memfd has performed necessary
> +	 * checks and can proceed to do guest-breaking changes.
> +	 */
> +
> +	kvm_gmem_invalidate_begin(inode, start, end);
> +
> +	if (!to_private)
> +		kvm_gmem_invalidate(inode, start, end);
> +
> +	mas_store_prealloc(&mas, xa_mk_value(attrs));
> +
> +	kvm_gmem_invalidate_end(inode, start, end);
> +out:
> +	filemap_invalidate_unlock(mapping);
> +	return r;
> +}
> +
> +static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
> +{
> +	struct gmem_file *f = file->private_data;
> +	struct inode *inode = file_inode(file);
> +	struct kvm_memory_attributes2 attrs;
> +	pgoff_t err_index;
> +	size_t nr_pages;
> +	pgoff_t index;
> +	int i, r;
> +
> +	if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +		return -EFAULT;
> +
> +	if (attrs.flags)
> +		return -EINVAL;
> +	if (attrs.error_offset)
> +		return -EINVAL;
> +	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
> +		if (attrs.reserved[i])
> +			return -EINVAL;
> +	}
> +	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
> +		return -EINVAL;
> +	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
> +		return -EINVAL;
> +	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
> +		return -EINVAL;
> +
> +	if (attrs.offset >= inode->i_size ||
> +	    attrs.offset + attrs.size > inode->i_size)
> +		return -EINVAL;
> +
> +	nr_pages = attrs.size >> PAGE_SHIFT;
> +	index = attrs.offset >> PAGE_SHIFT;
> +	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
> +				      &err_index);
> +	if (r) {
> +		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
> +
> +		if (copy_to_user(argp, &attrs, sizeof(attrs)))
> +			return -EFAULT;
> +	}
> +
> +	return r;
> +}
> +
> +static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> +			   unsigned long arg)
> +{
> +	switch (ioctl) {
> +	case KVM_SET_MEMORY_ATTRIBUTES2:
> +		if (vm_memory_attributes)
> +			return -ENOTTY;
> +
> +		return kvm_gmem_set_attributes(file, (void __user *)arg);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
> +
>  static struct file_operations kvm_gmem_fops = {
>  	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> +	.unlocked_ioctl	= kvm_gmem_ioctl,
>  };
>  
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
> @@ -942,20 +1168,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>  static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
>  				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
>  {
> -	pgoff_t end = index + nr_pages - 1;
> -	void *entry;
> -
>  	if (vm_memory_attributes)
>  		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>  						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
>  						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
>  
> -	mt_for_each(&gi->attributes, entry, index, end) {
> -		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
> -			return false;
> -	}
> -
> -	return true;
> +	return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
> +					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
>  }
>  
>  static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3c261904322f0..85c14197587d4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2435,16 +2435,6 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>  
>  #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
> -static u64 kvm_supported_mem_attributes(struct kvm *kvm)
> -{
> -#ifdef kvm_arch_has_private_mem
> -	if (!kvm || kvm_arch_has_private_mem(kvm))
> -		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> -#endif
> -
> -	return 0;
> -}
> -
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
> @@ -2635,6 +2625,8 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  		return -EINVAL;
>  	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
>  		return -EINVAL;
> +	if (attrs->error_offset)
> +		return -EINVAL;
>  	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
>  		if (attrs->reserved[i])
>  			return -EINVAL;
> @@ -4983,6 +4975,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  		return 1;
>  	case KVM_CAP_GUEST_MEMFD_FLAGS:
>  		return kvm_gmem_get_supported_flags(kvm);
> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> +		if (vm_memory_attributes)
> +			return 0;
> +
> +		return kvm_supported_mem_attributes(kvm);

Based on the discussion from the PUCK call this morning, it sounds like it
would be a good idea to limit kvm_supported_mem_attributes() to only
reporting KVM_MEMORY_ATTRIBUTE_PRIVATE if the underlying CoCo
implementation has all the necessary enablement to support in-place
conversion via guest_memfd. In the case of SNP, there is a
documentation/parameter check in snp_launch_update() that needs to be
relaxed in order for userspace to be able to pass in a NULL 'src'
parameter (since, for in-place conversion, it would be initialized in place
as shared memory prior to the call, since by the time kvm_gmem_poulate()
it will have been set to private and therefore cannot be faulted in via
GUP (and if it could, we'd be unecessarily copying the src back on top
of itself since src/dst are the same).

So maybe there should be an arch hook to check a whitelist of VM types
that support KVM_MEMORY_ATTRIBUTE_PRIVATE when vm_memory_attributes=0,
and if we decide to enable it for SNP as part of this series you could
include the 1-2 patches needed there, or I could enable the SNP support
separately as a small series and I guess that would then become a prereq
for the SNP self-tests?

Not sure if additional enablement is needed for TDX or not before
KVM_MEMORY_ATTRIBUTE_PRIVATE would be advertised, but similar
considerations there.

-Mike

>  #endif
>  	default:
>  		break;
> 
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 

