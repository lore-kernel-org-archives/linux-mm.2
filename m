Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC8560A260E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C2pw7k4p
Received: by kanga.kvack.org (Postfix)
	id 72E516B0605; Wed, 18 Nov 2026 18:05:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF926B0625; Wed, 18 Nov 2026 18:05:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6CB6B062A; Wed, 18 Nov 2026 18:05:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3015A6B0605
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:05:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2DA6808BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:05:42 +0000 (UTC)
X-FDA: 85449773724.28.0E8BA28
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id E2D4840003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:05:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C2pw7k4p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043141;
	b=2rfulnxLW6H7S3+PrKiiB1nn/HSurEYId55M67oC+rQXFKPEPcmRKvRNZGNV8QkHw02rLu
	GZYzoDzkgab3T43hSajnc2F0TSGaaSsrYunIpTSWBrTzIp3NEnr/Fq+G2zPxo8QO9tu1sB
	O3+zFRT4VS2GzIbZxq8rH1LJDgvC2v4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oDhtyDpb3tGZC7Jtx2M4+QH25JCcfsus/aSGkCqzCNo=;
	b=Ye8d1DVTHgE6HDhHlrPY/ubDUcYOYZ7BjgnEJFKlZACnauZbvtFmkOqro+HGxqjbFn4s1W
	6+Gg94hw5OGkxZ6C/asZm4/N7yhVJZiUa5cG78xM7hsrbNDGOR98Od2+UjyvmRRn9tNOaG
	YSBhdW9pp6d0ILUD1+aT96VyVpR5MvE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C2pw7k4p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-71af0656bedso1052398eaf.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795043140; x=1795647940; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oDhtyDpb3tGZC7Jtx2M4+QH25JCcfsus/aSGkCqzCNo=;
        b=C2pw7k4pG11ac0blB9pYEiURneANShw1P6ETFoZYEu+oj9i6U97ydr+aW5Dcw8+RWI
         O+gMJxBp8tI0QmSFYAWewg61iFfsrvPS+vuJCTiYG+rbeRl0iT8C5C7DB7wzwNcU/YbT
         mygRh5lFR6UdzMGw4Nbx6UzzxRTfk5dAg6Ev5GT6ZO2eqrSSmqgiV5Kq9aNgPKsqRvHs
         +v476uN5dfsMdiGXPVrlwwEUNCcyu5mEUSgpwhXscA8SLuj6k0D7DkAsT8hD1rKwF36J
         s8HWd6o7EHWciUW2dSuQW5IC9ysmhT5y790RLOshjttRewTU+A3XgfXxiXF4dkcKYn0w
         PR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795043140; x=1795647940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oDhtyDpb3tGZC7Jtx2M4+QH25JCcfsus/aSGkCqzCNo=;
        b=Is6GtxMyQLJ9/IMHbDyC83IlnVtoCASM9dQSEy/KJzfiJ2nW3ZFsDsmuCmVr/NPDSg
         kjDe9ivefiRqlyd3QndR5L/vLqCZexQ2ySdf+7DScOn2y8qE6jnsJxdKnEYpvZ00PqbV
         9dVY0+5LXqDNKqDbpV8p/DSugClXTnqzfpkLtop6omj6lETuUq4Hr0/i+ATXE8/v3hZ+
         WR8IAXCv2nyuOhqVpAQS8PEqhqaGXXaCHoofm10GWBeENnHB9yyPgVHc2LymmPKybNbY
         ku4FPTbt2mW9kTwJn6WZjV5QjkgPywwaj7q3Lhcy/Foe4RKbXFKmy8S3AhHcmjOaTcnQ
         ABAA==
X-Forwarded-Encrypted: i=1; AL+hErHJ4g678LfaZP/nNIagbsEe+D9Mh5SETTCWtNbggGXvqG/iJWn3xYYHWEwIW5uwXxt45NwXBySbiQ==@kvack.org
X-Gm-Message-State: APuU4Z+4oFc3JDQppKvbQVlrwLQ6/yOiQJ+LEAzTd0NrtiFn1JR93oJz
	tzPPVucg65kwfMaRnS0kkWABLsR3Gf/48waPWGDeuthvfuvTN4AhF5jk
X-Gm-Gg: AYBFou1WlWWfn5kDNLOew+x2IPf8mCUo9NPoH0ajJb2e1zaq/M1ndQKTwJ8kQmD5P9r
	WieaEc9XVLriURQ2zFr9ESMzWQMmZQML55IpGE1f7ngmZ+IYszeNUPxsOpiZnmfcYc7e8BBAmIE
	MK7naHIWSdVeeCoXmwu52JOy9vvHYRykySifo/hLpwt9WzVRW7ECJA5b1LLp8ELMoVe+NvJ9DDC
	Wv7sNjqAMwJ4h/xzI6zbZ4gM+Q2mURwTXNj4YqusrK9PUJcYnpdDQ/Qtyw7WV6HbP6wppYqr16C
	ZSYa43TEPh1ny79b1YbhfbdCkNsWaifkd5yZZMIrMaI7TSg6VswQkqC7z0FJhOwVjn1KK4HP1F+
	g18RR21wOWxJWCdexByUTiC73IM/NU9rUCdDQkRYbcQ6YIhlNLR7TL2Qi0RfOaNlFYp//1CELw8
	U9jKBepAzNEXgUfCCHJVgRwpxEn/78KPdYRxttM98l8bmy1qFQU/zTzIsvY4juDgvsvzQfp6TQB
	m+zQHRHHaGn4FMS46xjCG7S8jItUnKurlVG75JdjkzWnSWINxjZT+t9pe2TxCpZWkDbi/bKK3Xz
	wvuK202DHm3mxB34F/0HZyhaeA9kHUbWReDSCNBI17PiPdRYAZIh7odMprYP
X-Received: by 2002:a05:6820:81e:b0:716:bbb5:fec with SMTP id 006d021491bc7-71b1882c9edmr3135927eaf.83.1795043139882;
        Wed, 18 Nov 2026 15:05:39 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4b73f876f2bsm3601930fac.2.2026.11.18.15.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 15:05:39 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3 0/2] mm/page_alloc: get_page_from_freelist cleanups
Date: Wed, 18 Nov 2026 15:05:33 -0800
Message-ID: <20261118230539.3789231-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: E2D4840003
X-Stat-Signature: 6duck5w88p7mxqhraqptgkrp4q911e8m
X-HE-Tag: 1795043140-962923
X-HE-Meta: U2FsdGVkX1/yMFLoe+vklswJdLeg9d18QJtoG5PM8snjg37c88+4aKi+t46ktM6tYF99I/e7+rCSVv+GYeGUyDJFgYOZGZYvjJI/QvDfpiKe89H6FuY4h9ylor95eeeEuRaBoSdebVbaM/g+HWnWHy5IuSVFzbnB4ATPQONcvtA30R6ihA33+QWhGDO2uTBf0psvz1XoopigJaja/vvSmC1b6wi77SQ6g6wvKc2t4D56vM1mit+l/CyHW8+y2rF2hDJxEdEUE5CZix75pSQGxrj9LZtaDd/Sa1bv1sMWZdl78N3SneNxc/EgdNFOIJf6Nq3eFSSN9wl6sPxO+RnzOTl4pkvkvgiur67pYf7PXwqOFIEMLAohemE0OQtE6w/9viVhH6A9kfBQLJKDu6vWddg2/95zGivp3FlKGNj9aJoq34Lr0tx/7dO+VGelhb2c3OfPd2z83UfAvzV89GdKyrFHGePy0SaLrzRKNDfc2agEZ5vfmmfPOsBHdUae78uChh/McfG1jXOluOMuQj85YowPccsvVeslgqxNm6UdYgh/Z0efvNdJWKJ3arZYk7YbMolKHZbmzx2IvoqNtBw7Kzx9EF+6Ep+iL3DUOPu842KitvN6OWlg3RTeccssSdU3rcd4L3/561szuQCOZFb4ezCLUKWUcjzJ5Eu8mqO6cpyBzjs7odBD27neIRv2SZOBYg/3ULjDz1XJP+LpPERxlYBmQFP3gHriEHM4EUN5Si/8h0AP5Ixwb53Cn+DqHg1W5YbgThFpZ+9SgFvmGQo2iGb4UrFW/Pz0TymsHYVEI7hr9w03sTBRCNgNsVGv6C5apobgrMqZp/xMlyS6n9W89vNf3s8oSPy0u8gig2+hghW2LzbWDS3QQ8dfENOOIHAKVYtTvZHCHon2gJICzauuKT4nhkQCcLpUrGnNFqYfmfRkWMSKIXl9X384eNM65NUU/VhKMCIkLF4XYo+dWUy
 aXCTUaa1
 O4PBNUI3IpyCuNIvuckU0hyXqgjczXvRxGbPeZr2pd9n++yeioqDm1v0DG5BgirWiBl2qFjW8CCTnYJPoZjZghcTvugWIJA8k/3atSRpC+aZXD7FwAD/oV7SsCMBXRnG5Qk9IfNSxn0wtJVmEz+TRWqL5yZN4gG/G8IKd3Uha/qA2D/uRNqE1w7b7hbIypN/3PAlVsTDv9O1z8Vne15dThpt48FV4ulcumIQIK9gQHJeRoDtYkluov20XwG8ZZewCFv7X81omnwWebD6p/Nuglu4S8Ooe145Jerk2Onfyr7+9DLSQT2TRAjMQp7BNDcm4OcuME+Ff7typRi3FkAcNaheiuoFVonsQerO5A8fnlN4uRkxTenT5l9lXDBQolstKmJGWiu1QA5s6Zhrc53DXm+AEn9dK3Ta0t0TRgcn8DzutxqO07gG8ShVBMJJJyNwMsFCqwTmi4BzFfXWwgQE23s17ySYZZYWsT3o+dphmlNijW5LOqzqmIGwYPXl9DWcSKBeJ+Acit6B/O0orRCKGUAFDyUrk201vAW+cwgs1Ly2YGcrfT7LZ3S5aC3NQupHcNmM9gT4N/BrRXANfmdSeodQ4Cy5AaEPjVv2WRUU+2PCPps5wDma8UbTu+3Im+FInSRJLJi4dnJPIlmKsylj1bBitjb5EbvjNnA35m1Bkwl5w105ULZllqyUEN//yVWz7EQd8e2v2BgtAq5ycBaPkIDJ1Pfr7uirm8JBU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v2 --> v3:
==========
- Drop 1/3, since Kiryl is working on some in-flight changes that use
  the gfp mask. Thank you Dev Jain for pointing this out.
- Mark should_skip_kswapd_zone as inline, as suggested by Dev Jain.
- Collect signatures.

2 cleanups for vmscan and page_alloc code. The primary goal is to make
get_page_from_freelist a bit easier to read, especially after the new
kswapd zone skip conditions [1].

Based on the latest page_alloc/for-next branch as of 11/18/2026.
Notably, there is a dependency on the aforementioned kswapd zone skip,
677dfdfad244a "mm/page_alloc: only skip kswapd nodes below their kswapd
watermark".

No functional changes intended.

[1] https://lore.kernel.org/all/CAN+CAwNsqWpPoag_XE6bxbrfi6m71xw1NS_wc3h_ShZjNspSjg@mail.gmail.com/

Joshua Hahn (2):
  mm/page_alloc: move the kswapd node skip check into a helper
  mm/vmscan: consolidate promo vs. high watermark checks

 mm/internal.h   |  1 +
 mm/page_alloc.c | 47 ++++++++++++++++++++++++++++-------------------
 mm/vmscan.c     | 22 +++++++++++++---------
 3 files changed, 42 insertions(+), 28 deletions(-)

base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
-- 
2.53.1-Meta


