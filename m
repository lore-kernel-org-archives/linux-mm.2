Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94F5C624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06776B0095; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDC86B0096; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3326B0098; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 864706B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D49AA4831
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:33 +0000 (UTC)
X-FDA: 85173611586.07.61D118F
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6A1A5180004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WqcXHNLp;
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788467851;
	b=s8uXoE3ZTXeps8l9w+Yl27I9zeakoAoCk9HhZWWDmJPTNwZ9YMj40tixPf6DkDwypdOY7T
	xUGGQXR3pmVfSKTlkbwyRdZEcjNJE1fAx6QubvqPN2ykLa97zjKKYfCJkH+HX0p5dQa/kO
	eoKPutRGQ/UenmKlfNutpwwrE03JxMY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WqcXHNLp;
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788467851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0p7OiT9IYtJ0QF28DnbFmBCLEmI8cNswVbeL0gIZVk=;
	b=PpTFApEXkLTOpAPJ+dN8TVOqyVn6UBdjy0BYOsM3rQk5y/DF7KLLEDsTHti1VgUzXxsn0K
	ZbbgXpWKWx5HjnAkyjWGigTMMyBXDkQjhuBNVVzUH2Ix5Z66GwiLlcpqQKdhtZdNYAzs0Y
	xauFX5tM0cm7oOAI+d5BepJ2Ain3WyU=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48441fa5c37so187265f8f.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 13:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788467850; x=1789072650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y0p7OiT9IYtJ0QF28DnbFmBCLEmI8cNswVbeL0gIZVk=;
        b=WqcXHNLpLeUBIf28uttQ2aZ9bH3IPeL0s8XVYVMXnvTznWw4lckzEfVEDCDHQUkFig
         b1BT7Hg7TKT+4oAGAN474AaBIKbuWXyrimqBRS/l+JtUaFRv4fs/87hsvzE4NChQ5sbM
         vYM6IlsFkfTNuw/n74GCx7DBVnMFf63TcO2g+IYwju2hxjxt1yp7zDF2rrj4jB0fQ8xQ
         O9FIc0CKkr2Vq/Yr7OgICSnbWZ1rOXuAwRDGcQX8YR3QEa/xVWJjBjhKB81WjrSzfWmz
         rxu3SBYyg+ItH0XxRSkl/ydgEHtzaXQgA6iixBko3jAGFgnDgoqVhejjcTUDtfDx/BqY
         Ee6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467850; x=1789072650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y0p7OiT9IYtJ0QF28DnbFmBCLEmI8cNswVbeL0gIZVk=;
        b=dGamhXFtkV4ciGIAeL9vxU5JxH9xrwB8h1bZCXYP2J4pRwZVNfbeKB3ey+0jF4GLxZ
         IljVdRk0wXJNeOH6BtfFshNDbNYYiat8p08Z01mKCUMuoK62lBRuaXs1xhm1i7V4Uvwf
         nltH3Kwr73LLdz+oDJ+q8laXK+kkyxMjOg7sP2BXzNqKGQ/9xbrOtJu5NGBBHPZccINN
         RbObgi0YrbCkHeoAMEGCLHy9YAcqvwJTZtF3NvnKhRUWg0Q/21p+To/csqCnh4OSq2jC
         nOKaCP7PBvOKqWrNkRaBd01GUcZRBSMYOrwxP9XvubDwnQGZi1HABLP3Nx15xHioHxi1
         yrfg==
X-Forwarded-Encrypted: i=1; AKwUvBz7km6Fc53H/WB0/jsxwP+To2B3uyvSBzNgJdHpD9pJEBLZkeQysr7zg6d3BB14XnXQjAPcYzCn+A==@kvack.org
X-Gm-Message-State: AFuF++mBUZq8LWwRC57GlvrSruzFFsqqhl0TY6ga/upaNNU86swMw2I0
	cAVqrse2Hd9HZWNVntDY7g7PL1Dl0flWE9ypvHGYoa60VL+agmDQga38
X-Gm-Gg: AYBFou2eGc6Js2oUk/rrZTOhDTYjzNw3xzTikPYs13eJ+R31o+k9iI9YQ5y3jRYGZ9R
	LOdXncaK3oe6bZ9yH1QZHGZm6x79A7Wrlvepl3PDlrD0aYugsVR6lhZCZs8bOYToRy7reWQlCZS
	BV8sIdH7HrX0/jOVw0aVqNE2fa7rzek8Mfug8Nw87CJuxRM5bTvHTL2l+7aGhQXxZ/wGX/IAmsI
	JIbJtoZ9p4VRWsVqymX0mLU2hw8dD1inIYBzTDFca3B0jPLWMAC92XjVlJ1s9pOEWQ/v/Ztx8HF
	oXLWF28vux1O811JS6qanjkE2Cy+dhvc39dv6SvLAfO/NO3ru6kHHkF8QfZCJODrKeWMer8WT9U
	tMUha7FQfxnYHnFcC5gUO6LYf+dCibVFcPRffvL26SGfrqAt7njB3WE+x4e6CsjQHRl4yGFW+ME
	u6V9pkZXnDJIGtatFDykMTwI1GU3Bo+V7dwdjzIJt+vpkzOQiA7b2BAmASVx0IcdiNalwEXRmIf
	wB1xds6JwDeAsPW2OjF75JJRkl8FC6IkgODbf8HsATZmXoUAn3lAks4Vh4zHd54rhlHxU43Xbfw
	VxXO83gktPZt0zliey1fwvvFPBLMHeK47BO8FrUfhSXKdw/G8BhZocRrq4MztPVRFFvF1I7KWzR
	WhRM7
X-Received: by 2002:a05:6000:46cc:b0:484:3f15:15f2 with SMTP id ffacd0b85a97d-485872bbf40mr1870059f8f.24.1788467849852;
        Thu, 03 Sep 2026 13:37:29 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a979-9501-3df6-d7fa-8a5a-06c5.310.pool.telefonica.de. [2a02:3100:a979:9501:3df6:d7fa:8a5a:6c5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm1005070f8f.8.2026.09.03.13.37.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 13:37:29 -0700 (PDT)
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
Subject: [PATCH v3 1/5] slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
Date: Thu,  3 Sep 2026 22:37:16 +0200
Message-Id: <20260903203720.63689-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260903203720.63689-1-kmehltretter@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rykkz96bapcb9g6w44bpzg5etq75zhcr
X-Rspamd-Queue-Id: 6A1A5180004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788467851-132799
X-HE-Meta: U2FsdGVkX1+PDVkJpX3d/fPobtG28hk1qIvzUW19XHf7WFGN0Xvr9lpA4SuPbkplTOVKNa0vU1zUW1dCS4mHPyoHfwayqx7fgoYvmyBe6s4I4F9NnDy0KaDl6Wh863zx9DC6JJGh7OlByp5knLBx3Qfs0lKIDdPAyxYzsGHxVcjTduq6V4C7hEmWeHSAjC1zXDwZJ3Ke/B+J1mNCqTzQ+XLu0QeprZf0qUBkkFhV0WhRqvAy5kVMIKf0bYwq9SU+ArSNUxanDYy46tsixUvIE2WK50bEA1MfI9eZpT46jYDEY0IOxXeAkk6KDTuixcwQu00ZbbXIite9puKDspsVxKQWEKCejYXeqN5DgNRJwwEDhz/8cZe51qre9UXrVFS9SXVLo4ninWRIO6LgFSLYc5vTVeBjFeVClyyl1Q98E1+GpSJjbher6aoIPQZYi/JqM2VnnoYEdnjFgxgMjmfjKIvypfGrZ4SkRgr/glakJniWSV5QSW9E6Z3xMxabv9k/dnsdK/vTgU7WJWLzPf5HEyjNgNbNAK8WIhq3qDD5nMQy2paQSr5ROuoMyxjKysKpcNuHnKQR06ShcJhXdifdUBWzQjZoT2Jw0mQtEKZjusobp+O+TMDs4UsivssKXDhT2PwoGRgKL1hyLd10kKZ6cDNj/97zf4nAlrS1Yb0sji8cjcMPSx8HX1fy512YhAXGkRBFf4KPGfyMYOmCnUtaqR0y1/gPaA8mawZZnFeeDQHkQlVIaXZduPZi15Cy+yPO30y5/+wt5sQXwmhKFSzrQjqUQOQyW17KzaAeZmIoVsJGDNwnBhQcWxHf2gIqzKDWhVsXs/S0wO3mP1kuB9WghvNEWFqZZXcOOKs7kyn8Iv0IB6uxdsODYU2BieHoa4UZ/UrYbHOpkzhW/Z4MDvfIcnajQ53j6sVbmWYabkeG+rbLa1Jsl1TdubVASSVsGmpo2O7i5AxxvPLnYTMT9J/
 nRFvbw/d
 OyX1HInD8sNXyCIAJl14CoD57QrpPzruyMWpTMCfHwmsacoSFizyR8/FSgTJTQaRzsE0s1z2w6KGPSvXuApJ4/bv1hC6B08h3n79/Qej1YjnYIRNtAC9SldtvqR+ay8LQE6vahiIY6er96mWDfjf3UBqf4kTRpIUMSBpomiVdkUVcixVpnGhMS2YtZOlknVtTH8AZ5h13sgZgthsOzm0KWtvzLPrxd4yAsvwU+jyRIeLUtCNXQhmh3TJE95FY6EXSwLQ2BlYR1Um6YWrAE06vFEeKfSZ60PhSlKu1KgIunKZQlkrx7FdGTKStq8o6wyPAXuOYiFF24jzlvdqO/jlu91OTc4uT3HEDXgEGU4LCqKU3jdd4To0e+O64O5/tKVZRYovn2xYTcsgQ1KIVhwQorfZsU1yFdi1fXuyaXvMb5PZV5vWCW4JcRGQgk1THH+Qbd3FJYtLUBihs/DyTmy36qBSORQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmalloc entry points are annotated with __assume_kmalloc_alignment
but return ZERO_SIZE_PTR, currently (void *)16, for zero-size requests.
This violates the annotation when ARCH_KMALLOC_MINALIGN exceeds 16.

This can mislead compiler optimizations. Clang's UBSAN_ALIGNMENT detects
the violation on armv5. GCC and Clang retain the ZERO_OR_NULL_PTR() range
check but eliminate an exact ZERO_SIZE_PTR comparison after an annotated
allocation.

Define ZERO_SIZE_PTR as the greater of 16 and ARCH_KMALLOC_MINALIGN,
retaining the existing value where it is already aligned. Assert that
ARCH_KMALLOC_MINALIGN remains below 0x100, the value of LIST_POISON1
when POISON_POINTER_DELTA is zero, so the sentinel remains distinct
from that poison pointer.

Fixes: 94a58c360a45 ("slab.h: sprinkle __assume_aligned attributes")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 include/linux/slab.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..563dadc16d82 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -262,13 +262,16 @@ enum _slab_flag_bits {
 
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
+ * It satisfies the alignment promised by __assume_kmalloc_alignment
+ * and keeps the historic value 16 where that is already aligned.
  *
  * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
  *
  * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
  * Both make kfree a no-op.
  */
-#define ZERO_SIZE_PTR ((void *)16)
+#define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
+				ARCH_KMALLOC_MINALIGN : 16))
 
 #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)
@@ -625,6 +628,13 @@ static inline bool kmem_dump_obj(void *object) { return false; }
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 #endif
 
+/*
+ * Keep ZERO_SIZE_PTR at most 128, i.e. below 0x100: LIST_POISON1 is
+ * 0x100 when POISON_POINTER_DELTA is 0, and no architecture currently
+ * has an ARCH_KMALLOC_MINALIGN above 128.
+ */
+static_assert(ARCH_KMALLOC_MINALIGN < 0x100);
+
 /*
  * Setting ARCH_SLAB_MINALIGN in arch headers allows a different alignment.
  * Intended for arches that get misalignment faults even for 64 bit integer
-- 
2.53.0


