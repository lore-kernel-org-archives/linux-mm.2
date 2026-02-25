Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972B5EFD20A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017D26B00D2; Wed, 25 Feb 2026 03:47:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07656B00D3; Wed, 25 Feb 2026 03:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E186B00D6; Wed, 25 Feb 2026 03:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFCD36B00D2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:47:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92BA91C368
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:47:39 +0000 (UTC)
X-FDA: 84482350638.29.C72EAE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7231F40005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:47:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c9gv31vo;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772009257; a=rsa-sha256;
	cv=none;
	b=rcWBWs1HJT3T44yD/q3MIfhD5BXZtQdxwKn1Am8WookNa/kew+YA8ri1MCZ+ZIs4AHb6V+
	QsMDFY6bIO7kudhOIrG1uxCKzMseoJ5TJb+L/4eLobe8uO7DHCnQCkZY/T6dZ/af9j4Rjp
	lMUcF/lwPyd58tvfFQIMNMOaB67FwRc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c9gv31vo;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772009257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d04OwuAx5S3mZfnINvJ//qURUEObB9dXr+1t12EiSts=;
	b=V0YsL3Nra/pQlQs1KEBr7cXutaUJnY7BkRISstVMqA/dsS9pZG0lFjqa8znEX612wHAJO4
	WYKvRT3L8u5HjsfEYGB9MS2/XYQ/AtQHjn6Bu3A0jeXjrKm1xzgUIa2oXQQ0iOGWpw1QmT
	WwXKUkiGeVCBdfQC2eQHrDifGwJseeU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772009256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d04OwuAx5S3mZfnINvJ//qURUEObB9dXr+1t12EiSts=;
	b=c9gv31vofQPEV5F5meEuHcuH+tKkPAmnw+xI9+h3ruK6wmUzUCzOWjEamaUekWGI4RKCcf
	pD1Eo0U8ncJNl+l99iNi/9l4JA0lRXPqehrqToyE4qK7Ri0uFzsa5+QBQ2Hz/W1ParjKs9
	4tcUsh9oaGj5eMiOUoPYrncdl6w0u4g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-4-4FFrYcPSmYzIZuxXg9Uw-1; Wed,
 25 Feb 2026 03:47:31 -0500
X-MC-Unique: 4-4FFrYcPSmYzIZuxXg9Uw-1
X-Mimecast-MFC-AGG-ID: 4-4FFrYcPSmYzIZuxXg9Uw_1772009249
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB49C195608F;
	Wed, 25 Feb 2026 08:47:28 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BE0E0180066B;
	Wed, 25 Feb 2026 08:47:21 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 25 Feb 2026 09:47:28 +0100 (CET)
Date: Wed, 25 Feb 2026 09:47:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/4] pid: check init is created first after idr alloc
Message-ID: <aZ63F7vHRKw9qZw9@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
In-Reply-To: <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Zrfar_RxmI_6DdsHS_nitd1FiTSppGyItlzTOrBn29Y_1772009249
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 7231F40005
X-Stat-Signature: ccw8p3tyc9tse9rkm1uwt71jgnd64wjd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772009257-766509
X-HE-Meta: U2FsdGVkX1/x/6xMRfJMFYmbhbrHzDbb5uuHJh4G/ottbWJhofpxShDsJVuPBIaockTszA9kPDw8yjB4sRSZEkZYfSNdCnwCd5VU+ryYWU1IgbMOYRhIkMP19mH4+eZKI/AhfZ9x9fz460yQX8eHssfodCqyU96yMxInR2dowYEjtdzNI7ImuwWdYkaGVidfNxk0ICUAa4LgrPARKTXjT+U4XTr6Ft1QQQgEgoTKcMW8FU0BFWZsFxN739zhsn4pEAWbJ6DTXWn2y9lSllU2yhKhVkLaAi5k6FhLb3E9j3GzIrn2jjsU+C1w49U/H0XBNYNgcAECmQEISrjhuQgSQ3zB4oyGgZ7K9+i3+hUIWxDIibnKnwzGjMggA+Z+5w3oCq6pdJ7Q8GXc44tsrrMo7IFaEoYI6hto5QjCkR+vtGng2D8z+je0k+/fMHvzJEWnsZP0HmcRB+gs7VD83J+ebxJjO/+Wr3O9n7aBrGjomLxt84V7Uf3Ufa5UBy8pjWIlIaDQGBKyIMvkK/9mO80GNpwne/8prb0puatS34O2MANjaaktTu9L/kabMcf3peaWCQYNfyVfltI3oz8LBkEUs8+PFuG5lnvZTdR8q7b4nZzbaMTvIcn/5PlOD0qPrN36EqEtvsQ9aR7QOZ34B7xpf4jD7D45qCsPqIRw5RFYyzbmy05OPyUBuZ5gGSnqD+QmTNOAqRALtRojwJt7jr/J1UqYU4LaTnqu54pQ73TOr6gfyBHq+7c8QjYoTRLcrB9SKAXUG7DbXPupgoaxHlxdgzvTTqEiIkeFrT23gV21LJIInGTjqH+91mfeuo33jt8wADyhSlsoM8f9TxPs2D3BnqHzwGe8gV7sokJ/STKqd9jITxXnAp1X4doN/KmWi+ZzjEkKRS58YybmPWHJ5MjZ6jmlsexFra9p4DZzBZqBELyT2JSkl3tAmfEFRVAlJJRJ1B2boHio2T8jAsJyJ1l
 Jnmqpk1o
 MG/hVB0wqDFaG4WWZYy9lXLEfO+N2wcH3z1thrOUrIexS6tng7uMBjjH9Ebr3Yd3rRuRATVB4k4i6E/+I3iM/H2CDUSjHGvtuwXCObXMb7dW4kLWA8tQoJEULSdnNspCoaV5dm190MiX6N5uANh0NRuKG1OpdFeYm7mChOvJMrKZm+WE+TfZfiB+7mEwwL3XifLVIZEcGZiKcUCnfG8gs3ykhEws9d8h1Qga3Xi6VtWn/SJQ6T13xH7pgwJrnCcw5dV3eo9D7dXDCmqM2WsBjD651t3YIUUBGqXpvPjzmzaY9MZkK+vg9o878dX1ibVTstfpqC4BECEN2p4TvewPUrJQpbYpV+swj+JQzrTs3g5QO1lrrkJNiJfFI9jZoar8EEhUmBoWSNEQ3h3zImgk/x9h+BCj38TmWipbZdwVN+QKaeU1guGeHJhSlFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/24, Pavel Tikhomirov wrote:
>
> This moves the condition (tid != 1 && !tmp->child_reaper) to after idr
> alloc, so it not only covers that first process in pid namespace has pid
> 1 in case of clone3(set_tid) requesting wrong pid, but also if idr
> itself gives wrong pid for some reason.
>
> This could've been the case before this patch, when creating first
> process the alloc_pid()->pidfs_add_pid() code path fails, so that the
> idr->idr_next is non zero anymore and next process calling to
> alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Effectively
> leading to init-less pid namespace, which is a bug.

Yes.

alloc_pid() does:

	/* On failure to allocate the first pid, reset the state */
	if (ns->pid_allocated == PIDNS_ADDING)
		idr_set_cursor(&ns->idr, 0);

but this logic is broken.

Suppose that a task P does sys_unshare(CLONE_NEWPID). Then it does
fork(), and fork() fails for any reason after alloc_pid() succeeds.
If P does another fork() to retry, we have a bug.

So with this patch we can either remove the code above, or (better)
improve this logic.

> Note: This is also a preparation for the next patch in the series, which
> will introduce an ability of creating init from the task different to
> the task which had created the pid namespace. Needed to make sure that
> init is always first, even in this new case.
>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Signed-off-by: Oleg Nesterov <oleg@redhat.com>


> @@ -296,9 +290,18 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>
>  		pid->numbers[i].nr = nr;
>  		pid->numbers[i].ns = tmp;
> -		tmp = tmp->parent;
>  		i--;
>  		retried_preload = false;
> +
> +		/*
> +		 * PID 1 (init) must be created first.
> +		 */
> +		if (!READ_ONCE(tmp->child_reaper) && nr != 1) {
> +			retval = -EINVAL;
> +			goto out_free;
> +		}
> +
> +		tmp = tmp->parent;
>  	}

Cosmetic, but why did you move "tmp = tmp->parent;" down? This is fine
but not strictly necessary. OTOH, if you do this, perhaps it makes sense
to move "retried_preload = false;" as well?

Oleg.


