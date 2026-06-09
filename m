Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFF2CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78F76B009E; Tue,  9 Jun 2026 10:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50EE6B00A0; Tue,  9 Jun 2026 10:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66B76B00A3; Tue,  9 Jun 2026 10:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A933F6B009E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:39:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7037A1C2D8D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:39:03 +0000 (UTC)
X-FDA: 84860631366.18.0E3B1B5
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82644180002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:39:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7fPXFa1;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015941;
	b=2N8U/tVFchG9SHAdzmLEif09AtVtjDR7kIGk+N21NQLxb15HGad2130O4V54xBhbzQnbWt
	p1LBU4drEh2x9fF1U0S+jBhXywdXlS/ecaowiw9TtAkahY3iRIoK+h1Jxp0lMSkMpikL9P
	41n4nUIt9CfbWlpvsk6tDJT/PbdaTfM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7fPXFa1;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyS7mKR1Pj5rWSjXZPjC1j5mlisxE9H8ozK2CuoOEmk=;
	b=xCWVqeZl0Ji8ONDmuCUM063nt0Hz4fGXTCVXgWuLxJH7f7lQB9vIbcB1TkhQclAjjOWT7e
	MNlqiqVd4I1LenjtKTWVNeBJlBzDhjKtIN6QhiFknKYJokwcM6+O0gP/GKPvM09aNtQhDw
	rxbN19CHtyt2V6pXx8vvv/B5V3QC/GE=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c85a2b8c95cso180901a12.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 07:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781015940; x=1781620740; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyS7mKR1Pj5rWSjXZPjC1j5mlisxE9H8ozK2CuoOEmk=;
        b=h7fPXFa1YvrPyivLcyYrOUgV1Wp25tuPtkVmlLbCdoeULm5N5m65rr5QvPF6+Zf7/n
         214lxehaK7U3QC99iMoD7vrFon9uVYj5NN/wzt8yHrrvTETKiRnf7KJQObA0zd7a/ASU
         TjBtbfVNrUBEjyf4OYuBq9cNyegC3OygNJmheLSVv8Bm03/1Yeu6LZn0RjFyCcIQZrRE
         q/97iZIFC6HttAlz/9kjU92CIh9xFb4AkqLk8uOzpS9MP7lOtNKiBpnCDCzy+YmC1cLb
         8c0QKF0De8lZXLB/ABkkzz7orS5lQ+0xF/+T6KLIZMSTCjaHOs4RImcb4Ai+QmZ4+bmT
         s/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781015940; x=1781620740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MyS7mKR1Pj5rWSjXZPjC1j5mlisxE9H8ozK2CuoOEmk=;
        b=c/FDcUIwcyZwqt3VGmX4P46jssbFNIVGn0B7d2KqQlvtOrdJAO4dJQY/UgHtWhdemk
         3s05tVURwgBs9Hgdc0Cs2TeDLUdoYFikUcP2liHlTT5yj68fyLC/wI7lkT0F65d3QpZQ
         KMm6AQzgk4JvbZgQMRU5Lzea9jiim7WvRwV6NilMX0WUKiojBlcKVEiHFwEBkqTOFbl3
         bsu1dFLU1FfUCm+p9oqIAbFiDXFJYdSKvdcoEO4cj0/CjbQ0fwAXCo2opNhdrsIzaILV
         vmeULMpIlNx4c5V5k2vDMwfNvIBq+ykCuCB8CJoGsm0ceLbB2tA0dT++hJhwhkRLWuSW
         iNdQ==
X-Forwarded-Encrypted: i=1; AFNElJ+IalBa2KvEeXgZyRMmoZm42keW7nB0YkdpIVrEz7TApVym69tvkvoxN9Uakklz5rngENattBlwLw==@kvack.org
X-Gm-Message-State: AOJu0YwMDpUJ7VsnMQ+7D89Y7DjkDF4F5UJScoHpzNaEbfwnJCZn5d5Q
	TWGoGqCl+D71l2cGiJIe4WcoQnjLrDnn1qqA9YfHJiFqVE6dn6VLNPXh
X-Gm-Gg: Acq92OFVMopNyp0EnDp4JMHlwJDMF/qz4rWusmBP5jbmubSjCGtiIEBQ4vkGygq5ns9
	BrQqIsq2KnYgL4VyH4wLiagjgz1GikaJVHuZrqD1xF/THNZSC3cp7LVZEaeFGgGwkXTXFsIW75M
	kzH3gvhuKOeZwTrVJmT1wH05uVG32dUQdHcYJFKxhBtlY80bweqtJMpyIoE+9puQ7jvJSxwaVhp
	QGCpJpT+MSKx/EBorl0+24F7zorY/BTFEe5wuYSAE0M+Fl6PlQqk43CAd/sg6J8aLandZq229uf
	7VJqkaUulHAktoJy+k5JAjBiigPPdCDGGjCrdt+FQ08BjVxX2rz/QP33mXQUJd7+IG8VQ1JJ9Im
	ATgnk20fGcR5SyNiX0DiuEqqurl78IkzPsqBYndK3zymAAx5GbhbHU0BPJf/b1CDBn//1dTWPzE
	TkzmZlHKrKZTmWTOSEkqzIuMeH1nk5QbikcPyuW/VufQzYMQLz82WRT9zYDAzyfZPmlOUFvfhUd
	zs1ZW+Kw0oNvW35ABBoay/l
X-Received: by 2002:a05:6a21:4784:b0:398:6e38:95e8 with SMTP id adf61e73a8af0-3b53b6e9085mr2088352637.2.1781015939654;
        Tue, 09 Jun 2026 07:38:59 -0700 (PDT)
Received: from o6.lan ([188.253.112.242])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0b315esm17939677a12.26.2026.06.09.07.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 07:38:59 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Tue,  9 Jun 2026 22:37:59 +0800
Message-ID: <20260609143801.7917-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
References: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82644180002
X-Rspam-User: 
X-Stat-Signature: 3ffbe7crjhkcnrt5xfnsqeh4byhr3q9x
X-HE-Tag: 1781015941-337884
X-HE-Meta: U2FsdGVkX1+dLkDwJ9pEQIOBDmiNZVCQJZ2D0z+3+qX9EJSgf36yDNMX+aI1lHsKmuroG0wiqBvndzmQWXahD+cu8PNB95u2hy6BEgJXKDFIIUcfw3dlga+rB/8nrmw9NplPfyYai+UuO/KGQusIY5OiLex9fWvhismQHad6kuiDLq5Hpiay/xtBXEaWpwjSwbhKWNfgN3s5s8WgtxkNP6lu49lFffgBCS1jpAo5U2RK/gMLveCQFIkwXCgTJzjjEilpaTypyorXY1xLiJtDZSGCPhbe9BK2W4M6xeN6WtXLY0yJ9rUY9DeEtsrywN/r2+S6Z6k6mc0QtSNeAVtssN+LGO5DraqQXFUU9AxsvtYef7dUqLdy4HkAWfqupiQGLm9koNRT2k/esxKMkx20gfWC8/gayWIiZ5pHjPFj1bqTYyyXip0Gw8HxcRlWp2GFUaBwYZ45hcFzFThEKdkgINtIIFhZeo95Y3yZWgDbUw21TL2bp7IBOrqfedpzCAVfp0rFBKoSrxg5CKNlzuwEq6BTu93m+Z6lFt1VlCmSNKxg4HP+9bCWRdOhwCIWTZ9iUC5f80tIxlynxzPOLEZ+r8+A7BH6W0NrBh0u0c6/1WjpG5ebw1sEaur7WwAflCFxjhw5Dio8fYWW9+U1kg8YmDaB5xgftnbMMJQWwxtfp4AQ9TWTh10U6iLsEy39B0wUkAoZ/BBEzuZU8papHygAuXUrXrVTXywGTe7pqc14tUUOahtgcxMLrTrlrM33EVVy5JPK5OqoVxTfhvqkK4AS9nbqtZN3W1zXrzOJajkfe0ViIq3ua87oNCKZuunvlrOWxKbDw8n9KPRVqfv8WPsI1PTeLCP0HqqyE6LvtOjweJ1bq0AIsXm8Aitej/1WFfbz1HpIzMkt3iOWjxdRXPfCThnolemMITLOmTNza/vT3W8p6/qsUcFKPpnIUhPnWbC296RyZ9ZbW9+xTw6lSqn
 ZNpV7biU
 iVRRfngWrLNokXthOk9RvQXh/tGwsdGaofJOLeKf4o9/lvq13S0MvMtwZocg3+WjVi3crrFyE5P/WhlOK5daoBHx4DYgNReE8peFc7KDdlg9phXTT0o1Y3PWV8uTqVXUBTVW8123ukrKovWuxzGtkuWAXmiXSD1GfIEEqA5xFca9OH61TyrcRnwNThl9mFRUubcmIS+ts5URl5o+osbtJgHvvtNzj6JBcihiK0Q1vbNasw4/mVoCtJT+l/+1+1mZF95YSkN99tMiY7yxkvLO+clhgE8eSAD+04Y8AuNGTs6WlPAO34v+CeHLqSz5P2SK22htUZVjw1N9Ap8MCiRLMdiTkWsLVwHrtwCTxk/9TRGEhkKqZfq8Cx8b+Q68hYndQQDL9G/3Y1FDLBp5BLAPLQhlnO34+lJmFO6Ee7nmp41P7EyEmzPuNy1MaJopqcNcAyAhIDvXpUHyPgiLIpBjw2VUI+Y9Xyj1Qv6Uh+WQGGQHRhPU5ZazAOAgoz9VNF8Ine4aMq5mwpCSxv/FNM2baqq/7ZMF9NZrKZsWj9+kv7LwnnYL7ZCs3izNNJ1G1uO37SmRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The huge zero folio is shared globally, and its contents should never
change after initialization. As Jann Horn pointed out[1], the kernel has
had bugs, including security bugs, where read-only pages were later written
to. If the persistent huge zero folio is read-only in the direct map, such
writes fault instead of silently corrupting the shared zero contents.

Add arch_make_pages_readonly() so mm code can request read-only direct-map
protection for a page range. Direct-map protection is
architecture-specific, so the generic weak implementation does nothing.

This was inspired by Jann Horn's read-only zero page work[1] and follow-up
discussion[2] with Yang Shi.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/mm.h |  2 ++
 mm/huge_memory.c   | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0f2612a70fb1..02d33cf45b01 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2936,6 +2936,8 @@ static inline int arch_make_folio_accessible(struct folio *folio)
 }
 #endif
 
+bool arch_make_pages_readonly(struct page *page, int nr_pages);
+
 /*
  * Some inline functions in vmstat.h depend on page_zone()
  */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b81d1ecb434b..2e9d01dc1197 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -308,6 +308,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 	return 0;
 }
 
+bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
+{
+	return false;
+}
+
 static struct shrinker *huge_zero_folio_shrinker;
 
 #ifdef CONFIG_SYSFS
@@ -982,8 +987,14 @@ static int __init thp_shrinker_init(void)
 		 * that get_huge_zero_folio() will most likely not fail as
 		 * thp_shrinker_init() is invoked early on during boot.
 		 */
-		if (!get_huge_zero_folio())
+		if (!get_huge_zero_folio()) {
 			pr_warn("Allocating persistent huge zero folio failed\n");
+			return 0;
+		}
+
+		arch_make_pages_readonly(folio_page(huge_zero_folio, 0),
+					HPAGE_PMD_NR);
+
 		return 0;
 	}
 
-- 
2.47.3


