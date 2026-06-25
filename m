Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646C4CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398AA6B0095; Thu, 25 Jun 2026 04:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349796B0096; Thu, 25 Jun 2026 04:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC6B6B0098; Thu, 25 Jun 2026 04:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D89696B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:35:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D4D28FE08
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:35:40 +0000 (UTC)
X-FDA: 84917776440.30.81B7ABB
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8CB4DA0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:35:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TkSyN/aC";
	spf=pass (imf15.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376538;
	b=NCUl1nIia3QJjEMpTh2GB9gElEld0I1bqsUgtw9OUmZKnHIb73qMIP6uCsLXP8hE6gdBN7
	5Xcd4RvE+9V9TwyemGp2h/fz4Rnz2oVOGFbh9tWUzuj2QtYe+9ZJ2EUf3x9HDgiwsqV2pV
	esoI/8woh6B0ioG8Ug7dXRNGllK0jzs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
	b=VGnwXDj9ZpqJ/6WtZMVZg74y6h7Wn9V/kz6jFhcSnAI2TL0qB0FYO3sZEANy9Vo5cR00WW
	br+jbCCX4SaODZH3UdhXO8OQGbSIZq8FWCOm3Zb8qKaOhpG1Udj2pvI6xiSBBe5adVLjFg
	yGHpIddMU/aVTTPAtCvhb4FDda6W9FA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TkSyN/aC";
	spf=pass (imf15.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4626fdc829aso1535787f8f.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376537; x=1782981337; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=TkSyN/aCbyX8OSjIqvii7uGcMzUCgQoigJdcD2XbHA6hbdzSZXy/5Nf1Gg3VoXJ86N
         7htN/eKMuOihu/a6oXnppqx1LvvQTtBYRL3F14f8MkA6Ts4S9xjxzJJ/GS5OvRFIUJz8
         eh9W6ttEKEh4JfOFc0CoPuYeOy+ZBZLoZBhFY2PsY1qGIOTVr5WGzsHz2+5nYPZ4Ws6z
         WycHvxc+EoAOAeYCv0mA/pY0NoHLe/p6/2E2h1BIFUPYYc44I2Dcu95uz0wtYIHQWaxn
         le0NkLkqnWe1a0K7mkdd+qUaORCY1ELadg7j4DnDyn+QZyyV5se9oaX0Wq4yLQvhzq2c
         qVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376537; x=1782981337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=tDC9awt+LxdhM8HDnPk/drdWodxYWFFxndBufMEn8ediOG3vpQmb7CwyeXtR0qpj+U
         J1coLomYXLq28ZB7HL4p96dlqn8O/FHE/jOJkdY/wL7zH2Ia5q9uewnHuqcQnfZrmUpt
         z3vS6GW8pHvhYRcYvCWdcszFL7nVzTbZu+XbAO1nLlCZkyxrtLfBo85iuxp/krOa+0Nw
         qjGfBwOBmXolYtFLMB38YFRNIOgAAcsXzI/UuLZtmNovJXab44x4PCzHxfThGqnFGM/f
         3LwRB2NPWeJuzFkU2M5+wnERaFKWQJbC0vbP4hEVIO+gTO+V0IdIRiFhKRDMED5H92XZ
         4SrQ==
X-Forwarded-Encrypted: i=1; AHgh+RpinULhv11FEAOFATh15oamcy+nB/TTSUkvWs2GNYN1Gyn7yYGkx6yc79Quau936vfbRqMc1oZ7mA==@kvack.org
X-Gm-Message-State: AOJu0YwLlCYJ8PiBYi6HGXOpyPXG0q9jTQUgmsgJ0RJdRikOwEO6ZScc
	cTqDce+4XWOyVZEuY9gcYuExvwNKJeGniqKiUm1AhBGZnE9CqOSJmXNq
X-Gm-Gg: AfdE7cmo5mCLIB4Zk6Z2eC3LGcopBOte3CSweHI5w147c+e7dz01LjHK1DX5RXiFz1p
	vUzP0NyhCK9emIic93bGnM3MSoOvMKYpOmxxPoxA6AaZgMnDcI0BKDXmJRyU8dIU5koE2e8IPpT
	Ai9sOFMMM1/gawwLfXSmAAn5FcJWgGjVFEOjUfdd8v9gTq1rzzKgowFMMNVqX2tSi0hPITLuRof
	MdIIW1nBcKXHVr6pTKG9z9hIGa+H7ruHSienGE1kQ0XOSpjDflFW2Jvo9PedO8bSE5uJXcUXDGn
	lU+M5smTYPEtDtL5n7GbqOviKdqwaie11mnmjK6cb0oxv77oCNfpoqMHj5qfnwn7mohu0hbeU2d
	axSkB4p1fG8jVAa3nQrHiL/HDPLT/j1zyQeR0JgexGymbu4777G1cDOlIu+0hkV2lAvUm+Xra8e
	4y3WTbKVYA
X-Received: by 2002:a05:6000:1841:b0:451:3b12:9bca with SMTP id ffacd0b85a97d-46dc20763ecmr2315779f8f.25.1782376537012;
        Thu, 25 Jun 2026 01:35:37 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c2279b85csm13357402f8f.28.2026.06.25.01.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:35:36 -0700 (PDT)
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
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 2/7] vmsplice: change argument type back to "int"
Date: Thu, 25 Jun 2026 08:34:04 +0000
Message-ID: <20260625083409.3769242-3-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CB4DA0002
X-Stat-Signature: hjibhngtkmdfak3ysi41xzf7xzdoo6i9
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782376538-340919
X-HE-Meta: U2FsdGVkX19zu2nF7F0GrJ9MFSPN5M9CcrTQ/2cuZ8lwQkZnFoiCeDQWDKMBF1BQWjDjhzNMIqEPrYwI/2KejPMDI+JHSQbde9s88ZGUmJYNTm36WolAtT7aT3NRUIF6wN0Ha35oZjLqGC3bZxI0JCfc9CkicdtpRdjQ9kfnnTrYSG2lqgy1Q3O4pFv7gjFO3EjHzYedFDU7JbP3gCQe68YwRMTVyU/6CUXcsHSAapxfF/JkR7ztIJAS1x/k8VAiorTsGhlgmBDzeuH0a3hZEtLuLl+Ec6azdAGFBmPUXf8e2ijnM4WK0HMPEO3cg3tRZXrFE8Dl/t0Jgyf+6AmE1Gf4HAypONTzWWF7P4tuUmWRSCIdq14gaK6ktpO7ZpfTX3VMis30MiHRTPR0XkTV6qKoLbE2B3d/oX96oHLv8ijkbClXgcrfvEh27jAiBHOmUo9x7dcxFa4BUcxDbo8kw9foh4eX5jvLwriBpbaYeUWygNvUCajCk40WxSu3T7NDeTI/tnohtay5WZmcxkoB2I9Yg9meWqsSppQnUFwhplk37uIhsMDx5ST1JeN6fmLO5XisQAmkSrpoiMiAk2wTf3W+aQjnoYdch9ebDEQlWI8XBs/fUr2fi+/Dw63Y6ydzS2xSBZBLtz6b3N90O/S1POosEH5MpSsUMLDIxl8gv7VjzUGwBdr3UTfUiv9wGk0ALeML/KIeh3GqpGx5MTIkhDabDV6oreemz9BVpd5AZ9Anea26z25F6G8WPklC3Bt355as0ENt5ff3YZZeAwTHJA9pcdGb2qNtNH/a4SRZpwxj5Gt+8BbotyAJuN5NJfQFen2GLxT+OKexHbdDlL+ADv5g/wNsAF1Od3tbUOLcaEKM4AlPQ283G6ekZhLMrvSx2/5/fs7Ps1djsCxgkV53d2fY/2Ug66EafmCaDuv9s+b1KiPLU1R4KOTFnMbdIuIc2xDg5uqfnmP+dyp473Q
 gKpZjYyQ
 7hO8niGb+EuOYSnDIVJnlWxaOJ2AQKd/PkXfe3sE1H9CAX1MCo9XxhxpBo7PTfUSVImg+0OQfweG44E0Sz0auczTDfnb985/y2rEKV3U448f7UQY3yPymm3BLdEJos0qCIC1M/ZK0XOkuW9P06IUlM/onI2q1IUxAFQREBiOvjf7Ll78ETnamcbvwcYnYNX/qaSOIe5nGYWVFGpriF4GKWYmYX0ffCaWMx9vwAcS6XE/5ZpYNnpiFwfDR1iFAIOjQaVIfGuWK5Vzkd99ZEza9J2Sdu/vgUjvniVRAYVewOdWYfNORdym+z6OgNfYHYb6aXDJnibzmqvqKRUkk4/dKArG8LEspI2b9vPXgaerLQ1KXOoZTJkTr/TrpGohkaNAwQVsqHiG7eni2dOyMhu2PAymKMf4W/w1O+hoWH7v5az1qR8rMSsO2XpoYz7XUNJhdW7qmKDIkCkjhp5bH+t7+ll9ZHgI7tJ1BLZMMzfw4zHswaKg=
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


