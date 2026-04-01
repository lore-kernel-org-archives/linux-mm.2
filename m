Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A78D35160
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1092C6B008A; Wed,  1 Apr 2026 05:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0898A6B0089; Wed,  1 Apr 2026 05:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92B46B0088; Wed,  1 Apr 2026 05:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB9836B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:11:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FA178C3A2
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:11:26 +0000 (UTC)
X-FDA: 84609418572.19.03A7B36
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40A8420005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:11:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nZxYsEjv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JCN8Ehc+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zo2PpqKA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BAatxIFH;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775034684; a=rsa-sha256;
	cv=none;
	b=sNVC5EDT80mQLyskTvWXkM9+XuvY7ik3sqjpgfL3NBPhclZCPrOS4lsQe7qNp61V3LO39t
	Az9CB6EIPmcAunBdCEhh7liHzqRKe90OPme90n4BFLpy4fwqEou+Wtw8IEx5MhJ+Jxi/Pg
	iS+oGLa5u107Jp24i8lNO8JUtgFQkyg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nZxYsEjv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JCN8Ehc+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zo2PpqKA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BAatxIFH;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775034684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=5ynVGqaSIr3KHkQacevGDmD2HPc8NhRypiTeIN28Jj2NQK17zXHhU0j7wcd8/T6Z1k+vNu
	T9SJOwAlYqpQadeVb9HuXwlL8VzMoOx5Ee2hefnrxZZbWp/rpuaGee7G7vFgngfJwrAAfb
	Uie8mxWxVmGN5GDzsFIG3cNpeN7Meug=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBBC24D2CF;
	Wed,  1 Apr 2026 09:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775034682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=nZxYsEjvLNi0fjFwdsdR1QIaA5CvnCSA2jDPIHtYN/zMUPveX4qhK/mtlK3b2E2MA5YHn5
	K6wSSMfGS6pQ+rykA1fRsTcl+zcoowmjDYoJHQITm9pgexAemYCQK9PkVOejTlhUzl1lM2
	VIV5BvNh/EoHP/3O5qFeEP8cTeIbqhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775034682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=JCN8Ehc+FFINdGPTdJ+9HBZQRIpd6mKRIPCj7gdnQHcZCq1hpu7eDDuibBMcEPjV60J3hM
	BfW0iDBNn8QnJpDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775034681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=zo2PpqKAESdoDeQY2nAufXpoxkmcfvpYoV6gUQSBEZsX8z810LV8EEnBxv5xgeAtIdc4MS
	iix+uHfALyUGNhO93ta76Wu5ie9nz/RxdKk+d+NVbcV6+PvDY5C/r6ZjTtJUsOpr/zrkvQ
	eBthHK1py/eqJtWIXTqPWLeU6YFIduI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775034681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=BAatxIFHNOqSkzuZWOB7WxBGFIaFDehxiBNj+YqoR2+cqrgIPuY0C0BJNxqNmTVJ8EfJuP
	7B26ja4KxcBrjhBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE8044A0B0;
	Wed,  1 Apr 2026 09:11:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Db9LNjnhzGmdMwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 09:11:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F960A0AFD; Wed,  1 Apr 2026 11:11:17 +0200 (CEST)
Date: Wed, 1 Apr 2026 11:11:17 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
Message-ID: <gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
 <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
 <87jyutwo6o.fsf@mail.parknet.co.jp>
 <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
 <87wlyss2ny.fsf@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wlyss2ny.fsf@mail.parknet.co.jp>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 40A8420005
X-Stat-Signature: udexu5jabjsmjj33bxccneo1o4bc3kxy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775034683-408540
X-HE-Meta: U2FsdGVkX1/ygldrnjW04WyyhsE59ocqrACXM0X5FSdcLr+G7fZArA/M1nkt2UDmpzsvwgkMIhfGuYMBcjGbM9ZPu2w7ldt4utsBtPGMousM3bMTtAxARmJoAxcURcBFXKriBW3YzLe3FIhZb+VCUSHhKnnGa/2vknSFrerCXjq/2E3Q9R19hxKoQ9Xgw1+G6kvzwCBj1LvHvqeH/ahMDMVPMnp8LG/KD1GyDph29VxZFMFrbhso4qPbtTpGwrOfin/cxLJBX6S5kZV1iyPYDksrYK/LvDnH95DWB0KW1Wt2sTz3dn1CAA9bPvD+Z6D72Ri99pkCQTYwtoYfuy6I6NWPavcLIq0YpS/WIrEJ0EvgyMe9WklxMaehAHdOwPDFGjs8ynvH3Hxh2GFzNNG9tzdFd9jdBvnGjfJLjVRdYQyovKi7NXDlBJf8UJN7r/DDfi8h13vxTxuUsGyTW4UAZdr26jpTo2S2Jh2J4VhTTphv8ygSzjva+/AYOZapEf1sws0IxSm1Bsas95fRv4QZpayBBmT/p6kMspu8oIlBneAWuuZFNnqfiSG67dxP11fIz+/yVgs5RaHyQpI5gtv/ffktGYOTc0LXKL8yXh1ttxEQHXcm/pfcRS08WX+MFjJbinJNlwWFjJO5QjWAyDloYpoqYC1nuilkg3SSP1cFhBJ3dktlmYgNAywelwWVkYIw5z006g+wI+yUDCOTsgHYtfAQBZnPWVrA5dDvMVaAHBnuXTbBlZeIYtaxnnzDU4KuOixlLpzHF4kSTU5FuLLc+OqzS8q16ENn0LRbWPkEYrKuuaRiXPPsV2joZXDK0Nzy1Fo/ZQaH57JBVWCzVczK51dKviXqnh3xsnS1ahd1BaumAO6Elq73Ybm993v1H/rZzPGfEwtrCk6kZVfvofOK5vJhrSjOVGEby7EyS0LU+/sDQihcQWeSFBsO2Unyi1clMLsGnGAZJF8mDqNhYQZ
 f5ztQ2LD
 iEWArcAWskHwMMQVGjt9Tbu9dTCYBOY7pVIOt34/OBnog3DKxtuxy87lnGk4dhFc/Dio57bfph79WP9xnGuSsh8LWRBpZKstKqNHdUgbIGFBhetXj5KnbR63bVppOCG21IWPqtTz31TGRbH7iCp8dCpWpRGaYjvdsBVzw0ApCi1A34tsLkAM1WPWoOx97QlRJdAe6ghu8a9U8AhZ+XmkNWz3HOH9ZHrDxcrI47rsw37XXqkm+2IGjaVrWqazfS60O/jKrIe8EA5FyV48Wpy7hbZVhCf3WIDQi5kUW/EkK4QRWDX9ch+2Wnmo8151YfEwsRdEO50WmpG8hudPqeppNHwekkbhEYzIHzwDHDSgHWICcpqqUbsYtLe61dl6QGT8HRlCdBGJSRhUDYL68RzxhfCJ1Z7cC0yec9AtKGOI4fzOdqcfr/PdCtd1+4SnnjI8tWPbuKrVwB6lyyUw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 31-03-26 19:40:01, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> >> It is including trade off write amplification vs reliability (i.e. may
> >> not call fsync()), for example. So I think we should not add it easily.
> >
> > I expect in practice you'll hardly be able to observe the difference as
> > inodes usually get quite a while to be reclaimed at which point the dirty
> > buffers would be already flushed by background writeback. I don't see how
> > this change would lead specifically to "write amplification" - that would
> > mean frequent redirtying of the same metadata buffer of an inode
> > interleaved with frequent reclaims of the inode and I don't see how that
> > would happen in a realistic setting.
> >
> > If someone comes with a realistic workload which would suffer significant
> > regression from this change, then of course we should address it. I have
> > plans for adding an interface for filesystems to expose the information
> > that inode has some pending dirty metadata and a way to flush them from
> > flush worker because that is a common need a lot of filesystems has and
> > doing the flushing from .evict isn't always doable due to locking
> > constraints.
> 
> I think it would happen with normal operation, for example, copy many
> files more than total memory. I think this would be much common than
> write=>close=>open=>fsync in your example.

When you copy a lot of files which are large in total, I agree the flushing
can be triggered. But I don't think it will trigger any excessive IO
because the metadata blocks being flushed aren't redirtied after the inode
is evicted. So blocks may be written out earlier but I don't think they
will be written out more times. For FAT for example you track only
directory blocks in these lists so when directory inode will be getting
evicted, you may see earlier writeout of dirty directory blocks but that's
all.

> Anyway, with it, reclaimed
> inode metadata will be flushed forcibly and frequently (yeah, may not be
> significant though. but I can't see the benefit for users from this
> change.), and lost to chance combining multiple time of dirty while copy
> many files.

The benefit for users is 24 bytes saved for the majority of inodes that are
there in the system - all the virtual inodes on sysfs / proc filesystem,
all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
saved in common configurations.

Another win is that with metadata buffer head tracking now separated, I can
modify that code (which will require growing the tracking structure) to
properly track buffer head containing the inode and flush it on fsync(2).
Currently there's a race that if flush worker writes out inode before
fsync(2), then fsync(2) does not writeout the buffer containing the inode
at all and thus data is not really persistent. This is actually my initial
motivation for this refactoring since growing inode for everybody to fix
data consistency issues of FAT/ext2/udf isn't popular these days...

> > I'm still thinking about details but this has to be a properly
> > abstracted interface all filesystems can use and not a special hack for a
> > handful of old filesystems.
> 
> Sounds great. How about we delay this behavior change until this
> interface?

I would prefer not since that would delay fixing the data consistency
issues and I expect that reclaim discussion not to be very fast to
conclude.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

