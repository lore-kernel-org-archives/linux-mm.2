Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0D7F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A0C6B0089; Mon, 13 Apr 2026 14:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651AB6B008A; Mon, 13 Apr 2026 14:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566FD6B0093; Mon, 13 Apr 2026 14:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47E5A6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E080213A212
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:05 +0000 (UTC)
X-FDA: 84654369450.13.09748E6
Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	by imf08.hostedemail.com (Postfix) with ESMTP id C38FA16000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=cZBSYs58;
	spf=pass (imf08.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6w/vm8RhE1QibuAbeZrZpu+mbFZf/j6v7Old22bTNI=;
	b=FbYf10xmAi8EpmZeMzDRFXO97NLioBMlaCQfhcOS/wRUJ7Rvu61lgHTQpa9tyG9tMnDhXW
	1Cp/m+HHtM/RbaS60JD/CvAU7EZSB7urOc5vuxb/3ZY2KCdQeSkMivs0r3nSJfTX/cgpwf
	jtorztBxW8Pk9p0e6bBoECo/PzHET04=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=cZBSYs58;
	spf=pass (imf08.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104944; a=rsa-sha256;
	cv=none;
	b=wlvg1KtWLSiqAcdgs049oo3JTv8IbX8a41PbayPv7Q1/iPPrfhGgKq3BwDYbgDown/zY1X
	yjMu8vEwreEM6vfScKUWwWPTTwuFFdr5JsFSdD8qOb0TIz7ppJJ4pakrXdlUM5PfSy1eQ2
	YpiyLGMCgexz/ZHZJLO/jNM4xnlNPj4=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 9FEB0C5B1AC;
	Mon, 13 Apr 2026 18:29:38 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E99BB5FFB9;
	Mon, 13 Apr 2026 18:29:01 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DE28C104504C2;
	Mon, 13 Apr 2026 20:28:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104939; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=J6w/vm8RhE1QibuAbeZrZpu+mbFZf/j6v7Old22bTNI=;
	b=cZBSYs587EC2pPG0T0zWnt6Rm3YWgLoLQHo/fERZmvyCcXnMbHG6UHv4UW2EhRe6AcwwK4
	rLJqLN0QcpxJ+eU2wnigOQQIs5tEOULYPsd1eLcu1LilosOrM1UCnTdfl+hYwGPMfNEMV/
	/5Ph0br4h41uQYEnh8/FBrJsTvpWOM11sOt/QM2ZTP7geak6StbyhdakN5Z/m5BxbpCjin
	o8OFL6dggWmiW+3fP5D/aD3dYrcXLqeqZdzncuDbmqmu9QPwy6ZHA14bp/bp5laVHfSfBf
	7xNDlnmSlRRrNNIRvXgvQWAu27n6dhrzs7GZ2IUSyjAbZY1p1dja0IfA16reIg==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Date: Mon, 13 Apr 2026 20:28:41 +0200
Subject: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260413-kasan-v1-1-1a5831230821@bootlin.com>
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
In-Reply-To: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: ebpf@linuxfoundation.org, 
 Bastien Curutchet <bastien.curutchet@bootlin.com>, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, 
 =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
X-Mailer: b4 0.15.1
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: C38FA16000E
X-Stat-Signature: frq4yxgixjtxe3g6fkx9goirtxo8bny7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776104943-5252
X-HE-Meta: U2FsdGVkX1+UzcodNIIdj8uGREzsaABm5E0tTodLVnw8625npsG/b2+k9VXgm9kjn4LSnt0gsHn8wtRt7of4NPKUzuQ18B0oFL4YJ/Z9hB5/lurMU4GYKhroxtoCYb/X4KDodJFmzzKEQ+A2D8pkadwrq9kUw3QyYJzTQiHbMYfpdQyBYu3GqRbjMlG1kJxWASeWTrs4py5sqXl7GrrDBKbiHxaVq4PrAEJdiCpFRSCg9C73h09f6AJCvreBhGTkRRiSBtTVLYLxMT5fujL3uZcdJjrFHbsyN/8HNbtLtXiwm2xZCjBV9EZ0rwJsOuVnDaCQxfnMro5+IjucXbHEtWXI4UATVWe9zWUxBNuI5mV/+PmkzfMgkONXLfmgCc25nVJy6yoLRuGoS+ETws/Q5pzHLXJl3dqvhehU91M925Dlx9veJ+WblQGndPC9CHUwSumLMmBSaJ1Klz4fchdrZlyk1woeLIyQg9n+ndEku5b2qqXJCFgO2xvo2Yvl+UbWZfcw5+8SZwzTVhOVlYbIV9DFuJSzgfy9LAEu71PGC3K+8gWp4zHwH+0oFLJzwb5jQ2M6CfOa9H9IM7oioykOTyN1pt7xwq3W8pwPqzpfHz3xqabQ7EgQu27c4ZA86Hmx5dZBRT9u5n5j1jNbUcW+sosZOUzaXi4XepazPHq/UwvIR+dE/bn9jhbCfn+0sF0maeJAW5jhBlAJ2TH/MU1hR+zw3PiEZ8WrSfLDr+aoj7MAFHWwjNF2OExp27nNGafsTuyZsywRQ0XlXuUp3kdhx4H0rDPBYJOi79SHJ6Aq2B/A91prKIrb3QanoGjkR8kh4/76krZjcbo7CyhIxqBPC21881t6a4wyK5X5EwqzMlnx7+GnjKs9w5qW+X7zPRJ6dC26+fpl+61tPzaCnbrwgc20X2hLYX5eHzAb0grGJnhpxe/4SjfVeZO9pbNGWQGrguAIPO3pyTS4XAzYbgJ
 w/iBDamJ
 UzZq9aZYME1pKGsMGRo7GKid5Wl7ijxDTHReVLlFhXeH0Rn6i66bcGN57uUKoyCcp8MzODiroCjhq1P2EV40bTfndd0dHCtkOi/vXEI1/qK0gmUMJuS427hEuTUfrFpi6LSCVs3jbL3YmIBFfNibIneNBcYqCFx3UUIyY798FZ6ZR10G5eyhp3c3j0GbQ00VwZsUX0ooxqfCptGqp7UPT13vk/N3rS7hquDI7hBFjI6npqhiSpCtswrkM4cR6roJmOqwM+7+z2YfoSlDl92VIpbRcMVyoDHYuqgi4AszXqiN4QDFGOv9b0G7BRQ4f5xKNxG9ekGfzmrUgttqRW11ks1YyWNL19Bo6XZTKswUvhl+C9P1PtvlyIJnW1RDX8RNvBriZo8Sf2w2xj/ys3X1Rhbxg6JsJwIY32DVjabXNA7eeDzsqskGMNfPoJJT0ucFhSVcN7j3e1q2LVmIjy7RbkEuE8VORKC3AyhC4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to prepare KASAN helpers to be called from the eBPF subsystem
(to add KASAN instrumentation at runtime when JITing eBPF programs),
expose the __asan_{load,store}X functions in linux/kasan.h

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
 include/linux/kasan.h | 13 +++++++++++++
 mm/kasan/kasan.h      | 10 ----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 338a1921a50a..6f580d4a39e4 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -710,4 +710,17 @@ void kasan_non_canonical_hook(unsigned long addr);
 static inline void kasan_non_canonical_hook(unsigned long addr) { }
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
+#ifdef CONFIG_KASAN_GENERIC
+void __asan_load1(void *p);
+void __asan_store1(void *p);
+void __asan_load2(void *p);
+void __asan_store2(void *p);
+void __asan_load4(void *p);
+void __asan_store4(void *p);
+void __asan_load8(void *p);
+void __asan_store8(void *p);
+void __asan_load16(void *p);
+void __asan_store16(void *p);
+#endif /* CONFIG_KASAN_GENERIC */
+
 #endif /* LINUX_KASAN_H */
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a54766..3bfce8eb3135 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -594,16 +594,6 @@ void __asan_handle_no_return(void);
 void __asan_alloca_poison(void *, ssize_t size);
 void __asan_allocas_unpoison(void *stack_top, ssize_t stack_bottom);
 
-void __asan_load1(void *);
-void __asan_store1(void *);
-void __asan_load2(void *);
-void __asan_store2(void *);
-void __asan_load4(void *);
-void __asan_store4(void *);
-void __asan_load8(void *);
-void __asan_store8(void *);
-void __asan_load16(void *);
-void __asan_store16(void *);
 void __asan_loadN(void *, ssize_t size);
 void __asan_storeN(void *, ssize_t size);
 

-- 
2.53.0


