Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0532AEE6B7F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043276B0092; Sat,  7 Feb 2026 03:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30116B0093; Sat,  7 Feb 2026 03:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CA66B0096; Sat,  7 Feb 2026 03:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D56E76B0092
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:12:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60D2A160403
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:31 +0000 (UTC)
X-FDA: 84416943702.26.2272F81
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id B621C1C0003
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gli3ttMq;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770451949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfAfOKttZZZtCqQp8K1Dj0tvri2/xt7pdNxOOLU+9Pg=;
	b=qRzKkqO56luggUoCNr1viNmJtWAVoWB9u81GwJ90rg0gv0vXm78J6kz5dfEEUBGQYGtA9C
	4V8ae37Lyu7EDjVB1YxLJ9XDAm/kwX4zCJQbsLPF09KIaNQlE0MaY7jdENWYHc0oG47n94
	gckqx+F6Ji7qnq8i8otR0WUUdLkdbKQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gli3ttMq;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770451949; a=rsa-sha256;
	cv=none;
	b=1Aqu/Y8Ur9OE5CW0KW9CKpjDztHO16yIIs7zf5IrzvYMAE3vVlUxJMLAN62Wt8F6sVegSa
	fvtfhiCJLz9257F9j9vDSMi3NMEqIaShEbQ7EDT96CxmRpYfuUbPmJ0yxZ0nrMCuHhPZSo
	ot3guqJY2GPX9kX9wHlH9DDzp1wuMX8=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-824484dba4dso1201524b3a.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770451949; x=1771056749; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfAfOKttZZZtCqQp8K1Dj0tvri2/xt7pdNxOOLU+9Pg=;
        b=Gli3ttMq1gd18Hh3HJcir4R1dqRgjmwZsN7H9/ZDnBEmLgP2qeG1y87q6xQu2smNuD
         4x5R+N9Bgxju5moZzVfY0WutUfwikNKChegWUaqZRxCo+KIqu5OC5fozMy7Ve+iQHgFe
         S6VUrV0e5WZSOO16V/cDZE+uMNOoJZVLH9BlMQIuoWms3esN1Mhqrz+lopAxvksqTC0D
         WJ71yJ1LnoZpMDeerBflIRSNo4YRT/7joZadh3u1zX5y7rFeysAN/a6WNcZrCZPEEqji
         T4nj29/lYpPPG5JW4tsC4TXEYfb2kTlGTSbru/vmuIQAoL3vqS3+HgwFNDQXOyEX29Y7
         wv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770451949; x=1771056749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vfAfOKttZZZtCqQp8K1Dj0tvri2/xt7pdNxOOLU+9Pg=;
        b=RnFmKuq95LRuHECRLPsrGY7Q4dTe54AWNMyQ6cTJHK41f+r0ODYNBGe1jXmC3OeEYp
         7JuFWOiZoh+sP3yxOe3XQzqIwCBGXki46muhH2D9CRoOXSwU2q/dJAs1TrNHp9LjX9Lu
         XWAbD8YQ3NNpxisokQz+qZ3x+xNJmE9XvNjer7bB8XUzsbqGry1GZE2T+GIClgf89r9u
         hUMCcunCJcAUXjFKNHoG+mp2pXdRlWbR9ye59vR3+xR8gKaXqttgCUMPiG1OlOee1sUV
         i77bdX+a3a9SgtJBZEpr0eKOcAQKfLRC6NsvveVOx7k6SBk3HJ2O+Rj73N1RzRebKTp1
         Bj5A==
X-Forwarded-Encrypted: i=1; AJvYcCWlWY+OKX6P+Z3O9lrZoXM93WE2UEKC+JBvolT4KNdldGpwMlHT7fc7bfFEo9eoNNuQIwDMVUdcMQ==@kvack.org
X-Gm-Message-State: AOJu0YxVeToaxnEUx3XH3Up9qPBvHUoF74aLzKo++NDAxprBfdAe54iZ
	ScUlE8M+X5Rrtm2mlBm6bKyk95yONZ96CukmO6O4Hho7T3KsDcOXWXZV
X-Gm-Gg: AZuq6aLWExsNuI+DxT7n46LuA99GqAcbImiv7ZkbfjbbQdpZH4Pp2RqyOZnwtDNCeiU
	9dAPlaibcqXEGLNle+zhT6OMxF1WalCYheIn5aXcDFLNc/MDDeYC0ihBVYGNWnmrIv86v8q+Z8T
	g9DLoak7ReA/Com84ON9jpdT2wRYrSPW8xM2/+J7WMwhFa+qlC0mP8+n5rTy/WzJKH8gvTV9JBr
	Ds8ZnfcVelKdfmKhkKHLu5F0rMVzPy+ckVmKnwZTIuiencNMQphg+dLrZTVLkfjfCUm/6batY8c
	iYzfaYfZzVDfjmZzf+y6afsyJLWgdZnmKBepafZHTrxowL+zP6NDyTMvNNRUmfUtCj6a87EpcAi
	JphuJq4nFGRNYuW1VSB6GSHlhgNSSXjdQ38Ay6RfzNinYGufsKZo5wImuXN1XMhK79yaflhyJ74
	8yCtJSqteZQTbwbR/v2XwwzlE=
X-Received: by 2002:a05:6a00:ad86:b0:81f:5f49:6913 with SMTP id d2e1a72fcca58-8244166b425mr4943161b3a.30.1770451948660;
        Sat, 07 Feb 2026 00:12:28 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824490442cfsm3951466b3a.16.2026.02.07.00.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:12:28 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v7 1/5] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Sat,  7 Feb 2026 16:11:40 +0800
Message-ID: <20260207081144.588545-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081144.588545-1-vernon2gm@gmail.com>
References: <20260207081144.588545-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: brtk3w7on14etdxdpnxfnkiha4dzit8k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B621C1C0003
X-HE-Tag: 1770451949-484762
X-HE-Meta: U2FsdGVkX18kMYlLogO4TpVrKCllPNz2/4Jf4EoKe2CUioP6CPYckivBdLVO1055CCkQ2PE+iy5pVafWEyHtXKVZUI8oJcIzjLEwyCbhym2jIyqIychE1hGhWu5L5nvXqr5KnkvNEYxtSLtsw8yjxD19Y3knx2E+xgy6CQt6o62GHe5NZ6u13+UZw6HpvLA5NHcv8mIe5kjFPuWES/n5NjyBr0zw0kyFlAs23yLZ8cFNG/+vnJhrIYFEqgO2W513+x/ODNh8WArFBMdHsc7eO62KzVddQtAXYqbUsKw0BMHs/t3FQVnggFxkIhFuyWf0bvESibWP0nQ8VGm5Iwekf1P9VItpesbivN/1DvutPBDKPufAdlIe9OPeqhgGci62jYHJbKAek6EMIyoYrUpDcuNb+zaOdjFXoo9+KzcL5Rhc/yNduMDvbpq90gpO6urhf0MWl7yYeT4S6E/0ectnWk5ns5bAj3BxbAxZyL6tf8tZL31FUOM48p6mrUXoeHHDLpIHZQy2caxeLDPEJypIpBIPge8omeMVOPByBjqx5rQ6Qjo4RvBtjBd0A0q6GeH26IXp2tIyUpv18R4/tJtKYq13Ppk/TlthkF/tw8cbUgZMgpchw/X5T+YWecANUa6rbzrsPgJZv9eT9kY0UdlT0nrSxvWVfcL/Mf99k2MxJcVI3xGgwufDXrM9sON8eFCsE0XRiBGG6DskGDHKjz/nybE7p4kHGbU4uMR5tZnRB+UliWD7X1FFJ0Wn6nXlzzBwY1lRknkQEd4Pc1Xt2xAHroZVC9kKycodoctqn6IwGmXtfb18M9LCOZwpVacnVqeTNPjIEdULBM40w543663Ge60ZwK5ZH0DVwkwsAOdrUaKgroTDqn/ihrQGbVrX75tsPgmpOL94EhP47fnlbWcO1vHqk1x91wyd6XH/dbzx9eSRpG5q//+sSS365aTm0KBKoq/BmO0dzAosFHRkDxy
 LQkE5eg/
 X8aHXmMeVLBJoWap0Ufb43/0jySQfcTWQEQT21TFK8rr1L5gFiUpd3PYYzGJzZI4zSqdeO0ViSyBNTo27H/a6VXf+MoMsgcjc/NtwU1S1fgABpUf1OWfFdJWu1iuBhR8RgaKlOCrwmMWZawNcKqG/F+//alp7eh9C6AekXM0GxoGig0rJRXJUOkRJxVstb6TOkuDULnbiECNeMiE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add mm_khugepaged_scan event to track the total time for full scan
and the total number of pages scanned of khugepaged.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 include/trace/events/huge_memory.h | 25 +++++++++++++++++++++++++
 mm/khugepaged.c                    |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4e41bff31888..384e29f6bef0 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -237,5 +237,30 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_scan,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int progress,
+		 bool full_scan_finished),
+
+	TP_ARGS(mm, progress, full_scan_finished),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned int, progress)
+		__field(bool, full_scan_finished)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->progress = progress;
+		__entry->full_scan_finished = full_scan_finished;
+	),
+
+	TP_printk("mm=%p, progress=%u, full_scan_finished=%d",
+		__entry->mm,
+		__entry->progress,
+		__entry->full_scan_finished)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c46..4049234e1c8b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2536,6 +2536,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


