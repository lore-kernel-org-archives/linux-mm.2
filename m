Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AB4D1CDAC
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD29C6B0088; Wed,  3 Dec 2025 18:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37396B0062; Wed,  3 Dec 2025 18:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBAC6B0089; Wed,  3 Dec 2025 18:30:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 936666B0062
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:30:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F9111607AD
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:40 +0000 (UTC)
X-FDA: 84179756640.28.3DAD242
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB15640019
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TTSGKzFD;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cklfaNDxY6VKXExfqmnJrl/OhxSGptLjLWS7DK3yRM=;
	b=NDQrZ9hKJM5j2167ArVtmGdvJFZq8TJth0gsq2pdNG0n2jn703uXZ6dsEALeIYpkGAa/X6
	APniYjlnstI5alrc68r/quxp7Aic7tc5IZSRtUKXOx+wRy8UFZYHhFbv9c76DGysMRKWET
	0QDix9OT8goeeixvZzyUTwyTNK76UM8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TTSGKzFD;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804638; a=rsa-sha256;
	cv=none;
	b=C6TMo174eJI39Iq6EysFBx3eKl6ELFUn3DdrNvVTKfI+3XqNmUYbXJe+spc6PZ9zM2oe1f
	DEgSsmenSqZgKnWRm46eoQCS6GC9/yCUkjqSWK97PYvWUiEX68Z2lWo8K/FAvHRuoSg/HL
	iYxB+4lJ75FnEGaX4aTuNeixaiqzajs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96D0160183;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB03C4CEFB;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764804637;
	bh=+af9Qrl81jzQeC8vw0DiKskxnHYHklRLaViyotNOrs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTSGKzFDZcQCzCkHsA0QD/1UM2l83yGCYfNGL2ubDFhu5/qeOqXuKKuQqZE7chn1+
	 wQUHvKKZWhk93Crwejf1aRATHApj/RIA9T9v2yzKOIfpvzYXlCiX3vuLOg/sG31hSz
	 JJnA1bl6492zszZWShNQLqIaQkToFRRiUTlckUtfHB6cy1MqEx8EV1bexU9WfrMzer
	 f/j5Ey+0A5xveVQFv+1s1JAg4qLKxoY3aUF2o4hgNPxf/Z8P7HaTzq4N80gCluMTsU
	 5iqc0SENnfMz0CvtMWuNavf+s6+0x7XcoVJKjYZM88aWE2M3c4wF5DMMeTylnovfG7
	 06TNKJfZlbo1w==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Christoph Lameter <cl@linux.com>,
	Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v6 2/5] checkpatch: Suggest kmalloc_obj family for sizeof allocations
Date: Wed,  3 Dec 2025 15:30:32 -0800
Message-Id: <20251203233036.3212363-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251203233029.it.641-kees@kernel.org>
References: <20251203233029.it.641-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3354; i=kees@kernel.org; h=from:subject; bh=+af9Qrl81jzQeC8vw0DiKskxnHYHklRLaViyotNOrs8=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkGJyTv9C7XFGXkFdC7we0hu+rcOSf++jRpTnn3BRHPt 5c9zp/eUcrCIMbFICumyBJk5x7n4vG2Pdx9riLMHFYmkCEMXJwCMBGxyQx/xV2+miz81fON7f6+ 2KR5uzQO/j8lw/ym6/hE8ZyDycs+bWNkOPDaslVXY7uKeBQvU9LTrE1t+e7ZKwP3vRKdUnPn5tI /fAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB15640019
X-Rspamd-Server: rspam02
X-Stat-Signature: z6uimatmyxpuzor3e1p94j1h6pxmhg39
X-Rspam-User: 
X-HE-Tag: 1764804638-759020
X-HE-Meta: U2FsdGVkX1/8huH/pfLzPWfPrXEZr/H0EKJRqxvWIk22QkgkizGVIgSl4HebYM5rJdQtudygIW3k7HIyOmrTMHlL6+mHNYlSeLDoESMnR15BsW3aEkjHweRdJ3zRgZ3ChuWqwdV4YgcGb/Sgf1SFEuNxmrBVsYEHoFA4MWdW0wvp4WIzasJFbpHjiaMnlOR6GG7YTGkJH8sXq7hal2vIYPZq8jzwJl52O54U2ytOjIo3NzSdoFqRDy2TlWLLLhB/8cKEbB/uv/k/rYJNJTRFqSPIZGnwYEJTqMEXV8rW8x/+2Gkej12l5i7lcxdjpv1gNes3rO1BTWlpduD7v6Bjuwfe6Dszq8NqtoQBqdnsUlbRqGKXwjxn9cLyQdbwdTfKjh4w/1my4vF2i0/VM+sObcW0urC9A0pA4u3hMPYJJ56l9TyASm2Y4dcUPZlHzNhnywOGae2QIrxwBpdKJ/fwU/GDAR5/p8B2um8nnRTJBaHbgfAPXpcTStZefdtOu+fF7mphdg6mD1f/RhdPMy5J7Tw77aKMkEur70rriTTHKX5/lb2GeEonIw3A7lNiQgrTzah6tL7S5jYlyix8byf5dUym7t5o7YZFZoi36BZ5RXYFEmey1xl2HGZ54xz1L90JTc9wfo8VUJF5dooMn9SdCbpQIHtKHN/C3O72a9g/n9do+q9pftD3ipJVALgX5O0PczjbmheMWpRicVS0eufO+Ulh6I4sT8tDRgGEXn0LEz3MYu1LbR0seNbpR2It2KdOf1AjICctaIu99Nbbeq728VmlYtDklm+ZwWLh2v04Fr5cH1SRavxim/TkEmhzSIlaa0PaYlTSkGA/0qkizuS+5Wnn/D8a+AZpd9gJZNzlxvoE2+wSaetjuqTHkgzZL04oqnYcpccqOfm+/YFxWQG+DUXPIO7b+1Sr+k7afNPWP+EXZxOO77oBYuCvvR9cYqUWXAxsmW2BOLc2RDdVG1M
 OcqPylYf
 aWoPADKPYNk8+W3p65XnyIy3pM+YXLjhxwJY5uP5fgRbcmzNLVN23a5L78QBLbztS1tU2B0WlH8sVsXWUMqRTcA+L7ftBmtrdFAjHG0+JYGqcKECu8JsZivirzyE8gbln0+XTyvWEELRf7dKCJVaNq6WE5f7ogw0Yq45vHhx8AbFCVo/t2zzy32EMrzTShW9Ttrbs9LTksL9MrSBl5BiGHZKm3UruQ+/co4MrUgIrz4nBlC7DTFl4+WXfYzh4kd0mPC4jZYIXKvksB3my+c4Gb1du1w0on6vZDiYfYK1yZzgZAxQWPb2T+UNlVPTC7qlcOpM7vbdphdliC+0KRy/nSRlCz/+RVJvTjY1p8sRTggLHiWIjIs2OvL1ZELLNUCg0TnZvtqYSINE8BvvTcVTVcd5MIOEqmZynZR/9l5AD1jxskGe1Rr0SLzEBc3Dgvp/LO3Qf4m2zSQgU/Xw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support shifting away from sized allocation towards typed
allocations, suggest the kmalloc_obj family of macros when a sizeof() is
present in the argument lists.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 scripts/checkpatch.pl | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d58ca9655ab7..a8cdfb502ccc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -7258,17 +7258,42 @@ sub process {
 			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
 		}
 
-# check for (kv|k)[mz]alloc with multiplies that could be kmalloc_array/kvmalloc_array/kvcalloc/kcalloc
+# check for (kv|k)[mz]alloc that could be kmalloc_obj/kvmalloc_obj/kzalloc_obj/kvzalloc_obj
+		if ($perl_version_ok &&
+		    defined $stat &&
+		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*,/) {
+			my $oldfunc = $3;
+			my $a1 = $4;
+			my $newfunc = "kmalloc_obj";
+			$newfunc = "kvmalloc_obj" if ($oldfunc eq "kvmalloc");
+			$newfunc = "kvzalloc_obj" if ($oldfunc eq "kvzalloc");
+			$newfunc = "kzalloc_obj" if ($oldfunc eq "kzalloc");
+
+			if ($a1 =~ s/^sizeof\s*\S\(?([^\)]*)\)?$/$1/) {
+				my $cnt = statement_rawlines($stat);
+				my $herectx = get_stat_here($linenr, $cnt, $here);
+
+				if (WARN("ALLOC_WITH_SIZEOF",
+					 "Prefer $newfunc over $oldfunc with sizeof\n" . $herectx) &&
+				    $cnt == 1 &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*,/$1 = $newfunc($a1,/;
+				}
+			}
+		}
+
+
+# check for (kv|k)[mz]alloc with multiplies that could be kmalloc_objs/kvmalloc_objs/kzalloc_objs/kvzalloc_objs
 		if ($perl_version_ok &&
 		    defined $stat &&
 		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
 			my $oldfunc = $3;
 			my $a1 = $4;
 			my $a2 = $10;
-			my $newfunc = "kmalloc_array";
-			$newfunc = "kvmalloc_array" if ($oldfunc eq "kvmalloc");
-			$newfunc = "kvcalloc" if ($oldfunc eq "kvzalloc");
-			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
+			my $newfunc = "kmalloc_objs";
+			$newfunc = "kvmalloc_objs" if ($oldfunc eq "kvmalloc");
+			$newfunc = "kvzalloc_objs" if ($oldfunc eq "kvzalloc");
+			$newfunc = "kzalloc_objs" if ($oldfunc eq "kzalloc");
 			my $r1 = $a1;
 			my $r2 = $a2;
 			if ($a1 =~ /^sizeof\s*\S/) {
@@ -7284,7 +7309,9 @@ sub process {
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herectx) &&
 				    $cnt == 1 &&
 				    $fix) {
-					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
+					my $sized = trim($r2);
+					$sized =~ s/^sizeof\s*\S\(?([^\)]*)\)?$/$1/;
+					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . $sized . ', ' . trim($r1)/e;
 				}
 			}
 		}
-- 
2.34.1


