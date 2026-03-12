Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 671E4106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64726B00BC; Thu, 12 Mar 2026 16:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04A26B00BD; Thu, 12 Mar 2026 16:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B455A6B00BE; Thu, 12 Mar 2026 16:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A40096B00BC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:57:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46E4D1C32C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:57:52 +0000 (UTC)
X-FDA: 84538622784.30.23081ED
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6047B1C0003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:57:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKTUhgpY;
	spf=pass (imf20.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773349070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TCU3IeL+CM9jwMcCHM5UD2nm48BrqqrHRJzKJccTi0=;
	b=vO6n913s7Q2kGI+JVPRYmZtcvzpYijB7/CVt8LYg1lp9AyYzzdnSKdtbXyKktMBde4Qd+1
	Yz82I1K1kS/GqSJ6pRMwu5Mtz/tPtpQjli3pf1OM4WVI5wDTJnUI1b9cIDCuKJ6ZpU1Mec
	SaNkGpusxj3r7oSop0eXZ1Vt/WhFCAg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKTUhgpY;
	spf=pass (imf20.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773349070; a=rsa-sha256;
	cv=none;
	b=shrTlgdbCD4Zl8m1HclA7WjfuZymYoOdwbsX8Hnee7BevkN1ZaEq4lfXomFd1J2ABFubwf
	f0/G9b05pfxywv7FpZXDgkuABB+RDZbgbdiY9W9diFxYzNJMNJdKElwNblyt4Wqfntbfmo
	W+nwrJ9fCp8PnQVKWF25vufutgbxUPk=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48534b59cf3so13308955e9.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773349069; x=1773953869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5TCU3IeL+CM9jwMcCHM5UD2nm48BrqqrHRJzKJccTi0=;
        b=fKTUhgpY8SBfREsdl1PGdy5LUE+FRmtN+7EKtfxq1eVYtctKdqRleEIMTI+q+bPE2w
         w6a5vfe2iMy5r7S+DZWExxvd6mmFXmYKR944GwCsY3XuzAC7gn6PoSULlqpWc2urT8qr
         T5FEN0QLvZmuym7MGlndrcD3Dp1QK1gvqy3OLqGx77l2I3qJBixJqVUUbRdpt3Pi0tWL
         xh0uE6lJaG6YWnedHku8NlC5qkMzUGRP++KmgxZ6SI1knlr9T8NTp96EYQdDeT60+Thg
         xfhfz8f8lVknLEnkZciZHe0hUCYUDjuHaCmgsFUJw7FrhIi6bGuHJMX2fhbIdguiWhn4
         q56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773349069; x=1773953869;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5TCU3IeL+CM9jwMcCHM5UD2nm48BrqqrHRJzKJccTi0=;
        b=sSHtgMl1hll7TBxADnz6+G56uBt+Qu3acjUC5eogcz4Ix420XKVVMe+RkQ7jgDJQTT
         aLTlFy9XGR+q5HTKSB3HPV5DgUTEAKhifURlfsxms7FlAxDlJtTTJSh7+/j5KXrob38q
         TT7w6+MLNeRq532zKUiKKdps59rgOyoAq0Fyp4GOBmzCVqyRmVtkEJMl/16odSxlJP/Y
         9Ko3zbtP20myOtLPKc++T9JUPe3yZmS7wChwuy5acTml8U0b/WEz4O3jln38GCqRHcMu
         LNJNOL905gRrMvMGxt/imCl+/LC0j4K7A4u2UFXI42S5crVksI7+Namy1Eyil2TiNmR2
         83LA==
X-Forwarded-Encrypted: i=1; AJvYcCWA81i4fsW8K8ci7RPhjElKMHtO7C7rVzb1/mlRjR4TkGq3k5UmlqAcdZAPwnrYWU5G0ijR/O+YRQ==@kvack.org
X-Gm-Message-State: AOJu0YzNK32zHgVAMcfaJTgQ3TTiZSVEIVn4cq8mhaYkDtVuFDHYV+FC
	dxcBPD2w4dNdWNL3YG0RImjzrH6dv7waVm3PH/u9V/jkEpakSvFDupGk5A4FMVjXlcs=
X-Gm-Gg: ATEYQzzEO6fgjzlLlI1wvGBqP+OXvmNtT913RJlCKY8XT6Y1wpVePsUAhPcJSRmI5WU
	KK3hXV55AAxofmKXWdBPOcVSYLEAZcQ2cfeTyjRBcu8T3ezEzVrOzGxE90yqG6NrKu8555bj2eM
	v/fMCF2fLc77kYNSJk9XODEhnxu7oBD5b4SK2JGeuAROksKKywLPr8mlHrJ44rWoEgEhRLfybqF
	BtgXUfZfV3RxqaYNy5k8Igl7wuTfwMeH3kuBxg1X2TrU2CB6QGAVKC5l5gHXhhy4aVbHYIN5cJ3
	YOgv5QEAsI5HQhkexiWIIT9AbCZAkDNWslrUEJudu5zTgNx26gHLMwWOqsJxEWQeYjZTJz2JOlS
	A/aik7PRWYNpA2uZ8qu7J4Jnj2toBg5XQLH7YAEGBUIKBoaXXtJzgBumA04tMrTSU+4dXve96oU
	Hpon98d16DukVEbiThBHFl7u1HWw==
X-Received: by 2002:a05:600c:4f8f:b0:485:3423:727d with SMTP id 5b1f17b1804b1-4855670c095mr12566595e9.26.1773349068753;
        Thu, 12 Mar 2026 13:57:48 -0700 (PDT)
Received: from ?IPv6:::1? ([2a00:23ee:2968:90cb:1c6d:1979:bcad:501a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4855725572csm6531295e9.2.2026.03.12.13.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 13:57:48 -0700 (PDT)
Date: Thu, 12 Mar 2026 20:57:46 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Message-ID: <43bacae7-3891-417e-9384-20cede8eec6e@gmail.com>
In-Reply-To: <20260312135514.e4fc0fa4c1f50e6fbda2644c@linux-foundation.org>
References: <20260312181948.20020-1-objecting@objecting.org> <20260312181948.20020-2-objecting@objecting.org> <20260312135514.e4fc0fa4c1f50e6fbda2644c@linux-foundation.org>
Subject: Re: [PATCH v3 1/2] lib/idr: fix infinite loop in idr_get_next()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <43bacae7-3891-417e-9384-20cede8eec6e@gmail.com>
X-Rspamd-Queue-Id: 6047B1C0003
X-Stat-Signature: fac6asa4u5ewc7tag9o3iidxedukb36g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773349070-304706
X-HE-Meta: U2FsdGVkX18YBNEIIAD6HF+yY+68tmrHqgmIEQAb4Lh3mFv82J3vzdRAxI0PN0BNjW92+cBXZTj9rTRHncfWiG4n7pHNgVxjWNlAWoZGfbSeUWD0qLq/gKk8/+oJwbmmky9gG0hrW8ZAwlIfbSRwBFrz/L1yCVxYyiUDB/Xp0B1x2CnI79LnHo2EdhCaV03XYRp6KtyGCGnXhawJi6EcOhbGlbCmsxYzcj+6I8RVvTNJGCbmnDrwQBIv8kX8tVq7N5gyQow6V/NdXi6Z+GsOg0mkwfK8djcOr66mL6DtXPi0sEpSV696mBojhm9aw3Xo6bVkxcULLJKA65Pnaqyork7lqJQwYGOcFwxtSDSS4KZG8gPuQmdA6U/g1C2DZUl52fX4U/aS/as6iNXqVqrMkoJiEUm3pR6CBGyni7UTRICdB6D0Ik8DSPbg4rLL20sF6TekD53xqr3nLzwxZU+snoofCH9anzUqldoumwZKB/rSnG8LY66PS77okVbBiSVhNA2ZmZyWTiLLIseBXtBAi2U4c43Fy2ZBfiBWeu4/aZ8q1fGCowSWghM383NLTqARprjGrtcbuvvlFNd2LXTVI9q9UnhM5eQuivrHd7P+6rTqef6cH/G4VK20KRDyWY4ohbKTqgj3q8GFUAQ16Q8PAfB26HH4DR46cZ/AeNwoDrqSIUxCWuDQAuMKszGFRwJegy1hKD1s+wQPwBikNo5C6ThRjxlOIOJcKHH8C+wB2y8qPbwIUsm40xbPIWFBrcOVfUtFd4cHSM+x1wh7qydUUxv1+v7iEfaoxsYe1ht1JtD6UWspHR6LSXcEoa2jYj/lMq5H4KHeuFi0CD+DMGSm0Q6RIevRv5vxWI5hWRaUCKAVgEJ7bkWYv15wsCLH18IIwWXCPuRKGzBXNTm996tINGO7k8kCwjotlCskwvK41B4E4kKgPNifFuaxb7Ka0j/6oIOndJk9URZBdwCiRkC
 NjPE3QlE
 8dZ8W5eFdwqhuY1iAOWK+Q75Wt4Zh+t2gWPUOi5Uvr3joZm2tlvDnzFtzNYmSLzHKw+AFCMrxc13Sxe3tp4OYLv7641ofg0pRUxN8NSxEDuKGwIUT1Z0l5i0EQHJROLKLbU/4oOyTIF5o21bjR/ip4xfm2uYV79TRBOZIyZn7BtUsEXYM8eyqLPuFByS70vzEhsjeepIuAQhxh8S4X1INPMrx+kYoOXE850R4P81NQwIyxA2fGGIC9DJl9YCdZmDYJUiY7mGb3JpTgmivIs0cCVpT+moDP52qoUfEHF4f0EXNmNZnx5niKc52a2+Z/DjEM8A12IpKIELlim9co13xFEWTBXlNWg9Wm2j3Au0yda8joJg3vlRlDebqwPYblgZHURuMMrGelDB5BtuWWfL4jbr7XP3dYXF3S8fvviTrzDJag8WLCKT/4laVcqdn7Zxsria8vazmvo0zvMQXnjZLFVYmh0jq3BlGoxuHR5OkYDU5P8Md4frvyWBXVzOSwzq+APV/u+yIhoIHSEjozMQcY9hQuEJqhWE0+1uujQUWd4QGlNFfm/s12MG/Sg05cMHtr6IY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12 Mar 2026 20:55:15 Andrew Morton <akpm@linux-foundation.org>:

> On Thu, 12 Mar 2026 18:19:47 +0000 Josh Law <hlcj1234567@gmail.com> wrote=
:
>
>> In idr_get_next(), if the returned id from idr_get_next_ul() is greater
>> than INT_MAX, the function issues a warning and returns NULL without
>> updating the *nextid pointer. This causes a soft lockup for any caller
>> iterating over an IDR (e.g. via idr_for_each_entry) because they will
>> receive NULL, fail to advance their index, and repeatedly query the same
>> state forever.
>
> This assumes that the idr_get_next() caller ignores the NULL return and
> just keeps on looping.=C2=A0 Isn't that a caller bug and if so, do we nee=
d
> to defend against it here?

The risk isn't just a single loop failure; it's that idr_get_next() breaks =
the 'forward-progress' guarantee of the iterator.
In macros like idr_for_each_entry_continue, if idr_get_next() returns NULL =
without advancing the pointer, the caller is left in a permanent trap. Any =
attempt to resume or retry the iteration results in an infinite loop of the=
 same warning because the index is never incremented past the problematic I=
D.
Advancing the pointer ensures the infrastructure is robust against these 's=
oft lockups', even if the caller's error handling is imperfect..

