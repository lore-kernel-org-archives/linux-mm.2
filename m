Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15099E9E31B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BD96B0096; Wed, 11 Feb 2026 10:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF7B6B0098; Wed, 11 Feb 2026 10:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218E16B0099; Wed, 11 Feb 2026 10:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2E846B0096
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:43:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5907C1C30
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:43:14 +0000 (UTC)
X-FDA: 84432594708.14.09A9642
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0DAE2000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:43:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CjX0bdPK;
	spf=pass (imf03.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770824592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jx1hsuuG7ObMhO/uK+TRbv/qG1QFFvi3Ae/jdkXmec=;
	b=lSgTHV7pJTokItQJFqU6T22FXEpvMOL2WMvNvPNN98sYnBof6D7pbiqPms1goaWyExEhfX
	zAU8x9dIy5A+5G12x/HLGYauzXx5GuagyRgvgUeyh8iHEjixko15jMoSvhiTYmkFi3sV6z
	ui3CQvZYhC7RdXf8Cjrp1puAXIe8cMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770824592; a=rsa-sha256;
	cv=none;
	b=6qRXXaJioeptSo3c67KTWLmoSbETn0qBtMBfCYbIg/HrHuRWQ8SFmsnatH7nPDSFX46knw
	6JGTVDLJ8k/3o5racwpCm+jplFY4R8pKKKbQCv45619YE0Nr4kdA6xOGKGr5sFUKZks0cn
	OTqiLFW3XWeuJNGEgOP6N5u0n/rnMoo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CjX0bdPK;
	spf=pass (imf03.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770824592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1jx1hsuuG7ObMhO/uK+TRbv/qG1QFFvi3Ae/jdkXmec=;
	b=CjX0bdPKri6qEk8TbxBjcpctU4GlOVlr5VtFLaFprJGfybIYpizHlUOcFy3NkdHZBASZTP
	ySd8Nz/RavuDDaldZ0tSV+AXB1n3fb8eoLuZ2yrkYNOCHHaSannElXEihjXE9ySOO+HaE9
	OxbDtChymHLYzNaUygfWo2YpL4TrDq8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-hUcKwGwXPeOaG_WdkWuOAw-1; Wed,
 11 Feb 2026 10:43:06 -0500
X-MC-Unique: hUcKwGwXPeOaG_WdkWuOAw-1
X-Mimecast-MFC-AGG-ID: hUcKwGwXPeOaG_WdkWuOAw_1770824584
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCECD1800370;
	Wed, 11 Feb 2026 15:43:03 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 057AA30002D5;
	Wed, 11 Feb 2026 15:43:02 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 492B8400DF78C; Wed, 11 Feb 2026 09:09:02 -0300 (-03)
Date: Wed, 11 Feb 2026 09:09:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 1/4] Introducing qpw_lock() and per-cpu queue & flush work
Message-ID: <aYxxXrG1UVvHUGHP@tpad>
References: <20260206143430.021026873@redhat.com>
 <20260206143741.525190180@redhat.com>
 <aYaEZGImn7qayP12@WindFlash>
MIME-Version: 1.0
In-Reply-To: <aYaEZGImn7qayP12@WindFlash>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: lgp76TpgR0vph7Ym6upQt6M5GciUwpuXTS-7VeDPqak_1770824584
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: C0DAE2000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6fmja97yiyufxrtgbw9c8bqy15g3f1eb
X-HE-Tag: 1770824592-380063
X-HE-Meta: U2FsdGVkX180eZ6k+HoMjUb5jPuSz/LYixJmAoY4tMzH/Lp7QWuFL7hhRp2lPYvv09Z+n0sEAhJb3J/l6r+XRasNnBEU/YpT5Ipq9qMDSm3TOW/NzmH82Vwxs1MYjbAB+SiHa/zRjT7+j6iYx1TdD0mghFw2c6MCyOspBbcEkpzcGd9u4qfB2lv3+nRn394FjIlHLHuw+Apckgxvf4ayox1b0hrcedTeYe5ObCpfLRY+zsQO7BXaNQ1PCnx2OCYEAwfU1QLxApNotClMiq3WCWsv0aLVYROaD9QHOr4BKO7mVUY5Ac/RxZf0Y/73JcGTNWGlPQ++5RpMusfrOoN+W+NH+ISd8FFtXRItuA4BjnxxL851583S3SSKPAgk83g3xhxW+ELNnlI6Eg28BcNmV8UdvSAtscrKKUVQYiIYBXeg4evXHbKD7S+a3Loe6oBMnqs4EXTl6Xk3n+hdLkub8wn/3+/q83AQeLRO+6MDMv6PSkQBCwv0x71VFB57S02N+xBWQ/RamJxj+C+enjA6PqY8IWm3f/Hpuy5EJ+oLy5qPNYPHViAu4wHZ6UoQmlnwfEzXaMyN9IiKCvInaXKm6r1rkWbRcqSJshhWBR0ZgZjWYSoFx5bOs6ovQKof30KcUVz0ftEVFU6xHEyK9yMMh0fo74gj2VQthIM91rM0btr+H08DtEILLmAr3yoBqwiyUkGzMPkdQ7wQ2YEn9r9m/XIsb6mjtsUO/vxJbXvryntZ1c9UrgvcMWCFuAG14ZReJk+Pr5okAwiId7CuK6gXSDI+T1g4yCaIqqxqXXr1tlanyaRLXnragZ9VJ+dGUhkCOmJDBIl7aziFKLaLU5MPzQjMv/FQs8tPm1eCjlzMs2IN89JWiBLwu3ugW1aLel3UGu/A7QNyzngCvIrXgfzenv3xDMzHlDnJJFPcdj42PoPPSJ3TR7k0jJevEWgpcPQM7Xu25TWeDah/UrrHFMz
 i0J0q/e4
 Rm/RR95YURIe5F8S5L55rBh537Lb6VxMcZZo7GkWPyc8l2cU+IWR3G9uRu9OaeKYdbr0Cw9jVbdhti7pB0z2CZGE0A9D++nbpHHCRC3GBv9FzcK0j6cSfLEHj6pvBZ2+2+xb5Ge+IYeIDBqgmi05U1HfuUjjAh3IBjBZJoAZizTlxefdbH7nVnHLy32UXeDcxqTOcNOS6/tXtVaDccDYbw3vZjvbe5XrDAeObO3woKUMuhNq9pHbqCQPgim9bklhXn9LTH6L40Qz/KkTKIF+7Gvy/sn4eKxLQYG5OKLLPNhMGTNG2x2F5tkgHgzDonRw5La7LBB3ZZ6lygDslv0XlTHtegNQfLvE3go5QvkXo+iluQNe9Y7kAAiD/SokYCtOR3d+SfOGHhG8ew5XRhf3oNQL7XadukofrewIac5SeeGxhjHy8ByWpSbJY0ae8nd5dE/yb0s1B92HY8ekftgkb6kkan7FKORrVSCqJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leonardo,

On Fri, Feb 06, 2026 at 09:16:36PM -0300, Leonardo Bras wrote:
> > ===================================================================
> > --- slab.orig/MAINTAINERS
> > +++ slab/MAINTAINERS
> > @@ -21291,6 +21291,12 @@ F:	Documentation/networking/device_drive
> >  F:	drivers/bus/fsl-mc/
> >  F:	include/uapi/linux/fsl_mc.h
> >  
> > +QPW
> > +M:	Leonardo Bras <leobras@redhat.com>
> 
> Thanks for keeping that up :)
> Could you please change this line to 
> 
> +M:	Leonardo Bras <leobras.c@gmail.com>
> 
> As I don't have access to Red Hat's mail anymore.
> The signoffs on each commit should be fine to keep :)

Done.

> 
> > +S:	Supported
> > +F:	include/linux/qpw.h
> > +F:	kernel/qpw.c
> > +
> 
> Should we also add the Documentation file as well?
> 
> +F:	Documentation/locking/qpwlocks.rst

Done.

> > +The queue work related functions (analogous to queue_work_on and flush_work) are:
> > +queue_percpu_work_on and flush_percpu_work.
> > +
> > +The behaviour of the QPW functions is as follows:
> > +
> > +* !CONFIG_PREEMPT_RT and !CONFIG_QPW (or CONFIG_QPW and qpw=off kernel
> 
> I don't think PREEMPT_RT is needed here (maybe it was copied from the 
> previous QPW version which was dependent on PREEMPT_RT?)

Ah, OK, my bad. Well, shouldnt CONFIG_PREEMPT_RT select CONFIG_QPW and
CONFIG_QPW_DEFAULT=y ?

> > +boot parameter):
> > +        - qpw_lock:                     local_lock
> > +        - qpw_lock_irqsave:             local_lock_irqsave
> > +        - qpw_trylock:                  local_trylock
> > +        - qpw_trylock_irqsave:          local_trylock_irqsave
> > +        - qpw_unlock:                   local_unlock
> > +        - queue_percpu_work_on:         queue_work_on
> > +        - flush_percpu_work:            flush_work
> > +
> > +* CONFIG_PREEMPT_RT or CONFIG_QPW (and CONFIG_QPW_DEFAULT or qpw=on kernel
> 
> Same here
> 
> > +boot parameter),
> > +        - qpw_lock:                     spin_lock
> > +        - qpw_lock_irqsave:             spin_lock_irqsave
> > +        - qpw_trylock:                  spin_trylock
> > +        - qpw_trylock_irqsave:          spin_trylock_irqsave
> > +        - qpw_unlock:                   spin_unlock
> > +        - queue_percpu_work_on:         executes work function on caller cpu
> > +        - flush_percpu_work:            empty
> > +
> > +qpw_get_cpu(work_struct), to be called from within qpw work function,
> > +returns the target cpu.
> > 
> > 
> 
> 
> Other than that, LGTM!
> 
> Reviewed-by: Leonardo Bras <leobras.c@gmail.com>
> 
> Thanks!
> Leo
> 
> 


