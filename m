Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D8BCDB471
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 12:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD71F6B0088; Wed, 24 Jun 2026 08:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86FF6B008A; Wed, 24 Jun 2026 08:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77D06B008C; Wed, 24 Jun 2026 08:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DCB66B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:53:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E9BD1C5A3F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:53:47 +0000 (UTC)
X-FDA: 84914798094.09.49459B5
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2475E80004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:53:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=q3v2976b;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.161.42 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782305625;
	b=1PqyDUJZ2kSONYeABqv2JBmrYoCM6GAenIFZsgCcFcksh8LVOfjfO3ElMr3Jw/MaNU92zm
	R5BAXKuCj/eBNICFfySJ0GtDhkFLyS2XEy3CcVKDe71R4jSXtEuKe59hwCUfXMlyKYoN5U
	dZcAqN15+mj/mInq5BJlVuJ+WtKEHag=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782305625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyUeAUZQ6VzVD4aBIbLL3a1KL2Cf5FHGMKxIglpvK8o=;
	b=JBbvCxZOmSLcVBR/XXVOdDsTZG1VVQydCvmlwIDqcWf34XpZbPAhWm07EacqEQYUSP/TQo
	dAO84rEaCqBY5hFGrUrIL6SU663/P3chh5Mw+hGNGj2imPSdowU8POgNP9kqqJKrXz9OQR
	F6nzaA9BOpOoi0BBMLZk5G5qsTs+MAA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=q3v2976b;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.161.42 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6a1009f6adeso730413eaf.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782305624; x=1782910424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyUeAUZQ6VzVD4aBIbLL3a1KL2Cf5FHGMKxIglpvK8o=;
        b=q3v2976biY9vtsGMh5mURhn9UTLZFkLNpJE/U0KaCcASKJ2egfhSMj2UKCqq0rSH1C
         uPDtDMwfBvF53uijxEmNSHnWw60hDADbLVP9bwfaTOxD222/b+mpzaWkd02B5MR1KXAX
         1RGXBUOgL0cJTEspE9ojA/SuPjAFxWHGAukj/G4e2t8VlnG/j8xgNLeadnw8D4Pfw7EI
         V/LeL9P6pyXH814mMZMYuYh1JJnh2/OsA6RwtFbWDAQ8vfaQk0xxQrbeTyaLsYWoVb7+
         4cdWAzmGfOzIFOIslbhOfWGxlvbYQPRCfXD5z857OhJvTjUUYgamIJoxmXdu719Yx9td
         kFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782305624; x=1782910424;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yyUeAUZQ6VzVD4aBIbLL3a1KL2Cf5FHGMKxIglpvK8o=;
        b=YJlCwQ9IbvgB5Qv/DQAkiUxrwCOqE3ZMsIDJzpjXqw6oFyuZ98A/RJY3VU9/CcEvO6
         kazmMiJMO3EhxBGTAdOM1T979ysw8eD0wJzU8F6hHoVwfj2Ba1nP/ndzk2viVl2Wzvid
         ofwHoSqHEJoROlRCwEu5UDIJ+tpgS/cjahSFTe6fBCzdS+tpZM0u/m34foxr+jy87nN9
         wHFC4Q1TDOfmSfHflTLzL3aFQhe/kyKC5KOcd6ao928+vHI/xWbGUBH3Ak96lAjWsVGa
         WgykkhG+Dn6HrSne8tH9/6yej7+KJUq57zByePtLneW65zbHSZmduglV+QdMc2GzwIof
         IHWA==
X-Forwarded-Encrypted: i=1; AFNElJ87taJ9UjHYAAENxH+ifqBjTuWf5V7+JbjZteNc7lvWuFiB1uQTilxgmLp0LsxuKlnkP7W+ZyvqrQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9nO7LAWq3uN2RO8EUveFBDXgEVJMHFC/ScpplUL1m46szFxF8
	NVS7ra458K1MJ38Hspp34ltx0LrRWCc2P3Ipq/9HBPG7a8pPK2CkGGEeAFWGH5ux5mA=
X-Gm-Gg: AfdE7clt8w0/orRwaK05vERI+lg5+DS5Ibohhamgl9WYSbOl00koM5e6wgpDbN/cR/N
	nBRGXPsCicN/LhLBmZhY2C+webLuDLhucjwxuhDOCAc/VyfV0WDvMPTDygM3EFd9pmtLosjE+Ux
	+nLveK5pyPwk6at3lkg1eOPOtcVHMfAxKlfLxLh0BkKjZuu2mxxlHquzXSdHNRUUVYaL68Ib12J
	W/yWxYBP2+AXGkE9dWIssbtZPt4OxPTe+nuiQC+cGm0irJmbwYtm4Ev2ToK3U8Sbb7qHqpnBlDe
	bDZl0GkBZmEamx1FeGZ1Fhh5mTrAmPcMeYJ+RxeRMbR5oaNrdBp3dhx8e3RHnsziYdeo4c3S5WG
	kt7MeQuhIRvcMhjBnUwws5tcIQNHCNZAQP8lB4kyO+Upi5wluS+rJMtOkrT9A9gJW6Zp0smXZLg
	jRU/gjihOQR/408TdsQoVhpRNiWjmI9RfLR9/I0u8jibO8tNirZB6E9gOCOm2Ncm2kgw==
X-Received: by 2002:a05:6820:2222:b0:69e:9c80:2fa0 with SMTP id 006d021491bc7-6a1230575c0mr1922407eaf.17.1782305624088;
        Wed, 24 Jun 2026 05:53:44 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9faf29asm9264161eaf.8.2026.06.24.05.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 05:53:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: nilay@linux.ibm.com, tom.leiming@gmail.com, bvanassche@acm.org, 
 tj@kernel.org, josef@toxicpanda.com, yukuai@fygo.io, 
 Yu Kuai <yukuai@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org, 
 youngjun.park@lge.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Baoquan He <baoquan.he@linux.dev>
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
Subject: Re: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg
 paths
Message-Id: <178230562124.29628.5186654393991521598.b4-ty@b4>
Date: Wed, 24 Jun 2026 06:53:41 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Stat-Signature: jx15k8ngewz6pquzosq9e7icrsp5oau5
X-Rspamd-Queue-Id: 2475E80004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782305624-120250
X-HE-Meta: U2FsdGVkX19e7Qs2wsge6HGxNDa3rtioInGuHRyffzeyUGdrYbovq+VJBTvp8DjYGXU9a+w+e/n/RdN+1SeQ5MGm6de5WTuFXV0v1SV4UxP1Ind9oIO85FCFVkIAP4Ge3Dp83EUTg1iHbG9xki2MNqNZvNJ0QRcorN1mwOLvSpD1c5LjDmuiZ43hiTA99WeYEP2CgdxoQSivloLz8vpbiXoPTUAgYzFMRn9vKOAvFwuR7RQ3AHgIPNd+8EDgPfUouk4IT7H/kFm98kG1x7Zr0D2F14+P4HkwFJyeteH03Auo4OT3GE1QNtSa23u2WG+LMF/NK+Zf4GdmG019Q6w9erHA+dieGYBdbPNV3jqcqCUBJA7LdQS1GLw3WUAoyPmTIxBWhbfcYszyy1pjGZ/nlZeeyCqf2rhW4bEeYZjMWndfmzajqbOPQ48GSgpTfCP0JyT4p1HbDbPIsIdu3E8x1GC85nytfgVxL5/1xRbgdLSPY0526UZeZSYTDrVvah09/rJtTgL/5lXKpELfldy+LtTMmu41NjnXvESq6Z81Lsiozc5okft4hRFdhGC8CIivmHAP/eZShTK1V8cvbWzLkL789Z+DYFFttZuo2Rv/HT1fk5k9zDMSpuX/qeS2XLhJFdCI0tgJqlvutFtIjQW1arQOecjbPBFQMLSYUYSRfsSqgwcUGY8Sd8MFZ6Js6Ocr4tkaMSxe/mcfsNLjmqET2tPoZo5P/bRHHs3CBpZDX0OK18DYxLVInXnQLUCmh/3cgghBAZpyzqB5U/C6AMFvFYWFJuToWtMHPAUxCLLvOHEvlrWCKznzEGnoorlgN9yiOPneYHdvC10231dj8jgpYtkjIcFvVfYtc9JueivrN0X+E035QJY/iINWG0OAtuqTxvEMQOVMipDtV6QgY/PX0ZXqusB/04YEYMu4YrYqV1Ijhjyny7Nh4dewIekdZo+U4PU7T6VngPh8fcB0o8S
 FQkAB25i
 zXw3Mq+Zzj3FzJL+btT7C6VSLuTTjFPlpUeXZrKqzsz6a1Pctmdl9UrKOVtOeMTFUsH8eulS+X1VCX2uzCgqP2EGY8C7A+9IP6zwmTirUWmqW6dhqO+TfTdid5W44QK0OBonpxfbzaS9i7u58Mqhea+d0DbGk5KsRYTyizgIEH5JNieJLxd/RiYeYLydl3ak+L7C2zeCjFf2e4WM61DuU+KleO9vV8MkATN3gSW6wgRlf3V+dE2ht3vlE8032JkXWQhf7IiyN2SqRTzz7/iV76/TOdtPwXwUjZjk5dEoWNUNtX5wrVPREyJUXcViRtRvV1yFO5jD45HN8a1AsVEE6xKD0Q8tgZbvl8S1YcJyALFzfNyzmya2PePsxMUfj5kZIzhBlUsbbAz9sizt8r6dJSHwprSREFyC7C8il4JfGkPdyihwSQgzeFvtXAdwE/td3rTVWB8kGZq5IZAb/YxhR5obwGpF2b7JjLakzQ4agljSxpCixlnR/Ts2IapeV/iET8FGwqV7vgWjp4HAa7WCDY+GuUrQh/Pd9QuoOQb/reIFcfzH5e/00CZrC2skpKypxWc9Ck6329h+S8cJsCwkqcfMJ94R6Bm3lVWQ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 08 Jun 2026 11:42:41 +0800, Yu Kuai wrote:
> This series is the follow-up blk-cgroup locking cleanup on top of the
> earlier blkg-list protection fixes, and prepares blk-cgroup to stop using
> q->queue_lock as the global blkg lifetime/iteration lock.
> 
> The current queue_lock based protection is hard to maintain because
> queue_lock is used from hardirq and softirq completion paths, while some
> blkcg cgroup file paths also need to iterate blkgs, print policy data, or
> create blkgs from RCU-protected contexts.  This series first tightens the
> blkcg-side lifetime rules:
> 
> [...]

Applied, thanks!

[1/8] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
      commit: 25656304dabd26198ec69460c594a19d086ef099
[2/8] blk-cgroup: delay freeing policy data after rcu grace period
      commit: 0af3fedb8c8ed3c07b4f76927bd7fc88f6f82efb
[3/8] blk-cgroup: don't nest queue_lock under rcu in blkcg_print_blkgs()
      commit: 56cc24f59c145ce6938959f792df04b8a4f5a4d8
[4/8] blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
      commit: 9327a865e395a53f67dffac4710beb1d4730495e
[5/8] blk-cgroup: don't nest queue_lock under rcu in bio_associate_blkg()
      commit: 457d3c4f0fdd6cf8a4bd8115bf470809984a9f02
[6/8] blk-cgroup: don't nest queue_lock under blkcg->lock in blkcg_destroy_blkgs()
      commit: 4cfd7c1cff8f4c863b99d420cdbe0563802a9e80
[7/8] mm/page_io: don't nest queue_lock under rcu in bio_associate_blkg_from_page()
      commit: f928145cbcb52544203808f159461d0a25543df7
[8/8] block, bfq: don't grab queue_lock to initialize bfq
      commit: 3ca4f4e3ae811d414076a491cbf0dfcdae0dc01e

Best regards,
-- 
Jens Axboe




