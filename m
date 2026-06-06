Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C37CCD8C90
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 06:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B64C6B0005; Sat,  6 Jun 2026 02:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866966B008A; Sat,  6 Jun 2026 02:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7554E6B008C; Sat,  6 Jun 2026 02:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65C176B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:11:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8F8CA03C2
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:11:04 +0000 (UTC)
X-FDA: 84848464848.27.182CFB8
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 095B720004
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:11:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r2vF5enX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780726263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8r8X8oylGshLaIHIAK1kgCpu4mjI5I9eQ7pptBpGukw=;
	b=qgWSNfYNTxm6h+CVr/n9RP5/JH8J+JeKqKy+d83OKw9PUCOGAb38FSShsPvd8k1sKuDJCe
	rBZelqLZLZMRgT85BoAFG5AQxJ4HXJYsNQRxG1c3qNnsQ69N1T6FhhXQjE4x+WYJuHexfu
	fLIb351Ws4tiTKhQu2cC0lA4acLIPGY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r2vF5enX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780726263;
	b=aJNWznC8A2pUsk1K/DqP78RZK9U/s0i3DEtiDSStmnOP6b5At0nyixaNLi412Uejq0GXYn
	z2V1NzeDux/YnXm44E3e9nR5bVDLIc7lwg8pkjfcf+Q3L6TMu28Nsdqs+r7C1bTlK/UBFA
	zFS9Yh1TEhM9iJX+Oe3Lw/VERr1vlWg=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45ef5146b56so2342347f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 23:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726261; x=1781331061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8r8X8oylGshLaIHIAK1kgCpu4mjI5I9eQ7pptBpGukw=;
        b=r2vF5enX9GyieZaD5FHUy+0TH+J2wSW0QVdAzGrw7JiUwl73XeigjmqujW1QGwWyVd
         IVEngvM5yk6OkkpWa27It9Krs7jzR6/+d01znUi8+UM0GXjQnZmIBIS2nYPogIf0h9mP
         w0Dk0VnSDYsywe5dnT4xY6LY2irxVYIYm37VsBwvSx+mw/vHjXv3t0Vdbe2LORpCjA9c
         Z139TDpIPaWbKddalgs9S1NHrAlR+tcPBvmIFzgmqyXpv6wjlimVjpEaDvH6l//CsTem
         1H+lmtHMM/Fr1l/fnJxhKP/lZfGcz6MRdmgnUXFdFybaBs3hIm3jtG4PIsBYrYMUcznt
         7UoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726261; x=1781331061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8r8X8oylGshLaIHIAK1kgCpu4mjI5I9eQ7pptBpGukw=;
        b=suKvNoR+k6f9lc92m9sE+dB03JZzK80i3oBFmsQvL87mmfXNQo2By8kSqsrGKw3BYQ
         jKDfbikwSLGoFUI1z6gB0PvASxRhIy4yjgHqtJRMiKtjLfTKMSmkyVXhWCWo2YgmW2n/
         lJjX2UHXJFq+g6yoWsb4lJ28kWBYJyMeDJo9rTrJgKUdy/TzvHjxvUw9tmQSIvPiL7SN
         5Fe1hSD4E62/BM83AAcGsbuHPYy2owF3d8e6quWFYGOrDCLtBO3FMwNsA2aO6K2o6SJx
         DG1piJ8znldMWjPr8e4clhPJuyX+ZTPusdKXLARZrrihhVVGO4V26gV8FNUt87wE0mf1
         UebA==
X-Forwarded-Encrypted: i=1; AFNElJ8tIh/chvmTvmuKpCyCJXzU+ggBsMAs8e+lmvohZ7IrbdjDJrMS6x3jqVWNOGULTHiBbsaceDpVLQ==@kvack.org
X-Gm-Message-State: AOJu0YyR3mHqa7HigkENAew8HdQAUihjWEJch1B8jnCPaQASVta4+qdD
	wX+TZMf+VD28WNIWJNQduyVWYVs9yycZOJhIO58sitRBmHxx5C01vFqF
X-Gm-Gg: Acq92OFecOG7PO0+BkpzQlPYgEQn0TCKmSLdiIc0P4k3ztZUZi+YTLiXzbt1WWeum9R
	bFUOYXEYr4+pJcb2zT5UZ4l4HvUIv7CnYNhlU2Y+tyEmgBQ/DGuLs57G6Lou48Icz4CyQ1F4p3R
	P2ogxdeZsdP5HxZ5QqpKZtPHJeFmeqoChK0eU+KMSW16eXip4Wi8Y5OgxUai6QTnJqAU9kD9cLt
	rJpNrID6GN45hJl1kaITe+ICESOMKOj2XKiClcbU3TO6x7wxQghT3VL+oX/klkW1VfiUgPpw7oR
	gXB29CLjr+yJyBvPuaXMcv7is3CcgVXJzpP6ttAbgzwJrs9GjjBbOgTU/RDsqF+5mSR/qjtimMR
	r9ZF0fhPWOdupCAx84CJ5YGPFpR711ZKUCwj93XmTvwpUo+l8awB/HQWOcmqTV9k1VUDYLwpDdz
	6QLoMudyjN5sGkeyE6O3Y3K+Yq+xhMWA==
X-Received: by 2002:a05:6000:41c4:b0:45e:f5b5:885 with SMTP id ffacd0b85a97d-46032b610d1mr8361361f8f.2.1780726261254;
        Fri, 05 Jun 2026 23:11:01 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f360bd6sm34254711f8f.36.2026.06.05.23.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:00 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH 0/5] vmsplice: fix some problems in my previous vmsplice patchset
Date: Sat,  6 Jun 2026 06:10:26 +0000
Message-ID: <20260606061031.3744880-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bozhgn43o8dsdwbgasdueeixbp649t8e
X-Rspamd-Queue-Id: 095B720004
X-HE-Tag: 1780726262-173639
X-HE-Meta: U2FsdGVkX19qd1glDZszhq7M+bYnVrKDJcQUBB0LBmayRJuGeRcKpYqpda09OVizjJUbM4zu1eoMm0HxxPKxHsJ9Oj4zs6mtbVljSlxyFaO9boGhvAQpiSOAbMyRKLNE9pkhpr9pPmw6/PgnZ7VxXBd1zgaEBTd+vjFDXmIvlOJDbq02Lzkj+0wQ8hfgwH7HGRx6oYpS2rQw1bCIsF1xw0z5mhuSuIwgkuQUwVt7D0qWDMsc6bBvOJJMIxRdwqvllUfOSuGfE9jPSnYeQ9K5mjv4NaSfXHSuPRwSmQvV3gWAlX2ioX6xshS4Ms+wVNlknD0lqF0xfyRIIAq0d9WeRfdfDWWGNMQoJWv3OwI3lDHrtDSubm4I5jmdK/UBhlbXFoHFxYsoyrbsM8e+dCVTb4m2NnmIARSmf8KqQgg+yn+ek5uodVtBBMWmP/RCXmWuHZDGWt9qits+8gCUdqQwT8mB+5BVDD8BAuLK7uGO+i0ThIMyIEx1OaQs5tz7KbtWRzP2Tgb0oiyoPBHF15F/LFP4VqoZUPidAIpDCfAkglAC6DqFjYe80NGpUOLxbiaEA7VUGkpXQjrev+nHhbNnJOme9Ym/KMPJeQ7YT29OjlMGXGCb6qtqDe9J7Z8Q7PC5QiS3aXxGsua7ZfoV9uNVqxdOpv+ZgcmJnFiVcaESWtekc53xMS4GQiN2OqeO4kO6veCte0aJhIEVIPPtC8HrW0aG3MMa8v3KQjppcMZD/ZekG7/b4TnlBpi4/TeZEYANiznHp/byqt96tShiUU1iT/7vQTudsvk5kfSrQdC9NUk8nAVpUYcpChkpaWgk0G7lkWs11D2nDKiuC8LBa0XNvl6BXkvoyj4UohNuBzBu3xb7efOF/JhyBWIt19gogFCnaPgG8fxW6569e3MR52M8XP+UBtTi5yWAqbZDUYIu8s1zoyEP4BhDdZEdN24r5Zyu0vpDIlNJ/3UE5iEgCG4
 2EJ0cbq9
 4y1mM8XtNNblGE8rbIdzoaE5/CYj9F7l+L0/hELWQcDvMyFZcF6LyB06KKTd1FVpV3IbhHLOq0R219qxl72cVbJgGMhJdl2bmgKezaFJdi8o1B76zz1RKXUjhB5JJqMaIFFRw1iAqwloPCpcmTDu5dz7O6sykGaDt/ObOreqKGBSOoACVQmeTBwTZ/gZGUy1t/5tITv3bdstMA94NksWjSvgX4QN4fpPUgEV4deEKCHzLjEa8ml9kuYvs0HSrSero3a4RLIerDbKNhCzg9iEYpr0tYJDbRX6Jl/LAfDrxnIFGAG5xRZLZIqrHw2q7l+tgXPnI3b8yGa+ZxNl6BItBhYqWJzlIKDoFM7yPPvU+PelJSy/zlH0ByR+h3V80UWFkthN2ewv2UNJc2JcW8Z5wBo4Ic1cWAPbjsNocBSCtxYTH1zx3tcBuxZC8xINAFnIjAlRxJrdBXq+uFQswnTcyRN9Ryw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is for VFS. Of course, it depends on my previous vmsplice
patchset.

I fix some problems in my previous patchset.

1. Fix problem with CLASS(fd, f)(fd). See first patch for details.
This is probably not so important, but I fix it anyway.

2. Change "unsigned long" back to "int". See second patch for details.
Again, this is probably not important, but I want to fix this anyway.

3. Fix that LTP vmsplice01 bug.

See patches for details.

Please, run that LTP vmsplice01 test again.

Notes:

- I want to repeat: I change behavior around SPLICE_F_NONBLOCK.
Previously, vmsplice ignored whether pipe itself was opened as
non-blocking file. Now it is not ignored. And in my opinion
new behavior is better.
- vmsplice(2) now is in fs/read_write.c . It is very similar to
preadv2 and pwritev2 now, so I think it belongs to fs/read_write.c now.

Please, review this patchset carefully. I'm still new contributor.
In particular, please, review that do-while loop, I'm not sure I did
everything right.

Tested in Qemu.

Askar Safin (5):
  vmsplice: open-code do_writev and do_readv
  vmsplice: change argument type back to "int"
  splice: turn wait_for_space flags argument into bool
  pipe: move wait_for_space to fs/pipe.c and rename it
  vmsplice: make sure we don't wait after writing some data

 fs/pipe.c                 | 17 +++++++++++
 fs/read_write.c           | 61 ++++++++++++++++++++++++++++++++++-----
 fs/splice.c               | 19 +-----------
 include/linux/pipe_fs_i.h |  2 ++
 include/linux/syscalls.h  |  2 +-
 5 files changed, 75 insertions(+), 26 deletions(-)


base-commit: 8d86fcfc2857d64af85f5c87c193c25655c970af (vfs-7.2.vmsplice)
-- 
2.47.3


