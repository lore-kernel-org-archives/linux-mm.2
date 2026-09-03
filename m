Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA13C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31296B0099; Thu,  3 Sep 2026 16:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1BC6B009B; Thu,  3 Sep 2026 16:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9826C6B009D; Thu,  3 Sep 2026 16:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 366486B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:37:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 831DCA068B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:37 +0000 (UTC)
X-FDA: 85173611754.22.C89C1A4
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6AE5120006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=othomu3H;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788467855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akOv2wAC7HX7aMxE6Q3m1WKBtSvSbn9vu4HmmhmzJNE=;
	b=Q8u2LLwRMHbXxcS4QKcD6WWw8WAc42H5ujYqANFnp/idqT/DXwlzlqI11vUBax4jy2gK3p
	WVytIwdUb6hTqMdrsVUq+O2BEQB54hIApam8kU1TKLs+IkdoV+E5wP5zsBnBLjw8j6/daH
	kqDOxJq/40pEGpo+Ulqj+hcNG5EuO4A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788467855;
	b=a4N4gDGOawWrzsa/9heV9ZkWpzlZA7VsYiDJGKWU/UH/e7hBM5Bh0xPz6e7ZnRhSf+bL7c
	aR0ayGOQmpzjPvzjS36dX7ApgHCYN0Iz1PqHD+qBObwswaV+YfaAiMGMg6XJNjHMI9ctqg
	89CK/8GyUe0z7fV4U9fCU6yeKzT7pEE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=othomu3H;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48441fa5c37so187319f8f.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 13:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788467854; x=1789072654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=akOv2wAC7HX7aMxE6Q3m1WKBtSvSbn9vu4HmmhmzJNE=;
        b=othomu3HNniWlum4T9c8l+hpnluGClPp2VSLhKLg/V4kyDLmULctiHltCjI7IsXfuP
         +z2lhU/BA7CDctYPkLxI9WJOWgfd5Id8zBXFrVxAdkEwQIwdbrKyu6cFSaq2lGtNAa49
         JA1a+ZYmaU/ZbxceydY+sE9+b0AiL4+EQunvZIErdNUUMq8PAs3jFyy+5CrIPkJRppHE
         DnYfICrYKgw4brWLpM7CB8Eu5JACJr0kKjU4wTMyhXSqAu6rUNZo7aNVSCnOzr3hGJS3
         M3rZVqytJjDsFoFH7L48cKK7qmRHXwc+l/1SAyqfOY5Oeea+wp89NXxRuR/ngJfEYZgg
         nwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467854; x=1789072654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=akOv2wAC7HX7aMxE6Q3m1WKBtSvSbn9vu4HmmhmzJNE=;
        b=i1VId4U+QNTu1Nr/vJWawzyqBfSIrbgx43lsSA/aQoJfJ8cLsT3/LVDEL6HeFZu5FZ
         jmXV8OaY88jZk9Lu5AqVm4MA3REl6Yu5+21mtQjkv3xNGxJd4vNUSa0bsQ2ohEdlWJmq
         NIu7avucuB8W+IIJqxlMoKAOIVcC0b2B0EM+d8CmBqXQvgrq67etAiBh7kyTN9kRlJtP
         uICAYiZyvhk9+C6gYNkOCGOdbzGbjTjhDyM7LkahzTrW9JsBZFiKjLaLL5gogwh9ja/G
         SxnA4CnMQrBlJWLDz0oU0Z0qx220NCVmILlcQV9cW2bS9GIlQcJq6ta0A9lRvuj7B5Pk
         G0ig==
X-Forwarded-Encrypted: i=1; AKwUvByKQd34w0aBaLdeWMiVauyBq0XuEroMqtkyep/l8EH1lY+2l0Aapz0X7b9To3PHE+/VcAjRpic00w==@kvack.org
X-Gm-Message-State: AFuF++mO4566AZ50DyG7vIaGi7kgBQaWeS8Rt2cxI4xoknF5rDlGYFDo
	zc1K8aUm0xTsUcWGrBeaHc0zvNzMRG1LwfZ8QlpQ9TdBgYR9xrCnFw4v
X-Gm-Gg: AYBFou0iTxUV+NFTRIQwtKVK6RiCoQ0ycGR8zk8kCzyRQS/6p0u3wxQz3EE8YqtxcYm
	YIJoaOXZDmYMDcm1MJ8kR0Ha8/RIuf7U2nwNDM+4O+pVhWknUa3mGVXtS2N7kLDQUv16qk0IJgk
	S4UEJXAvd/uVvN+SuakKyDMfgSTUNaVmPFgWx4u8k9Vw4tDMsdR7QyHRK+b4uWFICjahJ+VbFxa
	n2/sbMsTpNLzaqN1qKT2V3+mCEobwFvkBFLWuhT6nrDM9EkuSDzZv00WC/kkxE6pZxPwh517+6d
	xkwF2R7FPFrFQcqYhST7uuIUyTDQRYV9eJTpWVElPSgxKJAkMZR5ekcwEzHnqoJXBqslv6av+O7
	8XDzNdHwuuE5yxbZoBq9LzyYN9ucgtWSJWL7/tgzNnV18JVUHp0EFQJssQjFYpPPqhehvHDGWln
	f0gQekjDiH+YzPf/UzILtiw0+xfITjYS0FuGXbaAvGj/pu3808yjEDFXiOo7JywLYeEFPb+9ma4
	3UAaBqEG9uRGwQS/7d4z00M23l+JBxQFsttt1idzQYgHCiP+fpbTW1IkC5Ot/N4PDHoiArCkMkX
	OGtFUbgZENdJqmmADnRS82QeQK4A4sEoWU/ZjY+5R63cbouHYXwgH+9HAUJvAFCifHpbIakVwrX
	vNSTa
X-Received: by 2002:a05:6000:220a:b0:485:81a8:6f09 with SMTP id ffacd0b85a97d-485870982a4mr3472028f8f.9.1788467854295;
        Thu, 03 Sep 2026 13:37:34 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a979-9501-3df6-d7fa-8a5a-06c5.310.pool.telefonica.de. [2a02:3100:a979:9501:3df6:d7fa:8a5a:6c5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm1005070f8f.8.2026.09.03.13.37.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 13:37:33 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 4/5] slab: test zero-size allocations in slub_kunit
Date: Thu,  3 Sep 2026 22:37:19 +0200
Message-Id: <20260903203720.63689-5-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260903203720.63689-1-kmehltretter@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 67bb5u5zaxpwpzu51m5t7sfyznfp1jcg
X-Rspamd-Queue-Id: B6AE5120006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788467855-618152
X-HE-Meta: U2FsdGVkX1/kvvsfVI7Zs9CCL7hk4+C3Hz/dVnDo4hDZAHiQmtpcM3WIkX99gKLONSin5gpCbemkBOYEgQkXrjKKDAyTvu/9cGVMTBnaf5PwYxrb7hdE5Q2MCdBXgKakHbXktlex9ODgeQdwFMZjwsWQJ2mbSyMa909i2G+6NZjwyrixGgb1221o01Ql+MFK6dYKEqopZsG0xXfnIzy4caggF8sHH5k6UJ9G+jTLKq3B6N8+LW3G89MbWPEbznWMXXQRF8ohCe8ys9gUvNlfUnrMz3yjmsfQFlztSI8AdR2njlt4PsAaORhJQBU3MQ6vSYfujbe4UpctV4NYja1Y9FYWYgQ1pMbStsOG94jWW+EnAgjZMqkweiSZFn/PFCEqlY9ePjo98wWPbVIu6ieY98CrWraIShL1slM+Ch458qRLmOzmSdn1R1vr2Sc3sXgl6X9m3swhHkMTlrK/CtVMGGdV3ZN22FfmHW0UlOzhLsJKbW9fXZ1jMxIdwQ6SIKAdy40J6UHkEdlHFhp1YL8HNXEapwgrXBDth0Y1BPTUsywa9M4XGfAO85y6aADLDsxrBuxYTEjjiNZnNtC2N6KeoVNL6h0GBT2XOAzoggHTsQ3+0q+Poh/o/C1Isxnt2oeW4ulHvPica8v9PsqF/Wi9kGlBLzs0sOE1mtGqLpzfyWwKZOIsexNLzSELizmha4r3XGqNNh3v/Eg8375E0yf4OtUw+wGTi0V8Iyk3nhftzKqoMlqAPAQkLse25Z7o/civonQwgqk50CeC+UcVAyGeQ1Q5TEEPEpupfqTj9kBq8GkpRshICQvCyQQBRVRxz5iuZ0NBTkxOeUIjhK+Q/K6IOnV3H5E1CqHgwMw6SalzbdPFjl9BdxjHtrCOo4kkSiFx53lpEwgasqsc2fq9zkME5OCFeTYaZ7SeAofQcEYBUns6l8ntVLG6kqbrPZza34hrHhL59o5PGesnYs+pT+9
 PDgqFMSk
 RnGlv3PKK4vw5e0NMal9ETNeV9bE31y6RI1fVgMw1Rmg6kmezrcJZqIlZWFy0ZfTgVUeKlezQVDFdjmcLsQ0QnpsTVVyKukPHKBBAdPu3rxoRqeUK6nqXAOapHm20sbGJ8l12G0cAi0AhRjOmMgxdyp0+7J9uPfkKswtIqevJ7arXqcxv2ZTzHmIf4cGeWXePt0B54caPMgnqCy17YRHmz5pE5dM+icJMLQY8qHF5G1Ac9RgUtKEENRzboZ+lxbrVy3p4VawerejkAyQfrA0PLdBnygil0B+gGZFHC4kmIP4UX4QyE7jsLqK1ZXJWmwmV9bshrNMwCAZCJpun2ZA1XiBUMIv116/hiMPiDSXt2G3AGt7CtI+jPru8a0T/WBYkUVsNQ+aeV/Kls99Du1gYeP/amPspzMak0oJ81cgThIhJhVnSUNrwXhOZN5tJmLr2sQahcXClhjZWkU9+xXomOz7HPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit coverage for the zero-size allocation contract, including
ZERO_SIZE_PTR alignment and exact ZERO_OR_NULL_PTR() matching.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 lib/tests/slub_kunit.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index e3b63f0338d5..923d8646bca1 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -465,6 +465,48 @@ static void test_kmalloc_nolock_and_friends_kprobe(struct kunit *test)
 }
 #endif
 
+static void test_zero_size_alloc(struct kunit *test)
+{
+	unsigned long zsp = (unsigned long)ZERO_SIZE_PTR;
+	void *p, *r;
+
+	KUNIT_EXPECT_EQ(test, zsp % ARCH_KMALLOC_MINALIGN, 0UL);
+
+	p = kmalloc(0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	KUNIT_EXPECT_EQ(test, ksize(p), 0);
+	kfree(p);
+
+	KUNIT_EXPECT_PTR_EQ(test, kzalloc(0, GFP_KERNEL), ZERO_SIZE_PTR);
+	KUNIT_EXPECT_PTR_EQ(test, kmalloc_array(0, 8, GFP_KERNEL), ZERO_SIZE_PTR);
+	KUNIT_EXPECT_PTR_EQ(test, kcalloc(4, 0, GFP_KERNEL), ZERO_SIZE_PTR);
+
+	p = kvmalloc(0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	kvfree(p);
+
+	p = krealloc(NULL, 0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	r = krealloc(p, 64, GFP_KERNEL);
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR(r));
+	p = krealloc(r, 0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	kfree(p);
+
+	/* Only NULL and the zero-size sentinel match. */
+	KUNIT_EXPECT_TRUE(test, ZERO_OR_NULL_PTR(NULL));
+	KUNIT_EXPECT_TRUE(test, ZERO_OR_NULL_PTR(ZERO_SIZE_PTR));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)1));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)(zsp - 1)));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)(zsp + 1)));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)(zsp * 2)));
+
+	/* freeing the sentinel must stay a no-op */
+	kfree(ZERO_SIZE_PTR);
+	kfree_sensitive(ZERO_SIZE_PTR);
+	kvfree(ZERO_SIZE_PTR);
+}
+
 static int test_init(struct kunit *test)
 {
 	slab_errors = 0;
@@ -489,6 +531,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
+	KUNIT_CASE(test_zero_size_alloc),
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
-- 
2.53.0


