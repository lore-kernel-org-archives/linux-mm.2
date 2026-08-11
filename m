Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 874F6C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1843F6B0099; Tue, 11 Aug 2026 13:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134FB6B009B; Tue, 11 Aug 2026 13:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A8C6B009D; Tue, 11 Aug 2026 13:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D53116B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:32:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A1C9C0175
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:32:06 +0000 (UTC)
X-FDA: 85089681852.29.3C3287E
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5ED7B4000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:32:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eDWp4EnK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786469524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERRITY1hxaGEnfqUSi5n4r903VR9ma1HjxyBNbt5TxA=;
	b=Lbr5Sh6IImbsKpYB2uLxX0kwY25v/TkzKfi4Ne51w0mObZV1m8N5+w9+kiwuj6vvZJifsI
	dn+pTC7etfemf0DzTSvG1M7WOWtSjx6alAeajh6OgTBeyCJTfg2XInPUOl2itAakMQH+9p
	/kTzizaNIUkCJBV2+7MGyNU1zVkQBc4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eDWp4EnK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786469524;
	b=hX0EcOkap+QFw4vL6tgeG/uOq+dkF+0B8MNVKPODuvVnjwbd7IKL9FyOWNnxvKfvfiXgm7
	V0eUyLiM/bmwt1IbUBNQxShwUWPrO1UFTPuM9kFoK3hCG/DRIJMs3tdSp4KwdQ2Az93+KO
	Qi/oCSiKKDV9Uhh2J5j5N9GRR3FYC6A=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-664c628fea0so20223d50.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:32:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786469523; cv=none;
        d=google.com; s=arc-20260327;
        b=N2wHSzOpPZvloxdSCb+l4OhE5JbdtH3mf2fAfvzgosTLWcxsyqSFGkH0wzgQzGHdOr
         PyksuZfssUkMzZ2BySXBP2eOWuufUFcpRg7XUIlNufaq6sv/xNBesLHYCd1oqV7AT9t1
         Jk0SbR48qGt5+Gs7AYAd087sDr6InT7n+slydeeN0aN3ggtC5Hi2xXfyAOLG4kCf+hUP
         DTY9wUCybokq+lbkTA55bAgUAW/uWH3W2nH5sEmJwSL7c5ZgCt6IHdad7aBhCMP3RVnI
         ggdph39CQw0Lg3qtkiSg84jt2RR0EphqW+LJdt+sYJhzURVgnjEW7X0nmi/LUe6CzzmR
         zdbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ERRITY1hxaGEnfqUSi5n4r903VR9ma1HjxyBNbt5TxA=;
        fh=BYEW9I5Q+dVWPouCTmRvvJzFkEPuXHnN7IkGsAn5Bp0=;
        b=Nc1AgcerOb4eyBIb7GZUD7NsQ9uEgtnNPr6V/It3eWcEnky7Ia/9fDIKnDAo3qjTBt
         e42MkRofdJLInhtnMELX9dj20vGR5JIKean+jVaTr3WQB5AfssC7v5AVlaKInaDspfxn
         pOLcF4BEqGZej/BEmaxA4uBBNvEpY6gNgAW7jxK+4wtUDNGR9o5c7Ml95Wh2aiTShTGm
         o50x925yaYFLYI79wh1Ql9OlnPTWifL7RVpNP39poIjJMOc+V3wwqL47auxIabgo3+zh
         ELmis9iEJF8AsgMnx3zZaN7IaIDRT2CHsm4ksqKXx4tEa4MzD0GgLYIh8BAJ0HfMRHQF
         89Ew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786469523; x=1787074323; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ERRITY1hxaGEnfqUSi5n4r903VR9ma1HjxyBNbt5TxA=;
        b=eDWp4EnKTzdxFlJDPeT3GlTxF5artAhVsPmJDIZNksKAJCbkZNXVlPoF/FJjeK7QV9
         yFXovom/OUVMrrC1faUML2Ov8/5GaLSUGBh+IF1n8ixTGiauojRm5LxbsStY5juZFN2H
         l8tAEJw5sWChS5OsY0XUmJQhuyw9DV52XDOct9+mo/+YZxAqprF6DmykSBC4+HMqWNMz
         WLtrudmWLXI1xLPOyDR3zOVIxGrhjT6AswbaWzWoDR6UvffaiHdxaTiGz291DfKHvHrf
         3pnG7wbHXygPbnpUa11MCilFKfc8n83j+lYxIWFJVgQq9gow9rRcXLk8EdGKi6T9ymrz
         bZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786469523; x=1787074323;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ERRITY1hxaGEnfqUSi5n4r903VR9ma1HjxyBNbt5TxA=;
        b=If3JlyYGYUgELw4qSEtPIVmGnmPhBwQRPLrZn1o59ZwjPjx3IfLan59eO89++N2nl8
         nyY9RjngTjfouE/ZkE0FPklPnet6Tayn/YqVE+t7T2th3Z/ZNS7QfxYjKLzQGTErEjKC
         pNwGy3phcpZvlqDBY6MuCX94RV3+RygFgeLL7joBZZqgv+4mJ1mM76w6yykLBRPRuklA
         bHRe4b66GNRL11kVgXqM64wE74bExcgi7KItAnD5c3h9nAGoj6E8sq8saX6E8js/1lFX
         rmm+iAbgMiDyrsuM9yZpiP481b32wQD/igYvvYLhTjtzw/ggGbnU73uN2TpHe2rzRfhd
         E+xA==
X-Forwarded-Encrypted: i=1; AHgh+Rrwjo+kpFLGT/dAkWCMvNoj9KmDasZO2QbqpA6/EId8ESWnFelPcTFBmWKL1zZnCZl7aiETlaCVkw==@kvack.org
X-Gm-Message-State: AOJu0Yxo5bFdEZ++yx6eFtZ3TG/XbyBb/gSND0KYzZ8+Vypb75EOhKsm
	Al1n/GczXUn48ZlQC8jy8Yjplc235qd+IqoDJDu9SZpguAg5ejFJ64u2ZWyWV39fxOCd1X1Kh/c
	HqmU4HjMXjVS6+roOdi0hPseCxD7L+vA=
X-Gm-Gg: AR+sD13I3zhmn3FpTrBY2Uv+FcML78TTqmPUQI9j6wkWRgzNOyWXjSKexqjSJS1iQuM
	zcIgwShQ9QLBSYUFS53umznqU/oVFfYNXolX0/RG5TYkMqgNWRqVWy68jxWNgOf5dLrGGAf9mMZ
	V7fmsDA++mH/dHOaxE0insaQaOWa0FOVjfnpmpQzbkxB1J5lOxDkjY6WZoDIOh+QP8I01ekvXO3
	2ovC2tfY6YT5+10JAx8uovyN9yqtkzdBV5Bw/xuuS5SkrQg4mZt9Wgh/zxuZvtDEixzYtTXLNiX
	16i9f+d/IxaOF1p4hosyi1a0OiNJFWUzLv+CnFkhzFmEdyk=
X-Received: by 2002:a05:690e:4889:20b0:664:bc5b:79d1 with SMTP id
 956f58d0204a3-66b22e451b0mr2180056d50.3.1786469523393; Tue, 11 Aug 2026
 10:32:03 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 11 Aug 2026 10:32:02 -0700
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 11 Aug 2026 10:32:02 -0700
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20260808031459.3032812-1-sh_def@163.com>
References: <20260808031459.3032812-1-sh_def@163.com>
MIME-Version: 1.0
Date: Tue, 11 Aug 2026 10:32:02 -0700
X-Gm-Features: AUfX_mwrhilf5EkQAmh6qiDNdpRXB0bQkc0hgqQsNdzth8bGhV9f0aBTbfanMTc
Message-ID: <CAPAsAGxBpKDLNRoFCzX2+Wm5HC07c0uaoRsTtSOHhFsB4Bx-1w@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: fix cache shrink race with CPU hotplug
To: Hui Su <sh_def@163.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Zqiang <qiang1.zhang@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5ED7B4000C
X-Stat-Signature: ff9m4suamh1zb44qhh5hsphu43w888cx
X-Rspam-User: 
X-HE-Tag: 1786469524-256253
X-HE-Meta: U2FsdGVkX19Q+UXV3hJJon7z1xMgGDLtjT5u9dGqIsMlOHeIvB8WlLudZq4x5xAftsLzmmMpkrDJEUhmrQw9rQkcib8/qz7p056b66/zC87CnNOvPa+Dckl395S+vLZtVW4tyqC44/Ws5xQ5uL2W54BFeDjl6cKN+VpNjLBZd+oNqib7hK54CeZRwvI9Ps1dvAJCzIHVMXuPJVrRkcNeK1QW7jc99eR7p8bBQN0Fi64RttP7lkolp2NbJYJGdndlj9kl8hd3dmxZ5DVoPH2//wy4i2WESG905tFRxAzXk1iVCfq6Q3HbDprD7jAm9PrsbtTw5x05ZbTXSvGG1W7Kn6tBGrwJi3z6PvapkCJ76M7w9Ka0ovTNciQ+CWu/7hsVKZnTVMQWn5rhSDbqDYc7poWLeVlpsSeLRfO5IDiDGQnTnf7JKPgABfToDQWUdaYkpxty/me1zM2iN5fTMOhijirJwdC2C3Xvsm9S5xo30aEnhMzFklrryaD6OPUkmNyhYpPdes66R3ABZMpzzNnIUMx5n5yEyPs4lW+HWOyLiGhcu7No2LqU7XzdJAytXF7SrQCmuJW7GUo4P0dMQdXRIgAURvgEaIXZ3YJdzuzjlJb1b0aRB+fX0F1YXqkjJFEuaTTbaGAzrgi3J6iIwsswUkp9tWBN5kpr0KflWGlgyAdbVMVGHMh5p3BzgFyxHuAKLh89JSNGZ/s6zGsnCh9cCk7vF0ZXcJ5XUMvRJz18KZqCCDQ0zReOGOeZvpeMt2HOOFWYUf0tQONSEOSIuxbMZwokl2ni4apXeSrZDaR9lIE949t9MWBVPim/DINkZlhdEfNMioacfNnVlCLDM8vZw/d7QyxrqTsGzlKEGTpA4HpzG/qe0JdGBZZ8dpuFpz9wd3iD0W8+dxs8Pn7qGUE1yiqsiv/e/p4Z4/2gTJ+/FmKgzaQYx3i0wI8imJWb+6KzKYveD76yHWSMC213AM9
 dvOfLZj3
 qlrvPYBjXofDvEGVDlEJb8MmW9glX0QCh0vgzkE+16WH+lfKfrBaUCGk/Y53XBlrPH4r/YVUCohhf0if3oL2MFIIV4/RYe5v/PdkLPmsrBDFSURkGry/N/MjOFvHDi8crq5STVlBmh6fXJIV1q3rWqZMx9VmrhfQmG5x78hBSpYlmKoHsweVIFhKdlKjQJQyHxefSjzKULMsorYdxe92AU8E4b5cg67En9v3RHKEgoSZOkw5SaTTiY3f2hz7lgJm+5HbsWxzWwYKyx5JFvyq295i0v5DI42pPluw2joW1qAZ8LowxrpLlvpt6BEJJsuSdimboCwReheDRvdM0iHX3kRyRSl7jmPfNpsXqMbpJ0wAM60DqiQAGUYcc7jBZEz0yjlD16vVz7fg+MDyJ5EydsQxAjvGSdL41j0xAKJRRWHI649rkmVcTBqUjVjmXgc+apX5gdoeP/QoF8gq/IyTgNCfr5SEGsHjFqL/h2H9brCkMUzbSmhJFGRzAVRBJqryNTUlbZusVOTxOHvKEf3VfphllTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hui Su <sh_def@163.com> writes:

> kasan_quarantine_remove_cache() first invokes per_cpu_remove_cache() on
> all online CPUs. Each callback moves objects belonging to the cache from
> cpu_quarantine to the CPU's shrink_qlist, where they can later be freed
> from task context.
>
> kmem_cache_destroy() invokes the quarantine removal path while holding
> cpus_read_lock(), but kmem_cache_shrink() does not. The latter can
> therefore race with CPU offlining as follows:
>
>   kmem_cache_shrink()             CPU hotplug
>   -------------------             -----------
>   on_each_cpu()
>     CPU1 moves objects to
>     CPU1's shrink_qlist
>   on_each_cpu() returns
>                                   CPU1 goes offline
>                                   kasan_cpu_offline()
>                                     drains cpu_quarantine
>                                     leaves shrink_qlist untouched
>   for_each_online_cpu()
>     skips CPU1
>
> The objects left on CPU1's shrink_qlist are not returned to the slab
> allocator. This may prevent kmem_cache_shrink() from releasing slabs
> that would otherwise become empty. If CPU1 remains offline, a later
> kmem_cache_destroy() also skips the list and can report that the cache
> still contains objects.
>
> An intermittent occurrence was observed with a virtio-9p filesystem.
> The mount and umount commands both returned 0, but the kernel logged
> the following during the userspace-triggered teardown:
>
>   [  2994.380134][  T111] BUG 9p-fcall-cache-1 (Tainted: G    B              ): Objects remaining on __kmem_cache_shutdown()
>   [  2994.381140][  T111] Object 0xff11000004361118 @offset=4376
>   [  2994.381607][  T111] Allocated in p9_fcall_init+0x201/0x400 age=19564 cpu=1 pid=104
>   [  2994.382591][  T111]  p9_fcall_init+0x201/0x400
>   [  2994.382810][  T111]  p9_tag_alloc+0x12f/0x700
>   [  2994.382982][  T111]  p9_client_prepare_req+0x102/0x3e0
>   [  2994.383165][  T111]  p9_client_rpc+0x1ab/0xa50
>   [  2994.383334][  T111]  p9_client_getattr_dotl+0xb0/0x1a0
>   [  2994.383515][  T111]  v9fs_vfs_getattr_dotl+0x115/0x360
>   [  2994.383719][  T111]  vfs_getattr_nosec+0x22c/0x3a0
>   [  2994.383910][  T111]  vfs_statx+0xd7/0x170
>   [  2994.384062][  T111]  vfs_fstatat+0x45/0x80
>   [  2994.384215][  T111]  __do_sys_newfstatat+0x84/0xe0
>   [  2994.384386][  T111]  do_syscall_64+0x115/0x6a0
>   [  2994.384566][  T111]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [  2994.399720][  T111] WARNING: mm/slub.c:1244 at __kmem_cache_shutdown+0x363/0x500, CPU#0: busybox/111
>   [  2994.405655][  T111] Call Trace:
>   [  2994.406325][  T111]  kmem_cache_destroy+0x73/0x1b0
>   [  2994.406630][  T111]  p9_client_destroy+0x271/0x3c0
>   [  2994.407210][  T111]  v9fs_session_close+0x3c/0x260
>   [  2994.407409][  T111]  v9fs_kill_super+0x48/0x90
>   [  2994.407584][  T111]  deactivate_locked_super+0xa3/0x160
>   [  2994.407778][  T111]  cleanup_mnt+0x1dd/0x3e0
>
> Thus, a successful umount left objects in the 9p fcall cache and
> prevented the cache from being destroyed cleanly.
>
> Per-CPU shrink_qlist storage exists for every possible CPU, and each
> list is protected by its own raw spinlock. Iterate over possible CPUs
> so that a list populated before its CPU went offline is drained as well.
>
> for_each_possible_cpu() can do more work than for_each_online_cpu(), but
> this change only affects CONFIG_KASAN_GENERIC kernels. The extra work is
> limited to cache shrink and cache destruction paths and does not affect
> the normal allocation/free fast path. It adds one raw-spinlock-protected
> scan of each possible CPU's shrink list. These lists are normally empty;
> a non-empty list is traversed to remove objects belonging to the cache
> being shrunk or destroyed.
>
> Fixes: 07d067e4f2ce ("kasan: fix sleeping function called from invalid context on RT kernel")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Su <sh_def@163.com>

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

