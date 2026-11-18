Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5A3606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPcmpMZh
Received: by kanga.kvack.org (Postfix)
	id 826CD6B05B1; Wed, 18 Nov 2026 03:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7DB6B05B2; Wed, 18 Nov 2026 03:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7236B05B3; Wed, 18 Nov 2026 03:33:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E9F6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:33:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54E1CA82AB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:02 +0000 (UTC)
X-FDA: 85447574604.22.C2D27C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8A7B8140009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TPcmpMZh;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794990780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qek8ua6eHIWYT1YV4GUxD472coOCwQ3P3ofziBmkSG8=;
	b=Y2a589nI1Dw7nvSNCMap3x4mn5XjzWE2W7ZM6YZ8npeUl3aEfcZKl3i4SqYmQOzGs1ZQKc
	Ww89KQ7QJZiWcvS7QNPCPEhhCcdrX/QLb1mxCee9bYGGZYIinhZhLWvW852WKN8OmoHawU
	BiZwSG7NYvsR97Zv7zcM1h+pVkGnfOo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794990780;
	b=ZmGHr4F0VH9MddeyrlQc6pqWeG7uU59vf5Dq407Q3ZibWf7Eh6zeLEnpAGPMt1fxydzQ7z
	wzc2alVppBtHZR5+vcufkFpvyhRm6LxVuTDaSnyHu1ixf+0L5oUz/YrA8+kyHPFQPM1/OJ
	5NsjmxZnaQJht76ZqnRd8KO0xxX0GyE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TPcmpMZh;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C14861F8E;
	Wed, 18 Nov 2026 08:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EC71F000C4;
	Wed, 18 Nov 2026 08:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794990779;
	bh=Qek8ua6eHIWYT1YV4GUxD472coOCwQ3P3ofziBmkSG8=;
	h=From:Subject:Date:To:Cc;
	b=TPcmpMZhO0E9IMO+M/7wTgzTQ2TyFstj/Hj+fNtnOMRKBWcJqzyi8s7x04ufgxJFd
	 OtJYU6U5t2nZD0FUmpj7zSf+U5NT7MGA7XRcJ2sHhi+NfxDnqkY6SqqKAlE7eVnB+I
	 NT7J20qxcy9ZmkJujA0x2lYF5Bb6x9nDx90TumXAKYz6Pil0r/Ayu2gt469KNWCZvV
	 RvORY4Hd8pvhYKUMCk70Xr/Aco2Xd/rZLIcbM0gYpzGLMOvJb0HF5TNPfopYUPDLbc
	 9RTa5Rkw3PUs62EGj5NCmLRSKJilXTpOF7mgOtEE1b7sRACFc59b3lJgr0BMbDyNfT
	 nJG2hK9WFR+/w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH net 0/4] net: skbuff: limit pagecache folio refcount
Date: Wed, 18 Nov 2026 09:32:37 +0100
Message-Id: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKVi/WoC/yWMUQ6CMBAFr0L2myYtIkSvQgyB8pBF05puQRLC3
 a36OS9vZidBYAhds50CVhb2LoHJM7JT5+5QPCSmQheVMaZW8ujbgNH6xcXWrwjj079Vfe60PpU
 oqwsoua904e3Xbcgh0u0/ytLPsPFbpOP4AB4RvCt+AAAA
X-Change-ID: 20261117-skb_refcount_overflow-75a0034e469e
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Rik van Riel <riel@surriel.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3989; i=david@kernel.org;
 h=from:subject:message-id; bh=HZyNAn6wVm0K2Mhg0A9sA6QcH+I9r4/teclsbJx4eJw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+Jm3wWrFjxcEbfiITHJoX5ZVsj1s48ZxM8vs3nhO3P
 P3qzcPd3FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEDrAy/A/tvLe6MnPBnjM7
 w+77vZ+zOHT5ro8vY/eGNgr+ZdSaNLOIkeHCd+fXxWxWZx84sjmvaObkq/uwybXEPFZlsv8CU4k
 3u7kB
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: yaend5tuejdirgc6qerp9b3sguowapim
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A7B8140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794990780-313420
X-HE-Meta: U2FsdGVkX1/PlXDL7wb8Ii3Thu/vPJBbYP7G1r1yC85C+/8xWEIv1EC7++IpyIoIf0OvOyr0lF2LPoyUM0oTtUNdk5jUDaPmkMOUYLJu/1SOEmXobLrx0VVW0enAoqkhgw6mTk8yUj2Ha2DdhBFkVMliMTOKKB9OOqnkWnasRMY9pAAmmi42tGLjJh00KhR7ukSMrIIFDfBXKhXbRAZe1SkPWz0LzzQ1AUMNwdJ3b7WVGdCCEG8VfTWTbGWQfxVLWLeTkNKlSGGue0FvElER78kefUMSRSbU0I78I7r00FN9j7F4QWFbVG3Rs/akRnHn6G+9F+LJQKWuhcr5Z14VYDKou2NilqNL7YRq4SUxOhG+J3RFEUxaPmib8GFD3xuSLIuyVJwpkW0572G9YrY2I9otp5sqfK13BY/iw9psPsvxZ9iQ+J/MC/5omD2gwHXYM7M/k6ldIYIV5DV4mzW9yns7yKkb9oKtE6vXmYu9Ai0b770V6j3ZNVboyNkdaXG5fLFnerbKt60fMHv2gforUuk0MFurwvUen5BkqpUGD/PCE6McwGx3bLi4m9qUPLBHtbTICtFvpZbq33xjYRgl0+Cy1ca/m/zZXKR2TO1NTzoMIAvxe3CJe2WW1H6ES6jKDP2RADHwktu63QCb4oK38d3JPIFbinnizR3bWFmXp8tX/Xnc94YgQZIfzt3pmk7WcAe+DLGZLQiwPr1zDjfO7VHfFk+q41OZprmeq1WS8Ls1yzIdgSdxxtAEWa3NlT+5EPfHAvaNEZOrkv02Ubo5snoNhzOB3GSgKoQ5EvQCQxHYSLfF72MFi8utMYRYclwc9bBdOjJbi5KRhQQfBF2Xx6iSUXsM9phgeFsxaV2Sr8JxBMbm/YKlmJ3j4KKmJVXflmHUhbX5b52usvihA9z7UdcDYo7nl+tQe/oadPkW4OBq0BGYDfaNtyaKfeZQZs/EkxSqsGTwsn335LO/RnY
 TdoBMs3F
 xf8xpT0Zsf70myZ+BuIbV+fOwmSX+lpuS6w0gYU4aGj56cXiKnsKXn7HTW73+YmeRcXAjxLpIy4mQt+Eqc0msrgx80lToiccdgN92CViq3B6o8ZfsUSZ1w5BxAQ6cJmEdPu/rxeJj34/IBg3ldqzVkwYFJGB0jzke0StsBxBLn4OZtZyOAWnP5Zlr19oJi4IXNa1pheZTADFf7EwtIoGUucRP36JuMpKonZG42xId6NTHJeLnPpw87BTXnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

these four patches were hidden in the MM series "mm: limit pagecache folio
refcount" [1], initially as RFC, then as regular patches after review.

I'm resending them separately now to catch the networking maintainers'
attention ;)

The MM prerequisites are now in Linus' tree, on which this series is
based. It includes c6c9a4c1c9a16 ("mm: limit pagecache folio refcount when
splicing into pipes"), which adds the refcount limit checks to
try_get_page().

These remaining fixes should go through the net tree, ideally soon to
address the remaining known cases where networking can overflow the
folio refcount by taking unbounded references.

More details in [1], but in essence:

There are ways to overflow the folio refcount and cause trouble either
by letting it go negative or letting it go all the way back to 0.

This is particularly easy with large pagecache folios, where page table
mappings can "easily" create many references. The MM changes limit
references from page tables, GUP and pipes, and leave some headroom for
races, other bounded refcount users etc.

However, skbs can easily multiply folio references, so any such skb path
that can take unbounded folio references must also obey the new limits: we
must use try_get_page() to obtain an additional folio reference and handle
failures accordingly.

Patch #1 introduces skb_frag_try_ref() and skb_frags_try_ref() and uses
them when copying skb frag references. Patch #2 covers rearranging
frags. Patches #3 and #4 cover splicing pages into skbs and splicing data
from sockets into pipes.

We use existing failure paths where possible. Socket splicing returns
the bytes already spliced, or -EFAULT if no data could be spliced because
try_get_page() failed.

skb_split() is left alone: each additional reference requires another
socket-charged skb, and making skb_split() fail requires more churn.
The handling of page_pool and net_iov references is kept unchanged.

The original refcount overflow problem was reported by Anthropic; we
knew that it was possible in theory, but didn't expect to have easy ways
to trigger it. After fixing the splice issue, I used AI to identify
other unbounded folio refcount users, and it flagged various skb-related
paths. I made it actually reproduce unbounded references. These patches
address the paths that were actually reproduced.

When testing the original series, I ran tests before and after applying
the changes, using a kernel with reduced folio refcount limits. These
tests focused on exercising the new error paths and checking that the
refcount limits were respected.

These tests covered AF_PACKET, nft dup, NFQUEUE, software GSO
segmentation, TCP receive coalescing with dropped ACKs, and socket
splicing.

I also ran the following networking selftests successfully:

 - net:tls
 - net:udp_splice_checksum
 - net:udpgso.sh
 - net:msg_zerocopy.sh

If there are any further tests I can run, please let me know; help with
testing would be appreciated as well, as I only have access to limited
hardware and have limited net experience in general.

[1] https://lore.kernel.org/linux-mm/20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org/

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (4):
      net: skbuff: limit folio refcount when copying skb frag references
      net: skbuff: limit folio refcount when rearranging skb frags
      net: skbuff: limit folio refcount when splicing pages into skbs
      net: skbuff: limit folio refcount when splicing from sockets

 include/linux/skbuff_ref.h |  53 ++++++++++++++
 net/core/skbuff.c          | 169 ++++++++++++++++++++++++++++-----------------
 net/ipv4/tcp_output.c      |   8 ++-
 3 files changed, 162 insertions(+), 68 deletions(-)

---

base-commit: 63fdb511c27afcebce797e3db580b3534ddfa639

change-id: 20261117-skb_refcount_overflow-75a0034e469e

--

Cheers,

David


