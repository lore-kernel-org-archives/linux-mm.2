Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 538F0C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317136B0092; Tue, 21 Jul 2026 03:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF326B0093; Tue, 21 Jul 2026 03:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22CC36B0095; Tue, 21 Jul 2026 03:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCD586B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:58:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AE14A0BE8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:58:41 +0000 (UTC)
X-FDA: 85012032042.02.0CC6FAD
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77EFD40004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:58:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784620719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIXxGEqueAKbvhH20kRRx34G8a+xY9gHjs7JNw3QQys=;
	b=YCcj9hfvwf11LjcqwAjp04PkBTP0o8+gEsBYDN/V89/YRvoSQ5zE4NAWuLM7IAMHBx79sz
	ReD4icbl+az9XUzQqYunTeKBF0oX2iZMQSt+fbo+RzFHzK0zGbMjWbQT19NCjJ5UW5xes6
	hdbspP9/bpgVRNCzxpjXrNqGesOuxiE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784620719;
	b=fY1OYvr4crg+QWlCnXWaw7OnnC3/9/OUQGJhc9av+kffbMDpHx9E+IQaLi9/Ky8hRSBghp
	GSLEqoGyksHQhM1Hzt3xuSdjzGPXqKulxDaxxjyBKZU/EstcLN1rEWKrOngLbSNdK+CrQs
	hXONz5w0VYui/rlhX3OUmwinVY5Up/k=
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.51 with ESMTP; 21 Jul 2026 16:58:34 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 21 Jul 2026 16:58:34 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 21 Jul 2026 16:58:34 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, baohua@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm, swap: Remove unneeded
 swap_extend_table_try_free() in swap_dup_entries_cluster()
Message-ID: <al8mqsmCy42X3Ewo@yjaykim-PowerEdge-T330>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-5-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720071342.50742-5-shikemeng@huaweicloud.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77EFD40004
X-Rspam-User: 
X-Stat-Signature: fxwqgfxbdq4ppdmhybe81n8m8pazzcqf
X-HE-Tag: 1784620718-137335
X-HE-Meta: U2FsdGVkX1+XmpulYZWlIxFa9nfYGXrZ5god3k7gZGtNb66z7QmtZGpAXsNpiXvAabNMQfkUisOYM9TzoUOZrTY9z/hPPylVODDScLorVf5w8nRfGLKJiu3EvQCsXe2kX8kH34btocGJ05oQLK7qrZswLJbIAOgh+bzqJSKYPmWVu3xa7byg3BMPW7n7OAwUp5d5K1RzYO3ddEausNIzIn6ixdlemBgQeW/ASYhsW6pjn5sVUE2idktx0Zhd2Aoz6xMvbsmO9ttBr34Eg+VDu/RagXKTwVT/+bmEYtLEmCUUWSTrNgKA3ojWMlzbku36bJEKEWQGRQR8KeZQV8D+pn4Vh04ouvDz/V9E4bI4YLiKuxLnkeVQEzP5yP5K1Q85qKZkRDcdokDmNvYnMZKjVOwWkc31QCZ1yKBVM8s3oAZkgTZJ99JW6tZNnFwHT9MBM0R3z0jg8aH8zvrFTc/ZFto6H5ulBjoV1PZttYjtfkLzYaS9k/kyTPiBkwJ+UH6jIqPo3wuo/CghzIq5tpXLDREaxCJHScjfAn19BDcUt25qjcXMr6/qyRxr6ACNOMUTlZbhKDveXgwcju9kliGFT7fEZ47G3Nu0uFmAZFhU/x/haf7TY2cqrtWR+ME4EIKT1E4HcQMPewhzVQsMdH7byVqcX1ZF3W0VzWD1i+wfWNl8NRAaFbxrMC0RJxquEE5v8VqHCzr8Vvqtha1JSuxbFyDEodrwV7nUENG3hLBvhcEYM9lU6QAiAqpT7qP6O97US/9lE5xGX8IxnYsNlJ9NSJviTjtQDc76h0GiW2wv2ZvuNb1u5t1fAhs3efB29NhwM7YXnrAPaiLRI9ja7zhvh7kIYZYydr30H6yjUTvcVfc9aw+anGbuDsvkLAfpugNEG1vbppFP4anYUpdULQJ2TBiyTbQUhXcpRl4VIkpRa3FCu4+yyrB+cJH87KR1cbG+n2JmmNRuoTIEw0SueTo
 qrtmzGd4
 rPzwjcYOoOISUMUCCGXtddgBz7GHSyZ+J8fMbWbOF2sZTcpS2z/OgY8w7q9WGgpGXxR3J5F9NpQrp/22TffoOwHvu9Asr+kmqKa0l5VY01jEeHVh0rVBmSsMRTSUldpr5A255Bz5vUsd0QpJon9V54dmIf+THW2Q85RuNlaj7af+7Eh2SfqbU45Kn5xNkZIdPyiuB4P73Zwq5vu4vfBVMxfQ5zH7f6WT98cOM4oeMokfumTopWixmmTxnaIcp9RiYfoaafMhS4s/0yueR+zBmQWYqXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:13:42PM +0800, Kemeng Shi wrote:
> Since commit 0475fde0f68de ("mm, swap: avoid leaving unused extend table
> after alloc race"), extend table is always allocated when any swap count

Looks like this? 395085eacdfa

> reach MAX - 1 and is always freed when swap count decrease to MAX - 1
> or MAX - 2 with cluster lock held. So the extend table will always be
> freed properly when decrease swap count in __swap_cluster_put_entry().
> So swap_extend_table_try_free() outside of __swap_cluster_put_entry()
> is unneeded and can be removed.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> ---
>  mm/swapfile.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 3fcbd10c6353..fc9f16bc2e4e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1732,7 +1732,6 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
>  failed:
>  	while (ci_off-- > ci_start)
>  		__swap_cluster_put_entry(ci, ci_off);

Right, it handles duplicate here.

> -	swap_extend_table_try_free(ci);
>  	swap_cluster_unlock(ci);
>  	return err;
>  }
> -- 
> 2.36.1

However, looking at this part, since swap_extend_table_alloc() uses
GFP_ATOMIC, I think it could be further improved by not releasing the ci
lock.

This would also clarify the situation where scount becomes MAX - 2.
But there seem to be some drawbacks. For instance, the original intention
might have been to make the swap_extend_table_alloc() API work seamlessly
for both sleepable and unsleepable contexts, and some implementation details
might not look as clean.

Here is what I was thinking:
...
        err = __swap_cluster_dup_entry(ci, ci_off);
        /* <- Could -ENOMEM handling be improved here? */
        if (unlikely(err)) {
                if (err == -ENOMEM) {
                        spin_unlock(&ci->lock);
                        /* <- Change to NOT release the lock, and make
                         * swap_extend_table_alloc aware of it with
                         * GFP_ATOMIC(aware cluster locked) */
                        err = swap_extend_table_alloc(si, ci, ci_off,
                                                      GFP_ATOMIC);
                        spin_lock(&ci->lock);
                        if (!err)
                                goto restart;

Just sharing my thoughts! (Wondering if this could be a good direction for
further improvement?)

The current modification looks good enough to me.

Reviewed-by: Youngjun Park <youngjun.park.lge.com>

Youngjun

