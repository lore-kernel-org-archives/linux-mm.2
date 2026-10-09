Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE983CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C576B008A; Fri,  9 Oct 2026 03:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451F66B0093; Fri,  9 Oct 2026 03:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BD36B0095; Fri,  9 Oct 2026 03:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E85396B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66D288028D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:11 +0000 (UTC)
X-FDA: 85302218862.28.3413168
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id A43E21C0006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hlFi+xED;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529929;
	b=vB/7oTK0rbUXDRFMVRkNfMINi4hzwkPu893pXV29nbODHkOtyQNv7E0TTlLRBVgIeYVkoe
	hdGa2yc/NhkS6N9x9GFE12RU5Kovntj8v85QLsFkykSX8yZwS+zj/ghImypzFGNh4TG2fT
	rm5d3gQfUMwsRHWNKQXeF9vECMLTvZY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hlFi+xED;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aptDd8Np6uwn+I29ocduigmysLweAOQhXRAknslhT0Y=;
	b=DKCRIblxyG9PAznypMnadXtSKfV8wKYAnE9JhFxaZcM7dGZrOcGUiQEWJ6IPqLr13gl3zt
	eVpvCH56owj2zQ1Qpbd0gYaNALceTqLfSRUHP8sud+rYVfQxTiB1ONy0BpeYXywX2VUPCu
	cvZ4kb+ui9/rrVNLljkVgPWFGR/SpLk=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e61f017091so12940265ad.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529928; x=1792134728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aptDd8Np6uwn+I29ocduigmysLweAOQhXRAknslhT0Y=;
        b=hlFi+xEDx6UezYiy23W1lRC2UTXINdzkISJG9F7l4MXBoj9Q2i7AdauvleQs10mjr6
         jd8jzzMT+Loft31LuH+MlB63JF9QFGPJZ/QCiKMfis4DhXjQiBbv6MKcO59VGgkp9a94
         ojjhkqWOvuWp0wKktld0U3Xr3vHJynt8HFNq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529928; x=1792134728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aptDd8Np6uwn+I29ocduigmysLweAOQhXRAknslhT0Y=;
        b=DhUAc01fzo/3O0QixqvA8jKCyWZa6tNpk588JEXzD+/geE8O+5mVLAow/oNFEROmhp
         nxHSdkeMZoP1wR1I20UdwahaTDp3V/8USppo36pj3UJFZVsFqIl2j1ECZufdnrSgul7j
         lEv5IkkHxEOhuaDiTGRvNJUt/5J5uCjbUc+3RkUaudaF//n/RPJ+BdEzLi3F2gSMGYeT
         YnBj4JchV4okilxngNnPQVcQmhUz6/GpSw6Jg5MJRUqrHWFAQ5IRX2xMfOB8o2h54evS
         WPvcnVm1NFyDd8FnYEHwi5esby2u0yIpJkQyM5A4xQ/9b+A9eRrEioO+ZccMwnK1q35f
         c89w==
X-Forwarded-Encrypted: i=1; AKwUvByceFazWz4B1p6Wuwf8PHzeZlkX20/6slAtWhgaCxrzNMP7e8ZeNt+S4cED37sLp7ymw9nGao39rg==@kvack.org
X-Gm-Message-State: AFq9FYLkigXaTf1GfSvPI0M4zSPPvvJdiRVhJJVhSVcaj49shsazM/Jf
	lCuPJlmUmaCqaVx7FLAi9WI1SmzlXUHi2XEAQ5Ui3okE3MBPaoZT7cBOMKngWA/sJQ==
X-Gm-Gg: AYBFou0bW0CEMlYKOwBhS/b2HOS8kyuyHaNvdQFKbgD8U2oMQYSMZM7jaTj7GvZhiEF
	BfjA2CiAVsHgnxf5ihXfW4z6yeFZxds3GkBUXhdGIg/FQ8pndh75e8DDGq6xg/Csrai/INXykeC
	2P+qxgFjyMb37cbdI5lBbGp51q+V8C0OY//GVcyppPI203Fev6oZKPv5qrVh44JYRNmxtYlsGOu
	D8OAnL0fBj5YRpDTc1nkgsKwcMMk4N1xnmlIF/4aZnbByr/v/3kAdBkV7VwKmkmLpjlJG9sWOjp
	9GC9DdTsPDBdREh8SaheLyXnrQn6GdFRMVhLcVwCIO1dO0JakufgOmtaguOVgE9TYNxRxckE2cL
	1cVE1/mueOoG6tfWccu5M7VevNpHSgUlMXjUlaLR60WmvWobv+zzsmWhQ54XslqNvbw4odsmEPI
	lHw/jtDD8S9dvSuboEBRzo94xHQjP8mtSw7IMDoYkEWP0yTRQuJ4cumEIcP+qZWtLehUhl+LvGh
	GQ/9v9TcYqDcE1NpX8T9ASoDPyQm70ub1pCATyzUiqy1KHIROSWMLnHyK/O9rY=
X-Received: by 2002:a17:902:f54f:b0:2dd:c100:b2c3 with SMTP id d9443c01a7336-2e842ce0ad9mr8639605ad.46.1791529928470;
        Fri, 09 Oct 2026 00:12:08 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:07 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 00/11] zram: redesign zcomp and rework backends
Date: Fri,  9 Oct 2026 16:11:23 +0900
Message-ID: <20261009071157.3730698-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A43E21C0006
X-Rspam-User: 
X-Stat-Signature: hxzybuap8kwkbwyycipp6ehnjr1akngf
X-HE-Tag: 1791529929-688930
X-HE-Meta: U2FsdGVkX1/vT+3smp0XWMZmA5LrWoemaQslxDHG8h+a+OqaXPd7H+krh3yFNrxybcyjfp9nKo1XWGMsR1g0k+fvBTZkmuBeVscAJdGL+M/KlbdCRQT8K4mMrYXlyH7CFK/6l2//wdSdspUDwBjAdtuSDmeuh1FgTMOIlBbwzro36Di660/gAXW5Tao2JoYHQh6lNWdaHCh9vQ486OUHuBEHs8Fcuv6OYp6Mm36oX5h76gejQ5GSLmnLP9Kyrfj4ceLULLkn7xwNCWKLQIQKk8AemiZYhwOo4Jn4jA3EqNHy8f9bhiVkZi/fSppghHKITVhzLr+0LuWpDLg/dI97j545NswMaPaCFY+58Kar2VAYpxf6TcHwJb7rtoJlUfA3B9lvNtCKcOycH2us2Ol2p6WJTDYrd7SB4ObkeVdSMaCFDk+XYfA5vcmmLSS/HCg6T3MIUeHza5fhygiVndc7SQCKZWPNQpnRsZJsF7E9VTzv1lpa3yNMrLF2uGgTGsn/sN8H43EHAmnSms0uEYdpZ+PwtnnS2+qt/gyOxThECEx8wM9Fay3FylikCaG8aQuYgMijHIknjp2xSx9Z7Bil+FHdAJ2MFf6VRhUHYbnOTIMyTCqGWA0Merqbw1shI5kwGb0+plSGaVFUgS1B6MS15gLVSr6y/kXPKAMGwXx6BUgGqvY20OoaP8QSvPLQxGKgMh0vkkRZqRhR2OnD4a3dNdX/d+wQPXf7mHi8CJKzRF8Zst/TdHClpKr2rIwR9dPmEclXT0KBIXsHZLRBTkZSHg6k//kqDNwaYEBiMq7mjrt5dWR4iKZnLmutm4oo4rLKn1rcFmI/r+pPelMS4tOJeFeutoNpz0umJ45swizRRB0k7nDIAg5JRCxlFoVNzogTQj0ue0zkYLZEqS+nJgF2we0ASZLU32hxGgxkqcwJrDvLrWuUIDPBul2LQMRm4TyzyTR5aIYxthoMG6m5A1d
 6txenJUz
 Cs8EdWkjskxSwMvsFM4VL4OAWXqMklhuxtC/LhVq05VkWclxM/2e8T6Y2HEaafJRXZ9+N5g+StcSDLBZT1dE2hilsbeQPrwZ7oB5uhIk+cxiEOc03qDRsnFJAS6lKGeqfgFLF/XBmbu+SuYmucGyAIxlKtC3mVJc3jXaCfNUaCTTDqWtgiBcOA6QDqxDXbN3wVmzVF49Px6NiOzTJ1ymR7gMbTrF7IK3eWcPj79gvD+k6sEGF1WlUCwNKcOhPUE26i6nmPvu6rXsQ52AqM87ory+Eduw80gKKnAkxH8h4KZ6g5a73B/L9GDIAcNGdYkp8kq4N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series has a number of memory usage optimisations and fixes
that result in savings from double digits KB to triple digits
KB per-context/per-CPU, depending on backend and its configuration.
More details are in the corresponding commit messages.

The zcomp redesign and backend rework happen in the final three
patches.  zcomp part, basically, attempts to address the priority
inversion problem, that is seen on some setups.  In zcomp, we have
always kept Read and Write contexts together in per-CPU streams.
With preemptible zram this becomes a bit of a problem, as a higher
priority Reader can preempt a Writer, which may hold a stream
lock, but since the compression stream is locked by the preempted
Writer, the Reader gets blocked on the very same stream lock.
However, we don't have any reasons to have Read and Write contexts
share and compete for the stream, because Read (decompression) and
Write (compression) paths are completely independent, they never
touch each other's buffers.  Thus, we can split compression streams
into per-CPU Read streams and per-CPU Write streams, so that Readers
and Writers don't block each other anymore.  Kudos to Barry Song
for the idea.  Decoupling Reads and Writes results in noticeable
performance improvements on synthetic tests.

"use a singleton compression context for recompression" patch
builds atop of decoupled Read and Write streams and reworks the
way secondary streams are handled.  Secondary compression streams
are only used from recompression, which is serialized by device
lock, IOW it's single-threaded.  However, we still allocated
secondary streams per-CPU (we needed to permit concurrent Reads
of recompressed objects).  Because we now have dedicated R/W
streams, we can allocate a singleton compression context (for
recompression) yet still have per-CPU decompression contexts.
This saves a notable amount of memory with some backends and
configurations (e.g. zstd, deflate, lz4hc).

The final patch in the series pushes performance gains even
further by switching to rw-semaphores for Read streams.  This
allows multiple Readers to concurrently decompress objects (with
some caveats).

v1 -> v2:
-- Switched to rw-sem for Read streams (Brian)

Sergey Senozhatsky (11):
  zram: prefix backends printk-s
  zram: remove debugfs entry on init failure
  zram: zstd: do not allocate empty C/D-dictionaries
  zram: lz4hc: pre-initialize dictionary stream in setup_params
  zram: lz4: use LZ4_decompress_safe_usingDict()
  zram: lz4hc: use LZ4_decompress_safe_usingDict()
  zram: zstd: do not use kvzalloc() for zstd allocations
  zram: reset writeback state in zram_reset_device()
  zram: split zcomp into separate R/W streams
  zram: use a singleton compression context for recompression
  zram: use rw_semaphore for decompression streams

 drivers/block/zram/backend_842.c     |   6 +-
 drivers/block/zram/backend_deflate.c |  98 ++++++++-----
 drivers/block/zram/backend_lz4.c     |  85 +++--------
 drivers/block/zram/backend_lz4hc.c   | 105 +++++--------
 drivers/block/zram/backend_lzo.c     |   6 +-
 drivers/block/zram/backend_lzorle.c  |   6 +-
 drivers/block/zram/backend_zstd.c    | 133 +++++++++++------
 drivers/block/zram/zcomp.c           | 212 ++++++++++++++++++++++-----
 drivers/block/zram/zcomp.h           |  43 ++++--
 drivers/block/zram/zram_drv.c        |  55 ++++---
 10 files changed, 456 insertions(+), 293 deletions(-)

--
2.56.0.385.gd3acb90ef8-goog


