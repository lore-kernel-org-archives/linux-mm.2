Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66425606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zhaEFJmC
Received: by kanga.kvack.org (Postfix)
	id 68A4B6B05B4; Mon,  9 Nov 2026 06:00:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661C66B05B7; Mon,  9 Nov 2026 06:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578136B05B8; Mon,  9 Nov 2026 06:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 370C36B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:00:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCC911A0655
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:00:12 +0000 (UTC)
X-FDA: 85415286264.12.4F0D643
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id CE60DA0008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:00:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zhaEFJmC;
	spf=pass (imf25.hostedemail.com: domain of chenhongfeng0212@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=chenhongfeng0212@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794222010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElXE6Czu3kJtnBp4J8hepfVFWJpvs2+YyAeDoXoHd4Q=;
	b=UOXIE/7fUdFaZzida1MtNRL6jeap1VvnRqAQDgDgg2P2u1QeOLGAYYVBJLFbteUZL7l+Ng
	wCgBC0MwIEnZ88yFF4zkbpxQMvMxYuRWBeAK9IM7P09dp/w3qdTGcWQN+8LhvVvL8hZvDt
	Fo+PGP1aorojy6fmdV9c6Bn86qGa7ng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794222010;
	b=DzEl6N9VwVD2fS4e+UKnoJKeAhLWgAgZpULi2VMSg34Rb56kJK/Lo6DNjrkKLU6yIEdxeh
	1Cz+vjEWVu8azHh7EEImxvx/1Jo2XtVuGxkffHSRz42BPEqtz9b5fH+3mMvmFoFFnCZMSY
	YezsAEExQq5KzXpaAxP6RdI6GX+MeTo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zhaEFJmC;
	spf=pass (imf25.hostedemail.com: domain of chenhongfeng0212@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=chenhongfeng0212@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-36f6295304dso831635eec.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 03:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794222009; x=1794826809; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ElXE6Czu3kJtnBp4J8hepfVFWJpvs2+YyAeDoXoHd4Q=;
        b=zhaEFJmCZLQtVMHGjFajN3kpgLk1A2JNdGmhnupD2IWA/VSQpADR2jE6R/Ui8LvnAi
         p3QtWofWllomLXu/G+9uOd0ebaD8gJbUg4YIGpQ9z0VxA7GA+K8SwdVlueo0sGReb/nh
         EA4hDnsQlo0FrO3979V+X2VJG5gv/XIQZZeXVlSrjTNCtnNgJxfCH8tEhGgKkJiKrfcr
         4EAxwNIyIRF5AEn4weSNJdg3H92/PECVCZNdocWUF2UVWq3YzIqOY5Mz9P3id0CNACdm
         YWju8GcfDqJR6aqzwH40GYkBTOb0P1Lz1LjW1ADyoukVk4f2MuANW5UMJ8jD8N+NNdQy
         74nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794222009; x=1794826809;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ElXE6Czu3kJtnBp4J8hepfVFWJpvs2+YyAeDoXoHd4Q=;
        b=OUwBcnQs+cRBOVb54EANh3kmpL0aLZ2smtujxJDZN/7yjkEpfSgnaarWu4GwRcvaKt
         B+bMMZXNb2jemufD+6rNWjYkvtZBOjg635gyBcresuwZIuHy6tm3aEzybUoB3xRUaedY
         QTzfTDwe6mmm0ZDhDmTUx4LvRZlPUFAoG9611/dWFyqeB55VXTM6c+kAru7ueSMElx0N
         d/XUTpEweILdQDayq+k63bsY0U4SbhlrO44kD1UHa0MvZMW4qds+Z6/DSQi9E/56cmOK
         wUpaRp0x8NunCqPLAGDGetmyHNW2TE4HQbBKlcy5nftK+KrvU3DjO9MhLxeXKwzP74vL
         ys7w==
X-Forwarded-Encrypted: i=1; AL+hErGmg19BuvngHLLjoNUoMl+dEQ8t5JmuqVT8TESQ0koES9v+QYqzO858OZeFqZkgKm9obcLWq9CNmA==@kvack.org
X-Gm-Message-State: APuU4Z+MPBCgQ+iUN/QrHdMsV68Jhh1KjtRzA8B4pRQFzyDMI3JUApQO
	KXZmeR9f5ZujPiSCO6yMVkiVjRqM3GDvtvvbc23idnEef0lFAZqPhnJM
X-Gm-Gg: AYBFou1CNU1wpIaLBLSaPYKfHO1p8LQrSCr/TihZ6pUC6LViYYSWeXJt75gxqYaIGDj
	e9Meqv9N6o6Sgrzqap460XCvTEFbL2qQ/uASo0lRpCEZ3OgedAnEc0Jupzi8Oyf6xvQZkrVFWd4
	2x3T5BhuXgwX3gHkqJ1c15qtBAx84irTl268OgdxC8sB0g4o99a1eVKMZI5xGDMGxmePpt4YJfW
	iGBJlmJxmq1PrWZlv+SMd0hnHSPRNYJMCvMckWWOwzMchiMDCrl/TrDjWfH4rLmNa26K355YL1v
	hsLfOMbDV5hJh63QWH6+0sKh1JSSNFbCi6z0rWG5PFFt2eIX7hPDp7xcgBr7zvayGil2zmhozmU
	w0QbyrknkIQGmnZ+Ag3dvi05drYw03Jr2e6uTnqQXAweF7ddTmovMSwdqaYLKKtMCqWNNq+fmTx
	Id7LgFUrXC+qg6QZXejjqr7pDXQOQeRQysKmbmlfYNHgMigsOSrZ0GGu5ci5wGwDMt8n4LMLhEK
	118boEDqXSDUlmAzO8wU5zp7bXdPVGztvsEOfthwtHkSnSKJMNpSZit9HVtjLFV177KUuRw5Vud
	vg5THROq3BXMqCQlrgWZYeH+M3XLOJgCZx+GTznzdz62JTTPSQ==
X-Received: by 2002:a05:693c:8808:20b0:36c:9e26:88b6 with SMTP id 5a478bee46e88-37256613f82mr6129121eec.9.1794222009245;
        Mon, 09 Nov 2026 03:00:09 -0800 (PST)
Received: from hongfeng.mioffice.cn ([43.224.245.240])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37265c06c61sm11832518eec.14.2026.11.09.03.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:00:08 -0800 (PST)
From: Hongfeng Chen <chenhongfeng0212@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hongfeng Chen <chenhongfeng0212@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Hongfeng Chen <hongfengchen@xiaomi.com>,
	Hongfeng Chen <chenhongfeng0212@gmail.com>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu batches
Date: Mon,  9 Nov 2026 18:59:55 +0800
Message-ID: <20261109105957.2577351-1-chenhongfeng0212@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAKEwX=M4jTnxmq6cj115Gw4u5jdY7Ex65jPtVTEopW70jGzfuQ@mail.gmail.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com> <20261023123736.1542117-1-chenhongfeng0212@163.com> <CAKEwX=M4jTnxmq6cj115Gw4u5jdY7Ex65jPtVTEopW70jGzfuQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 31u8wnibof7ki91j696hdfag8duhf98d
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CE60DA0008
X-Rspam-User: 
X-HE-Tag: 1794222010-325168
X-HE-Meta: U2FsdGVkX1+S8q8PjpKURKb0+9QTyaUOKoYU0Su0jXsvpDx5yESSZ9K8kE9/zXc6zIwMimutda/arypoRwaEQu18QAPrgf02MbCaO+TBvtZYEJ8dO6WkQUTKyV80Sotfxwo4np0J0SF2pUWpmUla+mCIepF0DQsPD62iH824yANVOnBDTN2fNcGCqtOssh+mkFcj3J/1PXOJ3OnKYZynaqpWDHTWYQyH9xvBVz+8WvNFAFijVVsafgVCbtJzqzP1Obp+yaWIiOX/AHUOoDa/0CyhQLhQoAJGrCCvWdEDaGj8YWON7U79Tf1zvxup/36v4aiaooEXSglT85t2uMDw7AhBHXHMsPqQgHNxoSOyFnqts5S/ElwYWTp40nByxAPoaCUn0COWch8/Q4SMvQPYhsre4yfvWoVvj3gF76c8/RoPj/lIZhH6aeesZeLT95ET0GIkNcEhNyCFL0cn0Y73cSSezqcN15KfHjJSW4uks7olL1KBGbhyBKyQ3uNAKdP+hVc6xWw7KmWmffYLNwtUJqtY/KG6rbrP9vPVRjiJ48TJjKQXW3/BG1J7AGL1uFSmCIqPiq03Qm+T0Sc44IzXBqfmNQqqawE4t8fGD08YL6e2JcRijG4GRjth4xmUHcB/tT8jXI4GsG375C8LlSknv8CLBGJLySoHUWKDVrIqLLblqW/Iyoj+Io1aSKKHbSsOPsZRZVeo5MtJw9SZobc+zlJlu0zfZdFp4P2XSHnnmGfi3odtwQ0cUA9L1WU6PsVVK0mRnLPW1gb/QfVLJmqH/n/D9a+whlkx7mSnVGb/XMLKAA5qUGyA0ymCkfH6g2ls9Qp1bSwafohL35sMACqoAxELDaTcjwcDb/veL4oIkKvfa+tLeproOvPy2LUsT4DKHaiX/zQ6pZxGRD9tI2kq5kJvLmDXzEQ+49K7FNx/fbjKKLH0doEl9ulDxooHUMGBnb39TgM2fpTmCZSL5Um
 NGgSgsZJ
 O/Lb/AZ/CGR9lB03g3aHWviCGg2uhhMxqTmb8kFjcYLaB6AN2lsZYGf7WahGuhhPVWX2toHILpi3mO3AmyN9stD8vO99hgLkSjE91D38QWLkRH2n7hXNM6xgVhDAnhfaart5QbuRG8TK7FkEze3w8go2vAb+fMEBU2+ci0DOxE6x+fVol/EWoKPsdJg2cAloY5YorNzk/+S7tvnH+qK4fKIm881VhzwvnieXPJuZAvHTrw49UKqcqqPXMKN1yP3zSBe4r8ZE4ev8sqB6Li3FJkHoEI9Gmfi5HuYiTYfw4P2V5GpUkqeLfjRhKCO7ahwYnUMCe/CLcv4kKq2wcroU9+qKQrs37utxy0M9uxueUUBpfVQz9ebbPqLvkoIBFhIeYPeIKdhA5HOeXfES9qF/nlSgGEb7fhdp56HzQtPdru/Ozyfy17joH9CVwDvYg8d8yfy2VC//Sk5uGB/9EA6crvLin7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfeng Chen <chenhongfeng0212@163.com>

On Fri, Oct 23, 2026 at 11:19 AM Nhat Pham <nphamcs@gmail.com> wrote:
> Is there any more juice we can squeeze from zsmalloc in that case?
>
> It would be nice if you can perf zsmalloc freeing. And yeah, maybe we
> can't optimize any further, but let's eliminate that first before we
> rely on offloading.

Here is the perf breakdown of the free path:

zram:

  __swap_cluster_free_entries        90.28%
    zram_slot_free_notify            86.01%
      slot_free                      74.15%
        zs_free                      56.01%
          __free_frozen_pages        19.85%
          kmem_cache_free            10.15%
          _raw_spin_lock              5.53%
          fix_fullness_group          3.31%
          dec_zone_page_state         2.43%
          obj_free                    2.17%
          trylock_zspage              2.12%

zswap:

  __swap_cluster_free_entries        94.30%
    zswap_invalidate                 93.49%
      zswap_entry_free               73.76%
        zs_free                      34.03%
          __free_frozen_pages        11.13%
          kmem_cache_free             5.57%
          fix_fullness_group          2.66%
          _raw_spin_lock              2.45%
          trylock_zspage              1.75%
          dec_zone_page_state         1.67%
          obj_free                    0.96%
        obj_cgroup_uncharge_zswap    13.90%
        list_lru_del                 11.73%
        kmem_cache_free               4.62%
      xa_erase                       19.27%

Most of zs_free() is returning memory: empty zspages, handles and
zspage slab objects. So returning memory cannot be avoided, it can
only be batched or deferred.

In zram, zs_free() is 56% of the time, so deferring only zs_free()
can speed up munmap() by at most about 2.3x. In zswap, zs_free() is
34% of the time, so the speed up limit is about 1.5x.

That leaves two places to go further.

1. Async freeing at or above __swap_cluster_free_entries()

Deferring at or above __swap_cluster_free_entries() covers zram and
zswap with one mechanism.

2. Optimizing zram alone

For zram I would rather go back to v1 [1], which defers in zram. v1
also uses a single gc_work per device to offer a best-effort service,
which greatly reduces the impact of the unbound worker on other
tenants.


[1] https://lore.kernel.org/linux-mm/20260412060450.15813-1-baohua@kernel.org/

Thanks,
Hongfeng

