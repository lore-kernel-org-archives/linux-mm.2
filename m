Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304A4C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3476B00A5; Tue, 15 Sep 2026 11:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F4B6B00A6; Tue, 15 Sep 2026 11:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B546B00A7; Tue, 15 Sep 2026 11:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D554A6B00A5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D67BD1C253D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:39 +0000 (UTC)
X-FDA: 85216340958.08.CC29AEB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id BBF8720006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GXr2pwCm;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485216;
	b=wXytKaS0Vm1OkVvLU2LnMrw1IsQkn8W2/DWmKYWWwu6IgtahHSVKXMJu5Q4fvwPnsNzbOg
	DyoXMniUopWggyQzkla4BEd4nm3rBSreCQh7yr4fyIlB0ukbMJYn8zq1+lvg4C+Z5mdRNK
	aS3NV9O8T24juks9HEkiFU6/rhh6ka8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GXr2pwCm;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2PJAn/L7ZQjvu205LAClwiudMULOGyRoDYDF+juhzk=;
	b=SHKsKMErqD67JcGA5PjueM+gGd63bvhaekaKaASoIP/1PQ+RJHiurfwxirZSSTrOtzBgtU
	X6vYyLFoSjwAOH4C5KJ0ULg3KNJF7EiuIQpfvK5lS3+FAa8YsN79mUKL3XKYHvlu/oUjVA
	xkHCY6uPYcEdQVX1FHKHGYDKeu5ffeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789485216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U2PJAn/L7ZQjvu205LAClwiudMULOGyRoDYDF+juhzk=;
	b=GXr2pwCm1zmoWU3rMtUth8m9S8YYXnHI8t9mYiOdRi5jY8eLFcrNDq/Hm7NxX7Hf8auQC3
	U/D5uhPknPcMbZYpzR7hS9dF7W8JtH5PtM7dtym3zq4PXGnXEQnLADDZ9wZ2bR4PnWFsfq
	W8CWVwhmzuTuPiqlApsOm1Ju10BQiUc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-412-exUphlHtMCWEYxi51V94Vw-1; Tue,
 15 Sep 2026 11:13:32 -0400
X-MC-Unique: exUphlHtMCWEYxi51V94Vw-1
X-Mimecast-MFC-AGG-ID: exUphlHtMCWEYxi51V94Vw_1789485210
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BAB7185FCDD;
	Tue, 15 Sep 2026 15:13:30 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 81D7A3004188;
	Tue, 15 Sep 2026 15:13:26 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 15 Sep 2026 17:13:29 +0200 (CEST)
Date: Tue, 15 Sep 2026 17:13:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/6] coredump: hold RCU while releasing parked threads
Message-ID: <aqlglWwVeh4rwL0q@redhat.com>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
 <20260915-work-coredump-fixes-v1-3-f354ca41780c@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260915-work-coredump-fixes-v1-3-f354ca41780c@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: rZhp_sAeJBaR_rpHEcpdUhu12rnBlgFpox8AvgV3aOU_1789485210
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBF8720006
X-Stat-Signature: dnws9mq5scopurwkjryrifuehnhrz3ed
X-HE-Tag: 1789485216-817321
X-HE-Meta: U2FsdGVkX198dixAjcgmr8lksp3Y0sQOqnk0R+GI8Is8TvthGFcEPV61Uq1m5sDgsifIImo6s0UnN5WRdCdIXRXQPRTvPFNCiZXn2S/862t47gS5LikWBFevRJ2pb8wekLcfQ45GF4ouhwTNKoduW6mSmKHn4XVDru8q27vLiOyzY0+f76dNMoePpQshn8C6fNbwFKR0dpvRHkDbguiCW7PDn2Oqk3lDRoZ3s9ldFbPL4+4D+1Hzw90prfSC7qh3Czstl7q/hRcLmVkxF+gNv5d/70S6lC2SwVnaI7hESAejST0jRIlYhncu+lMtEOFZ0LLBUR+TIGG0skqE95HnKygn8SWEY0796RU20XuK2JEykX/k+cy2JQeJPYg45quOG7Z4rCwnRCw56kq1bULMPqhMMSjRL8x++dJOIRjEGIitiD2aDDqathTB+Kw0ZQuBHbe+XJo6Ri+KRkaB4sNlPwZJFYyg0OYJWNGs+i1cb1D7oJP0/2OY/wmORXxGaeFmxiGw0OcYeu/nqmFAivUurdG/KTsrrDL44e6qySgiru2onvfB3zAYvDy0EIFRw/Dq7XSiENsWi4l9CfjahdgBnOdk+euOejChe6T7k0TmFgi5FAn/GMNWc9jXCbX5xz2jg9Y89GW9pK3Mrzh6ErFR/2soJPdNsf17lEjoER02rrP1tyJJCzJl42sEAwBa/MjsJayXbbDnqGXD45mr0vx1Z9GZXNlOovpqn8uPet/4RtyY7F8sLqun6guGIPnvTR/oPlVnzU3K8ucoYiZK2ZtuIirU/F7bvpEcWy96/VqAffckYD3/M2nGDGWeiUude5Fw5DjLp8agQg4iv07o/wooDp6dpSaxldjXcE42oey8S+aRJnqggLbVGuCLNKuzeIIdRchLJ1FxC3dpeR+T+3moqWILtvxqwy9rJi1uUCtP9MFbGoZLNYJuSxhE3nWQRBtbxQd8vrpmB39NpNzoowb
 YnAf85Iq
 rDiwJClsKtfWis19ekwmy9olXQWTBbbhi9iOcP3TCaXrraBebSvL2hgBlZ45v8fUwW7Kw/dEWzuuw7KfYDP05cTKmP2GCTavSonm6H/VJ5+KkN0AfOhXIXypqJkASLsK4eAnsjbbxaTXa0zlQps+CiBKMaikKaKEekUQTCqxKusbWKagdEEWh+on42eXgIHylcnyr4n7jVMG+1jWN4xfpz2be9Iz2k88c/lzONvUcpMa8lz7l7y/IAD9YW0SOa+qxsGnjKEvEc9s297lqbyB85MZH14QZl2zOjgNhB5uM/S/1O1XGBg7RgUieIF+d7A8okDAywlJcUmFlAvFum4orgC8kWnmv5b6b/iddqpEtzF84KzLmfoxSWons19yDp2ZutFtR/Cyw+BkKMFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15, Christian Brauner wrote:
>
> When coredump_finish() releases the threads the wakeup neither holds a
> reference on the task nor is it inside rcu.
>
> The threads don't necessarily need a wakeup to exit. If it gets
> preempted or was woken for other reasons it sees ->task cleared and
> exits. So only rcu keeps such a task_struct alive.
>
> If the coredump client is preempted between the store and
> wake_up_process() for longer then try_to_wake_up() takes pi_lock() in
> freed memory.
>
> Hold the rcu across the loop.
>
> Fixes: a94e2d408eae ("coredump: kill mm->core_done")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Aah, thanks...

Acked-by: Oleg Nesterov <oleg@redhat.com>


But to be honest the changelog looks a bit confusing to me...

	curr->task = NULL;
	wake_up_process(task);

So wake_up_process(task) is not safe, task can exit after a spurious
wakeup if it sees ->task == NULL.

And perhaps a short comment above "curr->task = NULL;" makes sense?
The reason for guard(rcu) is not obvious at all.

Oleg.


