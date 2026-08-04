Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F430C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4126B00A9; Tue,  4 Aug 2026 09:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ABD06B00E7; Tue,  4 Aug 2026 09:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1FE6B00E8; Tue,  4 Aug 2026 09:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A88D6B00A9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:57:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48D821C007F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:39:07 +0000 (UTC)
X-FDA: 85063541934.19.E8264A4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3FCB540009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:39:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wvohMkIs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="FdK/Fa76";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="xKZL/gF7";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XetrqBDd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785847145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnExphRxEzIlDNvgZ2NHF0WSmLvuvWvbQz3FoCApmhE=;
	b=OF1nsRAFLSMwYK5gAGTI1Zd29Mw9cxc7HwZnHY54/pmoBhBGFfrt5IyT50IqOgA3mXjOiA
	E70ATaxHBVoqwkDg53crTygNZPj0qOX+HpfOSZsDwFF/7fyd4zKC8YmKQKZMPV2eIXY/cD
	35NS7I7prUMewp1fePGsJL5NdvFMgx8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wvohMkIs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="FdK/Fa76";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="xKZL/gF7";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XetrqBDd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785847145;
	b=JQVPWWaaph8fgWad/rwd5O0mzshyWzZCn/nPJrVceuOL2TqGGLCC174bsBZiEUom6EhloA
	ofSaCd3iCxfWfCiVuKx1NGS5JFd+YklF6rd2kvRom8i5oAa+zu2WcfEUh4+AFpKmngPH2q
	ofavcpVuvpVUOUG87D/QS60RGpD01Po=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A11CA3DFC;
	Tue,  4 Aug 2026 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785847139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rnExphRxEzIlDNvgZ2NHF0WSmLvuvWvbQz3FoCApmhE=;
	b=wvohMkIsXd9yQZOEekufv+/wSEoE0QTrBjCrlfQYXnFoFALgKBzvEuxp3xXMEXb6j+zLGT
	YKOH3SuD/auYha4F/6h/WYQKLo6gtbFJU8bM93k4q3o2IOGc4bl/ES61KRfnQ32p/Hf1cE
	Tg3JYIbE8n1oLduDNwRJJwlG1V8GySk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785847139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rnExphRxEzIlDNvgZ2NHF0WSmLvuvWvbQz3FoCApmhE=;
	b=FdK/Fa76S7Y0zeOrDlmk0JnV3bWdjkzcl8zDqN60TgNmCBiJdCcSBvDNKOzuZtQ4ftLHlf
	dfJ02+I1SoIfkACg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785847135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rnExphRxEzIlDNvgZ2NHF0WSmLvuvWvbQz3FoCApmhE=;
	b=xKZL/gF772XFr5IDL1R1+ZkyiJvy1ndS1SlYygAYzd4LpDZsZnWu4Cu+5txRQdWkDh6evs
	TndXSrXQcouBd645DhWI12pePPM1Q83nU1lLHpmaCt2+IXigp1Eh0LIM1rNZTt4GiuIaso
	oTJAU/8oBNr4dhpWpZwd3k8NQ+9rEjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785847135;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rnExphRxEzIlDNvgZ2NHF0WSmLvuvWvbQz3FoCApmhE=;
	b=XetrqBDd+RmJqSJ5wEA+hJsLUFtVId7SVDz7ajG6/wu5rJhGfE5RSzqYcRApPVZG+qfYlH
	O2K/mufrSfRt9YDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFE3F779BB;
	Tue,  4 Aug 2026 12:38:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JWakL13dcWrDVQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 04 Aug 2026 12:38:53 +0000
Date: Tue, 4 Aug 2026 13:38:52 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
Message-ID: <anHc4aUbwxWx9YJF@pedro-suse>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-4-pfalcato@suse.de>
 <anHI4B-lMu6AJJfA@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHI4B-lMu6AJJfA@lucifer>
X-Rspamd-Action: no action
X-Stat-Signature: ggqai1rjfesqy3ujjzy6eun4nk3677b5
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FCB540009
X-Rspam-User: 
X-HE-Tag: 1785847145-806484
X-HE-Meta: U2FsdGVkX186GIPI22dymg/4AlCBHnvgfvWVeK6pA1rFRBULY/zt5trSXxYF0IOsAi6enzm18PDUFDk7NS6T+cVVez9d+HsdnOQOnMeBuZA+BGPHhwIbhkcpIVkagi6YZb9c7psMe0YVsoNaqDt1RNK6QF2YGhtLN/s8VsleFahP1Sc5JEWGDfNYcGyGU/jKjq7mtvgo8HPMLYvDgX1XmY3U5z1WR3DCqvWwsA7uKOMvM9Fts+ePppm516XlgAPX1Nlnlnq2Five4xJJ4dcmeoYxmqLVFJE+1SsEo7p7DcmUHJaC9DGVvoYRkkcdU62lRG5IQw3sBPxxUubZz4fBSMnbbGEqe+WbWoJdHb63yXV/MSXFncDUQjaNbTdbEe/Q5ep+QW/Pqrm40KCHCXqoz052zCu5NgNPpla7ZwZVZpRHCjBtVRwthK44znBaul57o6muKlg4t5CgIk9EZ2tspyWDH5fejWEGQBcu45mlcGN+ObS12fT1kt0wAqRAwOcxGlYJB3FVEm7AwDr3TLiFOGopx006XqI+UTnXCplPPk9C5HUbbNr28/mGWd3Aevgy5mJXDbEC/aYCpuTw7ucMGXU2G/WhUceLE5fnGdf1GfQgV29NMAP9YktOk4Q3tBkCMeKJAq+R3FP2vlyZJpwWjF/Ecn5f8TDM4+PXfZcwaXzgNPTaI45LZPHodkn7sCeiqsL75kioAUv+y8NcNoE80771i/YnFU2GiPpaVLKcdeuF9CBLuKVNHZegKaAbOcxQz2uc2CPfeQr9EMDBw4l+lBVn5tqXjDY9LIkv+1V7/7lj/g/GtT9all+nCaxZ73mHro5HGB8cNWYQsnzeZVMr21hYxCA3zFmXPZjS2cdm15thZScWtCeNK/kGtI8ajtKIFFliI2/hsZUY8mAOqxb1K15iBaU/0FIJant6UH/s024OA5l3CVwn6Qwi98nKmCnXkFOEM/1deSDBfD/7lk5
 PSGTa3LN
 6rmxlRH0iGMTuWcu71wxERlQ1kykCsuHmucNt5NO46rQRFgnK2km14Q1lp//DF4GLwuqwnEvdoC/5VbwDbaluaNnJCmZMb588T1F9O/WIv3QvGcFFEs2Old9Fnqou3OiAcYVG7I634+C2TmA9lvI+KJAhqH2ztKubQCF+09zYEyAj1u+aABZw8cSOaUcwYEoQ7lBMRcja6xHnKCH9oIqrDOEWgVMyCdG9nA+iCyZiSqvXNDp4Tle1SEfjfHsNyWIL+M7y0ZePpsA55l55BCbS/17P2AimYieZjd47OXFrOrU5J+aG4BLviJFqxZg5V+AFp5+G9NIa20156FDmxUC5vlC44mnCPqnePbhv8FRI4lwwSatRAmUMOZ+Cv6MtTZQNZcVxajG26SIFQv3ZjXTJqL4DHt0S003+8vgLRMSTxRQZZcgq6XWBiCnOAWW9axmwfepW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:13:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 05:43:57PM +0100, Pedro Falcato wrote:
> > There is no need for write access to the PTE.
> >
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> With below addressed LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> > ---
> >  arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > index e2ea8ba9f8ca..f2bab31040c7 100644
> > --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > @@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
> >
> >  #ifdef CONFIG_PPC_16K_PAGES
> >  #define ptep_get ptep_get
> > -static inline pte_t ptep_get(pte_t *ptep)
> > +static inline pte_t ptep_get(const pte_t *ptep)
> >  {
> >  	pte_basic_t val = READ_ONCE(ptep->pte);
> >  	pte_t pte = {val, val, val, val};
> 
> Worth making these const too (that {val, val, val, val} horrifies me btw :)?

This is PPC code, so I don't know if they have any particular opinion here,
but I could definitely do this.

(FWIW, it seems we're more aggressive in MM in doing this than other places
in the kernel?)

-- 
Pedro

