Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110F6CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACA16B0005; Mon, 18 May 2026 15:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7359F6B0095; Mon, 18 May 2026 15:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E696B0096; Mon, 18 May 2026 15:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56B266B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:12:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E98661A0A38
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:29 +0000 (UTC)
X-FDA: 84781486818.24.93B5048
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 064FAC000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bBwWyR1T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779131548; a=rsa-sha256;
	cv=none;
	b=8Go25iuiCM/MyR27kg0o7D8U3KlvfC7jNsVxslCdm/zRJhc6s7NFWti2HaDcdtvFntKZV3
	DhRWUYU69jVQ4p55RD7gzuocgkBUouoEZsMljKTWE9r0ygenzLklJt46LMFMkDsHkWAbQz
	VShRvGl1YZMkxfNV7CoQT630tN2Q0XQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bBwWyR1T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779131548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBC6NBfwX3+M9N5z8/EgZVcnEG4Grml2tle9vPR+gqU=;
	b=QyvNFJgGL+cJ25duK+xA7V/rmaTgyYosnjvuDNBe2WCJ3aDt91FsWHzt4DTtnVJffOZucZ
	xZxLYDE/rWfIxuIOdscfff9s6oaFvD9mi/e2tCm2SXRZcg2rRTnKI2Qu1xj4/fBkWgCrgx
	45berK1LO7mVys/h7vKFPU0KFdBvuhA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43eb05b1875so1468398f8f.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779131547; x=1779736347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBC6NBfwX3+M9N5z8/EgZVcnEG4Grml2tle9vPR+gqU=;
        b=bBwWyR1THm2ffovVkiiQbBor3q7y0fQ0olRJcbWJwvAoKecf01fXSNNj6TynhEcZvT
         qjwXmldDg2DJG47DSvEXwcZKBthgrGmoLzqqPpEJTG7PpkTVfEVNd84aKqsVYmy8nrsp
         1vOA9Dp7HfLuUZodjoH3xXlyHpBOnCkulL0VOV39RFo9c+wqh/XcvUTuc0VqFhQD1akS
         YLuRnpHLJLKLkyqLL3AcAYf5ICG5EBWkFHwinethyHjvGyWtWtlOKBfomnQJh+8+bFlI
         yQipmCAGZ8QP6LPhuUKXfyjLX4G87vaYpKYJYEn2O6PLhhk/2WxyH4iLl0mmYbq6zcQR
         q6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131547; x=1779736347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yBC6NBfwX3+M9N5z8/EgZVcnEG4Grml2tle9vPR+gqU=;
        b=fbj17Ewecdr41hP5PPcxWlJ2n/pelXJqob0uwuygcgM5hiO/Vf9QwJ34kljkUVb3Hh
         2TJFWwdD9z520er8PkBWAJWbJV4UXthGMyhVzg9uqwEXwjJP5E8teyjLr8ikRfobno32
         WXS1+3I8+0dOq9cWUTM2pplxUCLM2GASvmcmFj0Atl9wjoZ/Gz9aH5PlsgETkNpF7eUp
         2yi6SUPLZBRdrGviKRUVIL5JQ804/IQLZiXx9pxGtGFCB2/afb5VpF58NbjHptaG4XFw
         p1JNryjXLcLkB/6hEisk4RzlCnEUShY6QWqOgK5Vl1PpmjZPfgAP6oF0+nMXNOBIm/24
         fzmg==
X-Forwarded-Encrypted: i=1; AFNElJ/JHTD3o6Aa35yvClpQwBNDXmQeyw7xCE2BLELVrKprGbQQnZPu3riyt12dohMeTEIq0/bBL8VyyA==@kvack.org
X-Gm-Message-State: AOJu0YzI7fLnySzcDrBiwTf66tooGXLex5+4IaIAKB2urbyRTGk85UiW
	V0v/6mEhA0ImCUZMfDeVN76KXVx3F/7YE1kcMD+prw3vt8MlInExJhCv
X-Gm-Gg: Acq92OHik/5yB9ip+k9SgRheQc+PT92L47lTFlZc9urOXrdL6zyaLZuzYmeOvs6D/yx
	Qn4/U9/wjcGHIKZSrf8GUte+M6X8ZsGmdWfWJ/ZE/MVPyaoasLCTqYNDhViS1Df6cmv7AJmvI3N
	EbNyWEm++El6v2pQBiC0IRIrCrt5T6DQxRCAFeCvfNeamNZb62U2zmqYLyLKNuSmvSrADPF4ES4
	Mzc2OM/fhNBBnGkC5IbZ9BDem7HHexFCSjYhIEJvT7dg0icwFKfH+UUrG5fkbwSejZGbE4cIcLt
	VFq66D6f+y8k/9WDS162oVOeP6f8vMSJjvVtz7LpA/WFF7NkHZBzsDGC9P856SYC8DVn0foXVbS
	yCdQpHtlUP2WM5BqLMPmaAO9NrtCG2vdl0As6z4BrJByv57BBKuAEkuxpD/Yff8FKfjVZSWIHUV
	/oGbp0p+rsriIY9nwMbNZeXvRW3qdBw0uL1M19RYaxMRMLAd9YA20=
X-Received: by 2002:a5d:5885:0:b0:43c:f7e5:817b with SMTP id ffacd0b85a97d-45e5c5cc2b5mr26469781f8f.19.1779131546344;
        Mon, 18 May 2026 12:12:26 -0700 (PDT)
Received: from mshcherba-RedmiBook-16.. ([188.163.115.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm40043167f8f.34.2026.05.18.12.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:12:26 -0700 (PDT)
From: Maksym Shcherba <mshcherba2000@gmail.com>
X-Google-Original-From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: [PATCH 5/6] selftests/damon/_damon_sysfs: support update_schemes_quota_goals
Date: Mon, 18 May 2026 22:09:31 +0300
Message-Id: <20260518190932.42270-5-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
References: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jikjprns4o7z3my8f4r4yudgdahe9wtw
X-Rspam-User: 
X-Rspamd-Queue-Id: 064FAC000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1779131547-837103
X-HE-Meta: U2FsdGVkX1+CorONEMdF1Yrq9gxoOj654kjsXNm1lOx7EYN+32rV6++lwYndbrZOFsuEG4arSJGHwSQFeRicVbRlfbuLSi5CdAb0EieanZsfqWq8yGu7QJNWny8YPs5nlyu2GIXXEvm3HTaDkNPnJSzfwJrOadFnLW6zg5PatgBTSIgt5My5TG/CW7yJXuycFcvg6etsJuLdQVOvtfkXq4YnNvX2qQ02CCkFaxBLQ9oP+eQr2EMxcxBFiTEtF4CDjj7XA1WZwt/UHuphg5X6ENIR1jEerUWSYyVFt4k+x5kE6cVdqO95F/4DcOm2lSPX4Zzx29KvFxoR4PQSblStNqmNI1TX2P+R/89KMx6rKASl/twu1N1Flnu13DW3NvHdRhLf0WziXYKQ40e5bU5SNG8zb0O4RQROmW694itisbIIJA7HRDbgnrNhRfKHGdj9E24DRnm2cGjeyXW+CqhY6VJJiCcGUBoBHZ2evQIc8KfAJcuHNAyPY+eMdTyFqSwMuAcgjkuOFpLMTv9mC0S/HtoZowhcEV1n37C9pBKpEn3e91XBRgjGD74VEKOWdQcq2an4zSmbGQVoIqonvXp1pb5pJ7bUNx/tdicLhnxcG6rFUkGZmEjTQt4gp/Rr893DT28nGkfoo9wwHJtZbpbh0dt3Y/ioPL30NpvnO4haxhNlWz1o5k7xOu4jnLESiCTnN53yQ6VW0Wm9oRnhNzzdzDNXsUOr81pRb8UsdDBtXGOkUuzXBOzw2uVjac+Oguwyna8dWLRCL7RwnLrHzOUng+unw3LWXvqFDgpIun8esqSgSDzOQQsJ8q33hcH2g6m962h58VjDB41OQFhBLCKiTtWZjye2FctJFzVpfhzbOy126nULsGyE9wizbT7/s2ozlg6csDglE9hlYom0e2RAjsquB/qDIZyq1i/bHh3foDvRd2Qg1aP8znmkIg0FyLF02AWP5Wr0Oh61DUxUBNA
 zOSmupPp
 eTjRb8KkFkINbS11Vve1eenbEcaq/1yU2GqZWGhupOkg24TTLDJzNbzj9eXDZ1ZTpaFVQwdjEh89VQv6/vCKbiUXvWOeJ9NGJzO6kKknzba+ZmRoMmU+JnwWmBRtn5Hd0ukUcK0QMD0mFq44eyn45tNqrMM9gELYQ2bSwIU4SdRsPAufTiqaNfyaZ8D/2ns1EX5I579IfD1h8fCyzomtncYHN96jrfBYrphmbPsoF0brRdAmoUaJWSwyEIRL9/xnaKrCN49VFTofX5nLUgrFtI94UIgB2Hb8YZ8W8KHsoXxkugBjXr7FP4Uk035mhxh/D3D2WY1kJvuTX8n+SYBbRTMW/o9bSzbC76y1Boeog3pKf2qXJSr+95PcXmzFgz4/1OB2x1vU3mwsMPPr3HeRUNjw2OWT8viu2LNwIKsQfq3/IFIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add update_schemes_quota_goals() method to the Kdamond class in
_damon_sysfs.py, which writes 'update_schemes_quota_goals' to the state
file and reads back the current_value of each quota goal.

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 8b12cc048440..27cd94683f6d 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -806,6 +806,21 @@ class Kdamond:
                     goal.effective_bytes = int(content)
         return None
 
+    def update_schemes_quota_goals(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'),
+                         'update_schemes_quota_goals')
+        if err is not None:
+            return err
+        for context in self.contexts:
+            for scheme in context.schemes:
+                for goal in scheme.quota.goals:
+                    content, err = read_file(
+                            os.path.join(goal.sysfs_dir(), 'current_value'))
+                    if err is not None:
+                        return err
+                    goal.current_value = int(content)
+        return None
+
     def commit(self):
         nr_contexts_file = os.path.join(self.sysfs_dir(),
                 'contexts', 'nr_contexts')
-- 
2.43.0


