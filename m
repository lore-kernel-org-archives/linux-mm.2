Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F70E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 17:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6376B0088; Wed, 18 Feb 2026 12:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753ED6B0089; Wed, 18 Feb 2026 12:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635B66B008A; Wed, 18 Feb 2026 12:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F07C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:42:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A15D1571A7
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:42:24 +0000 (UTC)
X-FDA: 84458296608.14.C3663E2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6710C40008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:42:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PxaekDEg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ch1fLl53;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PxaekDEg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ch1fLl53;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771436542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=fUcWOTBmCqaGN50vZ1YFo/399GBWJMvq3eY78q0ZwQjgund64Bzx9v3DwFprzGdiGFKsxZ
	2elT1AJygblGSa+vR5Se8G7z0EgJpnmJsDNBjSwdOfN34r+Z/RKl8H5OWCWur3D7kC1gfs
	VvBJu9NPqnlhVO0otFLF4NYNZXp5JnI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PxaekDEg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ch1fLl53;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PxaekDEg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ch1fLl53;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771436542; a=rsa-sha256;
	cv=none;
	b=5KFQRVfaiIMx6rMgdmiKIrfj8lWxk8rO2gvQLjltPHmuGxIxQYHVmCX7jTy4fbd7TmA12S
	Sd3g3Pb/+ygAjYYBfCy3RSexOam5bjYFKAUkCMIxgBkY1f98EwKS/qGqpnQX1I5/TBxFu8
	OEYT5vULs87WECQiYPJjjGj3GZiLGzI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD9683E6D4;
	Wed, 18 Feb 2026 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771436540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=PxaekDEgryjgjhp7gu9pnwHOKrO1w+Ild6EkoruNjPFB9xcrTFRJHcpg4wM1iMrrwV9nL9
	+p0KTwTezVzUVsoU5P3776MvLd2UhU6GppBO19aXfEYGXEI4YmjE98DOMZwqZXE+v29yqa
	OocbOqqZx2qsYHRjfOgH9QO7hDMuz20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771436540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=Ch1fLl53jWDItA/wsG5VC6xmr8thrkEqqKnsTtBDCAFDTy5xXH1KMWTVFMiY+uWnyLcXY1
	EDZBrO7fKy55OdAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771436540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=PxaekDEgryjgjhp7gu9pnwHOKrO1w+Ild6EkoruNjPFB9xcrTFRJHcpg4wM1iMrrwV9nL9
	+p0KTwTezVzUVsoU5P3776MvLd2UhU6GppBO19aXfEYGXEI4YmjE98DOMZwqZXE+v29yqa
	OocbOqqZx2qsYHRjfOgH9QO7hDMuz20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771436540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=Ch1fLl53jWDItA/wsG5VC6xmr8thrkEqqKnsTtBDCAFDTy5xXH1KMWTVFMiY+uWnyLcXY1
	EDZBrO7fKy55OdAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7FA83EA65;
	Wed, 18 Feb 2026 17:42:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H2z8KPz5lWnlbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Feb 2026 17:42:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6949BA08CF; Wed, 18 Feb 2026 18:42:05 +0100 (CET)
Date: Wed, 18 Feb 2026 18:42:05 +0100
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <bf6eek2jagskkgu3isixqjjg3ftrkp5juf6lge3rjjutzzhbdd@vkliyqpsmrry>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <aZSjUWBkUFeJNEL6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZSjUWBkUFeJNEL6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Stat-Signature: wmr6pg9ed5sqkfc9wsnjz1ionb1d96ji
X-Rspam-User: 
X-Rspamd-Queue-Id: 6710C40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1771436542-581406
X-HE-Meta: U2FsdGVkX1/b1XlKKvaFa9iWr0ioSsKHXh+1RvFoXZjpYXyTeaXvN4Khi8k7EEqUzXdqFVetJbtsH5waZ3t1afncTVzPxY/U4XlJ0D5YwjUQRATIyV2L0Ti7UPJTF0jNYU54kiDLGqmarWiUCS1OekV9txOCta33c5ixEMXiTj8lDE9meke/n00B0zrpfqktcpYykXn+T7wOZuDDtNad/XNQMjYr168d842evpbRZKakdzYIwGbeLEqgMRWr02ckW+dRxQzUzXxtr7MrxjzCXUrHAEdBIj21Nwh53Dw0ePQZ2Ws9NQjrRn8oUncCJLJyVMMCddp3ifSJFAiDeSZU3bY/L+TkfoiNqNC/jrOUXTI7wDGRDEyja5HIn0L5pdCzuPnVSuVBE4PCSDGmn9Gt4PzWPQfnPAmjyeIpRl63yBT72yBEvYQMiw640+VPH/q/u3dFwph9er41wiEddYnZgRgNQXTygPq2bHG12LYIsjlb7zb/GToBv8HWFnYbToIP1pej0HMmM1NwPOvwuA/iN0es+ewEERKy5Y1KSmuewbODyVonE+/b090Vynbf43WzmoHDeABydaMu/PDXxiq8zzVFyzwZyefQZ0+5c0HbFX2cx0pdeiWvBi37mFsbs81QW/8BYhc133Gl3lrQ5wbMTiy3Q0LXToqIkSYJegVVS7A/+uNNquOzA50a7y8ISZzF7kVIRxSIL9+nJcuQ5ylYplFpRmBh0v0e2q+2gnRDUgS/ZgpNsyIjmO/x+wMV7eg/uTdld0jizE1MVM2beri1PXt86/1TPkdWiZMDchUK9H5VzelwRPmH5EgQymDSSdNXSKQoaJI2WyLlBhk+zL9e5N8wjMVtFdcUB3JYEk61qNKMId2AA/m8ho9zyBjfZxP+QtszY8U9c1ri/bjCnnTH9ifHIbS+pUGleNmKPoM3rsw3bqWZJIjH5/rUQSe0FViH/6EXJDd/gFVTHRwh9Yi
 9BD2KtEn
 7HiZ5SVC0n7XAof6uQqqhhNRYfIi4wzGdkB3KvjsBtpxLdGEiGhzgeTmZRcM0dSNyKjM5NuSbH7RZtUWS1cCcsblt691II8dJW0p0len262rwxFanQBdBwqsYgwHspv8rEh4m1k9OQ6UuzGB9Xgj+eEXuhscg6u1QQ+wNatQcRA8Fy8zNnRLOTwzgUAjsZiTOHIgIl9vmEtBN0dAKrDU3QwqNjbEK5tNJ15tNXeYgob2D8NS9lU1L4nxXYGxoJ2ZrQEu5Qf11XjaKY1MjRewU2wecpgwtqD4WvGQAuWysMQZes3ZiARJj5up3U26zY7QYNAlUSomLBC+Z9r4zZ6fcPNyJIOEuCcHs4HHjb/9F67eQtBpe3T1B8xDgaKiAjDpgSiBDLaaWX9aKMuNtLkVBfODFa4A7JggjBdzS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 17-02-26 22:50:17, Ojaswin Mujoo wrote:
> On Mon, Feb 16, 2026 at 10:52:35AM +0100, Pankaj Raghav wrote:
> > Hmm, IIUC, postgres will write their dirty buffer cache by combining multiple DB
> > pages based on `io_combine_limit` (typically 128kb). So immediately writing them
> > might be ok as long as we don't remove those pages from the page cache like we do in
> > RWF_UNCACHED.
> 
> Yep, and Ive not looked at the code path much but I think if we really
> care about the user not changing the data b/w write and writeback then
> we will probably need to start the writeback while holding the folio
> lock, which is currently not done in RWF_UNCACHED.

That isn't enough. submit_bio() returning isn't enough to guaranteed DMA
to the device has happened. And until it happens, modifying the pagecache
page means modifying the data the disk will get. The best is probably to
transition pages to writeback state and deal with it as with any other
requirement for stable pages.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

