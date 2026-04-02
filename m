Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B943D3942F
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1836B0088; Thu,  2 Apr 2026 10:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092496B0089; Thu,  2 Apr 2026 10:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2E86B008A; Thu,  2 Apr 2026 10:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9D376B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:21:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C633140374
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:21:32 +0000 (UTC)
X-FDA: 84613828824.27.05DFF3F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 437B7C000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:21:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ge9d5A4e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xSpU8Fxh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pi4tKhfb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NmZU3PwP;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775139690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+t/GVakiUh0UbLhg8erN+xKESs+nE/tJ7PVCDMkhkgQ=;
	b=OtBojuOWDDW3ex4VU2b+/8QLJmgRGKw/tj1Ktskwfdc2gERZS5i2fMlDmBHrbNaQvwQvBe
	uSudMmTBh2T+IvCigvJbTbe42tiuxY6rQl7xdzPvFwzYsRIPW/iptC9PzusEDwFzBPsABN
	lGrIQA9Fe7HwU8tM7xgHVbnSOQ52SzQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ge9d5A4e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xSpU8Fxh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pi4tKhfb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NmZU3PwP;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775139690; a=rsa-sha256;
	cv=none;
	b=37+1KxMyhHD6Hl4XoNvc03Noxak7HKEjIQY3UZx3fuVgC+zz2cHFmr5n001uS5shmVXIty
	knbuKiaqTt7p5pjcTCKsKlNt9PhcLjGzyemFCmdrOx34LVFR+3gR8g8FHEJBluc9+9H02W
	AoJMC+zsxI1CKiGcB+UDUq3B621byk0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D12904D343;
	Thu,  2 Apr 2026 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775139689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+t/GVakiUh0UbLhg8erN+xKESs+nE/tJ7PVCDMkhkgQ=;
	b=Ge9d5A4eQTEwslaVwgQj1m7vH51wQqm9zI0DrBXnaWKCVpqHAS4kdfc92Ak1XtiwRDeONu
	crJN5z9izuORNNaX7LihJN5NspAcRDheg1Hf7rixvKnCvSV+EhZXPm2E6SQCT+WYyZjWmi
	J/INjhd4HqcWAquud1224dviHlVDpUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775139689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+t/GVakiUh0UbLhg8erN+xKESs+nE/tJ7PVCDMkhkgQ=;
	b=xSpU8FxhBt52/bPIuzYUZmhAbQmPN6jcfzyI8P52KYUJ80o90TjM2HrbYkgF3cgI6rJNjj
	TQQQeuETSB0dudCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775139688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+t/GVakiUh0UbLhg8erN+xKESs+nE/tJ7PVCDMkhkgQ=;
	b=Pi4tKhfbA04sc3MZx5yJfJJWIRV11fkxb3jI4GZDUI5bKM2Y19yldTsg/okGYKXSY4I8fk
	aCXWxP2pDW8g2HJ+U/GfUAJ+8P17bp+0LzUaShMHXTGKk6O7SXIHDxYSJBPRtRZaz66F61
	gLlIZYYrIGji2uDIrrwDYGNP4y6zReo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775139688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+t/GVakiUh0UbLhg8erN+xKESs+nE/tJ7PVCDMkhkgQ=;
	b=NmZU3PwPDQLrcGmMsmJ80BTphM/nGyLJNrfHxcFUeWXXiTgBW+EEXX7Zef1/ubGEkX+a4Z
	dt/U6Z4PkAGAgJAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 162F34A0B0;
	Thu,  2 Apr 2026 14:21:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XmIjAmh7zmlVEQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Apr 2026 14:21:28 +0000
Date: Thu, 2 Apr 2026 15:21:26 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, 
	jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-ID: <3rmcbafb3pwq6endpfpgh3kzygolhvpal2xwg5sgq4pw3toikf@t3jx5uorfzxs>
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402141628.3367596-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402141628.3367596-3-pfalcato@suse.de>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 437B7C000F
X-Stat-Signature: n1yuyfed41x1esyktgaqf8xr7zam1tut
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775139690-75447
X-HE-Meta: U2FsdGVkX1/vpd3a4knkE4w+MKORzVcaAChwetMHfLtLK+hEQYI6FJwQbUMxSmSoT7qqOOt7W1ju0/iGZnVcGGHaEmsBI38lBF8Qvl6oZOYNFSSrObZvVn/cMMGJFNeRW88ulLz61kyfDbu5DRsz1byxU6KKIfeTWAqg8gH0q6o359V5VTYodUqcD9K1Kl0ubBRAcu2U0OV5aC+n3/oIYXskYBuoO+DQltefWC5MBnFF96dV41/9NBnsfQBW14/M1Fj2mG+jjfeaGG5G06bLyKP68GrIqsDBcxevmaAsP1u4Z+EOsSm0eKefFacL7jDNQmsc5tZICCO+KaI7S0W7TIIz4LLfxXgBpOtxSjmxfU3k/o8/2YfomupxQc7fhN+ao0eBCEJv/nu5/Ih8SrYUgtul6ZCVA/I4z1Nazlgw+BjNjEcTqNsYfJ63QNTav3clScgTiVr+gD6CmK/C2HtpG1WHnX4+WbchT8448twz0BoP/WePX6a6Ctd8QUvMdptGbOG77LZKdUGVeZnSjFhNhsDXss8iIBYsGo9froLWawlfd+os0usFJWrR5rYLfgCkB8bHdpWlIU5yi4X9Zft3EPS/JHyBEq2QNI2O4wBadXkSDa4VcNxu4tomqoWEb27EhIPyr3/Baa7Y2e89KvLIjKXR3WGrYSRnEqjAaGPwGBJC2HkrnXh/22uUtd5LtekSarIeDql7WPC4TPMBZ6u02wzCXiTDD98dw1ujntHyLMtGbmQ8uk2RrwHKA2TcBCLjzXKJGgMrgFz3IeqeY4+bCxVptN2QdF7LRffawwOq0/McrTk7M4der6A/1JrhTNdDTWg+oY4MFrrhYz1bubHxo73N6ktDFsZDSv75W4LTOOFelVLqEkEtzpT5oOK/4ArE+DKddn8vHQ2zLgPHG9xXS5gPoC+MZJtN3cQmf/XhVqc0HNr0wFk/txq31utk5bA4NSfQ2b0GVxOUVCfruYO
 ebKMBtnl
 GdLfStk2QSeawjzjVNd09840l2X/jgV93J9ZJtJSgOiUKLS2mtEViACPCxdi3ftvzqPA6LTeE5UXqALwRN9qlclRD0nwjBZgRRKcL4dK7SU/uIiYPrAduUNKEOSBOrEbsnNSY4GyKEVV4mltuSgvfONsQ8eoVJI60yx7GNzoNBVvJ6EX2cHWSd2g+q2HFK5oLG+krb0z0mGJExCAafbcm7k9+j+Ms+SqRnCTBbcH3wpNI0+ONCsEKokBad7DT3uzLnkC3PHq/9itDk961BlnTyvpqEu0Dd+noHRN5hCef5/H7+3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ugh, of course right after sending I notice a small problem.
Andrew, can you patch up the commit title to something like:
"mm/mprotect: special-case small folios when applying permissions"
(or protections, whatever sounds best)

After David's suggestions, this doesn't apply to write permissions
exclusively. The rest of the commit message still applies, I think.

-- 
Pedro

