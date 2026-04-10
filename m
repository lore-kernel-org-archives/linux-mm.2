Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C2EF364DB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524F36B0089; Fri, 10 Apr 2026 07:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5BE6B008A; Fri, 10 Apr 2026 07:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBC16B0092; Fri, 10 Apr 2026 07:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A76A6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:08:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2B651604BB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:08:20 +0000 (UTC)
X-FDA: 84642372360.15.66B6018
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0BB544000C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:08:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=knWOB3VA;
	spf=none (imf17.hostedemail.com: domain of BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775819299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xk3li1I24xXhjUCjfH0QaipKwS9GLoq65H2d0oESdI8=;
	b=NXsUJNwjHTRk03z+DR9mCbBLyhQhGpo7CQ033O+gcaolTrK5cdgvXTH8uGpjJqwL6cdCio
	GI5S16we7sO81ZakqqX90w3rvEIcdvvBhooxKLA2faObfRlmvyJV9sidWKKq7xnBJS+bly
	5kmeduycI1xZNiIHHfV5sBarqyHGL0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775819299; a=rsa-sha256;
	cv=none;
	b=stoZou/lUDIfxt/oZwmbff84uEs/DXQmqp8+3+dl+Nbj/ci6lvD8pg8bzGRh6OMxTDnZc3
	/Hkp3gPGNVdOHtL4QkYGh9+RCw2Pt/s8i7hlscGu6zQ9OQXJsZrC4H1pwOKbRuBQl5ffBp
	V6PPlzHtKCxoYB3+X7ymWt0LzAJfvbY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=knWOB3VA;
	spf=none (imf17.hostedemail.com: domain of BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Xk3li1I24xXhjUCjfH0QaipKwS9GLoq65H2d0oESdI8=; b=knWOB3VAByYCcpkF0lENzRH+ip
	aVuP52BPDwBNuQU1+PdpEGH/ldK009CzPSvk4lJ56usBnn6Q0VM5vASn5ZD1XcsRCaViYFS0c8/Ha
	qbattmUm28AM+8E6/CqlHMZls9hRiZpCMyhvEpQKWvzSsZW3nF17zVYMn5oHrziyAzKbfmju37qZO
	O8MYZTwLVdLCIApCjzDAJ/eLj6Ri3D/BPckKbCuMQQ9GZPRDax9xQbAEDYRbQCeG0wBZ8v/vXFbhn
	Y/03kH+Ez0v5Ms4FAYkAhUGmZmCBNnR0nl4MUutiOf9IOAQHUK5cypEjM0/PGmxDRSovwOFFhhC+7
	ko9qzmoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wB9ig-0000000C3jL-3MIo;
	Fri, 10 Apr 2026 11:08:14 +0000
Date: Fri, 10 Apr 2026 04:08:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <adjaHn7RnvaMp7mc@infradead.org>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
 <20260409164834.GA3472346@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409164834.GA3472346@zen.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 0BB544000C
X-Stat-Signature: u8hkrhug6971k49ismm64tcf1mef1rzd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775819297-389247
X-HE-Meta: U2FsdGVkX1/RWeynQ/NRd043Ju+oxnUQ1juI7tTDFL1N1RVV534UOb1Ejwm3b3RUHK+8jf41dyCO1AS7N6C5Ta2lE538dRDxvgWOxpZ2td65L+1vxZt+w7XYP4gjg+o/iS8BeWeNvD+W4tY59/aFoIwQA0+FgioNhEeg5tArZ6D1djJ6hlQ4G2F12xqTFQrcoxml1JC7YHIg0SvHvgR8A/eBiRKVbseTpyq6K6t5AOiOX3HCxecw4TAkTf1WnzJ0rjMcLH5a4gaxkYLPOqrim/qlBveUl1MO+hHdSilJTH3KwW8mz0pwLkwplCBSrfiVl+hifJtaQTrYH6EFAoDvcpnh2xyxvR/s+yoL/uPZgCuExmIDVfyhn6by0jSZk94CuhD8s04yLfwryHDTtjNXJkUlp7ci0fOjyQ4uFlNPtfddnB4CEhSPznIcyrZpIfQaXh9GZFv1PvUHP2rSEbWMKwxILNY5ALzljWTKXhKN90Wwr8ZGlPUgEWa5dEy8OQax0lsbLL9Nvn49Yfv/0tDIqxHEP2T+DBEnPN+4pRNxcXAQddsS292kQEBcsnpbdteU+FwsBcWzejElWYoeOXypREFoNkPlaZPNneTN9O0zUluycY2nc6tB5Wn1ZBo8OTyVJBek4tP7JdrxuOVRhMa+8mbg2qtKA6uu1J7BGN/wLW7o8YwWeYmgkRCurY80Cw2itSEhoMzqQrjKVGpfa0BG5bokDhyhiBUxQZqRJPPruHeBKGpzBKAp4ceRegc04HjRsHixPBf7MKnIRkjBabCDdEC/MAHmbvAu0aVdFn0bavYNLkdklEqK3B3NEjVXA+ktqBYXdnDqaBFtfT2riL1es4Rq5uZ8Vc4KMoNI3CqXb7qjVeyVIk9XzEE5grOGg1XhHTg8DZyQpZDZA8IZp8mD0bENQH99/b8/z/xdpo974gABJcgcxF2lZnf31wNiI6Ym1uMQQiK4SQeQM2k6qke
 gcmmH4uh
 a1b5pD8zwYwQbK8NxCifYgR1UDj0pki3Lraqg5juo3HL7rCuB2BF1LPK2D+FF6h37I6IGJz6OuYm6tBzMY/KvpQv3n6RJbaeSs1iQLks91GEpMRi7sPWDy4eBRYZo5wQ0dhsqkeHST8Yw6Xh1ikFs/mvUlVh3HNQnDwzZlAgMVknn1fgZ1vjMOp3Z07ekyfxi8JyrkNcsUV3GER2mbEj/Ax8tB//lTPAOqTOCUVybv2E7X8mqODQRcaUVrpoit3Fy67eBI8sUgrrtw0wk662BuTakRFQ4PebZg/7Zdedyty9qbbpht6sE/IMKTw2VoOo11tKrt9Vi92Wg/Ua93gHegv17EyjP+8wRabYIIhtnNzhFaUWa26OaaUlsbyPMuVFrQ7raEkhyOEWLpo8HocimHfCcVq/3r06uxwS/JDHd77D1V8MtwdZ+3fkQtHxb4JSH8neuczziSYqSwDkh5XryeGyNkzvzkFcLh+/dzdqOaBqzh3H/BhSkUwjl5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 09:48:34AM -0700, Boris Burkov wrote:
> > > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > > and they can work on freeing memory needed for freeing of hard to reclaim
> > > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > > they should really be addressed.
> 
> One question that pops in my mind (which is similar to an issue you and
> Qu debugged with the btrfs metadata reclaim floor earlier this year) is:
> what if the hard to reclaim inodes are the *only* source of significant 
> reclaimable space?

(disk)space or memory?  If this about disk space, make sure your file
system ENOSPC handling triggers inode reclaim, XFS already does it.

If it is the only source of memory we just need to do the slow reclaim
to gain memory.  You better use mempools or similar to make it safe.


