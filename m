Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CC0606A329
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gXfA/Dfp;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ihTRBDUo;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=z8DqKq/+;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HgutpAPI
Received: by kanga.kvack.org (Postfix)
	id 2A3B66B05B0; Wed, 28 Oct 2026 08:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2548F6B05B6; Wed, 28 Oct 2026 08:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143756B05B7; Wed, 28 Oct 2026 08:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E46646B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:18:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BD29A8AED
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:18:52 +0000 (UTC)
X-FDA: 85371938904.23.835C21B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CE58140008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:18:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="gXfA/Dfp";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ihTRBDUo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="z8DqKq/+";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HgutpAPI;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793189930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OskEvaxrgfNfL/Gq5v8g3VeZhJ7zUOHQB1CES574JS0=;
	b=uFjB5f1oUhvjdJ7FOAB+RpsuaklZGQkIb7ppT5QPzTwr25m4aYfWdPJd6TEk+oNa7laGcz
	tz+mVehZv7TDsgi113DmTRwLiruPwLswKTJlIgC5QZlqBDi3VRSAhs7JAJtadMswjdyMmL
	3qKcX02LTX83U9oQ6OOzutujZlwpf3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793189930;
	b=trpTsu8pCEKogACh4MueblsHb4aRSho6YaDFwjIxBo7i+Jayd0w+SfwvpZR/znqRdh3EDy
	TOFe2hWYY/1ZuEOmNPGJbRxHC0vIywf/HhTkDIvX7Sm9oq3mR8eyM31CiKAAbAB2EmbFBK
	koZ4P8Kcb7Anegicb7ZhjDgv83BWVqs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="gXfA/Dfp";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ihTRBDUo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="z8DqKq/+";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HgutpAPI;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB2AB2212C;
	Wed, 28 Oct 2026 12:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793189927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OskEvaxrgfNfL/Gq5v8g3VeZhJ7zUOHQB1CES574JS0=;
	b=gXfA/DfpF6w+jyZaWtiR86xpjyK4cUM01VKUq3ddfeV01r2x5BlhIoEm39ldSPFMxwckRQ
	/Fy4Ng+MwGEDmhprV1iwEcx53S2e1sfnTLx8rptIWu4ZkVfpJ/dOaVgJHrCrKQZaHAExFC
	lesktXcN/bRaF6rQoWKMbvwZakHJ8DE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793189927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OskEvaxrgfNfL/Gq5v8g3VeZhJ7zUOHQB1CES574JS0=;
	b=ihTRBDUoHkkC1CO9Vi7stz2y/cMF7dsbcqqppFqULwrhtZd80WfubWLOKDDczOMOfPN7UP
	tMqLffewEcxRxUAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793189926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OskEvaxrgfNfL/Gq5v8g3VeZhJ7zUOHQB1CES574JS0=;
	b=z8DqKq/+TGAIJwmTF4U0sQ7FfYKJ77L7dKL/trqLyzIl/Sgl9Ekctzsh1xn4HTwg+/cd4o
	R0xm4n8RpjQrRepUKjnrNa/qi2quvDzjKwWyo8+erMWnL1P2DO5b4tyYhdhl+EHyi1fk2X
	55OxWOhPLgi8dZ8SLybC4j9oDNf4bMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793189926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OskEvaxrgfNfL/Gq5v8g3VeZhJ7zUOHQB1CES574JS0=;
	b=HgutpAPIGu/bYSfZI0OSy/iDcOHIXFbgI+oIOVqCmUwY1MYJLVJuYZ33vVQG/DQK6vAmu9
	ASr5yKE/0sTjYkBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 399C71321C;
	Wed, 28 Oct 2026 12:18:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3uAeNSTo4WqLbwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 12:18:45 +0000
Date: Wed, 28 Oct 2026 12:18:43 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Andrey Vagin <avagin@gmail.com>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot
 parameter
Message-ID: <auHkLMb_Xo-7Z7mx@pedro-suse.tail5790ac.ts.net>
References: <cover.1793094611.git.chris@chrisdown.name>
 <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CE58140008
X-Stat-Signature: g6raoycebsfd1xmm79xzb3j4h3eduogy
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793189930-29609
X-HE-Meta: U2FsdGVkX1/SWI1PhACCsS+eM9AWc0oSYVfS1OKkgHFVkqRb62NdekKLsRfWxS3xRkdsdtXkaqB4pGGJ5uAiQKsmcAHLEaXEkP9XkfkJup1noB8HoKQH2GFKJfRlZqssXlbDA75Gk/jgZhME+0aySi/a3albFBJu9718+wIPEKCayvhxUoDtO/9ApXV/8iS94l9ep0Ll54xVXxgLvUldT2d0IW02P5YFcAjn8CMGA5FTxxlPpuJ19rrQR7ojjJ7Of+7FUFYHzegu74cd2o8R80gQyw9hwxhB3e4wZY2vLzEo6kLf/B1QIcCpvro+4wQJ2ZJlBWqRD7AMVOEtcL16IR16dBikuPGbz5k41BQSJQXbpO9AvGBlUU7Yow98FuPRDc9Lg5r3BQP6iRBsMxpzGaLnxxg50EloqpWQ6OIcJuMkDByXYaAZT5/Njr5KIkN/Lz3x0Y1BcKXUlQBDLOn7UnaUGyWudDaIkITnBblXiskf+jzT5LOBdANkJ6Sbp8EbdGkfORYXDKJoIF1NVEWSY+vv05p6IlW2v2wTHhwQxlK14NBSZuh8LN3gYp6knADSkdMMyMofx3Ljgx1nS26p8qr/mrDWFyx79lHNQM9waqk/BHjtR4yM3tSp67xd3fdocA1+8Lvsx9VQGXEckcIYPbTgboHUDtd7AuwgJn5eiDTbKBGV+9ZV0qEaJIIMaIAteOaPW4zdsPwnpTLwdZHSbA9um6WpqhloyTbjjSRqs/hFmra+dPX8zJ6u9qDNgnwiarLdeyKaT0NwsD67E4XaH2NNK8Cfr+UzhNilDNkI5k72hbeU+B6r5dHFcXJOo745dgy3RQgGrumGNRq8ws5pDuNE+4s/pYovqe7uxnktCMIb4yrW4AhZ+JGy/H/YKUOyZozxrQZRDJVi5MynfQoMSSwkPIsqTFX19TA4l+zwArKnKXajUzI3rV8NtPiAUotvVR7ChbK3P7RFXP6hJ1O
 0qv7HgxA
 dyjNgQ3vvFLojMdk4IdUshSOH1/W+Ulq+JdH2EF8bRWdmYoB9wdctQSFeCT2jLs4ytwFKKi0jq74ihNE0tAX13DsPhqzSdJe38f/+a2fAMgOECY5/Ske7UnGxVcIUhv9NjgCGlDmNdCnstKz8n/8hQgMdxVsyY2z31kr7KSNhxLNa2gcR2+62WyjO7//M+F+ut3u3bLqDaA3eUpg+3pu7D9EaqqJMj8DEfxEfxdByr4QnX2AU4TZ9h+4jjWD+p3QbjmiDhCmqKwafjVaMsC7yFbQEqOQJ4oBfguHk6Z6/fBNGlhV5omnbFG50yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 07:43:04PM +0800, Chris Down wrote:
> CONFIG_MSEAL_SYSTEM_MAPPINGS seals each process' system mappings when
> they are created. As it is today this can only be toggled at build time,
> so hosts that need sealing and hosts running software which moves or
> unmaps these mappings end up with separate kernels. This is not ideal
> since it adds more complexity of deployment, it would be great to be
> able to have one kernel which can configurably do both.
> 
> So, to improve this, let's add mseal_system_mappings= so that this can
> be chosen at boot.

I'm very curious, do you actually have a usecase for this?

-- 
Pedro

