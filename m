Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4503F46455
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA80D6B01FC; Mon, 16 Mar 2026 07:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55B06B01FE; Mon, 16 Mar 2026 07:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58156B01FF; Mon, 16 Mar 2026 07:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B463F6B01FC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:52:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F0AD1C164
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:52:09 +0000 (UTC)
X-FDA: 84551762778.17.4C5D6EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 996D420007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:52:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eLKPPkFJ;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773661927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMMpP2PlqEQrh0LsuT2QxskC9rMBKcARY/PvEZa5MQc=;
	b=dWs/lkgxNGtn/swEJ+djdG0lm3Amod2HiRGeJTYSqMX6wyDA6aCg3dWRq6iS79v2DEpaTb
	IGewkb9F2LB7B2uq3xC77C5Hu6F7QJ3pnTFKAX2ou9Ag2RydOrrud17Rnp+QxRqGs50H/v
	hp6X8RZangoxTBMVEf/dt8dfmFO8noA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773661927; a=rsa-sha256;
	cv=none;
	b=bNj8nD+Mt8eKykgbep4uiptNikBmDLsVI2GJY4Lf2AaMdF6Y7BD2W5BAGQeBMZAmQKcphD
	1kVhxK2/2x9/OOzpOozUV/ljeRMc+CwjHzGxUydcu2nZmQAWc5CNrN6BfeGoRxZ2oBIkUi
	rhbJK24r+I7wz/pm+pacHMr+h2AxwuU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eLKPPkFJ;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773661927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iMMpP2PlqEQrh0LsuT2QxskC9rMBKcARY/PvEZa5MQc=;
	b=eLKPPkFJ1sf22SFNYyquHHrJYY9DgHpW34LNz5f1ZwnAc7smm124znp2GV8qR65zRYecie
	n4XA3PbPdiKTSoekoODtn7gmY+N/+3R4dOoZ4h//EFIvuB8c137oXhiyH4awCjrptJcVjW
	IEw4Rn4xEuamOY4yUGrto3JYma1C0ac=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-Esin8boYNg2gUyOr0f2cXA-1; Mon,
 16 Mar 2026 07:52:01 -0400
X-MC-Unique: Esin8boYNg2gUyOr0f2cXA-1
X-Mimecast-MFC-AGG-ID: Esin8boYNg2gUyOr0f2cXA_1773661918
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41DAA1884EC3;
	Mon, 16 Mar 2026 11:51:38 +0000 (UTC)
Received: from fedora (unknown [10.45.225.204])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id C67D930002DC;
	Mon, 16 Mar 2026 11:51:27 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 16 Mar 2026 12:51:36 +0100 (CET)
Date: Mon, 16 Mar 2026 12:51:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kees@kernel.org,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, brauner@kernel.org,
	dietmar.eggemann@arm.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] kernel/fork: validate exit_signal in kernel_clone()
Message-ID: <abfuvq2Wh__7lzZ0@redhat.com>
References: <20260316104536.558108-1-kartikey406@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260316104536.558108-1-kartikey406@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: iXKe_tCRc3la7wtunj8guclWrjYRvBCzAdBheJJ00rU_1773661918
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: xidpshrnoyw35tuezosspxyr14rwh1b7
X-Rspam-User: 
X-Rspamd-Queue-Id: 996D420007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773661927-161408
X-HE-Meta: U2FsdGVkX1/NMqp2MBMWWIoe5B/o446Awh1KzCfqpBY+DwNofsyweGRKfhdrI98jlfl/jUJOdUH0NyAjhaxSlJwlpY01ezVg5oQz9x9fJ0G38/eFPZqcPrJGDkTKNvphSJEbGhDlLFu78ncf4rO+ABknK37FR4YECD43jQiGqUbuGD67veXooq9gbhhbXHEoXF4IjQek69pCI9S/NL8LxwYSDBZC+r64YBalCFv4m5r5eBRhE3wH1mt+EqVsEAW9+g30WJO73e4zzfGaQR6Li22HxvvOdRG1AVb0BoeSyMDYYwxXaQCi2y2CVwMw9WRE579GfGjN28pNQol3LkJas6ZoT2qY9EkP3qkGUWbC+spkJqf55im41bc8XTFHpoPK8vJN4l6tPpabkM8tiwWC/ja/h+tsdaTYZ7+5mCPoJoS3hijWN1iZ5S2Sz2CAHBDK2rvhun3eOWEayRR4YSCZ8gl2iFlW1HnMH1WFqByoxUoO05am/M7mQLSVr8iAEjLAHXmzd5YXEBk8RAS2oV7AzLu6WRFOQGzR/FMBstNt9JExgnfXwzyghIRG9UJrA4XXo4IU1FUL1kxODJr69D4FsbSURetVLk9fx4LnSNFZJKlg3dALSdnNtfjLQuUUyw5o91wK8d6dfAdypdpaFTiNW6CYSiQ4wYCdH94jD18sgGMVlVcMQBJHnodYlfCIN67bT4j1CRgluDH4vEqJBSI+oBLEHMXo9FDo5W1K9bT4OWIVvhQlob3roVrP2lL5dimVMS5IqcgNXh0CsLev9S+g7kmVqCdTFMgGxUa30s/YoPUW3fMKmtPvOx+IBwVDdDPLZ7HraolNZOxkNJJa8dHalDA6594HjujnagEm4WLwVQ72sBJQZYU7N/cdJj79l31p7LktAcH3zMUerOXlbbtHfvEItRMQ0VdFFoRL6KP4jqDPaSHuzRaMV0b256/X1FwbZQSeME8wDI2gHgXxrzq
 gjWjSABG
 ungz4vFNdW7HdQeFJHsA168KiYTJAlTA/wqYrfOIKUAYuqjuUbXRiKgTYgymVCtqB0ios6Z2xRoxdPIDY6Jg6iDmdTi9NmJ7wcfDCjjKmdGoJM1M9B/e5Jlon1mcS37MjRXFSKPa04fDMcqre8q66/7NkjckUnpWY/rh/yIjtG8b7peAqWYl/e7k/W1WqdegbT/IH+UQrf+jW1x8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deepanshu,

Let me repeat, the changelog should be updated.

On 03/16, Deepanshu Kartikey wrote:
>
> CSIGNAL is 0xff, so values in the range 65-255 are possible. However,
> valid_signal() only accepts signals up to _NSIG (64 on x86_64), causing
> a WARN_ON in do_notify_parent() when the process exits:
>
>   WARNING: kernel/signal.c:2174 do_notify_parent+0xc7e/0xd70

Again, do_notify_parent-sanitize-the-valid_signal-checks.patch
was dropped. do_notify_parent() won't WARN() in this case.

> Note that this is a user-visible change: previously, passing an invalid
> exit_signal to clone() was silently accepted. The man page for clone()
> does not document any defined behavior for invalid exit_signal values,
> so rejecting them with -EINVAL is the correct behavior. It is unlikely
> that any sane application relies on passing an invalid exit_signal.

Yes, it only documents that if exit_signal == 0 then the parent process
is not signaled when the child terminates. But in fact a non-zero non-valid
signal acts the same way.

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2687,6 +2687,8 @@ pid_t kernel_clone(struct kernel_clone_args *args)
>  	    (args->pidfd == args->parent_tid))
>  		return -EINVAL;
>  
> +	if (!valid_signal(args->exit_signal))
> +		return -EINVAL;

OK, but then it also makes sense to remove the same valid_signal() check
in copy_clone_args_from_user() ?

Oleg.


