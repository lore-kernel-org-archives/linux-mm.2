Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83ADCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2E86B00A3; Fri, 22 May 2026 11:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9A56B00A4; Fri, 22 May 2026 11:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7516B00A5; Fri, 22 May 2026 11:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8D36B00A3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:00:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4C8D92D1A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:27 +0000 (UTC)
X-FDA: 84795366894.03.FF3C8E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id DD8992001F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ENhR2ZDW;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaWKP3Ic/6AxP7g0jItw+8L16wyfpnyMRsN+KfYTPfA=;
	b=arDe9qxOp1oQmY951LGmb0kJ+yl3gUyestkOEf4USiktQMyiB8q5gZ4+JgAyFXkMb7P1w5
	QNzV0vRb3X5wDz+Puvs3PkenwkbmhKnL9INy3kLeRxRAbHH95wYJUHXY2czrt7qycbtTc8
	jNlkhJ80N4+sm6RLbPw01PG8ZGtjI7U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ENhR2ZDW;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462026; a=rsa-sha256;
	cv=none;
	b=al0KK/4RFU9kQoRqRgthaemsIgyZBzRZYsXaKcH0S1QO5FBWMZFYYSX/MoaMmvvGRtzCC4
	FYEoxdy1yT9/hgHrP+Bi4aqMScwcYsBl3wXYXyK3Lo0aitSCwD32ur/2MT7Kr8wguOAvhq
	bYe6BeX3buLHxWD1Ltmsi+nd5TQhMQc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DaWKP3Ic/6AxP7g0jItw+8L16wyfpnyMRsN+KfYTPfA=;
	b=ENhR2ZDWOVoHvn/xGbtfT9Z/QXSkjYoAEqiuwNkg+QLYJ00FejaRZ89I6gCUYHdXUwBtcm
	Mzk97/5wsdUEWO0Ie/ZuYIL6a5ITsnlhhXsEIAsQXs0jPLzVM5326gXiyzHpCMFI3+P/to
	1ivZxboNMQclXUP7N2j8v9mZ1RKLXYg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627--Uu99pyCPjaLa2bp4sc63g-1; Fri,
 22 May 2026 11:00:20 -0400
X-MC-Unique: -Uu99pyCPjaLa2bp4sc63g-1
X-Mimecast-MFC-AGG-ID: -Uu99pyCPjaLa2bp4sc63g_1779462017
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F047195608B;
	Fri, 22 May 2026 15:00:17 +0000 (UTC)
Received: from fedora (unknown [10.44.48.45])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6299D1681;
	Fri, 22 May 2026 15:00:12 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 22 May 2026 17:00:17 +0200 (CEST)
Date: Fri, 22 May 2026 17:00:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Christian Brauner (Amutable)" <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qualys Security Advisory <qsa@qualys.com>,
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v3 2/4] exec: introduce struct task_exec_state
Message-ID: <ahBveiRasSfLAx5b@redhat.com>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-2-69f895bc1385@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260520-work-task_exec_state-v3-2-69f895bc1385@kernel.org>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B0nceZTcrF-qdql_Kf8e_WFFKy5C5OZTwR3Dc34uFsQ_1779462017
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD8992001F
X-Stat-Signature: 4xrmeruom4hso8whs1cztfy6iuf7ffe1
X-HE-Tag: 1779462025-702717
X-HE-Meta: U2FsdGVkX1/UEtyWe0uGgFKSkRI8x82sSpuRHQSf6Mtlij2jZcRNrYFRCHHlz8z4rXUHx8X0Sgw3l5UjngDQiX2CVJDr8qgD1RNtpbBzxsKlv60r5+UIcCjZLT+45kyAWjnRjHVUd/Q58DHslAMa++Jyn80bG8h7GGDW7UKI1joBFseUd/ma+J2ym2sct0kK+UtqDSlUPuqS+/DibXFr+mrVyN0duzT8zh5rTujNIWLoZ9vXlQ1v3AMWcj+AWHlEBfLQ+WMbEQKAM74A/PI8ltSL8G3/V9irH0hN0oDt/jXs27BzJQ8dyMFHyFE1+QfpwVPmhtv3Cq36GQNSIskjv7ww81lyFpgomVG+yxM9pPHIsTbLNEMTKXqhDcIZSAeUkI6lUfHbY27bubYXfqPA5r4ktsJTpXYr2Rb58dB+kBxXHJlw9mR4DpKX9HWO1pWrDJlw/fAsjrIAlTNdG5LQ/Q3wlTCipQUfrHAbkLJVvKXEqWZZ+2NJGPNmsppDsWZ5tSop0UUxXIGjKNvS/lml/KhDQyCJSUgSvMX0ya5KJWVt8uMi3tkzOxaioO6n/WgRCvIxPEp7ITQAywZZOjHOq5rzzSO1kMLCxziXLE9vxq0cWlWcNo+8wvqSMNpWKkimcrppPj2wIbv5jecWtEkXBzNGLXbSYs2p6zRjjKwioR3t0kWJwYv+IG4g5Wy1VqwB0HfZAXBgUS2QRSGtRwwjvsKAybIkLeefenfvnz2woTBs1eEKmEj28nuj4NhlGD0zgW1zTeSMmcdWEEMJpXKas4u+NxC9gHch48Nj2jWUiffHWTkqWq1S4ESlYuBwMYcGm3QhhCD/ISkihWODiSKYXFxO6NXrKDeHLdim4ciTv36dAqSjM4rN7irZ7My6kKKvTBA9oOxJizJFmd4Sw33hcWNvpWMQqztr51rY9sDgrrwNpN7IyuP+RYAtra91wybMRwsdZUFxZwkMFS+O6LG
 uCCiaY+z
 keTm8uWZsPMLIJSBBXPy0Lgq4vfWXDP2k4gWhf357Z1C2xw1kIDoJDwcH0fvT9HLhdBGiCniAfx8DgpJrxmIYtA4fap4ag1phfBpwzYcd4DOsnoi8Lp0N/NPrS7ND9zNsD944HKIZhYRV7xHUJFj5VSpyEzrHtQmqnHopHm9TeGeZona2eo/1hD+LaA6zur/bC64kjuDjny6tYeIuuB49HZHr6svlKix/VOKJPJY5nP7i0IgX85Jh5+CrHV8TiVMlmvPu1qfmrkVoQRdezolrTxFz39VOb0IYPoLMcvB/chIvwC8k/3jnmcnWDcQx+Srfdmor16TPV9aOiF+l7B/hW7CKtPwiFaIVyMkWfGHealMd7wL7Ylg12a8+KSLZnmrg5KwVAViIwTLgFa1/iZIrmNpNQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/20, Christian Brauner (Amutable) wrote:
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -962,6 +962,8 @@ struct task_struct {
>  	struct mm_struct		*mm;
>  	struct mm_struct		*active_mm;
>
> +	struct task_exec_state __rcu	*exec_state;

Sorry if this was already discussed...

Can't we (later) move exec_state into signal_struct?

AFAICS, the only complication is that task_still_dumpable/etc can't use
tsk->signal->exec_state if tsk was alredy reaped (another thread can do
exec_mmap() after that). But perhaps we can rely on pid_alive() check
and return an error if the task has already passed __unhash_process() ?

Oleg.


