Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236EBCA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 16:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E227D6B0095; Sat, 10 Oct 2026 12:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA2B6B0096; Sat, 10 Oct 2026 12:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10CA6B0098; Sat, 10 Oct 2026 12:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFD296B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 12:21:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34754A8264
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:36 +0000 (UTC)
X-FDA: 85307232192.21.3FAEF50
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6DB1D40002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JoZ/sgjG";
	spf=pass (imf12.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791649294;
	b=h5oiodIaJWfPv8eCK3HgfghJOtHHAM9CK3LW12DtKDoMpEHhl7A7gfx/C5QucBFu+x0Kp9
	VnxY4NJ3PKN1Qt4kvjfPAkbmyWryApiGUvIlqgGGVOAt0jDIq12ymYhY9d0D6z740qEBAG
	A7xA9Hm8/eNTSmAzVKixqjk6GwfNxfI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JoZ/sgjG";
	spf=pass (imf12.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791649294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOFRoJt6U85Tsj+Ev9WdukczofMEitvTriF7KGly0Fw=;
	b=BbscrY//cMo7Jexq/Attg95Fitmy1sx5MrxXqQ2hNzMoOLKqwp0Cr853RDURX9f/maIK/J
	J/2271hNdU0p6tF0au25hZQw00GTmyQ9EjGR3MHpuFEMNDACg42y12qMXVAhWyX2cV+pdR
	i/HGjkTHLm7P5rSuPL/muWQBWLg6Moo=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3515f9a5d25so1801478eec.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791649293; x=1792254093; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EOFRoJt6U85Tsj+Ev9WdukczofMEitvTriF7KGly0Fw=;
        b=JoZ/sgjGjmx0bA9nsUVMOjNf4qzVSm48OtjbzpHg/KG734sGA5wUV5yw6uEy5WbCvJ
         WlRdigHimO5vvKLqv4F4Qm/RRl826qRUkPqoRnKqIBmskyYCHic2ac+h4KIZMgM0l009
         y+XN6n8r9jcMfzxJyoIl15dubdbPH8oN79Nmf3jCDwmAm5EdWISgA4XaYPkWZHkOFzTu
         3vGVKegG51+Rat7Y5vPw+VOxg5MlzwqOcJt0pv9mf7ExYYOXBbkdR1d6FEMIf9BWzTMk
         yaaQV1A8pW1CvCdk4limufSN2cyvgrowVAAbZJ68RqTBJjAiwNCJg65CEP5N4Gff6+S+
         vDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791649293; x=1792254093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EOFRoJt6U85Tsj+Ev9WdukczofMEitvTriF7KGly0Fw=;
        b=nXc8IHXlB1LdYt0niquD6UmwYy9DsbfaiX3LemXPX19qctZPGSTzoezoD44wlPVTpP
         bG737BYGjgSn2VaTGgoH8/biIdieNo2Antvpxhp1uE04IgE2IG/3CEZYrj6xsH/MxhyY
         ZNy+a8M7iCD9QZVkB5+RQn9fdbmkTvb5bH2CpprtDZsE4qtc9wwb3Z2BJJxKSwhWx/5Q
         YHLRkY0pnORg1HGLnIpAXcGHncTmsbDyw6EQzLe6JsxfkhPyOtrXy9CrxqB8U0kazNQH
         55VVh/3Yk7XKxOVWvetMkxL2p1YHxNE/J6B3HY2F+4Us6i6ndsVUYfuGymGPtXHaXjbF
         q+2g==
X-Forwarded-Encrypted: i=1; AKwUvByopxBE2FFM56I8TwgLXdwSqW9Wl6FjzYzsKxhOG5UfFB9Dtt19gcCRW1/CN0CUMC1TqFGZfidHLg==@kvack.org
X-Gm-Message-State: AFq9FYKWK9X7H21Iik0RwR2tr7Jp69LrT0ySNHnTbWdWmrzQTt5DXseF
	1EFwVDV7o8oHwdrZDnKCnIi6rCOpplS1QikVxQgo3ZCF1I0TmmIV/FQY
X-Gm-Gg: AYBFou1M0bSe9zuA0fTgq8mRWyV7CipfYBOoaYr88tnH5w3LtXoOW5aeGTkTNNIm4FD
	Ja5i7qaLfty3TIAaR4mS8/HhkDXNZzWS5v6dYwqxNGmIWe2+Ic1Y/q2P8aeRC4flTzdgQmDikGX
	tBk0gtZXxZK3c5mXo0T0+zDrfRtsrvC9y7Jo2pAGRuRfdGQTvWKK8X6J9TlbqueBH1NFmhoFgY/
	fUMpJzMRKEQClR+VUPVABcPg4T8ufBfK39ZRyhtMD57Ap797nN5/u8hdJQOJwlOORFjuhyaHLTR
	QBalgOdkHEePQr8A24aIxh2goXknOagdJDPuTVcJ3UJCRjvsBsOt2e1z5Pn/57gxg5MEO9H4T8k
	5UHy8q3JL9xs2nsnjCTIccZt2RZDQnoO9xS/GH3JbDS6g6wvY/vfmMkGF1CqVgtLDFVP120IIB2
	VwMTXgiJ7qDQE0nVrsfX5z9hVsfAZZKkss05Q0V2Mf372MaPxyKsbcDwlL+AxOzsV0sjZ7Os2GF
	e817eYaoleK/kzefw==
X-Received: by 2002:a05:701b:2212:b0:144:c124:279 with SMTP id a92af1059eb24-16a5f7c79c8mr7463252c88.35.1791649292992;
        Sat, 10 Oct 2026 09:21:32 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([115.96.176.39])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a3f6186fsm15778622c88.14.2026.10.10.09.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:21:32 -0700 (PDT)
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>
Cc: Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Subject: [RFC PATCH 3/5] mm/memory-failure: Add a pre-online poison registry
Date: Sat, 10 Oct 2026 21:50:11 +0530
Message-ID: <20261010162017.62506-4-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DB1D40002
X-Rspam-User: 
X-Stat-Signature: 6ni36tqwtf47zsf1gyehehchjm3d8ry8
X-HE-Tag: 1791649294-366160
X-HE-Meta: U2FsdGVkX1/9wqUKPIgiFzdfI8HZoYixBDmVIOhpnwCwlKtXNy/uXJkd9AB3xKI2Ej5JGwV2AvOA3N+gJs5KSBspStHaVJCsE3lvNuay/VYsA8pMTSM0z8oftEyR0FzwmT96JoSdbgn028Bg6k90FsQfRQ5GpiTXedMzjNVU7s+QtQwIAd5n0TK01hHbjiE6GfDH5hq2w4qcd5llC4j5q3vbCwqcfX2WrPG0OSZtHeY/QgXyeT00OKL9ojBDbwmnOFhV80xTF1gcXOnf42U/eV7wRUAxiOdkaoarCTfLFv7CKWoZ7IjoyCZSSYDfcXyzY6b8bNf3rgMzuSZZ/kfoWp9vGobSN0jNmz18XNzaWDp1Ra2ivpP/fyFV0s3qSwM9KRpSkzt9XrJLZ3VplUSJZ8BlGFfX0WwDYhS1ZQf1xTefWydgmFRhzr+3x9cV2v8PiFL0QTIJuFzKWnIGqrh0c/ck1QADTlbBjvQdOY2IWVwoaqHhBNRl0W0KFN8aWT426hTSoLy52bfDwWL4IMongzIWFiytIg9T0wsAp6nlLDEfcY+0blz7Y9BdL5I/ZllzlVll+Lz5ETy3FI6t+qFB0J7Ik31ATYvkEu898ZA+HvlGlAitK9r+ivDcC0DJvuauimPKLryEFEPh3MvSoqVZluhcsCY0cesTtfeL4ZNG27hYdmsQo0hD/pp6kA0Hobh9ABWhHblUh8svePyv5By05zxfeOeQ1WZALiZjxzhXdA+sULxaWVU0+wj/3W4bsgj5ZLSzAcXbYgkBYjUBszhjnvCs+4zMfp1/OOj1HMcX9sVnEICuXYZkD2O09sQNRPpwmz3SJxNiIMg5HCvGEDFKIjtUSYEoklKoLYBe8CCxbasLtOUgwl1vXaPct/nAHQYojySMdHwBk8Q7VKYEjXNePvxyRfTBINwqDx720lH8WKTNTEwsjRe1tZb6tmRF2Lks1eKbY1u3VB2GGNlQBi0
 XZYN3YJs
 W21o0E7rz2aE5bdt6iy4s1KJfFuiXIWLO1aw08m+VrEoQKAY/I3PSnc9R5g+z96++JANsQtYKOMO1mxE1hQ9GNCEaxWwCbWEXLeOIq+CH7gPhOjLLBNsUbGFrwJSKHFe+7tlv0mcxnL97Uoy42tUQAMRXtrlYO0m9ZI/yIN5kH0rH6wP/o3vwE0xPk/HcuqNjiu+CMlblANG8THW9nEHhcwJMFPzomMSjsxJd61yJaqrqaXiSdm57O7E6aHDzloFX8yoDsGwyiXSNcmWwVyJVp7m/qGGhhQ6GLbx0Ks1hBglPGCuYILGuBeTyl/g7eC1csZNjcOl71c4hgCxmfnvm/4ZducGKDejMfvuQ2062t/9VtJ9DbX7t4V4/BQpxM0uJ0WSa3s85ZILBJTHXRy8xg/X8u2/Uv7KuHbNZPY7oR5+e6oscyNPzM9GPRyQaDHJ8UaXgzN/fCjfX7EE076yOAj2yb5gOq8uZBhkNGu3AEUX46BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A frame can be known bad before its backing memory is onlined. A CXL
Type-3 device retains poison as DPA-based Media Error Records and can
report those records through GET_POISON_LIST after a reboot, kexec, or
device hotplug.

CXL poison can be retrieved while a region is being prepared, before
dax/kmem calls add_memory_driver_managed() for the range. At that point
there is no initialized struct page on which memory_failure() can
operate. The poison information must therefore be retained until the
corresponding pages pass through memory initialization.

Add a registry of sorted, nonoverlapping poisoned PFN ranges. Each
registration represents one owner and its independently managed memory.
For example, a CXL region registers the poisoned PFN ranges translated
from its device poison records and receives an opaque handle for that
range set. A second CXL region receives a separate handle for its own
ranges.

The owner uses its handle to remove exactly its registration after the
associated memory can no longer enter the allocator. Removing one CXL
region's registration does not affect poison ranges registered by
another region.

Keep each registered range set immutable and protect the registration
list with RCU. This keeps allocator-side lookups lockless while allowing
a registration to be removed safely after an RCU grace period. A later
patch will consult the registry before initialized pages are released
to the buddy allocator.

Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
---
 include/linux/memory-failure.h |  92 +++++++++++++++++
 mm/memory-failure.c            | 175 +++++++++++++++++++++++++++++++++
 2 files changed, 267 insertions(+)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index d333dcdbeae7..ebb988c2fe12 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -11,9 +11,73 @@ struct pfn_address_space {
 				unsigned long pfn, pgoff_t *pgoff);
 };
 
+struct preonline_hwpoison;
+
+/**
+ * struct preonline_hwpoison_range - Pre-online poisoned PFN range
+ * @start_pfn: First PFN in the range
+ * @nr_pages: Number of consecutive PFNs in the range
+ */
+struct preonline_hwpoison_range {
+	unsigned long start_pfn;
+	unsigned long nr_pages;
+};
+
 #ifdef CONFIG_MEMORY_FAILURE
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
 void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+
+/**
+ * preonline_hwpoison_register - Register poison before memory is onlined
+ * @ranges: Sorted, nonoverlapping PFN ranges in ascending start PFN order.
+ *          Adjacent ranges are accepted, but callers should coalesce them.
+ *          The array is copied and need not outlive this call.
+ * @nr_ranges: Number of entries in @ranges. Must be nonzero.
+ * @handle: Registration handle returned on success. Set to NULL on failure.
+ *
+ * Register PFN ranges that must be withheld when their backing memory is
+ * initialized. Pass the returned handle to
+ * preonline_hwpoison_unregister() only after the memory can no longer enter
+ * the allocator.
+ *
+ * Return: 0 on success, -EINVAL if @handle is NULL or @ranges is empty,
+ * unsorted, overlapping, or contains a zero-length entry, -EOVERFLOW on PFN
+ * wraparound, and -ENOMEM on allocation failure.
+ */
+int preonline_hwpoison_register(const struct preonline_hwpoison_range *ranges,
+				unsigned int nr_ranges,
+				struct preonline_hwpoison **handle);
+
+/**
+ * preonline_hwpoison_unregister - Remove a pre-online poison registration
+ * @handle: Handle returned by preonline_hwpoison_register(), or NULL
+ *
+ * Remove @handle from future pre-online poison lookups. The caller must first
+ * ensure that the associated memory can no longer be initialized or handed
+ * to the page allocator.
+ *
+ * Pages already marked as hwpoison remain marked.
+ */
+void preonline_hwpoison_unregister(struct preonline_hwpoison *handle);
+
+/**
+ * preonline_hwpoison_intersects - Does a PFN range cover a known-bad frame?
+ * @start_pfn: First PFN of the range to test
+ * @nr_pages: Length of the range in frames
+ *
+ * Return: %true if any registered range overlaps [@start_pfn, @start_pfn +
+ * @nr_pages), %false otherwise.
+ */
+bool preonline_hwpoison_intersects(unsigned long start_pfn,
+				   unsigned long nr_pages);
+
+/**
+ * preonline_hwpoison_contains - Is a single frame known bad?
+ * @pfn: Frame to test
+ *
+ * Return: %true if @pfn falls in a registered range.
+ */
+bool preonline_hwpoison_contains(unsigned long pfn);
 #else
 static inline int register_pfn_address_space(struct pfn_address_space *pfn_space)
 {
@@ -23,6 +87,34 @@ static inline int register_pfn_address_space(struct pfn_address_space *pfn_space
 static inline void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
 {
 }
+
+static inline int
+preonline_hwpoison_register(const struct preonline_hwpoison_range *ranges,
+			    unsigned int nr_ranges,
+			    struct preonline_hwpoison **handle)
+{
+	if (handle)
+		*handle = NULL;
+
+	return -EOPNOTSUPP;
+}
+
+static inline void
+preonline_hwpoison_unregister(struct preonline_hwpoison *handle)
+{
+}
+
+static inline bool preonline_hwpoison_intersects(unsigned long start_pfn,
+						 unsigned long nr_pages)
+{
+	return false;
+}
+
+static inline bool preonline_hwpoison_contains(unsigned long pfn)
+{
+	return false;
+}
+
 #endif /* CONFIG_MEMORY_FAILURE */
 
 #endif /* _LINUX_MEMORY_FAILURE_H */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 60e968243470..e89b400c3fa2 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2291,6 +2291,181 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
 	kill_procs(&tokill, true, pfn, flags);
 }
 
+/**
+ * struct preonline_hwpoison - Owner of pre-online poisoned PFN ranges
+ * @list: Entry in the global owner list
+ * @rcu: Used to defer the free past a grace period
+ * @nr_ranges: Number of ranges in @ranges
+ * @ranges: Sorted, nonoverlapping PFN ranges
+ *
+ * The ranges are immutable after the object is added to the owner list, which is
+ * what lets readers walk them under RCU with no lock.
+ */
+struct preonline_hwpoison {
+	struct list_head list;
+	struct rcu_head rcu;
+	unsigned int nr_ranges;
+	struct preonline_hwpoison_range ranges[];
+};
+
+static LIST_HEAD(preonline_hwpoison_owners);
+/* Serialises writers only. Readers use RCU. */
+static DEFINE_MUTEX(preonline_hwpoison_lock);
+
+static int
+preonline_hwpoison_validate(const struct preonline_hwpoison_range *ranges,
+			    unsigned int nr_ranges)
+{
+	unsigned long previous_end = 0;
+
+	if (!ranges || !nr_ranges)
+		return -EINVAL;
+
+	for (unsigned int i = 0; i < nr_ranges; i++) {
+		unsigned long end;
+
+		if (!ranges[i].nr_pages)
+			return -EINVAL;
+
+		if (check_add_overflow(ranges[i].start_pfn,
+				       ranges[i].nr_pages - 1, &end))
+			return -EOVERFLOW;
+
+		/*
+		 * Require sorted, nonoverlapping ranges. Adjacent ranges
+		 * remain valid, although callers may coalesce them to reduce
+		 * storage and lookup overhead.
+		 */
+		if (i && ranges[i].start_pfn <= previous_end)
+			return -EINVAL;
+
+		previous_end = end;
+	}
+
+	return 0;
+}
+
+int preonline_hwpoison_register(const struct preonline_hwpoison_range *ranges,
+				unsigned int nr_ranges,
+				struct preonline_hwpoison **handle)
+{
+	struct preonline_hwpoison *owner;
+	int rc;
+
+	if (!handle)
+		return -EINVAL;
+
+	*handle = NULL;
+
+	rc = preonline_hwpoison_validate(ranges, nr_ranges);
+	if (rc)
+		return rc;
+
+	/*
+	 * The range array may be larger than a page, so do not require
+	 * physically contiguous memory.
+	 */
+	owner = kvmalloc(struct_size(owner, ranges, nr_ranges), GFP_KERNEL);
+	if (!owner)
+		return -ENOMEM;
+
+	owner->nr_ranges = nr_ranges;
+	memcpy(owner->ranges, ranges,
+	       flex_array_size(owner, ranges, nr_ranges));
+
+	/*
+	 * list_add_tail_rcu() publishes with a release barrier, so a reader
+	 * that observes the entry also observes the fully initialised
+	 * ranges[] above.
+	 */
+	scoped_guard(mutex, &preonline_hwpoison_lock) {
+		list_add_tail_rcu(&owner->list, &preonline_hwpoison_owners);
+	}
+
+	*handle = owner;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(preonline_hwpoison_register);
+
+void preonline_hwpoison_unregister(struct preonline_hwpoison *owner)
+{
+	if (!owner)
+		return;
+
+	scoped_guard(mutex, &preonline_hwpoison_lock) {
+		list_del_rcu(&owner->list);
+	}
+
+	/*
+	 * A reader may still be walking this entry. list_del_rcu() leaves its
+	 * forward pointer intact so that walk completes into the live list;
+	 * the free waits for a grace period.
+	 */
+	kvfree_rcu(owner, rcu);
+}
+EXPORT_SYMBOL_GPL(preonline_hwpoison_unregister);
+
+static bool preonline_owner_intersects(const struct preonline_hwpoison *owner,
+				       unsigned long start_pfn,
+				       unsigned long end_pfn)
+{
+	unsigned int low = 0;
+	unsigned int high = owner->nr_ranges;
+
+	/*
+	 * Find the first range whose inclusive end is greater than or equal
+	 * to start_pfn.
+	 */
+	while (low < high) {
+		const struct preonline_hwpoison_range *range;
+		unsigned long range_end;
+		unsigned int mid;
+
+		mid = low + (high - low) / 2;
+		range = &owner->ranges[mid];
+		range_end = range->start_pfn + range->nr_pages - 1;
+
+		if (range_end < start_pfn)
+			low = mid + 1;
+		else
+			high = mid;
+	}
+
+	if (low == owner->nr_ranges)
+		return false;
+
+	return owner->ranges[low].start_pfn <= end_pfn;
+}
+
+bool preonline_hwpoison_intersects(unsigned long start_pfn,
+				   unsigned long nr_pages)
+{
+	struct preonline_hwpoison *owner;
+	unsigned long end_pfn;
+
+	if (!nr_pages)
+		return false;
+
+	/* Fail safe: withhold a range we cannot reason about. */
+	if (WARN_ON_ONCE(check_add_overflow(start_pfn, nr_pages - 1, &end_pfn)))
+		return true;
+
+	guard(rcu)();
+
+	list_for_each_entry_rcu(owner, &preonline_hwpoison_owners, list) {
+		if (preonline_owner_intersects(owner, start_pfn, end_pfn))
+			return true;
+	}
+
+	return false;
+}
+
+bool preonline_hwpoison_contains(unsigned long pfn)
+{
+	return preonline_hwpoison_intersects(pfn, 1);
+}
+
 int register_pfn_address_space(struct pfn_address_space *pfn_space)
 {
 	guard(mutex)(&pfn_space_lock);
-- 
2.43.0


