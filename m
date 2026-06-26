Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D476CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40D866B008A; Thu, 25 Jun 2026 21:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5716B0092; Thu, 25 Jun 2026 21:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD0D6B0093; Thu, 25 Jun 2026 21:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 025FD6B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:54:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FBEDA02CE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:50 +0000 (UTC)
X-FDA: 84920395140.25.C8B35CE
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 95FAC180006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ks1dWFwS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438888;
	b=ca0wjocKCL8y7x9nh08lTWhIUR7vYN+LnWWp1M27cpeGItA5rFnt9vV8PKSgQ2Cr/skStC
	YtMwywFw3JrG8TTbHG/nLowphR/OubD/w5U0SoGAKjDO4SmArL50wvl4hYo2z1HStPPi1S
	T2SdCd+I42EXkfG4fYeQ/ui9Vqzs9H8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CsVLAkg0GTe3mySosYexdwuiWNuNXRLwOOfIA7hMuwI=;
	b=ZHIhnNfw8gXeJhyrLqQo3H+GmOux6klaOPYSxG1ncpxEuxAKah/XDGb459402zmJm8yYyW
	JcdOQHwIUgj9jYXiCdRkqGa/B2kuh8iGKXujlXKChVZhhSH1M+8Jktp6sDx5B0gMrMSN1b
	pV5pDQfPt2QydWNfiTP+oZGrpSJjtgo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ks1dWFwS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c7f123b1acso6273685ad.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782438887; x=1783043687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CsVLAkg0GTe3mySosYexdwuiWNuNXRLwOOfIA7hMuwI=;
        b=ks1dWFwSmIv3vsyAVwUIv/4Er9+7v4femR40ITiyqqhFbg0vPhXLkE9/iIMgv9cF9w
         VmFkB/9/+IRxtiTZFwNL47yTN0g1kgsEJ3Y3Xb7SVMAdsuc7FsMpACw6tWR72DDNzT/y
         /Tw0vNBI5Pri6zXSdjNELGsiqaxEQAp/afr3wlgpqKN+ZrqaJ2vvNuAFgDqsHXj3x2tG
         hKPB4C3lxYnY5du7Zn2qopBsoxgTFS4j8y1PlUzxavFWgSZ05wddVUM9b8Ya+FxzukIr
         A9UxAC5ClPZHSMyeIRPe/qlB6sMKnI5u2uzRh86AOY5Ibx1Nsnnde21Rr21LmKHI8l0n
         v6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782438887; x=1783043687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CsVLAkg0GTe3mySosYexdwuiWNuNXRLwOOfIA7hMuwI=;
        b=Vd6ZYLrEzAdDGk+0ChYeeQr3++un0dQd25/tqwwCXXXs/iAgJcC6t9EcBJi0zWPJSP
         /Qw3d4IhgA/JezZJ0UPB98epTxa/s/FISEsQDhbMO7/80K2MMcVOQBbGMBZi27LOwf4l
         tYtmdLE9aECZF6lSGzBXRxZ+v1gISGGfiGJp4ur6a4j4SYKsdPjGPGiTMfRkAIkEmYED
         PCL6uZg0po2FTW5CxLKRHtrnWLfVXrGWieq5XegVKUueImMbeOLqLrONhxnukWWeZYWa
         Jc1gdfCiZRg/2SNRRsJ5pS9/vIF2lWV/kqfxg37TWccxMCozCXRlYnss+zyB+zlhXaEW
         Ee1w==
X-Forwarded-Encrypted: i=1; AHgh+RqbMyUL/O5N5SHt2UEaJVFsTrAYY1b3LDgIFIEx9H3gdBWUFVmMJ0lddr7Pg5djQo8tqDS26sykmA==@kvack.org
X-Gm-Message-State: AOJu0YzbJR0evegGFkLcEZ2UoF2EFiBSjpE0FQaZ42n1N+UQyrMvRa43
	2xa2QCM48K67J7P39fj5EwV/snwPaqtspxdmM7uo/oBBWSEeNoF3qXGZ
X-Gm-Gg: AfdE7cm76n55r8gGMpiE1m4uFsmnB8DVuiSxO8T8Dd9inn4x2OByZLJcjpW1dZJEFsA
	znarO1cAFkdqTWk+QQTMts7RVLd4jsZ5KGTEI404ec89ysC0PxqZRGkG2kZrDHIAs4Obd96fo6f
	on+IkSzIihG6SkkKfSCiN8QygsxNO94V94zBcMhMiNrUyhT/INVkWQb6EaoMP0OEGxHV84i/ECn
	JXZHRPrq619tDlHTmknsE7H32lG+5eUd65G4QFjgdE9DZ3FCnNg6r3s1eYAwba0q99dfD25zd5m
	8lrjISlEZMzkGKZO6JTFZy2mC//vk9gCkNf8vDy27KJ1qDSlekuOm1vOiF0Y5yuT4axRntiGgul
	75OHMeHyQ/w0OTH/dH7f/HCmS+KQQtz13IxUsz6YBf3x/KvXQ3UNN3eUrfAGnbRt1Dnag2sGYFn
	mtnAwdMV0LnUigv9d+yG5GOwxD3eNQ
X-Received: by 2002:a17:903:1666:b0:2bd:5ab:af95 with SMTP id d9443c01a7336-2c7fc36e61cmr46992765ad.0.1782438887399;
        Thu, 25 Jun 2026 18:54:47 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63b2bd7sm29047005ad.48.2026.06.25.18.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 18:54:46 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v6 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Date: Fri, 26 Jun 2026 09:49:59 +0800
Message-Id: <20260626015003.2965881-1-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95FAC180006
X-Stat-Signature: z77n7tfe64xht17ik3bqi7r8z953h5rb
X-HE-Tag: 1782438888-982768
X-HE-Meta: U2FsdGVkX1+Vcoibqam6M7QR4iVKR2VB7N61uR86bzxFy0ktf4xmh4KKlhLmy76Ul/2PRxU57CF6r8gCqs+Se76Ibl+kwE6Dcklayi4GwtifyxhUGFNrOarOxKZaJfXq28BLGgS3HzrR4x13zju2tNlYg+IWR8I0yTZ42XcFYj6O3aqDZyrDpgvJ1DWojd9Qh9JJpSTAUsHg6lw3XaqYORxifpfJ45YJ3L6xpU9OemdShVQk+iwabrpARvfYy9cVHZiAFGHg81v+q9zNVBfgWmDgpFx3R3nGWa8lN3gGN5bw9/5YwZzzmQF6XxOPLGRRrQ+TpSDB4BHDLWpF5/5Iu5uyuEzwbVEmoGAEDm8s3KqMoq+MwMuRCrnng+KJg5s9P5Tqtjwd0Ji7KPI253bw34Xu8oTvpR9Q4PRh36XP53VmfSpcskipBhf47Kxh00X7Zsh9EDySbi8mqv57L4/0qX8XyfR/wNG7lNNhnFKNQ4a43H06vSMnMDpVTT7h4J63NVHankEtFZWSsGA9lzWDh6Yb/8+tLSru75W6/yEXSXQl9V9ADz1nG+vrUC2nJ8xfZLa0wZK9zBG7iOTNSCohY+h4VSxHvgivQut21Z3tdHnKr5g9iaxB6mgkQxGrb6Pg0WtrJ4PCG2VGFDz24e9AC92vstp1sSKzItBpjRrKMzhAbOFneOfgQkYsHlWSqHz1dtb02H5JIdp3WsP/aspcYDvLo0zNPRbjyhueY4HmH9U/Ofmr/XM5MTK7bG8xTZd4OvalNjkdBYBfYwjzg0VZMTgM81qaUxp3I+KLQ7IFKLIhGpHgNxdPobxpmfWUi5osFNjRFUAPfT9ekMv5hhBgtezAQ5m5zrx2CwN0QOpdx4UopEzXJxdUHJkmj46FFExmWEuw+2c8vaxTzmbQKqhLLKlNurIx2/fOIS6fqHyFPKb359NErtKQVtD627xRB4nO82nDV6rdneboPocXLor
 /CKCjR9Q
 VuIjTSeMiu6v8EmxQDOj8ABoGVzXS9GNtsF4PkZCCW/imU98qpbN8/ikIfRTCdF6iVsFhQp/Dhg0UzG1kw71rSq0TzNxjGiLvUltAdwyTi3o9cAGB0/I5aXqCbj88orskwdVDmXf+YZ4OH25vD7nJ1Lk0T3TkhHbSiaw0pueqX+WPoHRC8UmuAyAWrbkA5SPMVqT5kxvEf3znUoJQHK+K38+wr6NXyx94KjEdKulCDtSunjX3DHJrTqC+rwcMIHvRa/ARZkZ7b+HwTmlGN5wSZ2BE5qNs+nhIDQMGAcP8roFHey6r2jOK4WDBP1GwFlFyMxiGntLuUrx1FqJglthpLnc0NSFjaIkDQyK+GuHTkX8QYDAgSxzxK05NmQW/+9Tf/JMmF6AVGAhJVRzG92LVTuywKLR/bBaU7JhJr206IEqNxU0Ef8ruYDHPEeTCpQnv4KD2ypSDxdEhLxDr1N+9IOd3BkbQOV1EV+VsA2QElEYqt0z7NfUDw1naYfUZTUpjBcNJEM+Sv0Gi3DFCaw2Q734KwgrIaGhUTRJj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

This series reduces lock contention in zs_free(), which dominates the
unmap path under memory pressure on Android (LMK kills) and on x86
servers running zswap-heavy workloads.

The current zs_free() takes pool->lock (rwlock, read side) just to
look up the size_class for a handle, then takes class->lock and holds
it across __free_zspage() which can call into the buddy allocator and
acquire zone->lock.  Two costs follow:

  * pool->lock reader-counter cacheline bouncing among concurrent
    zs_free() callers.
  * class->lock held across folio_put(), so any zone->lock wait
    fans out to every other zs_free() on the same class.

The series tackles both:

  Patch 1: encode size_class index into obj alongside PFN and obj_idx,
           so zs_free() can locate the class without pool->lock.
  Patch 2: drop pool->lock from zs_free() on 64-bit; 32-bit unchanged.
  Patch 3: move zspage page-freeing out of class->lock.
  Patch 4: document the three free_zspage helper variants that result
           from the split in patch 3.

Performance results:

Test: each process independently mmap 256MB, write data, madvise
MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.

Raspberry Pi 4B (4-core ARM64 Cortex-A72):

  mode        Base       Patched     Speedup
  single      59.0ms     56.0ms      1.05x
  multi 2p    94.6ms     66.7ms      1.42x
  multi 4p    202.9ms    110.6ms     1.83x

x86 (20-core Intel i7-12700, 16 concurrent processes):

  mode        Base       Patched     Speedup
  single      11.7ms     9.8ms       1.19x
  multi 2p    24.1ms     17.2ms      1.40x
  multi 4p    63.0ms     45.3ms      1.39x

[1] https://lore.kernel.org/linux-mm/20260508061910.3882831-1-haowenchao@xiaomi.com/
[2] https://lore.kernel.org/linux-mm/20260527115930.3138213-1-haowenchao@xiaomi.com/
[3] https://lore.kernel.org/linux-mm/20260605084242.1549811-1-haowenchao22@gmail.com/
[4] https://lore.kernel.org/linux-mm/20260609113520.3507783-1-haowenchao22@gmail.com/
[5] https://lore.kernel.org/all/20260616031309.3036234-1-haowenchao22@gmail.com/

Changes since v5:
- 2/4: rename obj_handle_class_lock() to obj_class_get_and_lock().
- Pick up Reviewed-by from Barry Song on 2/4, 3/4, 4/4.

Changes since v4:
- 1/4: rename macros to make their intent clearer, following the
  kernel's *_BITS convention (Nhat Pham, Barry Song).
- 3/4: drop the unused pool argument from __free_zspage_lockless().

Changes since v3:
- 1/4: gate ZS_OBJ_CLASS_BITS on a new spare-bit check so unsuitable
  configs (e.g. UML, no sparsemem) fall back to plain obj layout
  instead of breaking the build.  (sashiko AI review)
- 2/4: annotate handle_to_obj()/record_obj() with READ_ONCE/WRITE_ONCE
  to silence KCSAN; sync the #if predicate with patch 1.  (sashiko AI review)
- 4/4: clarify when async_free_zspage() runs; pick up Reviewed-by.  (Nhat Pham)
- Drop Reviewed-by from Nhat Pham on 1/4 and 2/4: substantial logic
  changes since v3, please re-review.

Changes since v2:
- 3/4: drop likely() hint and tidy up else-branch braces, per review
  nits from Nhat Pham and Joshua Hahn.
- 4/4 (new): document free_zspage helper variants in a single comment
  block, per Nhat Pham.
- Pick up Reviewed-by tags from Nhat Pham (1/4, 2/4, 3/4) and
  Joshua Hahn (3/4).
- Fix patch 1/4 and 2/4 From: to match Signed-off-by, per Barry Song.

Changes since v1:
- Rename obj-encoding macros for clarity.
- Make 32-bit / 64-bit handling transparent at call sites
  (no #ifdef in callers).
- Extract a helper to keep zs_free() unified.

Wenchao Hao (3):
  mm/zsmalloc: encode class index in obj value for lockless class lookup
  mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
  mm/zsmalloc: document free_zspage helper variants

Xueyuan Chen (1):
  mm/zsmalloc: drop class lock before freeing zspage

 mm/zsmalloc.c | 225 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 190 insertions(+), 35 deletions(-)

--
2.34.1

