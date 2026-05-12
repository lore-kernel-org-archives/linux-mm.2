Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE74CD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EA16B008C; Tue, 12 May 2026 04:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFAC6B0092; Tue, 12 May 2026 04:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0602F6B0093; Tue, 12 May 2026 04:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE9536B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:37:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F7ECA03E9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:37:33 +0000 (UTC)
X-FDA: 84758113986.22.76F0439
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 64C5E180006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:37:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XDcpM7HE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9nMywJlr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XDcpM7HE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9nMywJlr;
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778575051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7Q6p7r7/PTCrwEUB3BqNV/hhNykM2WI5rGmdNMnE/M=;
	b=RCc+Z4+npHUd28DA9nK7jNoUm9YiCZu15HaxFTzUiIGL4aNi1BbF4vWl5Y4TI7jcG0/Hds
	sp6JlsDptw/ktjgSib/b0/2pafu2C1AWYRejPvYMxIqGf1YOU2ABExTV+z3Ozw3hxuE26Z
	/5DgBVSGLH6T/VMcKWHAxbE/bn+wzkw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XDcpM7HE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9nMywJlr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XDcpM7HE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9nMywJlr;
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778575051; a=rsa-sha256;
	cv=none;
	b=hVGp759Q2phmGQoR95P9ZAfdyr3iCDb2ndmpFI81xKM4teyNekpNhaqdXrJAHsEdlni7yU
	2fMg9IIJGMrZgX7JE0DEfFSpITcWFhcNto01KWtJV9940AJVzRspYsu81H0ouHsrdCTNFe
	z2cFxUqAKxNujLPq79GkHmF9zdsE4mo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1907A6BF57;
	Tue, 12 May 2026 08:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7Q6p7r7/PTCrwEUB3BqNV/hhNykM2WI5rGmdNMnE/M=;
	b=XDcpM7HE5T4YXQ8cU48rhnlq0031pTSR7lGt01xe7saIgyqP7q5NwgRWiPHf3ly+ynh0Cp
	EZoWgGFSUcyC91HlWChdyHpptKV6LkzEWJ/PLw65aRJuw6ydfzUw6Kmo7ugyC8/Dic1iRy
	Sg1qkIy8Or5cXMgS62vHomBmwb6OCqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7Q6p7r7/PTCrwEUB3BqNV/hhNykM2WI5rGmdNMnE/M=;
	b=9nMywJlr4PLXO8Wk+lLz+Kzebosqxs5kPLFv9AgywrldbKhOX8RyZbBI7VnrvIEdsRJ8xd
	Mcv8zGLYQKT+HDAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7Q6p7r7/PTCrwEUB3BqNV/hhNykM2WI5rGmdNMnE/M=;
	b=XDcpM7HE5T4YXQ8cU48rhnlq0031pTSR7lGt01xe7saIgyqP7q5NwgRWiPHf3ly+ynh0Cp
	EZoWgGFSUcyC91HlWChdyHpptKV6LkzEWJ/PLw65aRJuw6ydfzUw6Kmo7ugyC8/Dic1iRy
	Sg1qkIy8Or5cXMgS62vHomBmwb6OCqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7Q6p7r7/PTCrwEUB3BqNV/hhNykM2WI5rGmdNMnE/M=;
	b=9nMywJlr4PLXO8Wk+lLz+Kzebosqxs5kPLFv9AgywrldbKhOX8RyZbBI7VnrvIEdsRJ8xd
	Mcv8zGLYQKT+HDAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4920593A9;
	Tue, 12 May 2026 08:37:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0rFANcjmAmrjBAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:37:28 +0000
Date: Tue, 12 May 2026 10:37:19 +0200
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 6/8] mm/bootmem_info: stop marking mem_section_usage as
 MIX_SECTION_INFO
Message-ID: <agLmv6kAorUNC37g@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 64C5E180006
X-Rspam-User: 
X-Stat-Signature: fx9pyzb19mqunmrcpr1km5o7zcpdb1it
X-HE-Tag: 1778575051-383414
X-HE-Meta: U2FsdGVkX1/BUfUjCh/b94X9NOHyRy9KiWgnIPoRh+OBNGNdKq76yrKbjZ9iHTwgCssxFKA0Irf/HC/pJWBA9aFixZjvCCnaKF/n9Kx/0TE0YSUEp1ORLVecqL/crjnS12cCeApp7bRFNA+ITt9bjga5LPz6TVrBdYiXHJmDUhHu9GVj2RYnA0/LbTM3ytteTQZjjGPDwJG4yNrWYvWM5ouLH99FzwNZFTt073eJan231gKanrIXA+eczw+Hq4UX/5Lznf5RBEc1PIk47eCjb/WKInrzJyVB8bF75IzZd8RYPceldbAzgLDXxKMXH6x0+3m63U9VRjD/kCmSPYIwMoxiV18MbVLE2rqaaKfBLgv+4vS5bwwvXftdirhF7ouPz6QYMo81f2Sy0CEncu7NgwUl6d8b0OnPDqm8UbxC9sqHm+xCUkcHsf8fUM4WPNtlYhBYw0PKqHL50LA+LRbSwkKtTccZt9jRHPj260pM3L52oUNXZMT/ZxRQ2FPGVjt95/n7AdRToNKy+zwJL+CmeQtnwMUD4XWsFYoVVEtnfb2ByrANGpFYq+mO05Y3UlGts6OST+xmwfvAyAlrxPGfaFDhsiYfW0ji11Z8oSINnCTNBvqd1at81AcjjWiSwGLhjHykv0JsTgv95EqKBj4qcqgxvW2Ig+oD0zIQD2Db+oHIkJMon4x7HwF8thzdx9iBxAWUnDn1ewz3mJvA3drjUK2zRNbdxgOjmECXCQ0hA69f4W6lJB93cOtj/FR/gz0AJq8MgrEfRk0WAlkEi2qaft6jTVKG32A6S2wvC/b6i7mKe2mO3PkKM145+g3z0yBoA8El3rx+O/0O7WZNU/fAW05OQAkOrmhbOmFE2vNQwhd6YcKUNRzfFW37o1OzHMaNC1Di93U1z/sDpyiPZzgWu90fnOD/hOsyRvU/6oXtECypdQ6cWjw9lU0JEc3mLNeiPGaGZKui7r6P9/xT1Nj
 RNX8WTPE
 P1JM8TYPy8b4fYYHiBz3JOmvOm6yeyqaYEDiV4F4RJ1XUG5Z7BHelcsRkDlexrjqpbR3K+KvZPPChFJF+TLcLUgKpjvZNxVtwOkSI0l4+ry+jiOG/WNAfWgtgpfL8wm3HeToIAC8xV8nlBNenjGDVG6iAh8FVeYTts92iwBX+E+DGEXVqq/OFZNPM4L4W4V0ERb6h/c6hLbxMAJmdM0cBGSae3XKTKw/UDzV0xSjuoz82tEL5t/SwxVCdrK7vfJca67P9ERYfofzhs3GMVo1E0264i+e2ampSR8h0rQasMvOgndwKIXfSFmRn94yNwUg7KeKnP/eTQ2nl+FI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:34PM +0200, David Hildenbrand (Arm) wrote:
> We never free the ms->usage data for boot memory sections (see
> section_deactivate()). And to identify whether ms->usage was allocated
> from memblock, we simply identify it by looking at PG_reserved.
> 
> Consequently, there is no need to mark ms->usage as MIX_SECTION_INFO.
> Let's just stop doing that.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

