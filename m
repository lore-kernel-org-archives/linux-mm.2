Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF57D7309C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 05:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9BF6B0005; Fri,  3 Apr 2026 01:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A796B0089; Fri,  3 Apr 2026 01:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5692C6B008A; Fri,  3 Apr 2026 01:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4556A6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:01:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF4C714048D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:01:04 +0000 (UTC)
X-FDA: 84616045248.23.3B8622E
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14C00160007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:01:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LmwyqTMk;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LmwyqTMk;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775192463; a=rsa-sha256;
	cv=none;
	b=pQXJDVyep29DHHfIGrwqgds98UMwj4cZFA6fh3pjLl1hj/m/fhKQ6tkiorim4RO5EReWly
	63qcx37DfxBzAt/5+YYJbjA9SuOXWPV9bhVoE6EyupkBiuH9/iINMvpbfdXnXsqFmi/0mj
	ZSqYrssJoqz9X7R/Jvz8Ci6qI/RuFWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775192463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQJtFaNwbncbMp+SaMn+f9Z1Y6W2kUOXpEOhhAKm3G8=;
	b=0CrHSef7bGSQc5Q5lInh5wNEc80QFPArgI96E3Ljlna9OZclow1CU13dnZfotoSOaifL7l
	IBrzoWqAxzgB5d4oavfwLrod6sH5YIi7AzrunvPZGCdrXxknL5JeS6o2+3Va6u8cJQTrfC
	JGc90LnCnwdQpV6TseGDMxfi3StXsbU=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35d96be7c13so963153a91.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 22:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775192462; x=1775797262; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQJtFaNwbncbMp+SaMn+f9Z1Y6W2kUOXpEOhhAKm3G8=;
        b=LmwyqTMkB48dl5BZAUwdKyMe74xnibfbuAP9iQB8YDfVqkzdEHx17nMOebtC2r4iSm
         J9g3duvw3DOnHKLNlMUIkhd+DYHPfKoHNWn21YCfx4iO6EdTBCWgCnRfdo1DDYU+PiCd
         10Ht13gvRONywMn+VfPM7AHicaaxPfDsFaJH3modLIkrFT0DeOPdCSRKagR41p0igHnw
         VTQmXrfW8CHiibexnDY6rLZQvz3yWCe/Gk9eaVGXGIWzZFwb1fkIge0V23SAItmu8q1F
         nJfra9WWpJsV+6XCbHvwhYT0pW/wELUG+NW0X2R7OjfW21Tfb8FlBF7FfQLlLvWZ3+4/
         n0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775192462; x=1775797262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQJtFaNwbncbMp+SaMn+f9Z1Y6W2kUOXpEOhhAKm3G8=;
        b=nikxbATbkVSMrBemwDvoORZzqjz1BXR9rEpRTW1upUOQnVmpVfb4BkcZesoiV74mNm
         E0dksdr1EJHR9ouztQsYGfG/w981STFPCHydMlZItA5oa7BeZsYMUV4QdaK6K4Ufunvu
         uYou1WM0QGfo4hGa2b2/ndKacFHuzlkm6dpTZ8xPE+75Hzzi1SnEAM2BeYctyu6E/NKj
         /EMw2mt6I16HW1Is9NLZmyKZ9aB941LlfLm2IWHyhYGV+M1W0VOdefR22hsoPCvBwf2o
         UJF7s/XVv16jH+O4rYk21n7X0qN6vxuvz8+u7bZLCzGpuQ47hmY/7l48zAN6Cf9vdFGf
         +o6A==
X-Gm-Message-State: AOJu0YzhJMO5vAPr6DaidC1LIufxFijPi5k20lM/6HdE+4mZ28QVys/0
	4C5e9eYQsqKVN/CvjlnTV7AMqO0o8rpoEkun0IrhWmS1OYl913YYTTwE
X-Gm-Gg: AeBDiesMsM87doL80pK6pi8rmHlyF5w9/Pw2WIDQr1N2wDgoFjOYB3Ly24YVwr7SdXG
	FW8aQPYXbFM4+rV3+G8V+1k+rKiFDwHrMYHY7fe9wsGofBNe+BSBlvoGg8hV5K1mlA+TYQTtNRC
	RjYb034a3T3Bzc42CPukzzKbzsq+Yn0yhrADeqbl+Tw4cAuoM34xAtqG1wVLFChm0CxKcVprGnq
	WfLNiOvV679RPiqhLUtp/LeefX8McPjrYcFA9NOLXsT1MjcErQmeIxo42iumNjdOpODlSIqsoBE
	c1OU6k4UX/pq0nTO4IOKlZqCI2bTKjkv7FL8msbPMkI7qpF1yD5p2IMPnleDeO+lpo5Urq9YPW/
	IVOtwbMxW1AGRGRp8hNSsXqcGBh1lNx+ebcV9kDB7kPv8UB+PnojNVXJZ9abBF0TLT7eK6Xxoog
	LrtrkvwsGpLWxkXtVHwxSpuHI+DV1HTn5Ks7MTcaRM492V/Ea51oDrvmouGi1AuQ0kY961
X-Received: by 2002:a17:90b:314b:b0:35a:2ed:9b6f with SMTP id 98e67ed59e1d1-35dd65b05e0mr4834473a91.0.1775192461715;
        Thu, 02 Apr 2026 22:01:01 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c647792bsm4474251a12.6.2026.04.02.22.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 22:01:01 -0700 (PDT)
Date: Fri, 3 Apr 2026 13:00:53 +0800
From: Kairui Song <ryncsn@gmail.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
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
Subject: Re: [PATCH v3 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
Message-ID: <ac9GVguKyK44aYUk@KASONG-MC4>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
 <20260403-mglru-reclaim-v3-9-a285efd6ff91@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403-mglru-reclaim-v3-9-a285efd6ff91@tencent.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14C00160007
X-Stat-Signature: cragt36qwdixra79oewra7mo6q5oxhu5
X-Rspam-User: 
X-HE-Tag: 1775192462-30683
X-HE-Meta: U2FsdGVkX1/9ZsI+zGnOX/nJylkEoZVaKY6Rt40xh9K6zg+LdNEestb5d5OaQU18T1DZOUs3ELTSrGdx54Nn/qMbc4sP5TVyg0JeQz5zPbpPgdtboukiQsAmCgnm0OrVeBWXAjBXbZryo4razup1EUEN5sBg8SRFUrvFdxChyOazqxGE8mEdUjpH63mFZxyo3wy6ZPJY+NrXJRBsBq8IKbwL0O6fCtb76ZkcGnqWR/tPVRaZiQ7kO5OSy5xmkRrIhdr4RSFD1O77jtQMiOvSAskY3uG3vAd0VTIyFs0h5zTliCPyKiW+FCL5dTdEamf6p0OfeIUhfvxPBgGcvq+wIZOiXVeERoT55x1Jnhy6B7BgxsqRTeuP2q/ZujkNnWtnqQy9IdWqTL4TeQlDdEdlK6jiA/ArCZrGCXyQ/Ezdp2ncozclVvjbvwtxBT6CYdrljbyJIMfvihqveOi5m8HRNA34LA/WufKo4DPZkG6S9Wr67ZAkFM7SjRigUR5gXLmpT73Wjmy5lz66mk6V5xbCx4lvID+R2AzbkTqzGWGCo5rctFLPoW9uyz5k5oyy66gpbOhYTnSKpAh4jLVdBQfXcvbvEtYQzsrLYHxDLA0fRg5aV4zz80JGgvSZhHL09rOaLj50BMC4qNulvJpVxO3hMX1gFngB11mIvpLMfyc3Ks0gWvqKUdsOj2KUi5cdnYu7nmZMfTUCeqKC2R7fwzSEBwzg9domMlljZ0+giZeTlFth3PEzorDhOaiaMFALZKz6zbi95UOn571d1uimLWyqyhqJGL8H3g2VYUsQApjq97uesKuHH0d2+jdqk/dx8gbQZalUrGLBPQHqEaiKEHkznBwJPQ+9qcfsxbuIPIArF+iTz5MrtBuRNRUvlqeFoFm31gTsebnopDEBk13Z87LEXHT4lXt9ylYEVsFjxbTi7kwrlL+uoWkUEbwXCrMS6jJchs822NT0LTFYZUydzrd
 cBPrkUlZ
 QqRVcROG2ed9R2qjdQ6PSPDr/4VwwUmiN7TuDb2j5/p+d6XZUTHPTKzVKoodQs3XWwsn4gD6TFoiTG97Aw7dPGH4OXgzRBnJr4a1XmysXvdvPV1MUKCV3HGvHAv0qDpYHGniOgAmfPxaWsICpsXOlk8AK51mfsmA41IOFkHWwC8vB/Q/kAWL0GkUl9wQoGn5fnlfY2f+rn+a67U+sKhVbUrYrUQNnOKTZHh/NnS99TzuF93VyJdxJgPb94Clt7zLoF8y/rA4PaZExOmwv3ukVGeJgxSRU2beVGLyHFH3SW0DSQ9ascl+Sxs2MefKAYKHQEj1gTOWnzvhdjv+IO1GZX4gWR2tGM6pKddstFTB0A6dG++Q7KXKxoXVDIij7kW8EtVesEe4EkeEfKLHgihrIaRwwre4sdRy+tLvvYHGZYzT4vt4D301QwGLuZKiGJ+BFPUPxNrlDa7FUdinY0kB6NppNqnusa2HoL2sVzKOQJRzH8LblA9XZz6Fl+mYyn7shQTS5FJZqABgecyZe2AJ9S+kgRVWADG5qFNGKR7PGKWp7wPuDKsUW9ELLA0v53TGAgHe6OOkRdgU7v1AjWedzlsnvEj6RngvhFI0blO6a0HBcCxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review, which seems not a real issue but just in case:

> commit e6160f371a1c25f6b49b0a6639582d0636d9905b
> Author: Kairui Song <kasong@tencent.com>
> mm/mglru: use the common routine for dirty/writeback reactivation
> This commit drops MGLRU-specific handling for dirty and writeback folios,
> instead allowing the common shrink_folio_list() routine to process and
> reactivate them like the classical LRU.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9f4512a4d35fc..2a36cf937061b 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
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
> Does removing this explicit promotion and instead falling back to 
> shrink_folio_list() cause these folios to retain stale tier bits?
> When dirty and writeback folios are processed by shrink_folio_list(),
> they frequently hit the activate_locked path, which sets PG_active on
> the folio.
> When these folios are returned in a list to evict_folios(), it tries to
> clear stale tier bits by checking if the folio is from the oldest
> generation:
>     if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
> Because PG_active is set, lru_gen_folio_seq() calculates a younger
> generation, so this check evaluates to false and the tier bits
> (LRU_REFS_FLAGS) are not cleared.
> Later, the folios are added back to the LRU via move_folios_to_lru() and
> lru_gen_add_folio(). While lru_gen_add_folio() clears PG_active, it
> intentionally does not clear LRU_REFS_FLAGS.
> Could this sequence leave the folios in a younger generation with stale
> PG_referenced and LRU_REFS_MASK bits, artificially inflating their access
> counts?

Actually the new behavior is better I believe, clearing the ref bits for
dirty folios make no sense. We even previously had a commit locally to
disable resetting the refs bits for folio_inc_gen unless it's getting
protected by ref bits (MGLRU's PID).

The access count contributes to the PID protection, refault tracking
and things like PSI, leave these counter untouched should help them to
track the folio hotness info better upon the real reclaim when the
writeback is done.

I better mention this in the commit message indeed.

