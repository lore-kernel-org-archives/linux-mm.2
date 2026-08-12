Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F394C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D5D6B00D1; Wed, 12 Aug 2026 06:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0416B00D2; Wed, 12 Aug 2026 06:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E53E6B00D3; Wed, 12 Aug 2026 06:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E72C6B00D1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:40:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C736A217C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:40:19 +0000 (UTC)
X-FDA: 85092272958.16.B0F016A
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id C268BC0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:40:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XFy8IknC;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531217;
	b=en/2UoyFK5swkxkciLYfs8bdCWOPZ9bRaRKNB/wKiM3Fg9/u2S747W2I4Na2htqj+SsArY
	p8OnIElQinEwpfgWyR5RS+Jdv2aEpRl2i49es4Y7mXgPfJf/MEeaBm5tk4Q3R+vLCnfB/T
	TYpE8bwfPuF5S4m6bqY7n2P8ayy2BEM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XFy8IknC;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJ+Hxoz344ZJ6+13dkxOMiOcxZbShSOPZl6HyMgRs+M=;
	b=cZ81pkIujFvi2w0ArkOzJypTDOOMRGUzYlDL24tNtc5vKcyL8ocdRTJNzAK4cihizZ1SD8
	QJdL0M6JR1fg5j6LCyPKGQou8dmdVEPtd49STDoADSovw036bxXzDtdVmWZ29OY7gQzeJ/
	1/t0/pBQZnm54SREmYrU7Zjtzn7sCLs=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38101f85591so1919408a91.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786531217; x=1787136017; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qJ+Hxoz344ZJ6+13dkxOMiOcxZbShSOPZl6HyMgRs+M=;
        b=XFy8IknCnqnmvwbk+x0enp+MwxFQRHOwN2kM5um9KznORawYZiiPEFP2jnLljInlt4
         sQ6h3Aw29MYUti6tfN7PoB6ynjVZy1CKu4t2nhCcqE3cPpDlVaPZEYnoeLndku79R8Zm
         bPGkwl2mETC+I96xuhOlC103EiAHuMYjNqN1EkvvGSZK3bv+njL0h/+JzuhRSGsxrA2J
         Lh8sRhNcrkw8zNuKlPq1PRP63Guwt/I/CLKj7v6IjOPkM8YcEcRXspzG57li3Xy4BcLj
         jUu4Z59T6AE7a1cuB7qhhgyEGx42RibTxluob9niNK6qWoHczq1iNQKC16C3L0wnV16i
         D0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786531217; x=1787136017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qJ+Hxoz344ZJ6+13dkxOMiOcxZbShSOPZl6HyMgRs+M=;
        b=YYZmZT/t3LcE8RNr9yK7kr3676IkrM5RVb5Cj3hUN3AJyj1iz3TYECMqxoND0RlLAo
         f+Td0Z9szIg0CbxkcKyTVQhB5wVREh+LHAjzKfbSVlHmfq7lx10aWc61UU2KZJNH7KDD
         2rWodJ+kj8/MNaqrPiC3vogj0mxkmk6ZfvaeO9X9w2rZi+5Ac5cUh3b+U8TgDXJslMri
         yKndAwimXQuKmfYycG255lrovH5HdyAPiE/MJ+cXUwcu8amDQxvR5kxyAH3Rs/iWS/CZ
         Z4E2ifzmDqx9LPLkAfi4eltuWI+dyiMsudSVRskZBeRN24HqeDq0pgnGdTCpzrWBnHqV
         T0KQ==
X-Forwarded-Encrypted: i=1; AHgh+RoO+DsqgDpTebf3GJj0VeRabX10gwUbxBqPtfLbc46FMwwDFdt8XrXnbGnaOFkYlRvKJQECJZslHg==@kvack.org
X-Gm-Message-State: AOJu0YzNs8f7A368mp/coBQfWO3UT57mecryPTpdoSjiPcXbW3S7DkGm
	MISmIlDF+Ke7W5rVpZetAhIOUox24loY7M658Cym5Im4HO9Ij91KD7SM
X-Gm-Gg: AR+sD13DxGsDcXbafpQBs1DmDMeItv0VLBCWoFfu4+ohtcZBRR/KpsczqAzzcJ8Oecl
	b/L0BrG+/emcE1nJ/oZKBnutwAQIaeuj6/un4wpo+Bl5z6+KIRbEJDRGwsZ+WATN9JrOFSytnjU
	UhL5eUz4y/fq3mIUOn8J+cxKC1ljmRA6RySu+WDe0M2I4gu/hNj+BKnwW42/WBPTpiTgcp/Ocgg
	ccNceQ2HTfTs80ZKIlE5T0XipjjmVD/Gedd118N/IeQf8PdeOnIBzoFqkKi1T+oK6CpJcGaWsFT
	cB+W6GpM8mPXMM9U4Bo74QtQPjK3hojiXx0IfyEi9JV6wlMOhHJM3iRCx8NCS70uUUx2YQ9W7Gf
	px3oeLlZVaJDBi1WQWTy9hL0kHlgow2FyWzcZieQgay2/n0T7wwhHAUg1xenPr8zKjxkSZY1wiM
	XJ3g/zWt3fYYkEVuCGoNpotx5hAVcj8VaXduL/03GfflRYr4kaKVqAybTlTzXorSm/gGtP3RGAB
	j48h236sCPeC/frh1ZVitipsw==
X-Received: by 2002:a17:90b:5203:b0:38e:9784:dd47 with SMTP id 98e67ed59e1d1-392f3f08abdmr4412175a91.1.1786531216574;
        Wed, 12 Aug 2026 03:40:16 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf3d0b432sm9931990eec.8.2026.08.12.03.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:40:16 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2 3/3] docs/mm/damon/design: fix typo of max_nr_snapshots
Date: Wed, 12 Aug 2026 18:40:02 +0800
Message-ID: <20260812104002.15225-4-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812104002.15225-1-aethernet65535@gmail.com>
References: <20260812104002.15225-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C268BC0004
X-Stat-Signature: ak65j6kpwrgth86o74fh45rmkgjq3kgk
X-HE-Tag: 1786531217-307176
X-HE-Meta: U2FsdGVkX1+Dvx1tX9Fnc3q7FwiXMTRxFke8mjKq+6GK4BMMuMsjehAgJNxcpgZpTYItVt6H++kPmQ1fOFi6AdkrDimJ9WFZWn8rJnX/n1q8+/5soVLyjoW4TI96HB0Nc8OEvGsQ+98AKx0fD0ueUWvxBGoXVSfax2ysvsA4u8bt3cqfUFKnu8hlkAS/7+9byjhGbpI4AbR97NYJLHGCTt/8fjXU49lf32II7KvD4hi+3KLwUGeAus33E6KyY84YSnqfpNyBLFV7OSQj+8Pm+7XzbIKqD9r3Xk5kctBXghqfYAkuaKK/EGRy/3jaLh0nSP6leUwEFopNETbY+K1Fm9G3Zs2pOfcZFtWjWLqM3Tt/fosgqnNwGry8Mix3ciiy8qOsLduZ93+QRLEWNXdPjP1PIQAPpXVbHro/fPEi8RrRjeDYhIM4z6SujegJ6GpGhrA4Yaq0CaBxw434/366WQNkcMeU7NEnu0aJjxwFD1OawNqZRPqD6bUxl92LhmCpa9JR+yJhlCW2ShnUQqVLKrhYVhANwcoSnU71R981GsgKQ7pbbPAQVmf+bL+nJDAMREFw95VUwoWN4RZy1dxM3hxaNpTTa7+/apX8oiN8pBta+2HEMy5DRgQ9jSx0TU0dXrVSrIXxMZQ4w3B6WWMDWKOLlhrBEjmxJxAVaNecmCIHOZNniXx0Q8MI1eNl8HqGB53tJcXUx5NHQJzpAa01K27nqjb4fqmMSye3t6ifSmfT+nXACNuvXsDCMinW6csOjRyZH2cW8OAJnBLBK5jHsxuMe9D3zLLnCqPmH5A/taUlQsBiaZSKheo2eSFO1HmcUw32w8BNe2RgMwK+c0XvYrdW9lFbHFhk+AY7BED/SbawP3nczKE4a9yv5quX1h9KCxlLO96r1d+TjU27Qs31PSqq3dNubmyTxj7+H8DqW0qSuZxTH4Pp9quF3ApPBTAM+6kmD9vKBsZqPQrSs9z
 ChocF0qd
 vNAkEpKnfv5UvEceaNKBrAq352HXiKwuzG9Y0XuZ9TbAqnJ9E7412arqGjF2MA67wj60/dpuXDHoioeT87zeUjQlWdGaasJI5A14n06XO14KdGqUYqNca9TqH0fTkTzryyoYGxfz8m3TB43mXzV7jKVU9A+th6++uNDU9SqO+hzafuCOSgcIJAWpq+WBvZrFqdbcW7zp8s4SZaJCnYRe1yelYeYMGYOLgHspwHO+06gY8TYP+d/caVFcIvhSB2yZ5Ro9nfIm3J/SoGdS6sqyTBUWoJZljhnDhh5HKsZBYehZO/998gSlkJgvZws5BWz07B2HmwObk9bZ0a9ARu4uIr8LwHgQ11W0IfpnS8qnYRpyO/7g6nP95+SX9j/sNRW/8mOc/ENfNcgrUkejJiIJ+Ta+IetmqdXDZ0LCRxV5yslLhqMV000w6ZrsaPqrD5rR3yN7l6iZaiFM7tmN7BYkRvolkc2zCgwAS8f+TAACuA0IqG1tWTABuAinjAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fixes a typo (nr_snapshots -> max_nr_snapshots) and corrects a grammar
error.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 include/linux/damon.h             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index e7977f005ac0..d1dd9050ebf4 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -871,8 +871,8 @@ action is ``pageout`` while all pages of the region are unreclaimable, applying
 the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
-non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+non-zero and ``nr_snapshots`` equals or is greater than ``max_nr_snapshots``,
+the scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
diff --git a/include/linux/damon.h b/include/linux/damon.h
index cbdf5f77978e..4b0d2d2e4ea4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -549,7 +549,7 @@ struct damos_migrate_dests {
  *
  * After applying the &action to each region, &stat is updated.
  *
- * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots equals or is
  * greater than it, the scheme is deactivated.
  */
 struct damos {
-- 
2.55.0


