Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8FECD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3E66B0093; Thu, 14 May 2026 01:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3DE6B0095; Thu, 14 May 2026 01:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092B46B0096; Thu, 14 May 2026 01:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE2A06B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:07:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 945FDC09E7
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:23 +0000 (UTC)
X-FDA: 84764841966.20.EFD40A2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D328E40008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="E/oh4tN/";
	spf=pass (imf17.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHj0raYlOLWENr35Un076mgEptg+l9iLC10CO+Ra/1g=;
	b=xuNBFO2WHn2P2cEMvcwQo7/gpZynYTcmHWGFKWTQv+GL4ItQXY75ixO88WYDSar0Ps+xNU
	dsvgTcHoQCD+I8Spy6j6dQoQNBFqKPfuzgxSkXso8+d31r0dPm9gk27eF0beWJwLsb8tfv
	zLkw1AnDyhxjMmE39/jwKCJiMiW7ung=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735242; a=rsa-sha256;
	cv=none;
	b=o2MwNijapj9+Css07wpyD4vyD2GRMj4Jl2Md1prTEn41XAMHSvhKein/cPpQ5tSjJgIzz2
	krfFa7BvIi0+AUTVMYExYGojPyOGF6qIWPknWEhE201SljKmZoCFJocULotpNUWxfphAZk
	By2pekoR9eAoywmLMhXkUWBDr/epLA0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="E/oh4tN/";
	spf=pass (imf17.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7ADC51655;
	Wed, 13 May 2026 22:07:15 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 951093F7B4;
	Wed, 13 May 2026 22:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735240; bh=m1VX1+Cs1y6NAynCJMAnljF2dh+IIFzjeI0LtRTOziM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/oh4tN/nyhRAFt0FylqFv26rxNYr0RLbwJycvUtCBR5EOuw4xnrNUwGQFUl8Fdnr
	 aMaaYdqq9tcsYZ8Usbbj9Jd4MTN28+Kac6h6lxa7WKAFMWPWsLaVF2fDlTou0GExN0
	 K25/GUzhMJfdsgdFVJlXBsG+2zTNhbDSt5LZ5Ziw=
From: Jia He <justin.he@arm.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jia He <justin.he@arm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Kees Cook <kees@kernel.org>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 3/7] lib/math/int_log: drop WARN_ON for value == 0
Date: Thu, 14 May 2026 05:04:51 +0000
Message-Id: <20260514050455.2954509-4-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D328E40008
X-Rspam-User: 
X-Stat-Signature: ks8zqnrrpxpt53f9kc9pypeaapj4p89z
X-HE-Tag: 1778735241-691607
X-HE-Meta: U2FsdGVkX18CgqFZa3UOQAMukRb5zM2Ah2r1fmgW3Y6Ehm9/LhDevlNTUaQ1S2nP0mKAVHODU6q84zafBYuo8ShnIddh1nfZqbprKRni91fEfNJDOHMDr1PVVo+Fj8LwgF1U6j7FcPekG3lXZ4AMELuoEvg+EWHGVlUBCxCF5abkqxrHWu/KBEgGG4G/uZUMyUMrSFL4jJRYJFAKI+RCKSXBLwG/DCNV2UHNpz1xWlgHS19TgLYztwTtg/iZLG/kQ2KSZhZr3LCzNIyiSI+W/9w8QNotHKYgNbDoig75MFcloTRuJOkiR8+RumCcI4wAnC+S2MIGn4r5HroLp5DlUMEAWvFdwErHGt0wNYy8LeFdfHQNGbI3D5+WzhlunaRMTVkiCU7ooWeyVYmLxweoyYzlX4vTxfvVjhwPVoeJFDECK5A58n/dXp8kqj5Z6KtXMH3Nd0DP9SoT70VxZ17lbPzDa1aBNCvqBfWe9YWvE4FhIpSaTHeCxvmu/9WHAOUuHZ4+6sY1d0O774zwhpgLxAG753MIC19MKAEP/S4dwTzwBBtBZuWZH0o0F9PEU8LMN3ZJcU65CGSZvioGykuij+pmsLdh9lxQp248/eA1buKzvz4O7WyPkajY51ren6LZ4Ux68Cvbd1FzXTR4rW0HleOkGUbjK5nhnVU+6GgKSP+rM8OG3bsZmqZz1z1M+6bc4yBFo+40O1905veX/MNsKhBCE1oqYyh6BP8M3CUd10R4zcJEHNf4nagrK4RWQ+meMXDCAArlI3gVzZip3yIiNqi0u4megZ7MyoYnzsfSxcI1/+Z8LuYb/6hAFAUH6g16lwo7fosyD3otEUVgSEvw5V0+40+3QfK2VaocIH3cjbciz9EL5zfgqfooIT94yKp8XgwoQHEfQXsEmIwLv4koOcs6+RGgNiGn0uyFeSEjeeMs8TX8oeUn0fqI4Ot16T8JqNnZFKciSFhteIXH2KI
 8rR7w0IH
 Z/Oz365mPykZIRIGBmdOVkiQcswd9lZZWFSStY5tipf57mCk+KjhYqP5e4UrxhEShGBoQRLRCg9VGuCUWFjW38mubbtUDg1tmEQUT0Uv5ML/2KjQJhP3H73a0XdtE1J4inK65cYo0dDLVp/2i76NpWixEtPEgf+vm3x49q+eTjTExNEZRAx4ITNIBiiuV0H7GD2BCsG6qXeIrw6gviypxPFbvhJaqNkdcU3zZxKORNhTTNy3TBTYBhNP40jGtsTogkHh+qZuA6h789PvyAmrz+iBXiYm3C78Oyk7Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

intlog2(0) and intlog10(0) already return 0, and the math-int_log
kunit suite passes {0, 0} as a valid input. The leftover WARN_ON(1) on
that path produces a backtrace per test run. Just remove it.

Signed-off-by: Jia He <justin.he@arm.com>
---
 lib/math/int_log.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/lib/math/int_log.c b/lib/math/int_log.c
index 8f9da3a2ad39..8585207cbe7f 100644
--- a/lib/math/int_log.c
+++ b/lib/math/int_log.c
@@ -59,10 +59,8 @@ unsigned int intlog2(u32 value)
 	unsigned int significand;
 	unsigned int interpolation;
 
-	if (unlikely(value == 0)) {
-		WARN_ON(1);
+	if (unlikely(value == 0))
 		return 0;
-	}
 
 	/* first detect the msb (count begins at 0) */
 	msb = fls(value) - 1;
@@ -116,10 +114,8 @@ unsigned int intlog10(u32 value)
 	 */
 	u64 log;
 
-	if (unlikely(value == 0)) {
-		WARN_ON(1);
+	if (unlikely(value == 0))
 		return 0;
-	}
 
 	log = intlog2(value);
 
-- 
2.34.1


