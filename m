Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5BF2C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFBF76B0099; Tue,  8 Sep 2026 04:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2E56B009B; Tue,  8 Sep 2026 04:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE92A6B009D; Tue,  8 Sep 2026 04:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBB586B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:24:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5162B1C21D8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:24:33 +0000 (UTC)
X-FDA: 85189908426.29.91977FC
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F0681C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:24:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J8eJiwTT;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788855871;
	b=XfC5A8OnVs46c0Me7stS0JaoVJR6pePp8/5Mv6i+fcXSQrG66Tt8itESFYX/HbtnvnTEvb
	mJwl3vQ8z1x4X8+8Ac2mzorpmujhl6btZKHC7MJRygAeBobKnkOU44NVKOFEaIM2GhfXGa
	dBplwrqChQv0/WhHmJVuqWsEAhkfAbo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788855871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oK4yZ0KXSZYf7SN3RbE80ZIj6P3fE7TSyC7nlXOk0JQ=;
	b=JJyq9pBPBtHuh4vtTI0J14VTigelK1jg5M6l5jRRjRV6yBJLtmoYp0K4z1g4Gkt+c+oLND
	CK7sIM9Fo/JjDeluRtSpyoKWQYp2w8mYwE+3/uLD/pHLOALnRHTKpHMJb1C3cmoIdVyOqE
	fT0uMybZakyx5Lz1okBTc5x/y3fPD3g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J8eJiwTT;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2db858d60e0so908125ad.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 01:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788855870; x=1789460670; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oK4yZ0KXSZYf7SN3RbE80ZIj6P3fE7TSyC7nlXOk0JQ=;
        b=J8eJiwTTEXBGokeqVlQ0v3iQDbPxSzYLjqyg0RAny+J+L2S511UVmywF3x6coFvsil
         6JeO/hA8Hodt9lL//l28Pw5nVhJQfmzdq1bGaeV/owRuXKgKg7SXO0xf08qOIQHJOgJR
         ELixFmeQLu44G+U6n3gy9K4xxuq7dRiQAM96w+P4F7K8RJ7EAeTAGE3mt6xeMU7j7bEz
         /sfokS3aSaUdy7URTwQbn6wltThC7qQITMjeolQVMStbSJm7qrDoUu/Tqy0O5BEp8otL
         liL0XiKxYzFricEhqEEMnfnxhHct8oXca59DDpkmljty3PxP6zRL/c7FtlD8VuUMgJBr
         CV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788855870; x=1789460670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oK4yZ0KXSZYf7SN3RbE80ZIj6P3fE7TSyC7nlXOk0JQ=;
        b=etggmfxUeKIYQpzon2Rngw1/B2onvWvRWiI1gJ6Z3ieTf1UOWc7LL1XeiMl2ceYBJ6
         aTVMhE+/IjjuN4zyCWPPO7yIe36rNEzgW18mBjKS4dVQYBcjsFYLW4eb/ahUkJNrcxcl
         51QFHXn4KpUA97eFeJg2n7wxHekMPBTMAOnIhS5g87Nyq0BH33OAFp3E/Pm8Q6slhOPs
         RgT6qetMsBTc7taAl2d/lFPyEPpPV8JB6RqdPjKxdqt9E+s1d1sFjwHiNzKWerccP8qU
         4N12Ay5VhSFVflzCHGeVaL2KDtDezNHA4iqD/M4kL3W0nnKyUkE43D/Ez7ZaAInJurJV
         m5TA==
X-Forwarded-Encrypted: i=1; AKwUvBzFjpeVTJJw/4V8UBxxhvnAmhrEw9on+uOnl+7bm/+yW3QQkGt39eEj/+W/mU9GnqiucfIKoWnKqQ==@kvack.org
X-Gm-Message-State: AFuF++kf8h5iP4HsrGyCI87p19xe3vtYEG5CnB9OSeuRarKYFN+cmr/1
	1lHkcbLY/KZ3YCtguZnLvQF6qnzdbb42KrINpxwbeZBZ3QBAieTpASVy
X-Gm-Gg: AYBFou2ft2gC+BjMXT9SIPQ+056uC0OU+XrrIDHwTjbcznfSg+Gp7FjVV1iSpnXTyDl
	6J0AhBwAr8r/5Sg3w1sDBaHD5AmKvHXFlqEZX6YN7ZsU0bEGpmvWqTiXBDlWZYe5S/42Gl/NU+P
	6MPCD1PCSpyLM3fTgAouPBXzdUbwNhA3XZ20Xfr3pwt8yrD4+b5DSzOKKsI3ATHlPnCrjfaqnmQ
	xkjMZqAgCOXNwokJ3Eu0U3BHl/HjyHVFx+Vh6czc+bw0CM5I7GdhLPb4MEmGotdcSY/pNvT0GC6
	WuhcJwTnVZxS52p65JJIxfGEExQ/SY+mLnRDn4odPEr6W/2fYnpc7WFLZCzJ9dcUWH1L3B7jSv+
	LVTihFpsK7i8vgPPRwtNZvlKg/vRJ8QKDJ9MzAZtZxE3K7ZP0T5JzPuIikS6Qhteso4her3+vIb
	5I+GhrvPTGg96wMUjCxWTbqyRasyXXbZEbZdJ0zCxHXdCuaHebQYOxFKQkODc=
X-Received: by 2002:a17:902:d586:b0:2cf:b68a:340 with SMTP id d9443c01a7336-2db125f0cf2mr410415385ad.10.1788855869776;
        Tue, 08 Sep 2026 01:24:29 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1495acf7sm55472585ad.25.2026.09.08.01.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 01:24:29 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
Date: Tue,  8 Sep 2026 16:24:15 +0800
Message-ID: <20260908082416.2356617-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825135209.3135169-4-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F0681C0006
X-Stat-Signature: ikc7zrizf3dnizqkto94cm59dzsyoah5
X-HE-Tag: 1788855871-478253
X-HE-Meta: U2FsdGVkX19xe4AlxkY9GXdh0A6OIzoAAgvv4EWr82RVeNS3RxbbQHTycrCTuj6/wLPtT9T2aiXYRtha5h2W0HHeAiZthHAECLVIunwq8BKo62FzyWx6upva1tR9TQmIPhgJrD233HK3rLSLP1CHuYz3hWqb8hTlPwEbHSZ2ILH8Bkx0Jn6GUUkIcUSlphtihWGkNtNRZ+CtJU7/TfqmFTB/Mjl0iXfFZD69KPTqAf03peNML7Xc7mTlBnRqN+bTCHmQuL5dD8P6UjY3yAR5yHflf+5kD+CBc7kguI9+jlzcdYvR0BmM01GIJaM227TQDQTQC5DMdIwJoQHLOfpexvTd50/Q4t5btm3eQKgqiBKOppP0Kx4nnO9NefIFd2QnaSrWXMHem99QYXNxJe0/HNZh+ULwcWHizHeOyohL5kNofZGmoMKNjfnE8yYjaIVzwFPwbfAF/1NoarCDDG+F1fhYtvNT4JQwGXfQhcS1s+ju+s5yl919Ib712eMWNJtnp+WNdD48qHz94rbgyYuI9hKKInfjLWE1uw01iovOJALZ5QNOxX+TPHIY/zEiiSGUgWDXH0E4pV3N+uQWWRlKkBZNV30ZIFpkGCU433LPuuHFrvtgMCN97PZJ/YcoR7ns5YmVqYlzQC0DDeDbNQ+FgApfwfzbQ99xmTpHoXj0sHKv7evAbWCYcNwqRBKiRG3QTMR7MX3bAHWv3DWvJ7F9eH3CSEttFcGs3AzAA2ccqIPzYncJ5/Z/56zFBKtWPffXFqEhNDTmIlZ1bIkYSSnX91Odaj5rAtGquSS5qsQdeHSnp048gGm8GcozxZoPGmjb7uWlqSziHB37ewfcb3Pm75LtawTwNbR54u+agb/PVvrLXpGuFqH+K0lkqkA1+RV9ZTf8xQV6JmekkRgDRG84h3SJA4L3OGRL7CLga01FJ4N0D+IGda5ttpOvAV6VLimDw9ux4b3NGm8Vyq1CRbV
 3lqD/D9o
 LJ6RL9CtGL7S1kquU7ak8LJaAM+6h0mxQz946wLSRg+yqSliaVb5zHnX3uJStXsAbQ3T7V+16xLiMt6sCq2d3scAcZwnOvJfiZd/kJ4STnQonI42sKm5k7rT6SMTqJLkWWSQtxmso1yXYesEOleUgGhgmD7zjXSzk9V4bmFcYp/0O4wxlq8GVU0ukPNUDJvQx3Dm7EY4iLMcnbQKkCT+bQ2mmru5O92xFRmMEMip/lOlDP9GTFg8ItVJZbJM2Tj/c7OynYceiIJXa99jwEcvcAdhi65z3iIy7/GEg82Zil/YZ0mQMHUwnLKj6WyHTQ5ylwzP8rAUzY/n9EcM1v8+pmnGd9FzNOcRpEXfrRHDAMaG9WYOAUZVxT/qd92bIv9gJDfNAPKh1FjLgxHv1M20ybIYsNnvlU8I5Mwcm9gzV/vs+1teLEjvf3P7YShuyne+Zp7EaMlSAIaCaNm+Ws9A4VO+vBbdMHYSbMtp4l+1ytcJPpLnlzz5CisM1JNkZPaIchOqD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 15:52:07 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> zswap writeback decompresses an entry into a fresh swap cache folio and
> writes it back. The folio is cold by construction, yet it is left on the
> LRU for reclaim to find and free later, wasting a reclaim scan and keeping
> cold memory resident longer than necessary.
> 
> Allocate the folio off the LRU and mark it PG_dropbehind so the swap
> dropbehind path frees it from the swap cache once writeback completes.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/zswap.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8163e6c5f76c..d16822a516e8 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1013,7 +1013,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	 */
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
> -	folio_add_lru(folio);
>  
>  	/*
>  	 * folio is locked, and the swapcache is now secured against
> @@ -1046,12 +1045,26 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	/* folio is up to date */
>  	folio_mark_uptodate(folio);
>  
> -	/* move it to the tail of the inactive list after end_writeback */
> -	folio_set_reclaim(folio);
> +	folio_set_dropbehind(folio);
> +
> +	/*
> +	 * Drop our reference before starting writeback so the swap cache holds
> +	 * the only one: the drop in folio_end_writeback() needs that for
> +	 * remove_mapping_reclaim() to succeed, otherwise the folio is handed
> +	 * back to reclaim instead.
> +	 *
> +	 * Nothing can free the folio in the meantime: we hold the folio lock
> +	 * until writeback starts, PG_writeback then blocks swap cache removal,
> +	 * and folio_end_writeback() takes its own reference before clearing
> +	 * PG_writeback and donates it to the drop.
> +	 */
> +	folio_put(folio);
>  
>  	/* start writeback */
>  	__swap_writepage(folio, NULL);

Thanks for addressing this.

I checked the refcount handoff in v4. Dropping the zswap reference before 
__swap_writepage() removes the refcount overlap I was concerned about in v3. 
The swapcache reference keeps the folio alive until writeback starts, and 
folio_end_writeback() takes the completion reference before clearing 
PG_writeback, so remove_mapping_reclaim() sees the expected refcount.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks, 
KunWu

>  
> +	return 0;
> +
>  out:
>  	if (ret) {
>  		swap_cache_del_folio(folio);
> -- 
> 2.53.0-Meta
> 
> 


