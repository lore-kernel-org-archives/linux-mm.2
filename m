Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9F1EC1EA6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938FA6B0089; Thu,  5 Feb 2026 06:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC086B0092; Thu,  5 Feb 2026 06:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0D86B0093; Thu,  5 Feb 2026 06:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64BE46B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:52:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E552F13B01E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:52:45 +0000 (UTC)
X-FDA: 84410241090.29.E3F0CF6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id AC15E20009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:52:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yf/YTyTq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q5Z1NplZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yf/YTyTq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q5Z1NplZ;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770292364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6i0Y+COppC7XkuUVmKQRi6WI/byuV2S9cdcfhLCB9I=;
	b=Z+WMmcqGmjaHeon4pY6N8vMKLpEFozz0zifMcfa5m0skUlQ4XX2HdAowyF0iOGVHJM2rw7
	cbgnXDxTRYzo/qFmgztFOKR6AEf1+37469LaBTo+qwmwEuor5yLeqlBDgj2oWytjufjKd2
	i0poqiTdqtIm7Ne/yVGaDv3di3ADaCo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yf/YTyTq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q5Z1NplZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yf/YTyTq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q5Z1NplZ;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770292364; a=rsa-sha256;
	cv=none;
	b=1lheBlEoEW67Bug7ghuiD9kJ23IaNRnc+rIs/j/k+CE5W1pKnOpCjjgpluyNQ/fYWeqV99
	L4i79cL4Lg2T6IjiUiFdFSGTesmAcLWGYLcQRlec9m06BKujxJP7u9JIpJZ/QRgTCcywP5
	8IPyIXIZGL8QE1zsQSV3oqtUggv1P4w=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D24E5BD94;
	Thu,  5 Feb 2026 11:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770292361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6i0Y+COppC7XkuUVmKQRi6WI/byuV2S9cdcfhLCB9I=;
	b=yf/YTyTq8BKlF5Yp+lwfFt3AYI4+FED/rliHSVlUYszpHUcyIITvQqhE3xvLSVEIs5kevR
	70myIE/skRg/ZWd9uQDBfeGOOSQXpaCCy8kUdVetFWN1nRX4VyhkBHVisv6jVPn+hGhQrS
	Fc311HyyKDpi9VxTsmWKbCtWe9lWnlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770292361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6i0Y+COppC7XkuUVmKQRi6WI/byuV2S9cdcfhLCB9I=;
	b=q5Z1NplZ8YAxWXVjC1jg1js+QwkAx5qITWpJMXjBD1eXo1YDNU1TU7Qs0B7HRuzT/QAnLE
	p8776fmdz5Rzd0DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770292361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6i0Y+COppC7XkuUVmKQRi6WI/byuV2S9cdcfhLCB9I=;
	b=yf/YTyTq8BKlF5Yp+lwfFt3AYI4+FED/rliHSVlUYszpHUcyIITvQqhE3xvLSVEIs5kevR
	70myIE/skRg/ZWd9uQDBfeGOOSQXpaCCy8kUdVetFWN1nRX4VyhkBHVisv6jVPn+hGhQrS
	Fc311HyyKDpi9VxTsmWKbCtWe9lWnlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770292361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6i0Y+COppC7XkuUVmKQRi6WI/byuV2S9cdcfhLCB9I=;
	b=q5Z1NplZ8YAxWXVjC1jg1js+QwkAx5qITWpJMXjBD1eXo1YDNU1TU7Qs0B7HRuzT/QAnLE
	p8776fmdz5Rzd0DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 722333EA63;
	Thu,  5 Feb 2026 11:52:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IobZG4mEhGlGegAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Feb 2026 11:52:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 23A65A09D8; Thu,  5 Feb 2026 12:52:37 +0100 (CET)
Date: Thu, 5 Feb 2026 12:52:37 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] export file_close_fd and task_work_add
Message-ID: <luj2ggjo47mvjzhzavoy72ro6kaoj46cicudjrc6646vs3s7q5@wzc7aabgdlkl>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com>
 <20260205-mitschnitt-pfirsich-148a5026fc36@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205-mitschnitt-pfirsich-148a5026fc36@brauner>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC15E20009
X-Stat-Signature: impatk5snqb77971pnmti4rpocs39qhu
X-Rspam-User: 
X-HE-Tag: 1770292363-163942
X-HE-Meta: U2FsdGVkX1+1QJ4ccYnD27su88GjbnT1pTbAB1VKXPYD5JMCVPQHdbst905GpNMcCX2F7DBuqf4lnu20wxSpUmHTcaeaCAno68HdFLqX56UrpaWOIddvaI74R/0V8o9OFf43gHRaLQ/6qccOBg5KnWjdQv5hWa8wk3ZgBFc8SU4mKyyC/wTZGu6i+EZI+G0LzCiwcmVoe4unMwxbn/gobATCWB7nsfhwZnmME9IrrV35dWARruXuSo0QWBe089QNzZioBWYrKUm1xBQPWTuvwV/OAA73W6dr445OFdM1vLCBxE5wcn+OcAfZIDdlEQQEdGEft6Xk8CLovG4LioBFM0QeM/epbKQ9UB4bSsmO8I7ri3kr+v7eMEiQJSWxwWOeX7Q62EgrQtaVYd0MC1G7GX+8KGWcbzeJwFV3iV06YWYtRPsN4FlelKoO0EhOo0+C698KqbBaWT5Zzi0S1jjXu+l2JY8gv+VsoYToY7w07rKx5zF7UeP8a3GSjHeU/mdFQtLE34cNdiWCkj8LEn0WH+4ik3JHed3BRKkAa9IaI62BgcTV+9Oyp6G11beLydOlrq30tAn86Fit7/reu/CoDvUkFnnLsYlDfwfKGG3sbsKnulF80SDIRj5ssRc0f5nYd7b4gBSY0c/H62MiNgb9TrZqpipiiUuNo4aUj20PfwSYtOzDiBpnKWOW1rWoFvJbRJnXm/3ucrO0vfiuvsLLHK5SxNb+1SjQmGp2DDECOlBARwLQAr5f23a2Cm+yUg9lSeH+TM5A8KoGcUiropXLuvIEzhjhO9vCYXUP9nmB8sxeCRZKfGo+YRaR/mtUUokWW+A2xCA+m0S3sLgWPgA15pc2+85R3P00TzWB0jkJmZoWuHCGjZW8iLat1Kp2H7rNdkyRYAmhCJhaTKNpM6plz49UhyrzeqAAxojD49mrT5dtcPFOkuvfoB713sum2MdliJ9NxWDz0Q/D0q70beI
 AER3/4mZ
 gyUE9c6he6EwzITXhJWmkLBR8IxoPVifKIdiq/lT3q8LbT+uhOHH3BR1Wv5px4w6rw6Q5nLotmp0KLbQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 05-02-26 12:38:22, Christian Brauner wrote:
> On Thu, Feb 05, 2026 at 10:51:26AM +0000, Alice Ryhl wrote:
> > This exports the functionality needed by Binder to close file
> > descriptors.
> > 
> > When you send a fd over Binder, what happens is this:
> > 
> > 1. The sending process turns the fd into a struct file and stores it in
> >    the transaction object.
> > 2. When the receiving process gets the message, the fd is installed as a
> >    fd into the current process.
> > 3. When the receiving process is done handling the message, it tells
> >    Binder to clean up the transaction. As part of this, fds embedded in
> >    the transaction are closed.
> > 
> > Note that it was not always implemented like this. Previously the
> > sending process would install the fd directly into the receiving proc in
> > step 1, but as discussed previously [1] this is not ideal and has since
> > been changed so that fd install happens during receive.
> > 
> > The functions being exported here are for closing the fd in step 3. They
> > are required because closing a fd from an ioctl is in general not safe.
> > This is to meet the requirements for using fdget(), which is used by the
> > ioctl framework code before calling into the driver's implementation of
> > the ioctl. Binder works around this with this sequence of operations:
> > 
> > 1. file_close_fd()
> > 2. get_file()
> > 3. filp_close()
> > 4. task_work_add(current, TWA_RESUME)
> > 5. <binder returns from ioctl>
> > 6. fput()
> > 
> > This ensures that when fput() is called in the task work, the fdget()
> > that the ioctl framework code uses has already been fdput(), so if the
> > fd being closed happens to be the same fd, then the fd is not closed
> > in violation of the fdget() rules.
> > 
> > Link: https://lore.kernel.org/all/20180730203633.GC12962@bombadil.infradead.org/ [1]
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >  fs/file.c          | 1 +
> >  kernel/task_work.c | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index 0a4f3bdb2dec6284a0c7b9687213137f2eecb250..0046d0034bf16270cdea7e30a86866ebea3a5a81 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -881,6 +881,7 @@ struct file *file_close_fd(unsigned int fd)
> >  
> >  	return file;
> >  }
> > +EXPORT_SYMBOL(file_close_fd);
> >  
> >  void do_close_on_exec(struct files_struct *files)
> >  {
> > diff --git a/kernel/task_work.c b/kernel/task_work.c
> > index 0f7519f8e7c93f9a4536c26a341255799c320432..08eb29abaea6b98cc443d1087ddb1d0f1a38c9ae 100644
> > --- a/kernel/task_work.c
> > +++ b/kernel/task_work.c
> > @@ -102,6 +102,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
> >  
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(task_work_add);
> 
> Uhm, no. We're not going to export task_work_add() to let random drivers
> queue up work for a task when it returns to userspace. That just screams
> bugs and deadlocks at full capacity. Sorry, no.

Agreed. And just to demonstrate the point binder's use would become the
first of such bugs because it is prone to the module being removed while
the task work is in flight and thus do_close_fd() code can be freed by the
time it gets executed.

Generally, making some code modular usually requires more effort than just
flipping the Kconfig to tristate. You usually need to make sure all objects
and queued work is flushed before the module can be removed. Not sure how
much of this is taken care of by Rust though...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

