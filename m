Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0724ECD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 23:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58286B0005; Sat, 16 May 2026 19:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09086B0088; Sat, 16 May 2026 19:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EA56B008C; Sat, 16 May 2026 19:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A39B46B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 19:07:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 397FE1C0339
	for <linux-mm@kvack.org>; Sat, 16 May 2026 23:07:13 +0000 (UTC)
X-FDA: 84774820746.07.CE577C9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4B33180004
	for <linux-mm@kvack.org>; Sat, 16 May 2026 23:07:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ryYtMULD;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778972831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fRmmYsKxngs2j8r5GGiootBnUnPKw9sKMgaHLCSBl4=;
	b=uEzsx6v6GmRhvEl7YHXFlOM02jJzfaRkJqSNE4vQ5PZ6OiC7V8tRyUz/qZGGWCtJ/bK64S
	jUIcdn94UxOSApkLapNM+mKFQylVPw2uvWwUzC69mYo0/NlN+CGTLxNwy+r5LopiCGmVwe
	jiuLS7xIK4TOorwbl+L8vtSWiAZwAnM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ryYtMULD;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778972831; a=rsa-sha256;
	cv=none;
	b=B6GbZjO1H0LVKYWdTiQ7ERREQR73Hi6LvROJ+hXhK1WOvrhPArpar3oQ4YGDIMNNofqiAS
	R2qiQBe9hW4vm6A96qYifLpPJ61ED4J9+fLdrA2fYSLpxfkOIi/0UxakkXwmeNN4u02QTE
	HKXEM6HTS5QvuP23L6eSyYGfFppCPCs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4fRmmYsKxngs2j8r5GGiootBnUnPKw9sKMgaHLCSBl4=; b=ryYtMULDZwbQs+GFCAfwBOEPaM
	Lob7cabWXt13wQzjh6qSjSSCVuthAadH8UeE/XKJUo4VkKXGtC1zEAUuZXPXBrvQ2F5APtt86fU10
	bloGX19doRG67ifJN4xM0yACmLuoxANePWuKlNqoy4Hj4CSKnlLhjAKIOaHwgLXjJ709m0UEmDGe+
	HXs+53WHSuzeaFFf2ucsFU8JPiAJhz/5GISHU5xVqc3K+RAgguo/uW9gDe5S5Td/voIxTixKg9QlU
	Cp8I523m9rASYVx16gEMXLzCF9XbkbxJAXNzdmMB1a4J9hiCrOr18DU/FrppKKUE+hd7r94r3JJ/D
	cpOw1f4w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOO65-00000003KaM-2J8E;
	Sat, 16 May 2026 23:07:05 +0000
Date: Sun, 17 May 2026 00:07:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <agj4mXKRVW44ZJ18@casper.infradead.org>
References: <20260516182126.530498-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516182126.530498-1-pfalcato@suse.de>
X-Stat-Signature: rh7nettpxyjztkxaudw9trztyaymfo81
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4B33180004
X-Rspam-User: 
X-HE-Tag: 1778972830-368329
X-HE-Meta: U2FsdGVkX1+HVy1ArQh0t/V88FVKV9q6601Hl3Kdap9jWtqf38ugAJCFD7xFggCUo7T2UdeWJNSB4L+bVOxhoM0q9bgZGDfM3Lx19MrJoTaDVbdqolcQvF7lt2+ZTpcFtIxn7tm1eLHK4azmK+/aTFntOsVK51ys7Cj12GVOv1gd1QEylrkpncygSIXVIDWp2ATFv+WVVz1i97YLvwOjoPhAX7How4AbdYFGY0ItTVzVXm27pbkSFqdtT4XlcTmDoHbmtHGjxkFEcocixQo0/eqqSzDpCGGdJmNTpxy3Z9/RfbwYqhau09GUSaPsQHqHs+eG+diWQJSyGvYIaGbjaIZJBDorfWoP9+OkdY3IT9MHWjPeRq7HJdkxpGnziD/gHLJyeWPgORKAHbN1jJDqvJgOJeToKk5XI+v3wJArnRahsRWOHjOSdjJ2UWn5sE7iu9pTX5tI2NrywPoBBQAkSKHHjKI/HU5wvOsdn0xV+u+ofU5C5nFJFSKqz8k7J/W6fbozC8+hWVoNvId08nef11ZXtno4UX5/Vc3vvSPdibYfsbzoH3hC/c/aBXdk+l7P3mMlOuxmntdh5WPVOBNMarp4/yMf4Ej/XE32+wBq4KMRQZnkaXujJG3e+MSppofmMTto2FIIqI7DmQZaXe6LeV8uSsYW/6WM9GUWKHPkuQNl4ufL9fKK0xw6vOdD1UuSVMztf6Gfr1oKeTbJ8vBuFxt0erqYjJUVEQDlBFXhFIGeBzcFVCN2v273LUsWG2ShmW1D4nW3Mu9bq2NwGK7QjVR2XUfQRxLKMgYFV8JAhIQ+DGlDwNbIiA1Av+PoUiXdHCAndk+wrJZKCffL+boQh3/Gxab6B3vihcYQXZbXq2ZLKGyWtOLd9ZAxnBjK6uB8j96I2OvKSMCCt3jROUVublodKtKsvEvw4P25E3dFvrQpYXM3ndQ2uxMfk9YOEUjmERPhb5Zz3zxgW4FIaeI
 7QOBNYpy
 ft+xNNrINzpTpdmgr3vocNor5oDLCgh+Mr/jQlv9ShbZP683arF5Z+VP9mTuMrft1cQxGaoAEeIUjV8panvr7Hx754Q9TkRUlUJkmz3xM505UPy3ml5D/HD5sZ3wi+cH6dkMnKy8SyXnD/+tCbBM0OuFRqcnqNZLT95e7RVtqJFLjnQASSBXhr8WNDrRxbVMFqiJ0/Jp1Ra0cvUEy3kXQ0EuebCcAidX4Us3v2mtHkoznFPuWGfcWKB9YotrnQWEUkfKgN1xhp/xpG93UugE/kq6ssQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 07:21:26PM +0100, Pedro Falcato wrote:
> +static bool may_write_to_page(struct page *page, struct address_space **plast)
> +{
> +	struct folio *folio = page_folio(page);
> +	struct address_space *mapping, *last = *plast;
> +	struct inode *inode;
> +	bool may = false;
> +
> +	if (!READ_ONCE(sysctl_splice_needs_write))
> +		return true;
> +	/*
> +	 * Always fine to write to anon folios.
> +	 */
> +	if (folio_test_anon(folio))
> +		return true;

What about KSM?  It's not something we've seen attacked yet, but it'd be
pretty nasty to be able to change a KSM page in another process.

I just got off a flight, so hopefully I'm semicoherent.

> +	mapping = READ_ONCE(folio->mapping);
> +	WARN_ON((unsigned long) mapping & FOLIO_MAPPING_FLAGS);
> +
> +	/* If it is the same (locklessly), then LGTM, proceed. */
> +	if (mapping == last)
> +		return true;
> +	/*
> +	 * Else we have to recheck with the folio lock held, for mapping
> +	 * stability. TODO: killable?

I wouldn't've thought that'd be necessary.  The folio can't be being
read because it's mapped, and we won't map a folio until it's uptodate.

> +	 */
> +	folio_lock(folio);
> +	mapping = folio_mapping(folio);

I think you're safe to just look at folio->mapping here.  You have a
refcount on the folio so it can't be freed, and I'm not sure there's a
way to transition from page cache folio to anon folio without taking a
trip through the page allocator.

> +	/* May have been truncated, etc */
> +	if (!mapping)
> +		goto out_lock;

typically we call this "out_unlock".

> +	inode = mapping->host;
> +	may = inode_owner_or_capable(&nop_mnt_idmap, inode) ||
> +	      inode_permission(&nop_mnt_idmap, inode, MAY_WRITE) == 0;
> +	if (likely(may))
> +		*plast = mapping;
> +out_lock:
> +	folio_unlock(folio);
> +	return may;
> +}

I don't have a problem with the idea, other than it's really sad we have
to do this.

