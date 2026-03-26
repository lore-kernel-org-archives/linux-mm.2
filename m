Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86939109E54B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 05:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6206B0005; Thu, 26 Mar 2026 01:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FFA6B0088; Thu, 26 Mar 2026 01:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6436B0089; Thu, 26 Mar 2026 01:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE3E6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:50:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB4955B39E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:50:42 +0000 (UTC)
X-FDA: 84587139924.04.399CA8C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 574F140006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:50:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jESuCKXI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of BATV+847b3fc614e19ce422f2+8250+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+847b3fc614e19ce422f2+8250+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774504241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCYIMgw31hZoV2qq5ERN/QG4vp4AeM8BHPz7QOX0MIE=;
	b=aeHqdmPYbNoQpIuLBfvJxPh81zxUP8Yg1AzKqHKk/3cSBBMpt0Dr/SUifHaSxB4HsKLTWv
	+9a/G0Nk3NQdVCqmGdQHJ+RpzKBCGa0UbStK+Nb8BExWCyoPTB4vEPtto3ic+72hUzRPn+
	tq4pz7s4lHAxoMXuEdN1M4avhEQPEro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774504241; a=rsa-sha256;
	cv=none;
	b=ZFyEo7jq+0zZwWQ1P1NQGaP+gW0l2Ol/pjKQOy/AqYpsxjA2ActvujyfmMes+Wv659szw6
	t2BVwR6hoqa+MrTz4uyROsKvZiyA3pqmPF4OqypzxHNH6AhdNmq18Fq3oJ/NPA2a7ApSKh
	zxcskqbCiIO7VMgmZSMbn3yFgIf4aIU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jESuCKXI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of BATV+847b3fc614e19ce422f2+8250+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+847b3fc614e19ce422f2+8250+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vCYIMgw31hZoV2qq5ERN/QG4vp4AeM8BHPz7QOX0MIE=; b=jESuCKXIRU6xrbGqN1bg5HqDQF
	Yg5KSrNdxFdu+X4fDizUM7Tax4NAtCqgpjaa5PdGsIhHfQsanwnAt0OxMbZC6ygGk0CTcSYAI2dgH
	gGYLslMyzOaPXI7L3Y+AF1/hREquoQYcs+Eo9XqfqLP8HQ8ToLDe2ceK4KI/Ml57+Q6UG4lkc5HJa
	zwqeORvDraz9EdQEPrvzJmhyGpsvJZiEPXSiGmR2H9ZBdyNycLWKwMvgFCWKO42GZRbjcv3vWJTqA
	UM4x39vSdZQr0DFls4F/kJyvSc/2EuzUXoQKZc4JQbKA3KD+XrEgLNbrzQqMNEAfwkt7TT3UmVPUR
	k0igtWXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5dc4-00000004lF2-07Px;
	Thu, 26 Mar 2026 05:50:36 +0000
Date: Wed, 25 Mar 2026 22:50:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz,
	willy@infradead.org, miklos@szeredi.hu, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1] mm: fix writeback regression for strictlimit BDIs
Message-ID: <acTJLJdrd_T-cOAu@infradead.org>
References: <20260326001337.828947-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326001337.828947-1-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 574F140006
X-Stat-Signature: 4fi5qg7fpcun68wtft88nspmioxk8rmr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774504240-802058
X-HE-Meta: U2FsdGVkX1+sRDxIBVSdtRnTSe47WPN0UIA6FAkS245sQXaCeP8SFC0ecwGu0DZbZ35IhayHcktMUEhwViPlnfskm9XIx2yyIo+azn4ZezxVopfYQkNRd2QKV4a4KRsk57QJm3YKQ/yXEkmfgylTUkECY+mJ/k9GX40Fhz3tHqQVqwJbg+kWQU7TSk0sfQbtXG5wdclvU3dIwjCrT6XtAacZejAal6CZ3VJ8cGtknpE1NzubGLn9Q6Pac6FmyXkGJnwSali7B7tPfkFwANjbTqIimgGuuE+yivUp+gtzIKcURiqoZW72e4N2ZvSCSeoC4yKanYuXajbQTR+PCxztX63nmrLg3UzS/71jM+gs4zjC2jLB1EHjOUPvmvAtuwV7Vs1gmuufszyDfmzs2He5W7d4CFKlIHHQls5q3m8feHBS73dUTFKX26K10CZq75BwCUOplrdSyEH6fwD/jYdHbaFIzY7uzRV7RQmfQ0beBLz/jV9Nflxh6UkaJuWui6Uogj8OXksNIOLyrmVHDF6yfISiEuHhSTZ1U8HTWP3YXe3Np/3l4zLMOfeVy+IXRk4/lBqFTz1WstUfn+VP+nwZuIkmiFQSOOLFd8VEPJKFSCYlOTOFYZDIGecLyJQiVHe8fJK306gX1VtFeCOpIfM9qfDaSJt2obeepjcKlKmo4gy47OZfbZRwBLdQ++z0lxqQyI3swLUySu1wxyA9vgVDSciq6G6keMmO1fzkbxMI/zXm4RAPS7t9iWweWwu775ynCQSy5cVq15G67WCmU3LKpKqU7OkoIlCUNsZVtOzIiVsdtKji0WmfSF3hS6u+zTvVd5LmgO5zT5PphPdFz/J+HvHE++4D1EfHGeEudQOZfaw0k1ET3sdyCpAVqALdaMFD7DliF34b3GDkxWGe1GMREzU9zXq60oc309JkZQGYNZRV/pSV5OIcHZknuf9dh2iee0Jx9f5QbbKkQWzCEDI
 84TEeIDQ
 s0bp6nkxPzAmIS7GC+x3xqR3RdgQpAMPe5BBrftB7qZUtgN3uM2uW5JCXdFgIm61J8byeFoE+hf3e70NgYMvqExZo7XWFYS1m3T6A8Hiy4JVCKlf9ypzmspFlBvgZ/yNtG6y4GeTU65wGGl7LuAARzVXiKWF79mMt228sSiixExYmMtqXFWnUM2nSoEMTb/7dk6LbCUQQnxyGlrbKN0sRVli9PyPVKDEEvlRQ9ketVYc3tKzqnOkp/mCxhAnDC5g1W4x2ip4ScckVj7tQIdxzJQ2FuwwfiFl6gwdhg2DfXRXBBVkT1pMrZjYla+3Si45SldMRU0t1u4qejxAFfRL/lKWRC/RsGFCiAXPoyrSUPf5qxHXPIPYEqbin6jYBq3BkS4zU8k7anTwY1dSUwt32wB7+pINeBgQswvu01U3XFjnYfNqamLzvm4mE5NeUOlXM02ZiRWeVAXPT4OiVO9Cvj6NPtcxyRVuN3zg9MzoLDjn7JlKKWIDHhRN6XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:13:37PM -0700, Joanne Koong wrote:
> Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
> unconditional writeback kick from balance_dirty_pages():
> 
>        if (unlikely(!writeback_in_progress(wb)))
> 	       wb_start_background_writeback(wb);

Yes, that looks like a bug.

> This fixes the issue by kicking off the flusher if wb_dirty exceeds
> wb_bg_thresh for strictlimit BDIs. This restores performance back to its
> original baseline.

What speaks against just reinstating the old-code as-is minus the
misleading latop_mode comment?


