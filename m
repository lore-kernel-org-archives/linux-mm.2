Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F95ECAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 05:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4198E0008; Thu, 25 Sep 2025 01:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B8E8E0001; Thu, 25 Sep 2025 01:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8368E0008; Thu, 25 Sep 2025 01:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 188698E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:25:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC8031DED34
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:25:46 +0000 (UTC)
X-FDA: 83926635492.07.2DE6CCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 19C9B160009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:25:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcDk9GaZ;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758777945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRk0xd5+cQAs2guF5q7YYr9CznbPHFoPg/gQhOcufFw=;
	b=1QfeyiDVyDpGiRLnZd7ZT/Odx3yfCOnY9ZVAemF+1i6izLg11DI5BQDiFqRaalGhiw+KYc
	/rPg657lZaG3H75pCumn80QI9EkY5u8HtpCVTzZJ1MHo1v6wcdDZ/SdcvQNxqTnCnLbq1N
	RgeBMCfH4p4uWN20W/IQEggyxk6+F8M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcDk9GaZ;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758777945; a=rsa-sha256;
	cv=none;
	b=hHLP1nlpjZVraUC/xVISjgIe22jKMLRsO/yGu0/HIp/jH0JOTwQz5/+qltb43VrUDp7IXF
	2iqQO+v5jjYtySIh+xTBwD7CnXV5pWsyy2qF/cgGmwRsODv7GaJ3gxCbwtip+zpl/MxJwY
	OpzoH4c5PQJcw9vj+lhmCS+0rG7z/W4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 919EF438EC;
	Thu, 25 Sep 2025 05:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A352C4CEF0;
	Thu, 25 Sep 2025 05:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758777943;
	bh=OGudxTQC2g9GWDssdOMa7QneRr36x2Z9xVSFQN+8uMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qcDk9GaZRzRW1zsoel/WbDttK1TmFSovPAg0aERxDxbLpJzCYC2Xg2VwWqbS1RBL5
	 8Ku/w0fsjx+u7zelLKiCfxyKt+7Tr+GzWth5TYEG3PX7e0+L6ONIlu6KVZ8kgphlOq
	 NxPq+5M03AgyPhiy2kfvpZBHfC0fNmX5YIlzCpZflaLCm1V/lDyIHDOyrbb67YdPb5
	 cY56TOX5b+wATU438Q4RDvuyH9YWGkqucIjosNDvLZLKapbKqw60YyQIS65UKbzTQP
	 7exEYAtWCj4ZAr334FYq8ezivXhfWnzRje0m+OR2vXkDDwkNaht9VZlA1GDsXKA8Za
	 E+tdgYgA9heJw==
Date: Thu, 25 Sep 2025 08:25:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, vbabka@suse.cz,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, elver@google.com,
	dvyukov@google.com, kasan-dev@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with
 KMSAN
Message-ID: <aNTST_OoeUxLQu-6@kernel.org>
References: <20250924100301.1558645-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924100301.1558645-1-glider@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 19C9B160009
X-Stat-Signature: 7ywnfidsc14kjadszfs48r4tie4eb8an
X-HE-Tag: 1758777944-520744
X-HE-Meta: U2FsdGVkX18ODVLbpZUNHlfb1WjFfLH5dF8opQQNbYIp4i4xzB9OFPIgvbbLVs3J1aaJEU4T+sIll/O6NC7mS9iCCGc4nvJEYHPjfEZTV/2cfqxgD7G2+uAXJ1ASCl/s8D+DFKs/No7Ns507UQ2cumBnKiVErG4GQYNeJUcERgkUR+wgVEpGfOrkfziVJgdR1YfDCZU4p9ZtW4kWNTyCEpL93hy51Tx/5FwgLS+fsNInuYmE/DSyY8O3DBTGlC1EIUkRo1RMxZWbbv9VUVNQ9vdqlQhY8turnVhScCbq1AUJrcp1b7WqZbyVwFpQJ21xVu9mRrHdFudbcKJukNqJaqkms+BGobjzJ/320c9IyYrzfp3IKLGYvI3o37FOvCfen7/IEQHxCEg0iztC1Wpz2XmOzniZVuKtdLiKj+3Op/QeU7PP6z8njeItwRJlCa0bdJfc1TX7r/RFnTKUuQVFidbOhhmU3X+CWwayCoGbw1PqcrfgVNxSjuv7abJ8/iPF/f/wiPFVMhOeEJYkJOZqTrdtlA70dIGRIcTbYDAYO9qgnyW4s915Bg0hvBI/cf4QM3QqUf5eOHIeTwJjdv0QhRE/GkmJSB6cTJ0oVuvMldVmTjNp8YEv68iMiBsN0xoBmuVDL9oHb70Wu1xprImvOajFn3Z2xaZC8K4TfLdJVggjBhyDu7eybvF/FYjCFXl/P2zpT8vNIluZDv0NzYjuGNLjCNvShX1M+yd06jt95luaCg1mPEOaINB3Ry7U2XlyoBRK1qDMc1GD0LZcuwBurPQOATsfOP/lZbWJrbgcbqkRfHUZ5BZfTVXBgKYYYLpyfQpVgOWoje+GnXIvWceHCOw35NK/IJAlGG5PVtYfLhRLrZYlH1a5TjJ289GnmIoSRpGJJUqHrVGGkzgp3TzBrfjihY4LVVEj55y4Ik88lSUMRkGCfsQHPzRewsjJWVr6LY+jvC5FS74/V8lKUZS
 Lz7fH7x4
 6JbezVikIp/m33w5OB5GIrFBgu8v7iTBhe3yhEHVAUxHaBRtbcxiWvRWHvYBpRUxV2efujm92kW6MaraUnqhFhomu03NQ4L1kdhyv1FQ3wT4n8v6Pcr/Y0oON8kLGe3auu/Xs9clms5qIxqqKggpNa/axM3DXwW5yVc/22A1qOuxqFfS4NmobQZdwm1tIDAd6f8HQ1nTHJw8dlwJaDmdYb9PwKZ5S5gatjFvbpGWPrYsw+ltbK2dCLd064+/xg8JquvD6c9cgJnwy0Fx2/4a9A2yr0BY4zcTYcA8mA2DzIAlkK76yPlDTQIxvkmYqYcBlB5z6sxrljzmWVGjAKKmj0tXUXPtgc6X2Uh1vhiqTTSn7YCb56QY0U3yn8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 12:03:01PM +0200, Alexander Potapenko wrote:
> When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
> for metadata instead of returning them to the early allocator. The callers,
> however, would unconditionally increment `totalram_pages`, assuming the
> pages were always freed. This resulted in an incorrect calculation of the
> total available RAM, causing the kernel to believe it had more memory than
> it actually did.
> 
> This patch refactors `memblock_free_pages()` to return the number of pages
> it successfully frees. If KMSAN stashes the pages, the function now
> returns 0; otherwise, it returns the number of pages in the block.
> 
> The callers in `memblock.c` have been updated to use this return value,
> ensuring that `totalram_pages` is incremented only by the number of pages
> actually returned to the allocator. This corrects the total RAM accounting
> when KMSAN is active.
> 
> Cc: Aleksandr Nogikh <nogikh@google.com>
> Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

