Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C547C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A116B009D; Mon, 24 Aug 2026 11:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3412E6B00A0; Mon, 24 Aug 2026 11:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EB26B00A1; Mon, 24 Aug 2026 11:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF1436B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:03:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E3B98018D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:03:39 +0000 (UTC)
X-FDA: 85136482158.25.5DA1AAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 68170180012
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:03:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KI0vHaFK;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787583817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1N4Dgg6M9ZUavS0An6jb6rtj/L03r3LLP7KAMFYdsrQ=;
	b=pph0k/5Ide/YqD2O/Kq02WJ6NFva58hRyeY6ysXm03k8+P5I6bctOJNTs15KPPGtrXnslQ
	DqtF3DR6Kw4+COq6i6Ed8qnonjshSHsd0ldExTQ8FEMLzCPH+e7KFLdlJEz5N4/XSKj01n
	yVV751hRIz9fgXeWrZ6wNJ05ehizoaQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KI0vHaFK;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787583817;
	b=UonFSod9+Y3JO56DD42LoIMHzMPRccgV3ZQ0sdj8svazJyjIau+wQ7g/hpQR244ODEg40E
	jyPMhA7p6cO8m5Sh0On+5RDjEun0eOSB7DIgTbbWy/AfnoSDujI7/C9AotTISburWI4v6D
	TeF7Mo6jZAugsXoTH5D/B8cR07MfpLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8816640446;
	Mon, 24 Aug 2026 15:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33F81F000E9;
	Mon, 24 Aug 2026 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787583816;
	bh=1N4Dgg6M9ZUavS0An6jb6rtj/L03r3LLP7KAMFYdsrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KI0vHaFKs2iuJuLBxJTIK9hzpbfb70XWVZdAMV9ZNmSB1s5dX3EODo6iK2rwMvff3
	 o1zo4uNkOUy09uxeY227ljEze1a3rJTOdghr5kYtStFuCASrN68C5wXq15sm38+bAT
	 Ws7tjHRZmtjHfxUXLJR7Yuwo/17LwBS6i/9QuCr3b4J8f6QnJnCtXixlT8ArO6Iz1s
	 Om22oh+E7kYUjI76NqdsR4QjPcwMNRS1j/ASCgkr8ipXbaMycJ7ls7Hc1vaozvBhem
	 V9GLPj4tNytQrv1bFOrJFpWnbWNOhms6MCk2QEG6JzFO7PgXOtlsfOddDdj7QhxkAg
	 YQKYaFLUEoNJg==
Date: Mon, 24 Aug 2026 16:03:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] userfaultfd: constify VMA parameter of
 userfaultfd_*() helpers
Message-ID: <aoxcY5n99-Pzlw_b@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-2-3086981b33cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-2-3086981b33cf@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68170180012
X-Stat-Signature: us1xrbdc7so9bthdstfxo8ya4u9hgq9f
X-Rspam-User: 
X-HE-Tag: 1787583817-185567
X-HE-Meta: U2FsdGVkX188gEmegmYPlUtpu+qwfHQGRZf56N01e0Nh0CuiOZTzGUudGrVxfitqIoTyyN1OlOM/Q/4pUcw9qn9r/t7uX9rqs1+U04xoQlPV76ey8z2ceVteclr/x4MrisnFNn66ZHFkrLCW11/UyUgopKzEppGKPqI3Vav4ZhyId14ySQvSGf3AI2cfqXdsNOhPb4QPV8xLCwAKyvwNTr2dvSzq3jwgUJ3g9soKopkmtx0hED+cZwd2oEH+Vw6FS4ZDKYCvlT8W9aDL0iJSzUhHQDu/8D1NGpi+PQ7IxhltLtX+AwaCIZYgeXgMrX7hEjWvumJftGom+dO2zNaFVIHdZxXFkataJCR2BJJy/cqmDCtpQdSM2RMCjDqp3Q0T94vXo9dv96Os/qCrSn3mVlcM0LCAKCBs4VwGk646CaF7/Txzx8MH/pLRCnAvrPmSSzZvOoeDui87i/P1M6YjnTyD+mlWOn3fqiZmn5umzYAvaOY8RYfUweqmwB2c7fmjZwf9STUiS9aKNG4nXfS6EEZBGfv2vFON9aGlpgvpXWFrBSibY3KQWlBxVe9MPEs/blqTNm3Yl1ju7Rz5hqb605HzZoIX3YMu0YlRu6TyDJ40nX53C3vDRvMNdGPEta7XH343T/kuxEVKcjGKw1KGKxHoCpCa/A74nvMyb6mxosxv0pmw4Avbm7q0UqyNYniq1hH72mK1YT8FPyXjU8UTafwa4zLYovthsseFyeZFgFyeDAZgHDb8iqTuXjsrNU/9LHkc8r7DhjJkeBWntEyGQNiykLkvZbnZuCIaW6OY1Fy7mxMMuk4rI078nhjj0og59R+C2Dc/yNpoimmlkil36WuH1Bft+CI/lQsI0r0OL+MhFPYkFX+gg26syXw1nM/60B8cUB+71K4w+DeRTabztbx9+HG5xPfFcjYStGS8mwWUkpDds6lc0+06u+Ci0XN9JsRkRfF2HsuJZs6m8iU
 MvrVqosG
 uv3rURZIoWUqfGIO7AK4aLJgLO77uEWouGK3XhcS/NxES9IXM95UqtKV/iGRJzJB2Yshc/X2a8RZRmmLaWoBIMJAXNuDLNlFUu/M3R97FciDBq/XYmaL4T4Ep1YhF9eTx8HH6aRJWxd5XhinKZGZTmnaipSRdIUDWLX77G4IMma1O3n1Rk9921amLMLr39B7kDOb3n7c4eLUDi7EhGfcUrO0UF0Lo3+qDBGbs5HXQKEu4jhX/JT0feaMaeHZlsomAn/exP2GDhnugK8+T+URA1JsLs+bsFARmd9Ez48Jx90uSrboarpxG7muX7IPNUlmwBbkGB2uKd+b47pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 03:17:39PM +0300, Mike Rapoport (Microsoft) wrote:
> userfaultfd_{missing,wp,minor,rwp}() and userfaultfd_protected() only
> read the VMA.
>
> Make their vma parameter const.
>
> No functional change.
>
> Assisted-by: copilot:claude-opus-5
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM and compiles GTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/userfaultfd_k.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index a4351cffc60c..3396d270b159 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -204,22 +204,22 @@ static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
>  					VMA_UFFD_MINOR));
>  }
>
> -static inline bool userfaultfd_missing(struct vm_area_struct *vma)
> +static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
>  {
>  	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
>  }
>
> -static inline bool userfaultfd_wp(struct vm_area_struct *vma)
> +static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
>  {
>  	return vma_test_any_mask(vma, VMA_UFFD_WP);
>  }
>
> -static inline bool userfaultfd_minor(struct vm_area_struct *vma)
> +static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
>  {
>  	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
>  }
>
> -static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> +static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
>  {
>  	/*
>  	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
> @@ -230,7 +230,7 @@ static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
>  	return vma_test_single_mask(vma, VMA_UFFD_RWP);
>  }
>
> -static inline bool userfaultfd_protected(struct vm_area_struct *vma)
> +static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
>  {
>  	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
>  }
> @@ -353,27 +353,27 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>  	return true;
>  }
>
> -static inline bool userfaultfd_missing(struct vm_area_struct *vma)
> +static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>
> -static inline bool userfaultfd_wp(struct vm_area_struct *vma)
> +static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>
> -static inline bool userfaultfd_minor(struct vm_area_struct *vma)
> +static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>
> -static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> +static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>
> -static inline bool userfaultfd_protected(struct vm_area_struct *vma)
> +static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

