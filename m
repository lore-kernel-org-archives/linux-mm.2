Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459DFF01822
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880A06B008A; Fri,  6 Mar 2026 05:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82DF16B0092; Fri,  6 Mar 2026 05:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D746B0095; Fri,  6 Mar 2026 05:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 620766B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:23:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E9BAC1DF4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:23:00 +0000 (UTC)
X-FDA: 84515250120.24.C32021B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE9C4180007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:22:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d4s7wDXd;
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tX/SD6EVQ4Rky93nE+4JayZQSa6Ld0wpdeMJeB4Y+k=;
	b=PKyzDwRuewxv5ciSX2KUMyAFusrTxvzd7qOAN/C9CipB6cdFNasl1l5Klx/jL4NkuR+V+s
	2B71pstxkWsuuOhxpXz4akKjumxN8hl7FmCpS0dcTC6/l2JA7AoQBIczvYR8A2sKQvN1SG
	hiN5TAFVy7RrXhgDOlJJA2zpNuSx+r0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d4s7wDXd;
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772792578; a=rsa-sha256;
	cv=none;
	b=KG1pYuGs3Buj8bYJCgpBE8z1ixeZiZZm5gJDGZSGvI94I4UYLntQliuDkQDmkjL+zDPikk
	xjmLQcPjhiFAUXEK0dKO/wDxWtHkWO8XaWdrnN2j8EBJsOtl2YlmHUOZX5SyYnXp2oLQ42
	u9C6KNOH35GFMcMn6nqAghenwubpvP4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772792577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7tX/SD6EVQ4Rky93nE+4JayZQSa6Ld0wpdeMJeB4Y+k=;
	b=d4s7wDXd+NuJqZsShFizKUGDJw9DAjy2PkNWYw0R5uGQotGK6D4muI4X/y3Lu01eJTvZ8X
	jWYJTa+3uvGE+kSDmYhcffYyQoWmA7dPwMY9kaqeJT13QArR6fU8tpbGwv+iUzwj1d/L5F
	8RLrogJ3qL88IHpl8vvZzI3tUNejVOk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-rqhmoTM9OGy0XfnfP41-7A-1; Fri,
 06 Mar 2026 05:22:54 -0500
X-MC-Unique: rqhmoTM9OGy0XfnfP41-7A-1
X-Mimecast-MFC-AGG-ID: rqhmoTM9OGy0XfnfP41-7A_1772792572
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF6011956096;
	Fri,  6 Mar 2026 10:22:51 +0000 (UTC)
Received: from fedora (unknown [10.72.116.21])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6459B1955D71;
	Fri,  6 Mar 2026 10:22:42 +0000 (UTC)
Date: Fri, 6 Mar 2026 18:22:37 +0800
From: Ming Lei <ming.lei@redhat.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	Hao Li <hao.li@linux.dev>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <aaqq7YmUcOht3GWH@fedora>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
 <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org>
 <aapeVb_L5zohWRRe@hyeyoo>
 <d5cd4eb4-1703-41af-9c71-842ae33edbdf@kernel.org>
MIME-Version: 1.0
In-Reply-To: <d5cd4eb4-1703-41af-9c71-842ae33edbdf@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: UAKn5RuELeSCNmRVitVvtNxMLLRKx5yNxrFKIRX0k0A_1772792572
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: x8u6iafes3ogcu4e5gkyz8j3sn6muikd
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EE9C4180007
X-HE-Tag: 1772792577-954250
X-HE-Meta: U2FsdGVkX1+YW+BPv5eYfC8BoYVOxBxchDzjXVhVWMgYDfLLXXkm4H6aKnZhkqbwrEwsm9CgS+6R6leEivN1eAwIqaPG03ITHMoJqvHTOAf5S2uV1oMkxzqMLpEuKuaWRh1u+wP+JC+RZcZ0QuW94WqmqPsIYsJxNkcYH4w9mALqUdboCvklmoHmD7d7lR7JMNnjGSEshsGf6I+kp3qLqht8AWEwnFNzHwY9gmmqzOHiE5FYEAj7d1A7Zh2F/OTqitOJGIjdu6TY1LohlA4gxZQU9Q6ThLoMZoy+EIZMPBei90h6SakScCj2J2q+7plpEFqOEcNPHgv6Ikm3WVzbfeymv8bz0vpXgoI3EtJJ+gV2oNXfTgKBYiCiSeiIrn+VgUiA/1RIyK/FXpunG2fdlDctCEpHXJQ6vS4g20rJERHbP657v3waB5k6xQeKpfZl0k7yI8GIS2prXxBGproyT6BMMpBdspwNR2hypbNPwytgbcwMJZzkjV7+Zd4Vdgwr+vbNeaOJNQPZskW8WMxVnrg4ZPeFe3kJtAfStvEdBHrK+A44G9cvgbaoSbo6EDnKZDoOThwtWs7xdC4yEy8sEWNtqHHB65zXBBAkeBjGL9KC9Xy1LxpHls6bGRjKUR/5grsEkX3GQIS+ytdkOmc/4KC6Nd/rL6ly5P3DOoNHIu1aBoyOc3099eRpgdZPXn3oGHW8ugPErCIMamQPjstIBSw2D6j9KgaeUyduqTfLFMAYPgqjbSVEzrPn57BOEutRkWGnW6mfF94aWXfM3lf1zUKVBjcttTsPq4WAmu3GsUtKb+UfuFtWK3+dx7zislzElaZ7dVgYQpMxfO5uYNyZG9jk+z3xOwHhU/mKXdDPCumjH7+SNsD2ERSbI5MFXpxaopRNNWNo7tW9P7l21PZwCN8YTHQwwFsR39eyK+dRYCjfRIeGYtagXlK6pm8PHkQ0MkjLjR2inZEyQm7pjcn
 92s7l5Rz
 +U24q5XrB5BtTUk4F78gG5mIZ4dF7ZYe1y0vKb4GngRqUnzF4ASqcF7auQ6NnG9MRBvoOjtSwR1b+9Yn+m15a6AoGUb0wjEssqnd7hAYp/TN0hx1GGYe2S4WwfJ49efk0XuLF1DbjY+orGWkJNKWbWW0PsnZpZ2OiqLrblhxryIXNcz3aj8bQWeXQv8lnGHNlPCU5Mzqqy9XZPKzgMTkR9JobdF8tbMoMGLwb4ytNND7RzxMX2KAhHiCIeOl0AIyF2ekhOkUkHqy8UO/ih8NmZNVFnC19JhjeYkEQ2lm8lBG/wech62yS1osO76mMtHMM+V0JtwN3aJ2BffK+eVvbI/hYVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 09:47:27AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/6/26 05:55, Harry Yoo wrote:
> > On Thu, Feb 26, 2026 at 07:02:11PM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 2/25/26 10:31, Ming Lei wrote:
> >> > Hi Vlastimil,
> >> > 
> >> > On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
> >> >> On 2/24/26 21:27, Vlastimil Babka wrote:
> >> >> > 
> >> >> > It made sense to me not to refill sheaves when we can't reclaim, but I
> >> >> > didn't anticipate this interaction with mempools. We could change them
> >> >> > but there might be others using a similar pattern. Maybe it would be for
> >> >> > the best to just drop that heuristic from __pcs_replace_empty_main()
> >> >> > (but carefully as some deadlock avoidance depends on it, we might need
> >> >> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
> >> >> > tomorrow to test this theory, unless someone beats me to it (feel free to).
> >> >> Could you try this then, please? Thanks!
> >> > 
> >> > Thanks for working on this issue!
> >> > 
> >> > Unfortunately the patch doesn't make a difference on IOPS in the perf test,
> >> > follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):
> >> 
> >> what about this patch in addition to the previous one? Thanks.
> >> 
> >> ----8<----
> >> From d3e8118c078996d1372a9f89285179d93971fdb2 Mon Sep 17 00:00:00 2001
> >> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> >> Date: Thu, 26 Feb 2026 18:59:56 +0100
> >> Subject: [PATCH] mm/slab: put barn on every online node
> >> 
> >> Including memoryless nodes.
> >> 
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> > 
> > Just taking a quick grasp...
> > 
> >> @@ -6121,7 +6122,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
> >>  	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
> >>  		return;
> >>  
> >> -	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
> >> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) == numa_mem_id())
> >> +			|| !node_isset(slab_nid(slab), slab_nodes))
> > 
> > I think you intended !node_isset(numa_mem_id(), slab_nodes)?
> > 
> > "Skip freeing to pcs if it's remote free, but memoryless nodes is
> >  an exception".
> 
> Indeed, thanks! Ming, could you retry with that fixed up please?

After applying the following change, IOPS is ~25M:

- delta change on the two patches

diff --git a/mm/slub.c b/mm/slub.c
index 085fe49eec68..56fe8bd956c0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6142,7 +6142,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
                return;
 
        if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) == numa_mem_id())
-                       || !node_isset(slab_nid(slab), slab_nodes))
+                       || !node_isset(numa_mem_id(), slab_nodes))
            && likely(!slab_test_pfmemalloc(slab))) {
                if (likely(free_to_pcs(s, object, true)))
                        return;


- slab stat on patched `815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next`

# (cd /sys/kernel/slab/bio-256/ && find . -type f -exec grep -aH . {} \;)
./remote_node_defrag_ratio:100
./total_objects:7395 N1=3876 N5=3519
./alloc_fastpath:507619662 C0=70 C1=27608632 C3=28990301 C5=35098386 C6=9 C7=35782152 C8=115 C9=31757274 C10=32 C11=30087065 C12=34 C13=31615065 C14=7 C15=31798233 C17=30695955 C18=128 C19=32204853 C20=64 C21=36842392 C23=36212376 C25=30013640 C27=29055001 C29=29990232 C30=48 C31=29867595 C36=2 C50=1
./cpu_slabs:0
./objects:7232 N1=3816 N5=3416
./sheaf_return_slow:0
./objects_partial:500 N1=195 N5=305
./sheaf_return_fast:0
./cpu_partial:0
./free_slowpath:20 C4=20
./barn_get_fail:260 C1=6 C3=26 C5=26 C7=7 C9=5 C10=2 C11=26 C12=2 C13=10 C14=1 C15=19 C17=8 C18=5 C19=19 C20=1 C21=9 C23=22 C25=11 C27=21 C29=26 C31=6 C36=1 C50=1
./sheaf_prefill_oversize:0
./skip_kfence:0
./min_partial:5
./order_fallback:0
./sheaf_capacity:28
./sheaf_flush:28 C24=28
./free_rcu_sheaf:0
./sheaf_alloc:178 C0=4 C2=9 C3=1 C4=9 C5=65 C6=4 C8=5 C10=8 C11=1 C12=4 C13=1 C14=8 C15=1 C16=5 C18=8 C19=1 C20=3 C22=10 C23=1 C24=5 C25=1 C26=7 C27=1 C28=10 C29=1 C30=2 C31=1 C36=1 C50=1
./sheaf_free:0
./sheaf_prefill_slow:0
./sheaf_prefill_fast:0
./poison:0
./red_zone:0
./free_slab:0
./slabs:145 N1=76 N5=69
./barn_get:18129029 C0=3 C1=986017 C3=1035342 C5=1253488 C6=1 C7=1277927 C8=5 C9=1134184 C11=1074513 C13=1129100 C15=1135633 C17=1096277 C19=1150155 C20=2 C21=1315791 C23=1293278 C25=1071905 C27=1037658 C29=1071054 C30=2 C31=1066694
./alloc_slowpath:0
./destroy_by_rcu:1
./free_rcu_sheaf_fail:0
./barn_put:18129105 C0=986015 C2=1035357 C4=1253502 C6=1277924 C8=1134182 C10=1074529 C12=1129101 C14=1135641 C16=1096273 C18=1150168 C20=1315792 C22=1293288 C24=1071905 C26=1037668 C28=1071069 C30=1066691
./usersize:0
./sanity_checks:0
./barn_put_fail:1 C24=1
./align:64
./alloc_node_mismatch:0
./alloc_slab:145 C1=3 C3=19 C5=6 C7=3 C9=3 C10=2 C11=18 C12=2 C13=6 C14=1 C15=12 C17=8 C18=3 C19=12 C21=2 C23=5 C25=7 C27=12 C29=15 C31=4 C36=1 C50=1
./free_remove_partial:0
./aliases:0
./store_user:0
./trace:0
./reclaim_account:0
./order:2
./sheaf_refill:7280 C1=168 C3=728 C5=728 C7=196 C9=140 C10=56 C11=728 C12=56 C13=280 C14=28 C15=532 C17=224 C18=140 C19=532 C20=28 C21=252 C23=616 C25=308 C27=588 C29=728 C31=168 C36=28 C50=28
./object_size:256
./free_fastpath:507615526 C0=27608438 C2=28990052 C4=35098103 C6=35781903 C8=31757101 C10=30086841 C12=31614841 C14=31797983 C16=30695700 C18=32204722 C19=1 C20=36842201 C22=36212117 C24=30013416 C26=29054742 C28=29989974 C30=29867383 C31=4 C39=2 C47=2
./hwcache_align:1
./cmpxchg_double_fail:0
./objs_per_slab:51
./partial:13 N1=5 N5=8
./slabs_cpu_partial:0(0)
./free_add_partial:117 C1=3 C3=7 C5=19 C7=4 C9=2 C11=8 C13=4 C15=7 C18=2 C19=7 C20=1 C21=7 C23=17 C24=3 C25=4 C27=9 C29=11 C31=2
./slab_size:320
./cache_dma:0





Thanks,
Ming


