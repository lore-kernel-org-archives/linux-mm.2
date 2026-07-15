Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A44C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19036B00C3; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF13B6B00C5; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA77F6B00C4; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A27D26B00C2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C486912013C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:40 +0000 (UTC)
X-FDA: 84990725400.04.B364EFD
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 132D120003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YM5AQXgU;
	spf=pass (imf31.hostedemail.com: domain of 3CWlXaggKCJI5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3CWlXaggKCJI5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BvOk2rkLE/yZxPV4YYeXjAMJoxjIiJfLSZRx9VhA7SI=;
	b=L4FOaw5ZXt0m8H2ICeMM3HE4f9yxPtRT4Fvpx6nJzm/GA493zMm/EkIyCgBEfPy1UVrEFe
	vOnlt5g++xV1T1eLYN8sRrh53Y0oFi18+X6zMN6gpa/M9V3T2ZBl6giabzs2uEE/xYPoqn
	32BlUiuDyWiAWSdW+AoNpjUT57U1Z2I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113419;
	b=vzCfBW7UHCBTmjzLTFjzIPDcU2yhSAoAOajSB4d/9as9qg0F8LBAL4mW4vhjKexES8QjsY
	mvm4MD9qIoPpHnWcMFSM4NUaJnFERNQFLd5jfkmv/7zJ6pSYNEs03qlSINDvWuONw/fOys
	7rJ76fD4Kip+adZzJ8FQ7YpQzzIrQHE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YM5AQXgU;
	spf=pass (imf31.hostedemail.com: domain of 3CWlXaggKCJI5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3CWlXaggKCJI5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493c526df6bso17621345e9.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784113417; x=1784718217; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BvOk2rkLE/yZxPV4YYeXjAMJoxjIiJfLSZRx9VhA7SI=;
        b=YM5AQXgUIm9ZOsqGfUiKc/hAISY7jpUoC8juMlMFOFM9WJBBV4RdLCzjDQBbbA/ilx
         QZTHhd2JPY+F9vM6Tpc21dixSwA82u9zh6Hfe2LRFnU5fjqy7jPKnw3GSip33UErpA9p
         h8+Y8aId6hSAiOlCZjwXuq8u++7FoZtjnJCbhhC+rvdS2dip0pw2qg56qvimL9xYF0P/
         XS2tYfHtUzpVeWdOUIf5G73qGbArcsIXJo7t2drLpMD/CPnoUYjcdrwePVVWeJfRh5jc
         q2OY+jkY/BCrcAmrwGmCTlzZRlyN8JjnebrH9UDezD5sQmKVBKYS/BterIcxyshihejC
         nO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784113417; x=1784718217;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BvOk2rkLE/yZxPV4YYeXjAMJoxjIiJfLSZRx9VhA7SI=;
        b=VQmTWW1iuX2DW4T1pfnt0hjl7H/A8OEf9Z8AmPSFxAC1B1kHutf3GsFaafCQroBn7H
         9/KPIwb4ostNwDUFotDrbKJ97C3F7/muW9gZcl1nKm3MckNBPsVbF9nLWtR+R4V1NxlY
         uYZangZue+FMGR2R/18s4ucpq3d6gSjHmNiIqGWFOiJdFUUNs2e97XJnWRF1nEsaVZU3
         HWJUPLiPtdVxUi4da20v41SUQX7sCGtd+CAHFtFmOIgCSgs+vblALA+2WFTJcNAaicA+
         g4PLg7YLwbo4TVtLeYng7cXGPhlxzVyPiTsQ933OIhmW5KR3VdAGGXtck3kirz0syxpb
         z2Aw==
X-Gm-Message-State: AOJu0Yw9IfcKP3SFjtT97LUp3OLDWOV0tYGcAwsKXvPQQw2kndjzJVA9
	ZNwdAe+PhnT6LdgG8Ol75veMrrrXnT/hCobjjlWJrosox1vmSJre6ml7C/9DTkpmpM6tNFrEPb9
	syVdniWdHeBlOZA==
X-Received: from wmoq16.prod.google.com ([2002:a05:600c:46d0:b0:493:b593:ca9f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f8a:b0:493:f7c8:eae2 with SMTP id 5b1f17b1804b1-493f87e6e9cmr175096055e9.15.1784113417076;
 Wed, 15 Jul 2026 04:03:37 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:03:17 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAPVoV2oC/4XNQQ6CMBQE0KuQrq35tIDBlfcwLqD8QrVS0kKVE
 O5uixtdGJeTzLxZiEOr0JFjshCLXjll+hD4LiGiq/oWqWpCJgxYAYcUqBtUT0c7ayNuVBqtzWM
 aKOdMFLxAaMqShO1gUarn5p4v7+ym+opijFhsdMqNxs7bsU9j79+HTynQSso6l5hjA3BqjWk17 oW5k3ji2SeT/WJYYLhgEAjO6jT7YtZ1fQEIegvxFAEAAA==
X-Change-Id: 20260710-spin-trylock-followup-332c636e0d99
X-Mailer: b4 0.15.2
Message-ID: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
Subject: [PATCH v3 0/4] mm/page_alloc: couple of followups for recent cleanups
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, sashiko-bot@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 132D120003
X-Stat-Signature: nf94443g1q38pkiac3rtcwaypmbutmxd
X-HE-Tag: 1784113418-947528
X-HE-Meta: U2FsdGVkX1+n3F8LiLL9dymRDfyKfsauT8EtYg7ILxjWafyqASwNq106XbqVA8CpgiGdeeFmWplJVKU5NZs9bfHjyV7EJXfwpdkOjw8dNLrgOvXqwXbp7WLpWzvdLAuj8Gginlz6qa0n1w8TnAOdfUjualVSmg4hJZOk1crWtbN6n8yXB4SA46y67SDauxScnIqlOpse+nt+ycuJcJKG6zrbKM7o7n1IiN1wFEDeatY1XR1t9uqGMj/MA/0JF3UVvdw3GNexhEswSnEiAI+XOM2WE5qjaNtOw7mGSvtEObPiORRMiG7L76j6RJo+Ms64jGQgMyiIGz8Ief7qxAP2vkhd0JBiusRyEk6ZThzWQiUwLUvEEndlFDoGFwaL/B+JV9EM0xBGE1yuwDkRfd3i9i9dPfFOjjkkRH0qcMPjKif/AkAOP91pzESY2sUo7TT16FCo4iZEmfM3l3Je6MdiAPdA3kXAotu7T50sB8yFWUtPZ6HoSMdcprY3lpC37vP1HgiwWlADUr8rmTtiNP7CLUMf8A5fdNLAsVjiDxevFENTn/3vHtilVGgzM0LiKQPeXjeMgrI+FrVklugVstkii4Rd1FE5+JHEXfOS6CdvJGxa7qwzV6MCnh64zNvtm5MKQ898x5X8RHYvV5k8EvXrgjwWbZ2pdzRKB72PMNoNDVReWT2yvunZXxf6of6YpHxIYQRmMTpq5HLhqbB5R0aIHkhzZk33MQ18F/ToMzUz1llRcUgSj6y68dGMSJgJQGlonclqxNUe2RJpID8oXTjyMz7vIN2IXUWVpU4oZWm7D1Za7wouuQkSyyp/fts+aRLwlJci2VFmhn5mqouOv/E84PNGb86QkfnR4iDv7TB7+CDRimJI+fkfer172NhAR7axvpi0rDNLRnDyV5y8R4vjqCsXohYcD3pFq8G1LhQY9BCgmSsum1/k3SZCiIdbq32Z1XyoI5VDhPNTKZgwIkl
 sKH+LX6y
 Z1dNblF42LsOspCQ9lgTRpFJvxP8bLaF8e3b6SmNMD/1whrhmMJHJH74V87m392p8q/kUBXQOE856WKXWHTpevzwFIYheuC+dMHDMTcDDfA27V+89ZUQH4ORosfsCJgywKajGcnZDv0lk6yMqGXlpn9+8VWxL1nFXlLvpZ9ONyqYSgaytsqadQh4L29snNHbWktGgWJ4IsYnAQDhjpXPeY4ztormJ5xUtCjFJG0yXrITN1gwV7LVrcf2rDoA/1MqSQ/LnyymRhzJRBZXdshYpKRBAMj0P9qlms3c2Cwv7JTOgGsKyMh8esR2DsuRtlcDCpa2QNyB2QYR4+ef7NtOMTFIyQN8vJzwuh8/Hz5NEWWtpqIDkJyyRMUX/jy23ScAMiOdWGCGOoN7FVY/x7XygB5uf4VpglZ0EweZ3e1RhD5YZBX6lORLTV/5YPOpS9CJErVza6aSj4ucFIQVWkvIsqW3bbG1c+rJhpHbEji5mf/L6Zl/jGv2ZWDpAz2o65zzh2DX9T9r8S04yP3xKB9fOLtgWSaJ08q/In6lxA2cMu10SO18WQViypHFDcvLIQWUiweWHYaus/4k40S1xPdHtJMgi+GFPo7Ma1438d81saW7H2+tctOVFeEeTzdPkwWfvijxlyE5OKCp2xN2u4ln4jlR2u9ZZLDkebNSn0xH1P1sxBLEA17PI73+G59C3ndftohxveEunGKkAjP4+h9GdHDtpYXDqJpOGUfIWQ8tX1YN6YSWbeZgFf7fHkzyGMvMUyxmvkzGpwWZ8KCTOtGptzumf34suEg8AOI5hjGQF1uKrTC5oaO+9Z2+E5O0KFOPsd5+Km/YOGsGWsinv8OVQftMJogqh9TWSNrdI9kBwD0yA2qxgmkYQk9PcQD9rifJB0ow76TCy8B0G+bBKhEQGcBAULJyS01+vXTmN1Fy8Yh02dq+cKiZO18FTA0IVaex/IN2tJsgpibWQfZ0C92knOLKIQ0U7
 ELQxQotF
 zhpZI2rMvPMVX6h/FTuREmDg8SQlfS0LyuXCrgI31GA4LVQyUJQmb6IAjE9VtkIhzzNkHG9GIiq7DroBDZ3Wf9wWww2lErAaAmECLbKhkyGyt88L4/1GRVtiPnFcIt3zuKDk+1siCT0WngUiogE8zp0uQOM/b+UXDSsaaXGrukorRn8JuL3xeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



---
Changes in v3:
- Fixed Sashiko Links: (Zi Yan)
- Fixed kerneldoc syntax (Sashiko)
- Removed extra VM_BUG_ON() (Sashiko)
- Link to v2: https://patch.msgid.link/20260714-spin-trylock-followup-v2-0-=
3c20ed032b14@google.com

Changes in v2:
- Separated from functional fixes
- Added cpuset cleanup, comment fixup, VM_BUG_ON() removal from Zi Yan's
  review of [0].
- Link to v1: https://patch.msgid.link/20260710-spin-trylock-followup-v1-0-=
affb5fe5ed00@google.com

Based on mm-new, these are followups to [0]

The alloc_pages_nolock_noprof() comment fixup could be squashed into
"mm/page_alloc: relax GFP WARN in nolock allocs" - currently
11770f8836f44 in mm-new.

The VM_BUG_ON() removal could be squashed into "mm: remove
__alloc_pages_node()", currently fba100a6cdfc5.
[0]: https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@g=
oogle.com/

To: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Brendan Jackman <jackmanb@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Clark Williams <clrkwllms@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>
To: Tejun Heo <tj@kernel.org>
To: Michal Koutn=C3=BD <mkoutny@suse.com>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-rt-devel@lists.linux.dev

---
Brendan Jackman (4):
      mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
      cgroup/cpuset: update some comments about the page allocator
      mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
      mm/page_alloc: remove a couple of VM_BUG_ON()st

 include/linux/gfp.h    |  1 -
 kernel/cgroup/cpuset.c | 13 +++++--------
 mm/page_alloc.c        | 22 +++++++++++-----------
 3 files changed, 16 insertions(+), 20 deletions(-)
---
base-commit: 59c684a9908d2e6f7a791f7f033eae57ec2b3a61
change-id: 20260710-spin-trylock-followup-332c636e0d99

Best regards,
-- =20
Brendan Jackman <jackmanb@google.com>


