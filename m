Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E7ED10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA0E6B0032; Wed, 26 Nov 2025 11:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B3D6B007B; Wed, 26 Nov 2025 11:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19CB6B0089; Wed, 26 Nov 2025 11:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E17916B0032
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:06:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69FEC1606B6
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:06:28 +0000 (UTC)
X-FDA: 84153235656.03.8BC09BC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5361A40008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:06:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ceADUzeN;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764173186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WD2On646CAAU+DEqS7lMhdf/O5eBnONlES7TRzouurI=;
	b=eWvvt6g10rcGFl0l141Zpc7DtaGWhl+7+XiiaUQ1C9LN+BUlOFuJalJA6pDeeLw0HYep/S
	M/SP+Tb0Mos5JmInxlOKOo57Y6QTPXCy3qRDVNOm8IuM4Gih7fjU4Qe1StXtto44DI798/
	yLN7oAlN24IzZPzzTwMhjCBvD9wbUvo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ceADUzeN;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764173186; a=rsa-sha256;
	cv=none;
	b=IvCEijl+tlvdtSRU2tFElgKlE6uf0n5NTaTHKqiYNktb8qunVmbEh/dCbyLxNzKytmCTFI
	gaXZURVReIk4B1i6Ut45cyLbP6DYDr3kd912UYbV63jG4uLXhkDRoMZtp8X4vblI3kThJb
	F1Ese2y/m2mPB/IvpNlHlPhuS3jfhcA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WD2On646CAAU+DEqS7lMhdf/O5eBnONlES7TRzouurI=; b=ceADUzeNBk4SxAwb5qzlYOjtGM
	afvl8UklDf+N4GCJIn/F9z0AZXKQgXP96PW1rbt2F9MKEs8oSAQAJKGo+c9ClkTxypGHph87DJRgE
	tW3LRaMb9Vwf9qhJHp67xR/HB67UeB1Vg+nVlB1KS2SQ/SY24mIQzF0+FRncmsstag4LNV7LbeZpZ
	VkYEqFZ/tq1MJAfERXcf7l25g8TKWONVpTOojZcHmrAEcL5Hox9nUIWuAoOBek93QkAohOG5hdWEF
	xx7b0JgkBubr4wGZs2DtxjSsLk/U+ZOKMh4TyGimgwIA03DrGVkufqBmNaMprLzbmRI0BqWHwC2Vg
	lVdySwpA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOI29-0000000AM2R-3wTD;
	Wed, 26 Nov 2025 16:06:21 +0000
Date: Wed, 26 Nov 2025 16:06:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <aSclfZOU7hChCoM8@casper.infradead.org>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
 <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
 <058f5858-f508-40f8-adfe-e5de78621d64@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <058f5858-f508-40f8-adfe-e5de78621d64@suse.cz>
X-Stat-Signature: pcfn67erfujm3oj1rjwjxggbbj8e41ch
X-Rspam-User: 
X-Rspamd-Queue-Id: 5361A40008
X-Rspamd-Server: rspam09
X-HE-Tag: 1764173186-545542
X-HE-Meta: U2FsdGVkX1/dSvyUDGjYGI3eOKUiQG1h5Zl/QRx568HKcxtHyawkGrcL34mcYWgjRu0FE/YPxxE87nN7Kj15jcy/n2OYCOm5dpGsPait1bZlk6USvB2zMzbCezXPYHQH7Hp8S2xZD2VjNTylZR45GBnF8eMq4V8HTPcjzckIwLhg89hyJfHHEIo//8R9sNGHXuNY8BDnSMK/6N5QES7yah4crWUI4VJ05FUmfgcW4ZGm8nz5NYWFDJnP4Yj6HxucSW71Xv9Dr/Y3OFyWcRJHL2Ft0983YEjwymUcXe4Cq8RljtlRviUcPRsi7jx8H5QNpeI2R44KUerM6PJ3FdVbw1i0chg8IgsmtA8TQfAzRHB3cv2cMFId3vyMPrmOFdraqxvfSJDF4MkvBKNcbmU2ffUz4PR6IoVSfXhdewlxuIHsiWDdcLrf9P1ffJKQkys+SKoF+XmjmDQnjFdwFxUVbBJaROievErWxajz5uJPcC4MvhjZISlVv/9/jNK5ClEAYFq6/Fj13C/WBh+PYF0Q5ze1mLZUfaW8pNPC6fvya5ytI7yrtmb11J8HTUxxfU2c7EqchGWgrVnvZoxfTMqfiRBdPkJI8BWufehKfNr5x7txqir9NKSCq38VtNeyZUJLRCgw7+4olbmNfiBXKff2BtdNtmVl/rnQYswBPkw9DV7taYheBN2mj6ztYnhy4UkQpyLmXnbDiYMBkQJqqAm+5bVIy8cpRqgynLQAFgEuRSOezSIw/tqtWbiXAiXqZNoFtqgInv9l35sqA0LPXJvi03a+2Tphm9QSkrGZ93OnZXIhsyV/gR1WBg4NuTGbXxPdIQ4Sz/d5lbSwaNmJ6VHj4Q2GtuKploq0hvd4nwLVpZI+RiBStbx8ylfL4oOnmCK+pu4DhkU1WNoiBoF70bhJ5C2xA0deWX3qQjmnvnKmTGQgTln0PVBCGXqY1v//zfiCP/u07HOvIcKdF8KEy5P
 s99adrT+
 Eraeky+UoBCXXCr6mGJ8bZevzfdgTDOuMSrdCxaDQX/meAkiYCh3KyCJcgEMZgLl/0jo3HMZAWiC2uDErc+vLfc9IW3+eZdCKwkvcApDwXyoGIFwflw8DmD3mxHCbR3RV1GaD7RMmis+eltQuOMvt9WQO/QSVig4c6RxY2OWKuKaS22qvHv9bjzHdAFn3FLUJXy/DBSf2z3GKMcd0ScvfIvF2KmhEASbowzRlV9Zmco14CVwViXfp2G11xHgTPPCaDI+ypz060jYtVtw04ZDMVYC5lUUHZnr9lZxHFgwfikSLA/wLYYjXFO81ljUeVeZ7dhp7RBpm0+CK0u5UBDtwU/FiNU+aFZKMNqIJScHUs8ns/pL6qVHdFajGUHs0Ojit2OXFg/jjdl7PjeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 05:04:09PM +0100, Vlastimil Babka wrote:
> > [ process gets fatal signal ]
> > 
> > -> rcuwait_wait_event() errors out
> > -> oopsies need to do something, maybe [VM_]WARN_ON() not right?
> 
> AFAICS from vma_mark_detached() we use the TASK_UNINTERRUPTIBLE variant
> so this path can't error due to the fatal signal.

Well, today.  That's a nasty little landmine to leave for someone else
to stumble over in the future.


