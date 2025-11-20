Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01706CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEF66B00B4; Thu, 20 Nov 2025 10:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D66F6B00B5; Thu, 20 Nov 2025 10:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBF16B00B6; Thu, 20 Nov 2025 10:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD786B00B4
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A5D5138972
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:53 +0000 (UTC)
X-FDA: 84131327826.07.C7EF746
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 215322001E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xG2QlyPL;
	spf=pass (imf13.hostedemail.com: domain of 38S8faQUKCB48FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=38S8faQUKCB48FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nc/agqhZHpBZo5pQd3t3SIT1Qnduk/rx/3xksUJM3vo=;
	b=YdUw01aZ7GA6oASFwYUN/KAoPiueFKU40e6cwpo/ETWoTvT6DrB+Q9xSphPrL7eVUzSJ+Q
	9QrPTYrfdbCSDz5uYsLZHm3/+b96lwGWliBiqTRqZevFPeOADYjT3w2qH1av/2Nw5kOTFd
	68wh2WdggrsVKeb0SsN2jdsVNB5cznE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xG2QlyPL;
	spf=pass (imf13.hostedemail.com: domain of 38S8faQUKCB48FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=38S8faQUKCB48FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651571; a=rsa-sha256;
	cv=none;
	b=zu3r6pX01bDcnRN11KcLpsDp3/9OpRzAsSnuTAFwGN4X49y/3MtdDAm+CTA8UqMaHKbykJ
	9Fg/NrZxW4ueM/ZtkNqYeiEBFArC4/YiwxaSpfAo+z3KRuLY+N605SvGB5QtINtvd4ozH9
	mePYry75EvLbUNijtapEhbAiEC+OzgQ=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775fcf67d8so10445805e9.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651570; x=1764256370; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nc/agqhZHpBZo5pQd3t3SIT1Qnduk/rx/3xksUJM3vo=;
        b=xG2QlyPL1W8nPP14aZK4van57jIq++XjYrzpmP3kgKRgs2eeMaCtO9ZdBcpBJbDLWm
         eNJkUy0+mIql5TAz8Mte2MrCUcbby58R+djwbmiEAu6w+NvhracTERsUpbg6wmU6nRRz
         Ma3RJgor6YIrYM74GZPNsRg0Q9tLPUWUwxuQvzj4QkZ3fWkjTjjwheoSLGz0kBOBXD+D
         jojfLhYrchvky5eqQvCJYp0NoNEK7WxRbbRfUFqr3/rmsFBtHqZ3gc51XaS2k8dyV3fI
         Bop0meENtq014D9kPQGFMCR3hmwRTDGaCIMBB7A7hIyimZOfHiaN7fBtNQua1dOVsHo7
         YQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651570; x=1764256370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nc/agqhZHpBZo5pQd3t3SIT1Qnduk/rx/3xksUJM3vo=;
        b=rn+151OFYSEdS5lCEIdf+NIvLEJbAJ2iQ725C1/w4kCRXz3JkZDsaFuCiP1vQCU/dm
         Kv3dMMSJCY2YWq8Mu5ZwUQjhMqS3adrCuHK1LbxQogS4FZK/m8AGLZd3SNFMcdWkwbno
         jSbIaS/SjCPw8PppUs4Uww4p6rURjgHQ2IK5E1E7NnDzqnDa8HWl/RRdoxGVd/bAFsd0
         15iJy9h6wfRBoawlOgKsPvn5LaLD/0MNg6f2H8bmO7/NkvLGe63XlVzhzJAyexmyB4T0
         hibMbA1ZaTKUaEMfVDA0H1d2PvpkdrRsvoWPH3XrZXJALxkM0DotSlw7BhYSEmYIzitt
         5Hsg==
X-Forwarded-Encrypted: i=1; AJvYcCVIHZXneJ3I/t+y93kRMae4bJPKWqzsBVuMJsa+5NdPMa5qdW+MYUmRTPHZY25L6FO1Z7K0Gi3BVA==@kvack.org
X-Gm-Message-State: AOJu0YyanB0LUwPQwC/ezcP4k2Tpy+94lQvNGPFmOJuSHuPDKDnJ5twn
	8q1UDvb4syDE8dDHzzlY9LpSpb6AkGT1p8G4qaPqE4Io4kt8ijGNa6kSqwnZ8uKce2gRDHOFHt7
	6/Q==
X-Google-Smtp-Source: AGHT+IEEaNMCstTJqOLR6fdO3p0rd5Vx9GNO1jJ07YubqwQoWR7BvLPGZfMoQILzZHDOemuyFlxyBYdKgQ==
X-Received: from wmd10.prod.google.com ([2002:a05:600c:604a:b0:477:9c68:bd6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3590:b0:46e:761b:e7ff
 with SMTP id 5b1f17b1804b1-477b8c92773mr32595725e9.28.1763651569512; Thu, 20
 Nov 2025 07:12:49 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:41 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-17-elver@google.com>
Subject: [PATCH v4 16/35] kref: Add context-analysis annotations
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 215322001E
X-Stat-Signature: 516szq1pojk4cg39c44qobnacejtnkpf
X-Rspam-User: 
X-HE-Tag: 1763651570-432467
X-HE-Meta: U2FsdGVkX1/vi633fxZmxfpjtl09OuWXhc0ZoTuhyQqmzcAaHb9I1gqym7/a+x/6Tw2R33zKTPLjniQ89Jeea9xCMVqi122v9ZBDPW0SHX5vr4KWo9A0dq/tx9uhXqHEopp8lYhxDdBGfvFHDnKzx2SEPY+HQiFAYz58y7ygGJK5naA5XDnSRV1LdnLHXOEtI0QcuHomxKEpXMBqdz0FCIHdCCLDNWSRYCCjeolxwoLT19UtMp4Vlc8HZn+spGtIOePCg5EvQcMRBQrDtC3r39uRqJ6MzEDMYClE24FDqCx7DJoJokjXV0YH5NCxYp7gTeDc9k/M95EyveQ9ti/985EETppvWnZUoFsut+/m3i+Se2zYNAyssTXUcZkfb+/B87828hcodOCj3ZoP9bVm1/n++1gCxQjSZ5nxqlaS0XOzWe4Bh/kSF0vHPYyKSdSKZ5vY2kr3b3WUWN1y5gfedL332FKL8y8A6BI+K2p92pV4dJ36czcZ27a0TmPEXEqH22gMvWomz8eZPsTTMF4YDJOqlGsUSDfWQ2x0IdgEn0FYC0KmV/rDXCaM0QrC4tJKZjwvjnUcS0VItYhiTuDxG1hjCU64WJCB++GNIFlq5xgwS6b+zS4490V5iir+3Rx0Ejo3RGl9oojXjNo3uft1xhE3nicl/gvKKuggomKG89/Ep4EOO9Fm2hJavBpK48pA421Vpu4N5Na/3nesp1BJsGxsxjLivUrfDyezjsffeBnIgDmPyBeXhilYySzO4UcNi9Cgw5RHde9PYAfte8+cGCnX5ERlwuwIknZztyrg5LE2P1WEOzINKMPiuPN9hHK6KYjq4ik3TC/3PPCV6Qq3hCj7NyVHwDEb4HpmACrPaFEyTxNuerd01b8EX5X3GSu9HipaZNGf2Q2W8fm43ghGS7Ltcbz5P2e/4cdMtXlurVJFDANZKDlM8oz9Mxjp+PNXVxtHljbR1g5k5g40lM+
 GamGGVCG
 L1wjnPNuo83j7bZWxjXZnwSfmbJvqGbZ897kHtWgvD/L6fgcNK32Op70HbKPqMXIg2g6AypRt/KXA2a4mzOnxlHZKyYqVVWdA+nSryMjZ4vR7MumFpSQcopURCsmdq23YweXD+4lv/a9YjQtNSBnPutIifDF34lK6H8XfmmmVPewXBvAoRGqvgyWu4pZwlJwYg/jTTyv+4C3ThdxVxfJOFGOsPT9vT1+EDY0RtsBJTrMTliwLAKlmeVT6ZVuQiN+hecwXiseSpAo/0BInRnTbX7keH7C5CxZwCEDGNDdAoGWz1J3Sz+3HTXrSplSXgXdRASQNnc9AlwAZseDegu12ZRb05SL7hkRVKeyPncMi9u89HUieqwK1uyNBRFMLg5w4o9oS1NabcczIMGQdzBRZ8AXrnh5h1okVpF/bOg2B+yOQXEiWD6HwuC5t/nZsaieivW/+H0CQeV/5FTvfOHg+uz0kRsA15VfWJ9JJnLkXgdIYrSKBaKW9iVO77yJ/p0ZVmzpEuHCpbQuYC7wk79C6VDOvdOlcubKiKUlEl4eY2OR9ZO67ZSTN7oMaj3Hxubs6twSr4QQ7WRk0nKk9lx060199bhR8AxQbFTJjshFquiItgTRPFdmU0cT1EIkiDbKIIFFk0i6G6L63ISCDkXCoSPYCPg4qBwWPuTCyOaEMsMnz/e/s5iszlPE5Flg15IydhWpK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark functions that conditionally acquire the passed lock.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/kref.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 88e82ab1367c..9bc6abe57572 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -81,6 +81,7 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *mutex)
+	__cond_acquires(true, mutex)
 {
 	if (refcount_dec_and_mutex_lock(&kref->refcount, mutex)) {
 		release(kref);
@@ -102,6 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
 static inline int kref_put_lock(struct kref *kref,
 				void (*release)(struct kref *kref),
 				spinlock_t *lock)
+	__cond_acquires(true, lock)
 {
 	if (refcount_dec_and_lock(&kref->refcount, lock)) {
 		release(kref);
-- 
2.52.0.rc1.455.g30608eb744-goog


