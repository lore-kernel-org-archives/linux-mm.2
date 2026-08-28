Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 755DAC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 22:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECDC6B0088; Fri, 28 Aug 2026 18:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DF56B008A; Fri, 28 Aug 2026 18:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DD26B008C; Fri, 28 Aug 2026 18:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00C256B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:02:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FA6D1A0594
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:02:49 +0000 (UTC)
X-FDA: 85152053658.23.0C1CB2F
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id A7B1C80007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:02:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a9sej2fw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787954567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wA8fy7HWE3V3WB6sMl8dDfF3ITuMIwqNn0Xomqm4doc=;
	b=23MlJzr0iuNlBdpu8i+pKWD7158PxbXyfR7+dMSzQExe3qoYUX78pY/Wl0DRFbyTxLU3fJ
	fNmcTErZZ9A2bVK9nBA0J9kjOWHkNq+2tz+mAqqxuE7cqcbaJjGTGW7xPOkbLcPb7QS2fJ
	JePvhWOV7Fg/Qj8s5aDYlmjC8PjHehc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a9sej2fw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787954567;
	b=OYVHmd1ymFx+mt5ryhrAyB/UQIoBsxExNOGpjmMeZlgE1kPNJKSTRrVgQYu8Rcpc4FwoJU
	x5z4aHbm596aGwjVp72Gc7N6JQ9HJmm05Oxed2NqZsKBaIwca6xY1e4mRna45FeYAdl+P0
	NObjVDvznl21TKkobkf5P+W9ClA5bik=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-836cbcd0a48so24385047b3.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787954567; x=1788559367; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wA8fy7HWE3V3WB6sMl8dDfF3ITuMIwqNn0Xomqm4doc=;
        b=a9sej2fwhnv1xQNODNa+etHmSOMhhtRXOkBRAfA5ummXEe6og5MrqRcyUxsmXdn8N4
         QC40v1O9DVtp6oUMXrXfYkBC25EmtX3gbHWLsDsbnN2CkSjI7tWHO+r2EkltwOlqT6XT
         3ZIYTIeS4PFIDZxTAQjtvTW9O7vDqTXPsnp9s9ccn5W1UM7uX9KczKYHl2KloeXHjz8/
         0hY6qIAAeOMTUmrmJ+A++lZ/7fWjAdA7j73qHNpnpSnQXfOH/qUUppG+JQrWeFfK0dFC
         quwMjZfkmHyQB+s5IY9wk7812HQzRXeVRoaywHRAiKOnNVfRUHFXZWRLh1As+uTmVgFk
         MOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787954567; x=1788559367;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wA8fy7HWE3V3WB6sMl8dDfF3ITuMIwqNn0Xomqm4doc=;
        b=mPzWhzlaT6kgBmI/z398I3XYrJ+P/LNjSTok72BE41otHJP454yu1q9k3/Wb+KMrLe
         IqcBFlPPuM5ONR8qlUmgJewQGAQNSFdJNY16f7XYe727RnSjFyhXs8Iu7WARUPvtaJei
         Z29G8dpm5hFIRVG2ITypliKaJ50Qi5o76XHmYYRZVC4hmgrYkCpdaBc7+dBnkKcxr0qy
         Lnv8AXcsAKNRkTre5RUSegzAM5GhpbNbjsjZ2FQEyfIDTepNjtqGn0RAXp9omq4ag8Kj
         wHPkGpJJ4CA6+fo/5eL0G8fcrZorJYysLcqeVaYsVY4Vb4t5GhM3yapuUsalgbyEs/ol
         +d0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxdgSQk3mZS6rGQyGj+kqWV5IRfVIJggdKcAPJVj4YDgzjm45NP65g+s8J5yhwb7EyqXj73GUIHRw==@kvack.org
X-Gm-Message-State: AFuF++mbOnyUz/hIc8tHp99qtG9MbOmuCo6CFYyVik1rvbswQGxkYtxr
	FpilW+UAAnv2VZp1ng2EsQ+66GKBk8Ey6+Bhiar/S6O3SCDSOTnJjoEMLWEE/Wmk3w==
X-Gm-Gg: AYBFou2uOCjLenq71oZ+tFmcNdqbXJ7N5JPd8r4IcoGNVOYBzIMd9+kvvXq48IVxlnX
	Suh/GaOwmPSsS8TUM686xDgPJNmdWv7Z+shkDOn0h3w0HpDdLmsXGGxtZiQBPp2C1KDTp5W8FWc
	bNMuI27EB/FG7QTguaNGJdafbbCmflVQE6OEYSnCyjvsjhGDZWiG9zqqlwu2rntqjbKlItLDdho
	6NkyWXW9+0zSlDGjVZHkzNwibfEa3SMdSeHYUSo6UsEhjV9DRTjgNZgb7mTfrP4N8KxDrIRB8k8
	4t04Pv1F4ECiCuQ/WfV+jOAZ2AS14zpQ4Xgm5pC9+Br7LAUGycSD09+mOZ2Pi87d3MyQbstk0ob
	YLNG0ovq89Ery+FAo6cQJnbIhGrbm4+YMOBi3j2dv984pPyDWMR+CERwksQ05GuRSSV+MHDufTS
	3YzJkXJ1gmMYQnfWbtUb2+It3e7RAZRiTkTt+ys1nBBD2iwRv+WoI+1e8uCFK0eFnw9NpoRAuFm
	wA5n9NPLxMeBC7Xw/+mSxjYkVSa/sxtCSADgx2dKWlOxWPO
X-Received: by 2002:a05:690c:692:b0:84c:6169:49f4 with SMTP id 00721157ae682-85d6a3d835emr43441127b3.19.1787954565878;
        Fri, 28 Aug 2026 15:02:45 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e66abaf31sm12814067b3.35.2026.08.28.15.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 15:02:45 -0700 (PDT)
Date: Fri, 28 Aug 2026 15:02:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, David Hildenbrand <david@kernel.org>, 
    JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>, 
    Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
    Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
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
Subject: Re: [PATCH 20/25] s390/fbatch: no lru_add_drain_all() in
 s390_wiggle_split_folio()
In-Reply-To: <20260828170217.324c3445@p-imbrenda>
Message-ID: <ef4081a0-908d-bdad-4e6a-91c4c8b20130@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <7bf68e7b-f88c-6ca9-39ab-e9fedab0c8be@google.com> <20260826155722.0198d3ce@p-imbrenda> <2319f670-fe0b-f032-c0dc-486cbec0f3e1@google.com> <20260827145502.2fb4505b@p-imbrenda>
 <cdbaa4ff-d2b3-34bf-dd41-01fdc65edebe@google.com> <20260828170217.324c3445@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 891q8hkyjg34szn8ui6knngyt7y79x87
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A7B1C80007
X-Rspam-User: 
X-HE-Tag: 1787954567-993739
X-HE-Meta: U2FsdGVkX1/ck4xOJvse4TJ/oRFzY0A4VcyDmk/v6OwRWqzz/WObpK51j53laLmK8hCl9N1kvo+rX0YrcyMWUAxuTOpy/sG14w6yx3siQAP0faECt4sWnHzoKI6amaPrmU8uqGefo9L2mx+94fg3ZmdyKvAQBVUDZ4QsKcs/fq/jiQyeFBkHPEeIb/wAJLN6s2WFFz/3oKkkBkIH/Xi4nYLiarxK1yBY4kq+SuuqzZKQwRH4sgxD/ygMN/FxLHu8tg375m1LQca3wJtscFzvIDBRTCAbB2x25evPGRqr5ZScwbMBOfk/AqD4NqEnfuED2aSytxSefJjXRfLrS5m7zV0NaR7+4bal1InoarSPb1QDamA57IftgwsOqczpZJfk4d6VozcOnptTCi5AUPvcW50UbstB1wEHZRuXOX3V9a12IJaP6qodLsYDmzjvv1q1WZvv1tSjgwCb0ukswBREL6Qfk/zF83pffjDQJW6QPiBhahMLUBhyrrQYS329I8AYHntqbUJuHifgFt+C12LAzIDo5Gu62bNBIArNWR7n2UEhNYmzXGf5PCnQXX6wEAcVqGApwOL+4e4ZG7zy+OalZ5s3BAL68HXOtd3mMVV9+ecudjZykI2HkhAYO4VAvj49Hx0+72+DrSO0n0ooRCHEWCXRv9aT4YzXDPRvkmqY+bvdkSPcHqf5pgygBp/MhFFGEsdycn1jVyb1526abJ7QYVc4z2jZ58jCEY2HL0mQ3Hl6TGIGndBodn/qf7/P45d+fwK7ztN79/kLlLm9E4LSNoKjFDVPsA4Lf3Uesn8wkdeVZDbEFVE0QqcmBLUwCV9ylgNwAlygOXKlACBYZn8n1eGUImD6jc6l2KTpkOUGzOrIFQXxo6WjuCTT5P0DXWKDQpY88m/WLMbbyxuCz1uWI6n+oxjv4OPNu+FvTFLxP2XSvpc25tHIso5zIZ99tbKICl2FHE2ZQ2Xz6Aafjvq
 1PtCdz6t
 Cj4wHxS4rbqImlj00WUZC1bjA4AaAAYkfrvMjIm5zLqpvG3gB4hxX1jvJxF4A+3deXRwjIVqbLRya263MNe5eHcs0tBTVH/rMwVO4w6M2bPMUVDYYOGiv7KFodsS3gfwrJKfBDQBbhuQxYef8rUz/MOwTL5FrYmb/Zms8/rd/xu3GjWECNqmSvMVYbI3UulQ2mP538j0VAmQ7j5LyOgZwLGTB8XIdxKv7dkDEXsZAQXn0oN1OXofQnepznXkJ1cf9CYdP2k7xOEvXtTm8j+AfrDWfuI1qcyiFvAFyF0E1i2XtNx0PJ05jcXJm+cSe06fHpQc9/dBVcftv5WKZaDOEw4D9JuX0xkLfB1Pzf7DagP50G/cIXu2FxQ+gmtmYarFI4kCp0WgmYIGnr+bn/P5v5iTKSGH+ozIOui7J2UrhH+4568T8qZ61QHTmq0DsZkHYZJ/2oDyHBIM7CJyEDskUMrTVz4BHhcX7qoXUM1KJf8jQapo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026, Claudio Imbrenda wrote:
...
> 
> so if I understand correctly, with this series the LRU caches
> will never hold extra references (as in refcount) on pages anymore,
> therefore calling lru_add_drain_all() will never decrease the refcount
> on any of the pages that are in any of the LRU caches

You understand correctly.

Though just before hitting send, I remembered one further detail.

lru_add_drain_all() also invalidates the buffer_head cache on each CPU:
entirely unrelated to mm's fbatches and LRUs, if I understand correctly
it's a genuine LRU cache of blockdev buffer_heads very useful to some
filessystems (e.g. for quick superblock access), which prevent the pages
(folios?) they are attached to from being freed while attached.

My understanding is very poor. but from glancing at the folio-oriented
kvm_s390_pv_make_secure(), I'll guess that you have no need for that
aspect of lru_add_drain_all(). But if you think that you do, then
we can replace your lru_add_drain_all() by an invalidate_bh_lrus()
(like 22/25 does to drop_caches).

> 
> in that case the lru drain can indeed go

Thanks for confirming - but please reconfirm in the light of those
buffer_heads.

Hugh

