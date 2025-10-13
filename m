Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB6C6CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486CD8E0013; Mon, 13 Oct 2025 04:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F6F8E0002; Mon, 13 Oct 2025 04:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D9D8E0013; Mon, 13 Oct 2025 04:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2132F8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:02:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE18F86BF2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:02:34 +0000 (UTC)
X-FDA: 83992349028.03.0E1D959
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 918CEC0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:02:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LqT5YqsW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vgVVVQMS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oEiSGFhA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7whrss6A;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SMGMAUukUxpNjNcKVJwA9a+7Snorm+D13jrnLntxKU=;
	b=UMdlPWu1buw61lrpvWwbTn8U9mMlK7ZDbZ//IJQWwlTcJntfh7GckKZ8tajOg7a1MOBzbH
	6/0NAu1bpdGJi2J+4PNHd3qtqFfUJnby9FJQn1A1vPi9brFb4iH+tZvEXJCyPPlNnN/C57
	Ysrp9dxltUW2R70o/rN68W79K9GFOh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342552; a=rsa-sha256;
	cv=none;
	b=kYKv0gCHIo+63dI37WYALGOvwx9bkYKpPQGOqArvgO6lN5+UawXZl4GOiFaknWt+QyHqfG
	4F4vPiPFQX9obzVfnQY0l4CUCIPSNBfBPyhN8Y0ssnsLYoCMwKWMgn8MJZ8lBBl6sVPBXm
	hmzipW40A/WgSQwGfxK8cM83L98i8jc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LqT5YqsW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vgVVVQMS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oEiSGFhA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7whrss6A;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C9F21F798;
	Mon, 13 Oct 2025 08:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+SMGMAUukUxpNjNcKVJwA9a+7Snorm+D13jrnLntxKU=;
	b=LqT5YqsWJ0Vgpux0nxYmAAOYFr7l3RBYqrewCzQXffUENxnRGvclxlDr6L6nV8PBlATwcI
	xc6u+Giab0ktqrnOdOOzmAGYZhnH7m8cusJJJ0QBQxgpWA30Ca2WUNXCjrSlPpShILrmq2
	xzoXL6BivvfunDbvRHAZd9hnJ9rcfdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342550;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+SMGMAUukUxpNjNcKVJwA9a+7Snorm+D13jrnLntxKU=;
	b=vgVVVQMSlR9JSz7QkBw/COiNTfIyqbaJ8RZ/R+ae7iRS9uxPJ6wOrtgrUUCYf6+4m1syfh
	WxQLeoRnDQ+a9nBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+SMGMAUukUxpNjNcKVJwA9a+7Snorm+D13jrnLntxKU=;
	b=oEiSGFhAR2iiY5Lfsas+XhOzSRRyNJtHAnV8zGMdHGiFSVvDG4LKwwTjR+UuZchXcSP8pX
	vCGSl1eG4qMWBOV0FROTQ1vgbsbCM/BgWN9aNu20FXoPGBoYJDNYyyPm6O+NTAaEwt5P4s
	h+DkDrUvD+BV+CX5rsIuSQqEFhkGkH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342548;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+SMGMAUukUxpNjNcKVJwA9a+7Snorm+D13jrnLntxKU=;
	b=7whrss6AXT0MVcTpt+7UM2abqodWxJ7/XZDk2FsS83j5C8mKART2fb8FVK8G4vJODeCGMG
	JOXtoO6uOci1yWAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96E9A13874;
	Mon, 13 Oct 2025 08:02:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Gq0FIhOy7GjQEwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Oct 2025 08:02:27 +0000
Date: Mon, 13 Oct 2025 10:02:25 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <jackmanb@google.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	Michal Hocko <mhocko@suse.com>,
	Network Development <netdev@vger.kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
	Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com,
	bpf <bpf@vger.kernel.org>
Subject: Re: [syzbot] [mm?] WARNING: locking bug in __set_page_owner (2)
Message-ID: <aOyyER1uSsPl5b7a@localhost.localdomain>
References: <68e7e6ad.a70a0220.126b66.0043.GAE@google.com>
 <20251009165241.4d78dc5d9fa5525d988806b5@linux-foundation.org>
 <CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 918CEC0009
X-Rspamd-Server: rspam02
X-Stat-Signature: dz9se8dwc8nh8e6d5t3o4a8zs4fj9ymt
X-HE-Tag: 1760342552-430766
X-HE-Meta: U2FsdGVkX18Vk3rPyYPGTy3QgfpRrEVlFgUx/5ztCBkd9HJwp8R2NKhqlBpabK7JAnDHjqrRbGgYo2SFxdPNCMIY4y9wOgA0Xw75UsyQ7s51N4Q7pw2AYP7HqzXnJtJRunvdoG53ErKP9/R81Hk1qsK+DVnIaTYLxp7XQngmdgeFMubT0hafhn2guK6y7HarfSD47EpV7B+HKkskB4QrmYj0imoNIAsupotCttmX2rsJXF5qsqPi8yuBGZXEELme2C3GBxqOHOA77vncc2KmVkBTBE6u9nmLegGZF793OwudX3IVqQGLOpWZgMUGiWmeTCtIBjHgIgp3YeL/AzIcwO5f1x3v51gIUHXvMlpBKTdzh2emrKbILrNBANEUlRIVOXzaOjvMxjllKOVYsMEjGloZExDHEE8dARctR2TqPYfEEXl4ch2/lL6zZ0K5nwsT0ye3hHXZm9oWG0J2SrIbcjpUlZ7cno8ZKov8KIgXSTHneAKIKzk/irkrAPGFl4kpFRMnZkRvBdM+VsS227tQBZ5ZGCz48xAehukO3bEiEyg5KUc9pn8e0kDBTiUFiK5a3v0zeo1LsblPXmspnpx/2DpKLBOMPjVnDjjuIXyaSst3Pfn91eZQUcnkzNqs7c3EDWxJ43BMGMvc6/jznSlATPCJuK/tCyQH1K1tMvvtOL7BfSxlZhQVVTnzw/vV69BVpsupSiL8G5w2Ix2HPDPJcI9JNfVdMabuf7JKkk0KPS7ztc2OOrnRjPn3FbNf141m6HipnwaiqGZcLAEgzR5l07Vs+Rg6zY4JPQht7gH5V2hqy8CD1Wu1r1kwQP0ZnlqOhQIxJEhFNcqfNZmMBxXH7qauPP94a0KgcnUKkkpor9fMRMEn5Hiyuo1svF+AFovB87T0EnF/ODE3Cvu1On3wnORH3MbAz4rJx1khWYRkDkktYhTJlw+m8GbJPmGpnxX6FZ9Dmm8TeEA8hZ4fVlW
 UjXLbEmC
 2JPYggz5VscihPwHw+fAdlI97boy9/8L9GecVvUnmwBcAF7wBHiPUNenn6zK1A406c7YhWPxXGx9ZJol555rhf9/elm3ZM4Fe0uwEBsyrWZMP6vzl9CYdQQ1a2XW/QzF8eBeMeSHZb8RkIcXaq4YA7tL/Hg4hyB8FNNwTbHCRrhHa22XLTAMTq+CDQPUtQlgseZrUzcdQVjnfEMfm2Gu2MxZDlgxXDs8luOnqyWCMqW2CEbuDebQIESZCsVcaV9lOQzcqn92vB4dFhRJNbbIkwXEZfTHSwjl6hbuAq6Xf/bCwgNwZ5JcCuNCi9ZCwFXpFLmNrJ+YxdVmOWSETo1pklrbPoWW0ulIm4y/W/gMYqd6jK0emBHzaTQ+0XBfrGepWK6DLJ1hRrnC6Ek17wK+yJ+0tJ/9tbZrr1OBym9PY9aOsN7A+Il+tTz+XiUmujgQ4ayvzTlZr7I+mJVqWmGNhyphInKXqe8AH7OMvNz6a8uXVH4/O6t0MGAlKIUWal/g2x4QC2NuLUvx8+OZhFe6glVC1jw48gINAgx+BwvXhKM1daP/vUgcPRKJx2h+wRxvXfYCK9VMhqd3aRCCllCFhLAuCKC6sXt5K4vSD6zDBvV952oB8gXVSlqX0q8svtP6X0y9SXs1WE0+O/czALtyvZuxWpzS2qM1E/GEAo7j8w3xKbATBNriKNAkFLpqKcdSk5NrHqYRJDR5S4u3xU2wuo5qFxTKKAJwBh8gvOwjdSXIf1HOugnU5w7gryKbm8Wtq1GjBt7a9rs9399SKCSL79OTF83ywwpw6nxDu7WR7N4nGhaUYknQVv+6rAajtzFB2qxune4QOIUnr9HjQQzd8nm3bWXCgWxVsNDXIJHT1YmKLUTNgj0qd4aFcA2UgRakrA+xRBlXZjxziJfp/whQmj+FLDMFWi3EddyLTPeGTKmgYuJCMePHsvY0wnVKMav8XIYRb/IElgdfOZ+Kh4GMhbRRT9Y5J
 fV2MuypW
 xdZNVK3Etpq2s6jXDOA4iDm6XCOqBEQW5r9c7xHG7u4uBmAcWpFE0wZ2WgwYHVi8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 05:26:21PM -0700, Alexei Starovoitov wrote:
> On Thu, Oct 9, 2025 at 4:52 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 09 Oct 2025 09:45:33 -0700 syzbot <syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com> wrote:
> >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    2c95a756e0cf net: pse-pd: tps23881: Fix current measuremen..
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16e1852f980000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5bcbbf19237350b5
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=8259e1d0e3ae8ed0c490
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/8272657e4298/disk-2c95a756.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/4e53ba690f28/vmlinux-2c95a756.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/6112d620d6fc/bzImage-2c95a756.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com
> >
> > At 2c95a756e0cf, page_owner.c hasn't been modified in a couple of years.
> >
> > How can add_stack_record_to_list()'s spin_lock_irqsave() be "invalid
> > wait context"?  In NMI, yes, but the trace doesn't indicate that we're
> > in an NMI.
> >
> > Confused.  I'm suspecting BPF involvement.  Cc'ed for help, please.
> 
> The attached patch should fix it.
> There are different options, but this one is the simplest.

Seems quite trivial to backport, so:

Reviewed-by: Oscar Salvador <osalvador@suse.de>




-- 
Oscar Salvador
SUSE Labs

