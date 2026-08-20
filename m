Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCB0C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5E76B008C; Thu, 20 Aug 2026 02:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286686B0092; Thu, 20 Aug 2026 02:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F186B0095; Thu, 20 Aug 2026 02:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1FF26B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:34:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2035A1C103F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:34:11 +0000 (UTC)
X-FDA: 85120683102.23.9FFE217
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8B3A91A0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:34:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebF9ekYr;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787207649;
	b=x7HfekEi1EzNrWuoiEgYoyj/t4fpl+EixTcUfwRDXbCARCOYv/bCxazrnWb4SfTkp/0x81
	/sarL2HfR5NBcmmPqcPm6L6kSpVMVOnCRTkCyb3ddmUpfTJg7w2F5TBtDzzYZNsT4+ysZd
	2a3nKWfjUsYyTCxCBncnggDMUPIACMw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebF9ekYr;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787207649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PENPtk/etW4kWB3HZkvkr6lSKI29AakIAu1GkDMjdFw=;
	b=hncwn99IOEvflFn4ARApWaF96ukvV0LJ4/oqCyzfld1DhMqugoNx0/fL+cXOX5naq7zvN4
	vu5ASNPeFILtPpBH6vFFCQQ45RN2G6fl+TYL9tjcMNDuCXhj0HHs79rSmBGGAJcTLOQYDp
	uxbnygz+PJnkMhbe68jVZZLDBLb8jCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2C1C60AA9;
	Thu, 20 Aug 2026 06:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9B91F000E9;
	Thu, 20 Aug 2026 06:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787207648;
	bh=PENPtk/etW4kWB3HZkvkr6lSKI29AakIAu1GkDMjdFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ebF9ekYrq4pFO8UvvsUouw/6fE9Fsy6YYnnQgly9lXag3wmXe2O2LUKWPnid2d5u5
	 xoUCUiE0Nrpo3JreFr3Syjku1a7cUxzCBA51BXeomQ8LaCQn+C6YG4kpXSJt1GtsAH
	 My/UFQ2eW1ZQU3qsffJf6WIgR/Khn9xodUEjafPD2GIEsZzPkmlff44gxuMYI4sJdz
	 EBc4Vh9flLcx883zbmN0bcOeM7fkuA/1D6Ti40wSJyCks9BsMs9YE7veLfrBS6/rxc
	 2v2cYXv/TNHMJjk/y8tFDRk2M9pL1iAvbhsC3frEwJPHH1EBl0kaSqlmjIqbfAeyGz
	 or5FSHtZaE6PQ==
Date: Thu, 20 Aug 2026 09:33:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Bradley Morgan <include@grrlz.net>
Cc: Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v6 0/2] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <aoaf1qNNbv40Mqmr@kernel.org>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
 <aoV5EfBtlWcyf51E@kernel.org>
 <6CB4696E-03E3-42A0-9E3B-6BD1E143D5ED@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6CB4696E-03E3-42A0-9E3B-6BD1E143D5ED@grrlz.net>
X-Rspamd-Queue-Id: 8B3A91A0006
X-Rspam-User: 
X-Stat-Signature: r1fei8stducinr84mkokq13t86se7cgq
X-Rspamd-Server: rspam06
X-HE-Tag: 1787207649-400924
X-HE-Meta: U2FsdGVkX1809aJWT4mjaDzgNiAI9JkTbo8/nHBMPbUbKBpB8Qr9UgD6e47pTLy2qk2e0gFnsM6s/oafMdvVKabz8592FDqvlquebhjgIl1pw5f4n4Y07ISP4ujo+HAhPcS+4KBeeIMCKAOvCB4nr3QQUJNdqx9VGjNya0/hYqSyjzBM7TNoI/lBoCv9znlLL29mddpwWVD/4+ITomhJqw6xl0trYIkamupg9HhfHBhVPRwU8CKJiLlWYmEiJfvr7HlIQNVmHQLsEQIfnCian5XDaPXZYhMTaLgPKge/Ot3DHEFetlEETNTFxD8zAnh7f16FjClQmed0FLrD6xPM7OMn92ZK2Xs9L4BszOlHgZNL6PsMM2l9cfGh+Lis0O8oIEVrOCIt2O17xj2gKCQm0ycNnldGbkigx/cQl6IM2vh2Vu79w6hbSCEuEs0TTxFV7iDXKADSXtEZT6/Mo95s/JferBWXJuFL/j8KFa7Kx31hN5UVbzjV7cvo1i0z/hNF3a3e9frXuIonfYhroDKSNk4pL5oVRrHtHoFgDbTHIagg+CfQhxDDzxBFphdDoYNoPqJHpX7FQDn89zwycOWLBR1v/QZoK7Ah8RBPRzb7FoQRvAkVcD8MyoiXdVkxsu542AmCeqTHhG7Iv3Tg9OKXtgzi7+dSOzYKqEB+szqVSzH57kgIiwfB19WDTWLRWKQvn6j9GT4q/3pbKT1oEykDXNJc8cM6JoHW9ulymI9UBHKL6y1bV7UnbCFVNyMlfeWtO+2SAaDYuliLHlnT5T3nfXioH23qZnE931JARd3EUjc8jp+7Mm9BP9HQC9Hjo2ICZbh8bejyBvhBq3zegqrWGQ1TAbuGAru0lBLbz7QXAN9E3S9UjJv+FZQ5F8SD0T6WNPOt5eHXF9Mbu7vwsorWf83M1Bw7mBuE5RWDpeUqCvYlnPNfLWYWapKawGAU7BAIN4WpPEJenp0OMzQUZ5L
 9YD7M6M7
 QOeK7MbAuuHRCsS9XF1+gO4CZMUEFU+7ULhED9HcDHUZTgrJ++XGWF8VOjxgbi1QtWJUHv+jsFlvJT1zPnE9wcFBFGmbKdkq0GNSJVwV1+oVqIpvvJG1WJkUedjz3HzIeJuAVtznAZ1dxs2cWxvRZBAurkMxzC2j+E+hCycsQXNUBzJKAP6T29nQCrnUHUWmkF7SZtFGuKbWyDxy2f2YoyazEKk2swrMqC6qORHeIg0MFpr3S6zced3FBX/QURu69+GvQuzi03lEJvK0OXnG15hhv/15Wsvkd8furSo9qH15LUbbf8u087wbQlZ85upRiUWHJIpXOBoWc4bmTCzALIbs39IUmpNrEPUdRDsa0fMAsAq1/iStRJsY3QPUuDUGwMQbwr7nK+lHaOo8SRVd6tas5WZFulwlFzP3PE0YCTAGbbjq3txKrTCYW8v6OytXz48t8DMjz2xqyPw0F5C5gY3sAaorUEi0OfY7GQmFdDtvtsIkNhHqPjXysAjWCYNNT35xGyAzp/KeczKkl7sjMUgGEOA35IpWEuYgE4IqiIYHGbJBFQ4gIXCVguTQvUTQdKTfti/omkgEaKghMu1RonTfbjM99/HSl1n/f2W+xFvZsj6TYJLIKujR8miVnq0ju3RX3NA10szIHPBY7jiXmXiKPjMfnYo12Si4+WSF/BE0nPDULIy/XWsZyDIHNRoPl8dmbvIy/Up35XxMozwOw7RMr5lb+zLkR0FhhiMgQnsr53O7HR3zykCundGmWYQF0iAeLN5Gvqddy7ZArjodWKBjPyZ4sIKZMxZZjgNu+juFIde0wABDHUUDxDIFKNZQMKlKvEKI2+t/8WVzpQFUvloIDQzP/icZHNCfXV7Bsa+uShQIpEhuDhyeqC9R3XDpwnQCD7Iea+IuJyd3j1QviuDjCyd7nCPQyElpmks3VT/jzJVmGw8vQ1JlHxIKaJ7FV1i0Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 03:23:04PM +0100, Bradley Morgan wrote:
> On 19 August 2026 10:36:17 BST, Mike Rapoport <rppt@kernel.org> wrote:
> >On Wed, Aug 12, 2026 at 04:31:50AM -0700, Breno Leitao wrote:
> >> Memory failures are common enough on large fleets that kexec regularly
> >> lands the next kernel on a frame the memory failure subsystem has
> >already
> >> marked bad. Patch 2 teaches the segment placement to avoid those frames.
> >> 
> >> Patch 1 is a prerequisite. locate_mem_hole_top_down() walks candidates
> >> downwards without ever checking that the subtraction stays above zero,
> >so
> >> the walk can wrap and report success with a destination outside of RAM.
> >> Patch 2 adds one more downward step to that loop, so the bug is fixed
> >> first and both patches rely on the same bail-out.
> >
> >I queued this for v7.4, the patches will appear in the liveupdate tree
> >after the merge window.
> > 
> 
> Ah, so it'll appear in a maintainers tree after MW?

Yes
 
> >> Signed-off-by: Breno Leitao <leitao@debian.org>
> >> ---
> >> Changes in v6:
> >> - Split the pre-existing top-down underflow out into its own patch, and
> >>   drop the "if (poison < kbuf->memsz)" guard from the hwpoison hunk now
> >>   that the loop bail-out covers it. (Mike Rapoport, Sashiko)
> >> - Reword the changelog: the MCE comes from reading the poison back, not
> >>   from the relocation copy writing it, and the placement paragraphs read
> >>   better split up. (Mike Rapoport)
> >> - Move cond_resched() after the struct page dereference, so the scan
> >does
> >>   not yield between pfn_to_online_page() and is_page_hwpoison().
> >>   (Pratyush Yadav, Sashiko)
> >> - Keep cond_resched() per pfn rather than batching it. (Kiryl Shutsemau,
> >>   Rik van Riel)
> >> - Link to v5:
> >https://patch.msgid.link/20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org
> >> 
> >> Changes in v5:
> >> - Return -EHWPOISON instead of -EADDRNOTAVAIL
> >> - Leverage is_page_hwpoison() instead of per-page check
> >> - Link to v4:
> >https://patch.msgid.link/20260807-kexec_posioned-v4-1-70d57f14625d@debian.org
> >> 
> >> Changes in v4:
> >> - Anchor the top-down hole finder on the first poisoned page in the
> >>   window and the bottom-up one on the last, so each jumps clear of the
> >>   poison in one step. New range_first_hwpoison(). (Kiryl Shutsemau)
> >> - Count a poisoned hugetlb folio in full: the flag lives on the folio,
> >>   not on the subpages, so the per-pfn scan missed poisoned tail pages.
> >>   (Kiryl Shutsemau)
> >> - Link to v3:
> >https://patch.msgid.link/20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org
> >> 
> >> Changes in v3:
> >> - Return the address of the last poisoned page in the range, or
> >>   PHYS_ADDR_MAX when it is clean, instead of a bool plus an output
> >>   parameter. Renamed to range_last_hwpoison(). (Pratyush Yadav)
> >> - Add cond_resched() to the scan loop, as a segment can span half of
> >>   memory. (Sashiko)
> >> - Link to v2:
> >https://patch.msgid.link/20260730-kexec_posioned-v2-1-f92d18551f64@debian.org
> >> 
> >> Changes in v2:
> >> - Change from pfn_to_page() to pfn_to_online_page(). (Miaohe Lin)
> >> - Return the poisoned address once we find a hit, to avoid the O(n^2)
> >>   rescan. (Sashiko)
> >> - Link to v1:
> >https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org
> >> 
> >> To: Andrew Morton <akpm@linux-foundation.org>
> >> To: David Hildenbrand <david@kernel.org>
> >> To: Lorenzo Stoakes <ljs@kernel.org>
> >> To: "Liam R. Howlett" <liam@infradead.org>
> >> To: Vlastimil Babka <vbabka@kernel.org>
> >> To: Mike Rapoport <rppt@kernel.org>
> >> To: Suren Baghdasaryan <surenb@google.com>
> >> To: Michal Hocko <mhocko@suse.com>
> >> To: Baoquan He <baoquan.he@linux.dev>
> >> To: Pasha Tatashin <pasha.tatashin@soleen.com>
> >> To: Pratyush Yadav <pratyush@kernel.org>
> >> To: Miaohe Lin <linmiaohe@huawei.com>
> >> To: Naoya Horiguchi <nao.horiguchi@gmail.com>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: kexec@lists.infradead.org
> >> Cc: rmikey@meta.com
> >> Cc: riel@surriel.com
> >> 
> >> ---
> >> Breno Leitao (2):
> >>       kexec_file: stop the top-down search before it underflows
> >>       kexec: keep the next kernel off hardware-poisoned pages
> >> 
> >>  include/linux/mm.h  | 14 ++++++++++++++
> >>  kernel/kexec_core.c | 10 ++++++++++
> >>  kernel/kexec_file.c | 20 +++++++++++++++++++-
> >>  mm/memory-failure.c | 40 ++++++++++++++++++++++++++++++++++++++++
> >>  4 files changed, 83 insertions(+), 1 deletion(-)
> >> ---
> >> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
> >> change-id: 20260727-kexec_posioned-72bb0a4143a0
> >> 
> >> Best regards,
> >> --  
> >> Breno Leitao <leitao@debian.org>
> >> 
> >
> >
> 
> Thanks!

-- 
Sincerely yours,
Mike.

