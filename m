Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59CA606A686
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=NkLYdeUO
Received: by kanga.kvack.org (Postfix)
	id 66F436B05C3; Mon, 23 Nov 2026 08:52:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626D06B05C4; Mon, 23 Nov 2026 08:52:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0DD6B05C5; Mon, 23 Nov 2026 08:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 187786B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:52:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A61F1208B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:08 +0000 (UTC)
X-FDA: 85466522736.28.FAE1F0E
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 617B940004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NkLYdeUO;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf04.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441926;
	b=2mWN/sa9skLPa2sjfmCRaaclsLWeNGQLCTuc8zWLMrZbGweNw9Uxvos7axr4FVpiG2jWlU
	QG+pXz4QX/3+9/YWYsy/D1Ssro8xfRL8/51FFbrPXHpuLsm4jlPsNcQ/4KeSVWK1h4TZpj
	9Iuo+ji98EJt9F+edEqRlXZJ/LkbeHY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrTUeuiSWYSLVvE8ZZ1kOMd1tWwePjn1AWC0+hhhsyU=;
	b=I0GL2MtaRdRosFI7Duhy8ZIRuiiD1eLOsH+wV9bf0NLl2f6Dk4w4dQk7QjOjfiGNhiTZH+
	qbza6/CVfGGkn7NtZkRHBHO6JELnJLzSEQMFI/T6r1DNpr7n3zKmbUamgZ2Av/rRxSzQ2f
	SRkyx/R2Bbsy9q4tYP9D+ZVj3jSyYIA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NkLYdeUO;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf04.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso30650105e9.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795441925; x=1796046725; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RrTUeuiSWYSLVvE8ZZ1kOMd1tWwePjn1AWC0+hhhsyU=;
        b=NkLYdeUO6A+6JcrjhwIDyxoM5sDLSj8VdzfjV/ekRsyxnRWBBn0YWho74bVl7B8m1K
         bc3It2ygoKJe3TCw2qXT+w5shYEWduxutotK66jBDUz7OUfp6QZeKIRxh1dxhYZWq5EH
         NyGFVi4J3VSXtFSuFPPKJiv9vbHdiMaqN0a8na8UiDhjQZc8UgVQfbrQ0zl0DpZI/x01
         xg2QlwUFsE7/0PPf8XJ60QfK5SNAPVC9GZ3bTIYwtrSwet5rhTg3zAALbhhihPJp30IN
         zpoXRZzGeKnQMJt/c4cZyV47cV4r+M7SbRoj4fVnSFdq1R84/tc17Jsonq4L+YQ/k8ku
         BlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441925; x=1796046725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RrTUeuiSWYSLVvE8ZZ1kOMd1tWwePjn1AWC0+hhhsyU=;
        b=I0eQxVvV+nolrLiXI2LrRVe6/O/bX5I+EDqpfnnBk3uAGM2CiOGviMZTUkCe2Jsaz7
         73cxnLm0R13fxloqGQ7GGT8PMnnIKlaBVlbLwQYqFk5F9o/tcn6C1TdhpD7ER7PIGq7h
         s1KCGgZg7sU8bzYgr7G42+4qsDf6PaQ/yA8wlTeeLSFVnHbFBVi1wz6SHdhknxydUFqM
         MBRoku5m6lo77xH5GvHZAORDQzQG+rT/W2WTKWDMthx+Fk433t4+LcDMkBbJ68gw9mdF
         f9vngAapmNrkTG+uCixtEY25dNaqzPdmEyzCHrDCGH9zu39wNq2J0Wjj0ApeZzRmuGU5
         zEYg==
X-Forwarded-Encrypted: i=1; AL+hErG6ElApVDBsWOmkDzVKviP3noGD7BvmvIo4rivgNFLV+6BytRK7I4eMO+Sc5CnIaEzdCL7C8N9MVQ==@kvack.org
X-Gm-Message-State: APuU4Z9vx0gZ/GhR77miPTgcR7qy+z+IrQZ0IORj4L7Tz2lxFE7jKGei
	iXEmoIYERTcg9UWnlTxgqtWF9qoSwNpvqGclwQQPDhy1EpBwAgVX6jKCF5qDV2XIXfw=
X-Gm-Gg: AZFdTZeL7S5+SbPGWSgqSRrIDr2fWBddIzgMbtz2fnef8ZaefV3kc6owDvy3YUeufVX
	KNv7j/FLGaAaM3VrSB/kLiWsZwXYGPiKC+L1QyEhdIP6ZH8D4Lc0Ba1NzuOD07GJw/ff85Dr5jp
	j+9WdyP7xD3KlHhC+/HNNOx+2vRbbhGuN8KQJ+wtMdUKMkYcG7LiesahHo4DrSMsdftWVMD60Hi
	2cce1OvfsBPFrK6HA2fs3HDaU2tuGpT0ytt9eo4MVEw0DBdrT9SUNlSvFLGZ7tQpEQycta72I8h
	0yarlWQKozooTvre+ugPN/RONjyNzXRqsk9LdMpY1OsCpd6ATrD6CMA2bZzIsM+5i88rn6AvD9G
	1icQQF5fdGJ6QtjmHcrpPYPEVNMU8G0n88gowDqGfGHHvaNT60eBTDhgJ9Qc7NVFRpuVOyyIRHi
	S4mvBW6Ade2wbVBNY5Y6gQbNCD6DdoeGIszJ5RArN4DCEQA0mZZREx6Z44aHb0HUfKozI6tXcb9
	WvG01VDmJNuUWjvOonwFmliuE7N8JARIyWiPav/ZCxcE8mQmTXHGFuXVCFdGsFjaIBUm0rtnHml
	a6yIO1ECS81pajIWeBz+AuvVYNBCeCqF45ZY3o2p5q9ZVg9knCbaftiselD8tLdoEkXbYWOFIPo
	SThqyVvM2/QW7TDP7qANmU0MCFwT4pw==
X-Received: by 2002:a05:600c:37c9:b0:4a6:eca1:7d5c with SMTP id 5b1f17b1804b1-4bb888251b4mr214460955e9.32.1795441924994;
        Mon, 23 Nov 2026 05:52:04 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f1b7800023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1b:7800:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm169279215e9.5.2026.11.23.05.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:52:04 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v4 1/5] include/linux/rculist_nulls: add hlist_nulls_add_behind_last_rcu()
Date: Mon, 23 Nov 2026 14:51:56 +0100
Message-ID: <20261123135200.4086519-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123135200.4086519-1-max.kellermann@ionos.com>
References: <20261123135200.4086519-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: acfaifrbpkadszfrbzk8y3ow14hnbu3i
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 617B940004
X-HE-Tag: 1795441926-476233
X-HE-Meta: U2FsdGVkX1/z8FaRSXdGNr5DM8AhN1L1XUbN1nHBSFcUuPYlN7CmFB4ei713SKX3qSKympY/bUVpW3rMVeeWZkqwXrdJoxrOU646hoNKopSaQKdabqNxjFKMfgpnsfrmRDMiiEaB+3DNos0fGxgoRFxWy27uSaD7TnuzMFZ7UsuR41/6aE3RL1BpUP6PaciAxYOCFKcbX8ok1EUqEhFr8y1ZEN4NkHIWpxbXIGO1hqGfyjr23eLSIBpMkn349bbLB9pvAc7qDJL0KnJAckyH2QPHvafAkRoacG+7MICv8zFGDKO3PTe0nor65lJix99/tn2qixfeROt0VcpbFNLD4+shGNUzFC8JnKhTNm5yLvwnx6q5tdWPWrKT/1yBX+mnUUy1Qgr7RGD4CW1Lt+yehPLhVcUW1pW6y++7jA5yWslLlY1UotJMHx+QY62bkBjmcWbtiJHdeeb8SR6N8kOd5u2wdff8Gd7L9psRc8OgJwbCRYqWV5DOnY3oVNsA8nFBgkphjey+2fX8+4VyxmWPQCUflg6Nlj8pB3qiU3FtOQ3O/4QHTAJUPQ2P3na63dWbxWw3LmfhZra8Xk2Glr2CWBlUP32YT6Lcxzz8swNKLvazSLi89vydtRQnZ5TU3pugexW1pvTmDkDvI2xQ697gzGKmVXtW9fs6w2qop3IIt/oFNdGjCcOC8aPKsoPyrUoN6Q1vihwyU8BkYzAGbLerdg/izfMqqonBbDduDDoCwsvrOPMWkOG0Gn3qHEohsNz2CZOJu3weKz4RYtaJXtB6yydYwhIGQ6Z8lmeMSYeLpcObEU9LHoLVSBYEg5RPke9PuNzar+dUI0S6bsjSjokNwaMQ9KUfmEU9h9eQQznenX0+G56bAoHKlGalcgiyQcrEvXFEaqYIWXZeAXETcZILn8kSQ8Q45E7pMlKimwWznkWVKC8uuaXsK77yD8Kha9O9Uz7L8EGWvOHvPBpd1mK
 OWy1s0IA
 7so5IGUTVc2UdOouctJCCFlTSaum4c1/9UW7jeTivCMs5tjb5PzVt2IxvCnLFZpRU+dpqkk0iHDhfVqpNsIeuWiDU256AkXaKwAaU8Bo35qCg0cCd4IiivW+5TPLvLV1kBk8TDN99WMCL7vxDdmnXZKsObzjbdbGyeoHO15Qamv6lOlpNk3J9uhOhKC6UCBQH5Fq/r0RryGW1N4TcxiDQ50XgEW8H8i7S59r07S9/wJLj7TuboQbayCPtru/mP+4VN/XK3zLcznlfa1v4mrufNvVTc21MJAyH8qby2C8a4D9awKWCMLC+7rB+hS0hXMphmr6HalW/0guXRIL13eVd9QC/VFDTqSibIzYfBDLdspitpiiuZt57EUX7u1JG79Z9fcV9TjV/e0FWQCpPBYYLUckcPHz/QEcOmZQehnE6rixmrq8pH5L6TqCk6Cz1xaBrsjBoA6VCu0bIYDBZURUNwfmanVfUCypE7RAcJlYc2UW4mMG8H/xmTZNvdcXr3mUEF5GORLWui63M3WSl0wbbnhPdiy4sCjc14FoeAnT+iyoXfYsutROJczwLtZRGfLpL0mOg1bTtTfvWLhX5/+QVRibeNCM+QYLd8Z22V3BxiDkrV2k7i8AT+m+/lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move some code from hlist_nulls_add_tail_rcu() to the new function
hlist_nulls_add_behind_last_rcu() for callers that already know the last
node of an `hlist_nulls` list, to allow constant-time appends.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/linux/rculist_nulls.h | 36 +++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index a97c3bcb1656..ffbf5ed4ff19 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -115,6 +115,33 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 		WRITE_ONCE(first->pprev, &n->next);
 }
 
+/**
+ * hlist_nulls_add_behind_last_rcu - append after the last list entry
+ * @n: the new element to add to the hash list.
+ * @last: the last element in the list.
+ *
+ * Adds the specified element after @last while permitting racing RCU
+ * traversals.  @last must be the last list entry, with its next
+ * pointer holding the terminating nulls marker.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_nulls_add_head_rcu()
+ * or hlist_nulls_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_nulls_add_behind_last_rcu(struct hlist_nulls_node *n,
+						   struct hlist_nulls_node *last)
+{
+	WRITE_ONCE(n->next, last->next);
+	WRITE_ONCE(n->pprev, &last->next);
+	rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
+}
+
 /**
  * hlist_nulls_add_tail_rcu
  * @n: the element to add to the hash list.
@@ -143,13 +170,10 @@ static inline void hlist_nulls_add_tail_rcu(struct hlist_nulls_node *n,
 	for (i = h->first; !is_a_nulls(i); i = i->next)
 		last = i;
 
-	if (last) {
-		WRITE_ONCE(n->next, last->next);
-		WRITE_ONCE(n->pprev, &last->next);
-		rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
-	} else {
+	if (last)
+		hlist_nulls_add_behind_last_rcu(n, last);
+	else
 		hlist_nulls_add_head_rcu(n, h);
-	}
 }
 
 /* after that hlist_nulls_del will work */
-- 
2.53.0


