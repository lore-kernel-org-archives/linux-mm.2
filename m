Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088A0C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C2A6B007B; Tue, 21 Jul 2026 07:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D616B0092; Tue, 21 Jul 2026 07:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B344F6B0093; Tue, 21 Jul 2026 07:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7206B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:53:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4A7880112
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:53:37 +0000 (UTC)
X-FDA: 85012624074.21.E950D85
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id CAAB3C0006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:53:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=krdchLHY;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784634816;
	b=6lbEhRh/YsDbQ3KTr4TwZn7mBLYIVNf5ami6YEuXXWttndzd1k/Fdr0SELNMZmB4AmGRjj
	byiOwtpV/4Hf6hNMEnCWvz57315E30nMPdt2DuUSaKkm9CxYKtivOy/JWN8CxoqPSydN+H
	SgCzRbSgQD+i80kv/OhuEbbdYegdQWU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=krdchLHY;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784634816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFtff+4rtunUzbDu3zAPLU3jEyIS3Rtob9OmN7SZ7ok=;
	b=5w6af6hvtauYcXtePy8UQGEMhYw/2rkszS3Q5utyEJx3KLLDo0Xm5bs/uyelciR5POF4M1
	5+hUJlsXtZzv63lKn6fUn8borCRumsBy/hoPWU8lXb+YQoESDAyPwfRdiTZHkYQ02umX+c
	o4aN9l4q/COovCVpgbUnnuYf6VTqULg=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f23e851626so119624826d6.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784634815; x=1785239615; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xFtff+4rtunUzbDu3zAPLU3jEyIS3Rtob9OmN7SZ7ok=;
        b=krdchLHY/h0Gzcys1wduG3NvPmlgS+/W+b8xFK3+Nsx5gaa01A7Sy+JF3JR0DKHooE
         6ZEZ0H7e83fem1FniOSusiIQGCaqJRrBo0QOxxb6jZhgVuA8RdjAyiQfnS8cIoAuUiSX
         tKqAaOfNe+Ih7813uQXxztPVgSqcYB7RB1K9kXYSlW+qn+33EqF6L/7YQxRDmw7HjBIu
         wTA9S+3rZkOLL7b3OA00MA+onY+g9tVMRGY4GiEllGW042muxa6ob3tsT69oRW7oQ48H
         FH+sac2pKMf2B7WnWaC0JGFVJdBe4+4A0WDGc76j+GuqhEkJHDLgwGGJ+4kamKIN+N8y
         JbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784634815; x=1785239615;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xFtff+4rtunUzbDu3zAPLU3jEyIS3Rtob9OmN7SZ7ok=;
        b=Mvm8+Sf8Yz4/KYVKBX+T+zJKClU22HfuZOnAZdO5q2fOmw1F7EDe4vNFgsr5dd8mar
         p/G06pLvAIRwr7UB0ifkJSstO/SmHBvjiiiwJG8h8oOpXJSCrVvOduJAhcTPxlbO8T5G
         IBAvkwl9Gp0LEBuEtbp7gyQtvO7DZdR4SepohhX21+9xBvTSrANq5HU3rpf5/GJn50id
         UonY9t9s0z70IVEr9r/noLZKwTJ2jTBK3R0d1yEz4XbrveUa00iZmofXr6+ZFXPrMu0b
         FtLkglm64DVvsgfCy2z1oZHqKK7uSALtPIpFM1ZbZpaZe5Wn0zExfTlEkDFtOlb1JLux
         bU+A==
X-Forwarded-Encrypted: i=1; AHgh+RpvE1wEskO4RNs15jpDu7wE1x7Vw5rGRl2gUcZDOmcNWxPZKTZZK0+H5RxSyC38h+eZIlNecrQ1Mw==@kvack.org
X-Gm-Message-State: AOJu0YzsjjyJiPMdbVcsOLzB4awRwQaTi6s28uqkHM8FmdAhNvXwV3Xi
	XonaG+b45yg+HAVRtJs2z/gYAEmzGOsYVvVAndLKE4AfR1IXeQb48bGM/EXGj6f6FEY=
X-Gm-Gg: AfdE7cmpdqXnqRfwwgkXery2aurWpiOEPjwedrKUHLhe8PHCxbUAP0NLinjgJE0+6f1
	yGur92M9vMnPQcnWNGvGdY2QVcGKzSBxX7eXiV/TtQ25RyewEK8blk8sli93m7WfAaoBIYQY7SF
	V/V57N9oBaGGz1p9m2o1/hg+MWA5DTZD5LVA/NYIqL408RS0qerzePghlHCD41Qc7TblNv6akYh
	w3JeopL2QPQ2frG5hkilrOvqZF2I0NlRypQeSjtwAjiCJ3ow3G/Nia4P98ds2TNAlZK+uxglVI9
	lBogd417s0pSavbIESzpOWS3KmopzpNzwOg18nqgV+S57z0h4+zpr85M5OV7I/4GvUmuWkVtJG3
	Vzjl/gpbklUhbjP9Y+ikr7D2U70GDTtJgRStOTWMG5s93M7U/A8phVURavbdyEtkIG+X/sWoew9
	ON
X-Received: by 2002:a05:620a:2781:b0:930:a3f9:93be with SMTP id af79cd13be357-930b41e3f78mr1494400885a.45.1784634814831;
        Tue, 21 Jul 2026 04:53:34 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52dcd31sm1081955285a.2.2026.07.21.04.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 04:53:34 -0700 (PDT)
Date: Tue, 21 Jul 2026 07:53:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Barry Song <baohua@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	youngjun.park@lge.com, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <al9dvQtSwAkKSvQ4@cmpxchg.org>
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
 <20260717122514.51514-3-xueyuan.chen21@gmail.com>
 <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CAAB3C0006
X-Stat-Signature: pkeden67wsy3fp7zegotea5riq6tgj85
X-Rspam-User: 
X-HE-Tag: 1784634815-978833
X-HE-Meta: U2FsdGVkX18lg96Qf0urKlQCcxDytx7VyDdTq+a62T0ZcaSgcBh4S8ch7uhVEgoytjJmpg3cGNW/RxLI2WTOZnOF7Z5XRJ+KMU4TBwxMILBTHTLWD8FvbzyMOSai7RTKBTP8P5aEHrhLXT0mBSKBXHGWAb9REIRsHtbK+iwO7BY/kA/AH03vz8RLuP1HUn+kYbiSqOUBqh4YU/tJxp0lMMwNbH5IcidqqvfV85LOiOJ1T7V9omZujfEiwPjpUePl+77vOqHCRCx6W5E7Mb+PfbycCoeq+V+3mJ9Vr43fOHjG/CnLqHyFk9JbsEMsyVOTFE2VQgQINz5gXiicryLHMAvFQX2W/1Loo3g8zP0pDYrxFBkJpNFGo0AcRzuGOp1i8DIerMaGwQS6RBoI3H/v4J0oGa+yfkw4wG2lDxf1WfHbCqqpSA45wukyT2iE1B3+D+ZMaemTEpcVLc00uBBnEa8vzqwXfdEorD9Ig4OxpV/9cMGNUyiFV8MTVOuROdVLpKhdsYf1xs9mdN8dsoj5HToOpPHK8GtI8uZbCjJo7bAzfXcUr/5iw5i0dBX7own9hb6rF/EDXPd2B1wH/pIQkE9sEVdf8xr1GRBNIqyEchacbuD3f4lp4TRLF2+eOq0MgQkGPSgqtXIEa9LwyTiF/kMoWHAip7hLjoF67Fm17PRLaXq3sJTX4+lrs4MpwRuwYtTdtL3W42n+vbfhUlO9VNLbyw+Uf80lVHk219Ixo3SCFNrp/oWtK3gSGkh0TFqq5dPsxyP8TiIwuiuUhOd5QqzH3CNC+yvK1toyM4Sc3y7O1eHDG2l4pQ40UzncG5F68WzWnjOK4dqmLXDlfG85bS73p4VkHlfur2CSLndwQWsbiE7KLkLpFQ64hMNnEEUhI09MFxlRxxpsGr3ycq/u0jopHGXzm2U2OLDxMkKi6sE2MPMYaRwEMWMpCBSPZmMf3LTImFDbGrjql7ASJYo
 S8LcmmJ7
 YLEPa7Ff0cWMZcw2loBpAUZI0x4ZPi2v8pQxPMfB5rXMMw0d1dDn819o8rYwpVNsaCAlt187Qlyr/R7Txw1gDWeJZIaGIFL3Ao/8LUNdf2gTSdl3Y9TojQSwEYvO3SRpCTRbYINlm8229VsJ77uSleDJ9W5+J2rEh2/yFuLKpejCBor596yhpljKfq8u71vumYkKmlU30czSz9PQfwfFszpmflwptOEcfxn8QmqrH4Ho605A2gTcsxJUDpozmDgzGzFaQ3AWOUOcRSen/5crTbsmfgVc9rIAvWSDNJcxhaGWMNqLSg440wbnjU2VJ9c7EmT65AmNDGbPIikGgfzK7NeAyqza5KtHtXnyrfpCL2dzkgbKuccRZRp8aLx2m9fbNmi4U4upos0hTnyUKzhsns7tUAbqE12j0ZeOBmzYwtoaNlnBgj+WyeHdsOraZOcx5zwZScD95sHp4cXtnpoA0sJ+as4bHr8wROY7XM1+v8kemS4A245HDmvyC1nqwDB7g03ZkT9A86hAeU7OuWmWPhT2hqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 04:15:13PM +0800, Barry Song wrote:
> On Fri, Jul 17, 2026 at 8:25 PM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> > @@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
> >         rcu_read_lock();
> >         memcg = obj_cgroup_memcg(objcg);
> >         if (!entry.val) {
> > +               if (nr_swap_pages && !mem_cgroup_is_root(memcg))
> > +                       *nr_swap_pages = min(*nr_swap_pages,
> > +                                            page_counter_margin(&memcg->swap));
> 
> This looks a bit odd. Could we decouple *nr_swap_pages from margin and
> have the function always return margin instead?
> 
> I don't think this function needs to care about the initial value returned by
> get_nr_swap_pages(). While folio_alloc_swap() may depend on it, they're
> different software layers, and we shouldn't couple them together.

Agreed!

