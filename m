Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB17C606C982
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JAtowwJ2
Received: by kanga.kvack.org (Postfix)
	id E8CE96B05B0; Tue, 10 Nov 2026 16:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D1A6B05BA; Tue, 10 Nov 2026 16:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C236B05BB; Tue, 10 Nov 2026 16:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9DFF6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:59:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 570004012D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:59:15 +0000 (UTC)
X-FDA: 85420575870.13.D3D7048
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BB8C4160005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:59:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAtowwJ2;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJO94l84QK4bprsIuDcbPoluEQrXPtjS00pqy7xCAGM=;
	b=WBai53toQ0c2tTuAUgPYsaivRBgl1bGiy6H5sfz6bJzZc3uaTIOL5vEd8VjZiNqfHi7jc4
	6FWiQ31KmiT4X1j0qfgkISg+vL9ZElZB/NrGAZWlcL19Awl1t6bi+0W8c/l4dFsh/qkUMg
	K0hpCNsJCLD3+goMOzC3QPRNJTHyAPA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAtowwJ2;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347953;
	b=Ks0vg2b1PYIl/TII4idgUfpEpfOkyW3mAbrqqe976sZZNuUTv9U1/nj2QCPtM7QCSkoc9w
	M73pr7al26S5naPM38uhSrVddCnoeDKSl4KxJFhrs4ZZ2YpLx2dkUh7UAQ8wQMBs2FezJU
	FnH2FU3KBeLG6JoGqgh4roiwWRb1nwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 489CB60546;
	Tue, 10 Nov 2026 21:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D211F0089F;
	Tue, 10 Nov 2026 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347953;
	bh=ZJO94l84QK4bprsIuDcbPoluEQrXPtjS00pqy7xCAGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JAtowwJ2pPdCxaTBZjmKWNh5PkcnHC1a6JqF1BhyWgLEOzat739v+ux/OaqQKC+zo
	 AJRUFFRLkFiCTJvFNJCxS5fuoKKN/yiKzz5944+hRGW1Pk36p4YwmEI4B4ymNtaS/s
	 0LG9OFyRJ+uw3MFuCJ7mc5ieslXrWLACXId7HRo+lURTCYdpyQMb9AADbXSWAfDBpM
	 SKZvctyT4GvwnyYePshqwabyG10N3/JG245TfZxFrDfXyI4Y3nncp9K4Lquhu65ZhH
	 75DW9LUy9jNh6MqNcF4VarBImxcsrFW34Gyf42+1X63g6x7zu2D3TkBye2OXHVrX3u
	 H1oHCd7yuYlag==
Date: Tue, 10 Nov 2026 22:59:08 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, 
	tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 05/34] jfs: don't set SB_RDONLY after filesystem errors
Message-ID: <20261110-tasten-willst-denken-3168bf999f0d@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191224@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191224@kernel.org>
X-Stat-Signature: y9jfx1fus4r1uzrzthfon3dw73t6j1m1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BB8C4160005
X-HE-Tag: 1794347953-618786
X-HE-Meta: U2FsdGVkX1/xy322CJPAcqvHOYVtpJraQEMYLKSwpPnVG1K65bNZ6wWSggMAR7IsMsgrOCtWNDrs4ZvpBD0CsL/EyjCZEHqKHGAj/E1xa1uM1jsT+RYGx/VJxn3/oKCiKUMB5+5pBRyTOQcye8AAOc9DSdK/pQgxiN9N83l88RDIbmEq4QfGLVOG66yw3BAwHItC/QrEsXXPHsxXB72vSu/g/RuMfhJIJJx1rlFdbcoI0OT8uWK6344NeHFIzI2fJrhdU/gvKbeRoOMidXKlhnGwiEpZRSW+MFKM6LRAbCi2gTrxYBbfyv6JmtiLbRwSNLUtsubpXdhCQc0LIxaRfInzJTbehhZTMhiWSkIpmlhqyJQmECbOov3kG9l7tuo7JneKrZN31vekWVQpXbajUWMNnpXnAz3z00rzIQnojSksrbObsSDiy4Vrlt7hSAg4RFDqjq/tT0GDrdQUDAudzWftwg8HaM+XZHAcnJCYEXSDkw1Iz39KC6b8OGF59qSL7T30UbaW5UT5ItrHK+wWecZ41JX5YbKo3P3oGpj+hJ81LQBEgrmlu5eSnGuETqy7ps/QTaVBDW7LqPKoQYJwCwhDTOd9eYmhleLGYMUgP/tjoN9ifSFM16JG1YzeIreeZ0LsfIui3VBBRqRNFaeUl8ZxQWW7dJ3nZFE1Ci0tfyd8rnya8lOzGmpFWCEJ6iFUloZbzstWaApJfrY8FPTPlGSd1dEMA3N5dZ+onPG3grd+Q7rqJ4oBs4RmBBO/kYnAuPQZTRaQIdSGd7bJ2tM9R3oGggT0aGxQzQJdsBHYWFXSLXbGu63nXve8dnq2Zd0cbr6/UXBwdfs+07btj2pn6DwPb6/Fe0Sc3QZeZcr0pXVn6NM/3miM+qz6mR4rpWIQqnpZzA+WZUw81I6VEbLpuGwODug5ZsomeHhz8pIPc2zrksRDvIBbqcgesl/3HN0u/ogiorHvKpr7/LTMb+G
 V5Eeqdx3
 IJLMBL31IbZG1p6ObpTeg/Q/AT2zCjTN1FGnxO/ftM4R9/mfSGF6OSXjVbmmKF8GcntngdobD9NceH2ZRjHRz5doHrAZ1cE4qn8tXZKEcsSRewUEa/2gv9Z42sq98t01xuSGZTt705JP/9OPbbbMdClRfbWpbtIal4KTFEgyPfmb/1tt2K/VRUyzul663VItSt9V/RVTzfz4nhqcbgo3wGonOjb8Sl2lFRT8I8HJJuxX4a+8FS9k09A6k9hqGi/jOKdPkSv9bSBYYFHOYcTCkq6RBxTBwtmmWugL9NyJhGCzfavsD88R5oj/1+N17PE4E9wTjZY+BcPRGmKpTcWxt9bIYFd5gTtMGI31i6WBeSbDTLfq1hU8MX/5Fqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:09:51PM +0000, sashiko-bot@kernel.org wrote:
> With COMMIT_Dirty never set on ip (and jfs_freeze() skipping txQuiesce() once
> sb_emergency_ro() is set), could evicting the inode trigger
> BUG_ON(!list_empty(&ji->anon_inode_list)) in jfs_evict_inode()?

No for extAlloc(). dquot_free_block() in its failure path marks the
inode dirty and jfs_dirty_inode() sets COMMIT_Dirty because atlhead is
set by then. extRecord() doesn't mark the inode dirty on failure without
this patch either and it only runs for XAD_NOTRECORDED extents which
Linux never creates.

> sb_rdonly(sb) is still false, so won't jfs_extendfs() proceed on a filesystem
> that just entered emergency read-only mode during sync_filesystem(sb)?

Right, I'll check sb_emergency_ro() there too.

> What happens if userspace requests a read-write remount (for example, mount -o
> remount,rw) after a runtime filesystem error without having remounted
> read-only first?

It succeeds and the filesystem stays read-only. That's how ext4 behaves.

> won't updateSuper() take the JFS_NOINTEGRITY branch instead of returning early
> at sbi->state == FM_DIRTY, and overwrite the on-disk FM_DIRTY error state with
> FM_CLEAN?

Pre-existing.

> Wouldn't jfs_evict_inode() hit BUG_ON(!list_empty(&ji->anon_inode_list))
> because nothing commits the inode after jfs_reconfigure() sets SB_RDONLY?

No.

> If the filesystem was mounted with JFS_NOINTEGRITY and an error occurs while it
> is frozen, does calling updateSuper(sb, FM_MOUNT) in jfs_unfreeze() clobber the
> FM_DIRTY state?

Yes, I'll make jfs_unfreeze() record FM_DIRTY again in that state.

-- 

