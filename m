Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4DBC79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53E36B0092; Tue,  8 Sep 2026 16:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04B46B0093; Tue,  8 Sep 2026 16:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC716B00B5; Tue,  8 Sep 2026 16:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 794256B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:11:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0607D140769
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:33 +0000 (UTC)
X-FDA: 85191690066.28.D058EDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E1461C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9GkKh5X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	b=JE9pSnYsClPLwMkrK4fVxIm077dekkcfcEP9A8h8lXJdPkAjkfaEXwPaoDz2HCrzCHkDID
	5nj3NauhNA2aoKriP3lDAv8/uVeqLxGQBrHU59Af0OR4Pp5IioBuMPj0N6+ZKrdT6cDeW3
	YolMd9hv8fdXuAf8ZBj6UcmLo8QR72I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898291;
	b=k29TnsqjqOQdCQlO6nLpteh4xeLmQECjnvdH4Cw2iMiy7cjLizoSHnoexBhMvwA2K9+zL/
	2vZlm943RGxZMBOByk9k4tvn5XkfKs3PHbVxKGQCMsWgk56V5Rc0noLg1+EtpJgDctI5+h
	v7doACpBzjlvIHjfHDbQB5nxE6bt3jg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9GkKh5X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 659A640F47;
	Tue,  8 Sep 2026 20:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B331F00A3A;
	Tue,  8 Sep 2026 20:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898290;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h9GkKh5X0jcgjb2IqzG0A9dMUBhG0CSmrU4/fWVjIOCvlMAmyRU+9t8DsxdM7hCgk
	 xy7li52rTR3mkNeStCdKcEq4CgPfdozE6ERzSAZjPXDnWqbVYmbPxUAO/r6fbXvRhk
	 AV5x44hKZmoOGA59UNltzyCZ9bhdyNfjzt8Novg09Qa+dWrkHxSe+8f5iUdxF/RABu
	 MXCNlK867DngB0zjUjNKFtIUJFUTn2P+WruMSmicmjtpjTp9LRxvUSEswIqxSoMJXl
	 iWmmf828OqX6/yuWA3UJ47biS25/bMKA4U3us/o93XIMLx+TaZV4CxJCPmwK1volM9
	 T7MGQlEWI2o7g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:23 +0100
Subject: [PATCH 19/39] HSI: cmt_speech: convert mmap hook to mmap_prepare,
 refactor
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-19-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2632; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GNn4/WHo/gNb5sHnp4BEq122HpiBRxK72Bb5u1n+58g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7+/y9OYub6mImCvR7C8yfMXeFVZv409uAnUz2JY
 yuWKfwo6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEFp9k+F8Tmn8/JmjzrmCH
 U4li1foTT7b/DLBp2Ss0lfnf4QULLi1iZFj9Lt7r/RHFgIQ1yi7r7V/5N6QGGHdq+jcav/zcl53
 jygUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2E1461C0003
X-Stat-Signature: be1snc6jotnpys6wptnp8z77ircm65r5
X-HE-Tag: 1788898291-39576
X-HE-Meta: U2FsdGVkX1/MUG3a2EmXvRRMJq0rCKIEdu+1G7EEjwJuX8VeLz5Gw4l1LAFHTJarBAuipHJuF81gS8bllHl//MMgLoexSIJX8tlM+TlM5j2yep8HgnQl+vGiA/ohiM/AVje2nM2uO5bp8IYj2oHiN7QCucOrzFj+HacyEMYHf2GSYQFQbaSXBiLXPosr1gsP1N0jJSqLFFhQW6CTgOWRFDsy4lljbCKE0y2DdsDs0VR74Jo8qhj4djJSClfMbwulFp098oysG8leBY9AOvemcHsDYllEMRd0/1RUtTEDbFmbJvkKhoLeST0ZyFT/lD3yPigksR2cXbiwODCbGe/rDyyS7xdslnmSkkbnn5QG50PH9SoYQp/MWJGmuigKu7ROGxkhK3JmsoYnRi0AW+eG3/dQeSRnJ3lF0OVcBUWGvmV4ZDBNcrrvveKJMXK+IqwKFORbkGe//j0gJN/dsY+QVSGrqzPKBwrbTObY5y0+89TG2HdL9RD/8CaQOHesT+cEASHGFwEypvJHLe1fod/D8i5fyxn+hyQAb2+sckzsdF9bwMrG69AqRvFymWPbWzke5e1soVAQO50Xt9x9K3AUeS/x1s51aA164kC+NBrFl/O3scHRZXxC1lIUZoFreh/Ymq8IXOtvWoxMAP83xteTbJ8UvcNHv0z5wDUOQkO0xIB2Hy4kMXXGbXxUKOKkruN8BNefEm1nnu5ilJHp6dXTqlPJQKYODYh0NvYu/7Dpw34voqk9iiP8RefEWROoo4gqHTl1oUlO4bCepFLGNyFYArFMoj2WH8L9ZqjiRQ+VxcGiQEm5zsRoWNhhXXLa0xUq/fTHiSdyDtThdSmwKgr1OroAAkxswzww5GisxO4qngC7QtegX7NM9vOWZR6qMOuypMgFkWJBTT/1Y+VhHbHlkuS/gaNtE5X9xophJ5mFxjpSPIacoCtcbA7HPuA84FAWM/wMuzT9Vq7VQEzwBGk
 nPOgn2s3
 dxBSezyco2mRFBnVXokeAwapKuNQtRNttS10ezuYwvMx95578+7CmbkRmlRj6P043nv/++6xxQy3+5Nkawjh6YAv6Tub0KJXAgxihjeuYT9INJlXqyhjfXhmGEbGCg1l7KjSko4nq5fdLnlPf0g6xwSxQmDXfF/k594qp5tVsXNNKAb9FQhyREoIspwAmCEHqMihzjk5JD9tWWi5zCx97XAygY06AWeHRPbDQU0ptYo8INUubgBjja3Tea+4ABfIcoB4PFMH1cXK0IeU8yyIz448s+tWqR+y5iMSMAuspAhiSmlXagDnP9oSp+31Tuq8FOkokJX6LST7gcPQxerlOAPfrj2MUVHLo0H2WMCKhlOdzglQviF7aImfSzsZT3T7/LqNjkfKZBUsTSq64xKVRoQJWl5Zfc8ctNTaBSV3xyMoFE7K4cULawaN6cIYAuwKFcrVB3NG0J0XVXDXymnpSELfpINYAf+/buWe/v0dGs7Yag+ENwXcwCuR2G2P+RCp+yn+T6k3Bm/PXVJq+ViUTZ0a48UFU4d3k48KkObNtPMSOjT2hZSJwMiXGE2U1/YKgOOW/8sR+1lCTdLIPW+1jH5UiN+0O7lOTdd2Wicpw+J2ZmEmDsH9g1raq3eYP4dXi9xt+HBqnN2meFiBUDy9I5rlm+VCqYejhRk99xCNkLrZlCy2lk1RsmlWAHXOzSyZJLzysyt9ekq8p8xWq58A1PZ6LIrGObLTIDG2NPPpMU7XJddToLPgosOlseD27AX+T1vx+eO03IOrBTYYj/MBfE6Qt7s78kxzisriFOhA6NcJoQ6dJhBVmgdivPsJbKd6ng7APEWojZ/Qdigbz+1/Qf1+WyqUIGX9REDcQuArB559s5+oOjDHBVdlyjBuun/RyeAXbUNXVMvv9O0ftyfMyB5cLO/Lp9KNKGVvGvqbO2vftmn7Q/i7kk1z9DGHNfQqzGgxB5NvnrNLQFnFQoeUZ6EqNzJNs
 oWqjpKiV
 xgGvvgp7ATSPWk2MNrKlHhSbymAtFI7ezaDFXUoXD+7lR82L6cXdlq2UQoKVrQ2PKm8SHjKtPWryyWIFtRua/ECvt88vKziKIyH8LhKRT3wWFXzrlmIOfSmFPLbt+re3ENI0VED9qWYjMtQPkpJosiDPlh8+Y6bML8xhefQ7dm6O3OzOxFdzrrK3XPaPZn7+A5m0g1KgqrQZz8smq0m9gHHB/8/1E9XqxdDyu7q/u3lphkcjbSOHj28IyDbtAuyDyP+37dH2EdIfmPkzKnQ7ogf+m+9Si35jgfFEN6Pf0+O9ywH02lqvBR3ff+44Hc4EQ5Aa/Z7siW8Gd+bpoAugtL0bb+pXn4D8T+pro9v+nhe++ekXrnQdIpZXCot41+h533smdqPVOY8jQdHbEDcOBLCMhkteGQ2JVLun0YfQ24DQP52RU9tIqD3whdrlR+Za+o2s8XbRBCe156+VbRnPUTUnrQO0S/q21oOkkdALQU+Vg34ATHePpK252/0zVL/4Y33b9jDEdilJlRmtUDCkUBsn2wpZJ6rwZNDNjHC40prC4PG0ycUTdgKmFZP3vhoJUOsBcwCuAmhCcEXlfkH8rjsOBT6BOeyHdHftXvUki6yLlAYmhCycOd/HIy8aTQTLUeuwoczxlrtnd5wNCf6q6p3GN6gALmNOG7AqXxdNS0I63XePEKX20LYB6pjyIvBhHQ7fRhBBW+uMNKk2gazrGvP2UOf3FTH4guDT7fAmiANgd1UTTaPA1Vwnqi2eCzuoSu3szEqA5zv5X4BFhNCk2bthXAcH1UvQoa9aAjdGbPRWXehdnpAksjBVtqxL8J0cH902wfpAMOBtytW0m5FbH5DdLtj2Cz5YO8BrIgkNH8uHruijkkhZfrQRenItKWYllhX/Vdbu3bg6D43khPoZ27aQfExRwcCtINWUdK/waDwBhT8bVKCp+ACneXIJ7RJkg+Yaj16b/zgSEZnZzrvT5qskj4fou
 15qjcjdk
 5m0y6Owx4EkG4QT86Y4VHHgi+LdHyHrF9FPkfC8F6MAjP2lYQ+GHkt1svB6PLuJtIB4ayjI+YB9hxGgZNPZ/bCgvEVZimUwagUHXHFWqmx82FSIn4KEExIsjVOOk/O9ewWzXizE1/DOEDQouQrTARzpdULosW6qHGrZhfZFLG64YdUg/7Lr8LnKwMX1gLBBzbRs2tS8KRpcbvi1JQ2axD+dJw3NQIV5GruXfuBEdExEDczysaaWsGR8Z8liXDd8Vw9K80BvlPPDkOXJGBtYVs59RtbSDpHNqpmiTUaCoJOY16+lFdakj8RIl5QK9AvqEVAieU4suuwFUy28wG51Q6+riBveMLShkhDJpP4FtAx8hjkZIal0xeCRA3u2dDcESja9XuvsLp87DaVx7L0s+npe6AsQ8INEo/wlNK/Blf3EiZro6mVO9IDyWYGLAPsbQF5fvBxgQ9UGTqrAKu2AbYtUI84VUroyAQ5Ya9TcoS1nu7Txp6V/8+6UGvJH5ESFEQ/V9L9PylyNRk5apKTb9kkRVCPVJmgYO6unJsWuOfOyswgvLp1qjhlNrDeoNaLTxNt/SHRBtr3ESK0T7dK9AL/roB8hYbNL3lyla3pWiV0vEtwzu2yc7UT0Z5d116TS65itkWt70AA7cn9buUsyET50M6B3VTvu5ewJ00MqnHvCCkY0VdHtdS+xNmY77ypsPrBrymv2RwSqCqpn8AhTRzri+3LzrGym5fpEdOOJux0vckjw0AH+3gUtXFgXqVMDi7G9nMtWbXoTqz+JeDp0Qb3E2xD7uxi/ViHmG++EJMr35Kv9mpubLElHO0iNmzabV89KyKTCtzt8Jcuk/CC1cxdAEhpr4o5+bk/Gh17VCsSzBD9dczBnKUmRXNVxbmCQ5Kb922ETl1gXZn7TJgTClj6jy532Wb002fJgkiAactzgSuvqVr1ZXszvNX9+sKx0bLPVskTNJITtF81QX9uDp3Y35TciDk
 UeuodFnh
 3rt23Q86DlsDVNAFmDtk3c7sFSW6W0Wj6hpUJMcBPsKxrzUAipXsllM9k+88ffEuszBvevn63u0UzhvuPH1e+h6Qn8IoyWtOZOHP0wNNO9kpX/ypS/H+4wJWaqW63yu7cSbC9SS1r+umubR9eMBphsR4zy+QFNDvZuhRQ5yyrw1cizJkVKxVekkP6X7KDAxu9ru3Bo0qJmWLBP/+QaziuHAFExJNtR2F1SduVbQxmSAI177hvJuRE41GbfHLiojGbVDLxHpzNryuazG01SQuYDRD/cMr51ULhmEQ+z0R4wSwLdJkfMONOX2aR5Bvg1uDXYbk8N2qwixKPH0mDpUp3E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7226677ebde7..801697b74d4f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops = {
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,

-- 
2.55.0


