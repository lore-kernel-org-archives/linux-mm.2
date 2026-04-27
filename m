Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C3DFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0A16B008A; Mon, 27 Apr 2026 08:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8B66B008C; Mon, 27 Apr 2026 08:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6396B0093; Mon, 27 Apr 2026 08:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 903476B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:44:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50C1E160185
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:44:08 +0000 (UTC)
X-FDA: 84704303376.30.7E43051
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F418180009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:44:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FHOQ++Ro;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777293846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=955jjZIxxknUeB2SbfK/z9zTb80A5dO8nDIswaatI7I=;
	b=n9jgSt2SEB5MacwwHLkDvOt1yJ8ZNt4/jvuHGLaNSUHc8j38XCUDHrlwK3T77vogEu/fIM
	Yn6gIe3bHA5kNNctgXT1LEC3iNUF3yBJDFLhYXiOv5+rEXAdJkfd4p5HBBitgKKQjfNuEg
	2hlYNux2HMj8FXRBSE9xFzJ5PQt8oCs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FHOQ++Ro;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777293846; a=rsa-sha256;
	cv=none;
	b=s5HVTJpGjjgOKrQSwIibSz/qqGW+RGQdIGeg6KfGdssGnTiijyxaax6o7YxVz9GcglvOKK
	75+vmihmT+SOK4+CTSYzeAqe5Sfs5r+xKTU1L/FsYzYxXf/b8dV+UeEBibK7rjgCM4eZs8
	gE9Y8xwHHIcn+QbgG8c89UkIPLvKwKY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=955jjZIxxknUeB2SbfK/z9zTb80A5dO8nDIswaatI7I=; b=FHOQ++Ro1OPIzCJ30X8QNrYF38
	tMokfVlKhhdHPbCY//yhDqo2LA9mFuikUTYQiZIGrfdYmgCeNPzkiL3j5rLOxr7pUnUz4vO8kMgLo
	rFlvAC52/rSCZ0WJi0lY6UKhCej8De7n6TA3Ubki7YFE+1jvm27DLy3Var7+eRjPePFHG+o5fUUNh
	fQl0NgeqRWAzfBdlUD9QR60VnOz9F0BvfePjGkpv8UjKNfyGegHPlNNf134WsKnqPCDYNptDG8Jr3
	6y4bmkqSJkrPvaI08VjtenYYHLeIUvAzOnO5qY6jMm8y3lfc8V30goLH85UgmbvC7vPRi4gOd5wFA
	UZtRrLXA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHLJV-000000024bu-1l1Y;
	Mon, 27 Apr 2026 12:43:49 +0000
Date: Mon, 27 Apr 2026 13:43:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] sh: use folio_mapped() instead of page_mapped() in
 sh4_flush_cache_page()
Message-ID: <ae9aBZOcg_Gc7PH2@casper.infradead.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-1-e89c3592c74c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-page_mapped-v1-1-e89c3592c74c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6F418180009
X-Stat-Signature: pbmmprc4wgj1dn7o11oeh45opiuc6wxz
X-HE-Tag: 1777293845-551710
X-HE-Meta: U2FsdGVkX1/NEjFmNYY2HuRb5XvQt/xt9Btg42idiXda952TGhcM2LgcmZtybCELyUyHNYPG0YMPn2md0sgA0iygcFdKl5NfAzsCa+ogouzzeOh5OimmaYmoZzgv3rL2xe3MEFfHyUFP11WJg03Ny4Esq/pC19sivWOrSPrs55FJSGeG21JMBQt+Y2mshf87PQaC76LRvJUmFKd5wOdosniaV1ksTvMDCIYZ5OIDJF3P2za+/p8tPfCd51gwSOd59RE2b0aNvXFr+rXTKG/Vj9Vs/b1IYRDQ6DSYmJzckjhqEboFR4j4eUpozwi08U/KdorzAmTWOgpjT0jtnct+ttZtMbRFjgWX/S6Ea+6Vkatj5/pT2B5LdknRjJq1uyh50AIvRRzrf4oAR9x4v0NLCtt1x9RJNRTBfIvpRPt2OXrtg8MiRT3fyLhJ71jSvAjvLYlBFXJd729gqJ7abO1hNYhXJgLKquadRzEaTXsIXODgl/MbOdVQqFsY00HLRHhuwQRzWCKDyyfUKa6kVNrne6JxRg1kJmZ9qATUVtEW9DuYr+UzzfevWMWEB/ZJmuCjKjA0Qm01dcGfJw4Cd8eDTmIvki3oK3dU7gAM5xJs7uJz14oL7isk2IoPmw/q590ZoWC7CfClDzcQqWVd0BNSdVhwFh7MheIz5LjI/Se2pXOafq839h99St+56/hwiVguf9CHWFhrBSYji/WV0KgJ7TvzJQnKCqs6d4YJcrR+TAYI86UQYSa8lDU1AfIhtnmG3uD35r/3US6KHmxzxt3mFBNvm2MANhB7Xu1vEiJFzoXtQc/Y0QIL5suQI9FoSz0H/C2lSDJ5g+D8o0IVV1RWjSY2oiwtknHBwCzV2981n7/D+lm1yluhHMfcG4JB12aIqbBs3RvD31/wL/zraeGcjvCzrTFloeZwCJFMVq22UssqyMTsfwZgV/n+EeBKEJPIcwQ1CGtbRF2p9SjYaIA
 mwV532QO
 hgxjrwI/JydZi/LZs64oVlUZFW+2OHl2lJiKysLvHXHbq/94X/sQifpV5HNnQkTHkNT+B/BL83jzJ0mp9LI5aqxyihwy4XNrMbTIUZVn3Az2VDWw3DKXyzW2dvzsvqk0MPHfn2thOdP3o8y03xAuKYBK8GE5c9p6pbcM1rCjLO1qGoc37OxmUAmnQiCLaEjIbSBdkeqA0H6r3v0lcAAEwyrh9ITbQgqHGlBH9rMFZ+FfHG4c45sWrf7X8x6WMExe692URjZxF3CLzdxQ0NHVnhz5fI7RWWx5YBIXTSCdntFVp/JJj5Ex/dTxlIYbbsijOELzRcuU5gnnuX7gatcQHvDqb/LkFS+MOgEqZEpb8QZ3B3p7j4cXCYP5yXdMAG45Iv0Qn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 01:43:14PM +0200, David Hildenbrand (Arm) wrote:
> We already have the folio in our hands, so let's just use
> folio_mapped().
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks; that was an oversight on my part.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

