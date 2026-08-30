Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A5EC61DE4
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E736B00A2; Sun, 30 Aug 2026 03:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F00F6B00A3; Sun, 30 Aug 2026 03:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D546B00A4; Sun, 30 Aug 2026 03:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D47DD6B00A2
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:49:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CECD2A3AAC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:44 +0000 (UTC)
X-FDA: 85157161488.20.E30AAC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1DF8C20004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNe9x6Un;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Kmf7UNuR3TJfz0wmHchwj7E8FCZ4Ng6XB4qrntzPsXg=;
	b=JULSA/YkqRHLJrfay0Nc+qlqHUdEcfs8456bEfX+w0fBRsDUU7guFigBKIeT4Qs+JF0WFQ
	it1jRPQCZxSBm/MID7g98VzoMedRgHZWIglIpmswoxYlRgp4bu9RKseGFOG1i19AjTANpx
	a7/dfh3lUWQYF8gFtUDiXn3pbS9CDms=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNe9x6Un;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076183;
	b=HBbYILtemujLEFNj6sNq4A+97U83QyO2a0DVnzVCyMX3l8rvTfl3u29IXtWp36hoS7Zfrg
	wow2uT9cI986lOWwggUkY9Bp2rbKmzBywEr8g9CYbe6iIYCe9VVkBF/nPHiAeA+dMZHT7s
	h2GlkNBfIdSQA29S6UpQY5Tds2LS1w4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B5E54059D;
	Sun, 30 Aug 2026 07:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A190A1F000E9;
	Sun, 30 Aug 2026 07:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076182;
	bh=Kmf7UNuR3TJfz0wmHchwj7E8FCZ4Ng6XB4qrntzPsXg=;
	h=From:Subject:Date:To:Cc;
	b=eNe9x6UnAK5IeFqG2g12NDUx45i6Sa7NrF/9OqdSg+uGiEVFvzk5LFJM1blh/UbMy
	 BZdDLd/DVd8TX6VxnkN9vZ8z4Y0G81c3wDyXh6pV3V/c/msuMtzKI1ivKcA4LbE3GJ
	 SMADYzhe0EHnAp8QVn9iHnc4HAwNqZp0DizycG89nBIv7RLinZsDF8J5uANqqAdMd5
	 +2quL2ySSSXwdofmmFlhwgLBxah6rWfg7/YTIT0DhFiGrsE+iIVRR1rSgfZmODmmmW
	 bYJFZfVqhJVUepBerrCFkXFvHkrqPe7aFeEXQg2zv7dE5mUBz907gwL1aKOKkqXg2T
	 KV2IanmTnRHOw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/3] tty: replace page allocator calls with k[mz]alloc()
Date: Sun, 30 Aug 2026 10:49:36 +0300
Message-Id: <20260830-tty-v1-0-0cbe6170649b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6DIBAE0F8xey4NRavUX2k8AF3r9kAbFhsN8
 d8FPb7JzCRgDIQMfZUg4J+Yvj7jdqnATca/UdArG5RUrdTqIWJchW5Gebddo1tlIDd/AUdajpf
 ncJpn+0EXy7Q0rGEUNhjvphId7K41bNsOOOCfDYIAAAA=
X-Change-ID: 20260829-tty-84f05b74862a
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bkpc5mzx9gj4w6ewiqn7hrxqgkaudyuw
X-Rspamd-Queue-Id: 1DF8C20004
X-HE-Tag: 1788076182-787362
X-HE-Meta: U2FsdGVkX19adtN+Tf+r3Uo9ij4xUvHa7yqV90od2wQRnJFQXDnt2BNUNnU5HN6Ps7Pz3+8yvQbyKdPk3P1yAMRD/TU1eV4jRi+lgPsiQuhQ75/w78dcRNZk/4TUatcrkygOSGAEhk6OQzW5sCyuWts+mbp5q39vxYmaizg6qsnJBbNCHrSAH/qymacxzGk802oFBcoZPJRSsOTx0sDtX+qNjxzw3pSLIhdb+AXv/VHTTV/IwsZlyuNjX5wdW8m0YiTbzK0ScyEJQJU+IU9TSddlxXWkvAIADwgeZt0vQeCrbNOxsDzw2PqhUvU4w1m2rot3vR/sEXhdXofKtZCpcItqRJ9cdyC9LSKuMY7kJSr/x7WX478uyDLv2j5pnBmc9NBxNtnZxLrdIHYIBzQFg+IPsl0m2GK8ZDIwQgZzku78BmjJGbXPUj8CyHhXlm5GpN8rP47gojWUPpqFFYynKFh35NDvkn7BBjIr/bxOm40LEKeIYo9xRbUyLo2p1wX9Vse7eaH7AqsMCFBhApTthQES8Y92MhbOVaGu0Rp+7gTploruiAyzy0hm+hUVFwV47Vx5dGBp3A6VyoU3DzB367QUAirqlyBgGbfdxqjra9gnE87EFnPbpiD0Gf9yO+cVw07D5NNPD5YRemLEV8+ErIgBDHGAKEiVKn71LDBwZ6ENUOEjxBVuvZyKWE7vBNQRFsYxN7cA8vajNIv9xGqMhp50yV9VDE16CjDYlN9r/kUxA3AQmFBccd1Avv6BSe0RiSKYBjhepZ3fxovScHK/vJVQ8Acj/t0O8sgdVC0ghO8BvhIH3CS6ir4HfRJZLi4oJO54t4I42f7geYVy8rWhic7LjI66PmYRziikMtkR5iZOSmnfXx1me1gkyRFRh1Dgad/WHTG/j3VR5BaFsB96vl7wasChOypxOdQ0wVPEq+PzugDCChoVv8i/BHbWF5APWDGmrVQxP3uDNgf5wPd
 VWEReoaX
 hK+MwUqapG10zJ96yZlw2JSmZ5gytplpg/yOtJ62x69iZtOq3xqaFQnxpMGcFeNI369B6ErN1nVWN1+UXT9YkC56Ry9yiiXR46Dx/yiX3hAk62SXN79UnLLStq233/eZz2vHLnZsJojeNAAUxB+GlE6hdnywuB2wbFEGgQFKoRUzF2Apkf8DUg8GBvhsQt9/RZQbvVDECE9pn8XozGQpR7jcV4glKEPlzD28/E8ufRaTHpohucsRbHbTxhZU7Mh76ynw2oR/eGKBjqgM=
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
Mike Rapoport (Microsoft) (3):
      tty: port: replace get_zeroed_page() with kzalloc()
      serial: core: replace get_zeroed_page() with kzalloc()
      tty: hvcs: replace __get_free_page() with kmalloc()

 drivers/tty/hvc/hvcs.c           |  6 +++---
 drivers/tty/serial/serial_core.c | 16 ++++++++--------
 drivers/tty/tty_port.c           |  8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)
---
base-commit: 1b78070aaef63512688aebfbc82365ef9d6660f1
change-id: 20260829-tty-84f05b74862a

--
Sincerely yours,
Mike.


