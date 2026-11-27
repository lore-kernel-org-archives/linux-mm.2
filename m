Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F74606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tvMUcPVe
Received: by kanga.kvack.org (Postfix)
	id 40E196B05B2; Fri, 27 Nov 2026 18:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E53E6B05B3; Fri, 27 Nov 2026 18:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3B66B05B4; Fri, 27 Nov 2026 18:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3CCD6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:00:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 787D240536
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:00:24 +0000 (UTC)
X-FDA: 85482419568.06.DB1B98A
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id B9F6780017
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:00:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tvMUcPVe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795820422;
	b=RmweRHUDa89IINtIQBCzN6A2279lcCLsMCT9H0qlkpjrzW+EYfWqa9fqpqQ9oVH6QJYgwO
	hUwuRAIMPiBWMLynSvymgQLpLv1MHwQSVbJWDpP4o3FxEYJFKbYXKGZZY3XqF068YHhehC
	vSoPdYu8fkGN1sFm5/QmEFwMeVsoaQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ar+S5jk4rHH2V7R/Ok+7bDPoVRQ9mGkSVjC3XjNon4Y=;
	b=1qPRY2cOB2ooTJp3ptgzET6QJxolC0XtbczceyWgf1ZjICwl3T+fJv3yadkA9oA2ub+fWw
	NznGZJUoScOXVtW9WnN3kQZMvx9r3dfAALaLAgyjD4Q8bu3/xd7dL/BhNMm47Cvhht6oi9
	x/1YebhiOvpWGu+2IsExL2IE6PIWFUg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tvMUcPVe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-92123f02faeso89760876d6.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795820422; x=1796425222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ar+S5jk4rHH2V7R/Ok+7bDPoVRQ9mGkSVjC3XjNon4Y=;
        b=tvMUcPVeqncVQqq7XNEjI+N8FZn10ZpKQ+bkT7/dDb7Zk8utUxfZPNqn8NMXdICl+O
         Sk8nKZkl8h8wa+1p/eKFu4y/2JiyLiHoNQzixbLbZZIqrY640/slCVf44nQEJy+dYYks
         UePQ/k9U1oFaLxKFvxUSUnPmUfcJ0R1pX/N/Mv2ADqc2QoUFzWisGYe+1954wbarWWci
         lSoHZzAQoDRYnc2P0LfROrbF2bo7xJcp70PCtZhc2ArTg5PbJumzY72oyYCYPc1nB+pl
         8dVbHCltZMXff8EN3LL5Skli2yeFiY/t/HF1Cljq6cwA0Z1qfi1tPkxsU6XI9aJMW3kD
         hzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795820422; x=1796425222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ar+S5jk4rHH2V7R/Ok+7bDPoVRQ9mGkSVjC3XjNon4Y=;
        b=xzh3DrURN58JiuazHhEoYh3opUATERxn1lFnZmdC6BsoDFz2/6P/7HuCm/mOCP2b7G
         gpa8T6oi81j13NWfyI5YPfyoW5GROknPxoqU/usrqMZl8y3fgBrFeuADcbHesiBJH5fz
         QzNCyT3uyf9vRRgUYKlgI36hXxPHcAMLFJZCvqbOx3o6LOqUOIwcBF1Iw0VP9yN4TxWi
         YnDVHuFtUSPm5KN9uI9wcz4ReBcCv4wmWEZp05TqJ1Vc90mt733614rWOXNRECMNnjm8
         E2mieBQY+Tt93Lg9j/vyUbXnsNd/uCz8rpCvXnarBLe8cQjksvVs17DVeP13YwNmjKUk
         ytqg==
X-Forwarded-Encrypted: i=1; AL+hErFN49Oy8RDMYLv9jnXWdBRMM5pNa6D6S5tKsFWxfd4zvZa23w8gJ1UihmaYEVH8E3eAnI5xdxUB0A==@kvack.org
X-Gm-Message-State: APuU4Z8bRxvzD9WAeSaO/fKeE28kMzok2dBWescTKs8jQ3PIjKCJenG/
	vjPvPpCGVSniEbRqxJJ0al2D2BpeXto6KV3a6tTqfwntaMoqK3cu9bYJr8z7XuLb
X-Gm-Gg: AZFdTZc5Inhltvv3ZOFxQFUxFe+ns0TLkXz178ZUw5vkXhzValYH+hdiRLmSXr+XThP
	/7ZtumHKn5bvJAVO6GiTr75B3Y617FzPKjthLv9EJhE2o1ht8zkef+db5U6wV1i3pyQvumwQfMm
	NMh19xg/q02LQmCTLfRQJi9vehaNsSjNLv5BcZwsjDNmQwouba8irBAEAGvaToftkVSihNCaqvx
	vdgaWu6iPUie4NSnkyhW60yKJ6dO6522nttu8xIliUZ6RojYhx4NUPQKQEF7gHPthZhQV1dcahB
	tyUB77FdFBD61mtZsQZUG4EcMuzNO7vFjhCuyERmi0//s/47LtNtGKsUEoy/sy35Z+8URMm9GjO
	+oSU0LLr0LeCMyqc4HiF95bGBlJRizOQuSTa6NuI59IbbCrYFCZKYYU9eEm00zxFVJFdFoON4SX
	/9EuRVw8qPshx6j2NEmT2fqvioqzsRQ4Nyn10CYbk3KXqbccYfKO3bbJn/OJ/Nd1e24Y9J5Zp1t
	YIyPEOiKphJzPXGMH1YQyhxOpI+1wCusK561wsFZW+05qa0ogJ7PaC5xzc4XQOTMW4BpZO0idO4
	TB7bSV08SWxq8LMaboKtUQYHGofvAy51kDs7Qwq/agv2TwCSqh7FHtpJo0jMf4+WYsmvVhWoEvl
	R2RVcibYgOoXCyEL1eZOMeCkBtfJh1A==
X-Received: by 2002:a05:6214:1242:b0:91e:a545:691b with SMTP id 6a1803df08f44-92134b5a208mr465954136d6.56.1795820421643;
        Fri, 27 Nov 2026 15:00:21 -0800 (PST)
Received: from localhost.localdomain ([71.18.96.11])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921787fd72asm88678026d6.12.2026.11.27.15.00.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 27 Nov 2026 15:00:21 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Greg Thelen <gthelen@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yifan Feng <evanfengff@gmail.com>
Subject: [PATCH] tmpfs: reset the memory policy on remount with mpol=default
Date: Fri, 27 Nov 2026 15:00:15 -0800
Message-Id: <20261127230015.30733-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u6tkf7ihdfgds1pigaacctfkrfwez7xj
X-Rspamd-Queue-Id: B9F6780017
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795820422-910627
X-HE-Meta: U2FsdGVkX1+/2G/ouDYG+XjTfPw9Dx1Y79n5HRXjqwZ8rGv4PiZcNNlyL+NvHQpcbN3OGOucN8+cFClyDrp1FRBWE9oy+SgQ4Jp+4xdnI1VIGskjops/mccwChbw77K3msGDLH9YHrC+0s2GE/5Q5FpMCvuSfn3Jfp7iR18tJCdV8UcFtoG4OEvS/WiUB2x8HOLT2jx6+cQFeXJxa9cotQnwEBJBlEm7mnJMYf8FBtLTWDxp7YYNXixW1BhlYQdod8/8pEPwGIVZtWO7k65aZ5rnmVnlsO/cfjTIwqOOVogHURwdVv4iQXF8+578+dhp978OShvBeYI02Lnyfa7M7HQ3POfGv+gcDDbrqSPIdSF/rmQOwgwJJFX82dXTsXddC4VKXirHiLxOaKFi8/P+gFK6IBnxytvRNOir4jsxHIEcIaL1R7jwKNl6OWOmUDaLmvjWTEhgsDKyKesY2qDGTaVpwckOjIWcFvV7xQvePCfFPvqoJlqnaWi0aLE/RJxxypMUbb60cidVlDSD62ekT1oOojkrCKqhxh5RG8DDCQXviu3DVdFscotYgOlzJAWAFe5voL6AJ+frOvx+a2UumYH1QnfNr5dFzxJspYTc6tjKDWycUibRWfdJ3Cf98CVkUpgt86mPwk1mEd4um+exZxPVBO6pdeyTsxxFAlmQrpXM4LrktOMTUNuH1L4RqHroUItg1JVRkExt1hBK8CWBfheCMIqTreFXQOKT2COdyRzISWflYr1++7AHMR7aR+RPKKHHzjoMwjL3pFbpzO8ipjYFZWqPS6VBjxjygngLaDGM2x36m7c4ND121qUpZSP2tJRd4QdFyNI4fxGNCVH6QY5cV+/5Tq1eu3bATZ5Y2gQWax/gLnuT/9lLVxc2r4ta2xdkgJzYuYLkjvgxHsERkbSDVDSiL6nVyw7b0acz9971nrx0e0lBkVHZyZespcqM0tTxReYsDerLt808nU5
 omQdCKsS
 egAJJaxDudGpbruu0NVr1W7pTcWovCQrKAb7vH1TUHnILepeIB5jkC5IfweJaQa/fd5k5yKM+mdK/MFQl4mYSHonoh3TRtuSWBlef/r2CDKwHiw84Z+kEszpWTNmufelQZSISI5Yv9v7S7+LPMElk/Y2kgQP4aTR/h6eIuoxbz5zhrfMWl4/Vy2bZz7+O+iWZqlEjkMQAfn5a4BNph2ugjN1czcGri1kHaosoolevmV5BCTgUkmYS6jq2qvvtG7m5BSbqA30NvwszYliYL0Ycf+HLyHWY8lu/0SoDcFVdk2Mj2rLi0jFFutfa4UAZsZ/KmWvWAuVf3js0ZAtasTJ9h4IiAHG83GIAZu5eX7nlYzxJu7K5wVQEEc8oSo65ul5M0sgjXu9jrxaDGmP9Wr5HVrEKgUk98wtr4sLilf1cr71m8pNzL298s8o2R+++n3nn46RdF4Af0Ekh+U7ShgKymVmRFDWv83CYEL9g+wiRwcA8lQaDTnKWQc0Hqg1uNBgJPbksg9j76WGyp5umEHmiD1ZiiPjXdmHZEEWf/F9ydDG9M8CKwKGfvpQiqki5geCxd4y/MtYi4HyS1PMrmuWCyM8po8Xj11weB/bMk3Bbi2oK6cdQZnbG9oe6f2OVDSPq9045
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mpol_parse_str() returns a NULL policy for "default", and
shmem_reconfigure() takes a NULL ctx->mpol to mean that no mpol option
was given.  So a remount with mpol=default succeeds but keeps the old
policy:

  # mount -t tmpfs -o mpol=bind:1 none /mnt
  # mount -o remount,mpol=default /mnt
  # grep /mnt /proc/mounts
  none /mnt tmpfs rw,relatime,mpol=bind:1 0 0

Record that an mpol option was parsed, and replace the policy whenever
one was.

Fixes: 5f00110f7273 ("tmpfs: fix use-after-free of mempolicy object")
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
---
Tested in a 2-node NUMA QEMU guest: after remount,mpol=default new files are allocated on the node of the writing task, and a remount without mpol still keeps the policy. KASAN and kmemleak report nothing over 1500 remounts.
Found and written with the help of an AI coding assistant.

 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a5713109c843..48d1eec43007 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -134,6 +134,7 @@ struct shmem_options {
 #define SHMEM_SEEN_HUGE 4
 #define SHMEM_SEEN_INUMS 8
 #define SHMEM_SEEN_QUOTA 16
+#define SHMEM_SEEN_MPOL 32
 };
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -4905,6 +4906,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 			ctx->mpol = NULL;
 			if (mpol_parse_str(param->string, &ctx->mpol))
 				goto bad_value;
+			ctx->seen |= SHMEM_SEEN_MPOL;
 			break;
 		}
 		goto unsupported_parameter;
@@ -5117,7 +5119,7 @@ static int shmem_reconfigure(struct fs_context *fc)
 	/*
 	 * Preserve previous mempolicy unless mpol remount option was specified.
 	 */
-	if (ctx->mpol) {
+	if (ctx->seen & SHMEM_SEEN_MPOL) {
 		mpol = sbinfo->mpol;
 		sbinfo->mpol = ctx->mpol;	/* transfers initial ref */
 		ctx->mpol = NULL;

base-commit: 822ba3a89c7896b26e4beb70e2ebffb881924dfe
-- 
2.39.3 (Apple Git-146)


