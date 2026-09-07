Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2F3C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360EF6B009D; Mon,  7 Sep 2026 05:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311BE6B009E; Mon,  7 Sep 2026 05:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B166B009F; Mon,  7 Sep 2026 05:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFD366B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:52:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76F66160743
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:52:05 +0000 (UTC)
X-FDA: 85186500210.24.3597B91
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4034F20007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:52:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dE3PFJPZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=evckSjsS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NbQGgxrx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1h27ebbK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788774723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lrwr41K2Av2Kuzp3keYp7cIHw72jszLX9DJXo1qTJ+s=;
	b=fGTpADKGz23cyFOypULfeubKrBYPDLcN9Trs8vFno3oX1MmlytsLwrSeYkGlQFGLFA7IrX
	GlFC1owudZcU7JJI+QE3o1hcCYYSMtpCs8PCFX0Fa7hCDI8UvvcMdDT+e9p4fFxOCThuea
	Sh2R8rPjoMxCh6MhrUUiMA7+4JeO8iU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dE3PFJPZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=evckSjsS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NbQGgxrx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1h27ebbK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788774723;
	b=Z8dIZAmXQUxz3wPIqcvVTRLpU9zlYCX6JUI7PvenEyCXFxnSABChUb9+5w/vE6HDTh2Qtr
	SFXAAsBoGRRh99/cqoywtQlYSEqX8KNvAeuZBu7Mi77D/FbumrE/uxPV1F5ZrIEnQZPBUB
	8/IxX3KURqEZEwbqJRCcriETL//pJzA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A71E41F74B;
	Mon,  7 Sep 2026 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788774717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lrwr41K2Av2Kuzp3keYp7cIHw72jszLX9DJXo1qTJ+s=;
	b=dE3PFJPZWRBPE3E4+rmps6dicaRZa2lCogXhIAPARvhDr6vvx9qYbxmlSQjsnHfXNen+k9
	5jcmJNUQgEpcf/GRp/OUHCDGv/s2RwAJb9RLv5g8y28PVln/B67+9+tv9bvPSNtXQLRIp4
	auJpXhHpf9JXfP+UwDoG3pnUYEsRvEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788774717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lrwr41K2Av2Kuzp3keYp7cIHw72jszLX9DJXo1qTJ+s=;
	b=evckSjsSFhYc+ha+a3TasKEfS0/LQCR+139IpylcHE6VnVcJPNJjmlXsOvY9O3DuwYYjaA
	CTIgKmbtMXby6CCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788774713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lrwr41K2Av2Kuzp3keYp7cIHw72jszLX9DJXo1qTJ+s=;
	b=NbQGgxrx4+NYiF3BWZ485svl9z6Ee1XZLb/1OpRgnur5eDPsRpMyj4gNviEj+/kc+QPDCL
	ODIOJEQYohutKHlDEki5eB59AHMB6I33iDeolOCdVGGUuCKnZ8AIIImspU26tZvI8+B/Aa
	87/kQFxM5cCda+/c9MYTphsxXUmchIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788774713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lrwr41K2Av2Kuzp3keYp7cIHw72jszLX9DJXo1qTJ+s=;
	b=1h27ebbKa5K3TTcSGv2wM/I+9Ex8ihbl44C997NEjxlviuolS4UO8fGXYe8BefaiWwHQWs
	IQkWQKViMr4m1xAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D0AF13432;
	Mon,  7 Sep 2026 09:51:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3FX5BTiJnmpiFAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 07 Sep 2026 09:51:52 +0000
Date: Mon, 7 Sep 2026 10:51:50 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, akpm@linux-foundation.org, david@kernel.org, hpa@zytor.com, 
	rmclure@linux.ibm.com, andrew+kernel@donnellan.id.au, pasha.tatashin@soleen.com, 
	kas@kernel.org, tj@kernel.org, rppt@kernel.org, rick.p.edgecombe@intel.com, 
	yu-cheng.yu@intel.com, orsonpeters@gmail.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Message-ID: <ap6IYeTM8PMinxo-@pedro-suse.tail5790ac.ts.net>
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903031608.1194238-1-vernon2gm@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4034F20007
X-Stat-Signature: q5zs9k7efgxfscwra3bqk854p1cn1xjt
X-Rspam-User: 
X-HE-Tag: 1788774723-118406
X-HE-Meta: U2FsdGVkX1+B2+TbYHwpoWk4Z7euT4CXtfVCVBtl42W7ln1swxikXE35c9H7nMsfwhTqQ2H9ETHJpZ/pLstj091iwAcxCzS4p4fcLncaZuLc5qsf+S0OC7kfxPAzO2UyVegSqJqpdgps9A0mZADQdLmFFVZbs7WYGSL0VZCKM9vjM5uxg81pmbcDY35RsZrGzQNJ6SCKS6c3Ro0E2TJK5vL0pZIizRGBR5gJpOuJS6MUQzbhVRwcgLtiaPkYgISZ02DdEkf16lz1oTunEwWlJlbSthtYgm1invc/vTOhNmv3FYIftgk80ghLvSTmKudGg3+ZtLwR9RD+aX84/8F9yOVDt84974jky+Uz1KAWphVQLHfiL5y4VIMZaCMITem349Dn7uNFf3J7JXLbHZ2JoUSJ5TaHD84v/7N36fGE2Hi2jY5LiDFVv7svOh85wHuul+5e23rEyg/Tovr70nusAl1LJAZtP7Hfz5dVIZrsDQ3dxWZ30a0xTjscxvHZhF8WpDRL1UqlpsqPeXnqdIOEfO01Z4BbEr6sihpoX9B9jTzI3MEct5Xz2klb5usXh8xEGPkopwS2E4BZxu2seCLVbxJ4qvv3wLwcCYCnKatenCuJkGek9dZHluYBdfpPKD4WEWylX3DWmq+1VuJmfsvGfhRjAEaxLpgTbQlRvTLq9hoy75D+V70S5z8tZgU0Bt+JJQ0wQ16etpdmj/fTAqr+xK6o1YORDgkTEjWH/rK7gdiANYV3pBK0tEMpzSE3xaw35XbRhRmvRzyS59ibIwgKXZm3LTYk6RWrHFaF3+mzU34ZXaoDcsrZvl9x5d+qKc+2nP78pXWS0SHpizGxtMkYkZGnlHW0YmpjufE66vK/nmn9p4usAMIwCk59Q7qjlS+J8RcPBq1VYuJ8A6QbEveiUcm+hB7Y2yWd8yxG1D4DaxKAI1kffH87D8UDvT5nVJPzKkliLLXkHPxdgo3G76U
 pzHhtzCP
 8B5vXUhJEF3ch4CDNh+ANaXFECg95YjwSlye6jBrMCoKMuvx95e9aTq17thpNFDEr8ut9jN/t8zuJrLTLN/Q01FnL5goAZSJAcE70dNIT9Hz+Oi+nwedq3nx0CnjEsDGBkSLYJ/nyL9xG/uvufYZc5/RvhSfFc/zC+Ovn+tzr1k9SA8EjA5/dydBnvbvcGulv+Ba0N7jndL8pnn1T2RzPMa1lPMSHrw9bePg1pBQHljYcfv0nzkTN3sZGT7c6/+AutW7K1DgaxM4AlTgU6sNIqUb1b5Ysy1dodG6LudxllPsvRedROaO7VIdUh+3zWXe9YFLJ+YxSMb9PZR0Tlgqebfosr5gLKqq1F0f5yuSIRAj19L727lMeJqfhd0afrnCe81PJlgiOylA1REhQNfJ9EprUBEImzu3wU4Ze/T8rT4Wi48EycXqVtZxtjbnjwzT3ELiYTOQ/o3vQnxRY9lJgEpWrmCFxwAE/D3r3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 11:16:08AM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
> silently discarding the hardware dirty bit.  The subsequent
> pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
> _PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
> stripped from the value, so there is nothing left to transfer.
> 
> Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask,
> and pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify()
> is the odd one out.  Any pmd_modify() on a writable, dirty PMD loses
> the dirty state.
> 
> One visible consequence is data loss with MADV_FREE on PMD-mapped THP:
> 
>     memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
>     madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
>                                       // folio marked lazyfree
>     memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
>     mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
>     mprotect(buf, size, PROT_READ|PROT_WRITE);
>     // ... memory pressure ...
> 
> Reclaim (e.g. under memcg pressure) then finds the lazyfree folio with
> no dirty bit set anywhere and frees it in
> __discard_anon_folio_pmd_locked(), even though the data was rewritten
> after MADV_FREE; subsequent reads fault in fresh zero pages.  NUMA
> hinting alone can trigger the same loss, as do_huge_pmd_numa_page()
> restores the PMD through pmd_modify() as well.
> 
> PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
> the dirty bit means rewritten data is never written back.
> 
> Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
> pte_modify() and pud_modify() do.  The existing
> pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
> hardware-dirty <-> saved-dirty transition based on the write bit,
> preserving the shadow-stack encoding rules.
> 
> Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
> Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>

FYI we just had a customer case for our downstream kernel for this exact same
issue. This fixed it beautifully (I'm wondering if polars started doing
something interesting lately, that nobody else does, and that's why...).

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

