Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BF4C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7756B04E6; Thu, 13 Aug 2026 09:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41ED6B04E7; Thu, 13 Aug 2026 09:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30DD6B04E8; Thu, 13 Aug 2026 09:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7FE86B04E6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:22:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93B3712014C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:22:09 +0000 (UTC)
X-FDA: 85096309578.17.0AF9E55
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8942E180007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:22:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IsnC7J96;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786627328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2tEWWdzV+7J9x88mIAGKHx9J/CXctHydpXer80NAgU=;
	b=ypzeQh/K+VtT1Ucq8VUZ8sEzu1JU+hLWTDkwGyicDlvVrjNZYY5s/qGvfXZ0ooFKMebL0l
	fDzbVjqVp96VuBDC+qzbwyD9iroTKG9q/1hdqaMqRWyKw0WBhGteaZZt5h47o4UZyMPOiw
	n/+ipVAl68IyQ0d64HcqqB00wJ0/TB4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IsnC7J96;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786627328;
	b=VGsfhoGPi6Nag9HxOA0WbG5qg3kCi8Etu1DsAsLOhpTas9MFawcimGCmL0aJZy8XTrVhjs
	bOZc2Z7WFGlUNy0R2whwbcgDlx9LiyjiZE0/x+hS94awx1v/WDAUFnvakrxtf6jHHqQU7q
	ciyQ5xNqPRe++oWghMDc7upXmltgu6s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q2tEWWdzV+7J9x88mIAGKHx9J/CXctHydpXer80NAgU=; b=IsnC7J96+5xO9KPnzngYlGsl/H
	iNgvGdcnDcmFKIG2lc+J8i/HgTeFhid3FS1KzmzgpQUXW09LazRt05BTIlBYLpZYNA3NCqq2zqbpr
	R7W7AQcQOu6CKU4DgPPoAuWEir5LQC5ecRW3J1z6JYHAeWy+K16KbtBrfPDHnaesw1TVo2rgabb9T
	BtwWAz5OdaOMH99i+yFmBGJdNpawFUlpd9fZsC5aH8GAqhV8+ruzxhOEhl+80xyetdSZy56TkfWsi
	RnQXcMg1h0y8GSqAg9F/nUxStw5uwxthrBiqkjxzt11/MqSzS14qg7QYybzcR4FvAMerl4b1uNdQE
	Lw/uXskQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuVNk-00000003dnP-0Ndm;
	Thu, 13 Aug 2026 13:22:04 +0000
Date: Thu, 13 Aug 2026 14:22:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
	geert@linux-m68k.org, daniel@thingy.jp,
	Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an3E-5BuWLgwzrd-@casper.infradead.org>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026081355-remold-sterility-84f9@gregkh>
X-Rspam-User: 
X-Stat-Signature: 9ukp7g669quf7z89z3zuojnixjwaqqzr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8942E180007
X-HE-Tag: 1786627327-970627
X-HE-Meta: U2FsdGVkX1+9LsDS+ND06ymotXusOScvqQa7RTzjk8jmIqBJNkpxQjLTOGtwBVS+g6O9cPC+BhXpO0GZmW+3UXfuQYIyHUMkM298JQnpWLrTd9ggPOOUrqIV8CwM3ALoVw3v26aFCMOLHPeVM4Mw5YPRRD0EI3oxk7ce8yK+fY3TmecH9if/hsTsmrDcJpkQRJxxTKBXGtBKGHSakpUzfNPjyyZbdkf46ol2RMytdYL3kVJIV3pVkDrY3S2Y92Xg7dl4H+mGMv+xXfJWMm/vyfPUL1UjlsAgQJaXrhCorFGNNs4kPw6DGXIgC+PvX8VA7HR+VZPekVS9HII9l1aXBcL2uX1jcKNqjGiKfwNFDigVrkUhREu7xQKu0frUbjQP+E7QlEd++IZ0ZqPBkyTEVbKI8EjaMn7EcYOCY+Zy6u6imBqZwW19T85+R34Gomt+i0aMDyP2RH0IWxuHNoZTrcchothNNibpREHjop5bQxUuCyoOlHaLybOGI5XcWjrFh1TzmVtZGje+uGNYG3xw6LpMlEk+igJYm+XHfJveGNPXprwhHOfI952OPn86zsJsDcgv0XgVnhKGjJ3GBGidKzUU6KO6IsKh5ax2j0xDXLcYcirvhJ7uSwetiRiyNJSo5jCRcn2xqieaGQY4Q0V+vzoeL8FngaoTO13NNO0/DqzB6q6JKCG3d2cOHbtplC9Y7ZOoNUNwBvuVAwaR6CEVvO8Xprh8x0YPEcauRZh7BT8LFawJ7U6c6w4vARnUEJ/Ha7aCV3jAr48iaewvFEO/R811c5gpudBpIU4Wct43x5sL6oxXcE0NTRWHcnzpXbJ1zH2A9/MZ37YYXKwbBnEp6rKSlgQhQjXpKmKmIMDNd52w0RTCJqPPm/ifjQAXwAU33kEG3ZxQTTNl44TSL6qFJWaCuE4c+405txkMt0HFI/JjhnMnh5EBA56IJpWwhaCxaQdok7hyjHUub8W+gNt
 jc6elKne
 wUPV9GQ1Um6oFlNUGo80YKPa5UJPD0n9w6oO2QHnevxPZuZfQsC5DGZdcAD1Qho/sqF02ZSb+wAj767U7feoulTx2fHz4Ktcbn/8iiIjkLe//ZtQvxTIXIKXe1xb6JFE7uYjrlXqZ2mgp+Uj9xVtB9LYIF5sjKhYvtRtJa0jniwibv09G1keGR4YgzG0tRCeNWbFk4I3z4RjF4Wz+ibN4X/C7Y0jhQLgmwCpK07we+mofF+QcYz2NtfsCWYls0jE5mZT/NnO+/QcjnKgvuUnmJ4APXaS3en8y3Sv0fMtvUriJZgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:19:47PM +0900, Greg Kroah-Hartman wrote:
> On Thu, Aug 13, 2026 at 03:33:58PM +0900, Hajime Tazaki wrote:
> > Upon a private file mapping request to /dev/zero, it calls
> > kernel_read() in do_mmap_private(), getting a failure with the message
> > like: "kernel reads not supported for file /dev/zero", which is because
> > zero_fops defined in drivers/char/mem.c has both .read and .read_iter
> > definitions.
> 
> Do you actually use a no-mmu system?

If you look at Hajime's contributions, you'll see they're far from an AI
slopper.

https://lore.kernel.org/linux-mm/?q=hajime+tazaki

> > @@ -869,7 +886,11 @@ static vm_flags_t determine_vm_flags(struct file *file,
> >  
> >  	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
> >  
> > -	if (!file) {
> > +	/* private and file mapping will be marked anonymous later (do_mmap_private()).
> > +	 * and /dev/zero is marked by them at .mmap_prepare,
> > +	 * which should be _before_ this point.
> > +	 */
> 
> Wrong coding style for the comment, which is very typical of
> LLM-generated stuff.  Always rewrite the output of these tools to
> actually be sane.

A lot of humans write comments like this too.  Indeed, it used to be
the preferred style for net/

