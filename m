Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3004CE7A8B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B41A8E0008; Fri, 14 Nov 2025 03:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066168E0002; Fri, 14 Nov 2025 03:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96538E0008; Fri, 14 Nov 2025 03:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4FC68E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:48:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A11687FAE
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:48:20 +0000 (UTC)
X-FDA: 84108585960.14.EA0016D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 198A1C000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:48:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ho4enqty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HsvVl0bC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ho4enqty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HsvVl0bC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110098; a=rsa-sha256;
	cv=none;
	b=bdP403AESzrYTjVbPfqvvV9Q9BHDFvRk4nvfnrJ/Fd0fDhgd8Bbt4e1f/DN4ZfiZKhjUgI
	LM5LZo4JTqxRbKmHbaWzxS2e/TmZUpLNGm1Du4rW6Cq9wCI0FSrLplJErIH85y77XL3MLE
	hZoP79W/V/l1i8tv26DPQsm2jZyPUTY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ho4enqty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HsvVl0bC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ho4enqty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HsvVl0bC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NewmV1pcDRKaQJIMUZo/MiTJQZGP+1ogl/0KLlMvZg=;
	b=djz/flrC0qaOoKm7asnDTHil/MrC6884olY6D4FyubeMl/QvTu5wV9rG9Rqx2ByAHR8SCt
	h0dP5/xz44XHe84AMMTsEApXXZdzY2bZlx76GuGMJzkQp+ylucER4ccF5a2uAB1IhNe5k9
	GAtwQf+Glkd0/9qWhpL8E9sc2b1ACow=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1E0581F391;
	Fri, 14 Nov 2025 08:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763110096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NewmV1pcDRKaQJIMUZo/MiTJQZGP+1ogl/0KLlMvZg=;
	b=ho4enqty3nkFp0hbRfLy8VUI0H4OOw/xm3G7MPvC+YrDIMw2wXluMTP0oYeycDf3OFJA6O
	3dgyexc/9pw+jIhrDpDMjF/mpyarhpFoUPY6a3j9/bdjXSVpTVfQYoIFQwMoYnBfIidZa5
	eyugQI45k0GRdIIIBNO2P5s9YUaXpdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763110096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NewmV1pcDRKaQJIMUZo/MiTJQZGP+1ogl/0KLlMvZg=;
	b=HsvVl0bCZHHZ2oHzggJbblAZniayaB0mjhAn7R3i0UoXoimiTcqqA3YurAndL8yL9yRm0z
	qUeWaAcJx3AyuTDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763110096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NewmV1pcDRKaQJIMUZo/MiTJQZGP+1ogl/0KLlMvZg=;
	b=ho4enqty3nkFp0hbRfLy8VUI0H4OOw/xm3G7MPvC+YrDIMw2wXluMTP0oYeycDf3OFJA6O
	3dgyexc/9pw+jIhrDpDMjF/mpyarhpFoUPY6a3j9/bdjXSVpTVfQYoIFQwMoYnBfIidZa5
	eyugQI45k0GRdIIIBNO2P5s9YUaXpdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763110096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NewmV1pcDRKaQJIMUZo/MiTJQZGP+1ogl/0KLlMvZg=;
	b=HsvVl0bCZHHZ2oHzggJbblAZniayaB0mjhAn7R3i0UoXoimiTcqqA3YurAndL8yL9yRm0z
	qUeWaAcJx3AyuTDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC9B33EA61;
	Fri, 14 Nov 2025 08:48:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TxvgM8/sFmnmKgAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Fri, 14 Nov 2025 08:48:15 +0000
Date: Fri, 14 Nov 2025 09:48:14 +0100
From: Jean Delvare <jdelvare@suse.de>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, David
 Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/cma: Remove CONFIG_CMA_SYSFS option
Message-ID: <20251114094814.3b2efb09@endymion>
In-Reply-To: <20251114010928.151974-1-sj@kernel.org>
References: <20251113145636.731a24e4@endymion>
	<20251114010928.151974-1-sj@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 198A1C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: m44x4grif3r5orizoe1pq8fq1zm19o7g
X-Rspam-User: 
X-HE-Tag: 1763110097-409137
X-HE-Meta: U2FsdGVkX1/HXljzrkuFgaHVVhHahxHUwsM8S93OiHIUV67jmcJVeKZynjVFcCJ7UdvXauLTmWh1RhhGwiuo1M33ohB+S2AaFhlGGYZD6BK34tnAanOuYZ/Mns+R+xTKQnSpHlScPzr49ARgRFY4LbLZs0yy+2hpGhsLxb67YbWbxFn7V0R1/GJUFwyNvuehWYBxRQPf5ONtOefFUoU4pG5Zx2xczx2HXMykbiTWDlWsZeG/JwcP7mC1rkvixUstnZfirp9fxZOZ6NqFKdmN5h1eHY1l8LAeuXKGnOBQQiQ55dfSWcYHwPapW3BHTbo1dlenWrmo/YRLa7mVjTQ4izZZeEuQrpbHO/GEzfGr3wRnVAoEtai9T3dRuInP1jG0dsKFfXtHuJqtToN6kM/G6CHK5Y8DId4vcubVnJ0aBtF74Dso1LKd0+tUYcSs9sLGQW+SnyK7jDUi+0kiRtX3MHVve4hoBE30yrNixy1LiOxKsao7Af3EhSpdOYeetadSIqLsIfuUilkieQtRfDtkp7HFH43i/T5Tcy094h/ktD2evhrSS6Cko77PjpnvpcWabAkSDgXP6PnqnfWniC+zajE3Lvr23bwqzcn/jokNvQyphjocyTYSpsS+SkdUyjgNTte/EhfBG2iH3GpJiWWGWZ7eJDlQEAMkiWGMkB0f9DMPuSC+IS7f7a4MQdiy59v9cJ+/K13NiOrQEWmzaEtJjZr3jdjHNxUGLebH4Fz68ffIv3qxAvylfU75/2kZj/xHQrbzBtD8NIrc5PXDUeZ6hccI8oWrtOhKGNzX0u3NYwLLydrTMkl6TMdeaAyQSy4QJk4ZFH6e8RyQW+b/xGaxWBTpJnkb1b+1bY1Zk1x7GYpX9MDqeG4wzBoINLeS0vJuJmbgX8HpdsvzntL/3KO6l/IRqhrzO9HPucdBHT8oB8LS9IULtWJBEBDoeFN5Scm6Y+bJTs+Ogxyh0GthqVL
 /cxt5E7g
 nHC5bE/kybr8wTVMG2zbkzkO1b+R6Jv1+Df6t6xeWWJTk+hOvr1FBfBgOzD7xJza/d70FT6SuYBsFsBDyMuvgGwilRec/3kc58x7uOHY32UogbYKFNigCiLeedGfGuf+Pe+cSyPTdoUWOb1IuRPzr1lOpGIn7GXDnMyXANB5AIWjhZAFr6Pdt5Tvg0N2Y1q/wl+6fGzYg4FJ3E0yuozfUV44KW7rRAbc7TRaD3hS+aVcFo4tNPwjdBd1d2ahJW35HR3Tqz8ZGalYkVmHSBS9oQpsaehiAbchSjadDpfVw6QgldbOrYMxNOD20pmxN0Tq9dNvS5xs/UN0GVhV8QvsceYtD4E8VTaRYIy4Dm8QnyVaXRP0mbYEopFWRmz1RQQ66M1C1rR5AQFa5GVqtQylUgBn4QQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Seong Jae,

On Thu, 13 Nov 2025 17:09:27 -0800, SeongJae Park wrote:
> On Thu, 13 Nov 2025 14:56:36 +0100 Jean Delvare <jdelvare@suse.de> wrote:
> 
> > The sysfs interface to CMA has a marginal runtime cost and a small
> > footprint, there's no reason not to include it in all kernels where
> > the dependencies are satisfied.  
> 
> Overall change looks good to me.  I have a question below, though.
> 
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > ---
> > As discussed with David:
> >   https://lkml.org/lkml/2025/8/6/371
> > 
> >  arch/loongarch/configs/loongson3_defconfig |    1 -
> >  arch/s390/configs/debug_defconfig          |    1 -
> >  arch/s390/configs/defconfig                |    1 -
> >  mm/Kconfig                                 |    7 -------
> >  mm/Makefile                                |    4 +++-
> >  mm/cma.h                                   |    4 ++--
> >  6 files changed, 5 insertions(+), 13 deletions(-)
> > 
> > --- linux-6.17.orig/arch/loongarch/configs/loongson3_defconfig
> > +++ linux-6.17/arch/loongarch/configs/loongson3_defconfig  
> [...]
> > --- linux-6.17.orig/mm/cma.h
> > +++ linux-6.17/mm/cma.h
> > @@ -49,7 +49,7 @@ struct cma {
> >  	char name[CMA_MAX_NAME];
> >  	int nranges;
> >  	struct cma_memrange ranges[CMA_MAX_RANGES];
> > -#ifdef CONFIG_CMA_SYSFS
> > +#ifdef CONFIG_SYSFS
> >  	/* the number of CMA page successful allocations */
> >  	atomic64_t nr_pages_succeeded;
> >  	/* the number of CMA page allocation failures */
> > @@ -80,7 +80,7 @@ static inline unsigned long cma_bitmap_m
> >  	return cmr->count >> cma->order_per_bit;
> >  }
> >  
> > -#ifdef CONFIG_CMA_SYSFS
> > +#ifdef CONFIG_SYSFS
> >  void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
> >  void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
> >  void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);  
> 
> Why don't you check CONFIG_CMA together?  I think that makes the change more
> complete and safe.
> 
> I found there is no file that can be compiled without CONFIG_CMA but still
> including this header file, so I expect no real issue for now, though.

This would actually make no difference. This header file is internal
and not expected to be included by any file besides that CMA core
itself, so it is assumed that CONFIG_CMA=y whenever this header file
is used. If not, then things would break already, even without my
proposed changes (due to cma_areas and cma_area_count being declared
but never defined).

-- 
Jean Delvare
SUSE L3 Support

