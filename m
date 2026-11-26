Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD58606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eFshtLzJ
Received: by kanga.kvack.org (Postfix)
	id 8FF716B05B2; Thu, 26 Nov 2026 16:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B01E6B05B3; Thu, 26 Nov 2026 16:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E3C6B05B5; Thu, 26 Nov 2026 16:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3B6C6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:18:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B8861A0123
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:18:55 +0000 (UTC)
X-FDA: 85478535030.26.3D5B958
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9C83C0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:18:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFshtLzJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727933;
	b=hna0cF63Hx3W4Hk4vnrH95+n1aqSndz0a+ZciWePIc7uyG8gE4HXOM2prL2jKBECbt9M0Z
	Yh4+D6qEV3/oMb0NQI+62Zj0LcyDj93G4SyLM04IvwotOUGeWrJfPwbzfSEaWYcE3/88g+
	68wZPyKmb98I6cs+a1QRgRbSq2u98Ts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w4CqDwg7D7154OuRysg7R/98YqHxmOgh6GHFXhtckiw=;
	b=UsZERd39h7CNj+MbjJjNMLElC/fBFerWFrW4ySLgfTTQMR3InYxHNN6MiLoBDtc5N6Hdq3
	QMAW6hRO/0FxqRx5YnxVCjtvvEbQ0w+xYjEKSWvm8fzOjC8jlJAdq2/D55CliHX9peBc29
	FyOoSu5rhNdLb5YlYeyS6u/MxONw1Ok=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFshtLzJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E0A460CBA;
	Thu, 26 Nov 2026 21:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08E21F000C1;
	Thu, 26 Nov 2026 21:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727932;
	bh=w4CqDwg7D7154OuRysg7R/98YqHxmOgh6GHFXhtckiw=;
	h=From:Subject:Date:To:Cc;
	b=eFshtLzJ/qZhIuDavJGMHhx0awqSSLOmqIK+rtEp3hFJGJsXGZp89mYuJ0A2oflwe
	 WPjABWLlBns1I6Gpe1W3XZGnCdq7jSWTGPUQyeOkVmmQRQy8IgxiawOkCmrG/1zgEO
	 eESU6WCiodorlDqXUIXFTOcA6BJ2tDqcXtW2yLhywgq0ZojA041FHtBYK2MknIb8MU
	 oJv4WcqlaWM1MpPY7fKv9kixGfxkcsNBzxM2tkOx+8ZvKYFk6ctt6Ocxu7uwKKFUZL
	 /UZgbnXSlWo4Nq25r/q2s7Gpew/DaW+ywHX7yhxv4/yrC2G+0LK2yGIXRSzA8sisTU
	 xuxNQUPxv3ikw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH net v2 0/4] net: skbuff: limit pagecache folio refcount
Date: Thu, 26 Nov 2026 22:18:36 +0100
Message-Id: <20261126-skb_refcount_overflow-v2-0-a6f600a5634a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/3WN0Q6CIBRAf4XdZ2mgoulT/9GcU7oo6aABUs357
 03rtdezs3NW8Og0eqjJCg6j9toaqEmaEJBjZwak+gY1gZSlBee8pH7qW4dK2sWE1kZ0arZPWoq
 OsSzHvKgQEgIPh0q/ju4VDAZovtAv/R1l2Iu7NmofrHsf98gP+Tc6/xlFThkVQvA+r0QuM3WZ0
 BmcT9YN0Gzb9gEfcs4u0gAAAA==
X-Change-ID: 20261117-skb_refcount_overflow-75a0034e469e
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Stanislav Fomichev <sdf.kernel@gmail.com>, 
 Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Rik van Riel <riel@surriel.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5224; i=david@kernel.org;
 h=from:subject:message-id; bh=3E6okuV7gkYorzSuAVGWdCzZhWj30E+ec9fUig6K0PM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI5Fhn38llMXxfVz2q0s2jN+791KUdTQ3Se/9a7Xb/G8
 ay09bv8jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACayTZCRYdfdXwv3Kr03PpUl
 v3XP76BOnjcqivlTt/s51jGtWzF3pxcjw3Kz/hluE1tXX7M+LxFt8GxbePipKOMJnzqUJmV9XX5
 3HwsA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9C83C0003
X-Stat-Signature: ekh6yisut3wfauqkisbrsmtwp6fth8cy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795727933-304130
X-HE-Meta: U2FsdGVkX1/OcSo08ffSUgd3sJL150ATBUN/F2qLhD6cW02rtzTCh4DR7Imu5/bwI7K9PzuSHCSaTkaDoqf2g7P3taf2uxUnT9kyZjAfy7wTAmVxaMAjEnsTzms5lQhCYm8QaKYPC7Q8Oen9w8LDtH1UY8xQR1XT3c+9dLx92K2lW80bPGqRacv+rpQCSxtXBjeatZX063h9FuatTFSJf6r5Ml/H1FnQo+JwiT1tuc3iSkf0xJZSbjtowWXC/J2Bwv2Jrhf+OE62qsKutLC4ICtblRUlNpMISqbx7Zcd0mhlHx4hWQN4a4GKpw44OGnjdMsg4psslFRVfGHMxZWBDDjpVuud8etDL4FgFkr6ljh3Ycl7CqK5Ucee8z9cuaHZGtj/Fi2TvoQm/UE3KsoIDNDZzYKVgf/HpH7YdDoljkuO4P6xBuYB7YzpghN5pO7BJmAV92fbRdHxBvNzMbLpBsfVhYnB4EAjSGrqO/nFMR3zggKzXQz+O+qwWcEv6mjXg4G9zaX3QHRrOqKzwBSLLhP84yUlDsxur0wW6SWqXCeUIefLDIfY2rzD0R7/26DLDiuftct1/BmZSGyOI/CH13k+QUiXR8uP+dkS+6PJ13yfatVRuVahqBINcdAXAPh09UE/dKl2DEmUaziD3yzrXFiAyr2Gda69JuBJeG9UUSFDik81l0iJd7khKJCsLk6gbIwMdXwxIFAqquJ6Cu3VFsZOwPkpyx7Zl/egsTB2PuNtJfTH2vdXKJ8Aw0SbQA3jC30n8NKM47cNIG1JKUmy3IKAC5bOl78OEew8ac57xINvQOMT1Sssctqw4YQna5FIvck5x16qBIDPfFHJOIA9hRZleWg4yF+O+9hbEqvwG15ccjaFZ+rNn7JWbnjHKkozEoORmoWE/mZbk2jmGhzT79CDIbmbqeNi/xcNrtLGi9LdRb0xFdbuc68yrb8NnmpsKHfVnUFSGgXHrqmxFuB
 HhuTBq2k
 AGu8AgwNccTGzVZx6ODmUP0UeVEc73Qxa9t6BSZ3z6OvdKubnZnIVf0/8QalW25B5/ilPYwIcT3Gv1rPRv1UDfcMucMIZjeNNLqf8RNKPW6CBUayF4NuC0zbr2y56yQtOF9Vt5/Q/SG6JLpZ++4FwXDuJGxZmNwMxia3Zpr/3XVo5TLLF5rC+GD460TH+pCnEjFnVteSXmjaiT2/MCOF8ghoUWbsnHKG0OqpBf9YW8vAXr9TVkxBxw6/dwlQJ5BN41LtryrNdhTQlBnQ7Kw3KrJCBOgc7TOyosKPRUYnYKBIW3nV4FaPkJGSDdHoQzte9pFgl1iULSmh/GnJx35ukdrOmo5rA+EKjerhl6aD0ULMu8/ztKYM5trigUiA8p+GbDFKd+FQRwczTgjJl0KWBUM9mPgOSwYPnOwMMf00wPisl/HsEQR49mZXxT79HSoo7mBelAuq5khTQpcZ3t8HiRA9ygC8kdbWNYEP2RHQ3Pv1N5UcD/Pt11mlGJy59mQz+Oo0W+9LPh/cjpKhHSD/Feet3eMdJ+72YwAtrqNAfAvm3Puq1WIkP48UzqIO1+nP+mpd6sXPBSYqsyBnMUC6FIK2xHBf/UWlvEc5HgfleJihtY4pAJ+FrzZ9ijg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This is v2 of the remaining folio refcount overflow fixes that should go
through the net tree, ideally soon. They address the known cases where
networking can still overflow the folio refcount by taking unbounded
references.

The series is based on Linus' tree, which includes the MM prerequisite
c6c9a4c1c9a16 ("mm: limit pagecache folio refcount when splicing into
pipes") that adds the refcount limit checks to try_get_page().

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

Net paths that take folio references that I don't touch because the
references are either bounded or the paths are not relevant in practice:

 - skb_split(): each reference needs a new socket-charged skb.
 - IP-TFS reassembly: each reference needs a new inner skb.
 - io_uring zerocopy send: each piece is charged >= 4 KiB of TCP memory.
 - kTLS software splicing: only transfers references from the pipe.
 - kTLS device offload: pushing the record fails in skb_append_pagefrags()
   (patch #3), so a socket can exceed the limit by about one record.
 - AF_XDP zerocopy TX, nfsd splice reads, sockmap / sk_msg, espintcp:
   bounded, or require privileges / special setups.
 - Other driver-specific paths: not looked into for now, as I can neither
   test them nor see if they actually trigger unbounded references.
 - page_pool and net_iov frags: not pagecache pages.

The original refcount overflow problem was reported by Anthropic; we
knew that it was possible in theory, but didn't expect to have easy ways
to trigger it. After fixing the splice issue, I used AI to identify
other unbounded folio refcount users, and it flagged various skb-related
paths. I made it actually reproduce unbounded references. These patches
address the paths that were actually reproduced.

I ran tests before and after applying the changes, using a kernel with
reduced folio refcount limits. These tests focused on exercising the new
error paths and checking that the refcount limits were respected.

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
Changes in v2:
- "net: skbuff: limit folio refcount when copying skb frag references"
  - Fix skb_zerocopy() kernel-doc indentation
- "net: skbuff: limit folio refcount when splicing pages into skbs"
  - Mention nfsd connection teardown in the description
- "net: skbuff: limit folio refcount when splicing from sockets"
  - Propagate the error through an "err" pointer
  - Document the skb_splice_bits() return value
  - Update the description accordingly
  - Drop Pedro's Ack
- Extend the cover letter
- The GVE issue sashiko reported has already been fixed in commit
  3946899dbeac ("gve: fix RX page refcount overflow from INT_MAX
  pagecnt_bias").
- Link to v1: https://patch.msgid.link/20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org

---
David Hildenbrand (Arm) (4):
      net: skbuff: limit folio refcount when copying skb frag references
      net: skbuff: limit folio refcount when rearranging skb frags
      net: skbuff: limit folio refcount when splicing pages into skbs
      net: skbuff: limit folio refcount when splicing from sockets

 include/linux/skbuff_ref.h |  53 ++++++++++++++++++++
 net/core/skbuff.c          | 117 +++++++++++++++++++++++++++++----------------
 net/ipv4/tcp_output.c      |   8 ++--
 3 files changed, 134 insertions(+), 44 deletions(-)
---
base-commit: 63fdb511c27afcebce797e3db580b3534ddfa639
change-id: 20261117-skb_refcount_overflow-75a0034e469e

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


