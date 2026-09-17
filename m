Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4AAC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A57C6B008C; Thu, 17 Sep 2026 16:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F1D6B0092; Thu, 17 Sep 2026 16:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FF26B0093; Thu, 17 Sep 2026 16:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08DDE6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:45:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 976761604B3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:10 +0000 (UTC)
X-FDA: 85224433980.06.0F9A6AC
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id AFAA3140010
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j9vZPGkK;
	spf=pass (imf26.hostedemail.com: domain of 3U1GsagYKCAQ02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3U1GsagYKCAQ02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789677908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jMNh0+jAAa1Kr4+QO+vi3xyA58GWdIBX9d8ih4uK1uA=;
	b=U8C4qPVBVabXn20qnzo3aKwub0kivRpHOAnbQe1DWo1IWZEZkti1a8hPr20v8yMMcm1wRZ
	iU6SKV0+JopL4PjVxxySxJ02XO4Mc42vh1U/LKzjK+iC9hqzbDjim+j6F4GjV/B5laXc5T
	8cQFFdXerD8f4lfRLx6KUUTKJjbV6Vs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789677908;
	b=gCQJNj72wNYsHyy9FH9c8zj0NfcXUM6FqQYsLf7Cd2Cef0Alc+dbkgQ+qVteIiqtPCFu9o
	6JjcSCfIoLCuQDQd739ylLD/AR+dtL6WweuRHokenDlz5NaC8WSHNxj32fV4bEVyFphvt9
	Lk0k76rQXpRcq9U5bXtM5yzbNbjZ7NA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j9vZPGkK;
	spf=pass (imf26.hostedemail.com: domain of 3U1GsagYKCAQ02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3U1GsagYKCAQ02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so161865a91.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789677907; x=1790282707; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jMNh0+jAAa1Kr4+QO+vi3xyA58GWdIBX9d8ih4uK1uA=;
        b=j9vZPGkKEt6z/bWxKj+4SZ2AiU+PKZO7JHk9RbHzeaUoWdUltNy2bfp6kyTPqH2L3s
         64yZvaLYLdqrSIIsQli14atsTNEKdzTIHw2IjivYhbmz93hi7c/zZSgz3LGtIpF4SVVp
         mjou24yIWxeRuc1nbiAGrbfbBSI4WIpSOeMaVK5dHJF4or/shUcW/3SayLpA3tT/wI/M
         OHC7YBu/ESiJa97KnGm1+NRtxWnVqAwalzNJPibpG/iXO83mlGNYiLfVQmNx703/mRS0
         bxW392aEZ2gYpgYabB26kDbmf7V0Nv1fdfYXshb8GYpBYBj375kmdTD7WVERwfRNEZQk
         42wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789677907; x=1790282707;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jMNh0+jAAa1Kr4+QO+vi3xyA58GWdIBX9d8ih4uK1uA=;
        b=WXNao+f9gRR09jPQXe+AbFhhPn/QA39CrYpnzC3wUafws53wPps/CAN1JCSb6KNLrv
         GxaKEmveinWUij/H/fdxrmgSlmPZXZ7STfiSDfTXqcd6rBwq8NrwY4yRrCK+3iUEH5/x
         J2QIhgsZDp95YNMZdkxlzk8nkvEZgogBzev8npCXr3qs2dVD18IQOyKK3brnVBxwaQyE
         QVqlIbp7ViBOGYrbnX+aJSP5my8Yd0FkMljHlz6YBFepVeVqLfBhDXxDK5/doShZe0Ce
         EpNlBvvlz3LXrlMd9DoL3MF+G8SA3BLGY3O16MI5eKpzK/xTRexz6LBMdhaW71hbuHb+
         0pLw==
X-Forwarded-Encrypted: i=1; AKwUvBwj1iOUzvHCb6s0cXDIhbgeXCW1muYxgiPKh+gkGu0UGgyIpnH2yTB1iCeLS+CFVFbJH9WZafhr1A==@kvack.org
X-Gm-Message-State: AFuF++mfQv/0FVzsfIEUx00+Yi1dDBAMnKkDmbtO+PAR0AOoDg1A7CP4
	rRCsroJWxUJNEetFTUmNdEO6nVrtYGxgY0zDfm3ZqYQ7SKKdv/mqMGnInBXreG9dQ/BgPlw2QWB
	csCPt2g==
X-Received: from pje10.prod.google.com ([2002:a17:90b:550a:b0:39b:a3c6:1ea1])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:280a:b0:39e:2530:2102
 with SMTP id 98e67ed59e1d1-39e54f4221amr1221121a91.11.1789677907330; Thu, 17
 Sep 2026 13:45:07 -0700 (PDT)
Date: Thu, 17 Sep 2026 20:43:46 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAJRrGoC/4XNQQ6CMBCF4auQrh3TFErBlfcwLqZ0Ck2AmlaJh
 HB3Cy6MK5b/S+abhUUKjiK7ZAsLNLno/JiiPGWs6XBsCZxJzQQXJZdCwUCDDzNYdP0rEAwWDPU
 4kwHr3qCMxMoWWGGlWTIegdK8+7d76s7FZzrf303Ftn7lkosDeSqAA0rdKKMl1lpcW+/bns6NH 9hGT/LHVSI/4mTiTK1QKp5TIfGPW9f1Ax+ywPUaAQAA
X-Change-Id: 20260527-memory-failure-mf-delayed-fix-7d5a8f4a8a8b
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789677906; l=1740;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=Am2jKIW9EJEt0JmvNafH4y2xjpYHkskddR3CBeqh7Zw=; b=/wh3h4RwP/TLeQrHX1ATtrr76sHTMiPuM2R+SJAOB0ZNs9zkKo19zhJPXOol9dk/vZK8KxzTh
 kMzeBBM0ciYCOfVQNYSBsGFmVAddo2DxqCG+W/jupYzZWJ8KL9ooBKj
X-Mailer: b4 0.14.3
Message-ID: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
Subject: [PATCH v6 0/5] mm: Fix MF_DELAYED handling on memory failure
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gqdzxzm8egs3rmieabqzp916cwx9jy3h
X-Rspam-User: 
X-Rspamd-Queue-Id: AFAA3140010
X-Rspamd-Server: rspam03
X-HE-Tag: 1789677908-907566
X-HE-Meta: U2FsdGVkX1+bBiXM0bSy09LjPVU67u0qVLE41Khp1/0SA4RO4gSl+gImw/c97UGmwz3pwjG25N76UwGU1a9UurAeguHrLQBaC0R8FwvWMABiUgTNKHyxTJw1RpAnZLxXeoC+pePwFkU8+cpzId+r5sSoPZC3CIiHX8F+DL14bCnYSLvMKS7kOwTyxBYu2qPb6wQLT7grukqM5HfquvpS7GM8xk7mnpN9ozhAFnIGtWoRHwEL1NNwltpVlhVCofzh8mRynHng0gIGwmrCuIztWkF4jIq+rWFQGE9ZiblLDtpBfwm38u1xa3w+v3o0n+Mln7Ch+t1RpOMwvAlqAVQbZb2GiCZ+f2p0j9yHQ8+57+hWXsObAoPSeCLKo/n6PR8ldvOQwC64T3KA0HM9GnDQZVx/IBbbTEyxjsB63qpriaNinkYqgOsbzUE18hcONUtKzA2niaie2WR+Y+IYFRHmvnqvO0JpNOWGvYP0LaMPUToA1raYxvKE0DXZk8sKHPDT8Gu32lrkYC5ScCrcjJxFbJxXNiwYJDogbO69hJvTybLZn4qx6PtYMJEmVVYuHKEznlVmE/aV8kPDaD/bPAyXehMKLK8xPqjEVfD54TH3wJOaFjQHeYwnqaEZRs7C9q5j5W9JVU6+OzWUBAlyA3EefNT2YRJEzTlOavKSwSNlFwqip2Zyv63M8VO/6MYx+9pPQGf52E0KL6mxEvp7W2XqkIpDfB0Bzoz2gg84ipZKylyxs8OrqUYMz+XdFWaDrB4CMddiInCc9Y5D+ZM5xVX5wHkHi5WpQPGOakkMTF04u5pfX0si4Z1Ze+kTtRJEgIgsRODepEUYVyxUp0LQewWD+TkS9UQkSV4iD0QVrkW/yl8asdvcTYkh5hsGTa28YNA6RiaSJFYy6VCa/7srz1s+KdLBix8CWRTjivQNdUmL8NIvyRJpOVqHJmzS53bf5yjv1uUOWZOhZP1Yl0YuIhI
 e5IVU0rc
 S+/qcRi6agpk3sFYcK3Om/qWeJ5h80o6Mp2hk070u7N74iqOx+UkG3Wf5RvgddVfX14OqlzyvvZtBQW8m5KbeFe9q77NY0BwVLaH24DjQhFJFMktYHaExj6XHcfwzQPehtxnVKMUUqMVOMt4l2gwh2Yub8ULwxr5uRdSR0mOgLKGHuUb8e9sc9qdHQqfZHFfywMVMRi2OyqOMJjarVJTVO8Jy7KAGmaTtfFZDoPjs55kQtLgx3jKdW4lVu/peTcpfZXuPlXK7P0IqDgkxCs2oaW7lT00WJ42cf9EHe58GjTz98QWJ/FqdYEjJ77m/D6hI6goJH4uCboANqdmIZd+f8U5nLKtPZFPuYLcyJqsN+wJmd+LtehJeIlzOZrsgz+0oH15dtaVJoXoMmUdM1vypdK4ABcx1WQeSTxrsCvl8mit8auNwO4Ejgyz99DIlUj/ZfyC4p/2z56S6T5uxjHcPlaBcW39J7byIvm1hT14GB+WfjhKiKr13zoxMA+QRDyeEJm/0m36uiTA02aTv1aKs2qghIC8htJ8zdys5j3FyYiunSEgpqXLARUlLr8u/ir48WuU2jY8+aOPoDbdQF+sjEQhUfjG4qPWYq3pmtPT8rBO7qj8kG88nwFpSJPennJczzQxAp2PM06TFF5zYcM1tMfTQsJ/Xv/RyTKeLFWUeBw9IV9JNhuCOrd0ogg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's a sixth revision to fix MF_DELAYED handling on memory failure.

This patch series addresses an issue in the memory failure handling path
where MF_DELAYED is incorrectly treated as an error. This issue was
discovered while testing memory failure handling for guest_memfd.

The proposed solution involves -
1. Clarifying the definition of MF_DELAYED to mean that memory failure
   handling is only partially completed, and that the metadata for the
   memory that failed (as in struct page/folio) is still referenced.
2. Updating shmem=E2=80=99s handling to align with the clarified definition=
.
3. Updating how the result of .error_remove_folio() is interpreted.

Changes from v5:
Add comment-style fallthrough in the memory-failure test, as suggested
by Ackerley and David

+ RFC v5: https://lore.kernel.org/all/20260823-memory-failure-mf-delayed-fi=
x-v5-0-d97a5703e45a@google.com/

Signed-off-by: Lisa Wang <wyihan@google.com>
---
Lisa Wang (5):
      mm: memory_failure: Clarify the MF_DELAYED definition
      mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
      mm: shmem: Update shmem handler to the MF_DELAYED definition
      mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED =
cases
      mm: selftests: Add shmem into memory failure test

 mm/memory-failure.c                         |  29 ++++---
 mm/shmem.c                                  |   2 +-
 tools/testing/selftests/mm/memory-failure.c | 114 ++++++++++++++++++++++++=
+++-
 3 files changed, 126 insertions(+), 19 deletions(-)
---
base-commit: 08745c62350126bc31b09548137be87e2866f628
change-id: 20260527-memory-failure-mf-delayed-fix-7d5a8f4a8a8b

Best regards,
--=20
Lisa Wang <wyihan@google.com>


