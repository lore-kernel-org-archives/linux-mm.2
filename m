Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AC9CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A566B0093; Tue, 12 May 2026 03:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA456B0095; Tue, 12 May 2026 03:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D377E6B0096; Tue, 12 May 2026 03:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C757C6B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:23:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 723831A039D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:23:54 +0000 (UTC)
X-FDA: 84757928388.07.BAEB5FB
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id A720A40009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:23:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BU2y59SqFukqO7Luqv9lSeOSHObUdXJCRb74gvCvzQ8=;
	b=wwq8cAMgusGU28SU/oRXiEiGgVoBAQnbct0zQ1Vfrgu6uh3FHdBP6XI6SFMY1xtQ3P/+7E
	kYiANRme+9X14QKwiJ+swM3jP+q5bRmn1YAWcADg2Xc/A0sHXGO7ZR4ARhaO6PTzwjlwcU
	izDqEHX4Tkgy5fPJEWTdxtY0igPaq5U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570632; a=rsa-sha256;
	cv=none;
	b=rC4kTXEb5NbLqAPtKUJclQnr/Mkv9FJxXayNWHCOwLafOdiJ3PmvrPahE+M3Szp8FO3drT
	+wHCeEBgCRfmZt2biO8ws5sBqx6H6WzPBhRBdBOKUivqWQq74JfEWfVVkf06QvGkyavoW9
	y0+pfwEPTBh9EgPfUDU/z8TNfqFRY/E=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E305568BFE; Tue, 12 May 2026 09:23:47 +0200 (CEST)
Date: Tue, 12 May 2026 09:23:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
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
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 07/12] swap,block: limit swap file size to device size
Message-ID: <20260512072347.GA32756@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-8-hch@lst.de> <217f91d9-4d5f-47a6-ad20-0404968b8e08@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <217f91d9-4d5f-47a6-ad20-0404968b8e08@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: A720A40009
X-Rspamd-Server: rspam06
X-Stat-Signature: gs6ciq7nz6w3q6b8fmekretbpmuk7anc
X-HE-Tag: 1778570632-620628
X-HE-Meta: U2FsdGVkX18kOaNpzR+A/7T3U5r5XdsvXS5fc5lFvbbh6AjAzVT4UZnM5RPOlbBeFHssLE54VS5X+HQPcKiBknVlBf89dab6SEM7pHWdzoQonlwCLBPJjqxgJErenbcbon/ijIe08N13kHm7dM8g8/oHtj5Qgyc3HCVaAFb1Bl1vZBKtxHSZPLNBDeQ5xh8NjyIXcHhsAdOJB5OEyiu2d7q9TxDMSN+fcRdC0xTCFqq8hhbBI02dZcV12dhkVWPNvSri7Xv4qK9I0b46BEEABru3vNCJGTw0VHCfYSgeYplaabwI1fsRHz6f8ezxyeMSQ5hUS2oRFNfer6hVkv2A/0IBauuEQm7hXoEz/IljysD2FScCevHvRjHGRzqw/8USJYqqTd6wufY2JLoWQE16a7j7pv5j7gSIwS58SrSJTVOMz0+WvXyTlR6cgX53kBz5XL2GFMxILEOeG/a+wTr4g5imPYFDWN69PLjXYdYrkoOqTs4XmIdpEbb64CBNeGhNOYLYJNzi5/ehLjVtQGhlTTM1j4A5bboTknBsjZrqyYEi5h9J6ila/16BMDK02Zx4NmYXot+cWU6AN8iMsGhN9VaYDW/IfiPtPvbVZULyuAoY2D3sr2httqMR7MvbIV5R5cHAC0UpnoPw3SwFns0rCA1ft+Hxk5AMgiobqxxg9LWPO2okeWf+E+BOeimh5qj1yr2w9ZbXnKzfhK/lEFuLCfcIL+/6EZ8/vEYt0RArEuaNHMj8lx6s8OmyxcVeGWCIB2YSwAHAhAvzaLOWB+m564g4pn9XS+sVnvm6IfgvAWlzcmJ6dDhDQ7M2CtNMgkqOIJrvXMdpOLLhi1wsesgmfi6kBWhqPIkhClawjegkryX4QtEGbevpijS7mVnPwAUbx+9EtfiWBFEkYJKW/2QkO4w4mEPnNLt41dVUVlBuoS+FvovpjtnbXXrY5+eZBg3fQeA24/NsfYNLm5hh6qJ
 Erea208h
 jyfhFit3173LnE0tp9YDrfK5IbxB6oOFBNHDZKLlrTQB7zkCEQy5JXSengFqsq7ZCcz5XM4zpweWNqtvqjJrrZPvMd+EB8hNQJteSjQJX/dxRdmBq2dUTXRYRUP0NnlU+wjhVs9qU5aXAfgGJjde6EV3J7RN8eotJggpKczJqaXaHzohxTqSmKhQtJ3AigVhPS4tf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 04:21:47PM +0900, Damien Le Moal wrote:
> On 5/12/26 14:35, Christoph Hellwig wrote:
> > Don't blindly pass the value from the swap header to swap_add_extent,
> > but instead the device size rounded down to page granularity.  This
> > activated the sanity checking in the core code that catches a too large
> > value in the swap header.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks OK to me, though this maybe could be folded in the previous patch ?

I prefer to keep behavior changes as isolated as possible.


