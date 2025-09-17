Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4669CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F018E0091; Wed, 17 Sep 2025 19:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466E98E006B; Wed, 17 Sep 2025 19:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3D38E0091; Wed, 17 Sep 2025 19:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6128E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:54:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD09611ABE0
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:54:55 +0000 (UTC)
X-FDA: 83900400150.11.E0B401C
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 010808000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:54:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jLq1DwTY;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758153294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVqmq1XyM68IuWPFvf/CwgC6VPWqheMQfHU/6sGfhXY=;
	b=1+4G7yTk5okIZKhu/klUILb9Ls9m1wCA+Q8ZArrPBh6nVxNNUzeZ/Q5WUij2eKfTqLEmj0
	LLC8GP/Nvui0BxVFqfLhrLRh9A9mzdYbRSHZnAdy2oZ4r3koBgA0fz3og0qcFZEL8QiMl3
	mxpe6OPZVvjc0V7Ybekusv+0iv/oRMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758153294; a=rsa-sha256;
	cv=none;
	b=M4bkL3LUsvuRG65aAqTv7YMBMW3jTvI+hVenIihFeZmYcGlOn9iEoFFCcCT8lg95OAbl4G
	U4OWE1o+fMPWlm9/s7vQdAa0FGORXBJeDAcHOAvyOxbp+2x9kOoXNw6T2TPbKJKEQdUj7L
	e1JDO5djScEk6vFaJ/rg/P0a2n359ic=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jLq1DwTY;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-811ab6189cfso36425285a.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758153293; x=1758758093; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVqmq1XyM68IuWPFvf/CwgC6VPWqheMQfHU/6sGfhXY=;
        b=jLq1DwTYM4ui4HqwEtf/ZB9lQUSZd7ODe29U7zRreu5q/NyTzvXvKLh0XZKVc6UkF1
         Vk7jSj6qAOMu8Me9VW8e5Q9hepXSYrlAw+rB5LHBqlQc+xljFuWdDb5AfiDDZPkVK6D9
         nRvig5nUxwHFJ2nHv46XV04MkgixHraQVs7dih1RFCgZlpdxBxF8ddx8x86yMZnqm99Q
         C88LK047whdhf40DCbMQT5kYVMmgLjM+H9g40pJIGjXkC2JBeOpK9GWTA4O7+eu8uP8b
         UOW5TqRYRAkRzBVs42dR5pPl0cJfa8CuU7yE3vTkVVGtqFUVLeuSnnS6rtn3to46h+bN
         ntZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758153293; x=1758758093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVqmq1XyM68IuWPFvf/CwgC6VPWqheMQfHU/6sGfhXY=;
        b=fEyMhrPSQUxopUAD1SRX/wPOjqYRxp6nEnk9WrgnHqacGlpB0HM1vIntFqYzUzomk+
         z6z8NgIcNWrvN+q9wigmzho+/dGPeY2xeYiQe7op9dbMkv3nefXXkLsC2iPhg3LIjpqr
         BKNU6qDrXFFRSvvllA7V8F6iNqSLtditegId/QZZFGLVXwR/4FAdjBdvw0nILrbLu3P3
         yzO20YisvmiS+pb4N7rH6iwgE7vgvV4OSSxfhNctrG2UZO8b5igGLTeDhuu8Jxl2g1wJ
         dOpkC4rWKQfDQPv2rNdXqNuzYDeiHl3EgbBuPgoTZiIBFn36ddM25+htdFaPVCz51/2I
         Y3sg==
X-Gm-Message-State: AOJu0YzR/HCCsvhsYfgBJsZ23CotKYjJYr+tAMnAHUqBRUIyJodA/bk5
	BpPu6ELw2FBVj+wkiBqFPms4OYP62FW6KkeYhsYvtrdWIU9Bb/CwKkarDWKW/BibqcoSWgU6w6f
	HbXBRczYgVQ52iBXF+nanUBAVS/kwT7A=
X-Gm-Gg: ASbGncu3+rhKnO2QRk9huaitz74s62znfilJ1OVhZd8nzhA2PJsJt5esEb/mTKh5Yqo
	ntJRMojvjbqwQx6/UgCboSwpYW1or/2KWHe5DvIqiwSnPSGXUnIfDfkcuku1Irz41co4Jwlz2iq
	Ij2uMggebQMuZuJEaPgAv7ckUgerh2f9rHZv7FthiomY/BfEphSmjeqo6Z+zo6U1zxyZ6d5p/74
	iHfYFAkEV7BzA8yCCyD+vSKknYqzwEuy9JKu8xWyzaoRyiZafgqewtjUchU
X-Google-Smtp-Source: AGHT+IGder1j1Rwbf0cQacLg5ALStnZiI32aSbbV6lf0Xs9drtdSw2rF92r3+LPRUslUoss8jtrhYKBhZNjGSi29rjo=
X-Received: by 2002:a05:620a:4116:b0:815:dab2:1ea8 with SMTP id
 af79cd13be357-831162658a2mr458884485a.79.1758153292929; Wed, 17 Sep 2025
 16:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-6-ryncsn@gmail.com>
In-Reply-To: <20250916160100.31545-6-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 18 Sep 2025 07:54:41 +0800
X-Gm-Features: AS18NWCbKRDQhueLJq3obspsewbZg-FyKMrsp6P91o-NQiGvqOCVRcKPSrRiGuk
Message-ID: <CAGsJ_4zL2nVUOpV7aBsfHn=gS_bw6pdFYTp4G3frW-3ovupBew@mail.gmail.com>
Subject: Re: [PATCH v4 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bghgtbpgrf4qffrcs9mgzq9qnd7q67p7
X-Rspam-User: 
X-Rspamd-Queue-Id: 010808000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758153293-239450
X-HE-Meta: U2FsdGVkX19kiI1k4m4TM+fb1EHTBvTs8e5vjUj9kNphUDuUzD2nLlTOW4nQ/UBNZCImsvE6Gb1x2zqScuE4oqBgArcszOj0KyzneCpAVpIL/l4bTWLsaUrcpDLugXaMewzmmb1tEAwjWcY//ZpJoeZRewMG0tTjSuicYh8WlRv+gr7YE8CtjQxySmRhhBXeIR4XKGJp3R8lJXenAyG+1i6HAq+eeztyCftFrfk0OHRLiFeUR+WuPfm6ceR85qIfqbkSKQOjQ17B8n/Z3wd3lHeZkXocF2f7Yg4sfw8/bI3CdeSmtopwCpK5Whdu6NXYTaG5HSNoHbzXRhr32yZvXhxREVqtFHslGAE1hDnQRyT44F3ZMsshbZTw1NcajR86R3SEFZWeYVJC2EbtmWb4nXegBGWREn/vrWPkNssvDFMXaYe87UvRNh//XF+8ba+RvE+TuGgWqIFQPzNSDQk0KE9KtQDuwmpc/CazhNKgHnNUnW15mT/fT9Nqd+rVgYZ5YP5PdNwsf511NqdBkz09HNNKZxSxdW04WU0Auq461BCWveiZ4KfU+u6Jyb/epHLyKc8h7VGI65tUojQ6Fwl5IbdLEzyB0msI2c7tb+DZOox641JBTj6cwq13Dt2pjYUJnagcn/oTUCJG9o3edS6KtP5JNR7WKL10PicIL1f3u4dIXaRTcN/+FsdDGbZuqS3i9IyK+kGfv9Y8WDFvuEzTLKfCNGgMPNW5Fr4bNrolTniJq1Bnja5Gjm4/juaEekFeKvQE6G/+u92f5Tgwa+BtV+5erYFgi0YjDgabWOM62QAHupCUIJ9ofsF6n36H8Bj3w6dLe8VMltLpBTM0wG0lNLB0ZzUGsgmN8RaJt6x0WfFK0F4nzvOutSgGnaidcF/eG6biDrvpnbcxfevysx4ZPsiHaEhnDOQ9nqWkB6isXQwptH86p05CiwYtJ8NDIfbHu6/KdVR9tr9aMTbJRbd
 IxoNe7Zv
 lQ/Eur63kO/qJA/udMwWEpkchjYZkojnBHzEMD6xpsmwarOJgTmvr9Eo1FQv0yEJjLmR5uTdybSQux8bOGzTh8VwjgvB467DNMDn2J50cbb1TcvJtvziSz2ZEQkznhNxmvn/VWdKTYJZmMayq3DIA/XEJhiPb9pzkuU9I6qd68vTaXA3JfhLM+zELBhgO4ClNwEqdz8VHvV33O0kMNeQA+LEsInwgyHJGH/9H6QMFAG2L4ke1dQGdih/+jyAsFdfCc9qQEFEY4rM+OKuR2QGSvvsGzrQ+h2g7KtBsxIwD7eT9TNYj42UamAUfQBKnrFLdkufrSwcosgmmq1Oss+zoR0Dkb7ceKHxz299/+LnsQzpaPZRkDgoNvpLMIB9f7mLSt5myz3VhI4PJ289pfVE9TpqtmKqkDToKSyTWkbtLf8NyXN/gZI9Z8ChQKoOdyGHTROMy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cache lookup only increases the reference count of the returned
> folio. That's not enough to ensure a folio is stable in the swap
> cache, so the folio could be removed from the swap cache at any
> time. The caller should always lock and check the folio before using it.
>
> We have just documented this in kerneldoc, now introduce a helper for swa=
p
> cache folio verification with proper sanity checks.
>
> Also, sanitize a few current users to use this convention and the new
> helper for easier debugging. They were not having observable problems
> yet, only trivial issues like wasted CPU cycles on swapoff or
> reclaiming. They would fail in some other way, but it is still better to
> always follow this convention to make things robust and make later
> commits easier to do.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

