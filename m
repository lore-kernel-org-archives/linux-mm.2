Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB114C5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831476B009B; Sat, 22 Aug 2026 09:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB796B009D; Sat, 22 Aug 2026 09:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA126B009F; Sat, 22 Aug 2026 09:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33AB16B009B
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E92E120147
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:05 +0000 (UTC)
X-FDA: 85129049250.20.7E17771
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf03.hostedemail.com (Postfix) with ESMTP id C4A2020003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CW8GEcX6;
	spf=pass (imf03.hostedemail.com: domain of 3-qmJaggKCM8vCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3-qmJaggKCM8vCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iy152RdCZfa3BuEh7IM6k3QBkRdl6kOpMlXoFvVNGkU=;
	b=FRZQt3ejx/PwTK3JpRk7v9zu4dRnjSYega2vM+b8xCuP8XH1BMetNcT7gd+ToeWccYSXAQ
	ZACOPBaWW0noffrgWa4srsPwFDO68nnykvUhLDGadbZCy0v9pMzspnVAZq6HMyW4WbxkKB
	uZqzAWGZOpI57VwhISBZ8SdtUtTCLSg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CW8GEcX6;
	spf=pass (imf03.hostedemail.com: domain of 3-qmJaggKCM8vCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3-qmJaggKCM8vCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406843;
	b=cibLKPpRx11w3RAwhH3+3t83gcvYatMoneGHJlUD6MQkD4SH5iE4oeJcfpxLtCxywKSPKV
	4NZDijqMAH8zz86MyYLAOBUn1bxs20THZNhfU23kNbWK4/MKRTnxxqmuVmMq/55QDY233e
	SpTOB5s+wm2QmDzSCQkBgdtmqI70FQU=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4955d314945so9785065e9.0
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406842; x=1788011642; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Iy152RdCZfa3BuEh7IM6k3QBkRdl6kOpMlXoFvVNGkU=;
        b=CW8GEcX6S9o8fz3x/T7COT8C3L4R35HjV1yF4xdzOiIx/nJw9qef7Cph20pg9OJtwy
         a6NFsGNK4jWO19uyHiNRKvxjfcd7s8PxB6CMN1rg5mZgbqhbaVP2WVWKsmGAdIqnp5Fp
         z15wEUz4cwakZqmqvWZmXyLxG4a7v6I1Om1ZOu4TvxLSeVW8wggW5RE7TlxI2lDOYJCl
         dvbHETUT+UxU6bzBjZuMG84EROj6khsJTjNH+4sIToYmpPalDjBMPzaM058RYY6VT0id
         gqRxPzxPvlIUvj8il28JmaRM/QOvDVMCavc7qmbYUXf+PNr7v6HSHejbc4jm7RRQHOSv
         sFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406842; x=1788011642;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iy152RdCZfa3BuEh7IM6k3QBkRdl6kOpMlXoFvVNGkU=;
        b=ebpgv08v4V4OTNRafDX7QJCv8Wj7qmZfqgIEml4f50I2IuHRgq+9lnLpp5KiUKjT9A
         uIyaw1ySTZv/hm/9qVboyEI5HWi68lYSz9mkPZdhBbt5srLnl/VhuvAZB7aXHGC3X15n
         ixVZyDzzdNxoGnd10xs1E1fCHgyUhu6RqObjGmSQtOLXA25BZshZ44a+otIyUucVQo04
         dBLayA3iHXqmfmzZGAg7tIxThpcphCz+CT8zpAluBUGuX7UoNKqbXr9w2Gs3UaEzN8je
         9QSSK+l6OcoD8VndbHF04vcVN1b93jy9O4PVMs28MYt96w/mBNkncYq/jnx8EJto/Lb7
         UXBg==
X-Forwarded-Encrypted: i=1; AHgh+RpGt8ZUwvMP7Y4s+4bMyC2P9Vd51Z2/cv/DnZ6NsAOx1fMnr+ySHZbR7uoIb2zR4vWbkANUPFeSTw==@kvack.org
X-Gm-Message-State: AFuF++n9c2MU8IzbIHfkedlI5KKqcOV0+iuhmqB3WEZ1F1J6x/WcTXDK
	47AmbvdiEo20jUrLXyAmWqbpTi3QcNRwqHGMHc10jIesKsk2VtP24dLERYxAXkTGyxOlMiq4Pw=
	=
X-Received: from wmbd17.prod.google.com ([2002:a05:600c:58d1:b0:499:c849:1518])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1552:b0:499:49f3:77b1
 with SMTP id 5b1f17b1804b1-499c19ad953mr53970335e9.3.1787406842383; Sat, 22
 Aug 2026 06:54:02 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:23 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2988; i=ardb@kernel.org;
 h=from:subject; bh=B9vd29okea5ocqXwmV5m+3LPo6WPI7iW8XzHP/zdLDo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5dVpa7gmF+04XHXv0Ldtx/jvSMk88RI+HWdutLtap
 Wi5rVx7RykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIpTSG/xktVZWhn+fx1iX+
 bvjnnZkok/3UO9r1gvf07LoHPi0HXRgZDsyUzJr3gL341aYFm75+/P88IPjPqYkbik+7C0pNn/V YjA0A
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-12-ardb+git@google.com>
Subject: [RFC PATCH 1/9] mm: execmem: Add API to split an existing execmem
 cache allocation
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4A2020003
X-Stat-Signature: nfk9oq5g6o73u635ayqpe56jxwnq81y5
X-Rspam-User: 
X-HE-Tag: 1787406843-546523
X-HE-Meta: U2FsdGVkX18DVUJTu5eRGm5B3zHVZ84QL70FABPHFubjOxvW8CnEiofm3Cqx6kqzp6wQ5mGmBqXbHOgI631cFZn/k5YJjShqWxCCEhbebQnilIb2NOhjw7njQOJhWjSMQqPNq3med6m5AS1kolnyoAcDapzfBbnLqd04mx82YrtKkYR8TI5bdVUGk6azdkSziRPsjiQl4Cb62dHHgz9lVesn/maIS1w6i2/qAwd/9JadsjQEcjRmJhuOI0TFQx4rBUMjG87PqtMsWBAo5qFq8RvWL9vhXjNHPrUT7hsAY+FbQPPPQ4bWqnzhjNj4gJ+xJvR9cND6x83wb3iF9STcBaF7ebzGpm1X26d+m7rr+1+WwGJ/TH0Q3fzFxEwVCcRaGkEgPDvjtIZakmJxZCknbwrUWqgA38s77I5GMpE9mZ+/okQHhAsqtXUYtms1ggqTPdA9+wnqauwWR1Gb3LecvS3wH4H+blzwbs9BDrTZfcDAiIBWndpIdVqw1rbplp04Dv+sqAbQSf6NXXGYpw3i/vRgEZvkSuVn7StjwvgqiFpTVmMQ1o19jw+rL0EgqTzMkW8+E/i1SWAtTpB4sw9LuaI0FoqvLm/CGCvEUoLo+cRWlAp0CqkoE2efkhG7VVxn9ancajJsGamCSMoiweug2/liMF+xufkfhm92w/10alsYMkIaOh1FA4psw0hdN/cuTF6Mga7jRhhVADrRZQYM9W0K2E/qHvA7y0c0QYgHRDcBcomIOmIZD8OsGc1WU3zjUnuCj2dcrDdOHf1nAQeXnEm3qeahXsQC8suHfi2ZrWjdr+SwnLwuFHmVZC+Qpv4Ed9LbpljrX2sescqM8B2dV4FJU16d7Tc03Ow6jXueQNsd/lVTuzPN+bjICHjtviAhKEB5oiOmkqfm4g847ItJYn+3Y42t39GmgyiLKxnM8kbrk5/IS0sOaqm4NPTno+91qiUzT0C4tB141JqgUmp
 E1PlqHYh
 bE1Mp8lVUXvSqKZJMHccaXjGgOO9F2iNU4yGieepupoIlkSinuZKMN/aZQGEe7wlfpqTSX6FZd6S091kAhESmmKwWa31+hm0uZqbtM6iOivPVznWi6s4MehQXpDWYWZ5U2vpUV+Nmlvz1bXLUfCaC8eY7p5BzB2HHAK26KTLM+c1E1izgDLc4FIK1v3gyOGs2baiIBuKLuUqy7jpLxFEfdJv5VXm1dBYCDGv4mmolC1K5Wf+7r8+IOt8igqdjW/DFeegUouUOrHRM0bnwzLWOKyksTYeRqo9JhTKGfeGNccUyVkdHaIJ7wp9S08uB8nhLcyeJszyU84EHZ2HRbiyubItk8Wnj1S83WZPNDIz1Jw47uU9iwzmjRyNWQ3+IsXvDv8P221Gj7zK+dK/oIkD4qmfoC3ZeWlNQEJLnAswwm3US0iTtMbKcG+AYVD8IEEDpE8BCK3PvtIdf1mQZX/BDy4zPYW6nP8y0IK2sNwuuOlc8rVr9LZz2wcvy0JUMmOdJgFAi0kz7n+UsXhe2dizkXIwzcO6+J2zJeZTdj0g5olcXMwFsrJV7lRAK2OpEgmoIAneZNnNWIhT5RYlz0bbOtO9iHzcTOiVryT8I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

In order to permit the module loader to allocate MOD_TEXT and
MOD_INIT_TEXT from the same chunk of memory, add an API function to
execmem that splits an existing execmem cache allocation in two.

This will be used on arm64 to avoid .text and .init.text being placed
far away from each other.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/execmem.h |  9 ++++
 mm/execmem.c            | 44 ++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/execmem.h b/include/linux/execmem.h
index 7de229134e30..59bd862cb061 100644
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -178,6 +178,15 @@ void execmem_free(void *ptr);
 
 DEFINE_FREE(execmem, void *, if (_T) execmem_free(_T));
 
+/**
+ * execmem_split - allocate space from an existing execmem cache allocation
+ * @ptr  - the existing execmem cache allocation
+ * @size - the size to carve out from the existing allocation
+ *
+ * Return: the address of the carved out allocation, or %NULL on failure.
+ */
+void *execmem_split(void *ptr, size_t size);
+
 #ifdef CONFIG_MMU
 /**
  * execmem_vmap - create virtual mapping for EXECMEM_MODULE_DATA memory
diff --git a/mm/execmem.c b/mm/execmem.c
index 084a207e4278..6db0c1d82a9d 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -439,6 +439,33 @@ static bool execmem_cache_free(void *ptr)
 	return true;
 }
 
+static void *execmem_cache_split(void *ptr, size_t size)
+{
+	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
+	unsigned long addr = (unsigned long)ptr;
+	MA_STATE(mas, busy_areas, addr, addr);
+	void *area;
+	int err;
+
+	guard(mutex)(&execmem_cache.mutex);
+
+	area = mas_walk(&mas);
+	if (!area)
+		return ERR_PTR(-ENOENT);
+
+	if (size >= mas_range_len(&mas))
+		return ERR_PTR(-EINVAL);
+
+	addr += mas_range_len(&mas) - size;
+	mas_set_range(&mas, addr, mas.last);
+
+	err = mas_store_gfp(&mas, (void *)addr, GFP_KERNEL);
+	if (err)
+		return ERR_PTR(err);
+
+	return (void *)addr;
+}
+
 #else /* CONFIG_ARCH_HAS_EXECMEM_ROX */
 /*
  * when ROX cache is not used the permissions defined by architectures for
@@ -459,6 +486,11 @@ static bool execmem_cache_free(void *ptr)
 {
 	return false;
 }
+
+static void *execmem_cache_split(void *ptr, size_t size)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif /* CONFIG_ARCH_HAS_EXECMEM_ROX */
 
 void *execmem_alloc(enum execmem_type type, size_t size)
@@ -511,6 +543,18 @@ bool execmem_is_rox(enum execmem_type type)
 	return !!(execmem_info->ranges[type].flags & EXECMEM_ROX_CACHE);
 }
 
+void *execmem_split(void *ptr, size_t size)
+{
+	if (!ptr || !size)
+		return NULL;
+
+	ptr = execmem_cache_split(ptr, size);
+	if (!IS_ERR(ptr))
+		return ptr;
+	VM_WARN_ON(ptr != ERR_PTR(-ENOMEM));
+	return NULL;
+}
+
 static bool execmem_validate(struct execmem_info *info)
 {
 	struct execmem_range *r = &info->ranges[EXECMEM_DEFAULT];
-- 
2.55.0.860.g4b6b3295ed-goog


