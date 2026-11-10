Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604B8606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=QgUUViqV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DTFvvSvR;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=swYBA4Ja;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ujMwJ2Ho
Received: by kanga.kvack.org (Postfix)
	id 81B376B00EF; Tue, 10 Nov 2026 08:53:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2696B05B0; Tue, 10 Nov 2026 08:53:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC576B05B1; Tue, 10 Nov 2026 08:53:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42D236B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:53:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D762AA85A6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:53:22 +0000 (UTC)
X-FDA: 85419351444.04.0204672
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 815FF80008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:53:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QgUUViqV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DTFvvSvR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=swYBA4Ja;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ujMwJ2Ho;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794318801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcmj2mRiryRprIj9Gr9aUDtuxY0NQ+ycYiPJC0rulso=;
	b=ftmGpYnUXH/qtUdtE4aW+SrfaLUj09QAEcfav/jHz3u3HtsWwK2M948ZY4dcsoav6P4uyV
	mNotEgViOMQUNPoq631et8HeUqeJoAW9kHwq1+atblckur4RyodO6uicI5rWPNA7FosRd9
	W1iCDO/tTOcfGcIZvOk6zvdW3lyUOyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794318801;
	b=CsO1CgBE3ojQzw4JddlduPLtlP0MjiAjz4FSubVGs6MC2F48WnVmupNDJXIukKKlLILRkR
	jSqs7H6o7lZ7ZM/Q2R/vPP00baBSyFutaAKe0BuJVssOZzPQ4WBWyfWG9nLI17ZQa5qwVp
	d03Lm58vOOFASJY3czkgabJKhwf28IA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QgUUViqV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DTFvvSvR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=swYBA4Ja;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ujMwJ2Ho;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C461021E68;
	Tue, 10 Nov 2026 13:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794318799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcmj2mRiryRprIj9Gr9aUDtuxY0NQ+ycYiPJC0rulso=;
	b=QgUUViqViWCMY15ugNChFv3abQjhR0uVHD/mNm2xAI6hXizLOON7KbCxBRMn+Q7qx1Zd/+
	3qxHP6EzoKtTueeVE9Z+gQRnx96xpDn8BlwYqAfVSUVpXc54rN+klU8AqSHZo+OnsWxvLa
	R6W4nNqX/hdq9yBvnn5xvzixKZK6QVk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794318799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcmj2mRiryRprIj9Gr9aUDtuxY0NQ+ycYiPJC0rulso=;
	b=DTFvvSvRIVl0YFEtqQr5KB4edvgx8y6PdCUR48rHCmH2cDjd82wBkfA7lpwefWONspUH4N
	JjMCaDYCoX/xCrCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794318798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcmj2mRiryRprIj9Gr9aUDtuxY0NQ+ycYiPJC0rulso=;
	b=swYBA4JaEWYZe6/pZZCl2ZydZAx+XJLdjEntlW7iIabs9RFjPiEcIup8fyTHn71UupdCxf
	AxUIfuYOX3Q3MPmzP2tAirCTHRiPS++/CKbUkf3LPJQcmKL1/7kcUUd+vG0W/bEDBh60Bv
	SeQXZBeVzjMSLyPtYg0APXwT/UW/npg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794318798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcmj2mRiryRprIj9Gr9aUDtuxY0NQ+ycYiPJC0rulso=;
	b=ujMwJ2HoR7JnVj9DpENaei73/ZLgzQaEOocb2UseRJBKNMbQEP5DWJzT2SBTtRDVGi8sYH
	cIp78rA38DQHsrCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A68713479;
	Tue, 10 Nov 2026 13:53:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LOSuGc4h82oXfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:53:18 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 1ED802251E; Tue, 10 Nov 2026 14:53:14 +0100 (CET)
Date: Tue, 10 Nov 2026 14:53:14 +0100
From: Jan Kara <jack@suse.cz>
To: Gopal Malaviya <gopalmalaviya53@gmail.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, fujunjie1@qq.com, vishal.moola@gmail.com, 
	roman.gushchin@linux.dev, Trace <tracekotae@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: restart mmap readahead on sequential faults
 after many misses
Message-ID: <jwg2p4bjzkacnx6fkifkb5jbe7ah6btuecpcpulbkym6e23v6x@mh35p6yafmqi>
References: <20261105192517.228523-1-tracekotae@gmail.com>
 <20261109091444.128521-1-gopalmalaviya53@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109091444.128521-1-gopalmalaviya53@gmail.com>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspamd-Server: rspam06
X-Stat-Signature: oq8s5a69wfr75q6affd8nssrbgtengmn
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 815FF80008
X-Rspam-User: 
X-HE-Tag: 1794318800-189202
X-HE-Meta: U2FsdGVkX19U5eskB/YlXn5ePWFqsHl3D4L3Glo0GzMXkxNqHXnnnBld///uuAovwF/kb64TdUzlJYvI9nQNzfQT+yLm5UqWR7XQEj0WBojC4DxG4O/zDys8ClYEgbntT+rjVnduYyYXF1afzn1JvwwS394AgM9aT432rWE+7ET3bxouH7JJn7a5+DbDqMvAbBh916bElAh2cGrnMkmK9qjhhpLALt/nX/6QlXe1Y0Ln/cmeVNyjQyY1TOFG9KMN0ytj5z/6ErhZxmszMtb7lFoE076+Kn84tIocjS4T/zrrt1k5pnxVDhHIkVbeQlsGGtje2Vc3G8axQbUWOpI831MDg7EWf2Vg8tZB690DNYJf/1uoNqDOczYanp5FMTdgdaxBHSnY8fOX8j/sTTHTIkP/6eLX7n+LwWbG4blHeKsH56TIwh+rK0LUJyvGmE2v9CO/heXhXVQxfGYEEIPNF/36xuL5rORQST/wXncu+CNlebZEImK6ws0Kpj4tKPP3iTfPh7FE8UlzMno7GzF7d+1Z9/nL/AngbjAtziPuvo4OlAbqTM4Ap/Hn1682ms/y2BaI90cV+pP8CxXgxcu5GurZ5YaPDaErRe6tgNzKi1GrDN33A/dhF463ZllHY9HiVmSHcb096y2H2vj6LWiBtK+rZ0tD+bhHTc5lkkqZOOosSFi1ijci4p0dmWhuKD/RYwA1oM6NDBTBVzQnNhn1EJ25Ul9WSB4nC0RKfiojdcNCqdHbvtVvqnI52GLr5yTYI4VwT8VfrMgjn00XODuLl0n+alPwueZyBXDVW69TKJQ5+swD55ost/FtnSyf4Lg105pzaayRcG9PV6zZ5TG/LFtMpn+zACZPmZB+YMeODUcz6PTwTbjFflo5jX0yI0OMxsAMrqY2iYGiwrtpdO7UXJXfdvwLep3V1EBfERiBJh3/vm565RGNg7j12RQCewdZiEhqVWnKkpPQ+x/rgyB
 fPuICItl
 CSsd72qANQg4HUqmRZULHCdurPgvQmsrsC9zIlzXWWvV5304DUCGSVH4i0gK/OAC+nGGpvgR9LI7OlOFebMCdgZ1gMD9x2CN+DsPmRIKcgBK1hkYln2VUYFx8FY1OD/rRgtDAiibHtZfVFxbu2+7I0U6DnO+ifQmCY29BDFdk8Dwry0VUC6hrqo1P3e8HddSCrGU33RgB5ArPHLew5yCPgvKiZP6Bomod70NGJaqtb9i7F1irvdA9e94SjnwHJH20PaIJ/GmJt6ROZGnqXXbrOxQJjQN6xLYGHq0VYBtDxW9NdwwgZnTmWH3H1TO5UowACLF5+UrhFM5Y2dcwbuKIfsCH1ElXNoUf2znfVbTKpWEhMJnVtWNr2d7Pm1tlziSIGMHlecXP6E5I7/nO0Q7lSu2CK7TmqCB4UqtToYCTTxcf5hGAjDLF1vqEM7KF3XgaLyNNfx7clWIfJwyDMZmz2PVXAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 09-11-26 09:14:44, Gopal Malaviya wrote:
> Since commit 9b0fcac3cfe7 ("mm/filemap: do not count FAULT_FLAG_TRIED
> retries as mmap hits"), about a hundred sparse mmap faults push
> mmap_miss over MMAP_LOTSAMISS and turn off mmap read-around, as
> intended. But mmap_miss only comes down on hits on pages that
> read-around brought in, and with read-around off there are none. A file
> that is then read sequentially gets a synchronous single-page read for
> every page until it is opened again.
> 
> When a miss above the limit is on the page right after the previous
> miss, start readahead the way a sequential read() miss does, with
> page_cache_sync_ra(), and keep mmap_miss at its cap so that hits on
> that small first window do not bring back full read-around for random
> access.
> 
> Tested in a KVM guest (x86_64, 2 vCPUs, 3 GiB) with ext4 on virtio-blk.
> "base" is mm-hotfixes-unstable. "95b8e" is commit 95b8e432265f ("mm: use
> zone lock guard in __offline_isolated_pages()"), the last one before the
> series of 9b0fcac3cfe7. Commit 0b9c0aeba938 ("mm/filemap: count only the
> faulting address as a mmap hit"), the first of that series, gives the
> same results as 95b8e for the reproducer.
> 
> Reproducer from the report, read_ahead_kb 128, major faults:
> 
>                                          95b8e    base  patched
>   sequential only                            1       1        1
>   sparse pass, then sequential               1   16384        2
>   sparse, MADV_SEQUENTIAL, sequential      512     512      512
>   sparse, close and reopen, sequential       1       1        1
> 
> Touching 1% of the pages of a cold 20 GiB file, larger than memory,
> MiB read from disk:
> 
>                        read_ahead_kb 128        read_ahead_kb 8192
>                       95b8e  base patched     95b8e   base patched
>   random               5656   215     215    344731   1032    1032
>   stride 2053 pages    6545   216     216    419003    992     992
>   random 2-page runs   2992   215     528    173093   1099    2248
>   random 4-page runs   1570   216     594     86797   1266    2301
> 
> After the sparse pass, reading 32 regions of 2 MiB in turn takes 512
> major faults per region on base and 2 with this patch.
> 
> Not tested: NFS, the GPU workload from the report, and other
> architectures and page sizes.
> 
> An AI assistant (Claude) helped with the analysis and the approach, and
> wrote the test programs and drafts of the comment and this changelog.
> I reviewed, implemented, built and tested the change.
> 
> Fixes: 9b0fcac3cfe7 ("mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits")
> Reported-by: Trace <tracekotae@gmail.com>
> Closes: https://lore.kernel.org/all/20261105192517.228523-1-tracekotae@gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Gopal Malaviya <gopalmalaviya53@gmail.com>

I think this [1] looks like a nicer solution to your problem.

[1] https://lore.kernel.org/all/20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se/

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

