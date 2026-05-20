Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1449BCD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 19:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2344E6B0005; Wed, 20 May 2026 15:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5076B0088; Wed, 20 May 2026 15:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4356B008A; Wed, 20 May 2026 15:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFB8E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:45:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9462E120465
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:45:31 +0000 (UTC)
X-FDA: 84788827662.25.879F617
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FA36C0007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:45:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FAmaUNo6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4RDn2vVl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FAmaUNo6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4RDn2vVl;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779306329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dK9b9MnEkgC3RRfbTuM5GBU2UYy5wFM7Gu9SZMz91vk=;
	b=juip5n4VHhaiFgAXIMDXsi+HgQNQWx/JQ8BEdttcmbK75ZXG680qxEEoVbmwaGhha/FLWa
	ZjTcCHa6jMId7/3wB3N292aKLRHhItn0a/7enTsoWMeZlkY2V0CYgBUxsh5DTZitHAfZuL
	yqG0k8BZA8ijtevshAL00uW6xk6kxgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779306329; a=rsa-sha256;
	cv=none;
	b=D3Q1YLoD9LiaMtAjfy8W45LP4bL4zhk9IEiQKWDTCfhRNkUGW0gmp/6YSUjnhJaxXCf+1x
	tmmIseyG5Ka4RIa06l4qeNUIkGDf6sIBGFCiFf16G1MPG9eme2TKrtz7QX3C2mhgKqbA2y
	hJXnJDa90k50LiMpQiHy9ZrlA/Al20g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FAmaUNo6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4RDn2vVl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FAmaUNo6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4RDn2vVl;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9D9866D8A;
	Wed, 20 May 2026 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779306327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dK9b9MnEkgC3RRfbTuM5GBU2UYy5wFM7Gu9SZMz91vk=;
	b=FAmaUNo6KDVwbDdWx7ORtrgC9tAauw6F3weMBzzP23icVfW+vBiqGH+BAWGbuyHAoRB/vX
	PPTakybI9lW5kH/ZGrsi/UDR31l7NovWTFKkhAt+forTbqTI0g0QhidBGtjyLeVijxvFk4
	UFKsga4UWwcVVZc4TfOHZ9eHxcV4RO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779306327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dK9b9MnEkgC3RRfbTuM5GBU2UYy5wFM7Gu9SZMz91vk=;
	b=4RDn2vVlG5m6T4m5TUgp98iBoN2HZzjVNbKkG6zILTF7elvOOwBEyRNmezqc8R1uiyLWGj
	8RuZxJda6lR+W1Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779306327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dK9b9MnEkgC3RRfbTuM5GBU2UYy5wFM7Gu9SZMz91vk=;
	b=FAmaUNo6KDVwbDdWx7ORtrgC9tAauw6F3weMBzzP23icVfW+vBiqGH+BAWGbuyHAoRB/vX
	PPTakybI9lW5kH/ZGrsi/UDR31l7NovWTFKkhAt+forTbqTI0g0QhidBGtjyLeVijxvFk4
	UFKsga4UWwcVVZc4TfOHZ9eHxcV4RO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779306327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dK9b9MnEkgC3RRfbTuM5GBU2UYy5wFM7Gu9SZMz91vk=;
	b=4RDn2vVlG5m6T4m5TUgp98iBoN2HZzjVNbKkG6zILTF7elvOOwBEyRNmezqc8R1uiyLWGj
	8RuZxJda6lR+W1Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90DB7593AA;
	Wed, 20 May 2026 19:45:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dZjnIlcPDmodJwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 20 May 2026 19:45:27 +0000
Date: Wed, 20 May 2026 21:45:22 +0200
From: Pedro Falcato <pfalcato@suse.de>
To: Daniel Palmer <daniel@thingy.jp>
Cc: Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/nommu: Implement just enough vmap that compressed
 erofs can be mounted
Message-ID: <ag4OcGs7SkJAYsby@pedro-suse>
References: <20260520163442.1099667-1-daniel@thingy.jp>
 <ag3ozpy8ehNr8vUP@lucifer>
 <CAFr9PXnAMAAwnPkY=KJjSmpE5w+daoTo+zKkOFwaGq7yZTq0=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFr9PXnAMAAwnPkY=KJjSmpE5w+daoTo+zKkOFwaGq7yZTq0=g@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FA36C0007
X-Stat-Signature: 89rdo68yekusjz5ncyh8i8ixbm4yjrck
X-Rspamd-Server: rspam06
X-HE-Tag: 1779306329-873332
X-HE-Meta: U2FsdGVkX183ExMlewb5jXRLTRNdhRqrt+lv8MbICDx439iaMXeOcZWgMfQNuOecrwLKbRIqWsE6hh8+7ZPoTAbsKDDq1LlxZKUVsk1tV0n2zM3QwErbxwUYGdVD7nUGgE/Hhl+ZrKoTCJJeaJ2wDncsfnNP8lkACrah66Ma5BZMOi17e1UV/2deRl61uaxg/rKkQcvNZebfwdVq8C8wAWYHZtcGodALEGKU7Jv7xipRrEbhsJT0rpj9iRQCCV4hg777jfw/OXiIZNlyG99U9txDrZ1aSsvXqWq5V6loUYd5GfZUsykatR2OGOip9l8PiqowU3so4ypiwgytWmW3lr4Kn+DBOixK3n45E192LAO0qKnJmJ+BXE5WU9gfiDklo4NQtF8wVwgxmhF2o7cwUKeX74sK/PQqwsErweXznZrhVZOgqA0NtIAPhjwfv/I5J5BqeyabaAJ6RW0GoqtdMB59tXSY+2JfoUhTp+/1A1EVwtHgTaVGMSK/dgHo3adSBoist8+2lYGAB1aXWG/qvkPnELS0a8aRUBhi3EZTrFRLuJt8vVlGnNsX6ZPsjiUq+eJjAZl+SyvJSPhbkXBhx5bmJpFjqgyhpiuI2oXPC7mYxRAbQDa3etqxaOwUPgIWVMckxzz95R6sekX63ZZib20hnsITGHJgA/XwjAWIJmtQ05TuhAxbyNKQmuzrMN5LA386+T2vRrP8N/PK2wFt6OhrUYudYC4Tw/Kmaii5GEYVjdoW3nPiuFDGd0F4O9hUXmeys42J/MPMeBlaBe12/kGTQiMjNszjAdVIll6EupIy6XYoDmOUhzIMBSI5ZeN6lfzxsvq0lIiFRbD1C1ysfXG7xUAN5xzsF9Pmad8nx7PcknClX6gCF0QIoXjiu5lN9zh1at8+KvyNjMJwks7jL95LSDae7SPfnmbmbUCv69EfCTqdhln/ryvwwpJrbVMZKFHEZPat4VNeAhMhnAP
 s2Oe09q8
 beogLKSmlWst5PLBFlfKV++j4/7dkUKfEebUGPlMhoQpAWLa6gsjrURDAXKLF9N8Lt12fpC7UUYMbau932ugLvChWNqdcguxkF5wN25HSPPimgP+pcryA98Z94ejEE2ion3Mz9XK60zWfHXruZrJtWt5yyf+cZrYtTC/YJq61HdvsTP+NfsOpnVl9Flv3+i3GWpAr90rQHuc4tSt4ayUeustf9e7Ole1uyTjlxann9qecuRA69Z0zKD1DbFQBLOTE5leVR+umisQOWB9gnbUZjeNcrFBvBFuO+DH454suW1WnMohFhhBAzWHMVJaxO2UofLwL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 02:22:25AM +0900, Daniel Palmer wrote:
> Hi Lorenzo, (and Pedro),
> 
> On Thu, 21 May 2026 at 02:05, Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > For some reason this iddn't arrive in my inbox properly... strange? Maybe
> > missing To:?
> 
> Sorry, I CC'd everyone hoping I wouldn't get grilled for the silly patch.
> 
> > > Did I miss anything massive that is going to come back and bite me?
> > > Maybe it would have made more sense just to change the erofs
> > > code so on !CONFIG_MMU it doesn't use vmap?
> >
> > I think that'd probably be better honestly. I think faking out vmalloc is more
> > trouble than it's worth, and it'd probably have to be everything-or-nothing.
> 
> That makes sense.
> Do you think it'd be acceptable to maybe return NULL from these
> functions instead of crashing the kernel?

I suspect the reason for this is simple: calling these functions in !mmu
configs is a programming mistake, and we want it to blow up loudly instead
of having slightly/very broken behavior.

Maybe in 2026 we'd have picked WARN_ON() + return NULL. But I don't think
it makes too much sense here, honestly.

> 
> > But yeah would gently point you towards doing something on the fs end I think
> > here :)
> 
> Noted. I think I'll at least send them a patch to make compression
> support depend on CONFIG_MMU.

Awesome! (note: since you're space restricted you may actually want that
compression :p)

-- 
Pedro

