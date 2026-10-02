Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C669CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9476B008C; Fri,  2 Oct 2026 03:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9FD6B0098; Fri,  2 Oct 2026 03:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571006B0099; Fri,  2 Oct 2026 03:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 326AD6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:00:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE6451A0629
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:00:33 +0000 (UTC)
X-FDA: 85276787946.23.E52DD6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED56BC000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:00:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LB5MfZ8g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtNwuh51450zgPbNP+lOvAlJrZTcY2sBjh4xMuP21vw=;
	b=bangC4/qm5lRniLALpRwA8Kk9NAP9K4RFQOtAq9Bcvbgae/x22duyY95yEiShxHxEa2ydT
	jcTl3KRledGSRK9AfmcdwmxF3GNgusCZUYRukO4ScgY6e3BHgQdnZmzdhP5GLbtMNuuw0y
	kWfbO0qw4P9DW8TapMyccabyw2VL1Tk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LB5MfZ8g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924432;
	b=e80kGghpuQeDFeI0FlMg8m8INUNzqzxp20r2qRak7G++mujeCz2rxLhHkow+0NuwAendZO
	tN2fWveAIcyzWqdD1jqnyBoduVr0IVlRMNNMBjEXMmkKU270notCR77ESbrvRIRx/LFmtj
	yDJmqGcrOa2m3F/hviA2ril5I2N7SBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A658439B9;
	Fri,  2 Oct 2026 07:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2A71F000FF;
	Fri,  2 Oct 2026 06:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924431;
	bh=gtNwuh51450zgPbNP+lOvAlJrZTcY2sBjh4xMuP21vw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LB5MfZ8gwUz7jV3rjOoWGsbV2OJ22b98eGq9HqzFXlfodFfw693NurnE4J5S0k8P5
	 9nvK1wFEP93FYpZ8Yrj+krBwOqTFfYI1uKjaBg7BblFGnLZJFGRCr0WKYuvF1lK/OX
	 fdJdifTIwBtx5p5k5sN0Ma5IUJRPVpzBN6OjbuqHx0SsF3wmNLZBsxiOC6RcXe6U7V
	 +Gp+TyyAbL3cPzuVxrbYnUm51uQmq0MVWARIEWZcaZLfWNyfIJo9PNR52KgaYkcjhB
	 r2lVWQEmwik9HSiRcDRw+PK7PeWXgZqErv0EBPEud/ZTYmuWPlP+0oumFqa5u3J36B
	 KTvwpey+7Wvbw==
Message-ID: <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
Date: Fri, 2 Oct 2026 08:59:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
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
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ps7cjzgorw86phxhx5wga9y7uhowhmrn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED56BC000B
X-HE-Tag: 1790924431-32832
X-HE-Meta: U2FsdGVkX1/ZOK51AoQPzhFLO2ADQ5F1xDQak5xUUOsLnCUimVTGR6qy/Ac9n4fJE/mIMIBtjEKxM32Ev2YXJuHWOtx95ERWLIwWL6LlAVgevJiqz9IzITTOnuWjOwLid9O4M0yytWjyCNazVWnq0m87b26F4QlT15tlQ03MKoOLav4xXV6TlksOj1+Or1SsH96mKH3ZsPu2MOd7efwX78wCu2x1IjeyrXcDxuuLL2Azufuqsmw+U+2tsHxpCfjFBm2paR05Hf40rKJu6FKqZ44JUyqJkgFhibRR/WGKRuQXnCdKiN6eXBsF3PNBGZPuKJcNmLZGMILeoAQdmFc4uPNTT2VEMDtIG3csm1Uq+M9VGboskH+hygKTSh/lvWrwZTpz3hGjp1KIeAEW3b9GnPusZmwbUKF6YfXdRj7lS6gFnvP+M07gFF6RAF61Ps186x3j/rkMsF+QvveAizRPxAmhM1XBRlhODxKS4mXuV6rJd7yUolEN2sbaVakLd43xvJ+cCzHEiMz6z44AdmlmOm7FgXGMi6D6cHNWCZg+9W5IpGGUv/dx00YWQoE3Jw4o6gIk7Pt1K5g9oYT0T4CWPtLHt+yFUozHsBhl3ReOzx1sjgOP9gEU2z3PWrvmLVAKPC4VJu3XhUY42lkqik86YCLCwUru5wWxCgc9QJqi0GShrC1Yn+JDrr2fSyk2tZdGnH9KKQj44hvXigiM4KPUJFSsGdYxHdJ73IMS+9hCLVzcMBXR80p3H8E1BMVOYAvqnM1C9yUhgnO40LM6QGAo4vFnD2Cqu1f99eXwZG+n4b3amOaPwaSHVGtUl7SREyA46WE0mQj5m1+D8+3PEjOL/3GsQ1m94Tbi05A7B7DJadJffkHlhGmU8d32hmlIRRR0odW1Pqdvt0nM6sivDjJnqo9X49D8GPW6PzRowiwP2Kzd2khQAzu7MaoVANAypWjh4zjPh/RraazrKjhiwL2
 s5PRa3id
 HGYggr4jcqx2OfNsIo96p/LWr9pNqdFmYX4TfYxLmmisdCBeYtxp+cJsNXpPZVpaqbkVhggYluJccwiAuJMd+v2Gw9i0ehH59IrQ+8ITnxDuXX2XKVw0JJSDOvbGHX34iogdgDIMxrtHrBQoVlRb6uqyxnC+fSK1MM/aaosAGa/NyqOEzZOMqIuVwEPMe+r0ylOiu1r674l7mTsiCmqVJDOpt5yCiRXmdby1GT0y7Rv4Iy/JCj+78ElLoDO/kO3NU0H2VyW4HM0BG7L9Nl8qsctzZoFCDZSL2xBgLnI0mYu6dIM3ttozk3tH9QaA0E3begWrCDYvVq73qkju+R4M4/xHSOk41C7mM4FlEFRybSbSEmebhy0/yTgZ8VzYXdCMZtSOUd9BZHd5jDqXkFSVPr+gDdEDGLM6gMkFPvdjhB3k7iNT/oihi0uig3lu1QzcS8ApZw9y6dHDOhGXn8rEIoM/tmCo40nveFlBIe1N+JL3ClCmIeIVtqJytPsbAc7+zB4p3Fcfb+oe9D6I+Xczk4PfMnxW2WmY5zWV/0aodTRrE3/FNMVV3zvZkGSeprR+TI10XN1hw6w1ZljjX/DdWkPLBetRZh4dmOhKeb/Xbh/aCsAt4rdCMDa7cIdVGXVsLFDykFELbPFCe19YxURzBrgDZZx1MG7GZr7KHLeJPtqGXFA6wGy3DV1sn/T1F0bklZn9IrX74XWQoDuJZenl7XX9XQB/xVfAU4HvGlP8EZnI/A5dxC2ADHDNoVdt2knw6ak1zhqyrvvQEyuaPy/hcQ1Uzq1DWtY2tB4rE7FEaKOfkrWGg5dTeawKM9WdINMU23QVeGhGyyxmCI5hxdaY7Cena03zS4XnI1TW1sjxfRM8lvcCqjOUKbbcdEPMmOzXigSKOMGK/qs3v2grQljJFvaxb5CrZuVcVn7Y/d1vv9PeyjGMP7SviavhAi07t0LGAHQJrV0ImZZmQ0sLt/DFhtCTCB0wL
 R7mjUrqc
 dtpCG/Ih5NhjPOQu29gSPRYgvNpYIYidGmRPljfoUbHrv2csNOgg+NrO/gSjgWgCm6A3sx1q4BttOyU9UTASiLImbPR3rZxGpyvQDBCIL/KFvKdW7RY35rnh0+8qj6V/dlgkP2aBAAZo/FCoji7Bb4Yt1Kl+4ZIwPMFFYJdTfBGpTMqO3AjV1WLJ7noHlA9kNi1lyXGqZgfqOfCxstmRD/rRDY9TdGpVjkm8NEhMDGb15IJl9p+JEE2nDhEWtmu9TF7tFFwh2CP6AqelPIgfABT9K+7x9+dm/u3siOZL91kTmoFusVwoSFNFX9uEpUctju5G358VQp77CXyTYALMpHMTWGXh8VU9/vAVoGIgr4eoL6r3DpOOkiTrWeu79c82WWnIUyvLK5VCHPOoMCTtF42r36BZqHGbcj6QwcxGmAqw1mkRIDlNn/LBQ9hhxLPOVkhks0Htw9uF0Pg1aZqNeMug1fxkxYfq13zvb+ZgCcxuZdtgHSBJpOq66zRctyVMYqNS9ZnokP04hM7ExZ3eogwvNGP6rUIEVZ90y7mrtzREmUSmQLCzkJMSNGuDvQzbLlPeHf9BnXammbPOs9PVl/rjUYYJ4f8Wrr8UNIZMqIDugqM1vQrkUJByFlerNri3xdLcMILp/fePN60Gz6Ikv3jt6tZapkUVZzPKAz82+IvBH9GlEs9nxQs0y3K6+b8+1H3OJqLZhfOsve6wiso+5p0oYFceuJ3Mp+1zE/61v+hYnTybUe4rS7LEHPy6l901HtVLiF6GLXZQt5ECj0EsJVsQmlxR8DQFsuJ2xGzl7y4q6FDG8sVMcsX3PwHSfAbc43vTCkgFc7egd12vMQE0SzRYJQGN22RL9+7av+n3AgdJwS1peGPRkWhCQfb0b8qIh97lo1koDLVgb5uxX4TdnsUL6WbyRvvXuItg9mt3N5cKvVZb2GyDfltt7Tystelc0TmeXGeurCnKPHdLAT9ancF60jfmh
 fNxVS2fC
 thomhye27+W56d7znXmLevExOFHAiyuXVwPHvhNdvxXyYXlCgmA7BzJKwqJntDOPNNe5wdZv3g09aa/vjDgSdo5rluwQKTsCBXWumhkAque/CEFn2UtaGsJuv93UIsOKpB9FY7qNwrGZ3NuMOb76py7Nil4NBqQryFcEY/pZn2ZVeLrXsWfp+kPccFwtzjc7hXoJNbgKjbsU0t7v4V3jy5nOUQ6aeGNL6e55toLccs2i6K+BB3lkzS6Gb0CG1l0mbhHuxO1EnIVhlH8W8iY61C4mE07Sb0pecYD5U1bGpBuzveAIp3Yf0+PoDMNMUFc0NKQ+GK1J/HhsDe7v7yWovosxL+u8f84Z9P1TdtuZ9EJEIUuKpCnzzo/OxmoaFpvywVm4ivTHTUTBsMkaKvaCXDYD/YAYlJaKjb/MqBTPQ0wdFdZ+UAPHnHZDspRDLHtaqKRAlr1CjnAoEzEPaNTj04kwEqPE6AwB29BGlvsd9RGEtRuPw+2rh6EPy60PDTx3ebrGtfg1Z8JbkBJLRTaWSff4P7EO2kot6Uw51KfrwgIdu6GlqR1GZvvOsv33x25WV4N/1UAqLlVwulwQCcK7tUEL92Q6qZEA28PU6vEc87ZKIe65ZliJRJ1ZzTw5yc1V+ZpfxsgESu0g208daJBMV5yvtS7995Cty2E3EntXt8A8o+LgMUZzEZSrFvnrMeK7+dcgPizsUwaSu/jor3ZUBE7mH/la62wZ8nEVkLra1xeAGHbT68GrNGnsfoK76Lk9ylP/M1YV2XSn0TV5S61/hTqEU39kYm7PK+QGLx3Jjf70L+O2j8FeiCI1IynZxj27QqD/IZrasgpMl/BNIHBSu847KlIGnflOAZKm7NSgGohqY4VOlFfX27GYvGl3o3n0xzDZOquFPsGt+mgKDHDIonRzp8P0NrPcC0cvWn905WaaG0kYmpwc3GxlBI97e3+PeaCT3wIuCf5Ixy4j/7oqnswE21/S4
 wOlUIw7I
 vKE+5+5OriyiJK0d7f9loPuLI6lciW92V9+8KIAK60BgcZz3HE3iODlh3TxvU7bYGUjs57ugtQakA62mMxVs5SyFXnjtYiuZ74ps67Z9170CvYWjFj+CYVcYSy0EoKohvqEGtoXb6locVP8ZdiMy0glbvaiwOY/aN4iD1QwO8M2K9lMHwMX4gXjOgbHYOaphcu0WUDPcJwezLsrMNrg4fsKN8mO5TmnXaFaAkVwMO/Xp3ssh4rV7xd5JdKVClqteMuYY/yi5+XJxl+Hn7GvyY4T7Mf9olSZO92LJsj2rg6ndUP2xWKCQqIhwFYZBGwAzPXTGrfecP+9Dq8nmd+9aFYZ4tboTQa8BGvD5updVWVLIgpnCp35l09
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> Introduce vma[_flags]_is_persistent() for the purposes of identifying
> mappings that are persistent in the sense that bytes to the mapping stay
> there, and bytes read from the mapping are the same unless changed by
> actions taken by userland.

That's extremely confusing, sorry. We have to find a better name for that.

Is this really all about user pages (pagecache, anon) that we would find through
the rmap?

-- 
Cheers,

David

