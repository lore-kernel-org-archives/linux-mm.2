Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F20EC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 19:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5836B007B; Wed, 30 Jul 2025 15:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DDB6B0088; Wed, 30 Jul 2025 15:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCABA6B0089; Wed, 30 Jul 2025 15:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABDAF6B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:19:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0703DB9E60
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:19:35 +0000 (UTC)
X-FDA: 83721895110.23.5C08739
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id C52311C000F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:19:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=S6px7Vmo;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=9Rruzgnb
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753903173; a=rsa-sha256;
	cv=none;
	b=u18/ji+o850u2Tdx+0vArOEG07Qj40rjZ8Y2yrOheRmu5Qvknulgt7kqFaT74lyy0Cq+KR
	ldaBfq6g1uZenk7uKglmpKrUf++3KgFTdZg9Uz/yMNcv/aleC8RfRhIznryqZrE2Wy6kVr
	wb2CW1ES26uAVe997y/78CHb7/3eWjA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=S6px7Vmo;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=9Rruzgnb;
	spf=none (imf18.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753903173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QmEEM2pn7Tus3BjInJV0eWX/l4iVKVBIqgB63o1NBvg=;
	b=lk7NLbzKgnzzFTEzd0gY7zzFb1NobGDU3etAE7eoYcvJFnZEnmBk2fOiIMHGJsQ75gZsiT
	0UGxZreWevtlVp9frpsx6UwydzqHU6rFCPU6hG/agRHnPERDQWWtOBaRAOplMxHIb1q29K
	OLXFG0hIh0QML/aG5/7y5OoLN8VizXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753903170; x=1754507970;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=QmEEM2pn7Tus3BjInJV0eWX/l4iVKVBIqgB63o1NBvg=;
	b=S6px7Vmo1VB8ZlA7+0wJXegbsPHY+z4XjjHyKTMbPRjXtLETGlaMl/mQ6C0xVVFvqcuuKWTRlnND/
	 30e7qqyYxtMS4O4ZeF0xbpIDPMp+rpcfb1wRycvzTpPI9p1TtJvCp4wK69fddukMhk9maAFOJ63YkK
	 cQm9qvsMm4mJPBHO43wX3hhl+rb0XJI76vDFIptpnad4T5O2alVi49jc1PF+qN19/tSVO6EadaElBK
	 48SKqlA0aKZwMP5+reLBJeAIOL1hYCGkkxUsgpnZWW0AfVMUJotfC2dbMo7OkVHFIMnZDaANqcK1hM
	 hkgzMY2/2H1J5uSu4cL7P5tTirjTOrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753903170; x=1754507970;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=QmEEM2pn7Tus3BjInJV0eWX/l4iVKVBIqgB63o1NBvg=;
	b=9RruzgnbAMugNfJmZEDTAoSVd5s12KCa3JKJ6AJiUKzoFR2TUrGXIM3x3cKEBHcJoy8l/dXCpFDLV
	 jTnVBjuAA==
X-HalOne-ID: 1c955182-6d7a-11f0-aff3-632fe8569f3f
Received: from slottsdator.home (host-90-238-19-233.mobileonline.telia.com [90.238.19.233])
	by mailrelay2.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 1c955182-6d7a-11f0-aff3-632fe8569f3f;
	Wed, 30 Jul 2025 19:19:30 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	rust-for-linux@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	bpf@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v14 0/4] support large align and nid in Rust allocators
Date: Wed, 30 Jul 2025 21:19:21 +0200
Message-Id: <20250730191921.352591-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C52311C000F
X-Stat-Signature: 9kucqyesfwii8fwr6e3h39zry9yfnmj1
X-HE-Tag: 1753903172-663103
X-HE-Meta: U2FsdGVkX19tiY8ZVfRAUaNmNS6VA8+LW3jm7Yy52eQL6jhrt2SX8y5dZdZrOi4onrvEjMutHtoFRN47M3iOKrLhS0qHEh312vShslTMktw95FXewgYYLC+Jx0O4mnxHEYfU5FQ/kc6bAJ0U+E524jK9ZGNCwfcoMGjSvlpqmdGfn9Zcy5iO/g4dqn3ltWAnlowcsXJZXvk3yy+PoKw7I4iXOrKwzEivw2MBhoh+10XcCXn2c4mA20xOitu0vovrVHG+gPy6aqzEM3yjpHQCeKE1gGtL/EBcZk0RTOClPwe7zdnxHJn8g990lMUW4SUYodVVKJk+ov9n5P1xOdBqUzM4x+wqZJ0Sih3hoc6J2hzETRwy0IKoo9UFHiyPeNTZ6+oclfTcVSvuGyMK8KMNs6eQHzmYWckIQstLKs3IKnqUPizNajHW40kgHxVCYnQu673uifLrcvk0cZ3ha4ZWEhIzh+drYavX971H786jwNttmPWpdIKH5ePu6fwfJ0yT3Y+jzFmXCzEPEVA5sSxEVcj1DANG0UbgnJ/Q9nSU4aE+eEpx7aNI9QwtjO9YjIG/I2MR09tk/c8JBu9nNACfOoJ/KFEqI3bD9t1bzaA59msb6Ilj7ziB8NpntKilyaN03RGGMVynow9V9b2VgYgbqPRXHy7Ribhl+DxyyFQeUdwWrxGEqQm6qh8fz8AK7pR/U9+VydIKfWz/Qgsmv3FeI+mCJxDqxzSNed1HeiUc0KrxEL5FMnzgCjRx+YqpiY+T2ZcWso6XI20Vf1mnrWiu6+82LZ1N3SC2GfTaXCiXwFdWrLHgA8x61r7if7zCBFFqhBOTHZ/574gVoMDW4/QKnHZ272HFHdWP1zzu26pGjWOW9tJ0AK78pMjdSkLcEkKHf/8KSHCr+CqvEJjmqLn3+kG1Cw0Cj8lcd55awa5YiiW0n4eRKbzkGkI4wU7ZAnkUb8otXWd6HWPEig9nJDQ
 SzQPgqXh
 UrfJKEmy40w3kU2ulV8Tehv5QEMml5qHdMgxc/DBzxUkjkKdnG2UbcQLLWW+C1tirXkydny8Vu5pCd9ctLUnDUrEzh6e9Q+oCWk6a1wy4pyuaoAlMgky+g3G8lee8SWon1FRrxonXjY2MCEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The coming patches provide the ability for Rust allocators to set
NUMA node and large alignment.

Changelog:
v2 -> v3:
* fixed the build breakage for non-MMU configs
v3 -> v4:
* added NUMA node support for k[v]realloc (patch #2)
* removed extra logic in Rust helpers
* patch for Rust allocators split into 2 (align: patch #3 and
  NUMA ids: patch #4)
v4 -> v5:
* reworked NUMA node support for k[v]realloc for all 3 <alloc>_node
  functions to have the same signature
* all 3 <alloc>_node slab/vmalloc functions now support alignment
  specification
* Rust helpers are extended with new functions, the old ones are left
  intact
* Rust support for NUMA nodes comes first now (as patch #3)
v5 -> v6:
* added <alloc>_node_align functions to keep the existing interfaces
  intact
* clearer separation for Rust support of MUNA ids and large alignments
v6 -> v7:
* NUMA identifier as a new Rust type (NumaNode)
* better documentation for changed and new functions and constants
v7 -> v8:
* removed NumaError
* small cleanups per reviewers' comments
v8 -> v9:
* realloc functions can now reallocate memory for a different NUMA
  node
* better comments/explanations in the Rust part
v9 -> v10:
* refined behavior when memory is being reallocated for a different
  NUMA node, comments added
* cleanups in the Rust part, rustfmt ran
* typos corrected
v10 -> v11:
* added documentation for the NO_NODE constant
* added node parameter to Allocator's alloc/realloc instead of adding
  separate alloc_node resp. realloc_node functions, modified users of
  alloc/realloc in accordance with that
v11 -> v12:
* some redundant _noprof functions removed in patch 2/4
* c'n'p error fixed in patch 2/4 (vmalloc_to_page -> virt_to_page)
* some typo corrections and documentation updates, primarily in patch
  3/4
v12 -> v13:
* fixed wording in comments (patches 1, 3)
* fixed bigger alignment handling in krealloc (patch 2)
* removed pr_warn import (patch 4)
v13 -> v14:
* addressed Vlastimil's comments for the slub allocator's alignment
  handling
* added cnages to allocator_test.rs to match the new API
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
--
 fs/bcachefs/darray.c                |    2 -
 fs/bcachefs/util.h                  |    2 -
 include/linux/bpfptr.h              |    2 -
 include/linux/slab.h                |   39 +++++++++++++++++++++++--------------
 include/linux/vmalloc.h             |   12 ++++++++---
 lib/rhashtable.c                    |    4 +--
 mm/nommu.c                          |    3 +-
 mm/slub.c                           |   59 +++++++++++++++++++++++++++++++++++++++++++--------------
 mm/vmalloc.c                        |   29 +++++++++++++++++++++++-----
 rust/helpers/slab.c                 |   10 +++++----
 rust/helpers/vmalloc.c              |    5 ++--
 rust/kernel/alloc.rs                |   54 +++++++++++++++++++++++++++++++++++++++++++++++-----
 rust/kernel/alloc/allocator.rs      |   49 ++++++++++++++++++++++-------------------------
 rust/kernel/alloc/allocator_test.rs |    1 
 rust/kernel/alloc/kbox.rs           |    4 +--
 rust/kernel/alloc/kvec.rs           |   11 ++++++++--
 16 files changed, 202 insertions(+), 84 deletions(-)


