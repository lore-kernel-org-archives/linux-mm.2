Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9C910F9307
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 23:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE09A6B008C; Tue, 31 Mar 2026 19:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91B46B0095; Tue, 31 Mar 2026 19:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9597B6B0096; Tue, 31 Mar 2026 19:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 832616B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:32:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 287E2B97CA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:32:11 +0000 (UTC)
X-FDA: 84607958862.22.6A46878
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010014.outbound.protection.outlook.com [52.101.193.14])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1808C40009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:32:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WCEQFoGi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.193.14 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774999928; a=rsa-sha256;
	cv=pass;
	b=mztdVNXt+2RpRwCnMQO4xFivDgMo4l1vNirV1q/RHYVD3f/ig/wtd/jUwD00JuwxhMgBFr
	EvwjxM/MLuRfk7fAVRBS6rheUvecOAKnuEMSESIfrkuVyW0CzGmoZeJxKCviWDH7KWp+94
	o/ms9Gv54BYxWnIGfnhANHYskLastCA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774999928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9i7/L8N61XGOxLN8370xhuHyXq8itLZLu+EjP5vnfc4=;
	b=LCu2+ueyYM0HqP78WiEBzUYanp/bJmGX4R8EhZMIbw27vgXdRodWQ+sukb1bAJcAT5bQZx
	pDwy2/dNtLJpQzCE2AAgjaqZEcKdAIYjTjikclEfjSrPsc1Foy3wsVH7h8dBynKrhL0vFN
	RjCtnSfVzhg3BIrpoSMIy+u0THus6b0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WCEQFoGi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.193.14 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EEap3v3cDwCgOEWxOxBPQGXV393MZyxrdd4U7B6ZfJx2kgJYIvPuaf1dt4ygstfgET59u8d1xFqJZC9jrrWsgGih3eDrCgtcaDJalkSNFHCTJ6/3Kf1231VhopqV09Kb5Xvvqy+6UKwHg7hGpUqvr499m8RHlXgweNBT+JhHGa9JLjS8Up3+yt3eHQDeB0VWS2Bturo5cLKVJ8R7Q8h0nXf2QjJLqlGT6oPnTVU2kPmNpaPYc16J5sxgRVdtEzDzjnWM0AWZdmY65hPQJq5ySBcdUGabCxoIHCTMG+qmf7v3YbRU2736Jn43OwT+N0jOArCiznfmMsSBDG0iDeSOfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9i7/L8N61XGOxLN8370xhuHyXq8itLZLu+EjP5vnfc4=;
 b=BkHqns2FvBfphz9f3vmMvHeOVnmJuxMaAbpcb3VG07EVZnGUMLv6J234p6f/fvdS4ufHW0ooAYMbJcMlsLtDbhybl8VX6mFwlk8KgS4h8zhcJ8O0sFWRfA36d2vPeUVurV2H/rK4xmvQv+3iddZxVXdfvXmC5E5YUdWzkAbGobAtpt5kM0srddRfES4T3tOHe3jCnIWYWd4Pd6YrK/DlDmw2ZbJh8/psa2cs9Uss11pMKjCEEW/dNepABprywvPUwaurcw8Y8+ZY0fpFj1K/EezfSSZoy8jfgLvNygGxpHsP0awD1CiQR1gbrxzsF/ORd30Dhuvmpl1ZhhdDm8j5Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9i7/L8N61XGOxLN8370xhuHyXq8itLZLu+EjP5vnfc4=;
 b=WCEQFoGiS0y3qC3pRg8tb9+xkBTZcWhz5PefVmGRSoi1iRLkaoOLRIFAtfYGveFz2b2WbhwsL62XJhvAkTd9K7WebRn0VEOsofW2on+zrI+HtXwDgYi8K4f7kvTeiSwCty1wZqMdLqAPdXlMvAMNxaYri6nfYo+it9c8AnVL0UY=
Received: from PH8PR05CA0024.namprd05.prod.outlook.com (2603:10b6:510:2cc::12)
 by SA1PR12MB8886.namprd12.prod.outlook.com (2603:10b6:806:375::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Tue, 31 Mar
 2026 23:31:54 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:510:2cc:cafe::c0) by PH8PR05CA0024.outlook.office365.com
 (2603:10b6:510:2cc::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.15 via Frontend Transport; Tue,
 31 Mar 2026 23:31:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Tue, 31 Mar 2026 23:31:53 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 31 Mar
 2026 18:31:53 -0500
Date: Tue, 31 Mar 2026 18:31:05 -0500
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
Message-ID: <cqkyz4zxosmev6lnbasa32ed5jjfljrx3gr6plyjfhrtbysuwr@rg5noy6y6ayu>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|SA1PR12MB8886:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dc181f7-1cce-4908-1af8-08de8f7db13c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EF4RvKvPkuOhPrdw8fXb06hJgmMfWhTc2V6A2rWaibTaY4ONa8dBHERxsCobKJJiOjab39lelvWnT5Ax7mKvGiJajHHy/GQXiZzYVjn4HTjaUwPYxi+jCctsgpnPV0pDjgT6hwvsmecBGWi9J/HzixYOdcxJRYSCFYSQqpwupwytOKQ/a5hIvJFELtHQr8CxmR9N93j7R0Yc8qGzSFsvxtmjUvRFg3T9+gHlUDM3SOYcrGUxOUkNmmZffhGfpTKN0seC0noTzRJlaayDWODN0xGisXGwmKLUJEjB1U3Gbdujhus3LSxqphKx8rVoGd/hDx5sESr84TeZq6nr2cT7vadnyZD5/XByqgW/tO0O0NNiSHaD3H2GJv3vNbus3uyI452ma67m+CYoZFafrwHDyOBdE3be+vybJYDIN3w5Dlr7r9yOhqnsSfGFZJMKdYhxxqUMPTGCHkC7mbPMIJRqN8cnJnFpIvepji0hcMd2Zog7m51tThIjz8GhD/MX4tK7S2V9J5S+q7+Jug3twwK5yM/JS9vNhqgO4ru/I/elzZv9vjj8Mg3r6zFJyTwgnBCP8zZRfaeX8iQ2/J7SIlnFlPQdPdpXr0s8VlogQCTPSAudSrVKnXwL3Ny1nr7X9OS7XJoRRRxELUTwC9iSq5yb4UGnfCzQuEk8YP1/tm8MissxU8kFl+QxTd4w14/VRErXC9mgxaSy/CX4czX1yZwRvXNPltvTJ7ji3HOP/MlEZdDAsjhdODI7SEG43fKUazP7RL5dIH4XBuH60YrxfbWl1w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	x0zni7VcSq3tFbnDgfY1IHqGkrFvCM61HfpJdSzL0dQdakILD2CGg4SFM5iX4uX/FlGauWMfKwLtVyBvvHHTToMmJzvVkyhWXIHMIjyJxMpnHKxaoWiZjl8wk7kBsKXQBoQhEvS+eUFKHc7wWeSwcUA4iGulZQcPoajhGAxwHqATsM6N1TEikYv3DIJwFc+IhtB28gWu+nL3llA533iVx1m8qA0/kf/0OYCyYWlODkcZMlA4kMRmpuO8fMUqdErEmSgxGZcnjGnTXLE9AUiLceB7iHyeVilTrMqh/K+GHTrzx+aZfaaKrkd8usTmapPp8cNGPw569e+10R7Y6N5z2J6mtR2dfNk0OMUTkT3kLu+WGRMee9fOlDSJP/GmvTVZlvFioRSeo4mGL+QNbuwcNsFcrw0ZwNM9+maEEG53+q9X3oh1+dKm6ROq7N1uN6K9
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 23:31:53.9703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc181f7-1cce-4908-1af8-08de8f7db13c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8886
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1808C40009
X-Stat-Signature: k9nu8fdn5hdkkw8saowskddrhqbg7cqa
X-HE-Tag: 1774999927-417543
X-HE-Meta: U2FsdGVkX19Pf63yAeKirj81UfffIlPADvn5Y6oegvUhXp9Mjpi9ut5aMouJUpWMPNeP4qnPyMJsk41FvzLhmD3qbrGXtTdRAoScY/P4YdmFbx+r7WJXZ/LXqOyroBHA1YRk/Wdg3VSDs86HSwID4xeGT2tY9Ge7zV0q6bDzakEbljwAvTiv+P96Eq5cBmErAwI0nsg/xYAn5m17U9ocPieXZxNnBQNkoAyqrA7Qx4BTtRuS9bsxbbgnZosIdi3BHq5uhrhcfYELFffOuJmesqrYn6YQoTqqypCdfRr1NIHecTM/T75Pa7HYzs/gJ/0JzB4Cr0t9yOSrMx7SP/h6FXJjbF+PGfdgK2lQsZvNmzjFrnGzIk6WvvhDZIc66iL3LmFEf8EK+o3J/U4EXk1ZMN5wWJ+AmMZJ7H+JgE4UOVwcwf4LLSY6YPxROtSI9EgK8LWsHhZVb77fKX8y7vE65qDxKHwSnqZGWbREWwl+hY9CD4GBgCbKY0tyzGIlm/DWVu9M1Pc/tFnFVFvvBsr66IsXeSWG4SmKmIcsz9ydSZ2t1J+01u6ILfbdLPhTy6yg9BRo6vt8WM8P6JRPL+KdGDK2uBN0XowrOEFtmqHWziVZ8KDbZD5kGYE/U7XjTqkmfqTkPyD/RgV+fn1hhmEpdoyb8nrxrzjfs4f0kl7ePJuOzXAOtvwMCtjrKFzKBAOJsWEJNR9uHKvYVDrob11X8T3bBw9Xk/HtgPqmDrD1+p2ssYSx+GU48OvuPYQzr6pHN6B9+OFyrpnrt7tozfJY9gVCydhrc8uWzNJjDm9VQbPkDmFfqIu+pRxiizZmLAkguUqzyFej7X3iOq/I9xFRtFivl2A0QL1oFzf9fxUuTA1SX98n6DrdrSTvDaik22DMG/6+epbwlF8WxFkc20e4tNnsaR+LEPwlb1Fv9IGi7tUi1ASh5aA2/eqWM2uUbWf3KFFtvuTxtI2q08bBlUN
 Yv2QiJz4
 jvcGo1nJnM2aNogMMyCw7mfr16Zw+nv9fkZtTLod8EhNSCGwO7bxBYKB0iGXbvnkWl8v44nEdpk7WrRpJs/riJwvAU830ZyVJF7qdPasdzPE6U5nPNElC5gHsn+25Jj1cynmOTI2MJ821I7yvUBizNOLI2fs8nrMzBd/rv4oOmiLa4eoh3A2qoXAt1Ey+vY1xBwMmJB2A3vGjiCPhKOtrsS4g9AjhxbUAhW2OHtfrU0x1TkSXcDCBJlxLAYm9T5W4gcNAe5lloyV65AF3kaOxhTjay8ExgcIgEtOIcJiHEXF4CSZKwbUDi6VW0tZqVT8dPjhXCj2bmRexWHNyjvbTtBnO6TlXvvzbaFdjk5sSy01O9+DwUd7yNn2luthdN68G3L6cWZAdpTvxPNVyqwulERQuhPY6VOx1hVKr+dRq4rF4NZ3kHd9Mttcpb/aPBxuYHdRYKYYkYUsstkAkxTJS8hJtOGJX3PUuOk29Flg9dh0jl15tiJ7QxkLb4tO5BvD/vls5X/WXN9BkT9nZ4tzvsafBgHoxCO2cKGwweJtG5DAh4FXDWfDw8WUmkZ/rxB1ZZjuC8Lmfb37oRfqVQoKGIL4PnHrPhy6picW2
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

I think KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES deserves some mention in
the commit log.

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

That's only true for the guest_memfd ioctl, for KVM ioctl these new
fields and r/w behavior are basically ignored. So you might need to be
clearer on which fields/behavior are specific to guest_memfd like in
the preceeding paragraphs..

..or maybe it's better to do the opposite and just have a blanket 'for
now, all newly-described behavior pertains only to usage via a
guest_memfd ioctl, and for KVM ioctls only the fields/behaviors common
with KVM_SET_MEMORY_ATTRIBUTES are applicable.', since it doesn't seem
like vm_memory_attributes=1 is long for this world and that's the only
case where KVM memory attribute ioctls seem relevant.

But then it makes me wonder, if we adopt the semantics I mentioned
earlier and have KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES advertise both
the gmem ioctl support as well as the struct kvm_memory_attributes2
support, if we should even advertise KVM_CAP_MEMORY_ATTRIBUTES2 at all
as part of this series.

> +
> +Userspace is expected to figure out how to remove all known refcounts
> +on the shared pages, such as refcounts taken by get_user_pages(), and
> +try the ioctl again. A possible source of these long term refcounts is
> +if the guest_memfd memory was pinned in IOMMU page tables.

One might read this to mean error_offset is used purely for the EAGAIN
case, so it might be worth touching on the other cases as well.

-Mike

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
>  #endif
>  	default:
>  		break;
> 
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 

