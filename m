Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D8ACFF4941
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 05:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A066B0092; Mon, 30 Mar 2026 01:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB3F6B0095; Mon, 30 Mar 2026 01:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D10F6B0096; Mon, 30 Mar 2026 01:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE286B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:19:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8DC4C2084
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:19:50 +0000 (UTC)
X-FDA: 84601577340.03.2A916C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8C15218000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:19:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YrYQd2N6;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774847988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfzanPImVBxUZYk0hGCed0rensFpBKfhyF013Y1fyMw=;
	b=qXH4fMKrv7gdM+Mb1ulqa3E8mTVIGli82V9LA2j28TniQnP+vfcUjSq6KYuvrFIR1REVKt
	mwnvQrEJ1jgX6Cv1luxDzULXJdWpFy5/86oQerT+dDhb6HPIyGK3tffvbbxWwTfXaKWSlB
	n76mtZEoYgLqyTUhFTYST6MVPb2R13Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YrYQd2N6;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774847988; a=rsa-sha256;
	cv=none;
	b=mCaHC/OM56vistP2KC5mHw7iCbyouxhGZ8Bd+L2hfwPT86F1EmbqdQmj8Yv6LOvM6xp+yD
	FDUA7Gy/DQTNt3aKdBR/jfosVYZLpcGP73TIvHhDRT5qKkHPslZSaaHEzZY3wqjUliaqQg
	RaxD/sTffkbvU75gn8unsWgig2PXMyk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774847987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UfzanPImVBxUZYk0hGCed0rensFpBKfhyF013Y1fyMw=;
	b=YrYQd2N6n7kr3FElBIa+enj4/vUnVXDrEHr/yx2m+LriQISmpKEbjezYSMHgrHZAncdK50
	1XoKxoa1T2gPRiu9FdYYV6NdfWpTpgXWpdQ9KDlnruGuTqnzzmn7aST8D4MbrNgtVNxzW4
	F4qvbasm4QbICDljdFb1cQ+c0tSFU3M=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-P_rrCNVYP4OheqmGVhvMzQ-1; Mon, 30 Mar 2026 01:19:46 -0400
X-MC-Unique: P_rrCNVYP4OheqmGVhvMzQ-1
X-Mimecast-MFC-AGG-ID: P_rrCNVYP4OheqmGVhvMzQ_1774847986
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35da8eb0553so605956a91.1
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 22:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774847985; x=1775452785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfzanPImVBxUZYk0hGCed0rensFpBKfhyF013Y1fyMw=;
        b=PqiPM4Hohvjrx9BX0YWWTeyfiBFLvtw/WfYFifODjEDjghtkdOXkLpKG/nOB3WZ9uB
         GEEmUTjuxfGjeDjtnn9LHtVO+zMTnvvVdZts23ahwPjzCVznr35rz7uwprqeenyrWoRB
         BpknoR0USpXLZjbWcj6uzFfaiYNVeDhnbmtY9xw44vSXQrvqn8Od/HzIKIaM961b09Yy
         JBAFtqsS39FlZhZ/EIXf9Jk5bcZ1hyH157skatYSmAwyt9FUTUSlm05EhqU7A6+efCXC
         vcasJCXtGDa46l8OS1HEKo+C89/15XMyYp+Vp9n4aPzZWnXmQTEDRX3dfK2ob9SbKcOT
         NIzA==
X-Forwarded-Encrypted: i=1; AJvYcCU3uU2Uze0PCmxQXCEK3HDm9zv2WIJQ+TJ/ILc0kthQROTRwchc8X+9jjAWn+0o+lTiCcVevDilfA==@kvack.org
X-Gm-Message-State: AOJu0Yx2OIFhvGzW/JmjvA/npCKuKIi2NjUEC8tl4Bm6sJCCljF1Wu9g
	47nfrhWtAy66MmaI6s34Tq1ZsVse5Mw3rRKecDXFzyrQWqbIay+hPx1/eeQJZO5nehO9lKYlH1b
	CABdQVq0sa7tLR/+pSrQMcjlUcS7C3Pdug3IeBSSgtDkAi7qUokJHzjC57b3H
X-Gm-Gg: ATEYQzym+MLiJoOS82ntdNWbi4mcB03zKFjOWu9x0ufWJZ0fdhVsKSeI3WaiIwsFMY+
	F0m1etC+VDXv5XMcYR92Ma8fXRWIqJhV6pB6DZ0/3j61Y3S6nR0rjdApZBZkYxwVY+8FuFxv3gR
	mZXVpUAGtWMXn1DNPbpbVbEied43Fq6JAe5cl1s1CHxZSGuq3IIYRA7PUo2U3nrlHuAD3J3tPKn
	NoTIji3pB35QFoKPgN3YCJzV0baW6lMGoOS/4k7/3CzNCj8gGQztBVM1V8aju7iL7hdWMcWwHC8
	+JrkPVjaQFyXFSLiZZEH4w3x+frNm8L7LsLUaLIOnu3Q/P38gNT9cFKauSzRdPnBhhqsSGHYQl/
	SqWhSjS2UZkQ1oIhekw==
X-Received: by 2002:a17:90b:528c:b0:35d:9d7b:85ef with SMTP id 98e67ed59e1d1-35d9d7b8852mr4628504a91.6.1774847985112;
        Sun, 29 Mar 2026 22:19:45 -0700 (PDT)
X-Received: by 2002:a17:90b:528c:b0:35d:9d7b:85ef with SMTP id 98e67ed59e1d1-35d9d7b8852mr4628484a91.6.1774847984601;
        Sun, 29 Mar 2026 22:19:44 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d9bb7cb11sm1720354a91.7.2026.03.29.22.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 22:19:43 -0700 (PDT)
Date: Mon, 30 Mar 2026 13:19:41 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org
Cc: rppt@kernel.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acoH7TALgBmBkk2h@redhat.com>
References: <20260327120305.58653-1-liwang@redhat.com>
 <20260327121350.858a127fa49ed6e1eb4a40a7@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260327121350.858a127fa49ed6e1eb4a40a7@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qgHwtAgwIPyfTpz4-Stv81r6fD0Gn65p00kwnTl9IOk_1774847986
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: 3fuhiuf77zsg9qba4g8xqyzordtcut7e
X-Rspamd-Queue-Id: 8C15218000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774847988-851826
X-HE-Meta: U2FsdGVkX193nSM+wDUgd4J6H7/CEFs3qgijO3ZWFu4TAtBbzsq0jgEnjhIaH77FJqLUFVF3OZGQdJ4xwhCDi1DKgrYcI8iMeBrDdmuak9EyhX2SiJOtn+u1mcQfzrFmetK8jNqPBtZW0+UNDAmZe+x7E9Plg1gpV5sJgpm61gLQ/EW1zf126CS/IfaVgpXZC7gv5ZXXjXLf4knFcQhIPC5sXQDRBvcHUWPxdzr4NkjFcSKQe4M9Sd3cn4jjifeZ+8pOmZflNkub2lDCJxjCNHhQSXmorBJk42e083kfLXFvJIK0HoF6Mu2JwpsLZX8Sb3MX1APgG+gRQPJZ2wRc0LAwlpoZvY5QQM+/dfGNd43VLgKuYFYrwoiplnJYgJhYp9OPBiXQzMYIUOl6J2omnVtPiTPs6sfjF9idO1hPfQLhaNakVTsoTyD1TVNiFMZjgpojAsczQ4BQ+xy5hgCow41ZmV8KPFcMC15nMH7NcVZ++xp4zUrkIt3x4qPyncGnA02ojUMGI+vVCRahFWgDirA8t+gRfhaDx+SqpXtooViOFUrhhZPZlMpyYI2ln8ASECZ2EZxUlCazpGGfKbKir2KixoRuG8rZYy520MrR9n0B/6NH+56yTCqC8WzpwS/jh+Gs/POqENeXk2Q6X1QTwuHkHDtS+QEGjTfg9VsroI/R55EIoZ6IYrSjiF8/SI/D8jtik+hDj78SqCFH5o/n5MXrn1nnlIDDuHBn0JOzYiDw32eEFdZABgEnzrLV3/vKGWPyQYY8Ww0j5TQyddvdh+Vn794DwLy2g+ybavrQ6vz/YUNOfGMvAwNiYysMWuR35OO0dCDGDvAwiHTQYWs+kvxLbuSSxp71Wfxt0oK79KMTbyH0AiAOPOImApku4BkmduQU3CVJIpIBcg+swXWX6pCK/MjG0v2Zxj5AOCuyMOi8EB6U7VNAprAe3dsbb4OPfO2lLMr9fKYL8bwauRe
 tVnPmNSx
 twTt+bNJxinbbgS0pJO5kxQw/bDbzuR3foxWjBU3RZGxCNMkJSQ4q+bXZVa2WWwb0nAhTcBcXan0hzLDYk5T0seldmhyujx5aT93JZurE9BEllY7AQM3pqzx5dK7US93qr9PSIrvsAYHB/WubWGLBWL2325cvRYQd8Qn3r2AIdaZPoaqp9jJs0uGY6AcveO15Bg+BhhLd3TGdik/0DZ7dbTFEQLQ2stiXkGg1I2dmtMvcuiA/o+BdGs1Jjf+ctpC6PQf4EIY4gyhTO8mpfnXn+Q5mJA4Cb5aPdnMlHDNN8gmIeaagrq0gyksYZabSLREGHfMBqsvZ+jbXab+yrsn34+O+/eb/gumwqJHKt2g/2tmiazi6BbKErXciI3QqccDGmxVSBrSzvzqL8RdFoP7nLZJWaK7Bltp5B/EKnFsLopo+xmmzom3E0S48o6PgDdqnKPiCj171KUm7ETGXK+h2f9vkIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reply Sashiko comment:

> https://sashiko.dev/#/patchset/20260327120305.58653-1-liwang@redhat.com
>
> > +	if (writesize % dio_align != 0) {
> +		ksft_test_result_skip("DIO alignment (%u) incompatible with offset %zu\n",
> +				dio_align, writesize);
> +		return;
> +	}
>
> Is this alignment check complete? 
>
> Direct I/O requires both the transfer length and the memory buffer address
> to be aligned. Later in this function, start_off is used as the buffer offset:
> 	buffer = orig_buffer;
> 	buffer += start_off;
> If start_off is pagesize / 2 (e.g., 2048) and writesize is pagesize * 3
> (e.g., 12288), writesize is a multiple of a 4096-byte alignment, so the test
> is not skipped.
>
> However, the memory buffer itself is only 2048-byte aligned. Will the
> subsequent write() still fail with -EINVAL on 4K-sector devices?

TL;DR: Yes, we should do both buffer address and writesize alignment
       checks to satisfy all FS types.

Looking at the kernel code: fs/iomap/direct-dio.c, the only alignment
check there is at line#413, which checks file's pos and write length.

EXT4:

ext4_file_write_iter
  ext4_dio_write_iter
    iomap_dio_rw
      __iomap_dio_rw
        iomap_dio_iter
          iomap_dio_bio_iter

  390	static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
  391	{
  		...
  403
  404		/*
  405		 * File systems that write out of place and always allocate new blocks
  406		 * need each bio to be block aligned as that's the unit of allocation.
  407		 */
  408		if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
  409			alignment = fs_block_size;
  410		else
  411			alignment = bdev_logical_block_size(iomap->bdev);
  412
  413		if ((pos | length) & (alignment - 1))
  414			return -EINVAL;
  415		...

Sashiko points out the buffer-address should do alignment check as well,
I firstly suspect it based on the FS extra check before the iomap_dio_rw:

ext4_file_write_iter
  ext4_dio_write_iter
    ext4_should_use_dio
       iov_iter_alignment <--- do buffer/writesize alignment check

  842 unsigned long iov_iter_alignment(const struct iov_iter *i)
  843 {
  		...
  853                 return iov_iter_alignment_iovec(i);
  		...
  865 }

  799 static unsigned long iov_iter_alignment_iovec(const struct iov_iter *i)
  800 {
  		...
  809                   res |= (unsigned long)iov->iov_base + skip;
  812                   res |= len;
		...
  818         return res;
  819 }

But eventually I found that this is only fallback to the buffer I/O
when the direct I/O is unsupported (go to: ext4_buffered_write_iter).
This wouldn't happen in the test as it open with O_DIRECT flag.

Then, I turned to look at Btrfs path:

btrfs_file_write_iter
  btrfs_do_write_iter
    btrfs_direct_write
      check_direct_IO <--- do buffer alignment check
      ...
      btrfs_dio_write
        __iomap_dio_rw <--- do samething like ext4

  778 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
  779                                const struct iov_iter *iter, loff_t offset)
  780 {
  781         const u32 blocksize_mask = fs_info->sectorsize - 1;
  782
  783         if (offset & blocksize_mask)
  784                 return -EINVAL;
  785
  786         if (iov_iter_alignment(iter) & blocksize_mask)
  787                 return -EINVAL;
  788         return 0;
  789 }

Yes, here I found the evendice that iov_iter_alignment(iter) & blocksize_mask)
do the alignment check.

Unlike ext4 which never reaches the check for normal files, btrfs always checks
buffer alignment for every DIO operation. And it's a hard -EINVAL, not a silent
fallback to buffered I/O.

-- 
Regards,
Li Wang


