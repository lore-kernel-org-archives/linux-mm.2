Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81088CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 11:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5068E001B; Wed,  8 Oct 2025 07:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755B98E0005; Wed,  8 Oct 2025 07:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C8A8E001B; Wed,  8 Oct 2025 07:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7588E0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:14:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8BA0B9AA8
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:14:42 +0000 (UTC)
X-FDA: 83974689204.23.0322A7E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8E2EDC0006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:14:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kVw51J2j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=33peweNC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kZPVtsqf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uN3dwGld;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759922081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fc/04qoN/PMDbssSJP/92cG5yZ5biHITDhDiKMO97Aw=;
	b=FlXLRDVm4sqWrrBsJGWJgjJ9EYg+OjXXloD5YfaxNuPh59pnHJkvusI3+uvOZiSoVpbGE7
	Z0glLO2jLYuTcvfgPjsRCSkm2ykjhaWDd701hLaEcNyHMZWBETqsEMzn6fri4Jt7C4XbIa
	Q52koQva9zvjUJl93YSdtnybV+5/b4s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kVw51J2j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=33peweNC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kZPVtsqf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uN3dwGld;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759922081; a=rsa-sha256;
	cv=none;
	b=6KwadKzvL4w4vrsJYJSglqUa/uqNtzQmUk/VBtZgQdX7FCTovQ4tf58OAT47GVkA9sbSF6
	8AQULPU63A63kTKt50heNQtsjIr1NqNlWgGb8cV6vXL9eTPLcOgbeCZ8i86Z92WZ6PNz9g
	hYQgVhHXM4L+co+AQhH02GGTDFGxZmI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C73731F395;
	Wed,  8 Oct 2025 11:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759922078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fc/04qoN/PMDbssSJP/92cG5yZ5biHITDhDiKMO97Aw=;
	b=kVw51J2j/E7tVEzyyLxqoBAdREbgmWnsf7WzPsMcIJapYif0H4STyvrK1SMgv22387PxqI
	iWllC/fTDgNaYsMzOPRNJfRU3i4BtM2copjCIkvFfrTnaixx906B7oZvwmlwWnEEGV8mq8
	pyBciYIPSqmTg15kLuNUZr0lw252dXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759922078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fc/04qoN/PMDbssSJP/92cG5yZ5biHITDhDiKMO97Aw=;
	b=33peweNCNeyqrEz6ctw6e1p+yxnDOi1e0j0cOxH6XAGtg1VtpaoD0rsyURzQ+lsAPoG63b
	GUvKBK03sGptvNBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759922077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fc/04qoN/PMDbssSJP/92cG5yZ5biHITDhDiKMO97Aw=;
	b=kZPVtsqfdZ2/Jrw2DnxoypL8H4w9ijLGDAr+bd4fOEHIR4vWQsag1GLODvhW7ST0+TQyd+
	mmTSJVnAtnPbRi9kA8G1rWBUOg5Sst6e7vlnCo7sJrO9qOAg0nV5CVBlj0dj+p20nyq50o
	V5jHx7B+iVqolmZVQzvgXCx31OFC+cs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759922077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fc/04qoN/PMDbssSJP/92cG5yZ5biHITDhDiKMO97Aw=;
	b=uN3dwGld1DTLfMpItq+thAviWSsxYb24QSwhOHDw+hd5D1u1kB8cdEE+PF4kP/EqVXs1lc
	fZvmJxbm3ZmFkTBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B498713693;
	Wed,  8 Oct 2025 11:14:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YQ0FLJ1H5mizIwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 08 Oct 2025 11:14:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 386DDA0ACD; Wed,  8 Oct 2025 13:14:37 +0200 (CEST)
Date: Wed, 8 Oct 2025 13:14:37 +0200
From: Jan Kara <jack@suse.cz>
To: Joshua Watt <jpewhacker@gmail.com>
Cc: jimzhao.ai@gmail.com, akpm@linux-foundation.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: Consolidate wb_thresh bumping logic
 into __wb_calc_thresh
Message-ID: <ywwhwyc4el6vikghnd5yoejteld6dudemta7lsrtacvecshst5@avvpac27felp>
References: <20241121100539.605818-1-jimzhao.ai@gmail.com>
 <20251007161711.468149-1-JPEWhacker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007161711.468149-1-JPEWhacker@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E2EDC0006
X-Stat-Signature: 6herebriaq6r9t7xwoozqmswt9a1xm1q
X-Rspam-User: 
X-HE-Tag: 1759922080-121501
X-HE-Meta: U2FsdGVkX18BPiu8s9ogXpHIhOg2LvzlsiPqw2ZFRZYCl3hO0Uv5r1sc+0ESvnwQbAh66wy3mCzG7kKkGO886tX5rT5j90G7IVzFfU/4em7sh4uc0uBC9G5R+jeE1N4Goxcei+xevBKjbzLqAnUM5MjK06hALiz6jqbexxnlbMxdUToUc4H8gig06DmVXRY/2Lod874BTO28MXrOanxAMyBmRWLRV+L3iP94XFHglQHPg9dZCCsXIvTN9MmVMVn8Ec5Qx8wRpxOjIFcUjgWOyBjMQbxUhKMNLbK4HugRzpcdBWc78RTOaasZn91eQ+2TRFRP5j6Ra3LEMTglJN6l0uTtwWt+M7feKG1B0glKnd02yiY6fBJhnTa04NrI/1X5eRimXVnNBSxKgzvYva2RJe11ke7U/oVGxB1i/Ps157tFf9UqCp+2S/ta6y77vmluUmZc04bZgPh+w4RG3BKlDAqMiejeg4kwaghS1nY5qhztXBYJXGFditfWoytoi+4a2DaGSEk3XEgEi2jMMDJmwWoeIIFZwe+28ukT0VlAmcmQMiHtvomAWEb6zx630WQTrC9Ar/JqvJNdKMHQxg6qtTsHFW1XXIr20XXLvbYOSHcLQRvytsMh5k4IIS0cPf2syzzrfGffHP8MltlCuRtqCwnqPYnDn94EffPjHh+RPwRyj4G0fE4xSkkPLuHzEhfbWBB4gKmaQHwq9Mm3TYNlXYk/x2QiIGkq4EURtSBzclwSpBW59gjs6FdMyjyareKFumK7/hzUifyzTsWHL7RwUbR2EpiBthw+aQ8p6xjXf5vlo41cRErxLVErxu7JObI/AU3dsmYJrHQUt9E0fwuSoq0kAxAKEdO6pYmftECZQCXSI/p2QGiy7V5cBylWKtXbv4ZD2kJY61nUblJOClvQMEcbNMTEeYJw58uAFGRIo0FKazZgt2G++Hy8IM1byqrN+USm9VMVHzB5v5EM4ob
 mZaBQbYx
 tQLtSUfaqjFw7NCa1ANEFAmgEDh4Y+6XLG5WTUD5M5poVvf66b22SPSyT9qbxRT8NPJdMsszK9RpEfn7Z3nHQHQXagI0NPr5ToqR1toadWfQ3ojuNngoj1OQtELGjas3Bi3v65f/mjHG+3TW0ghVqN9Ax+C3bTeMHn5420TPv3mfxbH5zfM+F2fyYK6tDKAL/fig/t62Ty+LNl7noZqW5CxixuAKN2kOMTc2Swbp0b+mtBsSF9+v44gDOfxiETHSBtoqlSKEigae9ZwBhEPakbQpp+FKzvFAmiANJMlKXVX1LAYGsUH8wf0CRHD4mdcUJEj/gHP+bqhRjHrMq4dvJ56N0Fzfmx7S5MXpjxT4abHjw+A+WcY2Z0olxtgEYQFi+O6w2wN2EdoaeyHrPnIynr6bdi5NnwqSvK6AXDdTrQR+N6S3mZ6we8RqdeYnGhXIRR8/aLgduCaeK5qRZADPgS7x7IzQUT6KZvcwR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Tue 07-10-25 10:17:11, Joshua Watt wrote:
> From: Joshua Watt <jpewhacker@gmail.com>
> 
> This patch strangely breaks NFS 4 clients for me. The behavior is that a
> client will start getting an I/O error which in turn is caused by the client
> getting a NFS3ERR_BADSESSION when attempting to write data to the server. I
> bisected the kernel from the latest master
> (9029dc666353504ea7c1ebfdf09bc1aab40f6147) to this commit (log below). Also,
> when I revert this commit on master the bug disappears.
> 
> The server is running kernel 5.4.161, and the client that exhibits the
> behavior is running in qemux86, and has mounted the server with the options
> rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,soft,proto=tcp,port=52049,timeo=600,retrans=2,sec=null,clientaddr=172.16.6.90,local_lock=none,addr=172.16.6.0
> 
> The program that I wrote to reproduce this is pretty simple; it does a file
> lock over NFS, then writes data to the file once per second. After about 32
> seconds, it receives the I/O error, and this reproduced every time. I can
> provide the sample program if necessary.

This is indeed rather curious.

> I also captured the NFS traffic both in the passing case and the failure case,
> and can provide them if useful.
> 
> I did look at the two dumps and I'm not exactly sure what the difference is,
> other than with this patch the client tries to write every 30 seconds (and
> fails), where as without it attempts to write back every 5 seconds. I have no
> idea why this patch would cause this problem.

So the change in writeback behavior is not surprising. The commit does
modify the logic computing dirty limits in some corner cases and your
description matches the fact that previously the computed limits were lower
so we've started writeback after 5s (dirty_writeback_interval) while with
the patch we didn't cross the threshold and thus started writeback only
once the dirty data was old enough, which is 30s (dirty_expire_interval).

But that's all, you should be able to observe exactly the same writeback
behavior if you write less even without this patch. So I suspect that the
different writeback behavior is just triggering some bug in the NFS (either
on the client or the server side). The NFS3ERR_BADSESSION error you're
getting back sounds like something times out somewhere, falls out of cache
and reports this error (which doesn't happen if we writeback after 5s
instead of 30s). NFS guys maybe have better idea what's going on here.

You could possibly workaround this problem (and verify my theory) by tuning
/proc/sys/vm/dirty_expire_centisecs to a lower value (say 500). This will
make inode writeback start earlier and thus should effectively mask the
problem again.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

