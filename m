Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5309AE7E0D0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A056B00AE; Mon,  9 Feb 2026 14:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5D76B00AF; Mon,  9 Feb 2026 14:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BF26B00B0; Mon,  9 Feb 2026 14:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2666B00AE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:16:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 314FEB7528
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:16:59 +0000 (UTC)
X-FDA: 84425875758.03.DC761D2
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87C6F140004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:16:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p8dNNdD2;
	spf=pass (imf23.hostedemail.com: domain of 3qDKKaQsKCIknpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3qDKKaQsKCIknpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770664617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gltt6Xe6DQ/hUW9baNp0LT+ih0woRx1cYGTgZsKwvqs=;
	b=FU78B1ZZy1HdUHqzLIyC7pl+C/qqIuvwURcwsXyD+0sykkcomPqip7zabzSkeKhFAzG2Vb
	QZSJqvWTg4qbbf8msf8ItzSHz3jcyfa+NwYrAKjRlD7ORzTaNR91bbYReayGX/59q2Kkb3
	PuycRIfbX1MZ/2SFu17aDs8W94yR8sk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p8dNNdD2;
	spf=pass (imf23.hostedemail.com: domain of 3qDKKaQsKCIknpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3qDKKaQsKCIknpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770664617; a=rsa-sha256;
	cv=none;
	b=gtrrTNpgL41cLgTtQeliHCG//0f+xwvl7iJn1FYjG4wBLpJEVcdJxGNNAHQVaa/oyGAnAA
	35oTe/3hNbNDzUGo1AfY/mwI/VlOCdQ5JFzNrx5KosLphRvvtIqFtCXcCSo1uzrdsV0Veo
	bR0EbLF9Kh9TsYqfgg5Ow3xxAl0Idj8=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6136af8e06so2166320a12.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770664616; x=1771269416; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gltt6Xe6DQ/hUW9baNp0LT+ih0woRx1cYGTgZsKwvqs=;
        b=p8dNNdD2fFuVQ+Rxi2qlati34K9DGdNaJQBbjsfxc6HuB7BLXhr8XdUYVv4eWfNLvk
         +uzKR4VXxZJPNDHQLcleLjwFiNE1ySa+iFemzCPnWI+JrSwiw14jKxXy0UnNjRoALVfh
         CnJ5d+8LEqQASNSq7gn5bBjoypjT6lrGc1KWle8ktD/iGTVyOPpA+vdAdWn68nIprh2i
         nRVm5l1/klxlRqZB+vePf9GwEhuY+8aKm9xpmSIYliqQVhWpHejz54a3/S3CK/2xI4Q0
         DTxOeB6q5dmt8GpD9viT7PCp8/oV/bX9Se0xFhB7PAOCpghFyEL+72VERyvdzXcsiH29
         jMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770664616; x=1771269416;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gltt6Xe6DQ/hUW9baNp0LT+ih0woRx1cYGTgZsKwvqs=;
        b=sEbV0m4c+C7XRB1KwnjoVCDu/uUl41c6iei9mLaDxMuUobMRvisnRoEbczLj5HzRiN
         wB/EpyeyhDdLJxD0CDvDaUsvIDPOOhYZgw16ZD4Qbnupn6bYQ7do2sb7zDy3t2Ed5WDx
         ArUjQWTq0j+8mo2UFCGG7fZWkDrt9pfPsVkPWRswnsHpx+6l+vzDfHIZ8PoWNE+WSrLc
         m14+sh2QfYO4RvoSaT3qTTjArHWdUHAHxxE1o6bauwJUUOoAU5S+nsjTKXEI9g3NZd2j
         iyZWuTgk5gBCIB/Qgs8bRmkQ/D3LptM9U6PVYb5eYct335jzy121kbN4E9iEe8yIhh6M
         yuxA==
X-Forwarded-Encrypted: i=1; AJvYcCWKRvQQ2DNm9jKnU8zUU0+DkNQ0+DkK/RiFPgNhTwxUfCKww/EDX/XbDmwo10B1WDPpPhT2Rukngg==@kvack.org
X-Gm-Message-State: AOJu0YxE8zVshALQq/BT0a8lBKMaDxZAtxSs5lh++3hJzeowjgtYPiZA
	cYW4z9GgkRY1lEdKfafECprf0I0hT4mTyhWqbmT+pWEjKwAeRhH1yrwrmIDHp5MWBuheNAXM2yH
	bUbO7ZjqRG6xpWseUh6x5T4wLwQ==
X-Received: from plbjy6.prod.google.com ([2002:a17:903:42c6:b0:2a9:628c:cd39])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f54e:b0:2a4:8cd:c3cf with SMTP id d9443c01a7336-2a951926c4dmr98825655ad.49.1770664616237;
 Mon, 09 Feb 2026 11:16:56 -0800 (PST)
Date: Mon,  9 Feb 2026 11:16:42 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <cover.1769818406.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 0/2] Fix storing in XArray check_split tests
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: oqunqkd1iuh5dsfckezgde96zf14kj54
X-Rspam-User: 
X-Rspamd-Queue-Id: 87C6F140004
X-HE-Tag: 1770664617-550960
X-HE-Meta: U2FsdGVkX1+mr/TxnW4aMQ6BXCkL5uFrZGm22EWezQIRGJF+AIeIyYD+IBA4/pkjg1EUsKelu4hoWlSAg9Ew2vgndKMyIzDkiONG7zogQCwiPoASQGGAlNAeQBLQtWIs28kpsHejnHL6jaMHRd9zFNVU4XtUSLG0X0Lu0GbFzQksm/6dXplemxGOiVSNQBGutfMDJY1DOD3BYPsOxMya7RDndkVfdq6RvN9r+7WRIEHZTKyJRcfhEGdhH0K0Hp4cvsPCgi550Y44JJHDLoMY3DqestCaC75P1mRl4F5q4yqbEF6CN80ZbpbkOxHZXPfwEWesEFj6LzKDxwxmznVTENXrP6cKVugtOy6BVonHmZHS9J6Wb2Ee4nt4lpgz30N+nzJAGzI7ak1zQ6W7VVXRI12JIfmZcgoIpXs7TiDJvr770cnr3xR1BV9B4zu/P2da44QBTPXpsn4CVX/0ErqdJu3QaYDn4McLQ60OW8/yDjrFcxaB6eW0bEjg2XUKvZsBDE5/sidnn9beW7UgOIThYsNO9P8l9PNesgoCECAdgaMszg0EEwTYT9vxTSloYL6bFOk7FCAINiDffQnXtpoQwhRPw1ykUHNz1JeM4hPh9rGQLAtORVGuL6AKqubGg6/xRp9mU1X2lGPBYy2chjiP4WY7c+DBJAwznl+3r5oW/DKaI4GWm7XEB/lE9cYWFjWwK12zu128wiQ6qC0GlT9jT2S8Cn6VGmA3Y8sy7OB4Iumz421s48XYEoMGyebGAr7dhdE9UKR0wxB0kmzfOVRvh99Je9SX6FrwKxehKNemJbvwTIj+Vnro+XaAIn86yAvQKW86iREAcPupGZQypxyjgb7V7gnNZSsjsttATzwVtongH3uvL4WwiqkOkbulKXF7BjZ5sr533vCmjAm9ezDmlfaNSBSuSTieUKyvY8nyjn0uWfJ3V/WE+jRJOzk/XTDz+/t1nOGp43pFzifdgP8
 5PhH8Rii
 07KV7JEBpUJioocduan4ttIA8JxjpeycoQym6HZvKU5CiSTM6+pWO3RfjVrdwL8l3alKfr7NB4wql7ihzPA0QiJKx2fHWhjN8w1u2rGCZabBpXVqHIhvOXWbJcmqBwKAHg+ARzt0Hn5C0WrkHUq8yCFvclixc260aV/6XiKZffszNucKTU6hn84uupCa/i2xlH2DYKtnYdgnirKvEe1xrl8Djv86s+7+qYdDEFyaXAn90Mvd4cLsVwE70KxXyxUUrJYbUWXMMykcMEh0btGNYf1i320Oig2iPMM5OS7RRnfcOFvRsCIIdv44WFQNrf5VzOHcISCUApp4kOPuwiFmRUK6MPkUu59Ri/EtzF9+MNldGIRJjPCYVRu+CxLPeQEuylBImN9BiNE+AeG2ZFF8eHoZa1qhtfChq/wLvmD3XuxmKXD0YVhjUjwxw6jD4s1fyDiRUJ0hgB9NwHXu72iVcjXXbEG8t5FAH1Vsz8DSyjx0TChOIM+3jdaQR4O8ODc0VDOZ29eDtOKMZJfp/IgTgY/6tTDnx9SD9C7rtoOx6SjW8P58HvGL8lMB6Eo1U9a6Q5sYs1dWcs+vz0CGIpVG8U+M5zf2Kom8aErRekGwnJiXqq5eLsuUiHYgrMIhoJYuYvsnRiceCsAGGghsYszbCZfWP9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

(resending to fix Message-ID, also gently nudging for feedback!)

I hit an assertion while making some modifications to
lib/test_xarray.c [1] and I believe this is the fix.

In check_split, the tests split the XArray node and then store values
after the split to verify that splitting worked. While storing and
retrieval works as expected, the node's metadata, specifically
node->nr_values, is not updated correctly.

This led to the assertion being hit in [1], since the storing process
did not increment node->nr_values sufficiently, while the erasing
process assumed the fully-incremented node->nr_values state.

Would like to check my understanding on these:

1. In the multi-index xarray world, is node->nr_values definitely the
   total number of values *and siblings* in the node?

2. IIUC xas_store() has significantly different behavior when entry is
   NULL vs non-NULL: when entry is NULL, xas_store() does not make
   assumptions on the number of siblings and erases all the way till
   the next non-sibling entry. This sounds fair to me, but it's also
   kind of surprising that it is differently handled when entry is
   non-NULL, where xas_store() respects xas->xa_sibs.

3. If xas_store() is dependent on its caller to set up xas correctly
   (also sounds fair), then there are places where xas_store() is
   used, like replace_page_cache_folio() or
   migrate_huge_page_move_mapping(), where xas is set up assuming 0
   order pages. Are those buggy?

[1] https://lore.kernel.org/all/20251028223414.299268-1-ackerleytng@google.com/

Ackerley Tng (2):
  XArray tests: Fix check_split tests to store correctly
  XArray tests: Verify xa_erase behavior in check_split

 lib/test_xarray.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--
2.53.0.rc1.225.gd81095ad13-goog

