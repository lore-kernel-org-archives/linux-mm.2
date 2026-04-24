Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F88AFE5214
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC1D6B008C; Fri, 24 Apr 2026 08:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D6C6B0093; Fri, 24 Apr 2026 08:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C226B0096; Fri, 24 Apr 2026 08:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F39C6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:01:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F02E54014A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:01:21 +0000 (UTC)
X-FDA: 84693309162.05.E95B499
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F4A518000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:01:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XXhpjgvn;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777032080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9gfDuuaXGFcGzcTQeLr1pg8fqm0C7Flns4/9cvFi4g=;
	b=pJTrQ3m70XaP+/3oNve2jEPz5+XeS73SyX+F5iwSoLsWvQUmhGN5bHwQV7V3Y5CMib1My4
	lOv+C62CrBkAOOKJLo5uY38g1s2abpbT8CubM9YMwwwKPI8tJy5fkhFprcS9iAVYx8Euet
	OMZfhbbkBAWCwKq9xH4T+MwayP/0E/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777032080; a=rsa-sha256;
	cv=none;
	b=SK2CdmHi6aCBllkNg/OqT4pPLx0wvoJWkl/VLqXlhSrwJBZFF+rWxuUEwj6LhH8XsPWYTd
	H1QH9HYCNJAUu1OITIWT1mJ+eGWlYUljUq7ziZj9dLchglD7b2cCBhCOlmpqU/d9pV2bOm
	BYLJtmL3QM0hG9/wMDNnJxx2Atu0KxI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XXhpjgvn;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=i9gfDuuaXGFcGzcTQeLr1pg8fqm0C7Flns4/9cvFi4g=; b=XXhpjgvn+c0oE9J0xyNK5mpMTS
	kUx+kT9SiAQJQHow1kuklllfRYjp1nacBmIV6NiAm/4iuo9zbo2lQ1vk2QMuF/Esq985vSWJtpHH6
	onBsQragEGxgW8PFJ9SQZ/kB3P+ktm0N+nqjXTxia0n6bW449lIyALBK8wobcvq9eS+rGZChiCBPU
	O+/ml6KOuQugS7YhUCdPf8qPgzTIuUaexfm26y8itblIlcOGXAnxNRq07GFDLeBrqcCQKKlIGhGQr
	HyQc51x84G0ritTwD28VsX+RGp5ar9kMoruGbjgnfZewEtZl9FqpY+b+mznM4BVfzx5CmAz6IXf5Z
	d8WmURlQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGFDW-0039ct-3A;
	Fri, 24 Apr 2026 12:01:07 +0000
Date: Fri, 24 Apr 2026 05:01:01 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 2/3] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <aeta8Ifvmqi6-E8w@gmail.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
 <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
 <aejlg62nxcF_5g2v@gmail.com>
 <c1517ad3-91d1-2ea1-efa7-0f29415d513d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1517ad3-91d1-2ea1-efa7-0f29415d513d@huawei.com>
X-Debian-User: leitao
X-Stat-Signature: 7w9rq9dqjiy793a34sezy8dd6gooonxt
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F4A518000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1777032079-219636
X-HE-Meta: U2FsdGVkX1/Z6OVSjUVACuC6wFZ/dVtN78X72rzKODXuHYiw18c+e9eYyWwyz1rK+h3Ty1lpptFmM2ljY36+jV52vpqEMJpDfaxZcXGXcc4rmSg3y8eBz35idy9Eq9mnjfMXk4ekhORIbMuUf8yO+TYYNaVtLitEDrJhRzMLgKFTd1DUfWT1KxeD1jcPqj4AxRPgeTcjO+23DI5fYOvvtoOIbcT6Nvrm+LZ1tgou/Im/qhvK1o2gxFmdf45Qh/VF//jGXaaeREKE50l6iq8V5jpXpHMx37z5r789hMqg6QN/flEPJcbNdur5TKwfFBSJ0a2OcnxPrjzzmCS+0odivaNrEjejYm4AcRiw1XmMw4iNMh03mrDaw3UkcJp0nBx73TFOAp1iNNNYFSf23WKEsG2HJKg8iZetx5vcEOBY2rezEw/o39TFO9/5MuSECn0AygvOEXQwmeegFZz3byzY2+0XCmz6jX7vtmbqJnVMx1J5WwEy9GEULfiJyI1dOQ3EQEEqHm/dQHf3mOmxng/9XYjuDuzi/0iklOLl+nXRxqHKU20f7nVRIAgmZ3xZFFdgtX5gLHXq5d3UV6CweWdy7vb3mNzh1bi31NJNF1bsI7DW+6EDhGyC4mQaOCA08Xz6AxQd/MXAywFTPuyrU3rN4zOmen/v14QmPkiqw4KtWS+IALCzXlXw9mLo8Mbk+TGhwpz3T/8RLf2IVQt3AZxKWrjzDLlzrKNNbsyCji23D+/4dHd5M6KZOpZtSXBXbu8UVhervSc3dtuZ7uU0uwsPAazKnmV/hWmVTXjlh/NDPRBGMlEBpixmVl6P0rbpJf2WRmHWLU7CECviiQRCqphKpDr1dvoWR6SJn5tMIJLuCtczY0wWUNMiOCGVB7Q052NCpk0mKOG6hoR+GQdznEGXLh/cSz2SvoUsR3nO/zF+ZE3hjmonTUBMRGrrCwxH4TbYpKNNYjfH0y1an+Ue9Ap
 lvoUZGVS
 yF2XJlHeSddoRED3b4MFpTXSzFq5J6PM1KzJ8AcMJ9mjvXsvk2LD/2Db2iu0wy+CdAHE01X+LvoYrYWZfFOBpAEEG2Yi/G2JGOWiEhNDHc3VZ4YG3m36eXcflRQ/dziLVFtnIfoxbdwcJNo4QoxWS2EzTh+mypz7gAH2w9Moz4etpwaLso1tiogHnEfU/2j1A5yliQh8rhNEso3ogQShRZQju7LXL2luK8fQVZ4hUOhAAlJjTlMnyvo/0v95oSSqbht18EbXiBBLG89Z1O4qfu2v6XzeFvAbkGx3StDpuYI9J0PE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 10:38:19AM +0800, Miaohe Lin wrote:
> > are you suggesting I drop MF_MSG_KERNEL_HIGH_ORDER from here, or, document this
> > will not hit userspace pages?
> 
> No, maybe we should rule out or document above rare case if I'm not miss something.

Good catch. A buddy page being concurrently allocated to userspace can
briefly satisfy get_hwpoison_page() == 0 && !is_free_buddy_page(), and
that page is recoverable via the standard SIGBUS path — panicking on
it would be wrong.

The page allocator can't filter it out either.

check_new_pages() is gated by is_check_pages_enabled() and is a no-op
when CONFIG_DEBUG_VM=n.

For v6 I'll try to rule out the race inside panic_on_unrecoverable_mf() so
action_result() stays unchanged:

	case MF_MSG_KERNEL_HIGH_ORDER:
	p = pfn_to_online_page(pfn);
	if (!p)
		return true;
	cpu_relax();
	return page_count(p) == 0 &&
		!PageLRU(p) &&
		!page_mapped(p) &&
		!page_folio(p)->mapping &&
		!is_free_buddy_page(p);


A buddy page being allocated must transit rmqueue() → prep_new_page() →
post_alloc_hook() before the caller can use it. Each step either bumps
_refcount or sets state we can observe (PageLRU, ->mapping). cpu_relax()
lets that remote-CPU progress become visible before we resample.

A genuine non-buddy high-order kernel tail page stays unowned across the
recheck, so the panic still fires on the case this series targets.

The window is much narrowed now, not eliminated — I'll say so in the changelog.

I also added a selftest that enables the sysctl, injects MADV_HWPOISON
on a userspace anon page in a forked child, and asserts SIGBUS (not a
panic). I've been running this in a loop for hours, and I haven't seen any
false positive.

Thanks for the review,
--breno

