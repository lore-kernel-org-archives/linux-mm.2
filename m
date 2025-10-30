Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B4ECCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE0E280012; Thu, 30 Oct 2025 12:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEF9280003; Thu, 30 Oct 2025 12:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C478280012; Thu, 30 Oct 2025 12:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3C7280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:26:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2293913965B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:26:06 +0000 (UTC)
X-FDA: 84055307532.16.2CE0382
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C35540006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:26:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wr67yKJ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D+oqUsGa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wr67yKJ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D+oqUsGa;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761841564; a=rsa-sha256;
	cv=none;
	b=eDehhW6nyFCxIJaP8PlfbdpbJTSewlDZv8Em5yISPfmJmWePk92R7WoYlGoAjtP5Y5g4Ej
	fccNOnlIemc0eVEpVwMMR9VEni92uNBjT+nFHOZVxJAEqcbmAhzaoGxvhF/OfuUHOW2u+S
	vUUjXOgkEKHL41JT4vm/5zO0duDGP6I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wr67yKJ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D+oqUsGa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wr67yKJ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D+oqUsGa;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761841564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y45ny24R7zem9vCEHKWr8/ZHpLbSWhPSrqSC/spGVIw=;
	b=2Gy9aLdX6YchxmFq4vpwIxiZa6EYPF9dHTdaIpQQB5wIvgLWNdA7Ftq1jq8OiTbybzI8qb
	Mkk+/AvUkWmMfSFqgTNwv+OE8sjCFDgts0zICSj3Zz3A5F0hnkuGH1vicbtnYB+XmB51ka
	Bm1iVzeIww7HAskPCxgXANFbt9skftY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6B776337A4;
	Thu, 30 Oct 2025 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761841562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y45ny24R7zem9vCEHKWr8/ZHpLbSWhPSrqSC/spGVIw=;
	b=Wr67yKJ4CtPObOAKIVbuQJ9uY1Mk/MgeJUi4m6VsB6BWlU0F0w3slr/L7uxGX4UIVenmYG
	FVooJOrHZxMD/LXTl1NWfVDmDpsPcFAepG2c3+9mRbdmLpk/tAp/3f6fhAHmZQkmiFApmK
	dN1RFs/oz0bT5pWP2kremYVE/gbgeeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761841562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y45ny24R7zem9vCEHKWr8/ZHpLbSWhPSrqSC/spGVIw=;
	b=D+oqUsGaCNVth5UJ+jVZ9a4MlY9qTQC2zol7+YlVgHZwEw4ExmMJUEvovqmF7TEqS4ZDTF
	1G1QbvzD5qIGfHCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761841562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y45ny24R7zem9vCEHKWr8/ZHpLbSWhPSrqSC/spGVIw=;
	b=Wr67yKJ4CtPObOAKIVbuQJ9uY1Mk/MgeJUi4m6VsB6BWlU0F0w3slr/L7uxGX4UIVenmYG
	FVooJOrHZxMD/LXTl1NWfVDmDpsPcFAepG2c3+9mRbdmLpk/tAp/3f6fhAHmZQkmiFApmK
	dN1RFs/oz0bT5pWP2kremYVE/gbgeeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761841562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y45ny24R7zem9vCEHKWr8/ZHpLbSWhPSrqSC/spGVIw=;
	b=D+oqUsGaCNVth5UJ+jVZ9a4MlY9qTQC2zol7+YlVgHZwEw4ExmMJUEvovqmF7TEqS4ZDTF
	1G1QbvzD5qIGfHCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0369B1396A;
	Thu, 30 Oct 2025 16:25:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rF/mOJeRA2m3FgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 30 Oct 2025 16:25:59 +0000
Date: Thu, 30 Oct 2025 16:25:54 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 2/3] mm: implement sticky, copy on fork VMA flags
Message-ID: <jmyrkglrrdxtdkcnovmkcxbk64zgfpp6r3e33bquixkvoxl45r@zcnwp3v2ucbp>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <ec71238fd1f735ca6e4970ccdc0abfbb60967596.1761756437.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec71238fd1f735ca6e4970ccdc0abfbb60967596.1761756437.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C35540006
X-Stat-Signature: huzndhffii49rzxaa4s1jmeoq8r6nct9
X-HE-Tag: 1761841563-658100
X-HE-Meta: U2FsdGVkX1+81aniEbHG6Ao62TF2kIjzpJql/msNbouiaqijkR/LU+VuO8ej43bw8mWgoFc4WZ/ZeQ4GCL/JGLrDrLgv3kEt7lJ1ENf/Pbad2U9xayklydRb1uUzfde55SKTnbXIB2AoD5hYW1hia0LiHTVyumkSxcYRp5gtKyaf4KxB06444n/6Yomhx9Kz+A3XmJbTd3f2UJB4dhOsEkYu97Qlqup/7AZ6m6HtpiWM/tPJ1g33Z2P4Hm+60a+QxBxgJ6Hc4e1mc/BoFmoRjvyq22mWseUuhTcmg1peykxtlW8nb/eZlKU2Kq8wqS8v45reOdfiqaIuu/3PSuk2VoT1Dq+jnTkmavp646F+7+zavmmab2GPQTtuPPcglcSU4z2opINs2QUoSLrvIutd+BMQF0yRqZ3HN73cVSSiuYbp2lJvKLPkVwDEkfxZPkfCY//BuQfYDMWS5kRtXXROIExboQh8ejr1lJVM7g++N9DgHVnaRc2m4Vaxtgo6fBDsPLGU0CR6W1BOhp8+00v/J0oV3iE/uYy+GwFYtHuwBVlcsivhl4wLslmT/fm5Wrzn6IAefX/DR8KR9Iu+XLgt7zW3fOCLyAEBFVeTdCCPdXLeBmP/dsOCbZMuwiRX3vmO6SfDHB6dDRshVdnQwcSzKXu8o6Fahz11v+fdVWiibMvUDmS7EHxHCsTdhKVql3iHM0NUW29kKX0Aagh7VTM+7aLOiBYXVSlIv3xXj7AR3MZiVQjU5GGxnV0LjYgeGmKRSsDiLSjBOATg8p9k+Om6G9TBTH+lOq4mzrg3G+1DIA6qgofoMFKItjfBVXbhXOZtih3AxqDWAlGJDKAw/NBLlI5lqOvgEfKrf7G76uDhu01GXM1fofiZVx+wNOE+rWrS4KHLnGZhVx0UnO+qLXWEVJMB+xFHJVOTNwsWDadcbrEPzqHUjtQ0qw1HrZWLMJqYx5isljKW3o4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 04:50:32PM +0000, Lorenzo Stoakes wrote:
> It's useful to be able to force a VMA to be copied on fork outside of the
> parameters specified by vma_needs_copy(), which otherwise only copies page
> tables if:
> 
> * The destination VMA has VM_UFFD_WP set
> * The mapping is a PFN or mixed map
> * The mapping is anonymous and forked in (i.e. vma->anon_vma is non-NULL)
> 
> Setting this flag implies that the page tables mapping the VMA are such
> that simply re-faulting the VMA will not re-establish them in identical
> form.
> 
> We introduce VM_COPY_ON_FORK to clearly identify which flags require this
> behaviour, which currently is only VM_MAYBE_GUARD.

Do we want this to be sticky though? If you're looking for more granularity
with this flag, the best option might be to stop merges from happening there.
If not, I can imagine a VMA that merges with other VMAs far past the original
guarded range, and thus you get no granularity (possibly, not even useful).

If you're _not_ looking for granularity, then maybe using a per-mm flag for
guard ranges or some other solution would be superior?

The rest of the patch (superficially) looks good to me, though.

-- 
Pedro

