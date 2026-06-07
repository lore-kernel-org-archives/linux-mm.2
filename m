Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D8BCD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 16:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305DA6B0088; Sun,  7 Jun 2026 12:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD886B008A; Sun,  7 Jun 2026 12:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F33F6B008C; Sun,  7 Jun 2026 12:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5946B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 12:20:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95B481647D0
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:20:55 +0000 (UTC)
X-FDA: 84853630470.02.5C39C2C
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id C28FA1A0004
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:20:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UdFnvSKm;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780849253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HrqFsYWh7IgIodQ4s8E7nh3lZZmydvw5nlZkHywms4=;
	b=g8yuy9eUch7oIjXkzmZm0y6Q4pcgo/iBYSKeA4atGnZDMkbKPUzabgml6cov/rpGqE9cMd
	igh0dO9W5kCRqjIkMtdY0rCEXdu584xzsgKSbEVGhq5gTIX7TThCXzQNs9NooK8MIWg5tm
	thHcLitNg37WaHghjWWm6wb3mxt/Wtc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UdFnvSKm;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780849253;
	b=rvVd6G356VfLdTJn9YFjyoDn8hb8HHQEctZ5UvTeNtHNpcxbBLckFmc9E32sKZnXiyQk2i
	58XytMYhHl6Hao21BUKtuewxZk2qqtQFJ7VSjSsAbhBPRnItTRBR50jeS/gfBZkhJxbmO8
	25CeuVMEPvN5Xt2zdrFr8MOUF5vMl/g=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9157d3f2098so443991285a.3
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 09:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780849253; x=1781454053; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6HrqFsYWh7IgIodQ4s8E7nh3lZZmydvw5nlZkHywms4=;
        b=UdFnvSKmb3Py/JCK7sSqZgZehldtMcAaZf+wgk/DaSyoek/CHAFvIARxWuRVPcTZu0
         jmKwh7HuAKz71tTvfoPcCFr4xj4IV1R5MGTeWhDMSeU9UUQHh33Y5JHHamMUQU/ioQfh
         LYr6fF3ofgSzw2lbQb1layVgA/peaW8gGmA9Ckeijek4umo86etjkQ6De7I0zGMXthGz
         CQEH+it0Z+yQiuuZDz8DqYir1vvL/aZgr+ylH++Mv2dUSBpxzEsoaeiyIMJvdp1CJexp
         g8ryGFSfl9wZfzsxri7RXtR7g5sfEb+FH8lGUvHzWffmvstvM/Uqs6eKvWGREcUovSmJ
         1Eww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780849253; x=1781454053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6HrqFsYWh7IgIodQ4s8E7nh3lZZmydvw5nlZkHywms4=;
        b=lcu2DcrRPMfgA3m5DirAauQHEJyVkKzyRB3yij08iIGf9B0uXvTMl6zelvg/UIXPaA
         KhOLkimLrPaYWJouO9iPshoZoosqpaC+Y2vWZ3LFH2VGH6Y457zTnL5pFyfvjbNf3k3C
         adpv0g3UL17cetA1m5NeBL/IIANbXnhQYl4V6rrUmJg4VxwAbEOOG8DJtB9cZw9NkThG
         ihnCq1ubcflaecb9GjzqHBmiD98k6HyL10gJIRNklqrI8LbTO/+Ezyvo0BhcgN/ylSpE
         fSqzjosg2beWo95dyMSj5B24/HxSWtOcgEtlDS4+8OYA0A5Le8biAiJ7guYVJLPDCGdi
         LXCA==
X-Forwarded-Encrypted: i=1; AFNElJ//wRamzBM1Ef42PQOPrC8iYgiUFJ3V3MDhoR5c7rSklCnA9a4Utb39kUZSYYCB1k1w+7EsOPHThw==@kvack.org
X-Gm-Message-State: AOJu0Yzb9pKoULxykvipGk4JkQumsvKKZ4iF1Twxi4X3+G1suTXieL0a
	3Fnq8pOBP+RtrnUvhcSLGQsCQb5T+xNelA/r5SkYE9CYXga2YexUJ06Pj69ru+ski4mKaQgglTn
	qTomD
X-Gm-Gg: Acq92OFDdNIdRpz98GSDwtbDViQon5wo1DvdYFg4LFwGMdBCH9soTyNGR26K5GKuShB
	rc7ZdIRl7acS28lmN0CYLT2wa2cAmSZtYdY70swNIfHYI+0A911VW2xSfwZRitqnNiasefMAjoo
	zrzdldj+JQ0Kz349TX+DFaL0e8/8Sy4j8x0QwWrab528pMDQvUxmGBYkw5VbP9n/nmuU8Bi/ZWS
	prg9i3GdURGCS6b9cL1YANDtSGn6lDLbRmTNnSbGRFSecHU/8K8L8CCSFh4MGg5mNms0pBgUDWk
	pbE5lsjQi56ChfwWOUtMCN5NW8ZF/QvKL7Rj/6nLgE4YusdxGny/e60GelHr905bLARlC5fhYI/
	c4vyKECnlzq5MaLKFXOSB4HADVboDAN/FMtsYBdhk0x0cQB5kRs71Maj6bXJMxhA6w//F9EfQPb
	OGIMAXHNTGhSK4u1KIhMvZcqEJaK8aP9+GJ4vlHI+nAikX9oxCjm0IpQsPbJznkGxkysjpnCuR
X-Received: by 2002:a05:620a:29d4:b0:915:cda5:2803 with SMTP id af79cd13be357-915cda52c57mr287390585a.56.1780849252787;
        Sun, 07 Jun 2026 09:20:52 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm1456344985a.22.2026.06.07.09.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 09:20:51 -0700 (PDT)
Date: Sun, 7 Jun 2026 16:20:50 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, jasonmiu@google.com, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
	kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
Subject: Re: [RFC v1 1/9] kho: split out radix tree tracker into kho_radix.c
Message-ID: <aiWYZhoSOAruIIM3@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <20260605033235.717351-2-pasha.tatashin@soleen.com>
 <178083348873.1648214.11020626647820932506.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178083348873.1648214.11020626647820932506.b4-review@b4>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C28FA1A0004
X-Stat-Signature: 7zuujshyw4ofspsy7cykgmihbdmpq64y
X-Rspam-User: 
X-HE-Tag: 1780849253-197750
X-HE-Meta: U2FsdGVkX1+xbavp8R/4O7YLqSv0xw8XoFJ9TQuedr0zt4uo2n3zvc7oXSx52QC5bShtlc1oZ2k3Krx0k8v15GX6zL5tDPxNLvht+cp6UK4X4HJE953iR2ckkkf4j3MfD4wvcSfkLD3l+zwp8Ex2I84p4WEH+sw04r0cAtl4xG+cnQVm248P2A5857W3A8q6rRG4ON/qseU7rkxY9ZpChjjEW2FN07TaDXrVyhfSKNd/+vu7SH6v67uul/5oeYH9DnZzuch/kB+ShHUSIlN/Jk2gj15l5VaLRU24DlFY5quoJwvevEozgXhey9ZzIF+6RL5fRDVFl5VkaCIKD5Ob8ZwuQZPZ+NuZAZ0yFLPLC5GJS4RAAn6oS6c5yZT3Z5JB2Xf4y27/smdpOkhA0Gju8FTGDMjbCS2eZMD2C79g1RW4YUB0e+b+lZYTB70EPffvs7jBkLyinPJ4R2/+Ra1xAQhB4TMHpuOmAHoNXZ8qop9hYA43tOjUW9lLZUkTaqvl+AcPvxMLGwedZ39uKTclfriVxwz+OytHcGt/sMdnvFw8ynLc0nDd8Li5B0EFlCLrf/TagHciLXnD3wZQe5jahXZ9R9IH6akAenKfey2cztdcKogua3WwOncZRvejr0VNxbe5vhuyJoiJciet4mhBEpPmofcyR4/BNcwx8VmZPZcJHiZJZ9pcJ7EnRm9kt1VjgyZKte9DBQAgxQ3MEQBZfoJnxyH+NSR5Ux5FLRtOxiq9iuJ8O76TleoSrrLJiUJWMn80DzHayjiifLXhBLDKRAPIDPDUmCJXTsmsbJsEARhdD1S2hGbRoSoOBFE0gd1ZubgyEQ71ZG/B3sTggYehGerkhHbGOU1ftHYf941mLKI9b49ZSjbKLz6fEktHT9Ych+UoyQFoTBs9tWoGWSxMcCU3Dlyj5INwRj3dwaMw4ck6KfijuR/vcYkn8rxWAVz19iYKr+PahL7EB+X2h7g
 XOvef9uR
 114utgIYqnmMfAFCZP4sBLeQsyNb/M9BtXxeXxdluCzQevbFIQArtRyHUIOMvxsg9DCdPqRWb3T2GkUIGXzgeTGvbXQSoB7OgE0laA7t6upXnU9k52dk5hzGBj+9SB3BP6Rrwe3ZQIaunNCLr5ifJfF6NvlUfwHUVN6uzkIVbWpVeWb233BdJwR9vwyU5yQCF+56nZ3+9hZZXbvevRwnhH3HUq9IvKajYhSCc9TldLvChvc8ykjsF5176YGL6PrpQVA9rSh2Gpi8b5vcqohJ/VRPowMGyOY+HMrthKahWSn5rSDwNum5+Wso0kPrc8APBQqgYgyegc0HhaAI2ScGLZ50ytUOjbs7bqZ5MBn/bGjmvpOFbjmEvuzBtZhTHwvboCi1JuiT4H6xYB7cQ+Uckapx1926AVrkaAzg1TK0OJcuwQXzQHp+6rmOfgv6Q/NkiOxTmAsrv0N93oq8+lxM5W3tCeQTFpEh9JLbT5SgsMDAIsZdgtj6++Tc+vaaPWBc9ThLv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-07 14:58, Mike Rapoport wrote:
> On Fri, 05 Jun 2026 03:32:27 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > Move the radix tree tracker implementation from the core KHO code
> 
> It's radix tree data structure implementation, kho memory tracker is it's
> user. Please rephrase to keep the semantics clear.

Yeap, I will update it.

> 
> >
> >
> > diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> > index eec9d3ae07eb..a3ee8a5c27a2 100644
> > --- a/kernel/liveupdate/Makefile
> > +++ b/kernel/liveupdate/Makefile
> > @@ -7,7 +7,11 @@ luo-y :=								\
> >  		luo_flb.o						\
> >  		luo_session.o
> >  
> > -obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
> > +kho-y :=								\
> > +		kexec_handover.o					\
> 
> I don't see much value in moving kexec_handover.o to a separate line,
> btw, the same is true for luo_core.o, but it's not important enough to
> change.

This is purely for consistency. I wanted to use the exact same style in 
the Makefile instead of having two different ways of declaring the 
object lists.

This:
    luo-y :=                                \
            luo_core.o                      \
            luo_file.o                      \
            luo_flb.o                       \
            luo_session.o

    kho-y :=                                \
            kexec_handover.o                \
            kho_radix.o                     \
            kho_block.o                     \
            kho_vmalloc.o

Or this:

    obj-$(CONFIG_LIVEUPDATE)        += luo_core.o
    obj-$(CONFIG_LIVEUPDATE)        += luo_file.o
    obj-$(CONFIG_LIVEUPDATE)        += luo_flb.o
    obj-$(CONFIG_LIVEUPDATE)        += luo_session.o

    obj-$(CONFIG_KEXEC_HANDOVER)        += kexec_handover.o
    obj-$(CONFIG_KEXEC_HANDOVER)        += kho_radix.o
    obj-$(CONFIG_KEXEC_HANDOVER)        += kho_vmalloc.o
    obj-$(CONFIG_KEXEC_HANDOVER)        += kho_block.o

I do not care which way is chosen as long as it is consistent. Since 
this series adds new separate files for KHO, and does not touch LUO, I 
used  LUO as template, but we can do the other way around.

