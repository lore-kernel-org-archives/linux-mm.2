Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4037060A2625
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OFZwaliZ
Received: by kanga.kvack.org (Postfix)
	id 3DF226B06A2; Thu, 19 Nov 2026 12:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6FE6B06C4; Thu, 19 Nov 2026 12:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3EE6B06C5; Thu, 19 Nov 2026 12:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 050046B06A2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:05:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 810DDA8A62
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:05:23 +0000 (UTC)
X-FDA: 85452494526.18.2E90E2B
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5E7FC0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:05:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OFZwaliZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3Tyz_agcKCAQmvskivwksskpi.gsqpmry1-qqozego.svk@flex--irogers.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3Tyz_agcKCAQmvskivwksskpi.gsqpmry1-qqozego.svk@flex--irogers.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795107921;
	b=XnS8H5U0R6bUrBVJl2NmyqSsj9ejniVQbuedtwAN0up6b4Bgfe2K9+6Dp0j5BSFgMSS9HA
	dPfAzu+v4OosFIYz0dTZS6iTQpsODJR2dIA5EzgHo33LfuR0pmysoZgU+LZRcxuJrkCWWs
	d8NF9dUhEigyRroNYC8/xmDYvJkoUIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lxyKrcrROgSrDO2SJS728Cqlccn0RMILLNUr3hcKYMg=;
	b=73A+vrzp3XPZszR+o/uCO0aCuDzABFCJ9qXQHoYrZpO8oH2F+z9G3TcpouBboUbyQ8PHTN
	HG08lMIBlEuEwbIsvk52OxkiBTU1ABGobkbnCNKLCvg6LDDnmFtjgYqD+MUMwIdQ0SfawL
	0HuNm7Z9S3EfHCDWIkQSBcab69zK+PM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OFZwaliZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3Tyz_agcKCAQmvskivwksskpi.gsqpmry1-qqozego.svk@flex--irogers.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3Tyz_agcKCAQmvskivwksskpi.gsqpmry1-qqozego.svk@flex--irogers.bounces.google.com
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3837afac185so4822120eec.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795107920; x=1795712720; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lxyKrcrROgSrDO2SJS728Cqlccn0RMILLNUr3hcKYMg=;
        b=OFZwaliZIEd9jlZUgPva+ermgmMK80sde4fUATebywBZfNlFj+jcYET5BZGbsLxc+W
         c2gza8UakUDwr56ZUi8pvADd6VP0+cWTunTGCZSYNlBF9b21bW/mFf2MUO+VCsjgdMyA
         VDrRC330JoUS8rYbZxKRrYLb8gvVuxQmag6BvvA/3Dh77fBlFQmTKmBOI/w65GEgkxpo
         fAMm3MP0+cS2j5Q+m6JwPf+eck9lUg+Z7lSNLiClmUTiRxVGwdbvYxj2FcQ3vs01mho3
         qI/sAHhPE142lCAG6tICtPS1E1APuPrtzdQLm6gKPNqTGxWKpvnykMBQIjV2a8j61dnj
         8PPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107920; x=1795712720;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lxyKrcrROgSrDO2SJS728Cqlccn0RMILLNUr3hcKYMg=;
        b=wap65KuIe2panOGxvDyZPNfbFFbicRcTeNpo+7fNPhu3iOZCEsdzb+bkd2kbmHzodB
         mlMM8WbOa0Y3wUTy/XQR98Zys5Vv7kInOzx00qOrNbmXKewdYUiaPQGmLegXq9OV7fEH
         PB8XbargAITmFnk6RXkxDLVx9+9KDhLZ94ispl3v7E1Py6kSLnpXkKUTZAfPalOvu8oS
         LMJiulWaZlIgJuNp8M6vZJd72Xfj5cf05lq6Ks5KBA5X0bWLhoyiZGhEQbKS3fivDeJq
         RoIbhnitFBlMPWPidXOGC2eQ700bdxzoDmOYJc9p7BC2CuTB2jUwWitRcJyOMdgGKsOl
         SIxQ==
X-Forwarded-Encrypted: i=1; AL+hErG5YLHgtMoIih7Mo9fmi1Od4ZohVwwNoXohnvykup4tvMjbVd6jl7w8+cpfI51yi+V7ETK0TqAHJA==@kvack.org
X-Gm-Message-State: APuU4Z80xCg4SS01pS2bpmHgIvt0TkDg3r6LqWOpFV/oQF1BwSMzUgox
	d7VPLlbiFBPRhsv9EAcrmw2HjiTA6INChSr3cTUOrLdEKXE8NRCLgCvRBTKZrd2a9UPTkOg6WVE
	hsxZEHd8tYg==
X-Received: from dybgp2.prod.google.com ([2002:a05:7301:2102:b0:384:7a9f:7f2])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:d211:b0:384:6a72:4e91
 with SMTP id 5a478bee46e88-3846a724fddmr2026727eec.31.1795107919998; Thu, 19
 Nov 2026 09:05:19 -0800 (PST)
Date: Thu, 19 Nov 2026 09:05:17 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170517.1515872-1-irogers@google.com>
Subject: [PATCH] mm/backing-dev: pass "%s" format string to device_create() in bdi_register_va()
From: Ian Rogers <irogers@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jkdifz9kmirbckz9yqrpk61r8xongzuj
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C5E7FC0004
X-HE-Tag: 1795107921-27362
X-HE-Meta: U2FsdGVkX18c1CNb+D5xgVnlKhq+eJMWLnaApLC1ofK/mYZUL8RqInLOTGubaWNq+lu8EkCAousOAr12SO3AQQVY2SrNeQT/o28HKDod66WOJAWVM8JQ2/8PM9g3PtC3dChj2ESZxB6sZXX3TC2zbAn6Af7joak+tg5MvMvayNGDF8rENpILfFCGHBuuNr7gBUOLhA8/0EQsM0n7h+xSTyH5A+basu8UhE739+r0W2Gz+DztmKNdWE9IYanomtbEWRRKPB4qLO0Jj6OjK8py7URB5LRxe5QUihLXxXkegZYvbLFcEmROHkFdNq5SeFEOluzsM0NZp+8qYtGRU5YWE0t3L/jEF5C681Fw1aby9ygodpgcmz+61uUgzsahb4K2IXDv3KhQO8RxafL3mf17lwWOpWjTRFLiZj0ir/UG/FA+xP5qSFxAsz79qck7k3WV8Oy1M64W1q/eqGFuU+A1/XhjWWSIicoSi/hnfINyJzpmYJSdDlq3HSaOlpPxN4nBDjSJWgJ8pB/hvcAcjtK7gpBV1SYGEETYGXNsjRUS4KMHs3HqeindB8qz8KDtuKYkhTDObnbmVaHsm7yALxzVo64k9XYwX5jNXBnkXTzCGnoAD6NCv0pcEg3YRpGP6T7nT87Hs6Tn7zAcak6EwHuGsWtt2DquzfT2h+d1ZXQVqhU6Jn8qCY/EX6owWdZEEvGNl6uGzdLvkK16/x+VDXqX5ZOfgMPxu1zM5HdOuoIel2nq2UeOffHZ8p1TAka/fwQgANm/YXW/I2iy6JEvLbiuPIxJdh+YWKDE0lDxwL4/5S9qr5Xsb4vQZ1zzLTkPW5T0NrtHQAQPfojcKiCt+mdri9MWvZSWAd/7zkmdFieQfwS0xHxgsr0tbBt7DebkUvOYx+RZtdND9B0o4TbEvSMUCZxv6e/CRVjE9CQ06Wj8Q5EEbcpRXC4QkHEixaW87LBpFJ6OAybZtjZ5RxykFgY
 itiRRvn8
 EGqruglJ/g1izHnuEP7jv2aTZqXb32O8NcfYHXM7FFxT6cFBSe50fGf/mFQjxPXZcaHnzODu7j9TjX7vmoNuIyQ7zJ3NlFqltzibMxR4GpK+JK65oN577JwXVlK7jbjdmYpQ0nS9N2qDAkfa+bw/1uyuIjPKP0J3iNnpLl1owcpHG9an42CjDuzV1gtrMLYbLGUiBSJ2N5VphhGSPnLSURjLUp0ieS0sEr9DuctvE7/AHzbl1QpkdeBenxOJqx1HW13DqPEvbX7NMFZoc7UxtXkmmo6WdUrcYDUxlNpRcgPuGLLs0LWhI068Qn21cPqIlh2Gw541gEV3+MWGirPbt4lA0Jrcn++VpHIlhpujCzue06UxDOHMv58G68zANdLUyLFR+XchPFRMjfMOvgQWr92roQbo4Y/uGKDfBUdcDtdBgJeNFmru//YO3jFpO/G0BFagGWy2TiBqV8g9xUHo5VaOLlBRwfP7p0ILVPJomHGysfMZXJLmrXJr0G/EIYbFu5lH/jEStGJyCsUnZrIerQxBrwvTSAzMw6KkbQ+5pzGCHV0OQ+J2vTGWAFWHM9y7zDGIa04hDL/cuMGSCmQ6rwQ2mocrgJ9sm4YJ1zZQfXGwll/Bhv6OPLrNJ81aP1zwIlR9orZqOmzrrqVKS7sDsCu1NW94TKTWQaOL3kh1xByJR3ONetqElTKNSfhaEKOj/Wq/0+80i59WVEv4OEoNZ9p9KgwsKmmabehugFYaleDuRL4MN7SPVYbHvsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

bdi_register_va() formats (fmt, args) into bdi->dev_name via vsnprintf()
and then passes bdi->dev_name directly as the format string argument to
device_create(), causing vsnprintf() to run a second time on the already
formatted device name with no variadic arguments. If a caller formats an
identifier containing '%', device_create() interprets it as format
specifiers and reads arbitrary stack slots.

Pass "%s", bdi->dev_name to device_create().

Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
-Wformat-security enabled; fix and changelog drafted with an AI coding
assistant. Build-tested under LLVM=1 W=1 and -Wformat-security; not
runtime-tested with '%' in backing-device names.

Fixes: 6bd87eec23cb ("bdi: add a ->dev_name field to struct backing_dev_info")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 mm/backing-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fad1495d3b20..58373d494d92 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1097,7 +1097,8 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
 		return 0;
 
 	vsnprintf(bdi->dev_name, sizeof(bdi->dev_name), fmt, args);
-	dev = device_create(&bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
+	dev = device_create(&bdi_class, NULL, MKDEV(0, 0), bdi, "%s",
+			    bdi->dev_name);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
-- 
2.56.1.708.g77570a6a1d-goog


