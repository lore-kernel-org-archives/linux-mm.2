Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B0CFEDA0F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFF36B0096; Tue, 17 Mar 2026 15:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90B06B0098; Tue, 17 Mar 2026 15:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA66C6B0099; Tue, 17 Mar 2026 15:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 988636B0096
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:08:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CE4C571A7
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:08:25 +0000 (UTC)
X-FDA: 84556490970.05.9C15140
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id DE3A820011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:08:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZowhB4Yb;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cMncruhV3zGKox3/ctrnX7MA7dyJ750pVWwUyV32A0=;
	b=YDeDXQBwDWUkRwib3beK3famoEqz801QByFBandHS4xw4/pjbGo8ohypXY+tNa3C8TaKe4
	ylBeVvbWlYp2as7VkzbPqOdOc6i7XTI/nA6EBbKljVNwX9rPFRttL2br7g4+aGZrOF+D9/
	xd+2QWnEHpJ+A2GYYu8XYXD5TvSU37s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZowhB4Yb;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774503; a=rsa-sha256;
	cv=none;
	b=zcQDzOJm7bvVqCArARQCy13A183cePmGUPgFFNHK1gZVG8HIrwxvr2i5pa32q4JTFeSKfQ
	yjF4sw2R/4HNSWPiMnZ2CdexsijRi34LQNK3FNgAHTzYNhbciwYiURk7Juhrkb617mRzua
	p2J+V73x/zpaObEynGnE+RV5O+R7ix8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773774502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9cMncruhV3zGKox3/ctrnX7MA7dyJ750pVWwUyV32A0=;
	b=ZowhB4YbTTdF8rV+ziUMo6dxTMvMA6zLMfBRwp5zpYse0ZejYk3JFV79PLHYBaMYrbJYMh
	C5uIeBAaqPBQAqLmh2VyznZx61Dola0POd3JThA3bDHL+LaT5zdKdqtYDxGzeXhANgn9ws
	xo1ps0UIDiDHexdhshVDnrzmjpZXpeQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-eCvhrhSaO-murqpA7XqfXg-1; Tue,
 17 Mar 2026 15:08:18 -0400
X-MC-Unique: eCvhrhSaO-murqpA7XqfXg-1
X-Mimecast-MFC-AGG-ID: eCvhrhSaO-murqpA7XqfXg_1773774497
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E4BC1800245;
	Tue, 17 Mar 2026 19:08:17 +0000 (UTC)
Received: from fedora (unknown [10.45.225.204])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 9EEEC30001A1;
	Tue, 17 Mar 2026 19:08:15 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 17 Mar 2026 20:08:17 +0100 (CET)
Date: Tue, 17 Mar 2026 20:08:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal()
 checks
Message-ID: <abmmnjgxrrGLKn2D@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
 <abld-ilvMEZ7VgMw@redhat.com>
 <20260317113452.cede9a514dfed36a1cb0e5a9@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260317113452.cede9a514dfed36a1cb0e5a9@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: a2xWOlorrVdZgsYviiGMtRJ3yYPZjWNOwAmkN2KTyhM_1773774497
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: DE3A820011
X-Rspamd-Server: rspam08
X-Stat-Signature: kfgyxibxu36p37f7mrrckz7ox496mwxj
X-HE-Tag: 1773774502-77199
X-HE-Meta: U2FsdGVkX1/+J19zrcGYbw9VX6RdglftvVnhnIYHdktQCD4qeEVgencEufKPD1M6G+Z+eQgJgYItudAwE07zY4Mdk1MXAwo8OcuKacKW4+4sNJmUIqVOb5GKo+qWZ0yw5X1BFDuFNpkqPlAjZO6MlIsfJIRs14jPtT3Sq7Rs6o9mlL35r5aB6l5fwcU11MLEIZ6aDn6xit1OoI1YnB5AzyZIIdpOiTmSSeb6j1Kk1L5v0FZl2+pk/LnKSGiUy1hPcjfnVw+wEbp6eXmKhgeplDyyuO4BOr+ACtDKuDcKmZh19Qb7YtS4eEeAeY9ZKhDiZFAbuwC5c6aTyGA197bKSCJQQhPSuUBt1NHKaJHIht4VQzH1Pjn0dH48Anrgko5TRSIm+FCQaYgs0H9DSA4ysl64bf1UkpY5jYaigclucZrMaOM3Ae8AS7W3+VIov8dlkM1O+0NFwmqCMXAZ94sBi7pahFN8fDYG7d3x+od/YzItCYY24BNpgFItgRYg2xyRRg9k3iHsZy5WQYSFKhMJpRMSLxQ4UAQP4TnhuxOv8mquZBpOjg8z+sOALOHBMjPky8Hg5+qVylHE968xYIoTirc1sB452pESsyO9JmlrzHianHkEBBkJXzshVExoYM67h07txzwSyCy5zoqsf6s+LscSYhSkjU0Q3Gma4RWKp9e+4CD5gj4XF7foe++Qiyv8NjjXB9I+ml950pYoDwOimajS5FDWJ1Uw428TBzOzbZX+zBw9Kwa8G9mCa6+LrikCx8wwu5eMd7UPVCsZoYiHlrqyIBml5q6IJFvYvjbOyBeYVjS2HJta2pn/9iQAeuWk6jA5U70YgVM16E7JXB2+R3uGXPaArFlBOzbKc3S26kk0AnIOVNj/LQVlQbE8kkiLCj9+lzadlBoUcUTFeeU5esSNf5tS9IsJCUkWK6EUU85EjlvpWfaFwn81fzG7338H9G527NbXB2WtZnnB31t
 J17mXa90
 14Uz0IdkEUHbH1z9nbm6fyTwC68eLcHeLgTTJ8zvgYctRSWyV69YhhRf04LJe8MrknJ2F3yfovxzlDlckGb6rofqvevQrPxecXBZt3I5UO/Ed+bzaUzybnq1VRyR+Orijjr0MMldPCqC1nh0hpzzJzT+C4MQpnaca8ZIuVdRkWFOqGQHv+gJoNR1H4x6kyRffZdjIpSHBL5vgrmoqrkucN4mvlM/AN4HBHdC10VUPMgFMt7txdJcn7S2lpgIijyeOysuKeEo5g/4YbSLkuOslLg8tv1eAAAvOJypl4fdTsgeT+DQMsuCHvTvsfda9MjMvH0/touj4ZFsV8k2Zb7K8USl5TKOzddkEM+9X2M6YAZCyFZvaMtPlYg1UDD3Vqasy011D0Iwm+884CE6LGiWU/FW0P7+OWjgwN7DzqO5LFpWG8bNys52DseAGG1+pjcZ5KdXq4nnSZfm0hv5+lAQBvobMh3Cls57AvBtH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/17, Andrew Morton wrote:
>
> On Tue, 17 Mar 2026 14:58:18 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
> > argument of do_notify_parent() must always be valid or we have a bug.
> >
> > However, do_notify_parent() only checks that sig != -1 at the start, then
> > it does another valid_signal() check before __send_signal_locked().
> >
> > This is confusing. Change do_notify_parent() to WARN and return early if
> > valid_signal(sig) is false.
>
> Sashiko has a question:
> 	https://sashiko.dev/#/patchset/abld-ilvMEZ7VgMw%40redhat.com

I think that userpace can't bypass kernel_clone() (which checks valid_signal)
before copy_process().

This includes ia32_clone() and sparc_clone() mentioned in the link above.

There are in-kernel users (fork_idle, create_io_thread, vhost_task_create).
But if they pass a non-valid exit_signal (they don't), we do have a kernel
bug and WARN_ON() added by this patch should catch the problem.

In short. From the link above:

	While kernel_clone() expects the caller to validate args->exit_signal

this was true before

	kernel-fork-validate-exit_signal-in-kernel_clone.patch

from Deepanshu, and my cleanup depends on it.

Oleg.


