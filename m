Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03C1CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 04:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207D76B0005; Tue, 26 May 2026 00:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191D36B0088; Tue, 26 May 2026 00:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034926B008A; Tue, 26 May 2026 00:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF07E6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 00:12:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C2721C0172
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:12:36 +0000 (UTC)
X-FDA: 84808249512.15.5EBE02C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CFFCF4000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:12:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lNuGG/JC";
	spf=pass (imf01.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779768754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zolLXtUNuGgMGvntuicSbuzfsAN933tYyy3XaR95l44=;
	b=ll8T5ufMuKRp/fRMJAtqWiRs1EPndsdOHD8nimcLrXaOUESzKTDHUa6+FGGCyVioK8e8k8
	GBGHohPKVw65KTz7fXq+pq7/Tw5qAxzV0VU54MFM1xrC9h0OAuPNkQrANpoyBsAtut0dAJ
	8D1B5gsmerIk6Qs1y1fu+L4qqlp0D2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779768754; a=rsa-sha256;
	cv=none;
	b=hVBGRc0Ztsw67ncJ3YWd3cns0slqKOnNQ4HpcuIeTMu3ZJphxjzWeG/5n8M69Ykca5E43r
	lgAVLz9Oh9WcbR5nYzuegEb8JvYAeMoBvMLGb2QPwSzR9EOe7bCTgcDjHwcUiAgQDDLb/v
	4Q2JWz8rYG8WkFaf0Rysx3vsQqFLNmQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lNuGG/JC";
	spf=pass (imf01.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01FB2441AA;
	Tue, 26 May 2026 04:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E571F000E9;
	Tue, 26 May 2026 04:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779768753;
	bh=zolLXtUNuGgMGvntuicSbuzfsAN933tYyy3XaR95l44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lNuGG/JCaQFXm9DDXJufxSObLd3mxQYXUbJx58IGDqgyqXUXLdPw6Qum8nbATPHWY
	 5y2VYItqqlemNRDU4RYHDFJSue2sXB7QuSOk6n2bmNNK5t60yWIf2XVPU2xvz9XOqB
	 4tDOcHHdsg2zavU9J43B7Yf+uT1eeJgDZ5jMnzX/6kLtcAXzSv4gUknm8/CDjiFRtU
	 DbMMr04HINTanf9VBY8VWy2BPeuTqj+LeaBQhVBfYlXUceVNqK2M1f81lxUHFzgjIU
	 a2cniHjQE9QBikxhPJG6GvI7LUSdZmwi7xavsdN/6CaDs5RblpvPwwl+i3h6rFOHOs
	 WtFijc6Mq4nMg==
Date: Tue, 26 May 2026 04:12:32 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahUdsKSVV65qSvDm@google.com>
References: <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <8a42abed-8289-44ec-a144-dfe531a4af71@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a42abed-8289-44ec-a144-dfe531a4af71@infradead.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: 6gxuznfaeasxocuwab7gxpb8d96p93oa
X-Rspamd-Queue-Id: CFFCF4000E
X-Rspam-User: 
X-HE-Tag: 1779768754-473530
X-HE-Meta: U2FsdGVkX18kjZXJDbPOw06MmSRVP75mVXf+T02E/Y7WNS4brUXZAHyjpv1lVq2C+HmQ0Hmz73oo+mEi5dpCsiHNK1OKkXUp4YldgetBhd4/aN9YUJHvPdZSW0z3NYun9kOotJ3EX0UR8Wt5lbCJvId93A/9zyYtW8hnVFu4z4m6U1y5oqRirez9v8tT2FwVYHflml4S0cWNuLEyM1cWkinwjqog/1+4qSF0AO/OfJ8skkdyC9yihsAjyqd000G6p3zKBmuQg2i4rVystnE0tEGTiE/ZsQAV8k1shXWYUtrAvJaP+YKxcmApEeInjDfH26syt6KWzOK78IC4g36rqE2KnuMPviU9WvHcwSLuIVh6/dUEocpc013MbqO/EO0fo3QXhWwDZG/VM19RV0ED9uryQOHuRfHkdoo2JZnybo0V6DWYIjy4W/7KBoHOFDDfee4l60vQewbbKLYvxKSkhXM2GlFWkyBcxawD24eFRw7rHfgRdygQzgBIhshhi1W6a65cMIojtWn2cWlyT6Q2QXChKg1kI0mJLlrJ+4zWSJa+fD4puk2q43Xw5qVG2WaG63f8TVkUbCerUomZXG5pvOajpN1e5YQRf0YS4rZxSGFReGO9yg4nEa5h9myQLiqPyyn2VdFZ1ettmDB6uvpfk+PpeOzEv3N6z9WE4Km+Yqm+K1DBIMsxZDJHYHcNANd4jVipVLuUBQ7BFeYZOnTdtoo1DeekYMdzeTvXKZvz3pMfnGxJHiZGjwuAS2GAb0+BpU84BFYe1z9FtxLYFkZClKlgO4Y+mvqu0XmvfHp96pG3XeI0bxt5b+63Ta8JZzhTy+LcgP4MpiInIslZKF7jImOzGGd29sZMFWwgd+bHsT54fygyLp7+X+V8ifbWA7y3vNAZdmvheqAErpH41NeYfAkQokxbxJPjm1YjTQH4Ouqka8CT64gnC0Eo6jthXck3z/ZraBKUw7gDLJsm74t
 ec5Ib+4Q
 6blThX09jLiEAuH9aWdIGthy9SSNnBg2M7xzyrUnPm7STOieAqw4Hs9EHVdm1AsNhQsaqKz1jpY+YZAvpN8dGoIHN4mG1asaHPCBwOCFIDTHYVhGs4PginepB3VKRzN0wC6UYfUSZuwREDcKgIkhKl9Uz4nQ7OGVhO1Y0W0l0VFASot3Q6ENqhao6qMMSlNbDHGHun5SX+X5ef/Dj/z95BGE0CJ/m6q7ZWxM2M8LpeN9Ey9eyKwhA9N6UZZstIpZxfGk6wr0P5no5F5HFInByrwbBjkV4XwdADEx7CJ1Ro5eAg02zifsq363Q4CBdiCq1e+A3heHA37hIRlX6Wb4l411Njw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/25, Randy Dunlap wrote:
> 
> 
> On 5/25/26 6:10 PM, Jaegeuk Kim wrote:
> > On 05/22, Theodore Tso wrote:
> >> On Fri, May 22, 2026 at 05:08:41PM +0000, Jaegeuk Kim wrote:
> >>>
> >>> Thank you for the explanation. It seems I made a wrong assumption on the
> >>> usage of "user." prefix where each filesystem can support in different
> >>> ways.
> >>
> >> The "user." prefix is used by all userspace applications that wish to
> >> store extended attributes.  For example, user.mime_type,
> >> user.xdg.origin_url, user.charset, user.appache_handler, etc
> >>
> >> For more information, see:
> >>
> >>     https://www.freedesktop.org/wiki/CommonExtendedAttribute
> >>     https://wiki.archlinux.org/title/Extended_attributes
> >>
> >> I certainly assumed this was common knowledge across all file system
> >> maintainers, but this was apparently not true in your case.  I don't
> >> know how this could be the case given that f2fs implements extended
> >> attributes, and I would have thought you would have known that when
> >> testing that feature.
> >>
> >>> I shared some motivation when replying to Darrick's feedback [1], but yes,
> >>> it was not enough for all heads-up. The problem started that some speicific
> >>> application needs as many high-order pages as possible mostly for reads. So,
> >>> I thought we can turn on large folio on the specific files per hints. One way
> >>> for the hints was using immutable bit, but it turned out it's very hard to
> >>> manage disabling the bit whenever deleting the files. Along with limited
> >>> ioctl() and requiring inode eviction to manage large folio activation, I had
> >>> to implement this path.
> >>>
> >>> [1] https://lore.kernel.org/lkml/aeA5C8byIpXWla7f@google.com/
> >>
> >> Actually, you still haven't explained your use case, at least, not
> >> well enough for me to understand what you are trying to do.
> >>
> >> So an application wants a particular file to use as many high-order
> >> pages as possible.  Why?  What sort of guarantees do you need to
> >> provide?  What happens if they can't be provided?  What happens if a
> >> possibly malicious, or at least gready, application uses this
> >> interface to grab a lot of high-order pages?
> >>
> >> >From your patch:
> >>
> >> 1. setxattr(file, "user.fadvise", &value, sizeof(unsigned int), 0)
> >>  -> register the inode number for large folio
> >> 2. chmod(0400, file)
> >>  -> make Read-Only
> >> 3. open()
> >>  -> f2fs_iget() with large folio
> >> 4. open(WRITE), mkwrite on mmap, chmod(WRITE)
> >>  -> return error
> >> 5. iput() and open()
> >>  -> goto #3
> >> 6. unlink
> >>  -> deregister the inode number
> >>
> >> Why should making the file read-only matter?  And when you say
> >> "derigster the inode number", why should this be related to deleting
> >> the inode?
> >>
> >> This is an interface which seems to be very specific to your use case.
> >> What if those requirements change over time?  What if you want pull in
> >> a file without making it be read-only?  And what if you want to
> >> release the large-order pages without deleting the file?
> > 
> > Let me try to write more details, helped with Gemini.
> 
> [as an interested reader:]
> 
> If this idea is so good, why shouldn't it be done in the VFS/MM so that
> other filesystems could do the same thing instead of just in f2fs?

Thanks for the feedback. I'm really open, but just trying to understand it's
good or not. If it's so bad at all, I'd be really ready to drop it even the
ioctl approach, even though I already prepared its implementation.

>
> 
> -- 
> ~Randy
> 

