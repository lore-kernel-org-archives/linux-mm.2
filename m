Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DBC9D2CDF5
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 00:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9B56B000C; Thu,  4 Dec 2025 19:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A276B0010; Thu,  4 Dec 2025 19:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4496C6B00CF; Thu,  4 Dec 2025 19:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F02D6B000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:58:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0E241331EB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:47 +0000 (UTC)
X-FDA: 84183607494.02.C6B6C0D
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F08E1C0017
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mVrzgYR9;
	spf=pass (imf18.hostedemail.com: domain of 3RC4yaQYKCLkZuZfhmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--avagin.bounces.google.com designates 209.85.167.201 as permitted sender) smtp.mailfrom=3RC4yaQYKCLkZuZfhmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OkIFDglYe+NNTa2m54quJMQQhad7qn1qBiLg81dFGHA=;
	b=lxuVDlS5ZpP37tTZnTb3EBnWt42QDXAF2lstrFy2cwYga8dvlw8WnE2MkQEWy0XtC9XYTT
	mHdfP/dOkXQ2NP1+bE0ouTpPeCAhXjn9dxV0VXGZb9DpePSY039b0o7ZhrImYaPPXtb/Vv
	etlewaQFfep4BmqdqmMNUslOIPibteE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mVrzgYR9;
	spf=pass (imf18.hostedemail.com: domain of 3RC4yaQYKCLkZuZfhmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--avagin.bounces.google.com designates 209.85.167.201 as permitted sender) smtp.mailfrom=3RC4yaQYKCLkZuZfhmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896326; a=rsa-sha256;
	cv=none;
	b=3tpgmT5Jxar8ucrCvlqBa2mxKH3nyv8L4qiYhUMPwioyuuxNoD81eYvOZfQYvOQOm4gxEA
	9PJ88YYLiHLcb9PctM7/XpF4Xm24Q5S+h8Ye4Lk44X+DNqKy9/dWCSisZ2XxkoWDTBKR+i
	a92Xt0bvA8l3BMW1Es3F3bdtReSVGXc=
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-4510650af52so2166493b6e.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 16:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764896325; x=1765501125; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OkIFDglYe+NNTa2m54quJMQQhad7qn1qBiLg81dFGHA=;
        b=mVrzgYR9dollPk1Tqxb+6xnSxpjC6R5g7mONHmMfAKV2dnc3XekOzFIfftr/OsTRwO
         n4LUhPnnP9z2IaLXcUgWkKRK+ZKiBJSlZhzYP0zUaiMqi5/zcPatBPXdlOiXgkbSlfPy
         qggabdJOsoY0V20SIRMW5ZR2ivPcbOWSE7kfoa5bW7pSaSKRINbfHa44h3srl4pt/6ek
         o1LMCr+lcjhWBc5PUBNR9YYA/I9ASKyUU4F0uBEIW2KQXGP9pDhvoxol5cw7u6ykKZ1P
         0uUMefoqgTRSHDBVBddcF+DiNUS5+I6VAc9qeNVGq2TAokocnicAoYP66oMtr95ZeB8I
         gDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896325; x=1765501125;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkIFDglYe+NNTa2m54quJMQQhad7qn1qBiLg81dFGHA=;
        b=qQK/WJC2u+1izwdh1sPkCN7IB/Px+sDDeKeV0kjg5VlQqa3tXDfzSdh2drBY+BC6V2
         0Fsgq+dYRpKm+adJTVszLhDwcN28snMLyey9KJH+RGT12d8qpCzjoJgoznoL1sQ+mB/a
         VS0BSleFHA29KKjClJ4DsFmZIY7GGKHv1H4RKXfuZCsbxJF9kHEvOfAZokgAfBzA4H0Y
         JhCjQbQJf6k32aI4OarXzi22w18hfq6Ng9ZiAmv7Nd0M7z8hd98Kj4PxPOoQJUjj5QFs
         VzbWtH5J+CJRHLT5OGPIqjxc6dQQcRpbKo+ZzeHHF301WkiwnBb1WmfFeH/fAr3QScKD
         vgdg==
X-Forwarded-Encrypted: i=1; AJvYcCU7u8Hnj/8IdHvd1qCmaWL+/AIMM0q+wV0QKNBn8bWL6watvOluXyhxhv1RyD5/tEivLQ82uw6C4A==@kvack.org
X-Gm-Message-State: AOJu0YxbxK6/5l2Uqopiu+ePN7VoZP8bIxzWhPIi7TWtuXhKfq6Nrp+b
	zoPrMFB2T5SH/4ziuFFqYDVtGw4T3EitbyNvFZAJj4PoR9WhZAaXtI0eBGolMjl+Pbdz6CMbWVH
	VwzHHUg==
X-Google-Smtp-Source: AGHT+IHj0LPEa/ejQQf0MUYWeJwJfYADQwqU4BCYqxCRyoUpapAb59gw8xQzZvkTJOVDLbICm1TVHGWi4NY=
X-Received: from ioby11.prod.google.com ([2002:a6b:d80b:0:b0:949:806:8e17])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:2383:b0:44d:aa8b:58f6
 with SMTP id 5614622812f47-45379d21b91mr2858055b6e.1.1764896324986; Thu, 04
 Dec 2025 16:58:44 -0800 (PST)
Date: Fri,  5 Dec 2025 00:58:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205005841.3942668-1-avagin@google.com>
Subject: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: id7ur5d8efg49f5ffch658okeaui4hxr
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F08E1C0017
X-Rspamd-Server: rspam09
X-HE-Tag: 1764896325-763166
X-HE-Meta: U2FsdGVkX19TpVsyJhZTG5yp/tBhgkHU97Pb2cTwpAhJRY8Opof4yhQJRBn2UZsoOruBwz7eX2kPK8HeelfBus8DVtGguNnyUB9eF3SX8qmXmvNvhqkSy1nE2Sxz/cPW3FG75xwhJnaz5DWzLD/ykABhhzYoYHCMkCTnNxYFAV48v80/pANcriay0c9TKbHIedl1PdHiOBZIfsuy136KutHxQQ5aPYBJbhFS8ZsbsN314Cgv6jb0i0NvvGlmBQFmIdmicbErX9C9uf+iTAwwPmd/4aAOrm76+BhGCkEme03RermLtp750p6lRU2RdhhMsfyym0O6UTz/Zuj0pMUCw4t3qVb1wpSlDOvLaH3olU5cUDpdjZddApO3ZIDu2qpuNw8e7cS/ZmqN7q49ci/h+3cIMHxWAnFNJcCGGdG7m2NMWTfxh1PiLgKSwbauH06KVIm4QJECtP/A6II3hwFe/vZgPRgWeFrAfWni0y+4hkToJ9oKlSchETTkpdM2MJ4ujhBTNDgYG16or66b9FKPbZQv5la9bNZUAtwDOPRXt3mzrJ5Z1X9Erot2Dq2y5JZfJ0lafv2J6uXWscO9Gw5mpSfUyp0IiWna0tLpCBBt5//vCgbjadQ0urwz9+blwt7ZfD3HWiksOVv3GFL5msDMjSscmH90lP1Y2T7u87HwtkQnW/LWwcWVfP6NDIQk0LDmz9qYO11ueefElzXf8jb0mOm+ig98X3fNM9OrmTMU/VZoZ8MaeDlztmsqtPPgZ4iI70cW45OnDEun/6uG+tljeAlCaUAfSFOoF2yTOsKr5sQaxCEoCnwbJOTRvyTzFIEOxXrDfNBXZmnfDU6aFM3zTIxLmGpu7307ZhUlZf0qBqSu5atFX1yX2wr+UBQW/C3wgw6Jfh/NLd9IdD/TMaPhynVx7FZGWhOIQZh9U93/CjxfyIGBPSw9KHpr7kxgCOFEFFNTKwR28k4Ht1QVDRB
 L0ipK3hs
 pgo/dxrSFncsJuD6GH4h/fzm9PEc6b02qaAWmIn353w36iIHvVF/cDQI382cIojxaZqjfuy9f+tHNBmhCmQ2S7ieOqrw3BiodKg1xb3YQFHz/PPBNH1sokv+NlHWfeoq5zKpzBihN174Z/hwpZfMmoDs1xlj68+TVx9g+6J0zzoqS6eromzsiALTdYLr6oAB1UjVgsYx6jcTqHzlOD7zjdZai/iZ5UKWK6O1NKVgVPjLUT2Zh/FZ+XLzfLEdJWGWfpN4wmM4aQBsOQcz25s/FoBQ5XGB4VYECAdG+vJ7/CzpqW8eFxlAr4zcgfTPlSeh3bl91Uev4xgIJ0z/j4boAytJ1An/3aYJJMMz2a5AnTkVALVrmJeNvSq7KHPoPRiNvzafAX7I19njwEuHSY2fWmxbB2PQmQnen01fY/vx7fx3nfFFfHbife92nI4GlS471liva9YPFF2nC0WX4IP/WzIs/2iRYq23cxvqrVMUbyyso8h0nQ2LW/jA3UIJ1XoSEs247iebTIzsRnyD6w63folq2PxBDVNcRCjeUMBG/7CeMEvYYeX/IDTDyCBvAs7x82kSo/RSqqjL6ld3Tu9nZGM3NQROAshgPEAwAhpmXnVi0MYzIjUFgwwtthypu51HvmwvYClzKI4GxTDiuETukdvcyYZ8With8PSdVQz1j/1qaeu2Unzm5oLKhUdoIr4m1Hf6+iUX68Y6MAssztTDEEbsApwgS1w+oZ7S2IBnulVbbwkZt6poJBDTjQwZglNTjvDRH9OGI5nig9Pk0YnE1b5Ise24G4rHwXHrBh34Ng6J/MzXUWaN0aQsT8+gd4DWX52Twt/J5+hXgwW0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces a mechanism to mask hardware capabilities
(AT_HWCAP) reported to user-space processes via the misc cgroup
controller.

To support C/R operations (snapshots, live migration) in heterogeneous
clusters, we must ensure that processes utilize CPU features available
on all potential target nodes. To solve this, we need to advertise a
common feature set across the cluster. This patchset allows users to
configure a mask for AT_HWCAP, AT_HWCAP2. This ensures that applications
within a container only detect and use features guaranteed to be
available on all potential target hosts.

The first patch adds the mask interface to the misc cgroup controller,
allowing users to set masks for AT_HWCAP, AT_HWCAP2...

The second patch adds a selftest to verify the functionality of the new
interface, ensuring masks are applied and inherited correctly.

The third patch updates the documentation.

Cc: Kees Cook <kees@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Cc: Vipin Sharma <vipinsh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>

Andrei Vagin (3):
  cgroup, binfmt_elf: Add hwcap masks to the misc controller
  selftests/cgroup: Add a test for the misc.mask cgroup interface
  Documentation: cgroup-v2: Document misc.mask interface

 Documentation/admin-guide/cgroup-v2.rst    |  25 ++++
 Documentation/arch/arm64/elf_hwcaps.rst    |  21 ++++
 fs/binfmt_elf.c                            |  24 +++-
 include/linux/misc_cgroup.h                |  25 ++++
 kernel/cgroup/misc.c                       | 126 +++++++++++++++++++++
 tools/testing/selftests/cgroup/.gitignore  |   1 +
 tools/testing/selftests/cgroup/Makefile    |   2 +
 tools/testing/selftests/cgroup/config      |   1 +
 tools/testing/selftests/cgroup/test_misc.c | 114 +++++++++++++++++++
 9 files changed, 335 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/test_misc.c

