Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8045C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61946B007B; Wed,  5 Aug 2026 11:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C117C6B008A; Wed,  5 Aug 2026 11:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26B36B0093; Wed,  5 Aug 2026 11:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 927A06B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:40:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32D49A051D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:40:08 +0000 (UTC)
X-FDA: 85067626896.25.25E90A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 092AAA0019
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:40:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AYYMgLUB;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785944406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yyp1Jx5TsTnjgSPHEVsBIOepBcBoQsHK8XWBCZVl2R0=;
	b=YgQGaZbI01U3JfvPq8fpnLV261YAYPRiBcgw5pa/BzFP8FjA7/Pr0ghn5c0ujdVskKPPM3
	ZXArZ0k9dUAG6aL1mHQTFwd+6cKBcCScPMymRSueUzz6BrhPb7/Z5uCjGQoRZvIWN808Yb
	qvXFbP5EJVoCPMQc2xjEmdTirGzfwSQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AYYMgLUB;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785944406;
	b=qdjpRC+m9Mt7FwvZ3ioVom4WICW5DV/jzVWkIOgD9N6tG8fBhQNWPa56UU8kPficjas8VF
	FbXO7h535snZmLJ2RxiFM8+fW9ZlIakqJsSYLU//BFt4fsWLrAEWOFukC4hgKoNeZPjCys
	i0T4tmsKFyuJ6kBcdlz1ot6VLM2R85g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F83A41359;
	Wed,  5 Aug 2026 15:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38131F000E9;
	Wed,  5 Aug 2026 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785944405;
	bh=Yyp1Jx5TsTnjgSPHEVsBIOepBcBoQsHK8XWBCZVl2R0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AYYMgLUBM0HBs2ErJaGcEb66aVopXjcrNQWSryY0zMd9FSd7NOnZ4C6e3lfcPh2kR
	 XCLgvmnP+9PsHbhHPlKJ2hJrHYK/TFkC6CA9V/EgJrqGDuJ+zRIzdVw2XX6j+Hcm1L
	 Idzlw2CMtozwkJjP0EfhM2EdECZ5QZe+XLqDVXIw=
Date: Wed, 5 Aug 2026 08:40:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Pratyush Mallick
 <pratmal@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 e47602c51d20a93fa1711ed896dc9480de4374d9
Message-Id: <20260805084004.afd47046925c62a5b19e242a@linux-foundation.org>
In-Reply-To: <202608052027.LCDnsFT0-lkp@intel.com>
References: <202608052027.LCDnsFT0-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 092AAA0019
X-Stat-Signature: 8zyqxu59spbqaqmq6yjigtw5a64obwm1
X-Rspam-User: 
X-HE-Tag: 1785944405-484319
X-HE-Meta: U2FsdGVkX1+UY0vRMjlB9PLpf6XXxAfcY4UEFuGloYvJco521wENi5HuMxH/Jm0Mk2p+HtcHa6BXDkRGz2SV9TBjZ5qdNwLH5WzphOLWiQK0DiUpzVaVfg4Wtlu7wNdEL7zCCU0W3ExkLdWQzd1JgDTM+RpXOti5FdOpLmDfBaIfNYBb8X9HMh/i8kzvxK44YXGTbAnfgri4DwlrPz3dvA0TOgtzCGfImUUqxDgJK+pjTwyFaQMgbCeGn3UkDNE/70eqoAFA2CJBi0Hs6mi7xrbFBfWsQDvnCwV0Z5Xmtd9qHucKD2P9PbOG+9/93Wpn/iaBKkQQkHBYxadKhsRgPILJGOk7xFn9tAWIW+OM6v2JJnZ6DSPv6DrW+XWWM++8+NhmE02U2J4nCGhzDS5cy42L93gKJHVZag+RBh1hbl1AkGGfPzJG2dNfPYdVw5M8udNrE65W8ZxBdKVbvmNeq4fupDr+FxlPSlPb1O4F/xdaO0j7E66Ff0eVx2u+uDy5tf8YAzCBZ+0EA41lLfz/ai2fPoEiwm+vRsDTlh0tDG/rjqpUm7cMJvPfLmEnCgp/bUVOpkg5zeqpeLD6I1jzf1TRjSAsnkt2xGGGi31ZriSYp2AodeSeQConvtLq0LPEbRZfQlIBDaK8IJZsnAIaO9Lfrh1gvVxjAm+EfAObXlNUgDWZGPgWVKA9/D92ZdDOiS9F+8JP3fvFs2ceSnfC5rktN8FSWFBF0SxuyMjSXdObqP3uMkw+nPozRDGoxbqvI5JyYwcxGH7Ipqi8Dcwirxw19CBfpKS9cJK+QfAkEOioqfcBghJ+HEgW0CDCVOy1HBwIMsS5bICsGdvZLxWqPenUCg5dC44nemC2asV/5pm6K6TuD5pnmhKBO4Hw3sMOwA58JFDNtyui2V3GjsGBzniggc4tpav5PnoBvnUE1ab4zDf/H/kn0Zdw6ru7MO1tpuFO4/lwzsFqxBKenMC
 qawoEGZe
 f96mxqeBpXsm/x4cn8CxpKu+w+hrLyq9ldkPQc6Ax1bnj9/pKfOIs7G+FNgRammvAtu0r1m2e2Yz7cR/bfEsGULMJb7FWGy69GUy+oph3V+VYvmZmdiRJIgOfbFiAQY12ScwxBfAYAQ5404XpnFMILJH6jgdZDYqhyqtXkCPwqk5ePoSrnvArKl4RVDX2VpbBmH+hX0ZWDk6FSTcbxdSvVz9ku7wofuOB2iT2aRjr+M6QKSl/FzIIYSlc69JSuwuAp5hviljMC0ORZ0ziED5FHyBZTALpSNsOqfwRb5mNIGpET0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 05 Aug 2026 20:32:52 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: e47602c51d20a93fa1711ed896dc9480de4374d9  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202608042227.XDO54bZk-lkp@intel.com
> 
>      .gitignore files
>      ignored by one of the .gitignore files
>      of the .gitignore files
>     /mm/write_hugetlb_memory.sh: warning: ignored by one of the .gitignore files
>     /selftests/mm/ksft_hugevm.sh: warning: ignored by one of the .gitignore files
>     _hugetlb.sh: warning: ignored by one of the .gitignore files
>     a.sh: warning: ignored by one of the .gitignore files
>     arning: ignored by one of the .gitignore files
>     fd.sh: warning: ignored by one of the .gitignore files
>     files
>     g/selftests/mm/ksft_memfd_secret.sh: warning: ignored by one of the .gitignore files
>     les
>     nore files
>     s
>     s/mm/ksft_ksm.sh: warning: ignored by one of the .gitignore files
>     selftests/mm/ksft_pfnmap.sh: warning: ignored by one of the .gitignore files

Thanks.

I'm guessing this is due to "selftests/mm: use pattern matching in
.gitignore"?


