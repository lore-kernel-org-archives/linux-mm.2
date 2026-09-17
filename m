Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1DBDC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017F56B00A0; Thu, 17 Sep 2026 12:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AC66B00B4; Thu, 17 Sep 2026 12:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5776B00B5; Thu, 17 Sep 2026 12:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC0F96B00A0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:35:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19744C03EB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:35:46 +0000 (UTC)
X-FDA: 85223805492.21.B8B1907
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 402701C000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:35:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IV/9Pasm";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKVFt5hWEYnD6eEg5v/Xa2EXI6qsPR+4lUqezNWfIlU=;
	b=GHs8jSehtiNp1gAD3tgjdU1lYw2muyvTtzUiPviUakc/sFegbLMHiH/2YjGMvzV8j94GR/
	5yT7N5iYLWBEZHtop9Cw5pw+9rZferqKHf/VH0IzDepGLn8m8WvadC1Vp9tMOcDHsFfTnK
	RB8y5QhfHobGL4aTPL4hZKX+RZLAGVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662944;
	b=Ix+MNsgt4r3m2CghCFdiGJUYeBm3ydT1vIhpBpDVt8cNiWX7J2A0tD+ka54U/h9TO8TKy2
	VTlN0izv4EGNE7YmhBtt9vIH+aHKy4Y+1GkTAXgFtg2wU/FLktAR40JnaHNI65K6NLg7Zg
	n66uqBpka75IBFzt4vDVsMVn9SIThqE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IV/9Pasm";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E495404B7;
	Thu, 17 Sep 2026 16:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F111F000FF;
	Thu, 17 Sep 2026 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662943;
	bh=FKVFt5hWEYnD6eEg5v/Xa2EXI6qsPR+4lUqezNWfIlU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IV/9PasmZBO5YhUTKMJwtqWrDzyfIMqG98/OixkibqYaETeveCJSocgYxeinKbgWe
	 MpmlWpxjyxZJirkQc6IvLeLnsl5k9Qb+FABl8TpZTDl4IGbNImcxeUx5LkBJjyyy/S
	 dfOTQHdnOzZ8R3RoG/CXK5ZNSnSORxfdCu4tIg2CmJ2rQ9UMzfBgGYbpWkmXlqTlvc
	 ZFzojg34izQY/BkB0N5UslgtRdnFDJs6wKXp4YB2TTlkgKCQF+IyEV0DKTQdyp/TA7
	 b5Cyfq4c/U04mWPjwEyiBhs4nTJGz5z5iWZy9wy/4BbexSb2mlB8sm0LG9LLYHs4gr
	 JlWWa9qVTrEBg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:34 +0100
Subject: [PATCH v3 25/40] mm/vma: enforce that only kernel-owned mappings
 may set VMA_IO_BIT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-25-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=ljs@kernel.org;
 h=from:subject:message-id; bh=srNzKq7fofHttIELlvlJ1JXyChSF0gnbXxhEM58NSes=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB+qe5lUeSZ0do9k1ofr3R5LajbFpLa2dWjl3N4yK
 5PxSUtuRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayvpKR4b6RTVDOs/tZHw76
 Pf4btYWFM3zlM/kZ4bVfDzxa7RzldIfhf+LPwCkBHut65XITpNiSFkr3rdWy/jLz0OrUifvY79V
 fZAcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 402701C000C
X-Stat-Signature: u617zij9ibbkgmt8dmdnsh5ntwxccskg
X-Rspam-User: 
X-HE-Tag: 1789662944-782952
X-HE-Meta: U2FsdGVkX18/dHckmc+XKggt6l5ahQnYReTTMbqOEpGqJKZ52GC4kfS6n6pBxO3FNs7lghjsEVxgKctY6CaQkNuPGEwmPymwYN/8Z7F4yKQySqLpmWxXAWAqxTS5wOFJ09T22h9JMJBVOZJNWZdHEYnlhcTB8qRB7iq8YzX8zA/sXrLOtQhQTEm0pSt0TwSxFPSFj9ZH48GG8VMeQb4IqkgUglayolPVErYCEpeWtaI5cgU/8/VJciseJP6h48KvavOPJ3GTbHJ06CQGrhvOIVLldntbMMjVRZyqt8MgOLYruSUkCy1RbHNzAAwOfxq7mk/NUE99fv7qcZ7W1umL00g07zt8mYqLTYh9zRzOXlVtpDFpHf0crymQAdpXstsFbhsj+XcambCzHtidxFw6cb/xc03bE02Y8mFyg+6tpJ7jR/MDrrD4BVcoIx3Fscvt2m34yZjh0AJK2d65a3aLsQ1/FiGBtL2pGM3XPPYGXA6KCp4PuwBe/yJ6fwrH9v+GbuJbB1ynZUZuV1llVo14Z68PqX3Bf2TFrZaTOw34f9D3sJ45C+NoBzV+yddSwgZcNlFWkSoGkPLbv0ZGHKnUxKmONd/1ygpDpEnefw2gOCFmvHiz25q7MLtV7d+Ghp9XT092JEZtvQk9fKLTXRlh4mVeA/wEGBpyRIUTsZyGyuv2EE9dpGFcxb43TiAIOE4fNwk0f4CjDkCUSmX5HnNL/bsk978fWVBLfnu7Yn2+w/333b0RcJaNaDQ4Ak8XoEUZk/Wr6goTuZP4S0P5lrIC8yNXlSZ7b22av/8MbGRl+q2yYpJlA8MiX0ycn/9FHp4VJpNzu4RY/dELk1WK2rtt85EODQV+EWUjvzhx6JiVXxGUElqm6oqPx8YlSYu06oqGQW/ywd9BRoGREvvBWpd01ddH8UK9KBUVeI7N/k6ysc9+/vk7GmTBNv/j1BxvL+FZhM05T5wubZv+XpWa40i
 re1xNEtR
 hU3uuJnTClBeEsCmHt9bn0t2yTf+x8+EmlvmmoQguvVMXnQtI5+N3cReAe94p+smPQ55UzPaOmOPEiVipBL9laWqzqhJSf+GhtlRZMkEfVINDglj/leeHQ8TuemW6v8Nk+q+S6Ta7TftBwky6OuiWkqgUhvMlhKNCwIGDpU7jjbg9tVjufGx7262ywj6P1uVE0rAydr6QRUTWsXLcL0ybLNCaG//GGkN93EKu9GY4sA12qf9TzqM+kmBK93z+j8P/SLQFMssRwP6dy5vr7biTjYWBhY5Cj+crfC5RRFJJWtzbMITuzL0m7qqggJdaH4qMwpQeny0nkfAUfs3LZS5lhPlTfFigkddRMrJZ8hjcx5P9waRku36XeG954bWd99WjdtaihoptJpNnb1mW9Cf6uJIImQpMSJLeK72DYFRNzXUoWqRcPOvwR6HD813/fpXZhiiM5eZCdPzaLix8QhLKpFXQGwUctxmsFf50fl4wdTAkPKGtJJ24XdVQHkFWS0fgIZcqxG5D8Cqp5KcHjFbB6eOqMfKL1PfnFAGTssj2qmJFg4Yg5H8NXrlIXf/XcWufQ0t3j9RHO/S+sgqZOR21bgGIKvTHMPPIkNk1mzNIiiacHn7fuNnxT+twzmB9k54Bk/Gp8z4KHP6WiIPTQC+fCkXl5AHUupvHSPin1QjacvU/JJLJfcMZF3sv+DyC+MMUYsHTtWskN5OLT3F4Bp6f3nmGbKRMUZOAVgkVBvHXmjI5mUSLFLAX4VE2yCMqdxHuAUPj0jmwvG6n0+rWI1QKabcy5N+SOj6MUgSASzDnzvuxqhe2rpNrp/hbVRABcW/wv7+fOze5DtjCtP8egonrSXH+d4H8+ricLWwrl72g85BQsO/ezfLXm3Fonn4HqLl+Nab3hmakBNGEf18WTwW89xdXzIkSzwuZWE0lkTZTP2DQAiBE2PvQRu44frsQWvmC+4mXHc75XxVvR//k7v8MgEVHyR1k
 X7oc5qz0
 S2mpia0Qw5GH8kxGak4VS9nEu6YvnBHv9LE6N4jdFLMLuv9johSA0eHmA1csl3ONcmmMQm7JKalKkvzOFFjOYcoCHY7scQmLdn3TVQNiJ8ixe65y7cylhvQipZ8fBBACUwoYDoT9CGjkpGpt7q7Z7RCZ56zeciugbspej8Cp/ol5K8jFFfeHdCvyDHSjE2DAc6oFRylw8HslmshBnaOPUhYXsi6nQgb3Qc9FhMFldVtwlsCsxyHbfXPNGi63Zifi3yjzJicSL7RVDjdOaVufJwJoXa/o+ENMVx08VZ4oOqhs+I6snVWOzQzvVOPp35ci5cSUmAJYhZuadeT0gil2hSqTOS5UmbM9YspHqqAueTvD+k6h5dxo6/4vbRs+IdbZRLcs2uRRY70wqU2JIMg65JH7DRi9jWIj6AOhw9Ouh7Z3Hrk7SpRoN0nznIX7RUxhbu6I3iuMDQylpy6e3x2SHhBHEwKarc4qe+LhXEoHjcZuQz1v5Zlk5x4MjDGCmvGffN+AykKg10YIc4PAV3klvFEVavUPugb97uFEUvJw21O9meWJUmoM4w8BWcIYwcu0N4NQO55oa5ao0U8MbaApttKZDhSNTuysstHI1p4/PAH03tannQbuQJPx6ALt2uMctyIMFJ9WL8i1vMQOS63CApFQaqx1jYiJcR3vPvGsHVIIWnTCTr030Am+GUBqPFlbVjO+m6uD04nxhrKapOVAvft91cWowVtgFypnvPZhJ4lrW44dl8d6jTfeoWvRZGhzwJWzD0WoXGACFS+uAWo6/3H4AdFtQ/U8qdUhpi+d4xlI6PP3SPWoS1VY5+Z/0IfF3d+NUi5dK7WBnJii/V01a2MTFJrmmc6gbXlMVrcaYGCVoyToRXExecjQ8GQkWH5PGe10HJpkKMDxXUUPnp3R9RX1i2QsewE6mBjpmjHB/ddKb3TQZHENpfTn2Mu8hBlaY2vCbRv73xDNPNPPlLUnK0Br33gYH
 cl3aSS9O
 FJCuzib8nQWZIZhjyYYifPvrxmQ/L3vYM96BZlMoRgfT4D6pkVywxRgpUdhv1awEZOg2Zm7TKdNTIH5wBMnpAXYvXnuYGoTAMmvSSqsV962HEIu3e26tCMIz6Wmz4CqxH2CLYFMcpPxWoeXS1COn0nLGGCrKgNlQlbD16jOV2usKAZt6ojNmaM+dLIaPdb8beCqHifhweyE/3a6/lFW+ln6YczUT8vMI2nVpkVkBFJfYIn71TpDyyTfCpSQ+GxGxnUQy1scDuelGmre+G3lRERpcGGaLdPBtk2ymReQ80hg5CFZY3aaVG/i13110MzQvbbhnXMp/hfXX3BVYiQXLcceICmqkzufN1WQPSaUa/P3oiJWAwwRFeyYYx7rR/tEK5WK4Vb9m36kv/bYSGA+NJz9L706qVV7KJx4eI/titj3SbrJ2V1mL+DSVuJ3Ej+elKKlOCT/bOXkNV2T1v/rsatJ97mDU7v4bUsVrVW4eheqgeBMI6uaxFqtg6wSnwv4sWT29HZR1RvTYA6GvxQ39ITqUu45TElFT+14hyOODWtfBDqQtSxE+a7CazLSMh/n2tOBihjLCrmJon0P+r8qe1kXbvSdLGyBf7W8Vz3NWrb0VlGmKkwNT0rWz/WMOe+fe/YJtWux7t5JNEAT1M2ap5vfFqB3vgI/dHMInDZHwcWU7eI42oSVxnHCL1sdsNrtPtH847utwPQ8eLbjHYC+6szxTQXhoOvo46grolLkCswl9RRVJklN217MutbTj9Yd1gnczMBxs5rJ+jH/ncfmk2smJKViRk2INJxlwt2l3j4rpE6Amoz/eO8kOeYWJMgimMs4tTmmWhaUg0Rqf1HZoAPpA+b0s9f3a9ZlTs/VSSeQ4kLO30L7fmNz4B+lCtxD3nhqRmLgKum5sjFQvnf00mPFwsRv5LPfaebNQj2v5gC6YY558HyDLKsHCQ99VtXfbpzs04UcpNRJi4LqLT3GNmoNvzLulr
 UUUoJkxM
 PS6HU58ooG4DnAWvhYs69QHzZjUgx0y9tJCmQr8TFv82Xo/hPfbEI62oKEeJSrrIxyCTvFuU1IkHeD/e//YfrI+W3RqEl2pdLnWfsOQSq5AFAMLFM0T6rJ9VeNGml7VCa+hgOjaAUjooH+9XVDA+lmDnJ0KBKsXoQibI09i+cBnxFqu67BZm65fismsaBRtYUX1u/PbT7b3nkYhJIa6GTVD4C7V2yKIL20MJ6xOa80s/58GWI+8G3HE1iPebN8jdCdHBMlcA7+qqLcZGDGl1SL7KtYvnEUO/Qbl58bOuQwRU/3KbTfypkjWLihh8YxkKe8FYpgaeYHSVmL7OhWjrrzumlPbWGG3Isyxd1E0zojC8Ox/PdoTabYFV5XqqKbQJcIoaLx1SDdQLdQgt/iImV4N7PkKqXw1CdUcOcTi5cYTpuVgdlHlZWphhq1a7WBQfuzsTn+hM+rsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as kernel-owned. The check WARNs and fails the
mmap for any out-of-tree driver that still sets VMA_IO_BIT without a kernel
mapping.

No functional change intended for in-tree code.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 1db8b218fe64..56a0cd154419 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2787,6 +2787,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
+	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+		/* Only kernel-owned mappings may set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 

-- 
2.55.0


