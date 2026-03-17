Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FF5FD8764
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4CF6B0005; Tue, 17 Mar 2026 08:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C466B0089; Tue, 17 Mar 2026 08:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9656B008A; Tue, 17 Mar 2026 08:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6536B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:49:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0108DC0332
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:49:03 +0000 (UTC)
X-FDA: 84555535008.20.7F22731
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id E6CF8180007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:49:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PfcZ2vaK;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773751742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8meEsPcYjYq3M656hxC1LNsg3q9rz4gRs0UsPS4fXw=;
	b=ASdJAEKQs23pQfy4bBaYG+y4R27HbD3bmrrk2BAWCQJfBXZaFdswJs3ZQw2i8qMRfs5diu
	6on7MAuK8ioPyzgz8R92jbHaW/DG0vG27nTewnrVh870acCHTezqCECqikMGOXUhcOKdeN
	uUgsIXYWtkiF4wuHK7ok2kIPmTLTD98=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PfcZ2vaK;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773751742; a=rsa-sha256;
	cv=none;
	b=HOd8/W0cAqVWo0oje6OTFXjfhdn5to4Ww6kZnwBYC1sJplEdAEA5LPxxxAmizKLZHCnuZ8
	Es93C8899yNdtjHYSZFwzsPv+3lHZBlaBncrQw81b+AeBzkyV0S2BxfsHVza0f4BA53+6o
	g3xBHcX2BQiZMklniEnlCoFekxnNyMk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773751741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p8meEsPcYjYq3M656hxC1LNsg3q9rz4gRs0UsPS4fXw=;
	b=PfcZ2vaK7taHw3hOl5MIHS0gd9K54t6gaVbcWPcb95GchCxDqt+HZebhUCRI7Xeilf7he+
	ML7v1oaJzbgf/2JOmWQSEh4adQKuU3tCbuPzJnJkml6X4RLvdAqZEYJsoNj/tExaTWFVLF
	SnCad9/oYJpn031Hv+PhQA/HaeWFO6I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-_pS-Wp-TNG2ZhKLZBOo5-A-1; Tue,
 17 Mar 2026 08:48:56 -0400
X-MC-Unique: _pS-Wp-TNG2ZhKLZBOo5-A-1
X-Mimecast-MFC-AGG-ID: _pS-Wp-TNG2ZhKLZBOo5-A_1773751733
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B384518005B8;
	Tue, 17 Mar 2026 12:48:52 +0000 (UTC)
Received: from fedora (unknown [10.45.225.204])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id F1E641955F19;
	Tue, 17 Mar 2026 12:48:43 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 17 Mar 2026 13:48:52 +0100 (CET)
Date: Tue, 17 Mar 2026 13:48:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kees@kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, brauner@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] kernel/fork: validate exit_signal in kernel_clone()
Message-ID: <ablNqvlB9NQlRcw8@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260316151956.563558-1-kartikey406@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: B9HxkiL1ZpmfNb8jxIZvHEW9XXm0b1DU3cf99uiuTZc_1773751733
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: E6CF8180007
X-Rspamd-Server: rspam07
X-Stat-Signature: 4w7e7zquejx3pefyw3p4cajo8ynth5m1
X-Rspam-User: 
X-HE-Tag: 1773751741-749124
X-HE-Meta: U2FsdGVkX18S7uEy596ZmFdvbtRngBsg0BmnA4MAAwTbH3zJ33JoXC7y7RqYTi565TV3RDtyXg1KsEmGG0onniCh0gSykyJF8f/RU5N4e4qXowpm5vmHSJizu6HRDsqSG+rRw896fAoBSwbv0s2PadcF2Oo+uZ4r/y6WPoSSWcLEVLnKUKl2waMjhX4wka2JmHq3v+nEYE+f9kHDjNipYoYtbIm0EMn7xi0MOitZqXH7fH3pilsnUYvU76nAAX1ThVT+L34TSUQ9CeZMnB7AmO60a0ZHNOSsnyH4KuWGDTEYyJ5edXLiZRXvHHKzJDDVkNOeAkOSjOvsKzYx8y929ztTgZMA0A+vcFhkAZo2ph+LPDOeOFVpbZ3DUjXg7KoI0carpwtzpN9sBVrwCq+78Ozh5atHGTbDHkFqJamt5j+4X9A7XBxbb/9i23LjcsvXcpy8j7ENw/BtwfeGHS6nGhOPsdSAR2hVIOJauZ/oyWTi5F8rTxKPcF6AQ+dMjegPGXYdSrFj3oKMnCyDlNR/cmvLvoLSdiN4dknLcMN/TadlnahMk9DnT2EGZLK/xV+8gY2nnSALtaXpvB4/KCdLeUQpSVV8LPYSs1VatkAhnOOiqOSzypnfsdSy5BrJR1PGdOjjq0DgBIKByD4bK8WVvM2Zu0hvGUkGhgdXkTPnNgfUOMHSHU2qBuQhxsy67PdP5FGw97ufpwN60Dxy1fpVLHz2dhmYfxK7knLeJOaxBT8ybx+1U/GsFwi/Q/Tps2pqfe0xVs3Yz7aSqQ9jFqRaU2yBi23yuyCf39YnCbU7cS0CNdR03SooyIN1O+nGWUxetn1S5zIIO9XsFRh8oqBmkvgw6OP/kkcxKgKsL05eBV8Iu4UmOK7/N8ro1wtrwXAnreVkMx+IlyDkXGP7dw1xW/07xxeZMkd+y8bX8DRzUsiTNwCOWF+xu4pmK9ncnhksU28rd28rkE2zvfbJEUE
 29mehDlL
 ka2gWETfoemKY8KLWbsPPGo7on3+pA15soGkZMwwX/CeN6LISGQBYlgLEszlog9ey6wCzljpQd31ZBHTdMTB4OBu4KJOoaNcAXZaBw62JS4ViTG6rSxQOJ8yTcDE95IMfKvXvw4VJn0NAV6EOmMU8Kuzh9ALg7BXQg5A/p140u1BGuk6dWrr3NJx6acJTU1UMSWdakggz0JPxSYH/yRMY2DkZ46XjHxY/yizYJ5u+U5m07C7B2+kv8GJInQKvrrjn5jekVwB6cuZjfMYPROiANTVl13HCPpRyE/Yl9KH2tjS36BFVA/1ZedAmLQTq9nz/h3LfTimC9YppCg6qRmmyoh2kB5eilGo2rMqZYI9+X+euvSZzzGtL8o5FdK1yDnfo9l7Pq6q6L88oIZ+u3k/CrkYdgXHK4rxjWQxjz50c06lGLCJTiSzZrs92OSn6OcU0eZ/7i5l21uFO+ZbhMiQHUfUHzA6LPZsEVhFMVm/vT31xKNGLYqRcWqZ7bIUXdoQQK1QaC5WczhuxyDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/16, Deepanshu Kartikey wrote:
>
> Note that this is a user-visible change: previously, passing an invalid
> exit_signal to clone() was silently accepted. The man page for clone()
> does not document any defined behavior for invalid exit_signal values,
> so rejecting them with -EINVAL is the correct behavior. It is unlikely
> that any sane application relies on passing an invalid exit_signal.

Agreed...

> -	if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
> -		     !valid_signal(args.exit_signal)))
> +	if (unlikely(args.exit_signal & ~((u64)CSIGNAL)))
>  		return -EINVAL;

I guess this can die too, but OK, this needs another patch/changelog.

Acked-by: Oleg Nesterov <oleg@redhat.com>


Andrew, I will slightly update the changelog and resend
do_notify_parent-sanitize-the-valid_signal-checks.patch
in reply to this patch from Deepanshu.

Oleg.


