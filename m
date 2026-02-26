Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBD1EA4E22
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162306B009B; Mon,  2 Mar 2026 10:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117DE6B009E; Mon,  2 Mar 2026 10:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30A16B00A0; Mon,  2 Mar 2026 10:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDE326B009B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAC651C18C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:37 +0000 (UTC)
X-FDA: 84501568074.27.852368A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E5AD54000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1Q1ivTW;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OaBXJgsoo6WsLjg1YVuWoSTbF9JI3puRHeYj5Y9cYkA=;
	b=JYpla1ejDlMzFQhqppFqazND5fy7f/hXsEeQMtINdO0pkPB6jVYXgfDM9gGZRrnmbo8z6m
	HnE7Zoe9L1Jo02sqGTRhYQPAdlwwhMsntmsbNLlw43IMabDPfUxqgjQ63nXZdQrCbLFOFK
	QuqAZS3Xjtlib0WRWRSl28Yo5iAtWXY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1Q1ivTW;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466816; a=rsa-sha256;
	cv=none;
	b=8pgo0av43GfBt19CYEVMHOn1lbXng+zy7//x8XQp8mSa15dR4bnVLg6erQm0DNz+a2rbrh
	CSjZWMN1kgfzXzTlCCh40AZIT0X/PZFszH2HSUux5koqZJkigSMFNHimap/N3t+pyQytuW
	I4QKt47XCXyKbtZPB8UwslbH0HfXUu8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OaBXJgsoo6WsLjg1YVuWoSTbF9JI3puRHeYj5Y9cYkA=;
	b=Y1Q1ivTW6ckLsEGQXrkEkwD+8I/hZlk2dOQp+g39oYj97tjJID9UBgROnYj4t5+f/W71UG
	NLEEa86VX7X0KIS6xMUgrNW3bfStjH/4uPP2scaaEtCx/viwBeewIDeHeaq71yqtFsUI99
	1Dv5W+MooROtjRptkLlDhLf6gnJgcPY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-vTipCNljPmCj4_eeQjf37g-1; Mon,
 02 Mar 2026 10:53:29 -0500
X-MC-Unique: vTipCNljPmCj4_eeQjf37g-1
X-Mimecast-MFC-AGG-ID: vTipCNljPmCj4_eeQjf37g_1772466807
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E76011800267;
	Mon,  2 Mar 2026 15:53:26 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F51019560AD;
	Mon,  2 Mar 2026 15:53:26 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 40058401E0C28; Thu, 26 Feb 2026 15:24:29 -0300 (-03)
Date: Thu, 26 Feb 2026 15:24:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Michal Hocko <mhocko@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aaCP3V64INRZiZUH@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZiRAa6uf4KhscJC@tpad>
 <aZiSHT5DwIZwc/cH@tpad>
 <1fd2efef-888b-4d3c-9c72-bdb2d594336f@suse.com>
MIME-Version: 1.0
In-Reply-To: <1fd2efef-888b-4d3c-9c72-bdb2d594336f@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: CLg9LlUqBAbisgy1B3HnbdBy-XWegSaH5NBgYX4pRkI_1772466807
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E5AD54000A
X-Stat-Signature: cu9c5mjaj3zggsd844iqdujeesgqeuc3
X-Rspam-User: 
X-HE-Tag: 1772466815-589444
X-HE-Meta: U2FsdGVkX1+qJqV07T1khgnoQrDjaurY6BaocUQ8ocSMA22XkSZDXInxTqxSm6jf6fxnP2joXtT+gD2rIrR7lTiAFsgMISZCmf0sDT3YP5bH/JgBCbB5RvFm0fP6aBzus8n2P5sy55WQqUiEi5Dftguc5YyQA5j8u7vX5TmVz8lvZsFUN6Fkc/DKuw1EEtyNavwpFVUOpXHBnaBAjHkx4VuRFWGXfdXd8dyI3+R9RRVJU6nabAojSI2rdzZmtfxmy8Bltts552vAGUGeyKEOn/ACSA5bQubGccWIiFQ8UiC57upOeR840ClCbIDMO0awlM01ZEsvQL8sr2WlCTkiFWPI8RYHqh0Pcag8vVuIWnoAf9f6dDZ03LJv32EJXlSmyy2Xj9W6b8mZd1KrD4JTPtAHp7Oi0Cy2jpiMiFKMWPpxmKhusO2Km1/3UwGjZMU4sqiIcH9rW28h8QckXuf1BXK31JGEjcVt/uOzOtOXjPOxyVB6wwcz9Ixe/6i0rYFx/B9wZLzTNMZ4+ztQRvOq+HQ8uvOFyv5XqYGCd+L/yRG5NF/pMWynZeUISJjVAlD6p4x4DHzfZi2AP/lph6ogYwejxinBeTJf+2vM8dIZpn06MZZEc27CTKJr/E1jsCxPKC1S3IBYJF/skDgnbAPISSWCK7J1Mf8ryHBUnkYT3Zn6ffVRpYEr0YUEmW8NovN/0x7DS9hMU4BmgpMeDERRdtLZGGblwoj5oO1NyLuRmLpUwyYI6u54X+UIN3tnm3aCJtc9/lIAYsiJjI49cSYgCa1K33TihfOClVJdzcDiMHoPsnbRgsaQQLXB2Wf7APQbyDK8otStRnHCntGpjCOOIgQqulYyzkNOxAgFnUZQPolIncdmAbvaYfBqN68H23mi1o8C3u+qdlg9/bbLSY1M8rBYEL8sV6b4huF8Oydy1wcdjXfl5/cio5tcRuEpUCrUZdgAh6/B2gcbTzE/qii
 DhLNXks0
 NKz3oO38TqoAA3WRKhWT0iKh9AXFvLYYVsHz17PHiKak51EELEqSAK/WGAaPG6uIYJHw1QWt09HyxZ2VcqNVoAJEpNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 07:09:47PM +0100, Vlastimil Babka wrote:
> On 2/20/26 17:55, Marcelo Tosatti wrote:
> > 
> > #include <linux/module.h>
> > #include <linux/kernel.h>
> > #include <linux/slab.h>
> > #include <linux/timex.h>
> > #include <linux/preempt.h>
> > #include <linux/irqflags.h>
> > #include <linux/vmalloc.h>
> > 
> > MODULE_LICENSE("GPL");
> > MODULE_AUTHOR("Gemini AI");
> > MODULE_DESCRIPTION("A simple kmalloc performance benchmark");
> > 
> > static int size = 64; // Default allocation size in bytes
> > module_param(size, int, 0644);
> > 
> > static int iterations = 1000000; // Default number of iterations
> > module_param(iterations, int, 0644);
> > 
> > static int __init kmalloc_bench_init(void) {
> >     void **ptrs;
> >     cycles_t start, end;
> >     uint64_t total_cycles;
> >     int i;
> >     pr_info("kmalloc_bench: Starting test (size=%d, iterations=%d)\n", size, iterations);
> > 
> >     // Allocate an array to store pointers to avoid immediate kfree-reuse optimization
> >     ptrs = vmalloc(sizeof(void *) * iterations);
> >     if (!ptrs) {
> >         pr_err("kmalloc_bench: Failed to allocate pointer array\n");
> >         return -ENOMEM;
> >     }
> > 
> >     preempt_disable();
> >     start = get_cycles();
> > 
> >     for (i = 0; i < iterations; i++) {
> >         ptrs[i] = kmalloc(size, GFP_ATOMIC);
> >     }
> > 
> >     end = get_cycles();
> > 
> >     total_cycles = end - start;
> >     preempt_enable();
> 
> While preempt_disable() simplifies things, it can misrepresent the cost of
> preempt_disable() that's part of the locking - that will become nested and
> then the nested preempt_disable() is typically cheaper, etc.
> 
> Also the way it kmallocs all iterations and then kfree all iterations may
> skew the probabilities of fastpaths, cache hotness etc.
> 
> When introducing sheaves I had a similar microbenchmark, but there was
> different amounts of inner-loop iteraions, no outer preempt_disable(), and
> linear vs randomized array. See:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/commit/?h=slub-percpu-sheaves-v6-benchmarking&id=04028eeffba18a4f821a7194bc9d14f7488bd7d9
> 
> (at this point the SLUB_HAS_SHEAVES parts should be removed and the
> kmem_cache_print_stats() stuff also shouldn't be interesting for QPW
> evaluation).

Hi Vlastimil,

There is a problem which the numbers vary significantly across runs
(on the same kernel, system is idle, cpu is isolated).

SLUB_HAS_SHEAVES is not defined on my build. Just copied slub_kunit.c
from slub-percpu-sheaves-v6-benchmarking
to current tip (and dropped call to kmem_cache_print_stats).

1st run:
[  635.059928] average (excl. iter 0): 56571797
[  635.235206] average (excl. iter 0): 58329901
[  635.409957] average (excl. iter 0): 57459678
[  635.585128] average (excl. iter 0): 58268333
[  635.767325] average (excl. iter 0): 60063837
[  635.944534] average (excl. iter 0): 58912817
[  636.154503] average (excl. iter 0): 68992131
[  636.362533] average (excl. iter 0): 69030629
[  636.536737] average (excl. iter 0): 56545622
[  636.704314] average (excl. iter 0): 55536407
[  636.879097] average (excl. iter 0): 57397803
[  637.051157] average (excl. iter 0): 57021907
[  637.296352] average (excl. iter 0): 81582815
[  637.539810] average (excl. iter 0): 81126686

2nd run:
[  662.824688] average (excl. iter 0): 56833529
[  662.996742] average (excl. iter 0): 57145388
[  663.167063] average (excl. iter 0): 55828870
[  663.339814] average (excl. iter 0): 57505312
[  663.514563] average (excl. iter 0): 57374528
[  663.690328] average (excl. iter 0): 57282062
[  663.896128] average (excl. iter 0): 68097440
[  664.103029] average (excl. iter 0): 69263914
[  664.276497] average (excl. iter 0): 57073271
[  664.442210] average (excl. iter 0): 54895879
[  664.617186] average (excl. iter 0): 56972700
[  664.787353] average (excl. iter 0): 56457173
[  665.028944] average (excl. iter 0): 80339269
[  665.268597] average (excl. iter 0): 80371907

3rd run:
[  716.278750] average (excl. iter 0): 54191777
[  716.442014] average (excl. iter 0): 54151132
[  716.605254] average (excl. iter 0): 53148722
[  716.766461] average (excl. iter 0): 53204894
[  716.933339] average (excl. iter 0): 54719251
[  717.098761] average (excl. iter 0): 54922923
[  717.296178] average (excl. iter 0): 65351864
[  717.491440] average (excl. iter 0): 65264027
[  717.660778] average (excl. iter 0): 54370768
[  717.823625] average (excl. iter 0): 54137410
[  717.988983] average (excl. iter 0): 54222488
[  718.152716] average (excl. iter 0): 54339019
[  718.387978] average (excl. iter 0): 78249026
[  718.619598] average (excl. iter 0): 77746198

Increasing total parameter from 10^6 to 10^7 does
not help:

1st run:
[ 1074.601686] average (excl. iter 0): 650711901
[ 1076.450880] average (excl. iter 0): 633014260
[ 1078.363300] average (excl. iter 0): 660440649
[ 1080.266134] average (excl. iter 0): 652695083
[ 1082.117007] average (excl. iter 0): 635632144
[ 1084.009277] average (excl. iter 0): 654270513
[ 1086.286343] average (excl. iter 0): 790520038
[ 1088.512516] average (excl. iter 0): 768071705
[ 1090.448161] average (excl. iter 0): 664564330 
[ 1092.349683] average (excl. iter 0): 659016349 
[ 1094.274099] average (excl. iter 0): 662388982
[ 1096.172362] average (excl. iter 0): 647972747
[ 1098.753304] average (excl. iter 0): 887576313
[ 1101.339897] average (excl. iter 0): 885102019

2nd run:
[ 1120.186284] average (excl. iter 0): 615756734
[ 1122.019323] average (excl. iter 0): 623846524
[ 1123.885801] average (excl. iter 0): 639124895
[ 1125.693617] average (excl. iter 0): 623667563  
[ 1127.588515] average (excl. iter 0): 646441510  
[ 1129.410285] average (excl. iter 0): 628291996
[ 1131.542157] average (excl. iter 0): 728497604
[ 1133.698744] average (excl. iter 0): 743717953
[ 1135.514112] average (excl. iter 0): 616621660
[ 1137.306874] average (excl. iter 0): 615863807
[ 1139.110637] average (excl. iter 0): 616425899
[ 1140.948769] average (excl. iter 0): 638115570
[ 1143.426557] average (excl. iter 0): 847799304
[ 1145.914827] average (excl. iter 0): 861180802

Will switch back to the simple test (and its pretty obvious 
from the patch itself that if qpw=0 the overhead should 
be zero, and it is). Its numbers are more
stable across runs.


