Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DC7C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE536B00D7; Wed, 29 Jul 2026 10:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887B96B00DA; Wed, 29 Jul 2026 10:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CBE6B00DB; Wed, 29 Jul 2026 10:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54D3D6B00D7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:29:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0588C80666
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:01:59 +0000 (UTC)
X-FDA: 85041675558.21.47F376A
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3CBE78001C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:01:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Bwcr5zef;
	spf=pass (imf02.hostedemail.com: domain of 3s-tpaggKCIwzqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3s-tpaggKCIwzqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785326517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6vZmqUxcdYhUIdSFB5PctycrIEjAwj/FRDgFiBIT6OU=;
	b=RsIhr88HDyUOXvHwhx8kuc7YvwSoGDtvmeSku/GWnVftkjgm5WahCJ9tND4bsM9r5ZcgsD
	7HaHPgDtHrvqP//w9lPSibqsuWL03P1MGTlTU5OUSDPM7EVwkocuNI6STIsSMeSXKQrRaf
	EhWSgO5H/8e75tfTCGUwOBAdCfMS0wI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785326517;
	b=zwdJk8gedgKU0qbYbIfKcWtWafGzUus2GzTDd0NGZmBGbYmzGl4rj4hXvs7hrI3yPnlG8J
	0JTgSGEeTJrgt+faFnXE0HOt66u+F0Cf7KQgG3AidH5bP/xCtjc5kryMxEklfG1W0EuI2Q
	i62i+JE0/k2Y7bPe1X+5P5BXtwAY6XE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Bwcr5zef;
	spf=pass (imf02.hostedemail.com: domain of 3s-tpaggKCIwzqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3s-tpaggKCIwzqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955b84e25eso6146705e9.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 05:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785326516; x=1785931316; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6vZmqUxcdYhUIdSFB5PctycrIEjAwj/FRDgFiBIT6OU=;
        b=Bwcr5zefbbBRuGB0lFlLjTjDrqb8/JIKbjcfkRD4AqBaEfGCi/OxaRJ1h7ZRk0HsSw
         roOUTIVDPqdhRo3MorCOcTvs3YM2zY63vaPLOBz7caXXDro4rX9Ykra/T04XM6MCBwV0
         RbXVzyAlCbVsaZW6ch0lB1BnrAoV1aY1GdfldOGvcxiAj7b0Fhg/HQG+3r7yPuLElKe2
         /AXfMZiqXcGCt4J1PLVha8Cl+Ad5tLz9hSVr8TGpkqYsQlVwDmMMmb82hBZvOw7TFynH
         z89Jz4SOpk89BY7j9xPAbEQowSNtFKlga8TvlBjziJwtVme1oRnoFyuY3rWsscR50x5M
         eI1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785326516; x=1785931316;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6vZmqUxcdYhUIdSFB5PctycrIEjAwj/FRDgFiBIT6OU=;
        b=CMdhGLQ9sxGD/QVy3sz5DGbncPLbZgvIyrbgKscXhZb1hM1DrQJEGu+glktK+IZVex
         kddjZhFVRgzU9OAJ1iCEOwDuAKPTmLKSRskiibsb00SXKrJ20kLX7o9RpPuYnBYUgRrQ
         cvc0m2hjiweR/DHFqMuANUbqUYEoQoAVjQp4xjbrVz91nvdY28b+RsYp1MHv1v8dBp0e
         RxWH0gT5yH5JOhME5WQ0pDVBQSxFLGRXStqR5FzLhCt+8y8dXaGqxjgaIPG2SrzxTCmD
         fU/qYaP9EA2OqEIkJxqnCdIuizlk+qCO+h4qgAClzUOReXNS7kQXdaorgfvQYJY2lOwS
         DEgw==
X-Forwarded-Encrypted: i=1; AHgh+RoHKG3krIHjQHMpvxX7Jl3vhPyfWW3GiPuEs7QTsZSb/B3zTSGA6jCz29cU6VoYDQmUQuFWforuGQ==@kvack.org
X-Gm-Message-State: AOJu0YxrIAdPJIPeO4S4x9Jnl5NQBPlk2tnVw/bTc6OxuYBSs+xVxPKK
	9zsIfqnB2ggtVNrslKQXic98RFqok4DNeuaA1ehS/tKG+viHL4b0iDzLrfamXGw4q2+2WB51Z6k
	8b6fQh5daeBE6WA==
X-Received: from wmjy25.prod.google.com ([2002:a7b:cd99:0:b0:490:b058:c623])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:630d:b0:495:5365:c0d2 with SMTP id 5b1f17b1804b1-496c6558b53mr82888125e9.14.1785326515378;
 Wed, 29 Jul 2026 05:01:55 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:01:48 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAKvraWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDcyNL3dTcxMwcXaichaWRSWKipUGSYZqJElBLQVFqWmYF2LjoWAi/uDQ pKzW5BGSGUm0tAE5SZUlwAAAA
X-Change-Id: 20260729-email-change-8924aa90b1f4
X-Mailer: b4 0.16-dev
Message-ID: <20260729-email-change-v1-1-666ae7c2b7fc@google.com>
Subject: [PATCH] MAINTAINERS: update address for Brendan Jackman
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3CBE78001C
X-Stat-Signature: g7sfwfgxdeg5fn8r6e17hqfzbuwshbi9
X-Rspam-User: 
X-HE-Tag: 1785326517-796113
X-HE-Meta: U2FsdGVkX19uMg9jakbkq5tR4cm6I77b9bg7Y5eEc7MY5cn0znLfrK1BlroO0kmaDRBnT5+ZUFmc+0ITPvDwwDWodmuQz2vTifq1tFD8FAIg0LRPYtAcvURAp5YHeGm0fOD+HrvSiXO7I+64ev+GiYWUdWc4GD+Odxt7vnUtR4p65ASMoEwzE+oHAXY6b9WqZb4GPEkIj9stUwOF9xTFWcOgNqmYSliA5kYOk8pIJygS6pJjzmweil3a3xDGHS1KBJ8w79Me++JtYW5jqkBRnxWwANmCoHEq9beazX9swdkWPAo2NX2NtjqRYdFKqCScQJc80k36+CmavTKJDncYXRdd+IOtr0gVRRAiXTXESP6FK0AjTGcltbOxXzmM0tzTHidmMNqzglk7lXVhz+rigXJUQ0pxnacNtBpAkTzo0oV8ZY0Cyu1Fpv1AkrF5MjoWobIKG56oId2h9/upVW1BKEuiky98vZ448eKvKZykqhznJ8Gji6Z39O2iGI6dF2B0sXVw9tXKNwbDa/p9ri84Lmi1MAbMKOW8RgSo5ABuWQra/B1I8EoeXR7YNNW8V8DZ2OCRTzaFUQtj+wpaAD05mkl4lRyoAQU4Lve1/yS5OTLmugwLXArG+R78+8QNLHkdV98kcK3rHXy/yFbYT8JvJivV1x/URJqFqbcVo5Q6iKrf49TVAQJNKCCiWJlMMntiZwtU5asoAQmF9GsPXvd7zfQoh0edk1TLnUBlayrTpUm7BldH27lWm5RbJAOT75K29C5d+hIZ25E3/HXigKHMfdP8mX7RQA+yk7ZmV3Vqwr/8f7DDJK9znAsCAy8DE0aITb+zxTtYHNDrK/HJCODf2xUvOoGBIxzzvqFtuyDPqJfYJT60M5WpdkWAHdOACSbX5HZEKym0O7m79+a8csRyE4CaivXzURc7EhnH9l+mBpBL7csyMHqDnoEzRSxq9K9+B9Mbi/ya9uaWpCeIqK/
 lsTuKoHZ
 owmDNxkduWLKNKGrXA41GsqSO4GdokLhcZWVTJ2sBoCfj1+As+KHIoP1Uw++4Y0DDC2BZ15EevuRcBkLLoBETknlUtC8NeviXqmlOLuAK4pLzyqmAzEzWipkol6lwdq5UJybKlYP+g1icD0cE5EHILd3y2Kj8OZMchav3THYTTfuinzW8u6x+eG2/66do+n6N/Xog6WqcfDKSNH7/NMLy/SsKrAE7NJX7Ef3xCUpqb8CU1obsFSHX2VG9ATJBregQt9DCT+t/NkvsN1J9RyH78bx+Neif4dlNYGzfYjS+T/7msN7Ua8NNbof6oKzXpZzlRHvLBILbswMo+9Q0UKqpvn4CsevKH69Px65tNHZOkD7Rl8Nmc3g9AXHAzOEjuw/faUa7xz5NbzEJWpIa3+v0nWm5FKkpgaBCoO7L55nQcQ0YGwhJMyyyu/2tY7mFI8wKsm4qJrK49og7S9X3zO9Fjk/U8bzpLDaqpTQwD+5jTa260KgSzcQgdmaUtmCZ5S3N8GobxqhsVnjEWlor0TvJM9QTZR+5V9zJQk9QlPMT7qy5dzR+MB3ACr6OLQ8nE8KfxWECMQ7GRBKxtPQlr+wGDx8oHcqvhcIFP2GiS6J8qCEfmup0grnh/jJEZPoTvVd2VA8VljoAgusFLV87zyTbrnitX6Q5QSPqIoezRs9t1Tq/gkQuWuWO8NuEvFh+NaW+Lyoh2PHRiJHBXvsFlvzsiAgmmcGo7A5RNBajZkMKKpjBAnD/fjs2hwOpruYuHduP2mc5T6HJZn75nS6VRL9iUuLHm9LnyeL5El5twgiaiczSfvgOT/FP6olFcjrTucc8BcG1knoNZITu1VyNb8a2+iq060u21DJAPsPg45FXtXgkTXND9wY8BQM6LFUWuNDaVkIIuwla37/lBLjmY6dQx7wKqrkYOnIjWFjvLwKaRbYLD+nRiw1nolcsncyKRUJafAiEDDzZCtd9QArTzGs4cULwt71g
 h4yr4XAl
 TLMQ044uUEQuutY8sO8+WbV+6ARd45s/EmmbvePw+axxaULTiBEllh+ql7NG1enIisQHx3RnJEoZzcxXvvCyZ1aFSPXe8V9xek68QClFX2Z2mZR3iiNXfMo27AQfB8FvGYVq5/Fpqa1Gb1CHy/a3x2S/vFHKgWVVgfutcoUBAovS0yDnvGFdIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Brendan Jackman <brendan.jackman@linux.dev>

Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address

Signed-off-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Brendan Jackman <brendan.jackman@linux.dev>
---
I am leaving Google. Luckily I've mostly de-Googled most of my Linux
workflow already, thank you Migadu <3
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index ca6dc25758026..7324e1af59c2f 100644
--- a/.mailmap
+++ b/.mailmap
@@ -170,6 +170,7 @@ Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
 Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
+Brendan Jackman <brendan.jackman@linux.dev> <jackmanb@google.com>
 Brian Avery <b.avery@hp.com>
 Brian Cain <bcain@kernel.org> <brian.cain@oss.qualcomm.com>
 Brian Cain <bcain@kernel.org> <bcain@quicinc.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index a22b942616cb8..2657cbf6df903 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17162,7 +17162,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
-R:	Brendan Jackman <jackmanb@google.com>
+R:	Brendan Jackman <brendan.jackman@linux.dev>
 R:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Zi Yan <ziy@nvidia.com>
 L:	linux-mm@kvack.org

---
base-commit: c73b725a57f276a3702ca213bde78fca029bc619
change-id: 20260729-email-change-8924aa90b1f4

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


