Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F324CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD486B0093; Fri, 22 May 2026 17:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94736B0095; Fri, 22 May 2026 17:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA8D6B0096; Fri, 22 May 2026 17:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 996B66B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:59:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41092A0588
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:59:18 +0000 (UTC)
X-FDA: 84796422396.23.537BD17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7E16A20003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:59:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYAaq802;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jr/Z2AKz/S6GO5hNUPCMB+wOkCX8/5qQhPyUJDn/qd0=;
	b=IAkJY5cjU7Ai/ZcrBx0WAY6wi7RIp/taLs15rnMDuD9jYIsF9VDtN4mTL/YN4nedsLOt+n
	0KulnIRAdCzj2R2ECvIUVJgz3iBp/c504+eJEGeYw8+DvSk4cnHDN/n/JGAUaSyZPncn+c
	LV+7Wp01bnsuWPmjzh3A7oEeVp0LWtk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYAaq802;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487156; a=rsa-sha256;
	cv=none;
	b=hcVM8zwGeT192TMBVAnpZdf7nX13FPi0tO5SGKjsZtmm3r4OtZGBNRH+mjNUkU3U0QU6WR
	9gEqTvSphkas9e0rjh/thXbLjJteAwkYwyAgGusjgt0jOiUAgNPmvr58Sa90enJyBKNzRP
	sC05HYME7gWNe9iMgwDepbfYxnAk0iM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AA4B43260;
	Fri, 22 May 2026 21:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830F51F000E9;
	Fri, 22 May 2026 21:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779487155;
	bh=Jr/Z2AKz/S6GO5hNUPCMB+wOkCX8/5qQhPyUJDn/qd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EYAaq802O2za9BCFbi4Cl+SfNKnQlkvaAfjcYaiPPCp/SLXcgTk2WxuFGNK4P7Vtm
	 58kRCm6uAsnRbVMHG24BLYCP8pT1OQWsjYwelrK5wU2OE9cVMEIxP994QK0VEj7OWP
	 ZrxeicvQHidzeg1aJp5NkML6Man4qqdbQEdvbLQGx/mc7to2/AEmHe7SildFkaC0ZS
	 wd76BFBYJeDXmYJDMCcekBFIf94k8AbcgfeXG/GV539bRLikd2C3RzglpxWPVtXMUJ
	 xekiBJoZHOUHKIkirn961KEs58FLMF2NVuDTM+Hw3zX00254bIEv4I12WmsihPKjsv
	 I2YIuvCjeb3Cw==
Message-ID: <94f759f8-e2ed-4f22-b9e7-4693ad005509@kernel.org>
Date: Fri, 22 May 2026 23:58:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 14/14] Documentation: mm: update the admin
 guide for mTHP collapse
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Bagas Sanjaya <bagasdotme@gmail.com>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-15-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522150009.121603-15-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qsn1wuypg9hptdpbxp6aguuprboho3r9
X-Rspamd-Queue-Id: 7E16A20003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779487156-950086
X-HE-Meta: U2FsdGVkX1++ngVPjucVIgDxRo4t0ZsQhW0xgtbiAuFd8ZNfZ3JFb8HejthnWhG43wN+2CnGAD33JET53PVhHUOdPi35xUDrTOgJ9Vnwkecmj1nRIOr+6Xj0EoRYQ+YPFlThM7R7w8uy8tBdi2do1YIkidhLBGt7OxvL5s5CYln5JY00riexeVVSM3HD5+EX8wJN/tGiZ5KYdzo4gwbeWt/hkxNoKQKYbZKWD5BcvHhon2mQZFFJFihZs+vSK4sIRXzixsgocSdYNv3i15sF1VRu6WJlU6X7QrYCHcOF95KTw1drvczZxPWIJqTjjDUFdxcYgfxDN+6p3y9rXcjNf+b2WHhPrmSO6Mg3PAcpYI4ibuqHgYn+ERkILV8+OWPk97AUEjwfN/NQ5RX6JgPr17l1kEsH4TNfYX52QkUmtpZxuQ6KBxZYvc+OcgMAzaxhm2Jy1KGnIKQwHuNRVcib3UTB9f0TB/fUDMZe7N154SeKSiHHckx9VZetHujkhOWyAl0H7UIpU+7oX7dzAXCslNno5W7xoaY8GfqRToMj1KxpMtQHiO5qtU7XpHHJURuyOk3y+C0C3z98d4lbcfDj/Rz9WDXwwbD9DpWAnU2cCOG6t6iTfIyRKS8BGVToWikCSR0LcBtxdIpH/kLqxaQFCh4Nrdvdq4FZ23gE3KXkNjaJDMsWO47WA4ElhhrpDOOkG6a/CuNCzm0/dageb57GoigrJjmqqlvelGlG0HhOUWqbSwEzU1w6Xl9m3JqDWK0JByU5kuadhJ8a83nDgH8Xz8lEGjt+PRmBogtkvmJiuhgLH1mmTwsaD6e/lToabFbl6JxeHQ+CKcI6/HPXlCsQhS41Qxzw+/MBHe9ZZz8GH5idU4HoHVo6leZY3bQQXwDAEvR5ywyh+49SMGxEcNj5yuXJvdvQLLyRBH9c3ATn/Zb4UX86ZL3IT88EZuNTkZtEBbjwD8Y2Pc8CBQ0LkTh
 TWh0bMg0
 2QcQKMaPMPbd3T71LqMK0HMxbp0J2Wnvkb4cXbMHqv8vuTaXyS4NpCgkNbx/vitWxCGAGwP8fPg3MEHPVnONhRJ8MsXQ0TAiKvjLY2STgFf6hICRmc92SqqXIb5b4U58BFT4JrkgFUrVMaYJ54taRHwTziXdxZUHgccKv1DWsixfQSmGlOC+sOnM+/u4uE4VJ13SisKrr7A+5ROBHAlOrNmRZdZ9D/5vaqwPVQlVV/iZGHMVEjJuZxelWziLcDERjZiUoJ6wbSiGBLSz1pVARJ0V5MI5JY34yt9lmvZ8CdkKlACzJ1Nv93gsEvi4URNgR3+NQZzUD4GnEfZDjYhC+MbJ/7LOEzQwN1m5TcIFV7rg/EIZ42HgcC8oF5cknHBr3pxIr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
>  process THP controls
> @@ -264,11 +265,6 @@ support the following arguments::
>  Khugepaged controls
>  -------------------
>  
> -.. note::
> -   khugepaged currently only searches for opportunities to collapse to
> -   PMD-sized THP and no attempt is made to collapse to other THP
> -   sizes.

Should we maybe leave this here and clarify that for file/shmem, it will still
only collapse to PMD-sized THPs?

-- 
Cheers,

David

