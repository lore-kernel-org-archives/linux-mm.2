Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4AFACD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A515A6B00B9; Tue,  5 May 2026 12:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A297C6B00BA; Tue,  5 May 2026 12:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 965BE6B00BC; Tue,  5 May 2026 12:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 877196B00B9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:38:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BE168C803
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:38:03 +0000 (UTC)
X-FDA: 84733923246.18.1A6FADC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53A6D4000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:38:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PT5kkN6R;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777999081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlcpUkTCG1qrT1EXnPDrvOYgaqDe5tWwf+HPJSw/JqE=;
	b=5yBcOhr9RUClRZqktZp8sYGUN6HVPI7Bl7qFcb3qecYJbO/Fhp6NU5p3uYVBptMnBs5Ebg
	Q9UTrT2QkxkfqKSawMWPIhHHwO2kztQgO7kZOIJy39IgfEWknUdTLUQQf+gWxEPmSVEUql
	Q9iKFTn3fI9iDNOUITojoXkgjJtwPlI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PT5kkN6R;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777999081; a=rsa-sha256;
	cv=none;
	b=OMoF6K6UdzlAdg0MYK7RmDfXx8UiP6Z5cbG46Y2OxlAID7MQCr/TecvZl6e3u2T2nF1/w4
	UB4iENmy1Wk7hL39rdGMveoSJO7PY3JTNa4TOWbSjWbmbsj6ai4ZudSf2XeeRMVKONFYP2
	/uS/DLGRAnztj9B+JTKC2U9U7aZXSMU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 248BF4040D;
	Tue,  5 May 2026 16:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33B5C2BCB4;
	Tue,  5 May 2026 16:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777999080;
	bh=OR+cXX3O3Pn5AnhBdDXDFvoMA55eZX7aqCQYJmBcSwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PT5kkN6Rg7Zr+umAFS68riH9fPZUlYimaVd9+UCV993sVtUPjG+zgOMNOoYZYxPZ8
	 XKU3by1C9G1rulwOyQGw4c8h4sVfkr26Nzkx9wHCFLiQULmbqOqNVEL9nZMnHE9iQE
	 0Skc4Rss8oYhJUIiPKqbXtdcKYEf8XJjHmM3t8bFtgKkkGawOTHA1SeY+Nml47OeNb
	 pBPnJHtDzmrnPbvfCUO/Z4/c7dK5+syJJN959XwjlGLAK0Uft2aowz6oEh390QzQkC
	 5dhxZJTU1qRsxSb0wE6fW+wrztq85AXi5R3hT+YAoi+VC3sC7fJlmCoomP0y8JnFcS
	 iVtuXeABi/OMA==
Date: Tue, 5 May 2026 09:37:58 -0700
From: Minchan Kim <minchan@kernel.org>
To: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com,
	liumartin@google.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: fix use-after-free in zram_writeback_endio
Message-ID: <afoc5qLvK2PDQKb-@google.com>
References: <20260504123230.3833765-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504123230.3833765-1-richardycc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53A6D4000D
X-Stat-Signature: rzubiwyxgsuf6gtj55wmbf1k93mmasjg
X-HE-Tag: 1777999081-509453
X-HE-Meta: U2FsdGVkX19ulMZDaqf/oapFm45oZddR4+BxUn/yZW1Qr6we+i+vqbHlYFdOAJ2Vhyhmg4Yg9Azw/El0/oQdTKTBtzHhpuxjcqOSk1g+hQed5RO7QmxyfB9iNyXbbBwN9y+4h3pNjZ0kqioQF5iLFOkYu/93LMEb5fkVwsfga99N+nJEpQtzX6YwOUSi+xLC/0bRPUGAOPRGbVIwMq/BwZBXHRbPhMnXwihsBlRxr36zquqOrxGR4Vpev1+FICiC9HkXXp0PSwlvYIzuPmp/iWotidxfjoxnBoiB6VQy7rWJqh1O9Td5b9YjoA0CN92hTBNE6W4QWtZHXtj/JMt7xPpqNxrCZE+sENo6OFNXBe2NdE7MHX7JEPNO6eROyrlZwJBCTE+XFgfSwallXb3nqg4TFzPxb5r0yGKxiaFV4T3KTrd6Vw5bmn+gv0J+x/7EJekX7gD2v5WX8gC7on1Z1Ojp/x9aaHMYDEEigF0Ph/9d7fJIPryqhjvDSmEyLV+Nwm13GAxriOZNmeKjWOfLZt+tkWPKxUdGhI5SleGNiNULLr8/U2DBk6h/sF6ZRHMerAZcFFXjEBxALmgZULaMU8PkCssQp1WKz2Z7N9WtUTCg+KZOjvCoPtX55Msd7PX3nwMwoHflt4sAjC5TEZs+BzBWUsVVzZ0Sg9Hdgo8sgCL429Tld1TJrHM+zbAo6VkIVX/jI/4rC0BKQknxJ/Vfo/ZFPQTYymzSkLg+JDyoTDd9aMB1S4U0/bt9609dEmR7J0uWzfOnkQoKPdppVZUPIs94aqr6h+UseXYcoeIvgtOQ5bF50LWAvezHbkE0gZ3zL/MoYdmbfVsEScz2QGAAK4OiN1b0QdofhfDUjDCfh2l9Kbvcyzhz/12Dpk0TdycIK+T7GYS4RsYg8kFv0+pufNQIwVHBKyTIa4cX8ya7V7kwF7PfljOwGFLMlDvZyyKKtWDWqtlHnlLtW2h2u80
 P09u+9CK
 vr80j/zLhOjF2FiuvofRomZSFhSKhGSun4YAjJQJLa1p+C1rjQ9wvaKkebshJoeG7EucDazdNLeetJKw1VH2h3FlHp2fQo9wwfqOHRUOwRT5TEBNNVLQY3btDxuZfiph81AGMXD6xXnzofkZnebiOfqhnWrR081U2OtWTcvfVN6TH03zqhCH+/acv8sYh8RTsd5XszKxFeu6uliDSP+q9g9hNJJJRUl0arrl5eoDt6VGBT1NVNeUTZ5eWMq13xgI9YXNFdI9FlahDVSmTQ+ZGy3aaWtTpE2M9giT0o6aFZSBElDnUW/+iBMBFIfBVoOe0r54t8o+HsUiip4bOtLCIRosXEJaAbSss6XP0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 12:32:30PM +0000, Richard Chang wrote:
> A crash was observed in zram_writeback_endio due to a NULL pointer
> dereference in wake_up. The root cause is a race condition between the
> bio completion handler (zram_writeback_endio) and the writeback task.
> 
> In zram_writeback_endio, wake_up() is called on &wb_ctl->done_wait after
> releasing wb_ctl->done_lock. This creates a race window where the
> writeback task can see num_inflight become 0, return, and free wb_ctl
> before zram_writeback_endio calls wake_up().
> 
> CPU 0 (zram_writeback_endio)       CPU 1 (zram_complete_done_reqs)
> ============================       ============================
> spin_lock(&wb_ctl->done_lock);
> list_add(&req->entry, &wb_ctl->done_reqs);
> spin_unlock(&wb_ctl->done_lock);
>                                    while (&wb_ctl->num_inflight) > 0)
>                                    spin_lock(&wb_ctl->done_lock);
>                                    list_del(&req->entry);
>                                    spin_unlock(&wb_ctl->done_lock);
> 				   // num_inflight becomes 0
>                                    atomic_dec(&wb_ctl->num_inflight);
>                                    returns to writeback_store();
> 				   // frees wb_ctl
>                                    release_wb_ctl(wb_ctl);
> 
> // UAF crash!
> wake_up(&wb_ctl->done_wait);
> 
> Fix this by moving wake_up() inside the done_lock critical section.
> This ensures that zram_complete_done_reqs cannot consume the request
> and decrement num_inflight until zram_writeback_endio has finished
> calling wake_up() and released the lock.
> 
> Fixes: f405066a1f0d ("zram: introduce writeback bio batching")
> Signed-off-by: Richard Chang <richardycc@google.com>
> ---
>  drivers/block/zram/zram_drv.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index aebc710f0d6a..a457fdf564f8 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -966,9 +966,8 @@ static void zram_writeback_endio(struct bio *bio)
>  
>  	spin_lock_irqsave(&wb_ctl->done_lock, flags);
>  	list_add(&req->entry, &wb_ctl->done_reqs);
> -	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> -
>  	wake_up(&wb_ctl->done_wait);
> +	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
>  }
>  

I agree this will fix the issue, but using a lock to extend the lifetime of
an object to avoid a UAF is not a good pattern. Object lifetime shared between
process and interrupt contexts should be managed explicitly using refcount.

Furthermore, keeping wake_up() outside the critical section minimizes
interrupt-disabled latency and avoids nesting spinlocks
(done_lock -> done_wait.lock), reducing the risk of future lockdep
issues, just in case.

It definitely will add more overhead for the submission/completion paths to deal
with the refcount, but I think we should go that way at the cost of runtime.

