Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A191CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C8E8E0005; Mon, 22 Sep 2025 05:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C7E8E0001; Mon, 22 Sep 2025 05:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BD98E0005; Mon, 22 Sep 2025 05:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4E98E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:34:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35ACE1405A5
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:34:00 +0000 (UTC)
X-FDA: 83916374640.15.E193AE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 984A240005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:33:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcGOUP0g;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758533637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPhOZzfo2QRicolv+Ki5Ba+EkYVJudZWaiU+4AUfAXQ=;
	b=l2hAN+WtmsslTSXVCZahZSdlwyz/Bou7tpt86m/SGZovRBBUYWQ9rK0wpM2HVHmWtYC7Ym
	lO8+YfQXsKjp8Vf4hbblmHMEFf6dEgpE93CMGLNVRXSTiBY+nk4BNmyXsrQKrbQtMTbGAu
	DSE1MTafM0wF8/54iGQi7BNDV7J5yzU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcGOUP0g;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758533637; a=rsa-sha256;
	cv=none;
	b=H/H410H3/p/MUHo43TVi9Jc34yOH9A+QvcKgylJyR37mEfI6h9YUTwW+TN7G7QTj8xJqDP
	IOK1RNsJxRhyKE/k1xGjnpNGpXHJb3sAgYlk+taAV1hJN7ifQ0Kpfc+EYKaNgn3/TfNbXs
	lszoFiPOUyMmSieOZ6ln67U0E6RAvBU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 900A4601F8;
	Mon, 22 Sep 2025 09:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E3AC4CEF0;
	Mon, 22 Sep 2025 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758533636;
	bh=jLRdDSaxnYTd9dRmlEFkF52UGZnJn8IegF1L8uNE940=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcGOUP0gXDakGBmZv1ed/AWRmcuu+UK225NC7R4+cixLxiGld/mUELkwOXNmn3Qnh
	 w/wmKwxySu97Yv7QMltH/385y3/HnOtMKDvVgc6wDXCyWpHhdO5Wef5MkVmDnHvdsg
	 gBw+5wr8q3dVl9ZGi6z13PDzysfGZ6y6JqHMiKfO/zyCDwiTGWKcmT9BbKA6UmixRg
	 kmUTJ9ijms1TstXKTmA/PdJw/4mRSGBBhJjOHNKv5iUGeZsB+gLdq7TJEbpJ7fweGv
	 +Naynd9Z4gH6y3RnGtEynYWgky2uV6UhzFXF3mv73GsU0iDWFBMHmpwNyqbUZAy1W9
	 qZVU5Tea6khNg==
From: SeongJae Park <sj@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	linux-mm@kvack.org,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Mon, 22 Sep 2025 02:33:53 -0700
Message-Id: <20250922093353.57883-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250921150830.buufaqnc7x2zpdvo@master>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 984A240005
X-Rspamd-Server: rspam05
X-Stat-Signature: z1sech59s3dz3p9huh6rkicsa8efo95r
X-Rspam-User: 
X-HE-Tag: 1758533637-234283
X-HE-Meta: U2FsdGVkX1/KcPB6QfOTrz8JeIesreWWY8hPfPQOY7NES1rzNNYSY0TKI7q4ujsXNuiMbTMO3g5aU1zKzoEKI/Biw6c8z1KgfkT8mGJFIyHNkSUxkjYuQ5mt6n7WkOrT/8URimNJOxtMkXKX9i9AaRyF+uB0fGJahBzyfG4YVigqvAsMWMX9n1LQ1Exq9kZd6maELWnpAhXONRwC9Ao4+jxGRmFd2jxdK23PkbXEDFY8TEwl6lvDSAE4r3ZM3Khl/RumO5sb+y+tIPp86kcM4wueQ8rJHYg09uHen2q87r6ieUtQT+zTaP7IIWduu2yED/n1A3kXjOHFYx4sN4fdI0g57Vkx7vHZXdQNswjUSpi5r1dDIAmh+YKHQjV5kYrcEke7mykY5/suRA6iFZz4vYB7XgGMrXB0O1PF1Tf7dVcXe81U3Fx+vxb3G4+spmAbOwuOjoc6g8UUBB6uqzfnmC42/i8J69WqBeFRpeOnjY13UXDZ0z5zVA9R0dBdso8IVZczYNsS5Dg6TpnUAHgFbraqLTnq+ZfUgupqryD/wNRthYfZYjjDG3w5XMvH9HbAi9YEQgEkI2VUzs5yX3toUB0lC83G1Z6VBspIM6Hsk6L7Ui8OQXwbpvt6sPXqBNT3zvsFqWdJUDAwHjEijOkD7T97/3iFn0jWLVnJP/kuOcEUNiTxK4f4LUSjbazcZ7pZbBTYUsFbBhnHD0nuheq4iRjt2yRhtmc/3IA69zEvbbtO944XzGXINjw7kkVD4T/M6igaTADGhuI4k+y9cltUkneNQrjpVA2xM8+LYuoeL4N3lXtNtC2DdEHvB3y3YMUtHYJNfyDznt1QBehaXoHbiNi3+Ryv6KzLbfrnUPHPhpwNcZcbYfoYkg6+LGFkpuftUR86qMfhccuXOsAvviLZUNHxasj+nIKsCL5puUED8ND27IA9vD/EZthppr2+Cy4xq2HAii68NrwDuI9WuWu
 mUVKdatN
 2yWcuuzrk6nnT2azRdMkXFyiXZsrNOTErL+qMkOWL3uP2X3OwaetSLc8Qp49Bi1n72kRJGzDDYsY3+12RKKhTlFGuer1AHfiHW0AEb/kfQFB0dnVGE/7BKQbRCnN+tksHd3csdIN7HnfOV0q1yD4QuX+7CLcqAkHnCe+r/5HypTjbrmqw6oxLpnbcHJdwluhVb7+WmpdAA05Fw8RrYfTCV//rNlF/lVX8MzPwOUTaEUElSVEq+mI3cOUwnr+H+ZojrpuPZNjfZ4QQQPvWez+imPPLhZiz2O9spvfY/8bN0axyD5KcwIA4oGKYDL8udWenrvThAZsb5Y2I4PgZ929wzH0Dwp5qb8TISOiq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Sep 2025 15:08:30 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> On Sat, Sep 20, 2025 at 06:41:30AM -0700, SeongJae Park wrote:
> >On Sat, 20 Sep 2025 12:29:58 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> >
> >> On Sat, Sep 20, 2025 at 04:52:33AM -0700, SeongJae Park wrote:
[...]
> I run Qemu with kernel built from mm-new base commit b8086c280108
> "drivers/base: move memory_block_add_nid() into the caller". Then run the
> kunit command above.
> 
> Not see error for around 20 times of the test.
> 
> Is my step correct?

That's same to my repro step.

> 
> >
> >It was also reproducible when I build and install kernel on my QEMU machine
> >using 'make install'.
> >
> 
> Run qemu with the same kernel and do "make clean && make all" several times.
> 
> Not spot errors yet.
> 
> kselftests/mm/khugepaged pass with this kernel.
> 
> Will do kernel build for more time to see the effect.
> 
> If my step is not correct, please let me know.

Your steps for kunit and kernel build were same to what I did.  Maybe there are
more factors for more stable repro.  I didn't have time to dig in more, sorry.


Thanks,
SJ

[...]

