Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E26CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292E46B00A9; Tue, 13 Oct 2026 11:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243186B00AA; Tue, 13 Oct 2026 11:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C466B00AB; Tue, 13 Oct 2026 11:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D397E6B00A9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:23:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 172681C39D6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:23:58 +0000 (UTC)
X-FDA: 85317973356.22.638EABB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 569EE18000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:23:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpS+mpVY;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7y2wIWqJCiD1mq+s6TBxosGhEbO2v5L2eCG6r27DMpU=;
	b=mxrGwk0HeQ1n5r9awXpdaJMvqV8MSY4FRgvXrrCcLixEKzON3SBjO3nsP79p6NrsSHtsoi
	OIO3YChnasq2Ei9jw+E/iCeE+fecCKBwixAd5/vWaNctb99R11SrjC6qgWl+QGYofJL5hL
	lc5P/H2p5be7oXLzysEsKH5dmaLkvq8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpS+mpVY;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905036;
	b=p+QA6xYHuC+IoeOvKkok8iyYTnmro7izbXjXHPIQ/fdZNlPIMalBOhr0KS7AJrSva2inBF
	Zy8Z8G0YQk+NreprRhJvPgbwmEZNO2qHNiGtcRhwnltsZxN3KjmhwD7KW7I0h4TLNz7bvK
	k975Ta5FFZDDGfg36gR5U9qkMOcyV3A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C83B260A56;
	Tue, 13 Oct 2026 15:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B4B1F00893;
	Tue, 13 Oct 2026 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905035;
	bh=7y2wIWqJCiD1mq+s6TBxosGhEbO2v5L2eCG6r27DMpU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UpS+mpVYglZ2uQ8Y0gUiTHbNS/0eEDd7Gwfv+wRB2nSEO2XMk3VHu0lLw8WX5Nzau
	 rLTnwY4XWigTuG7uotEX9nfLCoVecmAmu3InghlgD1rBuvoo2GWVr8v6sOadsS5IEr
	 iz0nCPzqzFnmvZiXcUtWBPrBzw1GbZoG8AoPxB8U46gn+d/1CwYNZX6YKYwguINq2e
	 8THu+sXxGFvDc+V+vMk1SBQ2uFpYRcozBmBOSMEGQVekjATeQmAcTO0vLzpzFrTegE
	 iOcGaxq+DpKTc1omcRjjergbjo5HioQ7nc2otLkmw8DVLA1xY5Uu99wxOdWjD6cx/d
	 EHXf+2qQegEUA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:14 +0100
Subject: [PATCH v6 34/39] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-34-1aa3c9b139f9@kernel.org>
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
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2691; i=ljs@kernel.org;
 h=from:subject:message-id; bh=SFuIDIpM5G6bOlnOpFKwrzHC45i8Mw6xqs+xYU2jMdQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZwpSmyXEo3qYn7jXSnc+221yfFkrkVeqhFvf9/KP
 8kcEt/cUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIloL2P4n8c95VPXF85Lfmtz
 +85f22G9407naxYuA+Uv3Ulrvr4/EMXI0Co43W1lDcNj3cuF7bnm3SsuOVzWWLd0NoP8F13+oGJ
 +LgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 569EE18000A
X-Rspam-User: 
X-Stat-Signature: 6kwy4tp7ohinmxwa1ts8885wf9z8qe8n
X-HE-Tag: 1791905036-449399
X-HE-Meta: U2FsdGVkX19k00G5QHnh+Xqx1My+aT1lmxlO4i0RZmgcqhuaSFTjO6737/lqDGlFqrzlRlkbY3mw7foVtT8CXrfVCgJARCDPiql7uAWyhkhDOPpiekAFyg6x8PTqYIgO4sucwP5VFvxq+i4tRlIVPEc2ns9/5EpfrUAJZil/ANHmTmGfLJWNFASytgbHKBYQaif09m3P7EfzF445PtoCtROjIrKHfJk8/ApAs8YiF4WkQ52XuvFgaGcNgDB9iMzXPIQz62J1EWWnhVGSVqYLZW5eHypDlsHsFGMdalZ55jBIpS8IXkRpJ4CpQ6aQRRYk7lrhq3T31VDluKxWSjBAqQD/KbuQSonuMPHM6PngcDmwBA5fq0EaesfV823tuvlgUXwiBzq2KegbHcFTvOfLg2ZmER3/tGTmAy+QHMxsPQFGjZwmhkMtElMfI3Wr5fq+r3VlBrDdWpM69jy/tKOO17z7/4g35vJF9pVmI3oRPTyGSUB7+0HGTQ9IsmjetqL9Pd9yu3GVuvqcFw77bZLPJcC1zRn62ojQ2L0nqd3WZyx+GtBwb04GYrtzCaEcwXy+w9k1P6IfA7+IDf4RnFEFu+0MBUZUUUgM6ldUJPtqc0J5Ztxm2ffiq1DpY24aGYwU8G2z1apnYAfu3zZ9arkd9s3T3oSW+1J+V8tixp0GnSgwPal+I/dFTU7hj5RLd9r+oYTa0R+14g9YgPCc3KBHCZi+JLjU7P5XGOPfXntyV8FKox4qsNft0gzIqryWZsWyNtJbdNRvdEp+nEjQs5nGylQ6wZRcizE19TVIC/xnVEECglqS8R7LZMr7YaXiJ1FdKMoNqdTiMVwcRqJWzSFc9Oxo+KEZ7QW+S/r61vrmf1N+iTPP9hllHQExMM7e1X8+H+IGQGM05fdkpapVtyZA7jz77ryjsLD2oU+UWLtPbgjNp3nnH04rCoo/rT3GxstS+iT126cC8yeHihJntbW
 FRDKRmEe
 PRXQC9XzmQWZBn1UYnhLMLvib45nDe3JIIcqrPlykTK8Wd5bNtgDvc4f6jGYCWScL8A/0H1pcLNcLvQV5i+n9oAdCBFGXdAEWZHConywjc7RBCfiOaN0ZLbUB5ZcCk0hJubsUFeFAJh4GH5O9Ix4K2PYbj7cDE+T3Upa7gMwkKQjrwWSpjsQ0ApAEHjaXZaLCdWZpdyxVkR/BKjyzsPeZOpFTmy8jSqIeiBIJBkVCHjDmO6rTfEEtvpzQk/sLc6Cyusjx6gvJecACllIs4WjncUOZkmM1GINSIQPmPoIpVgglhJF8P7Brs2Y97N/CDN4Lf7HiF61JcN/9rFqFf6DkRPkk4ghWlxPvFChO0qeuXxTKxlhB0yh4Ajvb8LwmkvcMvxdaQhYszm1OsZFObk2er56aa1PbMXOm8A87Wni0HkHle7YqLn64TeomGxsCZub7a04z+LQWke0BpXMoVutlUJn+OOITJGHZxKA215FctOwTQQSEOCkG8znhMfZIwlZyJgEc/zv0slJvOjM6uSi158y/CX3ewdTn31csAgQDdfp0ejveQPqkG6/YM/+TKIdq/AyEFfp1OpJYRJlcfZkYHUT7khRNV0sDMBjKxYHMxXifT6db4QfYkar7hYHFIL2ETUkySE9+2qXjtX9YfORodxYLHGzeJ8ENqXxiwlx7sdM1gR2Q/BfQ0fN9n9K4VEe2+nUkeCSnzgVrnBqcCMN9/iY27N6Cy6sAcqZUpc+ywA72ww8RUPaiGF9raumyRf6H2wMK9j8nX+JrodcB/2juSFnqxrj5YFEoNgIDbh0BPTvoOKkO0jhPhOrgUwoi2SiNYptUl4hmA6RDLPPW8WhLv5kpyxVFJjW/Qcz0oQMxmBeppVpHAmqR0VKc3b3Sntc4QAJpT4hMW0GtaMFJqJGOVwmF8BHRPgXVrhICY8OJ9gvJHb2+7OEsCyAwA8+J2hQcIaiQVb6PVFuZwysBcaQ0wEdUq29X
 Mluj6mTs
 0JOtmR3XUs2NOb2/E41HgaFoIvKRf2Jax+DiKpmeWM0V56vj0W1Ap0EcgA9onad1ehCH2rM0KKinGFnd9QvJ11fGABDxiMnvRtBuUm9CHP1Y7OUIFB8Qc3bieaAPfri5Wr/+aaxmOFCFHz4vlpzDas6+kSdfJfI9Yv0epgtGm1eViY9qOoTnqyo95hsqNpPjHzstbkPPez47Usk+GxVcX6XUdbJi0k4QRlXWNpbMeiWESScZHFVrpbhLFbv4DTQ/Km52KUf/I+XJAG6mcKT1EA5EQ8F0SKK2xmiBpoHEKuqA2vc9pP7dRf2BUBOujsQ+xuXSfKKR+FtZgbl6Opr11reEqIePuAghF9MqXTVW0UxVlk7m5x8qlxErWDPcUnf68AQYRZrrXez/Z4KHoDNEHRPNny8xpPv9W0fJ1xFCf6XHIuinS+1Ri+HBd+jQizfJeXmB1913tY7WCBf9gXOwKxhVh8j44lnhowemSKJex8P+M513ymP7R+4FvbmB+l7q3Wd8Hhq2OMp7V8l4jevTKZz+GsU/4Rn+nHeMx6WrsDSVg3c1JNecHJLPWh5dmIDN0LNzIxOc4eCAKJES/INCbhiJtgKmWU2epjurTuQJdA1Clo0x8pYe4hzyi46YWUMbnLYoE+o8yAx2Ity2yBxzfZn/2fX3mGXmyB8WVtrkY/Uz8uQfMkKG2YIfzSqeQcLWPs2rrbftVVFzeB/xqWmqeFMClfKQyRMqOnLW+r2qDay73rmhphzNxK5QcLHCJJQR3XIzy9fuSEp9s9a6Selc70FBRYELD3HcI+zA+yP8HOoRPBj4cLJQ+R1TvfBtwcg1tUbU4io1qAz+T4ZBvk5F60MuEiYFppbhhy61C9gudJBD0fc3+dOtqZsHX3k+mrPxKcfkKcOgOfbUffQk5Aba0sVqIOB0dK21PHvtSxi/lYCoLHGoocX5S2a3WlezDv7LEcc42n7SJrp365L1zcK1Wr/pcAMyv
 tsEGzXIN
 k/SkgRTc7sxQ1E+n4WvoCAKl5wFU8Fqq4oPTQ8JFDLaomObIJ0uztP55edOsaGIKVT1AGSftSUJcLFrfwG8wlqH+VNB2OvjRVskme2vwzUD1Wbeppl7AEO4expIcfo+tdlG/uwq3BGh1jpW10F2BN7xjT7deafmiN5igjX4uDxVROSV86JT4lf+urYASEJ4pgYh9BBhZcgbo5Ch76jQ4MmBExrSAambaAbUVjqXd2sQP8mS6+Qk6NfngBOSHRrjxBSCPH8mo68bm7mua2KHgEPjXQtav5/Z/kbVhiNVvdT3tM5e3lSpLIhuvIaPa9SuKGuw8qxuoG6JevN/fhkput4bHNOMxgRoK2QQ075iJaq0OxfYbFTOxojsWxdJdEtIaoT/DaChuqIbATc+rr2rpY6J5SYeoBMRcTSxyzUcAdKPZTFaB2l8me968yq2SnsdvT6PT0qTWiAcxtLjNKOnQw6yH+SrDtVoGc7aNHXjxdI9gMxv9V05VWxfsHKixnXgIqa/XIvR7JJmwMnyZbXxzi65jnH+Cg6dhAGyf1mnaPCMm/Egd5SOuUglYm+lxiZCH2Nh1eYb8My8BvMWXvA8zeoicNSSBQVeVgGG/+Yn9ewoqYQ4tmekswiV+qwucXxoZCqULGJLFthf5ewbtRbpWLVW9hc+1lyO20CAJkL/aSMjkusgK9YT/xPfN3/EAkPSAFRK2KsfLAsREQeDY5H/n13H4nuk0GNZ/BOEJJC3QY3lzcfRRh8FJuoNaPIKSVQKDHxjSWT/D+sySe5+3qA0/G/2CA1ozPyL9G5L7nokKoj4jbpySc8mt5HFgQB/Cm3C49HGJN/olJp4snyU26m6Fk1WVy+U8ox4sFFVFIYUiHn8XmR7rwkOaO9Tgc4JzXJrCxzwv401tp34WYHbB3q3UDofEU7FKIyj/i8Z29j5maWhEFkaGi/26Dxti1czKwgKJChpZT1lchc3+7BDIf2JMq9v9m/ZVP
 hmXkWQoP
 Sf2ztZGgOOAICBsBm2rpqvjuk29Oa4Ijxpyi/865S3JEOqw4L2cBIjbXarzMdFu+KNMpqbq0TwvH3r/mN/K3kwq7gdtmNuHO/4ctNaHr4EoPTUrm/enY6jO/Itvyj1M89Cldm1WoGmc03UCgqfQ1Cri73SP6n15HYIq+T0/kPr0+CPap7knD+OrxogypoytM3yTfzq/9ZyfKGJddvyCD1MihLoKlnVCIASNn6G6iUArIP1VIYzh1mF6YBiJ2KqlPwi27UolVYDMpnaUMq3bdBHqV2NW+jEXETsbZFLG0tzB4D9wH5HoY0lglSfzjIlF5KqL6KTCIhXLD8nj8c2UCyv+cPWPzZO+GVeURNWOgwASQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is now an invariant that VMA_IO_BIT is not set by mm-managed mappings,
so each existing VMA_SPECIAL_FLAGS test need only test for
VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.

This is precisely a test for a fixed or non-mm-managed mapping.

Update a number of callsites which already explicitly handle hugetlb
mappings.

vma_supports_mlock(), ksm_compatible() and should_skip_vma() explicitly
check for non-mm-managed or fixed mappings, i.e. for !vma_is_mm_backed(),
with hugetlb having already been excluded separately.

So update those to check for mm-backed (and add comments for the retained
droppable checks).

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 3 ++-
 mm/ksm.c      | 5 +++--
 mm/vmscan.c   | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b5f7be8f65d8..03f2bb4c30b7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1112,8 +1112,9 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
+	if (!vma_is_mm_backed(vma))
 		return false;
+	/* Core mm may discard droppable memory at any time. */
 	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		return false;
 	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..df4c5199f625 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -747,9 +747,10 @@ static bool ksm_compatible(const struct file *file, vma_flags_t vma_flags)
 	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
 			       VMA_HUGETLB_BIT))
 		return false;
-	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
+	if (!vma_flags_is_mm_backed(&vma_flags))
 		return false;
-	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
+	/* Core mm may discard droppable memory at any time. */
+	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
 		return false;
 	if (file_is_dax(file))
 		return false;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 12ed3388ee41..aecb157bc379 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3477,7 +3477,7 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
+	if (vma_test(vma, VMA_LOCKED_BIT) || !vma_is_mm_backed(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))

-- 
2.55.0


