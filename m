Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F3BCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488B06B0095; Mon,  5 Oct 2026 02:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460536B0098; Mon,  5 Oct 2026 02:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376056B0099; Mon,  5 Oct 2026 02:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BADC6B0095
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:53:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9534E16015F
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:08 +0000 (UTC)
X-FDA: 85287655656.25.41F960A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0B94140006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nHdC2h55;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183186;
	b=p/tpRH+ZkX+Rnl/1VHVr2Ccop8SH+v4Q0coBkLOSoLWllHlIZi44OERQE2vToXtYgFeNp/
	BogWLKtPF+MfqT7iH6zuf1BHDQYDWOM0OVZ5/XiqOeYWWHvknxaugv1pMgOs/JbqnIh2LE
	uNlf39TiFijgg17aA/N/BkmOhlzzSgY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nHdC2h55;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3qCoCe5HgkC4I11/aszYLTcw78qjIhlSBPgmqbtI6o=;
	b=SxBzgOGTHkrDFcemJCGim1dEXZ2KlCeEPN7h9AGQDrT2299dY/Qy5MLoSrfPzs5ohy+Ek+
	54tEpTDApGzckt81cEZsD12pPafbU1aEm9uKSVdxofMZ9Isqt0f35CasTLuReRlltb9WBm
	+Sj+syWr3dvdP/7sMA2Ho9HmMRx07m0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso6628375e9.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183185; x=1791787985; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J3qCoCe5HgkC4I11/aszYLTcw78qjIhlSBPgmqbtI6o=;
        b=nHdC2h55A2V19vdrBe5aefxNDqiXvGiy0EwLEgUCKRDsyS9apd8OAlw+B9musWzcfU
         SDeIiZGqA8ZvXHjTOhfkS9hxfhtqww4dK9I1W7gIfJCkGmAu6xqRfN1v1ZO/nmS6QUWN
         6WhtgwA7EJ3Eg/Gf6U1dQAltWF6JXh3dtgirlnZfhtjoYsEpp807f///x3kJO/1nJykA
         zJ20crdD85L8raXiPVqxB1w+qC4Ja0qBH0mNjG6V/4+Bh+PrKkMILE0l2jsFSEujXnvZ
         TaMURj5JwGSkKzjSiBsg2BOFj8+4mZZzjSgslhUqEJpio3+PMkjR62/gQ4Wo7sCCo+am
         ZPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183185; x=1791787985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J3qCoCe5HgkC4I11/aszYLTcw78qjIhlSBPgmqbtI6o=;
        b=venBW6BR860ysIg7WSv8EYnSCqKALFd+IMwxojP8UAq/QxSH/Xqc77Utv3gMElGh46
         2gx4JCX7K5MHKg2VIpbCstdleIie/hgEtDycwZX5UHDnXagRvGoYHkxH/fpqIe8zjvBB
         1ab2hPZ/gdsmpzR1svjjioei4NGRcc4oNMWdglmdFsGDmI15dNVEsJL/VblPN4yMHZnv
         0OVo/0V6ra4v6sm5Z3ecBQ87CXVbkRy6tYwzXfYV8v7DbURLzyRo/DJilu0CF+E2rcsG
         vC/vtpZVBLEoPjh21DhixibqQ22KJQ5IFVPv77edgqRwkgGc7I3rbzx/3OoLh/OMfkcT
         Jq2g==
X-Forwarded-Encrypted: i=1; AKwUvBx1FCp2ia0Nf3Jj2xhjIFvYmgynmQ2FuXXYdXW1Nz1fYDzOUO32HRr57t99sBdwawgQ1j/2+JrfHA==@kvack.org
X-Gm-Message-State: AFuF++lAdSnholr8iLAt0GGPkd7qw/Uom+7QIMwpWRZTSe+jtKMSqyR1
	pvmE+v+YjLjNTVK6jmL/N3INK+ljFwAy8Uh7gDrTHIXa5ngl4L7W6VSh
X-Gm-Gg: AYBFou23OnkyMJWj2g+kc+4wK1zi4KxZQiH4Ub2weKmT4sIYTnZOAXUQpCBli/o3QLL
	lxLXLJPkpz2jCSUjVw4pZlRloABqENTcCcpfSPxX+8SKEZ2j4tMIjBh2pg4jys3A7ux/dtIRn0N
	mnWUibRMNQCP+X1N1H0bxTN+/hHJZ+/Gon55Bz5GHIgTWpGCEEgCzFr+fsHlkP1Sw4S5LHPZX7G
	A4wpS69D8M6zAoXq50LkNQrTzxZ0ERtHMpLlfpNzocWhBan/6TOLNQK5Kev3NpAUkx/4CkW25ib
	bAoPvKBL6UJ1TGstgIN+aoVUpJl2ks59PbB4m5zTZQvAu0fU48J4A9e+ompfFc5YXi7f/ZDXx9m
	+81IjWi7e+2DTi9Q0A4jJYQTyeWoVXG4UvjRfceR3OBPKWibBvKejGiO+bGEZkco6hHxbnFVxLd
	AQ3CnB20wbBS2z9WP3rlyaB/2KLQdWOBmi4e+T4mAsgW0mFOUDe7QTdCo=
X-Received: by 2002:a05:600c:a116:b0:4a1:6517:ccf1 with SMTP id 5b1f17b1804b1-4a1680e9524mr72604545e9.9.1791183185355;
        Sun, 04 Oct 2026 23:53:05 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6308481dsm1247436f8f.3.2026.10.04.23.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 23:53:04 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Park Tae-sun <ts930@dgu.ac.kr>
Subject: [PATCH 2/3] mm/mlock: reject ranges that cannot be represented
Date: Mon,  5 Oct 2026 08:46:30 +0200
Message-ID: <20261005065244.6935-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005065244.6935-1-azpijr@gmail.com>
References: <20261005065244.6935-1-azpijr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 4jot534es8fpmj4wo6gsozexrrisjfkt
X-Rspam-User: 
X-Rspamd-Queue-Id: D0B94140006
X-HE-Tag: 1791183186-802324
X-HE-Meta: U2FsdGVkX1+uy7fvyLwCxzMOf/qZhdlXfHkSqOkVMyuUysKvYpmwVAW+jSr4JvY33N6aImoDYJeRLSSymWHIwvsPNy+17auT8Qzkb5ruDJ4xDx9iY4LO7UkWMlibe3ZAqxwTEbcczBUCC8mdyWkz3mSVTTCxm6E+68txEWSW6l3O3tXjQ73N8oa0QxQDkx9QxBrT90YGL+njKN/Rt1E/p/ak0lT37fz3SftG0urzUdmhtjvRV0E5Sco9GkWdEVoC/y8hRahIIzuWnCfY9xAjsbgOAiKs8hrmWkYYU0bkVnYyqfKSORT84liMRPabyXlGeJ4Wl+7oRmS4GgCXHfFvKT2XAjaUw82UGI3OZmhm18uvYhIWtVRGesoTFO0qkz1GsUIBnlmkupt1/j8BDBTBLVe+aiK3nuFWzW3UkVsO353ioRlPzvRN1GH4zbNy74QukNXBpUKKjY6PYLHRzomabF5mbhWLNtOthX7as3SmLgslg5lIcI58S1Yvv9fseBBdAlzu4ImeDA+Oq2m8DV0ZZ9kkWxyTY6ex1GWLpcUCYuU9DzcF/NRbJjb0MHZ/VnIDYETfKmzXOvnKcNr3USy5LGdbrpZaR+Ogxgu0M4hyV0r9v3Z7eZdFT0R0giT1SAG5od+2CnWFpbNVFPcj9aHuMPcIq/buMXQWpA+s317KfnsxVLoJEXyrI81w2FvVACvBAt5mN0B3RTx6EZbH7/dIFGQlaUu7FOYyi/KaPO8DYZmniPALBmKFLFtL0JJqFNmcGMIinITs/dcqm9NVe8ANxj/258Jix6cuugpN7y+sEerpT+oILlR/TzeP4Y5FjydvqNCp0QI/Ctil+s15+MgfWIGMu7xR3AOD1TXMXqQezmhnF2YeQKlJw4VZsdKHOry7rFnzDEoZ/6j5QDjv5IAjQiN9zq2wtYDSFC4Rw5oFQPihSyT3rfh0LMDqokHOBIXLGxs/ENg0NgwIU/2fKUg
 oqO4lzdM
 IOHUrafk0TmoSPCMHsGNz3s1mniriKzYzfZs+tZU0qlUH0QER4zcKWDtKuLJbOceZRjrhNsFyrXtM3Zi9xt++yA2R1zuCS1enN7QbWbLM1KlzNm+d+iS5kBvWkGSZKSJWrQTl75gaYSCbxtuF6BCg7xpi9d4XUfwKg4EVoCOexewFmFvWGBmE50q8Q7ah+yFeQlk6rQmMUOuPs4KLD2uStYVvm8o5uP2lAlhn9k01JxWlvWpmZA5kqJ2lOD6ClymRINv1zdKQj5dTXGm04P9C7WLWX+w9wvZxOdLnkZmBcVQapX1oEwYVlGUdcowDXxy8l7oWsjPfesTjzDs8ckbWmSavrATY+hkD1kIIyQ35kqmWdHVQeWqeTCuWhl5QFF8RjQ/6kZBesuzPWumlGLlZTnOiAVPpS1vhayoO+Irs/82KvM9j4xX8zRhuFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A length within a page of ULONG_MAX wraps when mlock() and munlock()
round the range to pages. At an aligned address the length becomes 0 and
the call is a silent success; at an unaligned one it becomes a single
page, which is then locked or unlocked. An overflowing start + len is
only caught in apply_vma_lock_flags(), after the RLIMIT_MEMLOCK check, so
mlock() returns -ENOMEM without CAP_IPC_LOCK and -EINVAL with it.

Return -EINVAL, as man 2 mlock documents, when start + len overflows or
the end overflows when rounded up to a page. Doing this before
can_do_mlock() also avoids making the result depend on
RLIMIT_MEMLOCK/CAP_IPC_LOCK. Requests that get a silent success today
now fail.

Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Closes: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/mlock.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index cc28e5d7413a..a9e2b90c058f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -608,6 +608,7 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 {
 	unsigned long locked;
 	unsigned long lock_limit;
+	unsigned long end;
 	int error = -ENOMEM;

 	start = untagged_addr(start);
@@ -615,12 +616,19 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 	if (!len)
 		return 0;

+	/* Reject a wrapping range before can_do_mlock() and the rlimit check. */
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
+	start &= PAGE_MASK;
+	len = end - start;
+
 	if (!can_do_mlock())
 		return -EPERM;

-	len = PAGE_ALIGN(len + (offset_in_page(start)));
-	start &= PAGE_MASK;
-
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = len >> PAGE_SHIFT;
@@ -676,6 +684,7 @@ SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)

 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
+	unsigned long end;
 	vma_flags_t flags = EMPTY_VMA_FLAGS;
 	int ret;

@@ -684,8 +693,14 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 	if (!len)
 		return 0;

-	len = PAGE_ALIGN(len + (offset_in_page(start)));
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
 	start &= PAGE_MASK;
+	len = end - start;

 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
--
2.55.0


