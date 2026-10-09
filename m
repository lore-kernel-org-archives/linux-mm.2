Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C5ACA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2306B00BD; Fri,  9 Oct 2026 14:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3836B00BE; Fri,  9 Oct 2026 14:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A666B00BF; Fri,  9 Oct 2026 14:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACB56B00BD
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:13:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAA1E120467
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:13:22 +0000 (UTC)
X-FDA: 85303885044.27.7F16B19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 29903100002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:13:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZKQheuz;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569601;
	b=7Ep6b3jKosg8kFzYa4ecN5mODO1MQc3X1o62x/vzkJdaKQajLT0Yergry+nLueDhnLtD9k
	/VPo8k3+NEjAnWeyUjbrbfjnZ4tpnHkiUr8VoOWlwhPUA94kTrzhHMjmrnqYHp/Q8xC95/
	HmZwm5tL6GvEMUEY79O+AKBWw+Bh5ZA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZKQheuz;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDIhdQ4t5p5EBi+T7UN1fdBBm9Y25zMxYUCZ1BD49A8=;
	b=Ayv0Bn8DgFN6odPyRH3chaWZYAsDTNIzBsYqrd2wvv01yvaL33E9rQWFxJkMx4KoKstoNZ
	LmW26IpO9e9Z8u4I2xf0h8dkTRHdB8tsApXOq/q59/irxYV/IJI0KkOgc5sfx5cumHHe0P
	EWQ/CwhwgktLrFREZAdM8eJTA2cH8DA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 754184362D;
	Fri,  9 Oct 2026 18:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D411F000FF;
	Fri,  9 Oct 2026 18:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569600;
	bh=iDIhdQ4t5p5EBi+T7UN1fdBBm9Y25zMxYUCZ1BD49A8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KZKQheuzBkjAM2O4+v+AZscyh10745SRE5C6d3hgUYxBW9oahyQGgRTz6g7EKF9cj
	 ie9ox3bNzDg7SRc/MO6N82ZYBJWc+4n12YhVZWAof5GhCb96kF+gsk1C/Y/8rGfu1o
	 7CCvtSI/YbcpjDK+A11l/1D1cYP5v8zEYIW3WCMyHxJ7lF7MjbR840DrdGt5vZrtFO
	 NB53sOnVa8Su3CgmzsP72rX0M3DYpmTp+JFOUnUFIRGKpI6NDVQZfFM8j31isA9cQH
	 S6+ru0/6oBB58nPMUJ+z3lLqnWs9hJIXZgqQn1xE9SvXQ9+3rBEVUt2CaO9duNF64t
	 b+Dv1O2VII1Fw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:19 +0100
Subject: [PATCH v5 25/38] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-25-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6830; i=ljs@kernel.org;
 h=from:subject:message-id; bh=XJ2QJEIs+ulFNbkBjHGFKwasEh4q1kCJXoJq3WPvmC8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxdZTT/t41/fs/H5z+brsyr9v8cpvPio/3ax/YH9
 /dszZC70FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJhNswMuxP+iF4fjXblA6R
 1ikqZ1buuORjmSmrtsPH5vKxQpvN79czMpzfnimqq8Nefkpl+R8PoW3L22/e1zuYf0zopBnvWrm
 lL3kB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: wo4nqa8uj1mjxipaznpdusae5s1gmgok
X-Rspamd-Queue-Id: 29903100002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791569601-866064
X-HE-Meta: U2FsdGVkX1+pgYgjYJhJAypKPFCC/IEhUBM/jzMR9lCtltSmVGLo14mQPNb6rzK95t1vuUGc8cTRYdprSk5Kac/VWzvE59evLG1X9XVClZWY8LJy6DLeB7XEqeGOBBfi8ZLr4tuAZzqpkgs77Y0Q8odBfr4+uoYhhdI0syreoIpoDkXMPxtf+tiEgEChZKZF0eAPbssI605Sy8Uoca9qCQDhpKbthK5ftM6V9ey3jpcc+jb1z969D/4O0lJb2EFPIbzNiP2F0jXPFzP+gh+r0C0+iVtRFSnykf/h+/DjzUtced5rzaA41EEWUxjsyB21KEt9W0uT8rQpWDCsEsXhsISiN5mbCj717Ef3FrwWLld5DzAEJLXvDs1X98Ds6x3R13DL4euoupwUCiK25sKmA55tpXAVmvjuLj/ITzuBTeid3dqW/6EKTt9g0tcdrtTLcqgcKJkJQaF2VbdlQEh1xQhZPnq9KR67qHiomVZ4vmj4Pbw7sJurvsRizS00Lff7pS867+vCXhJYdiwWnIx0lY4H0Jx5Be4Xa8Xwv7JrOk51OimjDJ6DIjjKkPLMv3EeIiH7oX2G5LX6pjHbPkdoPRd6+ilP2NrCcWrt8elYbjsymnKLHCBcKYoVoVGFLrTQKXaPX3LE4jmkWn1tamHkYxLqUH/MGV/WcZ+bkLlfo56AhKip1FnsylrE+Gfigib/bNS2tQIKg2EFq2YUKyPSuag39QOQYTWLGXeSm0HWMBZSIhaUvTUyMR8Jc1OSHVDGgkvhmN1AheagD/DuHCKpg5kGe0Rbl82acUfFwlRHzyAezJLykX59eJppJO/djnEgvJRD3VKg5KFhL22njCUnEKGuo7d1RRkj2w48yIFwpu5b6BCyB3SnYSCgZ9dpat2LP00MfJw8ULkCzBUbUJcN+vqDaSOD4uVta2wazH7oM2RYwPUpAeJlUliiVSpWNOnrFdpVIOKBWcPyuFkCwnr
 BKkfWJTi
 dyVjthTmuxwb2JOhIwfowlM0H6Lnd5IaJrFs9VxpRwTH3/WGof/xS0f7Mysec+l6XijTRfLbLzeEPMCRalg+LeNGjprccVlKIQOR3uxuYpRPhJ46t5glJ4YBWLy+uEEMPPAWmzWK/1ySYfmnTkHxj0qTHbKDyoo9dshiVsYxJRvj/6Qa1J5P0vRSZPa04iGw8OtVJ4fzgMNRw+itGip/Mg0zkmrUyN7vE6k/CJNsDC0rJE9v1//zV5OXkNR2x5W3PmomhQQdSXY6sC0LAKlGQHTomAGTHlT48mV4ZGKlfZVXLmLwCNKpEv9hwQYMkmMjF6xdcQZdhTkEkBL+GFRxhzH9m0iWlTtpFsKsLZUkYZ85aEJsNxd4tYMJwkqriwij1nGHXXS8oxUkzVl5qSf1R48deg9r08ChaC1RYF3g2S9kCDSv2iUHJc8mBS+SVqDC+9g2e451FEivW18r5i4wgaW8v+ei+CGsmeHjyidYjYdD1ao0d3cOGyNt+mj187RSK40ThfRtJ1L0UXCEmRgjuggNoaNH1Xde+WreSdyzl/Kffkf4GhYZ12BXAnCpFjDyz3LxQ8jqMfwTMWfkeldUkpVDR76BwDplJIG0UgTWTEeAMxeybWBIpd+EhU+H8ocFRSTNIJ0EmymysPj3p5wpuWsW/BiJ1KGhDpruBecP0STuJ+71YRsb0t0ulSOQgDbE8ehw6t1tkmsLX9R7nDr5xhNZE//S4637Nn1rR+0hfrtx+KrR1dgEKlUcWrD81ZNTioHPnrjxdC9Gwg63e2sHZGiIGvzqZOJPwd12MHl3ZACr89kOrWr5oeSSbldCZ3lbiuJ4Ig84vw23pjjYL/TfDfPUYSon2v3Vt645f5eWqrdmLNeuTowQErL3V0TH3uzzB/LDmaQqr+yJapokUjAlKRARfTaMlgvpp+0t0F7zu4lSbj14CTpXSuUrSl/OfxMn1FbyAD+FliyUCqB7RSNcUA2Bx3YeP
 9wDXrx4u
 T07c0kHLzS4ye0MjMSY0zGsWi405hAec5YiNRLz+FccEQ++B+7ozL0DLj5V8HHMOI3Uaxk8EkBHXlVXNYUKhG4/1/iFZ+sr6/P7lDG0P1cMPICvejatQGCLwaz5aat2i+X0/8ewz/8h+ezeerMWbTbRtt9sOGo11PfuZnt3b5HahxLqs5zPYbwyUfjVFhIGUp5uNHZQzlTOFc44KTKIkboSE+tV19aQOVz4upl98QIkyF+ri9NcDWoMk1IWkbN8LXBT0/I/WapKLPEQA5BynD9T7UB1D1YFNI/NFYSPphOGjSiwldvIOADHpLacBeUbr0bZxXCuFtumdob+7J35s7wrsS+r+7QU+Ppko1YzOABcFoq29NZl1buaM7A7YL/kRqhwhrgge+HcOhvwQpT5hsh6AnVRpV6iIlU0WJuQKU4/7JGh+RGzTc7H+ns+z17TN5O8E6a/l7b/baWnSh9IWXhe0VRKO04h2sBdAG0GaWKjB6YwWlSWLTCkmsH0tv+K7qjH/WuZHvXZ0r9apTUHOE+s1Ha0pgtY7uOhGI51mcVO9nHYawzc6obwDJJfwb60OeANq3S8vJ6FUfsIR4QpOj1HSL1b2EYYHZDIrjlOvRw6pT4LecUsAx6G0aOYhqcR2SEbbfhm5Cplhr7pDpBAWrFuH2vnZOAlbWi9En3SbMu/di3nvdRDSizPOqORwVvL7ojFN88mxFHZQz7tOwfIgPQ2cuq92q+Dt37SgF3HJCWqAnsGCmCwqyaU5OnyfAj2fFtU9oeG5+jILOzbObH2ejYh/V/U20AlAb11YjT7tC2gRdhYX7InI/OghfoUNwvO53M6ZXzZZcC/v8oUdz0CGeiMQPnyr+/BMgR+zjQ5dQSKvv0onjlpx17Za1hILcF/dfgKIvIJtKadvqNvK9qeYnlj7LwvdrtcS9CnDjgL9rbHXHz+7msqBkxPyLFlvrjz6Oc2FZ2R3CeM+xYpKhtYz716oFe8vb
 NKvQlJZg
 ntWMEEH8t6np3C39eBDmGc2WJTyeBNOMCxQMqqltm80FnBwIN8WoTjdrA7mORIc7KLzxJl0EdDp5xsNy21FZf7Z0NmyiAxIDjVcFEIRBHAckzuGd7aKVc6tHiNLPiLjtqQEmwybtInrNXNTIcrSPCn2W8oHHXgVg27oAg6gUPUp/0Y2w8u2EJ/g6lNMrnkxya5cd6Hsn5fEC5lHix4t4G3sLbnqefKqtnXgI+S3Hgsv+vjBl0w9kyan1BHj47Cd78wKdOZVkh6g46xBoubfHYO9wQdvWTBSIDdy+Wk1GiQJ65xjES7exkveph+xDUKcBOWowj9Ih2irqol4YX2turgI/dhN+Ygpc1BfhRQUn3/c7jJmxsHO5LXhNOIr+P5isFA1qAAzE3QBDQ457ZgNAC3hhLhiComEG+pEHwhWAaui8kRsVUlAt+mc1lEj9VSykE5iKPQI8m6dhoobgZrdQXA6xRxpV+uZ0UYQLS8qmZwbTzTYiTN2i9f5to/9XAY3eccbJw0eV5Z/MZERjN2z/Hr9IwWz8xn/rZR50GzuG2gsB0lIlbv4mXH0Wi0wpw6XllEeH/uG/NueUzZ9XvTVEmtuBVZMhYL1R3LqDfCggRtFqAvoOyj0eMLf9+DuAuh/w4VrCGRO9tzLB71+YEocRpvB4dHNBC8roJr1Ue+6YFaLJhhF9KN94/Ny3/Z4IcO2Rfyxk3OY/d+iQUeg9cFGDwy3baQgu4K9gR6aK8C69LxSJPxFZ2h6FOw0vMyNhEER4GHA6cbFTX0mfYmmPeauNmEHRO1ZBk1U6msvPQpov3rh29AHTY8a2pWrZB/WqhF0uPyIV9Xf7x41rLiNBtBXUL8zAAan1iOYI4j7ERzetjErp7uuDtPRMBtVwsj/BMBToSrCPi02lgikd43ZEqw1HoelY/lohzCBAiL7fCGcvfkROc0onVTIe2ocgaNtOn/dTD3CBmcMltUqcXUOgMMoXmmpj5FuC9
 GWVwID+b
 W2KPY1IQyzzQuflRyDHlI+DdpJ45RWghbxrJVIh+6QFzotb0DrqS9jHjjHN1NqTRJMsJ9d+cPaSsisQY5XdUo/99Av9p3heSNZEltoZZ4JGw1q/q1uiSs+1QjZuSI8QZDZukSBhFDXjFwsTR00DgoB6Bb8zMAQKAuWewTcqDIhKkdfaQBP/Minfj31KLGzbUxG8Oldfk49qml54araDxD5u+8Fes8H0RXc0qNovSbVEalgA66BInyPaEjPvgSM4hs45EEA3/nYN38UtpsGl4i38St0yqT0vsWDgnYDZN+jAe2uRXDsTNCLBgNsKFkLc7Uel9mA7WIZq6Rc9wBAUuq78wnlD5k0zvzMnMyw/tRqLwvuXir+Q6BDTwsHmaUhZ1inmWaEaYYgQVg1coJSrqbAiTUxjDHIdNfV6zodedBkd49sLvoAJZREIL6Ojq2CeuUngCzdtQLpJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have now made it such that every driver which sets VMA_IO_BIT marks it
as not mm-managed.

However, vma_flags_is_mm_managed() currently treats VMA_IO_BIT as
disqualifying. This was a product of drivers previously marking a range as
not mm-managed by
setting VMA_IO_BIT alone.

Fix this by removing the VMA_IO_BIT check in vma_flags_is_mm_managed(),
and update mmap_validate_vma_flags() to use vma_flags_is_mm_managed()
rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
longer (which is now redundant) as it calls vma_flags_is_mm_managed().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps mappings which are not mm-managed, as
drivers use it
to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to mappings not managed
by core mm, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
mappings not managed by core mm - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  3 +--
 kernel/sched/fair.c             |  2 +-
 mm/memory.c                     |  7 ++++---
 mm/mprotect.c                   |  3 +--
 mm/vma.c                        |  2 +-
 tools/testing/vma/include/dup.h |  3 +--
 tools/testing/vma/tests/merge.c | 10 ++--------
 7 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b5f06cd174a..3ddb463db895 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1627,8 +1627,7 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				   VMA_IO_BIT);
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 /**
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..a07a658cd99f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4212,7 +4212,7 @@ static void task_numa_work(struct callback_head *work)
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || !vma_is_mm_managed(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index e5c1d1c35bc7..094983683f24 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2343,19 +2343,20 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a VMA which is not
+ * mm-managed
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is mm-managed.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   vma_is_mm_managed(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..706c679d4281 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    !vma_flags_is_mm_managed(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
diff --git a/mm/vma.c b/mm/vma.c
index 51bdbe08bb02..cb8729b195ea 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2796,7 +2796,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
-	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+	if (vma_flags_is_mm_managed(flags)) {
 		/* mm-managed mappings may not set VMA_IO_BIT. */
 		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
 			return -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 442ea9eb098d..94bf818ad0e1 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1667,8 +1667,7 @@ static inline bool file_is_dev_zero(const struct file *file)
 
 static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				   VMA_IO_BIT);
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index acaab282939c..b26f1a66a170 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -496,17 +496,11 @@ static bool test_vma_merge_special_flags(void)
 		.mm = &mm,
 		.vmi = &vmi,
 	};
-	vma_flag_t special_flags[] = { VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+	vma_flag_t special_flags[] = { VMA_DONTEXPAND_BIT,
 		VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT };
-	vma_flags_t all_special_flags = EMPTY_VMA_FLAGS;
 	int i;
 	struct vm_area_struct *vma_left, *vma;
 
-	/* Make sure there aren't new VM_SPECIAL flags. */
-	for (i = 0; i < ARRAY_SIZE(special_flags); i++)
-		vma_flags_set(&all_special_flags, special_flags[i]);
-	ASSERT_FLAGS_SAME_MASK(&all_special_flags, VMA_SPECIAL_FLAGS);
-
 	/*
 	 * 01234
 	 * AAA
@@ -520,7 +514,7 @@ static bool test_vma_merge_special_flags(void)
 	 * 01234
 	 * AAA*
 	 *
-	 * This should merge if not for the VM_SPECIAL flag.
+	 * This should merge if not for the 'special' flag.
 	 */
 	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {

-- 
2.55.0


