Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC279CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5242E8E000E; Tue,  9 Sep 2025 10:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FADB8E0003; Tue,  9 Sep 2025 10:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437768E000E; Tue,  9 Sep 2025 10:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30A9A8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:44:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF840160588
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:39 +0000 (UTC)
X-FDA: 83869983078.19.D4C690B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35597C0015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XOdIY1Bv;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UrfLjqoesH2Mdwkd1Uq8kj4vRyvm4Z28yUkSYQofXQg=;
	b=RBpiwIvN5QuMldwhDJYRmxp8tJTH8GAhou6e19RPeKyizcMMIlrAMrZ7RyomeSn6bE4O62
	3SO4f3YtUo83sbKLfvcBOiuqk6xADyEFmToTqXUXs7/pEZcMFtrj+6nBXA0LPcex/FHrdW
	gfxO05ZX+JJOmul0jG2waGa48DKLL/Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XOdIY1Bv;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429078; a=rsa-sha256;
	cv=none;
	b=FT7H/szZBgaMeHbgbnqkUHon2W7W3EtVOwuYFP91QK6XQPrRYSJXeFt4RdiXyIS70PSVq7
	+g9Wwgc7Inw4mhWvgw6gFbrMtJn9py5l1sWfnwiNHoZgQqBp0BZ2ON5H9sz9rvAiOkZbB3
	ber9eAr18IanO8BiWDBBmDVjgqKNPIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 650E660224;
	Tue,  9 Sep 2025 14:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0B7C4CEF4;
	Tue,  9 Sep 2025 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757429077;
	bh=gr1qOquHmGnAq/jY71lVBf8+IAgpqOxYBEJiNJgw11k=;
	h=From:To:Cc:Subject:Date:From;
	b=XOdIY1Bvtm5/HQ3Iyd6I4zi6z1teXURtfIj2qsCbBwJ/B1fq91940d14ku6nZXAvy
	 FGHtQINugOPSfPhRObkdKVa9fSZ6opE3H8hSg786egjE+xrPstMsKjm23QyM28TiAu
	 7WW5PZEasI6WKDsH7p2byHV6ODIq2pMKA2+HSAINeyH+Gg7K61cbc8Cltw9+HxvspL
	 PKOhjeQB3g63ev+XnJvDNQnHq3RAVyh5EySucVBhOU5M55Yo0XArUFsuWYZFZktJ9n
	 kIShKdzJCeqyf5m/Nxt02v/gGZkoEs9q7wJC03XHc6IT3Ss5CMrghedNAemAk1gy5O
	 QEZy1m3N9IiVg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] kho: introduce the KHO array
Date: Tue,  9 Sep 2025 16:44:20 +0200
Message-ID: <20250909144426.33274-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35597C0015
X-Rspamd-Server: rspam05
X-Stat-Signature: r51nbk47g6bh5kxdpacmifbeg8rntnsz
X-Rspam-User: 
X-HE-Tag: 1757429078-598253
X-HE-Meta: U2FsdGVkX182fvtrBDhPN0K1RUt65GVQmv+vCt3CaOgKCS0SiHnY1Oh6CCRT/kNRH03+g0GSXjVRkq6xxInRhOHBaTvey/vU370aY3hd/uxZffGUcwL+gsirPoXa97MKy4Ba4YO6L9RZQfZQP0ixk6DlQfz/rxp3+3AIkZAjI/zJokKozx7qJ4L61Y9HWIsjthm2X860d42lgFWtQEBs8Lf5BBUauYTbuny5qt+nP4ksmpspABxkgkOMW7UD1rjSH4+x9bQwjYyyX08UnMuhJs7AFggqBK+7vIur5tjHjOa+mNvEb1NhwEi9NBVerS6aHFNa+r/fyrvJJ0Wb5tVIozDwIXHwO/qyJX+pLfgCw0gPKoKix9tN64oyL3TDVhcRfcPBZLuxfv1k47zvDbcS3H3ASo+gOCQTqqY86tTv46PLAajTYqwTz80AWtFio0qESwSmAKqRz5d+drfI3x2OyJWYgkAIjna5fuNQ6N3fHdHDqoFC6cRZJzbAoTgKTB3gh1xNSaFQb+/syY0yQ9hqsomR0rAyGwBdR55eO9CkxqBO5U+jUgMZfn+sdwVASuSPIhDKZDf2xa28N3sJxG0d9bGHN1Sko18J0cRsvATBOvOldyf1QTA9kZxq2+VgPgnGybTKT3jqPu7EyGoGwkLtSlXPK0tpdHAGAe8eyALBUDFsTYUrZi5HJx71RgIbkZK0wl2aZ6rcSIpaeJ1bV6wT2QFr4GNg7CCRQkEpe2+BqlSQEjA5zjWaTVnzhw9OlgYAcdgC3lUZs3r4GNWD4l8arm9BRi745WRM/QCj3H0XlIxUQq0WiKzgyZi2g+4NMfM33RIu9FPuQLlGnRIP9SL4BmJSO2fs1uiSgMxAXB7+rTXt3u0+bj6JrUblm9KE5Hg9cSQAcE4h7ZlUiPH/QIoBVorzwy9/Q7jP4bh528SZuwajui3xqbQN9XAfDalFC3kP4IaSMpQJVusIaUq3Cz8
 89ziRalu
 /ishHX5X+n3V08PpGftMZxCN9gE+qjSllD+rLUBfXRTSPNiz4w15I/9YNn04o/MJC/ZA4sjilV7slUUOZ1n55Li51sHCukILdF0/LZhcK5M62CtqBw2PzuZUNKyllt7Cd0laf9M5eFUMwgHD8QVrzFg1dc3SGAfjCXGRu5FNCIw03nJ6i6qp57oh8KNR2VX91nlq0EC0Z1bcoTtEsqFCtonCcgkxqEiGCE1k0y2+W/KUUcXWNawHHXvMn+7IzAh2xrnlqSwffr5rh+MbkjL3bdVSNaPCexKhwLNdg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series introduces the KHO array concept, and to demonstrate it in action it
converts the perservation bitmaps to use it. It also takes Mike's vmalloc
preservation patches v2 [0] and ports them to use the KHO array as well. The
memfd preservation proposed in [1] can also be a user of this.

The main idea behind the KHO array is to build fundamental and flexible
serialization data structures that other layers can use to make their logic
easier. There was extensive discussion on this topic in [1]. This series
provides actual code in action to give more substance to that discussion.

Patch 1 adds the KHO array. Read it for more details on the data structure.
Patch 2 converts the memory preservation bitmaps to use KHO array. Patches 3 and
4 are from Mike's vmalloc series [0] and are modified to use KHO array instead
of open-coding the linked lists. The full git tree can be found at [2].

When converting the two users to the KHO array, I think it did make the
serialization logic simpler for both. The actual judgement of whether this is
"worth it" is of course subjective, but I think this should at least give
everyone a clear idea of how it looks like.

[0] https://lore.kernel.org/linux-mm/20250905131302.3595582-1-rppt@kernel.org/T/#u
[1] https://lore.kernel.org/linux-mm/20250807014442.3829950-30-pasha.tatashin@soleen.com/T/#u
[2] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/tag/?h=kho-array-rfc-v1

Mike Rapoport (Microsoft) (2):
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in
    fdt

Pratyush Yadav (2):
  kho: introduce the KHO array
  kho: use KHO array for preserved memory bitmap serialization

 MAINTAINERS                    |   2 +
 include/linux/kexec_handover.h |  21 +++
 include/linux/kho_array.h      | 300 +++++++++++++++++++++++++++++++++
 kernel/Makefile                |   1 +
 kernel/kexec_handover.c        | 291 +++++++++++++++++++++++---------
 kernel/kho_array.c             | 209 +++++++++++++++++++++++
 lib/test_kho.c                 |  30 +++-
 7 files changed, 768 insertions(+), 86 deletions(-)
 create mode 100644 include/linux/kho_array.h
 create mode 100644 kernel/kho_array.c


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.47.3


