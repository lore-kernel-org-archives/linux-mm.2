Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C17ABE9A02E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B686B0089; Tue, 17 Feb 2026 13:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748B06B008A; Tue, 17 Feb 2026 13:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D376B008C; Tue, 17 Feb 2026 13:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1446B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:01:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F353513A75F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:15 +0000 (UTC)
X-FDA: 84454715310.06.AEE5BC1
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0913C120006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zlE8ujzN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 36KyUaQYKCOcJeJPRWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--avagin.bounces.google.com designates 209.85.210.74 as permitted sender) smtp.mailfrom=36KyUaQYKCOcJeJPRWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771351274; a=rsa-sha256;
	cv=none;
	b=gzuE2DsuaghuwvC8s/DsDHqLJEXRB6f7kVYK33xsgmhzVxn7IvzQNWLgvzn9dQaEUG/HZs
	Se/37vyykEzO6mvlPM01SpqGFxt0WzBd8nW3XHv0c3YY3Z5KZ511f3A1mhZZ9CfjG0GWVg
	iainaTYAiFjB9z5KIAoHguYVAk4kyN4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zlE8ujzN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 36KyUaQYKCOcJeJPRWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--avagin.bounces.google.com designates 209.85.210.74 as permitted sender) smtp.mailfrom=36KyUaQYKCOcJeJPRWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771351274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWILvLkFP9VgHvdYSVEMstLcXKjVhz4il8XVeiAhgTI=;
	b=vifs+IZJvgWtXW8SW0/FYV3c/8LxEhVG+VsGp5is2PpEmwli552uvklPQicaActhnxGCC/
	vC9C8VFiRUPMsG9fPPr9Sd37ld/HAGXCzNGOqNw23s/JBNE3qiihb0ziNRDIjvZ4sgEyhR
	KX4gkIP5WHcLlXpc69w6f1Z4aDHa8p0=
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d18fa0728aso41501141a34.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771351273; x=1771956073; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWILvLkFP9VgHvdYSVEMstLcXKjVhz4il8XVeiAhgTI=;
        b=zlE8ujzNoM/boN9kUaVjhdmpncSeNJyFYC9fuSthMK34hXiZJ41+9AGGPj/GsS4CnP
         lAw3uPisc+bbBURP5n5fabg/JfGBpBiojU+kHk2EmbiExnvnChySVhjk5GzyFjjFAMqM
         aEh5qtSfodRnPBpFjvYlp7n0MVNDYQc77kjC5YhNJL4/4YM8z2//M2C5QQBI/Jb6Jbgf
         NM9woeISITvajNwbifIsJg9Gno6lxDZM2c2zbW1/fw0v0+lVIvlOZukvdR2Mb2e0q594
         G27YMkWTxCK+Ffoy/6ea0j2QYemQgEPbObYgWRFEWSjaNuy9u593VImUfCDz03e4zoRP
         Go8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771351273; x=1771956073;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BWILvLkFP9VgHvdYSVEMstLcXKjVhz4il8XVeiAhgTI=;
        b=KJJUm1c5kUzwCQZXCDE/C3xPa3G3Bu3e6icMNhDG34e6tqeV7edRu5PhC7JAHJ3Grr
         1EhUgtYDqCZnb9TyJenIEzZQeasSWh6mJzULbcgjin9A5e74An11xQMC/B3alTYHjNfr
         80/cfk/t9oLvu+qvWp59pv3Ql/MjW3aeq+Hz37S9LoZyCH1Ez2/UZR+bM/Sr+vjQc1Oq
         xhz241h2BZcIVNuoWOTCGQFSuKmcC+0ylvCpcUiMWRHbo70LLHwNaL+U6Rx+8qn/Xmuj
         pgo1ZDLc0XbfoQd8cQwLJCPjYXUZBqtYkphOUfs3R57ZPozZffOhZRXZy7jHuUcZMAdD
         A0Og==
X-Forwarded-Encrypted: i=1; AJvYcCUwziTKinrJErUBreLPGhg6CitjhEDJFoSe7O3V8pgAh8MxAHwf9IlnNUh5qAQJD7+EZ9fRjF5Elw==@kvack.org
X-Gm-Message-State: AOJu0YxBHvn8cG+TmuCRS54xoCjJFPRAE9roW4E+lGIaSSLBcE7m8Rjd
	v+6azhoyCCtrtN1J4SsfamwRswUQkj0l2feiv0MzbAzCvxwt3q4W0b6kNMtktNkKvL9Eo593P30
	8yf6tdw==
X-Received: from jabko7.prod.google.com ([2002:a05:6638:8f07:b0:5ca:4c19:c2b7])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:458d:b0:663:364:674f
 with SMTP id 006d021491bc7-67858fea6bfmr4750317eaf.1.1771351272644; Tue, 17
 Feb 2026 10:01:12 -0800 (PST)
Date: Tue, 17 Feb 2026 18:01:05 +0000
In-Reply-To: <20260217180108.1420024-1-avagin@google.com>
Mime-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260217180108.1420024-2-avagin@google.com>
Subject: [PATCH 1/4] binfmt_elf_fdpic: fix AUXV size calculation for
 ELF_HWCAP3 and ELF_HWCAP4
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>, Mark Brown <broonie@kernel.org>, 
	Max Filippov <jcmvbkbc@gmail.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cko7smbemayw7uz34ztpcrpro3utq7tg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0913C120006
X-HE-Tag: 1771351273-810854
X-HE-Meta: U2FsdGVkX18eyl7lGCzGX02+P0y7mH9F9B10+SAFoTOscnAs/40DUO8mNvYyhS/URq7YTN0i7Qr8UXSBqgU12puAbEbzKmjQt0i9BUEdTRyjamtzMKscVEMfI56/HY/nESaOAkyLcEKywunH4Oud7Ct4WZ60ubrxnm1C/vltxjzVbMjrPO88LIZwEsEBXjfKEa26TOU9kkvWz+BuY5OIcSAePocnkdOaH1qBhJnTq1xbKGAEblpi7/x6TdC5DXl2FlsdeHvDsk+CaSsR6+cL3qNecMObYwwnW6FVCjC31nez7L0bfG0e1giKd/ePr+haO0SDxrmWdd2TufJ7/wUJ57gjPDIIqo5Hh7hsbd/buLmXpgTyJqZ1wFUYytGJrYwvap8ny8I3ME06Vk7m21iyXVkMjKwIYXYsyS5QYd8bY0xlT43/OkqRglPUy8CXPdj2S4YUDNIyjHA4LHPxOX7fLzWrZ4OtiglAexRTAMu8u4+Abgt5pc7o95Uvh1WBQjxRHfVHcwBXWnQb2t+aYpWfZGVPKfEG3CS7UNxIm42VhfoBk1rb8TRWf/+vvmnajw4+PsVk3MbmQ/F0QGy4WnEnA29Su2UitfqeQbO1SxB7NN50zOfUf6FdvmZxp6S86T/WKAmB1vVhryEGuJUWS+6Ib2Lgg7RdkfaILHU6Gue6FbjfR7zpaqjGiulXCWk8DfUKUuDunz34d1v21QIKRs3AtsGfCmQy/Sumi58v0yCUBeSbs48nHRi8ceAxeWaRDpQKTu78imqLUy9lPD2Ggba5OXhd+KkK2bnmYep3CUvXy13LBN3jaGfHpXu7S0K2dWLUP5PefSzyiQ/liiVhbL/3mvUzWlkpE+G8icTH9c1uMAlk4Fvp3E2dBGmXsZ7ENxEOUqIANlL8qQnhlbf3io8SZ8wNjoTaCgUWZswwmOkm8J0RKpa5YXgtmJmncAhLTIomgX3Sl+9pqNDjMhYjiRT
 dOmk9LRA
 kkRcs9NYXLAMDtbwy1y+cM7SqU0eiWC3+vlnFgwwuTBetOlrk6n9GVwfVukwUfLK0OWx7UEp/xRuYfAeOmQzCpwg/J+C3hhh5P4fI+YFWHY/9RTY++1prZnCzzBwuPxoH5K26AlhRKXPPuW1DLEDWCCERJiJOcl4cHCXiKKJ/AMXU3M1kqHkOj7y/3udeLraEY3fiIo7MXroBX+W8qIw/f+VfLqHY5nnYRuENm+jtW/G72RNU6qRkqWwj0CrEP8wJGIHomvDik9TYbXMFViyBjQgUnw0lvce2aGU7RDWwvJSbSewqBPJtWvc/2iGEZLNCceac3mePUT892NaThkzILYBwcvh+iZUNhejLG8WARsErSgNoOjqqTU2U9voa82oUN344D5jL/2hkDbuZuhlLl9Y3uqIsNASPfkxLr05rN1+kWnm++1lYxX4vaP8RbUUXONZzLLfC7Fc65WJsvMtpaZbjP9g4KD5taAn4w1rYdrOavOZmvHBJSqAh2t4+Ot0mdwLEIAax7t9T2lNvOhSFcJjSVLipUSqUoQ9x9IEjZo8HG1uyITkNzFS/7NI+Anijo9n9a45PnRxOsfMqduLLjO+Pd9nFSgH4ggzZxFHLL4g7lxeq9DTAQAGMBc5K8MLcEjvWsMFdSvwT5bRrA35bwZRqrDgXElJ+TvV2iKkaxSN/FJVX6kHdC9Wyx1MxD0wcbCLNEd5bsKm0BchD7yHK5Mg0i+uzb3TczCBntqO4PqrDNsuQ8rKhR5JpZegf5wGb5McU+8UBDr89raPDS1wj8lz0pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4") added
support for AT_HWCAP3 and AT_HWCAP4, but it missed updating the AUX
vector size calculation in create_elf_fdpic_tables() and
AT_VECTOR_SIZE_BASE in include/linux/auxvec.h.

Similar to the fix for AT_HWCAP2 in commit c6a09e342f8e ("binfmt_elf_fdpic:
fix AUXV size calculation when ELF_HWCAP2 is defined"), this omission
leads to a mismatch between the reserved space and the actual number of
AUX entries, eventually triggering a kernel BUG_ON(csp !=3D sp).

Fix this by incrementing nitems when ELF_HWCAP3 or ELF_HWCAP4 are
defined and updating AT_VECTOR_SIZE_BASE.

Cc: Mark Brown <broonie@kernel.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Fixes: 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4")
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/binfmt_elf_fdpic.c  | 6 ++++++
 include/linux/auxvec.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 48fd2de3bca0..a3d4e6973b29 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -595,6 +595,12 @@ static int create_elf_fdpic_tables(struct linux_binprm=
 *bprm,
 #ifdef ELF_HWCAP2
 	nitems++;
 #endif
+#ifdef ELF_HWCAP3
+	nitems++;
+#endif
+#ifdef ELF_HWCAP4
+	nitems++;
+#endif
=20
 	csp =3D sp;
 	sp -=3D nitems * 2 * sizeof(unsigned long);
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 407f7005e6d6..8bcb9b726262 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -4,6 +4,6 @@
=20
 #include <uapi/linux/auxvec.h>
=20
-#define AT_VECTOR_SIZE_BASE 22 /* NEW_AUX_ENT entries in auxiliary table *=
/
+#define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table *=
/
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF=
} */
 #endif /* _LINUX_AUXVEC_H */
--=20
2.53.0.310.g728cabbaf7-goog


