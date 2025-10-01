Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8F5CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78D88E0007; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29088E0003; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65A98E0007; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6A188E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 864FC8589C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:54 +0000 (UTC)
X-FDA: 83950527948.21.B01AA6A
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9FB3E140007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R6cAq3Hd;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
	b=JcEEeIiBHLW4+vfMfAJiqRnVIdPI3yD99M1dQeudJth99158RmSlI6X5yQOVbs/Z8pq7qk
	X0yVeRw+XjIcOdYDck3KN9qxN/FoBEK8WKrhnifk+hnIYa9tXV0OxCgBkYEqMOuGTBYWTK
	gYRRTUtKbhBvt/Kf5NTBX1dGJDbhdMU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R6cAq3Hd;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346812; a=rsa-sha256;
	cv=none;
	b=nlM4lUKull+Tesk/bG3g4nTny4+GIyxQVmMEu5iG4UVeHx+TCzFCpa4PFBqYhEQVVXIK9K
	Vf5kgr5h/yGO1jxfxyU30/6by4jq3uxNhBZ00JEsAAyluaNoklQdOjHvCmKN6IYGCl34yN
	+OTRV/MMWKcIcSmdH8wX2FjUkbrm0tM=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57d5ccd73dfso232982e87.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346811; x=1759951611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
        b=R6cAq3Hd9YYp6PpPOeE/RuxDSLtYfy8CxwNgKrwSBCRb/cMEcgIkdGkCDxco+kJtVt
         L6NB8W+RPGoezLWM/ZWEgkg+W9TY9JG76AS4U3j+TQcOrtyzsEOQXvICzZfy2c9vkSet
         g5kRCfP2DC8YSrep2ICnXDMvHnSuqOuBb4PZrQWPmAfpOIqQ0zNu5jmUD8eihkhgb4V+
         sI/2nzvOfECOkcEd51mmZqVFGYu5IJ/CYgSejOf2QREbe0eZ4JkpZ0c0as9nTBhAV60o
         iOnELJGuI9gmkrCZPI18dH/Me6M8I21sdMMM2vY8PKtjngH/bi/+7OonFQwmEwjPg7tP
         c4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346811; x=1759951611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
        b=UhL631uioMt2c6DnWee4DfAAxAYz8+Fs3jzlMI/kii+fCyEQ4s6xhtO4lU8ryHUV66
         9HY/8QDuRP1SghLnKF6ZO4u/xkA3B0W0eLorEJlQ5grS+TXQWHVsi/7+JdfwHe5IvWY5
         y/c0EsM2XjL/t2odGBb5VmAdpRkGfA74uyj7ngRnyX3c2aOGSAhByeRr1K8xtL4L/4Ud
         zkFnjbebsdBxLoMlaxzIIOulW9hRRS5IEZnSS3mUTaEamYbAsHmoiHwM/MpgQ7dmes3L
         blV8Re80dT/YjGEcF2l5kr6BruL7PRxhN5a8MLgXx+EFVFUn+qWVaQww16nuit7p7Em9
         gOlQ==
X-Gm-Message-State: AOJu0YwWyOgLn3mlOzSVn9h/BcJHuXV39Z5s/ooFIi0gtGsNhsjZ4TJc
	R+x2L0OqwQn273eV0piWqAsG3YUBnvL2Qh/5hkBakFHv8zuoaSM4edm5fWzJ5+6U/nc=
X-Gm-Gg: ASbGncuCOMdOjMSPQod22fOit3Cwh2t11KMDVTfACARUHx1aYB5CXd/Sm4et/sG9fjB
	Nndf86wnPUCZb+CtRZNiz9nxH5minFdeA5uwF5DpFPxJtO/h/GwSGVYR6NganuyN04XOoszQepI
	rQrhxK4N0AGLIzuWIRZ8oBEU2+ngKrslixuqkbomt1Z99G3McA1E7tXZvyUzCSehmo9TslDY/5/
	QdKU5oqVsPJaRjrLCaItwN33SrJsvA0TEpMKAbcEeEGIy6JioVHCuQIJ0epUl8ULl7tAAH3+kyK
	2NemeW+uBABNBtfyc0FmkDOLbfw9A700gmPt3uh9o/I3Y/x+PdPdVmMNIuoK7JSvlE1x/843Kn0
	vp7fRYoX+DhFGPZcs4yqGEbMPqfEVnOnwcFO+FxDA
X-Google-Smtp-Source: AGHT+IEf29nqQKPfqYlqzEpEYNiDi956qj5XBnEwQXCvp6W703JnoRPSW6KZ+JL2jB5rOA++8NRQcA==
X-Received: by 2002:a05:6512:3b29:b0:577:3ccf:cddf with SMTP id 2adb3069b0e04-58af9f6cd35mr1447231e87.46.1759346810827;
        Wed, 01 Oct 2025 12:26:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:50 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v3 02/10] lib/test_vmalloc: Remove xfail condition check
Date: Wed,  1 Oct 2025 21:26:38 +0200
Message-ID: <20251001192647.195204-3-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ymn986mh8oyscy99ixbcgnnbah7mttpu
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FB3E140007
X-Rspamd-Server: rspam04
X-HE-Tag: 1759346812-231203
X-HE-Meta: U2FsdGVkX1/wPjXtxz+mbKc+MJ69enwtt3yvrLTU0P29yAVKWv30mhcXG9PhTAXqrAJ+90VhRmjSDt9k7iblaRgOlu6odv5ea1DDbt0Yw5R04lq9PxViLCaNLviOJE0GzCdAVKFzFi03aI3GYxzoBE48SqXcdehaWi9iw10txSSMKVquBEkaQYX7MCV7rvzMVeG+lA/tEO/P3k66iLcEErpoms2PHyT03ZMdslYbSNHLfk/+0/VQtErKvVVRfn4s1cRqG6mbgqtGz62cqADVLg9BEEO4gyFI2OLN5W7Otssy3tIY4Ii8q/78+0jYwn8CSdhq+fa3sGeXLQjGwMzOizpkxcM21hybL9LQDYS0GAn2AeCI7PXJ/YlO/iaDzC1DLLdO5SyuZYyr+pc4ZnT67jdgZrwtBbGGyL4FgxbrhjEA0aRz9Utm+RkOzj7vgG3mojkMcjZLQpGJC78h1xlRW60CcFrZn/e2tJLJQKlPFFWrDhuEJYKKW9GuLYq31upSTAKpad9pyQeNLWt5O7PfW88e/HI/bjLq9IKc7aJE3QW1WetFEabo9nmDir34FRwEccOlKI+2jDwPfRvDR1LuuGizXczKVIMDkFb0Vu2F/Ufer7X/CrLd0R/AhinMhddSv043lqle078UX4Eb1wMcFj05f14WYURkAOkn7OV5Clb6dLZNmGy804lM+WexLf3dV6+P0nSlbJ6siYQgkGwjXNYA/RqpnontffrnBkiAUlsDOLU7pwdubY4s5sn9mwDJHpzYu2z9kQmb+bvjn21jmQ0/mXjHPePx0SI7OXko1GPWPQ0QNRcLVWFiC1+dd90rld5tXZaXGFcP3HNmv63yk5PPTDazk3/pwzPwO7jH8Ly/mJe5MbKisxt0bltFIQNSSXfUQs13rlkdCcuMbg/QALUHYKuOgbYDr4ouEm+QmaPizJtwOug1stjUhFUBysuTU4K0SWz9pUQ9ZFhGfZR
 b9Cp1X4A
 l/DfOBqSVF/vZzy1tWv5q0HG4Mma23zaDlVtN9JGWudi9eArgSimS9qM7gty2TRUaOFJApnrFIQEEGAVzlku3M/umlYBxWaaQjRKiTeaYmRsMzp99RTYV/ni1iZfZ34wLjqO6s0Y+jbS0lcJVoXULaQHigj+448iqADgdoeNrEbvVj0/Li4VdtzxXPxY0uat5kpG4IxD6SfBp5+FCSRoZsV4eJSnNp6Sr7XpAGMs8EW/LPKxJL8xle3DavHoVFGnvONTe8WZQTJyx61rQQbtmGGZuYWMnt5BCGd/UOl90lNWjjTcHDTabxnibekqdTa0RhlUeDLnG7Mv5oRZ226SjP9HHFTxAiSzowzQjlaaaugk7PPzp0r9J6YtyHUHkKs36AVM1qCbcFGfEJ9GRB/rh3RgStAP2ULVuxE9VH2dZSc/2xRC6PS+Qk0mTsPMzpJzDk8I+rjW0cFTeP6GR2/98zQOjFd+/tpfHev4c2xkSBR5+3tXvaKMKqGCNwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A test marked with "xfail = true" is expected to fail but that
does not mean it is predetermined to fail. Remove "xfail" condition
check for tests which pass successfully.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/test_vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index aae5f4910aff..6521c05c7816 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -500,7 +500,7 @@ static int test_func(void *private)
 		for (j = 0; j < test_repeat_count; j++) {
 			ret = test_case_array[index].test_func();
 
-			if (!ret && !test_case_array[index].xfail)
+			if (!ret)
 				t->data[index].test_passed++;
 			else if (ret && test_case_array[index].xfail)
 				t->data[index].test_xfailed++;
-- 
2.47.3


