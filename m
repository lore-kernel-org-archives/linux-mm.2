Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C2F0C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284476B00E2; Tue, 14 Jul 2026 14:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C896B00E4; Tue, 14 Jul 2026 14:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171DD6B00E5; Tue, 14 Jul 2026 14:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D91CE6B00E2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:23:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72B931A049B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:13 +0000 (UTC)
X-FDA: 84988204266.20.763851C
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id AD3B91C0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qfQ+N2K3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HcjDBHsn65ZCZzOohF40VNQnTu2vZZX71z4vh7Fe7A=;
	b=5G5mopKPCysrmEojFlC8dEPI1j6hyeHSJ3VYFptBt5PMR8LhBqzA7Db9Smf68gN7PP4j4e
	aD2RCADgBbXx5cZ0YKFNwOvJy8gkbdQl6NcCpeZY68KSyqXT6PUhq6ujio6T06mJmYKb1T
	RIB5w4cdwa0+x/grMnxt4ubS8k9lhBo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qfQ+N2K3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053391;
	b=BjOjxzY6IDUF4qgmtWFtwE/2rxt+BaVnU6iByeaZMJGa3Z0PTkbVU3pWCGbijbj9IUVkrm
	GKMvvC9CCyqwaVfEXRuPV0lBsvsfpXLZswOZ2+c2j5wl9hJP9DjH7L9wnmFHIH++Cnemvx
	8Huq0h8429Gvx5AdLk8jGFD1UQpJkcw=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c04bf4711so42655881cf.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053391; x=1784658191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/HcjDBHsn65ZCZzOohF40VNQnTu2vZZX71z4vh7Fe7A=;
        b=qfQ+N2K3ct+z85fwnMbllo0kHYS7G5NQJFzQRlRs2fngYGdPCUCsXthRFpqa2XVp0V
         nkfUz9skokF+c8oeDoGPHXVMf3Juwsf+phjIf8KjLrMVqGPKZDVnU11UGjXScWEKP8Oo
         fnsUH6Y7b6qfKnd47Slp0ImHfTIz/WUz54n3KFAE1JMd4BwRVB+tZUBKrxp1vVoXxPjN
         wbRdzmtQ4nP4YwZujuBc+Ud67avvq7LxJMoDw682A2O7Kcno5h2U7FeR3yXgkWKMM7jk
         uO+tKXmoVdqAUPyG0i9MNEXtRsXobUipe6yLYZ1nlrCpu1UcaP47a3JMvv383WOXKlnK
         tUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053391; x=1784658191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/HcjDBHsn65ZCZzOohF40VNQnTu2vZZX71z4vh7Fe7A=;
        b=hq+2bnq95Kn3yrKOzE1u2XxifhGfdHrgKbZz+XJcNfYpmEDTggR43dx3ewR08QWaMV
         /Go6yvHiH1PzJ6SXWBWEYH1jgKuqa/M7FzzsOpse72rBYU5dbSi7JJEKanmRCm7V6BzB
         AVwW2hmNFQaoAnbk5mjBSoQdTrWaNBDuaYsIX1sL6loMom+7eewrLsjCWbIlt+0CB9qp
         OZ274sJLtj8xbuJktX1yZUIKO9RuxdzQRWnB74X3Zth/DnTmkdMSuJelnoUKe0NDQE/w
         hrxJqCef/kPMfSdhITiaYQneVT+JciqwQe44AMIUUvivA8OEEsNx15lwNLv8+ePGEt3r
         HfAA==
X-Forwarded-Encrypted: i=1; AHgh+RoA3uEJx3ZaEO6MK581+p+rNczXzaISPrXXu+SrWM4g1HoE5E3A/XZJHAR59eMUNFJ++JvIJIkh1w==@kvack.org
X-Gm-Message-State: AOJu0YxbMkth4LWDl3rXwhIXwhBJ7MfWceROJRWPONOfVQFMqx9PppJD
	AEddcpe1AA/w30VW5snji1aR9KUVTWV+zqktTMfw+uBcbUCA7bk9DgYL
X-Gm-Gg: AfdE7ckwIsIfShthZg8iPkr2PZsH/xJQkr7pZu4/JQOaBIsWoIVmFWugK+MLZZBQ6zF
	Tuxyh/5q4ZmaomruY1nXT1DbwFp6W6ocaZlO0pd9SZC4okKCqVCfJ4674TnCCnykK1gkcbzQ6d3
	Aiu7YoQs3NpSPXz5Wqq0STFmcGV+GvrdIob3mdP/a4atw+PMhelfPbaY1Gwt9Y9jpBp3O9WYAkT
	NFlpz/uDa09TrladL2Y5oTbYKvQGtkhBYa3QsPFPFR6OKYK1eMlTJaRcIHE25ljnobTWQaqD8VD
	D7lMhG9lid/Odl45HS7HW0PScIiv+qOW6aewX0CMq9Ogc2WcFzNUMa1hbp4xfKtNi4T7e+fy9vH
	Xehv0lvyO8uq1LlnNPS0A4N5Yae6/hKQt9UKVxB6bCS2mHPedHNnfQu1xVb0qU1/43cQbwgF4lp
	XyfbGG7odJ4oD+jsn1r6n12XI0pHcVtXnEYk3dWuFOHXymTSjjgKU=
X-Received: by 2002:ac8:5cd4:0:b0:51c:7b12:5fce with SMTP id d75a77b69052e-51cbf311623mr144967821cf.74.1784053390733;
        Tue, 14 Jul 2026 11:23:10 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caab6ed34sm116210141cf.4.2026.07.14.11.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:23:10 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 01/13] arch: add HAVE_REINSTALL_HW_BREAKPOINT
Date: Wed, 15 Jul 2026 02:22:31 +0800
Message-ID: <20260714182243.10687-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xm7m4iud9npiwmr76gmg9p8rbqjhxhqt
X-Rspamd-Queue-Id: AD3B91C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784053391-985240
X-HE-Meta: U2FsdGVkX1/+9DQn9DeRv3KPo4j4ZNEX6OUcTReXoDOg6SmH8Q8IDtnobcUwKkmizyBNgMA6ou0FdYutGxpMTpgsHML3PhO7+JNn4O8GKHCc259AM8j0ip5V4aMWrA8W4yjI5heOV6d1CdIDjK/3F1YpcSxE2wNSr6QPGhgCYKJNafwbONniGZ3dU1MIoZGJdTWzkstNl1vfgQL0b1UihdJrgbahGq2KAw6iN6jtNlqX/t1XWsb1pf/7kooQiAXpyTQSg4+p7jQop5OoMZTIVyw1ivkcNRrixjSZv21THtnlx9BfyRz7gk0Z3zqBvE+DXiJtY/tvP5HEOK2TVv6tnl0yaMDfMwhWqC58nrp3TgzvyjpUekrlp6zXEVbFo+aygtjQmvroryP+CLQZQcu+ZxNVgFJ4ztFG8QMxxNFqRjicGiNxY2Dc35T2TRzodF8Pocu7R1PbIErfuuqU/gHge525kdUeiaiQIkRWKSjCykdylXk+txKX+qtLY2nTOxYf1DWOH9dxd/YJhCpQRTwv4aY8GUjPZlUdfNGJmjhZep/paBuiAvc2rY7RwQvueoFNU76UgEi4SLEgJC6GjJMzCO5fp3H1zdhbYG9A1xLdBsbOwE+eaHVsoB7JB5ad9krqS1PKHqbWpw0xYX7TTAluy6q3kfLGsrg3lgXOzr8zM3m8IaKZJgDWCfQOTClJr2uBT+E2Xesvvy95/+IiLb0p9ceL5tU97bLGtTTh9l/DHFPxpu7TGHK8Cr/2fKmGCNzokgS1kqF3r5PmiXRWbGHRtwKDOzvg4vpCIgDBE+1te2ZOGabHD/ftWk6f8eKh+RYxduxY8Thju3UzC9eV7yTHdz2WihNzCDAlZtIDMR4sJlmxnI+1NaeajsTclm67Z2E9GgVPGHUGQ08LBAYy/YzkmB0JoLBsCPzXJNPuD8us/Qz6H650e0SoX/btMVCMGigNcmYuqzIlXco9w0tQdkN
 q8ULnVHq
 zJQs4lGNU6x5yriCq42SJA76hXdKsHHHrAK56kOkRJ9ydUzzPf2LXyjNWvx6ACc8uvM7ZmF+2T+3Z4klfRrcsyAKOMcuX/tLGmfe+MnUcYbVe+791TPmPrmGQRtTmiU4evHXJagCuacWsYVEbX2HA3E0B/DKaFlcTT2+NQhZexz1AptZqgt1qz2FERQ0BAv1hHKIWECUhmpShnfOcxTLq2ZEKWWv92R9SKsx/YVzqJQoUUYtwikNNFmCDd6jksDZWw9dLqngYf+NN7nc3E/N0iIIXHeSTzJhvmyIJGlFEsQjqcvnXuG34y2TabKDXqqEeZcpDxW2l66Ns3RJwL8KW/khLNOlZNX5jgHvud73rZe94PKNanEhTNbNIWGyLDrb7eoZweDNHNyAkWonMcWewrM9EKYn8m5hRx6AVquwDEOXRAT1kw7x6r9fsunxVfdy1z8XoSzpawpqac7yJaOILVRYKubKIh2U/ekORg5AdSTGdvDDRMgw/ua0zoOtHBNXiR4vY0TwOd2ENeMLJ8EcR+UQgUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some architectures can update the address, length or type of an
installed hardware breakpoint in place, without releasing and
re-reserving its slot. Add an opt-in Kconfig symbol so generic code
can offer such an operation on architectures that implement
arch_reinstall_hw_breakpoint().

This is a prerequisite for KWatch, which re-points preallocated
per-CPU breakpoints from atomic context, where the register/release
path (which may sleep and rebalances slot constraints) cannot be
used.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index fa7507ac8e13..41b3784e0ddd 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -457,6 +457,16 @@ config HAVE_MIXED_BREAKPOINTS_REGS
 	  Select this option if your arch implements breakpoints under the
 	  latter fashion.
 
+config HAVE_REINSTALL_HW_BREAKPOINT
+	bool
+	depends on HAVE_HW_BREAKPOINT
+	help
+	  Depending on the arch implementation of hardware breakpoints,
+	  some of them are able to update the breakpoint configuration
+	  without release and reserve the hardware breakpoint register.
+	  What configuration is able to update depends on hardware and
+	  software implementation.
+
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
-- 
2.53.0


