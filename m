Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B1B0CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347456B008A; Thu, 18 Jun 2026 08:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA776B008C; Thu, 18 Jun 2026 08:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1725D6B0092; Thu, 18 Jun 2026 08:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6BE96B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:32:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 771641668AD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:13:41 +0000 (UTC)
X-FDA: 84892773042.24.33370F7
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 986A11A000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:13:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DrXVD+87;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781781219;
	b=6k0OHqXPigNhWplbwg/AHWI6ZG3sbewU802g6ozD2K6N0D3lwpi+FPRNy0Wmw0aFmrQnzT
	dpHqaIrAjj5Ltj2mwQ3yQYPASrtZtPJT+yLVUd2hzt+fVW8qcetRU4TESyLR/u4uBYHpy/
	5IiDW64rLvocGF5wVPWPd0ZCvhzMekA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DrXVD+87;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781781219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDILEybOTlA7pWxB3ZppyNLc60d4wQCyVXPTTIKX4iY=;
	b=ZB8SO42uDH2l27DkzbH7GJe0tf528JM57rAoIR+t+61kldYkriLCLSD8VNw5jOlrIHKw2Z
	gpLPbD8jYprno7NFmC4E5EWNbmPjiEPNc6Nw4nj4vHa4S8RdBZP3dv4nlBv/udGOT94FeQ
	3HYaP9+xzGqUpZFOC+Ncp8uEEtNsr6c=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-91574384cc2so100549985a.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781781218; x=1782386018; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VDILEybOTlA7pWxB3ZppyNLc60d4wQCyVXPTTIKX4iY=;
        b=DrXVD+87WkPAzvRGHPZj3nL78auaQgJ7pZm3tMUDysaH5Di4mOYjCTEIIvyR3Jmkrg
         KLs+C8xXycsR2ZHRRjo3zAnVwzMi52jnCNc9WS1+213ItRic/Zc6akWs1HXQZ4k9OlvW
         7gk8ZKgF9Ih5tmk3qxC4gnR2WYGb3WO+4T1EQXjiQs+GE8spStdpoi2Eb+CyHiayJqRI
         tV2NKNXxR41xbDmdC3n1w/d+bn0fsrFGLBrAWF7LoLIrknD33X0IN5kFAiTciLGT/5S0
         1WyXwwDqKamI9pvTACX4zbYuWnJRRkBydqsehJEeSRAN2N+uiTTtfb5XvgyICSOjXZI5
         nDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781781218; x=1782386018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VDILEybOTlA7pWxB3ZppyNLc60d4wQCyVXPTTIKX4iY=;
        b=Im/xILisef89/UHeSBtBkO+4oBd7S32k7gLuiKx2FpNG2+0Ig/xZMYaCpsRb0yF0D9
         P4v7JoIbzEwMlsoaeOEaaC+2sxWoBfSaCn3W5XomOjawNAId3HqaszqiRa8PYZ/uBMvg
         oJboyuK5F85Ag3VulWbJo3QS309qy+aESbvaApnuD4af4z+7C4dyiH2XVE4BCMQVY6lL
         7z7SLHKtTpfV2vrjxAUl7k/a06W7ShdA+yLN7ccISapS1Scqp5ukcBbf9qLG8L1Z5yti
         dS8TnLeQMHHmLsqQrvKFTaqTAYljang7nirovfQGu0zzbRTZr4ivbXMS3sto/sriI16F
         JoMA==
X-Forwarded-Encrypted: i=1; AFNElJ8P7ypgk04q0e1LSw2rVLEQ7Fsq4gDXLVnzS+Xro6lP/jcGtstZWMrVVVeSg0WyAekemvuPGLPLPA==@kvack.org
X-Gm-Message-State: AOJu0Yxs0atAgMqChrKwv+jGVBLy5J1TXqa0vwpbC7fB0Z1SGj8vvTcP
	wQQSwk3nCxQnUwfGlAMTjL13UBnBX8pDbi/3+/oS3TxaUBq8paduSjDUrbbIg+1FMIc=
X-Gm-Gg: Acq92OHEmdNQyJiIGj76/jgmhMwSjKgbXWzJ/eG8HKFyhheN1f8w5tpFf99DFrmRqdy
	MNBCV0aVJlFt9ht12RCRxqruSJLI4Q9pl0apdrsuwMDIFeL5YmYLSEVfnkTKW596tR75EI/VScy
	UDQFnLapz1FgCvhg0S9fG2Epp1OxwXCuNIbVG4Zznh2Qd/Ya2QwBuqMEqYLndwwlhXbq6TedjY2
	R7995XyH79Ox05vCR1OQqKCCx8uWML56P01h+Xhv44FkxsyT/odHn6EHhN4lz+FCxZ8D9F/A493
	7WLn8CzC1H3hHivCMHISfp8MYXgw4h/mUkp5YcrqJIVtRk9wj80zRpNxUzIjJ7TzEJ0hIUiCu4w
	X6LWLbKQSvOwv7dpq3irQIlAptvdAj9eNMm9eDlLzGSFr8wKzqYm+e3Tfukt6KzT4aGLzpwCvjj
	9RM/DTDV2Plo9BBcG7+BPE8iCA5Li3Opgs+prCJIVX/AwqRoJ3T9ECJjYmS1NT7YDl6dSe
X-Received: by 2002:a05:620a:278a:b0:915:9fba:878f with SMTP id af79cd13be357-91f8ba807ffmr224910185a.5.1781781217669;
        Thu, 18 Jun 2026 04:13:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619ed7215sm1951269085a.7.2026.06.18.04.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 04:13:37 -0700 (PDT)
Date: Thu, 18 Jun 2026 07:13:32 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory
 Nodes (w/ Compressed RAM)
Message-ID: <ajPS3AKrZEbZbXBw@gourry-fedora-PF4VCD3F>
References: <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
 <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
 <aiwl4kCG814dpX7L@gourry-fedora-PF4VCD3F>
 <9f1815b0-896b-44ab-9e6d-9316d8f11033@kernel.org>
 <fdbdc9f7-d142-4880-b429-065d5056cabb@kernel.org>
 <ajAcIwBAnqgEEWSD@gourry-fedora-PF4VCD3F>
 <90418cd3-751f-439d-83ed-a0c33517c3bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90418cd3-751f-439d-83ed-a0c33517c3bd@kernel.org>
X-Rspamd-Queue-Id: 986A11A000B
X-Stat-Signature: foo5hooqb9mazcgncx45kf6zxrmgty7w
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781781219-618944
X-HE-Meta: U2FsdGVkX18IkZ5VM4wxrxxQdm95eyiBlnjrhKfOYiphmpvq20oWpr8GVNDj+KyAeOVzouMp0f7SZv8ZzzZhG5Iy1SDaOzU8PcRyQeiEALsparmLVVWvWntrGBM9UnzHVuhRKEIIQuWBGSJtoQVbl3qIncUFJ/OGif8RHuEUE+q9eRb7afBMfIoi13/iIlLFXaC2Y85IDVff5hoZUo8uvFbdiLySCxSoYWXctPpXqFUX4hqLD3/Hdv1yYPtp3npZ9Bewb1s9G2LOAqOAAZK6l5P/qnjIUb5WGa4ttg9Exg7Aafa6NJfVEr1mEIlH/hDDJX088B+8ipPKAGwLmvG+mrFU2uzuocuTWBqhEh+4aJQBa+bj8J8zPqa5KA7mTNJXp48ELstS8ETyQlNJRwwRtIeaATLi53b7XUA6xz9jIUyAREzueMtcneK46hszvjDxTigRZWVcSKalmI89be3uE7uW0RdgBovsj4Z5DSdt3G5NLS0ryClEhTWXCw1EgzYomqOTwsa/OJ4jMnajef/tl8ufPeyZPUc8+NUrwJnQFuizMSnjgh0QzW/IRCQyEaCuWKV+KlxXGkVKBIDRYrV+mUeV8fVB30XGAkN1SLc90+/4ZSC2t8KUPbjWlQHMoC1bBti106hyzUXHNHQCvXNWKd3lNJrZ+H7ZxPOu8/JS13n+8wb0k47vEeWAM4CjrBHZbLcW7erVfbAOPjeX4nbrZnz1DlYtZrP2rvwIqjd0fISkBSMXD8gMr/ZUAeYo3RtzUuaT+6TmlaxH8do/z9U+X9ghlB2U9QdtPNePKCMj1t532BH5pEm2huqh9OJsGQDt4zeKBMQBeLmw6N5mps+OGbWfEidSsd/T5/MXC72urcXbxILugkP8eLAXnUeqAaV8GLJRHeZIv3sQx0tV+dWe9pege7en62sXOsvqZazuIK57M5UX7gmPH4cSboGPeGeB/mwd0XA+XRRYrvb/I2o
 oBT3c2N9
 5CfvFUmgqcoKHcZVSLcjC1qMF1kwMySAyolVPRH90JfMFbuoYxwcup4KAkzWuyT+65nz3zF1/Pt7x/fSRst1Q8FkReieK9iL91PODeajbtrUVWkkiQdeHtd2VWb0pOPiiR0uPVx5vd4jbxwsda2y+C798vIfFK2MqnlA/nvd44Z9htzBGDOIR43slCJyrCJLekPZsOiFnRdwGmsyAr9OiayixTS3xHyEclQipZo1t7/rWrUugBkQXpe1BO+zPpr72JsUdPvE1YPS3f//mbiE+OKwoG9sMtqCMzAE1UVttCnjwxQvLruYd5m4lSkduUImZguCw4dyLcMJAj3FAJA/RyQwdgVgifK26NxnU+DCRhLuWoLEAB6u86k+hlugG/oFvHhK7w2HRKNV5Yd+U+3wuiTXepQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:21:30AM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/15/26 17:37, Gregory Price wrote:
> > 
> > One thought would be a way to switch what fallback list is used, and
> > then have specific fallback lists for certain contexts.
> > 
> > Right now there is a single example of this: __GFP_THISNODE
> >   |= __GFP_THISNODE   =>  NOFALLBACK
> >   &= ~__GFP_THISNODE  =>  FALLBACK
> > 
> > We could add an interface with the desired fallback list based as an
> > argument, and let get_page_from_freelist to prefer that over the default
> > global lists.
> 
> Does it mean a new argument in a number of functions in the page allocator,
> or can it be mapped to alloc_flags (at least internally?), because the
> number of possible fallback lists is small enough?
>

What I ended up with was adding a single page_alloc.c external interface
that allows you define the zonelist via an enum, and then an internal
selector resolution in prepare_alloc_pages() stored in alloc_context

eg:

static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
                int preferred_nid, nodemask_t *nodemask,
                struct alloc_context *ac, gfp_t *alloc_gfp,
                unsigned int *alloc_flags)
{       
        ac->highest_zoneidx = gfp_zone(gfp_mask);
        ac->zonelist = select_zonelist(preferred_nid, gfp_mask, ac->zlsel);
	... snip ...
}

struct folio *__folio_alloc_zonelist_noprof(gfp_t gfp, unsigned int order,
                int preferred_nid, nodemask_t *nodemask,
                enum alloc_zonelist zlsel);


The original __folio_alloc* functions just add a DEFAULT - which tells
select_zonelist() to base the decision on __GFP_THISNODE.


struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
                nodemask_t *nodemask)
{
        return __folio_alloc_core(gfp, order, preferred_nid, nodemask,
                                  ALLOC_ZONELIST_DEFAULT);
}
EXPORT_SYMBOL(__folio_alloc_noprof);


This does a few things
  - The isolation is structural, there is no way to accidentally
    allocate private memory without passing ALLOC_ZONELIST_PRIVATE

  - The isolation forces folios - there are no non-folio interfaces
    which allow zonelist selection

  - The zonelist selection is confined to this allocation context,
    so no inheritence is possible.



I tried to avoid using an ALLOC_ flag so we can avoid yet another flag
crunch, but there certainly are few enough zonelists that we could
encode it there and expose it.  I know Brendan was looking at plumbing
alloc flags out to an interface, so i'm open to that.

Externally the way I determine what zonelist to use is a lookup based on
reason - letting the node filter.  This is really only needed in a
couple spots:

mm/khugepaged.c:  enum alloc_zonelist zlsel = alloc_zonelist_for_node(node, NODE_ALLOC_RECLAIM);
mm/vmscan.c:      mtc->zlsel = alloc_zonelist_for_nodemask(mtc->nmask, NODE_ALLOC_TIERING);
mm/migrate.c:     .zlsel = alloc_zonelist_for_node(node, NODE_ALLOC_USER_MIGRATE),

static inline enum alloc_zonelist
alloc_zonelist_for_node(int nid, enum node_alloc_reason reason)
{
        bool ok;

        if (!node_state(nid, N_MEMORY_PRIVATE))
                return ALLOC_ZONELIST_DEFAULT;
        switch (reason) {
        case NODE_ALLOC_RECLAIM:
                ok = node_is_reclaimable(nid);
                break;
        case NODE_ALLOC_TIERING:
                ok = node_allows_tiering(nid);
                break;
        case NODE_ALLOC_USER_MIGRATE:
                ok = node_allows_user_migrate(nid);
                break;
        default:
                ok = false;
        }
        return ok ? ALLOC_ZONELIST_PRIVATE : ALLOC_ZONELIST_DEFAULT;
}

Otherwise... everything is now a mempolicy w/ MPOL_F_BIND and all the
handling goes through the normal fault-paths :]

static struct page *__alloc_pages_mpol(gfp_t gfp, unsigned int order,
                struct mempolicy *pol, pgoff_t ilx, int nid)
{
        nodemask_t *nodemask;
        struct page *page;
        enum alloc_zonelist zlsel = (pol->flags & MPOL_F_PRIVATE) ?
                ALLOC_ZONELIST_PRIVATE : ALLOC_ZONELIST_DEFAULT;
...
        if (pol->mode == MPOL_PREFERRED_MANY)
                return alloc_pages_preferred_many(gfp, order, nid, nodemask,
                                                  zlsel);
...
}


Switching to an alloc_flag would probably be trivially if that's really
wanted

~Gregory

