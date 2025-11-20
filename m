Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49269CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1186B00CA; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981D76B00CC; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802446B00C8; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67A816B00C8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B6861DF9A9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:32 +0000 (UTC)
X-FDA: 84131329464.25.01AFE64
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1FA4B18001D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=df6wNlR9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3GDAfaQUKCEUls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3GDAfaQUKCEUls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651610; a=rsa-sha256;
	cv=none;
	b=pMEiTGCrJN7LVdbrpUP3cWjF41P18RVdUPjFbYaP3tWS9IWuM8ufo+M109I+3R16Wziezo
	WuBYcyfWrKCvovG29QV2BFs+M+wwIxxtLFMbA/iiR+AMac6kTup8vIsoBKZKXAjpPYud8S
	lnb9fX+4KeQUKTeOlWbzW/c07WNua9Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=df6wNlR9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3GDAfaQUKCEUls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3GDAfaQUKCEUls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN628sGqwThlti0A3ZPE5fg7KLj/Ov6I/vXTKugeedg=;
	b=aUKW3YVdMoKaU+wkJXZv9Bqdj68La7BP6i+hd02JX0vjXZlOuoWswGE0pLGjE6sJVR96zu
	8QRSiW2qezwdlEkwGS2I/+c9iuW4bzS6MM21uFn+WMTpaEY7I4fGTcmNivoW2eQq2u7fIi
	pxvoxCL/Tc4B8hvTFifwj3V+iTumB0E=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b735eea0bddso90149266b.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651608; x=1764256408; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kN628sGqwThlti0A3ZPE5fg7KLj/Ov6I/vXTKugeedg=;
        b=df6wNlR9kjCsI+gsE+zUSlZh4yELJCcib8JSXPTIW/+/NfNvRh9ezdwhTmVJmhOS4S
         fyD2KZjPWvCmLrt985I/9GJpUuLdWotkF4qpKkbvLI5cYOwWFNCgKZMmhx48jVBG+EZ6
         dAcoqiN7dV13lIGhWnkVXJibisfTVveQKZNz4/oUTPPw1sMTcAiferDl/fNrGczYt1sH
         zmmsGP/K2srjG/u+bT/nRMSjHkrKbChg5xEcgkqU6Rqy7eUkWH0xOyhaGAEk1xbmKo5d
         6zXV5rFaLnS2L73UF+jrpzqjrT6jMMKlFxoll9sP+yv3tRT/PUDC90MxsPoGgKGyqNBo
         aiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651608; x=1764256408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kN628sGqwThlti0A3ZPE5fg7KLj/Ov6I/vXTKugeedg=;
        b=Ei18O083KmbB9p9aqlfmofMJc3dINr4yir0WdoQG5vMsUU8K/pCS3XTl8RdLJ5b9hP
         GsGDogDCzR4dAS38LY1TZPIA56SxBLy2qhlKKrm5ygKDUcnrtoMr98ZAHrGmxrqB9a6C
         AoOagfbGMr76RYB0yH5WzONM1h0QohQxfjgZb9li0SV1yAhTqciMsU1toXufqBT8v1vT
         IooBIxvWCSsDSgPBe7G9k+GQwDSwdykG//loNTkmEH48LEMWYXnG1xAgmCrsZPBg1Ysx
         ZtwwoR5prt+wNt8kBHSx+L+tbMp56LW1ImDlCPaBp7OINQX133e5TALqwNXend0DOqTa
         xo+g==
X-Forwarded-Encrypted: i=1; AJvYcCV6H3mAoskXq1zhZsiOiZLUw2fXK3HoEk5jySfARRySYll2BJg3YlI2ZvGqQtGckrAWl/UQvrlorQ==@kvack.org
X-Gm-Message-State: AOJu0YxTXUAmMJWl7irkUJWjlRnsu5vjejdT+Rnyy7bRANZeCajmlfzH
	kfv77wFwI6HpSWvN1MwNosxTJuCAg5cIUTZI5D5ADn0LvGoO441RyERS04hVm8uZ7hEMsgMFoUn
	SlQ==
X-Google-Smtp-Source: AGHT+IGPQ40L++aTOvA8JIRy1kdoYShFPO1YhmYJSO3OkON5NZw8EMACaSNJB6l90jTWpiXg4l2yJf3kSw==
X-Received: from ejcwe11.prod.google.com ([2002:a17:907:d64b:b0:b72:63c8:2878])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:6a0d:b0:b76:23b0:7d6f
 with SMTP id a640c23a62f3a-b76554a515bmr362722666b.56.1763651608428; Thu, 20
 Nov 2025 07:13:28 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:50 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-26-elver@google.com>
Subject: [PATCH v4 25/35] compiler: Let data_race() imply disabled context analysis
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1FA4B18001D
X-Stat-Signature: q6qhzpygke39utkq75pmmdnsrcq8x4h5
X-Rspam-User: 
X-HE-Tag: 1763651609-523455
X-HE-Meta: U2FsdGVkX19Vp9cxfhyYbfTGYcjfuXOO5XXxhfuqixgMZdIAiQoNH6xnBXhFcSoqq9bP9QjPi5DlTGNp08RqHewPTE5DN8RtEQFyVs7baD+gAZmdIneGoAyMj75ZtRyozhmLBVZuMe+XdH0CYd8XCYHqcOfRNl+/JjVj1LSi7CrN2/DaUwrS8UaUCVXJAM40Brt15hqAbEoAd0mNZ6mdackg7uE3j/AkKgVs5b2RdR3VRgGee2bdL7DkxRC674AKdVqJOLOdbridivkRHohkrYBTIRZvK62B/LoeAQ9T7vL5HgRpQoF+VqmZEFMKNzIBN9+mAKGfDS1ntNm/gD2wLTNErQ3ke+L9XlVowXdR/D/fG8S6hZ3KjmR4Re0ce5zwSrc1AI6OF7An4WgHFdtSEfwh4/JhMGJ4eimMHulNsFKJlLA6z3ma0Tj8TIkXQ2zzk3IGiHRbg962MUfUvhQoJbp9oVc2D7RPYqqaQYGPAEqAQUWlOxc5IAXCdTL3JhmjgkxKANguTOdgF34HSBA96KcQ4b23noCF/MhaBT6OfMgHL6NZhHvSXO3eNHg1qAPIdt8kIqs6jhswqLZAojEmRFwkbqrfmCFzZYxpcsbcEij0oseYQ+GyjHgYW7PjsjQZc/NMlct3YR9UnmPiDjDYlbbwyYgVEv4GgcQP3kvC5HxT4KFSMKPyNm0pbWtMlEUj+BKAMHiG333hWrHohUeqJLrUGMjcbtksB48m/DMnrP/sP7U3PBXoo5zKmq6GnOBrWAs8+eR6z/nhCcba4OJ9hOPccQ10HCZfuYTGXCDy/zVeqbXbK+7W3HStNOtyBqfU8xkXgvDhdpH6rU17tBu/hAuj0hd3zps5xqstVOaY94vShWg04T0JKiVgUvmR24CvpgZYgo44YrlRITlKyWZCG3qjjyS2QbwgUUwAm43vg0JVDfbEjjOI+mpIwqy5sWPBRybYALqTaxZDirU6XW+
 QCqc8Rls
 HsaXNwIw5ersTTNRXXEgpZyDOnD8rOGvKetyQKwoe3dwtc+mcF2+kcpwlEgkVvxra/GFWOj/r+UXaOCTcH+ODC/Aw6Y9kl6ghYsrKYyRmUWs7Hsc9Fq4HRVhpUZXN2H8JOxf2lMpRMHe6nuT2aN7/zdv2gFwTgBmuLSoK3vPX/wflecWvBpsmVCHqQ/ZE4YB6pq2aqVq+HdvIEa3jxnEhfjKtGKDLLWVoZlLPi5Q7E5RTqrl+gMLsccIOsQgMr0ij6c/xddgyc3nRzZGljVVswidVoNJRTJJb4cUUdKutnl8xFuNrF0CmyzbSb0b1vnwNdWONIH9Tz6zfl/4kdETeUmFqh8L/vgAyFLqX4AP91rBh0WhSsojUwhxtcyKuxhMa6melBqIlIwm0y+JszmhYASWluqk+IIAoM8YtMWSD7BA2ZtGCf8dfmWqlH+ifDiaZBfw5oKopCZG9eaRGTb0iwfzOnNzAlFgKxfRGhCt6zX7U4wCblW9K+BkFnpJYvsharf+Xa9NB6BojPkX+ould1DZYlGyI1UlTertnB4IqERUmoXESmn3xleJ552Gkc/mKtvdtCnG4vCIiJMQAkDegdaeK9trdRlFZ+W2l26j6WT+KnlJyeJ8M9DJaXmQHXVDA8ETnc1qsztYCklGdLaEYu928xnkK2I6Pdhf2dRpJyT8iHRXNEA7Rnr+XMzrz0uHF2txhXRr8cCK+u0y9uSa9MDEwEOzdGaGFtL+2NAECoaa/PX3ElGBnqeIOqLQ3Tg56X+8RDxcdFQwE1eE89X3x4o3BnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Many patterns that involve data-racy accesses often deliberately ignore
normal synchronization rules to avoid taking a lock.

If we have a lock-guarded variable on which we do a lock-less data-racy
access, rather than having to write context_unsafe(data_race(..)),
simply make the data_race(..) macro imply context-unsafety. The
data_race() macro already denotes the intent that something subtly
unsafe is about to happen, so it should be clear enough as-is.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v2:
* New patch.
---
 include/linux/compiler.h    | 2 ++
 lib/test_context-analysis.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 5b45ea7dff3e..8ad1d4fd14e3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -186,7 +186,9 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 #define data_race(expr)							\
 ({									\
 	__kcsan_disable_current();					\
+	disable_context_analysis();					\
 	__auto_type __v = (expr);					\
+	enable_context_analysis();					\
 	__kcsan_enable_current();					\
 	__v;								\
 })
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 522769c9586d..4612025a1065 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -92,6 +92,8 @@ static void __used test_raw_spinlock_trylock_extra(struct test_raw_spinlock_data
 {
 	unsigned long flags;
 
+	data_race(d->counter++); /* no warning */
+
 	if (raw_spin_trylock_irq(&d->lock)) {
 		d->counter++;
 		raw_spin_unlock_irq(&d->lock);
-- 
2.52.0.rc1.455.g30608eb744-goog


