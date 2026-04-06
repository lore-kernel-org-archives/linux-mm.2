Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1467AEF4EC4
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 08:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B456B0088; Mon,  6 Apr 2026 04:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2331A6B0089; Mon,  6 Apr 2026 04:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122286B008A; Mon,  6 Apr 2026 04:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 067B46B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 04:29:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5133E03C5
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:29:45 +0000 (UTC)
X-FDA: 84627457530.06.8F72E70
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6C1E714000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:29:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WD0HTpYG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EmZOkFvV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zw+aL3x2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Lcjrtsff;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775464183; a=rsa-sha256;
	cv=none;
	b=DLKw3FWn5Cy7GNVH7EO2g0JtHwyofbfIyJazOcnxzRIX4WmRFhI1UqhgYjty8qkz+4WZX0
	aOUI5pIbR9NrFqYwrV/MaLM2ZGDv9oHts0Z4NFzvYXmU5Jvq/tcTDr3adQZP4BbYB00JH2
	rb7Tm0aUoz1T/278ZWw6kz3FIkdB5w8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WD0HTpYG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EmZOkFvV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zw+aL3x2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Lcjrtsff;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775464183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5U5F001QquqLRy0TkEuVWz/fK0dQaCWrwRN7alLbgs=;
	b=ButOAjdnXsJl3AU3yd6D7YH116/FXEUIxjmQpQKfaLb241OXvrI2mI1zgOHrTIWk+mMEd+
	4rY0yTu+l5nSL1A92ILFgaANyYKAGtygm1Z5WsjzxWtYQ2J4A6ENoqKlDfVytJk5qT3Cpf
	h4hU847EfiMt134bxMSdmbprXQTIxBI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE4774DDE0;
	Mon,  6 Apr 2026 08:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775464182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L5U5F001QquqLRy0TkEuVWz/fK0dQaCWrwRN7alLbgs=;
	b=WD0HTpYGlq0Hh8HZeyq0JqhYi7iZN5H7XG/uZKUhFpYzF9c0b/wxUU0UXi8z+p4700u7kv
	OgXfPxs1TtP60MlurP0oG/j+hb+qLmDiLAfVt280UG+L1KW4ABg0fE9T6ozYJQjNdlonJa
	AnT3sAerkTKVb0qDtsJhLO1pBnvlaaY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775464182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L5U5F001QquqLRy0TkEuVWz/fK0dQaCWrwRN7alLbgs=;
	b=EmZOkFvVDy2ic6xjW6fQE/Nlc3NemD39hLDJuYFn0YAZdfjE23a/yxRqEDL/F5TjbCXdqx
	sfCwUq6JlfTS4dCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775464181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L5U5F001QquqLRy0TkEuVWz/fK0dQaCWrwRN7alLbgs=;
	b=zw+aL3x2bVWTRFUwfBXURIJ5rxW70zrwbKSQuXtc0xiTiXm9if+9RbY4Ll5WxHqTaRRdlD
	C9AcSWpP6BGxCZ6Vwrxf8rt3gnZCyM28M1tJqNzHXAemqlDPaYBZpvLk4a/J2PZOUznJb/
	NpUA2XKkz/pHZuafmAcEujoA1qEk3lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775464181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L5U5F001QquqLRy0TkEuVWz/fK0dQaCWrwRN7alLbgs=;
	b=LcjrtsffYtqiNr+ZC51/R2XgcKbD9X8y31SISfulsKBvNtZr8SU7d/kD8dyKK5sB3VsO7C
	z1YYEIdKDzqKslCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F25D94A0B0;
	Mon,  6 Apr 2026 08:29:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vF+qN/Ru02lhGwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 06 Apr 2026 08:29:40 +0000
Date: Mon, 6 Apr 2026 09:29:39 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/mprotect: micro-optimization work
Message-ID: <6bl5bzq742c522nmhlshlnf6ho6y6a747l3zh63aagp7kfxymv@s2c6fsuikn4m>
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402113328.fd0a6f0e28cf74a651fa2291@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402113328.fd0a6f0e28cf74a651fa2291@linux-foundation.org>
X-Rspamd-Action: no action
X-Stat-Signature: 5cz98fn1eiicujpgqdwk8bpdz4o57es9
X-Rspamd-Queue-Id: 6C1E714000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775464183-383479
X-HE-Meta: U2FsdGVkX1+4Bj0btDghZPPo5iDO6f1vjJKVsRgEt3Vp+uoBUstkgBOdaPvk+66p3QJEd6ixVXaNX2+g+/GoxFM4GzmxVMQd9qJxP+MLB1BVEpDvDITIFjck9U96l9tEVhfIVP2ciSOyBRdQe4JVufWoPH9fOmnONWxX1XPjG56e0aWhlzN5L3XmAMS4wPqsB4TCR7efOfkDHupWxF+d2JRJX+pfdNXCIAMRVJlD8S2uXrwtcG6N6JzY5PVulNUOuXJvmI6m1n/wl3C2LOLov3Y7wiGTvRkDE0czFWNuuxUn500NdAyY6qGZ/5DqCPy/JdUzPLi+XHJlXmFwNjYMC8PVp9cz761DIoqm7Wfap2cc1AFvxXdWMGS9E0zjQ8aOe0h9K6NK2Lj87wi6J5dU0YaJFfm/W9TtcvF60Sr8BCJ5hRcuRoFM1yN4HxEojN14FkjNkmUZMe1wGImam8WTWIQn9iRoB5eqk/MYcmbyfbhmSV0TtqxBT0SeaZUsefYz7nhBmsz8QTGpCypxqRGjBmu9puqLstYdwHIfiz8Bqq36TWIFWZ9JsPWOknpE8N6tom3KvLLm5QTZo+sfcjduR9Jaa4fsnZmy1PoSmB66XlAKtiRq3MkTndz095yAd9XvwVMma4JcOekIZjp+i8tdj4Le82a0RPfVcCf94UOAqFYTtNNkuCw5Z3+awe27TDK+LSS04Se4DQoaXsGnDNjirwWlouo/YWDHBhiQgZC90qpupzCEQtxLFytoDLaOoc+mpAWz6GPBRJNXSRQghySKUxLia1DvjS/trKeN574T5dAuRO46SHV4TZqMmoZCVfEK5U5xKqibStJBp4psY7nvEwGKXIPZM8oAtu53Za06ZaBz4mwyyUuSz0919AtYskN/6rHKy4jpfPnlIBLFYDsx8GW4Nalut295jw9W5UW7/+NFtMn7wkv5OaHlUZel3eSTsXNeJymp+JrFJNSf4bI
 qzTWBVB8
 3QmuurkX2rDcSdpgVON53cpaR70Ss+h+oT89eoWovEDXQQ+kVpN3l0FEzJvEQzDXZlN3LBxi8CJQ+RV6N5/LSAoP9lnvuuEqNDN61gWQY9BtE6lqqZcp9SO739kL8PvfSQ1dErAFNwtMMiW+dTfVIaU5JVpvsHms2a8VyR+v1RydqMWXxfcZl6OO/6zSeLqvbeHb5+CG2msnRTxE/WzuO7q+iEf0UyEUGbD6lNF5hE/SrHl4PG1ZFcINGIWIbG6caU2MbbqvpJBKfPSvc+si8BOHxHOWCYBYMUQkdjCTWOVBjsdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 11:33:28AM -0700, Andrew Morton wrote:
> On Thu,  2 Apr 2026 15:16:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> 
> > Micro-optimize the change_protection functionality and the
> > change_pte_range() routine. This set of functions works in an incredibly
> > tight loop, and even small inefficiencies are incredibly evident when spun
> > hundreds, thousands or hundreds of thousands of times.
> 
> Thanks, I updated mm.git's mm-unstable branch to this version.
> 
> The update is rather large.  If people think it best to spill this work
> into next -rc1 then please advise.

I think it's a fairly safe change for 7.1, but I'm biased :) Perhaps others think
otherwise.

-- 
Pedro

