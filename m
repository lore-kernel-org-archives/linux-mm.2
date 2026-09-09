Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7FE5C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B6F6B00A0; Wed,  9 Sep 2026 05:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30BB6B00A1; Wed,  9 Sep 2026 05:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B275B6B00A2; Wed,  9 Sep 2026 05:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9133B6B00A0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:46:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 168D21A014F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:46:54 +0000 (UTC)
X-FDA: 85193744748.23.A3B3BA6
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 51F7A20009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:46:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zg88UL5d;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+7MnKyiB0fAnf+ZBPoUiSQUKpsvD64pam2O0QOh8zY=;
	b=j3AhtPt/ZpwDJn/moDo4JO5ZOVK1yuywbL6zlf6/H91WeZCj9ynO7mhrE9YP2KKQgd/5Yu
	DAGkI+Vv8Cgoe8W0mIoAHCq1AJsO1TsD69YuLAdDnwMhbUIiJRZ4x7ra3ElbdUCcRqKelE
	8tOPPgh3roYCJF1pgw2f/6j7pMiOyzM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zg88UL5d;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947212;
	b=u91lu2ApGP0Pc1Jye1QciOYP7nVdl7PuBsfnl2LI++q4H+LSEBAdJ/FepvcU/Q3emvf/hx
	Zy5biWVNkVKCoKTZTntRs4+0xvCMYbfcuOYneenTV81Dx9DGvHBXX93W/e0+VSUMLZX+9j
	SXn+TPCL+gQh/8THiJ4qeORk30dAfEY=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d46e4cdccso8525187b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788947211; x=1789552011; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+7MnKyiB0fAnf+ZBPoUiSQUKpsvD64pam2O0QOh8zY=;
        b=Zg88UL5dGUsenWgfv/mZAsX9BR3/2nT67bLZf/rP8ihvmcbdQdKN25rRJ37R5TN+Zh
         2uptNC8RJXmGeaq7e65pmzZ3B44WJ6nROld8Vtf3Fu/c4ESx8E6NJaNQ3hV8V42/JxVG
         Cr8p7PH+oYEXdPpTdv2/gRNsP2NQkpf9x3sIw+14dKx4vC3cPxEnkg09zS4vllQaLc3O
         1lnQXkoLeOEPARAXVUeChCnI/NfkFUIHD1B2RDaYeDwdhzdbFHghG5iKkBx0ZCS2Fsdb
         lyNc8tcNnnh/wq3U3ER9oldf0K/R/y12SdAjM8hfj+fD+tRGk6Se0xVzCv6KzMd5iGIJ
         STeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947211; x=1789552011;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5+7MnKyiB0fAnf+ZBPoUiSQUKpsvD64pam2O0QOh8zY=;
        b=GxrLS403t4UGhxCQ8ZfniNe6dNOqjHRa+o+oz0+t88WxUJ++zEkyvX1A/u/zvjggkd
         lh8Yp0KwcfvoXN3lYEbnsG0iu/9Y5rtSeQDdhB+mAGmTKkuSKrpvaLwCWuiFZPGV8oXJ
         njJoMM1nRsP+fSQ6fzFX7QH6GMlTBKFScE86dV3oSsp3PeyMRBr1NeMvqtSGvI5VtCJ2
         TBM6LxJI+iK+NXuqHRM2WIrLRZRoH7xkn/UnIM8yOnYfgjeQPZI+p2Xrey99q+CY9pP0
         38v7GAWbww82DTwK1T1r9XQeaN7ZV4I0GD3d1ACNcHPNN/3ouh27VYgDGR2O0TwaBdwo
         oSKA==
X-Forwarded-Encrypted: i=1; AKwUvBy7wKbHE6FBaJdL1xg354xKDaTOCSumM9GG8mvMIlW1Ed/8GSYXadpey7coewnmit/L33I1ppAmsw==@kvack.org
X-Gm-Message-State: AFuF++kC//w/G2R1VUEjrzBZUuHYlGcwKDke94bVMsfiwhH+ZWtE7Pv2
	iq0uSsInZVtz/ZvyMafRUGu0VwfFI/YFtRm9F8TA0dlMxJq5+qKOA5ue6p4E0rFAEg==
X-Gm-Gg: AYBFou3KexwK2lPyhzkLG0fm6XmR+ObIkGtqqf+DgiIIwrfRSCm/TLdR7QYy8suMd6I
	qFn3exjVYtH7I7xm0P+UyO3a2oAc4qmv2WuaS12PxqLjLSql+ENbB3UJnwZMXm01IBlR3DDuuzs
	xD5Kw/wEyxJ9hiiavF0N/enff7xrNBkXMTujSrGhB0oHUG48+lBhiBgns5/D5DIvF7A2NXbuuxW
	cPtJq9OKRVK9T2ktvI8O/f663vaqlNGFUWRi90tJG60fArH3YKXDn0TxBUApbqfmtkcUx1FHcU/
	jb8hE7/K+dOiaMQMz5ZYdt2Q6uBw9g+9S8FviYhAmrHv/zHm6WPDkufZNrKZSoinH3qhzKAeuob
	VI2+1lrybexPVSA5sg37VcLjeBXxjAQjVQQE04Smu32Wms234wFnX6ITqJvPvsyYI1jL7O51SMZ
	CsyXASq/R3QxhA9fs2sm9SoPxqAY4bucj9fS2EwDKmzSjtNv6eG0EL5L6LKIAi/r75hvTfEP3j0
	IJYik/uhzodDYelj/g2q3uwavf0XvlB+ZX6J/fvp/L7Q1jQlyFhOrbqvM4=
X-Received: by 2002:a05:690c:650c:b0:85b:35f6:bc5d with SMTP id 00721157ae682-87f23fe7a98mr24694497b3.13.1788947210602;
        Wed, 09 Sep 2026 02:46:50 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-87149316356sm106597417b3.9.2026.09.09.02.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:46:49 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:46:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 03/26] mm/fbatch: temporarily disable lazyfree and
 mlock+munlock batching
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <5953f6aa-ca44-c9a2-97e1-a5b3b92e9e50@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51F7A20009
X-Stat-Signature: gja56eomjrupbd1iyadte8ju3ceekc9n
X-Rspam-User: 
X-HE-Tag: 1788947212-46624
X-HE-Meta: U2FsdGVkX1+nlJ2Kr9SDKPKf3SeaY/xtbTXlT5u9UEddifmASdksh3zJLphkAmrOQfacUBxDyBJ4gArxkAf8WosHvBIFKIXlQ8aAz/nduTr6jvEOb9CaBLDHjnFxUgdcF5ODRCZw8pKxx6lHXRIdBvLdozcAtOk55pqgvfbNHEZ72qrXR6GRmk63Cymf7HeEghsla9JoGg6rNy9w3Cs04oRiBUubQQ0RRY0yNm6cDBKKFSKCqn3QLvLVYqPJubOuCALj3/RrSsX7SWOE7uTbEbIr6HexcJNhV6ELOSoyYaAECjp42i85jlceBBoMnV/ZekAhnh0ylIrTcrPIvTih1AN5hWu4A3BCuE89bLg89uK6xEEFr4tURoTY859Vu8QkITZzEAo/4ZUYaW2zLxtTL4B+yi1tEmHNwgWM09eCtBZWWpdPpCnUi+yJGhI3U27d9QVbRfhUtMMgC9qYgLj2h+c+DWmvtYJVzny9cdUff+9vxj93Ke4K1CfAUjfNInXvp+3gDPti/BdRfMFNzoe/5eO9VZeZaDf6BdrNY4rsafIEfu5BJruxT3ZXp7dmuzDIuBWSXIiiOqZsKcnedXjB9XKvTeEBBeuQwzkowLonZoykk2wtJoiobq979qiqDDHZRFANTaAWy2xvYm6HtQI6i4IOvv+FnYz2ybqkdQ0t2EVuVdx5dXLjHaNP3jad9uhCHX2x0CKTWZvhkeT0msXJ0crvb2yZFL0RMqUo4FHh5/5RwmbIqrpI89zhdzMhSisrzmqpjaMzBeydCCNjwvwFvgMYI7dsv0hEW1L4Q2AVPlj08AXdtg+b1YlSdVaQ9mjrt0SUrJbDhtLhfzXzvlQld7bI1kZSnCcktaPIzlB2ynyo6w6NaPspYtbYbT8JShzQlQ+xJNIjS5Y2t5mCbo8ftSmOxnP5mPa7zhWige/jg/hBAb6kZyTAq93GUAIYYA+krNCzFEH86+dzsRX1uzo
 Vh7wbOBQ
 Iu/LXqF+lrNU3od7MHo4Haw9tGd6DQ1Trkwh6AEgQrwt9zzsyIsI8VkKsSEd2Y1uHrilI2JhwBiCUrJqiXz8L6g4/9nyf2Vxbjc5T6bKGHMRDBnKvrZVhkfVb08A799bFfsoGCC4wCaWykfxKXwnWoU53/EEaVg07yyAev0z3UvTBLECNVWT/R0mnA+fog91LNtxWCx9Dp8v/6NcqjG2SNVmrZeYpJ3qQacHBYLv2Y2HIUkXKCirFoW68wy7VBVzzI9VWn8Kvoc8ko18XND7Ud+GvO0rnuZB8vEAUc51VmQEpHkUtPFMZhPrDpK9FP1dTDZD5tqFNkiCSp9oO6mTYHuSVtIRXlrwshTFmkId+ZuprmVIZdaHxAkRdO/EJIsmgsyS/5/VxFV2TVVsBdmoAGWERkUyH9RnWQJ5bUHLCIY/troy50XT/4WeLWi8irh+5WrSf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It will not matter if we occasionally get activation or deactivation
wrong; but a mistaken lazyfree (MADV_FREE) would likely cause dataloss.
So disable its batching while reworking the per-cpu fbatch handling,
then re-enable it with more thought afterwards.

Similarly disable mlock+munlock batching temporarily: they will need
some redesign before re-enabling. Just insert one disabling line for
now, leaving the rest of the code as it was, for consideration later.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-By: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/folio.c | 2 ++
 mm/mlock.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/mm/folio.c b/mm/folio.c
index ad6c64a4c22c..b9dc4f5e10a6 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -219,6 +219,8 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+			/* XXX Temporarily disable lazyfree batching */
+			fbatch == &cpu_fbatches.lru_lazyfree ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..929abeac85d0 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -255,6 +255,7 @@ void mlock_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
+	    true || /* XXX Temporarily disable mlock batching */
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
@@ -278,6 +279,7 @@ void mlock_new_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
+	    true || /* XXX Temporarily disable mlock_new batching */
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
@@ -299,6 +301,7 @@ void munlock_folio(struct folio *folio)
 	 */
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
+	    true || /* XXX Temporarily disable munlock batching */
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
-- 
2.51.0


