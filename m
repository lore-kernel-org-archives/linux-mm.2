Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F9CC9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 01:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7756B008A; Fri, 25 Sep 2026 21:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE986B008C; Fri, 25 Sep 2026 21:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5436B0096; Fri, 25 Sep 2026 21:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 777436B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:08:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BF1E1C3676
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:08:27 +0000 (UTC)
X-FDA: 85254127854.22.3590E9A
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 572EF180009
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:08:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D0Tzpi8r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790384905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8o3YWWPI331T0WI+WVvTTsIk9M0avmYjoyCPD/hirYQ=;
	b=HMtjRav26UaCFbYNcEUIQffQgTaP07KT4QRzsWjnWINwKWkT3kGVx6lO5HD5I+qAEeGuDa
	O9PbU2YXLtQQFNE2UgJG8IaFw6aQqlzhfc/mqkWmv7xn6WtubwJHHGZxs6KgiiHQATs062
	qeyGfyHInZZpf6pG/e/WP4pneOOlKeA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D0Tzpi8r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790384905;
	b=PEr9H4igVXd6A/A8DPx7KVRwF/SzIQVkoD2A2bBQDYGTLLVAAUSrvgh5bNACzlkZl+acmD
	t+dIMgl/pi+bl67T1XZJrjTOwn0+u50Vfr1YBaBPM9P/Aw879aEo2OHlFOwMf+2eNYZ9n1
	HpxaUnHabQISLrLCTa2IUr+HQNA1ujQ=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccc09d65so936711a91.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790384904; x=1790989704; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8o3YWWPI331T0WI+WVvTTsIk9M0avmYjoyCPD/hirYQ=;
        b=D0Tzpi8rWpVKjlnuB7pqovyhzgDT4jU6/EYc/So7+0emnqm3KgEerbzHu6tA+gLNDI
         rq0Fb7rRwy9s9P/BmC3yavsDYchS7zyjeAliFo1YY9jUxWDr1rwAt/2WMfXtYoD1Uj+N
         lIWMp3cC/nAzyTW+2HPbMCsazNroDqnAIlkEAiVgci4hv08J/v7X/+jNBjTfuOW3JYqZ
         gSIuijG9WjfKO4IpEvc9hJBqlRsJeNN9cGYbeWiHRYzJ7QWJVHfkj3FllFfh455pvkej
         ejznQ8eC7/vvw3FqPC1v35OmdL4xHHff8IL+/Pfwj0eOmt7YFf3CW15WsfA82+WZp/WZ
         PALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790384904; x=1790989704;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8o3YWWPI331T0WI+WVvTTsIk9M0avmYjoyCPD/hirYQ=;
        b=0CGzefRiTo71keiRMbrLNT3RQNN9MwMmvtq5II3HjpRjb+uddeJWRznnK+X9Sdxg4F
         lf71s7kh5X+zefMduoTRCFGhKii0/qczfS+WizomExIZHmKu7tS+yAQ+mHWQ/7pz3bHy
         h4u9Uj+EwFhx+u4zYgc0aiHJs5gtcZ3ccdCg7ZKjTDRr1RVjpcRQOtZPC5EcacB3B7sb
         2tzWZWQrdm1UUCLvffwDtRpLhkcu1Pu/MK/Yv0ru2WIxCZD/QSyiBNBvOY8ZESvVDohj
         V//WsjpAwOEkHEI7NYWg0/pvsWD9R9GxNAuSorUvZerh/rq+J+TzXBAqZjgURdXrue52
         /S0Q==
X-Gm-Message-State: AFuF++kUpxoe58ERkDMAEF2EoMuE6G7dbEBNjWhY0E+XHn0/89L92gfY
	/17DrPoKG4bFueI7lLGPCJzFhV1YZyRwfwNmfDkhLzp+OKlDfH4h7JAr
X-Gm-Gg: AYBFou043TCN6s4COlfPdHoLCfDTarpeSYaImu4bFzKT8d58sreX2xWzpwVQkv1aGJe
	zOun+PhTSP1w4gLZHo72tmUJJqeQ0pZfJJzGK2uKzhy8aMaiJZtkP0suZoNtWOCNN+V4VcJseym
	R1SWFerxiXW5BuiZSFgYktjSmtsxTKvDnXeY9q50uRtbB7t0+rK4rctJlGo+l2SSVQ711tsNK20
	p2HF//LIWI2g/XI6Ftj+vpeVUrMmqwSVRsCEREWRh+vwNcT2PpeyTJiVbw2VsqSS+m/ZzJ7bNOc
	VLoK3eoivEr4Tc1rPfu0aT6+euuOINLKdTFxdrlfLvK7fqm8oBtcLcWwNSm5RoxrpFUK2iAZtH9
	fGCceu+BFulYGQH3NM5izMVvNuCLN1SB3W9uerwBYCZYi1Bm8uQSkZzkoVVRtas7s1rE6+lx8XL
	ow31ttNaVJkLUPdDi/e07XojTvRbZv3eUQs7OjD2OdDSsuW7lZ+it8cQwxM+5GqU9pCdBhxNfz+
	Y1wpaXqyiamGVaAJjRIootZYsTRmjGqZzmvVmyGI1ly/6p3y79ERh4UypxHgMABsVlgFdOW8Rjc
	oU9thBszXxw3zwhkoITbX6Ldpf0b7sNP6qiqrmgftNOt68r131mZo5GDUsiu
X-Received: by 2002:a17:90b:2604:b0:3a0:d9ee:a2e9 with SMTP id 98e67ed59e1d1-3a0d9eeb955mr765639a91.45.1790384904050;
        Fri, 25 Sep 2026 18:08:24 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9356f48sm7032117a91.6.2026.09.25.18.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 18:08:23 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 5950016C9C94; Sat, 26 Sep 2026 10:08:21 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v3 0/3] support kselftest on nommu platform
Date: Sat, 26 Sep 2026 10:08:16 +0900
Message-ID: <20260926010819.604346-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4r9976xmeyz5smmuzdszpdc6znhkmq6u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 572EF180009
X-HE-Tag: 1790384905-553161
X-HE-Meta: U2FsdGVkX19JaUBn+d2kiVT7uLfdJ4HqV8827MrDVQf4/b+NPrlnwT2V9fJ+qR25hRmDzTnecUF1ay3Ht9LJzrF91NRYjCZtZqiqpet3FXx9bntmXfu1ybb4rID20wlWr3ffUgruXJ5TS6lVStsmVSCyP7eK1aKLBm3LRlLQEvgchwN4izakpHEobGFZrlCsgX3Y2E0/s82BwoI57RdxTS+t3Aij3gbgnP9au1wWr4Iv3GEg+lJl1PFTI5rA7V8AgdxuOff38QQMfN2DzaylTDNiwfUqIm1QAtD19F0ViLOruhPFEXwcafE+c1THV0BqMQNRsbjUyFLfi04Cg8uAYM8MocULax1fGEtdSuHExJhDkjxz/kWoqFzznwmW+sd65ORkrJU14xcGCkepem0jWjEJFuHo2W+7aO9k/CPPkH+hE3VcAYdJX/Xyska7k09B/7/jEUeu0RvbEaA/Xh/UcfcCA91fYxQTPUJWOSIOjYzRWgAU/Hllu5DsNa18KocSG6fL+8y4WR2yU8B5fEadR2iplee60OAJ9NMQ4Z67dyhFkt+z7SjyqMlW4OASTU9M7HQzlW0jWBaeUkGtRWjDSMQN33QQ8hTVg7tarfqK8dqe9yiEQy2CcEHg+z0JOc/qTCBZjtzrQ38os8EP/r//DM9DYgJ3+mOhNyhHUybcmW0BzhcaRHv06rwgeb5FylG6Wmf/KbNfnkhkAS/2mqNkfh2bKJ52bfvniLo7TwIkDl2M79tKeCVGGL5KvYZ+DJoFgwjndbjX6dT5tVhhEiHxsmzzPBO2eHi+MF1rqKq8nqys3NAzqxpQ74k2XmDDLXO+LBfmkyvkx3YMD/SIw7QDuYE48xsV/PGKX0UwG4zGvi8/Lenq6x/W1/Q53Qou1CdJ8qRpyMa+MDnGEWb1K9WGb5g7P92MNxhQSca7YP/6Ci63iE0JUHGoNNvfvrDXwTc9JicAkDZYNLJjmGPg5jO
 dgmBurGz
 WjXOs3tcljK7MpoHQZwwWkUvSLHmEWblCwNcSSQKKnA5f5I6wqf2u9ffEiAClJv4APwwF1kl7DnsXoTyq7LHaNj+WNYdn3TrdEhyMC2RJ9a/WrGHzBhoWh0oiH9SN3WrZRhKx5l5t/jTLMsmBA4kppZcVq5vUGkewV1S2/drbWVzNHH3kpE1c4mXg0CRoYEmeNgUW2lSTtomjagR2py83AU4i25WdUJ27X7llyUl5M6zhxI6yEFojRhMBuhUpwAaKdSsSliG3vFu2ydxDxC6Ks4ocpzMePEt6yISxqMKEMhhdx3F7Bx9xMsl0q45gs2XMcarZOgBQYUD8pYk8BzzxTCvMbeFqinST0Vwe4fJQ2sUHj5zcTHfFbaCcS4aFCGZonIQpfIpp0whlCcgIR3SECKTaY8WirKLZWOjsBy869UAgyGr+cIOOjCdCRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds an ability to execute kselftest on nommu platforms.

Currently there are several issues if we wish to run kselftests on nommu
targets:

- it cannot compile/build test binaries because the current files mainly
  assume to build with glibc,
- some of the tests are not able to run on nommu targets as there are no
  fork(2) syscall.

The first issue can be avoided if we can build static PIE binaries (if
targets support it), but in our case (build on ubuntu/glibc and run on
alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
mechanism.  Thus, we need to cross-compile with musl toolchain, which
needs to be solved the first issue.

The second issue is the lack of fork(2) syscall on those platforms.
Especially the test harness helper (kselftest_harness.h) uses the
syscall, which cannot be simply with vfork(2).  `timeout` command used
in `runner.sh` never works for nommu platform as it uses fork(2).

nommu component in the mm subsystem has several known issues and having
test cases should help this situation, thus this patchset is very first
step toward enriching test environment which has not been well tested
for a while.  The test cases is implemented based on the document
(Documentation/admin-guide/mm/nommu-mmap.rst).

Initial shape for this patches is implemented as an opt-in TARGET, not
built/invoked automatically if users don't specify this nommu target.

- v2:
https://lore.kernel.org/linux-mm/20260825015945.141739-1-thehajime@gmail.com/
- rfc:
https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/

Hajime Tazaki (3):
  selftests: kselftest: avoid cd - in runner
  selftests: run tests on nommu architecture
  selftests/nommu: add nommu mmap and mremap behavior tests

 Documentation/dev-tools/kselftest.rst         |  14 +
 tools/testing/selftests/kselftest/runner.sh   |   9 +-
 tools/testing/selftests/nommu/Makefile        |   8 +
 tools/testing/selftests/nommu/local.mk        |   7 +
 .../testing/selftests/nommu/nommu_mmap_test.c | 258 +++++++++++++
 .../selftests/nommu/nommu_mremap_test.c       | 362 ++++++++++++++++++
 6 files changed, 656 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/nommu/Makefile
 create mode 100644 tools/testing/selftests/nommu/local.mk
 create mode 100644 tools/testing/selftests/nommu/nommu_mmap_test.c
 create mode 100644 tools/testing/selftests/nommu/nommu_mremap_test.c


base-commit: e8d0f6a1b2a447d02845984fa6288787543cb03c
-- 
2.43.0


