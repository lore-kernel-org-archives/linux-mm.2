Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8883CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143FF6B0088; Tue,  2 Jun 2026 13:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE756B008A; Tue,  2 Jun 2026 13:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE5D6B008C; Tue,  2 Jun 2026 13:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEA996B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:35:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E0071A08BC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:35:57 +0000 (UTC)
X-FDA: 84835675554.29.6F1EA8D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E91B180006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:35:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJcmiZ+I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jhN2GYkS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CjoN6ud0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d+8GAyg8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780421755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzdYszYKaK4b4vH0SnQI6TUiWFf8bFm1Ogb1TfiqgZs=;
	b=MATEB2MYEjdBEFgad/9uKkXFD/z7hAp96ZASg5V9dPGi4rakSyX+RCjjOB9uWELoYcbPrp
	QBUm0+Y13mlfs6UT+ffshI4OA4NkWl9d+OlW3kVpf1r9rugJvx3oErXd/JcYBnL7EeGX9Y
	Wy+xUb3icZrZtptRAu8KbGgYaS5147I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJcmiZ+I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jhN2GYkS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CjoN6ud0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d+8GAyg8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780421755;
	b=ELqmhlpelbWyNjIF5BCH2VAxgrOCBifdvSnHK+oZuUGtfyGSCSHpw8vJhgdYcAOJJsqv5m
	I7jsCNfxcy1sVM8x/r+K81nGTWzwnF2aO9Y7eGJDYSj7Fh1poQ/EkPLOMCQPM5bGL4mdvC
	QZ8Q3eXlB3mDUBjw6GLt7RR6p+NLfqo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C33E275BE7;
	Tue,  2 Jun 2026 17:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780421753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PzdYszYKaK4b4vH0SnQI6TUiWFf8bFm1Ogb1TfiqgZs=;
	b=oJcmiZ+IRDb0Vl8+5HTv2yX/FDF9rGccWP37o6YhmvUhiE2iOxo3tg5UegmyBF2vhhgR4b
	Bn0yWmBg2jeI/af12tSnXAWoTv6YHiNlxM75JHnWcI0qPQ6m/dQe/olnfe5LbEpVl48w1F
	Zn5QLciVSgcBoN4ANRIvAu6btk/OF6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780421753;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PzdYszYKaK4b4vH0SnQI6TUiWFf8bFm1Ogb1TfiqgZs=;
	b=jhN2GYkSZ6ZmL7SlhUTGxGK8CGKvahfHmS6TdWBw2sjqUP11uu8YbNTC0yD4ZwQRc7jxoy
	7y47Oyq0haBSpRCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780421752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PzdYszYKaK4b4vH0SnQI6TUiWFf8bFm1Ogb1TfiqgZs=;
	b=CjoN6ud0xM6zZLHHr+iDUEJvlRR5Tcqe7CvaIG+t31o4cy6J/x5ZZFE/0EuCt9l70ftEzF
	4L2SgHs9MheGVMjLGRN+ReW6rIzJF3ziG39/Txnz/q21ehkbfyJulncwGEdvfmSZt2Eu6v
	YN3wdIaK7Ymkb7hLrFH7QvFmi3zUJcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780421752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PzdYszYKaK4b4vH0SnQI6TUiWFf8bFm1Ogb1TfiqgZs=;
	b=d+8GAyg8Gv/8dblHxs6OE+NHkcm59mYKFHrOEl4A53724DsuXV2AEYoC1YVWXKOJkRxAv6
	CItYWAayJ3znFBBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D53F779A7;
	Tue,  2 Jun 2026 17:35:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TNkpE3YUH2oqKgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 17:35:50 +0000
Date: Tue, 2 Jun 2026 18:35:48 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Usama Arif <usama.arif@linux.dev>, willy@infradead.org, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	r@hev.cc, Andrew Donnellan <andrew+kernel@donnellan.id.au>, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org, 
	kevin.brodsky@arm.com, lance.yang@linux.dev, "Liam R. Howlett" <liam@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
Message-ID: <ah8Qcxuugn5tTilK@pedro-suse>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
 <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
 <ahmSolHvUChl-3vM@pedro-suse.lan>
 <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
 <u52xvwk2fjjk2izdb4wvuqq2zhc5neb4q6usimcxejluuyngxw@d64sc6rvojyp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u52xvwk2fjjk2izdb4wvuqq2zhc5neb4q6usimcxejluuyngxw@d64sc6rvojyp>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E91B180006
X-Stat-Signature: 97wbkezmot31si5fbce4mxt3k3pyxa3w
X-HE-Tag: 1780421755-392409
X-HE-Meta: U2FsdGVkX18ahS4PTcmK1cn2x1/FvZRFORIEREPd26WrRyRJOZDdf4wICFWZI4e3dBFVwIrJKsV/Lruiy+mQ0o+l/wJmlN42GttB923IrcXfTj3EwX1/2WnIWy1I6r6uGCDvuplrhv088FZtMyF02xuM2b1DvsRaPWIW5SebQvYkyWJ7evWACt31QuwH/CQMqRC8xfoqqwbnbAjc9OtgT1VnxtCTlOEHc4lHvpBTqs6Rx6w0dFhHLuLcVEB/+GukJrw/SmuBmQq8kiVXVrCrGp8x0dHoE9IRWRRyTibmuuEnMo5KT9qeY70uCEQUxv5TZTC6aaHwMabah8N4eN1Ub8YUMA7lyfachu/M+SX3mZqyJ5Cz41Oij5JlhgjQMfjI2lCbNvVWVOXIuYns386+Y51PWuGp7xDW9eIn8E22YQzM97PhvwciJTCuGnxIHa14T7QqtiBET6qv2371TCcczcYtJJp7fQCwkQggqvu2PsVO+NmbuhexLaJl6K9qCcxNCfZV+srMvv7gnnd2YBn6WHsBPcj34XzJatIkRtYT/ZHCT/Ag0qAyctimYe5wNvPnP4iUagKurhw3aLzDhJFeGNrRYDpQziksMABI4TYyG0TwqjUk46w2bWyI4NuFvzRyDEcVwixY4lQD0U62VihrHiC/JEDzO350/I6gpWMGn1mYOcL1wV6xMtwBzdPqnW/hQAwA5POXByOXBALN56dKBY8xPjXf0/XPx0jap41uHWWATKQJ8qvGe+df6GUg4ZEe+VCVI5CqIGzc8ey9RJ6n5hCYLmbJ4eJrdPSL2peh3pte5yCv5TsplP0jSqxOaPPNnm1IJnk0YWlNCAvDQdn4VM6OtQsU5tO2iqCAS+HJpkiEVb7TCox3oPyrRV3wrUlll0CRxE+Jfy7BjBFU9F/rqByKqAqM49fDB8ka9KzSn9JgGdeatYcaQ/TJyZbINz0P9nimEOPIKJh1eAv3JLH
 OlJMotMB
 hoj9QbpyvRr1dm8zcri7e7lteNmXwxiDs/6UgsOhmEdioKQAul1h5nurqmQFb7HAqjXTDtSeqipPoDs9C2VNTFQXdD9E0qqKJLlnZwwhxvbfDPbu7JSm1xZYTFTYP5Ye/l39vUsFi+F1du4Ml5KtybTNwirIJqc6kO05VdxVb/oMZP5HjEHHcGCIz4gu+Uu6y35OacGSCf1tcCrwunFpe9PSqMixjJfODyxdZiyR1SIHO5CBAxQr2H4huYGwEFNqAcStMz0XN5d5DSb94kTHRM6/SfbWxizcO8zWwTEhxOx9PMKdr1DjY/VZ4FdHtAhgt1qFwWS+YKCbh4qqcEGodo8TmSLkDa0MQOOEs72AfJgOx2dj40CCZdP8Qb0shPhs8EjT2xq7RZQIo3M05gwkAdxz6aYX00n4QYZgAZ8Ayb0gNyGvSQpv310pm13hGQs4iCqBua64lrxcdNDbg+5m1eajfMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 05:16:29PM +0200, Jan Kara wrote:
> On Fri 29-05-26 15:11:54, Usama Arif wrote:
> > On 29/05/2026 14:40, Pedro Falcato wrote:
> > > On Fri, May 29, 2026 at 01:19:03PM +0100, Usama Arif wrote:
> > >>
> > >> which means mapping_max_folio_order(mapping) <= MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always
> > >> true, and you dont need the min3(..) in your diff.
> > >>
> > >> Now the question is if then why not just do:
> > >>
> > >> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
> > >> 		if (mapping_large_folio_support(mapping)) {
> > >> 			force_thp_readahead = true;
> > >> 			thp_order = min_t(unsigned int,
> > >> 					  mapping_max_folio_order(mapping),
> > >> 					  get_order(SZ_2M));
> > >> 		}
> > >> 	}
> > >>
> > >>
> > >> This is because this will regress the 16K ARM case where we already got 32M
> > >> folios. Someone might upgrade the kernel and start getting 2M folios now.
> > > 
> > > So maybe limit to 32MB? It's still arbitrary but at least you get simpler
> > > logic. If the architecture does not support 32MiB folios, it will clamp
> > > the maximum folio order to HPAGE_PMD_ORDER, and you get the same result.
> > > 
> > > Does this sound correct?
> > > 
> > 
> > Yes, so if we replace it with SZ_32M, it sounds correct. I just think
> > the 32M size is too large. But as you pointed out, even 2M can be too large...
> 
> So AFAIU the practical discussion is about two options:
> 
> 1) limiting at 2MB with a slighly more complicated logic to keep mapping at
> PMD order for 16k pagesize on ARM but use 2MB pages for 64k pagesize on ARM
> 
> or
> 
> 2) limit at 32MB with simple logic which results in larger (32MB) folios
> with 16k and 64k pagesize on ARM and thus larger memory overhead.
> 
> I'd like to maybe offer option 3): limit at 2MB with simple logic. This
> will reduce folio size on 16k pagesize ARM compared to 1) but do we really
> care? I.e., is there big enough practical performance impact with conpte
> and other tricks ARM is playing?
> 

arm64 16K contpte tops out at 256KB TLB entries. It's quite a lot smaller than
a PMD entry. Also, something that was discussed at LSFMM was its effectiveness.
Apparently, most of the gains seem to sit on actually having a larger page size
(perhaps Dev/Ryan can comment; sadly the slides were not posted anywhere on
the ML, so I don't have numbers).

To me, the question is quite clear: do we trust users that say "please give me
hugepages" enough to unconditionally give them hugepages? I would assume the
answer lies somewhere between "yes" and "no", but 32MB I would say is not
particularly excessive. 512MB is... much worse.

-- 
Pedro

