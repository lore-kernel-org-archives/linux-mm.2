Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459C5C87FD2
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53956B0089; Tue,  5 Aug 2025 12:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D039F6B0093; Tue,  5 Aug 2025 12:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4AC6B008A; Tue,  5 Aug 2025 12:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A36826B0089
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:21:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50F30808DA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:21:06 +0000 (UTC)
X-FDA: 83743218132.12.499E0AC
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6BB42100003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:21:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B2ez0PVU;
	spf=pass (imf05.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjNpkvSXW+v2m5Yu69UUOTo/LokqTIxoGaybS6E7Cys=;
	b=rYr/KwyrKoldNIHxDMCOxabAiYaP2tEEFV6EPnaiYElI72uWQmKYbO6qm4+bR33BsuaRCz
	Qiqb9BXAaLABzZyWmS6c+ms0+baFHgC0VVZWf+UAdOfiVY4xtNduc8/X+V0JTQx30aaRhv
	nPAJSZZePR+FAdLve6clomX96BeDWVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410864; a=rsa-sha256;
	cv=none;
	b=6KNFiTcM366yJN5kJh1uGT/zAa4MHAm7+lzvwNLYy5f6wRnBTUMbiXbRKSDupq2nW3jfaX
	/KA1TWMO7xvtvvksMvIvmsvKMwqwaMvMLIvwyZk1jJpVKFGa3oL7J7fWpmS3CcVj1oOQJf
	2TbbtraWxmoJMzO7dn1MhbDkjKjj0lA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B2ez0PVU;
	spf=pass (imf05.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71a38e35674so27802317b3.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410863; x=1755015663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjNpkvSXW+v2m5Yu69UUOTo/LokqTIxoGaybS6E7Cys=;
        b=B2ez0PVUXc4jRg9z5bfwsHwBWJ0Ly6fSwNukt5/aTvI4rt6EjSVjYyQAdYKo8goQZ7
         Si/K7fFbqrr20a/gPlyE5WJt2D3SwS1oR072naacdolbQfGjwBIov3N7iKE3TcFzLrl+
         0ufT3w/Bb7tLLZMjt1d3d1pJSad1VTsfPhUwbP5TNeiyQ2LBkGr/1/t+pIc6QNcr/ELo
         vPqe20hKzDatzTRPbnj5AvnI02IJESrrLYiOehOhnUJcVDUJfNvjcf4HIRK9xBeq7+DH
         tGj/ffUE88bjVIQbx6r9IIFyOomXuVzhrsYLSijbytxgFmzweTc/4BWW+k/cvwRKyqES
         o1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410863; x=1755015663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BjNpkvSXW+v2m5Yu69UUOTo/LokqTIxoGaybS6E7Cys=;
        b=qaClVqoNuE0WwjGFGlXnzZuZmubeCjesz6n4R9e6rCVVv9SMyr2q6+tz1TgGdNt+me
         lwQVpVbyw+Pqexwo75PlQTqeZFNfeEdUHNv/DVMUpkoiC8kqanLu9xsmuYJrXLlI3bGP
         UkKpEy86H5c2iWJ0OZw2wrAwGUhvS+KNuqUfKqC1McspgZTCgpRBBcAEYu+6dTzfw/O7
         KeNJez8GwUYh6BLd0s4kCjvSeEsgKb9PLiS3XFnn6RnqapKDgS02SYcd1LmWOQ5VSZ0r
         s1Z06K8EH4rxrzuuJ7M5X6Ovp2VYRXpewSWHutDRjJxPB2El8dhx8HpFqjg181CIDZo6
         /u0A==
X-Forwarded-Encrypted: i=1; AJvYcCUTboUjle49KjRSj5VT+NfNG2lWmmOoj+mJ+L07rAh3H/yfONcNu+ER8Um4IHG8ROZ16kU28vE3WQ==@kvack.org
X-Gm-Message-State: AOJu0YwazCOqJH31JhOvFxFBo4w+8sTpVmNuZ8kAdc6k8MWQVltpXJz0
	dWmK7p5cvbJe/EXXWD0rxlVAdFJubSeqm1cDpNzsZ1yjxTOL5fTdI6An
X-Gm-Gg: ASbGnctbzoaRFA++hrKofiwjvxOyuomPA4XLhjhZji3a+310LZrK38fWA9eCLagYKVG
	Fq1YKTFrU7sDYtQRyJ2wWdOUKF7eXbQkXecCwWNgD/RfRyjMD3ut8DKCV87cZW6jxSFsUSnBJbg
	3e6RQrbh3mMCr0gBGudvygyoStSxOYxGfiuUnpTD/uhlwdvYE9OWHDYdVh7tRNWT25OpaFoBz8G
	i5geGEOEXe00UHRe4EQel5dZAnwZ5st8zkUhVi+ivegDg6ndCS+05r3CekQxS0NXJoX81eY93OE
	FoW0+SMipi/HEOlIduxe/gL1ipJ6tJvEgW3sgjZfEMgyVUjEdY5tfPnR94H0I6Gwu7iK1mAG+ME
	SP8JhOGdj9/D3inymRU428gaKWvMVM4afErYLYXNuOXQ=
X-Google-Smtp-Source: AGHT+IEQM0QlTGhxyMPibEvEMDpbAzpmE9uEnXqB1fB3pRbIadxeRKgx9pmHX+QFoHCpre2n2PEesg==
X-Received: by 2002:a05:690c:8694:10b0:71a:34c6:706 with SMTP id 00721157ae682-71b7ed8b056mr123189357b3.17.1754410863480;
        Tue, 05 Aug 2025 09:21:03 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:2c65:e45a:e7d5:5f0e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cdfc5sm33098757b3.77.2025.08.05.09.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:21:02 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: [PATCH 4/5] Docs/ABI/damon: Document new DAMON commands
Date: Tue,  5 Aug 2025 11:20:21 -0500
Message-ID: <20250805162022.4920-5-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805162022.4920-1-bijan311@gmail.com>
References: <20250805162022.4920-1-bijan311@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6BB42100003
X-Stat-Signature: 5pr1y4qjmrsbzirqypnqdnykhx76xs36
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754410864-115976
X-HE-Meta: U2FsdGVkX181QeH8iFDF/kMYsdpfT525vink8Lvu6I0J1TZYoLa4QBnTd09kiznjiOzvvDSgE1po2mYYAznkck6rnE2qS5qav5sb2T65pXQUQ7i7MM8gvaYjlTvLf2rs7eqMWkSsl634Mvh6lGcI6VQNGuo4iKEPks69Gfv9A44puA/zA0dwiGUne8lNGpc/EXoQXPnQAXGDcnvVIN3QWuJrTGzV769JjhZ7/hWWpeFAbhhseSEFscnHnQp3rnOEwU3nBWGSh3uAK5njb8O/iu+0Y1ahd32PzJGr5w2xps+6de9D7Ac9dXoIjSoiDnxQsbScfQRJN93eNOg4p7OCgbguwlxoS/VaKnNCF+97PlfCAkkXY56DzCdbwPSNIcVFPcAuo2ASkpsMtWkgm8DUHnV2eapObGJdC61tE2luxyT28dkurjWiI/6lI0YDF5KPmaIveKfdBepOfgVMht+ooidfWQyc+Ivm2m1qgB7SmHuFkQwJDds+nbaC8EE8TuYn+GZut/prif/Mo07zSnhSsylCNfPGe/Op030oCdqzfTOZfSwcRqA1THkQtI0/LcFVhDVvuFt62eqt78GLCHOaA5smT8fVHDhlVd1GiMxPBOHmvEs2VdCUQgmJ0tiMrjmfRMJZO287RHtHguseb48fO9v+bHUTGl5+hqrjQV2xzHwW+42IieG+A4lWBlHCbqxUL5vbrRI8TQZJQmKb2w7A5Nj40AR5nfPfRjA/qfQci5hFIWV80o/AH5kamJgjFNKef9Y6aMGpfvgM35A9DqZv6XvLFSjAcjgYkwhHkouJ+edbtYBKUg+k9h5yqhX0sISDUUGXm5XEb9bwxmqFjoouweCM5XoVYPVK9HAxfVZ0xR/qtbzhV6A/Z6ZiphbCX4hFrCG5b8ScACH+FVC1/O8Cj0xv10S6xrl27kDYK7mEe94a+D4oGMdR7dO7jSgSDJLegDIWOpiINep3SLDm20B
 ZMkXIiqu
 bUmTqyjYz+ezOgy8IaMOjGWpv72iNNVIqCraBXjfuGw/XMoSnpNz1yqJBc7Bc0ZI6Z9GCGPTufQp3Vee+jLTw0+5oK4NQOrA3N3syI5yoUAFLoj9vgn3tFxkX85KYFtbIeEoOwIBdYt05jc8GlG4k4v6BKXs445HRhFo5qckAGGa0wtvUO3N2mDLl6UgOrPo4u9tr0+CfWktNgtbnBbwvbugRUNv59cuGgl5ilpkViwJDltdjbdXyVSvD6FGZ4rNJkNbKJTKBC3mQQ8qE4DNCcxqeV9Cnw4/6//p7fq+waoIO+AaMVsK23y5WDmmorZGA3ykClhX8PYGp7muGViZVNChXfTVtYKH9ejrAlHuEez61k3FWwCsDxCzLSNU85VLix6db5A9zE4AqdN+JwEBwv7EOYLmY7Lku2B7PPIztl5feGRhnSoqaFzvOiOJJh9aCpk2SkTaPtnVESUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

Document the new commit_schemes_dests and wait_for_schemes_apply DAMON
commands.

Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e98974dfac7a..429947de9aba 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -27,16 +27,19 @@ Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
 		makes the kdamond reads the user inputs in the sysfs files
 		except 'state' again.  Writing 'commit_schemes_quota_goals' to
 		this file makes the kdamond reads the quota goal files again.
-		Writing 'update_schemes_stats' to the file updates contents of
-		schemes stats files of the kdamond.  Writing
-		'update_schemes_tried_regions' to the file updates contents of
-		'tried_regions' directory of every scheme directory of this
-		kdamond.  Writing 'update_schemes_tried_bytes' to the file
-		updates only '.../tried_regions/total_bytes' files of this
-		kdamond.  Writing 'clear_schemes_tried_regions' to the file
-		removes contents of the 'tried_regions' directory.  Writing
+		Writing 'commit_schemes_dests' to this file makes the kdamond
+		read the dests files again. Writing 'update_schemes_stats' to
+		the file updates contents of schemes stats files of the
+		kdamond.  Writing 'update_schemes_tried_regions' to the file
+		updates contents of 'tried_regions' directory of every scheme
+		directory of this kdamond.  Writing 'update_schemes_tried_bytes'
+		to the file updates only '.../tried_regions/total_bytes' files
+		of this kdamond.  Writing 'clear_schemes_tried_regions' to the
+		file removes contents of the 'tried_regions' directory.  Writing
 		'update_schemes_effective_quotas' to the file updates
-		'.../quotas/effective_bytes' files of this kdamond.
+		'.../quotas/effective_bytes' files of this kdamond. Writing
+		'wait_for_schemes_apply' to the file does nothing but wait until
+		the next time every scheme is applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
-- 
2.43.5


