Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B997EF8FEA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9F56B00A0; Wed,  4 Mar 2026 08:40:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790066B009E; Wed,  4 Mar 2026 08:40:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654F86B00A1; Wed,  4 Mar 2026 08:40:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6526B009D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:40:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 224641B8328
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:40:40 +0000 (UTC)
X-FDA: 84508490640.08.0E9634F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id E510B40010;
	Wed,  4 Mar 2026 13:40:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=teznPaF7;
	spf=none (imf04.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpMjkqBNogxSPvE5B7hwtzwkc1kjwuxpixdO2LSAbyg=;
	b=rdhO0N588pcbpjb9n4a4gUdWFu8CcBm7TzwKFSL+jWqH14dSX6wJrLBkUxI5VKPmD3gzJG
	qAkiYqxQH5/z5i7EuxA/b9fBuHUvleQAv8GOZeHHHoIIRAax3oo2E9RRkLPdKTtcEweQkB
	uezbQcY/Ha8nQnzNSPVk2FTZDaYQrus=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=teznPaF7;
	spf=none (imf04.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631638; a=rsa-sha256;
	cv=none;
	b=eoX5Xfydw/SWUZCDh1hWlIvtKrDloJHoBPVpdGnTpXsvcV/fFkAKsvfcrNopRPK1i3F6O6
	fzinc/mssAxfigeI1wS0wWwptlWoMxPK4iB2b122mccnlKAhMUOMeuksiWwwi7HKIyEgxF
	+72ldcKBRsQIyB1L2ASZtOGM8LtFnHw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UpMjkqBNogxSPvE5B7hwtzwkc1kjwuxpixdO2LSAbyg=; b=teznPaF7Zol9XUlVmtkbdixlbj
	BGB56AhLKfWY9Cz+hlyK/SiVnKp62wmIciq1TfXQFK3eFHtabHDLKNQO0GqXac+YG8+R8BcmFAt8K
	cYAuvLkI/h0RYFbvWB03S5niI7jr1jteo6dXkwPe/R14U9EuFH+GJa45KPaMASqgAe98EAq0VK8Xi
	YyyYCH1nP6ks5seA8bZfAOTiODPxPZy/vA9q1sDq9Lr1OL9KaPoJwlI8OO9j9x33Z2lfM9YjsjoYr
	QiFjKMIvshsyvhmFha2IBILD2rNKcADZJIHENkohEcDKP4kwAxyx23jS2oLVsblAfaNcvNhAOhztq
	KNlz3OuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmSn-0000000HGUA-0qlh;
	Wed, 04 Mar 2026 13:40:33 +0000
Date: Wed, 4 Mar 2026 05:40:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/32] fs: Move metadata bhs tracking to a separate struct
Message-ID: <aag2URb_D0h--RKX@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-49-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-49-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: E510B40010
X-Rspamd-Server: rspam08
X-Stat-Signature: uoc5sgzgrtw7zsbfb85dhbudingbzb4b
X-HE-Tag: 1772631637-624899
X-HE-Meta: U2FsdGVkX1/QvSSLDUOC5aF7KZjnCvIBHq1ByStKxrbFmpmQ2x/wVdHO0foLmkoBr8Faq2zCmg9xMmxvLWO7jle/uk9hodyebLht6ITqhrecojxchqdxFF3HVp+fJRcaIEO+zb2wNojnR5KxojQ7LVxcu6QLPCYVLTtamrLqCBV6VgLONg+wvtgmZoQUzgp21SrnTywIxKLWYEL4FPeREfBa1zARaHMyIFqsFUjmX1kc0no+RJLt+RRNpYFQgNrMB9hCuUBngyUHyG3qzVdHoxVCzpzqTRIT67fFpqSsFzOVyRYG9eUib0KMq7e5G1j5U/akjfUIOfQdwDpapIFCQaOtA0KwQ7saXjc93+C03eVkr4krC9tYRY4vOrZiZhwUWb61v6vbXWM2N44o2uBgxw9GOUr0s9yND3TN0/iWk3p/PcCWGvvnHENjvEj9onCF3JjiTAfTjpg/S86lbSmJN7BGvtHRJJADoEW2by+0oXsjbHK+Yvzh9aD3B6aQ2L5Np4c3onYLGWkME1LaVwRIec29IY1d2vlIZU11+WfpFmthsK+zhTI08KAVlG95MN755JeMy7xjvNAgmEtZSppLLwbRT2XPy+9QO3HcBc9qKBLhOaKBtmYHBJyqtdMVPlagPk3KIm5w2pTRUwwiBao9YEFHKJoqHS2eE/fkpwiWFni4Q59CBeR2TOZVCMiPKyKu4DIWyTQ1/JAUZReqXABO1ts/NwA78YYtflbMBYPterk7b3moVQy2sM63GGq0UatMOtAjcNK1Sq9ea5UGtj372UWT+UmNtZlX8O7zf3u4KlJzvKvtayWwvj8MBBRcw+SMNHV6gPd8regX0qJKK8TV7EkteW43Ryk3eqacx8Xz5ianR3U/BUtKfjFGDpBIcjUUeNgqxTMczYK4psOAFzg2CrIRE6XcRujW9R39BSeFAFBHc/DGoMLOnpiN9V3z0kAL6Et2f7WTAF08RUgRnW3
 n2QPlls1
 6R24KhlomvE9GQc88X2dbyGPkjSdqBbR1ucfgnm9T6FzOyUyWUdDI1kkDDTPsEpYpvwtn0X/gtpF73LiLtaiE+/Tqt4ImUq6gk8kxmapSCAjPnTXFaBDodJhpSVTCBzDNf6by5xM6Eg99qslEd3xiKHO3GtN1x8KOR7DEwmC0PASmkDQvjA8Lb6NEsjBl1ukpKwq7DoD/KsjFO8OK8g12jJvA2/69qdDCWBFQOTWoiukcK0y0f5ANlM1CjDsRV2JAUXwlNI4UJSA+RYpwBJ7FTzXCuZLwS89GqJjH9ndrlbgB6Ch8rr2Y5EMtnetC8HMRclV880rv2W/IOi3rmFgUecpf/nVKHvN1jOVKx/VyLrzW9e3yrHjB00HAVPg6WFACdAGaK8lPERWWzdiNLWOi1qUR7AgiQxD5XD3aanEVKpZ3rG+3/Wi0vaf5rlaLDGJBYtfnxUVb8HZGtLaIZHca5ENrnm0Mssoifrjij+Jz41Yd1iPWWIf78n3eJfELbjTmGLEo/K3RtwY1RadhKBiqN8hNjRzBuV8BnahaBarcoOiQthVZKGpYVW/iuHud6kFXWAfLBXqkGf9qGlfb4dhvGy7IWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:06AM +0100, Jan Kara wrote:
> +static void remove_assoc_queue(struct buffer_head *bh)
> +{
> +	struct address_space *mapping;
> +	struct mapping_metadata_bhs *mmb;
> +
> +	/*
> +	 * The locking dance is ugly here. We need to acquire lock
> +	 * protecting metadata bh list while possibly racing with bh
> +	 * being removed from the list or moved to a different one.  We
> +	 * use RCU to pin mapping_metadata_bhs in memory to
> +	 * opportunistically acquire the lock and then recheck the bh
> +	 * didn't move under us.
> +	 */

Should the buffer_head simply have a pointer to the metadata bh list,
as that would avoid all this and keep a lot of the references to the
list self-contained?


