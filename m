Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FBCF606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=rXjwRxsk
Received: by kanga.kvack.org (Postfix)
	id 428086B05B4; Thu, 29 Oct 2026 02:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9186B05B5; Thu, 29 Oct 2026 02:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8066B05B6; Thu, 29 Oct 2026 02:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07A316B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:07:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D285A02ED
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:07:15 +0000 (UTC)
X-FDA: 85374631230.08.835233D
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7A87920003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:07:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rXjwRxsk;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254033;
	b=YUu2a4ovmB3HKSuIN7f6jdQzILYmUVGHxzUXJrCRKr7Rx2xW5hwFVj3xSvqvKairxyiBgl
	Q47tuYez0bfveWrNBqhLp1+VH6wT19f/LD5IYjSHtuTWJ6JRQ0HLfbrEljSnX9x4M312jn
	+aTl9pF6v+WmEyK+5WRYWeEM/+RwReg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rXjwRxsk;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UNSxvxACDv6rV+hh5v7KUi83+vs01nWTUXRQ2PYQNxU=;
	b=6nNmr4zqZqWJ6DTaiG34dYjyOPmwPHZA4O0GqEp541MvvQvlh4iNWTJ1q76cYdSJoFZQfU
	U7HbpDkZ/AULPmmNZ2yoYDjIRl6Z0EfSJUkyP+EWz+FQY3oKt4cb7p4BpyDI0Qa3A5A7N9
	XVjX6/JRL6VdyMGx4bDcElyuhliiIKY=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e812e2b31bso10304605ad.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793254032; x=1793858832; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UNSxvxACDv6rV+hh5v7KUi83+vs01nWTUXRQ2PYQNxU=;
        b=rXjwRxsk8YJkZHAH6//OSLsDf0MDqljp64BoOo5TTgHxDjc3bjzmALLSw1KU5ABMIT
         eDPwwj8/kq80/plPopaI0ro6mJGqzK/rvKlY+1nRMkiDEL9x4cSAfwjzmO7opQ7oaF97
         N7tcO2qqqAW7AStpFk1OC3UVOHvJTXJcvf/Xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254032; x=1793858832;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UNSxvxACDv6rV+hh5v7KUi83+vs01nWTUXRQ2PYQNxU=;
        b=L//0hqZqTe/eSO4wQY5F6ZwnCYPyaWmq078TE3eu+EfAMPQ66wQeTtMZk9FlK6VyL0
         KsnfQH0JsLaHKDM/4Q2NXUdRivDrwwrx0UJGEAo8QnINuO+8PiivqjW+6PQHUGcPWCdi
         MTGueTihdQItYZUkAtosbbqzvqOhTqFLOyeP2e3bBETJIwbj9Hfg0353M8u6KBAUJW0w
         BOp5yPQgSkUNAYGJhadsjqSEp6ERSID8st8r59rRHwLAYYRvvgKYB1xzf/5npU4Mri3c
         OGoXk+hDTm6U7yjSVZRI2LOChaGgUDyW2MLYyKuYqPqTmmj8RaGrd23BO6X2GlMOWur7
         sC+w==
X-Forwarded-Encrypted: i=1; AKwUvBx+LmVSMe/yqL2tDEaALeuke6ww3sL/GYlexEQI0Kt5wSAOsNn61LhRbLy3yAxZl8/sLvQSenMYqg==@kvack.org
X-Gm-Message-State: AFq9FYLc3m11Ckf7UYOayI/lUWENREfPyyrPAC0DCEVl4ehwq/z+QF61
	G1RPM2ZkNqDfkVRzHi4k+OrtvzGbS2vr/NN5xun99rTnpyYnDVeL5/SE0wSiVbvVkko=
X-Gm-Gg: AYBFou2BdGpp6WOWf1+5+6e6/RQ+8DDt/UBwAOdTFq+nK7Ff4dCKArad3g2YWtx4sP4
	78HUU2WZpmGnSqYaw5mh6kBhQ7zhSOUVjvfy81GPV8uec4eKXsMoiwIB3q3K8emdDw32J1QHKV5
	FJJx9AEzL8BK0moR5gKXNNWPXnW97jlw3PnT4K3b+ht2Nt2+9gWYwWdmzcAIaMhSWsXQVq3i9L+
	0kO2cRlH0P4A3fswknOb5JeHsDPfQWWMkAtTM+ov52HXmGPRzmr6KvZQCeYA4UB6857lu8iGsQ0
	HC1z+CswO6H+5Xr07kBTPGuhP/S0EOR7VykWJgUycPvqCOmM2yLOn5zCewSZqj8IqM3vf7u/hSc
	F9W1d7mAi3C3XEWLvAwA57krjSmCADeb3annj955NqYyi1zjzJy/JPWYJI6vis34jZBDArHPdlk
	erBu8RLmXwverZqM4QzyCswBRzXIJ7oc0w6B3v3r152WwA6JlZ04z9PWNQYUab2T8vqk1LJYYTR
	7Qen07nkh0nii8vTPfvx2jLw8yQBbDCGldhL3Sd4AJ1hs2bFeN/9DhDzlJBfyyoCbkJuBQv7AGi
	1GFBVKQXmqEkZrXR8JU10aAreIRd1yq+Ag9G5UHgendwcEN9/ckrKmWupygziUJBqTR02PGB9dI
	Yc3nkIghqjIFqfuTy9wfXaLBpjMMQfTtDg7Evnd2D/2IkbDpu7E2rWIQQBWfdsEFGm57OHgV03w
	==
X-Received: by 2002:a17:902:fc87:b0:2e2:b7b8:abc5 with SMTP id d9443c01a7336-2eb0038e312mr41423305ad.32.1793254032255;
        Wed, 28 Oct 2026 23:07:12 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae64549dfsm29271725ad.4.2026.10.28.23.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:07:11 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:07:06 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 0/6] mm/slab: Support selecting slab hardening features at
 boot
Message-ID: <cover.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A87920003
X-Stat-Signature: 8tf1omprkra5rpoqy7jg5kkkbryryqnz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793254034-606452
X-HE-Meta: U2FsdGVkX1/rE02Nrvbml5eyZ9ApuG04DQye1yawP/p/m0TXSwhw85Rbj4hs7q5Y1s6KBWhAd833waLlMSW8u/y/MwwZQpQabKhWn8L4PdQkdBk4d5ztuVuI0+RQBDdKpp1Lx4nzbfGKMSmnxo2cFIrn7vNc3YP9UF4haTioeFGqvZOC0sV82FZ/JMEX6hjDFwl8d4HMD95EMSRygzOweCZ7YsaVkCjJWVaVbc4WyUiT70XYVgIggpGzcBclq+FWKRSeR20xZFcJSfHTmZCMVWfRaaaxTGHbu6/DNa7XK6uVrXRnRSKqyDXcNTr9vqW2P8zssVxQdOS4FOLXmurjdKRzGRs+CO76iVT8Bd3Zn3p30/YWhF/exBsWggwhFYPYsoefLZBxMutJvebp59amJ/YI6npwnEv7JPUY88ZzLazEZ+pt5NSKvPY7diWCHFbc74h+31DV1hTP0BULnfH/vyuT7NDxC9w7GPz45Hsj8l96bJB5DlGLHLcORmdkWQw9P2thHkaQrpyj0ObJ9XjeW4QZTCJVuoyMr3kzqL01x1DbfXYAqz4dElavrnMOjL1AgBcQfQ3fM+2qGiFFsBz88qyOeZK8/wBvfbNI2og2oSnDO01G0P1H2TFs9+/mWP4bL2Zc81sxLBAkMrTPxxIJYVP1nemJWOh55bU7K3CYfo0Wr9V8WT9Okk2Ri8IFUXs7gqDGHYU0nn1luruMHRbnfOkN9Xgu+TQPGHd/KlG9cLuRXnMlOw5zPQNWVFxPPOXwDsBYeS7Jr2sP11RBoyawkWNuyLOEvvgZNnuo5sxnuNuoTZLrf4b+kMgquh/RdbYXXMRpisBXugDdNF52zFEGP4h0WnVaMEBHe2Bw3foZu2qTtHvQ4w3Uj9eMvpst2LcCjEkRfGp1Th37yu4tD3fiSEPr+bN3ku/stAJyFH2oaRSALS2E1wdgpouE3+IBK2akC1vU/TT+D91k2FX9O1/
 42LlRxvC
 75eiIT87JSKgTmuQ9De7NJbFRrngQFMxRgbjTM1jZU6623e8Sea3EqI/cgFE/ra4OApRJOsnCc2bw8bmadzJZijbZeD/PjX1Jj4vj9Ll7Njfh42dJoGlGTDzk3krdotC+h8iDddkaEMAnnghID3/aHZS1TsDDsm9SLTcZ3EKN7e1BWkxnHqObIcteiPACuRsOMw1Rpsggqx0YUthU0P7xFPdUEU1pRStyh2hES4tZBHBcuuwmhfteozcqqaKOnkbSarA6Sajr3MinNVdqxu+4Barlz7SitAzCsPNNgDEywVXMrhg2lMkL4L1ZSiPcgM4Q7TH8HTs1lf0HWGai7m2ZeUpZ2fu42Ws53Yut/42Ey+Ag8h1KGf361d/XAhNRBs4Q2lT/IHpbr4OytnKxkF1yDiRAG2QG9bj0IQ3VmuhoOHh2R7emzOGqOLzbYQZSbdIWdvD03amALZxVaXeONE5XuWZ+OM3PrJFCofzE/ntUDdrl8/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Slab hardening settings are currently all build time choices. This means
that, unfortunately, hosts with different requirements end up needing
separate kernel images. At Meta, for example, some hosts are built with
these options and the rest of the fleet isn't, and that's one of the
things that keeps those kernels apart.

Following the discussion on v1, this series now does two things:

- SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM are cheap enough with
  sheaves that it makes more sense to just enable them by default than
  to make them switchable. With both on, system level benchmarks didn't
  change measurably, only slowpath heavy microbenchmarks did [1].

- SLAB_BUCKETS and KMALLOC_PARTITION_CACHES cost memory (Harry measured
  about 1 MiB and 18 MiB respectively after boot on a 64 CPU VM [2]), so
  they get slab_buckets= and kmalloc_partition= boot parameters, which
  default to on when the option is built in.

Changes in v2:
- Make SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM default y instead
  of adding boot parameters for them (Vlastimil).
- Skip the memdup_user() part of the slab_buckets test on !MMU
  (Sashiko).
- Keep slab_buckets= and kmalloc_partition= separate for now. We can
  discuss whether to merge them into slab_hardening= or similar, as
  Harry suggested.

v1: https://lore.kernel.org/r/cover.1793086056.git.chris@chrisdown.name

[1] https://lore.kernel.org/r/auITixAJMfLtfa7i@chrisdown.name
[2] https://lore.kernel.org/r/179312451613.474906.1475329637924619088@kernel.org

Chris Down (6):
  mm/slab: Enable SLAB_FREELIST_HARDENED by default
  mm/slab: Enable SLAB_FREELIST_RANDOM by default
  mm/slab: Support disabling SLAB_BUCKETS at boot
  slub_kunit: Add a test for the slab_buckets boot parameter
  mm/slab: Support disabling KMALLOC_PARTITION_CACHES at boot
  slub_kunit: Add a test for the kmalloc_partition boot parameter

 .../admin-guide/kernel-parameters.txt         | 15 ++++
 lib/tests/slub_kunit.c                        | 87 +++++++++++++++++++
 mm/Kconfig                                    | 11 +++
 mm/slab.h                                     |  8 ++
 mm/slab_common.c                              | 48 ++++++++--
 5 files changed, 163 insertions(+), 6 deletions(-)


base-commit: d15d7703166daf7bd62c844a3cb1b3a6279adb4c
-- 
2.54.0


