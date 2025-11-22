Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9595CFC515
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091EF6B0022; Fri, 21 Nov 2025 20:43:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0426A6B0023; Fri, 21 Nov 2025 20:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFB96B0027; Fri, 21 Nov 2025 20:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7A646B0022
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:43:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77D7FC07BC
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:08 +0000 (UTC)
X-FDA: 84136544856.03.76BD523
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C0C8C40002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XBkGrH6X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763775786; a=rsa-sha256;
	cv=none;
	b=NEbW9ElSyF9qU4S5PZt33bWZDfwsdTK783niOv5kEnLJQU5dhvwIDyna3fUAIdA5ng7fNw
	cHUr6OvYC1t837KjfJZcWv9wvoqUlC96UqlgjrxsG/zuCv079z5+mG3ykLgBGfoq5a2FLP
	OzbIYJ8+D4oVCdpz1C/VZJxldeyl7rg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XBkGrH6X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763775786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VFFFal0KgopQTRirqvBnLjiWC6ARsP1SoxJHi8HOcxY=;
	b=7Ji2YSyZFu4UtczRYgDD8L1FqN3yUq++mJZQObLc/UfAwQSOBdizhKVV+aPhYW8m7z8qoV
	B7jXtw4iNeg/y66+0r2WUa0c/MRq3sJwQrIpuC+K7AmkmS7CkefdJlxQi418LvuUkwa9jP
	PJOXMhg499H9DvIB6K/bUXoEg57x34M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDE1443E1D;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C603C4AF0D;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763775785;
	bh=b0N2+6axFL60SmL5qq5mSm+WP+EAAIDcygJAHAmKD64=;
	h=From:To:Cc:Subject:Date:From;
	b=XBkGrH6XQV0rAAPjG07QkiTblZA7Dosnd9q4wS/SttoChQxGFDGEtw3c/+uSX9ZuY
	 Zx2mkX5+8Vvd3F+p4coxqRU6MmDRdnFZDnhD0K/ihwUfthtQp1OB+lkHvPlOyJiblo
	 qDiXXQYy33Qn/1cpWVT3qVw/hVt97FJ8DzLC7F4wYtNXuieC8+sRJeu1hTlocj9SXc
	 8B0tPAW1xtUp1DmjAiTPz+VwljWcYJ1RgJBrMY0uJ63/17zj3HYzaGGTYLhMwVIt4r
	 c16bOa/gcSLIh7SSrtuBBAw4dQJX11bYYPtbqk3gFpMeDvjQFVN8tOEBQZgIN2D0Pa
	 DOcl4A+6IXPTg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v5 0/4] slab: Introduce kmalloc_obj() and family
Date: Fri, 21 Nov 2025 17:42:56 -0800
Message-Id: <20251122014258.do.018-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1730; i=kees@kernel.org; h=from:subject:message-id; bh=b0N2+6axFL60SmL5qq5mSm+WP+EAAIDcygJAHAmKD64=; b=owGbwMvMwCVmps19z/KJym7G02pJDJmKoko3Vx3sM6x9fsUtUvjBdZOr2T63v3zR+eRSkRXIv f5jmfftjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIkYKjAyTHHeOCn7oMaEkqul welvZ0wv6WtTfMs5fc0ubUupSt5lxxgZZh0OOdHlxfcnVN1s53SZWb4/bcREDX+7xZ43SV1a+cq TDwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0C8C40002
X-Stat-Signature: 5xebot1iwantehuw1x5ufb8smdg5fwo7
X-HE-Tag: 1763775786-956361
X-HE-Meta: U2FsdGVkX19uur0d7yHlIlhr2mz9e4tUNoyTfCWWaW1h941+3Eqm24zLyOuai5VuYE8/UhyCSKgSUoRusGCZ/MdmV5vPF8olSVcai1yLu8ZSiOSCaOZpbzG6fpdcO2F0MnKLfz7JYyFBAHv1TVj5mvYAyfh1B9jDoIVW5EYpZZfKfUAxz2XtZeDwllnOIgcYzxYgdXqp3CcI1fgiwnwpQDC41U9SUvUcq6VUbM8Wu9Kub0z9j6JWVHdFqmeQfS4zRIE+uwXhgnke6R+HNdq5yObo/2yCgvriLaCb2cka3ZjsagxT57LxXu6vfDLQizQmiaUT0+y1UepE37GW/u0Mj44oSYLNikpUjb5kqBnt0omObxJvsIrmbku0JTO2hCqsU06Rh67d9cV53PBIfU4xdvAW2C0iSct9mKPEjg5cbk5giQLOgv7KYAo2rNQryGdnUJb8O+DBhDSbkAvaworOm7VizOJ7M/l4gbpeNtoZkd6wZPVGRcPTtXlp45cbdY+SdhWtYTrK5V1fEcbcz2RGqELxgEuy8e0qzot4KGYW/z1TjYo312th5c4R8VizcXhu1pPo6hgdrjNSJfV4KPXqIHnqOqoYQ/TmTZi2OGpzH0MWFaaGV5g+/X2fn5THi5A44RgnmTNABdY2Rx4NQA4BslPJbG0Ap2+ibgBV8FoZzzx9v5EFZWcg8ATdHTXXq3n2mXA7zvsLYaVCWRy5gqhxJaiCHSpA8ZsWLxX66eVTEKv+7LulZMUjol+063Gre3iHhFP8bf9MXmf745+sladGDvHUhnbm/XK36UhJygvQqHpqNJcsX0TdcT9iZrvjYM9m2J5njR2WoJ/z5Zf+x/bw9ia4vQ8wu/b/J9mV0/k24FNtG9zKwDG0k4exUz2PAx7OLMwNeuIgLfUu2rihRVToV0wZGMMSjFWHnhDcsdAJFEDKarAijaNuphSB98b0S6PkPeY0d+dojV3e5feHVWW
 McsXWnEC
 oRM5Hch4RJnmd47ldtZqdxCZQq+Lhay9sZTSzCUD4TIAWoh7HaoE7Dw7tzS6aeE62MQQzS36GpvHaybsBQ9LUYJklq1k5svlkdRtpm6o1Z0K146egtO+4V0acbSdiEQW0danfIn1jKsLD4X7x3uQKEHC8MJml7Q/rqAGUoCcSxDPQH1u0edVHEOULZ5sGI6iJo5Lyzo4OrJdekRFrZeJDH8z/f3Kx3b58v3h2o4fZWgsmt55z8/mJp8Qu8QPq6JtX12yGMsZwZVqPLjdByfUNHRVbl5bAtxzN4m36my/v/+38OXg9Txb1cFTsrDyizm2g4g+zVxokxYY1xOhO//Pta4BPsSgGBuxAVIRa1U7OdEnuwidoRM5iiZzgX0iy+XJbLZgSsQbOvLDKgQVcXP7Kyx/IUDAkzjgLCIBlKALOAPEA+27ro+enfQ4mtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Here's a refresh and update on the kmalloc_obj() API proposal for
discussion here and at LPC[1]. Please see patch 2 for the bulk of the
details. And note that this is obviously not v6.19 material! :)

The tree-wide patch for conversions is here:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=dev/v6.18-rc6/alloc_obj/v5&id=f79ee96ad6a3cafdb274fe15d3ae067724e72327

Thanks!

-Kees

[1] https://lpc.events/event/19/contributions/2136/

 v5:
  - switch to using assignment with type as first argument (Linus)
  - fix various comment, commit log, and kern-docs (Randy, Miguel)
  - renamed flex_counter internal helpers with "__" prefix (Przemek)
 v4: https://lore.kernel.org/lkml/20250315025852.it.568-kees@kernel.org/
 v3: https://lore.kernel.org/lkml/20240822231324.make.666-kees@kernel.org/
 v2: https://lore.kernel.org/lkml/20240807235433.work.317-kees@kernel.org/
 v1: https://lore.kernel.org/lkml/20240719192744.work.264-kees@kernel.org/

Kees Cook (4):
  compiler_types: Introduce __flex_counter() and family
  slab: Introduce kmalloc_obj() and family
  checkpatch: Suggest kmalloc_obj family for sizeof allocations
  coccinelle: Add kmalloc_objs conversion script

 scripts/checkpatch.pl                     |  39 ++++-
 scripts/coccinelle/api/kmalloc_objs.cocci | 168 +++++++++++++++++++++
 Documentation/process/deprecated.rst      |  42 ++++++
 include/linux/compiler_types.h            |  31 ++++
 include/linux/overflow.h                  |  40 +++++
 include/linux/slab.h                      | 172 ++++++++++++++++++++++
 6 files changed, 486 insertions(+), 6 deletions(-)
 create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci

-- 
2.34.1


