Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183A5C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D6D6B0088; Sun, 30 Aug 2026 04:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE656B008A; Sun, 30 Aug 2026 04:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D043B6B008C; Sun, 30 Aug 2026 04:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFBF86B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:10:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CC9880293
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:49 +0000 (UTC)
X-FDA: 85157214618.26.6DAE387
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99A90180009
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+CnEfqt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788077447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=roA3pn9tytWMEXCOgBxbLuMlI73dGfxw422usJPW7ws=;
	b=manyfXsyXl+iz7gP9YB5ek4MDULlP2KsNfmvYLhKkGSCwg7MNNYN6POJV8wqd0LreFoYnf
	FNBQ2nv3zCNb7zhcEfBPhAO5F48vdp09NMviCxrO8vSkNyl0UQ2p3I5ZksM32isGJahwNf
	yK5hwR6VjzN/3/+wgWYdgKMJjuCs8ik=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+CnEfqt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788077447;
	b=CIjPj+1WGBX0IkP2/8or9J7sszV2q4vDMhTRRSqD/Ldx1K/rzoZ7dJnszu+eFeFyv+yaKE
	FTlWY4mf76aQHBL8eJc399RfdN7MKAVTk5gSqpos3oK9vPHEmWT17EjgXKfMwOMExTiEhl
	8f3Nm9A2ATiyEL9mAbwJt5xvyJ1hTRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5317B600AE;
	Sun, 30 Aug 2026 08:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4D51F000E9;
	Sun, 30 Aug 2026 08:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788077446;
	bh=roA3pn9tytWMEXCOgBxbLuMlI73dGfxw422usJPW7ws=;
	h=From:Subject:Date:To:Cc;
	b=g+CnEfqtLN6YUoq+dT274N/zsTIZktli69oN0lC8EXm6TfKebORKrOjPyJ5V4Hc1/
	 7ZJRxEfuZwTEBu8hxRmGCytaJh7VHkbyVkTRhm8wbUxHObSYkTvyz5jyH9LaBs+hDb
	 IQHVTJO1tqpCZY2nfl5rug+O+lNQzgt+NmKtUbxmTN7KtIzvKocteZOpga8xLeN9O0
	 dbATn+SstNgbhJi3do34ibCrnWKCajk1PwKSqhAXeZLFGGJ28250c+zUNC7YUXn+bc
	 8O/dYy95oiKmlzSTKtwDFRdUKO8NlAdZphtdTa9D8UWr4jwZ3IdJhCs5+f/JSUOVrH
	 uRSbGkLeJTJ0A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] USB: replace page allocator calls with kmalloc()
Date: Sun, 30 Aug 2026 11:10:36 +0300
Message-Id: <20260830-usb-v1-0-aa349c302246@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMzQ7CIBAE4Fdp9iwGMP6+SuNhgUXWAxq2mCZN3
 71Qj99kZhYQKkwCj2GBQj8W/uQGcxjAJ8wvUhyawWp70Td7V1WcwqDPltDEiAFa81so8ry/jM+
 /pbo3+alPe8OhkHIFs0892nk9nmBdN1ZD0b6CAAAA
X-Change-ID: 20260829-usb-ad052ea1ffad
To: Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Johan Hovold <johan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 accessrunner-general@lists.sourceforge.net, 
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: a586pyomynckxkq4tb7zqkitxim6gkaw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99A90180009
X-Rspam-User: 
X-HE-Tag: 1788077447-503738
X-HE-Meta: U2FsdGVkX1/vWmuL4K5X+/uyM6aUXHTbryA+KLdv34R5uHt4EFQv0jsgbmBUFn5IdazZAV218BZnZ+uY8TrB7zVBCReVL2Mll58l17gzVIQKCf3w4dT3r5WzoBRh7ZNjMck2yTlCxnuOc6LGAx94W6yKOT2591FqTQj/8kZQJwG72ZomcnSOkbEbzI0Z4mHBvWCaujTN9VuyTOcbIMV3iV0H/aQPOkRbX4cVb0gtE/9GT7p8m3elbTw9JND3Bpzyctf7usp/aNC1yxhSz7rkvESckSKbLf7KBzkGjagQW8F2kPAlzh476V8fwHmKKHJDty1RVmShHJb/ayhDkJL1w/9IFoyiC2ZwssVvbh9AtcAqa8sLMW/ilWK86QFlL5UQztKG9WNX7PceBRIPitbMc+qKh64aYNUeHiAXY4zJaN/rQyqxGjbE76zQgkIMSZatWnbNoa6rKLjr0tK3eVdTl74Hq69UMue9pm4DhkZNrM/HYv+pzo5LjGCB7sX1FIfn1dPkAm3GA5hTG1vfEwvMnL+VhXeTtU461JTIrl9apWWQ0t4VUqGeZMuO5C+hve2fWg9UXcIBnjJpZk9xJN28w0bUDwuFYnXCEiO+c+MzpXYuZlepe1oZSytYYd6PuMjwMYpJgy7eWpkkU5ShGT5xGSfQXviCh2aTBw8C+xgkBRXIhrhE7EBmXMfpzayl6d6VcMXLTZG/daCYhdJP12D1qkQ2ZDMhdPfz82tJ7+qw1iUjcs49XK9cdqDxIufH4pgkgSZ6/1psPyvENjGQVavy5KVNqNeZsmkO1oip6y+YkG0Lgoii6aU0wpBKqSGCu7iS2o9vfCTjqpiXsGj6JQtl/mVQh4kken8oK5Z+Sdf602oc8QwqQU4VxIM1HaztJJmImWGMTnTJSsuyOeZwNaGP72ery5zw6CD4vN8eWERbI3yi/L7Ro71m2XjS9P26AXyoECi/iSRXNGvJybEBc2/
 jX4qxH5b
 7WeyCDnak/7/mtF8xf7/mTjrNoFnGRpGJRQThtcFkwf+gLWiY8c6tM/Je9+e1BGUo58Ay0OrRKprvCCgi6xZACvoBjqQUDjoo+3wRDtwuqZcJjcErymCD7w082XrgymJjFbZJBltWdUUFdR4jE9npjrOnB+p5uh9TRapknPVoQ/CPoqNbmtJlB/S4TnBAda2/87cUojVK7c3zeojF4S1yGJOI+YCrySKc59W8D48K2vqU6Ef3foqaYqBRekDGuAlVxhhNT3SuYo9XsMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

The patches are deliberately kept small: each one deals with a single
driver or subsystem and with a single type of allocation, so that every
conversion can be reviewed, and if needed reverted, on its own.

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

Note that the buffers in usb/core/buffer.c and usb/mon/mon_bin.c are left

alone: they are mapped to userspace and thus really need struct page.

---
Mike Rapoport (Microsoft) (4):
      USB: usbfs: replace __get_free_page() with kmalloc()
      USB: cxacru: replace __get_free_page() with kmalloc()
      USB: speedtch: replace __get_free_page() with kmalloc()
      USB: serial: wwan: replace __get_free_page() with kmalloc()

 drivers/usb/atm/cxacru.c      | 16 ++++++++--------
 drivers/usb/atm/speedtch.c    |  4 ++--
 drivers/usb/core/devio.c      |  4 ++--
 drivers/usb/serial/usb_wwan.c |  6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)
---
base-commit: 1b78070aaef63512688aebfbc82365ef9d6660f1
change-id: 20260829-usb-ad052ea1ffad

--
Sincerely yours,
Mike.


