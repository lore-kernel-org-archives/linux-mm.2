Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE4FC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE166B00DC; Fri, 17 Jul 2026 14:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAEC16B00DE; Fri, 17 Jul 2026 14:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D8A6B00E0; Fri, 17 Jul 2026 14:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A03436B00DC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:47:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1644F1A014B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:47:40 +0000 (UTC)
X-FDA: 84999152280.08.C3F1CAA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB2BDC0007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:47:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EXxahEpy;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784314058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUeLqfN2j1oB2MnjjL/LYb0sz/3GEuAWUl8u9/2q4Qg=;
	b=obqaQ1qPIu/yBjV0A3m/W8Evp/Vh0LvgrXqJQFU8FLnlbRfP5ge0BlZiYC/Jb8qzyP4edY
	+/cwMNjXQ+NFLYnODUmhBwzNm1qWjtC2ZTOAVysRIZgkm8dGKSdCdAFAcK0MnzOxZMeCCe
	Gh8GZy9d9LySRagvV2i+en0gXI5laKA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EXxahEpy;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784314058;
	b=nPUQy7H9Ab/WcnoWfi6KOxcc9b5i//j5g+DJfo4B/UBAZwZkhicTtEoQQvRWAr6G/1veWF
	hUq9bpMsjcHA/EXFrHCm1X4SZ/1QNIJAwJHzqgYBIvmQivVoJGWpXxOTuh0wresAVcvMvH
	NOGachumrzrkIZeu+dJCg8Gzw6WIe/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784314057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUeLqfN2j1oB2MnjjL/LYb0sz/3GEuAWUl8u9/2q4Qg=;
	b=EXxahEpy0einBlhoLUDMiVfiNrq9T/B9jaABxEiyjj5D6gyQ499PnQ5XmHhHJCQSp9z7Q2
	9jkXEuq+yfwXQ8Q2aWFGs3MP9So2dsS0bmQ88p83/vz3e2N9B2EAM/mo0ez/vjwXXkejy5
	78CM6hjrn24h1SfSj+tXw8XosugwqBA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-uC1irEO2MSSdc0hTf3nDcw-1; Fri,
 17 Jul 2026 14:47:33 -0400
X-MC-Unique: uC1irEO2MSSdc0hTf3nDcw-1
X-Mimecast-MFC-AGG-ID: uC1irEO2MSSdc0hTf3nDcw_1784314051
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41A57194510C;
	Fri, 17 Jul 2026 18:47:30 +0000 (UTC)
Received: from fedora (unknown [10.44.49.164])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2C9F2D72;
	Fri, 17 Jul 2026 18:47:22 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 17 Jul 2026 20:47:29 +0200 (CEST)
Date: Fri, 17 Jul 2026 20:47:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <alp4ud1b9aX6rmXo@redhat.com>
References: <CALC_0q8ntqjCwC6CBN_0h_z9-_+pDp8-pqQgZ39O2s8ke==9cQ@mail.gmail.com>
 <20260717181252.2277818-1-richardycc@google.com>
MIME-Version: 1.0
In-Reply-To: <20260717181252.2277818-1-richardycc@google.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: R_lkXtN9kW6dG8k6jjCeExVoexS4QjANkVtPZXO9VIE_1784314051
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB2BDC0007
X-Stat-Signature: gxjj986hncyokt8jw7t379obdzp5doej
X-HE-Tag: 1784314057-983429
X-HE-Meta: U2FsdGVkX1/6SHTSodPEUySxdbn9vuZPG0bwnK5+ErsNztLDqliw0BBTI80AHAA6K1PH4VVYhB3ImD5PGwp6tUl9G0Cytygvy43FO7n9DtBktqM/UV5R6LyKlplVYyfIzGGX1+Ms46pGNyj5V71KGeZLOxhvn+MT7FBGVtKz6INWHeuq0ekVJ1nUFC6Umocuvf0DgvGPPqCfYrXei4kM/oP4DLk5qKjXQ6kl2l+uyiccZ7Lu+u6bZbiXK/XaOmMRvLXc0x6HKWWiKkAN75der8SvGh3xQuCsqCwUhIEOK+U0CnHTcnTRy8Y/z1OBDFn4l8tWIMAym68I/ywspTGAf2UE1k/+mshvT/9b07PIHdUi1blwZj/fa/vdT26u5RpWSPiZ0HyHJupq1yTzqzBDVUqLcloLiSDevfN5z45W+V7KMRuBYVpinARWzYS6IlosY0gaQ9bpykm4C4JMiwUvOoywFtRh6X5HA24HaoAQQT5ElNDcGJXFbsH4neQvNBBx9YzoCOaQRjdaac5QVyPcI/io+hn4BP2bZPL5NJ+++J1gxH4RNdPyx68ZuN8hAE9hRTxrAFHmqXbjJtRU65FST3d2lGRWJqkwVyxd/AYbLxKty0I97Y9t1rsOp/Wl8MfCsofwedwY8RzjgTQXHTzcs/ihooxGstas6HYcz7GL+MpwidU4+PuGbPFUYqDr2vNvzMzV8sNRa8FDHEsgU5HnGJmV3MGMsHyYcfqznPUaOYuXhIWez0HYgYvQKM3a0oF7gxNNuIuRQoNQt2MILHF2Nrr/pnKByf41MpHrihG4cywuvSyZzs+2JAy1rtswqpwkPMDJVQjoVz4NF2MEovDMfSRn8p9Zi8kpwktGWfenvjnAeGHTakoCvQ/iePElxpY5vEDSQOgNlcgZyMiI0zVfUa+j0T9DYenuyisI3hO4G70y/l2aN1N908O8nWsZMe1ZT/+m72uoYgg7XZC5xbV
 t9Pm5nna
 MFGGegQggggy0AZ+iPibGmFwBNYwPSN+AiLNpoIInFqNluwuPBDzUjlyb8Cb6CSKReKSvBzXStYv4bZ4guFA9he2csXeEG7a3zwxaOgCEGjUAQjR7ZS/QvMxrs3v31wVWA/+4WB0xcsMDUbwCZxHhJ0AAKGxLw14NmY7TFK0Z1de06B7wkBvV6H9uwMUMyeqURQpu9YE+AFQ04hWNJgzP5fmZplRQPC3K1g/znu3+6JhdWKRcLcgE2muAIs0xR25cJBCHDMqG0fewVdFWNMsMufmc+mcoePc8+X5bpwq7mSxtxasFk3/a40a+RJpK0wpbqX5Ln7qgtnASKJGPDZQIYWMmC0bFFPHbTK/J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/17, Richard Chang wrote:
>
> v3: Return -ERESTARTSYS instead of -EINTR in user_proactive_reclaim

Yes, this change LGTM, but ...

> +		/*
> +		 * Return -ERESTARTSYS to allow the freezer to interrupt the
> +		 * task. The syscall will be transparently restarted upon
> +		 * resume. Real signals (e.g. SIGINT) will be automatically
> +		 * converted to -EINTR by the signal layer.
> +		 */

... the comment looks a bit misleading...

So, if the signal is "real" and has a handler, handle_signal() does

		case -ERESTARTSYS:
			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
				regs->ax = -EINTR;
				break;
			}
			fallthrough;
		case -ERESTARTNOINTR:
			regs->ax = regs->orig_ax;
			regs->ip -= 2;
			break;

If SA_RESTART is set, the syscall will be restarted after return from
signal handler.

Oleg.


