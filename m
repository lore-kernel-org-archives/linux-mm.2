Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0A9FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E5D6B008A; Mon, 27 Apr 2026 07:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4DE6B008C; Mon, 27 Apr 2026 07:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332886B0092; Mon, 27 Apr 2026 07:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2314F6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:43:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 204D188322
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:38 +0000 (UTC)
X-FDA: 84704150916.23.B8C4AA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6FADCC0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bt5VYUaV;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wtva+FS3vpAxca6Ju79ePfSu3Z7UgkanAUfbEe4Bf/k=;
	b=7EG+CFabhgfhuH3KopafrJXVhAHHwQYeWaDSzcHnilllZyArhSLn20y/DtyEQ5fAU9WPfG
	y0lg8aISY7/7eh9PGPCOQVYBdKbKchDqYBrDT7FidEs6juqpjgjcdKouTNQSPDU6xg1rj6
	AAlsmHsPHAKHICGiD0BXb6CbbJMT260=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bt5VYUaV;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290216; a=rsa-sha256;
	cv=none;
	b=z3Zp+BgpT5hfqI94tptTeSok7oy7Lluu+5ZARQkzbi91biFCD1f5QwXJOwRlZ3IQ9HIlsv
	Ov+uq6GbRMl8Xa37OhNEe56R4RdTu19sJgRvL9ErI5Gcv/aRr/TZOqhONQ1YrJaQjy14iA
	BrJPTBzA04qPPoQP66Xo5Ts+tJF/dbM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CDB543EA7;
	Mon, 27 Apr 2026 11:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6E3C2BCB4;
	Mon, 27 Apr 2026 11:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290215;
	bh=EDbnBx17zS3xFZo6r0KM+PlWBWkB+tisTjXCa9SljeA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Bt5VYUaVeiMKMvtp4PJnzxTzkhqzQtitzwOIBd7dGufTGpQdLZr+l9UI1u+wF94vZ
	 przTAXUDjSXZPITU2w5TMfx3urPPrN2uaiYEtWIF9DjELA4Uo/uf8PsTFUWgRtk5LX
	 X0Tq72uYHSKXbMiDinApxr7tyK/bgleYGU00D4DUxXtibOPcIFwE2jplS5S2nZDGIK
	 XRVMUEoijnNXp9mPoWTjnEMg255JfJaljHDsj3uyF1ELYKZ7odNNG4Aagw/7Haj+R6
	 zJJwmbPgkWWz/pFJma/i3UPApAxVDSoqoNCCo1sapUQt7ORtmpSkrNmzr8PZw5ngTz
	 XgCcm4nFpIUgw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 27 Apr 2026 13:43:14 +0200
Subject: [PATCH 1/3] sh: use folio_mapped() instead of page_mapped() in
 sh4_flush_cache_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-page_mapped-v1-1-e89c3592c74c@kernel.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
In-Reply-To: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FADCC0002
X-Rspamd-Server: rspam06
X-Stat-Signature: qrbejokf15donzywywmpoua3znn4nc41
X-HE-Tag: 1777290216-544573
X-HE-Meta: U2FsdGVkX1/X/8OxcjeCtiQWwYEF52l7avqJanrFxBpl8mzEGpjJoIcxxW1OTFi/UIpjRyxzXXrBo9pOz7H5xnAQzFBdbKzK2MHAt0Lh6r1vX/18fwDY+HuaC2u49xTrAIIUxnDXdQ8Kb4qP9NQuhFPggWwXLRst9voqapdGW9Pwsy5VkJVNyQhWG3klRnJdq6137ZHQkCy2LMgaDibiX7Y4MuUmBsoMBMIKBaRE8xED9bG62woTDnzPgVhrVQNVOyamafTyklKMIbLG6lEAPy5uSbg2b6YUaxloP11UOIc/q9Sw9LnrSA1Qh4FY00mIhbHgg0YEHmkG0gHaBdyGBWRDZVfxHMxSwBLmV/UinPkmpE18N9fUYcqfU+qbqamIfq6qrWZ8XGgaGHQNrhMjZOQ9Y/XsCIB/unjPHlV0LyMHhk241DOqKLE9UB++xMlGEL9f7t2WmsP0XBaVwOTqkneXAEhNLu/mEfO4J3Xsn40i4zDoW/CJEJGyDJZqJwjt4Ccx7GdZYumbVpqHqTrzYszvU+SLjl23FqThRxau5hIZ6DVLY4OX+V/Kn/rZaVAWOd6jfz6XESGFcEbLQDV+WRvfHF8Ej3U1IjcMi3A7fRwA8lrAmr40plbqXK8e66dgR5UxPUvUcS2Cp+Ig0Jmze8BE1ZYiOY6F4hP2I8AqNESmv2Vp5wkwCvb3YCNZ+5uLTB9pGqm+LjZnmfuRE+fkgGW4I6WpdG4KpX1z/9F+/adXoFRGsf9UohThqMXATNiGeF3tvcYrVpB19Wk148StedExlclhVCwXaXJCp7w6/v81nu9I0jfF8pz4xTCiaOO3bTnih6h/1CR1oD1npir4mEFuzxJy6OPj53LX0zD4WyuBIDwyuLKYNBBNwaWuNZIjTR+NYNDEo6VgDg5fdWBx7EdTwBcq4eWnjtX+TTpSsbVYQk/EPZwKBd2AmRitc53BQ+9WL4C89PmtXBmTPDX
 LgYFooQQ
 db9jEK34Nxwxjxnwefb6DS5LtU2f/yOcsniOgUcz7SgC1T/66M85/FVP7om5k8M/6CXSWmyVeFg4F1snvZl0YG42SgYdax8mcK+TS61GWQCqKLlKsLMkMBZs8j4jXRrVbZ/eu/HOIYEoYWKYqtgzHqyjltp0jj/4MQNQETby6MOExT0j4C/PJKA2Nr9jvhy5TgdOZco5gYdPSytpV6NKlMOnswKpgwJg/ImtUJFmHgmP1TwYBws7VPQmjo1EKNaEmhlSRfOOOKylbpiZYYZEM7VGwoUgYGcuDCFB2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already have the folio in our hands, so let's just use
folio_mapped().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/sh/mm/cache-sh4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/mm/cache-sh4.c b/arch/sh/mm/cache-sh4.c
index 83fb34b39ca7..8bc9ce541c14 100644
--- a/arch/sh/mm/cache-sh4.c
+++ b/arch/sh/mm/cache-sh4.c
@@ -248,7 +248,7 @@ static void sh4_flush_cache_page(void *args)
 		 */
 		map_coherent = (current_cpu_data.dcache.n_aliases &&
 			test_bit(PG_dcache_clean, folio_flags(folio, 0)) &&
-			page_mapped(page));
+			folio_mapped(folio));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
 		else

-- 
2.43.0


