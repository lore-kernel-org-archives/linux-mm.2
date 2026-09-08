Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10168C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6276B00B2; Tue,  8 Sep 2026 16:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A936B00B3; Tue,  8 Sep 2026 16:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BFA6B00B4; Tue,  8 Sep 2026 16:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE86B6B00B2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:10:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BAAA407BA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:10:07 +0000 (UTC)
X-FDA: 85191686454.28.5809EEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9CB6D180005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:10:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXtl5gCB;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRgT9ea8+VjlPBqyFE1dpILlF4sMFkSDNa29fecVCzQ=;
	b=v8U3RCAYo3PuzNgb6zVhBicHKQmOrpPiFQndmZZaw43AWiWpdl3H0GbbH/cERZ5PjN7FoA
	Ayl9JyZNdHjgf0HjVaux0fDN6kO3NUktSKhLoFshcxmFhiE7K2Q/AkIyqJP3J0Xjwl1AmF
	bexRDYt5aO+yyuIug3b9OWQearTS8VI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898205;
	b=vj8gQaXwhiHubOc2+oIp/e2BMJXULOwZJz3+3QGcaWDQmuS/CIz/qTHW5f8+W3zAIT5o4o
	EQZj9GTX1lMbt9QDY5KiTsPmQzxmysdX+FDjJAYI1ernICP2Fb5ihDH/1wRzz5r60UYtvx
	F5/yWwk294sVL8vTGghmA8JIO8IsmDg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXtl5gCB;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E217E43474;
	Tue,  8 Sep 2026 20:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1831F00A3D;
	Tue,  8 Sep 2026 20:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898204;
	bh=TRgT9ea8+VjlPBqyFE1dpILlF4sMFkSDNa29fecVCzQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CXtl5gCBQnmo1ODch5we5oyPtX6Nta2sLhdZVCDDoKrJYyG5ZOrfeL17dSMRxRx+O
	 2JtdoLnek/ZnvF5M6XzHHKyvbTiryESdHP1W0t3643iGGF7vD8iJj7wa85XGsTdQwt
	 jVgFDkNZwQbInU9u6s2EX2THAL+wyzfzfsWN/AApTZ2QAkHOhs0MBqZLv0neZAPd9D
	 r3VHpvsQFuoBH08M0WynwzQJFyDYgjz8hc/CfsxdSjdJDToy8bZrk+CcdlfRaN6GiZ
	 STxCchuEh6FVGii4scQ1lBGiJ3533RSLAGnPV8X1LfklWgDOvEuhjx87N1UE/YAZAW
	 KE4B0FDcUN4lw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:20 +0100
Subject: [PATCH 16/39] mm/vma: add and use vma_[flags]_is_fixed_mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-16-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5182; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Jg2oZKAkMU8D3w7VkxZpIxKVLG547PwsxLoXFYp4+ho=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG5es2n6jbmNMW5PX19+3CQW5rEg8nT8bCWdz7nGe
 e/NuDxvd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiDd2MDD+ib8253+fxTJGd
 hXPZ4/adfMwxL6f9aj2hE7T5P6PAlh2MDA33ta9mW2WlSpl99XNb+fXNhbgq2+cPjoY/uzi352f
 ldz4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uromz3ypanxmr8parjdpr3byruacfr1j
X-Rspamd-Queue-Id: 9CB6D180005
X-HE-Tag: 1788898205-212056
X-HE-Meta: U2FsdGVkX1/jtR+1/YNOqppO4g4lfFZOPJTVVJ1Wwvo/M1+LSKdlEF5vZvbmOjnF4xGWSVWFhHVABoptrcRs13H9I6QCmdwrpwoxqEJNwrJJPJ8RNeo6XwZ/uYs5I0XEYUiT2SFWvNCDqILvvNp+s23yjBbYzrIb/BGkuJb+Znfc9rQiVvnTZg+ZN6/eHV+5XwSgVzx6KfTzwEn236UbstHLlfw6UxkNBg4xrqH416dboVkg4j/7Gm1mCIx/pRd+ZjnXTk/6tozShHtsMDjGxuL9sJK3LF03/E5/zt2yUNVBBM1WsFevbntVbmKRg3RW74B4U84g+wosn72h/nYeP8Z/OEU6PedfK2mglq2Q5R7JfZ9jPGiLHiZFr3ko9QLXzmp971CP8icSY0X+bXn4vK8z74D8KGEsErpLs3fAtIKibFVPPcH1CpWvRarPGLmYjvp8pM1D26DAJYX+iVXsFHCFc5l2qYrOVnHiHKBvNno2dH5x3A8iTW7oHc/zpGbwsqxbdlcsRGaHbbwgASAgCDjqGSIOh0lcOJPQigIxebJcL805M19rx4pzIseu8EswRsMy5KAc62ZcefszZbm/2ZZjSWN4jHyFxFKQ0t50jyroMhRAWUEFu4ViH2AxJZ4JUMdbmO/fXB4DBwaixtxNw1PUi0MgUgNJbT/oagAfLNPJBCDdouclI7e2kfz7hsjMaxpJ0vhYtpfNV2mgQJcHkecFtnx8kN1OycZScN4MWpjrPl+x9KtQJlKtWK/vqPVHmx4YTf0TICtg1Q72k8Wnlf5JCT59p3lmuICfsSAnazmvaZfyxZjd01XGeUFfMxtpn1GegO7aME3K6oSRDtvMZQq0d2X9i/JM2znsXVvGdCPPlHPjM/eW+MHPnaYedO5uzuh85Ffe2ZkvJyNDHRqUOx19Sh5eGxFNGDt6SWJE1QyawxqEyzKcIo2txu4PA4vZBcE49uBKP6ZAbLn9+g5
 MiVVrZOd
 xIJx7T4JIQjUZslZQztzH/DsJ7KzWpSRNN55Nkh6Iksnv5brA+KBw11IiqTvL9F2QhfO7jqjOVoqrOilA0gMWNrY+tAcVycUByaXVhK6qY9G3rxd/A0URypHeYuZ41zJjhq4wJ3FaMgehyOKqYQFRQhbY5ADbpNXsgQKTBesFPBLkQ2A2FaCs3iz5j1+1ilI8GK16JfBVFLWyxobMFMbffLqQ5CyHuccbif/PJ7TYYH9h7d8dT3rIRj7vHVRNI8oja3t4m+ovGcAKZGiioU2sjKkBw+6RerLuMNG2yQm3HENUHIwDnZF6ZLiZGr7DngtQGVc/GJc9NYvYvKyNhr5AXtxJvCofQn2GjGShvebjgJKrXsX0+1vhfPS01NHEi5/osObo3f3CouwgY/UmhDHQmSwN1hUmhbon7rg7w0z4UqYnfmEySB/t8q6nLpQ6bsmFNQdt2yx4cmpvaQD7ohUzLoa9VVq3NGb4pb0RgLJ5tt0gfiPeigfBeAUJ0/i5oNbq8+bWvFE7FNd9tcxSoYamP3qmU7RN0gvwZQ/pV2JLr4j7MTQ5j311/6FIywnzvV62T4HwNc9mSq6HRNFBXJicMPi+jT1854+RD9if0AJevpQCe6reyL56UeNQ7WP9mz7CWS7MJ9k4coDcHIxwOgz5bPIIqjufzJ2P5rwBzuvPNvPzioIhUbJ/ms2Ax/lk2LE6r03SKtvS9SvkJvLHrsJQXBs6QNpZnd85YNyMLs/gam9Jw4o4vJaPoTjlC7ru+rx1ItUuJhNuamnH+F9Z3f2F9m8477XdwmuCz+/dAxLW5KYkZdbCzPmV5yJLsc+FI/cuqfaiYuAtS7pFc7RcRwR/5XXy8iDvxoZKgHe/AgWFOjukqqJ09GsodeKWo75thyBj8pYu1eoKXky1gs9FPJnY4SJMlBK/Yh3tQ/EE+rxwzzj/IWg2Cie1v7GS+RyK0zQL6mY5SoqbNWCmIbNdNVGNVdooacOL
 xJxQ9hAG
 P+MsxSCW3lbKT9xABjs0AOlp16ZgR7A1n/Ga8bIAQ2dDQ1bXvxU3u2PLfsuIrCIdyrjn/WiWJqJMy9Jgjic0tdUzC3CA+kn97KDiRu3TCodiEEh4QyCHpdQz9aXbfntVpoz2mBP2TuO0V/o5YqHVioFLgcIdJ2PqHFo5T5W0bxuzkClgLPGoxoqWH4n6nQHI92/xmSctAPvzvLziY8/tq0cztcg0Lm4AcGsXIlh/3SvCr4iOTxbQC/pTz1HLDlJ/GumJmMjP7NwBrqM4pbBRWRcnPI1yzlXNYferh7Iv3CWqVftmb3IjYGgU95DzLt3VoJZt3bIobkedtfmBDChoDRrtwbYcFTtkifuWA/n6xAd06DLUhrthM8t/tjAiliwBDtveVIfte3dw5wB0GOtKzZ2EdIhQ0hGHp1A8pvEApx21TvLgJnSObxcm1EFSfQh1i561gjCV6CCnmoQekpy7PQ7k68NaMrdlHindZPWDsCZFjRPi5txJyo1Oisi7NQ1IzTH1mcujoDnLdVRHZKeydWzfI/TU9MLEEzMWM92lmq42jFyqJWwbr22A6MK/xsBjYRzpDM4BGdQufpDGwiW+UZegE9nyX4pGJ6LrlaGHwZS+pkDu/FOycEe8KzDWYcBxSqQFpNwVc5Uk2onzTUnBTG1oPcvMHo3Gnx2tAgz9kFT4hZPtW0kBKa+KQ5DVXsBXVq+W4VBeGrA4SNSxGzpl7qq8a4F2urQm3KqScIsxCsBT2Kc392OK7t9P3oRmfNoacMO8jYPj/JJRmRQkuBXHGYtMwGb3bqJvSdFsj79QKqbwtzkvwHrr1LvKJTYtXSFmBoUuTNGvjkDvrhzuq907b7dGmIcGZyq9Q/iEE7ZravHF1n7Eh7pEpdz6qcHjoJZ14OJClOovv62vpK/zu59llMmh8xiJ5Bcr1NFL4Fe0VwJSPPic8f1YlTPqNyPwOwtDxXOKsEU0MqEK8xz8Z5j42TtSIcJ2Y
 i1zmDmoL
 UZp8rn1X2NY0SCMwoC1lB+MCLczpPXFQ8UP34nohYKjrtpIjyHfda8i9XqxP7yIjigxNUM26ud6u759tPu65wUKi5aw0k/0Rjo4R5KhT2QwIhixnFnw7ZYLUfm9CU1HgDY6s3rZmOL5Na/8jMQ1wTknejlpvCRHB2tHLXSlgnhG0iShGTB6SaIjwl6IQcQ3uehbS1Iit6FozLMoSui52XqqvrpuEyFGMTkNOu7jmFampn2lZmax0mqX6wuwz49Vb/YGPD8bDU6qOiTSdZ9XcQl9mbRvjU88xRibUg9WubRnPo0iXsotn7ooyezw99iAqLB41RdGq5VgZ0e5KOQs7Fqr+phE/flb60IQhE1Lbp9avkOfYWmFW9IvvcxhZtU0mZwirygn92FRP56cB1kDzK9+g4pLKd8Qo3KKVJTbOhqEgGI1ctoaxuudkgyyZmg1cA8SV/o1q+w8NZbaY+qAxRJ4tn44L4po9RAiPKjrw05TlmlbSeX0PO3VaxsVUZOGu6sOlPcc2CTcx9tduE9RqDTove6YjPeytr+M4dkvMBpI55ZqyW7oepEBfVP5sda6K9PCSjmKrhj7zUpm2tGFGo8yfFZCYdQaLgmRa38yFsR3O+Mrg3/IuP5ZKQRbmV4LEZCf54bOqywL89NX+Zck0JmSjCvAIdsu4bXYVW1ZOWYGjLxYwKz/bUmesHTHSdwi2It+YzklOao+hNdbHv1EsFZosA+taER4FYUiQ8uH5BwMBRqAEDU7cCIIzn452+v4fzGsINfcz8VI4oSK89/JIUjyh2C25Ala3cXDUsXKqqcmx4nZAp72EVbMVw4NtgdBQ5qFPyyZmond4UhpXXuSYO9Cn/6DQQ73YA2F6Vvx/K9AsCgkXPexwRvF9E5UHRyBdNeasGp2C54yw53XFDlWkYf7+Vk8DQ0rS8MalOzWty9YJLYFxDkpsnbm80fa3P+ts8dvONfrS4AptyM5y2p+HjbQjsFC27
 3AdtFwF2
 NeLQyIsbSCF/Yc8q+VQWbuobXrwDQV6scuXeH11g7GSugwuhGgI5xU741V52YQAGigvRRzGmfT2FUzU/7m0O+zhwCtqAfCNSwemV8P9KkKe0uPDz2hbm/FRXeHi9Q1V46ZJtZk5YoloSRc9TuKId5XW9qHgXjPISLQQsYIj+9mk7qAFqTH5rmJCxx21FBdAMfE360t3nOH5SSVJScWja0ETNikdIaXJv+tNjuN4gXiDEN21C0JkFlkAdpWpndtLbIK6jMVX1840Sjl4VNMvMjbONc1nYFUM4CHrctFL+Uli18aH8TdAgxZX3qUczYWIPxD6L6MLgIfZNUmkuy6HAw7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to kernel-owned mappings, however VMA_DONTEXPAND_BIT
is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
must explicitly test for this for now.

We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
set for VMA_PFNMAP_BIT's despite the one implying the other.

Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
mremap logic testing to see if mremap() can expand the VMA. The criteria
for khugepaged and MADV_COLLAPSE eligibility in
__thp_vma_allowable_orders() are precisely those for mergeability, so use
vma_can_merge() there (with an expanded comment).

This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.

Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
VMA_DONTEXPAND_BIT.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 39 +++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c   | 11 +++++++----
 mm/mremap.c        |  5 ++---
 3 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 45c59474c853..bca955941212 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -600,9 +600,6 @@ enum {
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
-/* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
-
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
@@ -1650,6 +1647,40 @@ static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
 	return vma_flags_is_kernel_owned(&vma->flags);
 }
 
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a kernel-owned mapping of a fixed range of memory), and thus
+ * cannot be expanded or merged.
+ *
+ * Returns: true if the flags indicate a fixed mapping.
+ */
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+/**
+ * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
+ * expanded or merged?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_fixed_mapping() for a description of this property.
+ *
+ * Returns: true if the VMA maps a fixed mapping.
+ */
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1671,7 +1702,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (vma_flags_is_kernel_owned(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..befffadd978e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		return in_pf ? orders : 0;
 
 	/*
-	 * khugepaged special VMA and hugetlb VMA.
-	 * Must be checked after dax since some dax mappings may have
-	 * VM_MIXEDMAP set.
+	 * khugepaged moves data from VMAs once collapsed, after they have been
+	 * faulted in, relying on refaulting for file-backed memory.
+	 *
+	 * Kernel-owned mappings cannot be reliably reconstructed from page
+	 * faults, and fixed mappings (including hugetlb) may not be marked as
+	 * kernel-owned - precisely the mappings which cannot be merged.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && !vma_can_merge(vma))
 		return 0;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..ed19b47c2caf 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1788,8 +1788,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return -EINVAL;
 	}
 
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
 		return -EINVAL;
 
 	/*
@@ -1827,7 +1826,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))

-- 
2.55.0


