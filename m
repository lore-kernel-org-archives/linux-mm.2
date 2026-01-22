Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA9FDD6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 21:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3052E6B0359; Thu, 22 Jan 2026 16:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2ED6B035A; Thu, 22 Jan 2026 16:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1A56B035B; Thu, 22 Jan 2026 16:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 076FD6B0359
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:23:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB90013D35C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:23:39 +0000 (UTC)
X-FDA: 84360876558.20.9ADAA91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E3CD0100007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:23:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YE6jrEPK;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769117018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2C2CT9ueN+usFG1mcQtccTIsqfNAYR8Tmtb3NvqwOQ=;
	b=BGpRd+I/A3qqa+BbUyDTFq/XzYTlvu4zajcKcW5buptLtBEfjgV/XGvsv16JI+/UmadjVa
	eOsihRMCFHxxQq1hKyaA2/rfa4CE5VP7kPprmal60cDKqtEWlAtA2Ow8yMqEs1+gcc7/9n
	SO9zzcXhYdoaIQv5pyyanHt7SJqIOJI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YE6jrEPK;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769117018; a=rsa-sha256;
	cv=none;
	b=WXE8YNXXycTKEp1qN58+wdTXZ7MufsFv1i84Hdmz7O1uXl3+bgOZ1NFfcHnBm5o+9exsqm
	SvTQ9Ap5NhXRLjWSExNZHrOlLZ0J7l78bdWJSvgTTpu164hkV8w6XxKg5hl9FeSjs4LDv/
	+h48EEJseV/O2+yqcHdJO0KtOD/jz0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6E15436EB;
	Thu, 22 Jan 2026 21:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3E3C116C6;
	Thu, 22 Jan 2026 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769117016;
	bh=jSgY5ZwEr3TZ//h6VeSmcz6HoWxw5sGkQ/chQWBHjLw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YE6jrEPKl4RAL4TzmBlLqe2nKox5hw1ncpUW19Ztk+DhB2aI9E3axKvJSuT6Q5AGt
	 BMeKNElGJJR3OXX8C/S0vuZiCH8UtKO6YiCNFIuNyjFRJXBlBKYbTVCz/qr0LYNFXO
	 WRQ8N1GUu3n9TknQ7WQ6BndbHRZkTxHm+TDpxm7g=
Date: Thu, 22 Jan 2026 13:23:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 420/429] fs/romfs/mmap-nommu.c:66:42: sparse:
 sparse: dereference of noderef expression
Message-Id: <20260122132335.5f3160dd20dfdb68c57ede35@linux-foundation.org>
In-Reply-To: <202601221505.RxftadLx-lkp@intel.com>
References: <202601221505.RxftadLx-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3CD0100007
X-Stat-Signature: 88kjnof1o1o4bm7e6k34nsn4qhnyi4xo
X-Rspam-User: 
X-HE-Tag: 1769117017-947037
X-HE-Meta: U2FsdGVkX18ekkjOLVPBkdD6QNOEOakhuSzvcr5lDrZPlNUINE+qLTE9MuOmMc0naYHjRFqS5teyjnXv//mnxXnVzbyGoMPr5vIap1p8qgUJKe7uMjdntVQhjp7EA99MiAzMoknm0U9zAx6jwqvt9WQhnwWggy1NeK1k9vbuyXAexlLv3TmH3ADk58FO7Ap6XDQf/wgjN83ys6Rf983oifzGSvWttdC0RLeb3eBZdbQqTDwYYWMvPjX6gumJElvg2lhc695oL91a640USibTPjOPQfF0R+U/4AzlMKmpxx1xrR5favCYirm7u+rGcBYumUYrWJbzAa7HqDEq5UzKTYmo0uXbmJrGRt5Ly3b2RCez5QEnnqx6UcbnlVuaQrvUUXDNfBXNxqWZZW5bwGWwNrdMaK7ZiYL+I60w7JMimygvL9+7BTaKUEYPCk7tAg41689OxVVsFO26ol2arn/eHPY4pTpcp7Q13X8R77luVLGuvUccAMsDuDirVhMZhdTQ1hUOiCjq0eby1Tb4l7AQ03le42GJ1dw0gPmySZznJeVhGcK9BKzqi2l2YSmX37PL1udMyE+MY7IwSLOlb2u8S7TFqt3PHaEK//bxlLeCXBTiuxroBaQ70Jfe/kq3YXQGaxK2omZtf2zsGBB1AAVpWujUFrAQnsOiAVvu8vTlSVmqgAAhFWRM7PSpaClDYOr4kdJgrmOvUTXC+ZNakJNdUmUaQTbofU8gdWG+W8tMNjSQMQ/E4/CLCHUYJkxoaDQMPIz6Nx4iptf6yWwQRlJyJ0uhgrYwtScuQ1TrdvE/Ve3yb8vxTxJOgJx8jGLqv4iB3lmMVDFg8VcnMbpa4Bj42GfMVRuFE7Q5cMh+9VnAKdFJ1q1KykGl2NwNks8z4ZRKoJIcGT6n6XFbgnClQmZOC7zj450A1G9Gr6cu0FUGzpU62G0e/hoHC8C76DWZsug3w1+c2AL8R1jsK6Vkkdx
 Ti+FjdCF
 BKVq2njRMYaN8WXP/PlHb4RyxDp1NPrZSMAOliuYXEpjuF8c6j3lcEQr/9XTgkTWd/4FGaToUPAHOAMFbKmWcMIovO56KngAbV8FJ+xHp1YOE1A49MscLIbPTy2NjUnpJcIIQog1GmJUqE0KW2gdfcfIGZAlYk3lbGbAiUT+1pzbwnN5x6Szrx6w7yjmi2VhqoZsV23xfkTrzqrV/Sg4FwcEHzXymWDjHTp2+P9BPe/pGGdy1RMXw1WRqK4jmOCV51hF905/rvZqvkP2r5a45prbuW6cfjSEMxTm6acTsmGzduAqxb1+ayURFsRJ5dj7ryJtM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 16:04:37 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Lorenzo,
> 
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   dc4fe40a11269aead253fa0beb098b00417b8694
> commit: 57a654376d4bb67119d436edc8c3c4c0ecb3c369 [420/429] mm: update all remaining mmap_prepare users to use vma_flags_t
> config: sh-randconfig-r122-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/config)

Has CONFIG_NOMMU=y

> compiler: sh4-linux-gcc (GCC) 13.4.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601221505.RxftadLx-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> fs/romfs/mmap-nommu.c:66:42: sparse: sparse: dereference of noderef expression

fs/romfs/Makefile has

ifneq ($(CONFIG_MMU),y)
romfs-$(CONFIG_ROMFS_ON_MTD) += mmap-nommu.o
endif

so why is mmap-nommu.o being compiled in this testing??

