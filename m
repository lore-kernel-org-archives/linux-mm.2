Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB135C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31906B00C5; Thu, 17 Sep 2026 12:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2BF6B00C6; Thu, 17 Sep 2026 12:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83066B00C7; Thu, 17 Sep 2026 12:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 852246B00C5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:41:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09EE4120410
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:41:31 +0000 (UTC)
X-FDA: 85223820024.09.6427B7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C9ED100004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:41:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2q4yDxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663290;
	b=Qcmgcs48HYQL8v2ydtDkB0t/9GzQ0AKUlWaws3P0B85w0gaia6lqcPrYvkx0zUcUfdLznW
	tcJrVXlU8gatZ02TjHqo9nZXU1uqLvU1pfp3tGE+gMizD9MkasWvwBeFNooSzYgv4YxkZq
	t21j7dPxOMiRq8emx2w0oOlx6z/VEjA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2q4yDxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbEvWuDC6KaxDOww6JLm5X1oq7s2JCzdjzk0eBTVi0U=;
	b=rmlLDGz9KW05l1lFlef6ZBJsGk0WAUq5jG440FyFhk/8Wi1ttw1WzHGVpKZcEcIhJ8GXD4
	OmupeP+saiFEeO1riOf1gIETJ2O4ut8gTYAgJBzByvuG8sDTFtBRY6VKgHt5exgwWvFKe6
	lEOywD7DPqzjDYXE+aAP6KcCFJR5IK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5905840A32;
	Thu, 17 Sep 2026 16:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31891F00898;
	Thu, 17 Sep 2026 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663289;
	bh=FbEvWuDC6KaxDOww6JLm5X1oq7s2JCzdjzk0eBTVi0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V2q4yDxEwjCNULJ1wnapBLzBV559XXPol46rdR9VnEF1Is/X6FPfAsqnicDy+a9B2
	 PSf+epomDur9Gilo9l4e/Wz59jWSIU+Ydc+44/ZAn7DJ+dw/60hQlLhudXXu3Qlq8x
	 tMrZGb4wK9r9aaOwAnnTG1ulaN+DLMUUKqW03DYaizpXlTp6a0JoSEk92vDsyfnzsI
	 PweH4DrsTaFoQtaHHNehKk2tI7J16c6Mdwgj5QzFv/TomdCYf5ZNfw1xR3xvXC0GEi
	 bLvpD8QTRyv9RsiDKNeF6TkGBv58m3jk7H0mwdOLeILBOknknZ+mkfcI0qpWtTqE4B
	 JJIbh6yqwtf4g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:45 +0100
Subject: [PATCH v3 36/40] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-36-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; i=ljs@kernel.org;
 h=from:subject:message-id; bh=12r+57hlfcUqhp52wOQ04zakYjCIf/s1O/YwMYeI4F0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9ZefTW43MXj/f9+j7r8s+fR3o9Ze9l5QVPPy2x5
 GHgjpecfB2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYSOghhv9eLyal7ZhkPSnX
 6OPt2rBFT3+evh75KH+1fu7fRLOa+3ELGBlOv+PqW9jt8ev/jfvbtvRLHJsX8H/DsvMWucoiveV
 RfPJcAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C9ED100004
X-Stat-Signature: 5fuo6e6edxcu49u6z5ns7yqao9k6wsj3
X-HE-Tag: 1789663289-585078
X-HE-Meta: U2FsdGVkX1+MdALBjwXeykcRsN+jdIhl8LWMjuYGN2nkEk+iVeZVZaa1PGplAHDvU9Zx98YNpYiwN6dihCabsv90MiZEga0uE6NZ0TFiEoILazZ+0qjmOwEw74Mo6xzksRW5I5Dtgr2qQDrCKwAMJMHGnWkcBkfq2GArex/Ao+dk7QIOF5yAVMkM9dzSTz2tR3HOMnYsu5lYUcywMLYJiHZ/R2BnxNHpcFBW1HgPq4TwDWIDJJK5+1q7Ormr/SjH5jrcSyklRqYUtOn3xXDQ6Ik63taVBZGNzCCxDdFs0uXZp+chevBKE3yQyxviFIjVu/YkVvCsCx+IYMdnJvmYSejX9Sh0jfSOpqEZxppnOhcm1bCv+7Z0LyMifq7CTX3lTFxfc9RVp3iHrjdg03l3fOywQTV9hRrQt/rbFArXPbh5gprh13W+wQII1TvVP9huy3J9Cx9O07CMhlgf6xr0MZCE1RnoXPyLL+HCBYlgmhnhWhBXNy/zISGBvdNzIx7QhQZ/pkGKTVm4VZXx04ezY2bpW9lkj2QLOMfgJ7MNc7KgUXkWQiChrgbgd5i7OmWRi7jDSPILClaeo1qRMS57vdz9rIk4LCtji/jttc/WMyE3Wn2BENtYeKYzwJPEC3mZcDQhVzyTiNKwCGl1N0ejO9US6Llq/F9rr6Ox4xqKhbMfFwy1GVZ6VVtooaBd6tWPyq+dSwHBLjhiD8vXOc0MLs2NwJOKvwsMUYKeE2V953QNgKoIBTjOHtSJv1zeYWTeK1HKh0NL7cU5iFDpJDKXZJZk/m9cnBAvzHWHof/OwFavdr4Bgz1pcu1J4HvsJniEYnfKsW/OdKEI8VbyFOtIZ/yaA0ES27b86JXDvqHlKSpuFnxrNt9CEbD0I89PGjg1qh+1ZV7Py0LnCzhxQSd4JnEcZxjIEPfW+V1zsmOVwPCfGJBDFw36pqxM0hQFVo7T650px7CgakvayREBzH3
 pvwyycxJ
 mab49AX+EPOI3lYwrIPTDm1RVkNU1M5NmvC56/vQqrPg/t2dj2XamxQUoCyX33sbpz0au/aHoX7lpcGM013Y0GF+og4Jo2n59fz2cy8JJd52bt2amPqgawD/8v37k5yuqXzF/HQCCQENFmwxv8tC1HYnz+c2zN6n9a7tNzKseram0Amd2S/c+Lo4RGxa4GDV5DNE8OodVdYtLBbH8yTqc7DqcfPjBnZXyGlcUCS+TmhqDxVOv4jeTzZDkhZwufvpxZtxAfMpnOzCdTGOPrwvHCq+dOyGHtVXySnCHyrWzG9IYlByk4Ch3HvJwUHuuFiQ6EzaVYkbdyS/E/VGpUXAy+2vduoO8sxPf5f/B6DBksjwfpcmcJNuTS67oGYzTlJ6oatipU4r8DqCnaCXRB+k8du52d7ra42H7/rhOyoK06op5grqHLUCLWxlfULQXjcgG2OVhNRy0d2NBhrq78k6Js1hT+fGzs+Fnygqq46A+5Sm+OakIvjzZWAQoPoET0WqPocehppRNSytxsih4yfNxXixFVegcECCJDdeq4bQCDBJjjnIHXb0cb8HP2FIegyFAITElb5u9y0zdwkh9LuCjQqmZeYzAyQ+/IGzdLGSH/hJhhNSm2BAaKc/1/qo5GkcaJm1818fPMFe4mHri9b9mQUledKNNI4UjNS+d5vTw3yqUdUnp/q6muleqDcUOwQtmCW57Y3i4xZbbGYu1bryvvWaTCUbv6TcKjxGQmsQVUMOi/LUyE7GmtS+D4caCeOcDIqKYep2tq1wEiNEAxl6ZnBE2dPHFZ2Zsg/EfminypGn2DKufwOg2QLQD7zK2LMmpr4UCuHTYzcAgs4q8dBZNKK8SSfryOztyBT5TvHrhtqsjmuTpzHjicudu/BotLaXR1ntoXiNJvhJn5HnDLW20b0JmXQJUDKrot0hRdKxJqT1wZjLxJFTtXxlRKdlFljbV1B7uvEIx0zJVC6MDD73z6cLBa2FO
 c0Ap5/PS
 TKuJQFzRd9o4BQ5IVBLoYf6+tGdpLQGP7yPTx2MiMvR///91MpuwGEQ1WCAfTQe/TYTUuqQTByL5YDagETVBTA8f00+waujefazS7/5ViWcqRHe6ZqXUwq6tHtIGdJl4ut3M57dMZI+g3IwLM298tUFcyQCUnYoASKtsM4ncD5pKjTUMz8xpA6ZtnpvPmQEBl+95M9KfvqJbybJS26eESkHvPCUnJbj+af+E4camNerpRLYtNdd6ocqOhRKfZOottOUAoIjE5wNi1nhIG/dV9hbJbatRdDAAe2oX0JTAiwGBGRO04AdQEBw2ckbSqvtgmNCs+F3ldfkPnqEHEJ9bBpK7i9H9T3xd5+MEuZ9Kf5YokwgLC8sHtGnY0yVW/6g4G9VCA00usfLcpSDIgvXXmTJn3jhCxv/62W2pVcM3sIxmjQ3/LU8btDZH1/oMbSdfh48XVXRdCAP5IfOMORtqXmOypgu13KQ5SejXXan/9yJdbonSxPN3yOkkhO6EXi92abRn4RDCgGU+noAHD5SCKNzOk2G0uVQh/ZVtFCXeGfkzWVMYARw7voYzeytyN5selORCHZeMS1kJ6UYZT91UST+xXr+gBU6CcFpD0AqSdw4otHRNkIJ+5S9YVGCg344Dg5mE64oczXNElBat99PV2JY3w1G9MVe9mk/SQ708HvQ8aOS4Hv8BE6Z0RbiZP72I4raQh9Xe7EvOzPb961oF9bePRN6FxEae3FEChLzL9vokBjITM8e7h690JAzpFEUjeU2E872b3LpwhLSqBs3MChhKg6yPnnSZMIC0eUW7Bvwlbxpf6epHEzUznchS1xuqNOc+FRLh55UJve7t86xzBK/soudJUwF5L3Dei0BFBeB8FyVmPFf/VC9ta+O+bhmIjmtIdNWmLwLTCjYJrv3DBITNyv5p8LLn5vG/W+9oA5MVwf1ICHX6EKOLk7ofh+vtmErKGO393gHevqc71gY1hIAfCvmtm
 vDi2TyPj
 Lb1TqkdPugvqQRm9JOqL3/8LK0BkqdR9nM3Qtc441vdGg9gxrqQDQcNO/c4T07wWTyxVKi4dgAZuqJYvJkgewIowm62T/3UoxB7GVlpa399glXhAlXG0BMnOvdJGxi94/LaDJGNqZxc6/OsQHjRY4O8MCm2hsU6XPIx0VNfCAYzsvcACxsu3ngMvyk6ppUx1/0IvfZXPWgW1m0n1YBh46kNLoa9xJBzlmzCXBh4Lr3tAvuLh9uP9a3cRjwWhuJCROCrdKg1Yi6pyQtbIH9mErosqEBzgSESE9HgT3hrjaLWCEumqid76M0UScaahzJAqiy5EN8AlZWzWVKZfp0+QAYtAwdM/mWkhgiQMW5FbaODDUSG0Lb/FP4n2ZWu/5sPKBOfZEuwkK6Y+Z5OcPt2OCQeD5VvxohPqX9XeXjQwiwszcgTJLcvt2PRYZNuEs1+ueX7wgF+mJYYI8VeF6smnUN/ibHtQT6nHeP2Y9fFXEEXdD8a96G/qnc1VvLc2NfRWdsBGHKmcb4ElNpS3O2JiT1wEL+yCW9N112/NPa8uG7rz/Q+CoWXc0Rj/5m9SzTWwJYVjJSVPjNsPcJivDV21Z/bbt9WsNbEwn5U7eWJqwJCAPRT06ILKtupu46IXON75ClEHv+VpaELHN/GMjD3g17S7h4WMwIUFnOzCw/SYikTFNJ0+rI2d51VK56909QQyZwme4oAx+ssVc5rqes7wOuiruF2h6KBpr5Grv/zsMAwIPw2TgOyo0Z8w42dDvUa9VhWhPQyMkEWU7QxrUggDqrMe+kaEiPz5xq8JiyFllA6s6mmrNtzTpX+2NNDkFBE6YGGF/i2DeA2RQhCMmvyAeuva9fsX81/oMQUooMvoIv6F+/vqeCpkpo5fodEPG2A3E1vFVbIW7MgtEX0P9aGiM5NYdnqTk6fjwOqtriHaThXMErMEUdZP2VXZxc+39ZT9libmgGF5QywoosnVx0xGruxbeivTi
 cVtsF32F
 2JAt1oPcxVzkQ9erAsb7+JKWzlVF2olWKEiKyfYsvc0zVetGmzNffccM3Ltk1ntvrGadaOHZoZ3xpyryAwiyjJ3fHA5gU0MwZSUc+ycsQeqn9UFiJk86Tp7zyya8piPgCcL0AbAuuhTzeDimjJo3N+arXXdTB9oHEMgXxtMf5lIyU0EI+hnLmLhpf+TtGGUrEpyWAj947GUJaNN5GEDWE3hvTEosZRy3zNIWLTtCP/Gy2vm4UTK15wsCMjtkIt+kyfPvXMP4x+sbcGpB25t3B1HuiCQutbn484VmIQZkfeSCKy/yN9sSwes1yvF6uKwMfVCFGhzkenxFlFMAV6x7YpeYt14VxxbrmIygSJTL8GhTD7a+fQiBRJ3vFW/YHXRr6z+IaTHaqlR4N+F4955Fc8J8frqeZZDzX7yEO1Qj2+Y8uGL7omIKYfI//mW2tF8zXqnhIbSQ4rVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping()
predicates, use them to determine whether to proceed with migration. This
drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings may
set it.

hugetlb mappings remain excluded, as they are fixed mappings.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b9c453c28795..b74c0ae42768 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
-	    vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma) ||
+	    vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;

-- 
2.55.0


