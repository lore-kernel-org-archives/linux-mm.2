Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF228CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB1E8E0055; Thu, 21 Aug 2025 08:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2C98E0008; Thu, 21 Aug 2025 08:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E05E8E0055; Thu, 21 Aug 2025 08:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE318E0008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:45:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B468F13815A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:45:54 +0000 (UTC)
X-FDA: 83800736628.24.1DC609A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4C4FB80008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:45:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Clhi6lYK
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755780353; a=rsa-sha256;
	cv=none;
	b=ELiOt/8B26uJ7o2NV0FzkMiiJH1SbW/ABDNhpoObdAyt1Get2AYN1OeEmj5uMQHhi2OwIZ
	khWaUjGsMgZK3TQZPJxn+PrsrSvlJANiAyZwcxQBclJxiRPFBz+k4kQnE4ulQDiNUj8Thg
	iymp58tim43LO7wqIe6j6REVgayC7k8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Clhi6lYK;
	dmarc=none;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755780353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZFrPyGHQwZqMzGzv4IGH0Q8nJY4m/IRsAGxpn3yf0w=;
	b=AmxRusvL8wEzn1IyYp+fjDrsLzBV+D7f8/IjmAB0+pap5Y1CoafQpZ2WRlpji1Egglq1Lf
	V+EXZ4WT+xgjBnwdV3qQWVCKL7V7JJ8W/ae76Z3tf/qBs50nOCZC8NWX2TmpKEr4/6Htss
	DB+OiFKfPOEqjmKGykL701c3C/V770Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ZZFrPyGHQwZqMzGzv4IGH0Q8nJY4m/IRsAGxpn3yf0w=; b=Clhi6lYKNgKNMkxF5CcAEIx/b6
	9oBB8r8WH66JH+M8E+GcAklxaN3vI2ovChmvUaHpfPZDShYXz8ao2mUizgXKaHHHLXa9enroAtD1n
	zkoMZaoRA8oIKgOeHfaIUqpHl7K6gZkSNYDhFHXRBjgeIbXqMPGLljo5LTzdRW3Z8CE52dc2hlAAG
	7+6vVOUs6yjATskg1mqBfAmM3CcLukisg32xH0nPVqmIEWiJxoBPTItKT45FmtMMJVDrvMjdkHpTd
	oTrCaRQsvq8/gxg3xEcEGsjbJh0uSfCi81UF9CtypVp8VsexDhYN8S0Qb7LtxEx6xC/MF9u27Gene
	VFl5y8rA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1up4fp-000000079du-3KH1;
	Thu, 21 Aug 2025 12:45:45 +0000
Date: Thu, 21 Aug 2025 13:45:45 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: fengwei.yin@intel.com, akpm@linux-foundation.org, david@redhat.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
Message-ID: <aKcU-fzxeW3xT5Wv@casper.infradead.org>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
X-Rspamd-Queue-Id: 4C4FB80008
X-Stat-Signature: m9pbzhrhbqxdyh1n5nt84a64zxmji8hh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755780352-147536
X-HE-Meta: U2FsdGVkX1+ch6jmiknbhSpsEXWpFCLzpjAThF/DIOTwSwndKHV57R6zuy0QDrQx1TSnD3YP0RS8DQBebyIu4+1u1jcbiYCKj9YWC8DpK45LFysKI1DMilmQh6cboDZbOsiyPkRFI0d27RRkt9d8DPhUnn1tJidp/CQRvNH5xEIJVtpDJ0T/9cpagprB4ISUD3GcMKIOJn4pxjVY5v3Dm3ZgqWcvJvb3v47qaZRAC9Fw7nJi4elNosRHZ6qhdwOqy8Qt2h4tVE3+SGwd0uxrjVNOLbA1du1pSX7Sg0DZ7bctH7Q/f2Qq7SH0Zv0KFL5gwW7fl7Weqj2G2TZ6jJA9P9fPkLgOfb3e46EETUdR/t0ILe+byG4Cml88XrxAWIwUwHXL/lkD5HTL85hfZCpvM8YhFBeVmP+J1cXuj6Fkszb0bdOQieNm1MgNMMG6PMPYkPE5E+2OACXBRawTJsep1NSN34cedHyEIbJ2AzTzvdUL4+x2PDdTLCA+GgHdQmnB/8Gj6fIzDb8WvYLqC8io4JcRZyZK9xy2XWxk5kzcCLc6Zsf1LHipOsyLI5IDCtWDIMPkgKn7aR9sEjmnVe5LrX0m17yjCAg0uFd5SGGgBPghHQ6Ald4djiIxN7z8HHZorLywt4tiVru0qdVHactWEbFRaW0RPfHJgptHActSNyK8J4gtgm3TSYYZzoI4gIQ0yleZD1YcNv0/DTSC0vj3/mZpeS8fmcGW9F3ESZNWwNUhs9cNRCSSIFQbNf6ftyNiDnzztI9cwhs22QhjgYWU8jcnUndOVFMfe3n1UZ4xwJ2YkeBmsMhVgW1sf6ud7pCRqV05SQgysE7eMcbJrOqSFHjpHIq2DXUzZSqdjIPy5cLwSthua21xX8czDINKGON/CNi4sKZFbDXs5U51OQOy/w/HSIpAn6kVZPco8nr+HO4+RZFf8GvdOZdku0XqrauTGMiQX1wWLAAsY9WPflW
 SfzLMUCM
 UZREZ60H7UCezqwAN5mFuxf/70spatWcdFX9HLQgW1VpXUTZIelWCKDOIZyWhZhFafv0PL4lAv3rcV3xazFNCM0jYUexgvRUHcPVbbvVP98EV2PLhiemP4UY3cKt1B1sl2PLuZPwxf/mXiP31y1gG0rwSJZIhJ+NschY7P1TQObudYeL8iaD/xD3mKYrCixPomkT0SVfrpR90lP6SLCRcMR4qz67EpdS+SXv1P3j4J/HmtYb+lHueCh1K3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 09:22:48AM +0800, Jinjiang Tu wrote:
> 在 2025/8/20 20:42, Matthew Wilcox 写道:
> > On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
> > > We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
> > > if we doesn't set folio into pte, we should unlock and put folio.
> > I agree that folio_unlock() needs to be called before folio_put().
> > What I don't understand is why we need to delay folio_unlock() until
> > right before folio_put().  Can't we leave folio_unlock() where it
> > currently is and only move the folio_put()?
> 
> In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
> the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
> the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.
Oh, I see.  I misread your patch; sorry about that.

However, it is still safe to move only the folio_put() and not move
the folio_unlock()!  It's a little subtle, so I'll explain.

We must not free a locked folio.  The page allocator has checks for this
and will complain (assuming appropriate debug options are enabled).  So
this sequence:

	folio_put(folio);
	folio_unlock(folio);

is _generally_ unsafe because the folio_put() might be the last put of
the refcount which will cause the folio to be freed.  However, if we know
that the folio has a refcount > 1, it's safe because the folio_put()
won't free the folio.  We do know that the folio has a refcount >1
because it's in the page cache, which keeps a refcount on the folio.
Since we have it locked, we know that truncation will wait for the unlock
to happen, and truncation will be the last one to put the refcount.

