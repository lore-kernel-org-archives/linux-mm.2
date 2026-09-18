Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4D6C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E0A6B008A; Fri, 18 Sep 2026 10:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11EFD6B008C; Fri, 18 Sep 2026 10:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034B96B0092; Fri, 18 Sep 2026 10:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5AE86B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:24:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12EB71A067D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:24:18 +0000 (UTC)
X-FDA: 85227102996.04.F1E6E1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id E842DA0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:24:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FCsjr3q3;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COGJ2JvndcwpiY85nNJ0ortnJmNdGWOwG92Ky7RrAcw=;
	b=Ibg20dpeYXJpc3DsSZsKSsJcMGdTqe5wU1rCK9d3BgCPCpBKElA0ntiJlnxt48kvkAXKw8
	n/JAAVqqXaPNyKS+QxXzqdC4Z45/8PHtR5oGPoYFfv8bxSPV2efbTUm/Kwl1COwTrAr6T2
	qVK0hL0iAAKxYX5JWYr5gzpJLiK6/gE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FCsjr3q3;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741456;
	b=5QAbrvbQ9yOr+wRqQvFV6P5yMSj5/croHT/JauPzAG15ONXtFjGkW7z+xyI/OtMW/z7tKG
	XMS3Z6gKIEIy8pzbAp4g0ckEiEevmoyseTwr+bncU1ZQPKcLlG47xH4LuUYTQfbXA+twaa
	tPjMm49LMVUuztiO2XxKpOlCmE4zOHU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789741455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=COGJ2JvndcwpiY85nNJ0ortnJmNdGWOwG92Ky7RrAcw=;
	b=FCsjr3q36vBsRQojhxvjzd4lZAzwiQMXiKx8/xrGIPjZQgYpEYYAj195uUy9jB8yl8CmR7
	bhXEIKqqnlK7gqLwsB060CNJwPoITaN+S/xe9E3+FnbZIa2HHIuW1E2XxkyKpW7R5et631
	4KlHJyoozrRQ824WE4KduXM+njZ0W50=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-_WEziOAXOlWM0WqjR88tKg-1; Fri,
 18 Sep 2026 10:24:12 -0400
X-MC-Unique: _WEziOAXOlWM0WqjR88tKg-1
X-Mimecast-MFC-AGG-ID: _WEziOAXOlWM0WqjR88tKg_1789741450
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 811BE188307C;
	Fri, 18 Sep 2026 14:24:09 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6FDD5195604D;
	Fri, 18 Sep 2026 14:24:05 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 18 Sep 2026 16:24:09 +0200 (CEST)
Date: Fri, 18 Sep 2026 16:24:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 6/7] signal: don't retarget shared signals in a dying
 thread group
Message-ID: <aq1JhBwfJKSKNNCU@redhat.com>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-6-f3787fcda051@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260917-work-coredump-fixes-v2-6-f3787fcda051@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: sfLd6TBnSfvg5DcAC1fCfoMjBjKcMa7KwemXgjg99PA_1789741450
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: xpnws3au9hr5bg6ryd81f4c5ygdhci4o
X-Rspamd-Queue-Id: E842DA0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789741455-618272
X-HE-Meta: U2FsdGVkX18MtGZSYJcFtlUtLiUsLm1GF1Lnsw7m1bxGYzG96h4hK7uDOGZB2g1i0ZDAZ/76b69eJyiXYwtKW8cN5LWAvShjzsl1+WueD+6UvGAamVASQQScbVFfb5uLMmwZyqEuuY/3OsVoCxIcg7zoUiZL4ZTmCSSb1Ana5ClsggBJ2BySNqQrWCTGD1NIscsEVvQDUNCtIvov5oMNzYPQOtOsVad8wcHcgL1BISs7W+B6oFv4Pk46w8Ev7JoFDtTWG2HuRm2Y9zJS42sgX7yM3jIX0DF4s4slmIuX09H5UW4rjZ3YVJBgsoajY/gpu+FfiaW9pXWMYnf6QlzG/DT3i2nUE6cVNvaA80h1qwIKi54rA9wAXaStBLkieince+RTWTSYIpstIlsoLJS4IMRymjlBnw9FWWyf7of8jXqV8MfiKLiKRQ891vgAVQwyRSvj8GPHXLl6VlxIoFeO0wu3jjq/zAoQ26GPeMw+6KJCGmquVCl+J/EPyBzmim5cBp/csWwwzp8UBGdIVDf2iEqgNje4SDXdreyNs4k/EEkhW8Vn+Hs5tjFOjBoHGJjHdHT0j7oPt+ZmLJXAVd1VJ5NXRwY+Hmm3jXfky8i1hdkHhHLP78dji4/J0gmSBH0J2yVguegFUEX/XEaKWaw8Pg51+E0dSt45bbrdg8/i9nv8vtcK64+anVw/nAtmNrvHRpLy3WJcDWOCXvCOLd66ulOE47Ugg+jwmKamJ+XkHRyKR1c6nIg/kptbMlHddC0k3eVNfRDLqDUzF302hjiVXf52EzHbGtbPi2XuX2CTQCiqA1TGUUiikFvyV+RKuE1RymOhuwVJmahYYA605XANfhsCS+nYTMuo5oxoOZw1DPHiiZZiU7Ssk/iUcCQCn5ZVaU+UyrGbhfrruftD1MJ/n4RMhuNcUQyJ/xfgf1518oQwWjkiP0z66iuaHk0sMsSk2L1iW0G9mIuE32YDEb9
 ge/UiSNl
 LtwLKRmXkM70W9QRCKj4tDGoVOrXfA7ADoXWOZ3F8n2sxksBqNI/DtOHsxRkvo31aMRrNbWA4kOdjpAGH2BmxPGdE4bRNXPsKJKOpJFuOQC4uknWh1lxWDdIvezZHnXunqaVptIx5UwR6p0t1bJhH1qAVfGXogq8ZhzGigvXISrntePtMiNR8tpRlWizCLxgxGhXfGh4RUcPdqwV99vAkBN4Pc4jbgZNF24juzdJP4Bo1GTV0thCuBijNyeQ5ajhwYkKGUAACLMXMVMugThL1EMfH9lb3qnjoOWmJQIef78mkdqvDOGqy3uXl5fFFVVGOs/Oz/vEPXZmpOZSfBakWyzuqUuAox/wbMBZV0EJL937SiLlODAEf5X4vJb3WhtyJD4AxUMa9tgtm9KYOEq1Lb+7DKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/17, Christian Brauner wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3117,6 +3117,10 @@ static void retarget_shared_pending(struct task_struct *tsk, sigset_t *which)
>  	sigset_t retarget;
>  	struct task_struct *t;
>
> +	/* Nobody dequeues them in a dying group, see get_signal(). */
> +	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
> +		return;

Acked-by: Oleg Nesterov <oleg@redhat.com>


