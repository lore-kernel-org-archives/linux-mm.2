Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F7CCD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0698E6B0098; Thu, 18 Jun 2026 11:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A566B009D; Thu, 18 Jun 2026 11:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C576B009E; Thu, 18 Jun 2026 11:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB3156B0098
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:02:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 457E3C06D9
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:02:40 +0000 (UTC)
X-FDA: 84893350080.15.E80ED32
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1BA7C80017
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:02:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I3aIeWJq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9nj4athg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ipvHMcZP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5KCoBLuT;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcBpkMrWRkv4c2eX3mnxASJhUwC5xasxtwqDsdHi1pg=;
	b=rlJKcetnPMcSMAD9oEFefHIKl+XoCSQ9vWMODCt+eIzJvODRLYN3dNlHNzL70p0fOSXWm8
	JsrMcSTi0Qi12fngbGMOK2cJncB5J/62qozEXi59pI3VdnLUQCI04hJuT+BzADqjNxzSOc
	kM3ROgK3y5LMDK8YlEgKuNr4F8NM9qg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794958;
	b=5bsI7ytGun+Nm5xehnG/PHY0UaYyOxcvLK4KPzBNkvy8mvkKPK4r/k22ov+D+AutB1alPa
	wkB34vQOOo8uYcgQC63hnTUEfRtOeWyi+twiqHdc+QqqeiLeRpiUgX6IRvoVO2eaqWIpZ7
	XlRmpYY6RA94pTI6TCjl8toyFO5vGBc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I3aIeWJq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9nj4athg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ipvHMcZP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5KCoBLuT;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C1B1F7597F;
	Thu, 18 Jun 2026 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781794956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcBpkMrWRkv4c2eX3mnxASJhUwC5xasxtwqDsdHi1pg=;
	b=I3aIeWJqGtHnWch7dA4WBOrl8VynDCf+ndGvVpwb5uIdUUntJlNTYvsiQONKX/dMLTn27J
	HVGYIdm4F2vgrbO4oagP+GvgCXcXbqjxng2MDUiduR+35dzx5hegR9mZLQNgTI6ILL8m6b
	XUrGcCnaCcb4y2BT3y75ps+ooGxS3OQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781794956;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcBpkMrWRkv4c2eX3mnxASJhUwC5xasxtwqDsdHi1pg=;
	b=9nj4athgqqq3B8Hj3wGtkc/gzkoHKcYuheIc4gKxbR/ET21uq7pwjhahr8OaIapkJNFQp3
	gR+Q1tKpfypdtFDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781794955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcBpkMrWRkv4c2eX3mnxASJhUwC5xasxtwqDsdHi1pg=;
	b=ipvHMcZP0PkH26HXzNsKowJ7yjgVHpYHjFJ+dtvTFhYOHYvR7Hn5RQbKLArJvESAbnUQ0K
	D3qsFIQIMsCbvhQ+5eFLNyCCOzmiDfxDrQLNIl40Tc1g4f6FscAdQFf2jPQ6/5aH7sqKxq
	14UnzWGCYqBtuORJ2eswh/xF+2keh5g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781794955;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcBpkMrWRkv4c2eX3mnxASJhUwC5xasxtwqDsdHi1pg=;
	b=5KCoBLuTmGiEPYC7LkfcCqMu8yiclzzzAqf5FeVbbkrkHz9wSsc8qBhIXVYBvrxv8zku9X
	L6RnOwehoYbTn2DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EA3C779A8;
	Thu, 18 Jun 2026 15:02:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jcf1A4sINGoJPgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Jun 2026 15:02:35 +0000
Date: Thu, 18 Jun 2026 16:02:33 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
Message-ID: <ajP9bQhmvR9OX0VE@pedro-suse>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
 <ajPZlxq5z1hyo1kE@pedro-suse>
 <42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1BA7C80017
X-Stat-Signature: hbqq48kskdmeiy8cddqes64d6yu7ft3w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781794957-714342
X-HE-Meta: U2FsdGVkX1+rXPoJJl22NhreUAZtD4Ji75/lbmNu8nhRG4+rN2joa1+D8u/olaV0CxBj5HPHOk9Mn/sAnMH278Tky7Z/AGbvKzeg7i2Dg1d10klg7Hw0CXiJGMtKyOGKz6ulRnql7HnaHY0tJZASohEmQdEk/ZMYdQlUzhSQyQjs+K7oe7gEdDtnIvT2OCdCgKKALkCD3fi/vH2Tesp1HAvhgV0muohCL8oXT7COq1Wpp0k7v53rPP/EY3eitcK8BExb2vMy0whZzN4fZIE1ex/pAH2DVSM2IAQnLJ0edjNQf9rsfDJv0QcUXZ5p0NZUepTQz5GwEEZC3naL2uxQN0PGGLvOMzjLyw9qR9LoB0s/sRYM2+nZKjyecuAof4fL5nKEgwXCgftnmSrs4oYupTEIpKihCwL0UJriCpKvHROKhzfjJnngnypgs+BDjUsHqzNXovIarm7mL7zFPBr0d4YgmFtBKGc5UTlzfJhpQTVMJKVniAOQaqEfTiSvtksJTbpk3fd1L0LJWYNGfsYnk7QwPeD5J7Exxzkn/mqfMczsBf1fb3sNV7oFByCLOWWdKPsRpiXtariMpnGLfWgJBcp4pMUJrcoLIFYfumyXQJCtvkmOYu4M9z3TOeF0IniUzPJNPnr3h7NVR1n03VWoImhKaqg3Peez7A8ybQTQ1AucpYDSCMs9zFFacqiTD0/hFP49PIKKvz33Dd7IFnVdEgxHjEvpZcKpAinQ5d10Ib1o5eoy/87hf5xeX2vNRlT+M2lyIwA8HULb+7bLoziDt0c0SEGfYdtiOwjOSoSVZ9SsGJa2amjoOaOlxBO/GqD5UPvAXZE3BM9rpkO93cQ46bxl05anXXSRGohFFhDowTFgX3YbL4hztAnFAIC2/xilK0REFtjjjlmJ7L+j0EaqpmjlFXiYyE7nmCWtH95WJ9taY2botsmITLvchuPfQLSsIBG90wYj9oCTpZV7DW/
 Jrk1s7un
 DdjRFVG20520n+3sudw4QlUAoEBhdsSYZUj8VgmZ90NVAcF22cDul+Q4rrA4fFMgghr73k8AxfYWgs/fqDi/xase7yMzpVR2Swc2SVIOqYqKl/OXYlINx7yiznmKdmKabOFX11sNYt3SWCrN9/pcKXoPhNjIZsZqRxG/sMQ+NcLm66JOe+P4aj5R06PVoUCH/vK0vfhbkWApkoav/T8/5AQ3CK+JXxdL5lViZEpVJRJoTyBSY6DR49ZfJ14m2lx8PfGzL3bAJytUBgLLa/L6et6FUZlBBEqDkjaI1mY5x7Mb9arQLeWUIN/fkqj6FzVXBLOkQEayUZWJrb7flC8Q0ouCHIizY7/b56fVoE1+E+MpCX7LDqLvSQW1H9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 09:01:08PM +0800, Kefeng Wang wrote:
> 
> 
> On 6/18/2026 7:49 PM, Pedro Falcato wrote:
> > Please CC reviewers properly!
> > 
> 
> Oh, I will put more reviewes to cc list.
> 
> > On Thu, Jun 18, 2026 at 05:28:42PM +0800, Kefeng Wang wrote:
> > > The do_mincore() uses walk_page_range() to walk the page table.
> > > Fortunately, the caller always passes start/end that falls within
> > > a single VMA, so it's safe to use the walk_page_range_vma() in
> > > do_mincore() to eliminate an unnecessary find_vma() lookup.
> > > 
> > > Unlike walk_page_range(), walk_page_range_vma() does not call
> > > walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
> > 
> > Why not? Can we fix that instead? I really don't like having this open
> > coded in callers. Are there callers of walk_page_range_vma() that expect
> > to look at PFNMAP mappings as well? From what I can see, the callers all
> > seem to operate on folios (and/or anonymous memory).
> 
> As you said, all the other callers don't operate VM_PFNMAP， so we don't
> want to add walk_page_test() into walk_page_range_vma(). This hack is to
> preserve the original behavior, but as David said[1], we could add a
> follow-up patch to remove the special handling to see if anyone screams,
> and this indeed changed some behaviors, so it's better to handle it with
> another patch.

Yes, I agree, I'm 95% sure no one is invoking mincore() on PFNMAP mappings.

So, if we're keeping this check for this patch:

> > > 
> > > diff --git a/mm/mincore.c b/mm/mincore.c
> > > index 296f2e3922b5..0c6731ae6c4d 100644
> > > --- a/mm/mincore.c
> > > +++ b/mm/mincore.c
> > > @@ -259,7 +259,21 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
> > >   		memset(vec, 1, pages);
> > >   		return pages;
> > >   	}
> > > -	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
> > > +
> > > +	/*
> > > +	 * walk_page_range_vma() does not call walk_page_test(), which
> > > +	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
> > > +	 * page table walk. Without this check, PFNMAP PTEs would be
> > > +	 * treated as present by mincore_pte_range(), changing the returned
> > > +	 * residency status from the historical "not resident" to "resident".
> > > +	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
> > > +	 */

I would rather we amend this comment to something like:

	/* mincore (historically) reports PFNMAP mappings as non-resident. */

because we don't need to explain internal differences in walk_page_range
functions in a random comment in mincore. And perhaps attempt a separate
PFNMAP check removal patch as part of the series, or as a follow up (so if
it does matter, we can simply revert that patch instead of this conversion).

In any case,

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

