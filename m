Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA9CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632F06B00F5; Tue, 30 Jun 2026 10:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602826B00F8; Tue, 30 Jun 2026 10:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3AC6B00F9; Tue, 30 Jun 2026 10:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15AB06B00F5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:40:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D0A5C2444
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:40:16 +0000 (UTC)
X-FDA: 84936839232.04.158FB19
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 60D84C0011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:40:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0k0FXMnR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="m/+HI1/7";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GWNUlwry;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ik9xhJZm;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782830414;
	b=A3VvSl4UruJ7Mu7QkjL8QGz9GzrDp7yAVPMLo/tDgznyDfpuMbxOrELYC4f1oQvx/D+LJB
	UYkWmOK5DgTC7MaJbB0gOHX4Z2yHqh5YrjiphFfNFMN9Vw02B2A5rbhmMc2J+AOccThIo2
	EuTVKOBT3RVaqnceBmnx8DKBX+qMQtA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782830414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnFr60XaYcmQD9ST85I7XAqhA4M5wK5bIo4FXi9x5zk=;
	b=qa6peabWvEy4rJOZhrPLi+Y4BgaUmbN+CtcLecB5TmqqjR6oarIS9MGESw2FkMEc3lTNfl
	ThM8OiGAwJKG12hveJKmrRihGT5u/UYBZwexdO6ypFMvE3Wfonm2ftBluWJ2S0NU8uLOPN
	Qprq97yYrOBzSphJtx4uZ7YZPZF+WSY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0k0FXMnR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="m/+HI1/7";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GWNUlwry;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ik9xhJZm;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D85CE710AC;
	Tue, 30 Jun 2026 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782830413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnFr60XaYcmQD9ST85I7XAqhA4M5wK5bIo4FXi9x5zk=;
	b=0k0FXMnRZuZQKPf8AlzFtsH1LCXRXdhx/OEktTiFuW1O+D7tP115J0RNzL7lOcRkP0RVzd
	Th+sca2po7IYFsHggCLVTDoJX2PDfgb2LKCOtNyCi7ZZkzK0zLGmzNkVoAcV59LvbOMCgp
	Dx+gO5T2zGr/fZ1hliA9T60qUxFGlQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782830413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnFr60XaYcmQD9ST85I7XAqhA4M5wK5bIo4FXi9x5zk=;
	b=m/+HI1/7GMGCNdrhmmTlPQ1hDyyj6yxI/B0skh4iW+rUiFKZt+w+sD7DJ5NWT8cAkbWBps
	KI1Yso3Ab0s4jMDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782830412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnFr60XaYcmQD9ST85I7XAqhA4M5wK5bIo4FXi9x5zk=;
	b=GWNUlwryy/hcdx2rbHUHS/5UkdYtUkVc6/+ZKTlpL06/73FknUEdl2d5TbOufRvFbg5n7E
	ZwAh1mrRsokFVN0hlAarcdCrK1T649DaG7zUUTcTQNwl/P6EjQy/dSZJlf0vBNUEkR1LJM
	nJDFBvclmEIrp+j5RTJ9mk65GWGwTo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782830412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnFr60XaYcmQD9ST85I7XAqhA4M5wK5bIo4FXi9x5zk=;
	b=ik9xhJZmxShdFkFpjOeBjcBFyhpTrF39dswSYhtIu+pp8Gw/LsDhvS2GUNI8ds2uMqbrgf
	JztpxbaXoOFHGZDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 793BF779A8;
	Tue, 30 Jun 2026 14:40:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T4qXGUvVQ2o6DAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 14:40:11 +0000
Date: Tue, 30 Jun 2026 15:40:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Xiang Mei <xmei5@asu.edu>
Cc: Dave Hansen <dave.hansen@intel.com>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, linux-hardening@vger.kernel.org, 
	Uladzislau Rezki <urezki@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <akPT82jDvPwlaNuo@pedro-suse.lan>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60D84C0011
X-Rspam-User: 
X-Stat-Signature: 3doy63tjr5cugqhdff71quwfj81f8yoh
X-HE-Tag: 1782830414-139145
X-HE-Meta: U2FsdGVkX1/IFTngadCujeSDIMbpL8Zt9sVK/IIT+cwzlQ7+bRzqvd5I3uxOZOseht1lvlnymarRmH3ynEUAM0l5sKILG9mJh+iTk9OloZ0KRJP8JqPQp39o98swNO+aAWeCcxsQ8En1uz0/5p3hpmLEfGIfqPlclaSBnQ6JSoschMc4DUJb9jY7ku0Rcp972d3MW05j3ZAeuW5J+WCYAcfqDSa3pDaFyyJnfeBeuoTNCusGj3xgiSOB9GqawUhNGWuqvEaVbdt72ClJNnKHJDbGREON9HV64nkZcRn+ZrpQ/Oni1z9W7ihuvZ28CLsHOMhNnPy56nlt8GKCLRDbSf7zPAJFgMkxuWWPUAx3Vw/p8aFFwIjWdiMv+DufyI9SH1HqIjz4BoJ6g80R9IX2g/Q9NyCNDANcQRAGs9sZJEosORjLGjHuwgveG2iWVpqCcLVZe9lxlMKRb+ZKBkCXfxWlnPS2uN/RLg69xJNdEiGvU+xEfs1PP7aDc/Xr0Z5nORuQkrkVhsAuES4nRaC3bMu0hf346MkuEpkO/cFFcTDG/5Jhl3pSN+RC2wLh6lbhi1fQjKXMpRuFCpEtOrbso9LdWvqnYs9bl2CTRl9GTeQKy7M8fOYw2g7hf8svQT6D8hXyhZ8DMkw+bu/sDCzkwgcNI8Y1PIvI0N2ZAQxPXdsgG4zlTJnfpIMo4SeLYGnqjxU5vu5E10OkZJ2X5GFukGyuJ1sdRtpiMx4D+TKae8d5EcfIGB2b88AUFj8BOZ8Env2FdmfRP709mvSF0B8A6rNxcGhi0YLG5muRDX1rT+ninIWalO308orFJSv1Qeu8CU0WzvYsDMj3UoMwC0d0NlzwuLy8sdBDkCogvez3kf1vl5rnEuVVswG//2W8AAs8cIMPVDIAsXfoShbWS/6jC9b0R4WtnZFwV14GbFkkaKGWO0MYlm1ZklngFLRmcYxkDLpnhL1vIxeE+I+YpV7
 +3yUrZrX
 zCnfhdNoHlw093qYG5O3KtQIjl1+FB/uO5teoY9WejsMiRL7U0e0UyQs/mJ1NP6CkNPqgaOgwCaKcATcxwPYkvPdhvUwwbwfW2d8WPWX0AmftQ/DnNkoYL+lxLZ5SdC+8e3NRSSTFOfgHRz4l+D6+xxnxtBd7OwGUValy0zti0NrOfiEwhNK5uV/AkSZZsxLzTlzHzUrkIkIe1zcZ0Zk1weolMZpmq/iEDiGJiI7Q6RINFaXdzQhoy34L37JFAGddW5OIjBE07DsjY1KB1slU186qTQonQZAylo3tzcSPI2EToS0F4cfaw0yX6CgJDfRg5B+m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just as a quick FYI, it's good LKML ettiquette to keep people who engaged with
the previous threads on CC for new versions :)

On Mon, Jun 29, 2026 at 04:28:19PM -0700, Xiang Mei wrote:
> On Mon, Jun 29, 2026 at 3:29 PM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 6/29/26 14:47, Xiang Mei wrote:
> > > With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc area,
> > > which an unprivileged user can surround with attacker-controlled data by
> > > spraying vmap allocations adjacent to a target stack (for example via
> > > XDP_UMEM_REG, though other vmalloc spray paths work too). Today each
> > > guarded vmalloc allocation is followed by a single unmapped guard page.
...snip...
> > To even be considered, this series needs to be refactored properly.
> > Making this VMAP_GUARD_PAGES a separate patch is the bare minimum.
> >
> Good suggestion, I will do it in v3:
> 
>     1/3 - introduce VMAP_GUARD_PAGES
>     2/3 - mark percpu vmap areas VM_NO_GUARD

I would suggest you create a VMAP_STACK flag and condition these guard regions
bsaed on that. Otherwise it's a bit arbitrary as to what callers get 0x11 guard
pages, and which don't.

(you can find the concrete stack allocation functions in kernel/fork.c)

-- 
Pedro

