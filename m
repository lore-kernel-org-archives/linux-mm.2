Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E007CA5FAD
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 23:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D506B0088; Tue, 29 Sep 2026 19:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027AC6B008A; Tue, 29 Sep 2026 19:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58E46B008C; Tue, 29 Sep 2026 19:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B783E6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:57:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39995A05D1
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:57:18 +0000 (UTC)
X-FDA: 85268463756.01.EEF9BDA
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A7C11A0003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:57:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ig4DG9Md;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790726236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=d2OlJ3pOFLYukF5tQBlnlNk14VTvFLw29xsc+/lj80E=;
	b=m0zdIEHPj6on+RgPcpQO2ppbqK5K87I/Ea/PG5CndElBwZXFL3WBQt/aAJ86mQehGnMNJt
	oMvGa32Oswo+bbTi/AJjVx3mN7bzvoOhX3iuCNlhw70Q8VdsjRp5PJyUZWemsstNPPSq6s
	x64SCBJXalHtr/L/wX0j/viMrayFxqo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ig4DG9Md;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790726236;
	b=E0DhaTIv0QuvEYnVA6ufgLhITc9mTwKnrVO2NjWZSvLEIvz6hq910ECwr4TUSFsHYYs0Xf
	NA7MciNeUXHuTuifJLreWRqJj4G0ABTGefIbmQwAEbFIruvdyuvXdnWwMQ76LiSVaFTDSA
	QveY0ksIN5HtAD2vIP/Tk6yPgAG6PVg=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so2593164a91.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790726235; x=1791331035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d2OlJ3pOFLYukF5tQBlnlNk14VTvFLw29xsc+/lj80E=;
        b=ig4DG9Md8B0vCY6yTpJCZ5Yhiu3NNmt4nkmYhT7Dk2Cv603WxIr9QaMVoiTe4ibY/N
         DJpcXj9Sofccbs5mM4sH+QcU8dnx4Q8jOx6Os57624XZCVbYbGk3DyvW6F8eq0whZID2
         Djc8ulA5UZIJkWAlhVtpLrdGRP4k4UEnoejwLWEpYXOrPCyLNprUSpv8KgYAKZGp6M4g
         WJT2P00IIrle+LlTN1kACrlP0WSawAIGtcnVvR5yuO6s7HzeWNbuIhWiT+OxxX5cMOJj
         Y2301anJL37zFSZD6tsXFlgOT/JPwnJECi1qx826wCcDBFR7kjzUdAnyhkcW9BqEMDZj
         1J8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790726235; x=1791331035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d2OlJ3pOFLYukF5tQBlnlNk14VTvFLw29xsc+/lj80E=;
        b=dK8y9RKuOf94kQ1b+KFQ/Rl2nSRWm4qTbvf1YjMvykSi+zVeWO4gXh8+M8Q0lGYEdv
         QeaNhsW9ILYBjsOKfjir5SFpxIgxUrvetAJLWzWqvvAwgLit2Vtf6dZvyCk6r/wTar0S
         Ckrs7tudPEurAg0Lq067dopYBD1Gx3TVPmId1ssGwTjfwCIBfKKy6wrmhjVx1FHw1q2F
         z7FBT4lKj8irLkhE79TEXJQ3IDPht0A6HkqvI2tccEsodJUlC1bDCx+P5om86bN3LEMs
         hRKM+QiISfetu/U7ZAu6xoHOm+hQob9XZv6yhOnSFA4fjJppk4XG8BrnIJMtxQw8ZmaL
         RLGw==
X-Gm-Message-State: AFq9FYI2baYgbQXy3mVoYxI4JZYnNLbRNi/9wfiwtvTXM8AeqKMwRYRC
	elubkiqf47CZRjyqUfNZwTqa+UNDlzOb2Jxi76Bf8BO0hMqUex3QmE08
X-Gm-Gg: AYBFou2rmV7DZaRLSi/oSccOoeg0iUUj5RaPY8iNDWuPmTL4yt7vvxYfyXjj3TPDI2W
	AfDcjXp9v7OQA+NDfTLgHLGkTjjiMFzk1qZp5gFbsMoAZqbUhjJnbveLA3o8UyTnKNGJvM855eH
	5FygXSXiCVkJQLAXgKNQCdXBGZpZ+ndB3KR/CUqqpMf3TMMMroF4HV3xxOyA0x+y7ijl51J4xMZ
	VC4q0NzKrVTkgLIk0vr4F5T+dGEnQoAinLNjV1N5xm0v4eHeAQwWxnDaLyV6Q8h5vXOG9y3NijW
	bSoQnu5Dy4w7xS8D+O771f07gSeu95uewvMRfCBxKGeBobCDDLvALsK/8djGP+oCpGBKZ6+DppL
	l1ZIzfUZRnU/7db9EaA8b5MP+vKdU64YQIh4zJo7/SvRWvH8PVE4a9e2k4LhiOLbX0SUMdpB+xN
	AD3c07I+F98z97SItzATMHmYS0BpQSqvzbclaB7Bnnbtf+qCgIOmKSgCscJEPcEtWuzere1nTLZ
	K0Oan3Hf9WsZZ84i7UKl38P0yD6ZDJamj/9RuTk8npeBsXapfprJvZXF4NV8WhVrnFwhv1o8wJe
	ofjKYMvlaufXjXzv8/zpGr4CElWWyXW/WHn/3srC4qb0mFBKLI6R7eAVueuG
X-Received: by 2002:a17:90b:1b03:b0:3a4:b50a:1113 with SMTP id 98e67ed59e1d1-3a4bfe8a0e8mr825389a91.37.1790726235201;
        Tue, 29 Sep 2026 16:57:15 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4ca78102csm242607a91.4.2026.09.29.16.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:57:14 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 2360016DC6A0; Wed, 30 Sep 2026 08:57:13 +0900 (JST)
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
Subject: [PATCH v4 0/2] support kselftest on nommu platform
Date: Wed, 30 Sep 2026 08:57:09 +0900
Message-ID: <20260929235711.2287931-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A7C11A0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cawhcd1esici9n47g537ayixf3cz4of1
X-HE-Tag: 1790726236-969117
X-HE-Meta: U2FsdGVkX1936xyIpWBCT9p6uFLnmuwoEUAF0tiZLkXG/DrnW7wbQvkimdBasgU+qHSLBzAR1wzCpLzRz0f6QyLK50gUjYRgJJqu2uQR/I5A7BI3I5/+5uHmp50prmyA4cN7GqjuF0fRmycLzOPHiRkVeFnn+3WXRF6Fczidw0GTn2zcOezyp4nyz4+E7cQKrkL/n/LwRqSRzVop7+TlhxH/9MMrEieAW7Ls12Eklrca0CaA+aXRQ1ODeerRHjLNh/ebXtNIeEce+POrp3Ok25oUC9O7xFfPuBVwcJwmeYoJWc6TdTpsZHRjLf/4wdqrjpUpoEsmv339MTSlPoCHFbnRM5csF9PuhrUgVFpIOV0iEAr+UnuIyk1rafTJHq6kbEStZJ9vLHf1DPdUCH9HbmTQDrVlYoGpteKbs/yHVmRbx2P4pT+EfL00T5GsWr0wlMbhn4zI6U9X2Ewa7Z2Q4QVpD4TdxrH0FvgMZHMeOV74Sw5y8Yw1xoaqPr2tQm+zHEgoyici+s3KPAR0gC1UQfy5z4JptN+cQSaZUNrnt1kkAZoKcptbXpTffiGxVnw/gVyq0h5raJSw42HLXDJsBPeBES9duW/r7H3vBxp4ZkZ+r3D1ZkS8vKhcAmFzolsR1UQm8vezsQ+9SXtJ1MqEFtwruPao3BnFbBaMHSFidhZV6TsiwqLasq7Olc4hnj/hswKpmtGaZ86RNPSYsvXxiXjIhjUAFvyCH0V0K5fY77bCAzNDV+zaWIGnv+PYYi8u3fe0svar2zxGJDbDVV1OUlOVLlKajLdOSSV1PtJPc4dNaqd7wghpul1cdvmLEKh9pt19d+KshOpajkp9ljmOeVagARo06dwoNNqZpzYRloTz83mkp/fzPRCGnYV87f7vrfg0aQ8gajMzROVMl9H4hAihg3z7ktQECjnN/e5svGWMomtT6mZTiTFQNy6Ynz4GDBCO4Zxz313ZauqV3Pr
 6GMQLiwm
 xVF/2lFCqFikgQ3x3ZUjsuwZsd4E7SZjiN0dlSUtJYeprvAnZJGal1sbhJlo9My5wBY6UAR5A2+P7S6rmGb+z0FcsWMzAkUF9RBZoo3ybJAYi576f8Ghn35B7gGTpbj6b6DBIGMk2scQSsiZDxrBq/kEWzWvREVo+24rDj0pUmCESYlauJl12Yp05VezmgOK/zvxmlOzRKqHRuMOXwBb+zPvEVK6IA696qpcZzsQbZY0D8TxdLAY4/qR8NOkXIHBllTc62Enj+9jt1+5bzChCrZf5h0Kq8Ngdc2l8acIuroglKsKuoSRc8jBH7TLeq5Oin9uToU3+8US9NtoEu5jRmSSrFg5lQlYmDLzx/B3vLekuyI1YRxi/Wwk+3CPmGmokIqoWa2/rRWX8GZaydQvg+Gj1MpGh353IEjaUP6fd/HtTCg3HLny/DxVJwA==
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

- v3:
https://lore.kernel.org/linux-mm/20260926010819.604346-1-thehajime@gmail.com/
- v2:
https://lore.kernel.org/linux-mm/20260825015945.141739-1-thehajime@gmail.com/
- rfc:
https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/

Hajime Tazaki (2):
  selftests: run tests on nommu architecture
  selftests/nommu: add nommu mmap and mremap behavior tests

 Documentation/dev-tools/kselftest.rst         |  14 +
 tools/testing/selftests/kselftest/runner.sh   |   6 +-
 tools/testing/selftests/nommu/Makefile        |   8 +
 tools/testing/selftests/nommu/local.mk        |   7 +
 .../testing/selftests/nommu/nommu_mmap_test.c | 261 +++++++++++++
 .../selftests/nommu/nommu_mremap_test.c       | 366 ++++++++++++++++++
 6 files changed, 661 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/nommu/Makefile
 create mode 100644 tools/testing/selftests/nommu/local.mk
 create mode 100644 tools/testing/selftests/nommu/nommu_mmap_test.c
 create mode 100644 tools/testing/selftests/nommu/nommu_mremap_test.c


base-commit: e8d0f6a1b2a447d02845984fa6288787543cb03c
-- 
2.43.0


