Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D565CD5829
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 10:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F129B6B0092; Wed,  7 Jan 2026 05:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFAE6B0093; Wed,  7 Jan 2026 05:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D947C6B0098; Wed,  7 Jan 2026 05:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A976B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:12:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73FE0B706B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:12:26 +0000 (UTC)
X-FDA: 84304753092.29.5A83B0A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0861A4000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:12:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QFDq+39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1xIkwc0J;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QFDq+39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1xIkwc0J;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767780744; a=rsa-sha256;
	cv=none;
	b=bl4xqUVEyFYy9jmV1vUUXAVWdYj0Ep/wfq9kfvtnkcIw+UUq8I86c0mv2dQ5obOGRF21hK
	sDRQRosGV31EPzKs6CXMybPlzg7Ivn+uyN5WzTC74OuBpjpkL6Wg3omQIfhb27LFAwg/Ma
	tOPRyR2Ua+sl3lsiyWoOHXzYuSqZ3J4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QFDq+39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1xIkwc0J;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QFDq+39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1xIkwc0J;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767780744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyjOnRY6tYvp1SLKJ5JK+KsRA6c7bJH9ig4viKI2uqE=;
	b=4WieIkIj82ZoB4LdVBRcqfS5adJ3ikpCVzkbExYCXT/3M5F8K9ULhGTlXAwmOKf9OvkxYE
	1zDmjnyDEXMdf7yIe7i7CX5sF/ce9qIuu2REqOqzVB/dxkEXxMYuSwZK6axFvyojaZZ/uY
	N1F7AoHg4zHBikz/iVdzohiQKhvxvHE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 73F8C5BD4B;
	Wed,  7 Jan 2026 10:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767780742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QyjOnRY6tYvp1SLKJ5JK+KsRA6c7bJH9ig4viKI2uqE=;
	b=QFDq+39Cc7oo8MwJC5X9kvzdCAs7F5gTkXwgDDInSioh8QXQXlDb1qgFSYSvwBtauL8ArC
	QsQD+xenkJ81NoU+vDAFF111htE7lk4tIz3upqa4dYT/nByhjztWJFH3hbN75DTkIaIlFX
	OxpJ8Bgm3iodG9WIcNEGtH8cZ1UnkwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767780742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QyjOnRY6tYvp1SLKJ5JK+KsRA6c7bJH9ig4viKI2uqE=;
	b=1xIkwc0Jq/RwWecfl7uotKiHHKwTnzT3D1ecK3Ds2roqaVuBqa0GpxNyu2ET6nRwqeEMjh
	3rOgLBlVdLtCW7DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767780742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QyjOnRY6tYvp1SLKJ5JK+KsRA6c7bJH9ig4viKI2uqE=;
	b=QFDq+39Cc7oo8MwJC5X9kvzdCAs7F5gTkXwgDDInSioh8QXQXlDb1qgFSYSvwBtauL8ArC
	QsQD+xenkJ81NoU+vDAFF111htE7lk4tIz3upqa4dYT/nByhjztWJFH3hbN75DTkIaIlFX
	OxpJ8Bgm3iodG9WIcNEGtH8cZ1UnkwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767780742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QyjOnRY6tYvp1SLKJ5JK+KsRA6c7bJH9ig4viKI2uqE=;
	b=1xIkwc0Jq/RwWecfl7uotKiHHKwTnzT3D1ecK3Ds2roqaVuBqa0GpxNyu2ET6nRwqeEMjh
	3rOgLBlVdLtCW7DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 628923EA63;
	Wed,  7 Jan 2026 10:12:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fAwLGIYxXmm1RwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Jan 2026 10:12:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 12E80A09E9; Wed,  7 Jan 2026 11:12:18 +0100 (CET)
Date: Wed, 7 Jan 2026 11:12:18 +0100
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, david@redhat.com, 
	miklos@szeredi.hu, linux-mm@kvack.org, athul.krishna.kr@protonmail.com, 
	j.neuschaefer@gmx.net, carnil@debian.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-ID: <ucnvcqbmxsiszobzzkjrgekle2nabf3w5omnfbitmotgujas4e@4f5ct4ot4mup>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
 <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <CAJnrk1aYpcDpm8MpN5Emb8qNOn34-qEiARLH0RudySKFtEZVpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1aYpcDpm8MpN5Emb8qNOn34-qEiARLH0RudySKFtEZVpA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0861A4000E
X-Stat-Signature: tgu5h3gzrkscyw9kpgtkt7miz4c5dinz
X-HE-Tag: 1767780743-657025
X-HE-Meta: U2FsdGVkX197ApqAeplgf+RGzUo6c7gpA/OHoMX0ueP20zyxsF3UENznukzfet6RDuU0b1zAy0Yj2UTYyDrWxuwaFubCiI6/Fy1cPJR+iffLzLf6A9eVJOYzw6+HWr3RkLBWxkI3X7cujj4zT6kAGY93SFjfWtXTQSPLr5j7irYhqoZzBK9r/SNxJ8wLGiCtnJSYarMt52/2DCctADtm3pLTJ0IYm0jHDiWMq9SmfrkABQUAX/UnvGA6o/ZX6/MmImnbL3PoQqPBL9G/20OkonEngN/NyKvIvMmuzfS6lXDI2QGWohIxcBLpHsdnt2oaIuTKbFcEqZihujoM5PT+dPH3wcKiepdvpfZHoaDTd8AVdED17eBIxFShLoInzOgLu4zG1bESq7c5J5agLKYm7BgRAW3x0XOAzcaxuSOAjdDu98+Mvxv23QbFvo5rWtlsS64a3fmzrX5KgT1Li/nUZ+wwXWe4kf/4tMetxvlnq6KB76WwdWQb34/AWOWnyd764G6Ekw4gRCbptzvVdRTVz0FxCCqlq93p5j6NA2+7LMe4Zd8tIHPoGKZ0IMwaPhAGqpZbwgKHC+hpbjRJQVkb/c1nAluLrIjpxw/6tFQ3vLSkIbvecCE9xpDT5UkSUUOoBRuPk+JLkidGWcJriT9hJz6t0ICR5GuRO54ILiQF1UbvO8wCNpMyowVY1t1iNS3HCl6vexj8BGyijgZIBbW4XSqrXJrBL3u90Cd2l3fm6VDmfSm6U0vTayZnpV6icNjBFam/KXgQhw7boV32bs+8K0E0z+4k+8nFEzpsDEPs4WGs6IJbp1KbwRODjCYcFWXv+BhO94GmtwdLxudKn88Ihed6ylc03ghWQcxME43gWYdezM7hoNeDc3yCMJhp/AwcRD42OiwPD6xUFwAky6XGiTO6hYJo8EFa0Rf92GS8qvcviQKKZRANl1OmJhyuqiYfLhSEQ+dMuoaWzGQZVR1
 3N0eXWlW
 PCw6pnSQUK88wXCXUuelts7auI5RxHNvwE6hFNqunws2tSKdLuyRpDsTE7rruW14xOTOj0mHaRjKO73VTxudm0qa6P3eCnMJASkMjvxbJPIFHK3USIze4tqOZOLU7UZ5TdMNzJt6lRh/6T5mvaZxUM/v3wAYHppsA0FrA1NnNv/WR1vuwcZHUoWzPfz37mmyE2c/bxIodp7CbU9vfs2KolMBsXGOn9Pz7PctnUTw74IKbChZ8Ah2F9qiVbAH2naeJ9tRrBvzrp2fEk2V8Fvcr7iRG8hunty30OT0/Y2AP7NwSAyPq9kNBVBlN0n9G8kyW+EoHLKiUHiQA3vKiaaSzm6s09Hdv9iNpngNTTRxfII/PNSJEV90HychkbE/cvJOgpDk3JMOpCvHkt3Fli+mD3KCVjh38Y8FhRhDK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 15:30:05, Joanne Koong wrote:
> On Tue, Jan 6, 2026 at 1:34 AM Jan Kara <jack@suse.cz> wrote:
> > [Thanks to Andrew for CCing me on patch commit]
> 
> Sorry, I didn't mean to exclude you. I hadn't realized the
> fs-writeback.c file had maintainers/reviewers listed for it. I'll make
> sure to cc you next time.

No problem, I don't think it's formally spelled out anywhere. It's just
that for changes in fs/*.c people tend to CC VFS maintainers / reviewers.

Thanks for the historical perspective, it does put some more peace into my
mind that things were considered :)

> For the fsync() and truncate() examples you mentioned, I don't think
> it's an issue that these now wait for the server to finish the I/O and
> hang if the server doesn't. I think it's actually more correct
> behavior than what we had with temp pages, eg imo these actually ought
> to wait for the writeback to have been completed by the server. If the
> server is malicious / buggy and fsync/truncate hangs, I think that's
> fine given that fsync/truncate is initiated by the user on a specific
> file descriptor (as opposed to the generic sync()) (and imo it should
> hang if it can't actually be executed correctly because the server is
> malfunctioning).

Here, I have a comment. The hang in truncate is not as innocent as you
might think. It will happen in truncate_inode_pages() and as such it will
also end up hanging inode reclaim. Thus kswapd (or other arbitrary process
entering direct reclaim) may hang in inode reclaim waiting for
truncate_inode_pages() to finish. And at that point you are between a rock
and a hard place - truncate_inode_pages() cannot fail because the inode is
at the point of no return. You cannot just detach the folio under writeback
from the mapping because if the writeback ever completes, the IO end
handlers will get seriously confused - at least in the generic case, maybe
specifically for FUSE there would be some solution possible - like a
special handler in fuse_evict_inode() walking all the pages under writeback
and tearing them down in a clean way (properly synchronizing with IO
completion) before truncate_inode_pages() is called.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

