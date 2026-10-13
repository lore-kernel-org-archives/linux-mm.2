Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBF5CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59A66B0092; Tue, 13 Oct 2026 11:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09136B00B9; Tue, 13 Oct 2026 11:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8826B00BA; Tue, 13 Oct 2026 11:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68AA16B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:13:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2AE980C81
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:13:03 +0000 (UTC)
X-FDA: 85317945846.08.D8AC962
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C7AF180008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:13:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixcsJGDv;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904382;
	b=xT1MuDiZKH+q52rIfCWsyc2BUGZbIDsaj8NZe8xck9sNdf37zBNkz1vnQ/fDsmF9UVDJHD
	uJGij7fozi8z2xCEi4MGjGvDegbLdixuC1w2Y87HZ/f0ssd0dgj6zS30oGDwLMJIlTW+GW
	uD97EbOEBigbqcgG1lkzThZHObC0Rjw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixcsJGDv;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMtIN+4F9Qb+gUfI9aB/QG5XlGE+8TEC3chxVq3fBvM=;
	b=jn1CQBzHTr9R1ortUCZu86t1WcAxY/9SWoX4aYBumTF/SdngQTppqCHUP5Z+g7d6TZuWF9
	0SRWgA9wVUgJjXBlsgDKzDLUeT6OjvCdlc/2gynJ/vKZ5JK85M8dXAWLvLLC00d51IQlFI
	GckA9UUq0p64GcFHTapN6c27yduXMMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 774EF60A52;
	Tue, 13 Oct 2026 15:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7581F00893;
	Tue, 13 Oct 2026 15:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904381;
	bh=GMtIN+4F9Qb+gUfI9aB/QG5XlGE+8TEC3chxVq3fBvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ixcsJGDv2gXgIS4jGBI7EAE4DlkrwlHt1eLiJ8ovFfYoa22s7vr2T9kSCoCv1qRmf
	 q2qeZ/wXO3QSzD70TNeJBCNbUC65BF2IbQ0jqJ2xw/4bNhW2xT7Ukokz5cjfRWQQBF
	 ahhuyGrMne9PTkLZYKUSEc2XZCt6S9Aw5tw0X1hvj0gqloiiqNcRNUbKxk4pQuJusx
	 hw4oi+etGB9cMNxuy1wKs5uBu41NeNQyCLp8UIzPzR0uapTC9giu+yld870QQnFUL3
	 U3wJlvLQqwI7VWVD+b9OxalSEZy8StvliGgPnRTT5iB9tauY0KoMXbDnMh9LOK1EXQ
	 zfBE1M6H6iRdQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:53 +0100
Subject: [PATCH v6 13/39] ALSA: pcm: use vm_insert_page() to map PCM status
 page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-13-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2824; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9ugH4FT9/gtznAktS44gGpUEq4pOXZMJ2VeeFOF3Z44=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZzUYFE18/JTq3IT5lgYd0l6kcipCwzfdp0PUWX8u
 ej+SaXEjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkkS0jw9GNStN2+eculLc4
 J/Uy7cK+1C0e1Zdc84TqdrLdtT0wcxbDP6s1izVucIj7pt3InPRBrZQ9MmzjUs/o4JtMN1KN5nA
 5cAAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: pi7zn1thtcrf9fhmygxottyx46wxiauc
X-Rspamd-Queue-Id: 1C7AF180008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791904381-162892
X-HE-Meta: U2FsdGVkX18jc5vOm+PmBFbTQ/SCW96BbfbgwlbFuzwpyu2hKp1185QbCq/YAZFFb9WVVmKvpwY/0JUUFm3J8VQvVqWcKiVnbxpw2KusiQatCF2S/p+ZYOP43NoQCcHNz4Hop5ttX3MojrbtzktCJ2iVOyCXuTBZ0lXlAVBBh3HrMCbiBLS3gXfsEiCWPJM7ujIKAYjjwRlE7fCdkdms6Uzq2lg27e9wO+sxvizA1s53RZeWwh8k1aoj3fovLwE1rQmzpWQgfYs+S71vb0wGiZrhA4XyDAyAkoMXsIu7Am7KFzCycfXYQs+5PTCYRZ6H9ioo1mCne3rQpXebGft38Y4/4n8YIznCtfXD+NnD2OJyuNAq731jOXd3UBIkdpeqG/ugfMq2/iKt8XdHWTK8nGkulO5IVRHnwSL7xcoZxN5HLEGEI8u7xOeBJkb+DPNOrg6Hb68RlFeT5/NT0QxXaz/C2STrQSa9BWcvdQ8Wc7MYNZWFjB/Gtfyk2bRk8EvWN1bCoC0+gIdkNdkudC+79Fs/m9Ao8p7v9SpWHrQo6xo0qvEjGqGMCQh0L8+OPO0cQ2ykHZA6kiI1T9UWTgy0xSrWUWEu9DS7WB3uw4M9uKxVTVl9gYz5fFCh2EAk5VeAGJl2JM98SpRzrUGTQV9+KcvsdyjaeFuqMJStFTl/L9LOgGLCITAmIEj2btIi5Xg8F1/ifV04QAmfLnGyekKaRWjm4TuAwapCkTTdJ98L/2OajglxRxBG2PFPFHf6WKPLx4Gqnhfumr+Rhgy80OsCJMYNxVyFK99PPB3gzNYYbW98wvpzhuV11iUyihwFft6Zi8iV/lu9F2jyZpuAJyNWAWdm1vSmYFs3SxYXJC8ayl5Bk5bo9mFdQOWQpB1jWxWZW2lakOKjKz6JAmETF+UFO7OKD+51bD3T4NF/K2E/ofvXCG/nijxhoAgwg2dW0H3zMgbu1xdSgADXO8pHTr7
 UtVg6/+8
 7xD6t+iF6M76tpx9ljL8gpx0F2wBmjlsB5OhLzmZVrBSmQ2S93/WMNYwrbjUXgslLXKwJHqVQDweKrFa3dBWwEv6NfYyXQwWWIWF9QnEJLYSbQvFwmPu8NJTcqfrp52YGXoT+IVA3R+/s0hbXZVzKqBTXxP+JFf1nITQu7b6VCtEEdNwp5QcD42zoUnU+Cm9ID0/8pvi/2NSgt09H658HNDiTNPAkJ+8ncgQIjKiNnNhhFDcCQFhCOZEU3eL/cZvvXxk0c5OFJLD3Y4iJYqRHTk0o7TRk8TtmL7ZvSyCa2Po/HQbK1wI59GMdSvEfOb3dJzSD35tvvQAGwDZKqfZqBnFn1zaJFXqChAtK1Ixcy+pOkYPsOLPT/zrLmy4eYGh6tpp3g1kI2NU16YbJ+Bi3tIe2iHs9wVvuzsZlxd4TfxWB3kT1Wo4fh/6/QtGzVdXPlKAU1FEtmWov0rWH/QiKotFWfSFSAJLO8ytgVvcHrKnVQelP5TwtGYkgQaW79H2yr3uVHwsOlH2K7voEcTHTTWy/4iBDvtK5N4UVId2e+T5GOxDYT4khXrZXakwJkd2rgaJfyQrnrrQC/VjMhkhWSk7fxzi+p2XPaX01EOlV9byMDwYe65hef2Dgzg7Vr/Z31QKUTUfFRrIQIoIA0+w5cIpCBiXRS3OlXwmW3VGaQBPr3rK3tay5bm92D7ouo9oJ9z762IfF6gIXzHiZFh2Fp25c6Y1GM85c2cyFP1tVMhlpK/I4vP9DN41/IfNjWGoWG7K0Rvo6esXCrl/gZM1rVp6oa+GKV42TIs/z9EfSaYGAbjvBQDcC1+XwQZbKm2/7Fi9VKiYCT8EZCeIuK7ubkDhegcrpKosnsCW9OxyPq2h84joIaSdBK/aWQDrQ4cpsiykQ4q/mUiR4rT3/Gk9KJChKY71pv4HNPbH+QT+xo+mtJx2hM1XYa6hvRfOjjG0bdTLnhBFXBJTzq5UUZG2PHts/0oXF
 7nLzK/81
 PqQEJiLTuMNFRZz22d9di5ZNvDBr5O6T2dTlMfmWK4GQ/liBr/LWo7ByfC3SnZJcYgUXFPPCNLaYCm1hixzw0+s1EeTG3GXYasa3duaofMmRDxJ8sIdp0hvcSfIgFoGmMefQFfJRHdqq41DEWxjCb92JdPRftKmP7PTMveNJRz0KjleanzBokUqEDJ1DLeTqNa1BX6cduF5hSeS1O+Kpz95+tmayFnH5G/MPfv4jyCKOX5O9oo3JSjBoKc6hCWNqHmoS+xCVEbITKUJgkRydIfx47rb8uKvUyKcpZhunpMMb12SbRlY+Vy3tOk6x9nnwytASKRP13nwPaaU+iaLdrpM+etdOJQyUwdqbdWJJaSqhiAZM4ejDHuX5togqYlpcEJvCnF+R9fL2dpA56RACOqDrBlaiRSuwxk6PsOLUz6fDFccfYxCMMLupfpnCPIAIarAicv8rWyc7L16p+CrMUj+UIAt8cREETampFyGYXWjYlUmV+/VegUSChYnJdJmYRh/dCw/7zlzHX+93TT/QpjHA7B1ogUZsKhDzDq68bouyoYksnABet9SOnh0ghicuBJ8ARYG7+wG4F6lYmL8OEOK2E/PZlGCjT6AyI6/xefxMAyxchYIa8xGkVmk4vcj2TyL6T8gBsb0O3VBl7MixS35KaEDtyuwq5TYH/aL65cYiPE7GOC6R10YJ6DHgaDzzk8g0WKXk/V1lAjKO80evBeJGuD7V8BAqcSxel8gFmCXXZR3rXdOxqwRyILKCiUMfyeFk6EZmLGaaPNTpqBn6qst2XhXkdrepy8TA89q5uPOQaWxXoVRfu6cCp8aRfjBwvCOQYEs5bjxcxyIZ4fkMjGoN2/ZdCpUrBNJIIurFmDH82avKnXZ8bXdowcGJ0nVlPBM9bv+PFh1TOv/H2L6sspdAegwEHbJr5Ck3rpWiP3ww+PYnztaNRyf88tTne+KL3TSi3VqxPHEEdmnAxD7YTtyhADGNT
 55Z50M42
 5ioqvky1WF4TRQKHPCGgxe8SG5K82IA0NkwldoeTh/j9qyLQoV2FqQ/YW+opUiCJ1YBEOHr+zA2yq1zF2hW9PCnkKYwWVt8yVqsg30p+gJm1YJHNQ2xNAefnTAnAjqRNpdRawQ065+i3MLosvvQB3VPq9ke5c5dYt8sw0/MkNxWols5dpfwNRfE0WeZJ+3JS8hVoSJuNd5oMKR2Hez3Em2PlxZTiC3q4EPv7ZY8TuyTRSWxO40stmOr4yqJ+KhHt1uM7xDe/fCp1huWyoscNhyqHzc5Hl2dASQEect50YYwLxxIo1hzoCjNPY2PoOBC4uhK5rGZx0ZcaiFL9Rcqx3AtwkmmcAQsWHMRmZNqYHZyqf/zQo4DkFdjvy4Ef2K2h0CGvC2IN95qQcsRyBpwy/hHb4mmgvGnf3GFSpS/E5l4HPg04skylGY64XJ4W1mBAkXHDNfB5xJm6KQh7j0xqPPPxBGAZ4dLCnT/puvIcwya2b4shmH1fh5fc92Uy5u1MYDLKZG8LvLx523+qRHVpxBuW7homzCuP2J7/v+GnTkS1Pex5cXmLaPT5VsXJRltbzm5BnetwNCUyFGmDOsTueaAUcmLZYgkLKdSmgLBav8/113Ou7rhip1FAsHoFhF8ufkIOwbDUvJrQXK038F5T9YeWjOGM2auy+rsyVIbu6sLdCMOw/xCi3B7ReUMswiSjJv/J2ejtndX4d1f94SXeiQPz37UNdWOXsLcijzy5D2yW223drKW7pfnKo+nk+qiaW+kDDu1403SePUeXyHE6CaykNJFBIkOggNOajMN4pw9/gtQpqP/GmfJqi1XUJ56wJMCUF6P6+97QgYOylj4ZjOD/91Eh1i6qonGdbzYqjRkmhnMGflAdGoHo26o1DhdR0UxEMjtU67uJcweaLwPsrZNz6yWyirFLzPahxOmvWHCJ47jvx3X5HuJu1m9tW6vIrDPJ0aXlT/XNV6bwofa0lUltCFlYF
 KaCBXMne
 JWOFASnTWCreeoJQxD2pbAH1iHD/hSrEweUJkYMXfsFIgeBJ81KTGSMBXlrGwggazXDXaKY2Hb6f3WgyM9zJ0oyZ/32S5FWul6ZChITBAHaIhXZ1lZNlhuAzVDvRcg+eHeJEJ/MJfHyMXfEmjcPtIQfa021XFWJ99PVbUOErFbHKfiozVOghHtR/Hh3x8tuJ+NJtwFB7V9tanrUdAbsBuFHlTHRM+lRjlZOw2WimQfkVD5X686+OZ3SgRrXio9zQldS5LIDFl8nPmZPSQSJrMJPlJnd2w0/8PPLkm/tUAZ3BoRy1xAY2A8yzlA1lnfM1H6xU0PZHo+bB5ROjQu8Znv1fqBoqC0HAm0L+hBkmGe/ApcYoGRXlCdXx+JoBoI50BU3OntK8Xxgz0bCseRz4BuPNPLzF2HiRvoK1BfGY+GqDKfHSACjIVIIJz3kZznMMCcX0XljiVTB5Bb166LSL/U8So3pFX5dQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to keep a fault handler around for this, instead map on
mmap.

While we're here, rename area to vma to be consistent.

This correctly makes the mapping a mixed map mapping.

This works towards establishing the invariant that only PFN mapped or mixed
map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
VM_MAYWRITE, so it must not be mm-managed; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Acked-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 sound/core/pcm_native.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 62324282fcae..c98fb3df14f3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file *file, poll_table *wait)
 /*
  * mmap status record
  */
-static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
+static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
+			       struct vm_area_struct *vma)
 {
-	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
+	const unsigned long size = vma->vm_end - vma->vm_start;
 	struct snd_pcm_runtime *runtime;
-	
-	if (substream == NULL)
-		return VM_FAULT_SIGBUS;
-	runtime = substream->runtime;
-	vmf->page = virt_to_page(runtime->status);
-	get_page(vmf->page);
-	return 0;
-}
+	struct page *page;
 
-static const struct vm_operations_struct snd_pcm_vm_ops_status =
-{
-	.fault =	snd_pcm_mmap_status_fault,
-};
+	BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
 
-static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
-			       struct vm_area_struct *area)
-{
-	long size;
-	if (!(area->vm_flags & VM_READ))
+	if (!(vma->vm_flags & VM_READ))
 		return -EINVAL;
-	size = area->vm_end - area->vm_start;
-	if (size != PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
+	if (size != PAGE_SIZE)
 		return -EINVAL;
-	area->vm_ops = &snd_pcm_vm_ops_status;
-	area->vm_private_data = substream;
-	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
+
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
 		     VM_WRITE | VM_MAYWRITE);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	return 0;
+	runtime = substream->runtime;
+	page = virt_to_page(runtime->status);
+	return vm_insert_page(vma, vma->vm_start, page);
 }
 
 /*

-- 
2.55.0


