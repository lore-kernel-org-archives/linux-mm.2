Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 681C3CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A348E0007; Thu,  4 Sep 2025 05:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB738E0002; Thu,  4 Sep 2025 05:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17B98E0007; Thu,  4 Sep 2025 05:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 904E88E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:33:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 428CD86A39
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:33:59 +0000 (UTC)
X-FDA: 83851056198.09.C3523E6
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB79D160012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:33:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=ZmaUn4wn;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=4kaiBPQt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756978437; a=rsa-sha256;
	cv=none;
	b=xOE6aCEyJyHK6xYOE3wCsNEHgAmoNLGROSbbW8YUJH/ISKLt+usOqv6VKxZMWyG/gEn/GO
	qvsmnLmhhFsSHI4DFAF0cikIR9lhku9tjqAbsIUKibKLLiWjumupMwXIFMHuTLiGnh4MnT
	NI7ewF0xpdT4P3lUDrEuETScRr93k1I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=ZmaUn4wn;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=4kaiBPQt;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756978437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IuKTho9AadcM+Re0nAwehN+zaegfeyCAyeD2EXwBdM=;
	b=qm+SsICa4xzgfIc2KVlH+OScFlcNCW3vMhA5tQbGe0vn79OJLqTbWv6dw53w/DeS6KBZKL
	3I+KwJOrifH0zUbwA6SdJW4fp+9F/9iwZ/U0jQ7frWVSA7NrcQt6qh7A8Vx9o8MHg7LruC
	Nur79a3/b8iOi2OeqHQCyft4xAysSRA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756978434; x=1757583234;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from;
	bh=4IuKTho9AadcM+Re0nAwehN+zaegfeyCAyeD2EXwBdM=;
	b=ZmaUn4wnej3tj0YPURzSnREubQR7uz0uoH5s4PsMUCGzyOagNr+E+eR5Ab71zSmt8k5c2nin0lH3i
	 oep89GfftkxOZiLG+tMIBCdq6dUeLMfzNNgB9yBYCi6w/op+YJd6VkpVYegbHJxr+q0x1zeyhza4UH
	 APLp9hlPx0PiEPHsRmskPD0MksbRo9CfpXXt80nXlCaCYzArOj0m+KxB+06lmT389GK0UzbFTn8rBq
	 9yGzGT4OyKzNhNzQ2GSGBhoXiBRfSAXzBm9H6cbhGWvTCUZHNKMMGF4ucrns1b7x9Jfx7cMXDQ1nAA
	 hvSuoLTO0ly/VQ4byqnvjqwP6jZAFaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756978434; x=1757583234;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from;
	bh=4IuKTho9AadcM+Re0nAwehN+zaegfeyCAyeD2EXwBdM=;
	b=4kaiBPQtOZ/PWNLcFNX3C1uWz0M7ZqHYVA1wUtVitG2pKAYKIz0+b7gh2ytX5Qe+YuDykFtycLGbE
	 vE+uZE8Bg==
X-HalOne-ID: 44b5596e-8972-11f0-8a3c-85eb291bc831
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay5.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 44b5596e-8972-11f0-8a3c-85eb291bc831;
	Thu, 04 Sep 2025 09:33:54 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: Re: [PATCH 0/3] mm: remove zpool
Date: Thu,  4 Sep 2025 11:33:24 +0200
Message-Id: <20250904093325.2768507-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250829162212.208258-1-hannes@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DB79D160012
X-Stat-Signature: bea1x478rtr8bs9fkrux6j5jzdt6jtub
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756978436-768684
X-HE-Meta: U2FsdGVkX1+VGst7t6gKaUY9UegM0siFSwz3Suea3VQA7aYVEmVPYQiVGA8Q2Y3G0Loshj24wA/8qNCt3t/hAqptO3hg6vakUA4GF7PPKJOqG+Cs6lcn22oplNowT5GYko+y2U44oeiftrBBbN8uHix8tQkC2JOoU3G8yKK4rGluAMqDOD2QQGdL8UZl13+bnPvhKLpqjXb+zxWfyLHiIquT8xhOpXztkE7YTZKLTgks5PttUBANYgH919X/KgRd/Mm6YPsH2fZ6x9EXqPMfdMVk6xd9wukoae1shWDu0t3i76Et/kcQytNqC3nDxQf+St0vLekJGT1tkmw/Tie8OAuwcM5rZG0iO6xJWDzjuVCtRyQv+x9wEkQdF/lEKL1JBmqDPdqoQqgEYFCXm4dhVReeztEaoWT7AR+hDvfjnsI2yhg+V2vsGEySEGo1CJF/Ei0Ky7VIilBitWc0e7g2C1UzSZQtchxTGRWVKhLREcgMz4NS9VwxaSs1ZVSrGIyfA7Az6yqep3DcMtgA+hJCbMkh5Xnp2Wv539ljGwnET+OOIPBs5wUCb7SAVAS+MFK0Q7nDpjW+qbgmorzhJVtSM8/Ot0tFyoDDDNv5BSTtNxo+jecNecwX8z5u4KBcaKQdPITyp8O3agm8T0o1xzZPDGYr2DgVUgArSYetD2GhKQSmOU3/gTnB+BhRiKr85/8oiOEvali53pTc+gbspGlcmxTuiUqIvqy7ElODj/WBlaRaYto92HvQSD9HpLlFMiIq4fFpC9EN/H2X7jeczFTPuSvHEGCiD0Q54AWSeOBTR+ZhlyXO8TzYGQThs7AIjYT9RNaUBXgUUMHg0Rqi4GzmZzLq37jIM8zJxFLKkEk4yIJRGtEo8vxynlrfUpAravsVXeJQ8n94Zo9TQHa8i/fm6WjLcV5GQFe82ZUP6aglytbSUImsoGUaOdQTxaCGqfodFog8gEEmOb0ZGbsH/4v
 UfO2hasp
 KQS96CoFPdSSeNeFLmQcL3m4h2RXazDSNPNhJeJh5bOfUqzZ6P9AgHkZkkRno8SHD5U2B0nu7OeFg2GDS6mmG1HCq38ky+4d++8yDAkHsoXZB9nf9sMHrOiCoNBWuEvf7kkWKoHioQ3OJSn+ozdEyJbNkkcjRhbWvVs3P941injg0KjjVyOg3cOtTS6Gw9/+3WQWO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> With zswap using zsmalloc directly, there are no more in-tree users of
> this code. Remove it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Per the previous discussions, this gets a *NACK* from my side. There is
hardly anything _technical_ preventing new in-tree users of zpool API.
zpool API is neutral and well-defined, I don’t see *any* good reason for
it to be phased out.

BTW, remarkable is that you didn't bother to CC: me to this patch.

Anyway,

Nacked-by: Vitaly Wool <vitaly.wool@konsulko.se>

