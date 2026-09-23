Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A14FC98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FB86B0088; Wed, 23 Sep 2026 04:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8FC6B008A; Wed, 23 Sep 2026 04:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323D16B009D; Wed, 23 Sep 2026 04:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 07D1C6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:40:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8582A1C342C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:40:02 +0000 (UTC)
X-FDA: 85244379444.14.63B8AFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C45A140002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:40:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwlzpLjm;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790152800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyh/pOgTF7kL8hlZc2xBVOE3tXIRZyVNxNqqITwdaBM=;
	b=M5Dhkdzc0jZMg68XP21oR5MKWfo92/rLrdqRXuCqs9ogMYKYeIOXlsN7pFnT3OGh5a5izx
	TqcV6zRJ583tacOgUnNJOyZqE/BQ48FteEwFNHKTuM+TUPTxZsAMog0hA+VAtrRjUHLl0/
	fXEHEvfUWTyRbsJWBTUEPQSpnyEf4b0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwlzpLjm;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790152800;
	b=Z/ixz3qVeTV5NxVUHck9bMzjyYoyeEkAtl24iVmYMdsx2L6GBR2Y/Mo51JKrWt7ZZGla0w
	NxGK/XbE0LPu3JCSG11cSPH0GCqFqS8EZ02LqKHf/4WQZkktkljOwBh8hWFguNIL6n8mNX
	wfP5DGhAS7rSPbqxkklgmzTtU5MxZOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14DDD600AA;
	Wed, 23 Sep 2026 08:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1AC1F000FF;
	Wed, 23 Sep 2026 08:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152799;
	bh=wyh/pOgTF7kL8hlZc2xBVOE3tXIRZyVNxNqqITwdaBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UwlzpLjmsWYQu2X1w7dPBuGy9erltg3vOL+NfJ/uSQJOrfQZlmrZRX6l6hUG4aJNu
	 TIvi5TPQoCTfXAy0RAoguEf6mQORqWqbFPbBFb1Yvt0SH9n2/Qs2LaLGimCaz+fm2w
	 T8dFUUnNLMdizGKkGqqr2O5bg0+pgzDyYyTE/cTuhGeYVBNIL4mitLsMDxcBI96C2e
	 u//dZhCVEMH4DJvU7iBXv2WG12zQPZ/UyJlyaQK7I64hFTFC7IROS30zAFLt5WULss
	 OSRcfn3e8dbaKrIfZo56huYPUUIc4z0kJ1Fi4Zi8c+ZQhg/H4nld0N6VuWFasb9d7U
	 hnf2wJf5IlUxA==
Message-ID: <b007cd0f-29ef-457a-8e44-63ab26f3bcd0@kernel.org>
Date: Wed, 23 Sep 2026 10:39:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
 <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
 <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
 <aq6kzpK7wPl3iFGe@gremlin> <aq6lW9FvL69QeA9H@gremlin>
 <arOCPN02xB7mykju@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <arOCPN02xB7mykju@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dotwta1ztm4go1jj4twrdd791fa8m9w1
X-Rspamd-Queue-Id: C45A140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790152800-896494
X-HE-Meta: U2FsdGVkX1/Qs+Rs74VS5G+X6Tttag1ZwIdDkNoceycbjFgHKOdNsW3HHXLQ0eNTpzNkShVkE37ROVoui/09LbyV+l5SJ9b/9slV2wAQpxF94E/+6SMoQPMZ7rpbjGkO4TmKzzkEJS0tX7j0qan+Q2Ogn8kiA5exdHSjLXvUdx9sFZaLtxGJ3gmpBh7qpKafEjNsRfbJ2T7fEII82kqr08YYQnNVHpkcPvaYKtndec7RXFQIhz2+G3Fou7EjPuuKClzP1+ycXvWG3fzMmkiXm0yXINUOr0AnQPg2xm/hUlp1bTFtSkyKkB5SmI9s2jgjQFUwuW1Xe3VWT+kjCpgEibIBCoqZx5iHZMgWOzRIk3jdEgdK2QUOEGHTgWasd2PI49EsmBk4MwtA3s3UDpLZF8vC90v5ugUYWKL4SSPPTwH5pklvIT8ueZkR6O8uq4OXklWh5NwALxo+0h/N5i0UiUOBc38W6Zzucqtaz1IGyPKy2wFgJbTI54qEPgXYEs0wcPmj8ZCmPcpbMkCphGa/guRlN3656k2kVbYJdZ/whIl7p7zA/tfBbWEsYtWzahi5gZA63XzwgyD5/5jmiAzOISUwQQIyrNW1Bw/o20MbMmWKRUCUBKYBfo8XKYLAmlCmsLit6BKVxIHgpCE9lfY9vUSdNqsKv1nH+UtU4ehmwaBJPexaQbIE8RvUJAqpz4LVy8jM5mIrp9WkrtIjU84zfLdZcO1s3PjbNbo6IqIH2FNDBbtywPqFlATMlhGyICjXCdA2nHubqA7Ka7ZENgE6VOmPQBcXEo19qIwZ8srucbUjA2Ix3u6RxuC/I9SMKN5RWNOhfgyJA0Kd2JtFDpJ6w/r+wYk2LBDRGt9DI1IfF3gK9AL9XAaThjPYN5coSLOY6YwClhB/Ry9mboZJjotrt8pB3d/iGlmslujHqGoF3HW0l1nhXF3r3Up/hZhcg/bspuiXD7TWzJs36s8O2w3
 KTWsdQ+P
 8KsOdVCjBEfEbLY3PlPhZ0TXztwydaKkyIGKQeYCJ7RErqzv6v34OidYMuPfjldHQSwIgNyTnNtoPfDec8YHjkTn/ObfLJ7HGSZiGLBkaBarnRtXEY6C+wXyANWDP/ECAZevzegdHVUV0Ow+IYNSYpsAa8eAkgpq9lM11/647sQF9M4epSqy/ZQIULo+5v6vTVkQSQoMylI1tbpnQFHKq8Y3AbDlmg31ikbnSQAuxE2eKDIzORCFAYjrsf4aqLqxUaWD8NzTBsDPbSm6k9N2zoRbg4BEm77TWLYOVC5A5p92raBwBTxZQCIqGn6MNMBvXhzV0VsUdyNiaOob7hlPPR8hn/yYgkBqwHvmREQHugA1NJwLO/NTSRA8zMW4r1udln+3XYOCV0zuHNQIvWkDH6WJIQvoeADcZgCFlItmZfUDnS5sj3Ji/r5HfpGpci05S/2Qg1vF0M9KilnmAorL1ug5dfkaEg4RfomPIR+8RCH+Lo+NuziIdb/j14TC2uQ/B9YmtqrU2D+gndxBb+jSxxfyBjzgkhFWm0jJFq9e8G/KcKNDv+u2Fghj4jhscL6CAj3h1I4mEbu9GAVqFEQUkKO+3wVzIjcivMsQ7JpohCTfAi2vdSd3101iZdPK9Yiz387Eo/IgPoegBh8QcXZpt79iXhfQdi8WiDZ4UOPSl9+0lh0UPM8CgBZc5Oia1+CDdsGxQYYEcJHjDDZhPuSXWYWcNVMmPieJzjuKpCnWhWE1D7bshDPsxTLhRJaWESviwOg9pxuy5qntHrdVlZ3jYa6crzxngCYGx5qBiKXFJyudBCB4A2IieowFbPkhO7Yy/kZxu3pIXsM9CFgXQD+O8psf9nL8kRRWK9o7zO1UzrB+PQZej+Smi4/MnH7K5UX+d8J1plQvw88d6usRPJTBu0qJDJ0GSWUd+WEb2UjwPCoc/njHt5VmnBAC7mJHuL+h1D5p3OoPiK3xL8lYPr4tJU/bXxN89
 kK16lEg/
 k1sxgl3snXoXxajicKoiENGhl7X/uClhzduYIz+5J+BkEavpeLFhFQQpWmLfS/lXzM+dQQi2y3prslNT80S9aQRJ7JoxiJ0wYZA+HfxgcaDDa8CyLD8ioVXK15thhr/yLg5y/gTRqrxLOHzk4XtowRTlyrBwmJKPi3qXNYZ97TrYCFRu+kBoK1u3L4JuFCtgIGgFb1PpJbxKgeBOtw/OTupdE+kwX3vbH9Uvujyj4kRjjl1POfKeXRma2aHP4+z5Ws0vmwDY06z2RR73ewfljklV6zdaMwCE8T3CpJ23c9agZJDcW3ZIz+LgcMGWzQKcddNOtJWKQ3XIs/Gx3QXvWiVSpYgXiskUQ2s0oIrBSwOGzFlttiHkZJd7YMKM2B0XZ0NYQu1ZrWDpUwp643o0VVbm3qwQlsuKsjxEtn6aFYYXXmf3/LiZdFWaFznf6xKU+bLxVqHlt9k++A++8LnPj7OGf3xwZCnBAEKK3xLxRk6+1KprLc1PvnntdAWSBOlxDnD+XGnCd9XJyicjWQuhIGfbV5BvhaciFeWD7MG+SeGMwTBOHqZ/3veLHbHvHsrBILE4/IQMsy9aQx8p6+tgWSy9eE0WoaBMQjnWwAeFjr+rZCRqtp7SfYJkgzzqtfo4YdapJyEmiPEyKWbG43nf0ccHSRJTjEfi6THSOOvWE1QybBlYPB9v7uFr5syI7nkkmP7cPBvTH56gbpLgoirapEuhTtsTrMa8mG+IVhr6n56p1vMoWBKg3hfboa5w8avCq5XAcLM5yP4MXwh+5k7H/mLRN60Q9pWkR6jcdYGDpZ71kBRFnQT+Z8E5Imh4jnkC2eWQxe2CUWyMVpzT+sXhV+WSbkSqV7M43Fn7pGzyXDMYXvvorkzEIjz1oAQ+f5Kfg737I/E9UeH+2oh9NEnzgL+pclIJTdK/+Dh4HsBEfhDswWlWWRoRgXjP5viABYyn5ASPMh4PmSQAxHkK9mW9NrWvZNBku
 k1W1PKDd
 fZ3e0nScG05fHV3bl37MsDoiKe08xBx+t2zwOrSDjq+eRyCotBitIDRmPPjHrLATVad5Q2l1m26qhj8cEii745F7x3EpGSDed9z6ydk8YvsV7tSRxcZu+l6AtYw4Sw/HVQfmo2+GVp70KacO7qs7nQo4qGxh5Mc24r0kP7ZJ4RajTDq2KfRKGdIUKw+uOY/5VID0bs7I51xBdrxfcOV0OCs7gudI/riWnHrkJl0wvoeZdLo2tfdXtM/lSPkoAmXVJiqhCIxNCjdbSQYAnAeb+3qUxtrNtoWAnqK4ErO9GrvbJ6wQifsPjrn3oES5SXo7lM402VNtKmUy9H+dHKBhHXOePYZjHG4wgEoBkV1AfKx5IRGcmokdP0op1yfVmCSdRUKO0aSfCaLG5eHleNx/rI2NelS8CfROCGffGGOzcmOblXmUbC2vCUXHQ5TecScBaTpWq7TdV1a2fc/Y46mM0GJbN+d4Afif1HhSe9CQz4m+15E3NhwYcudtb+QIPhnm0nyqrEXQ+gPQTpFhuyY9tHoLnY/6xdc55npg5LiyYXmWrle7Isc52Tlf4xUticHKKX06PMKqpSWIPBByH2M8P+zePi5T2yxMxoKg4Ge9wlhEcPyb2lebK1F2ipaf5wRKh1iUvG2ULO+cvmazXOy19N4Zoihk9Uatw6YV/LdW2MtCYpIJLIbgnEdVgUZGCaJpsNVGk+h5oEMoCXxwd9JY1wl5JhlrU/LXE2kJETmLEawU9mndoQl8Np2WYcLJS1HDZIc68BhpOl1at6mmsEN6YbhAOBHSzppZYidDBOTb8zPJ+PnlLn8qz/VX5dGcMrQH63psWObn1jAmyU+HueIOjZimuUxfWobG924uO+R/FfD9uv7hj1l1My+2sPkR+fpCniIj2ZOXyallblrhGhqaxc42HqjxBn2y/VaC684RU15/9m9+yC0SCbJ903unqcxo1P5eCGTHQM0+ohu+10/iCdotILFi8
 fjzko0HV
 PK8mHhIKVaM0tufYeD5EqutAmB8myYy5jC6G/vLyJOn4LZapvz9CTiGNXQmfjvfdOCq8sJHY/b/HyOfDIvlbb6fWktCz/hNp5OH3U9MDo7mIZS65EnFKqT+aqLgh+PAC4QN3+WGR57b+W7HyZ9S9CMOeaCyAOD793ihQjxsI2s7fzaSHG+2Y8lHjZvpXggvH7UOadjrQ8fZCQ6FfID7Stfs60/oM6lBsgggFZmTC15gbr3b29gbX8LnPoezxGwlV3DDmTv1CZAmPH3N652KMDoRreTn377wThM5cRXOLoi8nTAfqUq789Cct1ejlQEUj7Acu71GSlfeOLkeekoSYCaZKueTnJMVkWHfbWD5eMNRTJ7xzNQnZer
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 10:13, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 19, 2026 at 04:09:13PM +0100, Lorenzo Stoakes (ARM) wrote:
>> On Sat, Sep 19, 2026 at 04:05:57PM +0100, Lorenzo Stoakes (ARM) wrote:
>>>
>>> Thanks guys!
>>
>> Note v3 has been posted to fix a stupid bug in 1/40 + attack some very trivial
>> sashiko stuff
>>
>> https://lore.kernel.org/linux-mm/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org/
> 
> Just a gentle nudge on this :)
> 
> If you guys or anybody else has some time it'd be appreciated! (obv. the v3 as
> linked above not this v2!)
> 
> I know the series seems intimidating but most of the commits are very small and
> it's been in -next for a while.

Busy with too many other things sorry. Its time will come.

-- 
Cheers,

David

