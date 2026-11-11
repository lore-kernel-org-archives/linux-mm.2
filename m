Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52B8606A89B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bPJIDuEw
Received: by kanga.kvack.org (Postfix)
	id DE0276B05D1; Wed, 11 Nov 2026 13:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8FFC6B05D3; Wed, 11 Nov 2026 13:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C586B6B05D4; Wed, 11 Nov 2026 13:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8D96B05D1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:17:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2973F140364
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:17:19 +0000 (UTC)
X-FDA: 85423645398.05.2120E74
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 534D9A000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:17:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bPJIDuEw;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794421037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAFBic9FeqiTcoA9Sc56oOZoN08uUZIC/3Jq0YqoHLY=;
	b=TYLCCsJ1+s9ivXFGNF71fvGpn1yd02ISrG1BIRvG2wMyvgHf5gozq6+lHMb9p4XCk3PRND
	8GLQVjrpdwsGeVlWkGywrVOsiJ1Q6SUsc/HwpBU/5qSEKBEC2IdbuQxb+BviQs5U61DLHz
	t2bqOuA+NU3gsyXs67GvgBzMfOPXlDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794421037;
	b=XbC6X7XbVeMa9SzxtGQJ/VLX5PFS5Eo4qwXcNXZierBzQBNBSnUsytdGwkyxEYqtJHdgr8
	wj7PZEiKytCBWI13xQo2ALvXMfdZUNmM7CjF6E16QeudjbdPJlSfrjStSN2H2vcj/XGk3c
	nVFckQtA2okIQsCgLSIUTTZ4hqjwWZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bPJIDuEw;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b30cbfa628so40839787b3.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794421036; x=1795025836; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JAFBic9FeqiTcoA9Sc56oOZoN08uUZIC/3Jq0YqoHLY=;
        b=bPJIDuEw+G70Z8WLWkbd+/GPX9BBHyUC7YhtPzyWc9UkCvp4ZaQvQGYbWtVbISEH4N
         pNKwQsp4bvn5S4X/X2IgAHXXoONm2sF+beKkRNnYU8HBIiwF1l4pF6oUq6gj3oIwjc1l
         v3xzgbUgOZeYykwtZbrOI+h3xlhEA1d5gCOGb9GNJIqlfINWmqNJCEbqB/HoseP8lmEc
         ok5wJNkSFL96/8XxMwTqIZWcEGP4xDdqrrJN29ClDxga5aQrJgAO0tv01mpvZ2d2brk9
         Lf2OTWXPX3ewIriZ0F8Bd+fKCJfe+3eydMb3NEslLX+M650UKsRZYyVCnry83cia2tTd
         IX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794421036; x=1795025836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JAFBic9FeqiTcoA9Sc56oOZoN08uUZIC/3Jq0YqoHLY=;
        b=V8n03Mlfv04kshUHfvFI8YyKpNJCVaCOIL3/DJEAso6A6suL3SXa94nC6ueAMGgS6x
         yigVaBZI+CXSioetd4h62aAGBF7wiLGI6oo/gTgU8EnMx8YJxO+wuVuxOfKFUvJnkmGi
         cNXXaP20CE7NERtYwcf3FuCvv0eATlhCqgELWh3YdnDW+Mu82j8mX5qOXCau+svApdJ6
         TeJbHIMFsqVUXToSTEqk0rDTd/gkyt91zAmqmIMQ7nvDlK16pb/bN649qxsygtsvFEVx
         01LRcYxg1GaBJFurRan2PgkiHnCcYyvasC412FZKf64gZxGeyiKAEIuOPvWbhdah/xTj
         KllA==
X-Forwarded-Encrypted: i=1; AL+hErEXfe8vU8mpTccMJtqHNu/OE9wPnp2P/9wAsrctY/DMaZmSiCT3IVBOkeOY4M6F1Iw5t+4Sp/Parg==@kvack.org
X-Gm-Message-State: APuU4Z/Q2PHvgzNvNXOUlHP0Mq6RgWDUICZDRsfk67ZsDLmbdxfG/STw
	oI71ChXHnZA6/so1XUbUhjpVsgO3BochyK+pbeti3ptVT35ChHcdEiuS
X-Gm-Gg: AYBFou1O8F1L+9g6oN5vYFMW2mm+i9JbOofJr2FnQn1eM00xlN7t0IgKhLyF+4f9yb0
	kzxLnvCQfiRBs+tMA93CqFBYHS+DYjz8ZrbgN5+FWTTRJpTMTPq4XBG00rz8v7lq+sftKJdL4og
	IpX5aBtxH0+2ufFvBmzqXhZveBbIs0sTPCAcpnOQpunDvjY1Kfp4oUIo1NvaWUmpvsTIkXw8BAH
	YCP0Q/2cn0nb/61ayVZd/pBvB9KS2V3OiE6F8vmxhgOMgZGY8NxhR6VSWbIBQehlozjJ7SRcRs4
	9eMxXIeHfzo03oTpNqN9IbSqF+zeFARF91pygweqPZQSy3vFob9iHJU0qi/R00IjKKzqv/rXlY5
	i+d0qdm/8Gd45qZ5SIt9wW9NRfxtPeoAg0s/Y1PJfQqLJTU1IaKMfxUP722ljjg4KJlDf6Wo9YS
	HNqCVj4DHN0R5g6rYXdO6NeXa6XozNksmsBeSNGDY+h1uQmIrOPNwZAhBJark8wzKya7YDNZPrm
	Ku+oeAFiONRm6+FDsXn3/foMbfgnYN9ODJMgenf9qsasFYhtZnUwV3StztHWR75XNCMlbzvMQxs
	MH222V0Hh4KVZwcX1qOT55HqPuAjzpTkgoW1wnHQPNSYQO3cohNrbhUU0mSthC/DVV+Wfg+fp7r
	C6dKi0w==
X-Received: by 2002:a05:690c:4f07:b0:8b0:d837:364b with SMTP id 00721157ae682-8b3a7e3b702mr19660887b3.7.1794421036454;
        Wed, 11 Nov 2026 10:17:16 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b39324c124sm49936597b3.6.2026.11.11.10.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 10:17:15 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	mhocko@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Date: Wed, 11 Nov 2026 10:17:13 -0800
Message-ID: <20261111181714.1463827-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9i3nc9qmgqhxtin93jhydsrotjd4mis4
X-Rspamd-Queue-Id: 534D9A000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794421037-906798
X-HE-Meta: U2FsdGVkX19Ske6FS/a/OvS0lD2QWMNRix3AEArheGWFRy05GxtU6d503mFpRrZ7IfZP45xlO24Q/MhqcOOGaRVPL0Cs9m6CE+SR2Owzt5NdnE2Qafrmh51oa43HCHPHSB5khYWDXzk7XwgiDU1MgUW/dVTyWq3/agE3Vvy/v0Mad0tujMxz9f9xUrRPDuXQK68SbDnj3qcAt64mNUWPYonnn7pu6hBCse/JM6fYpC0xz03wnVD6Ulz7yjuHzO68IE5tKnioqCglYNRDHFMnfFFEMfUJj7jvMZ6CYf6aCCKBcKK89RNPXoF3MYg8f5m9f4f2hs2Z/zXjawxBPwrXxx1ydvi29nUvhN9HFVsiKqPn9uXZPA0vt/c0U4PtqP2Y7uwwZUEr8iMPKdS11SlhuQ+OxM0FB760LkF+zd3tNPyUdZBdLkywwCvU2Qo5WYGhg1q3tWzoacpQNiwVlUZSMJiKOoo3K2MCk0Bso3kEwNx3DB/Wg0J9B2PZ+EfacaU/cY0C0PLs0PF6O9V12yMsIcmVzSSEZXYTgTjV9OYqg9+LeleEsc26Pdoswo838fJf1EA64+I4/4PfoyEcdcGv+7dZAHuefue96cDqcTMvsphu3h3y5TCPji8bxb86lvTIKl/sqR6nsf4vIR2ATYCHjbzHvTlu0YhWpfHucu/0pGhcrUbV/azT6qC1LwOLGsOf03IMSJbx81fS6QtH7HWjmyzRKs0hQaeDfnbXPjlte7C/vC30nK67ct7Ul8Yai+3OkRJK5zjB4X2lGGyyxda+5l1WkK1lV1vUjLYSrWYcS1dEZ3+qdjcDdbssdDiM9cynHDdRYRWoAwRQh6f2wHepYv3o84CZlFtKjciu/s4l9Fky8IyajwRhlsdI5b6KRfkvxPVWU4ydgmXA13tb+hm9+ZaM3FpTwnjb7Xqy+xs7FHfiEkKTFamwqS8UxcY0AO0RPd/oIoVbL/dZBexCUZn
 df2GDNdX
 iikJPL5dyANeBYiUyxFj/sGoKTMMiL2b/eT+D9reMwqqKoXmrno7e+xiBP5eQCKlX03COCrfm34MJU54Dkt41b5wzyH6EgpKNfbVwoJ9FADDgRl2xAxT/3rPx99IDtrSMgvceh6JqNLIH2/Qart59pyTblQ9zJDSswrZbWQrYrORCgDvZfLMjBPUHVQqFfzzXQC7m9dfzp6zJCxFEDgMIpqNNA9XtmsNfFjpP776g51M3mK9S6/sU3yWEeXmvkOlClJM2FiYVQ6S/t75XaO/Zo6e9KmppHXG/b34rhO0PqHg+eQ5cwLVcbl+lYPGOgAoDURPQcXqBlmRHBTRRyKmw4BOqxNHoVfbAilDyY2H6XsdrW1CmRNDG5A5FIU0NpThk+gC/LAS90lFM2K7MWYCfsetUJcXLMhCKEdTk4F0dV2R/3kg1QC0CyI4aolOLaGNPtcZkuGHmhtDuJCQ/XpjJjR1wfb9nOW6HqWII7FMhH7yb7mSIQf7rgb+B5V9Y22/c+OZKGCVAlZNJasGnXlhJWggWaMPCDsdE144gFJz2XOggpvQkLTwSKJua5YLILjXhoLr3PP+1287UWUiSlx4kk31XeGeQ+If4idBOi9Z0vrVIlGdg5N3uOOongf4VEzk00Yh2/jVv+Ok/7Wgx429Le5IUq6UbARVy7u7P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 22:13:59 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> memory.reclaim is a useful proactive reclaim interface for memcgs, but
> tiered memory makes "reclaim N bytes from this memcg" underspecified for
> userspace controllers that manage memory placement across tiers. The
> kernel's reclaim policy is aging-based, and on tiered systems aging may
> demote folios before they are eventually evicted. Without a way to
> declare where reclaim pressure should start, userspace can only reclaim
> from the memcg as a whole and observe one aggregate progress value.

Hi Zhe,

I hope you have been doing well. I'm circling back to this discussion
to see if there have been any updates since we last spoke about this.

I'm wondering how feasible it would be to enforce some kind of placement
decision from userspace with this new tool. That is, I think I would be
interested to see if this solution was enough to grant fair placement
of memroy across tiers within a memcg.

Were you able to run tests to demonstrate how effective this was at
managing placement decisions for memory?

Of course, I think we should answer the ABI questions below. Maybe some
of the memcg folks could chime in a bit about what kinds of interfaces
they would like to see.

To start, I'll reiterate what I've said in the previous response, I
think we should keep this a node extension until we can demonstrate a
scenario where there needs to be tier-awareness (to be honest, I don't
think there is one).

Cc-ing Johannes who is a memcg maintainer but was not CCed in the
original series:
Cc: Johannes Weiner <hannes@cmpxchg.org>

Thanks, have a great day!
Joshua

> There is prior history here [1]. The old nodes= proposal tried to let
> memory.reclaim scan selected NUMA nodes, but the discussion left several
> ABI questions unresolved:
> 
> - nodes= did not clearly say whether the mask was a source selector, a
>   reclaim domain, or a demotion-target constraint.
> - The implementation did not apply the mask to the whole reclaim path,
>   so demotion could allocate outside the mask. If userspace interpreted
>   the mask as a domain or target constraint, the ABI did not provide
>   that.
> - Selecting top-tier nodes could become an implicit way to request
>   demotion without uncharge. That would make userspace depend on a
>   particular reclaim policy and could make future policy changes hard.
> - The separate completion-accounting question remained: demotion can
>   count as reclaim progress even though memory.current is not reduced.
> 
> This series takes a narrower approach. It adds a typed source= key which
> declares only the source on which the existing memory.reclaim aging
> pipeline should be applied. It is not a demotion target selector, not a
> demotion-only goal, not an eviction-only goal, and not a change to the
> existing completion accounting. Leaving source unspecified preserves the
> existing memory.reclaim behavior.
> 
> In that sense, this series extends node-scoped reclaim pressure to the
> memcg memory.reclaim interface. The existing node memory_reclaim
> interface can apply pressure to a node, but it is not scoped to a
> particular memcg. This series lets userspace apply the same kind of
> source-scoped pressure to a cgroup's resident memory on selected nodes
> or tiers, while still using the normal memcg reclaim path.
> 
> The main benefit of this series is to give userspace a steering knob
> for per-node and per-tier memory placement control. A tiering controller
> can observe the resident memory distribution across nodes or memory
> tiers, and then apply reclaim pressure to the source that should be
> relieved. For example, it can apply pressure to top-tier nodes so that,
> under the existing tiering policy, cold folios can be aged and usually
> demoted to lower tiers, or reclaim from a terminal tier when it needs
> actual charge reduction.
> 
> The existing memory.reclaim interface cannot express this. It applies
> pressure to the memcg as a whole, so on a multi-tier system the kernel
> may make progress in a tier different from the one userspace is trying
> to control. That makes feedback control of tier ratios ineffective: the
> controller can observe that a specific tier is over its desired resident
> footprint, but it cannot direct the next reclaim request to that tier.
> 
> Patch 1 adds source=nodes:<nodelist>, which is the basic source
> selector. Patch 2 adds source=tier:<N>, where N is the memory_tierN id
> exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
> only a convenience layer over the same source semantics: it resolves the
> current tier nodelist at write time and then uses the same source-scoped
> reclaim path as source=nodes:<nodelist>.
> 
> The remaining issues from the old discussion are intentionally left out
> of this series. If userspace needs to control demotion targets, that
> should be a separate target/demotion-policy ABI rather than folded into
> source=. If userspace needs a strict "bytes actually uncharged"
> completion mode, that should be discussed as a separate accounting or
> goal extension because it would change the observable meaning of
> memory.reclaim progress. This series only adds source selection for the
> existing reclaim policy.
> 
> References:
> [1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/
> 
> Li Zhe (2):
>   mm: add source selector to memory.reclaim
>   mm: add tier source selector to memory.reclaim
> 
>  Documentation/admin-guide/cgroup-v2.rst | 29 +++++++++++
>  include/linux/memory-tiers.h            |  6 +++
>  mm/internal.h                           |  3 +-
>  mm/memcontrol-v1.c                      |  6 ++-
>  mm/memcontrol.c                         | 11 +++--
>  mm/memory-tiers.c                       | 24 ++++++++++
>  mm/vmscan.c                             | 64 +++++++++++++++++++++++--
>  7 files changed, 133 insertions(+), 10 deletions(-)
> 
> -- 
> 2.20.1

