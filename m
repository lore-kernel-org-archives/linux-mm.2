Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC326105D98C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 23:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84FB6B0088; Tue,  7 Apr 2026 19:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35EA6B0089; Tue,  7 Apr 2026 19:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24086B008A; Tue,  7 Apr 2026 19:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB0B6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 19:36:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CD1A160989
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:36:04 +0000 (UTC)
X-FDA: 84633370248.03.7EAE6AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D79728000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:36:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gzwV2I2n;
	spf=pass (imf02.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775604962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSte9vRO1TSshWcFHdBwTd4rL0Ri6sBQhlLf+reom5g=;
	b=SD9qDzvUg1FODYYZYFkZlV/ScVhJRDh9mYm69Uh2rpmOW7B4WzJCY90Am6ThG84j/vYUBO
	bNcmojjCpsrBbtUpjufH/eeUPvso6ES91wlu6e8u676K5uHAnEppUhBI1GpN0+6i0BY1Vj
	9lcX9U/JxcfX6EjEPDe8ojWq2kJ0WJU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gzwV2I2n;
	spf=pass (imf02.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775604962; a=rsa-sha256;
	cv=none;
	b=EVtMiZhHtTvU79MCae4TeBS2/JmnNrFw/x7L40WlivBjLJVASYPqWkJG/nP4CLDVXjY3wS
	GliSjJzR4a/b6Gj9Lr5RQEPzzWW0hKPEa6bXDBPwXkn111PB6xfwLCOri2exGzg3lSYqch
	E86i8imVKdGFF2V4D3igCHtFmapeqb4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775604961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cSte9vRO1TSshWcFHdBwTd4rL0Ri6sBQhlLf+reom5g=;
	b=gzwV2I2ncUaqe4+QeLgjoWkgtjPeLfmFpCTr4rwSDxK4lI4btnWMqUO++NzW1aPp4fp8Ow
	WP8R4m4Jnvezxs8mFvTp60v/XkbRv16gtk2CR58hFskdBBfdyVr21kon4pDLTIVBCGJhjL
	1wglG0RCTCdDy3ecrqUPW8SFVaGvM7E=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-Bi_GAVn4O3SsggUb42Sn2Q-1; Tue, 07 Apr 2026 19:35:59 -0400
X-MC-Unique: Bi_GAVn4O3SsggUb42Sn2Q-1
X-Mimecast-MFC-AGG-ID: Bi_GAVn4O3SsggUb42Sn2Q_1775604959
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50b52a2d70cso136579331cf.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 16:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775604959; x=1776209759;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSte9vRO1TSshWcFHdBwTd4rL0Ri6sBQhlLf+reom5g=;
        b=lASWuYbGmH9RymE4rioGSRXsijWVxRm9DkUQQ+cv5NDX63Mn8jf31L/+sIP7N+vukn
         ErqzATsH3xXOtsqfgYjkk183C0HXOUU9yXovOay4fXZCHHLBKkb9Ihtp6yYH9fJcMykY
         Ywfbm9QMzsJF1eSzF7r8uJmWo4BTDeUIsUiR7U/JcBYNu72bGjOODDIWGczy74yb3Gbi
         rWx6ZaCEIM1iWPXH+n2Cx4hWysSRcQDGpAmxuqMQcRpAXSjY7gJPyEmEpFU25SZ71h+Z
         DJ7PP6EpGvfBv+O8CGQCop4RiRy8dhiL9r2wbWEOBxLMEwAidMt6HPX0bVJsnqw6HzbW
         I7sA==
X-Forwarded-Encrypted: i=1; AJvYcCVSwnahXbrbTFqsyxn8fgvxYbD32t7Qbwgevmt7twqw2zGkYaDSYzzEu8nqeHwItjRbVA8hC1gNyQ==@kvack.org
X-Gm-Message-State: AOJu0YwBJ3gsENOevI1I4R8mcAYrHcVwvgwbNIwYDC/DTEYwTKTpkSXc
	+5G7+PrMxAhZvvamK4kY+T8JZdm77AMaiWsP2/pAy9BBONOYsQgrN/j1VGrDRQUl/15gA3oFl/9
	RMDbx4r4qF9D/cwCdgVjW0Pz6che87DDIeI/lTzPYJyep43Us7xJB
X-Gm-Gg: AeBDievrKLBOOGVz5bUCpBKqp59bpyKE7KGT67Vlt5HI64VIX/3gx0+6JwsS/ZQcaFF
	6d0GQSFUr059jkjj3LyG7aQX/padBgK4Ka6NsDxwc75F8Ws5e0RVNKZwV0UYWpMmEInCDA2qPR5
	oHBF2d+dXxpNqi58IviuLg2mgYRosHU/T2oBn72hE+0a/dGAqsxu8KFPOzKDIEgevZ2bn5qpgUD
	3Ulo4d2HMi8Toe0z2eFLF8+avPq/8kLHpGc7JApo/gBATIehvKqK9p6v3IZIsrrIKYZ4VKASQTj
	kdUb0meTOgILDUJdQDScZLwMrtJl+C3BHJ/kQc0DATq5HCTaDC2Kun9arUX3BBj3rfF/osqM/29
	dgLX01AWtRxZukh6JYLPt47FGzLhMMyBHH0slPrdh1vRNYxgLipncLLQfsFjz0q4=
X-Received: by 2002:ac8:7e89:0:b0:50b:41b7:d6c2 with SMTP id d75a77b69052e-50d62ad8295mr291701011cf.47.1775604959230;
        Tue, 07 Apr 2026 16:35:59 -0700 (PDT)
X-Received: by 2002:ac8:7e89:0:b0:50b:41b7:d6c2 with SMTP id d75a77b69052e-50d62ad8295mr291700461cf.47.1775604958598;
        Tue, 07 Apr 2026 16:35:58 -0700 (PDT)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d5ea136a1sm129517281cf.25.2026.04.07.16.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 16:35:56 -0700 (PDT)
Date: Tue, 7 Apr 2026 19:35:54 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH RFC 2/2] cgroup/dmem: add a node to double charge in memcg
Message-ID: <adUVZ-i3Ot3R07Lq@x1nano>
References: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
 <20260403-cgroup-dmem-memcg-double-charge-v1-2-c371d155de2a@redhat.com>
 <auzxmkl5jxlvlxpryibtz7srdnssguiaylb3uisheclrqelcgh@owm2nve7axb5>
MIME-Version: 1.0
In-Reply-To: <auzxmkl5jxlvlxpryibtz7srdnssguiaylb3uisheclrqelcgh@owm2nve7axb5>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Id6fBEssU98fIpwxWIbKFwBWWyNgv8MIpRn024ULe8M_1775604959
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D79728000F
X-Stat-Signature: yupdpii5ap5pirzob84uidjcqpc57naw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775604961-440358
X-HE-Meta: U2FsdGVkX1/iei0VpkjIIktVHE4twSZIbRX4MrCp7f9xxtvFZx1j30EFgIJNNXancOjGE50IG7XyYEKJJ6WuCd3kUXSyS811NkweFW+xHtCjVYfkXtzE6MhzXwBUlywyFuh/Zny/XjrDNcqzAJvdh4MTAq/YGYefBDjIatWTpQ66jk7buI4CinxiRid2YoUTtCsEOazcRB5b8sGem1iKNPXcjrPMktwsXVxO8n7dHpZ+22R7Py+2qvqdBPtbP87LMN+4eSkNLv2fiSrt74tnBywbzC+oRJviB4yfNXRlpx+CgaQtqwcT3uXCAiTJke5Osy0BhA2gN0xtuPY/G+VXmO5f2YyKJeBJ/cT1/aMnMNh/aV/bBbPmELy71FsQwJyWfD/mLbBGglnDjFCKd/YVh+PIx3aM3CDfaP1bieQGot9E+b1kMjQpeRrxofIwhVxWHMjst7mJOXxulu5ophEipjbm9EoiBhvRw0GhfplybrzUnXusTEsmMli0rrO0n5bSga8O1v+Q/4SrkilmRIAYHao24S5XjRBk5Ci5vwSBi/pKVT4BM0fT1lKCxw6S5It/BVowCtcOfb0UHDwRYPbDBeC5nUlGKJ/XsCqPDY7jQxq8ZxrMfgFou5z6NmXIaZvC0bzlk2+PqvK8CU2CJBv38oysnOzN5VcKCtZAb8gwrNbx1df+XGKzcihcHqhcVGFw8Tbu/L/ftU5JSTkGHIeZ/luEBtD3swJqftahPRoyv0GAXk4QZltc5FZUxCfvy0wKDnH3pjZB8oG9flPv2ZEd5vbNrmrZUq4c5Fp3ZHa3auNzzg7CX1yWEFFdNt+dKIXfC5dje3WMuBhp+zMU+qoYG6Y4vN1Woa1eL/qSFPZUR5R3XO7O8oKoQAESSRE7B3IP47Vku7C5aevCxkdcgJ1yJGhTGf8YG+gg96gEeElhXvNkRa/m1rvGkXC6WGzfRq2G61ujuP8jIQDvX51Ki9+
 wQ/oE3qN
 MqS/wozMhGPU6jwN/II691Lm1khPGwdX9Q7+11B+jkKc0bxpwUykhPQRmlVu6BTQrLd2sWSsux6KlFGbKGDiE/J7/ZH8XBD5FlPUUrwCiH9lOOSdXZfi9N85018MX8Cye88nUaiCootXlGNhBCF10jNzzCx3G/l7oYZ2tEiMCJAUyLLyaamTLY3x8xDnd58Kd+3kI+GIpO9IQU3cIZQ+oeqMyXCT91XHDQ2ZbosdI6//opr77hQxarBIkUluq491DFed7HioNEg2aMauRgB2Dflotsx6XORxUpKKNMGDzHVv90YiWuEPrlrqPK8rFJRx3SSzI1hCq8zQGHJErjpBNy+AdedG1SzuvBUgW0ZChU8p0nwUUIX9lZirLHmNGot2UV5nJ9HrO41r58rMgQMCWEs9kyEiqQhY8YSPHdIc1ilqO41PWrnsg0hE1nuQsdEq6Ib4p65ovb2c/CnJPeMORNk+NIQz1bg5fX/BSawW66lJ3ZtJzpik96uVQTWwfE2XOUp8xNpa4VtjlLVkZ2oeGVLt2XRfP1gKkZPszuCw1FXeeKE2tauQ7VVCW52VUIRaLPqNBVUawbB1Ei60kOz0qVpEvHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 02:48:05PM +0200, Michal Koutný wrote:
> Hi.
> 
> On Fri, Apr 03, 2026 at 10:08:36AM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> > Introduce /cgroupfs/<>/dmem.memcg to make allocations in a dmem
> > controlled region also be charged in memcg.
> > 
> > This is disabled by default and requires the administrator to configure
> > it through the cgroupfs before the first charge occurs.
> 
> This somehow dropped the reason from [1] that this should be per-cgroup
> controllable. Is that still valid? (Otherwise, I'd ask why not make this
> a simple boot cmdline parameter like cgroup.memory=nokmem.)

[1] argued it should be controllable per dmem region more than per
cgroup. For example, a cgroup configured +memory and +dmem with one
region charging only dmem and the other double charging memcg and dmem.

cgroup.memory=nokmem karg would double charge all or none of the regions
for all cgroups iiuc. So maybe just make memcg CFTYPE_ONLY_ON_ROOT and
inherit that configuration in all children would do?

> > @@ -624,6 +656,13 @@ void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size)
> >  		return;
> >  
> >  	page_counter_uncharge(&pool->cnt, size);
> > +
> > +	struct mem_cgroup *memcg = mem_cgroup_from_cgroup(pool->cs->css.cgroup);
> 
> This is not necessarily same memcg as when the dmem was charged via
> current (imagine dmem controller to depth N, but memcg only to N-1;
> charge, then memcg is enabled up to N so this would attempt uncharge
> from new memcg at level N, possibly going negative).
> 
> There is a question whether dmem should enforce same-depth hierarchies
> with `dmem_cgrp_subsys.depends_on = 1 << memory_cgrp_id` (see
> io_cgrp_subsys for comparison).

Thanks! I'll look into depends_on.

> And eventually, if per-cgroup attribute is desired, it would make
> greater sense to me if that attribute was on the parent level, so that
> siblings competing among each other are always of the same composition
> (i.e. all w/out dmem or all including dmem). This likely results in this
> extra-charging attribute to be properly hierarchical.
> 
> HTH,
> Michal
> 
> [1] https://lore.kernel.org/all/a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com/

Thank you for the feedback,

-- 
Eric Chanudet


