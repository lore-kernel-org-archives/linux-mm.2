Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B4CF513E9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 01:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137B16B0089; Thu,  5 Mar 2026 20:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4816B008A; Thu,  5 Mar 2026 20:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5086B008C; Thu,  5 Mar 2026 20:48:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCCE86B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:48:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A760A1C32E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:48:11 +0000 (UTC)
X-FDA: 84513952782.20.6D85DDD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9E961C000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:48:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ikDIS8RE;
	spf=pass (imf21.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772761689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxf7FMyoG874zmp11MoqUtyQvevQU1A2APIoEt2g/+M=;
	b=utJ59kDYbmcBjtA5QxHrZvk7HBYZFwmfXszYHuvcxNGr1RvAxuMbIOU8xAYm/yEoVQ/yUs
	jXSQR2ma50427Gt8Ere+I9d6jdYC4mfdrYj9a3S8912CLmbAklvoLlaFcdEEXIGsEFmnQb
	T1L7/0i93jWgHNHN7j+1YwZmzHS0fFc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ikDIS8RE;
	spf=pass (imf21.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772761689; a=rsa-sha256;
	cv=none;
	b=Sj7y1rqbyyyRg99nzcKzKIj+U5iGGZ+vQPTm/76KGTCbxilrNtQGCJ+E2XoOicTEdg1E6y
	CMKGKx3cJh1qMM+dwyJXz5MVpU3VjUzxfnqOwhQt6Hw7dtDVBqyZx0ibG94X9LTTPWt6d8
	mCNHkWZ2H8CIRcPdfzLDYBL5KAw8dos=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772761689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cxf7FMyoG874zmp11MoqUtyQvevQU1A2APIoEt2g/+M=;
	b=ikDIS8RE0OAakSIg8SYaqO+EZeVh9Z2AovPPRjvH0Z1KRgXy1y0gKfzb5efDAjk5GQ1I/s
	eEMfUUJGFHyFQ+gu7P3EY6YR7UQUgWdVm4iR1qbVDx3ak1mWzfHzBxkauldESWtxAVzvvd
	NmmPkojF60Lusd13qrbHDWkadssf2fI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-sDZu-UPOMQy4Rs3ZPQLmHg-1; Thu,
 05 Mar 2026 20:48:05 -0500
X-MC-Unique: sDZu-UPOMQy4Rs3ZPQLmHg-1
X-Mimecast-MFC-AGG-ID: sDZu-UPOMQy4Rs3ZPQLmHg_1772761683
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2798219560A5;
	Fri,  6 Mar 2026 01:48:02 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 645F33003E9F;
	Fri,  6 Mar 2026 01:48:00 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 396B84018D584; Tue,  3 Mar 2026 13:02:13 -0300 (-03)
Date: Tue, 3 Mar 2026 13:02:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
Message-ID: <aacGBc9x+zn1tluU@tpad>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
 <682380ba-c8f3-4023-928c-2152e934f8db@kernel.org>
MIME-Version: 1.0
In-Reply-To: <682380ba-c8f3-4023-928c-2152e934f8db@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: yNQ0IOPfbf7_CVlX_zzzXfbkV1FEugJmDfV5pKAr39g_1772761683
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9E961C000F
X-Stat-Signature: 43xuuqqt1sa6fjnjbjn1f6z5p6qi87co
X-Rspam-User: 
X-HE-Tag: 1772761689-461346
X-HE-Meta: U2FsdGVkX18kkJhEgR/TzbCjpU4CZcyedN6CvyRzD1eA7tHZk+LfmU/VahoSG0Di/SscXm3BOapaDIRTRVwiiw58Gwu4QnIJlyng1N0KsKKk9+SCvckryPX/mGAYoD3tnGXUFyhtkt3ewzTPE0Chd6ONKBxpIUqpZJ4nrhsOCHIfm8bRvsz+ATT/ygiH5ezu4gGe5ocQhNnX0E6e3ZOAcab/buuFVBEJuPn18o5eN2ZB2h3kV/PMASFhg0M5/ypjv1sJpbutIT0RKvgdoepjhhbWRH/lkgGPd8n8vjvKOKc3tFxa8JcXTWDXlyXTCy975mi9RyxSOKCi0526Ct9RET8peYGC11pi6CDvs6PTCF/eJ2FmYpN4x1UIRljf1dJ/7iYxOd9ut9tefwwOhvrmC7E3B93LtKVm1vuOTLO1JomRK6GVY+p0sQ0sXlbDOyoMqL2zTnPgHvG+xfg3OzpauK444b+FZS+SuQ2pHg4cHckTJnWqyrXQgOIF99XIgBkcMAlihJxDIJ4kqDXZsbXxo9EugW3p+7tVxAOaxhGZiafHzP/2Em3cg3bu5+gxEqAbjH+I60r5DhVdyRsNuEnQynYAEWO2r5e5ECqjIGomJotJHVAUkwlw7DvKmM/ClBhsvgX5H7KLK4T5E06sMEA7jx/zm0O7i2JBinbI9QRt5JkG3zfkcNc2fXYQIPtTqsgwRVicHxRoHAS7vHvrrl9zC2+XJgGV2rjLMev30cX4rR5yNci5VQc3LFs9xsdCziG+bMTErEOqN03/AtO8YxSshzVwRCm4Jf2d2ES6LE7Sk6d30orPGbuaHtyc1PWvhG79gJpAIbkfyuHJhIVzgvn/pdYo8Sx0H3JI9XIirZDg59KRax0WgUtF+tjfIPePa6PZNWx2wW1SvEDuBvEF6IlO5tFQuh0S5uH+Q6d0zzUwc5ygxKPzEDLP7B40/AEuwAa7yI4lD9a7n+6jZHTH8lv
 fgOX7RHb
 kHLowRmu33gl4uwmzzF50ecqqZ2rGdfh4YmBcP03qYvHmpV7cShlztdQEFuTDkp7I7rcumA8nUwdEtqwwv+6sV8o2fai6XZWAoD4vRDjNPOgbh+bP9620NM+9f07+QRxHCBhnET9NgJivVyQj/C/QGpmhZn0QP1MhJgOYVdrtTPaHdzMmix8m0eDUwYsWNYUUaMQq3M3FJW5D0eFrXtOF68WmKQXCeE971AqB0ewhuvThgZCKtvpbzdfrOpz2d4qAV21nSP89Rf959oq70n13tMt8rARpK4KO3P0xvtw9n6CErd3mRTZb9cqsAAm1xMvqiXYCJ+rqTQMkgjkmQveSD5a0bXJv+M5v7ip7t4cHb1Limk5fqUsVXtBqB/OE7SGFYdg8Yb4dLqCZq1uQTkS4Y9w7pdnIRVE6D2GuZ20LeEoqtL62e6feH3uYGl7ciCh1+jVMXny8RnopvIHVcKlHmME+zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 01:03:36PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/2/26 16:49, Marcelo Tosatti wrote:
> > +#define local_qpw_lock(lock)								\
> > +	do {										\
> > +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> > +			migrate_disable();						\
> 
> Have you considered using migrate_disable() on PREEMPT_RT and
> preempt_disable() on !PREEMPT_RT since it's cheaper? It's what the pcp
> locking in mm/page_alloc.c does, for that reason. It should reduce the
> overhead with qpw=1 on !PREEMPT_RT.

migrate_disable:
Patched kernel, CONFIG_QPW=y, qpw=1:    192 cycles

preempt_disable:
[   65.497223] kmalloc_bench: Avg cycles per kmalloc: 184 cycles

I tried it before, but it was crashing for some reason which i didnt
look into (perhaps PREEMPT_RT was enabled).

Will change this for the next iteration, thanks.


