Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A604C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CABB6B0096; Wed, 15 Jul 2026 13:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A18A6B0098; Wed, 15 Jul 2026 13:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BAE86B0099; Wed, 15 Jul 2026 13:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52F996B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:47:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB5A31401C9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:47:58 +0000 (UTC)
X-FDA: 84991744236.10.6F80906
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id AFEED20006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:47:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5VUWfzb;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784137676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIVygPSmRSWtd96RmEBykYqblePCOKqaKqCbFyUwsMM=;
	b=gQL4Kwu64TQZQsaqmNzG72NvsoxgbI12wqUleZublo/RO01I0P6F1WofFjBYXVsHVoVEXt
	BQXIk/vJ1eMQIHz/DF0aHpTlJ/Ed+wME712fPCRWUnVQ00wMaxJ7YZUOyko4dlUGyW2Bhn
	QmTMHjCubkHRKhWAM9bAYBMFe5/blw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784137676;
	b=FFRSvuBu6ViltXoBF/4RJoo2jRTTwAXDqJwiGR/zpTcvzR3If4ImBXRbWFIcqSXLePrZ8T
	Cqt16WDMliPfi4dtn2n2C+n9y7yHk9qDdk73c8WVmH6e1yWyczFd7tPw91t7kywzX0SacA
	0Lk+jDgr5+GWkLEQkdYVruCVgLa+gqg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5VUWfzb;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784137676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIVygPSmRSWtd96RmEBykYqblePCOKqaKqCbFyUwsMM=;
	b=E5VUWfzbuwCymsOZ5D34RTrQqFootkyAzEdSSFk9IpLAH3aXbe2Qt/xMvfyhtefMr7CefQ
	9h8vQrEboCEEv6eFx6ShyVHlCLRqJXlvZ5AGwCg/eXF6lAD5aN/e3S8sWMLv52yL2xcTub
	x5Citp3hsfbShOewrbWWdmnAFNr58nM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548-QVSUtwD9MmKUJTfozln6hQ-1; Wed,
 15 Jul 2026 13:47:49 -0400
X-MC-Unique: QVSUtwD9MmKUJTfozln6hQ-1
X-Mimecast-MFC-AGG-ID: QVSUtwD9MmKUJTfozln6hQ_1784137667
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D79CC1955F7D;
	Wed, 15 Jul 2026 17:47:45 +0000 (UTC)
Received: from fedora (unknown [10.44.49.164])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id F37061800480;
	Wed, 15 Jul 2026 17:47:38 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 15 Jul 2026 19:47:45 +0200 (CEST)
Date: Wed, 15 Jul 2026 19:47:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Richard Chang <richardycc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <alfHuSTW8sPAl9l3@redhat.com>
References: <ak5-qwmpXrYi5md6@linux.dev>
 <20260709072231.3163082-1-richardycc@google.com>
 <ak-OyACkE8lLaRRS@tiehlicka>
 <CALC_0q8O1uw18aWM8w8be60TxW02Os90AKSOLFoqubYAbLjkrA@mail.gmail.com>
 <alCQ28gBclWOFF4_@tiehlicka>
 <CALC_0q93iheF=Y36SSTg-XCoKgHrhxk88LqcQkDd-O3ymMVmxw@mail.gmail.com>
 <alYqVPEyZ2ySrdAm@tiehlicka>
 <alYuKYnHgAaOFz-z@tiehlicka>
 <CALC_0q_9DamACOEyXeevWvq-6D9dQZ6NNt=iBN7gkOQRM9xqfw@mail.gmail.com>
 <aldJnz0u1YyoCyGr@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aldJnz0u1YyoCyGr@tiehlicka>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: lSd_tpm8-U3O6iDAr_IlvVYnuBgphoeACdNJ_0Czo3E_1784137667
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFEED20006
X-Stat-Signature: eyc1gdyizxsu3x8aodjgqyuxz3i995ny
X-HE-Tag: 1784137676-373843
X-HE-Meta: U2FsdGVkX1/SJh6105FA1WoCwuREdPWyS5RIQhR1wfOIAAJO85Mjg+ypFKOLisoOHObCWFn/J8987JdQhJPFHh6LiLahybcJB/9LcBfKHIVfoUZSRvZXT1xqu7lM59IA1RPkaWqnwKafquovTsKzMfbVN0vUKRXb3SYRBAKwjsTUJ+/ouCSTz0N/GWDCxYGfKd12use3IY1jVRQ7WLnbjbgYQHVJzCu9LdiFUsySkNKStB6SZR4zUPRcoq3tGyhTAsjtdrn01Be85H5A6PPkG6PLrie647LK5+g6i7OgRBic1RdBbU46bzjiE2JikUmbeepnZKuagXvefD7gzijyMegAiBymeJEy2LjgJT2KCnumcpPEYUnpFB6o5KRpPOppP5RDe9TrzvsB7Skn7w7YIeMQSXVfIA+nMPeJQOPB2Al0AmSCW7EWArsN8sltQfO2QBbjjhr1u95DtD+KFoqEIZ3SDC5BlEGPp8r9oxTLVqmTKkPtH2VF6gUxRa9ue4QG5BfmQ55vzxC+tFIBSu9BMzT0LU/ngUpJHQ7Kd3Vct2Pg4UHRyM9mbxyvmY38qb78JiaPpTW2QcFCNrHBet/JSL6eoeTLYgNzbCimP9eN6o/ZYdkF1i9/+sLu06N3AnHI5VgJkXSuvWn6zMgP+IrE3yvZJCWoAR2ecJtGBmre7tLQj51OAc+6nA3BTwZmQaa06nOVYg3iw7jZ+/+GutmZ8FnKIXEkzrIuRw9bLqKESsgY+BCgtNhJACuWsOSz9o8rr8HCXT8j66kWYRCoslyH2ZYM1oG95S0O63gJ8HWaeCMqmigynLyyHiOrU7PACSlasKST+Xg81XUI5WAAqtAmyPLASnp+U5PaQToi/yS7LK8wO4a0ZUCODY6hNLNGGMOAxV9CnzKbfXrSoufrtIMT6FcZ5tDt/dfOm4lxDaabwQ0cbhbUddh1TR66LcWG5pCzybGBp4F8k3XwUHuOAIX
 uFqIgayR
 61g2nIe8+kwkhHCx2j34NhKZXzTKTqsI8Sziinp+pF9TswqAfSiiD7wI+U5oeyoHp5SbD5e3TwS5bZq5WV3IHXjKb2vcOx5KDcdKxWuNK0fVd8+tq7nVKeAq6h4++NVb0l6u/RGJeFHQRHS6+hvJq/KkhWOPSOU8Ef2Lt6SMkv1aIW3gG3XW6KzGh240j35lBOMvD/s92DeKRKUh36lwgh0pmYXwL/Qj7SQSl6UjTarqChStzatj6rd06HmdIemkdeJiQJ78OmTrbXBhUaBkDCVIg4JpoFmgCqE1pZq3SX+qUpv+JtiL6VdcAh0AwspWgT5vVoEVEXM73ejfWnb5eE2vIt4mcjORceitB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On 07/15, Michal Hocko wrote:
>
> Oleg you haven't been CCed from the top of the thread but TL;DR is that
> we need to freeze a user task performing pro-active memory reclaim that
> might take long.  Currently we are calling signal_pending to bail out
> but that leaks EINTR which is bad as freezing task has a side effect of
> terminating it.

Sorry, I guess I don't understand the problem...

Yes, unlike EINTR, ERESTARTSYS should not leak to the caller (just in case,
debugger can see this error code).

But I am sure you know this. And the patch looks fine to me.

Oleg.

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..336af76d2a28 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7909,8 +7909,13 @@ int user_proactive_reclaim(char *buf,
>  		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
>  		unsigned long reclaimed;
>  
> +		/*
> +		 * Make sure that we enter freezer without delaying much and
> +		 * leaking EINTR when that happens but also take care of 
> +		 * fatal signals to terminate.
> +		 */
>  		if (signal_pending(current))
> -			return -EINTR;
> +			return -ERESTARTSYS;
>  
>  		/*
>  		 * This is the final attempt, drain percpu lru caches in the
> -- 
> Michal Hocko
> SUSE Labs
> 


