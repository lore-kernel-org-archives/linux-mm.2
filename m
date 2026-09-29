Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3D1DCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 20:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D046B0088; Tue, 29 Sep 2026 16:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97586B008A; Tue, 29 Sep 2026 16:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E326B008C; Tue, 29 Sep 2026 16:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 651A06B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:21:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4BBC40623
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:21:06 +0000 (UTC)
X-FDA: 85267918932.17.22E56A2
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf12.hostedemail.com (Postfix) with ESMTP id 202BF40003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:21:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eQUykKNP;
	spf=pass (imf12.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790713265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zKv2477Z43K69h4lwRjf4ZEKr1l8Bu4ddjI08syiTdw=;
	b=xORzREatKejPKc7nXu0ds5lln4ltuQ4TKj/xQgFzSv1PO9P/GSMbU2gWpu9fAsFMH41ZmJ
	4bQSBK+5a0ub8d/PVgiooS0izjE/c8G8hOLTW7BAl3BoDATXqAGwJDbleTKNfDtqDeS+of
	fcdzytyyRwFbppM6zlkZ98Ube4Z/fPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790713265;
	b=oDv4K8ihtC/j1gnQKS8oBlZG2SoPQEpIxqVtR0qSyXguPSMeeU9Qp2GWE9Q8p68HyRP7SM
	nMQ1vzpooLptCFQD6jr67+70tH7Bk3TBFjLXQEivpkEsG560H1yp/+90vPGDryXrvfp0yq
	I2aHw2mRpBxnKUUQY14XAOeQ7l2TaMo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eQUykKNP;
	spf=pass (imf12.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912e4b11so27494715e9.3
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790713263; x=1791318063; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zKv2477Z43K69h4lwRjf4ZEKr1l8Bu4ddjI08syiTdw=;
        b=eQUykKNPd+x5jyc9bChSIVzEEqbUQAVN8DOsSefpZwSGa7Pux6kTg3wDi2MuUpYy2k
         32S1m23FPPxwmDd8kDc95WX34vlTtXmU4Vh6Eui5r6DQBuWLNb1BDeIKJ03MVMplDBP1
         Dh+jtGQUt973Q7oYFPWeeD+YDqdmxcCNFvsBQSsLdB8GpXa2BlK+h85viy2LXTJP0nd1
         8qNLfYw6zy/DnV683JtJaoCxLl+5q15b5f7w9CRbz5hOSdaErj/uuuQDrlNJUU9+YHvu
         MVBVxm+5/ODQyWsIqadHJCoWghD2TIh6KhHoMlgBvktO3g+8sdQcolZpXYyRNFcb2kGJ
         dnhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790713263; x=1791318063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zKv2477Z43K69h4lwRjf4ZEKr1l8Bu4ddjI08syiTdw=;
        b=v9vknPqZg+0QwlqpD1uJfJaGMa9TJQt9bJnnjj/50j7tDwkpU4kKio6mwngJat6bc4
         LHfZYRYcs6kSKPCs7QBNZpUfX5LVcSswrWPNrJM5pW9JTPKYSTytV6SI51EDHgxB1M49
         n6FRL/pM4eo8p1uHDDKceq7CBGDVodk+7n+02q9/bcM81RnMRbCNcu1RW/2Bdr51E0nD
         IWnCWZtjRNlE9VC7YwoaCa6kGDl55t+kB6Tc6XwJvXjDhLCi9HAvvYt6VRRBLx0aZXIQ
         UceGHu0j+ZO3ZnDRhW6xV/SuhDH2OKhtC07tOhaG1De5UNABm3TiQOfTpJVkasDWzofW
         d++Q==
X-Forwarded-Encrypted: i=1; AKwUvBwLBzivFIqACeLgFDxUu5bmq1Gt9zBPn9vcBDfJVtaWQvdMcnGno8H+j4fNrqUzAvA7Qfq5P3E2XQ==@kvack.org
X-Gm-Message-State: AFuF++luQ/TXAUEmD3EV9Ft4SXbMpRO+oU0xPDln8iINgLrI5gyW66tu
	U1avlQDVNMszV/wCK+FD+fhCcxX2gAox3IrxZve8b53+rOJppO1EHao=
X-Gm-Gg: AYBFou36tcznH4h9x0bkxwlnZMgaHBuqZ3Yw2gWFUfmFCtjB3VZXPz8MkrkZJAWJwfz
	9Fr6z2ERRW1qzROoenWbT/GtQwRpzutjXsl6q9onErwtipghPI7BRZ+/0wn11LXPwk8jvy1v8GB
	FfVkfcbF8HDmcrIQ0k5fI1ngW3ugkDoVt2MkZ3C/ymgaOT6p3b4lsGNijVjprCtdAysMbF49GO1
	fuIEXZvnnZskFkXoGZf3EuucRVrnQr0xm+VJU7StB3+8NXLUUVSaWcF0rvAFT82wmU3mRDNd5MV
	SEMsUX+O0g6nzkoWtdMtboprTzH+b/5h8cvWSmz3z+eh3HSOoTHAX+xdNrMacw/ierN1sU9ErUU
	o5mLlvQYZglZNafxd2WAlpXwzFOhBP6P0OxyiLhuosEAFTE4R12DF+3v0+rDY/zNoTcas6NuE8e
	lU/Ta1vcF6sTH/MDnobf8sUZyOEVK7t7WlJIfHGC69OFCCBwJQDX+SCDR5qo+yxe83W7lwyQ8rx
	raQ6irMoPYJ6rI5m6lc+i/SVUeOEsfxrF5PPHJoro1Sdt3NdDjr6JKMT0L3p2Os01vMTL2ovFJt
	eIb3lVg=
X-Received: by 2002:a05:600c:c494:b0:4a0:1d2:1a8a with SMTP id 5b1f17b1804b1-4a015027518mr3741815e9.16.1790713263399;
        Tue, 29 Sep 2026 13:21:03 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cfe13a1sm102947985e9.5.2026.09.29.13.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 13:21:02 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: gabriel@krisman.be,
	krisman@suse.de,
	brauner@kernel.org,
	andrealmeid@igalia.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] shmem: fix unicode_map leak with repeated casefold= option
Date: Tue, 29 Sep 2026 22:20:35 +0200
Message-ID: <3a57ec70731165b4b1244fa89bba95c82a666df8.1790712330.git.med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 202BF40003
X-Stat-Signature: z67ionfxbrjar1cbawngkp6ztsr3zdm6
X-HE-Tag: 1790713264-542792
X-HE-Meta: U2FsdGVkX1/EiK9sDH4RuVztK8MVa0hpZ/EtLvlitcru9/eapBCi2mFt4vizLwkMADSlJnSFedvoQcZw+SsbIZepPTGd0/hn14nIvlXck+IlqoTEEV+LCNTifIkQnV72RhMPb9tKPau6gQjdep4Kp496klqUxC519bGelrc5CbZG/OGjPaymijP8vx2e0P/dkZHdxSdzON5/I4pTv/fqs3KJa9JxgV4iCUTzC08AuTN5lWwPnF3UL8BQYaXDVOdVD/eW5NOchsu6J/IpByobJQWKKd6HqWDS1WJCWXnN2NdQMX0jqLgkBsgXekjJNkAXETWKHjgAURGCUykKXhxaL+AxldypmM80nRlzckSxduiregQx60GF/r/3uM/fwy4mgD9oND11n2IAOL03cih5jjqcLm6Qg614RLNichmRm7NYtkp3QZKqULNGxFBSd94ZzSbUpkFwsetDAiKAR/nF0igaBBI8717QfVSiIEfMCAKFzxpNJMizQJ+/as4zQHdhpwqXIbwICnyRYVJfMwbx5RMcp6Aa3VrVnIadoKqL+RWF0HdJWnZHJnotFnZux6wCPWK4VODiFupDdfhrKlxBXMHbwaTBtKyQDdWbCCNeBInWztGUYAMivp2m3HSAOz05k++xr86ObI2B5tu1imKwR9GU/2x+5/KoPcmbCA6/iZdRc+sexj7vLvV4iJLncChTo92SB7Ggu4JJlUjiBQ8Lm++/OeJ9QozpdPY1ORuUuTjHK8wtyDopHEhKW60G3c9MaTvJ1oXXdTgVWj1BwU0PTEtjFzfngcV0FLfXQtwR/06L+BnRfaL20P4P0+qkMG0ouxZjXHXPt2JEgP6LllRXJ5BTlnDiraPgTX+eplMilGCPw7msUo8TS+8B+BsPzZ9vbW3ZpYZR/eIE09xUP35Xi6EEvn6wM+E8wUvThwq+bTadf+lQKjfm03549jroeGa6HWxfQobr4gF38CMt0pT
 YILYV/ip
 bwF/ptZmczqVEa2bMbeh/sqsEsJYylcI4YjUwLE0d6Wt4npXVJFmBNm/x7ncCpcOCKF0eUENj5SS5HblTKbpAHvo6c9tUZsuKJ5/hDtaP3jiFTjZu/rBteSIsSBiJGb/gftEbnm3wj/oKocJCMzymkSTRMhN9DzwN6MKRlY2hKoT1L3iWFIcOxIMMiqOa6vcCJ2NlqFVQhWctf1WDsZ6C1Cu3lZqxoh0cB6ush9RJilmmRFxv9FxeO+W2lkrRFhRv1gzlGScoXW8LgGTTulY0q2LEaFKVF9IfODAu2HgcqchGvlFbyeeAIv1C0sbR+RFgefL9hem1nSUqfKAyvuX+IWyaGPxPwP5UCg+ROzrxU+B9c92g+Nvg9nZ70RVHhSDm1ImF8k9tiC7Bk3atqBDiEhS8ErTgh+IszbB31EootVV1LHZI04Y+ALwY1bvpU26uj13P06DkP2xIW8gsIxASBVvEfBn66nbcqI0VvS3u+dXqtSWwX2cze2FMfbynWOczgDVIL7EA+2FeAUrwpkXZimKq9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each casefold= option makes shmem_parse_opt_casefold() allocate a
unicode_map with utf8_load() and store it in ctx->encoding.  When the
option is given more than once in the same mount, the later call
overwrites ctx->encoding and the earlier map is never freed.

Reproducer:

  mount -t tmpfs -o casefold,casefold tmpfs /t; umount /t

Repeating this 50000 times grows kmalloc-32 by about 50000 objects,
and kmemleak reports them as allocated from:

  utf8_load+0x21/0x110
  shmem_parse_opt_casefold.isra.0+0x65/0x100
  shmem_parse_one+0x368/0x510

Free the old map before storing the new one, so only the last
casefold= is kept.  On a normal mount with a single casefold=,
ctx->encoding is still NULL at that point and utf8_unload(NULL)
does nothing, so nothing changes there.

With this patch the same loop leaves kmalloc-32 flat and kmemleak
reports nothing.

Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Cc: stable@vger.kernel.org
Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
---
This is a separate leak from the remount one fixed in
https://lore.kernel.org/all/ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com/
which Gabriel has reviewed; I found it while testing that patch.
The two apply in either order.  Tested on mm-unstable, alone and
together: kmalloc-32 stays flat for duplicate casefold=, single
casefold= and remount, and kmemleak is clean.

 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 07b2855dfb7b..262f1bcb6144 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4731,6 +4731,7 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
 	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
 		unicode_major(version), unicode_minor(version), unicode_rev(version));
 
+	utf8_unload(ctx->encoding);
 	ctx->encoding = encoding;
 
 	return 0;

base-commit: 90ddfbd1963659ca4a5d3d7f20717a4222682a8e
-- 
2.53.0


