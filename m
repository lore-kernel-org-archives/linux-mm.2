Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D366C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915716B0093; Thu,  6 Aug 2026 01:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F006B0095; Thu,  6 Aug 2026 01:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A4A6B0096; Thu,  6 Aug 2026 01:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD7A6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:37:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D88A2A16DB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:37:57 +0000 (UTC)
X-FDA: 85069738194.15.CA28246
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E0581C0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:37:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PR7aSNsl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785994676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2MLbXsduJEAILuzhNfI62PQO7YBQ2k1YhAQHL9snXWs=;
	b=YRpwoq5piKW9u/ZPNfaZ4BVmmJOvNJypobEtVxaQrEGk1NuhEg3ylPwsnVYHgDE40ZGvqB
	Y0gjqyugzUGp9wcv1rhl3ti1AvmI8uT2fkxBmnFAguPDtmYFdPz2+/Xsy0cK4f5kZXQqJT
	lzc4mLCKcsx7k8QPyS0xgmz5lc0EPis=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PR7aSNsl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785994676;
	b=Td6nISA7Dbpk3jWOCek53H2P5K6TdTzAtwbbhWP1xTyg6fvg6WO9D2guDCefRifuf6bAP7
	p8oN/BsKXT0RYlBH6W59ZMjVhyfadslxUO5W3DlfbrZ4ICu4zhrUHu/MB8Ojw3sAU/J235
	TKlx+vRbWUyWdQ5pxIm8HakfLZQRKkU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99F8042D6F;
	Thu,  6 Aug 2026 05:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A521F000E9;
	Thu,  6 Aug 2026 05:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994674;
	bh=2MLbXsduJEAILuzhNfI62PQO7YBQ2k1YhAQHL9snXWs=;
	h=From:Subject:Date:To:Cc;
	b=PR7aSNslmo6nqBUf9z+O67zC0AC0EWNlTATHtsZtWWKJ/kUPN/Ljv3gB6Gp1JIxsc
	 3y3UMScND3Tv4jYKfE/SNAJ4zZrSJiFqssI6yTSjn2ifWLZ8Dz5SEWFOzffVkKwkzx
	 TR1C7Eka/9EDOJfWP849T195eFiHKAWsNvwhQEU5x8Ay3MODZlXqSGLkyxTNiztwDX
	 bJJvwaY1b26Ai17wStHrLzqFkeh6/U0HcCauskihSUQQcdnsPBGsCSp8HKv9ileNQ/
	 Yg21ZdTHOMOCGCDkA+zOwt9BtAJ++MzC2Jq8RVpAUWVpzTjgEIdGkaYr42ucLlcfdf
	 OTZihc1bk3Kjw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH 6.12.y 0/2] mm/slab: fix unbounded recursion in free path
 with memalloc profiling
Date: Thu, 06 Aug 2026 05:37:40 +0000
Message-Id: <20260806-kmalloc-no-objext-for-6-12-y-v1-0-036dfc3273fc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MwQrCMAwA0F8ZOZvRBleKvyIe2jXT6GykFdkY+
 3fLju/yNqhchCtcug0K/6SK5gZ76mB8hHxnlNQMZMgZb874eod51hGzosYnL1+ctKBDS7hi5JQ
 8+4ECR2jFp/Aky9FfwfWW+hVu+/4HRIqj+nYAAAA=
X-Change-ID: 20260804-kmalloc-no-objext-for-6-12-y-bedd8e852aeb
To: Suren Baghdasaryan <surenb@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Kees Cook <kees@kernel.org>, Danielle Costantino <dcostantino@meta.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
 Hao Li <hao.li@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 "Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: t5muj1e1abqh8iceh4gz78yjohg9oyro
X-Rspamd-Queue-Id: 3E0581C0007
X-HE-Tag: 1785994676-349749
X-HE-Meta: U2FsdGVkX1+E2KwuWhWIMoHuDxY2DfVbTM1GinlWWY/cLDRYXibaBZg0mgmF3JpKxDsbtUMUFD+fRZp1vgepPc9oSumdJpgttRcLN0U19aE9oQ2qQd8/fPR5nr8tqvRFCFtHBjN4Scpj/emKV45lcRvu/T4pFrdP+4zMMk9+sWiB3Yv0STcIi9MkmGRvul/vvnVe3xOzS/RAOtsB0q1SBwmP37VPXwiTBg8BXKlZpyQ85xErORxADKMAj2g/dOj2hIKny79kpJKRxCvu4H24Ue44yjIakNFyacSvdiWZ+h8Q5OGJh2vow6pYJYerxOZqy3pmDeEjz63X9QYbatFoSpnbc+XqPpgDrdq5aUdFo1BAZlohqfDIQJ3cHyp8Z6tpzqsxX5PNdZW8ng1lSogPLpcNGFGcV/5X5/86vTjSl2PN8Nm9L1BbZpB84b08J55iklOfxZRMUyeNcV77cssan9CdT8n3zZ3MOGSPoqpA1AzGDs6ff9gyj3GRe7A3AQP7Xejqd+Eelw6pZ+9mXNUam2Qz3f8Mhe2U1zMOAfy770h9RiCnWm2gcl00YReXkAz0ZewwBsfWHWuHGPMGqXiodF/YNYv1UDdo0Sia7EESYJTcklbYMaqDkN45lURDP2SJWEFrLxC22CBPzAscSIjRHNxAST/GJOqnCA2lKyhuCeqz9eMkY/fokybxBT989Nt2mH2bHrTmM9923xCLY2sJ0SSPnW83v67eKniFGezpRLKwMllKx09hT1m7z9ykPhyoXxkLpVjfRD3Hvphyf5GQVwgHWqCi8HvjlLSbNFUoHMdaFibK33940oArlBMfHD04xZJHC52m/5tOaHIvQxjr9+n9H89LzQIVJOcp2XTk1cv0EOuzlLnzFsOWaMgwtyqGOJPe31wKUXnjKo597X6VlyefyVpkVG/2C8owNsdCyhDMGqZsFiKwJnb6UHItRpHLk0kO5uADUzpHYIMT8RX
 La7nzgn5
 J8hHgkvURHXqjJ+hzWPYOHgPlHpkOdCBnfQvGs5E8xiJI4VPS1hXB5vpAA8xzyB3vNDSR3TN43LPwfB685BZhAJcv6sSNAbnt9DeRwBVvm1CizslK4o7ZBrK2vnKpssa/eW/W/AN2dECvwefRfvEEzJVu79iuL8mjeWxKTTSC8wVRkLJ47P26tL1QNDq4tUVFGaJlb2qcp8ETuYRLLYERTEY6CssWHpcKbt2ARY9xLL9ydq3MsfWk/DUBc1yE59YnQUU4W42rtJvehDIWvsvPbV3PquKaY3vkak1tTnfrBf+Jy4+7jJr0gogBQx2GUDMiVDzLbE85aeRQ+gFENI1RBRelxoJeZc51Dm3TzCYSxUoAU/wJIdRi7eUANVDVuLP3MYykUV9cmuS9pkyBapGakoT7KMS0xrLJkCJ+wLOMLaUmLw1whaGeRVRoPYJxUwAJAmp+xCgAPnwYAHKqZCQDYOA3YrYDvORwiceBZaayeTkjv0bG+kZBgqqode2+073gthpnsE9NZ4wxGv0eC++yHk9kY0fD5CUnc4TILZygIcnkiFFj5qUxDQdN1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is backport of "mm/slab: fix unbounded recursion in free path with
memalloc profiling" series [1] for 6.12.y.

The patch 1 was adjusted for 6.12 as mem_profiling_support is marked
__init in 6.12. I simply resolved this by marking
mem_alloc_profiling_permanently_disabled() __init since in 6.12 we need
it only when creating kmalloc-no-objext-* caches during the boot
process.

Patch 2 has slight functional differences compared to mainline
due to lack of SLAB_ALLOC_* flags, sheaves, and kmalloc_nolock().
I described those subtlties in the backporting notes in detail.

The first two patches from the original patchset [1] are not backported
to 6.12.y as they are no-op in 6.12.y:

 - mm/slab: fix a memory leak due to bootstrapping sheaves twice
 - mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT

[1] https://lore.kernel.org/all/20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org

To: Suren Baghdasaryan <surenb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
To: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Hao Ge <hao.ge@linux.dev>
To: Hao Li <hao.li@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>,
To: "Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Signed-off-by: Harry Yoo <harry@kernel.org>
---
Harry Yoo (Oracle) (2):
      lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
      mm/slab: prevent unbounded recursion in free path with new kmalloc type

 include/linux/alloc_tag.h |  3 +++
 include/linux/slab.h      |  8 +++++++-
 lib/alloc_tag.c           |  9 +++++++++
 mm/slab.h                 | 28 ++++++++++++++++++++++++++--
 mm/slab_common.c          | 13 +++++++++++++
 mm/slub.c                 | 34 +++++++++++++++++++++++-----------
 6 files changed, 81 insertions(+), 14 deletions(-)
---
base-commit: 833291ee77846538926c990bcb468f6f54e9af50
change-id: 20260804-kmalloc-no-objext-for-6-12-y-bedd8e852aeb

Best regards,
-- 
Cheers,
Harry / Hyeonggon


