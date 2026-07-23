Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A33CBC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C17C6B0119; Thu, 23 Jul 2026 03:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998B56B011C; Thu, 23 Jul 2026 03:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886E06B011D; Thu, 23 Jul 2026 03:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43F5D6B0119
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DE5A8033D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:51 +0000 (UTC)
X-FDA: 85019269902.20.C4DBA5F
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf23.hostedemail.com (Postfix) with ESMTP id E476314000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="aGXzYW/U";
	spf=pass (imf23.hostedemail.com: domain of 32MdhagcKCEku9p3nl3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jyescas.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=32MdhagcKCEku9p3nl3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BP29+lWQBrVZ0v/6HzcYEqD+hOgCbSaZezdh9Is5B8A=;
	b=ItTUwInnuNkNP1lMhiveqW3V7Rl3uCGcdjYUMELde0RQhbZ2IvKTiiAwLTsgSAbwxtGlZ2
	tEpmxQFFH2Bx8YoAAiscEfkhMKxlG6begXnt88xjax1ub3zZNDenQuZqVgcIKibPo4rYrT
	YBwIefIBvoanW+MscB1dzePHymiHpII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793049;
	b=UchdvFUzqvkCDaCzzMVyObfWwqiNglIplumU7Mw1DxGjtB/m4qVaT37SyZmK/GtOuR1hZx
	wBrboEyga9nE8XrXTy3OTP2IgnJ4BsUp35VPFZs2JRUzg5mXm0ghCyh1LNwl2IK2gY2LV+
	MyHiXZreud5uyCmZah1KBcLAE0MpOUA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="aGXzYW/U";
	spf=pass (imf23.hostedemail.com: domain of 32MdhagcKCEku9p3nl3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jyescas.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=32MdhagcKCEku9p3nl3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c96b4f58ddcso410658a12.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793049; x=1785397849; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BP29+lWQBrVZ0v/6HzcYEqD+hOgCbSaZezdh9Is5B8A=;
        b=aGXzYW/UNi1JIvuI+z1NdvqUvmpAuG9PoR0x9gBAeWamJZ4oh3htmiCnNh3Os4WHR0
         QEpJP+lBM1q/hsxdbqSy5JI9VQ0ixvjEye5V77yVyZpqliMoyCiJjrdXmBVSZMy9mTOK
         qgi0V+pdFhmzPdqcKLKhmVMMn8yLBUWNY1LKE54yagSayTUveIAzyKlUW4NaIaaBNn25
         PVWRKkFtjr130/5vhjprpuWYfzMU/mtcJqUdF/+kUGJljUglhfGfkyf6DnOpA1goj6Sc
         brE3gT7E/ujMMnn10I51nE+obWSiSt4jkyOds7D4E1p2KT01jngwIeeehj5WmE4wrW8z
         uVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793049; x=1785397849;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BP29+lWQBrVZ0v/6HzcYEqD+hOgCbSaZezdh9Is5B8A=;
        b=knQztkKCK7xiqmGw8sWsLcQZIwRdawU6O4pj5DNNCLu4YuftD2rgVTEB0Isf3jCDX1
         +CgdP1noxh4+tooMypFKWjbKxSpufjb1OJB4GFWS8B2xUUQ38b8+RZqYS/9TaA0pOWZG
         ShREQVYTIZO0NVVwThCwLhK9tseLwnxkUJ7/c8i1xEKgZph9uzZaq1pxLy83QDjpL6MF
         RhvNHCk0rvRmjqcWJQtMS3hK7oIycjoJsVGnQ4nP7fdnlwaIOmkg2GMot8aN3MNBXcla
         lJZBkl6Lt0/Ar+h75cFyagj6kDEoelRzWipaJNBs6VJbL7DFpA4ePsHhi8jKiweAdPbD
         6uSg==
X-Forwarded-Encrypted: i=1; AHgh+Rp2gNQ9R3Bdzwxkgcu2jXZSUvY345+wXkRZENRIrfqwcVuQ65scBte8ln/BnmPgAYcTvFNq2XZ7XQ==@kvack.org
X-Gm-Message-State: AOJu0YwEu9o5BWaonJih9SOsNnNNWDSmNYJ0MJWR+IyAw6okRtewThqW
	YF85k6wk5ygCGFQnptAGUcejC7YC5o+ENqg5E8/V8NoIC28W4P0ZWayG8XjnxmuDmwQLmdBIcjM
	srcEq5lzl0w==
X-Received: from dly25-n2.prod.google.com ([2002:a05:701b:2059:20b0:13b:9d65:a542])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e85:b0:38e:5741:5173
 with SMTP id 98e67ed59e1d1-38ec662cdc5mr1864402a91.29.1784793048525; Thu, 23
 Jul 2026 00:50:48 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:16 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-13-jyescas@google.com>
Subject: [RFC PATCH 12/16] mm: Define the make_alloc() function
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E476314000D
X-Stat-Signature: s9ds5ipykqsh7qccpiiijhjpwcusfeex
X-Rspam-User: 
X-HE-Tag: 1784793049-334397
X-HE-Meta: U2FsdGVkX1/+uUKAqnUUhP/S0/+tugVq+OhJBIs516J2DxLIu0t32vkO402Ug8D7CdMJr8NRrg47gjCuw9TZCOwrL4W+e7TTQNjnlEowew+ugbEtj2xUH5CgbcnT2WM+JyQRuzQxiOvi8RTgwAmqGbKfj/jBTFBSF4rlKjKrgGmkb7ctAVMIil7/jCwwNkQKubKjbRtFAwTZJMgbjGKUFAQ2lzKC7sGqU2uEAefM5jAztM7dRqK5iWvi/IbQt5MgW9gZoDL9ywghJ/q27yN3UrQV5KJaxh93IbyU9WXmWlOj7spR9ht5MG3n4apUf0rFfEL4nLx95nvlN3vFHUNkAVYD0Co8SrQ+7Lj8DEgk+J5j7R+1TFg205MXOwuU22+a/hpGhsDPI0Ik/uksG0nuoOTuLFoT4izbrjoUDvQtwSM0iEt/pJq5ehrx/k14v1BTn9rq4Aiy8SyFEdEgcgmiXODFAoVu1OefcO09z4XL7HD9SEvx9SG4EmCB4QhXepD91rrfB0sRrbiAZL+RYnDis/CYicg5K12tck5JBL3Bal7sbVEeyFKbv1Boe9SRWNX992UNcoR63e0mwbPMxmheZYOukb2YtsvIrRW/PbymNnJMKn9zcd/TpgiAMk9j4l/I0nPg51lzKte0VZd0XbJxPSRvPm85SNzniKIBMW2DRJmzvdxu4ryDWhkht0/lFZZTisuH61v6Fp4DT5Eln1ulUftmzL6dg3S18Vsw1KUlUox1++oXjrXE18WgmCpCW9SeYG9LarMNYzdyJWMYnekpUZwolV+cCRWJ9he7vMqbof9dS0RK+PBGJIX23M3ANi41kWkF8ApD1mixaZR8PMFggNeEJFf9rwuCggqyy3rKiSiKAzI+DuwMW2TgpHlRrBPo9bKR63UMoKhTMoF2+lN38My0ywcrPjsd7XQnLI+/Edfbh5JJik7Ilmg4T2AnswuAJDMi9HlhRQ71Pm9DJGB
 u7TOYrgl
 /yklW70kH399YM0czXFszeLrG1WAJ06C9qQR01400XGdh0+QW9KPxQ2yeCebT1NOLHf3/tAOcFAmqD+Pqlp4/l0hAo/en7gB34BJHk4hxvNFKYfFOQC0oC9zVFl116uGSB3xb2n9DUpVAICt9W6lSKRp24YhwaXP/gzm0o6gE958gvf+LdAcdiDErQQ47K876YM04e6KeguXjzAcZyaA5Q8+1KubmWCN353noih36tI6s8dXoQW+i3t50Sd7DkHtiC7oxVIiMgpWDShEuIgGJoreg4JbnOk7CUbDE97mhUIqXUpkoRQ3GQRjtauy5SsLSltMPeCns/FjwGzbCThJxJm5wAk9iV+hBR2CYMlWB8ZSE5Ou5E1TS4eEu7KrdKtlaxgK11wTC2F5+l84Enn5BQU2K8K+fwrxZFkT280gT+4B4iBHu7KGxVkeMi7nNmCOiiY97LQ4dzJLkCewo9S4iVkcf1vYgG8mOTdyePPCMdJ5Je19FWMer02LTa+FM3trp26lHtBzSOUyizf8pyfIj76zDHsDg8lOeqyZmPX+d1q84jlp9LbKvgQAB8BEI9zNPBLZMW0dvE18gg53l1ajKvDz2ePG46/0nVnfuOFb7hkECZpjsfdWQefFFqATU1E4G3D/u6SZ6FF/WXv3SAbmSCzhKPu6wpQer4GkWuanDqioJDSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The make_alloc() is the core function that performs the allocation.

The tasks of this function are:

- Call the Buddy allocator to make the allocation.
- Store the details of the allocation in struct page_alloc.
- Insert the struct page_alloc in an xarray using the allocation id
as key.

If something fails during the allocation, the pages and cache
will be freed.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 71 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index d91f49880f8d..7f6eebdd5197 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -97,6 +97,18 @@
 
 struct dentry *mmdir;
 
+/**
+ * atomic_long_t allocs_file_seq - Represents the naming sequence used for
+ * allocation files.
+ */
+atomic_long_t allocs_file_seq = ATOMIC_INIT(0);
+
+/**
+ * allocs_xa - Represent the xarray that contains the actual allocations perform
+ * by this driver.
+ */
+static DEFINE_XARRAY(allocs_xa);
+
 /**
  * struct req_alloc - Represents the requested allocation
  * @node_idx: The Node index to allocate from.
@@ -174,6 +186,47 @@ inline void set_migrate_type_to_alloc_from(int migrate_type, gfp_t *flags_ptr)
 	}
 }
 
+static int make_alloc(struct req_alloc *req,
+			    gfp_t flags, unsigned long *alloc_id)
+{
+	struct page_alloc *pa;
+	struct page *page;
+	char new_alloc_name[12];
+	int ret;
+
+	page = alloc_pages_node_noprof(req->node_idx, flags, req->order);
+	if (page) {
+		pa = kmem_cache_alloc(page_alloc_cache, GFP_KERNEL);
+		if (!pa) {
+			ret = -ENOMEM;
+			goto free_pages;
+		}
+
+		*alloc_id = atomic_long_inc_return(&allocs_file_seq);
+		ret = xa_insert(&allocs_xa, *alloc_id, pa, GFP_KERNEL);
+		if (ret)
+			goto free_page_alloc;
+
+		snprintf(new_alloc_name, sizeof(new_alloc_name), "%lu",
+			 *alloc_id);
+
+		pa->req_alloc = req;
+		pa->page = page;
+	} else {
+		return -ENOMEM;
+	}
+
+	return 0;
+
+free_page_alloc:
+	kmem_cache_free(page_alloc_cache, pa);
+
+free_pages:
+	__free_pages(page, pa->req_alloc->order);
+
+	return ret;
+}
+
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
  * order and migrate type. Once the allocation is performed, a file is created
@@ -183,10 +236,12 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 				     size_t cnt, loff_t *ppos)
 {
 	struct req_alloc *req = file->private_data;
+	unsigned long alloc_id;
 	unsigned long nr_pages_allocs;
 	unsigned long *allocs_ids;
 	gfp_t flags = 0;
 	int ret;
+	int i;
 
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &nr_pages_allocs);
 	if (ret)
@@ -200,7 +255,23 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 	set_zone_to_alloc_from(req->zone_idx, &flags);
 	set_migrate_type_to_alloc_from(req->migrate_type, &flags);
 
+	for (i = 0; i < nr_pages_allocs; i++) {
+		ret = make_alloc(req, flags, &alloc_id);
+		if (ret)
+			goto free_allocs;
+
+		allocs_ids[i] = alloc_id;
+	}
+
+	kfree(allocs_ids);
+
 	return cnt;
+
+free_allocs:
+
+	kfree(allocs_ids);
+
+	return ret;
 }
 
 static const struct file_operations req_page_alloc_fops = {
-- 
2.55.0.229.g6434b31f56-goog


