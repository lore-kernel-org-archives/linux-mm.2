Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C59CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 05:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A831E6B0005; Mon, 18 May 2026 01:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A335A6B0088; Mon, 18 May 2026 01:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9494F6B008C; Mon, 18 May 2026 01:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8603C6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:30:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D859120786
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:30:02 +0000 (UTC)
X-FDA: 84779414244.05.14B4779
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31D31A0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:29:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779082200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l3typelnMP7vJAs/AWZuufzuUL9D+TpREvSuxzBiD4A=;
	b=2gXQEDGpswJ8BQguQKyBVgXDgTGlwBnPI+ifYdWVkiMQxI23r5yCic/dbDJTdufu23fL0Q
	IVw40q5x+dp9Wy0GfWdwmmu/piphESAuypDKbuFy3RHxf0FGoWsLR9Q13tWjFUot2ciI2e
	mjyDgq8teI2ie7PrXOX/smCtyoAj8yo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779082200; a=rsa-sha256;
	cv=none;
	b=XNifDMcpwGpyBpIjT9GQ3/OIMk6am/ixGMHm8eySs7hYOhKWGYhhB/cHFCIfgIvBuNC7rh
	PYEbOn/BLLPKMtmqmOzxJ6qHm2dtIv0XFHaJqjDypD9FA4/FIKi4pk9iUMNsSgibkPHmLA
	WX2hltIdoEgLRFNol418v0ihuNHb6aY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1EAAF68C4E; Mon, 18 May 2026 07:29:55 +0200 (CEST)
Date: Mon, 18 May 2026 07:29:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: improve the swap_activate interface
Message-ID: <20260518052954.GA9758@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <CACePvbUj0-fAd-gjRjxFXYz22hGQaT9upFL85KUqD=W=SWX+0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbUj0-fAd-gjRjxFXYz22hGQaT9upFL85KUqD=W=SWX+0Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31D31A0002
X-Stat-Signature: do7s9c3aeoihbwni7f779rowoym4kkqa
X-HE-Tag: 1779082199-787579
X-HE-Meta: U2FsdGVkX18intbxkxdRSbTYMNWHxWsnOaERN8U4a7NZyGHgsDJyp0gOaEbg6OVcKc9bJ6iOkHBfnS2a7EqDBD5t6V42WbWkXWxTrnefj+lXKRFb1hrnse/7XW4CF1tkHsUkF737J4BibpVMJx/Jvrko82SA2C6RldrQFercF7xESdXjgdcEicvbuRO2kyxSWh70QFe4PBrgE6F1Q/fC/6cXHn5J3Gh8y6wnLVNxf8eTRCc1gpvOd1gv0XFWlemu4rx0PxhEU4e0SbAgs0m01Q10Es/mAHIfJ5ZtDJkPSTzOmBNMWpexGvCO3ii+nhe1wdI8VuMU2btHdgx+ADPKA4X99NngEi9FMlP2SvKBt7nkVTP9pfXDD+7jb97DV6YiQU45lUoViW3+kyjGO0anqSkm6VrTpcD2yMBgTdeO5lTvAB/iwMDz6PMIB4ExcYqZlWfb5eLWSMpvPxUveterUEtiYWnvKAIhbtEK7koyHct9ktYI20duXFoSPG+qLH0fOFQr4pBe/0mar96p0+LryXCpv9HrwhQIqR2meZd2oXFxQMTGIm1OyHwvT6WJc359VS09Hu58VvQ49dBmci42e++bpWWPN0uVM7B6j2BkeHTym/ap/EuTLGjCek8wrskdGvFrzxj/p/xpwl5l0lnhVHgEqA8P4MWw3lmhweg0o0FHU58Qi753JXTKZMgBnNpS3n+SzsDNyBnlB7XocdUxVaaoxWTEYvMhFwqd6q22+q9++vm81vFeyJMvTrI91l9mEfNA8bFwY/YMdwN/JubF8Q5XR7R/V9hBmuwEG2vS+o9mIo475FDttQq0vBHl01BT8+OPfA5ZSPs9/r/weKKrXkQekKNpCF6Hl8qA0KVT/dZFT2k9dmE+fpnRBRVNZS+IiLZxuUHi590BgrFXLNkbBGSqh93rqOSHIda5MJ9Q7LxNbTiA12/PX0ZVH3TjX+MsRwf6srITpM14ONn1j55
 1HsXRp1v
 uIAePIWln/QkqpkBTk7v2uAGnh9vkPWZqrjDodbXqXVxMaWf0+nKGOvkSF+fnhP6b1KMZfXa1F7uWaEnmMcuxmYSKUaDAlf3DJMmUV+1fgDZRhjnuj2TcPNqERi+XOJTFu25Ok0hnr3b0nv05pUU2aQsfx+veGXNtdpWbsX+Th3A0sZ7D5IgnvoUPS6uGGtS9O7DyiyejdBcKBMqM45+hsHXpAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 02:40:09PM -0700, Chris Li wrote:
> BTW, I just tried it, this series conflicts with Kairui's swap table
> phase IV series. Might need to coordinate the merge order with Kairui.

Yes.  I think the swap table should be a priority.  Next would be
swap_ops (see my take on that from Friday) and then this series.  The
iomap-fuse work from Darrick seems to be a bit stalled on the fuse side,
so I hope he can wait a bit on this as well.  Especially as swapfile
support might not be the highest priority feature for that.


