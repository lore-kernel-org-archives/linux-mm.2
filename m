Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70CF0C61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650436B0092; Wed, 26 Aug 2026 08:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6001B6B0095; Wed, 26 Aug 2026 08:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEBB6B0096; Wed, 26 Aug 2026 08:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAE26B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:55:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B2E68037A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:55:50 +0000 (UTC)
X-FDA: 85143417660.23.D164B5E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B9AA18000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:55:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K6U6ELrx;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787748948;
	b=wcAgKpAc1AFKIoSI8KpCjVqRrRKLsTGRLopOQStSniBl46TZdINDrT11U8L/yUsVFgQF9y
	Arwwj0QPKgSKkeW0pgdDpr1q+GmyUHNe8v8rGK5Atin/s9orrxnRYHQ0tlYqh9OvtaJj8x
	HnMLUR3FCAhdFjBhagUcSYlhhrqbXdI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K6U6ELrx;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787748948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnrjRmkdDMOkUOanYpX8DXzjHMEr7A8cKpEvbJBdT7o=;
	b=6VZfmsKJO9vfPob0zwDEsloIVnv/uclQdmrlw3n/ekF4aOd89dJfWpQN0c1N7UHLqxMMu1
	/fhwO9KaWKaAxVzhvcFVhYzKDPDRgtbOO8Y7BZGx9om6Mbg+jCOoFNEIL9QvGV6PwfF77m
	8QpPQoicsQn+7eV4OI/Dqo1mlinpktU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787748947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VnrjRmkdDMOkUOanYpX8DXzjHMEr7A8cKpEvbJBdT7o=;
	b=K6U6ELrxWjc88P6yDKL0V7jN8dmzGX7l9Itrt+ywejG5E5GLG8hiqMgrarc3QEptZrvuSF
	UWdSD9qNwaesOeMZR1MPWjslZieWwzxpRIj6/vwMp1YmDZLPnr5qf9m6kJDj0cAkN+2CkE
	h2tuSLQlJ9JoQSTz4uQthJ26ISIuuv4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-OyLs-H8nPUi38HBJaBo-pg-1; Wed,
 26 Aug 2026 08:55:40 -0400
X-MC-Unique: OyLs-H8nPUi38HBJaBo-pg-1
X-Mimecast-MFC-AGG-ID: OyLs-H8nPUi38HBJaBo-pg_1787748938
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 187341956088;
	Wed, 26 Aug 2026 12:55:38 +0000 (UTC)
Received: from fedora (unknown [10.44.48.90])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CFE3940E;
	Wed, 26 Aug 2026 12:55:32 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 26 Aug 2026 14:55:37 +0200 (CEST)
Date: Wed, 26 Aug 2026 14:55:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>, Ingo Molnar <mingo@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
Message-ID: <ao7iQ_wOLghOvTsq@redhat.com>
References: <ao7Q8miiuLAPVnWv@v4bel>
MIME-Version: 1.0
In-Reply-To: <ao7Q8miiuLAPVnWv@v4bel>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: ywgcTHzOMWyz3srg2AkjyIodRSKykvs6pGI11Weiu_g_1787748938
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B9AA18000C
X-Stat-Signature: tan3erbecxsebjy4yg7ukn1ygryx1go3
X-HE-Tag: 1787748948-200845
X-HE-Meta: U2FsdGVkX19vV/BvVS/DMOr+bu2ksjvuS4YW6pabjHhOCiq957GngQ+Ehs7gvSzVEyf1I6QHgPbnNM2AorTeNvZ7yeLGFJNHSah7sW8Phqkt32SuZ9A1wh2KtKqd/5+GlY4UM1faBRzP46jNhxe4jNCazDg2uQraPmGrhNCI/YW3025Gf5VC01JoPICGKlADydAupet0qGfQgoicLFFxTWzLWD/h4zQTH3FWytO7Mu0tA1AUY+vQQ2XRrHuJs1feDt5ILYA1UiRQvGYXR5ITaukjwehIOjk5vdXNbi7dsbgev/cP63b34eU2sgLvajogcsvdAje0BXTygN2aa9QwWuWp99hDJReBx4sXoo5SXSTgyeK/u7w9yyvILeWd9Vd9SIven16U3G+yBb8U/6pH5HsLJxYzjBDykwDKh9XHEK4jk/erh+DTCnTXSMXunotk8+k6GgNtFNLO3bQYDXx/aEAlRaKgyBTCKPW+38J4dJBjs2j4ihUBRWjIUcK3NqOivXg+U/YfTziNpHW9ps2rb+oT7pbC1VTE3knpiZU8o1yS0rdSCkR1iZ/VCn3HJNfC5tSHBH6vBvMZxXvlzTHeygTCzXEhQh4bLjQm3cpvdbbApdHZ6xNkqkvgjM/l7GUHE51aTGsMWLE1M/kLmWxeLVqALss7VJOEOKa5Bzva12nc231+lOEaEU3Xoku2i6/3R9VrbKPRnqlNrP6GvL3KWTilRVy1Y3nyKxuFqMhoTE2BgU3M54+fn/KIO20WEB4vm+LxZHkqdZQm17kQGqSslR32EBiJQW0zL3l/HMUSJM2cMA1d8LIqxCt0SZePjsEerk9Hg0ImxCPnzBHbhSQkVApeSSysY8XZT3qwq2Djpoq9qaKRQu0w19mPvJ1TM7YNbECKSGolmGy4CxKgNwGPXVgjWBzb3lPP1m6YkzkyC0ObMs1AzAwZiaBA/jhrKS2wJR5StszJcZsOpYQIBjt
 9YETN/ej
 APFAIaVz6f2m0JIWQ9cYIwtr4n/3iRZtV7NKXpsHF0Z1mqROtBgPoE2017eKaxxkPf+n5sATO3NPMgWQDJzNJSERAuIcuJiBbmy1POzACDwrmEGNaQevWwl2l/etLLEXt0lE2bmNyS64vMQmAlI5SlDsAYKebXV3zW4bFYA5YSb+DHjG1lNXuvz6mdRr8UovUg3KlGDmGvVMyjMHSxMGNyhVuKXaPuk8dfQ62IV7VXLll180Zn3GHvWZwUsGRd31jUaPbwLmFMteAgZ5W4/40eCi8oA1F+4kh/vouPkmkfUXbFHBdb2jdTviWdu9Tg4TFLaRaFl40bZ/MKiSx7BWCr7UImwifLzG4vK8q9MK8jYPE18J87rQCXVJw6idKl57ZlRmvByjC/eo7rjpS2Eh3+MTemXSMrppybVPszLeKBnYaGDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OMG, my head spins ;) I'll try to read your explanation tomorrow.
Right now I am all confused.

But let me ask some stupid questions right now, please help me to
understand the problem.

On 08/26, Hyunwoo Kim wrote:
>
> begin_new_exec() calls posix_cpu_timers_exit(me) right after
> exec_task_namespaces() and that removes the leftover node, so the state
> normally stays invisible. But bprm->point_of_no_return is set before
> de_thread(), so if unshare_files(), set_mm_exe_file(), exec_mmap() or
> exec_task_namespaces() fails, the task dies before it gets there.

Do I understand this correctly? If begin_new_exec() does call
posix_cpu_timers_exit(me), then everything is fine.

Yes? If yes

> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1003,6 +1003,18 @@ static int de_thread(struct task_struct *tsk)
>  		 * the former thread group leader:
>  		 */
>
> +#ifdef CONFIG_POSIX_TIMERS
> +		/*
> +		 * exchange_tids() hands this thread's PID to the old leader,
> +		 * which is reaped right after. The PID lookup in
> +		 * timer_lock_sighand() then fails while the per thread CPU
> +		 * timers are still queued here, so dequeue them first.
> +		 */
> +		spin_lock(lock);
> +		posix_cpu_timers_exit(tsk);
> +		spin_unlock(lock);
> +#endif

... then why do we need to call posix_cpu_timers_exit(current) before
exchange_tids() ?

And what if another process attaches another cpu timer to the execing
thread right after the code above?

Can we move posix_cpu_timers_exit() or the whole CONFIG_POSIX_TIMERS
sequence in begin_new_exec() up, right after de_thread() before the
"if (retval)" check?

Thank you,

Oleg.


