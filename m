Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58E1606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=bjp6CK6n
Received: by kanga.kvack.org (Postfix)
	id B2C1D6B071A; Tue, 27 Oct 2026 09:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03856B071C; Tue, 27 Oct 2026 09:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19346B071E; Tue, 27 Oct 2026 09:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73CFC6B071A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:49:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 229DFA876E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:49:17 +0000 (UTC)
X-FDA: 85368537954.09.845365D
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B16C1C0010
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:49:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bjp6CK6n;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793108955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XomX6DB6D1/SIO93qU+NvqAlwsKLsAk/d0xRuNeXAOk=;
	b=iYDPRzHX1IdsU2LftvwcIyIKGfc2OMOo3HpVZQ9XKKQq37/Gv1EvA9zKA24lcJPoR9GIV8
	m61wwOmbBMBA3nwx8uOee/ScSKRBHU6Tvt7+5JXR+Gg6fzH9oP01d7UeA8EMEbCvfZTGBN
	XPX8Sfqc4K2xpgeMnJ7Q73ub/jXvaFE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bjp6CK6n;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793108955;
	b=C3qBLxjC2v2rF+1Q06NVFM4gvX+zesMAtH9IfIHHG0DCR2CllIjOvJ/dlFqKPadG8+etZn
	YdYopA9aKyt3K9qw8L3pPzY+Ei5gj1JS2ZUek6Z+9XOwY0rn1uW64gMhDfSV0jB4W5EmMs
	DyZM6BElWxbKSlLhNQK1w9MpdFw5v6w=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-536c8f958d7so30673801cf.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793108954; x=1793713754; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XomX6DB6D1/SIO93qU+NvqAlwsKLsAk/d0xRuNeXAOk=;
        b=bjp6CK6niTJB/rN66qsby+k1yN43TKMYXcqTq3Mvd6FNYaZSGR/9XMmgNX6+v7wJLv
         JF+A0/aOoQ1qOKDNO+x/xLs8kyc4AhluF/WkJJiCd9yreoZb16xNh1wqz5NusYnubcBQ
         lp5YfZFIeTBLcECdenBg5Z3/6VxRjgcaDzjlxLx/HfeBsy61A619vKurEkBnxDbsAHho
         1esVuWsZe8CqcrHQjsxG5RYONoiVnEI2z7Crt4jhFCWEwQd/JNU7eKy6SGD18NqgRlRI
         DYXMl1W/TNaQ80dFm31guh5HGVa6+gG0SUO9RHuhdpw6p1EK7WLbtFlldUqMl2U4Fe9q
         xAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793108954; x=1793713754;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XomX6DB6D1/SIO93qU+NvqAlwsKLsAk/d0xRuNeXAOk=;
        b=f1TWfO/eflZMoXBHeNjFkLnVj7mlWonNJrfWXmZJ2YoRhYUUxeXf96Tp8+mZIt5Xls
         C/jm7MWNzhglAXvajQztUt+RiJWr+ylTko7NkXbmDmmNKXpurigH14kHimjCkAZwhnL2
         meeqEd72Aa/bK3Urbk4pgWQdSlCB6Lx0kKrm8B8VT3APhl4qeLozLwLJNWtmQTL/0Tco
         ifBmTYvOsGK1qQ33SwlbWN0qp3aq9232u0lwRJWsOoI3jepC/nOqNCbHvK/5+FiYtisO
         Lj9phe+YdT3HpmVGnqzQbHKrFByWwQrS3lHyUM7oa2CoXDpql4yQPVdGraUFnitpiE3P
         BBRQ==
X-Forwarded-Encrypted: i=1; AKwUvByf6l/pB/KuzDJ3fER3M+YUS9PjshNrN8AFp2wGLBkO33t30PC9H243TqzpSlT3oBMSIMzpFnLfrg==@kvack.org
X-Gm-Message-State: AFq9FYKNiRLPO7RI3Rbe4T2feuelCLrnkgExyHfLx/5Hr5WfxUHWG79y
	NUacc9cLoXOED2w1VPjYFPEDCh4Rwp3OHYk/1MClsT2ZPG+LN2RYkJuiwu0rkgHGvE4=
X-Gm-Gg: AYBFou2lwuHg37rKkPI2hyEqUxCYPavw1fedQ4yDS6reO1FhffjncgEAJxJF5njnAGE
	HKSErAwN61uneINUb/tF+J1ef7XxXaolLBM1cLMUkJGqkBNDlBPyJ+2GRIQjar1F/5YUNKo0hg/
	/LZpcjysLuWqyLKYN8OusjSwNMdtsGCx0LFKWinvwQtpEs0ZEORxwyi39jL6pvmePMXDXEjfdzq
	xV/JVoWoKKScgQ7DnDR7oHVMQRFL5ywdvPecXDngH36HZFV6MMJlAPQtBZ0SvJ4vlnNalbvhJzn
	Dhqni2cGqFNdlltUB4wtjwTHxtrVS5dekFaaSTpXfHKvqfnw0D57MWbKENVSk1yvhuRk8+WkRYg
	2HYY3OF0kJ4wsLKum18/T/opdG071iYYa2RK63c30znjXAWl544AAP3lLkACm1eSjGXdo1bfQW2
	aD9brTq91LAWDdAblHuOyJ+z6bRtdE1KA9a5lYPIvAdsQBuDKFxk1/8/SUWjydGA3Lfe8opVDky
	b1DZGqFD/D6s9M3KQuuisls5RtZCkH+mGj7ITy8aH+lCXWdnXy5db+tOaIqWL/6INCRAmH/cLz1
	6xXkdnZoe3cXs73U6GM4Ol2dBsI=
X-Received: by 2002:a05:622a:1b10:b0:532:f0a2:ef4 with SMTP id d75a77b69052e-5383b4caaa3mr156684351cf.26.1793108953988;
        Tue, 27 Oct 2026 06:49:13 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53839709ed6sm79085531cf.16.2026.10.27.06.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:49:13 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/6] mm: fix pfn walker races with memory offline
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org, 
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
 hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com, 
 nao.horiguchi@gmail.com, ljs@kernel.org, liam@infradead.org, 
 rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev, 
 iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
In-Reply-To: <9051ac3d-60b9-4ed2-b781-b7191898bc83@kernel.org>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <01d7d54d-0047-4eb6-a1d2-5b3f113f26cf@kernel.org>
 <179310071902.664110.12994053710961856591.b4-reply@b4>
 <9051ac3d-60b9-4ed2-b781-b7191898bc83@kernel.org>
Date: Tue, 27 Oct 2026 09:49:12 -0400
Message-Id: <179310895201.1491991.14362391061932133491.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B16C1C0010
X-Stat-Signature: h9p8bz3bfakmt1zf8hiydbf6fm97omk5
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793108955-36294
X-HE-Meta: U2FsdGVkX1+OWVHnrf/ki1VuTalLJvzVeEgM1ldpF1R3XrJSe9qNHsZDrnP43WF90/fRZmk/VA209NqLfxGKcJqJzh7sQTI9zBwctx5orS0foFg1R6ZcKQaUUV/7PfI6hR1hxmfKnrkJUZXng9nykzFOPDP8FL0C7ddThsN8flXioco6Z8h9o6cna4re+mBE+wAsUEJr2JUG8qrBOkJ0xtF4embMI0822Xavp2diWPKlzJYJqeVC96CnD3IA9WQxvIYmP4FgJrzOstVyTvWBezC+RGZo1XzCuMHZVJUUAdt4q4NfZVpzkDOWKeIF82VBvGy7OQB2rSWjJtl7fs878OP3vtZ0jBNcDENZ7SA+XeTAfFI6vOwsG1fCTlhcbSkmImzPZL23r7ihxZxur+hXw3TsXrhwSZCRZMvS7IOP3ZbDXLJdcAMdk1T/XzMo0iR8pFFXf5GqFhRbcAvSr5vGJtNLqpxArWBhruDJq4LSM6YeMJ/5LZs1ypDJ1pXdZc0EVm+oDxkpoj4FIiZZ6HlB665eCnys8UTYU0yL49TTdIaqGO+eLjzSVtLz9XKJJIzot4gDRx97Tqh2JIzqtYota6ufRGJi8LxlCiRL4BvU5YmI8nlC61/yWntSa1r4ea6Tq0ttCnGePBtFZLcImETUhRlR6l5NzkYv9EMXE2yQzMbNZrgT+FSJ+8JuPjTV5qXT02RKcijLl5DLbhhZNoMerqy0FANibKwKEHdw7fXerfvoHhdyYE+51vTIMY4T/IRDOzpGJWjQeIMuda1lPH9ACpYak01aAh3SelnZ6XkGwirj/vPcHvnIS7kBFlVliO1wELNzCFPcIyPaCxBU3ljfO/qH1MleDr/Yu30/7ahYD1NXw9tZQjlNmklPA62gaKShGgxzfaiY3NiuB0OW6zBDYK1nCe5Jkq38ufqrNc9JEBWqI24DLQgvVORSBoeUSiU0+95NRzFveeEp4T1mefe
 5JFkO51K
 CyKe1GN62cw2OZRcolpuBaJJyZy9CUVpnmn7u7CyuyUDMajOrWnxSGwbRjvXWn4hH9iRlGTD6DgsMZENr94Ssfej+zWPkEcgPeb4zw/VyYY+4Elj1hP8Mis+KHz+16NYhh5FWeYudoVi917bxbHTOClzXoTwgJOJx6J+BtXZtKvZpSuFNfDr+zP50L/Q3F3jUyt+pHG4Vtp/Z1rYPaTExuTYIXTLkOd6thYqRmnD7XfhyVAUdR18Qu2e65O30beAZ8TOn2az5K8WGcP6MHJd5nzy94yM322rEZB3zLuSkZOSfJiRV06KbKaBfyGa1pY3rKZaFqpL68iuUWoKlHxv9JrSG6dI8iLGTH5FVxP2i8vAeOrK3TcBqw9k69g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 13:51 +0100, David Hildenbrand (Arm) wrote:
> On 10/27/26 12:31, Gregory Price (Meta) wrote:
> > On 2026-10-27 09:57 +0100, David Hildenbrand (Arm) wrote:
> > 
> > I actually have a reason for these fixes other than "bot said bad".
> 
> So you found them on production kernels?
> 
> We did not have a single real report of that for probably a decade or
> even longer in production.
> 
> Recently, we had the single first report about the compaction case from a
> stress test (no production):
> 
> https://lore.kernel.org/all/20260903095543.3752338-1-yuan1.liu@intel.com/
> 
> "We are not sure whether this race is reachable under realistic
> workloads or only under this synthetic stress test."
> 
> Where I motivated that we need something clean.
> 

tl;dr:

while these are ai-generated, I'm not posting untested, unreviewed
schlopp for the sake of getting patches upstream.

I actually care about this issue.

---

Some of these don't show up as crashes but instead as hung offline
attempts (GFP_KERNEL landing on movable).  That shows up as our
hypervisor just failing to overcommit / guests hanging.

The compaction/alloc_contig bug is one I've seen in production.

I've seen a handful of NULL derefs in production i suspect are the
zonelist derefs, but it's hard to say (they're rare enough that we
lose the dumps before someone has a thought to pull them).

I expect this will scale up as we increase the number of VMs and
the amount of hotplug we're doing.

For clarity, we use ballooning + hotplug as a combo:
 - ballooning to do cooperative overcommit
 - hotplug to defend host stability when the overcommit ratio is extreme
   (basically deflate_on_oom because a host stability issue)

We're pretty aggressive about ballooning guests to squeeze them and
dropping the balloon to hot-unplug that memory when a guest is cold.


skippable side note on virtio-balloon/mem:

I have some improvements to virtio-balloon and virtio-mem that allow for
handoff from balloon directly to mem for hot-unplug without having to
drop the balloon, but I haven't posted those (and we don't run those in
production, so this is not the nexus of crashes).

Similarly I have another extension that lets the host set a "NO_ALLOC"
bit on the zone so a balloon-only system can provide the host a way to
defend against mass deflate_on_oom events (we prefer guests to OOM and
have the host to kill them due to PSI, rather than threaten host
stability). Also not in production and not posted, but there have been
a lot of experiments on overcommit here.

> The thing is that the race between offlining and actual memory removal
> is extremely long. Poisoning is just a mechanism to find these theoretical
> issues that could cause issues faster.
> 
> And with all the other things going on, this has lower priority, and I
> wanted to get back to the AI patches I have once the other thing is sorted.
> 

Sure, I realize I'm pushing this out during the merge window, but I
felt it reasonable to get some thoughts on whether these fixes are
worth considering for the window.

If the answer is no just put em on the back burner. We can carry
fixes as-needed.

> > 
> > I have a reproducer for every single one of these (and the other
> > series) - but a handful are unreachable due to a 2-statement read
> > being emitted as a single read by the compiler (which can be undone
> > by a targeted compiler flag). Those were included for completeness.
> 
> 
> In general, I think we want something that will protect all
> pfn_to_online_page() + zone->contig thingies, not just selected ones.
> We discussed in the past using some sort of rcu for that.
>
> get_online_mems is usually the wrong approach.
> 

Agreed, although the PFN walks seem genuinely harder to wrangle into an
good rcu shape.

get_online_mems seems like the backportable solution, but i can see not
wanting to have to go clean it back up later.

> protecting individual pfn_to_online_page is just whack a mole. Likely we want a
> way to check whether pfn_to_online_page() is called from the wrong context, and
> maybe we need a variant that can be called from "wrong context" for a good reason.
> 

Agreed.  Although I fear the structural fix for this will have uglier
performance issue than we think.  Then again, maybe it doesn't matter
(if you're doing a PFN walk, then you're likely already doing something
stupidly expensive).

Where i'm largely concerned is the page allocator and the
compaction/contig code not taking a regression.

For zonelists i've ended up with something like this:

@@ -1461,7 +1466,7 @@ typedef struct pglist_data {
         * Generally the first zones will be references to this node's
         * node_zones.
         */
-       struct zonelist node_zonelists[MAX_ZONELISTS];
+       struct zonelist __rcu *node_zonelists[MAX_ZONELISTS];

...

static inline struct srcu_ctr __percpu *zonelist_read_lock(void)
{
       return srcu_read_lock_fast(&zonelist_srcu);
}

static inline void zonelist_read_unlock(struct srcu_ctr __percpu *scp)
{
       srcu_read_unlock_fast(&zonelist_srcu, scp);
}

DEFINE_LOCK_GUARD_0(zonelist_read, _T->scp = zonelist_read_lock(),
                   zonelist_read_unlock(_T->scp),
                   struct srcu_ctr __percpu *scp)

static inline struct zonelist *pgdat_zonelist(pg_data_t *pgdat, int type)
{
       return zonelist_dereference(pgdat->node_zonelists[type]);
}

With this the zonelist cookie checks evaporate, but you still end up
with guard() at every walk location - not great, but better i suppose.

I was hoping this could be sunken into the zonelist walk macros, but
I haven't seen that pan out.  I've been spending a lot of time auditing
that code for private nodes as well.


On performance:

I've been hammering this with will-it-scale and a bunch of workload
tests on a variety of hosts and have not seen any obvious regressions
outside of powerpc (which i can't test directly, but SRCU-fast requires
atomics for powerpc from what i can tell - so it will eat overhead
without a fallback... if there is actually any hotplug ppc hardware out
there to care about?)

-- 
~Gregory


