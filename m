Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F973CD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 06:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AE06B0092; Sat,  6 Jun 2026 02:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951D06B0093; Sat,  6 Jun 2026 02:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868BA6B0095; Sat,  6 Jun 2026 02:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 760626B0092
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:11:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 440BFA03C2
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:11:52 +0000 (UTC)
X-FDA: 84848466864.15.315F89E
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6177614000C
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:11:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lQIzF8Cu;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780726310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
	b=WWJsIoh3PmTLR6hl8SAD9Q9C3hFvBal7Ju6BLpg0DtqzRa2a+7ON/4yOOmLkpyvVAoOEwb
	imXe4izgWFAT6i1kEFbmfdWgbAYaIOauDtXRCWxIkUnEHuF7bRQ1a5gOH5/z6MCWc1ncoz
	PQXpq7YdhyrkvD4i8NpFnTZlkVSteBc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lQIzF8Cu;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780726310;
	b=40mm0Qqz2ZZoHE61EfZ3lHN89paPyCbRAIaNwFMUJYckUTn5s3tr4MMl8ZFp2lATWpkQq0
	MWG4ZUGTjukQyjZY/1q1SEzHTsPrTflE/+aW/ANoQ19nxtmam5Liaqz0KXbzchfbD4Uua7
	U24wje4s1EQPMMOyjJ5B5NHKj+lktM4=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45eee266c6cso2062626f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 23:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726309; x=1781331109; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=lQIzF8CuerNJ6p+payhC1ifQiKf5cFZ8uty2bfxJ1t1RTovN2+yTyC/Np1Pg6w2Dz1
         fMPsdqOws6J1zyWNsEMIbQjeNuoTnsOrXRWEXYmZWXLkJk3Zicq2cbwZ9WqSc9bm9Iiu
         bT4zOl/5utllmUjy2Vfimb9VVR2iu9I+mojp6CPbKyA3bK5BXkE0K7W2GEgJrLYJDKuE
         U74xcbxrw35JqbceBnyQCvVbAbhM5vMFC1Lm5QoezYCtJsm7TReYLjCtJauJNemdxHVL
         40yxsLALY/0ZaZV5Lvj+zSuU6wPSyN2Wu0Xhss+ri4bqEwCs7jvP5xe1/SpC0FiGrLHv
         VtTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726309; x=1781331109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=b+WZzYdEAMLrubQf8iSHRBqiiWmOP/Q+71myNMETJyzumIc8DB3d5xZhqv8uYDwdWK
         FOa+W9ROM7aaWY3xiiLu830CSRHGgVfohmwtlLrrm8Cv1t2Mqhh00O5yVp1SkrBfZepY
         JI08fRXiLOr46k4gNwfEyb5+SHjw8tZNLoanDJgXiVgM5hh/bSa1rLbEfYjTGnDSbcNu
         LYchuz73nFE1gimM6ICzSl+IRMNdE1i34pf00GIZysxSzbG0BB1nMLCvEx/1CnMJK8Cj
         QX49DqG+1VqnIEdwE1xQY/jqEXQxPGRZevGUUJeYF1D+Go/NKYkK/HYaZAAT3h4YFN+d
         +/ig==
X-Forwarded-Encrypted: i=1; AFNElJ/q2g8I1zahb4oY8fjDQl+8B4T/RskrBenDeWXDc+JL6b+GP2yz4NrqdD/IAzih/wMkSzmdspNldg==@kvack.org
X-Gm-Message-State: AOJu0YyIGPk4TrYCJ4hzsX3QVuVeKGlgmAOQTUI8EE5ab1L5Emh7rlMe
	IelHzhycuPjoCFxu5aQxOXBzvpRfBWNDJlJ2F2uKS6tevUXCI4IhHt2i
X-Gm-Gg: Acq92OG61wqmiM1A0ngWzxUTqkEf+aAyJ/l2Yd0zdXlhAqz3RtXlan6JysEXZ7Rkjwv
	Sio40WKJBIvrOfjUzlOvcnXDlVjepFYuk6V1fx2dVjlO61Pg97PCWHN2/qm6eKV9e2AofByapen
	XY9MbO3Vi7juVT8EtyCEHtontocBj2QYXyDq++UPE6qYMXbhZXxoDVqwfdMDMUcF/+JtmmE+KKa
	R86AxFPO7Aa9ayK76idwsGv59cYnjKAF9fbUvWkmXZhC62eZBZNbybe9KUoQblc9qpfp4QLgorJ
	VS6LzSyJIOORxMD35XcJvPtvEAJB6ZlTqYKn2DzGKzkD1ENmbi+He2kpw968283AAM6MuUvbk2P
	reXwccAxpX3fXLNQeJAVb6ChZbSc9FAjcyxplWOVPJqtkXuFZP2dG/XiV1xBu21qDU+u/wbkIwF
	MkX6Ep9ce0PwUjLBXs1Lvx//fqLZV6nSMmJRuliPJ6
X-Received: by 2002:adf:e014:0:20b0:45e:f29d:d438 with SMTP id ffacd0b85a97d-46030618a38mr7876243f8f.28.1780726308885;
        Fri, 05 Jun 2026 23:11:48 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46028a6dce6sm24115947f8f.30.2026.06.05.23.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:48 -0700 (PDT)
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
Subject: [PATCH 2/5] vmsplice: change argument type back to "int"
Date: Sat,  6 Jun 2026 06:10:28 +0000
Message-ID: <20260606061031.3744880-3-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6177614000C
X-Stat-Signature: yh1rt83wja6pf5jms73yyuozaqjonwf9
X-Rspam-User: 
X-HE-Tag: 1780726310-561536
X-HE-Meta: U2FsdGVkX1/OFD1KsHDn6ECQCLRbP5I1+rGFFd7gzWpby7NxwpoGlRpcH8RyBSlmkTB3xFmbg9N89NkDhA0zCrwZJ73V4atgdABxkAcBp3GbeAuYy0ARo0zDSuJcp0IsiOr95pdkRoTWVf+XdEeFfPW4/AGIc2XtdFARYVgOMR9X5XS33rOpmwznpsY50PR6su7hL+jGkk2SsHdS/ZTh09/wdKth9SqgTmBpnQWVsXvJZcPzm/un/DvJCprJoWjhOcZtRaxU00hbHOvLlXEOjsERA2jNe+uTd0FhW5JhYT7+g2+J2WNB69irJM6tyzCxS8oqBmFp0AN+8Ikbmpdc8bxmZChTI7tIHeP5AtrHUAxAfSj/heg6qitG8DugxvgU3RD4lrk0FZ56vgQqr+Np2dZvTQXd556v7h9P/FIolphid4lSz1MR6uOSwfrAz5QrV6P59+2tJZr3QWkWEGmsVT+lAtLNBc9o2R6FmhgF6vzyKRaPsCLfTujTQH8q/1uNjMXzqQJom0Iqk+slxlemE/lEAU+Vlr1fa/D4BCPMpadwXqGt+X40z7mh76yC2DA9DbYjn6gcNwvqQRtfj9UfyoIb1oM/KaTX4p8FKu21tUw1BHTmwkNARWvBAX0WsiRJ8tTlXXvSq8xzekHEFX3G9y+JZoktrBkBrLvtjsujWz2mLgvtD4wttD9PzHOQCuu55G6VBPmWsGpTJ+s+uOPH2SPdf55DCKTgzfA0hMsau7aIQNC0E1onrqVareV6tNnzcQkhCRKJUxDXFPWMmzBF/tUh42+eZVBmAmoqWGUTDI1A7M/5xyY0T00nEzTnes7a9UqgGVdZXoD/QeSDgocJVwK+nonrFmZ4YDNtDAgOT7LQWxQeqfHdeZU0vI0YDMYiZ/dTMjSmBx57ARH2k3VoxfMxKnQ2HVrGIuDktbUwYiZp9WoqR8eW1dbmMJs0hM+arICSWWY8Ab59agfKur/
 hWldHv5r
 Ok5a9gzJVSGBOFTRoo9cdp4/aBFULlqid9EK1xDilS8jEhJ0v/AiuDdNDLr0mOK6hCOLpFfCjx5nbB+PSJFiAmBKeNF2wGH82t5R4l6R/TOOeN7qPJlMm6O3yl9EFgqzueCivZ8BQr0amr3yTeOujCSEKBOgKtUW1S9JWG8HYrzg23HjvVZ4BzMN1pKsUdPl/zFPuZhbQesSyVcswjNtT2KumNZ7bWFQ8r+gC79koRyTieN9qQbCWYezXwPoWv3YkfNkQaGd9vnhxz33arSqVx3hrTFHwa8TCD8nuaHrjwClXA4JFlH6dYFJyfUureYEK0SHtguhKU9mohpYS5FV6EUVbCP4fijoBBsjB2Zt3+14+vWjXMx9X2Ndau7irI0kKVkrTouLnO9fsFCrnvpnEFQX0tnEKpjhTgfdn501smH2NdNcdX8gytrnKjRpxZCtXNtE3vk/dKFu4GlhKMTqMwt17I59GlpRME46kHqdbl/AMrTb9FkcT2yPcRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

My previous vmsplice patchset changed vmsplice argument from
"int" to "unsigned long". This may cause problems, so let's
change it back.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c          | 2 +-
 include/linux/syscalls.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e224e7cb8..77487b307 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1218,7 +1218,7 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 /*
  * Legacy preadv2/pwritev2 wrapper.
  */
-SYSCALL_DEFINE4(vmsplice, unsigned long, fd, const struct iovec __user *, vec,
+SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned int, flags)
 {
 	if (unlikely(flags & ~SPLICE_F_ALL))
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a86a88207..46a3ec954 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -514,7 +514,7 @@ asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
 			  struct old_timespec32 __user *, const sigset_t __user *,
 			  size_t);
 asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
-asmlinkage long sys_vmsplice(unsigned long fd, const struct iovec __user *vec,
+asmlinkage long sys_vmsplice(int fd, const struct iovec __user *vec,
 			     unsigned long vlen, unsigned int flags);
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
 			   int fd_out, loff_t __user *off_out,
-- 
2.47.3


