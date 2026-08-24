Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B291BC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 22:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935B06B0099; Mon, 24 Aug 2026 18:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7426B009B; Mon, 24 Aug 2026 18:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787376B009D; Mon, 24 Aug 2026 18:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2B66B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:03:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C531EA026D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:03:50 +0000 (UTC)
X-FDA: 85137541020.23.43121B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5157040003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:03:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BKR4C7OE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787609028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6umSLzif7YwA3wBurX01NBnFBatASw3o1QKXhBN6wY=;
	b=Fv7503BZYblWOQVZ3XIxXBD/+TJinzGNJ+Te/YsXoKGCuwSwymkHpojI++eso3CEiTSEN8
	PTBMhNT7s4GP514aN8HCeGSYJLIvUXp6kukSBxbe84IRWzkGd2rUq52MEC41E8INBsnGEe
	hywTV3fLRKVtgJqJGkOoQ/CZnqfI3hQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BKR4C7OE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787609028;
	b=ry3C3kDnORM9JRZRG1k6MCLvXYX07iYwkpgOgnzO4CQHmVQzCGwvAGM0Z5t52vYs47NtTT
	a+YZMWFQqEtET31ajzLLnOgGuYnoeJoa9OtWgSf53CdghZ1C21yxad4n7akpLDPooLum5X
	steRW58fPWYxX501msHc8BcwhcZfG04=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787609027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P6umSLzif7YwA3wBurX01NBnFBatASw3o1QKXhBN6wY=;
	b=BKR4C7OEijjFLAlAdxwxXZL2K0QL3eGZx4BNJ2nL9ZDt+rvc6GUYGxSaymThHGxb3yr7AD
	0f+r9sg6C8MPAsIedBj32QY8OZFW0vA5EalJ6kMA41dAEPQ67sEFcBz6s5OiBX6liuUKmt
	RlokmlhRXSlQLwPl5QV/qNTIcpLfSKM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-2Q5ZcZ_7NNupAEDm2vBlhQ-1; Mon, 24 Aug 2026 18:03:46 -0400
X-MC-Unique: 2Q5ZcZ_7NNupAEDm2vBlhQ-1
X-Mimecast-MFC-AGG-ID: 2Q5ZcZ_7NNupAEDm2vBlhQ_1787609025
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c0408254aso2568881cf.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787609025; x=1788213825;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P6umSLzif7YwA3wBurX01NBnFBatASw3o1QKXhBN6wY=;
        b=HLrxyAKLJUVo3AE/9mds/7I/nkqD5pNiFabDfu3GxAWbUBwKFLLP/O3fwOasYzIcr9
         nsippZdlhzYw6d1U4FjlgUnZLC50Y0otMxPtvGUBxB6IN/9V+P9BEZ2Epi2Dpsav7SeU
         c/Nl6ngzQimBdO7ncDO6IAjPapV8EiGJ2CoyZcnhtbUKivuCVP53/8Q3sNxXiYv+pLWd
         YovdsRpCDQ2LValbTR2etsETKQ9D6ZloYv5O6gfKsw13XtaRbMYo3iNMdGdFShcFoox7
         uHXpO8MZTEv+l5U3DmMFZ2hYuyR8eQYOUXeZ+gi2KuEJSScE46GaUpjnhAGXIACzyQ+z
         9ZCA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4PuYLCwGzVPfXlnWJKUrnB5DEQy+rbwaOdZEZL5eUlDrLZBVu7oUQVoEZPX1rHJcs6RYq7cD+mA==@kvack.org
X-Gm-Message-State: AFuF++nCriKWjh19nKjqRRs20qXuLBcBQRlEIu1HVXaouGt4z6dOoalF
	M4j4n1T4UPhdrDr6pp16Y51TIQXangtYvwxCf99n5viywdaaSc7+gm9RMWxVWQbDHDPqbLEMiNe
	2y5ReJdmKVDcrdPoXiAh3nItYEB5x2eIm0IC1SF+GpalC8lfWexqK
X-Gm-Gg: AR+sD10KtvliNNJHVgQM2u0y78y9kPQyTzQDY0sifkms8BZP/DNEnxWaYKKulFllJrD
	emjrdQ2ss6gLZe3AqiDOwuQu/OlM5pBdmtdRY6NsM7dIcRZwjdXKIEWCMGsWQZRUQrkbrp9l3Oq
	vX51UAN9/lVaipTESO7JGpC3tUzd7X9t89aCyA8qpWaYkOO8v9yAB+5OTL7fIxDdEZRpUzTteYw
	THwzx/pVAWQbJiy74xDJ/+7l6q+GPDfTshPR03r4vnJN5r4w13JE+3ynVTf1SAoAOK0Qm4luvVT
	cu8b4jhxUnJzjK4XODjvDxdhfNTHUjMEyjP1sutttkBfceqlmyQ3CSmPiIvLu2gtBHKxG9ZXHdc
	F/gzuu6RNf24r9y3kzjIAc7p5viwX+N24BJPY3pEt0mxt
X-Received: by 2002:ac8:59d1:0:b0:52e:125b:9444 with SMTP id d75a77b69052e-52e2ed0710dmr27174671cf.17.1787609025370;
        Mon, 24 Aug 2026 15:03:45 -0700 (PDT)
X-Received: by 2002:ac8:59d1:0:b0:52e:125b:9444 with SMTP id d75a77b69052e-52e2ed0710dmr27173851cf.17.1787609024921;
        Mon, 24 Aug 2026 15:03:44 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c93a81392sm71344616d6.42.2026.08.24.15.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 15:03:43 -0700 (PDT)
Date: Mon, 24 Aug 2026 18:03:43 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Maxime Ripard <mripard@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 03/11] cgroup: add memory_cma_accounting mount option
Message-ID: <aoy5n82tN7PynPVf@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <20260821-cma-memcg-regions-v1-3-d21b165b8440@redhat.com>
 <20260824-poised-meaty-shellfish-9a09d2@houat>
MIME-Version: 1.0
In-Reply-To: <20260824-poised-meaty-shellfish-9a09d2@houat>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SQswwqhAV3TqVCUaQ-WFxLh74r7jRZqOyXDqinLA91I_1787609025
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 5157040003
X-Stat-Signature: qatizyc8phic8c17s6b3xwhyd4tegmdg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787609028-77119
X-HE-Meta: U2FsdGVkX1+9doBiKgsi/1vkg35o+89wLCj5WQg7JzFxdYg6kOvCfPwWtCebN+ijD20esZwjVqTOUMjlHB74qg0IBNgqdhKa3R6zAWinFsxa6LHTmBbLHx7I7jFkXz0yiVVhs1aqNjFwkQl4ov+2uA1CRTMQBgHveSI2NKEiHhNyOiM6mXRlc8eCMApA4n2JPM/LgRAjRWl/YeQhN5Tsiv17OHEXgLRha4xYPA62vGBI9I5uw8b/IJ+obQ0UJ+m7dmB+6aauvIQapMSdBdYID3JMFmjzEkwNa9auvXwWg/RuW+e9hmwz7vDvF5gZyHGypQnenJ4E1kAVV3xyGOWA1T6+g8VfsXgYripYsulu4a7VJBtgIC1T/8g13KQ5RJV5V3BW4hpk2BRxVPFsJ70FE7tnIzes6D4Wft7rsrEjF+LVgSe7F22Ey3F4Q4E34Ctmei5+w6zLkGqzuYIM6dPC0zOG7H9+86BZu1qBP15H2aiwdP153z8lZcwLVCeSz940yMHz0Dxr39xuD/a7QfWCD++M/HyY5wz7ogDT42XjiQFAlCMhuEYpOUPe4YNz1RU/bzwgpEJmPNckZ/NjMnCcGjwJPA8swQbe4G4teeKYamaddSH3z5jvUiKL5PfQMcQP3MNyjjCG4MxoEWB83KeW8jQLwjEvV87ksh3U1VtY7mdFnZNjKJS0qSobGoPxFvdYFuGN5Wvf03+EzIvt80eoF49xfGPdY+4MkquvVKJb+HUGhPHe4EeR02X0bWwoQiEepjmYg2za9gPKnVRuRjG7i247DNwfTh0UR6TRse58v70ql/EwXq1hMUxPLhfyuGzS3PpF2cZv0dmWYLSs0y9jg1CJOsRwv5q2z4Irz4kGwAIg9NZD0hwzAWNiipo5ceF1ywN0UUthmMsslfiIqhJNPjRqoj82roQLZkf9M+ZKmpplmAGeKMi2mt0NepyLMz0K7CTppYudDK101oNDcyE
 9j5BQblB
 cOR6lc7MmLQacQjGiZy2p1c7AvNYNpQJu1ABQMYTUtcEX4/4t6cdg/PzxVZif1jnVHUivQczEhLSvrbxLS8SydX4QUmJIFuqyjr37S2wTbVOt/4Fo/n5bxKcaVStUeBx7dHySQgObYBZhoST8sGx9Oso6ywuukuexw6U8LG+TKTK4GmtoorR89VpLTV96cF4TyfnUZ5FPe9x6dlkrXGu9ZyzvjppfAEgFuMzDPld8n9u7E6Y59CpENBOjfUnqjGcPRmyRHQ747O3cGeud1ZcJC7doqTclyP8Txz1VZfPymS7Tw3w49stC0P/scr6wpHVxyWUU8+BiCcH3k4idHBuBUww8mRT/w8soV+jWI0bbSJzycxo3YXnTeWogGqY/M53XumnB8IQNBdA9PaPy4VPNcRm76Wd8HtJP16OPcFI/UQGFerrlAVdAM0/9/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 09:02:30AM +0200, Maxime Ripard wrote:
> On Fri, Aug 21, 2026 at 02:56:55PM -0400, Eric Chanudet wrote:
> > Add a cgroup v2 mount option that will be used later in this series to
> > enable CMA memory accounting under memcg.
> > 
> > The option is made opt-in as it will charge allocations to the cgroup's
> > overall memory usage, which changes existing expectations.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 20 ++++++++++++++++++++
> >  include/linux/cgroup-defs.h             |  5 +++++
> >  kernel/cgroup/cgroup.c                  | 15 ++++++++++++++-
> >  3 files changed, 39 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index aed195a71cbf..3dfc13f31a0c 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -246,6 +246,26 @@ cgroup v2 currently supports the following mount options.
> >            will not be tracked by the memory controller (even if cgroup
> >            v2 is remounted later on).
> >  
> > +  memory_cma_accounting
> > +        Count CMA memory usage towards the cgroup's overall memory usage for
> > +        the memory controller, and expose per-CMA-area usage counters. This
> > +        behavior is opt-in, so as to not cause regression on existing setups.
> > +
> > +        A few caveats to keep in mind:
> > +
> > +        * CMA areas are reserved at boot time, memory is only charged to a
> > +          cgroup when a CMA allocation is performed on its behalf.
> > +        * CMA pages allocated while this option is not enabled will not be
> > +          tracked by the memory controller, even if cgroup v2 is remounted
> > +          later on with this option. Charges happen at allocation.
> 
> And what would happen if it's the other way around, ie mounted with this
> option enabled, then remounted with the option disabled?

I meant for it to have no more charge issued until remounted with the
option enabled. Pages that have been charged are uncharged when
released, even if memory_cma_accounting is disabled after the charge is
issued. In this version, it is broken[1].

I extended the documentation line with the fix for a potential v2.

[1]https://lore.kernel.org/sashiko-reviews/aoi_OHVZjsY9a9VV@echanude-thinkpadx1carbongen13.rmtusma.csb/

-- 
Eric Chanudet


