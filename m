Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4F3CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBF3800C2; Mon, 27 Oct 2025 19:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7EE8009B; Mon, 27 Oct 2025 19:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9F0800C2; Mon, 27 Oct 2025 19:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B8F938009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:35:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78DA686524
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:35:47 +0000 (UTC)
X-FDA: 84045503934.01.9D01779
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A8DA61C0009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:35:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DsgRW1CV;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gtlWGlf8Il3fDP1MGAoknIABk6TQTdJM1ZjO/034mk=;
	b=oRQicnUkPHf+VZSlhXuQdEAGl4YZYIH3mCed5RbEWf2NgK6D2pI62m24hoQm9uW4Z78xuK
	FjH66kdaTqhmWC1cyVjoS3Q4gOcFk9lghnGUGt+SKAEcLyJf/EcUPagRn5aABCRy5Jw5Vk
	j1VXvRNYljt+dJtTd5F+NqJabET5rGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608145; a=rsa-sha256;
	cv=none;
	b=A8fs734jifH1A7UC0MTU3rtfXuy3VY+OcPffeind3B8xsyT2cRq0IcCyDyf729KZ82Ort7
	h6+FvK8iYCj/GbUybvGFjT5SYx1adixqeGx6847vg+uMRZAJkmMD8GZ0gl896HNHp2IL7Z
	K2n4UtgQabdfqOpqkENw2HxoFPjiF/4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DsgRW1CV;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 651EF448BC;
	Mon, 27 Oct 2025 23:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB11C4CEF1;
	Mon, 27 Oct 2025 23:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761608144;
	bh=hwP/ISptcED0C3gyAgZ7TO//hrJsL4mtGE0vyK8MMKY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DsgRW1CVuz7pf/7lDWSQnSrE5lGx71T5LIt5ghrJXhpQ0KVQ23X8tAhdxcLFSfPvN
	 7909z9taUvPExsiFMmji6rakj7APUszplZBRGGnGCRr5e3EuRfldu+w6U61snmkSD/
	 M4CgCrfH8raUQ+gz3eGYh6/lUUi+I9KknzqBEWt0=
Date: Mon, 27 Oct 2025 16:35:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bajing <bajing@cmss.chinamobile.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the problem that kunit cannot run
Message-Id: <20251027163543.bbf0f6bf9f81c3a61afa48a2@linux-foundation.org>
In-Reply-To: <20251027091231.1770-1-bajing@cmss.chinamobile.com>
References: <20251027091231.1770-1-bajing@cmss.chinamobile.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8DA61C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: yhwfcrkc3h91y47b56z6uwwnagaqjpb7
X-HE-Tag: 1761608145-870832
X-HE-Meta: U2FsdGVkX1/D8inkb2ScVs1S6/4HYs21sN/Kj6Ldp1SutVHZPPWAUttuoa5v+tW/mvORG3w1IXaGFYCPSXzyD6Q22xsbSMOnI7N9KzBUkezIXRgUjwfF70kFoNYPWdt4rwaYr22c2UaTWuRqKshZUUtIPkFhCfyYNpbqLa2gnxmAbuHB+O8kITJ/yYRfEgJlYeIory09wzzx88saHJS5cjAZ2ltFg+DFyZI00rXk4jgB9czquBnpo5xN3+5NwxMX+1EzgYJHgbQN/djVFU6ao2k0VBHgRo8Xq8YYiTeEy2JmcprmhPxOrLLxz3vsIWep54Z8cetq363Eh4CmY2gYEnGJLbUkb0kPnF0KC7BALbu4g27amtxe54qrbMdBAiIDqx+6Cf8pbBXW55yeCTFWkLu3+to1AoSHmw4BVBSS7GHK3Vw9aXwh3cg1x5T/DdkWOD9q8QT1jYqpURQKcGLIGc2xb+QCt29qcL3deQ4T7wEQJSUXHqGk1MsdC3Z4w0pxdhJprXYzdIRLQRM1UQwDtTp6A5sbSG+Sbj5uAeua0tafKFpkC/9yTmmG4ZqAHm4PkDI5r0TaucvJCxttVxhqtU5XefhmodE2CBs/R4cArV5a5sHLyEyPKDjP8o/OQzhbB6n/tsE+DmmXOZTLBRPZTBeMn/O8XV0uu1Niu6Feq53oq83hN/Y0v4V99i/LlsEBLjuiv1NijoaaDNQavUw7GnNz5bI8ihnVLRh0l7kqavIe+nu4pX575ObzfzXPkjnec2Vse9a6pKSiBglG5Y2QP30meIgDKDY6LZMqhbK2AxUGshD3J57CSiUpteHRP401BqJ2a3KNmDe1HRo/58Qu6YhyeVYLHjvE/KfaKpLTPnA+9BqibrO0l+Fugig42CzMTizqK2JmF4vvkLMLpe1K1vX701Mar1zoNDrSNIcgw9451dOY0kedh1NV0+ZSAqLVb3MwNuktOe2KoDtf4hh
 WHtom75p
 CM/w8EE/plEILeMp644+8/IOEZXe9k/3WcpAtjvNa+glfnxfsuaGMnwOrkrZkDsd6juu0MuxLGyPf4awfC76arvaLchb0eg1jOv4KrXZ626t9/kXfU105o9g2krL8l070mXl2q8HTnLa7I4LGH/kSBr/On1EuRY9EnHZ80q6Bce+dxiydrJPDFuj6an2Q9x+0c42OoGQIkzuW3CvXb9rb93CyWUXa2VvilsqLDHuqqfkp5xavQPClXi6QJ5EVXPq4OxmDYPbDmt3mV4GFhowpwkdEuRGYx64WOGohTJ3EdGNl6IE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 17:12:30 +0800 bajing <bajing@cmss.chinamobile.com> wrote:

> When running ./tools/testing/kunit/kunit.py run,the error for mm/swap.h
> is as follows:
> ERROR:root:In file included from ../mm/shmem.c:43:
> ../mm/swap.h: In function ‘non_swapcache_batch’:
> ../mm/swap.h:66:19: error: implicit declaration of function ‘swp_offset’;
> did you mean ‘pud_offset’? [-Werror=implicit-function-declaration]
>    66 |  pgoff_t offset = swp_offset(entry);
>       |                   ^~~~~~~~~~
>       |                   pud_offset
> In file included from ../mm/shmem.c:68:
> ../include/linux/swapops.h: At top level:
> ../include/linux/swapops.h:107:23: error: conflicting types for ‘swp_offset’
>   107 | static inline pgoff_t swp_offset(swp_entry_t entry)
>       |                       ^~~~~~~~~~
> In file included from ../mm/shmem.c:43:
> ../mm/swap.h:66:19: note: previous implicit declaration of ‘swp_offset’ was here
>    66 |  pgoff_t offset = swp_offset(entry);
>       |                   ^~~~~~~~~~
> cc1: some warnings being treated as errors
> make[4]: *** [../scripts/Makefile.build:243: mm/shmem.o] Error 1
> make[3]: *** [../scripts/Makefile.build:480: mm] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [/home/openeuler/kernel/Makefile:1924: .] Error 2
> make[1]: *** [/home/openeuler/kernel/Makefile:234: __sub-make] Error 2
> make: *** [Makefile:234: __sub-make] Error 2
> 
> ...
>
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -4,6 +4,7 @@
>  
>  #ifdef CONFIG_SWAP
>  #include <linux/blk_types.h> /* for bio_end_io_t */
> +#include <linux/swapops.h>
>  
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);

Thanks, but I suspect you're using an older kernel.  6.18-rc3 doesn't
look like the above and it already has


: #ifdef CONFIG_SWAP
: #include <linux/swapops.h> /* for swp_offset */
: #include <linux/blk_types.h> /* for bio_end_io_t */
:
: static inline unsigned int swp_cluster_offset(swp_entry_t entry)


