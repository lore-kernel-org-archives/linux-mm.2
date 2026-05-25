Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B28CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F916B0095; Mon, 25 May 2026 02:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40476B0096; Mon, 25 May 2026 02:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E6B6B0098; Mon, 25 May 2026 02:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C50466B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:08:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 981D0161781
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:08:33 +0000 (UTC)
X-FDA: 84804912906.01.B4EC43F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 141A51C000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:08:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=omAVCkbe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779689312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCg31p2xOKCKydn/P3nu+tddPYsDeLtUBR4m8q8r3Ng=;
	b=GEqoOMqgYfxbU3O7NfuCyh8wfoIZ7mxyw11jdgTE4zrqKHBOi0C2b72Cs4tpXjPktyO3t6
	VRFEWf0PiRCgubmm0xRhVDhBKPKxIs3ooe4pj+MUqb3SLDHsKmykYvV5uv6E4BZ82t+UfD
	2Y2W4F8PpWBttmRGKzVUdbnzD9NO35w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=omAVCkbe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779689312; a=rsa-sha256;
	cv=none;
	b=2UUjGhJwAW+Nm1tBmLzORKkF+nUahf0b9jph6BdCbNYR0kO6ctiCjRi/oDRdyc7ZASvCiO
	Ek3FFuOBeUNoc6hR8fT8G1THtJyjxwFqWYFHC7LpCd80J59CabSRhnm5cEzrZukKeuz/Au
	gtpty6QGHg34VFJUyDa7Z63f4I5Mf8A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mCg31p2xOKCKydn/P3nu+tddPYsDeLtUBR4m8q8r3Ng=; b=omAVCkbeVegfS/UW8xEIv4Ylhx
	UvfRBDpWwG6N3luMYv2OhkLkV9qF0hdpFJvl12Env24n4MZ6pPIZxiShTtOLq+Gy0xIKa9n1dHL51
	071kkDtCyoSJQuahR6eDXTIC0yWd/CYvn5jlT3MUpuh5QxExdiAaD8zLgaL61DJ+1KhHw8u0VbxaO
	8BBs3zvz1OLbN6lYcYEXe6CPpl00V5G/gcGOGxn0M3/J8HtQuGz4RTyBDYpY5lGYS4RK8Bm60GFn2
	2gJCqu1yEEC5UJa+zHK7nst0F/X2mu3vwKtU0UpwVr3nLQd0ehHELHyxa9J8ZBrTV/Pg+GJtV56j3
	wwgHiWmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wROUJ-0000000GO04-1423;
	Mon, 25 May 2026 06:08:31 +0000
Date: Sun, 24 May 2026 23:08:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Message-ID: <ahPnX-CwVgK-9chp@infradead.org>
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520-block-v1-1-6463dc2cf042@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 141A51C000A
X-Stat-Signature: 9na8rcfdhrintqbk3prbeswa3g4nz1zh
X-Rspam-User: 
X-HE-Tag: 1779689311-857395
X-HE-Meta: U2FsdGVkX1/ybpJ9RpUliFUlrzr/cRslN/upfe97QuGcVWNEBMhB2rdIwfrdcdf8tTTxkFT7OqNwlgZZDXO/O2m3ufIR455Ms+ObFVN6w4VzW5FaBBni8WYcctlH6UwUcITQ4A3IE9xnWZRJWX8DKDqIyDhQtUZeb/nHqJT/7V+cNpdSM5U30RU6ZYcWLCDaE1DanRGGjIUWzzVhxVOoUMig5mbFlskFcbqJTnr+qFRSR5VxcBZ8sb/afOs2LQarXa5Y/8iGHhQGq/hwF+XxMs/SqZ6nWu0EE3g109/S7YkYA1x/icmJANPiYGnCmXKkJAjii4mdAGGmROxuIwk0alXUFjRTC04tsW92sdi+mZtOin0om9+MaFKbkpd0xCB53mpE5a06h4o4qPmdhlikwTyFAwl5R9hZFUN9R2g4r4CHCfiB6D3iYSrXvEtbzKyuAC1QoNALaziTc4FfCmTmCHSE/MhNsuCQObnCjUaILjnBU/xC4TdARzB6LhDrt+D4eEh8JOzcxzjCEwiZ17B0u3I20XsjBYZqF4ViO1D7x2Mne3LfFVkWoHVG4xFBmnNOkPbGFXMWOf1t5HqnnYgrgUzKDVuFQt3e1qMbdj7s/ULbwbDIwLQ2frQ5+ePcKIhxJS0kCmdFIsg9vl7jCSRW//PvBT3Bd4abcv4Sy26mwUIIbPSIf7vIpG9TT8Ew/ySp4mAemWhLdwdJBU762QZOWfyu8qi6EuCH6qlliPNY2ml607n7JvMhbyODGv36SObQ7CxQCqyKa6GkqRNUthyYilbutBNFOMWdWU6l2ooyO1eRTfK4mjJ/4K/3eanMlQHsM3cy+h/fZJNpZAHvweZ/PJMVL4AI/zRU+FMXLAXvBfU5FCftThQREqJw+lHljMCzMjJsizmcEwi9Ou3Rm6Ho6+p9m+hsfBAcNHNet5X+ZkCTJRLE9Jv5JOa+hO6BqftzZpDQxM3g29qb0A1Z8UZ
 ge3gYWzV
 grj4Xl3+aQ+eLZ+PD8pjulRxDBEzSi51WFlNYy5CVwTqMuWXq0dJAUUDRZIgCvosSLyiuUX+FEBdj7RHlodCqS/XqBbDRUldVIxu3t09h/KL166IPsN/od18zW5QcIsnmh7A4Ga6Np0knozB3AVz9Zh1xaDB2cvbcvwT7SgPYC9mSjpvm67fHzw6+z9Ivrlq+c76GpDbU7xhI1djcdXYXxtD4YKmIV1OoimvS2PC343VeoMIoW95pjH2bDWek1nbyJUeXFvsFwHJlRWrHcCmXjjlw10Vg+yQ280mziNk66J81vb6BId3MiTzxIa0zyE4xALxbt+FTRJ0sj30R7P+Pylr8tiErzj8xqu59Zt/EMrmJWyApA3QV5irkltbbIVNe1BSH5yjtcU4RV8eVHQU2adc9Evshc2Cimeqw1F/rYkHZ8bGY0Pou84Quqt949xlTdmThU5iBRzQJODXlpVKKZ0hDwPmd9FZ4LfvM524O1liXvzBO8xmKK/1TNCCt3BJfwhNhmc1mLTnXREOi6mUHC3V1L+lORvRIBsqzxoVw/+D8tdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 11:15:52AM +0300, Mike Rapoport (Microsoft) wrote:
> check_partition() allocates a buffer to use as backing buffer for
> seq_buf.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().

So I heard various vague references that we should replace
__get_free_page with kmalloc, but nothing definitive.  Can you please
point to a good resource for that?


