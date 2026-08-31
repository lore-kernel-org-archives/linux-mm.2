Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5921BC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382256B008C; Mon, 31 Aug 2026 10:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AF96B0096; Mon, 31 Aug 2026 10:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2980C6B0098; Mon, 31 Aug 2026 10:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 094236B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:18:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83AFB120142
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:18:50 +0000 (UTC)
X-FDA: 85161770820.27.3524566
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C690080004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:18:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="es/OHSgr";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788185928;
	b=okibuLIGxXJazM2r8RsR4v9c3q2Tm99yGaOM9VuJsttR2afiAIoM68D1b/AqZeZUFxO6hZ
	9XuEDFjXKDGc84T/AMu7BXKw9S2GIF78MG5VVHNBjyd/y8+mTMYQWfwq2SnHsMCsPzETZI
	xvgxii5kJ0aamxQTvHTZ6kAZTKf0Ypg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="es/OHSgr";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788185928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YONLIVVAUFRdHkx2Rc44fd4Rx093REbHbos2HAeeAtU=;
	b=FCpG5pynM2wxwdTRRwtSA4G23Ejm4sp3J4q2FoJsOAiPm8Duj3AUz8ofte3LvPJs4l4ETw
	ewsj+zWi8tLdzh3PWXlPCoDlJbZdrC3uSLcbQXMx87SViMigxRbxbO8zDq22SWs5om/+6H
	RQ+8B0olcz5uZ9fEQpEyX/EC56MzNr8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8815B6013A;
	Mon, 31 Aug 2026 14:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE251F000E9;
	Mon, 31 Aug 2026 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788185927;
	bh=YONLIVVAUFRdHkx2Rc44fd4Rx093REbHbos2HAeeAtU=;
	h=From:Date:Subject:To:Cc;
	b=es/OHSgrFhhuoB5mNLeORVCEwgIemnBbctWc1VqXmE/ivZ6SBs+Ja6EwcYS/4910S
	 alTuWAoZYzsEqFU34j3SWao+xeT68zjaUaaMpYb/Ya6E3RoT2x+McOyVDaLRmMH+Mm
	 ZS+ZRHI7YjX8cwf4PUMZGzZPWokcS7bFZgoeKVsjo6NZvkrudu7ET0YQ7mg84N886k
	 JMcai+D1cYkOwowdJGDgB5jn8/fjvroxm6puqYnHDvPhbonfDjLgA3cSJ9+olUH1/Q
	 Kv2KicCSqVsJCZSYeD8FvQS5vbc/n9aIQuPQLvwBrlNgXExPcbWTUPy8imsUTbK3Cs
	 ZGuT0pNVoFDag==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 31 Aug 2026 15:18:23 +0100
Subject: [PATCH] tools/testing/selftests/mm: add missing .gitignore entries
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAC6NlWoC/yXMQQqDMBBG4avIrDsQI6jtVUoXan7jlBpLJkpBv
 HvTuvzg8XZSRIHSrdgpYhOVJWSUl4KGqQseLC6brLG1aauSR/nwPLPiNSZoUvaSxIclgp2r2qv
 rGtvUhvLgHZHr//z+OK1r/8SQfkc6ji+cxVydfgAAAA==
X-Change-ID: 20260831-fix-mm-selftests-gitignore-dd389da72760
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Pratyush Mallick <pratmal@google.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 ljs@kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1249; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GiQY0/cGhCIhrwjz7J5xvOXUacu6SzKqp5fSychrLdM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKm9hpxHJY+fk3bZ5vKhnl/GItVs+fO4w32CZgY4Tjnm
 /krpjXSHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIAh2Gf1rTy/fvmXPZ3Pb7
 1q5Nv9Q501wtoljnZOrvkNc3k+37ocrwv/SYefGUjgehKjudFCp8GsVey+iUiufaF5xfdJinyrO
 WGwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: h8uuojfmj85yxhogs83urghtu8a38e1j
X-Rspamd-Queue-Id: C690080004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788185928-679847
X-HE-Meta: U2FsdGVkX193pigXjwAW47Pq7vnYsa8upYysGaoTxUw+zzDYCXZ/KIWQ1gecRZa+kLDVaQcQHlKgrQDwORL3y1uBRgCUiH8EBuT+KeEACE+TeGnv6o98MAUZm1rUYmeHKxlssBxvy9ggIuhxFP8G7/9YkrABTDp0wtiRpKpdr3b4EDvQT4lOLZq2QIpe0HpBx1TPT8O7Bh8nRyldb2yVl2+D3Qw/IGlvsb3PmpU9yyCWVGszropeaNHuW+RpGhDtIULBXYcM0CWdT7ZG/7OBJKF+xKGMghz8z9MISFUIoSgugL60fut5r8Z8Q4M0BBv6B7714DZpFXtN0XRYmAAJ7qxhRvnle6on9wkfStIOUPGzWl+ZImBe4DTEsxhMQjAsxccSxmiUtdNk14NvF3L24Yr4OZawmJoqocf1WcGz0OGKEQrhPpX6NCEngKSN3Xyfco3vEYOhaFO2MHdKdkAdwD7Cqo5TKLydWBVF1bq+WNgoZ7bT4G1MYzDxIgDE+350JR1hzf3StcVIOYlMFZhr4T/rqNcvs28oNlkI3XariiwuLOJY+4KomXdM6vr6hue2LxOWnJx5EsbTQLRc31d2ueA4Lf95Hs8nRmXfTBySqyO9X5sVsLw6/ubUDr8nMQydUYeotlVd2dxSHGxZJLu7Ew2h3T8N3xpP+GhQRJyRZJIpAYFPKLBS1CASYE/tgVR05AHL1HRxwEyEqn1kNuh+tAly0ucj51p8L0AkAnvgccBVpcWL6fUV98CtO/6d/ZuIvZCRW4kpoASekw3pGcuUyWxtKfrtf42XA9Y5IFsmyYk0vMR6ZYqgMwn3ve3pXA2OhhnvrZq31WvE2liCiDv68wTTdskH0dOm+43xosFeVwbIAiu0/33BZ8kYAlcJ3Ab0DI58/yrqR/qZy13D/XnJ2X5lMZkZHXLwHQbpZGQzN2eqrYJ3nGJZLmhWGEcxxOZ2yHCggUwIwHF9789u5h/
 cn934IGu
 yJr0PEte99bMPRyFk1wlUzg5V6GoNHPZFIFzRqO1KB4RBE+6HV5sOP5GPK628npEA+b19IclqpICbYdX8MQhRk00Qwe3p4Himw5oX+KbbTTxLS/Jmu1B71kaP95Lm28Crx8eIIio+05ogsGwX3KPABg87M2/KRmn4FXKFW7g6ltz7soJe5pXxKmFZIOkaX1Saf84c048a1MCS/Qixa11nu5erixvE9dfMr7jw3ycwkxSwicPuAcMF2+l+XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2bee308f3adb ("selftests/mm: use pattern matching in .gitignore")
switched to a pattern-matching mechanism to reduce churn in .gitignore.

It however accidentally excluded the page_frag test's-generated module
intermediate C file with .mod.c extension, and also the local_config.h
header generated if liburing is available locally.

Explicitly fix both the issues, fixing the module-generated C file as a
general pattern as these are always intermediate files that should be
ignored.

Since this is a trivial .gitignore change it doesn't seem necessary to
treat it as a hotfix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index fcd892ed21e3..a306d7754786 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -2,7 +2,9 @@
 *
 !/**/
 !*.c
+*.mod.c
 !*.h
+local_config.h
 !*.sh
 !.gitignore
 !Makefile

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260831-fix-mm-selftests-gitignore-dd389da72760

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


