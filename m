Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F29CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 22:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350886B00B6; Tue, 26 Aug 2025 18:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3289D6B00B9; Tue, 26 Aug 2025 18:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265926B00BB; Tue, 26 Aug 2025 18:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 169EB6B00B6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:00:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AD95B8A64
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:00:34 +0000 (UTC)
X-FDA: 83820278388.08.B261FF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 583CF140020
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:00:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fUtamZV8;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756245632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYgOuAEbsNRNFaEndOqyqENnWJjPztlc9vKjQKlk+gs=;
	b=MOAXqlVB7EaVWdjQORYT9RysGMNmF0hjzB4BfMx8dhiIveULxGKoEJHazPMtGmHogKVQQ3
	eaNYsyAHThfhh2qihdQjxfp81mLxqu0Cn8rCHq0evJ8FdtC32pXtsdhINRlJluLiUxzpTl
	Z+gp5vyzXoXLkUq+77UtdnXm16iXhTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756245632; a=rsa-sha256;
	cv=none;
	b=UZlhrZk224Mn9eH30z504gZlQDg/ge6K7+Fry+U2ynC9k3nwV/u8VZOS4WjpYYgCdanD2a
	UXIFPaX6TE695u6XZV6+4GfsV13IAlfxKcbDA/ap3NP4M+ZJuTPUaBCiSwRam1Y2cktoei
	TaNzqjdT+IUifbzlgrYSCyKs4I6QVxc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fUtamZV8;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD1A945122
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB720C116B1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756245630;
	bh=pWOdIofYcd2BVstz+MOo3lsC+kzLhH9iyv0DoflFa54=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fUtamZV8gWk/4de3o3UGqCPEPue5eEHD0j8H2Ej11wZV2yVn5PyVy6YauGqhE07mq
	 YXsdQcfyNq/ggCU+rxxlZI0wDbh9/yMr517q0qVb45kRFvUS5xHTuIzHaBBB0wu5mQ
	 d34JkK0UuRAmg5kX7FBE59mZp7TyXJkFWsa68KZqsQXxPD0M2Xz6mN+u3sEgZA/tA0
	 ccXaGSFjgw4zW+G4V32Mpsw1zj9+uuyDin/oiV6Z2RKsLa2tcQjLKcpmA7rn3mMSvy
	 37BlY9macyX81A+VxBplILG+F4XXrLJww/5fccuFvTEFubtwUdWRzj+sEqVpePb90C
	 ouhm/qCBG3lBg==
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-459fc675d11so11965e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:00:30 -0700 (PDT)
X-Gm-Message-State: AOJu0YzYnvBtsdm+mv/JfPJmXJvr0FR9x2PYp/Bizz4TgJGwNSE3szOE
	sD6e0ZLl2ZeuZhizdIz2gWr8CpCBzv/I8hZzhoJLafpfvTGmMwMxuZ+WSGyOVexuyXNacM9hXjN
	1lKainhM3hmYua6M/z+vXSbgiXsfPwOcGyxxNuLDS
X-Google-Smtp-Source: AGHT+IFFTxvgOgSqw04QBrhAUuN83/2UNWCNNQoSfb+IBD7KvPA/aZk8w3052+HFEplww/6pof07vUVot5s+RaGWfWs=
X-Received: by 2002:a05:600c:3495:b0:453:65f4:f4c8 with SMTP id
 5b1f17b1804b1-45b6696b9c8mr2691575e9.3.1756245629266; Tue, 26 Aug 2025
 15:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 15:00:18 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNinT1sZG1edUDMXbdCJ8W_enDcnviAuj5=MViNZ1AczQ@mail.gmail.com>
X-Gm-Features: Ac12FXzVFLxJhUeNWdbvaFLtBNcpDNkz8bxPDbSkalAjd85ceadZ4fbjUsUIo5c
Message-ID: <CAF8kJuNinT1sZG1edUDMXbdCJ8W_enDcnviAuj5=MViNZ1AczQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] mm, swap: introduce swap table as swap cache (phase I)
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 583CF140020
X-Stat-Signature: giw771epqx4w8ynjgbx3oeaz59mqjhhf
X-HE-Tag: 1756245632-464260
X-HE-Meta: U2FsdGVkX1/wBJBSp9nN3A+A9vZFua3g/zLVVhRFSGeGZOVBAExoKAphk8QYICfyKy62NEzOde6PKDX1ZwBqe21wycPyKsD/no5IT+9FdbALmz8ebmQnbhY2jyw5UCQprTjQquQs/LQPccsyDUnRBSMXTj1lEeqGZOcgXq8+gRFxlZAISLAUcmw8+HWiv7/ZsyvLXayBu4WzbHDjAVOlXcjKDBxWY2h/O+zLBy6wZ0TmPxLIUntNipKp458/Jj9u197PSzZSXbn64GVZoOL4vM7gte3o69l0pPCC57Z1QbJUZZ9Qj6LgaqZRwAyzVWSbu6JhXYTN7fI65B9JJ5AtsltQte3GAy9RlDEhqoMLYoQPU9rkwN7akEQZBwDlFwpyOvzNXnOZVkohEXiXlBoCvfh6H9fgtPFVzZZmD2Hgym4X07cLJqnvltd619hWRj2auDHsameOMp9IZDobfjYIEubCjQb+XHCCKzG/6t+Qqqh3fdqAG1JNAfHPZoLy+8fBWRcLrB9z0vAWSRLgq3tagI1w/X8r5kRP1k1ES+83G3p4nnkIcA03PBinc//1XpjjtCQpqwejbqDuIJ1DCKkIQtXsuPmoxHyA/Zns5sC0Y7MZ7fuTeAlpXK0q5ZoG4B1fmrA/huIJbZ41fM8EsVkygXhU/9PFsHfLQ5Dqhvz5Os9lVeZKQXNzeFqGiVSjwJc3qRxIOaH9rM45CKuFpcScRqeVY/4J5ixeM8jB7kgcrckOuu5M+bMpcETo7ZqCYnJs27DZAQ9H9FzPMgTLD3eCUx18HLO5mxltjsTKXGyZ+UWNu3JkrZefoUyCZmck1FQr9OaYppU87cN5HAB0yE4KjI0xvc3B7Ufp33KzXs+R971cAVjFkHZOTkysEejPSjHVM/wjqTR2wk7Rw+5TcwGW6amOC2eZEjZm5GmZWWiAdQHKu8hpvNF1Z8oeTU9lmx8ykv6A2gt7VTc6NCix8ck
 +3VmbGA5
 T2awNP8K4kqJgn3YjCl/c3QQOVzxJbbeoDm9AOoRBtI62wIHEHED+4CEyb8hN4gnB5cpXJa5tHvagbTbMnSxeg5PN7t1fNmzDSOUw92i7BvcyBIPeupJpE/GMAYUZ5C7KKgEHu6MbO6nS61tsEUGHTDen84rTmo+FTSzQaxv2vLL11Aklbh3AaRfzEL+kcRjVhRL0UBhAGNr/IiRokJYGXE1pz5jUzoYSX+5Iy5Yl0pJniPuurliZdOwDEfmyMoWO6kEyHHEV6EFQZXXgeKTytbFzKu+vOKxb0HVzklHBtBM5fzK/1+Lnx5Qo8yPApFQ2qUqnbCwRHBdg/y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> This is the first phase of the bigger series implementing basic
> infrastructures for the Swap Table idea proposed at the LSF/MM/BPF
> topic "Integrate swap cache, swap maps with swap allocator" [1].
>
> This phase I contains 9 patches, introduces the swap table infrastructure
> and uses it as the swap cache backend. By doing so, we have up to ~5-20%
> performance gain in throughput, RPS or build time for benchmark and
> workload tests. This is based on Chris Li's idea of using cluster size
> atomic arrays to implement swap cache. It has less contention on the swap
> cache access. The cluster size is much finer-grained than the 64M address
> space split, which is removed in this phase I. It also unifies and cleans
> up the swap code base.

Thanks for making this happen. It has gone a long way from my early
messy experimental patches on replacing xarray in swap caches. Beating
the original swap_map in terms of memory usage is particularly hard. I
once received this feedback from Matthew that whoever wants to replace
the swap cache is asking for a lot of pain and suffering. He is
absolutely right.

I am so glad that we are finally seeing the light of the other end of
the tunnel.  We are close to a state that is able to beat the original
swap layer both in terms of memory usage and CPU performance.

Just to recap. The current swap layer per slot memory usage is 3 + 8
bytes. 3 up front static, 1 from swap map, 2 from swap cgroup. The 8
byte dynamic allocations are from the xarray of swap cache.
At the end of this full series (27+ patches) we can completely get rid
of the 3 up front allocation. Only dynamic allocate 8 byte per slot
entry. That is a straight win in terms of memory allocation, no
compromise was made there.
The reason we can beat the previous CPU usage is that each cluster has
512 entries. Much smaller than the 64M xarray tree. The cluster lock
is a much smaller lock than the xarray tree lock. We can do lockless
atomic lookup on the swap cache that is pretty cool as well.

I will do one more review pass on this series again soon.

Very exciting.

Chris

