Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC46C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B47B6B00A2; Mon, 24 Aug 2026 08:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AAE6B00A3; Mon, 24 Aug 2026 08:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0946B00A4; Mon, 24 Aug 2026 08:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA9D36B00A2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:30:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74F5DC0114
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:30:09 +0000 (UTC)
X-FDA: 85136095338.29.5446565
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A50A80006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:30:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gX6yXxim;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574607;
	b=zWY9c2fY5Q3b+q+yMKum+FkN/XxIUOaMmHa5haiyneXbspKPUbbUrm6lbCvcJ3Ct56cWhS
	W7fnTstOzGOacmbD87s/7VWKzQJZjWSu/XNLhmkWdo0e/HYl0RjHvvun21PCtOlgqD9Ws4
	uE9IBwNXkTMKqWMg+uSgVc1HgFzTztw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gX6yXxim;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUk7KPHfvUyw9pUIUwd/E+D8sEbupQa09omQcDsDz3o=;
	b=ps/KlvYjgB8NRzDIBrYbfi2BW5JlTUNGFH0IPZFk+iYqSuxicVDVp/yFpcKuuw4gTY0lsC
	DnPCLxI90UTGQKNLY5qaFO8+X+9shC80AHp0vLnkzFKjapnaeaZjXHmXRutJi26rk3cpYK
	cV9N1nSeHuVgttjRMFf6qvkhcst8hDc=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4799b3f7c83so2341716f8f.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787574606; x=1788179406; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PUk7KPHfvUyw9pUIUwd/E+D8sEbupQa09omQcDsDz3o=;
        b=gX6yXximaBRlbYaDuk77t9elALR/F9DZBVIgnK55DZU0dzEzU2R+NKGkmVwDdrmcKo
         zX/ezcFU6RKeVtSsMzJR8yGi76CXWppsMbOY6aJNyh0NYOrpRr7omVjZ5PeGmdnKUte8
         f/QzwIq6b6rZLsgtDy+IPKhXhHGq0ivbuYFlgIBTrsPADKS9CTkDwSBGm4FHZSJjSxJV
         Jr8tJZWe48wj5rU7worJmLkKAKUAmRKw4kr/weWxDHPTkPyb49ga6bJre9xcooPYyH79
         rP07Fc8YzTF+9M46H38lnlTz71+KqHf9Tq6LjxTeoP0ksoNXNYyWp+MKI02mr2mslYXH
         W1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787574606; x=1788179406;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PUk7KPHfvUyw9pUIUwd/E+D8sEbupQa09omQcDsDz3o=;
        b=P0NXvtcjB99BA8/PV0GKA8TQDqsnrCFNdKr3+igcgSuQ5xIy0+00yKKJ+Q9imqiAcK
         71tSNyERWGvG499IMR1LaCY0yaEiKTrHw/GvWYnQdUkhPyYv3yyavAB41vVPnT2QcFOP
         BNXMhmp+sV+ES7VTxgFOtTIFs9BxXdJLmUNmZZWvVxSESLHo+d+QoDmNTs3DE+JaYkf6
         ccEf28Ty107ZT9bp2/4bkvPae1/QOaz79Kyot1Oq0oy70XCJhsziODeoV2c4iEmYXO9V
         r1qTP7ffKC/ou4lj02bWbo9czX8Km+rrzVsWGXewLQhzvakowIydsuuLUbwOz1nygFqq
         sQCA==
X-Forwarded-Encrypted: i=1; AHgh+RoM2xtlPp+MZRbBM0hbYx9f3QzUtw5mhDLAXddTSZwzqonmQxw87yiML9EGwtu++1v2SGW6MT0RWA==@kvack.org
X-Gm-Message-State: AFuF++ns11kPLtQzEw1Uul3OvEfdi+6PCDLOZ/tMPr+bKryQCe/tWuXa
	GR9rEqvG0UWz7T7cWC3L75FWGu/J3V2LU5BGHtph0dN6YY+D1lzPSFgz
X-Gm-Gg: AR+sD12nzNlUk6IrmcvHKz8RkenJl6ltuYK+n7D/SSL/R3eyzPX4PI3KJh4gQ9WOCxj
	QI146NF1Vs2WoB1wGp6ExPHEX/cx6ejESRK4tC5XKqkfc0WUVxeL0QXlwpyT0uVCmVQkeEaypfD
	g7ejVOVre55IvYLH1tUHJIiCWBRJ2nGlT20CS/s6df3ycfiDsh8Cx3dtHtrKh75vgVBiJ3WKhnW
	mG6NE5amWl+g3jNfvJuF5jq61yIv6PnELNHICFULVKxyJh2y45yWQpsVQ0wavO1M4akMtQxeqjI
	tqVsHx2LqEif98PoCS0Ob4jeqgEGgGaBvkmpuTVmDXLOp4Cir6AV8c3wdrgC4Inua1L4WOiH3Wo
	omM/hiWjf7ySmPiC+lDTpCUMOJka/XdGDpK28K58YwTEM1BylCQnWBoCl07APAhoM0VrYq7Z525
	RDt/oBX6LoAhG0cSDZP6L/qfP0RaSaHikmVoXs/msu9s243YUvjlmEH0CgMOI+wrhj0Dx2jTF+d
	I5Qage05F9ESkhCCO9Kk16F
X-Received: by 2002:a05:6000:2383:b0:475:3a97:8e2c with SMTP id ffacd0b85a97d-482c81c0377mr18786975f8f.16.1787574582551;
        Mon, 24 Aug 2026 05:29:42 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482c9c086fbsm7997186f8f.26.2026.08.24.05.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:29:41 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:29:29 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mm/migrate: copy the referenced state via
 folio_migrate_refs()
Message-ID: <aowmf2OcDnayYaU2@KASONG-MC4>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
 <51b025a4-7da8-4b50-9ba3-1c25eaee7b04@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b025a4-7da8-4b50-9ba3-1c25eaee7b04@kernel.org>
X-Rspamd-Queue-Id: 9A50A80006
X-Rspam-User: 
X-Stat-Signature: s6kysijxkxny93efiwkuwqnifykyz4z6
X-Rspamd-Server: rspam06
X-HE-Tag: 1787574607-725243
X-HE-Meta: U2FsdGVkX1/N3iVg5G6aP9P6Q5Xkljbh8p+5cBAW93Yk8DKLVpEajpBCCjz8/d9oxm6GaeZe3Th664Uw9wyYEqMz9PaHSmFnAlVOB8msuIFhZNq7AtLaZQw7WPUzd4WgUByei5nP3Ubm4NfRH2aaLskVHMMMEOkX3al1eq4nab9lH5PL7Roz3lWoS8ojK+BUq/bpm+7EwA6MIC/WLNCGhEA+PuV2ilnDf6BzkZ+TtwwDRpibBotEKjD76N7O50dxo25eatqFh7Q6XaXS3w8SmdllJplGRT4Oo1OZAEw3k70dHx+4MvkizlJPjDqt+bhFrvM63bNRRsQZP2RwlM8/o52aIwb3LbaYv/XRABvvPobjZhBeH+J2nDTdcx/PxAUu4uLE+yzXLCIYYFzi1OBRhJ5LGgnzp5hrl2biprUR1OiAeZT7Mre4HI0Aq1a4fr1WDuEkJHGqSwWjVkuy7Y1PYvl2HrTYLo64iUE+eweR5REpVMtcVe4tSW1BDE3rn3+BjQ8nmqTjEGFFwmAG/gNnKeO/IDcRjwUaQaUbXBJZ+k9SUAymHfb+opPEg/3sUBONwTueefK+/8WHf5cfZfM7PcVgC1yJk86+uLSvmk8bLVoVicw4+zlPXDioeL3+J0I37be35Docm86cIwSIrj341RBUXd+K5Bsdc4wkgvhF04Kt+FRbFVTym9uDDtXRSHURx27u0hPaCEzOAG0OqEb4tLDtm2v0X0pbu0dFudY2oSJswsed9/1GdGS//A0+S3XrzyMNmkhTyS8tDAs85zNIOV/TOuTaZJL9AR8pNkpr6HTzl+MtLS6tQbDVNYbRPvLV+oIBkJ+o/MG0qhsg4cF7r20KI42xll7EpMAPRULvZANBYCLUabzEiY29qWHPvVpxRVh8WK2eV9FN5+cX4VFWmfQEl3vLsz8c/rzl9CwFw63dB1HoBigQHdP+Cy6LTKyFzijIdMtRTermzuZJJFH
 iMKsUGrR
 P1CXd1TqevAHF6PC3Pzm10S8tiY1X2iA4mB7mCf1rjQ23S/ZYXlzVk1YMdNFneOeTPolu6GIKixMVve582sjy0/qjBG6B50fj2m7TY+Z8eXah9+hd0ALVdAcPP2e4TaWFwcOPDSTeEr3Fmc55dFhwkEeY1siXVyjRM5hf31sX7AI3mmo1JHqti17DpKGrJN52BXJE/gINeTvZBIvwCUpm+sWS6OLcmImiY6h+4HB2Itl9KAO2Dv7d7O1EX0JhJQACxDQwmsl5zhg6c26afGTWwBfAwE4w08udl0HUSy0O46HShTHEZSsoQCMAHYbgQ15hd7HvQTAh6Hq9l5Ci3SMeDa4FblnjsYcjdkSAqoLuxprs0J11B6pjSyCgHCPS+hXOKSRyfdLfLLCFnpeN7rEbPBMgcE/FdDEeBiIbLiJ/h5kaMEFVFT47b82rx9Yzc8MZA+QVdDhfaG72qW7judWBkXCDGmYKdkUPVW1M5B3gJeIRMnK0W34Zpeay66I3yDtzSBn6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 08:20:34PM +0800, David Hildenbrand (Arm) wrote:
> On 8/18/26 07:38, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > folio_migrate_flags() copies PG_referenced separately, while
> > folio_migrate_refs() copies the rest of the reference state. Make
> > folio_migrate_refs() copy the complete state, i.e., PG_referenced plus
> > the MGLRU refs counter, in both LRU implementations, and drop the
> > open-coded copy so the reference state is transferred in one place.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 16 +++++++++++++---
> >  mm/migrate.c              |  4 ++--
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 93bf3fa221f8..df62daaa2ee7 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -366,11 +366,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
> >  	return true;
> >  }
> >  
> > +/**
> > + * folio_migrate_refs - copy the reference state to a new folio
> > + * @new: the destination folio
> > + * @old: the source folio
> > + *
> 
> Man, that function has a confusing name (refs vs. ref_count). :)
> 
> "ref_state" would be clearer (just what the description says).
> 
> Or better, "folio_migrate_lru_refs", because that's literally the name of the
> function you use: folio_set_lru_refs.
> 
> Can we have a cleanup patch to name that consistently?

Sure, I think I can just rename it here as the code gets consolidated
and kdoc being added

