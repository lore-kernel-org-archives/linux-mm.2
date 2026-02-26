Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E70EFCE091
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1E66B00B4; Thu, 26 Feb 2026 09:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A0A6B00B5; Thu, 26 Feb 2026 09:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6076B00B6; Thu, 26 Feb 2026 09:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB0316B00B4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:29:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 719451B6A8D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:50 +0000 (UTC)
X-FDA: 84486841740.27.15B15D3
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D7DA80019
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xptgD2FT;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772116188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAX4WJ2Ss7mjZl94h6x1hLn056hNxjHN1j/COBhWBBI=;
	b=peT6ogSYOXdOGKSuyInwzpaxIsZFeCvGh/BGTEofTdEwucM5TvOt1emQLNxhg/fWq+xDp7
	4GQLgdT0kvsiqln3sHWXTpQpHA5KXefAghk9MB3pNsv8H/07QdaAI9ySAwnY/HA5kB43Pr
	LtX49vspfs7y4bHxNPmZ//V2iHv+x0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772116188; a=rsa-sha256;
	cv=none;
	b=dL1+KmkN2bxOmJHCTyG/mM2tBlDCM4FkR0X9+D3YGu0s3WSYRML7nN43JN4mcpetkwDonr
	PmaSH++xuWbs5gMNHpaQyVNIlhIlx4EJyqYON7vzWEELwKEWDzxdXaCoVjnFOZHlhVLpWm
	VBKFft2NumrnIEteSfBD1J+22EkzPKY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xptgD2FT;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772116185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AAX4WJ2Ss7mjZl94h6x1hLn056hNxjHN1j/COBhWBBI=;
	b=xptgD2FTlKgBhNODGcIrRBp5blA/GA2rw0WiznS6TETnPB6o8qUhsVJg7xmMni+6JRIITy
	GfcBPBhdnXx+9cHUaLcfBCHSLjGA/YNS/kr/PSdgC4DD2iinr47MB0lewbNYLKnnWWgaIm
	ttz9L60EnqKSXm99wwPsa0f42GEZLTw=
Date: Thu, 26 Feb 2026 14:29:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <655d0b2af1814312929e9e094854dd3ab029d094@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: annotate data race of f_ra.prev_pos
To: "Jan Kara" <jack@suse.cz>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>,
 syzbot+6880f676b265dbd42d63@syzkaller.appspotmail.com, "Theodore Ts'o"
 <tytso@mit.edu>, "Andreas Dilger" <adilger.kernel@dilger.ca>, "Konstantin
 Komarov" <almaz.alexandrovich@paragon-software.com>, "Steven Rostedt"
 <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Jan Kara" <jack@suse.cz>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
In-Reply-To: <2xzc3lp6ehtjwbzip4i5muh4g6oep4l72zh3j6sablfghbvbau@kh7famgorzrh>
References: <20260226084020.163720-1-jiayuan.chen@linux.dev>
 <2xzc3lp6ehtjwbzip4i5muh4g6oep4l72zh3j6sablfghbvbau@kh7famgorzrh>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8D7DA80019
X-Stat-Signature: d5gk9c4y4z6pkdh5bky431fj5m6d4319
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772116188-111182
X-HE-Meta: U2FsdGVkX1+pN8BbSweh/slstoz1/xZU0+puLIsLOXWhfAPGeQ9fWqihTusY+/lyVaGzNZONBPFzYvjeyGli3pvA9ZzDmq5p9uYMuP3uiRelv1dIxFGiFI41Zm8N6lbMTWzlbYPiTHxqFbNZ8JRjWwBKiyD7OBIN6qe4wrxmg45mxKqZPKHqo+g8m41xavUWsQSyIYmKy3Sr+tT3dKqdEdRGu/6i4JKGbYOh1hEDn7I13JD0NfRemlLUr+jHnsTfhEPU1Adg86iV5bIRwRW1PZFafMoGN+HjOwi1R53jWbTco3rLv2YTn1YAUkwkflT+Y3KW43zuS4jqg91a+QFYztnzGD4f6NhSm2DAj067Qpde6f+EtHFKbwUY5QuMWJJSur6jyqLz7iLsj7GkqRX0lu8SU8sCaY3iAu6dgykTkEBKrn3/PcS2csriTDQAforHjxtAkINkpsHLSdTuXbs+3StfoLQY/I3uvI3Vejg0eZV8yJTfgH33h/SAQ/DXZql03fYZ78KBf96SH3WVJMZLcmvoPzGCJdAC9JLJVh6eVoVvKwtSwen4m9Lg2AcUF+5/TM/1qF3RqClUS4Ua7QFPBY7kNxtQMRmblhq+Q1FHniPrnZ0pqCi9Zie5bhkGHDiKoNZvJ1ATucq21mnjZr0tFKBYYOY5QNqWAAtUHintdszvTqezW4zgngd2FLV+RTYy9n/VE+KlP1myX4Uzrlyh+Krgynen33sXzb3xvpjuIKugLnuGd3xSpO44i8WjjH8npSeLCYbAPBEniR2aevzw9f2RMh5uMvPmm9ptjQAkZnPHKIlroMGbDW+eWgSwSS0LJDqU3hB7naxwQOvchH+WObMAWhvovh8uDdy/wQmQSk8W1WWIw6JVTnT72MJ2cNckCvmRkQq9i/NthRnmMwVzy9SuyPGYXn2HANKaKjcGbvBMIfjLgTWGouK9uIIsp3mXZTECEYQMHZzVzAlhGCX
 OjR/uvgv
 5sIkAOj0SAJ8qgd77OrvA6Q4LB4sdHFPSt/1rS/99kL0jKzkev14cVOEK3IuEGJDFGqkfeOJYi/DKDBSfJbOGmaMWcgoi4AILtiD3TYk0Wg6Y4fre5/ZnnXecrTwMhSBZV4IlruAVYlv+ddVOKafv22ubAi+pYb8GGEwMgZHV+JuARj15hKjHn6Z7PltnUdXD8vgT3pwz4aAcJ4MhUxwJzWLtGIfYLlkNG+C/pFmVs+D6Hve/WHFKldwnQkkCA9S+tPkK0dye9E1vknBc1mi4T/Xd4qdN2nbwI6PAcR/9pJKI3X/yK9WjZi2DbQ5C5cqLePrUTJZusSGngGHBEGqj59Vk+gqAlzUcpMsZ0+nU6xtQpzLAwu/lGYdbBSaTzD/U3Tj/wglFhDXeQQ2Cjwa0f7qTDN/cmlKlmzWIkyk6gLRbsueizETcouhWVKQuryCQpMM5NrJT+HQmyeLdboJDi+Y9aaHJjqlGLCnEJB3sMvermaJ/wMMfbMd2cqJkLsXemIsxJ3z2oygw6VycIYuSKn05E8qp33826mn5OLBbddxaz8s9IBYpu9+dRp7TXfQGZqtOIQtBvV7XyGMkn11dqtWtEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

February 26, 2026 at 21:21, "Jan Kara" <jack@suse.cz mailto:jack@suse.cz?=
to=3D%22Jan%20Kara%22%20%3Cjack%40suse.cz%3E > wrote:


>=20
>=20On Thu 26-02-26 16:40:07, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >=20=20
>=20>  KCSAN reports a data race when concurrent readers access the same
> >  struct file:
> >=20=20
>=20>  BUG: KCSAN: data-race in filemap_read / filemap_splice_read
> >=20=20
>=20>  write to 0xffff88811a6f8228 of 8 bytes by task 10061 on cpu 0:
> >  filemap_splice_read+0x523/0x780 mm/filemap.c:3125
> >  ...
> >=20=20
>=20>  write to 0xffff88811a6f8228 of 8 bytes by task 10066 on cpu 1:
> >  filemap_read+0x98d/0xa10 mm/filemap.c:2873
> >  ...
> >=20=20
>=20>  Both filemap_read() and filemap_splice_read() update f_ra.prev_pos
> >  without synchronization. This is a benign race since prev_pos is onl=
y
> >  used as a hint for readahead heuristics in page_cache_sync_ra(), and=
 a
> >  stale or torn value merely results in a suboptimal readahead decisio=
n,
> >  not a correctness issue.
> >=20=20
>=20>  Use WRITE_ONCE/READ_ONCE to annotate all accesses to prev_pos acro=
ss
> >  the tree for consistency and silence KCSAN.
> >=20=20
>=20>  Reported-by: syzbot+6880f676b265dbd42d63@syzkaller.appspotmail.com
> >  Link: https://syzkaller.appspot.com/bug?extid=3D6880f676b265dbd42d63
> >  Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> >=20
>=20Given this, I think it would be much less intrusive and also more
> explanatory to just mark prev_pos with __data_racy with appropriate rea=
son
> you're mentioning in the changelog.


Thanks for the suggestion. I'm fine either way =E2=80=94 __data_racy is i=
ndeed
cleaner and less intrusive for a purely heuristic field like this.

I'll wait a bit to see if Andrew or other mm folks have a preference
before resending. Happy to go with whichever approach they prefer.

>  Honza
>=20
>=20>=20
>=20> ---
> >  fs/ext4/dir.c | 2 +-
> >  fs/ntfs3/fsntfs.c | 2 +-
> >  include/trace/events/readahead.h | 2 +-
> >  mm/filemap.c | 6 +++---
> >  mm/readahead.c | 4 ++--
> >  mm/shmem.c | 2 +-
> >  6 files changed, 9 insertions(+), 9 deletions(-)
> >=20=20
>=20>  diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> >  index 28b2a3deb954..1ddf7acce5ca 100644
> >  --- a/fs/ext4/dir.c
> >  +++ b/fs/ext4/dir.c
> >  @@ -200,7 +200,7 @@ static int ext4_readdir(struct file *file, struc=
t dir_context *ctx)
> >  sb->s_bdev->bd_mapping,
> >  &file->f_ra, file, index,
> >  1 << EXT4_SB(sb)->s_min_folio_order);
> >  - file->f_ra.prev_pos =3D (loff_t)index << PAGE_SHIFT;
> >  + WRITE_ONCE(file->f_ra.prev_pos, (loff_t)index << PAGE_SHIFT);
> >  bh =3D ext4_bread(NULL, inode, map.m_lblk, 0);
> >  if (IS_ERR(bh)) {
> >  err =3D PTR_ERR(bh);
> >  diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
> >  index 0df2aa81d884..d1232fc03c08 100644
> >  --- a/fs/ntfs3/fsntfs.c
> >  +++ b/fs/ntfs3/fsntfs.c
> >  @@ -1239,7 +1239,7 @@ int ntfs_read_run_nb_ra(struct ntfs_sb_info *s=
bi, const struct runs_tree *run,
> >  if (!ra_has_index(ra, index)) {
> >  page_cache_sync_readahead(mapping, ra, NULL,
> >  index, 1);
> >  - ra->prev_pos =3D (loff_t)index << PAGE_SHIFT;
> >  + WRITE_ONCE(ra->prev_pos, (loff_t)index << PAGE_SHIFT);
> >  }
> >  }
> >=20=20
>=20>  diff --git a/include/trace/events/readahead.h b/include/trace/even=
ts/readahead.h
> >  index 0997ac5eceab..63d8df6c2983 100644
> >  --- a/include/trace/events/readahead.h
> >  +++ b/include/trace/events/readahead.h
> >  @@ -101,7 +101,7 @@ DECLARE_EVENT_CLASS(page_cache_ra_op,
> >  __entry->async_size =3D ra->async_size;
> >  __entry->ra_pages =3D ra->ra_pages;
> >  __entry->mmap_miss =3D ra->mmap_miss;
> >  - __entry->prev_pos =3D ra->prev_pos;
> >  + __entry->prev_pos =3D READ_ONCE(ra->prev_pos);
> >  __entry->req_count =3D req_count;
> >  ),
> >=20=20
>=20>  diff --git a/mm/filemap.c b/mm/filemap.c
> >  index 63f256307fdd..d3e2d4b826b9 100644
> >  --- a/mm/filemap.c
> >  +++ b/mm/filemap.c
> >  @@ -2771,7 +2771,7 @@ ssize_t filemap_read(struct kiocb *iocb, struc=
t iov_iter *iter,
> >  int i, error =3D 0;
> >  bool writably_mapped;
> >  loff_t isize, end_offset;
> >  - loff_t last_pos =3D ra->prev_pos;
> >  + loff_t last_pos =3D READ_ONCE(ra->prev_pos);
> >=20=20
>=20>  if (unlikely(iocb->ki_pos < 0))
> >  return -EINVAL;
> >  @@ -2870,7 +2870,7 @@ ssize_t filemap_read(struct kiocb *iocb, struc=
t iov_iter *iter,
> >  } while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
> >=20=20
>=20>  file_accessed(filp);
> >  - ra->prev_pos =3D last_pos;
> >  + WRITE_ONCE(ra->prev_pos, last_pos);
> >  return already_read ? already_read : error;
> >  }
> >  EXPORT_SYMBOL_GPL(filemap_read);
> >  @@ -3122,7 +3122,7 @@ ssize_t filemap_splice_read(struct file *in, l=
off_t *ppos,
> >  len -=3D n;
> >  total_spliced +=3D n;
> >  *ppos +=3D n;
> >  - in->f_ra.prev_pos =3D *ppos;
> >  + WRITE_ONCE(in->f_ra.prev_pos, *ppos);
> >  if (pipe_is_full(pipe))
> >  goto out;
> >  }
> >  diff --git a/mm/readahead.c b/mm/readahead.c
> >  index 7b05082c89ea..de49b35b0329 100644
> >  --- a/mm/readahead.c
> >  +++ b/mm/readahead.c
> >  @@ -142,7 +142,7 @@ void
> >  file_ra_state_init(struct file_ra_state *ra, struct address_space *m=
apping)
> >  {
> >  ra->ra_pages =3D inode_to_bdi(mapping->host)->ra_pages;
> >  - ra->prev_pos =3D -1;
> >  + WRITE_ONCE(ra->prev_pos, -1);
> >  }
> >  EXPORT_SYMBOL_GPL(file_ra_state_init);
> >=20=20
>=20>  @@ -584,7 +584,7 @@ void page_cache_sync_ra(struct readahead_contr=
ol *ractl,
> >  }
> >=20=20
>=20>  max_pages =3D ractl_max_pages(ractl, req_count);
> >  - prev_index =3D (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
> >  + prev_index =3D (unsigned long long)READ_ONCE(ra->prev_pos) >> PAGE=
_SHIFT;
> >  /*
> >  * A start of file, oversized read, or sequential cache miss:
> >  * trivial case: (index - prev_index) =3D=3D 1
> >  diff --git a/mm/shmem.c b/mm/shmem.c
> >  index 5e7dcf5bc5d3..03569199baf4 100644
> >  --- a/mm/shmem.c
> >  +++ b/mm/shmem.c
> >  @@ -3642,7 +3642,7 @@ static ssize_t shmem_file_splice_read(struct f=
ile *in, loff_t *ppos,
> >  len -=3D n;
> >  total_spliced +=3D n;
> >  *ppos +=3D n;
> >  - in->f_ra.prev_pos =3D *ppos;
> >  + WRITE_ONCE(in->f_ra.prev_pos, *ppos);
> >  if (pipe_is_full(pipe))
> >  break;
> >=20=20
>=20>  --=20
>=20>  2.43.0
> >=20
>=20--=20
>=20Jan Kara <jack@suse.com>
> SUSE Labs, CR
>

