Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5AF5C79F91
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 03:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7176B00C3; Sat,  5 Sep 2026 23:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98446B00C4; Sat,  5 Sep 2026 23:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86F66B00C5; Sat,  5 Sep 2026 23:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8880B6B00C3
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:56:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C6EDA47C9
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:56:38 +0000 (UTC)
X-FDA: 85181975676.13.6E00BFC
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EED6C0002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:56:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTjEx3hH;
	spf=pass (imf10.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788666996;
	b=UODhi87JFYlKdFNtF+ckmAryFq3d/f5Eus6pYY+mN0ZcBV9BYPWc0K7j3CuPbZIcVg8svf
	/VbySdpf/4tyET+RvRqu+pd+/O/w16UCr+MGMsB7t7Iuhe1WIHkWs4xFmyht+0qR8A7WZ7
	yZnNX9D19tJ3KlNfh5FVBSJLGzBvoHU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTjEx3hH;
	spf=pass (imf10.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788666996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFIuZ6zIqPPlmMH3AGzmZi9cqGjx6Zhr5KeBymliPYQ=;
	b=ejoyFP8VxWt3YpTUbdEIELUxDDk7np/W0fBvQdLyd35MzImiGkPWDkiXUB+0U/C3dCNEAf
	sLeoHil7FjjvPA7pKYYEtmfV+UKOmoehGNyFTejZ78P/wmFrO/65CKjXLaCaijHIJ8Ossz
	p43GtdLTScN/mViK5jnmbltBTxi2Y3Q=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d715f4a587so34269215ad.2
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 20:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788666995; x=1789271795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BFIuZ6zIqPPlmMH3AGzmZi9cqGjx6Zhr5KeBymliPYQ=;
        b=mTjEx3hHID4ggbFEZKuoeTZOYOywv74v9rpV90KpufIdmEld8OK3t7WMDld+vV2v/G
         /H+Q6Tfl3pjFAoAN//UY4EF8NWfqJ41YUpZt3DEjdcrTFuJnCQWTFxgB7bL9mjvdA65H
         TnTX7uYImBHAGOm0bIf6XrfyqBvvwUcU0qxd7N3wkcBe9KZP/MnEAdtxtVvuQhW3imcy
         V0hKy3m2Hn+CT4iqELNiMZxi2ATFG6nyniN8Z6p249f7DnOZ7U9eXETDihqJ7BAinGXc
         5v0BD7GB0IKPzkKLD68QkeAlw+Kd6DO01QIJEvHrru1g8tEyKS6cOuMJ19C2DjoD0TUj
         luRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788666995; x=1789271795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BFIuZ6zIqPPlmMH3AGzmZi9cqGjx6Zhr5KeBymliPYQ=;
        b=nlmuPQbxx2XC6/2cDLgOGuLmHo5xvyk2p6hNI0QP3vaWgc3P86L79EzSQseRHA1+M8
         p+Fbz6Ly2dWbTTgc65LqLYah1zb1pRj+pCJTRUhGAAl3eBK+252gYK7mk3wBBMUzntGD
         9JbmZYu4DrLL+OSK/hUdMCrOOqN1Z2P40oWLRM+JsP8JBH8pTrEPhaCcYDULco6EqGMf
         OEn1Q5xPUs04Hgahz+EJzrgu4IwloAJxUkTo5n76swh1oAIe8UnwWxcVfTlK4oTNW6WV
         vXB9AP90LLUQtfqfH7gXnbsJCguI937haLokmoVi03eaFptSuWgCpTq6iwK4W7gN+bl5
         zeeg==
X-Forwarded-Encrypted: i=1; AKwUvByOx4TiVNRrGXqfNCZuGemfUEN6NLIB/+fjJzIBcmTvR6B2ogl7bI1wc+O4h6csJ4zXZhhqDUp4RA==@kvack.org
X-Gm-Message-State: AFuF++ne3oygVOZOkilprp5YMGqIPFTsbVm0OxIKykt5KGjAV/7PMkV6
	vEWAAGfAECq5xlUD0RSg0dCALCGIvMQSvuVz9F4c4ehio1DmrZkpoXDS
X-Gm-Gg: AYBFou2Hh1qqSdSY/9J//4dO2VKmb/jS8gZ6RWUJ1+T7lVLhB3qFXJ3OphEOSxhKSHG
	DTrOcmGjsbpEumEH+VGuaGC/nC79kAamyPH/hZoIMSdJskoxk54SI3hhI1qn/m3d2vz9eO55mL5
	JhLzwrNGltto6NRlNSWH1M2ao3OnB+TJCTTS39SeTrP59Q6oxBsBS+jK+ihOFwJABZSIGxd8vDI
	oUKwekBJtihQTeiInKZ5PcEa+FmCU5MepqjxQ8br4Kthu/jZtPfrAKnFcZJDKtK3n+A0epXgXQO
	IwWSHSgVIBfiMGv05GsjRE8qN4I3+OQM80icC/KxkY84fxSgzjRxprGzyl/+5fAHici8CpKV8T8
	ZjaDNnDlbCPONTcuiq7hS2HC//LqEEsOxMxI2mGPedQKENboA8QonQHOOfaHEHieYpwfjmvrQXr
	G3q+1z7PlL8i//CaZjlpv2WN4xmbG2LcvanPKQZHm2ms1tE5qDhPWHRs1DnM0HYaVr2/RtcZ6a6
	7AMMonN77JgxOph
X-Received: by 2002:a17:903:2302:b0:2d9:3365:7f48 with SMTP id d9443c01a7336-2db127c0b2bmr222747835ad.14.1788666994824;
        Sat, 05 Sep 2026 20:56:34 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149c2850sm28176825ad.62.2026.09.05.20.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 20:56:34 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	baohua@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Sun,  6 Sep 2026 11:56:03 +0800
Message-Id: <20260906035603.399231-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260905194602.b88f549b9462033e40336db6@linux-foundation.org>
References: <20260905194602.b88f549b9462033e40336db6@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1uqix1mpjeyeqo1miwkjoc48brhx1wum
X-Rspamd-Queue-Id: 2EED6C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788666996-407140
X-HE-Meta: U2FsdGVkX1/M8nDXmmOnsj8ABF+mfLR4z+4QJgmA2+QOUcEdIfQBcDVldhIctZsNMF04AgILJ1aqJyABPXIgKiwd0u01MW27t5pw+VbNGv0LBPASBa7GBD+KCF3AxPALF9ewHpSEDaw/zeYcDAFcKL9OfA6XdeAdwb9ZcqMS1aFUj99M/KthJp5bZ2i3qSsp6L66qWJZXSOgR6LIhivxnf0/iU6qnCWyRUCNr8iIqI81Gx49ogW6kmCBZKwFGgqZ02UjXThdHF1YeoF5YfkG4U9KRM55Xs0q3nOGcJhB+DYYSzbVQUAlipIruAYBhRXZrHiQ6zLC9Ath4yjsWMvk4TSBe2fbTzzaGsnSl3Ywa95K1RYjsmnLusMze8Jxbfq6wir/xRtuiGlnFXATvjc3mIg9nQgPKoU+wB5w+2BJrYp9yj3+246rKtY+YsCMpgIqQPb3g2/x5MyBl8imbs1HQDKHqBBCwCiDwv4oJGt8VxAjiCvpGYqgdqQdIh6lwFbnZckfDrYOgrgpVM7JIF59CkeyvV3UPGQMkWNPFamvCLQ0VUuufiICkoMAWl0tXQkgc4ZUYoxyyH5wddOga4EpTqfdFsuEGpwJD5wRvuZ8VkZHkyzAjbBNsLO45k29pzzP+B15F4gUniOcahbyrpZeplHdQ+QbIXcNhCdWWv4bsABtLKiDyAe3DsLYkgoaNaw1gIDbAZxsRdR2QdC9MrjURANzeAcc/wct0f4yfGmR2stxrDuqXuFPMibVII/CghK86/L8utJTZUDjjw1++Txh5qT3rT4oPWm1SODfYsLpmrsvvkZ3hMbrRPUdeuhfTvNGkCFYS4iKn9cOGgfJML7uKahtOiX9K3TxLGqXtqkwjl/cNxuvoyOw3+1qTZ1a7Vb59ALtZzvNTspb4cI3ZXTjygr+BiDUt9nXt3NeQ78qOn+pLq8iiBm9xOYzYtn57iNYpeCZMM4X/LyqRyoP1VK
 QWDOHcbF
 LUAmnFt6az++h4TmjIMzXWtl8vxehdjRmxp7lu9Hr2s6tHzK4VltZpGotQFzzYJdrBgnKy91EeZy77xBqQ8AEIBzHhUi0tPukBjCFhZqjCWyEtvayyvhJE7ESAq4S0c/NAD/SURLPCFnpT6at7BjicsDJTHsCd0CxYKRTdmYUIcku89G12jdsDGg6sjpDPCmpo8Cu5IICCyA7gnWZQ1RSYAhM3nBl2zSeIc+K2Q+Y27PT0GXxCmRwiDIJqVSlsiGATy2JrFaGRinlCvKlZcXxfMgcvGAqxrIIL5cq93aKTozG0EN6i1jVNI4UcvqIh8hpwEuDjThrIbPMV9NaJfndxgM7JcPQD/4dDQMluu8hJ8ObuCswm2IIsKv3W1bbwZT939V7mfNlumuVWgMdPL2topD3MkW9kuX91gBZii1B1FwyBMfhHwYEByR0IEX69X/WbPo9Eaz0op97dco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks a lot for the review, Andrew - much appreciated.

On Sat, 5 Sep 2026 19:46:02 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > To stay conservative, this only skips anon when the swapcache is really
> > tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on the
> > list can be reclaimed without IO. Whenever there is a meaningful amount of
> > swapcached anon, the normal path is used and anon is scanned and aged as
> > before.
>
> Argh.  The thing about magic numbers is that they're always suboptimal
> for everyone.  But I understand that a full-on dynamic tuning setup is
> a big project and hopefully not worthwhile.  And yet another /proc knob
> would require quite some justification.

Agreed - a full dynamic tuning setup would be complex, and I'd rather not
add a knob for this either. For now this uses a conservative threshold to
catch only the case where anon is effectively unreclaimable; the reasoning
is explained in the function comment (below).

> I think this function deserves a comment.  One which explains why isn't
> doing what it does rather than what it does.  That comment would
> highlight the heuristic and explain the thinking behind it.

Done in v3. The comment now explains the "why": a !__GFP_IO reclaimer can
only reclaim anon already in the swapcache, so when swapcache is far below
the anon LRU, scanning anon reclaims nothing and only burns CPU - and the
aging it would have done is merely deferred to later __GFP_IO reclaimers.
It also notes that 1/64 is a conservative "negligible swapcache" threshold.

> Also, AI review asks "does reclaimable_anon_is_low() incorrectly use
> root memcg statistics instead of node-wide statistics during global
> memory reclaim?".

Good catch - it did, and I've fixed it in v3.

For memcg reclaim, can_reclaim_anon_pages() is called per-memcg (memcg is
the concrete cgroup being scanned), so using its lruvec stats is correct.
But for global reclaim it is also called with memcg == NULL - e.g. from
set_initial_priority() - and there mem_cgroup_lruvec(NULL) resolves to the
root memcg, whose stats exclude the child cgroups where most anon lives.
That could make the check fire on the root's tiny stats even when the node
has plenty of anon and swapcache elsewhere.

v3 splits the two cases: use the memcg's lruvec stats when memcg is set,
and node_page_state() when memcg == NULL, matching the node-wide view its
global callers already use for the file side.

I'll send v3 with these changes.

Thanks,
Bo

