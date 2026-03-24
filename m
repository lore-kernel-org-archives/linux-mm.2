Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361BBF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DDFF6B00AE; Tue, 24 Mar 2026 01:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872896B00AD; Tue, 24 Mar 2026 01:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761B26B00A7; Tue, 24 Mar 2026 01:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9C46B00AD
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:47:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27B97BEEC9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:47:20 +0000 (UTC)
X-FDA: 84579873840.02.CE68D41
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5C19A0007;
	Tue, 24 Mar 2026 05:47:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qXjs9pPb;
	spf=none (imf25.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331238; a=rsa-sha256;
	cv=none;
	b=h3D5+EYwNZ0HAURGUyrhsDInW4GgHZURjQL8y6lfQA7ajL9lbdCDnEM+VM3NOYoxVeqsbK
	7YqWV8VdSBlpx+pwna6soq/2y1IV9m9FgigT9Hmv6sptnGOad163Tu/DVRjKHivzwwyy27
	dpt2XvgNYuzCOv1P5t/Bs0cKaFXHNu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6Vm/30+XKDDAsXGEh8YRVDUyTubbzFSvxa6tRmH3Js=;
	b=eG9DaLfo4doo4fLrrrhHXcnWdWGC+5aLwwvitwoOVJop75aYn45IfDLSIUrjkFJMnAWrbb
	udPoklsskV3nwnNfDMK9hYw+tBI72KdVmrCfYJIgzpW4aGa29B2p5rVG6226mE8gKmL9fw
	OnCMV+wzQvTqBZso06uGaRL6/kozUy8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qXjs9pPb;
	spf=none (imf25.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W6Vm/30+XKDDAsXGEh8YRVDUyTubbzFSvxa6tRmH3Js=; b=qXjs9pPbBv/4jA9h8OppKIk/xc
	i3rBSyqai4I69+ZVZ/O9dBhCLTH7+mKDTPi9dSH6pvx/XYujKmwZhz17uIoRJVclWXm23QotNoh8u
	cmPxRdlx+peIQLkIPS9hcEmvV8y3bhRiYLcghYLw3KpXZY674gGrJOl7vZTTEHlW1Rgdmq55Jtn72
	ibHv4o0hsW0B2MwNn9y7JtzQxmf9ebatCiKWkzYAeUSX+B9O0My/0olmVRKayq10T1d5Dp2N8zrCt
	DJIYhB+LXvALubHa3zmpmQboEFoSHW1yYSNZvqImxo/UoggUG3hsezpIor83vOR2+GzYnReTiFEnY
	WMjnuWEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ubh-00000000cNO-3Yci;
	Tue, 24 Mar 2026 05:47:13 +0000
Date: Mon, 23 Mar 2026 22:47:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 28/41] fs: Move metadata bhs tracking to a separate struct
Message-ID: <acIlYRiP41KCqsGM@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-69-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-69-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5C19A0007
X-Stat-Signature: woc9ym6r5qyyx63si6bxyxjwdxqtaj9e
X-HE-Tag: 1774331237-653356
X-HE-Meta: U2FsdGVkX19LBxlOzzVgEraZc0Xuqdkun+I5hNrsGZWARpVZAz9eMSoNBJJMsJi9zx6iVtik9B5rGl/uYWrYL8WBgpiL18iukCVtVwaB+XgdoNb6SvL3JhNd9YFqSXoBQ3DdX9stmDXPmFNaT6hhZL7dahAmXWHKo56YYmNGVwCiLWNl3VcEQWEG9vPVwr424rmPYKwDI1os7Mx/DHdUNmB9dPWlev3ENxplkRGGfX1/T4u3io/HlXSn66U6T1GjMTk8JAcDpXhwY8T5NAPgyJt/1ZY4m2g6ozBVjuGA9JfPug8opPb3CwjRztzqlYIqAvMl0CmV7aFwq70yd99CZGCzIHobTM3jy+jObUNvM1SFYVMR4ePZjheXunyA27LDxjUgr2jdnDMqZNXlmSRt+hQP8BGiegcaNPRM9xjwa3U2VqO0nciMrL/e2x2+aH+s95XbN2lwAAPZTrgkgueKAySzMoH952ABel2v0BqtmAxLz0GrlWcdmOTNSl69l1WNwnQr1etZz8MOPI2YYgJQ1zQa6Kta0z2C2TiAHrl6E4HGEG0igEYCIWAAqOhlWSh4CXay9+twuk0A7GM9+D86LW1oQrA+x+97+F9FyngFc/0FW0BJ2da55gPCO/zkJHkrY+mwwJ1ujuyrNOhOj1o3IN6f4HbUZBtecsLdVHPaA1PnTfBJxwTQPleej0d8pnDRhno3QJA54+DqLMZ7XrFC2ccZmy53HgvoHvU7T2WxO7JS8d9E1SAKRVneyqFmUPQ5ZmNCoSjUWUouKOlr/U8eme90E7MzzXl44Nl7nwF7OoOLo2fK6dcrPcrFQHvK5xtUAJv+mo6JF+l6aaCwamQSxc4KgbV9vShEAdx1iiJ4Y6G/Jppj1G6FZnIWVTOyVF8pqLzluvFc+9D5S4n/qLww7nkInhhpAG0ktk1tTRACqJnireBoGE7JWfsO4M8ABAkhZSCNh3wgnCNwYyCDQJS
 BlC3N/HY
 jZ/kNWlnkjd16/LqOESGqMV7CzJ7ZQMQBEUm2IERz3GqhtM02l3T1QmC1trUu5pa2NQg6GJvB6+XuxPJ1+se1qL64YmUmhYp0TVRfOjiQ9c50rFkFkw2iDxatw3reHk56ut8fhoObBY62JXB6gTVQSWNUPxQPo3+ZhcYLMo4O2kD423LJkf554MQTdsE9DoZ/f7uNll09llYx41otHRskpMV5VGK4YEWGUlsCylScjldTnZaATjVzTubTFlhRCL7bldQ69uLiGL4Gh9n2n8OchSAo+p2sK/wFPKAszjsYGL5w5eIUTP/gVHsqE0OkvJcI8YV/cQjxCJkpg1lucOqVGeLwtbWF/N1INbC3/J+MxuHmURGLn9eR9nmFiTjU6DcDQDjNBbkzdZy5rvVqLCqqfYafpyMtLii6czMOT4gZfqiKwGjZWbI64JAM/Usdsnh4dg5ZA5uBDw38zhq95ORQGKXcrJdVFeZPoLTZgZhkv4vGJ3sVvn8QfcLjtIH6AKzjRMKJj0/SGHr4lK0m6fa4tkDNY006uKFzV9d9YObvwr4dhypy/Mp5erUoCu5qWT1VLT/g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:41:23PM +0100, Jan Kara wrote:
> Instead of tracking metadata bhs for a mapping using i_private_list and
> i_private_lock we create a dedicated mapping_metadata_bhs struct for it.

s/we //g ?

> So far this struct is embedded in address_space but that will be
> switched for per-fs private inode parts later in the series. This also
> changes the locking from bdev mapping's i_private_lock to lock embedded

Instead of "to lock" I'd expect "to a new lock" or similar.

> +	/*
> +	 * The locking dance is ugly here. We need to acquire lock

s/lock/the lock/

> +	 * protecting metadata bh list while possibly racing with bh

"the metadata bh list" (or spell out the field name without the "the").

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

