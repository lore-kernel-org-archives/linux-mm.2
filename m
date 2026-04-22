Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D88BF94CDC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9EE46B008C; Wed, 22 Apr 2026 04:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50046B0092; Wed, 22 Apr 2026 04:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C657F6B0093; Wed, 22 Apr 2026 04:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B76E76B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:05:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C61CC9608
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:05:09 +0000 (UTC)
X-FDA: 84685456338.01.FE98730
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 88FAD80005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:05:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XXLVkWLD;
	spf=pass (imf02.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgOoLeHSNRmJRchPxzuYzxkblk+pRJMxNj39oO1u7rM=;
	b=xp3tRDBXvo1jwkd6qfX6pV0egJLq/Md3JEn0Ta4oacJBpPdfR2x+KM5o6ZVYg+YMyDESbZ
	l61FCthO9j6JEGSfHHdrzFk+b8ITWqEgJy9AJY0z0U4bYPMypmhczUHfb5k/8G3my2xsBw
	GvukNoUgWM80Ev6BOQ8Qyv/S5AfQA9A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XXLVkWLD;
	spf=pass (imf02.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845107; a=rsa-sha256;
	cv=none;
	b=a04wsgpSeflg+nTBOgKSg4ruhAjn+WsUrsNLhT7jz67h2J7bZpBkP3+DNUzp6sWlyvcd28
	MhvyaXkf+BKP2xT5fUnvZSX8xPbKPpAsb8VCRkrrUQlYjJ7W7XlWbXatsO8+Qq8lvfUKU0
	Wmza7UkHchvckLVYf5dTlisG0xysH/w=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3590042fa8eso4064262a91.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776845106; x=1777449906; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EgOoLeHSNRmJRchPxzuYzxkblk+pRJMxNj39oO1u7rM=;
        b=XXLVkWLDofXVYqPojNyl9MVhuE9Qsh2Pr12EIBWXYDgOTD1x0kIC2B00oqz/XWi/sK
         SnXPpzeqx2uu/MJuGwNXLlQBMWkEHmaFhm2cAMwA5JBwhlM0Tqwh0zvq2TvZQ5By0Ye2
         dJl4+oGL5vLJPcIE/9ufSEIhzDy+5RwdQvZxeFmGpSVmDhveQOqm4S70a339XQamjHh+
         cBt5dRMlGzzYogyprQH3H9IuSffhAQmaANg4cKc7DoDg/HA5f9JV5LT2WM2MgB1gV0Fr
         nv/4cebfQTwj0VbvSyf/sMWCvDmz8TJ56g5SeUxp0jZPlL1Fqgq9Wt0/iv4nQWCjDgDE
         RoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845106; x=1777449906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EgOoLeHSNRmJRchPxzuYzxkblk+pRJMxNj39oO1u7rM=;
        b=Ku+BgEeRVnzN6ZWh9Kh3Fy7Libi+5Fd/gHHaRAnPE+9PUdtJh/9v+x1zR+XoAUKO8O
         O8OkWWOCC/GZBDOP94xjppkwAvBU9+1qWGP4PZNgi6fbBp5/JAcnEhwqerKTLqFPXMOg
         cQuexe9rhyqWQyXZwLkFGi+qvz4bSwYsNCz61dD/CZ4T6idkc3qNPtruIA9dWknILk1/
         kDmRihV3fpF7ccKmU1z52rVQK1n6rNn3rGpiOUD6JzX1L4swNuOabv4f1E5Gvjv0bq5a
         4z4CMwB1MCLXmhC01lakQcc9tok+VqmZ7fHktkWNqLNPXp4dVmbO+Iga5E9uUBLfUEhP
         H8rQ==
X-Gm-Message-State: AOJu0Ywl7TmyLZ7uBa4WQLp4xVLtEG43H4izTvpkN5cYae3G2ce+nGZE
	t1esynVL2nZVcQoJMZ4VnEq8Am8kUymCd2KJijDbPabABueJD0FLUXE=
X-Gm-Gg: AeBDieuwTns0ODK1NxtywjgyJUtHTOwGuZNM+YCwDeMJsxTNvOKKoDFeQ1NueHwvlL+
	Ntdl8/1z3Wxi1Y2ZGvQF6SZYKJbqk0zA37UNJAe0/+ueKglynyTajhjDQeVJV/qrt/aq6QtgyTM
	h/Wk2SkfnCRP8auGjLS3GcizQYW9Uim6mpKWLRlGQkYXt03pw8ycwzIh4gerAELsriGhV7iK2Zb
	x2w5HTgkbnRgR8q6RWZT/pXNLVASmTMU89+zVIBZ9x8Wp13ktGyo9t5JHnIXgkvgSU9lKYPIibs
	8Puf32o0IntaIXEJXDTbhIevLFAPsX1B4JPx8tdlLO8PzM9tVFQLfaOC/Iq2AlMWMIweAFamyv5
	gOy8NdT17ZYRYdBUBHMDNlJH5cKrGd5/t6ff9ApWzd05wTBy9QlIxfTbhKIlObGioakxbnXWXK6
	Vlfobl6dYL/NHdPNRPs7TKbdXya3UiBpwt
X-Received: by 2002:a17:90b:35d2:b0:35f:bbc0:e570 with SMTP id 98e67ed59e1d1-36140228e16mr22584055a91.0.1776845106396;
        Wed, 22 Apr 2026 01:05:06 -0700 (PDT)
Received: from thoundrobot ([43.154.64.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fb9b121sm8508494a91.5.2026.04.22.01.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:05:05 -0700 (PDT)
From: Li Wang <wangli.ahau@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] selftests/mm: suppress compiler error in liburing check
Date: Wed, 22 Apr 2026 16:04:46 +0800
Message-ID: <20260422080446.26020-3-wangli.ahau@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260422080446.26020-1-wangli.ahau@gmail.com>
References: <20260422080446.26020-1-wangli.ahau@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ftqn5j1o484arqba7ej8mkrdouhm5of1
X-Rspamd-Queue-Id: 88FAD80005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776845107-880389
X-HE-Meta: U2FsdGVkX19WTdw9E5UY5QCrSMmCmMSNY9KDajzoBNLJXq+lu6V1pjGVEABIQ1HhJkzRIT4x2GvP5bLmBUmsGmH1vMvWta4L0WhQdIKQsilvCMYvhFGj6pZnqQS6GxHD0zn3CZeUagxsJanoQ5HF/EEOJSyo4Cy675WGxvmSqUhIcSTUCvAQ7jOU0zEO0Z0jnr73PBYoc9u30SEM00NbGWVKIVokyf7LaJDP56xkYGTjvDPmHiOU9OZrBlETgR3qB8aBjabpQ4b45kx0+yPp6sxi/XaONhjSZiCMrdUQxkergp7idSqPRRm9FsFXA5iciaWM/Agt1veZju4ZvvGorZZfQBjslAJMQslD/bqyCeqSfQFN5B6kRiIrzLb5T0oSwuqTHd3WRsELjqdR6Ery/+N6+9fDExi5w3OkBDHwIibuaJuc7/u1mSJDDzSX5/wYk9eysqHviWTp32OF0C3A8Xhkaa2jwtcnH5hCw6Y2f8I/XHGTY0e1hBvN6UPajY4QGGEGGG/ZKt+GJSLIv1rnxxvk1fcAHhES1+dAcE0awjfMe0hV5FOtoIet0Rb/H86AYRBhC2D05s9VAirnPSrNHb5xpklqoM44gAF4oKkTOCa0nafYXJ3Ll9dlmiGZ0aQ4REeKboVe1Q4JUqPUeEE8XqjHWuQykTwrI0vvPzpg4kQ5o645zGTkum/TVFc0eQOfCEwOTgCRip5xrv7MoTCPdhhLeXzOyMMl74OlCwEinclGkiyiBl4vOngkW+miV9jpfoQrmf9p0mTfwxwlfHes2ts9Y7HucC45vNKnfSlpOugaNuGER2cY+7v9jfTnNyr5LftwVofqvSBxlFMG9U8LSuFw7x5VNxTBHJgfGx05CCobC724XhAHzx90EaQ3dziDOQtosnuePo4ob36AL63IenteJbGDEocbSeAMM43g3e5ExiLNUejR2Bro0hft/LqLhzTBzPp7uSduhUk2xqG
 OkYz2E1z
 7LdxjlHljXPbd8vXi64pXML9Hc04jkqemf6fp04lQF/k635KRDXMtKQh7R729Eg/vuTKzeOLT1LY7eamApKF6CmPpO9FNNc15cPDJhbtMJwvF1LlhDRoYHdBnX8uzuACmA42W0UXTOpFMxbFAHNBuSSYLfAYV+AApW+GSYPs1inLg/iQi9WGsl5eI1nALfZCLtim06opQCSNLQuLY7J/MUZ3nV3KkxlF2Yw/zg2ipjQOMfMQWQo/bv+ZdD0KBsotZDe4qkt4TTVNLuuZ+Opnk4bdRYKF6K1tYr6ZkMUnRIdC9x6v3iYajn9h6BuUuQNmQgxrMH4JvDZTGg1GJIAzzDD8iXmOXthB8vC/NzVBhXaoNdF2rSHkTRsTlBbNX2CeGy8T01ndkFq+JIOJsn6vJ1ztn+aoAvHHpFPiHOO/DArOsGRG0vYkyLYnmaxoR2Aybb4jx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When building the mm selftests on a system without liburing development
headers, check_config.sh leaks a raw compiler error:

  /tmp/tmp.kIIOIqwe3n.c:2:10: fatal error: liburing.h: No such file or directory
      2 | #include <liburing.h>
        |          ^~~~~~~~~~~~

Since this is an expected failure during the configuration probe,
redirect the compiler output to /dev/null to hide it.

And the build system prints a clear warning when this occurs:

  Warning: missing liburing support. Some tests will be skipped.

Because the user is properly notified about the missing dependency, the
raw compiler error is redundant and only confuse users.

Additionally, update the Makefile to use $(Q) and $(call msg,...) for
the check_config.sh execution. This aligns the probe with standard
kbuild output formatting, providing a clean "CHK" message instead of
printing the raw command during the build.

Signed-off-by: Li Wang <wangli.ahau@gmail.com>
---
 tools/testing/selftests/mm/Makefile        | 3 ++-
 tools/testing/selftests/mm/check_config.sh | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 6195770eba6..18779045b7f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -263,7 +263,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
+	$(call msg,CHK,config,$@)
+	$(Q)CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index b84c82bbf87..32beaefe279 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -16,7 +16,7 @@ echo "#include <sys/types.h>"        > $tmpfile_c
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
-- 
2.53.0


