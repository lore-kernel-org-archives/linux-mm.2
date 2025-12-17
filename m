Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC3ED637B2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 03:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C546B0005; Tue, 16 Dec 2025 22:18:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619B26B0089; Tue, 16 Dec 2025 22:18:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5265D6B008A; Tue, 16 Dec 2025 22:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3D26B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:18:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E52331608B6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:18:34 +0000 (UTC)
X-FDA: 84227505348.23.2C4833D
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6CC7D20004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:18:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oR+cDav9;
	spf=pass (imf13.hostedemail.com: domain of linyunsheng@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linyunsheng@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765941513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUOzTgYQB8Tecz2GimhrlhEA5uFteptR3rbBR5YGgXs=;
	b=PxGui5xhvxKt0O+k6svhXVbeoIbb9934J+UgAfTrc2PJRut73Pzq13CLhKeVQkyI021QF8
	0YtVwmJ0Dt8MzEE7XY3u5IIXkhc3KPcFrQ6qoRqI6SgF37qE9txpYow/2lgcypgCKL3Htn
	zoIR+mHxoGeNThvI6R9vFqn/3jMebek=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oR+cDav9;
	spf=pass (imf13.hostedemail.com: domain of linyunsheng@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linyunsheng@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765941513; a=rsa-sha256;
	cv=none;
	b=M+SeSsmvHxt5wMXDZH18jGZAkUo8jeEyXIlZXQChkEffiaWSSfHqkkYOGTTD90Xy7OxvQ4
	BdygCj0MgCr7POu45oECAEwlXZ1fE5VK3K+e057v5VMLztVNbh/ynFVd3k16smF+Y0oYJS
	sUslQetwEOSi1L8m0RA9LUqQ1AySryo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZUOzTgYQB8Tecz2GimhrlhEA5uFteptR3rbBR5YGgXs=;
	b=oR+cDav99PZGFTqVPoFeaCYAS52GFj3uo08gPMDEQTkxU7OmAyb5HCgdGxyQ6SazlXYGjaiHi
	LwI5EP0RJW+uOZ8YknIdKr/AGBHoTK0noPRP6gNgaLKWzgVFwrcomi5c11DXIKf8Nej70xLdorp
	9SsiSrcz9g5m+iAuRptAUuY=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dWJqF3MXVz1prLY;
	Wed, 17 Dec 2025 11:16:25 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 5707C140158;
	Wed, 17 Dec 2025 11:18:27 +0800 (CST)
Received: from [10.67.112.40] (10.67.112.40) by dggpemf200006.china.huawei.com
 (7.185.36.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 17 Dec
 2025 11:18:26 +0800
Message-ID: <b62c18a2-7036-4cca-a3e6-8a873a2ca832@huawei.com>
Date: Wed, 17 Dec 2025 11:18:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] selftests/mm: remove flaky header check
To: Kevin Brodsky <kevin.brodsky@arm.com>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mark Brown <broonie@kernel.org>, Ryan Roberts
	<ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <20251216142633.2401447-2-kevin.brodsky@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.112.40]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200006.china.huawei.com (7.185.36.61)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6CC7D20004
X-Stat-Signature: 41yh8dp1ghkthzc63gdqyckg6aa4oabb
X-HE-Tag: 1765941512-531986
X-HE-Meta: U2FsdGVkX1+WuT5Adc0ePHPB37wr0Bra74EqTtqNXVB8B319ACfEooxRZfGU8WsAiyFn73PdqaW31lTFVBLxhNzEu0bUNEPXkseeV54ja8V2GSXz3/oKP+T8ADczz404vcHJYmSaR5ew7sK5ZMB0nCISDQFAJhvzWeEMw95KDL4338c0wvbNa0gYgvn5RbfUq7WMI29rqc5VDCG2b9wa5DWNorAKWw2U/e+0b2NbtNk2pQuUf/ffUhZDa/+jpior28YJGeCqtqWNIM/7GvC0KtqNwIl5hhMqHXXoGn/aJN2/HaCtFxCJQe/Lh/92stY/QCDEVP7Y/RG4CDoCL31AAZd4eSUwt9wpzodKVQO2Hn/WR94Mjv8nADgMK3BcA/93avoEzy/HDg5Pt41C3WHs3dkhlX9BK8uBDlEzDWWq4iZlZwJpUKwg+oLfpPikLPkVtZ37PFA+2iq1mwBRbYVWkz4mXA63vv5PLE7yjDMAXJoNGVPPeSSVQFksymPMdh6gUHuQmTfaB64yIVyNj8exPNS7c93dNXPtFieM03Wqdv9SfZQJKXiJvXwHSVOHstke66yGAiy6froERVixX6KA9TZ+TeobD9h8TDhfujxTzJLHTJ1iZRy4Y0sMety5XVdB9o8tbnpw5KetP5VKDQrHQbH4e8klSYr+xuCjA9D9VjGu3ilSiu57nNODKh/I1QzX+5CCVjBWwt/2UcQ+NSoxWyuGYA+YjahGgjgIMTcjtFFaDCh3D0pyXslRk93ZpT9N99HlLQFpS8Jdx/qAN76nao9HR69hy85NsVbXHD94LThywYATBnfvJzHt+ZaFdtSIDv2MMZMYbn43FQ8gsCVXv60UUJiVw7QyI2gKEQtRPgbPQVG9VaoKGth5qw2mb0RlHlRWPI0k+Dus99sO8lDTqJvHMUukbRiAZcqq0f6ay2YkKmUk5akObRBDJutWpIew5SD1EbLzZhIlRJzcjRg
 f0cAPzFk
 mB9MR4YIi5yREqU69UkVT4mnfQWge9NWWGDHzM6t+JJ6FrmQ67iL1v3miDV0IZ0krh/1IWAvEzNi2Ort1q3EbduPoYIGSC0Qc4F7bjRb7Xs8fOL1hexLFj1Dm+Au8ILm3ptN4LbQJadBTpswT5K4tqPHMgpDD3YMCGFe6xOfBSjNJdeObVvbJzrJY3QIOheWzMALLBykIVxkSBzTSEq15s6tJ9K8M9+J6J9ANQWYRFnI+38vsbCCg2yVkntaX1gZnUM/MlADKrSGWbaCisQ+E/xFH4pXF0UJc3XZCect/oCv24/YzPcLwVNKceU5NxNkgMXJAvCl96ENOkQiq0yslserHxFwweXLJSn4Em0iNswR42Vksd62NI2S+PKMLghg2Ki55edQ4Ro/0uih5TXBudVhMEUFREu2nvkAnSdpwpbFOWSY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/16 22:26, Kevin Brodsky wrote:
> Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
> is not compiled") introduced a check to avoid attempting to build
> the page_frag module if <linux/page_frag_cache.h> is missing.
> 
> Unfortunately this check only works if KDIR points to
> /lib/modules/... or an in-tree kernel build. It always fails if KDIR
> points to an out-of-tree build (i.e. when the kernel was built with
> O=$KDIR make) because only generated headers are present under
> $KDIR/include/ in that case.
> 
> <linux/page_frag_cache.h> was added more than a year ago (v6.13) so
> we can probably live without that check.

As some commercial OS still uses v6.6, I am wondering if we need that
check for a little longer, is it possible to do something like below to
avoid the flaky check?

@@ -46,7 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE

 KDIR ?= /lib/modules/$(shell uname -r)/build
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
-ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
+KSRC := $(shell readlink -f $(KDIR)/source 2>/dev/null || echo $(KDIR))
+ifneq (,$(wildcard $(KSRC)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
 PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"

> 
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  tools/testing/selftests/mm/Makefile | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index eaf9312097f7..aba51fcac752 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -46,12 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
>  
>  KDIR ?= /lib/modules/$(shell uname -r)/build
>  ifneq (,$(wildcard $(KDIR)/Module.symvers))
> -ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
>  TEST_GEN_MODS_DIR := page_frag
>  else
> -PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
> -endif
> -else
>  PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
>  endif
>  

