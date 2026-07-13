Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC7EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23B16B008A; Mon, 13 Jul 2026 06:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD43F6B008C; Mon, 13 Jul 2026 06:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC61D6B0092; Mon, 13 Jul 2026 06:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD7C16B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:41:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48589120718
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:41:43 +0000 (UTC)
X-FDA: 84983412486.16.6692D77
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 380EF120007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:41:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Q10KK+fs;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783939301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYEvHk/YQwaSKZb15XTEhRLqDQdjnw2zpv1OC/g28DM=;
	b=Lzvindq81BBQ5GrjVtl8+4GrPtYySXoewTkXR5fAcES8EpgtIhlGFMox1QOKM1HzThoOJY
	5sUUNXhc0w0hvmHyRneSbxD0yWvjirzQzABQqJFcQa41Bt+zSLuBVelEUo1UNNIgb0L9mP
	ttuBgLtnMH2R3LgkCsu+oHQp70iXaXk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Q10KK+fs;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783939301;
	b=j0hCT3hJdOvj1qGL4jMYANP5E5IURpNky30k9WFhIgbcfxpbk5nURykuJ1e414Z+c1IGzx
	9m9vt2x+iljQ2gbn1Tm0XRhYarFvNExcT4UxwdXQU3w3wJSbyqGw/J+uYKT+EJp69fFZce
	qz+W2wu5Ew+3zE/GGxAItUTCEOgLPNQ=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso1748130f8f.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783939300; x=1784544100; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GYEvHk/YQwaSKZb15XTEhRLqDQdjnw2zpv1OC/g28DM=;
        b=Q10KK+fseF6b7cmbXcM3MclTqwi0Dmp5x4pFwFWkRlyDQbW5FbHbWAkgH6eupgjbVL
         VmV9pAvDAOMcT4N/vZRbKFux+srz6WKlr5VGy5/SA0sg/2+sHOsM1o/5G5JUKGzrSHoA
         X6cq3StUzOiuE/AvmBfDnAHVkSiPi7L7qdraGI3F+2WPtRKffUb9tJsJbJxG1Z+D/NtT
         N5BBjdor90j3nIP0jsuzD2eJ1dxSw/rsAOuD5pwT2w7gYrPA2E4grIJ2aL7AVALxpayl
         8HMZJcSAZlWXqOZLdjorYOvfWZmcID5DrCw4fqybLSj8Bs7Bzp2uM/smeeIkG/RkreFa
         lKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783939300; x=1784544100;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GYEvHk/YQwaSKZb15XTEhRLqDQdjnw2zpv1OC/g28DM=;
        b=nX1uEfNg71C6Ojss/+khCGGPnMIC6Hu7+4zf12t37TZ4k3EuDo5EOPhg2Wt2Pq6Ndb
         uaKUwP3iaUoWTn7JenkBpGAVOMaPKHUCla5SaxGF2nPUJUEuuAGilcYI7axk5MkES7zz
         v8wTE9juCTKVl9v6BikN2U5Bi1QLeMadV/NiuZkGWY2yOY7U9cSibNHQeNOw3JE/cSWX
         SBzGXzlZZMm5tMbLQY0bKdfYDNkviZXOQTGQmUmi5A87T+8wzZMy/v59Fnavt59w6krC
         UuF+ov7RQC2v2WN2YKmC89rP1gsjPxsloPexnS3A4UvdpAZXKU32DgiXQnxdrqCuPQ8q
         dYkg==
X-Forwarded-Encrypted: i=1; AHgh+RrJmUuygZigVHgHQzLKUQrfTAYT7c+r7K1EJT/hZ5/2JqGjqBmSHriPcW2zOfEvopJG0eM/DX8XuA==@kvack.org
X-Gm-Message-State: AOJu0Yx06n+QvlTEK66kY9lPxvbCjpvUheIEQyA2tAtpZXLWphIxPOSO
	+GvJELVkntX+BoSTM5R8OnAMIoJHX3+JogRsTaRaz2p28jvGMjXgKmMqmsx2jF69Yww=
X-Gm-Gg: AfdE7ckHLrEHbIEaUUDCl9697KrCLPs0/qY/HKDAdjwncHlmvADr9Md12iThS+xAMk4
	kQsqpxkudRM9HIx1CmavrU2g/vXNRZ6TW/1VDuDv7Sau122AfPGt2CEP/11i6dVMG4JMzoVnDnB
	pf+usRr+nWXOuAOP4x1wC099blqviq6rPVgGuizUnMjLa1T5/Wc/MYmLfdm3AiLPyrc8SfbO5CR
	5oZAOGWPVSW47rmcdPnAUyJ/BP9mGECP3EGJv4r4A+eg2nvo3wTAfGHZewUt4g7Hqb+oOyg/q3Z
	I2DXH+yl1vGDiMRct3WDpfhdR7Aehb4OjZzVZ5ojRUDTLzMGpc4/gPU2AzTCMDZTjnAeUzUGkn7
	GVLD2XaaEXndjGANpCwTZ7F0yOQZL1Mqhbb9HjrsjuRrSdOBnlqVFhwNAdGfWiKwWeduhKIYnjJ
	Ko3tHU6dZvOw==
X-Received: by 2002:a5d:64e7:0:b0:472:aaba:faed with SMTP id ffacd0b85a97d-47f2dcc6bd5mr9999848f8f.31.1783939299409;
        Mon, 13 Jul 2026 03:41:39 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039af67sm95258224f8f.17.2026.07.13.03.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:41:38 -0700 (PDT)
Date: Mon, 13 Jul 2026 06:41:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, harry@kernel.org,
	muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn,
	mhocko@kernel.org, roman.gushchin@linux.dev, ljs@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <20260713104134.GA276793@cmpxchg.org>
References: <20260710154318.75388-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710154318.75388-1-qi.zheng@linux.dev>
X-Stat-Signature: 3a8bn9fzoz6dueouqjafb5d8713pqfng
X-Rspamd-Queue-Id: 380EF120007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783939301-853621
X-HE-Meta: U2FsdGVkX1/ayvotTb/bL/Aste/W5zYSKVF2QlYM3wXY3XaXJ/vyaT2oCDgZbK3V5Z9lBCiWoh/e+/mfoQdFZIIaclU+P7iAmPtDn4RpC0KqKkd+5sa5n6BsXlw89XAq88uChRvhIoe4sJRkHTflnnwnNIFpBLaeqOIAe3nnZnWJgerrvyrnQv6Sv4GY1OChE9ewydtQLB+gLiHwMelftFC1bCwaSq9pSfgy3ri4zhD1kTU/3STW2VLbg50O70SpCvcmAjJ9i58H3x104L0B7OPt3vrQb+oTBjgVy+sambalw91rtC9eUjNoFw/p5tYjt4Dc96ZeOM9atXrY/N8VQxWNpyHUXi4z6aJ1z/XPKVzir6t1r098exgEZnQjkcj1KrYp2Fb6HYdY3ucTVAaS2C0VlwLmLpdjqbIChLGiAX/pC+0CFAJRsQUQhcRPLYuxp3kDm8xS6tKDKYerejez+2O7nDd5zu7Erpn0opzbwM3YBgU5b85+ChqPmbcNAwJ4Me3nHKEG8CpB/ft08HChbxVM3cGs+Ek+HxJQWhghS/ANDhnHPp9DuCZB1Qx5+ovx6JFFmZU35OxPGd1BC22MXZ7RXha8FHgxQwUgA+Q8iAlBcSEV2UkXfgY1yxY5KjbUuAONK/ZglTVjsNzqJfM/v9DyhY5MGHLxSz9s9A+LQL3OmZjQiHnyaa4kK9aVk/ayWGwLWqQ9HMzixo13AE/oRXNWmIBleRONplM3QDlgUJjNzrw8Fs5xGimT2QCBmMjJz4/Broe0JjOvHlT3LUTZXuX//Qhj8w9Bhz58Jo4tCGbDAcdSlLXn+CFW34927MqNo1+0zbj/x/WK2ISYKPelIBWOvSZglQG69YKljoMoc1qFvD4WS9zKvu88E0ebPrh4hDKKqTB+NpCT2xHtIvtUAc/LfJAcHwY2FglmS4u7KgYdBHSQhyw0+Aw2VdIwM88rTRRmNl1Svd6Sflx2z9W
 Fqxp0/Lm
 r+49/jNq5QI4Jx95kEWVZdctjf9K3ZHMGs4GWBEIBL88fvMiBUI1+1e1cvMDAGCOXKZTx+3u4nlVNj9RMc8pNm32o8V1Y+HZugk1dXItP2rQeZ+2w3Nt4zRrueNU4Wpp/eL2IKaWQl9hrZRJ7S5yzwNUnNIcrEjd/HvGF+Z9pYKWdKcNTe1x8K7/OXccIYKCsUbQPqhZmb1pxKULoAxhDPsFJ9jeKX8zfdqHVBdRMqNk8qb3h4B0PV6E7sha66gD4jclv53PUnsSrMR1Dm1IVur6idXzdscjOBC5AaTMi1a1Axe43jIbiYS79qmWeyoKhGyykjaNyhIGkVJ3wMDWF6iKSn1EhQ5W0qh812RbjBeoNbpvI8PXp8GEW1CRQHXcWMpCsDYqL59y9qISN4OAaoay+3uv1o1LhR4/uVzIU5WhTim8jucdEAM69gaPubCFBz/8OXQY3KL0Fm4iJkdw+u+US1jSgnJxj+n2X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:43:18PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages += delta
> 
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to parent
>                                       unlock lruvec
> 
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> And the user-visible impact of underestimated nr_pages in MGLRU was
> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> reaches zero, but there are still more pages.
> 
> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> flushing the pending batch. A non-dying memcg keeps the original lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> to the first non-dying ancestor.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

