Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E43D3517B
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 12:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7256B0089; Wed,  1 Apr 2026 08:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2978D6B0092; Wed,  1 Apr 2026 08:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F066B008C; Wed,  1 Apr 2026 08:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F05E36B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:50:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 998831B8C28
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:50:50 +0000 (UTC)
X-FDA: 84609971460.11.91D67ED
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	by imf19.hostedemail.com (Postfix) with ESMTP id 041C71A0008;
	Wed,  1 Apr 2026 12:50:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=dqJQ7ruY;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=KdnBEHm+;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp;
	spf=pass (imf19.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775047848; a=rsa-sha256;
	cv=none;
	b=NDa9qbkFwFaFFP85w7rXNP3M5tn1OP9B9BoqAF22kbB1edP7jvnNuCCFEKbMTz/L93rM0J
	xSkVYeduAbc/IyKEHXH+J8t5tETzlq7tVIAmKMVnUh6/4avB/mAKUwawOfa9FZ3pL6uOv4
	PGlQXVC9qbL+2z/tf8vqzgDoCcQJKkg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=dqJQ7ruY;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=KdnBEHm+;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp;
	spf=pass (imf19.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775047848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPBKhpUGjbLqOjWvgyGXvIWOd2G5DG6+OKURw8r5aLw=;
	b=zbm4lNEN73S9VdueDPR+ISZZGT8gxexDzTAQZoVMMAujjTIBWArhSBhVQ7+jiBIeczRH+T
	/wKfpQbIywLyRj5i6qIQryGS0sFkEmxPe+D/Z/lTInKp+421Sns5btZJhXgHFZbSOINrtk
	SUiYl7+woW7vgSpsA/n3Sn6j3G0xJP0=
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 24E7B26F7689;
	Wed,  1 Apr 2026 21:50:43 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1775047843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RPBKhpUGjbLqOjWvgyGXvIWOd2G5DG6+OKURw8r5aLw=;
	b=dqJQ7ruYdeTaqITPpRQwovMgoXJZ//3rBhfHEUSXZntxLfEOaeiYcGiQUlShaVrh+6Y/C1
	cXCtW+2x8iNBS+HhYDZf5uwKex/VghtmyYQIpNi3pnmPBCS/dHVsShuFLVen+q71uOPSHp
	BbuzlxZwTnPUo0xyp67UBqN++fojFVt+xCWgW3n4TYAx+ZFpJlmGZKSo4YAaWC5ln8nz/9
	dqoaw+wJ6rRfwxZbc1XkdN61C8TX5HXOH2vrM2FEutEOJuT9fNG+bM3dw2w8k5N42NXZ6p
	4dYp6/2f9q7dBNZOuR0Q/14mHKwaQiLCreBNi7hj8e1ukp4S4UU9Tu7tJ77pTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1775047843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RPBKhpUGjbLqOjWvgyGXvIWOd2G5DG6+OKURw8r5aLw=;
	b=KdnBEHm+ZL35BY6ZddX41t3UtdD8vFGWCtWTzqWFFxQfI/Z1PMRw16SdSTOVgUcbO7Yi/b
	nuCfjQXN3PMGuiAA==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id A77B4E004BB;
	Wed, 01 Apr 2026 21:50:42 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 93D6622001D9; Wed, 01 Apr 2026 21:50:42 +0900 (JST)
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
In-Reply-To: <dvo2jvc6upmzrgqxx3n6er3e2gvujheongtzkihzmllwxqiyuq@h3qrrnwxlwo4>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
	<87jyutwo6o.fsf@mail.parknet.co.jp>
	<mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
	<87wlyss2ny.fsf@mail.parknet.co.jp>
	<gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
	<87tstvc90b.fsf@mail.parknet.co.jp>
	<dvo2jvc6upmzrgqxx3n6er3e2gvujheongtzkihzmllwxqiyuq@h3qrrnwxlwo4>
Date: Wed, 01 Apr 2026 21:50:42 +0900
Message-ID: <87pl4ideu5.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: hkork76n44zsdb7eac85c5aeejkw9u51
X-Rspamd-Queue-Id: 041C71A0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775047846-191620
X-HE-Meta: U2FsdGVkX19RVM58k8VJKbUy37RG9AtyxyB19bZN6ipnSC/ELNCoprN+3EOq/1uzaMx2+aWDIBgk/tlGB58VnyObOCSR3t3pzkXHW9VluV2DBbbqzongk8Ger4+VMFpKG22Mi+YFSChDqfmYi9LuhLkfo9vZtsqWOuW7gXKrC+qxjq6PHIlFmvLFipvMIAeU5/XcbVPj2AdJ/2Ttaz6WuIV+a+zacc3e11iJFj7/seem00QLFWWYZe9N4ypWAHed2T69QRn6Z09gpnC7dLWLBE6qW+x2ru5AtDfWvUyCgYxjVhYvq8hAouARW2VTfwQZQ3P2UN2hlVLEy0WsP1IxeVMlpUQvtuqWyOEJA01JOFmVPZ4uXLshZ2pp+1sfNEtPl8CqfbpZaLHWEmTu/ScYtfK8xl64o3mBiYrv/Qg9Sm9rqhdpmA19hlnblkM1N+8kjOEyEp5ybTJLl/lS+DXQqjkrocE/8ePwZSK1QpOq+eCkBkpdKWbvG1PZ7VPlSPkLcJELfbmefHrL/ZrnLV03BgIp0tsCQn4BTBMXLNk+G/Y0CYyv2iJW9tPPwEt3OT+Ye4Sp4Rf0x178MIooIm118diO3amU67HFe4zUP4mZVZuD6CqrE3ZEKw89eeFLRZrXHBv+MvXVjO9YyAKvd9e2HDHYMvE3E3CNhIhY66+IymBDHJP7j03Xi55kTKwZigEeetGZylwQTPROC5vDF5tO3e11g5wTiuY1UlTYIyXNzh4hXYXnOMHfgNtsn+bnJMwMDuW3ho8l4aTEPD0wf2puGulN5wuvxMYSe/11bS9tRq/WzKMm+630hKwbmPFzir1JZ5OSQo41/hBujqgDj//Cz0nZzYzD+gZHfKaI7B9/pY9czMoQ1ZOF7KyRhNSmzDAwdZ8cyRzKHtQ9872rRIerRSK+a/SQLDnl3ajAtqQOxWEELeJpCPglkDgLA/knpWnuDBqm834kfsHVtlBdCXl
 5OcnpNbp
 nEldcUj6mE/MPoIBIaAYUFpk80WRuDoWp6oF3KOTih9vl/U4YublyvhnUBNL9WzB7xh2vU7nkIUmp1plyFhCMyjUZQrrY2dAaZKxYxK9rxxTCpXTtk9vRNC3HsaeUSwiTbxsNuKAhc4HXsWX5uCO8IrdyXvlo+kOvNQn92QA91j2EsuwMttCDOtvm1fjmsXxIeQfHI1qIUvkHEaTrll1Ef5qkS2Sm9YE27P0h4YKWQyoY/5/8aps4HK6LWlMThvQ6Zk8VTCGKqQKAPA6YpyMcSz2RspCfekemQl/WYPti0Rq1BJlANQxEIB+zr/0qsdhcEhRRb7nB6bN1o0yJIW+HWkIKvrDAmSODUuBgVl7U/cIcc/gOwPltqrcwxWzxZ6yR3/c1A+ehDvs1GEzhCj0uoi+l7sjwPbQDyuepVmZRUBFuNiMce3+enXrRar8thAKhVI/LqZ26usOago0ql+wRddeJp++heWZYPl7WPCmy6iHq3l0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

>> Hm, metadata block is shared by several inodes. So earlier flush
>> makes fewer chance to combining multiple dirties.
>> 
>> For example,
>>   create dir-A
>>   reclaimed and flushed dir-A
>>   add new entries to dir-A
>>   lost chance to combining re-dirty of dir-A
>
> Yes, but for this to be possible you would have to:
> 1) stop using dir-A between dir create & file creates
> 2) create enough memory pressure to cycle the dentry of dir-A through the
> LRU and reclaim it
> 3) continue memory pressure to cycle the inode for dir-A through the LRU
> and reclaim it
>
> So the amount of work that already has to happen to trigger flushing of
> a single block is so large that IMHO that flush will be lost in the noise.
>  
>> >> Anyway, with it, reclaimed
>> >> inode metadata will be flushed forcibly and frequently (yeah, may not be
>> >> significant though. but I can't see the benefit for users from this
>> >> change.), and lost to chance combining multiple time of dirty while copy
>> >> many files.
>> >
>> > The benefit for users is 24 bytes saved for the majority of inodes that are
>> > there in the system - all the virtual inodes on sysfs / proc filesystem,
>> > all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
>> > optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
>> > saved in common configurations.
>> >
>> > Another win is that with metadata buffer head tracking now separated, I can
>> > modify that code (which will require growing the tracking structure) to
>> > properly track buffer head containing the inode and flush it on fsync(2).
>> > Currently there's a race that if flush worker writes out inode before
>> > fsync(2), then fsync(2) does not writeout the buffer containing the inode
>> > at all and thus data is not really persistent. This is actually my initial
>> > motivation for this refactoring since growing inode for everybody to fix
>> > data consistency issues of FAT/ext2/udf isn't popular these days...
>> 
>> Agree, it is good.  I'm only saying about the flushing earlier. To
>> implement it, is the flush earlier really necessary?
>
> Yes, to separate metadata buffer head tracking into a separate structure we
> must remove the handling of buffer head list from generic inode reclaim (as
> the filesystem has no way to provide the separate tracking structure there).
> Of course we could add a filesystem hook to inode reclaim to allow for
> handling of metadata bhs but:
>
> a) I'd rather do that in a way that is usable also for other issues
> filesystems have with inode reclaim as I mentioned in this thread before
>
> b) I don't think it's warranted for FAT etc. at this point as I don't think
> the possible overhead of metadata bh flushing on inode reclaim will be a
> problem in practice.
>
> But of course we can reevaluate if my gut feeling is wrong and someone
> comes with a workload which significantly regresses due to these changes.

OK.  I'm still thinking we should go the way to reduce the amplification
for performance and storage lifetime if possible, not increasing.

However discussion looks like enough for us, and looks like we just
voted to different priority.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

