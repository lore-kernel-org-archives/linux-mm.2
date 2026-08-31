Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2333C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1B66B0088; Mon, 31 Aug 2026 04:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982226B008A; Mon, 31 Aug 2026 04:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8716A6B009B; Mon, 31 Aug 2026 04:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6842F6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:27:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDC444011E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:27:53 +0000 (UTC)
X-FDA: 85160886426.08.6B46A80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4012A120008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:27:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWpmUpON;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sdnDSnE27149BUcPj7rnlsDQtbHL0lCszRlaB8rnvRg=;
	b=ngb/fqoYdDin++vHk4Fpay/cXXR5mzFz3Q71gNMCvQHaVBZoviyltALDNbPbBahnMS9rqe
	+Q9uwdhGwlAwDf+TaA9Z3X4/r8Kwq/Wi5DYa1QaidHcbatLKSzSjwiJgp0ynrWtv9DYxUG
	GKOfCW9zAvMbmAZKbzgk1BklMbdwv6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164872;
	b=u7MyPpO6QHELLCUD405IP4DJ+u8jJLWSx96OMtb5UVfbhkOITM8h7UZaE/cxzi/Gdd7GQW
	BuM4NNiUsdo0aGwcsPtICSeJ7w08QDi/zXDB2Ucry/2sV1bql7FjcbfZXTxBf8qWrFkDak
	Fwipg7MgZacRkpOGMNqxB19TuaC7KQI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWpmUpON;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 046D760120;
	Mon, 31 Aug 2026 08:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237EA1F000E9;
	Mon, 31 Aug 2026 08:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788164870;
	bh=sdnDSnE27149BUcPj7rnlsDQtbHL0lCszRlaB8rnvRg=;
	h=From:Subject:Date:To:Cc;
	b=jWpmUpONIzS8DwMc97TLTkDvp8xhwhffGlQU+Gw9Em5B9/M5J/Cen3D8DG3Ny5rXA
	 /X3Zg8kghs4opYX4bsP2kTLk7XDnWbqMZL1Vzm8Jn5XuxlWYWT4hHFfEGvfrdd8c9H
	 NzVseV+IXY50R4md+TZPLh5gPD1MHVOAhL0DHzfVzpTNJglk+qDD37TlvsX99DW0Xt
	 9isP1ngUcA7K4+tMAixOnjetJSa3kcD67YzuGUckxXQs2OqW8bg80rihAolDXHb6Md
	 TAMBYtTxtXGKbCNm7OumQSKQVq06YANUkHxfDCqBserLdiA6hvWA6Ga4/Iplu5R8Ir
	 yc49DsjUUXjFg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/3] tty: replace page allocator calls with k[mz]alloc()
Date: Mon, 31 Aug 2026 11:27:42 +0300
Message-Id: <20260831-tty-v2-0-88cd58c3c640@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2OzQ6CMBCEX4X0bMlSsPycfA/Doa0LVE0x20okh
 HeXVo/fzOzMbswjWfSsyzZGuFhvZ3eAOGXMTMqNyO3tYCZASGhEy0NYeVMNcNZ11Uih2JF8EQ7
 2k1qu/Y/9W9/RhHgaE1p55JqUM1OUEtZ5Ga3J+jDTmj5YiljxHyshjS0FBw5GoyxqkFWrLw8kh
 898ppH1+75/AVqHITrEAAAA
X-Change-ID: 20260829-tty-84f05b74862a
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4012A120008
X-Stat-Signature: wtgk18htz8trid4sdu49wjoawr8twpyw
X-HE-Tag: 1788164872-958449
X-HE-Meta: U2FsdGVkX1+XIZYozJQKHGHHU4UIcUGWXj7iv8yz0hD2mtH06mwQCvdWzGWISjR7i5V32xLCDuETQr7jcT2xrfu8DqZb00vwIy9rzpTDj6/ygm6zGZzpDEhdV9hDRsQYzfevxHf2Mip5FS3lXuIcKYnCVDuvzT70gDNAVoB6jjPl/5NRmrP8zvOaiwyjNV4TDLMnXX9q58OG7z77zuOLMssssUq6DXNvbIlMeuM3ANpG6wG5YrXFkwPnptPO+U5jtvK0Oo85704FBoKwBVxTk8a5hPeyCAY10CyRwY7LKBIoutrffQXKFDW0Qn/sf/pCzexyPxbzO/1SVdE0XaciJTRoC8KRvKY8L7upJwKE9//iBJ3eBACCUVl0Vi45BYwOACN7q7wnRu7SzsBGzqrUiv/HBP9dygc+MHYGWw2QNUyIZVxNakRdjQaDGw4bvproRWesmunWeu0z0O0p5EDXKUY1wrhuOI5umnvLIYCZl6yBUQRSVHqAsbAaSQwdqbIEo3c46TBsS2I+HHnms7i6J9pBsKHpe/PfMyRQVg9XCyIyKNTjXdngs4e7n6xfsNTobanP2b6datBJnqhh76jQ6EduiET5Oq0WcakOOTMGYD+XfXq1lnbaekmPclH8tQa/tKoweEZm1FbW9Yz0555xPRsNUXx/Q2qI63Csfoa9G7PWnMX91zaezbauDezkABJDO6KWGlwQGAV8tU2JPdCuViRLuhGPWj15JcUX43yl5BbXjRm2DcBCZwbAydny+J/itx5hMowrjIhG/tZm2UGeHR4yY07lu/F/3mVoXgGmv72eayyi+Pax9dVsmAe44nTDX/mylXOP0fO3yAsH91XhYY/uyCuorrv84VVNYRKOmnljXgqBO+NlIZaawufkX+OmO3du9rYWN6/VxnRh2fT4fS0kIFUX9+LqaBmkFuOsItBOLsxKnwCQW5+ng/PnD1zEZ+CpX/OF+mc8lFJd9jo
 QfeWXlRI
 o8eYHda1wZnMGJjv1iSOt8GFpUUZ+PhGMxPAN0QviXsp4OEkJxcyl1Cvn0llBBmRSyNHJ5kw7pgNgGLw9q0KdhRFKZWEDv4qk9U4xm4PyzDzvkq1MjhL79Wo1CA6zqYn0X6siaEM6syLlFbz+9qsThcBraG/1QqcuD/n+bssb76P8QNmFZgxOUBCq5+qDd4OYX9J33Qol7+Vn+5b4f/IG//2NUFgTkPRAeg6CQ1mh4wREf9lhue/vFq7Tbc4d8sCK0T9a+NDTo941R9+q5r2cDrqTZr65cdja1vBHCWVKfft41UsJvn92J6R2LFxhq0LGJfD++qeVNcTouj2JaIgHaA62OKqinPeT+AWT
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

---
v2 changes:
* change xmit_buf type in uart_{alloc,free}_xmit_buf() to u8 *

v1: https://patch.msgid.link/20260830-tty-v1-0-0cbe6170649b@kernel.org

---
Mike Rapoport (Microsoft) (3):
      tty: port: replace get_zeroed_page() with kzalloc()
      serial: core: replace get_zeroed_page() with kzalloc()
      tty: hvcs: replace __get_free_page() with kmalloc()

 drivers/tty/hvc/hvcs.c           |  6 +++---
 drivers/tty/serial/serial_core.c | 18 +++++++++---------
 drivers/tty/tty_port.c           |  8 ++++----
 3 files changed, 16 insertions(+), 16 deletions(-)
---
base-commit: 1b78070aaef63512688aebfbc82365ef9d6660f1
change-id: 20260829-tty-84f05b74862a

--
Sincerely yours,
Mike.


