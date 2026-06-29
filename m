Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB88C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53126B00ED; Mon, 29 Jun 2026 10:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04DD6B00EE; Mon, 29 Jun 2026 10:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6DC6B00EF; Mon, 29 Jun 2026 10:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 838136B00ED
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:00:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16C49C032C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:00:31 +0000 (UTC)
X-FDA: 84933110262.28.547C471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3414F100005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:00:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjsGuR1V;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782741629;
	b=4jsy4WZ+qDGWkEXIOpBCp3RUxdcB41yx0NeoX1n8aZTM5J/NUlpQqf9Ok0ro0BerNtUuax
	pZny4kZalUbXMdfj78keTnTrQiEpiYLnJO1Aquf40WNJvcTevzkV8k8C3MDeuxXyRoO2BM
	YOPlzII6ECeo/WB3bvUqoDNpG8iwBps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrQ0h8iCijdq9h/HCuxi0sQxJ7nMjLHJaUOCoTtVI6Q=;
	b=eWZGVdZK5v/BsCJfPlkt58l6nXue9DlXubI1sYpspZDoXsqe6zyS+VkjfmTyJ6BEYVl0Og
	q4d8UxiHKNWEwwTYlDxuzeGO5YapfxvWgxYexRak9XNuUgVK6RdqsVg7AThxVI8RNtb2fe
	cFqvVixh96Q3iL05YLiu16Vx6LLiuHE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjsGuR1V;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 375A84184D;
	Mon, 29 Jun 2026 14:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8695C1F000E9;
	Mon, 29 Jun 2026 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782741628;
	bh=nrQ0h8iCijdq9h/HCuxi0sQxJ7nMjLHJaUOCoTtVI6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JjsGuR1Vs43gDkj5KXMbBnUrckiIBoNHJV4r4QaBfZxNjhs8A41+Q/vVdRxiq/O0l
	 Zo94CrqtSLNV6pEWOsb0h+jiYMkielj8UOu603MFzqP8eOtdFOlTC3roS0ZfIFF1MM
	 B8xpXwJWplO0PYAypNGXffK1wJx3OuYMDUw0+RXABJqbKtOM3ljtIsfAMPXMnIyOV3
	 jUrQhkCYV27sj+1/55UYgow8avwieI8D24TINhfQ6KV2mMhV81c7JQNsyRmWkGAdF+
	 exn26b+j7Ip6huuUGjCBS3OpuVP3SUdaS2kUeSeM0QMLnhn30GmoqTSC2sSyI0zC/2
	 +D41WJbjNn1Dw==
Date: Mon, 29 Jun 2026 17:00:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>,
	Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dimitris Michailidis <dmichail@fungible.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 00/16] mm: Some cleanups for page allocator APIs
Message-ID: <akJ6Z2P8eMm1tc65@kernel.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Stat-Signature: 6q35qqenxse4huqbzxs7c8zbhuuayzmg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3414F100005
X-HE-Tag: 1782741628-304038
X-HE-Meta: U2FsdGVkX19ywPWhjmqh9aGCmTGNGGtNYuuXXhbAz4h8amaxvTFeeA5WOHePVutSpPguxofrKkkS+7+6+GsWeevccQKmfod5wVwKaf/r8lrTQImRmMOXIeZdZpsHFKN+oExp1mEc/EAPTbZx/I4EnsFhmxcKEZgdoTjCA16LhzDAKvZF1XKGH5jmnVvBu/SxnkgslmsWzKdhHVrN7KxS3AfexMJ39RSVvmEqigb9BIviKLRIqDj+rq/6tS3pBHjifnQQcnhtb6xcdVcdl/BbbTJAor8ag6zX7aFbG3AWDWA80BkYtK/NYuLSEmrFje6U2Bz8mQCKoLZyTJjFy6Ns+pM6k64+J2zu+08tWCmU+a+2NRLf5st17BZdoP03J3Fyy7KkBaIBYMIOP24Ck3pnIU9hERMKhvu5tqfFb0//a+wX2obQeKlUhjO1aQagktDMWgILnALVMuKr0iROkFi4ULCYMtUSxOmdZfPwGKjb/tcmpsNJ9NQ2JL3X8ARm+zXERxLachET5ZlMyql7UgWJ6/1KT+rsZkeQHGXR3fg7vQQu55aP70L2lD80IvC7X8KzkHh+UnSb/gug2qQhegyBTJVQDKxbS81uqYvg705ERciE1e2LXz0nLfeJg8lgYhFxSorWXGAh6N5brNXUPw3CAnyt4QkCYpxIg0LtzFWk9vjLOYLAisXd6l+Yo5pYv02lOm6ZGMXtYreULw+HmscSokFsk/iMCZ9AujOanSAuDuc5SGFXdWYWTxLFTVb6x72DNOyjvX5sWc+EIPHVgqgqtjimjXupPMYb6CUz21g0YbFsx/S/Y0bIDbRLyeRhIP4rqWGKaCLwFtXii8Wujotfy5Rp0uqYw2ugH8+4gAPfOlCpGFuT7FCe5pNI+h+bbVhllHOqhVbGd6sYdFcx7BoOUedbTVSKLTdjCmNBl66iM0JBom/WSEHv8PcHamo+b/091eOevg1cxWvTMPbLruM
 5WiXZQSV
 lrPFQ1BsXgvrnje6F1OaboOL4KGoALuvzQESkaDde4Yr12joTWbaMibcNr0ZNal0s+wI6mZCyGzO2Ah+kbWBfFy015wCtSGCM9+l1LNmgd8KkEmBQUDj8TkDTetD4OHv8InyuDAE99wabBtHfAjvCXA2IvlMcWXcyVw9g4dNh6hRITiuBIwsYHfcSZIrDkeVQ9Mc7pVgdI6aytKp+4a54AsIFTi9KRFKrlGzsC4trwlZgRA4U+Z5dk/zJQqwz6wfXQiVjIg+9s0t/75AEkPZicSAEg8KcYQqjmRb6gTSAJIW+I9rOKd/VtusbG74wHoURPY7R3GdNf91W5k6nAiP4wDiLZ6RHBcItEXYvNVDTVlJ80eSGho+GnwQpIOL6N6wpsI7cjZoL6inU/gpte1z8eAyObBx/Bvg6FsbGYaLf3MIr5RlB8h/+wE6DcusgEyISuRwX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

On Mon, Jun 29, 2026 at 01:11:49PM +0000, Brendan Jackman wrote:
> 
> Some tweaks and cleanups for page allocator entrypoint and flags. This
> is motivated by preparation for __GFP_UNMAPPED [1] (which will probably
> become ALLOC_UNMAPPED in its next iteration), but all this is supposed
> to be an improvement to the codebase in its own right: unifying code
> paths, reducing API surface, and removing GFP flags.
> 
> Tested:
> 
> - KVM, mm, and BPF selftests in a QEMU VM
> 
> - kunit.py on x86_64
> 
> - For the ALLOC_NO_CODETAG bits I just booted a VM and read
>   /proc/allocinfo. I confirmed that if I remove ALLOC_NO_CODETAG, the
>   kernel crashes in early boot, so I was at least booting code that
>   depends on this logic.

Heads up before the full kbuild report:

CI has tested the following submission:
Status:     FAILURE
Name:       [v3,00/16] mm: Some cleanups for page allocator APIs
Patchwork:  https://patchwork.kernel.org/project/linux-mm/list/?series=1118244&state=*
Matrix:     https://github.com/linux-mm/linux-mm/actions/runs/28375636866

> I used Google's internal version of Antigravity (AI coding harness) to
> do the repetitive bits, those commits are marked with Assisted-by, the
> rest is manual.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

-- 
Sincerely yours,
Mike.

