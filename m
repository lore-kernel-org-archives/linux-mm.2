Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A68C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 02:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8D46B0088; Wed,  8 Jul 2026 22:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79756B008A; Wed,  8 Jul 2026 22:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969306B008C; Wed,  8 Jul 2026 22:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72EEF6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:15:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0678F168E94
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:15:04 +0000 (UTC)
X-FDA: 84967620528.04.25736A6
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C5DD100005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:15:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LS2nkebl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783563302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zWeqxfAf4eNddMGQ7g2wAFFizsD39eClXtJs6pIUh4=;
	b=3NzDdTck6cPGwcxwIrkskLH4AlZ3NdedtjmsQUAGAYCdz5N6ZF2R5kPXOMTMDbBSVJjJBe
	aeQ/EhY8PAMKcY5W5cK+a1RgdJCyXYUICFT8Grfl+MSeMK5L2ThvaykW0OVgwZSZORf1Au
	19jIXZaNIofo6tVcV1E6myEWsO8p6qw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LS2nkebl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783563302;
	b=I06Jo3xGjx5OHQFnutFjmRov3OzggXvCHjOnOd3mxrwmkmwN4igCi19lYpHf/fnmc8/pMc
	88KbdRyLt7RA7kvRvRqVUxIxDWXucrL8PYPZQswKNJbE2FfCMl6Tmd5qCAv0CaY4Ps6QWy
	ugWUpqmjTU0WFeHtxj6V4c+brg8OBew=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c981c2c37cbso280488a12.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 19:15:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783563301; cv=none;
        d=google.com; s=arc-20260327;
        b=FHrOOF+a3qHJ8dZV7nAnTC9XqHYEGs+QmwkH7bnJ6VchbgeYw183QU/JOoVw2sY/z6
         hhUQ7pmNaed6pTaVrCO5hoz/nQoXrG0qZ2/mvGNEpj0O0HfpTtA4ISd46UG7uWPhEZuJ
         2XJOVQPcLQjBqkF9/X7etBAIWGNKJoup82JyETsqhNBHB8Flgj8jT+ZZMv+E4JoNOKIc
         M4q/1FqDMQ4AoYXkdg2F13mw/M/ujOe6n6PBCYgpxSOodwmVnAJXImEdlSJ+5vEOOzrY
         oNUaeUt04Q5heBqukXmJoIPvg27MUxrzzWwbenKx1565JhTBHuLLyaZcjmnGlT89mzac
         ntbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=4zWeqxfAf4eNddMGQ7g2wAFFizsD39eClXtJs6pIUh4=;
        fh=tiDq9UOceyz5CIzFsqmPoVZBUOAtn1/nFSDuZQ2WvFg=;
        b=dztLIrsw/h+y+rjlQsOamteWeCMhSvYtVu8/D1pefTi/Z0HyY4ztZOF9MMm5m7LXPA
         z8nbrMJc6a1CxYmsXZRbdsUFK1k9rM74afJtdnX0ovSyoyK5zK31QRGF+bZsF/V4QqcM
         06kR/8bdJFotqMBXmdX9fBKr0EUSAE8ztWC7zYX/55Y6lkRbINoFL1vKAEZpUK4vs/8q
         tMqJIq8UvYuinogHdbjD68IZctsMJIR4gK0jW6a0OPxd+sZCv+nugp2neAliVjf/bq+7
         Lgw41CHtwQaFd+EUz/vpJilyKMxgn4r8JV0pn/ekA/YyFW5ZHi9JHzwjkxwLGGLLzkDZ
         tDHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783563301; x=1784168101; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4zWeqxfAf4eNddMGQ7g2wAFFizsD39eClXtJs6pIUh4=;
        b=LS2nkeblvN9e7lw4erLGca68UwTUZEXHcyri6lN0oSkzxuRmmEemsPeZ0k7Eonq9Lf
         PW0w8XCgIm3va32ueSrm6Y63PRmV19PuyL3ShxId5M9m7jZZaAtcvypvosfTFm5SpI5K
         mdYiCv9HSUq8W3zuBNusz33+hBqAWX3u6LZlU6nEPHAffGRqkfNQP18HX1iIzJxtaqzY
         JRWCZgsJ0JPFxVaGSC4LgA5jbRmwKpJeGg4DlexWPXipQYj1pgPp0nuO+m4n6pG3q4VD
         9r1J/8OKPM7zmteoTvmxQdrlP/QQD39wxu2ZHsStsYsWF8GZb3tx5FGlYQalSD/b921A
         2yMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783563301; x=1784168101;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4zWeqxfAf4eNddMGQ7g2wAFFizsD39eClXtJs6pIUh4=;
        b=GR4sbIYtflaOchiP2I88D+g5z/icoNT3ITQJvDyRuvAPf1ZoBG7Ubn5zEN4VcIO42D
         0n+f4gfx4+BjLy14DieZRFHqeXms7mIJ8mI6XxLq6QI2uhoM4YqDMuXR4KCh4TU1HPiu
         UZRf3ubp3viPUuAmGNCqH9iIuINTT2mgaPdVgaB0lxbgBheFhGdvGKHMqFBESWXWNbyi
         TqE4DuKZKdof5Zz9CzXgUe37D4gSxPVlE8VThmLTrgjqiYqOHbMwjJ8UsmwZ+Je24fJw
         tcFiiLCD7H83E/XLk25FcOhe4rz5h3huUMvZnfuD8+0inT/dCWTwDLVBvYI2ZH6gJJYr
         QD9g==
X-Forwarded-Encrypted: i=1; AHgh+RoNJGq0yrJ7Oqkjq5OVRrTqjqNdKhNT48zK8qorMl/vxQvMk9EYUFCGNQIxM2UlPGY/8WDvkTcmfw==@kvack.org
X-Gm-Message-State: AOJu0YyAEUJqXfHosTeDZEfTu3Fg8rqQQo4QblCE2ODfDx9+Y4EtXEwh
	AEhLgalbYzLxAzbPij7s2PKUYMmhnLPCIAfbrQ5ssHmYbXCPzyk9N5KFyjw0shnrPXWQbctg5J9
	Asi08hIki+0fnmpceuOYVjyUeXm4GlE6x/p4kupeQ
X-Gm-Gg: AfdE7ckp24gZhHlb2IJAKkLmzkwJkhICOXSp3yZDlhwt/nbTyqujX52j0WZPFkF6A0l
	wRvSJo1hBdLmkqCLzcgl5HIqkOrxJsJxsVwpkuJLmzuQxxqu1sKKfM2sRCDD95OJltQw90ZOn6y
	NFe5Cqzy/JbvYPZeDYJMht5HQYecRIkNS2ZZ4FtosSSw6b+af9fT/9c7d/jKwuj3jXLSqOPrNJp
	RhMj3GC/5kNYTMYS6aytYcWN8ePrmmR75XJrmNDV4Tdg2YK71SxAMbE8DYfgAFnhA8kGfzv7vJB
	7fLQ3JxEdRTF3qnVH3JKqzBvq/sU
X-Received: by 2002:a05:6a20:7343:b0:3bf:76d5:cc2b with SMTP id
 adf61e73a8af0-3c0bcec1928mr5597463637.22.1783563300230; Wed, 08 Jul 2026
 19:15:00 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 19:14:58 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 19:14:58 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
MIME-Version: 1.0
Date: Wed, 8 Jul 2026 19:14:58 -0700
X-Gm-Features: AVVi8Ccs1t1sSugbFQb-WlYWvA2uB04OV0NkpVbmjtfPNVkezHBwHBjNawuYamk
Message-ID: <CAEvNRgFMFK+pPZuV8ythDa9B3yhPy+mxJEhKM-9s8g3WO5dp+Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Fix bugs on HugeTLB folio allocation failure paths
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
	jthoughton@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C5DD100005
X-Stat-Signature: hi4ekuaygjttp7boxqwyb8qaw5wdbz6m
X-HE-Tag: 1783563301-72763
X-HE-Meta: U2FsdGVkX183pWPEa64ilZCjLrJyKwha14/NySuv1reJ9tpwsQ7/5FHuzmHVRGEEqrk64grXIrMhN7DR3s8XlNMekmK+DpPEkx6zREWCmQ63BFiI4uPkDFTZdvsZvazMwqNATX7q9DIlaIQWIXVZp/mfgHx1tmH0i8p9Nwa7LEW9dtGwLczRWYbdeuUIn13fv52/3CXCKFxolTuOt/JkWWWhcGvcl0Wj4EbEuD7Ip6REdjGWKU8eDojle5ci2dJ+i00dYYKsb1C5GsWynCX/giV5vQ1FKg32fwxh37djyVG2Qo0HlP1bKoer3NSgxtekTi/Q2EUGwCE5POmW+n346FJNm0tlc9NoSeiZBi0jUI2O77f/IPc6mPJ0N8Gq+VVPppqwrH3B8LyW9yqAhUso8SV6UasZOktFCA90xqzN6U3/VgEz7jKzry81rEi6MnyAWKWjPPkSrNi4WtTO9ZeJd+c0NKCn1x1pHutkk/c1RwaWHDwKsqjyWazzS89ogm18blyY+EehyIRxjHnfcoYcDCznKr8zVznTcXiGBQQ84Uh8wJ27VuxOppsjfEIBAqCAlQvgDNghPBcF2hnfLf7bwyxfSsV2ssp/lUEY8bBKJ7zfXs9YMNwbP+hvSx0/Ut/npExxEoDWu7208TY9lF71PvtSMhw0VaPf2xT8nBFYhcgS7vNTUA441UfDCN70COxFiHgcElP8gjaGOggAWRZjDADMAB/mAoLllwRYqIbeQhLl7VaBHapIIqPx1e1kZhEay9UHQQN62bP8uYNX582kPzSw2A8CYPzb6JPVHrewdnfS8D6v7raErtygFSQ5K10kIKBm5MDNft7juDQCiLX2yC48arUyDLaBYe71SgE6DJ8iiZONE2+rCPtix9uQM5bgxjGvEGCQh8kDzzrnx/snnGAK1RZXmgC8XVrjVVP3VVeFjxedvRWwbOm6WFLJvzF/a2iCGfy+SPzmCVpU7UE
 PlKnfJS5
 EqXmtDRu10VGju19tJz8VxETh+Ym4JCX2O932ET0CKRkyQUorzNRjkPxIy9AALvMwG/BacOV1sioFeLv6FpLk/alzGVWg1L28VSADb9XNQF758a6GbyrSafSo3RYmXmbWoGvCY7aGUnnapc8eg3D8hVAD5qbHaz1S41baT7j70q93oGG4uYYce7pHFNlHWEhHBgEZ1EAkCCxQfudHz8ZaDRktLuSmNZZibkRdDXncryF5K6JClMCt5v/6QJ9rDbu+lr1eiF5PLQ9MwOWL2jE8om9/Vg65gQf1alWS2SDg42vxZNfiwnDb3djcxR0qvC3yeSAkc2Ltpu0/uBuQHvApSaGoDiuv6LpowtZ9Ov6XPp1Cn3YqGMIzPnLfmiTu4UzHLUDDQeTXRzfLExOw/jo3rsRufMYmvl+imY8TM8jDcmpho70ju0iRvLEVG3MTtT/OzHWYuXfRmmjw/RXKgkolTsNHPBVDb5clXiqIJRFyXfl0BfOE14mGcHRedj7A4VuCA65GnNyvVLhI6PfF4WfnLgxZg0+sxmKym6OP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

Looking at Sashiko's comments [1] again, it looks like there are even
more issues. Seems like these bugs are quite deep into the weeds of
accounting, would definitely like some advice from reviewers and
maintainers!

1. Are the issues I've described the correct issues or did I get the
   wrong root causes? Is this the right direction?

2. Is there a good way to split up this series so at least some bugs are
   fixed? I kind of clumped them together because one fix revealed
   another bug and so on... Is it okay to merge some patches that we're
   sure fixes something and leave other bugs to be fixed separately? (If
   we get to a nice fix within a few iterations we don't have to split
   up the series)

[1] https://sashiko.dev/#/patchset/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b%40google.com

