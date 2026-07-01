Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61BCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3C06B00B2; Wed,  1 Jul 2026 09:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3BC6B00B4; Wed,  1 Jul 2026 09:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94936B00B5; Wed,  1 Jul 2026 09:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97D496B00B2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:59:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C9C51C2D27
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:18 +0000 (UTC)
X-FDA: 84940364796.01.D773DE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 751E24000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vlm+1lqn;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914356;
	b=nxFZ0s6uU2s1zQkish4eVG0UYEEeYS69BniCopBkJeG2wSD8+0arsRGk0vlB1zAG1479an
	NII3hjmQ0njUxfkv6X1FYL3vhLVqD2e+zCXsGv60F4oQigEahMEaN3wMreHIsvz1XuzqYz
	waupf05NeFNHWRV5ciYo9D5NNXRhqyk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LpfnkoRQ/FIEnyqT9WtrevlR/4ONd3yok9y5wj54j9M=;
	b=r35hJvlQ/z+r3VNIHRWG5SOSGrwU5DawBGpN48UK/RlTjIUBk09najxMTIxPXt3n8G+UQq
	xDVL3QHHBQbc7b5yVE24t+jZYiad5uP5Go3QjxSkdAQRmVQ0oVJj6aUw1QklPWph5mQBKq
	1gJwUkiIbD9lfsHweUoXK10CCecN3mE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vlm+1lqn;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FD0140212;
	Wed,  1 Jul 2026 13:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DD11F000E9;
	Wed,  1 Jul 2026 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914355;
	bh=LpfnkoRQ/FIEnyqT9WtrevlR/4ONd3yok9y5wj54j9M=;
	h=From:Subject:Date:To:Cc;
	b=Vlm+1lqnw0+3/DGTRCUIaNB1c1zYGlJAGjdv2/E5QfdeDDPjsHdM1kPXDdHsF5YGN
	 3x+fE/ceoDxA2tEV8/6vz4ccOiZvAE/g9lTu2ggMVY1LIdW3rhPgzy/P4cP/22X4BB
	 e933TZn2T+RhdEai0fwPXAXP4mxuvEnuJzpZf1423uKckJhVeWxNLhNyPKFFLugtpO
	 ibOOET9A4lUzyeY0V052OdR+CYiehh/YbhQXoMUgjvT6n8e6TkvedxIdZ2xmNyoGyM
	 6CYy+C1j1qyNX5QZjxiIaInB2gjnLS2PpWBJqFvMmZS3sqI03ko3i7uEC6tFbztQqh
	 BEVYL8FVMTU4w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] drivers/net: replace __get_free_pages() with kmalloc()
Date: Wed, 01 Jul 2026 16:59:09 +0300
Message-Id: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC0dRWoC/yXMwQrCMBAE0F8pe3YhxjSgvyIesunWrkiU3VqF0
 n830eMbZmYFYxU2OHUrKC9i8igV+10HeUrlyihDNXjno4sHhxRwUFlYDd+ifGcz7P0x9D6MiUK
 Eunwqj/L5vZ4vf9uLbpzndtUalIyRNJU8tagRtu0LbS7gOI4AAAA=
X-Change-ID: 20260630-b4-drivers-wireless-5294524fab46
To: Johannes Berg <johannes.berg@intel.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Francesco Dolcini <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, b43-dev@lists.infradead.org, 
 libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: npeabbfd8oop6ego953uskmju8ep3ghg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 751E24000C
X-HE-Tag: 1782914356-376504
X-HE-Meta: U2FsdGVkX1/aPZugrWMN6FDvV4ZuC4RamODvdpBjKkM7XDyX4y/ysI9DuKTKNKIwcybcrGOu112r9l8Sdjou11TZ4/1gdUJx8UByuN4lBWnvnpOvZ0R94fEEUXILuo6gMlJCQHTbXwSiVQXpi+UW7FNKy0/m+KhYiku/M45zgbGGNXwi4WdVwpp1eQDl01gAORghX1ifUlDOCAzPkhuRoda1pvlYuol7mJ+NK6yok8tlVa38nnwoGqpJGdxYEloWp6d3ywqBuPDbmM/Nt0I+RGfPQb46f8TMl7AXWOhu6h/PetPKOyBeBJBELnZImRIBzukhgKBi/7fr9NqninEZPz1gMzvL3MzRd3zD9+DOv/NdWShegvf1Ge2ABcRV9wtxgtpLC0x0l7KyQVzc8kPTv8sxgJV31O+gy+tBj6pqzjpQKtATsh3R+V5lQb3nOSduNIAnHUpkuHpfdvYx1Zg5l/OiyGd5mexF6sgWWz8RA+ZMDH8VbDOqXwxSzkO+ZTzKcePOn/3X1FLpFGMtpygF6POuJNc2N1yXdyXRc7PCmBLzvU7CZZ/BXdNPdvGRAX3TqEPRvoHIkzXlF+YoeVJXq/Q6dlV0suPUzEbazVR/WZQv8ogMqDwQYpg5PtrIZiWus7vKSRFkpU6WpdED2jf/xIAhktsnqGKti0olr7ZCeBlDVbCjozHDNXMovsn7XsV/ZSQsTXzZRRQHAxkWFI4b4Bwf1LXhquclnkTRdafvB+SLDqlNjG6fBlCjEzqLqFvRhcUeQGXCU6qLS28EC4wK/iWYlaAEi5Z2javAU3ftC6RdarN4eosvNJ2S1jFCErKukWwJTOMMgZO3Ht7azIefjx4CpJVKog8VBuLj/aBPDXKUMcaPRb1ogS+NUvO4WOkipaPTjxw5rTLdmBQ8OZVqXIVAPVxoJMes6lDzHX75WupHTcsc7VbdEr1L9wWBFVxO2vClLEwoJnY6SWgjOxM
 JkyBecDu
 MAzLXuiO+you69nSzX+GM5A97QYTbDPVbj3sIPHevyF2ryOUOKauwmQ8lO0gHfbheMTRsl9YVFe8Ef/ambrD4u/ag138XhBoAr85VvRKEvLSywkjkqB9ayAIyC1noEt1+bsxKOUZ6IpdBBHdjEPXiP0miCg7aOkgsUe7EAE011j7lZpT3WJ4ppzBctPsl/WywU02zbZuX07h4DCZ/A+juL0+OdzR/fhG0OGqyyAVydjkaBZ3Gmrch4NyjbPTi/yUZMcP2rGDNBhlI5wfR5Aryu7jM6Xo8eiqk6G2F4rsKYUo4C6NNeDWsWf92LmRZJGwURxrpeRVLMIfm5RwP4Go25u7k8MBoyTgmSk5ATgykVJi1mesl5e2cKkXQhPtYrHP/H5S/w8htE+uGDHaqXo2tVxGT+Q==
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

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/drivers-net-wireless

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
Changes in v2:
- split out wireless drivers from a larger set 
- use kzalloc() instead of kmalloc() + memset in b43legacy

v1: https://patch.msgid.link/20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org

---
Mike Rapoport (Microsoft) (4):
      b43, b43legacy: debugfs: use kzalloc() to allocate formatting buffers
      libertas: debugfs: use kzalloc() to allocate formatting buffers
      mwifiex: debugfs: use kzalloc() to allocate formatting buffers
      wlcore: allocate aggregation and firmware log buffers with kzalloc()

 drivers/net/wireless/broadcom/b43/debugfs.c       | 12 ++---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 12 ++---
 drivers/net/wireless/marvell/libertas/debugfs.c   | 39 ++++++--------
 drivers/net/wireless/marvell/mwifiex/debugfs.c    | 62 ++++++++++-------------
 drivers/net/wireless/ti/wlcore/main.c             | 14 +++--
 5 files changed, 59 insertions(+), 80 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260630-b4-drivers-wireless-5294524fab46

Best regards,
--  
Sincerely yours,
Mike.


