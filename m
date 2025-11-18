Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C37CCED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637BD8E0005; Tue, 18 Nov 2025 00:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E32C8E0002; Tue, 18 Nov 2025 00:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2138E0005; Tue, 18 Nov 2025 00:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39EB18E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:05:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7FD5B8A68
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:05:23 +0000 (UTC)
X-FDA: 84122539326.26.F7F635A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4346380004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:05:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3FLsg8oc;
	spf=none (imf30.hostedemail.com: domain of BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNapumT3u3cvg+LB7F7jDnuORw7Am+MenBUILnbf34A=;
	b=4YZAZdMqkZPW8vggh9LUziAjOAz6Ra/BOq+EUisokt4F70bit1Ex7I4g0dKc2wbCrChj6j
	dp7tQg2PN4v00JID6i2PWHWKMZE7J0IR1/6D/jA1SkH5BlKUakLRfZBJzRGyeMMQl9Eb2J
	5OlGd2IwtOovhRaNylZIXeAQN5/sSVM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3FLsg8oc;
	spf=none (imf30.hostedemail.com: domain of BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442322; a=rsa-sha256;
	cv=none;
	b=VGBc50Iy5eoWtbW9y7fkdZEwkTnszohR/Ny97Pt4OuZk+JrICpUCudR12rxbRu1lmj5hRN
	/ILPCSpDz0o61cwNLlBtPtMSypaz89MUAVzKU+As5v5XCWsLZk2XtFfzqX6UHRUssFgN7E
	Rc27sjGcOWwLBGH+Vxo/z7L4FfM1Ghw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HNapumT3u3cvg+LB7F7jDnuORw7Am+MenBUILnbf34A=; b=3FLsg8oc/8SF/EtTA96c5fyT3M
	4DeoEqtENiNgzKY1vcGzYH+/o+gsVgYU3B/3LP3UZhd+MKzEpOKB4aHyZ6JSl5nMLVMLolfilj/Vn
	V4ECNZnEH02rbw4uR2hVs1d1NXUxksldq9n1m500Hw1z7sKEAIR/1xsjZeSqjddazSY9npmFNJnb2
	ZXDUGHaILXo8NljKBcWAxKr7KsiO2wixMvya3QizH2aulIcTAFYBzbkSrYd6XCnCXAlNhoqEDTJ9D
	RLqQjiyQMyp5ik7gte1/pEnIa03haz5iZNQSedAeVA7Be3cfcWM2B7AKu4l5AGe1DDZQpe06jqGK2
	wvV4Qa9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLDu1-0000000HPKf-2dew;
	Tue, 18 Nov 2025 05:05:17 +0000
Date: Mon, 17 Nov 2025 21:05:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aRv-jfh0WkVZLd_d@infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 4346380004
X-Stat-Signature: sa15zw7suiz5xaodj7iwobeorhkprwsy
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763442321-449154
X-HE-Meta: U2FsdGVkX1+x2W4FEOXrPkGF6gevX7eAlmJiUj/vCpdLAAZml+ksRX3SY/Xf6OTB4zx6QoN/nZfVM2kTd7oqrLOfBjF4IKD+6+6Lifu1ji4FnVCReRohjc//2kOHqcVKU3sadG59LuFEjZOrTDFZgrLIIYaBlRpHcKbLFUz4kX+1+2vx9tXm2cdT8O8lf335oJqIh09Gm9AHW5aIH1JWV5rG+hC47Sel2SD+kewT+kwU44bKdifala5J5OJKVPqoqj+NmLvNMlKdmOskFM0+tldjMcjnCRX0YrczPXoXze0jQ0B/9D5DljDqW3MyHNyONAGHvkFIpkouoquzWdTEGaUxldz2nmCFqXWmUNuLZ3qjpklnIwahHAeiz2DViduflskptn8orRUFwe6RO3DhoBZJhsZErBJwDUFu/YpoVU7Zlds82Wx3v3dNgRJPSlDowPe6Yga1Kq4IQVIdxW4K65da3pIh+m2/ZSgCs3k6T1DoPyhJ2OTRVzeQpAcTgDxY+ScPknbwLbTbGkiK+zwJAgU25nB48Bmbr655kcU1rpXzrgvDiT1EdMB4DNfgWzPW5fwUV2ET7T7EQnBRH4zYnB8KA5qyc+VKNc6jrQ0RY9u8KlezxyBGPd2MM70BSFA5fRphbE4xXP2rsNAwOBSUOfh/s5Jo3wDBT7hZGduxb5FZrdvhwVZ1HFiz98R14jcE55vuzTXd/UFpVGfNgVm5/r9/m8pSBU4QsLmzwLkoV4rYtx5V7PL+u7m4gf+2WIYWPFye3lzsEV9pW6Yje/V1pFRQuJfUVmMTqGbNYhnxOok8ivFH+Q3loiGBoo7h+kiiqQu1nF6ZZmqu8pKck35EHvHg2ar8612gu1f5vUDNfpdEB8mr+1DKk3HB4Hl/pPuKRFjyi/znAV5QgZIm434YNyP6gAo2nxy29m27erx4RPXWktMRteqNgoAgLakqNLy3BaJTuRcVFaMlAZrdTeR
 zSaAibXa
 9nSYb68aAdMkyv70pxxQVE1UTfx0j9/KYu1bjBS/Q/9IukfpV/GlUGkua08sH4efdMAm2jOXWwrlKS0CZ4HYj+xDzSssIWvAo85Lua/hTr4Bhs16Kb7GBcLxTMzfaiwdjKcJoUo57CMWBqne0I04r+w5sHU48JQApPL5IjvrCQZp61J4EPBq7NVqAr95KKaXFDu/3FIzBQn1S80YAglnY0EfR9z42wj8SUSf0CVM1BNb39S5A0BNEgU13E6wRbWkA0P3OsvGCzsleeCdhVZeebCGN4TJ5UNoQaIFSQOUcabAUF8Bie0DwlAnV0zfj/8Yh9OlvLAsXpPwQ3ESLhwg0PZCHlPH9cUxVawqqcXPEabvfRywa5pLa3HbYQZeBqQ8mIbExbaGZGmpMxQEArHEwDGi2M7Gvr+zbsy7+rnsLuYq/eBXcNKlcK1D3utuTdSafcfmDc90dUwxXCh8368kkluH6GhosyYDYnY/B5lnY2ZaMVbaf81i05QuHpnZw5pzDpyzoD4ZYYXG3LwT2Z9YIW3I/voZv88VXEziVeWUG5BBgJtUbM/8ThghaSi6EFABb8i1wl3EL4JJ93YifH+HbyXaATsGY9eoJjDw9RzPm70ZhXYopaHzwR4M9ND2iM74LbqHznrK1hFzagNr3hgrcLoSwutY1PVss3Bcp8CUPSDJCG2FA9BIZxyJ8k7VjGaYKdg2VrtwrrNKAIrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 10:32:12PM +0000, Matthew Wilcox wrote:
> I don't think it's necessarily all that hard to make buildid work
> for DAX.  It's probably something like:
> 
> 	if (IS_DAX(file_inode(file)))
> 		kernel_read(file, buf, count, &pos);
> 
> but that's just off the top of my head.

The code should just unconditionally use kernel_read().  Relying
on ->read_folio to just work is only something file system code and
library code called by the file systems can assume.

Something reading ELF headers has no bunsiness poking into this layer.

