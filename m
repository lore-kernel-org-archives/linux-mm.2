Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFD6C9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FA46B0095; Wed, 23 Sep 2026 11:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10F56B0096; Wed, 23 Sep 2026 11:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2566B0098; Wed, 23 Sep 2026 11:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5B66B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:22:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51581120166
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:22:14 +0000 (UTC)
X-FDA: 85245392988.05.3722647
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 549F51A0009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:22:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="GBkkd/t/";
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790176932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=215xHvrjA8k8F2o69zQ3x9mbVUyDBcCR5N4QBUkVljc=;
	b=gKvEifMLWU9ZgnbD32E2ak72WrLG/OVa6mQPbiN2YVNY/32ck3oBNGP3LtTYgfE9yJ0uH7
	57TIL0AzpGaThcgzBA14PmTzNif/xombx124RssWU8NegNpSygv5FPUvkARB6XblF6jZBa
	QF7CJY8ynnSsE5XHLx/wpOZgMUELXwA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790176932;
	b=zS4gUXW/pgJUBQBNiMN6KyLRaO3CjoLYEMy6ccsaaIhp87A2iIM8nt7Xni7soqFIdjC1QI
	9szRQxn8G6SU2GZoUfwFAOBy5saDgq5K0T6SapK4gBa3hahTr5h4u1viJo00ODcD2VCf8B
	aEwky7c+d11UHZefvAAMFosGe91E8AQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="GBkkd/t/";
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-532e9ad9a1eso223991cf.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:22:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790176931; cv=none;
        d=google.com; s=arc-20260327;
        b=MmR5C/o+L4ehHKHaYtZFxv8IgSNhmV6YtrNcjdORKbdx6xMX/7+CaUl3A2yvpdpWUy
         oYASHEOW8KafCazXvWIWy545EZlUMxHK9MYmlleEhuc27n0Z0qNaeeUHiBRTIJwkQYGg
         OrB1YcOTkwq/D5rBVsyWfAcO99SFr9rDNxdKYibPDmQhDNDGltkMkUUYrb631zOoBDz7
         1+L4RkMqPkEG+fpdF8oJ4/qk8xp1QA8dxJ+XMwfzM45+ny3b0+yMH3XOn4ZUo+9o9guH
         pUv7tKPunJdSOqqSyuGIG6AvbzvDAXCdLY1rTJ6k7SWMhhLrcvNk54yrhlFkGZVQw4li
         qhqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=215xHvrjA8k8F2o69zQ3x9mbVUyDBcCR5N4QBUkVljc=;
        fh=i1J+J5RMTrrcWX0Clo0bNgu0Kv4iHhNskSZH/8g5G1Y=;
        b=a+gwwtZH9mII5XfwA7iyS/5CCHZjZ6FMmTcB12OSexnyCvLC1KMCTos4I9VeMnLonM
         nI1dNCwfsfGo3STt5/WQRQcjSgT78DtbicZDoS7NMhv/HJYbH3/8/gzijjoxUN4Rkhsz
         Da4PVDR0dif3wD+kkr5Y1/e2/IbnT484eXmnvHCEFgvUB4NJXK48mTdXdd6jTK2rYAvh
         +9to+4EGhtFl2jTrA4XJvOzoJ5Nn2Se8i/0wcTmX0Mqcd4FsCuzUf68yiFcIG1EsxFXe
         fnW4tEUsP7YMGy83XznPoxYDp8Ba45C80l94ThwLRpYWthvOOBAt3GycQRVlNdsF2Lad
         eEkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790176931; x=1790781731; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=215xHvrjA8k8F2o69zQ3x9mbVUyDBcCR5N4QBUkVljc=;
        b=GBkkd/t/FO0vzeTktGU+pkWnSJgL6Y/U/GRneBwTTLH69wkHm+llGmfUlJpHI5OAf9
         UMJ6GEV/sn2qr4RrwIOBLuA2bmpPjIhQy7QRylQ+U3ph8myWYqGY/w2J8jBdZfhgiVlY
         cs8t8/JYFj/eL9oZKsT4NJHPdMLW5HXpCGH81Q8QTsRiJHaiNnki/9UPNZGgBjVoxDFw
         Pdlz1ihrarkyKKWV3SqDoQYzCuullnHHPXn0IBdNjg8RPJxgqgAfz8GjhO5QCKkE64mK
         QcCfHC56OuG+OOwtNfTXkpBVFdt9lSyiGfQKSjPdBO/88IopZCkpM9H7IZNA4ifirumA
         iHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790176931; x=1790781731;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=215xHvrjA8k8F2o69zQ3x9mbVUyDBcCR5N4QBUkVljc=;
        b=wcjRsma6aL136+d/3aWP+iAL0OiIveGiqrJmJPT3ZVeLt6Ebu5jFK59aVCq6PmPZwW
         okFMdwNlQM3/NiXM7TtzkiiP/NAhBrE/yLHh4vg2sOmdkaw4bCmI4yIP+MQGVJ2SjDom
         O4b5TiAFQFWvKIqhtvgJnGjx6Fdu2d9Hn2DnitrxvFQlGmbQpmovYEStLHZskkhF+8qd
         1wOYqp8dU4DOKAHoqcv/o6ssh+NrxscqwN78seaeM89P0pWa6DfqWiYLNSwfAbC/Zw8f
         r3bKC5jNxkF4ZRz3EJ2aWwLd2esI67COyZmUhguVeBh1yfPmhT8ri9imUNA5YSW52Dvz
         B+wQ==
X-Forwarded-Encrypted: i=1; AKwUvBwa3YtdTVfKIVtvi3E1qpYh6r02hbQV7ig70afQhzHw5zIJnm3doV7ePe25tFq+FsTnjlsRD07/WA==@kvack.org
X-Gm-Message-State: AFuF++l+S6LtKILP9UBGNN77JOCfFpSpKwkPminSiGo9qqYIBoJOl0VS
	3DtcYbjOxSvY+XJtWR/OPXJQGGBeiY4vAd4IhUgfsbIJQzZ+ZnXQFf0yykTHnSdiG+VZ0PZlkov
	OzgwQfGcd18Ae6wrWNCrdWatFfKrBzV3byMWl3WZH
X-Gm-Gg: AYBFou0/6hwP4Hvttwwuf//1j+YLpvY8sGhUz86wFj/CSeChnDCA7/9hAGnSzUMYoTH
	7yEtIiBkNrxxk0sxTn6suOsvTHmNNlO9s5Dq2gyFHNaYRWBqpgfaNj42DXvGfAKcNZXmoU3qxEe
	1hXCrRrjq9fC3uuLopbwy+xy81XSsAAU2Xm4V/1W6B9lPUUeDDP4TmNkS5KGng6nG1qnE0wCCwd
	NDDxR9TJn836UT7HUX1cu7q14MpKIAz9PaENTpFcvGX5BawUlfKu/fxMGzIU7mKSbO4/CWcmW5P
	Bu1QTdtf3efIB4IZa5zyv7Pac5Aa2LTi8R09b47N/Bwutj2X2cxmpG0ff9dKKiNWzvzOelq4zbD
	Dhe1zDblE3A==
X-Received: by 2002:ac8:5f4b:0:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-532f8b3706amr797061cf.0.1790176930008; Wed, 23 Sep 2026
 08:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 08:21:58 -0700
X-Gm-Features: AclHuK_Jr66nWhopiYzgP8yybrhj32Etg8U9Ma2NnEVU0JzktEFxq__eunHeX-k
Message-ID: <CAJuCfpFe+pLusPy-xWYHp2rTP1becBb2nhX16xXd+hKD5Q+Z3g@mail.gmail.com>
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 549F51A0009
X-Stat-Signature: a898u3cw8onjbw4gcuniiq9eojfo6ko1
X-Rspam-User: 
X-HE-Tag: 1790176932-595873
X-HE-Meta: U2FsdGVkX18v7XkgcykjpodYqU/v3IAMPLXG/f5WabP8CTHpPjgpmsjeX/1O8k9pMkVunfAMwCFFnNhWWeDEMGOQdNfpBuKERCh7qh53md8Cv06tXxzRZytZiDhEUMn9uyUZd84XPVY6tPHtEhe0jL/9kU5wPT5XX5RBhlRJ6RUL7ybzo6lQRZvdZKnj7RroE7Og93/ZXg4mWyDMxb54M1cebPPe0guA1PGEQOichksAtuveqCUILHH9bwCoZAyMu8kUbaqmKODnZs5KTcqJ0x/qISm6SmAg6ZzuFIdYBiSXeNtzlB+J4pZy3b0Hxlf6X3xTvo1Szqwrg2v9CO2anwpDNPmvlbJUjZIsrHA/lPPuVyguSnUtJOGlrbjaWTpd7AKbYWNhv9eNtihyqDkfz/0qRT/hZlQUparPUJylcFiECNpx41hbJkyf9WOkcNI1NgErkGnHBHA0z4I2SCtRVTiGdXEDKZEOI25tlF9/3gsqYEWWroHsNRWs4CUFVD8KGg4JWla7MXyzy2jn2C3wfq8KChHGJ/0JtPaODQgj4flKPDQc3swClGxi63w/FbBjgOA2LOKM+oTQCILmxPiiGhGnMMSet2Df6lJmATT9dyII/FlXbxQgsuyjkde40GYj9fsAHjSBAqtgLaTOYsN5SR6+VQD0HCeeGl6ONcqVy7jE0qqmS2L98mVjuM2rG6R0RfNYfclWfk7L1Is2DTnNS95HK5ipSzCT/mHNxnQsvz1jC+60i4vMVqDW+lKvK9/wInFO2ksOwFtFIgyUIrDlCW5MV4tpbwCV5uUwXwvHc6EbQFN4St+M1wV6yY0Hdsk+LJDlHCpWsY/jblN+9m4yL76DzcnhrZ7Hvh/tvUZG7Y/Hcz1tIpWFsFUuXzWpfwGxzz4IZVgrGGzS9WRsyOpjsY4vJbQ8TnBlANidoYncvNjlDIHb+KIjLWzqzPXIheqBOtP2ntICb2sPIBeCL2i
 JFLXUOdy
 2BT0tNts2VMX3AdkCIoUS38ls5iNrJeGnZi8x6Rb5WergUhZ0jhZfPHDmFk06MsTN3TbGW5T06uSmgd1/WKJHW+5UIOqHC5TSATizjWeEHjeom1IDXLI4731k4CQSbezVqh69ZwZRf6C5axvwCzZjECzNYK5Q2FcTZA/UdCySo9DFncRj4mij3dkGDKqrz2VfgigRFHLViIAOKPgGtalhTb90sVasS9HUtaTb/xpLwE6GRcP9vEG2dgweUYr6g8yc/Ttm3SEexv3UHUnh8Pig+1YZFBZmRswCk3SrzCjgI6nVgRlMP0cggkvzMF882ONvhBBiHhn182zXXB/zTNhAj1yyNfpny5g92LdobS7gmexBeweYx/c1BnqQU0p7EoXCISwAzP/jvJhEIqpKEqrCvBZnVkHmbily57iN4M9/X1Od9XZMbvVQl6hbrM40wDiYfvH8zfpor5QPsd/1zBkreXFImUyUMLw238gXyXbAbcTzn0ZKXqRbYXwcOS7pOtK3zTCk7G9dadlt3L39/8cuuk+hL3zxa4DQDxGc6gPUF2QqtaUM9zGfpAngTALReOJ/nyfQadEi0rtYIsJi3BQtDC8+eYAlp30j2g961kc0f8gpBI6Ac7GYtdjcvhBHSezkDVCTiJMk2ePXUNppRX6ZnXs/wvLefSduy7Wo9iZ+FcqzHu49PlweJwBiikMge1gQTDw1DKJKOZVIB1Oy9FTNR+fgq9hc3U3Z3fp9zcBGcHynLdFiIr9/hOudZxSHys6piuhd58GVR1aQnPoXlZJi6kyFwo0bOyYf7phJDlT1K/Q3oVxAWTHVQzE5y0afYHG1yYkwufrjQ8Wp3+7VtsToRr0HRCJ3zReEA5UTCoQrFaI4n33CuPXwpo6OlnCS8vOi6xgGKH2gGMG65hmppb45GGMO9/Ik6w5MTEqpvYO/KkOCfaoV3YPdLYfuDySWAckuTS9QcrcKGZHf+IYBS82dVhrCE/WQ
 rJ61PUrT
 gMtp4Slo60SdxXR938wQR7wvVaL0buxexRRMXeclm9vUWHb1l/ZgUMVF5Kj0FLO55MIypdC2XptfwvmwWufUqMhqZfDAd8HRWYRK0u2lOzsFQ9kon6eQ6ZqLxHpBeSdxhzV+1TjlTmJ9D5XPDiSdPzvKpxSDMH763gly2tGTPrlQuiK1I0RQkDnGcr+qje8oYITzbwkt+RNR8blK27ABJjGfzZtUxPoTzy7ucD4FsIf5BSHYaBrOgnVwCCVclTJiWKtsRFtVeQ0M8YE60Ikv9Kd0wajKHzYTTDf5HmpwOpxBxoHLxru+iTnxW5hmTRYrU+LC6eWGE2bFoXbvt5hgmd/9blT0MYV1vCD+oLrROhO0rCIwHFOL9WSDSyyVr0gxbczhacZacD72UDppR0v6gdQ5+MjY879kxpy6gr8pq0dDNTNxEhSOKwr6q2qEQvj4qJxQPuTNNk1W2g1yc8E1hh5B6aQbsWQhs/UN373OS1ukxRCOScl3ktiH6/wXaJcyqqTsjeTJFqQL9zrvOQs/iPb0JQMnvFJP/semJ6L5moBuFsmJoGTwRbZALS9KF4n9wjGfe0hiJwmjHiainS/rF8YQ25t2CaKr+XiJrALBiot9g+UVt8GAXB64OZzQ3gTPIXbrlgFNxyck2jmK3ibDi7uaEXYNZ2eb4oZaEA9k6at8RWCDPdoRhIjUURKwWnxY9uiY6yU0igqfjaInuqgxUCU+r6hWXS8+nMBg1ZKKlf/05xppVldIQFBErqeD5qT4uekdlQ1F2UKOE9CWOYEMUgyYm49ERdADck/3OmGuv+xMOiqln7/yWn0znJPPOiNxXDG29ox0b2EfueIqgdUrk8sBsVBViC4hmAJLrxTKxHgIS/Ctj/ZhmLapeeRxJarLAst4wvxszEHw/m5OqN0lM+n50sMWjcpyBKSwGhjkbK8nrIe8SthPXGaLf3zQYMDSwC2bakR2FMyEq3qvowsZDL/lE8xQN
 PMQxge58
 uHdkq7M5fRFIIEj9+QUMyP2TaR8WPfxlFH5wUIdgzObx9tXbOYAvlZCP+NCZ9Tm6T1OqRSnEIX/nWkatZvtrkn2uQpSeIxXOdiGfywdrMrB8vwaUs6wR0ITj04ezafRjpT+J5L2VNddUr2os4OpO1B9i/sBhX+Sk1R55ntwsv8bGgCgaW7jBdw1DTrKGSz/kc56VzykX3Y8iQzh9WOk8bgemEHTCqBAh8LnYefvBytgge21X4hG6zhlMgvApyOqsxAN1AQvbGrI4xF2uQ8OHnIRRNHDjmrmF/8QaHVl/TYC2cLXXWxQ00b0pabYxfzDiSi/G3usHCnwjtxBx2K0DwWuYE2NYc5lfsypBfC6n2+jh2EGvqcJRmTM2Du7a2kINuMhGFgtpt0Dh280SGtHqFcLevullI0MpVHhioipIqh5S/U/RP1uFZkdbP3V3cvqFer6QFyd8m/X5h1SW5GZg/D8UvhTx/f7fOZCoEuzG/WlV8vGLnagwLTEEd7lFg5aI+S7F+o+doUyrRc96pUGA9FpSUHpCbOtfdyZI1jS1wOhKFNPAQPnHeWnVEKbvmkXDU0QhMQ+7XcdD4TclG2L7uDOgihudwm/+g4AaVUSQtXcwQSr69PgrcJb8CSTPuJ6HgCmRByYOniNZjHgaKvqpVJGbUAzWDJd0zUccVT/dju1KvsJ3CQMadgtjwuMjGb/jDnrNZWwqQ0n55HNCY8lQXI+i2htngsGrUShK19GFX/ofqlOqnT8JScwvYNFUM+t633WzkUmt8dOUAk0O3v6jrrRtOKLpb3AIMlBQK+fK1xvmQI/jKK/M7R519dcySbXVu3sS+8/oqmjg5TkjAwSr5a3yL/mqSqIsM+Psaggc5kQDoXDoQH8bTU0+nJI6IYgMxUPJBbd0p7M5knCx5v7E8KXiFQ96FFehNusiWvV8zCplqunVl+NugjuYZlrUXiOeqA+yIICy+T2naZQ77f33m7pjvm43f
 GxPGMZsL
 lRiVGVOl+HXNSnKQGEGl6Wv3mSVYr4gwbhGZ6C3BqCpjnl502fd4msoiKib5qVtkZrQL2a8AM5SQXxrM7qob7IF4J0K0CzAyveEthCfHBj8V8Te6f+80xGgwgXnbHox6GZAI+U3PyBOwCm2cvSM5+7kRcvESrBuWYKuDU+XCS7g4PGtL5RQANdH7OHj63ewHdbCkq7fha1wml4vI76Lvff7yYzmnbiDr5fI+KnOp62mEZQDVM2DakKy7r6epTl+fi614LbZUr3kUQTM6n2FLLoaHlnhRAbmUo7BmV2FIrsy9N7Bc9rG71NTCp9zS3dh+v9TKf6gJkLlzizNwHZDf5UrxUvKQe+CqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:23=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
>
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
>
> The mmap() operation which ultimately invokes __mmap_region() is guarante=
ed
> to drop the refcount for the original file the mapping was made under, bu=
t
> this is not true for the replaced file.
>
> This has been addressed so far by tracking map->file_doesnt_need_get, whi=
ch
> is rather poorly named and unfortunately fails to correctly track whether
> or not an additional put were needed in a number of cases.
>
> Make life easier by removing this flag, and instead drop the reference fo=
r
> both mmap_prepare and the deprecated mmap callback in a new function
> put_map().
>
> Track whether this needs to be done by aligning mmap_state with
> vm_area_desc and store the original file in the map->file field, keeping
> the updated file in map->vm_file.
>
> In order to have the same behaviour for both types of hooks, only drop th=
e
> reference __mmap_new_file_vma() itself took in its error path, deferring
> the replaced file's reference to put_map().
>
> To make this work correctly, map->vm_file has to be updated before any
> error handling, so update __mmap_new_file_vma() and call_mmap_prepare() t=
o
> set this field first.
>
> Also when mmap_prepare() changes the file and is then merged, the referen=
ce
> count also must be decremented, so update the logic to call put_map() in
> this case too.
>
> Also update __compat_vma_mmap() to manually perform this step for stacked
> file systems using the compatibility layer, and update
> compat_set_vma_from_desc() to replace vma_set_file() with a correct
> refcount/file update.
>
> No in-tree driver is impacted by the incorrect implementation of this
> currently (no driver that does this is mergeable for one), so this does n=
ot
> need to be a fix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h |  1 +
>  mm/util.c     |  5 +++-
>  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------=
------
>  mm/vma.h      |  6 +++--
>  4 files changed, 59 insertions(+), 36 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 0dca33db068f..fe576d468af4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -7,6 +7,7 @@
>  #ifndef __MM_INTERNAL_H
>  #define __MM_INTERNAL_H
>
> +#include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/khugepaged.h>
>  #include <linux/mm.h>
> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d0..016932780925 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
>
>         /* Perform any preparatory tasks for mmap action. */
>         err =3D mmap_action_prepare(desc);
> -       if (err)
> +       if (err) {
> +               if (desc->vm_file !=3D vma->vm_file)
> +                       fput(desc->vm_file);
>                 return err;
> +       }
>         /* Update the VMA from the descriptor. */
>         compat_set_vma_from_desc(vma, desc);
>         /* Complete any specified mmap actions. */
> diff --git a/mm/vma.c b/mm/vma.c
> index 55917d097933..fa784f069da4 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -24,7 +24,8 @@ struct mmap_state {
>                 vm_flags_t vm_flags;
>                 vma_flags_t vma_flags;
>         };
> -       struct file *file;
> +       struct file *file;      /* mmap()-specified file. */
> +       struct file *vm_file;   /* May be updated by mmap_prepare. */

Overall I like the change but I think you could avoid extra churn by
keeping the name of `file` as is and add `struct file *orig_file`
instead as:

+       struct file *orig_file;   /* mmap()-specified original file. */
-       struct file *file;
+       struct file *file;      /* May be updated by mmap_prepare. */

Then many uses of map->file would stay unchanged.

>         pgprot_t page_prot;
>
>         /* User-defined fields, perhaps updated by .mmap_prepare(). */
> @@ -43,8 +44,6 @@ struct mmap_state {
>
>         /* Determine if we can check KSM flags early in mmap() logic. */
>         bool check_ksm_early :1;
> -       /* If .mmap_prepare changed the file, we don't need to pin. */
> -       bool file_doesnt_need_get :1;
>  };
>
>  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vm=
a_flags_, file_) \
> @@ -58,6 +57,7 @@ struct mmap_state {
>                 .pglen =3D PHYS_PFN(len_),                               =
 \
>                 .vma_flags =3D vma_flags_,                               =
 \
>                 .file =3D file_,                                         =
 \
> +               .vm_file =3D file_,                                      =
 \
>                 .page_prot =3D vma_flags_to_page_prot(vma_flags_),       =
 \
>         }
>
> @@ -70,7 +70,7 @@ struct mmap_state {
>                 .vma_flags =3D (map_)->vma_flags,                        =
 \
>                 .pgoff =3D (map_)->pgoff,                                =
 \
>                 .anon_pgoff =3D (map_)->anon_pgoff,                      =
 \
> -               .file =3D (map_)->file,                                  =
 \
> +               .file =3D (map_)->vm_file,                               =
 \
>                 .prev =3D (map_)->prev,                                  =
 \
>                 .middle =3D vma_,                                        =
 \
>                 .next =3D (vma_) ? NULL : (map_)->next,                  =
 \
> @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
>   */
>  static bool accountable_mapping(struct mmap_state *map)
>  {
> -       const struct file *file =3D map->file;
> +       const struct file *file =3D map->vm_file;
>
>         /*
>          * hugetlb has its own accounting separate from the core VM
> @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap=
_struct *vms,
>
>  static void update_ksm_flags(struct mmap_state *map)
>  {
> -       map->vma_flags =3D ksm_vma_flags(map->mm, map->file, map->vma_fla=
gs);
> +       map->vma_flags =3D ksm_vma_flags(map->mm, map->vm_file, map->vma_=
flags);
>  }
>
>  static void set_desc_from_map(struct vm_area_desc *desc,
> @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *=
desc,
>         desc->end =3D map->end;
>
>         desc->pgoff =3D map->pgoff;
> -       desc->vm_file =3D map->file;
> +       desc->vm_file =3D map->vm_file;
>         desc->vma_flags =3D map->vma_flags;
>         desc->page_prot =3D map->page_prot;
>  }
> @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, st=
ruct vm_area_desc *desc,
>         return 0;
>  }
>
> +static bool map_same_file(struct mmap_state *map)
> +{
> +       return map->vm_file =3D=3D map->file;
> +}
>
>  static int __mmap_new_file_vma(struct mmap_state *map,
>                                struct vm_area_struct *vma)
> @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state =
*map,
>         struct vma_iterator *vmi =3D map->vmi;
>         int error;
>
> -       vma->vm_file =3D map->file;
> -       if (!map->file_doesnt_need_get)
> -               get_file(map->file);
> +       vma->vm_file =3D map->vm_file;
> +       if (map_same_file(map))
> +               get_file(map->vm_file);
>
> -       if (!map->file->f_op->mmap)
> +       if (!map->vm_file->f_op->mmap)
>                 return 0;
>
>         error =3D mmap_file(vma->vm_file, vma);
> +       map->vm_file =3D vma->vm_file;
> +
>         if (error) {
>                 UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>                             map->prev, map->next);
> -               fput(vma->vm_file);
> -               vma->vm_file =3D NULL;
> +               if (map_same_file(map))
> +                       fput(map->vm_file);
>
> +               vma->vm_file =3D NULL;
>                 vma_iter_set(vmi, vma->vm_end);
>                 /* Undo any partial mapping done by a device driver. */
>                 unmap_region(&unmap);
> @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>                         !vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT=
) &&
>                         vma_test(vma, VMA_MAYWRITE_BIT));
>
> -       map->file =3D vma->vm_file;
>         map->vma_flags =3D vma->flags;
>
>         return 0;
> @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>
>  static void map_set_anon(struct mmap_state *map)
>  {
> -       map->file =3D NULL;
> +       map->vm_file =3D NULL;
>         map->vm_ops =3D NULL;
>         map->pgoff =3D map->addr >> PAGE_SHIFT;
>  }
> @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state =
*map)
>
>  static bool map_is_anon(const struct mmap_state *map)
>  {
> -       return map_is_private(map) && !map->file;
> +       return map_is_private(map) && !map->vm_file;
>  }
>
>  /*
> @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, s=
truct vm_area_struct **vmap,
>         }
>
>         /* Invoke callbacks. */
> -       if (map->file)
> +       if (map->vm_file)
>                 error =3D __mmap_new_file_vma(map, vma);
>         else if (!is_anon)
>                 error =3D shmem_zero_setup(vma);
> @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *m=
ap,
>         int err;
>
>         /* Invoke the hook. */
> -       err =3D vfs_mmap_prepare(map->file, desc);
> +       err =3D vfs_mmap_prepare(map->vm_file, desc);
>         if (err)
>                 return err;
>
> -       /* It's invalid for mmap_preprare hooks to clear vm_ops. */
> +       /* Update first so file refcount tracked correctly. */
> +       if (desc->vm_file !=3D map->vm_file)
> +               map->vm_file =3D desc->vm_file;
> +
> +       /* It's invalid for mmap_prepare hooks to clear vm_ops. */
>         if (!desc->vm_ops)
>                 return -EINVAL;
>
> @@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *ma=
p,
>
>         /* Update fields permitted to be changed. */
>         map->pgoff =3D desc->pgoff;
> -       if (desc->vm_file !=3D map->file) {
> -               map->file_doesnt_need_get =3D true;
> -               map->file =3D desc->vm_file;
> -       }
>         map->vma_flags =3D desc->vma_flags;
>         map->page_prot =3D desc->page_prot;
>         /* User-defined fields. */
> @@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map=
,
>          * anonymous mappings. Rather than allowing these mappings to be =
odd
>          * outliers, simply make them truly anonymous.
>          */
> -       if (map_is_private(map) && file_is_dev_zero(map->file))
> +       if (map_is_private(map) && file_is_dev_zero(map->vm_file))
>                 map_set_anon(map);
>
>         return 0;
> @@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_a=
rea_struct *vma,
>   */
>  static bool can_set_ksm_flags_early(struct mmap_state *map)
>  {
> -       struct file *file =3D map->file;
> +       struct file *file =3D map->vm_file;
>
>         /* Anonymous mappings have no driver which can change them. */
>         if (!file)
> @@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_st=
ate *map)
>         return false;
>  }
>
> +static void put_map(struct mmap_state *map)

nit: maybe put_map_file() to be more specific?

> +{
> +       /*
> +        * An error occurred or the VMA was merged.

It's a bit weird that the function explains when it is being used.
Having an appropriate comment at the call site seems better to me.

> +        *
> +        * If the file was changed by the driver (which is required to in=
crement
> +        * the replacement file's reference count), drop its reference co=
unt.
> +        *
> +        * On error, the caller always drops the original file regardless=
.
> +        */
> +       if (map->vm_file && !map_same_file(map))
> +               fput(map->vm_file);
> +}
> +
>  static unsigned long __mmap_region(struct file *file, unsigned long addr=
,
>                 unsigned long len, vma_flags_t vma_flags,
>                 unsigned long pgoff, struct list_head *uf)
> @@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>
>         __mmap_complete(&map, vma);
>
> -       if (have_mmap_prepare && allocated_new) {
> +       if (!allocated_new) {
> +               /* Merged, so need to drop refcount. */
> +               put_map(&map);
> +       } else if (have_mmap_prepare) {
>                 error =3D mmap_action_complete(vma, &desc.action,
>                                              /*is_compat=3D*/false);
>                 if (error)
> @@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>         if (map.charged)
>                 vm_unacct_memory(map.charged);
>  abort_munmap:
> -       /*
> -        * This indicates that .mmap_prepare has set a new file, differin=
g from
> -        * desc->vm_file. But since we're aborting the operation, only th=
e
> -        * original file will be cleaned up. Ensure we clean up both.
> -        */
> -       if (map.file_doesnt_need_get)
> -               fput(map.file);
> +       put_map(&map);
>         vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
>         return error;
>  }
> diff --git a/mm/vma.h b/mm/vma.h
> index e97bd2dfa786..f15faa83f3d6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct v=
m_area_struct *vma,
>
>         /* Mutable fields. Populated with initial state. */
>         vma_set_pgoff(vma, desc->pgoff);
> -       if (desc->vm_file !=3D vma->vm_file)
> -               vma_set_file(vma, desc->vm_file);
> +       if (desc->vm_file !=3D vma->vm_file) {
> +               fput(vma->vm_file);
> +               vma->vm_file =3D desc->vm_file;
> +       }
>         vma->flags =3D desc->vma_flags;
>         vma->vm_page_prot =3D desc->page_prot;
>
>
> --
> 2.55.0
>

