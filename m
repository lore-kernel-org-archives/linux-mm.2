Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B78CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 04:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05D76B008A; Thu, 28 May 2026 00:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6D56B008C; Thu, 28 May 2026 00:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC686B0092; Thu, 28 May 2026 00:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC81C6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:41:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EE6F91BF6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:41:21 +0000 (UTC)
X-FDA: 84815579562.05.34D9FCE
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2F95114000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:41:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qTZTcxfB;
	spf=pass (imf23.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779943279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=du8cY++I/mag/xwhX2GLm0MJj99dlckXgLQrAUks2z0=;
	b=X7oXVj9RMOenpdwT861vjrHhOa/m2+4yt1zgExhH+tEW6D5irwqpw9tiKR2o5ylOT4fkqa
	B9wExMiER/EjR7IdkNWOn5Y9eb7FIXVHKe92cRGhG20waYSvMfiVJ0N0xJfqbKuOjzaIMQ
	P9jR2p3Kmuey+INZFUJeInUifOCbXFY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qTZTcxfB;
	spf=pass (imf23.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779943279; a=rsa-sha256;
	cv=none;
	b=QAAjXvwQN9gyafcqGLfxn3djl+irukhsBpFTISnrdNnbUzGzkfeuu+0Y509vYvzSQ5t//n
	eVGorHSnEPNjuhHG+f5jVIZdyQnEwc9JRSKO7nlXmuXB/CrGGrPfbEFapGf/pdhN0tSrMZ
	NPL2nt6qcqLwmfjTA8Jm45F5UobRHD8=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82f9fdfc965so5656711b3a.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 21:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779943278; x=1780548078; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=du8cY++I/mag/xwhX2GLm0MJj99dlckXgLQrAUks2z0=;
        b=qTZTcxfB2Bsiy5lAcsyr+8rphuBGyzESyhv8lCGPwhW7JVoTkjC/QwtZWuL/LGur+2
         nsB+ZMOOkdVWSHKQ9sx1fqZ6+uSNDL8VK0Gc7lN9kXbjRB8dKW8iyvuitmW5etfUjDcd
         jDQsP7VtJGEokCrC5kgq4hiJKMtti37O9jLK1xvcuy0UfOo+/6MYxiR5TjfWN5r49NCx
         dq0Q7Yyo9oOm/Xyskwl6wp/y1OyhTRla1YPFJZStkjW/TiAcokL/vI8+dLOr5ifu4w1W
         V4Cx/iwnJM4bmcbJUjfdPQ4K3JG8omMAturbJ+sqHtSa2rUCQEneqA4QRapWDf4W60bU
         vVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779943278; x=1780548078;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=du8cY++I/mag/xwhX2GLm0MJj99dlckXgLQrAUks2z0=;
        b=S/8CQXjlzM/tnguKCU24ROgRr9OHpLiKBr7nILWVcDrSRMwC9dnbjR8nAXQY0sCJ/a
         j+E3XBbeKpn72wkbF1dgWxxHa0Dfp0z2frZJRi4emXutWQsMZ9MZxHnq9/jqb4D3nizG
         3efJ8DAwUlbIQG4xBf+5xWSxAZ29oRhc3ODyHoflA3e+aIErvRmXR3G321xMGNXiN0LI
         s6bpeVqzauasi/O/N4vf/tKXSSoYrk0xlrsVtEcXkWCZ0PzWwwJMyDIVh9q/selLj+1G
         gbpvsZ0DnH+6Gt7sOJDiNRNgK3DgefrByQ6ee4UOppp7CQKvOFGjoSRpfW3u6bY9zcoF
         Boaw==
X-Forwarded-Encrypted: i=1; AFNElJ9+fHolweak5Eahel2/0lvsNasfGORooHdBmWBUR1QdODVYNFkdtzQWc353EOZmlCJ+7qzUpOdmyQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7EyELsepAGFgFxj2F+bHxZXK48fkmWvp3TkquMw54MifMYXJd
	3k/KvYCXdlQbjQrOrkdOT5+BzgUtERCvr3UcJVVNMUiO4VJOog7Gjipl
X-Gm-Gg: Acq92OHp1BlrmWrNHKrXxLHqQwATp9tAZVTzJyA1GEpGiSyaZxYgRf3AuXRoJsEyf8R
	uBWP/cutA6FE/SbpMolYlairA3C34xdt9XWpXPsXrX6yRHBG/Vkq5s8H7eKs66aBzs3HRioDcIr
	54vz8MVowqeY5jIAJPe7Vg1wPzRMKP/DmA0uOarlCirq9AuikyGSt+Ii9CQdVCtSs4OcQzeMPio
	cX4rX+dN0MjxGhkdKNfWg1QFjnJwCrZpbtp5NLOp8/X5i+KUbeVLvQQ86SAspoH6FfLLOaVLEvS
	FC7nOgYZbbnq0LmSVZ2EFwt5grf7Dhppnr+zOYQzcP0UZMUNpxY2ZYYqqO4CAYM3HpK5T1SwvGu
	qAx6tS1mPAOJWhi87ks/hJ3I+EJrbQK1a7wfHa1VZffshctOwewgG/JbULT4TYNK99HEUYnOk4Z
	LtWQDGzXMhC8VLC0DtTPPAERfwr1fL/uQNxEfMoXChsACy73Q=
X-Received: by 2002:a05:6a00:1c9e:b0:823:9b7:9c0e with SMTP id d2e1a72fcca58-8415f35c689mr23241583b3a.34.1779943277978;
        Wed, 27 May 2026 21:41:17 -0700 (PDT)
Received: from localhost.localdomain ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841f3cbcddbsm586596b3a.4.2026.05.27.21.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 21:41:17 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yisheng Xie <xieyisheng1@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 0/2] zram: fix UAF in zram_bvec_write_partial() and drop dead bio plumbing
Date: Thu, 28 May 2026 12:41:11 +0800
Message-Id: <ahfHZs0j2Zzpp/aq@debian>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260528-zram-v3-0-cab86eef8764@gmail.com>
References: <20260528-zram-v3-0-cab86eef8764@gmail.com>
Mail-Followup-To: Cunlong Li <shenxiaogll@gmail.com>, Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Yisheng Xie <xieyisheng1@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: yf577r36we3qhfakepfnpwujmktss6tc
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F95114000D
X-HE-Tag: 1779943279-846769
X-HE-Meta: U2FsdGVkX1+61gBsIhHLxS+BfSxm8+H/cJB1wiWAN9fIDBPa8XHhsWB4BHKS4BSPO1o1QkixolQFYxoZnheYY1gpkWLNUdFVdKqWcXA4vKGwJVfh24yNzT2KXrc1uu3rO7E41A9aRmz7Vaw9MkufKA3nvDij6GTSk9xojYIXJy6r+GTNDblpZOY2RVBqLU+zYE1Y+Sfh3i8HHeSn0ANlHP6v/CiXvhjaVFQeqge3QGV2P1wSqD+izDqgFP1TJZw5rtaCLoQSY5Uv98qXYlpr3s/WpZVa5r2SPLvbjuRa5pQcYXZ2a2wqB6uOkSxPLvFXnXCIaQPfuRyQai++ZD5a37jL3tVJL4vbtkQKtRHqgAPs+1ZvvuSlRYtJ5jAXrimTrO/vM7Ziivnz5+ZQYyMdI0vnMKlgmkyIxOToRC6tba/fXQ0q7odQXQKHpahOqeSOH8kwXsCyUv1Y5h+rXWKLkY1VUyhGXtIdsyt/XtVKFLWPsIBl0GZY+WmrpcIwx3XyecbLwgLbemu2isxXRlg/laWg63NO4KlEm3/KOg6p4/6CATVuMZzJvpRjnv1KQVihd0cmvHNFXgkoSWI1URbJFALMcOz8Gq2o15XY5XASMstL5kncDXyR1kZseVSs6kcaLOKS9fg0JCieJgVyoQ/kU/By7lk6tpd0/jHqcWGvMNPk7F52Xim5rLHR3MVsOxtEv2CnRUUglrugTIVTDpwDKhAqU3RBWP8vfTgbFLVkz+cOXjnGEimpsNLomPx82j/FggqiOPPTK1T8dU3iWEsFaro1+aJCOuLET6xpNn+WuhmRPCO17bAz5cVEzLb2+E9yLBEEaAFG0Nr9AB4CAKLMKSZNf5WEDiMiS/xCFB1Y+8ZkgvdIEIp+bix4dPAaAH/6VgCc5omvRZM0sA5N7J6Va7K/RMeM7QzzxNhCmT7fdM6Wchhom+OQ3skzgvhfCTEg1lO517YHvXLPvKLrxsE
 NKZQeV4Z
 25oXoUSe95Bf/G2YkNrCbbeOiB8QYzzXOM5bHiLHZGdmxMHF2SZMqD//z/oFI5DiB1xYgcpil+Won3uT/7uJm5yDOLFrMlu/3YxRgnfRFuetC2KMfb8iMholVEyGa8UhOdjPcMA+OzkbT236hh8HD4kFEKzjApYOtHsG+orMpByXUofY7oVFumxrb96jd23edIGOSuUmdTjYhgM+G0qZt7xfqp+jd4GoaCUdHfSz75Oe/N2BUyczFoLzKUGcV6n3h8QV3sHFBUXUpXYJPq7Gb/fa/dhfuzs5vYRES+SAKwKwivL021dYkEGKkY+vQGGIXkWu++yKr6gjo0nfnmxF7e3pW5Bb9PVAX9RWxwdSP1lhT32ZdeT+VeWnOQv5gKX1rXOhN7Afnw1+AYcOR88CfWPTBp6+cLFj0MVRS7sY36C2NMp7dDxr9YikCRuk9LrubydOUfFidCIac8aZdE7ILDffxXOecVN6i09c8PiBxFVrJHbgKS73dnKNEDHFqUE8T5CM/ywTJdzDIThnj6hvjLMJwDXUF2Cs3oizIAM8UzGlPo1MRHAaosbqfQLzeHJrqSuGZGeDhxpc4ep5Ift2KZe+2b4av+T0gN3eklyAAdgjnnw2D3u1c3lAxmw8bjKdGfIeiarhA15Ll20lNOx/IBA3RF43v2oUAQoK7InywJwc8yg9wGiK3jIeWG3DT43+XADwA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 10:48:43AM +0800, Cunlong Li wrote:
> Patch 1 fixes a use-after-free in zram_bvec_write_partial() that
> happens on PAGE_SIZE > 4K configurations when a partial write hits a
> ZRAM_WB slot.
> 
> Patch 2 is a follow-up cleanup that drops the now-unused bio parameter
> from zram_bvec_write_partial() and zram_bvec_write(), no functional
> change.
> 
> Patch 1 is tagged for stable; patch 2 is not.
> 
> Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
> ---
> Changes in v3:
> - Update Fixes: tag to 8e654f8fbff5 ("zram: read page from backing
>   device") per Christoph.
> - Link to v2: https://lore.kernel.org/r/20260527-zram-v2-0-2fb84b054b5c@gmail.com
> 
> Changes in v2:
> - Add patch 2: drop the now-unused bio parameter from
>   zram_bvec_write_partial() and zram_bvec_write(), per Sergey's
>   suggestion on v1.
> - Link to v1: https://lore.kernel.org/r/20260527-zram-v1-1-ce1acb2bfaf9@gmail.com
> 
> ---
> Cunlong Li (2):
>       zram: fix use-after-free in zram_bvec_write_partial()
>       zram: drop unused bio parameter from write helpers
> 
>  drivers/block/zram/zram_drv.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> ---
> base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
> change-id: 20260526-zram-b01425b7e6c6
> 
> Best regards,
> -- 
> Cunlong Li <shenxiaogll@gmail.com>
> 

Test results for reference:

Tested on arm64 16K-page QEMU (Apple M4, HVF) with KASAN enabled,
kernel v7.1-rc5 (base-commit e8c2f9fdadee).  zram0 backed by a loop
file on ext4, fio bs=4k randrw (4 jobs, 120s) against ext4-on-zram0
with a parallel loop triggering idle writeback.

Without the fix, KASAN fires within seconds:

  BUG: KASAN: use-after-free in copy_folio_from_iter_atomic+0x830/0x18e8
  Read of size 16384 at addr ffff8000d1168000 by task kworker/u16:4/321

  Workqueue: loop0 loop_rootcg_workfn
  Call trace:
   memcpy+0x3c/0x9c
   copy_folio_from_iter_atomic+0x830/0x18e8
   generic_perform_write+0x308/0x558
   ext4_buffered_write_iter+0x140/0x438
   ext4_file_write_iter+0x868/0x1004
   lo_rw_aio.isra.0+0x838/0xc94
   loop_process_work+0x2f8/0xdf0
   loop_rootcg_workfn+0x20/0x2c
   process_one_work+0x560/0xc10

  page: refcount:0 mapcount:0

The async backing-device read bio still references the page after
zram_bvec_write_partial() freed it; the loop worker then writes
into freed memory.

With the series applied, the same workload runs clean for two
minutes with no KASAN reports.


