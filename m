Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D62D8D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCE86B00AF; Fri, 19 Dec 2025 10:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FC86B00B1; Fri, 19 Dec 2025 10:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CAF6B00B2; Fri, 19 Dec 2025 10:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12E436B00AF
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E093A13A611
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:31 +0000 (UTC)
X-FDA: 84236647782.29.2C6A15E
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E61240010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XzhRJbjI;
	spf=pass (imf12.hostedemail.com: domain of 3VHNFaQUKCKEFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3VHNFaQUKCKEFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159190; a=rsa-sha256;
	cv=none;
	b=3elkEnJ7L/zneANELXGOFBwXVg0qrPelYxfH81z7JfLQzXghbrvr7B8hqPUPy+BExjW9Jn
	XPoTH6Tdaz85OrBC4zG/AkGwhuUUZmhZ04gNBY8kUKahD2gZKxs7P6PSIbYoEitlKIJUxu
	UW2w05iK3jQMqi6lwqlIukNCfJuDvPg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XzhRJbjI;
	spf=pass (imf12.hostedemail.com: domain of 3VHNFaQUKCKEFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3VHNFaQUKCKEFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNejWFdtMyTjodgPbCP3MYwy/kg9I0zeQniFTuJdWnY=;
	b=jslHOI9666qfNa7dAJ4T2pw/4Bk1I2qerJUsFRAWEjY8FMrNY5rcXjawdNelFV1HrrrRJG
	9XoLX7PjcCB/m/ErxFyUFP/n/kmjlve4Lj2JO6QXXghPq3b6X3jFqXFwGSWliuWTRqXwZA
	aTASyWCA9QZeyKA/BB7X+amZ9jO/oR0=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so13285205e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159189; x=1766763989; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JNejWFdtMyTjodgPbCP3MYwy/kg9I0zeQniFTuJdWnY=;
        b=XzhRJbjIKtehTOa+qGYv46We9C7IH5DfsLKhWj5ifHhXBl4cKPHx7SJsRzELjeaZnL
         mJIKj5MOilTWla8y+j6x+FLvnMKqVkA4OD19hT7lgYt1xJOvF3NeXy1XJbVdnpdLdt9e
         +L/9lMKG/C9Es+mMvbPbNsKFy4tadWmoB3OocG6s59PyLvfAQq2ZWQU7ie1H3GFpRNeG
         vcCn2vMzRkCHz8ZwObSL8meY562D1uxwGAulSnycTtPbT6iydwQPO4ItB+DXb7m/v8xl
         oA4gktjKimts5BL8T9Kt8Mx4RixSX/qI3NVN483FgZvdOv/HRqbqMdqfsWL5LP16le6z
         5AOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159189; x=1766763989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JNejWFdtMyTjodgPbCP3MYwy/kg9I0zeQniFTuJdWnY=;
        b=uYv4tNyRwQDxTxjJCQMFMFR4hUIdxfq26AAvDqtvUUak+GbaylO2F7DfGrXyLK4s9J
         1Kd92S4gp2Xz0G1WiTeq4egrCFlnK16k75S3VgFZkVw6k+Mfap8TXZ3uY3TSAmbafxn6
         bdadbO42+m9KDlOoDc/tvmM4jVNr0+AaYtWd6jc9W/d19ca5mTATnMY3sK43muERODwC
         n23YVdu3DlDOmS8/i1pJ/2XwfiH9ZdOwFbkNJTub9EtF3mYENxIHQG6q6trYrcMMtmkb
         wbbB1NC1+Uw23o14anZ5wqjhC8sIRc//eNRRo2aqAec0sWf4pa2fxnVHON76+kOWkZOU
         m9cA==
X-Forwarded-Encrypted: i=1; AJvYcCXzhA6G0yMYM5/sdhsaHGCCB1BBIxeDyHh0kSgf/iIm3mL3jwF9Jt2IY67zhzhtrDRXl39XnmW/KQ==@kvack.org
X-Gm-Message-State: AOJu0YyEAt9f6cb1k5j56htVNj9JDG0YSVG0v+cVkIeWtB3BxA4kmnrm
	FwXmb6ZrkjszKGVH+DxW3k99o6vr/m0juRPxu8PpZqmNQK7SPIxUsRv7utWAdLIvpfj+NBoTNcB
	SSg==
X-Google-Smtp-Source: AGHT+IFZPg350on31b7Arj7YO65031V0YGnmFoBhddxYq3gtipYJLlSpx9LZ4+YgVEePmezOZITENNcOhw==
X-Received: from wmbdr22.prod.google.com ([2002:a05:600c:6096:b0:477:7949:c534])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:820d:b0:479:3a87:208f
 with SMTP id 5b1f17b1804b1-47d195aa085mr30273655e9.36.1766159188650; Fri, 19
 Dec 2025 07:46:28 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:05 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-17-elver@google.com>
Subject: [PATCH v5 16/36] kref: Add context-analysis annotations
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E61240010
X-Rspamd-Server: rspam04
X-Stat-Signature: yojse9wh1rob5nusksrhioo4baxcp9xy
X-HE-Tag: 1766159189-167846
X-HE-Meta: U2FsdGVkX194mp37s9obIs3h5lwO83o8mshpfg8y0E8MGPHueeeK/jNx4/auckJngLYnfs9TNtW7EF5yDNM7VfABBOxnlwNIb/e7865MN2dRy1gLqrR6kTFuoZcXUMbvCwU0RHrcHdF01YkN0uQcoAg3jy1wMeKZ1COlA8Een1gds25B0uEuRG6MmfQHLy+iuR0CI7tzo9M2uQ3MvECN8+4GbmB4Avw27yhblaOQhyXrjD+F3GP6FZ3Fy0Wl4Nr5Jd6CtLWRbXWsYSuTUkVboVQCoAtX9TvEZcvTApJNP2XUnrhKd5rXTXwN5451nITbAb+dMIjVhz71u2lVMU1dOew7DsJJQpZstTIT3WWyCRyJkRZqT7QpbcyqjGulhZC1t2ed0XwkKp+Nx3Qq3zSbhb7S7FOrwyCGs0Cghremy+oVoANgt4YSnciRywmXnMKBFEo0zkoHlHKp6BmTWodmBETQ0gPC8iUYRrU9Vu7ricREs+pvkiIS025X0M+c8CHF6pOGvQFFZYGLCcujsUH49hwtkSsrf+JX+qqOp5Kz+7ZzywmqqSvahhqczLuFzSS7nQCgeygj8iAft8IfDLcDSnaFS5E/pjfP9rEq9shPrCU3sRM4unowCoVchhrlVChTdbYW8H/cjyCY+ss1dM/xEribuP/rXBs0v3LAKe8ustCn+s3oN/txydIm17CKKFHm5MrsFCoYsEM86BLfSgOJWtMxQpjWGCPYMbFpmJtzO3Io+NXxlw4PaKDoia7Rg9lGxNJl0sfqi/4idyYdiLkiBM7NC4P1vn6NH+VUS1WJTgS7W2JcdpoRRyjvBUjGtmeB1MMgh5T+nKCy+ZA4hXv02Af+wIhiv979SAsA/YXi4jyjGoxr2rXlom/skxyFdXzHYeM5xCid3mAQIrnvAuU64kv0SjC4y2fW8WuYu/kBCeUp0+UbCMz39cER1a25iuJbpARWXtJdv4nQ25zMBYT
 WIrZmT42
 f5+hBfo3S5ewz4xlBAAfciL1BM9EuK07IlapKgB80j+59HQQEiRkFH7PnCbNXR/c2IcPD8v0N+aGYcRqD4bTbTZI5BbgkijcW4pvpUNOtVVwyuVrN4LbmkiO1XmLrroA8H0ljEpvO7++63hi9B/v1BbAo0SL5dFTZ7Kf8t7vBlTOJOtz3/rmHniL4sqmZ0Av88/osGqbMWxZPzA2JIDPXXwUkW5rlsjpBwmHgTMmIwbmsZSH/r07wPUb9MgqNSuet7rsRFtnhNh47OUa5Yu/08ys3QBLm9TFY34wM7qu9FTRZUwcCVeT7719Q8/CVEZC41Eg8k5MXQf0zzETF/MoRlbPAUM+gat9y1TFJqjvmOZI4ykMW0FxfxOdn+nBq11yQh3qmM6mXws3R2cW/0tduteRkIzIURBF+LHPdSOyNv1FYt4RL089riEW44EwZtPdHHEaNm+WGNxIlVbH6gk/pUuxJBu9Nzcm05pjtsTD4U06XrUkxZhx15AUEqOzmGL+jqb6JbWK3yCqKNF8UuYQT6xTEQPzbvQ5udo8TuG8K9MlR6EozGeevxpBO4rA26div60iFqZRTB/O8cprzUtOAurS8Tmagb92v7gjOY4umOuzq/L/le9wJSD26dWh+8/A9J/93L+Cl98U2eFKZSwNT8kZEkLFYlABZ619JO5RzomooudKobhq0GZVHqwAs/caHv4hl
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
2.52.0.322.g1dd061c0dc-goog


