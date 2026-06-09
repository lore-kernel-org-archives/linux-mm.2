Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9126CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6DC6B00A4; Tue,  9 Jun 2026 10:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3977E6B00A5; Tue,  9 Jun 2026 10:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5A46B00A6; Tue,  9 Jun 2026 10:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7606B00A4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:34:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D60B5A05E6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:34:51 +0000 (UTC)
X-FDA: 84860620782.20.FB5C6C3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01ABE14000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:34:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dnczqqpE;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4bIh5NbfhAERUp7/8LJ4i3CTv6SkjIH+Edzb6aQu9c=;
	b=pBFZ/bs+HNy3ZwPj0qUWx3i+RrFM3Nt2u9U19Ee9XYoFPkW5WmEP8baI3DUvpIIgdHMuiP
	+ySUn/f5bSUWmhjKnKeKN3hsrvyE8J5JlhgIjr9PDJpk15PgTDEZLFHGk1l56poP1V1Nx0
	LTEO2SyE4SK5zwzxEDLS7LQ9kUyws9o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dnczqqpE;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015690;
	b=VA5VPduGNgHvuIw5KTPQPYcat/+QU/iN2VLqLxIktyEWWS1jgDQCbZGd0IH8pMJANOiJWD
	kAqjf6cJ5POQYuTYHamWilESoRMyufl2mWJKMGCJkgiZ1vk2ChUDEaMxj7rNgpf68CmfJx
	r1h5iVRLZn3mzJoSn0hkG9gHhB+dfSA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h4bIh5NbfhAERUp7/8LJ4i3CTv6SkjIH+Edzb6aQu9c=; b=dnczqqpEaE1tHQHEWp9Y0Om4fo
	dtX5XBMI8DrHEgRIH8wsvtz+5FjF0OVS+EQD6Fp+ai7XSPP9dZJKDbEJIKtAZHHtvEn+5Ce11/Hyi
	TlOoFTe6C7GBSoGV3K6bzzUC9iubFcKq+P+pW0zbc5VMSu7JO6LEZFOPoFb5gGLjpkUTD5ulEdHy3
	YJOn3yg/pEK3UCiL1xBouFG4SD1sz9/qDmE82ASYFJoZWP5qwyodQDiNcYmcZmSMXmZvhF1iVfVba
	OrmEGQksDp555/WZ/exocpRJEXUVLeZ9qN4yov8OQyc3qZiiI0LNl1l62ToK57Nn7kBsoeiIRCxZs
	vnsqbMYA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWxXT-0000000FrLz-0Ck9;
	Tue, 09 Jun 2026 14:34:47 +0000
Date: Tue, 9 Jun 2026 15:34:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in
 handle_bounds_compressed_page()
Message-ID: <aigkhkcXuQx7yfPu@casper.infradead.org>
References: <20260608210618.3437216-3-willy@infradead.org>
 <20260609131724.3114804-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609131724.3114804-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 01ABE14000A
X-Stat-Signature: 6icg3oin76g1yojuzsfmpt34dnspuisq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781015688-377103
X-HE-Meta: U2FsdGVkX1/ugVuaRYrr4ajjjf3Q4uo/fN9CzAQqaBtkYoz4xPtA6RIHqYXVVGzpLdxTiCpIL8QOk7mqOP/9JNA+lNbX022RKLHovJNiyNhQqTP/e37DFFB3vdR3ahEyj4AhkGvf6bCcJE9UPM+EZaBv5v9Hc5LrLiVVK4OAeSiL2TobO/Zr6E581Qo25Uj7R3Y7K9hspMCUgPJHFW8KFD7DL02VteoqOzKQjhHs8ITD0IXwXrFPYQo0ftq5n9rdcd0U9UTg6PaKD36RwlyWItQDq5bO0vCrQgf2DIVLfd/dAgfgC/T9H2mWitUF+l+EQn5CbdDln9PLi9YuJGXwjOFbw9YZTk2AsRxy9/4ADvhiXiis3gHskwPQhuK3M0TD8Pu65PEch9l3LEsNUW3c69izS1nxek/IfNTH44NnrXW0mztL4QALkGnoI8x6dNqCa+bqeWN2vMCr59yK9Lwd1enf5/cqrMl9seYa4S48pnUrQ50vQJRd8sdnrclt9zY56YYVEzmpvvcTdg1odShU1mnoTJrsGDyFpjx8x5T6YU0N1sc+vuL1+Qf7bbIatZbRcIgg0d+02pPx8ZO0jp3chItFbiLA95WaD0CfnHynSG8zg8ekwQ3ZZQ227/TCBeeMWX+jUccI8Z0XuwQ7W1oRqYVWZ4pzmdiiE3Z2tChlta7J57cmxkelY9TB4cIa0TTZgFwW9hfWFT4G7Y7ubPLdOLCCGI6c5G7Wc2IghPHmqWK5utc3Nt9gJpv9djbXrwZA1Su8n4IjeFbKYjLKhfN8eAjSmxX+VwRN5JNNdTwK7lb7K1LUQNGgUtYM9wIcB5FxbixkJBYHbjkXldEOSEv4OcvJzujfBArw3QLHLFqBnEokt5UxISKJggW/EvVR4hbjzT2cB3UWj+p3ambomOxa9viu6PzReibHQ0DN8jQy47tZkfJraDuQGrV8/SVErJT3al+aPF/97pU12J0N/h8
 aynLEhZR
 aJHM7b99g5Tx4kXoM87p+mg5lAABriCoTE0nMdo+261os0o5IW3192T4bt6rX3ZhqM8VTEoUdbP6rR3p8y3220zOvDj9k7YcRPIhBOkOByFD9mqtd/bOfXflPG+tWd7TbNuHk0mmqjIssCx4NsY63FHSmHcIzaILA/6xaaUf8DIVPFAj9mLh8a+lB/Tn8wWBCQjAn1mUtwCGQy+//gND+hIjUCwKRIregGowFPDhXVdISgaPd0tfSHXCc9XOra/vQazLDx4fPeXV1M6lo86JmXACvvKLZ1CmATjxy1AtekG8pUNybBtCBt62Sm7lmo3zXdt4mDxKkM909fEUzZ5Z9R4WwVscXZxN5FqhPb0uVXjSgx5DVXVozqyZg1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Editing your response to patch 3 into here]

On Tue, Jun 09, 2026 at 06:17:23AM -0700, Usama Arif wrote:
> On Mon,  8 Jun 2026 22:06:12 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:
> 
> > Nobody is supposed to use page->__folio_index.  Use page_offset()
> > instead, and simplify by working exclusively in loff_t instead of mixing
> > up loff_t and pgoff_t.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  fs/ntfs/compress.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> > index c904858dff3d..b279f38636d6 100644
> > --- a/fs/ntfs/compress.c
> > +++ b/fs/ntfs/compress.c
> > @@ -105,13 +105,14 @@ void free_compression_buffers(void)
> >  static inline void handle_bounds_compressed_page(struct page *page,
> >  		const loff_t i_size, const s64 initialized_size)
> >  {
> > -	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
> > -			(initialized_size < i_size)) {
> > +	loff_t pos = page_offset(page);
> > +
> > +	if ((pos >= initialized_size) && (initialized_size < i_size)) {
> >  		u8 *kp = page_address(page);
> >  		unsigned int kp_ofs;
> >  
> >  		ntfs_debug("Zeroing page region outside initialized size.");
> > -		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
> > +		if (pos >= initialized_size) {
> 
> Is the else branch over here unreacheable as the outer if statement
> already had if ((pos >= initialized_size) &&...

Are you saying my transformation is non-equivalent (and I have
introduced a bug), or are you noting that this is a pre-existing bug?

If the latter, is the error that the else branch exists, or did the
author intend to write a different test?

