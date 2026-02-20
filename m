Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8424C5ACD3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F9E6B008C; Fri, 20 Feb 2026 11:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3CE6B0092; Fri, 20 Feb 2026 11:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE956B0093; Fri, 20 Feb 2026 11:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE226B008C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:57:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBA271B450F
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:57:43 +0000 (UTC)
X-FDA: 84465441606.20.F99ACE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id F0634160006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:57:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bhZlI3iy;
	spf=pass (imf08.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771606662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVlPMF6mEVM5q0VRz5UF5IyvMK8+8R+3jexPuVtyib0=;
	b=tySFYuLXbLLE5TtApuIMlgJcP5iZIL5PaBmoJZJP+7WED2HnTDyCxEk/q/LdaK/WExfOg5
	nAvf7u8neM5bKUQ+rtKYtUYfys6wuq6IyO3eBtZHbKXEWYsfxZuVmwxRbOKXMR0u2ykAbD
	AJxiE6nDEtE1qV7iOS5+L2BPABSx7ao=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bhZlI3iy;
	spf=pass (imf08.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771606662; a=rsa-sha256;
	cv=none;
	b=zvJs2Vrp8a0QY933oAh7rrtSz6r7hkTVI7+qvqHz3prNiWP6i+FG6Bhd3WhU3EZlCHSQQn
	UIj7yHtiPnrcJ8JV7voqamNmOySWy6oTxj3wVvk2TpcR6gXHTdfx3fwzcrgLG0ph6tLEa5
	xy0GarRk7fdmG32/c3a/Rize5Fc5NlI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771606661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VVlPMF6mEVM5q0VRz5UF5IyvMK8+8R+3jexPuVtyib0=;
	b=bhZlI3iyEl21IF3QbgSxo1LiLt0ZflysnYT//ptaO+Im81rKXCxvSmyMhbJaHdYwpRzCV2
	jlGBXUVXFOEqQpqspGTyxa5+dlEYklNVf6CdrD+ldwiIvvNXK/L+2uOsrJ0EwXdN5ohvAT
	98VnR9dL3bF8rnh+wn2U78rqxCmto14=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-oubCWipYPzGnS0az61n1-A-1; Fri,
 20 Feb 2026 11:57:38 -0500
X-MC-Unique: oubCWipYPzGnS0az61n1-A-1
X-Mimecast-MFC-AGG-ID: oubCWipYPzGnS0az61n1-A_1771606655
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38B751956051;
	Fri, 20 Feb 2026 16:57:35 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B39E31800590;
	Fri, 20 Feb 2026 16:57:33 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B752A402754C9; Fri, 20 Feb 2026 13:55:57 -0300 (-03)
Date: Fri, 20 Feb 2026 13:55:57 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZiSHT5DwIZwc/cH@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZiRAa6uf4KhscJC@tpad>
MIME-Version: 1.0
In-Reply-To: <aZiRAa6uf4KhscJC@tpad>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: i2io17N3J8ujXSkhi81LCB4RuSBeJUYOP2iWLmoe2x8_1771606655
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0634160006
X-Stat-Signature: cgnq9mesqbi3dq88jnm3cpxowg4kkt8i
X-Rspam-User: 
X-HE-Tag: 1771606661-211271
X-HE-Meta: U2FsdGVkX1/PeuFuQlDFIlLpOW4qCSw775eI6Tqw+oIaKUEDczuQdQXTNgQ2ROQCOq5qBcvYPeWlxzmUA1MBdB8XRUYnJjp2QJn3aeMn2XG7tOkXFdH4ks5QiDMHC3OmxTi9jXm3+ZfPE9wW9s5Ik1iebRa3NeBN2PUuWCqwmMlH8wN9jp3kPVQ2UMEo8y2QhHPvCrKZCQH0JyeeUe35XyzPGuJG7x+T8sFx2wUcuDZx6gMBZ4fMlUuvzzgJkIWoCzlBo/w/jSY5EVLsprKsZZODvvTcB+2G48wLF1+wMk7xMmXVadSUZvbxweD+vEi692xmI01z0Fu2Mx2VFPQ/Ix+77C/7Sfr4VLRplPfxJPdTag8i5lWLqChXf9yTGlpMDBhw3bLcJxyDfrhcCswJQyF6Ae6dHqHD7VRZfw4qyyA3gro4XPdOhwolVVn9urLTsq6sQ0+sa5wfrNsS2nMN/wI6yvj04TbJ02phNve/95Ib1pRUp0ykPVDYXwhLXPJ28rv47LLYPinfLxisoEdsK4vx62M3oS9s5o2sCuSEaXjecKzKzCoP7SEPqVBMoSSUpq+4DfjwSaOQckb7Q1KszIS2mnj+WX7bNfpGqmaO0rfG8HZmVWPvKzq8xhwDOnX6tlSZ7JhdfpLiqW5FIHkUHjaYgKG66zUamkt+/w4Fe8V2TujBhsm0P7zMjdMLoJFumWNAqb3HLIWEqGKB7uiTK7uWVwqeSWcQynQ9hptjxbrOWbJpyR7Zuym6rEBOLfLhoUifWZZmi6eMbI4Wgz5oaAiIu5SCceXiw6nAEytsvqoZRXdNCserhDoUVqj0mJnEX3MCIT2iYbO2c9TVX5To0nZBtrmZ17rCqRL+mbERKiI8M27bWU7coBVoHTtchDM3WlxG/YtQtDq6OBhfUOaWJXeE0PC2XdRa/RoPVbz8h2MnU90kFVSKVZKiOk5mwV41iGsoqSoANoQpUlAvNd1
 CXQmRec6
 FgNFAWoEpvinL2SkBc7z0z2dhwh/IHel93iZk4oylJrxtHzz/opjAl9bX/vwewpk9X5pYe+OqBqhEavwjBgIZQYFq/FxGRN+e6TcFyqdQsroEpHDiuOSzaMyPgTh7CepBmQQ09r7VlMZ9+N+kAoXQIImRgt0Gs7sxNsFSSVat67uftGdX84nDTTwnEDCPhUABIU2XvNJT1nmNn4y3EPu2SuVxrR2v6EpAcNmNaf/xjC5OucpWoSyFHjHTn1S6NnmRYwdoQx8Q1geKtGmM9+sAbCVT74ZFRp3twPIuz4eBgeZnPPlBemLyWXtBcqGagGDr0skqrWDlOLKwGwv7hPsA8B3hN6QWQyeKLtcq/o+ljphtpbKpPHI6FgWAYpIsv7f66OffkRpY1sbkjpXCaSLeV3+27aM6NuSi6C+6ljVedS1MnDmYuPZfVFtvWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:51:13PM -0300, Marcelo Tosatti wrote:
> On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > [...]
> > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > configurations AFAICS.
> > > > > 
> > > > > Michal,
> > > > > 
> > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > 
> > > > My bad. I've misread the config space of this.
> > > > 
> > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > (and remote work via work_queue) is used.
> > > > > 
> > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > to happen before return to userspace changes things related 
> > > > > to avoidance of CPU interruption ?
> > > > 
> > > > Essentially delayed operations like pcp state flushing happens on return
> > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > the work is still per-cpu.
> > > > 
> > > > In other words the approach Frederic is working on is to not change the
> > > > locking of pcp delayed work but instead move that work into well defined
> > > > place - i.e. return to the userspace.
> > > > 
> > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > paths like SLUB sheeves?
> > > 
> > > Hi Michal,
> > > 
> > > I have done some study on this (which I presented on Plumbers 2023):
> > > https://lpc.events/event/17/contributions/1484/ 
> > > 
> > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > frequent, as per design of the current approach, we are not supposed to see 
> > > contention (I was not able to detect contention even after stress testing 
> > > for weeks), nor relevant cacheline bouncing.
> > > 
> > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > 
> > > The performance impact noticed was mostly about jumping around in 
> > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > 
> > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > enabled only if the user thinks this is an ok cost for reducing 
> > > interruptions.
> > > 
> > > What do you think?
> > 
> > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > do not expect the overhead to be really be really big. To me, a much
> > more important question is which of the two approaches is easier to
> > maintain long term. The pcp work needs to be done one way or the other.
> > Whether we want to tweak locking or do it at a very well defined time is
> > the bigger question.
> 
> Without patchset:
> ================
> 
> [ 1188.050725] kmalloc_bench: Avg cycles per kmalloc: 159
> 
> With qpw patchset, CONFIG_QPW=n:
> ================================
> 
> [   50.292190] kmalloc_bench: Avg cycles per kmalloc: 163
> 
> With qpw patchset, CONFIG_QPW=y, qpw=0:
> =======================================
> 
> [   29.872153] kmalloc_bench: Avg cycles per kmalloc: 170
> 
> 
> With qpw patchset, CONFIG_QPW=y, qpw=1:
> ========================================
> 
> [   37.494687] kmalloc_bench: Avg cycles per kmalloc: 190
> 
> With PREEMPT_RT enabled, qpw=0:
> ===============================
> 
> [   65.163251] kmalloc_bench: Avg cycles per kmalloc: 181
> 
> With PREEMPT_RT enabled, no patchset:
> =====================================
> [   52.701639] kmalloc_bench: Avg cycles per kmalloc: 185
> 
> With PREEMPT_RT enabled, qpw=1:
> ==============================
> 
> [   35.103830] kmalloc_bench: Avg cycles per kmalloc: 196

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/timex.h>
#include <linux/preempt.h>
#include <linux/irqflags.h>
#include <linux/vmalloc.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Gemini AI");
MODULE_DESCRIPTION("A simple kmalloc performance benchmark");

static int size = 64; // Default allocation size in bytes
module_param(size, int, 0644);

static int iterations = 1000000; // Default number of iterations
module_param(iterations, int, 0644);

static int __init kmalloc_bench_init(void) {
    void **ptrs;
    cycles_t start, end;
    uint64_t total_cycles;
    int i;
    pr_info("kmalloc_bench: Starting test (size=%d, iterations=%d)\n", size, iterations);

    // Allocate an array to store pointers to avoid immediate kfree-reuse optimization
    ptrs = vmalloc(sizeof(void *) * iterations);
    if (!ptrs) {
        pr_err("kmalloc_bench: Failed to allocate pointer array\n");
        return -ENOMEM;
    }

    preempt_disable();
    start = get_cycles();

    for (i = 0; i < iterations; i++) {
        ptrs[i] = kmalloc(size, GFP_ATOMIC);
    }

    end = get_cycles();

    total_cycles = end - start;
    preempt_enable();

    pr_info("kmalloc_bench: Total cycles for %d allocs: %llu\n", iterations, total_cycles);
    pr_info("kmalloc_bench: Avg cycles per kmalloc: %llu\n", total_cycles / iterations);

    // Cleanup
    for (i = 0; i < iterations; i++) {
        kfree(ptrs[i]);
    }
    vfree(ptrs);

    return 0;
}

static void __exit kmalloc_bench_exit(void) {
    pr_info("kmalloc_bench: Module unloaded\n");
}



