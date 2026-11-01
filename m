Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3194F606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 16:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FtgcIIiI
Received: by kanga.kvack.org (Postfix)
	id 3A9B86B00EF; Sun,  1 Nov 2026 11:35:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35ADD6B05B1; Sun,  1 Nov 2026 11:35:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2716C6B05B2; Sun,  1 Nov 2026 11:35:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 017676B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 11:35:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C1FD8036E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:35:24 +0000 (UTC)
X-FDA: 85387100568.29.808C248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89B5E120002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:35:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtgcIIiI;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793550922;
	b=wl2KjwEbHuAVebAnOI2sZRINYi2Afw6yXDwg7k8A2caFgoppiyUnyP1gvh1wVSLvqpUxsi
	3YaKuT2pUEKhiPTV65FPrwOOQxy4sBjkt0TptMmHmizy81x7m6FfJC3fm/oov75bcM2yzl
	vqznYz9Czo0IeMXbSqYYYk24fF7JAS0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtgcIIiI;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793550922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YjP3QKnL6hdPkyCUqoebq2EqaYVn4Rzbl+nO72ucugw=;
	b=leoHZepDWPPMwMuYxx+3u0leuttH0YFyan2N4UVs3bTjGJKpJdE+h5VLv291hl6etdPnQo
	eicKLih+B1zq3wWOyc9yQQn5csLXa7OZpOUlvSHotFYK0qNfXLb4M8DgYCW6iIvLL64UqP
	3UgPb7pyYBrzrng2Ofz0dsJul3ouQSM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7847043582;
	Sun,  1 Nov 2026 16:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9E41F000C1;
	Sun,  1 Nov 2026 16:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793550921;
	bh=YjP3QKnL6hdPkyCUqoebq2EqaYVn4Rzbl+nO72ucugw=;
	h=From:Subject:Date:To:Cc;
	b=FtgcIIiIxC5mhsREebYXXcY26MyqElKXddG8VSV30z/XdvQCFIksXl3c+v9GjMtuq
	 QtuU0P9aTtsZq8v21syWbho3OiSBZtdEDa3ECISWv4q7zM6O/HGhlHQOxW+RqzAM9I
	 +QuhM9jgjSMjzn5YuILlDB7v8aK0fsbW0DUQGedr1I0kOLSTNJq5vjVHZjLNaBlsYy
	 iq6QV6Rf3YtNPSsaU6wdiwqTvKLr6FNxxlY/W0rQilNl3wJfuYi1Q/ZVAeinf1d9G0
	 38iSbaHwMgS45cUu7ArhCVNfyBcfVkZdGAEEzA2xz2BFF0k56k81x9QnUyVrECNdhR
	 vBL59C8rcgqng==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 0/2] MAINTAINERS updates for page and slab allocators
Date: Sun, 01 Nov 2026 17:34:47 +0100
Message-Id: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAChq52oC/yXMQQqDMBBA0avIrDvgiGjpVUTKmIx2io0hiSKId
 zdtl2/x/wFRgkqER3FAkE2jLi6DbgWYF7tJUG02VGXVEJWEH1aX0PMkT57nxeDqLSfB9m6pbWw
 91jxArn2QUfffuev/juvwFpO+OzjPC697uwR7AAAA
X-Change-ID: 20261101-maint-page_alloc-update-78d176d4f4ab
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=779; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=C3HW2TevCH2Yd2fJl8QWGaAZ6VzDZANnTLuuuAbT5V0=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBq52o75G20DZ3UsraA1LZSlqLZzWB1h+UWekpAZ
 tOz7gPFZB+JAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaudqOxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQu+CwddJFiJpJQwf6A67YgTfbad6SIv1DxHNedH2qfkDT0AQ
 /oSGN+Ld2mcfLbvzkNYWDEPgreGMZ/RHkMe3/gbQAv0gZb63cJewmGqzwHcu9JOjmzUd8NIm431
 RVq7Tq0adY7QI3YxnAzerSMe8MHL629FI4j1G+1rICz4msmu0romeKm8+vcaOxAvEPDnP0qiv9h
 62+HGQhvz0/D/ATRogB39gOG2F2F1Vov1Bg+5NOUpPUHIvIAOuF3qF+pWu/hmirOHpOnQWDHeqH
 FxbOre8TLgzSmssk45V/kxvTYU3E2N02ntAuX6VXGvyjC3fZGCuIVlpCrIRq/p0l3vLSLpg6KMA
 R8fWrjZoSdg==
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspam-User: 
X-Rspamd-Queue-Id: 89B5E120002
X-Stat-Signature: zdmnggaiytnxmqbccq43wot959owijcr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793550922-967660
X-HE-Meta: U2FsdGVkX1+hAWbd4C88cjEYEUNgWk2WV10k/74RrF3jqyJWetXYRfpmrBf/sK4YfBOhYa3p1G4IlWDq9aLvS8ZOE4yHxbVXuE6vNUIb4KNnz2kNKSiTgNVali/lnZTSbTDc+HLDe/QOdzYfEfxlbuRvhZrf1u+vX6UNPUkGPLNgRATTLCta8Z2yaAZ4pK3Jnu59NFwlZK31En5cv5zw2wgldA178wfWXcj2bhAO4++gZHnoPjQwWom+7j8r9Y96dU+dH9dacq+Y9pXzBvjZuIpyV8OTk7dIC4OOuA/VfgBiVfYZq8V5qI9K+EbHFXk7bWu9kHP/Hsyu1wfsW8nuRtRncCq6qo6QT0j1udAyet6l1hoyhVvTGjeHMRZWGK99I7vHaD3D7c4McCw5s8Mn9DqButOQC2yp9LuiUpsbTp7b+17NHOSNYr9zw05prKUsmSz/Mdw5MeHRK0F0rxxXR6aSLFICWEjzUxJFxJdgN0tfYJ7sj6CPrXNrlnXi1qKBI5vLz/7XpAKFo0d1G3lwqB6vzsUao5FVc3tY0HlZPB/kmvHiWxfcWFVvoc3NMaIQo/XtGOiaCrFrhjIP8M92LU3aLU07HHNynHIIqKgoGve671EpqCh3jn4CK1DScRmr/nIORjHYzeUIKis4TlIk7FHabLk1sM0fYYzBbLHvFfz+6/NPLwv6/boLIENp6g3lSWvtUaMEXh5Y9OW9A0bESkbjNu4mc8RTJHwZyQx9dmpcJwaxa/FHNWMIzBJQ/3p8FVlKt5DLjjOzHcbKpcrO+nn1f/Kjbk6OY5wvuv12Ffb4RuFsYPan3BllOLEAH3BTpL0X2ql8NsCbWxIw/0PYd0fy+QOCLGCzFOc/hRNbmKo7dDKEQk23BPhCCXXPNxRaAo+ai7oiyN0c20LCSCBlxpycS11MvmtmMRthqObgwRk0l9pECBP2Wstfn57X/9yDs/7EC0aEGQVrv2HtDMR
 dYxR2Bmm
 Uhws2gzLYYzag6Yf4hHrozxyrMgtwpW/FlxaD/7NC6N6DVS9YOq+eKU4B9YhBau++03I+16hmjNwlV3ZoQ32GTfwlpB/tpgjj/o/IjDX7wz8xM0P5b/CmhpCQHKL32cpCZTLbhupZ2lpZC7R7Kbs3+BkXfCiMOb130y0/kHIxCWbl/PGi5lGBi4NLV9d2e8yCdGxmh/sXs9xYb+t9XOEgVuXAh10y+AlqROoLuiuv678Edu/QNWGtHt0iJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Following David's updates [1], perform similar updates for page and slab
allocators to indicate the MM process transition for these
subcomponents. Importantly, add Johannes as a page allocator
co-maintainer.

[1] https://lore.kernel.org/all/20261030-maintainers-v1-0-97278f8a5f54@kernel.org/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Vlastimil Babka (SUSE) (2):
      MAINTAINERS: add Johannes as the page allocator co-maintainer
      MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT

 MAINTAINERS | 63 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)
---
base-commit: 7161984021cb0605ae2dfc478072ab1aa45a2c67
change-id: 20261101-maint-page_alloc-update-78d176d4f4ab


