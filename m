Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE82CCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE676B0092; Wed, 13 May 2026 01:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D036B0093; Wed, 13 May 2026 01:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282676B0095; Wed, 13 May 2026 01:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2136B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:56:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAD82C2645
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:56:28 +0000 (UTC)
X-FDA: 84761336856.08.A1487AB
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id D1B7D180006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:56:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778651787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v5TCj2cJ/ZZjo4hdIuBCz/5ReUhnh72x/ISsIQifvmo=;
	b=zkbleNYGqMKnNPymeZxXcIUR2pupX9H4ECs/g5HB10O3tVZxJg46zguL16B/JufmyX4+aG
	bO2McsRPFMnXImjNMBrBOS77DQnrijU2C2R0KOQ+PPnSc52750xyzCxVoeRPrHQY0iCm1K
	r+HYNGwrm2QH3MljGCMqcTr/Mh7b/uM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778651787; a=rsa-sha256;
	cv=none;
	b=cT07XNl8qslYhr+2rU9MsA+WEb4J4sADfEUA3TVCIDae963mDACwDrVEnhbd95azvMCdDp
	NXNKCQzaWmFSOtaCTrHpGAy9+HmPCCtwYaxMmOQ5nP+W8JPkEwinoWdjFhFZbUKB3S8+Bb
	Kzjar5gpwldobwGdS8L264amJaYb5yI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 693FC68BEB; Wed, 13 May 2026 07:56:22 +0200 (CEST)
Date: Wed, 13 May 2026 07:56:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
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
Subject: Re: [PATCH 05/12] swap: cleanup setup_swap_extents
Message-ID: <20260513055622.GA1236@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-6-hch@lst.de> <20260512164308.GF9555@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512164308.GF9555@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1B7D180006
X-Stat-Signature: brxoud819z8og659f5jwjrstp1as9sud
X-Rspam-User: 
X-HE-Tag: 1778651786-126611
X-HE-Meta: U2FsdGVkX19hRUq7qGi7zaUfmBP5xb/oQjrmadc0wQ7KvhOaZq2rKC6xcUemsWNixBdk5edDeomPPXV7uMvgHoP1itJ571pW3yl9lGdY+u5FnmkbPqJnf4VZoRtV6sZPmuqlfLDLuWXobQ6yu7RXZNIsia9e2okG5O6ZBs1xRbbdNiBMtn80LRyjkMCb1JneyXZWgLv9dOrIKL3Vx1ka0pyn/fsqPQjn4896fn/aNyQE9/SHpt9AvZ91FgPa460RN1X4St4rfDzFbuEfknLszdr1cipkqYtqatv/IuYZ1WH2unzqhcds63xt4jWrZmJi1HBa98LKkpVCkm0wjrE0VZqe1E7gMfUzNT12W65P9vO7ZRfsy8rr+MtxsJgni6YXGzx9w01+jgiLVLLDSsjY/AWvj6D68sqI+O4KH20AigR+Cm+bt1cAHTk0JeRAnFI4Yvw6ghyxTGhQfnyFQIvEUWn/dISPaxYS1Ipjm2hzW162g6YOQx5GOPtAzU19L0Gz5K540JOj7dOIp+PHmi77yB7wdR+ZRxwuJPGkq+3m2yJs1///uYvoouU1xLK9gsL6qY2oZKHEJGL6I0hMilTAJ+PVenTSJqLx+l1CQe3F29ohYkk4NpRmqEXYiEdQcRsYMrzZ3ttsLZcuuE1aymhTtyESLoGJplAMgkrYTO35Eb8VRAs5HaHGS1NlDy64orf3W5/hrP8DHFeJaRJx72MfKxPuWp5/NkwY7+lN8bQp794L4iwh7EsXROKugaCHEs1i8dv5+zAndUVXm8KcMcioBLExAEvsSkei6+pb8kynngYGQbQ7USQAWbNMCsHhm5Ggs4XUpwBai+vOnc3dXGMr2INC1Yr5D/jdHHWwagJ8vt4S7MLyIjviZX58L9R5ybDu5qmJKL5+UY2fRPMi2A+P8XmDLpTkq5KMABLqOaV5VL8Z4Pbozi1vi6JkdOQAM2HbdoTnv+f7A+KzxfCpZ7z
 Dje53fGw
 CZPKM7qMWTu1OOMynH2x5CtgHWSQwMNFillotdVzeRLH+XVE0KrJiI6rViuFOAo2chsrU+sqVgg6EJXru8H/Z8vz3g4wS17FJ19QPKsgOXaNIfN9qCbqFhExyAqj/vXi0UWWh5lpQs+y75SdHDB04LKs9f1AjbWOTFXxuOCA+TBMNrYR2aYGIcZS0zwtiKEjndcFybbqWWeq4b96GiPnrvRUZKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 09:43:08AM -0700, Darrick J. Wong wrote:
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 651c1b59ff9f..1b7fc03612f4 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2783,25 +2783,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
> >  {
> >  	struct address_space *mapping = swap_file->f_mapping;
> >  	struct inode *inode = mapping->host;
> > -	int ret;
> > +	int ret, error = 0;
> 
> /me wonders why not reuse ret instead of declaring a new variable?

Because when I wrote this, the setup methods could still return a
positive number of extents value that must not be clobbered.  Since
then I added patches before this that removed that, so we can use
the same ret variable.


