Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0053ECCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440BA8E0034; Mon, 10 Nov 2025 12:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1298E0003; Mon, 10 Nov 2025 12:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0EF8E0034; Mon, 10 Nov 2025 12:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 183848E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:33:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B548BC01F6
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:33:51 +0000 (UTC)
X-FDA: 84095395062.03.FB02010
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD11320005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:33:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hDu5eaBS;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762796030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ag6LW6hemevws8YrksBMYRPO4jlV1oMVj+5QJ4bp/14=;
	b=RWd4Up85nJvdp4bueDAXHdsJJOubQ6TpJEVqDuhZ7FtUcScn8VRu3swkMTWmpIXM4beOLb
	5KIxjWPbVx518DxGUyjgOSNapSvKRx40bLMV/PcsmYgKImw5ItEQILvtg1Mlv8geHTmx9E
	pI9KaTLmsZ8j+dNDGc9Uwg8wDbVzlS4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hDu5eaBS;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762796030; a=rsa-sha256;
	cv=none;
	b=YYcGPnbyxtNQ3o5ndsKWn7r/SO6qpb1oXxqzqRHprkryoIcivlUnuIwdRkg/5X2rwr7sCB
	BUjdbo2TYxQJD9gQ7hbfIgj/m2wDJ4ZkzEHMzNkbP4vhiEf92C3HigiZYIlWIrUo3S1Kvf
	lLIitS/YNgNFWo1oxnqeCZ5/spvQa70=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ag6LW6hemevws8YrksBMYRPO4jlV1oMVj+5QJ4bp/14=; b=hDu5eaBS1pVnzx5mZNWnb8VpqO
	VFIdXUQKfLY8jwIzevEr+VfCN/w6HRq94VSeLELvL0tCdMRmTaKp+OoyCquDJ1YKftqgTXnGuXivN
	e7G1fRZ4akwXOIQlabKzKhURAD4V49v5AvJZjhK7oI11kCGjD6M+HDEdDojgdSauv5/UUlrCYfnMm
	VAEBeFyDxGQHEYv+LH8xct0W4ckP/Ijd7RaaLXzyI8yN0V8JTcE+DuFgiFbC9Kj8GA4O/wX2rCojR
	GDrtV0Zx8uqP60OizixU9gPweGirxQv8fXvN0WQKr4ad6yRB5QhoGbajemapDE6BEyY/3ih/ECIDt
	Ia90NZoA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIVla-00000002xxn-1bOm;
	Mon, 10 Nov 2025 17:33:22 +0000
Date: Mon, 10 Nov 2025 17:33:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>, Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>, Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>, Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>, kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Liang Kan <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>, Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>, Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/27] mm/ksw: Introduce KStackWatch debugging tool
Message-ID: <aRIh4pBs7KCDhQOp@casper.infradead.org>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD11320005
X-Stat-Signature: zch1rq4s8ebb7h8akcz7uwgsp55ny45n
X-Rspam-User: 
X-HE-Tag: 1762796028-156864
X-HE-Meta: U2FsdGVkX1+TIeRJy1UrarmZFk6FwUqqR7I7H6jsOwZbm9DlLiQUZWmAo7+AOcBXS8jdhJkjXAADjRotLMnmdnAYZm1mDOuJeh92k883JT24U2fOiNqL4m2u3EtzsLL/UWwpPI/Dckzy4UgVampoCFKrDj4Nw81sqmDdszXVgLf3hB4k9orIQ3WxNpAM12PVPB2mUHSkhZLh/jMFH4BX/kSqME3y5zF24Uj9xUs5fVx4J5LVfSKk2Vot32ho5NStIWUdZSIn2a/ZLt8z+3AYIePSUm++8IFKk//rvTHrOsRYGseqKbBivakOA21RDMwdiSSvo/zS3JCmDop9fX/cexB5cE3tVTSR8+/bmw6joCd0BEJ6mcHnz0LVhmJauahQ4OAreKYC26Vh2rHLXF7vuWh+QEoUm+UprEhDNBBnYyfKvqatpvo6aPXIvkCYXws98yXG4haGlYTVDiYDk2dUH6NqlhGI5H2Aoaefd3WExnxdYMehoivyhTMtJPlAAbdss2TmzhgV7kzlP3zLdAB+m432g7GCqWIgEvwwdMrqh4k2vqwOrObnoh6AAqFozU7T3EfQ1+jIRSY/RNdroe8N6YORKZl9ffsL7u4dAKy56ZeeufnZRkKV9aoXy1fIk1b8AtD73/QoKUBsZaIiRms4VVYdXzfPTF9Zj6isQGD4nORbfXWfZfoa8AObEQa1Bpo7l/nEtRoQF+TVnN2rSa4BG6jCDn476VY63CDfhn4zUNkAwpWL1XlhytMWJKTEUP/lNnZAJwgY1Ndb+cIZcL63hMX8qBfzxX1UqwQYrODFOmxzrDP2NVYtrelAmUdOmUZiG1b0vQIjIvdv/phSsrMNLvz+QegSUuUvfDTM3cn1UG9iMVbBR1eOlRo2PtKs/cYZAWfsr3ue7H5kvmhMti8+NbxqWbNPtzGmVvEL4+8R8UIPDo7+z+LlQaGqJfvYVYhBhcw6ziclkrwwhsqS444
 +EgevBrC
 /K9VcDPJ3dougoWYvOiRFr7fZ4c5xBchgErbvuUVmy1/UAsxVFAom99lD+pdc9MrrXzeD7AMtXEsiBa1Ywx9IK4BvI+SQ1zoZ77JzB5EPCsmbvps07vrUjm9HfPkB89Rg8GX0ZkicEN5/H+Hh19+Y6BzsfkLILAe9+OrqkD7Obcmem2A8mLA7P4Zy/uXXx7EFYa02/pK8jv/qnDYZ8VV6h8o0baqLHZMAGdVKrJ9eYAUB356naVszlLWpX+rNyNk4dlJKQSRke/Yv0G7h/MFDxGiEM3XmtORm37UuELBbQzsJm397Nn35Y5hewPBtXgMF3T7lpWjiHNk3MKmhtCkwyINApQX/RgkghHDy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 12:35:55AM +0800, Jinchao Wang wrote:
> Earlier this year, I debugged a stack corruption panic that revealed the
> limitations of existing debugging tools. The bug persisted for 739 days
> before being fixed (CVE-2025-22036), and my reproduction scenario
> differed from the CVE report—highlighting how unpredictably these bugs
> manifest.

Well, this demonstrates the dangers of keeping this problem siloed
within your own exfat group.  The fix made in 1bb7ff4204b6 is wrong!
It was fixed properly in 7375f22495e7 which lists its Fixes: as
Linux-2.6.12-rc2, but that's simply the beginning of git history.
It's actually been there since v2.4.6.4 where it's documented as simply:

      - some subtle fs/buffer.c race conditions (Andrew Morton, me)

As far as I can tell the changes made in 1bb7ff4204b6 should be
reverted.

> Initially, I enabled KASAN, but the bug did not reproduce. Reviewing the
> code in __blk_flush_plug(), I found it difficult to trace all logic
> paths due to indirect function calls through function pointers.

So why is the solution here not simply to fix KASAN instead of this
giant patch series?

