Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E78CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 15:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906F16B0005; Sun, 14 Jun 2026 11:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8796B008A; Sun, 14 Jun 2026 11:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A70D6B008C; Sun, 14 Jun 2026 11:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 683C86B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 11:35:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FDD014072C
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:35:42 +0000 (UTC)
X-FDA: 84878918124.19.CD62DF4
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0DF851A0006
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:35:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AYTKaWdU;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781451340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pR8769p891UZMpH2W/uEW47L6qds0Zm441UJr101ko0=;
	b=0D46RXeNEru2edEdaGJnYtEXlQwC7dyIyod8LCjA//P0cgu/LHqYPNLIikhMuETM38gV0B
	SrYF1wnZyUJitqm25uJtnvEN7whygzp7YjQWZHmSGZDrD9ZoFd6600FkmqYy78EpuUHZp9
	MFSIHPH7Mvxd5puXZACPZooCSWdGY+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781451340;
	b=gSD8TRCOYjAECanTGj7BZlVR50U8jH0WP+BNSqYaDLnrJDnJZsV5Piy3HZ7SHwLPAAzu8S
	o2xJdq4Bvvx2umD6hWaaIHC2NCmvkCrAQ/F188mLybPAC/NoQ7d1afBYRD+tfR4d38lqkV
	/ghC4G3yVzAP7N1IkU8HgfzEHLfpRPA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AYTKaWdU;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30759632453so2883080eec.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781451339; x=1782056139; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pR8769p891UZMpH2W/uEW47L6qds0Zm441UJr101ko0=;
        b=AYTKaWdUh2Sdug9b6HPfIvTNXdPe0JbO1pFyJq2JQua568YLrncuYY/c+muCEmPLLc
         nfeEMlrv0Mw+mlk4YH/lX/Z1x4PL8UdFwKXugukIfpGQ2tBZUdwVC2J1sX++1ADDuQqv
         mMi1+3kz/byeo5ykPSYGpClyr7zdNbmxBXASntXmCltISk+gXGcg/1NHbw1t03L+vA/h
         QGIOTDpthpCMpEsoIJ5b++vJVVwdnF1iImkwvg8JSAYXn84uQcel74Jz6V/CZZmgd6KQ
         2m7k7BDkOqhmqnuh9k92S+cNzZgMvlGrAfhW32xhOJ0CpSDdgb+3TPQXUHRAhheG8lkC
         mp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781451339; x=1782056139;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pR8769p891UZMpH2W/uEW47L6qds0Zm441UJr101ko0=;
        b=EfJHsYmb35vGe0xlxl6u/3ky2EMSswBRjoCkHrXDN+beRGwKyDQnP18nhPMH2XWGz6
         v/h5yr9ATr1Jg8I7EQrjaP///fTysokathNuilUciSZQ7zf6kr6mW2Pa/DlRnwekdv5M
         Jk9Iz2CoZIW9olpGJGT1K0TsBLg9hPnfpmHjfNAJcKQZZa0HVa7tbyaVSKHUpBhO6IPx
         jOTgxgTiJiR2eIOy16UPCQpdjTCAVHRYwEsJgv0jCaritnhKdAb+DfgBVjmm0SSFAM9j
         SoPAfT6vMCSIn2VTHT7w1JZx/xHlwX22lWgh2RtnrXsHdx9I67PHjT0RfRxqeTXWnJlB
         U2Hw==
X-Forwarded-Encrypted: i=1; AFNElJ9RBrnvVsQjE07ZpIzQgqTwgVE8PVs5SSyjdEBodkUSIWnyepr/p9YtfeHK0mncJMycN8Wv3i2Siw==@kvack.org
X-Gm-Message-State: AOJu0YyIn4W6KH+dzGpdsn+AuTHA5RHCJe5sbd2eWSMFOspmmK+lYlOE
	N4zPvjoakDeTQ1d2CNvFTZe7p7nnU3NEidRcRhrM4PlNaTrdx5cVGubm
X-Gm-Gg: Acq92OExfkv+iOszKVLjIm70zGQ/f/Ne1xIRepntS3VvnhOzsnC83FifNl+GG1hjp43
	wSFueLtDHsATKDuI0RhQML8IHfgbdOM4iTxv9M51zK4ZfG5jcJvpWs734glAMWrtR6m8Fbc5ug8
	eg+MopChieZRtcDeyRAmgwi7Pr6mvovJfe+Tm6OifK0/vPb1CNtI4rzpNA4jTzt/J5JD2fOPgnN
	c0O4toeIsPlX/u1onRer8hp58PUyTTcRr9wSDmPy5hGiZHXtLW2rfhF8nD0f/SCbv7J+97UtBwN
	yRpB7QNtoH+Cc2O+vhkhKhCMyp3rBmPCQNjinybdXqu8FOAraBTG1PBNKUz/6AKbQXw0O/NWkoU
	vKsDZSVwcrI2qK5htYfKD0ypbFp9hDW1A2960giaOswh9nuuYS/vq7MKj4/lv2RwOhJg+Ui2cM/
	In2s9xbkGB4Oblpxmg0iPzlsjHVwL7GKK0kihl8U5z8pEJfRl/8rMBKpoXJbEp6jmXayCdn/++/
	w==
X-Received: by 2002:a05:7301:9f0a:b0:304:dfae:68a with SMTP id 5a478bee46e88-30820213e52mr5158364eec.28.1781451338754;
        Sun, 14 Jun 2026 08:35:38 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e5d0849sm12580632eec.7.2026.06.14.08.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 08:35:38 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
Date: Sun, 14 Jun 2026 23:35:28 +0800
Message-Id: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEDKLmoC/x3MQQ7CIBAAwK80nN0EKJDqV0wPCyyVaEvDNmps+
 nfR41xmF0w1E4tLt4tKz8y5LA3q1Ilww2UiyLFZaKmddMrAp+IM/MIVysrgHyXcodKUeaMKqLw
 OfTRkkxOtWCul/P7317HZIxOEMs95+6WD0cmqSBjRGXMeTJ8GpXxCrcn2DqVCsiiDOI4vt8GwP
 6kAAAA=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>, 
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1781451334; l=2936;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=YipMZO8vcbHpc9Uwgtl34KMkub+gxp1VqBvE4Awkxbs=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLdreTA16fucfMYtRCr0kKLCyUAAQoxuzmykekFWnqFYKkGLmaOZIoZGMb0x7xF17AyieFiOMQI
 NKjzX+rxzaQU=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DF851A0006
X-Stat-Signature: 5fgk5myzxdchu41np5zaea8is3tqm3db
X-HE-Tag: 1781451339-377802
X-HE-Meta: U2FsdGVkX18ajzFPom67qPSi45MJpHjxQYV9qaTuU971sHT+rPG6zspg4Fr2XFKlLo6n8PxwolaOqedXV7YjUQuQNuxv5xAzy51xJmbmp8+jowPNsi+dRQMXpxrstit6miU/ZN17Bf2Hj65CBGqvICqSWFEallnuapnH91OOMm4GJfTknC85qdg6z3besZP60S7gsOUxeiXOsPGdhNxhsdFaIsb+ZQNj+T+sTHQDJZykivLEiWblq1/1jZmrrQbeZXLXw/5z9KFqsgl9Jz5I8pHjUbSNK/BRg9A0s+T1scJ074MpDCxX08AdyubVOIqJKwU3zv5KXsAfbXIkk7LMCmLCuiEbc2MqCUVdFB+f4EMLhmL/iIeT8ZvI/x+cAPrtnAw4Nz8vmz0m2NQhYqGjFnt8ju8NT9um3UcaOq0fflOEwef9xBTjbz4pqYXyFC/76xrEsmLnfcJ38DgUkxqvLUDlZE4BX+PnIEMk7KBISaElS5UArzIsxZKn8z5eE17FoDSKY8ZCdiUlUh6RSFxL/oiI6glZ6YypGKXmkzqxjgrOSDNcHPohXEgWlnkBgZLnIBzp07LNcy/FMsh4uYsW16km8a23KJUIIcLUo8ZzWwxwdicCkRBJ0zluWjHs0eTkNTzF5hwTKfrFC73Mq8bTen927dL2XNEjrLcpz3Ud6cVVRARLDvguz5n3H3x3Xf/s8cQZ0rD9ZouZmTq6CKMSGnjfXJCRWHwk2o+YhvjFK57jwXMi3QyWV7yOBHMrG6FmXA/Ult4ST31dF3G+Y5cQY9lB0+6kPnERnvTLkJ0skjvyTxhsZdg+fVdTVDXnEEv4GxlfogmoAT8JDMLYcq5ZK0p44scDUD0G41/oA2hyWr5+D/SOdwBmmwoRNcCxt3yOcn9+iYdAqzCd0T7X8HYcUHisl0uoDcLImHLgaZ3vVvICr+CWZMOkOI7p9sNeOVbQteHnT6wT+Ju/127hBzj
 /PvTavdt
 c/1FIsxOXqhwwWuZ2GDA6P4emKnN8+vYgdiPp2XYe317/fp9zLK87ROhzk2SO0lSFEGuRVELkaxNG1Wflh7Ui/t7Jwqftt9X7EjGXwiNiQaiuOee5oCmPGJOi831YU8+UJq3r9hT2zK/nQaNbCDGqUjroQmFwE1JtqVSWAjjhpi5a8qv9YcRD78edKmkzS5pBF6CvSmvZY9ETL+juxFiANsLVzJ23tV77yZRoD/3+V9R5u5IujOe3+xDa/8AdLiOwN70OI+IuV3o6nqXpPHnrvc/1nUgw28eBBDGhQCgFJdvTfTQJ/unsB8H6z3OZlXQqH6mtDMShiZ0+V0v7xE0nFCZpWRP3fiT/X/61wJGya4ct+5iWuB6S9Y8bt8DPi5/rQTx8HVD5ZY943BeKLisfdcFUmXxicO93UIBwggzLk7nStRSMgxQykmY6R12euSFqc/5D0L2dMLCvC9guUANDEPlMt4nabsdp0xwYaisd4GCgcgpq65DL70XqsQ2H01VqM0naxAVJ32YRQpaf0zqeyCFVaEBENpv2iVoz7MrxWkSzJ/qUsxcakhcB0fNzFuh6qDj8JSqAIftA0j/Zl90Ri9NjF0KtMbDkzgqFpXcrrcMYR/3KcBNq0stbxTYT1I+sEGmC67vmnxW3NXuFENwQHu7B1ufvj8uFBFYQxZ3Hvd1hvIwn95LXuTrQVZdRK0VV1NlXkZWsrjF+rMQ/tIwOjbHDOL0fxOLc47V9SS49rXHbljsB6spTlN9W7JgjFtzxnjH7HmW1Aj9PHvjc4IbsM8UqbBu0BvYkboXW57VHMQLvvh8jKazom86yHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series builds on Christoph Hellwig's swap batching rework that
moves block swap onto struct swap_iocb and per-backend struct
swap_ops handlers [1].  Christoph's patches unify batching for
ordinary block devices and swap files.  zram still needs a custom
path because swap slots map to compressed pages, not disk sectors.

The first patch adds swap_register_block_ops() so a block driver can
install custom submit_read/submit_write handlers when swapon targets
its block device.  The default swap_bdev_ops path is unchanged for
devices that do not register.

The second patch registers zram_swap_ops at module init.  On write,
the swap core still batches folios into a swap_iocb.  zram maps each
folio to a slot index and stores it through zram_write_page() instead
of building one bio per page.  Read handling keeps slot_lock and
mark_slot_accessed() in one critical section.  Writeback-enabled zram
falls back to swap_bdev_submit_read() for ZRAM_WB slots.

The third patch moves slot_free_notify into swap_ops next to the
other zram swap callbacks, and documents the locking contract for
that hook.

Applied on top of Christoph Hellwig's "better block swap batching and
a different take on swap_ops" series [1].

[1] https://lore.kernel.org/linux-mm/?q=better+block+swap+batching

To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-doc@vger.kernel.org

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
Jianyue Wu (3):
      mm/page_io: let block drivers register custom swap I/O ops
      mm/zram: handle swap read/write via swap_ops
      mm/swap: route slot free notifications through swap_ops

 Documentation/filesystems/locking.rst |   5 -
 drivers/block/zram/zram_drv.c         | 215 +++++++++++++++++++++++++++-------
 include/linux/blkdev.h                |   2 -
 include/linux/swap.h                  |  47 ++++++++
 mm/page_io.c                          | 187 ++++++++++++++++++++++++++++-
 mm/swap.h                             |  18 +--
 mm/swapfile.c                         |  17 +--
 rust/kernel/block/mq/gen_disk.rs      |   1 -
 8 files changed, 414 insertions(+), 78 deletions(-)
---
base-commit: 842f51deada6449843f811bfa22e536a01ae5a0c
change-id: 20260614-zram-swap-ops-block-register-a1b2c3d4e5f6

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


