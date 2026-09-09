Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7603C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8336B008A; Wed,  9 Sep 2026 06:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9889A6B008C; Wed,  9 Sep 2026 06:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850E66B0093; Wed,  9 Sep 2026 06:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 553876B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:20:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9560160173
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:20:33 +0000 (UTC)
X-FDA: 85193829546.26.69A8B37
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 253B1C0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:20:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K9x2WEel;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K9x2WEel;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949232;
	b=n7BDWE5UnBS5oQ8HENk6YmveHxQzrfmFbDzieKHN/Fa4resDfCaQQ8cpX3zqopZ3cCBW5S
	9YVD8ZwBPrbY5QqQmUw6Rz4KlN8u8IOFbRmKXsVSg+Y3TTMCUP77/LL9jcdrSCtNjPHJzd
	3+eqExAF+6Q3UrZphlzcHFQrRNHrlCI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4U3+AfBAvn6B1ULZHKx9lvgAuWRYBVO83SclUxbDGr8=;
	b=LlLjsQBYX9AnEUlaE+EqkgCUI6hYAEnZlJ2Lrx1JR3MtMlPgTLKHl8abdwESZxtFpWM8zm
	YBjaao74OhjG/6uHdpDnV37hm3uPoQlTGnNPqAVcIZmn6ZibW2dapICrSa9UoqcGn2pPfy
	ZZ4Kj13UxQftDUhSQSSoR5JxQW3kOc8=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81ecf499af9so76211367b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788949231; x=1789554031; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4U3+AfBAvn6B1ULZHKx9lvgAuWRYBVO83SclUxbDGr8=;
        b=K9x2WEelVNqvBjnoUK37rpeNlpQ0ziU81x9Lm3XzF3x9t6l+VzGxIwte9i31AwqzCR
         8NCcJ+IEgEZ2nvqhXsTUrF/Eii5Ic2dViESy17fKprQsR5YSKWWhoJDKhtizzABYghkW
         1lZrIlEEAWA1gIcYj1z88KocH5+epgcq8AbuWNNGitKlY4otKc2cSIDsUo+0lFM/r/0g
         bkjlv016++qen9sUhVTae1ulPBzCVA18gti0YL5D5942moUZI+iwSXgpYCosj6YrvKWV
         dIWF2k7d18c/O9KzEENbmj2X7OLRPQc1CAufbicfBWXQIrxRZXQoRQwijO29py5WXkOv
         Aipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788949231; x=1789554031;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4U3+AfBAvn6B1ULZHKx9lvgAuWRYBVO83SclUxbDGr8=;
        b=o82u+w+IIzlQ5sXfjy1gIiTgOMhjkZZvDqjaxVM6uvpNk6dZpaKZZRkbjl+hcyfHET
         opELkvyoSdG8bK/m3N3LHXJMRD3KSAOqbrbnCsCUAlsxnezzyKda64ZzypRwvzs2MeA/
         Kia9+wjONk+TMU8D26mHuTEfsgu/ZhT4STCce9Ty35ZncFojjAyM+YcYex6Q9Xum0w4f
         iGGhbTUXTgv4ejGEvzRTQHVLK2+SepQW9THNwTm8s1vY71ECjD4buQ0im79p3dj3LhA1
         VA7Y7nqIzK0LXPIlJuzE5eUB6lL8/I3mO4C5wncEA1XHVCk02XLb1KeHcSLCBje2qfwm
         2Zog==
X-Forwarded-Encrypted: i=1; AKwUvBzFErULRwoaxRmhsAhqYv4Np+VUnWjlXdjjKRziZdHJvC7jjxS33/WPOjj4rk8YY6vYnHvpzC0lBQ==@kvack.org
X-Gm-Message-State: AFuF++mNmJ8Dpaz6GoXX0voSNAAms7rg/mt7YWDWS43mLAP+/6ErB7Tp
	SVpDWwlgjAfB5wg324VMfoR4qUjsPl+JA8krcWHtYVVL06UXVHpAV9ZB9ngx20GiTQ==
X-Gm-Gg: AYBFou3MjSFj0EzMcfwP+IW7s8RJUJKxglOA2sSKpZE0ofZQTGWhEFRxYHEdsMmQECz
	jIuYuQACA8Qd+RdepETsQ6N5YvqJvevrSFKIWsmFMDTbR5KPdjTNwrYqavs1T5WKfH6TIr8WVG0
	Ne7J7sNeREvK2u7s1+NNNgtSiskXNMpVXLIpPcIshtAZm6HFpFFMamZcn6EpsPiD6Wm/bjaFbvR
	zx0p7n8rtOLKGhRyxpMJrh02stJT1LC0T9z3C28o4n4zVFzbFQaE/MbR64CzYwKuPRuqWhN1tS+
	Qs+VEod7qe2AupZ67MookiTTG8H+5dHbc8fOkRFfcWGyuObWBoCQTW6JHAX9ThdLLmE8qHj+C9b
	qOzu2RFGA9GCl17q6nOdXHvavsBhEonBhveFx/aaRPKwYwm3aAWycHXHmVhtZ92dH8uiu5HA+BL
	chq76pdbC7CbG55ZRsDNRXlhgguObcEHMtxvsAaM2Y7DzLlPUO7kxwcGA3VG8ntcV6ZAJOM0h9w
	8DlxSn/Yj8My0L+2F46OCpMizauM9VlUz0HiL9S5d+fYK2B+fuISWq6REo=
X-Received: by 2002:a05:690c:e3ec:b0:877:e47:f399 with SMTP id 00721157ae682-8770e480a9bmr69779907b3.23.1788949230466;
        Wed, 09 Sep 2026 03:20:30 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714a0b6179sm106432667b3.23.2026.09.09.03.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:20:29 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:20:24 -0700 (PDT)
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
Subject: [PATCH v2 19/26] mm/fbatch: vm/stat_refresh include lru_add_drain()
 on each cpu
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <48e09d89-27d7-60cb-a0ef-d2a5ea74d90f@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 253B1C0005
X-Stat-Signature: bw3jdgpehg88n88dihccb4e7f4yi86tg
X-Rspamd-Server: rspam01
X-HE-Tag: 1788949232-689996
X-HE-Meta: U2FsdGVkX18hxgOWtpjv6OS6vhBjt7wwNdsc2dioAY5T0VvFKgcHV9VB6GPZ9xv3NN4DhHS2PXGaVa+6qaxI/qSP54LeWoiwe+AhFjdEUWJzLq/8xEKWUgRx2YfIGOhxjTnnWU8Ce8ylFwKMf5tpJU7rLZskn2l6V/tsMZPuBE7YZJ81rjVBao+X/LPCbm/s9VJOdLJuikU5K6tW/hFu9GkK+xuDUTCbU6eNXOsHfxx9DCu3gRyKImUl644eSQ8/QW4Ds4I4QDZhkyukbutjDDkTJSlE6RHRGNocbX+Dftxkg53zAjRkwkTQMW9bQXrOxUSgd6yoyD2NMP3ZqaS4wBoHyk9EXKDc+06tJgG5l6GbC7BJJEdJh5a7qOVu/sG1C5JTvOmNdp4TuvxBXD75ow0kfUib+gu3IWXBw4EvWifxRuTC8rjJ9ahjIaSjiFsc9Ht6RW52fLrzQLBVLtdnTSuPjendfsHYUg9pXtKc0v81zkoJ3wP8+2dK0Y17WLXH4GvwYbHYKVNUKSR4x1pDCLGDbkCMbBXhOgZA79KELFpiqYaptL5LGorUOdwrIbr3zCOqDuj3n7rC0B5llHW1A9Utv9pwgI8e90yttzsXDF21KHegRM5Cw2AFnjC8PlHE2bRiWc12PZROY6e+iF3YypcBeSPN3TDV0eKa9PDnFm5IPcWAcPi8EkMnMl9s025HAxNh/m5aNCC6WzCMkou7MlOKxe2pFWhW/7V15j7TTypG6C5WnhctmsRHBNtxrv3Qo+JrOYOYjUeGaAZzz07YgDxWVZiByOYDTP3q77CZcauTGWdrj0pYTaxDge8uDD7M5MdU1GO0oEEobHxgy2AntuT2znpK3/0g6a8R903k0zHLumMJq1dQmLS2X91MSulSyZGaoDUlb3HxrxkOwY3uv/WokRBxkODxlE1tmd5oU+OPNfqphMqns6p8dY5hvcxcehbO/Rf1idFFJEfqyNK
 kCpyAU5X
 I1IK0pHP072dxxAS0rUHxarvKHiMioNJGGY4g/tRzOEH8XiXCv1kiEnYM2Dd05atjjKvXvWKCG3tvqeWN6TA2uiFfk0WHNuhLR4c7axWahDJ1xNgcVxqELmb93Kw3rE6GTJf2uvl9iRslo1TRCtv6U3rwZu4IVjjilTfEZnSX50Xo+ngHmC+CURGEFnBpzjQDshHKcj4xbwHdB5PyO3LY5WaasY4s1XLo2bNLKX75SQKpOQ2SmcZzUFHlGjVYyY+Vn+ZFZMeI3W4MkH2y2+cfh1UqkbZoS1ndu0pbbLm0lIpkA4u+GeqAgA7n5LcEG+A0yBAPOkgG3CTWlJtfGbzq8HenNddAUAZ8rwRkm+JrVwjWNlnryAbKSoHyAOTFU+lavQNTrekDmYIuIBUvS8rcmL3bCB3BFZCyBrYHVq5SFhKSFuWMgQf6fOJgAOpVcrAPHipQLwUidIpqskZvYJQLYkfa1Wb4cJ7AS52q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading or writing /proc/sys/vm/stat_refresh has long been a way for
testing to force an immediate refresh of /proc/vmstat numbers: it seems
appropriate that it should also call lru_add_drain() on each cpu that it
visits, before collecting that processor's diffs.

Add that in refresh_vm_stats(). I wanted it in refresh_cpu_vm_stats(),
which would include it in the regular (default HZ) vmstat_update() too:
which might be a wise precaution when proposing to eliminate almost all
the old calls to lru_add_drain_all(). However, that would go against its
"strives to only access node local memory" cacheline care, and bring it
into lruvec lock contention: which would probably displease its authors.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/vmstat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index cb57714539fb..d66cb67f55ce 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1990,6 +1990,7 @@ static int vmstat_late_init_done;
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
 {
+	lru_add_drain();
 	refresh_cpu_vm_stats(true);
 }
 
-- 
2.51.0


