Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B186CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A2B6B00C7; Sat,  3 Oct 2026 12:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A066B00C8; Sat,  3 Oct 2026 12:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2056B00C9; Sat,  3 Oct 2026 12:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 822536B00C7
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:43:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1479FC09B5
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:43:47 +0000 (UTC)
X-FDA: 85281886494.27.F43C9CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44635A0004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:43:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTINW59l;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kIT+NSwzB8WFQk8dJPoNJK+jJx3kX+5/gdc7Ft1Lo4=;
	b=TKEWWuD2xsFyXY30imfQLK//LgArwsnh1kuE44jJ8P/iVzof3FWDm4nrDBAcgSIqpNxkRS
	xnZZ4AqXtMTixtApHKQoSCkI96xiMIXxpLt8gzDwXf62cdx6ORpE8owIq/MF8iv2WFSAH/
	Rrfs5GSiqYRUx4SvNI+OS5bCUrff1Oc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045825;
	b=5GkMnp0L+PSz65eXMR3hS1ey1pRdwFkV8lkAJST/VkYBKkczPBaKPOENgOkLoaj099ctmN
	GEZxdcmdYoltXx2f2qmzJi/95/1uzo9Qk6GVHNYyxIWgO6Qd8sQ5H+EJCYHGjrG/C8KbAW
	VzYNnmFC8ck6GafbpEcgEbhr+Jmzl4M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTINW59l;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCBCC60D82;
	Sat,  3 Oct 2026 16:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A6B1F0089E;
	Sat,  3 Oct 2026 16:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045824;
	bh=1kIT+NSwzB8WFQk8dJPoNJK+jJx3kX+5/gdc7Ft1Lo4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cTINW59l1yamg7P7y051kd6liz+p1e90x7b0p1DJmHp11hWoOckeQtyu+6Av6fzfS
	 d/olY3OpCS+V5OKZAidIkZ3YKIJt4ckFPZz6+0ZyJ58rzZ5Jprtva/0MalgasNcaHE
	 6hyyZ0rlxwPDdq0tAOkUMMOMNDK8ntQjodyMNQ0MknKCPBDRxrVxeyh9fncHHK0rc+
	 SVziT51qN9CAi20BkeO323yGJZeVmIQQ+VyrOZ1CGVxCoNWWugy81kmGEoaZ1kde7A
	 px47qdDkeZKgT9AccNQi8kIhwHKT7eLTuD7KG94yvjy0gVhf/prx/YSpP2dQqcLz3L
	 9X8w9Vgv9ousg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:01 +0100
Subject: [PATCH v4 30/38] mm/vma: introduce vma[_flags]_is_mm_backed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-30-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4160; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Y3b8xUgToSJog4n58D2kDCliQEWnfU/R2ucO/6ABcQ8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mn7Mi75P2nhk3mRIaYqhq2/LjJYHK3meei++0HeC
 xmnxDU6HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI/FpGhrMTGZTLLVz1r/d3
 XDl8a9uXw1vv7H1rbf4zUkv7smZX9wJGhrPOdyzvBtaVWN7vv8u0gberu8FE6Tb/pSVLlvxdl+b
 4mh0A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44635A0004
X-Stat-Signature: si5xxyoiybi7kapy5zsjqqh8g9cimjuz
X-Rspam-User: 
X-HE-Tag: 1791045825-781571
X-HE-Meta: U2FsdGVkX1+U5/dO8vtW8QkPfdU5IwhSzNAzFmocFdkBstnkM4E350uAQ9a29DdlX5sjs9tw+kRnbW0HHDEhVj3kidLYtKPQfWJxXtFIud2kOeY8rNe/MJq4lELjSuOgcNiKFcTwCpBp7oZnUv+7FIwztYld0SWyTugxPwhv12CJehGi+ATNjIUkAaM15+xm054BxQ7TWBP0adSlxKroBWexSdE7M6Dn4CQJDuJqRZn+REfoEGOyjmGhmxdFRI02+Ha/boceSCJqoMs5qz/ro8h26r0pmTjmqAL8oqMk7ypRQoa1wzenrAnbD02nYhWGZ+B8FdDnGVLc4LRHg1MGTsMJG1H6WSpDUmZxNU9BvWeQJ2tlHE/9wnfocxGf2qlMI+Gt2Z/bGBMO996qEdggqFoLBhQsk2g0g+DrIWly77sCvdaArn7cCPpcE9sp6VJoKClxCr1mJWny8QbwX5OwBJdeJyhDWonwDZlD6bP0bDZyr8o7rKnMCDaLlC3WVOyoaTZ25hzYIy45fW2EbBv6FtSPBRnvpouM3EUhj9UmYn7HJxNNhhrzePOUxiVDktAKl7KwyUx4CHnQos/3L+Mmh4VpuhuDc0GcME6F5T1+npAdA1XwyM7EwiA8z3JXTECNyuDkr71mT+jwbkHFxZjkXqdUZB55vmIVOgbs0QQBxjcWoRdzmriJ15G4K79Gmdt6RJMYijt4TexE48J2eqdfpPZNc7WlYx+0OWU+drfw9pQcr4EuAPbDAXPMZ3na3M3yNa4F53AjyD9MWrrg+yVVp01xLDRNf4SDnUyxqIfZ8bWHDBSFsAjBwhOkSTdfY0N7/Ty1106uQKEi2j8jahFTPR+Zj9QiCcXgPjAaI4v9lx3gnsJ0uMkGnUfEEKR9Z2yvAIqLqsaG6G0b7EsgbV4CfdmaBmASXBhKrlpKq+AjUzbSktJTrq0oeNtQ+lOT3mh9U8LlV3NupF8ENyDydql
 p7/B7nDr
 HunAuolU5cIrptWRknvXgWACb7r+xcz/r5SEI7slZKA0gU3bLcrmablCSZo30Lw9X3EPoe8Ya3K/7k/nmhNbUczYe4FhtxwJYrqv4SQ4P6Ew07Tn+0sRAGJHaMl+yZRtJtUGV9xfQ6y8hAWx/KVzHwjm/xxmxzGpDE/s0tFJyF/svliJHbXpIiFBgr019RR5pWYTHmUSXV+lD3Omgd8VOaSx9+LAK2b9/6Hh1wMfgLwcnOoC582/egxitb+g6Mrx58Ws8pNfx9IeKWG/D6wOCKyHj2ByQLHYBKIXe2cLBMb8xmMd6dWWZ7bsrsxl/563I9bcWOQuVLqCbGiiqAQqp40oZXMK07Ia6aydLPQpgaGRKg0Nrf0de0MmeeQ/u9Rh4ommYQSjfM7HcxC7iSMGAV9SueQaozxzGybr27CI9+50MWlKFvUHID2BjqS2vi07lkWkFiaONnBu1AZ+jO1raPoXYrH1v51r01mKFUk2EYjA8gfRzL6KuQHfFhZNJ6MqaI4TM0STrSNNpAfb8J5Cgl6O9CNKohgAy5BhrnLIQwN0b1FRQlc5KZYWT7YhguSA0JQyfwCg2yydWgG5dyhqhxKAcHvFopR1ePlxQYw3J4pbymXuEoEU3JCYubYQl38nYyy79s/A19q05UT0UXPSt61mD2P8n15bwGO/7ciR0Td4xKxT5k+tgPS5YR+PI55Ug3b8Mf9tE29WXaTXUrKSF99eQApzyb0pc/0NkutbDCfLG0alpyfOrHlSV1+js34EWWhNF+rm2Dt1L/j9mXTG1NVGp/Ij1bHdKmwDGyFbI9M8sOqLPYWQP5U1+dNKbc16AoxloEDX61I5w5thGiAErq4yLzpd9rW8sxtQ/7LlsOmXyg8r6yaGdIVKI464wN8Xp8gpVyU8H1wr/CJm5612K/tDBdZq/4Z1SlEKNRhSd+7E8Qcu/57wilnydhqe5G94JdxhEJuZNhhOhXNHI3xD233TRfDg0
 8lpVCYMc
 j/9ZbvgRHmIUPVhNCvmPtljTFYCysxHJ/rQAyf892IdNUrIuk8NJ7D87U1giKjlPvL1h83m64BJp9v2MPEiiMoAvhXnMtzoQy/sLf7hTO2LYXJ9PmQr2x5aF0efhUI1/sY3sisPKqC/vGurBsNiQdfNZj9tFJWqmj49AU9qV25NmQuiCfCHPcs25Qxa/i6VRJoZtPp6miWubJt1yykFDEh61UP5nW812E2ACHMKaEes9rU/ij/1VS+X+SlQUScmVcQmshIj7SK2vHBZxD3fY8P4PfGg61Lg29/1DiYad6AJCaysKghemnYt+4BfqsgDqs4BkduUPvINOCMlC8aKcIV2nbrtwFRffzFKWs94EPLPBbk/tLLQtslkXdRcfpWImx6XFx0iAvAMN4/s9q+NOol3tMFoOj1zV681p2XJ7UJ2OHgsGBCUTAxTde9NzqJ5CiQnkxLAeN9JG2CkMfjJbpKPcmTdiE5a0gDWOIBhnalbezirgc0dBARvbinuX2uc4IHmYHbBEcXpwDkTx9eqGUFgO9OUmqNWsUp/CvjrdD4KS8D40rxEdMliEy1F66nils1N3WDtqw9dwJ5HrR/XPBRcq/FNyWm2g5i/TVhQHi3TVm76ZECWsb9d/rm5AUmZLAWrZAIiRgGCSVvCRSgSPnchgDNgUD/WUbuLHv0XKkUbsVSlbmX8lllKNfXBtHaO8zLtWRWpJBdhX3sleZze3Aq+WzhTYAWYjMO/W0DHG8naFp0i8/E68D1RKG9ecM9wfdfkWEhb8CxehvpuQwzQKFYc75x/GPDw7bFzZdNyfG4qJ0Z/a4sizfEIdXWHBQWhzg3Ssu7x9Q+58rjyKEI7dgqH3jHiiGYnNsFRz7WGFogBe5FFJraIdpN6d2IqIavVMTHVBPTwanyytQ7wZBhI3+ZTzsFETGmUlsuXrSCOBeLxzfz1X2WL1+sIUaYOl8Y6f1RKCWynKvQC8u0cFTsw+0ZT7BBwwI
 VQKbm2ap
 +WujqAXOK8hhXQzBh6wR/yRENooLJKGWBwTSRjlpBMS6lMQeYrk07mqvi+j9KOfMBjCduhEyKHH5jdetv0pQcAqiImzzjh3bwrHttTu20z5IMBKsRPgNA7lqMVxA6LVY8HllUaMv/w60VXS7e4Bj4ej2JIihpHIcsUiJHI+NLtycsh42MWuquvX7CJ4oOASWzxltAV69PlBU9W5T0gaBRiE5TuwJsrfI2e3JJ7sujXUIJtnwG8EYQ16wRET7LGK9T86/XMPdyL2Xfe/IafwoehmIdb6ONmKjXaZG5QSjX5i0s7uR4kikTM1cKzrAtqzXAf5T/8hPs1E0FcEdRhDKGbOckFDKP4HFih6v8W7F2+v8MNfBy5IgnP4tzrl5ZS0W+hGSyj1urlxnEp+xM5+e89b4Z2r1UqGAg6XWvph1UMgAS1UtAZP24THFNzeyI/wLmWKFvPIlQRlSsFAclqYepwBEhDvT7YIlDDKOXNoCTxoFLCWXg8eN1IkiDmWnOeBvDOs6KJ1Zheq8EQzL00l2g7kUnY5gMaIs1Izzql3V3mNcFJaLCLlo9KsxLWKDToK3vPBWR/GcqnJ8+2okPwM1MVbvMUPy8dWeeknFA3/Pa5fOOFFvNIC80QvLdcAUZargEpj7e+7rk0femBfLKelrw8ASpX9JdZtKKFcDiCWN2TAxey7uvuc570J+Y56G5CLoEgH4DJ9Ud5NJ6KNfRXC4+NAoEuI7866H5irj9lV+3zuiEGi9XBzbrnhnMvm6MxZaTYkitz/TjDBrkhMaO+Ep3tB9MDzftTAEJvT6JhPzERwP9DSwHErcnBwLvxaSrm59T7uyGRcxUPBYNoNV4dB6IlfF8MvE8gQX2ffzlDVrtDv13Gk07V68qltmkuZpX1eQL8iBMYqUzBu0CudU7ME0RDVGjAjvxrHvJix7mG0Yil66FZ8E9rTJmsKuPezBSLTapaPvp1nGlnrlF632X203+0PZXJSPc
 O7lnXTOK
 NuHH1oTSj6B7NoF8LD013a02NwV+5CEupdCyKF5yYfe6ddmdY2IhKHrunEO7q29DPMmlcRRWtm+yIqaXh1YmazYgbO04mS0zmejcLT8U6GoUJk9snguvv68/ANOf8mcprpxQzlWWRtfanfkpKAQ1KZ7rH9Ev77/a6G4Gq8lW6038vRq1gqCR3z8S1pYGAu8wjB/b1U+kbmL5YspfaH6TNWtjFmrhef1erTwntt2knywua30bNlmW1gX/ooOo3v3NCqQ4/HgUH2Nm7zqmQ/ZLgQKVoiuh8kdePJay6bpER1SeH9nRHoZuPi5WJSRiyHmBJuLFZlIxCcFkW4lh3oocm5PLmympTW6OGzNB7xulCP2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
mappings which are mm-managed and whose contents were placed there by core
mm's own fault path - rather than a custom ->fault handler - and which core
mm has not reserved the right to discard.

Mappings not managed by core mm do not fall into this category, as they are
populated by their owner, and nor of course does memory-mapped I/O.

We exclude fixed mappings as these have a layout core mm cannot assume
ordinary fault semantics over.

hugetlb mappings are fixed mappings, but core mm owns them entirely, so
they are explicitly carved out as mm-backed, as the MADV_DODUMP check
already does.

Droppable mappings are excluded as core mm has promised it may discard them
at any time.

Use this functionality to update the madvise MADV_DODUMP check to test for
this rather than open-coding it.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c       |  4 ++--
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2ce68713e4c3..55320cf2c525 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1738,6 +1738,56 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
 	return vma_flags_can_merge(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
+ * backed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * An mm-backed mapping is one managed by core mm (see
+ * vma_flags_is_mm_managed()) for which two further things are true:
+ *
+ * 1. Everything mapped was placed there by core mm's fault path (no custom
+ *    ->fault).
+ * 2. What is mapped stays there until it is zapped or unmapped by the user.
+ *
+ * These mappings are the only ones which can be sensibly locked, merged, dumped
+ * or be subject to uffd faulting, as all of these assume core mm and core mm
+ * alone manages these, and that the mappings will remain there.
+ *
+ * Returns: true if the flags imply an mm-backed mapping, otherwise false.
+ */
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	if (!vma_flags_is_mm_managed(flags) ||
+	    vma_flags_is_fixed_mapping(flags))
+		return false;
+	/* Core mm may discard droppable memory at any time. */
+	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+}
+
+/**
+ * vma_is_mm_backed() - Is @vma backed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_backed() for details.
+ *
+ * Returns: true if the VMA is mm-backed, otherwise false.
+ */
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/madvise.c b/mm/madvise.c
index 0922d5f07a12..9d0cde25da61 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1584,8 +1584,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Only mm-backed memory can be meaningfully dumped. */
+		if (!vma_is_mm_backed(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;

-- 
2.55.0


