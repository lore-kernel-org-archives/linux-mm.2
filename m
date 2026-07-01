Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10607C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33C96B00AE; Wed,  1 Jul 2026 07:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0BBA6B00AF; Wed,  1 Jul 2026 07:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49746B00B0; Wed,  1 Jul 2026 07:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBC446B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:47:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E50614032E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:46 +0000 (UTC)
X-FDA: 84940033332.12.AAA4407
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4D4654000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ME2z+bk1;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906464;
	b=7Jf5MB1/CmldXN1/+9YyFdvKJ5RBvFeK5B3H4Vzhl/VAYyt4jD2+ogAoXqFeLXzCLcqD6x
	OP8oCu7omxn7FN5vn023nVeTMZvoaqKWgNqd1Wu2JD16pDSALYaI5CKmoqqefoAGzWbPEr
	yj4bPt8+yADCpugEmt6bIgYZIqNrRCM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5mNQO60b8nT7uv9aRlYZCg/3s0UiXqqPoo14TkqY90=;
	b=2lNG02S3Fpcdo45empwZTiy8vCHVW4BYCv+mw00AS+HvNPKOwkANDjN6qTJ0BHzc/vY9ED
	/vMEvh6SkFXQZt/+8uPIL+6fA2gIlykmEBx0n0t+ziXo1VOByjQHvgVsUvn8qWtSjsOeGl
	LgPIwJR2oWzQ7D48j/9Lv5RY3alkoBk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ME2z+bk1;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30bf8b2bd20so1035745eec.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782906463; x=1783511263; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5mNQO60b8nT7uv9aRlYZCg/3s0UiXqqPoo14TkqY90=;
        b=ME2z+bk1yoXmKByBK/YvKjPeLp08ThNNOmUFtEVJYPTOsg+bjlDpQin2RU0vSiHHjn
         WNOXbJhvpZRLrF5Hb6h1tE+gAGeRbj0iLvLM0UWGUGjTb8o49ClLV1j5iWRjHUxpLcdt
         07u+qU15kFuSF27YFqGsH+MRT+Bk+flfsbDewmNlRvcF9rEma3SkiIR2YA5fLu6BgqgE
         YRh/xo5PapFFm8rj1PC1CGRKW6LVA5h8VwPqxOqUiOta/LBe0sYPMVNaqSl0yvJDmKLO
         KJVcAg+YtCfQRRmlOcUV7LNVQV+VQa1b5vT9PhRC4XhcPh8mJ/rtu47q37imQ+WVSuI6
         h1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906463; x=1783511263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g5mNQO60b8nT7uv9aRlYZCg/3s0UiXqqPoo14TkqY90=;
        b=OLDNW9y6RPiMcpK2LfhJhDtk/zCRkRIecgloLupWm4ktF75eQMPzgvVEQ6w3rPOpm3
         ysykTP2iDf2H0XeUIXYL1/WPVdC2ixkcZs8KduuKBcoljkUZvZgYP9tsX5LatGUGHj9V
         9u4QhrhZb/BwnHc7ZNtCZSVTVaGHcbLjxtY40a/D955JSVZjwN3N1pXff6fSGqSXiUaC
         7zAH5JUcmHZCjDVuf9Hd8boIjM4eDNDRBhBohe2s2VUqIlYYTID5essI2InPGD3NneD1
         I47qBv7nTrRVVXiOomYrqhT22ivZOSNZ4p8fYLS51wom+Zbg5RLjvpNSMY/7hzUYNpVT
         dZSA==
X-Forwarded-Encrypted: i=1; AHgh+RrFEYeYcATrfjmK8KSh01wHUK5MOnn3Bz4cziNClLJoh3M7QSTTDF0HrvLdZ90M/Mo4X+n+ED1C3A==@kvack.org
X-Gm-Message-State: AOJu0YxNb3UdQh+390GfjboWJBFl5hLPw8SylyDFc3CtVQZNeX226ioD
	t8qYlDTJPikW5Vzt2M9sdGzbYaVJfk5txfp4zCLHrR/AI9Hf8E5x3HZU
X-Gm-Gg: AfdE7cl/eWs0AIW+LWaSZLrPMy+p5jnbHyUti/eUk5IR+U46E4+X+M4ApzmWyBTCSfG
	++TXEZL6G53QzMRmN5xUyc2kB4419iFrmYlK0P+2d8a9FjUGJbdhvXuchmN5trSKNsbqvwe7pUo
	ML+4dzspjEgzaDSIMOCsEgcQ4ll0T2AshcwvsnDeleLkWGuJ8rW9LGIJtrcDhsI7qEIj8xmf5pL
	i+Rz23qnYrQ6B04JzO0bSUBvAeDGenerxahQLcWux3c+Fl+yTZDpc87x+9cBEYMyVyQoRNIa4F5
	yzJVsYkdNFaWlFXR8kH3nH1lDsMb8gRlWMLMJlaYbeoRo6EEcO5sE/2snCeEPoVJyZqP3BlUONN
	jTqypPAEof3hU0IB7UKMcTu0NsyYlTG7WPcDCAO5/Ub/S2EK8/JxoSvzNPiumKdjNEfT1jmQizn
	wanA==
X-Received: by 2002:a05:7300:d50b:b0:30c:1865:d9e0 with SMTP id 5a478bee46e88-30eff07d7fdmr1439014eec.16.1782906463047;
        Wed, 01 Jul 2026 04:47:43 -0700 (PDT)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee327cea7sm22518169eec.31.2026.07.01.04.47.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 04:47:42 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	sj@kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH v2 5/5] mm/damon/vaddr: implement DAMOS_SPLIT handler
Date: Wed,  1 Jul 2026 19:47:16 +0800
Message-ID: <20260701114716.56503-6-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260701114716.56503-1-lianux.mm@gmail.com>
References: <20260701114716.56503-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hieipf5cox1yoxuxwj34eeh797id7ya8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D4654000E
X-HE-Tag: 1782906464-830221
X-HE-Meta: U2FsdGVkX1/418IBa51WooWES6dL5DaQ5LKg56aA8pPVbsgKX+hDb2VBzkp699IhV9mRUXQ4gexTk00hq9q53BgDvfBo+diaIqMsYrkybtvdMLOB27tnTVIpHn0/oS0bC+/Wr3KubyVI6oj6pfuVOR+qUfDAM68iZKvqDh5G5136o4AbrR8LT3BuqN0xSRSBLnN4AvJ72ogqml/aYycycQ8J04NQd+Afv8HVEV/3iDVhmjs3ThwCLvzAxAUE76vdMDr1YhAiNMrZoiC/8TRw75APOft4LWNpUiUhEzj8ArFnAI3sd33QOR5OtB+sgX25T84RI5r1ennxtr3n+/bo4RMs2E8RoyhCsc9XZmp0YvfNIKr58l2xN/+ARJPx30GOFYvG0RhpMVtZN5/d812GlJdVKmsWOIU8q5Mq+brC2rHnPA1JTclckPXVVZrW5KqObng0Y6PtuWGevIrtEtI+HKhcm4MYoEI+tJkusoeY7Udm5XGbBio0ywW5gEXIXrW7iMnWiXLZGNS0rbycoc2vfAJmzvDF2Mi2MiXY3MIaRwN06RlR/5X5rSxE0GWT/FLw8CP7EDAQJ2kwK+0OW+QUcA3KKr2VsUuF6yEn9tVS4P21fYPahfu00t1yH9CNptESTunGF7rJRlZVq6hQ0JX/zkGBMydDOzzd3Q6TAv2++/J1wdmrRlYhqdxa4qOF4bhlQZmdNe2QeBfBa1rWP+9ADiHsfiMs58sVrnT8yx7J78xJgVbUN6c8kQDZ2Xl5+2lxYgWsR1PxUhiI7qxR56HTjWEtUT0HG9MzyznwUCI34wE+plTpc4eCk3FJk6jYrjLJsIyNdQtixkr8jCb8THUJPUaMzJUB1sBaZ+CJ5FtcB+Ie6h42lVg6lDm/qwBAK6vfdlKI7V/BrNTOEfDawKtXUcOZ1BxF4Z6+yL7a7yyGAQsWl5W3RTBML1XsZyco66BPLFkp4bwZ6cuG3MLYzMd
 BjwUAgiO
 HNlg5nOUaZonAhA80N3iAZDQwkTeHrrHUQ5S9f0T11PPzY/qh5a840Qg765YQIP0QlTdHfwhf1TeI36zRHrv2wwnzD/8a4wC8WMSXdGFSAUHB/BTyu3dOJ8sTOt/FoJUHjfEYw2jNVOuY6Q4sAJzoL5P0M4FW06T9P8Ov60QSV9Q5qfk360tRnNaD/cRpuJeEb40/RlmjntK/Cqmqj70JvWEbPKftKcXa09RYmisjSZuJPBouVerPXYqpM4xm6k9Toh9Wz3XD1iEycI7OQ0IrPIbFReUJtLDLqNw8fODwzpfoqLbyzN0mfhXtHGKNKcz/53Vu36tTrn4Yoj59YL0UBspMjxx+Nqd3NwVlOavxDlXuuwr7pppfIY0qNb7+UrgbXRR/dYDNOc8Iwm0W2jTGEDkb69QfUjPeBBzXhtUuuJjvs94mNlHkUrGYWJV+X2HJUj0DANaQ3F/97wxiiKftrM9d7N2PvNCUUgFj1r5KgLfnsFWN7XVQDPi3MYnV7/02Sq7od495o5vPLc+Vt10bSzoe56t8QBnuJuBOyLVVDX1m9YJfvCaRsDiG9kDv6F8KvHxOb07315DOQYNNIiuX32IMOeTDGWtb+mIi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wang Lian <lianux.mm@gmail.com>

Implement the vaddr operations layer handler for DAMOS_SPLIT.
For each folio in the target region that is larger than the
scheme's target_order, split it via split_folio_to_order().

This supports both anonymous and file-backed (e.g. tmpfs/shmem)
folios, covering KVM guest memory backed by THP tmpfs.

Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.wang@processmission.com>
---
 mm/damon/vaddr.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2a3757c13bf0..3f2061b29ed8 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -934,6 +934,71 @@ static unsigned long damos_va_collapse(struct damon_target *target,
 	return applied;
 }
 
+static unsigned long damos_va_split(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	unsigned long addr, end, chunk_sz;
+	unsigned int target_order = s->target_order;
+	unsigned long applied = 0;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	struct folio *folio;
+	struct folio_walk fw;
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	chunk_sz = PAGE_SIZE << HPAGE_PMD_ORDER;
+	addr = ALIGN_DOWN(r->ar.start, chunk_sz);
+	end = ALIGN(r->ar.end, chunk_sz);
+
+	while (addr < end) {
+		mmap_read_lock(mm);
+		vma = find_vma(mm, addr);
+		/*
+		 * split_folio_to_order() supports both anon and shmem
+		 * folios, so we accept any VMA that has a folio at @addr.
+		 * This covers important use cases like tmpfs THP-backed
+		 * KVM guest memory where cold and hot pages are bundled
+		 * together in a single PMD THP.
+		 */
+		if (!vma || addr < vma->vm_start)
+			goto unlock;
+
+		folio = folio_walk_start(&fw, vma, addr, 0);
+		if (!folio)
+			goto unlock;
+
+		if (folio_order(folio) > target_order) {
+			if (!folio_trylock(folio)) {
+				folio_walk_end(&fw, vma);
+				goto unlock;
+			}
+			folio_get(folio);
+			folio_walk_end(&fw, vma);
+
+			if (!split_folio_to_order(folio, target_order))
+				applied += chunk_sz;
+
+			folio_unlock(folio);
+			folio_put(folio);
+		} else {
+			folio_walk_end(&fw, vma);
+		}
+
+unlock:
+		*sz_filter_passed += chunk_sz;
+		addr += chunk_sz;
+		mmap_read_unlock(mm);
+		cond_resched();
+	}
+
+	mmput(mm);
+	return applied;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -967,6 +1032,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return damos_va_stat(t, r, scheme, sz_filter_passed);
+	case DAMOS_SPLIT:
+		return damos_va_split(t, r, scheme,
+					  sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.
-- 
2.50.1 (Apple Git-155)


