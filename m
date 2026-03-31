Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 137DAFF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DB76B009B; Tue, 31 Mar 2026 06:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744F96B009D; Tue, 31 Mar 2026 06:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6815C6B00A1; Tue, 31 Mar 2026 06:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 571AF6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:40:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE0F9BD80D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:40:09 +0000 (UTC)
X-FDA: 84606013338.17.636DD4C
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46A79140006;
	Tue, 31 Mar 2026 10:40:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=RGXImBG9;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=IkV85c1b;
	spf=pass (imf09.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774953608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o61ziz1K7RE+vfkx01/BqKbiM2DvTc1gWIWpdSZJsrk=;
	b=CrejlnDyOd95J9zyqt1ArvmUCcZItxLMLVxYui8vU/lK1/wum8yamjwIlSofkFey+fvRjb
	oPYBKeNMbwb4zrLQRXZnu6uIZmDDuCFOTJ+YEs1HPJ8Qf9aYRb+xV4pTL92dctqp/IIYXH
	WahRabVxtRiu2FiH5KFLRW/aqmiofhQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=RGXImBG9;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=IkV85c1b;
	spf=pass (imf09.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774953608; a=rsa-sha256;
	cv=none;
	b=zVZs7exSyZnDyh/cfibCXIzzwqa3YJtr0BL+KbDuZlDHUaiZJltjXtAkihkKMyeuVH3n+U
	a2rE+eCiZH/BZWRCP612LIUHeGlt37Xd7zrlwGK2tUEhoR4xo1Gx2Vb5f3mITMfWsYElCt
	04NzCBmvQTRgj/GUfJ/itXwis8X+yw8=
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 779F226F7689;
	Tue, 31 Mar 2026 19:40:02 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1774953602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61ziz1K7RE+vfkx01/BqKbiM2DvTc1gWIWpdSZJsrk=;
	b=RGXImBG9OkkmJqMaygJ7AQDGsKzIQl9abCecZ1Urgp/oZ2yiBvcZeoE7CFuE+/kvV+iN6D
	U4swsphXGmlc5MObWhkYovizM+FxkoO6U2EEfzujW5BqBtiQ0r/J752mOChnK4gJbLR1dD
	1VUSlKrbZJpn48cr/6Z/ap3ks+R41GUVNedpzkFQCJe04B0BLknTNOOiimUB7JUPB+SQ/N
	4X6OBt/0Ut5bSz7MyVLy+TgrTD28bKJcZgC7ik/AyOmHECVjUd9Vv439R9htdHSYnn55Lv
	bCx5WQtQ/S9RUkvZ1CIEdGRCrYI8pxGW0DbfMNG8k94uebjKG5i/Rptypu+OKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1774953602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61ziz1K7RE+vfkx01/BqKbiM2DvTc1gWIWpdSZJsrk=;
	b=IkV85c1bt9eSNB1ACUrhM1X1oZJQ7QVVMbbvnBOLSwK7ls9q0Ga6u2jMZrt3U7fvRHGRKO
	E6TPZwycQpL0rOBA==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 04458E00CC9;
	Tue, 31 Mar 2026 19:40:02 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id EABA92200056; Tue, 31 Mar 2026 19:40:01 +0900 (JST)
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
In-Reply-To: <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
	<87jyutwo6o.fsf@mail.parknet.co.jp>
	<mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
Date: Tue, 31 Mar 2026 19:40:01 +0900
Message-ID: <87wlyss2ny.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 46A79140006
X-Stat-Signature: jsh7tgn9o9jgdafgti188z9a7idac7bm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774953605-990744
X-HE-Meta: U2FsdGVkX1+1WOc31TdfOaprpQqOkTcOCVgKF59fqw/HYI/jj9dlZruc9K/eGDiVHhHZb6ENmTUPOo1izJWSQ8S85ZhJYDcD0El67cKh1974dZM6xs/F5VX89l4p6j0l8ZZKZPiXIUaVmjmF5oSfJB2avJtNu3AzYQDNnIEkPt/yXs55bIbA7QXwzcVZPquaN5QfwLcBsV1j6IJfbrtORdHRJFZICEq9w+XNuAUNqx3LXCP8/BGi7hMHgP6HN5xL8xlSy8fhEEvK3llGxj7aU6AHE7EZBv0emKQ9hl1hHhMQMUaiChySQskGlBc1yZx0J+gg34CFU8tzV690STA0FQaJprRog5dCeKs2hSx5g3Q5tvyHKyxCSfBcqh1a4yjH9dUH34KqF1JL+WDeiBJk0hgp1PSJQ8lwRqk8bneaQNX4r9WL7Lx0I6r/oZxY5FgyDL+GSFtNZ0aYiD0k4pwOgHBmZFXPorgZLZ71MXuFY1ANMMHfMiTkEdbbAUHazJe+3P/ndamHdVAf6VeJD2iCgv5HPpmfA3Nh4bcLjC/TO7xWc2nJt/Ujd4ToToa6PE5eBoDQGaxN0Fk/Ym1NRMeUC6+hQq9rpJHSjN5wvH44LtuJE+suFvvpAgAHxLp08d0TPI774gMjxInasX2Fj3vVciW+JbLEa549pllKTyz53Ck+uSwSh3+WD96yRLVlC0eRylfu2GXJ8BmzKG2ru5qu8Hg7C+UeslZcOh+8kR9n4QiJwXZHXJ2mLlXkkAnt9tJDC/Oa0OkzaNtfi1gR32i+amng718wRvY/SKto/VrDTJ0ebj4k0Wb5WpUncL9d4tpfEqbpAYGl/SDnXiSuYv8xhmKwDT92f+Hiqd9d5aCKLToHukeXAZxeoM+zDe1txTmy7ONCgJCYQbWbvpm8vetoSul5Fs/Zm3UJ2aKfoYkiPQIo+p6Nhd36nHvYGnr8ewryzKkdBEdTTl0IKWUmyPC
 PZHFah21
 NWRm3y4a6JeEAgXA+A8nk3MLhEgP0tViHQ2Nzd2g86YdxNqf7Og1aj3i3bSsLrZ8k1CGPBb8H9v+ytEHxW02nAoAuBv9UJyCkIuuua7xFNIYPneCdfOyEkQfOWMoCw07tvTT++qHXmqwlS1qrN8Y4Sd3RsQIMHdwQ5wkL9amr/JxZEDHWfLBXPEiVbDy/YUzPxI1klLpLxpT6tBaZWltciNRad4LwwHskjWTZOtbPu5u7Bt1mBIPvOU0pszd/P9c4+OrIvtUtLJx/8FVFAj2CNU6JbzGzOfpkm1Ri+fN4vH2SukTtPsMjgS92O6yXp+m3aEvUZ9S28R2ZkpQdfqXoN9pUJklIks4x0J1b+qhdaCrtfOQPCXqqbbF1vfpKZ18/JGDGYoEc9s8Qhh6uKF4bTSnt/TpGFkUwGRsHoFh6QNQvNPAwK879X5Dl3Jgrv2JM0nJePB33e8eTut1/TqhnbGh3rpzdUrDpDhZgO905wgEpFZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

>> >> Hm, why do we have to add this here? For FAT, if buffers are still
>> >> dirty, buffers will be flushed via bdev flush?
>> >
>> > The reason why I've put sync_mapping_buffers() here is the following
>> > sequence:
>> >   fd = open("file")
>> >   write(fd)
>> >   close(fd)
>> >     - now data gets written out, dentry & inode can get evicted from memory
>> >   fd = open("file")
>> >   fsync(fd)
>> >     - this should flush all dirty metadata associated with "file" but if we
>> >       didn't call sync_mapping_buffers() during inode eviction we wouldn't
>> >       have a way to do that.
>> >
>> > So in general I think sync_mapping_buffers() call is indeed needed.
>> 
>> Hm, it looks like not new issue, isn't it? Why we have changed now in
>> this series?
>
> It isn't a new issue. But so far inode_lru_isolate() was checking whether
> the metadata buffers list has any dirty buffers and if yes, it skipped the
> inode. So inodes with dirty buffers in this list could reach .evict method
> only for deleted inodes or during unmount and either case makes above
> problem impossible to happen. This is however a layering violation (generic
> inode handling code shouldn't care about details of buffer heads) and as a
> result it makes it difficult to abstract the metadata buffer handling this
> series is doing. And all this for a handful of filesystems which,
> honestly, aren't used in performace critical settings.

I see, I could understand why you wanted to change though. However, (in
my thought, this change has disadvantage by below reason) changing this
behavior because of layering violation is not good way, IMO.

>> It is including trade off write amplification vs reliability (i.e. may
>> not call fsync()), for example. So I think we should not add it easily.
>
> I expect in practice you'll hardly be able to observe the difference as
> inodes usually get quite a while to be reclaimed at which point the dirty
> buffers would be already flushed by background writeback. I don't see how
> this change would lead specifically to "write amplification" - that would
> mean frequent redirtying of the same metadata buffer of an inode
> interleaved with frequent reclaims of the inode and I don't see how that
> would happen in a realistic setting.
>
> If someone comes with a realistic workload which would suffer significant
> regression from this change, then of course we should address it. I have
> plans for adding an interface for filesystems to expose the information
> that inode has some pending dirty metadata and a way to flush them from
> flush worker because that is a common need a lot of filesystems has and
> doing the flushing from .evict isn't always doable due to locking
> constraints.

I think it would happen with normal operation, for example, copy many
files more than total memory. I think this would be much common than
write=>close=>open=>fsync in your example.  Anyway, with it, reclaimed
inode metadata will be flushed forcibly and frequently (yeah, may not be
significant though. but I can't see the benefit for users from this
change.), and lost to chance combining multiple time of dirty while copy
many files.

> I'm still thinking about details but this has to be a properly
> abstracted interface all filesystems can use and not a special hack for a
> handful of old filesystems.

Sounds great. How about we delay this behavior change until this
interface?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

