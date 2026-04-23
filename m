Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E026F99360
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 09:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359736B0005; Thu, 23 Apr 2026 05:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2F66B008A; Thu, 23 Apr 2026 05:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AAC56B008C; Thu, 23 Apr 2026 05:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 060866B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:40:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CD1F120433
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:40:06 +0000 (UTC)
X-FDA: 84689324412.07.8AF9709
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FD361C0010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:40:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RjBrRrqp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7NLUso2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RjBrRrqp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7NLUso2;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776937204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAIgJvfGcNyjVOyKNrtEJWERix5T9St7W0kXMBLED64=;
	b=d7wgCT8YUhs8J/z1BFbOjceyvfbXmhMHchxjooOxD7OFRHDZCtanfxI43i+Bre/QbZTNou
	8/jJhGzLzFAKCPKv1WBT+ZZ6c93ERVUuns1605CMpDovumcrsJUsteFQe5wescPsNZjKz5
	/sfwdemMODcj3zLJ65456/viDy7/1EM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RjBrRrqp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7NLUso2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RjBrRrqp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7NLUso2;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776937204; a=rsa-sha256;
	cv=none;
	b=lgegzpi2f/lIHqvCqd/msTaNUc0G4yIcI29tjkyz8I9L/aL806LX3RBEfVP5kYk8SxnVUz
	RGd/0tNovnn6mAEmGtcc+3XZOmrGrRqfbtY2SuUy7BNsUl4MtWCD4F65FEt4g46nLDvsYT
	sFcdnW8QTuEWJD28Bwv+YipIFeQgVoA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 135EE6A833;
	Thu, 23 Apr 2026 09:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776937202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAIgJvfGcNyjVOyKNrtEJWERix5T9St7W0kXMBLED64=;
	b=RjBrRrqpRz190AP3AMN2FKhggjXRYTLAux9jxSQ0D/CwownL+6OCGZxjXwSRwF47Oqlrgz
	sT/vrIHfWvlPLbAxA+XLx1aqgkssOdj6CTwo7S48qpy9HOiKWOaGWBPtZ7aJ+QCnmeofVB
	T32pWcNsaZgWNBkG5/fkTe9QwRb4o28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776937202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAIgJvfGcNyjVOyKNrtEJWERix5T9St7W0kXMBLED64=;
	b=t7NLUso2VTu/HsCctXD5rcdS0RImI3w7hjtAGikCRwuob3ieFexlWjv72/ML0GUJCD7Dok
	VA1qM6DxB6gGGNBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776937202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAIgJvfGcNyjVOyKNrtEJWERix5T9St7W0kXMBLED64=;
	b=RjBrRrqpRz190AP3AMN2FKhggjXRYTLAux9jxSQ0D/CwownL+6OCGZxjXwSRwF47Oqlrgz
	sT/vrIHfWvlPLbAxA+XLx1aqgkssOdj6CTwo7S48qpy9HOiKWOaGWBPtZ7aJ+QCnmeofVB
	T32pWcNsaZgWNBkG5/fkTe9QwRb4o28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776937202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAIgJvfGcNyjVOyKNrtEJWERix5T9St7W0kXMBLED64=;
	b=t7NLUso2VTu/HsCctXD5rcdS0RImI3w7hjtAGikCRwuob3ieFexlWjv72/ML0GUJCD7Dok
	VA1qM6DxB6gGGNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53DC3593A3;
	Thu, 23 Apr 2026 09:40:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d4YjEfHo6WmiPgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 23 Apr 2026 09:40:01 +0000
Date: Thu, 23 Apr 2026 10:39:59 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
Message-ID: <v6cqjcp3fdkmh7z7twu2onxvmybl4na4enbnpsjf6z3lklaphw@n7iqq4rbkytn>
References: <20260422123726.517220-1-pfalcato@suse.de>
 <20260423003227.74498-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423003227.74498-1-sj@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FD361C0010
X-Stat-Signature: qyzc4jpnwznnhh67o3u5rpz3pzao993q
X-Rspam-User: 
X-HE-Tag: 1776937203-34679
X-HE-Meta: U2FsdGVkX19PrIFKH+vA3oHMGI6JQlWCXMFi0XJQW0fS4k611atHktgKC2Awxei79Oqyv0vgOVGqCiMKZxlD9bmvKzB4op/a19BJH5c1TyUQMfPDX/VIWy3NVcrVoT4Rtp/zG+1rwse77qCDzdsmAXi7DH9ogt4Wn9tFFu1GKD2Wfw0PXUZJ8zw0Xjjvtf3oUE+ByahSePhwnmT0dbKhj9IcI0QPoaK5UMb0/ir2f2km+aa405RcaBcI7os5rOHdIiy/M5p4+8EJIDPA5AtALqTMmtzqc/liytCywZpumztE195tLnWNQkwjejQqgq8FzPWL7Or29fWtaUTI+13TfsPgYUWd1ntqa6wmnKyvAMMH/WHY1bkSZ1Rp1NDKbugPs4A6KIAOqvzlkeT13w+LqH+CQWeY3uKnY8Uf98/WRg0Sp4V+KPQpTgTyOyKTcPkcDtbfhFwaRcvjOzA4yOBm0Z+wA25fwCs+vWvytZ5LGgOf3weRb9ul0USbRKstCUXN5tgytoRcAG0R5OtkYHcQRLAKJYFmWUbY3xQDaLtzkWZkQrvri5fhMl6rysK7ECfnZZ1VVrtyw8i9gDvViM6+QimpqNiBuA/FjMiEtEportY0xqRBS7zi5vhlNUQvIkqovW3t9zjN0bKGNo3no+FTpnxLuB1eo9pETpgedvvHViEsWNZVHbtXqVm+gXzUiUKoKJLv4CxxrdxzN0QQPJV3YV/2Nv5deq/uzyF4rlVkr7G0D+PIrq0m1bob3Dht1nddbA76J8LaGsZUFdTtRQyhXBd8t3K2waYHOoH1yWfQYrVMsBolVZ2JYZGhRW7lgCDqQuDmX7tVCmYX21d+DHc09sj0fDfl5ulN8qdVUnVTm8jKABeHG5sPYl7AjqzjSZ3A/ysqugoOarwwTA4lxW9dRhFdCM37XEvCC35Lxot2xe2Z2JG86d973NIGjLSdNgovCb8yaSYgJ1ebwGKPCwd
 K/4CfNR7
 3oBqXFrMRy6z42hNK9NNAKGkkTal6Xv+1188aykiUUEBX6WoihTLRyJ0O1JYu3zdP0zvVaw0qJGVfYh9vjgnzhRWUtCsIOqmbGsb3n9dTQWl8/r2lY5lEjgEl3/DqKBtwNCd0x579446Tg/Zhsv2/GTWwJGvYdNLe4XmMXQsAr9y13MZXFJqvABkiCTyjlCdtDF9W4xrqz7iEMQBDqkzidyeLiLAtXhntTR5RIuSg+24XQcYvdzUe1fD6lkJCyfJVroGdX8btCsEYVXpCPDs+ZoJVKxLUV/sybCo9i8f3BII8sIev6DYAT0b2NwE7P1krJGu5yqIrcSW044n6hlzJH4K1Wya8ju5YHOyM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 05:32:26PM -0700, SeongJae Park wrote:
> On Wed, 22 Apr 2026 13:37:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> 
> > The pattern "include/linux/page[-_]*" matches every file that starts with
> > "page", because it's a regex and not a glob (so it has the meaning of
> > include/linux/page + match [-_] 0+ times).
> > 
> > Fix it up into a more regex-correct expression. Doing so reduces CC's
> > drastically in patches that touch pagemap.h (which is maintained as part of
> > PAGE CACHE).
> > 
> > As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
> > ALLOCATOR.
> > 
> > Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
> 
> Just thinking loud.  I was initially wondering the purpose of this link.  Seems
> this was added to show the example of pagemap.h touching patch that can
> dmonstrate how many CC can be reduced.  I once thought about suggesting to add
> the number or the context on the description, but realize it is too trivial.
> So just thinking loud.

Right, I probably chucked that link in there without explaining it well
enough. I was having my leasurely read through linux-mm when I noticed that
particular patch had _way_ too many CC's. I had a quick look and, yeah, found
the issue.

For what it's worth there are many such CC's out there. A group of 6-8 MM people
get CC'd on pretty much everything that happens in the kernel. Not super wieldy.

One thing at a time, I guess.

> 
> $ # Without this patch
> $ ./scripts/get_maintainer.pl ./0001-mm-limit-filemap-fault-readahead-to-vma-boundaries.patch | wc -l
> 13
> $ # With this patch
> $ ./scripts/get_maintainer.pl ./0001-mm-limit-filemap-fault-readahead-to-vma-boundaries.patch | wc -l
> 6
> 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks!

-- 
Pedro

