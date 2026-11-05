Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552B0606EE98
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hmbELvjG
Received: by kanga.kvack.org (Postfix)
	id 76E9F6B05B1; Thu,  5 Nov 2026 05:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F386B05B2; Thu,  5 Nov 2026 05:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6100A6B05C0; Thu,  5 Nov 2026 05:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC3B6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:29:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C98684099F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:29:05 +0000 (UTC)
X-FDA: 85400692650.07.9439FCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D47FA000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:29:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmbELvjG;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874544;
	b=tb6W9q7hjF1S2tHZ+8Q667j0wjd1g44zg8BFzEI4udMs6V1OgMfk4eFKAp3B5EzCV5VWX6
	01QnZiz9P0LN3gcHN+cfW0Pb2DTAoj4Y/wy7zcF/vg89hqWMKNo+PWVq+jqqm49TjugVzn
	1+0jyrl2u0wmlkNKAchNp2Or7doLMfU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmbELvjG;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57E1PfjaDh0LCy68sg+mNNI5f3Z5aUw0wqyBt7zz4T8=;
	b=ezKpFJIttI61htjAnRxr6naNzbvNcVuXxNjKQ7m44F9PLIt1gQ2zvPmsJ7THv9Z+nz4mge
	PFm6s5UkzyThcvDCOwV988A4xYy7lob5LzCVkZBWEkk0JN+o26V8KM27ZN94umyOXipYFY
	NSdB1J2s5rrbojdtlPLsdX6PtPzbZhI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 740D642A37;
	Thu,  5 Nov 2026 10:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808A91F00919;
	Thu,  5 Nov 2026 10:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874543;
	bh=57E1PfjaDh0LCy68sg+mNNI5f3Z5aUw0wqyBt7zz4T8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmbELvjGRYsr506EAwoJgBAXH0ELDX1EPlqMNbyvDHt92LsnGRKJzHsFbggux76Nr
	 4VuJW2OLsQiJnl39IQDOul1sCQwt9d8MZevNX4eSh6gNm3ZTG/LGbR7xUU9NM2H7ZB
	 Zmf/KjAazsfp6p+rrHhAm27ed37eIP7oTh4Gn6f4ESRdGcc5084mcjIlsi7PeEnK/h
	 ZHrwK8mAJ5fFhNsjwwjPEpQcENFcCs7lLj/i7dd0U+MO//fdk5W/zzCW3ShQTr3BSz
	 /h7RXevBU6GyHIwpRH9BJat6WAMucpuTZsxKrSRux510prhvj/rjFCVc+HBvyfwWTb
	 6GBRdXGUL1uJQ==
Date: Thu, 5 Nov 2026 11:28:56 +0100
From: Christian Brauner <brauner@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, ntfs3@lists.linux.dev, linux-sound@vger.kernel.org, 
	linux-mm@kvack.org, Chuck Lever <chuck.lever@oracle.com>, 
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC 0/7] proc: move procfs to what kernfs does
Message-ID: <20261105-erbrechen-unecht-bauformen-0794d3cfb679@brauner>
References: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
 <464ef986eab97abf226791c7e19ad111.josef@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <464ef986eab97abf226791c7e19ad111.josef@toxicpanda.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2D47FA000C
X-Stat-Signature: qptuqqf8ogds75xbuzrpdzjx3y37bkuc
X-Rspam-User: 
X-HE-Tag: 1793874544-63651
X-HE-Meta: U2FsdGVkX19Lqi17fI3O/9bYbcvQSnOnOxeszpkNweXBUhIjoVHCss3jiRMcJGyxUx/nGeUHB+vxPAiB8FuAB3KG1nfKnh7CskT5/icxC/J1dMhkqRb6x/ngDoDhDBhBjXop+N4CK+ORGIzHeZor84MC15nG1OeoJqVcMIb49Winmbts2R9Be+wCTw/iC0+MGpoSzbkLoP7l6VJzNZjOtQRl5aVTdt0xAvbZ3qQI7THVkf1UyLEC4VxMJfQBJ4t2TwJYnvMXJ7BspXo9c73bDVEASY5DT4rHBF4IkhSEuvGWNHUZ8jkF7i2/QBZutkSrB8RrvFace2xRoFa3nGbo8Sd/LLjh0vZYhJOeFerQfVp35cCjN8sbJiL3R7/NnrbYoJ8MVS9eEBvjZZGFPODkL9K7ljl62AQmzxLcJ9TwpdZ1rP4PbOLC5Wez02LBtWQPTPhoeSqoQ3xs59+WPXe2de+ieyMqVb/FTcsTclJhe2MTrUzd4SeRcHAaxtqpNcH+ZefpanXng5wPR+qdXSiY/oim4swcouc/aRRr9gLfvNEVj3L3kShiLYD09tayp0t8w1hYPxS/P0bj9oVrJSjlhrsst9g4ShyT0v85u5K2HgDSstjgYNHLabC3xGemCmA7B6lHA9oV4Zlsos5fCDACd86b0VAyt2mLUMw1sG6coB0YzmezITPau06k8dTj+xWK2RMnJnkl0HVaVpgBcIU8tSDQaXwW0xHOBCty6UgzdfTyJd17rcViKDo5+QQriE5CtroL9XV4/kUd+c0N2K8NuZYQ3Cio9+fTlg9wMf3LjTOrKK/5EfbBPUI5Vq+z4ci2VE2nTFtLXDQaV/fzNfbfBc8T0XkeHvUM8ni9iRPF3eNWh//hABmyVjuCS+tVKHqzkyoqDI40mAqgsQNMn3Ym70Zh5ARgiWDx6zHY5SVLE5jU3rpRajr7FWvAv+XxgAGaQgM+KBgks/8D5TyMxZ6
 LJ3voJZ2
 zjzJwYqEjuHwBRnGE2QR1i6sDym2ZQBc+kYMUTZ4D7rcR3ch0cb4EIWhlxGihthTw/Dki3L3gdBJx7/8KPKdV8v40e09eeT4SZAhlyJaDGAuYx2tSYb9EWYpd0cbKXJtABzwYdofVetIqauqoQYr+VkZJ5LhsmjW4ZKoOI1fjJxC3+02jAQ/chGwQ/cReNU6vdmIUcIVSTn4nYUscBgkZCUQS8CKrYv/XNJDIPSLE4Lnzm/k5674RjfEdC1Erd6ulBiN2uWl4J0G2VS99fNFvbbvVbqD3cy3VQtluhPBj7GLtoqtBpF+6NFOXPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 22:23:51 +0000, Josef Bacik wrote:
> This is a summary of my Claude review of everything.  It didn't find
> anything wrong with the conversions in parts 3 to 6, the findings are in
> part 1 and on the procfs side.  1-3 are reproduced in a VM, 4-6 are from
> reading the code.

Thanks. This is useful. There's some stuff that I already took care in
v2 fwiw.

> 1) bugfixes 19/38 ("proc: resume readdir after the last name it
>    returned")
>
> proc_readdir_de() now returns 1 instead of 0 when there's nothing left
> to emit:
> [...]
> So at the end of the directory readdir(2) returns 1 without having
> written a dirent, and keeps doing that.  This is syscall 89 through

Indeed. Fixing that.

> 2) cleanup 5/5 ("proc: drop the _buf suffix from the new methods")
>
> 4/5 renames the old ->proc_read() so that "A module that sets one of
> them doesn't build anymore".  5/5 hands the name to the new method, and
> the old and the new prototype only differ in __user:
> [...]
> builds without a warning with W=1.  pde_set_flags() only refuses the
> release helpers for seq_file entries, which this isn't one of, so it
> registers too.  With a module that has exactly that loaded on top of the
> series there's no warning, open() works and every read() fails with
> [...]
> there without anybody noticing.  Either the read method keeps a name of
> its own or pde_set_flags() refuses seq_read, and either way this

Meh, let me think. I think not renaming them back to proc_{read,write}
at the end is ok. Not my favorite but it will cause the compiler to
yell.

> 3) bugfixes 38/38 ("selftests/proc: check that a faulting readlink()
>    doesn't hold up removal")
> [...]
> own.  The two lines want to move to core 08/16.

Fixed in v2.

> 4) core 04/16 ("proc: let procfs own the seq_file of seq_file entries")
> [...]
> return v after pde_seq_stop_pinned() takes care of both.

Gone in v2 as there's a simpler way to do it like kernfs.

> 5) bugfixes 35/38 ("proc: sysctl: don't hold the tables while readdir
>    copies to userspace")
> [...]
> lines that get rewritten.  Handling -ENOENT like d.skip would carry on
> after that name.  -ENOMEM probably wants to be returned instead of
> turning into EOF.

v2 does both.

> 6) stable tags, bugfixes 34/38 and 37/38
> [...]
> table registered.  35/38 applies cleanly without 34/38, so nothing will
> complain if only the tagged one gets picked up.

Right.

> ->free_inode()"), which went into 6.8.  Before that the inode drops the
> entry in ->evict_inode() without a grace period, and the pin is what
> keeps ->data around for a walker that got it from ->get_link().  Which

Right.

> - The cursors in bugfixes 19/38 and 31/38 hang off an open file and
>   anybody can have as many as they have fds, so GFP_KERNEL_ACCOUNT.

That's a generic problem for nearly all of procfs and is another series
I have but I don't want to get chased with pitchforks.

> - copy_to_user_fromio() has no callers left after drivers 22/23.

I'll kill it.

> - fs 07/27 says ntfs_set_label() refused a label that's too long with
>   -ENAMETOOLONG or -EFBIG.  It doesn't always, cpu_str.len is a u8 and
>   ntfs_nls_to_utf16() is allowed (PATH_MAX - 2) / 2 here, so 300
>   characters come out as 44 and pass the check.  That's an old ntfs3
>   bug, it's only the sentence in the changelog.

Right.

> Two more old ones that you might want in part 1, the series doesn't
> change either of them:
>
> - allocinfo can deadlock against a module load.

Yeah, that's in v2 and I think someone else also sent a fix for this.

> - snd_info_text_entry_write() allocates the larger buffer and frees the
>   old one without copying what's in it, so a text entry written in
>   pieces loses the start once it crosses a page.  It's been like that
>   since ffb73b08e794.

Yay, more bugfixes... You share the blame for more mail traffic now.

> This part is me. I have a selftest that my claude wrote to validate #1.
> If you want I can send it along, but we should probably have a test for
> that.

Right, I can probably also cook something up.

