Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F7BC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0686B0088; Fri,  4 Sep 2026 07:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39D86B008A; Fri,  4 Sep 2026 07:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901DB6B008C; Fri,  4 Sep 2026 07:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67AED6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:21:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF9F7140ADA
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:21:13 +0000 (UTC)
X-FDA: 85175838426.02.F8BD96B
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id EA1D71A0008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:21:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aYfyNRYd;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788520872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vUJDxGrlaCkyExJEdPQB5RU8TkXl0JZWU/oumMAWGE=;
	b=hYSKuzl/liYxiQHWAQdWpVMkJMJWA0SgkzBcaQQb2X66GKtRztR+zms6MQpz7AH6zj7uf4
	37fZ4eic8QmwXfk4Kqw/a+hCGhomAlwcX2/aBdSPYYHygfpKqewey/BCFA3B8Ke+VzWzE9
	TKOYohmHOJSgVSlNRc7vqRwymochYbE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788520872;
	b=Vgmn12SiCsdXiQSJitRcJhueXE9hvKvmGWPWj2Pj9qXtemvzmjyroLpWeCDvH5vSF0+opy
	QulypOyg2Z7a07pOAiojS+7A2oUv0uCr+gyo0+HRV0DE0NUJgper2drpSwf5E9olUfS3h7
	SamK1/+ShasmNZk/YipqxXR4dfHTNq8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aYfyNRYd;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-485850cf499so480047f8f.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 04:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788520870; x=1789125670; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/vUJDxGrlaCkyExJEdPQB5RU8TkXl0JZWU/oumMAWGE=;
        b=aYfyNRYdsrdX3D5sluSxgPvWHoLbX1Sv5oOmyI4qn3RaOZO1omdGc/j/o4vuWCJt8W
         i7kzPEIZWWey+ZoR46Y0VYw7m5MVgRq7WLMX2XXNEfN/K+5gylziCemitVTAK7aLpxpo
         ODULAifLxYE9SgMc6uwrKAbD9Q0/03QIgUk4OXEZQsSn4B0oMLLmfcr9cSvkFqrEVdom
         CHe+d1TgZJ2RpHUwcbl0vfPVPRwbnCjS02JKpI9+Xhx69iHe1T+7UJYx+JnI4qcGsWtN
         ag8xr0HYq7V5HYFj+Ch4BXcAf+pCIZAh1Gseu9v00PaB/VltmwJvnfzrOTobcj5ND6Mk
         IkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788520870; x=1789125670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/vUJDxGrlaCkyExJEdPQB5RU8TkXl0JZWU/oumMAWGE=;
        b=pOQqDsNGr/Hjy+PuKHEsDS0LQXcCJdwP4jH3g/A9OWQeJXxJnrn1znSQt0R17Zkx4I
         wmo17Ytx6zb1fe/+pJ8SK50gIoHi87atmgfxzNY95io7qNva0k/CsAkzXn7ex30wIalT
         H92ZOi84v7k3MmjtaHfONfFpjWnDFnLUadpZMYgFbBWpWCHil6Cl3VKNejNjr1u26+9T
         IZLAJsD2UCvAWuhhwimwlRTTf6eCFhRjPo7Il/64PHxzWZBckhooqMnS5fyI87lfY+ZY
         e+BflOF2x10Nj0e61sNIUOu08NU3BTlSeTk5E05ZiOEiTbBkwRE7+4j3YUluHGT/POGo
         Y59A==
X-Forwarded-Encrypted: i=1; AKwUvBzWa7Ta0+IppJYSyrreiWWmIYXzGjj3XOZr0zcUHKFQmZlUNV6vYGJmFL9aTHFw7PwcH0tP+cfVlg==@kvack.org
X-Gm-Message-State: AFuF++mLtNaFp55eoMQtFua1bFVm91zGF8wGDjKTLcDBawtx/kDJ7WB2
	yWYzMucU4KK8DLzOBB22HOUM2eCzDWjtLdGGsm+mYnC6Hii72bCsOYSZ7whPLcvLhXs=
X-Gm-Gg: AYBFou2Hc+RaPGtu6IyKzVgifc2VaHeskP/FlH9gI3G5t5G6Ef1pTs+Z3x/ggCSgb2c
	IbKrTL8ZeBbX4zcYaqrWct1d9bd5R/qsH/JCE3uIuWdGaUJqP/Hzx8bk/tPh8FnVNDaoY88Wdig
	BTBo47dIedpiWqqmWjND6wJ2/frlS13w7R3ibI9gey3sIEqh7gxJclE+b4GxVqreJ/7leNIorg5
	jso61jRwfyC7AhR6yePHJi864tcda5Yxk1SxScSUpmRt2VuxnlJEYNWlnw3kecKHxNye5JTGvVj
	UR4wG0p6rpiDpsFvAAGn5LW7e2X18EXoIlIPmMqi1F6tbjPG4DyU76XDy6NqHqnWaI1FkDaWysu
	6+cAGxDyPKPu41zZCAUEtc5XkePQzwsYofWLRC6Z4eWu4o1jpPTZ4SPxWoml9gnLRaS2G9IhjyP
	31RYFKlSFWS3I09jJ+Lk6fT0IRLc9J9bH0m0dn1+9CNlXORHv2DESIs/2JQvksggLbBlMj3cyBV
	w==
X-Received: by 2002:a05:6000:1843:b0:485:8c17:975f with SMTP id ffacd0b85a97d-4858c1798damr2665575f8f.33.1788520870405;
        Fri, 04 Sep 2026 04:21:10 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885be01bsm5223760f8f.31.2026.09.04.04.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:21:10 -0700 (PDT)
Date: Fri, 4 Sep 2026 13:21:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>,
	akpm@linux-foundation.org, mgorman@techsingularity.net,
	david@redhat.com, vbabka@suse.cz, hannes@cmpxchg.org,
	quic_pkondeti@quicinc.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
Message-ID: <apqppFukssaAQz3w@tiehlicka>
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com>
 <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA1D71A0008
X-Stat-Signature: nzgezg4e4nacswb85c7x6wd1t7xhntr9
X-HE-Tag: 1788520871-520705
X-HE-Meta: U2FsdGVkX1907Cz9KwHSDuC3pGqngazlXCGdriMg6EsfVuzcXo9xraMQ6sFeUWG2npKliteh93rCHtAFRjM9a8QHrfRHdLx5rh/xW5RHYTx4BHJ9XuMs0tUYeWEbINswZ+v1z8WrHdYHaN8dGU2dK4AAhBZb4Fow7GD0m+FLtAlAVRB3ktcTPNfSXNwkhSMc5Kqb62heI8deAp439ne7X7+lKqOd6HcygY5yO2+oLNb4K4/d/01Kbw0NPphOMgwtNGpzeLCIUSiN++5yqUYQo/t9lucA7qUjRffJ7w29KPVsd8GNQxfhG/05XHMx8bAl/PKDYgbjE5NOXOCBU0rP3r3yMV8WUM1fInNf5WdmhPujL3HyOAHDmqgIyYqcPXWLdpXZhamN/029oLrri++VyGxDua/ZOkjya4TDWc6ISpruXfTqaqeq9ny4Zp3QmhrHUQquSrt5GA+FS2M9znH0Xn0ncaW3srU/wFWmoKZzho9zcXFN/mXwSO7LjlrBi0WmliO9URX9EmgzthZgFwSwN95rpV95O3+rnX5Box8fhQDFI4WJRLgunNCENxr6w2QSZOUi2akO2g+MYZ+XoKC/rbCe0a20TLjqpG86QA/QZOFt0kVlbp/2g0bMCHtLAeN9Jfp98vHOVD74KMkLtJq4cc/07ZU3NY+0XGldLfOouJ7foN+YgnrPQG1X3MRvK+YcVWvFqoBHknKH+KifpV0YJgDhWO1nZHI+FpXQH7G5RouIKdfhYUfz9EsyPoM2PR3ieqVlZUIxnOaxwgta2heSIK+7adyhB3b2Punxo6XgMRhn3ykK1bDksEhef+VRbT8q9EVCES5eUM24YQ1YZ7Dea19i+IIE92sZ782ZMBNboQ+tI1bmxhtdR4ptIcmzsX6Ppvq++90YHt6y5QWWlwv5URl0mNbFpLfglvretoz9oAXGi8DmhlK5xQaPXN4MTE0+jH5PdNNYyIUFhXkSGA7
 /vTVZi9U
 Gr0Vanj/BiYl6CpxNDEkmwlKlnasdF1BXHyEQzo1uL45zcUFBGH8lBYY/GYGXTnyMnz+E3msej5OOd9Tr+S/loPWfkauRysMlXeNQbPN4iwanI6f3VUW3X0L9+XgL8GI79WKANaCOHrjkubAFivFtZjProZKrwEo4kFfhFqomtqupch8QU6DLG/tgD26yEGERXGPqBwogUTR9YKlfetgGBM3eUOjp34e7Xi/Sz3wSaOvlVH6H0dYbhRspplSxhOdFkajyGboTqqqqD6WHakuG+zXVukIvpK1+kbdtcNRwCB/szVK47oPjWfzskqVypvOo08EQd7BwSbgEl/b5ZPrLlVI753RIxr07W74PE1qqOO/vqQI9LHIGtrE7lzdbf2SRvu+3ys4fGu0wc7SR69oN83FHITxc2NU3fr0ruspQEpHLzocyDTh4rJ7y2kuqanH3myTKq7x10Wdp/H4S81ViiSU1/1+llMsyfZlrtdRfjj/zrGytcEX9Y9p+lze+97YsU/ovAgN4fAbXmWljH1eR5tnbigq4yBtrXiJo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 03-09-26 07:03:33, Yosry Ahmed wrote:
> On Thu, Sep 3, 2026 at 12:27 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Wed 02-09-26 16:49:48, Yosry Ahmed wrote:
> > > On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wrote:
> > > > pcp lists are drained from __alloc_pages_direct_reclaim(), only if some
> > > > progress is made in the attempt.
> > > >
> > > > struct page *__alloc_pages_direct_reclaim() {
> > > >     .....
> > > >    *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> > > >    if (unlikely(!(*did_some_progress)))
> > > >       goto out;
> > > > retry:
> > > >     page = get_page_from_freelist();
> > > >     if (!page && !drained) {
> > > >         drain_all_pages(NULL);
> > > >         drained = true;
> > > >         goto retry;
> > > >     }
> > > > out:
> > > > }
> > > >
> > > > After the above, allocation attempt can fallback to
> > > > should_reclaim_retry() to decide reclaim retries. If it too return
> > > > false, allocation request will simply fallback to oom kill path without
> > > > even attempting the draining of the pcp pages that might help the
> > > > allocation attempt to succeed.
> > > >
> > > > VM system running with ~50MB of memory shown the below stats during OOM
> > > > kill:
> > > > Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> > > > reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> > > >
> > > > Though in such system state OOM kill is imminent, but the current kill
> > > > could have been delayed if the pcp is drained as pcp + free is even
> > > > above the high watermark.
> > > >
> > > > Fix this missing drain of pcp list in should_reclaim_retry() along with
> > > > unreserving the high atomic page blocks, like it is done in
> > > > __alloc_pages_direct_reclaim().
> > > >
> > > > Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> > >
> > > [Sorry for thread necromancy]
> > >
> > > Hi Charan,
> > >
> > > Are you planning to respin this patch?
> > >
> > > I know that Michal was questioning the need for it. While doing some
> > > stress testing I came across a couple of OOM kills that had significant
> > > amount of memory in pcplists. Something that would have been prevented
> > > by this patch.
> >
> > Could you share some numbers to see the scale of the problem?
> 
> Sure, here's a sample from an OOM log (ignore mapped/free_mapped, it's
> from the ALLOC_UNMAPPED series):
> 
> [   40.336188] Mem-Info:
> [   40.336195] active_anon:96 inactive_anon:1540181 isolated_anon:0
>                 active_file:51 inactive_file:0 isolated_file:0
>                 unevictable:382720 dirty:43 writeback:0
>                 slab_reclaimable:20339 slab_unreclaimable:26597
>                 mapped:382858 shmem:153 pagetables:8291
>                 sec_pagetables:0 bounce:0
>                 kernel_misc_reclaimable:0
>                 free:17264 free_pcp:16890 free_cma:0
> [   40.336199] Node 0 active_anon:384kB inactive_anon:6160724kB
> active_file:204kB inactive_file:0kB unevictable:1530880kB
> isolated(anon):0kB isolated(file):0kB mapped:1531432kB dirty:172kB
> writeback:0kB shmem:612kB shmem_thp:0kB shmem_pmdmapped:0kB
> anon_thp:10240kB kernel_stack:2576kB pagetables:33164kB
> sec_pagetables:0kB all_unreclaimable? yes Balloon:0kB gpu_active:0kB
> gpu_reclaim:0kB
> [   40.336202] DMA32 free:34808kB boost:0kB min:11028kB low:13784kB
> high:16540kB reserved_highatomic:0KB free_highatomic:0KB
> free_mapped:11032KB active_anon:0kB inactive_anon:1487720kB
> active_file:52kB inactive_file:20kB unevictable:393252kB
> writepending:4kB zspages:0kB present:2096760kB managed:1991156kB
> mlocked:393252kB bounce:0kB free_pcp:42404kB local_pcp:2460kB
> free_cma:0kB
> [   40.336205] lowmem_reserve[]: 0 5976 5976
> [   40.336210] Normal free:34248kB boost:0kB min:34024kB low:42528kB
> high:51032kB reserved_highatomic:0KB free_highatomic:0KB
> free_mapped:34028KB active_anon:384kB inactive_anon:4672764kB
> active_file:180kB inactive_file:0kB unevictable:1137628kB
> writepending:168kB zspages:0kB present:6291456kB managed:6120144kB
> mlocked:1137628kB bounce:0kB free_pcp:25156kB local_pcp:764kB
> free_cma:0kB
> [   40.336213] lowmem_reserve[]: 0 0 0
> 
> As far as I can tell there's about ~65M of free memory stranded on
> pcplists (in an 8G VM), which would have kept the amount of free
> memory above the watermarks and prevented that specific OOM kill.
> Although, as I mentioned before, this is a synthetic stress test.
> Perhaps in practice it doesn't matter all that much in practice, but
> it seems like the logical thing to do.

yes, pcp lists are quite (unusually) high. Is it possible they simply
got repopulated after the first direct reclaim run? Or is there
something else(odd) going on?

-- 
Michal Hocko
SUSE Labs

