Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF2AFD3758
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574926B0005; Wed, 25 Feb 2026 08:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521286B0088; Wed, 25 Feb 2026 08:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4031E6B008A; Wed, 25 Feb 2026 08:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4C16B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:07:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE4CB1405F2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:07:31 +0000 (UTC)
X-FDA: 84483005502.01.4FA1B06
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id BB5C01C0010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:07:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDzBTTAc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772024850; a=rsa-sha256;
	cv=none;
	b=Gcz67SOb+i5UFvTtgvxD3ZTwYtTSm1v+HjwEWPS0kHxhNXh44EyuB1XMmIoAmsMYq2QQsM
	0RlQ/NZcKdqNRcviqTr3yl4d4x8pil374CL7vUs98JLuuOOH0GcqE/csorRaGK0Ux9jFtG
	Q9B0OyYnNE7N7pTgd4Ymk8O+joQIMXE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDzBTTAc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772024850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2F0a1/I0evjMEXLNGJ/pUIJHGD/TW2VAOAzXXV180I=;
	b=MOkAkCcJXXr3EY+l7QzBYNCX0XFXPxXhvGsmc/TMGVYJqM/snXbt1Upnt/i36ul2CX8gF0
	TsDQgTsjGNNdi++PPLGVQmaNAhBB6IzeifLH9hL36snXxwU84b/9IA19YYo0/jfTOWF41n
	lw/9y3fcK3ZL5ayhEX0KfAl/fc43BPk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772024849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2F0a1/I0evjMEXLNGJ/pUIJHGD/TW2VAOAzXXV180I=;
	b=jDzBTTAc85GGXDKtXynV0p6aTnmXsydmE8ClDkz4OdpwpCLyN2WAd2FOW3OJBp01v3YZAA
	MqBzcY7ZNvpcWmzNYmj5m0wOKq4BFdoAZ/RoS8Oq+h0pP3G2nzTA5hGdA9rQkyAnZlehr0
	8i0g5smDehlSdn/g8ognkEL83vZGuWs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-YmllfxCaPq-Bt1xXjL4iBQ-1; Wed,
 25 Feb 2026 08:07:19 -0500
X-MC-Unique: YmllfxCaPq-Bt1xXjL4iBQ-1
X-Mimecast-MFC-AGG-ID: YmllfxCaPq-Bt1xXjL4iBQ_1772024836
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF37D184543F;
	Wed, 25 Feb 2026 13:06:54 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 097EF1800666;
	Wed, 25 Feb 2026 13:06:46 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 25 Feb 2026 14:06:54 +0100 (CET)
Date: Wed, 25 Feb 2026 14:06:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Andrei Vagin <avagin@gmail.com>, Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/4] pid: check init is created first after idr alloc
Message-ID: <aZ7z5XPAtptQVoW0@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
 <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
 <aZ67mwBEbRtdaWp2@redhat.com>
 <6269de34-203d-47b5-922b-342671573b7f@virtuozzo.com>
MIME-Version: 1.0
In-Reply-To: <6269de34-203d-47b5-922b-342671573b7f@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Py93sD_pugSTCPINLvlzImkCQoY8pebCPmaLTHnufDc_1772024836
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ecrm4ah4u83krixfbped8ugc4xnj1azh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB5C01C0010
X-HE-Tag: 1772024849-688446
X-HE-Meta: U2FsdGVkX19It/ABeOj4/dGENIbvDY1KXd2hXRLZSl9RrPvnQmovp2hR0es7nO8cs+Gcx8z9yqjSkqt1dtahWTb4m1a/U9DTN2aNCWaghppxIbxzgPjlQ3RMFNI0lOsrqWyHJ1kjKbKxOmhuQCl+xJzTTl/+BbCZKtr2LWb3LLect2VaZQnTBzLPYM2lMalAEQfXeJTReR60fqHD5MDOnq/rvr/jMHpzuC3UGGWZ8dZT8pqphYL01eIHcAtGAsjyfvBH+nweUizhetUJ+QYh5/bgb8zS6eUz+dPg73UVgolfP8+uZFAk1h+s0UOm934jOahzmSHD54wqmcYzFjj2PNhn4ydHNhOI4pGJEp3IBpOpadK5bXh/p3uzbylQAN+nAtG9fNBsnC77vLPc4DmWFwxy8W2pI0GQ1ZsIAxmftQtnYJKUk4QQ+6XmcafyDDWMNNGp6NEXH/HKcI4YC025b1CoXgLd+9xg6UQ0RGXyGtYDy3Q1BHeGzA9XARmyUPDEqCCwDht6vAFzKZpY6BkxV1ZKVYM8Olo+rm1VITNEJ5LWGafsTBsXeeyf3rTLuJ4m1cMB3mZwgsdYKygSVyo4krMyRU1obf4/O5ywl1+Wci0NKDOeswA/hZgCm+ecsF0YYy9/u9aPIvA0SUJOx++cz8r6MJTKDNoNq//vI+NTxDXUrLmaxu2wnT7TCZjArvfgcxgHxxfemD9QXkr2zCb+Bntjzk2XH3FCFoxevHkzEshoRzNpYX2Z8hzPzV55x2MWhHpH15X97ku9duYS17kKhvjIuBN66LYGMO4dYtygxFOgfZB5m3mCzK8yDmu5V3ooi7qogZ73SGmW8cuU0m54QotoHsC2KZpjkBJItYLQeheRYhQ/Usw4AlBu1RWtebCnvlZF2OnAiie5hshdHpIHOWp8l93syWq5DJqPPHOL8FoO+txBnDRtwrLqVwUj7IWDpvNhLArUrtpnAOAOyLJ
 xmqbABeH
 23vdYGxfw8pRP26JzSgu+hHT8ifaSoFsXWvKYnQmoC3K8LbCXsLV2uLOL8oJyeExn/EJp6GwltgcMewKE2TsQsiGeWv9uPiYVX0w1mbdEGD7/CV4V/skpiRylgot7beYGWAsiUzrfLxjUY3r3tTz50ajCtGU8LFR90dE+Dau+fqMW3pkgkONRplfKACaJCFOBH3+Tx8OgImq9NjElj9BOk+DXcPZmgHd8DgWfjPiZkGuuQvrMK0GS0hFCbY3LfZmyt/uns+Q3p2saH3u0MOS5mBdDEPrNna4BRJkULNAZzi0T9yPFGWQfW/FZDKwO9hcvFmyv+bMkGsHnj5w+m4RRIuFPu60OSWLppV6VpDt3dYsw4LWHKHAkPLa+iKqcBfo0kGTXpjQqpVIHcHIFJCP69/ze8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/25, Pavel Tikhomirov wrote:
>
> On 2/25/26 10:06, Oleg Nesterov wrote:
> > On 02/24, Andrei Vagin wrote:
> >>
> >> I don't think this is an issue right now, as we only allow one attempt
> >> to create the init. If that first attempt fails, free_pid will disable
> >> further PID allocations in the target namespace.
> >
> > Thanks, you are right!
>
> I guess it means that we should change the commit message a bit, e.g.: replace
> "Effectively leading ..." to "Though thanks to PIDNS_ADDING logic, free_pid()
> disables further pid allocation in this case and it does not lead to any real
> problem.".

Agreed,

> Please advise if I should resend the whole series (v4) for that?

This is a question for Andrew ;)

I guess you can just send a single [PATCH v4 2/4] in reply to v3, but it won't
hurt if you resend the whole series.

Oleg.


