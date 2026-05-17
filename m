Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06521CD4851
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 00:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF3F6B0005; Sat, 16 May 2026 20:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8FD06B0088; Sat, 16 May 2026 20:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E566B008C; Sat, 16 May 2026 20:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B82856B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 20:52:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1220E12044A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 00:52:35 +0000 (UTC)
X-FDA: 84775086270.27.B80DFD5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9CA3C180003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 00:52:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rXTqKtS3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K8tXsDjw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rXTqKtS3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K8tXsDjw;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778979152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgNm+GHE162l/M3+rLZxQ4Q5A14XvmlbUkDNHLqiHsk=;
	b=hxJxIWjKsiTj4GqNFZ6s7stLUXHV5BBweW5yaYwYWvy1doSEg5QO0qn81XsY3AA7gvOhEK
	2EgV9oBfZk1vmi6/i16Dnbs1e6YF6kaF+I2gA05J3sOY0xEmrzDhq2Mdx8hmmBW5/8TWkK
	KzaA2t6wyJr5S3xHGaqXg5vtZ0UD4XE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778979152; a=rsa-sha256;
	cv=none;
	b=kyHEoK7JXysEjsYGtb6zR3OiFBLzFf974ZdsmjVHzDf0sfWkWetIyIhb6sYvnBg8r8Ty+S
	sXsfq5co8GB8aNww5jAjk7xQtA8YFqF+v7H+XXCbz+VgL7uYqp+dt1okZomP7DZyru7o4i
	OCZwBcXSlTpFEXY6xcCPDK/2ZMNw/GI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rXTqKtS3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K8tXsDjw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rXTqKtS3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K8tXsDjw;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D36C61C52;
	Sun, 17 May 2026 00:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778979150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SgNm+GHE162l/M3+rLZxQ4Q5A14XvmlbUkDNHLqiHsk=;
	b=rXTqKtS3EuWQlJX5FG+D4OM/KwMFoVZ+RSkRRp11zIdSylOCQEMQriIsPszaT7FqPnFujv
	SFTE6HxUKqkTwE372+ivOjpbMB9IkbtZIfLVsmPhcYfCJ+9ZGrSZZhYdDm8Psi/iHTOz/5
	ZxvhRTbsZ4IpUMsag1wrd6hblvoNgEg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778979150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SgNm+GHE162l/M3+rLZxQ4Q5A14XvmlbUkDNHLqiHsk=;
	b=K8tXsDjwH8Huyie2WoWq03MC1RGXGTbzykdeii8hzxAA8CNYdyR1RUfPPE4SCc3/+tfW/I
	pVNPU+5wvOyMJeCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778979150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SgNm+GHE162l/M3+rLZxQ4Q5A14XvmlbUkDNHLqiHsk=;
	b=rXTqKtS3EuWQlJX5FG+D4OM/KwMFoVZ+RSkRRp11zIdSylOCQEMQriIsPszaT7FqPnFujv
	SFTE6HxUKqkTwE372+ivOjpbMB9IkbtZIfLVsmPhcYfCJ+9ZGrSZZhYdDm8Psi/iHTOz/5
	ZxvhRTbsZ4IpUMsag1wrd6hblvoNgEg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778979150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SgNm+GHE162l/M3+rLZxQ4Q5A14XvmlbUkDNHLqiHsk=;
	b=K8tXsDjwH8Huyie2WoWq03MC1RGXGTbzykdeii8hzxAA8CNYdyR1RUfPPE4SCc3/+tfW/I
	pVNPU+5wvOyMJeCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E110A593A8;
	Sun, 17 May 2026 00:52:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PFANM00RCWrBUAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sun, 17 May 2026 00:52:29 +0000
Date: Sun, 17 May 2026 01:52:27 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <agkIJF5EiAYLWjA4@pedro-suse.lan>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <CAGudoHHeYbPWQbz+vXoS-Oi4PhxX6rh5XsMUkZetyfdnJHNj=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHHeYbPWQbz+vXoS-Oi4PhxX6rh5XsMUkZetyfdnJHNj=g@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CA3C180003
X-Rspam-User: 
X-Stat-Signature: n7xw3fwodhu5q386tcrftouzycccg7ug
X-HE-Tag: 1778979152-691876
X-HE-Meta: U2FsdGVkX19d1ZqN/2LLIwbpxFiGIY3/+VBJlVK6ClqnLsohl4jQ6ypDloTd48ub5S+3KfsQYxsMXo5WDHxemOuDSFQn/R4AGb+IFFd/nqOvUU0RCGjChyGTNOKzb6z6mp6yaUI+FOq3Qy87Se++WUcIS69G36UR/k0CHvFpTCGtK7i3EM3yQ2dcA1YL8EIwkhzby3VarhjAC07kmnBKtyWkGfIjI7wY/LiAGBNCGKXhk28dv28iRZoVlrNjicj552T+pedalcj9YF/AJOEWEDTQZDYlzhND9tOwOAcEFomU7zb7jg24brEyjM7eex/1dthwzDErTrJ06GXl19pVeZKbxqxtq98KFhMA9NqhKu7XN/rLpO64lPGVHRYYiLTAZUxuYmfkccA2gW+N3ckEQOGWKhveCNaofpeq4FB1XWg5umgii/JAFh9L1mabL+u5xmAwImTQ/XoyA+e5SJvbTeUxl6ZgKwFXyUt0F5kPogdtyNgoOiqGFhV399bSHxsWvaSPZ0aLAiT0W0M+GqFYfEUvbZRD+rhh/4Ez0JthxQj+Yoj9zK8AfpDgQrX2TYPxnTyY2PSPG3Y61oZHkgKIw5AP+7dfk0P4/JPHxztpo5n48S7u/8APUG+e5boJDubnIebXjjVkbd4Gwx4BYHB68soLsQ9hBYiAK6f/pXpMYoBrBU+TNj76XdJo9/cHnTFpKDNKkCAZFgDc4mjiakGB2wWL8CEHqquiblN358qSAah4OkhCvY1Lz1NEqi/YUJd7y4IDm41Sb6DXtdT4CUfGCrUTr459YDMTzTS6Ehi1jHABVv2xUfVWVQuFjH8bAaE59Lme46SSpHDnmOvY2RGElrFu5xRkLf9zH5GUB7WbgFOOak8B7+LXQ2UaMfOvsIpdioUlvhyOH/cDao3GRyfRIn9WFxLfmCS5oYGbUs+pIlGLMgKy/ySTT32w3gn2CJ27+cH9IQFZpy3U/2OPm62
 SelmsjiO
 quW76UKU5hfr9L4s5u6ISxWJEda+ba6zvasnAcGG67/OF4GMkCY/FIjeYcmay95HRdQYgwBES3zamlj5hxRgMGXiF5FnJxxY+ZgDGVv3YhHF86Mk8vvspLExROoOY/vDTtCHYy4a19+MDWtB7aypW9bDBe19YNfFAobzjNXgVj2WgAjAETtyJvYi5lzpUnDaq4P4WwbhNRNFGKhC3zs2p8YsKLTqhA9ubXBJpHpWM1pU27y4PQFjqwTQ51X6WxQERZD/HbCFfX6GfYEZufwDVFlkId7r2RU6/wpNGQawDtroPvH0/nkDrHxnqR281r5885XE3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 01:51:16AM +0200, Mateusz Guzik wrote:
> On Sat, May 16, 2026 at 8:21 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > Since the advent of vulns like Dirty Pipe, Dirty Frag, Copy Fail
> > and Fragnasia, splicing a read-only file is fundamentally unsafe.
> >
> > As such, as a mitigation, add a way for users to block splice() for
> > files they cannot write to. This eliminates this whole class of exploits
> > that use splice()+confusion in pipe/net/etc code to gain write-access to
> > files they can only read.
> >
> 
> The patch touches stuff I'm not familiar with, so no comments on that front.
> 
> The core idea is a half-measure which will at best buy few weeks until
> splice bugs dry out and there will be a new attack vector du jour
> which people point their LLMs at. Perhaps it is worth it as a bandaid
> until a more complete solution shows up.

I won't say you don't have a point. However, the whole idea is to attempt to
restrict the attack vector. This is a proven source of problems. It's known
since 2022 - now we have 3 or 4 new vulnerabilities taking advantage of this.

Clearly, the kernel isn't doing great passing these pages around the kernel.
The API isn't the easiest to use (much less safely). Can those be tackled? Yes.
Today? Definitely not. In a few years? Also doubtful.

Merging something like this (or equivalent, that allows for a restriction) I
think is simply common sense. Basic hardening of interfaces so if anything
gets discovered it's much less severe. Even if nothing else related to splice()
gets discovered, I think it's still useful to have secure by default, minimally
intrusive hardening in the kernel.

One example: do you really need to be able to send SUID binaries in a zero-copy
super efficient way around the kernel? Not really. But if something fscks it up,
you get the world's easiest LPE.

(not that today they couldn't find some random UAF and attempt to exploit this,
since all of the page cache is mapped, but there are concurrent efforts e.g ASI
that attempt to tackle this)

> 
> A full-measure solution would git rm these modules to
> fuck^W^W^W^W^W^Wprevent suspicious modules from being usable by
> unprivileged users to begin with, at least by default. Of the cases I

Sadly, for the networking case it's pretty important to have autoloading
for protocol modules. Also, for the module in question (for Fragnesia it was
ESP), that's really not that arcane. It's just a piece of code that gets
confused as to whether or not it owns (versus "shares", like it should) the
pages it's looking at.

With fragnesia it's been found out that there are _several_ important spots
in the networking stack that aren't getting this shared flag propagation
correctly.

> had seen so far, your typical machine either does not have the thing
> loaded or in the worst case does not have a legitimate reason to
> expose them. Someone(tm) would have to figure out a sensible setup
> where stuff stops autoloading and there is a whitelist of modules
> allowed on the box, and even then the functionality provided is only
> usable by select people.
> 
> Back in the day I wrote a LSM which learned what kind of socket
> options etc. are being used in a given workload and afterwards only
> allowed that. The code never escaped $workplace, but the idea might be
> a starting point.

It's beyond my skillset to comment whether or not that works well in
practice :)

> 
> All that aside, is someone with access to many tokens(tm) racing the
> bad guys vs splice bugs? Realistically one has to assume there are

I would assume it's hard to race the bad guys (the typical security problem).
You get a great zero-day as a blackhat and (AIUI) you might be looking at
tens-to-even-hundreds of thousands in rewards.

But, again, not really my field of expertise :v

> some more waiting (as suggested by the patch) and chances are decent
> nobody has to be caught with their pants down even without the
> aforementioned mitigation.

-- 
Pedro

