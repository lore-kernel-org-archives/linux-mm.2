Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55782606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HYCXuoie;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k6n/Kfux;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HYCXuoie;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k6n/Kfux
Received: by kanga.kvack.org (Postfix)
	id 712306B05B3; Fri,  6 Nov 2026 09:06:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C32A6B05B6; Fri,  6 Nov 2026 09:06:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2376B05B7; Fri,  6 Nov 2026 09:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 365206B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:06:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44FFC80461
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:06:36 +0000 (UTC)
X-FDA: 85404869592.19.CF6C48A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1C24340006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:06:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HYCXuoie;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k6n/Kfux";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HYCXuoie;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k6n/Kfux";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkNYkeNE70WPtaAN9DA9oFQKwNzrr37+/VHeOjZamN0=;
	b=6yy5cCFDB2s8kQdTSLHkyMRr3q1vtd6RYZitBUpALuXBe4FUhq5d1p8vQT27kMk5qUNqkL
	OzqrJIHRpgjzO+6f3+DJwKkBr5c/7UJLPRIkUPBVQ6mb+EaI39XaS3xB/BwX1ZBbFLcY33
	YPR2bC8qtIDDueX5fVkwVTQfzmAVOpA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HYCXuoie;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k6n/Kfux";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HYCXuoie;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k6n/Kfux";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973994;
	b=LKNiaI4zRUiSvlelrPYQxYClXa0PC7Iu5LfGvFUp+nhBroM3aWLNdSAehLnPXcbVX96uuk
	tFa+bwu+AlQp/269DCciB38ZT6saD8FKCHsBXzwPhIj4ycmNUuvU7JkYhJ4Gby0con7N2T
	zBgZWw72X9fEzwpW+QS9xI3MVLfP1Xw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5170C1F7F5;
	Fri,  6 Nov 2026 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793973991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkNYkeNE70WPtaAN9DA9oFQKwNzrr37+/VHeOjZamN0=;
	b=HYCXuoierL737OpwGTSBiFtCNZsGHglPQTMPO4xMGvCJEhpXHAfWCPkjEWr2Zt6zeucAuZ
	Aw4xlaalSlJRo6qbRgIiC3dhzTu20ZWsEdGWxzfIh2RaQfU3w05UqFuL8h3JeZirIKOt23
	I9wm5k70zac1ek2/yfQvV33IYc++MrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793973991;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkNYkeNE70WPtaAN9DA9oFQKwNzrr37+/VHeOjZamN0=;
	b=k6n/KfuxZ+6UVLlCllYhPpTvopJG2L2NtK31AQ3FXc0D8tanjreTzupE1aEZBil9oXPmfu
	i75D+RtwwwZauaCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793973991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkNYkeNE70WPtaAN9DA9oFQKwNzrr37+/VHeOjZamN0=;
	b=HYCXuoierL737OpwGTSBiFtCNZsGHglPQTMPO4xMGvCJEhpXHAfWCPkjEWr2Zt6zeucAuZ
	Aw4xlaalSlJRo6qbRgIiC3dhzTu20ZWsEdGWxzfIh2RaQfU3w05UqFuL8h3JeZirIKOt23
	I9wm5k70zac1ek2/yfQvV33IYc++MrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793973991;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkNYkeNE70WPtaAN9DA9oFQKwNzrr37+/VHeOjZamN0=;
	b=k6n/KfuxZ+6UVLlCllYhPpTvopJG2L2NtK31AQ3FXc0D8tanjreTzupE1aEZBil9oXPmfu
	i75D+RtwwwZauaCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14F53134E9;
	Fri,  6 Nov 2026 14:06:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JH6tL+Xe7WooXAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Nov 2026 14:06:29 +0000
Date: Fri, 6 Nov 2026 14:06:28 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
Message-ID: <au3bJel0YnSeowCq@pedro-suse.lan>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
 <au3C8lNElGg4LnR1@thinkstation>
 <254c6f0a-9353-4806-a5ab-a071cd59c64f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254c6f0a-9353-4806-a5ab-a071cd59c64f@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1C24340006
X-Stat-Signature: hcqyqfxcbs57yiptxo793osij87k7xke
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793973993-946696
X-HE-Meta: U2FsdGVkX19XtE3FFDdOR7WXJ9Nkz9UqhwgThF1jNf3lq/6wALUDpmlIA73KZZuQkhSkztX6HJvI69/Akws23QCj6ZAjoBlR4q/7HMZMOezAmcUxM18YcJOklll80Ch2simZOBaVuwCjsL5PXOuu47+VIZoNWEbg8H8yBuCeiCG7AaaekJRODQ+ujJcuz4Wmo6ZtELok+WuMKHCbqAMMQupCF30LfJRLYVANbDUgZefsdTqTha8DURcgNYdZg0zbe8+33IbwT9/aSt58m0nfS5dZb494rU6OlPKVvjuLZ9kxXQe2Idp28ZsgxCXZELo58zrUl5qPqRZd7KIEEMQag581n65Tvbhd80UlRBcV4n3ykYKcDzL2/I5TOPSsyL0VYRQ5vb6YEw8SB6XBAuEaEq0dnuGx4Ymu85Xg3u2dWObxY3yvtnhHbVtgIBkfOQWRXFgsVYFWxZ3vmpHCfOOFLDo8Eeh5QJKtAdJlMdkJR2LCbbuQOoSJOwZywokhvKr39ZEde9HRdgOXDpH8ji55ysOvEbvvy6i+dhFSggxrKmGgDHTgvvT0+UIlFpLSWmm9HbhIzaC9ZOHKQU4cthc7sVfYsmKiMfh+xVoLfD7dHyq9+5+Ibmw0a/55B/LTZHDSL6KtlUz9Sf4/Wf84Z0tLVxWKhpRGLeC1vvUtZx7a1C6ThHtgOJoNujlTmIdOZ2V/r6o7NE7+whSeJYWnVbJXfXY+X+3tVSelZsbWwDmv0es6ihjRkueskdbZr/44p7zSVToAaP1Rin/GxeP+bOndMO1fiElXuG4nXl2Wl3v6lYP4U+mBmvlcu6X5FNMRQ95IWuTox4hcsmZdL0Q6c1l6NCizEqfQ0arJedQSRisB0hn4wZxIwX0333g9te5JPq0vsV/ZIOyI2RV438U8S2ofEIhjbxbhuMqA7Qr98v+XLmvqD8Yvc7YOEjkSo4/U6W6+eyvgUXjL5GKBRRkYoRp
 rKzqC7MD
 hyAB8XUxRlNBAv7p7h4aD4t9GHhc5uhpVvepED5lC+RdRTjJIS+es9CM0PbvgplqBk53SAYplhP0muPV70OiL79/l1coMAy9tlGCyRYyxxcZ/TWnnULsVhsMS15BLMd3L4W9O3pDdUe3vuHsW81cgP8kQLepijVIHcf6F6WoHX9RN2gsQlokuONczuMvpQ6HD7+SOnjov+itMS0pCgZL8F4TETSWA9E7Urgmk+S3mNVFN7E27Wdk0HcdwVXOepTbWlTvkQReLx+BurN5wXeKCUw0Ww5ueC+ERQyL91MKogStn5ivSS1o+FjCrnJka9I9hlMycpSHXf6NKV9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 01:29:31PM +0100, David Hildenbrand (Arm) wrote:
> On 11/6/26 13:09, Kiryl Shutsemau wrote:
> > On Thu, Nov 05, 2026 at 07:16:44PM +0100, David Hildenbrand (Arm) wrote:
> >> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> >> uptodate. For example, shmem fallocate() can put such folios into the
> >> page cache.
> >>
> >> collapse_file() already refuses to proceed with folios that are not
> >> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> >> such folios, leaving handling to the page faults.
> >>
> >> Note that collapse_file() effectively clears shmem folios through
> >> shmem_get_folio(); let's keep this fix simple and simply let the page
> >> fault path deal with that.
> >>
> >> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> >> Reported-by: Chris Mason <mason@kernel.org>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > 
> > Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > 
> > Separately from this fix: nothing on the mapping side catches this.
> > Every caller checks uptodate on its own (next_uptodate_folio(),
> > filemap_fault(), shmem_get_folio()), and khugepaged was the one that
> > went straight from filemap_lock_folio() to do_set_pmd().
> > 
> > Should do_set_pmd() and set_pte_range() assert it? Something like
> > 
> >         VM_WARN_ON_ONCE_FOLIO(folio->mapping && !folio_test_anon(folio) &&
> >                               !folio_test_uptodate(folio), folio);
> 
> I think so. But looking at these hard-to-trigger but in the end very nasty
> problems, should we actually reject the operation and do a pr_warn_once() or
> something?
> 

Yes. FWIW, this is something that's been going through my mind. Our page table
manipulation APIs (and usage) are way too fragile and allow you to do the
most insane things without ever realizing it (e.g you can clear a pte, set
over a PTE, get-and-clear and discard the result, and do all of the above with
no locks held, set a pte for a folio that's not uptodate, set a pte for a folio
for which you don't have the lock, etc).

Some basic assertions (even if there's no easy way to back down from those)
would be nice, or ideally yes a rejection.

I would just add that these very much should be VM_WARN_ON_ONCE instead of
pr_warn_once(). pr_warn_once() will (AIUI) not be caught by fuzzers, at least
not as easily.

Also, if they're inexpensive enough, we might want to upgrade them to full
WARN_ON_ONCE().

-- 
Pedro

