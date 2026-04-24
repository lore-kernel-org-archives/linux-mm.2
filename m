Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEFC0FED3F8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D496B0005; Fri, 24 Apr 2026 15:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E226B008A; Fri, 24 Apr 2026 15:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CE46B008C; Fri, 24 Apr 2026 15:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD10F6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:05:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40A261602F4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:05:57 +0000 (UTC)
X-FDA: 84694379154.16.AB8F7A6
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 583C6140011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:05:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bJqvLqbf;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+y/frdnpSLgJEoZfNr5r0lhUmPxn2PgdQPDQIjaIR+0=;
	b=iDEtHS2UYYjHobnbt3JMEB7rAZXkOM7S2ONs6/kFeJq3i7q+lKGVE+Uvw1lVh0ipqzqFBt
	tzOHEj0kuqjmnuqN5xmBk+PXoZlurthng4lQRL2EMnRsRcvaW1KuwFl50VOXew09SOz9Ac
	IeNVEELd6nxhnYBBzv6M8NohB8LG15k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bJqvLqbf;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777057555; a=rsa-sha256;
	cv=none;
	b=F/ixK74DgtnKRpo1QO5TXc7utLDAeE0VBhkXmPh94hX0W40boEHzHxmT9kilYoe7j/NgUD
	vNjLBVQy1qND3mIBAvF0lgi/nH4cmp0VfB3mgMnM2FBoTYY6pu/QHw0O5FMztefeFMtgLv
	F1NfJDgj55eD1lFkw8hOHowWqzyv7no=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82f2766905fso3871694b3a.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777057554; x=1777662354; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+y/frdnpSLgJEoZfNr5r0lhUmPxn2PgdQPDQIjaIR+0=;
        b=bJqvLqbfG0ko+glYDeURmnD7W1jpYXihE7gRkhWnJ8ZEITkVcrNgiewVkrFYoA3bss
         yhdy2oe+R5bE1Wwvu9usT0vxta6Ve2tfcNR1N7LnlGFmUrXpCgiL281MK7XWMnNaOjmr
         QlhLzUj0nF1VQUSxbxLK/P5raP23Fi3EhjPcz0Nl7GSe3gXaIrSr6cbA0T3CnXmuYkRQ
         itjrto7Jq+s5Y7MzaX8kiVXHlPtbo0rJTrsAcgh/lNV4OrYbuchexbcqaXExH3NHm3DY
         OPk52YJj1WYf4ZQHO+RzarYC0IHB0OQ0IdX4kcaSOsGmH/W/ieG8PIFvXUk5OCRnYV4o
         vbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777057554; x=1777662354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+y/frdnpSLgJEoZfNr5r0lhUmPxn2PgdQPDQIjaIR+0=;
        b=jdKwe3uUuTeRJDPRmDxSx+4f3TYg3Ux/7A98VdNX0gBaWIGJIp91tytusojr67aWZ5
         YljmuYzJIoevLqcn1GbeoJs8IoofayrfSashAbmQECOXFRD3dyN1wkWXNUdT1zkP4nwv
         ZJKHooqRds4FkLDkZAau9d9Tz5xCmpRU8Za4PJiT/XVuEJjdTDGx5Ee45ZzQaC/Fx7ql
         3pOiT0PIOK1Le+EzBjYzWIREyLSXVFJR62ONxcQxTo7VvRD4mrBgnNbGOmWZUrmjH+BL
         /L7DYPwZZecRWFktfdFjVl3W15DODehj9eZuikkaDNeIJSspUAvNTQaRxQC7rHISj+rp
         p1fw==
X-Gm-Message-State: AOJu0YztFs0CTEZXSdGXLgxE9vIQv6AYbSedD41W0EveBI6w7e9/JW1+
	CMt6PN4xCH/jXAFCgoE+yD2c/C/8X9MTnt5WsRx0TYfJvDgSHMqKLbroVmU5SmEr7vM=
X-Gm-Gg: AeBDievaLQTDM+0rpDGBkmiqoY/8ptMHcT4Jl/9hAQlHc+Qzo0PTAIeOlaXtJAPkqu3
	N/ZtsMvboOFmuK/X3s4WX0QQ22dsfvScWjLKPRcSj4AgDx04nbz2lzTqHFvwm4Hk1SCGTd/gfGa
	qh4dJPbw9ie0LV3fHvnTD8g5qikHN7zuBYsfmtAAh7Dd6BJzjoCZXXYaRp2eaOTObQE0p0LRJEI
	ASpQdVnFu0Vow2xG/WUVRPAlmgk41tQVK19JJ4KjaETIcaZ6AHhveM0RNiUNwf2dTvlRuGhIqSa
	VBt8Ed5e3jH9OEkN1E/EomE+dNY5CluSN2gdm4noA7cxsVFF90G4+H1TiUoyrMGdGfVVrUyj82s
	sBB8oNYwIIyuU6QgHmyESOILy2t/7eaZGkbVgh+0rHMtOR65rTO8RqfWqGtBYFCB4TDG8roVWhZ
	UEaR5MMdo3qGOAjUSVD8wlFYC6QFjWopIoVLCsrd7dFZr4sJKXSX+uWjHfvEwxnB/zpWS5BHJBZ
	PHPQWDQ
X-Received: by 2002:a05:6a00:3e16:b0:82f:8332:492d with SMTP id d2e1a72fcca58-82f8c7dcfecmr35092904b3a.2.1777057553343;
        Fri, 24 Apr 2026 12:05:53 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8317076ca48sm6904899b3a.35.2026.04.24.12.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 12:05:52 -0700 (PDT)
Date: Sat, 25 Apr 2026 03:05:45 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: kasong@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v6 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
Message-ID: <aeujMUcVjLZJZoRG@KASONG-MC4>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
 <20260424-mglru-reclaim-v6-9-a57622d770c3@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424-mglru-reclaim-v6-9-a57622d770c3@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 583C6140011
X-Stat-Signature: uygyn7nytoco4pformnz5wq3d747uc7w
X-HE-Tag: 1777057555-394139
X-HE-Meta: U2FsdGVkX1+eFG0OPPTYfJAEUJumbVIPyrEQeFQb0Hflv3Byks5l1RRdW4Yw27KC2Umhj7uI2WZWGxJYoWOoikh+U3TE7aOneZa8sr6ddb6rUgqLy7yJmKIxUZdUsFqUWZlfQMoxe4NnuWn2BUQHB+UikQdf8Q7p+etkambngXiyCkZTQqNisud+TWfVSNP6vSTTwSyrRvTQUUcfIc/FeKVxrZWRwrytwaTMl7IXn8D0Py7VHwHztg0gd0Nv0dZskJ45+t67Ryzj2Re7IE69FNxtn9I5MO6a2axHvCiPNYkvcx2VGkHFEt29rYz3+LY6WYUeZPLbTDOatN2ddYQbY12wEIGA2vlcuklqpkwy7KUZ1Kfa2OcWelQHIRZd2bOAr7w6kKwu3VNnKHaLMV0zCx3R851UbMoxP71G76AgVbkcp1fZiYqRwZIRLSAjb3bGIdzRgWrf+NS6Va2IgBfhYxPS26gIh0IIHvyX38T+sR61yir0JlP7CFDyzMCTQew8oyHrp+N8nX8Q8oTD4EQYcPSOfe+zzgpPliDDZDh1xxJkRAzGZ6SLQ313VXxFuKz2riEg2t3b7V75Nd4LyRFWmhf+Qy0aD6jTkXYcGAHDs0/rhJe8y+13nZwe0euq46akXny/WG5JvJ5toCKYGC6iqu4RfypjWid2m8H5HFOS+Hv3KzKoD414Ni0cBTykvDpOV3o/yBlpFU0BZHbAFEu+AsvTHoskxR3xV+kDMaFvCyNYSKQZ/EJKOkEzaoDrsLsc+pwK7o0ukJ55Mlt1O+2zA5Hvn7vGQlI0A8YlCaCKtAzOpQPy0w4WAZLlyZmnV2YwUvVi+iLwmrjER2qL+TKn86BB9hPISZFtUzqEpoDcq3zGGGlllxlYw3Q/TxIcWngYomzOQBA/HSMwQ2AXKluoHRneniffuZeDAOze+E/zrj0foYwG4BagYuSWDPg46/BA3mN16mLkjz+cbLaaDop
 Ojf98+B8
 9Ijpedjj/d8U4pzH2+a6JxqX3ZGhV7828Ce2NOm6J45mBowQTvtmvQIH5ApslUMq4MzMEn/rBBnrvDD3Symr92XqhqwI7Xwk6BaGsi3LI/Zlq60iG+hJgMTfkdbeglcYw+LzWE2Wmj/t+C38jmFriwvmhvbFECng5cYie6JQ+Yi8XS43o8y2BRD+PJmtT3Z4FHjx9ZCARNlCmSU20jvPy8y9h1NrA3xJCj0epYalWNqVPsJvX7oEXObQvpROniqngAVHRnUx99MwHIKu29pUmXJgWe2EIms4mce1VYeFt4uZzJRXbQ5f/4j0ZQ8p4CphbXNwaERIpBE+TCP1kPAZ7kjb3KpSTDpTZitUZi8qOTkTskf2bNwJO8c57t5lkoja3KRU2pnsqdFDgJtL6uKJLvzS3qHZJqhdvPFl0dkJgeIB1lcgPgcMDjr/ekRrTC7URR/LCxIUDi1Ll6sVjhAEergPJiPlp0qD/6AxUINsRAEz9MMbomIaPZmqZya2dGryCz5GT6cdk/IMt0sQQ62HlJ3MbIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review (the format doesn't seem right, maybe some sashiko bug):

> commit 1f5e2fcf6aa79d5fe07e850245e1292c205ab0fb
> Author: Kairui Song <kasong@tencent.com>
> mm/mglru: use the common routine for dirty/writeback reactivation
> This commit removes MGLRU-specific handling of dirty and writeback folios,
> instead falling back to the classical LRU routine to reactivate them. The
> intention is to improve scan efficiency and keep these folios away from the
> LRU tail until writeback completes.
> > And using the common routine also keeps the folio's referenced bits
> > (tier bits), which could improve metrics in the long term. Also no
> > more need to clean reclaim bit as the common routine will make use
> > of it.
> The commit message notes that this approach keeps the folio's referenced
> (tier) bits.
> When folios are processed by the common routine, they may be marked active
> and subsequently returned to MGLRU via move_folios_to_lru() ->
> lruvec_add_folio() -> lru_gen_add_folio().
> While lru_gen_add_folio() updates the generation, it does not clear
> LRU_REFS_FLAGS. Should the tier bits be explicitly cleared when a folio
> moves to a new generation so tier tracking starts fresh?
> If stale tier bits are retained across generation movements, could this
> artificially inflate access counts and disrupt the eviction algorithm?

I don't think that's an issue, writeback folios are moved to tail (oldest
gen) once writeback is done. And in real tests this seems actually an
improvement.

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35e3352a53e3bc..74255efc4ad9dd 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > @@ -4628,21 +4627,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
> >  		return true;
> >  	}
> >  
> > -	dirty = folio_test_dirty(folio);
> > -	writeback = folio_test_writeback(folio);
> > -	if (type == LRU_GEN_FILE && dirty) {
> > -		sc->nr.file_taken += delta;
> > -		if (!writeback)
> > -			sc->nr.unqueued_dirty += delta;
> > -	}
> > -
> > -	/* waiting for writeback */
> > -	if (writeback || (type == LRU_GEN_FILE && dirty)) {
> > -		gen = folio_inc_gen(lruvec, folio, true);
> > -		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> > -		return true;
> > -	}
> > -
> >  	return false;
> >  }
> The removed folio_inc_gen() path previously cleared LRU_REFS_FLAGS when
> updating the generation. Can the new fallback approach cause regressions in
> tier tracking by skipping this clearing step?

Same as above, that's not an issue but expected, even an improvement
for many cases.

