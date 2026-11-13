Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D521606A881
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=sOUiJxED
Received: by kanga.kvack.org (Postfix)
	id 436946B0603; Thu, 12 Nov 2026 23:33:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DD56B0616; Thu, 12 Nov 2026 23:33:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323816B064B; Thu, 12 Nov 2026 23:33:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 044BF6B0603
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:33:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E12580600
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:33:58 +0000 (UTC)
X-FDA: 85428828156.20.8671E5A
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7CBB220004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:33:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=sOUiJxED;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794544436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H76beDR155/tKgd6bms2sqDirr/ypiJD3wLDnQnjso=;
	b=SsO97JXxNselMyWvwylX7mhK/wMBJXnA+pgnEerqOuIMAbp3stox3+K+yCDBQHbDKiK4yd
	iyWsQKYlMN0FFgrfH6DJKlQ7qFC2ADEy7iFSvUohAFG/t7EQJc8mgP3F0iNJzbPqlmLY48
	mzmGmd+VVUFws6pk+DcN4wpJNXUikWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794544436;
	b=CQZfwlihYEEatbSg02VAE9CGg9Ix617YlKRrUDgInENJn8+0kUbUYVIKFhaN8QxK/xGJYV
	Ed+wWJ81IQmuvi/Y0RpN7hk+fJAV238R+GGIJqy1JD3vbqYZtam6ZmU4NJ5NvwvoMcVG9n
	ZD9yPNnovTNIS0oMDcoa0XN5QCgeovA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=sOUiJxED;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b0d0b80fb9so478961a91.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794544435; x=1795149235; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5H76beDR155/tKgd6bms2sqDirr/ypiJD3wLDnQnjso=;
        b=sOUiJxEDRmElnW+w1W/kl9nuB3QxBiWDmi+XbempT5VQMfXbWBuxx3y2kRJz2kUja0
         KyyGtmt+n0rR+bYOYdgsyTccZlRPmtyozK69p7ME844qjN/iAmSPkoiLGxp/kA/TwyGk
         U78jBtnrWMPYYQ8kKZysK35wEMXgrqP/TbvFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794544435; x=1795149235;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5H76beDR155/tKgd6bms2sqDirr/ypiJD3wLDnQnjso=;
        b=ZcfVyXLZ7FOU11Ku8UJkx/3VLsTSg0KqQYbpmztH0mSs5dBl1VKT3qq0jZDsoUhxS2
         xHp95UsQi0n1kZ1qBpFR9ff7WrH4Zg/PWhtaQ9CC0Rzv+S+kKIljrazTTHsFeTvz8y2X
         OInUislwjUutK5lQA15Uj2PeEDBoMhiA9/NKFBKo5/FvFf3NHGaHi/okDrDeH+OR5cAu
         5bOPJckvusfqcFEYCnq2WKvjjeD5gVBIAKJxy/rJDD0cvJ7Q6Z2hEvDbOAb6hreqAMJ3
         5cdu8PKtnSVAHzm2k8yYXZEc/nwwtfULsECAQhsZpOWY//QFALZicD50fewNtrXcdp2g
         gVLw==
X-Forwarded-Encrypted: i=1; AL+hErES386f7Ah8lRtbyxltkO4Pms33pyRcxx3JjO9blF+6EJi9HXtOosu7I0pk7mEFw4NQI//qGRIp0Q==@kvack.org
X-Gm-Message-State: APuU4Z9bX+8FnA49VHYkou4YyENUpjQ1WNlPbQfdDR0KEVt/OdP0ik56
	mu1ZMJZty5TemP4DVNRvW/vX255POmHU7ZPGgvEWMFRFCsyDD5O5WlnEgD8h1gNpwZM=
X-Gm-Gg: AYBFou11l+fuNyU+SybRvGKnp+MQHWeOXukvaod27Je84f3MUjZ/a4/DVyA6ZIOGyBy
	N0RbFJ204//3Uy5pDQwuADNBOkGfjT3VlpZEAa5OxRfnRMIZKoukifIQ2uYKXEse7alWJ6tq//K
	wrK1viJvacrQ7vKVRy7qmsOqDfVPQa8kvsMHH+n+aZjRyF1/rvL38P3nHt/6G3c7ubc+gOewPJp
	CqRgfgu+i3hj3EqokZOzMHijUfFOaMfEbDjE947bzfzqjEent/h1NlSgIZGGFEudnkW45Z338pE
	n2Dzf8rUKjIwz6yc+Tn00XL4TEF47iNXwRTQXnIeTFZffA0uwE1v1btENYN+0pV8/N3ly4b5iDR
	hihbQxsgj7k821mEubD4+CanN7sON+uxqzw/l7QMLkosh8y0atShxP1eKOPWveZqu3PMxzBX82v
	DJAcy79Jvj4+AP+SD+wyAIYgYvRRPGGs8V7h4b0Hb/IQ/IeaRhR/9Za2O5Ew8znVovvpurk85hJ
	TyUn+pQGd7SUmxFRA40eo94+7MPrv41avL44ZW6SOsGUX8jo900D1pJxEOMp54QeEv+avGJvwg7
	aKBevpeSnifzFuoEZaVbLtl/WXhgquHw2OePJz+xnU6U+N7Iv8++BNt+NjI9dEFn2bPNNEuy8OU
	7CQI90er+MqIxIOnOaaWca5tF8tCmj2QPSX9OJ++Z0+BG7BxGfvHp6ImtSZkHUM4nSWJEOy2V5e
	azN8jjDM3QBsDVrGQtRMk0o20Kz0jrti3vblOPNklCQquW11nSbdqHo5DoBdA=
X-Received: by 2002:a17:90a:c105:b0:3b0:9976:c1c6 with SMTP id 98e67ed59e1d1-3b1b0b8752fmr1061273a91.66.1794544435107;
        Thu, 12 Nov 2026 20:33:55 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197b76ccesm7614323a91.0.2026.11.12.20.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:33:54 -0800 (PST)
Date: Thu, 12 Nov 2026 20:33:51 -0800
From: Chris Down <chris@chrisdown.name>
To: Matt Salsamendi <matthewsalsamendi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix stale walk_end after a completed scan
In-Reply-To: <CAMPWk9NE_epOdOCbs1PGh8OQP4wjTObvjU-1Wopmu7SSNAMXhw@mail.gmail.com>
References: <CAMPWk9NE_epOdOCbs1PGh8OQP4wjTObvjU-1Wopmu7SSNAMXhw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261112203351.7d5bf7d0f78d652d@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: uby7oub6gsm37ajxei1qpy7endtos3g3
X-Rspamd-Queue-Id: 7CBB220004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794544436-244933
X-HE-Meta: U2FsdGVkX1+hmOH1l6EJPNjBKoH0o3gdxqjYgSaoW93KP8XwX8m4ue5F6Ij4dyYBQlnXV22G1p2/7CRYMUlHD6PPp2D1JG70gqNzv8jCQL56sKHtEdKR5rV5M2tKSqw4U7cVehlPy+ydOrBiuhU1drxGNM61+5FwB2Uy/R8gmEE24o6kDpKf1CQQ1CfHHJDaInVTXIVGI9FMG2SIeOuujJxG7bNJG0jTycH9OHfZFTj3E18D173jyhoCwH1r7sbfRYF4ER3jb8nIuV3QRXEKlyWH476+B13wMt1Dk3PPpvBqouDDmyoJXlyDIneJxWo5oYhIytRVaLezxXqP3g41tpWN0CUO9U/36g/s5H9LrR+ALmSE2rf8ErqZhJ7j6+Svpl3vOxKda0ORWBkNRJM2KxOmpyNxAbO16vVytTv9ijmpoE4cZnRrAvnKxx8r2vLVCbNu5o6ZRoMkwy62bOflncIZsB/TL5RJHc2wGfCRlJf2qXG2M6zrWeLF14zBqXIVOcGHWF2IRzXiOokzwQDEXQDLvTiOgoAsUR1kpIBcewNfoMePnp89NJRDReGXvULgTtbJoBMGfeAe6w6PigusD7gvOqb9Cjgscum9RsDsmwX07wKV385K3mDFhnpI+haKcPVOYNNm4i3InbusheHJ75jhWX6Ir2q+rNFjyYUL0UxibDYr0VuzoXgHlU5TZXfa13tlQ/ifLRNeMXidkWfE38Sf3skghKfoDxrXAst0idUOjd91Wbl6Yk6brdOlXL2yDCpJCBI7X+Joz+F+BFRbgq+upI7H2GemDXk9SlIiDJ8C8pk+IaMHc46uCJ0ZnP20FTRcQJXPZnNz21fJBHoPSfymTzbD/SPOthCb1sAoD6wVCt+4jvGfZvlUMZZ6L+gZqfTpNZlNpMLTtf90anwwDw97wuU+ID8M0HoxGdSd7HD+rSTe9/4SZLviN8cw7Magwuhw7b+l5knpUzh/X+g
 c7RqMLFN
 16LK3qcTOPwGL3s/xd+MA1RrMQKMyShX9ziBllGy2yrPbI1JPkWQ18iDDXvQKncCXVbF999cn0OwGyzRY0uS+O1ABmwNUHwMt7RRFRg9liGU6FvYSzbXRFpd714iDbOF7MOPK+jDbn8HAHO4PhkUISV8JIXQ9ZPL94TtO7hX/BQrafCoJSvyE5+TRAjrqOb8uQ2o0Z4CcukrcP6VuvsuWBU2B4hn/OQHeAhjAPeCs+5ykf9bG0SjU+YhLQoK1fHpgK92Ekm9NR7suX5Kp4K1+JO3DlcHnDuwqI84EB1rRRPjjC/qseqgKjI2S+wdP68zrbZHNvhufu6ogur7f8wG6k/XssLOpUm02j7BklekJewO1KbqQHk3gyNvriR+B4q+GgVV62nrbk6VT9PGgVwsrXCMJQkagUXvhPIZsxL6yMWzn+k0A1/BmnxXP3lG0NvWTHzHg5c2nMxvr7XNbCHxPFz7P0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Matt,

This patch doesn't apply as sent, because your mail client mangled it. It
wrapped long lines, including the hunk header and the Fixes tag, and took
the leading space off the blank context lines. git am rejects it as
corrupt.

Please send the next version with git send-email or b4 send rather than
through Gmail, or set your client up as
Documentation/process/email-clients.rst describes. It's worth sending it to
yourself first and checking that git am takes it.

Matt Salsamendi writes:
>+	/* A completed walk may follow an earlier full bounce buffer. */
>+	if (!ret || !p.arg.walk_end)
>+		p.arg.walk_end = p.arg.end;

While this fixes the refill case, ret being 0 doesn't always mean the walk
got to the end of the range. pagemap_scan_hugetlb_entry() can't
write-protect only part of a huge page. So with PM_SCAN_WP_MATCHING, when
only part of a written huge page fits in what's left of max_pages, it backs
that page out. It sets walk_end to the start of the page and returns 0 on
purpose.

Before this patch, the caller got walk_end pointing at that page. With it,
walk_end comes back as end, so the caller is told the whole range was
scanned. But the page was neither returned nor write-protected. From a
quick test with a single written 2M hugetlb page, PM_SCAN_WP_MATCHING and
max_pages = 1, the ioctl returns 0 with walk_end at the start of the page
before this patch, and at the end of the range with it.

Maybe it would be simpler to clear walk_end before each walk_page_range()
call, and keep the existing check after the loop as it is? Then that check
only sees what the last walk set. In the same quick test, that fixes the
refill case too, and the hugetlb case behaves as it did before. It would be
good for the selftest Andrew asked for to cover the hugetlb case as well.

Thanks!

Chris

