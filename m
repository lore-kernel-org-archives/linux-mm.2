Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF9E60A260D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mzbNMIyP
Received: by kanga.kvack.org (Postfix)
	id 2B7016B05B7; Fri, 27 Nov 2026 03:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268156B05BA; Fri, 27 Nov 2026 03:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156C56B05BE; Fri, 27 Nov 2026 03:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D86FD6B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:48:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A752F40257
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:48:57 +0000 (UTC)
X-FDA: 85480273914.09.46AA6AA
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDE3B20008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:48:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mzbNMIyP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795769335;
	b=usqjAvv1aPOaKajVbv7GOFCpbr2pOwZTLeoMxm+WDLPnoBfCpMsRoJE8R335+IU33dGpP4
	F44i1TuDMDRFD3UcyEXlOczLrhmI3JXG2azeDuD4qz5cHfNm4EpvrMhjFvFaj6wWF1FW2O
	1wq6czayr+QVm0SIsxOgLAVtONd7TGQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795769335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V20sSYH+TxrCV4unQJ7dg7ZdaFxiFFR+LbaIUnR8j9c=;
	b=qDgB/P0Z7lDiuD1CDtH1aAuwda8E2x9cG3b5Do2xIiXz53MLMM2ZI9rdmURWZ1sOBP5rB0
	Ip7YulLGiW+/u+DpUB2PnXoOOdUzSsV4dtNa8vYkzCj8SV+sGqc7zdLMZWkP2lnkDXZG1D
	+DNYU0bBJ5L5MkR/2duTk7QGnNP4Fl0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mzbNMIyP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cdb2893531bso4125000a12.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769334; x=1796374134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V20sSYH+TxrCV4unQJ7dg7ZdaFxiFFR+LbaIUnR8j9c=;
        b=mzbNMIyPL08IxOe/snvT25lJnC69/eZ4i/cpcQPSv3CTSDGGlhyLHC3ceQ7RitiJaT
         m9gvt+NHxPvg0HyIwJWyjiTQMDnWYpR7p2UE6yqnYHFXvJa59HctGA6jlI2jgBimGa3j
         yJHV7Wn3eGF8UAI9vB7PYq8sa7eZ0CneO/JQnrJlf2wSUUsSylA7ZrrWArzZr8gXvdpP
         vUXdzNP0pYogHjm9SuAPeFkfe5xoOqvnYqXEZqcenngFrI90Jy7IiFjZY9EzOrRFgm1C
         AizOdCp6e8oh14DrM5AHAYjlazZKieie2uGjwtpBS5zF2cIq81nWrZhY9t1Js5JeZbI8
         lEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769334; x=1796374134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V20sSYH+TxrCV4unQJ7dg7ZdaFxiFFR+LbaIUnR8j9c=;
        b=nAP9ten1lrT4V7PrOp4DwK9jE0fBL42H8VqraBTcFX7B+E2jQ4IOgo2okGQCxO4elB
         Q1lqkSUEE5zr72gDzI2UkByhjwIzg+nG1gKmkH6mndTEJkyTkLVhTFrFlmgYU9NYjS5g
         xyZrWTxZiha90gWRUqn8XTxl0k16NnAGGfWGytLeYAj1m0+JKIr0zrNOYy0dBvHgkjTH
         WB0AjLzL14Be+bf8WJzrsPmUWfiQ48+TAGIGwwZb9dGtkTe0CvZZM2+XD5V6jZgjlwov
         9Fq5xFF7h+uP5YLdYi30lAxOCUMLL+vr6VIlKBMbU1RLwW59ATCi/mJdE7Ad1vSea8mX
         AqzA==
X-Forwarded-Encrypted: i=1; AL+hErE/IpBgL4F7hmJrgmcC+0CuWd4jaHXXWY0ZMCBfzl82r0GVsVIvGPxkdwxLgs5++wyT5oNfCw00+g==@kvack.org
X-Gm-Message-State: APuU4Z9QeUA4lxkHOKLmi4vlAWOcGJTT+IyybcT/FtdsL7/EibvXqGsF
	vOFus5hgbTXWZZ85qPKDeWFBMNEs47vz6Lvpd3MM74m0QVjdM+qxdC+u
X-Gm-Gg: AZFdTZchWPjxYlgFhSdyWbUdz54d8/6cK3y0Oy6uXIZPHCQs0dzLfCCaeOhg2Vib7h4
	1mkUQZ4+P7fXWtL2Ow01aCgL/0HzibTmcZQ+C3wS4PmJ9UNFcJM3oexnjfgbph88T9Y7LDIpTxu
	04IuutG518Fd+/nV4FZ+LMZYWtSXTCYldNiFkCH5C9SjI1esrtXhYp/OjhRJRrapZqgNdGMYX2k
	0gunGFUUsFDlnxpmPeHKvkttaI+fyhOgopJq2QfX1cAzahDhusW26dnEY2hfOClceM9kTJNIsuI
	39yqz5NkYGl8OtQgiwzWTO23j51x+4qqL201Q+HOgLV4AjnNiLY2KpUODm5K8gcy6vYLwnBt6GX
	fFbs0tuAwoFoKKlmM5OXgrACM8lgll/4pu35En4u/17eNdOWJcLyYkeUBis093+osxysm69VcK7
	i19/N4Y/FJURdbBM8pLnz2v4P6swL2ApW2yXgj7Y+5ttQRZTbIwO6L2Gm5St75zC0ST9YpoLMUK
	fFMxMZ/Y5w9mELINvxOywqXSA9TXEb11MJsJLAFGKRj4ubuj5m2SjRUBqj/6zpjzHy11cV+UMle
	Xt1PQt7eGohF5mbzYHBgLuYHBJXGiVLOYsIkoJnWmC20KhW1w4GhH3IVSzkGmHnplbqDvotCxIB
	Q+hOH+IrYUXY=
X-Received: by 2002:a17:90b:390e:b0:3b4:fcba:8f7d with SMTP id 98e67ed59e1d1-3b4fcba9627mr7869895a91.29.1795769334244;
        Fri, 27 Nov 2026 00:48:54 -0800 (PST)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d0818c1sm12289058a12.30.2026.11.27.00.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:48:53 -0800 (PST)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v6 0/2] f2fs: enable buffered RWF_DONTCACHE
Date: Fri, 27 Nov 2026 16:48:43 +0800
Message-ID: <cover.1795746008.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788795700.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <cover.1788795700.git.qiwenjie@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDE3B20008
X-Stat-Signature: wuze9cghnjscj6pkh5fxky6fgymfi7xh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795769335-967936
X-HE-Meta: U2FsdGVkX1/WVvhlaUPWB6OACR18pinq6j4pYVQe0tMuGItX4tRr/zBmTaJPGutyfbuNEV2DwNqgwkNFWc9Ly88e57qQ5R72x6dqjq6ClXPM7BuPSIkA/M2vDR3dizZB45CbFeueIsXpjjJNkbWQ7BxKTNyFNkZbPh++LIsfA5Rtdavnd4AkwGXjo/N8K6ATuzqYOvIYx+5JKCAHuQqzAqCdWAadYp8XVw1EOlzni3NR/WEu6pfhWb4/LhyRBL5NsfFTjEBtViIDk8Geti6waxvHBt9ZNRTEmGwyISPxERTKka9WeTsqS2fRlGdMwXGv/FuH1ahdbgZh//AdY9dIuk9F9ITERjCHgMeG8/qji2XJVojfWVQUXR0SiMkpxuxYQtZMrzJ0g1GjoDtXYzZnYEOFmT4PvEPqxz55XsMHGZbTjjVd//4pIAPciQQ2AW0u86PZcQ+JgUeT999IXcjhko/fPs+vJ0dMG9QsFoUK1Sd1jRxabZcTId/T6FEUfAbg5eWGd7JwV10uBhkEFOdEJdgvISpYrSMadODJT50dDKNRqOXsQMpBxGA8uL5GFZhZ1slAuJstv398cgbg2eiToW0Y2Uc0d0MI2rFNFarhKP1y/dVh7YjH2GS0AiMcoQYD0RvNWDmxDfSUikAc7Wy7OUHOmoVllpuevn5WM5N38kgDLeimtnPmHG/5FOaybo/WTfCx9DX/+0ch+HohjIcAOnHQrE6LV5ldQPx0CEyGag0ZI/DRtkDG+MhiXdM+SQFFSeHVTI8eUjJtGe3D+rjwbZ3oAmUKqCU6LFrTVigaJMhoKYP4sP6E6yDGs6/g8x0p2WKwme7n64+E3H6ptD8lOOsxQwPkXzBMNjcgdSP1M84Fvwqc3bxE6nAw0KIrYVSxGpXXDmNQ26K5MowrM5Yj60JPbHke4ePtmtkJ7WQOEYkWVPld+dUgKANKSHNTgmmNhrCuM5ArJBY5XUfVfyX
 i3tcIFAw
 CZLjwCBSDUtMZexlcwSDCR5Ddv+v774gPsW6YffH7AogrzQh4+BbwK9xUjEIDL6YVuFwiJauXsXuZzKjTOuODGlHr9/9vz1QXLfc7JRksFgPO3Lkp0bcAdAW9A/VTqyFao6IU6ftSQfxurE/Z96QFy8Xa4knl6HDWvfFcHcGk5Mj2vd+GAFhka2gSpODZ4xOYvvKZ7Ehlew9oML2Hn1jh4o5DCd0wwEs8rBEid5NGMZNv7L8K/VP6D/BX5Gpu2p+Q8g8/mU9j8pEfhDZ5lueiwh20ap8dt73ut6z6axb65vj6hfixYhbaBi+NIuIgZVRq5kduTV7JerqNP1bAnycS2FhBoQtmp3eVwS8VWlipPIG086jcxzbHwvDVvbu7vyKHoptXW7W2B1ei4WM8XWSB8SFHGh9KBiaCe/Slq/CzkPgHZHYQWeikzCpoZEsTleqSqaNlU2cJtO7twyQ9BWsElmf5yvwAcObxxi6R1Osmrnf26lPo1lEf46MxVH9j2jTQr9Bzjm3x8A29CvmqRrMU420GWqNNF/myUBGy8NraHd32ycsdXc1VdMAS+50u0lyze5KOXSLLzgkqeuV/nwBoxICIGGM/hvkLN4tM3iWacj/ep+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series enables buffered RWF_DONTCACHE on F2FS for one-pass streaming
I/O, where retaining the transferred data can displace more useful cache.

Patch 1 marks dropbehind write bios with BIO_COMPLETE_IN_TASK. Normal and
dropbehind folios may share otherwise mergeable IPU and OPU bios; the flag
is set when a dropbehind folio joins a bio. The block layer handles
deferral from unsafe completion contexts.

Patch 2 passes FGP_DONTCACHE to the buffered write folio lookup and
advertises FOP_DONTCACHE, enabling buffered reads and writes. Internal
write_begin callers that pass a NULL kiocb remain supported.

Tests used x86-64 QEMU/KVM with two vCPUs, 2 GiB RAM, and an NVMe-backed
F2FS image. Each attempt transferred a 1-GiB file sequentially in a fresh
guest, with memory.max=255852544 (244 MiB) and memory.swap.max=0. Normal
and dontcache each ran ten counterbalanced rounds. Values below are
arithmetic means of the ten runs per mode. Write throughput excludes the
final fdatasync().

Throughput was:

 Operation  I/O       Normal MiB/s  Dontcache MiB/s  Change
 Read       1 MiB         4137.96          5869.38  +41.84%
 Write      8 KiB          686.09          1752.24 +155.39%
 Write      1 MiB          714.91          2161.02 +202.28%

Average memory.current was:

 Operation  I/O       Normal MiB  Dontcache MiB  Change
 Read       1 MiB         197.26          13.70 -93.06%
 Write      8 KiB         214.22          13.15 -93.86%
 Write      1 MiB         215.20          19.52 -90.93%

Mean reclaim counters per run were:

 Operation  I/O       pgscan normal/DC   pgsteal normal/DC
 Read       1 MiB          200999.7/0          200888.4/0
 Write      8 KiB          201136.8/0          201120.8/0
 Write      1 MiB          200899.3/0          200883.3/0

Scan counts pages examined by reclaim; steal counts pages reclaimed.
memory.current includes all memory charged to the workload, not only
file-cache pages.

Dontcache left zero target pages resident after reads and one 4-KiB page
after write synchronization.

Changes since v5:

- Rebase onto the F2FS dev branch, adapting the bio tagging to the
  sub-folio merge paths and excluding metadata-cache I/O.
- Drop the Android 6.12 backport results, as its dropbehind implementation
  differs substantially from that in the current dev branch.
- Add memory-limited read results and update the write results,
  reporting arithmetic means of ten runs per mode.

Wenjie Qi (2):
  f2fs: complete dropbehind write bios in task context
  f2fs: enable buffered RWF_DONTCACHE

 fs/f2fs/data.c | 10 ++++++++++
 fs/f2fs/file.c |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)


base-commit: b61a029304bb5531312ebc133b2a895d14dc3fee
-- 
2.43.0


