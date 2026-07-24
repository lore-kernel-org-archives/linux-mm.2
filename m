Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D91C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81F36B008A; Fri, 24 Jul 2026 08:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59456B008C; Fri, 24 Jul 2026 08:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FD66B0092; Fri, 24 Jul 2026 08:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6365E6B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:57:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D67ACA0345
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:57:51 +0000 (UTC)
X-FDA: 85023672342.05.B583A5C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id A678180002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:57:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tpg/AegW";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wYjmyrL6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tpg/AegW";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wYjmyrL6;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784897870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwqlQxogPnZR3j3vZatDYSH4YbGvS2weAZ8abPdxsk8=;
	b=xuIBVgwKsGlOuM0Za1NsMiPv1A+8w6UMnS1g5THDUA7YwOSILqxBwl/r2PQvvOIyff5xG0
	LyMN0VG0C63K6AQnw2xfuI8uLERGLfprBZii6Z+g+L19APZZAf5qt+Oo77yF3Gf2k2bCyI
	ccweUzYHpnTwO9EPeDWTteL1r+s9WlY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tpg/AegW";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wYjmyrL6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tpg/AegW";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wYjmyrL6;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784897870;
	b=UVx0WQ5RoLrNyXJnkhIcFGxbwJJRExsVA6DiPr22QqJ0QBessQCgTgdHaCapHRnaSmVM4Z
	xvnkOZNQ+D4eyck0XxbNnj8A+tjd/4EjyEXi/AcKYRB+mcVnWJAOX5rRBAa5p3YSeU850q
	LwSne/tb1VkaHo/nHbr5rdHeCN1EnaM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 134753ECD;
	Fri, 24 Jul 2026 12:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784897868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwqlQxogPnZR3j3vZatDYSH4YbGvS2weAZ8abPdxsk8=;
	b=tpg/AegWEEyQF9NL3NQe2dNMX5JujfVpqG5fC1Nc4EXxmT5E4LtC5ahHxaM7OXE8D40XUV
	VwAZMPotr2+KQx5XFISeCjDTQYMCrKsvycbLLpqToRj5oRBo2zDFi8rrdj5ato0KWxXq3e
	ItdiDPtlV2Mms3c2Gx90skTbZ0vvBXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784897868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwqlQxogPnZR3j3vZatDYSH4YbGvS2weAZ8abPdxsk8=;
	b=wYjmyrL6U3rCCRtwBOXDHGnCz5StpbG4eKz69wfh3VCRU/PAF30jeR51gKTW3uKue0JZgm
	86ndZlfes+8ZpGAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784897868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwqlQxogPnZR3j3vZatDYSH4YbGvS2weAZ8abPdxsk8=;
	b=tpg/AegWEEyQF9NL3NQe2dNMX5JujfVpqG5fC1Nc4EXxmT5E4LtC5ahHxaM7OXE8D40XUV
	VwAZMPotr2+KQx5XFISeCjDTQYMCrKsvycbLLpqToRj5oRBo2zDFi8rrdj5ato0KWxXq3e
	ItdiDPtlV2Mms3c2Gx90skTbZ0vvBXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784897868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwqlQxogPnZR3j3vZatDYSH4YbGvS2weAZ8abPdxsk8=;
	b=wYjmyrL6U3rCCRtwBOXDHGnCz5StpbG4eKz69wfh3VCRU/PAF30jeR51gKTW3uKue0JZgm
	86ndZlfes+8ZpGAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE4F0779BA;
	Fri, 24 Jul 2026 12:57:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hn4FM0phY2ogBAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 12:57:46 +0000
Date: Fri, 24 Jul 2026 13:57:45 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, 
	linux-s390@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
Message-ID: <amNgK4WYP9yZe7iM@pedro-suse.lan>
References: <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
 <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
 <4bfeb697-9c1f-4316-96bb-9bfd66f959df@kernel.org>
 <6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com>
 <20260721124057.2820903Adf-agordeev@linux.ibm.com>
 <3c21586c-0ffe-4ebc-97f1-803e8acfc5c1@arm.com>
 <716f73c1-41cc-48a5-b0e1-a47403a30da1@kernel.org>
 <47b4e62e-b001-465c-9c3b-ea0636925387@arm.com>
 <amMvuPZ0tglCoi1M@pedro-suse.lan>
 <67ee9da4-cbf9-40d1-92c7-49710fb15f1d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ee9da4-cbf9-40d1-92c7-49710fb15f1d@arm.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A678180002
X-Stat-Signature: d34s6q3od8syrtc1zi3pnpx543x1cdqi
X-HE-Tag: 1784897869-595029
X-HE-Meta: U2FsdGVkX1/4Nm92ZN6KglSecPh8Hrjj9q2micaLryl1c5kyaJugJfRfnfDBEX95/+cZ/NL5FgX3VIVsGlKrHKby1kaDnD1aXB+Y/KO2QE5nydcHG0dQPDLVWioPzGPo8jBCXoqtAMRY8ATjTgGNVU77xo8lIAuAMZcTWW2y0e9FDlaX4BKlqPspFiyMZg9CzuhtmW/mYiISimg/rjIO8pH8R0b6QUIN+s1Eb7I9S+C3FK3NU2FwluJD6XC1xp1wS61Zvl2dgryGvYBpN3CoUdC922tezUoNAl4gSVcHYQyTI5CbH3PnTK1/CZRWbRh72vChqNwLmUe6lwiHt6POIZ8FbjV1NMSkgpft+Q9T8fm2IBIgktws/WVeCg6KB3F3qUUbpgpaMUBe7DUemZpCuf8nIeVK3vcauO8KhdPniwl1GHZgAi/YrPhUV2g/mpfhueMq8u2VpU4bpjzOnOJ3LAV1i63/oEkt4tvX0EDNIi4UUm1hMYYKVqJv6YKptD7PE/mKAva9R6u9FplSNclESNXQxQ/G6oUmfmzL4zZWD+jQWVbEidV75Fz5oxsr73QnUd8cwd0mjOaXxEdBMTr0M8nHibOzapnkCgHF+SON+SjpmJkWZg+qygeYzcxUo5V+M2fRnrH0cyMFAGMjBl3zlibdCpG68OE9KFYvV6dUfM8jENC+AR462E7V091H5haBNo0K7PmgLmhG0gmgEAgLC4rxWmGSBnJdFJgUuse0Fb5+I2rUt8VLOQ6GKNcl9rFjdy22hcC/arNoqoAT4cCk2TZVabtU54TYBAxwqQjE3ysGKpoRJx1JvsStyJMqTT6ajzpQT+8UeqcruZMYvi1vKfvJ5sDBPfw+/tWdb0X9sDxY3MWTrU8S8bDpTbj8/FR+7J5YbwJoCs9p5TSUqzE8rvzmo3AVpiqISxi7xTzkBT+lJ0g5IBgTGwHhUeRECnIt7Onu/qWJcMmPo01wM4p
 xktcLt4U
 w1yyciHUVKknieOdc7Kq+FIAFQCFqQ5wL5Ag28H6q7CZmJ4AGkATC5lfbNqXgV8T+FZvpQg2ZExztw/Fwn8qbZtBqnm+rDbXuvIZ2mvob7GdUY7N+HFLL/DamINIJp/s8f3kNVA4GNCuEm4cYd8V1bSwOGp3ohgHk6d9qaZPBkBsM7isCB4+eCea428Kqvosqo/pFBkZiaT/oE4eVRiOV6ueHCJuYXJ+hgu8euCCYwwxcMcejiwyIMDj79AVN+DeoJ5AOkKqTvIsLEgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 11:34:52AM +0100, Muhammad Usama Anjum wrote:
> On 24/07/2026 10:30 am, Pedro Falcato wrote:
> > On Thu, Jul 23, 2026 at 06:01:49PM +0100, Muhammad Usama Anjum wrote:
> >> On 23/07/2026 5:38 pm, David Hildenbrand (Arm) wrote:
> >>>
> >>>> So after the conversion, it doesn't makes sense to keep STRICT_MM_TYPECHECKS
> >>>> around. Please correct me if I'm wrong.
> >>>>
> >>>> This brings another thing in my mind that in ideal world we would just
> >>>> turn STRICT_MM_TYPECHECKS on for all arches all the time. But the problem
> >>>> with it is that STRICT_MM_TYPECHECKS defines pte_t which will stay double
> >>>> meaning still. So we want sort of STRICT_MM_TYPECHECKS with different name
> >>>> and separate stack and hardware types.
> >>>
> >>> I think STRICT_MM_TYPECHECKS is also to avoid catching when passing a pte_t into
> >>> a function that consumes a pmd_t, and vice versa.
> >>>
> >>> STRICT_MM_TYPECHECKS makes the compiler generate worse code today, which is why
> >>> we don't enable it always.
> >>>
> >>>>
> >>>>>
> >>>>> We would like to keep it, and I guess some other architectures too.
> >>>> David had summarized it well. We'll convert generic code to use hw_p*_t
> >>>> types which would be typedef to p*_t for those architectures which don't
> >>>> care about. But if an architecture wants to interpret these types
> >>>> differently or want to make sure the type is enforced and not directly
> >>>> dereferenced, they need to convert the arch code a well. But it can be
> >>>> done slowly.
> >>>
> >>> I think what Alexander meant is: they want to keep STRICT_MM_TYPECHECKS (or
> >>> something that achieves something similar :) ). So as long as that keeps on
> >>> working, all good :)
> >> Thank you for clarifying.
> >>
> >> It has been a month since I started this discussion. We don't have any
> >> disagreement on it. Should I proceed to post first part patch series considering
> >> most people must already have viewed these emails and are on-board with it?
> > 
> > Besides the vague disagreement I have (about whether this is worth it or
> > not), I have an actual objection: I've been doing some constifying of pte_t*
> > for various reasons lately, and something that just just came up is how
> > hw_ptep will _not_ work with const, unless you do something like
> > const_hw_ptep, in which case welcome to Win32 programming or something :|
> > 
> > (I'm assuming the idea still is typedef struct { pte_t *pte; } hw_ptep;)
> We have moved on from this as it was very disruptive. Now we envision the
> following:
> 
> typedef struct {pte_t __pte;} hw_pte_t;
> 
> With this, const wouldn't be a problem.

Ok, great!

> 
> > 
> > Have you tried sparse instead?
> We want to ensure safety during compile time. Without going into more detail,
> more features would be build on top of this type conversion. 

I understand corporate/business goals may be tying your hands together, but
it's really difficult to think about your proposal critically if we don't have
all the details.

-- 
Pedro

