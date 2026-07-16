Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4FDC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B626B014C; Thu, 16 Jul 2026 11:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBB66B014D; Thu, 16 Jul 2026 11:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF20A6B014F; Thu, 16 Jul 2026 11:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9956B6B014C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:34:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6795CA0079
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:57:54 +0000 (UTC)
X-FDA: 84994490868.15.EE80FD3
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8FBBFC0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:57:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=scY77mWO;
	spf=pass (imf10.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784203072;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmpnw2WuwVbYt2i5mxyglNWbYuNa8vu1yBDcpvt+bw8=;
	b=LY9lOAw6YED0GfXMgD1IOe4ZYCUOuJmfIffbit5mAXArAISk7Yr/tuo6S8rnjMXpoFC6U7
	auxSOyi1w59r7n3zf/ZBVNpITws0GcP7S/llyjLZ488f/bJa7mEuq9wptjxMn2FZ912ehG
	GMLARsYfi7Ltc7qilbssEOezUD30rYo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=scY77mWO;
	spf=pass (imf10.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784203072;
	b=hLrvag3wvk2cTkTqNgvKUg85r+cLB/jjSaEA29BFheca3bsmwSEJG2E0sXOAh4QlRFLTtv
	mk+9P++5IiQUjYiU+0vGpCr4ipIGPWnDsXQUPQHRtmwW+gp/dwIhsreh5hXWgIOMnkjtj3
	Vn0xnHskCBuTFqNIBsR9EGaCtZ1lPI0=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-384c94c9414so2670161a91.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 04:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784203071; x=1784807871; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rmpnw2WuwVbYt2i5mxyglNWbYuNa8vu1yBDcpvt+bw8=;
        b=scY77mWOZU5MJ6CDym2LowwXCzH9mgS0HSK1v1rfU8oAX7rY8LuwopGfWnmQwIcD2A
         5FeowsP6zZoNl8fnNzIKr5uME9HMMq5OMMDusE8HGMQYq9lodUemgYdJNjpXGZ8Bu5mU
         Errjm95CZpLRenW3LUsuEwu6jcevMuMNIeh88aefsMvSaxUifjSKVpdkpfnoeL8E3onB
         lvxTyS8dLzHsFGOXhuc2p6yKqoiv8aNG9fwIQm24FwNUuHVok0juV1r7JqyXB+HXndow
         hSvl93RXdfdw3ExgwHRdM5YKl9QKC9+ScgUbOZuk++jmu7hXuvklTi4BonYHb8UzMjN1
         Sw7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784203071; x=1784807871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:sender:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rmpnw2WuwVbYt2i5mxyglNWbYuNa8vu1yBDcpvt+bw8=;
        b=m4GhdJGnejYOV9aXcLSik01spD1nrsRcM9NmsErX0nTB4LPvPTiFQwbSq+ohF4xtFO
         MALvsaPsiu53dZTbh4YNnlCizDr/e6ERsm4YdbHgblf4YZ0kfu5cKE6nXDhU4KYsW6sw
         cKEvZBw6uRTgy1Q47VjRuzJ5HvB180Zlt8xJ5p12EtCuDgH1G+vBWS2ZQWbPIlomJGmB
         ioJcUmzeLAUyVnskjLBsVjmzJw9Tcmi0i3/866f7vV0CeZkHErdYjpupdgrhyZN7GsrA
         0d/3mbDKEkhewKULGKfRFd9sn6KpxRjuvfW96WuU3wd7KiL7W/22ZNlPwlkZ03lwfqfC
         aM9A==
X-Forwarded-Encrypted: i=1; AHgh+RqtR0PpF9V/ggERSbQP+xYbFE9ycuaG3NEGTGyWadhEJ75lRnAKQRI3/o97rOz83Vt1ApzJOKYYlQ==@kvack.org
X-Gm-Message-State: AOJu0YxAHMNa9OWkcAt4Xoi8MPZzkctS/Udebl3A+p+ynWjZBFoFjHFY
	jGqSIOVsCY5syKEZPxMORSVHNpxwJrUGhy5XcaKq8eJTpnkCUrkMK+KN
X-Gm-Gg: AfdE7cnq9DzFFKOgt4LOer5bpn5JB+rRZez12raEG+0g7uvGjLbw0hF3pj8FkZWENlN
	LvmFrGV16h0/Qb2AvtamRSlPWHitpNEaQbsdIJpcMY8oJOGqZEmAndTCZor0euZlSDNGWw0AYon
	r8pJFwoXCmxKtrZEJ0VPR9pHJgGcSLNxQ0FpCQPS31O98zG62amzMsczX6FSeF8S9CbXuPF2bQy
	SDO+be6BjSrCE3+82GQGnE+jA5ydXJeuYFb5QTeK7I7oqfGdJPmS0zNZMfkQmxil3AizXF/g99p
	wf8gmS5OCY3W/Wk5mXQPMw29b6NMlky8RGtvHAISt5IVL2Ez9b1Y+qmB7XIU6CuGN6p6TKoewdC
	AopWJlQWv6PQ23y8CiQSw4Ot5XAOuLAvKhNqJVWJb1CuqSny1VhO+EUP+8L1B4qOSJznfwfMqyl
	DPsOE45UOLFdRH5hSjNRLHjX+a/ild2rt0oHz4kDLg
X-Received: by 2002:a17:90b:1d0e:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-38e250b1428mr6967576a91.16.1784203071478;
        Thu, 16 Jul 2026 04:57:51 -0700 (PDT)
Received: from localhost.localdomain ([2406:7400:90:2db1:9c31:f107:8086:4204])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6ebe98sm10920690eec.26.2026.07.16.04.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 04:57:51 -0700 (PDT)
From: deepakroag <gaikwad.dcg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] feat: grow vrealloc vm_area mappings in place
Date: Thu, 16 Jul 2026 17:27:32 +0530
Message-ID: <20260716115734.80909-4-gaikwad.dcg@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716115734.80909-1-gaikwad.dcg@gmail.com>
References: <20260716115734.80909-1-gaikwad.dcg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kt81hmf6ecptrdehak8b8zu8zq7r1gne
X-Rspamd-Queue-Id: 8FBBFC0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784203072-984932
X-HE-Meta: U2FsdGVkX18vW1/uFLhu4ixRVIZf1UJKclMRrAlm01GzX3jwuL1zhUzjPk/OKtJ4K2ivt5bgFbLhbCQKTWyQnvcHsoj7Rp0g5R78vbUkkZwyc3nQRLXTvoIibN+GRKMF523assIX/bpFfx10vkcbEjJbNlA0/Ei/a18WN6ju6KPY8ycRkFAg1wPgIWP1kYHHtH93v/LYJEQCEDoY366qXX/VWI4+jxScXZzP+mIODeDnZY3mB1eSpnKPfuANCiVk5iVBA6ZRtjlFkNg+VnTJKfG8zsJqk5kRUY/tP56dShmlYTMt3iE1TbjZ1qbHt3bWEo2YF7vxwLJsBKnnbikhxqk6Gz4buymACU9CweOOTEZMHGpYvJ8W4aVHBqzyYwK8UL7rIujSOJzTJOvdV/kDDg22pzDiD/ZfEUnlYEXZUXFGXyBMptAxXvKjH00pB8QruEI4KW9zG7uC/qhrcQwmpiIi146htrUZUhqKL6n7u8PXvaLRxUb2ROtoCJnUaxwFNJYm5pixPowiRvKI0EljCEKiJBXBE1uZHUOt8hOAkGDl2U+Tzg4uhheqmb325thVade2BI6Jq3zI10AmR93jU1+sYoMEkoB7EoeZSPmuOHJkErfrbv17dpJBr75gxyN11LOXfcUHp+uAwiSkxgSK5SUFsclozvb7CJ65UtLYMkCZ64qcbD/JWUASAVzzyj9EiuRv+zeRVgbxM/KKWb6/2JSEMB2VBcKeg7j459avVUjtvF+8CrqGaHTfN7MjHJa7NO+SsEZvKj3auXUR1BSRnde8+BLjUTyRtS3cU0slF7c+JQKjhBXfouu6JlP/MGvkMdDeunV/lZrj8NRUY9h/0VAVSg70dcR9RSolhlGOe4XgzBFvbABdHQ7176B9FUN2TgHJY/ZL6ZJCIlJPrRTPSVmZ+euvf7ubdDplrnF0SHR7YKAj9mN7CCWSZ7Gf3PFU8T/fMEUAog/OFq1DaLC
 uaMnNVhq
 yuJ+BrJb4sto7TaUUd+JPDAx4eU6QY6b72d4xl+oPoHXZyUaCQeKdxzsExmu74HITN3jCjQYHXnR3LyynFA5d4IceoHMKyb1BDR4htS9qbDh6X4vDX9sku4Zrv6SbEfvCj8REc2zF+8JZkLjVNyKPD2GwXq5SW57VoiTS6ePR+D9KQvqUdKGuEfZ1aPzF21HZfVTl7xqB9srqywQLbeQ+LI+ToKHYjzG2zkVOCHLy0bWL2BKsLKVsqekyD1bAW1dlaEsH+nx5MLh1rVjMvsBRtM6w6k7cSem2dus2WVf9jz09D8F340A8kIL3ha3zVFGvzIGcejHoVvm+xPH9JIhdL9Rh6zP9AO5LC4A07kHUzFdc4EJADM6ZuXqtZrcK4bxwmkGzA8B1zjRcc9/l0SGE+BcR0dt1pGRAeM7GeVl7OJ/zQdh0FfPhGk8093HpYrixBlTYJu6JhO9eACm44P499l/Ab9z9+1JVEkgvlXpazcUkhFyww3Bi4avarA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocate and map additional pages at the end of an existing vm_area when
vrealloc() grows past mapped pages, falling back to the memcpy path
otherwise.

Use flags (not gfp) in the in-place grow path for kvmalloc_array and
vm_area_alloc_pages.

Signed-off-by: deepakroag <gaikwad.dcg@gmail.com>
---
 mm/vmalloc.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1afca3568..1eff71240 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4426,8 +4426,56 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		return (void *)p;
 	}
 
+	{
+		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+		unsigned int old_nr_pages = vm->nr_pages;
+
+		if (new_nr_pages > old_nr_pages && !vm_area_page_order(vm) &&
+		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
+		    gfp_has_io_fs(flags)) {
+			unsigned int extra = new_nr_pages - old_nr_pages;
+			unsigned long addr = (unsigned long)kasan_reset_tag(p);
+			struct vmap_node *vn = addr_to_node(addr);
+			struct page **pages;
+			int ret;
+
+			pages = kvmalloc_array(extra, sizeof(struct page *), flags);
+			if (!pages)
+				goto need_realloc;
+
+			if (vm_area_alloc_pages(vmalloc_gfp_adjust(flags, 0), nid,
+						0, extra, pages) != extra) {
+				kvfree(pages);
+				goto need_realloc;
+			}
+
+			spin_lock(&vn->busy.lock);
+			ret = vmap_pages_range(addr + ((unsigned long)old_nr_pages
+						       << PAGE_SHIFT),
+					       addr + ((unsigned long)new_nr_pages
+						       << PAGE_SHIFT),
+					       PAGE_KERNEL, pages, PAGE_SHIFT);
+			spin_unlock(&vn->busy.lock);
+			if (ret < 0) {
+				free_pages_bulk(pages, extra);
+				kvfree(pages);
+				goto need_realloc;
+			}
+
+			memcpy(&vm->pages[old_nr_pages], pages,
+			       extra * sizeof(struct page *));
+			kvfree(pages);
+			vm->nr_pages = new_nr_pages;
+			vm->requested_size = size;
+			kasan_vrealloc(p, old_size, size);
+			if (want_init_on_alloc(flags))
+				memset((void *)p + old_size, 0, size - old_size);
+			return (void *)p;
+		}
+	}
+
 need_realloc:
-	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
+	/* Fall back to a fresh vm_area when in-place grow is not possible. */
 	n = __vmalloc_node_noprof(size, align, flags, nid, __builtin_return_address(0));
 
 	if (!n)
-- 
Deepak Rao Gaikwad


