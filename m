Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326AEE92734
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 16:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6748C6B0088; Mon, 29 Dec 2025 11:13:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621BD6B0089; Mon, 29 Dec 2025 11:13:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E456B008A; Mon, 29 Dec 2025 11:13:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 414156B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:13:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E322D89AEB
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:13:28 +0000 (UTC)
X-FDA: 84273003696.04.4DCD81A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 15823A0009
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:13:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EoIGNxfA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767024807; a=rsa-sha256;
	cv=none;
	b=mKiHWxNLy5hVwH3JYrOL8durBQErx50wrxmoyZrpqXw9/hAe8sHeU6GkOh1hO2ipU99n5g
	lPOjdSi8X4MUu6+1M7c0htQbUljCctbR0KVGvO6GVw+iEmvYFlj2Z5vnmCyftRG06nvlap
	YFh8REqXY/P2ANMhvfobJnvUJ+PhifI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EoIGNxfA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767024807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9Erf7ETfgl9KWaaWih8Z5sENNhvot0mCczAMC6I1y4=;
	b=0YT/fqGKpdJ7h+S9Fp3BOZ/W1TC3lep3V4dWY/qHAaSiFwGdrlP6Ceckrrj8EVxle0sYrn
	lAqAkiVYVVKYOqYt40EDM+1sHWv0u+PRH16/jt7d29UOp+c84JNGdRBS65UHXHR/czf2Po
	AeDLEBFQpu2Wd76celiXMPbTtG/x+Lo=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47d3ffa5f33so15020445e9.2
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767024805; x=1767629605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9Erf7ETfgl9KWaaWih8Z5sENNhvot0mCczAMC6I1y4=;
        b=EoIGNxfA3nuk8Ld+xbFUItSATlk/tr2kJeNsf90bb5bAs3Vit7KYBKBGct1j+KrBvm
         bUWS6DliKHn1JGvLiwSADpY4lkRudY2Pe4R8wAHkzBg7Z1tHkLkG+TCT2Wulb2WgvrSA
         /9YP6f1DuB6WCRiB6NkAtNcWjGWDeFgagxIyDWJOwjUg+2qAG1Gutb7z3970RWQIkPE4
         Uz/ZSfUxgh7/SXRPO5HiJYW37H0aHOdEwdYu1Zw/hsQPIjAxijw6mmV5ZX3OsYxDc3sj
         KlBOUlhl5SbtSHM9lkV37pIQIiBdzn68Oyi8YURpKRG/GfKOAqcZUZa21sNZsdWj3zpE
         3wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767024805; x=1767629605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/9Erf7ETfgl9KWaaWih8Z5sENNhvot0mCczAMC6I1y4=;
        b=T/2ZA8z7g6ZgiR0/R+9rutcpyvYH9XcUy3njDtobgak4D1SSFuhcjrjq/CcpSHXsis
         3cgXfARaKBFHmceigiyDk/2tlZGItHsEIwnDKkOmOSNq+p3A+QY5DtuQ3ylp9Hw1jI6+
         pupBb+xX2ms87KvZSLaot0y37CIkZAwPal5M5MGHQ874xP1Tkc7DgdKGdJ/eXalifz18
         N6TscJqohND8hc54YxdyYvClPYShg/rdrXenGrvKkoI9DJUBiyg5h+scMw3+7CMyd5Ir
         hIFw3NSw4i57uA9orRM9qQhNbQ7fW6hcbd7SOhiM7oD286shLbuSUxgQtf+5kVCTjUyf
         8kkw==
X-Gm-Message-State: AOJu0Yxu7j9k7zqauF7eEgVsxdF9MnoxtPSnQeFHirV8rEh88iTHtXQq
	YcR6DTAbEiihblY3qM0L8ieygtqu603fgK9TB8/lDyTvilOTqmOOSYFv+YkiVg==
X-Gm-Gg: AY/fxX6oQtDIEZTx6plMZvCvAxrpTRhf+7z9a+BoMWxfaDqPXkHhdLzZjjrLl4HP+Ex
	H7magnzHq9or+DUBs6HHSwfogC1Q/t/MXR61RwDhxJdpeLrr8w3VtcAyV95zVfaiDopBSvdamMl
	b/+8bHZMdX9/IzFy6QiCbGCjeOG0vuEm0bmAqelJ6x4pifZG3528yTMllXKvcJ36Ni3iW8miz21
	mAiRSe6FvjIY+JBm/xdkB6AvoCdwYH/mIJTN69w+wm4gVpl85KE8h4Nu9qklA1sdmIdknZyYqRF
	jTXF46FKSttt40H9b/LMCGt0vthgOFH9yC9dAeyU72nnY8t1eNilnLCG22j+/q6J2mc7LoG6J/N
	KtnztkB2B3s/Q52y3q/JcZYhqXXZh0ORQPwxoJxlyQ4NnrDPmf72v00MahZa2NeZlvlyvrdgk7r
	VHjwNBJB6wGRXhBbk1eoWfgpHRUxPXvWtXJTrh2HbdALfxWwuFcF3+iOIVnNX7VjKMbF6/LA==
X-Google-Smtp-Source: AGHT+IEgcIqdK2u+ve0xLk/PMiOg40+87MzQEo9+Y2j/idGPihhLbBW5VMx40/GOgZ9CVisw2OkOzw==
X-Received: by 2002:a05:600c:1c13:b0:477:63dc:be00 with SMTP id 5b1f17b1804b1-47d195893d6mr351220975e9.25.1767024805132;
        Mon, 29 Dec 2025 08:13:25 -0800 (PST)
Received: from localhost.localdomain (lfbn-idf1-1-1405-81.w90-79.abo.wanadoo.fr. [90.79.96.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be26a81b6sm617078695e9.0.2025.12.29.08.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 08:13:24 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: rppt@kernel.org,
	Kevin Lourenco <klourencodev@gmail.com>
Subject: [PATCH v2] mm/memtest: add underflow detection for size calculation
Date: Mon, 29 Dec 2025 17:13:21 +0100
Message-ID: <20251229161321.9079-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAFveykPnTH456rMSRgpDO7VyN2EdP6eOq3pKUBCDdQa1kAJ4AQ@mail.gmail.com>
References: <CAFveykPnTH456rMSRgpDO7VyN2EdP6eOq3pKUBCDdQa1kAJ4AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15823A0009
X-Stat-Signature: x65db9pbieqdb378w6q5jzqyi3dsm5pw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767024806-846960
X-HE-Meta: U2FsdGVkX18j/TOSBXvJ7sBBLXRxtrw3+jaPQM5+7yopesyZ4FH07f4cnsfpedBKUvrb8mIDAWxHWrr+Hjp33NQ58i00feeTTQV9yadPIjgE8wIvvSoMGbYbpXXAkIivgXx4XASEFsesh5TbC6METrxGwaFTWre+sF0hEm8JyEOwV+aOXk8HsTqx7HD3WGjjoDdOpdkKqQ1RUCbVwMmR7c9YH3lr1joUc3hj+nXOJbGpQLDBEvwAl7P5KMSwanjpemp4YA6Duq0xZQ1oVmczRd5599Q5BblP0POXlRLhDGU9AT5hnV99KDWDnq//zGQHW5p4p5Ag3ngxQxomxqr4Uo55KE45tWb1S+/gARIfgvXjYIkXidBFlsCtRUpwb+xXwV4LbbNzreZrNGUotCUAc8L0D660ba4HMtAVKppWd1s0hAQ0lJpJI+jMs8CBw3dsdk7fGFLr9+kmlTL0BHQ20b6Gm2iGohBkbtzggoWFZZ48AqIhBWChQiZMkdn8YG0BqWIcUB3ClritzuNmTq9fDJSMHKPnYjn/fjnCbU71p1RTubc8d2YU7uZtAP984UXGXw6dwIeDLTbpruTY7PDwLUBw2Z1ZXlX/T+gTE7wXqs71Jg6g30YFqDB5JvyAtdWLZlL4Suu0BXOiVeoSL3gjbQPmvvlk4Qn9h7kKzgpVTl07J6CpYhNKzMrKVwX56GveGCe8md8KyZTWInqXKM8iS3oIyxtWGgZpcY3JQcafCmr85O6O2lq1Oitu31MSLPWps+V+DlHX+xPH6nTapNtcIfK5F7bv0VTbPqcaE/sK0sY/D9aIY82hYw+o9cdwGGPL13pnHIoK9WlW8SEdmggtUF21c2/vQqKlq1NBxAn6zc5UT4P6rNRPx070nE7UXzufRU1y3WBfBw07JKkEd4m6QgK9qm6wK3iTZiRApWF11iHCpqNaQi4nzDz74YS60BgdVOlc6n/cKtstvvva9JM
 UL33TOqB
 +VJcvaRNWrFBxRxeIg4b3PG5shTXrvjy9YKsQTqlJwNRHi9DG4Gbpe2WdNQQ7/9as9ymIuDK60LhG4viufBNMndboSEEFOruW1q4ia6ryPxHmpFgc7KxyCjjNQg43sZA1YAZiyvuxhglAEtTHcKWte2g7878AKBxCcxImJPkI8+LylO32o1lfYp/ZZPFhkgeUUtGy0SRysLX5Ugb5B5Qk4LCZcSfdw1cyE3a1EdTg8MN44/jGqe5b3WrK7h3AkL/gofEsEeZ55MCNlDHu+Mtdm6qp1X9l5K/YnaOp5pbRBaBIWV5shsshyT3h3hG0qTP4MgNriHqWfbpXrPY5LKliU3h+LEEMVMsApFMplPwJcpjlp+oEqrOfufT1ewr9AKQ71oKLoZsl8XpfyyZz7a/MMJNkb+b4Ylwsw25eiDijAqBIL3E3k4BW/AEkRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.006512, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

The computation: end = start + (size - (start_phys_aligned - start_phys)) / incr
could theoretically underflow if size < offset, leading to a massive
iteration.

Add VM_WARN_ON_ONCE() to detect cases where the region size is smaller
than the alignment offset. While this should never happen in practice
due to memblock guarantees, the warning helps catch potential bugs in
early memory initialization code.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
---
 mm/memtest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memtest.c b/mm/memtest.c
index c2c609c39119..bac195e6077a 100644
--- a/mm/memtest.c
+++ b/mm/memtest.c
@@ -46,6 +46,7 @@ static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size
 
 	start_phys_aligned = ALIGN(start_phys, incr);
 	start = __va(start_phys_aligned);
+	VM_WARN_ON_ONCE(size < start_phys_aligned - start_phys);
 	end = start + (size - (start_phys_aligned - start_phys)) / incr;
 	start_bad = 0;
 	last_bad = 0;
-- 
2.47.3


