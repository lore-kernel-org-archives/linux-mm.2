Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62791606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 10:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9JNF4nw
Received: by kanga.kvack.org (Postfix)
	id 674AC6B05B0; Sun, 25 Oct 2026 06:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C8F6B05B1; Sun, 25 Oct 2026 06:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589256B05B2; Sun, 25 Oct 2026 06:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35A4E6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:06:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B50611C3DB1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:06:00 +0000 (UTC)
X-FDA: 85360717680.30.93759DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D59E8C0004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:05:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9JNF4nw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792922758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7gJTuVi9tDXgHlyaf5e6Te/gAcfSr0TPEgIwLiJCcU=;
	b=Ap/XZrhOYQwVf6DhyDmmUEZGdDBvbXUzUp6gr+KXLX65CJdgecdOlNmIk1lPYUFQrrdbaC
	A4A5cqa/QG70LZOqKm7azP25MTf2Fyhc5I+88YLCxB7ygCz5nACVxjbWsbIyU40zRxyWhC
	luUgYXX0Ska1GgxO2C9aZ/KTQ+pUYw4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9JNF4nw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792922758;
	b=OvXx+elD2F7FFvzpOAJ8PRr6YkBYncvfpJe1UcTlD1CfaKdyLdHBwxgfDEMQCw58Ynmgqv
	Xq5tFxZEXQVU8TgmHccSUJuCVG6hGdckbvltcQWRN6I/md+7tml2Xdmz5RBvSBH0V4Rmvb
	kgYat96hptMVSvlyQQCccOo1KQAqyQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC52C43EFE
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03CA1F031E1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792922757;
	bh=W7gJTuVi9tDXgHlyaf5e6Te/gAcfSr0TPEgIwLiJCcU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g9JNF4nwhyjZEs/ZmRDaoMhjB0L73RSQupVBm5JRTYeoBrJv0gN7l+AJKK5JzrreO
	 DFWfEJdJP3h2ysBnfN9qCKn37wITJF0Dt92aWPzo/uug3aUd/nX+jKQ3rVOsmEj1zE
	 KI6GS3VtLtlnLUkmoNrs22U0WLxUR7YvWdPj6pJdEqsWTHIiE1Rr4Z7BfFaKpCoYoa
	 UKkqCjf35AUpWlkaseQGXSrENUrbXG+Thu2FLQPVKSKya4Q4UnWP48NWfIElqMOq4e
	 G1qu0s+OaWBK274L/Ehzd/nwg/WWf36lzoOd5siZVSCEkW1ge6jFYiWZ3X7gmo96iq
	 3CJdBb3LHHp7Q==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f1ca4132bso185034585a.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:05:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBztw0Iqb1EyX+9orywD8ejuF55aWonGCkVA5L01Jd+yELkl+iE9hAIE6Hth3hV1woo30/vmsZXhPw==@kvack.org
X-Gm-Message-State: AFq9FYIzrNr+SxtHk0MUGuYMko9wqnr7mHrvjCQlgZjf7ZO5fUBs8irj
	KeQ0rnLuTWNLg7uSa8s0xh44Fv8nf9wG9JEiNAWBFPasiRvWZd+Tt6NO1WlKMnIi4lA7G1fUI2N
	G4Goh8cUfKMSpcIw59SYJTgIyiTTPtYc=
X-Received: by 2002:a05:620a:261e:b0:93f:24e6:403e with SMTP id
 af79cd13be357-940ef98287dmr493200085a.54.1792922756979; Sun, 25 Oct 2026
 03:05:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025021839.1542805-1-senozhatsky@chromium.org> <20261025021839.1542805-2-senozhatsky@chromium.org>
In-Reply-To: <20261025021839.1542805-2-senozhatsky@chromium.org>
From: Barry Song <baohua@kernel.org>
Date: Sun, 25 Oct 2026 18:05:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wBz8SHAy_nmv8w1UX7yX_yqhp_ShnNNJ+Ek82S3ZvYzw@mail.gmail.com>
X-Gm-Features: AclHuK9dW6R5A382Z6S5kYHE3k5MMyEbL-uFyfOty30ebho3VuUUWRklFvN0H7Y
Message-ID: <CAGsJ_4wBz8SHAy_nmv8w1UX7yX_yqhp_ShnNNJ+Ek82S3ZvYzw@mail.gmail.com>
Subject: Re: [PATCH v7 01/15] zram: prefix backends printk-s
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Brian Geffon <bgeffon@google.com>, 
	Bo Zhang <zhangbo0325@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D59E8C0004
X-Stat-Signature: xa539ripj5imt7i5rkjupq9o7j9wwa1w
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792922758-367257
X-HE-Meta: U2FsdGVkX1832BcQnzRjODMDC3VJgubSJnlO6omV9X11hxDqMii4YBagt2b3IWdI3Mh9v46ELy9wFqygrTguFqeFetwbz9f+RmI5kY7NhhK1dThUC4qOLTmn+68NhCyWWvXSwjhhx1rFutv4OIQo7bo6rdITskKTqGAFaW4crnIKCJHZy1euY7xtI41BVBG49aWh3xDNIF5vGZIYF4JKou+Ya7hlAadatYlUTR6GFcR9BGDoKR+gwrpTjwvNASGzsrSGjP3f7jTJvaOG53H40SP13pVnXaEqAt83+ga3aY2GCwXZeZ75aem3LztCrdgbqIykd84ZQ5IAk8q6d3r4LguTcha5TWwqxcMQWroqnWDQgS1OJFBEHplK8yTH91jATmk/BhWjtai/F3Zxt5XxjeepYsphfZyjrGtwcKPCQpOzj1sOxG7wTKsWFGkKZgNPH54tufK0pqauKM35yuIVJCH+/manDicU2MOkJo+fVm0PCfviUFevHtXvhVpbxITwFt8Jnj/59uAlQt/ad0Hbmn5yy/Q63MIKjvZAfnVs87jsmAEFYE/OoOIIgcsvkJa6vt8k/HbY3vkgop8Xq2PdvDIrRkALOcn1dbgYMii6LrIYLxu66CbvkEr0ET1fnIFEoi6FLBgY+/OPYGJJLJMKlQ+xRyg2Mqreb7n/lqVd9DjDPM9Xu0Rg+0wWNIFIsRi40d4JQ4OPoOnuc5ufjKnRwfuX0tQRAZ49odXTLuJ8oAqTdv/LBZRtw9G54EIHtS+oJkQwP20pn/64jeeS4QnaOmSh55SFGGpfiySBQ42ZMW8Yxwuntgozxx5+dfWbpUn2ENonpb80izXrWO4lF3IknDL0wTfGvSmNM7siRKERBDWstv9tkDvaSjr+GJVdUG9CGJvuaPo2quVqonz3KEFNvulPTWim20BIcyM7JwyPFE4S2hM8LMdGvTkgfp9cuVLZ5Ha/+hHlk6fa7F6psBk
 IQZZs+++
 Lz0ZPrW/Udje0o344MnfJKwKFTtpeDChZ2RGwZ7J07WqNHk93qxw0qEV+/5DlrA+D4JXK7OTAvIJIx7Dw9Dwuq2lfELmPtA6c5Wm5tQYwpaHtRtavBhn6cQ2ZzI/a7tGpSYD7vhoJIeDLlcivQmV73Um7qS430bV+CwcTSuCROxr4bJjorSh+VsbZcV2NSeJni4177miNn2UfifXZCrz+n+ktrL3vzG9l0+P12MrRfIZF4t35S9KvzalZMTYMp6vvI5nb3z2yfU/oDvWETxUxZezMZO65k+2e4ho+gxqxHFibMqIPlbokQezKdVPvUuiATZr++ZxGEN84jME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 10:18=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Currently, zram backends prefix printk-s with their names, which may
> look a little confusing, e.g. "zstd: alloc size 408128".  Prefix
> backend names with "zram:" so it's clear that the message is coming
> from a zram backend.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

