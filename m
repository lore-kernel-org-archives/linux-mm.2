Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E314B606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 01:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SW39g62m
Received: by kanga.kvack.org (Postfix)
	id CFFF16B0192; Tue, 20 Oct 2026 21:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4A26B059D; Tue, 20 Oct 2026 21:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6C16B059E; Tue, 20 Oct 2026 21:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5206B0192
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:57:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6088B1203F8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:57:22 +0000 (UTC)
X-FDA: 85344971124.25.0590971
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E35F1C0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:57:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SW39g62m;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792547840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zMi/65hYb4icVfgLOTZNJ+TTD2i0/XvV1mGmiRSo5c=;
	b=TY+Rc/H3v4e0hZ08q4z/BAgExqhiU/+GFvApLYF3Hs3GneS0y4SkJijG+qN1Qc60je/YGA
	I50C/bseDETFGomxb7wtLoqAjTxR7WAl9aO+S6MEKpBpoVTzND9nLJzKI921XAI4k+mm21
	c8hXvL4SjlPaNmhsLfnDAm/zDxpQiYg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SW39g62m;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792547840;
	b=SC6wW6EVf0YW84x/dPM8RKFloy3HOe5u/jYxFvqEgXe8VDCHlmfFHIsfegmpjxbHpGL8td
	iHZVv7sRzwZR7aOQX6efNhOkCt2ftIS75ohF0oAoAfy0uxNbyggClHhv154oCOS4Hy0fzR
	jy+JuXrvlCTQ8bauGqjQjz3v2wc3tdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61718409A7;
	Wed, 21 Oct 2026 01:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095571F000D1;
	Wed, 21 Oct 2026 01:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792547839;
	bh=+zMi/65hYb4icVfgLOTZNJ+TTD2i0/XvV1mGmiRSo5c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SW39g62muPgqyFTckNU7VOgm5KdXvPYXlN7Q7nzq1dd+EbBcKNERDCXCQQTo4G1zP
	 WcAhzipv9+PXjXeqgC4zSDyLZW5xMItrHbsi/+p5Q5NOhAkFTj3NRt3I8Ais5ZTyGQ
	 qwMlSInX9oFUF43PdeuHmTZdM+fqdta9z+E1gcyo=
Date: Tue, 20 Oct 2026 18:57:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, shr@devkernel.io,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: avoid 32-bit overflow in dirty
 threshold shares
Message-Id: <20261020185718.1d17aa486a19c4ba88a005fe@linux-foundation.org>
In-Reply-To: <20261021013046.23997-1-dennylin0707@gmail.com>
References: <20261021013046.23997-1-dennylin0707@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E35F1C0003
X-Stat-Signature: aqjrfssufmftnghe3uixgesdug3uzqsr
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792547840-11121
X-HE-Meta: U2FsdGVkX18aUU/HtkfBqGSsJaXdq5X40RXEdVTpKnPlngNRL3fWA61eiruqvJOMqXztmv0j75LI+eNgYUF1sh4CdwvJCq1vSHmgKPjE5XQO0KE2qjjxU9Xp9oLXxMtV7YoiaMXmAzGOhCDydoqKOo4YrySeGRX1HmfJpBd3k+fNY0QFWezK/0JXQo8lP+j07T4AMd6KLgwjZuZX+xkMFXZgqinvGIgaiwpzzjwzmfo6tYEIH+UrorifERBE8ciYfJtcHAoNEB2RVA9yhJjz3xZR2CN9q+jc5Dk/c9qnG4GH9VHNtaMP1pY8DsTD609CdYcnOhYvNtD++yxoGBqQpHYgSPh0sp2CgcDTWlL39GmjNC2Zre/ISC1m/eKT1kgQJFKeVN/sAeANXF/AL3KycRd850OltuhoPsDafFVzJTX9KgNWVoS68KPEVUIeCh7vAsTXla7HC8uJeRZSc6zE9BT+9L+BOiH5IMK+OIF5E0l7idYy6s5gjRXApLY7LjO9WXCDS3oZEXHn2f39yfDmoxxGPy/U5UhB/3BLfCn0mDrFTH4tVbm2rFzschxdKDUTT6TvChbcR619VwPwPimTYaIeGPbEERDrZSCADdUFEuRfqwRoZ7rH6mBQvQx92KpXc552CdakoPkLeuZ2Z4uzkv4Cxp8L9CCwnyFUAp3sjW8OyAfdXdJyPLyKDuye+ppqmJfl71OgpAIPzMxhsg6/YSbJQXCr2flY4k/eodvVZYzvwQpHTLv/dNw474tJL5/jJJqyxld+bjtCSm7ld1i1tiH2g8J6vmab91vhcZCkdeqWSkoM+eW8f/XqgwRzODhDCy5cwaqQpZlvJJ6z1xQtAq3vP+OWajYjBlEfik+T3TUQBHuSncgsG1lGGxCMfoAmjIeAX6+GuRE6xy3vqn0/J7tY0bznIaIEHrAbdx6Cj27pNfAs335ZQQhcRNankDFgXZTouwNFPHiGWftH9oA
 uLDrgXLH
 VAbvTBn9NirNrRNvAZHdTGwyKx9cdn1VMIpryVlftDLuf0OPA82CUnfsfbLi2h8xe5Gb82Omo8wgZWUzHmSyhvfrGjpAgpTzH3OLpW1Cm/4BNk+1v324nrQ3Ag/DK3vBMkYpKMBgoh8JIvC464VTC+ipGuvcUqXXevT+zdcO3RodXL83RgxwfTnN19JiCjrfcQww+YUO6Jlpvaol28IbQjUB4hmF+9WY9nNV/RpoN9SFPY2hRpgGRs9637osUIVn4r7Zrk44MU5q9NoZFl6KQrWh93Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 01:30:46 +0000 Hungyu Lin <dennylin0707@gmail.com> wrote:

> The ratios used by __wb_calc_thresh() are scaled to parts per million,
> but the threshold and ratio operands are unsigned long. On 32-bit
> kernels, their multiplication can wrap before the result is assigned
> to u64.
> 
> For example, with a threshold of 25600 pages and the default maximum
> ratio of 1000000, wb_max_thresh becomes 4125 pages instead of 25600.
> The shared threshold and minimum share calculations can overflow in
> the same way, producing incorrect per-writeback dirty limits.
> 
> Promote the threshold before each ratio multiplication and use
> div_u64() to retain the existing division order and rounding.

Checks out, thanks.

As usual, the need for typecasting is a signal that we're using the
wrong types.  It's better to reexamine those typing choices, rather
than casting away previous mistakes.

I think that if you add a new

	u64 threshold = thresh;

then use that, things will turn out more cleanly?


