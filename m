Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACFDC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE7E6B00D5; Mon, 14 Sep 2026 11:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896C76B00D7; Mon, 14 Sep 2026 11:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765226B00D5; Mon, 14 Sep 2026 11:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5246B00D5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:14:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E05CCA0064
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:14:41 +0000 (UTC)
X-FDA: 85212714762.11.DE4B88D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28B3C40011
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:14:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmNN6RDd;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7igvapfDwrm+6txgQcyn+RMKEShI1bTZhFDIgbQAbI=;
	b=6eSWnre7qIUg/7Mjh1525bG6yzGWlwRc21wIEFrVt6HkmK6x0MWehwqcjbKhP1pcuAirqj
	zRZXrllkldk5FUBIrhDVEFAvK1XV74jAtRAh+ovD/IWEpCgWmwMjp8oH5gbSik5OL2rzdb
	AUf+A02YqCRQqIAZz5QhI+HH6tc0rek=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmNN6RDd;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398880;
	b=0VXQrXR2kipR+EFBn5Lcd+N93m0wABF/+LHDh3cUxmQqfwxG2KSFzZvFtWLXvZcgesmThI
	eVi8qKizYhCN0vlQ8H4s7BOUDbRpH0hfhUCWJTxP1GbWZiskxeKSdi4u4lbKGVhzfCfdW0
	o6sVKnHhnsLzbgZrdKIepfRzvqdkWio=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4B56601FB;
	Mon, 14 Sep 2026 15:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561D31F000FF;
	Mon, 14 Sep 2026 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398879;
	bh=Q7igvapfDwrm+6txgQcyn+RMKEShI1bTZhFDIgbQAbI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LmNN6RDdl3OcQfn8BQ+xntQhwL6LNv57jORy8fPYj5F3Tw4d+J4Gv/urFCS1HPduv
	 9ga8gb8IS9Nb/Ri8aU5npchcY54I1jT0dihVMpK7TsTa6iVXCXEE/e90D6Alpyf3oD
	 nUxAaLD6ui73ipxcnnE4PaxYOmYSQ0ckxQNI9wpfq/zaipTE9ex+dQxiHxuaQVI6lQ
	 wWBBDhlhRX6OW9pBVgkPf8NAVf/hz7F7FHcLQ0iSVUrZtrfkvnkgGZoOQbMZcy6iK3
	 pIkNxaTA0MlSECXaa4UzJfWxeIUc9OSfpLcws1hNxglEKAY0qeQTM7P+e1kk9P91bD
	 H7071teIJBfYQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:53 +0100
Subject: [PATCH v2 33/40] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-33-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1318; i=ljs@kernel.org;
 h=from:subject:message-id; bh=73C/rtzFa+0ZWXqoblfAsIR57zB38R+k6a/jXJhy+os=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG8+vjHgcrw8f3fW07Wfj1QxRP/ycbZSLhQpuLxxe
 +huBUH/jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEykKJ7hf9jpecrcvEZFSdM3
 mHbmvdg35YBXV/5s9dTuXWfer/38XpyRYYKUS+2ulWxlWmuuG6c3V2k2Lry76n6ekfzEDq/vFVn
 ZrAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: fiu8zonbp5sxhordg4qp8rtf5gk8myge
X-Rspamd-Queue-Id: 28B3C40011
X-Rspamd-Server: rspam07
X-HE-Tag: 1789398880-946313
X-HE-Meta: U2FsdGVkX1+80wWptR7KKg3jVFFmgMhTsw/LOnUmfjdOasRegkXqmMa0zj0ElujaF1Ho59SAvibmFRSQ+xIF39uLQj7mo3lNxXYkSqks30u0TmskwEsIg2iM2NunfXBmo65RivvAjLpvDbhMsxN3N8jCfsfHzkB+CjVxHNzW7yi6xVv8mcDINQLsE1uK7B6r3/U8AvAaRgbebelbWrIrcErnSYvHVh6KDD/hi+tq+homGgVUeJrEkE9xwTpGAYf6GrsZTZUpAAR3Mcyle/d4QVU5z472zmLq9tlnkyKS67i03caKkB4iBjhPkhukEZQGDIQMSGJq2d3odynZi0Hv8dSKbmrwO9+L6L3hwsJq0xuI0vK/dCk8+Nd1x1x64Q3SC3BUtYcleruEglA9tbJJvT1Mut6DDJGLVsAqnsVQSUSsv1+UhCx4b7A/RwBBHZz377GFzy15fSzCI+MwFxjBWj0OzS0/P+3gmOtJXoSfZS8w5MFbtZ3GOFJvVMQSHd2rkzkojgkD7UDs7KFkplkmJCs7Ps/6RDaJT7Vd/g63fWCzPeTWoX/F4Rh+kHBRROAlj2cJTD4XtqNKO1NW69PV/c7z8HcLNjbXhsreTQizA19I70tnGsTAnu3ZNhWGvCCrxvXWZPi8ll2Z2/Bqd73MLsDDHzN2AEE599u2InX0HeyiM83WxB1HlUj2KTB3S9gCp9kRM8CZFzX+IJA+yt3iNsbxjGXvlwlc3w7RxCNBelmtviJ/kPHrOtgFfdxT6C0gTwVF9KgMifvGl/XmjZZZSEMHORZOtvnW1evR9Vmr9x0DZ8JeRAFc/W9hdH6VhuUuQIPFlqVl9dxi4ORAduVwKYTrEG9MFiGhzW+fSP3Q1bUihxzmsrbGH50DLVM5R7dYkLD9Ipw7kb2UembRZJJvGj7rUbFaQ2/bg+fpp3+igQHbl7+z7y0fTwDa28mh4ifx+SvTqiLEQOQj37Bi06A
 xB0G5wHI
 ufWhzzPn13LN0D19U7+nbFRGlkWQT9LQIOpn7cw/VGafcoLf8XsWtdzeVstvh0QQO7yL1NUjXP5ANy84PjrnKz0pijkwu/khVamsBAMU8we7cbq2L/wBsnIY2x2kYLYzrBKndDOFlvmZkMSkfdAXNgs1REszDe062ZVFwg06t66BfiKgpfdW5+mhou5s/Q1pd80QdiQc3J7UVy+uUAtoSPh/pkCc1NViqOPo/icNiNlcqVkVzjUfku1kqcUt+3dH1m0TYZEYQ+VrB0xBDcTPOLZD5h4kfFQ0KiyakfUnVE2AuYCzHndRSjiFX0LMPyk4OcFQXoD/HhjqtHfFLrn+M/0jES+8eX52Piqeky2H2fuxRietZzb3ukgElp+MIViOBHXv5NEOIQQXWr+95PlesTEmdO22EIqLaBvauSeUSfmPbOwgafKlYBOYT7SNqnVGQCPN6q51BnStcQIJ+qJWinUA0b6awGdhN1xZro3p5CiRL9F8ezAnnU6qaf0s+IUU9ftSHneqkSfgSDmrh+T/wwObPJIBqh6NV6AJtc2sgxtVC9Jmn+228Bhzi209fP7+TqbOIET9M69QEotCiO31FAHDOcXWI//QjHRnzsKkJVoCN1yDdVZS882X0MdkU4zRvAQe2hvOE8WifZGHSTCEknpczasERoSZcAa/Su/PwZxyHSqiIbycR8B3EIBiyVkgdIS9lu7aRV/OdC99QPkETwa1YsuMtEmrxWa3F4EC4Hxo2QSWJbT2oOlRMlGm9I0+ZbVGdk7am/TCNEZM1ylH1zZDEY7BDxsKcI7jTWaevrurWSSbSBni9sUxEvgCEVtVrDkLjJjjHKN79gjOQvp5AcvmYk48vpvbLH3EczsvjRSkJt7HBGUbZDrLaebEwQAHTi5GbWNx4cv7bvmKDk0b2oKmtO40UF0f96BAP6SHTTkorydmtLH+JasK4MUN+9QW7EMnyasbXTNL9fg+97rpaEK5QyJfh
 6NlA2rNa
 RShK/ew25U1PBEeNghmCjAES9bwxcbJBYzgaAxVHuK+OR18KR3w+TaWrAnMY3jgjwZBGQw5iKdsd2BnnuZwYY1Vd4oUKwWsq4DSINWuHfUJf56mHB6tfGaLNk97eQ4w+Z7D4qiX8JcIqVsvlb5iKJEQe0SFpoRZbAqFvQI/Pv/gczHW3jLIJu1Tuo4oyHKXArI2OnglGTrUcrJNNtT62RuzIqgWyLQoT5pHKNbgaRz0M22YNePr17Wat1xLvo38HGuT0GKwMleOglxrGyW+HKLigwP3YaQmyTDPUH5YbC00A2BIB7nwVFbwWENNF6XEhnlpvNFLD3sAQxsaz7ydBOPZX45cCGHOHY1xrVx+ASvJjA4ZnUQSJl9rnkFo//RF+qewbafkSyXY3ORQd3i04domWPyCjj4z30qhzuAkOrXyFtfq1w3TsitKXzR7ZFfxcAQkYh4NeZ2mY+2MN81h1E7OfNS620J7C0cmRy3xROukjANwj2s+dYGLPlQXybCzn6om0PIDCH/aNAG5A4LYIwDXEwo+HZCAe0+RndzORJWcWvwraqiu9Uy222uGlKpvVq4nvQjZ9FPE99+s8JlY1LyvHKPiQB6HJTdUmcodb62hzUQxyOMsr0iW8esw+YA71lFKXKsZG1CO+/aI5eRyTZJl0yS1mK1MbOjrGSxYiVqij4QwRiwI0qziQzCkKVetG+9j28eUB/o3OwiL2Tnf5eHW8HmXU+U/6r6ldm1dmoaTkJispoIvPu7pEC4aAV98+7l8JjhoTbW8mRwG8a8BQuG4JLJeE7lLt000JkCkyQSn6fxBA7g6QUmdyQRjqxRkyXQpgi6cL4CQmPDRkUQZMi61zhZ6e6uJwlop3n7Po1Bd24uCKunpV33s+wZw+Uarw09u9XleFu/OIeUUibAbthzGRAzVgfeTQ8/admN9arltCvulNw1clWLAg6ufFB1hlqiLrNEoH6dUxNg8kvDHG0V73tSDub
 xQrR0F5e
 NqAIaI06oT1t2B7u3aDZSdwMi8rD6/Co6XnSSGD3HvEkoQ5QzRC0BA39UX+aK7PyjQeWbzSbDSXaWpI1dXnE73ZcAj/Gl1DmJrklLv+mXHj5lZk2Sf/t3Pl+wukD7XOCgVrFeOijfmQtx5yUUNNvjIR4X1B3LtyI6gpJzLWI84chcYo1XLgA5cS6GDwa3QeQ3fb9v3XtpRMZWFr7NYVdyq4R53HlBRDpMdCAekMblHu8lU8q77MuDQVFyMYuIRG9Udmzg5S3OvU6j0KITQFS+xTKFjV90/+1oegz8x4FCGVGo7qDYtcYD4tbM4KUSFC9lxouDb9yH7cnxsH42MYVG2jX3GAiFEKBxJVqgUFhdb4im1X596DacisGviTxpLW9ivr7DXeWIBlgsCTsQJuFt6hnERlF2+kXNibo8KZZO9i+lvUAzD3tQFfB0PU/abamfCh00GMCSDoONwziqJHO9adyxLlLrBB0PnCt0FGiCb+W7z3YHCM/PZ8sWKOfujts8DjpGgD9BykajV4IuL1p3FgviUC1yRUCjhPr7pO5ZTKW7eoX6UnAGJmgyOU3RcUkNoo7tm5q/RRLNEuFHn+ah+Kvk6NJgkdK5SxTjqV3oC6TpMYQDOrX/KJfpHu7orvRL3FLCPd+ieLcV+vlvKcxlkJA8HEfxkuVzKTLEQkUcU6O57VRv4etPnY2njO30dnXr2cSEEJXwqYW++1Maqqpr00uX1A6znFkspMs7hQ2C0NwsACYhT/9yTsyElA4T1DSv4vxqWFDeDOUtFF8MaD/+Nptc9JNkPTKMJCY8s2dwfZxzoEgqf6dXK0UtDyu+69XrbGKSmS3I9wCMuR5R179Lk9TJt+r3Mk5b1sXShpGB9gWnfGWA5dwcYKN05mAu/GmC26rPqb05IV1wY3hQ1MMTWOHdVPwPw3DuogNW4AoHGUeWoTNzWTGP8fpk8pxOrVScDc8dQuy76bP2ZPm15DC3/CdoT5vl
 smKru54S
 WU72wcf56UjJ8l3NGcEGWKThdcKaJ/SbJF+dWqvMR7oZKoGi7Ec0P461ptSSlupicPOX5lGQmbt5RK41dL+SL+b0U5hroiTPdKPyZlMJxQOi5O7grpZr8CvUwMTLYcoACvy/TxbiOPbhiB9I3ZmN6Y0COux6hv4vy/Tohd7zT/5SXcfWHx3qPpNG9wzdq/MCpr2GfF3gbOG3zu28ZfsRLiBw3b0pVIDylMNNMshwKSu59Mo9F79ldKkqBD8W+CAb4HqZU5yLbEF5XtzHKiwnYGacDAOp88yqdxc8+WBYfaGgOyWV4zF1cY6niS6Dxs29ZXOIcRiQgDE58kb1xPNRzK1FKxIGNno1fQOTVWnSZW04/NzXSy5VyE4P0Q6E+DV4zTn4eCOzs9HBkAhM5ELgwk1ww0NyjitkJiuJ0/9u5M6xc7N5vSUjvM6pmIVV8xLI8HpbSaDU3akA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. kernel-owned mappings, fixed mappings and
VMA_IO_BIT.

Now the invariant is established that only kernel-owned mappings can set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a kernel-owned or fixed mapping,
i.e. exactly the same check as whether the VMA is permitted to be merged.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing differently - if we wouldn't be allowed to merge it,
then we aren't allowed to manipulate CoW behaviour on fork.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index e15973292f94..1af82b044d23 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1565,7 +1565,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_can_merge(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;

-- 
2.55.0


