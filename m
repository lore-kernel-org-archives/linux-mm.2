Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D836098A19
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fTckic+z
Received: by kanga.kvack.org (Postfix)
	id 6A8A96B02AC; Mon, 19 Oct 2026 11:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C526B02AE; Mon, 19 Oct 2026 11:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A7B6B02AF; Mon, 19 Oct 2026 11:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC626B02AC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:21:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFEA7A8399
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:21:54 +0000 (UTC)
X-FDA: 85339740948.09.051E6A6
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5619240014
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:21:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fTckic+z;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792423312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09q/0iBwzQnusWfsQDP8VzXzU6qhw6PdbTeHiI84DZo=;
	b=aP4OQygPZ+JXbYX9Bgv1Eo9/GC7jtfTLkVzbyqnWYqp+MFMwcT14PrIJxI5lmyJ/jx/WgE
	3NSK2HTnEpL8pYKWXOf8YixqmCO5hdatHn4QPZ+6mV+csB9/lpQ7yB87lnKGKOoPaMBWv5
	8dznqYMvsuvKW/illdubyuznfBfDAE4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fTckic+z;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792423312;
	b=o2XPHA8G0L/4J/0+Kf6liTPTWvNj0nP4m4iY5/Wd/A+U1QvBrHUjyLkJEWQjo9znn5qo9W
	ctdA1a0aHFQ3HwH5IKdGP+qICILFayxPa5Q5wgbaM7j1brm1O8IPhUc3/pzEnUmqDVnJJk
	nAQ2LZ4/hfqI5xo1D/LKVzu3jqK/+9o=
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6b8e2d8df4fso1575450eaf.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792423311; x=1793028111; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=09q/0iBwzQnusWfsQDP8VzXzU6qhw6PdbTeHiI84DZo=;
        b=fTckic+zEURUo72QXH7MjGZKYBodaa00myM3/yWMEWVqeK3Zxl0rT3eqZuPktR0cVZ
         tdDf7wgiabKbnOFwK3jgqfnhjjYivn+QvT53O6ypHqDtXMszl/gOuZv+Hz9SWacu8oN2
         fm6ign/cmM1YbX1ujBw3HM59yS/zHmJnhw/rKoueiU/J+AM4ENOsCi/ZM6zZI4vfb5ih
         1MBd3ofUxr4/XkgscnXu0Asv1DxAIY8wLb3Nnz1ySkrIcwpp8fzHjLmroqhnDH3aHzE1
         rj7Ci2nOqSZv/wQag3A1ykFufMtwk5J3yHbLtDzFpLjHsTq7hlfu5cT1J43c9qjvLGaq
         6AJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792423311; x=1793028111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=09q/0iBwzQnusWfsQDP8VzXzU6qhw6PdbTeHiI84DZo=;
        b=ztvFZn+kQbd47ilLIUwedHfgHV+enhNRIidRMWt2a9eQYHfZNQjkVdG86heIcqDXke
         zezeWu+R3UAA8ERCuD+nqWBK0hsKT3YhD3TYNiPw4MVUBT9OImlBWn09WdoYotPvLApt
         egJJM4HtedM5xtnl+ri3tnGhXEtmR+C4V+n3jFQtMPZK0XPLo0FUwp0anZekun+ruxoJ
         dmMesqSyRbFx3m2Q5f58Pn9IIx1WzMFlcmkxbgxYJEthhasI8Q3wB3KuerJfa6bTkFl+
         Wgf9VBu+Dvuxftg76D5dUQbMafUY0BqPqgkigPjDUe8o0ld6mJvukCO04Vd0S866PplY
         eHng==
X-Forwarded-Encrypted: i=1; AKwUvBxUCgESBuFsMhnxG+7tC6wzSvK1TzBbza0pg1ctELzI1LG3MgRySKgtkhoHi+FNHCQbcwmxMnDXlQ==@kvack.org
X-Gm-Message-State: AFq9FYKrBYPVaBRjB4p4Td2mMDdqREH8S+btwsQDjYS3PKVGtVwGrXOB
	mtOdY+4tQF7poS7n7yy9vY6zERN3sCjmzy4uneSFLS60Lp7TqRjQiXGY
X-Gm-Gg: AYBFou2Zdu7dNtlGgjuCmQawSWy9v7rzYvyr6cs1P0PwHuMvlPWG/308vHGJ9sJgPCf
	tzVbZ622yL539fBW5trTRknrzb8hkoYmySgOF3iqtcYMwSn4udArMYZj6mNLiyEOe4Rl0jVPJzU
	2IgXLgq/n/K2AjgZDZlnSQl/wNlHvRB4ALFWNHCl2pYgOnK3ieXzu/Bh99BVDUF5fh9q9S+Mv06
	fJFAA1AzXEF5ILfJJVxlLZ3OZlst5xXDwhcvmw+qYge6cVWlq1H+U/uZWTeowNcgCC8Kft3pigR
	7f5NPQQBsZhiZO4UzdG7USWYvbT4n03JcQz88Vzr8ZduVMOT3+nLGklYFK33DWKo+bCl3fkqw5W
	29SQg82CTjZzMXEmgeTQenHveCXp0lR5WTcCfQ6tKKH1XmKo+Ib1EFf03eG+MEsjZh0MYQUkWQV
	PQZBcqylc2CvVm+fyvJsL2TocJdpFQ+leaZZL4ZHFKfFaNQDEa+ZBidX/HN8Y6MWNYT/ti1lnFW
	DaBDDlakfzfdogeFSzoyOEDEo7C
X-Received: by 2002:a05:6820:a515:20b0:703:4766:16e with SMTP id 006d021491bc7-70357099e1cmr4063847eaf.56.1792423311061;
        Mon, 19 Oct 2026 08:21:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a73b6cac55sm9160419fac.11.2026.10.19.08.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 08:21:50 -0700 (PDT)
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
	linux-mm@kvack.org
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Date: Mon, 19 Oct 2026 08:21:48 -0700
Message-ID: <20261019152148.3330024-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5619240014
X-Stat-Signature: mchxnqqtmnq7jinot99sutzynfxqaics
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792423312-444823
X-HE-Meta: U2FsdGVkX1+U2slCsmOYpRjsGYUZLSzUNdQ7Zhv5MttZxl0seMUz+3hXPNOJIZNYDV6J3z+LNaejn0a0BxcUGScj/tvjg4+gUQUF5bji9ZKCi5esvGSFG4No2aLXRUqW7/a7t1MYOUXvvlDrjNq9KatfPaClHYz1CYcQv8cp+lcJKXzji1CrjEnXtc2Qqkuy+WIf/6VTkNAaF8FV2lXdIo3d6q58V3QdqFgyhSUWK5szIRYLxqgHR20JElAMkR/C2d+oCTEzPQogQPSlobmn1XQmEOg7tqrQnFv5l/DP/YPbv13Xv7CxHZkIuW5b74t5R/89jPNSNOVY6qZA9j0Ppi9r1Q63yYn4apOcJPuMLbNsm3dSSVGd7U0/tFtbynO1sIWiafmzJrPY5zM5EBOv2Je7SSUC7b3CgyeTAnaOtXxmri9E8vwD348flxvavI0+j4C4wbBsyNRtqReNX2I9QJX+F8cNX5qjfj0z8iz1SVN0wvGWmWocQVTmIymMFxqx1TcQEJiARB1q5q0jLTNPdbkgY4B6zrfdHqjsRbYtmFskGJwiRpoEOUJxBop0QMps/wlBeQvfeOnZom+rrJ6lU1DOQ0xHRypFJ5Y3YZOYQyGEvffJ0FNWjUlE5jAWVYXwHPwFGfb2w7wqDfTX8R8BFRgpaCm3q8gTxurpWbB/Pv7Dku2jTcFHGrKe3DD0U42u8voRXckqhpG5683tja2JhTkwP1S/nv2l3asFyVRRoq2Q8odb/3FC8upipXcyze95uSN1OxZvR+JK2ZP6ESy5cLl/cvjFypRmX8Nk3hqie3XhQBzC6raFW79fPjRUMe6Tj28FkbSZk45wCCE/wTDBVJesB9NvjUxx8x/sX/bLMhZuGNmmH1WmEK7nL2Q2dR7NnRNmPHfZIjMJJukmeNaXDWHzNIxqUAE8oBAW4xpQJgd4MnFgIsK8If4+yn2O0/B+J4YXf9fWnn1nxWJGBMA
 5xtFwyt0
 0lR4BMdVyLG+kcEJLbhkPGlS4NeIM2WlYJ/VH6IwlHSCwy8+2IG02CC8zdBDMmLjLmkPEn22h/Qm/oKQ1XO1Gf9Zs0SPdcBRMUI5+UNQxnsDV9NznQunFCN5yyUHFcQFP8pFzYBlwTEhdCFrKoE1eEZHbLoLPtzqnK0zlDDlBlRp9ghHbJLS9uKSM+ROg2PnfVA5ZxWCuPw5cGyqv8g+zGCJTk9C79fXCEhyUdweklLLn7c8mpy9CUKnlrRNEm8ZsyTk5SmMD5sedn47VjQbHqT5ORrYSXWByLNackSkWPSqMeGvNkCe+kG2k8cTUlD3sBaum8gUdF3jaECb+ovnUK92WYn1EoQdkxWDlHVU8pfP78GsdYtA1tFIjUCP44fS/1NjNgfqvmv8TWZCW6PQoujWwQwJ/zHze3h7YlVvocIuX51+pZKDjzuFxmGedVMMLSIl+KNJ+WElumrrm/DeBreXjryg0qTdUI7vsjL/N7iYKhRSYA8dBAhHEKwIZWCGkX+3bggs1u/pVN88Hp52zGyvrdS5rvUW3TjwS8gIHM8C9MtJUlILlbHiZheWwsKCy/7QlqNDAsplGCtY8t5KSNnOGuie+TAX3TszV
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

Hi Li,

Thank you for working on this patch. I think it's quite interesting.
I have many comments about implementation detials but for now let's
discuss the direction of this series first.

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
> This series takes a narrower approach.

I think this is the way to go.

> It adds a typed source= key which
> declares only the source on which the existing memory.reclaim aging
> pipeline should be applied.

Calling it an "aging pipeline" is a big confusing to me. Maybe just call
it eviction targets or reclaim targets?

> It is not a demotion target selector, not a
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

To me I think the other interesting aspect is being able to evict memory
from lower tiers out to swap so that toptier always has room for
demotions, preventing swapouts from higher tiers. In fact I think for
my interests this is the more important use case.

> The existing memory.reclaim interface cannot express this. It applies
> pressure to the memcg as a whole, so on a multi-tier system the kernel
> may make progress in a tier different from the one userspace is trying
> to control. That makes feedback control of tier ratios ineffective: the
> controller can observe that a specific tier is over its desired resident
> footprint, but it cannot direct the next reclaim request to that tier.

This part is confusing to me. The kernel curently doesn't observe
per-tier-memcg memory footprint and try to manage it, does it?
( that is what I'm trying to solve currently in my tiered memcg series ; -)
  but as it stands right now, I don't think there is any feedback loop )

> Patch 1 adds source=nodes:<nodelist>, which is the basic source
> selector.

In general I agree with Lorenzo, it took me a second to realize that the
bulk of this series is just adding a nodemask to
try_to_free_mem_cgroup_pages. It might be helpful to just call it
"reclaim" instead of calling it an aging pipeline.

> Patch 2 adds source=tier:<N>, where N is the memory_tierN id
> exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
> only a convenience layer over the same source semantics: it resolves the
> current tier nodelist at write time and then uses the same source-scoped
> reclaim path as source=nodes:<nodelist>.

Personally I think that it makes more sense to just start with a
node-based reclaim interface, and then extending it to tiers. It seems
like the tier usecase is entirely doable with just a nodemask interface.

And in this case, since we're just selecting the sources of reclaim,
tiers don't really matter, right? That is, we don't care if the memory
gets demoted or swapped out, we just care that the footprint for the
tier memcg goes down. 

> The remaining issues from the old discussion are intentionally left out
> of this series. If userspace needs to control demotion targets, that
> should be a separate target/demotion-policy ABI rather than folded into
> source=. If userspace needs a strict "bytes actually uncharged"
> completion mode, that should be discussed as a separate accounting or
> goal extension because it would change the observable meaning of
> memory.reclaim progress. This series only adds source selection for the
> existing reclaim policy.

100% agree.

Thanks Li, I hope you have a great day!
Joshua
 
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

