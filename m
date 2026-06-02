Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B18DCCD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8E26B00B1; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BF66B00AF; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB3A6B00AE; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6872E6B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38F81162AFE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:34 +0000 (UTC)
X-FDA: 84834107148.03.3D747CD
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 97AC140006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=T7xBVUUF;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDIPRhu4eC69IHX//CJMd4ihavt8RgvIqQIf1iXGap8=;
	b=fcKPwkKgc/FRGqaOeZNL6CqQ2u104BhtXhFKNF+ebSM4nH83Z/0O7WcidDayt+Fw9vjZ5Q
	XXHaFd2HiDoUBmsOYmZ8dp5BEblvwkkwKDA7+lOM9v/+QRex4LH7HNetvfduC73AGQWeeU
	DWWK92UaEzl3Aafqvd5q0djnZcOF/jI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=T7xBVUUF;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384412;
	b=tOFttOiGDN5LitoDjlxauY52vsl5XrVq5RVuKRzjZh8vh0ZwRYUxkkvpfR3/z8P4HDudhV
	tvD9uzNyvSqKYUH9HVIw8AZZVxXae3VwrQtkSGJd82tCEQqSl/htrY9Y1RzXPCG5rVDc4g
	bRAjjsmqg3iJ/snJgm2VrZwvJX2pdCg=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 885BBD0F64;
	Tue, 02 Jun 2026 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384410;
	bh=lDIPRhu4eC69IHX//CJMd4ihavt8RgvIqQIf1iXGap8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7xBVUUFAUZ1XGP2Kw6qlEA5/9HEkKGDkpi3ueWDkrUHbugbWP+f5+jASUCpDetB3
	 4VhZqrAwpI1CpEaFkNI6YNWgQbT3VEsrLpJWa6QTYtlfzm0R7SkfeEpjPD4kl/4SeI
	 4lhx15kW9dsRc2+66dNtTMKze+UJipjJ5sF4pcLs=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v5 2/4] genirq: Move NULL check into irqdesc_lock guard unlock expression
Date: Tue,  2 Jun 2026 07:12:51 +0000
Message-ID: <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 97AC140006
X-Stat-Signature: zxfb4two7piutyyqmofwwspepswjmt5o
X-Rspam-User: 
X-HE-Tag: 1780384412-103865
X-HE-Meta: U2FsdGVkX1+cgtfWmuRpedqVuGsWXPpDh+fKWqdq4hDNYNK0jruxivFRyIoYIeybra/e/bsUXi47lBubJtCO2371NZlwaFJ/23ZjAipsiD9PARhivVxu+CLaIaEFJ7g7fVfQLqZnXxU3G5pzJ3TGKKTDa6sGlW65Tj4Oks1gdpDb7Qu9gkf5Xx9XAprJAMqib8Re4hJDGGSlLw1oMDBBnXGomlKn+NDmJI1kqW2wXF5VP/1eWGCfnlK1d9u4MwX8tT4FiT79YibrwPgu5ZvXfCs8NCUKoZIAW/ZiakmsgVMcFbPPAobeJejq9+QgaK91BmLRqvHDAxcer1Flqsz2x+UB//EqypozPiWG5ODj+pxROX5IjhibUUZicg9aEz0OGPImFpoDzjS20qZ9un3xDWr+IGEmB/Q46S7agTRJmep1LWtAUPpj/RyV6Z69+6Seq18uGI7UYViFBUFQoeFRz359LTzxuiRI4ltEcXpKHWsjo4MvEBMHY46kk1TPtepgwaNa4dPtEH1gi1vOHf8s1FZUEyu35y23jvEet71iy9lk+2TCOEOJb+43+6DLk+mDRHq93LQDtwXtCdnKzEK31v5H6zEAp/TfSmRJHXfGny84BBq0gYLC7yN5ogfvhO4WHECArG3UXUdXog/RwEe0vzjS/pZPy2BwKdaJ3qM2DozaKU9bn+AUbz/yBIz5ys79ohxgLC1wS1KqESQSwky/tumkPR4PSwnaKLRkI0kW4j7uKdqS++LGPWPMGYIZhCmE0CDqYS6gjkZ4JX1CfW9JeTHvHnN3YSBBQzFvCnMgvjKjwX05Tbo7fVK1x4k4abkrE8YrNlyimbbEtaUeMd+zlF8x2bQKMJrSYN4ISfkv0/pYcRbll4zUGXDxKR8PCaudvq/e1eCRCup5XzYF7N9dW1t4nXL+AodqQYe9IyDANnXJsB0Ospq738EyUvrKXzFxj3qNuexwhqrn+Kc7w4I
 VtuefUN4
 HXqDrqswtbrAyHwcBjM2c1mKjq/lDiXnXEZKTsvwQ+QoD9OJ7a4FQCXGeH/2yWw3pmjC8eZFZ6WMrgqGA6D74+6h+dDvRs9K3xBS0NvVUlN+Fil1rq6TMV2KzKhEUVqBXeOy0VZe50dNGh3dF2sj7bHY3+jc94k+y1wPNnoBq6QpU1gg/4FoSApajPTSMZpzFpCiOs8skoYz7ZbtOqRbCKP8H+zKkHNeANmVUPokQtuwhVk9VMPNIssiQzl1UHeWPZ/uIKSWjvCPuikKWkpXu/nRON3Um4qUxX4JMzGSGbuyZFCOy3RzlXrzJ8LLBDdhq71TZ94JbWVvCQkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

irqdesc_lock uses __DEFINE_UNLOCK_GUARD() directly with a custom
constructor that can set .lock to NULL.

In preparation for removing the NULL check from __DEFINE_UNLOCK_GUARD(),
move the NULL check into the irqdesc_lock unlock expression, making the
NULL handling explicit at the call site.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 kernel/irq/internals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 9412e57056f5..347cb333b9fe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -171,7 +171,7 @@ void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
 
 __DEFINE_CLASS_IS_CONDITIONAL(irqdesc_lock, true);
 __DEFINE_UNLOCK_GUARD(irqdesc_lock, struct irq_desc,
-		      __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
+		      if (_T->lock) __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
 		      unsigned long flags; bool bus);
 
 static inline class_irqdesc_lock_t class_irqdesc_lock_constructor(unsigned int irq, bool bus,
-- 
2.53.0-Meta


