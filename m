Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC842606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifqPUIQb
Received: by kanga.kvack.org (Postfix)
	id 8131C6B05BF; Mon,  9 Nov 2026 07:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB806B05C0; Mon,  9 Nov 2026 07:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728176B05C1; Mon,  9 Nov 2026 07:05:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52CBD6B05BF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:05:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3AC41C3FE5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:34 +0000 (UTC)
X-FDA: 85415450988.03.D6C034E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 559CCC000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifqPUIQb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LYzOqgVWc34uRY6ovO7R7m1hhJFjX7us7aa10zp4XA=;
	b=7WvnCzn7EY/DMLo9+5rZeBg5NSHUe00ytINq8zNqj4elnHtsSrvG2L4qTaOYU2Xg6ucc15
	Mmx66a1YJCParyQ55LYxm59obwmueYhxogHnNkkOIFhwGnwwG++lsVUrLnbOPTK2HDpGxq
	VLae8+MtA4Y51BsKyJy5c/W1SKvRFpk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifqPUIQb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225933;
	b=G5bhALU2+ynsdXpVXXcGqtCSqmbkznZhiq++WzMF/zdhUoORHk9X+ML5HTC2S0Tj0LuAiU
	cH962VSoQ37FmorAHIsd3D4utelH9LHSEU8R9/7gKmF2XvEcMTitl8W3M6lJvx2Gr3OVKV
	v9TTg0N9W0oxyBtpdhEf7SjmQz+MbOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 710DA458A5;
	Mon,  9 Nov 2026 12:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEAA1F0089F;
	Mon,  9 Nov 2026 12:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225932;
	bh=6LYzOqgVWc34uRY6ovO7R7m1hhJFjX7us7aa10zp4XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifqPUIQb4197CXOoo3zkk/P+62IWE3W6hw3VXHH7BmaZDJzTj/sylmfjzUn/heM/o
	 Dy3qocNvWVFwIqtPRM05SK7rH7jllGShFdSL1cRyz7QQ/mkOqRGeBPNiZRUO8mrxRm
	 FIachU3c43wQuZXo5Uct+uIktJlmVTYkENycEl9wY+AjWuGD9c6TxAz1oGp/9/UG2+
	 XGuWNxEDTKXdIbIkn+pWSeDgW1jw3znXhbtuXBKg7H3oAZHzcnibIYvO90zTJhWf1j
	 3bP/GAN+qstiydBQLS9s63mMSLiQr3I7JY3AW6z//o+NeybqI0nzbTP8tHEzysVNuR
	 YHkTNUk0CoDNQ==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v2 5/6] arm64: lib: Disable branch profiling for architecture library code
Date: Mon,  9 Nov 2026 19:44:58 +0800
Message-ID: <20261109114500.20298-6-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261109114500.20298-1-jszhang@kernel.org>
References: <20261109114500.20298-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 559CCC000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b9fokds987ty918kmhd5tx9bx4ajjaqc
X-HE-Tag: 1794225933-76706
X-HE-Meta: U2FsdGVkX19KZVyIzoUex2pfMFiqhC1WHFb99PwtIxdS6fiu8EyJmJuzVnELMysgre/WvilbXz0AQmyDBGtI1XFJDVXWVFQm4usffoI7ZN92SbHMa32G+lU+qiQnST1Z+Ucbf+H6YgHwHfB1Y6+3ROIHp/mV8rwy6y2Tkcgzt0cfPRg1CBlXlayLlPk6bUsSbfwaIJyoxJEpoIzGDPZ9Y7wFad2GuLTj/Gq+An8VIpOcxdDFfM929IB/yuFq3MTR8cZVpx5Jibd7UtlACZdF0FBTZMj69bXcdjX4xVfVERyQgVf9gZmy1NOomrwNf9hSKWjllmyKifuyuxBzhdDmUa3tMf8mYcNGa3uMkPuLPYnLQ1hjgdtBu9X/duFkIXGsJiKWFLdaf2O5ajq/m15amIJzdPdKqaAvRc8yrkB50ouKIoqiHA00aXloDWIGkQsK+HjWo6f5o15XaHA5SMHXwCJAWIy88SsNAQwb3D9JuLFygHxPGOPqA0bWbeinmuL8rmrsuNDiPKjWJymubhULsw0JbsCJPPI4TRH9kJARsSy2WUqyI+IIfbdUyBUVfPfcdkZ0a0eM65BDq9BBjLBWgWc374ZgH58xsV7fazTLZz/QDoeRRYm6BluK6SKVg3g9tUSp+r2id7iCX3vjKb1L394HwXiWKaoK3iO/ZfRCLpRgC0txmo5C/rTmQ3QQUtqoctKns+pQOTkuQJ3g5a9jfO7obSV6KeXMZTodSRSrEvK8IhYUcMEu6cbYu+OqbLu3iFSomIst//Ou+Ge/PMavaYqWuAsX/ZywQh4hxaui9DoDJXkEwNSmLX7L0LYcqYKjej4yIu5US0mxEzDjBqiCM7EYVP4mFSNs+AlJJe7AIj8vXbXqByaT32HAKCVhCosMUCZpkq7P8ig7LKE4ZkVYnPqV2dHu7v29aFxb8ENxZ8TarVaT8pK4Ouqll6Ge9XcOO8EjwJMpYO9v4B/sjUm
 43rehlAb
 QWw5wU7gxJCaAY1Azm8VYd/sRIpDaDGksswZvGUVezMeUfEP7wzZ7VvH52uU0yVENobxaNYfV8CM5Ld20FCBP8cmgkX42iPVvNHQj0Y+QrmWqmDzWWOl1Efrko5VwktGGqiBoyl0eOup6hMaSy/tVrGobIcBhLlzM4XVvJ0uCYELcUj1+I/fJ/L68cVxm/5NJI3nQkVkWutWFzvgmHdRiKR70OOoMe1byMs7EMs0Mk9/KL9ggGni0fa77ZIqVaSm0E/5EjU0pr7g8KAeVFKmUDZJxHEL0t0/4Ik+Z3kYxY2qC2Uzzb+X8YQjeKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

arch/arm64/Kbuild disables branch profiling through subdir-ccflags-y.
However, arch/arm64/lib/ is built separately through libs-y and does
not inherit that flag.

Consequently, CONFIG_TRACE_BRANCH_PROFILING can introduce explicit
profiling instrumentation into library code, including helpers used
while applying alternatives. noinstr does not suppress instrumentation
inserted by the branch-profiling macros.

Disable branch profiling in arch/arm64/lib/Makefile to extend the
existing arm64 policy to this directory

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Assisted-by: LLM
---
 arch/arm64/lib/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 38ffd359123c..59d714865c00 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -1,5 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 
+# Built via libs-y, so the flags in arch/arm64/Kbuild do not reach here.
+# Branch profiling isn't noinstr-safe.
+ccflags-$(CONFIG_TRACE_BRANCH_PROFILING) += -DDISABLE_BRANCH_PROFILING
+
 # KCSAN uses udelay for introducing watchpoint delay; avoid recursion.
 KCSAN_SANITIZE_delay.o := n
 
-- 
2.55.0


