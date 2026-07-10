Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6983FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BA56B0099; Fri, 10 Jul 2026 02:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CD86B009B; Fri, 10 Jul 2026 02:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553EC6B009D; Fri, 10 Jul 2026 02:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3573D6B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:04:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD3C81C88F4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:03:59 +0000 (UTC)
X-FDA: 84971826198.02.08239D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 661E840005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:03:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lk39EIrc;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ULBMQmnv8LLLVlD5lvSVdvDm5rfD5U8h0VCK9hrKVpw=;
	b=AnPYIA5YCzwJR8HzPxrgRxGqAAbMeB3PClriH501S2Pe1nbB1E0P+05lkgs6203GVFpOgB
	+zCcA/fAZWieFFohv4Ibg4M87liF3IwbugGqJTvKAmUkpBki05hNuoBpQzlgiXe0hwPqEb
	NDdLZXVsE+eCAQEMxVoCp8pyAYdv58s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lk39EIrc;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663437;
	b=VKBDUGqPjWLaOMQRcMnTCliuvnqELmoXfCEiNsk6pOXc5MlMJo8fc50rSeFgzcERUoOyAl
	RSEoOCAF0pP87IsoTvS7gwdHomzxuT4wV5/7S/n11EhRN38V52l285ejL5RA9SfAHZE5KH
	m0lUIYW8DQIR9EjF+2LEdW++fFa5R94=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DD6340AA6;
	Fri, 10 Jul 2026 06:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084881F000E9;
	Fri, 10 Jul 2026 06:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783663436;
	bh=ULBMQmnv8LLLVlD5lvSVdvDm5rfD5U8h0VCK9hrKVpw=;
	h=From:Subject:Date:To:Cc;
	b=lk39EIrc1OLJ45PR4qGIue0wtirqeIp1tg9bOwnuuSR3Y7aiIkoBul9vNk6v+ZvzT
	 v530bKhAE+F+V1wC83Qdgcri53Ee8ZpaevpMbtx9OMGYhMucdH55s5hmGgJN3BCi4p
	 gtrImcaiDC3FfsH6Cxd2bEHf5APXZqTML+Uzg+CSBre+ROQCAJm8crl9SiXdIlk+a4
	 S4i8pHUVhN8mIx7CGtgZM7EVUQxYCD0rpdr0rAtsiOr0aioNTnakV/fXc151izR4ec
	 mdnLM6dfbHte2gsRjqZembbvY2axhKMBOlIPg9M8bmSzEYyb0okNAa8IDecsrBZath
	 WkvinjFjZu3lQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH slab/for-next-fixes v2 0/3] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
Date: Fri, 10 Jul 2026 15:03:31 +0900
Message-Id: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NwQ6CMBBEf4Xs2dVtCQU9+R+GA+ACldqalhAM6
 b9b8e7xTd7MbBDYaw5wyTbwvOignU0gDxl0Y2MHRn1PDJKkopIkTs/GGNehdejaB68zSiXOnWB
 SVOWQei/PvV73zRsE07Sn3nm0X/WX10kadZidf++/i9jVPxeLQEKhSlEWRFWRV9eJvWVzdH6AO
 sb4AVmp2ObIAAAA
X-Change-ID: 20260702-kmalloc-no-objext-2619c1e06083
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Danielle Constantino <dcostantino@meta.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 661E840005
X-Stat-Signature: fyfqzin67rmuycr7snfxxsqrdhueed3d
X-HE-Tag: 1783663437-187486
X-HE-Meta: U2FsdGVkX18sy81/tdW3nx1Ow3bRI/vQWUFqI3LhR5JygLb3AWWqlQSpc9fYA0jwr8qQYRJzJnQjANjwHvW9lxR/byNgn7f42oIG+HVdIAM+j+PrD3eKDaMLsf1Ylxa8+TRFNp7Gg4I8WgEL1Ui88fFkUTzi2taFbjvX5Cgox0pNBNo67SJeuMgcWWt83WbDVEPoc93DAZ+fbDu6EMASMz+AlGW2duWeVNDJxBKVeS7CxQFxlfjgxtKr8koUIdNrhUj7qmYXOEKoLaNkL2fR51ABCMMpAN5QJG03fqzdAk+91sJWooD+Ui/KZAmNYWFKowDHnJh4faJBYqPKhT5wrdPsrkhJBfoaTdmvZb/B+91bv8QwqopetKoIxE4g4d765KDYhXtPcfwkEvToKyj2jGA0fmEm7zoKN5UKxXIC274rs/KNff0Zh5l6CPnRK8Zks4UI1WuXM60bAjG8ecsU1RODUeqkQvyhztD27sKylNBUOaNrxucEUw/zCRsvP537uP4co3b0WLQtxj2Z3o/EoAfiHhiMhJ365jrDPTGYk8YkXQX1iQi8cb6g4x7AusZjkqWMA23ytFOf1F7bnJ86uWyrB+sCgmO4GFcNhgJvAtP6XdBzk3V01PGDub8uUhQBKWO77YdCsXW/L2KeoKyBcc8nv+2KQqu5FXuYjhXriEzMjNhcdYuIhPco8u6AEW2vSYKlt2IrUfmEdQF/oiY8CUcsaMCG7BNB6+wjYso59+r7Ys4CXMdYJESEJCPhpRy7ccqkfosSuOfAYmhbWyV8bQeWmFg08IqmhMce5IBHBhwTvB3Cl+lwDgWfuLujd84/PwF6B3mckhEhNv7SF/Jz7F8gKSpM26YMOLwb1ieefeKODPSHIFbMyx6LIyno7d8RStBBSeAk0yWNqav7rIIv2LTl6aIcRqhD7Rg1zvvjHxKAhs2LPhZp/3vofnZQerSuDlAEpMYhzmwjFWqQPa3
 IBrvCjRI
 uM7SSTLyYKrcQvL/LCv9tNDqdFeeZZ80icPffnEtsN9MX6gx3z5D4QEDPXlSjwKryq/WBcChwvE+KGj0Wp/YvVgp2v80F4pFQKzzcQcuwbe5ULDRj+WGqo5ceXvxsMwdQG9eSyo2JmJhXE1VwyAMqne9/brgQJMOIrUBOa+Xau7VJ/zKJMb6updX0A2rN8xZstwMHWA4DqEF8HprzytLi9vwlcqQDFplTk+jgaax/uPXDwSDpkqOHjMGorYeuYCOwO6U1LdTJCpRk9kyyp/gooeUe0sxR9WEHkJQfKTxoxCsJeuE8gFOCI9h7pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a follow-up fix after the recent discussion [1].
See patch 2 for the detailed description on the bug.

Based on slab/for-next-fixes (72bb229f916) and will be soon available
at git.kernel.org [2].

Instead preventing cycles by bumping up the allocation size of obj_exts
arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
disallow formation of cycles between kmalloc types when allocating
obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
obj_exts arrays are served from normal kmalloc caches.

I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
sheaves for those caches. So I introduced a new slab alloc flag
SLAB_ALLOC_NO_OBJ_EXT.

To avoid huge confusion, I had to decouple "disallowing sheaves"
semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.

While this cannot be directly backported to v6.18 and v6.12 due to lack
of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
particularily challenging to backport it. Instead of a new slab alloc
flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
kmalloc caches don't have sheaves in v6.18 anyway.

[1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org

[2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kmalloc-no-objext-v2r2

[ "v2r2" because after exposing v2r1 I adjusted some of Vlastimil's
  feedback and fixed a memory leak due to bootstrapping twice when
  kmalloc caches are aliased ]

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
Changes in v2:
- Fix a memory leak when kmalloc caches are aliased (patch 1).
  This is included as part of this series as patch 3 makes it
  easier to trigger the leak.

- Fix a warning in MEM_ALLOC_PROFILING_DEBUG by dropping
  mark_obj_codetag_empty() for obj_exts. Sashiko raised this and
  I reproduced it and confirmed that the warnings are gone.
  https://sashiko.dev/#/patchset/20260702-kmalloc-no-objext-v1-0-167175008538%40kernel.org

- Added R-b from Vlastimil on patch 2, thanks!
- Adjusted Vlastimil's feedback on RFC v1
- Link to v1: https://lore.kernel.org/r/20260702-kmalloc-no-objext-v1-0-167175008538@kernel.org

---
Harry Yoo (Oracle) (3):
      mm/slab: fix a memory leak due to bootstrapping sheaves twice
      mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
      mm/slab: prevent unbounded recursion in free path with new kmalloc type

 include/linux/slab.h |  16 +++++++-
 mm/slab.h            |  15 +++++--
 mm/slab_common.c     |  18 ++++++++-
 mm/slub.c            | 109 +++++++++++++++++++++------------------------------
 4 files changed, 88 insertions(+), 70 deletions(-)
---
base-commit: 72bb229f9161a1efcd5df32141b69fcc6ae81a13
change-id: 20260702-kmalloc-no-objext-2619c1e06083

Best regards,
-- 
Harry Yoo (Oracle) <harry@kernel.org>


