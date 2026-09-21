Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75810C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228646B00C1; Mon, 21 Sep 2026 10:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2005C6B00C3; Mon, 21 Sep 2026 10:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116466B00C5; Mon, 21 Sep 2026 10:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFCA16B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:14:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F1721A016F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:14:27 +0000 (UTC)
X-FDA: 85237964574.30.F8281FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4E6C41C000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:14:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W9lxQflM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790000065;
	b=NhJami2OiY3Zh2UI6noK/BNMrP/Zy6ILS17aigBybd05Tzh6lWVkV+SMWBtHmsC4COIb93
	Kw4nuGb7wughCjcotGWKRzf5A8MmNMHB2rbMYRgh3rHodgdcO6wl/yWaDr8R9Sszb1SCpP
	PXh5kKEzsyWq36eXuQHZunVvm9z/iaA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W9lxQflM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790000065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moO88O+F0fAZ0OS5+T5zgKqHROvYfe+dUtWbWvUTEmQ=;
	b=GWZ4T+94PC//8J3HYRrsIyKc4wMsxrwt+N56arfR5wFvtzttVHSCzyyvKPrXxU4qBlM+7m
	LPtauuXMlwrG4OBxKaTlcdq/23tDmsCo5CWbHMVOAthcxJR897jrratqkwD/TVEGyrvMGu
	AMo2QOgvkpxZmWBNJryBWhrntsnT9ko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790000064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=moO88O+F0fAZ0OS5+T5zgKqHROvYfe+dUtWbWvUTEmQ=;
	b=W9lxQflMihl15f/eKZqetruVTB3eO8Uqf4QqZyi/lc0ImgeHXs71ovBoHhYVV0pmvbr1DY
	wVX5bXOg8DpIKcxxuRR4q9HN3UfK3oVA1NKYMCMIl3kipVByEhPyRZe7Pulq8oVLCR6Vun
	ngLaIsVk04dJlfyr4tNKf7TMDziBu+g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-PCjHSjL8OHGda3XrwctxBg-1; Mon,
 21 Sep 2026 10:14:19 -0400
X-MC-Unique: PCjHSjL8OHGda3XrwctxBg-1
X-Mimecast-MFC-AGG-ID: PCjHSjL8OHGda3XrwctxBg_1790000057
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9953D18011EA;
	Mon, 21 Sep 2026 14:14:16 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 397C219539A7;
	Mon, 21 Sep 2026 14:14:12 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 16:14:16 +0200 (CEST)
Date: Mon, 21 Sep 2026 16:14:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 09/17] ptrace: refuse to change the signal mask of a
 user worker
Message-ID: <arE7soBASlufuPaI@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-9-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-9-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ahSDyYDNUsd7Rl4sif4h6hPLfSrua6pTmmB_JP11Sp8_1790000057
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E6C41C000B
X-Stat-Signature: x8pjbkx468wnxqjunx73or7d57bsecy5
X-HE-Tag: 1790000065-784949
X-HE-Meta: U2FsdGVkX18XjFGHtJqjc6xgIeZGBrq04omLpRKN19tX65ViMc+kb9+zDsUY1LRFOMg1qpYNS3y+AE1XeKGa7V38Ngna0FW2uDS86ITbXJwl2D4ZVHFRlip0DNQu6JPV7H9uWb0+syOmeTimUQ8wv44b+9vfQzez4ni/e6ieXswZd6YltBFUbxhPcIMOtkWZ5NA+OrdAqHutV20JROOSW6ZerBHi4pEIHvDb3TssT+QyazAhWi7pEF/yCGH6WxxgsNmjmMf4POWsYbQKiif2U1Fb5zGV85LIuZgOQ6OxRUGnoCmkjNJryr6TACKBKPzf9vHuFhoEZ5KNfnoCFp5nSW33MgnDRV2HcX1YAtXTmt8RXymhekLBAcZdpFwnUUhcphCWlfqaKKR8CkO+l36ODALatBGxUw7ori9zW8gXZxeJ9ZAS4wEJfoWk2UZkTCzgLu824hpJpyk47gubQc7ptuTJCWMuikepWaIyVXZH+dyfr0p8HCkdoXhzyRXaIX7ntpFRKbv+YvFRIBLa+aRY1vSYxqyLI0kDLzsJUENOOg/0T5hmZZNDMIFPUc5NcNf+ntK+F98XgRo5CJGRyeTLh6sSgcwMuD5CN1+FVUnhSwzdwT1Ji3VSNQd6osWEZlVXpWHl9J7pxM6jiWi4VdK5LPrFLzlHSJlPG6J61gmi/uAWBjvE2cMW+QlLjjoQmwKQ6GdTPCA1euxjlXgkplTJBg3Y4Ru5zaFhPkDUbmoqK+n0gj3V4XLq1B5wlKqwZwIF5phuMczlf6qLV9yqPzlSyZDgm4J6lNDcHa8I2bR/kVdjkUeZk91TNbU+mgoGDb6fYYWu680uABAEVGpmabsBJilbyDXB7YPctJbz9o8bMg4fXBJvbnuIXSv69k2cnSYPnYo7zksvAwD+g2qowJaJdgJJqHGhQmfDP7fKwekWoCml/5ov00UxZe2dRZrbTKxUci1dXsoGSzn5BYdoUVn
 +7tEPFqO
 oz9sFvxR6VGMipbKbl5qY8J4L6FsionJC6Y9igcd97/8MP0tbtzxg2SQq7d5q6sUeQJWuGm3HSrgrwQ0xDENugai61B+7sXk+HHY7MrK1KotSdWLiWDCWWoCZTjSiSfKb+xjTKMiq5DQXlIVjZy0hs/DnVajhh20dsfV9Tpm4841m2u1HhxwgKKGFpIjlr9mHqfxgmRynzXTUOHFxIrLpvBc999ttylpw60buWMUYvr2AoYuBhsnXXwB8diyMDp01aKcrAU8SxpHTA7HG63/e9LbhGds5y+1Gozwmvklw1Qs5RCFXj78oVtLIwPLhgoGVPJoZJLdewhDWUawLhMoHyosLlO6NJevt39j8aFo3OdcYW9ndQjGWPf+poxXP5A/em1Z3b+cfjf+r+bZDq2BegavavpcLTYG6t+87GQjw7e4nITuZwCa18PpRiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1227,6 +1227,12 @@ int ptrace_request(struct task_struct *child, long request,
>  	case PTRACE_SETSIGMASK: {
>  		sigset_t new_set;
>
> +		/* A user worker only ever takes SIGKILL and SIGSTOP. */
> +		if (child->flags & PF_USER_WORKER) {
> +			ret = -EPERM;
> +			break;
> +		}

Acked-by: Oleg Nesterov <oleg@redhat.com>


