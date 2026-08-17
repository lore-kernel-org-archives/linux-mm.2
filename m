Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363DDC5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 21:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8AB6B010F; Mon, 17 Aug 2026 17:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189C26B0110; Mon, 17 Aug 2026 17:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A07B6B0111; Mon, 17 Aug 2026 17:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDA686B010F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:34:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAD951C1C1F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:34:19 +0000 (UTC)
X-FDA: 85112065038.03.8CF1C36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 14620180007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:34:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NsUIgn8V;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787002458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQjvsR0htZRo4CCOSSq4xQt9hCGvWvKnzwfQzV5B36s=;
	b=hE4xQoYLJAL1Re9Yp1LIkC5/jqz315wvxwDteOkR4t02cQ/+hO3JCR0uWTELAKPrGtkuvV
	oDtlYlFVv5yb4plNpR03aOSOUgphuHMU5UtseceDtB2fXT50eEYPIaqK4zGL6es8r9eWTN
	PITV29zxp3+QQdMpn/9s0RPcCHeZxzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787002458;
	b=jCBNprgIGOFFW8I5JbZoL5b5n5DiyaornOkkWUPSS1F3XGhW0yb9NlpbV+YM2eoSs6AFMb
	7cei6bO3usiJINR8hxjEaJGtxiWLa5zrcBl5XLSdgyOGy2qagLICw3QkNr2o/MjKPR86ER
	28swplfC9xxCtRK1K0Dz/Uss98QetRk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NsUIgn8V;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAB43600C8;
	Mon, 17 Aug 2026 21:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F4A1F000E9;
	Mon, 17 Aug 2026 21:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787002456;
	bh=WQjvsR0htZRo4CCOSSq4xQt9hCGvWvKnzwfQzV5B36s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NsUIgn8VbdmC+39Tq3LQvej3JpwRFehOwuE7dvt9ybC6OLwBNz9KZYvARZh5M5664
	 Z1/k3tEEVvARkQmBZO9lNZvJOGoDouks8FeiCaUpb8plCUdIfjP5gCN9+ISyu+E0h2
	 Ufv8DJnbHqn/TRaC928KcRv1sRgQF4/P4jTMGo4A=
Date: Mon, 17 Aug 2026 14:34:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>
Cc: apopple@nvidia.com, balbirs@nvidia.com, byungchul@sk.com,
 david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: fix cache flush when replacing huge
 zero PMD
Message-Id: <20260817143415.60bedb09819d13a2dc0fbe63@linux-foundation.org>
In-Reply-To: <20260817163646.929678-1-sh_def@163.com>
References: <20260817090640.287a9a415da49e3974797aa4@linux-foundation.org>
	<20260817163646.929678-1-sh_def@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: u1a1o3b75ekq8fn19yyqazhbn5i1aj8c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14620180007
X-HE-Tag: 1787002457-111745
X-HE-Meta: U2FsdGVkX19/0VTi4Gom497LLyENXQA1ZgfpFew7uAs5OOHD2yrK8cNPoa91rIqTj+eZ7vlGBuLQHhV3mmj0yXCRDzol/nbkXWkQovWGsrvqriA9Jz8SisMjC2z5HLwnVtXK/3zfK9f4zBas5I/oIAfRcErhu8Mrj23KcGwNJnSiL1pqAXVuApQcL0Baek7mF36ul0WChI5mx6R7Pxa0FD16sM7P2OXJHYGMXBY7aQIueVsc2AaGKb3iOYqlcdJeylJrtTMqo0QbB6EsG/eGPSNDLF2pJnun6zMvjjYrrV6v3y/53YwrFPp62HpFWmWGP9Uf0XPcz2kch1doRs342bjLR4Pq6RZzAUv+Nv85YJ0lUfohZPvRZm5F6U+MDsoXlBEWjbPX3eWLUuIaJWQbbi1RqRwxOyyzCVKQ1KX+bmxpN9cEeCr5SbMsH5QGLeD2XkbmvPH32DL42DDFB0mnYkoNxrslpKJA//6izj+N0JR/2Z1Dv/xcp0n5nZfVXbopeAw7kWt2SNb0YHufgMJuRt3ouewS6r0Yy22L0zv7m/K+cdWR0OCLtd97yuDgUim2Sxncj5EWQ5LUvV1ji8hq8zDnSGvZQuQOQ2EuhsJumqDhONSYRj7xL3FIlzUWcHdWXHH6zmArHRdlw3lPKOhkAqQiGsjv4QZUoY/ZvGlO8Xf3ySaYg6gCrpkgepYq8h33pBOiqRl5zzmAYSNAiU1tG4brM8oVt/ASyzEfH9AecxiHMZ0ChDSXDnAoNWvooqLwm8wWBAe+lt4vt5Rf129LSXhEUls2mq6iYMX73QqTsWVK4YTmbXZfkGiOnNtV/PJzxyD3nWWsz61WkCcudWFfNA7kCAd2iCr8EZ649JSIMn1wpsR9XSqF7bCUTqmH/m5bmElZtwhAmnyXJOOo8jMVHydWw/dpmvyXPK/vVyht+Nr4EqHIwbgb/YUdIvan5dDzNQ53no+TlfCWm4NV8vV
 bO++tfFk
 adsACTIYHhkWxvgHgViAlbjndt5KnJiJs2xIIWN8wtqsbOJYjSULdSXjgS0jr3XQ8HHV1E6c4pCjF+LstOF+h5yF+ikhchUhzMu24ubES3DhjiGy4xANqKAlLgEPTcsNEhwTx0B74BQenJ07Wo5X5vBpRnXRXRO36L5PK8uo/4KPBNPDVyhroiNDBDLpvYxsG2W0XD363GPtDDkk7L79zOZFkMocVcI8Mey9IqgQ6del8xG2srMz6IKjnwHxBIXStXQYKrBggQjllUf5XJip3/8ruhTZzi1DPFnRvtOa1TAFeiOLbMqJW8DPVoPqYlNje0LEl4trrWZvlOQN+TTfQvDlOLWCHyldthhhSnFimyzGt8r9GTSN/QSJ33vpvzAN4o5NOURkqzUG9CdPEihFEZW2ce4G5iqfPRf9U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 00:36:46 +0800 Hui Su <sh_def@163.com> wrote:

> > > > --- a/mm/migrate_device.c
> > > > +++ b/mm/migrate_device.c
> > > > @@ -872,7 +872,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
> > > >  
> > > >  	if (flush) {
> > > >  		pte_free(vma->vm_mm, pgtable);
> > > > -		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
> > > > +		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
> > > >  		pmdp_invalidate(vma, addr, pmdp);
> > > >  	} else {
> > > >  		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
> > > 
> > > Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> > 
> > doh.  It's a shame this actually compiled...
> > 
> > Can we add some speculation about the userspace-visible effects of the
> > bug?
> > 
> > I'm assuming we should backport the fix?
> 
> Hi,
> 
> I took a closer look at this, there is no userspace-visible effect today.
> 
> The architectures that currently enable ARCH_ENABLE_THP_MIGRATION use
> no-op implementations of flush_cache_page()/flush_cache_range().
> 32-bit ARM has non-trivial implementations, but does not enable
> ARCH_ENABLE_THP_MIGRATION.
> 
> So this appears to be a latent API misuse rather than a currently
> observable bug, and I don't think a stable backport is necessary.

OK, thanks for checking.

> Should I resend a v2 clarifying the userspace-visible effect in the
> changelog?

Yes please, after 7.3-rc1.

