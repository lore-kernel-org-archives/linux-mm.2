Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB05C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DBA26B008A; Mon, 24 Aug 2026 10:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B31E6B0096; Mon, 24 Aug 2026 10:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9AB6B009F; Mon, 24 Aug 2026 10:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F305E6B008A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:41:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96B071A0170
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:41:56 +0000 (UTC)
X-FDA: 85136427432.21.6DE182A
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD27C40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:41:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZWSjRJnz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbn1aAX73v4jfLOAScY/xk2YxlfOe4UtWahA1Ug2y2k=;
	b=ZM0QFys0L4xysQoNgN8+FJfgyTk9ZmTfZLwh4cCERUvkDt0Auy64auUvTPIHntigZkIEnM
	otGPIPfqnRAoyG5nGtN4Ldnu6wFO9ym1c/BAgyVFGLqg3CtUFABhVIeRl/YgxGkmjxqdoL
	X7incrhiQf3ipav7NLb2GdVGJvNF/Cc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZWSjRJnz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582514;
	b=Ud/vbfnIutWZql9NBZm20aO4mUY6xl6T6Pq/1NTxcSGtZYm+8ns9LkMvRoXW4Im6QGPYGK
	LesyRjnB63guXXOLKd4U6XYVZBTJvfo6cZXLfXeHxAxH5t5JOPXvxyAnz+yBWrGYjWSKX0
	mBxrQCHxb0C2VIsFPgyz0brWTuVozJg=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6682259cae6so4336807d50.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582514; x=1788187314; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tbn1aAX73v4jfLOAScY/xk2YxlfOe4UtWahA1Ug2y2k=;
        b=ZWSjRJnzqovlTFboF3fuXeKtvM1enwqirtgmlIl9JBb65UIh5r4aFrsgpr2xSdRVtn
         8P+CgQtpX2SphoIH1sm2hR5G3BTm0+wql/gmr0qjBoiu/gA2O130rYnabIRwkyD9/hlB
         pcSn5pwQyslLnMSqcXvu1wXklUiSVTsErjeAdzJ3Ar+Z7/EyMMdT1w1j5VyfODZWg30D
         oVIsewACw3br7n90bNo6yTZhhkT01Lm7D8vWKzBgVHs9gpy5LCJ9D2HPAOWJnbqMTzl6
         n3wofF154yJUUJlSjTOzZVQ9KUu5zy1k6DkcxdhzKB+12k4YnBuJ4onRiMPn5QbuCp1z
         CJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582514; x=1788187314;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tbn1aAX73v4jfLOAScY/xk2YxlfOe4UtWahA1Ug2y2k=;
        b=mLd4sUbQhv/4OmW7s8XDrGrwbHhRDXk1qlNuReoXQWatXSzQxH/gdsttdqSGeJHtRX
         L7BptlrrzXgjH9hGTYwARgnH/B3Tvf1yUNtdzje/N/hEOrzTPLsdldIywPLuQfqXrMno
         eqk1eN7f4o5VVi/7kCrNfjmzcfgCdxPcNBj0FPS3S1pNP34y5n2iHPxGlxBK3HLpEUAr
         +aaM6XOFpM00zlBD44nDGdQgREX3lxcqohF71V1nx6CFAseHBrhPkRNeJD45gQnU4dGX
         WwC3XBSbcGzzLzO2Pd/O7SMnvZ0ay/XmadcA2dQKs27PG4vVecbFsznOpLZWzQsVJbYe
         naKQ==
X-Forwarded-Encrypted: i=1; AHgh+RpiHkRCqyWD8nJ6mq0t79/z8y+0vheOZ46kd3a9A3W0Qx478niUQYkQdUj4tUrJstm6UWcFEeZcxg==@kvack.org
X-Gm-Message-State: AFuF++mVd/owx6ZHsq21SuJDBqZrOwBRA4uVf0sjIGGpevkjq3Ypj1W5
	Hwd/rXWS840x5du6l4IbPuW7QOLCEDcR3y7PbfAKV2ZdNWMinF/g0gsUXoNA+9VW5Q==
X-Gm-Gg: AR+sD10FGwTMIrrfKKx5R8mgJgYSuqcHtf2nxq+Z2hL80qv1seVHi4wUJXzkP9NBLjQ
	Thx6/lC8t29wfyq6RfRspNZ8CUlLlMc9JGeQJV4dJroR5JBBct3G5J89GbpYNksr/I21xY5KaSp
	bDUkmfhPqaQ799gkiARlc04AaTYy2zgAXd0JUJNH31jk4UDYXU0MQzqlUL8SNhGV4vWq4gCcN5k
	uiqyhSGCk/CbaJuGlFusWZB6nIKDFm/pDqH3IHIMKXLPYoVRXBcnc+mlSN5V3M7ZyXWlWc2zqE4
	X9JK5GSiO7oGmuFz93t4O2SEm+aG3JFYcvVwSneAmY3Z5M6Su4RWSVeJqlaTjqnFl87jY5JrwBR
	WZuRGf3mXKs6zisq7aMnDKCwmj4WrtOFzq+9UAoA55Vyl6fy9E4o75VeyhPh2vImr9oAnAkHGZK
	WRbuy73oJamg52IEdK4a/9l/cqGat7EqGEdQRH35zIO+MPH49YcyLEl8QrGvqbT2Xnx8oDX/b5d
	CRH4+2xK7V3xSgf+V6KUUDE3pb1Y49l9oKyukbYmKj282AWKJovOFudOhU=
X-Received: by 2002:a05:690e:7b1:b0:667:cf87:5838 with SMTP id 956f58d0204a3-66cf222e93amr4903896d50.25.1787582512262;
        Mon, 24 Aug 2026 07:41:52 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84caabb8b35sm34455727b3.27.2026.08.24.07.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:41:51 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:41:46 -0700 (PDT)
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
Subject: [PATCH 21/25] block/fbatch: no lru_add_drain_all() in
 invalidate_bdev()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <8facb079-aa8a-2973-4882-173e7d06ac07@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: CD27C40008
X-Stat-Signature: g6ba4k8oe4chq16skgzz6ssqt9tm5htn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787582514-657453
X-HE-Meta: U2FsdGVkX19uPF4rtMcBdttjk17TYXWCssM9bECn5jyhQ74Ih6/hsq/tG+ryK2Ft5ziF2K8ZrrQ5b7zR0nyr4Drf8nvwy0WxgT65Wi9joMguRselMbYv7cT1/TagelMOUoUsgnpl5IOkN4FI4yWwa/97AmmEVaS2W116gBvZK7WmbngOpHJzmfl0DlVH/7UIqgFbW1VzQPmqWo/dF86hgo0FH0bXSPTHQzB2SWc5mrY84O5V6dXFHQWkCybl8LAuhIpYxxtu+PcQy6WkGSX181Zh2HkyOMBamSj0IsaXB3LwTiomdGGSlEX0mlJlOv9j2/2lYZD2VAGchlilU/ieBO4c3oX1KqRyBn9yZfPGZQpNmouzsVLNHcgy3mhELtTGKINoP32km7xR614rK8TSLR7JTA/w92zl6jcqC7XzZ7MQ0aDF0TOcvu2gPiZwFWbJLPZsYUfTdfnTMa6/5gyECdgKDgQfMR3Zh9bgzGnYlD1zvXkOJnDcFXBGxP5q+c9HCglKtMut9gW0LAAAUa/pahVnTNfH2jP814zo3rrsj3/Cn5LZ5MXP3Jgc8jIjgWqdBS8oPT30gVSYPxubPg+lskWZHBrfxnX+sup/8Y8KxXsRdIJugiLe2jzIQJCU2q0+zTrSEImB/AoYLwnH4HfTOs4zVo7JST2FfUbz6rznTNivz0tM9rXNTiYNb362z1wq2mhxjeZJiv7LY4VvTsQxOWaBrBigw+4ccV58ihpuSaTmqUJwlZ4PuMb4H+A6Fq8amPql3EHUIvMc1zoDzFJ6C+5CdkMhPWPq/ECN1YaNI9PxN9QXHA16bW7BNxSvfjVkNa+/XmOyCe+8qA/L0ZlUj7XrP7NpddPsphlu/YnfPVJIfvZIi5CC1sSBnMXlyMwUdzePkj3MO+Gmsr69IxQK7se3+5IYTJbxJef15uMNb+WxNxbKcMr8ehdmjmGBFIAqlNfUoCbrZXEUhNRrDZW
 VB31tWIz
 3wFFUAKbBhmqye0WxeL1OZqWnp79NyXrcZDWpP3O+yTA5Wt27JKR49mcIBxenvwAh+lEUXIHPkzLuWPhqq2qnzj0CpRrQZnBL5+44z0AsEmNd8RE163VzKubENAY8uNfIf1e5HhCX/HJXluhnI2iPS+UX1palUH2EKcpetTNppsVDCto1NVJ3UOE/oUNJcrdb6SRU2Okddzg7ed3glqqunkvDWbEtAE1mFB32vfolZbKvUD8+TNILPulY6V577N2xM+HXFAsotybKT31SmHOf52XNGV1qy8FC1MzJ0GfSpsWrO0V5AUl5r/IlMQhHdqmC3r8RnTgNWUwW+ksjtkbF6MMNRuvqG/1r00FqDpCVUl7oyWFsnzgBh8N0T2KokoSPsew9KVCkHAGKTLgMqlxlcg1O3si99ChRX+8kewwATmhkHhrVpI+/rnruGLiKDKuUSpdGOHckLDl2caPT2FwfpLighQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

invalidate_bdev() has no good reason to lru_add_drain_all(), now that the
per-cpu fbatch references are gone; but keep doing invalidate_bh_lrus().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 block/bdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..853545b29b7f 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -97,7 +97,6 @@ void invalidate_bdev(struct block_device *bdev)
 
 	if (mapping->nrpages) {
 		invalidate_bh_lrus();
-		lru_add_drain_all();	/* make sure all lru add caches are flushed */
 		invalidate_mapping_pages(mapping, 0, -1);
 	}
 }
-- 
2.51.0


