Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E77EA853C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 18:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D616B0005; Sun,  8 Mar 2026 14:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128216B0089; Sun,  8 Mar 2026 14:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A2C6B008A; Sun,  8 Mar 2026 14:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E570E6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 14:02:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C9A113B2AB
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:02:22 +0000 (UTC)
X-FDA: 84523665324.15.FC8A18A
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id C0E421C000C
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:02:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UYmM5+o4;
	spf=pass (imf20.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772992940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKtcruYTzK14kYFJK3mP/hRfgZ/eHbQmYEP+7T1CmKo=;
	b=2JfXGoyznCHyx4VoHJXuCJaqv9pzi4s1QchYzNCby7vFD9SI7mbALsblnKdtsnRdUxpKaV
	N/a1sz/k0q4PtiLUd+V+Hq9no3jjN5iRnX1lMpOCRP0vuP5R3a4De4Nw5keX7ymM6iN3fh
	jq0uDieJeUhjCcQzPxm8z5Qn/+gBnbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772992940; a=rsa-sha256;
	cv=none;
	b=J11TxLFaKBOWGnkYQd29k1zN3xy+36I7IC29Jv5oS6hxR9Ygk3ranFqjgp4nu9rZP0iw3U
	wT+IDIe9SM6KmsNkhi3Ea2ECw6dmsEG3fUJFaA5GE8ELCqOAyPiqkuMxyt7eoEYsCBTTpP
	UqdBjp8n7zazuxBoTKB397e1+LC8ovA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UYmM5+o4;
	spf=pass (imf20.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439cd6b0aedso3099887f8f.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 11:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772992939; x=1773597739; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zKtcruYTzK14kYFJK3mP/hRfgZ/eHbQmYEP+7T1CmKo=;
        b=UYmM5+o45cW/q+pPm5yws6ZOIc85EjWSG6GinJcp0l7hg5oDFS9uNLM4+dE9SqDTrF
         YkM0n2pJR5sdKKKkUxy5PN8+mJOuGM1pWHW4vPpeMeTXRRDbbevWh1vxeT62/+KCgm7I
         IydIt/cUQHXhbalRckZSmKq9beC1NX6LEmeOqlT1E8OCno/8tJqNR+uyHQmnsplvXHKT
         xSy+HNolsVSBkp1rXvMwiQb2F2Hlwa9khoechslUXf0KK6wP8vWRjoh5wqpuu1C5KSZh
         KrsyOl4a/Osh7qqlDkHfzq2V/EYDmupIxfkPvCMNzKwGit+KOY0piCQJJvfbMEk5Bf6C
         D/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772992939; x=1773597739;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zKtcruYTzK14kYFJK3mP/hRfgZ/eHbQmYEP+7T1CmKo=;
        b=QwZ74AJYt1+iMtNlQnmA3Dhf2/GVCVMahDzGAUJ2PkMICb2BT0+O4xJ+rYtYKAjGpX
         u/n3gXIhbhzxUEzjnW3cS5FcIIF8f7KmaPz2dW+cCdAI6Dzt6Ku7AwfoP6yb9wK8gF+4
         wXhP4gryQ745519MmuI/iluOfJgE+6rQmWK9yRiV9rZmsyzuj3epeLbTZ0td5TUarWU4
         5gF5ruFxD9J1Q8rZNoiy9is5b31YO+XAxmKEux33duoJ3TtfNpgQTtlP8Y3uM21V80JH
         I5EVFNw2FxS8kLarMI87fCoXo7ByOkILnRug9iA2pUTVrFkEqTceMbGtxeRBTZVK7KtS
         Q1Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWZTP/iNHv8WrBiUKlj46a+gzX9kkTOOqXTGkZpZUHJwj6eyl7/u1LtR5KaO5gmpQ+yAHGJGUZttQ==@kvack.org
X-Gm-Message-State: AOJu0YywauQ1fcVqj495y9WbD8s0tLk80oMYe9as3QZPpgzh2XEklVuG
	eCOT3uVHhG01jZyalTMvNoQk7u1Mg7QUycv1ET44mOc9aKIFZiEu1Gc0
X-Gm-Gg: ATEYQzwiXi9LAfGtnRsAfLPlyl+hd2GL0xqOvtNKpkSfuP8qNILz87V8dUvoo5ZkOyP
	obuIpSDEktZDOAJ3kmEj2ct657jQjl2P1byi+mwpFBypbLyLyHhrPbTJegHe1LdfwFOYWQ0O0my
	HTUT9cOLHVlR8e+8/c060a7K0eS7rukVWKsSomyrZvYcGLmF1Mjcr40nIWgq0YklJ0FNZyvg3U1
	/hsnCZlPYUf68JWWa7MajOSBuPEgYwCbLFKaxyxsfTsNoP3SS3PpUBuThoEjK2ACFvFFbaEC2tk
	mkVITt2w25pIGLL/RMd8MrkmZagtBYSl9qh9Vc45ovnmKyVApAKYphn8LFuQfPeKYkTgyfLbFys
	UihsU+BtGy9tnbc23A6SQPnPizWdSpx4vOzfvpfR/fryEuxihuz7AqAdXwEEnqfP06cf+X7oPgH
	no7yC1OdeW0UHT1hdJbyUpIwpCLv2AKGfmOPU=
X-Received: by 2002:a5d:588e:0:b0:439:ccd7:cde1 with SMTP id ffacd0b85a97d-439da65c413mr14710906f8f.14.1772992939024;
        Sun, 08 Mar 2026 11:02:19 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad97abasm18039839f8f.10.2026.03.08.11.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 11:02:18 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
Date: Sun,  8 Mar 2026 15:02:17 -0300
Message-ID: <aa25qVYi67f6IyjP@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aabC6ScPN2_PyPY_@pavilion.home>
References: <20260302154945.143996316@redhat.com> <aabC6ScPN2_PyPY_@pavilion.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mdksujqxnk9o6n6rzwrmfgg6tz5usokp
X-Rspamd-Queue-Id: C0E421C000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1772992940-404144
X-HE-Meta: U2FsdGVkX19W6pNoJa9JkGgZfuyjkVtr4yhFDrP4H3eePmyytEShmYmvxmmlck98Hwtx79N8Nd5Sw/uYnoDHfr7CMZcgEtW+U34MobnErM6oVPceyVXIDRiQ1adq9DDXwCnJUUCzxHNomXEcBeTU/3d1aFoxyLGZ+SjhgD1Ptm+MWV/Xdy20E9AOjg9ujMhOv7pds+aVDw26qQgcnynxK4rOZPSItIaykSGylQWvCjBgAVNbiDMgyTc1R0LymAidZTKECkAya0V27R9ZdkcgUFCy4ihOq9We78z4hdkqpdEXVtDEcf1OrXgX8tScW4MTIm25pT20dcMN/4/UZVF9jVbG1v9Au+JhHX/vvDlBcuhB6o8A8inJ5Lfcbb/I+jc9KtKrUckvyJK5efsuDyKA7BnJTu0isRW0Ex4mcaO6QfWWJRPTn3HmO29pRZlmQCVe/bgxdE1RAgHOcgdyc8gMUiu7upgrx40HqsqUH68nzOSXPJvlhX3qL2Natowou4+Z/9Zd5+rB4J3g+LY9GYTR9YiDg55nGaHTtJkI1kV/aUFd2exd9vRkFBYPfg8dOWifFKHawxMSdP0w37TJ9uIocVLV0vgMLjBtLPxjgVLgtvrPQIldrHojhphpjruLSbFlJ/DGHtMTEzZ3ts+qFztSjjwU+NFQnseNqtCmse3/0wpyx1G6ttJkkSrYcdhn+J20pHBrB++7Yq7Fbo11icp75nT4mIjYuC07NXKfy4W3J0qS5hrdMoEP/DtntFu+NcV74hzO3WuZJRWlICPdpnSvqCv+eYSnooyZeRY6rP79K65+YmFa0+8unf/ZWg1N1AsZOpfv3EhSJG6QPWb7Kz/akvxkgAv/gJc98CA4pTqqDhVy8rGFSP+Zo4B3Lv3pNE75WeYaUwo6tYQ/wUk3Uar21xhZ/FHxBlgkFrIVZJ7euGyLOQJr4tY9OO9F7rQ2L8xWUt5Ve0HmEzdJDX0EzcX
 w+g1Jvet
 cI4F4RZ84ogU6C2AA9fu+u0K8OARhuss3b8WVOZ3mhvNhW8IRP9ZhJi08fHuZPZFeXDDKB5+iM00QkrErYRKuQhWBmNfSk32kARBCZ8Fkshoz0VAqqxliTs12myVrTIXCtTAiS6vV3OPyGnIPMzi8kiZlZ31E37BHN2h6LN0FT+zut+tFc2YbD86ctORExEAbWBK1UKwUhYl3Qndes3N7TNyg0skmsv6nAWYblzh+PbTiETVQQyfFShg2eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 12:15:53PM +0100, Frederic Weisbecker wrote:
> Le Mon, Mar 02, 2026 at 12:49:45PM -0300, Marcelo Tosatti a écrit :
> > The problem:
> > Some places in the kernel implement a parallel programming strategy
> > consisting on local_locks() for most of the work, and some rare remote
> > operations are scheduled on target cpu. This keeps cache bouncing low since
> > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > kernels, even though the very few remote operations will be expensive due
> > to scheduling overhead.
> > 
> > On the other hand, for RT workloads this can represent a problem: getting
> > an important workload scheduled out to deal with remote requests is
> > sure to introduce unexpected deadline misses.
> > 
> > The idea:
> > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> > In this case, instead of scheduling work on a remote cpu, it should
> > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > work locally. That major cost, which is un/locking in every local function,
> > already happens in PREEMPT_RT.
> > 
> > Also, there is no need to worry about extra cache bouncing:
> > The cacheline invalidation already happens due to schedule_work_on().
> > 
> > This will avoid schedule_work_on(), and thus avoid scheduling-out an
> > RT workload.
> > 
> > Proposed solution:
> > A new interface called Queue PerCPU Work (QPW), which should replace
> > Work Queue in the above mentioned use case.
> > 
> > If CONFIG_QPW=n this interfaces just wraps the current
> > local_locks + WorkQueue behavior, so no expected change in runtime.
> > 
> > If CONFIG_QPW=y, and qpw kernel boot option =1, 
> > queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
> > and perform work on it locally. This is possible because on 
> > functions that can be used for performing remote work on remote 
> > per-cpu structures, the local_lock (which is already
> > a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> > is able to get the per_cpu spinlock() for the cpu passed as parameter.
> 
> Ok I'm slowly considering this as a more comfortable solution than the
> flush before userspace. Despite it being perhaps a bit more complicated,
> remote handling of housekeeping work is more surprise-free against all
> the possible nohz_full usecases that we are having a hard time to envision.
> 
> Reviewing this more in details now.

Awesome! Thanks!
Leo

> 
> Thanks.
> 
> -- 
> Frederic Weisbecker
> SUSE Labs

