Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C355CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE426B008A; Wed, 20 May 2026 23:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFAC6B008C; Wed, 20 May 2026 23:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C58E6B0092; Wed, 20 May 2026 23:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC9F6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:22:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18A59A02E0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:22:56 +0000 (UTC)
X-FDA: 84789980352.21.E35ACBB
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4AF6B40002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:22:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oy7VnsYe;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779333774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCEFUIphaYwH63nwZhxQG+TN7ecroRFNX1EgOEudxtY=;
	b=ZZwQlGTYn+J19JUvmto71KKYMAIPYfjTLlPbwOQAY64+K4QWaEBZZMYk2iQRyIf3/tuUmc
	D3RcyMFVmnuUnR7L1E4D0FQZqvRCObathuz01lS9izUhR1YtFcLgRr80Mqgd0fjAv8EARX
	tvgHAsf/vJtXIFhqVSwrUkyfDwtVUog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779333774; a=rsa-sha256;
	cv=none;
	b=RTtI9baeyWcSbH87mp8N8X4c3TA51kFJ9XekS4eCtm7DpKq7PV8QMFE5nA99FVvH3Bqdio
	y4m6zqHix6DHaidjKDUgxWJ/RvakbJ76AEPDEKk6B3xBY/uMXDI8kVGehIgenJg8X13OaB
	vjEbU61qDKUJNM4T2hJKHijsKR/mscA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oy7VnsYe;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7de46b8e432so5629971a34.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779333773; x=1779938573; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCEFUIphaYwH63nwZhxQG+TN7ecroRFNX1EgOEudxtY=;
        b=oy7VnsYeeFU/cGXGTogSX/JytQ/eBEi1i9A5MyTpPeYq7zPjGopGSL4fZlZFdNlt9J
         +JqW7IkUSnXpRL/LGSN0cQgsG3h9sREXGXVjEdWSvA/5Kc2dPACAnGw7bsXQe8coZ9w5
         PouF648H8ZueJp3yyWtk5WKNUHEK6OsBd+Kb76Qy9vluXwlS3RB9BzUk1ro1Ty+paBKy
         vF59fxQ06bnTR/F9p9a6jR2s8UjDENpy4SQoIxzmnbU85FJ9JsGz/oYLb/K4vR4HU4GC
         ykp9uMONTS3H1xJOMVtwTxO/04EFBb9wsdlcRrfs1/jOz534MjM0QEm/2xYaIlEr8uQN
         Uj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779333773; x=1779938573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RCEFUIphaYwH63nwZhxQG+TN7ecroRFNX1EgOEudxtY=;
        b=oMsYSoY4yCeXNumTfpB29svUaRGOclUEvX8bD4xPtVGaxRhL9bEx95v7JMpfYH/DlP
         HWH7DzgV1ajnkdVWCWWkJYeUsdB30gWtO/tCuMI7z3bleypkIGtyJmrEE57soiIhDLcI
         a8W7YXrEJe5U+l+MHLsn0Gl1vaYQ+XF8ea3mYTL8Y4Br/4avAUZGjAvsnvJ/gTp7zYky
         e9XzLYZ2dBhtatMw1K/eCpNYQpAooqrVzi4OvLIQnnL7pX3lUNhxGsXZJobz50jwAkqn
         Kb+Sm+RwAPzBtUR4usADtfuUn3+Zcg5ZKvzOnzpkUMpgSnf7DwlPpGWvgJzufoLGaxad
         PHgA==
X-Forwarded-Encrypted: i=1; AFNElJ+Z9N+Xm1Hu5AHzdNJGciCzUJjiQwfZMD4+pVdNeREc+R8xmXkaYzR5ThgEi1SNGc2bCAgJ/VCZxw==@kvack.org
X-Gm-Message-State: AOJu0YwTHmL5nm3DH4ge7TJ2fmtw8hCkQs0V01PVY+uYZc3gpNPs8LRU
	V9+c8EYtCL56P3CWrlsUnrmkLM1pZ1MnEcFf4F9k8XAAk2nuWsKHT291
X-Gm-Gg: Acq92OHgxGqOnxofEZXdyeSwTep8tfgpsQGFtp72zob15UYsFbH3DDCC2bDFYh6lOp9
	hXcCtvq3j32cd0THnIjCGiB4ydM2hyxhpsZjNdeR4ZrIGUFYwvdGTnrUe4kwaFSK6SzKHvR4Imo
	MVFu7tAjTYR4VID07vVNxHJUgBL8ouL3fNJ8PLB/tJt9YrR9Z8czwuwkpGZtOdBK1wFvDxYlaq8
	UtaJqE+aGUMTKFtDd3LZksnt9qdMWqZhYDuFKHBcRFLSv9OKMyR5U/xVQUowtOJ/sY5xrpRTTY5
	w2boXh19CpCRS5I0x3qddipCHtKCViv9PrVzsa9jaMjoGw0CQhADwpRqQLfQECCUASX+3ztJqum
	MFgGPttfBMSn3tOjfeAruYL408uAeb6U86Pbt0wp3LjjYqz9hckmSZPtOrgRpDMHNLedREQP5cZ
	ZvPEKaiCGFoREPNDnSHAQNJtOBbBEqwx7Xbwa+v/UpzgLuttSQMSzF
X-Received: by 2002:a05:6830:6881:b0:7dc:3db6:f02 with SMTP id 46e09a7af769-7e5ec271d04mr523258a34.9.1779333773170;
        Wed, 20 May 2026 20:22:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55b7c68d6sm13479796a34.3.2026.05.20.20.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 20:22:52 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 4/4] memcg: multi objcg charge support
Date: Wed, 20 May 2026 20:22:49 -0700
Message-ID: <20260521032250.3853564-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <ag5Z9uIMoXpr3rLP@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4AF6B40002
X-Rspam-User: 
X-Stat-Signature: cnopp1oncc9h5h8xjqjs6bmkfndmxnd3
X-HE-Tag: 1779333774-904008
X-HE-Meta: U2FsdGVkX18/8aCYsc3IAmeTyHhZQkDjR+ntJajt4oowSVCUYDf4cu261KnXmrs6EZrFapscnFmxwqH0RD3HgJ/sEWoCCKTDT7wW0gsrXq0BzzZauE2qKGTl5kia0U/0dLBd1xyRTDhuFJLE2nXWMkuaAOJJ8rVJiiXr9d7kXI8e/DisqQSXSVZjFt1wMTRvcdyFkqsghFbL5SkUmdaJ371yH6xS2sG2nGdOeSTsuM3GMaIdXigPtGfjo+viCX4M2MGQvQAK9/qzJ7RpCuuixzSLB+APnHCGDAYpHC9ARP5uRo9ddvgPElbaqNqybIwbKjsydytZN44tFxBzATr7Tbw4vLef/8f5otoXQlllvf2K0wFc5mmQyl1NsNLCv1du36dKoA+AzLAKEb+330xmDR93gqGvRSsik3dZX/P5Ma1+LNqpjsLervslInm/5kde3aDLz4h9HSbamlYcqmhjtDXkSYB5YizknncwvoPUFMg/EJTTt62kDPRuzcGpGCSRrrYk1Y85Mzr2HddCV+nP3jqc976o3lnMvfEwPvLTQ++cDfgm66zhCtsTww7SfuqZuZaX9Ncn+fKvHXfc0VI+XRGcpEQWWhxMJFgrQoQHgdWZazKTnxPLFMOeyYSj9eOjWK9LG/4kwFCek9vGT+iE5V0/uGJhH9R02A3BI9348k+kRa9r6MoxnE2l1QfT9qWeFy3wvKqlGy5bWymmRlOBTIxV/3m250FdJTMkm0KjOl6E8vhY5UsCz+wV029NNyDH7AjK6QkTFTEtdbmIvZ1Z7fvk1dROj2SLh9qOm1cBYrP1tb+yGCah3C8wkMgIX8+BPW8WLSkyOA/3rBCnmYe7RZVwGZYfh37hDyQn6sWlzwkklOPgSQXbsWIUVabU50blWCOaHfQALEmtrdvOHT7KeJPVgD+VCP4TmEwc+mGuVNPBUQYbN/qqnmX5aQjOBGmcEbJ/r4dMlJZcE4Dthqd
 eWA+miFn
 92zmrAvSATus90MAUe8xRnRiTmgtjOpG5d44QnPG72kN5nMVs/T/PBZVL5tysnznUYkSlEjA0dduNYOVcuDPUQQxcPeTBqMPQdxkM5+BY2IMm94LZX3/pxbXFSvheIHDcMBxIOYFIRz+/vS/UcUsONCaDZuAy694dgS3JyZfzenIQ81xDgQ1BujJmXkD8D8rZewbV7EHeiqwJqGvnV0BWulRy586bQz0ZI6L/dWiHUayeFEv88bbvAvQAHsqWqw8ISxghAJ0CC2ZwV8A47RqSmdWBlJLc1/hyr5F0egl2/ObUNP/bn/Ak2YAGxxUls1Dtp9xmyD/psbewsOjPvGaw2LkzImDPi+dkhUICuhgYiUL9XSVxHg3uHYqywePn+zzIc+9wU9YFmObcKeT59m1eKCQ0HcwCBqQINoLHUXx51sbPBp5CSxPcrlN7bXZmlu9HccFRbdZlG1UPItxXENJHieLG3WAYVAHjceCp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 18:05:23 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Wed, May 20, 2026 at 06:35:30PM +0900, Harry Yoo wrote:
> > 
> > 
> > On 5/20/26 2:31 PM, Shakeel Butt wrote:
> > > Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> > > per-node type") split a memcg's single obj_cgroup into one per NUMA
> > > node so that reparenting LRU folios can take per-node lru locks. As a
> > > side effect, the per-CPU obj_stock_pcp -- which caches exactly one
> > > cached_objcg -- thrashes on workloads where threads of the same memcg
> > > run on different NUMA nodes. The kernel test robot reported a 67.7%
> > > regression on stress-ng.switch.ops_per_sec from this pattern.
> > > 
> > > Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
> > > nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all
> > > slots on consume/refill/account, prefer empty slots when inserting,
> > > and evict a random slot only when full. With multiple slots a CPU can
> > > hold the per-node objcg variants of one memcg plus a few siblings
> > > without ever forcing a drain.
> > > 
> > > A single int8_t index records which slot the cached slab stats belong
> > > to; the stats are flushed on slot or pgdat change. With NR_OBJ_STOCK
> > > = 5 the layout (verified with pahole) is:
> > > 
> > >    offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) = 8B
> > >    offset 8  : nr_bytes[5]                                     = 10B
> > >    offset 18 : padding                                         = 6B
> > >    offset 24 : cached[5]                                       = 40B
> > >    offset 64 : (line 2) work_struct + flags (cold)
> > > 
> > > so consume_obj_stock, refill_obj_stock and the slab account path each
> > > touch exactly one 64-byte cache line on non-debug 64-bit builds.
> > > 
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> > > Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Tested-by: kernel test robot <oliver.sang@intel.com>
> > > ---
> > > @@ -3350,19 +3405,45 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> > >   		goto out;
> > >   	}
> > > -	stock_nr_bytes = stock->nr_bytes;
> > > -	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> > > -		drain_obj_stock(stock);
> > > +	for (i = 0; i < NR_OBJ_STOCK; ++i) {
> > > +		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
> > > +
> > > +		if (!cached) {
> > > +			if (empty_slot == -1)
> > > +				empty_slot = i;
> > > +			continue;
> > > +		}
> > > +		if (cached == objcg) {
> > > +			slot = i;
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	if (slot == -1) {
> > > +		slot = empty_slot;
> > > +		if (slot == -1) {
> > > +			slot = get_random_u32_below(NR_OBJ_STOCK);
> > 
> > It would break kmalloc_nolock() because _get_random_bytes() uses a spinlock.
> > perhaps prandom_u32_state() should be sufficient in this case.
> 
> > Is there a reason why it uses random eviction, unlike multi-memcg percpu
> > charge cache?
> 
> Oh I didn't know and actually we are already using get_random_u32_below() in
> refill_stock(). So, it need fixing as well. That would be a separate patch.

Hello Harry and Shakeel!

I just wanted to note that my work to push the memcg stock to page_counter [1]
actually gets rid of the random eviction and also the get_random_u32_below.
So the problem will no longer exist, at least for memcg/page_counter stock.

I was also thinking whether there was any way we can abstract or push down the
objcg stock to a different per_X slot (with finer granularity than per-node)
so we don't do random evictions, but it doesn't seem like there's a natural
point to do this from a quick glance.

The fix for get_random_32_below to use prandom_u32_state seems quite simple
though, so if either of you would like to send that in as a small hotfix
it shouldn't be a big deal to rebase on top of that instead too.

(Sorry for joining the conversation late too. I'll take a closer look at this
entire series tomorrow as well).

Thank you both. Have a great day!
Joshua

[1] https://lore.kernel.org/all/20260410210742.550489-1-joshua.hahnjy@gmail.com/

