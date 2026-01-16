Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AC7C982D4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18D16B0093; Fri, 16 Jan 2026 10:58:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF60D6B0098; Fri, 16 Jan 2026 10:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F8F6B0099; Fri, 16 Jan 2026 10:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89FAF6B0093
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:58:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E525140184
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:58:22 +0000 (UTC)
X-FDA: 84338284044.03.3113FFB
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3548B140011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:58:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768579100; a=rsa-sha256;
	cv=none;
	b=HnfARmXM0PqVGbIex6jTeff9LvgNauaym9ThfG9e9P2stmOG2OwYWRTp+pHoEuLjrYvM+K
	QUbDxtDd9wYcdfYwk2RdefhsEi9oaefJ0naT3xjcNN1X64bJS1A25ILC/BmjqB/9okAGtC
	PiNA0mnaBue+M7xWRVLPAUP4JMZw5u0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768579100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=pvIuhV9+sNv3iCssx0o0Pe32iUx/gKwQFY7jwtHcvQU=;
	b=5UuDsEpmppZcq+igXQJD/iCbp0BFyqy7pvlvRVydvRJGmoMhNXMdUxeDpawy0a3P8RRvi1
	U1ieDhzIhHk/QNwuxJRzVeZWC3NgL9N2bwD2r76DhDj+/5iIyzTunO43L4ukMQyqQDrwEm
	EVr6G09eEtNAUnkwk4aBADLoe0Kh1js=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8908f5ed4aeso22141216d6.3
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768579099; x=1769183899;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvIuhV9+sNv3iCssx0o0Pe32iUx/gKwQFY7jwtHcvQU=;
        b=B7pUzwY4/rOJYGwDtGuJleYuzZ/4nldjHdEYzVajnyOjQJ+xcjLE1pQQngDULXvAms
         3ugILULus4hLseYhjORXjrdbUOoSNtMTmGQYzAzBF2fLZCXPWSZSWvRSkytPmWA+vmzc
         H+sIi6tMoDLLgF9GEs+VH/4Fpf6axWDLz3Zxy8ODLtcLJQ4RYPiuwIifwG50x4Ll0sDr
         0YgJcT7hAmdqKA/+p207bZzof6DB94JFmssp0rJEXNTPbigYBXTFEOWkLforkp4GdqLJ
         F3VhfoaOHZQbFd8biW2aIdVOZwDXG+xu5VXG+Ppo9LnVoi6qn9KqsyBjqBLWHpqfF37h
         5DRg==
X-Forwarded-Encrypted: i=1; AJvYcCXwoJ/uL42Ihm9+PnVctAgYkhpJKBv0bKypD8B1fp9B4RpMpO1YneH3eZnmlpGWNupzsMT015+BTQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7dJNcNyj0L7gSIjKd7ccmc213ibbORt1abguNQf5cLcmNmQBl
	eq0ua6RLP0LWloN0883EVh1M+ie4VD2EM2IqGzIjqTOklNCVWMpV8sqjma2Mdw==
X-Gm-Gg: AY/fxX6Y5q1kQzJaRTGEC38Xm4cdNSk8hGxN4+vLGirAHRC9fQ5jLSTsYO6TvgDICO+
	b86RT9Pk+JEm9oyq3wj+Qk3RYSxX9s9qyQaHceiXY/z8uHDOPiFkA4wUjQ6YLuaRT9PTuwgU8B3
	ZcDJIvPbhwMlbeDjJ1ROO2UuP5GXioDafJcIgRAAEs8gBUWk6zZOP97ct3SBWN+Vc9dTwm4UTjT
	TLQ41UN7azLj20RCcCBO97PCbE93xsq68BWr5SL86Et1y9U0n9BXRvlKIaMofQyTNguFBOOowvs
	ypU9X/m9lohE86x/DqNNya+ITMEEqziLkgPs/M+31Jo/vop8beYKF85wSBvdFJQInwRRHakxiPk
	7mitAQ1nFzVSuk/epbcCtaddfpXoPiHLlwSKByg9hiMT9WlvdqItQDdzdDqGMOsjfEPs2j0dqkl
	/6yQ==
X-Received: by 2002:a4a:bb17:0:b0:661:1cbc:45c2 with SMTP id 006d021491bc7-6611cbc4928mr409451eaf.16.1768572623144;
        Fri, 16 Jan 2026 06:10:23 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:57::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-661186dc702sm1263388eaf.6.2026.01.16.06.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 06:10:22 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Jan 2026 06:10:11 -0800
Subject: [PATCH] mm/kfence: fix potential deadlock in reboot notifier
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-kfence_fix-v1-1-4165a055933f@debian.org>
X-B4-Tracking: v=1; b=H4sIAMNGamkC/yXMQQqDMBAF0KsMf20gCa3UXEWk1OmkHYUoiS2Ce
 PeiXb7N21AkqxQE2pDlq0WnhECuIvD7kV5i9IlA8NbX1rnajFESyz3qaprGXnt/u0THjIowZ4m
 6nlnb/V0+/SC8HAP2/QeVxSfzbgAAAA==
X-Change-ID: 20260116-kfence_fix-9905b284f1cc
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, clm@meta.com, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3280; i=leitao@debian.org;
 h=from:subject:message-id; bh=6c0reEst+EIZA2PaSJbeOygkyAUIcKW0sGGQ6IOzV48=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpakbN6YhptWCcXUtZJrdJi0Sq9v6y2NypuVlhA
 yll/P7R01+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaWpGzQAKCRA1o5Of/Hh3
 bbf8D/4oIWJVhIsaxEVusMGtLueC27JQrU8Qczg0pBer7m8PD7bV1s+HYYH5xxfhf8jnL+fwFX/
 Y5UKCbWen/HKE7lnSDIjQRFp/XpFIWYk9cMBu1/yItTsV0deSxajEFTHSHlBvGREXJ2gfntDAVN
 pJ3sXJrRxGeKsW0ElHzjSOFrwKeYpDHPMb4s0aXMOThEUZYboel+XK+nB1ulTaP+FkFlBiyMcM2
 hQG6b7KGmqi7hMUdiHUDm4k9nfdNECUObvqOdVyiJ8NOLs5GwyiIFMWvEjxMzHUTTB7a3IyeIce
 oK6u/BNhCT5AMpJf+QHz7DTQO2WfSJOb9rXCqe+7B5x+WiOQDWH1AyNVpLDVm8jo+LYFma+XwKN
 xCOUE9yJlAItKA3dOqNKhYhmgRJlJdRgNlEj2gU4sD3R1IsB4rBx6HLaVWgYYKe8ZAxGPNVE+3q
 KlF6sEG3hSFkc6foQrKPjVbFGqfcwh5yvRjUJ/k2CzRAA5vWGwRXkDcOSiAgFXbi+BW9WeNJMGO
 R+ntiHljO8OBuvxiDFIbPQPYiAPZaOLsgkxsMZl3ySAaavBcVryqykSbLsbyVGVsonEY83pEhoh
 mX9DqV2Q/qGcKbYsBMsGNxYlhe5beqgS7pyFd8rsBc62nZ/tf8S/piARqgtqyC6Mioj3jg3I9rx
 phWuOGd9v3zpcWw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3548B140011
X-Stat-Signature: yzp6wzurnipe7fan8hkc6dkuuxxwx59d
X-Rspam-User: 
X-HE-Tag: 1768579100-12964
X-HE-Meta: U2FsdGVkX1+6WYdH17It5PDCC5NVvYImAY+Xny7UlvbXOSmBGTnopTOIRvn1H/LU4bFbhYoK7HpWjk0phu1gcssd7Gp2sWUJeg2ncwh1DEYGtOR6vOBg9mO42Q2LDLiBbb6BCE+dAaOPl5m+xt8mkl1EhQoWpLC2njgAAkTxjSZLovPiVq+FRpKmbRz4fcYGs4Ta++LFtXmehrt+1ultxdMFmd5QQL6RsoqWWs3tJpMGqn0ayNGeoC0KdD1MIesKx8JiQb59prAdEpqvlprgRVFzGVO2rXJynmUuH7w14pyZ8eezPLFQldkJbgFqDTf4iAUmcvnggUbgvJ+rB2y9MV6y2j0CLGXh6sjpVnLGDk5/koxyluDyojbNELQaiV64mlyxhXiNzLAkga3lpbZXTNHakyvcnZnGhm3LncmwzQ+yG7TqsVkGwUgR1ZAMEX+mdnr/nnnHborK9P2xNCpAiy67km4mxlvQoNxnQwb1/WCOrKCiq+ZRh5RO/Wf90V3WgW9DcvRWKAxO+QYKgArpND3+tL84U0nXcSF2ZAlx2OKYMRXVtUiE+Tmkz2313hSzNQT19YxPszqn2oTmCXSWZNN7mmX6AUoBiBTDBJXiq4XP5mI0zFJBRJypLgTUewd2mc59oBM+kmMG2Tyn1PXe/lzY1+Hq8GEAbFFAEH7v0V8Cjn4bP/pWU+WB4LhH53R9HSA56USiSIP6A93IuqRZrECKz0lortXmQq3WFX+OV1Dfu5qV+4b82/Yv0PRjqTphuOcIEkm3EqIyc4CB5zvpO08/vgoO1E5UNxfm0ol2AH9KW39bqxrQX0xzlBZHF0Az3LXku7xf1OsDqmMnxwVHU4tf61MjiBi8VHreq8lfBiONh7TWFp4WF4Rw0HQ8ts93p5F4axRY3dbKZ7/3w889lW/MEJkjPVe9RCtTpV+k+ZleKqruOdvEpZlV7CvlcSvnUwNZ+I7CnaOSBalW0fh
 0vAtp03r
 2hCm/gdH8SS+mAtUp8n0uHt08+YDDSqvU/tFJhKdnmrDsSfnZCwl2/nVg+c2JNY4epKfvnxL5teMcez8PG+WTFJHiU/dk1OWpqcuPxIKXVqDkM6OukgCWGOBcNi8NRSY0Ri8OeB1xdIzRbDU+AIkyLEqPH3SH4+QrA2N0yK1EHQjERb6JlH9v79nDcMjeKuqEelOkpKvOgpf7aUvyLP4fO/IKcIqO6SMVhluXtq+tHpBe6tytAfKsYRoxYSJrQpGR1QEkMAW/Y9k48kLr+yi+sJ9MTQScmVVSs0Chlz1ey+sYBMUeFdwG049k4SYpLV1Zbb36Eylqs5jKaXDvkLP72tCyjO8c8AFWGAXdV5H+8HgfLU+KjDJ/yvAjshtnZFN8EmBNTzUkxNzKp+wN22x9El9DObqCNSJNVKJDyy1HfrscMiMtKg0TSzI/EmRyANrewTp+99wtnnmQXTjVkqiUoGLX+wg/st7bVnQVD5uED9nranFPBrX4J67Jrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The reboot notifier callback can deadlock when calling
cancel_delayed_work_sync() if toggle_allocation_gate() is blocked
in wait_event_idle() waiting for allocations, that might not happen on
shutdown path.

The issue is that cancel_delayed_work_sync() waits for the work to
complete, but the work is waiting for kfence_allocation_gate > 0
which requires allocations to happen (each allocation is increated by 1)
- allocations that may have stopped during shutdown.

Fix this by:
1. Using cancel_delayed_work() (non-sync) to avoid blocking. Now the
   callback succeeds and return.
2. Adding wake_up() to unblock any waiting toggle_allocation_gate()
3. Adding !kfence_enabled to the wait condition so the wake succeeds

The static_branch_disable() IPI will still execute after the wake,
but at this early point in shutdown (reboot notifier runs with
INT_MAX priority), the system is still functional and CPUs can
respond to IPIs.

Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113140234.677117-1-clm@meta.com/
Fixes: ce2bba89566b ("mm/kfence: add reboot notifier to disable KFENCE on shutdown")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kfence/core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 577a1699c553..da0f5b6f5744 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -823,6 +823,9 @@ static struct notifier_block kfence_check_canary_notifier = {
 static struct delayed_work kfence_timer;
 
 #ifdef CONFIG_KFENCE_STATIC_KEYS
+/* Wait queue to wake up allocation-gate timer task. */
+static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
+
 static int kfence_reboot_callback(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
@@ -832,7 +835,12 @@ static int kfence_reboot_callback(struct notifier_block *nb,
 	 */
 	WRITE_ONCE(kfence_enabled, false);
 	/* Cancel any pending timer work */
-	cancel_delayed_work_sync(&kfence_timer);
+	cancel_delayed_work(&kfence_timer);
+	/*
+	 * Wake up any blocked toggle_allocation_gate() so it can complete
+	 * early while the system is still able to handle IPIs.
+	 */
+	wake_up(&allocation_wait);
 
 	return NOTIFY_OK;
 }
@@ -842,9 +850,6 @@ static struct notifier_block kfence_reboot_notifier = {
 	.priority = INT_MAX, /* Run early to stop timers ASAP */
 };
 
-/* Wait queue to wake up allocation-gate timer task. */
-static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
-
 static void wake_up_kfence_timer(struct irq_work *work)
 {
 	wake_up(&allocation_wait);
@@ -873,7 +878,9 @@ static void toggle_allocation_gate(struct work_struct *work)
 	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
 
-	wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate) > 0);
+	wait_event_idle(allocation_wait,
+			atomic_read(&kfence_allocation_gate) > 0 ||
+			!READ_ONCE(kfence_enabled));
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);

---
base-commit: 983d014aafb14ee5e4915465bf8948e8f3a723b5
change-id: 20260116-kfence_fix-9905b284f1cc

Best regards,
--  
Breno Leitao <leitao@debian.org>


