Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEA8CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E7D6B0005; Tue,  2 Jun 2026 11:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3F5B6B0088; Tue,  2 Jun 2026 11:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06DF6B008C; Tue,  2 Jun 2026 11:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8A936B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:28:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F4A01A095C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:28:25 +0000 (UTC)
X-FDA: 84835354170.01.41AD359
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F8D240012
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:28:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CZd1HqFP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KioD6muOq73KOuZgXUdfc8mghtZCf5WX4ci2/jt07rE=;
	b=XosKu5JjXpl1CsX3crgXGxTHdY5gknm/fbQIREfKloGP+0frnPgTez5B8qkRq8Abep2VaP
	tB3Bi+maJw9OpIVIveNRD+++P2pOwtCO3mOjh/xXFn3Un/svOfjiKpk7rYFSkv4ZixCmvR
	NocwiFSY8fIvP3OiEsAx+eN740/jrjQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CZd1HqFP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780414103;
	b=1+Xpmn2nDOcwwyD1lAsUEqBQ3IFI/WLpiMzk/9tdCCYhqc4gqOJFBjhw57F3kb0jdmb8yY
	DJPVFY/1rVwhE6AXRlyHUoFrZ8lDQ7loJ1ZjYE7uObxnvcD8aZqvHUo+uQBLyUWJw/EBlw
	0ASgLscSEJ0WiAmso2n404ArCAcoa8Y=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45eec22fab7so2920690f8f.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 08:28:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780414101; cv=none;
        d=google.com; s=arc-20240605;
        b=PFX3A29HrUB5Qxk4cOQ012WI61OsaGh2oBl6gcwcrp6Kax76dRXCSoTnluMip7qutW
         6KxwhlbCGQOlwwXJezVmiuUkdJ5fFNpHdQEhQ5i9wpqKTVvNR7luEgWW29RMFGp0ab7R
         fQn2CojKx0eb1so5v6Kuqfid5JSqZMW7q6VZ4vNfmfbpJBsRGu628QvoUHYj0II9Uqmh
         EnYzybusVIOpGICH4rj19ZjmAo1GZgbHuYtLUli2I2Zit4xgQ6LQuE2fcp7Td/gdOZmJ
         Mv9Ro1PdujnaKLcWD5vt+A55YJ3gWUP71LI6pXCoLtop1YJ29rwlZ/Inhb/sxEGpVeQ9
         bTWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KioD6muOq73KOuZgXUdfc8mghtZCf5WX4ci2/jt07rE=;
        fh=rCu2fdRPKDR+Zz0RbckTbejujg31mTiP0URfWc/BQxc=;
        b=lHjCihSwSK8qIdH7AQt1h6QPDkrRcqQ1KjAsG+5ZaeULQFmnJPtAQnDTSTVdoetO8r
         7ekyeJLXeYfsWus4byw0PttzrT0QoJAf3AF/GD6rWij2ccilXQrvgQblAQh5qp3FZdQa
         bLePpMOAwP86z7hHXlO0paE++K+AhkmCmsT+pqzLe3TR50f7VvLS4Pb5RCeRmT41cbgu
         7K4g1m2eNACS+aCtO2aDz7GjrIKKvLlXhRsSXmhrFsPbQMR+M+HHjdraaZ+v8RY/Jqfd
         EYAYR0xrAQOxl3WOiZGboRhMiKNIZ9c5t8SPLLulq8POK6fLXQaBJ/PLZy3gzRS6VHHD
         I6Ng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780414101; x=1781018901; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KioD6muOq73KOuZgXUdfc8mghtZCf5WX4ci2/jt07rE=;
        b=CZd1HqFP/r8BfOLnw4mkM99+oHo/BII/DwIW4tnMVEjE8wef58Ozu4YJJe9hmXhGpu
         oimYC0E2e876uJy9LnBXqDzqybop/7RSxrqzz85jyEx87iDqk/1Eyzbfb3aDMP/MsEFJ
         RvpjOwyIdF5XbLxkEv+eTwwRKTqLXdOJXc4r+c4muz5ODFqB5zSoEfpD8/e+nXqsWVtE
         hXcTN5zO6kNvJ2wuP15RsmAt88Q5h9e2T3fWkif8I0NwVV0OcOHXGnFRI6h47foGdQj6
         qIlkMRQQYykLcESbmRS+K8aQAoPg+kRFcM7RSF/jasZcUpk9l6cIVBa9Sjtsv/KywV6K
         JbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780414101; x=1781018901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KioD6muOq73KOuZgXUdfc8mghtZCf5WX4ci2/jt07rE=;
        b=CQXQxigCQCMfHNT/59P4mHojEMvOir52RsHs8eoXipPcTStOyxgncboEjNEHWkra4y
         sfkEZuG9JoPKg8f8zLVdqugJyEkTUlkUOQinQ6KEwHqKsMhHixH0qTzw/bhZgu6UbWK/
         90Tb7dHPAVwNlYetpj+YkJR9mY3yTWqvsnARnowoMaKSKWBazKMg7/tVb6S0bCcU0KjG
         QUPRzJmioCapajVpFIF/s/9wdMH0nsPalkF8hyYeEcGFRd9C8xjjzfUhggNpaGTLl/ur
         zXC/k7gcEKfS9qsTidXKQLPstTd4Io9VFqBLShCDy4nc3z1LRU17R00dJZQDIWMNbRdj
         kDSQ==
X-Forwarded-Encrypted: i=1; AFNElJ9PSz5pgL6Sf7snDg30mWagS6MjiDNqt763AVeZRzz6SxwZ3wUkeSqc5jl2j0TwE8LuPYSv/LVlXw==@kvack.org
X-Gm-Message-State: AOJu0Yy5ICVQYiwfOXQEfeJyWREILoNImbvJmkURxPd54duPZDHb30Fv
	m2cIoJP+gwwYqwfwt0vsstltYJuh2HKSirt5B8cEPrxsQebGLx9dlBjdNrWSqv/hTeZw0gNytaq
	9usTPalNR73iYcfCyrBtZLSb8WAHkgTg=
X-Gm-Gg: Acq92OEsNUPFTWR9G8o7o+jfrWDcI2O5334ggSOH8gWYHDaaN/hCGzKHac80tHcfAfN
	Yewbpcrr04/I9Mfn9TUAbYmWg5+EPFKOlWNlAbCu48hE5f6oPKmEptJWKwrlbOcLWe8FSDEVq0E
	gxnedSr5u7+zcpAi/1g46vFB91NSlDOBIK2BJ89639mDjlAJxaeu71Km0VbshnjVXapnlmwdUkg
	LaqdIdpLJtgD3ILS5T+c2/1LbRwcfpeOdKTfJcV8NwZ7BBVRDt3fVANdXaDT0FiMM+aYmCnbVdt
	rCWQq3Z+X6v301yQ24VZHxAb3z3CfW+LdqiykGzqVPEYyBkppQ==
X-Received: by 2002:a5d:5401:0:b0:45e:d6b2:e6a5 with SMTP id
 ffacd0b85a97d-45ef6b83764mr21337268f8f.34.1780414101045; Tue, 02 Jun 2026
 08:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
 <CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com>
 <CAKEwX=PmwzaJhfjBrho3+kQ8HXFUC0WiegQrsguBc-_pmn5bSA@mail.gmail.com> <CAMgjq7D4XsAD4NGDL7FC2kaYAQAP8PDJdn4bpzGZwXYtjEpJ6w@mail.gmail.com>
In-Reply-To: <CAMgjq7D4XsAD4NGDL7FC2kaYAQAP8PDJdn4bpzGZwXYtjEpJ6w@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 2 Jun 2026 08:28:09 -0700
X-Gm-Features: AVHnY4IWURpsnvI312VbRdsgEkqVndHtTZWSNA7JxRNHqCQ-2eUuyz0lSoO1lo4
Message-ID: <CAKEwX=OZL+ykwTjZJzUDAEnTOO6B0mibc6dxiYtmnoLReB7TYA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Kairui Song <ryncsn@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F8D240012
X-Stat-Signature: hdr7a781dmbmq11cf5ucgai4pbfasbjo
X-Rspam-User: 
X-HE-Tag: 1780414102-433505
X-HE-Meta: U2FsdGVkX19LQsxwI6jbHHG6WhOEOAusPwOy35BHqL541mT5tyErjwSvHcMk2SW58OXsMeItcMQ9ycZKZjyDbcouIQUxozzTGuf/wy74HrrC/QJfP5x4fLFsDNY2ttQTysPzZNLGjK0pFfleUBecqYrbB20xiOc6TyvRFetMktXFmEeB1qV96q5qj/NZt16+iA7KepzrzeTE81St45CF9sw6e9ocBMQFW3AW+GP7QiqqMmwEP6v99REAkQ45jwBJ/RddZ7LA5Msr7JCtR5a3F15qBYERwCt9l/xKZ1/h8zyX998byzVePJJTxE5GGfPv56/5DejXTS4k7jQmMg7OTWznTusQzzqeNPZfooVBdLWoUPvv9MUvm550Ris0LcJysdk7mVNjLz/K4pb8jB76Ad2+bZhgZ/knUxCLQeRoubYsW+5/PSqAzjPCyroJEP+BVQ4YHsZv0MNkJTmDzwX7ST/lEVE1w8SyKQd3Me+bI4fwbj53iHTJ3qFz3u8mwOlrjk04cyxmOi5jr8flyI8CjWfDYY/dflAP+FWPcrJZiqhttX8dUWVTMGwtGu2Mxrfut9VghYEmY78DpkIHynfTDkHzPqe2UgwzzCj7WuaQBq8E1b8RR4fMg69/wHEQdL+X70FNy75pqT3mMGEFXKENo8X1fiSMKNqUmHrpsajlq7HPAdaMnEHl3kkXb3hfZppvLgUDMph78obnn+a7ZZt7989I7y4o/eDukASqU+yYRilm6Wj/31mBaIM1ROCA6TO5u3FvKxf0KUuKWp5V7Dpe5sZgYfMpmZCleUWEzvC/1bAMP2v/dj3YBs6D9zSXWXHKPLZSip/E28V6xQ9blqjd2cqhAJLGdR3W2kUXRVwuohNpnJ22BkpJZKeWv5bESwAiowlWRPgDF4du9t1eDhG2gRDvVIFZ28EhRT2imluZE58Rziyi9f0TVhME1FqkegfxTR/Nf/u14rIaHLkNVEI
 mn2mwmOG
 GsD97aQSsPPuFbdtD+vwldOVcJf4hSVEt8NAAbPhDb2UH492u7E1O3XKtecP9dXWh5PXnztgeOEFJAMDvLyC10YABUlEofHK/+h/OuwGW8YYTlzIS/+WjTqRhsTdX8gTtM9bHocvrQW9vPbgmn2DAIyqitZ4kHRXC3g1T7utLGsIiplO63lb/L9TSTl7iGohKF2WHPaDXrkNRONwPAeTUz9Tx5aShD7tV9U2mZngaHydYGeSyhtwET+uHNpVs2qadUR5q1a2l91RGq3h/iZdyKN4dBLTGXb++3znR+vWqaUS1jq9/9hkEE7RsGcORHrd5SRhuNw1DiJMPBCZGMpRmY08Bl13313csWnCAlOjoKVmwo6rEN8tjE0n/I8Q3nzcjRgGPqSmN3cixu3HZcEHJBgYBnbEcx6VXFVrbU9cCBCARenIPPzChjXaBBrW+69yKO0/Gj33ga3vZg6ru8PlhWX55DLb7Krn34724X+JSCoux7aiQCkgIGW0q3fex/Ddx2+Onfmddz2tJsseFRiv2g49JQmVIQeD84Brsh9ww3ufPIOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 8:25=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Tue, Jun 2, 2026 at 2:06=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Mon, Jun 1, 2026 at 10:45=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Mon, Jun 1, 2026 at 11:57=E2=80=AFPM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > > >
> > > > Are you suggesting we merge the virtual table with main swap table?
> > > >
> > > > Man, I'd love to do this. There is a problem though - we have a cas=
e
> > > > where we occupy both backing physical swap AND swap cache. Do you
> > > > think we can fit both the physical swap slot handle and the swap ca=
che
> > > > PFN into the same slot in virtual table? Maybe with some expanding.=
..?
> > >
> > > I don't really get why we would need to do that? If you put the PFN
> > > info in the virtual / upper layer, then the count info, locking, and
> > > all swap IO synchronization (via folio lock), dup (current protected
> > > by ci lock / folio lock), and allocation (folio_alloc_swap), are all
> > > handled in this layer.
> > >
> > > The physical / lower layer will just hold a reverse entry on
> > > folio_realloc_swap, or no entry at all (no physical layer used, zswap=
,
> > > or after swap allocation but before IO) right?
> > >
> > > Looking up the actual folio from the physical layer will be a bit
> > > slower since it needs to resolve the reverse entry, but the only plac=
e
> > > we need to do that is things like migrate, compaction (none of them
> > > exist yet) which seems totally fine?
> >
> > All of this is correct, but consider swaping in a vswap entry backed
> > by pswap. There are cases where you still want to maintain the pswap
> > slots around backing vswap entry, while having the swap cache folio as
> > well.
> >
> > For e.g, at swap in time, we add the folio into the swap cache. First
> > of all, we need to hold on to the physical swap slot for IO step. But
> > even after IO succeeds, there are cases where you would still like to
> > keep physical swap slots around (for e.g, to avoid swapping out again
> > if the folio is only speculatively fetched).
>
> A reverse entry is enough to hold the physical swap, just like how the
> current hibernation works with a fake shadow, you don't need a PFN
> just for holding that.
>
> >
> > So you have to make sure we have space for both the physical swap
> > slot, and the swap cache folio's PFN at the same time for each vswap
> > entry. So we still need the vtable extension (well maybe the other
> > approach I mentioned could work, but I'm not 100% sure).
>
> Right, vtable extension is fine, there is no redundant data. I just
> mean you don't need to set the PFN twice (for vswap & pswap). So
> simply reusing the PFN format in the vswap layer and solving
> everything there should be enough.

Ah yeah, then I might have misunderstood you here. I thought you were
proposing a way to remove vtable :)

"don't need to set the PFN twice" completely agree. I'm pretty sure I
did not here, but do let me know if I accidentally set it twice. I'm
be sure to check this myself for the next version.

>
> > > Thanks. Not too complicated, actually our internal kernel
> > > implementation still using si->percpu cluster, and use a counter for
> > > the rotation and each order have a counter :P, it's a bit ugly but
> > > works fine. It still serves pretty well just like the global percpu
> > > cluster, YoungJun's previous per ci percpu cluster also still provide=
s
> > > the fast path, many ways to do that.
> >
> > Sounds like something that should be upstreamed? ;)
>
> I'd love to :), there is a lot of work going on as you can see and
> people seem to have many different proposals about this so I didn't
> prioritize it. I'll try as things settle down.

Yeah understandable. It's a very volatile codebase, with a lot of
folks trying to improve different aspects.

Hopefully we're close to a unified design :)

I'll keep my dedicated vswap per-cpu alloc caching for now, but I'll
get rid of it whenever the per-CPU per-si cache is ready.

>
> > > > >
> > > > > For patch 2, a few routines like vswap_can_swapin_thp seems not
> > > > > needed or should be moved to __swap_cache_alloc? VSWAP_FOLIO is
> > > > > same as swap cache folio check, which is already covered. Same fo=
r
> > > > > zero checking, and VSWAP_NONE which is same as swap count check
> > > > > I think. That way we not only save a lot of code, we also no
> > > > > longer need to treat vswap specially.
> > > >
> > > > Unfortunately, I think a lot of this complexity is still needed. Vs=
wap
> > > > adds a new layer, which means new complications :)
> > > >
> > > > For instance, I think you still need vswap_can_swapin_thp. It
> > > > basically enforces that the backend must be something
> > > > swap_read_folio() can handle. That means:
> > > >
> > > > 1. No zswap.
> > > >
> > > > 2. No mixed backend.
> > >
> > > If mixed backend means phys vs zero vs zswap, then we already have
> > > part of that covered with the current swap cache except for the phys
> > > part (zswap part seems very doable with fujunjie's work).
> > > swap_cache_alloc_folio will ensure there is no mixed zerobit, it can
> > > be easily extended to ensure there is no mixed zswap as well
> > > (according to what I've learned from fujunjie's code). Similar logic
> > > for phys detection I think.
> >
> > Yeah it's basically generalizing that check, and handle the case where
> > we can have indirection.
> >
> > I mean I can open-code it, but it has to be there :) And I figure it
> > might be useful to check this opportunistically (at swap_pte_batch,
> > even if it's not guaranteed to be correct down the line) before we
> > even attempt to allocate a large folio etc. to avoid large folio
> > allocation.
>
> Right, but swap_cache_alloc_folio with orders=3D<large order> won't
> attempt a large allocation if the batch check fails, so that's fine.
>
> > > > Basically:
> > > >
> > > > 1. For vswap entry, not backed by phys swap: record swap memcg, hol=
d
> > > > reference to pin the memcg, but not charging towards swap.current.
> > >
> > > Maybe you don't need to record memcg here since folio->memcg already
> > > have that info?
> > >
> > > I previously had a patch:
> > > https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-7-104795d1=
9815@tencent.com/
> > >
> > > The defers the recording of memcg, the behavior is almost identical t=
o
> > > before, but charging & recording should be cleaner and you don't need
> > > to record memcg at allocation time hence maybe reduce the possibility
> > > of pinning a memcg. I didn't include that in P4 just to reduce LOC,
> > > maybe can be resent or included.
> >
> > That works-ish when the folio is sitll in swap cache, but say if it's
> > vswap backed by zswap (and the swap cache folio has been reclaimed),
> > you need a place to store the memcg, no?
>
> "Backed by zswap" means the actual swapout already happened, which is
> the case where we always have to record the memcg info because the
> folio is gone, seems still fit in the model.

Hmmm I might have misunderstood you in my last response here.

So what you are doing in that patch:

1. Charge towards folio->memcg when we allocate swap slots, but do not
record or take reference yet.

2. Once we reclaimed the folio after swap out, then we record and
acquire reference to pin.

You know what - this would simplify my usecase. For vswap entries not
backing by pswap, it *basically* just means I skip step 1 for vswap
backend. Step 2 is shared for all cases. Donezo.

You're right. This is simpler :) Let me brew on it a bit longer in
case there might be something we're missing. but it does seem like
this will reduce complexity (and with the added benefits of me not
having to come up with names for helpers).

>
> > Just seems cleaner to centralize this info at vswap layer when it is
> > presented, for now anyway, rather than juggling this on a per-backend
> > basis.
>
> Zswap charge could be merged with vswap I think but pswap we just
> discussed that we might want to charge it differently? And actually
> vswap charge is still quite different from zswap charge if you want to
> make vswap infinitely large? I think we can figure out this part as we
> progress; it's not a major problem at this point.

That was because I misunderstood your suggestions. My bad :)

Anyway, please keep the suggestions and recommendations coming :) I'm
playing with some of your suggestions right now, and waiting for other
folks' inputs as well. Will send out the next version at some point.
If there is no fundamental design flaws, I will un-RFC once I've
addressed all the main issues.

