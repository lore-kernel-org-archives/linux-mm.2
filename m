Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1B4606A322
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PJVpTTl7
Received: by kanga.kvack.org (Postfix)
	id 894856B0AA0; Thu, 22 Oct 2026 21:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BAD6B0AA2; Thu, 22 Oct 2026 21:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B916B0AA3; Thu, 22 Oct 2026 21:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 401B76B0AA0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:50:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F8711202E4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:50:21 +0000 (UTC)
X-FDA: 85352211042.30.CF2ACFE
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id B8D8340008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:50:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PJVpTTl7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792720219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X468p48PfOB0WmzJ6kNGiEZKtoooeWVaYKhSdbR2LN8=;
	b=KfYKWBUfAa5Rw9y8y4VQK/Hms54eZe0y4Pbe/k91yZuoktAlguO7L9tIvGclGbsQRqmQLg
	undRMBe755imojF7EEkfx3PvLIQ2QqP66VB1cL81ywt4oREbaVg0qhlKmZ1rnaMyX9wkY1
	g3qqfKtSHMkErbzw8DuxG270UkjzOwA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PJVpTTl7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792720219;
	b=uYTWj+ZRYqIAMN3qgvWEV8ImuadKwazxm08+B+BAbdyWS7QifFcqU/pstDx139lFE8z94c
	DILN8J92Rwzhg7Gmc0UbkWc7MaJsr7kQX8T0L7NRyjiIPHxorn0GT07Aj7IMqHrIAn1QQ9
	2eSYGzq5eK4JyUbh+1k5zdTwj9SRYho=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-35943f55c06so452053eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792720218; x=1793325018; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X468p48PfOB0WmzJ6kNGiEZKtoooeWVaYKhSdbR2LN8=;
        b=PJVpTTl7brz8YlY0qASdHgcI1AZ/FKrsy6+ACTPHBqawYzVlB5pfsfrIa76GVwF/0n
         0K72k07R3pVCiTAZ6n56rIpwZ4eLNdWKBG2cKeOuWgUQTjnUIxQYxCqlxNZlNDCEFGBA
         hl1u1GMEyaruH1V9wRX+IKmGok/VbYd8gnCTjAzt9SjJLoCBtPiBFfJ1yh0sDq2virfS
         uMOcLp+8vS1XJRC5dSStN/RWpnKDP8ekBVrZMPGdg80tAQHvYEoz3xLoP8AWXJhCUX5q
         IXNjpH4lJyKOD0YZqha9H/2kKFS7LbTeGhmooD457+MJlmOrPASihTu2JzbgZXJnJWw3
         rrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720218; x=1793325018;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X468p48PfOB0WmzJ6kNGiEZKtoooeWVaYKhSdbR2LN8=;
        b=Isy+7aiDZg40+nTUvMYn0u1C6sTwSBqmYpkbEP4L2WtKXirWfdbF9yoFA+HZNLyKss
         1SJJu4M83GSvUgfPsZidE62rzRUSx1+qTY/qJycygN6JCawG3ua1pIUNWAv3NSy0E//h
         nh+RAgeLVOi2tNZ3jPqNZsF4gTj3PIeqEdaA96UoPFGcVoet8TPsTM3nC5ZaVbSKLgcX
         5ZYlT8jF6DgnTqOKX1DCZKCJpCX2yUlNonaEy2de2R1Ih/o3RxfDOL/o8vWV4/t1pvVK
         LwOMm9eBaecPgfpmUjTdTC9uJH11ZD/G2EnsM0yMP+0EWBsRU1+RSnpd6191/c6/vXbS
         5m5Q==
X-Forwarded-Encrypted: i=1; AKwUvBw+zyOIqo/J499MQ9NqPxsP6QE0NypqYgnZcIg4jyNYf+Xor0H5ZuUgUJf2YrUJRxuk5iHtc7O9Yg==@kvack.org
X-Gm-Message-State: AFq9FYICUVkkK335SX0UewYOUqZP55hAZmlNylKPhfjcNj49EtXuqPk+
	DWpegI/zXMmGYloP8wwgZFxRqlA0rEnZSvDf4GAWflhuYJo11YtiK8ar
X-Gm-Gg: AYBFou3vPqyxgX+d8rVyeRJdwSCV8PgnpPGFb6m3vFcdFK/6hFGpppZ68wUsRR9DXRJ
	RnPYFzIw3FST+hc/nEj66ekNNSJR/sXuwAqScJ2p01R82qvhP+HOJ+bB5Z9XLLrkSQNi8wgMwHt
	UEo8mFZZug9Mai25rt3Kj29Bm+xKnoNGKAVUwRWY5n/wybdtmMnZ1Nz3T/vQC9UeEJGrYb4nFy7
	cd8GjRBhpZyc0QeNnYFTKK0jNzvvF0gPTcj4Vm1gBm5aycRFdhh3NpgDOdw2ypDSdIdfOqhm9A8
	2gWXrTUK9x3wkiOBGD5et1YqZLSKS8T9t3uXT3SgyphIp05QT5ZN0Q3CpWUQxVQjp++nho2/QbF
	3oSia/exLbdY8egxxXdeSpaiSoG/btFDIQWny0BpCBbYbDgrChdADpmHB9BF/po48KCMIe6f/3k
	jQs7qS98FZRGTdW0BK3sImtHVlHSmv9HaG4X5Sw/mwQNO+nzvrW8YV3JCMIJLrnkc18Eqbo1yGq
	pu1uYzuwu6jEKXCBVv3eN5rVDco7RGr3x7SfHWZWmu4doMHZKA=
X-Received: by 2002:a05:693c:69c3:b0:368:2c6d:ddfe with SMTP id 5a478bee46e88-368afd86765mr4796119eec.9.1792720218428;
        Thu, 22 Oct 2026 18:50:18 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9c0e60dsm1971091eec.2.2026.10.22.18.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 18:50:18 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 23 Oct 2026 09:49:49 +0800
Subject: [PATCH v2 2/2] kasan/test: cover load_unaligned_zeropad()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-bug-word-at-a-time-zeropad-kasan-v2-2-be0ecfbae847@gmail.com>
References: <20261023-bug-word-at-a-time-zeropad-kasan-v2-0-be0ecfbae847@gmail.com>
In-Reply-To: <20261023-bug-word-at-a-time-zeropad-kasan-v2-0-be0ecfbae847@gmail.com>
To: Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
 Marco Elver <elver@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8D8340008
X-Stat-Signature: m713sdee79599s5uct6dh1mdsmbo6ki8
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792720219-774405
X-HE-Meta: U2FsdGVkX19uAxxH6UeLBJClOCkgs4IxqmkYxsLjM8NG+V9E3WxrMUBeWzx2siTDm936r3cJfNXrCyz3zPq8gujAwe/+hXYHDxePvzGxQN/vkQgsHEkqqjZKVSF6/aN4TxtLv8oyK0dYKwQZFOHvcVH0egAri7tnXU/bSyC5ryDkMhBjIT8hmhbXDPOvyNqRecs/Qwcu5ub+mPDaPsoywJCXrfkJEarhWoVRcrOaErEIV7L9JEWliiJol3lvwy+jEuh8Y/cYfG6xRLnybR6AxpPhGvmol+tarXfL9aCYCFgmola8XyPenVWyPgPqxOGkOyXVRjk0YdJUi4XQVt49BxAnzLyNCMlWiYSfcGXaXmQypS9g7Zr8PoFBa0GIB++EjGkUjxOGdc+jhT6OnL8FXBOt2dH/h46P8QvXK4r8lV0SRdKQBtQcdx+PfhffkoNV3HNMXDQo+FbPg2kVefFF9Tn16bpQGDsTqKZL95C8gpT0lH9pcO4lND5vq3/VQU+9OFpurcXK9RQt0dJGlmGv2jc4xt0dJKKhG+MF1bevCHgg9G7seJ/BoNrOAZFgGMVB2xiJEyj4V6nJ3Bp9md5ho+asV8gx3eJjChsc+NXVLaRyu5v7itMPZYKGJfWlQpNd/hSw2d9NvJKUDYVHQVnG1ky+ACVzYovJGYOKqh6G+JeKDDRIG0czldL/omFMlMcvn3ySuhyfD/5ZPelrkaMrfJO2YXwFYT8yyhYgDVy5oqQ10+rMIrewOziP/D9wDPrVGO1I32qS5xRKDp6MOA2g+m92N/mkWFHGU+HTXO3B1mMB0TMzd6jkM1R5sMh4x3Jm/10h7Upmdi/EwcOWb7pdGVtHo4TPtWBxUUqrU4rDHUq0O3xT9nQKhVRJsqM/yWLCAzMTi+4vvvr7ebTFtGYF/IcBQQn2WQCa3YZRFh/hTS7L73IJRpQ93SJFg+GJpr2xGf+/fyuhM6YordtOqCc
 u18CMYv/
 UhkCZMq5ecMCKO2nLh2mBuXKCPS5EeXwpL3ZqC91HQsFhyF3SpKrin3kKANDgj47yE+GnHJaAAFacXKiNUManXvcHojxB4WXoTyGKIWPOggtJVi6aaUscdLJ8Gzea8JLQPQkj8U938SyCSJxRsjYM/UdYj+rTrQXeAFr264qezehPnuOyPv10kfAJhC2V9TvGPAaqaEG5dLDoVJWvIp07ylaIHTXTg3idYKeyhsOuOHUKpQi6bFrgC1LOYK/+GcvyHmO0JJxUnhCQGGJXg33jxMXzE5I2XVqeqm14hzEOXywS77q9jJD02AyhlwS/HzWBtJz1psJGG4kvyHM0yIum5VISFOgimr6Y2cF76RBcV1Ee4qtepHycKo5goC5Njv+IGlSDOe1YxuIEgyciBkxWL/E4ztInpqANJJorZ37HQmX+X9ZS1cuskWBx7zv/1qNX0VizQ+HvNMF/SFfECOzMWhqoTU/0LqU9GEu20DO8nMQ5zGoTb1feqa7uEGXGyaicGCvYnDZM0SWTwrXTV5/WYV3GsedBXyh1Rg1CGqCU2PNjRhMmpuOW2DFNkoHqSfTL5OkTN8J4Go6Q23c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On architectures with CONFIG_DCACHE_WORD_ACCESS, load_unaligned_zeropad()
does the word loads of the dcache name compare and of path name
hashing.

None of the KASAN test cases reads memory through it, so nothing
noticed that KASAN did not check these loads at all.

Add a case that reads a freed object through load_unaligned_zeropad()
and expects a report. Skip it with hardware tag-based KASAN, since
arm64 turns tag checking off for this load:

  kasan_load_unaligned_zeropad, x86_64, generic KASAN
  without "word-at-a-time: check the first byte in
  load_unaligned_zeropad()"                                 FAILED
  with it                                                   PASSED

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 mm/kasan/kasan_test_c.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be32..c791512f6fc49 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -28,6 +28,9 @@
 #include <trace/events/printk.h>
 
 #include <asm/page.h>
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+#include <asm/word-at-a-time.h>
+#endif
 
 #include "kasan.h"
 
@@ -1673,6 +1676,26 @@ static void kasan_memcmp(struct kunit *test)
 	kfree(ptr);
 }
 
+static void kasan_load_unaligned_zeropad(struct kunit *test)
+{
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+	char *ptr;
+
+	/* The tag check is turned off for this load on arm64 with MTE. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
+
+	ptr = kmalloc(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	kfree(ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
+		kasan_int_result = load_unaligned_zeropad(ptr));
+#else
+	kunit_skip(test, "Test requires CONFIG_DCACHE_WORD_ACCESS=y");
+#endif
+}
+
 static void kasan_strings(struct kunit *test)
 {
 	char *ptr;
@@ -2264,6 +2287,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kasan_alloca_oob_right),
 	KUNIT_CASE(kasan_memchr),
 	KUNIT_CASE(kasan_memcmp),
+	KUNIT_CASE(kasan_load_unaligned_zeropad),
 	KUNIT_CASE(kasan_strings),
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),

-- 
2.43.0


