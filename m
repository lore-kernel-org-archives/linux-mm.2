Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACB4CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7906B0295; Fri,  8 May 2026 17:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587A96B0297; Fri,  8 May 2026 17:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3C56B0298; Fri,  8 May 2026 17:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9346B0295
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:16:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B6F088E48
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:16:22 +0000 (UTC)
X-FDA: 84745511004.13.B6D1BA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65D4C16000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:16:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p2+CJhfO;
	spf=pass (imf08.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778274980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NF6C/d81QJhRDcIqUooNSTEJO/9vNkNfp0DzteRCjs=;
	b=gUyoVEZnX0y7CjNS+3hbmbT9554EfIsUlpAQWD6Qno8tbH0gwa5NKvgpx+QVz/fVYc4Nqc
	ox/PMbuzGgX1cg9VcrIVni5GPcgwk0lpclBCkbUKapFTmrlfaXV1lgLFpml0gWAt8EMWkC
	I4dAzopwzu/6SgCVEiH7Bhkhsspxzdc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p2+CJhfO;
	spf=pass (imf08.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778274980; a=rsa-sha256;
	cv=none;
	b=Eq/O9nSDmOxzrlIxO9t9iQo+cSAV0G9zeeG4+xy+NV0bTh2e8xCXTDP4J2T7iyYjidWBTC
	VCn2bMuaUrA6fdYxw474/ypywCkxXitPUCkfMv4UB83R/jmUnDeB9zJrKZbhfNa/7/nkM5
	7XZ2EE8YKOjPWclP+vmGDhwNeiSfcN4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41826432F6;
	Fri,  8 May 2026 21:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4497C2BCB0;
	Fri,  8 May 2026 21:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778274979;
	bh=70OCw1Vkjgg3oNBk6/UUtqGZOBPrd8//tlolMQrk7CE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p2+CJhfOLKI7D+tdcb1zgUcXi9bmIgau9NrEK0i7p1R9a7M/qnKGiFtPbptErwuKQ
	 SiRwHsj464rZtXXmfoKEsOaA5sqTQq0yG6psHPuitAJZdU5TzMHs2aeyTNWrRKd0Op
	 oO+M2nt7jDQHkqYigcdQg1arrICvBGFeqCsD7/1ZA1nNayE5cNCnmN4LD3WrqQ+Hzu
	 KeiIyftDpyLXrZIATq2flJEWY6hksi3VYORgpP0JvhN0viJv1xuI6OiPOi621JWYbu
	 x7ppUHM/oHfzoyxDfTJ01fz6JhHBAhTUo5EBdBTDb8sTzuMyrUo7uD4++yE8O8W+il
	 zUVsEvgZbeKtQ==
Date: Fri, 8 May 2026 14:16:17 -0700
From: Minchan Kim <minchan@kernel.org>
To: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com,
	liumartin@google.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] zram: fix use-after-free in zram_writeback_endio
Message-ID: <af5SoTVsm2vVhoml@google.com>
References: <af1BNwmyHK6aU_uT@google.com>
 <20260508084933.3730661-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508084933.3730661-1-richardycc@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 65D4C16000B
X-Rspamd-Server: rspam06
X-Stat-Signature: n7ua7q3u1hmeq5p8gahahjp3ehzin16a
X-HE-Tag: 1778274980-399656
X-HE-Meta: U2FsdGVkX1+SZCSUMti7JI0lA0G0qn5lBhiIxEwFROZn8rRe7geW+eX/WjnjpQffy8bGRCao2Bp5zLjCFPv0L4pIVi77HgUbyHma9opJAN9qm1s3O/ZfgqWo6lDTFZEYdLOLSUXgZKTXMnr156FjLOanH7/CP0ybe8MGTiH3TeZiErxtI8vCaEV8T0f/fo4ki+DHSy4dQXjnUME86QGEWPwztWu2zI5PEVcoJANNjGlNaAvFNI/ZHJdl5CsoVQfXlkhcnzQZymH2Cfbb7/W14YLhUkSN5VWWdbfg5eU0wmYIMUzO3E+JMv6YuhICtUyCwsGvzo5IyP0g9J/MdvKYDcpFTd0XQp7bbPk2MfLE8+wQ4ybO7Mv/M84x7t2ZvtRsw0AdI4AqDYKfh9GMLFj1GzHZ5W9+aWLsrLitjwmlzmmAaR05Ij7D4uyF8s2pMA53Aa52ZvtNetRSYWumn9530Na4GDwq2K03B29qW2211eKpdn3OJX0JhopllHthp4tIt1804ATldd8GK+49/FWQbz77+KK6YW12qcwcxp5q6a0gWbxYPCrJUryXDDvxpnX5+EsmlD4hZYb4Qr5ldeU0u9LjmjJyxyjhfKfMVkj6eJP0PMErDlb0N8CHYNhgEAxk5SAY7nuXhwn4prgok2NAXjoMajA554DM3mEnjp8NYu0b+0G9MRGJ9KIptjSCTd8QkyChdcS+fpfa6aCXG1ANHywpp5Kwl5kOFrJKWraNWqxIOgKAGc5oIfg9tPo3ygFHDq5hlrkxR64FD6lxMGefZgyuan6+34yzZvl/qfsaNPNaUdsL4SVAzEBEOii+3UMd2KciB52A9Z6T58hPDz+d8sYMuIBFmqTdZwgKsOSxNZ6ev+oLhQNvcAB/Zqr2aJRcAsniM3BfjRNWMfQCAxKyxpUclY60rfQFsucGjkirCms2YcjdvqiPDGurjocTFm/ziOwHvZDfFn/3Bbf4J3M
 xJ6OssYV
 Lrjay7XgC9YXMKvudPJv1PftLqb4UjkmLtHkI6YERjSKaFQWlyqUac10tPq8burHiY3L880mOdnGmclGhPXj3cLBUFMraN8geovV9HX/Y6a11UxGoSxkCu7zz9s/rfeXna8QSfuyA3RGJ5oWm34Nx5K32smk/X92YkkVH2ol1ZjB/N4T5Emf8HC34wth347qUNGNeQd5t68Wt+eBF3ftkzUhKjBuWeFZQLVFe+YRaKII/VcxhGEZSMMjqqlQ+hUcfQY6wKfaw0ltMRXRkfH5oHdShboNqapzJZ/h6m5G3gybizsSDxuNLm7Ws7z8XY0Lr67C0AXlbviOHCCdFY8RmBpImvoL4GlO3mikbc6r6jc6JpqQTDfZAgNmdLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 08:49:33AM +0000, Richard Chang wrote:
> A crash was observed in zram_writeback_endio due to a NULL pointer
> dereference in wake_up. The root cause is a race condition between the
> bio completion handler (zram_writeback_endio) and the writeback task.
> 
> In zram_writeback_endio, wake_up() is called on &wb_ctl->done_wait after
> releasing wb_ctl->done_lock. This creates a race window where the
> writeback task can see num_inflight become 0, return, and free wb_ctl
> before zram_writeback_endio calls wake_up().
> 
> CPU 0 (zram_writeback_endio)     CPU 1 (writeback_store)
> ============================     ============================
>                                  zram_writeback_slots
>                                    zram_submit_wb_request
>                                    zram_submit_wb_request
>                                    wait_event(wb_ctl->done_wait)
> spin_lock(&wb_ctl->done_lock);
> list_add(&req->entry, &wb_ctl->done_reqs);
> spin_unlock(&wb_ctl->done_lock);
> wake_up(&wb_ctl->done_wait);
>                                    zram_complete_done_reqs
> spin_lock(&wb_ctl->done_lock);
> list_add(&req->entry, &wb_ctl->done_reqs);
> spin_unlock(&wb_ctl->done_lock);
>                                    while (num_inflight) > 0)
>                                      spin_lock(&wb_ctl->done_lock);
>                                      list_del(&req->entry);
>                                      spin_unlock(&wb_ctl->done_lock);
>                                      // num_inflight becomes 0
>                                      atomic_dec(num_inflight);
> 
>                                  // Leave zram_writeback_slots
>                                  // Free wb_ctl
>                                  release_wb_ctl(wb_ctl);
> // UAF crash!
> wake_up(&wb_ctl->done_wait);
> 
> This patch fixes this race by using RCU. By protecting wb_ctl with
> rcu_read_lock() in zram_writeback_endio and using kfree_rcu() to free
> it, we ensure that wb_ctl remains valid during the execution of
> zram_writeback_endio.
> 
> Fixes: f405066a1f0d ("zram: introduce writeback bio batching")
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Suggested-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Richard Chang <richardycc@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>


