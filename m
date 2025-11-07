Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 073A0CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654768E0012; Fri,  7 Nov 2025 07:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C1F8E0002; Fri,  7 Nov 2025 07:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591148E0012; Fri,  7 Nov 2025 07:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49BD98E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:07:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3B9313B056
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:07:48 +0000 (UTC)
X-FDA: 84083687016.03.ED1623C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 609B310000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:07:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762517267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4VB5pc/6C7hcNmqP2BZzyudOBnisuXTaZFHkoWQjdx0=;
	b=sU8GgeJXZa8uirT+KTs0L2+gBGI1ksLPQljFG40E97QCnjMmQEWaPwR4fgpi3dI8RemsjS
	xudXxipKttWoVzNbLD+tj5hGIj/XvTGgiL6yiEjkwwuN24Hj0QqLXMbe+1YptpoI7ebgIL
	ovFFYiPSm2BJalBhM08TU8Loi9MGQ7k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762517267; a=rsa-sha256;
	cv=none;
	b=SFXo4/iMOCqVD/vdGnaxfi3FP7fL2ApamXzXWjxI67C1IndRXxIooJSHif5n3Z1j0R/7ck
	lbHIQFCXsfVvvJX75Tg7AQ1dfYNYEWKbfxHEZFPtZEA/wMF6CdcMhL4pi4+0PiNgLh+rCF
	knCaydrTJUZ5Pti+dh31/diQbLdKLxc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 89D95227AAE; Fri,  7 Nov 2025 13:07:43 +0100 (CET)
Date: Fri, 7 Nov 2025 13:07:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/9] fscrypt: pass a real sector_t to
 fscrypt_zeroout_range_inline_crypt
Message-ID: <20251107120743.GD30551@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-5-hch@lst.de> <20251107035533.GB47797@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107035533.GB47797@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 609B310000E
X-Stat-Signature: gm1rwuojzxjqz8rae7jf1cwz1czz13nr
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762517267-75679
X-HE-Meta: U2FsdGVkX1900xQNS+/ZoX6KXYjm54YFV6Poox60g/OtFCYcZisnoUqHnXIrH/oBfLYY8EXnsY2ncDmXPiSGilCOEOzc8HXvn5PI/rFNPfZ/Z8QnF+a3CkYBocEs8NISokAmyztCCE6i0fK4d8S1KJ3QtwCOnT6kDlHE6XzcEL6FBml4ndozorsMjv2gk1MQWE/1myfYQfeAAz7qEZTlEBXQ/kr9aaJxR2xy4wjAimneWJsGKAJbY3HKXGDjR6BPxhpPb8/Ei6roTkbwFnWi89QdBpV+FuyTu63g85Wyl72mMq2tpxHUm+y/X10TFR3Srt41CP2DswSRoQ0JlxxipmkGJvUURvJif3LtOVkLViBIUm2ubdO9PJSBOq6K0PxCUUsO9/88cwX9lEjLpDyuwNehfWvi2Lyj3HGGWXbziSovRA9ybMcEzkAABSuiTl2fcp0FyUccdjnxjPvw/tOG3pQT4JNBgdnrwROjcSDg7Jo+PStdg543aPI2/3f6AGPUUNzl9q9Z/BAAG6vNApwM/6299buBlAK8gV0bWFEFdVpcIdHxhqDE+OH6p0YhgZqRrhe7vpj8xwk7c8XDBh6Phnr2TWQgdp23toWEKFswfO9QuO+lOuzam7N6dPWeVX7Gl90C+EZx28oA/tgiydud/OVamhpH60Jl1KwOhjVVX5NYRveiRr8JBaTlmCCLFVNOE+kNACd1UMok+EvCyc6cB7DOrMEqDLocP4IL8Sq+kV6i7jiyI2/vGcCPFDnS/O3gWveoS6MmTb5UFPbAhI8tDeJgGCSe2gl1lwjFrMf3tA9inkwWrzf6Iud9cQxd6rhhZvNPyI0M9h8eN8Ve5xcJLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 07:55:33PM -0800, Eric Biggers wrote:
> On Fri, Oct 31, 2025 at 10:34:34AM +0100, Christoph Hellwig wrote:
> > While the pblk argument to fscrypt_zeroout_range_inline_crypt is
> > declared as a sector_t it actually is interpreted as a logical block
> > size unit, which is highly unusual.  Switch to passing the 512 byte
> > units that sector_t is defined for.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/crypto/bio.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> Looks fine, though of course fscrypt_zeroout_range() itself still takes
> a 'sector_t pblk' argument.

Yes.  The argument conventions for fscrypt are a bit odd in general.  I
actually cleaned all this up for an earlier version, but decided to keep
it minimal for this version:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/fscrypt-experiments

I plan to bring the ext4/fscrypt cleanups in that branch back later.


