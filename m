Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8656C606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=gCXfCy8a
Received: by kanga.kvack.org (Postfix)
	id 922926B05BA; Tue, 17 Nov 2026 07:07:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ACB66B05BB; Tue, 17 Nov 2026 07:07:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D946B05BC; Tue, 17 Nov 2026 07:07:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48C206B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B48FB1A041F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:27 +0000 (UTC)
X-FDA: 85444486134.01.03E4A83
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1934C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gCXfCy8a;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917245;
	b=LOjUrD/2W5g0TSNRbpjAQLzkFbiwyvSSk5REU+ky8mqaHfBB7IPCKbybULJssj3qbWCqNs
	A+ATv1VeHY+RiW/6oq9NzAKPMq6n2kR0QXL5lwmAkDk/5e+0NnEAzMirg3Z7TCdOqHffqz
	U5QmBWzAQoOsM5SbS2uWrmpuJW4ewGk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pngp1egAaX0YbQYqS/9oJoUz1wuFN3ikmsU5M9jflxo=;
	b=woPAUYrwCuv9j385oXmI828VVjpiWG5us9Dc3AuZfG9qwfQNYbTHgcBuqcMLrDUe+46W/T
	y5rDch/CA6tIsNOfdFbWOZjenE357ZQAW/rjTgYNQf7pjJ11Qo0U7qvFlDfRuAZfydzhAX
	2kqm4hR03nVSSKIES+jrR7aZIi5C7G4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gCXfCy8a;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b24f4b15c4so224861c88.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917243; x=1795522043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pngp1egAaX0YbQYqS/9oJoUz1wuFN3ikmsU5M9jflxo=;
        b=gCXfCy8ab8J9Q0AE+YvVFMMkY6pizh3Rx4R3FHRWGRu1bBWFqsUMw+pSFYdzxztpem
         a0u8HScGvaQ0HM0cu1W1/JXXDeaRsak51vzXOEQyYYAqVHnlTkfcI8UsVKY7/UxUVC0l
         c7+MEHCZX1LheHe5+vZSxvx5fcrSSkvaYRfMSbEwYjLGld7YCtM0b/LcTfBlNP4Juw0I
         buhgfTTmv/ShafxCnzxFwmpz5U9DYw09C8glNMkugJUVmg7YuZaSbRig/SuTImqHMKaa
         /XuD6uZ4/JlsRkn/tukNNclL9eWLjCwmEIbLQXMVJB2bd3Ja9GoY6/ucRX2ieNp2dXSL
         P0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917243; x=1795522043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pngp1egAaX0YbQYqS/9oJoUz1wuFN3ikmsU5M9jflxo=;
        b=XcSAev4WEkWJUej5oa1t4jyazj5YegUOPA/L1Tlyu9ZA1Z1FGVCrg1s4PGkfBI+nF9
         U95AxSnuEcu5sGJYpUDyMcBgpvx++7Lx8LUyiZ0j9Is/t5MkbSxqUMxH7ExXEMMJxa8G
         nOlcvqbGedpNTI7lMcNbG/J8s4TlqOEhTgjdN7QZiX8s/Nxhi67UyXVGsWAnNbxLH/+Z
         4pQxf+KUhIAlJH4KpR2maGS3ieForB6yfHjwezxEBnX6GA4nQuqJjdtbeBV5rHVkKRw9
         UMJwGV3+Orte8bQ+a4BWLxKgE1snJfRKWkbNbj6zh7cchq4mchHKtA19jsRqtj/SlHRJ
         Z4Lg==
X-Forwarded-Encrypted: i=1; AL+hErFnp7lqFbD+aiT08aS56Ko6U6k5oaiufHxeFAxA1pkoXu6/8ElzyytGdxQeTrarxoZBHIuJcf3eVA==@kvack.org
X-Gm-Message-State: APuU4Z9kuLvlXLtqUAnUlGtkZYYCQnB6hzsLl+6QO4cRDZNY6c7/N5Yo
	5XHO6G7fTiCYUSCdHV+ZrgufSF/eRAsi2GZGPmhe6pvyS9t7csg82nP2vOkTM93J0SE=
X-Gm-Gg: AYBFou2TcHNq3ixo/xZlgyv2Kj0SSav41IooOy4svdSQ9Cl0lAEk4s7MvkSTBv0ENTG
	tnSVhklHS53a4ZoXTwEOF3Gt5ek3cPMqIP10oxZ83Pu80i+sanaZTf0wfiqO71si7/9PIk1Q2vh
	cvb4RRaT+CASwb+e724AK37E3FpZ1053Mv30EBLtnQQzXhaolg2XpwQYEdSYAQ8ypmRBdGMqdsA
	Kv0y9Ww20Exw6U57wiaqyr+1qrGCwq0vPDgIqzXaQ9iBhRhtQAJygz30vKR5EAMtgN4+I5FV5+3
	8QKxyVryw0xXfPXqLwZkrUHHCoRnLegGlePqL2hVYi9mvZuJp3F8S7AT65BGIwBk9oY/tWiChun
	y1EvtS8SwIwkSsozaxNfA9wLSi62A9veIDqyzLWl/9gZU6Royo/VafOv9wKfV+gk6g9Qg49asEL
	FXzecrnH/XH0AsmBqnTggOmhP29afEV9qZMWDubnySmTdPO9jks+ITtkzzAFIsAJYDT9Lmgvz4c
	zB2DB/gBJO1XcSNLud88YBs8YiSHRIaTvLvg+v4Pd8XmKw64AwPMnxlRK1RsCZj1xzuRepgKsLm
	lrFz6vQIKbJki0y0iAtesbaf4x7jR6KcY6kVn3pxVOqmgJlEdc8yDeNQTC2dbIfzmWGWXwLn6dP
	LLuJtpwbI41Q=
X-Received: by 2002:a05:7022:7e85:b0:152:dd1b:4fa7 with SMTP id a92af1059eb24-1b53a3e54fcmr2076054c88.19.1794917243422;
        Tue, 17 Nov 2026 04:07:23 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.07.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:22 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 3/7] mm/page_ext: always use vmalloc for section page extensions
Date: Tue, 17 Nov 2026 20:06:23 +0800
Message-ID: <20261117120627.50601-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C1934C0008
X-Rspam-User:
X-Stat-Signature: ztrnsuin93ggntrwfhpcc3s9jsue9z81
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794917244-305887
X-HE-Meta: U2FsdGVkX1+CDEQdwFY6DyNkjV0DjRbx/vE3RTV1HZ+cHm/CcXFllmxxv9Z9ZPG7Pc5+JbcggnJSZ8/qzfaZHqDpW5d4RjjZ7udziKrlMLNY2XrYp/HG34ZHiTPkaYpSg+8CLU0JZDF0mA1td/TFWwfEyCSA5kE/uzGR4eEGXvRW+/ldvusHSofcmL2BT+mtWU9+TpiVnNvGy8g/hxJGbUr3NgTcjzKfhMfrsOOw2Ua/NmbM4Q90fWtYxv3xvaOvWaBIsEodfthhKKUH25qgHTOQ2WtayGAnjeKSd9e8TZv0twe+oKsfJr+XFtjdbtXN4gWb+6f8zQ1lBPN8okRXL9Z+EA+K35RTGW6Ckj62Njx8vbpXZDUf6kXRovSAWN9ki0CPidU8eoaiRdpSdcjrJg5eF1zGe0tSDpAjEC59VMZg3ZL4+H4kaCVVhhrMq+P7Pt0J258bI7/RVc4RciNB+d2mBljOmWb4c3yza0rGUr8ZvgbK4MB+3vH79ndg+O/mNhb0/9lc0LKKqmzMYHIwMEXe5znmJe92NvQcOe7CJM0986f7DPcva2Zik+cca8Wts+Bit742ui3iP9RO3GFhipAL7rgd1cXDmOKUGsCwWJG9/iuix3ptpw0YisZW7Ta0LxUF4om1rFy2rABbVhtKj09LnI11+UVNHRiLEW97tkWauqWu/d6bTctKO3wdQHO3zsJXnKZOehpb8lt3LYSkqooggBmI76aoebmWi1wCXMsjViVl+mTCDfBCp9aHNnNsQ53V9bVgRClKyVpO2vZytrWCY05E6IsF6HRutkoBnvidGQxCZtlRusJaBW9qDwcwtxx96Hw5TLcBG6uGP3F4MeQ8GaLkKcRoT+9GpWlBN5UWoBJjHp/SlHhE+aH+aM4FXBQNAfi5E9KsJ8SkedGjSOGSllTTOXZZyZ0SRsqyk0hTXv/CKSxp/KbgGV3c1625P9ggbDsM1Z6y/Mxag3u
 n15TvLPu
 pHmf2IKxjhN043Xmn0vtyf5GEmnqIgPB0QQPVsRGOzO8fRKm7o9QOnbWWL2rYXlJWTBTnEeCb4LimaTYaArBmuvPO3tEtRQy33MtZZXfieGVCqQ2cofZnTKkLhTCgtOnXq7NCaNXfzbV/3o/oN4bvDcspGDlE+NZxosDEqX/ezXJtbGpJxdsc4+yxDedLUdevlnpZaPj3fjJKvYt+n822CjL+xPztjQSwv/ApdLbmvN+xV8xPB5pupFT/9L319vqEkEIRFh94GCH3D4QapNUEfmb3htuo6kxNwgeSir1vodNkZcEHagTxYk8a6ifA8TyridtfjBveJt3w8QsqqjhVyIESrbz4id4uyTmS1c2tdj5WSM1XsJ61WkRjqS6mqj9mz72pEpOx5wAOk23DuqtqCG3rId9CNNNeSQGXHdylz1SGe1zlZJq1kw5soImsZ6AuYEyMaiQ7JErtQHzDBlDRF2q4CQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SPARSEMEM currently tries to allocate each section's page extensions
from the buddy allocator before falling back to vmalloc.  Boot-time
section allocation happens after vmalloc is available, and memory
hotplug allocations do not require physically contiguous backing.

Use vzalloc_node() directly and remove the buddy-specific allocation,
free, and kmemleak bookkeeping.  This leaves one runtime backing type
and lets a later change add memblock as the distinct boot-time path
to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Add a preparatory cleanup that always uses vmalloc for SPARSEMEM
  section page extensions (suggested by Mike Rapoport)
---
 mm/page_ext.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/mm/page_ext.c b/mm/page_ext.c
index dbc1bfa258f1..3b581242fd52 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -285,15 +285,9 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 
 static void *__meminit alloc_page_ext(size_t size, int nid)
 {
-	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
-	void *addr = NULL;
-
-	addr = alloc_pages_exact_nid(nid, size, flags);
-	if (addr)
-		kmemleak_alloc(addr, size, 1, flags);
-	else
-		addr = vzalloc_node(size, nid);
+	void *addr;
 
+	addr = vzalloc_node(size, nid);
 	if (addr)
 		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 
@@ -339,19 +333,10 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 static void free_page_ext(void *addr)
 {
 	size_t table_size;
-	struct page *page;
 
 	table_size = page_ext_size * PAGES_PER_SECTION;
 	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-
-	if (is_vmalloc_addr(addr)) {
-		vfree(addr);
-	} else {
-		page = virt_to_page(addr);
-		BUG_ON(PageReserved(page));
-		kmemleak_free(addr);
-		free_pages_exact(addr, table_size);
-	}
+	vfree(addr);
 }
 
 static void __free_page_ext(unsigned long pfn)
-- 
2.54.0


