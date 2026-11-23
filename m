Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD395606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=aIB7eXzg
Received: by kanga.kvack.org (Postfix)
	id A8F896B05B6; Mon, 23 Nov 2026 00:27:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3ED86B05B7; Mon, 23 Nov 2026 00:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955E56B05B8; Mon, 23 Nov 2026 00:27:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F73E6B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:27:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3E241207CE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:27:50 +0000 (UTC)
X-FDA: 85465251900.04.B3CCA3E
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id EEC36140006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:27:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=aIB7eXzg;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795411669;
	b=x68v+CK90yYDqmxH/cJOaeWgv4wtkXjGiwvzMMRhA4mbyqmF8MaJRycbnGvGfTGl8CNdcU
	DxwLPgr7m+w2M4csjPsw4P71s2AsaPYq9NYeaGli86Q/zeJleKna20rSWTUfHJrUHSFg1b
	n5/ZpeqxXpUl3XMJrCMuBgKVrabn5+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795411669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNTKVcF+kDGwUT5mkNEDzxX6VPdSRAfD0Do5dvR59q8=;
	b=ummVoGXMAGjC9WGctJmJ1bcBTr+ZAbsj3Mxk/nuyHqZepvmWMZmFUb5cPdw67jg43gGtFI
	9QZHPiKwFm59Xkc7MPQETXWMNOAYyVAFy2XDNUN3XGujnHonjuybJuLdlB2C6kvAcnj64d
	XADHMvyqCdir4pRrj5hTThw9E1OfkgM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=aIB7eXzg;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8ca6a12efd9so422196b3a.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795411668; x=1796016468; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DNTKVcF+kDGwUT5mkNEDzxX6VPdSRAfD0Do5dvR59q8=;
        b=aIB7eXzg2GnDKV0h2aMXeEzOYyo/bRHx7i32Nt+Y+byI1EriyUts4iLqTCInEwcXA7
         XtjVXc4vjiKGWhkEruJNhOqofEH5Wj7OWjr+l4sUss5+3l5nAMTxsR48i9zhLD5E+ly6
         qrQrkbAKA+RubS/wGmyIQydjgmrTGdXbgRzso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795411668; x=1796016468;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DNTKVcF+kDGwUT5mkNEDzxX6VPdSRAfD0Do5dvR59q8=;
        b=k/V0qwnl+9V2v8dYMLigXXbft5ibKq1VnmVYZKsBtlv7cfGDBvsPnm+RxBpZDLU2cB
         LkIOHLxZJro1exo30tsAsFlDLIuHHG/lhwK8VHMp3GT7XtAKO5sCK3nORmtNNZCBLAVr
         +Mw0uXwrElXBRivWJhUyd7Qkju1GG4HZplpwDzN4l4ynXkdTQJa9+tDyMaT4FCM480gY
         1Ux00f2aDXgdQlKtDDvJMsJVr4RWL6etK1vJGzYGal3cRtDXGlwuji9+yyVzobZj4YnP
         ht9W3S+Pw4d0Kc2XEBdH7nbP2vM72iOe80xghFxVYg1wymGSe+7hNQgejVF/BVyPHugi
         NtQg==
X-Forwarded-Encrypted: i=1; AL+hErEZf0xWISlXaoZW8QXz1lzPOY8YZOawOq0gs2xjfMvQ7MnWaYNpcm0cpytJtL4QGQa75mw48w/1wQ==@kvack.org
X-Gm-Message-State: APuU4Z8NtzHz8AvHfHhQih5hSNcY4gUY4huC3vCE9Xtyfds2fxbWD3iX
	3nGeSJAf0P4Yh24JrMjAzIOIpoC2DTdSgNEP2cyrMQ1Xl3Stwkjaa6y19FkLDxVA/w==
X-Gm-Gg: AZFdTZeH9WH6IVIh5/LYinHEl55hHOi1qEzpL3RUsjltryEhppzxga2nwtZAU9m1FaQ
	mlfA1YV5YD49InkjvTlapAPdcTldJT8XIPPCYh4Vs5E8Cw6IGg+ZkLFNjclBK+bK35r+ttBX/f/
	RYr9/+rVJqGlxCmutLY9CQ08J2Td54efith2TL9ebF6sXb3z0FhZCVnZ2abBUygBCFW5lvpHjw5
	7gfbvsovVT/DRH2hgSj1BrHiqoKZokKJGFBKGvGwpWeXzIHRRBM9uO+Y1tDOZJVmU5AtHUmrj6Y
	IBZG6T2uRbyvnLlansn9LwCihCqNWH3rKprmRhzdFQHZjkPAssoPFp+sXw58gkJQCw8eFm3xGcn
	144r6HwnwPqrxPVuJRbxhI4PVz49LtApReqoIRXC6N6TD72J5cv8MbgvcekD9pA6rfWHy+RCTim
	liUGu6RDSvm6Wh0/FK0QD5orqSlCDZyUp5rFOd0yZ+BsMJ95DlFvGFE/R1BZ3ztfvr49CSmL7/l
	H8gmDxnsIxUxp7aA0fm5Vh5G1WNoT7V6gkAqOkLgqi4eQBMYQSnF4VVpBW/es/ARPbC6KDe7VV4
	zavoeip1o/vg53K3+MBaO6buWjwgR4EvNZwuSkWF5hYTCKG+5uqhYdY0WdAzN7a3Je+eMQ==
X-Received: by 2002:a05:6a00:1818:b0:8a0:5d8f:665d with SMTP id d2e1a72fcca58-8c87d80b3b5mr8569194b3a.58.1795411667613;
        Sun, 22 Nov 2026 21:27:47 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f571sm4698086b3a.34.2026.11.22.21.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:27:47 -0800 (PST)
Date: Mon, 23 Nov 2026 14:27:43 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: sashiko-reviews@lists.linux.dev
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Hongfeng Chen <hongfengchen@xiaomi.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] zram: keep the hot statistics per CPU
Message-ID: <awPN3Fiwcej4_IU7@google.com>
References: <5666c1c8c04998784c81fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org>
 <8f0ec29c0e4230d10db088d29f79bba17c3ee6f0.1795403342.git.senozhatsky@chromium.org>
 <sashiko-outbox-228621@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-228621@kernel.org>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EEC36140006
X-Stat-Signature: n4cswj1x4ouuoxxyhajmewwufzokhwhq
X-Rspam-User:
X-HE-Tag: 1795411668-162982
X-HE-Meta: U2FsdGVkX1/j3ffQHmLSxIHJcGhryGAu0zcU14nVHtVxeH3dyt830D6fEdJUl6NXmUtZ91dXmwpsE+hqTk78aO0R4Zu2Gz1jRgpBRSP85DLFHdUBK/tx91CLt0q2qh7aU3gKMcxlbErP64Gc4l4NCzou+SrjoMvm5tFG/aDZSLfgQdxqz3GXiGPyU3LPgVuCFGyi/gfM/ALyrV378BYI9WGPoWpdvl4dMOFokFUaRmz98dbfccYa02ax2rPSCzNzbZzNexWJB+tMhF8YfpwEuxC8dlp4HMJv8oYIHEh9+7AQ+UGHPf5elKvSGgWxC0bsNFgHzj9p8+TmDB/K1b4d/XiJbwQyX/U4W7MzzMIGq3bWlKtHvgxBG2skDrFUCjKsiHpyuVbe4pk+mI1mjhMouHBiTT2zvsawISMWpajlTaXKbDLXVp2VzM3mIs2B/Kq5ynUHJtYwszF/807ymEXsOyij52q/QqtgjxXEqZa0DVO273JDSLcQtJ7dgUgrD9KcKAtbvBuPImg5lyQjUW15UgH/wkyrDlJILzchwy33DaOT7IKT8NkYMk6MPUKW9VkMj/rrCk6D3JFJqgAWldoQ7T/QEtTL0qILgYERhoVtoH72BZWPGzWu+JUDlVvG1vRT9hFgrB6U7AC/Af+InyhMPmE3sUrGxCCGrYPdHRi4DkGggSuRGIVvzeuwU9Q9quS8pWweCyOgEL8ZNyHiuNywifscbIluk4JSLlALVFLMOPhNlESM4Bq+TYFRTZX+Ugm1K3rN1otURVaTdwUD6uJl6wx/Xgaas0mI0DJ8c0d5TbiqgPjWSvk1BaXLRWzEhzQVH1ktdex+L4JcAEXcDWWbrFITKXC/cSmFOvUB5Ak4kSIgO41cliCJe9Ara9ex9UCufcfFT8RmIPLghJldI40Y0dzFgfubU3SMUkIUbw9dQ6DtuyTPS90cJQWa6EP9Dantodv7+tG1m3mLiIaWcCi
 vevf3IE+
 YmQrJUHe9tLjvrvJlTBo2XB9SzFpNJs0j8XYDUVHHLEjKKQns3YNcPpfX5oL4C4vIJ2FT7JeGyYqfI8eChqAsGjSGPnbaUsl4BUeYgF/NHwUUjKadmBVYRJSfIAqdRXh0+5wRaGkvtEP1PT92WdNIwpvr+Igz3umfB0DRiG9gvJreFtOO87rQy15VtavxEZ0uoD4JPA4AalZ8WY9PZiL5prvjzTwOLpBLZha59YIGYtT04oYLkX+oJAOc1p7Hm2zcyuITYoL3Lknk1TZPpp5quJjt8ZRV8oNUvFO/rci9N/0neaM7vvFNWBBDLsL5jzocvuWqiPpyvgD/IOEVd/2d9aYcaKqYzgpK/NAB/70m64kU4UaXs52n98xdC4O7ikdvQhYmqZKck/UJp051mFTizqb65izDZ41MYjslwzw5AdgLbsuA/cdfXCR0LeOQvQfHMaH8Si340ttRhIc7c1p63VibqogoYg4U+Z0YBVaYvD6DQ7VZ12nPwNbuyur3otAtxWgzHvr783XdKkK1r1+D4SBJ8a9wvJqfp5Zi9yMFQACByPh62B+DiI4HlFO70Y3t77DxktazEMA2yNT10xlnU9LZ1SweWc79WNbj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/23 03:55), sashiko-bot@kernel.org wrote:
> CPU0                              CPU1
> zram_write_page()
>   slot_lock(zram, index)
>   zs_store(...)
>   set_slot_size(zram, index, len)
>   slot_unlock(zram, index)
>   <preempted>
>                                   zram_slot_free_notify()
>                                     slot_trylock(zram, index)
>                                     slot_free(zram, index)
>                                       zram_stat_sub(..., 1)
>                                     slot_unlock(zram, index)
>                                   mm_stat_show()
>                                     zram_stat_read()
>                                       sum < 0  <-- loops until CPU0 runs
> 
> While the writer on CPU0 remains preempted, the true sum across all CPUs
> is negative, not just a transient artifact of racing with the summation
> loop.  Any reader in mm_stat_show() will busy-loop across all possible
> CPUs with zram->dev_lock held until the writer runs, and a higher-priority
> SCHED_FIFO reader on the same CPU as the preempted writer will never yield
> via cond_resched(), livelocking the CPU.

I high prio mm_stats reader is an unlikely scnerio, but yes, okay.

> Clamping negative sums to 0 in a single pass (like
> percpu_counter_sum_positive()) and moving zram_stat_add() before
> slot_unlock() would avoid the unbounded loop.

I disliked the clamping approach when I looked at it.  But thinking
about it more, I think it is the right thing to do.  It's perfectly
legal for zram to return 0 for those dynamic stats: no data stored,
no incompressible pages, no same-filled pages, no slot-free, etc.
So userspace should not be surprised to occasionally see zeroes for
those stats.

