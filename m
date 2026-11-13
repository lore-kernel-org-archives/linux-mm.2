Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07B6606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=gf1QoPRj
Received: by kanga.kvack.org (Postfix)
	id CEC3C6B065D; Thu, 12 Nov 2026 22:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E216B0666; Thu, 12 Nov 2026 22:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3816B0667; Thu, 12 Nov 2026 22:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 913066B065D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11DF2A80C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:35 +0000 (UTC)
X-FDA: 85428681030.12.8451437
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8BB3FA0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gf1QoPRj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjuLQ3sQch1AgnD9MXsNCce3VktIWaK+QChBd/wj6dI=;
	b=LE2iQ8XnOJLw9vxJroR5PohKKH+XZ/lUNfvBYRLeQMqNE4Dtf/LMT0lw1uweaBCR41aaSM
	0x28XfB0GjbHUL7wcgcdV1p2Lx7jIBzu8aTx3cV6Oc599HuTQPNprnbp8mqoHI6XruwvkS
	B4T11we2hqwkB5Io2qD1MBndEmNW0Ko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540933;
	b=CrHHV84/NHpTQKvvNPLbWSoEGAkRddntgxLPjDQyRHMmCcPSo/VrCOKufVKb68BLq40Khm
	+vmbYGYnniFxSEfP6cMy4GzvxqvE39l15jpw4iE4uk4N+cL3ilI5eZ9SPBiBfjb0BNhKd6
	jw5uLE1cPIagFPVQE8q0NYvuPrcIhyQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gf1QoPRj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-33fb4680717so1152040eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540931; x=1795145731; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rjuLQ3sQch1AgnD9MXsNCce3VktIWaK+QChBd/wj6dI=;
        b=gf1QoPRjS1k/9hA5c81grDDK/v0+jf3Nvq3UdeZ9u+KYDJ9Ea10TWWCaG5ZBWQ3ao+
         qamZlZAcG2xeeg4WRmpeJcGji2BHDGKFeQwYHhXQcYQ/V7HGHAWN+EF5DHDAxJDgp8VX
         osQ7FEPt4y9JSaeJOGNhkPxpoEcUvBU19D7dJahg8iMADdcRwqUh7moB4dmdf21Ij9Yd
         yZrOo5H9GOIv/HnHRWEb7ywgn03oyhl0BHNdngU7eNbXEZcm3R5Dlt4gLWdSlgqnsNSv
         Fem4cIMJuyVwfALlJ16yxN6+ulDZVoz9RgUeRtYY/4CDGYjeHUpToyl3QxJhJ50yNVCV
         DRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540931; x=1795145731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rjuLQ3sQch1AgnD9MXsNCce3VktIWaK+QChBd/wj6dI=;
        b=YZoUqlI4n5V1uU71P0d5L6sUSEFHrvkgvsnROUPctMyf7VFyvQfp6ZRD3pwMeQ6BOb
         p+MgJwfCwC6bBOm4VBmjx8b8piGsFmvUJUHAvKNP14CCN8lwFlfKjaXZcKCXaqh1V0Wq
         CWmV8iesalxK4R9/vP5uh3lSFTRQiJhLHuP1rHjSeKnTXHyEB7L/UAKjaYFSWEZqxXAI
         /wJB8Wpa2KuZaYg0QmbQ2U9ocH+ve6vph3qmcPf0bKEHi1Zu4ptOASctzhXfg2d/ueHr
         EQMoYUgNF9m2k78TV7Af+ab0CrjkcZg5wmHfGDeSPwT5THktzUFZ/73yM0TWt1i8D8LS
         wAqw==
X-Forwarded-Encrypted: i=1; AL+hErHznPha/b/ss42C34PVAcmDvGkwOdqZbuo8/tp7fbITmwqbeSplLX4DvhluntOt45qGKSIchMq5RQ==@kvack.org
X-Gm-Message-State: APuU4Z+7XKWl+vM3mvRGx/J/zvt779qMiqa4NLeRO2enD7EGitQEFJAm
	4H3ecLuTwbojJwybaHYotndinLN4UeiG9cf6Nc7BUTtzdvVTswxt6FJRCHTW76SoU10=
X-Gm-Gg: AYBFou13bRMIT3iTc8gZN89zsAlPdXvSqbVzctH6pJwpHYOrS/eL5EEE/CNWC810MSL
	ivR4RicF0vLzq/t5EAoaZs2EiUdfjICKt9a1Pk/XTBbKh8mxR0UiPWsNM6n5XiDLIXXhKrmcaRz
	v8VCZRsUuS+LcjDGqznC/U+qF5YLqnB1lx5J7nSL+HWlKpc7YoGtgHIvKn+n9vBVpFhNh9A+OJE
	fVLG9p/hM1K+u7LLYVduGI0SJzQN+N94KyFTSJ+eyGmSJtbwiwd0lMSBqVNsSGkoFchrv8R+8sV
	m0X8GZT4R57t6jKPOQ3e4fLZmIMqBP+7krCKAYF+5d4rm/jvpVHsxsVRj9SJ3IlOHSmEZ2rrxMk
	a5J6th+WQGpL7W1WyuujNabEWOSqGQBi45yMDoQPDcDfNU7+qkL9/ez4JjCWLtUiqEhykoG3pmQ
	xeMNRrtjQfxUkQh1y23qXlFr4+5a67KpRH4lVRKwEj2FdfXRpJk+V1W9PjF/xezyZw3fTjWYk23
	GIdtzOVd9kWuCWZ6lSJS4UzKGDXWK5yZkm0tHwl//OoFR0k9cib1wchezii7O1zpkqWxaGUeVqN
	Y7Im4QR0LCJTtQgxcLcoKlrgxkTzn1z1Q8IKWTJYPzv0EHFWjEd7qnGEo3Dcrw==
X-Received: by 2002:a05:693c:80cf:b0:36e:9773:84b9 with SMTP id 5a478bee46e88-379673132d2mr1035256eec.23.1794540931106;
        Thu, 12 Nov 2026 19:35:31 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:30 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 03/14] mm/mm_init: verify zones for template-initialized pages
Date: Fri, 13 Nov 2026 11:34:31 +0800
Message-ID: <20261113033442.62970-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: modk1t94q3fiaqt8expuubh96oeeoxp7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BB3FA0002
X-HE-Tag: 1794540932-905282
X-HE-Meta: U2FsdGVkX1+AfmwiEdKGoueE3cuQmq8Ho5BfxxcWPkGzc+gr2aTHW2llirI/dQ29dsrohmeS166RGI7W6hwAkndGVqeNcvslsbZcp5nvAYYRk6XXNdJcyB6ekE5+BE1Q7SJz8TCrg06+cGf/YvHeuees0InRYTeNSKD/Wbd7KpUbj3Zm3mihngsujf5Nzm/uk6n1o9qTPiN1Mcd28Q2OlZ1YOQHXbX/kJWK2k/wiGUObbly7AVaMHA01LOEd/F+dx+GZMVZ+yIbo9iAvrBiqTHuy2mpi/2niDr6/2YotQo5UNVQPC/gWWrs2sie9BbPVk9bpBXq6S8Ik9ejM0D2i2nZZ+G8c5Dwt2RMjnHZ3ITspg33oqYQj981DgaLaAqACam6HgS6t169J+USVQ+VH8C5ZIg6bSfDGKF8pXtlrsTuMt9bjYceV5JGbyjHQfluzyj61f/V99XL4Q8dFJoKqG8IVPLrTiw2SNuO5JE1INNluloy9en3n7vj6PGHr4MnNWl68KjkYzUkJCG7T5z+U7zlkpbj+mLspZzb38YsDRDR+bdWLQag0NsgSNoiRciqdMMKeRJTIZGdKaZ8Vd3Uwlbn2bCL7ndj/T3ao5kvvnP1qALau5wY5vvxb4hfi0pbLoGL85tL9wfTKYXrl7OCS+T+bXUuZ3Z703HiK09jQkHWmPB1NklM2tydrLmk1aPiMKavSAD1F+CBVoQjhuWYBn88AxcMtp1MNWnRJMHML/lw/1USQ+foHXclKaUNEnAs1EK5Pnq24FO8rLu5ijmNiU8/Sd0gJO3QHY13znjpeBzNFD3hK7WSghenlfxxmvLunl/Z7ambdQy+8e/DFgSUUy8nh8cLRAGQJ0plddCdXxo/jOxf3blbx6u5NMKDodJPrHvIH4YnDMl0mktz+dtMnl9kFcZu2RtuhuJSkl2C7E5kVXWp1UVJs+KzjemXTskx2918CPR7hES7ZRVCWkfz
 s5FIiywR
 rZHofbJbSg9XVTbwWEeMVNKdJoZsUk844Cammb7yRw0ouxkHdLJDjJ5gFCuVvLtHd5ngSHWIwh3O+AeCgQLMrzM/5KRDkY6FnaL3EfzsoArLXXqTud6qiRqWRnX6kAaT/0MkGRTBlYSLDmhxsxRIHW/cxI13yVWBASW8siLh3gCJz/e8AgqN6C5FGu4CAiYSS+/dL+8GICfKMsgQZ31lbByoLT+QT18wabbLvy1cr5sh/EDVoWFJvLItS4yvfkUJOIDZGvJk1kCbWlcLymDHtXYi72e9WwKL7zk1CWI5RhoQrRIKRVDOko6hLNIlmcvoeGEf/zAgYO2tyaZgdGz5cDGjVloTzwomxptTDrrHPcp/yoK6Qwb49Gh5i1IGBu6gy7Q9E92K44Gu88Hmo2bWuDQyUcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Template-based ZONE_DEVICE initialization bypasses
__init_single_page(), which means copied struct pages do not run the
vmemmap zone consistency check.

Verify each destination after copying the template so the fast path gets
the same validation as regular page initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Apply the zone verification in memmap_init_page_from_template().
- Collect Reviewed-by from Mike Rapoport.
---
 mm/mm_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 639880afe0ee..5ce5a325021c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -724,6 +724,7 @@ void __meminit memmap_init_page_from_template(struct page *page,
 		memcpy_nontemporal(page, template, sizeof(*page));
 	else
 		memcpy(page, template, sizeof(*page));
+	vmemmap_optimization_verify_zone(page);
 }
 
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
-- 
2.54.0


