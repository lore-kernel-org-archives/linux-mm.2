Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E7FC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5204C6B008A; Fri, 11 Sep 2026 03:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F88C6B008C; Fri, 11 Sep 2026 03:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E286B0092; Fri, 11 Sep 2026 03:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2236B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:04:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 465BA160115
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:04:15 +0000 (UTC)
X-FDA: 85200592470.19.341B3A6
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id 798F514000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:04:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CJ6UQuRZ;
	spf=pass (imf23.hostedemail.com: domain of 366ejagUKCCYOQTDQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--morbo.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=366ejagUKCCYOQTDQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789110253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q15pDPXWwHD21xyeCsqnIN6CD+fe6kHmFEwudOZDaaw=;
	b=bie65+SzOxzEX4RG8MaenejpLtUyzCF5IQWj002c+SnsY0MReN2nP5VltYA49/0SVjscfu
	JpDRN9qjn492NK/tUGCG856BlxEWyCofM4MVzEioK5lo96LXORLRsozIbZEV5Kk2W33SiM
	I5nGo6ST8WyDiGpPh8Wj0sEjOqGRlhk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789110253;
	b=akMpps4ToxB3e19IX7TyNTtsgHpFnJ242QAL5UyrkTTdmjoSUrheLLxM5YIhOVvUN0jnNd
	vW/k4bbsTU0mXYAzbRRWq8kqwsbVbKHaZltMj43EUiJTgcvO55C38ahJA6VCLKdhblF9ng
	rfT3KFdMrhspHEHSlyyBmFYqbEvknaE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CJ6UQuRZ;
	spf=pass (imf23.hostedemail.com: domain of 366ejagUKCCYOQTDQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--morbo.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=366ejagUKCCYOQTDQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8538a72b430so633001b3a.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789110252; x=1789715052; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=q15pDPXWwHD21xyeCsqnIN6CD+fe6kHmFEwudOZDaaw=;
        b=CJ6UQuRZQSdOVTP+0+LXa922a+n3r7iPcjOKBfcTju3AXp4J02/AgYrp007Ir0MDp+
         2zWVW2jNukgduXi/qjHLwXG85U0yZsbioRzFSNnEzb423NWwtuhNb37iayK7gh7t3JJx
         OQE9IP29ungTBjVEWPbkH3CRPecisgEhZuQgKnCWPSVlihKKi8QCnRi/Hx6Ja72c1lvd
         +oj0G/vftUVDC+oYxmdTNsgUKNlbCCaMdt27uOGb19Hor9XD/DPwzdoOTAcd6B93UuKT
         QdZ+WVPESO/APVr5LEgcaJd8JknuhnKLFguW6H+j1vGNVekps+WAw2kfFXyVWHhRYku6
         OkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789110252; x=1789715052;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q15pDPXWwHD21xyeCsqnIN6CD+fe6kHmFEwudOZDaaw=;
        b=XViadi8m+uFWnJifK2BPeu/iv/HT93+KB6kq8aJyAFr12eOhciJD4c+uL+hzvTYTzN
         FbtP2DO/VPvIeJ9oqz8O0M9CkZ0mGMKTfzdO43FS4Ba0EtYRHZuFYkok0F38jLS1nW4F
         QagosRzrUCwXxTOrDQWBFsDhIruzuKMhJnPO+kXG2oM7Kx8ZMmJ+FLY3kTD43cRLfzKm
         hAWmnrcdAOk7RANtJg9HNAHSRvMmF93L9C6umOuVqaY9DBdWLHT1dvFVbzxoltnqbvp8
         KLD3T4LLqaGlInjfD6SFmjp3ignlh3UpqnAHCb5oiYtGMCJckZP0UAvo+FgzA9DZ29qw
         XI7A==
X-Forwarded-Encrypted: i=1; AKwUvBxJNOdwFtHf9oTIYn8D0OHF7yQ+LefcgXkWkHimUIoKD7dKLMpHpfdOduBNVFbJxmeTt9+tfcnp0Q==@kvack.org
X-Gm-Message-State: AFuF++nxM/rFA69CTtRO5cIJBAv2xk9IHYDtTq0L5nmdmVDC3BbA3TuI
	rd5ILtdX7HRui6E0T/7F4rQub6HJgjP5MN7UhLa6l/aHXR4a/7iwiZzERv8v4GC/oB7l4nfPLQh
	3
X-Received: from pgbbx40.prod.google.com ([2002:a05:6a02:528:b0:cc4:aa48:7b7e])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1611:b0:3d7:eb3e:1c58
 with SMTP id adf61e73a8af0-3daed1c1684mr5671856637.8.1789110251982; Fri, 11
 Sep 2026 00:04:11 -0700 (PDT)
Date: Fri, 11 Sep 2026 07:03:39 +0000
In-Reply-To: <20260911070346.801948-1-morbo@google.com>
Mime-Version: 1.0
References: <20260911070346.801948-1-morbo@google.com>
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260911070346.801948-2-morbo@google.com>
Subject: [PATCH 1/7] kasan: Add .kunitconfig for KUnit tests
From: Bill Wendling <morbo@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bill Wendling <morbo@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, "=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 798F514000A
X-Stat-Signature: ngnq5nswsifftgmpeh8zao8cus9gyc1o
X-Rspam-User: 
X-HE-Tag: 1789110253-612395
X-HE-Meta: U2FsdGVkX18bys1qXqINuZuSgsBtk3mkEt3fCcMFEJkxaMPAVmV4Phm48y/xQrlki7H/R44K3HpSMchLdu360zuooPXoR80PjfF57cCwOYn3s7icahpMqTN1FWP8nHrN2P7NKIABgz/34U0AV6ve1QNEp2Rt9Z2Wvni91wUo4zVLxOlW6VSu3DotYFqsc90Oyua8oSf9OLNYWq4Yg00sXWjKH7kPZYKVrW0AGx7o3sIqi47NAQKfBKED7FPqZPiMqFqJpYWKzEEHQShkkpUtOucerYON2xlrx+CX5D1/YwQn9cf9a3Uwj2h5qzX8lwEajo2c7NYSDNE1+rWkj/DiVwnyJ4L+tx8EaS6qlRbVRA+jk4iHDsJvoDPK3mHSs7shPkbYGiA228ZfnEERX0mJ/V6yB/FKVrR2+w5yuZlRjsd+PrrDIVIcUwIHPFZBMvqcAl0yY93TvAMbO87nyEJZmZeJ+iwCY9TCv3KmQNdbkRMarntrkjd5ABlxGYNb7lobv2z621iF3eJbDFlUhet28UkQS5TVoWFHhkXiZDXZ0AjrC5ZRep/UPY5xpOHWCeABL2WEUaA5gdOtsgd4OrFPZ174DG8XuHtCZFiz0fFfO/41p4K2C9e0GvR2gVihf36HMBwwDsXpUrxUfR7zkFdaw8C58TnZiB3yWHZ35cttDir/xP0c6bCt3F/uTO2mBOpLQynyHBArDDl3gLNiCPvn2fwy+swH/acSE+bKjVNkPKq4arPDkbyB7Pyb5MgUWVZy8YVdC3Icaf/4DL+f7DaPDjgiKxqk4hCen4KYSvphjxUBDDBf5xd7ExL/9NK5qyuwDJ0ABTACoGbYqPpUrzzBGWhNLttYYk97Ra7YMJUtItQrsp23gKX9o12joIrUHu1NHMzvAh4UA1F1x7C0Q+SfXzvv/xdn/hqDegmhE3iCky6oL1784fUcjra6AKf6XPXwnJ96ADdKgurtMJ0x/f7
 sopyHbpq
 aawy7bzyftGzIXgWQnqFrbEAZo/YfdNYMEkc2sxmgbC+0LeEkUYFpBJDg4tMKSZR6oHPjNW6myLGNYD+k0XBN95InJZ5YT5M8SrfAnuaRTrNiBZDTFVMETkLQ3VLKlalzQYd7WM664dPFSTGw0QPMB5Jmqvn9wN1rfP8ec++Nb4lNP5zWcnMhbvHdb2X6kno3Q0S99iUGBuxufO6H2yGnOlFD3N6yRFH1EWuptQFmcas2M9U2MUyz6ef4OoHm3YZ9Y7e5d+ulWl7iz5vixkJAM9XR4W6BjQkfNX4OaUayN/d8Gh1NnYju37l9vQz6FGgAFpdOYUsUQ3s8/i5vs34b5vHLj2U5nQkSAxz76lF3cVOtTaM4kOy7o8DDFcj6A2oyMGiNtCojBL9Uflpvm1H7WhzsKuR66rwrh16tKFPHMMm2ZNU1avkC0PusLpWi/Yr+Phr+EF7VPFnZiu7OsLsYyu22jfuUpNjWexvFyg+lHvVhVixoGWBDUAAZXCVh/FwI3SWrc3GhbrueINlZJiRqsgC3K/jtdm1IRslj5oP5ZT9uF5rVS9el64eY6q7Yjuc6Kxi+HF/AqP5urQllM/v/oyCs20+ZvbgsLOj8Z9sYQ5KeB1kLOwliaiIXf3I8aFO7Z16zLvzCuCCXLcepC05klpYEAm5OVWR7Xr6Wi3yrcmd1oeccamz37gzRBArwMJt/LYgKrtC/TI+7pJpK9yiIKnMiO4k8K0CwzeZnflJWNu49jUj+VIKT06RwFZ0VocQ2lx0Ga7zEkZm8JcS6S2DnpNSQctox/NNKsyldDZ9oYe/vkUxDAFvgGFrXaij3FxcZr16o93AnM8xmOUVXSTzroEIGAJuP+SAXmEteqLuU8Jpoc09Y9aannLJOSquIb67hCi9DdBZ9FNpAUdTsTJPElGONSerzNWSbisVXInenxFs1opfgdVjxFTZxvLqzHCRym2gO20j4V/nNfvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a .kunitconfig file for the KASAN test suite so that it can easily
be run via kunit.py:

    ./tools/testing/kunit/kunit.py run --arch=3Dx86_64 --kunitconfig mm/kas=
an

CONFIG_KASAN_KUNIT_TEST depends on TRACEPOINTS, which is an invisible
Kconfig symbol without a prompt. CONFIG_FTRACE alone only unlocks the
tracer submenu and does not select TRACEPOINTS by itself, so also
enable CONFIG_SCHED_TRACER=3Dy, which selects GENERIC_TRACER -> TRACING
-> TRACEPOINTS. This follows the same pattern used by
security/landlock/.kunitconfig. Verified with:

    make KCONFIG_ALLCONFIG=3Dmm/kasan/.kunitconfig allnoconfig

that CONFIG_TRACEPOINTS=3Dy and CONFIG_KASAN_KUNIT_TEST=3Dy both resolve.

In addition, set CONFIG_LOG_BUF_SHIFT=3D20 to prevent printk buffer
overflows on serial consoles when running under QEMU, as KASAN generates
extensive reports across its test cases.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Bill Wendling <morbo@google.com>
---
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Micka=C3=ABl Sala=C3=BCn" <mic@digikod.net>
Cc: "G=C3=BCnther Noack" <gnoack@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
---
 mm/kasan/.kunitconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 mm/kasan/.kunitconfig

diff --git a/mm/kasan/.kunitconfig b/mm/kasan/.kunitconfig
new file mode 100644
index 000000000000..58a7448fa352
--- /dev/null
+++ b/mm/kasan/.kunitconfig
@@ -0,0 +1,15 @@
+CONFIG_KUNIT=3Dy
+CONFIG_KASAN=3Dy
+CONFIG_KASAN_KUNIT_TEST=3Dy
+
+# Additional dependencies.
+# CONFIG_KASAN_KUNIT_TEST depends on TRACEPOINTS, an invisible Kconfig
+# symbol with no prompt. CONFIG_FTRACE alone only unlocks the tracer
+# submenu; CONFIG_SCHED_TRACER is needed to actually select
+# GENERIC_TRACER -> TRACING -> TRACEPOINTS.
+CONFIG_FTRACE=3Dy
+CONFIG_SCHED_TRACER=3Dy
+
+# Prevent printk buffer overflows on serial consoles when running under
+# QEMU, since KASAN generates extensive reports across its test cases.
+CONFIG_LOG_BUF_SHIFT=3D20
--=20
2.47.3


