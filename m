Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B34FD877E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EB26B008C; Tue, 17 Mar 2026 10:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3085C6B0098; Tue, 17 Mar 2026 10:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6F96B00B9; Tue, 17 Mar 2026 10:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09C7E6B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:20:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B54F31B704C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:20:19 +0000 (UTC)
X-FDA: 84555764958.03.E11E7FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9A794001C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:20:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MGKLd4OO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773757218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5TIGwUxO8zK51/lXLNkPxBWxtqqdFPAT0HjWoHZs+s=;
	b=sH5c7SfITp+/mbp2a1cHfTymWn6pbx6xuieXSSCpRqosUwaShr1Ebz4kjmBxv5k8qYQjJ5
	wC9YHqVkpcXCZRU+RM09ytwOnBGXrsxfJ2+Q2Ei7MbJPfXePTzrZpeguQfLf+PnGOJ4SXP
	NfwiSdHsxKzHVjuhT8wuP2puQf3Lnt0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773757218; a=rsa-sha256;
	cv=none;
	b=Y1r8EySjnOUJNoj9dCqnQZdSoBxztnb57z1uHwdAIGfFNI/i+Px1qvzYYmfz/dQ2NVvR18
	JdTjVJrH1Q5Ff8E2ZSa/lO2Bs7xHL6fh5v2gbbo/1Mt7yL9n2EI8qAo0RV4E0GEetVl7En
	A14tsBtD2tahr5mBLHtecyWpLZgv+5g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MGKLd4OO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773757217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D5TIGwUxO8zK51/lXLNkPxBWxtqqdFPAT0HjWoHZs+s=;
	b=MGKLd4OOfaYF4g6JRnkHLHzlMc1ypQV09sF6P2mbczLIjCaOr1ExVE74kQtRaLGB7IblSn
	dAO1qxQJn6k2JQxKugwYUtcKhZb21s04uML4W5OmQzq4npLhv/n/axm0S9RA5BMYjzJ3nx
	PDOodpGu/BTOA4etAfAKxlQMUNLlnU8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-H-cnHrcVNoi9oF7MSpb-sw-1; Tue,
 17 Mar 2026 10:20:14 -0400
X-MC-Unique: H-cnHrcVNoi9oF7MSpb-sw-1
X-Mimecast-MFC-AGG-ID: H-cnHrcVNoi9oF7MSpb-sw_1773757210
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E382A1954B08;
	Tue, 17 Mar 2026 14:20:09 +0000 (UTC)
Received: from fedora (unknown [10.45.225.204])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4EC5C3000223;
	Tue, 17 Mar 2026 14:20:00 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 17 Mar 2026 15:20:09 +0100 (CET)
Date: Tue, 17 Mar 2026 15:19:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kees@kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] kernel/fork: validate exit_signal in kernel_clone()
Message-ID: <abljD-pLFI8B0D72@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
 <ablNqvlB9NQlRcw8@redhat.com>
 <20260317-federn-umsiedeln-3afae949282a@brauner>
MIME-Version: 1.0
In-Reply-To: <20260317-federn-umsiedeln-3afae949282a@brauner>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: rAO1pbj1ItpZE6E7Tn7JiEAtop2KQ8SDoNc5ooflvqg_1773757210
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9A794001C
X-Stat-Signature: wpdtwfhz8ni63zj6ue5pqcqh3jm6jy5t
X-Rspam-User: 
X-HE-Tag: 1773757217-18946
X-HE-Meta: U2FsdGVkX19lqefi5612a5/818FftWdVnkd/6NQVKI4CcSpCzqWDaUiLPYnavp18WH4Ui4LPpTX8JKzAdj0FSKP64Gd3X+akNIL6BHewDEoZD6oDjxkMAZabBY4/2cN6Z0VPQq8EkUBdsgDRix6ZSTpElRwL//GVc3mo+3utRmFR9vPC0n9uO/xERJzd+O3pEzLy1iZH/4mGCeZgxb4brn10aknyEsELcZskP+xZsTzXFDrmTDpynfpmQQyS1gFRcctlJBHqU14u3FnMLncW4sP2XBqASRs3psXMwe/Zm7tZpgNSQQeKU3G52Seax8NT0MRanB9C0nJTGpXTYygJDa8ITr2w80bfI0QUA1j9fa/CM5VBcbx379gquzjeYaNb79Q+tF8XTfRotaJASk+Rrv2RviS+j9zTd6dsEloZANMATEZe3c4Q1GikuxZU+C7/x3WLaUG1theDUFk2Oyi8V0grC5zf233LPCKJnyVCIdPGPhxSoIBcS2qthWi+7Usm0eJLgQ68WOvRL46TCco2qXdbJ+Swq2wm01cbbNstlZl8OrqdHp1ry/MEagiusQq+eZJTbs9hIa6hiInPTWtGg8bj///r7EChmxPCd3m1XTV5dF3aCfrTo6JmOOt8BErxgJGaprAXK/6QSqkKY5nvIb0WOfMwv3FApx/TEEKCp0eDE0bRfJfQpCZka1j8KEoGligT5a1Do3mIIsuqr0Ly/BCyMzYk1+wFl4uFQuW28BNMAFP0bOqOvW7hXQexzIjtwGb2ABba02U1ziWoke5tzeP3Qy7en5dCTCgWSd5dRqqOjQFrpNgfaf1cerxn96FMmk6u1UjzlvlJpvUF+/ouU5leNMTinOnRvK0YfxHmmcFL8Jb99grqnEVxSB1Nwvy3p93InfhPXC2AfcNz2IPgOUTNu3P3DuVBEwDAi87e9oZlsnZgx17KFyZ2U/5lM1j5geFoOhW8mDi5P3w8D74
 9XZG4yNN
 34vOv8LHd4yCFu6DLpC77IhvfVIKLStPsIuswOlFeI38ECCrOhln8MEXjh3tzLdkPT4tAGRQfAZPAlWv9f6SdAL5ftmmeJeQEt9NwUY5v6v3mo6DHtlRSx0z9Oh3J028VbEjp62pkd086kgQpT/RVBxn1Y5mjCv+j7qYlezc7aWJn+YCWF50mpQWpCKPNt4K4Zj5phK3dgfNaVMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/17, Christian Brauner wrote:
>
> > Andrew, I will slightly update the changelog and resend
> > do_notify_parent-sanitize-the-valid_signal-checks.patch
> > in reply to this patch from Deepanshu.
>
> I'll take this via the pidfs/kernel tree. I also have a bunch of work
> touching this stuff queued there.

Ah... Then can you also take

	[PATCH -mm v2] do_notify_parent: sanitize the valid_signal() checks
	https://lore.kernel.org/all/abld-ilvMEZ7VgMw@redhat.com/

which I sent a minute ago on top of this patch? (I have trimmed the huge CC,
so you wasn't CC'ed).

Cough... and may be another/unrelated

	[PATCH] pidfd_prepare: don't pass O_RDWR to pidfs_alloc_file()
	https://lore.kernel.org/all/aZ8gwQYpIjVktcOs@redhat.com/

which I sent you almost a month ago?

Oleg.


