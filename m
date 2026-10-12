Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04277CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9C06B00A4; Mon, 12 Oct 2026 15:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190F66B00A5; Mon, 12 Oct 2026 15:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0806F6B00A6; Mon, 12 Oct 2026 15:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBD8D6B00A4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:03:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 572641C4323
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:03:09 +0000 (UTC)
X-FDA: 85314896898.07.26E05F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8DA4718000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:03:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DUm9Ty/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbrMyFcruWOTM+TqqDWVtyxT/BNfE3irP0AGLXWSXYg=;
	b=HiQWjcDKOEZ4Ng1QXAka9yH5tdy0ittvyn5kb2ACHaXh/ueH4xkSxEPpf/vCB728sfxb8q
	0b9RFWUXvdNlDUCFA2q2YZTEf/jR34H2Rf0Qskxm6hJICLGvngHcLF9EQj4Cl0m9Eofw9i
	KTdS4mfsmix3ovFUiekjzEk82SoP15M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DUm9Ty/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831787;
	b=FphmGXnBOw+XoIm60/pd/fTWWDXA+eULgFsTOn2Nl0j/qq09sp7mGYjFdJSlicq7vi3hf6
	evC2sEEXCULWIOExwahweurY+GbSaNJ9wSomU48ON+NX7Y4YrFKydXkUK50kEuY02E8bOU
	ZOnAmZhKVCq/lRn0nd9IFQefE75Juso=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9424B6025A;
	Mon, 12 Oct 2026 19:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199741F008A1;
	Mon, 12 Oct 2026 19:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831786;
	bh=YbrMyFcruWOTM+TqqDWVtyxT/BNfE3irP0AGLXWSXYg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DUm9Ty/VUzwXUZU2iWOBG0PWpzBsOed1tnLF+/LOuCHN3/s6gMtIOhLJtOqm/91sp
	 dY0OwRAm2s77MVjKQ7l2hzjHQupErFyw+kdb96/e8gs9lZxaHfaPeKPn3KaNQKeT7a
	 E0YuIvlJE7wfEHSq50BIwKUvzlVN5TWWwYcOlMqhFcDXw2sdyBLtn4UQ8ZJaKfpytN
	 39H48+0qpm/uqCYyI6eWJLVYKVTU/c/g6GJbb4GlhubyJK/XD5eHxcyeIU8WgFVu7N
	 yyMeEXcS1IZA6/PewcvaXh0ZbcCVaaJhrnn00jkCqyx6nX8JwiysCFZ7gSGQ02X75I
	 INnXtZR7TiYLw==
Message-ID: <bad662fb-718e-4c48-aac3-37b01de165dd@kernel.org>
Date: Mon, 12 Oct 2026 21:02:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/38] mm: add mmap action for discontiguous kernel
 page mapping
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>,
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-7-923b70125b1e@kernel.org>
 <56cc2787-134b-48f0-a9e2-840f57b28607@kernel.org> <as0S-4wDLCJGEItq@gremlin>
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
In-Reply-To: <as0S-4wDLCJGEItq@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DA4718000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 4t77dw1cizbeeixuek93mu5dgqp53q5y
X-HE-Tag: 1791831787-979949
X-HE-Meta: U2FsdGVkX19K9KV+tRZGzXaSgTFfFij+jGsz/Eq73LTGPY590+W5SirdSIfQJzLHe5Aq3yfSTdZo1FbCspXXgXOYRGNzU9RBT2VFdaHbV4s9vUZ4IMOiGCNvp0f6djAXx0SSi66BNVIH599MHBU4Q7kFT9hYkwZ40oijqaaPu3/YizIYDZRXhPoVhmEuIJCndhA6sDHNBXbZw1db/Qb2KCBa+1YAbuKzpDFARgEF687Y5nhvIWjirotT/oaruZofPOr0LL0Mhhc9+0eIRNG1KCZ6BgXqCuk45c4wxVxTSt7pHxwzhMIuU706o6W/q99srS1fLaQEtJ6ITSXtnnFjnIfzXOte8EYx4NjwjkJeB6rSuT4NUjuBnUwYz/vIZMLnj45TZj65Y7+tGSEVVXwJruu+7BgCktqnQsIiZJX/YOF1l06gshroWHH9EK+2wC6h507Os5z61i5bxlAXzrnYxOYcBHgoj75T3vW/xBcZ3pzl7YcRMSgFDmiq9WEksNx5Ob3OgqZT3HD/DEGMz3EOi7p++WVEDfu7cyvl9vzETbTFfLCT7+aiW3Hb7ym23LrejJ/2pXcstJOcPXvBIKJCDe5+lIcHvBpgDjPZ0KwHiZQ9PxrmKzUP8AqZ2T+uV5BQdnR01x6uNU//NsFdtK7CjgCeRJDRHZDWumyw25DVT37D6vmpyRokeqOcwrDzvFCTYcwhxcNz/kGv1yMo37qXnXTp3nJRR1/m2Z7flfsk7MZlIJik2SY7jw/T4Ds9PWJsKF5RaO2YevuAimCl9NsOCPDj8JsdekS2qku7a5S7buPz15ur4NpQMSbUhyaCD8ol9t+Iv+tobNgNzKrsNyivgZwdhh0PItgttN1OT3Wrj8jhEZD7x9xRJxF1ffLgO5u6io2+54e0ojmhveqR1EQZkUs5ddZIsZCSO0CvSVDrL/NUnURWSvuTsQbQ+kj2K1uFOHlfRCCVikNlb7t7Tsf
 bGGjgipi
 okmpFF/rAE9fj7yKMGIuAjE24AoXZ9kYwDHXbce22bt5W8NES+YPZfIDD/R4pQ8xwhZm/YHAwsTv9BMD+Dpdpyd+Z11eAT1Uz1QPPUFP9BZFPX0fUd2mCnDlVB/qIoYaJHXQqWQm96qnhgZ3oxH/5VT2gCmqLRTM6VvUVMwiH+pvODKjvIK5h3Ed0eUirVDnboQUswlfhMuxkbB3Uaek9H3r6Ed9Fci+lbYV2hjUIAVi8Gqqogh0JSxd24u4y15sN3L+O/QEbAOdDkXfxT4jOkL13LWOditj4aei2XvPRV9Cyu3S203jFgmrdY+C5fYDEga+R17XWO5heyS6WpDkQ481rPUUB+sAia8eZoXgaQdHmAyc6B5du6MXnJiCYa4wxjDS1DQRlgLzGqi8Ktp21/4bnbENnGFeyxBtiDu+/eor4mrIT6itzPtE5spe4XwzGzrPSSCQ1vyeWk8T/20ihpv1QENbr2w6oxPf9Bni4uJXEwkXcsKebNVeS/nTUNjO0nt6YLs/NXl85eT5JVEqJJyBycnOY2/XwfcvpA5wdL7aWsjPqt3j44IhvWGu6ZCLgE01tQ3BC3MW/OyTbEbXmkWG9t6+6kMFws7IjYxWkAcc4V/TxoNVLeOr1wZyoQeaqEQUnc1fSdlTPQPx/Q5wD40UcMZF2Swl6WDShCWCmMOcjJMaab3xuVv86olqIGGWtjPOo7NXl/o08hvqyfobbvJEJQgppS0s2QJBPoGBj2FNtY8frevygcGY1QOSrMBSjfBS8xkC+OnusHmGp5yQOLYKC/NSVXf3YL9x5S6xMRbFTDzLpsgKzcEHp0LTmkXwgUzbXuF9fY8inaBFlCqd5gqVnpHMZhswAxuejZW2VxhLxznW0xFvjAmcbNkdQmPEM/aSNXf6FXbua5SSI8FuJPOhpchoH2e4+Bv1018n9C0tHmVcBB8OTQDD7e3LSX9p76OH1ncFf4GQ2G9on9ttCR0SKPO5Z
 Z4LFqtpF
 Hw6rO9tputamNze02ehO+xdeoptU+LUiHVdkvOMGfsa2l56NaWJ+lJkICcJVgxXqEj07aSPp2SdlxYxscobqCOD2PfxhKgWtvfj5CZIAj7XzWRSiLcYa1wGBs2tv3PWc8v/WjFPVIGdLY7ucw0AsSDsM999OcFvP1IVhmWhrA9kjJm7uhUMLKKtE3t+56ihNhgJL3OW++/aszpx6a6WI60US3dnQHmHKBMPLVQYHDLqJ0AGBl0OgOdLsmBp7QOYG3VpWcMXX+QMt1RUQfzz9bDCwNCqdyd0o8w5jdnir2mxgJkKnC/+7Y/qvhItPIhZMoThp7Lc9/KPZ455Tc+w1wLt0mufZgRHTDfur1/jutj/XdmmyEUiuwKAviAI0Z1fXck32bBsllzKl/mBL7B4E2tx28gVChzjmzlWT556KzDiE1LwgJASQ1MbrdidbueCdbO8cPo7OnOGRY7bqTCZ1NDXSSny1e9rhd/zbwTC173mt8TAAZeWvtee7IiyVSip7/gG3O/CumEnQozCDRBA1QCLlWxqsLp5uukAwJ+bs1MflEwCHgQgOgqJvAOXd2bMMEzBhAH67cozNX27RE+IryZDR3P4+Qnvd9cmruyB9NhozRyHX0cdwEN1vpzHyURwJLEGncTvktXorYnIsjSnp4bOlMHeqqi6a/shVo6ATle+8tZR26BbV0iBm8o3YmDifk9h8NSv270PPRZp0c/SwQLbd7efAasJBcFl1c5ImY6xsMnQrZyA3mEQaizimEnaPF89DMQRyEmGVmyu5+T1rAJFWOalv0bTW8geD3ipdL6DGU5yXKRXY5BHDtO3/eYOmRQFyd9HupQhChQe0qVAinWcWR2+AwwG6NEXFAXhHWgR8hs07OnbBWN+29hlN4oW1BbWJGIfXIr2raKfVjABTpLH2qNBsGtxYFwjbsW0/bRWTKaI78MAak6pFr39k2Tnut3zN5sGwkDIbCu05uDz7MYtQUKfeS
 tKxiLtxs
 4I5lFDGLKFVdeH+InEKzxnKJtlehyxTr0LG2kFyNYSkjCDUegdQNEd1+brJJEj/i99fptcz+3jrvjvIoJU48RtK8QS/v9tMrpCtveiMbP8bt/bdzZ3pYlu6NJ3KLiHWrbaDXxXHmS9lIFG+vB+uoCr1B7uf+D+L90oqgSVuwQ8Mi02nWPs3h4wocYyCMS/VDEFXKlTQloWMwEYJP6OrhzPlzO/57CvdivX7eKWVUrotFlzQT+7FZwb6e9iAj3JkrqyhmzFRYo0LMZHp6ix0jBh+y2Z+tOwCQIEtDjYGdyIOAVUmZVoYwbz2A+Uq71e7f8x6iOr5DOmNc4Bm+aZMvXO880i7R9p9TthBxnSSRdQ5NQHe5WhC2wrGOSFSjjL8/P3/Ep8mvDxmMp5QiQpirG9AgfcNhd49vpr4+tLbCpkWLTBDB4WdBKdond8I5SoDDoGVc/7hwY17bMGq+qo606cwCQaw3XYBy2BDXPDG5RxNXhEkQfEetY1avf4Dj/5psbnMHTnxZdrtp1soh01Xl8B3MWA3Qe613i+ohLgs0dF63cgGPV36mPmhNEhxtQLA/ZO0G0/ZeVBd0h5Ms2iD+s6xLLok/tCjeHBP3gwPzVRPJzEkBZxgrW+G6Tl3x3EPoDvjm4NA/ynYUeiAYInO4/CrwgkUFft3DkrIoWtU8LuEm4eiiUhYhWlDECg9wbTjH1xuGpKzOSV9aHu8IXX5oWMY7r4BtLzHOztDwU7+v2zSJYSolA9envph1uz5Dau8dpJpLn0nm0hxnNdygoKHDDPw8WgXeBf+Ty65UX7AZZNovu7+O5ozxtGZbDCKusYwFdrk3QDFPq5BFU1cpfHHgJohntUPK9PJ7lnCtP6U/iMNZkcGeL/XUWQfHbjqe83vS4iWLEzhUEbFO0LvwriLPu2VEPcI8jG61tjDPKI40LBZcDg0KOagX5sJdCyzN8UBQOaHn93uitcE6idEea83L6qeusBFgx
 6OWwBVUx
 Tnq0fJQohr3rmh1SnxyutDcHKA5xtGDAPTGxaYPU3WNBNnDv8ty/Ik2myCplandQIW8/SfTBh951VoULMqOEMkjXHz72BkRr7vxfM9reBnl87AMRQBSHQvIrnD23uf8hUWxOgi9GDOVbY15oVdotmNiM7BQNRWMlru+2igw6uRFL8AZ4v4WjUeP6xkW7zYNi7ck7D9lYZ7lMt9n6A+bNQxIxmmZ+urxh3FEpfSiBf2ccKCQwHySXe62qXDvAmRzLojeIUZUpmdBGMk2OGufKQapg4vOQL/Ss3nT1y+a5kQYnJ79DsEqnhx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Finally finding time to go over this. In the future I want to have more time to
>> review such massive series, as it causes severe stress to be forced to review
>> this last minute before it goes upstream.
>>
>> So if I push back in order to give me some more room to breathe in the future
>> it's nothing personal, I just have to keep my sanity somehow.
>>
>> I hate being forced to review because we pick up stuff way to early. There is
>> just way too much other stuff going on.
>>
>> I'm planning on picking up most stuff I maintain in the next cycle. For
>> cross-component stuff (esp. VMA) I expect Andrew to pick stuff up until we
>> tackle this once cycle later.
> 
> OK I understand, sorry for sending such a large series.

Just to be clear, this is not your fault.

> 
> I already delayed it from last cycle and sent early in rc2, but I understand
> there's been a lot of volume in this one.
> 
> I've been working evenings and weekends myself to keep up with review (and
> failing), so I get how thankless it can be (LPC was also unhelpfully timed!)
> 
> I will try to split things out more in future, this had a lot of dependencies so
> it wasn't clear that made sense + wouldn't just cause more stress over a longer
> period otherwise.

I think it's really the people that do all of the review+maintanance work that
should decide *when* something is ready.

Some stuff simply takes longer than a cycle. If it's due to conferences,
bugreport/fixes, high volume of others things, (transition work) or anything
else (personal etc.).

And that's ok.

There is barely a difference between squeezing something into this release vs.
queuing it early in the next release.

Well, there is a difference: making David's head shoot steam out of both ears.

I'm hoping the merge window will actually give us time to do exactly that: focus
on the things that didn't make it in time and just finish them.

That's what I'll be doing with Usamas patches and some of Riks stuff next.

[...]

> 
> I will split it out into another patch.

Thanks!

-- 
Cheers,

David

