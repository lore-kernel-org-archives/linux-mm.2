Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FE1C61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87FC56B00AA; Tue, 25 Aug 2026 06:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830516B00B3; Tue, 25 Aug 2026 06:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7B26B00B4; Tue, 25 Aug 2026 06:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0D86B00AA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:16:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A00BDA310C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:16:40 +0000 (UTC)
X-FDA: 85139387760.02.0578740
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD69480007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:16:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gOeAChmB;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787652998;
	b=BQWO4XBJwQiIHlpM4X+TgHbyGSOUHScJ716SjsJfmvi0Ocxm/tOPp8LH7o00NN2M4dCinG
	N5NB17J44kIQ4sJivlLnS8JLpDUy8PzhYB/54oL4GfXDZloNoYqK/AWcfi5Yioik/Fg9yx
	VGNB7X7Jc/R/dcE/8IiEBm3apqR69JE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gOeAChmB;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787652998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aICPP46hK3A0wWz/sGRhfqx/SzPeFmU/8o49XOoh1g=;
	b=rI+NpUd9qlLYrY5qs4UV5SW/7mjhoBpyafZ3rMDyJQBGq2W4VYAlQJLrOc0cRmEnazB2yB
	MSjBFPENy+nzjynEnxh4NeeXRugCq/nAJfaVoUPLVXsib4nTrIOYfNiPNIQ936ZCzfM6Ch
	nJF7/sbxzY7f5rH66N1BxLgrrX/G5Fw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C99E84351C;
	Tue, 25 Aug 2026 10:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCB51F00A3F;
	Tue, 25 Aug 2026 10:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787652997;
	bh=0aICPP46hK3A0wWz/sGRhfqx/SzPeFmU/8o49XOoh1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gOeAChmBSrTLHzBf87ButvM2PY7Fm604Tdgfyt6xo8MWEtNQIuKsDX0N7WwwT/V9v
	 fs2UmYjp4ccPpM2hdArDjMMLwGJ4lKhDLy1YiwCddsbEXlJW4n4lJxLKn2Y2Tppd5n
	 LS+TQs84pDt0E5wbSQQq1+HsAsdLrfBmOWJmvZwX/RLOmpCbYL/mTGNxQIahrh07Ix
	 cCBxxxz4Vvrj9r02UDwurB5+V1rivg64lw2SPi2IIUr1dmRpgTTZTdRj8/vPr/grRV
	 8HHV6Qn9rYSK1GTlrv4ifCko3gjohntQseaGJajUrdP0R51eBJVOBIN+j5hMrU+ECI
	 bAtyejmwvehXQ==
Message-ID: <7db786d5-5665-44b4-9c1f-a88596be0560@kernel.org>
Date: Tue, 25 Aug 2026 12:15:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
To: NeilBrown <neil@brown.name>
Cc: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org,
 max.byungchul.park@gmail.com, kernel_team@skhynix.com,
 torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 hch@infradead.org, djwong@kernel.org, dri-devel@lists.freedesktop.org,
 rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
 hamohammed.sa@gmail.com, harry.yoo@oracle.com, chris.p.wilson@intel.com,
 gwan-gyeong.mun@intel.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com,
 okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
 anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
 clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, broonie@kernel.org,
 kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
 ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
 baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 2407018371@qq.com, dakr@kernel.org, miguel.ojeda.sandonis@gmail.com,
 bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
 <20260821042143.GA40890@system.software.com>
 <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
 <178730572084.2852630.7732425311008244683@noble.neil.brown.name>
 <3d58eb3c-7a9d-4183-907b-46172664631c@kernel.org>
 <178761465493.3510150.12380729360578969391@noble.neil.brown.name>
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
In-Reply-To: <178761465493.3510150.12380729360578969391@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD69480007
X-Stat-Signature: 16q48t3gh1dbae8ockzk6dys8offu4qi
X-HE-Tag: 1787652998-731115
X-HE-Meta: U2FsdGVkX18IbEKAqAj4OC2m9a5UvO6+AzUa1De32Pt7KqHDSxfHPgzS43nTPsniUuCQn2+Bbglwh2jrmfijwuYQCwg8AFIoBatF2HiCak849kYg7U/eA4hhGqHMPE+gIATMQJGkdZ+g+6yqsyugKILs+EZunjSE3WGsT+TrmNxNIpCwY8lX5uJcumgwh/zpjUMFsCLBoRQcZOtwJgyPfAd7W4LEsa47JSE73g5qrnORxe6xtWYqXfUDYm5C/Enxcj4Ijdqrv7+LO1PqkeOsbZuD3elfrqHDd23L2P2/bGZBSJESooxtEw9BmSTKmNmTqPBqG8+t84rqvvIYOrTQoNi3YpAP6RwKrRaoVvNnQkF527IWDotvI4Ykcud5LOYoA8j2dZW+N4U8s0toM66Ij+fW6lCzgFntSMIc7OT7qDQYfWDU5NEOWYIjodvSuWSAlU0lCLHwbQzwQQqIMA2psnTkvQNRlVCCvxEuRC/TrQiZJSboNZUdq7itR2IviBDYP0NapDg2IsFOiQDZivOXMJHqfx6XDuEOGmIUzBy8XHO2nsG0XO9BFEWRCqyWj3WjyplaHh6AaR+bZp7l5bvdJ+AWbLTPXey3lKDVbVU0u9DMziSf3pxhgAH4wtYBAc4PUBDCKnbERwWkViDvazUTmD80WynpaEx/FtXwINd9C2YUwOdPY4nE6kHujq+axu+NwFpUlrFT3gOcbVEIE6vkRrkidEuVooDpiLY7oe9BR+BlUrO1nyiUwe0kuPKJafp8Z/J3wtfqUl7fdZkVbANJagbgrTk7zEWWZDRHEgbkN0zhquZYjoHpfCJE9adKirz2FDxV6Jue2iU/6/xvGXd01ab1zXLao6+aGns0vZbvCQggRVNV+EFow1+L0lhyuvpOIKSC07AcxWr8XJOyQqqVBcAgj4L/sAnPG7FS+524gMl0mEzTT0Syi9fdggbzRy145M5g8Q15FLnXAYx6+D4
 2aespqSw
 GjD6KUZWlBUHMi4RXtk0IfCy8eCFiRr+RdQ3cpO29tLoKDtuiEqGGIMeBhOJBnfh/8Izzvv5wn1Yxxq/Zfl4kqRwC4I5oz5HC1C+ZmS5akw7uPmYlY0Al+n5lAGDMcRwR2x7WrnCy7F1Q1nwvKzBxlUWuUcMvr3/mrF008Elk5TRLGcghJWfjPlsULDP1CX4FqYZoIdsemOY1FNHGqeVxPgHlJy16vj3ajdy+pwSp4cYkENUkK3PEz4L+rRe1FWr4j2pMIHXvix1c8GVrvPc2oo3Q039md0EtBdG8as7aMzrESN4Eg60PJPFEE8hXq8KZ2OQP5aLFgW6byrzFcKKW5ACFtQ9JmdLCtMrH9ktdlpmlwyyIYiCvCuIALw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>>>  But I'd like to see a coherent
>>> explanation of how the functionality offered by DEPT is clearly better.
>>
>> Yes, that's also what I am missing.
>>
>> Stating that lockdep is stable and should not be destabilized is not really a
>> good argument.
> 
> No it is not.  We change "stable" things all the time.  Replacing one
> big thing with another big thing is almost always rejected.
> Incremental development is the preferred approach.
> So developing something like DEPT to explore and learn and demonstrate
> a cool idea is great.  Making it completely separate can give a
> developer freedom to innovate.
> But the path from there to upstream acceptance is to take the lessons
> learned and to apply them one by one to the existing tools.
> Yes, that takes longer.  Yes it can be frustrating.  Yes you need to
> be able to work with people - not just code - to bring the community
> along with you.
> But the result is generally much better.
I mean, I agree, and that's likely the direction DEPT should take.

... unless there is something so fundamental different that it cannot possibly
be integrated into lockdep ... or can but overcomplicates things such that it
really must stay separate.

-- 
Cheers,

David

