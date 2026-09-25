Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 626F4C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF166B0092; Fri, 25 Sep 2026 03:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55ECA6B0093; Fri, 25 Sep 2026 03:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427DB6B0095; Fri, 25 Sep 2026 03:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7726B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:29:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97EBD160579
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:04 +0000 (UTC)
X-FDA: 85251458208.03.0AD3C51
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B38A40006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oc16VdJP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKlx39bvD+La1fyAAMePfYRq9L+0k8EzNqVplWKbJoQ=;
	b=v0u8vlLKFYWvPcHbBLKdrvSAwyViJWMr51JI/SJ6pLmA7mzXtkg6B+sdxXylOYMt4lhD9Z
	Gb+bQpRY1PrdPNqX+JV5kFhPZ7RvD8qrnMAffgOEBYR6ySjRHbcGeeV2Ml+QPYwSyWJP+k
	M4oNo0+XAfShFl1paVitTn3EF8Of7V4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oc16VdJP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790321342;
	b=WJvMOwEgrvQaCgKYntx280m7987SKDspGowDCqaAsUzR1kRYsV51+NOXFpyapvLZcNBx76
	jq2q5pKYN/ZRUE/FgOfGVb0lWJLvz21decKMpDb/7enKnkdfQUlXmTE3mFGemRvVN1/RRd
	xwK+KuJoLvrin5SQzmL2BgjHQzFgPrg=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-532e9ad9a1eso202211cf.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:29:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790321342; cv=none;
        d=google.com; s=arc-20260327;
        b=Ss+p9DHyzydRDmV+AxXe0mrySaT/8/euQIWVzfM6Qr5tG1lU8puYlAsKUQ2sUXieEN
         g69KrYS47MXmpfw1FEblwzWvhQQk4CkHzyz6tiqwQbwOHqLqGmzcu8dJ0cGFFp8aNzRb
         dLEX/4wgsKhU81BC3ht++gT6d/6Lu2ITVoRooLXuUF0xDwJ/+81zMc8d4YMTcmu3HpWU
         BynXPexnvZwphDBNzjnmNFCzOkHc88Oo03r6UGzMI9lv95USWFpN5RDEO0st5bu1bWx/
         uQ3ZUS5GqRFfBEd0/Or/Zraf/UV80jlRbCpFmQCNdCytzWiZKGMRwS01x1WimjUxuNdE
         pj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QKlx39bvD+La1fyAAMePfYRq9L+0k8EzNqVplWKbJoQ=;
        fh=pexICA3hRJNFwhxJJY8d+wOVIYK6iiVbugefqDpOrs4=;
        b=kx00/ZlHLXx8MJ0dhZj7UKl3E89GgHyj8Yxnyv5/fC43S2yya6aNUZa1njXHHsyWxG
         o9FvvNV4keQrHIKvCQy3rP6r7NxU/VE6TF8jL/Ba1ltXATIDGkQgYAQcJvG8nNEoZsv9
         BUibhkjObHzizEIT/hETAho9dGS/1rQQxcjE2HlyyCAMKHkcEXV0fyDRcRzTqZwrR/w9
         SOynT9J4sDu9BaCGrGCz1sT0uBcdIGMXGkndXst505FmWzjDrVr9F5LIS1gwj/avGPqS
         qDbNS+sukCAdlt9I3D/wrMDz92ujTHeb/0W9BnyHR0dO+rxVUNMUS45W4Bn7IbuHjwP6
         6fHQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790321342; x=1790926142; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QKlx39bvD+La1fyAAMePfYRq9L+0k8EzNqVplWKbJoQ=;
        b=oc16VdJPrusrJfNRyouNKRckRxugztrzCZr7kQSRVOqRXVF1DNaXEUbqzdv7ijRFJO
         qYBtUZte+wNxgqJ6pAJYNJSZG/VMQmyNAu4KGQZc77jHtNZnruehJyYtyBruqDRaXd0N
         /h9uyUpFL0HvwfWxIDZpeYSM86yS3dov/bhOZKhIk4ZvmzAUgaa6pGb2AMgy0/p/nOxZ
         k5ybRzRA2n7s0f4mJ1lV9uBZe0k1okRRpchgOw6NuE5p+pg/RbYo01Ez388M3T+Cr2ll
         +w/DEz9vNnildOzcwetEoarDjTu+2IROe1qiVx/JeVbX44R03AkJv9ou9qZXkh5lD/u3
         FYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321342; x=1790926142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QKlx39bvD+La1fyAAMePfYRq9L+0k8EzNqVplWKbJoQ=;
        b=M/++pxIthytmLWuK1tAMbFxz4vRyv8afMOkM426HbTsXX4Dkt6mMdDMxN6EDoXSrO+
         CGoJdJm5zsQvP2rEht+2kg5QCG7sqCBtoApVq7Gk3//bEHQKvhD09uncYBocGC+aHUZm
         ErNxRZqVo0qYaJYOohpgO74GRtswWKkBE3oW89nrYyabaU8NkGz9SSH3pWeQEEudsPDj
         GcBA1Rv9ew4mcEvN2xqqmibE/JoKcXU7Bt0T1CqS4sdhi4VSdjcJEP4Tnz+79IXjI0SH
         nErWVfRAMFgT11hvgFTrJKBVUXAIIES6PUZDmbfDscALuyqjdcXCeouUjPg2rZJJ2GJz
         +GLQ==
X-Forwarded-Encrypted: i=1; AKwUvBweqFgp02wy9wwK37vsuZo2RhJwagiXoOe+/H5H3mcpdJLeYqQOx4d4dzUh9nKyJD60klBcyhSdDQ==@kvack.org
X-Gm-Message-State: AFuF++lb2w+etbhfq/WgKg/ihr1alaQd6n0uUDMw78Hcjcp9ahpsb83L
	TKgMn1NGOmO81236mkJ2/IckD7JUMt7LeiRJlHmIfpFFhWVy0K/srixaLvOjydCOVJ+vMgNjDZj
	hMEqi10jAhRc33Ij+I8PKr8UJIR/zPMhKDva1PbQC
X-Gm-Gg: AYBFou2ps7mVIznftFWVpwqVV7oTERxDh/19Go2e1caJ9BGMQ/bvDyf4CqXn2yzljul
	2GF/ysHj1wy8pW5shGJdrlPOz4XVODvMhu7YGS6LM4bvS1GD49vATTUPs1HY7p5RNTc8LUX90tP
	OG3Qe9ltIrn0Nhuh9vzSl+LeV2Dg8bwkvbNpegop4bde+STZ4Y31MiH1Aru4LDbv+52SkCVALEr
	TzZSoC3FnC8t/tci6Vb0P2k7izyzYhYgkGKLJtZFKrWKLFFttrYd/GBNP4yQ9/RveqcSlfcA6m5
	4AQOx9YVqA8EVinJaqxxIYnamDBIY7+7wfbCNW8YfVN8DQ6DyYrn/Q==
X-Received: by 2002:a05:622a:4c15:b0:531:d8:e437 with SMTP id
 d75a77b69052e-5330e1083a8mr8850471cf.7.1790321341004; Fri, 25 Sep 2026
 00:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 25 Sep 2026 00:28:49 -0700
X-Gm-Features: AclHuK8wpU_boMBtoQ2BxSfl48UrjTg974xy2tCF5bv_vM_I_Kq5OyVf7aIl6LM
Message-ID: <CAJuCfpF2U9rgHmhaDoXX1hxsuuS=s-oWK9Nk19TDQ6CLpjhFVA@mail.gmail.com>
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B38A40006
X-Stat-Signature: utemk6q9dufssm6qi68f8gz35gy76k5d
X-HE-Tag: 1790321342-188243
X-HE-Meta: U2FsdGVkX18X2Biy1mjgs/UczzsytMHIHzeRcTLOTLutD4uQsuXMdFbrG39zj1HlDc61eL7jeoDJzFYVwt+k9GmHPAcC89J97nqpIRe3SRY6D+9Th0BG+A9sBuUYfxG+UsAE24Cul08ZLWDTCbquv7xiSzJclZWPqXpCXuPVAPj+iImD0KqB4BoavORHQEiUXeksMulKlDuX3BOnPdwxvMWGMr8yOmzExmdD4CDVpvmJ/Pl+KdFyO+uWj1TqUQF9BicDFDvIInZyBgaKC7GzXfMYIlbW2yCvTrqYpYeB7YBlmX9gADkTRM68CCFx+bSWGfTYtvHFkTFmUY+Y/W4t2D/+sgiK0dgkHqO6uHGfSdPoIIeOpJpxiXQG9rpnq7SEEZiwzKgSA647+KfND4qJwQWe3opszhPVhWuM2cyuVXoMD5qHXGEgw/Jy2W+9HttnuEkLtk7eiKOsuo72xFRe968sGg+BqEqSoIqH2itvD2cy9borjlyciGuCj6HYvJu0zD139GvdzikM48fhVaylIk4wl/+3EVjfYB1UUIfL97eJsbBdIDPsoYmDK+8SqVAEC7OnujV5xotvUQsWRcHA2+7f8kGakPhSyE6sDdDFsSiHL+SzdLJkzdppV/TKWeUnHVj9hsbgezUAtvXwpXI0KK7/8j6iiVIRjtW11Z5KZ4ufci5Flh6L0yEpSypmNGYo1u37Md6fVCo9Pj8brIga6fpkmKwQzVhgl0vscA/+r/epFRGkws8F/sFSL40inqrXn/tWl75BSFgCPMJ7gqjSby7FY40XofPQQnkX+rNid1NrARjK95UMIINXEULIkpYr1vWyCTx27w5/Aq8T1HqauwVZ6fu/7IGkmXq3IDXFB7bYzd13tz+qMAIv/rzvOA8ieMR2ldAJq7DZsxeoocgyk9Oqd99fCI8kF+t3nwDG4dmENHcf64elk0OjyrgVj5iWAb/QdRKE8BLq0Wxm40y
 D+sg4E3l
 gUBxO+9xJrf9P6S+1TCJ7CZVdKI5zyhJRIDo9OKNCi/jspSA7rZ1/zJU+xBgzgbHc2+7fsx2v3UPGuS24XjvCXZX/xL3YUhtzYOdh6NgcQSWiz/rL3wCumxSWK147AHrIEAKnoDSm5d9bGMfUbnqrAd0C0ruKRzBKCVVlMUAc7UBImYGOrxC3P7rtmSxQQXxOIT701TNY2BsH3a/NAo/dhk2jE3PL5cwvzz0nbao4vLmnZeJ1/FDt3npVd560c1mbZkCKqVfhs4S1x4nwxYEXSxwJI0I2gYe7eY1/EH3HoXHIzd9YsiRRWu/XrrOcgrEAc5Qo8ns/jfO3ydBvgQZlQWeRfuRI5w+HhJp1cnuksb9LbYATP+AhFNpQXXjFbYfuqEaJAeb7lZCNg9KdWwIvQ3vtO3dNdSaz2MmoYGPhOON7Aig5OeVf1E4DmnDA2On846wJeNvo8KIlie5whImMmiHXI9ZyUoocx9SOu309Hn5JApeW6/Sg8PL/AfcXtuaMn1SU4wVliT8D+KBSdZYU1UET4ELyMW6ClcnJQH7ygiCFL/oPyiD3WMNu6G5PmRKH3+B+fWbQmUuUCDyhrjJLXHlkFefgqE69cbiK9VbFlde6r/nUzcKni+i/Vv8V9a3e4+dFr1QN7qGY/WJCvyrHXub5ed1RdK8yrKwTpCv2VQ65te5/KAckkahXjoOj98xcS9kqicTV61jdNzRct4v5DlvVz0WgP8s5F7Bb7V8qOc5KKH3Zr5eaq08k6cyWa+5zzKCWY+VRvXxo0wICPtLnLKpsLNxI0fKljXH3QWs0Jo9gMooLEALJCWG5ktNdiXl1ZwQcNs3zvAmZwNnzNC5t0GfWBHzv7EFwYU/A+0YhhXe8RMjk0IDif4HlMNEeXmHfVlsPmraqSH0VAk0LGa2VK3t41R6WlpM2GE6pI250Xh6NGy/ge97y8+r9KD+em/uEVBP0bvBFrOzyw7FhfLB6NlJquR6I
 sadZ1kjp
 zvXMPSuFWdh23a6pHMEJBP+0WH/Fxula5ol+aGQ8fgGlTdEAkEgHmYx10JIih3eCUkT9sHeizSnwlASvUzze/ZBzuUYwkkubVvGo4cmTVO8tn2/bFuVRx8fZzARocRqS9RWJxkra9xRT7zptsTFNWVvB4GZ656FRSlQSpW51RGy6jUL3G+pHy1DnsqZb21gUzqf95A0goblpoQl2pu3Otq/cxcCROkuZGj08Ka/qqqxcg/dz2MVA4khS5R5sfV1iW920AC0/oVweutb/oQzOJuVoPkUmwnc/jrOpDijIYRYG4/VjfniZ+k/t8u+56Tx9FXSonbAI3Eho0PEFSrse0csDPSS4X8NpYbK4EasPBKEQkxS73aV8jIzfKP7FHDCMjdp7rnGR49tUS6O6jAzRI8e0pc/xnjP8yS1ZHLWHur19upzXo+ETAKGdgirap+nB07xqP2GmqOLOUaG0df7ED8rCwWNRUimXc4F3Ns4xEeAQXj83Gp8469NKUiIIb7EkeHIRVlEgC40MN/C4Ssjq/9PrkZgpOotAlsDw+xykrrqLzsBsyzs5z6iOTl29jRLmjWscBB4F6trE5uNDWLnsT9NumunKiFHUbYlS7VuLqvT0jH6f3VXEYLBKFmdFFcs1YsBwKJCto64SgBteV4S1AbS7/aJqTp34GL2Bsq/WhGUzvnuaapz8Q5FohNrKk//H2zsLFqX/3woZdQJf24nS0gZT7+tGK6Gbs3j8pvOGnrcogdtzTjDJD1h1bzC3KIHr2X0RK5XzhXkJbxB0i2GtdXjyXlTbhC+sg13iA3CI1Ub9mSuokhYdDvnyYJlPaVPwPsCbq0A4FTEREXAFxvnHmSP6uh9QlAU7vu/V6vn3Xk5zeuxMkofi1ibAaPOrVJLutsgaswW+3Fc1kriTIR7msrqOjXjg9CaizryDu53l1YEvEvTj9xVwYJQKK55iU0M6LTBZ26NNol34O/mJ/7vLUYSAv/piT
 ZEyKvZfH
 jKh+COtVxCi6siIOpn7LqQWBbY4KrFO4D0ijVKpDetVThSUKt19/Ff0Xg9K0DzLasE8eDc2ebbAeJVKQYTw7sL8In/NUi5pfEGQRxz8Fqgl4uC3LJxyjeGb/W+T27rJKbnCZmWQjSJOWaz4lyZiFKjC46IEVXDJu/bJhRWjTUVkEwJVEjFfdgVcasQNLOD60NAsN3khxJNkHvdpF5zC74YrViBVS6XmAWk3d9LUjD9XOL/cjSXlhTQAYQJMcvQh/+CPUvH4AJCcbik41fTbN80YzmriVT1NgckkHQPmQxlHFpQpOb0BeMw4fRU9tmvVEwM46O/CIbiQOR6TLhwXaUTG75Hf5eDvD8HPbl5kMIoi8IgTvCI8dFsLwvJwwBV3zNRYB3Ofs2kqPO2LZNx/cwgTLxywENBrPN8kW7GH7T0GbJSDRm+6WON/G7qnXAF/qxOA7v2bA8qDd4WUX+3Yw9u3kdCNLDG81F6odFWdSW2O2XrgaGW4dU9HK4zlKfO0bDEDSlQ6anBbwDvJK/mYCt69DDJx4wBqyq/d9raR/k4N4NG3hYAroiR0e3b9GbLHXF03gUp3uyjihmhr4g+bC0ObCYKfvRMDhF25kXVaWkNRaOqGIQvZfX4/v/6+oKqztdMcphRndVIweP+aaS+NIySKBjyOysXdi8H08DAvgfHXE8aWqiAlspv2wIsN3aCDoAhe89jIP2rCVhfwjQuCIPtVi+JqhtdB4LNHKmUO+P5V1G3LShzuPlt0sCnS7VdTf/Mh1sMKRRDtv0QBuvvOrvBj1QEpAHGBTTMOQ+oxvv9YPNtSawLpG3vzXTOA5+azLZ7kjdOh49CPyRuLe5ZVelDRhbj8qHsLD2Ne6/B5kGlAfLQBspludSjxfszrSgZ0rw2/sf2DgWEqnyohJOVSgeyoJbcPhHdvp+51gla5mMSiK73aDL3Z2zvBml7vHbvDvJZPYzH/UMMZC8tx76efnSFAsbG5VS
 PbUjbbTZ
 AiJbc7gokZmGIRuVzRik73AODu66/OBThuWrw4bnVH6LVoY1R9KZ9FOFf6dnFPLTNQ18WTZgjitQgAcGfq4Zixtln+l26lWryTpWCRApviB9eFTpf12eB7t6Xb765cz0koovswtf2NyHukofIuOFUDsmh3KHWxlK1rdRZYUKnKx5T0QvS0nfP+IXts7w+LJp2RKttmZAAylPB4ktCiSKrAw+cPx3l3BrG1MiUob5TG0FYvwoxP+2J8sk11xTsapZHNAWYVdWhIxYc+3PPyzDy2TDSmJzBMl5nIZRT4kghSWV5xeECcgdCI3dQLMhgveaMmR9ng+GqJq57fmiuxPFqQyliZSQ4vZ49IxyRGWvtMaxEbEXtBd8eT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:25=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
>
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
>
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
>
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index d6ed10cefc8f..62f2ce1ad5a1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start,=
 unsigned long prev_end,
>  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
>                           const struct vm_area_desc *desc)
>  {
> +       /*
> +        * It is not valid to execute mmap actions for VMAs which can be =
merged,
> +        * as any such merge would leave portions of the mapping incorrec=
tly
> +        * unmapped.
> +        */
> +       if (vma_flags_can_merge(&desc->vma_flags) &&
> +           WARN_ON_ONCE(desc->action.type !=3D MMAP_NOTHING))

Any reason you chose this "if (A && WARN_ON_ONCE(B))" pattern instead
of a simpler "if (WARN_ON_ONCE(A && B))"? Unless there are races
between A and B updates, I think these would be equivalent, right?

> +               return -EINVAL;
> +
>         return mmap_validate(prev_desc->start, prev_desc->end,
>                              desc->start, desc->end,
>                              &prev_desc->vma_flags, &desc->vma_flags);
>
> --
> 2.55.0
>

