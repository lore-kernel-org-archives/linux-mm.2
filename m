Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA56DE6816B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F106B0005; Tue, 17 Feb 2026 07:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD616B0089; Tue, 17 Feb 2026 07:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F010B6B008A; Tue, 17 Feb 2026 07:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D98A16B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:06:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A90C160145
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:06:08 +0000 (UTC)
X-FDA: 84453820416.22.FC38BB9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3A20D1C0013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:06:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tj4JYsK0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=etN8cHi2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tj4JYsK0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=etN8cHi2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771329966; a=rsa-sha256;
	cv=none;
	b=56GussR0Z2jSANiTabQaW8IRv+8mszcXSbPVXSJ1dyYR4eVK+XbTIoNobeyuzaaNw+P6Pz
	h88CcCvngTsiox0nNC+fmOA5mLAu15vys8h9DkEcWA4IDyN2mvzrS8mAUMHbodVcW1nRq1
	tJB8S7PByuGfKVgjb9SRhqS5Tet6HJY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tj4JYsK0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=etN8cHi2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tj4JYsK0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=etN8cHi2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771329966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxkqPNgkdCosp0/W0/1gwJfHUSCYabVKYzC0gST4xVs=;
	b=jlNDKSYe+LDPdPPMpuYQPMQeuvl9ByNT6PSXRc6vIZhmHveAWQOFYshGQR5x2oGx3cxbjf
	lsteEfeCiiHuosjwUlECkfd0+IP7rf2PVn6dkO7mp+qH0fIKh/hnumHIytE1lbmDJ6HOuO
	Bib2NgHfeG+lC0beKRTyfFyDWJFWn7U=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 699583E6E3;
	Tue, 17 Feb 2026 12:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771329964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RxkqPNgkdCosp0/W0/1gwJfHUSCYabVKYzC0gST4xVs=;
	b=Tj4JYsK0howQT9SoGnbXDmFratK/bokiECr7iooUakYXlGgRQwNzuv0YraZX61LfeqVKGF
	Dp+wWZ3u0etC1Fxkl5SuIjWnSH8aE2FGrAbtBjTBPacIMvpkPtdwhu0RwvZC46FToQpUhI
	ctwdVA3XIN/DkqcKNmznF+i7pkvla5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771329964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RxkqPNgkdCosp0/W0/1gwJfHUSCYabVKYzC0gST4xVs=;
	b=etN8cHi2zKQJDOMOzLxSV1Q5EuWC25+n+s47IHcmvF0HtHA8i1MbBaQ+DTKCtL+uoDd80f
	bKJwWS8rN1RtF6Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771329964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RxkqPNgkdCosp0/W0/1gwJfHUSCYabVKYzC0gST4xVs=;
	b=Tj4JYsK0howQT9SoGnbXDmFratK/bokiECr7iooUakYXlGgRQwNzuv0YraZX61LfeqVKGF
	Dp+wWZ3u0etC1Fxkl5SuIjWnSH8aE2FGrAbtBjTBPacIMvpkPtdwhu0RwvZC46FToQpUhI
	ctwdVA3XIN/DkqcKNmznF+i7pkvla5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771329964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RxkqPNgkdCosp0/W0/1gwJfHUSCYabVKYzC0gST4xVs=;
	b=etN8cHi2zKQJDOMOzLxSV1Q5EuWC25+n+s47IHcmvF0HtHA8i1MbBaQ+DTKCtL+uoDd80f
	bKJwWS8rN1RtF6Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50B283EA65;
	Tue, 17 Feb 2026 12:06:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gPKoE6xZlGmPTwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 17 Feb 2026 12:06:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0F5C3A08CF; Tue, 17 Feb 2026 13:06:04 +0100 (CET)
Date: Tue, 17 Feb 2026 13:06:04 +0100
From: Jan Kara <jack@suse.cz>
To: Andres Freund <andres@anarazel.de>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, ritesh.list@gmail.com, 
	jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, 
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, 
	vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A20D1C0013
X-Stat-Signature: srffptq93us7s1kszu3gqmsdr6aojfuf
X-HE-Tag: 1771329965-988291
X-HE-Meta: U2FsdGVkX19zn80ZhdksYfFJBzdsNiArd6n03XOsrbyj3aD0AL1uLdPgAQ/oEFuad8I8H3Ggws8Ygx+9ZC2zWwOupNKZC9++R4W/PUGlDeY2Z78zXFLqWNRCjWg5XhNA1TBMq8worxqj2grcy3b1dqSFpUmIea2OheJKb0mX2j50s8v8XbcMZghRLFDHypN484mInqabIm8dglGvpoyn+AYWKST7G3ItdqbSZlWYFDO5ZSoxV94Nc0PeWtb+kEk7y/V5HwtaWqK2ZZv8tHmilvOo8DbMP//LeSO++vT4nbCLndsFKfMeina74ct8Uc9qmstbjD3FLmahlK3uxtuqQwQgPi7hprEeys7+MLT3DOj6ZQt66mUe60U1zLtuQ3di+P/phxcluV76NEHVBmnQQ+akkC9UpHbAwV46+iplWY+jietd7UGEwYCfrV5OkKnxg8kUwkOn7/QWR+gusHhN+Ks5XoW2/6gaOafqu5r5NaaWhUHjzaFT6TB4xsUUp5CHKnY0F/i1Bud6k3nO7su1kezWbIR1EpwhaMxPNl7WaOnWYi7z6lmPEQQQsJ/Oo2c0OVsralNM3NKSYyxFPGDuqYcqJX2HJMVvsns38EkOCy01e7UHHHtdiotY6BIYXr3h+p15/fo5UWCmevy1G9u2iZWJirOkVgLFrW8sdtPqS3ktY7b+69WA5f9bq8C8jxMEa+XYVQwKytNvBNJiaCebjS7Ph29hEVcirTuTG/C3kh0AX9FGOb4nvD/uE65YHqY7khXB0rYdQWyJaR29RxYKzBlqo7tn72Fxaeu1PCbx+k6AyIMjhZTs9DJ50UgPUCXqRAm+rmjpUHD/8XM4/R35USI7ACZtvwNi68raI0NNDShAiDxKYr8Ib40L7xAbU4mjQl08j2VHHa3A8L4i1JVKuppYd8kCUILC0zxFKDFQDoo4plU3pZCAn2zirku1WVnOK9GJ5JVRsyoKUyNfGeT
 kRTnFL3o
 5AmDdVfq0CNSGhlnOy9KIQ0uFI9Ue/V0n4AIbyLpv1dBdzP1uv6C3hs130kf2V8FiuZQgC3mm837q0VVJ+7C3s3id64b1E7/G41KaNz9yF8Jj2tU8uVYIJYM2plqyeKIEhSb17I+dNYBd4FkSs/uv1P/skl4AHYN52hczc0QD6msB7IPY+qoFkZQstXbRuACrLyO11dXxOJGumUqT3g7+0tnLgvFlh/m6Sus0IyCplteAVWHCjaz9ZjQLP2ic2pWjYBn7oHl6J9WaKo+G1tszB5EnAM7VagX7WYXgDNsx7p6byxPooltnMOXCZ3NfjuBcK0tkKFj2O4JirJk33Moj06VHcFHW0b6+B8URvXxeqBptCODr1oRy3xAFLPufavFIG5GuGirE1LoTFbDzQJsPQTOGdV1m3iVEypXw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 10:45:40, Andres Freund wrote:
> > Hmm, IIUC, postgres will write their dirty buffer cache by combining
> > multiple DB pages based on `io_combine_limit` (typically 128kb).
> 
> We will try to do that, but it's obviously far from always possible, in some
> workloads [parts of ]the data in the buffer pool rarely will be dirtied in
> consecutive blocks.
> 
> FWIW, postgres already tries to force some just-written pages into
> writeback. For sources of writes that can be plentiful and are done in the
> background, we default to issuing sync_file_range(SYNC_FILE_RANGE_WRITE),
> after 256kB-512kB of writes, as otherwise foreground latency can be
> significantly impacted by the kernel deciding to suddenly write back (due to
> dirty_writeback_centisecs, dirty_background_bytes, ...) and because otherwise
> the fsyncs at the end of a checkpoint can be unpredictably slow.  For
> foreground writes we do not default to that, as there are users that won't
> (because they don't know, because they overcommit hardware, ...) size
> postgres' buffer pool to be big enough and thus will often re-dirty pages that
> have already recently been written out to the operating systems.  But for many
> workloads it's recommened that users turn on
> sync_file_range(SYNC_FILE_RANGE_WRITE) for foreground writes as well (*).
> 
> So for many workloads it'd be fine to just always start writeback for atomic
> writes immediately. It's possible, but I am not at all sure, that for most of
> the other workloads, the gains from atomic writes will outstrip the cost of
> more frequently writing data back.

OK, good. Then I think it's worth a try.

> (*) As it turns out, it often seems to improves write throughput as well, if
> writeback is triggered by memory pressure instead of SYNC_FILE_RANGE_WRITE,
> linux seems to often trigger a lot more small random IO.
> 
> > So immediately writing them might be ok as long as we don't remove those
> > pages from the page cache like we do in RWF_UNCACHED.
> 
> Yes, it might.  I actually often have wished for something like a
> RWF_WRITEBACK flag...

I'd call it RWF_WRITETHROUGH but otherwise it makes sense.

> > > An argument against this however is that it is user's responsibility to
> > > not do non atomic IO over an atomic range and this shall be considered a
> > > userspace usage error. This is similar to how there are ways users can
> > > tear a dio if they perform overlapping writes. [1].
> 
> Hm, the scope of the prohibition here is not clear to me. Would it just
> be forbidden to do:
> 
> P1: start pwritev(fd, [blocks 1-10], RWF_ATOMIC)
> P2: pwrite(fd, [any block in 1-10]), non-atomically
> P1: complete pwritev(fd, ...)
> 
> or is it also forbidden to do:
> 
> P1: pwritev(fd, [blocks 1-10], RWF_ATOMIC) start & completes
> Kernel: starts writeback but doesn't complete it
> P1: pwrite(fd, [any block in 1-10]), non-atomically
> Kernel: completes writeback
> 
> The former is not at all an issue for postgres' use case, the pages in
> our buffer pool that are undergoing IO are locked, preventing additional
> IO (be it reads or writes) to those blocks.
> 
> The latter would be a problem, since userspace wouldn't even know that
> here is still "atomic writeback" going on, afaict the only way we could
> avoid it would be to issue an f[data]sync(), which likely would be
> prohibitively expensive.

It somewhat depends on what outcome you expect in terms of crash safety :)
Unless we are careful, the RWF_ATOMIC write in your latter example can end
up writing some bits of the data from the second write because the second
write may be copying data to the pages as we issue DMA from them to the
device. I expect this isn't really acceptable because if you crash before
the second write fully makes it to the disk, you will have inconsistent
data. So what we can offer is to enable "stable pages" feature for the
filesystem (support for buffered atomic writes would be conditioned by
that) - that will block the second write until the IO is done so torn
writes cannot happen. If quick overwrites are rare, this should be a fine
option. If they are frequent, we'd need to come up with some bounce
buffering but things get ugly quickly there.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

