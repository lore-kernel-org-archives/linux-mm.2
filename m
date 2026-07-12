Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9958C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 13:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769176B0088; Sun, 12 Jul 2026 09:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FF76B008A; Sun, 12 Jul 2026 09:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6078B6B008C; Sun, 12 Jul 2026 09:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3793D6B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:28:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE686C4645
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:28:25 +0000 (UTC)
X-FDA: 84980203770.07.543733B
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id E43ACC0004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:28:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TkhdKnIZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783862903;
	b=QApDtmZGfMl35OsNopD3gEgb1hHOgySGxtb9FJF4A8yH86ipGqowp64AMzEoI/tF+Vsb0n
	iaWAL0qvELCLvFpIYWLAd3mSqRvNZIOPvapCMpAHg6lYS6wqs+4bSCHyQ+S/oofyY6k3si
	4uhiNLIMiiZgx072DQL4ofq43kKOD3M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TkhdKnIZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783862903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quumgjqsYkcYoEPAfTHS8GfYRBhwzzatV7O83C/ikN0=;
	b=iAqUFkeWtgsVbVhv3cBzWu+67ozpYErwUWe+Rv+MtYKtELtvlLJwMuJHF+RbwM2m3tvbmQ
	h7i3A7JdS9EiPU5+JQ98UY6u1SdFz5YrRx8zln0sGHLQhCAER3jNejPGLUI5jRw09Q58lL
	imsS+TXNaOfq+c9Rxnr5NJ0vBs1ZYEk=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-c9fcd903839so1314649a12.1
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783862903; x=1784467703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=quumgjqsYkcYoEPAfTHS8GfYRBhwzzatV7O83C/ikN0=;
        b=TkhdKnIZe3fy9QBpsKdlViFSV/kD4UKNeNF/dDppjqgQVxrZL0w7+7eCmjeHhfigII
         US6grg3CVW+p2X27Xkl6jJSoAgBAiEyHa7zcoBWscdktpXDZ6C57hZjxgcVctBm1Mw9W
         zbxF9triWWmuNiz/nji36Aq+M5hhCW4+frGyeUP7NNZQ+EcPd3fNqL9UlUFzUUd9gl50
         9tgXGr2n4rtikZL4yTaEJv4e4v4mdqpAC0Ss0avWI+Upa+jHjrEO4OSAsFCtJne82DOI
         z4h2CDTXxLT3iyRVbQyB2HJOmKiHqiWHjkkt+MHUFX4rJJDmHTHxNUbjVfO2wUP3hV5A
         NJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783862903; x=1784467703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=quumgjqsYkcYoEPAfTHS8GfYRBhwzzatV7O83C/ikN0=;
        b=j4MU9brmy/kByOe0/MDT8SK8c/M34574d25fMRSEZKrSjCPdgOncbj2+lHx7p7sKd1
         T+wxh57277i/9AC6MX2GjpSVQnqnKO+JrIx3Ki+NKdBZ9qouTTiw3vSsUqKVGuwMo3SW
         F6OM7GqKxDaQsnPngOFZD9aIlIVr8hSI9Fu4nAM17xs9l5M3Rs91e5091i7zcGS6DUxi
         hMIR2n+KpWvddMugE+Yg5DFN4Nes7TiGFMaHWfo+Ur362me3i3wNi75Cdqr7nkoaGGpb
         hrrXkQdnzo+vw1BwcLQh/9vrWcjJxLWOKGTp5iNdiAy8Fs1SIVCzE+7deX6qCDPQqAW0
         V4Fg==
X-Forwarded-Encrypted: i=1; AHgh+RrPL5mKMVolCDx2OVSFX66SpVAkXkHuvW5zjTSZkhzolyMG9FKERGvNNnw1klkgqB5Xb+HW5SWgQg==@kvack.org
X-Gm-Message-State: AOJu0Ywrd9Hj6cc+hH+qYJm7Ymq6OwQdyZ+vPSntvvScoseP0CVadE+9
	yAZR89Dw0U20D4jwa4yyRw/zVLPZMSl7D78X7r66XJG/nRLrHXYvrXU9
X-Gm-Gg: AfdE7ckkMUgijgfyJ4zPzoIuETckwcJ9CTow6ccVJNDzccZA/91LMn0OKF/dkpumgQH
	S4Lv14GECa3yyBuhlkQ+H4aVcZX48J4dQ4dua0CNjE6AuXpgCrDgzyMe1/QR460p4yl6NNLemNu
	bckfn4wFANLphvhlqmMmQANjSzbXulMKYWSoSp1G+1R/aeyFCyRBSrlqPv6GrvSYoqhVLUMcDt6
	dTuUhVCZsOGQ69jJOvunKfb2PHoJqPvg2tx2T43Rs/kF/ILgv5U6ogIj2aDhviHUo7N9ssnGSZO
	4JEl5v9Rb/SkA3z/83p0B9Xlgzy8AAWk5mZov9cV0KYXaHQ9DciRq12nmL+KIqvMdsO8RmCmMwI
	0MaeQwfnE7gVWTDCaFX4Bj/G7PtTO3Ob22DqFpmXTZIx6/orp7S8xexDXSx0OSjmXZYIBMyI0L0
	cCPgMcer4bX2vnM/74hIiemLpkh1UFjcSeJV2t77N1
X-Received: by 2002:a05:6a00:ab88:b0:848:2f84:f429 with SMTP id d2e1a72fcca58-8488976cfd4mr5160709b3a.66.1783862902694;
        Sun, 12 Jul 2026 06:28:22 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:455b:31d6:12b0:69de])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d498dcsm12561493b3a.30.2026.07.12.06.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 06:28:22 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when mmap_lock is not required
Date: Sun, 12 Jul 2026 21:27:59 +0800
Message-ID: <20260712132759.2030823-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <alG_1bhH5aqQCNEh@casper.infradead.org>
References: <alG_1bhH5aqQCNEh@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E43ACC0004
X-Rspam-User: 
X-Stat-Signature: kpqe4co3y1ud7phdrsjgzb9qxru38wfb
X-Rspamd-Server: rspam03
X-HE-Tag: 1783862903-419960
X-HE-Meta: U2FsdGVkX18wtib3/OISMcTFaQFokdcZKoFoxe9qMrLL4OpXp0vzVjh1y64gcqWxoqXWz/Bgw7nMTzT7D+AtlxjvH8B4yjjDfxFiFnziTdMqHwcM5jSozzQNK0rXP5EAPZaYC9ozIQRZhWk1wmf+tascT4I/tepsokM+xP/3XKZO459E+7Ln4P7aJJMAONTSsPCKHvjmlinP6745g0lP/62de9KL61iRdu1nLt+jxh/Qdy7DtbTR40niLeXpPv8OeFB+Pgt5raUs0XLBVe0xGtTETAE31FgCO/bBMrqjCjsv/ccbSRIrRLFF8+6mscrkJRCefWgYyX2ZgoY2abIRpewZP3PSMy8vXhdZvw99p7ixnGuMc5stWn+vNTjZVwQqe/CubIwNprZyFJDLfj1kx+AV61g8X8X7Cm1bCCqrYTlHUhemrHrwLGqtdRFssXxqZRWFrcqZPSZyTvoZuR6XvCwwAmUwPrE+R+kblrj9Yb33LtY3ITctlbM6D6S0/GKJwU0EdJROLz5ZLV4fU6uYh8cyhi+IVRnCA4v76z2i+MGypdCqJ+wwn77iYyBcZ/4E3JC/k42NEnk2IKYk+BOSeA7wteWW4lgu7StDn78bJLI+qQHpYagb86KCSx5/ukPBFO3bcARAO5fLFbizAWQAzFJVaTAwx8hL5KzKl9nbBpCqhsIoij9H2S24bWw2vMAREcOtNREciKNYZfcK2HDSvkAHXu44HcgV0oMfGVPAuLZuTMGrlBBEuEHMni77LmuAoN5O6JabPAfPoCnmHjnuwpAJNg/O3znBKWBcvleser0tcxYZ4D8oHYwcN1ObAVksO2zd/LVtbD6tZ03WGUapJ65xGdig1180CPhIhq1sClGGiZ462ivDqa72pTbJHBZL9bHXciUZDRbIx0Q9Af3EyawBxFtL22rcIgcHquiDQYHIcx7MaFl/nkzE78wnEwb4b6BjoyMdKMs5GRCKUVT
 RRgX4nfZ
 O7VE0gMZ0o0TCcl1eCFrgn/1Fzsb0FiNUpeFm40tXTjmF8x2/XszHZP9d7I3h4wy/FWlhc4s/97wGoftfkeYzZgvF+pMROrEFJ/rLQj/FC2TwRgChKbiZHhl3hETPUmOGiHDARzOra2+jaerJgTRIZedUP2ZbafIxoda1yoscKCXByUC+tzs+2i/8uhvbLRHdiL2khuP2EzhkrVnX8dgyQJwdSwrv8KI9KtZ7KiU6VL0BynwBwk7P2f+g3jFVX/zBn2W3MjwspGIwZMwf5AB2gyudDBkbB/hL30Gs9VAdxzeYvVwLqiawEFs3bZbtRXWLykJ4Eimzj2GIww3MPPSKHNGsZOGzFCXfglW2aVSUhIQK8aC129ezExMal2wkbP8RnCZQTHq70Wvl14mmkA0BVf35H3kyUhUbAhd/rAx1yr9AfVLrKdi3+USYAksX1XgqA9OBLg8fwtIKIUbkBxGsyi8E8ILlJxgzHvFc0YOmpeoF/O1qYwjUAhWHC7PW0V0BnCTzpFDg6FA0GL/1y3NZTQO+nmw53LR4eK4L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue, Jul 07, 2026 at 05:52:31PM +0100, Lorenzo Stoakes wrote:
> > +cc Vlata, the only one from the MEMORY MAPPING - LOCKING people excluded,
> > and Willy as he's been heavily involved. But see below you need to cc- way
> > more.
>
> Ugh, I hadn't seen this.
>
> No.
>
> I've been looking into this problem, and as usual it has turned into a
> yak-shaving exercise.  I think I'm five yaks deep at this point:
>
>  - Need to start by simplifying filemap_fault
>    https://lore.kernel.org/linux-mm/20260625195040.2508362-1-willy@infradead.org/

Hi Matthew,

Thanks for looking at this.

I understand your concern about adding more complexity to an already
complicated fault path.

However, I tested the RFC patch [1] on Android workloads and observed
lock-wait regressions. The common pattern is that filemap_fault() can perform
file-backed I/O while holding either mmap_lock or a per-VMA lock. The traces
show three representative classes of lock-wait regressions: GUP faults,
kernel uaccess faults, and per-VMA-lock faults blocking fork / copy_mm().

1) GUP faults under mmap_lock

  APP: com.xs.fm.lite
  lock type: mmap_lock
  holder: Thread-77
  faulted file: libbytehook.so
  lock-held filemap fault time: 95.606ms
  blocked writer: NetDownload#15 (blocked 218.971ms)

  Holder stack:
    filemap_fault+0x0
    __do_fault+0xdc
    do_pte_missing+0x2c8
    handle_mm_fault+0x4c8
    __get_user_pages+0x618
    __gup_longterm_locked+0xac
    pin_user_pages_remote+0x88
    process_vm_rw+0x2cc
    __arm64_sys_process_vm_readv+0x28
    invoke_syscall+0x58
    el0_svc_common+0x80
    do_el0_svc+0x1c
    el0_svc+0x48
    el0t_64_sync_handler+0x70
    el0t_64_sync+0x1bc

  Blocked writer stack:
    vm_mmap_pgoff+0x168
    ksys_mmap_pgoff+0xa4
    __arm64_sys_mmap+0x34
    invoke_syscall+0x58
    el0_svc_common+0x80
    do_el0_svc+0x1c
    el0_svc+0x48
    el0t_64_sync_handler+0x70
    el0t_64_sync+0x1bc

2) kernel uaccess faults under mmap_lock

  APP: com.xingin.xhs
  lock type: mmap_lock
  holder: Thread-2531
  faulted file: libtiny.so
  lock-held filemap fault time: 172.375ms
  blocked writer count: 5
  writer wait range: 152.766ms - 172.006ms
  representative blocked writer: com.xingin.xhs (main thread, blocked 172.006ms)

  Holder stack:
    filemap_fault+0x0
    __do_fault+0xdc
    do_pte_missing+0x2c8
    handle_mm_fault+0x4c8
    do_page_fault+0x39c
    do_translation_fault+0x4c
    do_mem_abort+0x54
    el1_abort+0x3c
    el1h_64_sync_handler+0x80
    el1h_64_sync+0x7c
    __arch_copy_from_user+0x1b4
    copy_page_from_iter+0xd0
    pipe_write+0x1ec
    vfs_write+0x368
    ksys_write+0x78
    __arm64_sys_write+0x1c
    invoke_syscall+0x58
    el0_svc_common+0x80
    do_el0_svc+0x1c
    el0_svc+0x48
    el0t_64_sync_handler+0x70
    el0t_64_sync+0x1bc

  Blocked writer stack:
    vm_mmap_pgoff+0x168
    ksys_mmap_pgoff+0xa4
    __arm64_sys_mmap+0x34
    invoke_syscall+0x58
    el0_svc_common+0x80
    do_el0_svc+0x1c
    el0_svc+0x48
    el0t_64_sync_handler+0x70
    el0t_64_sync+0x1bc

3) filemap faults under per-VMA lock blocking fork / copy_mm()

Other testing also reported similar per-VMA-lock blocking data [2], where
filemap faults under a VMA read lock can block fork / copy_mm(). One example
from my trace is:

  APP: com.xingin.xhs
  lock type: per-VMA lock
  holder: xylog_thread_po
  faulted file: 2026-07-07-11-51-46.203.log
  lock-held filemap fault time: 10.518ms
  blocked writer: com.xingin.xhs (blocked 1.583ms)

  Holder stack:
    filemap_fault+0x0
    __do_fault+0xdc
    do_pte_missing+0x2c8
    handle_mm_fault+0x4c8
    do_page_fault+0x30c
    do_translation_fault+0x4c
    do_mem_abort+0x54
    el0_da+0x54
    el0t_64_sync_handler+0x50
    el0t_64_sync+0x1bc

  Blocked writer stack:
    copy_mm+0x2a4
    copy_process+0x4ec
    kernel_clone+0xb0
    __arm64_sys_clone+0x60
    invoke_syscall+0x58
    el0_svc_common+0x80
    do_el0_svc+0x1c
    el0_svc+0x48
    el0t_64_sync_handler+0x70
    el0t_64_sync+0x1bc

>  - To do that, need to improve how we handle unlocking for faults
>    (not posted because ...)
>  - To do that, need to redo the hugetlb fault handler
>    (not posted because ...)
>  - To do that, need to get Jane's series landed
>    https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
>    https://lore.kernel.org/linux-mm/20260709184740.1286561-1-willy@infradead.org/
>  - To do that, need to redo how we handle hwpoison of hugetlb code
>    https://lore.kernel.org/linux-mm/alEpBqExnyvBnnxi@casper.infradead.org/
>
> So yeah, I'm not impressed by the approach taken in this patch which
> adds more complexity on top of a system that's creaking at the seams
> with existing complexity.

[1] https://lore.kernel.org/linux-mm/20260622192114.1147198-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com/

