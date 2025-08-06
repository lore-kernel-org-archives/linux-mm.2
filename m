Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E114C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FE18E0005; Wed,  6 Aug 2025 08:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFD68E0002; Wed,  6 Aug 2025 08:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF268E0005; Wed,  6 Aug 2025 08:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBD908E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:40:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B73D160538
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:40:44 +0000 (UTC)
X-FDA: 83746291608.11.E14D83B
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D70C40007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:40:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=pQ8Xqu4v;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=i5l+IAAh
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6NZAtsRQPRLEOnALjiUrPTbK1Ko1TPX/qvuOItNudmY=;
	b=MTrWjEqxTkBgM6X9FcB8Dx9cus/fXV5wj4GShiAqZDldAu9IXd1bw2MAVIz26JD2EtosGA
	+gLX7TkrCX41h2YQX+t3EXTxlqsQtGJCdhZR6s8sE9IfLYHnQmJeaiUxMx0LSFzxFP+5lV
	r9Rqii2Zy/AJRKJVA4jFpJy/07hPqSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484043; a=rsa-sha256;
	cv=none;
	b=OfeqxmqiudRxCVSgDoBhNkHcvFv7VG7oLBTQ1XOXtwGIfAsnsh9aQv4PlytplZlx0kyPlG
	fJKvXqtQ8/hBCXGQd7lpaJ40GDkVeDg1PdO0GyAffSxzYA5cFfXdjsyBxBpCjehBmQ6ibV
	ikvZziMJatwHZg3OKOgCr4YMCYlSsUA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=pQ8Xqu4v;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=i5l+IAAh;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1754484040; x=1755088840;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=6NZAtsRQPRLEOnALjiUrPTbK1Ko1TPX/qvuOItNudmY=;
	b=pQ8Xqu4vQVoFuzRNfkx8tDpO9pXYsqUSAgtU/nEVx76yuwztxDEQDHPe7PTlK3eczmunaTtBIgpb2
	 pnRpl2zV8im/earTDa/GqC0MFxxTPCWVKCJMWjhquroMMjyVWq7KRFmkHc2YdAce3WQbHnnnBHNnYG
	 Nx8LNmBp36TG7IMkzvfiPeL+6Bmaw0ql+FvaGgxQ2ajlNDeR5NYLuE1/2k2KkJA717U0yExEP9D3j3
	 9PPtJX67h2Tx9r1TZyh6A7pcU6/qmqauLjoKt23Lw3pimQfEwyr0uchl4Gjd2+LdWKsBURXlduGEmJ
	 mpA6bgGdm3WIBXQQuuI0G9YKpU3tdRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1754484040; x=1755088840;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=6NZAtsRQPRLEOnALjiUrPTbK1Ko1TPX/qvuOItNudmY=;
	b=i5l+IAAhCBevKEaEodC3AD/f5I2d0OS/oDuz/impr33Mg4QpfgQxw4yjoWNf7OQ+owvdOld3NLwVb
	 QBDDwOLCw==
X-HalOne-ID: 8e99376d-72c2-11f0-ab00-85eb291bc831
Received: from localhost.localdomain (c188-150-224-8.bredband.tele2.se [188.150.224.8])
	by mailrelay5.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 8e99376d-72c2-11f0-ab00-85eb291bc831;
	Wed, 06 Aug 2025 12:40:39 +0000 (UTC)
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
Subject: [PATCH v15 0/4] support large align and nid in Rust allocators
Date: Wed,  6 Aug 2025 14:40:34 +0200
Message-Id: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mok7br1xx4cmszfcke1oxg99uc4m9osn
X-Rspamd-Queue-Id: 6D70C40007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754484042-298090
X-HE-Meta: U2FsdGVkX1/VdkDKqlMR3CnzGs4n2Wz22qGAEZOdFQdP02PB8U6CYjlrG4GYmmzQSJwurGwWhKXwXM732TYSfzWjGpGaIaLNpUIp9C/0q5krIldb7ORCxNqc78sjxzPvgc2Ygwrz4NN5DhattP4x7DorV9boc0LJ49SGX8BfIp7yoKdDUWIc79Lxvq4ZhJOSNlx9ypCVdxvw9pKfUYQKL30WP36Eu9ESAPIP8pMZQg5qZ/6Cp8g1vKndWmhahKuY17YXgFnDMvXH9N531duU9PcfrNRkWEJ7nFaTXlzhM8YNP1yVKkiZQRVJcpTAH6l+siev0vw6uOPfslhMnyf7OLTCWOkASw/+4uIpvdw5Yw+7y9q5eFZ04+2KhYwTq5QGcbjJUUgZLet+Bg/Gg89jbCoPjyiMT39zZIzr6/zbw3U1eZzF4ZWKK9M28r2KvMiVzcB72nKL2mm0grA0gXICz6aJK6YhfVte+xEJ2UF15c7lvQaPTIWl7SVJU4EfVBgKWl6aODq4g5skR9Wvjjzd5FuzeZ4xUAt084K61CjqBoLte70h2clvE8XbSQbcsNjrhgpIOYbITB0m1pX10jOGq+i+x0ce7mQXnSl7jH2gko/9JfGO0jW+Stfrr54l9rUcDzt95cYWtjzqxHNe3D6FUulg29VTXJkJ26/xt4vllIh+F51dCGJqbVXQYu7UW/mlvFolvJIxVoZ9uiTV6f3jjtnjDv+vtfpfLEBOfcz5LqsIdvhLmoXVjROGXJQE5oDiUcGU8YiNhzUQdiSKW2w6Pz7ic94oUqg12RKJWOYqpKdz9qHRX6r91ONhXoQuBwKJzeW0QjWrgUbgeGfnfQMRP9WQFyStpNMMJd5eh5d+sMQ=
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
v14 -> v15:
* fixed allocator_test.rs changes added at the previous iteration
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


