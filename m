Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 773C1CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5216B00C8; Tue, 12 May 2026 17:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB70C6B00CA; Tue, 12 May 2026 17:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5DA6B00CB; Tue, 12 May 2026 17:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4286B00C8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BDACC21B6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:31 +0000 (UTC)
X-FDA: 84760003902.06.8207C7B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20D28A0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dTIiO68L;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91FyDo4lvxPgkiSt2vN5y4yAYQZnqJbtxElmqdOrkw4=;
	b=tlvzNKIMDsbp2QVajaylV1vB6tpodT4C7C5Vk72436BhntfUBKYWwSbrdGJvhdCpFIvY6+
	GnKkC/rmFGcD3Z7qxHhaNjkvY1BtG+yTSKzN21u3sRB+KnxRLJ4Qn/5cDvojB31w3gits5
	Rsv+KiXJwJGo2HpcjTy4+khQtyxAxN4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dTIiO68L;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620049; a=rsa-sha256;
	cv=none;
	b=D4wrORGgmRlL3OabAlgjiSl7kK+cWSGBxHmw22UmiC5EhVPuHtwlxaZTW1o1ORPNjfL4+b
	HfrYUmmSvgxFE5ARBehWwvkoEhSUpk+6sP2+Qx/PGHkGJanynpWBhAlTlFo20sv+4QDb9l
	Ifgy0u1O/KQBABYKrizm6tmZ4v8cXOU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91FyDo4lvxPgkiSt2vN5y4yAYQZnqJbtxElmqdOrkw4=;
	b=dTIiO68L9uFJr3EIx+YbJjGv3Ps9krBg7fIzG46hPi0VpuzOkyb2ZfotTQ6MsVnuJn4D5Z
	Xgap/2sFm/UFiSvSnyQPdpfoLOR8qB0ijcv+qOJJAULQ/30eJ6JGqdHk9Zi1EZ5CiPxEEB
	LABrUz072AGuB1yBP/lS/3FPrji/HUQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-VZfhXdDgPtWsNSgyoMLpaA-1; Tue, 12 May 2026 17:07:27 -0400
X-MC-Unique: VZfhXdDgPtWsNSgyoMLpaA-1
X-Mimecast-MFC-AGG-ID: VZfhXdDgPtWsNSgyoMLpaA_1778620046
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48fc9084562so3485585e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620046; x=1779224846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91FyDo4lvxPgkiSt2vN5y4yAYQZnqJbtxElmqdOrkw4=;
        b=oMz/nfxGZs+hAjZEpFvsXfDf4YKiaX/XZWZcRbvYrLrDN+XaDbd0rizm/3szYdo8TR
         tTqNKZMST34mSX5+o84RdnSZIrMdhpvxv7HARrIuC+c3AiMcJivfn7UFdt+SbrTDfVRa
         FpZ8uYoAj01astZdzyy99nL3mUvS23WouJlR4jSpe7ZtYixuSMYf3J0GKN3vF78PmrXi
         PkQYhISMdzEbURjnwzqeoiRkcc9s4uyhG7gjwLJWv2DBJcRUMD5RMZNh6OjxIwH/3Mq6
         Eg6+y1DmBntBgOwb0dJzZttOM4f0OELolDR4zz8hhgsRBsdTveAF/zHecDFVkzaAS2xZ
         EE+Q==
X-Forwarded-Encrypted: i=1; AFNElJ94pe11L8EraGp7QWen9Juw1jRXWuzu/HX2ZGJB9nymTqlz4nfOn+CnxuurcsdLs8nS61ibv9fmAQ==@kvack.org
X-Gm-Message-State: AOJu0YxaggwMMxO6+PWecWdeXsxYza25mxcSdPdJfo11DmmGnLmLDJO0
	VfvKu+puAqA8mmH0UjSRaXvLlmE4rsLxVKxG6s5zR48GWjohYG/Z3DdkHZriSM8zpKuiVEMhkes
	VPwD75RT2Jg5f57Y0w+pSiJFApqjuKmHifUwfoxxjuIM0scjvyil7
X-Gm-Gg: Acq92OEzCFRbi4iLkI8/YKoGe8s4m9INY7/Ea7O7ntk2Vf1lWO64GBWbinx2FJ1g/SQ
	rljP4e3sFL+4Awnru+WMcutGQS7nj2U5zNokAKYnbgHhlPbwXgsmjVfNJQz5YuA0XSr5zEPnsA6
	LpRbp59BK1epRNIkRITNhSSXuhXukVhh22b2d+l+HKyIOimKA6Xfnr8jXUsu/5rRTiJw8kkithh
	9LVrwAfzidI6fzQ3itVx61HAVPRqPwu640tzMrkvadwtVsykKGRwAYmSWY36op7Ys4NmWBLltlY
	tBGzV7QmFRQ41JXUqcvpBiurigBKODK5BX1J0ox0Y/M6Dhyc+WsrAQx22Es8Oh96GpPwUmQe7Lg
	hNLL9KYTLtiKZddu0pWoaCOJ4ptMSeIbEqSI8DLeQ
X-Received: by 2002:a05:600c:3b19:b0:48e:8dec:19ad with SMTP id 5b1f17b1804b1-48fc9a11b29mr6569875e9.12.1778620046112;
        Tue, 12 May 2026 14:07:26 -0700 (PDT)
X-Received: by 2002:a05:600c:3b19:b0:48e:8dec:19ad with SMTP id 5b1f17b1804b1-48fc9a11b29mr6569415e9.12.1778620045558;
        Tue, 12 May 2026 14:07:25 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4549120eb95sm34339020f8f.20.2026.05.12.14.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:25 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v7 25/31] mm: page_alloc: propagate PG_zeroed in
 split_large_buddy
Message-ID: <2db0d124c647e711c0bf95b1c7f1316a0d1408ae.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hmmcLhAVogMOqWsgIE71DiOXRWuR6ANQP18NvKqNoNE_1778620046
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20D28A0002
X-Rspam-User: 
X-Stat-Signature: 3ok3qszrbx1enqsca9rqrpmymgtdonwb
X-HE-Tag: 1778620048-21156
X-HE-Meta: U2FsdGVkX18G54JyVZKZyw70O98EchbtCpTHZJnPWs7l6UGzR1y7Azbkzm5KmPTwRAdn5Spg1mTbWOzadQKHxb+srkMgqmPOXSDkkK6zHfFSPFVLi3VZvfdXHzmnaDte1YwePtSyst0fcgUcFXrdECD5rJCETpt0psMEqx71xpORS2Oj6QJEa8MCsKWXDUq5V6yEVbLYJrENPPlLdsa/eQZa/Etn7fUANDk8wPF3nNVPx9cl2w196pHbOv6WQxzuIEtc/B/c3uoIfU/3Z8/+lP0hrc1iLEK/PyT7TfzZcKdg0Cm3CWb7lL/G/sWcwo8jCEIOdmqTK2+W8Fwz++na1kXLXJsZZUPx5e68yOYTpJWCNkijcdi2ViNx0O/VBOViwRK1Tx8j4nRPKVzuRbwPCAlpgae/Mvi0AusLW5DniXJkbml9vRTj6Fy3fb7TssCPzo6DRX3dLEFJkONXUHfr9LTzPfx2u30u4qefc9Asrz4hXMWVTs0n58PXP5zGHnqNqAsNEit8wWqiJ+ztp3u7HeCK5Xlc8fgEkHol8TxQ1IweHqXfjBX8HuXnkmNMzSclZSmiKWKFxEJGBw2zvgaa22kAu5ZlxXnYnXM396SAktO2oWcUAKcgLdqiEHxdIoVcK7/dez97B1VqdTmCiRzlREzIg6ef/ASlPXr6y4479PFNU3MqeP7dQNwhgB9ChDsLRd7C7CwdDKUftqY9Vkvvs6dp76iiacnIlN69ReYJS4Cu0yHDVMRts3IBn0C7ScTajBccMNEwIuIVUd9EWMnR2HVND1YNSuSwnO+CUEBPy2Xzi9Y+YyVPHDgaaUfBNKRRyfF5T5fEK0ns4I4srGAvN+QOBdAHTLKAg29gBO33060v1ArSKXs6G+ntsSccrMn5CCLT65RtYmgGRd4zYPX+Uvxv/3AN3JakYhIx3ROEYGkkjDGZemr2UKEqAf+E5+xtB5kYFrGmSVoMn5RgD4J
 ow3kY8Kb
 hq/dsLFxfPpczxi+MqbXZJn7wr0wgHHSLH53wwu2q5ewn53stZYNX76y7sZk8ND8Y9yNxajtm9gMNt0UHlJO6/sOY5iW7gbogC0v01ld4sVJlrOE+UvSQsxfc+FV7jZ1OphzvsWjLX0St4r++RFRHD45xPElDc9VGQE0BD8UPXB7QsWbNwKdZoGDRsIQOXSvRGz62wwh6Cdx2FVGoya43ZAkyRFGlxBthhCFIWZ+rXyxJ35ulNRtXZTGjXXMoNU+4vnMzJUT0MV/aWX8bfzAUHVlwSrLGj0tOWfcg72nnPcZv88Mz7f0oaK8E2AC8XvXFeMwRpYS7kippUv1D7JYg417/lBqShNPb3wSMWy0Xs2vbGGs699UhHxpnIXsil8ELiiHAocecOw1/9OHHWuNmZUUXxw4r/ieKmwxIvFqu39WJtlQ4vAuKJLTYtKFjD2zncxQ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a large buddy page, propagate the PG_zeroed flag
to each sub-page before freeing it.  __free_pages_prepare clears
all flags (including PG_zeroed), so the flag must be re-set on
each fragment after the split.  This ensures that the buddy merge
logic can see PG_zeroed on pages that were part of a larger
zeroed block.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 468e8bde7d34..ce43f5a3dbaa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1523,6 +1523,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 			      unsigned long pfn, int order, fpi_t fpi)
 {
 	unsigned long end = pfn + (1 << order);
+	bool zeroed = PageZeroed(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1534,6 +1535,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
+		if (zeroed)
+			__SetPageZeroed(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
-- 
MST


