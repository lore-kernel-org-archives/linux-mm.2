Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2302ED35165
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642AF6B0005; Wed,  1 Apr 2026 05:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6B86B0089; Wed,  1 Apr 2026 05:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5256B0005; Wed,  1 Apr 2026 05:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9406B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:42:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3A3BE0558
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:42:04 +0000 (UTC)
X-FDA: 84609495768.30.9290C07
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	by imf05.hostedemail.com (Postfix) with ESMTP id 08B19100002;
	Wed,  1 Apr 2026 09:42:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=xM9SP3IR;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=eHL6eK8s;
	spf=pass (imf05.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775036523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ddob+qWyvKUTgK+fMh/qkqDn+kishBT/6wKfgHgQIl0=;
	b=UD3K36tPzUlL05Qeu/eOOklOUIK7kQ6OdqQZdcvK3bGH5hgP9OQ609qrNnrcq6HgzmACZT
	3YVnvkcgvukSP3oCkpOYCGW8T0zz+JpMCP3jnpS1S00tmdgI4kUZaQRD+1mk4npqMT6Pua
	qpINcuEft+x6dTqALbul9ROXXZaalAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775036523; a=rsa-sha256;
	cv=none;
	b=gNkR8lEaNZ6ZoDviARnxBmKkcJ+IgKqIVxD6vZzFo3wT+nYvh43tlPJYe5lAnCwvxDuPXn
	H+Gb/fOgC2IjFTteVqXkXY/OhsZxH2k96xnrZvMo7bL0AskL9v7E29wG2jtxlaQroDr1Cl
	seo3VY2MRAELUlxmk1yLGcB/pyglN7w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=xM9SP3IR;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=eHL6eK8s;
	spf=pass (imf05.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 356F626F7660;
	Wed,  1 Apr 2026 18:41:57 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1775036517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ddob+qWyvKUTgK+fMh/qkqDn+kishBT/6wKfgHgQIl0=;
	b=xM9SP3IR6SCuCSTpNShzzonkoyYx/J/7Y4upeeQeZ3ri/438yMIefO6AT2HeIaOFoFnfPx
	R2W0wkTM1DyHhA9NP8P8H8DdL5qxq6PWVeINCMck/eQXjFDVHqVrTCRF37VBHoKleGUfeJ
	XCuZZd0F11KDnjLJKmyE6yQgddHB7vgJihcQNkeLR+5DTswKT5ZtUIMiV7amrtbjyppzn5
	/EEmrriK/QfgMgJO3Owdx1Q8zxs9kCoib62xsNa0Y2mDds13n6qnszjB4uzsMOxXSku0ec
	jYfCVYxMUPWHNPAIv8qUAuu8uCdkBgie/qO6nb0o38m0S/PrJQF4/WGYC9CL2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1775036517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ddob+qWyvKUTgK+fMh/qkqDn+kishBT/6wKfgHgQIl0=;
	b=eHL6eK8sp2ZrquHtYTH0cSLXQ/utW4kdMHSr5Ik88ROLy/OlyHFQzSiM96G6KfZX6aVGMy
	7ljbzutsO031msAg==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id B3A96E00074;
	Wed, 01 Apr 2026 18:41:56 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id A9EB822001D9; Wed, 01 Apr 2026 18:41:56 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,  linux-block@vger.kernel.org,  Christian
 Brauner <brauner@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,
  linux-ext4@vger.kernel.org,  Ted Tso <tytso@mit.edu>,  "Tigran A.
 Aivazian" <aivazian.tigran@gmail.com>,  David Sterba <dsterba@suse.com>,
  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,  linux-mm@kvack.org,
  linux-aio@kvack.org,  Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
In-Reply-To: <gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
	<87jyutwo6o.fsf@mail.parknet.co.jp>
	<mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
	<87wlyss2ny.fsf@mail.parknet.co.jp>
	<gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
Date: Wed, 01 Apr 2026 18:41:56 +0900
Message-ID: <87tstvc90b.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 08B19100002
X-Stat-Signature: br67ee37jpxk875gtbknfosuzig1xebj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775036520-745207
X-HE-Meta: U2FsdGVkX1/SnwG52Ha8UYPY6OCVaQtBeAXH/+6/zWCT3LoKcUDOo6mpBPJSKwK5W5Pz5Yivrl1bWcDlnVdKlSCJpA8rPxR+jazmuQr9GKCPBdOi7xSWZyyfuJnqaPpxTEagd//tlIu6UesjYjKDy+QbdnsqY4vwinmM+60ZJ7PsNrQIDfaW+6WZP0b44HmPEeryOH0B7sxEb1eEpPBPhG4P/aadz0iYRIb3HJTo4XGeQavk6c5dV6y3Gh7tMzDIYA2PZOj4nJWyWr56a2B3hJRX9hG8amKIeRlQu7dks/EeIBtE/Wv3aWQGtSVUSKLL/9hVP6k7VUcRkpD0wI/ySb3+gdXzZrvwHHKa9eEvQ0qJsdWx2Utxyw0ZghDla6jjY+SHsP3SGOc+6pNPbjU5Xyvj+9xT34IFLNUv/v01TkmK1aouSeooDcncHyM1VK1NaFzUgLP3ivLd+g8FRzkDvTWjJ4KIVjAX/Whs8vSl8syZyUoyqNnexzdsFyzwsBgD9pokq9nV6WvcqtKsXDu0LuwctU5Bl8+Ilkoq1BrxS/2G9SSru6V0DRH/RUjhmuCA3koTZfQ76fcLr+je17uuAdaSk/BbJNkXPFHQOKLFCD2c8qNEL4uyKQkYhq2fuBII1RCd0qitS+BYVfXgIhpFAA+zVZ9VshXluHhXxXCTefqsel0jLYQmZQzAUHPeAz90MknLiPKIt6Vdsuy0JJ8hLpCN90wKkEhmi6lULUvciPaW+GQWagVW1QkyFH7DiIpr6SZcHyBMdrAaGwnuGbJ/WR4hliaH/CX+C1/WHARYgVOSYbj7ZETDOx3GWnX/sISpEJH7a5MQVNe61MLWs7ti/XyjbyslyxIj/fStj3PhN+H+fNUzv0QBlSNI+8nrCvFq7EttPWj0Ja+MNoMcMGFQCBkmiwGcFZC7C4h1PrMBCDtsDOj7qrAy0ScDVmRysNWy88QNyRb/5P32WJOtWQp
 78EhEX9p
 7sc9rKzZZjsNTTA0ueGV+csm5g7a/2yb5DXrHKvke3yjwUiiwCMXyfGffiTw3M6qMJ+TauUqj9ZFJc46gOiO+nf8kFYdXvq1Y+fBxLEHQWeaIBa//aq2kW8TlOXphWBo/u4P1U4/S8qaQO6vY2eIPiCdtJllu4mWH4crxy9dcFUfr6X2/kp7Q8SRcVzTGk6Si9/RUsGhS9Eupx5iSNR2Kr2tg/SpwhvLtQLAoz0+qGmOo9dGd7s0hrb646ffXxTDDeikaBXHtR/ExYo5assSvFvK6inv6cNZqoJLwWeMMzMd2twFfh2RyMOd7TSum9/+XJB/8rTgf3SIAdxxByhhDJ2JjLG0tCM3Y59XF+dC9BYBszHeeopNZ9+Q/UXf17o5lPgxevHAqwyE0lzYvBD3yKcdNraS1udr/gixTx9LqpIrYCo4IaEGtPweEi71rI7uFIShlrc6IxGviD08qvij4mp+kRK/vmOi2u8KW5eA0OJauYMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

>> I think it would happen with normal operation, for example, copy many
>> files more than total memory. I think this would be much common than
>> write=>close=>open=>fsync in your example.
>
> When you copy a lot of files which are large in total, I agree the flushing
> can be triggered. But I don't think it will trigger any excessive IO
> because the metadata blocks being flushed aren't redirtied after the inode
> is evicted. So blocks may be written out earlier but I don't think they
> will be written out more times. For FAT for example you track only
> directory blocks in these lists so when directory inode will be getting
> evicted, you may see earlier writeout of dirty directory blocks but that's
> all.

Hm, metadata block is shared by several inodes. So earlier flush
makes fewer chance to combining multiple dirties.

For example,
  create dir-A
  reclaimed and flushed dir-A
  add new entries to dir-A
  lost chance to combining re-dirty of dir-A

>> Anyway, with it, reclaimed
>> inode metadata will be flushed forcibly and frequently (yeah, may not be
>> significant though. but I can't see the benefit for users from this
>> change.), and lost to chance combining multiple time of dirty while copy
>> many files.
>
> The benefit for users is 24 bytes saved for the majority of inodes that are
> there in the system - all the virtual inodes on sysfs / proc filesystem,
> all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
> optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
> saved in common configurations.
>
> Another win is that with metadata buffer head tracking now separated, I can
> modify that code (which will require growing the tracking structure) to
> properly track buffer head containing the inode and flush it on fsync(2).
> Currently there's a race that if flush worker writes out inode before
> fsync(2), then fsync(2) does not writeout the buffer containing the inode
> at all and thus data is not really persistent. This is actually my initial
> motivation for this refactoring since growing inode for everybody to fix
> data consistency issues of FAT/ext2/udf isn't popular these days...

Agree, it is good.  I'm only saying about the flushing earlier. To
implement it, is the flush earlier really necessary?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

