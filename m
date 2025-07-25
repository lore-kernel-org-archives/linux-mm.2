Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4433C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F766B007B; Fri, 25 Jul 2025 15:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477486B0089; Fri, 25 Jul 2025 15:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392316B008A; Fri, 25 Jul 2025 15:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1786B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:32:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D59D3113CEC
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:32:45 +0000 (UTC)
X-FDA: 83703784290.18.7ADFE22
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9EE9720002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:32:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tbYE3nSx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ypVB8EjO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tbYE3nSx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ypVB8EjO;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753471963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kF1KhrizHk8cMYmAS/UV7ZSg8lZF5MTa6MQ61yemQmU=;
	b=H0fAWeFBwNkx1abyF3d90Jdk6TvTZOpxcd0aC3C0xt8Pu0yZVHPgbUYYI3Ks1s099T+kYf
	+IbtSeqniDBUqEfSU5J5nTwQR2C0rMQeyuPqp9GCxKsA8PVr8eQdbcNXw/k1gToLMZae4R
	yj/7ts8vVE8TP+O87et2j3xKgRLkl0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753471963; a=rsa-sha256;
	cv=none;
	b=P3W0wjyGZWx1UV5KUM+9PF+S35Ahlqf7+cRjhO/T6Dpjb8EWiWe7Njqn74QJCkWa+tadWN
	0sJ/g+Bt3PHd50biWCmiGnFGNpgMJ6m5VuPV4j59u/2u/jYtAnLnNdLZI8HpUfjpaKTm3b
	7gmHifim0WB2neRzcxqVjQXMz62T/YA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tbYE3nSx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ypVB8EjO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tbYE3nSx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ypVB8EjO;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C46B1F387;
	Fri, 25 Jul 2025 19:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753471962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kF1KhrizHk8cMYmAS/UV7ZSg8lZF5MTa6MQ61yemQmU=;
	b=tbYE3nSxKmQALecEW7NbGT3lWMUCn8tUX6YvE4JmFZDZ9aZN8V8bT7ps52h2guZqVOQdqp
	X6xqTY1xP3UXqq5rpDjwWCYbz7bAcEvF88Zf3KP4bDIpLhkVgYY1Lk5OTuaPcGgJJzyIoB
	fi9tqxuL5Lz4+8SX5VyRLa6qW8fTgMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753471962;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kF1KhrizHk8cMYmAS/UV7ZSg8lZF5MTa6MQ61yemQmU=;
	b=ypVB8EjOsj8rZTptp/A0jJntVhnTUJerguaNCzT6YA5lAttNGkmZ8xsM/CM+zzLd8ro9XZ
	jnNfWmP45jIdNWCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753471962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kF1KhrizHk8cMYmAS/UV7ZSg8lZF5MTa6MQ61yemQmU=;
	b=tbYE3nSxKmQALecEW7NbGT3lWMUCn8tUX6YvE4JmFZDZ9aZN8V8bT7ps52h2guZqVOQdqp
	X6xqTY1xP3UXqq5rpDjwWCYbz7bAcEvF88Zf3KP4bDIpLhkVgYY1Lk5OTuaPcGgJJzyIoB
	fi9tqxuL5Lz4+8SX5VyRLa6qW8fTgMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753471962;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kF1KhrizHk8cMYmAS/UV7ZSg8lZF5MTa6MQ61yemQmU=;
	b=ypVB8EjOsj8rZTptp/A0jJntVhnTUJerguaNCzT6YA5lAttNGkmZ8xsM/CM+zzLd8ro9XZ
	jnNfWmP45jIdNWCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59166134E8;
	Fri, 25 Jul 2025 19:32:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NXx4Etnbg2g3KwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 25 Jul 2025 19:32:41 +0000
Date: Fri, 25 Jul 2025 20:32:40 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
Message-ID: <bsyihkvtwxqofkccmfr2g3e7efhob7hzwcgup7jlaryvg7uqtc@qgtcv2i4amdo>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVeHWt+SKWWodXUNhXZi1Wv9YazEOGWEUJLvgPbopqBrA@mail.gmail.com>
 <ca6af6bc-1c5b-47fc-a00b-11d46867b5e7@lucifer.local>
 <CABi2SkVRmuRp459g0RBwyTbd5dACwe6AiHrpxYuPXj41MxHp+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABi2SkVRmuRp459g0RBwyTbd5dACwe6AiHrpxYuPXj41MxHp+A@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9EE9720002
X-Stat-Signature: 6q5wuqdsnauxkgjsdeuu51wxj71nmy41
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753471963-133257
X-HE-Meta: U2FsdGVkX1/ZSoNF/406YUVpB0lq0X4PGeZYFf2A3KDt3lqCQiqrM6lvXLG86YgoM85JE4eEu2nc+/djK8MNjr+JSW7RP00ztOvqhbf9siKbtcsVgtvQfVxJ53McbYuIz5aGZayxMx/olynUu/rE+kFa7fAof0bol5QqKPX6UGJx3OSKICgKpjmLderq+wXrYh10Xmi0d9MH6nXq/70F1GSnVT3K+pvWcpG2TuYHZQ3NI6lCnKrc+R8tpvhMXYTUdo2XYBvJ+0jKiHH3MTJcbYY1TurTaHOoDQlgULKUC/wpjCObakHGur6kObXbwtL5Ls3AJXD9mgDwaJt2Jz2/NjYf3HjbaBZO2A8zpiZA6FWnodgydrN0f1jftqo6EKFKQoQw/3r+KaONce0Qkq2RBIXR1gY0u5G1TaI+m3zrMxIa70JKVkavnkISMA8wh7l38+/1RIukdfq/iQCsRF0/NN3LxRH3bDiYTix7wHf4W83P8kreLE4zd7R6GasrSGINTsw2G8EuMC5ddNW4bp+rYELrjRhfNgmYMvhBtt47WwVdiXDeHRjqwPV5pVh44Bk/r4Md80+MJC+4jFswGyEpoaepzU2qV/XA53LVq8xECAXk5+3nvygU2NwbJfJ2nZGIvdROJ+4oBVZSvYxOPHC/YPTePbEnsSGzT51pRynMcrYkpxu+ErgEKeabSDcRljxYdD6JEzdzUpotQFmS3QGO8OQozBY1P9QxvvicYkhRUS8qyO7k0VYVtmaDOylDHpnF82ODeQN1DUAQdVD4QZmO/PFpvBihZZbA6cymJt5cqYv+Ej2jqWBQ0Tqsx3updVO870HzmGdyXfC7cQHYKwpH8TB6uWWxxYegkOkE3e2Xw9rAWgO79S/x4Xn8quPWx8TMoE1/8gx2sNU9fO5Din44HwtMiIUrjL8IlU/EXRi+0Jg5m/LqUX55A/KN+MkI4lMkqy0RBL6wf6XD4nGQ/N8
 rZWNjyMh
 3r8fd/JQf29baxJwHUPQwlArAwHLDAVp3R8OFZ8qtyQs3TnPJl9N9fTKHWV8sE0ojdkmbrel0atGRcnUSxvaF7mF3a8GjB6VbDfASrEU646eoR912AvYLOl5lR1WRYx6dJc4SlnT/2b28aEdwYCbCCAg1vkFvcWTaziXUbyotHYkgzD0PrnAcaWm8vdTu+Nn/JoCCk1RafTHPEUbgN6SmJy2n1TYoQERwCZiNcQcynedvrbECKQMShPWFlgOslEoAVO0jhCAAHvggo0HF1/4EVHpsZSZxxoSxYsv3wgH6P3ZkOYEXhMSCvdx6UTsAXWXqqSYqEHEB+VfrHXPsXnTGkoolrQaw7N29POul
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 11:09:13AM -0700, Jeff Xu wrote:
> Hi Lorenzo
> 
> On Fri, Jul 25, 2025 at 10:43 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Fri, Jul 25, 2025 at 10:30:08AM -0700, Jeff Xu wrote:
> > > Hi Lorenzo,
> > >
> > > On Fri, Jul 25, 2025 at 1:30 AM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > >
> > > > The check_mm_seal() function is doing something general - checking whether
> > > > a range contains only VMAs (or rather that it does NOT contain any
> > > > unmapped regions).
> > > >
> > > > So rename this function to range_contains_unmapped().
> > > >
> > > Thanks for keeping the comments.
> >
> > You're welcome.
> >
> > >
> > > In the prior version of this patch, I requested that we keep the
> > > check_mm_seal()  and its comments. And this version keeps the comments
> > > but removes the check_mm_seal() name.
> >
> > I didn't catch that being your request.
> >
> > >
> > > As I said, check_mm_seal() with its comments is a contract for
> > > entry-check for mseal().  My understanding is that you are going to
> > > move range_contains_unmapped() to vma.c. When that happens, mseal()
> > > will lose this entry-check contract.
> >
> > This is just bizarre.
> >
> > Code doesn't stop working if you put it in another function.
> >
> > And you're now reviewing me for stuff I haven't done? :P
> >
> > >
> > > Contact is a great way to hide implementation details. Could you
> > > please keep check_mm_seal() in mseal.c and create
> > > range_contains_unmapped() in vma.c. Then you can refactor as needed.
> >
> > Wait what?
> >
> > OK maybe now I see what you mean, you want a function that just wraps
> > range_contains_unmapped() with a comment explaining the 'contract'.
> >
> Yes. You can view it that way from an implementation point of view.
> 
> Contract mainly serves as a way to help design and abstract the code.
>

What code? This is an extremely simple file. We don't need deep design
and abstractions here.

> > range_contains_unmapped() enforces your required contract and the comments
> > make it extremely explicit, so this is not a reasonable request, sorry.
> 
> Technically, this contract belongs to mseal, but if you have strong
> opinions on this, that's fine, as long as range_contains_unmapped()
> doesn't accidentally remove those comments in the future, which I'm
> sure you won't.
> 

As far as I'm concerned, mseal() has little to no contract - we still don't have
a solid definition of what mseal() is supposed to do, things are still fluctuating,
and there's no man page (and no one is going to look into random kernel comments
for this).

FTR: I entirely plan on axing this function in the near future (or will try to).
There's no valid reason for this to exist, and it's causing extra burden on the
implementation - besides serving as a poor example for future mmap-ish syscalls.

-- 
Pedro

