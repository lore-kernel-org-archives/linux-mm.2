Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE869606E47E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=QdRavS5x;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6O67/YbB;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=QdRavS5x;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6O67/YbB
Received: by kanga.kvack.org (Postfix)
	id 061906B05BC; Tue, 10 Nov 2026 08:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012566B05EC; Tue, 10 Nov 2026 08:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42D36B05ED; Tue, 10 Nov 2026 08:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3FFD6B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:18:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 602991C4113
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:18:43 +0000 (UTC)
X-FDA: 85419264126.29.4FB8A01
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 007BC1C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:18:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdRavS5x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6O67/YbB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdRavS5x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6O67/YbB";
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794316721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAbAW3qeJZAP6QskNB7tR3/qa91VOiDZlVSFyr4yqgI=;
	b=b560BkHcgmFdZnkl4oDYro3td03v/+H4m+7UggYI9hoJeWxGP4BUwmGNfQ0pivqzg6wKkF
	swMW/eK7vi9kNDC7cUF3/EN0LGlEeVMxF/9CylW8v4gn/PWpanExuc9zv7QflIYdmEDn0X
	+jSvXpcb8Y7AJuY+PLrfknv4/ThP1qU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794316721;
	b=m+3UuBpXyCmuqrxZlawfFs6o6CLPo9QRPmz9gQ3HDRmh5H6cWXPZYwzH0XtRtGYyO3lME3
	Qkn7ffosl3Qy/wxT5lO8D0wMZejp+X4WM845BVKxdWuHCkdG8QfBfFZNdFUVGeIxDWgmGj
	Gz2XaRoO5dwOCFDm0+emouCdwyCdR74=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdRavS5x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6O67/YbB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdRavS5x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6O67/YbB";
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BEF5F21E6E;
	Tue, 10 Nov 2026 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794316719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oAbAW3qeJZAP6QskNB7tR3/qa91VOiDZlVSFyr4yqgI=;
	b=QdRavS5xqlATb1s+sVg6bj292V3RFDt0Gmp1SVZq/3eZeH2qP7esKRlzGkd8vQ2TjtN19i
	IRRJ+QEwh0VMmLp6MmXOOqisKyZeceiLrvnPqxt4LgK1CE1ieBtwHYmdGI89MeEDKRUb1g
	8fPaKk1lk5duRm0PiqZwyw/l+YJAros=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794316719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oAbAW3qeJZAP6QskNB7tR3/qa91VOiDZlVSFyr4yqgI=;
	b=6O67/YbBFDLVhjNO4m09jeWOXXEfdkpjfEyLrzm5X1SDuZdG52rcOFI7TbsrOXg87es4bA
	72GVCG9/XJspWoAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794316719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oAbAW3qeJZAP6QskNB7tR3/qa91VOiDZlVSFyr4yqgI=;
	b=QdRavS5xqlATb1s+sVg6bj292V3RFDt0Gmp1SVZq/3eZeH2qP7esKRlzGkd8vQ2TjtN19i
	IRRJ+QEwh0VMmLp6MmXOOqisKyZeceiLrvnPqxt4LgK1CE1ieBtwHYmdGI89MeEDKRUb1g
	8fPaKk1lk5duRm0PiqZwyw/l+YJAros=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794316719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oAbAW3qeJZAP6QskNB7tR3/qa91VOiDZlVSFyr4yqgI=;
	b=6O67/YbBFDLVhjNO4m09jeWOXXEfdkpjfEyLrzm5X1SDuZdG52rcOFI7TbsrOXg87es4bA
	72GVCG9/XJspWoAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9362E1339F;
	Tue, 10 Nov 2026 13:18:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SgLYG68Z82rLWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:18:39 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2263622503; Tue, 10 Nov 2026 14:18:39 +0100 (CET)
Date: Tue, 10 Nov 2026 14:18:39 +0100
From: Jan Kara <jack@suse.cz>
To: n3rd <18670333770@163.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Jan Kara <jack@suse.cz>, 
	Amir Goldstein <amir73il@gmail.com>, "security@kernel.org" <security@kernel.org>, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [SECURITY] mm: mremap/remap_file_pages skip fsnotify pre-content
 hook
Message-ID: <obonr46juxfewuiymsoujvc5bppqhcwawuoj3ftmkey5xbniug@hlaentzdza7k>
References: <4f296d67.bbe3e.1a1c54655f8.Coremail.18670333770@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f296d67.bbe3e.1a1c54655f8.Coremail.18670333770@163.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Server: rspam06
X-Stat-Signature: x9ix4ecnnbry1m1h8hyzikr4bb6uaw5x
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 007BC1C0004
X-Rspam-User: 
X-HE-Tag: 1794316720-826952
X-HE-Meta: U2FsdGVkX1++39RTXTudUco9EMlu9pywORaK5ZOXC8qCKBeCKsFg80HtJGFxbTmii60L/S8sD1wVcbCq1/fDyIMOKypwwAxdcRGWYiCSzfGEDPl3YIuw+o8/qp6ArORs8PGlGgIURnKpg/xQUCs0FU0gdV70bJO0JpX2eE7RVPzstpFzBzl1xyAe3PHHuklb9QKopU4g0FqSignux9udRq2OGZ3bRYwD/jgfblbkfGH6o9/LIO3Jw7a2fYihhra77YEp4fRzOonFt4iQq3LgZEpdWU0mR4ChDEL7hdC6l5ZDIgKVxDu1niZMpMRktqOoron6aAC2/wqBVZrASOPn7E5eJCkXhAJV4/AoLFb3eTbBrsXVX6p1U0ySX/RbD3EzkhFoVdPq6RM9iOTQw7KY0JgRq/XK82FMhINmV+KHq7JAfv4UGmbK3jnLWYRWZ8AxLjnYx9myJaxQTeMRJRDQVTwIUTg7UXQxJdjyTHEWDIxU0es6d0AJd+Syj1RzBZAffOoOmYv4PCrGH9pW1/CMyCMGhu3oGzJFfXyIyhuHC8goB05ZD+39EdkSOD4j/TVj+FoGjTwKjBhxMyu1jYaKvBsBxMUkaYgU4N6WIja1BA8cyE+CjDWlSq4V7/FWJaSXXOK0Byo32YH4ZkXASduJf/x4Bpn3FGIZxlLyJYoYAIg8uUDbOhZnuhqBAI5QYksZAsam1VMlYXyisRusu1+m2z9tHuelA3MbxzYLbLKAn5j+P/gk2bkRNbLKZ3/6moJBU5AHk01D2f5hD9HQj3jHnIKAnvAPLXnG73MV097rSphPGp2Ixe/EPMrT2WKNZgUmXJkPc8bZahe4ZeVPJI9Cv0sAiRtGKwxoG3VzAuj6PSJxw6lMj433qw6vC5HQ38lNBxG8ybEIFEgVoTL/H9FUk5lDugt7R5XQ8tTzZ6s3X/DD2zjbNmOXopGgjFriNNi/XGq0v4IoI0+1CqN/kBP
 NTFSDTjF
 a3qyqwKK7nPCr3JJA4DkHGeND5Wl6KY0WgE/HPeUnzb8Ecoxc0cAJQ3HIRflac3/aaqPTbagdHRhWWjb16bfv15tLPCZ8EIBQa7IQlp1HI6ccLEYnhbx1H3V7dqxoW/b3E5PcgjPhpkHKheiUe4Wc46HyRC3r0Q+4jJSKY6eLlW5rcbCYoJIIa2RR7CDGv7UpQ+JNVjR9AivGJ+ETqlqttjTiXFrvUPHa0lgQDeSWx6+IedHX+P2rMpIH/g8A8qpNwXG2spi8a+boJf6PehPV1cpIZ2BTktMGgQmo8ndwumnlh6sHnnOZFMfjBehy9xYYopSxY2PLcDkNhrxiTUrzcWvoROy5zaU1Dx4KhiSr0/u9SnKzBy60jW6QmdeyJQSX5QoxIt+87wlsdZ1sWqv+9/GgDiuCml9gXxGHjK25OGg0jbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello!

On Tue 10-11-26 19:44:43, n3rd wrote:
> 2. Problem description
> The pre-content (HSM) event contract, as stated when the feature was
> introduced, is that for every accessed file range an event covering at
> least this range is generated at least once before the file data is
> accessed. The only hook that emits that event before a mapping is
> established is fsnotify_mmap_perm() in include/linux/fsnotify.h, and its
> only caller in the whole tree is vm_mmap_pgoff() in mm/util.c, i.e. the
> mmap(2) syscall entry. The page-fault level pre-content hook was reverted
> upstream, so the syscall entry hook is the only remaining gate.
> 
> Two paths turn new file ranges into accessible mappings without ever
> reaching that gate. First, the mremap(2) EXPAND path: in-place growth
> goes through expand_vma() and expand_vma_in_place() in mm/mremap.c, and
> move growth through move_vma() and copy_vma() in mm/vma.c; neither
> mm/mremap.c nor mm/vma.c contains any fsnotify_mmap_perm() or
> security_mmap_file() call. Second, the remap_file_pages(2) emulation in
> mm/mmap.c calls security_mmap_file() and then do_mmap(MAP_POPULATE)
> directly, without fsnotify_mmap_perm().

So this is about the useful content of the email. Five pages of text is
really too much noise for this amount of useful information.

Also what you report is indeed a bug but not really a serious security
issue => let's deal with that in a public list.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

