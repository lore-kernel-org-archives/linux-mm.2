Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C020ACDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81B16B008C; Tue, 23 Jun 2026 06:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59726B0092; Tue, 23 Jun 2026 06:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947546B0093; Tue, 23 Jun 2026 06:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 691B36B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:10:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D96D7A0433
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:10:47 +0000 (UTC)
X-FDA: 84910758534.07.A1BE0BF
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	by imf12.hostedemail.com (Postfix) with ESMTP id EFD6840007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:10:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTgdduQ3;
	spf=pass (imf12.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782209446;
	b=KQpUbv9pXlZLp5cteddk388GpCQdEYmeYbc5PmDYxixPIjyoTr00ibFBignPkIMx5twoWs
	l464OSzG3iLQxP2S8LvC/swD0teg0hsCShLs34gmDf9PqtHlSN3ZiGjMw8nUhuI/N2J2uO
	fXHYGCwn6N0XLJGNtmIOr0+j1ZDhG5o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782209446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9xRyN5mmtNm+QB3YIDVLwBheiPW9GTxijNSPRoIWhA=;
	b=3O0jCOofzdIMssutAb0+wTdgcHMRXt4+SYPhvwjGdZIFUO2Twc19HoEPYOi74r3oADOasV
	Vl4vcOZIjphT+ECnkmhhaisotI2Dpoi3ao58n64mKsePRiQOni0+gpwT9X6ebhR5id05GR
	RgVZfenEJ3HVHgwPFcPVIngHblNibKU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTgdduQ3;
	spf=pass (imf12.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-37cae9b7536so3208305a91.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782209444; x=1782814244; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9xRyN5mmtNm+QB3YIDVLwBheiPW9GTxijNSPRoIWhA=;
        b=eTgdduQ3FiVfxnmjNEdEdLBoWXS+adGv7EH6zR82iY+PmcwjJvylA9++s9Gz6nGk4N
         2+G+YaqZy5XxZ8WZD9/1myoEOdO7z6uHExjUDObTd4mX+VLutDVipK1JzdyEeMiQ3ClI
         yenbl+XrYJIXCbooz6gD2ljYFAfTBVJL0Vgzx60aOjeWty50YMEw9wfbo9s80pPmGxWm
         Ri6Ul22NV557GdrK5fAU+vGywqRtLKouIGAtXGx2DYWJqz7LHXDclBpKH93TWHteDUb6
         XjJ2odDWyKA5N0xdYYAYA8663ibX+GnSV7sAIRoFhJJ7j95Vas1zdQs7h6RvX8WA551g
         OeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782209444; x=1782814244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q9xRyN5mmtNm+QB3YIDVLwBheiPW9GTxijNSPRoIWhA=;
        b=hvjU6v298vu70HgHG5WFYtK8S8F7KzU2odMHWTc2ZAsm5nhCYlJuk7RiuXO0fOSTMY
         IjpbOnntIAOvRcLuOA70LHG1UAKnCq+yCwo5FSpkJPrVkn28lX8gT/vQcnKbaOV+tyN/
         jha5DDjxCAt3INjE8ha61UdEFcC/hjnmdj7Mo3h0EdOB7+T6F3CLuOUS1n+6uygk3IYS
         mcWwhISGw0o9STKwjJQg3PGK6rt8cvpq8TyhQUXIdviclrPQR9UCdW3E7x4ob/sjpEZ2
         Js+Gr8Cq2Hnj5M29Dl8035XOGplya8Kt04OFTPCTlJMtXexeuQUwe0yVV9QqKHVDbFVN
         LyqQ==
X-Forwarded-Encrypted: i=1; AHgh+RpIduAUfFe9XsbEJyJzBWhcmXW49D8OuMyNgYs3qQ1G/IplhLzgaEorD4jhnCu+ZdL6+v4Fzp35UA==@kvack.org
X-Gm-Message-State: AOJu0YwMx/9nrqJGoov3zeL2KmDBXsTlt7iN5PdhKTwtWC3H6SW6Qm1U
	Edfasl1NTTRuUDKy2NM9d0fT/Tot1xbTINIPfgHPkuhPMC7pOvb8/wM5
X-Gm-Gg: AfdE7cnraHVh6hHxZsoDItBxXypIQ0JzwvVD58He6qRp3Uuq/UK4S7dQfM6s4w13Uz7
	rgg8M9eKgLQ6bBrTdz+181mMFp9V4WSYY5O9UcNHN+NGlKmRlHFYhwNdwl00SwiLriZFYMvLTz0
	gSip8ouXoLWzLax4F71Ut7YxR3aEsSps5OGA7PvgiYdLrIsRmzV1SZZveNRGux3a7R3YOwawp2O
	kDmWUAgu24c/1Sx7oxR3W2SXuILIuKQk794b/zq399tVQ+M2riJzA4mvSwV+0Rk8E2TBzUkSesf
	VEEfac+meZeGr6vivOSquPbHiyWhSYATt1GRYeGZS12TUPGlGZzTbGaAEuZ5RknXScmE5vOuVrK
	m7WdmwK4vllmZae+B/WQrawlGj8qWPA+SpZ9yweAlIpphluKqTmKORog/HiqoyIOJj1Ot4aA94J
	mJj1B358szQTVzcXxe4FSkdIQLgQp+sRrYxwUuhG6h
X-Received: by 2002:a17:902:ec8f:b0:2c0:e5ee:f56c with SMTP id d9443c01a7336-2c7c99def24mr17988445ad.20.1782209444473;
        Tue, 23 Jun 2026 03:10:44 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:ede9:3e72:37cf:55a2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436f7e0asm118059125ad.30.2026.06.23.03.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 03:10:44 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	bhe@redhat.com,
	chentao@kylinos.cn,
	chrisl@kernel.org,
	jack@suse.cz,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	liyangouwen1@oppo.com,
	ljs@kernel.org,
	loongarch@lists.linux.dev,
	mhocko@suse.com,
	nphamcs@gmail.com,
	nzzhao@126.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	vbabka@kernel.org,
	wanglian@kylinos.cn,
	willy@infradead.org,
	youngjun.park@lge.com,
	zhanghongru06@gmail.com
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page fault performance
Date: Tue, 23 Jun 2026 18:10:09 +0800
Message-ID: <20260623101009.522775-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <d04f745d-eb3e-4d2c-8ea2-5fdcf2cf27b8@kernel.org>
References: <d04f745d-eb3e-4d2c-8ea2-5fdcf2cf27b8@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p7pqukwpmmrnixwgr1u64tbeim6g7put
X-Rspamd-Queue-Id: EFD6840007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782209445-723462
X-HE-Meta: U2FsdGVkX18sFHhQvOp807HK/ZwLmeoK+XQQ05jpLz4tigXx8Hw/ue4o997sJ9NmVuqpJBgMRrxX1FKgAsdPYMXGqz81vzpQl4gFjjJ5PjISoRnadehFAnexUkcflsn+Xc2yfSAljaI22h4uk2lo1qoZnJV97mLFSEkQl7NLhDgdL+pJNM8KoRU40q/qMOgGrxvNY+Ewr7ouKgbqPlmRvvf4ta53zkrqvb4Ry19UBGgEY71GoScGoFXgivYR2rwiEXC7sy2i1N2eNpNbZ4WC1NnLZvcWwfV1hW3CUYZyt2lQ3PlGj8iqtNJbfqrPNE6qjY1bjws5kcBuGytW+tKzX4eiv64cbrOE1Z9jh+esNvPLNq5+bDeE8g7jVpMS5OJ9rVthGYbRPryKD5+tWmvhvMmZCk04ogMTZ1BLYtbfL1T9SnErxPGx+swC6cTLSd9VZkzlTxbx69nobxteNjPXUY19NVlmjQf3eXjmWyT+2dz2noAxFIEnBAPcDdwxv11PiRDP/xjy3KpvtcLcTXV+Ng2STKNWwDJkuGVfdOuiMm/MjAAAWSLQjKImX+ggJ5/s0lra2oXUB+/5vCHyX85dTZ5X9T+rJ8Hl02MAWk1TdtmZTrCcUNs5SWuDZh06lDTE77BY/vx2ajvalO7POok6vxANP4ZzfDrBGrIOp29zzFdG5NSOr1+X4hXasmHs+nrP9EO3RcqsQ6g08E3vXfqCXJIKaO6ej+KiaUrzWXeYF5mDbiNUXe5cwGlxFbSSfJm5YRPJwciI5E50gQzH5jRh9W1lsz+RA5QaYxi8ELeV2KqHcDqp7Yz45MGMsQYZwNduia5lF5nu9w2v1lMHKvYH8Ml4TqXv7Ob82DvkxGWEQ3QEhdb13JgfkBG848aFvrx4qNrtr6LKmEygGDBc5TbknWNGufQeW6VAFhvCJ+SVM6lJwUkiTekLcj4z0StQl9+UKr+JImhO8UoeBpZLWMf
 1KxKv22E
 MwZA003hgsd1eFHkv/fJiCaFCyvaZ46Q4CCECBWvC65a/cfNW9YLs0BiazIZfDRApmPs7iV0X6+h18iZEwy9BcNt5v1P8oaLUXhkXeipmBeo3DK9hsxclMqGDgaysE/BULhH2XqXGqmh5vX0n9iGZr4jfMmK83uszm9FECwUscoE46SRLQnxWKCbEHgWBFO85SbXJTeAzPU+aOMyC3DZTzLQ76QS3oeFoYYI2jIyOHA8/2ZFfNNyJyoQ3CStioGY/aJc3D9NlT73wK71NC6t8vr0TeqptS36BKLMU/wwQKLq51JBdGtS0bq9P7AaGhLJQuJTCCLYQ2k6iH0cRu0K84o8ZGzgJE8EinCMIyuJSDuLVIAV0Cm8NfB9RHqZEO/fYghkoWxlmmohFz5a5NCBLLiWHOjhZ/omTUe5De6AspnCx6G9HPdbqnFPk3CslU60VXWtPpgRj7ONrsPPZZ58wnDW5Oe7WhcCyJIdKy9NDPUq8e7YBErsZq8nNXc5rfqMWw1ppqBij+8HvjJmv24Wu3CuSEVJHBzR3UUZgEiwfNiwhVKtQut9zvecxJEnajy4EnMDa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 10:02, David Hildenbrand wrote:=0D
> I know that especially browser usually use fork servers: a tiny=0D
> (single-threaded) process just to create new child processes. Any informa=
tion=0D
> regarding the apps above that use fork() on small vs. large processes?=0D
=0D
I wrote a second BPF tool (fork_info) that captures nr_threads and=0D
map_count (VMA count) from the calling process at the exact moment=0D
fork() is triggered. Results from 3 representative apps:=0D
=0D
  App (category)          Fork caller        Threads   VMAs=0D
  -----------------------------------------------------------=0D
  Taobao (shopping)       DaemonThread-6        526    8,987=0D
  Amap (navigation)       DaemonThread-6        289    7,120=0D
  UC Browser (browser)    OneNativeThread       350    8,144=0D
=0D
These are all heavyweight multi-threaded processes (hundreds of threads,=0D
7,000-9,000 VMAs), not fork servers.=0D
=0D
> Above you write "some call fork() from multiple threads". Any further=0D
> information on that?=0D
=0D
Xiaohongshu (com.xingin.xhs, social media) is a clear example. In just=0D
tens of seconds of normal usage, fork() was called 22 times from 4=0D
different threads:=0D
=0D
  PID     COMM            THREADS    VMAS=0D
  4206    com.xingin.xhs       85    4,140=0D
  4216    Thread-2208          85    4,157=0D
  4208    Thread-2208          90    4,211=0D
  5200    Thread-3200         337    6,519=0D
  5200    Thread-3200         343    6,563=0D
  5200    Thread-3200         361    6,769=0D
  5200    Thread-3200         453    7,793=0D
  5200    Thread-3200         450    7,779=0D
  5202    Thread-2219         459    7,846=0D
  5202    Thread-2219         462    7,875=0D
  5202    Thread-2219         465    7,899=0D
  4219    Thread-2219         465    7,903=0D
  4219    Thread-2219         468    7,922=0D
  5202    Thread-2219         467    7,917=0D
  4219    Thread-2219         467    7,921=0D
  4219    Thread-2219         468    7,929=0D
  5202    Thread-2219         464    7,909=0D
  5202    Thread-2219         460    7,889=0D
  5202    Thread-2219         459    7,884=0D
  4219    Thread-2219         433    7,771=0D
  4219    Thread-2219         433    7,771=0D
  4219    Thread-2219         434    7,778=0D
=0D
The process grew from 85 threads / 4,140 VMAs at first fork to=0D
434 threads / 7,778 VMAs at last fork, showing these are long-lived=0D
heavyweight processes that fork repeatedly throughout their lifecycle.=0D
=0D
Tracing tool:=0D
  https://gist.github.com/zhr250/ba7725d0ea55594bcafd3cd4806eed98=0D
=0D
Hongru=0D

