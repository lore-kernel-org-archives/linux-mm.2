Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F4BCA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A986B008A; Fri,  9 Oct 2026 09:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC2F6B008C; Fri,  9 Oct 2026 09:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1906B0092; Fri,  9 Oct 2026 09:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C37F6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:36:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95B081A0399
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:36:17 +0000 (UTC)
X-FDA: 85303186794.07.7F81999
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7CA53100008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:36:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791552975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=67m2j5dcHdzu0e0ViIgD+29dFq5iDPJ6CCKVZnKskqk=;
	b=c45PUMw9oUH1zimkxZU7uyb3LF4kmyz3HO0mjAZTqp7lM7e8XInSt7Tmngx3z4V7M7xHnk
	ZGp7vQ8vyjOwyQQLJ9tbLtkzT5Djr5DCKdl2x0Ubya88CAHxVbTiu9NxjsKief6sISkwXu
	cd2S+v4r1asExIcgEeZXYKCtyDWe1fY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791552975;
	b=lXCmfW0OP8+6BWoryRGqHuJ01Ayd5evh/js+TdZUxzjJ+7HDlY/qAMK9pXteRvwMGCrJfT
	DG/j3g2/Yw9ZpdsJ3e2EsYDRz6x7nXwckRIGkrIfmhaTkJbnJJvYQh2e3wRQyPSp39rrpL
	u69SDz7YRpYJxvgmOEO45gB+eYARnns=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B73B1F7D1;
	Fri,  9 Oct 2026 13:36:14 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C97D1326D;
	Fri,  9 Oct 2026 13:36:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P8nmNMztyGoIaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 09 Oct 2026 13:36:12 +0000
Date: Fri, 9 Oct 2026 14:36:11 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz, 
	ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memory: fix truncation removing mapped folios
Message-ID: <asjr2zCp1BVtfpTV@pedro-suse.tail5790ac.ts.net>
References: <0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com>
 <asjXJZap53yJWMYi@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asjXJZap53yJWMYi@gremlin>
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Bar: /
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CA53100008
X-Rspam-User: 
X-Stat-Signature: 85hfr17qqu63ujaqmeg8h4fmoo5shjmz
X-HE-Tag: 1791552975-791077
X-HE-Meta: U2FsdGVkX1+zO6PrlDF4m0Nn2K3hShigni1zRiyYVfvttPit4KRHtuXN1Zr7fzelzN3cOG8htvOn9H9N1O3/nZzt3ua984raxJIw3hwGRDG580frdnoTJfA1HSzFjRx7FOYp8hHJ521z0l8wKIrmu5+uMiuBRayK22431Z1gDPubQ7QQkfSI1gBE6fZmZtSlVA9XNM3fHdvgf9wotxS0ldA47XYIhpW4f26b2DVRjiBHgC8gho+KaTzAfmB9o2L0MpWjSrTrfDJ1lac51cByqbUCHit0Gb3qSaikIM2vgyVgjQl53EStAcUgfThgFeNuzsJGTWNE2RUuOU8z1bjGi4NGytt5/5wcK4NrhVM88lTO99J+n6c3YnjIe+vEriys9aF2feHZGO1zZ04MBAxmNnWbeiY6H1HGM6BARtS2mZBlneI30wr/W/VtLg1k8zr8TMAp2axmB8kBjE6asByOH6xVPuH477GjPmxfZ8obtd0bbbBdPgqDPXdb8/mIJgm0YQC68EOcaaa+mzXZxDSbFHyasBN70pTpqezkCk4BBxGPXEYzsJjcUaSAs/QUx40lGJEkBX41oXrdamu+EiJJh7YX2Vyy1E296xMLpMZ86ite50EEo8DXFumMPWLkHMgLDnkpOQmaepmICxC2Q1aqfkrqj9MZWosGtWTkZdOaWT47l8BqEAatjaZP5tqc0TLgKwPRHPBa+aWfYhMGClDycRvh1b+icVr2/mfZ+v8+T85d4pGovSEJs9z/Q1j6/7r2ueg67K2e6TpwljzhvqvfW0yvhotPRj1JSt52UajvJeu8t+kToa2xvWsaUf88+NYuyP4uO/9kHtgHm0hCbIHNjbIHqSUHQLA4iD2hvL71Tr0dTEHUTmm3lGLkbP+eSDaZvrI0i3IRQqJA5dcOvxNxbczVuuq16p7tSJS7FSXld2acmFLMH008pdwLuEn+SN/UmHNQmPzwA02+jI9wU9m
 NTlypiHm
 xu26dg70Gj83X03abutt+QphQuJnlrEbo+hCpLAFdwbAUYBe1idAdMjheBPtwU+LBf0eSb2sCQqLd+IXBTloeVCs0idQuAWGSibVUaFx+T+Dj79EstyI7Tt1xc++0TWx0ZynBppeikJSCPmRsn1s13JvCHz6bJ53cHUNmt+xNmxiqY8vs+S3Ybd+uRrM3eD0igS7M/cQwk4iamPtJK/EKjXvn8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 01:00:52PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 09, 2026 at 06:12:03PM +0800, Baolin Wang wrote:
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 1f5d5f7d39cd..0272217ad7b0 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> 
> > @@ -2044,16 +2053,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
> >  	 * to ensure they are still none, thereby preventing the pte entries
> >  	 * from being repopulated by another thread.
> >  	 */
> > -	if (can_reclaim_pt && direct_reclaim && addr == end)
> > +	if (can_reclaim_pt && direct_reclaim && addr == end) {
> > +		/* rmap changes need to be observed before e.g PTEs get zapped. */
> > +		smp_wmb();
> 
> What does this pair with? You should always say what in the comment.

Yep, this is missing a rmb to pair with. The diff I posted at
https://lore.kernel.org/linux-mm/asigKktcrSY80A_2@pedro-suse.tail5790ac.ts.net/
had one in zap_pmd_range(), which admittedly isn't the greatest. I'm not sure if
there's a better way to do this.

> 
> rmb/wmb are generally not needed vs. acquire/release. Are you sure a wmb is
> right here?

I don't think that works, because __folio_remove_rmap has a ton of stuff going
on, some implying full ordering, others not. Plus you'd need to switch the pmd
dereference to something like an smp_load_acquire().

-- 
Pedro

