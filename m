Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3913606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=VWbVcrow
Received: by kanga.kvack.org (Postfix)
	id A99706B07B3; Wed, 21 Oct 2026 16:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68E56B07B4; Wed, 21 Oct 2026 16:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930986B07B5; Wed, 21 Oct 2026 16:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE4A6B07B3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:57:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF8B91206B5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:57:09 +0000 (UTC)
X-FDA: 85347843378.23.C013D7D
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D53D10000D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:57:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VWbVcrow;
	spf=pass (imf05.hostedemail.com: domain of 3IifZagsKCDMhjhTTcSgPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--suseendranb.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3IifZagsKCDMhjhTTcSgPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792616228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TjGoXIwxwvYJCfSB4uUwJbeswXlbVh5GTXRCoqO+ToQ=;
	b=gFtoevp1jFKNIxpFBU+0XMmzL4KHEhB4J+9O+2cm5KR+8Eea57wNCyWI/aW0KzMEuRhRgK
	NJnWJsv5mobqqt2rbGh7Hw+lIBFL4XIeqXjmJfBrH+w/3UA82RkSFqlQysx7pIukuRQ9oS
	XbGMHAx8FZke6LV8zxLj4WObf3jYPMg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VWbVcrow;
	spf=pass (imf05.hostedemail.com: domain of 3IifZagsKCDMhjhTTcSgPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--suseendranb.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3IifZagsKCDMhjhTTcSgPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792616228;
	b=qH+ZOgcC6jnlPpr/UZ3YQ5a6dx3M7EmRDyEY+0iYrzY23Npjepax16HrpN2JqPVh6IyBJb
	wZMur3Bz9juBY9UDIwOih9fxargeYpdWdGMnUKMdcNenG8FqxGwVAK18oRTcASv+Wnxpa7
	+kQIebbMKyBka/BqC7W8E8PmV2ns3qk=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e60770381cso11401915ad.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616227; x=1793221027; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TjGoXIwxwvYJCfSB4uUwJbeswXlbVh5GTXRCoqO+ToQ=;
        b=VWbVcrowvCDwFHv8NalVj9uZJaryhAO5H6M7Km7e0MaQ5KBob74kprtBeeDiq/ZyCf
         Lz3AY7cc7dCbjIO58QgeFTnnB/xNqAIRMQQsHdtsaSmciVBheM3pInnzzI3xo0AoGrK4
         ISbYPS2bCW6mbwCuQ7NM3eAlZaDI3lKs57I3c3lpVePr2Rw/fsf1JjCUOHqgXP6H1YfW
         zzFnGJHWEzoZFLc0IKiHf0WDcu5Je2TGSgI+bW3n+RTF/wfgSY8eC82q2xf8dGnrUU22
         n/3udO8zDR4ejcgxDLa7WLBu9CF8eoVPNXWuBQc1oqAYIR08hgeMoXvTGIPdn6P5vIKk
         7tIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616227; x=1793221027;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjGoXIwxwvYJCfSB4uUwJbeswXlbVh5GTXRCoqO+ToQ=;
        b=sQnrfWc77BE80B9UcVoU+l5w+3tRYp8xwQ2g8qaTc5Uyw4S0rKdtJbxXDVLEhdwIFo
         WS4mwdftcZjnH0UFPegl5KEkuSElYrjcyysqg/nh39tg9/UfyiLxifH4MGfe4YqNkAip
         jiQ6NbwSCIQGwjWov8M4IJvv5hO/jM6zlG6pYC0FK6q4xR9n/m7poTyHrOM25VivRRq1
         Pf8/N9m/ucblES6Xdemuemec/ktEJ4RiHYECnLNanum6rmkturScpXkrOWS25oJKtBAW
         j/V0yzGV+yYX8CrjCAY11LOkiQcK4e86W1KI78Y7aeMKxG7wua0S32aHQiTRw4W42Rgk
         ZwqA==
X-Forwarded-Encrypted: i=1; AKwUvBxTBnKi2TVd2dWhdkqjIU5ETTBJH7s83COkD9/L59C/Po0iN3jb4Cz1yn+YDIouvcXaHjq6Eh41AA==@kvack.org
X-Gm-Message-State: AFq9FYLoIaA00tKYxHPFE5f8tZQRQgvTWMq8mvjtZPF0DuufnLvWRr2q
	qmhQromfj1ra7/OCyjJ5atVfGB2R4ISA+opJgoR8fJx8xzvOd1ItX0eNKGRqQOxUhWPLFEhZl8+
	Vpy4x9z5mpCcZR6bpS5nLgtQIZg==
X-Received: from plot22.prod.google.com ([2002:a17:902:8c96:b0:2e9:8ef0:cf73])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:26c8:b0:2e6:7c6:8d40 with SMTP id d9443c01a7336-2ea43c0b534mr25135175ad.27.1792616226856;
 Wed, 21 Oct 2026 13:57:06 -0700 (PDT)
Date: Wed, 21 Oct 2026 20:56:24 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205626.3286270-1-suseendranb@google.com>
Subject: [PATCH 0/2] mm/zswap: distinguish incompressible pages from
 compressor failures
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suseendran Bhaskaran <suseendranb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D53D10000D
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: hihhqhmwmiprjzo5bmn1u3othw8es5d3
X-HE-Tag: 1792616228-666926
X-HE-Meta: U2FsdGVkX1+8/dr5ZMFKjri7ojSMh7YaIQq6mzDxSq5U0bYRZNO4BmTYlZH131ROqTCJcPMoySoJvD5fdadlYBUObE22f/oQmbPXHBSryev+yl1XMic45fnKyRIOszujtYs1eQ9ysVx/tiRSXu/cMuggWRQEMWyic/0jz9BNs+hqXGA6Dw/pU2Hww4Nrw9XHN+FC3YFFbkmsPncVAz6s4fFW8v0GcqEPL36OfNKOvUSzu50YJPsMB1gmLbonnm7S32nUUJCX4v0xXE6e0ugDhkjqqJfEpz7PGThxY98oS6OZPWlGZIUePxTLxmwvlrVI5De6a/5Gha6O3xS0SnrFDLCWfyiMCjg4Hx7MrSl/xq2P+x+vca7+8QYsUfHXicJpUF04jUvoeDanXw1Z1BFJ2HGIQGxzYe7lDySnR359hl9ByL66FLxPDfDP2pNXITtNvFt0mh1y1s3FFy9WRBry56J1fRq7kuAB8i79XZZb8D/MYq5XgiHq2qZOamLnghnYqhXF1vlFugVoxFG0Nooe41EbNAhQuWwW++6Ra2UgPHuJUNBhRcNqf2JLv9EOCFamcuD3CuzvcarX6HRfVv75JJwauKWGF6lmccml7wEhMHmtQPm58htmKOOikrXfvobAdNETlrfYUJ5F3yA+jNrkw5Iv1ClMsUGIGDbWGUHlvpGZMZxWvYsH5F2EGE7AWKJZVf0HuqWMwZ6aiC2PGIz7PIwPGRegeUhqCAvfCK1IaO/B5hm/wnLjuMKpEyhcsuHvyR+x5etvuSIHQOvqZd0xshYfGCQHKrSKj4bnP8Glqi503pp7dZuXeAXZxKT5hQK8tQ14PVwRMof2caLH9A+Tok6KF7LCGreaKUBEapXf7+MJpHFMzN75xzsqQ8S3RuJjEbQJgZUGZWpPbkxER7GgZLw1oNprQ+DQiXZtmpl+HrULjVlIH0yKHfr3vqOTS9q/b/JTrAi/Xo/FP0dEeZ9
 rzG6xkpH
 P6tn/BIP9DiDMngcion3ZmhVyTGEPS1vrr3UpF+lQ6HXoxgYCbT3jEuPBGJnfAW8ujpXJCv8ctlridWAWQRtUkPMG++CTXmrmv+2NdK4htZdWBi7mYsDAEORSP1cG5yQMvjbcExFH3Ie/WtEry/xDqY64VluKMcaxfzomHpRzicq8LUfuAO7iz2WhPsfWVClp06xLvfOHdKHZy38FsOaNG+6RQRPUH8GJQw8OHAvZzzmAyui1Xr5CpG4QqqscugMkHxAeFclfZIzON/vChk16DZJL4r9qn64KU8Vgu0pnhSjp1/N6r7cZElmvJjyRtbMf0L0cFxjixwuHvZGC5NxauNbNLEMVWpDp/XqkQqQSWFQq3+UvpVWALBVvZ6GK9M8d8funKPyyQr5FozhDa+Noe86uexn5oVotdG82lQrcjN8BkTgiPCe4m6K+iu7Tf/CY5BjA1zT587u0YlPyRpQB7KiEwUB7R8pfLvm01KRsQS1DBdrIUoCq8aYV8H4AAO/g3fqUW+4RIYoj8HiCDrJd4/u78ubnLEMmRcdA3mgbevwZnW6rIBZCoVjVg/a4QvLu/yVeOczB1eF2DAqgJr+J82ewz6ZJl3GTqt5da6aYOtPOSwlYNjArkCvgXLNZZZjb3cUe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
as-is") and commit 0b1bf60c324a ("mm/zswap: reduce the size of the
compression buffer to a single page") updated zswap to pass a
single-page (PAGE_SIZE) destination buffer to crypto_acomp_compress()
(so incompressible pages typically overflow the PAGE_SIZE buffer due to
compressor metadata overhead). Because the single-buffer software
compressors return -EINVAL on destination buffer overflow and
zswap_compress() checks 'if (comp_ret || !dlen || dlen >= PAGE_SIZE)',
destination buffer overflow (incompressible page) is conflated with
unexpected compressor failures, causing two user-visible bugs:

1. Broken debugfs telemetry when writeback is disabled
   (memory.zswap.writeback = 0):
   Single-buffer software compressors (zstd_compress_one(), lz4, lz4hc,
   lzo, and lzo-rle) return -EINVAL on destination buffer overflow
   (whereas the multi-segment streaming path in zstd_compress(),
   deflate, and 842 return -ENOSPC). Furthermore, in zswap_compress(),
   'comp_ret = comp_ret ? comp_ret : -EINVAL' forces comp_ret to -EINVAL
   even when comp_ret == 0 and dlen == PAGE_SIZE. As a result,
   incompressible pages are misaccounted in
   /sys/kernel/debug/zswap/reject_compress_fail instead of
   reject_compress_poor, leaving reject_compress_poor at 0 and causing
   false-positive compressor failure alerts in monitoring.

2. Silent masking of real compressor failures when writeback is enabled
   (memory.zswap.writeback = 1):
   Because zswap_compress() checks 'if (comp_ret || !dlen || dlen >=
   PAGE_SIZE)' and unconditionally clears comp_ret = 0 to store the raw
   page in zsmalloc, genuine compressor errors (such as -ENOMEM,
   -EINVAL from an invalid context, or hardware accelerator errors) are
   silently masked as incompressible pages. Users see 0
   reject_compress_fail events, and pages that encounter an unexpected
   compressor error are miscounted under stored_incompressible_pages.

Patch 1 updates zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to
return -ENOSPC on destination buffer overflow, matching the streaming
path in zstd_compress(), deflate, and 842.

Patch 2 updates zswap_compress() to treat only comp_ret == -ENOSPC or
(!comp_ret && dlen >= PAGE_SIZE) as an incompressible page (storing it
uncompressed in zswap when writeback is enabled to preserve LRU order,
or rejecting it with comp_ret = -ENOSPC when writeback is disabled so
zswap_reject_compress_poor is incremented), while jumping to unlock on
unexpected compressor errors (comp_ret || !dlen) so
zswap_reject_compress_fail is properly incremented.

Suseendran Bhaskaran (2):
  crypto: return -ENOSPC on compression destination overflow
  mm/zswap: classify compression dst overflow as poor compression

 crypto/lz4.c     | 2 +-
 crypto/lz4hc.c   | 2 +-
 crypto/lzo-rle.c | 2 +-
 crypto/lzo.c     | 2 +-
 crypto/zstd.c    | 5 ++++-
 mm/zswap.c       | 7 +++++--
 6 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.56.0.218.g1ec904b173-goog


