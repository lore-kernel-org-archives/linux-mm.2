Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A7C606A339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=GaDxO8R9
Received: by kanga.kvack.org (Postfix)
	id 4EE386B05B4; Wed,  4 Nov 2026 23:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E746B05B5; Wed,  4 Nov 2026 23:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5476B05B6; Wed,  4 Nov 2026 23:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 030D26B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D91DC804E7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:02 +0000 (UTC)
X-FDA: 85399833204.30.D4C2ACD
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 223A81C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GaDxO8R9;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854081;
	b=eSk8GUsHKSp+D4ZhKTUEuWqF+IYlSHIIo4v6VU9dDYi6zafjpyEI/Rncow/1LG/2ptPSN4
	8HqmY0lDNE6FVmNiOzqc5YVMCyMSVG6gYlOTrr+Q9TnEEya5VloSmR9VLWh02SbGMYD2jX
	vDdhhQF1iz8oANnHNR3DJDIb4fFmwCs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GaDxO8R9;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lZ/laB7EjjzlJibu0SL3xlybjiUy40ADVZ8qce7qfBM=;
	b=zCby7afY2b+pV+Bjflr8t0yu6Qsll4Znr6ycLxeCHboiFGsYIw8LT+P/q+djwpuYckbOsu
	fa9l3bbQflCLPw0pg5+qsy8X+jmr4Fw89ySH0YUaMAmpUrpcWkT27iG7tA8PDpEzAP2BbF
	Bg9Shz/6tlBHzWXBQOwWMPJi20s5rCc=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b244fb7fffso2014615c88.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854080; x=1794458880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lZ/laB7EjjzlJibu0SL3xlybjiUy40ADVZ8qce7qfBM=;
        b=GaDxO8R9412O0QlMP0ulZP2h59gLghumC7SEc5E3ng4UYVxf9CBby3HHg2kShq2rgv
         eRRWhYTKwveB4an3Nib+9TSb+JJm0jEy1CZXEl/cUpjrLkI17sxUYeVVYKGSBhwYXmuk
         ys7PifV7PULJKtpgFEqsCQzOZhdeYpnwCBX/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854080; x=1794458880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lZ/laB7EjjzlJibu0SL3xlybjiUy40ADVZ8qce7qfBM=;
        b=hss9K0GGpnQo/OqA5OYiA5iCDHoq4l5L9FEXDZk6wv3ubWFvAmBWpPG9eneuwBGUQM
         BToSqhjAal222m+S+P6rg8QL26bR/2MHNFCNA+CfK1WlrG+8w+dFW4mZD7fY6Biwnsre
         MGTZNvci6WxLLMS3q8Fgu3xmmS6+YX+xz4okaMhPoxsjj8imwI2v5oKIFRJL/vJ0sxmS
         TKd27UwDEbMqNx9LPRrVfPGeVeZofuJCng099E1jx5QMYTNyh+fqZYroTbH2cvTimUlk
         +DVf63VRaX2QZyrMjG8H4Ptco/io/yIc4G+8l5TagR++SYVh0l+gGF4mvfIBt6Ht14+P
         nWjQ==
X-Forwarded-Encrypted: i=1; AKwUvBzqTeire+OYT8fiSMg3QX/WmwIto5X70W3TTs4Bch5W8LdKTeKevP5/HRF693XDVzsCDIe6Hvmv/w==@kvack.org
X-Gm-Message-State: APuU4Z8nMqql0AMXDmT7JFIH0/Yl+Bsti9v6UgLLt76RPRc2EGp5/Jnd
	0WwcJ9pJm5+U2GwDZ1eSruzpZ0qFQN7OQR3cbAMrg6KiF2/Vtm5ICHp8v9Bidnpyrw==
X-Gm-Gg: AYBFou20+Fa+931WHZOX0tSYetABK9BOwBCHADck9jmBHZCbXLcmGYq/n0rla2V+0k/
	y+TWGL8FmjLdaxVqTW4K7OMii6bX2sG0Bc9WzQTRh2cXc+/AwAxe0lUoDMxLeZADHdfQ0pdtfSA
	w+/3wGAS/FiwdanhReaPi/rcDoroXvG3v2Q3/Mku8uhqx3XvGOPxvU88Q/F4xH0AHOxzl6DTtgD
	hqz9qiLFJcPRWzKuV7Cx6JvtFa7YhFFmJnte43bXyjIGEZQHJHT+kHYckB5KAUDu06mxHZkDOSa
	OwGJz2ccKfxGZCJJI3moWNMxA0Zh2LZgBfFo40UyQK7lqrEjb8iVUh9JFfZGrNk7VMH30DNFwsC
	5RwLwbvIlfyTyvkfPX/V/B2G8UcwzSVmdNHKrvJzDLFxRX1K6rXXE/fKfgCqNTG5eMfqqtvAhLy
	zqpsqLtzNBmF7oJLa+1qvcJ+KmKO9c0O1FZm2XtpE5DKiofGC0O4z7Xvnam6z7ueA+Mmx5CQ7xw
	nA2FjKv5HofBStYmBe/HBHLJLDDPS+Ousn447ohaSX3AvNgThlDDIOwiljihqrobn2Hw+SoF1oD
	fNL3Kf67RvS7+FcOGKZ5UBYL7hBFs9oUWdxz7INKj7BW+xwDDVGpC3RHlBdFO18f6t1+2UZB9Zo
	Wd4GT9TohPxOVt4y7jQ==
X-Received: by 2002:a05:701b:4192:10b0:1a3:8d5f:6f93 with SMTP id a92af1059eb24-1ac5c8369cbmr26358050c88.17.1793854079724;
        Wed, 04 Nov 2026 20:47:59 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:47:59 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 0/7] zsmalloc: redesign object alloc API
Date: Thu,  5 Nov 2026 13:47:30 +0900
Message-ID: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: desjmpmm9ycf78bugofqpkm6m3snkebt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 223A81C0008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793854081-169672
X-HE-Meta: U2FsdGVkX191SyPwAMkRqMwHjidkhF7b0C8I0Ltm2nJwvHhKkeRmjkGgD1tWM4gKw9XPiwI9oxSelKxT807qgA/Nrrb8zTlSRe1kg7wi3J6jMoVcRnlEzyLGIyX1/pbN+OcrjPnapgniQisJ1UzDElOrx2ZixUGTaAWak2yVhMiD4VzZlIaF5jGJsIbp+HQpiUJdFv2kawA/sf4q5j/jYU30oParAFXIHpsfsuGt/hwR1qzxT74zTTj2TeXw87YcqoTvEZxlubvla4Dv4YdQRYxMIkjwBo2MsbkUG+thSrtX5glu5Ez6XalDVAj8EiMzUPcHv+Pr9fmwBqn2Gj1jysgT2UYyGuVL2+T05kmzB8RFhjDjB2C0BJcBJpVGJAE0a8/IdV8GzeBabmEpR+jlyrv8XIBUd9zZ6FNWxO621tcLA8zzgvVBns7YcMUVDFfu7Aq+8u+gCbQK5tJuR5+x0gapA0kyyjEX50cIbFQ5iPIryIPkkdXHJpzh55il2W5xkPHJEoLmdQ7sQmTPojk7aK8/l1tgp43yelfBHWhkXoanT/UZncKko3tnLTncqAGbHJzJ7DVLE6VWU6bsyWv6r5RbkDzfbMS5pC5Eh+h0wTzeee7a4pivxcehQDUH3j9FKA55MkQhj3lZNm/W/mfvUXay453Es8hfMcMSEXTkk87Z6462k7mX0xuLlRc5z86qwmmluYK8kTeqKXaEPy2j/5dXVgVEgFXFwIM9JBMZn9Yh0wemIqe96fV85OFH3EMr3/9/W0HBIdb4BKp0+FWaHpdLH9xc/e7Zvl0x3Y2n9iz4zLmmiNsPLTGh/Ti2rUnVp00tjF/msHtiRZkI3A+67S3gD5CbUfEqYlOBeKHdTGh40cqev/KiFRzOI+0rHQ/3tlNSbRcySTdRJiIXDe24LF3xEfW6Voj395btgvsLkvk4h2O0mUnPDw/oTBNke6lj/eN6+LhgXlNoA58rkTp
 PCRe6hZC
 kgvuZmrtm5FtGA+ecaaOgrNh8lVkHhZFintISytceiHGbhdKGadHDoTzvK5ecfVASg2In5oUG4q/qQmjJtY/Mlf3hRNJMWE6EYc7mW0K7jqc5vL4MbkAAEKx++LiRCkit7WhjvjHDD+3p/atmT/eyfTIZLiBIeSCotf+M0SQULeiudiY6Y0pV7H/UaC29givm3JA9j+jbAXFXzWDgJkTydyhmUclI/hZMagCBTSDi+GX5fZS8CkiEYVV7beHWVdE6f07Ir2h81ZfV+ZNBdRGU8XZuAO2DmJ7eRssDdvAdla0IEetLKxjqpkLJ40AE4e6a0JAv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both zram and zswap already have per-entry structures that store zsmalloc
handles, so allocating a separate handle_cachep object per stored page is
redundant.  This series embeds struct zs_handle directly into zram and
zswap entries and drops handle_cachep, saving 8 bytes and a slab
alloc/free per stored object (2MB per 1GB of swapped out 4K pages).

It also folds zs_malloc() and zs_obj_write() into zs_store() so we don't
take pool->lock and look up object location again right after allocation.

A simple zram test on a 24-vCPU VM
==================================
165 fewer kernel instructions and 0.7-1.8% fewer kernel cycles per write;
lz4 single writer +2.3% IOPS / -2.6% average latency;
24 writers +0.9-+1.0% IOPS; no regressions.
Memory: 8 bytes less per stored page.

Sergey Senozhatsky (7):
  zram: drop stale comment in write_incompressible_page()
  zram: drop get_slot_handle() and set_slot_handle()
  zsmalloc: switch handle type to struct zs_handle
  zram: allocate zsmalloc object under slot lock
  zsmalloc: embed struct zs_handle into zram and zswap entries
  zsmalloc: fold zs_obj_write() into zs_store()
  zsmalloc: constify struct zs_handle pointer in read-only functions

 Documentation/admin-guide/mm/slab.rst        |   2 +-
 Documentation/core-api/memory-allocation.rst |   2 +-
 Documentation/mm/zsmalloc.rst                |   8 +-
 drivers/block/zram/Kconfig                   |   1 +
 drivers/block/zram/zram_drv.c                | 130 +++++-------
 drivers/block/zram/zram_drv.h                |  10 +-
 include/linux/zsmalloc.h                     |  37 +++-
 mm/Kconfig                                   |   3 +
 mm/zsmalloc.c                                | 204 +++++++++++--------
 mm/zswap.c                                   |  21 +-
 10 files changed, 229 insertions(+), 189 deletions(-)

-- 
2.56.0.398.g882cbad275-goog


