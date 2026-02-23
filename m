Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CB3E98DF5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF646B0088; Mon, 23 Feb 2026 02:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0D86B0089; Mon, 23 Feb 2026 02:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE246B008A; Mon, 23 Feb 2026 02:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF8D36B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:34:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 822E91B644E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:34:26 +0000 (UTC)
X-FDA: 84474908532.01.33442CB
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8A0B20002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:34:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XgKvdpwC;
	spf=pass (imf03.hostedemail.com: domain of 3_wKcaQsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3_wKcaQsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771832064; a=rsa-sha256;
	cv=none;
	b=QCCQRAfFMPbRWGT/HjeRX4tU/M+jogVFYqz99S/gz1//xq7J6+H6Osg1C6L09kIBovx7XS
	3aHerKF08pn6M5bJBV2xMMx2HHAVFR/YrkjjY17ZtfxZ57UW1o4emMF6bnYM479hfgBQKt
	1opJUtxL+jpZ3LRqSYhyJd0PjdxcAiI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XgKvdpwC;
	spf=pass (imf03.hostedemail.com: domain of 3_wKcaQsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3_wKcaQsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771832064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s9KxNHasV2s2NqGw0lhhtRyZ4y7rgrLWzlcKrVq6wew=;
	b=Md5EmhnZavhq+BL4IOalM3mkUm1CCUHk4qXsXzg5JEuxZsuoGwSPhAV/AP5p85Tk3rN34g
	NhOdXcUgn9Vi6iuF2ltwER/kFGT5X/cPdwha2p7ErAqLQz7R6phodq4Sxi/wZkYXOC5+fx
	wrrM67xjzA8f1PEZ2gsdj1HfJ2YTDLQ=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-bce224720d8so2461315a12.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771832064; x=1772436864; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s9KxNHasV2s2NqGw0lhhtRyZ4y7rgrLWzlcKrVq6wew=;
        b=XgKvdpwCYuv80MCO0b7gTtDzHRgwyrlY6jrK75wy0lPiw5VIyDaksoKn/JhR4E5KA3
         5X7kPC6Wzmnf7qTRrmACYEviRduDWW3e5ZOr+/dOtvBeY6Bzos1RBhCm6UM3H1vCbojZ
         BK1q37la7OCvPXbNXHqHxY61ck56Gw1i7RWWRkn17JAUF7tiY19uDZW5qw6NmSAOw9gE
         eKZoFYcBW4zCwaGnq+GLjx069uuhSl6Qoi5qSU5B2BQ2HgUW6r9gCVDomDV1zUBbXn8T
         ZpL21i3iUvRXhKMJIgnCh57xrpFQIBe5A4XtyuZg4BZzDfME9nSYQqG/eFaZOhllOp/C
         PAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771832064; x=1772436864;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s9KxNHasV2s2NqGw0lhhtRyZ4y7rgrLWzlcKrVq6wew=;
        b=s0ktwKqq62oDFLInAdODUz1VONHVYrzZA3o6EDJzUk8rf5PgCN1eV/sbj0wSoeKRx5
         f1UVwh4aTm1XGxpiGMHu75+BwpUAhlhNZNzbga0YBm2DDY4kJ5H5Nupf8N1uBvPUE6Im
         8A/rA7zElMHGtdLhKBy/KC9cLG6srvUVDP6Pm7E6PhbGsuR9jRNI+l5VDLIftyJyOtQ3
         Su7b0Gmnhqw/4qtqApA9HrqkS2ATYL3OXOT+9TAn7nDhSu83R0THcw1Dl6gMevm2Hs3J
         GTk8LmAWRm3942SjfZdCjMESQhgxF6t/V2Xbe8IKx+EozezItMppUf8sjQjSTxzaUDMh
         0suw==
X-Forwarded-Encrypted: i=1; AJvYcCW/n7FiHq3H9iHRSG8ziZ+6M8jXbZG9DFtrTLBDh0t+V85vb1xEr4WSV3Za/OdUsPZEdzLwlRl4VA==@kvack.org
X-Gm-Message-State: AOJu0YwE5qu0VhsuquSCrjqbJLMdzPrBUsvhoOTur5iL+9OwMjI2h6wK
	LB7T1A3E0i4RRj75sxTmDf/vO9K0ZmOe26YPSvA5t+KqlzvNpBrWjuIcXh+JWMNIA+ppNuEzL+R
	pvMs315T3rD9WTpfAO1+bjBQX9g==
X-Received: from pgbcq6.prod.google.com ([2002:a05:6a02:4086:b0:c65:e8e7:d481])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6e8a:b0:395:16a3:c142 with SMTP id adf61e73a8af0-39545fac8b8mr6774757637.60.1771832063160;
 Sun, 22 Feb 2026 23:34:23 -0800 (PST)
Date: Mon, 23 Feb 2026 07:34:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <cover.1771831836.git.ackerleytng@google.com>
Subject: [RFC PATCH v3 0/2] Fix storing in XArray check_split tests
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@kernel.org, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D8A0B20002
X-Stat-Signature: zwgjn788ghic41tuqbpp3ukj55ygx54g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771832064-278076
X-HE-Meta: U2FsdGVkX1+kjattexDnAceu9uOhKGOIrKJcvMIXZfgsOooMROawN7s69zHCb0Yl+C63+rdwynXFqtRXQMBrI1VFAwPXbh0J9Y2Cn+Gvu5gpHmQL6RZynK3HIjY49a/5fbDsQc7G7ru7JXRl5UWWgr9yXNpRdTMYV1Nd6lZRKR9XJ9lurqBunGmY4alGRo04Fl86i8UJefZCVx6vZEYptTiYuopoXYsMpAxlXg9/0abbYmkgHl1w27Ib345KGSo+wvaMxOg0e0vcKnrsfbI057bXg4baTzJu1tVenThv93+YG57bvRoqM1vaDrWGi3x465/dj17SE/G9o2pPwuNS0khUAsAszzzjsgM4zulk76yYBHuV9/DafBa9hcrMZCpwn7F+pUcyAMKfvmSV4rYNBYDsNoyvf3QObPCU/pcH5NYsH/fwRZuEZZjmAJ34XQqNTNc37rkqU15zFkuJQNv26RrC9vUnJ35ZDpa5Jjl0QWitCyUoUFUYaKwnu1LObw8oMsKkcvVuppHvRDo7/2Us787e7Hkbe3cb+cWVOISEwJj60KR2isE7XwntGI46Olis9tWI3I+O3Iz2+08NomEHVhVGBgk/ObvXRmDNGFtqQKQ7pxIeIEnrJEIOZGb3+7UGXzKGDE7gcSXlKYZr9Pyn93RF3WrOws+7S7milavH8In+C8n8wZgNIKcmgpe6ZlvSRx1OxQDCsOiyKhtE3mNV7HfWvJUuSac2XK/Wg6YiI5EQkLPzLQmU30+qw0BycgdvbTmtnIESeWj33ugJ9JsTaEj99qw2I4VPPrw/mNOAqpz83OTKPZlSXi5Sk+N3EufXJ8BjWwNYi40faZOV6UhfMKfo29VdKqwxHCP01i87kwU0ayNbnAe+APOvyPrOv44/xwA1mD3jO2Zbm8IIj6jDtjkHSV1LCauii/kwO+0FCV7S0qyuv2KY0faU8zI0oFw2rd+BwTTPQ8hFEpl29Dx
 a5mWNEmb
 z6SiKWyU3pLMCcXMaibcI+rhj5fYxuHxKFm9yx4MHUtke1VXqsNQtTtNEpK4MIEvLkUxqIFwyCkLzmCd9X6VhilI93+lFqMadRfyZs1oUjeUn7y2+VICcIWgGW3KGLDh3YthQU7+5xzPthHXgGXjuu6xhjHD0OktlAKc0GIEVfZInc1J4xpRj7rb10URNfLQUrIGE6Ww+Hjj6kwi+bjHCanX1GHp609X4/bw15fEFTSQ8rcsfEpFxTfxR96vGssyt79SQcHH8FqHnEnMEZfF+oc9uC4RKk9QMMmDwE/bEXzXqbNW1OQ7ZdeHl/MgX/bEOa8ZQkGi4Uhn5AH15GwoShUePqH542qkWJCaslH5ojEl5ULPMFh1e9T66IRbjMlZ0mbaEBH1/aBwxhVbcsIPyHg7voDR08h6vWU9FWBZJZ2yXKGlF5/2NSRqSMhSod8d9qIlUC7a3pcpzfrg9TwvlZ41iAiz2th3OjQYJ3OdVnzapAtSeosXBouULiYP1Gd9U4MSFWKErXjrDQmKyR1kiUihZnBDyaNUzYzMNnJd4AOFw5gVIC+v1KwvGMegtjvgBjwwqs01zbFC83G2bA1iXByv/WT+tn+oTL03fwK8yZN1HWcbB9ac0ubJoN12vUhPvyu/LYo/sUOy4gIsedlb51qOQ0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

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

Previous versions:

+ RFC v3: Cleaned up commits and subject references (sorry for the noise!)
+ RFC v2: Rebased on Linux 7.0-rc1 (https://lore.kernel.org/all/cover.1771831180.git.ackerleytng@google.com/T/)
+ RFC v1: https://lore.kernel.org/all/720e32d8e185d5c82659bbdede05e87b3318c413.1769818406.git.ackerleytng@google.com/

[1] https://lore.kernel.org/all/20251028223414.299268-1-ackerleytng@google.com/

Ackerley Tng (2):
  XArray tests: Fix check_split tests to store correctly
  XArray tests: Verify xa_erase behavior in check_split

 lib/test_xarray.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
--
2.53.0.345.g96ddfc5eaa-goog

