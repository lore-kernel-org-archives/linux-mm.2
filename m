Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586CCCD343F
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 09:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBD86B0312; Sat,  9 May 2026 05:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2346B0313; Sat,  9 May 2026 05:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF096B0314; Sat,  9 May 2026 05:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F167D6B0312
	for <linux-mm@kvack.org>; Sat,  9 May 2026 05:47:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45F301C04D2
	for <linux-mm@kvack.org>; Sat,  9 May 2026 09:47:45 +0000 (UTC)
X-FDA: 84747404490.07.D8FBF20
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47724A0007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 09:47:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Bv+/YluI";
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778320063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+2pbbVhcPs+O/UiB7Rv0YgrC1Aa3k1+qfWtc56gjcQ=;
	b=xiKA+fYNKXiOhipBxjghCrxTj1w4tBHYEddh3JjmZ/dmHfHPhOhl0adyKT+IxrPtGEZ5yV
	apTSU7WjMlaiswnftVJxkLnii5587C0rDxt8uIhza2s38HGl0djXRopqPUMnBPUPi6sV7/
	a1/zTBuNOEvjhmslPIoyod4cldRdeao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778320063; a=rsa-sha256;
	cv=none;
	b=fjS4O+uaZ16HG0nur9+2BbqYovOGijnyoPzS4uxNeY6haKEVlIO5iP31UZyTEMLJQU+uwh
	NiisCuZqgOQHa5HDvgomEHZC6iw8zyB5I81JT9MPxuPxGj/sclZv1v41GJZLdqo5HcVcC2
	PtKsnkWhuGkiki0n0dVcVm1pN/yFt9Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Bv+/YluI";
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778320061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h+2pbbVhcPs+O/UiB7Rv0YgrC1Aa3k1+qfWtc56gjcQ=;
	b=Bv+/YluIxCYzSWDM6r6xXnJk3cZ60VwXTBhEg+4vuryOYu/VZDOfcWSHl1NSKzTOcVVZU8
	N9ONn4g9u+bODF/pZpn25LdsBJtLjb3Ou92xRIuM1uxUmaFFksXUmB6YQrRN19fXWWwItv
	lIQKSwkasHds8/Mds4ZEe9zq3Hvn3fM=
From: Lance Yang <lance.yang@linux.dev>
To: chenwandun1@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 0/2] mm/khugepaged: fix sub-PMD MADV_COLLAPSE range handling
Date: Sat,  9 May 2026 17:47:32 +0800
Message-Id: <20260509094732.83643-1-lance.yang@linux.dev>
In-Reply-To: <20260507070558.3064142-1-chenwandun@lixiang.com>
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47724A0007
X-Rspam-User: 
X-Stat-Signature: yjcp5ax65een6xzsiz7a9e6k78uftbud
X-HE-Tag: 1778320063-313082
X-HE-Meta: U2FsdGVkX1997KLgLfr/RNZBzLBp60ylD8y8nRCivdwqVlDWXlIq5Era/Oi8somupFcTGsB2WiyQ4LWcEOvEWTJeTc+iygKnCQkmHtlTKPwsZU2fragDIhT4hc2o9cJv4M3/kH+ef/cG535hfPEqmwJ2Ou982FY71uT5aw/zn5eD8cIpEVSNjo39cMrw6j5aVklBZ7o4Kn20IgjA3dDUN2Em7bUUP9JKOCFlztd75eRJGQO+tZrSj1U4Bamgw17wDWT5wWoTW9cFbCAh+ofvf6MIGKGrO68tljP2adhyN9TnHYrKwh7naX8Zl94eXDN5Uvc5U1YYmZbYfHvCWx3LZPlYvMGZBZpfCQ6KSSlrzMoMVLiDEpJCLsykGxYqBaD2Ek+VmC2W+mN8QyTxvLjY8AfvJbAD/k6dRwSCEv4BHF5citI/hnfl/3Zbdl3HxT2qldfZnn4XTWBV6o1Weq1APEnmMCXRh3g1OxafOmtquWH2Ap0HHEiKhuXJmWPn+00UlEJx6XjyR1Zl/PVbfYjv0Pwq4ft2/mSXkdv2jxJTbOG/0wcIUROrocMxLHwBdEow20LvzdQsue+RfGmTZQId7i1ZiQBM6tXJLjFTqU0U3/JYYo1jww8DzTkn9H58Zm1TOXaaWBQOulm3P8HzNoaZ09b86/NjXmhs12+U1B51Rf9QDNnfR+zzD+SzKwATm2bzPiDIAyrsi+taA6OkYY0HtkzzSttJ3C61w7AXwnG8+g6t8b8pk/P8gFj39S+SoqlGLsvqdXvTBcYdfpHRUFKzvzwgC+RssQq+1snu2sjT4XeQPhwgeWHTYGrg526QXoymqrTGfI87ZPOijLeBwBQxoOmQTlcFtReIWl1nMVirhMg7p8Rhpv0Tusdz3zJzzuSv8+MGasijbkhSEryzAxw0JoFEP8Ct0PSLXXdcDw2Bqz4UY+zO1edsDoeEA4/nJWvlc49qQ34clUxniI9Lk2j
 RD8dThdn
 QIpTrEiaxEt23UQA99bChOV1fXyb0D6KgOWXMgZrNuySOkYklcEe2JCIiYUmPp4oj9fGRz10VLwl8wKCHZ1nKIyXo2nfstc0CAAhsIXGuv/VHKt9kZ6GtWUD95Q3FqaP14R8lvpxi5HbK5yVVggYDqZxodSLPeTEDicKrVF6zCSuPPZ2NS/gVyA5VfxHdNcnRTN8Y6jy5z/DVIckW1oFqdB6XH7PDMCwt+exz/ugbfadcnj0tKmpwYV13P1qqWhljAw+V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

scripts/get_maintainer.pl is your friend :)
Please use it to Cc the relevant maintainers and reviewers next time.

Cheers, Lance

On Thu, May 07, 2026 at 03:05:56PM +0800, Chen Wandun wrote:
>madvise_collapse() computes a THP-aligned window from the caller's range:
>
>  hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
>  hend   =  end   &  HPAGE_PMD_MASK                    /* round down */
>
>When the caller's range is smaller than one PMD (2 MiB) and/or not
>PMD-aligned, hstart can end up greater than hend.  In that case the
>collapsing loop is correctly skipped, but the return value was computed
>as ((hend - hstart) >> HPAGE_PMD_SHIFT): with hstart > hend the
>subtraction wraps unsigned, producing a huge value, the comparison
>"thps != 0" fires, and -EINVAL is returned instead of 0.
>
>A concrete example:
>
>  /* both cover less than one THP; both should return 0 */
>  madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);             /* OK, returns 0 */
>  madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE); /* returns -EINVAL */
>
>The fix moves the hstart/hend calculation before kmalloc_obj() and
>returns 0 early when hstart >= hend.  This also avoids the kmalloc,
>mmgrab(), and lru_add_drain_all() calls for ranges that trivially
>contain no PMD window.  The same effect could be achieved by only
>guarding the final return expression, but early-return keeps the
>no-op path free of the allocator and drain overhead.
>
>Patch 1 fixes the kernel bug.
>Patch 2 adds a selftest with two cases covering the hstart == hend
>(aligned, was already correct) and hstart > hend (unaligned, was
>broken) scenarios.
>
>Chen Wandun (2):
>  mm/khugepaged: fix spurious -EINVAL from sub-PMD MADV_COLLAPSE range
>  selftests/mm: add MADV_COLLAPSE sub-PMD range tests
>
> mm/khugepaged.c                               |   9 +-
> tools/testing/selftests/mm/.gitignore         |   1 +
> tools/testing/selftests/mm/Makefile           |   2 +
> .../selftests/mm/ksft_madv_collapse.sh        |   4 +
> .../selftests/mm/madv_collapse_range.c        | 141 ++++++++++++++++++
> tools/testing/selftests/mm/run_vmtests.sh     |   5 +
> 6 files changed, 159 insertions(+), 3 deletions(-)
> create mode 100755 tools/testing/selftests/mm/ksft_madv_collapse.sh
> create mode 100644 tools/testing/selftests/mm/madv_collapse_range.c
>
>-- 
>2.43.0
>
>

