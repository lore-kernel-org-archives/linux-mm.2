Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D35CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1E48E0122; Thu, 18 Sep 2025 10:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C831B8E0112; Thu, 18 Sep 2025 10:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0388E0122; Thu, 18 Sep 2025 10:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A17398E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58562139C0C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:43 +0000 (UTC)
X-FDA: 83902544166.20.550AA08
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7848F4001A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2TMczNyE;
	spf=pass (imf01.hostedemail.com: domain of 3sxHMaAUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sxHMaAUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkIaNFjZ8EE9t4JDBPeqGMTocvjIYd1EXgJAVVa8hvk=;
	b=QdMjb4a3ds3K3cOqfzFadAJwU8nLqyigVluND1dESTdwSieX4HEt3d6sh7UfvcsBQhoc0T
	/lmwlCKArFx+fkL/E+yYXuSepNS87gx35c/RNxnMIisny7MtkTLTZqCOu+9sA9PDwHUvC7
	DizGcPMDRMgdJn9/5FefL7lIkO2gWTs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2TMczNyE;
	spf=pass (imf01.hostedemail.com: domain of 3sxHMaAUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sxHMaAUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204341; a=rsa-sha256;
	cv=none;
	b=FM88jS6WzoY0Ohc/bMbaVKONSBvUrnt/Ew0ErJ/fSIpECrTCXrgTo/v5oSmCgVoRW8mDEd
	fi2JrcQAW/NbxVcsIEX0otS3jKphCIDclqplO7uk+eq2SA9mhcnTqYtVg8+d+rEnfFdwr7
	AI66o7vjyu5wmqe/wQbdQUHRlqBLHzI=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso8078425e9.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204340; x=1758809140; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PkIaNFjZ8EE9t4JDBPeqGMTocvjIYd1EXgJAVVa8hvk=;
        b=2TMczNyEJFOdCQpC1CkRJ2qXmIJ41k+90OKJN2Cp0YPKYOarSFkgH7uLpwB/FpSeN8
         mhm7EgnIlb6gPk/0K+KgWZGGybjYsNN5TR2FXx0wXNtSEjyVRgdD8/mfFIUjB+P6Asci
         sng1tuGi1nAxAa9A89G1YuLdn7q6O72u40z19gCGxDPJ8RRuVPhYSyzOBuRHHXCqDZaZ
         TJUfNLNcd6V4pXyABRB8pawMpmjOx3o46T96ZNgMdG2eLM40Ftc5ceIaQrhp9xOMm186
         p19a3DRmhPZ7O2qFSU3TvFerknK1az/V6CiPf4xZQ/sMZQFO7ZGq+hTOa2QflikTwk9v
         AHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204340; x=1758809140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PkIaNFjZ8EE9t4JDBPeqGMTocvjIYd1EXgJAVVa8hvk=;
        b=gbiN/7sGyNm8Pw8OZANnNWAtAYg4j2jLCXgSVuOMGAAjUt1KU2IiRgchtivzbTJQI7
         NFH3EleeV72K9mjBXMdzYdBt3tVJJuymNaYEhoKwkMtAUuppinjpWvIM6S3DCU3kUGAT
         qLZi8ZSWJFlAwCVmreMDD4sCcMK9uOLHX6X+JrOx3EuH6gQk97IZWsgKncZrO//goJqf
         PvKKkiWm4kLAcMctKywBFLK4+OQUeWAaTEp4NFZ1T0wpmR1eR7H5lA5QBLjuoKPMiWZg
         s4E/C7oSSAKOwEZ1+03XhV6nlYCMKQ6q99lUz/6xoyIaLc/sZ8cnQXeblgq69CLa6rQp
         sb9A==
X-Forwarded-Encrypted: i=1; AJvYcCU94G7A6F80mUb7VhvI5jT7O4RT7Do90GYSbTxN90NCFZUWK22ghfsJUqdVldycWtdOHwAFthCILA==@kvack.org
X-Gm-Message-State: AOJu0YzsNUag5ck6QIUSnyPkDsabZU+yjmhafxHDolxcxhfiUSIq6lff
	4V59T9gjUwnmMy3+SwWdVI9G/PbRQvYx0ZvwYkwdmGNQEwAFuHX/zCrk5sA6Drb7096RHYMGzLt
	UsQ==
X-Google-Smtp-Source: AGHT+IHQzPo8Mj0thMXjE5t0fY5CTZzNk1DcpYE8xx/Ej+3pN7Wv3jLT0CrPQrr0ioychSRPw4fXch23mw==
X-Received: from wmqj11.prod.google.com ([2002:a05:600c:190b:b0:45d:db34:5091])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6018:b0:456:942:b162
 with SMTP id 5b1f17b1804b1-4650503b3e2mr26525245e9.11.1758204339995; Thu, 18
 Sep 2025 07:05:39 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:16 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-6-elver@google.com>
Subject: [PATCH v3 05/35] checkpatch: Warn about capability_unsafe() without comment
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: oohu5f7w344iiymathy86bhxxg1ak5hp
X-Rspam-User: 
X-Rspamd-Queue-Id: 7848F4001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758204341-222668
X-HE-Meta: U2FsdGVkX19v9Xgc47vANSExDTxn5zrE5m1RuPbm9dIJq4+QSS6KF1BTaqhXr5Tw7uQR1PER1N6SBk1Q9rlMXMX8EQ7ovyY5Olm4XeMm0klEqt+tX+N82gVU7oK4WR9/Jw2WAI5B0rwKOIw+6BcVGkyH8alxngzsV4KOdZUjj7zv68xF2sCLckHgbfpD48O87rVCHJMC6KwXJW2Qx1QEBDqVXXYizU+K6hg9CGbANuzAsJgcHXshmnaNQwSDrJFUjoo5XOVdebqflJBeOomESI0QP2scw+lpx/ITi0FPnLS7ZMiZQvTFZZXQAa9bLfsAmMiqAYifuKhDm3INcx3udQ2OwfiFF2s9iigY+kdsHv6mRl3zGN4HsgTumj363A671hRdiYsdeeMtIFNLDysTtvZ1P6cJ9ARBRl4IgxlWbZ0JFPuKnSw2FEJ+64gJq5zchEd29K/ie5WjnvUy2vSku2IyuJ6xznRDGY373F2255aV4W+kb8uhVLihx4OuEmdg86uR7b2bjIdv5ZIdEKV5QD4hXrAq58XQAiPF7hhQhNnneWn6PbSzrdPASxfnwmX26pT9OCfOT6wJwzOYcqe/rz4Yk4UQXfEU+vYAS74Gi1hCgdlqZqF51nvOFbTi2fkVEwPqKPpPwbFyvcA3KY1+L5WXQpzAk9goytAVPGcWzmsYljJIPs+Wc/rAF/a+I9PmkMB+l24Hu5/Oie/bgOOvgRCFdKP418zgUjkcfKWB2QW/CjV+KN1ZT+JrejLpWCnj59FTmNHgFpQ98wQ5KQ20aOFBv+vqApL5+NvkR5JfxrUk1GsQPl/vi07PJYE05ngGWHH5FmPOcr01MZsTWZt9FcNdEqxxlm0k1xf70zOZG5vcQ5qJNLNb2GpQ9GXgV3UL5/kThT0fGke82Ixnk8yFQ1c1wv3CeX1ZLRLi7AmoYwyoXYJQUHB6e4AwVNEBN/Q/TstQNa9bsLaqNYbJfwx
 zyIuz/z0
 SDEQrGmIlDGm0edMpzg07jSEUXqLLQLd4B5kUR4+og7iHQz82f5XBVF9/iPKv6Zw41anwn+IKQYm6RH7YnKfg9dJbCglJ2FDf7LBZHcJjkojNKubkbBEbQvUFaRq+Rnua0nTIZ/cKzFUyKvXrWsLDK/WGAe+KPwv7vITu+zyFO+piILcZXsu+gNyhzZ/d5pkxivUbuPubkG1NHE/aPZTjhS4W+kWRnG5x7UT2c6usn2QpVaXnMc08GHYl9FODeAEybIda2OgJ6+IDXW+/E0Rv3M4h40TLLbOpjWom9dabMmhymadSTIAnfVK8XF66R7h662uzG6605fckDqW7KKdEuC9N80nXwb94XCih4ELei9735wYJmNt0A6/qToqh4m/Ls4dS4mPMX8DGFkHznWu6ioyk+moDnxc4Leso438xO8o/i8LSvcHYDh13nMG3godlYmCHTJoTpicfaKzPmgyKyuqmpi2PGk4XZ0/tfGOXMTbYDI6QR4Ag+581TVZjz1KneIXwBlLnFNfGCJ/VFe1LwoxtszOP8WtGAMAg9AHgXE9tx7vyxPIp7hWgWZ9diSzYXCOHrXwygk8uuOgssYI4+LC6B3Lx2kIxnaQmEKi1DpFQXcWjHi+RP1j4JsUQwQDSIGCz3WBnZol5GfqPu7MXrr2OUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Warn about applications of capability_unsafe() without a comment, to
encourage documenting the reasoning behind why it was deemed safe.

Signed-off-by: Marco Elver <elver@google.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e722dd6fa8ef..532075e67a96 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6717,6 +6717,14 @@ sub process {
 			}
 		}
 
+# check for capability_unsafe without a comment.
+		if ($line =~ /\bcapability_unsafe\b/) {
+			if (!ctx_has_comment($first_line, $linenr)) {
+				WARN("CAPABILITY_UNSAFE",
+				     "capability_unsafe without comment\n" . $herecurr);
+			}
+		}
+
 # check of hardware specific defines
 		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("ARCH_DEFINES",
-- 
2.51.0.384.g4c02a37b29-goog


