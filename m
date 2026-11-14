Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0441606A884
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 06:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RphnadHq
Received: by kanga.kvack.org (Postfix)
	id 037EC6B05B1; Sat, 14 Nov 2026 01:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD876B05B2; Sat, 14 Nov 2026 01:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC026B05B3; Sat, 14 Nov 2026 01:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A96026B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:46:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C3E8C036D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:46:15 +0000 (UTC)
X-FDA: 85432790310.29.948D7BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1189220004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:46:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RphnadHq;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794638773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2sLgLOKrNeynVkasVZiOvcon7Y5kt9OU0MF0lujG9c=;
	b=ANm/1UQvrwO27P1sYEBXPV6MgxB3bvvuIGbgCFAGqMlYDiglDqVBQY3hKk3wTj4on2B/Ru
	/ZYM9MhSnTNikm/uVLAbOHIgTEm5c88qh32SWApOFdE4Wp783i4RVXvfZZAxA7b8cH1kce
	jVp3mykShMKa0UlEFKvp+bBpaCINpgc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RphnadHq;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794638773;
	b=PcUZr70Mn43k0c93hkZloI1wBolii1cVHegmlx0grvQzNId5CktXLvD6OcZ5okIHVrkb9s
	lFEaPaaEzkkA091X5ojyOut1j8EeHxFcYp91pYBUteKKnkJOhpTm791P6AlwzVCHJ7rn1w
	rKk586Mvr5Ryre05tAPC7cYkwgACwQ0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A83B91516;
	Fri, 13 Nov 2026 22:46:08 -0800 (PST)
Received: from [10.163.154.162] (unknown [10.163.154.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D712C3F632;
	Fri, 13 Nov 2026 22:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794638771; bh=2p+aENh47akfGlWR6ZTS9pUD8OTqWk1g+6Ivv38eA3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RphnadHqNUso6hl5YrI4sir0E4KMlPFHhwYLkDbzg1C7hBuo/Y00JyeydDKOVwaeg
	 +cgLWiUAkBPnOEz57Pg399P2TnUHxCvpDmjWLtlV9VXwxsxpSCkL5cefwBFrFx4tB/
	 1WZu/r7k9IKPEDUoM8qx6OZiBwKBDiQBLPPoV9Tk=
Message-ID: <0b018af5-0a97-4e3c-9d28-5efca28f163a@arm.com>
Date: Sat, 14 Nov 2026 12:15:58 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] mm: batch rmap walks during large folio migration
To: "Garg, Shivank" <shivankg@amd.com>,
 "joannelkoong@gmail.com" <joannelkoong@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kmanaouil.dev@gmail.com" <kmanaouil.dev@gmail.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "weixugc@google.com"
 <weixugc@google.com>, "byungchul@sk.com" <byungchul@sk.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "vbabka@kernel.org"
 <vbabka@kernel.org>, "harry@kernel.org" <harry@kernel.org>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "riel@surriel.com" <riel@surriel.com>, "david@kernel.org"
 <david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "surenb@google.com" <surenb@google.com>,
 "rientjes@google.com" <rientjes@google.com>,
 "kinseyho@google.com" <kinseyho@google.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "gourry@gourry.net" <gourry@gourry.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "usama.arif@linux.dev" <usama.arif@linux.dev>,
 "jannh@google.com" <jannh@google.com>,
 "liam@infradead.org" <liam@infradead.org>, "mhocko@suse.com"
 <mhocko@suse.com>, "ljs@kernel.org" <ljs@kernel.org>,
 "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>, "fvdl@google.com"
 <fvdl@google.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
 <CAJnrk1ZkhvyGLUyZrf_gA3XBv1XTfHArGOMgqr=5XbSCBJHz4Q@mail.gmail.com>
 <2ed65a57aaa676a59651abd671f18dc9b55f9195.camel@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2ed65a57aaa676a59651abd671f18dc9b55f9195.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1189220004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: g7t19d8can6x7apzqserpon88btd46yo
X-HE-Tag: 1794638772-853514
X-HE-Meta: U2FsdGVkX1+sY2srUZhh8yZPyRDsig3FLmZmESj42Hc09rC7d0p021o332QPvD7XIviyDdKeqZ+SE45EycT5REIdM89uVBiBE16ZomDLHd+1FkFDpsYDGNFxMnCCIBRok/rtqfYhfhDMD3pM1goMLnNjAA+OIP9sjv7hswtoEYkK6jODBknMrQXMqm2NoX1IDwEqSxb1pvHUoOKykWjFf4zGWMyFTc1sRaApxcc3aP85haWnJPhgMGfZPkOcVwGgNdgchCmaASF1ioHbVUEEp7UX5vVMCGwwZJbBvazvfQ+zt2Dl+ecoymeP9KY0C+hLl9mvfjNsDeo5pbRweH1s0s8uDOO1iI1AGZco3Xl2op+pT+s2HvcT1xhptIz89uNUZ+7tnTWFhBgrTtWCyPKlDpajwx6tRLopz/tH6H6GaboCnkWB080tOnYsp829zBet1O9QxPTgJ/PXpg0pj8hycbkLSvOIJs/TRXbcm7Wx8YuCGibRft0nbwGz+hMopQRejFQnaoZltCeykN83pla/eIB8FcfDqobZyExHIx5+RQYQP/e5GHzkjkOy46OBK3R/3dYSqouCVXeY7FOtLGSRo65r3VhzMLvhnSWR/ZyOg1u5Gcflh0dNThmlHkd4JfRBSFM9HE+3MztOwCWl6W4xi6m9kVniu3z1bjZfTCIVI6NuW8mZUHPJk/9V8jjjpSqoxJesfMNAYdX5w28mKvdMEnoDk6npHObQUFrZR67sN7EQkXQ9TvkPZ/zpPbm1KMieAVi6gaspC0hf2z0oseykdHVvlmHYNsHoAUcrKNAW1Afg7XZF3oaDzW4xpBoIlJ+GMs2I68ERffqa4vM3ie/QHxPF4iNo3SckbvKvPhnUYmu8h/UFWAOYuaQERAgEXyd4kdXQyCMuuaQkTmbDC6lNCxOCTl+4WhKWwiQE+bMgfRfCNjwxj8ZnspxXEFqjcmDlLhGsT3y8OXROtZFgjtu
 Qu2GvJ9x
 mrpEsmIsTS4zxpqyNqpB4/h6XZIJMwa4pUSG14f1ywv89zAaBtjINgWYOq499hgRPS5ygxkmN0xGdWvn796FZ9qlZE2KcLiLwj/peo7DgiPXLUL1dsII4n6fHIDGikDWyKA0PKko5E5yVDQXhpKxFU/ctt322pvIvENy+xjcVgK7y9fMMd9w4m+N4hyO7O59HcBz0aqkrbvBp4Qbp5GGQwyOYpQ5yj1R/L27GTQ53NgQHizLqLpxhMzt93d461R0L5Tajk7opZW7nDJR3CuqkQADK77tjtr9RIOYpI9w1R7SQOPfCTJIK1H3Jgew2Ajh6nCV3RHs62OApQIpB1MS4A2t7Nkt3F2WhBCNtaiq5DexvlhPAqHfMzhyFj/BzCWt+M4j/FXdkLlaqJFD+e9CGa+c59xAWnk6o/ANtZ4EVjpFWoHQ6/8qqnzOBu9suV7ZWM3yRGEXjBFXX404HCoYuX+sdAq/m+NDPMstETbNXajHaiax+Gf3Hu3n4+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 12/11/26 1:07 am, Garg, Shivank wrote:
> On Tue, 2026-11-10 at 16:08 -0800, Joanne Koong wrote:
>> On Wed, Aug 12, 2026 at 9:24 PM Shivank Garg <shivankg@amd.com> wrote:
>>>
>>> Migrating a PTE-mapped large folio currently walks the folio's rmap
>>> one page at a time. It does so twice per migration:
>>> 1. try_to_migrate_one(): Replace present PTEs with migration entries
>>> 2. remove_migration_pte(): Restore migration entries to working PTEs.
>>>
>>> For a folio with N contiguous PTEs, each walk repeats page_vma_mapped_walk()
>>> and the associated operation per subpage of the folio. (256 iterations
>>> for 1M folio).
>>>
>>> This series enables both walks to process a batch of consecutive PTEs
>>> that map the same large folio and do some refactoring and clean up on
>>> the way.
>>>
>>> Performance:
>>>
>>> AMD EPYC ZEN 3, 2-socket system (1 node per socket).
>>> move_pages() migrating 1 GB from node 0 -> node 1, throughput
>>> in GB/s:
>>>                        batch-         batch-restore
>>> folio     vanilla       restore-only   + unmap         restore%   restore+unmap%
>>> 4K        2.96±0.15     3.02±0.14      2.99±0.17         +2.2%    +1.0%
>>> 64K       5.99±0.10     6.12±0.08      7.65±0.16         +2.2%   +27.7%
>>> 256K      6.48±0.09     6.67±0.08      9.23±0.14         +2.9%   +42.4%
>>> 1M        6.76±0.10     6.98±0.10      9.74±0.19         +3.1%   +44.0%
>>> 2M       10.50±0.20    10.44±0.16     10.67±0.21         -0.5%    +1.6%
>>>
>>> In plain migration, the folio copy itself dominates the cost, so these rmap walk
>>> savings are only partly visible end-to-end.
>>>
>>> When the folio copy is batched-copy and offloaded to DMA engine [1], the copy is
>>> no longer the bottleneck and rmap-walk batching translates into much larger gains:
>>>
>>> This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:
>>>
>>>                     batch-copy                      dcbm+restore
>>> folio    vanilla    -offload(dcbm)  dcbm+restore    +unmap          (rmap batch impact)
>>> 4K       3.05±0.13   2.76±0.11       2.77±0.12        2.74±0.09
>>> 64K      5.85±0.11  10.66±0.27      11.56±1.45       17.55±0.56
>>> 256K     6.26±0.08  13.64±2.73      13.68±0.16       34.76±0.57       (2.54x)
>>> 1M       6.58±0.08  14.25±0.07      15.27±0.77       44.28±0.27       (3.11x)
>>> 2M      10.61±0.24  65.26±0.96      65.25±1.65       65.66±0.87
>>>
>>
>> Hi Shivank,
>>
>> Are you planning to send a v3 of this series? My reason for asking is
>> because batching the unmap also fixes an existing issue where when
>> try_to_migrate_one() unmaps a PTE-mapped anon mTHP one PTE at a time,
>> the folio looks partially mapped partway through and gets flagged for
>> deferred split. My mTHP underused shrinker series [1] makes this more
>> common since every underused mTHP split will now go through this path,
>> which makes this bug a blocker for the series. More context can be
>> found in [2], which was my attempt to fix this bug, but then David
>> suggested we fix it in a better way by batching, and Zi pointed me to
>> this series.
>>
>> Thanks,
>> Joanne
>>
>> [1] https://lore.kernel.org/linux-mm/20261103212004.1356327-1-joannelkoong@gmail.com/
>> [2] https://lore.kernel.org/linux-mm/20261109220958.2071687-1-joannelkoong@gmail.com/
> 
> 
> Glad to hear this series helps your use case.
> 
> Yes, I'm working on v3. I slowed down on it because it depends on
> Optimize anonymous large folio unmapping series [1], which hasn't been
> merged yet.

Hi, I was on vacation, I am going to send the next version of this soon.


> 
> If it helps, I can send v3 sooner, addressing the v2 comments, rebase
> on the current tree, and split into unmap-side and restore-side series
> for easier review.
> 
> [1] https://lore.kernel.org/linux-mm/20260924131106.1730494-1-dev.jain@arm.com/
> 
> Thanks,
> Shivank


