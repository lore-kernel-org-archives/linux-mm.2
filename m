Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76F5CE75445
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 09:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91D56B0005; Wed, 24 Dec 2025 04:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F6E6B0088; Wed, 24 Dec 2025 04:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921456B008A; Wed, 24 Dec 2025 04:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3F66B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:44:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1152B607BD
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:44:25 +0000 (UTC)
X-FDA: 84253879290.27.CFDC40B
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4AFAF80006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:44:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=emvD1cIc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766569463; a=rsa-sha256;
	cv=none;
	b=2AELcU0y14PsJbWvXK1QCvK+y5NyvSEXdnbJJS+51CUsVukOk+SSmj4K8PM7+8CC//NTY7
	snfuSUlKOOvRFqtLtIi6dqdnc0nl2QaTwNIISbxxd0munY+EoTLLuqCkexWwuJimNy0ZRd
	E7dWl6nxjn6HNUzWiDZacWFeoabwiqc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=emvD1cIc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766569463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XwW3zGmoJido1NdKRDHBQzXTcMBYtO3Qi5hrufVJ6PM=;
	b=o/eM0WKJmfqyXkCneWGVAVmpNz7jVH/tcIt52OEarF9Y5Lrcbl5mYJ+LuBqYjHiewlaZWy
	6GubBTrv1sUlUonCBY1n94Ly3XMcWgO7GYVzujAjQ0eZiizwBo5NVr4s1s2nltQwzbU6gM
	9skPgZX9m9Kp2Ll1n1F8yjcx21B3pt4=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c84ec3b6eso7457757a91.3
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766569462; x=1767174262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XwW3zGmoJido1NdKRDHBQzXTcMBYtO3Qi5hrufVJ6PM=;
        b=emvD1cIcWntCDKLKX6KA+YJ14W866PiXWXI/uxxwQRwe2YQAfopf8kkPMAZdNyxnf5
         JYrGDJ6ZhsvOjCBEEMASiQDapPROK9kuCCUzVxhfyrC+yHoou98W5uEX2Wys6zQL9TVk
         yjZ3vrNoHRe0CJBTMBNKJpG2LosFsjlX1yJo757a1fSJHSe6p4HG8TB7hRuluzbaHveP
         xY4Ma5S8DpAkHQxi+Kz46g3591OwZIGD2CNcq/aYPFhQgl07Srq0LnmrHDKAYVjq2O7B
         lvRoMeilA1BwvORnZlXcVz/tvN5CnJB9+MQf/qq7BvmZGuadZQM5bhKmPy/kQROe56iR
         lb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766569462; x=1767174262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XwW3zGmoJido1NdKRDHBQzXTcMBYtO3Qi5hrufVJ6PM=;
        b=hCFY9hlGk0MdYwQWmMAvVYJ5i9ZRGdqxaI9e7odFgfH0ahPkbdTCxjFT+8mtOQ28gu
         taNGWW7HLUiugLOsy8tWoXXBF7ZXFj4HVLxZAPNOnJNkG+RXKG2chlFVp2TuBYFSz42x
         w9JTOOyB+CW/SsD0QJi+XBrwdXWXegnemPAYzfC+LKWAGq9SV+4+1W34tduYppc47PxW
         qO9MF4fLtFSi70sm1rKCscAjwB5XOX6Nbk71DTsIlQW3bc4gnySyy5jwiADo48gLqy6T
         fbrl64EE/sJQwcs3or3rHantp+GgRgU+h2/fZj9kGB8hP5FaWzxZcZfw9wwRjzr7xqr/
         137g==
X-Forwarded-Encrypted: i=1; AJvYcCXlKn61GxaFt82GP12KN8jmk9fEFiKZ/+nX6IRXl7+Pq+YcyyjF9F9Yj0u5qkjRDF7Uwx72elF+YA==@kvack.org
X-Gm-Message-State: AOJu0Yy0SfRkE2hkeWERY5/37YOlsOOR1rnuyTnViNR14S1YnklMevVf
	RSgpcKCbkCrr7g7MmVXzBKnpKKM04slRVuHn52cHK8yA277j+wyYZl9V
X-Gm-Gg: AY/fxX4XT+JAW90/exihxjEfMTaebvKjf11KD+lZ3lmLbU2Rimviw82s+su+u2SXAth
	9jcHoyXSC4DsnLCLpqscKUxwEq26X/gm8mriGEM4aA4MwAxwyzcJp3MtGA9HftySRMsWCCGBjJ0
	fPKRFLVdj0KJNd/kSf7X7r8wOJNpQ9lQgEkM5rhsd2cYc7L2/6DF1erL6pDSc159KhmgOz0TmCS
	w1v8vVirKrMqX3bN80OWIWuF2rqk2GLvO4BbnIuVfuzJTx9nVX8bQTgcTsNCzXUx9i+WYG4w93q
	GtVgeHWgs6D1Fb/DGfpEBM1xQO6J87B4QebBzK12RMSXx5ItKt/nPPHBG+k6E7clv9Y8xchJOhl
	Ms26Ous9cpSEAbNKQ62jnfZIheTzliRETl/XAbaDnSRUgnmv2ZAyfEfqEw5ZwHiElinvfkB/g79
	A0+2baTbtnk/SZZal67z2QlbU=
X-Google-Smtp-Source: AGHT+IHN3ECYoL38/RYPhmxeue2NFAbQYQ2jKvyiV63B5EXhu7w16jAwi+WKbmwwD5y99B9uIOUvaA==
X-Received: by 2002:a17:90a:d406:b0:32d:a0f7:fa19 with SMTP id 98e67ed59e1d1-34e921b05d9mr18120936a91.17.1766569461679;
        Wed, 24 Dec 2025 01:44:21 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34e76de1e41sm8869208a91.2.2025.12.24.01.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 01:44:21 -0800 (PST)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at the damon_call()
Date: Wed, 24 Dec 2025 18:43:58 +0900
Message-ID: <20251224094401.20384-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AFAF80006
X-Rspamd-Server: rspam10
X-Stat-Signature: apb9uhizeymz9juo8e7roaue3wfw7z1i
X-HE-Tag: 1766569463-402272
X-HE-Meta: U2FsdGVkX188+fQutoOFzwZve2qml+3nqC093Tmfuojs6Tq3pgrda2uPdjPQgp7+xYlmoX20tZ9fKr07dkWaSWiloKdwsnI4t6g9n0mxIXce/999rMVFYp9nkYi9plakqYCX04/mXHGREa0DO6Uqdgyc9xc5ti3oy5LlnwJB8L6+O766ooO988L5Qo3+ULJbDPwuugcimIqEdTSzK70W9zpDSUOmw6R7ocBUx1Nrx8X7+eJHFvIqZhbk3MN5AeZlWPfWUf1O2gKGGS4yL4RO3TEQ/vDHeiDvBXIQwvPKJ+7NH1XfSAe3u6nqgZaTg7ubkcxo4NauQ6K27F84Rm3441TYMTpidLhwP+Z070IAiGRKSASwlhh9VZVyR7wiow5r5EDiL5kGLEt4OAy29+5lWKkdEmhcNgTfA4mVhRhwkz1FpUApMAj6LTWnT7bYP46JTreWJiQ7+wkX6A6Y5ZjzF1ExRtu7lL+yI+yKOiX3Q7gXWEXLJnJYuFcX94D8yrEogTG4gB7DpVLynnwbrNbQG1u6VE4Gbc6TmPhESMuhaL4SNv7Ra+86AvlTVWm4gPDyWi0gg74GpP95xlPofxESdN5iL2QErniCfJ8KAruTymRnqHSXlLTNEsWIbmZ1jXvRWZxv/sqeBuPQpU/U52gwbJNrFk6NKyj38sfnE03URw/KVQme0mdVfXh7wck1JjTRU5HgZT8xWea4KPt6pXC0SA9h1ZEMIIbkLO1O0u87iuU+eOu9KtN7hqjjWqaAW5Ska5OHUf3+PQhNJ7EE1Yo9f0KzbYONavuCFJUAAVfFKCmdc97E5GcKEAutNPEXsqriAeI6fOuk0z+LMOZ6Uhz8b4oBDDd2hCKkSnOl+pQjzLzbGY4nGp1rSTAuEZ7zSbepcFrbYcyBvcvjwCKo6bGsUEKqFFAR0xYenNVsrQ1rJEDocKYZ2yOoDUlwm0I43EHl7MOgvYTNGwq0sUQ3JuX
 Wb8GQB/2
 rqwEyYb70KkllajQxrVu/E5+tYssqgih0/GraJbMsvFjFd6bMK6lSYyrJ9oFDq6iw7aFfBmbTvEEuz3HQa5WN02gMVBi6VQvjEH5k9HwqvJJDUMw114NNcPjGojf0tDprcegJj6oUT2ZClVcF2HperM78+I7Jf2q34jXEyE5112FhFj1X1wCs9kLiM5UtIsjgrXTdILLfIzIYvLcNMhwhB5rlcxguIrWlmPJIDwpa92zwAfsQi7SqtSFn2cc7SfH/TV/JIHPskMDUMb7fo4jmjtYRtVL+OpgU9yw97soE3PdS/lH5cYXImHLU7t5nM97oNRFRFz0IN6z6g4SyKCA6dV2v6by877Ha4ra1LkSJGYgDqcZOIFIoV9baYHBwGgtOqGNLd3xTRa8otYSxmfiamaGXGuNVhm2BDLb+THwFo4Uc5huQ3ZmB0RZooZlbwbRs23vTFtNSsruBOYU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 cd /sys/kernel/mm/damon/admin
 echo "off" > kdamonds/0/state

 echo "commit" > kdamonds/0/state
 echo "commit" > kdamonds/0/state

If you repeat "commit" twice with the kdamonds/0/state set to "off"
with the above command, list_add corruption error occurs as follows:

4-page vmalloc region starting at 0xffffffc600a38000 allocated at
kernel_clone+0x44/0x41e
------------[ cut here ]------------
list_add corruption. prev->next should be next (ffffffd6c7c5a6a8),
         but was ffffffc600a3bcc8. (prev=ffffffc600a3bcc8).
WARNING: lib/list_debug.c:32 at __list_add_valid_or_report+
0xd8/0xe2, CPU#0: bash/466
Modules linked in: dwmac_starfive stmmac_platform stmmac pcs_xpcs phylink
CPU: 0 UID: 0 PID: 466 Comm: bash Tainted: G W 6.19.0-rc2+ #1 PREEMPTLAZY
Tainted: [W]=WARN
Hardware name: StarFive VisionFive 2 v1.3B (DT)
 epc : __list_add_valid_or_report+0xd8/0xe2
 ra : __list_add_valid_or_report+0xd8/0xe2
 epc : ffffffff80540bce ra : ffffffff80540bce sp : ffffffc600a3bc00
 gp : ffffffff81caec40 tp : ffffffd6c036f080 t0 : 0000000000000000
 t1 : 0000000000006000 t2 : 0000000000000002 s0 : ffffffc600a3bc30
 s1 : ffffffc600a3bcc8 a0 : ffffffd6fbf49a40 a1 : ffffffd6c036f080
 a2 : 0000000000000000 a3 : 0000000000000001 a4 : 0000000000000000
 a5 : 0000000000000000 a6 : 0000000020000000 a7 : 0000000000000001
 s2 : ffffffd6c7c5a6a8 s3 : ffffffc600a3bcc8 s4 : ffffffc600a3bcc8
 s5 : ffffffd6c7c5a6b8 s6 : ffffffd6c7c5a6a8 s7 : 0000003ff3f32794
 s8 : 0000002ab38c9118 s9 : 0000000000000065 s10: 0000003f823a5cb8
 s11: 0000003f823264e8 t3 : 0000000000000001 t4 : 0000000000000000
 t5 : 00000000fa83b2da t6 : 000000000051df90
status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
[<ffffffff80540bce>] __list_add_valid_or_report+0xd8/0xe2
[<ffffffff80255c86>] damon_call+0x52/0xe8
[<ffffffff8025c9a8>] damon_sysfs_damon_call+0x60/0x8a
[<ffffffff8025daf4>] state_store+0xfc/0x294
[<ffffffff80dbf1fa>] kobj_attr_store+0xe/0x1a
[<ffffffff802f070c>] sysfs_kf_write+0x42/0x56
[<ffffffff802eef4e>] kernfs_fop_write_iter+0xf4/0x178
[<ffffffff8026545c>] vfs_write+0x1b6/0x3b2
[<ffffffff80265782>] ksys_write+0x52/0xbc
[<ffffffff80265800>] __riscv_sys_write+0x14/0x1c
[<ffffffff80ddf124>] do_trap_ecall_u+0x19c/0x26e
[<ffffffff80deaa38>] handle_exception+0x150/0x15c
---[ end trace 0000000000000000 ]---
-bash: echo: write error: Invalid argument

The cause of the above error is that list_add_tail() is executed
repeatedly while executing damon_call(ctx, control)
in damon_sysfs_damon_call().  The execution flow is summarized below:

damon_sysfs_damon_call()
        --> damon_call(ctx, control)
                list_add_tail(control, ctx->call_contols);
                        --> /* list_add corruption error */
                if (!damon_is_running)
                        return -EINVAL;

If you execute damon_call() when damon_sysfs_kdamond_running() is true,
you can prevent the error of duplicate execution of list_add_tail().

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
---
 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e2bd2d7becdd..835703c65c12 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1686,7 +1686,7 @@ static int damon_sysfs_damon_call(int (*fn)(void *data),
 	struct damon_call_control call_control = {};
 	int err;

-	if (!kdamond->damon_ctx)
+	if (!damon_sysfs_kdamond_running(kdamond))
 		return -EINVAL;
 	call_control.fn = fn;
 	call_control.data = kdamond;
--
2.43.0


