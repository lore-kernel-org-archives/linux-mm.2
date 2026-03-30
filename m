Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B42C10D14A3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F3A6B0096; Mon, 30 Mar 2026 07:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F8B6B0098; Mon, 30 Mar 2026 07:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B936B0099; Mon, 30 Mar 2026 07:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 830106B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:29:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 267BD160759
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:29:28 +0000 (UTC)
X-FDA: 84602508816.07.E1760F7
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86FBE40009;
	Mon, 30 Mar 2026 11:29:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=WpiWpc3A;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=xzICJuwm;
	spf=pass (imf17.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774870166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azxPziBoTu0EUy5OEpWIvHWwjmLYDV1JOaPD5UsQPw4=;
	b=z5BePtsP+Lwq/ApGvvbsWPfdUiQwm5my3vCWydZpGy2JdvnInJKKamiDfQWvItVacxfLUZ
	H8Z77zmnIGKrQUPq/l3XZGMU0f7TiqP0glpqSK+tbC6tjkjUKhEH5/cmy62ptx2/ZxIwwq
	o13/l3yAQBALWaOeVmCp2pcjfQJDqGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774870166; a=rsa-sha256;
	cv=none;
	b=ZmqfCtZShuN1nX+XHhIhv59dOggZ4tMOXtM/kxteCP6+dY+9IyMU2xwHNAMMLRatJZ5ZKU
	GtcdzQBwvWfx+VVAxLSPRtYRCLFbotZQjjBGRc32xEewGrFDKtjFFhFFx3j9jAPZOp3kPS
	8wtHFxjvZoiOgGZBRLctq+V+cFTwxWw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=WpiWpc3A;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=xzICJuwm;
	spf=pass (imf17.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id E8A60209679B;
	Mon, 30 Mar 2026 20:29:19 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1774870160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azxPziBoTu0EUy5OEpWIvHWwjmLYDV1JOaPD5UsQPw4=;
	b=WpiWpc3A06BWRRTu1Eh7H4/yLh3+uexv5nVL92NTJyzJfbkFH6Oi0cN9FhimLmyIIOB6Ti
	1QtJ1ATMAUR8PbQjSmcB0npyYgX2Z+H93FjcbUlAtNmqRk/uPpUEdnrHKDLhZn/na/pIqU
	+RBBCVhwuNg+qVa2WWROA2U6hxBPXWE71phYBZEMU8HDAxFwc8Krvsq47HSLtCu8AS+0Rr
	/V2TDpL1is/6n+GUyiVCfargkn2XXg4njcelY6rMuHDUEN+a8aMLgJAcXcSCNWG68LIAzU
	ofL8yE2PEhLLdExxd71eTHVgYk9TsbNgQtIJTBLetAna/qw6zh/dkU0r/7m0TA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1774870160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azxPziBoTu0EUy5OEpWIvHWwjmLYDV1JOaPD5UsQPw4=;
	b=xzICJuwmbd2bwkmG4vWdifwyTBCo3WXeI70K7QBDEAQkYke/2C2LgEn+vOCw1ctSx1do3f
	1sOxI45CQB+75SAg==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 75B19E000B8;
	Mon, 30 Mar 2026 20:29:19 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 697E7220007A; Mon, 30 Mar 2026 20:29:19 +0900 (JST)
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
In-Reply-To: <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
Date: Mon, 30 Mar 2026 20:29:19 +0900
Message-ID: <87jyutwo6o.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 86FBE40009
X-Stat-Signature: hfqnqzjut9wo1sgjfh8mrdmq4yg7x8g6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774870164-274060
X-HE-Meta: U2FsdGVkX18x+ZBKzMowP8eWbj84ilqWeot3LWjGlLsNZaRRlDEJ1F72Pw+Ro5dYaQ0T0ukxVXj8OT+o684rXhXJEyC++Ciuc6+IvudXRkPxs07PoJd7zuds85pIB6BphHIbFXIj3UuRIbg0MZymwPbljsjY7bS2n3d9h42w+le4twy48qIjW+22kIrZ+DXFbQIKfAIv8u82J1cztyXLg7rEKQt8YnUTKtNKUsmvbM3vX0Lttr7xsF9fVxpRMhjiJBcQlZqXmkf1U/PXQsMj8I56LBz4g9MpAhepmOtiubWR6t8+YmXe+QyIAWqF7j48RVFXWWqlbTk92N1XYDFqMNEOjCjcyQVDmBcgs2k6p1JI8hmUB8VlfVxe69hufAlmpAQYuvTiiFix4fffV38Tu3IbAtudjIVNlNeqlhAnofivitIwaVkr2Wz2v4+oKXYys2ToMzpNBSSyBw3WIAq0cVtEv0BAZ744DH4KtJMFB25CBCi4ZQFOuDKiYOvADsECQra6Qot2XQnslsyk88/EWfQBhxQ+Js4BNE5yuBaq6mOlZkyTTuADavarpmk78Y+HKQmyhUjwc3V2/YjLFbudvlZX0As0C+LwU2pjhshrRmdG2vT6RWleo00SMGfHMKyYk0ylRr6gGG47Aicjmqd5cjoaekz5dZwesar2GkRSz8eZFwGQHxdNHq+rZBGoeK467otZPI6qBMrk7Q9/p2k+44tIH5Wib9Mh/Chdz8CY5jpLLny4X8dEeb8/B0rFyg/Aqta2XE3KDLHiDSkeYhmHk9ldybqi+g47MMfGUUf4lLHXR8LKJ80uP/T8E2iG7cIGcGxCBq4j/SQ5QToh7PrKpSJBmEE+sM5dNR6GtbYwe1LPMoyh/F84yyP05X76MWX3lEIsZrOySTHbc5dEiw6lzLaXJXu6bS2mLG7+zRQkttG86grVXAm7Zo1pZHOwhDBJ6Ktrs3piPP+xyHw75YF
 iQa5FH9S
 ZbSFlGBOQ9ll8qHuDhR05rITcKmGNUTDyao3G1KsqhWZgwKFHk5QoNdxiznFNednQtOwIACWHdRGyF+e/JkieeEbVosDK+KohCGU/sXWVRflleL6W9eOO31XsdX7DNwAL3ecbK4kAi2ZY59xu8vG496hM2eKMUEAG5N7zkVan/wutyxkBHmc8IqyqMX60FGPc6D2wySjvOeoryi9gpgdGTrmWZGTcx1YY7F4YzXWTU5Qzs7vjmoBEcyc2u69ivgyUB9RpZerwfhLDcS375MIVJtNcsPz3iraWEoehKt+fN7TsboSi0x/urVPhyory81qIHm+kxwGKBPq3keIBBlG2+pRp/8TG16ZyLidEKPF++j9YcGNHy8hxgV6aQAgQf8Pqb6T9kvDkoQWqB7JAb85LW8LBEtTvsZ2QXbqrtWXjvKhgjJIuROGb7qIZHC/2bC8u9Hc+Xvyy+LwaOfFiTW2KU+mcq6C29UJEmAfS9xYS2zduQcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

> On Sun 29-03-26 22:55:09, OGAWA Hirofumi wrote:
>> Jan Kara <jack@suse.cz> writes:
>> > There are only very few filesystems using generic metadata buffer head
>> > tracking and everybody is paying the overhead. When we remove this
>> > tracking for inode reclaim code .evict will start to see inodes with
>> > metadata buffers attached so write them out and prune them.
>> >
>> > Signed-off-by: Jan Kara <jack@suse.cz>
>> > ---
>> >  fs/fat/inode.c | 4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> > index 3cc5fb01afa1..ce88602b0d57 100644
>> > --- a/fs/fat/inode.c
>> > +++ b/fs/fat/inode.c
>> > @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
>> >  	if (!inode->i_nlink) {
>> >  		inode->i_size = 0;
>> >  		fat_truncate_blocks(inode, 0);
>> > -	} else
>> > +	} else {
>> > +		sync_mapping_buffers(inode->i_mapping);
>> 
>> Hm, why do we have to add this here? For FAT, if buffers are still
>> dirty, buffers will be flushed via bdev flush?
>
> The reason why I've put sync_mapping_buffers() here is the following
> sequence:
>   fd = open("file")
>   write(fd)
>   close(fd)
>     - now data gets written out, dentry & inode can get evicted from memory
>   fd = open("file")
>   fsync(fd)
>     - this should flush all dirty metadata associated with "file" but if we
>       didn't call sync_mapping_buffers() during inode eviction we wouldn't
>       have a way to do that.
>
> So in general I think sync_mapping_buffers() call is indeed needed.

Hm, it looks like not new issue, isn't it? Why we have changed now in
this series?

It is including trade off write amplification vs reliability (i.e. may
not call fsync()), for example. So I think we should not add it easily.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

