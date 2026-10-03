Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 072E5CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21ED96B00CC; Sat,  3 Oct 2026 12:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6AB6B00CD; Sat,  3 Oct 2026 12:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5EE6B00CE; Sat,  3 Oct 2026 12:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCB086B00CC
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:46:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75C201C3D7C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:46:15 +0000 (UTC)
X-FDA: 85281892710.20.CFE417F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F09C40006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:46:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJ0dh0Ad;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brSHanJN25qJ54Niea2K3A3DIc/HKTRx7GaGCKmRkSY=;
	b=BqA2+MeLXMFhf8qrtohWPR6cmd5O/3ECrYSX4LPlJfH7YsN05Yjp9VN9jnMrHXxzi9jppL
	o6CIqAw2ycViF9+Ar9XISLTXw1sZvIClyiiNA8O+37uWPEKk3jMk6dCoIV9T6+vMwiTxpO
	Er6syNK+Awx7myR9j6YFlMBOfs4JHrg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJ0dh0Ad;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045973;
	b=CNSbhCEf2uAY3XsbNYLSvoTd10nJaSj6l2E6nlgzsY4L9KEiZ6ca1kjj5V6Tu/V5FMUxGz
	GCU+2vfOcoAeoq+LxXBGiHh8Sx6KIMx53Yzbi6dQtAMe0wd9MljONTvGpGYbD/Oto778hf
	X6d2reGiwlVX3ZUvHwvI5G3yGxk+dT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3250260D82;
	Sat,  3 Oct 2026 16:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7521F0089E;
	Sat,  3 Oct 2026 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045972;
	bh=brSHanJN25qJ54Niea2K3A3DIc/HKTRx7GaGCKmRkSY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iJ0dh0Ad6rMFw8NWFanZoOVJKdqv5+0QJdiAuPXZ9hFyjOocWD2QU0tOfOy37t6sO
	 n6UrmtPTUJUo3LJbdeDRx+QQ5Te0C3wSrJhnoQBgpaHmInhP/d2JYMpj2gF5/EC6Yx
	 SnZI0MIy5cVgWLiNXMBLcUymDiHNdXmHhHCD6qxa2MIDbptZRpaEt2c3i5Mw1xt40B
	 Wdxe/5pCU1O8lC8rkV6oAvwNYLFq8Ol3KW4uIkeKpWEP6NkQE2lOGTytr0ts5h+KKl
	 I/Jd1GiCVYHiIhVrM6LNj/SoWNRHkU2fTkqopSulCs/J5P6F72igOUwTDZLDxIId17
	 MqAjrZAlrLXhQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:08 +0100
Subject: [PATCH v4 37/38] fuse: dax: do not set VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-37-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1534; i=ljs@kernel.org;
 h=from:subject:message-id; bh=tfz3ccYwKEyTRVC6abtstchqWCa1ts0/TLS9J4UHnV4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6ulcdp9wLeXRjDQtLZPds54xiam+0lFu6nXP+fr2q
 Yqq5p5PHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIURNGhh0P1K9brsuZMdM3
 fNKappSIu3U2ZX2sDS7Gidb7LvVtrmD478L7L4pdyulRC39Q4cPDS67qmWv9q+H2eh1l07bqyaN
 iXgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: rzppxc9nig58e5zahfutnpjkiiatmb4d
X-Rspamd-Queue-Id: 9F09C40006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791045973-934759
X-HE-Meta: U2FsdGVkX19nAyk9Q8a/Bi9yoOQbGYpzgt7dB0Q6D99q5frH1W32a8BQ0U+w58mkBJZUwJl0o0hlkAPHFK+jk8PEpPQJ9wNDaBmGrdz1/pJTP1A/h6rcjLwsAcvPS9kavG48uwVkPSiYkd7GOBWg/AnCH6Ksiznx6FMFpoxWVnDcgc8DqFzQvYTinYTPbT9wpVYDUdlop4rNLSyg3HPRid1uH2gawFT8cWtDfvpagn6n3ZccwKaZYVADRpLxML2dwfl0dhCjSrWSp+gh+zhb0Q/6c/L2VGRlncK29wx70PjIB2rGOts/dqAJ2AkS77DqAbPUD2AY0UJdmukOW4I9HsI1D5pSiRjC3y4GE2YqeAhjMsJ/cFNmzZQJIjpraF3DFx1EsW+mSQkkX+jqPOTPpYr+D1B/G87VngsX6HA2zJjxWM/LiwIPbnmDxBo2TiqVpr/Err7GwaH0rAnBWHasCWnIdmdfyNQdsE6k+j69nMP5d47YhR9zH3IO+gAc+RCXqtmPCY+JKpf6X55857y7okcNhOuTkx1niLGUycvvw8kisglxN+ZUjp9oqqS5XKRbFWdd3+RrixDontkh/yI4DCa+S98g6ijup7rcovClQ0qZbTyAHx4QIxP2eRXjlauAIa6FslC+x4EYJQ3lbGECWnw9BI5sUdVWZ5ePRncyzjUOjggzvDPUo1GPpUAY9AqOFz44AJVTuJwfIA1UO42TrTfp0v3h91djPMWo3LNZUXZRL1ehBJjjZugWzqbc4/bn4hBYL6LGUCG2n7X/QJAZo4AwxT/f2vCuSdNvskvDb8H1LKrek1VXj/cCjxvkV5KSTprxkzYJA72N63bFwJUJ/mdhbwRlLG1EWbxo5CWEga9GxRfr/D4F/T443mOn7y/ETvwH356BtLMY8lRMmirpJAe9hWylrklQQzNnrmXbkROftoJbmacHkEcAp/0nfnje8RD1qOIWzgBnJ9ccAGH
 1j320XzC
 qjV5hus2/ravrPLS+Az86ARbzmeZq81XZtysjCcdZFxgijje9cbIFngp8h58KR0L73zNVbXOiMT7DePXlVi/gVctGHU10GubYKITx9kGr9IJ5wI+hS+1/d///o96G+vPQhxlzpYZs3HHXl/hY6zPe2zYj/7STjJdRweAVTcw6y9WxlO52qr+KJ25zt/YYl0HZCjsaIMdFdomC6t4ovrWlw4F4Qq3mYUHor/cBle7HEGIBOKXLB9vmMIR9vThkFcGu+rvp5gcZ8bkzzINXwvTkqNCLsStN8a9S4rw186hBbdaVmQd4iZ8yG7OgDIfpljups2vcgCWYk6JH/VCj0rm+s2K2vNj1u7vcwdhmuoukGVnuSGYDAuctR1J8JNSqQacVCkGHWiOj/WiuGbZ7NAosVHyr0I0YZhm6G58khiOG9+lSot56Hfgq9SAPd7DzJIA1gW7kVoZ/I0fje3a3oddy9lt7EMh852PmnYYlG5AmcDptX+0hQJ2Vi9pAMeQ+pnT4calNhUVCd986eeJ/b2+0OdlIYBAxjCyL0LRipXt9BgGBMABMK3nR7dD4tfMF9Y2zDRHuCuVios2i0fHHoJD0e381j9dikuZv9iDF/1E0zTABmHxOwGiNjaQUPkouQivawVmpkalJadBVkOZHh9QV7dAWzibyvTs+46brgOpDcVRau7TKOOJXfoUtpvmF1UHxvEgB8SG4ppoa4UTjacxY+KuL53RJ34bOOQC1x0o36Ekx9Mi6Cg2xTUuCBsw8hzGk4KVnUFtj+LdP+Nn3QmNpzNTisBQyv5id8wR39eQ5RNUyPxPizXXcq2tTxUj1NO2ssYVEV6BVE3AadltTlllliIogMED9tB3Gw7Dizmz7JDRawnYhQyKimRUii9F0rLo+1s4O7j0ZjTo53bPa3n/uBtSetHBqsgaQQkEEX0GhFc1XBRR67xZl2/mFTu1GsTLfLw8InTyzOA3ambT58Xi8ZBkiwFek
 rhqxSi4w
 e7Vkjrj4I++W9+jXFHa7keWsvc5rTnetCRq8uKtyY4Up2FZ6ITAA92CLpMiqtoi2TMwOALaFLxhAnqSjtDl5vxw1mxq2TbFnJXdHO9NzTisZAEe/Ph1BEPkJ5N8+Nfl/6VqDGqrFytLOyBkub7iT9Xx6JIlmRHyq/jbpnQgsVtelW/4TKpRiMW8eSlMi8CUzvktyYCLVSrvdytcuqXHj/T8ElnCZe0qS4sA1qZBFWy9dWfxhRBBKcRs+VfPi/S/kw24Z6KqK5Sp9y1YTemPdEuumyezwRmfL1R1RfxgmXVNewgg3hE+eNsF5SIsf/aIBWDmF80UOPaifCJHVXaosG4znN1WEbBuxd1Sl+fH9BjEGvif8zH0ztsfki4uWhz9pgz7q1itmrQwAhYmx0kHlRgdQzIbrA4ocsbmub4iI66gQZoh00pDihncTqer753hg9N4iWn9n0UT9PsaXeMu210sd6uvfrfQWd8ih6Ijuulw5CBHZfZgjCXUR0xzk+vR6yCpsYLBrlo9C1kh1H2sDZCPiVZbchAstsQVi/z9ifJYhQuZ6h+ySJaSMlTFei3235SsgEt1p1SZ5UVSaUBRgmZnQIg6kn160HindvO2bXtBl/dgjKHXJ5wENNiNRHF6BLmi23ulcVzB1PSapTihlXYZKlWNsN9vTR+tAwfTWZot4o7LPzDHf4hGHN8jO5dZ2Lb2nQaDTdu3a6/hEIi8mug634bLy99CD4akSknIH+XGDQNdBYF+tRLllA+qDTnr7fCtwmEX+edUZK+A181R4XSoDhvhezCZVdS9D+H37NV6YncezP4YCqLFZL0kq4OAp+LXLjWWWhNgnXSJDf3LhsrU5JFzfXe4RM7IfV7I9u3GfGwZacEWjPGUWyqJmEowd6qdLYrf43iTpsmhLfaQL4iM5VONMxnEncZRaLddDgaSn7waUBMYcBJVxTxWbr5L9Hm3WfVGeWneZVu4BWfkwVxyC9jt5h
 eimUz7Nt
 dDNgCfOwA88Xs82+2Ci6vXuJAt3ms8gNQJG6W8RIyTBq67Z7Len08BkTvEq4/erXDTjKUloEDTV5MZC4Z5TqCX+be7CC5VqNtY2hdN7fiLheiT8pKErwTqtqlckO1ANBOW7wq0cpzVpJGI0ETKpQnU2wHcz/SYhghweqekPNwcIwwY+SGKHDjKSe4edtus91OJ3U9nCDZCCNtxcoPNgejENlifidGuHMtRxxiltckmY02aZBCF+qOzOV5kCMctdjUIRAVamWOTVlHs/dley06IzJMp/YtGTo9KH6K0NN16ogmDtx/JXxEQyxBZIgYdrxS8ok2qaJ7pF+XRA8zg8f4JtBzuiVEEWkQ/FIBCfuZP9ylq9kS1I7eg9hTygRIFPQ4zjadV86SjGOW+djhDgQ4nBPGjcaL0o8iv2esJpmYERwUD6r9GP0D3YEY7nqC5kwpLJvpCX6M6AmcKF/gBvLBhGuu4DATMxHu2qAFgEAu998yrYc6SAq44EBU7i1dWHmPg7XsmxQ4uJsxMrQhXUsMA/HsM3xtlB0GNtEKQMxdbilefy9c6+G1fA4eZyA6zJ4/l4K4iJPraeETzMU+6qkL8uXyBe50NN5ZJ/ryX3emuPcE+vcGILwyt1LZk4hoX72AT0sep7GzQWSwie+uXCeeB5cObRhooTHJOTEja0uOCCPdX+aiiLJPc0Fkd4jcgpWMzapY+SsgL9C9c7z7/jusrxnFcQnVGIOX2V3Pv5q92Av4gUdiSLnLDbMjLBus3u6NDPhD4NcYabplIAUqcewh6UN4MVSWBz2SsRnBBM38nPAs7c8MuoxfZute3jesCGOx2i6+rfzzyJJmAYtyidCvco0f23xSK3slGT5XQ25QPDpNPVSaFunojD/lYzZL//Nsuhj/Bc/wlCEFSjPClHAs5Ubw06D+94D+FDtt7tJf6t50qmJE0cFW8f1PGpukreyk8BBC2gvrmcd60VS/GUiN3yPOlORJ
 RmEggqEB
 sra8wX8P9dlEcP/91qZVJmyC8cEbsHJyNH+uZa0lm/1uDxDPmszqYleGqWXa+nGrQgQKq3aqRveIzVerkf2FZ+KaUb5G8tHmlA3y8pxJgF7YJVfLzhohiAEGvSUwIbJA6uXhwUyiV4yUFuKfUSehY7Idq8URv8y5kLB2TGSYHG/kKZwR6Ns60PMM73uYThQpk4ipu/V4GYjv/U4I5ctXVLrpyhQOdkfah3pghcKSxfaxAWVTJsWfdrx16xha/CZv4iERZcaBglvoCBj0AdhjKVY3Hhxb7h+ITlwnB+RXKBWBILSHdMOwS01abFdpy3jNEPsHQuLrmfTpJ39lMnM2GT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
relies on it to direct core mm paths.

The fuse DAX implementation, added later, copied the old pattern and still
sets it.

Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
insert ordinary refcounted pages and so do not require VM_MIXEDMAP.

Setting it only serves to mark the mapping as not mm-managed, making fuse
DAX the sole DAX implementation whose mappings are unmergeable, cannot be
mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
MADV_DODUMP.

It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX out
of its check for mappings not managed by core mm explicitly.

There is no reason for fuse DAX to keep on using this flag so drop it.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/fuse/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 85cdf0199bc0..a5994f1c637d 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &fuse_dax_vm_ops;
-	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
+	vma_set_flags(vma, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 

-- 
2.55.0


