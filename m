Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38F5CFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2176F6B0027; Fri, 21 Nov 2025 20:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCDE6B002A; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63486B0028; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAA9B6B0023
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C20A14063F
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:08 +0000 (UTC)
X-FDA: 84136544856.16.FB13B82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9310E40008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ut/vgIOd";
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763775786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cklfaNDxY6VKXExfqmnJrl/OhxSGptLjLWS7DK3yRM=;
	b=BT4qjTB9BY0hQQJPOn+oD06CSNQwKOnpAFfP4wynvxkZNLec+4aPXemvEzskomnWeolxvZ
	teY/sTlfKE8e8rsfVwrg5v+thlAmwra+7vbaeyb4Fx/ZtuT3tdo3R+SV17eWc8B6bZfqgg
	2PbcZujoyx+rwxi97x1phndg1owIPYM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ut/vgIOd";
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763775786; a=rsa-sha256;
	cv=none;
	b=3YNWoMoQu5XIy94WLd/YLxiC7aQ9pglMNMdKgQEjskD39lcH/0+VWoIt8JOZI/tUvxnx06
	TM8RCKmQz2j4ECy7BB+UgE0p1phCqpEz3lyxtX2BQk/Swi7rdKoRFfMsgLWFf4qFnS/5oG
	6wpMCZ/UrZopQqdhz8yOeOa4sZcnCGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4E2960008;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42879C4CEF1;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763775785;
	bh=+af9Qrl81jzQeC8vw0DiKskxnHYHklRLaViyotNOrs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut/vgIOdn9MIzV/rf1IxTxbVnSgS9e4p/4JDkKH6Ttyw2xh8qWROfZrRa6re07wQB
	 7SD8h59GPGZ3R4KcKAAkLFEsgbssGufG7lc+4/hU4MMThVIFJHAAs0QIjDHHVnq+JZ
	 Kqj8mh4UTV6+9dKfeD6d++C+lU6CVK5vz/VK814AfArFk8VGTu6Is3xCVMB4WnVt8O
	 J02kTYAhcLCYSzmh8XTvtt5M6GgGCpc0l5Myx0zPetaQ2ACat0Tihv2HyFBSUIRS9w
	 9RdCWBP0aB08rzsv9lXKKukwLvyrCki4976g8/MPdUxc8EwnNLH3+d/2ScRwJQEAl8
	 DowxFCRPFYzOA==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
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
Subject: [PATCH v5 3/4] checkpatch: Suggest kmalloc_obj family for sizeof allocations
Date: Fri, 21 Nov 2025 17:42:59 -0800
Message-Id: <20251122014304.3417954-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251122014258.do.018-kees@kernel.org>
References: <20251122014258.do.018-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3354; i=kees@kernel.org; h=from:subject; bh=+af9Qrl81jzQeC8vw0DiKskxnHYHklRLaViyotNOrs8=; b=owGbwMvMwCVmps19z/KJym7G02pJDJmKosp3epdrijLyCujd4PaQXXXunBN/fZo0p7z7gojn2 8se50/vKGVhEONikBVTZAmyc49z8XjbHu4+VxFmDisTyBAGLk4BmMimSkaGiYzhbomvJug35Ogl n12+4vI7AZuW9obj9xKOsNxu/jXVh5Hhf0E2e7Swoq/0hKn3vdeVOiq2NR9izjS7t9KnZePheXX 8AA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9310E40008
X-Stat-Signature: hw4j61sc83p1ngbanjwbr8tos9or5xir
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763775786-97512
X-HE-Meta: U2FsdGVkX19IVaauCrgDlK0W36C8ykM6WVsTtX7cJi06kAva2/cafrfKN2lcjvlLoMnKqRKYZc2KLrk+KFE59ab1BN/jQ5XH08OsvNgYIl+Bs7qCVDcF79toWiZqOpFR5FjoAU4pJ3ZMuqzc5u9pVjPsuj34HHHaog9PYJwXAg9zyeEsSCit9A3LKVXerXQ4ppt6oHKk2IX2HAVT3erm6aN3nxDfK5oCi8yZ6gp99qYU3PCIfmIKk20Sv17RGOrrdJTftv+/72N3QKqil0AZTkFY+P1A93pteEp3RPmW9H/ReAZ2Ft6ygK2sZ8zKp1+Z+yXOCCQ/TidEPWMRXBncaGw3uotGILQairEVMsoFE79ql9YoAmY9VZ4ZnTjq0pXhiNGAH7L9s48ZQxu0YQ81GidsI49LpJevJ8c1CtX1f8UhO23Otqi0KCFZA7BJ5JFLDiYzPkGoWCbrBvCq156XZ2eW4uki16F3ZqoRjO7kHFqr1Js5Zibkp93hKnkEXAqcxba4DML/TTVzMs2KidQOpK9jTGiqlKTx7JXurPGHeqbP33ueATCt05UUUs3fMybUTWfu5tlH7CN2wb79Ad3bi7jYeNvzaA6ogDdsVx4bdAbAP00+mfAfUg5bvTV0/esC1wLun4lsjrGlCII6nzfuAZONwre6hw4rMdMsH1stkyzjOU8xLPOk313HRV5MDTtprirG0jwQKrgpc8T+XOgoQDgxtjsemt13tQlF0TQWbje9Xq4LS0lyfqnwoYTbGBtE/R2GYQB5p93lznb9/24AySNLbaCfJxPGDDryJ2J12pgJuao3KauXTEO8YAH9EYynjV2/P8P/ygZ8tKxAqqDyUcK5vmmZX6Eh/nqc5u/CBFSxG6U3g72Y+WKuohqa99QgvwSBTod73TYy4kuNHXshsb5H9xNEa1kUWk2GZSStwHGwXNzpqynhbR8PC3TIk52pcpZikLWfVHCKGxposKe
 4y02s18Q
 dcxA+/sVO/ZD18w/QUF867F3yTTqZW+wrzX8jq1LH1m2C1weOrnUYxFtoB06zfKnM+DdDYbjfVdNe+BquUiy8FlWosnTlbQA0k1/W1d5obctiCid+fgx9mX2NcBEJDVPbd4YWfvTcKjRrb2pDeFdqdLW0kXpQn0lZeywU6+j5dt6yXwu1ubH8g+3GKUutUZ+YhDmCRSIjrXILMxEDIvretTQIITiZgTG7tbXdmkx3/KC1oudWvD4vmbMI8Kea2aWgIW8G3MkeloV75DT2VtX2wMBK3eH+0pLPtu4OSozHAv4GigYFd9dWq1uVnl3mGOK/Vq6vzJ1v9QVcinxAtVcA9nsRaViXXW4MyyAxez0NuTPTgGXA8gh8V1x6VNzj5SG0BgGplr9fWvUM2n1vAB+Q1sHcjqWORUVf6gXwWGE0QJFr0BND3GBVd9dlSTaQuJ28v7pwO+nGYlZ6Yqo=
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


