Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F5D7C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD386B00B0; Tue, 22 Sep 2026 08:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437B86B00B2; Tue, 22 Sep 2026 08:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6D06B00B3; Tue, 22 Sep 2026 08:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E84296B00B0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:55:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86EFAA65E4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:55:56 +0000 (UTC)
X-FDA: 85241395512.04.9EB9F0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A75C180004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:55:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dNojPstL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081754;
	b=8flUSIPqhMvpQSwPQflGf9PvHd9EesBm1KOFBu12R/JBZwEX+jd1IAUUcZ5l/Y0ONMqvJX
	OlgcndQ3bS2oa9s6FPAxD74hJK1JzlRwMLEg3+hOcyY1NjNhYjPUS4oAX7Em/Qny2UT2s7
	qPbpztKtBhHH0NgsmH3TgNzsDW4n2o0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dNojPstL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+Q202Ulk36gGraSq8aGSjuKZeytZD98yewc/uwH6yE=;
	b=dyzBnSkEH71bmUJynd9oMt9oUpQ7GUDEZvGOS17jYrzVC1lls9/DUWPEDRwLyfHr1Dg0DP
	WFT3ApOrbMg0UTcJtXbvWtaqrTiL6tMe6tEmD0RGD+icbxnxW5CdFZc88I0hlBS9HeXevC
	N80JtHHYRyf6DDeCuyWkPzM30f3TIJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790081753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q+Q202Ulk36gGraSq8aGSjuKZeytZD98yewc/uwH6yE=;
	b=dNojPstLO2j0ctNTsv6SO+9aqgJ5u2DOFZk+fl1ruI8NZW4ZrNUOjyNRFKX/b5PoZzUVUo
	XELytVRiqxosA0BpRvNWlFEnb3J1ri++UoKsKGYPT7/TumSnhkbN3/WJbwQSriXgurMIYR
	uXTSTyjE+ssZ7HW/l4+O+QF3g4cVNWo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-Cetgdzf5PD-aejzMw1bNew-1; Tue,
 22 Sep 2026 08:55:50 -0400
X-MC-Unique: Cetgdzf5PD-aejzMw1bNew-1
X-Mimecast-MFC-AGG-ID: Cetgdzf5PD-aejzMw1bNew_1790081748
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AC7D1802171;
	Tue, 22 Sep 2026 12:55:47 +0000 (UTC)
Received: from fedora (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 545E21956042;
	Tue, 22 Sep 2026 12:55:43 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 22 Sep 2026 14:55:46 +0200 (CEST)
Date: Tue, 22 Sep 2026 14:55:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 02/17] signal: only SIGKILL and the freezers interrupt
 a coredumping task
Message-ID: <arJ6zZuI59BJnXpl@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-2-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-2-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: XNDFyLPnHOkCy4_gSxeKlI-GCHEZpqabr43NH0V6LEk_1790081748
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Stat-Signature: r7wciyp5do4pzsi8fp878da7nyqwrwbq
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A75C180004
X-HE-Tag: 1790081754-817915
X-HE-Meta: U2FsdGVkX1+81mzie+toeZUjhniHigMMptZ3w5Qrs0TUI8yrnBvVo50mZMipRBpUk+OpyMrwBHGvx1f/KbS4ZUERFbbmvUPIDAU16pb6UOGLmSxywOneyutioAvtG2IC63UVml+Sphp/Wdb4wLsIwutnQxrqTJUJNl8kYgq5+n/VmNF7tNKv7bvDCiKw+n14jnhAlZs+cTLHB788tFcCzKlUt6GYsj6Gl9UpPGxneLJCoDccRq9oaZsYY34gFgaKZHC5KbNG6ncj8ABi3wJF7iV4EJmlDTmZGzFQxxEvQEIJq0FPNDBLC0zX204afX1g1+G7LsvDsLn6cqKOHOJjE11ReDxZSC6mxEaWKkGCAq+Ety0mjBBjSh5YYpbdFfpEDaLKZDSwpjnT85boRYHfxRWOfNeBCVV177kzhYtGarCNmGpPnYgp8Y9ALt3OoMEyaraiurTWGxSeMAzKe8uduRIb0auE2S2xom4dVCmy8dKjSVffwfXb6YZYwuLgXSzlYrmU1lmJsyrupMjtkrtdgnpYIjKNxEKOl+l+saiIR/dh5gjSiN+PCAcuozmq6m9z2j9eFv/jmmUdbn8cnoOFRxae+dwESJoFfX32zXqARljlpzk22hpfxnym0HcwJdVcICQfFFUhO4UupOO3BXu/gnslTLS+t9tj2F4zJw9UgpwC2+Y1pAwXAIkUa/1RSUAoj81Dos4dEaypM2YJTwPLbBfpFsJ6c2Q73Cp2+xYmnSex6aD8hOAYwQRnmAHc0DlNugocxdD1RSQJU1gculTFS6WaQmkBNASwHxZlZLoIm1JA4rc6NvQycZKuYyMVjMt++krp6Purzr2fr5ZZYD+DlcQQNLledmKNHR+AXedewrw5M13IsOs9B7N6MA+vgudNsQyp1HpKYU2IbMVgGtGPrUQIrpSU7riI5U7dLo+qQV6eWA65AR+NqMG+AmUL1li3mVgZh38Ra/0WiIUp0D6
 JhaXPcg8
 MDsjz/L+HOHr7oC16YcaF1D2VwEzrCbJ/xrkVps/63B+QeqArJ7suNJu8X1MapTIttm5VW4ACfV+mmgZ8T2J8xGBzHAjsbt6mLMTRsF185dtaXK5j5AF4CIvSDwAbcTpWdxEhqBC7gsDLLLQ4xHdd921HFdOLwao93DwFybVH1zEswelz6sPCPeJOX37BMk5PFTfcmqDspZtlY2g6xUemFbVrxoe9GJU3HxHxebqiBGasbQfTAHLCFg9Qeh6RU3w8M5eEKrafMjeiUq9fZWyN4ZZ/r/UEmA+xgtfvW5Pr353BVi7Pf9vsCmg5LBglkyrL+1we4Ak9t5bomHpKe4CinqDu93338cphQC89
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> For quite a while now coredump has allowed either SIGKILL or freezing to
> interrupt an ongoing coredump. Since we seem to like it complicated
> "freezing" can mean a lot of things:
>
> (1) Power Management induced freezing
> (2) cgroup v1 freezer controller induced freezing
> (3) cgroup v2 freezer controller induced freezing

All of them do signal_wake_up() which sets TIF_SIGPENDING
However, zap_threads() clears this flag.

With the recent changes including your PF_NO_NOTIFY_SIGNAL and
05/17 "signal: don't retarget shared signals in a dying thread group",
what else can make signal_pending() true? Apart from SIGKILL.

So perhaps we can simply do _something_ like

	--- x/fs/coredump.c
	+++ x/fs/coredump.c
	@@ -508,7 +508,8 @@ static int zap_threads(struct task_struc
		int nr = -EAGAIN;
	 
		spin_lock_irq(&tsk->sighand->siglock);
	-	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task) {
	+	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task
	+	    && !freezing(tsk) && !(tsk->jobctl & JOBCTL_TRAP_FREEZE)) {
			/* Allow SIGKILL, see prepare_signal() */
			signal->core_state = core_state;
			nr = zap_process(signal, exit_code);
	@@ -583,7 +584,7 @@ static bool dump_interrupted(void)
		 * but then we need to teach dump_write() to restart and clear
		 * TIF_SIGPENDING.
		 */
	-	return fatal_signal_pending(current) || freezing(current);
	+	return signal_pending(current);
	 }
	 
	 static void wait_for_dump_helpers(struct file *file)

?

At first glance the change in dump_interrupted() makes sense anyway.
For example, dumping to pipe can't tolerate signal_pendin() == true.

What do you think?

> Fixes: 403bad72b67d ("coredump: only SIGKILL should interrupt the coredumping task")

Well, I think we should blame 76f969e8948d ("cgroup: cgroup v2 freezer")

Oleg.


