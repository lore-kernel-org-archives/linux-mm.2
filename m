Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89364CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 12:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22488E0003; Wed,  1 Oct 2025 08:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA678E0002; Wed,  1 Oct 2025 08:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37A48E0003; Wed,  1 Oct 2025 08:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C40E58E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:47:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D864160A10
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:47:29 +0000 (UTC)
X-FDA: 83949521418.24.4D0900D
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6D65C0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:47:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P//ecjFt";
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759322847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jbAq27x+6Ohu5C8t37JTrdMMIEZluW2VP8UzF113Oo=;
	b=yQC4B1fIOgowLYcZsQ6d3Yd1D/bZOmx5GXCf3Hm1UlS28q0pIwLKIN77CNzUybSTlgy+CJ
	ryufdzeIhqkCb/bvsop1d773eWFN9PA025AVwi7MLPRWzhFz/AyBv1/pvd2/GnI/vGxpY2
	rvMJLkv9l0tYD9q+rQHJ400Cr9Xcxfc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P//ecjFt";
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759322847; a=rsa-sha256;
	cv=none;
	b=i+VJIq0bH3oKzXP+tstlUrVR4TbKiFUnnvgy0QgUHdkOJPJCs74VzCptyQdoAXnYnOPmdr
	jHNqFzEIeKMJ5SvK5cg3mlai2UjxurXWCFavnMNUOOMT06EVQ8b6kJo8jAhi3FVKK21b/u
	mgmJULjF+WW9NKBYc8+EF0D7LWVlsRY=
Date: Wed, 1 Oct 2025 12:47:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759322844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8jbAq27x+6Ohu5C8t37JTrdMMIEZluW2VP8UzF113Oo=;
	b=P//ecjFtKiJHDjV1XNDMgZMod3wG/g+N0uto8cBhW/w2QUokuv+5sjW9PjMVw0541JzVn7
	/+iVWORug+p8yhf03THXsQackG2BTLJZapgBOYiszUzGePwoidnACPcC59PDr+Z3sDAd0e
	0aLjqGO3yym+RrB5xV0wcTX8Ub77vO0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: make thp readahead conditional to
 mmap_miss logic
Message-ID: <aN0i107IF0oQ_PQb@google.com>
References: <20250930054815.132075-1-roman.gushchin@linux.dev>
 <hm56lqfeqcpjjpwkzuo4ktv7ayt763htehpi7ie2d47q52gm3w@mgbj42ivvv5g>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hm56lqfeqcpjjpwkzuo4ktv7ayt763htehpi7ie2d47q52gm3w@mgbj42ivvv5g>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E6D65C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: h1tf8qwcpzdr9gqb6mrkakpdoi4rm93b
X-Rspam-User: 
X-HE-Tag: 1759322845-313178
X-HE-Meta: U2FsdGVkX18edvbMCd7QiFX+AuAqmKQXZPVyB7qtPB/VFjF9Ajim3t0CMf6gHSJe446fZixJHMre5OOo/ygL2weFKyxYeH2GFBzHHCznu4LD0fyePYiQHvmHR9DY6dZ3LAeLfCml+coHS5bp70DYm2w/CpS6T0q4kCj/b2VW2yb4BRl98oqam3AwHjHHcNMhRLWdIBgjBBgcwM4LVynkTdTuKCVEKgFHhUMNgPlDd+qMedJnwMRiRDR9O+vKbohJwRdB1NB0JqISWEotyDoEdVFjR9Dl6PZvCLrqbcQ2YDkaayHHbUWZ4TW8hIkxVyr9hMOEXCBKe2uh91gyWPPsdzz3yKSDLEmq5BAelIpa0QB62w2lZSS7vVVzWQOdIeVfuveELDfiTNuPQkqNcT40ANN7Ql07ECTxZj9GsO/xxCOh4L/tL64/p/emtgR7pjsU4JA+XCI8qJIIh5GQDsLJoGXOANmqlrPJFJt2R6Xbk1UiF8tU0BSbrbq8jhqejhGoSHCDS54RRR/wTSVr9aQxL39SX7xwVMtmAhfl8TRZTgkzBLj9mAF4r+xytqK5ZE/gxrsgku+JQy4Ta8Qr2at2GGJ/phg5Jvh7+zU27V+utEMfL9GKYpldhdt1OBZ+2f2VEWrF6dAFVhIXSZjGAgkt3avNuN9ozmIT3ScVNX73m5HtArOS6fsyBnKd9maiDYkr6W7LYA6XWp78Dh7emZxXWNz8x4f08OZJVSBHX6suLVSB1KuVMkfIOPsEc+npqqLaWKwO1p0xrWo7wbL7ModvLmJ3d+IxAKc0qr5k+oLOs0oa19v8p+mlE2YwaiU0Ef1gxnp5ah1xVpTN3LOmXlsWzkxF0pZVgiKnFIJQY+j/Nebv9oCWlI0X+d6yQ2ItQtOfaIhnrhydsBps2Fi2jVhp4DlRxznufh3Bnik9/2IESdjGIdcXIHluOt4BqAwFx67ycYS1cnRzE+RSAktRVTr
 fiGaX/NY
 VZ8C8Qo3WZxu4n/iy9RtvapPZGZpTZFKss1sQmOp3mis2rHVDWGJPJ0nzx3I4Xwt9Hn3LLbS7eoII/kFyDdUnxZHFXjQrgFnUoAlXXbW7k9uhBdwcfX2rxbq15WzLrCZnqNkNtvk22AFsHfwtbvEkgvhtWXBT4OV1h28mrijYzORt+XYwBP0qqVLJE14K4CvTrGfnCz/dtHdkAikOi9zlLTFLh1e++QxAB6a1wFeeZEz9qkGTW0tmrpNU7bRYiUOpSgkxywAJiJRSl7g1JNiRNhiYkQSwrVDpLrHF1g/tQoL2/4yRrhk/UfxMZfTYxpWeDpnhLTmVgJhXoIVA6QQIQ3hnlBBbh6L8UqbwnPb+qe1gNB646QB/pjp/YCXYbA23e+pYH2zrt6PCHLUxvXZcMYRrmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 01:35:39PM +0200, Jan Kara wrote:
> On Tue 30-09-25 07:48:15, Roman Gushchin wrote:
> > Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
> > introduced a special handling for VM_HUGEPAGE mappings: even if the
> > readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
> > allocated.
> > 
> > This change causes a significant regression for containers with a
> > tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
> > commit, mmap_miss logic would eventually lead to the readahead
> > disablement, effectively reducing the memory pressure in the
> > cgroup. With this change the kernel is trying to allocate 1-2 huge
> > pages for each fault, no matter if these pages are used or not
> > before being evicted, increasing the memory pressure multi-fold.
> > 
> > To fix the regression, let's make the new VM_HUGEPAGE conditional
> > to the mmap_miss check, but keep independent from the ra->ra_pages.
> > This way the main intention of commit 4687fdbb805a ("mm/filemap:
> > Support VM_HUGEPAGE for file mappings") stays intact, but the
> > regression is resolved.
> > 
> > The logic behind this changes is simple: even if a user explicitly
> > requests using huge pages to back the file mapping (using VM_HUGEPAGE
> > flag), under a very strong memory pressure it's better to fall back
> > to ordinary pages.
> > 
> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: linux-mm@kvack.org
> 
> It would be good to get confirmation from Matthew that indeed this
> preserves what he had in mind with commit 4687fdbb805a92 but the change
> looks good to me.

Hi Jan!

Matthew and myself had a chat about this issue last week at Kernel Recipes
conference and in general agreed on this approach. But of course,
an explicit Ack from him will be appreciated.

Long-term it would be great to use a better metric for memory pressure
here, e.g. PSI. But it's far from trivial.

> Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thank you!

