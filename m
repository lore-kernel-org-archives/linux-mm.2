Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F045606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gU1Sm7TF
Received: by kanga.kvack.org (Postfix)
	id 96A006B0667; Tue, 24 Nov 2026 12:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948AF6B0672; Tue, 24 Nov 2026 12:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8592B6B0672; Tue, 24 Nov 2026 12:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5039D6B07FD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:29:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3E99A0B98
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:29:24 +0000 (UTC)
X-FDA: 85470699048.27.39CC5FE
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id E4AAC1C0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:29:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gU1Sm7TF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795541363;
	b=ukJJTStPZquz5nJQkx5j0gTVSQTRYXPBgpP8VVdci2P52X1AlwA1/VwRzR84BYQRPRjZJA
	7xZ1ldR8ZGP+h8Dl5lXaN2OmULEK2jMJ6DHXFalpyMKRzX7O0w2meYeZI2g/Qd0EgpnQ6w
	paWRf9r624e0NfWf5vLdC+xbV5OUQT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh6CqnsQ+4Kge1Ge1wt7W5gV069TsTISbQWwZdpvMuU=;
	b=N3wDlcB7o7c9/XAEEEMAwLv1fwiG1pFBFsGua32/T/+JYU3yWuors5wt8zKi0Z0mvc/G0I
	UdthBgxOdPjKhA6OUInhIbLC0G8xtbCRt5d/XUddwY0xZZeBIImZ4hujdZ/X8LIibMjFd+
	mgr+3/uJPJBAYDmQI1Y6BQGHjNV7QSo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gU1Sm7TF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so2070896a12.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795541361; x=1796146161; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gh6CqnsQ+4Kge1Ge1wt7W5gV069TsTISbQWwZdpvMuU=;
        b=gU1Sm7TFj+fbvloxT1O3AjfhifLOGvbscsSlT+Re8i++6oMOLTGIu2lx8KDpzIPeAU
         W3qP2Pxx1dly2Rx4NXCcTSSgA/GCylh4+GFQvcBB6ucpOVuEk04WYJggd5Yzk6uLjwGs
         NjvXDN8RaJCymzV5duwXTyHtWcrJhV0Z4vR+Xa2NdtFVEXiAPLRbUjZoJSreQy/0ROWu
         +7CDDTXC2s3hbHIszmFEnSUA/oIudvGjyS67DUucobp06Nv+HSWs+bBb6lI8whcddBj1
         a1Sk1ib2iyV0Z8iFJAQLGPi+/4s9bAKNF6y4+w05woBasd4mnRY03GNnSFRJh8XEMX04
         RUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541361; x=1796146161;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gh6CqnsQ+4Kge1Ge1wt7W5gV069TsTISbQWwZdpvMuU=;
        b=23tl2vY6+zN9UIhNgU+mUHvbomHWl0V1gUQX3wij/Br//iLs1N7AQraCDa/dELQ0vn
         BXJc3nPJ6vnZeNAvTMMKio7JUZVlzp/lgwvmlkUAzXiZsHugb9Ke/aZHtEAaOadWRjyh
         wFW2Ymw1vbNhK22s3hXyNNMXPnzBRAvvLRXJvDGA1scH6QmV8wjE/0WoywWCYq0ug5xF
         /dRlIaXg7NsAmki7KZtH+98xjMMcg3A+8m2hVxMKWqZar43eOi3NUUG5j6yyETGc+i9x
         b6Aa3f+NyS+VZW49b84miSL67K5D0b9F5dyFq9IRNQyyqZqyKE/0ikh9pemIpqUVj2IR
         8gcg==
X-Forwarded-Encrypted: i=1; AL+hErEDtzyCw9JA7RhgGVNlDqYwG2DqZB4y4w8Fjb9yvr+QIILlcHodcWPGfmPg/U6+HIUQMxMyi+omig==@kvack.org
X-Gm-Message-State: APuU4Z+5/8S3j/Vi+wIqieJdEcXHhDXY9auv8iE5Fj94Kv4GHPstSDzZ
	euZYo4TjtiATifEJGp6X4aYeHPUWKSc8ZwpJYxPviyE9NF2SrMZLXspp
X-Gm-Gg: AZFdTZd4TKhX2/el9AGwOzYYquAVQ44SqhvkMBdjrR2zcGg2QGTw61UI60DFWU++Zeg
	6Y3LnE9I54vKbC7blfjaymWb5bICT4QDDeNizAo+F4njRTtPPwjYSywFmLkO0Y2qlA1DMFQRcdY
	iZyqfLbSlgcew2Ydya/e5bj/7Wct4NvyLib2kC+4UErRdhNAMQe7e+7yd45yxtWRHsXAOxLUst3
	aCFN94WPwZd4uwo9qbywIklnw4oEBrGXESN1yeioP03Ni5SNcul16SDrf27KeFV8Q95vvlaDubh
	Bfa9HRZzuJWPK0DMvBJPOuusX6rB0DaXD1y2/pp0qMjpoaf3T4YgEuJWQBNn64g/xrOwW0hhBZu
	+sNpZPndyf9vXZMH6lyvE8G9Hyc2llon18WOxm12I3Q5PeBvZcddvPDzRo3aeH/ZZ42yOh2CJyh
	Lv5N4ZJQoiORg1FD2jdlvZ0PkQ0YM3JDwHZsVZZ/H8i9JJkn5LVZVhEZ0n0dBZv5zvAr5iAtK69
	rrQ3oMgHUuOGNDrjt8Yh0YU6UDA2glDa8HozZZ7kL47+uA55aed2W3vRriNohMKrbOZ1YdZ5QLW
	rH+KxwvbxqBTfyjLVwfaWZvRF4dm3SZfqZ9R27IgczEGqh7g3j1SAnVyWErNM9qsNdchzKw=
X-Received: by 2002:a05:6300:404c:b0:3fb:35d2:645e with SMTP id adf61e73a8af0-4014a27e70emr13896715637.5.1795541361413;
        Tue, 24 Nov 2026 09:29:21 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4aca2sm7432265b3a.32.2026.11.24.09.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 09:29:20 -0800 (PST)
Date: Wed, 25 Nov 2026 01:29:04 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 11/18] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
Message-ID: <awXIalgUrVIf5VP9@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
 <DN2UPVW6W83J.I1S5XXQ2DPLV@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN2UPVW6W83J.I1S5XXQ2DPLV@nvidia.com>
X-Stat-Signature: rhdeufe5irs5cto1tc1aro5cm5jrs3i8
X-Rspamd-Queue-Id: E4AAC1C0005
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795541362-742962
X-HE-Meta: U2FsdGVkX1+YBUogZ7rFDifo3BJHcDC2KB7XYz3nDB8POPKBnM2TBwNIO6hJtLMkXKuB+AaqndHD2FTHY5ceJ5Lv8CvBMqYf3jZ484sEXYYOVJpKoPFHG2owsX8Q/1ZKdTvRhdzdT0pG+vGNLDxwd4L/ECQ8B2n+0dZ6/eysYxFFLMw+qQMn6KwnmK1ITEQUyEljZjwU3LaB/OsThjRuoV2Rtn42zTm0Cmp90pvnuKMpUcBzSUjzwClc5Le+jkVJoB0Y66wFQ5X5NPtsffhZEG6Yp5IYZ/6/wi+SyOOT8uQ+CfSfDBqCfGHd4ceVZ+5sRmj3oTm8BTOygISidLBso4p7IAEaaLPJZQ7XRNgdt3z12biTeVJ6PRbB3AAGGnYJpKe2OuLr7SwIeD0OVe4lD5s9OA1N5BTPedyYFcf0Jcgex3aI/FBP3MO9MPWzfnNeqMqNvZgQd/f7GoEoDLa67HDxJPDvzQfiu2mYxPLgEH2vICMNVRijqhJv4wMpA3LsdQyYQInS1/8Ojp1oMSMVLI24CYybXN6/MkQc8HeJkT2c/AWdCXEywLKasVhagfrIkO8lRKg1yt9n/1GPfooY14ZuZ9v6aoN7idFrwtAn3WCrC8yzRXV1ZFXHZPgUbjW/IdyEjNeiUnooXneLL+QtaUW/UtjkydMtdORgVWPGW/MxHB5Vywcf7hmpMS7ZiU7GUHCueDStdQHc3myD8oCWlwJBHIUH9OcsUR4dGqDDRFARDdIhO6BQ/S2nemOSeW51ZrpLm0G6MuVwOllHSaasijxkXkDoM/i8qAIiOafzAWjOtc2rYrQxSY7QVix/BuuIMSTWAKEtBWDryUcaFtrLlvHrhrY5IUnllPpUiAu+A7maPdJPPVbaxdVIjcwWmTLqvjTyUWs8PmFGB0kewSxDn3A+JwDwzXSTYiXjv+onKi6B6MiyzTE9oCx3IcceJ6wmiCfLQPQbTk2E56wB76H
 GVajM4I7
 xAEIv6RrZ2miWIieh/W47OPa/Rp3x6tRvJdBJ+evhrFyZt8YqQp6JhRpIbJPd2wljGsh+4YRV+lpFqdlbOwEF3bJf7qqq8ygBo+Jymhlv+PHxdkvb4bK90ltxdRqNa88qsXCUmKRW2edeOwoA8TQtVR8EGqrvar6oOD2ZUuvfzlIdW0cmZs2dbwu6r+8fW9u+wvNhJmfGPgOceHIjESPvTR24fMv0csGAmBX3ygK11HlvNm4McIOYUszh28q3OyugVCPEygYVwpUWKnMzJbNSyL6j9bfq2UYB/HaEnzh5H7//x8hLMJEOupscuAQLaB3bgoAzrZ01Z9GVck78OEpPgxA3uMipS6fCmuVXYQW/VrGJ+m+6HJQd5wn+LoZX4rBBR2f7TB1ilGTyB2/Qg6jsvh91gCpDiRUJlx5MkFZi4jRRwDt0ANEIwVknanhSjBPp0vN/2jkuPsr1tpa6+uzYddZRiIgk46pr2VM2Vuw/cJzTmnAsAlw7IR6OUcYaEVJzlEWO9WWD4994BGnsPYJNs5q1H5zb8GsH+8LNLrWn+cp8dIE0+XVAipo6f6F2vTeijzffteOTN+8+NX8VeKv4ZirmYXoqfVJ44BCHVOIhJ8vtwg9nt8H9qkohVFzDzy/xP2FYCwr5lkeI9/LON2qWX2ocaD6vkvlD9lEAWxzpLPgB8QQHrR34exwGbq7EswLANPfjscljjhHTCNfnwyt2zp353SvQ7zV6LRpNBRs2YERg1TJoORXHuUY+jL+a6UldLh3ScQ87+cPk7c+WPZfOuxG4TH4ibFssE+FNbk518Huw3jFBnLVOeq9QmwX2hNEQRDN5+Xscj8sOGXBIVlc0nSslcM3fwIrAjyACo1xxOvdCh3zKYNFaXmpnvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:52:55PM +0800, Zi Yan wrote:
> On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > PG_referenced is only the lowest bit of the folio LRU refs count
> > (LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
> > clear it, and now it toggles as the count grows. But with the LRU
> > referenced count as a stable API now, we can use two helpers to provide
> > in-kernel users a stable and sane reading of the referenced status of
> > an LRU managed folio.
> >
> > Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
> > count when MGLRU is enabled and PG_referenced otherwise, and switch the
> > smaps paths over to them. The lru_gen_enabled() test stays inside the
> > helpers, so its static key is not splattered over the few call sites.
> >
> > Convert smaps as the first user of them. MGLRU now reports every folio
> > with a nonzero count, so the reading no longer flickers and clearing no
> > longer results in an ambiguous status.
> >
> > The classical LRU case is unchanged.
> >
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  fs/proc/task_mmu.c        |  6 +++---
> >  include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
> >  2 files changed, 34 insertions(+), 3 deletions(-)
> >
> 
> <snip>
> 
> > +/**
> > + * folio_check_lru_refs - Test if an LRU managed folio has been referenced.
> > + * @folio: The folio to test.
> > + *
> > + * Returns true if the MGLRU refs count is nonzero, or PG_referenced is set,
> > + * which is also correct for the non-MGLRU case. Kept as a separate helper,
> > + * to avoid splattering the lru_gen_enabled() static key.
> > + */
> > +static inline bool folio_check_lru_refs(const struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		return folio_lru_refs(folio) > 0;
> > +	return folio_test_referenced(folio);
> > +}
> > +
> > +/**
> > + * folio_clear_lru_refs - Clear the referenced state of an LRU managed folio.
> > + * @folio: The folio to clear.
> > + *
> > + * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
> > + * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
> > + * just like folio_check_lru_refs().
> > + */
> > +static inline void folio_clear_lru_refs(struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		folio_set_lru_refs(folio, 0);
> > +	else
> > +		folio_clear_referenced(folio);
> > +}
> > +
> >  static __always_inline
> >  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
> >  {
> 
> I assume this mean people should stop use folio_*_referenced() directly.
> Are you planning to remove PG_referenced helpers to achieve that?

They are still there for CLRU, but yeah, and actually there is an earlier
RFC where we can remove PG_referenced and PG_workingset, just like this:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-31-913619b014d9@tencent.com/

And this:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-32-913619b014d9@tencent.com/

It doesn't really reduce the flags usage but make the code cleaner.

The co-exist of MGLRU & CLRU makes it looks weird, hopefully we
can solve that soon, let's do it step by step.

> Other than that, LGTM.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>

Thanks.

