Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3B4CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876E96B0092; Thu, 15 Oct 2026 22:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84EAB6B0098; Thu, 15 Oct 2026 22:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764FF6B0099; Thu, 15 Oct 2026 22:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1FA6B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:12:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE7C01C2C35
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:12:29 +0000 (UTC)
X-FDA: 85326865218.15.C2A0012
Received: from mail-oi2-f10.google.com (mail-oi2-f10.google.com [74.125.231.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA2F0C000A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:12:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=msGW2Qcd;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792116747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbuCv0ryWYiDtygGwn5WS0AeqhHnfIiKGVCd6AYwWkM=;
	b=sRnOagCmtMFOn3gDFrayDiMqJakrN3fAhN61sTt2Dx35KLnzIHp7eJNVjVqKpPmz/fdDt9
	trGj3/apIhwkAs/gFRMrMxcqnHk5MYvgX2gnD4YtNZcq4l9/o9s3JWi8vlmGsqRZILozMr
	Wg1wKuAUe+mMtsyL5k3k6Olo+ygBwGE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=msGW2Qcd;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792116747;
	b=Y9N0qCV+w9b179M7Sci6eKuyL0cseTwtIcq2cO76GniaQTVhXF5DHf+zk+2ofTZbmyT0kk
	9jgkd2BhzYXyVRfn1hzAp4UVpIWodu2KvMDFt/e+6SiAEWD3+/IQ6ayDpHYNsIkX+a8WbY
	UP7cCk6NZy3B6J7naYGnduvgPx08rdI=
Received: by mail-oi2-f10.google.com with SMTP id 5614622812f47-5179f3beaedso2203085b6e.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:12:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792116746; cv=none;
        d=google.com; s=arc-20260327;
        b=d7gHXJYct0km6QEYUAV92HFaKpCoHpvQUvodCexextR6/COuSDH15gJpNEkOFbvkLh
         kM+omibIKv8nE7Vie0z6Ww/wD6axeW/bTukOuzHiH45S14LQ3kFMpwndRllKz53Cg0St
         bCxBxUn6WIagZzaZUe340iPZYXk+P93T0unKEQVc5PPSGl62q6OCEYtygOHdLnlOzB0f
         TgMJpNNmSC6fC60P8+IbOLoqwwKA3bPKd30JuLDbTAb25Ff3x9F5xP0KxWx6jZasxyHY
         Ms7uX8ySTbwBU7KirETfgg+45WL7VZwKqpv7ZrIqhaF5Ldeh6yXub+B82jyIm1F2Sd3f
         XXkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=NbuCv0ryWYiDtygGwn5WS0AeqhHnfIiKGVCd6AYwWkM=;
        fh=q9rmAsZ0o8/8kSahiKZxczQNMp0nz9rGF9FXSrfzwDk=;
        b=ilPX48TErdWgN7vf/nax6uXWywiU+YN8C9c5kHRFdFCxP6kM7uhD0MXZKgNeCyyEiK
         oFrxEgLwrCg8T0PAIKLVpgdT+pqbzp5kL44YAfHnN+pShjaXKThhr7dDazb4/3yHHaNL
         oPg4yAD+ekaOM6fvOLwkkGvQqgijUwR8i2bOB5QpNENpU4mYM5hB/LYAX/iuejrEVsQb
         PLpJ8Wa2a9k9LqwWUK6OEQJnx0/xTwlDZlh+kv0XtOdf7fQLtylnA1RASfKNlb/rClor
         Zuc3RwC1aEc2QHgCoXavql3HshXgxNkEtDkERlDdGzS1srcMIZvTzreKsHVET+Wm7AK7
         DHNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792116746; x=1792721546; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NbuCv0ryWYiDtygGwn5WS0AeqhHnfIiKGVCd6AYwWkM=;
        b=msGW2QcdvKGbeoJBF9qyCQHtpXMmufH2ZdYgux6D15ckcx3vO6aVr4Ayeh5rSmYAW3
         9s30KyXPWSTTkShbsilDHABzjgbBIaG7uTh8+Nk69YomfxSauFkD0PXAFb4xvck6jmP3
         jtaPquw1lUY0Kogh9YMBbquJYCjhiBJL7GaWdxwCUaovv0wRCfNczMKqeqdn217F6p2M
         KOoa50u9GyIAkU2ZpMyng3iHjhKyFGOBc8Ow6K8g9fMbpb9Gvp5BIk02g90ft6oSqLIg
         8tFmQFNInnjXMNQ1a/KJ5CmdzthAYUJnVU3ipu9cGK3Pw5sGngeT3TN0mR3PN3KHpJ/C
         5upQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792116746; x=1792721546;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NbuCv0ryWYiDtygGwn5WS0AeqhHnfIiKGVCd6AYwWkM=;
        b=EMqoZgr+OMIcSMcE3S6Nr0sm0YXClA6kLUmZYAJM83h9VsGKKt2FmCYBP5fsAkQc7E
         0+wJZffFYEnkrCFJYBdQ5JDKg0EeXuyCaWDxeCt72rC04po/zfAFaS7XdSctnBfX8Mo/
         tirVW7JECnJwDTBtXGymNDfsJCHTPjauead2JQWiWZNVJdIkhjHFqH2stzo7/ChannRS
         7p6NBkvxnke0uhVIr4/lKlFTDNV+ZkLPMjIxLnu6Dzl0cioBEG4q8nKNNAaCZ/+EGrXA
         zDx5vOB3f3Ws8tTBSNQp2ZACYLl7Adn2j1goY6g/T5OXCcOutrRD6e+3+F4uIFFX8qHw
         ilig==
X-Forwarded-Encrypted: i=1; AKwUvBxFpGcTBEIn4LZMfrDOCzfC74z5OAf3FhwCy51LeEg/n08JapKTMGhyMfz7vVeTebP753U6zc1bWA==@kvack.org
X-Gm-Message-State: AFq9FYJnvkKiqN87NyI08VH2WSORSDQlnSFRDncpi+EzkQYIwXa96VaP
	AsPRFUWOnK1x1NTYxHr+yUFAyY8Mfuj++2OiO2TBxDlZl8KshGhBeWHwuALNqCvxObGfnLzGDzU
	zlyYFL9s4LhPObo3wjSfWTwgikb8H1jA=
X-Gm-Gg: AYBFou3N3bRV3yjyyqsLEdHnf7HoISF5VBNkkzCvcAdCXfsDZTNuuEaUqISSCa5sw1X
	5gn1k90e0MIGTUhzIjOgRG82luAvdtNelCRae2BeG1cxT7uZ57pge/vA2vbssKX4ENCbBvL/MAG
	+q9vxSxxocckAQNh4J16kWRno4dhrHZ+JgFBBZu4PSlYETUbRctUQ/DK6Bd/2I06ERoJaQoXTzR
	WJxpRBRIRSLxJ2DuWxAtkFguw/zhfU2+t+UGeUtE6jd9jHIbrvJvj8Rfn6YvrtKcQZO8RsEMwWu
	F9UOB+7tT+jvDQMTYpWG1kKWeZPtGU9wXFIYqmGeed4rJqE2wVDS09ThZjCR4CmEQKhY4HTVoOd
	lqLC+6pw=
X-Received: by 2002:a05:6808:c110:b0:4cb:26a3:a0dc with SMTP id
 5614622812f47-50c4c7a5193mr21039421b6e.20.1792116746586; Thu, 15 Oct 2026
 19:12:26 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 19:12:25 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 19:12:11 -0700
In-Reply-To: <20261016012622.114496-1-sj@kernel.org>
References: <CANOyQmHhCJEbHpHUZ2P0hui+We7wxWkEde-Vh4k2rRXWovRYrQ@mail.gmail.com>
 <20261016012622.114496-1-sj@kernel.org>
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 15 Oct 2026 19:12:25 -0700
X-Gm-Features: AclHuK9Igmqn1XI8cem-R3h2TrMyNOe057Rl7_ZSLpCcuX45h7PRoh-LpcSd8JU
Message-ID: <CANOyQmHMRh6Sa=6N=hM8VzO0HRaFL0FxQB7An8=Y-X5GX36kmg@mail.gmail.com>
Subject: Re: [BUG] DAMON sysfs: failed update clears tried_regions snapshot
To: sj@kernel.org
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA2F0C000A
X-Rspam-User: 
X-Stat-Signature: dsowwxhrhh7x65bywj1hknmuo3ms7dhd
X-HE-Tag: 1792116747-737858
X-HE-Meta: U2FsdGVkX183QjuzzFuM8cIsYKkkH6tlt95pE9YzPciji3abgTb38gVmJ7tCuTOBd7rteGEwOUnRtIOc/0HHmmDMCbbVZty+RN2eBn4j/v8ExuHDXmsqmUPdUir21DB928hO7UY+jzO82d02SJij/d7fXfAiKuCT2eWxptJXAYNS36VyPL/dV3vvvVVpFclZAZM/qQxL+ABjnFeXZ+97v42zAT4KXwIAHhZ+Q4jJrXGPml2tEasRCy+c2K97l07+t4YgUvR/zIRV7RpHHPXOx8PghTbk8K8peea+yNjWVto5425m2o914QXW13SQ99LKFuH1fLddKghm/fygNfHkbWT+FJVxUiBlArq0Nq9R0S1sY8NvOjmZEmk5ad6IO91b1d6nKar73OnRx5M+KaIU6XTxC6le7YNPF64yTb2amExSUs6Qu2ukDqVocgtlpbDIN5TAheRtCTrV1xxRWKmkmOjBsF5HDk6zKMP4PArFSoD2BljkTEC2agsv7O6fVc0pbcq0nz29zBBJBIqLkHzv6T9gqkI8F9VUdscam+LdvRX/J4gOIGzhW+1cZ7nYAiquvd1ntQK9iDhuDYmdsHbO2OfoFopw8fJLVl3cokAtA+NPmjaGtGm2pKr7AloSwYzZ5WdFyuWBP0yJfCcXt+3Ce5RsdTeP0+ZkU854xQx8Kd7DKO+syNcpNyHUMtTMU7GcYSUFv9M13Yt/3yBgbcZPUiHm/w2gpiTT4ktu8e4jBRkmRKli11SzGU3hZYN44cLkTevWRSC44T+xJkVto1uzSkAVio3udZLewjwBcwkj/tfm6387KRsnv3i6/Y9r67lfLa+TZso08tEXI0ZD38f8mFqHbP0hhUCDKAiVYjZf2r6ry5KkOX8fYO7piKWkzlXcMAALMUD2NjQN2QfWokUuVXXdHpswsrAwVQdMsHEeqYBy1hSCt1bBkMfS750cFNsVMeWpL0GHYaBRCbB0aEP
 gShMoyfV
 AafnsYPeEIG22EXiJ7xRUU57WbQM9T9zorIuFyWmTEj+vYGxzVditGP5AFH+KJkyFh0LBUgA8Pxe0ea2J9TJ8BqMQgVTqlVoju/cMYuJZTw9zidHrHWwtksgEgIUh+LsLf8/wFZtHC96m6AZTIrkJ/N6nO2+/FCnVaQSvSyxClrcVaHeAkxNOc6T1XCZvvn48p3DPAOF9fYuy0uX1uLZj1uBRrFrOOZarzc6zrKkOXx8JMBKh7ffdw/aHTrq9XEwe71sOshNkEtDxGixt1EGdn1GKs//qYEN5/up7nmwUqkfhNkWvq8l/7tv/AXhMpVZsdOzQqSba54dcjRWS35cDxDM+DhpLBFPuEapk8F6ECQ8QHj6FswCyY+c4z9sEuDF+tRBPyJ9ynX+wjxhILcEMcEAwVuZ8VLSkKvqoH06BiHY5YGU/t3ffD13qwIgupQ22Hq5hDdQOLqhx1PueE8hpqCV//rgg279gGGSk0S77DoQKSF4ljnPam8ZIgT9mR8ikMsKN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

> Please do not "top-post" [1].

Sorry about that. I'll avoid top-posting from now on : (

> You shared 4 bug reports in very short time. Three of those are
> from 32 bit.
> Could you disclose the purpose of the testing and how you are
> doing the testing, finding bugs, and reporting those?

I've been trying to understand DAMON in more depth with help from
an LLM, not deliberately hunting for bugs. It spotted a few possible
problems as we went through the code. After checking the code and
reproducing them in QEMU, I thought they were worth reporting.
If that wasn't the right way to go about it, please let me know :)

> Why would the tool tries to refresh the regions after the monitoring
> is stopped?

That's probably not something normal users would do. The test
deliberately called the update after monitoring stopped and found
that the failed request cleared the old snapshot. It looked
unexpected, so I reported it to ask whether that's intended.

> Is this an answer to my bisection question?

No, that wasn't a `git bisect` run. The suspect commit,
`66178e4ec30a`, came from code review. I tested it and its
parent `cce0b334c310` with the same setup. The parent kept
the snapshot, but the newer commit cleared it.

Thx for your time, and sorry if I've caused any trouble:(

Best,
Aveline

