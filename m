Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC03DCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109FD6B0095; Fri, 15 May 2026 11:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBCC6B0096; Fri, 15 May 2026 11:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C2B6B0098; Fri, 15 May 2026 11:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4CD56B0095
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:50:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B97DA0177
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:50:03 +0000 (UTC)
X-FDA: 84770090286.15.7B18802
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E2FBC0002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:50:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QTLglfPD;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778860201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbOb39Ni9J+OOnfW7hqY4KXUDyVfLPAfxlWM2720htg=;
	b=FIELcrlMQ/xjp357BhlL4xDPCfeTXSb0NoPoCskNPE/pdcCvflLl4E161jkgjsxozOeKls
	2Le/IiMOvyP6g7mOz9MJG8stBV0jyR/1Sj9hYI0EEkxQiXSvmAufbQ7hXWw/HmFOblmLo0
	bJ/zXJLVpzNARpDcuADCf3Kuec0ZLjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778860201; a=rsa-sha256;
	cv=none;
	b=M5UiG/meOtzVy9axU3DwW+Pdnzc8A7ecFD0WD0o8QsIOJVWVfm+H4P2Qcmdxnu+cPjrbos
	A6su2Ntu03fNc2kTxmijSE79D27mvM/LbE4l0T1D4yh+zKxLcIqEQu00j/xJtYHSv9IF99
	tfV3xT9/cAN2c6OnAxBM2g1zLgohRwU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QTLglfPD;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778860201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sbOb39Ni9J+OOnfW7hqY4KXUDyVfLPAfxlWM2720htg=;
	b=QTLglfPD9n63GJGCswi7kH63wa3kJVZXLSak8jytHLw0BUFamTu8k00nf5euEEjZGeBTvT
	Xofk5KSPqKNRUmG1RU7s3gzV2tPE6umcKeChroZVVBvWJN6x3ODuagoYb1bDKDSOTu912Q
	FjMMCzZAdOco94od/BfexQpcGJJvzZo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-PVCkdrSANp6znqDPcRhVaA-1; Fri,
 15 May 2026 11:49:54 -0400
X-MC-Unique: PVCkdrSANp6znqDPcRhVaA-1
X-Mimecast-MFC-AGG-ID: PVCkdrSANp6znqDPcRhVaA_1778860191
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4F2D19560A2;
	Fri, 15 May 2026 15:49:50 +0000 (UTC)
Received: from fedora (unknown [10.44.32.66])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6A98A1800240;
	Fri, 15 May 2026 15:49:46 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 15 May 2026 17:49:50 +0200 (CEST)
Date: Fri, 15 May 2026 17:49:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <agdAmAfXKXX9Nzcf@redhat.com>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
MIME-Version: 1.0
In-Reply-To: <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 8E1OpzgN48A9LENoGIaAhzfDzRDNgKstQR9WxR0idFA_1778860191
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9E2FBC0002
X-Stat-Signature: ayt63tbq7uaun1diqx56koho3rqjq763
X-Rspam-User: 
X-HE-Tag: 1778860201-782370
X-HE-Meta: U2FsdGVkX19bwc93DUZ2UIY3kRmPY5MRED66de3LGFqNmwxpejv4YHAq2ZksX8Z+6k1EW9Tudnj5MaV/0R9X3WeZMCArBj73viGDPuhNzYd+FwzztGw3uziRZAKsrBH9K+70s03rB2YZV6vx52NbSk9TvXgsOHLY9IbjfZ2aqgEpih0U7zsS8oZ7udB/fIb+as9TnTp/YJpBzP3fUFkR32qHfVM6ExwTqtDYa/yyzT4S7gsrDgwmhTe3gNxV3C6Vrh/+WGi92WyrHgT5fTkMpAIA689+hcKUV02/fshocICf+D+EwuR06sKj4s/36rNMGydYoSWGN1ih3QT6uGaCDSZ01MwAH9JIhZhb6I99huiP8hGOcWZ+tfoPRC+uAz5rtYaJT1YbLOSmIC613IW634dQImiIFB1EEQLjghSYL+kO7em/u3UHF4tt12Rqv1deT1NDTvaIAIHYgJCAHHAdraScmejRXT7A6BvQFvwUt1DS5p/q3az+D0CecHVt9Qe61rStkSXqpB8d0WCgxrYKTTRJlIcyhX9bGsliDQjjjc4EMleD3qQOWzhYAhzvuI42lnsPXn3VQNPd833jQcm5YM3WHwiG2outbhFp/ucJPAOc9f6U9bshSrmTjrRHaEzsYntt45OBh1L06/xOlfFN1i2oRJHJRwGlrbKBTrq16jHa1wPTlm0XUAKza/uj4UnabrZIfBLY3PTniUL1KEY1UXcdL/QatUv0BPGlEOGgSvswDkIARjHBfXCFi28qXyt3IQmfHbfyHbMJRu1h/R8sjPrFkAtLN/7UCeGKKmfhKHMuSQAb/asl0/Iif8Q+ybH1bMuwNh0An2+QKqfHVskc/Q+4UqoVktCMLJsMwwZZ63FdHjwCHzoaIrBG/xgMkOOij6d/23TMsh8Uu5fZCVbT0r0gokZkI30DvM81Xy80Zzi76JBs24nL9uyw+O4FNLJY61+jhCISYy9SXr8oUQ8
 jrJOMpN2
 GnkUXaDIXXmpcBrxWHvheTX77JY8kvtDW8V65kRNE2b8PtfAVy7MreUL380rFz50Ki86oaykVP6/tZFFJ7gslP/BsJufr7xRIFkknSX2zuB9UGw1Py2IpRxMGuFgXSft6W3pQgBPgRt2RAj8xbhnKoplLWKRQ+Ni39RivrFX3uDGwqE4kSkV60J74KJlDuJwutKGMdtwH/OrUneVHJFCDy89kQHLaH3H5kjthwnZhzWC8/a32jWdIsBl5mH3h1uzN42K/s3/LoKl7kuykH16FAK2lMGyhcWobz3mrHAVl+sIHWnqTsYsQe0WPt8GigHP64n2qOvjZeRdlwqRqnyQ6/0dQ1XWMpMpWsvqN89oKvdKAeKlGDRbss988+TiX9bw9QSi/25J0CS2XYTRUlLRkl6ZxUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/15, Christian Brauner wrote:
>
> Right now we have clear and simple signal sending semantics for pidfds:
>
> * thread-specific pidfd -> thread-directed signal (unless signal is thread-group scoped by default)
> * thread-group pidfd -> thread-group directed signal

I don't even understand why this patch uses pidfd to send SIGKILL...

> > +	reap = reap_kill || task_will_free_mem(p);
> > +	if (!reap) {
> >  		/* Error only if the work has not been done already */
> >  		if (!mm_flags_test(MMF_OOM_SKIP, mm))
> >  			ret = -EINVAL;
> > +		task_unlock(p);
> > +		goto put_task;
> >  	}
> > +
> > +	mmgrab(mm);
> >  	task_unlock(p);
> >
> > -	if (!reap)
> > -		goto drop_mm;
> > +	if (reap_kill) {
> > +		ret = kill_all_shared_mm(task, mm);

If task_will_free_mem() above succeeded, we do not need to call
kill_all_shared_mm() ?

Oleg.


