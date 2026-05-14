Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31E7CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E7D6B008A; Thu, 14 May 2026 04:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5F96B008C; Thu, 14 May 2026 04:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3DD86B0092; Thu, 14 May 2026 04:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E88C96B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:12:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91A5A160640
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:12:27 +0000 (UTC)
X-FDA: 84765308334.18.6FC5F5E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5763E1C000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:12:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BYfnfFYh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s4j43AXD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BYfnfFYh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s4j43AXD;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746345; a=rsa-sha256;
	cv=none;
	b=FCrLCLoM28M1vPm46yKIJRI72y28JdQCJWxgSV0Rr5BDpzFw1TQYyFc6hY7P8rKLzWr/zf
	Sa8HRO3NPYPROQDTVw/S5U3w0Qjc6imcliNOdqdiarHFB8aFPuzYFygBrqPetKtqjwqJ8M
	juNa0MCcKYvmHpTSRh9+6NqpT2ibLyQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BYfnfFYh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s4j43AXD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BYfnfFYh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s4j43AXD;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETngYR2j68Acn31dR1IX4qVn4fOT6tuFxnVWZdzLlIM=;
	b=BRDXpFAJIdv+MlitD7PDD1/sIJ7K7Mkgecx4hx1awGkk0SYadZz3+0+CUt6Bp9DHIG77d+
	X9LoFlHspgPJ2kpDhKzO7BnpNXX8uq6d16mw1/iKnRbAL46thMq3rvWXtdoGi3P9LBF/fj
	jvjTMcBtjv1Dm5zI2oUK5HcCkt/NOsY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AAA2666E05;
	Thu, 14 May 2026 08:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778746343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ETngYR2j68Acn31dR1IX4qVn4fOT6tuFxnVWZdzLlIM=;
	b=BYfnfFYh2W/bA11kp0OY5ZlLkNcowTz0mbGaG4zNJAimsSL0TMCy46ohzg+0ZiCqNI9hSA
	SedYdrkijjifG5IQfb5P7Vanw1dgZSuazlsHSvqUn0+lfvSQZdi0vTDjlQxqNKf442glVA
	JYFATDOpFQD519fJzCL9qT5SVwFx6cI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778746343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ETngYR2j68Acn31dR1IX4qVn4fOT6tuFxnVWZdzLlIM=;
	b=s4j43AXDYJKsTr2rpuJn/O977uq3cjI07syszbtRPp9siNJtl1cdSG6nu5U9mtpqJHzhE+
	JsaJekvrtUWW4dDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778746343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ETngYR2j68Acn31dR1IX4qVn4fOT6tuFxnVWZdzLlIM=;
	b=BYfnfFYh2W/bA11kp0OY5ZlLkNcowTz0mbGaG4zNJAimsSL0TMCy46ohzg+0ZiCqNI9hSA
	SedYdrkijjifG5IQfb5P7Vanw1dgZSuazlsHSvqUn0+lfvSQZdi0vTDjlQxqNKf442glVA
	JYFATDOpFQD519fJzCL9qT5SVwFx6cI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778746343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ETngYR2j68Acn31dR1IX4qVn4fOT6tuFxnVWZdzLlIM=;
	b=s4j43AXDYJKsTr2rpuJn/O977uq3cjI07syszbtRPp9siNJtl1cdSG6nu5U9mtpqJHzhE+
	JsaJekvrtUWW4dDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A467C593A9;
	Thu, 14 May 2026 08:12:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1HGVJeaDBWrRGQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 08:12:22 +0000
Date: Thu, 14 May 2026 10:12:21 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/69] mm/mm_init: Simplify deferred_free_pages()
 migratetype init
Message-ID: <agWD5ZYu0In6vaHN@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-6-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-6-songmuchun@bytedance.com>
X-Rspamd-Action: no action
X-Stat-Signature: m1k6zjo1xx8jp7idwsayczapth195rkq
X-Rspam-User: 
X-Rspamd-Queue-Id: 5763E1C000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778746345-32011
X-HE-Meta: U2FsdGVkX18DQi1lVMRfycqGlYQURSiGtOs7dMkyxwJUkW4k3h5LlEA86saxMpqbZsYnyG6YpPA4hGKk67DMk2zCJ9sbwX2EZ1w4dGI7SKPe+fOPAZd735ob7JoSRI8HEDYa54A+KNXT1DtN5ZMHfKGpSgyrXk3a+BBdEzQwCrRcNbHhbVSFkbYpz0t7POmNfLiVX+5dvEnJm3106ge2qc6fzES+7gQ6OlTG8L9DJxfvp6GSUXk24MdFgUHi1CTmkWgvp+GNpcs69aAj16TJ3IY8iHXlBdwmaM1TN/H+HvZTqFP2l5iQSG3o7BLFbFjVKYK2BClNPygHPouBgRjsaim3HZ7P5ouag9DWEEp+eHCjFsxeWIrpQH9P5BWpxuT9JZYVzuwi62RTunPb5hRew1J25LX+uTAB7rFpv3D/xJ2VHFu4hOYUemSaUKWkfaJqxs4+wsZNktO3LowkEChN5cRX4tB10IvXTnLouK6Ir4r4xVVkj4qX84Q2DdgiXAqY90a2q0v0IqukPSOd3G4B34DibbdWv0L6YTXiyywbTPqqq73gGQCGv7uiESfNTWcAlCSoXsDXLEfLl+4cO3VepgLxDsgew3xu6d4+Gfz1otzjUKZB6tFjfOZsU+65Ab+jjgcBbUcqi8KKWk+D+EB8x2K95ZSC2W6w1rmZBGkjTqwR47hVUPe5/SCaRKsTQCLZRJcwKXU/TGpZjop/AhP4bXY3mOHg6iM4eJGfX0JtH9/g87ddm3IdPcNvygf0/gZkkrwQ4sPnXFluew6cmkm0AxGESuNB5YhT+k4TW+b75Ag9iyy6WVvQLTkBhGr+3BQJSFVUYxwTueegV6kif2q3xN9ThX18AXuZTJb33R5yQf6ZXBjLcLD0Yp8IT3tPZFfYRU4b7gQNCCnmLn4gv+H3UDaDLRt+mR7YtmYwI1S0FEbfuFSChROcC/Zt8p/PaPLWO1OW6FJhtSGEWIRRFyg
 vheWuOWp
 AxaFFU+6ix5WqpkW5WKlbErL/BfcLByYMCdSTbWHsNT8/Qhzo7MHJLwFEkBur7FbRp0FhfmCyAIwP5nSqgzyxNmZQ3W9UnuO6kCkLMaGeDGIBHKg7XSmY3Xenu3at0JHOdM/s4WhcB8Cf59e1FGi0jV9OePtCRBEJtMBddJbJ3RL5zFZRryAAzDtohgjXIsooxYSPp8VXoLdThanuFqb0CuqkPE0MOTLFYKuT0O3uQPRRE0UnZtW6Juk1RRbImwVls78+w0gkMLbAnYDPYz6lFBPpt0vxgQlk8WZ8jZetns2B7OEKZ+wmU6r9cq2KWFsOJxScypkTESjHW/Z6a1Y55h1v4NB5eJfpc7FqHvIFtMikFjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:33PM +0800, Muchun Song wrote:
> deferred_free_pages() open-codes two loops to initialize the pageblock
> migratetype for a range of pages.
> 
> Replace them with pageblock_migratetype_init_range() to remove the
> duplication and make the code clearer (Note that deferred_free_pages()
> may be called from atomic context).
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

