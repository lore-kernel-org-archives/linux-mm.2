Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADFBC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D6A6B00B9; Thu, 17 Sep 2026 12:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E436B00BA; Thu, 17 Sep 2026 12:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05D76B00BB; Thu, 17 Sep 2026 12:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 784A36B00B9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:37:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EFB312041A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:37:48 +0000 (UTC)
X-FDA: 85223810616.01.808816D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4229B80007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:37:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQV3b22S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663066;
	b=B1xDScBIIulX6qG3ZMLwce5OpwGvmxFJ0DY/0v/WpqoFveYncEG6o02IPhhtvSrA9ojpsa
	YO0gYmQysb93U1GkDrJWjPdcDsMhl0SXt5nD2kvj/wh0p4FmZWpDAJCjC548DTLfRueFVp
	mTZ1cBi9PuB4Kp4Q9PfXMh+pEqYYU+Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQV3b22S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tN13W6jwJWnvYLjX7TO8ZRd5JDwmaJZiUPNzCgrQU0E=;
	b=475kCypK1kUNOz6TrirlfdVElvzW2g+8KZgQnWefIK/w8bj5GWkyStBIMEETiriRFHGq/B
	JP7RC1qiBNAD8bgy+Xu5Al8QSOBgoD+xjmqVYkb3DpRiEmXUG36UfLyl4ddrqx5YA+iVIN
	6OuPQyCohDKihVPTdntRcr5uNWnyMjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DD3F43782;
	Thu, 17 Sep 2026 16:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3831F00898;
	Thu, 17 Sep 2026 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663065;
	bh=tN13W6jwJWnvYLjX7TO8ZRd5JDwmaJZiUPNzCgrQU0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gQV3b22SwbTXH2zZ0GNZ69Q+lD+VzX7N9jRRUCm9CHYqN/P9n6cVUA02HsJ3fcMRj
	 dSINd+RiOI7vahB0ZNe3QKThxObOyz9igl0iAMUTyOzwM4gbJgvzJYt5+/N9X6hTO5
	 jaef2ZYYCtZjRK1D/JdtpNvMQp+m5oiTU8xF212Pfnx+EIDqQOnof2nHSEB3pehulA
	 RvTg063k8u7CxEoIZfNushpCHKlN1asRDoVpTfAqHKaGTacWP0MPcPmpMDvvnDHy/k
	 uGCyJ3fqRo0ld9pBy2qL1IQxQ9qLgL8tBsqJfQzyvcjux8dHazd5fMox2Y0rPy09p1
	 Nx+dvv+9Ch0sQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:38 +0100
Subject: [PATCH v3 29/40] mm: drop some redundant checks around hugetlb
 VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2730; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2GAQjO/s/Bk0fyt5AOQ4Ez3Tt7coS55V2FI+CqksX6E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9OnONd+HDZkt0HXrQpGbZ0W6/Ysm6704SDTJZzn
 UQNH+w80VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJHJvMyHDlHuMOi+c7wlyD
 ptu6Xt0/a8umhJW/J9/QvBz5/FLH+5lKjAx9784w/Y4vvvs7dnqrqoMSl3h0wKZ7m0+7+nm77K1
 IcecDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4229B80007
X-Stat-Signature: ud7yda8cyyfbb8zgt1999u8bp5sfma3a
X-HE-Tag: 1789663066-268757
X-HE-Meta: U2FsdGVkX19j7uTNGDihlOyO1X8T6ar6zvZgux4+E+/KY/t+8qdE1Y87uTVcAlPtKV42Ep+opoNw4Mviw8rvuXTrC4P5Q+wTcLRIBrJuAGJcaVqOOrAaYFbp37fEf/kPOKz+NbcuIEEtW1w2Na0zm40d4JsuivPQWSSWfmhIakCCILZkc1LWhwrbS9WEwhZPt4TgdorfAnfEUlgjoQOXcIHreOG2zGQZ1SWHWx64gJ8RKn/m6gHESUjNs/F/BlA3s9uAZsNwIUymuNDZeTm3hmQ35AR+N8b9lVvzpjvq5JX4aD/UkYd19Vc6GDsWVjV7p7HqO8dEeamn7KtLYoVDbgoZnY42A5BYAoNVC3LDXYCiMb4XaFU8KYbAbpGwkqgPRPfw3QxZsl+vCdapPOy3QniDpln1tLQ4Da55XSq1U9QRO/48a8L6I6n0bcdEgpWIMhDxQ2K9mx2mz4kuAlmKFUbgWyWobK7MXZLh8F0raIIg2tgxpySw7hbdNEza66ld39bWd91NkuQBphqZh21VMAx3vcqUSdJImD4lOyFwgGesQp2UDsfiAurXYND+VT0eKkAtReOUxrcpLGnqXJnP2GKZnKpNYnD3+HYkQ+ea9MOuN7AetBcNbWvTBgNjwMXUlk/TuTV/s2zCtZdUc5AF34RTMosKQGmz/ixXISaaa/Qn/qQz/ogv84HM2o5jF80x9a/W++WimHA8ITx7nan4uIgzHnB4UCr1mfSSnN1EBCX2obKsCXVMA3td7tnxw4aMs3ys3pRTJdIcFuKx5xyvCeRtWXTlUUio+okBxC0azVNZeBbUwPnhHioHCzFnIWZ83pASgtVPEuRS+82SXKz71t8d2tXak/Su2BdS5Y5XmQMDOj1znTBD6MUUaBGkrRvpzN/dfEXYNJt4fyvgfhn6CzqZQqjnwHpBEAGBYDuAMj3mwHK9YlSrq5GvnxXSQFs3CWt2BAagK7YNsOoFT+/
 2bqRhm5C
 nVaWTU9MTwCP8PvBi007qCK+RLFjFoqoQfKE7zrOZiu6m/gBGo5IlddGawLBHYhsN5u6rWyM059wxLBO257v/CuRVroIJEhv4jKgVIPgP78qePq7LhnYSqJGqsVK23k7dtk4zH2cR8lDVhgciuUYb4Bq3QeYUyWvGxaAAKuuLLSjMEjqLmd/uM4wiqXe2FzTbpi91IvsvxM6+PU7rsZrR65bYbWusym7oZXlYU316DSf7qcOVUkXptQwZbqM4Hgk0QriSAzH6zWfHxvQkKMnQqSPiryTBTVJEFHipN2EFKhtg/v3159pWTd0f3FNerv+z88aSI0mZj1fInbDycTsl+qU6wI8y5bh/3JBr3xiBTsX4o9HBVbagYjkQIyjyiryO5OYsbFxRzRHcHUmQW1NKFqWr4q5PwL/t7SBU2NnRPDZcaqQIfpQWQeBm2I0FTYh7Pa4pFxDCDTNCya2OMUsHFvO9ddAjyZOc0fufzcf1/WX6clF2wWf+S9AfF1fZ+zR9XjqgsPCZsGHXBI5yzXoY3x7Ytvn5vA43o1UoH+VBrJL8tBDd7jLHH+Hl8R1JilrQoLFqQCQrdYGM8cBWB3rUU8rwVidpTVCyShVxgS4lUSXiFnWzm8EC15YTNDpFDkaTleGOdKiC1PAcRIhUGTEvH5UQsEh1JSBvxLhs4vHyt1gLfIS6m0aaW8haBrliad8fO57CfGzbpDx9L1oTqMY+i1vFyiTGHuM5iHQAXWYqu26WcyDz+gl/QjMTW+P0/L//MAdheMzqi/eAwACM6DQFDTRaSeZRS4yZbJqxP1tz5HTb/awvKgDtTq9EJqI7YMtZXdCd5ZGOusXtoXm2y0V/NV3UwkvQ23oZMddvDMUbplOxV6qQR4Uw+JW1lJNs00ga4djl36fJpVHblxQQsmZ0kExpymMIswPr/DWGaf+7mtg2i+YBSDLcymqx1Np27bFILvAmQl+mhLQ4Z5rcpDqJ224NTzgd
 OuN43NlS
 h3CjoON7BPqjK70ondQxS8ero/oNcmSI5guBDDAQsvZC0ZuTvofn21CfvRGCVEJ26AFWRAQUaxClJY+cLFB8VrLfX6lV+ykGeuVGBrNhE6byVDNNhZHrGu/Q3I+3/FWE1Zey3bN0THJ6Fd9rd65nKpYNJO9BXQ3XQjXEc2kN9ltiYwMLIK+zK9KGozmwJOdfLoU2Mw/VPpUG5iv6Sk3I6uoWgfPbNLwVtLLQ7tWzI6hBj0uAsmPbG6LBYGgmiSAhG0QU+b2f2VVieFQTf0LY7uHPe1vSY8y/RAU6I5ZcLTo7MeKe2YQZTlletGbKK5zpw3TtcysUvC/y/mYS1qoFS8/0h6qepM1VUaEQ5LCudLhH4YtFLB/a14aJ89QiB8K9HW91rQUnPu/av9Os1aBNqfM3vphBLx014EgiA556XYmGuhBLx7NrAHzcibaU7kdmBCnRz5R/02+OlO1fS665HYraW9HBbZmZD/vFBSSK/zaVkZqqfG9+d8oS8XpN3RMKyJeS4lgvBqTzycEvptMte2CJD1MjBYNUMnVZq6FZ6HQxXqxtHk+smAwPcpcfaUJl/g0S8x0pGwC+cPtIjR3Mw0UPnxnajwwu42DBZtl7litynyfbfEKWbiI1oL6kQJZMTTl0Eq8fCmUxtAQnem+5YnWbj8OEqiSlyYfxb8dn3lSkDKMSmFj0krLI6jUjimARy/vSGDkIoV1TgcD30B8wsSQrkhTde/XGnA7oJwz2rbCoPSEE9sLQ65/Dz284uM/PvGidxVcTOvifMM4QEQlmhR5MKMwQFYF76wNRqKDe5JnR1H0rG1tcuZwu5ppHlMDNx/3mgpQnZ99/L1nDiF8ygDgjb7xcfR2HKCdeYEsxBFmce6QpGaANZJ8iVrLPY6WEkYgpOpnhL2YzAkPEBjXUZwYeUF5zH92IJawTAebs9YU711QUtGSxfULgRUT0bNN2GVdcolt2kYERbERPfoZ1p+AlzwVs5
 6X7Cavi/
 mJb+VI4AnSC6NqYLCbEtAuM7n8ul9EMhLmYWkyS/nIGyxtEZFIjC6Xohg6lBb0hGQvHw38+L6jhd4gK77IaHdeVaO0GsM5xFhoSOlVhyRay91i8Vqk2Or88H8oOBAioEcqec5QcnVyzkYQ2pj3eDeEgIF5piMW1VqmeQ643qkMpCTKZZloATj2jwe9pysrm+h0M5LbdyUi3gr1XkDWL6+BigilfwX2t1seTVcSCCFufOcpY6d2yllC78GP3ZJGwKGIkhLj50GNhaAEafbe1L3J0S4iwUfJEZim13VUm1N0SX+YLo68Sg2+43Kdt98Yy2udCwld4JjEmgikm5CXzvtZA3UEbWnL6X0fEGmNeZDdcCwr0CQAs2xn2Z/q3bSXWexv/X7O89x68bVXU3AIT/YShC2EJlmMrT58wMHhTj/91WSXnKxlIrxp5F9t1xwXfF0tt8Wcm0CzVM4bt7g8e9CJkOpSM4/oXxaFGgyQI96clw5Oqg1LyiHSRQyVZMmh0UqLdzOeHJRHlY+mr9LMluufmwmiOTAqlwS7SJ/qebgRuPSm0Taiu0/UHADOlrUHjisotdlB1Q/5Vyi6hBV5qdsi5UGwTnZmfm+PX4jQD4wnW1pE2R1M9UKfIBmG8WJ1gUr8hNc8JmjIZzP7pUciLItIuCocUklRlThMd5KwtrFgCZxfd17GnjkHdnkxwob1YENvMk/d+MtMzHDkXiSFOtHzeIawC6RR6NsfMG9ou9p/5VHO/qBXCIFg+XBQspzt0NwFdXQjIGhChV3wx+TdnHhJyto1RSeJ0xwnfwvVyzefP24/zb9n2gCxWHWVaMLVOVZ1c0tk78lgeti4dU5hEKSmduU4sN4D4HgH2Fm66eho1en5JDQf7bx1mVJ/qh678n9wMZ9FOluP1rEvqaVwsDuPOSbfExTEMIx4VnFdKfaZ95lPOssHslyuHDBiCsVbwGZ+2dfdQtoCL+l1yt8+IHa0JS7+qNN
 XFVGXAhV
 WcZ5uVwqjoZq0KM3SZMVK7/iTO3zvN1LAY8XGwB/N9A5THGkAy7v5XOXD3A3s4fHV3XfFGvGPmCNiuJVkyCspwboSJaqsZiQ5+IV5GNrQB7Kc75oCqN9ZVftYn0hKJ1ryD5fzEaLSC7bd3yRJcvm7/TxFxYSNyJeSxvi7rS1n2wFduiYZVMxygXjMlqbQzAFcFfkyL/XM71jnP2iD9f6aExwO6EuwIuqOBjAVZQ6dNjwEHo4rNG2z2PSwC959YwkSRCqiWzCMukxbXSPvfFX/gVMaBHP5xc/q821o1kAV7kXH67xToZm9WuytUCOVPmsTLlNV5CrFYF6XqyN/jACI96RE5fNLyutVZPcuY16dATH71FcDfbsv9kdlaFOoaq+qFPAAmbYgqy8WtQoiHEEKYTNHyBHNQIQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust code which inadvertently perform redundant checks on hugetlb VMAs
and clean them up:

* hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
  suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
  the series, once VMA_SPECIAL_FLAGS is removed.)

* hugetlb VMAs unconditionally set vma->vm_ops, so they are never
  anonymous.

* hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.

While we're here also drop a VM_BUG_ON() which the simplified check above
makes unreachable, and use the new VMA flag API.

No functional change intended.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c         | 4 +---
 drivers/gpu/drm/drm_gpusvm.c | 3 +--
 mm/migrate_device.c          | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a7968f8d24bf..3c1240ffc38d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,14 +1463,12 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
 {
 	unsigned long pa;
 
-	if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
+	if (vma_is_hugetlb(vma))
 		return huge_page_shift(hstate_vma(vma));
 
 	if (!(vma->vm_flags & VM_PFNMAP))
 		return PAGE_SHIFT;
 
-	VM_BUG_ON(vma_is_hugetlb(vma));
-
 	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
 
 #ifndef __PAGETABLE_PMD_FOLDED
diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a1d4989b0b61..fab34fea99c2 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1141,8 +1141,7 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *gpusvm,
 	 * limitations. If/when migrate_vma_* add more support, this logic will
 	 * have to change.
 	 */
-	migrate_devmem = ctx->devmem_possible &&
-		vma_is_anonymous(vas) && !vma_is_hugetlb(vas);
+	migrate_devmem = ctx->devmem_possible && vma_is_anonymous(vas);
 
 	chunk_size = drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
 						 fault_addr, gpuva_start,
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c38cbaaef5a4..b9c453c28795 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -743,8 +743,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_is_hugetlb(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
+	    vma_is_dax(args->vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;

-- 
2.55.0


