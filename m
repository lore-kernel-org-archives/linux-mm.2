Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F991C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 01:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9246B0096; Fri, 25 Sep 2026 21:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A596B009D; Fri, 25 Sep 2026 21:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027496B0098; Fri, 25 Sep 2026 21:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAF326B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:08:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9955D1A0794
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:08:29 +0000 (UTC)
X-FDA: 85254127938.27.857C831
Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	by imf20.hostedemail.com (Postfix) with ESMTP id D2B841C0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:08:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YNIVrFwk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of thehajime@gmail.com designates 74.125.228.39 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790384907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCkD0NEbpweweLPyYmTDv9COC7AncTDYJNFGXpSt24U=;
	b=IK3bhSgh2QvVdMrdovoG57eHj8nT4T03nuFQ8eE0xxWrHViy0vopcrBi2MsjCvBix7OvFb
	D4/dLM9L0EjZ/pnqKkiGM9DEQ3qnlRZJPETdRIE072082vC0BFLTbQipybinsIvyrwz1gx
	KtA+fw/nLeZXtomg6wqtVfLSOfw7IN0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YNIVrFwk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of thehajime@gmail.com designates 74.125.228.39 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790384907;
	b=IoNb9RrXXIb930YaOsHfqpXRSdibFz04hOjIqQYvEMq1H6b9NSTOw3+6dxW6/lL2NnXUpa
	6sWIHYxkbAoNrHZ04b9FkGDj+VSC93CrThrqwMS9uHfZOmgtRC/8CPoaoUGqAwBBVOQsTB
	lK3UX0Ty7q1nqJXO4CY9EC0l2MUwMqI=
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc7979d1deaso267751a12.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790384907; x=1790989707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nCkD0NEbpweweLPyYmTDv9COC7AncTDYJNFGXpSt24U=;
        b=YNIVrFwkjjtbArEZlc0CAMkeuiB9Jn8fsmrDyFPeoA2TMfx3/FcqssP/u9CRjfLZ8G
         XblHyzDA+lUI0Yfj05BrVTrwwuM4NpaAdklxbdOX8+Li7Ri5euyBANkuIicqGxOWC+q5
         RfWKiLmHunuwhavFX03+Z5By16WPT1iGY4TMHCh81saF0nUxfPG3ZACvVR78NZUpe0uy
         agi/cviE9JblCGO5Ebflxtvu250fqKYmdmFoqBZYNrL0XZ7J64A8Or+IGeZcpkwWZGXc
         m2pXmuFNxOdfzw2HnWRxk/RFRsPQOBcL2hh4ukpQEkIUj/a+PM86aZ26F0D8ukXnDOWZ
         l1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790384907; x=1790989707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nCkD0NEbpweweLPyYmTDv9COC7AncTDYJNFGXpSt24U=;
        b=kmzSjytBHCJlpAtp7fbzd/CAfogXBbQ3Mw3KN4X4lAJ0OJQFKZwsc/JYSZMJvLCbuN
         XRAtfWDAlsw+L9hCnfU9/ONJINT35EvrC+551cyCQkfIxjvVtHoaQTTb94cf67q/cnnM
         oHClR+HFBb5PnAJfVeB7PnkeyNTDBPzeC3eRWjRrU8szbgZ6UBZ/OxGtQbtvBpAaU0Zv
         DI054gnBQyJfnpwBoIMh2UJuI2fDvngGRjHQ0xs5hqSdplJecOasGmDC5ScHOveqJe5D
         rSaxwym/aUTJ8YZN7tuLQNy/2gEfc8o2NhGrrUjvpNZxud7vRy9K/DkS9MdaPI6Q23ks
         4CHw==
X-Gm-Message-State: AFuF++k82R5u5I0MxJRvn3+t/TZy1GC2bczPKFZwyy2UX6cFu2acdUYY
	wxIma33CjB4dr3mK76XQ6VRxdAWhhBXuEzQvN1GeOVoEnWQHQ2/z9SDK
X-Gm-Gg: AYBFou0554cgn+zSWDiGUm86drfQCaAHsxs/s10gu6YxKlqRzVlhs7P7mQvTDK5Xrvy
	l79uRpvcN0JJ0puXvV7Ej2J4gmcmJv5DkZpxWICRzZHahe9AiMiqiycqNrhqkj8KcpYYdbroNat
	ie89ILrlq2zD3aCWrybThRKt4h0PH9MoCnSRqyVeQwBGdy5khs3+hwqTgtrpqq9PKVrkySwof3s
	0E96uAQcDHVOHIfeytZPwSN9g2joFDHXPJQdxTdSSRfJlMBHt6qpEZGgpSNKyyeL4CfLqlOoMWR
	OKDq+OvVdMBVH+2h05CzMg7WZ0wpSsiu5Ux3IikYF7KbkfaCV3y3vDS9xmpUzEfLk8qA2qvFW3n
	bz3lapfiw08SdtzJ8/+OXnYuSZrrEACzcrgC0dAnCfssMZxDMX8ZfaUDhQIMAXCGwFb+lHmGIH7
	4y79NqnWvke/gZRH+nh3FKB8k7aSESSfJ6kd48YyiGcrkDSmZ1nWVeu8BCxUso6bkkgcXuPk4dd
	LMNUo8EOILGwveypuQlaz28ZW7qo/GBAdvz5rg0POVowxHvnqboTAK/IyVdyma4bPRCRY2Dk3lo
	W147lE9ejswFz1R3E3WPrYVcSZbRRyGYVV0aGU6cUuR8ET3YI9AhyERgP0EGbA==
X-Received: by 2002:a17:90b:39a6:b0:3a0:c0f0:9a96 with SMTP id 98e67ed59e1d1-3a0c0f0ab36mr2504067a91.62.1790384906461;
        Fri, 25 Sep 2026 18:08:26 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99dcd78sm7026970a91.15.2026.09.25.18.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 18:08:25 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id DFEC716C9C98; Sat, 26 Sep 2026 10:08:24 +0900 (JST)
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
Subject: [PATCH v3 2/3] selftests: run tests on nommu architecture
Date: Sat, 26 Sep 2026 10:08:18 +0900
Message-ID: <20260926010819.604346-3-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260926010819.604346-1-thehajime@gmail.com>
References: <20260926010819.604346-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ta3q8wmim5x876y11putmnxy1bfhhd81
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2B841C0002
X-HE-Tag: 1790384907-82589
X-HE-Meta: U2FsdGVkX1+J12IGGcbkJAP8xVWfEAZVRnb19zg4A0gk2f54BopSpqSVQ0ahypKLdH/zxMKHW8itShMnO2Ex0WVUV2ctyz9mOmNLOMii9Lz3FrARrDAkZP36zb4rmhrPmkjz95tGfW5magwEfYTI6ERwueHyiuwy0UWYrD/BQ3D0Y3zaxOvfTRlNjq8S4F7uZiW7T/mq6kL5evg3DMxwvxsEFlC7IGOF9IdD4uO+2U46aX7eTATkJtdsi5Bp2207D31KIe1HUPboRy8FnCk46hKGTjaBgLCsSkBdD6jqR2QDk4UpmHrhfO7YEkuHlA9jK24PBnQfPlgnQwIWWAp0rPYQKSBSnTD8EQ3IhszB3dUiMEH6tAZ8VaOoAXFCaNkDbSo7HHnETHvd0rZSo3RfmaZqF81XfrYcHTT7+FWBy7L3EmtR10puEsmNBfjJLld+hzBGkp4XlwfSiOv6h8d3gR7mPSJHYqG6tsBvraUJsVOqN08b08rTU16rxjcBptR/+o+KRkbXCitSvsJ5ARQEtW11kg1cJHdBza10zSYkRBDBeAvqiD0wv21rIY5Wr/fbXC5DiFIMAbaUrZtWx5oV2rUcOdHi3Q6lW0vVuxN9Fi7UvZ7erpTFJRpjfAtv3arsjhEHaZJ0edSruYA0JEOy38j+wPtU930ZJWrk0f5x9xqPwudyHjQ95SfHEqJMg1SwL4p6JCXcMp7kRsA9Kn+j0qU8wEntEqZ6Dq79jQ5ZzqEGTc+zQNZRbPy9REfbq8f/LickYbtsgPBe0MyZgCldEXVbROL7O/TQi/+MKWAPzAav9UQ0ZWH9zGIqUAwsDCgwSU9MZnX1x4Ehw98492ew3XywE5s0qBHQ26h2NFLoZCx209F73ixUgj2Jzf1K8KMObxC3JkrEBvHWOP7Kb6SUpQPBkJjCylRwisxk4UCi8+6ReOzbsWt+rGlxU8N2OQyqvob3xEDTZS4LOTS3vUF
 EcDgoS/B
 wChfbdXTrKbtxQqmsDRmlxD2KSB7vkUbLcDN81Fcz/be9ymoBlTA+4SgAsXeMgXRHSoo+1owQubNwa/rajAw/zL6LuW9TLn6QVVq5gJr2D/HYrf1tq+lV8rbxCQMttCI/2B0wREFMpjPvimFXbu0sKSkI4qZSO94gPfxSWHNMstf+zXNKUvMZ9vi8GEQkJwzt2buv6ztjoZyjY1liUxIEK3IHrgObUfzqbEanthXuvjPgTKFwRB3uAjb3+W2cnLOHPwuZpX/prmKHlOO/OAptHQK94SNFESkxcv67FSSP+ENBVCB+3wLOAfNSPwzWefbVg7y/HBm3kYIXlndRgnH5ir6g4SuypVwMeOAF221wAyj0GKAw2jQkI3bSf4w4h3HcmWK0igI9XPqsrPjLCEMuyC7nAatsxDnWd0gv42K5oNCf/t+cBWd1izwm+E88BWz3bjpvlu7r6jksTC9BQRhtN61w4fzuf9gruMbHEe15FZjjso9HqKMNN4O9zSjRFGkW3i7ioNLt/0YmlLCrQdDlMPNtVBGPClIa3VAOkFbVuL+0UzpUzubR+TjkbRtwGsYWNiJNf/DeVrMt/fGV5xUL7QDpkMQqJYhcmm/baiNgDwcU3nQSG6yHwmSrxViYhTRbutIIkj1pNfhnBlzLGgmsmVyqjz2xgOAiPHjGch369BhLiPiAsR6rd531o4T7X4HVMncorggEHmNGWafKozMa6xJuRf4Bb4yFf3mwAZSEt2lC+TYMr6pTPjGd7ihFncmcFW/EfLXZneJfhsi04Vy7wY4lUO+betXK7HMkfwdSdv8i/ZAioiEcAq7xTNcBWlcfCWb7iUw3Th4roYSgfoEEwecB9AtymcWzVSNs4ag21cYJzPwZFfcEGTunFKWTXE9b4vi7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures lacks MMU doesn't support fork(2) syscall and only
vfork(2) is available with limitations.  Thus, we cannot run kselftest
on nommu architecture as is.

This commit addresses this issue with the following changes:

- on test run stage, avoid calling timeout command when NOMMU=1 variable
  added to environmental variable, since timeout command uses fork
  syscall which nommu platform doesn't support.
- describe the difference of nommu tests in the document.

So command line to build/execute tests for nommu should be like below:

 $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu
 $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
 $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
   -c nommu

Cc: Shuah Khan <shuah@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: "Ricardo B. Marliere" <rbm@suse.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-um@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

v2 => v3
- remove unnecessary modification
- new target is moved from TARGETS=mm/nommu to TARGETS=nommu
- rename CONFIG_NOMMU to NOMMU to avoid confusion to kernel config

rfc => v2
- reformat ktap header, reported by Sashiko review
- https://lore.kernel.org/linux-mm/20260825015945.141739-2-thehajime@gmail.com/

rfc: https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
---
 Documentation/dev-tools/kselftest.rst       | 14 ++++++++++++++
 tools/testing/selftests/kselftest/runner.sh |  6 +++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 64c0ec7428a2..c35b819947b7 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -230,6 +230,20 @@ section::
 
 .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
 
+Build and test on nommu target
+==============================
+
+If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use
+``NOMMU=1`` as a make variable/environment setting to tell build system to do the additional
+checks.  These nommu targets may differ in several ways, such as not supporting fork(2) or
+using musl or another libc.  Set this variable to apply the necessary build and test adjustments.
+
+::
+
+  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu  # <= build-only
+  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
+  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
+
 Contributing new tests
 ======================
 
diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index 8fc1018d6fec..95b5ebb8bbb9 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -38,8 +38,12 @@ tap_prefix()
 
 tap_timeout()
 {
+	# nommu doesn't support timeout command (missing fork(2))
+	if [ "$NOMMU" = "1" ] ; then
+		echo "timeout isn't supported for NOMMU"
+		$1
 	# Make sure tests will time out if utility is available.
-	if [ -x /usr/bin/timeout ] ; then
+	elif [ -x /usr/bin/timeout ] ; then
 		/usr/bin/timeout --foreground "$kselftest_timeout" \
 			/usr/bin/timeout "$kselftest_timeout" $1
 	else
-- 
2.43.0


