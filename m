Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D17CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D726B00B4; Tue, 16 Jun 2026 16:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725626B00B6; Tue, 16 Jun 2026 16:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A876B00B7; Tue, 16 Jun 2026 16:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 355276B00B4
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:51:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9A4D1401FA
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:51:36 +0000 (UTC)
X-FDA: 84886971792.22.43F914D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1EA43100002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:51:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="gFj/tZku";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUobB4c4LuSlDSioRinvR60+XHgnr1Axh4buGNM4lE4=;
	b=Epv8VpPrkScX9oUQah33TJOvYVQXP57Z1mrkcuKFVulBn2GgHRZ7QR4Lnv7vSbarMM0JuX
	ocdWx3Vr02mOfKu9y4E6BJb1CuFxx9Jd869BaA+vrdirgK+GZTlapS6B+f74EyddMGk3Ef
	pZcvp/EmNovNE7h49U1jbzoCrHuQPDM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="gFj/tZku";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643095;
	b=WXErwFYCh4zFBz1aqF4LILZVPjRL314yEr8PGcYi8SrXuvhhdM1C2cJ9R/58sSJM76C5w6
	w/SvtXdMHvpxq3fzidl+aOfU8OLJ+KSviSpyqCjmiYvrcLNLuLbh0FRghNEMPN4Fc8W5TX
	m7h5G8Zz+ahz7hLbJTPKenIwTYhNB04=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vUobB4c4LuSlDSioRinvR60+XHgnr1Axh4buGNM4lE4=; b=gFj/tZkuGLBn1RILXXmCVhMFjH
	M3zu0i8Gn5A3u1DPTAx0sw2gnbGi9sw+zpW9z5APVS1bmnW1v37pCezwYv6bl+PErKGwbscrfAuYK
	G/ylKYgMfru/o5MmPUGJfdTu7Ln7kZ+y4gvU2QlquAY9kYsrxhcmIIa5rgRd2mmbxvfrtMc7hC+Mu
	DFu8FJ4ZenO+EY64gJu++eP5g7slEI/6mtT57SBI2aF7Wv9avHrfQ2/hbq4AMRAbMbzR1DErgtBTp
	mfuBGf7ZAFtafgWRnIy+DYuYl/T11StYZ9j9nOw/Q0fsaRboCdvQIdRymk925QF3t46ZsVesNfkHG
	5ybDsu5A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZTBW-00Dr8c-0l;
	Tue, 16 Jun 2026 12:46:30 +0000
Date: Tue, 16 Jun 2026 05:46:25 -0700
From: Breno Leitao <leitao@debian.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, lance.yang@linux.dev, Davidlohr Bueso <dave@stgolabs.net>, 
	Qian Cai <cai@lca.pw>, sj@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 3/3] mm/kmemleak: stop the per-cpu and struct page
 scans early too
Message-ID: <ajFFTw6natWGsoCy@gmail.com>
References: <20260615-kmemleak-stack-resched-v3-0-acecd7d7fd92@debian.org>
 <20260615-kmemleak-stack-resched-v3-3-acecd7d7fd92@debian.org>
 <ajEgSI_UiTPU5eIF@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajEgSI_UiTPU5eIF@redhat.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1EA43100002
X-Stat-Signature: 16awpjs4uwnfwd46wtpkjoysgpxeagri
X-HE-Tag: 1781643094-258072
X-HE-Meta: U2FsdGVkX18TnHFPOd2nDe3/cTBH7D2P06NMfGMreeK/cBD1KXZYhF4WWZE4NetwPN3dvqMGkdi8aoK6oko3ADMjFd8yz4pdzBPEtqopi19l2yVB2mHqquHEqUBZVcJsimUZNy9Sa/3jUvuFLcjPYKZZ0wCdMTe6b+IQtKb6T+ioKxQrPlhPt1jWy4MVx4AamDJglr6d/ebSDk/WkVTP9ovWpSbqB2NEFARL8gTL8XFZV9glPB5jqrZIg7c7ZiNyTsZISSpeAWoAJ04xv6sSyvGQgH39NJpVks09G4imonLlgU2OQ/GzLasYHfa+Aw9cb6GrSG9f0pof6opdXnRuGpTF1BKagFR1PWS6rBHVe0wdHAfwMEYEDcHwJDnvzE8c9bTGA9pEMm9BW5SYAG+TYxggozlSN+uioZdM8dQ3zFNoCYDxHYZ+duzgphNGsb7Bv2nIZVkG42nIB4089E9ZBf1ZhWyFPPRaGOJlicrR4UNDPt4DmGglTMalLY4IMkEnBxBY9DpDWKVZhSZphDwGp9pXiBLjC6PLjyBcJil3uqolXhWJ7E3Lde19dSTGoo9tm6rTuTId5TF40Qz+w6+FJ44cU4x2ZyUbWMUSRF/B8soxbarJurET98GrBUfx42+zyXieK0kwMm987gDsmuWBZGzmQhE7t29ujndXm2iMK5CNheIP/qpyozKQoIXgXm4NScxTBi5XXP6gK1Mv+NLa7VV1X6koRr2HEABIAkxPerlIAra2cEXfyLyoueBe1m41alJPMqnOTXK0+41QsmUG3Sz4cmK4DRmfm+Ctch+9ZD98kvJaElTmkpRs41Ue5DY0f5uYSbxX3/Bb/lfy56Dqy8iekxlKS3OvhW38TXXT4n0D2KI7mpOFm1EIlrcwIySpKLSgJAPQJq/ncitZHoJjhWtFVkF5DMPl65stDzz1m3kMP/YVk9IeTYbupW3QB6+AxmkqjlmQaVCo2i/3esy
 /p8zU0lC
 FJ20MdDhvQvkXnuoROE1yzffDelG/gE1tE8TpRzS0mK/fFsv2wqY2Eqf6+5acOeMhd5dZH1zINrWs8uSBWsuJKvuZvKMawlrbbDCkr9aBECZ8Abiqx+VRB5EOdR2h78/DirCgLNOEdVCvSc7up5U1fF7dSpDn9WQC1Z1C09pZrDtcXbY44lRds1pEiGrr46eNdY+qqvQopbP9fgUxWLfuRXLm8891QAB7LRpNo0DR/QSTUrCkBbciVA6DCAypa0VbvKct
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Oleg,

On Tue, Jun 16, 2026 at 12:07:04PM +0200, Oleg Nesterov wrote:
> On 06/15, Breno Leitao wrote:
> >
> >  #ifdef CONFIG_SMP
> >  	/* per-cpu sections scanning */
> > -	for_each_possible_cpu(i)
> > -		scan_large_block(__per_cpu_start + per_cpu_offset(i),
> > -				 __per_cpu_end + per_cpu_offset(i));
> > +	for_each_possible_cpu(i) {
> > +		if (scan_large_block(__per_cpu_start + per_cpu_offset(i),
> > +				     __per_cpu_end + per_cpu_offset(i)))
> > +			break;
> > +	}
> >  #endif
> 
> The patch looks correct, but...
> 
> if scan_large_block() returns true, then
> 
> > @@ -1902,6 +1908,7 @@ static void kmemleak_scan(void)
> >  		unsigned long start_pfn = zone->zone_start_pfn;
> >  		unsigned long end_pfn = zone_end_pfn(zone);
> >  		unsigned long pfn;
> > +		int stop = 0;
> >
> >  		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
> >  			struct page *page = pfn_to_online_page(pfn);
> > @@ -1918,8 +1925,12 @@ static void kmemleak_scan(void)
> >  			/* only scan if page is in use */
> >  			if (page_count(page) == 0)
> >  				continue;
> > -			scan_block(page, page + 1, NULL);
> > +			stop = scan_block(page, page + 1, NULL);
> 
> it is pointless to enter this for_each_populated_zone() loop and call
> kmemleak_scan_task_stacks() after that?

Upon further review, your semll is right, once a phase trips scan_should_stop()
the later phases are still entered and each just bails on its first
scan_block(). That can be optimized away, e.g. by lifting 'stop' to function
scope and guarding the remaining phases so they aren't entered at all.

It is not a regression, though -- the pointless work is pre-existing.

Before this series none of these loops broke out on scan_should_stop(): the
scan ground through every CPU, every pfn and every thread, relying only on
scan_block() returning early on each call. This series already removes the bulk
of that; the bit you spotted (entering the next phase only to bail) is the
small leftover.

So I'd rather keep this series as-is and do that optimization as a follow-up
once it lands, instead of growing a patch that's already been reviewed. Are
you OK with that?

Thanks,
--breno

