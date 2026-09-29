Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB36CA5FB3
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 23:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E3F6B008A; Tue, 29 Sep 2026 19:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5EE6B008C; Tue, 29 Sep 2026 19:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDA86B0092; Tue, 29 Sep 2026 19:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9D706B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:57:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32097C05D9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:57:19 +0000 (UTC)
X-FDA: 85268463798.26.663C80A
Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5606EA0007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:57:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Amq3UhQO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790726237;
	b=Uz8XQX7mBtkeeP0MWbk8QBfd0PXi95IG737AZm55CmNW3ASRm7U03fZk6Zg7SRbyCl7JlY
	PC7Oav0uCBtw32IeDIsuPC5eRAMQzS6QDPz6PRiZyh3YKf3hBIgDIBNIPr2V/4yQ6Ysouz
	b19S6oK7psqJ76chcZsJrZwY/wrQlEA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Amq3UhQO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790726237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFwQ7bBmiDvOjFgxrjCdqBVWt11ayQv2mN1CYnb1whI=;
	b=HgXPcnacWpuRn/+0QHhw1MEhoFVdILRxMcLVtw/Pw+eZ3uhRtDkpkKPBg5JxI4so0TJiZf
	Zctreu0YRxZu24bXc5jAWVUpi2KmQri5IHQeKlCPXfwGaIv2aVGY1pgzJSiVm7wQp3gV3K
	jEruaAnfa70MrrGM8wguiD0W1KxW8Dw=
Received: by mail-pj2-f39.google.com with SMTP id 98e67ed59e1d1-3a49896dd9dso436622a91.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790726236; x=1791331036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jFwQ7bBmiDvOjFgxrjCdqBVWt11ayQv2mN1CYnb1whI=;
        b=Amq3UhQOaBcesRA37h1M2ZP6BKiO2Qf+mLibHIBl1Zeyhp40q7IMp5/TpVujfcQgt7
         qeZ70K1uUaliMWyNK+meU+qcDQux6yl7iE4Hcu52501WJ3UwmXsGkJU8Z3chSglkkj1U
         DTvjph61DRRRV4o+BiJcqZMcT2C4TJqjbZdu7k96y5hVNI5GUm7F0xZfEHITjpBMfi80
         zuxh6K1CyB3nZYTJe3W9F0nGo57tm+c9SHvLUoPjU9ZW3ue5CSpMZ2gt65vBGe7Cqeip
         RJgDUUbjWUjwSPXyxj3cp8gEaGJauO+xVAQJbFb0jvKRyJjMyg71ueQxQ3KE7AWs/IzR
         UMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790726236; x=1791331036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jFwQ7bBmiDvOjFgxrjCdqBVWt11ayQv2mN1CYnb1whI=;
        b=i/MeZYcbPUKF40S9+ZCHv6dp5Z7hkOPBQ6cWgJBPxjSrNRiHCnyZOmK1oWOEevtovw
         khK2J/ZrMLYeAVur2E/xt1KgP3RPKLwjsxa44Wg7wavXSsJAVaILl5ke3cmtcQcT9PVj
         v7UE0vQ3JkPhcQ1fOeuknWsqMEHb3l7xqpbTZ85vhiFqaNDWirnetvQ/dEw/cTR9MJwm
         P3DWeUBWQhRUuDWnDCSjO5fi0tEP4mBNaw01W5JIPG+5wre2BMdtu4cgwnU1c/JBuZpu
         0Lv5pNvqihhnbbgZAAS0T9iIG+cVggcP2eh3n0PrwDEsw+uFbWc5fD4PhRuRhfQQSFDS
         rR2w==
X-Gm-Message-State: AFq9FYLn580kNO7vk2dF/WX6LfH0AbKSk3YykXMHMXF0EkpSSq2Omy2I
	HEhjXR8Gej/M5INYUt0SNbZrwez8iRHIwO5TRVR1EP4HObmY3lNDOwZG
X-Gm-Gg: AYBFou1URclAbrooloZcb2phd7sLj/fFefTwKkoBeM+cvQQHSKG+hIAeHJlipZQAbx4
	gZLtQCp1SYJmq2VO/GQpwV3L7yx7GVFbnsnYD5PvJsG/4dURLXiVTus9FKPZlk1Z1c9TL6d3QIm
	FeRfZjNKejLz2S+tvU6BzvyHUtJlO48qlDgjVbf6FZeH96ZT8bmCcRbLs77DywW5gxjNHtBr8XK
	xYA0AyUR6kaakZzabfP/ToZkkx0LrUz1oPGAcrgMBqwYizB6oDMXfEVvXVx63sOVlM2HZT59WiW
	gLm+lwH5HmP77Vst9mIOX2tw8EYpx8hr7q0fGfNh4VD9H9o/xAX3uP+UaJ1aLwrsLeDRFrnE9bk
	S0fm4zbiPJSKNLY+1pZnZxYRut/sdAeF/yFxSc8Gq4B7jq6+zk8xQUCZuz6SGIRluz3/WOIdLEn
	uvG7/UCyiaibtaC4MjXPCUxeWZ6i8x75QIfqFNXV3Or5MuNpMlEr//4A5ltsrhn0/uQrYQQrF9Y
	GdmZBgI13Vc23Yx1LwqHnOcf5KakyGpZkEnXvOLv7ti3/kvhGUDHig2lEtTRmsyLKt/m7tnUwcx
	TitCo+3j1FnuFNnFIWUCKOV7H0BoZl5YrbKZEKwV7i6iYS0F2KtCf6TemUh30Rk=
X-Received: by 2002:a17:90b:2604:b0:3a0:7c6c:9824 with SMTP id 98e67ed59e1d1-3a4bfe867e4mr468724a91.33.1790726236229;
        Tue, 29 Sep 2026 16:57:16 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4ca4498f1sm265230a91.11.2026.09.29.16.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:57:15 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id A488B16DC6A2; Wed, 30 Sep 2026 08:57:14 +0900 (JST)
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
Subject: [PATCH v4 1/2] selftests: run tests on nommu architecture
Date: Wed, 30 Sep 2026 08:57:10 +0900
Message-ID: <20260929235711.2287931-2-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929235711.2287931-1-thehajime@gmail.com>
References: <20260929235711.2287931-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tnsb4477tpkpmg5n4rpgawhjhd9k8pk7
X-Rspam-User: 
X-Rspamd-Queue-Id: 5606EA0007
X-HE-Tag: 1790726237-648793
X-HE-Meta: U2FsdGVkX18NVVS8hrS8EIuYttTYW+higfxFLAVerNGKQk0UPiCxpmpYJui4b/qMCC4MjQzTSXh+m7QV5BW4ZF1FVJ9MKyLgO4svEbPxlPQPT21ko1O773HLHWcUGiUqwjmSoZuTKC4HLS+H/ebY/KaOzSn40TKyAp7QMn18zxn79DrthU4+BhmrdGAO4tE5IGpaao3hnEBIMjucwRUV2ALtZrJQ8fbODTlhRy18rgJT3UqgM84zZLl8Nvk8u7eBQ7Z2oQ9wgKA4EpzPprfWK8ioNbC68Y+6N0kwof9a+DrtUNRbZwDJ6r+xJNuGPGsLRJCRV8VJi22mRowSpGGCIeRSzFJJUPnDegPF0iZP036N5UFHJ9GtCmpHRyuvkUcX947RyMrhVFwa/yUMi1E4t5BoGA5WU0cl4azBdZErHR4PuBBvLlB8B1B63WbjWPP0H+MRVl/J6iy29FTMQebA4ylaNTAPj4ZWbG2bDIreiueDtZvRxW5F2VTuO27zpcKzntw4bVJh+zUEM+E15CmlYr66lgivD0N8jxkccDjitG0Ojv20EuAX7ilPFOZ+Dqf+tmpGChoeuXGH9BOwOiGU5Dpx5DBSJ+J6gR2UckyNpHqTV+WaIm+CT7LKXmF6fp38o2/xrxc22kWm/VCAzYKlJ+aEfBeGAQ1fqF9KOK3AHvN4g8igD23mjBooIdsZ1hQWMkmxpdV/vdi1pA4u71AVQio5v6BgBr/aq5yU6QfX10WlxsQ7E69OQq8jBU8hOA89UFjv1+8wj7D6/6aF5y6q6xqaGKAZZ4hp4elDkJ3RcN+QGbcrK6HaKV6Jdo+DZiA4fGV/N3Nlz1ZlvhOZ/GRHr3qC36hktoOmQyztY+l6q715jCOoXjcfReIuUl5YOaQAHBBRtkkKadQxMrmnRPItmISW3x8Nmd4Y8/5DkT+a2/J0DVI6m/aDZNKgQmBRko6fJiqY2/my+MqDCX6j/ZO
 4wTfucdW
 KH6T5eMv/szJoWQWhFFo1drYOW7h+k/jYHv9Kf1XGK5jsPVqJlt6k0h1tgTGQoOyOjLKveNiq46LRDpSABX2Fdh730icIz99tevUs5evyDN0rqaoZ3QWER6jSFPQA7GkEfY9KHqxMLv8HOibEoUjZxlMWo7bUI3AQ6bKeEyJsw6Q2y088hReXwqIC1ubVJRflyedsCKjbWX6wzdobVSSEkj3aRSwfC2CXK4w3oLoEEwIa+OTalr2OQC8/InhAvdgSokvP8bqOCJDdCPnRVLlrMlXaQ+p9DgcStZUKJKMsCGBDJaGZboBi5/3HuA2kiLv+1m9VbDXdNTyUjQcaH6Vs6Bd1PmWskB8Fe0pUInuB86CCiQbwGjCoIqm1k+ZJdvehnm6n8oWJ7IOPZvLB35etgnI/M4p79DCPDR53eA4JcUfC+MAngupkXwIo5SWAtxLjk9GaV6bM5JOZAQB1CR5ahl38m/zTj2/tnn/2PPtWN7CNXNVNH8xp/RjRes4iss1oTXhMF1F/208Im0Tdm7vGiq8DPuqPyvgPMQjbZH8s6tLM6LEiNUxPvIRKuh/aQBC5Fpawy+RhpIdf08motShs+d+RxOzsftcQsiE2kV7GhDV+XPne6jTb0GrFcemezbgcE+u02M1jEZzXmqYhHhDkaFvlzJ4YNfQgxVh+hfuoFyDa4FqCzlfcyaEfXCTx4262YN8frlngnm2DsGZ0cPUGgdR8Gb3c3hgCaGx13Z8QcqFEKl6JFbpHLhzqk6oelj3XUGcAI+lbVrN/GkbKr3NeIhPAkZGTRMHvLkKUhVRY4GkcVqDQ0gtJFJyo7fJH6N7J91v03vHkIFQtgoIt0MLp3C9h1RkhoH0mip2Eg3NgsRyGddhsYT0SLtg6gTYefaf7EQgF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures lacking MMU don't support fork(2) syscall and only
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

v3 => v4
- fix typos in commit message

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
index 311811dc55a0..ee2c1f0403d9 100644
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


