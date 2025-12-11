Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7227D41C12
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 09:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A596B0005; Thu, 11 Dec 2025 04:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB996B0007; Thu, 11 Dec 2025 04:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9706B0008; Thu, 11 Dec 2025 04:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7924A6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:23:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22621BB5C9
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:23:22 +0000 (UTC)
X-FDA: 84206651844.23.9D279BE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id B40BC10000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:23:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iSF3iqZZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Cvddhdp0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iSF3iqZZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Cvddhdp0;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765445000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXntFMz/1BItVG7BvsstcortUO7vx/YgUgUDL2qXBqE=;
	b=cqjk22XXz5nhBjyE2SJJAhFEM2+CSiAFEaIF3wFPDyCgVV+Ed02U4C2vOL+eRNTxxV+YLX
	p+qSbQPQGsXZmHDLCPdjISq64JzmljeCGh/DQbnj86fThnu7d1UWdwF5C0olOG+HWqq14M
	jUWXXrUY+LmttWqKQ0zlpcxk6VdzIqU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iSF3iqZZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Cvddhdp0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iSF3iqZZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Cvddhdp0;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765445000; a=rsa-sha256;
	cv=none;
	b=zly4KZ91HJIRJHOEOkZWZAZnxRbmRr0k7bkOtbUybhrYh6Q/GBIbS2LuGKwm6KiM0945I9
	b5/n0wl37woNoqH1RZuH97ZzJLvGCkL9mr2yJYa8OWKrirWeAvus2Dxg3+/JmNG/qolS6O
	i8KI0Wk7QkWvZ3L3nQTnqv29dC96Fx0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A9B42337FC;
	Thu, 11 Dec 2025 09:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765444997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xXntFMz/1BItVG7BvsstcortUO7vx/YgUgUDL2qXBqE=;
	b=iSF3iqZZaJrUzVh/nhj6PdwJEthnAQy0QYc1mpHJiPiyiaBizi36yLvF7cXtFalxhQTrGR
	PMwYI1ak2JMSe6oOE+koNDCfB0TBf85IQR4BgUrcbZIVTUuzsdQBSwhBaoQ9kAyEbPpR37
	AFC4jwR3HYiL3BG19FRM4isEFf/C2po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765444997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xXntFMz/1BItVG7BvsstcortUO7vx/YgUgUDL2qXBqE=;
	b=Cvddhdp0Fjq2RHksq6zh9kRmwA0xd166utjHnw/+xQaSp8yYOft/CkEU5SteuF4KKYOpxx
	hHOD9FZ/73CzawAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765444997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xXntFMz/1BItVG7BvsstcortUO7vx/YgUgUDL2qXBqE=;
	b=iSF3iqZZaJrUzVh/nhj6PdwJEthnAQy0QYc1mpHJiPiyiaBizi36yLvF7cXtFalxhQTrGR
	PMwYI1ak2JMSe6oOE+koNDCfB0TBf85IQR4BgUrcbZIVTUuzsdQBSwhBaoQ9kAyEbPpR37
	AFC4jwR3HYiL3BG19FRM4isEFf/C2po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765444997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xXntFMz/1BItVG7BvsstcortUO7vx/YgUgUDL2qXBqE=;
	b=Cvddhdp0Fjq2RHksq6zh9kRmwA0xd166utjHnw/+xQaSp8yYOft/CkEU5SteuF4KKYOpxx
	hHOD9FZ/73CzawAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DD9F3EA63;
	Thu, 11 Dec 2025 09:23:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PC6FJoWNOmkodgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Dec 2025 09:23:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4F54CA0A04; Thu, 11 Dec 2025 10:23:13 +0100 (CET)
Date: Thu, 11 Dec 2025 10:23:13 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Deepakkumar Karn <dkarn@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pagemap: Add alert to mapping_set_release_always() for
 mapping with no release_folio
Message-ID: <5edukhcwwr6foo67isfum3az6ds6tcmgrifgthwtivho6ffjmw@qrxmadbaib3l>
References: <20251210200104.262523-1-dkarn@redhat.com>
 <aTnn68vLGxFxO8kv@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTnn68vLGxFxO8kv@casper.infradead.org>
X-Stat-Signature: bgmc89hkd1md7oyqx8i4pftmiiusrmkh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B40BC10000D
X-HE-Tag: 1765444999-755120
X-HE-Meta: U2FsdGVkX18Hf3v1uI8AJzSSjof6Q3/vxN7gyhbnK4b0bCRAz/bAPwmGkunn9s6K20I44BnVCNSxeQZnw7/YsL3k7LFNWI5XzPfoSpQ10P/afjJokZL4hdXZ87DIaRVK+ctUoE5kEW/xPZ6fy8FfSNyfOMQ9/tEXukWEwkbinGqqX0yMDHsMwR3S7lv+ctY+D7aw6EkMcC0qm9bPm9ZzMNF5GTYzjXGWyz0N2F6iiZnMtVbXQJwKkkymL6TFFj29MufIMvNWNsphRMIvAkxlt0+XxsH3EBxhEJy2Rp6bfmQ91ZHod1C7FpzkQ2QVW7surlB5oJT59N9hVkH/OIELbdOJXdU/pG9fSdyUwoshJYhZhMUQ4CZSbFzSWI7UvSiPY5Gn8y3iwkpvCrv5Xp5Zyq3B9gTvlTj2xQnBKhq/uH8VKoXpFSQrWqnNpdYgkz3NEyLxviLxK6B78K3cYH39cGg268qgZkAAK0sdUBA0bxkQoT+Ev8OqPCAGu23SBv1o2n/c7ksjfn6xADtG47ihXlOG7rAlylV1Rr+iY+eulxVZWTNBb5M6lO/hOLFglMDS+tFtd2u5UNIlE4uhhHXxNTIRwDtcYegb7Sfb6glR1x+qCmJmQps+nYVRizXIWP3TfOTkXGRmDz+Murnu4vfy+G6xn/ctyoXueo1cA8PHb1NBWp5/JTdPQk1fmrcekDujwWh6DMGwawxeG2s2nNkxt+W4sVBpgIv4mp6TwXJ0YczIiI3iBQ90WO0BitAGJ1fO264qi3E5NaVGADbkXpf8aAe1mL+cPQsPiIYe37qmLO0V5nxstlX+CUHT3BwqHX6LigMpQRf1ZXenQ7WlcYnOCHFhNtZ7bibK3UY/8It8auVQM0JgpX6ZepAyrJlAthZyAEd6Mi0sTpGaMkj64VjFl5vHC+GCa0uj0NtGPFLH8B6NqsAQDN9FEntTLRekryvuE8cjpaRtGvRpaTZEZj4
 de3SuhDG
 /Uzf6Swjs6hT5Z8dQ7z5z3624JUYzn2m0dBG+Lqzi4Cd+xpCQHh+R8RsQFo4yoV2u8v1KR/RYSt72O7M10gjupCdV+6M6Let/fd5jEbArRN6KMzoxYpldurLiKliHqBdkT8v/wT4K54EkCHLY6dZskLcD0aszoxP6zt1srdKQCB7ONL+UobWRWy116pYkwijwKCB3JDqkYAPpdkIk4Y1MLsr0jbjY+xlBwsT9Ps9szJtKNLlSyUOgCrna2lxpcwbqT8DLwdEC3S7m3GYt2dhEm+QQcwDr/LX6mt75XTR3596wWzzaW62UNSCiPdASzThcKgI0gzMKZJlkJJnX7/nSbCx/oeBWrgvCovL2rCJehLrwBDzlCLM/3oLstX2AzKXq/UP405u4k7Q9nY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-12-25 21:36:43, Matthew Wilcox wrote:
> On Thu, Dec 11, 2025 at 01:31:04AM +0530, Deepakkumar Karn wrote:
> >  static inline void mapping_set_release_always(struct address_space *mapping)
> >  {
> > +	/* Alert while setting the flag with no release_folio callback */
> 
> The comment is superfluous.

Agreed.

> > +	VM_WARN_ONCE(!mapping->a_ops->release_folio,
> > +		     "Setting AS_RELEASE_ALWAYS with no release_folio");
> 
> But you haven't said why we need to do this.  Surely the NULL pointer
> splat is enough to tell you that you did something stupid?

Well, but this will tell it much earlier and it will directly point to the
place were you've done the mistake (instead of having to figure out why
drop_buffers() is crashing on you). So I think this assert makes sense to
ease debugging and as kind of self-reminding documentation :).

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

