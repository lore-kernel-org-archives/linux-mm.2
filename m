Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F043DCD6E4C
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 01:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C08B6B00D1; Sat, 30 May 2026 21:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197A56B00D2; Sat, 30 May 2026 21:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADFC6B00D3; Sat, 30 May 2026 21:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECD236B00D1
	for <linux-mm@kvack.org>; Sat, 30 May 2026 21:01:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE5D11403D6
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:01:52 +0000 (UTC)
X-FDA: 84825912864.03.0201F39
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id CFCF514000D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:01:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KXJypvmU;
	spf=pass (imf26.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780189310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zPl6w3uFFVNTR71LIvI6Hm9g27LWiqb2gsEEN2QBH30=;
	b=f62MY1uXYYSwW2D92KBVDJGrbUjOlDrBxSAUWeWWsWkR8K3YzjEnZq4azQLqyDKaOF10qt
	D3bE9boe94TrbkwFg5yDJs1NAT+qHHkhBW4xT8ZvczLE3xsfzjLeLKgXI8FPABiAREY2k+
	xaKmGbWv2v4HdWO6CneS+hlRRi0cElU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KXJypvmU;
	spf=pass (imf26.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780189310; a=rsa-sha256;
	cv=none;
	b=H9Qo7vS5IegZly/oS7ZmDBsjjuHbjV2yx2y+m7WSREPcmZUIW5c/ZHDoYA0JaAqm1mcAZ8
	DNusx+FrpykbVM4DQpUmZNgDG1oamcq0qbsD1ngab4KaQJwVChh4tIwV0XmLZmjlg4mRq6
	APysHUtAGy7FYvkWqDIeJa21fAsYSeU=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49041e84237so72990135e9.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 18:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780189309; x=1780794109; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zPl6w3uFFVNTR71LIvI6Hm9g27LWiqb2gsEEN2QBH30=;
        b=KXJypvmUWzuKCdwIqiJJ+GCc07+oWWjcnYW/Ut4c1R+skPSTxdHytaHi2iK25n1F4t
         HqQ3/yZ76owgJd/vBJ4WtWRmyuuGVUsB5hqIHm6a0QzfJ8agc5VEXIc4nXk3xDsdob8Y
         UOqsG13aAlgCZNV7rf4vNM8c52+Rw8/lXKVzd2MmPVy5U/cn1NpF15dSBgUjucx8v4uW
         1TP/O+7i7D1DBplhu0wR0TV6KLqeu90iNQbtT2fWUpd5m8lSVcv7m86FS04/LU+KAW8Z
         5zfvDpyKsqIX+0COX9RWsutofL03oSiKx6M5jsJAQ22v3fzFyTl2R7ARaqkrE42DACgJ
         LzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780189309; x=1780794109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPl6w3uFFVNTR71LIvI6Hm9g27LWiqb2gsEEN2QBH30=;
        b=XHInuN/US3WpDtg12s2rrWuzXOoD7JgWl/Ey00/SH/cyMkyh7vBYbL3X5nWgmeqo0E
         LthDZVFnVVdVceSfs/WsCGUUF/svZrQEowuSWtvgrWMXyn9Gw5YK8YMTsYfz4W7K6zls
         8DMUVf4xMq+yjmX03q6zCyDEcdN8pRMz8dJw7MAS9CbQYh6w96S5zWigeLF/Ghs108hX
         JYdOCNQSGVFkQ8/HSAoxyjtC5Adaeg5xkNaJQ8r45ExeRe7VTQWij8XxbGPYQNhPV4WQ
         n11kMQbchXxJUwgov69n6VpqIPuz5RAgAB6PSDlaloX9vJ4zUjgzhIRPFcDLMDBJ1mjg
         S6Lw==
X-Forwarded-Encrypted: i=1; AFNElJ9e3OciGI0gFLXrtK84xxkUHfeVk7584CjJmbP9NmwhWFnK0v2JTpATOhhpRRxtRvCQUMx6+vMdmA==@kvack.org
X-Gm-Message-State: AOJu0YzfwrqvzhLKaZpwZ+bWpCvl4F7NXt1q7LcKVtJsXz3koxkdxPf2
	PvxelF03xO7LqSqPvv1/oj/pKy3sgeGd/jsQ+LHuknLLFoEMnkdqf+BK
X-Gm-Gg: Acq92OEFS63Feh12UIUGb06G7SLR9nICdQYojo4FejDwHIDBzAaO8Heit3HhydYsZqW
	Q7mXkAlcY+uQNS7hnL7+C6pjZQQLwros8bcTLHtu4fiN7Cum2cGzqslw+VJONXkPh8JFss8epi1
	HBQFOBcl+h6Fc8aynK+Bj19yGNbhLkpYV8TUnYd/RmTj1ucbmssZhn9O2Tz8gdKN2st8IdGmrO6
	doxeXkp20/dmwWbqPlhPHdaaMg780UCpnoTxogEZGyVmpI5muB3DHE/xvoLdTKEW/eTJUbiZlr0
	JbDVUzz9/IEKjuK+zPmnMaKWFEp+zy9qolPdvDhIZfZ+rLRe27RKzOz5gQK/ebBoJlDPUsDIrK/
	5kvi4ZQZ32vOxwmwV1gHKC2rPGIPcj7vf2sHwcVXM+VoKgKK+wKFsn8UdS7nwCIRyBgE9XueDG2
	XTgxbJhvYxRbKEhy1rDmZe030qYWleviPoZaiH7NAI
X-Received: by 2002:a05:600c:c168:b0:490:5000:917 with SMTP id 5b1f17b1804b1-490a2a02ad9mr75824695e9.1.1780189308943;
        Sat, 30 May 2026 18:01:48 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909cab0e79sm261799535e9.13.2026.05.30.18.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:01:48 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev
Subject: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Sun, 31 May 2026 01:01:04 +0000
Message-ID: <20260531010107.1953702-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CFCF514000D
X-Stat-Signature: 8mfhihtr4ycku6fknwyjth66cp7j9jrw
X-HE-Tag: 1780189310-85010
X-HE-Meta: U2FsdGVkX1+MHB+mYiKVas3Uik4reAH1iK2Iu0tOluHz7QaJ8vHDQMMZKnL41uPdwNVYvwtcMFwNAEScKIZ65v/99L5zsrBWp43RbNYaD15TG++Tb8NQqAyHfN/BtfErakWSWek++JGl1LUCnwpi6zBMEgNeaaogYteIzm/JlLOIeqsq1p/4QP9G3v8HWSbidaXswdI0yw9nazySjKuNHmcAHWIW20fH69PeeyA6hJBLAuHHGGwsyPknltwuWz1v3CKjUHzvK8oL+xmt8hg5Ld2O+mK56+YBpFAaa9TKgC5srWRW+a+sHqhc/vpAojq7xuBSpBKk5bkhH5qgtdA8QoBOUvop/xqxY4EUsJOY7p7w3efdcF3mjAKU1H1Shfz3m2T/c/tU1sK46oAYp3hWNHjNjVsWj0PwPLXQOAujP/LS7prdHqJ2ee438Gdu7Pv8YIBYdAFCjYIOmz7tamun1uR+NgrEGoBGFHkT07gYCl6+1XBZNNlp42UC940sd5Pg5S5s9xbk+8hjWk/Jx40h5A95/7cjik3Ug0mpoq6j+UGlRC0qsuTglhda85VXySZ5hrJyEAki9d1B6kH8j//MvHvm9hfcJmwLt3LVUrdyot2kD3BLoGtvyc7yTwBMq7FDcAELRfwkLGCxSTSspOoyL2LHd/UjHy4RH5IgPR5zS++o9m9DvOnWgIEh3AOB0iW7KRar4pE8yp2wsljy5/rARUQVJdx2Ox1fLesoMLYaeoYLTBu702l4OgAyY2V8uDBbl0TSkyqV0jcL9tHfAF+crK/gj/gMunqsC5xwqQN94ynU5viPixZ5lJzFhrs+h3JbfxRbUpuLwqX999LHCSzQAry4enYDWifoHNYLKGtCirO32uEDoBO+HLEHyLRkQVsSWDS6RBUbuewQR39PWAAKAZv+LMO6+hi80bGJKhlX94q78mkXjA+V3/cZhoAuo9+nydvmjqX5Jtp4v00Ogws
 zvtVjDCM
 DgQ+b1iQvSbWen79G2uqsDJbGj5XzxBw+z39Kn9aiYi8p+raGKRzRaJwFiTkrb5NAdgJKw1QlmHZlb0wIX1okNUv1VYoP56QOEj057dW3Z5LMrM1RphhZL5Kn8aNhHpEpIDcX95/bwqNQWsmDAr3CAXz1R8BwaoySKHks700Nj6xzq/RH4WL9Q+xMvxCwGmP394Yo1SOCDjyZ5kA79aziTu/4e22rLQFBdQoSQq3UaOXqHJSAH/alJdPaY/e0RoqsoRwrc5wB72l6NLOfCG/NpBQqV/Q4SFsjnhjiZORFqmvpha/aRdTgUJ1oEMzMOmvpzwLO1NUS7EJkBUTP8Mnm21zcoEpcK9fe0un3gJb7GW6H7BeJossD1tu+wVWhzB3iCXl6LKULXN3fzdbYdfHVP2NgjB5MaOzpebhcI+V7o0E55Rmti/7qaP4woOaCe28FCcXsHyS/toj08IpKqEKeaiqnrcX4Xk5E4SeylHrUF5n7rZX0t5p2mt1nO0R6jCRvADLZobtmjcVHbQtMH1iQiUyoQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is for VFS.

Recently we got a lot of vulnerabilities in splice/vmsplice.

Also vmsplice already was source of vulnerabilities in the past:
CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).

Also vmsplice is problematic for other reasons. Here is what other
developers say:

Linus Torvalds in 2023:
> So I'd personally be perfectly ok with just making vmsplice() be
> exactly the same as write, and turn all of vmsplice() into just "it's
> a read() if the pipe is open for read, and a write if it's open for
> writing".
https://lore.kernel.org/all/CAHk-=wgG_2cmHgZwKjydi7=iimyHyN8aessnbM9XQ9ufbaUz9g@mail.gmail.com/

Christoph Hellwig in May 2026:
> vmsplice is the worst, as it is one of the few remaining places that
> can incorrectly dirty file backed pages without telling the file system
> and cause the other problems fixed by a FOLL_PIN conversion, but it is
> the only one where we do not have any idea yet how we could convert it
> to FOLL_PIN due to the unbounded pin time.
https://lore.kernel.org/all/agwFlBKvKytjURDO@infradead.org/

See recent discussion here:
https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u

For all these reasons I propose to make vmsplice a simple wrapper for
preadv2/pwritev2.

vmsplice(fd, vec, vlen, vmsplice_flags) will
be equivalent to preadv2(fd, vec, vlen, -1, rw_flags) if you have
readable pipe and to pwritev2(fd, vec, vlen, -1, rw_flags) if you have
writable pipe.

SPLICE_F_NONBLOCK is translated to RWF_NOWAIT, all other SPLICE_F_*
flags are ignored.

There is a small change to handling of NONBLOCK-related flags,
see commit messages for details.

I tested this patch in Qemu.

This patchset was written by me, not by LLMs.

Askar Safin (3):
  tee: fs/splice.c: remove unused parameter "flags" from "link_pipe"
  vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
  splice: remove PIPE_BUF_FLAG_GIFT

 fs/fuse/dev.c             |   1 -
 fs/read_write.c           |  23 +++++
 fs/splice.c               | 202 +-------------------------------------
 include/linux/pipe_fs_i.h |   1 -
 include/linux/skbuff.h    |   4 +-
 include/linux/splice.h    |   2 +-
 include/linux/syscalls.h  |   4 +-
 7 files changed, 33 insertions(+), 204 deletions(-)


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d (7.1-rc5)
-- 
2.47.3


