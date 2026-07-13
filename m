Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212C5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B2D6B0088; Mon, 13 Jul 2026 06:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB826B008A; Mon, 13 Jul 2026 06:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD326B008C; Mon, 13 Jul 2026 06:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85AC6B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:09:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D1401A0B07
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:09:57 +0000 (UTC)
X-FDA: 84983332434.13.D9256A0
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 49B6D18000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:09:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UUwJxube;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783937395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMaPztzkv7mkAfMpEcEj82JplFx/jQM80q6OSMWqA9w=;
	b=Q/hZNEx8cyDFWpt2oBa60b5o2x8VA7l3XaA5RrICx1iOIOi0enF6I6xG80hILYdIzrMk/H
	HWjt/G09LFakv6gu2sIoET/6YKVE7+Mwep4jgmQkz4RyTtcbhWJmLBBn/65xID/pkTFdIY
	WBEacI5iSvOXUrcVBIasLKrFBXtB92M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UUwJxube;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783937395;
	b=1r38wEjqX5tut6H+Gcf3Ih0ce62ejXWS59a6MZ13fHLazkFW6awTlNEDnsiWzndVBPk4o5
	6M8RuRmNbLcDXe01hW1yTpD+xFASyPgLn0mVou6stMLmW1swFxy0ikvEzvx2TmyRxkmq3I
	T9iW3mRr09+SVeqGRtaFEjNmJaYOxt4=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so3577321f8f.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783937394; x=1784542194; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RMaPztzkv7mkAfMpEcEj82JplFx/jQM80q6OSMWqA9w=;
        b=UUwJxubeE62Oql0jNq440cwqIhEpJXejOm641Be7ZE/ivizeJggDEQ1R+4j6UIZ1WW
         I2AnZZuzq8L1YDgmwj57jqD4taTMrXfOG2gGUC3TFSfsji9DcfxYXt4G7I7ON7IOtClt
         P8NTVac+O0kdrWkHAYvl/9PNApvyGZLwtj1H3LcMEhGHmg9LZutsE4TiPo4toDAul+Kd
         rVQDJelUQ37MoC2akGgEES4SOs8v30kn5UaVjWc7lQzLu9tZlOXbqGVZtAOPHTs8pFUv
         nIVCHEJsi/U6sK0r0ixP5/43brNRekgKj48K9KKCr6lXbUwUOusAN8XYjAjjbUovFZm0
         Zrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783937394; x=1784542194;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMaPztzkv7mkAfMpEcEj82JplFx/jQM80q6OSMWqA9w=;
        b=SGlQoB3wiodWXkG3YzeHFO5BXDYSlkP/pht5MwR6JwudBuL0kRDDH5r2J5AaP/d8SQ
         O/j+/Pnyo/srxqWgwZpBuuU1GPuIwzw8ebel59zAI3mL6tZxJzL8YbAljvX1/oha9Tni
         0m29tcDhPakc75BIn0TJ0rQoBfD7znKEtfvgicfo16OGzxMMicMkM0VLslyt4LR6TKyr
         rphSrvujGrFGdFOWvwup03hdrYpuyHPldd3gf1A2VxONa6zD2i+u51Z1S1S+ZDX/M1D+
         oNsziZcsUGPR+mQAqIU3vjwcCbxaUDb2OHsXtIaXsUf0ZVuY5mcTOsklUitV0qOwv+2m
         ygLQ==
X-Forwarded-Encrypted: i=1; AHgh+RparttDdVPaRmO1/kqMhLqoMWiFW+PswXWc/YEJzuDDAUcz8xr9T28tXuEd6XcbE1KsKzZvhfFadQ==@kvack.org
X-Gm-Message-State: AOJu0YwIdf1dk/W6AzaABo7VhFzRLw0ZnVGewNH1w69w2bjJ+PxJG16A
	Q2Yq4u9t42HIkF3UoFfXdoDOpQvXJPxGEINk0bpFPnRaVZ8YL2bbd15lhXyoD+kAdmg=
X-Gm-Gg: AfdE7ckrmlPjlG8+ZoaTtWiP/mk9sgAcft8bfFESty330cjKSrmlpuuYoBv5nsWLNTU
	gTu20YdCDl3diCe3Vc8cZT24OpR1pNq92ixx4VNda4kx6yufashqE617c2erYVfg4G4bUQaS5pg
	lkcPj+rsLRl3sxiapTmgtQsRkot5LkfBNDHWUwbzB6dIYswug6gBA09Xx2uHaPpQhJMD/h9CerL
	4yXJ/lVvo86BqFH8C0fUp2l0uI1CtJKzw8gzFKRELiPFtDN42SBUqsdndAe+xV3gkFLdmOeBnRr
	NksrvI2AHfrJud6nLMwuEDWzzM2LMrpniw56Gesr1QNoW+IVWoowEvkfLYKPhQTysOIgi/7/IU6
	+lpSQsYLTACCmvdUC4gX6TfaU/++vhabUkfBSc+v3fN2QLLCPKeoboI3BCtauY4yCvufbWmGnjV
	BVj1zLAdakc+QmwLBnaBtlJB8=
X-Received: by 2002:a5d:64eb:0:b0:47d:edb2:a4ab with SMTP id ffacd0b85a97d-47f2dd2c919mr11096800f8f.43.1783937393990;
        Mon, 13 Jul 2026 03:09:53 -0700 (PDT)
Received: from localhost (109-81-90-85.rct.o2.cz. [109.81.90.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039b0cesm86605884f8f.22.2026.07.13.03.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:09:52 -0700 (PDT)
Date: Mon, 13 Jul 2026 12:09:52 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
Message-ID: <alS5cDDzoOJUWhlm@tiehlicka>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49B6D18000D
X-Stat-Signature: oiwiz7ahybx5iwru4dso5juqg8qj4xg4
X-Rspam-User: 
X-HE-Tag: 1783937395-920769
X-HE-Meta: U2FsdGVkX18T/2/KFi2ooyBw4liE5qpyt3nHCsPYyPQyOYENqKRJ6Arm/idObwxd6mqsrcbSWZZHEDVIZeltWhz1K5Do9XcRz4ZRPImuiEvYiMPuM4xuevrDZd1OS+pLm6T3S6URCNvabSS0cfZPSg9v7pgVW18g+ztiQgpJoleYhu/7YjZU61XdO3EEHxRn/PdwYWFRh9GcjczoZFc9sJ7jkRDYS+WvjYe16V0rsvGg0Lhwu4JMU6O7N+1hNr2vVAbhgVySCwyWNTkBtL2WuGDjT5POwaNR0zjY2KrPWtEMyRXcxjAS1LoMNBqoysetfGG3DTdiowxfaR5dc4uD/yd2zXqdXnjEYqw+3BcGAqLSgZGe7/HpEY9SEMrmBPzxAz0MoXyllKfPN9VTD6q3PyU/uCSQqHRKIq3W63RXnxvDbxvVuDNH1xRvPHjj85IZB2XG4oGSlbHKUjv8FcCD8CsADUFgLs9Epr0FeukkbNVBffFjQ0uumvfeETGDe/dFhTB0ooAdDkHyt7X/TQ3vRkCfsROUM49LdwleQ1X/TgKD/PYP2/LvDE4DBuAF1rtI7TXgEAerrrusbNdgkmowJ809USmWROTURpc1uQStX+tXgsghkHiyWNV4eY/bnqS9uNHSOjS4O/MnwWiAjeCkba8ibJIfi2stOtY2dAh25N6CtfXIpOv8qIaBUC6Z723DFn87KEu/dK4X2zalWPSxTeqs5jdMen5IFcCgvQ1xy7w1LfSL2NApRzsnR83KQsDdl0BYXZ+xwE9F7+HHwLHO0Q4YTj28U5fgh+yGIhr8vTn2c2GwIiaPli7MkI0WhlNpF9lqmDCnD/C+uWmRo628kSD6TUBnvzxaWJrJINp6KjHqLw/E0gKzPNmGskqefdI98+6luK8XwkaA5Sv7ItdokrhyuE11nLnw7HftthWzQBG8nsIRowOVq3COikmhiFj9Qk84oWO68VxeTKu7LNc
 pQOAY8me
 hvnCAzYD40JPC5QH5JhHElLx7ZLYrIV10sm9vwJhvD95O2iB08+zuCzQ+6FtBsFAzcPG+WJ0871m1TIkEo0cniU5U0wkS4bqhAleZA4dQJ0Jno59Ff+0QKcLBSlOZGKzWlhrvSHsOnfEXzsff2mTVixBrBvKa4DhQrsx9mlI032S3yJRyTQqdTC/s8QwYp0SBj3SNIrmrExrRkBgrg8rPkHkro4z8gV3645yQi5grsj/yC9twUMWBUM+S0gHXfTZJYXg1NDOvxX+LP11fv/ZhDmkGw5nkMWcdQhgCNH6/XZnWn0Z4JU0oTwlp6OLD7a8lXJSfW+kojpt446oYGs8II+26b2LakDJnGK5dQboTpk7v2OyRN4u37v0K8z4urkKYf68R1l64OtiS7DjyezN8NWYwoj2nHT+YIk6nS7bk/JLQ6UvzVYonUEDdAmf5fOad8XJESKgxKucxwUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-07-26 17:00:10, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Looks like a left over from prior versions of the patch because there
was no use in the 940b01fc8dc1a

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs

