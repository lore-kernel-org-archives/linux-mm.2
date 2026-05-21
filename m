Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B1FCD5BAA
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F18D6B0092; Thu, 21 May 2026 04:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9BF6B0093; Thu, 21 May 2026 04:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6066E6B0095; Thu, 21 May 2026 04:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 508536B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:51:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E6B51A04EE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:51:16 +0000 (UTC)
X-FDA: 84790807752.19.528D817
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 441741C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:51:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iTWlcAFV;
	spf=none (imf18.hostedemail.com: domain of BATV+e9ec8ca064152542cb28+8306+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9ec8ca064152542cb28+8306+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779353474; a=rsa-sha256;
	cv=none;
	b=VJhxxHhza56z2n+G9THs1Uvw7MUgoUVxH6RyICwBwpPPtKXp9GRkgV2XcNpnIe/Gfz1e7c
	UrsXFAEp5gaw0OpfqtdttmDrU9haEtE90kZYOvv0DICbgidqPPrIbl6wFK88Q7PszYG9ut
	8FzCblmP2LyktWSax//MI0HvkLoHv3E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iTWlcAFV;
	spf=none (imf18.hostedemail.com: domain of BATV+e9ec8ca064152542cb28+8306+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9ec8ca064152542cb28+8306+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779353474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adkD1i4uWAA/O/XCvNqvQRIx38qTQ9cyPCt8+vT2S5o=;
	b=rmw2XCzlwyEWUGwqGISaPsy4+RyNNRog9Zgu33bteLfwYXvbeG8L1dVBMEmYhyZie6yQq6
	dvkAMaCdbxfSy3r28uUxiL3JUmfAHFJTDXQiVawIJI3Na8kOrzVBsmGnIwtvbXzb3sgrGl
	YA8B1ZE23uUxfbhhu2/XgbaS6w6vf9g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=adkD1i4uWAA/O/XCvNqvQRIx38qTQ9cyPCt8+vT2S5o=; b=iTWlcAFV0bGroYj100cYzExpuz
	rsveboyudTm6JgzWG1IVCmUuLa8zzLxpbanYD8qxdzQYq8YiIeY2EruMxenhS8o1y4SfVtSpiGm6n
	XeSobI/z+GxYgJibYVSNh+LgT8nXyz2pe/NPNc62zXD7/tOAyWssVVQ2VUuwo96KR9jxicA3j1zE1
	6pPN4zVjPNKcXi+0GGucZo34eSB2hLyo53j4PKeNPV/FS6FHUbY6SH3ALTtS0KJtJaZCAb9HYgI6C
	eYOoMQNzCszV/wK+x2FRtUvCP4CA1j6cH6KjxIQZqYY9WNvnHgXL0K9rbYpRJxuBGRaIbOjIrpStg
	HiphiGQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPz7V-00000007D7o-04Ty;
	Thu, 21 May 2026 08:51:09 +0000
Date: Thu, 21 May 2026 01:51:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ag7HfNryTmQ-bVIS@infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad_HwhzlNPUEKQi6@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 441741C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: gxa3q61dx6s1uxgad4mxhybztjp98uwd
X-HE-Tag: 1779353473-495557
X-HE-Meta: U2FsdGVkX1/PwOgEopxv0nveAotVd+910KlT34qnThP/ahF27iv3hjre7uXg32PR3MKGSdTRDRLtxkFTRyUICLvCeH3EGuRit5pa/xU0VpEAlpUJGCXFflFl6VEx8Qw39tsIW44TZl69DXGJgO+LT/4czAoZ+VwC3qeoWyMPVufgX3JLaCec+sMcpiqJ54LkWIVyeW9XbSg55HzX4Oy7gH2s8QhzJo/KOgXfF97xNIXkw1Hw9nMHLgTun7nXglIezdHWNEvayjK7ulXMHaQlmIrXyqCTx0wmMkubHnXGs6OPUvpOxFOcbEDSlOmjm2Xm5bmK0bVZGbnZY6thz33SZy7G4Jh2CWm5GoD3g7i2+VAm39Nt2RnuFD3Ymgu3KewCUv5bUDpIEL7Tt1C211GfexH2KagZIX412is2idh3840kQ5dSf3s7W18R7ssp7SI3DsOwQ+z8MXV7CkB3Jau/AqTQsX96Rrmle3mhMiEzo6GUd5kcctnZgxcQMdN6gXJwVeGRCYBZoadJlMGjuD2kbyRFXFNvKGOm5VQgaRi+yZKpCce6q1NhOqwI8E+3lGWyIwSui+dsf4VFs6WLtp8hwcJwTqQk+p+gRCiQbw9NWz2M0P/Q4VTDIsI5BT0e//fW6850DenB1e9bfC1D2ezrcelJJJ7iljUbBgNaRjThAz4QlGr3M1UAnPL5b/CKZrP4jr1Wcb7+8O7DiIgRHyehJzi+oFGkSQOP98XrCPVvSg+WwKnr74FxN14VSQ0c8bEBTg+o7sbEMt1D9X4dfJMV3s38pUR7w4fTp/Dlib+vJmIB5aoJeYmpk5uhe3VoJ61UJbS3DoCUF5biWByoZG/b9s/yy2PjRFbvfcNPfqA0CfABaEYSl4zwCL+Me0a7bHukXN24zJI3+YX0IkCbfidtEYNNgb9esUuVEQXxIczpcP8yiehEfNh4WQJZZFb6s19sLed/REhP7p/vWouQ5Wj
 lCcRUg8d
 qheNpaPhLGYkREoRlRlDorUTklpD3tZpsZ9CCIS5r2rCK1N7wVqvar002K1dgzAb2WzNkBuhQU04t+anUzIAihbVtW/l5biwOe/OBe2JjVJcvdfYHIE6B6coxtomhMrwABVEWbhEMlfgFVr1TfDIsgd0nWCJGAn9stJu7Nq3y7t6QFMf6zDlKSAqJdsmZhPyTh85Td2idce1tOyB3CBP8Oifs/kjN8F+bXBlqSVuC5H6xcnR8+8zXD0nH4Zvt86xfimbHyPNKoRhSXBztvEBq0pqFqCJyPGpyqMotYIuuFh52F8OFA9+M/OVOhy7anjHWJYNNSpuN44E6Tkc/tznuNrPDQa2AWQMsd4Y7FRDgR1+F9LmE4dBUxGaoDBb6mRnxqSjRCZAjsS0THRK+A2XxbbfGTwkwO6H4FXqj0o9hxzVdLIL/zu9Unq6U8lnFeldzFZ7IhFnziUKjI77o4cvcPYW5ePp9cj2iHVaw9czlD59JnyF9JE2DZJOsjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 06:15:46PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 15, 2026 at 04:44:04PM +0000, Jaegeuk Kim wrote:
> > On 04/14, Christoph Hellwig wrote:
> > > Please add the relevant mailing lists when adding new user interfaces.
> > > 
> > > And I'm not sure hacks working around the proper large folio
> > > implementation are something that should be merged upstream.
> > 
> > Cc'ed linux-api and linux-fsdevel onto the patch thread with a proposal that
> > I'm not sure it's acceptable or not. 
> 
> You haven't sent a proposal.  This is a reply to a reply to a reply of a
> patch.  There's no justification for why f2fs is so special that it
> needs this.  What the hell is going on?  You know this is not the way to
> get code merged into Linux.

None of this got properly answers, and this broken interface now landed
in linux-next. IT is offloading a user.* xattr which is free-form
user data with semantics that are weird to say it very nicely.

All this was done against the advice in the mailing list discussion.

I think at some point we just need to stop taking f2fs updates likes
this.

