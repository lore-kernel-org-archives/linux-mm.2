Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76853C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BBF06B00D5; Mon, 21 Sep 2026 06:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B926B00DD; Mon, 21 Sep 2026 06:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6358A6B00DF; Mon, 21 Sep 2026 06:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA356B00D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:32:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55F7D1C0184
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:32:53 +0000 (UTC)
X-FDA: 85237406226.08.71EA164
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 32FB51C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:32:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UtmS3hRM;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dfX0uPkgOugVML85bBzWDMFZaOWExPaUKgWWIP1kWE=;
	b=X59JqpgezA8izOxpc4rQDbP+hiKr2HKHskig1S+ggP8pN+px0pMrBRhcZXmIR1EHw8UuBz
	4gqZ4u93KgU5EtxEhvLiqruCFdmOcPin546pX51I4gi2aw08KYuQLqbbiWJYQCDKYKNkyV
	MI6Igqa9VaV6lCg38byUDAIUupxzYsw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986771;
	b=TBHr0d+syRh3I72rnSXcrqdeYiZn+pV6xpP+rqFVLQEvxlvUqNCBX3EG9xmuIgTNT/JD7c
	A6gb4lXDTmZk7ux+Ysq52LTgyMqrpTEC+YVmra08L2g6iVgz3SGURzDGHpxmYCUhLPpFq0
	Sc/4Fhbpz5x0Rl+th6RvH87DWcr0kRE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UtmS3hRM;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789986770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dfX0uPkgOugVML85bBzWDMFZaOWExPaUKgWWIP1kWE=;
	b=UtmS3hRMN9bHaseJQM3qHXRODvG2VsjEwLA3HY/8t/vscym9OAJtEajxNkaihswO8s+Jxk
	jj+hmbKQAAXUslRoAPwUTwSuBZyJJzaBbSS2pGog5ouE0vD5KtKIK7y6f4m3CXDu5bGVAg
	/yCATyGPDva1/nPylJGSR8uxeYoaNOU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-EiUlTb4tNzuHYTvdF1LTDQ-1; Mon,
 21 Sep 2026 06:32:45 -0400
X-MC-Unique: EiUlTb4tNzuHYTvdF1LTDQ-1
X-Mimecast-MFC-AGG-ID: EiUlTb4tNzuHYTvdF1LTDQ_1789986763
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 509D71801BF4;
	Mon, 21 Sep 2026 10:32:42 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5FBDD1956041;
	Mon, 21 Sep 2026 10:32:37 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 12:32:41 +0200 (CEST)
Date: Mon, 21 Sep 2026 12:32:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <arEHxPFFrRtvUSPJ@redhat.com>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
 <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
 <aq0_lvHDViIpX_Mu@redhat.com>
 <20260918-elstern-potenzieren-marotten-71ebd0744753@brauner>
 <20260918-oliven-lebst-wohltat-c633868711f1@brauner>
MIME-Version: 1.0
In-Reply-To: <20260918-oliven-lebst-wohltat-c633868711f1@brauner>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: FoH0XU2W5IWsVSMaK1Q7wZi3TuKT2QWn2vdDrQMcsoQ_1789986763
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uimqj78bp4e63uasc8jb9stzsicn5sog
X-Rspamd-Queue-Id: 32FB51C0003
X-HE-Tag: 1789986771-939801
X-HE-Meta: U2FsdGVkX1/7K1l//YIhZi04jPhNQxgNpXG93ZMVg/47jPyJYSKKrF93PB7ioKd0EU0VbO03pigaHfSB1fE4ZARMI89LtrKUGnS/Bp0WrQQ+WmIIjHNVygYK7nSL5RCz4k2Xfr8pGgrgC2xxKJpWJZLgBGnQY/FdW/o0KNT3C/R/Ku1R64KJcvRh0rdAvE2EvX756smKu+STXP/dep993ky5wNow8qm+l7khdedTCSQEWZHk/WPQHnHWMrLltSlgsG1hxFY7N56xQiyIiDC4LgmCBH5tLtvC7vIC26OCdsVBl84fCcEdPiG7K/e/ZqObzL/yXFvLD9Z4eU6JHWpXQBkwDRgdXlkEc5UTTUNhsmRs2GPVKDGOaKQPxqChJ3kCp0boGh0pemAIBgOfnByoOvYozXjopfYC2sgn40IZmPdNebNoxzaNxg5BcDja2ZWe1ZXZuBYfDZtwtUTWAGm6skQFhXvPhKFtOs0ZF/ZoEC/CfOs0nSo4HQrIh7Ns3tsPX6dUURhJr+1sGiPKYET/llLUjAxSJV6RH3Op72BclLJ8vBC4mg9wq0LGdSVEpxQ1XwehzidKbOrBUROeESFaO2xUTk/sOKtR0aqV4bUE5ETK/eRcTZiGj8c+/4Xl9G5SQc2HaRh0gODlezqQgIrB2mjIZvCOFT81ng0ylYE+1tqkl/WvekAgqOTQoq8dCzolGZCfmLkCa/e0kDhEq9YSFY3N/H5nj8JSSBk+C6oKlUe6rWZCnmkJcI43c1kpV58xfGlprja9MeXp94edzkeJjl0DjVQT3fcI6al2WDqAEv4Jv698XJQJ5umea4YMk37UijpDhxMcPo0eJgil9SBZY95Bj8IsuiqPWV9XiZXWklXiRPl13nVlpwR90kuT5ww6OrzaHKr74uhBAT62dpu0mm70divNeJ/lSJqdA7IPHQX/GCHyJGD0gkPwScLvoYJhoSIWK936IBrW6DNKBKj
 OZbxNio9
 EOd7UhpZksQRbee/5iReGkYWkSjzAI65iyLnBmIemonMgT4n4LADvHjFhGyMn8/caN8ChVjNckNC9+Nr5a195C45Z+ps64xrX0P7QMvo8+8aYni9uNxo/K3dzgIxaYD+wp9q6BQUDD37n/bqWc/EkcPdZALCvLXFQJFJVqLWnlHEYCftH4/+L8bJ2muPa74QxxDORYx/XnmsjD6leiubh2IHm/SVYkrk8BLtRLbtDsEYpx7JMKBsin++WjC9dUq/FU+JN29RNzpDgNSyXKoV94wOE/XNALvdX73KrrU/AI3CyLkQKfR12hFcZhwNIWM79BfJDBi5WpdGTIECKAFphDZl52FC49L5F+HJq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/18, Christian Brauner wrote:
>
> zap_process() skips every thread that has PF_POSTCOREDUMP set.
> do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
> io_uring_files_cancel() right after that.
>
> That runs task work, create_worker_cb() runs and creates a new io-wq
> worker. If a thread started a coredump rgith before that worker gets
> created from a thread with PF_POSTCOREDUMP set which zap_processes()
> doesn't see. So two ways of fixing this:

Christian, I got lost ;)

TBH, I don't understand why the new io worker is really bad in this case.

But lets forget about coredump/zap_process. With the change below the
io_uring_files_cancel() paths will no longer be able to create a new
worker, even if coredump is not in progress.

Is it correct?

Oleg.

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2707,8 +2707,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>                 .user_worker    = 1,
>         };
>
> -       /* A creator past its fatal signal gets no thread. */
> -       if (current->flags & PF_SIGNALED)
> +       /* A creator past its fatal signal or its coredump point gets no thread. */
> +       if (current->flags & (PF_SIGNALED | PF_POSTCOREDUMP))
>                 return ERR_PTR(-EINTR);


