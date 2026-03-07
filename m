Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0641FC9EE0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 09:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEC006B0089; Sat,  7 Mar 2026 04:23:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A136B008A; Sat,  7 Mar 2026 04:23:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BBA6B008C; Sat,  7 Mar 2026 04:23:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7016E6B0089
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:23:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB3D313BB0E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:23:56 +0000 (UTC)
X-FDA: 84518730072.06.F145594
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C6C6E2000B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:23:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TVP+pBF4;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772875435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPoaumSQGQDHjPKkao9qJkcUuFlJLf7irl7NQ7E98l0=;
	b=3B4EQ8/areBOlsx8VZDlc7UEvcoTd8rQpFL0hjpaRV7Aoj8opTUZ8eXXCidX6Lvmeh4yLA
	Cvyvq0qJdWlLA4DGA+avrsq+n9HvlRSxRDMuP/3ALZI65HW1FuG8m4eLiQLNhcJj4XixFc
	xdxbrdYplM0Lg/w686Gdh/4vvZScp+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772875435; a=rsa-sha256;
	cv=none;
	b=ruaQ8COSEkvC0SYnOHLMrL2edHI6EDXmWr5lD923Gu9cjbj2izw07cFjZQr6iz4J+3Kkb1
	0Xa//s2yn1K5ct5mVWU8YNM/tsHjE/yTeJ7qw+gdbw6oQWVJ593JvVPZ+7MNcyhPC/p0uB
	MPJ0EkkAkAvX4xyu3+ctsG6c3f37XfA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TVP+pBF4;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772875434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kPoaumSQGQDHjPKkao9qJkcUuFlJLf7irl7NQ7E98l0=;
	b=TVP+pBF4juj4tPRoliwXIVu9ymr7xyMXRn0g7XiMzWijqi20SsNtPP1K0G7JHyq9OxwZTp
	VSU9J6oHhrBQsMAG6yIQ8clhQ1Umabykqot5SdiSyNvz5iGJpWi6Dlm2wO19EzpBydq8Xa
	ETIgWatYqcJrVVutDcROMfDBT1zgzIs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-Pkc55JnhPzCzPM9390S7BA-1; Sat,
 07 Mar 2026 04:23:50 -0500
X-MC-Unique: Pkc55JnhPzCzPM9390S7BA-1
X-Mimecast-MFC-AGG-ID: Pkc55JnhPzCzPM9390S7BA_1772875429
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63A7919560B5;
	Sat,  7 Mar 2026 09:23:49 +0000 (UTC)
Received: from fedora (unknown [10.45.224.43])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 074A11956095;
	Sat,  7 Mar 2026 09:23:46 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat,  7 Mar 2026 10:23:48 +0100 (CET)
Date: Sat, 7 Mar 2026 10:23:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mateusz Guzik <mjguzik@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] pid: cosmetic changes to alloc_pid()
Message-ID: <aavuocRuM2Kmwj98@redhat.com>
References: <20260306190100.1900572-1-mjguzik@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260306190100.1900572-1-mjguzik@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: GQtm9krbLEAAEGp7LBRIjdiM6jJa5E1gDTi4WfToaAM_1772875429
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C6C6E2000B
X-Stat-Signature: q1xdn64ox8npsfctsy8ykmhyymuzzfwy
X-HE-Tag: 1772875434-731640
X-HE-Meta: U2FsdGVkX19cUOe/ik3LswrU09w9YWxWVR6aHbiT8ARQ9gIoWvJrH0kkvTQeFKGO3Z4hHKhGRhrBkH04gZD4KnFaXNovLG+PjOkmI83c5xgj1FHqQSlpAOXvCJGrqtLcgeTJ7ZhABzNIuV9XK0liYO2acfMNxGQ6TVcwwfGttMPBZPv7B42BYM/8rJvkcc8iFYK/toy0O7d1HypCwJAgDF8uIFU+aRgJDaRlMH4vch4s5L/9ZplPPA6Uoz3swpMvDPnZX+AaCj+LN3JQb2/F/MMnjs2MifdUDZ4QO2mcBij2dJWxonTEnzr0AcNNvuAP8xGbfTa08dNPBnffBIUJuBRAlhI2YqZNkuJ2F7hntmSpNMKqVMaVnUgNPVdi9yDwKLhfaLBJRtIiicf8u3sNWR7T1S8AzATDuRlVyAG/jMxvkjUyGfduTFEMzmnyFOGAPMeBm3SpIXdvJWyOoPIhgjIwwDS2Ak2sQdAGxP/1CSVQtSOn54XlucYMh8GR4cSQMB4k7iz5r8lzgy3TyJG7ziGWu2AsG2seHLGEsXG+CeAvsIPrLgw3WYmDnmz7vHmleOai5mCsFNVvkXfKhCQXtcOfLzu3G7kLZBZVouZrlPkyEf1gwZJjyrtDKV9KPGH8QvDVD90zXyBTatuO2wJQNFIxCcE1+dx3l3M+nIzPJLG31a9Fzpla4Auv0d1oyVEiS0QQcb6zOVZ3iZE8pCfuKoJeZwyM0WQw0icSkGw02qQPnR3e102jvT5NZ3MeKeIY9BewuifrBq9ZPBLTuL/94O0TARN6xxfZOTO1XvkNrhgUb6BhsEX6tbXBZ1LABnCpZbrx/ouOsqhjS09aQMYBI23K2DBPdyq5O1+BflSlR9UBOe2AqpkQwY5hDxM16YhBSuupiKXLbFR0tfdZz8tyLY6Cgp2kWZmcWyMz4qNa47Am9hrAK9cIO3VSEgoyCsB9RmMhsf7pzHgU/tfEiCd
 28C0JD5N
 BvWTyBgYkNZb86G1gcRUMApYxgSRI+a2j5M0L/BPLjxkk2cU3pA0ueqWEdm/iud9kN8YC5opTOmsBTcWI4jdgqNXTLINYxJ9cCxwkg/fHU4g8zE1yCqdwwfgWYkkUiDLCq41axfVI9zn05H7+jF4sz5yKyfMO62v/8ksVu8XyMFYz4vnsvrcQ+8P/mdMJ0NJtaOdm4aIBMMVWgvEC/A0TUdE+eHI0F9fj32NFgMmS5yvfrWIgF+F7VBglWoHktD1mo9dfZhzQxNX7hbIZ16fxBfUIabl1eFZCd54LQzRvZLu4Xt0rLxLordlkiQ9Gr/TOOhYfUm+m3AIwzP5+WphZI2XBC8OsnogM/1FL3vNiQqPr6FbFfohT6PdjcFFd97DjWJ7+P2iZ9ODEZ8St0TRGw1GdYHGapGF4bp7V8Q2hQ2Ka5BFEiGp6c3gFVZtsTkGmFSEiWpCUGabxItI+O2dDVq49ue8VMoTEeD8ZB2sTESaP8TntKpGwd9UaWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/06, Mateusz Guzik wrote:
>
> Commit 6d864a1b182532e7 ("pid: only take pidmap_lock once on alloc")
> landed v2 of the patch instead of v3. This patch remedies the problem.
>
> No functional changes.
>
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>

The patch looks obviously good, but it conflicts with Pavel's

	[PATCH v4 0/4] pid_namespace: make init creation more flexible
	https://lore.kernel.org/all/20260225133229.550302-1-ptikhomirov@virtuozzo.com/#t

In particular, this change:

 -     for (tmp = ns, i = ns->level; i >= 0; i--) {
 +     for (tmp = ns, i = ns->level; i >= 0;) {

With 2/4 from Pavel we need to decrement "i" before the ->child_reaper
check.

Pavel, it seems you need to resend your series anyway, may be on top
of this patch, I dunno. And probably this all should be routed via
-mm tree?

Oleg.

> ---
>  kernel/pid.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 2f1dbcbc2349..dbe82062e683 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -177,7 +177,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>  	 * for a process in all nested PID namespaces but arg_set_tid_size must
>  	 * never be greater than the current ns->level + 1.
>  	 */
> -	if (arg_set_tid_size > ns->level + 1)
> +	if (unlikely(arg_set_tid_size > ns->level + 1))
>  		return ERR_PTR(-EINVAL);
>  
>  	/*
> @@ -186,7 +186,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>  	 * 1. allocate and fill in pid struct
>  	 */
>  	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
> -	if (!pid)
> +	if (unlikely(!pid))
>  		return ERR_PTR(retval);
>  
>  	get_pid_ns(ns);
> @@ -205,7 +205,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>  	 * This stores found pid_max to make sure the used value is the same should
>  	 * later code need it.
>  	 */
> -	for (tmp = ns, i = ns->level; i >= 0; i--) {
> +	for (tmp = ns, i = ns->level; i >= 0;) {
>  		pid_max[ns->level - i] = READ_ONCE(tmp->pid_max);
>  
>  		if (arg_set_tid_size) {
> @@ -227,6 +227,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>  		}
>  
>  		tmp = tmp->parent;
> +		i--;
>  	}
>  
>  	/*
> @@ -247,10 +248,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>  				       tid + 1, GFP_ATOMIC);
>  			/*
>  			 * If ENOSPC is returned it means that the PID is
> -			 * alreay in use. Return EEXIST in that case.
> +			 * already in use. Return EEXIST in that case.
>  			 */
>  			if (nr == -ENOSPC)
> -
>  				nr = -EEXIST;
>  		} else {
>  			int pid_min = 1;
> @@ -276,12 +276,11 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>  			 * Preload more memory if idr_alloc{,cyclic} failed with -ENOMEM.
>  			 *
>  			 * The IDR API only allows us to preload memory for one call, while we may end
> -			 * up doing several under pidmap_lock with GFP_ATOMIC. The situation may be
> -			 * salvageable with GFP_KERNEL. But make sure to not loop indefinitely if preload
> -			 * did not help (the routine unfortunately returns void, so we have no idea
> -			 * if it got anywhere).
> +			 * up doing several with GFP_ATOMIC. It may be the situation is salvageable with
> +			 * GFP_KERNEL. But make sure to not loop indefinitely if preload did not help
> +			 * (the routine unfortunately returns void, so we have no idea if it got anywhere).
>  			 *
> -			 * The lock can be safely dropped and picked up as historically pid allocation
> +			 * The pidmap lock can be safely dropped and picked up as historically pid allocation
>  			 * for different namespaces was *not* atomic -- we try to hold on to it the
>  			 * entire time only for performance reasons.
>  			 */
> -- 
> 2.48.1
> 


