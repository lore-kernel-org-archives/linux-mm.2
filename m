Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F710CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEDD26B008A; Tue, 12 May 2026 09:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EAB6B008C; Tue, 12 May 2026 09:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E126B0092; Tue, 12 May 2026 09:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A27916B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:05:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28FF44042E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:05:00 +0000 (UTC)
X-FDA: 84758787960.30.2D775B8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5AC6980011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:04:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IWxKhxuC;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778591098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0aFRyJuhw1FtNPMKr1MBpgrmHtqCJuNbQnKGEA8QiY=;
	b=6seI5Q1zb3SyVC/mGj1V5lXec9uHuhH5CF7Ae0I5pv8Lq1Jhv6f8oVFoMpTxD7pjEKDJ67
	Jfggq8uV4VdKVdkHX9CQE1nfguhiYgydGaLmr3OuVr64W8wAN0eHjSqRftCv+0BJSOTWNs
	MTHuVnRd2eUC6HwfGNbM1VxDRaHjuas=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IWxKhxuC;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778591098; a=rsa-sha256;
	cv=none;
	b=KEfkAYTC4b0uCpQkdi5UEQ0isASspEFb4XccH4Nkgq0NKjHC8EFiRsEpluBIdytfMiNFq6
	A0e+lC3thD4Vo/2D0W4Qhjq2qxHJxcSoreQMnS45F0cgB5PWuS3bSXf9tnE1pxcfwcXtbM
	T5FcDRmddcxMP7YD9DmVX/euLT2EhEQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E0aFRyJuhw1FtNPMKr1MBpgrmHtqCJuNbQnKGEA8QiY=; b=IWxKhxuC8RCB2ActRTE8KVCN5M
	DnB++oI0X/b1BOwytq0dCdw2EnHJ5xKN7a8N7CjMHhp6vimHXGFuskQWqFyVDCgYVjcrr/QtfyRz+
	Vhj1QBg0V3xx+ogUFvMEj/oO5A18drI7yOJFJefy7H8zgIlbq+4+3eCURXkveQPjvt5e18OHgIS3E
	803DK7ZSg6AxWI4Sz9ropY1dhIEyM+7MsALBGdkmcgi9iFa9eSbqb3QdEr2eTnSQDlTzBAl7BF3dM
	LoG2lIC4HSHeZak3IXAesaJIsDmjccUXQsB352Bp38OVfglSjXPBACflDJcF+j0nmAPLklKei7oGC
	+iJ1PGTw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMmmd-002Oak-1d;
	Tue, 12 May 2026 13:04:23 +0000
Date: Tue, 12 May 2026 06:04:15 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v6 1/4] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
Message-ID: <agMj4ukhj1PkXXrN@gmail.com>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-1-183012ba7d4b@debian.org>
 <9504c193-8c01-4d03-8f62-c50fd7fbdbc0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9504c193-8c01-4d03-8f62-c50fd7fbdbc0@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5AC6980011
X-Stat-Signature: xsmkwwy8ea4qkwuyq9sg85pum5tzakyo
X-HE-Tag: 1778591098-355393
X-HE-Meta: U2FsdGVkX1/TOr80Glq658hYLCxmrlA+/Y0e+y3jNAz4lSUHJCBi8PECG5VmtA1pBRBbN/OkUbl5m8GRKvcKZzEDhJjuWsjOV11PkNEp2g3+s+EZa5d03CP09TI22jInJGbEoa3AZ00rfc1gEx4kQ8GoRdWLIktPUBPH9bf3KcNo3zx8I4rVEMc/88TCNtlhnBu/W1mzpTUzU0eimmdAXBJ7zC4QMatdeLAzTMJAzdemwFSRkPgsPmlpxhtzOuMq0I+EdJmMlZR5a5KTBEWBVDUreLEh45q23KrZsLfg+UuLl0/ZBxffo1s1n7zAfXkeidE/fdNTSOrK12KR5EixQQ5W/Cd2r+TI7SSymRrfin4iUWMO7+qWQ9oyNmvaZWT8r0IvVcISlb3y/I0obl+eWKEliG66QZgNwaIwiAN042rrdrt8IZx0Kh65xANQgnW9n8H2CHcSlWCjoIYJ9/gvYEi03X9wIMHzvueaf+yrRwjgKvqYoXfEzsLcGkcXDFALfzYZ0dqxUXxaZXgygQKY/p/DdEDy+H6zoe23u7Yb+w4z0JZduVY1qCC3ZyOMCn6PI1gxjeHf5OJsMnP81nn/dFDAhTG26bbQGmOKcZBhSiTAXNzqjZcJDgeRJxaopcW+EL3z7Tmyvp+ygAlRyDYPoVZcSVnQsPTyw+F3Agf5cBrJiyYUoRnBmHhzwbZeeEB4JOWGhi0DPKnDeoUo67Qeu2ylU8mxqguJNR3Ch+qdaweuWWuUvGwJfJnx+DpnC/2uWpX7L7mG9PPrDWKBLtNgugTkD+A5V6ANqMPJqFHmdNP2MD87TXhZ8VaqzXKDNSp5oL4UigkDdjCPqKX30JmA3RykuH2KHe0+JzKNExe+JuPWBEq6UNe0gPYEygHcJ5EB79CAOPaV3HENGGTO8tF66qEHIuflo5y4uqqyLM+PfuJUU+g4HPK7L7XyO+uobB+TWuv7arXd9jkKxlH6MzF
 RSjU1Z9V
 M1Dfh1SHIEIUYd3sYH9HOXzzeHj2+14588Q6cx1F/jWFV11cxIIiXpPJETcidvYTTxErxQpl5rlmlurFuwpYtid7ZPhAXvsgHPZRTp6+uCkF5Rj4iExxYJhCAZgHgYBrBobdazCsF/u2jon9cxyk2jqusMJ0BnYr/gJ/R4jtvPF8mjLnV1Cpt3v6edNoHacna8skwS784UgPXM0BJ51tkMI0wq6sfIMxfKdgIyij68yS+0LYIjlomVnGRCdQNokw72oRF5ZRNHV3PkECOpTIpWBzWLM0x5Jo9PRQX6MPOTSWP5zBU7IyimdpyiFP0namDlP2r1z+8J3lH5HkvdQmDPTj7Gm9Uyva/jzttF8+ZDJ4UZVh9hkRKGxlk7fI+WwG2HElF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 10:17:00AM +0200, David Hildenbrand (Arm) wrote:
> > @@ -2348,6 +2348,7 @@ int memory_failure(unsigned long pfn, int flags)
> >  	unsigned long page_flags;
> >  	bool retry = true;
> >  	int hugetlb = 0;
> > +	bool is_reserved;
> >  
> >  	if (!sysctl_memory_failure_recovery)
> >  		panic("Memory failure on page %lx", pfn);
> > @@ -2411,6 +2412,18 @@ int memory_failure(unsigned long pfn, int flags)
> >  	 * In fact it's dangerous to directly bump up page count from 0,
> >  	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
> >  	 */
> > +	/*
> > +	 * Pages with PG_reserved set are not currently managed by the
> > +	 * page allocator (memblock-reserved memory, driver reservations,
> > +	 * etc.), so classify them as kernel-owned for reporting.
> > +	 *
> > +	 * Sample the flag before get_hwpoison_page(): in the
> > +	 * MF_COUNT_INCREASED path, get_any_page() can drop the caller's
> > +	 * reference before returning -EIO, after which page->flags may
> > +	 * have been reset by the allocator.
> > +	 */
> > +	is_reserved = PageReserved(p);
> > +
> >  	res = get_hwpoison_page(p, flags);
> >  	if (!res) {
> >  		if (is_free_buddy_page(p)) {
> > @@ -2432,7 +2445,11 @@ int memory_failure(unsigned long pfn, int flags)
> >  		}
> >  		goto unlock_mutex;
> >  	} else if (res < 0) {
> > -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> > +		if (is_reserved)
> > +			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
> > +		else
> > +			res = action_result(pfn, MF_MSG_GET_HWPOISON,
> > +					    MF_IGNORED);
> >  		goto unlock_mutex;
> >  	}
> >  
> > 
> 
> It's a bit odd that we need this handling when we already have handling for
> reserved pages in error_states[].
> 
> HWPoisonHandlable() would always essentially reject PG_reserved pages. So
> __get_hwpoison_page() ... would always fail? Making
> get_hwpoison_page()->get_any_page() always fail?
> 
> But then, we never call identify_page_state()? And never call me_kernel()?

From what I read, it seems that error_states[0] = { reserved, reserved, MF_MSG_KERNEL, me_kernel }
has been effectively dead code on the hwpoison-from-MCE path for a
while.

My v6 patch relabels the failure-path output to match what me_kernel() would
have reported anyway.

> This all looks very odd.
> 
> Why would you even want to call get_hwpoison_page() in the first place if you
> find PageReserved?

Are you suggesting we should all the page action as soon as we detect the page
is reserved and get out?

Something as:

    if (PageReserved(p)) {
        res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
        goto unlock_mutex;
    }

    res = get_hwpoison_page(p, flags);

Thanks for the review,
--breno

