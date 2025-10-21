Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7F1CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B69B8E001B; Tue, 21 Oct 2025 05:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966728E0002; Tue, 21 Oct 2025 05:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CBD8E001B; Tue, 21 Oct 2025 05:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7743C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:22:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 237F31A03FD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:22:33 +0000 (UTC)
X-FDA: 84021580986.25.D8E6EEF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id B956712000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:22:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wIo5oCUa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZUGe23PS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zknEK/zc";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kPU+3C/Y";
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761038551; a=rsa-sha256;
	cv=none;
	b=M0TKp7g9UPlFyvRICLAiuGUay9kdoKbDY/0fS5DgFXWquJ2Iltz8rXHHaFkPnkfyPnQMaV
	1P907QmzjNv2KCcyljarpBeAisu27sofe6RJFZEl5JS+xKJkWSLV16xuaHJylLbyLf0UhR
	LWSXAbZSVkkpuLeW6Zbm9Lep9YnKQTE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wIo5oCUa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZUGe23PS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zknEK/zc";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kPU+3C/Y";
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAlZsLpmZR4ppbAmqbxDqov94GN0TMQzZ5ttVOeE6Qg=;
	b=uTePaRFPFPYBcfyIVqKSRcs1OQmGbhVDRcVMWBYDzUYvvHr3tw+RZqy+efbp8HAAjS94O3
	JnW1pRWFPOMANjgPqootvtQyN0eQorcxMGoHHQaj+y0kJR01eeE+vTJseaaZMUtAXRO8nG
	TkBL/7icQ/3tj8G/yFk/iq68mEGybME=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 14C5A1F445;
	Tue, 21 Oct 2025 09:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761038545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAlZsLpmZR4ppbAmqbxDqov94GN0TMQzZ5ttVOeE6Qg=;
	b=wIo5oCUa2Zf6G/b0DE8QuyA+165ilNoG6Td2Qi4HjGX9sJzbMwWLg/e2M+kyyGbM6Ds07f
	cSfr7fAh8edu7gMHsAzEAJWI+d74RfJ7DFit0Z2j6difanldXOGRK9casSAWZBWrGOVlLs
	8UxQ+xl1xFvdecu9KYCrVB6XFkAYOyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761038545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAlZsLpmZR4ppbAmqbxDqov94GN0TMQzZ5ttVOeE6Qg=;
	b=ZUGe23PSGWx1vK7/4Jv6B2vxq/TLQ7rOdCDZIKb1LmySP/5zaStEv4m1wLAa0kzyGtcd6d
	VaHXSCps+TFIy2Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761038541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAlZsLpmZR4ppbAmqbxDqov94GN0TMQzZ5ttVOeE6Qg=;
	b=zknEK/zc7CEYMwKxbENGVk7jGMw3bjyuGtCZn9IcWRGlybq7iQmHt5lN58n4/OMjuNou5W
	HVtTO+f7TsnPkfgFyllmcwRa65KdqqnXvoZNPGg/j4wYkZG/wUz0VVcsoO9UQV+Ui3CTDP
	DBsyHI7OST7PQifcontK6lwoUXHBvOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761038541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAlZsLpmZR4ppbAmqbxDqov94GN0TMQzZ5ttVOeE6Qg=;
	b=kPU+3C/YjFWWX0UvEImfaygoAOL4KZLRLoIVZmxPI41j8uiYELf8HzIepXlft+4PX0ZqlJ
	8+YAZu8pue5iQLAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2222139D2;
	Tue, 21 Oct 2025 09:22:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5JsZO8xQ92joQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Oct 2025 09:22:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 979FEA0990; Tue, 21 Oct 2025 11:22:20 +0200 (CEST)
Date: Tue, 21 Oct 2025 11:22:20 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	djwong@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <rlu3rbmpktq5f3vgex3zlfjhivyohkhr5whpdmv3lscsgcjs7r@4zqutcey7kib>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPc7HVRJYXA1hT8h@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: zzsr16ffff6jsqpab1ssaaiwd9iysf1m
X-Rspamd-Queue-Id: B956712000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1761038550-556341
X-HE-Meta: U2FsdGVkX1/haym0YW/mA7CpGgEujSrxapcNiPR7qKy8BV0595k9nhtGUWvW2c5io2eiK408SxSHAOX7n4TVURkH4NHcY9FI7Uy4EV6UCAXVH6xjAaYD/UXp03Wnwwba4c0G4lQiBBDTKrpH5PRXWPhmqJNYvQlXPPd3lYn1sllD4qUVgdcmIt0qYL+gShdjctkzpZXgq+lXuwGznyGznty78Czx5HynN5AJZZMm37bBH3kUzuewmAjRXb+VLSJOHnzpJ1I2UJaNIQoVUoY1+v6HUH2y5pFvOmpasZ5Qyet7nqyFmR1g1gntLcmxIfbVHvlWaHMpYgnLiceXI6v0PzJjdn2kHUomVNeEnTx4gA1d4jVn0DciNwSzr66Blaw/u9Isx1yfrN2s9kdOsdM6HaKq36HSQiQHCQTQFSRRNLpdQJEb6J1qIRd2lSUmUVEwWJYS5tJ2iqHsm1lFcqw4mDIpO1OGCCARE9VGkL2et3ECdBkL7MxBxyVY7UaDH+0QR6fGxNqZygALRp7WIcsVyyYERm0L1TrxDhreha3Je2MCmI0/eIzRQrPDp16xtml0nh+gadnZJ+BirrQ/vSyUr79dNp7tORVK6xNghK8LfW6PJ754bCMP9FoBx8KEmrTeXZfYgRRfVQjx9jRazTdi0xKq1mSxxsRZk+t7SwtkyZjxti1gL5UY+OKxDdZgzpGginFaJR85DN8y0kmiZoSn/TJjZH5/2mTLITxlIotPCVxSiCDzHya5rDlgHP0O2AAfy2RIhbiisdiygmkPHMjhTheuXY8FCp8MIZXQ6sCcM+MO2cIFJkByn7TBbeRz/izu+ndq93HwKY2lPo3RgZfoDw8hfHkCWdPWWFwLEegabC5tpG1Gtb4tSR8CclAtIaj81q7kZEcyatnEv2xQ1G8uou/p3rEnZaawsMvd/dE7xvz/TiEWZHxUTsYjEqze8p7Shvh+h4WJFL3hioyJ8dS
 6r6b4qZV
 RqNuxkn7aLP/FAmaG/vR2ryLWsObdHn3oj9ExP82B9dZ+Yd3cBzhgqZtthFdhsWVFXcF13inaI3mWZB4DnUgBTL4dgmNMMIFce7yisFcLatS92ot6gyiwK5QMAZOoMdff7pf5eHAbNLYe56KiQEIdZCh9h31oij4GgFm2w9U2uy6f5vgx+EOe8HSOdxz4a7Jz2Mm9FOIyNRUSbJMSfBA0bEUzVUD3k++L488LtWV2FoQAsdeF5qHP1iITdNyiAXsJpAiMBOAbitTPjp0paLze54H76NszSzz2wWuUz0GpDNPtZjmKlPyxXr+hGmPKnTNrMzQTlJ79b983NNWykcsNrE9r7cWArvmSCk2MT0FDdO/vj4WsKcLVWa3dfjwgXtWMYgrMammXBY7vup0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-10-25 00:49:49, Christoph Hellwig wrote:
> On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
> > Just FYI, because it might be interesting in this context.
> > 
> > For anonymous memory we have this working by only writing the folio out if
> > it is completely unmapped and there are no unexpected folio references/pins
> > (see pageout()), and only allowing to write to such a folio ("reuse") if
> > SWP_STABLE_WRITES is not set (see do_swap_page()).
> > 
> > So once we start writeback the folio has no writable page table mappings
> > (unmapped) and no GUP pins. Consequently, when trying to write to it we can
> > just fallback to creating a page copy without causing trouble with GUP pins.
> 
> Yeah.  But anonymous is the easy case, the pain is direct I/O to file
> mappings.  Mapping the right answer is to just fail pinning them and fall 
> back to (dontcache) buffered I/O.

I agree file mappings are more painful but we can also have interesting
cases with anon pages:

P - anon page

Thread 1				Thread 2
setup DIO read to P			setup DIO write from P

And now you can get checksum failures for the write unless the write is
bounced (falling back to dontcache). Similarly with reads:

Thread 1				Thread 2
setup DIO read to P			setup DIO read to P

you can get read checksum mismatch unless both reads are bounced (bouncing
one of the reads is not enough because the memcpy from the bounce page to
the final buffer may break checksum computation of the IO going directly).

So to avoid checksum failures even if user screws up and buffers overlap we
need to bounce every IO even to/from anon memory. Or we need to block one
of the IOs until the other one completes - a scheme that could work is we'd
try to acquire kind of exclusive pin to all the pages (page lock?). If we
succeed, we run the IO directly. If we don't succeed, we wait for the
exclusive pins to be released, acquire standard pin (to block exclusive
pinning) and *then* submit uncached IO. But it is all rather complex and
I'm not sure it's worth it...

For file mappings things get even more complex because you can do:

P - file mapping page

Thread 1				Thread 2
setup DIO write from P			setup buffered write from Q to P

and you get checksum failures for the DIO write. So if we don't bounce the
DIO, we'd also have to teach buffered IO to avoid corrupting buffers of DIO
in flight.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

