Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9537FCC6B1D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA9F6B00BB; Tue, 13 Oct 2026 11:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AC56B00BE; Tue, 13 Oct 2026 11:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923F16B00C0; Tue, 13 Oct 2026 11:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5216B00BB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:24:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BB6180C9B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:24:38 +0000 (UTC)
X-FDA: 85317975036.10.1633EBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4B77B140007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:24:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=frqVEp7l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ts5FqIBv2fWYs7Xe01nn0l1b/khkxTyGv6WJ8ChJMkQ=;
	b=zgCptjb3PkVOdYMAFGULOwRKY1KR3h9gM5CPesQbfgpn5amyvOxMPTnbJ90jPmDT/8b22j
	NAu7//2/vWVv0D9gpeoMVbQ6ZWPDLKFUeJrBi3nliwZGeLOtupjix31d/lZcZHzaDO389f
	vxtzJRrHx8bZgrHpLWxrh6eCM7YhpUE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=frqVEp7l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905076;
	b=SJqTay11rcxY3XMOY3r6j4RWoV8smngIoFLzk9bw863bH/6uK6PVCF/ZePrNsBFofL15Im
	4s22Fg9tRJNFLOK62/5Ec2ZRIFfTZF7xaxhkEEKpxMWhso0IM3eJ3mrLAh8J3Xp9/ZFItP
	KOyLYTgMF+NIPEZ5e7sPcI8OugksNMg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86CBF42D8C;
	Tue, 13 Oct 2026 15:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0261F00893;
	Tue, 13 Oct 2026 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905075;
	bh=ts5FqIBv2fWYs7Xe01nn0l1b/khkxTyGv6WJ8ChJMkQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=frqVEp7l8FM6W+8Dcyt6OaOlfy1/61o2FwoIu+tE+sCQS7ApPnpZVfcEjqwyG10pS
	 2yJ66rzsXeBSJ3aNehuTRuadNU36nKkye4Y95CxpodAE5FIEdBZE70Wnk0FHDNltXS
	 oUg35rUjVOYIXcN+oSGaQJoGdIcu9/YirfjboOfM6Hqu3d8wHixBBrmHswsXrfvYHM
	 1VopEMJi1Orq35BbsmGYxyzh4z7Iao71qsAblpACMusbAylnHb/kkCDXAy0lQaLzSl
	 deK8lvKWH5lGesNvD5IrDGaOnyec1OCF4+Hyri//uBAmksAXs9nKW1cjeR70iVdvar
	 GEIN8zS57k93A==
Message-ID: <2d301625-ba76-4b3f-8a24-d66f0e56bfef@kernel.org>
Date: Tue, 13 Oct 2026 17:24:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/39] mm: add mmap action for discontiguous kernel
 page mapping
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-8-1aa3c9b139f9@kernel.org>
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
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-8-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g7taagcs44pxppequpjx1s3p5if6xseh
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B77B140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791905076-526719
X-HE-Meta: U2FsdGVkX1/9NN1qm8R9l5ixyg29NG5RDHggAUtOBk1/oxxe4gfeW8xvRvGpr8eqbGbzGkQN26WDgqOzW4IT7vWJqXCZb3uHXEX/5pX8ZBbVbS/rorAemPNvhtgjtp3Ue3WzNi3BhhuOma7FokQ52FiWsfQUY8j9o3KA30+eIRC9QgPHjUTkoDjtVGSHnoPSV0BK8mEYm0B7AiSxDEiK3Z3TU9FJ6npAP+sxNsdvdOzllLwHEhE20PAPtUV8VwAPufZFr+8vRED7mKW7i8m9QOiuOkMXUjjsC4nkgoShH7XSeg4nlM5jebwn6PrpIq1bER/wZ8SHdS9L90BBPuVVJyH6qDMRxSiDv0/pq9w54aaWicEXUaOaFgcJgtamoUtTJ3U+iXK64ExgSSjAh/pd6fD63pWmN9EkYjaRqkVLAdmoDE/6diFreQNknC6FlbuqBdUL4OTc95Rv+eMgfHN5SPNofOLv4ImdqnXsQG2ir0saoxGE5flIEbrsB5RBxygOX9GrPbrO1IcfbaMBY2vBMtAjPCekkgCd3QyGWHCrD/nmxf6AD6HZVYP3E64IH533RLiStO4OQ67kKkr7grmYwjc9Dm8bK7RJsVoU8IzJJUrzuiQ6B1GGyBx87MnjjMcb6f9wRRTz4a/GUStAa6EeVxZT3jinh9JonPRxp3uormx+7tuM3H+SYYLheEYZSl6g3zDBkf+uwRtYE2+b9DuCVLdnTR7EcYMYkQf3OdArd2nSD1b/jcZuFLtcsYktA0TxlM+H1nkQVjkPgJodqTwGQ9EyJbM/vCKpZSYpKF4iPb/6+kPn88zHqqcDEhp7US0tdSlrdOWtwj2gakFgsBva3k1BWGY/AwK6xaE2PMbFirxi7etZezWsRYWlr4KV4NhXc+F6QvIIhvwXX/DVBxRuBRzy/ZPHMwf5jnO6juj4fpWrvyveYBKwiudjvODUFY8Uz9wxPjclwtQent+tWcu
 k0Q1hk4t
 ONcJEB/0HV8SrP5kof8D377TiXYM6Nc2x+GckCfNACBHtpZbURDjRlwld29VEI7ThJi4dWPiZizYyHPExES8kgUmwziRAowyFFCpH+s0Be1cNq7DFx7c1BB8kZEzonPIn6fWCO5lfXdVNLu1+KaNmAhjOc0NHv3s3BHpCtGD011iV2J87uvw3cNMLP7k2UE3VcjMa4hA/8eamaPix5r1cXwm99TzuYWo6m+9NuGYTcwX5aahDs9Pl+A13V/Qi1S8XrY309Ew7jSaMcDR2lnUTdlKIEhbYizUrL4zmFEKgu2xf1KaYiNrqREiSLZnHKpuJhgo8HgSS6fngi8qVYbzek3egA5NCdqly0cfSN1kttOfFkD6iXZXXSs9SRbMeYsIsDKquZ/xOhOSGBVRiG6oLpG7/C7i/XTCsN8AtB5X+kp5c4VUT1CnmZ+M02MDt68Vg9cyE4M8xkcpLjw/+/FbPUi2S0NCyDk9y4YUBxL0qbpPQZhBsX+sE3hwObqjAh1rrUnqfIgYX5NUElhQwACrCh2SN81fsR7K/2IEAE71PPDYSCHTfoMm9uPJgIkp0/hpQdfYH39ZzP7Bl6DMGGbwP/A+XButEemzlHnDBeIi8+RQ/SfL+9TSEGnp/XRJBMONe73pdYJAWnc9LwfhaobSQwhAuToyoXGjE0M2RPIV3jg1/zGUowkJWZ2myxQzU8y/w2Gy5QbUx9Qc23a8j22WLffJ+uZeBpZ7BHR82UBXh8mCJKP9i3uUMKR8dIj0jrjqktAsfRV2DO/B94VmdZx//iecspzpI1KQJMy+gDDlRUNLtJGz58fPNWtLDMatTDDO8voyZdM15v+U/J5qSjJovDTelv5poJsN4055sadnVos+Di8ByEqh3f6nFYpjFYNpOUS363cU/LUr/QU/JjJeqfZIP6T42pPAByNRMzA8pyTQHu+isSlLWeI4tJE1d2Q1Eg67prwrbL6smOHvC1hD9dryYtNB7
 ff0dM0Ss
 4uYPxZUGbutcuNAlxDXdep6Rt6GeJ5NWBmQyHh7489BpD2rVlkpoSc1G7n0RIMtbuegPUVAIAMkYFRaNGNagOiTEdkWJnBivOitcsDzHsMXSwTFFRplK0t7xbZGpjtJLCSUfBOs9gNvS/01/7xYRXxfrclib8rjkUvyh9AglqkqbSugl1IlUpuDKHru7Gqh5IZauiwLgf12N/ARFdtETKr1iMqmkGGtxbMFBO5Dv30dgoU14qGUPWik4pp1IN38LjEi68wrEDXIXpac8D535s8x7jDZEgSG+mcoezmlHpSJndbvwGXNR8U34td67pk00yWjTIWSl6dJlpZe9hIXrappL+4u49yHScwI59uxgHDwLXsW00exN6Sy1IeEMlipEc/hCEeK8Zp0mXWhh103AWOSMszFxiGKhKeKdlgUx+ZWyDYNLcMgfp3b29Lu7P+lbnBYjlJNZhK7zJ3SpWaAshgN6UB0+5fyfoRhF4lLZdlQTdyRsq9+b0YELKlvg2G8Bc0poHUCXuTh1hnDFyh6y5tjZxnWezbdfXGtwL5HAxMHt/LupF2Is0SZjHZQEd1Bko7Lhm3UUxxdUxkB/2SFCeXSIwe37cOw6tT6ta5rmGFpL5G/8HgrHOvnSRtARJMvbOrA6MOJ87QnUadQOyyvDWZ36BY2Ar9ACM6EB1kJcvcfK/YWVq6JqugyOnsjBDAohD7FvT1whJxWKmS1siTAqrtaTHjPUaVTHEu+MAc7ufJxq2PpVUIH8v9NxbRhCVyWcGHIHFcz6VF+JoLxsrLW+/qYzGdt2QYQA4Aa/PboQOurBYiYbLat0u4pLaVB9GNg9/gPu6vF7R+lwMu1x74WVzn7KEsRegVOdYpyute082FaI7/xvlE5sL2m+qEIklGBANaLc02wE+d6B2/xV0S0GA+5VRS7jm3kDs+c2M2uD2w7AW9oJ4U+1Ad9KGU1wMqZZunkq1h5IjF4zZNVxljo1udbzfbhQC
 Jacdt3E/
 cwsqFDfbzm+oboap7eHtqPUkwc1RvKKgnHHYb0gfhgvRYtI7Gc1hjKaweTYLxoa6dssXKsirCfuSbMOqqHd6qgYmu5yzjMRYHozfse6llCkV7St34eJVo/U3YA5+6Kg+wmTQeKrQ/6B51Jlckjne/x2vDUJPillk0azQJ1SI1APi7kTQWDRh4UYED5kD0jjUBskLOqVN6Yb2PuWYr/C3euuSG9oAz0GFKHU1DtVYKfI65tC1Ri2vkt3AqY0XbD9I55jPzEA6LM8z+uWxlpuoh1HaK/t3a5wOVlCl8MdjEKnRScE4lQtJKOYvXlQGXpve7Ko9i1hlTvt3KZTBXiHIgLNAJ4IpQI2e6aW6HK3c4Q77w64rirnG/BsBq45tVKRgPnynQu/6mWabeDN0CR4sFgdI5qWzoFwyR8H+WAPbZxcsuew1gLcUP8I5XiwPxnk643rIFyRBS9GL4TOIklPjGm1t2G/KRufXlWFaAOPQqBsB0A5tBzvqE7SqJTu68TgwBXOQt5dIpjKDKvns/aSKk4G3LxhQRMAqhgSt0ecy3N0JwKYRRwzfmaAKr5nY2aA02+7zjf3QtL+4Ibn3JNcTv/mv0dDlk1SEFZzQW374x9ooUaf8BNwuM6fj02UabvLvf6kTWC67DlaKoiPnkyZhUFpzXZyTcX22kFEsT1yC5WhMTM0k6OXlaPf97CEOIAXr+PPRC8v2SDPABgPMu0SZ7OzsI+QHmWLg3waHsAIpv1YTnymW0L59PP+nzH6pr/wur8Qu/a1ac4Nio56djNK1XKJskAAV65/cIexkBItm23Z07tc5fUecEZaWhJ1X2rG7k/TYa1DzSoaKVUbeSzzSVLMi4ytSNW70PL71LPXzrQzeF7G8NPXTSKUiLW6ZJ0o/2mL1aKsrDSSyIl6pgf+1SEZKQ+VlJe3gwIsAMUIuwMyMiQr6sklXTpA0o0HwbZMnUDwqZudFTPbdaGPGL5lJft/bxo7qf
 8gV4V6wp
 pRI6iSB4WvyAfME9ZNcdmoSwVlVisuySFi+IpbymcP1hSUBm5r4Y0e6gTiMDWmUgez9aZs6E+g4lwa7XE6IBCA2sh0pa6HMOETRn5qLkutTkJEmX61A+Ub32DOtjrwqzTka0bK4E9cWtXstybqfD5+lE6xLy7d+esEPluWB/JljO8J7EG4qF6EKn+xSsZvoVs21yTN8Ng8IHEwd1PV/y0IpUTE5zmr6ar2zJZWmtJoLNv6MfFTthyYzlLwda/KQLPR9EmHiqYYA7ZLSK49liIsfdOepYivVg9EHdzo8EB+OG6jRpNppZAvbAjG2gDT4vjCO0jKdGm5xOgNugFmGQPE0oerXwZJYbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 17:04, Lorenzo Stoakes (ARM) wrote:
> The existing kernel page mapping mmap actions allow for partial and full
> mapping of an array of struct page pointers.
> 
> However some drivers require the mapping of discontiguous ranges. Permit
> this by providing discontig_kernel_page_ops which allows a driver to
> specify how the operation should begin and how batches of pages should be
> retrieved.
> 
> It uses the minimum exposed interface to do so, providing address, page
> offset and both vm_private_data state and a local private state object.
> 
> ops->init can establish state for the operation, and ops->get outputs the
> pages to map and their count. Should an error arise the core unmaps the
> VMA, invoking vm_ops->close, which is therefore where any state established
> by ops->init is released.
> 
> Also update the compatibility layer to do this too via
> compat_mmap_action_abort().
> 
> Batches may not exceed the VMA, but may map less than its full range in
> case the driver wishes to allow the user to map an area larger than the
> available data.
> 
> To use it, users invoke mmap_action_map_discontig_kernel_pages() with
> initial local private state and a set of operations.
> 
> Users can then use one of the provided helper functions to perform an
> action:
> 
> * discontig_kernel_map_abort() - Abort and leave the mapping as it has
>   been accumulated so far.
> * discontig_kernel_map_page() - Map a single page, or a compound page given
>   its head page, as 1..N contiguous pages.
> * discontig_kernel_map_pages() - Map a struct page ** array of a specified
>   count, mapping only those pages which fit in the VMA.
> 
> The userland VMA tests are updated accordingly.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---


[...]

> +
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +					struct mmap_action *action)

... indentation ;)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

