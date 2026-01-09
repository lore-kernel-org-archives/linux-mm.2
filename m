Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93657D232EC
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014866B0088; Fri,  9 Jan 2026 03:21:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F042A6B0089; Fri,  9 Jan 2026 03:21:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC1D6B008A; Fri,  9 Jan 2026 03:21:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CAE4D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:21:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 704128B876
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:21:14 +0000 (UTC)
X-FDA: 84311730468.26.6ECB7AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCD62A0003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:21:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gk+RzwZJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767946872; a=rsa-sha256;
	cv=none;
	b=HDYqK8VvKc37Vx7GLY+v1C323cliYgF9erCduYzj0SvFKWmY6FmrLMg79U+wOYREVhwg2F
	ukdyaFB/r1GOvB0vCpLPqq3x7hxzDqWWtiDZ2F631QUcuXusLJgUEOX4+CV6GOOJ6Ozj1Y
	J/dg0rEKlJqqgLdwD204u9hnKAPBHQY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gk+RzwZJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767946872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bwCvYNVWz131ksEKOnghAOgppy+qUVLkrHVAB2GisI=;
	b=r+WK3JNIiAVp+PCoqo5CHB2dvR2sH7qNT8jC+Ntan0jIxD5ga43t1SZ5aIMKguLF73yYqO
	TfZR3UW5ax9+zOrBgqtZbPRRXI2BYRrlPQofV5Tdhog9WxepLtlEh9Ietrz78rP79bG67l
	r9IczRleE8tpO44TGAz83skCN65CY+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96BEE404ED;
	Fri,  9 Jan 2026 08:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA62C19422;
	Fri,  9 Jan 2026 08:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767946871;
	bh=KUFuE5V8UAiIurL6g3Fp/lJo2ewluF8KzNFw5f5PUjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gk+RzwZJgqFqDXbdeT7Ij2ANvkctK08svhshZT4R6yu6GK6U5FU7oH4Xe+zv8qwMi
	 4CjPgeTPbBjv8HsMIltG5ewdwonA8kjSIA667gREwSdMJ3RS+7Buq5U6Eos8SvbK+J
	 nKkrMxUoT4X8Q0FyxCy4EZdhe4iqJhr4V6t7/UJCAhTlbVpUQXR/gm208md0TMmWZM
	 HkmXt9IdJ7rCxhmZTAD0oRgGfDs7xzYOTVswLzOoZ7GMgJgYq9abd0Ivcl84yf5tq9
	 J4AmlCsrCF8YDst8YMFTNmMfuhpye4VlBUo7YM7KAkx0A9LACF/F+ezsCZLKZlQrcl
	 B6Hco6Rs0QnpA==
Date: Fri, 9 Jan 2026 10:21:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Lain Fearyncess Yang <fearyncess@aosc.io>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] loongarch: wire up memfd_secret system call
Message-ID: <aWC6bIEg6UqvX1DO@kernel.org>
References: <20260109051054.188030-1-fearyncess@aosc.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109051054.188030-1-fearyncess@aosc.io>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCD62A0003
X-Stat-Signature: f8mofzk5cn7eobsfx618jtqxwgazxwm4
X-Rspam-User: 
X-HE-Tag: 1767946872-395718
X-HE-Meta: U2FsdGVkX18szA5YkI9tyT5i0jvOc0+AE86fmR5q9ja/r1XZ9bAtFrDd/7SR9w/hFcr/iieAxjJbAFh8DjkFs1P/qKeaiKrihCZ5sVh4MOhPPQ2cPeqQrC6Cb2Cs4aijPLNoCDlCFd5IAMqt8yicgGsB8LNci2PSd7ZytK4Gx8r+3/I9VCfQjY0OKBL0IXdf5bCcvufD0zMvR+7lZkwFeddz+r3GCR6+Cw1WHbR0mm87IrxjVGJz9T1jrNsWi9vuIbGNhgGWCBZIb7gWYPgcctRRCImrx6XSPEY48SUjbmMaavvOw/5zS/PHYBYJleIR5BkLQmj+rCiR/Q7Ph2q0JZzN1BQ65XJ645EV4E0qqPnCLLw8DwABPc1ZRvyWkq82CKFlpOREy+kHqtMMFehC0sIXANJIiKdXf4RJ7eNgWIpX6qC0QPyKWGeQGl+Jvykp+RMSDfto6fC6zH2IWgr7pyqRXzquuN+Hm8NeiI8akg9I0Qw2SBDkeYUPT5u0Cp+oOrtuHWYe9WYrcZzeyvqWGscHA5HLqQqQWsxCKNGPTWqWcMFnuFGhdl6clnOJKN+Fl+nYB8+wMOghXJf00zVsW9x9rPhdLwXwK1XH4Uj9FkBY8wWbp3XL8PgD2haQPRGVgAkOK7tjSvc/xrXqCRqDa30DqFwW+dcLnwSmRjiScFkX9shnTm6u04vc6Jt0lnzFVeDUbniaizRvqCq0zHQCcX8W3v+qeBGGnad9BBnaVgFn3S4onWwio0UKZTCA4n+jRT9C3CkbkTyNt3V3/R3dVwuE8faTk+9ZG42WV3Cc+rDgqg+XSkR8v6rYlfqfEgP7eE9DBvjj38ThUk2sTQhpc/aF7x0SVrJucziW0cDndNI/g/PHKbIQI6J2DTKriuoWZajlTU5nfZaqbkMbRbzaGZBM6Fj9DN6yIc0SoKWC1a5yHceZGmLAV4O31s0n7aWNcrQ/xIqmQ8v9X3UbeZ3
 KNdIy4AM
 mMViRun08yx7MxIcvVYLsQUob1kY+IPmZooIDRT9qtVjXbptWeZ0voghUyr//7+MfnWh37753oMVnzd2VB7soqPK8OmzJRESeNUltH4b3PF/S/B1dIGJF2KRZ7wAUHYR2+XPlRdFVCIcQUbbKBD0M5irQX7JIlBgPC1Mz7rFPosyy9XnfJH4FiScRYti5aYEcVxDMTKoE2b3KsBvUPZo9vwOVRAF+txT4uTZlpD1ZGcp/KIe2JMFUuIT7XcTptOQEdv4uqx2d7Wgr0Jw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 01:10:51PM +0800, Lain Fearyncess Yang wrote:
> From: "Lain \"Fearyncess\" Yang" <fearyncess@aosc.io>
> 
> LoongArch supports ARCH_HAS_SET_DIRECT_MAP, therefore wire up the
> memfd_secret system call, which depends on it.

LoongArch version of set_memory* does not support splitting of leaf PMD
entries. Does LoongArch always use PTE-level mappings in the direct map?
 
> Signed-off-by: Lain "Fearyncess" Yang <fearyncess@aosc.io>
> ---
>  arch/loongarch/include/asm/unistd.h     | 1 +
>  arch/loongarch/kernel/Makefile.syscalls | 6 +++---
>  tools/testing/selftests/mm/Makefile     | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)

-- 
Sincerely yours,
Mike.

