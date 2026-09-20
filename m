Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C95FC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 15:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6FA26B0088; Sun, 20 Sep 2026 11:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D200B6B008A; Sun, 20 Sep 2026 11:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F576B008C; Sun, 20 Sep 2026 11:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 993B56B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 11:15:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B22BF16049F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:15:23 +0000 (UTC)
X-FDA: 85234489326.27.8B10EE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 648BF1A0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:15:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=htm0S7lQ;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789917321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPP3HBXD0HVoCCj/kBuPA6/lcgb/IF+n7p3Pg2EkF+g=;
	b=g7K36MhisZqrbAIIyOtYohJlYKbza6fxB2QpkLb05Tm/fTwwJ/cm88zTQ1UpI26Ei9YSKg
	g8UVamXVNXAN2n+eQIXH7+nGOdVRPi7XMEGDsemqNSYn/DmEDHd5Deg1X2Nh0RquXUlyQG
	PPB4UAaOtRKO/ep6ILwDI6e49HjnOhM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=htm0S7lQ;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789917321;
	b=yQa3G2F6il05U+gdPqEkH++fUTfUb3CNboQRUs72jRsgyFe/8xXd4LzfwObvK+t5StZkCg
	rLrZak21NpqQM2EEGw7nK/j6mU4Zix0GwI0FmOw5mjARqoUPsC9z06mzcNl7iHc1o/gPzS
	q3Nm5C2lwNLXDEweIoBw8X7UEY7ybO4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789917320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jPP3HBXD0HVoCCj/kBuPA6/lcgb/IF+n7p3Pg2EkF+g=;
	b=htm0S7lQxePtjOgHqz8YM9IzTV62G8f9d4w9J3VegL3c7wUIXyejnPwuALpOoJ5oWaP99r
	avwVryqdOYfMOaVHVBvnV737dJxsFuWulTRbDWWSkzsJ5UfvpdgVuE+x0b66khq6tJptr/
	DIUZSmZlDwKjH5uh8ctOfVpJtrNH3Nc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-189-GlfUHkt8N1uLLTONHapGaQ-1; Sun,
 20 Sep 2026 11:15:17 -0400
X-MC-Unique: GlfUHkt8N1uLLTONHapGaQ-1
X-Mimecast-MFC-AGG-ID: GlfUHkt8N1uLLTONHapGaQ_1789917315
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6C3118009E7;
	Sun, 20 Sep 2026 15:15:14 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 9D0F21956095;
	Sun, 20 Sep 2026 15:15:10 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 20 Sep 2026 17:15:14 +0200 (CEST)
Date: Sun, 20 Sep 2026 17:15:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: NeilBrown <neil@brown.name>, Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org
Subject: Re: user workers as coredumpers [Re: [PATCH 1/6] coredump: don't
 switch a dumper that has no files] table
Message-ID: <aq_4fY6GVtK47Njq@redhat.com>
References: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
 <20260916194837.3732307-1-mason@kernel.org>
 <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
 <178960987412.207413.3957049392884487413@noble.neil.brown.name>
 <20260917-zahnpasta-aufweichen-flackern-1182320f5c81@brauner>
 <20260918-tonart-umgeladen-gesponnen-519fca5172bd@brauner>
MIME-Version: 1.0
In-Reply-To: <20260918-tonart-umgeladen-gesponnen-519fca5172bd@brauner>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: BBMLw8KVciAbaFCLtvEkYgMAbwqIrSOrPNQufVncMQI_1789917315
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 648BF1A0008
X-Stat-Signature: kgyk3ows3fhnsbzxnnosd7hny77bjmh7
X-Rspam-User: 
X-HE-Tag: 1789917321-352383
X-HE-Meta: U2FsdGVkX1+JLXiGC9O4d+AzHmf5rFzSPQll4bIVx53e+o54DJp+idx6ooSdAp4m+ESqYhgMar3tSD9rQumxtwkIyN+MYhYkbUHGUxECvI+q7wj2mNrN91ujGRNJ9sT7izDXK7unzXO8nSeFq1gWPoPTew7Fy1GmYtokjQ1D1w18ziyYgn02sfYkLqEP8cNqmBGGbjjbEFSdFK29uHs9c+63lPyFalTl/3dJtKgT+mbkhpiP5Cjrjoh6XEnJ+H7SjapB7hkh2gycwHKLSPu7qkrFgQWA0xQD/0D91on6cKgOuw8bLRfjfzo/n6R6jFX+ShZEVAm0Q999ytrzpSPc8ohuawcbTAKTvnDQTygJf7gIAU6o5Vz6Fr5ZqWOdNDVEd+TK8iIrCARbhBA5bP9RKeBJd1tDI8vGXSqL+YkqVHgpR2JvGbp+2oeYPwKNPW9mRV/ByXNjEUANDqMqPE3F64Ht0xngvdu7UkOm3wzSmhZL9H41gobvtnI50Qc8lOy5oSbQeUMoJGoh5bhiLxOw77YnjBsvPU9dAbuqt02OsE1OjXAfMT2b22zyd6Tg5Mky8114fQo6yncxXPjIy8Aw6I0+Unav7R3v45PpKuMOUM2S0kAz2zeB1lekkPpiXRR91VtIZnHfU24gta7hyHLF30VA+bFX8vsoXenrEDDikx1aWYZuaa8pMwjns1gGSpBWQsCk08Ydw3NSIDh7caLUvSaPzrLNYXCqGtyASW0TlzdUL4LXgdhypyNlW7rrE2gmmOZmmZnvzq1O/WDCpRoJinN3aqDCcfYPtCuM3KKvitQSn7vgg+5aZAwKhQHt5Xj9kYDaisfCpeNDPpmn6cVhZoox7HrNylpm8XcxC8Rg0Gpzvv+1+vNTFhbUPYlnohVByS2lJPZNjKgM2OFoxWGdFT2dOw3mTDIkQa3kCsRQl8XlZcvtl6JfDodxUKR3pCNxY8TSbWss7Bq81bAwNtw
 Al1jq847
 0GXwx1X1i1dBfqRyj+090HFUQbZMKCWkwJLy4CH62R2MN1X3dytf5yjzbD+nH7eZwMIyV1viFMDv7HPr8dCQe9dJbqfTZ6piX64cSQ1xeJOpCxkEhBcpkR8zoSYzmkBmlbg5fSJwhHuW4ceQrjp+HdlQC6w5MIgbbGDee+JXkbm9CHf1Dpsqm2stH2eUbPn0AZ2P8GNf8i1FH7i6YXt+BRSaAkdTQH3opHQcfcZ4R4R6b9nRhPAIPVK1uxZO6/Boyc9ZSj/S0W+9i7L+ujbol7OS8bt5xz7UuGuYYqB4e4sOLxU83aJuvpNo7WxsaM2+bpwPfUGAMi9dYDaAkqlSjtR9Yy/qvZlZ1MoOS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/18, Christian Brauner wrote:
>
> So I thought a bit about this yesterday and had some brief discussions
> bout this as well. I think we should kill this whole bug class by
> ensuring that PF_USER_WORKERs never participate in a coredump.

Agreed,

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3021,6 +3021,21 @@ bool get_signal(struct ksignal *ksig)
>  		 */
>  		current->flags |= PF_SIGNALED;
>
> +		/*
> +		 * PF_USER_WORKER threads will catch and exit on fatal signals
> +		 * themselves. They have cleanup that must be performed, so we
> +		 * cannot call do_exit() on their behalf. Note that ksig won't
> +		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
> +		 *
> +		 * They must not dump core either. The dumper waits for every
> +		 * other thread in the group to exit, and a sibling's exit path
> +		 * may in turn wait for this worker's own exit, which only runs
> +		 * after get_signal() returns: io_sq_thread() ends up in
> +		 * io_wq_exit_workers() and waits there for its io-wq workers.
> +		 */
> +		if (current->flags & PF_USER_WORKER)
> +			goto out;

This probably makes sense anyway... but see below.

Perhaps it makes sense to change ptrace(PTRACE_SETSIGMASK) to fail if
child->flags & PF_USER_WORKER ?

Currently get_signal() from PF_USER_WORKER can only return SIGKILL,
I think we should keep this rule.



I don't think your change can fix all problems. Suppose we have a main
thread T and a PF_USER_WORKER sub-thread W.

Some signal, say, SIGHUP has a handler. Debugger unblocks SIGHUP for W.

Now, kill(SIGHUP, T) can choose W as a target, complete_signal() can
choose any thread if wants_signal(t) is true. W will "drop" this signal,
its signal handler won't be called.


In the longer term it would be nice to rework this logic somehow to not
rely on ->blocked...

Oleg.


