Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638C6CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427A96B008C; Fri,  2 Oct 2026 04:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8B46B0092; Fri,  2 Oct 2026 04:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C77A6B0093; Fri,  2 Oct 2026 04:13:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04C896B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:13:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BD4C1C35A8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:13:24 +0000 (UTC)
X-FDA: 85276971528.22.5C49905
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id B98A740009
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:13:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RtnL/PuA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of hnkz.64@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=hnkz.64@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790928802;
	b=txt1BuINTs0FqnPCPM4m0Cn0dqGEWKA+yO1VosuEjGXmCrCZMkg2/sNjTih6bvB38FAyN4
	waWouJzOMzTR6jDUNFQpeFYDzynoeLRPWLiD5vk7EXl9bHDFqGdDNWykMgWtckVvQ8VJxO
	guw9YLPuVvZfP4t/RQfbmqfQcAoJW9I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RtnL/PuA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of hnkz.64@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=hnkz.64@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790928802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRkehR6QhzTUqhAnAiS8EO3o0r2RIFdddFBrAAp0J8s=;
	b=xWqexn6zGqNSS9e8fLC3P8feAfmL2D5pQ9vD3uLXWg6f4HhxJxkPlSq5CvhVBhwRy3zkke
	WNl6RR0fZOSEmHsYuAUxErV3qLE3Cf8mHCgvq07+nCbPo/z+Ll1ySdZQDdyp+2E13D3NbF
	1CA0ZpV7uxH/pW2JmdH0h+Vmlp5QdIY=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc797656e36so2606557a12.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 01:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790928801; x=1791533601; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JRkehR6QhzTUqhAnAiS8EO3o0r2RIFdddFBrAAp0J8s=;
        b=RtnL/PuAit5ZUzZkwxD71rjvZ2b5/KRaoaK+JR6fnsvbvEb6OiNpvbZMFxDmdYCgGo
         uBdVoxZXEnfdXACDqBTWMJbpZWpboD+fU1YsMNLKQV+Yx7nTrRuAGVlL6zOau3Bti6Rc
         ULKt66ON5lFfxRglc4vveu8xdrqeRICylJWOzDmJxzrNXNSdC01ru5nXg5C74Y9Eyozu
         fFNPWRbG1gYemH4Nlv4VMsV5xm+ftgynSey8M7kX6OEySQXeD6TIj5090JtVyjVEXslq
         ShJLJnOI8yuqmFKL5A/RF9UM6DHoJMTOYbID6XW4rJbNx0stGZtECXSof5eQwHyvDsJj
         hZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790928801; x=1791533601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JRkehR6QhzTUqhAnAiS8EO3o0r2RIFdddFBrAAp0J8s=;
        b=k+FVOhBTcnoKcHBja35DSRBl4mZ4OC6RsihMDouSEHEP3f+sO4oiqdvlMdEGH0GSSp
         /PbsEXmc723puvMy/DU6LlIzxLlb3h39YHCogQDcskmhfQ0cuzmvTCTZ5sd44Huyk/cI
         REdoMGJ9xHkQxuP0xxoz4Y6fVN9er+0wovDFCXAievw7Lv8E3bc5BeMkrxBm5jvxGkkn
         u9ksiE1vWEIw1WhgS9vv6fUOz0nNJ3K+JptERGo+M+Q+MsnsuP41/kWK4Ck37G5ut4GP
         yX1P1kELrfx6BKNggkiGJmm45FQD2Rmdg2A/QQnOFmoaOFrrGxbw2sTJhDPHU707utt9
         ivUw==
X-Forwarded-Encrypted: i=1; AKwUvBxV89yp3caZxu0fmhyXKRnAVWCuC/ZeuGZpFlMX5c4/bSEDNXbK6G5ZV0TfFbQpEg+E9DERbM8AVA==@kvack.org
X-Gm-Message-State: AFq9FYIF8fy9NFOfo6HSMRg05hch1ypIrc2uN5CiyRRgj1+t1tzvM6Lh
	FdYlarQ3tILYlUx6GpVZwiaox8yS+5jw44iOP23Sv6nSHTxSkEzIyRaAVUZfJQli
X-Gm-Gg: AYBFou3btNSeVH1m+qV4FWEWRcsZibOQtkMryvn9r5D/w3LpFyl5EPmIHxP3KXeGLIl
	eyozbGWq+s33RIF4SEicSH0ZUE5PWTXDiIVb8pa4GOLOrggkVg+A/bk1ZLrTqJF3z+Cg9d2UBdP
	Ub1aaIztreEKLdLaHHGmvXURFDostSENLTs+pK1SqiGq1LugeQcolAJItGCXJ+wMZU+fS7vnSFW
	t35kMPM9P9q6OKgbXEfPXZWg2YO+b3GV8/McTPjrNr1bg31rgH5u3G0EsawYYIR0ZmDyFhNyAor
	azqFIfRo8zO34X/CH1yGQpsI+FueMZs1pcygKlgzBojAUXXW3B0MqJg1tVPQXtpO5ZtKdY4409/
	L8DE3OibvP4hZGdWObbAyU/atc/lWAL655SRzsgyDh5Brg+VCentHkobWXnqvJQP7s58P3+PClu
	RbGU1r4PmcFwVjBfDtWXH9jOL96UWkDANZyS1Yo30bnV5UezlR0mg25bvTGeFJ3GMyooepTmpvB
	r+45Pg=
X-Received: by 2002:a17:90a:d64b:b0:39d:f08e:e6e7 with SMTP id 98e67ed59e1d1-3a6ce3570eamr805756a91.9.1790928800962;
        Fri, 02 Oct 2026 01:13:20 -0700 (PDT)
Received: from hnkz-ubuntu-server ([2404:7a80:860:3300:f22f:74ff:feda:3295])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a6f8525c0esm692758a91.4.2026.10.02.01.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 01:13:20 -0700 (PDT)
From: Kazuki Hanai <hnkz.64@gmail.com>
To: hughd@google.com
Cc: Kazuki Hanai <hnkz.64@gmail.com>,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	gabriel@krisman.be,
	andrealmeid@igalia.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] tmpfs: fix unicode_map leaks in casefold option handling
Date: Fri,  2 Oct 2026 17:13:03 +0900
Message-ID: <20261002081306.637148-1-hnkz.64@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260827152516.805622-1-hnkz.64@gmail.com>
References: <20260827152516.805622-1-hnkz.64@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zue6roi55ad19biocs1z7rawcgnsmuzc
X-Rspam-User: 
X-Rspamd-Queue-Id: B98A740009
X-HE-Tag: 1790928802-214067
X-HE-Meta: U2FsdGVkX1/keQQapzWPbh2mLeFBkMB7Y02sWWNLcVEpXMUVepSHjS+8ESMFQmOa6t6saVL/LLQ1vxFeFQ3fbQWrrkMdOMYfGdQhsQWfqBgE7gZWx0d0V2M2dYodkK5hrGzYqx5LmZ8k+eXyJdcAC7t+KM6F08bEW8DQP2Iu2FxGHwW0pW5Ik+uhXR2rYEOTDjn8+6YGpY3nMAH0w3Qd3rZJNlQ5baBwSJKfeccLfQsLRC889TFTw/+cy/BmOamljk8uVUtIM/Q6XWfsUgdfX5VjYO6eKAVWe9Db1h3DGWT7ld7t6CvXVKmw17iPs3oIagSMadZwum+DdztJ19roDCscRV0eB9JJ8T7M+3eWT77rThJB2YejCohx0KRJM7XQvp1rmNLhOyjCabPMIgltj2WJh4VKXzp0GRlz8A59Vc7E/uYvTzdtMe9I6ENRE9I9O++wkz4oC+BWMknqexByj/bk/AnXJ8+slGgMHgIpiBlXVRjAByYaV64/HApv/sojCQ+K5KHgWgNo0+we80Guww+eW3jcUoXRSqScaHYDyKm/ke6H6Jw6o5pGFaIeP+fXPjop7wiKOOWBhzzolVWxzREOYTEl/h/gI3zHgKN4BOosDFHBwjrrQrd3cTwhS6E09YPKniEWTOQNIaC3pYwC0OGenEkHzilqPIHIn8POHH+LYuefMLAttTF21PZodP7JaPU25GlFKt0iD5PDafvEZv6ipfdPQpGMJHMZ0pHQEc6BYvuO+l2VA+q1RHMgv+MCBQBFoITvZk3QW6YXGrXX7GaJtdVt2pHMJXpmGdtFmZC5SdYFjrA5zS4s9C/cjr77wfjEkQzBvnRFvKxQ3fhZuODuXQXvg4tBPU51pOgVoCi3jm+EsR4QLjZ+MnQce3UbLM59kPRpzjyX/7+wj9IJ1RdMSgCV20jGjNCgAHKmwF8NuX7Fwl1xuVUAZAawCZnUwYQXU0vPImaD5EVcEh+
 avdmf/uu
 FwtAQtWJYwTEfE1wFtCNvafFhnIlZG/AOKpAzOZMPGg3KNWwiF7iefVhJj5q2NxE46dd9KMVnKle4aNiYUTVur77GCX2j3Fi4Vqp23eE8THnRluVl5/0ySGsPoAj5m07BHOeYRsMUbBY7mGOdB8ELOyJE78ZLg2j4y9zQq1rfIU76jssLPO2lPmPNzDE3rOA6uWjupoLc3Alg/qdR0xb1Obd71flrjbS/RuZWmcZOhWeqenhgy2DTIt5zESGl1Cvd1UJmNQbhgWqIM2loT9DPErAYAKPut6o037MbKMDid6f6yTHPKqlQJnLy5uZTpf6xtUjEJqGI429au5xWF7aSYZxsYgIsyPnW9v+DaQvQpUBmu5wrLk/Mnnn884AROgK6nT7gw0UUQLbJt7XYiIpc9jVKTY63p7HqF5pSyFzFbkNJ7Agt0Xux+VWpiV6fEvDdElh+gGMkO7oeImCShDapj9GmEU7nKncZTiagWmRXPDTyv5Polr+dIywhm5yftbIqLxeoKFmXFElLL2BPWy2qQ6AmdOcj+SLS/+EaBCCDo9Y5ve5yWqQxUWwGHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_parse_opt_casefold() stores the unicode_map returned by
utf8_load() in ctx->encoding. A filesystem context can receive the
casefold parameter more than once, and a second successful parse
overwrites the stored map without releasing it.

The map is also leaked when an unmounted filesystem context is freed.
This includes the temporary context used for remount, because
shmem_reconfigure() does not take ownership of ctx->encoding.

Reject a second casefold setting, clear ctx->encoding after transferring
ownership to the superblock, and release any remaining map from
shmem_free_fc().

An unprivileged user can repeatedly create tmpfs filesystem contexts,
set the casefold parameter, and close them from a user namespace. This
causes unbounded kernel memory consumption and can result in a local
denial of service.

Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Cc: stable@vger.kernel.org
Suggested-by: Gabriel Krisman Bertazi <gabriel@krisman.be>
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
---
Changes in v3:
- Reject a second casefold option instead of unloading and replacing the
  first map, as suggested by Gabriel.
- Reword the commit message to describe the remount and close paths.

Changes in v2:
- Keep Fixes, Cc, and Signed-off-by in a single trailer block.

 mm/shmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 848316eaa7f4fb..1bd004c3dde20b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4509,6 +4509,9 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
 	struct unicode_map *encoding;
 	char *version_str = param->string + 5;
 
+	if (ctx->encoding)
+		return invalfc(fc, "casefold parameter cannot be specified twice\n");
+
 	if (!latest_version) {
 		if (strncmp(param->string, "utf8-", 5))
 			return invalfc(fc, "Only UTF-8 encodings are supported "
@@ -4998,6 +5001,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5095,6 +5099,9 @@ static void shmem_free_fc(struct fs_context *fc)
 	struct shmem_options *ctx = fc->fs_private;
 
 	if (ctx) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		utf8_unload(ctx->encoding);
+#endif
 		mpol_put(ctx->mpol);
 		kfree(ctx);
 	}
-- 
2.53.0

