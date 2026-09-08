Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62149C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C9F6B00A4; Tue,  8 Sep 2026 16:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4B36B00A5; Tue,  8 Sep 2026 16:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E606B00A6; Tue,  8 Sep 2026 16:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F08A76B00A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:06:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90AD61C29BB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:06:47 +0000 (UTC)
X-FDA: 85191678054.27.3D2A859
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id CD9F812000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:06:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAFFF8kU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAFFF8kU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898005;
	b=yUZk8dU85MakVPKPRydklAXnpJcoonu9TS+HKoo0Il3JBMROs+5JspUNJ0fTJ28UIAEnF2
	/EWRRD0GEXnknc1jAU+AT/GRoaH96iPQWJe2rpr527Li5raD0a68TZ9gXEZMRAQKi9A61H
	hgz/JMPBSW9jkJwrSgjv+wTFI+4Hc9s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1zSXCuuemMYSZ+ATEEeV/0Jgsd6l+I3SUQ2G9I+xWQ=;
	b=T0V3OkmipGBzH5h6Z/qmsQD211HBG40OqtaG28U+aHqmNte+IRnWnUxbmSosgkV9k0y9wP
	4rG3zBw5hJIxRG5pfSQ3iS0L7B0b/g/S7JmFROxPCplZKpt8MFpFT8kfE89EILtE5YMf7B
	tOkOe1ujtOXF3x9rivPRQJ1JYc2V0Lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D972601DE;
	Tue,  8 Sep 2026 20:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA7F1F00A3A;
	Tue,  8 Sep 2026 20:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898005;
	bh=Q1zSXCuuemMYSZ+ATEEeV/0Jgsd6l+I3SUQ2G9I+xWQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nAFFF8kULWGDtynQ1ptaTKgtwlADNVTMJQzH9XDZPaYvYCKiMrLjdGKXP9p4DzLES
	 1IxJ2YXF+5EfIeFpLwZ47ZZU+ydsAaQYvfyiviYwez6sZf8Ka/2v8iw30Bsqey0Bzy
	 hUekG1qis3YlBMAA2XEO06XY5v8B2T9kHQVzC+OBPtEp0yIm98MeGB6i2ZyV5GRBFz
	 c07oX/1c5GK2D2RJ4GN/q++PPjmZjvOpzr7IxT2B2PMx/SnyguYWIV3H3ikbyvrJhF
	 WhDPOrlqEwEt6qc3Oew4hW1unMOTBuwcErdgQhLim2QXogQv5C95YoT73t7g6MaCo8
	 U9zjDfC5khPKw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:13 +0100
Subject: [PATCH 09/39] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-9-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6164; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Kga81qu7Oz3OCjE2VFbHFuLAyKOVWZ4qEDtF1PVGOsw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6cuEiV50DhpRlXMmoT/tWx+xWIJD363xO/cd5xO
 65TdbnfO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR64mMDF1i281jpHf15u/h
 v+FZPH+fqPcFzyURLa9TgyafWdXt+Zrhf/mCRbffzl3VNUUn78jH5j2PbzOceMTNuN3lxiXR5tV
 Wv9kA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: CD9F812000D
X-Stat-Signature: o8uzr6hrydokcuibppg7q8hsn4xta7c1
X-Rspamd-Server: rspam01
X-HE-Tag: 1788898005-534767
X-HE-Meta: U2FsdGVkX19GIYp4+F2xwrw31qmw6kDMWdEs8Zng8TCmu30A4GAenIKOwT63GQaZVllQnYpuWWPsbtxXrOfBh+uv4PUdLQJpW974pYQsMA5nzXVbOBXDsbPKg4IiJV7067ryNVbcQdQ4IdAMxHS1kfpJH60jRlShHcahYEe/fnseaQIWTWTfuZ3G/pYQXPNbqhmGzj8ywVV2/llh9VPd8sI80QnINTpuonptAJnGdjDH3lWxvCEPy8w28l0slR/FnfI5N8DAWvb8URH5S/gQP+GJnNliZOAGjZ3Y0u8FRY0yHZcw481rbR/oQ2Wg9s6fx0lZUDjhNaz9iKnK3pi2Fv///B1+fnx3MrQ7lNpHP2dFs++Yefu94of/H2JXk35ddQ6bzJ2RJaAqQrtl7yIaEVdRHfbM8jMoE+KhQpAmbZ5QniOQMjg017ehk8k9eIhXA/uxLOvadO1Sif5jJ5PjLy55ZqcTB+q5hPQVF+b5ZJpxEIJ/3WH+Il9ucmvgV7H2HeMvJ7P4hVKGGjNK+zoiXZg+U1mRQXRmCObJINKGvTUZKy7UXHPht3H7ENrMy/2WcrzXLKKTgKsFnWFf1ZqVDoNQejcJJwr/57c0caPz9LiBfY56/9xJbSYOikDAyZAa5t8h+AXUK3Axvc47PUiGve4lDmlaSyGkZPt5M+9b5ni2CtQuXS3JJWeW9vUqoVDKojmsDgKKZ8alJXnWTvagBOkhxALk6vc4GvC5a+64iWevctnorIowdHtdFAcRsEJTWv4An823wZUAPc1BHHyATu/B2aXzIdELcW3n3Tpf17SNVTdbNUt+gKWF8A46GzLTAtHl3nebXcUGkMxMI04HDRR6VfJfwqfuLffglcLvYyq3m3Z0CIeons50VcUxv5CgLXxNB5GgnLwys71J6G9pr/tIx3BE8EXVtW7W3mNlVrkHSS7/TOalkMp59BANsY2QleH9oni3ccYc0kuZ6wu
 zl8HXWJQ
 76ez6m14O5ep5C97Ua79+7uPteCl5bN1Z4jzSR4hNvyVMTEYorJl1Vm9lLuRst17dbHQW8vDI6mZUnuTTb/1lO2IQcUD6V4HtMQiauz0Fpld60GakjCYPBECyd1/L6WUIp6uNEcRvzjQTwPg1FnmO7UKOHHtqpCQV9jl9nuYrIW0hgGEp09wpesr3WFooKkm9SoZgCyWYWsCH2pE10tY1MEUp8qjnOW9GBCjwY3gNgbPQznz9CILDNzXJSdZ2HycBdMo2viabnQb6bH1K4gm7R3Ja9mtn+bgwaOefYAtP7BN4zHevTHQtxVljTctT+bXDmxWzgljWmSXypsDic0LPd1fHphjZcXVtxnVJbC0k2uz3HltWrzlCZHWep98Ow9mCzTsQqPPyOV90S9v/xVuV0ewhIKEcPhNryLELY9Fgejdqp03BcoIa7oh5GgWdx01wZOBOu7RG9S/og2uPKQeQb7O/OzDF4GGTuy0RTE49NHlYbJsQV73wqZ1iS2eACeJMv1XdfvL4KkAcmyf3LV+BXWGL0nRw45kDIPBdlW1szUXY+EM2WG2KE9KR1fW0/MQliOqx7P9VQNAP0zxtVJYNg0mcB8Mt2g6cL9fDr7rpG24cyqqOCo4emNgM1+r1F1Dd8sQLlUyEM69LgxXrcTHLhuYBcKPOh4HClqtsrHbmIyixZ1p7bdmp1X9ivB2quHvMVhrMM2ftUOaMY71DnmnLxA1QmdRw67GIekrhVL//2SQt0Q7+T//713xMYdfKDg/ctPPxr5XYrxBfFphINiV0yFnIIOxfNQC1KmSKvvN6n+dngI3JN9Nt3TuMpcvWswOplwP+LTA0h2csEVeuL0gyzCQpIY9NTJj+oZkNCScRIfgNrEsKpWVIK46iy4uLl2rRsa0Me1/Mli+LKyHF31lYBX7AMo83MYbdU5UwGfbvsb543JNhjssrdmy/j67AWEJ/yMVj5ni3cMoz8CWnSzC9qO1/bG3e
 aP5GwXa3
 VrxCkFMWro3i5wJ3yFaP8Fsn2NaDYo4kecCLgB5Toyg5u95EdC8y3wrZQYHgsVQI1kJYbfJcKbG5GWGfAKJ6G2fD9HYJwoTkh4+DlSxUiCxennzNEkK5J5QsCEvjk2vl5ppikARgQ69G4hmaOc0J7cKAyh+nCcM9in+JCv+27WKjgrmvQTPn/ToXhVMHYiZ8/q5YYzF6SlrG9h62UBpf6d9Gvv+IirF+QYfLZJHnzjifqP1FCzOh2JkFzL5BgjIgq9qXfG7bFUR2F4f/ErF0cy0ZzBIhTq5pIu/jTOqoIcaU7zQFBTgIyaNByKnieREXk0HgC+Xn7mbAudmPmSnIkqhSGhBWBIyXHFp0RkxW1c+qWNwMm3VU8ujq7KTXCZzFkBTj2dfDbbtv9ksarNwmGGEPoPEyQ5ZhtfPwUCiZS/c0pNZvXkQS16oyMvUHzaOQ31/VzwgLehvco5G63W90SHJ7RimNlKHh7hxbPPsBJmGsn3LV72OicdxjqDAUJk8Yk3Xu6Ix6ov8g5maGZPfRtS6lz6IArLfM+ksFZE7IZuOT5mJsTIKRdzhVbxTa+VH/dZuJFIarQ1Mg02lOLy3viKkp+cUKoiX9W6C3D0YTSuMaBLhybmbtE6OJ3w8LZmfiM0aLxfNNNq4V5zHmbj9F6zl/d+foUI8Zc8APZ6oyDWhj8V2KL/F35oJ8w99fOyaXQcz6/O7Z2TiGmzGhV6/EvwwL4Lncssp0p+RVzVtJXwA8jHJAagEc2iMuN2QWdPjQUzzToAEd/r1sdeLjNjsmEJCXNPdSKJUFYwGrbPdC1Aj0EkJCkzYkNU2oNEjeJE7Cth0N/8VuV+Ol6VuoqcTJjSGWe9r34mhwgyOjtIHeEOGDj1JkmpRAoIvR4z7zjEhfTyElacEgJV1SvqaZyKIOCSNMFJdUZsDMocH/eCQrDoS+NqnKFy1jzJigPC4XRZVDcjRcg2mYWwmNgvBIv6kHBxRK4+qnp
 2tGZELOJ
 /0UBwfBQbO7JqB872ydSR3zodlqXQezSHC6IW0uAUxF7g17Nkkf8cNLP8WHHN9isOTbhSk087UcIkEISSHHBS+qBnFjompA2bsuLL8Ep1ehoXZo5enBPlfcWdhCp+9pOTtzf2Rl5DGu+tb39+BxqY3lQndZ/kZ9yGYxsidSn7tuHSNFlcQhftYu4xlTS64bUqZUxzIeRiz+z0/K08MvGJZzXg7wpp4Bn05imQeEuqnDjK8qtHoh02c43GvBm2xky0RMf22YIvZkrUIpSHZDTzy1Hw3d9NKQNLjF9UnL5kFxIkycYCEJTRwntFWolUjPYTpwyzNghu6wpx77BLyFEgQVCqNqAOniRr1fWVWSHdaMPdQV8SHTiXoHeutujrob6boX4CYLNGAtOJsbkZvHMj5+JCkIpwt+eF3Ss+DPwCxRBkKWNGUp12x9vrJ240dSHf39rtFWmbF/HWxZ6l5AlFsqifmXGfHZAddGNKZDEyeN2jFXN8q/XORuihRSM39JFOvVwMmB5+g6kDcW777yWxsJapun1IB7UTchk3ZBmVP1xMGuje+2WkVHex6p2Y5hcL9r4PLreiE+tfNBUsOCcjFrRqnlbau39/Ht2ZhWi+bIdW1rBrQ/FwveTNim+S5agum6G2nLU//2gdk7FPMx+L1OeMQiBHY9svtlyluJz3+vbH8mYoSVBW4iaEoHE2/70OJmFwhTcqhsuej8+4EO9cl9VSxRyOp0CSYGs5Io4J8s+B5dPMiiEgQVR1edSe0nDCIVQNZkw4dE3ONu/YtOrnWZrHhXcYqzpqI54HO0tq9BTkcjqkZCM4b6la0KlhQOi5VNFoWBRnMXo+J9tHotEnNlB1NwZzEO3J5NBg9K/cT2qJvp4ZUJsckrjZoQ3LKknvd8LlFJsA/7dk+68DThnuDjHe4dS8YrIqyIUc88qV8gRRr+ENqmDYi5IutIh2BPh6VvyJB7KZwigwS03TtU4vTRZDI5L3
 H/59izEu
 eP1pYWnWG0OBs66P26BhC1Lb5qwkLLziviV9UlABdfyJ0/LaCZyRBB8rm+SiMswRDiTkeK1jaSRWC0hnPH0Df8URPBsLqA5l/CFG5B91y6CDhxxVlR+jwAFBXWrVaL8vuBk0DPSH/V76dxZ0+UHcFwPIvuiMNhLNujY3aOIZF8s102kfbGM2Hv8bHvGFwjM8PaydKzvCIiQkoOGqGlWNbJqH2KA/nG/9fD9lo/PDdkawh08vADZZis78lCz7y6Wt7qsb1IfhTUrmcYEassCtqT0vwYuBEQOMjnkAZ+Ajq0UP2IDInvjKldyVNWPHoiLUtuJX328jB/6jfFzT3D/O4N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
part of this change, additionally take the approach of mapping pages upon
mmap rather than providing a fault handler.

The page span cannot be mutated when an mmap mapping is in place, so this
is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
-EBUSY if it's attempted, gated by the rp->mmap_active reference count).

Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
this, which allows for iteration over pages in mon_bin_discontig_get().

mon_bin_discontig_init() increments the rp->mmap_active reference count to
stabilise page spans. Should an error arise the core unmaps the VMA and
mon_bin_vma_close() drops the reference again.

The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
correct reference count arithmetic upon unmap (with mon_bin_vma_open()
accounting for splitting).

The existing semantics are all retained, including not mapping past the
range of available pages, with a SIGBUS being raised in a userland process
that attempts to access past this point.

Ultimately insert_page() is invoked to insert each page, which increments
the reference count on each mapped page. This mimics what was being done
previously, only we pre-map the entire range rather than doing so on
demand.

The existing fault handler did nothing that required demand paging, and was
presumably implemented this way due for historic reasons.

One behavioural difference: pages are no longer faulted in on demand, so a
page discarded with MADV_DONTNEED is not repopulated and a subsequent
access raises SIGBUS, as with other pre-populated kernel mappings.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/usb/mon/mon_bin.c | 82 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 687f6a8981f3..9d00b21a8153 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 	return mask;
 }
 
+static void __mon_bin_vma_open(struct mon_reader_bin *rp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
+	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
+}
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&rp->b_lock, flags);
-	rp->mmap_active++;
-	spin_unlock_irqrestore(&rp->b_lock, flags);
+	__mon_bin_vma_open(rp);
 }
 
-static void mon_bin_vma_close(struct vm_area_struct *vma)
+static void __mon_bin_vma_close(struct mon_reader_bin *rp)
 {
 	unsigned long flags;
 
-	struct mon_reader_bin *rp = vma->vm_private_data;
 	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
-/*
- * Map ring pages to user space.
- */
-static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
+static void mon_bin_vma_close(struct vm_area_struct *vma)
 {
-	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
+	struct mon_reader_bin *rp = vma->vm_private_data;
+
+	__mon_bin_vma_close(rp);
+}
+
+static const struct vm_operations_struct mon_bin_vm_ops = {
+	.open =     mon_bin_vma_open,
+	.close =    mon_bin_vma_close,
+};
+
+static int mon_bin_discontig_init(void *vm_private_data, void **private)
+{
+	struct mon_reader_bin *rp = vm_private_data;
+
+	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
+	__mon_bin_vma_open(rp);
+	return 0;
+}
+
+static int mon_bin_discontig_get(struct discontig_kernel_page_state *state)
+{
+	struct mon_reader_bin *rp = state->vm_private_data;
 	unsigned long offset, chunk_idx;
-	struct page *pageptr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rp->b_lock, flags);
-	offset = vmf->pgoff << PAGE_SHIFT;
+
+	offset = state->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size) {
 		spin_unlock_irqrestore(&rp->b_lock, flags);
-		return VM_FAULT_SIGBUS;
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 	chunk_idx = offset / CHUNK_SIZE;
-	pageptr = rp->b_vec[chunk_idx].pg;
-	get_page(pageptr);
-	vmf->page = pageptr;
+	discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
+
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 
-static const struct vm_operations_struct mon_bin_vm_ops = {
-	.open =     mon_bin_vma_open,
-	.close =    mon_bin_vma_close,
-	.fault =    mon_bin_vma_fault,
+static const struct discontig_kernel_page_ops mon_discontig_ops = {
+	.init = mon_bin_discontig_init,
+	.get = mon_bin_discontig_get,
 };
 
-static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
 {
-	/* don't do anything here: "fault" will set up page table entries */
-	vma->vm_ops = &mon_bin_vm_ops;
+	const struct file *filp = desc->file;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EPERM;
 
-	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
-	vma->vm_private_data = filp->private_data;
-	mon_bin_vma_open(vma);
+	desc->vm_ops = &mon_bin_vm_ops;
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = filp->private_data;
+
+	mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig_ops);
 	return 0;
 }
 
@@ -1298,7 +1322,7 @@ static const struct file_operations mon_fops_binary = {
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
 	.release =	mon_bin_release,
-	.mmap =		mon_bin_mmap,
+	.mmap_prepare = mon_bin_mmap_prepare,
 };
 
 static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *rp)

-- 
2.55.0


