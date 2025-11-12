Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1261BCD4842
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8548E0008; Wed, 12 Nov 2025 15:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BFF48E0006; Wed, 12 Nov 2025 15:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCD98E0008; Wed, 12 Nov 2025 15:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEA78E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:36:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 727D55A2B6
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:36:39 +0000 (UTC)
X-FDA: 84103113318.04.354077A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id CAF66140009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:36:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kp57rjur;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9o8NRvJdzTieC05I6sj+VphdIDRCWgXCmaEd+EQUzE=;
	b=EnWh2V627ykvacx9/8O8zjJLh6pTajVMM3KAdwqerO5R4r88M3DqldoLpF9g+Iw/9q3VAn
	S+wDszBsOOWVBN0q5369n4CDlMXKOIBiQNDdm5M0gHfENIEUbkqrt4InDy8kZGaONf+f6P
	JStruaRQo08WUqEOLXJjiMS0wMOplaA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kp57rjur;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979797; a=rsa-sha256;
	cv=none;
	b=5liVCMuPGBN54Kkdi1andTBFHBo8OPraRHCZCavpf5xQXMxBTEggcpYOVHp56teZlDS679
	PIlSBQzdkc73RoPPBf5jS9VX6hW5CCWwFz22NIZuRdSaiOace/xFb5+m3N5ZRl9/ftGE2c
	+pOJDd6loEX5+2uqie/r21VOGDAi5Fk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=s9o8NRvJdzTieC05I6sj+VphdIDRCWgXCmaEd+EQUzE=; b=kp57rjurHJAHd7F+xCvQZd2no/
	zldsm/PODHXAoZPRO03KjAvh+i6TFvDrouKIddaHozeoKX6h2p6XnR40qvkW2IfcfJjSqtjOOASHE
	pcLUkbSjzs9jrpSZ1b8HCTaxH2HZB+iIqy3JOelzm0XwDoUm+rsEL547/n1nbkk1Zdvdon9bDW7m/
	fbDrR+VT28Mw+bAffi2/e9rYJYquUsYKCdFL34XhsCio+W3x5wyTN9hfghxd3d7PyPKLuC/rsdqJN
	omr01SQUfqZXqu1vGLmq3jMm7SSbX5suEPyADu3Kw4ySsNlAUtR/0apBO+uhzbLc6bklHuhuBZo+/
	5LaH1Fjg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJHZx-00000006TTz-1U22;
	Wed, 12 Nov 2025 20:36:33 +0000
Date: Wed, 12 Nov 2025 20:36:33 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev,
	workflows@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/27] mm/ksw: Introduce KStackWatch debugging tool
Message-ID: <aRTv0eHfX0j8vJOW@casper.infradead.org>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
 <aRIh4pBs7KCDhQOp@casper.infradead.org>
 <aRLmGxKVvfl5N792@ndev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRLmGxKVvfl5N792@ndev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CAF66140009
X-Stat-Signature: 13f1p7bocznnp3665hkcf8cmmdac5gqi
X-Rspam-User: 
X-HE-Tag: 1762979796-653226
X-HE-Meta: U2FsdGVkX1+iY+30ExMsi79GaluE1XyhiQD74GMurwoRcv7qBXDq+GzdYBs31+yKR3lFXlzxS02FG+/2b7C88uoJGEL579+s+3pRk+p4Abf061HODz9Aaqq1/aGdDbZ1NcBGEbGKHvQPHzu1/RUPgbSk4baTjybToWGK1xuoH3s0aGik2j9ch/fLWMmiGj9VCSO9kh7zqHoiHK2t7GmKBLMPLaQ9DAQNTCQXbjPoV2/1GgdeSw8q39g3bVLQaLyPAXzjEp17gaJIVKUvJNNW2QiuPt18d8s4wbUxWUl4pEqAfihHwxOQeyHpOTXibMBX5ka77vrwFtnsWkuulv8jnTgIZiJiwyLwI7i4x+RwyBb+6oteu7LNqHvnq72VzFHQdgJJooQebzvrtdwDIP4dvkSrC25Gxh9sqbgygfk3VabICNn8dfC0Ret74xD122dilA5zdLaHMkmo02gXX0MM7Wd2+c6O6t0LgiltbgUedsJRGqaTJbJ9wSwBHLJFRG5Ru4HeTItbu5Ok+oi6eSJbkvHsDBoP4uHC64S2XGqVu5OjjsK/uTnKrCKzOoMtyncPDJmTzbgytlqVwaYcUSE+SSNRSt3UiAbLQGfoCa45KYOrkYx02DDWnekIF57aHDTb2YhnQbp+nN5QxrFdNx+qnWA9fYyb2VZmkGuS+9ldSl6TtgaG+ueEw1MBpi/SunWTNqTh/MhIP49GQhiCU9VDptz9BmpM7cZD1WVqlhE0BACEgzbfXQ7xocYAQM15aJ0vv9mMJcCBFGn2A+5cd5DRBP3dWDNJRmER7oNLBQyNEz35UWNw76Fk2iA0JpASikyzHLt/csFGZ9I1MdtAQTzDUn1evHaZhKdKA2icRfINAnXA+LzeXbI7+vQAE+4IzNay83YfZmgvi5hM/1o9d6/m3cTTp0diJ7YiI9xN2a1278oRIRWAmDI5LONjv42yg8E+UcYGwcuNf/wcAF24aNd
 kYxVDB2M
 1+5qhJVSlymjoWYz0Qm7BOAuRsB6A3eZgqRO6TPkBsxwr4Cdze4tVLjbcPbW3p3FfW5hoMEFS9ivmYKy3aLh37RKYPAkLa29gCQK/TMXsVmYKm1fPrLBn9xTBRwuDtcbtwBP/5EDbl7HZ/AKwRiNFaK6gXvpaMMgIgletrmJFjknFeFLu+IRSg9SVTrkcZAx9GVbZaCfJKRZz3lS0Ke4bjQX29LWqTuupQIElGG0WuBalJkAjq2x89gpkCrfuu1eu4dMNn6J9pyKzgj5mfSgvBhVeLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[dropping all the individual email addresses; leaving only the
mailing lists]

On Wed, Nov 12, 2025 at 10:14:29AM +0800, Jinchao Wang wrote:
> On Mon, Nov 10, 2025 at 05:33:22PM +0000, Matthew Wilcox wrote:
> > On Tue, Nov 11, 2025 at 12:35:55AM +0800, Jinchao Wang wrote:
> > > Earlier this year, I debugged a stack corruption panic that revealed the
> > > limitations of existing debugging tools. The bug persisted for 739 days
> > > before being fixed (CVE-2025-22036), and my reproduction scenario
> > > differed from the CVE report—highlighting how unpredictably these bugs
> > > manifest.
> > 
> > Well, this demonstrates the dangers of keeping this problem siloed
> > within your own exfat group.  The fix made in 1bb7ff4204b6 is wrong!
> > It was fixed properly in 7375f22495e7 which lists its Fixes: as
> > Linux-2.6.12-rc2, but that's simply the beginning of git history.
> > It's actually been there since v2.4.6.4 where it's documented as simply:
> > 
> >       - some subtle fs/buffer.c race conditions (Andrew Morton, me)
> > 
> > As far as I can tell the changes made in 1bb7ff4204b6 should be
> > reverted.
> 
> Thank you for the correction and the detailed history. I wasn't aware this
> dated back to v2.4.6.4. I'm not part of the exfat group; I simply
> encountered a bug that 1bb7ff4204b6 happened to resolve in my scenario.
> The timeline actually illustrates the exact problem KStackWatch addresses:
> a bug introduced in 2001, partially addressed in 2025, then properly fixed
> months later. The 24-year gap suggests these silent stack corruptions are
> extremely difficult to locate.

I think that's a misdiagnosis caused by not understanding the limited
circumstances in which the problem occurs.  To hit this problem, you
have to have a buffer_head allocated on the stack.  That doesn't happen
in many places:

fs/buffer.c:    struct buffer_head tmp = {
fs/direct-io.c: struct buffer_head map_bh = { 0, };
fs/ext2/super.c:        struct buffer_head tmp_bh;
fs/ext2/super.c:        struct buffer_head tmp_bh;
fs/ext4/mballoc-test.c: struct buffer_head bitmap_bh;
fs/ext4/mballoc-test.c: struct buffer_head gd_bh;
fs/gfs2/bmap.c: struct buffer_head bh;
fs/gfs2/bmap.c: struct buffer_head bh;
fs/isofs/inode.c:       struct buffer_head dummy;
fs/jfs/super.c: struct buffer_head tmp_bh;
fs/jfs/super.c: struct buffer_head tmp_bh;
fs/mpage.c:     struct buffer_head map_bh;
fs/mpage.c:     struct buffer_head map_bh;

It's far more common for buffer_heads to be allocated from slab and
attached to folios.  The other necessary condition to hit this problem
is that get_block() has to actually read the data from disk.  That's
not normal either!  Most filesystems just fill in the metadata about
the block and defer the actual read to when the data is wanted.  That's
the high-performance way to do it.

So our opportunity to catch this bug was highly limited by the fact that
we just don't run the codepaths that would allow it to trigger.

> > > Initially, I enabled KASAN, but the bug did not reproduce. Reviewing the
> > > code in __blk_flush_plug(), I found it difficult to trace all logic
> > > paths due to indirect function calls through function pointers.
> > 
> > So why is the solution here not simply to fix KASAN instead of this
> > giant patch series?
> 
> KASAN caught 7375f22495e7 because put_bh() accessed bh->b_count after
> wait_on_buffer() of another thread returned—the stack was invalid.
> In 1bb7ff4204b6 and my case, corruption occurred before the victim
> function of another thread returned. The stack remained valid to KASAN,
> so no warning triggered. This is timing-dependent, not a KASAN deficiency.

I agree that it's a narrow race window, but nevertheless KASAN did catch
it with ntfs and not with exfat.  The KASAN documentation states that
it can catch this kind of bug:

Generic KASAN supports finding bugs in all of slab, page_alloc, vmap, vmalloc,
stack, and global memory.

Software Tag-Based KASAN supports slab, page_alloc, vmalloc, and stack memory.

Hardware Tag-Based KASAN supports slab, page_alloc, and non-executable vmalloc
memory.

(hm, were you using hwkasan instead of swkasan, and that's why you
couldn't see it?)


