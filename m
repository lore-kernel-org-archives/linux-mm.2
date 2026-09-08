Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DF7C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9F16B009F; Tue,  8 Sep 2026 16:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD09B6B00A0; Tue,  8 Sep 2026 16:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7FA6B00A1; Tue,  8 Sep 2026 16:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 838EE6B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:05:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FF2E407C2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:05:23 +0000 (UTC)
X-FDA: 85191674526.15.A66C1C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4958C4000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:05:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChV4bRWW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U36DZGnKOUdxM7zJJhG5T3WAmK0mIYPM7XNxAdT+L68=;
	b=sCuqO70Njefcv4KUCbI0qbdfoNK60ZU7kkM7tlnLdH+LnKLOF0zN0Dt4BYM15mbgh3rRv+
	QAsiHsX75/CYwT23wnZrjGPcbGF9NbtE2j/h9r19UcRmyNwG4nqGeENAENSP03cgfprNxc
	TMwyWmzFgmAl8Wv1hBlKMHVPQ5Po0Ys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897921;
	b=oMqnYBJyLPjy5cF4hLtVreKaGLvxXGEtOnWFpApmxD3kp+djzQOifkJycrOnYS5alDsZex
	WCMBUlyBRAJL3jT6u1UadG2yRdFEukMVEV1qCWChmWuWfkP5ESuPdmSRGkNJMuJZltpg+3
	RMSTme69zJl/mKLTA4LiZx1gcj3M4dk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChV4bRWW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A149542AE9;
	Tue,  8 Sep 2026 20:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F2B1F00A3D;
	Tue,  8 Sep 2026 20:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897919;
	bh=U36DZGnKOUdxM7zJJhG5T3WAmK0mIYPM7XNxAdT+L68=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ChV4bRWWxR83B0qrk/BBBiY+oDL9aWo6ayFwYes5nSucV+Chp306BmAdi1w74jlQj
	 SGsG2d0q4IfMdE2/dllKZ0UhcIbPH1Z1TR9DuV56PilgnBu/oLPJMYrua5iHuhxLIs
	 CErXZ8fFRVcaj8nl/3Ta31HHrq9+mW2dn/Ps04f0XsX/rcUzbLjfbe852b9g55fqVM
	 c/EWnmBrMopK5BilxfqBAy0UgCLsgprXc+CY9azvzmSJLUK0sVbMOITXAsT8log5UB
	 Wg2xxTQ8fLfP9yL8TUOlBruIZhxAUG6ToyHN+/qw6GVQ9IPXBoClkpN0JoarU7OlIb
	 I4V/LAtmYfXEg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:10 +0100
Subject: [PATCH 06/39] mm/vma: tidy up map kernel pages enum values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-6-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3944; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Bv4qXKOuaaNRzjtlcRyEKTvdZCxVUpR8GVW5J10sIxg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7ckONmolgSWOfS7npbQePAQ49wAZ9i2wz2yYocG
 hsvrinvKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwESctBkZpt6apZK9aOfJhE1r
 1gq22q8OMGJpvlrzdyJz9OEXYXF3PRj+51WFbDwuK7hqTxhXE/+R2bk9G1oVbq5N58hdvzl1lZE
 4PwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qqdb8rnpakxunkxwkui3qesp4rhi6x8h
X-Rspamd-Queue-Id: 4958C4000D
X-HE-Tag: 1788897921-989777
X-HE-Meta: U2FsdGVkX196hyZ0E7SH8XxGa8Uq02AZDOlPPxPd6QMNCWHU7rUyMLYBOOKwvfFJMg7/oE317krua8OcbcgjmsIApHs1Uw48HMqNg4rf/J2wO8rkTfFADB8yzXOZ7L3qcNelHNW4YDp/y3tvQ2wKQwNYEq9060lYdaNJidqF8MqudHm5ZtYt7yFN/jJY5FIb7roxKGCbEXepf5UvfvwIu0AYZqF4+jp0Okvu/88r5qlyyDH4ox4CxaNliVL2nXoexSuWgOd3QrRhYjv7F03FJbId5HExubVUL7LUyd69vC36264hHRwmQfXVrm6K160tjnO9j2RVoYRNnYOeq49G90ZQ0ey5Q349vbFcAA1LbEbmLzZjCc2zDfARvpP9N67w1wXv7gbdY51EiU0gtLGkwdsq+fW97mC/P7KF8E6a+BWqHwn+9cM+OzGqYpicW6V/1vv6R4dmUSX7SpzqaboveawEMz5nprnwEHKhdYHsASdLDo1GOU2IUvhnkYBbrn4ZK0w6Cm89itYZ5iyahlv/NSj62iduAmpTq+yH4BmcXAL9nAaVQ8TXad9AgVNZpvKrMHOn8TBXKXlDWE8Ps422t0bcni5krMoS18qd0a44Cp6lpHnhoTq7Kuf508fU/01BwY1YFAnZtvJPuucv4Osn9/Mz6O7KErvstndjDv81SbQgM8CT8CJXS7qvArqeqCsaJcQ3q1im/kgBXr8NzThku8n8ij7y/V3jUuoq2GamJqAk1OOVugJMOdOswwSj/th6EKP67o3jInGpLq9nUPOSRYb36ym6vG/S/PAbw1j4dFSSDOq91STgUDDi7UhBH4d5p8kINU6r4wF2mCmV6gbWiVfbxWQLNpvsKW2aVhxhifn+QxlwH3axooltrgdv1XL4+Rda6iHH+ewMoZ7UpjOyBQ0fH0y7KeZKN7Z97p2bXDjVpiXQf+k9emCBisumNX6ikpNncdPNeggCQsWAvjn
 MAG7ZG6u
 WC9h1Q1Y8bvWtuqvV1/JSOyGNxkHpUSSTIeKAdYmqH9Td9BCXG7H2cD/iz8MSVNtuSNbYP35INBhycti24iPkVfV2Wb2292iLHX0VDlP+8YKt+h4i2VhLJmaX+ZgqFBJqhthOtbfYJlOhXcF64/uJKWubRofHaKZhu46Rb3s/OJSuUEaRJrOLmA8f7BLLqklosIjNJd8VUExIhKSfjwBZ7eN0mXoBLHlwFmrTdi7ogxfaQfu7fJNxf4aBoUMdU5uuJ2VBxI59TkybX+tsySnPtpjkxZgvxE9C9hIE7u+huJlK5faoN+ykK3GgPzWBjrGm5AdztcDJyoNvlK62yhNnyG/o4QAPUoUK9kq4t1EQ1hMtTZVZt47oC7/hjUQinMTvLmyF5vo/olIiyQ1KtMN03NRdk9XelmVtcYHbJWcZ/A+ZzAtUslt9IRl1/Bd8xoXD1vmJGiRpCXpI3okhGnkf4e1SV260Bz09svvXa6l8VMl+hnwaEhk/CtGyZwXsCDBp7hlxvXP13vaoS9033i0D9Z5ZCIZ7HAcUZETHvbvpNeNCticH3gmpGCU5DQoy7k+rvhCwxzmJ1WJwgj64BCYrFCD4tB7F49lDJnQWmJnsCagHEQI/rHBD4LUDwoW+3NoNCI/DO9hx6DzZ925enlyNxKxO3Ie2IDhg7Q/1/cXtvaoZ/DEzOfYSlZINYfnUIwvf4lSWmWXOFNcl0b4P0GEsaYp4Vc8FHpzodxdsGGZl/ltBVbte74kU+9yQ3NqvHboZPu5VCBjM9mHT/PzuhL+hj0DGjlJUywql2Qj7TRPzcBMa106ekHkeuki6MPSt8X5AFtxBKFib/jdSbxGprza8cYiGQwfvzzvtydRBMVXEmb70JlVLEcRcDIsTiWVyDLjKwTC0/yyOCjwen9a+f9Rb2ycBtvWWjizM3xu3/FIq6yfQ+pS8j+eFzjzV0UT1Wi1FPf1COD8MlpUzkX0FML2JbvJBobys
 kuxGqBe9
 fAOS8sAPh+WAtKQcbYWMt+DyB4boAme4IjA0kQvC9CagNSDdCWPvZ07ZJqV0x9Dp4nHamw3lAu3Rbs6JSZAVzWLNBDSInJG2zy1fJ3PmyZ/0cMIXmfMHpD0D3SX4WO3s5r3gFxJ4SUvpYSJGhGYJe9aCHaJwwtrH2CGJuEV+m1RZLuipbTmM/98t+k+A2mUbW4C0Khw8Wl9f5kkR6dSz59fgcdw8ZnaUHQOLHFIkMVacf5MDdJCoqNlJWjGsA7iNrzOjKVcRYuSpOpxNeyrhK8D8MuOI01HzBqzT94UHy8CLvJ159Wi2oNPXy9B2HmEZaYN59epALvHQzxzPcEzrBceXmP8yV1WPe1QpkQpURy6ZNn/raT5IChvfjeoU8xXeGSrcJaDkMJnowrujHr/wyTo1WRWBTLu7+5ukTu59sKwTDDlOvytiAZVvVdKjvI8k5VimnK4FZGhY9qwJ2fEXx5YkNIBMjjLUrSbJm7VUmaaIbMEIc6faUvKnJRCgon8+58VGauBuQIqoA50jQfL5eovAvIYeYYo9ZmhgUn6fCu8pzt+Tz6bU4Ix/JJhuSrcTrUKLGm+z81i3envlo62petoW90f/aB1RDV7oLLbG5y9OLDrBw/JNIxjdYhq2rl0RNNiZ7R5bg/digFljPCo08FKhWTJjTWcqOQnpz20uz4L1eE8sZcM4DSlbyVJtblie9OPCYOEHxf/7aItNa9JOh8ov39nhZwSnLXqWoVDZikO4OFtZeNvXg3ncTJKP71unutRvNHug5JCdDmY59QNMo5/TkonLcv5uTk7rtTnC8AQWJ/cV036zM+iZXygkG75YpgTEVoB45/Us1i7RdYITfAhYUB/VJl9ZWcl4r0DMgGivI8cGhH7iirs1IS/xMjzuH0jGz1gXjkm/umxbouqNrRKcDNiblFZP+TCtr367VLpqlQS2KTacLzgvRiFtzSu4m9X8Ol5db9XKBLbgwl7HdDNAstht2
 EXnhOMfX
 hl/b3jBlQ9bx/jHETQnwCvwiQmbn4I740culdfS2JiRDPEI289S5vZ0C2RlgEpDIRJygOY04RUjr+47z3Q4y9ImW99WNFpQjLcoWIXjuhXoMX0MWV+SsP40Gx3BzosT9jOD63EJ3tXKl85VH7J59CVUfdDWT2bfrzVTDqNtXUmDFsAKfYJa7gvNswCZuk0e5yT7txJ9eF1J37IzvoWYH+xbnyeKim21FntE6ZQduKG+aFm5gzJmqOD5MhzPiiXDPAA3dvhPKCrnwSPwKpdM3OJ1HgE4efMx6XSiSyQQLQKiWQO4rIEzch6+IzPtf22GcugdK1IxAB5GApbOh+ZmyotI0IN7GXShCHL23G9HnHuKKdcA0ffoKMLPRG555kcr7kMQCzIb3v/6jNX3TlJ5n0dSHmLpC4q79J/tA5IBhybXHYPpzbwZCCnbcklFRkqp33HGe+/RI8IW1dF8ymn+PrQeBfIuXcfaAJnJoWbECOjfzdx88OwVpswL9eNdLE22w599MPiVcn3K/JCZTbpIGDh2z+d3p07AksCwrNA1qOsU7DvuAvJaJ+oABKtQxYrHU1T+9UC6KEk3ZJx7x3FtjdRT30aiTa/7YUG4r1WdKOhAsC35v3Fp+bZIQqMvFcXzpJCJgBZfXZ7box8zFKi2Yt/Xj1PLYil7OnxjkGFjZG7ADOhTLkL1pnwDxFJW6a8NGmgTS44fOoscWo9aijZkvgJH7/rV3j/nLYSj/lor41V9z9RIi/LEYTah0o8a0PeSuMbZBu3DQGAkt5f9oLZIujZYHvb1Ej66GkSIEBygeCKhOjj0FVXL+RC6tkrMugYGzw3N3tEMAp38jKUEKameeYQFl7zGzT1ZRBy3FX7ElTlyZMU5CKkFFUeuyqsTBDXU/NoedkZvbHYX2r2Q3NuPiAwq/YNRjCmUwL1qdB7MpD5Xy/iBIdyOQBlqhQtxdJctuDFFw9HNiCxNuNKlfNqQIvTkkWXlqV
 qkXfKKHg
 SpMCeGzaTwb9pMff28R0cLTq2DJG5qDZW79ko+nbqK1Lk+MSlnkQuvmZ7jMNFELLEflfuin4MhA8K3nPRBcp16bVeDhaSRCi9ZCH72Xu8Gp8fysiHfwLiqwT9EncBpFtkmoeIamuYI/3x5/kPtdYFN1DVqptpVGxQ/ZhX1fnMBxDIFFRegboOnZuMd2HXGstePrJOCIEOdAk/HaTcvYnwMewTHagaZa8vaQJ+QPsPdM2kAyI66N+L2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 2 +-
 include/linux/mm_types.h        | 8 ++++----
 mm/util.c                       | 8 ++++----
 tools/testing/vma/include/dup.h | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5709b03b6ed3..94b860b8c50a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,7 +4623,7 @@ static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..9ca2ea3664bc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -815,11 +815,11 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
diff --git a/mm/util.c b/mm/util.c
index a3cef493ed70..b6f1bec9da15 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1462,7 +1462,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
 	}
 
@@ -1493,7 +1493,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
@@ -1516,7 +1516,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1537,7 +1537,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2986ae6ca1e5..1098655a5f4a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -454,11 +454,11 @@ static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*

-- 
2.55.0


