Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0787CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 09:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBD38E000B; Thu, 23 Oct 2025 05:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D42D8E0002; Thu, 23 Oct 2025 05:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B7D8E000B; Thu, 23 Oct 2025 05:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E09B88E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:37:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 954EB88EF4
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:37:37 +0000 (UTC)
X-FDA: 84028876554.07.D2C0E06
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 52EA5100003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:37:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LU/5yS3R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uL1pIUmR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hny0RdB4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t7GXBfMY;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761212255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxP+/O6Wpl//xRTgUvAUeHTOU3h8ER8X0cqpJ8cKmpk=;
	b=kZBeyYBv7XIB2zKd/vZzIIVa15dm6i84eZlT/eh5w8Efke8w7Idqgm78r3h77gDrUDtsdR
	IQ5LIizCeox2ZHqIS+RPuEFt/ZaXkrGbJRoK1kSljGnNGIa/MqyuytWAwqAHoWlRnWODKY
	hIBtPJiqMnK0qzNUl2jX5hPqClkBXaI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LU/5yS3R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uL1pIUmR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hny0RdB4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t7GXBfMY;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761212255; a=rsa-sha256;
	cv=none;
	b=kAyK6mdpIP5sejKHqZqlFcz3ZqZNZdLVu99zCJ05nN3g6eM40aaf1Gga1blbeZL5SxjP34
	yFnuCRgMpU95A1VcoEz7WPImn4875vFnHCgdtBcyU79J9jZDHoz9RtUdOigub2HAjBMneZ
	oo26SdUxfjTHKNi7GQ52a2YuNwglyyQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DB9F1F388;
	Thu, 23 Oct 2025 09:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761212249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxP+/O6Wpl//xRTgUvAUeHTOU3h8ER8X0cqpJ8cKmpk=;
	b=LU/5yS3RC8FrIC0QpaOAIilIPVo0TLduOY3AWCPGA6BobFE13lTDpn9+SV11lJn77agCcE
	vEnPPmZhYkQfdWV36//PsiBLWrlST69ajpllUQejLV4wcMewonZiPDPhTJgbY4eeOJajff
	sWQlnfK4uOKW1bSkXzv/aHDYPSCcwhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761212249;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxP+/O6Wpl//xRTgUvAUeHTOU3h8ER8X0cqpJ8cKmpk=;
	b=uL1pIUmRTNpECOZgs8QebhRKXbKiSIfrdEkqBgjXzUuHEluM4CX4BmxRWl10xHD2+jvCCO
	o6EbLcyHQ1IYQsCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761212245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxP+/O6Wpl//xRTgUvAUeHTOU3h8ER8X0cqpJ8cKmpk=;
	b=hny0RdB44tCxXfVG5kXbxljg2OduQjTiDJvUtB3QjYmX442ek9QsNEGU8MdsY1l1zC+p12
	lOs2MdTGzr/j1ZUidiC4CE7KFg0XDJLIBa03Nslhgf+bEKdSFiTbj6wlEDSnTeqlK+lobV
	YoOOkUPOMjIBXOPGz3lFDjIbiqqgkCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761212245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxP+/O6Wpl//xRTgUvAUeHTOU3h8ER8X0cqpJ8cKmpk=;
	b=t7GXBfMY7/0bvXiEGsumtSau/j3cPXl0f1UuZvT6uW5Zspqndd1KD40xRT7otK/IxMmgTh
	CqtbykZbOZK+WXDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4078813285;
	Thu, 23 Oct 2025 09:37:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Abi6D1X3+WgsSAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 23 Oct 2025 09:37:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D80CBA054D; Thu, 23 Oct 2025 11:37:24 +0200 (CEST)
Date: Thu, 23 Oct 2025 11:37:24 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Kiryl Shutsemau <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <dupgze7vl2vvndyasmm34ebhzxzumv3sz425qvbquruzvqgf4r@q66h2eeaxs7h>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
 <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
 <aPgZthYaP7Flda0z@dread.disaster.area>
 <CAHk-=wjaR_v5Gc_SUGkiz39_hiRHb-AEChknoAu9BUrQRSznAw@mail.gmail.com>
 <aPiPG1-VDV7ZV2_F@dread.disaster.area>
 <CAHk-=wjVOhYTtT9pjzAqXoXdinrV9+uiYfUyoQ5RFmTEvua-Jg@mail.gmail.com>
 <aPneVmBuuTHGQBgl@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPneVmBuuTHGQBgl@dread.disaster.area>
X-Stat-Signature: wigkyf43ij8gkoaub3b9rbwdoxznq6oc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52EA5100003
X-HE-Tag: 1761212255-244900
X-HE-Meta: U2FsdGVkX19DPQy2MIzJ/Sb5EhWy3OlAk0XVK+eWlQMYUc+LsXw0deoJRJcpqOHg4vUXnzTb5OapTnuGt7Lu7eKpOhZJvbJ8L2iBHqONeeUXwmkZAl7TGKrjmj+am5beoUZiysT4gRodwOtDjF1vdo05Nh8cRQa/Gf5O+dxjh9P6peioiy1QlsbnCv+w0u3TXchVqxqrfEUxePp3mdXGZJVuQ4fA9YySobzUD/bQxcLNHMMJmcPqhcR/LAMpBKO2OKWTroPXQe3MfiAl/KV1yiM28txz2X6JYyriPc5GBAeq90+NlNG4yKBirkYqStcPsCurOJSzGWAmLruETm5IbyTsG8MTPOQ01dPc/3T/GEtRMe3GykDb3uOXZdtb5I4GlTaBiYoRyYhnGrJ3gsn/5x781zussixnVPsFuSreIhcS08OhKa7+X0cJkCJtnq/5aTOgSCsytAl1lkJJ0WSMI61PvChs6llAm+l1QXlx9HINjBtqMrtQ1O58KjAgJMu0Xegng6SVoziCh+uDOhuagkfdumTxdwUhVgsu6TXi6rYE0pJZRmJiRg1Vkrov9khBGaKZfCr61zURjD4p2g1agBwT3Mp78fGaqwvYkv2o1r8AXgeK2f+6+5hUFWiR1knRpzaIQfEPDzQx7aFAUBWX8Ob6asA9i5pvyZRSl3GnpEz+cxCeWlepUFPwpuf3lx+kQlBsujsTCkWGZlsrcoHNF9olDbLD3xBAPxDlKm4yPMn3ryvSEAUpHihJI8CdpKiH9kbOHhVWZD14gucdhH/YbYBb7k84C0+Vzw14jPmAgSEIjhqa/0j1KS0se9QCwX15KDFqx6uC34wwypd7GLcCsDDpEd8DfblyctXRFF1UVz0IFngYBg8O4waexUAwuUKn9l9tI9BBaTLZhzWbL/FchyNDY5q/BImbLpVY21DAhYpK/sHkSm1wzCivwLQ8keKo5xhFAjXQR8Q6f32S85b
 1Hbx6Q4d
 9yXk/Ta+fKoLgmAT7Luvro2JJNodQFHA72WehDoFZbEsIFOUFt/X+0V7ahopk05cam9oTV0LjkvKGDRBqUfJwdhI+m9x8Q22zVXR7mXrkjS7C/kzK3nh+w0CsVHwSR3vpIl2iQ7ywpy8YuQuuEp28dl90OCkgMKgHmPdl6NJpLpAsqLHJHi70a/Hu8re1Cbc9g8BD95sABpVPU3QykwMB3lgFw72TulBUjYhiPY3onMvewWBju6BVHY5h9e1OuVXJoDHHvfOo9CddeqYo1SKDCWz1iNMsMyBHKdbQyPqxSpgt0eyRx+a95mBeYWPz1LyPTj7KlRBKocXUTbJ7TuhvGUHvKhRYJZt/il4TGPLVxb3gI/0J7Bi5oSCYxfTs00mggR7RrNej9/mlTJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 23-10-25 18:50:46, Dave Chinner wrote:
> On Wed, Oct 22, 2025 at 05:31:12AM -1000, Linus Torvalds wrote:
> > On Tue, 21 Oct 2025 at 22:00, Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Tue, Oct 21, 2025 at 06:25:30PM -1000, Linus Torvalds wrote:
> > > >
> > > > The sequence number check should take care of anything like that. Do
> > > > you have any reason to believe it doesn't?
> > >
> > > Invalidation doing partial folio zeroing isn't covered by the page
> > > cache delete sequence number.
> > 
> > Correct - but neither is it covered by anything else in the *regular* read path.
> > 
> > So the sequence number protects against the same case that the
> > reference count protects against: hole punching removing the whole
> > page.
> > 
> > Partial page hole-punching will fundamentally show half-way things.
> 
> Only when you have a busted implementation of the spec.
> 
> Think about it: if I said "partial page truncation will
> fundamentally show half-way things", you would shout at me that
> truncate must -never- expose half-way things to buffered reads.
> This is how truncate is specified to behave, and we don't violate
> the spec just because it is hard to implement it.

Well, as a matter of fact we can expose part-way results of truncate for
ext4 and similar filesystems not serializing reads to truncate with inode
lock. In particular for ext4 there's the i_size check in filemap_read() but
if that passes before the truncate starts, the code copying out data from
the pages can race with truncate zeroing out tail of the last page.

> We've broken truncate repeatedly over the past 20+ years in ways
> that have exposed stale data to users. This is always considered a
> critical bug that needs to be fixed ASAP.

Exposing data that was never in the file is certainly a critical bug.
Showing a mix of old and new data is not great but less severe and it seems
over the years userspace on Linux learned to live with it and reap the
performance benefit (e.g. for mixed read-write workloads to one file)...

<snip>

> Hence there is really only one behaviour that is required: whilst
> the low level operation is taking place, no external IO (read,
> write, discard, etc) can be performed over that range of the file
> being zeroed because the data andor metadata is not stable until the
> whole operation is completed by the filesystem.
> 
> Now, this doesn't obviously read on the initial invalidation races
> that are the issue being discussed here because zero's written by
> invalidation could be considered "valid" for hole punch, zero range,
> etc.
> 
> However, consider COLLAPSE_RANGE.  Page cache invalidation
> writing zeros and reads racing with that is a problem, because
> the old data at a given offset is non-zero, whilst the new data at
> the same offset is alos non-zero.
> 
> Hence if we allow the initial page cache invalidation to race with
> buffered reads, there is the possibility of random zeros appearing
> in the data being read. Because this is not old or new data, it is
> -corrupt- data.

Well, reasons like this are why for operations like COLLAPSE_RANGE ext4
reclaims the whole interval of the page cache starting with the first
affected folio to the end. So again user will either see old data (if it
managed to get the page before we invalidated the page cache) or the new
data (when it needs to read from the disk which is properly synchronized
with COLLAPSE_RANGE through invalidate_lock). I don't see these speculative
accesses changing anything in this case either.
 
> Put simply, these fallocate operations should *never* see partial
> invalidation data, and so the "old or new data" rule *must* apply to
> the initial page cache invalidation these fallocate() operations do.
> 
> Hence various fallocate() operations need to act as a full IO
> barrier. Buffered IO, page faults and direct IO all must be blocked
> and drained before the invalidation of the range begins, and must
> not be allowed to start again until after the whole operation
> completes.

Hum, I'm not sure I follow you correctly but what you describe doesn't seem
like how ext4 works. There are two different things - zeroing out of
partial folios affected by truncate, hole punch, zero range (other
fallocate operations don't zero out) and invalidation of the page cache
folios. For ext4 it is actually the removal of folios from the page cache
during invalidation + holding invalidate_lock that synchronizes with reads.
As such zeroing of partial folios *can* actually race with reads within
these partial folios and so you can get a mix of zeros and old data from
reads.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

