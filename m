Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 839A1D26D7A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0BC26B008A; Fri,  9 Jan 2026 12:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB456B008C; Fri,  9 Jan 2026 12:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7536B0092; Fri,  9 Jan 2026 12:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE40E6B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:29:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6920593C6
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:29:04 +0000 (UTC)
X-FDA: 84313111008.04.C2F0C72
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0057614000F
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:29:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MV1hAfyz;
	spf=pass (imf23.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979743; a=rsa-sha256;
	cv=none;
	b=YEiMe7jj67xjhmIT+PJNm2JYlW/Gh+A9dGtOPgbhxXhh6AIcyaT+RNJykqB2njTIaQchv1
	iqo0U8pLVOFfJoKR376ZUFsAH8n1IFyWkBNfLdXBUZe7L/BS/YVDRy5U4CgHMHGMMLgXnR
	Wq9i1mz2VIhwRZgXKUkkTmxBB4Uz9ts=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MV1hAfyz;
	spf=pass (imf23.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKdaUjJqG8oeq2ClRcu/iEJwRqPBhkw6Zp5ahsqycmE=;
	b=HpxoqezVKnmg8n5bVJw7U+5CcJauXPbzcuLWp45UWiiEFVve4H3G5zoDYvDMVHOZuMsiPY
	jZaF1jVjvII+KmPSeZVPh2Hz2NgDoSlfjY70F2iV72CkF6RJyqgAdY8yAbqE0eJ5MZj0iN
	lClz6Rbn+N8L9R4jvSuOQ+EOAHvDhao=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6455a60c12bso4310272d50.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767979742; x=1768584542; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKdaUjJqG8oeq2ClRcu/iEJwRqPBhkw6Zp5ahsqycmE=;
        b=MV1hAfyz6NZc10g8/TzVqAQDgDSEHbojB1EHXkEnJ9tSe1XcysSlL8shgce+zPkduB
         I7X/RBEXRKGLJ2w634nNRAfF3hUK/gg9HYT2VG4nxna4gs2T7hdaYjYKIALDadzbUwGn
         hsZWrKFSyIcxoIwa2TOc2cGS3F6skRyXDMufOjfuEgZja0D8XBDR+QQE1RcDRuRf1dfC
         +lyBN8wkD8icT2Yk/uBtVZDDjoljsHAmIdGHbWPOb/xBR9u6+5lXaB8HC+T7EaX5Rf4q
         XSetmAKe95Wg2z25WNrmQjZZUTX9SVE49U+ODgremZCw3zLpbxrtUWtRpLzr8nXziw0f
         gN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767979742; x=1768584542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CKdaUjJqG8oeq2ClRcu/iEJwRqPBhkw6Zp5ahsqycmE=;
        b=MJULDWUoeLscBPZC2FdWIh6RTZ44qq5Wkecw+6An6NOo9BPKO8QRCDDCfj4+ovC6g9
         16F/MnIV28iPg7lAjd/8vXqJ3zsKSEedviLsjLNCICqnPvqpiLjJOSA+2HXqNnr/aYbX
         vWZK+feGcpxVtVfBcvaP6uau6Vlp2IOaZLHADo4Enrgfk6GIcCHy2NiR0TRJpsxxVV1M
         YIYcXf1VF/+CXIqQJ99vmlRQkGSzCzKKKXdukqffgBDykd7jXVPOgZZX6cAKnhxZ5Qp+
         /ncUL7b6dB2NBXGLx60bZhp6KM+Pa13Bs0eeiblKg75n4LxOaElyOzKRsx1tAMOGH6LM
         0QLg==
X-Forwarded-Encrypted: i=1; AJvYcCWXfOFOTG2F9GXKykOYsirN3ZEy4Zy3Tgoi8elj6uP4r+ytktg5cWlTWQ03vMTRxlWM6xw06acz3Q==@kvack.org
X-Gm-Message-State: AOJu0YxX16w7cYfLrRT9TlXGvRDMNdLsG3ApcOJsYxDG7pdBwzUVoHJS
	cbx6HFa7zpM2Y3mptIkDGvQm/wGnlcc4M5ak4d3z0QPoweDr1A9nl8IO
X-Gm-Gg: AY/fxX4aGzof0cHJM3oTGFHf/LNsRXNJJpFs3I0C6BmGkwDfDwImt+xXRg9w9C1G28H
	XgSsEbESipbV1TwtYUzjcpOtw/BTfUu+1YaESd1OvnKCgbl7dt9JzJHGSFnGQLvwKmE1FQIcFaT
	SixCHq//Ki2O3KCBLIDhNviKd9Z/4+pPDRDKZqpIp6UYJnOyF5dvXHUh/VqcARsaJHnMUiqY/Q7
	BypzFDDUA6Qb4+UtHdFjOoidyu5H7kBfd9Zo/5yKbIgOSzEuDr+tEw4uNlCvjbFIR2BfYPUr/t1
	XahG4QuCjkptuNyxB9bX6tqJOKrqEG0SzGLqhguwtj+8lQaA4+LvEwfUdmKMphkvZWBKcidUEKF
	Qu0I44uf7okAIBlwPtch/XisvcbdSYoPk2M1OGxAQoW8zG6AzpimrSt92cECtMRWWUEgVVIOHO1
	VWH/u2HopdjUGqgY8URIUW2Bs5941hQv3tFmsa4PJuOzWz0axtfsk0tvNtnLJ1smaQK5B+ZpHkp
	I+6gW89JWuyZg==
X-Google-Smtp-Source: AGHT+IHucay935+PHPaRqMUBculLyFxfPX0jedTkWAnBd1oYEZ+/yHB0cl9/8egf4uBxzRx82kDPfg==
X-Received: by 2002:a53:e03b:0:b0:644:6c79:62d5 with SMTP id 956f58d0204a3-64716c797b6mr7021100d50.83.1767979741960;
        Fri, 09 Jan 2026 09:29:01 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d89d607sm4721595d50.12.2026.01.09.09.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 09:29:01 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH v2] selftests/mm: run_vmtests.sh: fail if invoked from the wrong directory
Date: Sat, 10 Jan 2026 01:28:33 +0800
Message-ID: <20260109172833.2989-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108031604.12379-1-sun.jian.kdev@gmail.com>
References: <20260108031604.12379-1-sun.jian.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zsohbkwtsrjet38cq3a3s5qqjpcfrtu1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0057614000F
X-Rspam-User: 
X-HE-Tag: 1767979742-411261
X-HE-Meta: U2FsdGVkX19A425LCaG4JkylHz+YBSm4FoB2t1llctY7dwaCeSO56RyPVFGI4lKLBOQzjsv4i/OfW0b+0pmP4hYOIvDZjkAi5BLcx8g7bWjf+/7xqcQTmKO4hs4Y12QNHrwvKoTWRKqG70qu4kWSl6OFJGv8hPxfW9vsagpRRBg13VmBOlhZGA+TwVQDy/0BhJTfepr8v1+dJdLAbSlWtSqNN2LDMphoZvTcu4pYjubUBUJwG9Tmg6H9icj5JB7Y7U16dP+aBU226xUiquuEAa30qsiZ6WKxi8YWj71vw908pI2spsfnLPsCqhzu7tPur8KFBSn2bfesWFMJjRCk/eyjvTBdKRnkgiqqE5lhAW8PsZkDQduGpEzS+i9TNfS872lFd9RYvwOmKyM3fA74acIx1q5ODt3KW2Ji6/npgqIax/AfxauKiG+KSr+KviA2URTX6FiKvO2XfUeXpaIPwcLnpszG7l0FMvfzK2ybbVMnKa5RZSBS+JeHcs57DkXxllStvaC9K9RSvNsn4NRUIvkKfoBlIm8KoUHLD48zZip0OZK6NdxZMJhe2+S4MoNrbAbu+flJtrHTEbgICjO9FUm7J5ZQHRd/2GOlj+PeTGk1hgdh5RmVnD38PuJqFVWfX3nX0kFrQHftx2K7cvYFVOy4ZOeO2sgFFCRt+SYpi9sbFF402AXbSCOCWfYuSeU71Xgg3tJaSPSonMkQqh99g/SKepMUmeGZaKKYICwwB3REA+Lw3p0Gg6h3D7n3ftvFpagRdzgPZirr1S7xrhQXdRX5+pRMMc0x3d6WGQ1wV8MDCV8Uj40PVeK89PKEgM3/5dQpg0U179pixkPTKfX+nNVfujBgXawvwnn0ClZic4Yk+G4dXvWpGrBU/7bEPsLZs/UaXfU/Yu9A9h3u/yPEE7tyl9o35xrBSluFaHH9ZFqVliDN8Har1QnpWtuOb2Q9gXVVkbn7Fqe9JNLYa7q
 eaqGKd8M
 jlVhzrosDsj2pnRiDugpzfYq+ZLir8KSB+vP1Imfdk29kuzKM8qcE6AHv+/IbnNDCf16WgXZKLAHWfsZKWbdlhHd5OsCUmq5mQpeknb2ALZ9NNDLdAKntDj0h9nHPOnzns6xM4U/qYInqNGkfkqKgEDNsqfyC9k581Tpz//5ZOIE4W2Vb0/VQpp9CRyGSxujdrJYGv9uu/CNj+KU4m1HiakoEWYaWMl+uopG+axMsBZVHYqxka2qZWcZYQnQ+F7VL/F2yNMkh6BX0+vW/CZeolgzTizGimcUvqZoaMX/grBBlSxZdO4FzkWKXE/RFHbf8GUiDQKWZf343XV3F+mngRB+FNKJ3cCQ72EeVLzRyCqh55B7npFl9flOqqfyZd0QDhjiK/rIGi2oaN8gPoO5tSnNnFfba9LaPh/vm8AP74fIY/Qwv58Ovn85DJ01cLq5EZHFkJRrxtKj0W9uF7kvZjTWwbv98JVJR61rNY0yBV7OxKyyvLoh2fI5qKud2Qf8AN1moEKkaZ8LG9tg0tWGkpDFMY0mhOPa9q4Gw0zaGScAq2id+fi1/N6UWhtk4fwQX7tjSa6z8pdRp1t0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh assumes it is invoked from tools/testing/selftests/mm.
When run from another working directory, relative paths can lead to
confusing failures. Detect this case and abort with a clear message.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d9173f2312b7..b7025afb56fd 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -5,6 +5,13 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
+# Verify invocation from the script directory.
+SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
+if [ "$(pwd -P)" != "$SCRIPT_DIR" ]; then
+    echo "Please run this test from $SCRIPT_DIR" >&2
+    exit 1
+fi
+
 count_total=0
 count_pass=0
 count_fail=0
-- 
2.43.0


