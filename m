Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0E1606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rafqYhJO
Received: by kanga.kvack.org (Postfix)
	id 9AB2E6B05B3; Wed, 11 Nov 2026 19:26:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982DD6B05B5; Wed, 11 Nov 2026 19:26:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C0F6B05B6; Wed, 11 Nov 2026 19:26:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62BD66B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:26:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF149120457
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:26:37 +0000 (UTC)
X-FDA: 85424576034.28.18E531E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id DD4D020002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:26:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rafqYhJO;
	spf=pass (imf03.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JaUIX8TvleTZ/eyRqexb46r9ox6QF7gVm6ONPKED1k=;
	b=SohE4FO/jm6UdG++iU+Um/CYu7g4vb8mQf2RrOBtlcVpSnyDvH8s096arIZLfUDnMf81U4
	icmy+u6CD3a17+0GM9QU42GiDOMeQNhEUGUMBRrVXX32ySckIt64rBo96I7bZSYD7wxJt4
	R38UvXWa7vTZKkVoAJe1rNW1vNfTGko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443196;
	b=XQ4Fn5ooF5wF/zqEreroDEZmLu5EXlYyYyf2DwuzDQZvIQ10Pe/bRiIygF6BJtLPqIC2We
	3a/Kn3NtykXKXAYAsGgcgJHKio8pVHzS6GvEL2wNugSc8os/NU2X0c7f5pztTbVzLpQR/W
	rw6w3GCMMghtCOqS3FsNZisTwpDfrSo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rafqYhJO;
	spf=pass (imf03.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=3JaUIX8TvleTZ/eyRqexb46r9ox6QF7gVm6ONPKED1k=; b=rafqYhJOPOa4iyEQfoTvTZ4K6T
	JVbDXCbUOkzGjrQC/xfo2SUILYVmHnv+jE1DpCEUr5UyyUxk3wCBssj1LE/zlM9WK6X0g2rkRthwf
	yvfLdVgeFnsmpeZ63A8wNgZzMoPPVqhz+1cMNxhKwCoJxTwN7iPj5kz2Je+KnDPde5Np+p7Pg9+iO
	EOyofX6A557DYr4wnLBnWDkTd7V0+fj6dLF6mYRJ39yinQRTOo/ezE2ND398UgI9HguHC9op42+ko
	fsvSXzyYASfK+vM9pYCGI+HWF0RRni/yWCbKDFhSA+4aIBXHGZTApjFR6G3Fukte5JrpDtPvere0F
	Tj8w+vCQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRIe6-00000008Em9-1nv8;
	Thu, 12 Nov 2026 00:26:30 +0000
Message-ID: <a7b1d671-18b0-44e8-b112-ab66893b3bf4@infradead.org>
Date: Wed, 11 Nov 2026 16:26:29 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, Minchan Kim
 <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>,
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Helen Koike
 <helen.fornazier@gmail.com>, Vignesh Raman <vignesh.raman@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Nhat Pham <nphamcs@gmail.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: coyyjng48ftmxz37msd6j59gcseb6z7p
X-Rspamd-Queue-Id: DD4D020002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794443195-308858
X-HE-Meta: U2FsdGVkX1/E/Isv/+yIew2gNsxL565cHs1pSm8DOwzfLKWspb6zmLBSaUA6Bh9LvlFQ+jaymDM+3itvCACqa1JkLWB5Yt5b5Bu0wdC94Qu1zv+FsGSl3mC9pUAnQOrK0A65jU73bQd2UuR47a/Avuc5i6BL07hqzMLkF3Em2TfZ3Y2oLHz029sVRLfmhm+ts10hkIyLPx8ccLYZ7lTb7yvgn3J+vU4OIPcGaIow6MZvKxbFsUFjVJUndoJpQVLiQ77mbk6Eob4mL9l6ebvGUApS9JTtm4sprKGAAjQjJDdbyvvYkCkbpRgP25ZQhQd0NLymFzua+b2hZ38+0aKAbVi/pgzMyO8MT4KYXvTin/0R1oCwy/68wibAC24HTBNEKGqRxQA5+Ed+ggamm7r26uNNCW5PsJi7xHKfxH7M3lU5y3df03HZLuj93pTnIECeNBbo49BkEiS9NEAXpKHKVhUqIhcjQfLr3FzgWmLwJDx69DKd0FcmkgOBibmimxntO2c4ZWs6JEla+eu4ig7zdzhgvo4ezZJ2jinGdzExKFg0g27NM/cpyfr/w2FEs335o4kAfsN3QKLiaUdwZMf8KGSU5BsWBeLCVLaNCScwdkzv7s220Yp36q8a5ZlOO4GntXl/Np15Qz/vCZyDY4ybRnBfjBEu454vee9v8fcwsjSP5IXDVyMbIar3Q7LdvnyUGCc/5+LoTzH4ptvrZ74GYomEdw4aKt7XsXxYZzisK3iBkrsxkDWSyvaewwc2C9U7zgWzkiTa6PkwgwgF48LUv2CFrxvq+3bKPj4sQO5Lz9Y0Jc4vCpubJRTHL/B3nbuGx0/YKBcGBW3RZwifQKwHwQqR5YFVHKBLVdUZOoPv6gTUUz7zmpbHbNkZcUSliY9CmOEq5XaMXNtWucFEHPLNhPw2H/E3nhDw3YrrOifp++PJABifIew8a5MF1pflxAtr7K4pmPJ3K1ybyRw1nPE
 8xGcd+uZ
 gJLVYntI5AhCk7uYgx7FxX/bOPXmdAQDP96GE3Lbaf2ouen/vNJ6ZxgW+PWAuaD2SYZrtldYEsQu/S3zjxKCAjtWFdO5Vy00UDIjO759Y6vT9pJksgeS0l6Cj4bDPse/xeA+Zulik/P99Hjz4MBKLWnmJtDjQQ4cU2beVm1jU9qLNgyp9rIqfw51+9BPVsh10IN3yQlzgaGGfCFShZASAhb2Vd2bROx1fhwpwDZp+rNlpRZwhjaTs7b9GON/m0rL2et1exjoWvV51zWZZxAKQbH18YhiXd25B6Ad/ck937de9F4hplCJyi3pZtUsxZkl//RzQpWtD13Lv/IYe+tDN7j8Of3tpRkhteRba6tZEsCgwbp0BAMPFGghlWy1NENAP03EdSm8Oy5bEwNttaeUnodCusktajc3MPo67iaUSsehV+EZJrbBeN8ZqeWK+qfjoHr2+1L5LhtkJFInMEICJL0Fu1TTAdYUbYrshOm3gETe/pEPZTi941XgTmOl5RFQQ18M4dj/fGd6CXxw12BhKbKMURNvs7Z+GlT+2f8DcNpMTGFd0cYMW5t7ovqYub3bzFz2vljtIwRSY6Mo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 4:41 AM, Xueyuan Chen wrote:
> CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> counters are updated regardless of this option.
> 
> Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> debugfs is unavailable.
> 
> Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> documentation to match, and clarify the pool name in the debugfs path.
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
> Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional. The
> option only controls the debugfs interface, while the class counters are
> updated unconditionally. Removing it simplifies the code.
> 
> Following Nhat's suggestion, remove CONFIG_ZSMALLOC_STAT and rely on
> the existing debugfs API stubs when CONFIG_DEBUG_FS=n.
> ---
> Changes in v3:
> - Squash the three patches into one (Nhat, Sergey).
> - Add Nhat's Reviewed-by.
> - Update the documentation wording.
> - Link to v2: https://patch.msgid.link/20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com
> 
> Changes in v2:
> - Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional.
> - Update configuration files and documentation.
> - Link to v1: https://patch.msgid.link/20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com
> ---
>  Documentation/mm/zsmalloc.rst                    |  4 +--
>  Documentation/translations/zh_CN/mm/zsmalloc.rst |  2 +-
>  arch/s390/configs/debug_defconfig                |  2 +-
>  arch/s390/configs/defconfig                      |  2 +-
>  drivers/gpu/drm/ci/arm.config                    |  2 +-
>  drivers/gpu/drm/ci/arm64.config                  |  2 +-
>  drivers/gpu/drm/ci/x86_64.config                 |  2 +-
>  mm/Kconfig                                       |  9 -------
>  mm/zsmalloc.c                                    | 33 ++----------------------
>  9 files changed, 10 insertions(+), 48 deletions(-)


-- 
~Randy

