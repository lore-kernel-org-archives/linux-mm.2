Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D34C624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 02:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B716B00B7; Sat,  5 Sep 2026 22:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4376B00BF; Sat,  5 Sep 2026 22:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EC46B00C0; Sat,  5 Sep 2026 22:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCF5D6B00B7
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 22:31:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E7F81603E1
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:31:26 +0000 (UTC)
X-FDA: 85181760972.05.D251D7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 74EEC120009
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:31:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JiOzH9hU;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788661884;
	b=iOb70BtVkLtRHuyUa2BSy2AxkC3Gwp3wEtkxi3escHd5b84YO3W6Cye/7/iubPkqmcpxL9
	pZkxCdagdiPBUAa9ceWklWI7Qf+3bDboLwFhFpPaTExe3vKu4WnbCnYJKtr1BXclw00wyS
	ug8gE5Kd6kdyQTfjNbrooEvBWVDAOKQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JiOzH9hU;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788661884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVYnYKeM4V2pRuhTBVBMHS1mPU9NDYVJ/TRJ5gtWSOA=;
	b=EqLoGynCkpZea8V0svSXjDFdG6RR/gmAOVhL21eppLF8w0mmT/nJw30MiFJo3XH6/J4eRH
	5X1voodC3lmp/+FUe8/3YKqBnQzbBJAkRftPW2n93Oedh94npE766w5B+mBYU52lH7wvYO
	qkDIOXJqcwkPwxGa8jcMcloOZtU/cTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91CFF407B7;
	Sun,  6 Sep 2026 02:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D201F00A3A;
	Sun,  6 Sep 2026 02:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788661883;
	bh=dVYnYKeM4V2pRuhTBVBMHS1mPU9NDYVJ/TRJ5gtWSOA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JiOzH9hU/p7vG6ADzKrmNQzVawhymrYC534PZ7ensT15Jw8U+wDC7/NSUWdqIBOor
	 FYOBDhcJoDNq5bCQjr7PF82t/1SO3Tpx4W27bfnYyQbGAEuIS8IGogsJwgsae3dwv2
	 uwxAhe72T26Euru4ZB+qahaygusdDhol552FAeyw=
Date: Sat, 5 Sep 2026 19:31:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: mawupeng1@huawei.com, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/hugetlb: fix max-only subpool accounting on
 alloc_hugetlb_folio failure
Message-Id: <20260905193122.76f5d3245cd2e0603e7743b7@linux-foundation.org>
In-Reply-To: <20260428113037.88766-2-enderaoelyther@gmail.com>
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
	<20260428030712.66256-2-enderaoelyther@gmail.com>
	<20260428113037.88766-2-enderaoelyther@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74EEC120009
X-Stat-Signature: 336j18npr3sxgqd5c7nmj57fs8kxz7bs
X-HE-Tag: 1788661884-212576
X-HE-Meta: U2FsdGVkX18WtQsmzjdBHccGlKOdIvfG5Txs149KUPDvbNlNqq17pc2HCTHYgziYvhZ/yg5tzzrzyU+z3WwtZ2kgoNL2abEVJQXwR8voULqfsicSG98id9cHeTDDFlgGt3uVpWVycBkxndlHNSsAieJ0w8gcl7IzkbTpQLd6wOPjMPYtqVlFXEPPGZ4wp5A/4KDYmubMS7h2aAmhyyW3JINusx8tKAb80NHJQ21vPCDw8nzqQiUnaLY00OcC+R7Hy+thnrZlsWfWlkRn5FLg0rf1c22qZjhUpgMoBbEIWjdgcS7JqqndJSruTMCTlNKI+dRwuLl1ETEYmUINdzO6JMshHjTYPEFdqVwqKBRWuuhd1tySiSYlrMCSnRSKYp8/BwlsuyO4EBtpQSocaxr15ZEpzPsnp62vyQnIUg588t6Ug/GqwfJYyXLKR7bvBprmidb7Ndjip3/7RfXIFEe88/MDOojXebQ+0iAdbH2SVh1v6fGuhluYDGkhxdS4UUo9KsMzaKFUR6kc+Jvs8wYg3Bp/XHg5vyR83c32evCA5vosJgyE9yLLRD50hgD/AI549ecE0ag8jB/4vKq5FHFyYW1NCAiXz98vVTTdFMIPeXx6djnCfB/TKgGrpqnBrM7dG8Ed47ZQT62EbfE/BubIlwIHjH1d7QH5ykChB50EvBHKcc4h4wi9rKh9kU/jTUSKmdy12dOVeSOjOsWl9NC0+zPKwS33NcP9WN5UdUU6nKH/z24eZRRWwtNHr80ucjs5EZIXDS+uY+I2C0EYeFEC2P6kw2uChwrWi1mLn5iO2W8/06eEiHj+kNP0iaMpeFcoCM4ElcSaNg3KxkRVYKW5zOz0DVGZZ7a54frVs2SOU67vWa0AGVLbDMYLdomjX/zwo5qFwDrh1+Dz4oeIc0IVrz0bcVbe+/dA+JxvEbYKAM+eGOZVhQ5NG3wjB6A8nW6Cw5dpZJHZw6Jos+toj9k
 QgVcdg8F
 1cb8HiSAPNGgQYsMkoY2y5FyCaIur3JyZXg5sLamcwribcWeVYdzuYUgmEvoyaoduOOI/gSSEoYuMuRwlIOTNo47ve/NQ9W+csGgI2ldM1Ist32vfboAePk2kampLPEnQVAMTMmWrJboPWqofP5G4YQ8kRE5Dh7xYpusT8My+hca6jZSn1PCOhT/3T8y+a2SNrA7wpFP4NCP23rh1m7KBK+O8kR0JwfmOBEFGcTzGW+nYSAjRFmgh5dI9ulin+vVDDQonrdeMZmLnSq0lgaFqZ3Y8WDQTIZ9VSs0uLVEruNYM/3ty6CDIZpUkMFo3TCqbVL3E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 19:30:38 +0800 Zhao Li <enderaoelyther@gmail.com> wrote:

> alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
> is set.  For a subpool with max_hpages != -1, that bumps used_hpages
> regardless of whether it returns gbl_chg = 0 (rsv slot consumed) or
> gbl_chg > 0 (used_hpages slot only).  If the allocation later fails
> before a folio is returned, the unwind must undo the used_hpages
> bump.  The old cleanup only ran for !gbl_chg, leaking used_hpages on
> the gbl_chg > 0 path.
> 
> For gbl_chg > 0 on max-only subpools (max_hpages != -1, min_hpages
> == -1), hugepage_subpool_get_pages() took only a speculative
> used_hpages slot.  Drop that slot directly under spool->lock.  In
> that configuration hugepage_subpool_put_pages() cannot restore
> rsv_hpages, so the direct decrement is the exact inverse and is
> race-free against concurrent puts.  This matches the used_hpages-only
> part of hugetlb_reserve_pages()'s out_put_pages cleanup, but
> restricts it to the max-only case where no rsv_hpages restoration is
> possible.
> 
> Mounts with min_hpages != -1 are left unchanged for now.  v2's
> approach (hugepage_subpool_put_pages() + h->resv_huge_pages++ to
> back a restored rsv_hpages slot) double-counts global backing under
> concurrent free_huge_folio() and creates phantom reservations under
> concurrent hugetlb_unreserve_pages().  Safe cleanup of that quadrant
> needs a coordinated fix across multiple call sites.
> 
> Reproduced on size=20M hugetlbfs with the faulting task in a hugetlb
> cgroup whose limit is exceeded.  Vanilla leaks 6/8 hugepages of
> subpool quota; this patch leaks 0/8.  Verified under QEMU.

Thanks.

I do like to see a clear statement of the user-visible effects of bugs
when we fix them.  "subpool quota leak" sounds bad, but how does this
visibly manifest?

I asked you-know-what and came up with

  Failed hugetlbfs page allocations can permanently consume the
  mount's size= quota without allocating a huge page.  Repeated
  failures can make the filesystem appear full and cause later
  huge-page faults or allocations to fail with SIGBUS/allocation
  failure despite available huge pages and unused real filesystem
  capacity.

Which I'll paste in there.  Because I do like to tell downstream people
why we want a backport, and to help further downstream people to
understand whether this might fix a problem they're having.  Please lmk
if it's inaccurate/incomplete.

I'll queue this as a backportable hotfix and shall await further
reviewer input.

