Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68000C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8670E6B009B; Mon, 24 Aug 2026 09:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83EEE6B009D; Mon, 24 Aug 2026 09:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DA96B00A3; Mon, 24 Aug 2026 09:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49B626B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:59:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8D16140125
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:59:02 +0000 (UTC)
X-FDA: 85136319324.11.D57E837
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 14D8218000D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:59:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hL8+sDkG;
	spf=pass (imf24.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DePtEtd6bTjy8gbPPUEJydq7WmfU3cohWIB8nVvJ4g=;
	b=SdPteKGlqPHgE0n+wDUj38PNfr6voT+ya44WBJkCDqymSbym7AlJ6dD8BuBMGlk4UMNaXO
	jeV1iwNouPPTT+kvrGvYc2aArSlJ2Ds39ApRrSMBelB7soBapb2i7M4IZjUPGV9KzYdtbl
	L4hzUGgk9jnty5ad73kdqWXuZ/TbPMY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hL8+sDkG;
	spf=pass (imf24.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787579941;
	b=WeNdlO2tCXRu0DYkSB1C8J+hXgkyVazGbZiwv8s7K+/qA2PYhXWCVuV3zGDabvQCT7TkEp
	PLv6wWBfHAsGHuzO7Q/D36PQkXZryCMrErjrNpK7rVzsQDf4ymYF/F/6NoSlxAz6ccdUUS
	BO9apWZmR/gEdb42BHe6NfSmmWG6tG4=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-66d110aaa7cso227950d50.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787579940; x=1788184740; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8DePtEtd6bTjy8gbPPUEJydq7WmfU3cohWIB8nVvJ4g=;
        b=hL8+sDkGdHYoWOZoqDfQbRICIPC5RAw36Q/BGxBKf0qvL52AnTMoC4/6wP3AXItXkH
         QjqPh/dSbpeZWMJCBkIxUo/JwI4CN0Cd3e6aqfZlvqctz74KxXaMmx5aDvdoBVUeK29q
         UGKphKmxmnfUR3cZmhz6nBttPD7GL18hG0b0c7WeJ4pObSncjS6TYi0pRUbOK75Ha8qK
         FuVePFtToT2bcj1QLK83KxHgdEFGNaWO2VneKesxbQ2BfySzgqvSIqFlPeUCuLPF0WDi
         f/3tmDpxCjWSxjT+aJM/hYbWEeru2f+HExyOac/kIBJaq7ofuHZS3FwlSz1MFoNXjyQJ
         OxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787579940; x=1788184740;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8DePtEtd6bTjy8gbPPUEJydq7WmfU3cohWIB8nVvJ4g=;
        b=b4aacu5vgGi8ndUPUCUtlt0Dpqbbx9zCn7wTS15wP6onvwq+EnOJ2fGHB7zoC/TcWR
         7lu78/NiqOijmgQhCClIj4CdxH7hWDspcgH2VzsOQaWtNgiuM8Ho8Rd4bRB92n8yGH5o
         TzhCq2vcfdVoWpF4v16YupHMjNiFlI1ukMBMCQO1WlFRuHqSWXSyo4nPh1ODsNqw/1V8
         P9i8sAlqDY66gfeQ9jv/HhyS4wIqHHYhJOCpsWLUQmbeC/MTqBUG7WwV3eoxznQaZkKN
         J0TFTLEa2T26urUcwpcD7GK9OTIT+bQOOb10tBnpyW+xweWyS4C2K2s5AGVQuCNwMr0/
         VYlA==
X-Forwarded-Encrypted: i=1; AHgh+RrsP4iv8Em0pjq76Feym8fDF0CussEPbqsj0FCyQVN8vDfNo6gRreHnPyQyPtFvb3ngVx3RkupxaQ==@kvack.org
X-Gm-Message-State: AFuF++n1hMPSrYRIyhBpTQ6xoHkurdJ+FqcPxizmPXrnHuWK1AXlNxyC
	qM6MB9BSsJHMboRMpui5E5mF0kZAW4Our9500mwRc10WITPO/Ay9Ck701w7NUb0HKQ==
X-Gm-Gg: AR+sD13+kNZagspLYTndJA9K8PZmDukdG//8FZ/E6w+vG3vPiGflkNDWKB/ayjJQY37
	FmPlDkX1YQ3iREIufojrkT7rIN/BAzrdk4RcIEJNTLIzQImq1kUAIaWyHWWPW8+xBAGtGxytjYB
	wy9CgaTJPiielUjmdV2L6y5CR/h9gWDDMfmP+aV/xuz4QpZ+NxerVTi6QT9FPgLj9GlMNdnnD2z
	D22tDT9t1Caya3s1JtCzdRXwD9P17UieVUqrGx3d5ZgU31UVIax37h1Eys65EOo+JEabj2wMiZA
	/SZZA6GRumJlfeppLbC9A3UvYL46KfTMw5GAlcqEbGWZ+DqlwHvnJ/XxZYdVeOrevDeNI4Y8itf
	GnUo8QYDSO+b+dPhHRP0ohJUD7yuRa1xLFAT2H0QYlla4WTpOju7HECBL3dE/EG3ajXawpJCCMX
	Z9mi7rq8OMJgy9Q9MAOuEHIITRECjkVYIv4i6+3J7PRj7KDG7jkmTHLJvfDTqQSUcEhVkp87eJh
	JyLzHmjimc+LXQTrXdc7NYIPswtGziuaoPkWUHcVqD2BTEu5WbvT96pKC8=
X-Received: by 2002:a53:ac9c:0:b0:66c:fb45:77e2 with SMTP id 956f58d0204a3-66cfb457872mr3574386d50.28.1787579939500;
        Mon, 24 Aug 2026 06:58:59 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84ca68c1b14sm34163727b3.21.2026.08.24.06.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:58:58 -0700 (PDT)
Date: Mon, 24 Aug 2026 06:58:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
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
Subject: [PATCH 03/25] mm/fbatch: temporarily disable lazyfree and mlock+munlock
 batching
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <9593975e-8732-999a-73d1-37fd332eb840@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: t9mwrmednj45qs1x4anx1kn56jtj98kf
X-Rspamd-Queue-Id: 14D8218000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787579940-971035
X-HE-Meta: U2FsdGVkX189s6hbZYpfPf9HGcLb82Jg3uY8/C9kX/bskbh5+e1ckFnxmvmrIDwEoMaIaV2WRle6iv0jounQQ0jqsNJ09NVA7s32wW4sYXr9RJ4BbwW2eUK8GwCCA4kJfU0xLDc0IwYcCkkCTNeolP5fesrbKJUruPdFrtpp15GzbfuoTNm0BtRwGV7HzHByilVTbhowtJLxh/oceqU2/dgf1ANDQIDLqUuGsvp63YaaUJen1a4swqAdSAtTaK70jAkVdHw1bZj5xFy3LPUrFv4ztkbXnH7vAFq2TiMQLuSuGopsiGRIc9m6h29X2ZZD0MaJm9h6e5rPPHhK/fDM3MpNLjHxAUO7EEJHztLw7yjYOKCT59nhMN4M8IqgkZLflloWtH2+RaUDzgCtQfQnE1DPOw+LnJGcupXKU1hxVByHCsZ6zta9w7UNWxymv1ue6HAbmMXCuro6HvdXczvF9htLmT2uvCPjpI64hElvPSbk+n9rHyQLOgwqrHDT1bU8grOEuB4rlhAu0jydE+bYZUlRzcbXBCKYKx40FZQSoPOa13ylP78qWkGFh0lpqUCWuIqXH6YrX9PDwCU5yCqawtBkM5JBpbv1F+pCUtYgujdkEecPBz6M1RGgfevx8SfZT7rpxWaBFFosSERXynEzctxEbyJ63pq14m6MxrEnAjC6l0Pg3z7ygFT0Lm0VMglc2e4in/rXdduoF8IK0Ruber+OUq6dB248beEP0BI083Cd6fF1xGoKMlnxrbAFqvg2odZ2sfUiKMsT9qvBif8O7wwJnquD0apPSRU7hVx03Dg5IU7Zhmi6RHK5muA6cU7tkwUHhK9QfTGHc4fz13cbWTjFuN/SGxU8dJP8t6bNwwJgVbZTN9RGreVDPJyqmzThfahS4D14HzmO7EWqCrQMLY3mZbmpJpuDE+/+GHM3jYTmycBFe2MsnVredsOz//6FLFz6yj0OrSfnjiX3VlB
 PPLl+ERI
 D19qURE5wZL1GYWqFaEOc3rcmTH34HSP0cL+O+FbmW3t2/Q75TFxnBXW0GQphuW/A+ZECVw21tNATOBEQPrXMr06xcVAhvuAZI2eD+Cf7RLy9rjND13QJBJwRs4Rj64Ur06+GzGImg4iwfR3ECwy396gsmFqZZlwluZ92kkT4lOpfA/NDNYGgfNNu6G7sM07E0hfPeThNBWidDYXaY4hLyF9hSBYHG2WX+liv14bqvE7zc8kahQvLPQMNqOuTcp0IN5VmjeKJg4b+hQGhT0/1cYfXBA74H58ebJ2QQggNa3Cr+K5CzukVGz16k2CZoDCENKd1R/zwFQVzvX+8hRFPHzWdY9m4nNUiGSIvviSdLAVDpCg9hGkcJ/4NmAWPs1rawq9mglzgBb7ld4Txisf/tablhTe8LxQ3+ZWxPLXM6vou4Kk=
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
---
 mm/folio.c | 2 ++
 mm/mlock.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/mm/folio.c b/mm/folio.c
index b2bce6b77498..a7010ae3edff 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -218,6 +218,8 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+			/* XXX Temporarily disable lazyfree batching */
+			fbatch == &cpu_fbatches.lru_lazyfree ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfb..14c02e155d68 100644
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


