Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D56C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4B46B0098; Mon,  7 Sep 2026 12:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5336B0099; Mon,  7 Sep 2026 12:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293766B009B; Mon,  7 Sep 2026 12:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFB746B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:43:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CD41A01EB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:43:58 +0000 (UTC)
X-FDA: 85187538156.09.63D1E8B
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf16.hostedemail.com (Postfix) with ESMTP id B86A9180009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:43:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=j2vLVAu8;
	spf=pass (imf16.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1QoYSkh0C9sSQm+kvMmLkOqIVg1cx7vAvkOyyyUjv8=;
	b=7YQX2Ald3426MjgbXQCccoWuz8rooPUwnt2nj91la4oMR7b8Y9+56PRdVVTgfTXv3jr2JI
	+gH4JM6kLov8oIplWv9ElYfXQWmCgK/HQjdZPkMUK+FqWbO5b7U58ru+NbMAUhZj0SKpde
	Pkq82j1hPZ4R9IuRK2CYbNgmY8txNVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799436;
	b=BDVcKZM1dqrh1fzhiYzrXZ+1MCf/w9dJ0bEOGsJ6px3nhJM62JaXaghcdjQI/Ifv55PHiM
	a4eeBLV8PI1yA4D82M3giZFkHcMGHB/aFU7PbuMrBp7FC+tOmTMtt4Ya4mdlkR8W4WSCYI
	WoDIghSjcig19T5F1OFiNEeS78Y5x4g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=j2vLVAu8;
	spf=pass (imf16.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6A072408FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1788799435; bh=K1QoYSkh0C9sSQm+kvMmLkOqIVg1cx7vAvkOyyyUjv8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=j2vLVAu8BUfrPUfw0IoMLttB9KWrQwcIEceYhLSk9uQ5Z0ckEPVfOfscBHEcW87ni
	 hmLInIrqLiwmZau8RpCopP0torx5zxcmYmnd8yNCifCDJ9w29pnYUhYWaLbp0pcmmI
	 K2EpC+wXJqbVWmqIDrNUlyN7cb+dQaEa6MBWRXOQDvNzkMu2svKs+2K1aRQnRpKccs
	 Bbt88ebw4fXNUuc5uDyjITojN/i8rhtRuLeabCSaYLpQLF1zP4BoWQ4u58OIZ/tQRo
	 JVnPV0O3/+B5SOZ8lZUwSg+I+zq3l/9klm1cKAo6XqVrn/6ohtHCdsYDF3+NSB07BI
	 bj19j/y/E5ZhA==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 6A072408FF;
	Mon,  7 Sep 2026 16:43:55 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Ebner <manuelebnerli@mailbox.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Shuah Khan
 <skhan@linuxfoundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: locking: Fix bracket
In-Reply-To: <20260902143936.703665-4-manuelebnerli@mailbox.org>
References: <20260902143936.703665-4-manuelebnerli@mailbox.org>
Date: Mon, 07 Sep 2026 10:43:54 -0600
Message-ID: <87cxupovud.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B86A9180009
X-Stat-Signature: hi3zfjuujdcew8knyot5gc14ewbro9fh
X-HE-Tag: 1788799436-593329
X-HE-Meta: U2FsdGVkX1/lHav4t7dN84Ke52KERmJWKljhuDVGJ0+uQqTtWP7JZf64eAV2NtLYac9c3Q+9+kqXNQUBq8e8IkETUYI3c1brdzrE8RdFs5ldjZOZ3JpEMnCpOMG+mR5Vs0ndhygR8nw2ySe60f7rynYkr2TNknX/SLu1bIaYhTIfoxbicQSPP5a74k6wvnBMI/zJYL0PGoRGt7VNR8GkeCftWRUESFiQ3FO/OeA3xflhTXBnwcVPDSSdX+uecR1GBT+dvpkFMIsuWOzI4VcYqEUrAG/9lJp23JE/igynCZ6ra+ED+lng0on/rccUb2xHZe20j5m3NsbDemDYsYvyVvG93sGxilTQqzHCb1h5zvzk4anPUcxjBLPaOT+NMT19Ejgr5XGb5i9Ur9rXU79fyBjHk/DDsiCWcTKSDTcc1/u2X5tCq1xrCLLCyyPIlN3UkhNe2Ws4gekajgiySmGLEaTN0aohyM2VLBNCiaycRK/2AfXdCahztl36LWVOINyE/Okmmw+F6sGDoTkGD9Po7HwL0Lcd7b/ESoYhH2atMicij+/ZzxlKthtYo8Ob3bimmObHJjKOMkD/2SGAnhcwTp6Z4nCYw63xFCL6v4ZtabZiA0PgBlmjmIl8BaDxhEbzsuGNDLG7uQhf/g9a9p24eX7tcOU9EvysrPgjdMs6Y5N7TsL1IkHo9Md7jHUr+gv4WsHy5oR+7VQxJWPTw8Kkwy+OtVt+uzgZF/sj8h7REqjvLm37UgFdyj+AfI/keC24ix/T+Ya5AvVmPx0prIn0MSwuNKVVIsOL4DMEXcEJbJqiqocFhVi/7LhLdb9PySNKvQLt+9G+b8hqUSbhrvojxr+9wE/Qj7WfOj8TN/Mu1rgmnRW9P7iva7sxgOi+XRNkAJ0EZw6unUloaX22IcV8Jy5L3n0Mx6Hi+CUNAI1QVfctxPe+J5FDLsdQUX5kxJmGPX96V6d+YYbtpkP9G9c
 LHP0zYih
 PSyJIzI0qSIk2/AHrGUAN+zIZCbDyP7iviJBRA5JHmXMhLm3X1O1hUK72OCoq+BhA7Ep3w0Ei59CiodIHkSVqkXmFZJjIFczXmW8yH1Tek/bQVhnlQ6EaswiD/dRr6YWrTiyerVv9Yjo8YsgS6q4cLC/mHzhNECZbV7oxEGyNfdMt2voZdJ+otGqLNFV9v9B24U+IdE4ZqoGyLsT1F9V1Dyq2LpYkbLF4OI3yzDn6cKPSu1QeGxETbZf/fq3NOuizPE6G4vHBDGZyZEA+uFbQb9GCIC3AcN3FwwD/Q1NAO/iulZMTZX5hThhbr7HKxI4F+vEoj6m0E+vtN5aEXKJg1DBcgfIFq79Ruw4VAjxI2mXvhokWjzxNFVqbGLgdC04ZICVz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Manuel Ebner <manuelebnerli@mailbox.org> writes:

> Remove needless '(' from code block.
>
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> ---
> Should I also replace ')(' with ') (' as it is in the second code block?
> It would improve readability in my opinion.
> ---
>  Documentation/filesystems/locking.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 844d65eb4..1598cf555 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -27,7 +27,7 @@ prototypes::
>  	int (*d_init)(struct dentry *);
>  	void (*d_release)(struct dentry *);
>  	void (*d_iput)(struct dentry *, struct inode *);
> -	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
> +	char *(*d_dname)(struct dentry *dentry, char *buffer, int buflen);
>  	struct vfsmount *(*d_automount)(struct path *path);

Applied, thanks.

jon

