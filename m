Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5BCC5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 01:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50BE6B0096; Mon, 24 Aug 2026 21:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28AF6B0099; Mon, 24 Aug 2026 21:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65916B009B; Mon, 24 Aug 2026 21:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF28D6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:59:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38A881A0269
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:59:56 +0000 (UTC)
X-FDA: 85138135992.10.A886F3E
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C66640003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:59:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HSqR0OuZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787623194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nhHoz17uhzvTdXS0vYq6oOhZqGXYkYOkqCoUJ92OGtQ=;
	b=jDJyxIe6nUzsZ1zbB7sUuvX0ectIkSXuLC7OHMNiyI0pw4whEAQ8BlB7y7A2bsTlZ4Q8Bv
	DdAuBsJDJB/7d79VfvsI9qCfGu23WKQbgzcY/1HY0QBkOx+X7gCthaSgAEaGw5UprL+Q2n
	NnVIq/7NZHNOadZefdz9lRihEgx5rWw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HSqR0OuZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787623194;
	b=pEuyCfANNUSXpwHdvs6ZWmzXi4xLVgc6/8Zzgfr/kzXOfdApd3BhuMCwGCwiNoBLPAZl5L
	d7EeINNtYk1YFVeNnqpjzHxZaD0isyRrbDVEaVTF8GVI8ZP1y9t5SNyFrENOl7hZjbuQ47
	oi73oKHr2nN17w+l5QaXumswmp829oI=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d01663d816so34106865ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787623193; x=1788227993; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nhHoz17uhzvTdXS0vYq6oOhZqGXYkYOkqCoUJ92OGtQ=;
        b=HSqR0OuZ4LhmzQTTOn3QKj5gnNxqhOQZFScqPgALma3S5B4+3xDtPAjHzKid+q3ChO
         d585grO9jH6J1Bn0h1/00CXbo632wgdPCyPTYCIlTG08nHQXEJaV55pfdH1aEwhfx9Xz
         CI8hln2ercqMOpGWyPjzz/sve10S+/VTyyyYjwAzHypMs5/cG6Me1aktnzv3zFy98jw+
         2+S/qNoLBvjGaL0OfZI3cpqVLkzUjsC02Bq4Akb4pGmgHFStsV/RSYtGN+8QTn8rIgWn
         Sq8+m1gGGIYsVDPAUoz9CIjeHXLI0Q7M7R78xhuF4SNZ6Z2acD6le2ytDnMzApEJBt+b
         kQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787623193; x=1788227993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nhHoz17uhzvTdXS0vYq6oOhZqGXYkYOkqCoUJ92OGtQ=;
        b=jTqFkBrJvHsIc+Xcl7vrNO57zEPt9gD+6RB0gwntwNQmfjtX1YM6+kTvZ9yG4kwXDC
         sra69ntxuK9ewMK6wfvvB9JLhxLnSL8CBOynd7H3/ehCL0/O3ten3T+0BbRHSY6sskmR
         IhR4TUWQ2oqw99OUDSqtoZ97IA+TOoV/IuayRBhA64INPHh4vsaBD9w2dhrETxLH0N9l
         M0/LMIgxsrLWM0aZyb2arOsxFZLHEckBTSpdpHaht3VgL98JJW8HixgJ6EaFCyvMe1vc
         tELFaCxo81oLJgO/HivUqdrPAeFudQ+Zb315iXlo7kRBrPWze+4U6S8WI/IDioGQxTsO
         zdow==
X-Gm-Message-State: AFuF++n/KqK8Bn230R4M/hcwJQ0MuQhXRfeOVlDfClpsLgJf5UgVOeCH
	ZQs4btijJPSKW22KMYQ7pB4ZyBaNy3aIWD1nSrhUsO5DZP0n8H9okm8T
X-Gm-Gg: AR+sD107MwPJpgLc+gCa0G+YIpirMCNnQIXAXl4Ew3xq/wZNZQFSE4/nMzYrcIMfV8r
	fBBHVq2y4mqjcfqZW3BtFgsznUckog47M4UmW5hZvpCKlvvCmKzqR2I/L+tIFZF02ugwd1A4R0o
	RVKg2BfU9THsgMKUWfnnQQgvuIJvAIcD+xkuAJMiu4bnf/EPzHjiPoWkYgF1i6DWcL+Pda7Ip9X
	S0CRMscSLIClLC2DZ5i3gmB64Mr5hRgy5XuY1u8MvkgkzVf9yAPOLuwWfiQVqSFWxKYF06RC7rr
	Ve/hbGjx03lkwXbSuQh9nvU/5aDrzBVF4zwxkcqzGeVP5m6eZ2rOpvFN8nHs6g5Kv/u4kL9dtEM
	z0M1H1NCHi+8J3lvM5bKTJBMTZnXXRnriSkismgJPinMgB0eHTtWaZd/AS7W6SzS/fwOYdtlDw8
	5zZz954rgAKZ+kVOgM3vpcfAH2oUgJZVjGg5VuMknglRIACyFgxHTRIqmkShOY36nfp+HRqyMC9
	nHRg0OzHTaZ+FlPEPhi+gzhbQI7fgYal1tqDQlyZIxYHWP2TFae0vbiGwiaWAYHBvLA5UcLzOYu
X-Received: by 2002:a17:90b:590b:b0:383:f52b:d616 with SMTP id 98e67ed59e1d1-396464ce7c7mr6288216a91.10.1787623193305;
        Mon, 24 Aug 2026 18:59:53 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645b17eeasm1704829a91.3.2026.08.24.18.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 18:59:52 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 7A77515C677A; Tue, 25 Aug 2026 10:59:50 +0900 (JST)
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
Subject: [PATCH v2 0/2] support kselftest on nommu platform
Date: Tue, 25 Aug 2026 10:59:43 +0900
Message-ID: <20260825015945.141739-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C66640003
X-Stat-Signature: h3m9q3geuexfp45zm4mmqdpyh8zxw9hy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787623194-215358
X-HE-Meta: U2FsdGVkX1/cBdoI+ZreLxXlVo+BZk1GQqIL76xjLHLhEu8PhnT20XZMwxwj4jOw4Svq4KkFES5s8w5QRDjpL0fXusgIyIpjRY65T55O8nud67aazytq+4xU5dxXe1ulQ5dYMltFP1wPifNyhA3a8VxrsMl3AHiMJ6dRD/Srp9J1xrlpi/ZOkp5cNg329L8n5Zr4/Oj3bjq3yHZvWtCKePDK6N0A/S0zGScNlre3+LiBBlj3SLIoXOiLbW2YjRbPH1/UMTuP/iq8RwkqZ+QUWRCsdP5VzLbRZDEfpNqpSqnQ88iw3e7o6RjmLYiB3lhVzGErmqIjjJpGmul72mgSffForvY95IaDaEuuwmdLcV10xTuR+skYVfFORp7QxsGI2/ldLhBSzrnFeOmgjECxYHOcwkUZnkouX5GJhBF7yxdwjZenq0zzb6tFbGQ5/qbyhpVo7gm/FcSFS560ecHfCWCFnFXfHowrpqw9t1w2OlgvK2wUQio4sZk6WeR7gKAP8q3qpOymbs8vkq58IBPcjQLlfWOvPbO1FLvF0HcmAAPkvaInoCCmSdnDtAblyrKH08ht7FRGx/o2HHSYsReYaQ+Fbuc5ooXCSLgdtsozS5WU2FUCwuyI2yY73aWzAxzLOSj97cCbCRr+PUPjwZQqKs0Vz9bh8a0aDlffaBxoL9oL4WFxDUjhPDHseL4XGHtxUMnRsc9cF6WXOAB5F44dUKiVZ3uubFYXPzBOO27cHZ+SBJ2AbV85znHizSLvEsUW0EliwOkZDr4re88LM4khXifCOgCEMbSq98C4z3rYtXImw+WZL2ASJVHqx5eFeLx6nxRm1IMbUSkHPr4j+YqHN37N4brLRSCOc9H3u6XXeMcNI+RG+3IDqaW/1f9N7Wba8x7LTg4VJskZ5gxeB2GKOA58Its/7Qf5zwp71sK9msOU+n/FmPPrXsFb7gkF7Ke48v9UGocQ4S1S/2WJRQd
 wafqXbw5
 072iNUPzUzyQrxLLjwaXu31jW/HTWMBLoI1Gjzi0GUpgJ7o/IyDGxYPNLZSf7zgVsWZeZV8hC81uvmnf1sQoh9xFcAN8XSiY5J55fGDSCzlvH1ewSsztdhnfxr52/gfes/SNst5QFuSaaGbCx2PXTZ/EbVunDwG6jNRudXPrkrteNO8jme0nS/6XLFEb3oc6WNAdqVo8tR/Y5ENyAtU0dWzJaeg7mUIPhPROFjRclsHNBexbyAAVo807MbZ0bU/RS7gqy6PmTskL8MxRL9VeS+/FN/NsqIEzhp3GRrEzKRvVwh5k9jYaCpj9nYdTQDdtyhb1423CjLq/gSV/eq0hY/ZtiNBIFo2oq1XufH4gdeI9apTpu9j2O+apD227xpqP4UOvyhkeHcnWMZ4paOCQZcPC+e3jPyt2P2Wh1oe6chLCX4GS2/WxKJ5/zfecm4650imSc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We add an ability to execute kselftest on nommu platforms.

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

So, for the first step, nommu targets only support low-level API of
kselftests (kselftest.h), and implement tests in a new target,
TARGETS=mm/nommu.  Other targets are currently not even able to build
due to toolchain issues but will be addressed once the initial
introduction which mainly focuses on nommu test will be settled.

The patch was initially combined with other patches but is decoupled to
only focus on test framework and testcases.

- rfc:
https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/

Hajime Tazaki (2):
  selftests: run tests on nommu architecture
  selftests/mm: add nommu mmap and mremap behavior tests

 Documentation/dev-tools/kselftest.rst         |  14 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/kselftest/runner.sh   |   9 +-
 tools/testing/selftests/kselftest_harness.h   |   4 +
 tools/testing/selftests/lib.mk                |   8 +
 tools/testing/selftests/mm/nommu/Makefile     |   7 +
 .../selftests/mm/nommu/nommu_mmap_test.c      | 265 +++++++++++++
 .../selftests/mm/nommu/nommu_mremap_test.c    | 353 ++++++++++++++++++
 8 files changed, 659 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/mm/nommu/Makefile
 create mode 100644 tools/testing/selftests/mm/nommu/nommu_mmap_test.c
 create mode 100644 tools/testing/selftests/mm/nommu/nommu_mremap_test.c


base-commit: 55b50d965aee5f66cefe4dde3907a0e272f96b91
-- 
2.43.0


