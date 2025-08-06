Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D88C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0DC6B00D0; Wed,  6 Aug 2025 06:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8336B00D1; Wed,  6 Aug 2025 06:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE906B00D2; Wed,  6 Aug 2025 06:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F15EF6B00D0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:35:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A653DC053F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:35:04 +0000 (UTC)
X-FDA: 83745974928.27.05319EE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B9A2C000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:35:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wa2wGgFn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="8fT/7Dyr";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yuUMPAUu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HLtTDCyS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754476502; a=rsa-sha256;
	cv=none;
	b=W2eT8xkfUvxBfXbdOO2eIuz6cRuNyw6MXhsUBgprr4TH1msEoXPA/7NgFDH5lUi8+zOgWk
	i84HKPVnok3Lnrd5IDRARXhxvzdl8fwJtD9NczDGxyc5ND2XZ4Jx+hQG6heSNQD+sWZJg4
	AaV2zfceRti8pnHkbBgXdgDS0VOSKwU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wa2wGgFn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="8fT/7Dyr";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yuUMPAUu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HLtTDCyS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754476502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7vXoJTyUOofn7iNpjbcuqYrzqeHk3HW6mJEtsTB0bk=;
	b=c1FH871IsG7RNfttfi15PLto7Hf4bm3V7WUju+MGc1A9bNSu2SlqZlAO++gTLhVviE1rXe
	4mInL8bST0fAYLP68FsY7IiixpQeSw9sKUKtNyRy4KlwJEZaLA0OvwvoidTx8UFLSNN/x0
	Du+/g9jlhtE5aeztMQT5nUx0xKL8CpU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE805211E0;
	Wed,  6 Aug 2025 10:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754476501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G7vXoJTyUOofn7iNpjbcuqYrzqeHk3HW6mJEtsTB0bk=;
	b=Wa2wGgFn9z5q6vRBMQ+z4njDof4QUAq9hyWYNrjDVNju7giFzzC/7iJARLyuXaTWqbFEkA
	Qs4xJ/WQwQWmvEXcRMwvXMaGi8Hhx3PyR0uTd4qBggYlZQ3spijR22Qeo+dixSpqMvbziq
	h/F/Y1VKmH/BpV8X5TasmuU0GYsIsZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754476501;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G7vXoJTyUOofn7iNpjbcuqYrzqeHk3HW6mJEtsTB0bk=;
	b=8fT/7DyrYwhJhV7ps1uut07EsEfi4JQKSX7fasxAUKkQdge78mFAvX5Ao3sgNu66iRuIAu
	9L2Ne4fM8CGizdDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754476499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G7vXoJTyUOofn7iNpjbcuqYrzqeHk3HW6mJEtsTB0bk=;
	b=yuUMPAUuGv4E3V/oiEfpLyQbbPOJw+zjzvqcp4Q6UleSxIQkYJf4JtBe91RB/Uhvia7xZ9
	kemVn5AYxRoF8PeCGFBEA/DR8HdOIHIeBYLZlNvaSfHCoRfgq85gf4meSj2/poYmYwYGXD
	uaSomXEeLmAEp2bXdBTks5P8lviW5I8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754476499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G7vXoJTyUOofn7iNpjbcuqYrzqeHk3HW6mJEtsTB0bk=;
	b=HLtTDCySyCi6YR8MCMBb/aW3/vozaivzhtlXuImiRB+4MFZlF/hDnqZvstxo8TV7ATlH2j
	vPHmxeiNOLLnDsDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8A0B13ABE;
	Wed,  6 Aug 2025 10:34:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ve+1LdIvk2gyNQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 06 Aug 2025 10:34:58 +0000
Date: Wed, 6 Aug 2025 11:34:57 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, wang lian <lianux.mm@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, David Hildenbrand <david@redhat.com>, 
	Wei Yang <richard.weiyang@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Jann Horn <jannh@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Mark Brown <broonie@kernel.org>, SeongJae Park <sj@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: fix FORCE_READ to read input value
 correctly.
Message-ID: <vahlhhwb3vh33c7nh67usxfraeotqq5pw5cwfak5ke3ysegv5l@bgtlqmv2wqyf>
References: <20250805175140.241656-1-ziy@nvidia.com>
 <7eaa1660-06d3-49b9-ba5e-28df1c35dcd1@lucifer.local>
 <6E5CCF4D-CB63-4E4C-BEDA-6FE533E0DFCD@nvidia.com>
 <dc139b0b-e461-4edb-ba1d-fc824f875142@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc139b0b-e461-4edb-ba1d-fc824f875142@lucifer.local>
X-Stat-Signature: 1n6aix7ns17idm78i5a4es6i7wqj43ay
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B9A2C000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1754476502-824271
X-HE-Meta: U2FsdGVkX1+V08QTnDQGq9HHQGDdE5h+DGY2nppTMC7hhODGsxEyGd+Y1PMv/JzYaPH0w7e0fxYVt+T6QPoap2htLmUOV/Dr4xMVs2xx7oFojRAH+4jQXFeweI0VCx+7Ukq5tGWyYjJcQR9HMqGU1FCd8+ahqTWHudF6HAYVruSwjkabe8vKuiD5FMHTzGtY0eZ44dR6E9uDUNunBW33riTtFmOsXJtpmb70bsiqCkMpQuoHO7I+fdrSdKaubs0JgyXwjOZMmkvgCBKDrnuCIdEqi15eA+Yn3Y3CRCwoSYXmkeqGaooQkDkUN1jnlvY4Fvm/gA75pr3EqtDDuXt2kggowckfDFqZwGMHh0tAnDWyHDppE4he1nSI0IpSxlrd/jXUVmVDvFOEp5cSPb23dMuyYAZiemKxH8Sl+ncjfxF2zMfic+X7XGonMXu44P2bo8XZo7w2FBgbHO6JHbb/Cglsec68aD9x1dTO+m24HexBQeTn95vm9pcnP8lKU3gmgoSqseSQ7vkKmL48ZGuqHR2fq5OJgg6vWMBioiuz81X/p5hmSa3k49Tx/yL4tscEf26O7zG0ojx/5JIsvAbDHw5tTpSnrCpjDVHS+aHrNRURImUvYzPiE3HknUQkv+dlCR/zyNVH9eKlprmZtf96EnBZdsof3TXOUevjwi6fyLJ1mlmQaw7UcUs8AlyTqltyeskKHifY+HHGXSJKh+xAM88yvn8wHbdYiUCaw991LAM+URzQsCcO3V8PViBXmnIgsOQf3BaU+X+ntDR2Avc3YhjK6u4W854KBd6Igsw2eIw+ZbxMmNfYk5ne5hrTfDr9IabnOTVuUYVVTMrB2dehJU31tBdpj5PXsYSJeZXRqZ/gZ4ykxrK8MqYZ7CvBsaw5+/DUgakqO3s5BeuYGH7XwUubaUonU7RwuMpDCN/k5HPHxmWTcBog/xuDICVF75a3C90fA6zgPoKhoWnYKfS
 hAJzFKHG
 d+2sNiRTkCCvmBkzx7a+r1mzftXC1ywOl+hmG15nFadMWKnmETJQ3bsuMvvas8J869akEdTutRuwRpO8QRr03+RYwVy6gVeZwmikvSWh4nff8m86QJGRQZgg610VniNW+Z6lvw8Qio6/4VJJIHJblM81t6e9NoC0d2FvfetV2BeM5HgxvhvzoXjYQuKWUSdgd2vTp8V9EG8HzsszMqOO8VvD13iwntCA8e1Idlbh4t4p5Wb/ITokvZHcKMXj9MHpaDpv12QWfJxeyuA7Sdtc26a18n7r/pKJxFK+9bkM4dhxSM9YQ+b6VkKcmssEphtBsqNvKJruyTbmJ5BRrqnHGuBaea9VkeHPJwZygH2zwt0R1ZHEIDlilra/PsBDUd5AIgtA/b1UZE1SSHFzdwTsXJycJ3xwGlbsg5xjA6lC03ppeX4q/8ucTdSFV3ZjzfciPZC2x7/CBtoZxtTGG/4yXDSjiJMqWbhBF0d81
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 08:21:23PM +0100, Lorenzo Stoakes wrote:
> +cc Pedro
> 
> On Tue, Aug 05, 2025 at 03:09:54PM -0400, Zi Yan wrote:
> > On 5 Aug 2025, at 15:00, Lorenzo Stoakes wrote:
> >
> > > On Tue, Aug 05, 2025 at 01:51:40PM -0400, Zi Yan wrote:
> > >> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> > >> index c20298ae98ea..b55d1809debc 100644
> > >> --- a/tools/testing/selftests/mm/vm_util.h
> > >> +++ b/tools/testing/selftests/mm/vm_util.h
> > >> @@ -23,7 +23,7 @@
> > >>   * anything with it in order to trigger a read page fault. We therefore must use
> > >>   * volatile to stop the compiler from optimising this away.
> > >>   */
> > >> -#define FORCE_READ(x) (*(volatile typeof(x) *)x)
> > >> +#define FORCE_READ(x) (*(const volatile typeof(x) *)&(x))
> > >
> > > NIT: but wonder if const is necessary, and also (as discussed off-list
> >
> > I just used READ_ONCE() code, but it is not necessary.
> 
> It's not end of the world though.
> 
> >
> > > again :) will this work with a (void) prefixed, just to a. make it clear
> > > we're reading but discarding and b. to avoid any possible compiler warning
> > > on this?
> >
> > Adding (void) makes no difference, at least from godbolt.
>

I disagree with adding (void), because volatile being properly propagated into
the type should hide any Wunused-value warnings (because volatile reads can have
side effects, so discarding a read is most definitely valid).

And as I was seeing in https://godbolt.org/z/jnWsET1vx yesterday, GCC (and clang)
can silently drop the volatile qualifier For Some Reason.

-- 
Pedro

