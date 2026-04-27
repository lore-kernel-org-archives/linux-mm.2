Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E353FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514086B00A6; Mon, 27 Apr 2026 08:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBA26B00A7; Mon, 27 Apr 2026 08:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4286F6B00A8; Mon, 27 Apr 2026 08:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31AD16B00A6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:18:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C81C640171
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:18:02 +0000 (UTC)
X-FDA: 84704237604.28.10255ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B700100006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:18:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fiFx94gu;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777292281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LDdgowznJ80yc4FSIIjuF1YZskEhBOBaw8pwQcLhv4=;
	b=OmB8aVjpEw3dK1MKUGiuFmbQBUqauxO0tyl0A9LWpF5UToI6dx7NvNDZKhrBbUQDd8vCY2
	MlBhftzUr95Ck1oRS4zxiRcQNKswDW/jVQ8vtYiQHXkHMjV52U8ct5Nd9FAsWp5P/zCLRh
	KLJ7WSbEpmyWjyX1x+7d6xEm3/2f3uU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777292281; a=rsa-sha256;
	cv=none;
	b=tK+xSZgbMGhA6wA39I8YXI1c3sNlzQbrSMgGzcux57sL3dywT8zDE/A9dys+gzmkWm0guZ
	LcCkoAZafVcnb4zbrp2y72gse9MI9eXrDsoZJaUsUkGm/2b5ypFM9aKCcEHwwnr2eFb6a+
	bcZZvkJlCSAzlTH0Z8mg3AwIHAH808s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fiFx94gu;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 022E96014B;
	Mon, 27 Apr 2026 12:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB317C2BCB5;
	Mon, 27 Apr 2026 12:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777292279;
	bh=AQ4MxxuG0FLIcClDhsTCj2LB5MBEyzoHu1DSqDFxwmU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fiFx94gucSnLNgfPsXQ6PkeKXBxrZAes8+MyPSVTnQtSHgxCxOgepMVd9ezClmOYh
	 661TwppiHatNg981pbUYr7Wx+07vpWIoXk5tf9119+sUPpC1tjtDHhvVEBFjVAwyyM
	 z4FQvDG6nYl4yDFqyAfwe4QfcfJHlUUawc1seo6w=
Date: Mon, 27 Apr 2026 05:17:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel
 <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn
 <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-sh@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
Message-Id: <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
In-Reply-To: <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
	<20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B700100006
X-Stat-Signature: 8r1kicyk6r3tp1t6peqp5cjochx8ffmt
X-Rspam-User: 
X-HE-Tag: 1777292280-211962
X-HE-Meta: U2FsdGVkX1/RKpUheFFwgquNKaSnqhg5SjuTXQirF/eATcUft6Vwo1jm8i6tCN7VKFS8+1QNQLxx2ECzE7oF/aAd4UAXSNNS2qLiIcoB/R6nr07CvNzZXvp/9SmJ/UgMh2mFzBVwcLOgmGNCK86a9FroeMYNBgvlWk8oG7UISi6pjVrVVojVfJGGIH3wFJerla0+RMqK+MmcPUA0l8SaIIiC5PdMG1uqZ7hn+DESWvwjJvNk4Xy6QActUM1YlzQl+UtVo1Dp6+XsVXyJ2DWdIeg9iPZy2J/q1ApalO+2H2DiTM079p83SQuEYXyNjFKupmf0SninTglU4AlB6wc4JGebNgLh38V9bWUFNGZ2rEW02O2nkGHTf03XvYGPEveRjC3QTMGYKC1GFPzFDl8YODkACiRHv//Mkq7LpjOuoRdBSHYeo2i918ijrzd8T1qMXzcpHFBvq9FHP3vN41wj2R96URW+tpvu3DcJpIwVqyJmC8aeKI8LRw/rPtoqoilFSs6vzqtEm1jJfws5ssvxCxUiTJb1aUwsilnC75T2eHvzzY5SCbuQ0rOlOyo8KGRSSsM7nnl4GhgitWYu26yiR5i9wAQEBzNMTWmaG40VEb8p0GEoMdR+JmaK7sUfNgyrVix8K4cLKnLaB9aEkqVWjFqiEK5Mm2euSKhcsth7JD9XtSPc3rX2w+j/ssZylopT6CMCtrs7WqioFU4qlaQIwlsVwZixqqUQIS2RhAI7tA+qC7KoJ6B80UjJdTWgVLWF4yL8TKSHIcoMAo4Wr7I5PUPsfZPbbiAcVk7gWmAevQhVhv4NJCA2ackbifQ0cpjy0I5+/sdDYeT28v7Tvd4M15KOHpmXFsg7wD7++DuVLZry3RY2QFVAl9E7xu0bMphci1E9w6cVA/5H+r4awdmfEyE1Jp5yXkTBAQEKYqpEX4PfWFeZbuYQsgiXMtglidoIrFjkYQ/++8u60ga9u4l
 03TTGC5f
 fItv7ud4IM4E7UBZNXZxdJYrGIW/Jl20YIgAvfRQ3khf9H9/5LUsYiQUE5PTyfgA6p2ivZmAMGxgv6aXWPyeejregCRfzuUpB0HFxtTm8GCLf2R6oPc6o+R+Q3iCFKeFVa0x/L/eonr0iz/ULSVnpGn6VP43oMFg4Jk1ZaGxQN5EZHgU1RpXU5Zb8/VpPe3uMFLYjyfT6Dc0S3iugDF/mvILvsFx4eCmLMyeUuwtugCq/MvLAemuK+n0lm1YF4GydxGwvHWJ42XNU8/iRXkV5am0d5LfSXgPr8rzRlHLeMeDs5XfX5Xj34r9Ak0LHUzq4N2Vy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 13:43:15 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Pages that BPF arena code maps are allocated through
> bpf_map_alloc_pages(), which does not allocate folios but pages.
> 
> In the future, pages will not have a mapcount, only folios will.
> Converting the code to use folios and rely on folio_mapped() sounds like
> the wrong approach.
> 
> Should BPF arena code allocate folios and use folio_mapped() here? But
> likely we would not want to use folios here longterm, as we don't really
> need folio information.
> 
> Hard to tell. But in the meantime, we can simply use the page refcount
> instead, as a heuristic whether the page might be mapped to user space
> and we would want to try zapping it, so we can get rid of page_mapped().
> 
> Page allocation will give us a page with a refcount of 1. Any user space
> mapping adds a page reference. While there can be references from other
> subsystems (e.g., GUP), in the common case for this test here relying on
> the page count is good enough.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  kernel/bpf/arena.c | 2 +-

BPF maintainers will probably want to carry this in the BPF tree. 
That's fine - please go ahead and add it.  I'll carry a duplicate in
mm.git so it compiles.

