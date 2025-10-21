Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BA1CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EDE8E0011; Tue, 21 Oct 2025 03:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427118E0002; Tue, 21 Oct 2025 03:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363968E0011; Tue, 21 Oct 2025 03:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 289588E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:44:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE3D51A03DC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:44:08 +0000 (UTC)
X-FDA: 84021332976.05.D23FD68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 153B518000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:44:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=SbYLDsBC;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032647; a=rsa-sha256;
	cv=none;
	b=g6MBhu/z1+a3jUd4LJ1+gXdM4PkHvAZ6ocZ8bX2T8hBwcKGEc6C0iaIwSv4JeEUgM/GN6z
	KowHDJjy26ng7vqjWDvOLnh5f9goVK+pXADXIZWiUemAqSSu7BgTDb/NQF/hkH+yq0gCm0
	lbsWwdJ4ZDQ09dWSrx1DkKe3nMvakfM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=SbYLDsBC;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hupht6IsYglzIwM6DM/LX/W9GWhT6SbnOPZZmh93+TE=;
	b=uvCNB1HT8Ds2G4y4i4egYQyBJaO2hDBLz2yD1JSGMMbgYmduRPxV8vuQGbOSYNscvnYnxb
	N6mh4iHPY9zE4ILvQRW/bQE+WABRAtQXwIfSBrXaTrr8zpfnVN//4mBf2+wjqvGNyxRD1a
	3QKWJS1D6mFbfYtWtfU/JnMxzGSlYKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4295E622CA;
	Tue, 21 Oct 2025 07:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0AFC4CEF1;
	Tue, 21 Oct 2025 07:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761032645;
	bh=VMczXjHiMMFNXVkIShw8MPqNOsA6McDHZHBD6eVjJ38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SbYLDsBCBxsgUOUSyOPz/19YEgyKAEWJEhKLS8zz7V8RujDKoQ1fbU/eYkXT2qoKd
	 snPOb3GiGXtM3//fVhez2HesiI7yRXP+/zPpdvKhwVZKpTOQIBblWnE5lcTMQvcSIv
	 sKm81tO8YLRs+1kjZ7J+IWfPX+KquM808y2vyexE=
Date: Tue, 21 Oct 2025 09:43:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: stable@vger.kernel.org, nagy@khwaternagy.com,
	Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hannes Reinecke <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.1 0/8] Backporting CVE-2025-38073 fix patch
Message-ID: <2025102111-stoppage-clergyman-f425@gregkh>
References: <20251021070353.96705-2-mngyadam@amazon.de>
 <2025102128-agent-handheld-30a6@gregkh>
 <lrkyqms5klnri.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lrkyqms5klnri.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
X-Stat-Signature: djit6pudz6wy8xpwpt3ogby5txc8tfj6
X-Rspamd-Queue-Id: 153B518000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761032646-910986
X-HE-Meta: U2FsdGVkX1+x+7SZA6107t9e7XOOYigwWYjnhs96Phq9OMqKItDJ79kY72Hm63up79mSVmDpYcFOPfH7AYyWKALWHzAyPioqDKmG9x5nq1pATPUtd9T/tdXwb6YOnIm3Fk0s6SnZLTtFQrzmJLr62sFtT46rCfRN6eYlRNsW31+0jKgEPug2CUqeuOKeWk7qbFb3gAfOhSJWmtmrJxWeMKpGcKSwq9L1a8RwA+LUCxrcvmUAFLEF3XfSzXjF21a/EaSqGxumSeA7VciSbLIoCYNQ7clEDJ2turWaUTVA4UwpWFRXqAZ/4Z4UVDqiE65v2qcL5MJvl58sGbXraaEseHPl9Qt5CliQ8zeTOW5s8xReBi5mmh4qxmIZyJV6iwboV3omz32lrsnaK3mEuIDEk4eoZekNVblGGijCLn04J6DxDiNmokI0V8gM5BSE4McOskDX+Qt1D4ImSXMIbCKulRioJiD6RGcmAv263lWSRSsUer73TIerPNdk92ICrRg9+OTbaPClSCrW0hivQ9p3zE/4QBE5SY1v45QlYjWaFuiKGaFyVqyROx48vQffQF09f8EbKNy1mKqf67MnuM6TT1Jms/dSJoXXka25YC9pBhEmaECzqGTt+0PzWgrSXgKOqdhOFoOQbGlaVGsxfNneYfJKyNXFy1aZ85S+bMayD/4pI5osY6ILY7SiypCsJHCa/zHa0OHpNY4uJ0m8mtEUwlZNlTt+qy9PvaUMPI+7pncpBoLeps+whoWKmovwAzLlyiKzu5G3L59XyuZ/44VCBhomPNjFKtDdk5vIW7X5ObhTgvU2L40sAfe3IcHF2Jy6iPAH3TO7TlHTXKb4RlwzMlNGoJEQr34OxLa/Q/zhm05vZe0eIWS82+qWcSFLraRg6Mpr3tJvsC78V6Ed6ber8knSnpSHF9ak7Y2v47y4oRiuk2uNlHaGHlekjIw7u48o+A+6b0Y7BfrTqaQKZY0
 +dDVZTCF
 ErDe3Iph+IF6m4TGXPAv+XaJ141KcRTyEkwIuYf5LUUUDVhZ+TyTgegXblo6lphm96gkje8olAvCkUklKHkkwyII+H6EKWkhbaQa/5BW4JlkDcpNh26pmJukzbxyupJbIir2nSWanCmRI9/uDHbPlrksRrJ/cXG3tIpaHVFjBqTvyQw6KMOCHwr/N9yGGenkhfSlQFh497HkzpkjS2JJJ0RVWQzR53WCVURStPIFud1igU2dh83KS8RvDmaiPl4/mxuysYVW1zGczSfOc6QYRSlW2BaJhOHnj8l+JpAdzCUSMOBfs7cRMVCWUruLPjmIbP94EhKczqW/aAPWnnRbOBR4psktZY0pkD5pHSyygiebDBH5frCOl6G8618+fMUpRhSEv9tXubO3sKWOrKSay6TxTf7p7iunPTwrSB9znLNLx41hdpXWNuM9sic3nXWHZR3E8o51y1nIgedqmgRskBcsulGsXHOUsbuXD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:25:37AM +0200, Mahmoud Nagy Adam wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> >
> >
> > On Tue, Oct 21, 2025 at 09:03:35AM +0200, Mahmoud Adam wrote:
> >> This series aims to fix the CVE-2025-38073 for 6.1 LTS.
> >
> > That's not going to work until there is a fix in the 6.6.y tree first.
> > You all know this quite well :(
> >
> > Please work on that tree first, and then move to older ones.
> >
> 
> Yup, I've already sent a series for 6.6 yesterday:
> https://lore.kernel.org/stable/20251020122541.7227-1-mngyadam@amazon.de/

Ah, totally missed that as it was "just" a single backport, my fault.

Thanks for this, I'll review this when I get a chance.  How was this
tested?

greg k-h

