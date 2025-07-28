Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAA2C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530BA6B0088; Mon, 28 Jul 2025 13:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1776B0089; Mon, 28 Jul 2025 13:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F75A6B008A; Mon, 28 Jul 2025 13:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3032C6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:34:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D611058A19
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:34:32 +0000 (UTC)
X-FDA: 83714372784.09.182E7F0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3EFA82000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:34:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lfmn6Cqk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753724070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqDXWAxgebVs6SjAbN0f5M+jCa7IiTLdF4RA9QqoSVg=;
	b=jxQNfz8Q4bm+oznCGkChhrxiuH0Mi9tOvBk5pdM3l5D2I5HjOkl9F1LzUtkqLyiKt9wbqu
	nNWEZ8bJ2yHzxwOFvQWGI/ZlvePCHYfbLSG24MRSg2NAjAnAM11nobLmT4QgGSvyk3LnlQ
	LTe2DgVu9t38txVfq+fhk4xA86KzvIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753724071; a=rsa-sha256;
	cv=none;
	b=RDKUILf7ysrpMNYjTgAU8UeuHiiV/Ygd7S+2SeUEkuHFjoSSUFjxjrIFp4g96c80crwlSr
	L3Ywr75FEXBAxZH/sdGGgu8O1gK2G4+MypdWE+mw+mh+Au4Ijr6Y9fhKokZ4UlB+8rpFsf
	kNxfhF7mUBrmtAsKoQxF6xhOKnamI48=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lfmn6Cqk;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UqDXWAxgebVs6SjAbN0f5M+jCa7IiTLdF4RA9QqoSVg=; b=lfmn6CqkKhTXqOeyMQ1VarfYAP
	+btVaS1jPbtSnxWAdty5IIUiuM66govjO0Sho7Y5dOueCDjX+SJWeoUMPxnpt/2wNOBG5dB0ul1vZ
	k0spiHeceACX7KDWckEZiOpcS0Pkl0nNeQkYeiJ5uIIoc1YIY5j+RRMUll5+eO030vwbcfYsYlxS6
	UEyq5xgKSq+kG84qqFMi0Mi7+E44j42/OrE2WKnwF8iMnVH/yC+89p/iq40irvIkSHu3EZ92qipMX
	JU28Ggr9sfmYB0E1d5IHq1YV+65QDsyLmTOJH0as7gLtBGgQh9ES37Dc5aVTW+S4EQ27GhNFPBrzl
	XbO8XQNg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ugRk2-0000000FyPy-11wc;
	Mon, 28 Jul 2025 17:34:26 +0000
Date: Mon, 28 Jul 2025 18:34:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <liam.howlett@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c
 at fuse_iomap_writeback_range
Message-ID: <aIe0ouF9tsuIO58_@casper.infradead.org>
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs>
 <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs>
 <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
X-Stat-Signature: e69h4fzk49143i5qgy896p3wbwnm3zu4
X-Rspamd-Queue-Id: 3EFA82000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753724070-318810
X-HE-Meta: U2FsdGVkX19TnlOSPAuN48u0BphOC63WLatoYEa6twraRKmFMkfhmUqsBMK3JmYAC5SC9+QzPirCn9t13XpG6uYT0vgaJ2pWDKhwFae59aJJbmsYzIMTsAoHw7gehqJ5Zw0ds2/FHS7isyDsS80KWRIaYsym9mXNB2YAJA75RFG8xMmzVzMQefTC95K+squUIseSN6pDrDJo0Sdf1e2zvP2b7aYq2DZ5hCu7J6G+xeYclAtlnVZjlsACe36RPJyBbOCiIlFSfEcZ10hZT+LBwK6PeloFrVPNEHR0OtHyqVf/YH47veCqBo8qrEZ/yMnKupiGzpPFFFCM1onJGaylxAIL7wfcB7sM8JU86XzGs/0nQFY65VyH6nQdxXTLwkYy5jqoPTrUBFP7wd+RPsJ5ncCnjg18PqAUONYhNacsAUeU/JztFKYiyDVW6KD4DVFMj8b8CstnDihvftfZrjV68bnzvwnb2wCK5idoFfCLZP2Pfl9DaQY+lxE8/6hWZaMiKN56F3FoogSp7zBDxzoFutm6LgcBJ8vGXq0wBQcVmn6NrrXd1Oxl8gsALqo9Io+4YF3FhGgzjjGa5Bizz/M2WE+fnhd5iTBDdEpC941lFr3sEprCz+PU0oMtbODqJnMd3nytosyD8s2dgyXMrYgjK1w0pFrPdM7UyfdVxSaduZ2lzufCoyHAO1us3E9qOUf/vLWa2NWV4TPGBoXuiwfiOJZYua3pPoGeOWO5rdUC//OPWhGJRL/EqY3a+mKQJLODn7x+590VpxrOJm1JLlG12Y/OoXZdVZnLh9V/UfczuNKHXOomFvycL7L15Xj1c6MPBjR4ntx8U+GWphOJet2r+IXsh0dalt+D4/iQ5a6r/wxrCyX+kw/qbgsigsKDL01v8voq6KpMK1z3PD+cfwV/B78E7nT5x4OllT52FZdwNlqT550pzCXD2/6JbnnrUWoPWsrOJThpldHBRDHoPsY
 9T9kurSd
 P4njxRnnBouQmpCiPXpsmfcvbvTYi1CuchTh2qddGZnYm/Xi0WQ4q4/uP8M7qLZIh+WsFpA/lAkNU/CYsyLrJZescJvAEZLrQKDOjQPZwCrNqjzeQGDTMiHSIRqa7yejGTkpaSS6qViMMVRq+Wt9fDs/cOrYGpQNz91adpxhMs0D/aQNa+/b2T5alSpMool2j3kbWIOufPXL9VQKoQaTf99veD6xAGPni9HJlhu40dopE6No6ojdVISW/z8cXJe3+zUbm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> > > > > Also, I just noticed that apparently the blocksize can change
> > > > > dynamically for an inode in fuse through getattr replies from the
> > > > > server (see fuse_change_attributes_common()). This is a problem since
> > > > > the iomap uses inode->i_blkbits for reading/writing to the bitmap. I
> > > > > think we will have to cache the inode blkbits in the iomap_folio_state
> > > > > struct unfortunately :( I'll think about this some more and send out a
> > > > > patch for this.

Does this actually happen in practice, once you've started _using_ the
block device?  Rather than all this complicated stuff to invalidate the
page cache based on the fuse server telling us something, maybe just
declare the server to be misbehaving and shut the whole filesystem down?


